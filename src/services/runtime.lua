local EventService = require("src.services.event")

local RayLib = require("raylib")

local libset = require("src.modules.libset")

local module = {
    LoadingScreen = nil,
    RandomInitializeData = {
        final = 0,
        amount = 0
    },

    MaxFrameRate = 60, -- this can change with no issues
    RuntimeFrameRate = 60, -- this should NOT change and will cause issues if changed

    _flags = {
        newMaxFps = 60,
        shouldUpdateMaxFps = false,
    },
}

function module:GetFPS()
    return RayLib.GetFPS()
end
function module:GetDeltaTime() -- Used for mathematics such as moving pixels by delta time.
    local frameTime = RayLib.GetFrameTime()
    return self.RuntimeFrameRate * frameTime
end
function module:GetFrameTime() -- Basically Delta time, but used for mathematics such as lerp.
    local frameTime = RayLib.GetFrameTime()
    return frameTime
end

function module:SetMaxFPS(newFps)
    self._flags.newMaxFps = newFps
    self._flags.shouldUpdateMaxFps = true
end

module.OnPreStep = EventService:CreateEvent("OnPreStep")
module.OnStep = EventService:CreateEvent("OnStep")
module.OnPostStep = EventService:CreateEvent("OnPostStep")
module.OnPreDraw = EventService:CreateEvent("OnPreDraw")
module.OnDraw = EventService:CreateEvent("OnDraw")
module.OnPostDraw = EventService:CreateEvent("OnPostDraw")

return module
