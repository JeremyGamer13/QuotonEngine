local libset = require("src.modules.libset")

local module = {}

local function CreateListenerObject()
    ---@class EventListener
    local Listener = {}

    Listener.Event = nil
    Listener.Connected = false

    Listener.Once = false
    Listener.OnceMet = false
    Listener.Order = nil

    Listener.Callback = nil

    function Listener:Disconnect()
        if self.Event then
            self.Event:Disconnect(self)
        end
    end
    function Listener:Run(...)
        if not self.Connected then return end

        local result = false
        if self.Callback then
            result = self.Callback(...)
        end

        if self.Once then
            self:Disconnect()
        elseif self.OnceMet and result == true then
            self:Disconnect()
        end
    end

    return Listener
end
local function CreateEventObject(optName)
    ---@class Event
    local Event = {
        Name = optName or "",
        _listeners = {},
    }

    ---@private Creates a listener.
    function Event:CreateListener(callback)
        local listener = CreateListenerObject()
        listener.Event = self
        listener.Connected = true
        listener.Callback = callback or function() end
        return listener
    end
    ---@private Removes listeners with no connection.
    function Event:FilterListeners()
        local targetEvent = self
        self._listeners = libset.table.filter(self._listeners, function(listener)
            return listener.Event == targetEvent and listener.Connected
        end)
    end
    ---@private Adds the listeners to the table, setting an execution order if provided
    function Event:AddToListeners(listener, optPosition)
        if optPosition ~= nil then
            listener.Order = optPosition
        end
        table.insert(self._listeners, listener)
    end
    ---@private Returns the table of listeners ordered if they have an order specified.
    function Event:GetListenersOrdered()
        local ordered = {}
        local unordered = {}

        for _, listener in pairs(self._listeners) do
            if listener.Order then
                table.insert(ordered, listener)
            else
                table.insert(unordered, listener)
            end
        end

        table.sort(ordered, function(a, b)
            return a.Order < b.Order
        end)

        for _, listener in ipairs(unordered) do
            table.insert(ordered, listener)
        end

        return ordered
    end

    -- Runs the callback when the event is fired.
    function Event:Connect(callback, optPosition)
        local listener = self:CreateListener(callback)
        self:AddToListeners(listener, optPosition)
        return listener
    end
    -- Will only run the first time the event runs after the listener was added.
    function Event:Once(callback, optPosition)
        local listener = self:CreateListener(callback)
        listener.Once = true
        self:AddToListeners(listener, optPosition)
        return listener
    end
    -- Will remove the listener from this event when the callback returns true.
    function Event:OnceMet(callback, optPosition)
        local listener = self:CreateListener(callback)
        listener.OnceMet = true
        self:AddToListeners(listener, optPosition)
        return listener
    end

    -- Removes the listener from this event. Preferred to do listener:Disconnect().
    function Event:Disconnect(listener)
        listener.Connected = false
        listener.Event = nil
    end
    -- Removes all listeners
    function Event:Clear()
        for _, listener in pairs(self._listeners) do
            self:Disconnect(listener)
        end
        self:FilterListeners()
    end
    function Event:Emit(...)
        local ordered = Event:GetListenersOrdered()
        local args = {...}

        for _, listener in ipairs(ordered) do
            local success, result = pcall(function()
                listener:Run(libset.table.unpack(args))
            end)
            if not success then
                print("Error in Event", self.Name, "listener:", result)
            end
        end
        self:FilterListeners()
    end

    return Event
end

function module:CreateEvent(optName)
    return CreateEventObject(optName)
end

return module
