local RayLib = require("raylib")

local module = {}

module._audios = {}
module._disposables = {}
module._disposablePaths = {}
module.SetVolume = function(volume)
    RayLib.SetMasterVolume(volume)
end
-- AudioService Create automatically unloads the audio once window is closed
module.Create = function(filepath)
    local audio = RayLib.LoadSound(filepath)
    table.insert(module._audios, audio)
    return audio
end
-- AudioService Disposable automatically unloads the audio once window is closed
-- and all file paths are the same sound
module.Disposable = function(filepath)
    if module._disposables[filepath] then
        -- we already loaded this sound
        return module._disposables[filepath]
    end
    print("creating disposable", filepath)
    local audio = RayLib.LoadSound(filepath)
    module._disposables[filepath] = audio
    table.insert(module._disposablePaths, filepath)
    return audio
end

module.Unload = function()
    print("unloading audio")
    for _, sound in pairs(module._audios) do
        RayLib.UnloadSound(sound)
    end
    for _, path in pairs(module._disposablePaths) do
        local sound = module._disposables[path]
        RayLib.UnloadSound(sound)
    end
end

return module
