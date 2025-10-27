local RenderingService = require("src.services.rendering")
local RuntimeService = require("src.services.runtime")
local AudioService = require("src.services.audio")
local InputService = require("src.services.input")
local FontService = require("src.services.font")

local Enum = require("src.modules.enum")
local libset = require("src.modules.libset")

local script = {}
function script:Initialize()
    print("loaded test script")
end

local audio
function script:StartTick()
    print("game running, will attempt to load audio and play...")
    audio = AudioService:New("assets/audio/test.mp3", Enum.AudioType.Sound)
end

local stage = 0
RuntimeService.OnStep:Connect(function()
    if audio and audio:IsReady() and not audio:IsPlaying() then
        audio:Play()
    end

    if InputService:IsKeyPressed(Enum.InputKey.Space) then
        stage = stage + 1
        stage = stage % 4
    end
    if stage == 0 then
        RenderingService:SetTint(Enum.Color.White)
    elseif stage == 1 then
        RenderingService:SetTint(Enum.Color.Red)
    elseif stage == 2 then
        RenderingService:SetTint(Enum.Color.Blue)
    elseif stage == 3 then
        RenderingService:SetTint(Enum.Color.Gold)
    end
end)

local dir = 0
RuntimeService.OnDraw:Connect(function()
    -- draw bg
    RenderingService:DrawRectangleLong(0, 0, 1280, 720, Enum.Color.White)

    -- draw borders
    RenderingService:DrawRectangleLong(0, 0, 5, 720, Enum.Color.Blue)
    RenderingService:DrawRectangleLong(1280 - 5, 0, 5, 720, Enum.Color.Blue)
    RenderingService:DrawRectangleLong(0, 0, 1280, 5, Enum.Color.Blue)
    RenderingService:DrawRectangleLong(0, 720 - 5, 1280, 5, Enum.Color.Blue)

    -- draw circle
    dir = dir + 4
    dir = dir % 360
    local y = (math.sin(math.rad(dir)) * 60) + 360
    RenderingService:DrawCircleLong(640, y, 32, Enum.Color.DarkBlue)

    -- draw mouse
    local color = Enum.Color.Black
    if     InputService:IsMouseButtonDown(Enum.InputMouse.Left)    then color = Enum.Color.Maroon
    elseif InputService:IsMouseButtonDown(Enum.InputMouse.Middle)  then color = Enum.Color.Lime
    elseif InputService:IsMouseButtonDown(Enum.InputMouse.Right)   then color = Enum.Color.DarkBlue
    elseif InputService:IsMouseButtonDown(Enum.InputMouse.Side)    then color = Enum.Color.Purple
    elseif InputService:IsMouseButtonDown(Enum.InputMouse.Extra)   then color = Enum.Color.Yellow
    elseif InputService:IsMouseButtonDown(Enum.InputMouse.Forward) then color = Enum.Color.Orange
    elseif InputService:IsMouseButtonDown(Enum.InputMouse.Back)    then color = Enum.Color.Beige
    end

    local mouseX = InputService:GetMouseX()
    local mouseY = InputService:GetMouseY()
    RenderingService:DrawCircleLong(mouseX, mouseY, 10, color)

    -- draw text
    local font = FontService:GetPrimaryFont()
    local fontSize = 64

    local frameTime = RuntimeService:GetFrameTime()
    local inputBounds = InputService:GetBounds()
    RenderingService:DrawText(font, "FT: " .. tostring(frameTime), 32, 32, Enum.Color.Orange, fontSize)
    RenderingService:DrawText(font, "FPS: " .. tostring(1 / frameTime), 32, 64, Enum.Color.Orange, fontSize)
    RenderingService:DrawText(font, "W: " .. tostring(inputBounds.Width), 32, 96, Enum.Color.Blue, fontSize)
    RenderingService:DrawText(font, "H: " .. tostring(inputBounds.Height), 32, 128, Enum.Color.Blue, fontSize)
    RenderingService:DrawText(font, "X: " .. tostring(mouseX), 32, 128 + 32, Enum.Color.Red, fontSize)
    RenderingService:DrawText(font, "Y: " .. tostring(mouseY), 32, 128 + 64, Enum.Color.Red, fontSize)
    RenderingService:DrawText(font, "TXT: " .. tostring(InputService:GetPressedInputKeys()), 32, 128 + 96, Enum.Color.Red, fontSize)
end)

return script
