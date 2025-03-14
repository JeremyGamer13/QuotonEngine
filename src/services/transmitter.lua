-- TransmitterService is used if 2 scripts need to talk to each other
local module = {}

local _listeners = {}
module.ListenFor = function(type, callback)
    -- if this callback type doesnt exist yet, create it
    if not _listeners[type] then
        _listeners[type] = {}
    end
    -- add callback
    table.insert(_listeners[type], callback)
end
module.FireListeners = function(type, data)
    -- if this callback type doesnt exist yet, no events are attached
    -- so just return
    if not _listeners[type] then return false end
    -- fire listeners
    for _, listener in pairs(_listeners[type]) do
        listener(data)
    end
    return true
end

return module
