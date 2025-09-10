local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Config = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Config"))
local RateLimiter = require(script.Parent:WaitForChild("RateLimiter"))
local Status = require(script.Parent:WaitForChild("StatusEffects"))
local PlayerData = require(script.Parent:WaitForChild("PlayerData"))

local Combat = {}
Combat.__index = Combat

local function clampDamage(n)
	return math.clamp(n, Config.Combat.DamageClamp.Min, Config.Combat.DamageClamp.Max)
end

function Combat:Init()
	Net.GetEvent("LightAttack").OnServerEvent:Connect(function(plr, targetHumanoid, baseDamage)
		if not RateLimiter.Try(plr, "LightAttack", Config.Networking.RateLimits.LightAttack) then return end
		local hum = targetHumanoid
		if typeof(hum) == "Instance" and hum:IsA("Humanoid") and hum.Health > 0 then
			local dmg = clampDamage(tonumber(baseDamage) or 0)
			hum:TakeDamage(dmg)
			if math.random() < 0.1 then
				Status.Apply(plr, "Blessed", 3)
			end
		end
	end)
end

function Combat:Start() end

return Combat
