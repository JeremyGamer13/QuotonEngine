local module = {}

module._ENV = "LuaJIT"
-- module._ENV = "Roblox"
module._VERSION = tonumber(_VERSION:match("%d+%.%d+")) or 0

module._ACCESS = {
	tableUnpack = module._VERSION >= 5.2
}

module.table = {}
module.table.join = function(tablee, seperator)
	return table.concat(tablee, seperator)
end
module.table.unpack = function(tablee, i, j)
	if module._ENV == "Roblox" then
		return table.unpack(tablee, i, j)
	end

	if module._ACCESS.tableUnpack then
		return table.unpack(tablee, i, j)
	else
		---@diagnostic disable-next-line: deprecated
		return unpack(tablee, i, j)
	end
end
module.table.filter = function(array, predicate)
	local result = {}
	for _, value in ipairs(array) do
		if predicate(value) then
			table.insert(result, value)
		end
	end
	return result
end
module.table.map = function(array, modify)
	local result = {}
	for _, value in ipairs(array) do
		table.insert(result, modify(value))
	end
	return result
end
module.table.reduce = function(array, callback, initialValue)
	local startIdx = 1
	local accumulator = initialValue

	if initialValue == nil then
		if #array == 0 then
			error("Reduce of empty table with no initial value")
		end
		accumulator = array[1]
		startIdx = 2
	end

	for i = startIdx, #array do
		accumulator = callback(accumulator, array[i])
	end

	return accumulator
end
module.table.reduceRight = function(array, callback, initialValue)
	local accumulator = initialValue
	local startIdx = #array

	if not initialValue then
		if #array == 0 then
			error("Reduce of empty table with no initial value")
		end
		accumulator = array[#array]
		startIdx = #array - 1
	end

	for i = startIdx, 1, -1 do
		accumulator = callback(accumulator, array[i])
	end

	return accumulator
end
module.table.some = function(array, callback)
	for i, value in ipairs(array) do
		if callback(value, i) then
			return true
		end
	end
	return false
end
module.table.every = function(array, callback)
	for i, value in ipairs(array) do
		if not callback(value, i) then
			return false
		end
	end
	return true
end
module.table.find = function(array, value, fromIndex)
    fromIndex = fromIndex or 1
    if fromIndex < 1 then
        fromIndex = 1
    end

	for index = fromIndex, #array do
        if array[index] == value then
            return index
        end
    end
    return nil
end
module.table.meets = function(array, callback)
	for i, value in ipairs(array) do
		if callback(value, i) then
			return value
		end
	end
	return nil
end
module.table.meetsLast = function(array, callback)
	for i = #array, 1, -1 do
		if callback(array[i], i) then
			return array[i]
		end
	end
	return nil
end
module.table.meetsIndex = function(array, callback)
	for index, value in ipairs(array) do
		if callback(value, index) then
			return index
		end
	end
	return nil
end
module.table.meetsLastIndex = function(array, callback)
	for i = #array, 1, -1 do
		if callback(array[i], i) then
			return i
		end
	end
	return nil
end
module.table.includes = function(array, searchElement, fromIndex)
    if module._ENV == "Roblox" then
        ---@diagnostic disable: undefined-field
        return table.find(array, searchElement, fromIndex) ~= nil
        ---@diagnostic enable: undefined-field
    end

	return module.table.find(array, searchElement, fromIndex) ~= nil
end
module.table.keys = function(array)
    local keys = {}
    for key, _ in pairs(array) do
        table.insert(keys, key)
    end
    return keys
end
module.table.values = function(array)
    local values = {}
    for _, value in pairs(array) do
        table.insert(values, value)
    end
    return values
end
module.table.lastIndexOf = function(array, searchElement, fromIndex)
	if not fromIndex then
		for i = #array, 1, -1 do
			if array[i] == searchElement then
				return i
			end
		end
	else
		if fromIndex > #array then
			fromIndex = #array
		elseif fromIndex < 1 then
			fromIndex = 1
		end
		for i = fromIndex, 1, -1 do
			if array[i] == searchElement then
				return i
			end
		end
	end
	return nil
end
module.table.slice = function(array, startIndex, endIndex)
	startIndex = startIndex or 1
	endIndex = endIndex or #array

	local slicedArray = {}
	local j = 1

	for i = startIndex, endIndex do
		slicedArray[j] = array[i]
		j = j + 1
	end

	return slicedArray
end
module.table.concat = function(...)
	local concatenated = {}
	local index = 1

	for _, array in ipairs({...}) do
		table.move(array, 1, #array, index, concatenated)
		index = index + #array
	end

	return concatenated
end
module.table.reverse = function(t)
	for i = 1, math.floor(#t / 2) do
		local j = #t - i + 1
		t[i], t[j] = t[j], t[i]
	end
end
module.table.fill = function(array, value, startIdx, endIdx)
	startIdx = startIdx or 1
	endIdx = endIdx or #array

	for i = startIdx, endIdx do
		array[i] = value
	end

	return array
end

module.string = {}
module.string.startsWith = function(str, prefix, startsAt)
	startsAt = startsAt or 1
	local substring = string.sub(str, startsAt, startsAt + #prefix - 1)
	return substring == prefix
end
module.string.endsWith = function(str, suffix, startsAt)
	startsAt = startsAt or #str - #suffix + 1
	local substring = string.sub(str, startsAt)
	return substring == suffix
end
module.string.trim = function(str)
	return string.match(str, "^%s*(.-)%s*$")
end
module.string.trimStart = function(str)
	return string.match(str, "^%s*(.-)$")
end
module.string.trimEnd = function(str)
	return string.match(str, "^(.-)%s*$")
end
module.string.split = function(str, delimiter)
    local result = {}
    local pattern = string.format("([^%s]*)%s?", delimiter, delimiter)
    for part in str:gmatch(pattern) do
        table.insert(result, part)
    end
    return result
end

module.math = {}
module.math.round = function(num)
	return math.floor(num + 0.5)
end
module.math.clamp = function(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    else
        return value
    end
end
module.math.lerp = function(current, target, amount)
	return current + amount * (target - current)
end
module.math.addPerSec = function(seconds, fps)
	return 1 / (fps * seconds)
end
module.math.distance = function(point1, point2)
	local dx = point2.x - point1.x
	local dy = point2.y - point1.y
	return math.sqrt(dx * dx + dy * dy)
end
module.math.distanceXY = function(x1, y1, x2, y2)
	local dx = x2 - x1
	local dy = y2 - y1
	return math.sqrt(dx * dx + dy * dy)
end

module.logic = {}
module.logic.test = function(condition, a, b)
	if condition then
		return a
	else
		return b
	end
end

if module._ENV == "Roblox" then
    ---@diagnostic disable: undefined-global
    module.logic.waitForUntil = function(callback, untilSeconds)
    	local timePassed = false
    	local functionDone = false
    	task.spawn(function()
    		task.wait(untilSeconds)
    		timePassed = true
    	end)
    	task.spawn(function()
    		callback()
    		functionDone = true
    	end)

    	while not (timePassed or functionDone) do
    		task.wait()
    	end
    end
    ---@diagnostic enable: undefined-global
end

return module
