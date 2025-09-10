-- Config: Tuning knobs for AstralFramework
local Config = {
	DataStore = {
		Name = "Htrea_Astral_Data_v1",
		RetryCount = 3,
		RetryDelay = 1,
	},
	Combat = {
		BaseWalkSpeed = 16,
		GlobalCooldown = 0.25,
		DamageClamp = { Min = 0, Max = 100000 },
	},
	Networking = {
		RateLimits = {
			CastAbility = 6, -- per second
			LightAttack = 10,
		}
	},
	Traits = {
		GrantOnFirstAttune = 3,
	},
}

return Config
