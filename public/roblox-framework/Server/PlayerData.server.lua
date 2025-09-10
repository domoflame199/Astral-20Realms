local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Config = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Config"))

local PlayerData = {}
PlayerData.__index = PlayerData

local store = DataStoreService:GetDataStore(Config.DataStore.Name)
local sessions = {}

local SCHEMA_VERSION = 1
local AUTOSAVE_INTERVAL = 60 -- seconds

local DEFAULT = {
	SchemaVersion = SCHEMA_VERSION,
	Traits = {},
	Arcana = { Primary = "", Rare = "" },
	Stats = { Level = 1, XP = 0, Gold = 0 },
	Inventory = {},
	FirstAttunementGranted = false,
}

local function deepCopy(t)
	local n = {}
	for k, v in pairs(t) do
		n[k] = type(v) == "table" and deepCopy(v) or v
	end
	return n
end

local migrations = {}
-- example migration placeholder: migrations[0] -> 1
migrations[0] = function(profile)
	-- migrate older shape to include SchemaVersion
	profile.SchemaVersion = 1
	if not profile.Inventory then profile.Inventory = {} end
	return profile
end

local function validateAndMigrate(profile)
	if type(profile) ~= "table" then return deepCopy(DEFAULT) end
	-- ensure keys
	if profile.SchemaVersion == nil then profile.SchemaVersion = 0 end
	for k, v in pairs(DEFAULT) do
		if profile[k] == nil then
			profile[k] = deepCopy(v)
		end
	end
	-- run migrations if needed
	local cur = profile.SchemaVersion
	while cur < SCHEMA_VERSION do
		local m = migrations[cur]
		if type(m) == "function" then
			profile = m(profile) or profile
			profile.SchemaVersion = profile.SchemaVersion + 1
			cur = profile.SchemaVersion
		else
			-- if no migration available, patch missing defaults and bump
			for k, v in pairs(DEFAULT) do if profile[k] == nil then profile[k] = deepCopy(v) end end
			profile.SchemaVersion = SCHEMA_VERSION
			cur = profile.SchemaVersion
		end
	end
	-- basic type enforcement
	if type(profile.Stats) ~= "table" then profile.Stats = deepCopy(DEFAULT.Stats) end
	if type(profile.Inventory) ~= "table" then profile.Inventory = {} end
	if type(profile.Traits) ~= "table" then profile.Traits = {} end
	return profile
end

local function saveWithRetries(key, data)
	local attempt = 0
	while attempt < Config.DataStore.RetryCount do
		local ok, err = pcall(function()
			store:SetAsync(key, data)
		end)
		if ok then return true end
		attempt = attempt + 1
		local delay = Config.DataStore.RetryDelay * (2 ^ (attempt - 1))
		task.wait(delay)
	end
	return false
end

local function saveSession(plr)
	local profile = sessions[plr]
	if not profile then return false end
	local key = "U_" .. plr.UserId
	-- store a shallow copy to avoid mutation during save
	local ok = saveWithRetries(key, profile)
	if not ok then warn("Failed to save profile for", plr.Name) end
	return ok
end

function PlayerData:Init()
	Net.GetFunction("GetProfile").OnServerInvoke = function(plr)
		local p = sessions[plr]
		if not p then return nil end
		-- return copy to avoid client mutating server state
		return deepCopy(p)
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
	local profile = validateAndMigrate(data)
	sessions[plr] = profile
end

function PlayerData:OnPlayerRemoving(plr)
	-- ensure immediate save before removing
	saveSession(plr)
	sessions[plr] = nil
end

-- autosave loop
spawn(function()
	while true do
		task.wait(AUTOSAVE_INTERVAL)
		for plr, _ in pairs(sessions) do
			pcall(function() saveSession(plr) end)
		end
	end
end)

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

function PlayerData.Get(plr)
	return sessions[plr]
end

return PlayerData

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
