-- Maid: lightweight resource cleanup utility
-- Usage:
-- local Maid = require(path_to_Maid)
-- local maid = Maid.new()
-- maid:GiveTask(conn) -- conn has Disconnect/Destroy or callable
-- maid:GiveTask(function() ... end) -- will call function on cleanup
-- maid:Destroy() -- cleans up all tasks

local Maid = {}
Maid.__index = Maid

function Maid.new()
	local self = setmetatable({}, Maid)
	self._tasks = {}
	self._destroyed = false
	return self
end

local function tryDisconnect(task)
	if type(task) == "function" then
		pcall(task)
		return
	end
	if type(task) == "table" then
		if typeof and typeof(task) == "RBXScriptConnection" then
			pcall(function() task:Disconnect() end)
			return
		end
		-- Roblox Instances with Destroy
		if task.Destroy then
			pcall(function() task:Destroy() end)
			return
		end
		-- Connections
		if task.Disconnect then
			pcall(function() task:Disconnect() end)
			return
		end
	end
	-- fallback: try call
	if type(task) == "function" then pcall(task) end
end

function Maid:GiveTask(task)
	if self._destroyed then
		-- Immediately clean if already destroyed
		pcall(tryDisconnect, task)
		return
	end
	local id = #self._tasks+1
	self._tasks[id] = task
	return id
end

function Maid:Remove(id)
	local t = self._tasks[id]
	if t then
		self._tasks[id] = nil
		pcall(tryDisconnect, t)
	end
end

function Maid:Destroy()
	if self._destroyed then return end
	self._destroyed = true
	for k, t in pairs(self._tasks) do
		pcall(tryDisconnect, t)
		self._tasks[k] = nil
	end
	self._tasks = nil
end

function Maid.Is(obj)
	return getmetatable(obj) == Maid
end

return Maid
