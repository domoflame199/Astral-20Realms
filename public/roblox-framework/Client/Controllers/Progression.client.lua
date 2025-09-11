local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local root = ReplicatedStorage:WaitForChild("AstralFramework")
local Net = require(root:WaitForChild("Shared"):WaitForChild("Net"))

local Progression = {}
Progression.__index = Progression

local POLL_INTERVAL = 5

local function xpToLevel(level)
	return 100 * level
end

function Progression:Init()
	self.player = Players.LocalPlayer
	self.playerGui = self.player:WaitForChild("PlayerGui")
	self.getProfile = Net.GetFunction("GetProfile")
	self.lastProfile = nil

	-- build UI
	self.gui = Instance.new("ScreenGui")
	self.gui.Name = "ProgressionUI"
	self.gui.ResetOnSpawn = false
	self.gui.Parent = self.playerGui

	local frame = Instance.new("Frame")
	frame.Name = "ProgressionFrame"
	frame.AnchorPoint = Vector2.new(0, 0)
	frame.Position = UDim2.new(0.02, 0, 0.02, 0)
	frame.Size = UDim2.new(0, 220, 0, 54)
	frame.BackgroundTransparency = 0.25
	frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	frame.BorderSizePixel = 0
	frame.Parent = self.gui

	local levelLabel = Instance.new("TextLabel")
	levelLabel.Name = "LevelLabel"
	levelLabel.Size = UDim2.new(0, 64, 1, 0)
	levelLabel.Position = UDim2.new(0, 6, 0, 6)
	levelLabel.BackgroundTransparency = 1
	levelLabel.TextColor3 = Color3.new(1,1,1)
	levelLabel.Font = Enum.Font.SourceSansBold
	levelLabel.TextSize = 18
	levelLabel.TextXAlignment = Enum.TextXAlignment.Left
	levelLabel.Text = "Lv 1"
	levelLabel.Parent = frame

	local xpBg = Instance.new("Frame")
	xpBg.Name = "XPBackground"
	xpBg.Size = UDim2.new(1, -76, 0, 20)
	xpBg.Position = UDim2.new(0, 70, 0, 14)
	xpBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	xpBg.BorderSizePixel = 0
	xpBg.Parent = frame

	local xpFill = Instance.new("Frame")
	xpFill.Name = "XPFill"
	xpFill.Size = UDim2.new(0, 0, 1, 0)
	xpFill.Position = UDim2.new(0, 0, 0, 0)
	xpFill.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
	xpFill.BorderSizePixel = 0
	xpFill.Parent = xpBg

	local xpText = Instance.new("TextLabel")
	xpText.Name = "XPText"
	xpText.Size = UDim2.new(1, 0, 1, 0)
	xpText.BackgroundTransparency = 1
	xpText.TextColor3 = Color3.fromRGB(230,230,255)
	xpText.Font = Enum.Font.SourceSans
	xpText.TextSize = 14
	xpText.Parent = xpBg

	self.levelLabel = levelLabel
	self.xpFill = xpFill
	self.xpText = xpText

	-- events
	Net.GetEvent("PlayerLeveled").OnClientEvent:Connect(function(newLevel)
		-- simple level up popup
		self.levelLabel.Text = "Lv " .. tostring(newLevel)
		local tl = Instance.new("TextLabel")
		tl.Size = UDim2.new(0, 200, 0, 30)
		tl.Position = UDim2.new(0.5, -100, 0.5, -15)
		tl.AnchorPoint = Vector2.new(0.5, 0.5)
		tl.BackgroundTransparency = 0.5
		tl.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
		tl.TextColor3 = Color3.new(1, 0.9, 0.4)
		tl.Text = "Level Up! - " .. tostring(newLevel)
		tl.Font = Enum.Font.SourceSansBold
		tl.TextSize = 24
		tl.Parent = self.gui
		task.defer(function()
			task.wait(2)
			tl:Destroy()
		end)
	end)

	-- initial fetch
	spawn(function()
		while not self.getProfile do task.wait(0.2) end
		while true do
			local ok, profile = pcall(function() return self.getProfile:InvokeServer() end)
			if ok and type(profile) == "table" and profile.Stats then
				self.lastProfile = profile
				self:UpdateFromProfile(profile)
			end
			task.wait(POLL_INTERVAL)
		end
	end)
end

function Progression:UpdateFromProfile(profile)
	local stats = profile.Stats or {}
	local level = stats.Level or 1
	local xp = stats.XP or 0
	local need = xpToLevel(level)
	local pct = 0
	if need > 0 then pct = math.clamp(xp / need, 0, 1) end
	self.levelLabel.Text = "Lv " .. tostring(level)
	self.xpFill.Size = UDim2.new(pct, 0, 1, 0)
	self.xpText.Text = tostring(xp) .. " / " .. tostring(need)
end

function Progression:Start() end

return setmetatable(Progression, Progression)
