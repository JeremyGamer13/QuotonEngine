local RenderingService = require("src.services.rendering")
local RuntimeService = require("src.services.runtime")

local RayLib = require("raylib")
local RayLua = require("raylua")

local libset = require("src.modules.libset")
local Enum = require("src.modules.enum")

local module = {}

---@private
module._ready = false
---@private
module._correctGamepadAxis = false
---@private
module._screenLocation = {
    x = 0,
    y = 0,
    width = 1280,
    height = 720,
}

-- Lists
-- Keys
function module:Key(key)
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
function module:Keypad(key)
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
function module:GetBounds()
    local loc = module._screenLocation
    return RayLua.Rectangle(loc.x, loc.y, loc.width, loc.height)
end

-- Mouse
function module:GetMouseX() -- Return the X position of the mouse cursor.
    if not self._ready then return 0 end
    local w = self._screenLocation.width
    local x = RayLib.GetMouseX() - self._screenLocation.x
    return ((x / w) * RenderingService._renderSettings.ResolutionX)
end
function module:GetMouseY() -- Return the Y position of the mouse cursor.
    if not self._ready then return 0 end
    local h = self._screenLocation.height
    local y = RayLib.GetMouseY() - self._screenLocation.y
    return ((y / h) * RenderingService._renderSettings.ResolutionY)
end
function module:MouseWithin(rect)
    if not self._ready then return false end
    local x = self:GetMouseX()
    local y = self:GetMouseY()
    local isMouseXInside = (x >= rect.x) and (x <= (rect.x + rect.width))
    local isMouseYInside = (y >= rect.y) and (y <= (rect.y + rect.height))
    return isMouseXInside and isMouseYInside
end

-- Keyboard
module._typedKeycodes = {} ---@private
module._typedUnicodes = {} ---@private
function module:IsKeyDown(inputKey) -- Check if the inputKey is being pressed down
    return RayLib.IsKeyDown(inputKey)
end
function module:IsKeyUp(inputKey) -- Check if the inputKey is not being pressed down
    return RayLib.IsKeyUp(inputKey)
end
function module:IsKeyPressed(inputKey) -- Check if (on this frame) the inputKey was pressed
    return RayLib.IsKeyPressed(inputKey)
end
function module:IsKeyReleased(inputKey) -- Check if (on this frame) the inputKey was released
    return RayLib.IsKeyReleased(inputKey)
end
function module:GetPressedInputKeys() -- Returns a table of keycodes, which can be compared against Enum.InputKey
    return module._typedKeycodes
end
function module:GetTypedUnicodes() -- Returns a table of Unicode numbers representing the keys pressed. On some devices, holding a key down will cause it to repeatedly be typed. This function will also get keys typed from said behavior.
    return module._typedUnicodes
end
function module:GetTypedCharacters() -- Converts the Unicode number table from GetTypedUnicodes into a table of the typed characters
    return libset.table.map(module._typedUnicodes, function(byte)
        local char = ""
        pcall(function()
            char = string.char(byte)
        end)
        return char
    end)
end

RuntimeService.OnPreStep:Connect(function()
    if not module._ready then return end

    -- reset tables
    module._typedKeycodes = {}
    module._typedUnicodes = {}

    -- GetKeyPressed loop
    local currentKeycode = RayLib.GetKeyPressed()
    while currentKeycode ~= 0 do
        table.insert(module._typedKeycodes, currentKeycode)
        currentKeycode = RayLib.GetKeyPressed()
    end

    -- GetCharPressed loop
    local currentUnicode = RayLib.GetCharPressed()
    while currentUnicode ~= 0 do
        table.insert(module._typedUnicodes, currentUnicode)
        currentUnicode = RayLib.GetCharPressed()
    end
end)

return module
