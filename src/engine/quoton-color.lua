local Quoton = require("src.engine.quoton")
local QuotonLibrary = require("src.engine.quoton-library")

local Environment = require("src.modules.env")

---@class Color
---@field R number Red value 0-255
---@field G number Green value 0-255
---@field B number Blue value 0-255
---@field A number Alpha value 0-255
-- An RGB color with an alpha channel.
local Color = {}

if Environment.Library == "raylib-tsnake41" then
    local RayLib = QuotonLibrary

    ---@type fun(r:number, g:number, b:number, a:number?): Color
    -- Creates a new Color with the specified RGB colors. Alpha channel defaults to 255 if not provided.
    function Color.New(r, g, b, a)
        local self = setmetatable({}, Color)
        self._Struct = RayLib.new("Color", r, g, b, a or 255)
        return self
    end

    -- getter
    Color.__index = function(self, key)
        if key == "R" then
            return rawget(self, "_Struct").r
        elseif key == "G" then
            return rawget(self, "_Struct").g
        elseif key == "B" then
            return rawget(self, "_Struct").b
        elseif key == "A" then
            return rawget(self, "_Struct").a
        end
    end
    -- setter
    Color.__newindex = function(self, key, value)
        if key == "R" then
            rawget(self, "_Struct").r = value
        elseif key == "G" then
            rawget(self, "_Struct").g = value
        elseif key == "B" then
            rawget(self, "_Struct").b = value
        elseif key == "A" then
            rawget(self, "_Struct").a = value
        end
    end
    -- operations
    -- TODO: add operations
    -- lua
    -- TODO: add tostring
end

return Color
