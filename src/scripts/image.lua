local RenderingService = require("src.services.rendering")
local RuntimeService = require("src.services.runtime")
local AudioService = require("src.services.audio")
local InputService = require("src.services.input")
local FontService = require("src.services.font")

local RayLib = require("raylib")
local RayLua = require("raylua")

local script = {}

local texture1
local texture2
function script:StartTick()
    local image = RayLib.LoadImage("assets/test.png")
    texture1 = RayLib.LoadTextureFromImage(image)
    RayLib.ImageRotateCW(image)
    texture2 = RayLib.LoadTextureFromImage(image)
end

RuntimeService.OnStep:Connect(function()
end)

RuntimeService.OnDraw:Connect(function()
    RayLib.DrawTexture(texture1, 160, 160, RayLib.WHITE)
    RayLib.DrawTexture(texture2, 160, 320, RayLib.WHITE)
end)

return script
