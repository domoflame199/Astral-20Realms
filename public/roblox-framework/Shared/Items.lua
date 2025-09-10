local Items = {}

Items.Catalog = {
	{ id = "hp_potion", name = "Healing Potion", price = 50, description = "Restores 200 HP", stack = true },
	{ id = "mana_potion", name = "Mana Potion", price = 45, description = "Restores 100 Mana", stack = true },
	{ id = "iron_sword", name = "Iron Sword", price = 300, description = "Basic melee weapon", stack = false },
	{ id = "astral_core", name = "Astral Core", price = 1000, description = "Rare crafting component", stack = true },
}

Items.Lookup = {}
for _, v in ipairs(Items.Catalog) do Items.Lookup[v.id] = v end

Items.Recipes = {
	{ id = "iron_sword", materials = { iron = 10, wood = 2 }, craftTime = 2, outputQty = 1 },
	{ id = "hp_potion", materials = { herb = 3, water = 1 }, craftTime = 1, outputQty = 1 },
}

Items.LootTables = {
	goblin = {
		{ id = "hp_potion", weight = 40 },
		{ id = "iron_sword", weight = 5 },
		{ id = "gold_small", weight = 60 },
	},
	titan = {
		{ id = "astral_core", weight = 10 },
		{ id = "gold_large", weight = 80 },
		{ id = "iron_sword", weight = 30 },
	}
}

return Items
