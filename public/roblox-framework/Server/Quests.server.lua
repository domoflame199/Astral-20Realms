local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Net"))
local Quests = require(ReplicatedStorage:WaitForChild("AstralFramework"):WaitForChild("Shared"):WaitForChild("Quests"))
local PlayerData = require(script.Parent:WaitForChild("PlayerData"))

local QuestService = {}
QuestService.__index = QuestService

local function ensureTables(profile)
	profile.Quests = profile.Quests or { Active = {}, Completed = {} }
	profile.Quests.Active = profile.Quests.Active or {}
	profile.Quests.Completed = profile.Quests.Completed or {}
end

local function snapshot(plr)
	local p = PlayerData.Get(plr)
	if not p then return nil end
	ensureTables(p)
	return {
		active = p.Quests.Active,
		completed = p.Quests.Completed,
		catalog = Quests.Catalog,
	}
end

local function isComplete(profile, quest)
	local state = profile.Quests.Active[quest.id]
	if not state then return false end
	-- kill objectives
	if quest.objectives and quest.objectives.kill then
		for npc, need in pairs(quest.objectives.kill) do
			local got = (state.kills and state.kills[npc]) or 0
			if got < need then return false end
		end
	end
	-- collect objectives checked at turn-in
	return true
end

function QuestService:Init()
	Net.GetFunction("GetQuests").OnServerInvoke = function(plr)
		return snapshot(plr)
	end

	Net.GetFunction("AcceptQuest").OnServerInvoke = function(plr, questId)
		local q = Quests.Lookup[questId]
		if not q then return { success = false, error = "QuestNotFound" } end
		local p = PlayerData.Get(plr)
		if not p then return { success = false, error = "NoProfile" } end
		ensureTables(p)
		if p.Quests.Completed[questId] then return { success = false, error = "AlreadyCompleted" } end
		if p.Quests.Active[questId] then return { success = false, error = "AlreadyActive" } end
		p.Quests.Active[questId] = { startedAt = os.time(), kills = {} }
		Net.GetEvent("QuestUpdate"):FireClient(plr, { type = "accepted", id = questId })
		return { success = true }
	end

	Net.GetFunction("AbandonQuest").OnServerInvoke = function(plr, questId)
		local p = PlayerData.Get(plr)
		if not p then return { success = false } end
		ensureTables(p)
		p.Quests.Active[questId] = nil
		Net.GetEvent("QuestUpdate"):FireClient(plr, { type = "abandoned", id = questId })
		return { success = true }
	end

	Net.GetFunction("TurnInQuest").OnServerInvoke = function(plr, questId)
		local q = Quests.Lookup[questId]
		if not q then return { success = false, error = "QuestNotFound" } end
		local p = PlayerData.Get(plr)
		if not p then return { success = false, error = "NoProfile" } end
		ensureTables(p)
		if not isComplete(p, q) then return { success = false, error = "ObjectivesIncomplete" } end
		-- validate collect objectives now
		if q.objectives and q.objectives.collect then
			if not PlayerData.HasMaterials(plr, q.objectives.collect) then
				return { success = false, error = "MissingMaterials" }
			end
			PlayerData.RemoveMaterials(plr, q.objectives.collect)
		end
		-- award rewards
		local r = q.rewards or {}
		if r.xp then PlayerData.AddXP(plr, r.xp) end
		if r.gold then PlayerData.AddGold(plr, r.gold) end
		if r.items then
			for _, it in ipairs(r.items) do PlayerData.AddItem(plr, it.id, it.qty or 1) end
		end
		p.Quests.Active[questId] = nil
		p.Quests.Completed[questId] = true
		Net.GetEvent("QuestUpdate"):FireClient(plr, { type = "completed", id = questId, rewards = r })
		return { success = true }
	end
end

function QuestService.ProgressKill(plr, npcType)
	local p = PlayerData.Get(plr)
	if not p then return end
	ensureTables(p)
	for questId, state in pairs(p.Quests.Active) do
		local q = Quests.Lookup[questId]
		if q and q.objectives and q.objectives.kill and q.objectives.kill[npcType] then
			state.kills = state.kills or {}
			state.kills[npcType] = (state.kills[npcType] or 0) + 1
			Net.GetEvent("QuestUpdate"):FireClient(plr, { type = "progress", id = questId, kills = state.kills })
		end
	end
end

function QuestService.OnNPCKilled(plr, npcType)
	QuestService.ProgressKill(plr, npcType)
end

function QuestService:Start() end

return QuestService
