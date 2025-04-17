local RayLib = require("raylib")
local RayLua = require("raylua")
local libset = require("src.modules.libset")

local module = {
    AudioType = {
        -- Best compatibility with all systems.
        SOUND = "sound",

        -- Intended RayLib Music API but may cause unexpected crashes and stuttering with certain audio files or certain platforms. DO NOT USE THIS AUDIO TYPE IN FULL PROJECTS.
        --[[
            NOTE: It seems like other people are unable to get this working consistently either.
            If someone gets it working with any audio file in a built project, this will become a TODO.
            Source: raylib support discord
        ]]
        ---@deprecated
        MUSIC = "music",

        -- EXPERIMENTAL: Not fully implemented at this time. DO NOT USE THIS AUDIO TYPE IN FULL PROJECTS.
        -- TODO: Try to get raw audio working better.
        ---@deprecated
        RAW = "raw",
    },
    FillMode = {
        Crop = "crop",
        Fit = "fit",
        Stretch = "stretch",
    },
    AlignPosition = {
        Left = "left",
        Right = "right",
        Top = "top",
        Bottom = "bottom",
        Center = "center",
    },
    EasingMode = {
        Linear = "linear",
        Sine = "sine",
        Quad = "quad",
        Cubic = "cubic",
        Quart = "quart",
        Quint = "quint",
        Expo = "expo",
        Circ = "circ",
        Back = "back",
        Elastic = "elastic",
        Bounce = "bounce",
    },
    EasingDir = {
        In = "in",
        Out = "out",
        InOut = "inout",
    },
    OpenFileMode = {
        Buffer = "buffer",
        Text = "text",
    },
}

return module