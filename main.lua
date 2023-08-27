local SetupService = require("services.setup")
local RuntimeService = require("services.runtime")
local RenderingService = require("services.rendering")
local AudioService = require("services.audio")
local FontService = require("services.font")
local InputService = require("services.input")
local TransmitterService = require("services.transmitter")

local RayLib = require("raylib")
local RayLua = require("raylua")

-- create window maximized
-- we need to tell the RuntimeService what the target fps is
-- so that deltaTime can be correct
RuntimeService.FrameRate = 120

local BaseScreenWidth = 1280
local BaseScreenHeight = 720

RayLib.SetConfigFlags(RayLib.FLAG_WINDOW_RESIZABLE)
RayLib.InitWindow(BaseScreenWidth, BaseScreenHeight, "ExperimAInt")
RayLib.SetTargetFPS(RuntimeService.FrameRate)
RayLib.MaximizeWindow()
RayLib.SetExitKey(RayLib.KEY_NULL)

-- setup audio
RayLib.InitAudioDevice()
RayLib.SetMasterVolume(0.65)

-- give runtime the loading screen
-- this screen will likely be needed by some other scripts
-- so we might aswell make it a core thing we do
RuntimeService.LoadingScreen = RayLib.LoadTexture("images/core/loading.png")

-- start all game scripts
SetupService:Initialize()
SetupService:StartTick()

-- load fonts & allow input service to begin
FontService.Load()
InputService.ready = true

local function step()
    -- run all step hooks
    RuntimeService:RunPreStep()
    RuntimeService:RunStep()
    RuntimeService:RunPostStep()
end

local RenderTexture = RayLib.LoadRenderTexture(1280, 720)
RenderingService._target = RenderTexture
local function draw()
    -- test
    RuntimeService:RunPreDraw()
    RuntimeService:RunDraw()
    RuntimeService:RunPostDraw()
end

print("")
print("-----")
print("If you are playing on the secondary build (or on certain platforms), this terminal / window is here.")
print("Do not close this! This is running the game currently.")
print("Feel free to move it away or minimize it since you don't need it for any part of the game.")
print("")
print("If you do want to read this for whatever reason, just note that the game will log loaded data here.")
print("There is no game advantage to using this though. All game information is not logged in release versions.")
print("-----")
print("")

local ForceWindowClose = false
TransmitterService.ListenFor("PROCESS_EXIT", function()
    ForceWindowClose = true
end)
while (not RayLib.WindowShouldClose()) and (not ForceWindowClose) do
    step()
    -- give input service the width & height
    -- otherwise it would return different numbers in different hooks
    local iwidth = RayLib.GetScreenWidth()
    local iheight = RayLib.GetScreenHeight()
    InputService.WindowWidth = iwidth
    InputService.WindowHeight = iheight
    -- draw in render texture
    RayLib.BeginTextureMode(RenderTexture)
    draw()
    RayLib.EndTextureMode()
    -- draw to screen
    RayLib.BeginDrawing()
    RayLib.ClearBackground(RayLib.BLACK)
    -- draw render texture to screen
    -- get config
    local width = RayLib.GetScreenWidth()
    local height = RayLib.GetScreenHeight()
    -- crop is negative height so the texture is flipped before rendering
    -- apparently something to do with opengl(?) coordinates starting at the bottom
    local crop = RayLua.Rectangle(0, 0, 1280, -720)
    local destination = RayLua.Rectangle(0, 0, width, height)
    local position = RayLua.Vector2(0, 0)
    local rotation = 0
    local tint = RenderingService._config.tint
    -- draw
    RayLib.DrawTexturePro(RenderTexture.texture, crop, destination, position, rotation, tint)
    if RenderingService.FrameRateVisible then
        local frameTime = RayLib.GetFrameTime()
        local font = FontService.Fonts.BASIC
        RenderingService.DrawText(font, tostring(1 / frameTime) .. " FPS", 16, 16, RayLib.GREEN, 24)
    end
    RayLib.EndDrawing()
end

-- unload assets
if RuntimeService.LoadingScreen then
    RayLib.UnloadTexture(RuntimeService.LoadingScreen)
end
FontService:Unload()
AudioService:Unload()
SetupService:Unload()
RayLib.UnloadRenderTexture(RenderTexture)
RayLib.CloseAudioDevice()
RayLib.CloseWindow()
