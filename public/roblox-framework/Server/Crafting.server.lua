local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Items = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Items"))
local PlayerData = require(script.Parent:WaitForChild("PlayerData"))

local Crafting = {}
Crafting.__index = Crafting

function Crafting:Init()
	Net.GetFunction("CraftItem").OnServerInvoke = function(plr, recipeId)
		local recipe
		for _, r in ipairs(Items.Recipes) do if r.id == recipeId then recipe = r break end end
		if not recipe then return { success = false, error = "RecipeNotFound" } end
		if not PlayerData.HasMaterials(plr, recipe.materials) then return { success = false, error = "MissingMaterials" } end
		PlayerData.RemoveMaterials(plr, recipe.materials)
		PlayerData.AddItem(plr, recipeId, recipe.outputQty or 1)
		return { success = true }
	end
end

function Crafting:Start() end

return Crafting
