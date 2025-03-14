local module = {}

-- helper
local function multiplierToNormalNumber(mul, start, endd)
    local multiplier = endd - start
    local result = (mul * multiplier) + start
    return result
end
local function test(condition, a, b)
    if condition then
        return a
    else
        return b
    end
end

-- ENUMS
module.IN = "in"
module.OUT = "out"
module.IN_OUT = "in out"

module.LINEAR = "linear"
module.SINE = "sine"
module.QUAD = "quad"
module.CUBIC = "cubic"
module.QUART = "quart"
module.QUINT = "quint"
module.EXPO = "expo"
module.CIRC = "circ"
module.BACK = "back"
module.ELASTIC = "elastic"
module.BOUNCE = "bounce"

-- Math from JS to Lua (only required stuff)
local Math = {
    cos = math.cos,
    sin = math.sin,
    sqrt = math.sqrt,
    PI = math.pi,
    pow = function(a, b)
        return a ^ b
    end
}

-- tween functions
local functions = {}

-- tween func
module.Tween = function(mode, direction, start, endd, progress)
    local tweened = functions[mode](progress, direction)
    return multiplierToNormalNumber(tweened, start, endd)
end

-- populate to tween functions
functions.linear = function(x)
    return x -- lol
end
functions.sine = function(x, dir)
    if dir == "in" then
        return 1 - Math.cos((x * Math.PI) / 2)
    elseif dir == "out" then
        return Math.sin((x * Math.PI) / 2)
    elseif dir == "in out" then
        return -(Math.cos(Math.PI * x) - 1) / 2
    else
        return 0
    end
end
functions.quad = function(x, dir)
    if dir == "in" then
        return x * x
    elseif dir ==
        "out" then
        return 1 - (1 - x) * (1 - x)
    elseif dir ==
        "in out" then
        return test(x < 0.5, 2 * x * x, 1 - Math.pow(-2 * x + 2, 2) / 2)
    else
        return 0
    end
end
functions.cubic = function(x, dir)
    if dir == "in" then
        return x * x * x
    elseif dir == "out" then
        return 1 - Math.pow(1 - x, 3)
    elseif dir == "in out" then
        return test(x < 0.5, 4 * x * x * x, 1 - Math.pow(-2 * x + 2, 3) / 2)
    else
        return 0
    end
end
functions.quart = function(x, dir)
    if dir == "in" then
        return x * x * x * x
    elseif dir == "out" then
        return 1 - Math.pow(1 - x, 4)
    elseif dir == "in out" then
        return test(x < 0.5, 8 * x * x * x * x, 1 - Math.pow(-2 * x + 2, 4) / 2)
    else
        return 0
    end
end
functions.quint = function(x, dir)
    if dir == "in" then
        return x * x * x * x * x
    elseif dir == "out" then
        return 1 - Math.pow(1 - x, 5)
    elseif dir == "in out" then
        return test(x < 0.5, 16 * x * x * x * x * x, 1 - Math.pow(-2 * x + 2, 5) / 2)
    else
        return 0
    end
end
functions.expo = function(x, dir)
    if dir == "in" then
        return test(x == 0, 0, Math.pow(2, 10 * x - 10))
    elseif dir == "out" then
        return test(x == 1, 1, 1 - Math.pow(2, -10 * x))
    elseif dir == "in out" then
        return test(x == 0
        , 0
        , test(x == 1
        , 1
        , test(x < 0.5, Math.pow(2, 20 * x - 10) / 2
        , (2 - Math.pow(2, -20 * x + 10)) / 2)))
    else
        return 0
    end
end
functions.circ = function(x, dir)
    if dir == "in" then
        return 1 - Math.sqrt(1 - Math.pow(x, 2))
    elseif dir == "out" then
        return Math.sqrt(1 - Math.pow(x - 1, 2))
    elseif dir == "in out" then
        return test(x < 0.5
        , (1 - Math.sqrt(1 - Math.pow(2 * x, 2))) / 2
        , (Math.sqrt(1 - Math.pow(-2 * x + 2, 2)) + 1) / 2)
    else
        return 0
    end
end
functions.back = function(x, dir)
    if dir == "in" then
        local c1 = 1.70158
        local c3 = c1 + 1

        return c3 * x * x * x - c1 * x * x
    elseif dir == "out" then
        local c1 = 1.70158
        local c3 = c1 + 1

        return 1 + c3 * Math.pow(x - 1, 3) + c1 * Math.pow(x - 1, 2)
    elseif dir == "in out" then
        local c1 = 1.70158
        local c2 = c1 * 1.525

        return test(x < 0.5
        , (Math.pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2
        , (Math.pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2)
    else
        return 0
    end
end
functions.elastic = function(x, dir)
    if dir == "in" then
        local c4 = (2 * Math.PI) / 3

        return test(x == 0
        , 0
        , test(x == 1
        , 1
        , -Math.pow(2, 10 * x - 10) * Math.sin((x * 10 - 10.75) * c4)))
    elseif dir == "out" then
        local c4 = (2 * Math.PI) / 3

        return test(x == 0
        , 0
        , test(x == 1
        , 1
        , Math.pow(2, -10 * x) * Math.sin((x * 10 - 0.75) * c4) + 1))
    elseif dir == "in out" then
        local c5 = (2 * Math.PI) / 4.5

        return test(x == 0
        , 0
        , test(x == 1
        , 1
        , test(x < 0.5
        , -(Math.pow(2, 20 * x - 10) * Math.sin((20 * x - 11.125) * c5)) / 2
        , (Math.pow(2, -20 * x + 10) * Math.sin((20 * x - 11.125) * c5)) / 2 + 1)))
    else
        return 0
    end
end
functions.bounce = function(x, dir)
    if dir == "in" then
        return 1 - functions.bounce(1 - x, "out")
    elseif dir == "out" then
        local n1 = 7.5625
        local d1 = 2.75

        if (x < 1 / d1) then
            return n1 * x * x
        elseif (x < 2 / d1) then
            local _a = x
            x = x - 1.5 / d1
            return n1 * (_a - 1.5 / d1) * x + 0.75
        elseif (x < 2.5 / d1) then
            local _a = x
            x = x - 2.25 / d1
            return n1 * (_a - 2.25 / d1) * x + 0.9375
        else
            local _a = x
            x = x - 2.625 / d1
            return n1 * (_a - 2.625 / d1) * x + 0.984375
        end
    elseif dir == "in out" then
        return test(x < 0.5
        , (1 - functions.bounce(1 - 2 * x, "out")) / 2
        , (1 + functions.bounce(2 * x - 1, "out")) / 2)
    else
        return 0
    end
end

return module
