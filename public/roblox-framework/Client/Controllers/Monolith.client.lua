local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local root = ReplicatedStorage:WaitForChild("AstralFramework")
local Net = require(root:WaitForChild("Shared"):WaitForChild("Net"))

local Monolith = {}
Monolith.__index = Monolith

local ATTUNE_RANGE = 8
local SCAN_INTERVAL = 5 -- seconds

function Monolith:Init()
	self.player = Players.LocalPlayer
	self.character = self.player and self.player.Character or nil
	self.rootPart = nil
	self.monolithParts = {}
	self.lastScan = 0
	self.closest = nil
	self.recent = {}

	if self.player then
		self.player.CharacterAdded:Connect(function(char)
			self.character = char
			self.rootPart = nil
			if char then
				char:WaitForChild("HumanoidRootPart", 5)
				self.rootPart = char:FindFirstChild("HumanoidRootPart")
			end
		end)
		if self.player.Character then
			self.character = self.player.Character
			self.rootPart = self.character:FindFirstChild("HumanoidRootPart")
		end
	end

	-- input handler for attuning
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.E then
			if self.closest and self.closest.instance and (not self.recent[self.closest.instance] or (tick() - self.recent[self.closest.instance]) > 3) then
				-- fire server event to attune
				pcall(function()
					Net.GetEvent("MonolithAttune"):FireServer()
				end)
				self.recent[self.closest.instance] = tick()
			end
		end
	end)
end

local function findPrimaryPartFor(obj)
	if not obj then return nil end
	if obj:IsA("Model") then
		if obj.PrimaryPart and obj.PrimaryPart:IsA("BasePart") then
			return obj.PrimaryPart
		end
		for _, v in ipairs(obj:GetDescendants()) do
			if v:IsA("BasePart") then return v end
		end
	elseif obj:IsA("BasePart") then
		return obj
	end
	return nil
end

local function scanMonoliths(self)
	local found = {}
	-- look for Models or Parts named "Monolith" in workspace
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name == "Monolith" then
			local part = findPrimaryPartFor(obj)
			if part then
				table.insert(found, { instance = obj, part = part })
			end
		end
	end
	-- also check for folder named Monoliths
	local folder = workspace:FindFirstChild("Monoliths")
	if folder then
		for _, obj in ipairs(folder:GetDescendants()) do
			if obj:IsA("Model") or obj:IsA("BasePart") then
				if obj.Name == "Monolith" or obj:FindFirstChild("Monolith") then
					local part = findPrimaryPartFor(obj)
					if part then table.insert(found, { instance = obj, part = part }) end
				end
			end
		end
	end
	self.monolithParts = found
	self.lastScan = tick()
end

function Monolith:Start()
	-- heartbeat checks nearest monolith
	RunService.Heartbeat:Connect(function()
		local now = tick()
		if now - self.lastScan > SCAN_INTERVAL then
			scanMonoliths(self)
		end
		local rp = self.rootPart
		if not rp and self.character then rp = self.character:FindFirstChild("HumanoidRootPart") end
		self.rootPart = rp
		if not rp then
			self.closest = nil
			return
		end
		local closestDist = math.huge
		local closestEntry = nil
		for _, entry in ipairs(self.monolithParts) do
			local part = entry.part
			if part and part:IsDescendantOf(workspace) then
				local dist = (part.Position - rp.Position).Magnitude
				if dist < closestDist then
					closestDist = dist
					closestEntry = entry
				end
			end
		end
		if closestEntry and closestDist <= ATTUNE_RANGE then
			self.closest = closestEntry
		else
			self.closest = nil
		end
	end)
end

return setmetatable(Monolith, Monolith)
