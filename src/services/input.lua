local RenderingService = require("src.services.rendering")
local RuntimeService = require("src.services.runtime")

local RayLib = require("raylib")

local libset = require("src.modules.libset")

local module = {}

module.ready = false
module.ScreenLocation = {
    x = 0,
    y = 0,
    width = 1280,
    height = 720,
}

module._typedChars = ""

function module:GetMouseX()
    if not self.ready then return 0 end
    local w = self.ScreenLocation.width
    local x = RayLib.GetMouseX() - self.ScreenLocation.x
    return ((x / w) * RenderingService.RenderSettings.ResolutionX)
end
function module:GetMouseY()
    if not self.ready then return 0 end
    local h = self.ScreenLocation.height
    local y = RayLib.GetMouseY() - self.ScreenLocation.y
    return ((y / h) * RenderingService.RenderSettings.ResolutionY)
end

function module:MouseWithin(rect)
    if not self.ready then return false end
    local x = self:GetMouseX()
    local y = self:GetMouseY()
    local isMouseXInside = (x >= rect.x) and (x <= (rect.x + rect.width))
    local isMouseYInside = (y >= rect.y) and (y <= (rect.y + rect.height))
    return isMouseXInside and isMouseYInside
end

function module:GetTypedCharacters()
    return module._typedChars
end

RuntimeService.OnPreStep:Connect(function()
    if not module.ready then return end

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
