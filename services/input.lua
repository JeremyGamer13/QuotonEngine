local RayLib = require("raylib")

local module = {}

module.ready = false
module.WindowWidth = 1280
module.WindowHeight = 720

module.GetMouseX = function()
    if not module.ready then return 0 end
    local w = module.WindowWidth
    local x = RayLib.GetMouseX()
    return (x / w) * 1280
end
module.GetMouseY = function()
    if not module.ready then return 0 end
    local h = module.WindowHeight
    local y = RayLib.GetMouseY()
    return (y / h) * 720
end

module.MouseWithin = function(rect)
    if not module.ready then return false end
    local x = module.GetMouseX()
    local y = module.GetMouseY()
    local isMouseXInside = (x >= rect.x) and (x <= (rect.x + rect.width))
    local isMouseYInside = (y >= rect.y) and (y <= (rect.y + rect.height))
    return isMouseXInside and isMouseYInside
end

return module
