local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))

local Status = {}
Status.__index = Status

local active = {}

local function ensure(plr)
	local s = active[plr]
	if not s then s = {}; active[plr] = s end
	return s
end

function Status:Init() end
function Status:Start()
	RunService.Heartbeat:Connect(function(dt)
		for plr, map in pairs(active) do
			for name, info in pairs(map) do
				if info.t and tick() >= info.t then
					map[name] = nil
					Net.GetEvent("StatusCleared"):FireClient(plr, name)
				end
			end
		end
	end)
end

function Status.Apply(plr, name, duration)
	local map = ensure(plr)
	map[name] = { t = duration and (tick() + duration) or nil }
	Net.GetEvent("StatusApplied"):FireClient(plr, name, duration)
end

function Status.Clear(plr, name)
	local map = ensure(plr)
	map[name] = nil
	Net.GetEvent("StatusCleared"):FireClient(plr, name)
end

return Status
