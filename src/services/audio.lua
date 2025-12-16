local QuotonLibrary = require("src.engine.quoton-library")

local EventService = require("src.services.event")
local RuntimeService = require("src.services.runtime")

-- TODO: replace this
local RayLib = QuotonLibrary
local libset = require("src.modules.libset")
local Environment = require("src.modules.env")
local Enum = require("src.modules.enum")

-- (Temporary)
---@diagnostic disable: deprecated

local AudioService = {
    ---@private
    _audio = {},
}
-- Initialize
if Environment.LibraryAudio == "raylib-tsnake41" then
    local RayLib = QuotonLibrary
    ---@private
    function AudioService:Initialize()
        RayLib.InitAudioDevice()
        RayLib.SetAudioStreamBufferSizeDefault(4096)
    end
end

-- Master Volume
if Environment.LibraryAudio == "raylib-tsnake41" then
    local RayLib = QuotonLibrary
    -- Sets the volume for the whole application.
    function AudioService:SetMasterVolume(volume)
        RayLib.SetMasterVolume(volume)
    end
    -- Get the master volume for the whole application.
    function AudioService:GetMasterVolume()
        return RayLib.GetMasterVolume()
    end
end

local function CreateAudioGroupObject(name)
    libset.logic.assert(not not name, "Cannot create an AudioGroup with no name")

    ---@class AudioGroup
    local AudioGroup = {
        _childGroups = {},
    }

    AudioGroup.Name = name
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
        -- If 
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
    if AudioService.forceCompatibility and type == Enum.AudioType.Music then
        type = Enum.AudioType.Sound
    end

    Audio.Type = type
    if type == Enum.AudioType.Sound then
        Audio._node = RayLib.LoadSound(filePath)
    elseif type == Enum.AudioType.Music then
        Audio._node = RayLib.LoadMusicStream(filePath)
    elseif type == Enum.AudioType.Raw then
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

    if type == Enum.AudioType.Music or type == Enum.AudioType.Raw then
        if type == Enum.AudioType.Raw then
            -- Override this if needed. Should return true if the audio needs to update with RayLib.UpdateAudioStream()
            function Audio:NeedsToUpdate(_) return false end
            -- Override this if needed. Should return data, frameCount or return true if manually updated.
            function Audio:OnDataUpdate(_) return false end

            function Audio:SetStreamCallback(callback)
                RayLib.SetAudioStreamCallback(Audio._node, callback)
            end

            function Audio:IsProcessed()
                if self.Type ~= Enum.AudioType.Raw then
                    return self:IsReady()
                elseif self.Type == Enum.AudioType.Raw then
                    return RayLib.IsAudioStreamProcessed(self._node)
                end
            end
        elseif type == Enum.AudioType.Music then
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
            if type == Enum.AudioType.Music then
                RayLib.UpdateMusicStream(Audio._node)
            elseif type == Enum.AudioType.Raw and Audio:NeedsToUpdate(Audio._node) then
                local data, frameCount = Audio:OnDataUpdate(Audio._node)
                if data ~= true then
                    RayLib.UpdateAudioStream(Audio._node, data, frameCount)
                end
            end
        end)
    end

    function Audio:IsReady()
        if self.Type == Enum.AudioType.Sound then
            return RayLib.IsSoundReady(self._node)
        elseif self.Type == Enum.AudioType.Music then
            return RayLib.IsMusicReady(self._node)
        elseif self.Type == Enum.AudioType.Raw then
            return RayLib.IsAudioStreamReady(self._node)
        end
    end
    function Audio:IsPlaying()
        if self.Type == Enum.AudioType.Sound then
            return RayLib.IsSoundPlaying(self._node)
        elseif self.Type == Enum.AudioType.Music then
            return RayLib.IsMusicStreamPlaying(self._node)
        elseif self.Type == Enum.AudioType.Raw then
            return RayLib.IsAudioStreamPlaying(self._node)
        end
    end

    ---@private Used to update the volume on the Audio node.
    function Audio:UpdateVolume()
        if self.Type == Enum.AudioType.Sound then
            RayLib.SetSoundVolume(self._node, self._multVolume)
        elseif self.Type == Enum.AudioType.Music then
            RayLib.SetMusicVolume(self._node, self._multVolume)
        elseif self.Type == Enum.AudioType.Raw then
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
        if self.Type == Enum.AudioType.Sound then
            RayLib.SetSoundPitch(self._node, pitch)
        elseif self.Type == Enum.AudioType.Music then
            RayLib.SetMusicPitch(self._node, pitch)
        elseif self.Type == Enum.AudioType.Raw then
            RayLib.SetAudioStreamPitch(self._node, pitch)
        end
    end

    function Audio:Play()
        if self.Type == Enum.AudioType.Sound then
            RayLib.PlaySound(self._node)
        elseif self.Type == Enum.AudioType.Music then
            RayLib.PlayMusicStream(self._node)
        elseif self.Type == Enum.AudioType.Raw then
            RayLib.PlayAudioStream(self._node)
        end
    end
    function Audio:Stop()
        self.Paused = false
        if self.Type == Enum.AudioType.Sound then
            RayLib.StopSound(self._node)
        elseif self.Type == Enum.AudioType.Music then
            RayLib.StopMusicStream(self._node)
        elseif self.Type == Enum.AudioType.Raw then
            RayLib.StopAudioStream(self._node)
        end
    end

    function Audio:Pause()
        if self:IsPlaying() then
            if self.Type == Enum.AudioType.Sound then
                RayLib.PauseSound(self._node)
            elseif self.Type == Enum.AudioType.Music then
                RayLib.PauseMusicStream(self._node)
            elseif self.Type == Enum.AudioType.Raw then
                RayLib.PauseAudioStream(self._node)
            end
            self.Paused = true
            return true
        end
        return false
    end
    function Audio:Resume()
        if self.Paused then
            if self.Type == Enum.AudioType.Sound then
                RayLib.ResumeSound(self._node)
            elseif self.Type == Enum.AudioType.Music then
                RayLib.ResumeMusicStream(self._node)
            elseif self.Type == Enum.AudioType.Raw then
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
        if self.Type == Enum.AudioType.Sound then
            RayLib.UnloadSound(self._node)
        elseif self.Type == Enum.AudioType.Music then
            RayLib.UnloadMusicStream(self._node)
        elseif self.Type == Enum.AudioType.Raw then
            RayLib.UnloadAudioStream(self._node)
        end
    end

    return Audio
end

function AudioService:NewGroup(name)
    local audioGroup = CreateAudioGroupObject(name)
    return audioGroup
end
function AudioService:NewSource(filepath, type)
    local audio = CreateAudioObject(filepath, type)
    table.insert(self._audio, audio)
    return audio
end
function AudioService:NewRaw(sampleRate, sampleSize, channels)
    local audio = CreateAudioObject(
        nil,
        Enum.AudioType.Raw,
        sampleRate,
        sampleSize,
        channels
    )
    table.insert(self._audio, audio)
    return audio
end

function AudioService:UnloadCreatedAudio()
    print("Unloading Audio")
    for _, audio in pairs(self._audio) do
        audio:Unload()
    end
end
---@private
function AudioService:Unload()
    AudioService:UnloadAudio()
end

return AudioService
