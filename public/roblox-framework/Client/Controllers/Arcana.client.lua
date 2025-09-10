local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))

local Arcana = {}
Arcana.__index = Arcana

function Arcana:Init()
	local casting = false
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.Q and not casting then
			casting = true
			local mouse = Players.LocalPlayer:GetMouse()
			local origin = mouse.Hit.Position
			local dir = mouse.Hit.LookVector
			Net.GetEvent("CastAbility"):FireServer("Blazing Bolt", { origin = origin, direction = dir })
			task.delay(0.25, function() casting = false end)
		end
	end)

	Net.GetEvent("CastAbility").OnClientEvent:Connect(function(name, caster, origin, direction)
		print("Ability cast:", name, caster and caster.Name)
	end)
end

function Arcana:Start() end

return Arcana
