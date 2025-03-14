local RayLib = require("raylib")
local RayLua = require("raylua")

local module = {}

module.Enum = {
    CROP = "crop",
    FIT = "fit",
    STRETCH = "stretch",

    LEFT = "left",
    RIGHT = "right",
    TOP = "top",
    BOTTOM = "bottom",
    CENTER = "center",
}

module.RenderSettings = {
    ResolutionX = 1280,
    ResolutionY = 720,

    FillMode = module.Enum.FIT,
    Rotation = 0,

    ScreenTint = RayLib.WHITE,
    ScreenFilter = RayLib.TEXTURE_FILTER_TRILINEAR,
}
module._flags = {
    shouldReloadRenTexture = false,
}
module._state = {
    texture = nil,
    font = nil,
}

function module:GetResolution()
    return {
        width = self.RenderSettings.ResolutionX,
        height = self.RenderSettings.ResolutionY
    }
end
function module:SetResolution(width, height)
    self.RenderSettings.ResolutionX = width
    self.RenderSettings.ResolutionY = height
    self._flags.shouldReloadRenTexture = true
end

function module:GetScreenFilter()
    return self.RenderSettings.ScreenFilter
end
function module:SetScreenFilter(newFilter)
    self.RenderSettings.ScreenFilter = newFilter
    self._flags.shouldReloadRenTexture = true
end

function module:GetWindowResolution()
    return {
        width = RayLib.GetScreenWidth(),
        height = RayLib.GetScreenHeight(),
    }
end
function module:GetScreenResolution()
    local monitor = RayLib.GetCurrentMonitor()
    return {
        width = RayLib.GetMonitorWidth(monitor),
        height = RayLib.GetMonitorHeight(monitor),
    }
end
function module:GetAppropriateResolution(getBelow) -- Returns the best width & height for the user's screen setup. Specify true to get 1 resolution below.
    local screenRes = self:GetScreenResolution()

    -- check if we are using 4:3 or 16:9
    local aspectRatio = screenRes.width / screenRes.height
    local aspectRatio43 = 4 / 3
    local aspectRatio169 = 16 / 9

    local diff43 = math.abs(aspectRatio - aspectRatio43)
    local diff169 = math.abs(aspectRatio - aspectRatio169)

    local targetting43 = false
    if diff43 < diff169 then
        targetting43 = true
    end

    local startX = 160
    local startY = 90
    if targetting43 then
        startX = 40
        startY = 30
    end

    local targetX = startX
    local targetY = startY
    local currentMult = 2

    -- increase in mults of 2 until one number is too big
    while (startX * currentMult) < screenRes.width and (startY * currentMult) < screenRes.height do
        if not getBelow then
            currentMult = currentMult + 1
        end
        targetX = startX * currentMult
        targetY = startY * currentMult
        if getBelow then
            currentMult = currentMult + 1
        end
    end

    return {
        width = targetX,
        height = targetY,
    }
end

function module:SetTint(color)
    self.RenderSettings.ScreenTint = color
end
function module:DrawText(font, text, x, y, color, size, hAlign, vAlign)
    if not color then
        color = RayLib.WHITE
    end

    if not hAlign then
        hAlign = 0
    end
    if not vAlign then
        vAlign = 0
    end

    if hAlign ~= 0 then
        local measure = RayLib.MeasureTextEx(font, text, size, 1)
        local width = measure.x

        x = x - (width * hAlign)
    end
    y = y - (size * vAlign)

    local pos = RayLua.Vector2(x, y)
    RayLib.DrawTextEx(font, text, pos, size, 1, color)
end
function module:DrawTextOutline(font, text, x, y, color, size, hAlign, vAlign)
    if not color then
        color = RayLib.BLACK
    end

    self:DrawText(font, text, x - 1, y - 1, color, size, hAlign, vAlign)
    self:DrawText(font, text, x + 1, y - 1, color, size, hAlign, vAlign)
    self:DrawText(font, text, x + 1, y + 1, color, size, hAlign, vAlign)
    self:DrawText(font, text, x - 1, y + 1, color, size, hAlign, vAlign)
end

function module:DrawTextureWHRO(texture, x, y, w, h, r, color, hAlign, vAlign, rotHAlign, rotVAlign)
    if not color then
        color = RayLib.WHITE
    end

    if not hAlign then
        hAlign = 0
    end
    if not vAlign then
        vAlign = 0
    end

    if not rotHAlign then
        rotHAlign = 0
    end
    if not rotVAlign then
        rotVAlign = 0
    end

    local adjustedX = x - w * hAlign
    local adjustedY = y - h * vAlign

    local originX = w * rotHAlign
    local originY = h * rotVAlign

    local finalX = adjustedX + originX
    local finalY = adjustedY + originY

    local srcRect = RayLua.Rectangle(0, 0, texture.width, texture.height)
    local destRect = RayLua.Rectangle(finalX, finalY, w, h)
    RayLib.DrawTexturePro(texture, srcRect, destRect, RayLua.Vector2(originX, originY), r, color)
end
function module:DrawTextureWHR(texture, x, y, w, h, r, color, hAlign, vAlign)
    self:DrawTextureWHRO(texture, x, y, w, h, r, color, hAlign, vAlign, hAlign, vAlign)
end
function module:DrawTextureWH(texture, x, y, w, h, color, hAlign, vAlign)
    self:DrawTextureWHR(texture, x, y, w, h, 0, color, hAlign, vAlign)
end

return module
