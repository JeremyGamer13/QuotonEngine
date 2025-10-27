local Environment = require("src.modules.env")

-- Return the QuotonLibrary that this Environment.Library asks for.
if Environment.Library == "raylib-tsnake41" then
    local RayLib = require("src.engine.raylib")
    return RayLib
else
    error("Library " .. tostring(Environment.Library) .. " not implemented")
end
