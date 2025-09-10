local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Config = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Config"))

local PlayerData = {}
PlayerData.__index = PlayerData

local store = DataStoreService:GetDataStore(Config.DataStore.Name)
local sessions = {}

local DEFAULT = {
	Traits = {},
	Arcana = { Primary = "", Rare = "" },
	Stats = { Level = 1, XP = 0, Gold = 0 },
	Inventory = {},
	FirstAttunementGranted = false,
}

-- Helper functions for basic inventory and economy operations
function PlayerData.AddItem(plr, item, qty)
	local profile = sessions[plr]
	if not profile then return false end
	profile.Inventory[item] = (profile.Inventory[item] or 0) + (qty or 1)
	return true
end

function PlayerData.RemoveGold(plr, amount)
	local profile = sessions[plr]
	if not profile then return false end
	if profile.Stats.Gold < amount then return false end
	profile.Stats.Gold = profile.Stats.Gold - amount
	return true
end

function PlayerData.AddGold(plr, amount)
	local profile = sessions[plr]
	if not profile then return false end
	profile.Stats.Gold = profile.Stats.Gold + amount
	return true
end

function PlayerData.HasMaterials(plr, materials)
	local profile = sessions[plr]
	if not profile then return false end
	for item, qty in pairs(materials) do
		if (profile.Inventory[item] or 0) < qty then return false end
	end
	return true
end

function PlayerData.RemoveMaterials(plr, materials)
	local profile = sessions[plr]
	if not profile then return false end
	for item, qty in pairs(materials) do
		profile.Inventory[item] = (profile.Inventory[item] or 0) - qty
		if profile.Inventory[item] <= 0 then profile.Inventory[item] = nil end
	end
	return true
end

local function deepCopy(t)
	local n = {}
	for k, v in pairs(t) do
		n[k] = type(v) == "table" and deepCopy(v) or v
	end
	return n
end

function PlayerData:Init()
	Net.GetFunction("GetProfile").OnServerInvoke = function(plr)
		return sessions[plr]
	end
end

function PlayerData:OnPlayerAdded(plr)
	local key = "U_" .. plr.UserId
	local data
	for i = 1, Config.DataStore.RetryCount do
		local ok, result = pcall(function()
			return store:GetAsync(key)
		end)
		if ok then data = result break end
		task.wait(Config.DataStore.RetryDelay)
	end
	if type(data) ~= "table" then data = deepCopy(DEFAULT) end
	sessions[plr] = data
end

function PlayerData:OnPlayerRemoving(plr)
	local key = "U_" .. plr.UserId
	local data = sessions[plr]
	if data then
		for i = 1, Config.DataStore.RetryCount do
			local ok = pcall(function()
				store:SetAsync(key, data)
			end)
			if ok then break end
			task.wait(Config.DataStore.RetryDelay)
		end
		sessions[plr] = nil
	end
end

function PlayerData.Get(plr)
	return sessions[plr]
end

return PlayerData
