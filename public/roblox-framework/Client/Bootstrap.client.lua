local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local root = ReplicatedStorage:WaitForChild("AstralFramework")
local Net = require(root:WaitForChild("Shared"):WaitForChild("Net"))

-- Load controllers
local function safeRequire(path)
	local ok, mod = pcall(require, path)
	if ok then return mod end
	return nil
end

local controllers = {}
controllers.Combat = safeRequire(script:FindFirstChild("Controllers"):FindFirstChild("Combat")) or {}
controllers.Arcana = safeRequire(script.Controllers:FindFirstChild("Arcana")) or {}
controllers.Status = safeRequire(script.Controllers:FindFirstChild("Status")) or {}
controllers.Monolith = safeRequire(script.Controllers:FindFirstChild("Monolith")) or {}

for _, c in pairs(controllers) do
	if type(c.Init) == "function" then c:Init() end
	if type(c.Start) == "function" then task.defer(function() c:Start() end) end
end

-- Example: request profile
local GetProfile = Net.GetFunction("GetProfile")
local plr = Players.LocalPlayer
local ok, profile = pcall(function()
	return GetProfile:InvokeServer()
end)
if ok and type(profile) == "table" then
	print("Profile loaded", profile)
end
