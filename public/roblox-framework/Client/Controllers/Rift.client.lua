local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local root = ReplicatedStorage:WaitForChild("AstralFramework")
local Net = require(root:WaitForChild("Shared"):WaitForChild("Net"))

local Rift = {}
Rift.__index = Rift

local USE_RANGE = 10
local SCAN_INTERVAL = 4

function Rift:Init()
	self.player = Players.LocalPlayer
	self.char = self.player.Character or self.player.CharacterAdded:Wait()
	self.root = self.char:FindFirstChild("HumanoidRootPart")
	self.lastScan = 0
	self.closest = nil
	self.enter = Net.GetFunction("EnterRift")
	self.exit = Net.GetFunction("ExitRift")

	self.gui = Instance.new("ScreenGui")
	self.gui.Name = "RiftUI"
	self.gui.ResetOnSpawn = false
	self.gui.Parent = self.player:WaitForChild("PlayerGui")

	self.prompt = Instance.new("TextLabel")
	self.prompt.Size = UDim2.new(0, 320, 0, 24)
	self.prompt.Position = UDim2.new(0.5, -160, 0.85, 0)
	self.prompt.AnchorPoint = Vector2.new(0.5, 0.5)
	self.prompt.BackgroundTransparency = 0.5
	self.prompt.BackgroundColor3 = Color3.fromRGB(20,20,30)
	self.prompt.TextColor3 = Color3.new(1,1,1)
	self.prompt.Text = ""
	self.prompt.Visible = false
	self.prompt.Parent = self.gui

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.R then
			if self.closest then
				local ok, res = pcall(function() return self.enter:InvokeServer() end)
				if ok and res and res.success then
					self:Toast("Entered Rift")
				else
					self:Toast("Cannot enter rift")
				end
			end
		elseif input.KeyCode == Enum.KeyCode.T then
			pcall(function() self.exit:InvokeServer() end)
		end
	end)

	Net.GetEvent("RiftStatus").OnClientEvent:Connect(function(msg)
		if type(msg) ~= "table" then return end
		if msg.type == "entered" then self:Toast("Rift opened") end
		if msg.type == "wave" then self:Toast("Wave "..tostring(msg.wave).." started") end
		if msg.type == "progress" then self:Toast("Remaining: "..tostring(msg.remaining)) end
		if msg.type == "complete" then self:Toast("Rift complete! Rewards granted") end
		if msg.type == "exited" then self:Toast("Rift exited") end
	end)
end

local function findNearestRift()
	local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil, math.huge end
	local nearest, nd
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name == "Rift" and (obj:IsA("BasePart") or obj:IsA("Model")) then
			local part = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
			if part then
				local d = (part.Position - hrp.Position).Magnitude
				if not nd or d < nd then nd = d; nearest = part end
			end
		end
	end
	return nearest, nd or math.huge
end

function Rift:Toast(text)
	local tl = Instance.new("TextLabel")
	tl.Size = UDim2.new(0, 260, 0, 28)
	tl.Position = UDim2.new(0.5, -130, 0.2, 0)
	tl.AnchorPoint = Vector2.new(0.5,0)
	tl.BackgroundTransparency = 0.4
	tl.BackgroundColor3 = Color3.fromRGB(30,30,50)
	tl.TextColor3 = Color3.new(1,1,1)
	tl.Font = Enum.Font.SourceSansBold
	tl.TextSize = 18
	tl.Text = text
	tl.Parent = self.gui
	task.delay(1.6, function() if tl then tl:Destroy() end end)
end

function Rift:Start()
	RunService.Heartbeat:Connect(function()
		local now = tick()
		if now - self.lastScan > SCAN_INTERVAL then
			self.closest = nil
			local part, dist = findNearestRift()
			if part and dist <= USE_RANGE then self.closest = part end
			self.lastScan = now
		end
		self.prompt.Visible = self.closest ~= nil
		if self.closest then
			self.prompt.Text = "Press R to enter Rift (T to exit)"
		end
	end)
end

return Rift
