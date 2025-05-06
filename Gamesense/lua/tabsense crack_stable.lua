
local ffi = require("ffi")
local http = require('gamesense/http')
local pui = require("gamesense/pui")
local base64 = require("gamesense/base64")
local ent = require("gamesense/entity")
local vector = require("vector")
local set, get = ui.set, ui.get
local username = "wyscigufa9"
local build = "stable"
X,Y = client.screen_size()
local var_table = {};

if username == "wyscigufa9" then username = "wyscigufa9 [DEV]" end



local x, o = '\x14\x14\x14\xFF', '\x0c\x0c\x0c\xFF'

local pattern = table.concat{
    x,x,o,x,
    o,x,o,x,
    o,x,x,x,
    o,x,o,x
  }

local prev_simulation_time = 0
local notify_lol = {}

local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end
local diff_sim = 0

function var_table:sim_diff() 
    local current_simulation_time = time_to_ticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local diff = current_simulation_time - prev_simulation_time
    prev_simulation_time = current_simulation_time
    diff_sim = diff
    return diff_sim
end

local tex_id = renderer.load_rgba(pattern, 4, 4)

local ui_menu = {
    tabs_names = {"antiaim","visuals","misc","config"},
    selected_tab = 1,
    selected_color = { {20, 20, 20, 255}, {210,210,210,255} },
    menu_alpha = 255,
    is_hovered = false,
    dpi_scaling_y = {{84,149},{100,181},{116,213},{132,245},{148,276}},
    pesadelo_na_cozinha2 = {597,741,885,1030,1173 },
    selected_gs_tab = false,
    mouse_press = false,
    old_mpos = {0,0}
}

local function lerp(a, b, t)
    return a + (b - a) * t
end

function ui_menu:is_aa_tab()
    local menu_size = { ui.menu_size() }
  
    
    local menu_pos = { ui.menu_position() }
    local mouse_pos = { ui.mouse_position() }

   local scale = {0,0}
   local scale_x = 0
   local pesadelo_no_direito = 0

    if ui.get(ui.reference("MISC","Settings","DPI scale")) == "100%" then
        scale = { ui_menu.dpi_scaling_y[1][1],ui_menu.dpi_scaling_y[1][2] }
        scale_x = 76
        pesadelo_no_direito = ui_menu.pesadelo_na_cozinha2[1]
    elseif ui.get(ui.reference("MISC","Settings","DPI scale"))  == "125%" then
        scale = { ui_menu.dpi_scaling_y[2][1],ui_menu.dpi_scaling_y[2][2] }
        scale_x = 95
        pesadelo_no_direito = ui_menu.pesadelo_na_cozinha2[2]
    elseif ui.get(ui.reference("MISC","Settings","DPI scale"))  == "150%" then
        scale = { ui_menu.dpi_scaling_y[3][1],ui_menu.dpi_scaling_y[3][2] }
        scale_x = 113
        pesadelo_no_direito = ui_menu.pesadelo_na_cozinha2[3]
    elseif ui.get(ui.reference("MISC","Settings","DPI scale"))  == "175%" then
        scale = { ui_menu.dpi_scaling_y[4][1],ui_menu.dpi_scaling_y[4][2] }
        scale_x = 132
        pesadelo_no_direito = ui_menu.pesadelo_na_cozinha2[4]
    elseif ui.get(ui.reference("MISC","Settings","DPI scale"))  == "200%" then
        scale = { ui_menu.dpi_scaling_y[5][1],ui_menu.dpi_scaling_y[5][2] }
        scale_x = 151
        pesadelo_no_direito = ui_menu.pesadelo_na_cozinha2[5]
    end

    if ui_menu.mouse_press == false then
        ui_menu.old_mpos = mouse_pos
    end      

    if client.key_state(0x1) then
        if not ui_menu.mouse_press then
            ui_menu.mouse_press = true
            if mouse_pos[1] > menu_pos[1] + 5 and mouse_pos[1] < menu_pos[1] + 5 + scale_x then
                if mouse_pos[2] > menu_pos[2] + scale[1] and mouse_pos[2] < menu_pos[2] + scale[2] then
                    ui_menu.selected_gs_tab = true
                    
                elseif mouse_pos[2] > menu_pos[2] + 19 and (menu_size[2] >= pesadelo_no_direito and mouse_pos[2] < menu_pos[2] + menu_size[2] or mouse_pos[2] < menu_pos[2] + pesadelo_no_direito) and ui_menu.selected_gs_tab == true then
                    ui_menu.selected_gs_tab = false
                end
            end
        end
    else
        ui_menu.mouse_press = false
    end
end


function ui_menu:new_tab()

    ui_menu.is_hovered = false
    if not ui.is_menu_open()  then
        ui_menu.menu_alpha = lerp(ui_menu.menu_alpha,0,globals.frametime() * 50)
    else
        ui_menu.menu_alpha = lerp(ui_menu.menu_alpha,255,globals.frametime() * 5)
    end

    if ui_menu.menu_alpha < 50 then return end

    local menu_size = { ui.menu_size() }
    local divide_menu = (menu_size[1] - 12) / #ui_menu.tabs_names
    
    local menu_pos = { ui.menu_position() }
    local mouse_pos = { ui.mouse_position() }

    if not ui_menu.selected_gs_tab then return end

    for k,v in ipairs(ui_menu.tabs_names) do

        if ui_menu.selected_tab == k then
            ui_menu.selected_color[1] = {20, 20, 20}
            ui_menu.selected_color[2] = {210, 210, 210}
        else
            ui_menu.selected_color[1] = {12, 12, 12}
            ui_menu.selected_color[2] = {90, 90, 90}
        end
       
        renderer.text(menu_pos[1] + (divide_menu * k) - divide_menu / 2 ,menu_pos[2] - 25,ui_menu.selected_color[2][1], ui_menu.selected_color[2][2], ui_menu.selected_color[2][3],ui_menu.menu_alpha,"cd+",0,v)

        if mouse_pos[1] > menu_pos[1] + (divide_menu * k) -  divide_menu and mouse_pos[1] < menu_pos[1] + (divide_menu * k) and mouse_pos[2] > menu_pos[2] - 50 and mouse_pos[2] < menu_pos[2] then
            ui_menu.is_hovered = true
            if  client.key_state(0x1) then
                ui_menu.selected_tab = k
            end
        end
    end
    renderer.text(menu_pos[1] + (divide_menu * ui_menu.selected_tab) - divide_menu / 2 ,menu_pos[2] - 25,210, 210, 210,ui_menu.menu_alpha,"cd+",0,ui_menu.tabs_names[ui_menu.selected_tab])
end

function ui_menu:render_tabs() 
    local menu_s = { ui.menu_size() }
    local menu_p = { ui.menu_position() }

    if not ui.is_menu_open()  then
        ui_menu.menu_alpha = lerp(ui_menu.menu_alpha,0,globals.frametime() * 90)
    else
        ui_menu.menu_alpha = lerp(ui_menu.menu_alpha,255,globals.frametime() * 5)
    end

    local divide_menu = (menu_s[1] - 12) / #ui_menu.tabs_names
    
    if ui_menu.menu_alpha < 170 then return end

    if not ui_menu.selected_gs_tab then return end

    renderer.texture(tex_id, menu_p[1] + 1, menu_p[2]-49, menu_s[1] - 2, 50, 255, 255, 255, ui_menu.menu_alpha, "r")

    --renderer.rectangle(menu_p[1] + (divide_menu * ui_menu.selected_tab) - divide_menu + 7, menu_p[2] - 44,divide_menu -1,50,11,11,11,255) 
    
    --top bar
    renderer.rectangle(menu_p[1] ,menu_p[2] - 53,menu_s[1] ,1 ,12,12,12,ui_menu.menu_alpha) 
    renderer.rectangle(menu_p[1] + 2,menu_p[2] - 52,menu_s[1] - 4,5 ,60,60,60,ui_menu.menu_alpha) 
    renderer.rectangle(menu_p[1] + 2,menu_p[2] - 51,menu_s[1] - 4,3 ,40,40,40,ui_menu.menu_alpha) 
    
    --left bar
    renderer.rectangle(menu_p[1] ,menu_p[2] - 53,1,53 ,12,12,12,ui_menu.menu_alpha) 
    renderer.rectangle(menu_p[1] + 1,menu_p[2] - 52,4,52 ,60,60,60,ui_menu.menu_alpha) 
    renderer.rectangle(menu_p[1] + 2,menu_p[2] - 51,3,51 ,40,40,40,ui_menu.menu_alpha) 
    renderer.rectangle(menu_p[1] + 5,menu_p[2] - 48,1,48 ,60,60,60,ui_menu.menu_alpha)
    
    --right bar
    renderer.rectangle(menu_p[1] + menu_s[1] - 1,menu_p[2] - 53,1,53 ,12,12,12,ui_menu.menu_alpha) 
    renderer.rectangle(menu_p[1] + menu_s[1] - 3,menu_p[2] - 52,2,52 ,60,60,60,ui_menu.menu_alpha) 
    renderer.rectangle(menu_p[1] + menu_s[1] - 5,menu_p[2] - 51,3,51 ,40,40,40,ui_menu.menu_alpha)
    renderer.rectangle(menu_p[1] + menu_s[1] - 6,menu_p[2] - 48,1,48 ,60,60,60,ui_menu.menu_alpha) 

    renderer.gradient(menu_p[1] + 7,menu_p[2] - 46, menu_s[1]/2,1, 59, 175, 222, ui_menu.menu_alpha, 202, 70, 205, ui_menu.menu_alpha,true)
                
    renderer.gradient(menu_p[1] + 7 + menu_s[1]/2 ,menu_p[2] - 46, menu_s[1]/2 - 13.3, 1,203, 70, 205, ui_menu.menu_alpha,204, 227, 53, ui_menu.menu_alpha,true)
end

client.set_event_callback("paint_ui", ui_menu.is_aa_tab)
client.set_event_callback("paint_ui", ui_menu.render_tabs)
client.set_event_callback("paint_ui", ui_menu.new_tab)


----------------------------------------------------------------------------------------------------------------------------------------------MENU

to_draw = "no"
to_up = "no"
to_draw_ticks = 0
to_draw_ticksh = 0

function defensive_indicator()

    local diff_mmeme = var_table.sim_diff()

    if diff_mmeme <= -1 then
        to_draw = "yes"
        to_up = "yes"
    end
end 


references = {
    minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    minimum_damage_override = {ui.reference("RAGE", "Aimbot", "Minimum damage override")},
    double_tap = {ui.reference('RAGE', 'Aimbot', 'Double tap')},
    ps = { ui.reference("MISC", "Miscellaneous", "Ping spike") },
    duck_peek_assist = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
	pitch = {ui.reference('AA', 'Anti-aimbot angles', 'Pitch')},
    yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw')},
    yaw_jitter = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')},
    body_yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
    freestanding_body_yaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
	edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
	freestanding = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
    roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
    slow_motion = {ui.reference('AA', 'Other', 'Slow motion')},
    leg_movement = ui.reference('AA', 'Other', 'Leg movement'),
    on_shot_anti_aim = {ui.reference('AA', 'Other', 'On shot anti-aim')}
}

-- [ cool things ]
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
]]

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

local aa_state = {[1] = "G", [2] = "S", [3] = "M", [4] = "A", [5] = "A-C", [6] = "C", [7] = "SW"}
local aa_state_full = {[1] = "Global", [2] = "Stand", [3] = "Move", [4] = "Aero", [5] = "Aero (crouch)", [6] = "Crouch", [7] = "Slowwalk"}

-- (c) Infinity1G's AABuilder 
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
--

contains = function(tbl, arg)
    for index, value in next, tbl do 
        if value == arg then 
            return true end 
        end 
    return false
end

pui.accent = "C3C6FFFF"

-- [ script ui ]
local group = pui.group("aa","anti-aimbot angles")
local resolver_gr = pui.group("aa","other")
local _ui = {
    lua = {
        enable = group:checkbox("\vtabsense - "..username..""),
        tab = group:combobox("\n ", "Anti-aim", "Visuals", "Miscellaneous", "Config"),
        
    },

    antiaim = {
        enable = group:checkbox("Enable"),

        condition = group:combobox("Player state", aa_state_full),

        tweaks = group:multiselect("Tweaks", "Anti-backstab", "Safe head"),
        cfg_export = group:button("Export anti-aim settings", function() config.export() end),
        cfg_import = group:button("Import anti-aim settings", function() config.import() end),
        cfg_reset = group:button("\aFF8282FFReset anti-aim settings", function() config.import("W3siZW5hYmxlIjp0cnVlLCJ0YWIiOiJTZXR0aW5ncyIsImZyZWVzdGFuZGluZyI6WzEsMCwifiJdLCJjb25kaXRpb24iOiJHbG9iYWwiLCJlZGdlX3lhdyI6WzEsMCwifiJdLCJ0d2Vha3MiOlsifiJdfSxbeyJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwiZnJlZXN0YW5kX2JvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJ5YXdfdmFsdWUiOjAsIm92ZXJyaWRlIjp0cnVlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfV0sW3siZGVmZW5zaXZlX21vZGlmaWVycyI6ZmFsc2UsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6ZmFsc2UsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOmZhbHNlLCJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImRlZmVuc2l2ZV9hYV9lbmFibGUiOmZhbHNlLCJib2R5X3lhdyI6Ik9mZiIsInlhdyI6Ik9mZiIsInlhd192YWx1ZSI6MCwieWF3X2ppdHRlcl92YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsImJvZHlfeWF3X3ZhbHVlIjowLCJwaXRjaF92YWx1ZSI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZX0seyJkZWZlbnNpdmVfbW9kaWZpZXJzIjpmYWxzZSwieWF3X2Jhc2UiOiJMb2NhbCB2aWV3IiwicGl0Y2giOiJPZmYiLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjpmYWxzZSwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJ5YXdfdmFsdWUiOjAsInlhd19qaXR0ZXJfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6ZmFsc2UsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6ZmFsc2UsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOmZhbHNlLCJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImRlZmVuc2l2ZV9hYV9lbmFibGUiOmZhbHNlLCJib2R5X3lhdyI6Ik9mZiIsInlhdyI6Ik9mZiIsInlhd192YWx1ZSI6MCwieWF3X2ppdHRlcl92YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsImJvZHlfeWF3X3ZhbHVlIjowLCJwaXRjaF92YWx1ZSI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZX0seyJkZWZlbnNpdmVfbW9kaWZpZXJzIjpmYWxzZSwieWF3X2Jhc2UiOiJMb2NhbCB2aWV3IiwicGl0Y2giOiJPZmYiLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjpmYWxzZSwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJ5YXdfdmFsdWUiOjAsInlhd19qaXR0ZXJfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6ZmFsc2UsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6ZmFsc2UsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlfV1d") end),
        cfg_default = group:button("\vLoad default settings", function() config.import("W3siZW5hYmxlIjp0cnVlLCJ0YWIiOiJTZXR0aW5ncyIsImZyZWVzdGFuZGluZyI6WzEsNCwifiJdLCJjb25kaXRpb24iOiJTbG93d2FsayIsImVkZ2VfeWF3IjpbMSw0LCJ+Il0sInR3ZWFrcyI6WyJBbnRpLWJhY2tzdGFiIiwiU2FmZSBoZWFkIiwifiJdfSxbeyJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwiZnJlZXN0YW5kX2JvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJ5YXdfdmFsdWUiOjAsIm92ZXJyaWRlIjp0cnVlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiRG93biIsImJvZHlfeWF3IjoiSml0dGVyIiwieWF3IjoiMTgwIiwiZnJlZXN0YW5kX2JvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJ5YXdfdmFsdWUiOjgsIm92ZXJyaWRlIjp0cnVlLCJ5YXdfaml0dGVyX3ZhbHVlIjotMTR9LHsieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXciOiIxODAiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6LTczLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X3ZhbHVlIjozLCJvdmVycmlkZSI6dHJ1ZSwieWF3X2ppdHRlcl92YWx1ZSI6NjZ9LHsieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXciOiIxODAiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MSwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOnRydWUsInlhd19qaXR0ZXJfdmFsdWUiOjI4fSx7Inlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiRG93biIsImJvZHlfeWF3IjoiSml0dGVyIiwieWF3IjoiMTgwIiwiZnJlZXN0YW5kX2JvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJ5YXdfdmFsdWUiOjEyLCJvdmVycmlkZSI6dHJ1ZSwieWF3X2ppdHRlcl92YWx1ZSI6NjN9LHsieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXciOiIxODAiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOnRydWUsInlhd19qaXR0ZXJfdmFsdWUiOjI4fSx7Inlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiRG93biIsImJvZHlfeWF3IjoiSml0dGVyIiwieWF3IjoiMTgwIiwiZnJlZXN0YW5kX2JvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJTa2l0dGVyIiwieWF3X3ZhbHVlIjo4LCJvdmVycmlkZSI6dHJ1ZSwieWF3X2ppdHRlcl92YWx1ZSI6LTE2fV0sW3siZGVmZW5zaXZlX21vZGlmaWVycyI6dHJ1ZSwieWF3X2Jhc2UiOiJMb2NhbCB2aWV3IiwicGl0Y2giOiJPZmYiLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjpmYWxzZSwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJ5YXdfdmFsdWUiOjAsInlhd19qaXR0ZXJfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6dHJ1ZSwieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6dHJ1ZSwiYm9keV95YXciOiJPcHBvc2l0ZSIsInlhdyI6IjE4MCIsInlhd192YWx1ZSI6LTEyNiwieWF3X2ppdHRlcl92YWx1ZSI6ODIsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJib2R5X3lhd192YWx1ZSI6LTMwLCJwaXRjaF92YWx1ZSI6MCwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOnRydWUsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiRG93biIsImRlZmVuc2l2ZV9hYV9lbmFibGUiOnRydWUsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiU3BpbiIsInlhd192YWx1ZSI6NTcsInlhd19qaXR0ZXJfdmFsdWUiOjE4MCwieWF3X2ppdHRlciI6IlNraXR0ZXIiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOjg5LCJmb3JjZV9kZWZlbnNpdmUiOnRydWV9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6dHJ1ZSwieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJDdXN0b20iLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjp0cnVlLCJib2R5X3lhdyI6Ik9mZiIsInlhdyI6IlNwaW4iLCJ5YXdfdmFsdWUiOjM5LCJ5YXdfaml0dGVyX3ZhbHVlIjoxODAsInlhd19qaXR0ZXIiOiJTa2l0dGVyIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjo2MCwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOnRydWUsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiQ3VzdG9tIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6dHJ1ZSwiYm9keV95YXciOiJKaXR0ZXIiLCJ5YXciOiJTcGluIiwieWF3X3ZhbHVlIjotMTU0LCJ5YXdfaml0dGVyX3ZhbHVlIjotOTEsInlhd19qaXR0ZXIiOiJPZmYiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOi03OCwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOnRydWUsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiVXAiLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjp0cnVlLCJib2R5X3lhdyI6Ik9mZiIsInlhdyI6IjE4MCIsInlhd192YWx1ZSI6LTE2MiwieWF3X2ppdHRlcl92YWx1ZSI6NDMsInlhd19qaXR0ZXIiOiJTa2l0dGVyIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOnRydWV9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6dHJ1ZSwieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJSYW5kb20iLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjp0cnVlLCJib2R5X3lhdyI6Ik9wcG9zaXRlIiwieWF3IjoiU3BpbiIsInlhd192YWx1ZSI6MzksInlhd19qaXR0ZXJfdmFsdWUiOi0xNDQsInlhd19qaXR0ZXIiOiJTa2l0dGVyIiwiYm9keV95YXdfdmFsdWUiOjE4MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZX1dXQ==") new_notify("Successfully! Loaded default config", 255,255,255,255) end)
    },

    visuals = {
        style = group:combobox("Style", "Default", "Modern"),
        color_style = ui.new_color_picker("aa", "anti-aimbot angles", "Color", 195,198,255,255),
        style_round = group:slider("hitlogs -> rounding", 0, 10),
        style_width = group:slider("hitlogs -> glow width", 5, 20),
        hitlogs = group:multiselect("Hitlogs", "Hit", "Miss", "Fired"),
        indicators_on = group:checkbox("Indicators", {195,198,255,255}),
        indicators = group:combobox("Style", "Minimal", "Pixel"),
        watermark = group:checkbox("Watermark", {195,198,255,255}),
        slowed_down = group:checkbox("Slowed down", {195,198,255,255}),
        defensive_ind = group:checkbox("Defensive indicator", {195,198,255,255}),
        min_dmg_ind = group:checkbox("Minimum Damage Override Indicator", {195,198,255,255}),
        damage_ind = group:checkbox("3D hitmarker", {195,198,255,255}),
        dmg_ind_mode = group:multiselect("animations", "position", "transparency"),
    },

    misc = {
        anims = group:multiselect("Anims", "pitch 0","reversed legs","moonwalk","static legs", "leg braker"),
        console_filter = group:checkbox("Console filter"),
        discharge = group:checkbox("Auto discharge exploit (only scout & awp)"),
        d_mode = group:combobox("Mode", "Instant", "Ideal"),
        clantag_h = group:checkbox("Clantag"),
        fast_ladder = group:checkbox("Fast ladder"),
    },

    resolver = {
        keys = resolver_gr:multiselect("Binds", "Freestanding", "Edge yaw", "Manuals"),
        freestanding = resolver_gr:hotkey("Freestanding"),
        edge_yaw = resolver_gr:hotkey("Edge yaw"),
        manual_left = resolver_gr:hotkey("Manual left"),
        manual_right = resolver_gr:hotkey("Manual right"),
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
    aa_builder[i].static_freestand = group:checkbox("\v"..aa_state_full[i].."\r  Static Freestanding")
    aa_builder[i].lag_switch = group:checkbox("\v"..aa_state_full[i].."\r  Lag switch")
    aa_builder[i].lag_switch_timer = group:slider("\v"..aa_state_full[i].."\r  Lag switch time", 1, 15, 10)

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
_ui.lua.tab:depend({_ui.lua.enable, true}, {_ui.lua.tab, "cgyh"})

-- antiaim
_ui.antiaim.enable:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"})
_ui.antiaim.condition:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true})
for i = 1, 7 do
    aa_builder[i].override:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]})
    aa_builder[i].pitch:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].yaw_base:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].yaw_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].yaw, "180", "Spin"})
    aa_builder[i].yaw_jitter:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].yaw_jitter_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].yaw_jitter, "Offset", "Center", "Random", "Skitter"})
    aa_builder[i].body_yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].body_yaw_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].body_yaw, "Jitter", "Static"})
    aa_builder[i].freestand_body_yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].body_yaw, "Opposite", "Jitter", "Static"})
    aa_builder[i].static_freestand:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder[i].lag_switch:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {_ui.antiaim.condition, "Aero", "Aero (crouch)"})
    aa_builder[i].lag_switch_timer:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].lag_switch, true}, {_ui.antiaim.condition, "Aero", "Aero (crouch)"})

    aa_builder_defensive[i].defensive_modifiers:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    aa_builder_defensive[i].force_defensive:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true})
    aa_builder_defensive[i].defensive_aa_enable:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true})
    aa_builder_defensive[i].pitch:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].pitch_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].pitch, "Custom"}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].yaw_base:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].yaw_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder_defensive[i].yaw, "180", "Spin"}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].yaw_jitter:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].yaw_jitter_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder_defensive[i].yaw_jitter, "Offset", "Center", "Random", "Skitter"}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].body_yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
    aa_builder_defensive[i].body_yaw_value:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.condition, aa_state_full[i]}, {aa_builder_defensive[i].defensive_modifiers, true}, {aa_builder_defensive[i].body_yaw, "Jitter", "Static"}, {aa_builder[i].override, true}, {aa_builder_defensive[i].defensive_aa_enable, true})
end
for k,v in pairs({_ui.antiaim.cfg_export, _ui.antiaim.cfg_import, _ui.antiaim.cfg_reset, _ui.antiaim.cfg_default}) do v:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Config"}) end

-- misc
for k,v in pairs({_ui.misc.console_filter, _ui.misc.discharge,}) do v:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Miscellaneous"}) end
_ui.misc.d_mode:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Miscellaneous"}, {_ui.misc.discharge, true})
_ui.antiaim.tweaks:depend({_ui.lua.tab, "Miscellaneous"}, {_ui.lua.enable, true})
_ui.visuals.watermark:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Visuals"})
_ui.visuals.hitlogs:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Visuals"})
_ui.visuals.indicators_on:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Visuals"})
_ui.visuals.style:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Visuals"})
_ui.visuals.indicators:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Visuals"}, {_ui.visuals.indicators_on, true})
_ui.visuals.slowed_down:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Visuals"})
_ui.visuals.defensive_ind:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Visuals"})
_ui.visuals.min_dmg_ind:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Visuals"})
_ui.visuals.damage_ind:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Visuals"})
_ui.visuals.dmg_ind_mode:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Visuals"}, {_ui.visuals.damage_ind, true})
_ui.misc.anims:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Miscellaneous"})
_ui.resolver.keys:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"})
_ui.resolver.freestanding:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.resolver.keys, "Freestanding"})
_ui.resolver.edge_yaw:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.resolver.keys, "Edge yaw"})
_ui.resolver.manual_left:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.resolver.keys, "Manuals"})
_ui.resolver.manual_right:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Anti-aim"}, {_ui.resolver.keys, "Manuals"})
_ui.misc.clantag_h:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Miscellaneous"})
_ui.misc.fast_ladder:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Miscellaneous"})
_ui.visuals.style_round:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Visuals"}, {_ui.visuals.style, "Modern"})
_ui.visuals.style_width:depend({_ui.lua.enable, true}, {_ui.lua.tab, "Visuals"}, {_ui.visuals.style, "Modern"})

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
    new_notify("Successfully! Exported settings to clipboard", 255,255,255,255)
end

config.import = function(input)
    decrypted = json.parse(base64.decode(input ~= nil and input or clipboard_import()))
    package:load(decrypted)
    new_notify("Successfully! Imported settings from clipboard", 255,255,255,255)
end

-- [ antiaim features ]
local function choking(cmd)
    local choke = false

    if cmd.allow_send_packet == false or cmd.chokedcommands > 1 then
        choke = true
    else
        choke = false
    end

    return choke
end

local ref_aim_check = ui.reference("Rage", "Aimbot", "Enabled")
local ref_duckpeek = ui.reference("Rage", "Other", "Duck peek assist")

local m_iSide = 0
function manualaa()
    if m_iSide == 0 then
        if ui.get(_ui.resolver.manual_left.ref) then
            m_iSide = 1
        elseif ui.get(_ui.resolver.manual_right.ref) then
            m_iSide = 2
        end
    elseif m_iSide == 1 then
        if ui.get(_ui.resolver.manual_right.ref) then
            m_iSide = 2
        elseif ui.get(_ui.resolver.manual_left.ref) then
            m_iSide = 0
        end
    elseif m_iSide == 2 then
        if ui.get(_ui.resolver.manual_left.ref) then
            m_iSide = 1
        elseif ui.get(_ui.resolver.manual_right.ref) then
            m_iSide = 0
        end
    end

    return m_iSide
end


local antiaim_features = function(cmd)
    if not _ui.antiaim.enable.value or not _ui.lua.enable.value or not entity.get_local_player() then return end

    local state = get_state(get_velocity())
    local players = entity.get_players(true)
    local get_override = aa_builder[state].override.value and state or 1

    ui.set(ref.roll, 0)
   -- ui.set(ref.freestand[2], "always on")
   --print(ui.get(ref.freestand[1]))

    --print(client.current_threat())

    -- antiaim builder
    for k, v in pairs(ref) do
        local key = (is_defensive_active() and not choking(cmd) and aa_builder_defensive[get_override].defensive_modifiers.value and aa_builder_defensive[get_override].defensive_aa_enable.value) and aa_builder_defensive[get_override][k] or aa_builder[get_override][k]
        
        if key then
            ui.set(v, key.value)
        end
    end

    if manualaa() == 1 then
        ui.set(ref.pitch, "down")
        ui.set(ref.yaw, "180")
        ui.set(ref.yaw_value, -90)
        ui.set(ref.yaw_base, "At targets")
        ui.set(ref.yaw_jitter, "Off")
        ui.set(ref.body_yaw, "Static")
        ui.set(ref.body_yaw_value, 0)
        ui.set(ref.freestand_body_yaw, false)
    end
    if manualaa() == 2 then
        ui.set(ref.pitch, "down")
        ui.set(ref.yaw, "180")
        ui.set(ref.yaw_value, 90)
        ui.set(ref.yaw_base, "At targets")
        ui.set(ref.yaw_jitter, "Off")
        ui.set(ref.body_yaw, "Static")
        ui.set(ref.body_yaw_value, 0)
        ui.set(ref.freestand_body_yaw, false)
    end

    if aa_builder[get_override].lag_switch.value then
        local timer = entity.get_prop(entity.get_local_player(), "m_nTickbase") % aa_builder[get_override].lag_switch_timer.value == 0
        local air = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 0

        if air then
            ui.set(ref_duckpeek, timer and "Always on" or "Toggle")
            ui.set(ref_aim_check, false)

            cmd.in_duck = not timer
        else
            ui.set(ref_aim_check, true)
            ui.set(ref_duckpeek, "Toggle")
        end
    end

    --static freestand
    if ui.get(ref.freestand[1]) and aa_builder[get_override].static_freestand.value then
        ui.set(ref.pitch, "down")
        ui.set(ref.yaw, "180")
        ui.set(ref.yaw_value, -1)
        ui.set(ref.yaw_base, "At targets")
        ui.set(ref.yaw_jitter, "Off")
        ui.set(ref.body_yaw, "Static")
        ui.set(ref.body_yaw_value, 0)
        ui.set(ref.freestand_body_yaw, false)
    end

    -- safe head
    if contains(_ui.antiaim.tweaks.value, "Safe head") then
        for i, v in pairs(players) do
            local local_player_origin = vector(entity.get_origin(entity.get_local_player()))
            local player_origin = vector(entity.get_origin(v))
            local difference = (local_player_origin.z - player_origin.z)
            local local_player_weapon = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))

            --print(local_player_weapon)

            if (local_player_weapon == "CKnife" and state == 5 and difference > -70) then    
                ui.set(ref.pitch, "down")
                ui.set(ref.yaw, "180")
                ui.set(ref.yaw_value, -1)
                ui.set(ref.yaw_base, "At targets")
                ui.set(ref.yaw_jitter, "Off")
                ui.set(ref.body_yaw, "Static")
                ui.set(ref.body_yaw_value, 0)
                ui.set(ref.freestand_body_yaw, false)
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

    -- force defensive
    cmd.force_defensive = aa_builder_defensive[get_override].force_defensive.value and true

    -- binds
    ui.set(ref.freestand[1], ui.get(_ui.resolver.freestanding.ref) and true or false)
    ui.set(ref.edgeyaw, ui.get(_ui.resolver.edge_yaw.ref) and true or false)
end

-- [ console filter ]
ui.set_callback(_ui.misc.console_filter.ref, function()
    print("console")
    cvar.con_filter_text:set_string("cool text")
    cvar.con_filter_enable:set_int(1)
end)

-- [ auto discharge exploit ]
local auto_discharge = function(cmd)
    if not _ui.misc.discharge.value or not _ui.lua.enable.value or ui.get(ref.quick_peek[2]) or not ui.get(ref.doubletap[2]) or 
    (entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponSSG08" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponAWP") then return end

    local vel_2 = math.floor(entity.get_prop(entity.get_local_player(), "m_vecVelocity[2]"))

    if is_vulnerable() then
        if _ui.misc.d_mode.value == "Ideal" then if vel_2 > 20 then return end end
        cmd.in_jump = false
        cmd.discharge_pending = true
    end
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function clamp(value, minVal, maxVal)
    return math.max(minVal, math.min(value, maxVal))
end

function rgba_to_hex(b,c,d,e)
    return string.format('%02x%02x%02x%02x',b,c,d,e)
end

function text_fade_animation(speed, r, g, b, a, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i=0, #text do
        local color = rgba_to_hex(r, g, b, a*math.abs(1*math.cos(2*speed*curtime/4+i*5/30)))
        final_text = final_text..'\a'..color..text:sub(i, i)
    end
    return final_text
end

function text_fade_animation_guwno(speed, r, g, b, a, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local color = rgba_to_hex(r, g, b, a * math.abs(1 * math.cos(2 * speed * curtime / 4 - i * 5 / 30)))
        final_text = final_text .. '\a' .. color .. text:sub(i, i)
    end
    return final_text
end

function animate_text(time, string, r, g, b, a)
    local t_out, t_out_iter = { }, 1

    local l = string:len( ) - 1

    local r_add = (255 - r)
    local g_add = (255 - g)
    local b_add = (255 - b)
    local a_add = (155 - a)

    for i = 1, #string do
        local iter = (i - 1)/(#string - 1) + time
        t_out[t_out_iter] = "\a" .. rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )

        t_out[t_out_iter + 1] = string:sub( i, i )

        t_out_iter = t_out_iter + 2
    end

    return t_out
end

--"Anti-aim", "Visuals", "Miscellaneous", "Config"
-- [ callbacks ]
client.set_event_callback("paint_ui", function()
    if ui.is_menu_open() then
        hide_refs(true)
        ui.set_visible(aa_builder[1].override.ref, false) ui.set(aa_builder[1].override.ref, true)
    end

    ui.set_visible(_ui.visuals.color_style, ui_menu.selected_tab == 2 and _ui.visuals.style.value == "Modern")

    if(ui_menu.selected_tab == 4) then
        _ui.lua.tab:override("Config")
    elseif (ui_menu.selected_tab == 3) then
        _ui.lua.tab:override("Miscellaneous")
    elseif (ui_menu.selected_tab == 2) then
        _ui.lua.tab:override("Visuals")   
    elseif (ui_menu.selected_tab == 1) then
        _ui.lua.tab:override("Anti-aim")
    end
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


client.set_event_callback("setup_command", function(cmd)
    antiaim_features(cmd)
    auto_discharge(cmd)
    defensive_indicator()
end)

client.set_event_callback("shutdown", function()
    hide_refs(false)
end)

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}

local function aim_hit(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"

    --https://docs.gamesense.gs/docs/events/aim_hit
    if contains(_ui.visuals.hitlogs.value, "Hit") then
        new_notify(string.format("Hit %s in the %s for %d damage (%d health remaining)", entity.get_player_name(e.target), group, e.damage, entity.get_prop(e.target, "m_iHealth") ), 255,255,255,255)
    end
end

client.set_event_callback("aim_hit", aim_hit)

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}

local function aim_miss(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"

    if contains(_ui.visuals.hitlogs.value, "Miss") then
        new_notify(string.format("Missed %s (%s) due to %s", entity.get_player_name(e.target), group, e.reason), 255,255,255,255)
    end
end

client.set_event_callback("aim_miss", aim_miss)

local hitmarker_xd = {}

--https://docs.gamesense.gs/docs/events/aim_fire
local function aim_fire(e)
    local flags = {
        e.teleported and "T" or "",
        e.interpolated and "I" or "",
        e.extrapolated and "E" or "",
        e.boosted and "B" or "",
        e.high_priority and "H" or ""
    }

    local group = hitgroup_names[e.hitgroup + 1] or "?"
    if contains(_ui.visuals.hitlogs.value, "Fired") then
        new_notify(string.format(
            "Fired at %s (%s) for %d dmg (chance=%d%%, flags=%s)",
            entity.get_player_name(e.target), group, e.damage,
            math.floor(e.hit_chance + 0.5),
            table.concat(flags)
        ))
    end

    hitmarker_xd[globals.tickcount()] = {e.x,e.y,e.z, globals.curtime() + 2.8, e.damage, 0, 0, 255}
end

client.set_event_callback("aim_fire", aim_fire)

function render_ogskeet_border(x,y,w,h,a,text)
    renderer.rectangle(x - 10, y - 48 ,w + 20, h + 16,12,12,12,a)
    renderer.rectangle(x - 9, y - 47 ,w + 18, h + 14,60,60,60,a)
    renderer.rectangle(x - 8, y - 46 ,w + 16, h + 12,40,40,40,a)
    renderer.rectangle(x - 5, y - 43 ,w + 10, h + 6,60,60,60,a)
    renderer.rectangle(x - 4, y - 42 ,w + 8, h + 4,12,12,12,a)
    renderer.gradient(x - 4,y - 42, w /2, 1, 59, 175, 222, a, 202, 70, 205, a,true)               
    renderer.gradient(x - 4 + w / 2 ,y - 42, w /2 + 8, 1,202, 70, 205, a,204, 227, 53, a,true)
    renderer.text(x, y - 40, 255,255,255,230, "", nil, text)
end

function render_rect_outline(x,y,w,h,r,g,b,a) 
    renderer.line(x, y, x + w, y, r,g,b,a)
    renderer.line(x, y, x, y + h, r,g,b,a)
    renderer.line(x, y + h, x + w, y + h, r,g,b,a)
    renderer.line(x + w, y, x + w, y + h, r,g,b,a)
end

local function intersect(x, y, width, height)
    local cx, cy = ui.mouse_position()
    return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

local ind_ref = ui.reference("VISUALS", "Other ESP", "Feature indicators") 

local ind_add_x = 0
local end_time = 0
local ground_ticks = 1

watermark_x, watermark_y = X - 90, Y / 2

local clantags = {
    '',
    't',
    'ta',
    'tab',
    'tabs',
    'tabse',
    'tabsen',
    'tabsens',
    'tabsense',
    'tabsense',
    'tabsense',
    'tabsense',
    'bsense',
    'sense',
    'nse',
    'se',
    'e',
    ''
}

local clantag_prev
local lerp_alpha = 0
local ctx = (function()
    local ctx = {}

    ctx.m_render = {
        rec = function(self, x, y, w, h, radius, color)
            radius = math.min(x/2, y/2, radius)
            local r, g, b, a = unpack(color)
            renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
            renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
            renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
            renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
            renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
            renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
            renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
        end,

        rec_outline = function(self, x, y, w, h, radius, thickness, color)
            radius = math.min(w/2, h/2, radius)
            local r, g, b, a = unpack(color)
            if radius == 1 then
                renderer.rectangle(x, y, w, thickness, r, g, b, a)
                renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
            else
                renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
                renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
                renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
                renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
                renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
                renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
                renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
                renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
            end
        end,

        glow_module = function(self, x, y, w, h, width, rounding, accent, accent_inner)
            local thickness = 1
            local offset = 1
            local r, g, b, a = unpack(accent)
            if accent_inner then
                self:rec(x , y, w, h + 1, rounding, accent_inner)
            end
            for k = 0, width do
                if a * (k/width)^(1) > 5 then
                    local accent = {r, g, b, a * (k/width)^(2)}
                    self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
                end
            end
        end
    }

    ctx.animation = {
        gradient_text = function(text, speed, r,g,b,a)
            local final_text = ''
            local curtime = globals.curtime()
            local center = math.floor(#text / 2) + 1  -- calculate the center of the text
            for i=1, #text do
                -- calculate the distance from the center character
                local distance = math.abs(i - center)
                -- calculate the alpha based on the distance and the speed and time
                a = 255 - math.abs(255 * math.sin(speed * curtime / 4 - distance * 4 / 20))
                local col = rgba_to_hex(r,g,b,a)
                final_text = final_text .. '\a' .. col .. text:sub(i, i)
            end
            return final_text
        end
    }

    ctx.math = {
        calculatePercentage = function(ticks, przez)
            local percentage = (ticks / przez) * 100
            return percentage
        end
    }

    ctx.watermark = {
        render = function()
            if(_ui.visuals.watermark.value) then
                local color_table = { _ui.visuals.watermark:get_color() }
                local r,g,b,a = unpack(color_table)
                local text_size = vector(renderer.measure_text("cb", "T A B S E N S E  ["..build:gsub(".", " %0"):sub(2):upper() .."]"))

                if ui.is_menu_open() then
                    renderer.text(watermark_x, watermark_y-20, 255, 255, 255, 200, "c", nil, "M2 - CENTER")
                    render_rect_outline(watermark_x - text_size.x /2 - 3, watermark_y - 10, text_size.x + 7, text_size.y + 9, 255,255,255,255)
                end

                if client.key_state(0x01) and ui.is_menu_open() then
                    local mouse_pos = { ui.mouse_position() }
                    if intersect(watermark_x - text_size.x /2 - 3, watermark_y - 10, text_size.x + 7, text_size.y + 9) then
                        watermark_x = mouse_pos[1]
                        watermark_y = mouse_pos[2]
                    end
                end

                if client.key_state(0x02) and ui.is_menu_open() then
                    if intersect(watermark_x - text_size.x /2 - 3, watermark_y - 10, text_size.x + 7, text_size.y + 9) then
                        watermark_x = X / 2
                    end
                end

              --print(ui.mouse_position()[1])
                renderer.text(watermark_x, watermark_y, 255, 255, 255, 255, "cb", nil, text_fade_animation_guwno(1, r, g, b, a, "T A B S E N S E ").. "\a"..rgba_to_hex(r,g,b,a).."["..build:gsub(".", " %0"):sub(2):upper().."]")
            else
                local color_table = { _ui.visuals.watermark:get_color() }
                local r,g,b,a = unpack(color_table)
                --wraith watermark hehe
                --@wyscigufa

              --  local text_size_guwno = vector(renderer.measure_text("cb", "tabsense - "..build..""))
               -- renderer.gradient(X - 70 - text_size_guwno.x /2 -5, Y - Y + 30, text_size_guwno.x / 2 + 5, 20, 0,0,0,0, 0,0,0,130, true)
              --  renderer.gradient(X - 70, Y - Y + 30, text_size_guwno.x / 2 + 5, 20, 0,0,0,130, 0,0,0,0, true)
              --  renderer.text(X - 120 + text_size_guwno.x /2, Y - Y + 39, 255, 255, 255, 255, "c", nil, "tabsense - "..build.."")
                local float = math.sin(globals.realtime() * 2.3) * 15
                renderer.text(X/2, Y/2 + 500 + float, 255,150,150,255, "cb", 0, ctx.animation.gradient_text("TABSENSE", 5, r,g,b,a))
            end
        end
    }

    ctx.dt_green_defensive = {
        render = function()
            if(is_defensive_active()) then
                renderer.indicator(143,194,21,255, "DT")
                --ui.set(ind_ref,false,3)
               -- ui.set(ind_ref[3], false)
            else
               -- ui.set(ind_ref,true,3)
                --ui.set(ind_ref[3], true)
              --  ui.set(ind_ref, 3, true)
            end
        end
    }

    ctx.indicators = {
        render = function()
            if entity.is_alive(entity.get_local_player()) then
                local scoped = entity.get_prop(entity.get_local_player(),"m_bIsScoped") == 1 and true or false
                ind_add_x = lerp(ind_add_x, scoped and 27 or 0, 17 * globals.frametime())
                local is_dt = ui.get(references.double_tap[2])
                local is_hs = ui.get(references.on_shot_anti_aim[2])
                local is_fd = ui.get(references.duck_peek_assist)
                local is_qp = ui.get(ref.quick_peek[2])
                local nextAttack = entity.get_prop(entity.get_local_player(), "m_flNextAttack")
                local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_flNextPrimaryAttack")
                local dtActive = false
                local color_table = { _ui.visuals.indicators_on:get_color() }
                local r,g,b,a = unpack(color_table)

                if nextPrimaryAttack ~= nil then
                    dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
                end

                if _ui.visuals.indicators.value == "Minimal" and _ui.visuals.indicators_on.value == true then
                    renderer.text(X / 2 + ind_add_x, Y / 2 + 24, r, g, b, 255, "c", 0, text_fade_animation(1, r,g,b,a, "tabsense"))
                    if is_dt and dtActive then
                        local work = animate_text(globals.curtime(), "ready", r,g,b,a)
                        renderer.text(X / 2 + ind_add_x, Y / 2 + 34, 255,255,255,255, "c", 0, "dt ",unpack(work))
                    elseif is_dt and not dtActive then
                        local charg = animate_text(globals.curtime(), "charging", r,g,b,a)
                        renderer.text(X / 2 + ind_add_x, Y / 2 + 34, 255,255,255,255, "c", 0, "dt ", unpack(charg))
                    end
                    renderer.text(X / 2 + ind_add_x, is_dt and  Y /2 + 44 or Y /2 + 34, 255, 255, 255, 220, "c", 0, "- ".. string.lower(aa_state_full[get_state(get_velocity())]).. " -")
                elseif _ui.visuals.indicators.value == "Pixel" and _ui.visuals.indicators_on.value == true then
                    renderer.text(X / 2 + ind_add_x, Y / 2 + 24, r, g, b, 255, "c-", 0, text_fade_animation(1, r,g,b,a, string.upper("tabsense")))
                    renderer.text(X / 2 + ind_add_x, Y /2 + 32, 255, 255, 255, 220, "c-", 0, "- ".. string.upper(aa_state_full[get_state(get_velocity())]).. " -")

                    local m_indicators = {{text = "DT", color = is_dt == true and {r,g,b} or {92,92,92}},{text = "OS",color = is_hs == true and {r,g,b} or {92,92,92}}, {text = "QP", color = is_qp == true and {r,g,b} or {92,92,92}}, {text = "FD", color = is_fd == true and {r,g,b} or {92,92,92}}}
                    for i, v in pairs(m_indicators) do
                        r,g,b = unpack(v.color)
                        renderer.text(X / 2 - 29 + i*12 + ind_add_x, Y /2 + 40, r,g,b, 220, "c-", 0, v.text)
                    end
                end
            end
        end
    }

    ctx.anims = {
        run = function()
            if not entity.is_alive(entity.get_local_player()) then
                end_time = 0
                ground_ticks = 0
                return
            end
        
            if contains(_ui.misc.anims.value,"pitch 0") then
        
                
                local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
        
                if on_ground == 1 then
                    ground_ticks = ground_ticks + 1
                else
                    ground_ticks = 0
                    end_time = globals.curtime() + 1
                end
        
                if  ground_ticks > 5 and end_time + 0.5 > globals.curtime() then
                    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
                end
            end
        
            if contains(_ui.misc.anims.value,"reversed legs") then
                local math_randomized = math.random(1,2)
        
                ui.set(ui.reference("AA", "Other", "Leg movement"), math_randomized == 1 and "Always slide" or "Never slide")
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
            end
        
            if contains(_ui.misc.anims.value,"static legs") then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
            end
        
            if contains(_ui.misc.anims.value,"moonwalk") then
               
        
                local me = ent.get_local_player()
                local m_fFlags = me:get_prop("m_fFlags")
                local is_onground = bit.band(m_fFlags, 1) ~= 0
                if not is_onground then
                    local my_animlayer = me:get_anim_overlay(6) 
                   
                    my_animlayer.weight = 1
                else
                    ui.set(ui.reference("AA", "Other", "Leg movement"),"Off")
                    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
                end
            end  

            if contains(_ui.misc.anims.value, "leg braker") then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", client.random_float(0.75, 1), 0)
                ui.set(ui.reference('AA', 'Other', 'Leg movement'), client.random_int(1, 2) == 1 and "Off" or "Always slide")
            end
        end
    }

    ctx.min_dmg_ind = {
        render = function()
            local color_table = { _ui.visuals.min_dmg_ind:get_color() }
            local r,g,b,a = unpack(color_table)
            if _ui.visuals.min_dmg_ind.value then
                if ui.get(references.minimum_damage_override[2]) then
                    renderer.text(X / 2 + 2, Y / 2 - 14, r, g, b, a, "d", 0, ui.get(references.minimum_damage_override[3]) .. "")
                end
            end
        end
    }

    ctx.damage_ind_guwno = {
        render = function()  
            if _ui.visuals.damage_ind.value then
                local color_table = { _ui.visuals.damage_ind:get_color() }
                local r,g,b,a = unpack(color_table)
                for tick, data in pairs(hitmarker_xd) do
                    if globals.curtime() <= data[4] then
                        local x1, y1 = renderer.world_to_screen(data[1], data[2], data[3])
                        if x1 ~= nil and y1 ~= nil then

                        data[6] = data[6] + 1
                        if data[6] > data[5] then data[6] = data[5] end
                        if data[6] > 100 then data[6] = 100 end
                        
                        if contains(_ui.visuals.dmg_ind_mode.value, "position") then
                            data[7] = lerp(data[7], y1 - 130, globals.frametime() * 0.03)
                        end
                        if contains(_ui.visuals.dmg_ind_mode.value, "transparency") then
                            data[8] = lerp(data[8], 0, globals.frametime() * 0.4)
                        end
                        renderer.text(x1, y1 - data[7], r, g, b, data[8], 'cb', 0, data[6])
                        end
                    end
                end
            end
        end
    }

    ctx.clantag = {
        run = function()
            local cur = math.floor(globals.tickcount() / 30) % #clantags
            local clantag = clantags[cur+1]
        
            if clantag ~= clantag_prev then
                clantag_prev = clantag
                if _ui.misc.clantag_h.value then
                    client.set_clan_tag(clantag)
                else
                    client.set_clan_tag("")
                end
            end
        end
    }

    ctx.fast_lad = {
        run = function(e)
            if _ui.misc.fast_ladder.value then
                local local_player = entity.get_local_player()
                local pitch, yaw = client.camera_angles()
                if entity.get_prop(local_player, "m_MoveType") == 9 then
                    e.yaw = math.floor(e.yaw + 0.5)
                    e.roll = 0
                    if e.forwardmove == 0 then
                        e.pitch = 89
                        e.yaw = e.yaw + 180
                        if math.abs(180) > 0 and math.abs(180) < 180 and e.sidemove ~= 0 then
                            e.yaw = e.yaw - ui.get(180)
                        end
                        if math.abs(180) == 180 then
                            if e.sidemove < 0 then
                                e.in_moveleft = 0
                                e.in_moveright = 1
                            end
                            if e.sidemove > 0 then
                                e.in_moveleft = 1
                                e.in_moveright = 0
                            end
                        end
                    end
            
                    if e.forwardmove > 0 then
                        if pitch < 45 then
                            e.pitch = 89
                            e.in_moveright = 1
                            e.in_moveleft = 0
                            e.in_forward = 0
                            e.in_back = 1
                            if e.sidemove == 0 then
                                e.yaw = e.yaw + 90
                            end
                            if e.sidemove < 0 then
                                e.yaw = e.yaw + 150
                            end
                            if e.sidemove > 0 then
                                e.yaw = e.yaw + 30
                            end
                        end 
                    end
                    if e.forwardmove < 0 then
                        e.pitch = 89
                        e.in_moveleft = 1
                        e.in_moveright = 0
                        e.in_forward = 1
                        e.in_back = 0
                        if e.sidemove == 0 then
                            e.yaw = e.yaw + 90
                        end
                        if e.sidemove > 0 then
                            e.yaw = e.yaw + 150
                        end
                        if e.sidemove < 0 then
                            e.yaw = e.yaw + 30
                        end
                    end
                end
            end
        end
    }

    ctx.defensive_ind = {
        paint = function()
            local color_table = { _ui.visuals.defensive_ind:get_color() }
            local r,g,b,a = unpack(color_table)
        
            if to_draw_ticks > 0 and to_draw_ticks < 20 then
                lerp_alpha = 255
            end
        
            if to_draw == "yes" and ui.get(references.double_tap[2]) and _ui.visuals.defensive_ind.value == true then
        
                draw_art = to_draw_ticks * 98 / 175
        
                if _ui.visuals.style.value == "Default" then
                    renderer.rectangle(X / 2 - 50, Y / 2  * 0.5,100,4,12,12,12,lerp_alpha)
                    renderer.rectangle(X / 2 - 49, Y / 2  * 0.5 + 1,draw_art,2,r,g,b,lerp_alpha)
                    renderer.text(X / 2 , Y / 2  * 0.5 - 10 ,255,255,255,lerp_alpha,"c",0,"- defensive -")
                end

                if _ui.visuals.style.value == "Modern" then
                    renderer.text(X / 2 , Y / 2  * 0.5 - 10 , 255, 255, 255, 255, "c", 0, string.format("\aFFFFFFFFdefensive \a%schoking", rgba_to_hex(r, g, b, 255)))
                    --renderer.rectangle(X / 2 - 50, Y / 2  * 0.5 + 0.3,100,4,50,50,50,255)
                    ctx.m_render:glow_module(X / 2 - 50, Y / 2  * 0.5,100,3, 14,2,{r,g,b,50}, {30,30,30,255})
                    renderer.rectangle(X / 2, Y / 2  * 0.5 +1,draw_art / 2,2,r,g,b,255)
                    renderer.rectangle(X / 2, Y / 2  * 0.5 + 1,-draw_art / 2,2,r,g,b,255)
                end

                if to_draw_ticks > 175 then
                    to_draw_ticks = 0
                    to_draw = "no"
                    lerp_alpha = lerp(lerp_alpha,0, globals.frametime() * 30)
                end
                if to_draw_ticksh == 20 then
                    to_draw_ticksh = 0
                    to_up = "no"
                end
                to_draw_ticksh = to_draw_ticksh + 1
                to_draw_ticks = to_draw_ticks + 1
            end
        end
    }

    ctx.slowed_down = {
        paint = function()
            local slowed_down_value = entity.get_prop(entity.get_local_player(),"m_flVelocityModifier") * 100
            local color_table = { _ui.visuals.slowed_down:get_color() }
            local r,g,b,a = unpack(color_table)
            local is_defensive = to_draw == "yes" and ui.get(references.double_tap[2])
            local is_dt = ui.get(references.double_tap[2])
            local scoped = entity.get_prop(entity.get_local_player(),"m_bIsScoped") == 1 and true or false
            local nextAttack = entity.get_prop(entity.get_local_player(), "m_flNextAttack")
            local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_flNextPrimaryAttack")
            local dtActive = false
        
            if nextPrimaryAttack ~= nil then
                dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
            end
        
            if slowed_down_value < 100 and _ui.visuals.slowed_down.value == true then
                local size_bar = slowed_down_value * 98 / 100
                -- text
                if _ui.visuals.style.value == "Default" then
                    renderer.text(X / 2 , is_defensive and Y / 2 * 0.55 - 10 or Y / 2  * 0.5 - 10 ,255,255,255,255,"c",0,"- slowed down -")
                    renderer.rectangle(X / 2 - 50, is_defensive and Y / 2 * 0.55 or Y / 2 * 0.5,100,3,12,12,12,255)
                    renderer.rectangle(X / 2 - 50, is_defensive and Y /2 * 0.55 or Y / 2 * 0.5, size_bar, 2,r, g, b, 255)
                end

                if _ui.visuals.style.value == "Modern" then
                    renderer.text(X / 2 , is_defensive and Y / 2 * 0.55 - 10 or Y / 2  * 0.5 - 10 , 255, 255, 255, 255, "c", 0, string.format("\aFFFFFFFFslowed down \aFFFFFFFF(\a%s%s%%\aFFFFFFFF)", rgba_to_hex(r, g, b, 255), math.floor(ctx.math.calculatePercentage(size_bar, 100))))
                    --renderer.rectangle(X / 2 - 50, Y / 2  * 0.5 + 0.3,100,4,50,50,50,255)
                    ctx.m_render:glow_module(X / 2 - 50, is_defensive and Y / 2 * 0.55 or Y / 2 * 0.5,100,3, 14,2,{r,g,b,50}, {30,30,30,255})
                    renderer.rectangle(X / 2, is_defensive and Y / 2 * 0.55 + 1 or Y / 2 * 0.5 + 1,size_bar / 2,2,r,g,b,255)
                    renderer.rectangle(X / 2, is_defensive and Y / 2 * 0.55 + 1 or Y / 2 * 0.5 + 1,-size_bar / 2,2,r,g,b,255)
                end
            end
        end
    }

    return ctx
end)()

function notify_render() 
    for i, info_noti in ipairs(notify_lol) do
        if i > 7 then
            table.remove(notify_lol, i)
        end
        if info_noti.text ~= nil and info_noti.text ~= "" then
            local color = info_noti.color
            if info_noti.timer + 3.7 < globals.realtime() then
                info_noti.y = lerp(info_noti.y, Y + 150, globals.frametime() * 1.5)
                info_noti.alpha = lerp(info_noti.alpha, 0, globals.frametime() * 4.5)
                --print("chuj") znikanie
            else
                --pojawianie
                info_noti.y = lerp(info_noti.y, Y - 100, globals.frametime() * 1.5)
                info_noti.alpha = lerp(info_noti.alpha, 255, globals.frametime() * 4.5)
            end
        end

        local width = vector(renderer.measure_text("c", info_noti.text))
        local r,g,b,a = ui.get(_ui.visuals.color_style)

        if _ui.visuals.style.value == "Default" then
            renderer.rectangle(X /2 - width.x /2 - 10, info_noti.y - i*35 - 48 ,width.x + 20, width.y + 16,12,12,12,info_noti.alpha)
            renderer.rectangle(X /2 - width.x /2 - 9, info_noti.y - i*35 - 47 ,width.x + 18, width.y + 14,60,60,60,info_noti.alpha)
            renderer.rectangle(X /2 - width.x /2 - 8, info_noti.y - i*35 - 46 ,width.x + 16, width.y + 12,40,40,40,info_noti.alpha)
            renderer.rectangle(X /2 - width.x /2 - 5, info_noti.y - i*35 - 43 ,width.x + 10, width.y + 6,60,60,60,info_noti.alpha)
            renderer.rectangle(X /2 - width.x /2 - 4, info_noti.y - i*35 - 42 ,width.x + 8, width.y + 4,12,12,12,info_noti.alpha)
            renderer.gradient(X /2 - width.x /2 - 4,info_noti.y - i*35 - 42, width.x /2, 1, 59, 175, 222, info_noti.alpha, 202, 70, 205, info_noti.alpha,true)               
            renderer.gradient(X /2 - width.x /2 - 4 + width.x /2 ,info_noti.y - i*35 - 42, width.x /2 + 8, 1,202, 70, 205, info_noti.alpha,204, 227, 53, info_noti.alpha,true)
            renderer.text(X / 2 - width.x /2, info_noti.y - i*35 - 40, 255,255,255,230, "", nil, info_noti.text)
        end

        if _ui.visuals.style.value == "Modern" then
            ctx.m_render:glow_module(X /2 - width.x /2 - 10, info_noti.y - i*35 - 48 ,width.x + 20, width.y + 8, _ui.visuals.style_width.value, _ui.visuals.style_round.value, {r,g,b,info_noti.alpha - 165}, {13,13,13,info_noti.alpha})
            renderer.text(X / 2 - width.x /2, info_noti.y - i*35 - 45, 255,255,255,info_noti.alpha, "", nil, info_noti.text)
        end

        if info_noti.timer + 4.3 < globals.realtime() then
            table.remove(notify_lol,i)
        end
    end
end

function new_notify(string, r, g, b, a)
    local notification = {
        text = string,
        timer = globals.realtime(),
        color = { r, g, b, a },
        alpha = 0
    }

    if #notify_lol == 0 then
        notification.y = Y + 20
    else
        local lastNotification = notify_lol[#notify_lol]
        notification.y = lastNotification.y + 20 
    end

    table.insert(notify_lol, notification)
end

new_notify("Security provided by best coders, cracked by Administrator (cbzcpolska) x Klockowo", 255,255,255,255)

-- local y = 0
-- local alpha = 255
-- client.set_event_callback('paint_ui', function()
--     local screen = vector(client.screen_size())
--     local size = vector(screen.x, screen.y)

--     local sizing = lerp(0.1, 0.9, math.sin(globals.realtime() * 0.9) * 0.5 + 0.5)
--     local rotation = lerp(0, 360, globals.realtime() % 1)
--     alpha = lerp(alpha, 0, globals.frametime() * 0.5)
--     y = lerp(y, 20, globals.frametime() * 2)

--     renderer.rectangle(0, 0, size.x, size.y, 13, 13, 13, alpha)
--     renderer.circle_outline(screen.x/2, screen.y/2, 235, 64, 52, alpha, 20, rotation, sizing, 3)
--     renderer.text(screen.x/2, screen.y/2 + 40, 235, 64, 52, alpha, 'c', 0, 'Initilizing')
--     renderer.text(screen.x/2, screen.y/2 + 60, 235, 64, 52, alpha, 'c', 0, 'Welcome - '.. username)
-- end)



client.set_event_callback("setup_command", function(e)
    ctx.fast_lad.run(e)
end)

client.set_event_callback("pre_render", function()
    ctx.anims:run()
end)

client.set_event_callback("paint", function()    

  -- text_fade_animation(w - 90,h / 2,5,{r=255,g=255,b=255,a=255},{r=195,g=198,b=255,a=255},string.upper("tabsense [V2 "..build.. "]"))

   -- print(_ui.misc.watermark:get_color())
   --render_ogskeet_border(400, 400, 200, 13, 255, "guwno")
   ctx.watermark:render()
   ctx.indicators:render()
   ctx.min_dmg_ind:render()
   ctx.damage_ind_guwno:render()
   ctx.defensive_ind:paint()
   ctx.slowed_down:paint()
  -- ctx.dt_green_defensive:render()
   notify_render()

   -- end
end)

client.set_event_callback("net_update_end", function()
    ctx.clantag:run()
end)