local RayLib = require("raylib")
local RayLua = require("raylua")
local libset = require("src.modules.libset")

-- Enums represent values that may be commonly used in Quoton. You are intended to use these as inputs to other functions, for example.
--
-- Never use the literal value of an Enum or your code **will** break in the future.
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
    InputGamepad = {
        -- Placeholder for an unknown pressed gamepad button.
        ButtonUnknown = RayLib.GAMEPAD_BUTTON_UNKNOWN,

        ButtonLeftFaceUp = RayLib.GAMEPAD_BUTTON_LEFT_FACE_UP, -- On Xbox One Controllers, this is DPad Up
        ButtonLeftFaceRight = RayLib.GAMEPAD_BUTTON_LEFT_FACE_RIGHT, -- On Xbox One Controllers, this is DPad Right
        ButtonLeftFaceDown = RayLib.GAMEPAD_BUTTON_LEFT_FACE_DOWN, -- On Xbox One Controllers, this is DPad Down
        ButtonLeftFaceLeft = RayLib.GAMEPAD_BUTTON_LEFT_FACE_LEFT, -- On Xbox One Controllers, this is DPad left
        ButtonRightFaceUp = RayLib.GAMEPAD_BUTTON_RIGHT_FACE_UP, -- On Xbox One Controllers, this is Y
        ButtonRightFaceRight = RayLib.GAMEPAD_BUTTON_RIGHT_FACE_RIGHT, -- On Xbox One Controllers, this is B
        ButtonRightFaceDown = RayLib.GAMEPAD_BUTTON_RIGHT_FACE_DOWN, -- On Xbox One Controllers, this is A
        ButtonRightFaceLeft = RayLib.GAMEPAD_BUTTON_RIGHT_FACE_LEFT, -- On Xbox One Controllers, this is X
        ButtonLeftTrigger1 = RayLib.GAMEPAD_BUTTON_LEFT_TRIGGER_1, -- On Xbox One Controllers, this is LB
        ButtonLeftTrigger2 = RayLib.GAMEPAD_BUTTON_LEFT_TRIGGER_2, -- On Xbox One Controllers, this is LT
        ButtonRightTrigger1 = RayLib.GAMEPAD_BUTTON_RIGHT_TRIGGER_1, -- On Xbox One Controllers, this is RB
        ButtonRightTrigger2 = RayLib.GAMEPAD_BUTTON_RIGHT_TRIGGER_2, -- On Xbox One Controllers, this is RT
        ButtonMiddleLeft = RayLib.GAMEPAD_BUTTON_MIDDLE_LEFT, -- On Xbox One Controllers, this is Select
        ButtonMiddle = RayLib.GAMEPAD_BUTTON_MIDDLE, -- Usually voided by the OS. Likely meant to be the Guide button.
        ButtonMiddleRight = RayLib.GAMEPAD_BUTTON_MIDDLE_RIGHT, -- On Xbox One Controllers, this is Start
        ButtonLeftThumb = RayLib.GAMEPAD_BUTTON_LEFT_THUMB,
        ButtonRightThumb = RayLib.GAMEPAD_BUTTON_RIGHT_THUMB,

        AxisLeftX = RayLib.GAMEPAD_AXIS_LEFT_X,
        AxisLeftY = RayLib.GAMEPAD_AXIS_LEFT_Y,
        AxisRightX = RayLib.GAMEPAD_AXIS_RIGHT_X,
        AxisRightY = RayLib.GAMEPAD_AXIS_RIGHT_Y,
        AxisLeftTrigger = RayLib.GAMEPAD_AXIS_LEFT_TRIGGER,
        AxisRightTrigger = RayLib.GAMEPAD_AXIS_RIGHT_TRIGGER,
    },
    InputKey = {
        -- Placeholder for an unknown pressed key.
        Unknown = RayLib.KEY_NULL,

        -- Alphanumeric symbols

        Apostrophe = RayLib.KEY_APOSTROPHE,
        Comma = RayLib.KEY_COMMA,
        Minus = RayLib.KEY_MINUS,
        Period = RayLib.KEY_PERIOD,
        Slash = RayLib.KEY_SLASH,
        LeftBracket = RayLib.KEY_LEFT_BRACKET,
        RightBracket = RayLib.KEY_RIGHT_BRACKET,
        Backslash = RayLib.KEY_BACKSLASH,
        Grave = RayLib.KEY_GRAVE,
        Semicolon = RayLib.KEY_SEMICOLON,
        Equal = RayLib.KEY_EQUAL,

        -- Alphanumeric numbers

        Zero = RayLib.KEY_ZERO,
        One = RayLib.KEY_ONE,
        Two = RayLib.KEY_TWO,
        Three = RayLib.KEY_THREE,
        Four = RayLib.KEY_FOUR,
        Five = RayLib.KEY_FIVE,
        Six = RayLib.KEY_SIX,
        Seven = RayLib.KEY_SEVEN,
        Eight = RayLib.KEY_EIGHT,
        Nine = RayLib.KEY_NINE,

        -- Alphanumeric letters

        A = RayLib.KEY_A,
        B = RayLib.KEY_B,
        C = RayLib.KEY_C,
        D = RayLib.KEY_D,
        E = RayLib.KEY_E,
        F = RayLib.KEY_F,
        G = RayLib.KEY_G,
        H = RayLib.KEY_H,
        I = RayLib.KEY_I,
        J = RayLib.KEY_J,
        K = RayLib.KEY_K,
        L = RayLib.KEY_L,
        M = RayLib.KEY_M,
        N = RayLib.KEY_N,
        O = RayLib.KEY_O,
        P = RayLib.KEY_P,
        Q = RayLib.KEY_Q,
        R = RayLib.KEY_R,
        S = RayLib.KEY_S,
        T = RayLib.KEY_T,
        U = RayLib.KEY_U,
        V = RayLib.KEY_V,
        W = RayLib.KEY_W,
        X = RayLib.KEY_X,
        Y = RayLib.KEY_Y,
        Z = RayLib.KEY_Z,

        -- Arrow keys

        ArrowRight = RayLib.KEY_RIGHT,
        ArrowLeft = RayLib.KEY_LEFT,
        ArrowDown = RayLib.KEY_DOWN,
        ArrowUp = RayLib.KEY_UP,

        -- Functional keys

        Space = RayLib.KEY_SPACE,
        Escape = RayLib.KEY_ESCAPE,
        Enter = RayLib.KEY_ENTER,
        Tab = RayLib.KEY_TAB,
        Backspace = RayLib.KEY_BACKSPACE,
        Insert = RayLib.KEY_INSERT,
        Delete = RayLib.KEY_DELETE,
        PageUp = RayLib.KEY_PAGE_UP,
        PageDown = RayLib.KEY_PAGE_DOWN,
        Home = RayLib.KEY_HOME,
        End = RayLib.KEY_END,
        CapsLock = RayLib.KEY_CAPS_LOCK,
        ScrollLock = RayLib.KEY_SCROLL_LOCK,
        NumLock = RayLib.KEY_NUM_LOCK,
        PrintScreen = RayLib.KEY_PRINT_SCREEN,
        Pause = RayLib.KEY_PAUSE,
        LeftShift = RayLib.KEY_LEFT_SHIFT,
        LeftControl = RayLib.KEY_LEFT_CONTROL,
        LeftAlt = RayLib.KEY_LEFT_ALT,
        LeftSuper = RayLib.KEY_LEFT_SUPER,
        RightShift = RayLib.KEY_RIGHT_SHIFT,
        RightControl = RayLib.KEY_RIGHT_CONTROL,
        RightAlt = RayLib.KEY_RIGHT_ALT,
        RightSuper = RayLib.KEY_RIGHT_SUPER,

        F1 = RayLib.KEY_F1,
        F2 = RayLib.KEY_F2,
        F3 = RayLib.KEY_F3,
        F4 = RayLib.KEY_F4,
        F5 = RayLib.KEY_F5,
        F6 = RayLib.KEY_F6,
        F7 = RayLib.KEY_F7,
        F8 = RayLib.KEY_F8,
        F9 = RayLib.KEY_F9,
        F10 = RayLib.KEY_F10,
        F11 = RayLib.KEY_F11,
        F12 = RayLib.KEY_F12,

        -- Keypad keys

        KeypadZero = RayLib.KEY_KP_0,
        KeypadOne = RayLib.KEY_KP_1,
        KeypadTwo = RayLib.KEY_KP_2,
        KeypadThree = RayLib.KEY_KP_3,
        KeypadFour = RayLib.KEY_KP_4,
        KeypadFive = RayLib.KEY_KP_5,
        KeypadSix = RayLib.KEY_KP_6,
        KeypadSeven = RayLib.KEY_KP_7,
        KeypadEight = RayLib.KEY_KP_8,
        KeypadNine = RayLib.KEY_KP_9,
        KeypadMenu = RayLib.KEY_KB_MENU,
        KeypadDecimal = RayLib.KEY_KP_DECIMAL,
        KeypadDivide = RayLib.KEY_KP_DIVIDE,
        KeypadMultiply = RayLib.KEY_KP_MULTIPLY,
        KeypadSubtract = RayLib.KEY_KP_SUBTRACT,
        KeypadAdd = RayLib.KEY_KP_ADD,
        KeypadEnter = RayLib.KEY_KP_ENTER,
        KeypadEqual = RayLib.KEY_KP_EQUAL,

        -- Mobile menu keys

        MobileBack = RayLib.KEY_BACK,
        MobileMenu = RayLib.KEY_MENU,
        MobileVolumeUp = RayLib.KEY_VOLUME_UP,
        MobileVolumeDown = RayLib.KEY_VOLUME_DOWN,
    },
    InputMouse = {
        Left = RayLib.MOUSE_BUTTON_LEFT,
        Right = RayLib.MOUSE_BUTTON_RIGHT,
        Middle = RayLib.MOUSE_BUTTON_MIDDLE,

        -- Only present on certain mice. Not recommended to use as default controls. Can be the side-button for "Down" on some mice.
        Side = RayLib.MOUSE_BUTTON_SIDE,

        -- Only present on certain mice. Not recommended to use as default controls. Can be the side-button for "Up" on some mice.
        Extra = RayLib.MOUSE_BUTTON_EXTRA,

        -- Only present on certain mice. Not recommended to use as default controls.
        Forward = RayLib.MOUSE_BUTTON_FORWARD,

        -- Only present on certain mice. Not recommended to use as default controls.
        Back = RayLib.MOUSE_BUTTON_BACK,
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

return Enum
