local RayLib = require("raylib")
local libset = require("src.modules.libset")
local ffi = require("ffi")

local module = {}
local fileList = {}
local folderList = {}

module.Enum = {
    BUFFER = "buffer",
    TEXT = "text",
}
module.MAX_SAFE_FILES = 24
module.MAX_SAFE_FOLDERS = 15

module.ACTIVE_DIR = "./sav/"

function module:GetOpenFiles()
    return fileList
end
function module:GetOpenFileCount()
    return #self:GetOpenFiles()
end

function module:GetOpenFolders()
    return folderList
end
function module:GetOpenFolderCount()
    return #self:GetOpenFolders()
end

local function CreateFileObject(optType, optPath, bufferSize)
    local File = {}

    File.Data = nil
    File.Type = optType or module.Enum.TEXT
    File.Path = optPath
    File.BufferSize = bufferSize

    File.Opened = false
    File.OpenPointer = nil -- result of opening a file, used for deload

    -- File operations run in C, so there are some points where we use ffi to convert from & to C type strings
    function File:GetExists()
        if not self.Path then
            error("Cannot check file with no target path")
            return
        end

        return RayLib.FileExists(self.Path)
    end

    function File:Open()
        if self.Opened then
            error("File already loaded")
            return
        end
        if not self.Path then
            error("Cannot open file with no target path")
            return
        end

        if not File:GetExists() then
            return false
        end

        local openResult = nil
        if self.Type == module.Enum.TEXT then
            openResult = RayLib.LoadFileText(self.Path)
            if openResult ~= nil then
                self.Data = ffi.string(openResult)
            end
        else
            local dataSize = ffi.new("int[1]")
            openResult = RayLib.LoadFileData(self.Path, dataSize)
            self.Data = openResult
        end
        self.OpenPointer = openResult
        self.Opened = true
        table.insert(fileList, self)

        local openFileCount = module:GetOpenFileCount()
        if openFileCount > module.MAX_SAFE_FILES then
            print(tostring(openFileCount), "files are opened in memory! You may not be deloading certain files properly!")
            print("Recommended concurrent file count (FileService.MAX_SAFE_FILES):", module.MAX_SAFE_FILES)
        end

        return true
    end
    function File:Write()
        if self.Data == nil then
            error("No data to write")
            return
        end
        if not self.Path then
            error("Cannot write file with no target path")
            return
        end

        if self.Type == module.Enum.TEXT then
            local cString = ffi.new("char[?]", #self.Data + 1, self.Data)
            RayLib.SaveFileText(self.Path, cString)
        else
            RayLib.SaveFileData(self.Path, self.Data, self.BufferSize)
        end
    end
    function File:Unload()
        if not self.Opened then
            error("File not loaded")
            return
        end
        if not self.OpenPointer then
            error("Cannot close file with no pointer")
            return
        end

        if self.Type == module.Enum.TEXT then
            print("INFO: Deloading txt", self.OpenPointer)
            RayLib.UnloadFileText(self.OpenPointer)
        else
            print("INFO: Deloading buf", self.OpenPointer)
            RayLib.UnloadFileData(self.OpenPointer)
        end

        self.Opened = false
        self.OpenPointer = nil
        local idx = libset.table.find(fileList, self)
        if idx then
            table.remove(fileList, idx)
        end
    end

    return File
end
local function CreateFolderObject(optPath)
    local Folder = {}

    Folder.Path = optPath
    Folder.Children = {}

    Folder.Opened = false
    Folder.OpenPointer = nil -- result of opening a file, used for deload

    function Folder:GetExists()
        if not self.Path then
            error("Cannot check folder with no target path")
            return
        end

        return RayLib.DirectoryExists(self.Path)
    end
    function Folder:Create()
        if not self.Path then
            error("Cannot create folder with no target path")
            return
        end
        if Folder:GetExists() then
            error("Folder already exists")
            return
        end

        -- raylib does not provide a method for this
        local success
        if package.config:sub(1, 1) == '\\' then
            -- Windows
            success = os.execute('mkdir "' .. self.Path .. '"')
        else
            -- Unix-based systems (Linux, MacOS)
            success = os.execute('mkdir -p "' .. self.Path .. '"')
        end

        if not success then
            error("Failed to create folder")
        end
    end

    function Folder:Open()
        if self.Opened then
            error("Folder already loaded")
            return
        end
        if not self.Path then
            error("Cannot open folder with no target path")
            return
        end

        local result = RayLib.LoadDirectoryFilesEx(self.Path, nil, false)
        self.Opened = true
        self.OpenPointer = result
        table.insert(folderList, self)

        -- convert the FilePathList struct into a Lua table
        -- since RayLib is in C, the paths array starts at 0 and is not iterable with pairs() or ipairs()
        -- this is also why we convert the paths
        local filePathList = {}
        for i = 0, result.count - 1 do
            table.insert(filePathList, ffi.string(result.paths[i]))
        end
        self.Children = filePathList

        local openFolderCount = module:GetOpenFolderCount()
        if openFolderCount > module.MAX_SAFE_FOLDERS then
            print(tostring(openFolderCount), "folders are opened in memory! You may not be deloading certain folders properly!")
            print("Recommended concurrent folder count (FileService.MAX_SAFE_FOLDERS):", module.MAX_SAFE_FOLDERS)
        end
    end
    function Folder:Unload()
        if not self.Opened then
            error("Folder not loaded")
            return
        end
        if not self.OpenPointer then
            error("Cannot close folder with no pointer")
            return
        end

        print("INFO: Deloading dir", self.OpenPointer)
        RayLib.UnloadDirectoryFiles(self.OpenPointer)

        self.Opened = false
        self.OpenPointer = nil

        local idx = libset.table.find(folderList, self)
        if idx then
            table.remove(folderList, idx)
        end
    end

    return Folder
end

function module:ReadFile(filePath, openType)
    local fileObject = CreateFileObject(openType, filePath)
    fileObject:Open()
    return fileObject
end
function module:PrepareFile(openType)
    local fileObject = CreateFileObject(openType)
    return fileObject
end
function module:WriteFile(filePath, openType, data)
    local fileObject = CreateFileObject(openType, filePath)
    fileObject.Data = data
    fileObject:Write()
    return fileObject -- not loaded
end

function module:ReadFolder(folderPath)
    local folderObject = CreateFolderObject(folderPath)
    folderObject:Open()
    return folderObject
end
function module:PrepareFolder()
    local folderObject = CreateFolderObject()
    return folderObject
end
function module:MakeFolder(folderPath)
    local folder = CreateFolderObject(folderPath)
    if not folder:GetExists() then
        folder:Create()
    end
    return folder
end

function module:UnloadFiles()
    for _, file in ipairs(fileList) do
        if file.Opened then
            file:Unload()
        end
    end
    fileList = {}
end
function module:UnloadFolders()
    for _, folder in ipairs(folderList) do
        if folder.Opened then
            folder:Unload()
        end
    end
    folderList = {}
end

function module:Initialize()
    self:MakeFolder(self.ACTIVE_DIR)
end
function module:Unload()
    self:UnloadFiles()
end

-- util
function module:PathToFileName(path)
    path = tostring(path)
    return path:match("^.+/(.+)$") or path:match("^.+\\(.+)$")
end

return module
