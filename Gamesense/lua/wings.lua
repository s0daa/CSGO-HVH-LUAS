--[[

        /ᐠ. ｡.ᐟ\ᵐᵉᵒʷˎˊ˗ 
        Made by NeDIAD a.k.a NotDIAD
        https://github.com/NeDIAD , @nediad , @notdiad

]]

--#region PRE-INIT

local wings = {hooks = {}}
wings.start = client.timestamp()
local hooks = {'paint', 'paint_ui', 'player_score', 'round_end', 'client_disconnect', 'player_say', 'shutdown', 'string_cmd', 'player_connect_full', 'override_view', 'player_changename', 'player_spawn', 'net_update_start', 'aim_hit', 'aim_miss', 'aim_fire', 'setup_command', 'run_command', 'predict_command'}
for i, v in pairs(hooks) do wings.hooks[v] = {} end
local http = require('gamesense/http')
local vector = require('vector')
local images = require('gamesense/images')
local clipboard = require('gamesense/clipboard')
local base64 = require('gamesense/base64')

local persona = panorama.open().MyPersonaAPI

--#endregion

--#region DB
local db = database.read('wings') or {}
local migrated = false

db.chat = db.chat or {}
db.dox = db.dox or {}
db.configs = db.configs or {}

local migrate = {
    dox = 'wings_dox',
    chat = 'wings_chat'
}


if not db.migrated then
    db.migrated = true
    migrated = true
    
    print('Migrating db..')
    
    for tbl, name in pairs(migrate) do
        local base = database.read(name)
        print('Migrate ' .. name .. ' => main')

        if not base then print('Migrate fail!') goto continue end

        db[tbl] = base
        database.write(name, nil)

        ::continue::
    end
    
    print('DB Migrated.')
end

local function save()
    database.write('wings', db)
    database.flush()
end

wings.hooks.shutdown.db_save = save
--#endregion

--#region INIT
client.exec('clear')
local gsa = panorama.open().GameStateAPI
local mai = panorama.open().MatchInfoAPI
local chat = require('gamesense/chat')

wings.hooks.paint.smile = function() renderer.indicator(164, 158, 229, 255, '>_<') end

--#region MATH
function math.clamp(v, min, max)
    if type(min) ~= 'number' or type(max) ~= 'number' or min >= max then return max end

    if type(v) == 'table' then
        local clamped = {}

        for i, val in pairs(v) do
            clamped[i] = math.clamp(val, min, max)
        end

        return unpack(clamped)
    else
        return math.max(min, math.min(max, (v or max)))
    end

    return false
end

function math.lerp(a, b, c) if not a or not b or not c then return 0 end return (b + ( c - b ) * a or 0)  end

--#endregion

--#region TABLE
table.reverse = function(a) local b = {} for i, v in ipairs(a) do table.insert(b, 1, v) end return b end
table.find = function(a, b) for i, v in pairs(a) do if v == b then return i end end end
table.dig = function(a, ...)
	local keys = {...}

	for i=1, #keys do
		if a == nil then
			return nil
		end

		a = a[keys[i]]
	end

	return a or nil
end

local function deep_compare(tbl1, tbl2)
	if tbl1 == tbl2 then
		return true
	elseif type(tbl1) == "table" and type(tbl2) == "table" then
		for key1, value1 in pairs(tbl1) do
			local value2 = tbl2[key1]

			if value2 == nil then
				return false
			elseif value1 ~= value2 then
				if type(value1) == "table" and type(value2) == "table" then
					if not deep_compare(value1, value2) then
						return false
					end
				else
					return false
				end
			end
		end

		for key2, _ in pairs(tbl2) do
			if tbl1[key2] == nil then
				return false
			end
		end

		return true
	end

	return false
end

--#endregion

--#region STRING
string.split = function(input, sep) if sep == nil then sep = '%s' end local t = {} for str in string.gmatch(input, '([^'..sep..']+)') do table.insert(t, str) end return t end

--#endregion

--#region TWEAKS
function unix_ts() return panorama.loadstring('return Date.now()')() end

local function datetime(timestamp)
    return panorama.loadstring(string.format([[
        var date = new Date(%d * 1000);
        var offset = date.getTimezoneOffset() * 60;
        return new Date((%d - offset) * 1000).toISOString().replace("T", " ").substring(0, 19);
    ]], timestamp, timestamp))()
end


function steam64(steam3)
    return tonumber(steam3) + 76561197960265728
end

local mute = {
    is_muted = function(ent) return gsa.IsSelectedPlayerMuted(gsa.GetPlayerXuidStringFromEntIndex(ent)) end,
    toggle = function(ent) return gsa.ToggleMute(gsa.GetPlayerXuidStringFromEntIndex(ent)) end,
}; mute.set = function(ent, state) if mute.is_muted(ent) ~= state then mute.toggle(ent) return true; else return false end end

--#endregion

--#region COLOR32
local color32 = {}

function color32.rgb_to_int(r, g, b)
	local r_byte = color32._decimal_to_byte(r)
	local g_byte = color32._decimal_to_byte(g)
	local b_byte = color32._decimal_to_byte(b)

	return color32._binary_to_decimal(b_byte .. g_byte .. r_byte)
end

function color32._decimal_to_byte(integer)
	local bin = ''

	while integer ~= 0 do
		if integer % 2 == 0 then
			bin = '0' .. bin
		else
			bin = '1' .. bin
		end

		integer = math.floor(integer / 2)
	end

	local length = string.len(bin)
	local byte = ''

	for _ = 1, 8 - length do
		byte = byte .. '0'
	end

	return byte .. bin
end

function color32._binary_to_decimal(binary)
	binary = string.reverse(binary)

	local sum = 0
	local num

	for i = 1, string.len(binary) do
		num = string.sub(binary, i,i) == "1" and 1 or 0
		sum = sum + num * math.pow(2, i-1)
	end

	return sum
end
--#endregion

--#region FFI
local ffi = require('ffi')

local color do
    ffi.cdef[[
    typedef struct {
        uint8_t r, g, b, a;
    } Color;
    ]]

    color = {}

    local function ffi_hex(hex)
        hex = string.gsub(hex, '^#', '')
        return tonumber(string.sub(hex, 1, 2), 16), tonumber(string.sub(hex, 3, 4), 16), tonumber(string.sub(hex, 5, 6), 16), tonumber(string.sub(hex, 7, 8), 16) or 255
    end

    local Color = ffi.metatype('Color', {
        __tostring = function(self)
            return string.format('RGBA(%d, %d, %d, %d)', self.r, self.g, self.b, self.a)
        end,
        to_hex = hex
    })

    color.rgb = function(r, g, b, a)
        r = math.min(r or 255, 255)
        g = g and math.min(g, 255) or r
        b = b and math.min(b, 255) or r
        a = a and math.min(a, 255) or 255
        return Color(r, g, b, a)
    end

    color.hex = function(hex)
        r, g, b, a = ffi_hex(hex)
        return Color(r, g, b, a)
    end
end

--#region FILESYSTEM
local filesystem = {} do
    local m, i = 'filesystem_stdio.dll', 'VFileSystem017'
    local add_search_path = vtable_bind(m, i, 11, 'void (__thiscall*)(void*, const char*, const char*, int)')
    local remove_search_path = vtable_bind(m, i, 12, 'bool (__thiscall*)(void*, const char*, const char*)')

    local get_game_directory = vtable_bind('engine.dll', 'VEngineClient014', 36, 'const char*(__thiscall*)(void*)')
    filesystem.game_directory = string.sub(ffi.string(get_game_directory()), 1, -5)

    add_search_path(filesystem.game_directory, 'ROOT_PATH', 0)
    defer(function () remove_search_path(filesystem.game_directory, 'ROOT_PATH') end)

    filesystem.create_directory = vtable_bind(m, i, 22, 'void (__thiscall*)(void*, const char*, const char*)')
end

function filesystem.collect_mp3(path)
    local interface = client.create_interface("filesystem_stdio.dll", "VFileSystem017")

    local find_first = ffi.cast("const char*(__thiscall*)(void*, const char*, const char*, int*)",
        client.find_signature("filesystem_stdio.dll", "\x55\x8B\xEC\x6A\x00\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08\xE8\xCC\xCC\xCC\xCC\x5D"))

    local find_next = ffi.cast("const char*(__thiscall*)(void*, int)",
        client.find_signature("filesystem_stdio.dll", "\x55\x8B\xEC\x83\xEC\x0C\x53\x8B\xD9\x8B\x0D\xCC\xCC\xCC\xCC"))

    local find_close = ffi.cast("void(__thiscall*)(void*, int)",
        client.find_signature("filesystem_stdio.dll", "\x55\x8B\xEC\x53\x8B\x5D\x08\x85"))
    local find_is_directory = ffi.cast("bool(__thiscall*)(void*, int)",
        client.find_signature("filesystem_stdio.dll", "\x55\x8B\xEC\x0F\xB7\x45\x08"))

    local files = {}
    local file_handle = ffi.typeof("int[1]")()
    local file = find_first(interface, path or '*', 'ROOT_PATH', file_handle)
    
    while file ~= nil do
        local file_name = ffi.string(file)
        if not find_is_directory(interface, file_handle[0]) and (file_name:find(".mp3") or file_name:find(".wav")) then
            files[#files+1] = file_name
        end
        file = find_next(interface, file_handle[0])
    end
    
    find_close(interface, file_handle[0])
    return files
end


filesystem.create_directory('wings', 'ROOT_PATH')
filesystem.create_directory('csgo/sound/wings', 'ROOT_PATH')
--#endregion

local playsound = ffi.cast("void(__thiscall*)(void*, const char*)", (ffi.cast("void***", client.create_interface("vguimatsurface.dll", "VGUI_Surface031"))[0])[82])

local cl_engine = ffi.cast(ffi.typeof('void***'), client.create_interface('engine.dll', 'VEngineClient014'))
local console_visible = ffi.cast(ffi.typeof('bool(__thiscall*)(void*)'), cl_engine[0][11])

local direct_print = vtable_bind('vstdlib.dll', 'VEngineCvar007', 25, 'void(__cdecl*)(void*, const void*, const char*, ...)')

--#endregion

--#endregion

--#region POST-INIT

local function rgb(r, g, b, a)
    r, g, b = math.clamp({r, g, b}, 0, 255)
    a = math.clamp(a, 0, 255) or 255

    if a and a >= 255 then
        return string.format('\a%02X%02X%02X', r, g, b)
    else
        return string.format('\a%02X%02X%02X%02X', r, g, b, a)
    end
end

wings.color = {
    base = rgb(145, 135, 255),
    gray = rgb(179, 179, 179),
    white = rgb(255, 255, 255),
    dark = rgb(115, 115, 115),

    green = rgb(50, 255, 118),
    red = rgb(236, 40, 83),

    logs = {
        hit = {
            mismatch = rgb(105, 99, 165),
            succesful = rgb(145, 135, 255),
        },

        miss = {
            spread = rgb(255, 178, 36),
            ['?'] = rgb(255, 36, 54), -- aka resolver
            death = rgb(255, 36, 127), -- aka ping
            ['prediction error'] = rgb(255, 36, 54),
            ['unregistered shot'] = rgb(36, 255, 102),
            other = rgb(17, 236, 171),
        }
    }
}

wings.settings = {
    prefix = '   ' .. wings.color.base .. 'wings' .. wings.color.white .. ' » ',
    chat_prefix = '{purple} wings {white} » {grey}',
    dev = false,
    build = 'Development build v0.1'
}

local function wasted() return wings.color.base .. ' • ' .. wings.color.gray .. string.format('%.f', client.timestamp() - wings.start) .. wings.color.base .. 'ms' end
local function format(...) local args = {...} return wings.color.dark .. 'FF' .. table.concat(args, ' / ', 1, #args - 1) .. wings.color.gray .. 'FF / ' .. args[#args] end

local cprint = function(...) chat.print(wings.settings.chat_prefix, ...) end

function print(...)
    local args = {...}  

    table.insert(args, 1, wings.settings.prefix)

    for i, v in pairs(args) do
        local r = wings.color.gray .. string.gsub(tostring(v), '[\r\v]', {
            ['\r'] = wings.color.gray,
            ['\v'] = '\a'.. (('74A6A9FF'):sub(1, 7))
        })
        for col, text in r:gmatch('\a(%x%x%x%x%x%x)([^\a]*)') do
            direct_print(color.hex(col), text)
        end
    end
    
    direct_print(color.rgb(255, 255, 255), '\n')

    return true
end

direct_print(color.rgb(164, 158, 229), [[



        ⠀⢀⣴⢿⠇⠀   __      __.__                      
    ⠀⠀⠀⢀⡾⠁⡞⠀⠀⠀   /  \    /  \__| ____    ____  ______
    ⠀⠀⢠⢺⠃⢸⡇⠀⠀⠀   \   \/\/   /  |/    \  / ___\/  ___/
    ⠀⢠⠏⢸⡄⠈⣇⠀⠀⠀    \        /|  |   |  \/ /_/  >___ \ 
    ⠀⢸⡀⢸⡄⠀⠹⡄⠀⠀     \__/\  / |__|___|  /\___  /____  >
    ⢀⡜⡇⠈⣿⡀⠀⠙⢄⠀          \/          \//_____/     \/ 
    ⢸⠀⢳⠄⠹⣿⡄⠀⠈⢦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⣸⠆⢸⣧⡄⢸⣿⣶⠀⢠⠙⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠷⡀⠹⣷⣄⣻⣿⡟⠺⣷⡀⠉⠓⢤⡀⠀⠀]] .. wings.settings.build .. [[ 
    ⢧⠀⣶⣄⡘⢿⣦⣽⣿⣄⠈⢱⡦⠀⠀⠉⠓⢤⡀⠀⠀⠀⠀]] .. ( wings.settings.dev and 'Debug mode.' or '' ) .. [[ ⠀
    ⠘⣇⠈⠻⣷⡜⢻⣧⠉⠻⣄⠈⢻⣶⣴⠶⡄⠀⠙⡆⠀⠀⠀⠀
    ⠀⢻⠉⣄⠈⢿⣿⣿⣷⠀⠀⣶⣤⣀⣷⣀⠀⠀⠀⣸⠀⠀⠀⠀
    ⠀⠀⢧⡈⢿⣥⣍⣿⠉⠉⠃⢶⣦⣿⠀⠀⠀⠀⡚⠋⠀⠀⠀⠀
    ⠀⠀⠈⠳⣤⣈⠛⠻⢷⣦⣤⡄⣶⣾⣿⠃⠀⠀⠛⢦⡄⠀⠀⠀
    ⠀⠀⠀⠀⠀⠉⠒⠒⣾⠋⠁⠀⣈⣽⣿⣷⡆⠀⠀⠀⠘⡄⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠹⠦⢴⠋⠁⠀⠹⣿⣿⣿⠀⠀⠀⠙⣄⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⢤⠴⠋⠀⡀⠛⠿⠟⡇⠠⠤⠤⠷
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠤⠴⣇⣠⣏⣰⠁⠀⠀⠀⠀


]])

print('Post-Init', wasted())

local raw_assert = assert
assert = function(...) if wings.settings.dev then print(...) end end

assert('Debug-mode.')

direct_print(color.rgb(255, 255, 255), '\n')

if migrated then
    print('Database was succesfully migrated to new version!')
end

--#endregion

--#region ASSETS
local png = {
    checkmark = 'checkmark',
    warning = 'warning',
    dismiss = 'dismiss',
}

filesystem.create_directory('wings/assets', 'ROOT_PATH')

local link = 'https://raw.githubusercontent.com/NeDIAD/wings/main/assets'

for i, v in pairs(png) do

    local texture = readfile('wings/assets/' .. v .. '.png')
    local download = link .. v .. '.png'

    if texture then 
        png[i] = renderer.load_png(texture, 24, 24) 
    else
        http.get(download, function(success, raw)
            if success then
                writefile('wings/assets/' .. v .. '.png', raw.body)
                print('Asset-manager: Downloaded ' .. v .. '.png (' .. download .. ')')
                png[i] = renderer.load_png(raw.body, 24, 24)
            else
                print('Asset-manager: Failed to download ' .. v .. '.png (' .. download .. ')')
            end
        end)
    end
end

if not readfile('csgo/sound/wings/hitsound.mp3') then
    http.get(link .. '/hitsound.mp3', function(success, raw)
        if success then
            writefile('csgo/sound/wings/hitsound.mp3', raw.body)
            print('Asset-manager: Downloaded hitsound.mp3 (' .. link .. '/hitsound.mp3)')
        else   
            print('Asset-manager: Failed to download hitsound.mp3 (' .. link .. '/hitsound.mp3)')
        end
    end)
end

--#endregion

--#region DISCORD RPC
local rpc do
    print('DiscordRPC: Processing..', wasted())
    local result, named_pipes = pcall(function() return require('gamesense/named_pipes') end)
    if not result then print(wings.color.red .. 'Failed to define \"named_pipes\", Discord RPC may not work.') end

    local tries = 0

    rpc = {
        client_id = "1286308928493453355",
        pipe = nil,
        open = false,
        ready = false,
        request_callbacks = {}
    }

    local OPCODE_HANDSHAKE = 0
    local OPCODE_FRAME = 1
    local OPCODE_CLOSE = 2
    local OPCODE_PING = 3
    local OPCODE_PONG = 4

    local function generate_nonce()
        local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
        return (string.gsub(template, '[xy]', function (c)
            local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
            return string.format('%x', v)
        end))
    end
    
    local function pack_int32le(int)
        return ffi.string(ffi.cast("const char*", ffi.new("uint32_t[1]", int)), 4)
    end
    
    local function unpack_int32le(str)
        return tonumber(ffi.cast("uint32_t*", ffi.cast("const char*", str))[0])
    end

    local function encode_str(opcode, str)
        local len = str:len()
        return pack_int32le(opcode) .. pack_int32le(len) .. str
    end

    local function read_data(pipe)
        local header = pipe:read(8)
        if not header then return end
    
        local opcode = unpack_int32le(header:sub(1, 4))
        local len = unpack_int32le(header:sub(5, 8))
    
        local raw = pipe:read(len)
        if not raw then return end
    
        local data = json.parse(raw)
        return opcode, data
    end    

    function rpc:connect()
        if not result then print('DiscordRPC: ' .. wings.color.red .. 'Service unavailable, required library aint defined.') return false end
        if self.pipe then return false end

        for i = 0, 10 do
            local success, pipe = pcall(named_pipes.open_pipe, '\\\\?\\pipe\\discord-ipc-' .. i)
            assert('DiscordRPC: Connecting pipe ' .. wings.color.base .. '\\\\?\\pipe\\discord-ipc-' .. i, wasted())

            if success then
                tries = 0
                print('DiscordRPC: Handshake!', wasted())
                self.pipe = pipe
                self.open = true
                self.ready = false
                self:write(OPCODE_HANDSHAKE, string.format('{"v":1,"client_id":%s}', json.stringify(self.client_id)))
                return self
            end
        end
        if tries < 3 then print('DiscordRPC: Connecting failed after 10 tries.') end

        tries = tries + 1
    end

    function rpc:set_activity(details)
        self.activity = details
        self:revive_activity()
    end    

    function rpc:request(cmd, args, callback)
        local args_text = args and string.format('"args":%s,', json.stringify(args)) or ""
        local nonce = generate_nonce()
        local json_str = string.format('{"cmd":%s,%s"nonce":%s}', json.stringify(cmd), args_text, json.stringify(nonce))

        if callback then
            self.request_callbacks[nonce] = callback
        end

        self:write(OPCODE_FRAME, json_str)
    end

    function rpc:revive()
        self:connect()

        client.delay_call(5, function()
            if self.pipe then return false end
            self:revive()
            assert('DiscordRPC: Trying to revive.', wasted())
        end)
    end

    function rpc:process_messages()
        if not self.pipe then return false end
        
        for i = 1, 100 do
            local success, opcode, data = pcall(read_data, self.pipe)
            
            if not success then
                assert('DiscordRPC: Fatal error! Pipe closed unexpectedly')
                self.pipe = nil
                self.open = false
                self.ready = false

                self:revive()
                return
            elseif opcode == OPCODE_FRAME and data.cmd == "DISPATCH" then
                assert('DiscordRPC: ', data.cmd)
                if data.evt == "READY" then
                    self.ready = true
                end
            elseif opcode == OPCODE_PONG then
                assert('DiscordRPC: '.. wings.color.base ..'Pong!')
                self:write(OPCODE_PONG, "")
            end
        end
    end

    function rpc:write(opcode, str)
        if not result then print('DiscordRPC: ' .. wings.color.red .. 'Service unavailable, required library aint defined.') return false end
        if not self.pipe then return false end

        local success = pcall(self.pipe.write, self.pipe, encode_str(opcode, str))
        if not success then
            self:close()
        end
    end

    function rpc:close()
        if not self.pipe then return false end

        print('DiscordRPC: Thread closed.')

        self:write(OPCODE_CLOSE, string.format('{"v":1,"client_id":%s}', json.stringify(self.client_id)))
        pcall(named_pipes.close_pipe, self.pipe)
        self.pipe = nil
        self.open = false
        self.ready = false
    end

    function rpc:revive_activity()
        assert('DiscordRPC: Waiting \"DISPATCH\" state.')

        client.delay_call(5, function()
            if not self.ready then self:revive_activity() return false end
            self:request("SET_ACTIVITY", { pid = 4, activity = self.activity })
        end)
    end

    -- Handler
    print('DiscordRPC: Handled! Connecting after 10sec.', wasted())
    
    client.delay_call(10, function()
        rpc:revive()

        rpc:set_activity({
            details = 'Flying high.',
            state = wings.settings.build,
            timestamps = { start = unix_ts() },
            assets = {large_image = 'wings_'},
            images = {large_image = 'wings_'}
        })

        wings.hooks.paint_ui.rpc_handler = function() rpc:process_messages() end
        wings.hooks.shutdown.rpc_handler = function() rpc:close() end
        print('DiscordRPC: Active!', wasted())
    end)
end

--#endregion

--#region MODULES

print('Modules..', wasted())

local render do
    render = {}
    
    function render.rectangle(x, y, w, h, r, g, b, a, radius, ignore_corner)
        x = type(x) == 'number' and x or 0; y = type(y) == 'number' and y or 0; w = type(w) == 'number' and w or 0; h = type(h) == 'number' and h or 0; r = r or 255 g = g or 255 b = b or 255 a = a or 0 radius = radius or 8
        x = math.floor(x); y = math.floor(y); w = math.floor(w); h = math.floor(h)

        ignore_corner = type(ignore_corner) == 'table' and ignore_corner or {}
        local off_corner = {lb = true, lt = true, rb = true, rt = true}

        if --[[x < 10 or y < 10 or]] w < 10 or h < 10 then ignore_corner = off_corner end

        renderer.rectangle(x + radius, y, w - 2 * radius, h, r, g, b, a)
        renderer.rectangle(x, y + radius, radius, h - 2 * radius, r, g, b, a)
        renderer.rectangle(x + w - radius, y + radius, radius, h - 2 * radius, r, g, b, a)

        if not ignore_corner.lb then 
            renderer.circle(x + radius, y + h - radius, r, g, b, a, radius, -90, 0.25) 
        else
            renderer.rectangle(x, y + h - radius, radius, radius, r, g, b, a)
        end -- l b

        if not ignore_corner.lt then 
            renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25) 
        else
            renderer.rectangle(x, y, radius, radius, r, g, b, a)
        end -- l t

        if not ignore_corner.rb then 
            renderer.circle(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25) 
        else
            renderer.rectangle(x + w - radius, y + h - radius, radius, radius, r, g, b, a)
        end -- r b

        if not ignore_corner.rt then 
            renderer.circle(x + w - radius, y + radius, r, g, b, a, radius, 90, 0.25) 
        else
            renderer.rectangle(x + w - radius, y, radius, radius, r, g, b, a)
        end -- r t
    end

    function render.glow(x, y, w, h, r, g, b, a, radius, ignore_corner, thickness, smooth)
        smooth = type(smooth) == 'table' and smooth or {}
        thickness = type(thickness) == 'number' and thickness or 10

        smooth.padding = type(smooth.padding) == 'number' and smooth.padding or 2
        smooth.alpha = type(smooth.alpha) == 'number' and smooth.alpha or 10

        for i = 1, thickness do
            local padding = smooth.padding * i
            local alpha = math.clamp(a - (smooth.alpha * i), 5, 255)

            render.rectangle(x - i / 2, y - i / 2, w + i, h + i, r, g, b, alpha, radius, ignore_corner)

            --assert('Iteration: ', i)

            if alpha == 5 then break end
        end
    end

    print(wings.color.green .. '» ' .. wings.color.base .. 'Render Library', wasted())
end

local mouse do
    mouse = {}
    
    function mouse.held() return client.key_state(0x01) end
    function mouse.inbounds(x, y, w, h) 
        x = x or 0 y = y or 0 w = w or 0 h = h or 0

        local endX, endY = x + w, y + h
        local mX, mY = ui.mouse_position()

        return mX >= x and mY >= y and mX <= endX and mY <= endY
    end
    function mouse.calc(x1, y1, x2, y2, w, h)
        local scrW, scrH = client.screen_size()
        local mX, mY = ui.mouse_position()
    
        local offsetX = x2 - x1
        local offsetY = y2 - y1

        local newX = mX - offsetX
        local newY = mY - offsetY

        if newX < 0 then newX = 0 end
        if newY < 0 then newY = 0 end
        if newX + w > scrW then newX = scrW - w end
        if newY + h > scrH then newY = scrH - h end

        return newX, newY
    end

    print(wings.color.green .. '» ' .. wings.color.base .. 'Mouse Library', wasted())
end

local widgets do
    widgets = {}
    widgets.__index = widgets
    widgets.widgets = {}
    widgets.dragging = nil
    local scrW, scrH = client.screen_size()

    local mouse_magnet = {
        y = {35, scrH / 2, scrH - 35},
        x = {scrW / 2}
    }

    function widgets.new(id, push, x, y, w, h, draggable, tooltip)
        if not id or widgets.widgets[id] then return false end

        push = push or function() return false end
        x = x or 0; y = y or 0; w = w or 50; h = h or 50 -- important variables

        draggable = draggable or {x = true, y = true}

        local self = {}

        local function slider(name, value, align)
            local new = ui.new_slider('CONFIG', 'Presets', id .. ':' .. name, 0, (align and scrH or scrW), value)
            ui.set_visible(new, wings.settings.dev)

            ui.set_callback(new, function()
                if not self or not self.current or not self.current[name] then return false end

                self.current[name] = ui.get(new)
            end)

            return new
        end

        local function line(x1, y1, x2, y2) renderer.line(x1, y1, x2, y2, 255, 255, 255, (self.alpha.addition or 0)) end

        self = {
            current = {x = x, y = y, w = w, h = h},
            animate = {x = x, y = y, w = w, h = h},
            
            alpha = {first = 0, second = 0, addition = 0},
            
            ui = {
                x = slider('x', x, false),
                --w = slider('w', w, false),

                y = slider('y', y, true),
                --h = slider('h', h, true),
            },

            paint = true, -- !!!
            snap = false, -- !!!
        }

        local input = {} -- mouse

        local alpha_markup = {
            first = 0, second = 0, addition = 0 -- targets       
        }

        function self.push()
            if not self or not self.current or not self.animate or not self.alpha then return false end -- prevention

            -- current -> animate
            for cord, value in pairs(self.current) do
                self.animate[cord] = math.lerp(globals.frametime() * 10, self.animate[cord], value)
            end
        
            -- alpha
            for state, value in pairs(self.alpha) do
                local markup = alpha_markup[state] or alpha_markup.first

                self.alpha[state] = math.lerp(globals.frametime() * 15, value, markup)
                self.alpha[state] = math.clamp(self.alpha[state], 0, 255) -- For some reason while loading in map or while low fps, alpha starts blinking.
            end

            if not self.paint or not ui.is_menu_open() then 
                alpha_markup = {
                    first = 0, second = 0, addition = 0    
                }
            else
                alpha_markup = {
                    first = (input.state and 120 or 70),
                    second = (input.state and 210 or 170),
                    addition = 0,
                }
            end

            -- disable draw
            if not self.paint and self.alpha.first < 5 then return false end -- :(

            self.snap = tooltip and not client.key_state(0x10)
            alpha_markup.addition = (input.state and self.snap) and 150 or 0

            local status, err = pcall(push, self) -- handling push function
            if not status then assert('Error: ' .. err) end

            -- rendering widget base
            local base, raw = self.animate, self.current
            
            --[[
                Snap to lines works weird with preventing floating point :)

            for cord, value in pairs(base) do base[cord] = math.floor(value) end -- preventing floating point
            for cord, value in pairs(raw) do raw[cord] = math.floor(value) end 
            --]]

            render.rectangle(0, 0, scrW, scrH, 0, 0, 0, self.alpha.addition, 0)
            render.rectangle(base.x, base.y, base.w, base.h, 165, 165, 165, self.alpha.first, 8)

            local padding = -2
            render.rectangle(base.x - padding / 2, base.y - padding / 2, base.w + padding, base.h + padding, 25, 25, 25, self.alpha.second, 8)
            
            -- mouse
            if mouse.held() and (mouse.inbounds(raw.x, raw.y, raw.w, raw.h) or input.state) and (not widgets.dragging or widgets.dragging == id) then
                input.state = true

                widgets.dragging = id

                if not input.current then 
                    input.current = {}
                
                    input.current.widget = {x = raw.x, y = raw.y}

                    local mX, mY = ui.mouse_position()
                    input.current.mouse = {x = mX, y = mY}
                end
                local x, y = mouse.calc(input.current.widget.x, input.current.widget.y, input.current.mouse.x, input.current.mouse.y, raw.w, raw.h)

                -- snap to lines
                local scales = {
                    x = x,
                    y = y
                }

                if self.snap then
                    for scale, magnet in pairs(mouse_magnet) do
                        if not draggable[scale] then goto continue end
                        
                        for i, value in ipairs(magnet) do
                            if math.abs(scales[scale] - value) <= self.current[scale == 'x' and 'w' or 'h'] then
                                scales[scale] = value - self.current[scale == 'x' and 'w' or 'h'] / 2
                                if scales[scale] < 0 then scales[scale] = value end
                                if scales[scale] > (scale == 'x' and scrW - self.current.w or scrH - self.current.h) then scales[scale] = value - self.current[scale == 'x' and 'w' or 'h']  end
                            end
                        end
                        
                        ::continue::
                    end
                end

                if draggable.x then ui.set(self.ui.x, scales.x) end
                if draggable.y then ui.set(self.ui.y, scales.y) end
            elseif widgets.dragging == id then
                widgets.dragging = nil
                input = {}
            end

            if self.snap and self.alpha.addition > 5 then
                for scale, magnet in pairs(mouse_magnet) do
                    if not draggable[scale] then goto continue end
                    
                    for i, value in pairs(magnet) do
                        local style = (scale == 'y' and {0, value, scrW, value} or {value, 0, value, scrH})
                        line(unpack(style))
                    end
               
                    ::continue::
                end
            end
        end

        widgets.widgets[id] = self
        
        return self
    end

    wings.hooks.paint_ui.widgets_handler = function()
        for id, self in pairs(widgets.widgets) do
            local status, err = pcall(self.push)
            if not status then assert('Error: ' .. err) end
        end 
    end

    print(wings.color.green .. '» ' .. wings.color.base .. 'Widgets', wasted())
end

local tabs do
    local active_tab, combo, tabslist = nil, nil, {}
    
    tabs = {}
    tabs.__index = tabs
    
    tabs.tabs = {}
    
    function tabs.new(name)
        if not name then return false end
        name = tostring(name)
        
        local prev_value
        
        if combo then prev_value = ui.get(combo); ui.set_visible(combo, false) end
        
        table.insert(tabslist, name)
        
        combo = ui.new_combobox('Lua', 'B', wings.color.base .. 'FF Wings' .. wings.color.gray ..'FF ~ ' .. string.split(wings.settings.build, ' ')[1], unpack(tabslist))
        if prev_value then ui.set(combo, prev_value) end
        
        tabs.tabs[name] = {}
        
        local self = setmetatable({tab = name, elements = tabs.tabs[name]}, tabs)
        
        return self
    end
    
    function tabs:add(element, requirement)
        if type(element) == 'table' then
            for i, v in ipairs(element) do
                self:add(v, requirement)
            end

            return true
        end

        if not element or not self or type(self) ~= 'table' then return false end
        requirement = requirement or function() return true end
        
        table.insert(self.elements, {element, requirement})
        return self
    end
    
    wings.hooks.paint_ui.tabs_handler = function()
        if not ui.is_menu_open() then return false end
        
        for i,v in pairs(tabs.tabs) do
            if type(v) ~= 'table' then assert('Tab ' .. tostring(i) .. ' not table') goto continue end
            
            for _, element in ipairs(v) do
                if type(element) ~= 'table' then assert('Element ' .. tostring(_) .. ' not table!') goto continue end
                if not element[1] or type(element[2]) ~= 'function' then assert('One of elements error') goto continue end
                
                local success, err = pcall(function() ui.set_visible(element[1], element[2]() and ui.get(combo) == i) end)
                if not success then assert(err) end
                
                ::continue::
            end
            
            ::continue::
        end
    end

    print(wings.color.green .. '» ' .. wings.color.base .. 'Tabs', wasted())
end

--#endregion

--#region NOTIFICATIONS

local notifications do
    notifications = {}
    notifications.notifications = {}

    local styles = {
        log_emberlash = function(self)
            local types = {
                hit = {png = 'checkmark', color = {r = 150, g = 238, b = 73}},
                miss = {png = 'dismiss', color = {r = 238, g = 73, b = 115}},
                fire = {png = 'warning', color = {r = 238, g = 131, b = 71}},
            }

            self.data = self.data or {}
            local scrW, scrH = client.screen_size()
    
            if not self.data.loaded then
                self.data = {
                    loaded = true,
                    y = scrH + 90,
                    x = scrW / 2,
                    box = { size = 0 },
                    text = { w = 1, x = scrW / 2, alpha = 0 },
                    start = client.timestamp(),
                    stop = false
                }
            end
    
            local box = { size = 40 }
            local y = self.meta.widget.animate.y + self.meta.widget.animate.h / 2 - 15
            self.h = 60
    
            local index = table.find(notifications.notifications, self)
            for i, v in pairs(notifications.notifications) do
                if i >= index then break end
                y = y - v.h
            end
    
            
            if self.data.box.size < 5 and self.data.stop then self.delete(self) assert('Notification (delete)') return false end

            if client.timestamp() - self.data.start > self.timeout * 1000 and not self.data.stop then self.data.stop = true end
            self.data.show_box = self.data.y <= y + 1 or self.data.stop
            self.data.box.size = math.lerp(globals.frametime() * 10, self.data.box.size, self.data.stop and 0 or box.size)
            self.data.y = math.lerp(globals.frametime() * 10, self.data.y, self.data.stop and scrH + 90 or y)
    
            self.data.x = math.lerp(globals.frametime() * 10, self.data.x, self.data.stop and scrW /2 or scrW / 2 - self.data.box.size / 2 - self.data.text.w / 2 - (self.data.show_box and 40 or 0))
            local w = self.data.box.size
            local h = self.data.box.size
            local target = types[self.meta.type]
    
            if self.data.show_box then
                local tW, tH = renderer.measure_text('b', self.text)

                local w, h = tW + 16, 30

                self.data.text.w = math.lerp(globals.frametime() * 10, self.data.text.w, self.data.stop and 0 or w)
                self.data.text.x = math.lerp(globals.frametime() * 10, self.data.text.x, scrW / 2 - self.data.text.w / 2)
                self.data.text.alpha = math.lerp(globals.frametime() * 10, self.data.text.alpha, 255)

                local x, y, r, g, b, a = math.floor(self.data.text.x - 2), math.floor(self.data.y - h / 2 + self.data.box.size / 2 - 2), target.color.r, target.color.g, target.color.b, 255
                local w, h = math.floor(self.data.text.w + 4), math.floor(h + 4)

                local radius = 4

                renderer.rectangle(x + radius, y + h - radius, w - 2 * radius, radius, r, g, b, a)
                renderer.gradient(x, y, w, h - radius, 0, 0, 0, 0, r, g, b, a, false)

                renderer.circle(x + radius, y + h - radius, r, g, b, a, radius, -90, 0.25) 
                renderer.circle(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25) 

                x, y, w, h = x + 2, y + 2, w - 4, h - 4

                render.rectangle(x, y, w, h, 15, 15, 15, self.data.text.alpha, 5)
                renderer.text(x + w / 2, y + h / 2, 255, 255, 255, 255, 'bc', math.max(1, w - 10), self.text)
            end


            local x, y, r, g, b, a = math.floor(self.data.x - 2), math.floor(self.data.y - 2), target.color.r, target.color.g, target.color.b, 255
            local w, h = math.floor(w + 4), math.floor(h + 4)

            local radius = 4

            renderer.rectangle(x + radius, y + h - radius, w - 2 * radius, radius, r, g, b, a)
            renderer.gradient(x, y, w, h - radius, 0, 0, 0, 0, r, g, b, a, false)

            renderer.circle(x + radius, y + h - radius, r, g, b, a, radius, -90, 0.25) 
            renderer.circle(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25) 

            x, y, w, h = x + 2, y + 2, w - 4, h - 4

            render.rectangle(x, y, w, h, 15, 15, 15, 255, radius)
            if type(png[target.png]) == 'number' then 
                renderer.texture(png[target.png], x - 24 / 2 + w / 2, y - 24 / 2 + h / 2, 24, 24, r, g, b, 255, 'f') 
            end
        end,
        log_wings = function(self)
            self.data = self.data or {}
            local scrW, scrH = client.screen_size()
    
            if not self.data.loaded then
                self.data = {
                    loaded = true,
                    y = scrH + 90,
                    w = 1,
                    start = client.timestamp(),
                    stop = false
                }
            end
    
            local y = self.meta.widget.animate.y + self.meta.widget.animate.h / 2 - 15
            self.h = 50

            if client.timestamp() - self.data.start > self.timeout * 1000 and not self.data.stop then self.data.stop = true end

            local index = table.find(notifications.notifications, self)
            for i, v in pairs(notifications.notifications) do
                if i >= index then break end
                y = y - v.h
            end
    
            local tW, tH = renderer.measure_text('b', self.text)
            local w, h = tW + 30, 30

            self.data.w = math.lerp(globals.frametime() * 10, self.data.w, self.data.stop and 0 or w)
            self.data.y = math.lerp(globals.frametime() * 10, self.data.y, self.data.stop and scrH + 90 or y)

            if self.data.stop and self.data.w <= 5 then self.delete(self) return false end

            render.rectangle(scrW / 2 - self.data.w / 2 - 1, self.data.y - 1, self.data.w + 2, h + 2, 170, 170, 170, 70, 4)
            render.rectangle(scrW / 2 - self.data.w / 2, self.data.y, self.data.w, h, 15, 15, 15, 255, 4)
            renderer.text(scrW / 2, self.data.y + h / 2, 255, 255, 255, 255, 'bc', math.max(1, self.data.w - 10), self.text)
        end,
        log_simple = function(self)
            self.data = self.data or {}
            local scrW, scrH = client.screen_size()
    
            if not self.data.loaded then
                self.data = {
                    loaded = true,
                    y = scrH + 90,
                    start = client.timestamp(),
                    stop = false
                }
            end
    
            local y = self.meta.widget.animate.y + self.meta.widget.animate.h / 2 - 15
            self.h = 40

            if client.timestamp() - self.data.start > self.timeout * 1000 and not self.data.stop then self.data.stop = true end

            local index = table.find(notifications.notifications, self)
            for i, v in pairs(notifications.notifications) do
                if i >= index then break end
                y = y - v.h
            end
    
            local tW, tH = renderer.measure_text('', self.text)

            self.data.y = math.lerp(globals.frametime() * 10, self.data.y, self.data.stop and scrH + 90 or y)

            if self.data.stop and self.data.y < scrH - 60 then self.delete(self) return false end
            local x = scrW / 2 - tW / 2
            local step = 5

            local types = {
                hit = {135, 99, 255},
                miss = {255, 99, 167},
                fire = {255, 159, 99}
            }

            local accent = types[self.meta.type or 'hit'] or types.hit

            render.glow(x - step / 2, self.data.y - step / 2, tW + step * 2, tH + step * 1.5, accent[1], accent[2], accent[3], 10, nil, 1, 10, {padding = -5, alpha = 1})
            renderer.text(x, self.data.y, 255, 255, 255, 255, '', 0, self.text)
        end,
    }

    notifications.styles = styles
    

    function notifications.new(text, style, timeout, meta)
        if not styles[style] then 
            print('Notifications: Invalid style!') 
            return false 
        end

        local object = {
            style = styles[style],
            text = text,
            timeout = timeout or 5,
            meta = meta,
        }

        function object.delete(self)
            local index = table.find(notifications.notifications, self)
            if index then
                table.remove(notifications.notifications, index)
            end
        end

        if #notifications.notifications > 5 then
            for i, v in pairs(notifications.notifications) do
                if v.data and not v.data.stop then v.data.stop = true break end
            end
        end

        table.insert(notifications.notifications, object)
    end

    wings.hooks.paint_ui.notifications_handler = function()
        for _, v in pairs(notifications.notifications) do 
            v.style(v) 
        end
    end
end


--#endregion

--#region DOX
local function dox_proceed(ent)
    local name, steam = entity.get_player_name(ent), entity.get_steam64(ent)
    --if ent == entity.get_local_player() then return false end
    if not name or not steam then return false end
    local time = client.unix_time()

    local dbase = db.dox[tostring(steam)] or {}
    
    dbase.history_names = dbase.history_names or {}
    dbase.first_time = dbase.first_time or time

    dbase.history_names[name] = dbase.history_names[name] or time

    db.dox[tostring(steam)] = dbase
end

wings.hooks.player_connect_full.dox = function(e)
    local ent = client.userid_to_entindex(e.userid)
    if ent == entity.get_local_player() then for i = 1, globals.maxplayers() do dox_proceed(i) end return false end 
    dox_proceed(ent)
end

wings.hooks.player_changename.dox = function(e)
    local ent = client.userid_to_entindex(e.userid)
    dox_proceed(ent)
end

for i = 1, globals.maxplayers() do dox_proceed(i) end
--#endregion

--#region SETTINGS
local aa = tabs.new(' Anti-Aim')
local rage_tab = tabs.new(' Rage')
local visuals = tabs.new(' Visuals')
local buybot = tabs.new(' BuyBot')
local misc = tabs.new(' Miscellaneous')

local refs = {
    slowwalk = {ui.reference('AA', 'Other', 'Slow motion')},
    enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
    yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    pitch = {ui.reference('AA', 'Anti-aimbot angles', 'Pitch')},
    yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw')},
    body_yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
    yaw_jitter = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')},
    freestand = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
    freestand_byaw = ui.reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw'),
    roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
    edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    tp = {ui.reference('Visuals', 'Effects', 'Force third person (alive)')},
    hc = ui.reference('RAGE', 'Aimbot', 'Minimum hit chance'),
    dt = {ui.reference('RAGE', 'Aimbot', 'Double Tap')},
    osaa = {ui.reference('AA', 'Other', 'On shot anti-aim')}
}

--#region RAGE
local wings_rage = {}
rage_tab:add(ui.new_label('Lua', 'A', format('Wings', ' Rage')))

--#region DT Release
local dt_uncharge = ui.new_checkbox('Lua', 'A', ' DT Release')
local dt_hotkey = ui.new_hotkey('Lua', 'A', 'Release DT', true)
rage_tab:add({dt_uncharge, dt_hotkey})

local dt = {ui.reference('RAGE', 'Aimbot', 'Double Tap')}

local dt_methods = {
    Simple = {
        uncharge = function(e, tick, def)
            if def then e.force_defensive = 1 end
            ui.set(dt[1], false) 
        end,

        release = function()
            ui.set(dt[1], true)
        end,

        force_defensive = true,
    },
    Tick = {
        uncharge = function(e, tick)
            e.force_defensive = 1
            if wings_rage.ticks_diff == tick then
                ui.set(dt[1], false)
            end 
        end,
            
        release = function()
            ui.set(dt[1], true)
        end,

        tick = true,
    }
}

local un_methods = {}
for i, v in pairs(dt_methods) do table.insert(un_methods, i) end
local dtu_tick = ui.new_slider('Lua', 'A', format(' DT Release', 'Uncharge tick'), -12, 1, -4)
local dtu_force_def = ui.new_checkbox('Lua', 'A', format(' DT Release', 'Force defensive'))
local dtu_method = ui.new_combobox('Lua', 'A', format(' DT Release', 'Method'), unpack(un_methods))

rage_tab:add(dtu_method, function() return ui.get(dt_uncharge) end)
rage_tab:add(dtu_tick, function() return ui.get(dt_uncharge) and dt_methods[ui.get(dtu_method)].tick end)
rage_tab:add(dtu_force_def, function() return ui.get(dt_uncharge) and dt_methods[ui.get(dtu_method)].force_defensive end)
rage_tab:add(ui.new_label('Lua', 'A', ' In-Dev Warning!'), function() return ui.get(dt_uncharge) end)

local disable, last_weapon = {}, nil
local dt_state, decline = false, false
wings.hooks.run_command.wings_rage = function(e) wings_rage.current = e.command_number end

wings.hooks.predict_command.wings_rage = function(e)
    if e.command_number == wings_rage.current then
        wings_rage.current = nil

        local ticks = entity.get_prop(entity.get_local_player(), 'm_nTickBase')

        if wings_rage.tb_max ~= nil then
            wings_rage.ticks_diff = ticks - wings_rage.tb_max
        end
        wings_rage.tb_max = math.max(ticks, wings_rage.tb_max or 0)
    end
end

wings.hooks.setup_command.dt_release = function(e)
    local weapon = entity.get_player_weapon(entity.get_local_player())
    for i, v in pairs(disable) do if i == weapon then ui.set(dt[1], true) end end
    if (not ui.get(dt_uncharge) or not ui.get(dt_hotkey)) and not (dt_state and decline) then decline = true wings.hooks.paint.dt_release = nil; el = nil return false end
    if not (ui.get(dt[1]) and ui.get(dt[2])) and not dt_state then wings.hooks.paint.dt_release = nil; el = nil return false end

    local method = dt_methods[ui.get(dtu_method)]
    wings.hooks.paint.dt_release = function()
        if not entity.is_alive(entity.get_local_player()) then wings.hooks.paint.dt_release = nil; method.release(e, ui.get(dtu_tick)) return false end
        renderer.indicator(145, 135, 255, 255, ' DT Release (' .. ui.get(dtu_method) .. ')')
    end
    
    if weapon ~= last_weapon then disable[weapon] = true end
    

    last_weapon = weapon

    if not dt_state or not decline then
        dt_state = true
        decline = false
        method.uncharge(e, ui.get(dtu_tick), ui.get(dtu_force_def))
    elseif decline then
        dt_state = false
        method.release(e)
    end
end
--#endregion

--#region IN-AIR HC
ui.new_label('RAGE', 'Aimbot', format('Wings', ' Rage'))

local iah = ui.new_checkbox('RAGE', 'Aimbot', ' In-Air')
local def_hc = ui.new_slider('RAGE', 'Aimbot', format(' In-Air', 'Default HC'), 0, 100, ui.get(refs.hc), true, '%', 1, {[0] = 'Off'})
local ahc = ui.new_slider('RAGE', 'Aimbot', format(' In-Air', 'HC'), 0, 100, 0, true, '%', 1, {[0] = 'Off'})
ui.set_visible(ahc, false); ui.set_visible(def_hc, false)
ui.set_callback(iah, function() ui.set_visible(ahc, ui.get(iah)) ui.set_visible(def_hc, ui.get(iah)) end)


wings.hooks.setup_command.in_air_hc = function(e)
    if not ui.get(iah) then return false end
    local jumping = e.in_jump ~= 0 or entity.get_prop(entity.get_local_player(), 'm_hGroundEntity') ~= 0

    ui.set(refs.hc, (jumping and ui.get(ahc) or ui.get(def_hc)))
end
--#endregion

--#endregion

--#region VISUALS
visuals:add(ui.new_label('Lua', 'A', format('Wings', ' Visuals')))

--#region LOGS
local scrW, scrH = client.screen_size()

local styles = {}
for i, v in pairs(notifications.styles) do 
    if string.find(i, '^log_') then 
        local style = string.lower(string.sub(i, 5))
        style = style:sub(1, 1):upper() .. style:sub(2)

        table.insert(styles, style) 
    end 
end

local logs = ui.new_checkbox('Lua', 'A', ' Logs')
local hl_widget = widgets.new('hitlog_widget', nil, scrW / 2 - 350 / 2, scrH - 160, 350, 150, {y = true}, true, true)
local output = ui.new_multiselect('Lua', 'A', format(' Logs', 'Output'), 'On-Screen', 'In Console')
local screen_style = ui.new_combobox('Lua', 'A', format(' Logs', 'Style'), unpack(styles))

hl_widget.paint = false

visuals:add(logs)
visuals:add(output, function() return ui.get(logs) end)
visuals:add(screen_style, function() return table.find(ui.get(output), 'On-Screen') and ui.get(logs) end)

ui.set_callback(output, function()
    hl_widget.paint = table.find(ui.get(output), 'On-Screen') and ui.get(logs)
end)

local hg = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
ui.set_callback(logs, function()
    local v, aim = ui.get(logs), {}
    hl_widget.paint = v and table.find(ui.get(output), 'On-Screen')

    if v then
        wings.hooks.aim_fire.logs_handler = function(e) e.bt = globals.tickcount() - e.tick aim[e.id] = e end

        wings.hooks.aim_hit.logs_handler = function(e)
            if not aim[e.id] then assert('No shot data.') return false end
            e.shot = aim[e.id]

            local mm = e.hitgroup ~= e.shot.hitgroup or (e.damage ~= e.shot.damage and e.damage < e.shot.damage and e.damage < 100 and math.abs(e.shot.damage - e.damage) > 10)
            local accent, gray = wings.color.logs.hit[mm and 'mismatch' or 'succesful'], wings.color.gray

            if table.find(ui.get(output), 'In Console') then
                print(
                    gray .. (mm and 'Mismatched ' or 'Hit ' )
                    .. accent .. entity.get_player_name(e.target) .. 
                    gray .. '\'s ' .. accent .. hg[e.hitgroup + 1] .. 
                    gray .. '(' .. accent .. string.format('%.2f', e.shot.hit_chance) .. gray .. 
                    '%) for ' .. accent .. e.damage .. gray .. 'hp ' 
                    .. (mm and (accent .. '(' .. e.shot.damage .. ' - ' .. hg[e.shot.hitgroup + 1] .. ') ' 
                    .. gray) or '')  
                    .. '| bt: ' .. accent .. e.shot.bt .. gray .. 't'
                )
            end

            if table.find(ui.get(output), 'On-Screen') then 
                notifications.new(
                    accent .. 'FF ' ..
                    gray .. (mm and 'FFMismatched ' or 'FFHit ' )
                    .. accent .. 'FF' .. entity.get_player_name(e.target) .. 
                    gray .. 'FF\'s ' .. accent .. 'FF' .. hg[e.hitgroup + 1] ..
                    gray .. 'FF for ' .. accent .. 'FF' .. e.damage .. gray .. 'FFHP',
                    'log_' .. ui.get(screen_style):lower(), 5, {type = 'hit', widget = hl_widget}) 
            end
        end

        wings.hooks.aim_miss.logs_handler = function(e) 
            if not aim[e.id] then assert('No shot data.') return false end
            e.shot = aim[e.id]

            local accent, gray = wings.color.logs.miss[e.reason] or wings.color.logs.miss.other, wings.color.gray

            if table.find(ui.get(output), 'In Console') then
                print(
                    gray .. 'Missed '
                    .. accent .. entity.get_player_name(e.target) .. 
                    gray .. '\'s ' .. accent .. hg[e.hitgroup + 1] .. 
                    gray .. '(' .. accent .. string.format('%.2f', e.shot.hit_chance) .. gray .. 
                    '%) - ' .. accent .. e.shot.damage .. gray .. 'hp ' 
                    .. '| bt: ' .. accent .. e.shot.bt .. gray .. 't'
                    .. ', reason: ' .. accent .. e.reason
                )
            end

            if table.find(ui.get(output), 'On-Screen') then 
                notifications.new(
                    accent .. 'FF ' ..
                    gray .. 'FFMissed '
                    .. accent .. 'FF' .. entity.get_player_name(e.target) .. 
                    gray .. 'FF\'s ' .. accent .. 'FF' .. hg[e.hitgroup + 1] ..
                    gray .. 'FF for ' .. accent .. 'FF' .. e.shot.damage .. gray .. 'FFHP',
                    'log_' .. ui.get(screen_style):lower(), 5, {type = 'miss', widget = hl_widget}) 
            end
        end
    else
        wings.hooks.aim_fire.logs_handler = nil
        wings.hooks.aim_hit.logs_handler = nil
        wings.hooks.aim_miss.logs_handler = nil
    end
end)
--#endregion

--#region FOG
local fog = {
	entity = entity.get_all('CFogController')[1],
	color = 0,
	start = 0,
	['end'] = 0,
	density = 0
}

local fog_enable = ui.new_checkbox('Lua', 'A', ' Fog')
local fog_color = ui.new_color_picker('Lua', 'A', format(' Fog', 'Color'), 0, 0, 0, 255)
local fog_density = ui.new_slider('Lua', 'A', format(' Fog', 'Density'), 0, 100, 0, true, '%')
local fog_start = ui.new_slider('Lua', 'A', format(' Fog', 'Start Distance'), 0, 16384, 0, true)
local fog_end = ui.new_slider('Lua', 'A', format(' Fog', 'End Distance'), 0, 16384, 0, true)

visuals:add(fog_enable)
visuals:add({fog_color, fog_density, fog_start, fog_end}, function() return ui.get(fog_enable) end)

local function ffog_start() local v = ui.get(fog_start); fog.start = v; entity.set_prop(fog.entity, 'm_fog.start', v); entity.set_prop(entity.get_local_player(), 'm_skybox3d.fog.start', v) end
local function ffog_end() local v = ui.get(fog_end); fog['end'] = v; entity.set_prop(fog.entity, 'm_fog.end', v); entity.set_prop(entity.get_local_player(), 'm_skybox3d.fog.end', v) end
local function ffog_density() 	local v = ui.get(fog_density) / 100; fog.density = v; entity.set_prop(fog.entity, 'm_fog.maxdensity', v); entity.set_prop(entity.get_local_player(), 'm_skybox3d.fog.maxdensity', v) end
local function ffog_color() local r, g, b = ui.get(fog_color); local color32 = color32.rgb_to_int(r, g, b); fog.color = color32; entity.set_prop(fog.entity, 'm_fog.colorPrimary', color32); entity.set_prop(entity.get_local_player(), 'm_skybox3d.fog.colorPrimary', color32) end
local function ffog_enable() local v = ui.get(fog_enable) and 1 or 0; entity.set_prop(fog.entity, 'm_fog.enable', v); entity.set_prop(entity.get_local_player(), 'm_skybox3d.fog.enable', v) end

ui.set_callback(fog_start, ffog_start)
ui.set_callback(fog_end, ffog_end)
ui.set_callback(fog_density, ffog_density)
ui.set_callback(fog_color, ffog_color)
ui.set_callback(fog_enable, ffog_enable)

ffog_enable(); ffog_start(); ffog_end(); ffog_density(); ffog_color()
--#endregion

--#region MINDMG INDICATOR
local md_indicator = ui.new_checkbox('Lua', 'A', ' Damage Override Indicator')
local md_default = ui.new_combobox('Lua', 'A', format(' Override', 'When no override'), '-', 'Hide', 'Alpha')
visuals:add(md_indicator)
visuals:add(md_default, function() return ui.get(md_indicator) end)

local dmg, dmg2 = ui.reference('RAGE', 'Aimbot', 'Minimum Damage override'), ui.reference('RAGE', 'Aimbot', 'Minimum Damage')

local scrW, scrH = client.screen_size()
local tW, tH = renderer.measure_text('b', '100')
local indicator_t, indicator_a = 0, 0

local indicator = widgets.new('mindmg_indicator', function(self)
    local e = self.animate

    local m, a = self.alpha.first * 2.5, 255
    local target = dmg2
    if ui.get(dmg) and ui.get(dmg + 1) then target = dmg + 2 end

    if target == dmg2 and ui.get(md_default) ~= '-' then
        if ui.get(md_default) == 'Hide' then 
            indicator_a = math.lerp(globals.frametime() * 10, indicator_a, m)
        else
            indicator_a = math.lerp(globals.frametime() * 10, indicator_a, 100)
        end
    else
        indicator_a = math.lerp(globals.frametime() * 10, indicator_a, 200 - m)
    end

    indicator_t = math.lerp(globals.frametime() * 10, indicator_t, ui.get(target))
    local t = math.floor(indicator_t + .5)
    renderer.text(e.x + e.w / 2, e.y + e.h / 2, 255, 255, 255, indicator_a, 'cb', e.w + 5, (t > 100 and '+' .. t - 100 or (t == 0 and '-' or t)))
end, scrW / 2 + 5, scrH / 2 - 20, tW + 20, tH + 20, nil, false, true)
indicator.paint = false

-- widgets.new(id, push, x, y, w, h, draggable, tooltip, lock_size)
ui.set_callback(md_indicator, function()
    indicator.paint = ui.get(md_indicator)
end)

--#endregion

--#region ZOOM
local zoom = ui.new_checkbox('Lua', 'B', ' Zoom')
visuals:add(zoom)

visuals:add(zoom_effect, function() return ui.get(zoom) end)
visuals:add({zoom_effColor, zoom_effOffset, zoom_effScale}, function() return ui.get(zoom) and ui.get(zoom_effect) end)

local tp_fov = ui.new_slider('Lua', 'A', ' Third-person Effect', -15, 15, 10)
visuals:add(tp_fov)

local zoom_thirdpreson = ui.new_checkbox('Lua', 'B', format(' Zoom', 'Effect'))
local zoom_tpOffset = ui.new_slider('Lua', 'B', format(' Zoom', 'Effect', 'Offset'), -15, 15, 0)

visuals:add(zoom_thirdpreson, function() return ui.get(zoom) end)
visuals:add(zoom_tpOffset, function() return ui.get(zoom) and ui.get(zoom_thirdpreson) end)

local tpOffset = 0
local tpAnim = 0

wings.hooks.override_view.zoom = function(e)
    local lp = entity.get_local_player()
    local weap = entity.get_player_weapon(lp)
    if not weap then return false end

    local scoped, scope_lvl = entity.get_prop(lp, 'm_bIsScoped') == 1, entity.get_prop(weap, 'm_zoomLevel')
    local tp_off = ui.get(zoom_tpOffset)

    tpAnim = math.lerp(globals.frametime() * 10, tpAnim, (ui.get(refs.tp[1]) and ui.get(refs.tp[2])) and ui.get(tp_fov) or 0)
    tpOffset = math.lerp(globals.frametime() * 10, tpOffset, ((ui.get(zoom_thirdpreson) and scoped) and tp_off * scope_lvl or 0))
    e.fov = e.fov - tpOffset + tpAnim
end
--#endregion

--#region VGUI
visuals:add(ui.new_label('LUA', 'B', ' VGUI color'))
local color_console = ui.new_color_picker('LUA', 'B', 'vgui_color', 25, 25, 25, 100)
visuals:add(color_console)
local materials = {'vgui_white', 'vgui/hud/800corner1', 'vgui/hud/800corner2', 'vgui/hud/800corner3', 'vgui/hud/800corner4'}
local updated = false

ui.set_callback(color_console, function()
    updated = false

    local r, g, b, a = ui.get(color_console)

    for _, mat in pairs(materials) do
        local material = materialsystem.find_material(mat, true)

        if not material then return false end
        material:alpha_modulate(a)
        material:color_modulate(r, g, b)
    end

    updated = true
end)

wings.hooks.paint_ui.vgui = function()
    if updated then return false end
    local r, g, b, a = ui.get(color_console)

    for _, mat in pairs(materials) do
        local material = materialsystem.find_material(mat, true)

        if not material then return false end
        material:alpha_modulate(a)
        material:color_modulate(r, g, b)
    end

    updated = true
end
--#endregion

--#region SPECTATORS
local spec = ui.new_checkbox('Lua', 'A', ' Spectators list')
visuals:add(spec)

local w, h = 250, 200
local x, y = scrW - w - 90, scrH / 2 - h / 2

local spec_data, loaded_avatars = {}, {}

wings.hooks.player_connect_full.spectators = function(e)
    local ent = client.userid_to_entindex(e.userid)

    if ent == entity.get_local_player() then loaded_avatars = {} end
    loaded_avatars[ent] = nil
end

wings.hooks.client_disconnect.spectators = function()
    loaded_avatars = {}
end

local spec_widget = widgets.new('spectators_list', function(self)
    local e = self.animate

    local lp = entity.get_local_player()

    local spectators, target = {}, lp -- Solus V2

    for i = 1, globals.maxplayers() do
        if entity.get_classname(i) == 'CCSPlayer' then
            local mode = entity.get_prop(i, 'm_iObserverMode')
            local targ = entity.get_prop(i, 'm_hObserverTarget')
            
            if targ and not entity.is_alive(i) and (mode == 4 or mode == 5) then
                spectators[targ] = spectators[targ] or {}
                target = (i == lp) and targ or target

                table.insert(spectators[targ], i)
            end
        end
    end

    for i, v in pairs(spectators) do
        for _, spec in pairs(v) do
            local steam = entity.get_steam64(spec)
            local avatar = images.get_steam_avatar(steam)

            spec_data[spec] = (not spec_data[spec] or target ~= i) and {
                id = spec,
                lerps = {},
                avatar = loaded_avatars[steam] or false,
            } or spec_data[spec]

            if not spec_data[spec].avatar and steam and avatar then
                spec_data[spec].avatar = {texture = renderer.load_rgba(avatar.contents, avatar.width, avatar.height), avatar = avatar}
            end

        end
    end

    if not spectators or not target or not spectators[target] then return false end

    for _, spec in pairs(spectators[target]) do
        local data = spec_data[spec]
        
        local name = entity.get_player_name(data.id)
        local tW, tH = renderer.measure_text('b', name)
        
        local w, h = tW + 10, tH + 10
        local base_y = e.y + e.h / 2
        
        local native, padding = _ - 1, 5
        local offset = (#spectators[target] * (h + padding / 2)) / 2 - (h * native) - (padding * native)
        local invert = e.x > scrW / 2 - e.w / 2
        
        --data.lerps.full_alpha = data.lerps.full_alpha or 0
        --data.lerps.alpha = data.lerps.alpha or 0
        --data.lerps.offset_y = data.lerps.offset_y or 0
        --data.lerps.offset_x = data.lerps.offset_x or 0
        --data.lerps.width = data.lerps.width or 0

        data.lerps.offset_y = math.lerp(globals.frametime() * 10, data.lerps.offset_y, offset)
        data.lerps.offset_x = math.lerp(globals.frametime() * 10, data.lerps.offset_x, invert and 40 + w or e.w - 40)
        data.lerps.alpha = math.lerp(globals.frametime() * 15, data.lerps.alpha, 150)
        data.lerps.full_alpha = math.lerp(globals.frametime() * 15, data.lerps.full_alpha, 255)
        data.lerps.width = math.lerp(globals.frametime() * 20, data.lerps.width, w)

        local x, y, w = math.floor(data.lerps.offset_x), math.floor(data.lerps.offset_y), math.floor(data.lerps.width)
        
        render.rectangle(e.x + e.w - x, base_y - y, w, h, 100, 100, 100, data.lerps.alpha, 8)
        renderer.text(e.x + e.w - x + w / 2 - tW / 2, base_y - y + h / 2 - tH / 2, 255, 255, 255, data.lerps.full_alpha, 'b', w - 5, name)

        if data.avatar then
            renderer.texture(data.avatar.texture, e.x + e.w - (invert and 34 or e.w - 10), base_y - y + h / 2 - 24 / 2, 24, 24, 255, 255, 255, data.lerps.full_alpha, 'f')
        end
    end
    
end, x, y, w, h, nil, true, true)

spec_widget.paint = false

ui.set_callback(spec, function()
    spec_widget.paint = ui.get(spec)
    spectator_history = {}
end)

--#endregion

--#endregion

--#region BUYBOT
buybot:add(ui.new_label('Lua', 'A', format('Wings', ' BuyBot')))
local enabled = ui.new_checkbox('Lua', 'B', ' Enabled')
buybot:add(enabled)

local secondary = {'-', 'Desert Eagle / R8', 'Tec-9 / Five-Seven', 'Dual Berettas'}
local misc_bb = {'Vest', 'Tazer', 'Defuse Kit'}

local preset = ui.new_listbox('Lua', 'B', 'Round Preset', 'Pistol', 'Default')
buybot:add({preset, steal_mode}, function() return ui.get(enabled) end)

local assoc = {
    ['Desert Eagle / R8'] = 'deagle',
    ['Tec-9 / Five-Seven'] = 'tec9',
    ['Dual Berettas'] = 'elite',
    Vest = 'vesthelm',
    Tazer = 'taser',
    ['Defuse Kit'] = 'defuser',
    ['HE Grenade'] = 'hegrenade',
    ['Molotov'] = 'molotov',
    ['Smoke Grenade'] = 'smokegrenade',
    ['Flashbang'] = 'flashbang',
    ['SSG08'] = 'ssg08',
    ['AWP'] = 'awp',
    ['AUTOMATIC'] = 'scar20',
    ['AK47 / M4A4'] = 'ak47'
}

local presets = {
    [0] = {
        name = 'Pistol',
        money = 800,
        second = secondary,
        nades = {'HE Grenade', 'Molotov', 'Smoke Grenade'},
        misc = misc_bb,
        extra = {
            {
                display = 'Auto !r8',
                type = 'checkbox',
                deploy = function() client.exec('say_team ', '!r8') end
            }
        }
    },
    [1] = {
        name = 'Default',
        money = 800,
        mode = '>',
        main = {'-', 'SSG08', 'AWP', 'AUTOMATIC', 'AK47 / M4A4'},
        second = secondary,
        nades = {'HE Grenade', 'Molotov', 'Smoke Grenade', 'Flashbang'},
        misc = misc_bb
    }
}

for i, v in pairs(presets) do
    v.ui = v.ui or {}

    local main_weapon, secondary_weapon, misc_bb, nades, extra

    if v.main then main_weapon = ui.new_combobox('Lua', 'A', format(' BuyBot', v.name, 'Main Weapon'), unpack(v.main)) end
    if v.second then secondary_weapon = ui.new_combobox('Lua', 'A', format(' BuyBot', v.name, 'Secondary Weapon'), unpack(v.second)) end
    if v.misc then misc_bb = ui.new_multiselect('Lua', 'A', format(' BuyBot', v.name, 'Miscellaneous'), unpack(v.misc)) end
    if v.nades then nades = ui.new_multiselect('Lua', 'A', format(' BuyBot', v.name, 'Nades'), unpack(v.nades)) end
    extra = {}

    if v.extra then
        for _, d in pairs(v.extra) do table.insert(extra, {ui['new_' .. d.type]('Lua', 'A', format(' BuyBot', v.name, d.display), unpack(d.unpack or {})), d.deploy}) end
    end

    v.ui = {
        main = main_weapon,
        second = secondary_weapon,
        misc = misc_bb,
        nades = nades,
        delay = ui.new_slider('Lua', 'A', format(' BuyBot', v.name, 'Delay (ms)'), 0, 500, 200, true, '', 1, {[0] = 'No delay'}),
        extra = extra
    }

    for name, id in pairs(v.ui) do
        if type(id) == 'table' then
            for _, d in pairs(id) do
                buybot:add(d[1], function() return ui.get(preset) == i and ui.get(enabled) end)
            end
            goto continue
        end

        buybot:add(id, function() return ui.get(preset) == i and ui.get(enabled) end)

        ::continue::
    end
end

local function buy_everything(preset)
    local function buy(id)
        local val = ui.get(id)

        if type(val) == 'table' then                
            for i, v in pairs(val) do 
                local weapon = assoc[v]
               
                if weapon then client.exec('buy ', weapon) assert('+ ' .. weapon) else assert('No association for ' .. tostring(v)) end
            end
        else
            local weapon = assoc[val]
            if weapon then client.exec('buy ', weapon) assert('+ ' .. weapon) else assert('No association for ' .. tostring(val)) end
        end

    end

    if preset.extra then
        for i, v in pairs(preset.ui.extra) do
            if ui.get(v[1]) then pcall(v[2]) end
        end
    end

    if preset.main then buy(preset.ui.main) end
    if preset.second then buy(preset.ui.second) end
    if preset.misc then buy(preset.ui.misc) end
    if preset.nades then buy(preset.ui.nades) end
end

local function get_preset()
    local money = gsa.GetPlayerMoney(gsa.GetPlayerXuidStringFromEntIndex(entity.get_local_player()))

    local preset
    for i, v in pairs(presets) do
        if money == v.money and (not v.mode or v.mode == '=') then preset = v break end
        if money >= v.money and (v.mode and v.mode == '>') then preset = v end
        if money <= v.money and (v.mode and v.mode == '<') then preset = v end
    end
    return preset
end

ui.set_callback(enabled, function()
    local v = ui.get(enabled)

    if not v then wings.hooks.player_spawn.buybot = nil return false end

    wings.hooks.player_spawn.buybot = function(e) 
        if client.userid_to_entindex(e.userid) ~= entity.get_local_player() then return false end
        local preset = get_preset()

        client.delay_call(ui.get(preset.ui.delay) / 1000, function()
            preset = get_preset()

            if not preset then return false end

            buy_everything(preset)
        end) 
    end
end)

--#endregion

--#region MISCELLANEOUS
misc:add(ui.new_label('Lua', 'A', format('Wings', ' Miscellaneous')))
cvar.con_filter_text:set_string('[gamesense]')

local con_filter = ui.new_checkbox('Lua', 'A', 'Console Filter')
ui.set_callback(con_filter, function() cvar.con_filter_enable:set_raw_int(ui.get(con_filter) and 1 or 0) end)
misc:add(con_filter)

local crosshair = ui.new_checkbox('Lua', 'A', 'Hide crosshair')
ui.set_callback(crosshair, function() cvar.crosshair:set_raw_int(ui.get(crosshair) and 0 or 1) end)
misc:add(crosshair)

--#region CLAN-TAG SPAMMER
local clantag do
    wings.hooks.shutdown.clantag_disable = function() client.set_clan_tag('') end
    local checkbox = ui.new_checkbox('Lua', 'A', 'Clan-Tag Spammer')
    misc:add(checkbox)

    local animation = {'', '', '_', 'n_', 'ny_', 'nya_', 'nya _', 'nya :_', 'nya :3_', 'nya :3', 'nya :3', 'nya :3', 'nya :3_', 'nya :_', 'nya _', 'nya_', 'ny_', 'n_', '_'}

    ui.set_callback(checkbox, function()
        local v = ui.get(checkbox)

        if v then
            wings.hooks.net_update_start.clantag_handler = function()
                local time = math.floor(globals.curtime() - 2)
                local i = time % #animation + 1

                if i == last then return false end

                last = i
                client.set_clan_tag(animation[i])
            end
        else
            wings.hooks.net_update_start.clantag_handler = nil
            client.set_clan_tag('')
        end
    end)
end
--#endregion

--#region HITSOUND
local hitsound = ui.new_checkbox('Lua', 'B', ' HitSound')
misc:add(hitsound)

local sounds = filesystem.collect_mp3('csgo/sound/wings/*')
local psounds = sounds

sounds = #sounds < 1 and {'No sounds.'} or sounds
local select_sound = ui.new_combobox('Lua', 'B', format(' HitSound', 'Sound'), unpack(sounds))

misc:add({ui.new_label('Lua', 'B', 'csgo/sound/wings'), select_sound}, function() return ui.get(hitsound) end)

local function daemon()
    client.delay_call(3, daemon)

    local sounds = filesystem.collect_mp3('csgo/sound/wings/*')
    local mismatch = false

    for i, v in pairs(sounds) do if not table.find(psounds, v) then mismatch = true break end end
    for i, v in pairs(psounds) do if not table.find(sounds, v) then mismatch = true break end end

    if mismatch then assert('Sounds updated!') else return false end
    sounds = #sounds < 1 and {'No sounds.'} or sounds
    psounds = sounds

    ui.update(select_sound, sounds)
end

daemon()

ui.set_callback(hitsound, function()
    local v = ui.get(hitsound)

    wings.hooks.aim_hit.hitsound = not v and nil or function() playsound(client.create_interface('vguimatsurface.dll', 'VGUI_Surface031'), ffi.cast('const char*', 'wings/' .. ui.get(select_sound))) end
end)
--#endregion

--#region VIEWMODEL

local viewmodels = {
    {name = 'FOV', cvar = 'viewmodel_fov', range = 90},
    {name = 'Offset X', cvar = 'viewmodel_offset_x', range = 2000, scale = .01},
    {name = 'Offset Y', cvar = 'viewmodel_offset_y', range = 2000, scale = .01},
    {name = 'Offset Z', cvar = 'viewmodel_offset_z', range = 2000, scale = .01},
}

for i, v in pairs(viewmodels) do
    local slider = ui.new_slider('Lua', 'B', format('Viewmodel', v.name), -v.range, v.range, cvar[v.cvar]:get_float(), true, '', (v.scale or 1))

    ui.set_callback(slider, function()
        cvar[v.cvar]:set_raw_float(ui.get(slider) * (v.scale or 1))
    end)

    misc:add(slider)
end

--#endregion

--#region ASPECT-RATIO
local ratio_enabled = ui.new_checkbox('Lua', 'B', format('Aspect Ratio', 'Enabled'))
local ratio = ui.new_slider('Lua', 'B', format('Aspect Ratio', 'Ratio'), 0, 300, 0, true, '', .01, {[177] = '16:9', [161] = '16:10', [150] = '3:2', [133] = '4:3', [125] = '5:4'})

misc:add(ratio_enabled)
misc:add(ratio, function() return ui.get(ratio_enabled) end)

wings.hooks.paint.aspect_ratio = function()
    if not ui.get(ratio_enabled) then return false end
    local aspect = ui.get(ratio)
    if aspect == 0 then cvar.r_aspectratio:set_float(aspect) end

    cvar.r_aspectratio:set_float(math.lerp(globals.frametime() * 10, cvar.r_aspectratio:get_float(), aspect * .01))
end
--#endregion

--#endregion

--#region ANTI-AIM
local antiaim = {invert = false, tick = 0, multiway = {}}

aa:add(ui.new_label('Lua', 'A', format('Wings', ' Anti-Aim')))
aa:add({ui.new_label('Lua', 'B', ' Experimental feature.'), ui.new_label('Lua', 'B', '\n')})

local aa_enabled = ui.new_checkbox('Lua', 'B', format(' Anti-Aim', 'Enabled'))
local page = ui.new_combobox('Lua', 'B', format(' Anti-Aim', 'Page'), 'Other', 'Builder', 'Config')
aa:add(page, function() return ui.get(aa_enabled) end)
aa:add(aa_enabled)

local manuals = {
    {'Manual Left', -90},
    {'Manual Right', 90},
    {'Manual Forward', 180},
    {'Manual Reset', nil}
}

local config = {} 

--#region BUILDER
--#region STATES
local states = {
    {
        id = 'global',
        display = 'Global',
        priority = 0,
        check = function() return true end
    },
    {
        id = 'standing',
        display = 'Standing',
        priority = 1,
        check = function()
            return math.abs(entity.get_prop(entity.get_local_player(), 'm_vecVelocity')) <= 5
        end
    },
    {
        id = 'running',
        display = 'Running',
        priority = 2,
        check = function()
            return math.abs(entity.get_prop(entity.get_local_player(), 'm_vecVelocity')) >= 5
        end
    },
    {
        id = 'slowwalk',
        display = 'Slow-Walk',
        priority = 3,
        check = function()
            return ui.get(refs.slowwalk[1]) and ui.get(refs.slowwalk[2])
        end
    },
    {
        id = 'crouch',
        display = 'Crouching',
        priority = 4,
        check = function()
            return entity.get_prop(entity.get_local_player(), 'm_flDuckAmount') == 1
        end
    },
    {
        id = 'crouchmove',
        display = 'Crouch-Move',
        priority = 5,
        check = function()
            return entity.get_prop(entity.get_local_player(), 'm_flDuckAmount') == 1 and math.abs(entity.get_prop(entity.get_local_player(), 'm_vecVelocity')) >= 5
        end
    },
    {
        id = 'air',
        display = 'In-Air',
        priority = 6,
        check = function(e)
            return (e and e.in_jump ~= 0 or entity.get_prop(entity.get_local_player(), 'm_hGroundEntity') ~= 0)
        end
    },
    {
        id = 'aircrouch',
        display = 'Air-Crouch',
        priority = 7,
        check = function(e)
            return (e and e.in_jump ~= 0 or entity.get_prop(entity.get_local_player(), 'm_hGroundEntity') ~= 0) and entity.get_prop(entity.get_local_player(), 'm_flDuckAmount') == 1
        end
    }
}
--#endregion

local comp_states = {}; for i, v in pairs(states) do table.insert(comp_states, v.display) end
local state = ui.new_combobox('Lua', 'B', format(' Anti-Aim', 'Builder', 'State'), unpack(comp_states))
aa:add(state, function() return ui.get(page) == 'Builder' and ui.get(aa_enabled) end)

--#region UI
local ui_map = {

    {
        id = 'left',
        display = format(' Anti-Aim', '%s', '[L] Offset'),
        type = 'slider',
        unpack = {-179, 179, 0, true, '°'},
        update = function(self, e, state)
            if e.inv or ui.get(state.ui.yaw_jitter.id) == 'Multi-Ways' then return false end
            ui.set(refs.yaw[2], ui.get(self.id))
        end
    },

    {
        id = 'right',
        display = format(' Anti-Aim', '%s', '[R] Offset'),
        type = 'slider',
        unpack = {-179, 179, 0, true, '°'},
        update = function(self, e, state)
            if not e.inv or ui.get(state.ui.yaw_jitter.id) == 'Multi-Ways' then return false end
            ui.set(refs.yaw[2], ui.get(self.id))
        end
    },

    {
        id = 'pitch',
        display = format(' Anti-Aim', '%s', 'Pitch'),
        type = 'combobox',
        unpack = {'Off', 'Up', 'Minimal', 'Random', 'Custom'},
        update = function(self)
            if antiaim.defensive and antiaim.defensive.pitch then return false end

            local pitchs = {
                Off = 'Off',

                Up = 'Up',
                Minimal = 'Minimal',
                Random = 'Random',
                Custom = 'Custom'
            }

            local pitch = pitchs[ui.get(self.id)]
            if type(pitch) == 'function' then pitch = pitch() end

            ui.set(refs.pitch[1], pitch) 
        end
    },

    {
        id = 'pitch_slider',
        display = '\n %s pitch_slider',
        type = 'slider',
        unpack = {-89, 89, 0, true},
        update = function(self)
            if antiaim.defensive and antiaim.defensive.pitch then return false end
            ui.set(refs.pitch[2], ui.get(self.id))
        end,
        depency = function(v)
            return ui.get(v.pitch.id) == 'Custom'
        end
    },

    {
        id = 'yaw_jitter',
        display = format(' Anti-Aim', '%s', 'Yaw Jitter'),
        type = 'combobox',
        unpack = {'Off', 'Offset', 'Multi-Ways', 'Center (Skeet)', 'Random (Skeet)', 'Skitter (Skeet)'},
        update = function(self)
            if antiaim.defensive and antiaim.defensive.yaw then return false end
            local jitters = {
                Off = 'Off',

                Offset = 'Offset',
                ['Center (Skeet)'] = 'Center',
                ['Random (Skeet)'] = 'Random',
                ['Skitter (Skeet)'] = 'Skitter',

                ['Multi-Ways'] = 'Off'
            }

            local jitter = jitters[ui.get(self.id)]
            if type(jitter) == 'function' then jitter = jitter() end

            ui.set(refs.yaw_jitter[1], jitter) 
        end
    },

    {
        id = 'multi_ways',
        display = format(' Anti-Aim', '%s', 'Yaw', 'Ways'),
        type = 'slider',
        unpack = {3, 5, 3, true, 'w'},
        update = function(self, e, state)
            if antiaim.defensive and antiaim.defensive.yaw then return false end
            local ways = ui.get(self.id)

            local current = math.floor(globals.tickcount() / ui.get(state.ui.delay.id) % ways + 1)
            local offset = state.ui['yaw_way_' .. current]
            if not offset then assert('Unknown way!') return false end
            offset = ui.get(offset.id)

            ui.set(refs.yaw[2], math.clamp(offset + (e.inv and ui.get(state.ui.right.id) or ui.get(state.ui.left.id)), -180, 180))
        end,
        depency = function(self)
            return ui.get(self.yaw_jitter.id) == 'Multi-Ways'
        end
    },

    {
        id = 'yaw_way_1',
        display = '\n %s yaw_way_1',
        type = 'slider',
        unpack = {-179, 179, 0, true, '°'},
        update = function(self, e, state)
            if ui.get(state.ui.yaw_jitter.id) == 'Multi-Ways' then return false end

            if antiaim.defensive then return false end
            ui.set(refs.yaw_jitter[2], ui.get(self.id))
        end,
        depency = function(v)
            return ui.get(v.yaw_jitter.id) ~= 'Off'
        end
    },

    {
        id = 'yaw_way_2',
        display = '\n %s yaw_way_2',
        type = 'slider',
        unpack = {-179, 179, 0, true, '°'},
        update = function(self) end,
        depency = function(v)
            return ui.get(v.yaw_jitter.id) == 'Multi-Ways'
        end
    },

    {
        id = 'yaw_way_3',
        display = '\n %s yaw_way_3',
        type = 'slider',
        unpack = {-179, 179, 0, true, '°'},
        update = function(self) end,
        depency = function(v)
            return ui.get(v.yaw_jitter.id) == 'Multi-Ways'
        end
    },

    {
        id = 'yaw_way_4',
        display = '\n %s yaw_way_4',
        type = 'slider',
        unpack = {-179, 179, 0, true, '°'},
        update = function(self) end,
        depency = function(v)
            return ui.get(v.yaw_jitter.id) == 'Multi-Ways' and ui.get(v.multi_ways.id) >= 4
        end
    },

    {
        id = 'yaw_way_5',
        display = '\n %s yaw_way_5',
        type = 'slider',
        unpack = {-179, 179, 0, true, '°'},
        update = function(self) end,
        depency = function(v)
            return ui.get(v.yaw_jitter.id) == 'Multi-Ways' and ui.get(v.multi_ways.id) == 5
        end
    },
    

    {
        id = 'body_yaw',
        display = format(' Anti-Aim', '%s', 'Body-yaw'),
        type = 'combobox',
        unpack = {'Off', 'Jitter', 'Static', 'Opposite'},
        update = function(self)
            ui.set(refs.body_yaw[1], ui.get(self.id)) 
        end
    },

    {
        id = 'body_yaw_slider',
        display = '\n %s body_yaw_slider',
        type = 'slider',
        unpack = {-179, 179, 0, true, '°'},
        update = function(self)
            ui.set(refs.body_yaw[2], ui.get(self.id))
        end,
        depency = function(v)
            return ui.get(v.body_yaw.id) ~= 'Off'
        end
    },

    {
        id = 'roll',
        display = format(' Anti-Aim', '%s', 'Roll'),
        type = 'slider',
        unpack = {-45, 45, 0, true},
        update = function(self)
            ui.set(refs.roll, ui.get(self.id))
        end,
    },

    {
        id = 'edge_yaw',
        display = format(' Anti-Aim', '%s', 'Edge yaw'),
        type = 'checkbox',
        unpack = {},
        update = function(self)
            ui.set(refs.edge_yaw, ui.get(self.id))
        end,
    },

    {
        id = 'delay',
        display = format(' Anti-Aim', '%s', 'Delay'),
        type = 'slider',
        unpack = {1, 16, 1, true, 't'},
        update = function(self) end,
    },

    {
        tab = 'B',
        id = 'defensive',
        display = format(' Anti-Aim', '%s', 'Defensve'),
        type = 'combobox',
        unpack = {'Off', 'On Peek', 'Always'},
        update = function(self) end,
    },

    {
        tab = 'B',
        id = 'def_pitch',
        display = format(' Anti-Aim', '%s', 'Defensive', 'Pitch'),
        type = 'combobox',
        unpack = {'Off', 'Up', 'Minimal', 'Random', 'Custom'},
        update = function(self, e)
            if not antiaim.defensive or not antiaim.defensive.pitch then return false end

            local pitchs = {
                Off = 'Off',

                Up = 'Up',
                Minimal = 'Minimal',
                Random = 'Random',
                Custom = 'Custom'
            }

            local pitch = pitchs[ui.get(self.id)]
            if type(pitch) == 'function' then pitch = pitch() end

            ui.set(refs.pitch[1], pitch) 
        end,
        depency = function(v)
            return ui.get(v.defensive.id) ~= 'Off'
        end
    },

    {
        tab = 'B',
        id = 'def_pitch_slider',
        display = '\n %s def_pitch_slider',
        type = 'slider',
        unpack = {-89, 89, 0, true},
        update = function(self)
            if not antiaim.defensive or not antiaim.defensive.pitch then return false end
            ui.set(refs.pitch[2], ui.get(self.id))
        end,
        depency = function(v)
            return ui.get(v.def_pitch.id) == 'Custom' and ui.get(v.defensive.id) ~= 'Off'
        end
    },

    {
        tab = 'B',
        id = 'def_yaw_jitter',
        display = format(' Anti-Aim', '%s', 'Defensive', 'Yaw'),
        type = 'combobox',
        unpack = {'Off', 'Offset', 'Center (Skeet)', 'Random (Skeet)', 'Skitter (Skeet)'},
        update = function(self)
            if not antiaim.defensive or not antiaim.defensive.yaw then return false end
            local jitters = {
                Off = 'Off',

                Offset = 'Offset',
                ['Center (Skeet)'] = 'Center',
                ['Random (Skeet)'] = 'Random',
                ['Skitter (Skeet)'] = 'Skitter',

                
            }

            local jitter = jitters[ui.get(self.id)]
            if type(jitter) == 'function' then jitter = jitter() end
            ui.set(refs.yaw_jitter[1], jitter) 
        end,
        depency = function(v)
            return ui.get(v.defensive.id) ~= 'Off'
        end
    },

    {
        tab = 'B',
        id = 'def_yaw_jitter_slider',
        display = '\n %s def_yaw_jitter_slider',
        type = 'slider',
        unpack = {-179, 179, 0, true},
        update = function(self)
            if not antiaim.defensive or not antiaim.defensive.yaw then return false end
            ui.set(refs.yaw_jitter[2], ui.get(self.id))
        end,
        depency = function(v)
            return ui.get(v.def_yaw_jitter.id) ~= 'Off' and ui.get(v.defensive.id) ~= 'Off'
        end
    },
}
--#endregion

for i, v in pairs(states) do
    assert('+ ' .. wings.color.base .. v.display)

    config[v.id] = config[v.id] or {}

    v.ui = v.ui or {}

    aa:add(ui.new_label('Lua', 'A', '\n'), function() return ui.get(page) == 'Builder' and ui.get(state) == v.display and ui.get(aa_enabled) end) 

    local override

    if v.id ~= 'global' then
        override = ui.new_checkbox('Lua', 'A', format(' Anti-Aim', v.display, 'Override'))
        aa:add(override, function() return ui.get(page) == 'Builder' and ui.get(state) == v.display and ui.get(aa_enabled) end)
        v.ui.override = {id = override, map = ui_map}

        config[v.id].override = false

        ui.set_callback(override, function()
            config[v.id].override = ui.get(override)

            --assert(v.id .. ' : override = ' .. tostring(ui.get(override)))
        end)
    end

    for _, data in pairs(ui_map) do
        local result = ui['new_' .. data.type]('Lua', (data.tab or 'A'), string.format(data.display, v.display), unpack(data.unpack))
        aa:add(result, function() return ui.get(page) == 'Builder' and ui.get(state) == v.display and ui.get(aa_enabled) and ((data.depency and data.depency(v.ui, v)) or not data.depency) and (v.id == 'global' or ui.get(override)) end)
        v.ui[data.id] = {id = result, map = data}

        config[v.id][data.id] = ui.get(result)
        ui.set_callback(result, function()
            config[v.id][data.id] = ui.get(result)
            
            --assert(v.id .. ' : ' .. data.id .. ' = ' .. tostring(ui.get(result)))
        end)
    end
end

local function get_state(e)
    local state = states[1]   
    for i, v in pairs(states) do
        local status = v.check(e)

        if status and v.priority > state.priority and (v.id == 'global' or ui.get(v.ui.override.id)) then
            state = v
        end
    end
    return state
end

local function invert(d, e)
    if globals.tickcount() > antiaim.tick + d and e.chokedcommands == 0 then
        antiaim.invert = not antiaim.invert
        antiaim.tick = globals.tickcount()
    end

    if globals.tickcount() < antiaim.tick then antiaim.tick = globals.tickcount() end

    return antiaim.invert
end

local function is_peeking()
    local lp = entity.get_local_player()
    if not lp then return false end
    local enemies = entity.get_players(true)
    if not enemies then return false end

    local predict_amt = 0.25
    local eye_position = vector(client.eye_position())
    local velocity_prop_local = vector(entity.get_prop(lp, 'm_vecVelocity'))
    local predicted_eye_position = vector(eye_position.x + velocity_prop_local.x * predict_amt, eye_position.y + velocity_prop_local.y * predict_amt, eye_position.z + velocity_prop_local.z * predict_amt)
    for i = 1, #enemies do
        local player = enemies[i]
        local velocity_prop = vector(entity.get_prop(player, 'm_vecVelocity'))
        local origin = vector(entity.get_prop(player, 'm_vecOrigin'))
        local predicted_origin = vector(origin.x + velocity_prop.x * predict_amt, origin.y + velocity_prop.y * predict_amt, origin.z + velocity_prop.z * predict_amt)
        entity.get_prop(player, 'm_vecOrigin', predicted_origin)
        local head_origin = vector(entity.hitbox_position(player, 0))
        local predicted_head_origin = vector(head_origin.x + velocity_prop.x * predict_amt, head_origin.y + velocity_prop.y * predict_amt, head_origin.z + velocity_prop.z * predict_amt)
        local trace_entity, damage = client.trace_bullet(lp, predicted_eye_position.x, predicted_eye_position.y, predicted_eye_position.z, predicted_head_origin.x, predicted_head_origin.y, predicted_head_origin.z)
        entity.get_prop(player, 'm_vecOrigin', origin)
        if damage > 0 then
            return true
        end
    end

    return false
end

wings.hooks.paint.antiaim = function()
    if not ui.get(aa_enabled) then return false end

    if antiaim.defensive and antiaim.indicator_defensive then
        renderer.indicator(224, 54, 102, 255, ' DEFENSIVE')
    end
end

wings.hooks.setup_command.antiaim = function(e)
    antiaim.defensive = false

    if not ui.get(aa_enabled) then return false end
    
    antiaim.peeking = is_peeking()

    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return false end
    local state = get_state(e)
    
    ui.set(refs.enabled, true)
    ui.set(refs.yaw_base, 'At targets')
    
    ui.set(refs.yaw[1], '180')
    
    local defensive = {
        Off = function() e.force_defensive = false end,
        ['On Peek'] = function() e.force_defensive = antiaim.peeking; e.allow_send_packet = not antiaim.peeking end,
        ['Always'] = function() e.force_defensive = true end,
    }

    if not antiaim.manual then
        local def = ui.get(state.ui.defensive.id)
        local allow_defensive = ((ui.get(refs.dt[1]) and ui.get(refs.dt[2])) or (ui.get(refs.osaa[1]) and ui.get(refs.osaa[2]))) and def ~= 'Off'
        
        if not allow_defensive then
            e.force_defensive = allow_defensive
        elseif ui.get(refs.osaa[1]) and ui.get(refs.osaa[2]) then
            e.force_defensive = true
        elseif defensive[def] then
            defensive[def]() 
        end

        
        local inv = invert(ui.get(state.ui.delay.id), e)
        local data = {inv = inv, e = e}
        
        antiaim.defensive = {yaw = ui.get(state.ui.def_yaw_jitter.id) ~= 'Off', pitch = ui.get(state.ui.def_pitch.id) ~= 'Off'}
        if not e.force_defensive then antiaim.defensive = nil end

        for i, v in pairs(state.ui) do if i == 'override' or not ((v.map.depency and v.map.depency(state.ui, state)) or not v.map.depency) then goto continue end v.map.update(v, data, state) ::continue:: end
    else
        ui.set(refs.yaw_base, 'Local view')
        ui.set(refs.pitch[1], 'Minimal')
        ui.set(refs.yaw[2], antiaim.manual)
        ui.set(refs.body_yaw[1], 'Off')
        ui.set(refs.yaw_jitter[1], 'Off')
        ui.set(refs.roll, 0)
    end

    return true
end

--wings.hooks.paint.asd = function() print(get_state().display) end

--#endregion

--#region OTHER
local manual = {}
for i, v in pairs(manuals) do
    aa:add(ui.new_label('Lua', 'A', v[1]), function() return ui.get(page) == 'Other' and ui.get(aa_enabled) end)

    local hk = ui.new_hotkey('Lua', 'A', v[1], true)
    aa:add(hk, function() return ui.get(page) == 'Other' and ui.get(aa_enabled) end)
    manual[i] = hk
end

local prev_state = {}

wings.hooks.paint.manuals = function()
    for i, v in pairs(manual) do
        if ui.get(v) and not prev_state[v] then
            local data = manuals[i][2]

            if antiaim.manual == data then
                antiaim.manual = nil
            else
                antiaim.manual = data
            end
        end

        prev_state[v] = ui.get(v)
    end
end

local freestand = ui.new_checkbox('Lua', 'A', format(' Anti-Aim', 'Freestanding'))
local freestand_hk = ui.new_hotkey('Lua', 'A', 'freestand_hotkey', true)
local defensive_indicator = ui.new_checkbox('Lua', 'A', format(' Anti-Aim', 'Defensive Indicator'))
aa:add({freestand, freestand_hk, defensive_indicator}, function() return ui.get(page) == 'Other' and ui.get(aa_enabled) end)
ui.set_callback(defensive_indicator, function() antiaim.indicator_defensive = ui.get(defensive_indicator) end)

wings.hooks.paint.freestand = function()
    local state = ui.get(freestand_hk) and ui.get(freestand)

    ui.set(refs.freestand[1], state)
    ui.set(refs.freestand_byaw, state)
    ui.set(refs.freestand[2], 'Always on')
end
--#endregion

--#region CONFIG
local list = ui.new_listbox('Lua', 'A', format(' Anti-Aim', 'Configs'), 'No configs.')
local raw_base = {}

local function update()
    local dbase = db.configs
    raw_base = {}

    for i, v in pairs(dbase) do
        if type(i) ~= 'string' or type(v) ~= 'table' or #i < 2 then goto continue end
        table.insert(raw_base, i)

        ::continue::
    end
    if #raw_base < 1 then raw_base = {'No configs'} end

    ui.update(list, raw_base)
end

update()

local function get_select()
    local now = ui.get(list)
    if not now then return '?' end

    return raw_base[now + 1] or '?'
end

local config_name = ui.new_textbox('Lua', 'A', format(' Anti-Aim', 'Config Name'))

local function load_cfg(cfg)
    if not cfg then --[[assert('Failed to find config!')]] return false end

    for i, v in pairs(states) do
        local state_cfg = cfg[v.id]

        if not state_cfg then --[[assert('Failed to find state \"' .. v.id .. '\" in config.')]] goto continue end

        for _, e in pairs(v.ui) do
            local ui_cfg = state_cfg[_]
            
            if not ui_cfg then --[[assert('Failed to find element \"' .. _.. '\" in \"' .. v.id .. '\"')]] goto continue end
            
            ui.set(e.id, ui_cfg)
            ::continue::
        end

        ::continue::
    end
end

local load = ui.new_button('Lua', 'A', ' ' .. wings.color.base .. 'FFLoad', function()
    local selected = get_select()
    local cfg = db.configs[selected]
    load_cfg(cfg)
end)

local save = ui.new_button('Lua', 'A', ' ' .. wings.color.base .. 'FFSave', function()
    local selected = ui.get(config_name)
    if #selected < 2 then ui.set(config_name, 'Provide more than 2 symbols!') return false end

    db.configs[selected] = config

    save()

    --for i, v in pairs(db.configs[selected]) do
    --    assert('State: ' .. i)
    --
    --    for _, e in pairs(v) do
    --        assert('State: ' .. i .. ', element:' .. _ .. ' value: ' .. tostring(e))
    --    end
    --end

    update()
end)

local remove = ui.new_button('Lua', 'A', ' ' .. wings.color.base .. 'FFDelete', function()
    local selected = get_select()
    db.configs[selected] = nil

    update()
end)

local import = ui.new_button('Lua', 'B', ' ' .. wings.color.base .. 'FFImport from clipboard', function()
    load_cfg(json.parse(base64.decode(clipboard.get() or '')))
end)

local export = ui.new_button('Lua', 'B', ' ' .. wings.color.base .. 'FFExport from clipboard', function()
    clipboard.set(base64.encode(json.stringify(config)))
end)

ui.set_callback(list, function()
    local selected = get_select()

    ui.set(config_name, selected)
end)

aa:add({list, config_name, load, save, remove, import, export}, function() return ui.get(page) == 'Config' and ui.get(aa_enabled) end)

--#endregion

--#endregion

--#endregion

--#region CHAT

local ui_chat = ui.new_checkbox('Lua', 'A', 'Chat Integration')
local ui_chat_hide = ui.new_checkbox('Lua', 'A', format('Chat Integration', 'Hide commands'))
misc:add(ui_chat)
misc:add(ui_chat_hide, function() return ui.get(ui_chat) end)

local to_render = {}

wings.hooks.paint_ui.chat_render = function()

    local scrW, scrH = client.screen_size()

    for i, v in pairs(to_render) do
        v.state = client.timestamp() - v.start > 5000
        v.y = math.lerp(globals.frametime() * 10, v.y, v.state and scrH + 25 or scrH - (i * 15))
        v.alpha = math.lerp(globals.frametime() * 10, v.alpha, v.state and 0 or 255)
        renderer.text(scrW / 2, v.y, v.color[1], v.color[2], v.color[3], v.alpha, 'c', 0, v.text)

        if v.state and v.y >= scrH + 20 then table.remove(to_render, i) end
    end

end

local function add_render(str, c)
    local scrW, scrH = client.screen_size()

    c = type(c) == 'table' and c or {}
    c[1] = type(c[1]) == 'number' and c[1] or 255
    c[2] = type(c[2]) == 'number' and c[2] or 255
    c[3] = type(c[3]) == 'number' and c[3] or 255

    table.insert(to_render, {
        text = str,
        y = scrH + 25,
        start = client.timestamp(),
        alpha = 0,
        color = c
    })
end

local function resolve_player(target)
    if type(target) ~= 'string' then return nil end
    if #target < 3 then cprint('{grey}Required more than {red}3 symbols') return nil end
    target = string.lower(target)

    local highest = {nil, 0}

    for ent = 1, 64 do
        local name, steam = string.lower(entity.get_player_name(ent)), entity.get_steam64(ent)
        if not name or not steam then goto continue end

        local function update_stage(prio) if highest[2] < prio then highest = {ent, prio} end end

        if string.find(name, target, 1, false) then update_stage(1) end
        if string.find(name, '^' .. target, 1, true) then update_stage(2) end
        if name == target then update_stage(3) end
        if steam == target then update_stage(4) end
        if steam64(steam) == tonumber(target) then update_stage(5) end

        ::continue::
    end

    return highest[1]
end

local prefix = {
    ['!wings'] = true,
    ['/wings'] = true,
    ['.wings'] = true,
    ['!w'] = true,
    ['/w'] = true,
    ['.w'] = true,
}

local handle_one = function(ent)
    local name, steam = entity.get_player_name(ent), entity.get_steam64(ent)
    if not name or not steam then return false end

    if db.chat[tostring(steam)] then
        mute.set(ent, true)

        add_render('Player automatically muted. (' .. name .. ')')
        cprint('{white}' .. name .. '{grey} was automatically muted.')
        return true
    end

    return false
end

wings.hooks.player_connect_full.chat_premute = function(e)
    local ent = client.userid_to_entindex(e.userid)

    if ent == entity.get_local_player() then
        cprint('{green}Wings {grey}support chat commands!')
        cprint('!w, /w, .w, !wings, /wings, .wings')
        wings_rage = {}
        for i = 1, globals.maxplayers() do handle_one(i) end
    else
        handle_one(ent)
    end 

    return true
end

for i = 1, globals.maxplayers() do handle_one(i) end

local commands = {
    premute = function(args)
        local sub_command = {
            add = function()
                table.remove(args, 1)
                local find = table.concat(args, ' ')
        
                local target = resolve_player(find)
                if not target then add_render('Player not found!', {255, 0, 0}); cprint('{white}' .. find .. '{grey} not found!') return false end
                local name, steam = entity.get_player_name(target), entity.get_steam64(target)
        
                if db.chat[tostring(steam)] then add_render('Player already muted.', {255, 0, 0}); cprint('{white}' .. name .. '{grey} already premuted!') return false end
        
                mute.set(target, true)
                add_render('Player added to premute. (' .. name .. ')')
                cprint('{white}' .. name .. '{grey} added to premute!')
        
                db.chat[tostring(steam)] = name
            end,
            remove = function()
                table.remove(args, 1)
                local find = table.concat(args, ' ')
        
                local target, direct

                if db.chat[find] then
                    target = find
                    direct = true
                else
                    target = resolve_player(find)
                end

                if not target then add_render('Player not found!', {255, 0, 0}); cprint('{white}' .. find .. '{grey} not found!') return false end
                local name, steam

                if not direct then
                    name, steam = entity.get_player_name(target), entity.get_steam64(target)
                else
                    name, steam = db.chat[find], find
                end
        
                if not db.chat[tostring(steam)] then add_render('Player aint muted.', {255, 0, 0}); cprint('{white}' .. name .. '{grey} aint premuted!') return false end
        
                if not direct then mute.set(target, false) end
                add_render('Player removed from premute. (' .. name .. ')')
                cprint('{white}' .. name .. '{grey} removed from premute!')
        
                db.chat[tostring(steam)] = nil
            end,
            list = function()
                local count = 0; for i, v in pairs(db.chat) do count = count + 1 end
                cprint('List of premuted users (' .. count .. '): ')

                for i, v in pairs(db.chat) do
                    cprint('{grey}' .. tostring(v) .. '{white} (' .. tostring(i) .. ')')
                end
            end,
        }

        if not args[1] or not sub_command[args[1]] then 
            add_render('No sub-command found.') 

            cprint('{white}Sub-command{grey} not found!')
            
            cprint('{white}add {grey}- Add player to premute')
            cprint('{white}remove {grey}- Remove player from premute')
            cprint('{white}list {grey}- Show list of premuted players.')

            return false 
        end

        sub_command[args[1]]()
    end,
    reveal = function(args)
        local find = table.concat(args, ' ')
        
        local name, steam
        local target = resolve_player(find)
        if not target and db.dox[find] then target = db.dox[find]; name, steam = db.dox[find][#db.dox[find]], find end

        if not target then add_render('Player not found!', {255, 0, 0}); cprint('{white}' .. find .. '{grey} not found!') return false end
        local name, steam = name or entity.get_player_name(target), steam or entity.get_steam64(target)
        cprint('{white}' .. name .. ' {grey}' .. steam)

        if db.chat[tostring(steam)] then cprint('{white}Premuted with nickname: {grey}' .. db.chat[tostring(steam)]) end
        local dbase = db.dox[tostring(steam)]
        
        if not dbase then return false end

        local map = {
            {'first_time', function(v)
                cprint('{white}First time seen: {grey}' .. datetime(v))
            end},

            {'history_names', function(v)
                cprint('{white}History of player nicknames:{grey} When: NickName')
                
                for name, time in pairs(v) do
                    cprint('{grey}[' .. datetime(time) ..']: {white}' .. tostring(name))
                end
            end},
        }

        for i, v in pairs(map) do if dbase[v[1]] then pcall(v[2], dbase[v[1]]) end end
    end,
    clear_keys = function(args)
        if args[1] ~= 'confirm' then cprint('{red}This command will delete all keys.') cprint('{grey}If u want to continue use: {white}clear_keys confirm') return false end

        db.dox = {}
        db.chat = {}

        cprint('{grey}Succesfully deleted {white}keys{grey}.')
    end
}

wings.hooks.string_cmd.chat = function(e)
    if not string.find(e.text, '^say ') and not string.find(e.text, '^say_team ') then return false end

    local args = {}
    local text = e.text
    
    for word in text:gmatch('%S+') do table.insert(args, word) end
    table.remove(args, 1)

    args[1] = string.gsub(args[1], '^"', '')
    args[#args] = string.gsub(args[#args], '"$', '')
    if not prefix[args[1]] then return false end
    
    if ui.get(ui_chat_hide) then e.text = '' end
    
    if not ui.get(ui_chat) then cprint('{white}Chat Integration{red} disabled {grey}(Miscellaneous -> Chat Integration)') return false end
    local commandes = {}
    for i, v in pairs(commands) do table.insert(commandes, i) end

    if not commands[args[2]] then add_render('Command not found.'); cprint('{white}Command{grey} not found!') cprint('Available commands: {white}' .. table.concat(commandes, ', ')) return false end

    local args_send = {}
    for i, v in pairs(args) do table.insert(args_send, v) end

    table.remove(args_send, 1)
    if #args_send < 1 then args_send = {} else table.remove(args_send, 1) end

    commands[args[2]](args_send)

    return false
end

--#endregion

--#region INDICATOR-REDESIGN
local data, i = {}, -1  

local indicator_enable = ui.new_checkbox('Lua', 'A', ' GS Indicators Redesign')
visuals:add(indicator_enable)

local textures = {
    arrow_left = [[<svg width="26" height="27" viewBox="0 0 26 27" fill="none" xmlns="http://www.w3.org/2000/svg"><rect x="9.00024" y="21.9705" width="18" height="6" transform="rotate(-45 9.00024 21.9705)" fill="#FFFFFF"/><rect x="13.2429" y="0.757286" width="18" height="6" transform="rotate(45 13.2429 0.757286)" fill="#FFFFFF"/></svg>]],
    arrow_right = [[<svg width="26" height="26" viewBox="0 0 26 26" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="18" height="6" transform="matrix(-0.707107 -0.707107 -0.707107 0.707107 16.9705 21.2132)" fill="#FFFFFF"/><rect width="18" height="6" transform="matrix(-0.707107 0.707107 0.707107 0.707107 12.7278 -2.09808e-05)" fill="#FFFFFF"/></svg>]]
}
for i, v in pairs(textures) do textures[i] = renderer.load_svg(v, 26, 26) end

local function new_indicator(ind)
    local words = {} 
    for word in ind.text:gmatch('%S+') do
        table.insert(words, word)
    end

    local tag = words[1]

    ind.original_color = { r = ind.r, g = ind.g, b = ind.b, a = ind.a }
    ind.original_text = ind.text

    local index

    for i, v in pairs(data) do
        if v.tag == tag then index = i break end
    end

    if index then
        data[index].i = i + 1
        data[index].original_color = ind.original_color
        data[index].original_text = ind.original_text
        data[index].updated = true
    else
        ind.a = 0
        ind.updated = true
        ind.tag = tag
        ind.i = i + 1
        table.insert(data, 1, ind)
    end

    return true
end

local function catch(ind)
    if string.find(ind.text, '-%d+ HP') then local hp = ind.text:match('%d+') ind.text = ' Safe (-' .. hp ..'HP)'; ind.r = 145 ind.g = 135 ind.b = 255 end
    if ind.text == 'FATAL' then ind.text = ' Lethal' end
    i = i + 1
    new_indicator(ind)
end

ui.set_callback(indicator_enable, function()
    local v = ui.get(indicator_enable)
    client[(v and 'set' or 'unset') .. '_event_callback']('indicator', function(ind) catch(ind) end)
end)

local dt = {}

local specials = {
    ['DT'] = function(v)
        local w, h = renderer.measure_text('b+', 'A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z.')
        local charge = v.original_color.b == 255
        local size = 20

        local y = v.y + h / 2 - size / 2

        if not dt.padding or (client.timestamp() - dt.padding.last > dt.padding.wait) then dt.padding = {last = client.timestamp(), value = client.random_int(3, 5), wait = client.random_int(200, 400)} end
        dt.padding = charge and dt.padding or {value = 0, last = client.timestamp(), wait = 1}
        
        local r, g, b = (charge and 145 or 245), (charge and 135 or 66), (charge and 255 or 93)
        dt.color = dt.color or {r = r, g = g, b = b}
        local time = globals.frametime() * 15

        dt.color.r = math.lerp(time, dt.color.r, r)
        dt.color.g = math.lerp(time, dt.color.g, g)
        dt.color.b = math.lerp(time, dt.color.b, b)

        v.r, v.g, v.b = r, g, b

        local shadow = -1
        renderer.texture(textures.arrow_left, 7.5 - dt.padding.value - shadow, y + dt.padding.value - shadow, size, size, 0, 0, 0, v.a, 'f')
        renderer.texture(textures.arrow_right, 7.5 + size - 6 + dt.padding.value - shadow, y - dt.padding.value - shadow, size, size, 0, 0, 0, v.a, 'f')

        renderer.texture(textures.arrow_left, 7.5 - dt.padding.value, y + dt.padding.value, size, size, dt.color.r, dt.color.g, dt.color.b, v.a, 'f')
        renderer.texture(textures.arrow_right, 7.5 + size - 6 + dt.padding.value, y - dt.padding.value, size, size, dt.color.r, dt.color.g, dt.color.b, v.a, 'f')

        return {x = size * 2 - 6, y = 2}
    end,
    ['PING'] = function(v) v.text = ' PING' v.r, v.g, v.b = v.original_color.r, v.original_color.g, v.original_color.b end,
    ['MD'] = function(v) v.text = ' MD' v.r = 145 v.g = 135 v.b = 255 end,
    ['FS'] = function(v) v.text = ' FS' v.r = 145 v.g = 135 v.b = 255 end,
    ['OSAA'] = function(v) v.text = ' OSAA' v.r = 145 v.g = 135 v.b = 255 end,
    ['DA'] = function(v) v.text = ' DA' v.r = 145 v.g = 135 v.b = 255 end,
    ['DUCK'] = function(v) v.text = ' DUCK' v.r = 145 v.g = 135 v.b = 255 end,
    ['BODY'] = function(v) v.text = ' BODY' v.r = 145 v.g = 135 v.b = 255 end,
    ['A'] = function(v) v.text = ' A Site' v.r = 145 v.g = 135 v.b = 255 end,
    ['B'] = function(v) v.text = ' B Site' v.r = 145 v.g = 135 v.b = 255 end,
    ['a_site'] = {function(v) v.text = ' A Site ' .. string.sub(v.original_text, 2) v.r = 145 v.g = 135 v.b = 255 end, '^A - '},
    ['b_site'] = {function(v) v.text = ' B Site ' .. string.sub(v.original_text, 2) v.r = 145 v.g = 135 v.b = 255 end, '^B - '},
    ['hp_bomb'] = {function(v) v.text = v.original_text end, ' Safe '}
}

wings.hooks.paint.indicator_redesign = function()
    local w, h = renderer.measure_text('b+', 'INDICATOR')
    local scrW, scrH = client.screen_size()

    local remove_queue = {}
    for i, v in pairs(data) do
        if not v.updated and v.a <= 5 then table.insert(remove_queue, v) goto continue end
        local padding = {x = 0, y = 0}

        v.y = v.y or scrH - 390
        v.y = math.lerp(globals.frametime() * 15, v.y, scrH - 390 - ((h + 10) * (v.i - 1)))
        v.a = math.lerp(globals.frametime() * 10, v.a, (v.updated and 255 or 0))

        if type(specials[v.original_text]) == 'function' then
            padding = specials[v.original_text](v)
        else
            for _, func in pairs(specials) do
                if type(func) ~= 'table' then goto continue end

                if type(func) == 'table' and type(func[1]) == 'function' and string.find(v.original_text, func[2]) then
                    padding = func[1](v)
                    break;
                end

                ::continue::
            end
        end

        if type(padding) ~= 'table' then padding = {} end
            padding.x = padding.x or 0
            padding.y = padding.y or 0

        renderer.text(10 + padding.x, v.y - padding.y, v.r, v.g, v.b, v.a, 'b+', 0, v.text)

        ::continue::
    end

    i = 0

    for i, v in pairs(remove_queue) do table.remove(data, table.find(data, v)) end
    for i, v in pairs(data) do v.updated = false end
end

--#endregion

direct_print(color.rgb(255, 255, 255), '\n')
print('Wings loaded!', wasted())
direct_print(color.rgb(255, 255, 255), '\n')

--#region HOOKS

for i,v in pairs(wings.hooks) do
    wings.hooks[i] = wings.hooks[i] or {}

    client.set_event_callback(i, function(...)
        for i, func in pairs(v) do
            if type(func) == 'function' then
                local state, err = pcall(func, ...)
                if not state then assert('Error while ' .. tostring(v) .. ' hook.', tostring(err)) end
            end
        end
    end)
end

--#endregion

--#region DEV

if wings.settings.dev then
    wings.hooks.paint_ui.dev = function()
        local map = {
            {},
            {lt = true},
            {lb = true},
            {rt = true},
            {rb = true},
            {rb = true, lt = true},
            {rt = true, lb = true},
            {rt = true, rb = true},
            {lt = true, lb = true},
            {rb = true, lb = true},
            {rt = true, lt = true},
        }

        for i = 1, #map do
            render.glow(60 * i, 50, 50, 50, 255, 255, 255, 100, 4, map[i], 8, 10)
            render.rectangle(60 * i, 50, 50, 50, 255, 255, 255, 255, 4, map[i])
        end
    end

    widgets.new('dev_widget_small', nil, 60, 110, 50, 50, nil, true, true)
    widgets.new('dev_widget_medium+', nil, 330, 110, 50, 320, nil, true, true)
    widgets.new('dev_widget_medium', nil, 120, 110, 200, 50, nil, true, true)
    widgets.new('dev_widget_large', nil, 60, 170, 260, 260, nil, true, true)
end

--#endregion