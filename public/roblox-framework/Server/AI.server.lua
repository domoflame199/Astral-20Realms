local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Loot = require(script.Parent:WaitForChild("Loot"))
local Config = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Config"))
local Maid = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Maid"))
local Combat = require(script.Parent:WaitForChild("Combat"))
local PlayerData = require(script.Parent:WaitForChild("PlayerData"))

local AI = {}
AI.__index = AI

local NPC_FOLDER = Workspace:FindFirstChild("NPCs") or Instance.new("Folder", Workspace)
NPC_FOLDER.Name = "NPCs"

local function findHumanoid(root)
	if not root then return nil end
	local hum = root:FindFirstChildOfClass("Humanoid")
	if hum then return hum end
	for _,c in pairs(root:GetChildren()) do
		local h = c:FindFirstChildOfClass("Humanoid")
		if h then return h end
	end
	return nil
end

local active = {}

local function wanderTo(npc, root)
	local hrp = root:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local origin = hrp.Position
	local x = origin.X + math.random(-20,20)
	local z = origin.Z + math.random(-20,20)
	local goal = Vector3.new(x, origin.Y, z)
	local path = PathfindingService:CreatePath({ AgentRadius = 2, AgentHeight = 5 })
	path:ComputeAsync(origin, goal)
	local waypoints = path:GetWaypoints()
	for _,wp in ipairs(waypoints) do
		if root.Parent == nil then break end
		if hrp then
			root:PivotTo(CFrame.new(wp.Position))
			task.wait(0.6)
		end
	end
end

local function loopAI(npcModel, maid)
	local root = npcModel:FindFirstChild("HumanoidRootPart") and npcModel
	local hum = findHumanoid(npcModel)
	if not hum or not root then return end
	while npcModel.Parent and not (maid and maid._destroyed) do
		-- simple aggro: find nearest player within range
		local nearest, nd = nil, 9999
		for _, plr in pairs(game.Players:GetPlayers()) do
			local char = plr.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local d = (char.HumanoidRootPart.Position - root.HumanoidRootPart.Position).Magnitude
				if d < nd then nd = d; nearest = plr end
			end
		end
		if nearest and nd < 40 then
			-- chase
			local targetPos = nearest.Character and nearest.Character:FindFirstChild("HumanoidRootPart") and nearest.Character.HumanoidRootPart.Position
			if targetPos then
				local path = PathfindingService:CreatePath()
				path:ComputeAsync(root.HumanoidRootPart.Position, targetPos)
				local wps = path:GetWaypoints()
				for _,wp in ipairs(wps) do
					if not npcModel.Parent or (maid and maid._destroyed) then break end
					root:PivotTo(CFrame.new(wp.Position))
					task.wait(0.25)
				end
			end
			-- if close, perform melee (server-side authoritative)
			if nd < 4 and hum.Health > 0 then
				local attackPower = npcModel:GetAttribute("AttackPower") or 9
				Combat.ApplyDamage(npcModel, nearest.Character and nearest.Character:FindFirstChildOfClass("Humanoid"), attackPower, { range = 5 })
			end
		else
			-- wander
			wanderTo(npcModel, npcModel)
			task.wait(math.random(2,5))
		end
		task.wait(0.5)
	end
end

function AI.Spawn(template, position)
	local model = template:Clone()
	if model.PrimaryPart == nil then
		model.PrimaryPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
	end
	model:SetPrimaryPartCFrame(CFrame.new(position or Vector3.new(0,5,0)))
	model.Parent = NPC_FOLDER
	local maid = Maid.new()
	active[model] = maid
	spawn(function() loopAI(model, maid) end)
	-- death handler: award loot and XP to last attacker
	local hum = findHumanoid(model)
	if hum then
		maid:GiveTask(hum.Died:Connect(function()
			local lootTable = model:GetAttribute("LootTable") or string.lower(model.Name) or "goblin"
			local xpAmount = model:GetAttribute("XP") or 25
			local uid = hum:GetAttribute("LastAttackerUserId")
			local plr = nil
			if uid and type(uid) == "number" then
				plr = Players:GetPlayerByUserId(uid)
			end
			if plr then
				-- roll loot and award XP
				pcall(function()
					Loot.RollFor(plr, lootTable)
					PlayerData.AddXP(plr, xpAmount)
				end)
			end
		end))
	end
	-- cleanup when model removed
	maid:GiveTask(model.AncestryChanged:Connect(function()
		if not model:IsDescendantOf(game) then
			maid:Destroy()
			active[model] = nil
		end
	end))
	return model
end

function AI:Init()
	-- Remote spawn command for admin tools
	Net.GetEvent("NPCSpawn").OnServerEvent:Connect(function(plr, templateName, pos)
		local templates = Workspace:FindFirstChild("NPCTemplates")
		if not templates then return end
		local t = templates:FindFirstChild(templateName)
		if not t then return end
		AI.Spawn(t, pos and Vector3.new(pos.x, pos.y, pos.z) or nil)
	end)
end

function AI:Start() end

return AI
