local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local root = ReplicatedStorage:WaitForChild("AstralFramework")
local Net = require(root:WaitForChild("Shared"):WaitForChild("Net"))
local Items = require(root:WaitForChild("Shared"):WaitForChild("Items"))

local Shop = {}
Shop.__index = Shop

local function makeText(parent, name, text, size, pos, anchor, color)
	local l = Instance.new("TextLabel")
	l.Name = name
	l.BackgroundTransparency = 1
	l.Size = size
	l.Position = pos
	l.AnchorPoint = anchor or Vector2.new()
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
	sf.Size = UDim2.new(1, -12, 1, -48)
	sf.Position = UDim2.new(0, 6, 0, 42)
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

local function fmtMaterials(mat)
	local t = {}
	for k, v in pairs(mat or {}) do table.insert(t, (tostring(k) .. ": " .. tostring(v))) end
	table.sort(t)
	return table.concat(t, ", ")
end

function Shop:Init()
	self.player = Players.LocalPlayer
	self.playerGui = self.player:WaitForChild("PlayerGui")
	self.getProfile = Net.GetFunction("GetProfile")
	self.shopBuy = Net.GetFunction("ShopBuy")
	self.requestShop = Net.GetFunction("RequestShop")
	self.craftItem = Net.GetFunction("CraftItem")
	self.profile = { Stats = { Gold = 0 }, Inventory = {} }
	self.catalog = {}

	-- build gui
	local gui = Instance.new("ScreenGui")
	gui.Name = "ShopCraftingUI"
	gui.ResetOnSpawn = false
	gui.Enabled = false
	gui.Parent = self.playerGui
	self.gui = gui

	local frame = Instance.new("Frame")
	frame.Name = "Root"
	frame.Size = UDim2.new(0, 520, 0, 420)
	frame.Position = UDim2.new(0.5, -260, 0.5, -210)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.Parent = gui

	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, -12, 0, 36)
	header.Position = UDim2.new(0, 6, 0, 6)
	header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
	header.BorderSizePixel = 0
	header.Parent = frame

	makeText(header, "Title", "Shop & Crafting", UDim2.new(1, -120, 1, 0), UDim2.new(0, 10, 0, 0), Vector2.new(), Color3.new(1,1,1))
	self.goldLabel = makeText(header, "Gold", "Gold: 0", UDim2.new(0, 120, 1, 0), UDim2.new(1, -120, 0, 0), Vector2.new(), Color3.fromRGB(255, 222, 100))

	local tabs = Instance.new("Frame")
	tabs.Name = "Tabs"
	tabs.Size = UDim2.new(1, -12, 1, -54)
	tabs.Position = UDim2.new(0, 6, 0, 48)
	tabs.BackgroundTransparency = 1
	tabs.Parent = frame

	self.shopTabBtn = makeButton(tabs, "ShopTab", "Shop", UDim2.new(0, 120, 0, 30), UDim2.new(0, 0, 0, 0), function() self:ShowTab("shop") end)
	self.craftTabBtn = makeButton(tabs, "CraftTab", "Crafting", UDim2.new(0, 120, 0, 30), UDim2.new(0, 126, 0, 0), function() self:ShowTab("craft") end)

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, 0, 1, -36)
	content.Position = UDim2.new(0, 0, 0, 36)
	content.BackgroundTransparency = 1
	content.Parent = tabs
	self.content = content

	-- shop view
	local shopView = Instance.new("Frame")
	shopView.Name = "ShopView"
	shopView.Size = UDim2.new(1, 0, 1, 0)
	shopView.BackgroundTransparency = 1
	shopView.Visible = true
	shopView.Parent = content
	self.shopList = makeList(shopView)

	-- crafting view
	local craftView = Instance.new("Frame")
	craftView.Name = "CraftView"
	craftView.Size = UDim2.new(1, 0, 1, 0)
	craftView.BackgroundTransparency = 1
	craftView.Visible = false
	craftView.Parent = content
	self.craftList = makeList(craftView)

	-- keybinds
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.B then
			self.gui.Enabled = not self.gui.Enabled
			if self.gui.Enabled then self:RefreshAll() end
		end
	end)

	-- initial data
	self:RefreshAll()
end

function Shop:ShowTab(which)
	local shopOn = which == "shop"
	self.content.ShopView.Visible = shopOn
	self.content.CraftView.Visible = not shopOn
	self.shopTabBtn.BackgroundColor3 = shopOn and Color3.fromRGB(90,90,120) or Color3.fromRGB(70,70,90)
	self.craftTabBtn.BackgroundColor3 = not shopOn and Color3.fromRGB(90,90,120) or Color3.fromRGB(70,70,90)
end

function Shop:RefreshAll()
	-- fetch profile and shop catalog
	local okP, prof = pcall(function() return self.getProfile:InvokeServer() end)
	if okP and type(prof) == "table" then self.profile = prof end
	local okC, cat = pcall(function() return self.requestShop:InvokeServer() end)
	if okC and type(cat) == "table" then self.catalog = cat end
	self:UpdateHeader()
	self:RebuildShop()
	self:RebuildCraft()
end

function Shop:UpdateHeader()
	local gold = ((self.profile and self.profile.Stats) and self.profile.Stats.Gold) or 0
	self.goldLabel.Text = "Gold: " .. tostring(gold)
end

function Shop:RebuildShop()
	local list = self.shopList
	for _, c in ipairs(list:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
	for _, it in ipairs(self.catalog or {}) do
		local row = Instance.new("Frame")
		row.Name = "Row_" .. tostring(it.id)
		row.Size = UDim2.new(1, -6, 0, 48)
		row.BackgroundColor3 = Color3.fromRGB(22,22,34)
		row.BorderSizePixel = 0
		row.Parent = list

		makeText(row, "Name", it.name or it.id, UDim2.new(0.5, -10, 1, 0), UDim2.new(0, 10, 0, 0))
		makeText(row, "Desc", it.description or "", UDim2.new(0.5, -10, 1, 0), UDim2.new(0.5, 0, 0, 0), Vector2.new(), Color3.fromRGB(200,200,220))
		makeText(row, "Price", "⨁ " .. tostring(it.price or 0), UDim2.new(0, 90, 1, 0), UDim2.new(1, -184, 0, 0), Vector2.new(), Color3.fromRGB(255, 222, 100))

		makeButton(row, "Buy", "Buy", UDim2.new(0, 72, 0, 28), UDim2.new(1, -80, 0.5, -14), function()
			self:BuyItem(it.id, 1)
		end)
	end
end

function Shop:RebuildCraft()
	local list = self.craftList
	for _, c in ipairs(list:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
	for _, r in ipairs(Items.Recipes or {}) do
		local row = Instance.new("Frame")
		row.Name = "Row_" .. tostring(r.id)
		row.Size = UDim2.new(1, -6, 0, 60)
		row.BackgroundColor3 = Color3.fromRGB(22,22,34)
		row.BorderSizePixel = 0
		row.Parent = list

		local name = Items.Lookup[r.id] and (Items.Lookup[r.id].name .. " (x" .. tostring(r.outputQty or 1) .. ")") or r.id
		makeText(row, "Name", name, UDim2.new(0.4, -10, 0, 24), UDim2.new(0, 10, 0, 4))
		makeText(row, "Mats", fmtMaterials(r.materials), UDim2.new(0.6, -10, 0, 24), UDim2.new(0.4, 0, 0, 4), Vector2.new(), Color3.fromRGB(200,200,220))

		local canCraft = self:HasMaterials(r.materials)
		local craftBtn = makeButton(row, "Craft", canCraft and "Craft" or "Missing", UDim2.new(0, 84, 0, 28), UDim2.new(1, -92, 0, 26), function()
			self:Craft(r.id)
		end)
		craftBtn.BackgroundColor3 = canCraft and Color3.fromRGB(70, 110, 70) or Color3.fromRGB(90, 70, 70)
		craftBtn.AutoButtonColor = canCraft
	end
end

function Shop:HasMaterials(mats)
	local inv = (self.profile and self.profile.Inventory) or {}
	for item, qty in pairs(mats or {}) do
		if (inv[item] or 0) < qty then return false end
	end
	return true
end

function Shop:Toast(text, color)
	local tl = Instance.new("TextLabel")
	tl.Size = UDim2.new(0, 260, 0, 30)
	tl.Position = UDim2.new(0.5, -130, 0, -40)
	tl.AnchorPoint = Vector2.new(0.5, 0)
	tl.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
	tl.BackgroundTransparency = 0.2
	tl.TextColor3 = color or Color3.new(1,1,1)
	tl.Font = Enum.Font.SourceSansBold
	tl.TextSize = 18
	tl.Text = text
	tl.Parent = self.gui
	task.defer(function()
		task.wait(1.75)
		if tl then tl:Destroy() end
	end)
end

function Shop:BuyItem(itemId, qty)
	qty = tonumber(qty) or 1
	local ok, res = pcall(function() return self.shopBuy:InvokeServer(itemId, qty) end)
	if ok and res and res.success then
		self:Toast("Purchased " .. tostring(itemId) .. " x" .. tostring(qty), Color3.fromRGB(120,255,120))
		self:RefreshAll()
	else
		local reason = res and res.error or "Error"
		self:Toast("Purchase failed: " .. tostring(reason), Color3.fromRGB(255,120,120))
	end
end

function Shop:Craft(recipeId)
	local ok, res = pcall(function() return self.craftItem:InvokeServer(recipeId) end)
	if ok and res and res.success then
		self:Toast("Crafted " .. tostring(recipeId), Color3.fromRGB(120,255,120))
		self:RefreshAll()
	else
		local reason = res and res.error or "Error"
		self:Toast("Craft failed: " .. tostring(reason), Color3.fromRGB(255,120,120))
	end
end

function Shop:Start() end

return Shop
