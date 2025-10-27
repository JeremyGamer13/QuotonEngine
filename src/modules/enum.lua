local QuotonEnum = require("src.engine.quoton-enum")
local Color = require("src.engine.quoton-color")

---@enum Enum
-- Enums represent values that may be commonly used in Quoton. You are intended to use these as inputs to other functions, for example.
--
-- Never use the literal value of an Enum or your code **will** break when switching platforms/libraries or updating your project.
local Enum = {
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

        -- EXPERIMENTAL: Intended RayLib Music API but may cause unexpected crashes and stuttering with certain audio files or certain platforms.
        --
        -- DO NOT USE THIS AUDIO TYPE IN FULL PROJECTS.
        --
        --[[
            NOTE: It seems like other people are unable to get this working consistently either.
            If someone gets it working with any audio file in a built project, this will become a TODO.
            Source: raylib support discord
        ]]
        ---@deprecated
        Music = "music",

        -- EXPERIMENTAL: Not fully implemented at this time.
        --
        -- DO NOT USE THIS AUDIO TYPE IN FULL PROJECTS.
        --
        -- TODO: Try to get raw audio working better.
        ---@deprecated
        Raw = "raw",
    },
    Color = {
        White = Color.New(255, 255, 255),
        Black = Color.New(0, 0, 0),

        Red = Color.New(255, 0, 0),
        Green = Color.New(0, 255, 0),
        Blue = Color.New(0, 0, 255),

        Yellow = Color.New(255, 255, 0),
        Cyan = Color.New(0, 255, 255),
        Magenta = Color.New(255, 0, 255),

        LightGray = Color.New(192, 192, 192),
        Gray = Color.New(128, 128, 128),
        DarkGray = Color.New(64, 64, 64),

        DarkRed = Color.New(139, 0, 0),
        LightRed = Color.New(255, 102, 102),
        DarkGreen = Color.New(0, 100, 0),
        LightGreen = Color.New(144, 238, 144),
        DarkBlue = Color.New(0, 0, 139),
        LightBlue = Color.New(173, 216, 230),
        DarkCyan = Color.New(0, 139, 139),
        LightCyan = Color.New(224, 255, 255),
        Purple = Color.New(128, 0, 128),
        Violet = Color.New(148, 0, 211),
        Pink = Color.New(255, 192, 203),
        HotPink = Color.New(255, 105, 180),
        Orange = Color.New(255, 165, 0),
        DarkOrange = Color.New(255, 140, 0),
        LightYellow = Color.New(255, 255, 224),
        Brown = Color.New(139, 69, 19),
        LightBrown = Color.New(205, 133, 63),
        DarkBrown = Color.New(101, 67, 33),
        Tan = Color.New(210, 180, 140),
        Beige = Color.New(245, 245, 220),
        Gold = Color.New(255, 215, 0),
        Silver = Color.New(192, 192, 192),
        Bronze = Color.New(205, 127, 50),
        Maroon = Color.New(128, 0, 0),
        Olive = Color.New(128, 128, 0),
        Teal = Color.New(0, 128, 128),
        Navy = Color.New(0, 0, 128),
        Indigo = Color.New(75, 0, 130),
        SkyBlue = Color.New(135, 206, 235),
        SeaGreen = Color.New(46, 139, 87),
        ForestGreen = Color.New(34, 139, 34),
        Lime = Color.New(50, 205, 50),
        Coral = Color.New(255, 127, 80),
        Salmon = Color.New(250, 128, 114),
        Khaki = Color.New(240, 230, 140),
        Mint = Color.New(189, 252, 201),
        Lavender = Color.New(230, 230, 250),
        Plum = Color.New(221, 160, 221),
        Turquoise = Color.New(64, 224, 208),
        Azure = Color.New(240, 255, 255),
        Crimson = Color.New(220, 20, 60),
        Snow = Color.New(255, 250, 250),
        Ivory = Color.New(255, 255, 240),
        Honeydew = Color.New(240, 255, 240),
        SlateGray = Color.New(112, 128, 144),
        LightSlateGray = Color.New(119, 136, 153),
        DarkSlateGray = Color.New(47, 79, 79),

        Blank = Color.New(0, 0, 0, 0),
    },
    ConfigFlags = {
        VSync = QuotonEnum.ConfigFlags.VSync, -- Try to enable V-Sync on the GPU. Only supported in raylib libraries.
        MSAA4x = QuotonEnum.ConfigFlags.MSAA4x, -- Only supported on initialization; Try to enable Multi Sampling Anti Aliasing 4x. Only supported in raylib libraries.
        AllowInterlacedVideo = QuotonEnum.ConfigFlags.EnableInterlacedVideo, -- Only supported on initialization; Try to enable interlaced video format. Only supported in raylib libraries.
        HighDPI = QuotonEnum.ConfigFlags.HighDPI, -- Only supported on initialization; Allows this window to support High DPI. Only supported for desktop platforms.

        FullscreenMode = QuotonEnum.ConfigFlags.VSyncHint, -- Run the program in fullscreen. Only supported for desktop platforms.
        BorderlessMode = QuotonEnum.ConfigFlags.VSyncHintOWED_MODE, -- Run the program in borderless windowed mode. Only supported for desktop platforms, not supported in all libraries.

        WindowResizable = QuotonEnum.ConfigFlags.WindowResizable, -- Makes the window resizable. Only supported for desktop platforms.
        WindowUndecorated = QuotonEnum.ConfigFlags.WindowUndecorated, -- Removes the window's frame & topbar. Only supported for desktop platforms.
        WindowHidden = QuotonEnum.ConfigFlags.WindowHidden, -- Makes the window not visible and not appear in the taskbar. Only supported for desktop platforms.
        WindowMinimized = QuotonEnum.ConfigFlags.WindowMinimized, -- Only supported after initialization; Minimize the window. Only supported for desktop platforms.
        WindowMaximized = QuotonEnum.ConfigFlags.WindowMaximized, -- Only supported after initialization; Maximize the window. Only supported for desktop platforms.
        WindowUnfocused = QuotonEnum.ConfigFlags.WindowUnfocused, -- Set the window to not be focused, like you clicked off of it. Only supported for desktop platforms.
        WindowTopMost = QuotonEnum.ConfigFlags.WindowTopMost, -- Forces the window to stay on top of other windows. Only supported for desktop platforms.
        WindowAlwaysRun = QuotonEnum.ConfigFlags.WindowAlwaysRun, -- Allow the window to run while minimized. Only supported for desktop platforms.
        WindowTransparent = QuotonEnum.ConfigFlags.WindowTransparent, -- Only supported on initialization; Allows a transparent window using a blank background color. Only supported for desktop platforms.
        WindowMousePassthrough = QuotonEnum.ConfigFlags.WindowMousePassthrough, -- Makes mouse events pass through the window, making the window not receive them. Only supported for desktop platforms.
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
        Point = QuotonEnum.FilterMode.Point,
        Bilinear = QuotonEnum.FilterMode.Bilinear,
        Trilinear = QuotonEnum.FilterMode.Trilinear,
        Anisotropic4x = QuotonEnum.FilterMode.Anisotropic4x,
        Anisotropic8x = QuotonEnum.FilterMode.Anisotropic8x,
        Anisotropic16x = QuotonEnum.FilterMode.Anisotropic16x,
    },
    InputGamepad = {
        -- Placeholder for an unknown pressed gamepad button.
        ButtonUnknown = QuotonEnum.InputGamepad.ButtonUnknown,

        ButtonLeftFaceUp = QuotonEnum.InputGamepad.ButtonLeftFaceUp, -- On Xbox One Controllers, this is DPad Up
        ButtonLeftFaceRight = QuotonEnum.InputGamepad.ButtonLeftFaceRight, -- On Xbox One Controllers, this is DPad Right
        ButtonLeftFaceDown = QuotonEnum.InputGamepad.ButtonLeftFaceDown, -- On Xbox One Controllers, this is DPad Down
        ButtonLeftFaceLeft = QuotonEnum.InputGamepad.ButtonLeftFaceLeft, -- On Xbox One Controllers, this is DPad left
        ButtonRightFaceUp = QuotonEnum.InputGamepad.ButtonRightFaceUp, -- On Xbox One Controllers, this is Y
        ButtonRightFaceRight = QuotonEnum.InputGamepad.ButtonRightFaceRight, -- On Xbox One Controllers, this is B
        ButtonRightFaceDown = QuotonEnum.InputGamepad.ButtonRightFaceDown, -- On Xbox One Controllers, this is A
        ButtonRightFaceLeft = QuotonEnum.InputGamepad.ButtonRightFaceLeft, -- On Xbox One Controllers, this is X
        ButtonLeftTrigger1 = QuotonEnum.InputGamepad.ButtonLeftTrigger1, -- On Xbox One Controllers, this is LB
        ButtonLeftTrigger2 = QuotonEnum.InputGamepad.ButtonLeftTrigger2, -- On Xbox One Controllers, this is LT
        ButtonRightTrigger1 = QuotonEnum.InputGamepad.ButtonRightTrigger1, -- On Xbox One Controllers, this is RB
        ButtonRightTrigger2 = QuotonEnum.InputGamepad.ButtonRightTrigger2, -- On Xbox One Controllers, this is RT
        ButtonMiddleLeft = QuotonEnum.InputGamepad.ButtonMiddleLeft, -- On Xbox One Controllers, this is Select
        ButtonMiddle = QuotonEnum.InputGamepad.ButtonMiddle, -- Usually voided by the OS. Likely meant to be the Guide button.
        ButtonMiddleRight = QuotonEnum.InputGamepad.ButtonMiddleRight, -- On Xbox One Controllers, this is Start
        ButtonLeftThumb = QuotonEnum.InputGamepad.ButtonLeftThumb,
        ButtonRightThumb = QuotonEnum.InputGamepad.ButtonRightThumb,

        AxisLeftX = QuotonEnum.InputGamepad.AxisLeftX,
        AxisLeftY = QuotonEnum.InputGamepad.AxisLeftY,
        AxisRightX = QuotonEnum.InputGamepad.AxisRightX,
        AxisRightY = QuotonEnum.InputGamepad.AxisRightY,
        AxisLeftTrigger = QuotonEnum.InputGamepad.AxisLeftTrigger,
        AxisRightTrigger = QuotonEnum.InputGamepad.AxisRightTrigger,
    },
    InputKey = {
        -- Placeholder for an unknown pressed key.
        Unknown = QuotonEnum.InputKey.Unknown,

        -- Alphanumeric symbols

        Apostrophe = QuotonEnum.InputKey.Apostrophe,
        Comma = QuotonEnum.InputKey.Comma,
        Minus = QuotonEnum.InputKey.Minus,
        Period = QuotonEnum.InputKey.Period,
        Slash = QuotonEnum.InputKey.Slash,
        LeftBracket = QuotonEnum.InputKey.LeftBracket,
        RightBracket = QuotonEnum.InputKey.RightBracket,
        Backslash = QuotonEnum.InputKey.Backslash,
        Grave = QuotonEnum.InputKey.Grave,
        Semicolon = QuotonEnum.InputKey.Semicolon,
        Equal = QuotonEnum.InputKey.Equal,

        -- Alphanumeric numbers

        Zero = QuotonEnum.InputKey.Zero,
        One = QuotonEnum.InputKey.One,
        Two = QuotonEnum.InputKey.Two,
        Three = QuotonEnum.InputKey.Three,
        Four = QuotonEnum.InputKey.Four,
        Five = QuotonEnum.InputKey.Five,
        Six = QuotonEnum.InputKey.Six,
        Seven = QuotonEnum.InputKey.Seven,
        Eight = QuotonEnum.InputKey.Eight,
        Nine = QuotonEnum.InputKey.Nine,

        -- Alphanumeric letters

        A = QuotonEnum.InputKey.A,
        B = QuotonEnum.InputKey.B,
        C = QuotonEnum.InputKey.C,
        D = QuotonEnum.InputKey.D,
        E = QuotonEnum.InputKey.E,
        F = QuotonEnum.InputKey.F,
        G = QuotonEnum.InputKey.G,
        H = QuotonEnum.InputKey.H,
        I = QuotonEnum.InputKey.I,
        J = QuotonEnum.InputKey.J,
        K = QuotonEnum.InputKey.K,
        L = QuotonEnum.InputKey.L,
        M = QuotonEnum.InputKey.M,
        N = QuotonEnum.InputKey.N,
        O = QuotonEnum.InputKey.O,
        P = QuotonEnum.InputKey.P,
        Q = QuotonEnum.InputKey.Q,
        R = QuotonEnum.InputKey.R,
        S = QuotonEnum.InputKey.S,
        T = QuotonEnum.InputKey.T,
        U = QuotonEnum.InputKey.U,
        V = QuotonEnum.InputKey.V,
        W = QuotonEnum.InputKey.W,
        X = QuotonEnum.InputKey.X,
        Y = QuotonEnum.InputKey.Y,
        Z = QuotonEnum.InputKey.Z,

        -- Arrow keys

        ArrowRight = QuotonEnum.InputKey.ArrowRight,
        ArrowLeft = QuotonEnum.InputKey.ArrowLeft,
        ArrowDown = QuotonEnum.InputKey.ArrowDown,
        ArrowUp = QuotonEnum.InputKey.ArrowUp,

        -- Functional keys

        Space = QuotonEnum.InputKey.Space,
        Escape = QuotonEnum.InputKey.Escape,
        Enter = QuotonEnum.InputKey.Enter,
        Tab = QuotonEnum.InputKey.Tab,
        Backspace = QuotonEnum.InputKey.Backspace,
        Insert = QuotonEnum.InputKey.Insert,
        Delete = QuotonEnum.InputKey.Delete,
        PageUp = QuotonEnum.InputKey.PageUp,
        PageDown = QuotonEnum.InputKey.PageDown,
        Home = QuotonEnum.InputKey.Home,
        End = QuotonEnum.InputKey.End,
        CapsLock = QuotonEnum.InputKey.CapsLock,
        ScrollLock = QuotonEnum.InputKey.ScrollLock,
        NumLock = QuotonEnum.InputKey.NumLock,
        PrintScreen = QuotonEnum.InputKey.PrintScreen,
        Pause = QuotonEnum.InputKey.Pause,
        LeftShift = QuotonEnum.InputKey.LeftShift,
        LeftControl = QuotonEnum.InputKey.LeftControl,
        LeftAlt = QuotonEnum.InputKey.LeftAlt,
        LeftSuper = QuotonEnum.InputKey.LeftSuper,
        RightShift = QuotonEnum.InputKey.RightShift,
        RightControl = QuotonEnum.InputKey.RightControl,
        RightAlt = QuotonEnum.InputKey.RightAlt,
        RightSuper = QuotonEnum.InputKey.RightSuper,

        F1 = QuotonEnum.InputKey.F1,
        F2 = QuotonEnum.InputKey.F2,
        F3 = QuotonEnum.InputKey.F3,
        F4 = QuotonEnum.InputKey.F4,
        F5 = QuotonEnum.InputKey.F5,
        F6 = QuotonEnum.InputKey.F6,
        F7 = QuotonEnum.InputKey.F7,
        F8 = QuotonEnum.InputKey.F8,
        F9 = QuotonEnum.InputKey.F9,
        F10 = QuotonEnum.InputKey.F10,
        F11 = QuotonEnum.InputKey.F11,
        F12 = QuotonEnum.InputKey.F12,

        -- Keypad keys

        KeypadZero = QuotonEnum.InputKey.KeypadZero,
        KeypadOne = QuotonEnum.InputKey.KeypadOne,
        KeypadTwo = QuotonEnum.InputKey.KeypadTwo,
        KeypadThree = QuotonEnum.InputKey.KeypadThree,
        KeypadFour = QuotonEnum.InputKey.KeypadFour,
        KeypadFive = QuotonEnum.InputKey.KeypadFive,
        KeypadSix = QuotonEnum.InputKey.KeypadSix,
        KeypadSeven = QuotonEnum.InputKey.KeypadSeven,
        KeypadEight = QuotonEnum.InputKey.KeypadEight,
        KeypadNine = QuotonEnum.InputKey.KeypadNine,
        KeypadMenu = QuotonEnum.InputKey.KeypadMenu,
        KeypadDecimal = QuotonEnum.InputKey.KeypadDecimal,
        KeypadDivide = QuotonEnum.InputKey.KeypadDivide,
        KeypadMultiply = QuotonEnum.InputKey.KeypadMultiply,
        KeypadSubtract = QuotonEnum.InputKey.KeypadSubtract,
        KeypadAdd = QuotonEnum.InputKey.KeypadAdd,
        KeypadEnter = QuotonEnum.InputKey.KeypadEnter,
        KeypadEqual = QuotonEnum.InputKey.KeypadEqual,

        -- Mobile menu keys

        MobileBack = QuotonEnum.InputKey.MobileBack,
        MobileMenu = QuotonEnum.InputKey.MobileMenu,
        MobileVolumeUp = QuotonEnum.InputKey.MobileVolumeUp,
        MobileVolumeDown = QuotonEnum.InputKey.MobileVolumeDown,
    },
    InputMouse = {
        Left = QuotonEnum.InputMouse.Left,
        Right = QuotonEnum.InputMouse.Right,
        Middle = QuotonEnum.InputMouse.Middle,

        -- Only present on certain mice. Not recommended to use as default controls. Can be the side-button for "Down" on some mice.
        Side = QuotonEnum.InputMouse.Side,

        -- Only present on certain mice. Not recommended to use as default controls. Can be the side-button for "Up" on some mice.
        Extra = QuotonEnum.InputMouse.Extra,

        -- Only present on certain mice. Not recommended to use as default controls.
        Forward = QuotonEnum.InputMouse.Forward,

        -- Only present on certain mice. Not recommended to use as default controls.
        Back = QuotonEnum.InputMouse.Back,
    },
    OpenFileMode = {
        Buffer = "buffer",
        Text = "text",
    },
    TraceLogLevel = {
        All = QuotonEnum.TraceLogLevel.All,
        Trace = QuotonEnum.TraceLogLevel.Trace,
        Debug = QuotonEnum.TraceLogLevel.Debug,
        Info = QuotonEnum.TraceLogLevel.Info,
        Warning = QuotonEnum.TraceLogLevel.Warning,
        Error = QuotonEnum.TraceLogLevel.Error,
        Fatal = QuotonEnum.TraceLogLevel.Fatal,
        None = QuotonEnum.TraceLogLevel.None,
    },
    WrapMode = {
        Repeat = QuotonEnum.WrapMode.Repeat,
        Clamp = QuotonEnum.WrapMode.Clamp,
        RepeatMirror = QuotonEnum.WrapMode.RepeatMirror,
        ClampMirror = QuotonEnum.WrapMode.ClampMirror,
    },
}

return Enum
