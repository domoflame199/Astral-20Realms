local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Items = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Items"))
local PlayerData = require(script.Parent:WaitForChild("PlayerData"))

local Loot = {}
Loot.__index = Loot

local function rollTable(tbl)
	local total = 0
	for _, it in ipairs(tbl) do total = total + (it.weight or 1) end
	local r = math.random() * total
	local acc = 0
	for _, it in ipairs(tbl) do
		acc = acc + (it.weight or 1)
		if r <= acc then return it end
	end
	return nil
end

function Loot.RollFor(plr, tableName)
	local tbl = Items.LootTables[tableName]
	if not tbl then return {} end
	local out = {}
	local rolls = math.random(1,2)
	for i=1,rolls do
		local it = rollTable(tbl)
		if it then
			if it.id:match("gold") then
				-- award gold
				local amt = (it.id == "gold_small") and math.random(5,20) or math.random(100,300)
				PlayerData.AddGold(plr, amt)
				table.insert(out, { id = "gold", amount = amt })
			else
				PlayerData.AddItem(plr, it.id, 1)
				table.insert(out, { id = it.id, amount = 1 })
			end
		end
	end
	-- notify client
	Net.GetEvent("LootDropped"):FireClient(plr, out)
	return out
end

function Loot:Init() end
function Loot:Start() end

return Loot
