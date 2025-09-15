local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local root = ReplicatedStorage:WaitForChild("AstralFramework")
local Net = require(root:WaitForChild("Shared"):WaitForChild("Net"))

local Quests = {}
Quests.__index = Quests

local function makeText(parent, name, text, size, pos, color)
	local l = Instance.new("TextLabel")
	l.Name = name
	l.BackgroundTransparency = 1
	l.Size = size
	l.Position = pos
	l.Text = text or ""
	l.TextColor3 = color or Color3.fromRGB(235,235,245)
	l.Font = Enum.Font.SourceSans
	l.TextSize = 16
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = parent
	return l
end

local function makeButton(parent, name, text, size, pos, onClick)
	local b = Instance.new("TextButton")
	b.Name = name
	b.Size = size
	b.Position = pos
	b.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
	b.AutoButtonColor = true
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 16
	b.Text = text
	b.Parent = parent
	b.MouseButton1Click:Connect(function()
		if typeof(onClick) == "function" then onClick() end
	end)
	return b
end

local function makeList(parent)
	local sf = Instance.new("ScrollingFrame")
	sf.Size = UDim2.new(1, -12, 1, -12)
	sf.Position = UDim2.new(0, 6, 0, 6)
	sf.CanvasSize = UDim2.new(0, 0, 0, 0)
	sf.ScrollBarThickness = 6
	sf.BackgroundTransparency = 0.1
	sf.BackgroundColor3 = Color3.fromRGB(30,30,45)
	sf.BorderSizePixel = 0
	sf.Parent = parent
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, 6)
	layout.Parent = sf
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		sf.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
	end)
	return sf
end

function Quests:Init()
	self.player = Players.LocalPlayer
	self.playerGui = self.player:WaitForChild("PlayerGui")
	self.getQuests = Net.GetFunction("GetQuests")
	self.acceptQuest = Net.GetFunction("AcceptQuest")
	self.abandonQuest = Net.GetFunction("AbandonQuest")
	self.turnInQuest = Net.GetFunction("TurnInQuest")

	self.gui = Instance.new("ScreenGui")
	self.gui.Name = "QuestsUI"
	self.gui.ResetOnSpawn = false
	self.gui.Enabled = false
	self.gui.Parent = self.playerGui

	local frame = Instance.new("Frame")
	frame.Name = "Root"
	frame.Size = UDim2.new(0, 520, 0, 420)
	frame.Position = UDim2.new(0.5, -260, 0.5, -210)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
	frame.BorderSizePixel = 0
	frame.Parent = self.gui

	makeText(frame, "Title", "Quests (N)", UDim2.new(1, -12, 0, 28), UDim2.new(0, 6, 0, 6), Color3.new(1,1,1))

	local lists = Instance.new("Frame")
	lists.Size = UDim2.new(1, -12, 1, -48)
	lists.Position = UDim2.new(0, 6, 0, 36)
	lists.BackgroundTransparency = 1
	lists.Parent = frame

	local left = Instance.new("Frame")
	left.Size = UDim2.new(0.5, -3, 1, 0)
	left.BackgroundTransparency = 1
	left.Parent = lists
	local right = Instance.new("Frame")
	right.Size = UDim2.new(0.5, -3, 1, 0)
	right.Position = UDim2.new(0.5, 6, 0, 0)
	right.BackgroundTransparency = 1
	right.Parent = lists

	self.catalogList = makeList(left)
	self.activeList = makeList(right)

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.N then
			self.gui.Enabled = not self.gui.Enabled
			if self.gui.Enabled then self:Refresh() end
		end
	end)

	Net.GetEvent("QuestUpdate").OnClientEvent:Connect(function()
		self:Refresh()
	end)
end

function Quests:Refresh()
	local ok, data = pcall(function() return self.getQuests:InvokeServer() end)
	if not ok or type(data) ~= "table" then return end
	self:BuildCatalog(data)
	self:BuildActive(data)
end

local function objText(q, active)
	local parts = {}
	if q.objectives and q.objectives.kill then
		for npc, need in pairs(q.objectives.kill) do
			local have = 0
			if active and active.kills then have = active.kills[npc] or 0 end
			table.insert(parts, ("Kill %s: %d/%d"):format(npc, have, need))
		end
	end
	if q.objectives and q.objectives.collect then
		for item, need in pairs(q.objectives.collect) do
			table.insert(parts, ("Collect %s: %d required"):format(item, need))
		end
	end
	return table.concat(parts, "  |  ")
end

function Quests:BuildCatalog(data)
	for _, c in ipairs(self.catalogList:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
	local completed = data.completed or {}
	local active = data.active or {}
	for _, q in ipairs(data.catalog or {}) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -6, 0, 72)
		row.BackgroundColor3 = Color3.fromRGB(22,22,34)
		row.BorderSizePixel = 0
		row.Parent = self.catalogList
		makeText(row, "Name", q.name, UDim2.new(1, -12, 0, 20), UDim2.new(0, 6, 0, 4))
		makeText(row, "Desc", q.description, UDim2.new(1, -12, 0, 18), UDim2.new(0, 6, 0, 24), Color3.fromRGB(200,200,220))
		makeText(row, "Obj", objText(q, active[q.id]), UDim2.new(1, -12, 0, 18), UDim2.new(0, 6, 0, 44), Color3.fromRGB(220,220,240))
		local disabled = completed[q.id] or active[q.id]
		local btn = makeButton(row, "Accept", disabled and "Accepted" or "Accept", UDim2.new(0, 84, 0, 28), UDim2.new(1, -92, 0, 22), function()
			self:Accept(q.id)
		end)
		btn.AutoButtonColor = not disabled
		btn.BackgroundColor3 = disabled and Color3.fromRGB(70,70,70) or Color3.fromRGB(70,110,70)
	end
end

function Quests:BuildActive(data)
	for _, c in ipairs(self.activeList:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
	for questId, state in pairs(data.active or {}) do
		local q
		for _, qq in ipairs(data.catalog or {}) do if qq.id == questId then q = qq break end end
		if q then
			local row = Instance.new("Frame")
			row.Size = UDim2.new(1, -6, 0, 72)
			row.BackgroundColor3 = Color3.fromRGB(22,22,34)
			row.BorderSizePixel = 0
			row.Parent = self.activeList
			makeText(row, "Name", q.name, UDim2.new(1, -12, 0, 20), UDim2.new(0, 6, 0, 4))
			makeText(row, "Obj", objText(q, state), UDim2.new(1, -12, 0, 18), UDim2.new(0, 6, 0, 24), Color3.fromRGB(220,220,240))
			local turnIn = makeButton(row, "TurnIn", "Turn In", UDim2.new(0, 84, 0, 28), UDim2.new(1, -92, 0, 22), function()
				self:TurnIn(q.id)
			end)
			turnIn.BackgroundColor3 = Color3.fromRGB(90,90,130)
		end
	end
end

function Quests:Accept(id)
	local ok, res = pcall(function() return self.acceptQuest:InvokeServer(id) end)
	if ok and res and res.success then self:Refresh() end
end

function Quests:TurnIn(id)
	local ok, res = pcall(function() return self.turnInQuest:InvokeServer(id) end)
	if ok and res and res.success then self:Refresh() end
end

function Quests:Start() end

return Quests
