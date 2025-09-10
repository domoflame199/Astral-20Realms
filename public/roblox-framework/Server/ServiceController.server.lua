-- ServiceController: Initializes server systems
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Config = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Config"))

local Services = {}
local Maid = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Maid"))
Services.PlayerMaids = {}

local function requireIfExists(path)
	if path then
		local ok, mod = pcall(require, path)
		if ok then return mod end
	end
	return nil
end

local function startService(mod)
	if type(mod.Init) == "function" then mod:Init() end
	if type(mod.Start) == "function" then task.defer(function()
		mod:Start()
	end) end
end

local function bootstrap()
	-- Ensure remotes exist early
	Net.GetEvent("CastAbility")
	Net.GetEvent("LightAttack")
	Net.GetEvent("StatusApplied")
	Net.GetEvent("StatusCleared")
	Net.GetEvent("MonolithAttune")
	Net.GetFunction("GetProfile")
	-- Shop / Crafting
	Net.GetFunction("ShopBuy")
	Net.GetFunction("RequestShop")
	Net.GetFunction("CraftItem")
	Net.GetEvent("ShopUpdate")
	-- NPC / AI / Loot
	Net.GetEvent("NPCSpawn")
	Net.GetEvent("LootDropped")
	Net.GetFunction("RollLoot")

	Services.RateLimiter = requireIfExists(script.Parent:FindFirstChild("RateLimiter")) or {}
	Services.PlayerData = requireIfExists(script.Parent:FindFirstChild("PlayerData")) or {}
	Services.StatusEffects = requireIfExists(script.Parent:FindFirstChild("StatusEffects")) or {}
	Services.Traits = requireIfExists(script.Parent:FindFirstChild("Traits")) or {}
	Services.Arcana = requireIfExists(script.Parent:FindFirstChild("Arcana")) or {}
	Services.Combat = requireIfExists(script.Parent:FindChild("Combat")) or requireIfExists(script.Parent:FindFirstChild("Combat")) or {}
	Services.Monolith = requireIfExists(script.Parent:FindFirstChild("Monolith")) or {}
	Services.Matchmaking = requireIfExists(script.Parent:FindFirstChild("Matchmaking")) or {}

	for _, mod in pairs(Services) do
		startService(mod)
	end

	Players.PlayerAdded:Connect(function(plr)
		if Services.PlayerData and Services.PlayerData.OnPlayerAdded then
			Services.PlayerData:OnPlayerAdded(plr)
		end
	end)
	Players.PlayerRemoving:Connect(function(plr)
		if Services.PlayerData and Services.PlayerData.OnPlayerRemoving then
			Services.PlayerData:OnPlayerRemoving(plr)
		end
	end)
end

bootstrap()
