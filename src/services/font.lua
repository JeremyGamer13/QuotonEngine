local FileService = require("src.services.file")
local SetupService = require("src.services.setup")

local RayLib = require("raylib")
local libset = require("src.modules.libset")

local module = {
    Fonts = {},
    PrimaryFont = "NotoSans",
    Mapping = {
        names = {},
        bold = {},
        italic = {},
        bolditalic = {},
    },
}

function module:GetFallbackFont()
    return RayLib.GetFontDefault()
end
function module:GetPrimaryFont()
    local fontPrimary = module.PrimaryFont
    return self.Fonts[fontPrimary] or module:GetFallbackFont()
end

function module:GetFontList()
    return libset.table.keys(self.Fonts)
end

function module:GetStyle(font, style)
    if not style then
        return font
    end
    if not self.Mapping[style] then
        return font
    end

    local name = self.Mapping.names[font]
    if not name then
        return font
    end

    return self.Mapping[style][name] or font
end

function module:Load()
    -- we use make folder incase it doesnt exist
    local folder = FileService:MakeFolder("./assets/fonts/")
    folder:Open()

    local loadResolution = SetupService.initialConfig.fontResolution
    for _, fontPath in ipairs(folder.Children) do
        if not libset.string.endsWith(fontPath, ".ttf") then goto continue end

        local fileName = FileService:PathToFileName(fontPath)
        local cleanFileName = fileName:gsub("%.ttf$", "")
        local fontName = cleanFileName:match("^[^-]+")

        local loadedFont = RayLib.LoadFontEx(fontPath, loadResolution, nil, 0)
        RayLib.SetTextureFilter(loadedFont.texture, RayLib.TEXTURE_FILTER_TRILINEAR)

        self.Mapping.names[loadedFont] = fontName
        if not string.find(cleanFileName, "-", 1, true) then
            self.Fonts[cleanFileName] = loadedFont
            print("Registered Font", cleanFileName)
        end

        local mapStyle = libset.table.meets(libset.table.keys(self.Mapping), function(styleName)
            if libset.string.endsWith(cleanFileName, styleName) then
                return true
            end
        end)
        if mapStyle and self.Mapping[mapStyle] then
            self.Mapping[mapStyle][fontName] = loadedFont
        end

        ::continue::
    end

    folder:Unload()
end
function module:Unload()
    print("unloading fonts")
    for _, font in pairs(self.Fonts) do
        RayLib.UnloadFont(font)
    end
end

return module
