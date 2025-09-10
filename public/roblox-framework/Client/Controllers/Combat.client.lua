local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))

local Combat = {}
Combat.__index = Combat

function Combat:Init()
	local function onInputBegan(input, gp)
		if gp then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mouse = Players.LocalPlayer:GetMouse()
			local target = mouse.Target and mouse.Target.Parent and mouse.Target.Parent:FindFirstChildOfClass("Humanoid")
			Net.GetEvent("LightAttack"):FireServer(target, 10)
		end
	end
	UserInputService.InputBegan:Connect(onInputBegan)
end

function Combat:Start() end

return Combat
