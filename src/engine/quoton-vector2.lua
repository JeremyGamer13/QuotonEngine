local Quoton = require("src.engine.quoton")

local Environment = require("src.modules.env")

if Environment.Library == "raylib-tsnake41" then
    local RayLib = Quoton:GetLibrary()

    local Vector2 = {}

    function Vector2.New(x, y)
        local self = setmetatable({}, Vector2)
        self._Struct = RayLib.new("Vector2", x, y)
        return self
    end
    -- getter
    Vector2.__index = function(self, key)
        if key == "X" then
            return rawget(self, "_Struct").x
        elseif key == "Y" then
            return rawget(self, "_Struct").y
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

    return Vector2
end
