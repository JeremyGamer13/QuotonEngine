local RenderingService = require("src.services.rendering")
local RuntimeService = require("src.services.runtime")
local AudioService = require("src.services.audio")
local InputService = require("src.services.input")
local FontService = require("src.services.font")

local RayLib = require("raylib")
local RayLua = require("raylua")

local script = {}
function script:Initialize()
    print("loaded test script")
end

local audio
function script:StartTick()
    print("game running, will attempt to load audio and play...")
    audio = AudioService:New("assets/audio/test.mp3", AudioService.Enums.AudioType.MUSIC)
end

local stage = 0
RuntimeService.OnStep:Connect(function()
    if audio and audio:IsReady() and not audio:IsPlaying() then
        audio:Play()
    end

    if RayLib.IsKeyPressed(RayLib.KEY_SPACE) then
        stage = stage + 1
        stage = stage % 4
    end
    if stage == 0 then
        RenderingService:SetTint(RayLib.WHITE)
    elseif stage == 1 then
        RenderingService:SetTint(RayLib.RED)
    elseif stage == 2 then
        RenderingService:SetTint(RayLib.BLUE)
    elseif stage == 3 then
        RenderingService:SetTint(RayLib.GOLD)
    end
end)

local dir = 0
RuntimeService.OnDraw:Connect(function()
    -- draw bg
    RayLib.DrawRectangle(0, 0, 1280, 720, RayLib.WHITE)

    -- draw borders
    RayLib.DrawRectangle(0, 0, 5, 720, RayLib.BLUE)
    RayLib.DrawRectangle(1280 - 5, 0, 5, 720, RayLib.BLUE)
    RayLib.DrawRectangle(0, 0, 1280, 5, RayLib.BLUE)
    RayLib.DrawRectangle(0, 720 - 5, 1280, 5, RayLib.BLUE)

    -- draw circle
    dir = dir + 4
    dir = dir % 360
    local y = (math.sin(math.rad(dir)) * 60) + 360
    RayLib.DrawCircle(640, y, 32, RayLib.DARKBLUE)

    -- draw mouse
    local mouseX = InputService:GetMouseX()
    local mouseY = InputService:GetMouseY()
    local color = RayLib.RED
    if RayLib.IsMouseButtonDown(RayLua.MOUSE_LEFT_BUTTON) then
        color = RayLib.BLACK
    end
    RayLib.DrawCircle(mouseX, mouseY, 10, color)

    -- draw text
    local frameTime = RayLib.GetFrameTime()
    local fontSize = 64

    local font = FontService:GetPrimaryFont()
    RenderingService:DrawText(font, "FT: " .. tostring(frameTime), 32, 32, RayLib.ORANGE, fontSize)
    RenderingService:DrawText(font, "FPS: " .. tostring(1 / frameTime), 32, 64, RayLib.ORANGE, fontSize)
    RenderingService:DrawText(font, "W: " .. tostring(InputService.ScreenLocation.width), 32, 96, RayLib.BLUE, fontSize)
    RenderingService:DrawText(font, "H: " .. tostring(InputService.ScreenLocation.height), 32, 128, RayLib.BLUE, fontSize)
    RenderingService:DrawText(font, "X: " .. tostring(mouseX), 32, 128 + 32, RayLib.RED, fontSize)
    RenderingService:DrawText(font, "Y: " .. tostring(mouseY), 32, 128 + 64, RayLib.RED, fontSize)
end)

return script
