-- [ reqs ]
local ffi = require("ffi")
local pui = require("gamesense/pui")
local base64 = require("gamesense/base64")
local vector = require("vector")
local antiaim_funcs = require("gamesense/antiaim_funcs")


-- [ useful ]
    local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'nightly', discord=''}
    local userdata = {
    username = obex_data.username == nil or obex_data.username,
    build = obex_data.build ~= nil and obex_data.build:gsub("Private", "nightly"):gsub("Beta", "beta"):gsub("User", "live")
}

local vars = {
    shot_time = 0,
    in_attack = 0,
    last_press_t = globals.curtime()
}

local tables = {notifications = {}}

local ref = {
    aa_enable = ui.reference("AA","anti-aimbot angles","enabled"),
    pitch = ui.reference("AA","anti-aimbot angles","pitch"),
    pitch_value = select(2, ui.reference("AA","anti-aimbot angles","pitch")),
    yaw_base = ui.reference("AA","anti-aimbot angles","yaw base"),
    yaw = ui.reference("AA","anti-aimbot angles","yaw"),
    yaw_value = select(2, ui.reference("AA","anti-aimbot angles","yaw")),
    yaw_jitter = ui.reference("AA","Anti-aimbot angles","Yaw Jitter"),
    yaw_jitter_value = select(2, ui.reference("AA","Anti-aimbot angles","Yaw Jitter")),
    body_yaw = ui.reference("AA","Anti-aimbot angles","Body yaw"),
    body_yaw_value = select(2, ui.reference("AA","Anti-aimbot angles","Body yaw")),
    freestand_body_yaw = ui.reference("AA","Anti-aimbot angles","freestanding body yaw"),
    edgeyaw = ui.reference("AA","anti-aimbot angles","edge yaw"),
    freestand = {ui.reference("AA","anti-aimbot angles","freestanding")},
    roll = ui.reference("AA","anti-aimbot angles","roll"),
    slide = {ui.reference("AA","other","slow motion")},
    fakeduck = ui.reference("rage","other","duck peek assist"),
    quick_peek = {ui.reference("rage", "other", "quick peek assist")},
    doubletap = {ui.reference("rage", "aimbot", "double tap")},
    damage = {ui.reference("rage", "aimbot", "minimum damage override")},
    osaa = {ui.reference("aa", "other", "on shot anti-aim")},
    safe = ui.reference("rage", "aimbot", "force safe point"),
    baim = ui.reference("rage", "aimbot", "force body aim"),
    fl = ui.reference("aa", "fake lag", "limit"),
    legs = ui.reference("AA", "Other", "Leg movement")
}

function get_velocity()
    if not entity.get_local_player() then return end
    local first_velocity, second_velocity = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    local speed = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))
    
    return speed
end

local ground_tick = 1
function get_state(speed)
    if not entity.is_alive(entity.get_local_player()) then return end
    local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    local land = bit.band(flags, bit.lshift(1, 0)) ~= 0
    if land == true then ground_tick = ground_tick + 1 else ground_tick = 0 end

    if bit.band(flags, 1) == 1 then
        if ground_tick < 10 then if bit.band(flags, 4) == 4 then return 5 else return 4 end end
        if bit.band(flags, 4) == 4 or ui.get(ref.fakeduck) then 
            return 6 -- crouching
        else
            if speed <= 3 then
                return 2 -- standing
            else
                if ui.get(ref.slide[2]) then
                    return 7 -- slowwalk
                else
                    return 3 -- moving
                end
            end
        end
    elseif bit.band(flags, 1) == 0 then
        if bit.band(flags, 4) == 4 then
            return 5 -- air-c
        else
            return 4 -- air
        end
    end
end

ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
    typedef bool(__thiscall* console_is_visible)(void*);
]]

local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')

local VGUI_System010 =  client.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010 )
local get_clipboard_text_count = ffi.cast("get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi.cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi.cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")

clipboard_import = function()
    local clipboard_text_length = get_clipboard_text_count(VGUI_System)
   
    if clipboard_text_length > 0 then
        local buffer = ffi.new("char[?]", clipboard_text_length)
        local size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)
   
        get_clipboard_text(VGUI_System, 0, buffer, size )
   
        return ffi.string( buffer, clipboard_text_length-1)
    end

    return ""
end

local function clipboard_export(string)
	if string then
		set_clipboard_text(VGUI_System, string, string:len())
	end
end

local aa_state_full = {[1] = "Global", [2] = "Stand", [3] = "Move", [4] = "Aero", [5] = "Aero Crouch", [6] = "Crouch", [7] = "Slowwalk"}

local last_sim_time = 0
local defensive_until = 0
local function is_defensive_active()
    local tickcount = globals.tickcount()
    local sim_time = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local sim_diff = sim_time - last_sim_time

    if sim_diff < 0 then
        defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
    end

    last_sim_time = sim_time

    return defensive_until > tickcount
end

local function is_vulnerable()
    for _, v in ipairs(entity.get_players(true)) do
        local flags = (entity.get_esp_data(v)).flags

        if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
            return true
        end
    end

    return false
end

contains = function(tbl, arg)
    for index, value in next, tbl do 
        if value == arg then 
            return true end 
        end 
    return false
end

local animations = {anim_list = {}}
animations.math_clamp = function(value, min, max) return math.min(max, math.max(min, value)) end
animations.math_lerp = function(a, b_, t) local t = animations.math_clamp(globals.frametime() * (0.045 * 175), 0, 1) if type(a) == 'userdata' then r, g, b, a = a.r, a.g, a.b, a.a e_r, e_g, e_b, e_a = b_.r, b_.g, b_.b, b_.a r = math_lerp(r, e_r, t) g = math_lerp(g, e_g, t) b = math_lerp(b, e_b, t) a = math_lerp(a, e_a, t) return color(r, g, b, a) end local d = b_ - a d = d * t d = d + a if b_ == 0 and d < 0.01 and d > -0.01 then d = 0 elseif b_ == 1 and d < 1.01 and d > 0.99 then d = 1 end return d end
animations.new = function(name, new, remove, speed) if not animations.anim_list[name] then animations.anim_list[name] = {} animations.anim_list[name].color = {0, 0, 0, 0} animations.anim_list[name].number = 0 animations.anim_list[name].call_frame = true end if remove == nil then animations.anim_list[name].call_frame = true end if speed == nil then speed = 0.010 end if type(new) == 'userdata' then lerp = animations.math_lerp(animations.anim_list[name].color, new, speed) animations.anim_list[name].color = lerp return lerp end lerp = animations.math_lerp(animations.anim_list[name].number, new, speed) animations.anim_list[name].number = lerp return lerp end

local function choking(cmd)
    local choke = false

    if cmd.allow_send_packet == false or cmd.chokedcommands > 1 then
        choke = true
    else
        choke = false
    end

    return choke
end

local rgba_to_hex = function(b, c, d, e)
    return string.format('%02x%02x%02x%02x', b, c, d, e)
end
local hex_to_rgba = function(hex)
    hex = hex:gsub('#', '')
    return tonumber('0x' .. hex:sub(1, 2)), tonumber('0x' .. hex:sub(3, 4)), tonumber('0x' .. hex:sub(5, 6)), tonumber('0x' .. hex:sub(7, 8)) or 255
end
function d_lerp(a, b, t)
    return a + (b - a) * t
end
function d_clamp(x, minval, maxval)
    if x < minval then
        return minval
    elseif x > maxval then
        return maxval
    else
        return x
    end
end

local function animated_text(x, y, speed, color1, color2, flags, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local x = i * 10  
        local wave = math.cos(2 * speed * curtime / 4 + x / 60)

        local color = rgba_to_hex(
            math.max(0, d_lerp(color1.r, color2.r, d_clamp(wave, 0, 1))),
            math.max(0, d_lerp(color1.g, color2.g, d_clamp(wave, 0, 1))),
            math.max(0, d_lerp(color1.b, color2.b, d_clamp(wave, 0, 1))),
            math.max(0, d_lerp(color1.a, color2.a, d_clamp(wave, 0, 1)))
        )
        final_text = final_text .. '\a' .. color .. text:sub(i, i) 
    end
    
    renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, flags, nil, final_text)
end

in_bounds = function(x1, y1, x2, y2)
    mouse_x, mouse_y = ui.mouse_position()

    if (mouse_x > x1 and mouse_x < x2) and (mouse_y > y1 and mouse_y < y2) then
        return true
    end
    
    return false
end

prevent_mouse = function(cmd)
    if ui.is_menu_open() then
        cmd.in_attack = false
    end
end

local printc do
    ffi.cdef[[
        typedef struct { uint8_t r; uint8_t g; uint8_t b; uint8_t a; } color_struct_t;
    ]]

	local print_interface = ffi.cast("void***", client.create_interface("vstdlib.dll", "VEngineCvar007"))
	local color_print_fn = ffi.cast("void(__cdecl*)(void*, const color_struct_t&, const char*, ...)", print_interface[0][25])

    -- 
    local hex_to_rgb = function (hex)
        return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16), tonumber(hex:sub(7, 8), 16)
    end
	
	local raw = function(text, r, g, b, a)
		local col = ffi.new("color_struct_t")
		col.r, col.g, col.b, col.a = r or 217, g or 217, b or 217, a or 255
	
		color_print_fn(print_interface, col, tostring(text))
	end

	printc = function (...)
		for i, v in ipairs{...} do
			local r = "\aD9D9D9"..v
			for col, text in r:gmatch("\a(%x%x%x%x%x%x)([^\a]*)") do
				raw(text, hex_to_rgb(col))
			end
		end
		raw "\n"
	end
end

setup_notification = function(str, clr)
    table.insert(tables.notifications, {
        string = str,

        timer = 0,
        alpha = 0,
        color = clr
    })
end

local menu_key = {ui.get(ui.reference("MISC", "Settings", "Menu key"))}
function get_menu_alpha()local a=ui.is_menu_open()local b=0;if a~=last_state then draw_swap=globals.curtime()last_state=a end;local c=0.07;if not ignore_next and client.key_state(menu_key[3])then is_closing=true else if not client.key_state(menu_key[3])then ignore_next=false end end;local d=state;local e;if ui.is_menu_open()then if is_closing then state="closed"e=false else state="open"e=true end else is_closing=false;e=false;ignore_next=true;state="closed"end;if d~=state then swap_time=globals.curtime()end;b=animations.math_clamp((swap_time+c-globals.curtime())/c,0,1)b=(e and a and 1-b or b)*255;return b end

local start_time = client.unix_time()
local function get_elapsed_time()
    local elapsed_seconds = client.unix_time() - start_time
    local hours = math.floor(elapsed_seconds / 3600)
    local minutes = math.floor((elapsed_seconds - hours * 3600) / 60)
    local seconds = math.floor(elapsed_seconds - hours * 3600 - minutes * 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

pui.accent = "C3C6FFFF"

-- [ script ui ]
local group = pui.group("aa","anti-aimbot angles")
local _ui = {
    lua = {
        enable = group:checkbox("\v{OV}"),
        tab = group:combobox("\n ", "Start", "Anti-aim", "Visuals", "Miscellaneous")
    },

    start = {
        ultra_text = group:label("Build: \v"..userdata.build),
        session_text = group:label("Session time: \v1488"),
        group:label("\a                                                 "),
        max_notifications = group:slider("Maximum notifications", 2, 10, 6),
        notifications_spacing = group:slider("Notifications spacing", 23, 50, 26, false, nil, 1),
        notifications_position = group:combobox("Notifications position", "Upper-left", "Centered"),
        send_test_notification = group:button("Send test notification", function() setup_notification("example notification", true) end),
        group:label("\a                                                        "),
        setup_notification("Welcome back, "..userdata.username)
    },

    antiaim = {
        enable = group:checkbox("Enable"),
        tab = group:combobox("\aFFFFFFFFAnti-aim tab", "Builder", "Settings"),

        condition = group:combobox("Player state", aa_state_full),

        tweaks = group:multiselect("\a869CC3FF{OV} Tweaks", "Modify fakelag on shot", "Anti-backstab", "Safe head"),
        freestanding = group:hotkey("\a869CC3FF{OV} Freestanding"),
        edge_yaw = group:hotkey("\a869CC3FF{OV} Edge yaw"),
        manual_right = group:hotkey("\a869CC3FF{OV} Manual Right"),
        manual_left = group:hotkey("\a869CC3FF{OV} Manual Left"),
        cfg_export = group:button("\a869CC3FF{OV} Export anti-aim settings", function() config.export() end),
        cfg_import = group:button("\a869CC3FF{OV} Import anti-aim settings", function() config.import() end),
        cfg_reset = group:button("\aFF8282FFReset anti-aim settings", function() config.import("W3siZW5hYmxlIjp0cnVlLCJ0YWIiOiJTZXR0aW5ncyIsImZyZWVzdGFuZGluZyI6WzEsMCwifiJdLCJjb25kaXRpb24iOiJHbG9iYWwiLCJlZGdlX3lhdyI6WzEsMCwifiJdLCJ0d2Vha3MiOlsifiJdfSxbeyJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwiZnJlZXN0YW5kX2JvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJ5YXdfdmFsdWUiOjAsIm92ZXJyaWRlIjp0cnVlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfV0sW3siZGVmZW5zaXZlX21vZGlmaWVycyI6ZmFsc2UsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6ZmFsc2UsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOmZhbHNlLCJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImRlZmVuc2l2ZV9hYV9lbmFibGUiOmZhbHNlLCJib2R5X3lhdyI6Ik9mZiIsInlhdyI6Ik9mZiIsInlhd192YWx1ZSI6MCwieWF3X2ppdHRlcl92YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsImJvZHlfeWF3X3ZhbHVlIjowLCJwaXRjaF92YWx1ZSI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZX0seyJkZWZlbnNpdmVfbW9kaWZpZXJzIjpmYWxzZSwieWF3X2Jhc2UiOiJMb2NhbCB2aWV3IiwicGl0Y2giOiJPZmYiLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjpmYWxzZSwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJ5YXdfdmFsdWUiOjAsInlhd19qaXR0ZXJfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6ZmFsc2UsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6ZmFsc2UsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOmZhbHNlLCJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImRlZmVuc2l2ZV9hYV9lbmFibGUiOmZhbHNlLCJib2R5X3lhdyI6Ik9mZiIsInlhdyI6Ik9mZiIsInlhd192YWx1ZSI6MCwieWF3X2ppdHRlcl92YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsImJvZHlfeWF3X3ZhbHVlIjowLCJwaXRjaF92YWx1ZSI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZX0seyJkZWZlbnNpdmVfbW9kaWZpZXJzIjpmYWxzZSwieWF3X2Jhc2UiOiJMb2NhbCB2aWV3IiwicGl0Y2giOiJPZmYiLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjpmYWxzZSwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJ5YXdfdmFsdWUiOjAsInlhd19qaXR0ZXJfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6ZmFsc2UsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6ZmFsc2UsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlfV1d") end),
        cfg_default = group:button("\a869CC3FF{OV} \vLoad default settings", function() config.import("W3siZW5hYmxlIjp0cnVlLCJ0YWIiOiJTZXR0aW5ncyIsInR3ZWFrcyI6WyJBbnRpLWJhY2tzdGFiIiwiU2FmZSBoZWFkIiwifiJdLCJtYW51YWxfcmlnaHQiOlsxLDY3LCJ+Il0sImZyZWVzdGFuZGluZyI6WzEsNiwifiJdLCJjb25kaXRpb24iOiJDcm91Y2giLCJlZGdlX3lhdyI6WzEsMCwifiJdLCJtYW51YWxfbGVmdCI6WzEsOTAsIn4iXX0sW3sieWF3X2Jhc2UiOiJMb2NhbCB2aWV3IiwicGl0Y2giOiJPZmYiLCJib2R5X3lhdyI6Ik9mZiIsInlhdyI6Ik9mZiIsImZyZWVzdGFuZF9ib2R5X3lhdyI6ZmFsc2UsImJvZHlfeWF3X3ZhbHVlIjo1LCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X3ZhbHVlIjotOSwib3ZlcnJpZGUiOnRydWUsInlhd19qaXR0ZXJfdmFsdWUiOjIxfSx7Inlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiRG93biIsImJvZHlfeWF3IjoiSml0dGVyIiwieWF3IjoiMTgwIiwiZnJlZXN0YW5kX2JvZHlfeWF3Ijp0cnVlLCJib2R5X3lhd192YWx1ZSI6LTE4MCwieWF3X2ppdHRlciI6IlNraXR0ZXIiLCJ5YXdfdmFsdWUiOjIyLCJvdmVycmlkZSI6dHJ1ZSwieWF3X2ppdHRlcl92YWx1ZSI6LTN9LHsieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXciOiIxODAiLCJmcmVlc3RhbmRfYm9keV95YXciOnRydWUsImJvZHlfeWF3X3ZhbHVlIjotMTgwLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X3ZhbHVlIjowLCJvdmVycmlkZSI6dHJ1ZSwieWF3X2ppdHRlcl92YWx1ZSI6Njh9LHsieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXciOiIxODAiLCJmcmVlc3RhbmRfYm9keV95YXciOnRydWUsImJvZHlfeWF3X3ZhbHVlIjotMTgwLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X3ZhbHVlIjowLCJvdmVycmlkZSI6dHJ1ZSwieWF3X2ppdHRlcl92YWx1ZSI6NjB9LHsieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXciOiIxODAiLCJmcmVlc3RhbmRfYm9keV95YXciOnRydWUsImJvZHlfeWF3X3ZhbHVlIjotMTgwLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X3ZhbHVlIjowLCJvdmVycmlkZSI6dHJ1ZSwieWF3X2ppdHRlcl92YWx1ZSI6NTF9LHsieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXciOiIxODAiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MjIsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJ5YXdfdmFsdWUiOi0xLCJvdmVycmlkZSI6dHJ1ZSwieWF3X2ppdHRlcl92YWx1ZSI6NX0seyJ5YXdfYmFzZSI6IkF0IHRhcmdldHMiLCJwaXRjaCI6IkRvd24iLCJib2R5X3lhdyI6IkppdHRlciIsInlhdyI6IjE4MCIsImZyZWVzdGFuZF9ib2R5X3lhdyI6dHJ1ZSwiYm9keV95YXdfdmFsdWUiOi0yMywieWF3X2ppdHRlciI6IlNraXR0ZXIiLCJ5YXdfdmFsdWUiOjUsIm92ZXJyaWRlIjp0cnVlLCJ5YXdfaml0dGVyX3ZhbHVlIjoxOH1dLFt7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOmZhbHNlLCJ5YXdfYmFzZSI6IkF0IHRhcmdldHMiLCJwaXRjaCI6IkN1c3RvbSIsImRlZmVuc2l2ZV9hYV9lbmFibGUiOmZhbHNlLCJib2R5X3lhdyI6IkppdHRlciIsInlhdyI6IjE4MCIsInlhd192YWx1ZSI6MjUsInlhd19qaXR0ZXJfdmFsdWUiOjI3LCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwiYm9keV95YXdfdmFsdWUiOi0xNCwicGl0Y2hfdmFsdWUiOjg5LCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOnRydWUsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiQ3VzdG9tIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6ZmFsc2UsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiMTgwIiwieWF3X3ZhbHVlIjoxLCJ5YXdfaml0dGVyX3ZhbHVlIjoyNSwieWF3X2ppdHRlciI6IkNlbnRlciIsImJvZHlfeWF3X3ZhbHVlIjowLCJwaXRjaF92YWx1ZSI6NzEsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZX0seyJkZWZlbnNpdmVfbW9kaWZpZXJzIjpmYWxzZSwieWF3X2Jhc2UiOiJMb2NhbCB2aWV3IiwicGl0Y2giOiJPZmYiLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjpmYWxzZSwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJ5YXdfdmFsdWUiOjAsInlhd19qaXR0ZXJfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6dHJ1ZSwieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJSYW5kb20iLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjp0cnVlLCJib2R5X3lhdyI6Ik9wcG9zaXRlIiwieWF3IjoiMTgwIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjo2MCwieWF3X2ppdHRlciI6IkNlbnRlciIsImJvZHlfeWF3X3ZhbHVlIjowLCJwaXRjaF92YWx1ZSI6ODksImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZX0seyJkZWZlbnNpdmVfbW9kaWZpZXJzIjp0cnVlLCJ5YXdfYmFzZSI6IkF0IHRhcmdldHMiLCJwaXRjaCI6IkN1c3RvbSIsImRlZmVuc2l2ZV9hYV9lbmFibGUiOnRydWUsImJvZHlfeWF3IjoiSml0dGVyIiwieWF3IjoiMTgwIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjo1MSwieWF3X2ppdHRlciI6IkNlbnRlciIsImJvZHlfeWF3X3ZhbHVlIjotMTgwLCJwaXRjaF92YWx1ZSI6LTUyLCJmb3JjZV9kZWZlbnNpdmUiOnRydWV9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6dHJ1ZSwieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJSYW5kb20iLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjp0cnVlLCJib2R5X3lhdyI6IkppdHRlciIsInlhdyI6IjE4MCIsInlhd192YWx1ZSI6LTEsInlhd19qaXR0ZXJfdmFsdWUiOjUsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJib2R5X3lhd192YWx1ZSI6MjIsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOnRydWV9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6dHJ1ZSwieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJSYW5kb20iLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjp0cnVlLCJib2R5X3lhdyI6IkppdHRlciIsInlhdyI6IjE4MCIsInlhd192YWx1ZSI6NSwieWF3X2ppdHRlcl92YWx1ZSI6LTcwLCJ5YXdfaml0dGVyIjoiU2tpdHRlciIsImJvZHlfeWF3X3ZhbHVlIjo0MywicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZX1dXQ==") end)
    },

    visuals = {
        accent_color = group:label("\a869CC3FF{OV} Accent color", {hex_to_rgba(pui.accent)}),
        indicators = group:checkbox("\a869CC3FF{OV} Indicators"),
        watermark = group:checkbox("\a869CC3FF{OV} Watermark"),
        defensive_indicator = group:checkbox("\a869CC3FF{OV} Defensive indicator"),
        console_color_changer = group:checkbox("\a869CC3FF{OV} Console color changer", {hex_to_rgba("47484ED8")}),
    },

    misc = {
        console_filter = group:checkbox("\a869CC3FF{OV} Console filter"),
        discharge = group:checkbox("\a869CC3FF{OV}\affffffff Discharge exploit \a4f4f4fff[only scout & awp]"),
        shittalking = group:checkbox("\a869CC3FF{OV} Trashtalk"),
        st_when = group:multiselect("\n     ", "Kill", "Death", "Revenge"),
        shot_logs = group:checkbox("\a869CC3FF{OV} Aimbot logs"),
        anim_breakers_enable = group:checkbox("\a869CC3FF{OV} \aafaf62ffAnimation breakers"),
        anim_breakers = group:multiselect("\n        ", "Leg animation", "Landing pitch"),
        anim_breakers_move = group:combobox("Move legs type", "-", "Static", "Walking"),
        anim_breakers_air = group:combobox("Air legs type", "-", "Static", "Walking")
    }
}

aa_builder = {}
aa_builder_defensive = {}

for i = 1, 7 do
    aa_builder[i] = {}
    aa_builder[i].override = group:checkbox("Override \v"..aa_state_full[i].."\r player state")
    aa_builder[i].pitch = group:combobox("\v"..aa_state_full[i].."\r  Pitch", "Off", "Down", "Up")
    aa_builder[i].yaw_base = group:combobox("\v"..aa_state_full[i].."\r  Yaw base", "Local view", "At targets")
    aa_builder[i].yaw = group:combobox("\v"..aa_state_full[i].."\r  Yaw", "Off", "180", "Spin")
    aa_builder[i].yaw_value = group:slider("\v"..aa_state_full[i].."\r  yaw offset", -180, 180, 0)
    aa_builder[i].yaw_jitter = group:combobox("\v"..aa_state_full[i].."\r  Yaw jitter", "Off", "Offset", "Center", "Random", "Skitter")
    aa_builder[i].yaw_jitter_value = group:slider("\v"..aa_state_full[i].."\r  Yaw jitter  ", -180, 180, 0)
    aa_builder[i].body_yaw = group:combobox("\v"..aa_state_full[i].."\r  Body yaw", "Off", "Opposite", "Jitter", "Static")
    aa_builder[i].body_yaw_value = group:slider("\v"..aa_state_full[i].."\r  Body yaw value ", -180, 180, 0)
    aa_builder[i].freestand_body_yaw = group:checkbox("\v"..aa_state_full[i].."\r  Freestanding body yaw")

    aa_builder_defensive[i] = {}
    aa_builder_defensive[i].defensive_modifiers = group:checkbox("\v"..aa_state_full[i].."\r  Defensive modifiers")
    aa_builder_defensive[i].force_defensive = group:checkbox("\v"..aa_state_full[i].."\r  Force defensive")
    aa_builder_defensive[i].defensive_aa_enable = group:checkbox("\v"..aa_state_full[i].."\r  Defensive anti-aim")
    aa_builder_defensive[i].pitch = group:combobox("\v"..aa_state_full[i].."\r  Defensive pitch", "Off", "Down", "Up", "Random", "Custom")
    aa_builder_defensive[i].pitch_value = group:slider("\v"..aa_state_full[i].."\r  Defensive pitch value", -89, 89, 0)
    aa_builder_defensive[i].yaw_base = group:combobox("\v"..aa_state_full[i].."\r  Defensive yaw base", "Local view", "At targets")
    aa_builder_defensive[i].yaw = group:combobox("\v"..aa_state_full[i].."\r  Defensive yaw", "Off", "180", "Spin")
    aa_builder_defensive[i].yaw_value = group:slider("\v"..aa_state_full[i].."\r  Defensive yaw offset", -180, 180, 0)
    aa_builder_defensive[i].yaw_jitter = group:combobox("\v"..aa_state_full[i].."\r  Defensive yaw jitter", "Off", "Offset", "Center", "Random", "Skitter")
    aa_builder_defensive[i].yaw_jitter_value = group:slider("\v"..aa_state_full[i].."\r  Defensive yaw jitter  ", -180, 180, 0)
    aa_builder_defensive[i].body_yaw = group:combobox("\v"..aa_state_full[i].."\r  Defensive body yaw", "Off", "Opposite", "Jitter", "Static")
    aa_builder_defensive[i].body_yaw_value = group:slider("\v"..aa_state_full[i].."\r  Defensive body yaw value ", -180, 180, 0)
end

-- [ visiblity ]
ui.set_visible(_ui.lua.tab.ref, false)
-- start
_ui.lua.enable:depend({_ui.lua.tab, "Start"})
for k,v in pairs(_ui.start) do v:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Start"}) end

-- antiaim
_ui.antiaim.enable:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"})
_ui.antiaim.tab:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true})
_ui.antiaim.condition:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"})
for i = 1, 7 do
    aa_builder[i].override:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]})
    aa_builder[i].pitch:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].yaw_base:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].yaw_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].yaw, "180", "Spin"})
    aa_builder[i].yaw_jitter:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].yaw, "180", "Spin"})
    aa_builder[i].yaw_jitter_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].yaw_jitter, "Offset", "Center", "Random", "Skitter"}, {aa_builder[i].yaw, "180", "Spin"})
    aa_builder[i].body_yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].body_yaw_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].body_yaw, "Jitter", "Static"})
    aa_builder[i].freestand_body_yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].body_yaw, "Opposite", "Jitter", "Static"})

    aa_builder_defensive[i].defensive_modifiers:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder_defensive[i].force_defensive:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true})
    aa_builder_defensive[i].defensive_aa_enable:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true})
    aa_builder_defensive[i].pitch:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].pitch_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].pitch, "Custom"}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].yaw_base:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].yaw_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder_defensive[i].yaw, "180", "Spin"}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].yaw_jitter:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true}, {aa_builder_defensive[i].yaw, "180", "Spin"})
    aa_builder_defensive[i].yaw_jitter_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder_defensive[i].yaw_jitter, "Offset", "Center", "Random", "Skitter"}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true}, {aa_builder_defensive[i].yaw, "180", "Spin"})
    aa_builder_defensive[i].body_yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].body_yaw_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Builder"}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder_defensive[i].body_yaw, "Jitter", "Static"}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
end
for k,v in pairs({_ui.antiaim.tweaks, _ui.antiaim.freestanding, _ui.antiaim.edge_yaw, _ui.antiaim.manual_right, _ui.antiaim.manual_left, _ui.antiaim.cfg_export, _ui.antiaim.cfg_import, _ui.antiaim.cfg_reset, _ui.antiaim.cfg_default}) do v:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.tab, "Settings"}) end

-- visuals
for k,v in pairs({_ui.visuals.accent_color, _ui.visuals.indicators, _ui.visuals.defensive_indicator, _ui.visuals.watermark, _ui.visuals.console_color_changer}) do v:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Visuals"}) end

-- misc
for k,v in pairs({_ui.misc.console_filter, _ui.misc.discharge, _ui.misc.anim_breakers_enable, _ui.misc.shittalking, _ui.misc.shot_logs}) do v:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Miscellaneous"}) end
for k,v in pairs({_ui.misc.anim_breakers_air, _ui.misc.anim_breakers_move}) do v:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Miscellaneous"}, {_ui.misc.anim_breakers, "Leg animation"}, {_ui.misc.anim_breakers_enable, true}) end
_ui.misc.anim_breakers:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Miscellaneous"}, {_ui.misc.anim_breakers_enable, true})
_ui.misc.st_when:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Miscellaneous"}, {_ui.misc.shittalking, true})
-- hide refs
local hide_refs = function(value)
    value = not value
    ui.set_visible(ref.aa_enable, value) ui.set_visible(ref.pitch, value) ui.set_visible(ref.pitch_value, value)
    ui.set_visible(ref.yaw_base, value) ui.set_visible(ref.yaw, value) ui.set_visible(ref.yaw_value, value)
    ui.set_visible(ref.yaw_jitter, value) ui.set_visible(ref.yaw_jitter_value, value) ui.set_visible(ref.body_yaw, value)
    ui.set_visible(ref.body_yaw_value, value) ui.set_visible(ref.edgeyaw, value) ui.set_visible(ref.freestand[1], value)
    ui.set_visible(ref.freestand[2], value) ui.set_visible(ref.roll, value) ui.set_visible(ref.freestand_body_yaw, value)
end

-- [ config system ]
local config_items = {
    _ui.antiaim,
    aa_builder,
    aa_builder_defensive
}

local package, data, encrypted, decrypted = pui.setup(config_items), "", "", ""
config = {}

config.export = function()
    data = package:save()
    encrypted = base64.encode(json.stringify(data))
    clipboard_export(encrypted)

    setup_notification("config exported", true)
end

config.import = function(input)
    decrypted = json.parse(base64.decode(input ~= nil and input or clipboard_import()))
    package:load(decrypted)

    setup_notification("config loaded", true)
end

-- [ discord verification ]


-- [ custom menu control ]
local start_tab_active, antiaim_tab_active, visuals_tab_active, misc_tab_active = true, false, false, false
local custom_menu_control = function()
    if not _ui.lua.enable.value or (get_menu_alpha() < 2) or not ui.is_menu_open() then return end

    local clr_r, clr_g, clr_b = _ui.visuals.accent_color.color:get() 
    local x, y = ui.menu_position()
    local w, h = ui.menu_size()
    
    if client.key_state("0x01") then
        if in_bounds(x + 146 + w/2 - 330, y - 44, x + 210 + w/2 - 330, y - 20) then
            start_tab_active, antiaim_tab_active, visuals_tab_active, misc_tab_active = true, false, false, false
            ui.set(_ui.lua.tab.ref, "Start")
        elseif in_bounds(x + 270 + w/2 - 330, y - 44, x + 360 + w/2 - 330, y - 20) then
            start_tab_active, antiaim_tab_active, visuals_tab_active, misc_tab_active = false, true, false, false
            ui.set(_ui.lua.tab.ref, "Anti-aim")
        elseif in_bounds(x + 421 + w/2 - 330, y - 44, x + 505 + w/2 - 330, y - 20) then
            start_tab_active, antiaim_tab_active, visuals_tab_active, misc_tab_active = false, false, true, false
            ui.set(_ui.lua.tab.ref, "Visuals")
        elseif in_bounds(x + 564 + w/2 - 330, y - 44, x + 615 + w/2 - 330, y - 20) then
            start_tab_active, antiaim_tab_active, visuals_tab_active, misc_tab_active = false, false, false, true
            ui.set(_ui.lua.tab.ref, "Miscellaneous")
        end
    end

    renderer.rectangle(x, y - 56, w, 51, 0, 0, 0, get_menu_alpha())
    renderer.rectangle(x + 1, y - 55, w - 2, 49, 62, 62, 62, get_menu_alpha())
    renderer.rectangle(x + 2, y - 54, w - 4, 47, 42, 42, 42, get_menu_alpha())
    renderer.rectangle(x + 5, y - 51, w - 10, 41, 62, 62, 62, get_menu_alpha())
    renderer.rectangle(x + 6, y - 50, w - 12, 39, 12, 12, 12, get_menu_alpha())

    renderer.rectangle(x + 110, y - 43, w - 120, 28, 58, 58, 58, get_menu_alpha())
    renderer.rectangle(x + 111, y - 42, w - 122, 26, 28, 28, 28, get_menu_alpha())

    renderer.gradient(x + 7, y - 49, w - 14, 2, clr_r, clr_g, clr_b, get_menu_alpha(), clr_r, clr_g, clr_b, get_menu_alpha(), true)

    animated_text(x + 12, y - 44, -7, {r=clr_r, g=clr_g, b=clr_b, a=get_menu_alpha()}, {r=clr_r, g=clr_g, b=clr_b, a=get_menu_alpha()}, "+", "OverStar")

    renderer.text(x + 146 + w/2 - 330, y - 44, start_tab_active and clr_r or 100, start_tab_active and clr_g or 100, start_tab_active and clr_b or 100, get_menu_alpha(), "+", nil, "START")
    renderer.text(x + 270 + w/2 - 330, y - 44, antiaim_tab_active and clr_r or 100, antiaim_tab_active and clr_g or 100, antiaim_tab_active and clr_b or 100, get_menu_alpha(), "+", nil, "ANTIAIM")
    renderer.text(x + 421 + w/2 - 330, y - 44, visuals_tab_active and clr_r or 100, visuals_tab_active and clr_g or 100, visuals_tab_active and clr_b or 100, get_menu_alpha(), "+", nil, "VISUALS")
    renderer.text(x + 564 + w/2 - 330, y - 44, misc_tab_active and clr_r or 100, misc_tab_active and clr_g or 100, misc_tab_active and clr_b or 100, get_menu_alpha(), "+", nil, "MISC")
end

-- [notifications]
local renderer_notification = function()
    local add_y = 0
    local x, y = client.screen_size()
    local frametime = globals.frametime() * 100
    local position_x = _ui.start.notifications_position.value == "Upper-left" and 5 or x/2
    local position_y = _ui.start.notifications_position.value == "Upper-left" and 5 or y/2 + 150
    local r,g,b = _ui.visuals.accent_color.color:get()

    for i, v in ipairs(tables.notifications) do
        local clr_r, clr_g, clr_b = v.color and r or 255, v.color and g or 103, v.color and b or 103
        v.timer = v.timer + (0.19*vector(renderer.measure_text(nil, "overstar   » "..v.string)).x*0.0115)*frametime

        if math.max(0,(renderer.measure_text(nil, "overstar   » "..v.string) + 1 - v.timer)) > 0 then
            v.alpha = animations.math_lerp(v.alpha, 1, frametime)
        end
    
        renderer.rectangle((_ui.start.notifications_position.value == "Upper-left" and position_x or position_x - renderer.measure_text(nil, "overstar   » "..v.string)/2) - 3, (position_y + add_y) - 3, renderer.measure_text(nil, "overstar   » "..v.string) + 5, 23, 0,0,0,v.alpha*100)
        renderer.rectangle((_ui.start.notifications_position.value == "Upper-left" and position_x or position_x - renderer.measure_text(nil, "overstar   » "..v.string)/2) - 1, (position_y + add_y) + 16, renderer.measure_text(nil, "overstar   » "..v.string) + 1, 2, 0,0,0,v.alpha*255)
        renderer.rectangle((_ui.start.notifications_position.value == "Upper-left" and position_x or position_x - renderer.measure_text(nil, "overstar   » "..v.string)/2) - 1, (position_y + add_y) + 16, math.max(0,(renderer.measure_text(nil, "overstar   » "..v.string) + 1 - v.timer)), 2, clr_r ,clr_g ,clr_b ,v.alpha*255)

        renderer.text(_ui.start.notifications_position.value == "Upper-left" and position_x or position_x - renderer.measure_text(nil,  "overstar   » ")/2 - renderer.measure_text(nil, v.string)/2, position_y + add_y, clr_r, clr_g, clr_b, v.alpha*255, nil, 0, "overstar  »")
        renderer.text(_ui.start.notifications_position.value == "Upper-left" and position_x + 58 or position_x - renderer.measure_text(nil, v.string)/2 + renderer.measure_text(nil, "overstar   » ")/2, position_y + add_y, 255, 255, 255, v.alpha*255, nil, 0, v.string)

        if math.max(0,(renderer.measure_text(nil, "overstar   » "..v.string) + 1 - v.timer)) == 0 or #tables.notifications > _ui.start.max_notifications.value then
            v.alpha = animations.math_lerp(v.alpha, 0, frametime)
        end

        if v.alpha < 0.01 or #tables.notifications > _ui.start.max_notifications.value then
            table.remove(tables.notifications, i)
        end

        add_y = math.floor(add_y + _ui.start.notifications_spacing.value * v.alpha)
    end
end

-- [ antiaim features ]
local right_dir, left_dir = false
local function manual_direction()
    if ui.get(_ui.antiaim.manual_right.ref) then
        if right_dir == true and vars.last_press_t + 0.07 < globals.realtime() then
            right_dir = false
            left_dir = false
        elseif right_dir == false and vars.last_press_t + 0.07 < globals.realtime() then
            right_dir = true
            left_dir = false
        end
        vars.last_press_t = globals.realtime()
    elseif ui.get(_ui.antiaim.manual_left.ref) then
        if left_dir == true and vars.last_press_t + 0.07 < globals.realtime() then
            back_dir = true
            left_dir = false
        elseif left_dir == false and vars.last_press_t + 0.07 < globals.realtime() then
            left_dir = true
            right_dir = false
        end
        vars.last_press_t = globals.realtime()
    end

    return right_dir, left_dir
end

local safe_head_active = false
local antiaim_features = function(cmd)
    if not _ui.antiaim.enable.value or not _ui.lua.enable.value or not entity.get_local_player() then return end

    local state = get_state(get_velocity())
    local players = entity.get_players(true)
    local get_override = aa_builder[state].override.value and state or 1
    local right_dir, left_dir = manual_direction()

    ui.set(ref.roll, 0)
    ui.set(ref.freestand[2], "always on")

    -- antiaim builder
    for k, v in pairs(ref) do
        local key = (is_defensive_active() and not choking(cmd) and aa_builder_defensive[get_override].defensive_modifiers.value and aa_builder_defensive[get_override].defensive_aa_enable.value) and aa_builder_defensive[get_override][k] or aa_builder[get_override][k]
        
        if key then
            ui.set(v, key.value)
        end
    end

    -- safe head
    if contains(_ui.antiaim.tweaks.value, "Safe head") then
        for i, v in pairs(players) do
            local local_player_origin = vector(entity.get_origin(entity.get_local_player()))
            local player_origin = vector(entity.get_origin(v))
            local difference = (local_player_origin.z - player_origin.z)
            local local_player_weapon = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))

            if ((local_player_weapon == "CKnife" and state == 5 and difference > -70) or difference > 65) then    
                if not is_defensive_active() then
                    ui.set(ref.pitch, "down")
                    ui.set(ref.yaw, "180")
                    ui.set(ref.yaw_value, -1)
                    ui.set(ref.yaw_base, "At targets")
                    ui.set(ref.yaw_jitter, "Off")
                    ui.set(ref.body_yaw, "Static")
                    ui.set(ref.body_yaw_value, 0)
                    ui.set(ref.freestand_body_yaw, false)
                end

                safe_head_active = true
            else
                safe_head_active = false
            end
        end
    end
    
    -- anti-backstab
    if contains(_ui.antiaim.tweaks.value, "Anti-backstab") then
        for i, v in pairs(players) do
            local player_weapon = entity.get_classname(entity.get_player_weapon(v))
            local player_distance = math.floor(vector(entity.get_origin(v)):dist(vector(entity.get_origin(entity.get_local_player()))) / 7)

            if player_weapon == "CKnife" then
                if player_distance < 25 then
                    ui.set(ref.yaw, "180")
                    ui.set(ref.yaw_value, -180)
                    ui.set(ref.yaw_base, "At targets")
                    ui.set(ref.yaw_jitter, "Off")
                end
            end
        end
    end

    -- warmup preset
    if contains(_ui.antiaim.tweaks.value, "Warmup preset") and entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") then
        ui.set(ref.yaw, "180")
        ui.set(ref.yaw_value, 0)
        ui.set(ref.yaw_base, "At targets")
        ui.set(ref.yaw_jitter, "Skitter")
        ui.set(ref.yaw_jitter_value, 70)
    end

    -- fakelag on shot
    if contains(_ui.antiaim.tweaks.value, "Modify fakelag on shot") then
        if vars.in_attack > globals.realtime() then
            ui.set(ref.fl, 1)
        else
            ui.set(ref.fl, 15)
        end
    end

    -- manuals
    if right_dir then
        ui.set(ref.yaw, "180")
        ui.set(ref.yaw_value, 90)
    elseif left_dir then
        ui.set(ref.yaw, "180")
        ui.set(ref.yaw_value, -90)
    end

    -- force defensive
    cmd.force_defensive = aa_builder_defensive[get_override].defensive_modifiers.value and aa_builder_defensive[get_override].force_defensive.value and true

    -- binds
    ui.set(ref.freestand[1], ui.get(_ui.antiaim.freestanding.ref) and true or false)
    ui.set(ref.edgeyaw, ui.get(_ui.antiaim.edge_yaw.ref) and true or false)
end

-- [ indicators ]
local anim_ind = {dt_alpha = 0, osaa_alpha = 0, dt_osaa_pos_mod = 0, fstand_alpha = 0, fstand_pos_mod = 0, dmg_alpha = 0, scope = 0}
local indicators = function()
    if not _ui.visuals.indicators.value or not entity.get_local_player() then return end

    local x, y = client.screen_size()
    local clr_r, clr_g, clr_b = _ui.visuals.accent_color.color:get()
    local frametime = globals.frametime() * 15

    anim_ind.dt_alpha = d_lerp(anim_ind.dt_alpha, ui.get(ref.doubletap[2]) and 1 or 0, frametime)
    anim_ind.osaa_alpha = d_lerp(anim_ind.osaa_alpha, (ui.get(ref.osaa[2]) and not ui.get(ref.doubletap[2])) and 1 or 0, frametime)
    anim_ind.dt_osaa_pos_mod = d_lerp(anim_ind.dt_osaa_pos_mod, (ui.get(ref.osaa[2]) or ui.get(ref.doubletap[2])) and 1 or 0, frametime)
    anim_ind.fstand_alpha = d_lerp(anim_ind.fstand_alpha, ui.get(_ui.antiaim.freestanding.ref) and 1 or 0, frametime)
    anim_ind.fstand_pos_mod = d_lerp(anim_ind.fstand_pos_mod,  ui.get(_ui.antiaim.freestanding.ref) and 1 or 0, frametime)
    anim_ind.dmg_alpha = d_lerp(anim_ind.dmg_alpha, ui.get(ref.damage[2]) and 1 or 0, frametime)
    anim_ind.scope = d_lerp(anim_ind.scope, entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1 and 1 or 0, frametime)

    animated_text(x/2 - renderer.measure_text("b", "overstar")/2 + anim_ind.scope*40, y/2 + 15, 7, {r=clr_r, g=clr_g, b=clr_b, a=255}, {r=50, g=50, b=50, a=255}, "b", "overstar")

    -- fhw9ufh984hf89
    if anim_ind.dt_alpha > 0.2 then
        renderer.text(x/2 - renderer.measure_text("-", "DT")/2 + anim_ind.scope*40, y/2 + 27, 255,255,255, anim_ind.dt_alpha*255, "-", 0, "DT")
    end

    if anim_ind.osaa_alpha > 0.2 then
        renderer.text(x/2 - renderer.measure_text("-", "OS-AA")/2 + anim_ind.scope*40, y/2 + 27, 255,255,255, anim_ind.osaa_alpha*255, "-", 0, "OS-AA")
    end
    
    if anim_ind.fstand_alpha > 0.2 then
        renderer.text(x/2 - renderer.measure_text("-", "FS")/2 + anim_ind.scope*40, y/2 + 27 + anim_ind.dt_osaa_pos_mod*10, 255,255,255, anim_ind.fstand_alpha*255, "-", 0, "FS")
    end

    if anim_ind.dmg_alpha > 0.2 then
        renderer.text(x/2 - renderer.measure_text("-", "DMG")/2 + anim_ind.scope*40, y/2 + 27 + anim_ind.dt_osaa_pos_mod*10 + anim_ind.fstand_pos_mod*10, 255,255,255, anim_ind.dmg_alpha*255, "-", 0, "DMG")
    end
end

-- [ watermark ]
local watermark = function()
    if not _ui.visuals.watermark.value then return end

    local x, y = client.screen_size()
    local clr_r, clr_g, clr_b = _ui.visuals.accent_color.color:get()

    animated_text(x/2 - renderer.measure_text("b", "O V E R S T A R ")/2, y - 35,5, {r=clr_r, g=clr_g, b=clr_b, a=255}, {r=25, g=25, b=22, a=255}, "b", "O V E R S T A R ")
    animated_text(x/2 - renderer.measure_text("b", "[LIVE]")/2, y - 22, 5, {r=clr_r, g=clr_g, b=clr_b, a=22}, {r=255, g=22, b=22, a=255}, "b", "[LIVE]")
end

local defensive_charge = 0
local anim_di = {scope = 0}
local defensive_indicator = function()
    if not _ui.visuals.defensive_indicator.value or not ui.get(ref.doubletap[2]) or not entity.get_local_player() then return end

    local x, y = client.screen_size()
    local clr_r, clr_g, clr_b = _ui.visuals.accent_color.color:get()
    local frametime = globals.frametime() * 15
    defensive_charge = math.min(math.max(0, is_defensive_active() and defensive_charge + 5 or defensive_charge - 7), 96)
    anim_di.scope = d_lerp(anim_di.scope, entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1 and 1 or 0, frametime)

    renderer.text(x/2 - renderer.measure_text("", "defensive choking")/2 + anim_di.scope*30, y/2 - 260, 255,255,255, math.min(255, defensive_charge*3), "", 0, "defensive choking")
    renderer.rectangle(x/2 - 50 + anim_di.scope*55, y/2 - 246, 100, 4, 0,0,0, math.min(255, defensive_charge*3))
    renderer.rectangle(x/2 - 48 + anim_di.scope*55, y/2 - 245, defensive_charge, 2, clr_r, clr_g, clr_b, math.min(255, defensive_charge*3))
end

-- [ console filter ]
ui.set_callback(_ui.misc.console_filter.ref, function()
    cvar.con_filter_text:set_string("cool text")
    cvar.con_filter_enable:set_int(1)
end)

-- [ auto discharge exploit ]
local auto_discharge = function(cmd)
    if not _ui.misc.discharge.value or not _ui.lua.enable.value or ui.get(ref.quick_peek[2]) or not ui.get(ref.doubletap[2]) or 
    (entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponSSG08" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponAWP") then return end

    local vel_2 = math.floor(entity.get_prop(entity.get_local_player(), "m_vecVelocity[2]"))

    if is_vulnerable() and vel_2 > 20 then
        cmd.in_jump = false
        cmd.discharge_pending = true
    end
end

-- [animation breakers]
local char_ptr = ffi.typeof('char*')
local nullptr = ffi.new('void*')
local class_ptr = ffi.typeof('void***')
local animation_layer_t = ffi.typeof([[
    struct {										char pad0[0x18];
        uint32_t	sequence;
        float		prev_cycle;
        float		weight;
        float		weight_delta_rate;
        float		playback_rate;
        float		cycle;
        void		*entity;						char pad1[0x4];
    } **
]])

local animation_breakers = function()
    if not _ui.misc.anim_breakers_enable.value or not entity.get_local_player() then return end

    local pEnt = ffi.cast(class_ptr, native_GetClientEntity(entity.get_local_player()))
    if pEnt == nullptr then return end
    local anim_layers = ffi.cast(animation_layer_t, ffi.cast(char_ptr, pEnt) + 0x2990)[0][6]
    local state = get_state(get_velocity())
    
    if contains(_ui.misc.anim_breakers.value, "Leg animation") then
        if _ui.misc.anim_breakers_move.value == "Static" then
            ui.set(ref.legs, "Always slide")
            entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 1, 0)
        elseif _ui.misc.anim_breakers_move.value == "Walking" then
            entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 0.5, 7)
            ui.set(ref.legs, 'Never slide')
        end

        if state == 4 or state == 5 then
            if _ui.misc.anim_breakers_air.value == "Static" then
                entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 1, 6)
            elseif _ui.misc.anim_breakers_air.value == "Walking" then
                anim_layers.weight = 1
            end
        end
    end

    if contains(_ui.misc.anim_breakers.value, "Landing pitch") and ground_tick > 5 and ground_tick < 100 then
        entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 0.5, 12)
    end
end

-- [ shit-talking ]
local phrases = {
    kill = {
        "◣_◢ dont talking pls",
      
        "when u miss, cry u dont hev overstar.dev",
        "you think you are is good but im best 1",
        "fokin dog, get ownet by Создатель js rezolver",
        "if im lose = my team is dog",
        "never talking bad to me again, im always top1",
        "umad that you're miss? hs dog",
        "vico (top1 eu) vs all kelbs on hvh.",
        "you is mad that im ur papi?",
        "im will rape u're mother after i killed you",
        "stay mad that im unhitable",
        "god night brother, cya next raund ;)",
        "get executed from presidend of argentina",
        "you thinking ur have chencse vs boss?",
        "i killed gejmsense, now im kill you",
        "by luckbaysed config, cya twitter bro o/",
        "cy@ https://gamesense.pub/forums/viewforum.php?id=6",
        "╭∩╮(◣_◢)╭∩╮(its fuck)",
        "dont play vs me on train, im live there -.-",
        "by top1 uzbekistan holder umed?",
        "courage for play de_shortnuke vs me, my home there.",
        "bich.. dont test g4ngst3r in me.",
        "im rich princ here, dont toxic dog.",
        "for all thet say gamesense best, im try on parsec and is dog.",
        "WEAK DOG sanchezj vs ru bossman (owned on mein map)",
        "im want gamesense only for animbrejker, neverlose always top.",
        "this dog brandog thinking hes top, but reality say no.",
        "fawk you foking treny",
        "ur think ur good but its falsee.",
        "topdog nepbot get baits 24/7 -.-",
        "who this bot malva? im own him 9-0",
        "im beat all romania dogs with 1 finker",
        "im rejp this dog noobers with no problems",
        "gamesense vico vs all -.-",
        "irelevent dog jompan try to stay popular but fail",
        "im user beta and ur dont, stay mad.",
        "dont talking, no overstar tech no talk pls",
        "when u miss, cry u dont hev overstar.dev",
        "you think you are is good but overstar is best",
        "fkn dog, get own by overstar js rezolver",
        "if you luse = no overstar issue",
        "never talking bad to me again, overstar boosing me to top1",
        "umad that you're miss? get overstar d0g",
        "stay med that im unhitable ft overstar",
        "get executed from overstar technology",
        "you thinking ur have chencse vs overstar?",
        "first i killed gejmsense, now overstar kill you",
        "by overstar boss aa, cya twitter bro o/",
        "cy@ spotlight",
        "courage for test resolve me. overstar always boosting",
    },

    death = {
        "ofc",
        "????"
    },

    revenge = {
        "1 STAY THE FUCK DOWN CLOWN",
        "whats up? what's down get around clown :D"
    }
}

local cur_phrase_kill, cur_phrase_death, cur_phrase_revenge, revenge_target = 1, 1, 1, nil client.set_event_callback("round_start", function(e) revenge_target = nil end)
client.set_event_callback("player_death", function(e)
    if not _ui.misc.shittalking.value then return end

    local who = client.userid_to_entindex(e.userid)
    local attacker = client.userid_to_entindex(e.attacker)

    local phrase_kill = phrases.kill[cur_phrase_kill]
    local phrase_death = phrases.death[cur_phrase_death]
    local phrase_revenge = phrases.revenge[cur_phrase_revenge]

    if entity.get_prop(who, "m_iTeamNum") == entity.get_prop(attacker, "m_iTeamNum") then return end

    if contains(_ui.misc.st_when.value, "Kill") and attacker == entity.get_local_player() then
        client.delay_call(client.random_int(0, 0.1), function() 
            client.exec("say "..phrase_kill)
            cur_phrase_kill = (cur_phrase_kill % #phrases.kill) + 1
        end)
    end

    if contains(_ui.misc.st_when.value, "Death") and who == entity.get_local_player() then
        client.delay_call(client.random_int(0, 0.1), function() 
            client.exec("say "..phrase_death)
            cur_phrase_death = (cur_phrase_death % #phrases.death) + 1
        end)
    end

    if contains(_ui.misc.st_when.value, "Revenge") then
        if who == entity.get_local_player() then
            revenge_target = attacker
        elseif who == revenge_target then
            client.delay_call(client.random_int(0, 0.1), function() 
                client.exec("say "..phrase_revenge)
                cur_phrase_revenge = (cur_phrase_revenge % #phrases.revenge) + 1
            end)
        end
    end
end)

-- [ shot logs ]
local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}

client.set_event_callback("aim_hit", function(e)
    if not _ui.misc.shot_logs.value then return end

    local who = entity.get_player_name(e.target)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local dmg = e.damage
    local health = entity.get_prop(e.target, "m_iHealth")
    local bt = globals.tickcount() - e.tick
    local hc = math.floor(e.hit_chance)
    local log = ""

    if health ~= 0 then
        log = string.lower(string.format("\afafafahurt \aC1EF49%s\afafafa in the \aC1EF49%s\afafafa for \aC1EF49%d\afafafa damage (\aC1EF49%d\afafafa hp remaining) [bt: \aC1EF49%d\afafafa, hc: \aC1EF49%d\afafafa%%.].",
        who, group, dmg, health, bt, hc))

    else 
        log = string.lower(string.format("\afafafakilled \aC1EF49%s\afafafa in the \aC1EF49%s\afafafa [bt: \aC1EF49%d\afafafa, hc: \aC1EF49%d\afafafa%%.].",
        who, group, bt, hc))
    end

    printc("\aC1EF49 overstar » "..log)
    setup_notification(string.lower(health ~= 0 and string.format("hurt %s in the %s for %d damage (%d hp remaining).", who, group, dmg, health) or string.format("killed %s in the %s.", who, group)), true)
end)

client.set_event_callback("aim_miss", function(e)
    if not _ui.misc.shot_logs.value then return end

    local who = entity.get_player_name(e.target)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local reason = e.reason
    local log = string.lower(string.format(
        "\afafafamissed in \aFF6767%s\afafafa's \aFF6767%s\afafafa due to \aFF6767%s\afafafa.",
        who, group, reason
    ))
    
    printc("\aFF6767 overstar » "..log)
    setup_notification(string.lower(string.format("Missed in %s's %s due to %s.", who, group, reason)), false)
end)

-- [ console color ]
local engine_client = ffi.cast(ffi.typeof("void***"), client.create_interface("engine.dll", "VEngineClient014"))
local console_is_visible = ffi.cast("console_is_visible", engine_client[0][11])
local materials = { "vgui_white", "vgui/hud/800corner1", "vgui/hud/800corner2", "vgui/hud/800corner3", "vgui/hud/800corner4" }
local console_color_changer = function()
    if not entity.get_local_player() then return end
    if (console_is_visible(engine_client)) then
        local r, g, b, a = 255, 255, 255, 255
        if _ui.visuals.console_color_changer.value then
            r, g, b, a = _ui.visuals.console_color_changer.color:get()
        end
        for i=1, #materials do 
            local mat = materials[i]
            materialsystem.find_material(mat):alpha_modulate(a)
            materialsystem.find_material(mat):color_modulate(r, g, b)
        end
    else
        for i=1, #materials do 
            local mat = materials[i]
            materialsystem.find_material(mat):alpha_modulate(255)
            materialsystem.find_material(mat):color_modulate(255, 255, 255)
        end
    end
end

-- [ callbacks ]
client.set_event_callback("paint_ui", function()
    if ui.is_menu_open() then
        hide_refs(_ui.lua.enable.value)
        ui.set_visible(aa_builder[1].override.ref, false) ui.set(aa_builder[1].override.ref, true)
        ui.set(_ui.start.session_text.ref, "Session time: \aC3C6FFFF"..get_elapsed_time())
    end

    indicators()
    watermark()
    defensive_indicator()
    custom_menu_control()
    renderer_notification()
    console_color_changer()
end)

client.set_event_callback("setup_command", function(cmd)
    antiaim_features(cmd)
    auto_discharge(cmd)
    prevent_mouse(cmd)
end)

client.set_event_callback("pre_render", function()
    animation_breakers()
end)

client.set_event_callback("aim_fire", function()
    if not contains(_ui.antiaim.tweaks.value, "Modify fakelag on shot") then return end
    vars.shot_time = globals.realtime()
    vars.in_attack = vars.shot_time + 0.035

    return vars.in_attack
end)

client.set_event_callback("shutdown", function()
    hide_refs(false)
end)