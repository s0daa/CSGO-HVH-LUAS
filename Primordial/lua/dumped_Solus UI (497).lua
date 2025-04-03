callbacks.add(e_callbacks.DRAW_WATERMARK, function() return "" end)
local panorama, screen, font, Png, bind_modes, avatars, avg, fps = require("primordial/panorama-library.248"), render.get_screen_size(), render.create_font("Verdana", 12, 400, e_font_flags.DROPSHADOW), {}, { [0] = "[toggle]", [1] = "[hold]", [2] = "[~]" }, {}, 0, 0
math.lerp = function(name, value, speed) return name + (value - name) * global_vars.absolute_frame_time() * speed end

Png.__index = Png
local png_ihdr_t = ffi.typeof([[
struct {
	char type[4];
	uint32_t width;
	uint32_t height;
	char bitDepth;
	char colorType;
	char compression;
	char filter;
	char interlace;
} *
]])

local jpg_segment_t = ffi.typeof([[
struct {
	char type[2];
	uint16_t size;
} *
]])

local jpg_segment_sof0_t = ffi.typeof([[
struct {
	uint16_t size;
	char precision;
	uint16_t height;
	uint16_t width;
} __attribute__((packed)) *
]])

local uint16_t_ptr = ffi.typeof("uint16_t*")
local charbuffer = ffi.typeof("unsigned char[?]")
local uintbuffer = ffi.typeof("unsigned int[?]")

local INVALID_TEXTURE = -1
local PNG_MAGIC = "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A"

local JPG_MAGIC_1 = "\xFF\xD8\xFF\xDB"
local JPG_MAGIC_2 = "\xFF\xD8\xFF\xE0\x00\x10\x4A\x46\x49\x46\x00\x01"

local JPG_SEGMENT_SOI = "\xFF\xD8"
local JPG_SEGMENT_SOF0 = "\xFF\xC0"
local JPG_SEGMENT_SOS = "\xFF\xDA"
local JPG_SEGMENT_EOI = "\xFF\xD9"

local DEFLATE_MAX_BLOCK_SIZE = 65535

local function putBigUint32(val, tbl, index)
    for i=0,3 do
        tbl[index + i] = bit.band(bit.rshift(val, (3 - i) * 8), 0xFF)
    end
end

function Png:writeBytes(data, index, len)
    index = index or 1
    len = len or #data
    for i=index,index+len-1 do
        table.insert(self.output, string.char(data[i]))
    end
end

function Png:write(pixels)
    local count = #pixels  -- Byte count
    local pixelPointer = 1
    while count > 0 do
        if self.positionY >= self.height then
            error("All image pixels already written")
        end

        if self.deflateFilled == 0 then -- Start DEFLATE block
            local size = DEFLATE_MAX_BLOCK_SIZE;
            if (self.uncompRemain < size) then
                size = self.uncompRemain
            end
            local header = {  -- 5 bytes long
                bit.band((self.uncompRemain <= DEFLATE_MAX_BLOCK_SIZE and 1 or 0), 0xFF),
                bit.band(bit.rshift(size, 0), 0xFF),
                bit.band(bit.rshift(size, 8), 0xFF),
                bit.band(bit.bxor(bit.rshift(size, 0), 0xFF), 0xFF),
                bit.band(bit.bxor(bit.rshift(size, 8), 0xFF), 0xFF),
            }
            self:writeBytes(header)
            self:crc32(header, 1, #header)
        end
        assert(self.positionX < self.lineSize and self.deflateFilled < DEFLATE_MAX_BLOCK_SIZE);

        if (self.positionX == 0) then  -- Beginning of line - write filter method byte
            local b = {0}
            self:writeBytes(b)
            self:crc32(b, 1, 1)
            self:adler32(b, 1, 1)
            self.positionX = self.positionX + 1
            self.uncompRemain = self.uncompRemain - 1
            self.deflateFilled = self.deflateFilled + 1
        else -- Write some pixel bytes for current line
            local n = DEFLATE_MAX_BLOCK_SIZE - self.deflateFilled;
            if (self.lineSize - self.positionX < n) then
                n = self.lineSize - self.positionX
            end
            if (count < n) then
                n = count;
            end
            assert(n > 0);

            self:writeBytes(pixels, pixelPointer, n)

            -- Update checksums
            self:crc32(pixels, pixelPointer, n);
            self:adler32(pixels, pixelPointer, n);

            -- Increment positions
            count = count - n;
            pixelPointer = pixelPointer + n;
            self.positionX = self.positionX + n;
            self.uncompRemain = self.uncompRemain - n;
            self.deflateFilled = self.deflateFilled + n;
        end

        if (self.deflateFilled >= DEFLATE_MAX_BLOCK_SIZE) then
            self.deflateFilled = 0; -- End current block
        end

        if (self.positionX == self.lineSize) then  -- Increment line
            self.positionX = 0;
            self.positionY = self.positionY + 1;
            if (self.positionY == self.height) then -- Reached end of pixels
                local footer = {  -- 20 bytes long
                    0, 0, 0, 0,  -- DEFLATE Adler-32 placeholder
                    0, 0, 0, 0,  -- IDAT CRC-32 placeholder
                    -- IEND chunk
                    0x00, 0x00, 0x00, 0x00,
                    0x49, 0x45, 0x4E, 0x44,
                    0xAE, 0x42, 0x60, 0x82,
                }
                putBigUint32(self.adler, footer, 1)
                self:crc32(footer, 1, 4)
                putBigUint32(self.crc, footer, 5)
                self:writeBytes(footer)
                self.done = true
            end
        end
    end
end

function Png:crc32(data, index, len)
    self.crc = bit.bnot(self.crc)
    for i=index,index+len-1 do
        local byte = data[i]
        for j=0,7 do  -- Inefficient bitwise implementation, instead of table-based
            local nbit = bit.band(bit.bxor(self.crc, bit.rshift(byte, j)), 1);
            self.crc = bit.bxor(bit.rshift(self.crc, 1), bit.band((-nbit), 0xEDB88320));
        end
    end
    self.crc = bit.bnot(self.crc)
end
function Png:adler32(data, index, len)
    local s1 = bit.band(self.adler, 0xFFFF)
    local s2 = bit.rshift(self.adler, 16)
    for i=index,index+len-1 do
        s1 = (s1 + data[i]) % 65521
        s2 = (s2 + s1) % 65521
    end
    self.adler = bit.bor(bit.lshift(s2, 16), s1)
end

local function begin(width, height, colorMode)
    -- Default to rgb
    colorMode = colorMode or "rgb"

    -- Determine bytes per pixel and the PNG internal color type
    local bytesPerPixel, colorType
    if colorMode == "rgb" then
        bytesPerPixel, colorType = 3, 2
    elseif colorMode == "rgba" then
        bytesPerPixel, colorType = 4, 6
    else
        error("Invalid colorMode")
    end

    local state = setmetatable({ width = width, height = height, done = false, output = {} }, Png)

    -- Compute and check data siezs
    state.lineSize = width * bytesPerPixel + 1
    -- TODO: check if lineSize too big

    state.uncompRemain = state.lineSize * height

    local numBlocks = math.ceil(state.uncompRemain / DEFLATE_MAX_BLOCK_SIZE)

    -- 5 bytes per DEFLATE uncompressed block header, 2 bytes for zlib header, 4 bytes for zlib Adler-32 footer
    local idatSize = numBlocks * 5 + 6
    idatSize = idatSize + state.uncompRemain;

    -- TODO check if idatSize too big

    local header = {  -- 43 bytes long
        -- PNG header
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
        -- IHDR chunk
        0x00, 0x00, 0x00, 0x0D,
        0x49, 0x48, 0x44, 0x52,
        0, 0, 0, 0,  -- 'width' placeholder
        0, 0, 0, 0,  -- 'height' placeholder
        0x08, colorType, 0x00, 0x00, 0x00,
        0, 0, 0, 0,  -- IHDR CRC-32 placeholder
        -- IDAT chunk
        0, 0, 0, 0,  -- 'idatSize' placeholder
        0x49, 0x44, 0x41, 0x54,
        -- DEFLATE data
        0x08, 0x1D,
    }
    putBigUint32(width, header, 17)
    putBigUint32(height, header, 21)
    putBigUint32(idatSize, header, 34)

    state.crc = 0
    state:crc32(header, 13, 17)
    putBigUint32(state.crc, header, 30)
    state:writeBytes(header)

    state.crc = 0
    state:crc32(header, 38, 6);  -- 0xD7245B6B
    state.adler = 1

    state.positionX = 0
    state.positionY = 0
    state.deflateFilled = 0

    return state
end

ffi.cdef([[
	typedef struct
	{
		void* steam_client;
		void* steam_user;
		void* steam_friends;
		void* steam_utils;
		void* steam_matchmaking;
		void* steam_user_stats;
		void* steam_apps;
		void* steam_matchmakingservers;
		void* steam_networking;
		void* steam_remotestorage;
		void* steam_screenshots;
		void* steam_http;
		void* steam_unidentifiedmessages;
		void* steam_controller;
		void* steam_ugc;
		void* steam_applist;
		void* steam_music;
		void* steam_musicremote;
		void* steam_htmlsurface;
		void* steam_inventory;
		void* steam_video;
	} S_steamApiCtx_t;
]])

local pS_SteamApiCtx = ffi.cast(
	"S_steamApiCtx_t**", ffi.cast(
		"char*",
		memory.find_pattern(
			"client.dll",
			"FF 15 ?? ?? ?? ?? B9 ?? ?? ?? ?? E8 ?? ?? ?? ?? 6A"
		)
	) + 7
)[0] or error("invalid interface", 2)

local native_ISteamFriends = ffi.cast("void***", pS_SteamApiCtx.steam_friends)
local native_ISteamUtils = ffi.cast("void***", pS_SteamApiCtx.steam_utils)
local native_ISteamFriends_GetSmallFriendAvatar = ffi.cast("int(__thiscall*)(void*, uint64_t)", native_ISteamFriends[0][34] )
local native_ISteamUtils_GetImageSize = ffi.cast("bool(__thiscall*)(void*, int, uint32_t*, uint32_t*)", native_ISteamUtils[0][5])
local native_ISteamUtils_GetImageRGBA = ffi.cast("bool(__thiscall*)(void*, int, unsigned char*, int)", native_ISteamUtils[0][6])

local function get_steam_id_fn(ent_idx)
    local panorama_handle = panorama.open()
    local huy = panorama_handle.GameStateAPI.GetPlayerXuidStringFromEntIndex(ent_idx)
    return huy
end

local function get_avatar(steamid)
    local huy = nil
    local counter = 4
    local rgba_image = {}
    local huy = nil
    local handle = native_ISteamFriends_GetSmallFriendAvatar( native_ISteamFriends , tonumber(steamid:sub(4, -1)) + 76500000000000000ULL)

    local image_bytes = ""

    if handle > 0 then
        local width = uintbuffer(1)
            local height = uintbuffer(1)
            if native_ISteamUtils_GetImageSize(native_ISteamUtils, handle, width, height) then
                if width[0] > 0 and height[0] > 0 then
                    local rgba_buffer_size = width[0]*height[0]*4
                    local rgba_buffer = charbuffer(rgba_buffer_size)
                    if native_ISteamUtils_GetImageRGBA(native_ISteamUtils, handle, rgba_buffer, rgba_buffer_size) then
                        local png = begin(width[0] , height[0] , "rgba")
                        for x =0 , width[0]-1 do
                            for y =0, height[0]-1 do
                                local pizda = x*(height[0]*4) + y*4
                                png:write { rgba_buffer[pizda] , rgba_buffer[pizda+1] ,  rgba_buffer[pizda+2] ,  rgba_buffer[pizda+3]}
                            end
                        end
                        huy = png.output
                    end
                end
            end
    elseif handle ~= -1 then
        huy = nil
    end

    function transform(input)
        local output = string.format("%x", input ) -- "7F"
        return ("\\x" .. string.upper(output))
    end

    if not huy then return end

    for i = 1, #huy do  
        image_bytes = image_bytes .. huy[i]
    end

    local image_loaded = render.load_image_buffer(image_bytes)

    return image_loaded
end

avatars.data = {}
avatars.default_image = render.load_image_buffer("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x0C\x00\x00\x00\x0C\x08\x03\x00\x00\x00\x61\xAB\xAC\xD5\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x00\x20\x63\x48\x52\x4D\x00\x00\x7A\x26\x00\x00\x80\x84\x00\x00\xFA\x00\x00\x00\x80\xE8\x00\x00\x75\x30\x00\x00\xEA\x60\x00\x00\x3A\x98\x00\x00\x17\x70\x9C\xBA\x51\x3C\x00\x00\x00\x78\x50\x4C\x54\x45\x23\x1F\x20\x21\x1D\x1E\x28\x25\x26\x28\x24\x25\x27\x23\x24\x75\x73\x73\xAA\xA9\xA9\x71\x6F\x6F\x26\x22\x23\x20\x1C\x1D\x64\x62\x62\xC6\xC5\xC5\x51\x4E\x4F\x57\x54\x55\xCA\xCA\xCA\x5B\x58\x59\x22\x1E\x1F\x4F\x4C\x4D\x20\x1B\x1C\xB7\xB6\xB6\x74\x71\x72\x1F\x1B\x1C\x21\x1C\x1D\x24\x20\x21\x79\x76\x77\xC0\xBF\xBF\x3E\x3A\x3B\x61\x5E\x5F\xC2\xC1\xC1\x49\x45\x46\x88\x86\x86\x7A\x77\x78\x1E\x1A\x1B\x53\x50\x51\x48\x45\x46\x86\x84\x85\x74\x72\x73\x2D\x29\x2A\x2B\x27\x28\xFF\xFF\xFF\x2C\x3A\xBD\x75\x00\x00\x00\x01\x62\x4B\x47\x44\x27\x2D\x0F\xA8\x23\x00\x00\x00\x07\x74\x49\x4D\x45\x07\xE5\x05\x11\x0A\x0B\x10\x59\xCC\xD3\x62\x00\x00\x00\x52\x49\x44\x41\x54\x08\xD7\x63\x60\x40\x07\x8C\x4C\xCC\x8C\x30\x36\x0B\x2B\x1B\x1B\x3B\x07\x84\xCD\xC9\xC5\xCD\xC3\xCB\xC7\xCF\x09\xE6\x08\x08\xF2\x0A\x31\x08\x8B\x88\x42\xB5\x88\x89\x4B\x48\x4A\xC1\x74\x71\x4A\xCB\xC8\xC2\x4D\xE0\x94\x93\x57\x80\x1B\x2D\xA0\xA8\x24\x80\xE0\x28\xAB\x70\x22\x6C\x55\x55\x43\x72\x82\x00\x44\x15\x00\xEA\x7E\x03\x71\xAA\xD2\xFC\x2F\x00\x00\x00\x25\x74\x45\x58\x74\x64\x61\x74\x65\x3A\x63\x72\x65\x61\x74\x65\x00\x32\x30\x32\x31\x2D\x30\x35\x2D\x31\x37\x54\x31\x30\x3A\x31\x31\x3A\x30\x34\x2B\x30\x30\x3A\x30\x30\x18\x6D\xCD\x25\x00\x00\x00\x25\x74\x45\x58\x74\x64\x61\x74\x65\x3A\x6D\x6F\x64\x69\x66\x79\x00\x32\x30\x32\x31\x2D\x30\x35\x2D\x31\x37\x54\x31\x30\x3A\x31\x31\x3A\x30\x34\x2B\x30\x30\x3A\x30\x30\x69\x30\x75\x99\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82")

function avatars.fn_create_item(name)
    avatars.data[name] = {}
    avatars.data[name].url = nil
    avatars.data[name].image = nil
    avatars.data[name].loaded = false
    avatars.data[name].loading = false
end

function avatars.fn_get_avatar(name, entindex)
    if avatars.data[name] and avatars.data[name].loaded then
        return avatars.data[name].image
    end

    if avatars.data[name] == nil then
        avatars.fn_create_item(name)

        local asdass = get_steam_id_fn(entindex)

        if  #asdass < 5 then return avatars.default_image end

        avatars.data[name].image = get_avatar(asdass)
        avatars.data[name].loaded = true
    end

    return avatars.default_image
end

local function get_observators()
    if not engine.is_connected() or not engine.is_in_game() then return end

    local spectators = {}
    local local_player = entity_list.get_local_player()
    if not local_player then return end
    local local_player_ent_index = local_player:get_index()
    local local_target = bit.band(local_player:get_prop("m_hObserverTarget"), 0xFFF)
    local is_local_alive = local_player:is_alive()
    for i = 1, global_vars.max_clients() do
        local entity = entity_list.get_entity(i)
        if not entity then goto continue end
        local observer = bit.band(entity:get_prop("m_hObserverTarget"), 0xFFF)
        if not observer then goto continue end

        if is_local_alive then
            if observer ~= local_player_ent_index then goto continue end
            if entity:is_dormant() then goto continue end
            local name = entity:get_name()
            if not name then goto continue end

            spectators[#spectators+1] ={
                name = name,
                id = entity:get_index(),
            }
        else
            if observer ~= local_target then goto continue end
            if entity == local_player then goto continue end
            if entity:is_dormant() then goto continue end
            local name = entity:get_name()
            if not name then goto continue end

            spectators[#spectators+1] ={
                name = name,
                id = entity:get_index(),
            }
        end

        ::continue::
    end

    return spectators
end

jmp_ecx = memory.find_pattern("engine.dll", "FF E1")
fnGetModuleHandle = ffi.cast("uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)", jmp_ecx)
fnGetProcAddress = ffi.cast("uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)", jmp_ecx)
pGetProcAddress = ffi.cast("uint32_t**", ffi.cast("uint32_t", memory.find_pattern("engine.dll", "FF 15 ? ? ? ? A3 ? ? ? ? EB 05")) + 2)[0][0]

pGetModuleHandle = ffi.cast("uint32_t**", ffi.cast("uint32_t", memory.find_pattern("engine.dll", "FF 15 ? ? ? ? 85 C0 74 0B")) + 2)[0][0]
function BindExports(sModuleName, sFunctionName, sTypeOf)
    local ctype = ffi.typeof(sTypeOf)
    return function(...)
        return ffi.cast(ctype, jmp_ecx)(fnGetProcAddress(pGetProcAddress, 0, fnGetModuleHandle(pGetModuleHandle, 0, sModuleName), sFunctionName), 0, ...)
    end
end
fnEnumDisplaySettingsA = BindExports("user32.dll", "EnumDisplaySettingsA", "int(__fastcall*)(unsigned int, unsigned int, unsigned int, unsigned long, void*)");
pLpDevMode = ffi.new("struct { char pad_0[120]; unsigned long dmDisplayFrequency; char pad_2[32]; }[1]")
    
fnEnumDisplaySettingsA(0, 4294967295, pLpDevMode[0])

local frequency = pLpDevMode[0].dmDisplayFrequency

formatting = (function(avg)
    if avg < 1 then return ('%.2f'):format(avg) end
    if avg < 10 then return ('%.1f'):format(avg) end
    return ('%d'):format(avg)
end)

local binds = {
    { "Body lean resolver", menu.find("aimbot", "general", "aimbot", "body lean resolver")[2] },
    { "Resolver override", menu.find("aimbot", "general", "aimbot", "override resolver")[2] },
    { "On shot anti-aim", menu.find("aimbot", "general", "exploits", "hideshots", "enable")[2] },
    { "Duck peek assist", menu.find("antiaim", "main", "general", "fake duck", "enable")[2] },
    { "Quick peek assist", menu.find("aimbot", "general", "misc", "autopeek", "enable")[2] },
    { "Force body aim", menu.find("aimbot", "scout", "target overrides", "force hitbox")[2] },
    { "Force safe point", menu.find("aimbot", "scout", "target overrides", "force safepoint")[2] },
    { "Damage override", menu.find("aimbot", "scout", "target overrides", "force min. damage")[2] },
    { "Double tap", menu.find("aimbot", "general", "exploits", "doubletap", "enable")[2] },
    { "Freestanding", menu.find("antiaim","main","auto direction","enable")[2] },
    { "Ping", menu.find("aimbot","general","fake ping","enable")[2] },
    { "Hitchance override", menu.find("aimbot", "scout", "target overrides", "force hitchance")[2] },
    { "Dormant Aimbot", menu.find("aimbot", "general", "aimbot", "enable")[2] },
    { "Manual : Left", menu.find("antiaim", "main", "manual", "left")[2] },
    { "Manual : Right", menu.find("antiaim", "main", "manual", "right")[2] },
    { "AA Invert", menu.find("antiaim", "main", "manual", "invert desync")[2] },
    { "Nade throw", menu.find("misc", "utility", "nade helper", "autothrow")[2] },
}

local function refresh()
    avg = math.abs(global_vars.frame_time() * 600)
    fps = math.floor(1 / global_vars.frame_time())
end
client.delay_call(refresh, 5.0)

local function active_binds()
    local ret = {}

    for k, v in pairs(binds) do
        if v[2]:get() and v[2]:get_mode() ~= 3 then
            ret[#ret + 1] = { v[1], v[2]:get_mode() }
        end
    end

    return ret
end

local ui = {
    display = menu.add_multi_selection("Script Items", "Display", { "Watermark", "Keybinds", "Spectator List" }),
    seperator = menu.add_separator("Script Items"),
    watermark = menu.add_multi_selection("Script Items", "Watermark display items", { "User name", "Fps", "Ping", "Tick", "Time" }),
    name = menu.add_selection("Script Items", "Watermark name", {"Forum", "Steam"}),
    avatar = menu.add_selection("Script Items", "Avatar position", {"Not display", "left", "right"})
}

local accent = ui.display:add_color_picker("accent", color_t(178, 189, 255, 85))

local pos = {
    ["keybinds x"] = menu.add_slider("bycat", "GoLLtLn", 0, screen.x),
    ["keybinds y"] = menu.add_slider("bycat", "UyDvgwgktUEBPNxleVEH", 0, screen.y),
    ["spectators x"] = menu.add_slider("bycat", "gPGRjidhIxQxP", 0, screen.x),
    ["spectators y"] = menu.add_slider("bycat", "gkOsI", 0, screen.y)
}
pos["keybinds x"]:set_visible(false)
pos["keybinds y"]:set_visible(false)
pos["spectators x"]:set_visible(false)
pos["spectators y"]:set_visible(false)

local watermark = { size = 0, width = 0, string = "" }

function watermark.draw()
    if not ui.display:get(1) then return end

    watermark.string = "primordial"

    local hours, minutes, seconds = client.get_local_time()
    local actual_time = ("%02d:%02d:%02d"):format(hours, minutes, seconds)
    local latency = "not connected"
    local name = user.name
    local tick = "- tick"
    if engine.is_connected() and entity_list.get_local_player() ~= nil then
        latency = ("delay: %dms"):format(math.floor(engine.get_latency(e_latency_flows.INCOMING)))
        if ui.name:get() == 2 then name = entity_list.get_local_player():get_name() end
        tick = client.get_tickrate() .. "tick"
    end

    if ui.watermark:get(1) then watermark.string = watermark.string .. " | " .. name end
    if ui.watermark:get(2) then watermark.string = watermark.string .. " | fps: " .. fps end
    if ui.watermark:get(3) then watermark.string = watermark.string .. " | " .. latency end
    if ui.watermark:get(4) then watermark.string = watermark.string .. " | " .. tick end
    if ui.watermark:get(5) then watermark.string = watermark.string .. " | " .. actual_time end

    watermark.size = render.get_text_size(font, watermark.string).x
    watermark.width = math.lerp(watermark.width, watermark.size, 10)

    render.rect_filled(vec2_t(screen.x - 15 - watermark.width, 10), vec2_t(watermark.width + 10, 20), color_t(0, 0, 0, accent:get().a))
    render.rect_filled(vec2_t(screen.x - 15 - watermark.width, 10), vec2_t(watermark.width + 10, 2), color_t(accent:get().r, accent:get().g, accent:get().b))
    render.text(font, watermark.string, vec2_t(screen.x - watermark.width - 10, 15), color_t(245, 245, 245))
end

local keybinds = { width = 150, size = 0, state = false, alpha = 0 }

function keybinds.draw()
    if not ui.display:get(2) then return end

    x = pos["keybinds x"]:get()
    y = pos["keybinds y"]:get()
    w = keybinds.width
    keybinds.size = 150
    keybinds.state = true

    local binds = active_binds()
    if not binds then keybinds.state = false end
    if binds then if #binds == 0 then keybinds.state = false end end
    if menu.is_open() then keybinds.state = true end

    if keybinds.state then
        keybinds.alpha = math.lerp(keybinds.alpha, 255, 10)
    else
        keybinds.alpha = math.lerp(keybinds.alpha, 0, 10)
    end

    alpha = math.floor(keybinds.alpha)

    if alpha <= 1 then return end

    render.rect_filled(vec2_t(x, y), vec2_t(w, 20), color_t(0, 0, 0, math.floor(alpha / 255 * accent:get().a)))
    render.rect_filled(vec2_t(x, y), vec2_t(w, 2), color_t(accent:get().r, accent:get().g, accent:get().b, alpha))
    render.text(font, "keybinds", vec2_t(x + w / 2, y + 10), color_t(245, 245, 245, alpha), true)

    for i = 1, #binds do
        local target = binds[i]
        local name = target[1]
        local val = target[2]

        render.text(font, name, vec2_t(x + 5, y + 23 + (16 * (i - 1))), color_t(245, 245, 245, alpha))
        render.text(font, bind_modes[val], vec2_t(x + w - 5 - render.get_text_size(font, bind_modes[val]).x, y + 23 + (16 * (i - 1))), color_t(245, 245, 245, alpha))
    
        if keybinds.size < render.get_text_size(font, name .. " " .. bind_modes[val]).x + 20 then keybinds.size = render.get_text_size(font, name .. " " .. bind_modes[val]).x + 20 end
    end

    keybinds.width = math.lerp(keybinds.width, keybinds.size, 10)
end

local spectators = { width = 150, size = 0, state = false, alpha = 0 }

function spectators.draw()
    if not ui.display:get(3) then return end

    x = pos["spectators x"]:get()
    y = pos["spectators y"]:get()
    w = spectators.width
    spectators.size = 150
    spectators.state = true

    local specs = {}
    if engine.is_connected() then
        specs = get_observators()
    end
    if not specs then spectators.state = false end
    if specs then if #specs == 0 then spectators.state = false end end
    if menu.is_open() then spectators.state = true end

    if spectators.state then
        spectators.alpha = math.lerp(spectators.alpha, 255, 10)
    else
        spectators.alpha = math.lerp(spectators.alpha, 0, 10)
    end

    alpha = math.floor(spectators.alpha)

    if alpha <= 1 then return end

    render.rect_filled(vec2_t(x, y), vec2_t(w, 20), color_t(0, 0, 0, math.floor(alpha / 255 * accent:get().a)))
    render.rect_filled(vec2_t(x, y), vec2_t(w, 2), color_t(accent:get().r, accent:get().g, accent:get().b, alpha))
    render.text(font, "spectators", vec2_t(x + w / 2, y + 10), color_t(245, 245, 245, alpha), true)

    local extra_X = 0

    for i = 1, #specs do
        local target = specs[i]
        local name = target.name
        local val = avatars.fn_get_avatar(name, target.id)

        if ui.avatar:get() == 2 then
            extra_X = 15
            render.texture(val.id, vec2_t(x + 5, y + 24 + (16 * (i - 1))), vec2_t(12, 12), color_t(255, 255, 255, alpha))
        elseif ui.avatar:get() == 3 then
            extra_X = 0
            render.texture(val.id, vec2_t(x + w - 5 - 12, y + 24 + (16 * (i - 1))), vec2_t(12, 12), color_t(255, 255, 255, alpha))
        end

        render.text(font, name, vec2_t(x + 5 + extra_X, y + 23 + (16 * (i - 1))), color_t(245, 245, 245, alpha))

        if spectators.size < render.get_text_size(font, name).x + 20 then spectators.size = render.get_text_size(font, name).x + 20 end
    end

    spectators.width = math.lerp(spectators.width, spectators.size, 10)
end

local loc = { ["keybinds"] = false, ["keybinds x"] = 0, ["keybinds y"] = 0, ["spectators"] = false, ["spectators x"] = 0, ["spectators y"] = 0 }

local function draggables()
    if not input.is_key_held(e_keys.MOUSE_LEFT) then
        loc["keybinds"] = false
        loc["spectators"] = false
    end

    if loc["keybinds"] == false then
        loc["keybinds x"] = input.get_mouse_pos().x - pos["keybinds x"]:get()
        loc["keybinds y"] = input.get_mouse_pos().y - pos["keybinds y"]:get()
    end

    if loc["spectators"] == false then
        loc["spectators x"] = input.get_mouse_pos().x - pos["spectators x"]:get()
        loc["spectators y"] = input.get_mouse_pos().y - pos["spectators y"]:get()
    end

    if not loc["spectators"] and ui.display:get(2) then
        if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(pos["keybinds x"]:get(), pos["keybinds y"]:get()), vec2_t(keybinds.width, 20)) or loc["keybinds"] then
            loc["keybinds"] = true
            pos["keybinds x"]:set(input.get_mouse_pos().x - loc["keybinds x"])
            pos["keybinds y"]:set(input.get_mouse_pos().y - loc["keybinds y"])
        end
    end

    if not loc["keybinds"] and ui.display:get(3) then
        if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(pos["spectators x"]:get(), pos["spectators y"]:get()), vec2_t(spectators.width, 20)) or loc["spectators"] then
            loc["spectators"] = true
            pos["spectators x"]:set(input.get_mouse_pos().x - loc["spectators x"])
            pos["spectators y"]:set(input.get_mouse_pos().y - loc["spectators y"])
        end
    end
end

callbacks.add(e_callbacks.PAINT, function()
    draggables()
    watermark.draw()
    keybinds.draw()
    spectators.draw()
end)