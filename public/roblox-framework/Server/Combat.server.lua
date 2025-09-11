local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Config = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Config"))
local RateLimiter = require(script.Parent:WaitForChild("RateLimiter"))
local Status = require(script.Parent:WaitForChild("StatusEffects"))
local PlayerData = require(script.Parent:WaitForChild("PlayerData"))

local Combat = {}
Combat.__index = Combat

local cooldowns = {}
local function now() return os.clock() end

local function clampDamage(n)
	return math.clamp(n, Config.Combat.DamageClamp.Min, Config.Combat.DamageClamp.Max)
end

local function checkDistanceAndValidity(attacker, targetHumanoid, maxRange)
	if not targetHumanoid or not targetHumanoid.Parent then return false end
	local targetRoot = targetHumanoid.Parent:FindFirstChild("HumanoidRootPart")
	if not targetRoot then return false end
	if typeof(attacker) == "Instance" and attacker:IsA("Player") then
		local char = attacker.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
		local dist = (char.HumanoidRootPart.Position - targetRoot.Position).Magnitude
		if dist > (maxRange or 6) then return false end
	end
	-- allow server-side NPCs (attacker is model)
	if typeof(attacker) == "Instance" and attacker:IsA("Model") then
		local root = attacker:FindFirstChild("HumanoidRootPart")
		if root then
			local dist = (root.Position - targetRoot.Position).Magnitude
			if dist > (maxRange or 6) + 2 then return false end
		end
	end
	return true
end

function Combat.ApplyDamage(attacker, targetHumanoid, baseDamage, meta)
	-- attacker: Player instance or NPC model
	-- targetHumanoid: Humanoid instance
	-- meta: table with optional fields
	local dmg = clampDamage(tonumber(baseDamage) or 0)
	if dmg <= 0 then return false end

	-- Anti-cheat: extremely large damages are rejected and reported
	if dmg > 10000 then
		warn("Cheat detected: excessive damage", attacker, dmg)
		return false
	end

	-- Validate range and existence
	if not checkDistanceAndValidity(attacker, targetHumanoid, meta and meta.range) then
		warn("Combat validation failed: distance or invalid target", attacker)
		return false
	end

	-- cooldowns for players and NPCs
	local key
	if typeof(attacker) == "Instance" and attacker:IsA("Player") then
		key = "P_"..attacker.UserId
	elseif typeof(attacker) == "Instance" and attacker:IsA("Model") then
		key = attacker -- use instance as key
	else
		key = tostring(attacker)
	end
	local cd = cooldowns[key] or 0
	if now() < cd then
		warn("Combat cooldown violated by", attacker)
		return false
	end
	cooldowns[key] = now() + (meta and meta.cooldown or Config.Combat.GlobalCooldown or 0.25)

	-- apply damage server-side
	if targetHumanoid and targetHumanoid.Health > 0 then
		local final = math.floor(dmg)
		targetHumanoid:TakeDamage(final)
		-- tag last attacker for loot/xp attribution
		if typeof(attacker) == "Instance" and attacker:IsA("Player") then
			pcall(function()
				targetHumanoid:SetAttribute("LastAttackerUserId", attacker.UserId)
			end)
		end
		-- small chance to apply a status
		if math.random() < 0.08 then
			Status.Apply(attacker, "Bleeding", 4)
		end
		return true
	end
	return false
end

function Combat:Init()
	-- Client-initiated light attack: server validates then applies
	Net.GetEvent("LightAttack").OnServerEvent:Connect(function(plr, targetInstance, claimedDamage)
		if not RateLimiter.Try(plr, "LightAttack", Config.Networking.RateLimits.LightAttack) then return end
		-- ensure target is valid instance
		if typeof(targetInstance) ~= "Instance" then return end
		local hum = targetInstance
		if not hum:IsA("Humanoid") then
			local alt = targetInstance:FindFirstChildWhichIsA and targetInstance:FindFirstChildWhichIsA("Humanoid")
			if alt then hum = alt end
		end
		if not hum then return end
		-- server authoritative apply
		Combat.ApplyDamage(plr, hum, claimedDamage or 0, { range = 6, cooldown = Config.Combat.GlobalCooldown })
	end)
end

function Combat:Start() end

return Combat
