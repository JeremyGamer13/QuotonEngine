-- TransmitterService is used if 2 scripts need to talk to each other
local EventService = require("src.services.event")

local module = {
    ---@private
    _eventNames = {}
}

function module:GetEvent(type)
    if module._eventNames[type] then return module._eventNames[type] end
    local event = EventService:CreateEvent("TransmitterEvent" .. type)
    module._eventNames[type] = event
    return event
end

function module:ListenFor(type, callback)
    local event = module:GetEvent(type)
    event:Connect(callback)
end
function module:Transmit(type, ...)
    local event = module:GetEvent(type)
    event:Emit(...)
end

return module
