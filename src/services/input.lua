local RenderingService = require("src.services.rendering")
local RuntimeService = require("src.services.runtime")

local RayLib = require("raylib")

local libset = require("src.modules.libset")

local module = {}

---@private
module._ready = false

module.ScreenLocation = {
    x = 0,
    y = 0,
    width = 1280,
    height = 720,
}

---@private
module._typedChars = ""

function module:GetMouseX()
    if not self._ready then return 0 end
    local w = self.ScreenLocation.width
    local x = RayLib.GetMouseX() - self.ScreenLocation.x
    return ((x / w) * RenderingService.RenderSettings.ResolutionX)
end
function module:GetMouseY()
    if not self._ready then return 0 end
    local h = self.ScreenLocation.height
    local y = RayLib.GetMouseY() - self.ScreenLocation.y
    return ((y / h) * RenderingService.RenderSettings.ResolutionY)
end

function module:MouseWithin(rect)
    if not self._ready then return false end
    local x = self:GetMouseX()
    local y = self:GetMouseY()
    local isMouseXInside = (x >= rect.x) and (x <= (rect.x + rect.width))
    local isMouseYInside = (y >= rect.y) and (y <= (rect.y + rect.height))
    return isMouseXInside and isMouseYInside
end

function module:GetTypedCharacters()
    return module._typedChars
end
function module:Key(key)
    if key == "'" then return RayLib.KEY_APOSTROPHE end
    if key == "," then return RayLib.KEY_COMMA end
    if key == "-" then return RayLib.KEY_MINUS end
    if key == "." then return RayLib.KEY_PERIOD end
    if key == "/" then return RayLib.KEY_SLASH end
    if key == ";" then return RayLib.KEY_SEMICOLON end
    if key == "=" then return RayLib.KEY_EQUAL end
    if key == "[" then return RayLib.KEY_LEFT_BRACKET end
    if key == "\\" then return RayLib.KEY_BACKSLASH end
    if key == "]" then return RayLib.KEY_RIGHT_BRACKET end
    if key == "`" then return RayLib.KEY_GRAVE end

    if key == "0" then return RayLib.KEY_ZERO end
    if key == "1" then return RayLib.KEY_ONE end
    if key == "2" then return RayLib.KEY_TWO end
    if key == "3" then return RayLib.KEY_THREE end
    if key == "4" then return RayLib.KEY_FOUR end
    if key == "5" then return RayLib.KEY_FIVE end
    if key == "6" then return RayLib.KEY_SIX end
    if key == "7" then return RayLib.KEY_SEVEN end
    if key == "8" then return RayLib.KEY_EIGHT end
    if key == "9" then return RayLib.KEY_NINE end

    if key == "a" then return RayLib.KEY_A end
    if key == "b" then return RayLib.KEY_B end
    if key == "c" then return RayLib.KEY_C end
    if key == "d" then return RayLib.KEY_D end
    if key == "e" then return RayLib.KEY_E end
    if key == "f" then return RayLib.KEY_F end
    if key == "g" then return RayLib.KEY_G end
    if key == "h" then return RayLib.KEY_H end
    if key == "i" then return RayLib.KEY_I end
    if key == "j" then return RayLib.KEY_J end
    if key == "k" then return RayLib.KEY_K end
    if key == "l" then return RayLib.KEY_L end
    if key == "m" then return RayLib.KEY_M end
    if key == "n" then return RayLib.KEY_N end
    if key == "o" then return RayLib.KEY_O end
    if key == "p" then return RayLib.KEY_P end
    if key == "q" then return RayLib.KEY_Q end
    if key == "r" then return RayLib.KEY_R end
    if key == "s" then return RayLib.KEY_S end
    if key == "t" then return RayLib.KEY_T end
    if key == "u" then return RayLib.KEY_U end
    if key == "v" then return RayLib.KEY_V end
    if key == "w" then return RayLib.KEY_W end
    if key == "x" then return RayLib.KEY_X end
    if key == "y" then return RayLib.KEY_Y end
    if key == "z" then return RayLib.KEY_Z end

    return RayLib.KEY_NULL
end

RuntimeService.OnPreStep:Connect(function()
    if not module._ready then return end

    local bytes = {}
    local currentChar = RayLib.GetCharPressed()

    while currentChar ~= 0 do
        table.insert(bytes, currentChar)
        currentChar = RayLib.GetCharPressed()
    end

    module._typedChars = libset.table.join(libset.table.map(bytes, function(byte)
        local char = ""
        pcall(function()
            char = string.char(byte)
        end)
        return char
    end), "")
end)

return module
