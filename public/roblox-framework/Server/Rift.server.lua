local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local AI = require(script.Parent:WaitForChild("AI"))
local PlayerData = require(script.Parent:WaitForChild("PlayerData"))

local Rift = {}
Rift.__index = Rift

local RIFT_USE_RANGE = 10
local MAX_ACTIVE_PER_PLAYER = 1

local active = {} -- plr -> { riftPart, waveIndex, waves, spawned, remaining }

local function findNearestRift(hrp)
	local nearest, nd
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj.Name == "Rift" and (obj:IsA("BasePart") or obj:IsA("Model")) then
			local part = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
			if part then
				local d = (part.Position - hrp.Position).Magnitude
				if not nd or d < nd then nd = d; nearest = part end
			end
		end
	end
	return nearest, nd or math.huge
end

local function onMobDied(plr, state)
	state.remaining = math.max((state.remaining or 1) - 1, 0)
	Net.GetEvent("RiftStatus"):FireClient(plr, { type = "progress", wave = state.waveIndex, remaining = state.remaining })
	if state.remaining <= 0 then
		-- next wave or complete
		state.waveIndex += 1
		if state.waveIndex > #state.waves then
			-- complete
			PlayerData.AddXP(plr, 200)
			PlayerData.AddGold(plr, 150)
			Net.GetEvent("RiftStatus"):FireClient(plr, { type = "complete" })
			active[plr] = nil
			return
		end
		-- start next
		local wave = state.waves[state.waveIndex]
		state.spawned = {}
		state.remaining = wave.count
		Net.GetEvent("RiftStatus"):FireClient(plr, { type = "wave", wave = state.waveIndex, total = state.remaining })
		local templates = Workspace:FindFirstChild("NPCTemplates")
		local tmpl = templates and templates:FindFirstChild(wave.template or "Goblin")
		for i = 1, wave.count do
			local pos = state.riftPart.Position + Vector3.new(math.random(-10,10), 0, math.random(-10,10))
			local model = tmpl and AI.Spawn(tmpl, pos)
			if model then
				local hum = model:FindFirstChildOfClass("Humanoid") or model:FindFirstChildWhichIsA("Humanoid")
				if hum then
					hum.Died:Connect(function()
						onMobDied(plr, state)
					end)
				end
				state.spawned[model] = true
			end
		end
	end
end

local function beginRift(plr, riftPart)
	-- simple two-wave encounter
	local waves = {
		{ template = "Goblin", count = 4 },
		{ template = "Goblin", count = 6 },
	}
	local state = { riftPart = riftPart, waveIndex = 0, waves = waves, spawned = {}, remaining = 0 }
	active[plr] = state
	Net.GetEvent("RiftStatus"):FireClient(plr, { type = "entered" })
	onMobDied(plr, state) -- this call advances to wave 1 and spawns
end

function Rift:Init()
	Net.GetFunction("EnterRift").OnServerInvoke = function(plr)
		if active[plr] then return { success = false, error = "AlreadyInRift" } end
		local char = plr.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then return { success = false, error = "NoCharacter" } end
		local part, dist = findNearestRift(hrp)
		if not part or dist > RIFT_USE_RANGE then return { success = false, error = "NoRiftNearby" } end
		beginRift(plr, part)
		return { success = true }
	end

	Net.GetFunction("ExitRift").OnServerInvoke = function(plr)
		if active[plr] then
			active[plr] = nil
			Net.GetEvent("RiftStatus"):FireClient(plr, { type = "exited" })
			return { success = true }
		end
		return { success = false, error = "NotInRift" }
	end
end

function Rift:Start() end

return Rift
