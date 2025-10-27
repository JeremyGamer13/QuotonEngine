local QuotonLibrary = require("src.engine.quoton-library")
local Rectangle = require("src.engine.quoton-rectangle")
local Vector2 = require("src.engine.quoton-vector2")

local Enum = require("src.modules.enum")
local Environment = require("src.modules.env")

local RenderingService = {}

---@private
RenderingService._renderSettings = {
    ResolutionX = 1280,
    ResolutionY = 720,

    FillMode = Enum.FillMode.Fit,
    Rotation = 0,

    ScreenTint = Enum.Color.White,
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
    local monitor = self:GetCurrentMonitor()
    local screenRes = self:GetMonitorBounds(monitor)

    -- check if we are using 4:3 or 16:9
    local aspectRatio = screenRes.Width / screenRes.Height
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
    while (startX * currentMult) < screenRes.Width and (startY * currentMult) < screenRes.Height do
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

-- Window
if Environment.Library == "raylib-tsnake41" then
    local RayLib = QuotonLibrary
    function RenderingService:GetWindowBounds()
        local windowPosition = RayLib.GetWindowPosition()
        return Rectangle.New(windowPosition.x, windowPosition.y, RayLib.GetScreenWidth(), RayLib.GetScreenHeight())
    end
    function RenderingService:GetWindowDPIScale()
        local scale = RayLib.GetWindowScaleDPI()
        return Vector2.New(scale.x, scale.y)
    end

    function RenderingService:SetWindowPosition(x, y)
        RayLib.SetWindowPosition(x, y)
    end
    function RenderingService:SetWindowSize(width, height)
        RayLib.SetWindowSize(width, height)
    end
    function RenderingService:MaximizeWindow()
        RayLib.MaximizeWindow()
    end
    function RenderingService:MinimizeWindow()
        RayLib.MinimizeWindow()
    end
end

-- Monitor
if Environment.Library == "raylib-tsnake41" then
    local RayLib = QuotonLibrary
    function RenderingService:GetCurrentMonitor()
        return RayLib.GetCurrentMonitor()
    end
    function RenderingService:GetMonitorCount()
        return RayLib.GetMonitorCount()
    end
    function RenderingService:GetMonitorRefreshRate(monitor)
        return RayLib.GetMonitorRefreshRate(monitor)
    end
    function RenderingService:GetMonitorBounds(monitor)
        local monitorPosition = RayLib.GetMonitorPosition(monitor)
        return Rectangle.New(monitorPosition.x, monitorPosition.y, RayLib.GetMonitorWidth(monitor), RayLib.GetMonitorHeight(monitor))
    end
end

-- Shapes
-- Rectangles
if Environment.Library == "raylib-tsnake41" then
    local RayLib = QuotonLibrary
    -- Draws a rectangle with a specific color using the given rectangle as bounds.
    function RenderingService:DrawRectangle(rect, color)
        RayLib.DrawRectangleRec(rect._Struct, color._Struct)
    end
end
-- Same as DrawRectangle but you need to provide each parameter of the rectangle individually.
function RenderingService:DrawRectangleLong(x, y, width, height, color)
    local rect = Rectangle.New(x, y, width, height)
    self:DrawRectangle(rect, color)
end

-- Circles
if Environment.Library == "raylib-tsnake41" then
    local RayLib = QuotonLibrary
    -- Draws a circle with a specific color using the provided vector as the center point.
    function RenderingService:DrawCircle(center, radius, color)
        RayLib.DrawCircleV(center._Struct, radius, color._Struct)
    end
end
-- Same as DrawCircle but you need to provide each parameter of the vector individually.
function RenderingService:DrawCircleLong(x, y, radius, color)
    local vector = Vector2.New(x, y)
    self:DrawCircle(vector, radius, color)
end

-- Text
if Environment.Library == "raylib-tsnake41" then
    local RayLib = QuotonLibrary
    -- Draws a string of text onto the screen using the provided settings.
    function RenderingService:DrawText(font, text, x, y, color, size, hAlign, vAlign)
        -- TODO: replace this
        if not color then
            color = Enum.Color.White
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
        RayLib.DrawTextEx(font, text, pos._Struct, size, 1, color._Struct)
    end
end
-- Repeatedly draws the text around the position provided to create an outline. Use DrawText after to draw the real text.
function RenderingService:DrawTextOutline(font, text, x, y, color, size, hAlign, vAlign)
    if not color then
        color = Enum.Color.Black
    end

    self:DrawText(font, text, x - 1, y - 1, color, size, hAlign, vAlign)
    self:DrawText(font, text, x + 1, y - 1, color, size, hAlign, vAlign)
    self:DrawText(font, text, x + 1, y + 1, color, size, hAlign, vAlign)
    self:DrawText(font, text, x - 1, y + 1, color, size, hAlign, vAlign)
end

-- Textures
if Environment.Library == "raylib-tsnake41" then
    local RayLib = QuotonLibrary
    -- Draws a texture, allows you to configure the width, height, rotation, and rotation alignment.
    function RenderingService:DrawTextureWHRO(texture, x, y, w, h, r, color, hAlign, vAlign, rotHAlign, rotVAlign)
        if not color then
            color = Enum.Color.White
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
        RayLib.DrawTexturePro(texture, srcRect._Struct, destRect._Struct, Vector2.New(originX, originY)._Struct, r, color._Struct)
    end
end
-- Draws a texture, allows you to configure the width, height, and rotation.
function RenderingService:DrawTextureWHR(texture, x, y, w, h, r, color, hAlign, vAlign)
    self:DrawTextureWHRO(texture, x, y, w, h, r, color, hAlign, vAlign, hAlign, vAlign)
end
-- Draws a texture, allows you to configure the width and height.
function RenderingService:DrawTextureWH(texture, x, y, w, h, color, hAlign, vAlign)
    self:DrawTextureWHR(texture, x, y, w, h, 0, color, hAlign, vAlign)
end

return RenderingService
