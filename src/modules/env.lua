-- This file is intended to be overwritten and contain only static values.
local module = {}

---@type "Lua"|"LuaNoGlobal"|"LuaJIT"
-- Which environment this application is running with.
-- Essentially means which Lua VM is being used.
--
-- `Lua` assumes no existence of LuaJIT features and extensions.
--
-- `LuaNoGlobal` assumes no existence of special global values (like _VERSION)
--
-- `LuaJIT` assumes existence of LuaJIT features and extensions.
module.Runner = "LuaJIT"

---@type "windowsbundle"
-- Which platform this application was built for. Currently only `windowsbundle` is valid.
--
-- `windowsbundle` means this application was built as a single .EXE executable bundle using raylib-lua.
module.Platform = "windowsbundle"

return module