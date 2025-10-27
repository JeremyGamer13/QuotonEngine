-- This file is intended to be overwritten and contain only static values.
local Environment = {}

---@type "Lua"|"LuaNoGlobal"|"LuaJIT"
-- Which environment this application is running with.
-- Essentially means which Lua VM is being used.
--
-- `Lua` assumes no existence of LuaJIT features and extensions.
--
-- `LuaNoGlobal` assumes no existence of special global values (like _VERSION)
--
-- `LuaJIT` assumes existence of LuaJIT features and extensions.
Environment.Runner = "LuaJIT"

---@type "windowsbundle"
-- Which platform this application was built for.
-- Currently only `windowsbundle` is valid.
--
-- `windowsbundle` means this application was built as a single .EXE executable bundle.
Environment.Platform = "windowsbundle"

---@type "raylib-tsnake41"
-- Which framework/library is currently being used for this environment. Entirely different libraries can be used as long as implementation exists for them.
-- Currently only `raylib-tsnake41` is valid.
--
-- `raylib-tsnake41` means this application was built to use the raylib-lua bindings by TSnake41 on GitHub.
Environment.Library = "raylib-tsnake41"

return Environment
