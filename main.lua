local Quoton = require("src.engine.quoton")
local Vector2 = require("src.engine.classes.vector2")
local Rectangle = require("src.engine.classes.rectangle")

local TransmitterService = require("src.services.transmitter")
local RenderingService = require("src.services.rendering")
local RuntimeService = require("src.services.runtime")
local SetupService = require("src.services.setup")
local AudioService = require("src.services.audio")
local InputService = require("src.services.input")
local FontService = require("src.services.font")
-- local FileService = require("src.services.file")

local libset = require("src.modules.libset")
local Enum = require("src.modules.enum")

-- This is one of the only times a user script is loaded outside of user code.
-- The user can run their own functions to run when the game is starting up.
local ScriptSetup = require("src.scripts.setup")
local SetupConfig = ScriptSetup:InitializingPreProgram()
SetupService.InitialConfig = SetupConfig

-- set default resolution
RenderingService:SetResolution(
    SetupConfig.WindowResolutionX,
    SetupConfig.WindowResolutionY
)
-- setup the game engine
Quoton:Initialize(SetupConfig.WindowConfigFlags, SetupConfig)
Quoton:SetTargetFPS(SetupConfig.FrameRateMax) -- TODO: Shouldnt this be part of RuntimeService?
-- TODO: Implement ExitKey stuff for Quoton here

if SetupConfig.WindowScreenResize then
    local monitor = RenderingService:GetCurrentMonitor()
    local screenResolution = RenderingService:GetMonitorBounds(monitor)
    local appropriateWindowRes = RenderingService:GetAppropriateResolution(not SetupConfig.WindowScreenResizeFill)
    RenderingService:SetWindowSize(appropriateWindowRes.Width, appropriateWindowRes.Height)
    RenderingService:SetWindowPosition(
        (screenResolution.Width / 2) - (appropriateWindowRes.Width / 2),
        (screenResolution.Height / 2) - (appropriateWindowRes.Height / 2)
    )

    if SetupConfig.WindowScreenResizeResolution then
        local appropriateRes = RenderingService:GetAppropriateResolution()
        RenderingService:SetResolution(appropriateRes.Width, appropriateRes.Height)
    end
end
if SetupConfig.WindowMaximize then
    RenderingService:MaximizeWindow()
end

-- this makes math.random a bit better at being random
-- also introduces the silly thing of RNG manipulation!
if SetupConfig.EnableRandomRNG then
    local randomRepeats = math.ceil((os.time() % 500) + (os.clock() % 500))
    local randomValue = 0
    for _ = 1, randomRepeats do
        randomValue = math.random(1, 512)
    end
    RuntimeService._randomInitializeData = {
        final = randomValue,
        amount = randomRepeats
    }
end

-- setup audio
AudioService:Initialize()
AudioService:SetMasterVolume(SetupConfig.AudioVolume)

-- load fonts & allow input service to begin
FontService.PrimaryFont = SetupConfig.FontPrimary
FontService:Load(SetupConfig.FontList)
InputService._ready = true

local RayLib = require("src.engine.quoton-library") -- TODO: Remove this
local RenderTexture = RayLib.LoadRenderTexture( -- TODO: RenderingService should be able to make it's own RenderTextures and have the user swap the target one.
    RenderingService._renderSettings.ResolutionX,
    RenderingService._renderSettings.ResolutionY
)
RayLib.SetTextureFilter(RenderTexture.texture, RenderingService._renderSettings.ScreenFilter)
RenderingService._target = RenderTexture

-- start all game scripts
SetupService:Initialize()
SetupService:StartTick()

local ForceWindowClose = false
TransmitterService:ListenFor("PROCESS_EXIT", function()
    ForceWindowClose = true
end)
while (not RayLib.WindowShouldClose()) and (not ForceWindowClose) do
    local windowSize = RenderingService:GetWindowBounds()

    local renderDestination = {
        x = 0,
        y = 0,
        width = windowSize.Width,
        height = windowSize.Height
    }
    if RenderingService._renderSettings.FillMode == Enum.FillMode.Crop then
        local ratioX = windowSize.Width / RenderingService._renderSettings.ResolutionX
        local ratioY = windowSize.Height / RenderingService._renderSettings.ResolutionY
        local scale = math.max(ratioX, ratioY)

        renderDestination.width = RenderingService._renderSettings.ResolutionX * scale
        renderDestination.height = RenderingService._renderSettings.ResolutionY * scale
        renderDestination.x = (windowSize.Width - renderDestination.width) / 2
        renderDestination.y = (windowSize.Height - renderDestination.height) / 2
    elseif RenderingService._renderSettings.FillMode == Enum.FillMode.Fit then
        local ratioX = windowSize.Width / RenderingService._renderSettings.ResolutionX
        local ratioY = windowSize.Height / (RenderingService._renderSettings.ResolutionY)
        local scale = math.min(ratioX, ratioY)

        renderDestination.width = RenderingService._renderSettings.ResolutionX * scale
        renderDestination.height = (RenderingService._renderSettings.ResolutionY) * scale
        renderDestination.x = (windowSize.Width - renderDestination.width) / 2
        renderDestination.y = (windowSize.Height - renderDestination.height) / 2
    end

    -- give input service the destination since otherwise position would be wrong
    InputService._screenLocation = renderDestination

    -- we may need to update the max fps target this frame
    if RuntimeService._flags.shouldUpdateMaxFps then
        RuntimeService.MaxFrameRate = RuntimeService._flags.newMaxFps
        RayLib.SetTargetFPS(RuntimeService.MaxFrameRate)
        RuntimeService._flags.shouldUpdateMaxFps = false
    end

    -- we need to update the resolution if told to
    -- this requires basically remaking the render texture
    if RenderingService._flags.shouldReloadRenTexture then
        RayLib.UnloadRenderTexture(RenderTexture)

        RenderTexture = RayLib.LoadRenderTexture(
            RenderingService._renderSettings.ResolutionX,
            RenderingService._renderSettings.ResolutionY
        )
        RayLib.SetTextureFilter(RenderTexture.texture, RenderingService._renderSettings.ScreenFilter)
        RenderingService._target = RenderTexture
        RenderingService._flags.shouldReloadRenTexture = false
    end

    -- step
    RuntimeService.OnPreStep:Emit()
    RuntimeService.OnStep:Emit()
    RuntimeService.OnPostStep:Emit()
    -- draw in render texture
    RayLib.BeginTextureMode(RenderTexture)
    RuntimeService.OnPreDraw:Emit()
    RuntimeService.OnDraw:Emit()
    RuntimeService.OnPostDraw:Emit()
    RayLib.EndTextureMode()
    -- draw to screen
    RayLib.BeginDrawing()
    RayLib.ClearBackground(RayLib.BLACK)

    -- draw render texture to screen
    -- crop is negative height so the texture is flipped before rendering
    -- apparently something to do with opengl(?) coordinates starting at the bottom
    local renderTexConfig = {
        crop = Rectangle.New(0, 0, RenderingService._renderSettings.ResolutionX, 0 - RenderingService._renderSettings.ResolutionY),
        destination = Rectangle.New(renderDestination.x, renderDestination.y, renderDestination.width, renderDestination.height),
        position = Vector2.New(0, 0),
    }
    RayLib.DrawTexturePro(
        RenderTexture.texture,
        renderTexConfig.crop._Struct,
        renderTexConfig.destination._Struct,
        renderTexConfig.position._Struct,
        RenderingService._renderSettings.Rotation,
        RenderingService._renderSettings.ScreenTint._Struct
    )

    RayLib.EndDrawing()
end

-- unload assets
AudioService:Unload()
SetupService:Unload()
-- FileService:Unload()
FontService:Unload()
RayLib.UnloadRenderTexture(RenderTexture)
Quoton:UnloadEngine()
