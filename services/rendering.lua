local RayLib = require("raylib")
local RayLua = require("raylua")

local module = {}

module.FrameRateVisible = false
module._config = {
    tint = RayLib.WHITE
}

module.SetTint = function(color)
    module._config.tint = color
end
module.DrawText = function(font, text, x, y, color, size)
    local pos = RayLua.Vector2(x, y)
    RayLib.DrawTextEx(font, text, pos, size, 1, color)
end
module.DrawTextOutline = function(font, text, x, y, color, size)
    module.DrawText(font, text, x - 1, y - 1, color, size)
    module.DrawText(font, text, x + 1, y - 1, color, size)
    module.DrawText(font, text, x + 1, y + 1, color, size)
    module.DrawText(font, text, x - 1, y + 1, color, size)
end

module.DrawTextureWH = function(texture, x, y, w, h, color)
    local srcRect = RayLua.Rectangle(0, 0, texture.width, texture.height)
    local destRect = RayLua.Rectangle(x, y, w, h)
    RayLib.DrawTexturePro(texture, srcRect, destRect, RayLua.Vector2(0, 0), 0, color)
end
module.DrawTextureWHR = function(texture, x, y, w, h, r, color)
    local srcRect = RayLua.Rectangle(0, 0, texture.width, texture.height)
    local destRect = RayLua.Rectangle(x, y, w, h)
    RayLib.DrawTexturePro(texture, srcRect, destRect, RayLua.Vector2(0, 0), r, color)
end

return module
