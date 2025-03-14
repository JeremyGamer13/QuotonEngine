local module = {}
module.initialConfig = {}

module._scripts = {}
module._listeners = {}

function module:SetGameScripts(gameScripts)
    module._scripts = gameScripts
end

-- pre pre stuff
function module:GetSetupSettings(inputSettings)
    local scripts = module._scripts

    for _, script in pairs(scripts) do
        if script.ModifyConfig then
            script:ModifyConfig(inputSettings)
        end
    end

    return inputSettings
end
function module:RunCustomSetup(settings)
    local scripts = module._scripts

    for _, script in pairs(scripts) do
        if script.SetCustomSetup then
            script:SetCustomSetup(settings)
        end
    end
end

-- pre stuff
function module:Initialize()
    local scripts = module._scripts

    for _, script in pairs(scripts) do
        if script.Initialize then
            script:Initialize()
        end
    end
end
function module:StartTick()
    local scripts = module._scripts

    for _, script in pairs(scripts) do
        if script.StartTick then
            script:StartTick()
        end
    end
end

function module:Unload()
    local scripts = module._scripts
    local listeners = module._listeners

    for _, listener in pairs(listeners) do
        listener()
    end

    for _, script in pairs(scripts) do
        if script.Unload then
            script:Unload()
        end
    end
end

-- event listener
function module:OnUnload(callback)
    local listeners = module._listeners
    table.insert(listeners, callback)
end

return module
