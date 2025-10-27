local QuotonLibrary = require("src.engine.quoton-library")
local Vector2 = require("src.engine.quoton-vector2")
local Rectangle = require("src.engine.quoton-rectangle")

local Enum = require("src.modules.enum")
local Environment = require("src.modules.env")

local RenderingService = {}

---@private
RenderingService._renderSettings = {
    ResolutionX = 1280,
    ResolutionY = 720,

    FillMode = Enum.FillMode.Fit,
    Rotation = 0,

    ScreenTint = QuotonLibrary.WHITE, -- TODO: replace this
    ScreenFilter = Enum.FilterMode.Trilinear,
}
---@private
RenderingService._flags = {
    shouldReloadRenTexture = false,
}
---@private
RenderingService._state = {
    texture = nil,
    font = nil,
}

function RenderingService:GetResolution()
    return {
        width = self._renderSettings.ResolutionX,
        height = self._renderSettings.ResolutionY
    }
end
function RenderingService:SetResolution(width, height)
    self._renderSettings.ResolutionX = width
    self._renderSettings.ResolutionY = height
    self._flags.shouldReloadRenTexture = true
end

-- Returns the best width & height for the user's screen setup. Specify `true` to get 1 resolution below.
function RenderingService:GetAppropriateResolution(getBelow)
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

    return Rectangle.New(0, 0, targetX, targetY)
end

function RenderingService:GetRotation()
    return self._renderSettings.Rotation
end
function RenderingService:SetRotation(rotation)
    self._renderSettings.Rotation = rotation
end
function RenderingService:GetFillMode()
    return self._renderSettings.FillMode
end
function RenderingService:SetFillMode(fillMode)
    self._renderSettings.FillMode = fillMode
end
function RenderingService:GetScreenFilter()
    return self._renderSettings.ScreenFilter
end
function RenderingService:SetScreenFilter(newFilter)
    self._renderSettings.ScreenFilter = newFilter
    self._flags.shouldReloadRenTexture = true
end
function RenderingService:GetTint()
    return self._renderSettings.ScreenTint
end
function RenderingService:SetTint(color)
    self._renderSettings.ScreenTint = color
end

function RenderingService:GetWindowBounds()
    if Environment.Library == "raylib-tsnake41" then
        local RayLib = QuotonLibrary
        local windowPosition = RayLib.GetWindowPosition()
        return Rectangle.New(windowPosition.x, windowPosition.y, RayLib.GetScreenWidth(), RayLib.GetScreenHeight())
    else
        error("RenderingService:GetWindowBounds for Library " .. tostring(Environment.Library) .. " not implemented")
    end
end
function RenderingService:GetMonitorBounds(monitor)
    if Environment.Library == "raylib-tsnake41" then
        local RayLib = QuotonLibrary
        local monitorPosition = RayLib.GetMonitorPosition(monitor)
        return Rectangle.New(monitorPosition.x, monitorPosition.y, RayLib.GetMonitorWidth(monitor), RayLib.GetMonitorHeight(monitor))
    else
        error("RenderingService:GetMonitorBounds for Library " .. tostring(Environment.Library) .. " not implemented")
    end
end

function RenderingService:DrawText(font, text, x, y, color, size, hAlign, vAlign)
    -- TODO: replace this
    local RayLib = QuotonLibrary
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

    local pos = Vector2.New(x, y)
    RayLib.DrawTextEx(font, text, pos, size, 1, color)
end
function RenderingService:DrawTextOutline(font, text, x, y, color, size, hAlign, vAlign)
    -- TODO: replace this
    local RayLib = QuotonLibrary
    if not color then
        color = RayLib.BLACK
    end

    self:DrawText(font, text, x - 1, y - 1, color, size, hAlign, vAlign)
    self:DrawText(font, text, x + 1, y - 1, color, size, hAlign, vAlign)
    self:DrawText(font, text, x + 1, y + 1, color, size, hAlign, vAlign)
    self:DrawText(font, text, x - 1, y + 1, color, size, hAlign, vAlign)
end

function RenderingService:DrawTextureWHRO(texture, x, y, w, h, r, color, hAlign, vAlign, rotHAlign, rotVAlign)
    -- TODO: replace this
    local RayLib = QuotonLibrary
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

    local srcRect = Rectangle.New(0, 0, texture.width, texture.height)
    local destRect = Rectangle.New(finalX, finalY, w, h)
    RayLib.DrawTexturePro(texture, srcRect, destRect, Vector2.New(originX, originY), r, color)
end
function RenderingService:DrawTextureWHR(texture, x, y, w, h, r, color, hAlign, vAlign)
    self:DrawTextureWHRO(texture, x, y, w, h, r, color, hAlign, vAlign, hAlign, vAlign)
end
function RenderingService:DrawTextureWH(texture, x, y, w, h, color, hAlign, vAlign)
    self:DrawTextureWHR(texture, x, y, w, h, 0, color, hAlign, vAlign)
end

return RenderingService
