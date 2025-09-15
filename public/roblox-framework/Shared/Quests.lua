local Quests = {}

-- Quest catalog. Objectives: kill and/or collect. Rewards: xp, gold, items
Quests.Catalog = {
	{
		id = "goblin_slayer_1",
		name = "Goblin Menace",
		description = "Cull nearby goblins threatening the roads.",
		objectives = {
			kill = { goblin = 5 },
		},
		rewards = { xp = 120, gold = 80 }
	},
	{
		id = "arms_for_the_guard",
		name = "Arms for the Guard",
		description = "Deliver forged iron swords to the town guard.",
		objectives = {
			collect = { iron_sword = 2 },
		},
		rewards = { xp = 90, gold = 150 }
	},
	{
		id = "essence_of_the_astral",
		name = "Essence of the Astral",
		description = "Bring a rare Astral Core for study.",
		objectives = {
			collect = { astral_core = 1 },
		},
		rewards = { xp = 250, gold = 300 }
	},
}

-- Fast lookup
Quests.Lookup = {}
for _, q in ipairs(Quests.Catalog) do Quests.Lookup[q.id] = q end

return Quests
