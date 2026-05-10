local QuotonLibrary = require("src.engine.quoton-library")

local Environment = require("src.modules.env")

---@class Rectangle
---@field X number Rectangle top-left corner position x
---@field Y number Rectangle top-left corner position y
---@field Width number Rectangle width
---@field Height number Rectangle height
---@field private _Struct any
-- A rectangle with a top-left corner X position, top-left corner Y position, width and height.
local Rectangle = {}

if Environment.Library == "raylib-tsnake41" then
    local RayLib = QuotonLibrary

    ---@type fun(x:number, y:number, width:number, height:number): Rectangle
    -- Creates a new Rectangle with the specified X, Y, width and height.
    function Rectangle.New(x, y, width, height)
        local self = setmetatable({
            _Struct = RayLib.new("Rectangle", x, y, width, height)
        }, Rectangle)
        return self
    end
    -- getter
    Rectangle.__index = function(self, key)
        if key == "X" then
            return rawget(self, "_Struct").x
        elseif key == "Y" then
            return rawget(self, "_Struct").y
        elseif key == "Width" then
            return rawget(self, "_Struct").width
        elseif key == "Height" then
            return rawget(self, "_Struct").height
        elseif key == "_Struct" then
            return rawget(self, "_Struct")
        end
    end
    -- setter
    Rectangle.__newindex = function(self, key, value)
        if key == "X" then
            rawget(self, "_Struct").x = value
        elseif key == "Y" then
            rawget(self, "_Struct").y = value
        elseif key == "Width" then
            rawget(self, "_Struct").width = value
        elseif key == "Height" then
            rawget(self, "_Struct").height = value
        end
    end
    -- operations
    -- TODO: add operations
    -- lua
    -- TODO: add tostring
end

return Rectangle
