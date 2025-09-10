local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Items = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Items"))
local PlayerData = require(script.Parent:WaitForChild("PlayerData"))

local Shop = {}
Shop.__index = Shop

function Shop:Init()
	-- Buy via RemoteFunction
	Net.GetFunction("ShopBuy").OnServerInvoke = function(plr, itemId, qty)
		qty = tonumber(qty) or 1
		local info = Items.Lookup[itemId]
		if not info then return { success = false, error = "ItemNotFound" } end
		local cost = (info.price or 0) * qty
		if not PlayerData.RemoveGold(plr, cost) then return { success = false, error = "InsufficientGold" } end
		PlayerData.AddItem(plr, itemId, qty)
		return { success = true }
	end

	-- Provide shop catalog snapshot
	Net.GetFunction("RequestShop").OnServerInvoke = function(plr)
		return Items.Catalog
	end
end

function Shop:Start() end

return Shop
