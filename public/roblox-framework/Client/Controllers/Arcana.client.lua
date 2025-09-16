local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))

local Arcana = {}
Arcana.__index = Arcana

local function spawnLocalBolt(name, origin, dir)
	local part = Instance.new("Part")
	part.Name = name .. "_VFX"
	part.Shape = Enum.PartType.Ball
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(255, 160, 90)
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 0.15
	part.Size = Vector3.new(0.6, 0.6, 0.6)
	part.CFrame = CFrame.new(origin)
	part.Parent = workspace
	local speed = 120
	local lifetime = 0.5
	local start = tick()
	local conn
	conn = RunService.RenderStepped:Connect(function(dt)
		local elapsed = tick() - start
		if elapsed > lifetime then
			if conn then conn:Disconnect() end
			part:Destroy()
			return
		end
		part.CFrame = part.CFrame + (dir * speed * dt)
	end)
end

function Arcana:Init()
	local casting = false
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.Q and not casting then
			casting = true
			local plr = Players.LocalPlayer
			local char = plr.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local mouse = plr:GetMouse()
			if hrp and mouse and mouse.Hit then
				local origin = hrp.Position + Vector3.new(0, 1.5, 0)
				local dir = (mouse.Hit.Position - origin)
				if dir.Magnitude > 0 then dir = dir.Unit end
				Net.GetEvent("CastAbility"):FireServer("Blazing Bolt", { origin = origin, direction = dir })
			end
			task.delay(0.25, function() casting = false end)
		end
	end)

	Net.GetEvent("CastAbility").OnClientEvent:Connect(function(name, caster, origin, direction)
		if typeof(origin) == "Vector3" and typeof(direction) == "Vector3" then
			spawnLocalBolt(name, origin, direction.Unit)
		end
	end)
end

function Arcana:Start() end

return Arcana
