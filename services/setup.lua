local module = {}

local scripts = {
    require("scripts.test")
    -- require("scripts.title.title"),
    -- require("scripts.title.title_input"),
    -- require("scripts.options.options"),
    -- require("scripts.game.menu"),
    -- require("scripts.game.overworld")
}
module._scripts = scripts

local _listeners = {}

module.Initialize = function()
    for _, script in pairs(scripts) do
        if script.Initialize then
            script.Initialize()
        end
    end
end
module.StartTick = function()
    for _, script in pairs(scripts) do
        if script.StartTick then
            script.StartTick()
        end
    end
end
module.Unload = function()
    for _, listener in pairs(_listeners) do
        listener()
    end
    for _, script in pairs(scripts) do
        if script.Unload then
            script.Unload()
        end
    end
end
-- event listener
module.OnUnload = function(callback)
    table.insert(_listeners, callback)
end

return module
