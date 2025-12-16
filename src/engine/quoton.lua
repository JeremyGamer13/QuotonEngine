local QuotonLibrary = require("src.engine.quoton-library")

local TransmitterService = require("src.services.transmitter")
local RenderingService = require("src.services.rendering")
local RuntimeService = require("src.services.runtime")

local libset = require("src.modules.libset")
local Environment = require("src.modules.env")
local BitOp = require("src.modules.bitop")

-- The handler for this game.
local Quoton = {}

-- Internal functions:

-- Initializes the game handler. Only meant to be used by the game engine.
function Quoton:Initialize(configFlags, configuration)
    if Environment.Library == "raylib-tsnake41" then
        local RayLib = QuotonLibrary
        RayLib.SetConfigFlags(BitOp.Or(libset.table.unpack(configFlags)))
        RayLib.InitWindow(
            RenderingService._renderSettings.ResolutionX,
            RenderingService._renderSettings.ResolutionY,
            configuration.WindowTitle
        )
    else
        error("Quoton:Initialize for Library " .. tostring(Environment.Library) .. " not implemented")
    end
end
-- Unloads the engine. Only meant to be used by the game engine.
function Quoton:UnloadEngine()
    if Environment.Library == "raylib-tsnake41" then
        local RayLib = QuotonLibrary
        RayLib.CloseAudioDevice()
        RayLib.CloseWindow()
    else
        error("Quoton:InitializeAudio for Library " .. tostring(Environment.Library) .. " not implemented")
    end
end

-- User + Internal functions:

---@param fps number Frames per Second that the game should try to reach.
-- Sets the target FPS (Frames per Second) that the game will try to achieve.
function Quoton:SetTargetFPS(fps)
    if Environment.Library == "raylib-tsnake41" then
        local RayLib = QuotonLibrary
        RayLib.SetTargetFPS(fps)
    else
        error("Quoton:SetTargetFPS for Library " .. tostring(Environment.Library) .. " not implemented")
    end
end

return Quoton