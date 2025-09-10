local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Config = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Config"))
local RateLimiter = require(script.Parent:WaitForChild("RateLimiter"))

local Arcana = {}
Arcana.__index = Arcana

local cooldowns = {}

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

local function castFireball(caster, origin, direction)
	-- Example server-authoritative projectile spawn event
	Net.GetEvent("CastAbility"):FireAllClients("Fireball", caster, origin, direction)
end

function Arcana:Init()
	Net.GetEvent("CastAbility").OnServerEvent:Connect(function(plr, ability, payload)
		if not RateLimiter.Try(plr, "CastAbility", Config.Networking.RateLimits.CastAbility) then return end
		if not ready(plr, ability, Config.Combat.GlobalCooldown) then return end
		if ability == "Blazing Bolt" or ability == "Spark Touch" then
			local origin = payload and payload.origin or nil
			local dir = payload and payload.direction or nil
			castFireball(plr, origin, dir)
		end
	end)
end

function Arcana:Start() end

return Arcana
