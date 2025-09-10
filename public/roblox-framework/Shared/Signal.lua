-- Lightweight Signal implementation
-- Usage: local s = Signal.new(); local conn = s:Connect(function(...) end); s:Fire(...); conn:Disconnect()
local Signal = {}
Signal.__index = Signal

function Signal.new()
	local self = setmetatable({}, Signal)
	self._bindable = Instance.new("BindableEvent")
	self._connections = {}
	return self
end

function Signal:Connect(fn)
	local conn = self._bindable.Event:Connect(fn)
	table.insert(self._connections, conn)
	return conn
end

function Signal:Once(fn)
	local conn
	conn = self._bindable.Event:Connect(function(...)
		conn:Disconnect()
		fn(...)
	end)
	table.insert(self._connections, conn)
	return conn
end

function Signal:Fire(...)
	self._bindable:Fire(...)
end

function Signal:Destroy()
	for _, c in ipairs(self._connections) do
		c:Disconnect()
	end
	self._bindable:Destroy()
	self._connections = nil
end

return Signal
