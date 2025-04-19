-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local ui_new_combobox,ui_new_checkbox,ui_new_multiselect,ui_new_label,ui_new_color_picker,ui_reference,ui_get,ui_set,ui_set_visible,entity_get_prop,client_set_event_callback,renderer_text,renderer_rectangle,ui_menu_size,ui_menu_position,ui_mouse_position,
renderer_gradient,renderer_measure_text,renderer_texture,ui_new_slider,ui_new_hotkey,entity_get_classname,entity_get_origin,globals_tickcount,entity_get_local_player =  
ui.new_combobox,ui.new_checkbox,ui.new_multiselect,ui.new_label,ui.new_color_picker,ui.reference,ui.get,ui.set,ui.set_visible,entity.get_prop,client.set_event_callback,renderer.text,renderer.rectangle,ui.menu_size,ui.menu_position,
ui.mouse_position,renderer.gradient,renderer.measure_text,renderer.texture,ui.new_slider,ui.new_hotkey,entity.get_classname,entity.get_origin,globals.tickcount,entity.get_local_player





local anti_aim_funcs = require ("gamesense/antiaim_funcs") or error("Failed to retrieve antiaim_funcs | https://gamesense.pub/forums/viewtopic.php?id=29665")
local ent_lib = require "gamesense/entity" or error("Failed to load entity | https://gamesense.pub/forums/viewtopic.php?id=27529")
local clipboard = require("gamesense/clipboard") or error("Failed to load clipboard | https://gamesense.pub/forums/viewtopic.php?id=28678")
local base64 = require("gamesense/base64") or error("Failed to load base64 | https://gamesense.pub/forums/viewtopic.php?id=21619")
local trace = require "gamesense/trace" or error("Failed to load trace")
local engineclient = require "gamesense/engineclient"
local obex_data = obex_fetch and obex_fetch() or {username = 'preto', build = 'Live', discord=''}
local vector = require "vector"
local ffi = require "ffi"

local tab,container = "AA","Anti-aimbot angles"


local menu = {
    ["anti-aim"] = {
        anti_aim_states = {"Global","Manual","Standing","Moving","Ducking","Duck moving","Slow walking","Jumping","Duck jumping","Legit","Fakelag","Height advantage"},
        anti_aim_selector = ui_new_combobox(tab, container, "Anti-aim type selector", {"Skeet","Venus"}),
        state_selector = ui_new_combobox(tab, container, "Anti-aim state", {"Global","Manual","Standing","Moving","Ducking","Duck moving","Slow walking","Jumping","Duck jumping","Legit","Fakelag","Height advantage"}),
        anti_backstab=ui_new_checkbox(tab, container, "Anti backstab"),
        safe_anti_aim=ui_new_checkbox(tab, container, "Safe Zeus / Knife"),
        disable_on_quickpeek=ui_new_checkbox(tab, container, "Disable defensive on quickpeek"),
        freestanding_disablers=ui_new_multiselect(tab, container,"Freestaning disablers",{"Global","Manual","Standing","Moving","Ducking","Duck moving","Slow walking","Jumping","Duck jumping","Fakelag"}),
        builder = {},
    },

    ["visuals"] = {
        indicator=ui_new_combobox(tab, container, "Indicators",{"Disabled","Default","Simple"}),
        indicator_color=ui_new_color_picker(tab, container, "Indicator", 150,230,49,255),
        indicator_scoped_animation=ui_new_checkbox(tab, container, "Scoped indicator animation"),
        defensive_indicator=ui_new_checkbox(tab, container, "Defensive indicator"),
        defensive_indicator_color=ui_new_color_picker(tab, container, "Defensive indicator color", 255,255,255,255),
        desync_indicator=ui_new_checkbox(tab, container, "Desync indicator"),
        desync_indicator_color=ui_new_color_picker(tab, container, "Desync indicator color", 255,255,255,255),
        slow_down_indicator=ui_new_checkbox(tab, container, "Slow down indicator"),
        slow_down_indicator_color=ui_new_color_picker(tab, container, "slow down indicator color", 255,255,255,255),
        turtle_slow=ui_new_checkbox(tab, container, "Turtle pet"),
        minimum_damage_indicator=ui_new_checkbox(tab, container, "Minimum damage indicator"),
        manual_anti_aim_indicators=ui_new_checkbox(tab, container, "Manual anti-aim indicator"),
        manual_anti_aim_indicators_color=ui_new_color_picker(tab, container, "Manual anti-aim indicator color", 255,50,50,255),
        ot_watermark=ui_new_checkbox(tab, container, "Watermark"),
        spectator_ot=ui_new_checkbox(tab, container, "Spectator list"),
        player_esp=ui_new_multiselect(tab, container, "Player esp",{"Zeus esp","At target flag"} ),
        target_label=ui_new_label(tab, container, "At target flag"),
        target_color=ui_new_color_picker(tab, container, "At target color", 255,50,50,255),
        zeus_esp=ui_new_multiselect(tab, container, "Zeus ESP",{"Flag","Indicator","Out of view"} ),
        zeus_indicator_color=ui_new_color_picker(tab, container, "zeus endicator", 150,230,49,255),
    },

    ["misc"] = {
        fps_boost = ui_new_checkbox(tab,container,"FPS Mitigations"),
        resolver=ui_new_checkbox(tab, container, "\af59042ffExperimental\affffffff Resolver"),
        safe_point=ui_new_multiselect(tab, container, "Safe point enhancer",{"Lethal","Default","Standing","Small jitter" ,"Wide jitter"} ),
        show_keybinds=ui_new_checkbox(tab, container, "Show keybinds"),
        manual_r=ui_new_hotkey(tab, container, "Manual right"),
        manual_l=ui_new_hotkey(tab, container, "Manual left"),
        manual_f=ui_new_hotkey(tab, container, "Manual forward"),
        manual_b=ui_new_hotkey(tab, container, "Manual reset"),
        freestanding=ui_new_hotkey(tab, container, "Freestanding"),
        sunset_mode=ui_new_checkbox(tab, container, "Night mode"),
        aim_logs=ui_new_checkbox(tab, container, "Aim logs"),
        aim_logs_hit_label=ui_new_label(tab, container, "Hit color"),
        aim_logs_hit_color=ui_new_color_picker(tab, container, "Hitez color",150,230,49,255),
        aim_logs_miss_label=ui_new_label(tab, container, "Miss logs"),
        aim_logs_miss_color=ui_new_color_picker(tab, container, "Missez color",255,255,255,255),
        print_logs=ui_new_checkbox(tab, container, "Console aim logs"),
        old_logs=ui_new_multiselect(tab, container, "Old logs", {"aim_hit","aim_miss","item_purchase"}),
        kill_say=ui_new_combobox(tab, container, "Kill say", {"Off","Main","Artists"}),
        local_animations=ui_new_multiselect(tab, container, "Anims",{"Static legs in air","Jitter legs","Crossing legs","Pitch 0 on land","Flashed","Victim"} ),
    },
}


local functions = {
    ["anti-aim"] = {
        anti_aim_state = "Standing",
        sim_time=0,
        sim_tick=nil,
        last_press = 0,
        mode = "reset",
        closest_player=0,
        side=nil,
        body=nil,
        jitter=1,
        skitter={-0.5,0.25,0.75},
        five_way ={-0.5,-0.25,0.1,0.5,1},
        actual_weapon=nil,
        old_weapon=nil,
        defensive_wait_ticks=0,
        bomb_was_defused=false,
        bomb_was_bombed=false,
    },
    
    ["visuals"] = {
        is_defensive=false,
        defensive_tick=0,
        forced_defensive=false,
    },

    ["misc"] = {
        
        end_time = 0,
        ground_ticks = 0,
        old_sun = {0,0,0},
        sunset_active = false,
        kill_say = {["Main"]={"1","Venus lua on top.", "Invite buyer down!!1!","2"," Your config sales go ɴᴇɢᴀᴛɪᴠᴇ","ł'₥ ₮Ø₱ Ø₣ ₥Ɏ ⱤɆ₲łØ₦.","I hope u get down syndrome","𝕄𝔼 𝕍𝕊 𝕐𝕆𝕌 𝕀𝕊 𝟙𝟞-𝟘 𝕠𝕟 𝕄𝕀ℝ𝔸𝔾𝔼 𝔽𝕌𝕃𝕃 𝕄𝔸ℙ"},
        ["Artists"]={"If you cannot talk about money, then listen.","Fuck on your bitch, make that ho wanna Milly Rock","Bitches stupid, she think I'ma eat her"}}
    },

    ["menu"] = {},

    ["lua"] = {},
}

for k,v in ipairs(menu["anti-aim"].anti_aim_states) do 
    menu["anti-aim"].builder[v] = {}
    menu["anti-aim"].builder[v].enable = ui_new_checkbox(tab, container, "Enable - " .. v)
    menu["anti-aim"].builder[v].pitch = ui_new_combobox(tab, container, "Pitch" .. "\n" .. v, {"Off","Down","Minimal","Custom"})
    menu["anti-aim"].builder[v].pitch_custom = ui_new_slider(tab, container, "Custom".. "\n" .. v, -89, 89, 0, true, "º")
    menu["anti-aim"].builder[v].yaw_base = ui_new_combobox(tab, container, "Yaw base".. "\n" .. v, {"Local view","At targets"})

    if v ~= "Manual" then 
        menu["anti-aim"].builder[v].yaw=ui_new_combobox(tab, container, "Yaw".. "\n" .. v, {"Off","180","Static","180 Z","Slow jitter","L&R","Slow 5-way"})
        menu["anti-aim"].builder[v].random_flick=ui_new_checkbox(tab, container, "Random flick\n" .. v)
        menu["anti-aim"].builder[v].delay_custom = ui_new_slider(tab, container, "Delayº\n" .. v, 1, 20, 0, true, "t")
        menu["anti-aim"].builder[v].yaw_custom2=ui_new_slider(tab, container, "Yaw left\n".. v, -180, 180, 0, true, "º")
    end
    menu["anti-aim"].builder[v].yaw_custom = ui_new_slider(tab, container, "Yaw\n nigga" .. v, -180, 180, 0, true, "º")
    menu["anti-aim"].builder[v].yaw_jitter = ui_new_combobox(tab, container, "Yaw jitter".. "\n" .. v, {"Off","Offset","Center","Random","Skitter"})
    menu["anti-aim"].builder[v].yaw_jitter_custom = ui_new_slider(tab, container, "\n jitter" .. v, -180, 180, 0, true, "º")
    menu["anti-aim"].builder[v].body_yaw = ui_new_combobox(tab, container, "Body yaw".. "\n" .. v, {"Off","Opposite","Jitter","Static","Optimized slow","Optimized jitter"})
    menu["anti-aim"].builder[v].body_yaw_custom = ui_new_slider(tab, container, "\n custom" .. v, -180, 180, 0, true, "º")

    menu["anti-aim"].builder[v].defensive_enable = ui_new_checkbox(tab, container, "Enable \a96e631ffdefensive \n" .. v)
    menu["anti-aim"].builder[v].defensive_tick_stopper = ui_new_slider(tab, container, "Ticks".. "\n defensive" .. v, 2, 20, 0, true, "º")
    menu["anti-aim"].builder[v].defensive_choke = ui_new_checkbox(tab, container, "Choke \a96e631ffdefensive \n" .. v)
    menu["anti-aim"].builder[v].defensive_force = ui_new_checkbox(tab, container, "Force \a96e631ffdefensive \n" .. v)
    menu["anti-aim"].builder[v].defensive_pitch = ui_new_combobox(tab, container, "Pitch" .. "\n defensive" .. v, {"Off","Down","Minimal","Random","Custom","Lerp"})
    menu["anti-aim"].builder[v].defensive_pitch_custom = ui_new_slider(tab, container, "Custom".. "\n defensive" .. v, -89, 89, 0, true, "º")
    menu["anti-aim"].builder[v].defensive_yaw=ui_new_combobox(tab, container, "Yaw".. "\n defensive" .. v, {"Off","180","Spin","Jitter","Skitter","Random","Sideways"})
    menu["anti-aim"].builder[v].defensive_yaw_custom=ui_new_slider(tab, container, "\n defensive custom" .. v, -180, 180, 0, true, "º")
end

local Venus_aa = {}
for k,v in ipairs(menu["anti-aim"].anti_aim_states) do 
    Venus_aa[v] = {}
    Venus_aa[v].enable = ui_new_checkbox(tab, container, "Enable - " .. v .. "\n custom")
    Venus_aa[v].pitch = ui_new_combobox(tab, container, "Pitch" .. "\n" .. v .. "\n custom", {"Off","Down","Minimal","Up","Random"})    
    Venus_aa[v].yaw=ui_new_combobox(tab, container, "Yaw".. "\n" .. v .. "\n custom", {"Off","180"})
     
    Venus_aa[v].yaw_custom = ui_new_slider(tab, container, "Yaw\n nigga" .. v .. "\n custom", -180, 180, 0, true, "º")
    Venus_aa[v].yaw_jitter = ui_new_combobox(tab, container, "Yaw jitter".. "\n" .. v .. "\n custom", {"Off","Center"})
    Venus_aa[v].yaw_jitter_custom = ui_new_slider(tab, container, "\n jitter" .. v .. "\n custom", -180, 180, 0, true, "º")
    Venus_aa[v].body_yaw = ui_new_combobox(tab, container, "Body yaw".. "\n" .. v .. "\n custom", {"Off","Static","Jitter"})
    Venus_aa[v].body_yaw_custom = ui_new_slider(tab, container, "\n custom" .. v .. "\n custom", -180, 180, 0, true, "º")
end
    
local menu_reference = {
    enabled = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = { ui_reference("AA", "Anti-aimbot angles", "pitch") },
    roll = ui_reference("AA", "Anti-aimbot angles", "roll"),
    yawbase = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {ui_reference("AA", "Anti-aimbot angles", "Yaw")},
    fsbodyyaw = ui_reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    dtholdaim = ui_reference("misc", "settings", "sv_maxusrcmdprocessticks_holdaim"),
    fakeduck = ui_reference("RAGE", "Other", "Duck peek assist"),
    minimum_damage = ui_reference("RAGE", "Aimbot", "Minimum damage"),
    safepoint = ui_reference("RAGE", "Aimbot", "Force safe point"),
    forcebaim = ui_reference("RAGE", "Aimbot", "Force body aim"),
    player_list = ui_reference("PLAYERS", "Players", "Player list"),
    reset_all = ui_reference("PLAYERS", "Players", "Reset all"),
    apply_all = ui_reference("PLAYERS", "Adjustments", "Apply to all"),
    load_cfg = ui_reference("Config", "Presets", "Load"),
    fl_limit = ui_reference("AA", "Fake lag", "Limit"),
    dt_limit = ui_reference("RAGE", "Aimbot", "Double tap fake lag limit"),
    quickpeek = {ui_reference("RAGE", "Other", "Quick peek assist")},
    yawjitter = {ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    bodyyaw = {ui_reference("AA", "Anti-aimbot angles", "Body yaw")},
    freestand = {ui_reference("AA", "Anti-aimbot angles", "Freestanding")},
    freestand_body = {ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw")},
    os = {ui_reference("AA", "Other", "On shot anti-aim")},
    slow = {ui_reference("AA", "Other", "Slow motion")},
    dt = {ui_reference("RAGE", "Aimbot", "Double tap")},
    fakelag = {ui_reference("AA", "Fake lag", "Limit")},
    fakelag_variance = ui_reference("AA", "Fake lag", "Variance"),
    fake_lag_amount = ui_reference("AA", "Fake lag", "Amount"),
    leg_movement = ui_reference("AA", "Other", "Leg movement"),
    ammo = ui_reference("VISUALS","Player ESP","Ammo"),
    weapon_text = ui_reference("VISUALS","Player ESP","Weapon text"),
    weapon_icon = ui_reference("VISUALS","Player ESP","Weapon icon"),
    ping = { ui_reference("MISC","Miscellaneous","Ping spike") },
    clan_tag_spammer = ui_reference("MISC","Miscellaneous","Clan tag spammer"),
    min_dmg_override = { ui_reference("RAGE","Aimbot","Minimum damage override") },
    menu_key = { ui_reference("MISC","Settings","Menu key") },
    dpi_scale = ui_reference("MISC","Settings","DPI scale")
}


local ui_menu = {
    tabs_names = {"Anti-aim","Extras","Visuals","Misc","Config"},
    selected_tab = "Anti-aim",
    easier_tab = {aa="Anti-aim",aa2="Extras",visuals="Visuals",misc="Misc",config="Config"},
    selected_color = { {20, 20, 20, 255}, {210,210,210,255} },
    selected_col = "88A6F391",
    selected_tab_press=false,
    menu_alpha = 255,
    is_hovered = false,
    dpi_scaling_y = {{84,149},{100,181},{116,213},{132,245},{148,276}},
    pesadelo_na_cozinha2 = {597,741,885,1030,1173 },
    selected_gs_tab = false,
    mouse_press = false,
    old_mpos = {0,0}
}

local rectangle_outline = function(x,y,w,h,thickness,r,g,b,a)

    -- left vertical
    renderer_rectangle(x,y+2,thickness,h-2,r,g,b,a) 
    -- right vertical
    renderer_rectangle(x+w,y+2,thickness,h-2,r,g,b,a) 
    -- bottom horizontal
    renderer_rectangle(x,y+h,w+thickness,thickness,r,g,b,a) 
    -- top horizontal
    renderer_rectangle(x,y,w+thickness,thickness,r,g,b,a) 

end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function table_contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end



ui_menu.is_aa_tab = function()
    local menu_size = { ui_menu_size() }
  
    
    local menu_pos = { ui_menu_position() }
    local mouse_pos = { ui_mouse_position() }

   local scale = {0,0}
   local scale_x = 0
   local pesadelo_no_direito = 0

    

    if ui_get(menu_reference.dpi_scale) == "100%" then
        scale = { ui_menu.dpi_scaling_y[1][1],ui_menu.dpi_scaling_y[1][2] }
        scale_x = 76
        pesadelo_no_direito = ui_menu.pesadelo_na_cozinha2[1]
    elseif ui_get(menu_reference.dpi_scale)  == "125%" then
        scale = { ui_menu.dpi_scaling_y[2][1],ui_menu.dpi_scaling_y[2][2] }
        scale_x = 95
        pesadelo_no_direito = ui_menu.pesadelo_na_cozinha2[2]
    elseif ui_get(menu_reference.dpi_scale)  == "150%" then
        scale = { ui_menu.dpi_scaling_y[3][1],ui_menu.dpi_scaling_y[3][2] }
        scale_x = 113
        pesadelo_no_direito = ui_menu.pesadelo_na_cozinha2[3]
    elseif ui_get(menu_reference.dpi_scale)  == "175%" then
        scale = { ui_menu.dpi_scaling_y[4][1],ui_menu.dpi_scaling_y[4][2] }
        scale_x = 132
        pesadelo_no_direito = ui_menu.pesadelo_na_cozinha2[4]
    elseif ui_get(menu_reference.dpi_scale)  == "200%" then
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

ui_menu.new_tab = function()

    ui_menu.is_hovered = false
    if not ui.is_menu_open()  then
        ui_menu.menu_alpha = lerp(ui_menu.menu_alpha,0,globals.frametime() * 50)
    else
        ui_menu.menu_alpha = lerp(ui_menu.menu_alpha,255,globals.frametime() * 20)
    end

    if ui_menu.menu_alpha < 50 then return end

    local menu_size = { ui_menu_size() }
    local divide_menu = (menu_size[1] - 12) / #ui_menu.tabs_names
    
    local menu_pos = { ui_menu_position() }
    local mouse_pos = { ui_mouse_position() }

    if not ui_menu.selected_gs_tab then return end
    
    for k,v in ipairs(ui_menu.tabs_names) do

        ui_menu.selected_color[1] = {12, 12, 12}
        ui_menu.selected_color[2] = {90, 90, 90}
        if ui_menu.selected_tab == v then
            ui_menu.selected_color[1] = {20, 20, 20}
            ui_menu.selected_color[2] = {210, 210, 210}
            --ui_menu.selected_col = "\aD2D2D2FF"
            --ui_menu.selected_col = "\a4E4E4E97"
        end
       
       
        renderer_rectangle(menu_pos[1] + 6 , menu_pos[2] - 47,menu_size[1] - 6,2, ui_menu.selected_color[1][1], ui_menu.selected_color[1][2], ui_menu.selected_color[1][3], math.ceil(ui_menu.menu_alpha))
        renderer_rectangle(menu_pos[1] + 6 + (divide_menu * k) - divide_menu, menu_pos[2] - 45,divide_menu + 1,45 , ui_menu.selected_color[1][1], ui_menu.selected_color[1][2], ui_menu.selected_color[1][3], math.ceil(ui_menu.menu_alpha))

       
        renderer_text(menu_pos[1] + (divide_menu * k) - divide_menu / 2 + 5 ,menu_pos[2] - 22,ui_menu.selected_color[2][1], ui_menu.selected_color[2][2], ui_menu.selected_color[2][3],math.ceil(ui_menu.menu_alpha),"cd+",0, v)
        
    

        if mouse_pos[1] > menu_pos[1] + (divide_menu * k) -  divide_menu and mouse_pos[1] < menu_pos[1] + (divide_menu * k) and mouse_pos[2] > menu_pos[2] - 50 and mouse_pos[2] < menu_pos[2] then
            ui_menu.is_hovered = true
            if  client.key_state(0x1) and ui_menu.selected_tab_press == false then
                ui_menu.selected_tab = v
                ui_menu.selected_tab_press=true
            elseif not client.key_state(0x1) then
                ui_menu.selected_tab_press=false
            end
        end
    end
end

ui_menu.outside_bar = function()
    
    if not ui_menu.selected_gs_tab then return end

    if ui_menu.menu_alpha < 50 then return end

    local menu_size = { ui_menu_size() }
    local menu_pos = { ui_menu_position() }
 


    --top bar
    renderer_rectangle(menu_pos[1] ,menu_pos[2] - 53,menu_size[1] ,1 ,12,12,12,ui_menu.menu_alpha) -- black
    renderer_rectangle(menu_pos[1] + 2,menu_pos[2] - 52,menu_size[1] - 4,5 ,60,60,60,ui_menu.menu_alpha) -- outlines
    renderer_rectangle(menu_pos[1] + 2,menu_pos[2] - 51,menu_size[1] - 4,3 ,40,40,40,ui_menu.menu_alpha) -- inner

    --left bar
    renderer_rectangle(menu_pos[1] ,menu_pos[2] - 53,1,53 ,12,12,12,ui_menu.menu_alpha) -- black
    renderer_rectangle(menu_pos[1] + 1,menu_pos[2] - 52,4,52 ,60,60,60,ui_menu.menu_alpha) -- outlines
    renderer_rectangle(menu_pos[1] + 2,menu_pos[2] - 51,3,51 ,40,40,40,ui_menu.menu_alpha) -- inner
    renderer_rectangle(menu_pos[1] + 5,menu_pos[2] - 48,1,48 ,60,60,60,ui_menu.menu_alpha) -- outlines

    --right bar
    renderer_rectangle(menu_pos[1] + menu_size[1] - 1,menu_pos[2] - 53,1,53 ,12,12,12,ui_menu.menu_alpha) -- black
    renderer_rectangle(menu_pos[1] + menu_size[1] - 3,menu_pos[2] - 52,2,52 ,60,60,60,ui_menu.menu_alpha) -- outlines
    renderer_rectangle(menu_pos[1] + menu_size[1] - 5,menu_pos[2] - 51,3,51 ,40,40,40,ui_menu.menu_alpha) -- inner
    renderer_rectangle(menu_pos[1] + menu_size[1] - 6,menu_pos[2] - 48,1,48 ,60,60,60,ui_menu.menu_alpha) -- outlines

    renderer_gradient(menu_pos[1] + 7,menu_pos[2] - 46,
    menu_size[1]/2,1, 59, 175, 222, 255, 202, 70, 205, 255,true)
            
    renderer_gradient(menu_pos[1] + 7 + menu_size[1]/2 ,menu_pos[2] - 46,
    menu_size[1]/2 - 14, 1,202, 70, 205, 255,204, 227, 53, 255,true)
end

local prev_simulation_time = 0
functions["anti-aim"].sim_diff = function()
    local current_simulation_time = math.floor(0.5 + (entity_get_prop(entity_get_local_player(), "m_flSimulationTime") / globals.tickinterval())) 
    local diff = current_simulation_time - prev_simulation_time
    prev_simulation_time = current_simulation_time
    return diff
end

functions["anti-aim"].legit_aa = function(cmd)

    if not ui_get(menu["anti-aim"].builder["Legit"].enable) then return end

    local in_use = cmd.in_use == 1
    local in_bombsite = entity_get_prop(entity_get_local_player(), "m_bInBombZone") > 0
    local nTeam = entity_get_prop(entity_get_local_player(), "m_iTeamNum")
    lx,ly,lz = entity_get_origin(entity_get_local_player())


    local from = vector(client.eye_position())
	local to = from + vector():init_from_angles(client.camera_angles()) * 1024

    local tr = trace.line(from, to, { skip = entity_get_local_player(), mask = "MASK_SHOT" })

    local local_pos = vector(entity_get_origin(entity_get_local_player()))

    if tr.fraction >= 1 then
        tr.entindex = 0
    end
   
   if entity_get_classname(tr.entindex) ~= "CWorld" and entity_get_classname(tr.entindex) ~= "CCSPlayer" and entity_get_classname(tr.entindex) ~= "CFuncBrush" and entity_get_classname(tr.entindex) ~= "CBaseButton" and entity_get_classname(tr.entindex) ~= "CDynamicProp" and entity_get_classname(tr.entindex) ~= "CPhysicsPropMultiplayer" and entity_get_classname(tr.entindex) ~= "CBaseEntity" and entity_get_classname(tr.entindex) ~= "CC4" then 
      
        local not_wepwep = vector(entity_get_origin(tr.entindex))

        if entity_get_classname(tr.entindex) == "CPropDoorRotating" or (entity_get_classname(tr.entindex) == "CHostage" and nTeam == 3) then
            
            if local_pos:dist(not_wepwep) < 125 then

                return false
            end

        elseif entity_get_classname(tr.entindex) ~= "CPropDoorRotating" and entity_get_classname(tr.entindex) ~= "CHostage" then

            if local_pos:dist(not_wepwep) < 200 then
                return false
            end
        end
   end
  
    local bomb_table    = entity.get_all("CPlantedC4")
    local bomb_planted  = #bomb_table > 0
    local bomb_distance = 100

    if bomb_planted then
        local bomb_entity = bomb_table[#bomb_table]
        local bomb_pos = vector(entity_get_origin(bomb_entity))
        bomb_distance = local_pos:dist(bomb_pos)
    end

    local defusing = bomb_distance < 50 and nTeam == 3 and functions["anti-aim"].bomb_was_bombed == false and functions["anti-aim"].bomb_was_defused == false

    if defusing then return false end

    if in_use then
        cmd.in_use = 0
        return true
    end
    return false
end

functions["anti-aim"].manual_anti_aim_setup = function()

    if not ui_get(menu["anti-aim"].builder["Manual"].enable) or (not ui_get(menu["anti-aim"].anti_aim_selector) and not ui_get(menu["anti-aim"].enable)) then 
        return
    end


    if ui_get(menu["misc"].manual_r) and globals.curtime() > functions["anti-aim"].last_press + 0.2 then
        functions["anti-aim"].mode = functions["anti-aim"].mode == "right" and "reset" or "right"
        functions["anti-aim"].last_press = globals.curtime()
    elseif ui_get(menu["misc"].manual_l) and globals.curtime() > functions["anti-aim"].last_press + 0.2 then
        functions["anti-aim"].mode = functions["anti-aim"].mode == "left" and "reset" or "left"
        functions["anti-aim"].last_press = globals.curtime()
    elseif ui_get(menu["misc"].manual_f) and globals.curtime() > functions["anti-aim"].last_press + 0.2 then
        functions["anti-aim"].mode = functions["anti-aim"].mode == "forward" and "reset" or "forward"
        functions["anti-aim"].last_press = globals.curtime()
    elseif ui_get(menu["misc"].manual_b) and globals.curtime() > functions["anti-aim"].last_press + 0.2 then
        functions["anti-aim"].mode = "reset"
        functions["anti-aim"].last_press = globals.curtime()
    elseif functions["anti-aim"].last_press > globals.curtime() then 
        functions["anti-aim"].last_press = globals.curtime()
    end

 
    if functions["anti-aim"].mode ~= "reset" then
        ui_set(menu_reference.yaw[1],"180")
        if functions["anti-aim"].mode == "right" then
            ui_set(menu_reference.yaw[2],90)
        elseif functions["anti-aim"].mode == "left" then
            ui_set(menu_reference.yaw[2],-90)
        elseif  functions["anti-aim"].mode == "forward" then 
            ui_set(menu_reference.yaw[2],180)
        end
    end
end

functions["anti-aim"].safe_anti_aim = function(cmd)

    if not ui_get(menu["anti-aim"].safe_anti_aim) then 
        return 
    end

    if (entity_get_classname(entity.get_player_weapon(entity_get_local_player())) == "CKnife" or entity_get_classname(entity.get_player_weapon(entity_get_local_player())) == "CWeaponTaser") and ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].enable) then
        local on_ground = bit.band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) == 1 and cmd.in_jump == 0

        if not on_ground then
            ui_set(menu_reference.yaw[1],"180")
            ui_set(menu_reference.yaw[2],0)
            ui_set(menu_reference.yawjitter[2],0)
            ui_set(menu_reference.bodyyaw[1],"Static")
        end
    end
end


local extrapolate_pos = function(entindex, origin, ticks)
    local tick_interval = globals.tickinterval()

    local velocity = vector(entity_get_prop(entindex, "m_vecVelocity"))
    velocity.z = velocity.z - (cvar.sv_gravity:get_float() * tick_interval)

    return origin + velocity * ticks * tick_interval
end

functions["anti-aim"].anti_backstab = function(cmd)

    functions["anti-aim"].distance=999999
    for k,v in ipairs(entity.get_players(true)) do

        local local_origin = vector(entity_get_origin(entity_get_local_player()))
        local players_origin = extrapolate_pos(v,vector(entity_get_origin(v)),10)
        local closest_origin = vector(entity_get_origin(functions["anti-aim"].closest_player))

        --hi ori I don't even know what the fuck is going on :|
        if local_origin:dist2d(players_origin) <= functions["anti-aim"].distance  then
            functions["anti-aim"].closest_player = v
            functions["anti-aim"].distance = local_origin:dist2d(players_origin)
        elseif local_origin:dist2d(players_origin) <= local_origin:dist2d(closest_origin) then
            functions["anti-aim"].closest_player = v
            functions["anti-aim"].distance = local_origin:dist2d(players_origin)
        end

       if entity_get_classname(entity.get_player_weapon(functions["anti-aim"].closest_player)) == "CKnife" and local_origin:dist2d(vector(entity_get_origin(functions["anti-aim"].closest_player))) < 250 and ui_get(menu["anti-aim"].anti_backstab) then

            local eye_x, eye_y, eye_z = client.eye_position()
            local head_x, head_y, head_z = entity.hitbox_position(v, 4)
            local fraction, entindex_hit = client.trace_line(entity_get_local_player(), eye_x, eye_y, eye_z, head_x, head_y, head_z)

		
		    local wx, wy = renderer.world_to_screen(head_x, head_y, head_z)

			if entindex_hit == v or fraction == 1 then
                
                ui_set(menu_reference.yawbase,"At targets")
                ui_set(menu_reference.yaw[1],"180")
                ui_set(menu_reference.yaw[2],180)
                ui_set(menu_reference.yawjitter[1],"Off")
			end
       end

    end
end

functions["anti-aim"].defensive_jitter = false
functions["anti-aim"].defensive_spin_amout = 0
functions["anti-aim"].defensive_skitter = 1

local def_switched = false
local def_value = 0
functions["anti-aim"].defensive_setup = function(cmd) 

    -- :)

    if ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_enable) and ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].enable) and ui_get(menu_reference.dt[1]) and ui_get(menu_reference.dt[2]) then 

        if ui_get(menu["anti-aim"].disable_on_quickpeek) and ui_get(menu_reference.quickpeek[1]) and ui_get(menu_reference.quickpeek[2]) or ui_get(menu_reference.fakeduck) then
            return 
        end

        -- need to add defensive checks :(
            -- paste from starlight :)

            functions["anti-aim"].old_weapon = functions["anti-aim"].current_weapon
            functions["anti-aim"].current_weapon = entity.get_player_weapon(entity_get_local_player())

            if functions["anti-aim"].old_weapon ~= functions["anti-aim"].current_weapon then
                functions["anti-aim"].defensive_wait_ticks = globals_tickcount()
            end

            if globals_tickcount() < functions["anti-aim"].defensive_wait_ticks + 50  then
                return 
            end

        -- check for stuff like jitter ig
        if cmd.chokedcommands == 0 then
            functions["anti-aim"].defensive_jitter = not functions["anti-aim"].defensive_jitter
            functions["anti-aim"].defensive_skitter = client.random_int(1, 3)

            def_value = def_value + (def_switched and 8 or -8)

            if math.ceil(def_value) >= 89 then 
                def_switched = false
            elseif math.ceil(def_value) <= -89 then 
                def_switched = true
            end
        end

        cmd.force_defensive=ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_force)

        if functions["anti-aim"].sim_tick == nil then 
            return 
        end

        if  functions["anti-aim"].sim_tick + ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_tick_stopper) <= globals_tickcount() then 
            return
        end

        cmd.allow_send_packet = ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_choke)
       

        if ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_pitch) == "Lerp" then 
            ui_set(menu_reference.pitch[1],"Custom")
            ui_set(menu_reference.pitch[2],math.max(-89,math.min(89,def_value)))
        elseif ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_pitch) ~= "Off" then 
            ui_set(menu_reference.pitch[1],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_pitch))
            ui_set(menu_reference.pitch[2],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_pitch_custom))
        end

        if ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_yaw) ~= "Off" then
            if ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_yaw) == "Jitter" then
                ui_set(menu_reference.yaw[1],"180")
                ui_set(menu_reference.yaw[2],functions["anti-aim"].defensive_jitter and ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_yaw_custom)  or -ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_yaw_custom) )
                ui_set(menu_reference.bodyyaw[1],"Static")
                ui_set(menu_reference.bodyyaw[2],functions["anti-aim"].defensive_jitter and -115 or 115)
            elseif ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_yaw) == "Spin" then 

                functions["anti-aim"].defensive_spin_amout = functions["anti-aim"].defensive_spin_amout + ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_yaw_custom) 

                if functions["anti-aim"].defensive_spin_amout > 180 then 
                    functions["anti-aim"].defensive_spin_amout = -180
                elseif functions["anti-aim"].defensive_spin_amout < -180 then 
                    functions["anti-aim"].defensive_spin_amout = 180
                end

                ui_set(menu_reference.yaw[1],"180")
                ui_set(menu_reference.yaw[2],functions["anti-aim"].defensive_spin_amout)
                ui_set(menu_reference.bodyyaw[1],"Static")
                ui_set(menu_reference.bodyyaw[2],0)

            elseif ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_yaw) == "180" then  
                ui_set(menu_reference.yaw[1],"180")
                ui_set(menu_reference.yaw[2],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_yaw_custom))
            elseif ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_yaw) == "Skitter" then 
                ui_set(menu_reference.yawjitter[1],"Skitter")
                ui_set(menu_reference.yawjitter[2], ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_yaw_custom))
                ui_set(menu_reference.bodyyaw[1],"Jitter")
                ui_set(menu_reference.bodyyaw[2],1)
            elseif ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_yaw) == "Random" then 
                ui_set(menu_reference.yaw[1],"180")
                ui_set(menu_reference.yaw[2],client.random_int(-180, 180))
                ui_set(menu_reference.bodyyaw[1],"Static")
                ui_set(menu_reference.bodyyaw[2],1)
            elseif ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_yaw) == "Sideways" then 
                ui_set(menu_reference.yaw[1],"180")
                ui_set(menu_reference.yaw[2], 0)
                ui_set(menu_reference.yawjitter[1],"Center")
                ui_set(menu_reference.yawjitter[2], -50)
                ui_set(menu_reference.bodyyaw[1],"Jitter")
                ui_set(menu_reference.bodyyaw[2],1)
            end
        end
    end

    functions["visuals"].forced_defensive=(cmd.force_defensive and cmd.weaponselect == 0)
end

local opti_jitter = false
local random_flick = client.random_int(12, 64)
local current_slow_tick = 0
local old_state = "Standing"
local five_way_jitter_idx = 1
local five_way_current_tick = 0
functions["anti-aim"].anti_aim_setup = function(cmd)

    -- start by getting los states
    local ducking = cmd.in_duck == 1 or ui_get(menu_reference.fakeduck)
    local on_ground = bit.band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) == 1 and cmd.in_jump == 0
    local velocity = vector(entity_get_prop(entity_get_local_player(),"m_vecVelocity"))
    local slow_walk = ui_get(menu_reference.slow[1]) and ui_get(menu_reference.slow[2]) 
    local fake_lag = (not ui_get(menu_reference.dt[1]) or not ui_get(menu_reference.dt[2])) and (not ui_get(menu_reference.os[1]) or not ui_get(menu_reference.os[2]))
    local lp_origin = vector(entity_get_origin(entity_get_local_player()))
    local current_threat_origin = vector(entity_get_origin(client.current_threat() or entity_get_local_player()))
    old_state = functions["anti-aim"].anti_aim_state

    -- now we execute
    -- need to add legit aa
    if functions["anti-aim"].legit_aa(cmd) then 
        functions["anti-aim"].anti_aim_state = "Legit"
    elseif ui_get(menu["anti-aim"].builder["Manual"].enable) and functions["anti-aim"].mode ~= "reset" then 
        functions["anti-aim"].anti_aim_state = "Manual"
    elseif ui_get(menu["anti-aim"].builder["Height advantage"].enable) and lp_origin.z > current_threat_origin.z + 64 then
    functions["anti-aim"].anti_aim_state = "Height advantage"
    elseif fake_lag and ui_get(menu["anti-aim"].builder["Fakelag"].enable) then
        functions["anti-aim"].anti_aim_state = "Fakelag"
    elseif not on_ground and cmd.in_duck == 1 and ui_get(menu["anti-aim"].builder["Duck jumping"].enable) then 
        functions["anti-aim"].anti_aim_state = "Duck jumping"
    elseif not on_ground and ui_get(menu["anti-aim"].builder["Jumping"].enable) then
        functions["anti-aim"].anti_aim_state = "Jumping"
    elseif ducking and velocity:length2d() < 3 and ui_get(menu["anti-aim"].builder["Ducking"].enable) and on_ground then 
        functions["anti-aim"].anti_aim_state = "Ducking"
    elseif ducking and velocity:length2d() >= 3 and ui_get(menu["anti-aim"].builder["Duck moving"].enable) and on_ground then 
        functions["anti-aim"].anti_aim_state = "Duck moving"
    elseif slow_walk and ui_get(menu["anti-aim"].builder["Slow walking"].enable) then 
        functions["anti-aim"].anti_aim_state = "Slow walking"
    elseif velocity:length2d() >= 3 and ui_get(menu["anti-aim"].builder["Moving"].enable) and not slow_walk then 
        functions["anti-aim"].anti_aim_state = "Moving"
    elseif velocity:length2d() < 3 and ui_get(menu["anti-aim"].builder["Standing"].enable) and not slow_walk then 
        functions["anti-aim"].anti_aim_state = "Standing"
    else
        functions["anti-aim"].anti_aim_state = "Global"
    end

    -- chokes for anti aim
    local desync = math.floor(math.min(60, (entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * 120 - 60)))
    local side = desync >= 0 and true or false

    if cmd.chokedcommands == 0 then

        if functions["anti-aim"].anti_aim_state ~= "Manual" then
            if globals_tickcount() >= current_slow_tick + ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].delay_custom) then
                current_slow_tick = globals_tickcount()
                functions["anti-aim"].side = not functions["anti-aim"].side
            elseif globals_tickcount() + ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].delay_custom) < current_slow_tick then 
                current_slow_tick = globals_tickcount()
            end

            if globals_tickcount() % 1 == 0 then 
                opti_jitter = not opti_jitter
            end

           

                if globals_tickcount() >= five_way_current_tick + ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].delay_custom) then
                    five_way_current_tick = globals_tickcount()
                    five_way_jitter_idx = five_way_jitter_idx + 1
                elseif globals_tickcount() + ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].delay_custom) < five_way_current_tick then 
                    five_way_current_tick = globals_tickcount()
                end

                if five_way_jitter_idx > 5 then 
                    five_way_jitter_idx = 1
                end
           

            functions["anti-aim"].body = side 
        end

        functions["anti-aim"].jitter = client.random_int(1, 3)

    end


    ui_set(menu_reference.enabled,ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].enable))
    ui_set(menu_reference.pitch[1],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].pitch))
    ui_set(menu_reference.pitch[2],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].pitch_custom))
    ui_set(menu_reference.yawbase,ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_base))


    if functions["anti-aim"].anti_aim_state ~= "Manual" then

        if ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw) == "Slow jitter" then 
                ui_set(menu_reference.yaw[1],"180")
                ui_set(menu_reference.yaw[2], functions["anti-aim"].side == true and ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_custom) or ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_custom2))
        elseif ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw) == "L&R" then
            ui_set(menu_reference.yaw[1],"180")
            
            ui_set(menu_reference.yaw[2], functions["anti-aim"].body == false and ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_custom) or ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_custom2))
        elseif ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw) == "Slow 5-way" then 
            ui_set(menu_reference.yaw[1],"180")
            ui_set(menu_reference.yaw[2],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_custom) * functions["anti-aim"].five_way[five_way_jitter_idx])
          
        else
            ui_set(menu_reference.yaw[1],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw))
        end

    end

    if functions["anti-aim"].anti_aim_state ~= "Manual" and ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw) ~= "Slow jitter" and ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw) ~= "L&R" and
     ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw) ~= "Slow 5-way" then 
        ui_set(menu_reference.yaw[2],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_custom))
    end

    if functions["anti-aim"].anti_aim_state ~= "Manual" and ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw) ~= "Off" and ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].random_flick) and globals_tickcount() % random_flick == 1 then 
        ui_set(menu_reference.yaw[1],"180")
        ui_set(menu_reference.yaw[2],client.random_int(-180, 180))
        random_flick=client.random_int(12, 64)
    end
 
    ui_set(menu_reference.yawjitter[1],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter))
    ui_set(menu_reference.yawjitter[2],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter_custom))
    

    if ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].body_yaw) == "Optimized slow" then 
        ui_set(menu_reference.bodyyaw[1],"Static")
        ui_set(menu_reference.bodyyaw[2],functions["anti-aim"].side == true and 115 or -115)
    elseif ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].body_yaw) == "Optimized jitter" then
        ui_set(menu_reference.bodyyaw[1],"Jitter")
        ui_set(menu_reference.bodyyaw[2],ui_get(menu_reference.yaw[2]))
    else
        ui_set(menu_reference.bodyyaw[1],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].body_yaw))
    end

    ui_set(menu_reference.edgeyaw,false)
    ui_set(menu_reference.roll,0)
    ui_set(menu_reference.freestand_body[1],false)

    
    ui_set(menu_reference.freestand[1],ui_get(menu["misc"].freestanding) and not table_contains(ui_get(menu["anti-aim"].freestanding_disablers),functions["anti-aim"].anti_aim_state))
    ui_set(menu_reference.freestand[2],(ui_get(menu["misc"].freestanding) and not table_contains(ui_get(menu["anti-aim"].freestanding_disablers),functions["anti-aim"].anti_aim_state)) == true and "Always on" or "On hotkey")

    functions["anti-aim"].manual_anti_aim_setup()
    functions["anti-aim"].defensive_setup(cmd)
    functions["anti-aim"].safe_anti_aim(cmd)
    functions["anti-aim"].anti_backstab()
end

Venus_aa.anti_backstabk = ui_new_checkbox(tab, container, "Anti backstab")
local closest_player = 0
functions["anti-aim"].venus_anti_aim = function(cmd)


    local ca = vector(client.camera_angles())
    local lp_origin = vector(entity_get_origin(entity_get_local_player()))
    local on_ground = bit.band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) == 1 and cmd.in_jump == 0


    local on_origin = vector(entity_get_origin(client.current_threat() ~= nil and client.current_threat() or entity_get_local_player()))
    local at_target = vector(lp_origin:to(on_origin):angles())

    local ducking = cmd.in_duck == 1 or ui_get(menu_reference.fakeduck)
    local on_ground = bit.band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) == 1 and cmd.in_jump == 0
    local velocity = vector(entity_get_prop(entity_get_local_player(),"m_vecVelocity"))
    local slow_walk = ui_get(menu_reference.slow[1]) and ui_get(menu_reference.slow[2]) 
    local fake_lag = not ui_get(menu_reference.dt[2]) and not ui_get(menu_reference.os[2])
    local lp_origin = vector(entity_get_origin(entity_get_local_player()))
    local current_threat_origin = vector(entity_get_origin(client.current_threat() or entity_get_local_player()))

    old_state = functions["anti-aim"].anti_aim_state

    -- now we execute
    -- need to add legit aa
    if ui_get(Venus_aa["Manual"].enable) and functions["anti-aim"].mode ~= "reset" then 
        functions["anti-aim"].anti_aim_state = "Manual"
    elseif ui_get(menu["anti-aim"].builder["Height advantage"].enable) and lp_origin.z > current_threat_origin.z + 64 then
        functions["anti-aim"].anti_aim_state = "Height advantage"
    elseif fake_lag and ui_get(Venus_aa["Fakelag"].enable) then
        functions["anti-aim"].anti_aim_state = "Fakelag"
    elseif not on_ground and cmd.in_duck == 1 and ui_get(Venus_aa["Duck jumping"].enable) then 
        functions["anti-aim"].anti_aim_state = "Duck jumping"
    elseif not on_ground and ui_get(Venus_aa["Jumping"].enable) then
        functions["anti-aim"].anti_aim_state = "Jumping"
    elseif ducking and velocity:length2d() < 3 and ui_get(Venus_aa["Ducking"].enable) and on_ground then 
        functions["anti-aim"].anti_aim_state = "Ducking"
    elseif ducking and velocity:length2d() >= 3 and ui_get(Venus_aa["Duck moving"].enable) and on_ground then 
        functions["anti-aim"].anti_aim_state = "Duck moving"
    elseif slow_walk and ui_get(Venus_aa["Slow walking"].enable) then 
        functions["anti-aim"].anti_aim_state = "Slow walking"
    elseif velocity:length2d() >= 3 and ui_get(Venus_aa["Moving"].enable) and not slow_walk then 
        functions["anti-aim"].anti_aim_state = "Moving"
    elseif velocity:length2d() < 3 and ui_get(Venus_aa["Standing"].enable) and not slow_walk then 
        functions["anti-aim"].anti_aim_state = "Standing"
    else
        functions["anti-aim"].anti_aim_state = "Global"
    end

    
    ui_set(menu_reference.enabled, true)
    ui_set(menu_reference.pitch[1], ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].pitch))
    ui_set(menu_reference.yaw[1],ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].yaw))
    ui_set(menu_reference.yaw[2],ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].yaw_custom))
    ui_set(menu_reference.yawbase,"At targets")
    ui_set(menu_reference.yawjitter[1],"Off")
    ui_set(menu_reference.yawjitter[2],0)
    ui_set(menu_reference.bodyyaw[1],"Static")
    ui_set(menu_reference.bodyyaw[2],1)

    ui_set(menu_reference.freestand[1],ui_get(menu["misc"].freestanding) and not table_contains(ui_get(menu["anti-aim"].freestanding_disablers),functions["anti-aim"].anti_aim_state))
    ui_set(menu_reference.freestand[2],(ui_get(menu["misc"].freestanding) and not table_contains(ui_get(menu["anti-aim"].freestanding_disablers),functions["anti-aim"].anti_aim_state)) == true and "Always on" or "On hotkey")

    if cmd.in_use == 1 or cmd.in_attack == 1 or (entity_get_classname(entity.get_player_weapon(entity_get_local_player())) == "CKnife" and cmd.in_attack2 == 1) or (ui.get(menu_reference.freestand[1]) and ui.get(menu_reference.freestand[2]))  then 

        if cmd.in_use == 1 then 
            return
        end

        return  
    end


    if entity_get_prop(entity_get_local_player(), "m_MoveType") == 9 and (cmd.in_moveleft == 1 or cmd.in_moveright == 1 or cmd.in_forward == 1 or cmd.in_back == 1) then
        return
    end

    functions["anti-aim"].manual_anti_aim_setup()

    ui_set(menu_reference.enabled,ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].enable))
   
    local my_weapon = entity.get_player_weapon(entity_get_local_player())
    local pin_pulled = entity_get_prop(my_weapon, "m_bPinPulled")
    local throw_time = entity_get_prop(my_weapon, "m_fThrowTime")
    local weapon_id = bit.band(0xffff, entity_get_prop(my_weapon, "m_iItemDefinitionIndex"))

     local is_grenade =
     ({
         [43] = true,
         [44] = true,
         [45] = true,
         [46] = true,
         [47] = true,
         [48] = true,
         [68] = true
     })[weapon_id] or false

     if is_grenade then
         if throw_time > 0 then
             cmd.allow_send_packet = false
             return
         end
     end

    -- jitter
    if cmd.chokedcommands == 0 then 
        jitter_byaw = not jitter_byaw
    end

    -- local view :thumbs_up:

    -- pitch
    if ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].pitch)  == "Down" then 
        cmd.pitch = 89
    elseif ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].pitch)  == "Minimal" then 
        cmd.pitch = 85
    elseif ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].pitch)  == "Up" then 
        cmd.pitch = -85
    elseif ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].pitch)  == "Random" then 
        cmd.pitch = client.random_int(-89, 89)
    end
    

    -- yaw
    if ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].yaw) == "180" then
        cmd.yaw = 180 + ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].yaw_custom) + (client.current_threat() ~= nil and at_target.y or ca.y)
    elseif ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].yaw) == "Static" then 
        cmd.yaw = ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].yaw_custom) + (client.current_threat() ~= nil and at_target.y or ca.y)
    elseif ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].yaw) == "Spin" then 
        spen = spen + ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].yaw_custom)
        cmd.yaw = (client.current_threat() ~= nil and at_target.y or ca.y) + spen
    end

    -- yaw jitter
    if ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].yaw_jitter) ~= "Off" then
        cmd.yaw = cmd.yaw + (jitter_byaw and ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].yaw_jitter_custom) or -ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].yaw_jitter_custom)) 
    end



    if functions["anti-aim"].mode == "right" then 
        cmd.yaw = -89 + ca.y
    elseif functions["anti-aim"].mode == "left" then
        cmd.yaw = 89 + ca.y
    end

    -- body yaw
    if ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].body_yaw) ~= "Off" then 


        -- micro movement
        if cmd.in_moveright == 0 and cmd.in_moveleft == 0 and on_ground then 
            if globals_tickcount() % 2 == 0 then 
                cmd.sidemove = entity_get_prop(entity_get_local_player(),"m_flDuckAmount") > 0 and 2.98 or 1.01
            else
                cmd.sidemove = entity_get_prop(entity_get_local_player(),"m_flDuckAmount") > 0 and -2.98 or -1.01
            end
        end

        if cmd.chokedcommands == 0 then 

            if ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].body_yaw) == "Static" then 
                cmd.yaw = cmd.yaw + ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].body_yaw_custom)
            elseif ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].body_yaw) == "Jitter" then
                cmd.yaw = cmd.yaw + (jitter_byaw and ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].body_yaw_custom) or -ui_get(Venus_aa[functions["anti-aim"].anti_aim_state].body_yaw_custom))
            end
            cmd.allow_send_packet = false
        else
            cmd.yaw = cmd.yaw
            cmd.allow_send_packet = true
        end
    end


    -- anti backstab
    if ui_get(Venus_aa.anti_backstabk) then
            distance = 99999
        for k,v in ipairs(entity.get_players(true)) do
            
            local local_origin = vector(entity_get_origin(entity_get_local_player()))
            local players_origin = extrapolate_pos(v,vector(entity_get_origin(v)),10)
            local closest_origin = vector(entity_get_origin(closest_player))

            --hi ori I don't even know what the fuck is going on :|
            if local_origin:dist2d(players_origin) <= distance  then
                closest_player = v
                distance = local_origin:dist2d(players_origin)
            elseif local_origin:dist2d(players_origin) <= local_origin:dist2d(closest_origin) then
                closest_player = v
                distance = local_origin:dist2d(players_origin)
            end

            if entity_get_classname(entity.get_player_weapon(closest_player)) == "CKnife" and local_origin:dist2d(vector(entity_get_origin(closest_player))) < 250 then 
                cmd.yaw = 0 + at_target.y 
            end
        end
    end
    

    
end


functions["visuals"].onetap_watermark = function(w,h)

    if not ui_get(menu["visuals"].ot_watermark) then 
        return 
    end

    local nci = engineclient.get_net_channel_info()

    local lua_name = "Venus"
    local address = nci.address

    if address == "loopback" then
        address = "Local server"
    end

    local get_ping = math.floor(math.min(1000,client.latency() * 1000))

    local text_size,text_size2 = renderer_measure_text(nil, string.format("%s | %s | %s | ping %s ms",lua_name,obex_data.username,address,get_ping))
    --renderer_gradient((w-text_size)-27, 5, text_size+27, 18, 12,12, 12,0, 12, 12, 12, 175,true)
    renderer_gradient((w-text_size)-27, 5, text_size+27, 18, 12, 12, 12, 0, 12, 12, 12, 175, true)
    renderer_text((w-text_size) - 9,7,220,220,220,255,nil,0,string.format("%s | %s | %s | ping %s ms",lua_name,obex_data.username,address,get_ping))
end

local animations = {dt=0,os=0,main=0,safepoint=0,baim=0,quickpeek=0}
local scoped_animations = {lua_name=0,dt=0,os=0,main=0,safepoint=0,baim=0,quickpeek=0}

functions["visuals"].crosshair_indicator = function(w,h)

    if ui_get(menu["visuals"].indicator) ~= "Default" or not entity.is_alive(entity_get_local_player()) then
        return 
    end


    local spacing_h = 0

    local scope_check = entity_get_prop(entity_get_local_player(), "m_bIsScoped") == 1 and ui_get(menu["visuals"].indicator_scoped_animation)

    scoped_animations.lua_name = lerp(scoped_animations.lua_name,scope_check and renderer_measure_text("c-", string.format("Ven\a%02X%02X%02XFFus\afffffffe",ui_get(menu["visuals"].indicator_color)))/2+6 or 0,globals.frametime()*15)
    scoped_animations.dt = lerp(scoped_animations.dt,scope_check and renderer_measure_text("c-", "DT")/2+4 or 0,globals.frametime()*15)
    scoped_animations.os = lerp(scoped_animations.os,scope_check and renderer_measure_text("c-", "OS")/2+4 or 0,globals.frametime()*15)
    scoped_animations.main = lerp(scoped_animations.main,scope_check and renderer_measure_text("c-", "BAIM")/2+16 or 0,globals.frametime()*15)
  
   

    local dt_check = ui_get(menu_reference.dt[1]) and ui_get(menu_reference.dt[2])
    local os_check = ui_get(menu_reference.os[1]) and ui_get(menu_reference.os[2]) and (ui_get(menu_reference.  dt[1]) and not ui_get(menu_reference.dt[2]) or not ui_get(menu_reference.dt[1]))
   
    spacing_h = spacing_h + 10

    if ui_get(menu_reference.dt[1]) and ui_get(menu_reference.dt[2]) then 
        animations.dt = lerp(animations.dt,dt_check and spacing_h or 0,globals.frametime() * 15)
        renderer_text(w/2-2+math.ceil(scoped_animations.dt),h/2+27+math.ceil(animations.dt),255,255,255,anti_aim_funcs.get_double_tap() and 255 or 130,"c-",0,"DT")
        spacing_h = spacing_h + 10
    else
        animations.dt = 1
    end

    if ui_get(menu_reference.os[1]) and ui_get(menu_reference.os[2]) and (ui_get(menu_reference.dt[1]) and not ui_get(menu_reference.dt[2]) or not ui_get(menu_reference.dt[2]))then 
        animations.os = lerp(animations.os,os_check and spacing_h or 0,globals.frametime() * 15)
        renderer_text(w/2-2+math.ceil(scoped_animations.os),h/2+27+math.ceil(animations.os),255,255,255,255,"c-",0,"OS")
        spacing_h = spacing_h + 10
    else
        animations.os=1
    end

    local b1,b2 = renderer_measure_text("c-", "BAIM")
   
    animations.main = lerp(animations.main,spacing_h,globals.frametime() * 15)
    renderer_text(w/2-2+math.ceil(scoped_animations.main),h/2+27+math.ceil(animations.main),255,255,255,ui_get(menu_reference.forcebaim) and 255 or 130,"c-",0,"BAIM")
    renderer_text(w/2-2-b1+2+math.ceil(scoped_animations.main),h/2+27+math.ceil(animations.main),255,255,255,ui_get(menu_reference.safepoint) and 255 or 130,"c-",0,"SP")
    renderer_text(w/2-2+b1-2+math.ceil(scoped_animations.main),h/2+27+math.ceil(animations.main),255,255,255,ui_get(menu_reference.quickpeek[2]) and 255 or 130,"c-",0,"QP")
    renderer_text(w/2+math.ceil(scoped_animations.lua_name)-2,h/2+27,255,255,255,255,"c-",0,string.format("Ven\a%02X%02X%02XFFus\afffffffe",ui_get(menu["visuals"].indicator_color)):upper())
end


functions["visuals"].simple_crosshair_indicators = function(w,h)
    
    if ui_get(menu["visuals"].indicator) ~= "Simple" or not entity.is_alive(entity_get_local_player()) then
        return 
    end

    local spacing_h = 0

    local scope_check = entity_get_prop(entity_get_local_player(), "m_bIsScoped") == 1 and ui_get(menu["visuals"].indicator_scoped_animation)

  
    scoped_animations.dt = lerp(scoped_animations.dt,scope_check and renderer_measure_text("c", "dt")/2+2 or 0,globals.frametime()*15)
    scoped_animations.os = lerp(scoped_animations.os,scope_check and renderer_measure_text("c", "os")/2+2 or 0,globals.frametime()*15)
    scoped_animations.quickpeek = lerp(scoped_animations.quickpeek,scope_check and renderer_measure_text("c", "qp")/2+2 or 0,globals.frametime()*15)
    scoped_animations.baim = lerp(scoped_animations.baim,scope_check and renderer_measure_text("c", "fb")/2+2 or 0,globals.frametime()*15)
    scoped_animations.safepoint = lerp(scoped_animations.safepoint,scope_check and renderer_measure_text("c", "sp")/2+2 or 0,globals.frametime()*15)
  

    local dt_check = ui_get(menu_reference.dt[1]) and ui_get(menu_reference.dt[2])
    local os_check = ui_get(menu_reference.os[1]) and ui_get(menu_reference.os[2]) and (ui_get(menu_reference.dt[1]) and not ui_get(menu_reference.dt[2])) or (not ui_get(menu_reference.dt[1]))
    local qp_check = ui_get(menu_reference.quickpeek[2]) and ui_get(menu_reference.quickpeek[1])

    if ui_get(menu_reference.dt[1]) and ui_get(menu_reference.dt[2]) then 
        spacing_h = spacing_h + 12
        animations.dt = lerp(animations.dt,dt_check and spacing_h or 0,globals.frametime() * 15)
        renderer_text(w/2+math.ceil(scoped_animations.dt),h/2+15+math.ceil(animations.dt),255,255,255,anti_aim_funcs.get_double_tap() and 255 or 130,"c",0,"dt")
    else
        animations.dt=0
    end

    animations.os = lerp(animations.os,os_check and spacing_h or 0,globals.frametime() * 15)
    if ui_get(menu_reference.os[1]) and ui_get(menu_reference.os[2]) and (ui_get(menu_reference.dt[1]) and not ui_get(menu_reference.dt[2])) or (not ui_get(menu_reference.dt[1])) then 
        renderer_text(w/2+math.ceil(scoped_animations.os),h/2+27+math.ceil(animations.os),255,255,255,255,"c",0,"os")
        spacing_h = spacing_h + 12
    else
        animations.os=0
    end

    animations.baim = lerp(animations.baim,ui_get(menu_reference.forcebaim) and spacing_h or 0,globals.frametime() * 15)
    if ui_get(menu_reference.forcebaim) then
        renderer_text(w/2+math.ceil(scoped_animations.baim),h/2+27+math.ceil(animations.baim),255,255,255,255,"c",0,"fb")
        spacing_h = spacing_h + 12
    else
        animations.baim=-12
    end

    animations.safepoint = lerp(animations.safepoint,ui_get(menu_reference.safepoint) and spacing_h or 0,globals.frametime() * 15)
    if ui_get(menu_reference.safepoint) then
        renderer_text(w/2+math.ceil(scoped_animations.safepoint),h/2+27+ math.ceil(animations.safepoint),255,255,255,255,"c",0,"sp")
        spacing_h = spacing_h + 12
    else
        animations.safepoint=-12
    end

    animations.quickpeek = lerp(animations.quickpeek,qp_check and spacing_h or 0,globals.frametime() * 15)
    if ui_get(menu_reference.quickpeek[2]) and ui_get(menu_reference.quickpeek[1]) then
        renderer_text(w/2+math.ceil(scoped_animations.quickpeek),h/2+27+math.ceil(animations.quickpeek),255,255,255,255,"c",0,"qp")
        spacing_h = spacing_h + 12
    else
        animations.quickpeek=-12
    end
end

functions["visuals"].manual_anti_aim_indicators = function(w,h)

    if not ui_get(menu["visuals"].manual_anti_aim_indicators) or not entity.is_alive(entity_get_local_player()) then 
        return 
    end

    local mcolor = { ui_get(menu["visuals"].manual_anti_aim_indicators_color) }

    local left_color = {r=255,g=255,b=255,a=255}
    local right_color = {r=255,g=255,b=255,a=255}

    if functions["anti-aim"].mode == "right" then
        right_color = {r=mcolor[1],g=mcolor[2],b=mcolor[3],a=mcolor[4]}
    elseif functions["anti-aim"].mode == "left" then
        left_color = {r=mcolor[1],g=mcolor[2],b=mcolor[3],a=mcolor[4]}
    end

    -- right arrow
    renderer_text(w/2+50,h/2,right_color.r,right_color.g,right_color.b,right_color.a,"c+-",nil,"⯈")

    -- left arrow
    renderer_text(w/2-50,h/2,left_color.r,left_color.g,left_color.b,left_color.a,"c+-",nil,"⯇")
end

local shield_svg = '<svg width="800" height="800" viewBox="0 0 24 24" fill="#fff" xmlns="http://www.w3.org/2000/svg"><path d="M5 7c0-.276.225-.499.498-.535 2.149-.28 5.282-2.186 6.224-2.785a.516.516 0 0 1 .556 0c.942.599 4.075 2.504 6.224 2.785.273.036.498.259.498.535v4.75c0 6.5-7 8.75-7 8.75s-7-2.25-7-8.75V7Z" fill="white"/></svg>'
local load_shield = renderer.load_svg(shield_svg, 34, 34)

local defensive_alpha = 255
local svg_expansion = 0
functions["visuals"].defensive_indicator = function(w,h)

    functions["anti-aim"].sim_time=functions["anti-aim"].sim_diff()
    if not ui_get(menu["visuals"].defensive_indicator) or not ui_get(menu_reference.dt[2]) or ui_get(menu_reference.fakeduck) or not entity.is_alive(entity_get_local_player()) then 
        return 
    end

    local defensivecolor = { ui_get(menu["visuals"].defensive_indicator_color) }
    

    if functions["anti-aim"].sim_time < 0 then
        functions["visuals"].is_defensive = true
        functions["visuals"].defensive_tick = globals_tickcount()
        if functions["visuals"].forced_defensive and svg_expansion >= 0 then 
            --svg_expansion = 0
           
        elseif not functions["visuals"].forced_defensive then
         
            svg_expansion = 0
        end
        defensive_alpha = 255
    end

    if functions["visuals"].is_defensive == true and globals_tickcount() < functions["visuals"].defensive_tick + 28 then 
        local difference = globals_tickcount() - functions["visuals"].defensive_tick

        local percentage = math.min(100,difference * 100 / 26)
        local weight = percentage * 100 / 100

        if percentage > 75 then 
            defensive_alpha = lerp(defensive_alpha,0,globals.frametime() * 15)
        end

        svg_expansion = lerp(svg_expansion,30,globals.frametime() * 10)

        --renderer_text(w/2,h/2-110,255,255,255,defensive_alpha < 255 and defensive_alpha or 255,"c",nil,"DEFENSIVE")


        renderer_texture(load_shield,w/2 - svg_expansion/2-1,h/2-110 - 26, svg_expansion + 2 , 32, 12,12,12,defensive_alpha <  defensivecolor[4] and defensive_alpha or  defensivecolor[4],"f")
        renderer_texture(load_shield,w/2 - svg_expansion/2,h/2-110 - 25, svg_expansion , 30, 255,255,255,defensive_alpha <  defensivecolor[4] and defensive_alpha or  defensivecolor[4],"f")
        renderer_rectangle(w/2-51,h/2-101, 102, 4, 12,12,12,defensive_alpha < 130 and defensive_alpha or 130)
        renderer_rectangle(w/2-50,h/2-100, functions["visuals"].forced_defensive and 100 or weight, 2, defensivecolor[1], defensivecolor[2], defensivecolor[3],defensive_alpha <  defensivecolor[4] and defensive_alpha or  defensivecolor[4])
    else
        functions["visuals"].is_defensive = false
    end
end

functions["visuals"].fps_boost = function(int)
    cvar.r_drawparticles:set_int(int)
    cvar.func_break_max_pieces:set_int(int)
    cvar.muzzleflash_light:set_int(int)
    cvar.r_drawtracers_firstperson:set_int(int)
    cvar.r_dynamic:set_int(int)
    cvar.mat_disable_bloom:set_int(int == 0 and 1 or 0)
    cvar.r_eyegloss:set_int(int)
    cvar.r_shadows:set_int(int)
end


functions["visuals"].desync_indicator = function(w,h)

    if not ui_get(menu["visuals"].desync_indicator) then 
        return 
    end

    local desynccolor = { ui_get(menu["visuals"].desync_indicator_color) }
    local desync = math.abs(math.floor(math.min(60, (entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * 120 - 60))))


    
    renderer_rectangle(w/2 - 29, h/2+13,60,4, 0,0,0,255)
    renderer_gradient(w/2 - 28,h/2+14,desync - 2,2,12,12,12,120,desynccolor[1], desynccolor[2], desynccolor[3],desynccolor[4],true)
    --renderer_gradient(w/2, h/2+15,desync/2,2, desynccolor[1], desynccolor[2], desynccolor[3],desynccolor[4],desynccolor[1], desynccolor[2], desynccolor[3],0, true)
    --renderer_gradient(w/2, h/2+15,-desync/2,2, desynccolor[1], desynccolor[2], desynccolor[3],desynccolor[4],desynccolor[1], desynccolor[2], desynccolor[3],0, true)
end

local slow_turtle = renderer.load_svg('<svg width="800" height="800" viewBox="0 0 128 128" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" class="iconify iconify--noto"><path d="M112.7 59.21s3.94-2.21 4.93-2.77c.99-.56 4.6-2.82 5.91-.84.77 1.16-.7 4.44-3.05 7.86-2.14 3.13-7.12 9.56-7.4 10.83-.28 1.27 1.11 6.36 1.53 8.33.42 1.97 1.74 6.71 1.17 8.54s-3.43 6.85-10.75 6.76c-5.82-.07-7.51-1.78-7.7-2.82-.14-.75-.56-3.24-.56-3.24s-4.79 2.96-7.04 4.08-8.31 4.22-8.31 4.22 1.17 5.35 1.36 7.51c.19 2.16.86 5.25-.28 7.32-1.03 1.88-4.25 5.02-11.83 4.97-5.92-.04-7.41-1.88-8.35-3-.94-1.13-1.13-6.48-1.13-7.6s-.19-5.07-.19-5.07-8.02-.4-12.86-.75c-4.38-.32-10.16-.99-10.16-.99s.21 2.33.42 4.01c.19 1.5.23 4.64-1.34 6.17-2.11 2.06-7.56 2.21-10.56 1.92-3-.28-7.18-1.83-8.4-4.55-1.22-2.72.38-6.29 1.03-8.35.58-1.81 1.6-4.41 1.22-5.16-.38-.75-4.04-1.69-9.29-6.95-5.26-5.26-12.13-23.52 3.28-36.23 15.49-12.76 43.81 1.1 45.31 2.04 1.54.96 53.04 3.76 53.04 3.76z" fill="#bdcf47"/><path d="M66.25 25.28c-13.93.62-24.38 7.52-29.57 15.06-3.1 4.5-4.65 7.74-4.65 7.74s4.81.14 9.15 2.46c5 2.67 10.8 5.56 14.61 18.13 2.87 9.5 3.98 18.53 11.44 20.52 8.45 2.25 28.16 1.13 37.59-8.02s11.26-16.05 8.87-25.06-13.17-25.05-28.16-29.28C79.06 25 72.58 25 66.25 25.28z" fill="#6e823a"/><path d="M111.93 51.32c-.42-.99-1.3-2.5-1.3-2.5s-.07 2.05-.25 3.13c-.28 1.76-1.25 5.42-1.81 4.88-1-.97-5.73-6.92-7.98-10.23-1.71-2.52-7.6-9.11-7.74-11.26-.07-1.06 1.27-4.65 1.27-4.65s-1.22-.7-2.35-1.34c-.88-.49-2.16-1.03-2.16-1.03s-.77 4.9-1.62 5.82c-.75.81-5.32 2.6-8.87 3.94-4.29 1.62-8.45 3.73-10 4.01-1.36.25-9.09-1.41-12-1.97-3.66-.7-9.18-2.26-10.45-3.17-1.48-1.06-3.07-3.78-3.07-3.78s-.89.61-1.78 1.31c-.88.69-2.02 2.06-2.02 2.06s2.31 2.32 2.44 3.18c.18 1.2-1.27 2.83-2.46 4.38-.72.93-2.75 4.85-2.75 4.85s.97.09 2.15.63c1.23.57 2.38 1.16 2.38 1.16s2.97-6.9 4.9-7.53c1.65-.54 6.3.99 9.68 1.69 4.79.99 9.64 1.87 10.66 3.17 1.06 1.34 2.06 6.68 3.03 11.19C70.89 64.2 73.64 77.02 73 78c-.63.99-5.7.63-8.59.28-2.45-.3-6.41-1.76-6.41-1.76s.58 2.11.77 2.67c.28.81 1.16 3.06 1.16 3.06s5.67 2.5 22.42.95 25.03-12.96 27.38-18.02c3.14-6.78 3.54-10.39 3.54-10.39s-.92-2.48-1.34-3.47zM96.65 73.21c-4.24 2.67-15.2 5.49-17.18 4.43-1.58-.85-3.94-13.94-5.07-19.78-.72-3.74-2.45-9.42-1.41-11.19.7-1.2 4.79-2.99 7.81-4.4 2.87-1.33 6.97-3.13 8.17-2.99 1.7.2 5.35 6.12 9.01 11.19 3.66 5.07 7.67 10.35 7.74 12.18.09 1.84-4.7 7.82-9.07 10.56z" fill="#484e23"/><path d="M41.18 65.86c.5 2.83-.95 5.75-4.07 6.02-2.56.22-4.59-1.57-5.09-4.4s1.14-5.49 3.68-5.94c2.52-.45 4.98 1.48 5.48 4.32zm-18.36.25c.07 2.84-2.42 5.69-5.5 5.11-2.53-.48-3.99-2.73-3.71-5.55.29-2.82 2.59-4.9 5.15-4.65s3.99 2.13 4.06 5.09zm7.95 10.48c1.16-.79 3.1-2.67 4.36-1.06 1.27 1.62-.92 3.1-2.18 4.01-1.27.92-4.08 3.17-6.12 3.17-1.9 0-4.79-2.32-6.62-3.87-1.49-1.26-2.18-2.89-1.34-3.87s2.14-.62 3.24.35c1.27 1.13 3.72 3.38 4.72 3.38.98.01 2.39-1.05 3.94-2.11z" fill="#2a2b28"/></svg>', 100, 100)

local slow_turtle_pos = 0
functions["visuals"].slow_down_indicator = function(w,h)

    if not ui_get(menu["visuals"].slow_down_indicator) or not entity.is_alive(entity_get_local_player()) then
        return 
    end

    local slowdowncolor = { ui_get(menu["visuals"].slow_down_indicator_color) }
    local slow_status = math.floor(entity_get_prop(entity_get_local_player(), "m_flVelocityModifier") * 100)

    if slow_status < 100 and slow_status > 0 then

        
       
        local percentage = slow_status * 98 / 100


        if ui.get(menu["visuals"].turtle_slow) then 
            slow_turtle_pos = lerp(slow_turtle_pos, w / 2 - 12.5,globals.frametime() * 10)
            renderer_texture(slow_turtle, slow_turtle_pos,h/2-251 ,25,25, 255,255,255,255, "f")
        end

        renderer_text(w/2,h/2-210,255,255,255,255,"c",0,100 - slow_status .. "%")
        renderer_rectangle(w/2-51,h/2-201,100,4,12,12,12,130)
        renderer_rectangle(w/2-50,h/2-200,percentage,2,255 - (slow_status*2),2.55 * slow_status,0,slowdowncolor[4])

        return
    end

    slow_turtle_pos = w / 2 - 110
end

functions["visuals"].minimum_damage_indicator = function(w,h)

    if not ui_get(menu["visuals"].minimum_damage_indicator) or not entity.is_alive(entity_get_local_player()) then 
        return 
    end


    local minimus_damage = ui_get(menu_reference.min_dmg_override[1]) and ui_get(menu_reference.min_dmg_override[2])
    renderer_text(w/2+12,h/2-12,255,255,255,255,"c",0,minimus_damage and ui_get(menu_reference.min_dmg_override[3]) or ui_get(menu_reference.minimum_damage))
end

local zeus_table = {}
local zeus_texture = renderer.load_svg('<svg width="800" height="800" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M7 0 2 12h8L6 22 20 8h-9l6-8z" fill="#fff"/><path fill="gray" d="M7 0 2 12h3l5-12zm3 12L6 22l3-3 4-7z"/><path fill="gray" d="m10 12-.406 1H12.5l.5-1h-3z"/></svg>', 30, 30)
functions["visuals"].zeus_indicator = function()



    -- clear the zeus_table :)
    zeus_table = {}

    -- get player origin

    if entity_get_local_player() == nil then return end

    local entity_origin = vector(entity_get_origin(entity_get_local_player()))

    local pl = entity.get_players(true)
    for i = 1, #pl do
   
        local ent = pl[i]

        if ent == entity_get_local_player() then
            break 
        end

        local bounding_box =  {entity.get_bounding_box(ent) }
        local has_zeus = false

     

        for index = 0, 64 do
            local a = entity_get_prop(ent, "m_hMyWeapons", index)
            if a ~= nil then
                local wep = entity_get_classname(a)
                if wep ~= nil and wep == "CWeaponTaser" then
                    has_zeus = true
                    table.insert(zeus_table,ent)
                end
            end
        end

   
        local ent_gin = vector(entity_get_origin(ent))
        
        
        if has_zeus and entity_get_classname(entity.get_player_weapon(ent)) ~= "CWeaponTaser" then

            if bounding_box[1] ~= nil and bounding_box[2] ~= nil and bounding_box[3] ~= nil and bounding_box[4] ~= nil then 
                if table_contains(ui_get(menu["visuals"].zeus_esp),"Indicator") and table_contains(ui_get(menu["visuals"].player_esp),"Zeus esp") then
                    if entity_origin:dist(ent_gin) < 500 then 
                        renderer_texture(zeus_texture,bounding_box[1] - 20,bounding_box[2], 15, 15, 255,167,0,255,"f")
                    end
                end
            end
        elseif has_zeus and entity_get_classname(entity.get_player_weapon(ent)) == "CWeaponTaser" then

            if bounding_box[1] ~= nil and bounding_box[2] ~= nil and bounding_box[3] ~= nil and bounding_box[4] ~= nil then 
                if table_contains(ui_get(menu["visuals"].zeus_esp),"Indicator") and table_contains(ui_get(menu["visuals"].player_esp),"Zeus esp") then
                    if entity_origin:dist(ent_gin) < 500 then 
                        renderer_texture(zeus_texture,(bounding_box[1] + bounding_box[3]) / 2 - 10,bounding_box[2] - 40, 15, 15, 255,50,50,255,"f")
                    end
                end
            end
        elseif not has_zeus then
            if zeus_table[i] == ent then
               table.remove(zeus_table,ent) 
            end
        end
    end
end
-- [pasted]
local function rotate_around_center(ang, center, point, point2)
	local s, c = math.sin(ang), math.cos(ang)
	point.x,point.y,point2.x,point2.y=point.x-center.x,point.y-center.y,point2.x-center.x,point2.y-center.y

	local x, y = point.x*c - point.y*s, point.x*s + point.y*c
	local x2, y2 = point2.x*c - point2.y*s, point2.x*s + point2.y*c

	return x+center.x, y+center.y, x2+center.x, y2+center.y
end


functions["visuals"].zeus_out_of_view = function()

    if table_contains(ui_get(menu["visuals"].zeus_esp),"Out of view") and table_contains(ui_get(menu["visuals"].player_esp),"Zeus esp") then
        local lp_pos = vector(entity_get_origin(entity_get_local_player()))
        local view = vector(client.camera_angles()); if view == nil then return end
        local w,h = client.screen_size()
        local size, radius = 15, 20*8; radius = radius+size
    
        for k,v in ipairs(zeus_table) do
            
            local origen = vector(entity_get_origin(v))
            local dst = math.min(800,lp_pos:dist(origen))/800
    
            if not entity.is_alive(v) then
                table.remove(zeus_table,k)
                break
            end
    
            local w2s = {renderer.world_to_screen(origen:unpack())}
    
            if w2s[1] and w2s[2] and w2s[1] > 0 and w2s[2] > 0 and w2s[1] < w and w2s[2] < h then break end
    
            local _, angle = lp_pos:to(origen):angles() if not angle then break end
            angle=270-angle+view.y
            local ang_rad = math.rad(angle)
            local point = vector(w/2 + math.cos(ang_rad)*radius, h/2 + math.sin(ang_rad)*radius, 0)
    
            local point2, point3 = vector(point.x - size/2, point.y - size, 0), vector(point.x + size/2, point.y-size, 0)
            local points = { rotate_around_center(math.rad(angle-90), point, point2, point3) }

            local zeus_color = {r=255,g=50,b=50}

            if entity_get_classname(entity.get_player_weapon(v)) == "CWeaponTaser" then
                zeus_color = {r=255,g=50,b=50}
            else
                zeus_color = {r=255,g=167,b=0}
            end 
    
            renderer_texture(zeus_texture,point.x, point.y, 30, 30, zeus_color.r,zeus_color.g,zeus_color.b,255,"f")
        end
    end
end

-- at target flag | at target esp
client.register_esp_flag("target",255,255,255, function(ent)
    if ent == client.current_threat() and table_contains(ui_get(menu["visuals"].player_esp),"At target flag") then 
        return true,string.format("\a%02x%02x%02x%02xTARGET",ui_get(menu["visuals"].target_color))
     end
end)

client.register_esp_flag("zeus",255,255,255, function(ent)
    if table_contains(ui_get(menu["visuals"].zeus_esp),"Flag") and table_contains(ui_get(menu["visuals"].player_esp),"Zeus esp") then
        for i=1,#zeus_table do 
        
            if zeus_table[i] == entity_get_local_player() then 
                break 
            end
    
            if ent == zeus_table[i] then 
                return true,string.format("\a%02x%02x%02x%02xZEUS",ui_get(menu["visuals"].zeus_indicator_color))
            end
        end
    end
end)

local eye_svg = renderer.load_svg('<svg fill="#fff" height="800" width="800" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" xml:space="preserve"><path d="M0 226v32c128 192 384 192 512 0v-32C384 34 128 34 0 226zm256 144c-70.7 0-128-57.3-128-128s57.3-128 128-128 128 57.3 128 128-57.3 128-128 128zm0-200c0-8.3 1.7-16.1 4.3-23.6-1.5-.1-2.8-.4-4.3-.4-53 0-96 43-96 96s43 96 96 96 96-43 96-96c0-1.5-.4-2.8-.4-4.3-7.4 2.6-15.3 4.3-23.6 4.3-39.8 0-72-32.2-72-72z" fill="white" /></svg>', 50,50)

functions["visuals"].spectators_ot = function(w,h)
    local spectator_add_up = 0

    if not ui_get(menu["visuals"].spectator_ot) or not entity.is_alive(entity_get_local_player()) then return end 

    --local players = entity.get_players(true)
    for i = 1, globals.maxplayers() do 

    
       if entity_get_classname(i) == 'CCSPlayer' then
            local target = entity_get_prop(i, 'm_hObserverTarget')

            if target == entity_get_local_player() then
                spectator_add_up = spectator_add_up + 20
                renderer_text(30, h/2 - spectator_add_up - 5, 220,220,220,255, nil, 0, entity.get_player_name(i))
                renderer_texture(eye_svg, 3,  h/2 - spectator_add_up - 5, 20, 15, 255,255,255,255, "f")
            end
           
       end

    end
end

functions["misc"].local_animations = function()
    if not entity.is_alive(entity_get_local_player()) then
        functions["misc"].end_time = 0
        functions["misc"].ground_ticks = 0
        return
    end

    if table_contains(ui_get(menu["misc"].local_animations),"Pitch 0 on land") then

        
        local on_ground = bit.band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1)

        if on_ground == 1 then
            functions["misc"].ground_ticks = functions["misc"].ground_ticks + 1
        else
            functions["misc"].ground_ticks = 0
            functions["misc"].end_time = globals.curtime() + 1
        end

        if  functions["misc"].ground_ticks > 5 and functions["misc"].end_time + 0.5 > globals.curtime() then
            entity.set_prop(entity_get_local_player(), "m_flPoseParameter", 0.5, 12)
        end
    end

    if table_contains(ui_get(menu["misc"].local_animations),"Jitter legs") then
        local math_randomized = math.random(1,2)

        ui_set(menu_reference.leg_movement, math_randomized == 1 and "Always slide" or "Never slide")
        entity.set_prop(entity_get_local_player(), "m_flPoseParameter", 8, 0)
    end

    if table_contains(ui_get(menu["misc"].local_animations),"Static legs in air") then
        entity.set_prop(entity_get_local_player(), "m_flPoseParameter", 1, 6) 
    end

    if table_contains(ui_get(menu["misc"].local_animations),"Crossing legs") then
       

        local me = ent_lib.get_local_player()
        local m_fFlags = me:get_prop("m_fFlags")
        local is_onground = bit.band(m_fFlags, 1) ~= 0
        if not is_onground then
            local my_animlayer = me:get_anim_overlay(6) 
           
            my_animlayer.weight = 1
        else
            ui_set(menu_reference.leg_movement,"Off")
            entity.set_prop(entity_get_local_player(), "m_flPoseParameter", 0, 7)
        end
    end

    if table_contains(ui_get(menu["misc"].local_animations),"Flashed") then

        local local_player_ent = ent_lib.get_local_player() 
        local not_anim_layer = local_player_ent:get_anim_overlay(9) 
        not_anim_layer.weight = 1
        not_anim_layer.sequence = 224
    end

    if table_contains(ui_get(menu["misc"].local_animations),"Victim") then

        local local_player_ent = ent_lib.get_local_player() 
        local not_anim_layer = local_player_ent:get_anim_overlay(0)
        not_anim_layer.sequence = 11
    end
end

local aim_logs={}

local miss_hc = 0
local backtrack = 0
local predicted_dmg = 0
client_set_event_callback("aim_fire", function(ctx)
    backtrack = globals_tickcount() - ctx.tick
    miss_hc = ctx.hit_chance
    predicted_damage = ctx.damage
end)


local miss_sp = {}
local current_logs = {}
local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
client_set_event_callback("aim_miss", function(ctx)

   
    if #ui_get(menu["misc"].safe_point) > 0 then
        if ctx ~= nil then
            local hp_left = entity.get_prop(ctx.target, "m_iHealth")
            miss_sp[#miss_sp + 1] = 
            {
                nigga = ctx.target,
                hp = hp_left,
            }
        end
    
    end

    if ctx.reason == "?" then
        ctx.reason = "unknown"
    end

    if ui_get(menu["misc"].aim_logs) then

        local color = string.format("\a%02X%02X%02XFF",ui_get(menu["misc"].aim_logs_miss_color))

        local w,h=client.screen_size()
        aim_logs[#aim_logs+1]={
            bullet_tick=globals_tickcount()*globals.tickinterval(),
            start_position=h/2+200,
            text=string.format("Venus ~ Missed ".. color .. "%s\affffffff in the " .. color .. "%s\affffffff due to " .. color .. "%s\affffffff.",entity.get_player_name(ctx.target),hitgroup_names[ctx.hitgroup+1],ctx.reason)
        }
    end

    if ui_get(menu["misc"].print_logs) then 

        local current_aim_text = plist.get(ctx.target,"Force body yaw") and string.format("- Missed - %s in the %s for %s due to %s [hc: %s | bt: %s | body: %s]",entity.get_player_name(ctx.target),hitgroup_names[ctx.hitgroup+1],predicted_damage,ctx.reason,math.floor(miss_hc),backtrack,plist.get(ctx.target,"Force body yaw value")) or string.format("- Missed - %s in the %s for %s due to %s [hc: %s | bt: %s]",entity.get_player_name(ctx.target),hitgroup_names[ctx.hitgroup+1],predicted_damage,ctx.reason,math.floor(miss_hc),backtrack)
        client.log(current_aim_text)
       -- client.log('con_filter_text "-hit-"')
    end 

    if table_contains(ui_get(menu["misc"].old_logs),"aim_miss") then 
        local color = "\aF85454FF"
        current_logs[#current_logs + 1 ] = {
            text=string.format("Venus ~ Missed ".. color .. "%s\affffffff in the " .. color .. "%s\affffffff due to " .. color .. "%s\affffffff.",entity.get_player_name(ctx.target),hitgroup_names[ctx.hitgroup+1],ctx.reason),
            current_time = globals_tickcount()
         }
    end
end)

client_set_event_callback("aim_hit", function(ctx)

    if ui_get(menu["misc"].aim_logs) then
        local w,h=client.screen_size()
        local color = "\a96E631FF"
        aim_logs[#aim_logs+1]={
            bullet_tick=globals_tickcount()*globals.tickinterval(),
            start_position=h/2+200,
            text=string.format("Venus ~ Hit " .. color .. "%s\affffffff in the " .. color .. "%s\affffffff for " .. color .. "%s\affffffff.",entity.get_player_name(ctx.target),hitgroup_names[ctx.hitgroup+1] ,ctx.damage)
        }
    end

    if ui_get(menu["misc"].print_logs) then 
        local current_aim_text = plist.get(ctx.target,"Force body yaw") and string.format("- Hit - %s in the %s for %s [hc: %s | bt: %s | body: %s]",entity.get_player_name(ctx.target),hitgroup_names[ctx.hitgroup+1],ctx.damage,math.floor(ctx.hit_chance),backtrack,plist.get(ctx.target,"Force body yaw value")) or string.format("- Hit - %s in the %s for %s [hc: %s | bt: %s]",entity.get_player_name(ctx.target),hitgroup_names[ctx.hitgroup+1],ctx.damage,math.floor(ctx.hit_chance),backtrack)
        client.log(current_aim_text)
       -- client.log('con_filter_text "-hit-"')
    end 

    if table_contains(ui_get(menu["misc"].old_logs),"aim_hit") then 
        local color = string.format("\a%02X%02X%02XFF",ui_get(menu["misc"].aim_logs_hit_color))
        current_logs[#current_logs + 1 ] = {
            text=string.format("Venus ~ Hit " .. color .. "%s\affffffff in the " .. color .. "%s\affffffff for " .. color .. "%s\affffffff.",entity.get_player_name(ctx.target),hitgroup_names[ctx.hitgroup+1] ,ctx.damage),
            current_time = globals_tickcount()
        }
    end
end)

client_set_event_callback("item_purchase", function(ctx)

    if not table_contains(ui_get(menu["misc"].old_logs),"item_purchase") or ctx.weapon == "weapon_unknown" then 
        return 
    end

    if client.userid_to_entindex(ctx.userid) == entity_get_local_player() then 
        return 
    end

  
    local x,y = string.find(ctx.weapon,"weapon_")
    local x1,y1 = string.find(ctx.weapon,"item_")

    ctx.weapon = string.sub(ctx.weapon,y == nil and y1+1 or y+1,#ctx.weapon)
    --ctx.weapon:sub(x == nil and x1 or x,y == nil and y1 or y)

    current_logs[#current_logs + 1 ] = {
        text = string.format("%s purchased %s", entity.get_player_name(client.userid_to_entindex(ctx.userid)),ctx.weapon),
        current_time = globals_tickcount()
    }
end)

local logs = {
    three = {},
    render_logs = function(self,text)
        self.three[#self.three + 1] = {
            render_text = text
        }

        renderer_text(5, (#self.three * 12) - 12, 220,220,220, 255, "", 0, text)
    end,
}

functions["visuals"].old_logs = function(w,h)
   
    for i = 1,#current_logs do 
        logs:render_logs(current_logs[i].text,current_logs[i].current_time)

        if #logs.three * 12 > h / 2 then 
            table.remove(current_logs,1)
            break
        end
        
        if current_logs[i].current_time * globals.tickinterval() + 8 < globals_tickcount() * globals.tickinterval() then 
            table.remove(current_logs,i)
            break
        end
    end

end

functions["visuals"].aim_logs = function(w,h)

    if not ui_get(menu["misc"].aim_logs) then

        if #aim_logs > 0 then
            aim_logs={}
        end

        return 
    end

    for i=1,#aim_logs do 

        if aim_logs[i] == nil then 
            break
        end

        local aim = aim_logs[i]

        aim.start_position = lerp(aim.start_position,h/2+200+(i*30),globals.frametime()*15)

     
      
        renderer_rectangle(w/2 - renderer_measure_text("c", aim.text) / 2 - 5,aim.start_position - 10,renderer_measure_text("c", aim.text) + 24, 18 , 24,24,24,70)
        rectangle_outline(w/2 - renderer_measure_text("c", aim.text) / 2 - 7,aim.start_position - 12,renderer_measure_text("c", aim.text) + 26, 20,2 , 0,0,0,175)
        renderer_text(w/2,aim.start_position - 2,255,255,255,255,"c",0,aim.text)

        local current_ongoing_tick = globals_tickcount()*globals.tickinterval()
        local text_timer = (aim.bullet_tick + 5) - current_ongoing_tick
        local text_timer_percentage = text_timer / 5        

        renderer.circle_outline(w/2 + renderer_measure_text("c", aim.text) / 2 + 8, aim.start_position - 2 , 6,6,6,255, 5, 0, 1,1)
        renderer.circle_outline(w/2 + renderer_measure_text("c", aim.text) / 2 + 8, aim.start_position - 2, 255,255,255,255, 5, 0, text_timer_percentage,1)


        if h/2+200+(i*30) > h - 30 then
            table.remove(aim_logs,i)
            break
        end

        if globals_tickcount()*globals.tickinterval() > aim.bullet_tick + 5 then 
            table.remove(aim_logs,i)
            break
        end 
    end
end

local function clamp(value, minValue, maxValue)
    if value < minValue then
        return minValue
    end

    if value > maxValue then
         return maxValue
    end

    return value
end

local rgba_to_hex = function(b, c, d, e)
    return string.format('%02x%02x%02x%02x', b, c, d, e)
end

local function text_fade_animation(x, y, speed, color1, color2, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local x = i * 10  
        local wave = math.cos(2 * speed * curtime / 4 + x / 50)
        local color = rgba_to_hex(
            lerp(color1.r, color2.r, clamp(wave, 0, 1)),
            lerp(color1.g, color2.g, clamp(wave, 0, 1)),
            lerp(color1.b, color2.b, clamp(wave, 0, 1)),
            color1.a
        ) 
        final_text = final_text .. '\a' .. color .. text:sub(i, i) 
    end
    
    renderer_text(x, y, color1.r, color1.g, color1.b, color1.a, nil, nil, final_text)
end


functions["misc"].sunset = function()
    local sun_prop = entity.get_all('CCascadeLight')[1]


    if ui_get(menu["misc"].sunset_mode) and functions["misc"].sunset_active == false then
        functions["misc"].old_sun = vector(entity_get_prop(sun_prop, "m_envLightShadowDirection"))
        entity.set_prop(sun_prop,"m_envLightShadowDirection",0,0,0)
        functions["misc"].sunset_active = true
    elseif not ui_get(menu["misc"].sunset_mode) then
        if functions["misc"].sunset_active == true then
            entity.set_prop(sun_prop,"m_envLightShadowDirection",functions["misc"].old_sun.x,functions["misc"].old_sun.y,functions["misc"].old_sun.z)
            functions["misc"].sunset_active = false
        end
    end

end

local all_players = {}
local get_bots_players = function()

    for k,v in ipairs(entity.get_players(true)) do 
        table.insert(all_players,{index=v,old_pos=0,timeframe=entity.get_prop(v, "m_flSimulationTime") / globals.tickinterval(),wjitter=false,sjitter=false,loop=0})
       
        local was_found = true
        local times_found = 0
        for i,n in ipairs(all_players) do 
            if entity.get_player_name(n.index) == entity.get_player_name(entity_get_local_player()) then 
                table.remove(all_players,i)
                break 
            end

            if n.index == v then
                times_found = times_found + 1
                was_found = false
                if times_found >= 2 then
                    was_found = true 
                    table.remove(all_players,i)
                    break
                end
            else
                was_found = false
            end
        end
    end
end

client.register_esp_flag("FS",255,255,255, function(ent)
    if plist.get(ent,"Override safe point") == "On" then return "FS" end
end)


functions["misc"].safe_point = function()


    
    if #ui.get(menu["misc"].safe_point) > 0 then
        for i,n in ipairs(all_players) do
            local amount_of_shots = 0
            local hp_shot = 0
    
           if not entity.is_alive(n.index) then table.remove(all_players,i) break end
    
            if table_contains(ui.get(menu["misc"].safe_point),"Default") or table_contains(ui.get(menu["misc"].safe_point),"Lethal") then
                for k,v in ipairs(miss_sp) do
                    if v.nigga == nil or n.index == nil or v == nil then 
                        table.remove(miss_sp,k)
                        break 
                    end

                    if v.nigga == entity_get_local_player() then break end

                    if v.nigga == n.index then

                        if v.hp ~= nil and v.hp <= 50 and table_contains(ui.get(menu["misc"].safe_point),"Lethal")  then 
                            hp_shot = hp_shot + 1 
                        end
    
                        if table_contains(ui.get(menu["misc"].safe_point),"Default") == true then 
                            amount_of_shots = amount_of_shots + 1 
                        end
                    end

                    if entity.get_prop(v.nigga,"m_iHealth") <= 0 then
                        table.remove(miss_sp,k)
                        break
                    end
                end
            end
    
            local eyes = vector(entity.get_prop(n.index,"m_angEyeAngles"))
            
    
            local mathed = math.floor(eyes.y) - math.floor(n.old_pos)
    
            if mathed == 0 then
                n.loop = n.loop + 1
    
                if n.loop > 4 then 
                    n.wjitter = false
                    n.sjitter = false
                    n.loop = 0
                end
            else
                n.loop = 0
            end
                
        
           
            if mathed > 180 or mathed < -180 then
                local true_math = 0
    
                if mathed > 0 then
                    true_math = 199 - mathed
                else
                    true_math = -199 - mathed
                end
                
                if true_math > 80 or true_math < -80 and mathed ~= 0 then
                    n.sjitter = true
                   
                elseif (true_math <= 80 or true_math >= -80 and true_math <= -1) and mathed ~= 0 then 
                    n.wjitter = true
                    n.sjitter = false
                end
            elseif mathed < 180 or mathed > -180 then
                if mathed >= 80 or mathed <= -80 then
                    n.wjitter = true
                    n.sjitter = false
                elseif (mathed < 80 or mathed > -80 and mathed <= -1) and mathed ~= 0 then
                    n.sjitter = true
                   
                end

            elseif (mathed == 0 and n.wjitter == true) or (mathed == 0 and n.sjitter == true)  then 
                n.wjitter = true 
                n.sjitter = true
            end
    
            local is_wide_jitter_maybe = false 
           
            local velocity = vector(entity.get_prop(n.index,"m_vecVelocity"))
            local on_ground = bit.band(entity.get_prop(n.index, "m_fFlags"), 1) == 1
    
            
    
            if (hp_shot >= 1 and table_contains(ui.get(menu["misc"].safe_point),"Lethal") ) or 
            (amount_of_shots >= 2 and table_contains(ui.get(menu["misc"].safe_point),"Default")) or 
            (velocity:length2d() < 2 and on_ground and table_contains(ui.get(menu["misc"].safe_point),"Standing")) or 
            (n.wjitter == true and (not on_ground or velocity:length2d() > 3 and entity.get_prop(n.index,"m_flDuckAmount") <= 0 and on_ground) and table_contains(ui.get(menu["misc"].safe_point),"Wide jitter"))
            or (n.sjitter == true and (not on_ground or velocity:length2d() > 3 and entity.get_prop(n.index,"m_flDuckAmount") <= 0 and on_ground) and table_contains(ui.get(menu["misc"].safe_point),"Small jitter")) then
                plist.set(n.index, "Override safe point", "On")
            else
                plist.set(n.index, "Override safe point", "-")
            end
    
            local tempo = entity.get_prop(n.index, "m_flSimulationTime") / globals.tickinterval()
    
            if mathed == 0 then
            end
    
            if n.timeframe < tempo then
                n.timeframe = tempo
               
                n.old_pos = eyes.y
            end
        
        end 
    end
end


local resolver_status = false
functions["misc"].resolver = function()

    if ui_get(menu["misc"].resolver) then 

        resolver_status = true
        for k,_v in ipairs(entity.get_players(true)) do 
            local bbox = { entity.get_bounding_box(_v) }
    
            local player_index = ent_lib.new(_v)
    
            local possible_desync = math.floor(math.min(60, (entity_get_prop(_v, "m_flPoseParameter", 11) * 120 - 60)))
            local m_angEyeAngles = { entity_get_prop(_v,"m_angEyeAngles") }
            local on_ground = bit.band(entity_get_prop(_v, "m_fFlags"), 1) == 1
    
           
                --local current_angle = "R"
                
                --renderer_text(bbox[3] + 2,bbox[2]+(bbox[4] - bbox[2])/2+14,255,255,255,255,nil,0,player_index:get_anim_overlay(6).cycle)
                --renderer_text(bbox[3] + 2,bbox[2]+(bbox[4] - bbox[2])/2 + 14,255,255,255,255,nil,0,player_index:get_anim_state().current_feet_yaw)
               
    
              --[[ if player_index:get_anim_state().current_feet_yaw > 0 and player_index:get_anim_state().current_feet_yaw < 180 then 
                    current_angle = "R"
               elseif player_index:get_anim_state().current_feet_yaw > 180 and player_index:get_anim_state().current_feet_yaw < 359 then 
                    current_angle = "L"
               elseif player_index:get_anim_state().current_feet_yaw == 0 or player_index:get_anim_state().current_feet_yaw == 360  then
                    current_angle = "F"
               else
                    current_angle = "B"
               end]]--
    
               if math.floor(math.max(-60,math.min(60,m_angEyeAngles[2]-player_index:get_anim_state().current_feet_yaw))) < possible_desync + 1 and math.floor(math.max(-60,math.min(60,m_angEyeAngles[2]-player_index:get_anim_state().current_feet_yaw))) > possible_desync - 1 then
                        plist.set(_v, "Force body yaw", false)
                   break
               end
               
               
               
    
               local math_resolver = math.floor(math.max(-60,math.min(60,m_angEyeAngles[2]-player_index:get_anim_state().current_feet_yaw)) )

               if ui.is_menu_open() then 
                    plist.set(_v, "Force body yaw", false)
                    plist.set(_v, "Force body yaw value",0)
                    break
               end
    
               local pl_velocity = vector(entity_get_prop(_v, "m_vecVelocity"))
               if pl_velocity:length2d() < 2 then 
                   plist.set(_v, "Force body yaw", false)
                   break
               elseif not on_ground then 
                   math_resolver = math_resolver / 2
               elseif player_index:get_anim_state().duck_amount > 0.5 then 
                   math_resolver = math_resolver / 2
               elseif math_resolver == 60 or math_resolver == -60 then 
                   plist.set(_v, "Force body yaw", false)
                   break
               end
    
               plist.set(_v, "Force body yaw", true)
               plist.set(_v, "Force body yaw value",math_resolver)

            
        end

    else
        if resolver_status == true then 

            for k,_v in ipairs(entity.get_players(true)) do 
                plist.set(_v, "Force body yaw", false)
                plist.set(_v, "Force body yaw value",0)
            end

            resolver_status = false
        end
    end
end


client_set_event_callback("player_death", function(ctx)
    if client.userid_to_entindex(ctx.userid) ~=  entity_get_local_player() and client.userid_to_entindex(ctx.attacker) == entity_get_local_player() and ui_get(menu["misc"].kill_say) ~= "Off" then
        client.exec("say " .. functions["misc"].kill_say[ui_get(menu["misc"].kill_say)][client.random_int(1, #functions["misc"].kill_say[ui_get(menu["misc"].kill_say)])])
    end
end)

local function str_to_sub(input, sep)
    local t = {}
    for str in string.gmatch(input, "([^"..sep.."]+)") do
        t[#t + 1] = string.gsub(str, "\n", "")
    end
    return t
end

local function to_boolean(str)
    if str == "true" or str == "false" then
        return (str == "true")
    else
        return str
    end
end

 local filesystem = {}
 local a = { { 'remove_search_path', '\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x8B\xD9', 'void(__thiscall*)(void*, const char*, const char*)' }, { 'remove_file', '\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8D\x85\xCC\xCC\xCC\xCC\x56\x50\x8D\x45\x0C', 'void(__thiscall*)(void*, const char*, const char*)' }, { 'find_next', '\x55\x8B\xEC\x83\xEC\x0C\x53\x8B\xD9\x8B\x0D\xCC\xCC\xCC\xCC', 'const char*(__thiscall*)(void*, int)' }, { 'find_is_directory', '\x55\x8B\xEC\x0F\xB7\x45\x08', 'bool(__thiscall*)(void*, int)' }, { 'find_close', '\x55\x8B\xEC\x53\x8B\x5D\x08\x85', 'void(__thiscall*)(void*, int)' }, { 'find_first', '\x55\x8B\xEC\x6A\x00\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08\xE8\xCC\xCC\xCC\xCC\x5D', 'const char*(__thiscall*)(void*, const char*, const char*, int*)' }, { 'get_current_directory', '\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF\x75\x0C', 'bool(__thiscall*)(void*, char*, int)' } }
 local function c(d, e, f, g)
     local h = client.create_interface(d, e) or error("invalid interface", 2)
     local i = client.find_signature(d, f) or error("invalid signature", 2)
     local j, k = pcall(ffi.typeof, g)
     if not j then
         error(k, 2)
     end ;
     local l = ffi.cast(k, i) or error("invalid typecast", 2)
     return function(...)
         return l(h, ...)
     end
 end;
 for m = 1, #a do
     local n = a[m]
     filesystem[n[1]] = c('filesystem_stdio.dll', 'VFileSystem017', n[2], n[3])
 end
 
 local add_to_searchpath = vtable_bind("filesystem_stdio.dll", "VFileSystem017", 11, "void(__thiscall*)(void*, const char*, const char*, int)");
 
 
 local oldLength = -1;
 local searchpath_key = "SAM_SOUND_BOARD";
 local gamePath = ffi.typeof("char[128]")();
 filesystem.get_current_directory(gamePath, ffi.sizeof(gamePath))
 local soundPath = string.format('%s', ffi.string(gamePath))
 add_to_searchpath(soundPath, searchpath_key, 0);
 found = false
 local function get_configs()
     local found_files, fileHandle = {}, ffi.typeof("int[1]")()
     local fileNamePtr = filesystem.find_first("*", searchpath_key, fileHandle);
 
     while (fileNamePtr ~= nil) do
         local fileName = ffi.string(fileNamePtr)
         if (not filesystem.find_is_directory(fileHandle[0]) and fileName:find('_gs.txt')) then
             found_files[#found_files + 1] = fileName;
         end
         fileNamePtr = filesystem.find_next(fileHandle[0]);
     end
 
     filesystem.find_close(fileHandle[0]);
     return found_files
 end
 
local config_texiste = ui_new_label(tab,container, "Config system")
 
local sounds = ui.new_listbox(tab,container, "config_board", "...")

local new_text = ui.new_textbox(tab,container,"config box")


local function update_cfg()

    if ui_menu.selected_tab == ui_menu.easier_tab.config and ui.is_menu_open() then
      
        local newSounds = get_configs()
        local new = {}
        for i = 1, #newSounds do
            new[i] = newSounds[i]:gsub('_gs.txt', '')
        end
        return new;
    end
end

local create_file = ui.new_button(tab,container, "Create config", function()
    writefile(tostring(ui_get(new_text) .. "_gs.txt"),"paste config in file")
end)

local remove_file = ui.new_button(tab, container, "Delete config", function()
	filesystem.remove_file(soundPath .. '/' .. get_configs()[ui_get(sounds) + 1],get_configs()[ui_get(sounds) + 1]);
end)

local save_file_cfg = ui.new_button(tab,container, "Save config", function()


    local str = ""

    for k,v in ipairs(menu["anti-aim"].anti_aim_states) do

	
		str = str
		.. tostring(ui_get(menu["anti-aim"].builder[v].enable)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].anti_backstab)) .. "|"
		.. tostring(ui_get(menu["anti-aim"].builder[v].pitch)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].pitch_custom)) .. "|"
		.. tostring(ui_get(menu["anti-aim"].builder[v].yaw_base)) .. "|"
        if v ~= "Manual" then
            str = str .. tostring(ui_get(menu["anti-aim"].builder[v].yaw)) .. "|"
            .. tostring(ui_get(menu["anti-aim"].builder[v].random_flick)) .. "|"
            .. tostring(ui_get(menu["anti-aim"].builder[v].delay_custom)) .. "|"
            .. tostring(ui_get(menu["anti-aim"].builder[v].yaw_custom2)) .. "|"
        end
		str = str .. tostring(ui_get(menu["anti-aim"].builder[v].yaw_custom)) .. "|"
		.. tostring(ui_get(menu["anti-aim"].builder[v].yaw_jitter)) .. "|"
		.. tostring(ui_get(menu["anti-aim"].builder[v].yaw_jitter_custom)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].body_yaw)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].body_yaw_custom)) .. "|"

        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_enable)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_force)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_tick_stopper)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_choke)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_pitch)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_pitch_custom)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_yaw)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_yaw_custom)) .. "|"
    end

    clipboard.set(base64.encode(str,'base64'))
    database.write("current_clip_board_to_save",base64.encode(str, 'base64'))
    read_data = database.read("current_clip_board_to_save")
    writefile(get_configs()[ui_get(sounds) + 1],read_data)
end)

local load_cfg = ui.new_button(tab,container, "Load config", function()

    local tbl = str_to_sub(base64.decode(readfile(get_configs()[ui_get(sounds) + 1]), 'base64'), "|")
    local crescente = 1

    for k,v in ipairs(menu["anti-aim"].anti_aim_states) do

      
       
        ui_set(menu["anti-aim"].builder[v].enable, to_boolean(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].anti_backstab, to_boolean(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].pitch, tostring(tbl[crescente]))
        crescente = crescente + 1
		ui_set(menu["anti-aim"].builder[v].pitch_custom, tonumber(tbl[crescente]))
        crescente = crescente + 1
		ui_set(menu["anti-aim"].builder[v].yaw_base, tostring(tbl[crescente]))
        crescente = crescente + 1

        if v ~= "Manual" then 
            ui_set(menu["anti-aim"].builder[v].yaw, tostring(tbl[crescente]))
            crescente = crescente + 1
            ui_set(menu["anti-aim"].builder[v].random_flick, to_boolean(tbl[crescente]))
            crescente = crescente + 1 
            ui_set(menu["anti-aim"].builder[v].delay_custom, tonumber(tbl[crescente]))
            crescente = crescente + 1 
            ui_set(menu["anti-aim"].builder[v].yaw_custom2, tonumber(tbl[crescente]))
            crescente = crescente + 1
        end

		ui_set(menu["anti-aim"].builder[v].yaw_custom, tonumber(tbl[crescente]))
        crescente = crescente + 1

		ui_set(menu["anti-aim"].builder[v].yaw_jitter, tostring(tbl[crescente]))
        crescente = crescente + 1
		ui_set(menu["anti-aim"].builder[v].yaw_jitter_custom, tonumber(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].body_yaw, tostring(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].body_yaw_custom, tonumber(tbl[crescente]))
        crescente = crescente + 1

        ui_set(menu["anti-aim"].builder[v].defensive_enable, to_boolean(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].defensive_force, to_boolean(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].defensive_tick_stopper, tonumber(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].defensive_choke, to_boolean(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].defensive_pitch, tostring(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].defensive_pitch_custom, tonumber(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].defensive_yaw, tostring(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].defensive_yaw_custom, tonumber(tbl[crescente]))
        crescente = crescente + 1
    end

   
end)


local export_file = ui.new_button(tab,container, "Export", function()


    local str = ""

    for k,v in ipairs(menu["anti-aim"].anti_aim_states) do

      
	
		str = str
		.. tostring(ui_get(menu["anti-aim"].builder[v].enable)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].anti_backstab)) .. "|"
		.. tostring(ui_get(menu["anti-aim"].builder[v].pitch)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].pitch_custom)) .. "|"
		.. tostring(ui_get(menu["anti-aim"].builder[v].yaw_base)) .. "|"
        if v ~= "Manual" then
            str = str .. tostring(ui_get(menu["anti-aim"].builder[v].yaw)) .. "|"
            .. tostring(ui_get(menu["anti-aim"].builder[v].random_flick)) .. "|"
            .. tostring(ui_get(menu["anti-aim"].builder[v].delay_custom)) .. "|"
            .. tostring(ui_get(menu["anti-aim"].builder[v].yaw_custom2)) .. "|"
        end

		str = str .. tostring(ui_get(menu["anti-aim"].builder[v].yaw_custom)) .. "|"
		.. tostring(ui_get(menu["anti-aim"].builder[v].yaw_jitter)) .. "|"
		.. tostring(ui_get(menu["anti-aim"].builder[v].yaw_jitter_custom)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].body_yaw)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].body_yaw_custom)) .. "|"

        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_enable)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_force)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_tick_stopper)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_choke)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_pitch)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_pitch_custom)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_yaw)) .. "|"
        .. tostring(ui_get(menu["anti-aim"].builder[v].defensive_yaw_custom)) .. "|"
    end

    clipboard.set(base64.encode(str,'base64'))
end)

local import_config = ui.new_button(tab,container,"Import",function()


    local tbl = str_to_sub(base64.decode(clipboard.get(), 'base64'), "|")
    local crescente = 1
    
    for k,v in ipairs(menu["anti-aim"].anti_aim_states) do

    
      
        ui_set(menu["anti-aim"].builder[v].enable, to_boolean(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].anti_backstab, to_boolean(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].pitch, tostring(tbl[crescente]))
        crescente = crescente + 1
		ui_set(menu["anti-aim"].builder[v].pitch_custom, tostring(tbl[crescente]))
        crescente = crescente + 1
		ui_set(menu["anti-aim"].builder[v].yaw_base, tostring(tbl[crescente]))
        crescente = crescente + 1

        if v ~= "Manual" then 
            ui_set(menu["anti-aim"].builder[v].yaw, tostring(tbl[crescente]))
            crescente = crescente + 1
            ui_set(menu["anti-aim"].builder[v].random_flick, to_boolean(tbl[crescente]))
            crescente = crescente + 1
            ui_set(menu["anti-aim"].builder[v].delay_custom, tostring(tbl[crescente]))
            crescente = crescente + 1 
            ui_set(menu["anti-aim"].builder[v].yaw_custom2, tonumber(tbl[crescente]))
            crescente = crescente + 1
        end
	
		ui_set(menu["anti-aim"].builder[v].yaw_custom, tonumber(tbl[crescente]))
        crescente = crescente + 1
	
		ui_set(menu["anti-aim"].builder[v].yaw_jitter, tostring(tbl[crescente]))
        crescente = crescente + 1
		ui_set(menu["anti-aim"].builder[v].yaw_jitter_custom, tonumber(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].body_yaw, tostring(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].body_yaw_custom, tonumber(tbl[crescente]))
        crescente = crescente + 1

        ui_set(menu["anti-aim"].builder[v].defensive_enable, to_boolean(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].defensive_force, to_boolean(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].defensive_tick_stopper, tostring(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].defensive_choke, tonumber(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].defensive_pitch, tostring(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].defensive_pitch_custom, tonumber(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].defensive_yaw, tostring(tbl[crescente]))
        crescente = crescente + 1
        ui_set(menu["anti-aim"].builder[v].defensive_yaw_custom, tonumber(tbl[crescente]))
        crescente = crescente + 1
    end
      
end)

functions["menu"].visibility = function()
    if ui.is_menu_open() then

        local skeet_tab = ui_get(menu["anti-aim"].anti_aim_selector) == "Skeet"

        ui_set_visible(menu["anti-aim"].state_selector,ui_menu.selected_tab == ui_menu.easier_tab.aa)
        ui_set_visible(menu["anti-aim"].anti_aim_selector,ui_menu.selected_tab == ui_menu.easier_tab.aa)
        for k,v in ipairs(menu["anti-aim"].anti_aim_states) do 
            ui_set_visible(menu["anti-aim"].builder[v].enable,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab) 
            ui_set_visible(menu["anti-aim"].builder[v].pitch,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].pitch_custom,ui_get(menu["anti-aim"].state_selector) == v and ui_get(menu["anti-aim"].builder[v].pitch) == "Custom"and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].yaw_base,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)

            if v ~= "Manual" then
                ui_set_visible(menu["anti-aim"].builder[v].yaw,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)
                ui_set_visible(menu["anti-aim"].builder[v].random_flick,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)
                ui_set_visible(menu["anti-aim"].builder[v].delay_custom,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and (ui_get(menu["anti-aim"].builder[v].yaw) == "Slow jitter" or ui_get(menu["anti-aim"].builder[v].yaw) == "Slow 5-way") and skeet_tab)
                ui_set_visible(menu["anti-aim"].builder[v].yaw_custom2,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and (ui_get(menu["anti-aim"].builder[v].yaw) == "Slow jitter" or ui_get(menu["anti-aim"].builder[v].yaw) == "L&R") and skeet_tab)
            end

            ui_set_visible(menu["anti-aim"].builder[v].yaw_custom,ui_get(menu["anti-aim"].state_selector) == v and (v ~= "Manual" ) and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab and ui_get(menu["anti-aim"].builder[v].yaw) ~= "Off")
            ui_set_visible(menu["anti-aim"].builder[v].yaw_jitter,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].yaw_jitter_custom,ui_get(menu["anti-aim"].state_selector) == v and ui_get(menu["anti-aim"].builder[v].yaw_jitter) ~= "Off" and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].body_yaw,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].body_yaw_custom,ui_get(menu["anti-aim"].state_selector) == v and ui_get(menu["anti-aim"].builder[v].body_yaw) ~= "Off" and ui_get(menu["anti-aim"].builder[v].body_yaw) ~= "Opposite" and ui_get(menu["anti-aim"].builder[v].body_yaw) ~= "Optimized slow" and ui_get(menu["anti-aim"].builder[v].body_yaw) ~= "Optimized jitter" and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)
            
            
            
            ui_set_visible(menu["anti-aim"].builder[v].defensive_enable,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].defensive_force,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and ui_get(menu["anti-aim"].builder[v].defensive_enable) and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].defensive_tick_stopper,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and ui_get(menu["anti-aim"].builder[v].defensive_enable) and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].defensive_choke,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and ui_get(menu["anti-aim"].builder[v].defensive_enable) and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].defensive_yaw,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and ui_get(menu["anti-aim"].builder[v].defensive_enable) and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].defensive_yaw_custom,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and ui_get(menu["anti-aim"].builder[v].defensive_enable) and
            ui_get(menu["anti-aim"].builder[v].defensive_yaw) ~= "Off" and ui_get(menu["anti-aim"].builder[v].defensive_yaw) ~= "Random" and ui_get(menu["anti-aim"].builder[v].defensive_yaw) ~= "Sideways" and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].defensive_pitch,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and ui_get(menu["anti-aim"].builder[v].defensive_enable) and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].defensive_pitch_custom,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and ui_get(menu["anti-aim"].builder[v].defensive_enable) and ui_get(menu["anti-aim"].builder[v].defensive_pitch) == "Custom" and skeet_tab)
    
    
    
        end

        for k,v in ipairs(menu["anti-aim"].anti_aim_states) do 
            ui_set_visible(Venus_aa[v].enable,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and not skeet_tab) 
            ui_set_visible(Venus_aa[v].pitch,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and not skeet_tab)
           -- ui_set_visible(Venus_aa[v].pitch_custom,ui_get(menu["anti-aim"].state_selector) == v and ui_get(Venus_aa[v].pitch) == "Custom"and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)
            ui_set_visible(Venus_aa[v].yaw,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and not skeet_tab)
            ui_set_visible(Venus_aa[v].yaw_custom,ui_get(menu["anti-aim"].state_selector) == v and (v ~= "Manual" ) and ui_menu.selected_tab == ui_menu.easier_tab.aa and ui_get(Venus_aa[v].yaw) ~= "Off" and not skeet_tab)
            ui_set_visible(Venus_aa[v].yaw_jitter,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and not skeet_tab)
            ui_set_visible(Venus_aa[v].yaw_jitter_custom,ui_get(menu["anti-aim"].state_selector) == v and ui_get(Venus_aa[v].yaw_jitter) ~= "Off" and ui_menu.selected_tab == ui_menu.easier_tab.aa and not skeet_tab)
            ui_set_visible(Venus_aa[v].body_yaw,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and not skeet_tab)
            ui_set_visible(Venus_aa[v].body_yaw_custom,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and not skeet_tab)
            
    
        end
        ui_set_visible(Venus_aa.anti_backstabk,ui_menu.selected_tab == ui_menu.easier_tab.aa and ui_get(menu["anti-aim"].anti_aim_selector) == "Venus")




        ui_set_visible(menu["anti-aim"].disable_on_quickpeek,ui_menu.selected_tab == ui_menu.easier_tab.aa2  and skeet_tab)
        
        ui_set_visible(menu["anti-aim"].freestanding_disablers,ui_menu.selected_tab == ui_menu.easier_tab.aa2 and skeet_tab)
        ui_set_visible(menu["anti-aim"].anti_backstab,ui_menu.selected_tab == ui_menu.easier_tab.aa2  and skeet_tab)
        ui_set_visible(menu["anti-aim"].safe_anti_aim,ui_menu.selected_tab == ui_menu.easier_tab.aa2  and skeet_tab)
        ui_set_visible(menu["visuals"].indicator,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].indicator_scoped_animation,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].indicator) ~= "Disabled")
        ui_set_visible(menu["visuals"].indicator_color,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].indicator) == "Default")
        ui_set_visible(menu["visuals"].defensive_indicator,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].defensive_indicator_color,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].defensive_indicator))
        ui_set_visible(menu["visuals"].desync_indicator,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].desync_indicator_color,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].desync_indicator))
        ui_set_visible(menu["visuals"].slow_down_indicator,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].turtle_slow,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].slow_down_indicator))
        ui_set_visible(menu["visuals"].slow_down_indicator_color,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].slow_down_indicator))
        ui_set_visible(menu["visuals"].minimum_damage_indicator,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].manual_anti_aim_indicators,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].ot_watermark,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].spectator_ot,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].manual_anti_aim_indicators_color,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].manual_anti_aim_indicators))
        ui_set_visible(menu["visuals"].player_esp,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].zeus_esp,ui_menu.selected_tab == ui_menu.easier_tab.visuals and table_contains(ui_get(menu["visuals"].player_esp),"Zeus esp"))
        ui_set_visible(menu["visuals"].target_color,ui_menu.selected_tab == ui_menu.easier_tab.visuals and table_contains(ui_get(menu["visuals"].player_esp),"At target flag"))
        ui_set_visible(menu["visuals"].target_label,ui_menu.selected_tab == ui_menu.easier_tab.visuals and table_contains(ui_get(menu["visuals"].player_esp),"At target flag"))
        ui_set_visible(menu["visuals"].zeus_indicator_color,ui_menu.selected_tab == ui_menu.easier_tab.visuals and table_contains(ui_get(menu["visuals"].player_esp),"Zeus esp") and table_contains(ui_get(menu["visuals"].zeus_esp),"Flag"))


        ui_set_visible(menu["misc"].local_animations,ui_menu.selected_tab == ui_menu.easier_tab.misc)
        ui_set_visible(menu["misc"].resolver,ui_menu.selected_tab == ui_menu.easier_tab.misc)
        ui_set_visible(menu["misc"].safe_point,ui_menu.selected_tab == ui_menu.easier_tab.misc)
        ui_set_visible(menu["misc"].fps_boost,ui_menu.selected_tab == ui_menu.easier_tab.misc)
        ui_set_visible(menu["misc"].kill_say,ui_menu.selected_tab == ui_menu.easier_tab.misc)
        ui_set_visible(menu["misc"].sunset_mode,ui_menu.selected_tab == ui_menu.easier_tab.misc)
        ui_set_visible(menu["misc"].show_keybinds, ui_menu.selected_tab == ui_menu.easier_tab.aa2)
        ui_set_visible(menu["misc"].manual_r,ui_menu.selected_tab == ui_menu.easier_tab.aa2 and ui_get(menu["misc"].show_keybinds))
        ui_set_visible(menu["misc"].manual_b,ui_menu.selected_tab == ui_menu.easier_tab.aa2 and ui_get(menu["misc"].show_keybinds))
        ui_set_visible(menu["misc"].manual_l,ui_menu.selected_tab == ui_menu.easier_tab.aa2 and ui_get(menu["misc"].show_keybinds))
        ui_set_visible(menu["misc"].manual_f,ui_menu.selected_tab == ui_menu.easier_tab.aa2 and ui_get(menu["misc"].show_keybinds))
        ui_set_visible(menu["misc"].freestanding,ui_menu.selected_tab == ui_menu.easier_tab.aa2 and ui_get(menu["misc"].show_keybinds))
        ui_set_visible(menu["misc"].aim_logs,ui_menu.selected_tab == ui_menu.easier_tab.misc)
        ui_set_visible(menu["misc"].aim_logs_hit_color,ui_menu.selected_tab == ui_menu.easier_tab.misc and ui_get(menu["misc"].aim_logs))
        ui_set_visible(menu["misc"].aim_logs_miss_color,ui_menu.selected_tab == ui_menu.easier_tab.misc and ui_get(menu["misc"].aim_logs))
        ui_set_visible(menu["misc"].aim_logs_hit_label,ui_menu.selected_tab == ui_menu.easier_tab.misc and ui_get(menu["misc"].aim_logs))
        ui_set_visible(menu["misc"].aim_logs_miss_label,ui_menu.selected_tab == ui_menu.easier_tab.misc and ui_get(menu["misc"].aim_logs))
        ui_set_visible(menu["misc"].print_logs,ui_menu.selected_tab == ui_menu.easier_tab.misc)
        ui_set_visible(menu["misc"].old_logs,ui_menu.selected_tab == ui_menu.easier_tab.misc)

        ui_set_visible(import_config,ui_menu.selected_tab == ui_menu.easier_tab.config)
        ui_set_visible(export_file,ui_menu.selected_tab == ui_menu.easier_tab.config)
        ui_set_visible(config_texiste,ui_menu.selected_tab == ui_menu.easier_tab.config)
        ui_set_visible(load_cfg,ui_menu.selected_tab == ui_menu.easier_tab.config)
        ui_set_visible(sounds,ui_menu.selected_tab == ui_menu.easier_tab.config)
        ui_set_visible(new_text,ui_menu.selected_tab == ui_menu.easier_tab.config)
        ui_set_visible(create_file,ui_menu.selected_tab == ui_menu.easier_tab.config)
        ui_set_visible(remove_file,ui_menu.selected_tab == ui_menu.easier_tab.config)
        ui_set_visible(save_file_cfg,ui_menu.selected_tab == ui_menu.easier_tab.config)



        ui_set_visible(menu_reference.enabled,false)
        ui_set_visible(menu_reference.pitch[1],false)
        ui_set_visible(menu_reference.pitch[2],false)
        ui_set_visible(menu_reference.yawbase,false)
        ui_set_visible(menu_reference.yaw[1],false)
        ui_set_visible(menu_reference.yaw[2],false)
        ui_set_visible(menu_reference.yawjitter[1],false)
        ui_set_visible(menu_reference.yawjitter[2],false)
        ui_set_visible(menu_reference.bodyyaw[1],false)
        ui_set_visible(menu_reference.bodyyaw[2],false)
        ui_set_visible(menu_reference.roll,false)
        ui_set_visible(menu_reference.freestand[1],false)
        ui_set_visible(menu_reference.freestand[2],false)
        ui_set_visible(menu_reference.freestand_body[1],false)
        ui_set_visible(menu_reference.edgeyaw,false)
    end
end

local has_checked = false
local function main_paint()

    local w,h = client.screen_size()

    if engineclient.is_in_game() then 
        get_bots_players()

        functions["visuals"].spectators_ot(w,h)
        functions["visuals"].onetap_watermark(w,h)
        functions["visuals"].crosshair_indicator(w,h)
        functions["visuals"].simple_crosshair_indicators(w,h)
        functions["visuals"].desync_indicator(w,h)
        functions["visuals"].slow_down_indicator(w,h)
        functions["visuals"].minimum_damage_indicator(w,h)
        functions["visuals"].manual_anti_aim_indicators(w,h)
        functions["visuals"].aim_logs(w,h)
        functions["visuals"].zeus_indicator() 
        functions["visuals"].zeus_out_of_view()
        functions["visuals"].old_logs(w,h)
    end

    if ui.get(menu["misc"].fps_boost) and has_checked == false then 
        functions["visuals"].fps_boost(0)
        has_checked = true 
    elseif not ui.get(menu["misc"].fps_boost) and has_checked == true then 
        functions["visuals"].fps_boost(1)
        has_checked = false
    end

    functions["visuals"].defensive_indicator(w,h)
    functions["misc"].sunset()

    if functions["anti-aim"].sim_time < 0 then
        functions["anti-aim"].sim_tick=globals_tickcount()
    end

    functions["misc"].resolver()

    logs.three = {}

end

local function main_paint_ui()
    ui_menu.is_aa_tab()
    ui_menu.new_tab()
    ui_menu.outside_bar()
    functions["menu"].visibility()

    if not engineclient.is_in_game() then 
        functions["visuals"].is_defensive = false
    end

    if ui.is_menu_open() and ui_menu.selected_tab == ui_menu.easier_tab.config then
        ui.update(sounds,update_cfg())
    end
end

local function main_setup(cmd)
    if ui_get(menu["anti-aim"].anti_aim_selector) == "Skeet" then
        functions["anti-aim"].anti_aim_setup(cmd)
    else
        functions["anti-aim"].venus_anti_aim(cmd)
    end

    if ui_menu.is_hovered then
        cmd.in_attack = false
    end

end

local function main_pre_render()
    functions["misc"].local_animations()
end

local function main_shutdown()
    ui_set_visible(menu_reference.enabled,true)
    ui_set_visible(menu_reference.pitch[1],true)
    ui_set_visible(menu_reference.pitch[2],true)
    ui_set_visible(menu_reference.yawbase,true)
    ui_set_visible(menu_reference.yaw[1],true)
    ui_set_visible(menu_reference.yaw[2],true)
    ui_set_visible(menu_reference.yawjitter[1],true)
    ui_set_visible(menu_reference.yawjitter[2],true)
    ui_set_visible(menu_reference.bodyyaw[1],true)
    ui_set_visible(menu_reference.bodyyaw[2],true)
    ui_set_visible(menu_reference.roll,true)
    ui_set_visible(menu_reference.freestand[1],true)
    ui_set_visible(menu_reference.freestand[2],true)
    ui_set_visible(menu_reference.freestand_body[1],true)
    ui_set_visible(menu_reference.edgeyaw,true)

    if resolver_status == true then 
        for k,_v in ipairs(entity.get_players(true)) do 
            plist.set(_v, "Force body yaw", false)
            plist.set(_v, "Force body yaw value",0)
        end
    end

    if functions["misc"].sunset_active == true then
        local sun_prop = entity.get_all('CCascadeLight')[1]
        entity.set_prop(sun_prop,"m_envLightShadowDirection",functions["misc"].old_sun.x,functions["misc"].old_sun.y,functions["misc"].old_sun.z)
    end

    if has_checked then 
        functions["visuals"].fps_boost(1)
    end
end

client_set_event_callback("bomb_exploded",function()
    functions["anti-aim"].bomb_was_bombed = true
end)

client_set_event_callback("bomb_defused",function()
    functions["anti-aim"].bomb_was_defused = true
end)

client_set_event_callback("round_start",function()
    functions["anti-aim"].bomb_was_defuse=false
    functions["anti-aim"].bomb_was_bombed=false
    miss_sp = {}
end)

client.set_event_callback("net_update_end", functions["misc"].safe_point)
client_set_event_callback("paint", main_paint)
client_set_event_callback("paint_ui", main_paint_ui)
client_set_event_callback("pre_render", main_pre_render)
client_set_event_callback("setup_command", main_setup)
client_set_event_callback("shutdown", main_shutdown)