local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))

local Shop = {}
Shop.__index = Shop

function Shop:Init()
	-- simple example usage: request shop and buy an item via command
	local ok, catalog = pcall(function() return Net.GetFunction("RequestShop"):InvokeServer() end)
	if ok and type(catalog) == "table" then
		print("Shop catalog loaded, items:")
		for _,it in ipairs(catalog) do print(it.id, it.name, it.price) end
	end
end

function Shop:Start() end

return Shop
