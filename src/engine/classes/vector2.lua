local QuotonLibrary = require("src.engine.quoton-library")

local Environment = require("src.modules.env")

---@class Vector2
---@field X number The X coordinate of this Vector2.
---@field Y number The Y coordinate of this Vector2.
---@field private _Struct any
-- A vector with an X and Y coordinate.
local Vector2 = {}

if Environment.Library == "raylib-tsnake41" then
    local RayLib = QuotonLibrary

    ---@type fun(x:number, y:number): Vector2
    -- Creates a new Vector2 with the specified X and Y coordinate.
    function Vector2.New(x, y)
        local self = setmetatable({
            _Struct = RayLib.new("Vector2", x, y)
        }, Vector2)
        return self
    end
    -- getter
    Vector2.__index = function(self, key)
        if key == "X" then
            return rawget(self, "_Struct").x
        elseif key == "Y" then
            return rawget(self, "_Struct").y
        elseif key == "_Struct" then
            return rawget(self, "_Struct")
        end
    end
    -- setter
    Vector2.__newindex = function(self, key, value)
        if key == "X" then
            rawget(self, "_Struct").x = value
        elseif key == "Y" then
            rawget(self, "_Struct").y = value
        end
    end
    -- operations
    function Vector2.__add(v1, v2)
        return Vector2.New(v1._Struct.x + v2._Struct.x, v1._Struct.y + v2._Struct.y)
    end
    function Vector2.__sub(v1, v2)
        return Vector2.New(v1._Struct.x - v2._Struct.x, v1._Struct.y - v2._Struct.y)
    end
    function Vector2.__mul(v1, v2)
        if type(v1) == "number" then
            return Vector2.New(v1 * v2._Struct.x, v1 * v2._Struct.y)
        elseif type(v2) == "number" then
            return Vector2.New(v1._Struct.x * v2, v1._Struct.y * v2)
        else
            return Vector2.New(v1._Struct.x * v2._Struct.x, v1._Struct.y * v2._Struct.y)
        end
    end
    function Vector2.__div(v1, v2)
        if type(v1) == "number" then
            return Vector2.New(v1 / v2._Struct.x, v1 / v2._Struct.y)
        elseif type(v2) == "number" then
            return Vector2.New(v1._Struct.x / v2, v1._Struct.y / v2)
        else
            return Vector2.New(v1._Struct.x / v2._Struct.x, v1._Struct.y / v2._Struct.y)
        end
    end
    function Vector2.__unm(vector)
        return Vector2.New(-vector._Struct.x, -vector._Struct.y)
    end
    -- lua
    function Vector2:__tostring()
        return tostring(rawget(self, "_Struct").x) .. tostring(rawget(self, "_Struct").y)
    end
end

return Vector2
