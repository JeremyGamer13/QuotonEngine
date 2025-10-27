local QuotonLibrary = require("src.engine.quoton-library")
local Rectangle = require("src.engine.quoton-rectangle")

local RenderingService = require("src.services.rendering")
local RuntimeService = require("src.services.runtime")

local libset = require("src.modules.libset")
local Environment = require("src.modules.env")
local Enum = require("src.modules.enum")

local InputService = {}

---@private
InputService._ready = false
---@private
InputService._correctGamepadAxis = false
---@private
InputService._screenLocation = {
    x = 0,
    y = 0,
    width = 1280,
    height = 720,
}

-- Lists
-- Keys
function InputService:Key(key)
    if key == "'" then return Enum.InputKey.Apostrophe end
    if key == "," then return Enum.InputKey.Comma end
    if key == "-" then return Enum.InputKey.Minus end
    if key == "." then return Enum.InputKey.Period end
    if key == "/" then return Enum.InputKey.Slash end
    if key == "[" then return Enum.InputKey.LeftBracket end
    if key == "]" then return Enum.InputKey.RightBracket end
    if key == "\\" then return Enum.InputKey.Backslash end
    if key == "`" then return Enum.InputKey.Grave end
    if key == ";" then return Enum.InputKey.Semicolon end
    if key == "=" then return Enum.InputKey.Equal end
    if key == " " then return Enum.InputKey.Space end
    if key == "\t" then return Enum.InputKey.Tab end

    if key == "0" then return Enum.InputKey.Zero end
    if key == "1" then return Enum.InputKey.One end
    if key == "2" then return Enum.InputKey.Two end
    if key == "3" then return Enum.InputKey.Three end
    if key == "4" then return Enum.InputKey.Four end
    if key == "5" then return Enum.InputKey.Five end
    if key == "6" then return Enum.InputKey.Six end
    if key == "7" then return Enum.InputKey.Seven end
    if key == "8" then return Enum.InputKey.Eight end
    if key == "9" then return Enum.InputKey.Nine end

    if key == "a" then return Enum.InputKey.A end
    if key == "b" then return Enum.InputKey.B end
    if key == "c" then return Enum.InputKey.C end
    if key == "d" then return Enum.InputKey.D end
    if key == "e" then return Enum.InputKey.E end
    if key == "f" then return Enum.InputKey.F end
    if key == "g" then return Enum.InputKey.G end
    if key == "h" then return Enum.InputKey.H end
    if key == "i" then return Enum.InputKey.I end
    if key == "j" then return Enum.InputKey.J end
    if key == "k" then return Enum.InputKey.K end
    if key == "l" then return Enum.InputKey.L end
    if key == "m" then return Enum.InputKey.M end
    if key == "n" then return Enum.InputKey.N end
    if key == "o" then return Enum.InputKey.O end
    if key == "p" then return Enum.InputKey.P end
    if key == "q" then return Enum.InputKey.Q end
    if key == "r" then return Enum.InputKey.R end
    if key == "s" then return Enum.InputKey.S end
    if key == "t" then return Enum.InputKey.T end
    if key == "u" then return Enum.InputKey.U end
    if key == "v" then return Enum.InputKey.V end
    if key == "w" then return Enum.InputKey.W end
    if key == "x" then return Enum.InputKey.X end
    if key == "y" then return Enum.InputKey.Y end
    if key == "z" then return Enum.InputKey.Z end

    return Enum.InputKey.Unknown
end
-- Keypad
function InputService:Keypad(key)
    if key == "0" then return Enum.InputKey.KeypadZero end
    if key == "1" then return Enum.InputKey.KeypadOne end
    if key == "2" then return Enum.InputKey.KeypadTwo end
    if key == "3" then return Enum.InputKey.KeypadThree end
    if key == "4" then return Enum.InputKey.KeypadFour end
    if key == "5" then return Enum.InputKey.KeypadFive end
    if key == "6" then return Enum.InputKey.KeypadSix end
    if key == "7" then return Enum.InputKey.KeypadSeven end
    if key == "8" then return Enum.InputKey.KeypadEight end
    if key == "9" then return Enum.InputKey.KeypadNine end

    if key == "." then return Enum.InputKey.KeypadDecimal end
    if key == "/" then return Enum.InputKey.KeypadDivide end
    if key == "*" then return Enum.InputKey.KeypadMultiply end
    if key == "-" then return Enum.InputKey.KeypadSubtract end
    if key == "+" then return Enum.InputKey.KeypadAdd end
    if key == "=" then return Enum.InputKey.KeypadEqual end

    return Enum.InputKey.Unknown
end

-- Inputs
-- Generic (no devices)
function InputService:GetBounds()
    local loc = InputService._screenLocation
    return Rectangle.New(loc.x, loc.y, loc.width, loc.height)
end

-- Mouse
if Environment.Library == "raylib-tsnake41" then
    local RayLib = QuotonLibrary
    function InputService:GetMouseX() -- Return the X position of the mouse cursor.
        if not self._ready then return 0 end
        local w = self._screenLocation.width
        local x = RayLib.GetMouseX() - self._screenLocation.x
        return ((x / w) * RenderingService._renderSettings.ResolutionX)
    end
    function InputService:GetMouseY() -- Return the Y position of the mouse cursor.
        if not self._ready then return 0 end
        local h = self._screenLocation.height
        local y = RayLib.GetMouseY() - self._screenLocation.y
        return ((y / h) * RenderingService._renderSettings.ResolutionY)
    end
    function InputService:IsMouseButtonDown(button) -- Check if the mouse button is being pressed down
        return RayLib.IsMouseButtonDown(button)
    end
    function InputService:IsMouseButtonUp(button) -- Check if the mouse button is not being pressed down
        return RayLib.IsMouseButtonUp(button)
    end
    function InputService:IsMouseButtonPressed(button) -- Check if (on this frame) the mouse button was pressed
        return RayLib.IsMouseButtonPressed(button)
    end
    function InputService:IsMouseButtonReleased(button) -- Check if (on this frame) the mouse button was released
        return RayLib.IsMouseButtonReleased(button)
    end
end
function InputService:MouseWithin(rect)
    if not self._ready then return false end
    local x = self:GetMouseX()
    local y = self:GetMouseY()
    local isMouseXInside = (x >= rect.X) and (x <= (rect.X + rect.Width))
    local isMouseYInside = (y >= rect.Y) and (y <= (rect.Y + rect.Height))
    return isMouseXInside and isMouseYInside
end

-- Keyboard
InputService._typedKeycodes = {} ---@private
InputService._typedUnicodes = {} ---@private
if Environment.Library == "raylib-tsnake41" then
    local RayLib = QuotonLibrary
    function InputService:IsKeyDown(inputKey) -- Check if the inputKey is being pressed down
        return RayLib.IsKeyDown(inputKey)
    end
    function InputService:IsKeyUp(inputKey) -- Check if the inputKey is not being pressed down
        return RayLib.IsKeyUp(inputKey)
    end
    function InputService:IsKeyPressed(inputKey) -- Check if (on this frame) the inputKey was pressed
        return RayLib.IsKeyPressed(inputKey)
    end
    function InputService:IsKeyReleased(inputKey) -- Check if (on this frame) the inputKey was released
        return RayLib.IsKeyReleased(inputKey)
    end
end
function InputService:GetPressedInputKeys() -- Returns a table of keycodes, which can be compared against Enum.InputKey
    return self._typedKeycodes
end
function InputService:GetTypedUnicodes() -- Returns a table of Unicode numbers representing the keys pressed. On some devices, holding a key down will cause it to repeatedly be typed. This function will also get keys typed from said behavior.
    return self._typedUnicodes
end
function InputService:GetTypedCharacters() -- Converts the Unicode number table from GetTypedUnicodes into a table of the typed characters
    return libset.table.map(self._typedUnicodes, function(byte)
        local char = ""
        pcall(function()
            char = string.char(byte)
        end)
        return char
    end)
end

-- Make the loop for GetPressedInputKeys and GetTypedUnicodes
if Environment.Library == "raylib-tsnake41" then
    local RayLib = QuotonLibrary
    RuntimeService.OnPreStep:Connect(function()
        if not InputService._ready then return end

        -- reset tables
        InputService._typedKeycodes = {}
        InputService._typedUnicodes = {}

        -- GetKeyPressed loop
        local currentKeycode = RayLib.GetKeyPressed()
        while currentKeycode ~= 0 do
            table.insert(InputService._typedKeycodes, currentKeycode)
            currentKeycode = RayLib.GetKeyPressed()
        end

        -- GetCharPressed loop
        local currentUnicode = RayLib.GetCharPressed()
        while currentUnicode ~= 0 do
            table.insert(InputService._typedUnicodes, currentUnicode)
            currentUnicode = RayLib.GetCharPressed()
        end
    end)
end

return InputService
