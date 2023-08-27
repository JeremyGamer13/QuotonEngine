local InputService = require("services.input")
local RuntimeService = require("services.runtime")
local TransmitterService = require("services.transmitter")

local RayLib = require("raylib")
local RayLua = require("raylua")

local script = {}
script.Initialize = function()
    print("loaded title script")
end

local menuStage = 0
local pickedSlot = 0
-- fire listeners
local function FireEvent(type)
    TransmitterService.FireListeners(type)
end

local PlayRect = RayLua.Rectangle(983, 391, 1254 - 983, 533 - 391)
local PlaySlotRect = RayLua.Rectangle(986, 555, 1250 - 986, 691 - 555)
local OptionsRect = RayLua.Rectangle(983, 555, 1254 - 983, 692 - 555)
local BackRect = RayLua.Rectangle(26, 25, 299 - 26, 168 - 25)

local QuitScreenRects = {
    Quit = RayLua.Rectangle(506, 289, 772 - 506, 426 - 289),
    Back = RayLua.Rectangle(506, 472, 772 - 506, 607 - 289)
}

local SlotPickRects = {
    RayLua.Rectangle(445, 309, 390, 101),
    RayLua.Rectangle(445, 417, 390, 101),
    RayLua.Rectangle(445, 525, 390, 101),
}
local SlotTrashRects = {
    RayLua.Rectangle(850, 334, 48, 48),
    RayLua.Rectangle(850, 443, 48, 48),
    RayLua.Rectangle(850, 550, 48, 48),
}

local CharacterRects = {
    RayLua.Rectangle(51, 289, 232 - 51, 715 - 289),
    RayLua.Rectangle(309, 248, 492 - 309, 685 - 248),
    RayLua.Rectangle(92, 143, 326 - 92, 539 - 143),
}
local hook = RuntimeService.CreateStepHook(function()
    -- stage -1 (quit screen)
    if menuStage == -1 then
        if
            RayLib.IsKeyPressed(RayLib.KEY_ESCAPE)
            or (
                InputService.MouseWithin(QuitScreenRects.Quit)
                and RayLib.IsMouseButtonPressed(RayLua.MOUSE_LEFT_BUTTON)
            )
        then
            print("QUIT PROGRAM")
            FireEvent("PROCESS_EXIT")
            return
        end
        if
            InputService.MouseWithin(QuitScreenRects.Back)
            and RayLib.IsMouseButtonPressed(RayLua.MOUSE_LEFT_BUTTON)
        then
            print("BACK to stage 0")
            menuStage = 0
            FireEvent("MENU_TITLE_BACKTOPLAY")
            return
        end
    end
    -- stage 1 or 2
    if menuStage == 1 or menuStage == 2 then
        if
            InputService.MouseWithin(BackRect)
            and RayLib.IsMouseButtonPressed(RayLua.MOUSE_LEFT_BUTTON)
        then
            print("BACK to stage 0")
            menuStage = 0
            FireEvent("MENU_TITLE_BACKTOPLAY")
            return
        end
    end
    -- stage 3 back button
    if menuStage == 3 then
        if
            InputService.MouseWithin(BackRect)
            and RayLib.IsMouseButtonPressed(RayLua.MOUSE_LEFT_BUTTON)
        then
            print("BACK to stage 2")
            menuStage = 2
            FireEvent("MENU_TITLE_BACKTOPICKER")
            return
        end
    end
    -- stage 1 (settings)
    -- only debug settings are handled here
    -- normal ones are handled in options.lua
    if menuStage == 1 and RuntimeService.StartedAsDebug then
        if
            InputService.MouseWithin(RayLua.Rectangle(685, 641, 64, 64))
            and RayLib.IsMouseButtonPressed(RayLua.MOUSE_LEFT_BUTTON)
        then
            RuntimeService.IsDebug = not RuntimeService.IsDebug
            print("DEBUG", RuntimeService.IsDebug)
        end
    end
    -- stage 2 (slot picker)
    -- basically just wait for a slot to be picked to move to stage 3
    if menuStage == 2 then
        for i, rect in pairs(SlotPickRects) do
            if
                InputService.MouseWithin(rect)
                and RayLib.IsMouseButtonPressed(RayLua.MOUSE_LEFT_BUTTON)
            then
                print("USE SLOT", i)
                menuStage = 3
                FireEvent("MENU_TITLE_SLOTPICKED_" .. tostring(i))
                break
            end
        end
        -- if mouse is pressed within the trash rect, fire progress event
        for i, rect in pairs(SlotTrashRects) do
            if
                InputService.MouseWithin(rect)
                and RayLib.IsMouseButtonPressed(RayLua.MOUSE_LEFT_BUTTON)
            then
                print("PROGRESS DELETE SLOT", i)
                FireEvent("MENU_TITLE_SLOTPROGRESSDELETING_" .. tostring(i))
                break
            end
        end
        -- if mouse goes up, check if its within a trash rect
        -- if its within one, tell the title script to check if progress is 100
        -- if so, then the slot will be deleted
        if RayLib.IsMouseButtonReleased(RayLua.MOUSE_LEFT_BUTTON) then
            -- loop will break if it is found within a rect
            for i, rect in pairs(SlotTrashRects) do
                if InputService.MouseWithin(rect) then
                    print("CHECK TO DELETE SLOT", i)
                    FireEvent("MENU_TITLE_SLOTCHECKDELETE_" .. tostring(i))
                    break
                end
            end
            -- loop didnt break so we didnt find the mouse within one
            print("RESET SLOT DELETE PROGRESS")
            FireEvent("MENU_TITLE_SLOTDELETINGRESET")
        end
    end
    -- stage 3
    if menuStage == 3 then
        if
            InputService.MouseWithin(PlaySlotRect)
            and RayLib.IsMouseButtonPressed(RayLua.MOUSE_LEFT_BUTTON)
        then
            print("LOAD GAME")
            FireEvent("MENU_TITLE_LOADSLOT")
            return
        end
    end
    -- stage 0
    if menuStage ~= 0 then return end
    -- check for game exit
    if RayLib.IsKeyPressed(RayLib.KEY_ESCAPE) then
        menuStage = -1
        print("WANT TO EXIT")
        FireEvent("MENU_TITLE_WANTTOEXIT")
        return
    end
    -- sily character interactions
    for i, rect in pairs(CharacterRects) do
        if
            InputService.MouseWithin(rect)
            and RayLib.IsMouseButtonPressed(RayLua.MOUSE_LEFT_BUTTON)
        then
            print("CLICK CHARACTER", i)
            FireEvent("MENU_TITLE_CHARACTERCLICK_" .. tostring(i))
            break
        end
    end
    -- play & options buttons
    if
        InputService.MouseWithin(PlayRect)
        and RayLib.IsMouseButtonPressed(RayLua.MOUSE_LEFT_BUTTON)
    then
        print("PLAY")
        menuStage = 2
        FireEvent("MENU_TITLE_PLAY")
    end
    if
        InputService.MouseWithin(OptionsRect)
        and RayLib.IsMouseButtonPressed(RayLua.MOUSE_LEFT_BUTTON)
    then
        print("OPTIONS")
        menuStage = 1
        FireEvent("MENU_TITLE_OPTIONS")
    end
end)
TransmitterService.ListenFor("BEGIN_GAME", function()
    hook:Unhook()
end)

return script
