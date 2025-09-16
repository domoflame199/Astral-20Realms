local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Config = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Config"))
local RateLimiter = require(script.Parent:WaitForChild("RateLimiter"))
local Combat = require(script.Parent:WaitForChild("Combat"))
local Status = require(script.Parent:WaitForChild("StatusEffects"))

local Arcana = {}
Arcana.__index = Arcana

local cooldowns = {}
local PROJECTILES = Workspace:FindFirstChild("Projectiles") or Instance.new("Folder", Workspace)
PROJECTILES.Name = "Projectiles"

local abilities = {
	["Blazing Bolt"] = {
		name = "Blazing Bolt",
		damage = 25,
		speed = 120,
		lifetime = 1.5,
		radius = 2.0,
		cooldown = 0.6,
		status = { name = "Burning", duration = 3 },
	},
	["Spark Touch"] = {
		name = "Spark Touch",
		damage = 15,
		speed = 90,
		lifetime = 1.2,
		radius = 1.6,
		cooldown = 0.45,
		status = { name = "Shocked", duration = 2 },
	},
}

local function now() return os.clock() end

local function ready(plr, key, cd)
	local map = cooldowns[plr]
	if not map then map = {}; cooldowns[plr] = map end
	local t = map[key] or 0
	if now() >= t then
		map[key] = now() + cd
		return true
	end
	return false
end

local function raycast(fromPos, toPos, ignore)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = ignore or {}
	return Workspace:Raycast(fromPos, toPos - fromPos, params)
end

local function findHumanoidFromInstance(inst)
	if not inst then return nil end
	if inst:IsA("Humanoid") then return inst end
	local parent = inst
	for _ = 1, 6 do
		if not parent then break end
		local h = parent:FindFirstChildOfClass("Humanoid")
		if h then return h end
		parent = parent.Parent
	end
	return nil
end

local function spawnProjectile(caster, abilityDef, origin, direction)
	if typeof(origin) ~= "Vector3" or typeof(direction) ~= "Vector3" then return end
	local dir = direction.Magnitude > 0 and direction.Unit or Vector3.new(1,0,0)
	local proj = Instance.new("Part")
	proj.Name = abilityDef.name .. "_Proj"
	proj.Shape = Enum.PartType.Ball
	proj.Material = Enum.Material.Neon
	proj.Color = Color3.fromRGB(255, 120, 60)
	proj.Anchored = true
	proj.CanCollide = false
	proj.Transparency = 0.2
	proj.Size = Vector3.new(abilityDef.radius, abilityDef.radius, abilityDef.radius)
	proj.CFrame = CFrame.new(origin)
	proj.Parent = PROJECTILES

	local ignore = { caster.Character, proj }
	local traveled = 0
	local maxDist = abilityDef.speed * abilityDef.lifetime
	local lastPos = origin
	local alive = true

	-- broadcast to clients for VFX
	Net.GetEvent("CastAbility"):FireAllClients(abilityDef.name, caster, origin, dir)

	local conn
	conn = RunService.Heartbeat:Connect(function(dt)
		if not alive then return end
		local step = abilityDef.speed * dt
		local nextPos = lastPos + dir * step
		local result = raycast(lastPos, nextPos, ignore)
		if result then
			local hit = result.Instance
			local hum = findHumanoidFromInstance(hit)
			proj.CFrame = CFrame.new(result.Position)
			alive = false
			if hum and hum.Health > 0 then
				Combat.ApplyDamage(caster, hum, abilityDef.damage, { range = 999, cooldown = 0 })
				if abilityDef.status then
					Status.Apply(caster, abilityDef.status.name, abilityDef.status.duration)
				end
			end
			proj:Destroy()
			if conn then conn:Disconnect() end
			return
		end
		traveled += step
		proj.CFrame = CFrame.new(nextPos)
		lastPos = nextPos
		if traveled >= maxDist then
			alive = false
			proj:Destroy()
			if conn then conn:Disconnect() end
		end
	end)
end

function Arcana:Init()
	Net.GetEvent("CastAbility").OnServerEvent:Connect(function(plr, ability, payload)
		if not RateLimiter.Try(plr, "CastAbility", Config.Networking.RateLimits.CastAbility) then return end
		local def = abilities[ability]
		if not def then return end
		if not ready(plr, ability, def.cooldown or Config.Combat.GlobalCooldown) then return end
		local origin = payload and payload.origin or nil
		local direction = payload and payload.direction or nil
		spawnProjectile(plr, def, origin, direction)
	end)
end

function Arcana:Start() end

return Arcana
