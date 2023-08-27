local RayLib = require("raylib")

local module = {}

module.IsDebug = true
module.StartedAsDebug = module.IsDebug
module.LoadingScreen = nil
module.FrameRate = 60

module.GetDeltaTime = function()
    local frameTime = RayLib.GetFrameTime()
    return 1 / ((1 / 60) / frameTime)
end

module._hookIds = {}
module._hooks = {
    prestep = {},
    step = {},
    poststep = {},
    predraw = {},
    draw = {},
    postdraw = {},
}

local function RunTable(table)
    for _, id in pairs(module._hookIds) do
        local func = table[id]
        if func then
            local success, result = pcall(function()
                func()
            end)
            if not success then
                print("ERROR IN RUNTIME HOOK:", result)
            end
        end
    end
end

-- run hooks in tables
module.RunPreStep = function() RunTable(module._hooks.prestep) end
module.RunStep = function() RunTable(module._hooks.step) end
module.RunPostStep = function() RunTable(module._hooks.poststep) end
module.RunPreDraw = function() RunTable(module._hooks.predraw) end
module.RunDraw = function() RunTable(module._hooks.draw) end
module.RunPostDraw = function() RunTable(module._hooks.postdraw) end

local _id = 0
local function CreateHookApi(id, hookTable)
    local api = {
        Hooked = true
    }
    api.Unhook = function()
        api.Hooked = false
        hookTable[id] = nil
        for i, idd in pairs(module._hookIds) do
            if idd == id then
                table.remove(module._hookIds, i)
                return
            end
        end
    end
    return api
end
local function HandleHookCreation(hookTable, func)
    -- add to id list & table
    local id = tostring(_id) .. "h"
    _id = _id + 1
    table.insert(module._hookIds, id)
    hookTable[id] = func
    -- create hook api
    return CreateHookApi(id, hookTable)
end

-- hooks
module.CreatePreStepHook = function(func)
    local hookTable = module._hooks.prestep
    return HandleHookCreation(hookTable, func)
end
module.CreateStepHook = function(func)
    local hookTable = module._hooks.step
    return HandleHookCreation(hookTable, func)
end
module.CreatePostStepHook = function(func)
    local hookTable = module._hooks.poststep
    return HandleHookCreation(hookTable, func)
end
module.CreatePreDrawHook = function(func)
    local hookTable = module._hooks.predraw
    return HandleHookCreation(hookTable, func)
end
module.CreateDrawHook = function(func)
    local hookTable = module._hooks.draw
    return HandleHookCreation(hookTable, func)
end
module.CreatePostDrawHook = function(func)
    local hookTable = module._hooks.postdraw
    return HandleHookCreation(hookTable, func)
end

return module
