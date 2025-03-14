-- THIS IS A CORE SCRIPT, You can edit the script and behavior of the functions, but DO NOT DELETE THE SCRIPT, OR IT'S FUNCTIONS!
-- Also make sure that all functions originally here return the same expected values.
local RayLib = require("raylib")
local RayLua = require("raylua")
local bit = require("bit")

local SetupService = require("src.services.setup")
local RenderingService = require("src.services.rendering")

local module = {}

-- Returns an array of require()'d scripts. Will be sent to the setup service.
function module:ImportGameScripts()
    return {
        require("src.scripts.test")
    }
end

--[[
    Runs after services & libraries are imported, but before any of the initial setup runs.
    This is as early as user-script code is ran.
    Returns setupConfig.
]]
function module:InitializingPreProgram()
    -- Load the game scripts.
    local gameScripts = module:ImportGameScripts()
    SetupService:SetGameScripts(gameScripts)

    local defaultConfig = {
        -- If true, will remove the ESC key closing the game.
        disableKeyExit = true,

        -- Uses the system clock to scramble Lua's math.random calls. Recommended if using the native math.random function.
        enableRandomRNG = true,

        -- Sets the default primary font used by FontService. Can be changed later if neccessary.
        fontPrimary = "NotoSans",

        -- The resolution that FontService will load fonts in. Cannot be changed after FontService loads.
        fontResolution = 256,

        -- Target FPS the game will try to run at.
        frameRateMax = 60,

        -- Volume level of the game.
        masterVolume = 0.5,

        --[[
            On certain platforms, Quoton games will open with a terminal attached.
            If true, there will be default messages sent to the terminal to denote it can be ignored.
            These messages are written in English (United States).
        ]]
        terminalShowIgnoreMessages = true,

        -- Changes RayLib's ConfigFlags. Recommended to stay at defaults.
        windowConfigFlags = bit.bor(RayLib.FLAG_WINDOW_RESIZABLE, RayLib.FLAG_MSAA_4X_HINT),

        -- Maximizes the window on startup.
        windowMaximize = false,

        -- Sets the initial resolution and window size for the game. Can be changed later using RenderingService.
        windowResolutionX = 1280,
        windowResolutionY = 720,

        --[[
            Resizes the game window (accounting for the game resolution's aspect ratio) to best fit inside the user's display in windowed mode.
            If windowScreenResizeFill is also true, the window will fully resize to the user's display (using resolution's aspect ratio) and may overlap the taskbar on platforms like Windows.
        ]]
        windowScreenResize = true,
        windowScreenResizeFill = false,

        -- If true along with windowScreenResize, the windowResolutionX and windowResolutionY properties are ignored and just use the best fitting resolution.
        windowScreenResizeResolution = false,

        -- The title of the game window.
        windowTitle = "QuotonGame",
    }
    local setupConfig = SetupService:GetSetupSettings(defaultConfig)

    -- Other scripts can hook into the setup and change stuff as they need to.
    SetupService:RunCustomSetup(setupConfig)

    RenderingService:SetResolution(
        setupConfig.windowResolutionX,
        setupConfig.windowResolutionY
    )

    return setupConfig
end

return module