local Enum = require("src.modules.enum")

local module = {}

---@private
local _functions = {}

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
local function pow(a, b)
    return a ^ b
end

-- tween func
function module:Tween(mode, direction, start, endd, progress)
    local tweened = _functions[mode](progress, direction)
    return multiplierToNormalNumber(tweened, start, endd)
end

-- populate to tween functions
-- Easing functions originally from https://easings.net
-- Original source licensed under GPL-3.0: https://github.com/ai/easings.net/blob/master/LICENSE
-- SPDX-License-Identifier: GPL-3.0-only
_functions.linear = function(x)
    return x -- lol
end
_functions.sine = function(x, dir)
    if dir == Enum.EasingDir.In then
        return 1 - math.cos((x * math.pi) / 2)
    elseif dir == Enum.EasingDir.Out then
        return math.sin((x * math.pi) / 2)
    elseif dir == Enum.EasingDir.InOut then
        return -(math.cos(math.pi * x) - 1) / 2
    else
        return 0
    end
end
_functions.quad = function(x, dir)
    if dir == Enum.EasingDir.In then
        return x * x
    elseif dir == Enum.EasingDir.Out then
        return 1 - (1 - x) * (1 - x)
    elseif dir == Enum.EasingDir.InOut then
        return test(x < 0.5, 2 * x * x, 1 - pow(-2 * x + 2, 2) / 2)
    else
        return 0
    end
end
_functions.cubic = function(x, dir)
    if dir == Enum.EasingDir.In then
        return x * x * x
    elseif dir == Enum.EasingDir.Out then
        return 1 - pow(1 - x, 3)
    elseif dir == Enum.EasingDir.InOut then
        return test(x < 0.5, 4 * x * x * x, 1 - pow(-2 * x + 2, 3) / 2)
    else
        return 0
    end
end
_functions.quart = function(x, dir)
    if dir == Enum.EasingDir.In then
        return x * x * x * x
    elseif dir == Enum.EasingDir.Out then
        return 1 - pow(1 - x, 4)
    elseif dir == Enum.EasingDir.InOut then
        return test(x < 0.5, 8 * x * x * x * x, 1 - pow(-2 * x + 2, 4) / 2)
    else
        return 0
    end
end
_functions.quint = function(x, dir)
    if dir == Enum.EasingDir.In then
        return x * x * x * x * x
    elseif dir == Enum.EasingDir.Out then
        return 1 - pow(1 - x, 5)
    elseif dir == Enum.EasingDir.InOut then
        return test(x < 0.5, 16 * x * x * x * x * x, 1 - pow(-2 * x + 2, 5) / 2)
    else
        return 0
    end
end
_functions.expo = function(x, dir)
    if dir == Enum.EasingDir.In then
        return test(x == 0, 0, pow(2, 10 * x - 10))
    elseif dir == Enum.EasingDir.Out then
        return test(x == 1, 1, 1 - pow(2, -10 * x))
    elseif dir == Enum.EasingDir.InOut then
        return test(x == 0
        , 0
        , test(x == 1
        , 1
        , test(x < 0.5, pow(2, 20 * x - 10) / 2
        , (2 - pow(2, -20 * x + 10)) / 2)))
    else
        return 0
    end
end
_functions.circ = function(x, dir)
    if dir == Enum.EasingDir.In then
        return 1 - math.sqrt(1 - pow(x, 2))
    elseif dir == Enum.EasingDir.Out then
        return math.sqrt(1 - pow(x - 1, 2))
    elseif dir == Enum.EasingDir.InOut then
        return test(x < 0.5
        , (1 - math.sqrt(1 - pow(2 * x, 2))) / 2
        , (math.sqrt(1 - pow(-2 * x + 2, 2)) + 1) / 2)
    else
        return 0
    end
end
_functions.back = function(x, dir)
    if dir == Enum.EasingDir.In then
        local c1 = 1.70158
        local c3 = c1 + 1

        return c3 * x * x * x - c1 * x * x
    elseif dir == Enum.EasingDir.Out then
        local c1 = 1.70158
        local c3 = c1 + 1

        return 1 + c3 * pow(x - 1, 3) + c1 * pow(x - 1, 2)
    elseif dir == Enum.EasingDir.InOut then
        local c1 = 1.70158
        local c2 = c1 * 1.525

        return test(x < 0.5
        , (pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2
        , (pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2)
    else
        return 0
    end
end
_functions.elastic = function(x, dir)
    if dir == Enum.EasingDir.In then
        local c4 = (2 * math.pi) / 3

        return test(x == 0
        , 0
        , test(x == 1
        , 1
        , -pow(2, 10 * x - 10) * math.sin((x * 10 - 10.75) * c4)))
    elseif dir == Enum.EasingDir.Out then
        local c4 = (2 * math.pi) / 3

        return test(x == 0
        , 0
        , test(x == 1
        , 1
        , pow(2, -10 * x) * math.sin((x * 10 - 0.75) * c4) + 1))
    elseif dir == Enum.EasingDir.InOut then
        local c5 = (2 * math.pi) / 4.5

        return test(x == 0
        , 0
        , test(x == 1
        , 1
        , test(x < 0.5
        , -(pow(2, 20 * x - 10) * math.sin((20 * x - 11.125) * c5)) / 2
        , (pow(2, -20 * x + 10) * math.sin((20 * x - 11.125) * c5)) / 2 + 1)))
    else
        return 0
    end
end
_functions.bounce = function(x, dir)
    if dir == Enum.EasingDir.In then
        return 1 - _functions.bounce(1 - x, Enum.EasingDir.Out)
    elseif dir == Enum.EasingDir.Out then
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
    elseif dir == Enum.EasingDir.InOut then
        return test(x < 0.5
        , (1 - _functions.bounce(1 - 2 * x, Enum.EasingDir.Out)) / 2
        , (1 + _functions.bounce(2 * x - 1, Enum.EasingDir.Out)) / 2)
    else
        return 0
    end
end

return module
