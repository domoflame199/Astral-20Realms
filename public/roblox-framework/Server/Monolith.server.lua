local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Traits = require(script.Parent:WaitForChild("Traits"))

local Monolith = {}
Monolith.__index = Monolith

function Monolith:Init()
	Net.GetEvent("MonolithAttune").OnServerEvent:Connect(function(plr)
		local granted = Traits.RandomAttunement(plr)
		if granted and #granted > 0 then
			Net.GetEvent("StatusApplied"):FireClient(plr, "Blessed", 5)
		end
	end)
end

function Monolith:Start() end

return Monolith
