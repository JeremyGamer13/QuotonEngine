# TODO Items
## IMPORTANT
- [ ] Remove `TerminalShowIgnoreMessages`
- [ ] Make `RenderingService.RenderSettings` private
- [ ] Start making it so user scripts dont rely on RayLib, plus dont say like "will apply only in the InputService functions" since we will only code for using those
    - [ ] Implement everything for inputs into InputService.
    - [ ] add GamepadAxisFix
    - [ ] Make a generic Quoton class, basically makes it so you can create the structs that RayLib uses
    - [ ] Move RayLib functions into things like RenderingService and RuntimeService.
    - [ ] Reduce stuff like `Raylib.LoadImage() -> Raylib.UnloadImage(image)` to `RenderingService:LoadImage():Unload()`
- [ ] Make FontService more configurable
    - [ ] Make it so fonts can be loaded on runtime (like `FontList`)
    - [ ] Make it so `FontResolution` & `FontFilterMode` can be changed later, just note itll only apply to fonts loaded after its updated
- [ ] Turn `DisableKeyExit` into `ExitKey` and `ExitKeyDisabled`.
    - [ ] `ExitKeyDisabled` on by default.
    - [ ] `ExitKeyDisabled` configurable later through RuntimeService.
    - [ ] `ExitKey` configurable later through RuntimeService.
- [ ] make FileService work, basically rewrite it
    - [ ] Dont use anything from RayLib (or we'll be stuck traversing the embedded app)
    - [ ] Implement text mode
    - [ ] Implement buffer mode

## ANY ORDER
- [ ] add a virtual mouse feature?
    - [ ] functions to enter & exit virtual mouse mode
    - [ ] functions to get & set virtual mouse position
    - [ ] functions to get & set virtual mouse buttons
    - [ ] configuration, the mouse position functions will return the virtual mouse position
    - [ ] configuration, the mouse position will actually be set to the virtual mouse position
    - [ ] configuration, hide the mouse when virtual mouse is in use
- [ ] get raw audio working better (unless its also bugged)