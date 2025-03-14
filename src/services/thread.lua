local RuntimeService = require("src.services.runtime")
local libset = require("src.modules.libset")
local RayLib = require("raylib")

local module = {}

local waitingFunctions = {}
local waitingFunctionIds = {}
local currentId = 0

function module:Run(func)
    coroutine.resume(coroutine.create(function()
        func()
    end))
end
function module:Wait(seconds, func)
    local id = "thread" .. tostring(currentId)
    currentId = currentId + 1
    table.insert(waitingFunctionIds, id)
    waitingFunctions[id] = {
        time = RayLib.GetTime() + seconds,
        callback = func
    }
end

-- used for the Wait function
RuntimeService.OnStep:Connect(function()
    local time = RayLib.GetTime()
    for _, id in pairs(waitingFunctionIds) do
        local pack = waitingFunctions[id]
        if pack.time < time then
            -- remove from list
            local idx = libset.table.find(waitingFunctionIds, id)
            if idx then
                table.remove(waitingFunctionIds, idx)
            end
            waitingFunctions[id] = nil
            -- run function since its been long enough
            module:Run(pack.callback)
        end
    end
end)

return module
