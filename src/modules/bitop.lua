local Environment = require("src.modules.env")

-- The BitOp library is a library that adds bitwise operations to Lua.
-- On LuaJIT runners, this will run much faster as this just reuses the bitop library.
--
---@see BitOp https://bitop.luajit.org/api.html
local BitOp = {}

if Environment.Runner == "LuaJIT" then
    local bit = require("bit")

    ---@type fun(x:number): number
    -- Normalizes a number to the numeric range for bit operations and returns it.
    BitOp.ToBit = bit.tobit
    ---@type fun(x:number, digits:number): string
    -- Converts its first argument to a hex string.
    -- The number of hex digits is given by the absolute value of the optional second argument.
    -- Positive numbers between 1 and 8 generate lowercase hex digits.
    -- Negative numbers generate uppercase hex digits.
    -- Only the least-significant 4*|n| bits are used.
    -- The default is to generate 8 lowercase hex digits.
    BitOp.ToHex = bit.tohex
    ---@type fun(x:number): number
    -- Returns the bitwise not of its argument.
    BitOp.Not = bit.bnot
    ---@type fun(x1:number, x2:number?, ...?:number): number
    -- Returns the bitwise and of all of its arguments. Note that more than two arguments are allowed.
    BitOp.And = bit.band
    ---@type fun(x1:number, x2:number?, ...?:number): number
    -- Returns the bitwise or of all of its arguments. Note that more than two arguments are allowed.
    BitOp.Or = bit.bor
    ---@type fun(x1:number, x2:number?, ...?:number): number
    -- Returns the bitwise xor of all of its arguments. Note that more than two arguments are allowed.
    BitOp.Xor = bit.bxor
    ---@type fun(x:number, bits:number): number
    -- Returns the bitwise logical left-shift of its first argument by the number of bits given by the second argument.
    -- Logical shifts treat the first argument as an unsigned number and shift in 0-bits. Arithmetic right-shift treats the most-significant bit as a sign bit and replicates it.
    -- Only the lower 5 bits of the shift count are used (reduces to the range [0..31]).
    BitOp.LShift = bit.lshift
    ---@type fun(x:number, bits:number): number
    -- Returns the bitwise logical right-shift of its first argument by the number of bits given by the second argument.
    -- Logical shifts treat the first argument as an unsigned number and shift in 0-bits. Arithmetic right-shift treats the most-significant bit as a sign bit and replicates it.
    -- Only the lower 5 bits of the shift count are used (reduces to the range [0..31]).
    BitOp.RShift = bit.rshift
    ---@type fun(x:number, bits:number): number
    -- Returns the bitwise arithmetic right-shift of its first argument by the number of bits given by the second argument.
    -- Logical shifts treat the first argument as an unsigned number and shift in 0-bits. Arithmetic right-shift treats the most-significant bit as a sign bit and replicates it.
    -- Only the lower 5 bits of the shift count are used (reduces to the range [0..31]).
    BitOp.ARShift = bit.arshift
    ---@type fun(x:number, bits:number): number
    -- Returns the bitwise left rotation of its first argument by the number of bits given by the second argument.
    -- Bits shifted out on one side are shifted back in on the other side.
    -- Only the lower 5 bits of the rotate count are used (reduces to the range [0..31]).
    BitOp.RotL = bit.rol
    ---@type fun(x:number, bits:number): number
    -- Returns the bitwise right rotation of its first argument by the number of bits given by the second argument.
    -- Bits shifted out on one side are shifted back in on the other side.
    -- Only the lower 5 bits of the rotate count are used (reduces to the range [0..31]).
    BitOp.RotR = bit.ror
    ---@type fun(x:number): number
    -- Swaps the bytes of its argument and returns it.
    -- This can be used to convert little-endian 32 bit numbers to big-endian 32 bit numbers or vice versa.
    BitOp.BSwap = bit.bswap
else
    -- TODO: Implement this outside of LuaJIT.
    -- The bitop page has very useful tests and a C implementation.
    -- https://bitop.luajit.org/index.html
    error("Not implemented in this runner")
end

return BitOp
