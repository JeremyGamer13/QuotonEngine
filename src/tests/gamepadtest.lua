local RenderingService = require("src.services.rendering")
local RuntimeService = require("src.services.runtime")
local AudioService = require("src.services.audio")
local InputService = require("src.services.input")
local FontService = require("src.services.font")

local Enum = require("src.modules.enum")

local script = {}

RuntimeService.OnDraw:Connect(function()
    local text = ""
    if RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonLeftFaceUp) then
        text = "ButtonLeftFaceUp"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonLeftFaceRight) then
        text = "ButtonLeftFaceRight"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonLeftFaceDown) then
        text = "ButtonLeftFaceDown"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonLeftFaceLeft) then
        text = "ButtonLeftFaceLeft"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonRightFaceUp) then
        text = "ButtonRightFaceUp"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonRightFaceRight) then
        text = "ButtonRightFaceRight"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonRightFaceDown) then
        text = "ButtonRightFaceDown"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonRightFaceLeft) then
        text = "ButtonRightFaceLeft"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonLeftTrigger1) then
        text = "ButtonLeftTrigger1"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonLeftTrigger2) then
        text = "ButtonLeftTrigger2"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonRightTrigger1) then
        text = "ButtonRightTrigger1"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonRightTrigger2) then
        text = "ButtonRightTrigger2"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonMiddleLeft) then
        text = "ButtonMiddleLeft"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonMiddle) then
        text = "ButtonMiddle"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonMiddleRight) then
        text = "ButtonMiddleRight"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonLeftThumb) then
        text = "ButtonLeftThumb"
    elseif RayLib.IsGamepadButtonDown(0, Enum.InputGamepad.ButtonRightThumb) then
        text = "ButtonRightThumb"
    end

    if text == "" then
        text = text .. "\nAxisLeftX: " .. RayLib.GetGamepadAxisMovement(0, RayLib.GAMEPAD_AXIS_LEFT_X)
        text = text .. "\nAxisLeftY: " .. RayLib.GetGamepadAxisMovement(0, RayLib.GAMEPAD_AXIS_LEFT_Y)
        text = text .. "\nAxisRightX: " .. RayLib.GetGamepadAxisMovement(0, RayLib.GAMEPAD_AXIS_RIGHT_X)
        text = text .. "\nAxisRightY: " .. RayLib.GetGamepadAxisMovement(0, RayLib.GAMEPAD_AXIS_RIGHT_Y)
        text = text .. "\nAxisLeftTrigger: " .. RayLib.GetGamepadAxisMovement(0, RayLib.GAMEPAD_AXIS_LEFT_TRIGGER)
        text = text .. "\nAxisRightTrigger: " .. RayLib.GetGamepadAxisMovement(0, RayLib.GAMEPAD_AXIS_RIGHT_TRIGGER)
    end

    local font = FontService:GetPrimaryFont()
    local fontSize = 32

    local mouseX = InputService:GetMouseX()
    local mouseY = InputService:GetMouseY()
    RenderingService:DrawText(font, text, mouseX, mouseY, RayLib.RED, fontSize)
end)

return script
