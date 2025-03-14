local getChecksum = require("src.modules.crc32")
local libset = require("src.modules.libset")

local module = {}

module.SyntaxConfig = {
    CHECKSUM_SEPERATOR = ",",
    SEPERATOR = ";",
    NIL = "/",
    TRUE = "T",
    FALSE = "F",

    TYPING = {
        NIL = 0,
        STRING = 1,
        NUMBER = 2,
        BOOL = 3,
        TABLE = 4,
    },
}

function module:GetSyntaxType(value)
    if value == nil then
        return self.SyntaxConfig.TYPING.NIL
    end

    local valueType = type(value)
    if valueType == "string" then
        return self.SyntaxConfig.TYPING.STRING
    elseif valueType == "number" then
        return self.SyntaxConfig.TYPING.NUMBER
    elseif valueType == "boolean" then
        return self.SyntaxConfig.TYPING.BOOL
    elseif valueType == "table" then
        return self.SyntaxConfig.TYPING.TABLE
    else
        return self.SyntaxConfig.TYPING.NIL
    end
end

function module:EncodeToSyntaxType(value)
    local syntaxType = self:GetSyntaxType(value)
    if syntaxType == self.SyntaxConfig.TYPING.STRING or syntaxType == self.SyntaxConfig.TYPING.NUMBER then
        return tostring(value)
    elseif syntaxType == self.SyntaxConfig.TYPING.BOOL then
        if value then
            return self.SyntaxConfig.TRUE
        else
            return self.SyntaxConfig.FALSE
        end
    elseif syntaxType == self.SyntaxConfig.TYPING.TABLE then
        return self:CreateString(value, true)
    elseif syntaxType == self.SyntaxConfig.TYPING.NIL then
        return self.SyntaxConfig.NIL
    end
end
function module:DecodeFromSyntaxType(type, text)
    if type == self.SyntaxConfig.TYPING.STRING then
        return tostring(text)
    elseif type == self.SyntaxConfig.TYPING.NUMBER then
        return tonumber(text)
    elseif type == self.SyntaxConfig.TYPING.BOOL then
        if text == self.SyntaxConfig.TRUE then
            return true
        else
            return false
        end
    elseif type == self.SyntaxConfig.TYPING.TABLE then
        return self:ReadString(text, true)
    elseif type == self.SyntaxConfig.TYPING.NIL then
        return nil
    end
end

function module:ReadString(text, recursive, hasChecksum)
    local actualTable = {}

    if not recursive and hasChecksum then
        local endIdx = string.find(text, self.SyntaxConfig.CHECKSUM_SEPERATOR, 1, true)
        if endIdx == nil then
            return error("No checksum found")
        end

        local checksum = string.sub(text, 1, endIdx - 1)
        local normalSave = string.sub(text, endIdx + 1)
        if tonumber(checksum) ~= getChecksum(normalSave) then
            return error("Checksum does not match save")
        end

        text = normalSave
    end

    local currentlyOnLength = true
    local currentlyOnType = false
    local currentlyOnKey = true

    local currentType = self.SyntaxConfig.TYPING.NIL
    local startReadIndex = 0
    local currentLength = 0

    local currentBank = ""
    local keyBank = ""

    for i = 1, string.len(text) + 1 do
        local thisChar = string.sub(text, i, i)

        if (currentlyOnLength or currentlyOnType) and thisChar == self.SyntaxConfig.SEPERATOR then
            -- switch state
            if currentlyOnLength then
                currentLength = tonumber(currentBank) or 0
                currentlyOnLength = false
                currentlyOnType = true
            elseif currentlyOnType then
                currentType = tonumber(currentBank) or self.SyntaxConfig.TYPING.NIL
                currentlyOnType = false
                startReadIndex = i
            end
            currentBank = ""
        elseif not (currentlyOnLength or currentlyOnType) and i == startReadIndex + (currentLength + 1) then
            -- check whether or not we are adding this as a value
            if currentlyOnKey then
                ---@diagnostic disable-next-line: cast-local-type
                keyBank = self:DecodeFromSyntaxType(currentType, currentBank)
                ---@diagnostic disable-next-line: need-check-nil
                actualTable[keyBank] = nil
            else
                actualTable[keyBank] = self:DecodeFromSyntaxType(currentType, currentBank)
                keyBank = ""
            end

            currentBank = thisChar
            currentlyOnKey = not currentlyOnKey
            currentlyOnLength = true
        else
            currentBank = currentBank .. thisChar
        end
    end

    return actualTable
end
function module:CreateString(table, recursive, hasChecksum)
    local outputSave = ""

    if not recursive and not table["$version"] then
        table["$version"] = "1.0.0"
    end

    for key, value in pairs(table) do
        local keySyntaxType = self:GetSyntaxType(key)
        local keySyntaxEncoded = self:EncodeToSyntaxType(key)
        local valueSyntaxType = self:GetSyntaxType(value)
        local valueSyntaxEncoded = self:EncodeToSyntaxType(value)
        -- add key length, then seperator, then type, then seperator, then key, then value length, then seperator, then value type, then seperator, then value, then continue
        -- tables are recursively thrown into this method
        outputSave = outputSave .. string.len(keySyntaxEncoded) .. self.SyntaxConfig.SEPERATOR
        outputSave = outputSave .. tostring(keySyntaxType) .. self.SyntaxConfig.SEPERATOR
        outputSave = outputSave .. keySyntaxEncoded
        outputSave = outputSave .. string.len(valueSyntaxEncoded) .. self.SyntaxConfig.SEPERATOR
        outputSave = outputSave .. tostring(valueSyntaxType) .. self.SyntaxConfig.SEPERATOR
        outputSave = outputSave .. valueSyntaxEncoded
    end

    if not recursive and hasChecksum then
        local checksum = getChecksum(outputSave)
        outputSave = checksum .. self.SyntaxConfig.CHECKSUM_SEPERATOR .. outputSave
    end

    return outputSave
end

return module