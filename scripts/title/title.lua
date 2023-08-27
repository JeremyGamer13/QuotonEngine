local RuntimeService = require("services.runtime")
local RenderingService = require("services.rendering")
local AudioService = require("services.audio")
local FontService = require("services.font")
local TweenService = require("services.tween")
local InputService = require("services.input")
local TransmitterService = require("services.transmitter")

local RayLib = require("raylib")
local RayLua = require("raylua")

local script = {}
script.Initialize = function()
    print("loaded title script")
end

script.StartTick = function()
    print("loading title assets...")
end

local drawHook = RuntimeService.CreateDrawHook(function()

end)

script.Unload = function()
    -- textures will be set to nil by the Step event
    -- if they arent loaded anymore
    -- if stepHook.Hooked then
    --     stepHook.Unhook()
    -- end
    if drawHook.Hooked then
        drawHook.Unhook()
    end
end

return script
