local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable(
		{
			_callbacks = {},
		}, Signal)
end

function Signal:Fire(...: any)
	local args = {...}

	for _, connection in ipairs(self._callbacks) do
		task.spawn(function()
			connection._callback(unpack(args))
		end)
	end

	table.clear(args)
end

function Signal:Destroy()
	for _, connection in ipairs(self._callbacks) do
		connection:Disconnect()
	end

	table.clear(self._callbacks)
	table.clear(self)
	setmetatable(self, nil)
end

local connection = {}
connection.__index = connection

function Signal:Connect(handler)
	table.insert(self._callbacks, {_index = #self._callbacks + 1, _event = self, _callback = handler})
	return setmetatable(self._callbacks[#self._callbacks], connection)
end

function connection:Disconnect()
	assert(self._event._callbacks[self._index], "attempt to index nil with RBXScriptSignal")

	self._event._callbacks[self._index] = nil
	table.clear(self)
	setmetatable(self, nil)
end

return Signal
