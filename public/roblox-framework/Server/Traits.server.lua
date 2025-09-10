local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Config = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Config"))
local PlayerData = require(script.Parent:WaitForChild("PlayerData"))

local Traits = {}
Traits.__index = Traits

local POOL = {
	"Astral Knowledge","Stoneborn","Flameheart","Aether Attuned","Shadow Veil","Beastbond","Quickened Step","Giant's Echo","Frostblood","Radiant Spirit","Stormrunner","Earthen Grip","Dune Strider","Tideborn","Marksman's Eye","Battle Instinct","Steel Will","Arcane Affinity","Nature's Blessing","Volcanic Soul","Wind Whisperer","Celestial Favor","Voidtouched","Echoed Voice","Starforged","Mystic Artisan","Soulbound","Ironblood","Ghost Step","Lucky Spark","Feral Rage","Astral Vision","Blessed Fortune"
}

local function randomUnique(n)
	local temp = table.clone(POOL)
	local out = {}
	for i=1, math.min(n, #temp) do
		local idx = math.random(1, #temp)
		table.insert(out, temp[idx])
		table.remove(temp, idx)
	end
	return out
end

function Traits:Init() end
function Traits:Start() end

function Traits.Grant(plr, names)
	local profile = PlayerData.Get(plr)
	if not profile then return end
	for _, name in ipairs(names) do
		local has = false
		for _, t in ipairs(profile.Traits) do if t == name then has = true break end end
		if not has then table.insert(profile.Traits, name) end
	end
end

function Traits.RandomAttunement(plr)
	local profile = PlayerData.Get(plr)
	if not profile then return end
	if not profile.FirstAttunementGranted then
		local grant = randomUnique(Config.Traits.GrantOnFirstAttune)
		Traits.Grant(plr, grant)
		profile.FirstAttunementGranted = true
		return grant
	end
	return {}
end

return Traits
