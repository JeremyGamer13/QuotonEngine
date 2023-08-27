local RayLib = require("raylib")

local module = {
    Fonts = {}
}

module.Load = function()
    module.Fonts.BASIC = RayLib.LoadFontEx("fonts/Gonsterrat/Regular.ttf", 128, nil, 250)
end
module.Unload = function()
    print("unloading fonts")
    RayLib.UnloadFont(module.Fonts.BASIC)
end

return module
