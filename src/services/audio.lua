local EventService = require("src.services.event")
local RuntimeService = require("src.services.runtime")

local RayLib = require("raylib")
local libset = require("src.modules.libset")

local module = {
    forceCompatibility = false,

    ---@private
    _audio = {},
}
module.Enums = {
    AudioType = {
        -- Best compatibility with all systems.
        SOUND = "sound",

        -- Intended RayLib Music API but may cause unexpected crashes and stuttering with certain audio files or certain platforms.
        MUSIC = "music",

        ---@deprecated Not fully implemented at this time. DO NOT USE THIS AUDIO TYPE IN FULL PROJECTS.
        RAW = "raw",
    }
}

function module:SetMasterVolume(volume)
    RayLib.SetMasterVolume(volume)
end
function module:GetMasterVolume()
    return RayLib.GetMasterVolume()
end

function module:SetDefaultAudioStreamBufferSize(size)
    return RayLib.SetAudioStreamBufferSizeDefault(size)
end

local function CreateAudioGroupObject(optName)
    ---@class AudioGroup
    local AudioGroup = {
        _childGroups = {},
    }

    AudioGroup.Name = optName or ""
    AudioGroup.Volume = 1
    AudioGroup.VolumeChanged = EventService:CreateEvent("VolumeChanged")

    AudioGroup.Group = nil
    AudioGroup._volGroupListener = nil

    AudioGroup.IsAudioGroup = true

    ---@private If this audio group has a parent, it'll tell the parent to fire it's volume changed event. If we are the parent, we'll fire our volume changed event.
    function AudioGroup:RecurseUpdates()
        if self.Group then
            self.Group:RecurseUpdates()
        else
            -- print(self.Name, self.Volume, self.Volume)
            self.VolumeChanged:Emit(self.Volume, self.Volume)
        end
    end

    function AudioGroup:SetVolume(volume)
        self.Volume = volume
        self:RecurseUpdates()
    end
    function AudioGroup:SetGroup(group)
        if self.Group then
            local idx = libset.table.find(group._childGroups, self)
            if idx then
                table.remove(group._childGroups, idx)
            end
            self._volGroupListener:Disconnect()
        end

        -- when a group is parented to another group, we need to emit their volume updates to our children
        local myself = self
        self.Group = group

        if group == nil then
            myself.VolumeChanged:Emit(myself.Volume, myself.Volume)
        else
            self._volGroupListener = group.VolumeChanged:Connect(function(_, multVolume)
                -- print(group.Name, self.Name, myself.Name)
                -- print(_, multVolume)
                myself.VolumeChanged:Emit(myself.Volume, myself.Volume * multVolume)
            end)
            self:RecurseUpdates()
        end
    end

    return AudioGroup
end
local function CreateAudioObject(filePath, type, rawSampleRate, rawSampleSize, rawChannels)
    ---@class Audio
    local Audio = {}

    -- Music streams have a lot of stuttering problems at low FPS, even if they allow for some nice options.
    if module.forceCompatibility and type == module.Enums.AudioType.MUSIC then
        type = module.Enums.AudioType.SOUND
    end

    Audio.Type = type
    if type == module.Enums.AudioType.SOUND then
        Audio._node = RayLib.LoadSound(filePath)
    elseif type == module.Enums.AudioType.MUSIC then
        Audio._node = RayLib.LoadMusicStream(filePath)
    elseif type == module.Enums.AudioType.RAW then
        Audio._node = RayLib.LoadAudioStream(rawSampleRate, rawSampleSize, rawChannels)
    end

    Audio.Path = filePath
    Audio.Paused = false
    Audio.IsAudio = true

    Audio.Group = nil
    Audio._volGroupListener = nil

    Audio.Volume = 1
    Audio._multVolume = 1

    Audio._musicUpdateLoop = nil

    if type == module.Enums.AudioType.MUSIC or type == module.Enums.AudioType.RAW then
        if type == module.Enums.AudioType.RAW then
            -- Override this if needed. Should return true if the audio needs to update with RayLib.UpdateAudioStream()
            function Audio:NeedsToUpdate(_) return false end
            -- Override this if needed. Should return data, frameCount or return true if manually updated.
            function Audio:OnDataUpdate(_) return false end

            function Audio:SetStreamCallback(callback)
                RayLib.SetAudioStreamCallback(Audio._node, callback)
            end

            function Audio:IsProcessed()
                if self.Type ~= module.Enums.AudioType.RAW then
                    return self:IsReady()
                elseif self.Type == module.Enums.AudioType.RAW then
                    return RayLib.IsAudioStreamProcessed(self._node)
                end
            end
        elseif type == module.Enums.AudioType.MUSIC then
            function Audio:SeekToSeconds(seconds)
                RayLib.SeekMusicStream(self._node, seconds)
            end

            function Audio:GetLength()
                return RayLib.GetMusicTimeLength(self._node)
            end
            function Audio:GetCurrentSeconds()
                return RayLib.GetMusicTimePlayed(self._node)
            end
        end

        Audio._musicUpdateLoop = RuntimeService.OnPreStep:Connect(function()
            if type == module.Enums.AudioType.MUSIC then
                RayLib.UpdateMusicStream(Audio._node)
            elseif type == module.Enums.AudioType.RAW and Audio:NeedsToUpdate(Audio._node) then
                local data, frameCount = Audio:OnDataUpdate(Audio._node)
                if data ~= true then
                    RayLib.UpdateAudioStream(Audio._node, data, frameCount)
                end
            end
        end)
    end

    function Audio:IsReady()
        if self.Type == module.Enums.AudioType.SOUND then
            return RayLib.IsSoundReady(self._node)
        elseif self.Type == module.Enums.AudioType.MUSIC then
            return RayLib.IsMusicReady(self._node)
        elseif self.Type == module.Enums.AudioType.RAW then
            return RayLib.IsAudioStreamReady(self._node)
        end
    end
    function Audio:IsPlaying()
        if self.Type == module.Enums.AudioType.SOUND then
            return RayLib.IsSoundPlaying(self._node)
        elseif self.Type == module.Enums.AudioType.MUSIC then
            return RayLib.IsMusicStreamPlaying(self._node)
        elseif self.Type == module.Enums.AudioType.RAW then
            return RayLib.IsAudioStreamPlaying(self._node)
        end
    end

    ---@private Used to update the volume on the Audio node.
    function Audio:UpdateVolume()
        if self.Type == module.Enums.AudioType.SOUND then
            RayLib.SetSoundVolume(self._node, self._multVolume)
        elseif self.Type == module.Enums.AudioType.MUSIC then
            RayLib.SetMusicVolume(self._node, self._multVolume)
        elseif self.Type == module.Enums.AudioType.RAW then
            RayLib.SetAudioStreamVolume(self._node, self._multVolume)
        end
    end
    ---@private Used to set the volume based on a parent's audio group volume.
    function Audio:SetMultVolume(volume)
        self._multVolume = volume
        self:UpdateVolume()
    end
    function Audio:SetVolume(volume)
        self.Volume = volume
        if self.Group then
            self.Group:RecurseUpdates()
        else
            self._multVolume = volume
            self:UpdateVolume()
        end
    end

    function Audio:SetGroup(group)
        if self.Group then
            self._volGroupListener:Disconnect()
        end

        self.Group = group

        if group == nil then
            -- if we have no group, multVolume should now be the same as the audio's volume
            self:SetVolume(self.Volume)
        else
            self._volGroupListener = group.VolumeChanged:Connect(function(_, multVolume)
                self:SetMultVolume(self.Volume * multVolume)
            end)
            group:RecurseUpdates()
        end
    end

    function Audio:SetPitch(pitch)
        if self.Type == module.Enums.AudioType.SOUND then
            RayLib.SetSoundPitch(self._node, pitch)
        elseif self.Type == module.Enums.AudioType.MUSIC then
            RayLib.SetMusicPitch(self._node, pitch)
        elseif self.Type == module.Enums.AudioType.RAW then
            RayLib.SetAudioStreamPitch(self._node, pitch)
        end
    end

    function Audio:Play()
        if self.Type == module.Enums.AudioType.SOUND then
            RayLib.PlaySound(self._node)
        elseif self.Type == module.Enums.AudioType.MUSIC then
            RayLib.PlayMusicStream(self._node)
        elseif self.Type == module.Enums.AudioType.RAW then
            RayLib.PlayAudioStream(self._node)
        end
    end
    function Audio:Stop()
        self.Paused = false
        if self.Type == module.Enums.AudioType.SOUND then
            RayLib.StopSound(self._node)
        elseif self.Type == module.Enums.AudioType.MUSIC then
            RayLib.StopMusicStream(self._node)
        elseif self.Type == module.Enums.AudioType.RAW then
            RayLib.StopAudioStream(self._node)
        end
    end

    function Audio:Pause()
        if self:IsPlaying() then
            if self.Type == module.Enums.AudioType.SOUND then
                RayLib.PauseSound(self._node)
            elseif self.Type == module.Enums.AudioType.MUSIC then
                RayLib.PauseMusicStream(self._node)
            elseif self.Type == module.Enums.AudioType.RAW then
                RayLib.PauseAudioStream(self._node)
            end
            self.Paused = true
            return true
        end
        return false
    end
    function Audio:Resume()
        if self.Paused then
            if self.Type == module.Enums.AudioType.SOUND then
                RayLib.ResumeSound(self._node)
            elseif self.Type == module.Enums.AudioType.MUSIC then
                RayLib.ResumeMusicStream(self._node)
            elseif self.Type == module.Enums.AudioType.RAW then
                RayLib.ResumeAudioStream(self._node)
            end
            self.Paused = false
            return true
        end
        return false
    end

    function Audio:Unload()
        if self._musicUpdateLoop then
            self._musicUpdateLoop:Disconnect()
        end
        self:Stop()
        if self.Type == module.Enums.AudioType.SOUND then
            RayLib.UnloadSound(self._node)
        elseif self.Type == module.Enums.AudioType.MUSIC then
            RayLib.UnloadMusicStream(self._node)
        elseif self.Type == module.Enums.AudioType.RAW then
            RayLib.UnloadAudioStream(self._node)
        end
    end

    return Audio
end

function module:New(filepath, type)
    local audio = CreateAudioObject(filepath, type)
    table.insert(self._audio, audio)
    return audio
end
function module:NewRaw(sampleRate, sampleSize, channels)
    local audio = CreateAudioObject(
        nil,
        module.Enums.AudioType.RAW,
        sampleRate,
        sampleSize,
        channels
    )
    table.insert(self._audio, audio)
    return audio
end
function module:NewGroup(optName)
    local audioGroup = CreateAudioGroupObject(optName)
    return audioGroup
end

function module:UnloadAudio()
    print("Unloading Audio")
    for _, audio in pairs(self._audio) do
        audio:Unload()
    end
end

---@private
function module:Unload()
    module:UnloadAudio()
end

return module
