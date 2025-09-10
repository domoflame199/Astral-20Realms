local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))

local Matchmaking = {}
Matchmaking.__index = Matchmaking

local parties = {}

local function createParty(leader)
	parties[leader.UserId] = { leader = leader, members = { [leader] = true } }
	return parties[leader.UserId]
end

function Matchmaking:Init()
	local ev = Net.GetEvent("PartyInvite")
	ev.OnServerEvent:Connect(function(plr, target)
		if typeof(target) ~= "Instance" or not target:IsA("Player") then return end
		local p = parties[plr.UserId] or createParty(plr)
		p.members[target] = true
		Net.GetEvent("PartyJoined"):FireClient(target, plr)
	end)
end

function Matchmaking:Start() end

return Matchmaking
