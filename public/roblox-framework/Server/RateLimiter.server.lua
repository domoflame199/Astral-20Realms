local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Config = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Config"))

local RateLimiter = {}
RateLimiter.__index = RateLimiter

local buckets = {}

local function now()
	return os.clock()
end

function RateLimiter:Init() end
function RateLimiter:Start()
	RunService.Heartbeat:Connect(function(dt)
		for _, d in pairs(buckets) do
			for key, info in pairs(d) do
				local elapsed = now() - info.t
				local refill = info.r * elapsed
				info.c = math.clamp(info.c + refill, 0, info.r)
				info.t = now()
			end
		end
	end)
end

local function getBucket(plr, key, rate)
	local d = buckets[plr] or {}
	buckets[plr] = d
	local b = d[key]
	if not b then
		b = { c = rate, r = rate, t = now() }
		d[key] = b
	end
	return b
end

function RateLimiter.Try(plr, key, rate)
	local b = getBucket(plr, key, rate)
	if b.c >= 1 then
		b.c -= 1
		return true
	end
	return false
end

return RateLimiter
