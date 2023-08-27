local RuntimeService = require("services.runtime")
local RayLib = require("raylib")

local module = {}

local waitingFunctions = {}
local waitingFunctionIds = {}
local currentId = 0

local function RemoveIfFound(tabl, item)
    for i, idd in pairs(tabl) do
        if idd == item then
            table.remove(tabl, i)
            return
        end
    end
end

module.Run = function(func)
    coroutine.resume(coroutine.create(function()
        func()
    end))
end
module.Wait = function(seconds, func)
    local id = "thread" .. tostring(currentId)
    currentId = currentId + 1
    table.insert(waitingFunctionIds, id)
    waitingFunctions[id] = {
        time = RayLib.GetTime() + seconds,
        callback = func
    }
end

-- used for the Wait function
-- kinda bad if we are on low FPS
-- but we likely couldnt accurately run at the time anyways if we were on low fps
RuntimeService.CreateStepHook(function()
    local time = RayLib.GetTime()
    for _, id in pairs(waitingFunctionIds) do
        local pack = waitingFunctions[id]
        if pack.time < time then
            -- remove from list
            RemoveIfFound(waitingFunctionIds, id)
            waitingFunctions[id] = nil
            -- run function since its been long enough
            module.Run(pack.callback)
        end
    end
end)

return module
