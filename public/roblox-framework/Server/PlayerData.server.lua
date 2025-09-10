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
	FirstAttunementGranted = false,
}

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
