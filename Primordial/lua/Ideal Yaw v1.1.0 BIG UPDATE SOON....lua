-- idealyaw
-- primoridal.dev
-- magmabtw / 2022
--

--[[

UPDATE LOG:
- tabs "rage - exploit" and "rage - helpers" now in "rage - general"
- added "antiaim - general > custom fakelags"
- added "antiaim - general > custom fakelags" fakelags type
- added "antiaim - general > custom fakelags > fakelags type" ["static", "fluctate", "random"]
- added "antiaim - general > custom fakelags" fakelags amount
- added "antiaim - general > custom fakelags" break lag compensation
- added "antiaim - general > custom fakelags > break lag compensation" ["disable", "enable", "enable on ground"]
- added "Random left" and "Random right" in "antiaim - states > body yaw"
- added "Anti bruteforce" in "antiaim - states"
- added fully completely new config system
- added "Rounding upper line gradient" in "visuals - indicators > windows style"
- added user sync in chat (now you view a idealyaw user in chat)
- added multi color logs style
- added default preset
- added standarts position for drugs elements (ultra premium feature)
- fully reworked scan enemy resolver (mb eat fps)
- fully reworked ideal tick (changes presets)
- now string "WARNING" in ping warning sets color to ping warning color
- now indicators have a desync deg.
- fixed mono line in trail line
- fixed some lua crashes
- fixed some lua bugs
- fixed "unknown" hitbox in logs
- rename some functions names
- removed old config system

]]--


-- ffi callbacks
local ffi = require "ffi"

ffi.cdef[[
	typedef struct {float x, y, z;}vec3_t;

    typedef struct {
		int         m_nType;
		void*       m_pStartEnt;
		int         m_nStartAttachment;
		void*       m_pEndEnt;
		int         m_nEndAttachment;
		vec3_t      m_vecStart;
		vec3_t      m_vecEnd;
		int         m_nModelIndex;
		const       char* m_pszModelName;
		int         m_nHaloIndex;
		const       char* m_pszHaloName;
		float       m_flHaloScale;
		float       m_flLife;
		float       m_flWidth;
		float       m_flEndWidth;
		float       m_flFadeLength;
		float       m_flAmplitude;
		float       m_flBrightness;
		float       m_flSpeed;
		int         m_nStartFrame;
		float       m_flFrameRate;
		float       m_flRed;
		float       m_flGreen;
		float       m_flBlue;
		bool        m_bRenderable;
		int         m_nSegments;
		int         m_nFlags;
		vec3_t      m_vecCenter;
		float       m_flStartRadius;
		float       m_flEndRadius;
	} beam_info_t;
]]

local iVmodelInfo = ffi.cast("void***", memory.create_interface("engine.dll", "VModelInfoClient004"))
local findOrLoadModel = ffi.cast("void*(__thiscall*)(void*, const char*)", iVmodelInfo[0][39])

local networktbl = ffi.cast("void***", memory.create_interface("engine.dll", "VEngineClientStringTable001"))
local find_tbl = ffi.cast("void*(__thiscall*)(void*, const char*)", networktbl[0][3])

local renderBeams = ffi.cast("void**", ffi.cast("char*", memory.find_pattern("client.dll", "B9 ? ? ? ? A1 ? ? ? ? FF 10 A1 ? ? ? ? B9")) + 1)[0]
local renderBeams_vtbl = ffi.cast("void***", renderBeams)
local drawBeams = ffi.cast("void(__thiscall*)(void*, void*)", renderBeams_vtbl[0][6])

local beams_vtbl = {
    Points = 12,
    Ring = 13,
    RingPoint = 14,
    CirclePoints = 15
}
local beams = setmetatable({cached = {}}, {__index = beams_vtbl})

function beams.new()
    return ffi.new("beam_info_t")
end

function beams._preCacheModel(modelName)
	if beams.cached[modelName] then return end

	local precachetbl = ffi.cast("void***", find_tbl(networktbl, "modelprecache"))

	if precachetbl ~= ffi.new("void***") then
		local addString = ffi.cast("int(__thiscall*)(void*, bool, const char*, int, const void*)", precachetbl[0][8])
		findOrLoadModel(iVmodelInfo, modelName)
		addString(precachetbl, false, modelName, -1, nil)
		beams.cached[modelName] = true
	end
end

for key, value in pairs(beams_vtbl) do
    beams[string.format("fncreate%s", key)] = ffi.cast("void*(__thiscall*)(void*, beam_info_t&)", renderBeams_vtbl[0][value])
    beams[string.format("createBeam%s", key)] = function(beam_info_t)
		local beam = beams[string.format("fncreate%s", key)](renderBeams_vtbl, beam_info_t)
		beams._preCacheModel(ffi.string(beam_info_t.m_pszModelName))
		drawBeams(renderBeams, beam)
    end
end

local sprites = {
    "sprites/purplelaser1.vmt",
    "sprites/physbeam.vmt",
    "sprites/blueglow1.vmt",
    "sprites/bubble.vmt",
    "sprites/glow01.vmt",
    "sprites/purpleglow1.vmt",
    "sprites/radio.vmt",
    "sprites/white.vmt",
    "sprites/defuser.vmt",
    "sprites/richo1.vmt",
    "sprites/numbers.vmt",
    "sprites/hostage_following.vmt",
    "sprites/halo.vmt",
    "sprites/crosshairs.vmt",
}

function createBeams(startpos, endpos, life_time, sprite_id, color)
    local beamInfo = beams.new()
    beamInfo.m_nType = 0
    beamInfo.m_nModelIndex = -1
    beamInfo.m_flHaloScale = 1
    beamInfo.m_flLife = life_time
    beamInfo.m_flFadeLength = 1
    beamInfo.m_flWidth = 2
    beamInfo.m_flEndWidth = 2
    beamInfo.m_pszModelName = sprites[sprite_id]
    beamInfo.m_flAmplitude = 2.3
    beamInfo.m_flSpeed = 0
    beamInfo.m_nStartFrame = 0
    beamInfo.m_flFrameRate = 0
    beamInfo.m_flRed = color.r
    beamInfo.m_flGreen = color.g
    beamInfo.m_flBlue = color.b
    beamInfo.m_flBrightness = color.a
    beamInfo.m_nSegments = 2
    beamInfo.m_bRenderable = true
    beamInfo.m_nFlags = bit.bor(0x100 + 0x200 + 0x8000)
    beamInfo.m_vecStart = {startpos.x, startpos.y, startpos.z}
    beamInfo.m_vecEnd = {endpos.x, endpos.y, endpos.z}

    beams.createBeamPoints(beamInfo)
end

--
-- region: #array
-- ______________


array = {}
array.put = function(array, val)
    array[#array + 1] = val
end
array.has = function(array, val)
    is_exist = false
    for i = 1, #array do
        if array[i] == val then is_exist = true end
    end
    return is_exist
end

function vec3_t:length()
    return math.sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
end


-- ______________
-- endregion: #array
--

--
-- region: base64
-- ______________

local bit = require "bit"
local base64 = {}

local shl, shr, band = bit.lshift, bit.rshift, bit.band
local char, byte, gsub, sub, format, concat, tostring, error, pairs = string.char, string.byte, string.gsub, string.sub, string.format, table.concat, tostring, error, pairs

local extract = function(v, from, width)
	return band(shr(v, from), shl(1, width) - 1)
end

local function makeencoder(alphabet)
	local encoder, decoder = {}, {}

	for i=1, 65 do
		local chr = byte(sub(alphabet, i, i)) or 32 -- or " "
		if decoder[chr] ~= nil then
			error("invalid alphabet: duplicate character " .. tostring(chr), 3)
		end
		encoder[i-1] = chr
		decoder[chr] = i-1
	end

	return encoder, decoder
end

local encoders, decoders = {}, {}

encoders["base64"], decoders["base64"] = makeencoder("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")
encoders["base64url"], decoders["base64url"] = makeencoder("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")

local alphabet_mt = {
	__index = function(tbl, key)
		if type(key) == "string" and key:len() == 64 or key:len() == 65 then
			-- if key is a valid looking base64 alphabet, try to make an encoder/decoder pair from it
			encoders[key], decoders[key] = makeencoder(key)

			return tbl[key]
		end
	end
}

setmetatable(encoders, alphabet_mt)
setmetatable(decoders, alphabet_mt)

function base64.encode(str, encoder)
	encoder = encoders[encoder or "base64"] or error("invalid alphabet specified", 2)

	str = tostring(str)

	local t, k, n = {}, 1, #str
	local lastn = n % 3
	local cache = {}

	for i = 1, n-lastn, 3 do
		local a, b, c = byte(str, i, i+2)
		local v = a*0x10000 + b*0x100 + c
		local s = cache[v]

		if not s then
			s = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
			cache[v] = s
		end

		t[k] = s
		k = k + 1
	end

	if lastn == 2 then
		local a, b = byte(str, n-1, n)
		local v = a*0x10000 + b*0x100
		t[k] = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[64])
	elseif lastn == 1 then
		local v = byte(str, n)*0x10000
		t[k] = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[64], encoder[64])
	end

	return concat(t)
end

function base64.decode(b64, decoder)
	decoder = decoders[decoder or "base64"] or error("invalid alphabet specified", 2)

	local pattern = "[^%w%+%/%=]"

	if decoder then
		local s62, s63

		for charcode, b64code in pairs(decoder) do
			if b64code == 62 then s62 = charcode
			elseif b64code == 63 then s63 = charcode
			end
		end

		pattern = format("[^%%w%%%s%%%s%%=]", char(s62), char(s63))
	end

	b64 = gsub(tostring(b64), pattern, '')

	local cache = {}
	local t, k = {}, 1
	local n = #b64
	local padding = sub(b64, -2) == "==" and 2 or sub(b64, -1) == "=" and 1 or 0

	for i = 1, padding > 0 and n-4 or n, 4 do
		local a, b, c, d = byte(b64, i, i+3)

		local v0 = a*0x1000000 + b*0x10000 + c*0x100 + d
		local s = cache[v0]

		if not s then
			local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40 + decoder[d]
			s = char(extract(v,16,8), extract(v,8,8), extract(v,0,8))
			cache[v0] = s
		end

		t[k] = s
		k = k + 1
	end

	if padding == 1 then
		local a, b, c = byte(b64, n-3, n-1)
		local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40
		t[k] = char(extract(v,16,8), extract(v,8,8))
	elseif padding == 2 then
		local a, b = byte(b64, n-3, n-2)
		local v = decoder[a]*0x40000 + decoder[b]*0x1000
		t[k] = char(extract(v,16,8))
	end

	return concat(t)
end

-- ______________
-- endregion: base64
--

--
-- region: chat print
-- _______________

local replacements = {
	["{white}"] = "\x01",
	["{darkred}"] = "\x02",
	["{team}"] = "\x03",
	["{green}"] = "\x04",
	["{lightgreen}"] = "\x05",
	["{lime}"] = "\x06",
	["{red}"] = "\x07",
	["{grey}"] = "\x08",
	["{yellow}"] = "\x09",
	["{bluegrey}"] = "\x0A",
	["{blue}"] = "\x0B",
	["{darkblue}"] = "\x0C",
	["{purple}"] = "\x0D",
	["{violet}"] = "\x0E",
	["{lightred}"] = "\x0F",
	["{orange}"] = "\x10"
}

local function FindSig(mod, pat, type, offset, deref_count)
	local raw_match = memory.find_pattern(mod, pat) or error("signature not found", 2)
	local match = ffi.cast("uintptr_t", raw_match)

	if offset ~= nil and offset ~= 0 then
		match = match + offset
	end

	if deref_count ~= nil then
		for i = 1, deref_count do
			match = ffi.cast("uintptr_t*", match)[0]
			if match == nil then
				return error("signature not found", 2)
			end
		end
	end

	return ffi.cast(type, match)
end

local function tbl_concat_string(tbl, sep)
	local result = ""
	for i=1, #tbl do
		result = result .. tostring(tbl[i]) .. (i == #tbl and "" or sep)
	end
	return result
end

local FindHudElement = FindSig("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28", "void***(__thiscall*)(void*, const char*)")
local hud = FindSig("client.dll", "B9 ?? ?? ?? ?? 88 46 09", "void*", 1, 1)
local hud_chat = FindHudElement(hud, "CHudChat")
local class_ptr = ffi.cast("void***",hud_chat)
local ChatPrintf = ffi.cast("void(__cdecl*)(void*, int, int, const char*, ...)", memory.get_vfunc(tonumber(ffi.cast("unsigned long", class_ptr)), 27))

local function print_player(entindex, ...)
	local text = tbl_concat_string(entindex == 0 and {" ", ...} or {...}, "")

	for res, rep in pairs(replacements) do
		text = string.gsub(text, res, rep)
	end

	ChatPrintf(class_ptr, entindex, 0, text)
end

local chat_print = function(...)
    return print_player(0, ...)
end

-- ______________
-- endregion: chat print
--



--
-- region: filesystem
-- ______________

local function vtable_entry(instance, index, type)
    return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end

local function vtable_thunk(index, typestring)
    local t = ffi.typeof(typestring)
    return function(instance, ...)
        assert(instance ~= nil)
        if instance then
            return vtable_entry(instance, index, t)(instance, ...)
        end
    end
end

local function vtable_bind(module, interface, index, typestring)
    local instance = memory.create_interface(module, interface) or error("invalid interface")
    local fnptr = vtable_entry(instance, index, ffi.typeof(typestring)) or error("invalid vtable")
    return function(...)
        return fnptr(tonumber(ffi.cast("void***", instance)), ...)
    end
end

local filesystem = memory.create_interface("filesystem_stdio.dll", "VBaseFileSystem011")
local filesystem_class = ffi.cast(ffi.typeof("void***"), filesystem)
local filesystem_vftbl = filesystem_class[0]

local func_read_file = ffi.cast("int (__thiscall*)(void*, void*, int, void*)", filesystem_vftbl[0])
local func_write_file = ffi.cast("int (__thiscall*)(void*, void const*, int, void*)", filesystem_vftbl[1])

local func_open_file = ffi.cast("void* (__thiscall*)(void*, const char*, const char*, const char*)", filesystem_vftbl[2])
local func_close_file = ffi.cast("void (__thiscall*)(void*, void*)", filesystem_vftbl[3])

local func_get_file_size = ffi.cast("unsigned int (__thiscall*)(void*, void*)", filesystem_vftbl[7])
local func_file_exists = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)", filesystem_vftbl[10])

local full_filesystem = memory.create_interface("filesystem_stdio.dll", "VFileSystem017")
local full_filesystem_class = ffi.cast(ffi.typeof("void***"), full_filesystem)
local full_filesystem_vftbl = full_filesystem_class[0]

local func_add_search_path = ffi.cast("void (__thiscall*)(void*, const char*, const char*, int)", full_filesystem_vftbl[11])
local func_remove_search_path = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)", full_filesystem_vftbl[12])

local func_remove_file = ffi.cast("void (__thiscall*)(void*, const char*, const char*)", full_filesystem_vftbl[20])
local func_rename_file = ffi.cast("bool (__thiscall*)(void*, const char*, const char*, const char*)", full_filesystem_vftbl[21])
local func_create_dir_hierarchy = ffi.cast("void (__thiscall*)(void*, const char*, const char*)", full_filesystem_vftbl[22])
local func_is_directory = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)", full_filesystem_vftbl[23])

local func_find_first = ffi.cast("const char* (__thiscall*)(void*, const char*, int*)", full_filesystem_vftbl[32])
local func_find_next = ffi.cast("const char* (__thiscall*)(void*, int)", full_filesystem_vftbl[33])
local func_find_is_directory = ffi.cast("bool (__thiscall*)(void*, int)", full_filesystem_vftbl[34])
local func_find_close = ffi.cast("void (__thiscall*)(void*, int)", full_filesystem_vftbl[35])

local native_GetGameDirectory = vtable_bind("engine.dll", "VEngineClient014", 36, "const char*(__thiscall*)(void*)")

local MODES = {
    ["r"] = "r",
    ["w"] = "w",
    ["a"] = "a",
    ["r+"] = "r+",
    ["w+"] = "w+",
    ["a+"] = "a+",
    ["rb"] = "rb",
    ["wb"] = "wb",
    ["ab"] = "ab",
    ["rb+"] = "rb+",
    ["wb+"] = "wb+",
    ["ab+"] = "ab+",
}

local FileSystem = {}
FileSystem.__index = FileSystem

function FileSystem.exists(file, path_id)
    return func_file_exists(filesystem_class, file, path_id)
end

function FileSystem.rename(old_path, new_path, path_id)
    func_rename_file(full_filesystem_class, old_path, new_path, path_id)
end

function FileSystem.remove(file, path_id)
    func_remove_file(full_filesystem_class, file, path_id)
end

function FileSystem.create_directory(path, path_id)
    func_create_dir_hierarchy(full_filesystem_class, path, path_id)
end

function FileSystem.is_directory(path, path_id)
    return func_is_directory(full_filesystem_class, path, path_id)
end

function FileSystem.find_first(path)
    local handle = ffi.new("int[1]")
    local file = func_find_first(full_filesystem_class, path, handle)
    if file == ffi.NULL then return nil end

    return handle, ffi.string(file)
end

function FileSystem.find_next(handle)
    local file = func_find_next(full_filesystem_class, handle)
    if file == ffi.NULL then return nil end

    return ffi.string(file)
end

function FileSystem.find_is_directory(handle)
    return func_find_is_directory(full_filesystem_class, handle)
end

function FileSystem.find_close(handle)
    func_find_close(full_filesystem_class, handle)
end

function FileSystem.add_search_path(path, path_id, type)
    func_add_search_path(full_filesystem_class, path, path_id, type)
end

function FileSystem.remove_search_path(path, path_id)
    func_remove_search_path(full_filesystem_class, path, path_id)
end

function FileSystem.get_game_dir()
    return ffi.string(native_GetGameDirectory())
end

function FileSystem.open(file, mode, path_id)
    if not MODES[mode] then error("Invalid mode!") end
    local self = setmetatable({
        file = file,
        mode = mode,
        path_id = path_id,
        handle = func_open_file(filesystem_class, file, mode, path_id)
    }, FileSystem)

    return self
end

function FileSystem:get_size()
    return func_get_file_size(filesystem_class, self.handle)
end

function FileSystem:write(buffer)
    func_write_file(filesystem_class, buffer, #buffer, self.handle)
end

function FileSystem:read()
    local size = self:get_size()
    local output = ffi.new("char[?]", size + 1)
    func_read_file(filesystem_class, output, size, self.handle)

    return ffi.string(output)
end

function FileSystem:close()
    func_close_file(filesystem_class, self.handle)
end

-- ______________
-- endregion: filesystem
--



--
-- region: clipboard
-- ______________

local vgui_sys = 'VGUI_System010'
local vgui2 = 'vgui2.dll'

local function VTableBind(mod, face, n, type)
	local iface = memory.create_interface(mod, face) or error(face .. ": invalid interface")
	local instance = memory.get_vfunc(iface, n) or error(index .. ": invalid index")
	local success, typeof = pcall(ffi.typeof, type)
	if not success then
		error(typeof, 2)
	end
	local fnptr = ffi.cast(typeof, instance) or error(type .. ": invalid typecast")
	return function(...)
		return fnptr(tonumber(ffi.cast("void***", iface)), ...)
	end
end

local native_GetClipboardTextCount = VTableBind(vgui2, vgui_sys, 7, "int(__thiscall*)(void*)")
local native_SetClipboardText = VTableBind(vgui2, vgui_sys, 9, "void(__thiscall*)(void*, const char*, int)")
local native_GetClipboardText = VTableBind(vgui2, vgui_sys, 11, "int(__thiscall*)(void*, int, const char*, int)")
local clipboard = {}

clipboard.get = function()
    local len = native_GetClipboardTextCount()
    if (len > 0) then
        local char_arr = ffi.typeof("char[?]")(len)
        native_GetClipboardText(0, char_arr, len)
        return ffi.string(char_arr, len - 1)
    end
end
clipboard.set = function(text)
    text = tostring(text)
    native_SetClipboardText(text, string.len(text))
end

-- ______________
-- endregion: clipboard
--



--
-- region: #ui
-- ______________


gui = {}
gui.groups = {}
gui.instillize = false
gui.create_group = function(name, column, is_tab, tab_idx)
    array.put(gui.groups, {{}, name, {}, is_tab, {}})
    menu.set_group_column(name, column)

    return gui.groups[#gui.groups]
end
gui.add_keybind = function(arr, name, bind)
    local element = gui.get(arr[2], name):add_keybind(bind)
    array.put(arr[1], element)
    array.put(arr[3], bind)
    array.put(arr[5], "keybind")
    return element
end
gui.add_colorpicker = function(arr, name, clr)
    local element = gui.get(arr[2], name):add_color_picker(clr)
    array.put(arr[1], element)
    array.put(arr[3], clr)
    array.put(arr[5], "color")
    return element
end
gui.add_checkbox = function(arr, name, default)
    local element = menu.add_checkbox(arr[2], name)
    array.put(arr[1], element)
    array.put(arr[3], name)
    array.put(arr[5], "checkbox")
    return element
end
gui.add_slider = function(arr, name, min, max, step)
    local element = menu.add_slider(arr[2], name, min, max, step)
    array.put(arr[1], element)
    array.put(arr[3], name)
    array.put(arr[5], "slider")
    return element
end
gui.add_text = function(arr, name)
    local element = menu.add_text(arr[2], name)
    array.put(arr[1], element)
    array.put(arr[3], name)
    array.put(arr[5], "text")
    return element
end
gui.add_combo = function(arr, name, elements)
    local element = menu.add_selection(arr[2], name, elements)
    array.put(arr[1], element)
    array.put(arr[3], name)
    array.put(arr[5], "combo")
    return element
end
gui.add_multicombo = function(arr, name, elements)
    local element = menu.add_multi_selection(arr[2], name, elements)
    array.put(arr[1], element)
    array.put(arr[3], name)
    array.put(arr[5], "multicombo")
    return element
end
gui.add_button = function(arr, name, func)
    local element = menu.add_button(arr[2], name, func)
    array.put(arr[1], element)
    array.put(arr[3], name)
    array.put(arr[5], "button")
    return element
end
gui.add_input = function(arr, name)
    local element = menu.add_text_input(arr[2], name)
    array.put(arr[1], element)
    array.put(arr[3], name)
    array.put(arr[5], "input")
    return element
end
gui.add_list = function(arr, name, elements)
    local element = menu.add_list(arr[2], name, elements)
    array.put(arr[1], element)
    array.put(arr[3], name)
    array.put(arr[5], "list")
    return element
end
gui.get = function(group, name)
    for i = 1, #gui.groups do
        if gui.groups[i][2] == group then
            for d = 1, #gui.groups[i][3] do
                if gui.groups[i][3][d] == name then
                    return gui.groups[i][1][d]
                end
            end
        end
    end
end
gui.get_type = function(group, name)
    for i = 1, #gui.groups do
        if gui.groups[i][2] == group then
            for d = 1, #gui.groups[i][3] do
                if gui.groups[i][3][d] == name then
                    return gui.groups[i][5][d]
                end
            end
        end
    end
end
gui.callback = function(tab)
    if not gui.instillize then return end
    local idx = 1
    for i = 1, #gui.groups do
        local group = gui.groups[i]
        if group[4] == true then
            for e = 1, #group[1] do
                group[1][e]:set_visible(tab == idx)
            end
            idx = idx + 1
        end
    end
end


-- ______________
-- endregion: #ui
--




--
-- region: #elements
-- ______________

local group = gui.create_group("Tabs", 1, false)
gui.add_checkbox(group, "Master switch", false)
gui.add_list(group, "Select", {"Rage - general", "Antiaim - general", "Antiaim - states", "Visuals - indicators", "Visuals - other", "Misc - other", "Profile changer"})

local group = gui.create_group("Configs", 1, false)
local config_list = {"-"}
gui.add_list(group, "Configs list", config_list)
gui.add_input(group, "Config name")
gui.add_button(group, "Load config", function()
    configs.load(configs.active_config)
end)
gui.add_button(group, "Save config", function()
    configs.save(configs.active_config)
end)
gui.add_button(group, "Create config", function()
    configs.create(gui.get("Configs", "Config name"):get())
end)
gui.add_button(group, "Delete config", function()
    configs.remove(configs.active_config)
end)
gui.add_button(group, "Load default config", function()
    local cfg = "SVk8e1tSYWdlIC0gZ2VuZXJhbCxCbG9jayByZWNoYXJnZSBpZiBlbmVteSB2aXNpYmx5OnRydWUhYm9vbF1bUmFnZSAtIGdlbmVyYWwsT3ZlcnJpZGUgZG91YmxldGFwOnRydWUhYm9vbF1bUmFnZSAtIGdlbmVyYWwsRFQgc3BlZWQgKDE1IC0gZGVmYXVsdCk6MTghaW50XVtSYWdlIC0gZ2VuZXJhbCxJZGVhbCBUaWNrOnRydWUhYm9vbF1bUmFnZSAtIGdlbmVyYWwsSWRlYWwgVGljayBXZWFwb25zOmFycmF5KDEsMiwpIWFycmF5XVtSYWdlIC0gZ2VuZXJhbCxBdXRvIGZvcmNlIHRlbGVwb3J0OnRydWUhYm9vbF1bQW50aWFpbSAtIGdlbmVyYWwsRW5hYmxlIGZyZWVzdGFuZGluZzp0cnVlIWJvb2xdW0FudGlhaW0gLSBnZW5lcmFsLEVuYWJsZSBvbiAuLi46YXJyYXkoMSwyLDMsKSFhcnJheV1bQW50aWFpbSAtIGdlbmVyYWwsQ3VzdG9tIGZha2VsYWdzOnRydWUhYm9vbF1bQW50aWFpbSAtIGdlbmVyYWwsRmFrZWxhZ3MgdHlwZToyIWludF1bQW50aWFpbSAtIGdlbmVyYWwsRmFrZWxhZ3MgYW1vdW50OjE1IWludF1bQW50aWFpbSAtIGdlbmVyYWwsQnJlYWsgbGFnIGNvbXBlbnNhdGlvbjozIWludF1bQW50aWFpbSAtIHN0YXRlcyxFbmFibGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBJbnZlcnRlcjp0cnVlIWJvb2xdW0FudGlhaW0gLSBzdGF0ZXMsQW50aSBicnV0ZWZvcmNlOmZhbHNlIWJvb2xdW0FudGlhaW0gLSBzdGF0ZXMsU2NhbiBlbmVteSByZXNvbHZlciAoYm9keSB5YXcpOnRydWUhYm9vbF1bQW50aWFpbSAtIHN0YXRlcyxQaXRjaDoyIWludF1bQW50aWFpbSAtIHN0YXRlcywobCkgQmFzZToxIWludF1bQW50aWFpbSAtIHN0YXRlcywobCkgWWF3OjMyIWludF1bQW50aWFpbSAtIHN0YXRlcywobCkgSml0dGVyOjIhaW50XVtBbnRpYWltIC0gc3RhdGVzLChsKSBKaXR0ZXIgb2Zmc2V0Oi0zMSFpbnRdW0FudGlhaW0gLSBzdGF0ZXMsKGwpIEJvZHkgeWF3OjUhaW50XVtBbnRpYWltIC0gc3RhdGVzLChsKSBCb2R5IHlhdyB2YWx1ZToxMCFpbnRdW0FudGlhaW0gLSBzdGF0ZXMsKHIpIEJhc2U6MSFpbnRdW0FudGlhaW0gLSBzdGF0ZXMsKHIpIFlhdzowIWludF1bQW50aWFpbSAtIHN0YXRlcywocikgSml0dGVyOjIhaW50XVtBbnRpYWltIC0gc3RhdGVzLChyKSBKaXR0ZXIgb2Zmc2V0OjUhaW50XVtBbnRpYWltIC0gc3RhdGVzLChyKSBCb2R5IHlhdzoyIWludF1bQW50aWFpbSAtIHN0YXRlcywocikgQm9keSB5YXcgdmFsdWU6LTI1IWludF1bVmlzdWFscyAtIGluZGljYXRvcnMsV2luZG93czphcnJheSgxLDIsMyw0LDUsKSFhcnJheV1bVmlzdWFscyAtIGluZGljYXRvcnMsV2luZG93cyBzdHlsZToxIWludF1bVmlzdWFscyAtIGluZGljYXRvcnMsa2V5YmluZHNfY2xyOmNvbG9yKDEyNCwyNTUsMTI0LDI1NSkhY29sb3JdW1Zpc3VhbHMgLSBpbmRpY2F0b3JzLHdhdGVybWFya19jbHI6Y29sb3IoMTI5LDE1NiwyNTUsMjU1KSFjb2xvcl1bVmlzdWFscyAtIGluZGljYXRvcnMsV2F0ZXJtYXJrIG5hbWU6MSFpbnRdW1Zpc3VhbHMgLSBpbmRpY2F0b3JzLFdhdGVybWFyayBlbGVtZW50czphcnJheSgxLDIsMyw0LDUsKSFhcnJheV1bVmlzdWFscyAtIGluZGljYXRvcnMsTG9ncyBhc3BlY3RzOmFycmF5KDEsMiwzLDQsKSFhcnJheV1bVmlzdWFscyAtIGluZGljYXRvcnMsTG9ncyBvdXRwdXQ6YXJyYXkoMSwyLCkhYXJyYXldW1Zpc3VhbHMgLSBpbmRpY2F0b3JzLExvZ3Mgc3R5bGU6MiFpbnRdW1Zpc3VhbHMgLSBpbmRpY2F0b3JzLHBpbmd3YXJuaW5nX2Nscjpjb2xvcigyNTUsOTAsOTAsMjU1KSFjb2xvcl1bVmlzdWFscyAtIGluZGljYXRvcnMsY2VudGVyaW5kX2Nscjpjb2xvcigxNDksMTY4LDI1NSwyNTUpIWNvbG9yXVtWaXN1YWxzIC0gb3RoZXIsQWRkaXRpb25hbHMgcmVtb3ZhbHM6YXJyYXkoMSwpIWFycmF5XVtWaXN1YWxzIC0gb3RoZXIsIk9uZVNob3QiIGF1dG9wZWVrOnRydWUhYm9vbF1bVmlzdWFscyAtIG90aGVyLG9uZXNob3RwZWVrX2Nscjpjb2xvcigyNTUsMTY0LDE2NCwyNTUpIWNvbG9yXVtWaXN1YWxzIC0gb3RoZXIsVHJhaWwgbGluZTp0cnVlIWJvb2xdW1Zpc3VhbHMgLSBvdGhlcix0cmFpbGxpbmVfY2xyOmNvbG9yKDAsMCwwLDApIWNvbG9yXVtWaXN1YWxzIC0gb3RoZXIsU3RpY2ttYW46ZmFsc2UhYm9vbF1bVmlzdWFscyAtIG90aGVyLEFuaW1hdGlvbnMgYnJlYWtlcjphcnJheSgxLDIsKSFhcnJheV1bVmlzdWFscyAtIG90aGVyLEFuaW1hdGlvbiB3YWxrIGxlZ3M6MSFpbnRdW1Zpc3VhbHMgLSBvdGhlcixMZWFuIGFuaW1hdGlvbiBpbiB3YWxraW5nOmZhbHNlIWJvb2xdW1Zpc3VhbHMgLSBvdGhlcixBbmltYXRpb24gYWlyIGxlZ3M6MSFpbnRdW1Zpc3VhbHMgLSBvdGhlcixMZWFuIGFuaW1hdGlvbiBpbiBhaXI6dHJ1ZSFib29sXVtNaXNjIC0gb3RoZXIsVHJhc2h0YWxrOjIhaW50XVtQcm9maWxlIGNoYW5nZXIsRW5hYmxlOmZhbHNlIWJvb2xdW1Byb2ZpbGUgY2hhbmdlcixLaWxsczo1MDAhaW50XVtQcm9maWxlIGNoYW5nZXIsRGVhdGhzOjAhaW50XVtQcm9maWxlIGNoYW5nZXIsQXNzaXN0czo1MDAhaW50XVtQcm9maWxlIGNoYW5nZXIsUmFuazoxOSFpbnRdW2tiLGtiX3g6MTAwLjg2MjI1MTI4MTc0IWludF1ba2Isa2JfeTo1MDAuMzE4MzI4ODU3NDIhaW50XVt3bSx3bV94OjE2MTkhaW50XVt3bSx3bV95OjEwIWludF1bbG9ncyxsb2dzX3g6ODEwIWludF1bbG9ncyxsb2dzX3k6NzQwIWludF1bcHcscHdfeDo4NzAhaW50XVtwdyxwd195OjEwMCFpbnRdfQ=="
    
    if configs.import(cfg) then
        print("Default config imported")
    else
        print("Default config import error")
    end
end)


local group = gui.create_group("Rage - general", 2, true)
gui.add_checkbox(group, "Block recharge if enemy visibly", false)
gui.add_checkbox(group, "Override doubletap", false)
gui.add_slider(group, "DT speed (15 - default)", 10, 18, 1)
gui.add_checkbox(group, "Ideal Tick", false)
gui.add_keybind(group, "Ideal Tick", "idealtick_bind")
gui.add_multicombo(group, "Ideal Tick Weapons", {"ssg08", "awp"})
gui.add_checkbox(group, "Auto force teleport", false)
gui.add_keybind(group, "Auto force teleport", "autotp_bind")

local group = gui.create_group("Antiaim - general", 2, true)
gui.add_text(group, "Freestanding  ____________________________")
gui.add_text(group, "Bind \"antiaim->main->auto direction->enable\"")
gui.add_text(group, "on \"always on\"")
gui.add_checkbox(group, "Enable freestanding", false)
gui.add_keybind(group, "Enable freestanding", "freestand_bind")
gui.add_multicombo(group, "Enable on ...", {"Air", "Move", "Stand"})
gui.add_checkbox(group, "Custom fakelags")
gui.add_combo(group, "Fakelags type", {"Static", "Fluctate", "Random"})
gui.add_slider(group, "Fakelags amount", 1, 15)
gui.add_combo(group, "Break lag compensation", {"Disable", "Enable", "Enable on ground"})

local group = gui.create_group("Antiaim - states", 2, true)
gui.add_checkbox(group, "Enable                              Inverter")
gui.add_keybind(group, "Enable                              Inverter", "invert_state")
gui.add_checkbox(group, "Anti bruteforce")
gui.add_checkbox(group, "Scan enemy resolver (body yaw)")
gui.add_combo(group, "Pitch", {"None", "Down", "Up", "Zero", "Jitter"})
gui.add_text(group, "Left ____________________________________")
gui.add_combo(group, "(l) Base", {"View Angle", "At Targets"})
gui.add_slider(group, "(l) Yaw", -180, 180, 1)
gui.add_combo(group, "(l) Jitter", {"None", "Static", "Center"})
gui.add_slider(group, "(l) Jitter offset", -180, 180, 1)
gui.add_combo(group, "(l) Body yaw", {"None", "Static", "Jitter", "Random left", "Random right"})
gui.add_slider(group, "(l) Body yaw value", -60, 60, 1)

gui.add_text(group, "Right ___________________________________")
gui.add_combo(group, "(r) Base", {"View Angle", "At Targets"})
gui.add_slider(group, "(r) Yaw", -180, 180, 1)
gui.add_combo(group, "(r) Jitter", {"None", "Static", "Center"})
gui.add_slider(group, "(r) Jitter offset", -180, 180, 1)
gui.add_combo(group, "(r) Body yaw", {"None", "Static", "Jitter", "Random left", "Random right"})
gui.add_slider(group, "(r) Body yaw value", -60, 60, 1)

local group = gui.create_group("Visuals - indicators", 2, true)
gui.add_multicombo(group, "Windows", {"Keybinds", "Watermark", "Logs", "Ping Warning", "Centered Indicators"})
gui.add_combo(group, "Windows style", {"Upper line", "Under line", "Rounding upper line", "Rounding upper line gradient", "Rounding under line", "Rounding line"})
gui.add_text(group, "Keybinds  _______________________________")
gui.add_text(group, "Keybinds color")
gui.add_colorpicker(group, "Keybinds color", "keybinds_clr")
gui.add_text(group, "Watermark   _____________________________")
gui.add_text(group, "Watermark color")
gui.add_colorpicker(group, "Watermark color", "watermark_clr")
gui.add_combo(group, "Watermark name", {"Default", "Small", "Script"})
gui.add_multicombo(group, "Watermark elements", {"Username", "User ID", "Ping", "Tickrate", "Server IP", "Time"})
gui.add_text(group, "Logs   __________________________________")
gui.add_multicombo(group, "Logs aspects", {"Misses", "Hits", "Hurts", "Buys"})
gui.add_multicombo(group, "Logs output", {"Indicator", "Console"})
gui.add_combo(group, "Logs style", {"Mono Color", "Multi Color"})
gui.add_text(group, "Ping Warning ____________________________")
gui.add_text(group, "Ping Warning color")
gui.add_colorpicker(group, "Ping Warning color", "pingwarning_clr")
gui.add_text(group, "Center Indicators _________________________")
gui.add_text(group, "Center Indicators color")
gui.add_colorpicker(group, "Center Indicators color", "centerind_clr")

local group = gui.create_group("Visuals - other", 2, true)
gui.add_multicombo(group, "Additionals removals", {"Shadows"})
gui.add_checkbox(group, "\"OneShot\" autopeek", false)
gui.add_colorpicker(group, "\"OneShot\" autopeek", "oneshotpeek_clr")
gui.add_checkbox(group, "Trail line", false)
gui.add_colorpicker(group, "Trail line", "trailline_clr")
gui.add_checkbox(group, "Stickman", false)
gui.add_multicombo(group, "Animations breaker", {"Walk legs", "Legs in air", "Peacock mode"})
gui.add_text(group, "Walk ___________________________________")
gui.add_combo(group, "Animation walk legs", {"Backward", "Forward", "No animation", "No sides", "Air"})
gui.add_checkbox(group, "Lean animation in walking", false)
gui.add_text(group, "Air _____________________________________")
gui.add_combo(group, "Animation air legs", {"Static", "Walking", "Freeze"})
gui.add_checkbox(group, "Lean animation in air", false)

local group = gui.create_group("Misc - other", 2, true)
gui.add_combo(group, "Trashtalk", {"None", "Agressive", "Default"})


local group = gui.create_group("Profile changer", 2, true)
gui.add_checkbox(group, "Enable", false)
gui.add_slider(group, "Kills", 0, 500, 1)
gui.add_slider(group, "Deaths", 0, 500, 1)
gui.add_slider(group, "Assists", 0, 500, 1)
gui.add_combo(group, "Rank", {"Unranked", "Silver 1", "Silver 2", "Silver 3", "Silver 4", "Silver Elite", "Silver Elite Master",
"Gold Nova 1", "Gold Nova 2", "Gold Nova 3", "Gold Nova 4",
"Master Guardian 1", "Master Guardian 2", "Master Guardian Elite", "Big Star",
"Legendary Eagle", "Legendary Eagle Master", "Supreme", "Global Elite"})


-- ______________
-- endregion: #elements
--


-- small: #installize elements
gui.instillize = true
-- endsmall: #installize elements




--
-- region: #global vars
-- ______________


globals_var = globals
globals = {
    config_dir = "primordial/idealyaw/",
    target = nil,
    screen_size = render.get_screen_size(),
    username = user.name,
    user_id = user.uid,
    small_font = render.create_font("arial", 12, 100),
    font = render.create_font("verdana", 12, 300),
    big_font = render.create_font("arial", 20, 900),
    pixel_font = render.create_font("smallest pixel-7", 11, 300, e_font_flags.OUTLINE)
}
helpers = {
    drag = {},
    animation = {data = {}},
    render = {}
}
functions = {
    rage = {},
    antiaim = {},
    visuals = {},
    misc = {},
    globals = {}
}
refs = {
    autopeek = menu.find("aimbot", "general", "misc", "autopeek"),
    doubletap = menu.find("aimbot", "general", "exploits", "doubletap", "enable"),
    hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable"),
    fakeping = menu.find("aimbot", "general", "fake ping", "enable"),
    override_resolver = menu.find("aimbot", "general", "aimbot", "override resolver"),
    roll_resolver = menu.find("aimbot", "general", "aimbot", "body lean resolver"),
    ragebot = menu.find("aimbot", "general", "aimbot", "enable"),
    minimum_damage = menu.find("aimbot", "scout", "target overrides", "force min. damage"),

    slowwalk = menu.find("misc", "main", "movement", "slow walk"),
    antiaim = menu.find("antiaim", "main", "general", "enable"),
    fakeduck = menu.find("antiaim", "main", "general", "fake duck"),
    left_manual = menu.find("antiaim", "main", "manual", "left"),
    right_manual = menu.find("antiaim", "main", "manual", "right"),
    back_manual = menu.find("antiaim", "main", "manual", "back"),
    inverter = menu.find("antiaim", "main", "manual", "invert desync")
}


-- ______________
-- endregion: #global vars
--



--
-- region: #configsystem
-- ______________

configs = {}
configs.export = function()
    local output = "IY<{"
    for G_ = 1, #gui.groups do
        local group = gui.groups[G_]
        local group_name = group[2]
        if group_name == "Tabs" or group_name == "Configs" then goto skip end
        for N_ = 1, #group[3] do
            local name = group[3][N_]
            local element = gui.get(group_name, name)
            local element_type = gui.get_type(group_name, name)
            if element_type == "checkbox" then
                output = output .. "[" .. group_name .. "," .. element:get_name() .. ":" .. tostring(element:get()) .. "!bool]"
            elseif element_type == "combo" then
                output = output .. "[" .. group_name .. "," .. element:get_name() .. ":" .. tostring(element:get()) .. "!int]"
            elseif element_type == "slider" then
                output = output .. "[" .. group_name .. "," .. element:get_name() .. ":" .. tostring(element:get()) .. "!int]"
            elseif element_type == "color" then
                local clr = element:get()
                local color_string = clr.r .. "," .. clr.g .. "," .. clr.b .. "," .. clr.a
                output = output .. "[" .. group_name .. "," .. element:get_name() .. ":color(" .. color_string .. ")!color]"
            elseif element_type == "list" then
                output = output .. "[" .. group_name .. "," .. element:get_name() .. ":" .. tostring(element:get()) .. "!int]"
            elseif element_type == "input" then
                output = output .. "[" .. group_name .. "," .. element:get_name() .. ":" .. tostring(element:get()) .. "!string]"
            elseif element_type == "multicombo" then
                local array_output = "array("
                local array_length = 1
                for AI_ = 1, #element:get_items() do
                    if element:get(AI_) then
                        array_output = array_output .. array_length .. ","
                    end
                    array_length = array_length + 1
                end
                array_output = array_output .. ")"
                output = output .. "[" .. group_name .. "," .. element:get_name() .. ":" .. array_output .. "!array]"
            end
        end
        ::skip::
    end
    output = output .. "}"
    return base64.encode(output)
end

configs.import = function(key_json)
    if key_json == nil then return false end
    local key_decode = base64.decode(key_json)
    if key_decode == nil then return false end
    local key_ = string.gmatch(key_decode, "[^<]+")
    if key_ == nil then return false end
    local key = {}
    for t in key_ do
        array.put(key, t)
    end
    if key[1] ~= "IY" then return false end
    local key = string.sub(key[2], 2, -2)

    local functions_ = string.gmatch(key, "[^[]+")
    if functions_ == nil then return false end
    local functions = {}
    for t in functions_ do
        array.put(functions, string.sub(t, 1, -2))
    end

    for i = 1, #functions do
        local function_info = {}
        for t in string.gmatch(functions[i], "[^:]+") do
            array.put(function_info, t)
        end
        local name_info = {}
        for t in string.gmatch(function_info[1], "[^,]+") do
            array.put(name_info, t)
        end
        local val_info = {}
        for t in string.gmatch(function_info[2], "[^!]+") do
            array.put(val_info, t)
        end
        local value = nil
        if val_info[2] == "int" then
            value = tonumber(val_info[1])
        elseif val_info[2] == "bool" then
            value = ({["false"] = false, ["true"] = true})[val_info[1]]
        elseif val_info[2] == "string" then
            value = val_info[1]
        elseif val_info[2] == "color" then
            local colors = string.sub(val_info[1], 7, -2)
            local output = {}
            if colors ~= "" then
                len = 1
                for t in string.gmatch(colors, "[^,]+") do
                    array.put(output, tonumber(t))
                end
            end
            value = color_t(output[1], output[2], output[3], output[4])
        elseif val_info[2] == "array" then
            local list = string.sub(val_info[1], 7, -3)
            local output = {}
            if list ~= "" then
                for t in string.gmatch(list, "[^,]+") do
                    array.put(output, t)
                end
            end
            if output ~= {} then
                value = output
            end
        end

        if value ~= nil then
            if val_info[2] == "array" then
                local element = gui.get(name_info[1], name_info[2])
                for idx = 1, #element:get_items() do
                    element:set(idx, false)
                end
                for idx = 1, #value do
                    element:set(tonumber(value[idx]), true)
                end
            else
                gui.get(name_info[1], name_info[2]):set(value)
            end
        end
    end

    return true
end


configs.create_index_config = function(config)
    local file_r = FileSystem.open(globals.config_dir .. "_indexes", "r")
    local file_context = file_r:read()
    file_r:close()
    if file_context == "" then file_context = "{}" end
    file_context = string.sub(file_context, 2, -2)

    local files = {}
    local files_ = string.gmatch(file_context, "[^,]+")
    if files_ ~= nil then
        for t in files_ do
            array.put(files, t)
        end
    end
    array.put(files, config)

    local new_file_context = "{"
    for i = 1, #files do
        local file = files[i]
        new_file_context = new_file_context .. file
        if i ~= #files then
            new_file_context = new_file_context .. ","
        end
    end
    new_file_context = new_file_context .. "}"

    local file_w = FileSystem.open(globals.config_dir .. "_indexes", "w")
    file_w:write(new_file_context) file_w:close()
end
configs.exist_index_config = function(config)
    local file_r = FileSystem.open(globals.config_dir .. "_indexes", "r")
    local file_context = file_r:read()
    file_r:close()
    if file_context == "" then file_context = "{}" end
    file_context = string.sub(file_context, 2, -2)

    local files_ = string.gmatch(file_context, "[^,]+")
    if files_ ~= nil then
        for t in files_ do
            if t == config then return true end
        end
    end
    return false
end
configs.remove_index_config = function(config)
    local file_r = FileSystem.open(globals.config_dir .. "_indexes", "r")
    local file_context = file_r:read()
    file_r:close()
    if file_context == "" then file_context = "{}" end
    file_context = string.sub(file_context, 2, -2)

    local files = {}
    local files_ = string.gmatch(file_context, "[^,]+")
    if files_ ~= nil then
        for t in files_ do
            if t ~= config then
                array.put(files, t)
            end
        end
    end

    local new_file_context = "{"
    for i = 1, #files do
        local file = files[i]
        new_file_context = new_file_context .. file
        if i ~= #files then
            new_file_context = new_file_context .. ","
        end
    end
    new_file_context = new_file_context .. "}"

    local file_w = FileSystem.open(globals.config_dir .. "_indexes", "w")
    file_w:write(new_file_context) file_w:close()
end
configs.get_indexes_configs = function()
    local file_r = FileSystem.open(globals.config_dir .. "_indexes", "r")
    local file_context = file_r:read()
    file_r:close()
    if file_context == "" then file_context = "{}" end
    file_context = string.sub(file_context, 2, -2)

    local files = {}
    local files_ = string.gmatch(file_context, "[^,]+")
    if files_ ~= nil then
        for t in files_ do
            array.put(files, t)
        end
    else
        array.put(files, file_context)
    end
    return files
end

configs.update = function()
    config_list = {}
    local config_file_list = configs.get_indexes_configs()
    for i = 1, #config_file_list do
        array.put(config_list, config_file_list[i])
    end
    if #config_file_list == 0 then array.put(config_list, "-") end
    gui.get("Configs", "Configs list"):set_items(config_list)
end

configs.instillize = function()
    if not FileSystem.is_directory(globals.config_dir) then 
        FileSystem.create_directory(globals.config_dir)
    end

    if not FileSystem.exists(globals.config_dir .. "_indexes") then 
        FileSystem.open(globals.config_dir .. "_indexes", "w"):close()
    end

    configs.update()
end

configs.active_config = ""
configs.core = function()
    local config_selected = gui.get("Configs", "Configs list"):get()
    local config_name = gui.get("Configs", "Config name"):get()
    if configs.active_config ~= config_list[config_selected] then
        configs.active_config = config_list[config_selected]
        if configs.active_config == "-" then
            configs.active_config = ""
        end
    end
end
configs.save = function(name)
    if name == "" then print("Selected config name error") return end
    if not FileSystem.exists(globals.config_dir .. name .. ".cfg") then 
        FileSystem.open(globals.config_dir .. name .. ".cfg", "w"):close()
    end
    local config = FileSystem.open(globals.config_dir .. name .. ".cfg", "w")
    config:write(configs.export())
    config:close()

    configs.update()
end
configs.load = function(name)
    if name == "" then print("Selected config name error") return end
    if not FileSystem.exists(globals.config_dir .. name .. ".cfg") then 
        FileSystem.open(globals.config_dir .. name .. ".cfg", "w"):close()
    end
    local config = FileSystem.open(globals.config_dir .. name .. ".cfg", "r")
    local config_context = config:read()
    if config_context == "" or not configs.import(config_context) then
        print("Config load error (config file is corrupted)")
    end

    configs.update()
end
configs.create = function(name)
    if name == "" then print("Selected config name error") return end
    if not configs.exist_index_config(name) then
        configs.create_index_config(name)
        if not FileSystem.exists(globals.config_dir .. name .. ".cfg") then 
            FileSystem.open(globals.config_dir .. name .. ".cfg", "w"):close()
        end
        local config = FileSystem.open(globals.config_dir .. name .. ".cfg", "w")
        config:write(configs.export())
        config:close()
    else
        print("Config create error (config already exist)")
    end

    configs.update()
end
configs.remove = function(name)
    if name == "" then print("Selected config name error") return end
    if FileSystem.exists(globals.config_dir .. name .. ".cfg") then 
        FileSystem.remove(globals.config_dir .. name .. ".cfg")
    end
    configs.remove_index_config(name)

    configs.update()
end

-- ______________
-- endregion: #configsystem
--



--
-- globals: #helpers
-- ______________
helpers.animation.lerp = function(start, end_pos, time) if type(start) == 'userdata' then local color_data = {0, 0, 0, 0} for i, color_key in ipairs({'r', 'g', 'b', 'a'}) do color_data[i] = helpers.animation.lerp(start[color_key], end_pos[color_key], time) end return color_t(unpack(color_data)) end return (end_pos - start) * (globals_var.frame_time() * time * 175) + start end
helpers.animation.new = function(name, value, time, start) if helpers.animation.data[name] == nil then helpers.animation.data[name] = start end helpers.animation.data[name] = helpers.animation.lerp(helpers.animation.data[name], value, time) return helpers.animation.data[name] end

helpers.drag.list = {}
helpers.drag.names = {}
helpers.drag.enables = {}
helpers.drag.standart_anim = {}
helpers.drag.func = function(id, x_var, y_var, size, standarts)
    if not menu.is_open() then return end
    if input.is_mouse_in_bounds(menu.get_pos(), menu.get_size()) then return end
    local mouse_position = input.get_mouse_pos()
    local is_clicked = input.is_key_held(e_keys.MOUSE_LEFT)
    local pos = vec2_t(x_var:get(), y_var:get())
    if not helpers.drag.enables[id] then helpers.drag.enables[id] = false end
    if not helpers.drag.standart_anim[id] then helpers.drag.standart_anim[id] = nil end
    if not helpers.drag.list[id] then helpers.drag.list[id] = vec2_t(0, 0) end
    local is_exist = false
    for i = 1, #helpers.drag.names do
        if helpers.drag.names[i] == id then is_exist = true end
    end
    if not is_exist then helpers.drag.names[#helpers.drag.names+1] = id end

    local in_box = function(pos, start, stop)
        return pos.x + 1 > start.x and pos.x - 1 < start.x + stop.x and pos.y + 1 > start.y and pos.y - 1 < start.y + stop.y
    end

    local draggings = 0
    for i = 1, #helpers.drag.names do
        if helpers.drag.enables[helpers.drag.names[i]] then
            draggings = draggings + 1
            if draggings >= 2 then helpers.drag.enables[helpers.drag.names[i]] = false end
        end
    end

    local standart = nil
    if #standarts > 0 then
        local anim = helpers.animation.new(id .. "standart", helpers.drag.enables[id] and 1 or 0.001, 0.1, 0)
        if anim >= 0.01 then
            for i = 1, #standarts do
                local standart_position = standarts[i]

                local if_in_box = in_box(pos, standart_position, size)
                    or in_box(pos + vec2_t(size.x, 0), standart_position, size)
                    or in_box(pos + vec2_t(0, size.y), standart_position, size)
                    or in_box(pos + size, standart_position, size)

                local anim_in_box = helpers.animation.new(id .. "standart" .. i, if_in_box and 1 or 0.5, 0.1, 0)

                render.rect_filled(standart_position, size, color_t(255, 255, 255, math.floor(50 * anim_in_box * anim)), 3)
                if if_in_box then
                    standart = standart_position
                end
            end
        end
    end

    local anim = helpers.animation.new(id .. "hint", (input.is_mouse_in_bounds(pos, size)) and 1 or 0.001, 0.1, 0)
    if anim > 0.01 then
        render.rect(pos - vec2_t(2, 2), size + vec2_t(3, 3), color_t(120, 120, 120, math.floor(255 * anim)), 3)
        render.text(globals.small_font, "Use LMB for dragging element", pos + vec2_t(0, size.y + 4), color_t(255, 255, 255, math.floor(255 * anim)))
        -- render.rect_outline(pos - vector(2, 2), pos + size + vector(2, 2), color(120, 120, 120, 255 * anim), 1, 6)
        -- render.text(small_font, pos + vector(0, size.y + 4), color(200, 200, 200, 255 * anim), '', "Use LMB for dragging element")
    end

    if input.is_mouse_in_bounds(pos, size) and is_clicked then
        if not helpers.drag.enables[id] then
            helpers.drag.list[id] = mouse_position - pos
            helpers.drag.enables[id] = true
        end
    elseif not is_clicked and helpers.drag.enables[id] then
        if standart ~= nil then
            helpers.drag.standart_anim[id] = standart
        end
        helpers.drag.enables[id] = false
    end
    if helpers.drag.enables[id] then
        helpers.drag.standart_anim[id] = nil

        new_pos = mouse_position - helpers.drag.list[id]
        x_var:set(new_pos.x)
        y_var:set(new_pos.y)
    end
    local animation_x = helpers.animation.new(id .. "standart_x", helpers.drag.standart_anim[id] ~= nil and helpers.drag.standart_anim[id].x or x_var:get(), 0.05, x_var:get())
    local animation_y = helpers.animation.new(id .. "standart_y", helpers.drag.standart_anim[id] ~= nil and helpers.drag.standart_anim[id].y or y_var:get(), 0.05, y_var:get())
    if not helpers.drag.enables[id] and helpers.drag.standart_anim[id] ~= nil then
        x_var:set(animation_x)
        y_var:set(animation_y)

        local diff_x = x_var:get() - helpers.drag.standart_anim[id].x
        local diff_y = y_var:get() - helpers.drag.standart_anim[id].y

        if diff_x < 0 then diff_x = diff_x * -1 end
        if diff_y < 0 then diff_y = diff_y * -1 end

        if diff_x < 1 and diff_y < 1 then
            standart = nil
            helpers.drag.standart_anim[id] = nil
        end
    end
end

helpers.render.arc = function(pos, radius, radius_inner, start_, end_, color)
    local start_ =  start_ *            (math.pi / 180);
    local end_ =    (start_ + end_) *   (math.pi / 180);
    local step =    18 *                 (math.pi / 180);

    for i = start_, end_, step do
        local cos = math.cos(i);
        local sin = math.sin(i);

        render.line(vec2_t(pos[1] + cos * radius, pos[2] + sin * radius), vec2_t(pos[1] + cos * radius_inner, pos[2] + sin * radius_inner), color)
    end
end

helpers.render.fade = function(pos, size, radius, clr)
    local a_step = 10 / radius
    local alpha = 10
    for i = 1, radius do
        render.rect(pos - vec2_t(i, i), size + vec2_t(i*2, i*2), color_t(clr.r, clr.g, clr.b, math.floor(alpha)), i + 1)
        alpha = alpha - a_step
    end
end

helpers.render.fade_rainbow = function()
    hue_val = math.max((math.sin((globals_var.cur_time() % 4) * 4) + 1) / 2.4, 0)
    hue = color_t.from_hsb(hue_val, 1, 1)
    return hue
end

helpers.render.multicolor_text = function(font, str, pos)
    local substrs_t = {}
    for t in string.gmatch(str, "[^(]+") do
        array.put(substrs_t, t)
    end
    local substrs_g = {}
    for i = 1, #substrs_t do
        if i ~= #substrs_t then
            array.put(substrs_g, string.sub(substrs_t[i], 1, -4))
        else
            array.put(substrs_g, substrs_t[i])
        end
    end

    local substrs = {}
    for i = 1, #substrs_g do
        local substrs_info = {}
        for t in string.gmatch(substrs_g[i], "[^)]+") do
            array.put(substrs_info, t)
        end
        array.put(substrs, {substrs_info[2], substrs_info[1]})
    end

    local position = vec2_t(pos.x, pos.y)
    for i = 1, #substrs do
        if substrs[i][1] == nil then goto skip end
        local clr = {}
        for t in string.gmatch(substrs[i][2], "[^,]+") do
            array.put(clr, tonumber(t))
        end
        local color = color_t(clr[1], clr[2], clr[3], clr[4])
        if clr[1] == nil or clr[2] == nil or clr[3] == nil or clr[4] == nil then
            color = color_t(255, 255, 255, 120)
        end
        render.text(font, substrs[i][1], position, color)
        position.x = position.x + render.get_text_size(font, substrs[i][1]).x
        ::skip::
    end
end

-- ______________
-- endgobals: #helpers
--



--
-- global callback: #get_target
-- ______________


functions.globals.get_target = function()
    if not entity_list.get_local_player() then return end

    local enemies_only = entity_list.get_players(true)
    local lp = entity_list.get_local_player()
    local is_target = false

    for _, enemy in pairs(enemies_only) do
        if enemy:is_alive() then
            if lp:is_point_visible(enemy:get_hitbox_pos(e_hitboxes.HEAD)) then
                globals.target = enemy
                is_target = true
            end
        end
    end

    if not is_target then globals.target = nil end
end


-- ______________
-- end global callback: #get_target
--



--
-- region: #block recharge if enemy visibly
-- ______________

functions.rage.block_recharge_if_enemy_visibly = function()
    if not gui.get("Rage - general", "Block recharge if enemy visibly"):get() then return end
    if globals.target ~= nil then
        exploits.block_recharge()
    else
        exploits.allow_recharge()
    end
end

functions.rage.block_recharge_if_enemy_visibly_on_disable = function()
    exploits.allow_recharge()
end


-- ______________
-- endregion: #block recharge if enemy visibly
--



--
-- region: #block recharge if enemy visibly
-- ______________

functions.rage.doubletap_override = function()
    if gui.get("Rage - general", "Override doubletap"):get() then
        cvars.sv_maxusrcmdprocessticks:set_int(gui.get("Rage - general", "DT speed (15 - default)"):get())
    else
        cvars.sv_maxusrcmdprocessticks:set_int(15)
    end
end

-- ______________
-- endregion: #block recharge if enemy visibly
--




--
-- region: #idealtick
-- ______________


functions.rage.ideal_tick = function(args)
    if not gui.get("Rage - general", "Ideal Tick"):get() then return end
    if not gui.get("Rage - general", "idealtick_bind"):get() then return end
    if ragebot.get_autopeek_pos() and exploits.get_charge() > 0 then
        local lp = entity_list.get_local_player()
        local weapon = lp:get_active_weapon():get_name()
        local select_weapons = gui.get("Rage - general", "Ideal Tick Weapons")
        if (weapon == "ssg08" and select_weapons:get(1)) or (weapon == "awp" and select_weapons:get(2)) then
            args[1]:set_hitscan_group_state(e_hitscan_groups.HEAD, false)
            args[1]:set_hitchance(30)
            args[1]:set_min_dmg(10)
            args[1]:set_damage_accuracy(10)
            args[1]:set_safepoint_state(false)
        end
    end
end


-- ______________
-- endregion: #idealtick
--



--
-- region: #autoteleport
-- ______________

functions.rage.auto_teleport_enable = 0
functions.rage.auto_teleport = function()
    if not gui.get("Rage - general", "Auto force teleport"):get() then return end
    if not gui.get("Rage - general", "autotp_bind"):get() then return end

    if functions.rage.auto_teleport_enable > 0 and functions.rage.auto_teleport_enable < 50 then
        functions.rage.auto_teleport_enable = functions.rage.auto_teleport_enable + 1
    end
    if functions.rage.auto_teleport_enable >= 50 then
        functions.rage.auto_teleport_enable = 0
    end

    local ticks = gui.get("Rage - general", "Override doubletap"):get() and gui.get("Rage - general", "DT speed (15 - default)"):get() - 4 or 11

    local lp = entity_list.get_local_player()
	local hb = lp:get_hitbox_pos(e_hitboxes.HEAD)
    local velocity = lp:get_prop("m_vecVelocity", 0)
    local tick_interval = globals_var.interval_per_tick()
    local extrapolation = vec3_t(
        hb.x + velocity.x * tick_interval * ticks,
        hb.y + velocity.y * tick_interval * ticks,
        hb.z + velocity.z * tick_interval * ticks)

    if velocity.z < -50 and not input.is_key_held(e_keys.KEY_SPACE) then
        local enemies_only = entity_list.get_players(true)

        for _, enemy in pairs(enemies_only) do
            if enemy:is_alive() and exploits.get_charge() > 1 then
                if enemy:is_point_visible(extrapolation) then
                    exploits.force_uncharge()
                    functions.rage.auto_teleport_enable = 1
                end
            end
        end
    end
end

-- ______________
-- endregion: #autoteleport
--




--
-- region: #antiaim states
-- ______________
functions.antiaim.freestanding = function()
    if not gui.get("Antiaim - general", "Enable freestanding"):get() then return end
    local _, bind = unpack(menu.find("antiaim", "main", "auto direction", "enable"))
    if not bind:get() then client.log("Enable \"antiaim->main->auto direction->enable\" on \"always on\"!") return end
    local states = gui.get("Antiaim - general", "Enable on ...")
    if gui.get("Antiaim - general", "freestand_bind"):get() then
        menu.find("antiaim", "main", "auto direction", "states"):set(1, states:get(1))
        menu.find("antiaim", "main", "auto direction", "states"):set(2, states:get(2))
        menu.find("antiaim", "main", "auto direction", "states"):set(3, states:get(3))
    else
        menu.find("antiaim", "main", "auto direction", "states"):set(1, false)
        menu.find("antiaim", "main", "auto direction", "states"):set(2, false)
        menu.find("antiaim", "main", "auto direction", "states"):set(3, false)
    end
    menu.find("antiaim", "main", "auto direction", "target selection"):set(1)
    menu.find("antiaim", "main", "auto direction", "disable jitter"):set(true)
    menu.find("antiaim", "main", "auto direction", "disable rotate"):set(true)
end

functions.antiaim.fakelags_switch = false
functions.antiaim.fakelags_switch_tick = 0
functions.antiaim.fakelags_switch_current = 0
functions.antiaim.fakelags = function(args)
    if not gui.get("Antiaim - general", "Custom fakelags"):get() then return end

    local fakelags_menu = gui.get("Antiaim - general", "Fakelags amount"):get()
    local fakelags_type = gui.get("Antiaim - general", "Fakelags type"):get()
    local fakelags = 0
    if fakelags_type == 1 then
        fakelags = fakelags_menu
    elseif fakelags_type == 2 then
        functions.antiaim.fakelags_switch_tick = functions.antiaim.fakelags_switch_tick + 1
        if functions.antiaim.fakelags_switch_tick % 5 == 0 then
            if functions.antiaim.fakelags_switch then
                functions.antiaim.fakelags_switch_current = functions.antiaim.fakelags_switch_current - 1
            else
                functions.antiaim.fakelags_switch_current = functions.antiaim.fakelags_switch_current + 1
            end
            if functions.antiaim.fakelags_switch_current > fakelags_menu - 1 then
                functions.antiaim.fakelags_switch = true
            end
            if functions.antiaim.fakelags_switch_current < 1 then
                functions.antiaim.fakelags_switch = false
            end
        end
        fakelags = functions.antiaim.fakelags_switch_current
    elseif fakelags_type == 3 then
        fakelags = client.random_int(1, fakelags_menu)
    end
    menu.find("antiaim", "main", "fakelag", "amount"):set(fakelags)

    local breaklagcomp = gui.get("Antiaim - general", "Break lag compensation"):get()
    local breaklc = false
    if breaklagcomp == 2 then
        breaklc = true
    elseif breaklagcomp == 3 then
        if entity_list.get_local_player():has_player_flag(e_player_flags.ON_GROUND) then
            breaklc = true
        end
    end
    menu.find("antiaim", "main", "fakelag", "break lag compensation"):set(breaklc)
end

functions.antiaim.states_switch = false
functions.antiaim.states = function()
    local state_enabled = gui.get("Antiaim - states", "Enable                              Inverter"):get()
    if not state_enabled then return end
    local scan_resolver = gui.get("Antiaim - states", "Scan enemy resolver (body yaw)"):get()

    local state = gui.get("Antiaim - states", "invert_state"):get() and "(r) " or "(l) "
    menu.find("antiaim", "main", "angles", "pitch"):set(gui.get("Antiaim - states", "Pitch"):get())
    menu.find("antiaim", "main", "angles", "yaw base"):set(gui.get("Antiaim - states", state .. "Base"):get() + 1)
    menu.find("antiaim", "main", "angles", "yaw add"):set(gui.get("Antiaim - states", state .. "Yaw"):get())
    menu.find("antiaim", "main", "angles", "rotate"):set(false)
    menu.find("antiaim", "main", "angles", "jitter mode"):set(gui.get("Antiaim - states", state .. "Jitter"):get() == 1 and 1 or 2)
    menu.find("antiaim", "main", "angles", "jitter type"):set(gui.get("Antiaim - states", state .. "Jitter"):get() == 3 and 2 or 1)
    menu.find("antiaim", "main", "angles", "jitter add"):set(gui.get("Antiaim - states", state .. "Jitter offset"):get())
    menu.find("antiaim", "main", "desync", "override stand#move"):set(false)
    menu.find("antiaim", "main", "desync", "override stand#slow walk"):set(false)

    local body_yaw = gui.get("Antiaim - states", state .. "Body yaw")
    local percent_desync = gui.get("Antiaim - states", state .. "Body yaw value"):get() / 60 * 100

    if scan_resolver then
        local enemy = globals.target
        if enemy ~= nil then
            local enemy_view = enemy:get_render_angles().y
            local local_view = entity_list.get_local_player():get_render_angles().y
            local diff = (enemy_view - local_view) / 4
            if diff < 0 then diff = diff * -1 end
            diff = math.floor(math.min(diff, 60))

            percent_desync = diff / 60 * 100
        end
    end

    local negative = percent_desync < 0
    if negative then percent_desync = percent_desync * -1 end
    percent_desync = math.floor(percent_desync)

    if body_yaw:get() == 4 or body_yaw:get() == 5 then
        percent_desync = client.random_int(1, percent_desync)
    end

    menu.find("antiaim", "main", "desync", "side#stand"):set(body_yaw:get() == 1 and 1 or body_yaw:get() == 2 and (negative and 2 or 3) or body_yaw:get() == 3 and 4 or body_yaw:get() == 4 and 2 or body_yaw:get() == 5 and 3 or 1)
    menu.find("antiaim", "main", "desync", "left amount#stand"):set(percent_desync)
    menu.find("antiaim", "main", "desync", "right amount#stand"):set(percent_desync)

    menu.find("antiaim", "main", "desync", "anti bruteforce"):set(gui.get("Antiaim - states", "Anti bruteforce"):get())
    menu.find("antiaim", "main", "desync", "on shot"):set(3)
end
-- ______________
-- endregion: #antiaim states
--




--
-- region: #indicators
-- ______________


--
-- subregion: #windows
-- ______________

functions.visuals.render_window = function(start, stop, clr)
    local window_style = gui.get("Visuals - indicators", "Windows style"):get()

    if window_style == 1 then
        render.rect_filled(start, stop, color_t(0, 0, 0, math.floor(140 * (clr.a / 255))))
        render.rect_filled(start, vec2_t(stop.x, 2), clr)
    elseif window_style == 2 then
        render.rect_filled(start, stop, color_t(0, 0, 0, math.floor(140 * (clr.a / 255))))
        render.rect_filled(start + vec2_t(0, stop.y - 2), vec2_t(stop.x, 2), clr)
    elseif window_style == 3 then
        render.rect_filled(start + vec2_t(1, 1), stop - vec2_t(2, 1), color_t(0, 0, 0, math.floor(140 * (clr.a / 255))))
        render.rect_filled(start + vec2_t(3, 0), vec2_t(stop.x - 6, 1), clr)
        render.line(start + vec2_t(3, 0), start + vec2_t(0, 3), clr)
        render.line(start + vec2_t(2, 0), start + vec2_t(0, 2), clr)
        render.rect_fade(start + vec2_t(0, 3), vec2_t(1, stop.y - 8), clr, color_t(clr.r, clr.g, clr.b, 0))

        render.line(start + vec2_t(stop.x - 3, 0), start + vec2_t(stop.x, 3), clr)
        render.line(start + vec2_t(stop.x - 2, 0), start + vec2_t(stop.x, 2), clr)
        render.rect_fade(start + vec2_t(stop.x - 1, 3), vec2_t(1, stop.y - 8), clr, color_t(clr.r, clr.g, clr.b, 0))

        helpers.render.fade(start, stop, 6, clr)
    elseif window_style == 4 then
        render.rect_filled(start + vec2_t(1, 1), stop - vec2_t(2, 1), color_t(0, 0, 0, math.floor(140 * (clr.a / 255))))
        --render.rect_filled(start + vec2_t(3, 0), vec2_t(stop.x - 6, 1), clr)
        render.rect_fade(start + vec2_t(3, 0), vec2_t((stop.x - 6) / 2 - 30, 1), clr, color_t(clr.r, clr.g, clr.b, 0), true)
        render.rect_fade(start + vec2_t(3 + (stop.x - 6) / 2 + 30, 0), vec2_t((stop.x - 6) / 2 - 30, 1), color_t(clr.r, clr.g, clr.b, 0), clr, true)
        render.line(start + vec2_t(3, 0), start + vec2_t(0, 3), clr)
        render.line(start + vec2_t(2, 0), start + vec2_t(0, 2), clr)
        render.rect_fade(start + vec2_t(0, 3), vec2_t(1, stop.y - 8), clr, color_t(clr.r, clr.g, clr.b, 0))

        render.line(start + vec2_t(stop.x - 3, 0), start + vec2_t(stop.x, 3), clr)
        render.line(start + vec2_t(stop.x - 2, 0), start + vec2_t(stop.x, 2), clr)
        render.rect_fade(start + vec2_t(stop.x - 1, 3), vec2_t(1, stop.y - 8), clr, color_t(clr.r, clr.g, clr.b, 0))

        helpers.render.fade(start, stop, 6, clr)
    elseif window_style == 5 then
        render.rect_filled(start + vec2_t(1, 1), stop - vec2_t(2, 1), color_t(0, 0, 0, math.floor(140 * (clr.a / 255))))
        render.rect_filled(start + vec2_t(3, stop.y - 1), vec2_t(stop.x - 6, 1), clr)
        render.line(start + vec2_t(3, stop.y - 1), start + vec2_t(0, stop.y - 3), clr)
        render.line(start + vec2_t(2, stop.y - 1), start + vec2_t(0, stop.y - 2), clr)
        render.rect_fade(start + vec2_t(0, 5), vec2_t(1, stop.y - 8), color_t(clr.r, clr.g, clr.b, 0), clr)

        render.line(start + vec2_t(stop.x - 3, stop.y - 1), start + vec2_t(stop.x, stop.y - 4), clr)
        render.line(start + vec2_t(stop.x - 2, stop.y - 1), start + vec2_t(stop.x, stop.y - 2), clr)
        render.rect_fade(start + vec2_t(stop.x - 1, 5), vec2_t(1, stop.y - 8), color_t(clr.r, clr.g, clr.b, 0), clr)

        helpers.render.fade(start, stop, 6, clr)
    elseif window_style == 6 then
        render.rect_filled(start + vec2_t(1, 1), stop - vec2_t(2, 1), color_t(0, 0, 0, math.floor(140 * (clr.a / 255))))
        render.rect_filled(start + vec2_t(3, stop.y - 1), vec2_t(stop.x - 6, 1), clr)
        render.rect_filled(start + vec2_t(3, 0), vec2_t(stop.x - 6, 1), clr)

        render.line(start + vec2_t(3, stop.y - 1), start + vec2_t(0, stop.y - 3), clr)
        render.line(start + vec2_t(2, stop.y - 1), start + vec2_t(0, stop.y - 2), clr)
        render.line(start + vec2_t(stop.x - 3, stop.y - 1), start + vec2_t(stop.x, stop.y - 4), clr)
        render.line(start + vec2_t(stop.x - 2, stop.y - 1), start + vec2_t(stop.x, stop.y - 2), clr)

        render.line(start + vec2_t(3, 0), start + vec2_t(0, 3), clr)
        render.line(start + vec2_t(2, 0), start + vec2_t(0, 2), clr)
        render.line(start + vec2_t(stop.x - 3, 0), start + vec2_t(stop.x, 3), clr)
        render.line(start + vec2_t(stop.x - 2, 0), start + vec2_t(stop.x, 2), clr)

        render.rect_filled(start + vec2_t(0, 3), vec2_t(1, stop.y - 6), clr)
        render.rect_filled(start + vec2_t(stop.x - 1, 3), vec2_t(1, stop.y - 6), clr)

        helpers.render.fade(start, stop, 6, clr)
    end
end

-- ______________
-- endsubregion: #windows
--

--
-- subregion: #keybinds
-- ______________
functions.visuals.kb_group = gui.create_group("kb", 1, false)
functions.visuals.kb_x = gui.add_slider(functions.visuals.kb_group, "kb_x", 0, globals.screen_size[1], 1) functions.visuals.kb_x:set_visible(false) functions.visuals.kb_x:set(300)
functions.visuals.kb_y = gui.add_slider(functions.visuals.kb_group, "kb_y", 0, globals.screen_size[2], 1) functions.visuals.kb_y:set_visible(false) functions.visuals.kb_y:set(200)
functions.visuals.kb_offset = 0
functions.visuals.kb_max_x = 0
functions.visuals.kb_cur_x = 0
functions.visuals.keybinds = function()
    if not gui.get("Visuals - indicators", "Windows"):get(1) then return end
    local position = vec2_t(functions.visuals.kb_x:get(), functions.visuals.kb_y:get())
    local size = vec2_t(0, 20)
    local render_bind = function(bind)
        local anim = helpers.animation.new(string.gsub(bind[1], " ", ""), bind[2] and 1 or 0.01, 0.1, 0)
        if anim <= 0.05 then return end

        functions.visuals.kb_offset = functions.visuals.kb_offset + anim

        local mode_text = {[0] = "toggle", [1] = "holding", [2] = "holding off", [3] = "on", [4] = "off"}

        local bind_size = render.get_text_size(globals.font, bind[1])
        render.text(globals.font, bind[1], position + vec2_t(3, 10 + 14 * functions.visuals.kb_offset), color_t(255, 255, 255, math.floor(255 * anim)))
        local mode_size = render.get_text_size(globals.font, mode_text[bind[3]])
        render.text(globals.font, mode_text[bind[3]], position + vec2_t(size.x - mode_size.x - 3, 10 + 14 * functions.visuals.kb_offset), color_t(255, 255, 255, math.floor(255 * anim)))

        if bind[2] then
            local total_size = bind_size.x + mode_size.x + 10 + 30
            if total_size > functions.visuals.kb_max_x then functions.visuals.kb_max_x = total_size end
        end
    end

    functions.visuals.kb_cur_x = helpers.animation.new("kbsize", (functions.visuals.kb_max_x < 120 and 120 or functions.visuals.kb_max_x), 0.1, 0)
    size = vec2_t(functions.visuals.kb_cur_x, 20)

    functions.visuals.render_window(position, size, gui.get("Visuals - indicators", "keybinds_clr"):get())
    render.text(globals.font, "keybinds", position + vec2_t(size.x / 2, 10), color_t(255, 255, 255), true)

    functions.visuals.keybinds_list = {
        {"autopeek", refs.autopeek[2]:get(), refs.autopeek[2]:get_mode()},
        {"doubletap", refs.doubletap[2]:get(), refs.doubletap[2]:get_mode()},
        {"hideshots", refs.hideshots[2]:get(), refs.hideshots[2]:get_mode()},
        {"fakeping", refs.fakeping[2]:get(), refs.fakeping[2]:get_mode()},
        {"override resolver", refs.override_resolver[2]:get(), refs.override_resolver[2]:get_mode()},
        {"roll resolver", refs.roll_resolver[2]:get(), refs.roll_resolver[2]:get_mode()},
        {"slowwalk", refs.slowwalk[2]:get(), refs.slowwalk[2]:get_mode()},
        {"fakeduck", refs.fakeduck[2]:get(), refs.fakeduck[2]:get_mode()},
        {"left", refs.left_manual[2]:get(), refs.left_manual[2]:get_mode()},
        {"right", refs.right_manual[2]:get(), refs.right_manual[2]:get_mode()},
        {"back", refs.back_manual[2]:get(), refs.back_manual[2]:get_mode()},
        {"inverter", refs.inverter[2]:get(), refs.inverter[2]:get_mode()},
        {"override damage", refs.minimum_damage[2]:get(), refs.minimum_damage[2]:get_mode()},
    }

    functions.visuals.kb_offset = 0
    functions.visuals.kb_max_x = 0
    for i = 1, #functions.visuals.keybinds_list do
        local current = functions.visuals.keybinds_list[i]
        render_bind(current)
    end

    local size_y = 20 + 15 * functions.visuals.kb_offset + (functions.visuals.kb_offset > 0.1 and 5 or 0)
    helpers.drag.func("keybinds", functions.visuals.kb_x, functions.visuals.kb_y, vec2_t(size.x, size_y),
        {vec2_t(100, 500), vec2_t(300, 200), vec2_t(globals.screen_size.x / 2 - size.x / 2, 200)})
end

-- ______________
-- endsubregion: #keybinds
--


--
-- subregion: #watermark
-- ______________

functions.visuals.wm_group = gui.create_group("wm", 1, false)
functions.visuals.wm_x = gui.add_slider(functions.visuals.wm_group, "wm_x", 0, globals.screen_size[1], 1) functions.visuals.wm_x:set_visible(false) functions.visuals.wm_x:set(450)
functions.visuals.wm_y = gui.add_slider(functions.visuals.wm_group, "wm_y", 0, globals.screen_size[2], 1) functions.visuals.wm_y:set_visible(false) functions.visuals.wm_y:set(200)
functions.visuals.watermark = function()
    if not gui.get("Visuals - indicators", "Windows"):get(2) then return end
    local position = vec2_t(functions.visuals.wm_x:get(), functions.visuals.wm_y:get())

    local elements = gui.get("Visuals - indicators", "Watermark elements")
    local name = gui.get("Visuals - indicators", "Watermark name"):get()

    local separator = "   "
    local text = "primordial.dev"
    if name == 2 then text = "prim" end
    if name == 3 then text = "idealyaw" end

    if elements:get(1) then text = text .. separator .. globals.username end
    if elements:get(2) then text = text .. " (" .. globals.user_id .. ")" end
    if entity_list.get_local_player() then
        if elements:get(3) then text = text .. separator .. math.floor( engine.get_latency( e_latency_flows.OUTGOING ) * 1000 ) .. "ms" end
        if elements:get(4) then text = text .. separator .. client.get_tickrate() .. "tick" end
        if elements:get(5) then text = text .. separator .. "server ip" end
    end
    if elements:get(6) then
        local hours, minutes, seconds = client.get_local_time()
        local actual_time = ("%02d:%02d:%02d"):format(hours, minutes, seconds)
        text = text .. separator ..  actual_time
    end

    local anim = helpers.animation.new("wm", render.get_text_size(globals.font, text).x + 10, 0.05, 0)

    local size = vec2_t(anim, 20)

    functions.visuals.render_window(position, size, gui.get("Visuals - indicators", "watermark_clr"):get())
    render.push_clip(position, vec2_t(anim, 20))
    render.text(globals.font, text, position + vec2_t(5, 4), color_t(255, 255, 255))
    render.pop_clip()

    helpers.drag.func("watermark", functions.visuals.wm_x, functions.visuals.wm_y, size,
        {vec2_t(globals.screen_size[1] - size.x - 10, 10)})
end

-- ______________
-- endsubregion: #watermark
--


--
-- subregion: #logs
-- ______________

functions.visuals.logs_list = {}
functions.visuals.animation = 0
functions.visuals.id = 1
functions.visuals.logs_group = gui.create_group("logs", 1, false)
functions.visuals.logs_x = gui.add_slider(functions.visuals.logs_group, "logs_x", 0, globals.screen_size[1], 1) functions.visuals.logs_x:set_visible(false) functions.visuals.logs_x:set(globals.screen_size[1] / 2 - 150)
functions.visuals.logs_y = gui.add_slider(functions.visuals.logs_group, "logs_y", 0, globals.screen_size[2], 1) functions.visuals.logs_y:set_visible(false) functions.visuals.logs_y:set(globals.screen_size[2] / 2 + 200)
functions.visuals.logs = function()
    if not gui.get("Visuals - indicators", "Windows"):get(3) then return end
    if not gui.get("Visuals - indicators", "Logs output"):get(1) then return end
    local position = vec2_t(functions.visuals.logs_x:get(), functions.visuals.logs_y:get())
    local size = vec2_t(300, 150)

    if menu.is_open() then
        render.text(globals.font, "Hit Mister in stomach for 56hp (44 remaining)", vec2_t(position.x + size.x / 2, position.y + 1 * 10), color_t(255, 255, 255), true)
        render.text(globals.font, "Missed in Mister head on resolver", vec2_t(position.x + size.x / 2, position.y + 2 * 10), color_t(255, 255, 255), true)
        render.text(globals.font, "Missed in Mister head on prediction", vec2_t(position.x + size.x / 2, position.y + 3 * 10), color_t(255, 255, 255), true)
        render.text(globals.font, "Missed in Mister head on spread", vec2_t(position.x + size.x / 2, position.y + 4 * 10), color_t(255, 255, 255), true)
        render.text(globals.font, "Hurted from Mister in head for 149hp (death)", vec2_t(position.x + size.x / 2, position.y + 5 * 10), color_t(255, 255, 255), true)
        render.text(globals.font, "Mister buying weapon_ssg08", vec2_t(position.x + size.x / 2, position.y + 6 * 10), color_t(255, 255, 255), true)
    end

    local render_log = function(info)
        if functions.visuals.animation > 13 then return end
        local anim = helpers.animation.new("log:" .. tostring(info[5]), client.get_unix_time() < info[6] + 5 and 1 or 0.01, 0.1, 0)
        if anim <= 0.05 then return end
        functions.visuals.animation = functions.visuals.animation + anim

        if not entity_list.get_local_player() then return end
        if not info[2] then return end

        local hb = nil
        if info[4] ~= "" then
            hb = client.get_hitbox_name(info[4] - 1)
            if info[4] == 0 then
                hb = "stomach"
            end
        end

        if not menu.is_open() then
            local style = gui.get("Visuals - indicators", "Logs style"):get()
            if info[3] == "ping (local death)" or info[3] == "ping (enemy death)" then
                info[3] = "death"
            end
            if style == 1 then
                local text = ""
                if info[1] == "hit" then text = "Hit " .. info[2]:get_name() .. " in " .. hb .. " for " .. info[3] .. "hp (" .. (info[7] > 0 and (info[7] .. " remaining") or "death") .. ")" end
                if info[1] == "miss" then text = "Missed in " .. info[2]:get_name() .. " " .. hb .. " on " .. info[3] .. "" end
                if info[1] == "hurt" then text = "Hurted from " .. info[2]:get_name() .. " in " .. hb .. " for " .. info[3] .. "hp (" .. (info[7] > 0 and (info[7] .. " remaining") or "death") .. ")" end
                if info[1] == "buy" then text = info[2]:get_name() .. " buying " .. info[3] end

                render.text(globals.font, text, vec2_t(position.x + size.x / 2, position.y + functions.visuals.animation * 10), color_t(255, 255, 255, math.floor(255 * anim)), true)

            elseif style == 2 then
                local a = math.floor(255 * anim)
                if info[1] == "hit" then
                    local text = "clr(120, 255, 120, " .. a .. ")Hit clr(255, 255, 255, " .. a .. ")" .. info[2]:get_name() .. " in clr(120, 255, 120, " .. a .. ")" .. hb .. " clr(255, 255, 255, " .. a .. ")for clr(120, 255, 120, " .. a .. ")" .. info[3] .. "hp clr(255, 120, 120, " .. a .. ")[" .. (info[7] > 0 and (info[7] .. " remaining") or "death") .. "]"
                    local str = "Hit " .. info[2]:get_name() .. " in " .. hb .. " for " .. info[3] .. "hp [" .. (info[7] > 0 and (info[7] .. " remaining") or "death") .. "]"
                    local position = vec2_t(position.x + size.x / 2 - render.get_text_size(globals.font, str).x / 2, position.y + functions.visuals.animation * 10)
                    helpers.render.multicolor_text(globals.font, text, position)
                end
                if info[1] == "miss" then
                    local text = "clr(255, 120, 120, " .. a .. ")Missed in clr(255, 255, 255, " .. a .. ")" .. info[2]:get_name() .. " clr(255, 120, 120, " .. a .. ")" .. hb .. " clr(255, 255, 255, " .. a .. ")on clr(255, 120, 120, " .. a .. ")" .. info[3]
                    local str = "Missed in " .. info[2]:get_name() .. " " .. hb .. " on " .. info[3]
                    local position = vec2_t(position.x + size.x / 2 - render.get_text_size(globals.font, str).x / 2, position.y + functions.visuals.animation * 10)
                    helpers.render.multicolor_text(globals.font, text, position)
                end
                if info[1] == "hurt" then
                    local text = "clr(200, 50, 50, " .. a .. ")Hurted from clr(255, 255, 255, " .. a .. ")" .. info[2]:get_name() .. " in clr(200, 50, 50, " .. a .. ")" .. hb .. " clr(255, 255, 255, " .. a .. ")for clr(200, 50, 50, " .. a .. ")" .. info[3] .. "hp clr(120, 255, 120, " .. a .. ")[" .. (info[7] > 0 and (info[7] .. " remaining") or "death") .. "]"
                    local str = "Hurted from " .. info[2]:get_name() .. " in " .. hb .. " for " .. info[3] .. "hp [" .. (info[7] > 0 and (info[7] .. " remaining") or "death") .. "]"
                    local position = vec2_t(position.x + size.x / 2 - render.get_text_size(globals.font, str).x / 2, position.y + functions.visuals.animation * 10)
                    helpers.render.multicolor_text(globals.font, text, position)
                end
                if info[1] == "buy" then
                    local text = "clr(120, 255, 120, " .. a .. ")" .. info[2]:get_name() .. "clr(255, 255, 255, " .. a .. ") buying clr(120, 255, 120, " .. a .. ")" .. info[3]
                    local str = info[2]:get_name() .. " buying " .. info[3]
                    local position = vec2_t(position.x + size.x / 2 - render.get_text_size(globals.font, str).x / 2, position.y + functions.visuals.animation * 10)
                    helpers.render.multicolor_text(globals.font, text, position)
                end
            end
        end
    end
    functions.visuals.animation = 0
    for i = 1, #functions.visuals.logs_list do
        local log = functions.visuals.logs_list[i]
        render_log(log)
    end
    helpers.drag.func("logs", functions.visuals.logs_x, functions.visuals.logs_y, size,
        {vec2_t(globals.screen_size[1] / 2 - 150, globals.screen_size[2] / 2 + 200)})
end
functions.visuals.log_miss = function(args)
    if not entity_list.get_local_player() then return end
    if not gui.get("Visuals - indicators", "Windows"):get(3) then return end
    if not gui.get("Visuals - indicators", "Logs aspects"):get(1) then return end
    if args[1].player == nil then return end
    functions.visuals.logs_list[#functions.visuals.logs_list+1] = {"miss", args[1].player, args[1].reason_string, args[1].aim_hitgroup, functions.visuals.id, client.get_unix_time(), args[1].player:get_prop("m_iHealth")}
    functions.visuals.id = functions.visuals.id + 1
    if not gui.get("Visuals - indicators", "Logs output"):get(2) then return end
    local hb = client.get_hitbox_name(args[1].aim_hitgroup - 1)
    if args[1].aim_hitgroup == 0 then
        hb = "stomach"
    end
    print("Missed in " .. args[1].player:get_name() .. " " .. hb .. " on " .. args[1].reason_string)
end
functions.visuals.log_hit = function(args)
    if not entity_list.get_local_player() then return end
    if not gui.get("Visuals - indicators", "Windows"):get(3) then return end
    if not gui.get("Visuals - indicators", "Logs aspects"):get(2) then return end
    if args[1].player == nil then return end
    functions.visuals.logs_list[#functions.visuals.logs_list+1] = {"hit", args[1].player, args[1].damage, args[1].hitgroup, functions.visuals.id, client.get_unix_time(), args[1].player:get_prop("m_iHealth")}
    functions.visuals.id = functions.visuals.id + 1
    if not gui.get("Visuals - indicators", "Logs output"):get(2) then return end
    local hb = client.get_hitbox_name(args[1].hitgroup - 1)
    if args[1].hitgroup == 0 then
        hb = "stomach"
    end
    print("Hit " .. args[1].player:get_name() .. " in " .. hb .. " for " .. args[1].damage .. "hp (" .. (args[1].player:get_prop("m_iHealth") > 0 and (args[1].player:get_prop("m_iHealth") .. " remaining") or "death") .. ")")
end
functions.visuals.log_hurt = function(args)
    if not entity_list.get_local_player() then return end
    if not gui.get("Visuals - indicators", "Windows"):get(3) then return end
    if not gui.get("Visuals - indicators", "Logs aspects"):get(3) then return end
    if args[1].name == "player_hurt" then
        if entity_list.get_player_from_userid(args[1].userid) == entity_list.get_local_player() then
            functions.visuals.logs_list[#functions.visuals.logs_list+1] = {"hurt", entity_list.get_player_from_userid(args[1].attacker), args[1].dmg_health, args[1].hitgroup, functions.visuals.id, client.get_unix_time(), args[1].health}
            functions.visuals.id = functions.visuals.id + 1

            if not gui.get("Visuals - indicators", "Logs output"):get(2) then return end

            local hb = client.get_hitbox_name(args[1].hitgroup - 1)
            if args[1].hitgroup == 0 then
                hb = "stomach"
            end
            print("Hurted from " .. entity_list.get_player_from_userid(args[1].attacker):get_name() .. " in " .. hb .. " for " .. args[1].dmg_health .. "hp (" .. (args[1].health > 0 and (args[1].health .. " remaining") or "death") .. ")")
        end
    end
end
functions.visuals.log_buy = function(args)
    if not entity_list.get_local_player() then return end
    if not gui.get("Visuals - indicators", "Windows"):get(3) then return end
    if not gui.get("Visuals - indicators", "Logs aspects"):get(4) then return end
    if args[1].name == "item_purchase" then
        if entity_list.get_player_from_userid(args[1].userid) ~= entity_list.get_local_player() then
            functions.visuals.logs_list[#functions.visuals.logs_list+1] = {"buy", entity_list.get_player_from_userid(args[1].userid), args[1].weapon, "", functions.visuals.id, client.get_unix_time(), ""}
            functions.visuals.id = functions.visuals.id + 1

            if not gui.get("Visuals - indicators", "Logs output"):get(2) then return end
            if not entity_list.get_player_from_userid(args[1].userid):get_name() then return end
            if not args[1].weapon then return end
            print(entity_list.get_player_from_userid(args[1].userid):get_name() .. " buy " .. args[1].weapon)
        end
    end
end

-- ______________
-- endsubregion: #logs
--



--
-- subregion: #ping warning
-- ______________

functions.visuals.pw_group = gui.create_group("pw", 1, false)
functions.visuals.pw_x = gui.add_slider(functions.visuals.pw_group, "pw_x", 0, globals.screen_size[1], 1) functions.visuals.pw_x:set_visible(false) functions.visuals.pw_x:set(globals.screen_size[1] / 2 - 90)
functions.visuals.pw_y = gui.add_slider(functions.visuals.pw_group, "pw_y", 0, globals.screen_size[2], 1) functions.visuals.pw_y:set_visible(false) functions.visuals.pw_y:set(100)
functions.visuals.ping_warning = function()
    if not gui.get("Visuals - indicators", "Windows"):get(4) then return end
    local position = vec2_t(functions.visuals.pw_x:get(), functions.visuals.pw_y:get())
    local size = vec2_t(180, 50)
    local ping = math.floor( engine.get_latency( e_latency_flows.OUTGOING ) * 1000 )
    local is_enable = menu.is_open() or (ping > 80 and entity_list.get_local_player())
    local clr = gui.get("Visuals - indicators", "pingwarning_clr"):get()

    local anim = helpers.animation.new("pingwarnings", is_enable and 1 or 0.01, 0.05, 0)

    if anim > 0.05 then
        if not clr.r then return end
        functions.visuals.render_window(position, size, color_t(clr.r, clr.g, clr.b, math.floor(255 * anim)))
        render.triangle_filled(position + vec2_t(10 + 18, size.y / 2 + 18), 35, color_t(0, 0, 0, math.floor(255 * anim)))
        render.triangle_filled(position + vec2_t(13 + 15, size.y / 2 + 15), 25, color_t(clr.r, clr.g, clr.b, math.floor(math.min(math.floor(math.sin((globals_var.cur_time()%4) * 8) * 255 + 300), 255) * anim)))
        render.text(globals.big_font, "!", position + vec2_t(25, 20), color_t(0, 0, 0, math.floor(255 * anim)))

        render.text(globals.big_font, "Warning", position + vec2_t(50, 5), color_t(clr.r, clr.g, clr.b, math.floor(255 * anim)))
        render.text(globals.font, "Your ping is higher", position + vec2_t(50, 23), color_t(220, 220, 220, math.floor(255 * anim)))
        render.text(globals.font, "than normal!", position + vec2_t(51, 32), color_t(220, 220, 220, math.floor(255 * anim)))
    end

    helpers.drag.func("pingwarning", functions.visuals.pw_x, functions.visuals.pw_y, size,
        {vec2_t(globals.screen_size[1] / 2 - 90, 100)})
end

-- ______________
-- endsubregion: #ping warning
--



--
-- subregion: #center indicators
-- ______________


functions.visuals.centered_indicators = function()
    if not gui.get("Visuals - indicators", "Windows"):get(5) then return end
    local lp = entity_list.get_local_player()
    if not lp or not lp:is_alive() then return end

    local position = vec2_t(globals.screen_size.x / 2, globals.screen_size.y / 2 + 25)
    local clr = gui.get("Visuals - indicators", "centerind_clr"):get()
    local clr = color_t(clr.r, clr.g, clr.b, 255)

    local pulse = math.max((math.sin((globals_var.cur_time() % 6) * 6) + 0.8) / 2, 0.01)
    local text = "IDEALYAW"

    local side = antiaim.get_desync_side() == 2 and "R" or "L"

    local degrees = 0
    if side == "R" then degrees = antiaim.get_fake_angle() - antiaim.get_real_angle()
    else degrees = antiaim.get_real_angle() - antiaim.get_fake_angle() end
    if degrees < 0 then degrees = degrees * -1 end
    degrees = tostring(math.min(math.floor(degrees), 60))

    render.text(globals.pixel_font, text, position, color_t(255, 255, 255))
    render.text(globals.pixel_font, "BETA", position + vec2_t(render.get_text_size(globals.pixel_font, text).x + 2, 0), color_t(clr.r, clr.g, clr.b, math.floor(pulse * 255)))
    render.text(globals.pixel_font, "BODY SIDE: " .. side .. " °" .. degrees, position + vec2_t(0, 8 * 1), color_t(255, 255, 255))
    render.text(globals.pixel_font, "DT", position + vec2_t(0, 8 * 2), refs.doubletap[2]:get() and clr or color_t(140, 140, 140))
    render.text(globals.pixel_font, "OS", position + vec2_t(11, 8 * 2), refs.hideshots[2]:get() and clr or color_t(140, 140, 140))
    render.text(globals.pixel_font, "QP", position + vec2_t(24, 8 * 2), refs.autopeek[2]:get() and clr or color_t(140, 140, 140))
    render.text(globals.pixel_font, "DMG", position + vec2_t(37, 8 * 2), refs.minimum_damage[2]:get() and clr or color_t(140, 140, 140))
    if functions.rage.auto_teleport_enable > 0 then
        render.text(globals.pixel_font, "AUTO TP", position + vec2_t(0, 8 * 3), clr)
    end
end

-- ______________
-- endsubregion: #centered indicators
--

-- ______________
-- endregion: #indicators
--



--
-- region: #additionals removals
-- ______________

functions.visuals.additionals_removals = function()
    local additionals = gui.get("Visuals - other", "Additionals removals")

    cvars.cl_csm_shadows:set_int(gui.get("Visuals - other", "Additionals removals"):get(1) and 0 or 1)
end

-- ______________
-- endregion: #additionals removals
--




--
-- region: #autopeek
-- ______________

functions.visuals.oneshot_autopeek = function()
    if not gui.get("Visuals - other", "\"OneShot\" autopeek"):get() then return end
    local position = ragebot.get_autopeek_pos()
    if position == nil then return end
    local color = gui.get("Visuals - other", "oneshotpeek_clr"):get()
    local clr = color_t(color.r, color.g, color.b, 255)

    local pos = render.world_to_screen(position + vec3_t(-16, -7, 0))
    local pos1 = render.world_to_screen(position + vec3_t(0, -18, 0))
    local pos2 = render.world_to_screen(position + vec3_t(20, -5, 0))
    local pos3 = render.world_to_screen(position + vec3_t(13, 15, 0))
    local pos4 = render.world_to_screen(position + vec3_t(-10, 15, 0))
    if pos == nil or pos1 == nil or pos2 == nil or pos3 == nil or pos4 == nil then return end
    render.polygon({pos, pos1, pos2, pos3, pos4}, color_t(clr.r, clr.g, clr.b, 120))
    render.polyline({pos, pos1, pos2, pos3, pos4}, clr)
    render.line(pos, pos2, clr)
    render.line(pos2, pos4, clr)
    render.line(pos4, pos1, clr)
end

-- ______________
-- endregion: #autopeek
--


--
-- region: #trail
-- ______________

functions.visuals.trail_last = vec3_t(0, 0, 0)
functions.visuals.trail = function()
    if not gui.get("Visuals - other", "Trail line"):get() then functions.visuals.trail_last = vec3_t(0, 0, 0) return end
    local lp = entity_list.get_local_player()
    if not lp or not lp:is_alive() or lp:get_prop("m_vecVelocity"):length() < 3 then return end
    local origin = lp:get_render_origin()
    local color = gui.get("Visuals - other", "trailline_clr"):get()

    local start_pos = vec3_t(origin.x, origin.y, origin.z + 3)

    if color == color_t(0, 0, 0, 0) then color = helpers.render.fade_rainbow() end

    if functions.visuals.trail_last ~= vec3_t(0, 0, 0) then
        createBeams(functions.visuals.trail_last or start_pos, start_pos, 2, 1, color)
    end

    functions.visuals.trail_last = start_pos
end

-- ______________
-- endregion: #autopeek
--


--
-- region: #stickman
-- ______________

functions.visuals.stickman = function()
    if not gui.get("Visuals - other", "Stickman"):get() then return end
    local lp = entity_list.get_local_player()
    if not lp or not lp:is_alive() then return end
    if not client.is_in_thirdperson() then return end

    local hitbox_screen = function(enum) if not render.world_to_screen(lp:get_hitbox_pos(enum)) then return nil else return render.world_to_screen(lp:get_hitbox_pos(enum)) end end
    local hitboxes = {}

    local head = hitbox_screen(e_hitboxes.HEAD)
    local neck = hitbox_screen(e_hitboxes.NECK)
    local lower_body = hitbox_screen(e_hitboxes.PELVIS)

    local right_thigh = hitbox_screen(e_hitboxes.RIGHT_THIGH)
    local left_thigh = hitbox_screen(e_hitboxes.LEFT_THIGH)
    local right_calf = hitbox_screen(e_hitboxes.RIGHT_CALF)
    local left_calf = hitbox_screen(e_hitboxes.LEFT_CALF)
    local right_foot = hitbox_screen(e_hitboxes.RIGHT_FOOT)
    local left_foot = hitbox_screen(e_hitboxes.LEFT_FOOT)

    local right_upperarm = hitbox_screen(e_hitboxes.RIGHT_UPPER_ARM)
    local left_upperarm = hitbox_screen(e_hitboxes.LEFT_UPPER_ARM)
    local right_forearm = hitbox_screen(e_hitboxes.RIGHT_FOREARM)
    local left_forearm = hitbox_screen(e_hitboxes.LEFT_FOREARM)
    local right_hand = hitbox_screen(e_hitboxes.RIGHT_HAND)
    local left_hand = hitbox_screen(e_hitboxes.LEFT_HAND)

    if head then render.circle(head, 40, color_t(255, 255, 255)) end
    if neck and lower_body then render.line(neck, lower_body, color_t(255, 255, 255)) end

    if lower_body and right_thigh then render.line(lower_body, right_thigh, color_t(255, 255, 255)) end
    if lower_body and left_thigh then render.line(lower_body, left_thigh, color_t(255, 255, 255)) end

    if right_thigh and right_calf then render.line(right_thigh, right_calf, color_t(255, 255, 255)) end
    if left_thigh and left_calf then render.line(left_thigh, left_calf, color_t(255, 255, 255)) end

    if right_calf and right_foot then render.line(right_calf, right_foot, color_t(255, 255, 255)) end
    if left_calf and left_foot then render.line(left_calf, left_foot, color_t(255, 255, 255)) end

    if right_foot then render.circle(right_foot, 10, color_t(255, 255, 255)) end
    if left_foot then render.circle(left_foot, 10, color_t(255, 255, 255)) end

    if neck and right_upperarm then render.line(neck, right_upperarm, color_t(255, 255, 255)) end
    if neck and left_upperarm then render.line(neck, left_upperarm, color_t(255, 255, 255)) end

    if right_upperarm and right_forearm then render.line(right_upperarm, right_forearm, color_t(255, 255, 255)) end
    if left_upperarm and left_forearm then render.line(left_upperarm, left_forearm, color_t(255, 255, 255)) end

    if right_forearm and right_hand then render.line(right_forearm, right_hand, color_t(255, 255, 255)) end
    if left_forearm and left_hand then render.line(left_forearm, left_hand, color_t(255, 255, 255)) end

    if right_hand then render.circle(right_hand, 10, color_t(255, 255, 255)) end
    if left_hand then render.circle(left_hand, 10, color_t(255, 255, 255)) end
end

-- ______________
-- endregion: #stickman
--


--
-- region: #animation breaker
-- ______________
functions.visuals.animation_breaker = function(args)
    local on_ground = entity_list.get_local_player():has_player_flag(e_player_flags.ON_GROUND)

    if gui.get("Visuals - other", "Animations breaker"):get(1) then
        local animation = gui.get("Visuals - other", "Animation walk legs"):get()
        if animation == 1 then
            menu.find("antiaim", "main", "general", "leg slide"):set(3)
            args[1]:set_render_pose(e_poses.STRAFE_DIR, 1)
        elseif animation == 2 then
            menu.find("antiaim", "main", "general", "leg slide"):set(3)
            args[1]:set_render_pose(e_poses.STRAFE_DIR, 0.5)
        elseif animation == 3 then
            menu.find("antiaim", "main", "general", "leg slide"):set(2)
            if on_ground then
                args[1]:set_render_pose(e_poses.MOVE_BLEND_WALK, 0)
                args[1]:set_render_pose(e_poses.MOVE_BLEND_RUN, 0)
                args[1]:set_render_pose(e_poses.MOVE_BLEND_CROUCH_WALK, 0)
            end
        elseif animation == 4 then
            menu.find("antiaim", "main", "general", "leg slide"):set(2)
            args[1]:set_render_pose(e_poses.MOVE_YAW, 0)
        elseif animation == 5 then
            menu.find("antiaim", "main", "general", "leg slide"):set(2)
            if on_ground then
                args[1]:set_render_pose(e_poses.MOVE_BLEND_WALK, 0)
                args[1]:set_render_pose(e_poses.MOVE_BLEND_RUN, 0)
                args[1]:set_render_pose(e_poses.MOVE_BLEND_CROUCH_WALK, 0)
                args[1]:set_render_animlayer(e_animlayers.MOVEMENT_JUMP_OR_FALL, 1)
            end
        end

        if gui.get("Visuals - other", "Lean animation in walking"):get() then
            if on_ground then
                args[1]:set_render_animlayer(e_animlayers.LEAN, 1)
            end
        end
    end
    if gui.get("Visuals - other", "Animations breaker"):get(2) then
        local animation = gui.get("Visuals - other", "Animation air legs"):get()
        if animation == 1 then
            args[1]:set_render_pose(e_poses.JUMP_FALL, 1)
        elseif animation == 2 then
            if not on_ground then
                args[1]:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 1)
            end
        elseif animation == 3 then
            if not on_ground then
                args[1]:set_render_animlayer(e_animlayers.MOVEMENT_STRAFECHANGE	, 1)
            end
        end
        if gui.get("Visuals - other", "Lean animation in air"):get() then
            if not on_ground then
                args[1]:set_render_animlayer(e_animlayers.LEAN, 1)
            end
        end
    end
    if gui.get("Visuals - other", "Animations breaker"):get(3) then
        entity_list.get_local_player():set_prop("m_flModelScale", 2.5)
    else
        entity_list.get_local_player():set_prop("m_flModelScale", 1)
    end
end

-- ______________
-- endregion: #animation breaker
--


--
-- region: #trashtalk
-- ______________

functions.misc.trashtalk = function(args)
    if args[1].name == "player_hurt" then
        if entity_list.get_player_from_userid(args[1].userid) ~= entity_list.get_local_player() and args[1].health <= 0 and entity_list.get_player_from_userid(args[1].attacker) == entity_list.get_local_player() then
            local phrases = { "didn't feel it", "fuu the beggar fell", "1 son of a whore", "buy a cfg idiot", "where did the dalbayop fall", "easy cormorant", "where did you fly ??", "too weak for my dick", "cat des faggots", "beard boost", "snapback tattoo and beard", "easy hell fell", "where are you going nischy", "grandfather fucked up", "crash is when nasvay ended", "ballin lua getni - then piss off cheto", "fuck you sat on the bottle", "hare on the bottle", "fuck you to sleep", "hit the fuck with a dildom", "knocked down a pissed faggot", "swallow a sheep "," get fucked "," pissed you on a ballin", "fucking twat", "too juicy for a ballin lua", "fuck off to sleep", "easy fell beggar", "put on a dick", "what do you do dog? ?", "next time I'll fuck you bitch", "don't fly fag, it's scary for you", "learn to play chmyr", "baksha's norms flew off", "learn to play faggot", "designed a dick sucking)", "fuck off the beach", " 0 iq", "buy cfg from balins", "iq ?", "I watched nolav's vids don't give a fuck about me", "the earth rest in peace ahahahah", "1 fag", "are you a player?", "fucking parashych", " 1 fucking animal", "beaten by a 100 meter dick", "pissed", "getni balin lua then burp it out", "hit a fucking dildom", "knocked down a pissed faggot", "l2p bot", "learn to play 1 garbage", "$$$ 1 tap uff ya $$$", "how do you like my dick?", "left to right looked like and died", "1 chock", "fucking hole successfully closed", "1 disgrace", "faking slave didn't give a word", "why did you go to public? got lost chtol?”, “a whore fell on the viola”, “you went to takeoff and the son of a whore”, “ooc ez map bichi”, “you can immediately see I xvh barefoot”, “if I’m 12 it doesn’t mean that I’m not old and I’m not a buff it's a shame (((", "1111", "1.", "1 pig", "kobyakov is even smarter than you", "dumberer than cork", "iq from bread", "fuck off the beach", "fuck off, what sucked", "piss fell", "how is life with pasta ???", "I'll call an ambulance right now", "sit nn dog", "soryan did not see", "who did you eat up for?!", "and you are a fucking scourge", "you are a fucking whore, go sniff mef off my dick", "what do you want to tell me? fuck, shut up, didn't give you a voice", "he hasn't even a chick yet fucked, but already killed a man", "what about mom? and dad ??", "go take a picture with the bears", "I play with one foot", "hs bomjara", "where did the slipper fly off ?!", "shcha fucked up will be flat" , "go feed the pigeons", "I fucked up your mother's feeder", "go get silicone brains on Alik for yourself", "your bones crunched like Russian potato chips", "a motherless bot in the lobby", "are you stewing a bull on your ass? ", "brain issue" }
            local trashtalk = gui.get("Misc - other", "Trashtalk"):get()
            if trashtalk == 2 then
                engine.execute_cmd('say 1')
            elseif trashtalk == 3 then
                engine.execute_cmd('say ' .. phrases[client.random_int(1, #phrases)])
            end
        end
    end
end

-- ______________
-- endregion: #trashtalk
--



--
-- region: profile changer
-- ______________
functions.misc.profile_store = {0, 0, 0, 0, 0, 0}
functions.misc.profile_change = false
functions.misc.profile_changer = function()
    if not entity_list.get_local_player() then return end
    if not gui.get("Profile changer", "Enable"):get() then
        if functions.misc.profile_change then
            player_resource.set_prop("m_iKills", functions.misc.profile_store[1], entity_list.get_local_player():get_index())
            player_resource.set_prop("m_iDeaths", functions.misc.profile_store[2], entity_list.get_local_player():get_index())
            player_resource.set_prop("m_iAssists", functions.misc.profile_store[3], entity_list.get_local_player():get_index())
            player_resource.set_prop("m_iScore", functions.misc.profile_store[4], entity_list.get_local_player():get_index())
            player_resource.set_prop("m_iCompetitiveRanking", functions.misc.profile_store[6], entity_list.get_local_player():get_index())
            functions.misc.profile_change = false
        end
        return
    end

    if not functions.misc.profile_change then
        functions.misc.profile_store[1] = player_resource.get_prop("m_iKills", entity_list.get_local_player():get_index())
        functions.misc.profile_store[2] = player_resource.get_prop("m_iDeaths", entity_list.get_local_player():get_index())
        functions.misc.profile_store[3] = player_resource.get_prop("m_iAssists", entity_list.get_local_player():get_index())
        functions.misc.profile_store[4] = player_resource.get_prop("m_iScore", entity_list.get_local_player():get_index())
        functions.misc.profile_store[6] = player_resource.get_prop("m_iCompetitiveRanking", entity_list.get_local_player():get_index())
        functions.misc.profile_change = true
    end

    player_resource.set_prop("m_iKills", gui.get("Profile changer", "Kills"):get(), entity_list.get_local_player():get_index())
    player_resource.set_prop("m_iDeaths", gui.get("Profile changer", "Deaths"):get(), entity_list.get_local_player():get_index())
    player_resource.set_prop("m_iAssists", gui.get("Profile changer", "Assists"):get(), entity_list.get_local_player():get_index())
    player_resource.set_prop("m_iScore", gui.get("Profile changer", "Kills"):get() * 2 + gui.get("Profile changer", "Assists"):get(), entity_list.get_local_player():get_index())

    player_resource.set_prop("m_iCompetitiveRanking", gui.get("Profile changer", "Rank"):get() - 1, entity_list.get_local_player():get_index())
end

-- ______________
-- endregion: profile changer
--


--
-- region: #sync
-- ______________
functions.globals.sync_clantag = " ᠌"
functions.globals.sync_update = 0
functions.globals.sync_users = {}
functions.globals.unsync_users = {}
functions.globals.sync = function()
    if not entity_list.get_local_player() then return end
    if not entity_list.get_local_player():is_alive() then return end
    if functions.globals.sync_update > 15 then
        client.set_clantag(functions.globals.sync_clantag)
        local players = entity_list.get_players()

        for _, enemy in pairs(players) do
            if enemy:is_valid() then
                if enemy:is_alive() then
                    local clantag = player_resource.get_prop("m_szClan", enemy:get_index())
                    local steamid,_ = enemy:get_steamids()

                    if not functions.globals.unsync_users[steamid] then functions.globals.unsync_users[steamid] = 0 end
                    if clantag == functions.globals.sync_clantag then
                        if not array.has(functions.globals.sync_users, steamid) then
                            array.put(functions.globals.sync_users, steamid)
                        end
                        if array.has(functions.globals.sync_users, steamid) then
                            functions.globals.unsync_users[steamid] = 0
                        end
                    else
                        if array.has(functions.globals.sync_users, steamid) then
                            functions.globals.unsync_users[steamid] = functions.globals.unsync_users[steamid] + 1
                        end
                    end

                    if array.has(functions.globals.sync_users, steamid) then
                        if functions.globals.unsync_users[steamid] > 50 then
                            local index_to_remove = 0
                            for i = 1, #functions.globals.sync_users do
                                if functions.globals.sync_users[i] == steamid then
                                    index_to_remove = i
                                end
                            end
                            if index_to_remove ~= 0 then functions.globals.sync_users[index_to_remove] = nil end
                            functions.globals.unsync_users[steamid] = 0
                        end
                    end
                end
            end
        end

        functions.globals.sync_update = 0
    end
    functions.globals.sync_update = functions.globals.sync_update + 1
end
functions.globals.sync_icons = function()
    if not entity_list.get_local_player() then return end
    local players = entity_list.get_players()

    for _, enemy in pairs(players) do
        if enemy:is_valid() then
            local steamid,_ = enemy:get_steamids()
            player_resource.set_prop("m_nPersonaDataPublicLevel", 0, enemy:get_index())
            for i = 1, #functions.globals.sync_users do
                if functions.globals.sync_users[i] == steamid then
                    player_resource.set_prop("m_nPersonaDataPublicLevel", 9991, enemy:get_index())
                end
            end
        end
    end
end
functions.globals.sync_chat = function(args)
    if not entity_list.get_local_player() then return end

    if args[1].name == "player_say" then
        if entity_list.get_player_from_userid(args[1].userid) == nil then return end
        local steamid,_ = entity_list.get_player_from_userid(args[1].userid):get_steamids()

        local is_sync = false
        for i = 1, #functions.globals.sync_users do
            local current = functions.globals.sync_users[i]
            if current == steamid then is_sync = true end
        end
        if is_sync then
            chat_print("{yellow}^ idealyaw")
        end
    end
end

-- ______________
-- endregion: #sync
--



configs.instillize()


callback = {}
callback.create = function(callname, func, fglobal) array.put(callback, {callname, func, fglobal}) end
callback.install = function(enum, callname) callbacks.add(enum, function(...) args = {...} for i = 1, #callback do if callback[i][1] == callname then if gui.get("Tabs", "Master switch"):get() or callback[i][3] then callback[i][2](args) end end end end) end


callback.create("run_cmd", function(cmd)
    functions.globals.get_target()

    functions.rage.block_recharge_if_enemy_visibly()

    functions.antiaim.freestanding()
    functions.antiaim.fakelags()
    functions.antiaim.states()
    functions.rage.doubletap_override()

    functions.rage.auto_teleport()
end, false)

callback.create("hitscan", function(ctx, cmd, unpredicted_data)
    functions.rage.ideal_tick(ctx, cmd, unpredicted_data)
end, false)

callback.create("render", function()
    functions.visuals.additionals_removals()

    functions.visuals.oneshot_autopeek()
    functions.visuals.trail()
    functions.visuals.stickman()

    functions.visuals.centered_indicators()

    functions.visuals.keybinds()
    functions.visuals.watermark()
    functions.visuals.logs()
    functions.visuals.ping_warning()

    functions.misc.profile_changer()
end, false)

callback.create("aim_hit", function(hit)
    functions.visuals.log_hit(hit)
end, false)

callback.create("aim_miss", function(miss)
    functions.visuals.log_miss(miss)
end, false)

callback.create("antiaim", function(event)
    functions.visuals.animation_breaker(event)
end, false)

callback.create("event", function(event)
    functions.visuals.log_hurt(event)
    functions.visuals.log_buy(event)
    functions.misc.trashtalk(event)
end, false)

callback.create("event", function(event)
    functions.globals.sync_chat(event)
end, true)

callback.create("render", function()
    gui.callback(gui.get("Tabs", "Select"):get())
    configs.core()
    functions.globals.sync()
    functions.globals.sync_icons()
end, true)

callback.create("shutdown", function()
    functions.rage.block_recharge_if_enemy_visibly_on_disable()

    client.set_clantag("")
    if not entity_list.get_local_player() then return end
    entity_list.get_local_player():set_prop("m_flModelScale", 1)

    local players = entity_list.get_players()
    for _, enemy in pairs(players) do
        player_resource.set_prop("m_nPersonaDataPublicLevel", 0, enemy:get_index())
    end
end, true)



callback.install(e_callbacks.AIMBOT_HIT, "aim_hit")
callback.install(e_callbacks.AIMBOT_MISS, "aim_miss")
callback.install(e_callbacks.AIMBOT_SHOOT, "aim_shot")
callback.install(e_callbacks.ANTIAIM, "antiaim")
callback.install(e_callbacks.HITSCAN, "hitscan")
callback.install(e_callbacks.SHUTDOWN, "shutdown")
callback.install(e_callbacks.TARGET_SELECTION, "trgt_select")
callback.install(e_callbacks.FINISH_COMMAND, "finish_cmd")
callback.install(e_callbacks.SETUP_COMMAND, "setup_cmd")
callback.install(e_callbacks.RUN_COMMAND, "run_cmd")
callback.install(e_callbacks.PAINT, "render")
callback.install(e_callbacks.EVENT, "event")