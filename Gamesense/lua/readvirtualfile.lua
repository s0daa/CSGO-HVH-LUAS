local g_pMemAlloc           = ffi.cast("void***", utils.find_pattern("tier0.dll", "8B 0D ? ? ? ? 8B 11 8D") + 2)
local Free                  = ffi.cast(ffi.typeof("void(__thiscall*)(void*, void*)"), g_pMemAlloc[0][5])
local UTIL_LoadFileForMe    = ffi.cast("uint8_t*(__thiscall*)(const char*)", utils.find_pattern("client.dll", "55 8B EC 83 EC 08 56 57 8B F9 8B 0D ? ? ? ? 83"))


local function ReadFileData(path, type)
    local RawData = UTIL_LoadFileForMe(path)

    if RawData ~= nil then
        local Data = ffi.cast("uint8_t*", tonumber(ffi.cast("uintptr_t", RawData)))
        local Ret = nil

        if type == "table" then
            Ret = {}
            local Index = 0
            while true do
                table.insert(Ret, Data[Index])
                if Data[Index] == 0x00 then
                    break
                end
                Index = Index + 1
            end
        else -- Assume default type is a string
            Ret = ffi.string(Data)
        end
        Free(g_pMemAlloc, Data)
        return Ret
    end
    return nil
end