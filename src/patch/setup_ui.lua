-- Quoton Script automatically created by Quoton UI. Do not replace.
local SetupScript = require("src.scripts._userspace.scripts.setup") -- The user's actual setup script

local module = {}
function module:InitializingPreProgram()
    return SetupScript:InitializingPreProgram()
end

return module