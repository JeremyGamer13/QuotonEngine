local RayLib = require("raylib")
local RayLua = require("raylua")
local libset = require("src.modules.libset")

local module = {
    AlignPosition = {
        Left = "left",
        Right = "right",
        Top = "top",
        Bottom = "bottom",
        Center = "center",
    },
    AudioType = {
        -- Best compatibility with all systems.
        Sound = "sound",

        -- Intended RayLib Music API but may cause unexpected crashes and stuttering with certain audio files or certain platforms. DO NOT USE THIS AUDIO TYPE IN FULL PROJECTS.
        --[[
            NOTE: It seems like other people are unable to get this working consistently either.
            If someone gets it working with any audio file in a built project, this will become a TODO.
            Source: raylib support discord
        ]]
        ---@deprecated
        Music = "music",

        -- EXPERIMENTAL: Not fully implemented at this time. DO NOT USE THIS AUDIO TYPE IN FULL PROJECTS.
        -- TODO: Try to get raw audio working better.
        ---@deprecated
        Raw = "raw",
    },
    ConfigFlags = {
        VSyncHint = RayLib.FLAG_VSYNC_HINT, -- Unknown behavior/purpose
        MSAA4xHint = RayLib.FLAG_MSAA_4X_HINT, -- Only supported on initialization; Enables Multi Sampling Anti Aliasing 4x
        InterlacedHint = RayLib.FLAG_INTERLACED_HINT, -- Unknown behavior/purpose

        FullscreenMode = RayLib.FLAG_FULLSCREEN_MODE, -- Untested behavior/purpose, docs state it's broken & causes wrong scaling

        WindowResizable = RayLib.FLAG_WINDOW_RESIZABLE, -- Makes the window resizable
        WindowUndecorated = RayLib.FLAG_WINDOW_UNDECORATED, -- Removes the window's frame & topbar
        WindowHidden = RayLib.FLAG_WINDOW_HIDDEN, -- Makes the window not visible and not appear in the taskbar.
        WindowMinimized = RayLib.FLAG_WINDOW_MINIMIZED, -- Only supported after initialization; Untested behavior/purpose
        WindowMaximized = RayLib.FLAG_WINDOW_MAXIMIZED, -- Only supported after initialization; Untested behavior/purpose
        WindowUnfocused = RayLib.FLAG_WINDOW_UNFOCUSED, -- Untested behavior/purpose
        WindowTopMost = RayLib.FLAG_WINDOW_TOPMOST, -- Forces the window to stay on top of other windows.
        WindowAlwaysRun = RayLib.FLAG_WINDOW_ALWAYS_RUN, -- Unknown behavior/purpose
        WindowTransparent = RayLib.FLAG_WINDOW_TRANSPARENT, -- Only supported on initialization; Untested behavior/purpose
        WindowHighDPI = RayLib.FLAG_WINDOW_HIGHDPI, -- Only supported on initialization; Untested behavior/purpose, docs state "errors after minimize-resize, fb size is recalculated"
        WindowMousePassthrough = RayLib.FLAG_WINDOW_MOUSE_PASSTHROUGH, -- Makes mouse events pass through the window, making the window not receive them
    },
    EasingDir = {
        In = "in",
        Out = "out",
        InOut = "inout",
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
    FillMode = {
        Crop = "crop",
        Fit = "fit",
        Stretch = "stretch",
    },
    FilterMode = {
        Point = RayLib.TEXTURE_FILTER_POINT,
        Bilinear = RayLib.TEXTURE_FILTER_BILINEAR,
        Trilinear = RayLib.TEXTURE_FILTER_TRILINEAR,
        Anisotropic4x = RayLib.TEXTURE_FILTER_ANISOTROPIC_4X,
        Anisotropic8x = RayLib.TEXTURE_FILTER_ANISOTROPIC_8X,
        Anisotropic16x = RayLib.TEXTURE_FILTER_ANISOTROPIC_16X,
    },
    OpenFileMode = {
        Buffer = "buffer",
        Text = "text",
    },
    TraceLogLevel = {
        All = RayLib.LOG_ALL,
        Trace = RayLib.LOG_TRACE,
        Debug = RayLib.LOG_DEBUG,
        Info = RayLib.LOG_INFO,
        Warning = RayLib.LOG_WARNING,
        Error = RayLib.LOG_ERROR,
        Fatal = RayLib.LOG_FATAL,
        None = RayLib.LOG_NONE,
    },
    WrapMode = {
        Repeat = RayLib.TEXTURE_WRAP_REPEAT,
        Clamp = RayLib.TEXTURE_WRAP_CLAMP,
        RepeatMirror = RayLib.TEXTURE_WRAP_MIRROR_REPEAT,
        ClampMirror = RayLib.TEXTURE_WRAP_MIRROR_CLAMP,
    },
}

return module