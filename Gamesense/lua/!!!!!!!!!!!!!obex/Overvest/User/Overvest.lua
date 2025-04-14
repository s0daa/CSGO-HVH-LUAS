-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local obex_data = obex_fetch and obex_fetch() or {username = 'unknown', build = 'live'}
local ffi = require 'ffi'
local surface = require 'gamesense/surface' or error('Failed to load script: surface library not found. Subscribe using the link and restart your game.\nLink: https://gamesense.pub/forums/viewtopic.php?id=18793')
local antiaim_funcs = require 'gamesense/antiaim_funcs' or error('Failed to load script: anti-aim library not found. Subscribe using the link and restart your game.\nLink: https://gamesense.pub/forums/viewtopic.php?id=29665')
local base64 = require 'gamesense/base64' or error('Failed to load script: anti-aim library not found. Subscribe using the link and restart your game.\nLink: https://gamesense.pub/forums/viewtopic.php?id=21619')
local c_entity = require 'gamesense/entity' or error('Failed to load script: anti-aim library not found. Subscribe using the link and restart your game.\nLink: https://gamesense.pub/forums/viewtopic.php?id=27529')
local network = require 'gamesense/http' or error('Failed to load script: anti-aim library not found. Subscribe using the link and restart your game.\nLink: https://gamesense.pub/forums/viewtopic.php?id=19253')
local colored_text = require 'colored_text'


local dpi = {}
local hitlog = {}
local hitlog_table = {}
local hitlog_id = 1
local rounded_log = {}
dpi.scaling = 1
dpi.flags = {'c', 'c'}

local menu_color = ui.reference('MISC', 'Settings', 'Menu color')

local lua_color = 'FFFFFFFF'

get_ref_color = function()
    local r, g, b, a = ui.get(menu_color)

    lua_color = string.format('%02X%02X%02X%02X', math.floor(r), math.floor(g), math.floor(b), math.floor(a))
end

get_ref_color()

local string = string.format('Welcome back, %s!', obex_data.username)
    table.insert(rounded_log, {
        text = string,
        loading = true
})

local string = string.format('Loaded version: %s | updated: 24.04.23', obex_data.build)
    table.insert(rounded_log, {
        text = string,
        loading = true
})

local tbl = {
    checker = 0,
    defensive = 0
}

dpi.run_scaling = function(value, value2)
    if not ui.get(value2) then
        dpi.scaling = 1
        dpi.flags[1], dpi.flags[2] = 'c-', 'c'
    else
        if ui.get(value) == '100%' then
            dpi.scaling = 1
            dpi.flags[1], dpi.flags[2] = 'cd-', 'cd'
        elseif ui.get(value) == '125%' then
            dpi.scaling = 1.25
            dpi.flags[1], dpi.flags[2] = 'cd-', 'cd'
        elseif ui.get(value) == '150%' then
            dpi.scaling = 1.50
            dpi.flags[1], dpi.flags[2] = 'cd-', 'cd'
        elseif ui.get(value) == '175%' then
            dpi.scaling = 1.75
            dpi.flags[1], dpi.flags[2] = 'cd-', 'cd'
        elseif ui.get(value) == '200%' then
            dpi.scaling = 2.0
            dpi.flags[1], dpi.flags[2] = 'cd-', 'cd'
        end
    end
end


ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);

    bool ReadFile(
            void*       hFile,
            char*       lpBuffer,
            unsigned long        nNumberOfBytesToRead,
            unsigned long*      lpNumberOfBytesRead,
            int lpOverlapped
    );

    typedef void*(__thiscall* get_client_entity_t)(void*, int);
]]


bind_argument = function(fn, arg)
    return function(...)
        return fn(arg, ...)
    end
end

local ffi_cast = ffi.cast
local interface_ptr = ffi.typeof('void***')
local latency_ptr = ffi.typeof('float(__thiscall*)(void*, int)')
local VGUI_System010 =  client.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi_cast(interface_ptr, VGUI_System010 )

local rawivengineclient = client.create_interface('engine.dll', 'VEngineClient014') or print('VEngineClient014 wasnt found', 2)
local ivengineclient = ffi_cast(interface_ptr, rawivengineclient) or print('rawivengineclient is nil', 2)
local is_in_game = ffi_cast('bool(__thiscall*)(void*)', ivengineclient[0][26]) or print('is_in_game is nil')
local get_net_channel_info = ffi_cast('void*(__thiscall*)(void*)', ivengineclient[0][78]) or print('ivengineclient is nil')

local get_clipboard_text_count = ffi_cast("get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi_cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi_cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")


local function this_call(call_function, parameters) return function(...) return call_function(parameters, ...) end end
local entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), client.create_interface("client.dll", "VClientEntityList003"))
local get_entity_address = this_call(ffi.cast("get_client_entity_t", entity_list_003[0][3]), entity_list_003)
local engine_sound_client = ffi.cast(ffi.typeof("uintptr_t**"), client.create_interface("engine.dll", "IEngineSoundClient003"))
local play_sound = bind_argument(ffi.cast("void*(__thiscall*)(void*, const char*, float, int, int, float)", engine_sound_client[0][12]), engine_sound_client)

local clipboard = {}
local char_array = ffi.typeof 'char[?]'

clipboard.set = function(...)
    local text = tostring(table.concat({ ... }))
    
    set_clipboard_text(VGUI_System, text, string.len(text))
end

clipboard.get = function()
    local clipboard_text_length = get_clipboard_text_count( VGUI_System )
    local clipboard_data = ""

  if clipboard_text_length > 0 then
      buffer = ffi.new("char[?]", clipboard_text_length)
      size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)

      get_clipboard_text( VGUI_System, 0, buffer, size )

      clipboard_data = ffi.string( buffer, clipboard_text_length-1 )
  end
  return clipboard_data
end


ref_dt, ref_dt_key = ui.reference('rage', 'aimbot', 'double tap')
ref_fakeduck = ui.reference('rage', 'other', 'duck peek assist')
def_min_dmg = ui.reference('rage', 'aimbot', 'minimum damage')
min_dmg, min_dmg_key, min_dmg_slider = ui.reference('rage', 'aimbot', 'minimum damage override')

ref_enabled = ui.reference('AA', 'Anti-aimbot angles', 'enabled')
ref_pitch, ref_pitch_offset = ui.reference('AA', 'Anti-aimbot angles', 'pitch')
ref_yawbase = ui.reference('AA', 'Anti-aimbot angles', 'yaw base')
ref_yaw, ref_yawoffset = ui.reference('AA', 'Anti-aimbot angles', 'yaw')
ref_jitter, ref_jitteroffset = ui.reference('AA', 'Anti-aimbot angles', 'yaw jitter')
ref_bodyyaw, ref_byawoffset = ui.reference('AA', 'Anti-aimbot angles', 'body yaw')
ref_bodystand = ui.reference('AA', 'Anti-aimbot angles', 'freestanding body yaw')
ref_edgeyaw = ui.reference('AA', 'Anti-aimbot angles', 'edge yaw')
ref_freestanding, ref_freestanding_key = ui.reference('AA', 'Anti-aimbot angles', 'freestanding')
ref_roll = ui.reference('AA', 'Anti-aimbot angles', 'roll')
fakepeek, fakepeek_key = ui.reference('aa', 'other', 'fake peek')

slowmotion, slowmotion_key = ui.reference('aa', 'other', 'slow motion')
legmovement = ui.reference('aa', 'other', 'leg movement')
hideshots, hideshots_key = ui.reference('aa', 'other', 'On shot anti-aim')
fakelag, fakelag_key = ui.reference("AA", "Fake lag", "Enabled")
fakelag_limit = ui.reference("AA", "Fake lag", "Limit")

dpi_scale = ui.reference('MISC', 'Settings', 'DPI scale')

hitlog.run = function(value, r, g, b, r1, g1, b1)
    value = value or 'sample text'
    r = r or 10
    g = g or 100
    b = b or 255
    r1 = r1 or 10
    g1 = g1 or 200
    b1 = b1 or 255
    colored_text:console(
        { { r, g, b }, {r1, g1, b1}, string.format("overvest")},
        { {100, 100, 100}, ' . '},
        { {255, 255, 255}, value},
        { { 255, 255, 255}, '\n'}
    );
end

local animation = {data = {}}

animation.lerp = function(start, end_pos, time)
    if type(start) == 'userdata' then
        local color_data = {0, 0, 0, 0}

        for i, color_key in ipairs({'r', 'g', 'b', 'a'}) do
            color_data[i] = animation.lerp(start[color_key], end_pos[color_key], time)
        end

        return color(unpack(color_data))
    end

    return (end_pos - start) * (globals.frametime() * time * 175) + start
end

animation.new = function(name, value, time)
    if animation.data[name] == nil then
        animation.data[name] = value
    end

    animation.data[name] = animation.lerp(animation.data[name], value, time)

    return math.floor(animation.data[name])
end

local normalize_yaw = function(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

get_velocity = function(player)
    local x,y,z = entity.get_prop(player, 'm_vecVelocity')
    if x == nil then return end
    return math.sqrt(x*x + y*y + z*z)
end

local onground_ticks = 0
local var = 
{
    info = 
    {
        date = '20.04.2023'
    },

    classnames = {
        "CWorld",
        "CCSPlayer",
        "CFuncBrush"
    },

    Custom = {},

    is_dt = function()

        local dt = false
    
        local local_player = entity.get_local_player()
    
        if local_player == nil then
            return
        end
    
        if not entity.is_alive(local_player) then
            return
        end
    
        local active_weapon = entity.get_prop(local_player, 'm_hActiveWeapon')
    
        if active_weapon == nil then
            return
        end
    
        nextAttack = entity.get_prop(local_player,'m_flNextAttack')
        nextShot = entity.get_prop(active_weapon,'m_flNextPrimaryAttack')
        nextShotSecondary = entity.get_prop(active_weapon,'m_flNextSecondaryAttack')
    
        if nextAttack == nil or nextShot == nil or nextShotSecondary == nil then
            return
        end
    
        nextAttack = nextAttack + 0.5
        nextShot = nextShot + 0.5
        nextShotSecondary = nextShotSecondary + 0.5
    
    
        if ui.get(ref_dt) and ui.get(ref_dt_key) then
            if math.max(nextShot,nextShotSecondary) < nextAttack then
                if nextAttack - globals.curtime() > 0.00 then
                    dt = false 
                else
                    dt = true 
                end
            else 
                if math.max(nextShot,nextShotSecondary) - globals.curtime() > 0.00  then
                    dt = false 
                else
                    if math.max(nextShot,nextShotSecondary) - globals.curtime() < 0.00  then
                        dt = true 
                    else
                        dt = true 
                    end
                end
            end
        end
    
        return dt
    end,

    states = 
    {
        player_state = {[1] = 'Default',[2] = 'Standing',[3] = 'Moving',[4] = 'Slow motion',[5] = 'Crouch' ,[6] =  'Air',[7] =  'Air+Crouch',[8] =  'In use',[9] =  'No exploit', [10] = 'Defensive'},
        player_state_menu = {
            [1] = '[\a' .. lua_color .. 'G\aCDCDCDFF]',
            [2] = '[\a' .. lua_color .. 'S\aCDCDCDFF]',
            [3] = '[\a' .. lua_color .. 'M\aCDCDCDFF]',
            [4] = '[\a' .. lua_color .. 'SM\aCDCDCDFF]',
            [5] = '[\a' .. lua_color .. 'C\aCDCDCDFF]' ,
            [6] =  '[\a' .. lua_color .. 'A\aCDCDCDFF]',
            [7] =  '[\a' .. lua_color .. 'AC\aCDCDCDFF]',
            [8] =  '[\a' .. lua_color .. 'U\aCDCDCDFF]',
            [9] =  '[\a' .. lua_color .. 'NE\aCDCDCDFF]',
            [10] = '[\a' .. lua_color .. 'DF\aCDCDCDFF]'},

        is_standing = function(player)
            return get_velocity(player) < 3
        end,

        is_running = function(player)
            return get_velocity(player) > 3
        end,

        is_slowmotion = function()
            if ui.get(slowmotion) and ui.get(slowmotion_key) then
                return true end
        end,

        is_terrorist = function(player)
            local m_iTeamNum = entity.get_prop(player, 'm_iTeamNum')

            if m_iTeamNum == 2 then
                return true
            end
        end,

        is_SWAT = function(player)
            local m_iTeamNum = entity.get_prop(player, 'm_iTeamNum')

            if m_iTeamNum == 3 then
                return true
            end
        end,

        is_crouching = function(player)
            local flags = entity.get_prop(player, 'm_fFlags')

            if bit.band(flags, 4) == 4 then
                return true
            end
        end,

        on_ground = function(player, cmd)
            if cmd.in_jump == 1 then return end

            local onground = bit.band(entity.get_prop(player, "m_fFlags"), 1)

            if onground == 1 then
                onground_ticks = onground_ticks + 1
            else
                onground_ticks = 0
            end
            
            return onground_ticks > 1
        end,

        in_use = function()
            return client.key_state(0x45)
        end,

        no_exploit = function()
            local active = (ui.get(ref_dt) and ui.get(ref_dt_key)) or (ui.get(hideshots) and ui.get(hideshots_key))
            return not active
        end,
    },
}


local anims = {}

anims.lerp = function(x, v, t)
    local delta = v - x;

    if math.abs(delta) < 0.005 then
        return v
    end

    return x + delta * t
end

local function contains( tab, val )
    for i = 1, #tab do
        if tab[ i ] == val then
            return true
        end
    end
    
    return false
end

local scrn_x, scrn_y = client.screen_size()


local enable_lua = ui.new_checkbox('LUA', 'b', '» \a' .. lua_color .. 'overvest\aFFFFFFFF.gs')
local lua_tab = ui.new_combobox('LUA', 'b', 'Selection', {'General', 'Anti-aim', 'Anti-aim misc', 'Misc', 'Colors'})


local export = ui.new_button('LUA', 'b', '\a9FCA2BFFExport \aFFFFFFFFconfig', function() end)
local import = ui.new_button('LUA', 'b', '\a00A5FFFFImport \aFFFFFFFFconfig', function() end)
local default = ui.new_button('LUA', 'b', '\a9682FFFFDefault \aFFFFFFFFsettings', function() end)


local enable_aa = ui.new_checkbox('LUA', 'b', 'Enable anti-aim')
local inverter = ui.new_hotkey('LUA', 'b', 'Inverter key', false)
local global_base = ui.new_combobox('LUA', 'b', 'Global yaw base', {'Local view', 'At targets'})
local current_state = ui.new_combobox('LUA', 'b', 'Current state', var.states.player_state)
for i = 1, #var.states.player_state do
    var.Custom[i] = {
        enable = ui.new_checkbox('LUA', 'b', 'Override ' .. var.states.player_state[i]),
        pitch = ui.new_combobox('LUA', 'b', var.states.player_state_menu[i] .. ' Pitch', {'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random'}),
        
        yaw = ui.new_combobox('LUA', 'b', var.states.player_state_menu[i] .. ' Yaw', {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'}),
        yaw_type = ui.new_combobox('LUA', 'b', var.states.player_state_menu[i] .. ' Yaw add type', {'Default', 'Swap', 'Body swap', 'Delay swap'}),
        yaw_offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' Offset', -180, 180, 0, true, '°', 1),
        l_yaw_offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' Left offset', -180, 180, 0, true, '°', 1),
        r_yaw_offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' Right offset', -180, 180, 0, true, '°', 1),
        delay_swap = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' Delay swap', 2, 10, 2, true, 't', 1),

        yaw_jitter = ui.new_combobox('LUA', 'b', var.states.player_state_menu[i] .. ' Yaw jitter', {'Off', 'Offset', 'Center', 'Random', '3 way', '5 way'}),
        yaw_jitter_type = ui.new_combobox('LUA', 'b', var.states.player_state_menu[i] .. ' Yaw jitter type', {'Default', 'Delay swap', 'L/R', 'Min/Max'}),
        lj_yaw_offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' Left jitter', -180, 180, 0, true, '°', 1),
        rj_yaw_offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' Right jitter', -180, 180, 0, true, '°', 1),
        j_delay_swap = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' Delay swap', 2, 10, 2, true, 't', 1),
        jitter_offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' Jitter offset', -180, 180, 0, true, '°', 1),

        ways_type = ui.new_combobox('LUA', 'b', var.states.player_state_menu[i] .. ' Way jitter type', {'Default', 'Custom'}),

        single_way_offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' Way offset', -180, 180, 0, true, '°', 1),

        threeway_1offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' 1 Way offset', -180, 180, 0, true, '°', 1),
        threeway_2offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' 2 Way offset', -180, 180, 0, true, '°', 1),
        threeway_3offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' 3 Way offset', -180, 180, 0, true, '°', 1),

        fiveway_1offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' 1 Way offset ', -180, 180, 0, true, '°', 1),
        fiveway_2offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' 2 Way offset ', -180, 180, 0, true, '°', 1),
        fiveway_3offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' 3 Way offset ', -180, 180, 0, true, '°', 1),
        fiveway_4offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' 4 Way offset', -180, 180, 0, true, '°', 1),
        fiveway_5offset = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' 5 Way offset', -180, 180, 0, true, '°', 1),

        body_yaw = ui.new_combobox('LUA', 'b', var.states.player_state_menu[i] .. ' Body yaw', {'Off', 'Static', 'Jitter'}),
        body_value = ui.new_slider('LUA', 'b', var.states.player_state_menu[i] .. ' Body offset', -180, 180, 0, true, '°', 1),
    }
end


local body_freestand = ui.new_checkbox('LUA', 'b', '» Body yaw freestanding')
local lc_breaker = ui.new_checkbox('LUA', 'b', '» Break LC in air')
local avoid_backstab = ui.new_checkbox('LUA', 'b', '» Avoid backstab')
local backstab_rad = ui.new_slider('LUA', 'b', 'Radius', 10, 250, 150, true, 'u', 1)
local fast_ladder = ui.new_checkbox('LUA', 'b', '» Fast ladder')
local fakelag_disablers = ui.new_multiselect('LUA', 'b', '» Fake lag disablers', {'Double tap', 'Standing', 'Hide shots'})
local direction_tweaks = ui.new_multiselect('LUA', 'b', '» Reset direction if', {'Legit anti-aim', 'Freestanding'})
local left_hotkey = ui.new_hotkey('LUA', 'b', '» Left key')
local right_hotkey = ui.new_hotkey('LUA', 'b', '» Right key')
local reset_hotkey = ui.new_hotkey('LUA', 'b', '» Reset key')

local freestanding = ui.new_checkbox('LUA', 'b', '» Freestanding')
local freestanding_key = ui.new_hotkey('LUA', 'b', 'Freestanding key', true)
local freestanding_disablers = ui.new_multiselect('LUA', 'b', 'Disable when', {'Slow motion', 'Crouch', 'Air', 'Legit anti-aim'})
local freestanding_static = ui.new_checkbox('LUA', 'b', '\aB4B464FFDisable yaw jitter')

local edgeyaw = ui.new_checkbox('LUA', 'b', '» Edge yaw')
local edgeyaw_key = ui.new_hotkey('LUA', 'b', 'Edge yaw key', true)
local edgeyaw_disablers = ui.new_multiselect('LUA', 'b', 'Disable when ', {'Moving', 'Slow motion', 'Crouch', 'Air', 'Legit anti-aim', 'Manual direction'})

local watermark = ui.new_checkbox('LUA', 'b', '» Watermark')
local centered_ind = ui.new_checkbox('LUA', 'b', '» Centered indicators')
local centered_label = ui.new_label('LUA', 'b', 'Centered indicator color')
local centered_color = ui.new_color_picker('LUA', 'b', 'Centered color 1', 255, 144, 11, 255, false)

local direction_output = ui.new_checkbox('LUA', 'b', '» Direction arrows')
local direction_label = ui.new_label('LUA', 'b', 'Direction arrows color')
local direction_color = ui.new_color_picker('LUA', 'b', 'Direction color 1', 215, 215, 215, 215)

local minimum_damage = ui.new_checkbox('LUA', 'b', '» Minimum damage')

local aim_debug = ui.new_checkbox('LUA', 'b', '» Debug aimbot')
local aim_debug_cond = ui.new_multiselect('LUA', 'b', 'Conditions', {'Hit', 'Miss'})
local prefix_label = ui.new_label('LUA', 'b', 'Prefix debug color')
local prefix_color = ui.new_color_picker('LUA', 'b', 'Prefix color ', 11, 100, 255, 255)
local fade_label = ui.new_label('LUA', 'b', 'Fade debug color')
local fade_color = ui.new_color_picker('LUA', 'b', 'Fade color ', 11, 205, 255, 255)
local main_label = ui.new_label('LUA', 'b', 'Main debug color')
local main_color = ui.new_color_picker('LUA', 'b', 'Main color ', 11, 175, 255, 255)
local mismatch_label = ui.new_label('LUA', 'b', 'Mismatch debug color')
local mismatch_color = ui.new_color_picker('LUA', 'b', 'Mismatch color ', 255, 145, 11, 255)
local miss_label = ui.new_label('LUA', 'b', 'Miss debug color')
local miss_color = ui.new_color_picker('LUA', 'b', 'Miss color ', 255, 11, 11, 255)

local centered_log = ui.new_checkbox('LUA', 'b', '» Centered logs')
local centered_style = ui.new_combobox('LUA', 'b', 'Log style', {'Sigma', 'Box'})
local centered_hit_label = ui.new_label('LUA', 'b', 'Hit centered color')
local centered_hit_color = ui.new_color_picker('LUA', 'b', 'Hit color 1', 144, 255, 11, 255)
local centered_miss_label = ui.new_label('LUA', 'b', 'Miss centered color ')
local centered_miss_color = ui.new_color_picker('LUA', 'b', 'Miss color 1', 255, 11, 11, 255)

local dpi_support = ui.new_checkbox('LUA', 'b', '» Adaptive DPI scaling')

local local_anims = ui.new_checkbox('LUA', 'b', '» \aB4B464FFLocal animations')
local anim_breakers = ui.new_multiselect('LUA', 'b', 'Breakers', {'Landing pitch', 'Force falling', 'Legs direction', 'Legacy slowmotion', 'Force move lean'})
local leg_direction = ui.new_combobox('LUA', 'b', 'Leg direction', {'Default', 'Reversed', 'Moon walk', 'Leg break'})
local moon_walk_cond = ui.new_multiselect('LUA', 'b', 'Moon walk conditions', {'Land', 'Air'})
local disable_breakanim = ui.new_checkbox('LUA', 'b', 'Disable leg break animation')
local movelean_val = ui.new_slider('LUA', 'b', 'Force move lean value', 1, 100, true, 45, '%')

local better_bodyaim = ui.new_checkbox('LUA', 'b', '» Better body aim')
local force_body = ui.new_multiselect('LUA', 'b', 'Force body conditions', { 'Target air', 'Target no armor', 'Sideways/roll', '2 Shots', 'Lethal', 'Target <x health' })
local predictive_body = ui.new_checkbox('LUA', 'b', 'Predict player position')
local force_safety = ui.new_multiselect('LUA', 'b', 'Force safety conditions', { 'Target air', 'Target no armor', 'Sideways/roll', '2 Shots', 'Lethal', 'Target <x health' })
local hp_condition = ui.new_slider('LUA', 'b', 'Condition value', 1, 92, true, 45, 'hp')


local config_data =
 {
    bools = 
    {
        enable_aa, var.Custom[1].enable, var.Custom[2].enable, var.Custom[3].enable, var.Custom[4].enable, var.Custom[5].enable, var.Custom[6].enable, var.Custom[7].enable, var.Custom[8].enable, var.Custom[9].enable,
        var.Custom[10].enable, body_freestand, lc_breaker, avoid_backstab, freestanding, freestanding_static, edgeyaw, watermark, centered_ind, direction_output, minimum_damage, aim_debug, centered_log, dpi_support, local_anims, disable_breakanim,
        better_bodyaim, predictive_body, fast_ladder
    },

    tables = 
    {
        fakelag_disablers, direction_tweaks, freestanding_disablers, edgeyaw_disablers, aim_debug_cond, anim_breakers, moon_walk_cond
    },

    ints = 
    {
        var.Custom[1].pitch, var.Custom[2].pitch, var.Custom[3].pitch, var.Custom[4].pitch, var.Custom[5].pitch, var.Custom[6].pitch, var.Custom[7].pitch, var.Custom[8].pitch, var.Custom[9].pitch, var.Custom[10].pitch,
        var.Custom[1].yaw, var.Custom[2].yaw, var.Custom[3].yaw, var.Custom[4].yaw, var.Custom[5].yaw, var.Custom[6].yaw, var.Custom[7].yaw, var.Custom[8].yaw, var.Custom[9].yaw, var.Custom[10].yaw,
        var.Custom[1].yaw_type, var.Custom[2].yaw_type, var.Custom[3].yaw_type, var.Custom[4].yaw_type, var.Custom[5].yaw_type, var.Custom[6].yaw_type, var.Custom[7].yaw_type, var.Custom[8].yaw_type, var.Custom[9].yaw_type, var.Custom[10].yaw_type,
        var.Custom[1].yaw_offset, var.Custom[2].yaw_offset, var.Custom[3].yaw_offset, var.Custom[4].yaw_offset, var.Custom[5].yaw_offset, var.Custom[6].yaw_offset, var.Custom[7].yaw_offset, var.Custom[8].yaw_offset, var.Custom[9].yaw_offset, var.Custom[10].yaw_offset,
        var.Custom[1].l_yaw_offset, var.Custom[2].l_yaw_offset, var.Custom[3].l_yaw_offset, var.Custom[4].l_yaw_offset, var.Custom[5].l_yaw_offset, var.Custom[6].l_yaw_offset, var.Custom[7].l_yaw_offset, var.Custom[8].l_yaw_offset, var.Custom[9].l_yaw_offset, var.Custom[10].l_yaw_offset,
        var.Custom[1].r_yaw_offset, var.Custom[2].r_yaw_offset, var.Custom[3].r_yaw_offset, var.Custom[4].r_yaw_offset, var.Custom[5].r_yaw_offset, var.Custom[6].r_yaw_offset, var.Custom[7].r_yaw_offset, var.Custom[8].r_yaw_offset, var.Custom[9].r_yaw_offset, var.Custom[10].r_yaw_offset,
        var.Custom[1].delay_swap, var.Custom[2].delay_swap, var.Custom[3].delay_swap, var.Custom[4].delay_swap, var.Custom[5].delay_swap, var.Custom[6].delay_swap, var.Custom[7].delay_swap, var.Custom[8].delay_swap, var.Custom[9].delay_swap, var.Custom[10].delay_swap,
        var.Custom[1].yaw_jitter, var.Custom[2].yaw_jitter, var.Custom[3].yaw_jitter, var.Custom[4].yaw_jitter, var.Custom[5].yaw_jitter, var.Custom[6].yaw_jitter, var.Custom[7].yaw_jitter, var.Custom[8].yaw_jitter, var.Custom[9].yaw_jitter, var.Custom[10].yaw_jitter,
        var.Custom[1].jitter_offset, var.Custom[2].jitter_offset, var.Custom[3].jitter_offset, var.Custom[4].jitter_offset, var.Custom[5].jitter_offset, var.Custom[6].jitter_offset, var.Custom[7].jitter_offset, var.Custom[8].jitter_offset, var.Custom[9].jitter_offset, var.Custom[10].jitter_offset,
        var.Custom[1].ways_type, var.Custom[2].ways_type, var.Custom[3].ways_type, var.Custom[4].ways_type, var.Custom[5].ways_type, var.Custom[6].ways_type, var.Custom[7].ways_type, var.Custom[8].ways_type, var.Custom[9].ways_type, var.Custom[10].ways_type,
        var.Custom[1].single_way_offset, var.Custom[2].single_way_offset, var.Custom[3].single_way_offset, var.Custom[4].single_way_offset, var.Custom[5].single_way_offset, var.Custom[6].single_way_offset, var.Custom[7].single_way_offset, var.Custom[8].single_way_offset, var.Custom[9].single_way_offset, var.Custom[10].single_way_offset,

        var.Custom[1].threeway_1offset, var.Custom[2].threeway_1offset, var.Custom[3].threeway_1offset, var.Custom[4].threeway_1offset, var.Custom[5].threeway_1offset, var.Custom[6].threeway_1offset, var.Custom[7].threeway_1offset, var.Custom[8].threeway_1offset, var.Custom[9].threeway_1offset, var.Custom[10].threeway_1offset,
        var.Custom[1].threeway_2offset, var.Custom[2].threeway_2offset, var.Custom[3].threeway_2offset, var.Custom[4].threeway_2offset, var.Custom[5].threeway_2offset, var.Custom[6].threeway_2offset, var.Custom[7].threeway_2offset, var.Custom[8].threeway_2offset, var.Custom[9].threeway_2offset, var.Custom[10].threeway_2offset,
        var.Custom[1].threeway_3offset, var.Custom[2].threeway_3offset, var.Custom[3].threeway_3offset, var.Custom[4].threeway_3offset, var.Custom[5].threeway_3offset, var.Custom[6].threeway_3offset, var.Custom[7].threeway_3offset, var.Custom[8].threeway_3offset, var.Custom[9].threeway_3offset, var.Custom[10].threeway_3offset,

        var.Custom[1].fiveway_1offset, var.Custom[2].fiveway_1offset, var.Custom[3].fiveway_1offset, var.Custom[4].fiveway_1offset, var.Custom[5].fiveway_1offset, var.Custom[6].fiveway_1offset, var.Custom[7].fiveway_1offset, var.Custom[8].fiveway_1offset, var.Custom[9].fiveway_1offset, var.Custom[10].fiveway_1offset,
        var.Custom[1].fiveway_2offset, var.Custom[2].fiveway_2offset, var.Custom[3].fiveway_2offset, var.Custom[4].fiveway_2offset, var.Custom[5].fiveway_2offset, var.Custom[6].fiveway_2offset, var.Custom[7].fiveway_2offset, var.Custom[8].fiveway_2offset, var.Custom[9].fiveway_2offset, var.Custom[10].fiveway_2offset,
        var.Custom[1].fiveway_3offset, var.Custom[2].fiveway_3offset, var.Custom[3].fiveway_3offset, var.Custom[4].fiveway_3offset, var.Custom[5].fiveway_3offset, var.Custom[6].fiveway_3offset, var.Custom[7].fiveway_3offset, var.Custom[8].fiveway_3offset, var.Custom[9].fiveway_3offset, var.Custom[10].fiveway_3offset,
        var.Custom[1].fiveway_4offset, var.Custom[2].fiveway_4offset, var.Custom[3].fiveway_4offset, var.Custom[4].fiveway_4offset, var.Custom[5].fiveway_4offset, var.Custom[6].fiveway_4offset, var.Custom[7].fiveway_4offset, var.Custom[8].fiveway_4offset, var.Custom[9].fiveway_4offset, var.Custom[10].fiveway_4offset,
        var.Custom[1].fiveway_5offset, var.Custom[2].fiveway_5offset, var.Custom[3].fiveway_5offset, var.Custom[4].fiveway_5offset, var.Custom[5].fiveway_5offset, var.Custom[6].fiveway_5offset, var.Custom[7].fiveway_5offset, var.Custom[8].fiveway_5offset, var.Custom[9].fiveway_5offset, var.Custom[10].fiveway_5offset,

        var.Custom[1].body_yaw, var.Custom[2].body_yaw, var.Custom[3].body_yaw, var.Custom[4].body_yaw, var.Custom[5].body_yaw, var.Custom[6].body_yaw, var.Custom[7].body_yaw, var.Custom[8].body_yaw, var.Custom[9].body_yaw, var.Custom[10].body_yaw,
        var.Custom[1].body_value, var.Custom[2].body_value, var.Custom[3].body_value, var.Custom[4].body_value, var.Custom[5].body_value, var.Custom[6].body_value, var.Custom[7].body_value, var.Custom[8].body_value, var.Custom[9].body_value, var.Custom[10].body_value,
        centered_style, leg_direction, movelean_val, backstab_rad, force_body, force_safety, hp_condition
    },

    numbers = 
    {
        
    },

    colors = 
    {
        centered_color, direction_color, prefix_color, fade_color, main_color, mismatch_color, miss_color, centered_hit_color, centered_miss_color
    },
 }

export_config = function()
    local Code = {{},{},{},{},{}}

    for _, bools in pairs(config_data.bools) do
        table.insert(Code[1], ui.get(bools))
    end

    for _, tables in pairs(config_data.tables) do
        table.insert(Code[2], ui.get(tables))
    end

    for _, ints in pairs(config_data.ints) do
        table.insert(Code[3], ui.get(ints))
    end

    for _, numbers in pairs(config_data.numbers) do
        table.insert(Code[4], ui.get(numbers))
    end

    for _, colors in pairs(config_data.colors) do
        local r, g, b, a = ui.get(colors)

        table.insert(Code[5], string.format('%02X%02X%02X%02X', math.floor(r), math.floor(g), math.floor(b), math.floor(a)))
    end

    clipboard.set(json.stringify(Code))

    local r,g,b,a = ui.get(prefix_color)
    local r1,g1,b1,a1 = ui.get(fade_color)
    hitlog.run('exported to clipboard', r, g ,b, r1, g1, b1)

    if ui.get(centered_log) and ui.get(centered_style) == 'Sigma' then
        hitlog_table[#hitlog_table+1] = {('Exported to clipboard'), globals.tickcount() + 350, 0, 0}
        hitlog_id = hitlog_id == 999 and 1 or hitlog_id + 1
    end

    if ui.get(centered_log) and ui.get(centered_style) == 'Box'  then
        local string = 'Exported to clipboard'
        table.insert(rounded_log, {
            text = string,
            loading = true
    })
    end
end

import_config = function()
    local decode = clipboard.get()
    local decoded = json.parse(decode)

    for k, v in pairs(decoded) do
        k = ({[1] = "bools", [2] = "tables", [3] = "ints", [4] = "numbers", [5] = "colors"})[k]
        for k2, v2 in pairs(v) do
            if (k == "bools") then
                ui.set(config_data[k][k2], v2)
            end
            if (k == "tables") then
                ui.set(config_data[k][k2], v2)
            end

            if (k == "ints") then
                ui.set(config_data[k][k2], v2)
            end

            if (k == "numbers") then
                ui.set(config_data[k][k2], v2)
            end

            if (k == "colors") then
                ui.set(config_data[k][k2], tonumber('0x'..v2:sub(1, 2)), tonumber('0x'..v2:sub(3, 4)), tonumber('0x'..v2:sub(5, 6)), tonumber('0x'..v2:sub(7, 8)))
            end
        end
    end

    local r,g,b,a = ui.get(prefix_color)
    local r1,g1,b1,a1 = ui.get(fade_color)
    hitlog.run('imported from clipboard', r, g ,b, r1, g1, b1)

    if ui.get(centered_log) and ui.get(centered_style) == 'Sigma' then
        hitlog_table[#hitlog_table+1] = {('Imported from clipboard'), globals.tickcount() + 350, 0, 0}
        hitlog_id = hitlog_id == 999 and 1 or hitlog_id + 1
    end

    if ui.get(centered_log) and ui.get(centered_style) == 'Box'  then
        local string = 'Imported from clipboard'
        table.insert(rounded_log, {
            text = string,
            loading = true
    })
    end
end

ui.set_callback(export, 
function()
    local success, preset = pcall(function() export_config()
    end)

    if success == false then
        if ui.get(centered_log) and ui.get(centered_style) == 'Sigma' then
            hitlog_table[#hitlog_table+1] = {('Failed to export config'), globals.tickcount() + 350, 0, 0}
            hitlog_id = hitlog_id == 999 and 1 or hitlog_id + 1
        end
    
        if ui.get(centered_log) and ui.get(centered_style) == 'Box'  then
            local string = 'Failed to export config'
            table.insert(rounded_log, {
                text = string,
                missed = true
        })
        end

        play_sound("buttons/combine_button3.wav", 0.5, 100, 0, 0)
        return
    end
end)

ui.set_callback(import, 
function()
    local success, preset = pcall(function() import_config()
    end)

    if success == false then
        if ui.get(centered_log) and ui.get(centered_style) == 'Sigma' then
            hitlog_table[#hitlog_table+1] = {('Failed to import config'), globals.tickcount() + 350, 0, 0}
            hitlog_id = hitlog_id == 999 and 1 or hitlog_id + 1
        end
    
        if ui.get(centered_log) and ui.get(centered_style) == 'Box'  then
            local string = 'Failed to import config'
            table.insert(rounded_log, {
                text = string,
                missed = true
        })
        end

        play_sound("buttons/combine_button3.wav", 0.5, 100, 0, 0)
        return
    end
end)

local key = '[[true,true,true,true,true,true,true,true,true,true,true,false,true,true,true,false,false,true,false,true,true,true,true,false,false,false,false,false,true],[["Standing","Hide shots"],["Legit anti-aim"],["Crouch","Air","Legit anti-aim"],{},["Hit","Miss"],["Force falling"],{}],["Off","Default","Default","Default","Default","Default","Default","Off","Default","Off","Off","180","180","180","180","180","180","180","180","Spin","Default","Default","Default","Default","Default","Default","Default","Default","Default","Swap",0,0,0,0,0,0,0,180,0,66,0,0,0,0,0,0,0,0,0,92,0,0,0,0,0,0,0,0,0,55,2,2,2,2,2,2,2,2,2,2,"Center","Center","Center","3 way","Center","Off","Off","Off","Center","Off",60,64,48,16,58,57,0,0,57,0,"Default","Default","Default","Default","Default","Default","Default","Default","Default","Default",0,0,0,0,69,0,0,0,0,0,0,0,0,0,-61,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,45,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"Off","Jitter","Jitter","Jitter","Jitter","Static","Static","Static","Jitter","Jitter",180,90,180,0,147,180,-180,180,180,0,"Box","Default",1,150,{},{},92],{},["FF900BFF","D7D7D7D7","0B64FFFF","0BCDFFFF","0BAFFFFF","FF910BFF","FF0B0BFF","90FF0BFF","FF0B0BFF"]]'
ui.set_callback(default, 
function()
    local decode = key
    local decoded = json.parse(decode)

    for k, v in pairs(decoded) do
        k = ({[1] = "bools", [2] = "tables", [3] = "ints", [4] = "numbers", [5] = "colors"})[k]
        for k2, v2 in pairs(v) do
            if (k == "bools") then
                ui.set(config_data[k][k2], v2)
            end
            if (k == "tables") then
                ui.set(config_data[k][k2], v2)
            end

            if (k == "ints") then
                ui.set(config_data[k][k2], v2)
            end

            if (k == "numbers") then
                ui.set(config_data[k][k2], v2)
            end

            if (k == "colors") then
                ui.set(config_data[k][k2], tonumber('0x'..v2:sub(1, 2)), tonumber('0x'..v2:sub(3, 4)), tonumber('0x'..v2:sub(5, 6)), tonumber('0x'..v2:sub(7, 8)))
            end
        end
    end

    local r,g,b,a = ui.get(prefix_color)
    local r1,g1,b1,a1 = ui.get(fade_color)

    hitlog.run('loaded default', r, g ,b, r1, g1, b1)
    
    
    if ui.get(centered_log) and ui.get(centered_style) == 'Sigma' then
        hitlog_table[#hitlog_table+1] = {('Loaded default'), globals.tickcount() + 350, 0, 0}
        hitlog_id = hitlog_id == 999 and 1 or hitlog_id + 1
    end

    if ui.get(centered_log) and ui.get(centered_style) == 'Box'  then
        local string = 'Loaded default'
        table.insert(rounded_log, {
            text = string,
            loading = true
    })
    end
end)

reference_visibility = function(switch)
    local visible = not switch
    ui.set_visible(ref_enabled, visible)
    ui.set_visible(ref_pitch, visible)
    ui.set_visible(ref_yawbase, visible)
    ui.set_visible(ref_yaw, visible)
    ui.set_visible(ref_yawoffset, visible)
    ui.set_visible(ref_jitter, visible)
    ui.set_visible(ref_jitteroffset, visible)
    ui.set_visible(ref_bodyyaw, visible)
    ui.set_visible(ref_byawoffset, visible)
    ui.set_visible(ref_bodystand, visible)
    ui.set_visible(ref_edgeyaw, visible)
    ui.set_visible(ref_freestanding, visible)
    ui.set_visible(ref_freestanding_key, visible)
    ui.set_visible(ref_roll, visible)
end


local function table_id(table, val)if #table > 0 then for i = 1, #table do if table[i] == val then return i end end end return 0 end


builder_ui = function()
    local p_state = table_id(var.states.player_state, ui.get(current_state))
    for i = 1, #var.states.player_state do
        local state = ui.get(enable_lua) and ui.get(enable_aa)
        local show = false
        if p_state == i then
            if p_state == 1 then
                show = state
                ui.set(var.Custom[i].enable, state)
                ui.set_visible(var.Custom[i].enable, false)
            else
                show = state
                ui.set_visible(var.Custom[i].enable, ui.get(lua_tab) == 'Anti-aim' and state)
                if ui.get(var.Custom[i].enable) then
                    show = state
                else
                    show = false
                end
            end
        else
            ui.set_visible(var.Custom[i].enable, false)
        end
        local not_jitter = ui.get(var.Custom[i].yaw_jitter) == 'Off'
        local is_customed = (ui.get(var.Custom[i].yaw_jitter) == '3 way' or ui.get(var.Custom[i].yaw_jitter) == '5 way')
        
        ui.set_visible(var.Custom[i].pitch, ui.get(lua_tab) == 'Anti-aim' and show)
        ui.set_visible(var.Custom[i].yaw, ui.get(lua_tab) == 'Anti-aim' and show)
        ui.set_visible(var.Custom[i].yaw_type, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and not is_customed)
        ui.set_visible(var.Custom[i].yaw_offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_type) == 'Default' and not is_customed)
        ui.set_visible(var.Custom[i].l_yaw_offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_type) ~= 'Default' and not is_customed)
        ui.set_visible(var.Custom[i].r_yaw_offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_type) ~= 'Default' and not is_customed)
        ui.set_visible(var.Custom[i].delay_swap, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_type) == 'Delay swap' and not is_customed)
        ui.set_visible(var.Custom[i].yaw_jitter, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off')
        ui.set_visible(var.Custom[i].jitter_offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw_jitter) ~= 'Off' and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_jitter_type) == 'Default' and not is_customed)
        
        ui.set_visible(var.Custom[i].yaw_jitter_type, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and not is_customed and not not_jitter)
        ui.set_visible(var.Custom[i].j_delay_swap, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_jitter_type) == 'Delay swap' and not is_customed and not not_jitter)
        ui.set_visible(var.Custom[i].lj_yaw_offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_jitter_type) ~= 'Default' and not is_customed and not not_jitter)
        ui.set_visible(var.Custom[i].rj_yaw_offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_jitter_type) ~= 'Default' and not is_customed and not not_jitter)

        ui.set_visible(var.Custom[i].ways_type, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and is_customed)
        ui.set_visible(var.Custom[i].single_way_offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and is_customed and ui.get(var.Custom[i].ways_type) == 'Default')

        ui.set_visible(var.Custom[i].threeway_1offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_jitter) == '3 way' and ui.get(var.Custom[i].ways_type) == 'Custom')
        ui.set_visible(var.Custom[i].threeway_2offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_jitter) == '3 way' and ui.get(var.Custom[i].ways_type) == 'Custom')
        ui.set_visible(var.Custom[i].threeway_3offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_jitter) == '3 way' and ui.get(var.Custom[i].ways_type) == 'Custom')

        ui.set_visible(var.Custom[i].fiveway_1offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_jitter) == '5 way' and ui.get(var.Custom[i].ways_type) == 'Custom')
        ui.set_visible(var.Custom[i].fiveway_2offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_jitter) == '5 way' and ui.get(var.Custom[i].ways_type) == 'Custom')
        ui.set_visible(var.Custom[i].fiveway_3offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_jitter) == '5 way' and ui.get(var.Custom[i].ways_type) == 'Custom')
        ui.set_visible(var.Custom[i].fiveway_4offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_jitter) == '5 way' and ui.get(var.Custom[i].ways_type) == 'Custom')
        ui.set_visible(var.Custom[i].fiveway_5offset, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].yaw) ~= 'Off' and ui.get(var.Custom[i].yaw_jitter) == '5 way' and ui.get(var.Custom[i].ways_type) == 'Custom')

        ui.set_visible(var.Custom[i].body_yaw, ui.get(lua_tab) == 'Anti-aim' and show)
        ui.set_visible(var.Custom[i].body_value, ui.get(lua_tab) == 'Anti-aim' and show and ui.get(var.Custom[i].body_yaw) ~= 'Off')

        ui.set_callback(enable_aa, function()
            builder_ui()
        end)
        ui.set_callback(var.Custom[i].enable, function()
            builder_ui()
        end)
        ui.set_visible(current_state, ui.get(lua_tab) == 'Anti-aim' and state)
    end
end

builder_ui()

local tab_table = {}

tab_table.general = function(enabled)
    ui.set_visible(lua_tab, enabled)

    ui.set_visible(export,enabled and ui.get(lua_tab) == 'General')
    ui.set_visible(import,enabled and ui.get(lua_tab) == 'General')
    ui.set_visible(default,enabled and ui.get(lua_tab) == 'General')
end

tab_table.antiaim = function(enabled)
    ui.set_visible(enable_aa,enabled and ui.get(lua_tab) == 'Anti-aim')
    ui.set_visible(inverter,enabled and ui.get(lua_tab) == 'Anti-aim' and ui.get(enable_aa))
    ui.set_visible(global_base,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim')

    ui.set_visible(body_freestand,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(lc_breaker,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(avoid_backstab,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(fast_ladder,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(backstab_rad,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc' and ui.get(avoid_backstab))
    ui.set_visible(direction_tweaks,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(fakelag_disablers,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(left_hotkey,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(right_hotkey,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(reset_hotkey,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(freestanding,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(freestanding_key,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(freestanding_disablers,enabled and ui.get(freestanding) and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(freestanding_static,enabled and ui.get(freestanding) and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(edgeyaw,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(edgeyaw_key,enabled and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_visible(edgeyaw_disablers,enabled and ui.get(edgeyaw) and ui.get(enable_aa) and ui.get(lua_tab) == 'Anti-aim misc')
    ui.set_enabled(fakepeek, false)
    ui.set_enabled(fakepeek_key, false)
end

tab_table.misc = function(enabled)
    ui.set_visible(watermark,enabled and ui.get(lua_tab) == 'Misc')
    ui.set_visible(centered_ind,enabled and ui.get(lua_tab) == 'Misc')
    ui.set_visible(centered_label,enabled and ui.get(lua_tab) == 'Color')
    ui.set_visible(centered_color,enabled and ui.get(lua_tab) == 'Color')
    ui.set_visible(direction_output,enabled and ui.get(lua_tab) == 'Misc')
    ui.set_visible(minimum_damage,enabled and ui.get(lua_tab) == 'Misc')
    ui.set_visible(direction_label,enabled and ui.get(lua_tab) == 'Color')
    ui.set_visible(direction_color,enabled and ui.get(lua_tab) == 'Color')
    ui.set_visible(aim_debug,enabled and ui.get(lua_tab) == 'Misc')
    ui.set_visible(aim_debug_cond,enabled and ui.get(lua_tab) == 'Misc' and ui.get(aim_debug))
    ui.set_visible(prefix_label,enabled and ui.get(lua_tab) == 'Colors')
    ui.set_visible(prefix_color,enabled and ui.get(lua_tab) == 'Colors')
    ui.set_visible(fade_label,enabled and ui.get(aim_debug) and ui.get(lua_tab) == 'Colors')
    ui.set_visible(fade_color,enabled and ui.get(lua_tab) == 'Colors')
    ui.set_visible(main_label,enabled and ui.get(lua_tab) == 'Colors')
    ui.set_visible(main_color,enabled and ui.get(lua_tab) == 'Colors')
    ui.set_visible(mismatch_label,enabled and ui.get(lua_tab) == 'Colors')
    ui.set_visible(mismatch_color,enabled and ui.get(lua_tab) == 'Colors')
    ui.set_visible(miss_label,enabled and ui.get(lua_tab) == 'Colors')
    ui.set_visible(miss_color,enabled and ui.get(lua_tab) == 'Colors')

    ui.set_visible(centered_log,enabled and ui.get(lua_tab) == 'Misc')
    ui.set_visible(centered_style,enabled and ui.get(lua_tab) == 'Misc' and ui.get(centered_log))
    ui.set_visible(centered_hit_label,enabled and ui.get(lua_tab) == 'Colors')
    ui.set_visible(centered_hit_color,enabled and ui.get(lua_tab) == 'Colors')
    ui.set_visible(centered_miss_label,enabled and ui.get(lua_tab) == 'Colors')
    ui.set_visible(centered_miss_color,enabled and ui.get(lua_tab) == 'Colors')
    ui.set_visible(dpi_support, enabled and ui.get(lua_tab) == 'Misc')

    ui.set_visible(local_anims,enabled and ui.get(lua_tab) == 'Misc')
    ui.set_visible(anim_breakers,enabled and ui.get(lua_tab) == 'Misc' and ui.get(local_anims))
    ui.set_visible(movelean_val,enabled and ui.get(lua_tab) == 'Misc' and ui.get(local_anims) and contains(ui.get(anim_breakers), 'Force move lean'))
    ui.set_visible(leg_direction,enabled and ui.get(lua_tab) == 'Misc' and ui.get(local_anims) and contains(ui.get(anim_breakers), 'Legs direction'))
    ui.set_visible(disable_breakanim,enabled and ui.get(lua_tab) == 'Misc' and ui.get(local_anims) and contains(ui.get(anim_breakers), 'Legs direction') and ui.get(leg_direction) == 'Leg break')
    ui.set_visible(moon_walk_cond,enabled and ui.get(lua_tab) == 'Misc' and ui.get(local_anims) and contains(ui.get(anim_breakers), 'Legs direction') and ui.get(leg_direction) == 'Moon walk')

    ui.set_visible(better_bodyaim,enabled and ui.get(lua_tab) == 'Misc')
    ui.set_visible(force_body,enabled and ui.get(lua_tab) == 'Misc' and ui.get(better_bodyaim))
    ui.set_visible(force_safety,enabled and ui.get(lua_tab) == 'Misc' and ui.get(better_bodyaim))
    ui.set_visible(hp_condition,enabled and ui.get(lua_tab) == 'Misc' and ui.get(better_bodyaim) and (contains(ui.get(force_body), 'Target <x health') or contains(ui.get(force_safety), 'Target <x health')))
    ui.set_visible(predictive_body, enabled and ui.get(lua_tab) == 'Misc' and ui.get(better_bodyaim))
end


global_visibility = function()
    local enabled = ui.get(enable_lua)

    tab_table.general(enabled)
    tab_table.antiaim(enabled)
    tab_table.misc(enabled)
end

local ragebot = {}

ragebot.force_defensive = function(cmd)
    if not ui.get(lc_breaker) then
        return end

    local self = entity.get_local_player()

    if not entity.is_alive(self) then
        return end

    if not var.states.on_ground(self, cmd) then
        cmd.force_defensive = 1
    end
end
local antiaim = {}

antiaim.last_pressed = 0
antiaim.direction = 0
antiaim.force_reset = false
antiaim.condition = 1
antiaim.body_type = 0
antiaim.is_left = false
antiaim.is_right = false
antiaim.is_reset = true
antiaim.prevent_jitter = false
antiaim.freestanding_jitter = true
antiaim.freestand_state = false
antiaim.edge_state = false
antiaim.desync_side = 0
antiaim.true_shot = false
antiaim.bruteforce_angle = 60
antiaim.is_in_air = false
antiaim.is_defensive = false

antiaim.setup_conditions = function(cmd)
    local self = entity.get_local_player()
    if not entity.is_alive(self) then return end

    if not var.states.on_ground(self, cmd) then
        antiaim.is_in_air = true
    else
        antiaim.is_in_air = false
    end

    if (tbl.defensive > 2 and tbl.defensive < 14) and (antiaim.direction == 0) then
        antiaim.is_defensive = true
    else
        antiaim.is_defensive = false
    end

    if var.states.in_use() then
        antiaim.condition = 8
    else
        if var.states.no_exploit() then
            antiaim.condition = 9
        else
            if ui.get(ref_fakeduck) and var.states.on_ground(self, cmd) then
                antiaim.condition = 5 
            else
                if not var.states.on_ground(self, cmd) then
                    if ui.get(var.Custom[10].enable) and antiaim.is_defensive == true then
                        antiaim.condition = 10
                    else
                    antiaim.condition = var.states.is_crouching(self) and 7 or 6 end
                elseif var.states.is_crouching(self) then
                    antiaim.condition = 5 
                elseif var.states.is_running(self) then
                    if var.states.is_slowmotion() then
                        antiaim.condition = 4
                    else
                        antiaim.condition = 3 
                    end
                else
                    antiaim.condition = 2  
                end
            end
        end
    end

    if not ui.get(var.Custom[antiaim.condition].enable) then
        antiaim.condition = 1 
    end
end

antiaim.setup_left_right = function(left, right)
    local body_pos = entity.get_prop(entity.get_local_player(), 'm_flPoseParameter', 11) or 0
	local body_yaw = math.max(-60, math.min(60, body_pos*120-60+0.5))

    local state = body_yaw > 0 and 1 or -1
    local side = state == 1 and left or right

    return side
end


antiaim.ThreeWay = function(yaw)
    local stage = globals.tickcount() % 3
    if antiaim.prevent_jitter then 
        return end

    local state = antiaim.condition

    local first, second, third
    if ui.get(var.Custom[state].ways_type) == 'Default' then
        local offset = ui.get(var.Custom[state].single_way_offset)
        first, second, third = -offset, 0, offset
    elseif ui.get(var.Custom[state].ways_type) == 'Custom' then
        local first_way = ui.get(var.Custom[state].threeway_1offset)
        local second_way = ui.get(var.Custom[state].threeway_2offset)
        local third_way = ui.get(var.Custom[state].threeway_3offset)
        first, second, third = first_way, second_way, third_way
    end
    if stage == 0 then
        ui.set(ref_yawoffset, first)
    elseif stage == 1 then
        ui.set(ref_yawoffset, second)
    elseif stage == 2 then
        ui.set(ref_yawoffset, third)
    end

    ui.set(ref_jitter, 'Off')
    ui.set(ref_jitteroffset, 0)
end

antiaim.FiveWay = function(yaw, offset)
    local stage = globals.tickcount() % 5  
    if antiaim.prevent_jitter then 
        return end

    local state = antiaim.condition

    local first, second, third, fourth, fifth
    if ui.get(var.Custom[state].ways_type) == 'Default' then
        local offset = ui.get(var.Custom[state].single_way_offset)
        first, second, third, fourth, fifth = -offset, -offset*0.5, offset, offset*0.5, offset
    elseif ui.get(var.Custom[state].ways_type) == 'Custom' then
        local first_way = ui.get(var.Custom[state].fiveway_1offset)
        local second_way = ui.get(var.Custom[state].fiveway_2offset)
        local third_way = ui.get(var.Custom[state].fiveway_3offset)
        local fourth_way = ui.get(var.Custom[state].fiveway_4offset)
        local fifth_way = ui.get(var.Custom[state].fiveway_5offset)
        first, second, third, fourth, fifth = first_way, second_way, third_way, fourth_way, fifth_way
    end

    if stage == 0 then
        ui.set(ref_yawoffset, first)
    elseif stage == 1 then
        ui.set(ref_yawoffset, second)
    elseif stage == 2 then
        ui.set(ref_yawoffset, third)
    elseif stage == 3 then
        ui.set(ref_yawoffset, fourth)
    elseif stage == 4 then
        ui.set(ref_yawoffset, fifth)
    end
    
    ui.set(ref_jitter, 'Off')
    ui.set(ref_jitteroffset, 0)
end

antiaim.setup_desync = function(value)
    local body_value = ui.get(var.Custom[antiaim.condition].body_value)

    if antiaim.prevent_jitter or antiaim.is_avoid then
        ui.set(ref_bodyyaw, 'Static')
        ui.set(ref_byawoffset, ui.get(inverter) and 180 or -180)
        antiaim.body_type = 0
    else
        if ui.get(value) == 'Off' then
            ui.set(ref_bodyyaw, 'Off')
            ui.set(ref_byawoffset, 0)
            antiaim.body_type = 0
        elseif ui.get(value) == 'Static' then
            ui.set(ref_bodyyaw, 'Static')
            ui.set(ref_byawoffset, (ui.get(inverter) and body_value or -body_value))
            antiaim.body_type = 0
        elseif ui.get(value) == 'Jitter' then
            ui.set(ref_bodyyaw, 'Jitter')
            ui.set(ref_byawoffset, body_value)
            antiaim.body_type = 1
        end
    end
end


antiaim.setup_jitter = function(yaw, value, offset)
    if not antiaim.freestanding_jitter or antiaim.prevent_jitter or antiaim.is_avoid then
        ui.set(ref_jitter, 'Off')
        ui.set(ref_jitteroffset, 0)
    else
        if ui.get(value) == 'Off' then
            ui.set(ref_jitter, 'Off')
            ui.set(ref_jitteroffset, 0)
        elseif ui.get(value) == 'Offset' then
            ui.set(ref_jitter, 'Offset')
            ui.set(ref_jitteroffset, offset)
        elseif ui.get(value) == 'Center' then
            ui.set(ref_jitter, 'Center')
            ui.set(ref_jitteroffset, offset)
        elseif ui.get(value) == 'Random' then
            ui.set(ref_jitter, 'Random')
            ui.set(ref_jitteroffset, offset)
        elseif ui.get(value) == '3 way' then
            antiaim.ThreeWay(yaw)
        elseif ui.get(value) == '5 way' then
            antiaim.FiveWay(yaw, offset)
        end
    end
end

antiaim.avoid_backstab = function()
    if ui.get(avoid_backstab) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
        local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")

        antiaim.is_avoid = false

        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = antiaim.get_3d_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(backstab_rad) then
                antiaim.is_avoid = true
            end
        end
    else
        antiaim.is_avoid = false
    end
end

antiaim.fast_ladder = function(cmd)
    if ui.get(fast_ladder) then
        local self = entity.get_local_player()
        local move_type = entity.get_prop(self, "m_movetype")
        local is_on_ladder = move_type == 9

        if is_on_ladder then
            cmd.yaw = math.floor(cmd.yaw + 0.5)

        if cmd.forwardmove > 0 then
            if cmd.pitch < 45 then
                cmd.pitch = 89
                cmd.in_moveright = 1
                cmd.in_moveleft = 0
                cmd.in_forward = 0
                cmd.in_back = 1

                if cmd.sidemove == 0 then
                    cmd.yaw = cmd.yaw + 90
                end

                if cmd.sidemove < 0 then
                    cmd.yaw = cmd.yaw + 150
                end

                if cmd.sidemove > 0 then
                    cmd.yaw = cmd.yaw + 30
                end
            end
        elseif cmd.forwardmove < 0 then
            cmd.pitch = 89
            cmd.in_moveleft = 1
            cmd.in_moveright = 0
            cmd.in_forward = 1
            cmd.in_back = 0

            if cmd.sidemove == 0 then
                cmd.yaw = cmd.yaw + 90
            end

            if cmd.sidemove > 0 then
                cmd.yaw = cmd.yaw + 150
            end

            if cmd.sidemove < 0 then
                cmd.yaw = cmd.yaw + 30
            end
        end
        end
    end
end

antiaim.setup_miscellaneous = function(cmd)
    local self = entity.get_local_player()

    if not entity.is_alive(self) then
        return end

    local freestand, freestand_key = ui.get(freestanding), ui.get(freestanding_key)
    local edge, edge_key = ui.get(edgeyaw), ui.get(edgeyaw_key)

    if contains(ui.get(freestanding_disablers), 'Slow motion') and var.states.is_slowmotion() or
    contains(ui.get(freestanding_disablers), 'Crouch') and var.states.is_crouching(self) or
    contains(ui.get(freestanding_disablers), 'Air') and not var.states.on_ground(self, cmd) or
    contains(ui.get(freestanding_disablers), 'Legit anti-aim') and var.states.in_use() then
        antiaim.freestand_state = false
    else
        antiaim.freestand_state = true
    end

    if contains(ui.get(edgeyaw_disablers), 'Moving') and var.states.is_running(self) or
    contains(ui.get(edgeyaw_disablers), 'Slow motion') and var.states.is_slowmotion() or
    contains(ui.get(edgeyaw_disablers), 'Crouch') and var.states.is_crouching(self) or
    contains(ui.get(edgeyaw_disablers), 'Air') and not var.states.on_ground(self, cmd) or
    contains(ui.get(edgeyaw_disablers), 'Legit anti-aim') and var.states.in_use() or
    contains(ui.get(edgeyaw_disablers), 'Manual direction') and (antiaim.direction == -90 or antiaim.direction == 90) then
        antiaim.edge_state = false
    else
        antiaim.edge_state = true
    end

    if (freestand and freestand_key) and antiaim.freestand_state then
        ui.set(ref_freestanding, true)
        ui.set(ref_freestanding_key, 'Always on')

        if ui.get(freestanding_static) then 
            antiaim.freestanding_jitter = false
        else 
            antiaim.freestanding_jitter = true
        end
    else
        ui.set(ref_freestanding, false)
        ui.set(ref_freestanding_key, 'On hotkey')
        antiaim.freestanding_jitter = true
    end

    if (edge and edge_key) and antiaim.edge_state then
        ui.set(ref_edgeyaw, true)
    else
        ui.set(ref_edgeyaw, false)
    end
end

antiaim.get_3d_dist = function(x1, y1, z1, x2, y2, z2)
	return math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end

antiaim.has_c4 = function(ent)
	local bomb = entity.get_all("CC4")[1]
	return bomb ~= nil and entity.get_prop(bomb, "m_hOwnerEntity") == ent
end

antiaim.setup_in_use = function(c)

	if ui.get(var.Custom[9].enable) then
		local plocal = entity.get_local_player()
		
		local distance = 150
		local bomb = entity.get_all("CPlantedC4")[1]
		local bomb_x, bomb_y, bomb_z = entity.get_prop(bomb, "m_vecOrigin")

		if bomb_x ~= nil then
			local player_x, player_y, player_z = entity.get_prop(plocal, "m_vecOrigin")
			distance = antiaim.get_3d_dist(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
		end
		
		local team_num = entity.get_prop(plocal, "m_iTeamNum")
		local defusing = team_num == 3 and distance < 100

		local on_bombsite = entity.get_prop(plocal, "m_bInBombZone")

		local has_bomb = antiaim.has_c4(plocal)
		local trynna_plant = on_bombsite ~= 0 and team_num == 2 and has_bomb
		
		local px, py, pz = client.eye_position()
		local pitch, yaw = client.camera_angles()
	
		local sin_pitch = math.sin(math.rad(pitch))
		local cos_pitch = math.cos(math.rad(pitch))
		local sin_yaw = math.sin(math.rad(yaw))
		local cos_yaw = math.cos(math.rad(yaw))

		local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }

		local fraction, entindex = client.trace_line(plocal, px, py, pz, px + (dir_vec[1] * 8192), py + (dir_vec[2] * 8192), pz + (dir_vec[3] * 8192))

		local using = true

		if entindex ~= nil then
			for i=0, #var.classnames do
				if entity.get_classname(entindex) == var.classnames[i] then
					using = false
				end
			end
		end

		if not using and not trynna_plant and not defusing then
			c.in_use = 0
		end
	end
end

local should_swap = false

antiaim.setup_builder = function(cmd)
    if not ui.get(enable_lua) then
        return end

    if not ui.get(enable_aa) then
        return end

    local state = antiaim.condition
    local yaw = 0
    local left_yaw = ui.get(var.Custom[state].l_yaw_offset)
    local right_yaw = ui.get(var.Custom[state].r_yaw_offset)

    if ui.get(var.Custom[state].yaw_type) == 'Default' then
        yaw = ui.get(var.Custom[state].yaw_offset)
    elseif ui.get(var.Custom[state].yaw_type) == 'Swap' then
        if globals.tickcount() % 2 == 1 then
            should_swap = not should_swap
        end
        yaw = should_swap and left_yaw or right_yaw
    elseif ui.get(var.Custom[state].yaw_type) == 'Body swap' then
        yaw = antiaim.setup_left_right(left_yaw, right_yaw)
    elseif ui.get(var.Custom[state].yaw_type) == 'Delay swap' then
        if globals.tickcount() % ui.get(var.Custom[state].delay_swap) == 1 then
            should_swap = not should_swap
        end
        yaw = should_swap and left_yaw or right_yaw
    end

    local ThreeWay, FiveWay = ui.get(var.Custom[state].yaw_jitter) == '3 way', ui.get(var.Custom[state].yaw_jitter) == '5 way'
    local setup_yaw = (ThreeWay or FiveWay) and 0 or yaw


    if ui.get(reset_hotkey) then
        antiaim.direction = 0
        antiaim.prevent_jitter = false
        antiaim.force_reset = false
    elseif ui.get(right_hotkey) and antiaim.last_pressed + 0.2 < globals.curtime() then
        antiaim.direction = antiaim.direction == 90 and 0 or 90
        antiaim.prevent_jitter = antiaim.direction == 90 and true or false
        antiaim.last_pressed = globals.curtime()
        antiaim.force_reset = false
    elseif ui.get(left_hotkey) and antiaim.last_pressed + 0.2 < globals.curtime() then
        antiaim.direction = antiaim.direction == -90 and 0 or -90
        antiaim.prevent_jitter = antiaim.direction == -90 and true or false
        antiaim.last_pressed = globals.curtime()
        antiaim.force_reset = false
    elseif contains(ui.get(direction_tweaks), 'Legit anti-aim') and (ui.get(var.Custom[9].enable) and var.states.in_use()) or
        contains(ui.get(direction_tweaks), 'Freestanding') and (ui.get(freestanding) and ui.get(freestanding_key) and antiaim.freestand_state) then
        antiaim.last_pressed = globals.curtime()
        antiaim.prevent_jitter = false
        antiaim.direction = 0
        antiaim.force_reset = true
    elseif antiaim.last_pressed > globals.curtime() then
        antiaim.last_pressed = globals.curtime()
        antiaim.prevent_jitter = false
        antiaim.force_reset = false
    end

    if antiaim.is_avoid == true then
        ui.set(ref_yawbase, 'At targets')
        ui.set(ref_pitch, 'Default')
        ui.set(ref_yaw, '180')
        ui.set(ref_yawoffset, 180)
    else
        ui.set(ref_yawbase, (antiaim.prevent_jitter or var.states.in_use()) and 'Local view' or ui.get(global_base))
        ui.set(ref_pitch, ui.get(var.Custom[state].pitch))
        ui.set(ref_yaw, ui.get(var.Custom[state].yaw))
        ui.set(ref_yawoffset, antiaim.direction + (antiaim.direction == 0 and setup_yaw or 0))
    end
    
    
    ui.set(ref_bodystand, ui.get(body_freestand))
    ui.set(ref_roll, 0)

    local jitter_offset

    if ui.get(var.Custom[state].yaw_jitter) == '3 way' or ui.get(var.Custom[state].yaw_jitter) == '5 way' then
        jitter_offset = var.Custom[state].jitter_offset
    else
        if ui.get(var.Custom[state].yaw_jitter_type) == 'Default' then
            jitter_offset = 90
        elseif ui.get(var.Custom[state].yaw_jitter_type) == 'Delay swap' then
            if globals.tickcount() % ui.get(var.Custom[state].j_delay_swap) == 1 then
                should_swap = not should_swap
            end

            jitter_offset = should_swap and ui.get(var.Custom[state].lj_yaw_offset) or ui.get(var.Custom[state].rj_yaw_offset)
        elseif ui.get(var.Custom[state].yaw_jitter_type) == 'L/R' then
            jitter_offset = antiaim.setup_left_right(ui.get(var.Custom[state].lj_yaw_offset), ui.get(var.Custom[state].rj_yaw_offset))
        elseif ui.get(var.Custom[state].yaw_jitter_type) == 'Min/Max' then
            jitter_offset = client.random_int(ui.get(var.Custom[state].lj_yaw_offset), ui.get(var.Custom[state].rj_yaw_offset))
        end
    end

    antiaim.setup_in_use(cmd)
    antiaim.setup_jitter(yaw, var.Custom[state].yaw_jitter, jitter_offset)
    antiaim.setup_desync(var.Custom[state].body_yaw)
    antiaim.setup_miscellaneous(cmd)
    antiaim.setup_conditions(cmd)
    antiaim.avoid_backstab(cmd)
    antiaim.fast_ladder(cmd)
end


fakelag_manipulations = function()
    if not ui.get(enable_lua) then
        return end

    if not ui.get(enable_aa) then
        return end

    local self = entity.get_local_player()

    if not entity.is_alive(self) then
        return end

    if contains(ui.get(fakelag_disablers), 'Double tap') and (ui.get(ref_dt) and ui.get(ref_dt_key)) or
    contains(ui.get(fakelag_disablers), 'Hide shots') and (ui.get(hideshots) and ui.get(hideshots_key)) or
    contains(ui.get(fakelag_disablers), 'Standing') and var.states.is_standing(self) and var.states.no_exploit() then
        if ui.get(ref_fakeduck) then
            ui.set(fakelag_key, 'Always on')
        else
            ui.set(fakelag_key, 'On hotkey')
        end
    else
        ui.set(fakelag_key, 'Always on')
    end
end

local setup_legbreak = function()
    if not ui.get(enable_lua) then 
        return end

    if not ui.get(local_anims) then 
        return end

    if not contains(ui.get(anim_breakers), 'Legs direction') then
        return end

    if ui.get(leg_direction) == 'Leg break' then
        local self = entity.get_local_player()
        local stage = client.random_int(1, 3)

        if stage == 1 then
            ui.set(legmovement, 'Always slide')
        elseif stage == 2 then
            ui.set(legmovement, 'Never slide')
        elseif stage == 3 then
            ui.set(legmovement, 'Always slide')
        end
    end
end

local states = ''
anims.scope_move = 0

local dragging_fn = function(name, base_x, base_y) return (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=ui.new_slider('LUA','A',u..' window position',0,x,v/j*x)local z=ui.new_slider('LUA','A','\n'..u..' window position y',0,x,w/k*x)ui.set_visible(y,false)ui.set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals.framecount()~=b then c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)().new(name, base_x, base_y) end

dragging_damage = dragging_fn('Damage Indicator', scrn_x / 2 + 15, scrn_y / 2 + 10)
local dt_ccolor, hs_ccolor = 0, 0

hitlog.sigma = function()
    local scaling = ui.get(dpi_support) and 'db' or 'b'
    if #hitlog_table > 0 then
        if globals.tickcount() >= hitlog_table[1][2] then
            if hitlog_table[1][3] > 0 then
                hitlog_table[1][3] = hitlog_table[1][3] - 20
            elseif hitlog_table[1][3] <= 0 then
                table.remove(hitlog_table, 1)
            end
        end
        if #hitlog_table > 8 then
            table.remove(hitlog_table, 1)
        end

        if not is_in_game(is_in_game) then
            table.remove(hitlog, #hitlog)
        end
        
        for i = 1, #hitlog_table do
            text_size_x, text_size_y = renderer.measure_text(scaling, hitlog_table[i][1])
           if hitlog_table[i][3] < 255 then 
                hitlog_table[i][3] = hitlog_table[i][3] + 10
            end

            local sc_x, sc_y = client.screen_size()

            local x = sc_x/2
            local y = sc_y/1.3

            local alpha = hitlog_table[i][3]
            renderer.text(x - text_size_x/2 + (hitlog_table[i][3]/35), y + (13*dpi.scaling) * i, 255, 255, 255, 255, scaling, nil, hitlog_table[i][1])
		end
    end
end

local pi, max = math.pi, math.max

local dynamic = {}
dynamic.__index = dynamic

function dynamic.new(f, z, r, xi)
   f = max(f, 0.001)
   z = max(z, 0)

   local pif = pi * f
   local twopif = 2 * pif

   local a = z / pif
   local b = 1 / ( twopif * twopif )
   local c = r * z / twopif

   return setmetatable({
      a = a,
      b = b,
      c = c,

      px = xi,
      y = xi,
      dy = 0
   }, dynamic)
end

function dynamic:update(dt, x, dx)
   if dx == nil then
      dx = ( x - self.px ) / dt
      self.px = x
   end

   self.y  = self.y + dt * self.dy
   self.dy = self.dy + dt * ( x + self.c * dx - self.y - self.a * self.dy ) / self.b
   return self
end

function dynamic:get()
   return self.y
end

local function roundedRectangle(b, c, d, e, f, g, h, i, j, k)
    renderer.rectangle(b, c, d, e, f, g, h, i)
    renderer.circle(b, c, f - 8, g - 8, h - 8, i, k, -180, 0.25)
    renderer.circle(b + d, c, f - 8, g - 8, h - 8, i, k, 90, 0.25)
    renderer.rectangle(b, c - k, d, k, f, g, h, i)
    renderer.circle(b + d, c + e, f - 8, g - 8, h - 8, i, k, 0, 0.25)
    renderer.circle(b, c + e, f - 8, g - 8, h - 8, i, k, -90, 0.25)
    renderer.rectangle(b, c + e, d, k, f, g, h, i)
    renderer.rectangle(b - k, c, k, e, f, g, h, i)
    renderer.rectangle(b + d, c, k, e, f, g, h, i)
end

function rounded_logs()
    local screen = {client.screen_size()}
    for i = 1, #rounded_log do
        if not rounded_log[i] then return end
        if not rounded_log[i].init then
            rounded_log[i].y = dynamic.new(2, 1, 1, -30)
            rounded_log[i].time = globals.tickcount() + 256
            rounded_log[i].init = true
        end
        
        local r,g,b,a
        if rounded_log[i].missed == false then
            r,g,b,a = ui.get(centered_hit_color)
        elseif rounded_log[i].missed == true then
            r,g,b,a = ui.get(centered_miss_color)
        elseif rounded_log[i].loading == true then
            r,g,b,a = 11, 144, 255, 255
        end

        local string_size = renderer.measure_text("c", rounded_log[i].text)
        roundedRectangle(screen[1]/2-string_size/2-25, screen[2]-rounded_log[i].y:get()-100, string_size+30, 16, 21,25,31,175,"", 4)
        renderer.text(screen[1]/2-20, screen[2]-rounded_log[i].y:get()-92, 255,255,255,255,"c",0,rounded_log[i].text)
        renderer.circle_outline(screen[1]/2+string_size/2-6, screen[2]-rounded_log[i].y:get()-92, 13, 13, 13, 255, 7, 0, 1, 4)
        renderer.circle_outline(screen[1]/2+string_size/2-6, screen[2]-rounded_log[i].y:get()-92, r,g,b,a, 6, 0, (rounded_log[i].time-globals.tickcount())/256, 2)
        if tonumber(rounded_log[i].time) < globals.tickcount() then
            if rounded_log[i].y:get() < -10 then
                table.remove(rounded_log, i)
            else
                rounded_log[i].y:update(globals.frametime(), -50, nil)
            end
        else
            rounded_log[i].y:update(globals.frametime(), 20+(i*35), nil)
        end
    end
end

client.set_event_callback('paint_ui', rounded_logs)

centered = function()
    local self = entity.get_local_player()
    if not entity.is_alive(self) then
        return end
    
    if not ui.get(enable_lua) then 
        return end

    if not ui.get(centered_ind) then 
        return end

    local DT_active = ui.get(ref_dt) and ui.get(ref_dt_key)
    local HIDE_active = ui.get(hideshots) and ui.get(hideshots_key)
    local r, g, b = ui.get(centered_color)
    local dt_color = {}

    if antiaim_funcs.get_double_tap() and not ui.get(ref_fakeduck) then
        dt_color = {144, 255, 11}
    else
        dt_color = {255, 11, 11}
    end

    local m_bIsScoped = entity.get_prop(self, "m_bIsScoped") == 1
    local scope_move = animation.new('scope', m_bIsScoped and 35*dpi.scaling or 0, 0.1)

    local alpha = math.floor(math.sin(globals.realtime() * 5 + 4) * 127 + 128)

    local text_to_render = colored_text:text(
        { {255, 255, 255, 255}, 'OVERVEST'},
        { {r, g, b, alpha}, ' BETA'}
    );

    
    renderer.text(scrn_x/2+scope_move, scrn_y/2+30*dpi.scaling, 255, 255, 255, 255, dpi.flags[1], nil, text_to_render)
    renderer.text(scrn_x/2+scope_move, scrn_y/2+40*dpi.scaling, 255, 255, 255, 255, dpi.flags[1], nil, string.format('·   %s   ·', states))

    if DT_active then
        renderer.text(scrn_x/2+scope_move, scrn_y/2+48*dpi.scaling, dt_color[1], dt_color[2], dt_color[3], 255, dpi.flags[1], nil, 'DT')
    elseif HIDE_active then
        renderer.text(scrn_x/2+scope_move, scrn_y/2+48*dpi.scaling, 11, 200, 255, 255, dpi.flags[1], nil, 'HIDE')
    end
end


direction_arrows = function()
    if not is_in_game(is_in_game) then
        return end

    if not ui.get(direction_output) then
        return end

    local self = entity.get_local_player()
    if not entity.is_alive(self) then
        return end

    if not ui.get(enable_lua) then 
        return end

    local r, g, b, a = ui.get(direction_color)
    local alpha = math.floor(math.sin(globals.realtime() * 5 + 4) * 127 + 128) 
    local vel_clr = var.states.is_running(self) and {155, 155, 155, 50, 50} or {100, 100, 100, alpha, 150}
    local scaling_add, scaling_flags = 52*dpi.scaling, dpi.flags[1] .. '+'
    
    if antiaim.force_reset then
        renderer.text(scrn_x/2-scaling_add, scrn_y/2, 100, 100, 100, alpha, scaling_flags, nil, '<')
        renderer.text(scrn_x/2+scaling_add, scrn_y/2, 100, 100, 100, alpha, scaling_flags, nil, '>')
    else
        if antiaim.direction == -90 then
            renderer.text(scrn_x/2-scaling_add, scrn_y/2, r, g, b, a, scaling_flags, nil, '<')
            renderer.text(scrn_x/2+scaling_add, scrn_y/2, vel_clr[1], vel_clr[2], vel_clr[3], vel_clr[5], scaling_flags, nil, '>')
        elseif antiaim.direction == 90 then
            renderer.text(scrn_x/2-scaling_add, scrn_y/2, vel_clr[1], vel_clr[2], vel_clr[3], vel_clr[5], scaling_flags, nil, '<')
            renderer.text(scrn_x/2+scaling_add, scrn_y/2, r, g, b, a, scaling_flags, nil, '>')
        elseif antiaim.direction == 0 then
            renderer.text(scrn_x/2-scaling_add, scrn_y/2, vel_clr[1], vel_clr[2], vel_clr[3], vel_clr[4], scaling_flags, nil, '<')
            renderer.text(scrn_x/2+scaling_add, scrn_y/2, vel_clr[1], vel_clr[2], vel_clr[3], vel_clr[4], scaling_flags, nil, '>')
        end
    end
end

ui_damage = function()
    if not ui.get(enable_lua) then 
        return end

    if not ui.get(minimum_damage) then
        return end

    if not entity.is_alive(entity.get_local_player()) then
        return end

    local value = 0

    if ui.get(min_dmg) and ui.get(min_dmg_key) then
        value = ui.get(min_dmg_slider)
    else
        value = ui.get(def_min_dmg)
    end

    renderer.text(scrn_x/2+10, scrn_y/2-17.5, 255, 255, 255, 255, dpi.flags[2], nil, value)
end

ui_watermark = function()
    if not ui.get(enable_lua) then 
        return end

    if not ui.get(watermark) then 
        return end

    if not is_in_game(is_in_game) then
        return end

    local dpi_scaling = dpi.scaling
    local sx, sy = scrn_x/2, scrn_y/1.015-dpi_scaling*3

    local sys_time = { client.system_time() }
    local actual_time = string.format('%02d:%02d:%02d', sys_time[1], sys_time[2], sys_time[3])
    local INetChannelInfo = ffi_cast(interface_ptr, get_net_channel_info(ivengineclient)) or error('netchaninfo is nil')
    local get_avg_latency = ffi_cast(latency_ptr, INetChannelInfo[0][10])
    local latency = get_avg_latency(INetChannelInfo, 0) * 1000

    local text = string.format('overvest | %s | delay: %s | %s', obex_data.username, math.floor(latency) .. 'ms', actual_time)
    local h, w = 20+dpi_scaling*3, renderer.measure_text(dpi.flags[2], text) + 10

    roundedRectangle(sx-w/2, sy-8, w, h, 21,25,31,175,"", 4)
    renderer.text(sx, sy+dpi_scaling*2, 255, 255, 255, 255, dpi.flags[2], nil, text)
end

local g_aimbot_data = { }
local g_sim_ticks, g_net_data = { }, { }

local cl_data = {
    tick_shifted = false,
    tick_base = 0
}


local plist_el = 
{
    player_list = ui.reference('PLAYERS', 'Players', 'Player list'),
    pl_reset = ui.reference('PLAYERS', 'Players', 'Reset all'),
    or_baim = ui.reference('PLAYERS', 'Adjustments', 'Override prefer body aim'),
    or_spoint = ui.reference('PLAYERS', 'Adjustments', 'Override safe point')
}

local better_baim = {}

better_baim.player_data = { }


better_baim.helpers = {

    angle_to_vec = function(pitch, yaw)
        local deg2rad = math.pi / 180.0
        
        local p, y = deg2rad*pitch, deg2rad*yaw
        local sp, cp, sy, cy = sin(p), cos(p), sin(y), cos(y)
        return cp*cy, cp*sy, -sp
    end,

    vector_angles = function(x1, y1, z1, x2, y2, z2)
        local origin_x, origin_y, origin_z
        local target_x, target_y, target_z
        if x2 == nil then
            target_x, target_y, target_z = x1, y1, z1
            origin_x, origin_y, origin_z = client.eye_position()
            if origin_x == nil then
                return
            end
        else
            origin_x, origin_y, origin_z = x1, y1, z1
            target_x, target_y, target_z = x2, y2, z2
        end
    
        local delta_x, delta_y, delta_z = target_x-origin_x, target_y-origin_y, target_z-origin_z
    
        if delta_x == 0 and delta_y == 0 then
            return (delta_z > 0 and 270 or 90), 0
        else
            local yaw = math.deg(math.atan2(delta_y, delta_x))
    
            local hyp = math.sqrt(delta_x*delta_x + delta_y*delta_y)
            local pitch = math.deg(math.atan2(-delta_z, hyp))
    
            return pitch, yaw
        end
    end,

    is_player_moving = function(ent)
        local vec_vel = { entity.get_prop(ent, 'm_vecVelocity') }
        local velocity = math.floor(math.sqrt(vec_vel[1]^2 + vec_vel[2]^2) + 0.5)

        return velocity > 1
    end,

    predict_positions = function(posx, posy, posz, ticks, ent)
        local x, y, z = entity.get_prop(ent, 'm_vecVelocity')
    
        for i = 0, ticks, 1 do
            posx = posx + x * globals.tickinterval()
            posy = posy + y * globals.tickinterval()
            posz = posz + z * globals.tickinterval() + 9.81 * globals.tickinterval() * globals.tickinterval() / 2
        end
    
        return posx, posy, posz
    end
}

better_baim.calculate_damage = function(local_player, target, predictive)
    local entindex, dmg = -1, -1
    local lx, ly, lz = client.eye_position()

    local px, py, pz = entity.hitbox_position(target, 6) 
    local px1, py1, pz1 = entity.hitbox_position(target, 4)
    local px2, py2, pz2 = entity.hitbox_position(target, 2)

    if predictive and better_baim.helpers.is_player_moving(local_player) then
        lx, ly, lz = better_baim.helpers.predict_positions(lx, ly, lz, 20, local_player)
    end
    
    for i=0, 2 do
        if i == 0 then
            entindex, dmg = client.trace_bullet(local_player, lx, ly, lz, px, py, pz)
        else 
            if i==1 then
                entindex, dmg = client.trace_bullet(local_player, lx, ly, lz, px1, py1, pz1)
            else
                entindex, dmg = client.trace_bullet(local_player, lx, ly, lz, px2, py2, pz2)
            end
        end

        if entindex == nil or entindex == local_player or not entity.is_enemy(entindex) then
            return -1
        end
        
        return dmg
    end

    return -1
end

better_baim.reset = function()
    ui.set(plist_el.pl_reset, true)

    for i=1, 64, 1 do
        better_baim.player_data[i] = {
            missed_shots = 0,
            accuracy_boost = 0,
            safe_point = 0,
            body_aim = 0,
        }
    end
end

better_baim.callback_pl = function(me, e)
    local pl_sp = { [0] = '-', [1] = 'Off', [2] = 'On' }
    local pl_body = { [0] = '-', [1] = 'Off', [2] = 'On', [3] = 'Force' }
    local pl_acb = { [0] = '-', [1] = 'Disable', [2] = 'Low', [3] = 'Medium', [4] = 'High', [5] = 'Maximum' }

    if e == nil or not entity.is_alive(me) then
        return
    end

    local eye_pos = { client.eye_position() }

    local e_data = better_baim.player_data[e]
    local e_wpn = entity.get_player_weapon(e)

    local health = entity.get_prop(e, 'm_iHealth')
    local vec_vel = { entity.get_prop(e, 'm_vecVelocity') }
    local velocity = math.floor(math.sqrt(vec_vel[1]^2 + vec_vel[2]^2) + 0.5)
    local armor = entity.get_prop(e, 'm_ArmorValue')

    local avg_shot_time = globals.tickinterval()*14

    local net_data = {
        is_hp_less = entity.get_prop(e, 'm_iHealth') <= ui.get(hp_condition),
        in_air = vec_vel[3]^2 > 0,
        no_kevlar = armor == 0
    }

    local abs_origin = { entity.get_prop(e, 'm_vecAbsOrigin') }
    local ang_abs = { entity.get_prop(e, 'm_angAbsRotation') }

    local g_damage = better_baim.calculate_damage(me, e, ui.get(predictive_body))

    local pitch, yaw = better_baim.helpers.vector_angles(abs_origin[1], abs_origin[2], abs_origin[2], eye_pos[1], eye_pos[2], eye_pos[3])
    local yaw_degress = math.abs(normalize_yaw(yaw - ang_abs[2]))

    net_data.backwards_to_me = yaw_degress > 90 + 45 or yaw_degress < 90 - 45

    e_data.safe_point = 0
    e_data.body_aim = 0
    e_data.accuracy_boost = 0
    
    local generate_container = function(element)
        return {
            contains(element, 'Target air') and net_data.in_air,
            contains(element, 'Target no armor') and net_data.no_kevlar,
            contains(element, 'Sideways/Roll') and not net_data.backwards_to_me,

            contains(element, '2 Shots') and g_damage >= (health / 2),
            contains(element, 'Lethal') and g_damage >= health,
            contains(element, 'Target <x health') and net_data.is_hp_less
        }
    end

    local force_body = generate_container(ui.get(force_body))
    local force_safety = generate_container(ui.get(force_safety))

    if contains(force_body, true) then e_data.body_aim = 3 end 
    if contains(force_safety, true) then e_data.safe_point = 2 end

    ui.set(plist_el.or_baim, pl_body[e_data.body_aim])
    ui.set(plist_el.or_spoint, pl_sp[e_data.safe_point])
end

better_baim.aim_miss_pl = function(e)
    local e_data = better_baim.player_data[e.target]
    e_data.missed_shots = e_data.missed_shots + 1
end

better_baim.reset()

client.set_event_callback('cs_game_disconnected', better_baim.reset)
client.set_event_callback('game_newmap', better_baim.reset)
client.set_event_callback('round_start', function()
    if not ui.get(better_bodyaim) then
        return end

    better_baim.reset()

    local string = 'Player data was reset due to the new round'
    table.insert(rounded_log, {
        text = string,
        loading = true
})
end)
client.set_event_callback('aim_miss', better_baim.aim_miss_pl)

time_to_ticks = function(t) return math.floor(0.5 + (t / globals.tickinterval())) end
vec_substract = function(a, b) return { a[1] - b[1], a[2] - b[2], a[3] - b[3] } end
vec_lenght = function(x, y) return (x * x + y * y) end

generate_flags = function(e, on_fire_data)
    return {
		e.refined and 'R' or '',
		e.expired and 'E' or '',
		e.noaccept and 'N' or '',
		cl_data.tick_shifted and 'S' or '',
		on_fire_data.teleported and 'T' or '',
		on_fire_data.interpolated and 'INT' or '',
		on_fire_data.extrapolated and 'EXT' or '',
		on_fire_data.boosted and '001' or '',
		on_fire_data.high_priority and 'HP' or ''
    }
end

client.set_event_callback('paint', function()
    if not ui.get(enable_lua) then
        return end
    
    if not ui.get(better_bodyaim) then
        return end

    client.update_player_list()

    local me = entity.get_local_player()
    local players = entity.get_players(true)
    local pl_cache = ui.get(plist_el.player_list)

    if not entity.is_alive(me) then
        goto skip_command
    end

    for i=1, #players do
        ui.set(plist_el.player_list, players[i])

        local handle = ui.get(plist_el.player_list)

        if handle ~= nil and entity.is_enemy(handle) then
            local e_data = better_baim.player_data[handle]
            local origin = { entity.get_prop(handle, 'm_vecAbsOrigin') }

            better_baim.callback_pl(me, handle)
        end
    end

    ::skip_command::

    if pl_cache ~= nil then
        ui.set(plist_el.player_list, pl_cache)
    end
end)

client.set_event_callback('shutdown', function()
    client.update_player_list()
    ui.set(plist_el.pl_reset, true)
end)


local get_entities = function(enemy_only, alive_only)
    local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true
    
    local result = {}
    local player_resource = entity.get_player_resource()
    
    for player = 1, globals.maxplayers() do
        local is_enemy, is_alive = true, true
        
        if enemy_only and not entity.is_enemy(player) then is_enemy = false end
        if is_enemy then
            if alive_only and entity.get_prop(player_resource, 'm_bAlive', player) ~= 1 then is_alive = false end
            if is_alive then table.insert(result, player) end
        end
    end

    return result
end

local g_net_update = function()
	local me = entity.get_local_player()
    local players = get_entities(true, true)
	local m_tick_base = entity.get_prop(me, 'm_nTickBase')
	
    cl_data.tick_shifted = false
    
	if m_tick_base ~= nil then
		if cl_data.tick_base ~= 0 and m_tick_base < cl_data.tick_base then
			cl_data.tick_shifted = true
		end
	
		cl_data.tick_base = m_tick_base
    end

	for i=1, #players do
		local idx = players[i]
        local prev_tick = g_sim_ticks[idx]
        
        if entity.is_dormant(idx) or not entity.is_alive(idx) then
            g_sim_ticks[idx] = nil
            g_net_data[idx] = nil
        else
            local player_origin = { entity.get_origin(idx) }
            local simulation_time = time_to_ticks(entity.get_prop(idx, 'm_flSimulationTime'))
    
            if prev_tick ~= nil then
                local delta = simulation_time - prev_tick.tick

                if delta < 0 or delta > 0 and delta <= 64 then
                    local m_fFlags = entity.get_prop(idx, 'm_fFlags')

                    local diff_origin = vec_substract(player_origin, prev_tick.origin)
                    local teleport_distance = vec_lenght(diff_origin[1], diff_origin[2])

                    g_net_data[idx] = {
                        tick = delta-1,

                        origin = player_origin,
                        tickbase = delta < 0,
                        lagcomp = teleport_distance > 4096,
                    }
                end
            end

            g_sim_ticks[idx] = {
                tick = simulation_time,
                origin = player_origin,
            }
        end
    end
end

local g_aim_fire = function(e)
    local data = e
    local plist_sp = plist.get(e.target, 'Override safe point')
    local check_dt = ui.reference('RAGE','aimbot','Double tap')
	local force_safe_point = ui.reference('RAGE', 'Aimbot', 'Force safe point')
    local checkbox = ui.get(force_safe_point)
    local is_exploiting = ui.get(ref_dt)

    if g_net_data[e.target] == nil then
        g_net_data[e.target] = { }
    end

    data.backtrack = e.backtrack
    data.teleported = g_net_data[e.target].lagcomp or false
    data.choke = g_net_data[e.target].tick or 'u'
    data.self_choke = globals.chokedcommands()
    data.safe_point = ({
        ['Off'] = '0',
        ['On'] = '1',
        ['-'] = '0'
    })[plist_sp]

    data.exploit = ({
        ['Off'] = 'off',
        ['On'] = true,
        ['-'] = is_exploiting
    })

    g_aimbot_data[e.id] = data
end



local layout_states = function(c)
    local self = entity.get_local_player()
    if not entity.is_alive(self) then
        return end

    local table_states =
    {
        [0] = 'STANDING',
        [1] = 'MOVING',
        [2] = 'SLOW MOTION',
        [3] = 'CROUCH',
        [4] = 'AEROBIC',
        [5] = 'AEROBIC+',
        [6] = 'LEGIT AA'
    }

    local cur_state = 0

    if var.states.in_use() then
        cur_state = 6
    else
        if ui.get(ref_fakeduck) then
            cur_state = var.states.on_ground(self, c) and 3 or (var.states.is_crouching(self) and 5 or 4)
        else
            if not var.states.on_ground(self, c) then
                cur_state = var.states.is_crouching(self) and 5 or 4
            elseif var.states.is_crouching(self) then
                cur_state = 3
            elseif var.states.is_running(self) then
                if var.states.is_slowmotion() then
                    cur_state = 2
                else
                    cur_state = 1
                end
            else
                cur_state = 0
            end
        end
    end

    states = table_states[cur_state]
end

local hitgroupes = {'body', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
client.set_event_callback("aim_hit", function(e)

    if g_aimbot_data[e.id] == nil then
        return end
        
    local on_fire_data = g_aimbot_data[e.id]
    local hitchance = math.floor(on_fire_data.hit_chance + 0.5) .. '%'
    local group = hitgroupes[e.hitgroup + 1] or '?'
    local aimed_hgroup = hitgroupes[on_fire_data.hitgroup + 1] or '?'
    local on_fire_data = g_aimbot_data[e.id]
    local flags = generate_flags(e, on_fire_data)
    local target_name = string.format('%s', entity.get_player_name(e.target))

    local prefixr, prefixg, prefixb = ui.get(prefix_color)
    local fader, fadeg, fadeb = ui.get(fade_color)
    local mainr, maing, mainb = ui.get(main_color)
    local mmatchr, mmatchg, mmatchb = ui.get(mismatch_color)

    local text = ''

    if ui.get(aim_debug) then

        if not contains(ui.get(aim_debug_cond), 'Hit') then 
            return end

        if group ~= aimed_hgroup and e.damage == on_fire_data.damage then
            colored_text:console(
                { { prefixr, prefixg, prefixb }, {fader, fadeg, fadeb}, "overvest" },
                { {100, 100, 100}, ' . '},
                { { 255, 255, 255 }, 'Registered shot at ' .. target_name .. '\'s ' },
                { {mainr, maing, mainb}, group },
                { {255, 255, 255}, ' ['},
                { {mmatchr, mmatchg, mmatchb}, aimed_hgroup},
                { {255, 255, 255}, ']'},
                { {255, 255, 255}, ' for '},
                { {mainr, maing, mainb}, string.format('%i', e.damage)},
                { {255, 255, 255}, ' damage'},
                { {255, 255, 255}, ' (hitchance: '},
                { {mainr, maing, mainb}, hitchance},
                { {255, 255, 255}, ' | '},
                { {255, 255, 255}, 'safety: '},
                { {mainr, maing, mainb}, on_fire_data.safe_point},
                { {255, 255, 255}, ' | '},
                { {255, 255, 255}, 'flags: '},
                { {mainr, maing, mainb}, table.concat(flags)},
                { {255, 255, 255}, ')'},
                { { 255, 255, 255}, '\n'}
                );
        elseif group ~= aimed_hgroup and e.damage ~= on_fire_data.damage then
            colored_text:console(
            { { prefixr, prefixg, prefixb }, {fader, fadeg, fadeb}, "overvest" },
            { {100, 100, 100}, ' . '},
            { { 255, 255, 255 }, 'Registered shot at ' .. target_name .. '\'s ' },
            { {mainr, maing, mainb}, group },
            { {255, 255, 255}, ' ['},
            { {mmatchr, mmatchg, mmatchb}, aimed_hgroup},
            { {255, 255, 255}, ']'},
            { {255, 255, 255}, ' for '},
            { {mainr, maing, mainb}, string.format('%i', e.damage)},
            { {255, 255, 255}, ' damage '},
            { {255, 255, 255}, '['},
            { {mmatchr, mmatchg, mmatchb}, string.format('%d', on_fire_data.damage)},
            { {255, 255, 255}, ']'},
            { {255, 255, 255}, ' (hitchance: '},
            { {mainr, maing, mainb}, hitchance},
            { {255, 255, 255}, ' | '},
            { {255, 255, 255}, 'safety: '},
            { {mainr, maing, mainb}, on_fire_data.safe_point},
            { {255, 255, 255}, ' | '},
            { {255, 255, 255}, 'flags: '},
            { {mainr, maing, mainb}, table.concat(flags)},
            { {255, 255, 255}, ')'},
            { { 255, 255, 255}, '\n'}
            );
        elseif group == aimed_hgroup and e.damage ~= on_fire_data.damage then
            colored_text:console(
            { { prefixr, prefixg, prefixb }, {fader, fadeg, fadeb}, "overvest" },
            { {100, 100, 100}, ' . '},
            { { 255, 255, 255 }, 'Registered shot at ' .. target_name .. '\'s ' },
            { {mainr, maing, mainb}, group },
            { {255, 255, 255}, ' for '},
            { {mainr, maing, mainb}, string.format('%i', e.damage)},
            { {255, 255, 255}, ' damage '},
            { {255, 255, 255}, '['},
            { {mmatchr, mmatchg, mmatchb}, string.format('%d', on_fire_data.damage)},
            { {255, 255, 255}, ']'},
            { {255, 255, 255}, ' (hitchance: '},
            { {mainr, maing, mainb}, hitchance},
            { {255, 255, 255}, ' | '},
            { {255, 255, 255}, 'safety: '},
            { {mainr, maing, mainb}, on_fire_data.safe_point},
            { {255, 255, 255}, ' | '},
            { {255, 255, 255}, 'flags: '},
            { {mainr, maing, mainb}, table.concat(flags)},
            { {255, 255, 255}, ')'},
            { { 255, 255, 255}, '\n'}
            );
        elseif group == aimed_hgroup and e.damage == on_fire_data.damage then
            colored_text:console(
            { { prefixr, prefixg, prefixb }, {fader, fadeg, fadeb}, "overvest" },
            { {100, 100, 100}, ' . '},
            { { 255, 255, 255 }, 'Registered shot at ' .. target_name .. '\'s ' },
            { {mainr, maing, mainb}, group },
            { {255, 255, 255}, ' for '},
            { {mainr, maing, mainb}, string.format('%i', e.damage)},
            { {255, 255, 255}, ' damage'},
            { {255, 255, 255}, ' (hitchance: '},
            { {mainr, maing, mainb}, hitchance},
            { {255, 255, 255}, ' | '},
            { {255, 255, 255}, 'safety: '},
            { {mainr, maing, mainb}, on_fire_data.safe_point},
            { {255, 255, 255}, ' | '},
            { {255, 255, 255}, 'flags: '},
            { {mainr, maing, mainb}, table.concat(flags)},
            { {255, 255, 255}, ')'},
            { { 255, 255, 255}, '\n'}
            );
        end
    end

    local remaining = tostring(math.max(entity.get_prop(e.target, 'm_iHealth'), 0))
    local hitr, hitg, hitb = ui.get(centered_hit_color)

    local hit_text = colored_text:text(
        { {255, 255, 255}, 'Hit '},
        { {hitr, hitg, hitb}, target_name},
        { {255, 255, 255}, ' in '},
        { {hitr, hitg, hitb}, group},
        { {255, 255, 255}, ' for '},
        { {hitr, hitg, hitb}, string.format('%i', e.damage)},
        { {255, 255, 255}, ' damage ('},
        { {hitr, hitg, hitb}, remaining},
        { {255, 255, 255}, ' health remaining)'}
    );

    if ui.get(centered_log) and ui.get(centered_style) == 'Sigma'  then
        hitlog_table[#hitlog_table+1] = {(hit_text), globals.tickcount() + 350, 0, 1}
        hitlog_id = hitlog_id == 999 and 1 or hitlog_id + 1 
    end

    if ui.get(centered_log) and ui.get(centered_style) == 'Box'  then
        local string = hit_text
        table.insert(rounded_log, {
            text = string,
            missed = false
    })
    end
end)

client.set_event_callback('aim_miss', function(e)

    if g_aimbot_data[e.id] == nil then
        return end

    local on_fire_data = g_aimbot_data[e.id]
    local group = hitgroupes[e.hitgroup + 1] or '?'
    local hitchance = math.floor(e.hit_chance) .. '%'
    local reason
    local target_name = string.format('%s', entity.get_player_name(e.target))
    if e.reason == '?' then
        reason = 'unknown'
    else
        reason = e.reason
    end

    local prefixr, prefixg, prefixb = ui.get(prefix_color)
    local fader, fadeg, fadeb = ui.get(fade_color)
    local mainr, maing, mainb = ui.get(main_color)
    local mmatchr, mmatchg, mmatchb = ui.get(mismatch_color)
    local missr, missg, missb = ui.get(miss_color)

    if ui.get(aim_debug) then

        if not contains(ui.get(aim_debug_cond), 'Miss') then 
            return end

        colored_text:console(
            { { prefixr, prefixg, prefixb }, {fader, fadeg, fadeb}, "overvest" },
            { {100, 100, 100}, ' . '},
            { { 255, 255, 255 }, 'Missed shot at ' .. target_name .. '\'s ' },
            { {11, 175, 255}, group },
            { {255, 255, 255}, ' ['},
            { {mmatchr, mmatchg, mmatchb}, string.format('%d', on_fire_data.damage)},
            { {255, 255, 255}, '] '},
            { {255, 255, 255}, 'due to '},
            { {missr, missg, missb}, reason},
            { {255, 255, 255}, ' (hitchance: '},
            { {11, 175, 255}, hitchance},
            { {255, 255, 255}, ' | '},
            { {255, 255, 255}, 'safety: '},
            { {11, 175, 255}, on_fire_data.safe_point},
            { {255, 255, 255}, ')'},
            { { 255, 255, 255}, '\n'}
        );
    end

    local miss_r, miss_g, miss_b = ui.get(centered_miss_color)
    local miss_text = colored_text:text(
    { {255, 255, 255}, 'Missed in '},
    { {miss_r, miss_g, miss_b}, group},
    { {255, 255, 255}, ' due to '},
    { {miss_r, miss_g, miss_b}, reason},
    { {255, 255, 255}, ' ('},
    { {miss_r, miss_g, miss_b}, hitchance},
    { {255, 255, 255}, ' hitchance)'}
);

    if ui.get(centered_log) and ui.get(centered_style) == 'Sigma' then
    hitlog_table[#hitlog_table+1] = {(miss_text), globals.tickcount() + 350, 0, 1}
    hitlog_id = hitlog_id == 999 and 1 or hitlog_id + 1 
    end

    if ui.get(centered_log) and ui.get(centered_style) == 'Box'  then
        local string = miss_text
        table.insert(rounded_log, {
            text = string,
            missed = true
    })
    end

end)

local ground_ticks, end_time = 1, 0

ensure_animations = function()
    if not is_in_game(is_in_game) then
        return end
        
    if not ui.get(enable_lua) then 
        return end

    if not ui.get(local_anims) then 
        return end

    local self = entity.get_local_player()

    local self_index = c_entity.new(self)
    local self_anim_state = self_index:get_anim_state()

    if not self_anim_state then
        return
    end

    if contains(ui.get(anim_breakers), 'Force falling') then
        entity.set_prop(self, 'm_flPoseParameter', 1, 6)
    end

    if contains(ui.get(anim_breakers), 'Landing pitch') then
        local on_ground = bit.band(entity.get_prop(self, "m_fFlags"), 1)
    
        if on_ground == 1 then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = globals.curtime() + 1
        end 
        
        if ground_ticks > ui.get(fakelag_limit)+1 and end_time > globals.curtime() then
            entity.set_prop(self, "m_flPoseParameter", 0.4, 12)
        end
    end
    if contains(ui.get(anim_breakers), 'Legs direction') then
        if ui.get(leg_direction) == 'Default' then
            entity.set_prop(self, "m_flPoseParameter", 1, 0)
            ui.set(legmovement, 'Always slide')
        elseif ui.get(leg_direction) == 'Reversed' then
            entity.set_prop(self, "m_flPoseParameter", 0.5, 0)
            ui.set(legmovement, 'Always slide')
        elseif ui.get(leg_direction) == 'Moon walk' then
            if contains(ui.get(moon_walk_cond), 'Land') then
                entity.set_prop(self, "m_flPoseParameter", 0, 7)
                ui.set(legmovement, 'Never slide')
            end
        elseif ui.get(leg_direction) == 'Leg break' then
            if not ui.get(disable_breakanim) then
                local stage = client.random_int(1, 2)
                if stage == 1 then
                    entity.set_prop(self, "m_flPoseParameter", 1, 0)
                elseif stage == 2 then
                    entity.set_prop(self, "m_flPoseParameter", 0.5, 0)
                end
            else
                entity.set_prop(self, "m_flPoseParameter", 1, 0)
            end
        end
    end

    if contains(ui.get(anim_breakers), 'Legacy slowmotion') then
        local self_anim_overlay = self_index:get_anim_overlay(6)
        if not self_anim_overlay then
            return
        end

        if var.states.is_slowmotion() then
            self_anim_overlay.weight = 0
        end
    end

    if contains(ui.get(anim_breakers), 'Legs direction') and antiaim.is_in_air == true and ui.get(leg_direction) == 'Moon walk' then
        local self_anim_overlay = self_index:get_anim_overlay(6)
        if not self_anim_overlay then
            return
        end

        if not contains(ui.get(moon_walk_cond), 'Air') then
            return end

        self_anim_overlay.weight = 1
    end

    if contains(ui.get(anim_breakers), 'Force move lean') then
        local self_anim_overlay = self_index:get_anim_overlay(12)
        if not self_anim_overlay then
            return
        end

        local x_velocity = entity.get_prop(self, "m_vecVelocity[0]")
        if math.abs(x_velocity) >= 3 and not var.states.is_slowmotion() then
            self_anim_overlay.weight = ui.get(movelean_val) / 100
        end
    end
end

setup_pre_render = function()
    ensure_animations()
end

setup_render = function()
    centered()
    direction_arrows()
    ui_watermark()
    ui_damage()
end

setup_ui = function()
    reference_visibility(ui.get(enable_lua))
    global_visibility()
    builder_ui()
    hitlog.sigma()
    dpi.run_scaling(dpi_scale, dpi_support)
    ui.set(left_hotkey, 'On hotkey')
    ui.set(right_hotkey, 'On hotkey')
    ui.set(reset_hotkey, 'On hotkey')
end

setup_aim_fire = function(e)
    g_aim_fire(e)
end

setup_command = function(e)
    layout_states(e)
    antiaim.setup_builder(e)
    fakelag_manipulations()
    setup_legbreak()
    ragebot.force_defensive(e)

    if ui.is_menu_open() then
        e.in_attack = false
        e.in_attack2 = false
    end
end

setup_net_upd = function()
    g_net_update()
    
    if not entity.is_alive(entity.get_local_player()) then
        return end
    local tickbase = entity.get_prop(entity.get_local_player(), 'm_nTickBase')
    tbl.defensive = math.abs(tickbase - tbl.checker)
    tbl.checker = math.max(tickbase, tbl.checker or 0)
end

on_shutdown = function()
    ui.set(fakelag_key, 'Always on')
    reference_visibility(false)
    ui.set_enabled(fakepeek, true)
    ui.set_enabled(fakepeek_key, true)
end


local ON_SETUP do
    client.set_event_callback("aim_fire", setup_aim_fire)
    client.set_event_callback('setup_command', setup_command)
    client.set_event_callback('net_update_end', setup_net_upd)
    client.set_event_callback("pre_render", setup_pre_render)
    client.set_event_callback('paint', setup_render)
    client.set_event_callback('paint_ui', setup_ui)
    client.set_event_callback('shutdown', on_shutdown)
end