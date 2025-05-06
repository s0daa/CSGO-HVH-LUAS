local function vtable_bind(class, _type, index)
    local this = ffi.cast("void***", class)
    local ffitype = ffi.typeof(_type)
    return function (...)
        return ffi.cast(ffitype, this[0][index])(this, ...)
    end
end

local ILocalize = utils.find_interface("localize.dll", "Localize_001")
local FindSafeRaw 	        = vtable_bind(ILocalize, "wchar_t*(__thiscall*)(void*, const char*)", 12)
local ConvertUnicodeToAnsi 	= vtable_bind(ILocalize, "int(__thiscall*)(void*, wchar_t*, char*, int)", 16)

local function FindSafe(token)
	local Buffer = ffi.typeof("char[?]")(1024)
    ConvertUnicodeToAnsi(FindSafeRaw(token), Buffer, 1024)
    return ffi.string(Buffer)
end

local WeaponSystem  = ffi.cast("void**", utils.find_pattern("client.dll", "8B 35 ? ? ? ? FF 10 0F B7 C0") + 2)[0]
local g_pMemAlloc   = ffi.cast("void***", utils.find_pattern("tier0.dll", "8B 0D ? ? ? ? 8B 11 8D") + 2)

local GetWeaponData = vtable_bind(WeaponSystem, "uintptr_t(__thiscall*)(void*, short)", 2)
local Free          = vtable_bind(g_pMemAlloc, "void(__thiscall*)(void*, void*)", 5)
local UTIL_LoadFileForMe = ffi.cast("uint8_t*(__thiscall*)(const char*)", utils.find_pattern("client.dll", "55 8B EC 83 EC 08 56 57 8B F9 8B 0D ? ? ? ? 83"))

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
        Free(Data)
        return Ret
    end
    return nil
end

local Weapons = {}

local function CreateWeaponData(WeaponInfo, i)
    if not WeaponInfo then
        WeaponInfo = utils.get_weapon_info(i)
        if not WeaponInfo then
            return nil
        end
    end

    local WeaponInfoAddr = GetWeaponData(i)
    return
    {
        item_definition_index = i,
        weapon_info = WeaponInfo,
        raw_weapon_info = WeaponInfoAddr,
        localized_name = FindSafe(ffi.string(ffi.cast("char**", WeaponInfoAddr + 0x88)[0])),
        get_texture = function (self, size)
            if not self then
                utils.error_print("weapons lib: get_texture is a member function! Make sure you call it as such! weapons[1]:get_texture( )")
                return nil
            end

            local FileName  = self.weapon_info.console_name:gsub("item_", ""):gsub("weapon_", "")
            local FileData  = ReadFileData(("materials/panorama/images/icons/equipment/%s.svg"):format(FileName))
            local Texture = FileData and render.create_texture_svg(FileData, size or 100) or utils.error_print("weapons lib: could not create texture")
            if Texture then
                local w, h = render.get_texture_size(Texture)
                return Texture, w, h
            end
        end
    }
end

local function CheckAndCreateIndex(key)
    local WeaponItemDefIndex = nil

    local key_type = type(key)
    if key_type == "number" then
        if key >= 0 and key <= 525 then
            WeaponItemDefIndex = key
        end
    elseif key_type == "userdata" then
        if key.get_prop then
            WeaponItemDefIndex = key:get_prop("m_iItemDefinitionIndex")
        else
            return nil
        end
    elseif key_type == "string" then
        local ExistingCheck = rawget(Weapons, key)
        if ExistingCheck then
            return ExistingCheck
        end

        for i = 0, 525 do 
            local WeaponInfo = utils.get_weapon_info(i)
            if WeaponInfo then
                if key == WeaponInfo.console_name:gsub("weapon_knife_", "knife_") then
                    local NewWeapon = CreateWeaponData(WeaponInfo, i)
                    Weapons[key] = NewWeapon
                    return NewWeapon
                end
            end
        end
    else
        return nil
    end

    if not WeaponItemDefIndex then
        return nil
    end

    for _, weapon in pairs(Weapons) do
        if WeaponItemDefIndex == weapon.item_definition_index then
            return weapon
        end
    end

    local WeaponInfo = utils.get_weapon_info(WeaponItemDefIndex)
    if WeaponInfo then
        local NewWeapon = CreateWeaponData(WeaponInfo, WeaponItemDefIndex)

        Weapons[WeaponInfo.console_name:gsub("weapon_knife_", "knife_")] = NewWeapon
        return NewWeapon
    end
    return nil
end

local WeaponsMT = 
setmetatable(Weapons,
{
    __index = function(self, key)
        return CheckAndCreateIndex(key)
    end,

    __call = function (self, key)
        return self[key]
    end
})

return WeaponsMT