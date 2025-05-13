-- THIS IS A CORE SCRIPT, You can edit the script and behavior of the functions, but DO NOT DELETE THE SCRIPT, OR IT'S FUNCTIONS!
-- Also make sure that all functions originally here return the same expected values.
local Enum = require("src.modules.enum")
local bit = require("bit")

local SetupService = require("src.services.setup")
local RenderingService = require("src.services.rendering")

local module = {}

-- Returns an array of require()'d scripts. Will be sent to the setup service.
function module:ImportGameScripts()
    return {
        require("src.scripts.test"),
        require("src.scripts.gamepadtest"),
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
        -- Volume level for all audio in the game.
        AudioVolume = 0.5,

        -- If true, will remove the ESC key closing the game.
        DisableKeyExit = true,

        -- Uses the system clock to scramble Lua's math.random calls. Recommended if using the native math.random function.
        EnableRandomRNG = true,

        --[[
            Forces all audio created with the Music type to be created as a Sound.
            May break some behavior if using functions only in Music audio types.
            Right now, none of the other sound types work stable enough to disable this.
        ]]
        EnableCompatibleAudio = true,

        -- Sets the available fonts that can be used in-game. Should be a path to the fonts.
        FontList = {"assets/fonts/NotoSans.ttf"},

        -- Sets the default primary font used by FontService. Can be changed later if neccessary.
        FontPrimary = "NotoSans",

        -- The resolution that FontService will load fonts in. Cannot be changed after FontService loads.
        FontResolution = 256,

        -- The filter mode that FontService will load fonts in. Cannot be changed after FontService loads.
        FontFilterMode = Enum.FilterMode.Trilinear,

        -- Target FPS the game will try to run at.
        FrameRateMax = 60,

        --[[
            The current raylib-lua bindings seem to have the gamepad axis indexes off by one.
            Enabling this fix will offset the index, though only in the InputService functions.
        ]]
        -- TODO: actually add this, it should offset by -1
        GamepadAxisFix = true,

        --[[
            On certain platforms, Quoton games will open with a terminal attached.
            If true, there will be default messages sent to the terminal to denote it can be ignored.
            These messages are written in English (United States).
        ]]
        TerminalShowIgnoreMessages = true,

        -- Changes RayLib's ConfigFlags. Recommended to stay at defaults.
        WindowConfigFlags = bit.bor(Enum.ConfigFlags.WindowResizable, Enum.ConfigFlags.MSAA4xHint),

        -- Maximizes the window on startup.
        WindowMaximize = false,

        -- Sets the initial resolution and window size for the game. Can be changed later using RenderingService.
        WindowResolutionX = 1280,
        WindowResolutionY = 720,

        --[[
            Resizes the game window (accounting for the game resolution's aspect ratio) to best fit inside the user's display in windowed mode.
            If WindowScreenResizeFill is also true, the window will fully resize to the user's display (using resolution's aspect ratio) and may overlap the taskbar on platforms like Windows.
        ]]
        WindowScreenResize = true,
        WindowScreenResizeFill = false,

        -- If true along with WindowScreenResize, the WindowResolutionX and WindowResolutionY properties are ignored and just use the best fitting resolution.
        WindowScreenResizeResolution = false,

        -- The title of the game window.
        WindowTitle = "QuotonGame",
    }
    local setupConfig = SetupService:GetSetupSettings(defaultConfig)

    -- Other scripts can hook into the setup and change stuff as they need to.
    SetupService:RunCustomSetup(setupConfig)

    RenderingService:SetResolution(
        setupConfig.WindowResolutionX,
        setupConfig.WindowResolutionY
    )

    return setupConfig
end

return module