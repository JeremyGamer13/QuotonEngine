-- for stuff like RayLib.Rectangle that raylib-lua does differently
local module = {}

module.Rectangle = function(x, y, width, height)
    return rl.new("Rectangle", x, y, width, height)
end
module.Vector2 = function(x, y)
    return rl.new("Vector2", x, y)
end
module.Color = function(r, g, b, a)
    return rl.new("Color", r, g, b, a)
end

module.MOUSE_LEFT_BUTTON = rl.MOUSE_BUTTON_LEFT
module.MOUSE_MIDDLE_BUTTON = rl.MOUSE_BUTTON_MIDDLE
module.MOUSE_RIGHT_BUTTON = rl.MOUSE_BUTTON_RIGHT

return module
