local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))

local Status = {}
Status.__index = Status

local active = {}

function Status:Init()
	Net.GetEvent("StatusApplied").OnClientEvent:Connect(function(name, duration)
		active[name] = duration and (tick() + duration) or math.huge
		print("Status applied:", name)
	end)
	Net.GetEvent("StatusCleared").OnClientEvent:Connect(function(name)
		active[name] = nil
		print("Status cleared:", name)
	end)
end

function Status:Start() end

return Status
