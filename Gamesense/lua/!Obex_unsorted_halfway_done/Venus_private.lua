-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local ui_new_combobox,ui_new_checkbox,ui_new_multiselect,ui_new_label,ui_new_color_picker,ui_reference,ui_get,ui_set,ui_set_visible,entity_get_prop,client_set_event_callback,renderer_text,renderer_rectangle,ui_menu_size,ui_menu_position,ui_mouse_position,
renderer_gradient,renderer_measure_text,renderer_texture,ui_new_slider,ui_new_hotkey,entity_get_classname,entity_get_origin,globals_tickcount,entity_get_local_player,entity_is_dormant,client_screen_size,entity_is_alive,ui_new_button,entity_is_enemy =  
ui.new_combobox,ui.new_checkbox,ui.new_multiselect,ui.new_label,ui.new_color_picker,ui.reference,ui.get,ui.set,ui.set_visible,entity.get_prop,client.set_event_callback,renderer.text,renderer.rectangle,ui.menu_size,ui.menu_position,
ui.mouse_position,renderer.gradient,renderer.measure_text,renderer.texture,ui.new_slider,ui.new_hotkey,entity.get_classname,entity.get_origin,globals.tickcount,entity.get_local_player,entity.is_dormant,client.screen_size,entity.is_alive,ui.new_button,entity.is_enemy





local anti_aim_funcs = require ("gamesense/antiaim_funcs") or error("Failed to retrieve antiaim_funcs | https://gamesense.pub/forums/viewtopic.php?id=29665")
local ent_lib = require "gamesense/entity" or error("Failed to load entity | https://gamesense.pub/forums/viewtopic.php?id=27529")
local clipboard = require("gamesense/clipboard") or error("Failed to load clipboard | https://gamesense.pub/forums/viewtopic.php?id=28678")
local base64 = require("gamesense/base64") or error("Failed to load base64 | https://gamesense.pub/forums/viewtopic.php?id=21619")
local trace = require "gamesense/trace" or error("Failed to load trace")
local obex_data = obex_fetch and obex_fetch() or {username = 'preto', build = 'Live', discord=''}
local vector = require "vector"
local ffi = require "ffi"

local tab,container = "AA","Anti-aimbot angles"

LPH_NO_VIRTUALIZE = function(...) return ... end

local menu = {
    ["main"] = {
        welcome_label = ui.new_label(tab, container, "Welcome to ven\a96E631FFus\affffffff.")
    },

    ["anti-aim"] = {
        anti_aim_states = {"Global","Manual","Standing","Moving","Ducking","Duck moving","Slow walking","Jumping","Duck jumping","Legit","Fakelag","Height advantage"},
        anti_aim_selector = ui_new_combobox(tab, container, "Anti-aim type selector", {"Skeet","Venus"}),
        state_selector = ui_new_combobox(tab, container, "Anti-aim state", {"Global","Manual","Standing","Moving","Ducking","Duck moving","Slow walking","Jumping","Duck jumping","Legit","Fakelag","Height advantage"}),
        anti_backstab=ui_new_checkbox(tab, container, "Anti backstab"),
        safe_anti_aim=ui_new_checkbox(tab, container, "Safe Zeus / Knife"),
        disable_on_quickpeek=ui_new_checkbox(tab, container, "Disable force defensive on quickpeek"),
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
        minimum_damage_indicator=ui_new_checkbox(tab, container, "Minimum damage indicator"),
        manual_anti_aim_indicators=ui_new_checkbox(tab, container, "Manual anti-aim indicator"),
        mi_type=ui_new_combobox(tab, container, "Manual anti-aim indicator style",{"Default","Simple","Modern"}),
        manual_anti_aim_indicators_color=ui_new_color_picker(tab, container, "Manual anti-aim indicator color", 255,50,50,255),
        ot_watermark=ui_new_checkbox(tab, container, "Watermark"),
        watermark_logo=ui_new_checkbox(tab, container, "Watermark - logo"),
        watermark_spacing=ui_new_slider(tab, container, "Watermark - logo spacing", 0,20 ,0, true),
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
        fast_ladder_box = ui_new_checkbox(tab,container,"Fast ladder"),
        ladder_yaw_slider = ui_new_slider(tab,container, "Ladder angle", -180, 180, 0),
        show_keybinds=ui_new_checkbox(tab, container, "Show keybinds"),
        manual_r=ui_new_hotkey(tab, container, "Manual right"),
        manual_l=ui_new_hotkey(tab, container, "Manual left"),
        manual_f=ui_new_hotkey(tab, container, "Manual forward"),
        manual_b=ui_new_hotkey(tab, container, "Manual reset"),
        freestanding=ui_new_hotkey(tab, container, "Freestanding"),
        sunset_mode=ui_new_checkbox(tab, container, "Night mode"),
        aim_logs=ui_new_checkbox(tab, container, "Screen logs"),
        aim_logo=ui_new_checkbox(tab, container, "Logs - Logo"),
        logo_slider=ui_new_slider(tab, container, "Logs - Logo spacing", 0,15 ,0, true),
        aim_logs_hit_label=ui_new_label(tab, container, "Logs - Hit color"),
        aim_logs_hit_color=ui_new_color_picker(tab, container, "Hitez color",150,230,49,255),
        aim_logs_miss_label=ui_new_label(tab, container, "Logs - Miss logs"),
        aim_logs_miss_color=ui_new_color_picker(tab, container, "Missez color",255,0,0,255),
        old_logs=ui_new_multiselect(tab, container, "Old logs", {"aim_hit","aim_miss","item_purchase","bullet_impact"}),
        kill_say=ui_new_combobox(tab, container, "Kill say", {"Off","Main","Artists"}),
        local_animations=ui_new_multiselect(tab, container, "Anims",{"Static legs in air","Jitter legs","Crossing legs","Pitch 0 on land","Flashed","Victim"} ),
    },

    ["extras"] = {
        text = ui_new_checkbox("LUA","B","Icon_extra"),
        icon = ui_new_checkbox("LUA","B","text_exetra"),
        gradient = ui_new_checkbox("LUA","B","gradient_extras"),
        length=ui_new_slider("LUA","B", "legfnth_Extra", 20,150 ,100, true),
        width=ui_new_slider("LUA","B", "width_extra", 1,15 ,4, true),
        text1 = ui_new_checkbox("LUA","B","Icon_extra1"),
        icon1 = ui_new_checkbox("LUA","B","text_exetra1"),
        gradient1 = ui_new_checkbox("LUA","B","gradient_extras1"),
        dynamic = ui_new_checkbox("LUA","B","dynamic_extras1"),
        length1=ui_new_slider("LUA","B", "legfnth_Extra1", 20,150 ,100, true),
        width1=ui_new_slider("LUA","B", "width_extra1", 1,15 ,4, true),
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
}

local mx,my = client_screen_size()

local dbs = {
    defensive_x = database.read("def_indicator_x") or mx / 2, 
    defensive_y = database.read("def_indicator_y") or my / 2 - 100,
    slow_x = database.read("slow_indicator_x") or mx / 2, 
    slow_y = database.read("slow_indicator_y") or my / 2 - 200,
    is_dragging = false,
    defensive_menu = false,
    slow_menu = false,
    size = 0,
    should_drag = false,
    last_item = "Defensive",
    not_last_item = "Slow",
}


for k,v in ipairs(menu["anti-aim"].anti_aim_states) do 
    menu["anti-aim"].builder[v] = {}
    menu["anti-aim"].builder[v].enable = ui_new_checkbox(tab, container, "Enable - " .. v)
    menu["anti-aim"].builder[v].pitch = ui_new_combobox(tab, container, "Pitch" .. "\n" .. v, {"Off","Down","Minimal","Custom"})
    menu["anti-aim"].builder[v].pitch_custom = ui_new_slider(tab, container, "Custom".. "\n" .. v, -89, 89, 0, true, "º")
    menu["anti-aim"].builder[v].yaw_base = ui_new_combobox(tab, container, "Yaw base".. "\n" .. v, {"Local view","At targets"})

    if v ~= "Manual" then 
        menu["anti-aim"].builder[v].yaw=ui_new_combobox(tab, container, "Yaw".. "\n" .. v, {"Off","180","Static","180 Z"})
        menu["anti-aim"].builder[v].random_flick=ui_new_checkbox(tab, container, "Random flick\n" .. v)
    end
    menu["anti-aim"].builder[v].yaw_custom = ui_new_slider(tab, container, "Yaw\n nigga" .. v, -180, 180, 0, true, "º")
    menu["anti-aim"].builder[v].yaw_jitter = ui_new_combobox(tab, container, "Yaw jitter".. "\n" .. v, {"Off","Offset","Center","Random","Skitter","Slow jitter","L&R","Slow 5-way","50/50"})
    
    if v ~= "Manual" then 
        menu["anti-aim"].builder[v].delay_custom = ui_new_slider(tab, container, "Delayº\n" .. v, 1, 20, 0, true, "t")
        menu["anti-aim"].builder[v].yaw_jitter2=ui_new_slider(tab, container, "Yaw jitter right\n".. v, -180, 180, 0, true, "º")
    end
    menu["anti-aim"].builder[v].yaw_jitter_custom = ui_new_slider(tab, container, "Yaw jitter left\n jitter" .. v, -180, 180, 0, true, "º")

    menu["anti-aim"].builder[v].body_yaw = ui_new_combobox(tab, container, "Body yaw".. "\n" .. v, {"Off","Opposite","Jitter","Static","Optimized slow","Optimized jitter","YawV2"})
    menu["anti-aim"].builder[v].body_yaw_custom = ui_new_slider(tab, container, "\n custom" .. v, -180, 180, 0, true, "º")

    menu["anti-aim"].builder[v].defensive_enable = ui_new_checkbox(tab, container, "Enable \a96e631ffdefensive \n" .. v)
    menu["anti-aim"].builder[v].defensive_tick_stopper = ui_new_slider(tab, container, "Ticks".. "\n defensive" .. v, 2, 18, 0, true, "º")
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
    selected_tab = "Main",
    easier_tab = {aa="Anti-aim",aa2="Extras",visuals="Visuals",misc="Misc",config="Config",main="Main"},
}

ui_menu.aa =ui_new_button(tab, container, "• Anti-aim", function()
    ui_menu.selected_tab = ui_menu.easier_tab.aa
end)

ui_menu.aa2 = ui_new_button(tab, container, "• Extras", function()
    ui_menu.selected_tab = ui_menu.easier_tab.aa2
end)

ui_menu.visuals = ui_new_button(tab, container, "• Visuals", function()
    ui_menu.selected_tab = ui_menu.easier_tab.visuals
end)

ui_menu.misc = ui_new_button(tab, container, "• Misc", function()
    ui_menu.selected_tab = ui_menu.easier_tab.misc
end)

ui_menu.cfg = ui_new_button(tab, container, "• Config", function()
    ui_menu.selected_tab = ui_menu.easier_tab.config
end)


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

local rounded_rectangle = function(x, y, w, h, r, g, b, a, radius, thickness)
    y = y + radius
    local data_circle = {
        {x + radius, y, 180},
        {x + w - radius, y, 270},
        {x + radius, y + h - radius * 2, 90},
        {x + w - radius, y + h - radius * 2, 0},
    }

    local data = {
        {x + radius, y - radius, w - radius * 2, thickness},
        {x + radius, y + h - radius - thickness, w - radius * 2, thickness},
        {x, y, thickness, h - radius * 2},
        {x + w - thickness, y, thickness, h - radius * 2},
    }

    for _, data in next, data_circle do
        renderer.circle_outline(data[1], data[2], r, g, b, a, radius, data[3], 0.25, thickness)
    end

    for _, data in next, data do
        renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
    end
end

local round_rectangle = function(x, y, w, h, r, g, b, a, thickness)
    renderer_rectangle(x, y, w, h, r, g, b, a)
    renderer.circle(x, y, r, g, b, a, thickness, -180, 0.25)
    renderer.circle(x + w, y, r, g, b, a, thickness, 90, 0.25)
    renderer_rectangle(x, y - thickness, w, thickness, r, g, b, a)
    renderer.circle(x + w, y + h, r, g, b, a, thickness, 0, 0.25)
    renderer.circle(x, y + h, r, g, b, a, thickness, -90, 0.25)
    renderer_rectangle(x, y + h, w, thickness, r, g, b, a)
    renderer_rectangle(x - thickness, y, thickness, h, r, g, b, a)
    renderer_rectangle(x + w, y, thickness, h, r, g, b, a)
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

local intersect = function(x, y, w, h)
    local cx, cy = ui.mouse_position()
    return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end


local prev_simulation_time = 0
functions["anti-aim"].sim_diff = function()

    if entity_get_local_player() == nil then 
        return 
    end


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

    local defusing = bomb_distance <= 80 and nTeam == 3 and functions["anti-aim"].bomb_was_bombed == false and functions["anti-aim"].bomb_was_defused == false

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

        if globals.tickcount() >= functions["anti-aim"].sim_tick + 10 then 
            return
        end

        --cmd.allow_send_packet = ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].defensive_choke)
       

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


local yaw_difference = function(max,min,current) 

    local current_x = nil
    if current > max then 
        current_x = max - current 
    elseif current < min then 
        current_x = min - current
    end

    if current_x == nil then 
        return current
    else
        return current_x > 0 and 180 - current_x or -180 - current_x
    end
end

local opti_jitter = false
local random_flick = client.random_int(12, 64)
local current_slow_tick = 0
local old_state = "Standing"
local five_way_jitter_idx = 1
local five_way_current_tick = 0
local randomized_50 = 1
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

            randomized_50 = client.random_int(1, 2)

            if globals_tickcount() >= current_slow_tick + ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].delay_custom) then
                current_slow_tick = globals_tickcount()
                functions["anti-aim"].side = not functions["anti-aim"].side
            elseif globals_tickcount() + ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].delay_custom) < current_slow_tick then 
                current_slow_tick = globals_tickcount()
            end
            
            opti_jitter = not opti_jitter
            
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

        ui_set(menu_reference.yaw[1],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw))
        ui_set(menu_reference.yaw[2],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_custom))
        

        if ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter) == "Slow jitter" then 
            local super_math = ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_custom)

            local triple_math = super_math + (functions["anti-aim"].side == true and ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter2) or ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter_custom))

            ui_set(menu_reference.yawjitter[1],"Off")
            ui_set(menu_reference.yaw[2], yaw_difference(180,-180,triple_math))
        elseif ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter) == "L&R" then

            local super_math = ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_custom)

            local triple_math =     super_math + (functions["anti-aim"].body == false and ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter2) or ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter_custom))

            ui_set(menu_reference.yawjitter[1],"Off")
            ui_set(menu_reference.yaw[2], yaw_difference(180,-180,triple_math))
        elseif ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter) == "Slow 5-way" then 
           
            ui_set(menu_reference.yawjitter[1],"Off")
            ui_set(menu_reference.yaw[2],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter_custom) * functions["anti-aim"].five_way[five_way_jitter_idx])
        elseif ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter) == "50/50" then 

            local super_math = ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_custom)

            local value_50 = randomized_50 == 1 and true or false
            local triple_math = super_math + ( value_50 == true and ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter2) or ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter_custom))

            ui_set(menu_reference.yawjitter[1],"Off")
            ui_set(menu_reference.yaw[2], yaw_difference(180,-180,triple_math))
        else
            
            ui_set(menu_reference.yawjitter[1],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter))
            ui_set(menu_reference.yawjitter[2],ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw_jitter_custom))
        end

    end

    if functions["anti-aim"].anti_aim_state ~= "Manual" and ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].yaw) ~= "Off" and ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].random_flick) and globals_tickcount() % random_flick == 1 then 
        ui_set(menu_reference.yaw[1],"180")
        ui_set(menu_reference.yaw[2],client.random_int(-180, 180))
        random_flick=client.random_int(12, 64)
    end
 

    

    if ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].body_yaw) == "Optimized slow" then 
        ui_set(menu_reference.bodyyaw[1],"Static")
        ui_set(menu_reference.bodyyaw[2],functions["anti-aim"].side == true and 115 or -115)
    elseif ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].body_yaw) == "Optimized jitter" then
        ui_set(menu_reference.bodyyaw[1],"Jitter")
        ui_set(menu_reference.bodyyaw[2],ui_get(menu_reference.yaw[2]))
    elseif ui_get(menu["anti-aim"].builder[functions["anti-aim"].anti_aim_state].body_yaw) == "YawV2" then
        ui_set(menu_reference.bodyyaw[1],"Static")
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
    if ui_get(menu["anti-aim"].anti_backstab) then
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

local mi_type = {
    ["Default"] = { right="⯈",
    left="⯇",
    }, 

    ["Simple"] = {right=">",
    left="< "
    },
}

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


    if ui_get(menu["visuals"].mi_type) ~= "Modern" then 
        -- right arrow
        renderer_text(w/2+50,h/2,right_color.r,right_color.g,right_color.b,right_color.a,"c+-",nil,mi_type[ui_get(menu["visuals"].mi_type)].right)

        -- left arrow
        renderer_text(w/2-50,h/2,left_color.r,left_color.g,left_color.b,left_color.a,"c+-",nil,mi_type[ui_get(menu["visuals"].mi_type)].left)
    else

        renderer.triangle(w/2+50, h / 2 - 5, w/2+60, h / 2 , w/2+50, h / 2 + 5, right_color.r,right_color.g,right_color.b,100)
        renderer.line(w/2+50, h / 2 + 5, w/2 + 60, h / 2 , right_color.r,right_color.g,right_color.b,right_color.a)
        renderer.line(w/2+50, h / 2 - 5, w/2 + 60, h / 2 , right_color.r,right_color.g,right_color.b,right_color.a)
        renderer.line(w/2+50, h / 2 + 5, w/2 + 50, h / 2 - 5, right_color.r,right_color.g,right_color.b,right_color.a)

        renderer.triangle(w/2-50, h / 2 - 5, w/2-60, h / 2 , w/2-50, h / 2 + 5, left_color.r,left_color.g,left_color.b,100)
        renderer.line(w/2-50, h / 2 + 5, w/2 - 60, h / 2 , left_color.r,left_color.g,left_color.b,left_color.a)
        renderer.line(w/2-50, h / 2 - 5, w/2 - 60, h / 2 , left_color.r,left_color.g,left_color.b,left_color.a)
        renderer.line(w/2-50, h / 2 + 5, w/2 - 50, h / 2 - 5, left_color.r,left_color.g,left_color.b,left_color.a)
    end
end

local shield_svg = '<svg width="800" height="800" viewBox="0 0 24 24" fill="#fff" xmlns="http://www.w3.org/2000/svg"><path d="M5 7c0-.276.225-.499.498-.535 2.149-.28 5.282-2.186 6.224-2.785a.516.516 0 0 1 .556 0c.942.599 4.075 2.504 6.224 2.785.273.036.498.259.498.535v4.75c0 6.5-7 8.75-7 8.75s-7-2.25-7-8.75V7Z" fill="white"/></svg>'
local load_shield = renderer.load_svg(shield_svg, 200, 200)


local should_shoot = false
functions["visuals"].defensive_open = function(w,h)

    if ui.is_menu_open() and ui_get(menu["visuals"].defensive_indicator) then 

        local cx,cy = ui.mouse_position()

        if dbs.is_dragging and not client.key_state(0x01) then 
            dbs.is_dragging = false 
        end
    
        if dbs.is_dragging and client.key_state(0x01) and dbs.last_item == "Defensive" then 
            dbs.defensive_x = cx - dbs.drag_defensive_x
            dbs.defensive_y = cy - dbs.drag_defensive_y
        end
    
       
        if intersect(dbs.defensive_x - ui_get(menu["extras"].length) / 2,dbs.defensive_y - 10,ui_get(menu["extras"].length),20) and client.key_state(0x01) then 
            dbs.last_item = "Defensive"
            dbs.is_dragging = true 
            dbs.drag_defensive_x = cx - dbs.defensive_x
            dbs.drag_defensive_y = cy - dbs.defensive_y
            dbs.defensive_menu = false
            should_shoot = false
        end

        if intersect(dbs.defensive_x - ui_get(menu["extras"].length) / 2,dbs.defensive_y - 10,ui_get(menu["extras"].length),20) and client.key_state(0x02) then 
            dbs.defensive_menu = true
            should_shoot = false
            dbs.slow_menu = false
        end

        if ui_get(menu["extras"].icon) then 

            local add = ui_get(menu["extras"].text) and 16 or 0
            renderer_texture(load_shield,dbs.defensive_x - 50/2-2,dbs.defensive_y-54/2 - 25 - add, 54 , 54, 12,12,12,255,"f")
            renderer_texture(load_shield,dbs.defensive_x - 50/2,dbs.defensive_y-50/2 - 25 - add, 50 , 50, 255,255,255,255,"f")
        end

        if ui_get(menu["extras"].text) then 
            renderer_text(dbs.defensive_x,dbs.defensive_y - 12,255,255,255,255,"c",0,"- DEFENSIVE -")
        end
    
        renderer_rectangle(dbs.defensive_x - ui_get(menu["extras"].length) / 2 - 1,dbs.defensive_y - 4,ui_get(menu["extras"].length) + 2, ui_get(menu["extras"].width) + 4,0,0,0,230)
        --renderer_gradient(dbs.defensive_x - ui_get(menu["extras"].length) / 2 + 1,dbs.defensive_y - 2, ui_get(menu["extras"].length),8, 255,255,255,255,12,12,12,255,true)
    
    
        local defensivecolor = { ui_get(menu["visuals"].defensive_indicator_color) }
        if ui_get(menu["extras"].gradient)  then 
            renderer_gradient(dbs.defensive_x - ui_get(menu["extras"].length) / 2 + 1,dbs.defensive_y - 2,ui_get(menu["extras"].length) - 2, ui_get(menu["extras"].width), defensivecolor[1], defensivecolor[2], defensivecolor[3],defensivecolor[4],12, 12, 12,130,true)
        else
            renderer_rectangle(dbs.defensive_x - ui_get(menu["extras"].length) / 2 + 1,dbs.defensive_y - 2, ui_get(menu["extras"].length) - 2, ui_get(menu["extras"].width), defensivecolor[1], defensivecolor[2], defensivecolor[3],255)
        end

    else
        dbs.defensive_menu = false 
    end

    if dbs.defensive_x ~= w/2 and not dbs.is_dragging then 
        dbs.defensive_x = lerp(dbs.defensive_x,w/2,globals.frametime() * 10)
    end
end

local defensive_alpha = 255
local svg_expansion = 0
functions["visuals"].defensive_indicator = function(w,h)

    functions["anti-aim"].sim_time=functions["anti-aim"].sim_diff()
    if not ui_get(menu["visuals"].defensive_indicator) or not ui_get(menu_reference.dt[2]) or ui_get(menu_reference.fakeduck) or not entity.is_alive(entity_get_local_player()) or ui.is_menu_open() then 
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
        local weight = percentage * ui_get(menu["extras"].length) / 100

        if percentage > 75 then 
            defensive_alpha = lerp(defensive_alpha,0,globals.frametime() * 15)
        end

        svg_expansion = lerp(svg_expansion,50,globals.frametime() * 10)

        --renderer_text(w/2,h/2-110,255,255,255,defensive_alpha < 255 and defensive_alpha or 255,"c",nil,"DEFENSIVE")


        if ui_get(menu["extras"].icon) then 
            local add = ui_get(menu["extras"].text) and 16 or 0
            renderer_texture(load_shield,dbs.defensive_x - svg_expansion/2-2,dbs.defensive_y-54/2 - 25 - add, svg_expansion + 4 , 54, 12,12,12,defensive_alpha < 230 and defensive_alpha or 230,"f")
            renderer_texture(load_shield,dbs.defensive_x - svg_expansion/2,dbs.defensive_y-50/2 - 25 - add, svg_expansion , 50, 255,255,255,defensive_alpha < 230 and defensive_alpha or 230,"f")
        end

        if ui_get(menu["extras"].text) then 
            renderer_text(dbs.defensive_x,dbs.defensive_y - 12,255,255,255,defensive_alpha < 255 and defensive_alpha or 255,"c",0,"- DEFENSIVE -")
        end

        renderer_rectangle(dbs.defensive_x - ui_get(menu["extras"].length) / 2 - 1,dbs.defensive_y - 4,ui_get(menu["extras"].length) + 2, ui_get(menu["extras"].width) + 4,0,0,0,defensive_alpha < 230 and defensive_alpha or 230)

        if ui_get(menu["extras"].gradient)  then 
            renderer_gradient(dbs.defensive_x - ui_get(menu["extras"].length) / 2,dbs.defensive_y - 2 , functions["visuals"].forced_defensive and ui_get(menu["extras"].length) or weight, ui_get(menu["extras"].width), defensivecolor[1], defensivecolor[2], defensivecolor[3],defensive_alpha <  defensivecolor[4] and defensive_alpha or  defensivecolor[4],12, 12, 12,defensive_alpha <  130 and defensive_alpha or  130,true)
        else
            renderer_rectangle(dbs.defensive_x - ui_get(menu["extras"].length) / 2 + 1,dbs.defensive_y - 2, functions["visuals"].forced_defensive and ui_get(menu["extras"].length) or weight, ui_get(menu["extras"].width), defensivecolor[1], defensivecolor[2], defensivecolor[3],defensive_alpha <  defensivecolor[4] and defensive_alpha or  defensivecolor[4])
        end
    else
        functions["visuals"].is_defensive = false
    end
end

local clicked = false
local can_press_under = false
local checkboxes = function(checkbox_name,checkbox_state,x,y)

    local color = {63,63,63,255}

    if intersect(x,y - 35 + dbs.size,55,10) then

        if client.key_state(0x1) then

            if clicked == false then
                ui.set(checkbox_state,not ui.get(checkbox_state)) 
            end
            clicked = true
            
        else
            clicked = false
        end
   
    end

    if ui.get(checkbox_state) then
        color = {255,255,255,255}
    else
        color = {24,24,24,255}
    end

    renderer.rectangle(x - 1,y - 35 + dbs.size,8,8,24,24,24,255)
    renderer.rectangle(x, y - 34 + dbs.size,6,6, color[1],color[2],color[3],color[4])
    renderer.text(x + 10, y - 37 + dbs.size,255,255,255,255,"-",0,string.upper(checkbox_name))

    dbs.size = dbs.size + 10
     
end


local slider_data = 
{
    ref = 0,
    last_item = false,
    hovered_another = false,
}

local is_math = false
local start_timer = 0
local slider = function(slider_name,slider_value,min_value,max_value,slider_addition,x,y)

    local slider_text_bool = 0
    if slider_name ~= "" then
        slider_text_bool = 12
    else
        slider_text_bool = 0
    end
  
    
    if slider_name ~= "" then
        renderer.text(x - 1,y- 35 + dbs.size,220,220,220,255,"-",0,string.upper(slider_name))
    end
    local mpos =  vector(ui.mouse_position())


   -- if intersect(dbs.defensive_x + 79,dbs.defensive_y - 35 + dbs.size + slider_text_bool,177,15) then
     --  dbs.should_drag = false
    --end

    if intersect(x - 1,y - 36 + dbs.size + slider_text_bool,60,4) then
        slider_data.hovered_another = true
        dbs.should_drag = false
        if client.key_state(0x1) then
            
            ui.set(slider_value, math.max(min_value,math.min(max_value,math.floor(min_value + (max_value - min_value) * ((mpos.x  - (x - 1)) / 60)))))
            slider_data.ref = slider_value

            slider_data.last_item = true
        end
    end

    
    if slider_data.last_item then
        if client.key_state(0x25) then
            if is_math == false or start_timer > 200 then
                ui.set(slider_data.ref,math.max(min_value,math.min(max_value,ui.get(slider_data.ref) - 1)))
                if start_timer > 200 then
                    start_timer = 0
                end 
            end
            start_timer = start_timer + 1
            is_math = true
        elseif  client.key_state(0x27) then
            if is_math == false or start_timer > 200 then
                ui.set(slider_data.ref,math.max(min_value,math.min(max_value,ui.get(slider_data.ref) + 1)))
                if start_timer > 200 then
                    start_timer = 0
                end 
            end
            start_timer = start_timer + 1
            is_math = true
        else
            is_math = false
            start_timer = 0
        end
    end

   --[[ if intersect(dbs.defensive_x + 80,dbs.defensive_y + 10 + dbs.size + slider_text_bool,5,5)  then
        if client.key_state(0x1) then
            if is_math == false then
                ui.set(slider_value,math.max(min_value,math.min(max_value,ui.get(slider_value) - 1)))
            end
            is_math = true
            start_timer = 0
        end
    elseif intersect(dbs.defensive_x + 80,dbs.defensive_y + 10 + dbs.size + slider_text_bool,5,5) then
        if client.key_state(0x1) then
            if is_math == false then
                ui.set(slider_value,math.max(min_value,math.min(max_value,ui.get(slider_value) + 1)))
            end
            start_timer = 0
            is_math = true
        end
    end]]--

    local base = (ui.get(slider_value) - min_value) / (max_value - min_value) * 60
   
   -- renderer.rectangle(dbs.defensive_x + 80,dbs.defensive_y - 35 + dbs.size + slider_text_bool,159,7,12,12,12,255)
    renderer.rectangle(x,y - 35 + dbs.size + slider_text_bool,60,2,24,24,24,255)
    renderer.rectangle(x,y - 35 + dbs.size + slider_text_bool,base,2,220,220,220,255)
    renderer.circle(x + base, y - 34 + dbs.size + slider_text_bool , 220,220,220,255, 3, 0, 1)
    --renderer.text(dbs.defensive_x + 80,dbs.defensive_y - 35 + dbs.size + slider_text_bool,220,220,220,255,"b",0, string.upper(tostring(ui.get(slider_value))) .. slider_addition)
  
    
    dbs.size = dbs.size + (slider_name ~= "" and 17 or 12)
end

functions["visuals"].side_defensive_menu = function(w,h) 

    if ui.is_menu_open() and dbs.defensive_menu and ui_get(menu["visuals"].defensive_indicator) then 

        if intersect(dbs.defensive_x + 85,dbs.defensive_y - 50,82,85) then 
            should_shoot = false
        end

        round_rectangle(dbs.defensive_x + 90,dbs.defensive_y - 50 , 70, 85 , 24,24,24,100,5)
        renderer.gradient(dbs.defensive_x + 90,dbs.defensive_y - 40, 35, 1, 24,24,24,0,255,255,255,255, true)
        renderer.gradient(dbs.defensive_x + 90 + 35,dbs.defensive_y - 40, 35, 1, 255,255,255,255, 24,24,24,0 ,true)
        renderer.text(dbs.defensive_x + 90 + 33,dbs.defensive_y - 47, 255,255,255,255, "-c", 0, "SETTINGS")


        checkboxes("Text",menu["extras"].text,dbs.defensive_x + 90,dbs.defensive_y + 3)
        checkboxes("Icon",menu["extras"].icon,dbs.defensive_x + 90,dbs.defensive_y + 3)
        checkboxes("Gradient",menu["extras"].gradient,dbs.defensive_x + 90,dbs.defensive_y + 3)
        slider("length",menu["extras"].length,20,150,"º",dbs.defensive_x + 90,dbs.defensive_y + 3)
        slider("width",menu["extras"].width,1,15,"º",dbs.defensive_x + 90 ,dbs.defensive_y + 3)
    end
end


local collidable = function()
        local current_x = 0
        local current_y = 0
        local old_x = 0
        local old_y = 0

        if dbs.last_item == "Defensive" then 
            current_x = dbs.defensive_x
            current_y = dbs.defensive_y
            old_x = dbs.slow_x
            old_y = dbs.slow_y
        else
            current_x = dbs.slow_x
            current_y = dbs.slow_y
            old_x = dbs.defensive_x
            old_y = dbs.defensive_y
        end

        if current_y >= old_y - 60 and current_y <= old_y + 30 then 
            if dbs.last_item == "Defensive" then 
                dbs.defensive_y = dbs.defensive_y + 3
            else
                dbs.slow_y = dbs.slow_y + 60
            end
        end
    
    if dbs.last_item == "Defensive" then 
        dbs.not_last_item = "Slow" 
    else
        dbs.not_last_item = "Defensive" 
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

    if desync <= 0 then 
        return 
    end

    round_rectangle(w/2 - 31, h/2+12,64, 3, 24, 24, 24, 135, 1)
    round_rectangle(w/2 - 29, h/2+13,desync, 1, 150,230,49,255, 1)
    
    --renderer_gradient(w/2, h/2+15,desync/2,2, desynccolor[1], desynccolor[2], desynccolor[3],desynccolor[4],desynccolor[1], desynccolor[2], desynccolor[3],0, true)
    --renderer_gradient(w/2, h/2+15,-desync/2,2, desynccolor[1], desynccolor[2], desynccolor[3],desynccolor[4],desynccolor[1], desynccolor[2], desynccolor[3],0, true)
end

local slow_turtle = renderer.load_svg('<svg width="800" height="800" viewBox="0 0 128 128" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" class="iconify iconify--noto"><path d="M112.7 59.21s3.94-2.21 4.93-2.77c.99-.56 4.6-2.82 5.91-.84.77 1.16-.7 4.44-3.05 7.86-2.14 3.13-7.12 9.56-7.4 10.83-.28 1.27 1.11 6.36 1.53 8.33.42 1.97 1.74 6.71 1.17 8.54s-3.43 6.85-10.75 6.76c-5.82-.07-7.51-1.78-7.7-2.82-.14-.75-.56-3.24-.56-3.24s-4.79 2.96-7.04 4.08-8.31 4.22-8.31 4.22 1.17 5.35 1.36 7.51c.19 2.16.86 5.25-.28 7.32-1.03 1.88-4.25 5.02-11.83 4.97-5.92-.04-7.41-1.88-8.35-3-.94-1.13-1.13-6.48-1.13-7.6s-.19-5.07-.19-5.07-8.02-.4-12.86-.75c-4.38-.32-10.16-.99-10.16-.99s.21 2.33.42 4.01c.19 1.5.23 4.64-1.34 6.17-2.11 2.06-7.56 2.21-10.56 1.92-3-.28-7.18-1.83-8.4-4.55-1.22-2.72.38-6.29 1.03-8.35.58-1.81 1.6-4.41 1.22-5.16-.38-.75-4.04-1.69-9.29-6.95-5.26-5.26-12.13-23.52 3.28-36.23 15.49-12.76 43.81 1.1 45.31 2.04 1.54.96 53.04 3.76 53.04 3.76z" fill="#bdcf47"/><path d="M66.25 25.28c-13.93.62-24.38 7.52-29.57 15.06-3.1 4.5-4.65 7.74-4.65 7.74s4.81.14 9.15 2.46c5 2.67 10.8 5.56 14.61 18.13 2.87 9.5 3.98 18.53 11.44 20.52 8.45 2.25 28.16 1.13 37.59-8.02s11.26-16.05 8.87-25.06-13.17-25.05-28.16-29.28C79.06 25 72.58 25 66.25 25.28z" fill="#6e823a"/><path d="M111.93 51.32c-.42-.99-1.3-2.5-1.3-2.5s-.07 2.05-.25 3.13c-.28 1.76-1.25 5.42-1.81 4.88-1-.97-5.73-6.92-7.98-10.23-1.71-2.52-7.6-9.11-7.74-11.26-.07-1.06 1.27-4.65 1.27-4.65s-1.22-.7-2.35-1.34c-.88-.49-2.16-1.03-2.16-1.03s-.77 4.9-1.62 5.82c-.75.81-5.32 2.6-8.87 3.94-4.29 1.62-8.45 3.73-10 4.01-1.36.25-9.09-1.41-12-1.97-3.66-.7-9.18-2.26-10.45-3.17-1.48-1.06-3.07-3.78-3.07-3.78s-.89.61-1.78 1.31c-.88.69-2.02 2.06-2.02 2.06s2.31 2.32 2.44 3.18c.18 1.2-1.27 2.83-2.46 4.38-.72.93-2.75 4.85-2.75 4.85s.97.09 2.15.63c1.23.57 2.38 1.16 2.38 1.16s2.97-6.9 4.9-7.53c1.65-.54 6.3.99 9.68 1.69 4.79.99 9.64 1.87 10.66 3.17 1.06 1.34 2.06 6.68 3.03 11.19C70.89 64.2 73.64 77.02 73 78c-.63.99-5.7.63-8.59.28-2.45-.3-6.41-1.76-6.41-1.76s.58 2.11.77 2.67c.28.81 1.16 3.06 1.16 3.06s5.67 2.5 22.42.95 25.03-12.96 27.38-18.02c3.14-6.78 3.54-10.39 3.54-10.39s-.92-2.48-1.34-3.47zM96.65 73.21c-4.24 2.67-15.2 5.49-17.18 4.43-1.58-.85-3.94-13.94-5.07-19.78-.72-3.74-2.45-9.42-1.41-11.19.7-1.2 4.79-2.99 7.81-4.4 2.87-1.33 6.97-3.13 8.17-2.99 1.7.2 5.35 6.12 9.01 11.19 3.66 5.07 7.67 10.35 7.74 12.18.09 1.84-4.7 7.82-9.07 10.56z" fill="#484e23"/><path d="M41.18 65.86c.5 2.83-.95 5.75-4.07 6.02-2.56.22-4.59-1.57-5.09-4.4s1.14-5.49 3.68-5.94c2.52-.45 4.98 1.48 5.48 4.32zm-18.36.25c.07 2.84-2.42 5.69-5.5 5.11-2.53-.48-3.99-2.73-3.71-5.55.29-2.82 2.59-4.9 5.15-4.65s3.99 2.13 4.06 5.09zm7.95 10.48c1.16-.79 3.1-2.67 4.36-1.06 1.27 1.62-.92 3.1-2.18 4.01-1.27.92-4.08 3.17-6.12 3.17-1.9 0-4.79-2.32-6.62-3.87-1.49-1.26-2.18-2.89-1.34-3.87s2.14-.62 3.24.35c1.27 1.13 3.72 3.38 4.72 3.38.98.01 2.39-1.05 3.94-2.11z" fill="#2a2b28"/></svg>', 100, 100)

local slow_turtle_pos = 0
functions["visuals"].slow_down_indicator = function(w,h)

    if not ui_get(menu["visuals"].slow_down_indicator) or not entity.is_alive(entity_get_local_player()) and ui.is_menu_open() or not entity.is_alive(entity_get_local_player()) then
        return 
    end

    local slowdowncolor = { ui_get(menu["visuals"].slow_down_indicator_color) }
    local slow_status = math.floor(entity_get_prop(entity_get_local_player(), "m_flVelocityModifier") * 100)

    if slow_status < 100 and slow_status > 0 then

        
       
        local percentage = slow_status * ui_get(menu["extras"].length1) / 100


        if ui_get(menu["extras"].icon1) then 
            local add = ui_get(menu["extras"].text1) and 16 or 0
            slow_turtle_pos = lerp(slow_turtle_pos, w / 2 - 12.5,globals.frametime() * 10)
            renderer_texture(slow_turtle,slow_turtle_pos,dbs.slow_y-30 - add, 25 , 25, 255,255,255,255,"f")
        end

        if ui_get(menu["extras"].text1) then 
            renderer_text(dbs.slow_x,dbs.slow_y - 12,255,255,255,255,"c",0,100 - slow_status .. "%")
        end


        renderer_rectangle(dbs.slow_x - ui_get(menu["extras"].length1) / 2 - 1,dbs.slow_y - 4,ui_get(menu["extras"].length1) + 2, ui_get(menu["extras"].width1) + 4,0,0,0,130)
        --renderer_gradient(dbs.defensive_x - ui_get(menu["extras"].length) / 2 + 1,dbs.defensive_y - 2, ui_get(menu["extras"].length),8, 255,255,255,255,12,12,12,255,true)
    
    

        local defensivecolor = ui_get(menu["extras"].dynamic) and {255 - (slow_status*2),2.55 * slow_status,0,slowdowncolor[4]} or { ui_get(menu["visuals"].slow_down_indicator_color) }
        
        if ui_get(menu["extras"].gradient1)  then 
            renderer_gradient(dbs.slow_x - ui_get(menu["extras"].length1) / 2 + 1,dbs.slow_y - 2,percentage, ui_get(menu["extras"].width1), defensivecolor[1], defensivecolor[2], defensivecolor[3],defensivecolor[4],12, 12, 12,130,true)
        else
            renderer_rectangle(dbs.slow_x - ui_get(menu["extras"].length1) / 2 + 1,dbs.slow_y - 2, percentage, ui_get(menu["extras"].width1), defensivecolor[1], defensivecolor[2], defensivecolor[3],255)
        end

        return
    end

    slow_turtle_pos = w / 2 - 110
end

functions["visuals"].slow_open = function(w,h)

    if ui.is_menu_open() and ui_get(menu["visuals"].slow_down_indicator) then 

        local cx,cy = ui.mouse_position()

        if dbs.is_dragging and not client.key_state(0x01) then 
            dbs.is_dragging = false 
        end
    
        if dbs.is_dragging and client.key_state(0x01) and dbs.last_item == "Slow" then 
            dbs.slow_x = cx - dbs.drag_slow_x
            dbs.slow_y = cy - dbs.drag_slow_y
        end
    
       
        if intersect(dbs.slow_x - ui_get(menu["extras"].length) / 2,dbs.slow_y - 10,ui_get(menu["extras"].length),20) and client.key_state(0x01) then 
            dbs.last_item = "Slow"
            dbs.is_dragging = true 
            dbs.drag_slow_x = cx - dbs.slow_x
            dbs.drag_slow_y = cy - dbs.slow_y
            dbs.slow_menu = false
            should_shoot = false
        end

        if intersect(dbs.slow_x - ui_get(menu["extras"].length) / 2,dbs.slow_y - 10,ui_get(menu["extras"].length),20) and client.key_state(0x02) then 
            dbs.slow_menu = true
            dbs.defensive_menu = false
            should_shoot = false
        end

        if ui_get(menu["extras"].icon1) then 

            local add = ui_get(menu["extras"].text1) and 16 or 0
            renderer_texture(slow_turtle,dbs.slow_x - 25/2,dbs.slow_y-30 - add, 25 , 25, 255,255,255,255,"f")
        end

        if ui_get(menu["extras"].text1) then 
            renderer_text(dbs.slow_x,dbs.slow_y - 12,255,255,255,255,"c",0,"100%")
        end
    
        renderer_rectangle(dbs.slow_x - ui_get(menu["extras"].length1) / 2 - 1,dbs.slow_y - 4,ui_get(menu["extras"].length1) + 2, ui_get(menu["extras"].width1) + 4,0,0,0,230)
        --renderer_gradient(dbs.defensive_x - ui_get(menu["extras"].length) / 2 + 1,dbs.defensive_y - 2, ui_get(menu["extras"].length),8, 255,255,255,255,12,12,12,255,true)
    
    

        local defensivecolor = { ui_get(menu["visuals"].slow_down_indicator_color) }
        if ui_get(menu["extras"].gradient1)  then 
            renderer_gradient(dbs.slow_x - ui_get(menu["extras"].length1) / 2 + 1,dbs.slow_y - 2,ui_get(menu["extras"].length1) - 2, ui_get(menu["extras"].width1), defensivecolor[1], defensivecolor[2], defensivecolor[3],defensivecolor[4],12, 12, 12,130,true)
        else
            renderer_rectangle(dbs.slow_x - ui_get(menu["extras"].length1) / 2 + 1,dbs.slow_y - 2, ui_get(menu["extras"].length1) - 2, ui_get(menu["extras"].width1), defensivecolor[1], defensivecolor[2], defensivecolor[3],255)
        end

    else
        dbs.slow_menu = false 
    end

    if dbs.slow_x ~= w/2 and not dbs.is_dragging then 
        dbs.slow_x = lerp(dbs.slow_x,w/2,globals.frametime() * 10)
    end
end

functions["visuals"].side_slow_menu = function(w,h) 

    if ui.is_menu_open() and dbs.slow_menu and ui_get(menu["visuals"].slow_down_indicator) then 

        if intersect(dbs.slow_x + 85,dbs.slow_y - 50,82,100) then 
            should_shoot = false
        end

        round_rectangle(dbs.slow_x + 90,dbs.slow_y - 50 , 70, 90 , 24,24,24,100,5)
        renderer.gradient(dbs.slow_x + 90,dbs.slow_y - 40, 35, 1, 24,24,24,0,255,255,255,255, true)
        renderer.gradient(dbs.slow_x + 90 + 35,dbs.slow_y - 40, 35, 1, 255,255,255,255, 24,24,24,0 ,true)
        renderer.text(dbs.slow_x + 90 + 33,dbs.slow_y - 47, 255,255,255,255, "-c", 0, "SETTINGS")


        checkboxes("Text",menu["extras"].text1,dbs.slow_x + 90,dbs.slow_y + 3)
        checkboxes("Turtle",menu["extras"].icon1,dbs.slow_x + 90,dbs.slow_y + 3)
        checkboxes("Gradient",menu["extras"].gradient1,dbs.slow_x + 90,dbs.slow_y + 3)
        checkboxes("Dynamic",menu["extras"].dynamic,dbs.slow_x + 90,dbs.slow_y + 3)
        slider("length",menu["extras"].length1,20,150,"º",dbs.slow_x + 90,dbs.slow_y + 3)
        slider("width",menu["extras"].width1,1,15,"º",dbs.slow_x + 90 ,dbs.slow_y + 3)
    end
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

            if bounding_box[1] ~= nil and bounding_box[2] ~= nil then 
                if table_contains(ui_get(menu["visuals"].zeus_esp),"Indicator") and table_contains(ui_get(menu["visuals"].player_esp),"Zeus esp") then
                    if entity_origin:dist(ent_gin) < 500 then 
                        renderer_texture(zeus_texture,bounding_box[1] - 20,bounding_box[2], 15, 15, 255,167,0,255,"f")
                    end
                end
            end
        elseif has_zeus and entity_get_classname(entity.get_player_weapon(ent)) == "CWeaponTaser" then

            if bounding_box[1] ~= nil and bounding_box[2] ~= nil then 
                if table_contains(ui_get(menu["visuals"].zeus_esp),"Indicator") and table_contains(ui_get(menu["visuals"].player_esp),"Zeus esp") then
                    if entity_origin:dist(ent_gin) < 500 then 
                        renderer_texture(zeus_texture,bounding_box[1] - 20,bounding_box[2] - 40, 15, 15, 255,0,050,255,"f")
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

functions["misc"].fast_ladder = function(cmd)

    if not ui_get(menu["misc"].fast_ladder_box) then   
        return 
    end

    local local_player = entity.get_local_player()
    local pitch,yaw = client.camera_angles()

    local m_MoveType = entity.get_prop(local_player, "m_MoveType")

    if m_MoveType == 9 then --fixed
      
        cmd.yaw = math.floor(cmd.yaw+0.5)
        cmd.roll = 0
        if true then
            if cmd.forwardmove == 0 then
                cmd.pitch = 89
                cmd.yaw = cmd.yaw + ui_get(menu["misc"].ladder_yaw_slider)
                if math.abs(ui_get(menu["misc"].ladder_yaw_slider)) > 0 and math.abs(ui_get(menu["misc"].ladder_yaw_slider)) < 180 and cmd.sidemove ~= 0 then
                    cmd.yaw = cmd.yaw - ui_get(menu["misc"].ladder_yaw_slider)
                end
                if math.abs(ui_get(menu["misc"].ladder_yaw_slider)) == 180 then
                    if cmd.sidemove < 0 then
                        cmd.in_moveleft = 0
                        cmd.in_moveright = 1
                    end
                    if cmd.sidemove > 0 then
                        cmd.in_moveleft = 1
                        cmd.in_moveright = 0
                    end
                end
            end
        end

        if true then
            if cmd.forwardmove > 0 then
                if pitch < 45 then
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
            end
        end

        if true then
            if cmd.forwardmove < 0 then
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
            start_position=h/2+100,
            text=string.format("Missed ".. color .. "%s\affffffff in the " .. color .. "%s\affffffff due to " .. color .. "%s\affffffff.",entity.get_player_name(ctx.target),hitgroup_names[ctx.hitgroup+1],ctx.reason)
        }
    end

    if table_contains(ui_get(menu["misc"].old_logs),"aim_miss") then 
        client.log(string.format("Missed %s in the %s due to %s.",entity.get_player_name(ctx.target),hitgroup_names[ctx.hitgroup+1],ctx.reason))
        local color = "\aF85454FF"
        current_logs[#current_logs + 1 ] = {
            text=string.format("Missed %s in the %s due to %s.",entity.get_player_name(ctx.target),hitgroup_names[ctx.hitgroup+1],ctx.reason),
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
            start_position=h/2+100,
            text=string.format("Hit " .. color .. "%s\affffffff in the " .. color .. "%s\affffffff for " .. color .. "%s\affffffff.",entity.get_player_name(ctx.target),hitgroup_names[ctx.hitgroup+1] ,ctx.damage)
        }
    end

    if table_contains(ui_get(menu["misc"].old_logs),"aim_hit") then 
        local color = string.format("\a%02X%02X%02XFF",ui_get(menu["misc"].aim_logs_hit_color))
        client.log(string.format("Hit %s in the %s for %s.",entity.get_player_name(ctx.target),hitgroup_names[ctx.hitgroup+1] ,ctx.damage))
        current_logs[#current_logs + 1 ] = {
            text=string.format("Hit %s in the %s for %s.",entity.get_player_name(ctx.target),hitgroup_names[ctx.hitgroup+1] ,ctx.damage),
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

local last_miss = 0


local main_bullet_impact = LPH_NO_VIRTUALIZE(function(event)

    if not ui_get(menu["misc"].aim_logs) and not table_contains(ui_get(menu["misc"].old_logs),"bullet_impact") then  
        return 
    end

    local w,h = client_screen_size()


	if not entity_is_alive(entity_get_local_player()) then return end

	local shooter_id = event.userid
	local shooter = client.userid_to_entindex(shooter_id)

	if not entity_is_enemy(shooter) or entity_is_dormant(shooter) then return end

	local lx, ly, lz = entity.hitbox_position(entity_get_local_player(), 0)
	
	local ox, oy, oz = entity_get_prop(entity_get_local_player(), "m_vecOrigin")
	local ex, ey, ez = entity_get_prop(shooter, "m_vecOrigin")

	local dist = ((event.y - ey)*lx - (event.x - ex)*ly + event.x*ey - event.y*ex) / math.sqrt((event.y-ey)^2 + (event.x - ex)^2)

	if math.abs(dist) <= 35 and event.z > oz - 25 and event.z < lz + 25 and globals.curtime() - last_miss > 0.015 then
        last_miss = globals.curtime()
       

        if table_contains(ui_get(menu["misc"].old_logs),"bullet_impact") then 
            current_logs[#current_logs + 1 ] = {
                text = string.format("%s shot at you.", entity.get_player_name(client.userid_to_entindex(event.userid))),
                current_time = globals_tickcount()
            }
        end

        if ui_get(menu["misc"].aim_logs) then 
            aim_logs[#aim_logs+1]={
                bullet_tick=globals_tickcount()*globals.tickinterval(),
                start_position=h/2+100,
                text = string.format("%s shot at you.", entity.get_player_name(client.userid_to_entindex(event.userid))),
            }
        end
    end
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

local venus_svg = '<svg width="800" height="800" viewBox="0 0 36 36" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" class="iconify iconify--twemoji" transform="scale(-1 1)"><path fill="#FFAC33" d="M16.61 17.589h5.278v1.056H16.61z"/><path fill="#FFAC33" d="M15.555 15.478a.526.526 0 0 0-.373.901c.845.844.845 2.631 0 3.476a.528.528 0 0 0 .746.746c1.254-1.253 1.254-3.715 0-4.968a.526.526 0 0 0-.373-.155z"/><path fill="#77B255" d="M23.888 23.486h-8.575c-1.873 0-3.261-.974-3.809-2.671l-2.405-6.601 2.114-.771 2.419 6.641c.255.788.8 1.151 1.681 1.151h8.575v2.251z"/><path fill="#3E721D" d="m35.205 11.222-1.962.609-1.306-4.21 1.962-.609a1.115 1.115 0 0 1 1.392.733l.647 2.084a1.116 1.116 0 0 1-.733 1.393z"/><path fill="#E95F28" d="M1.687 6.947h1.761v5.024H1.686c-.87 0-1.582-.712-1.582-1.582v-1.86c0-.87.712-1.582 1.583-1.582z"/><path fill="#3E721D" d="M6.694 4.89c0 .923.748 1.671 1.671 1.671s2.727-.748 2.727-1.671-1.804-1.671-2.727-1.671-1.671.748-1.671 1.671z"/><path fill="#5C913B" d="M4.869 12.905c0 1.166.945 2.111 2.659 2.111H22v-2.111H4.869z"/><path fill="#77B255" d="M35.279 29.382s-1.975-6.154-2.731-8.768-1.006-4.614 1.077-6.147c1.135-.835 1.431-1.844 1.204-2.899-.377-1.752-1.284-4.076-1.72-4.925-.189-.369-.486-.758-1.073-.928 0 0-3.915-1.737-15.24-1.737-6.333 0-14.215.957-14.215 3.265v3.612c0 1.23.997 2.227 2.227 2.227H18.51c.727 0 1.37.473 1.587 1.168l4.352 13.79v.001c.429 1.402-.915 1.633-.915 2.787a1.3 1.3 0 0 0 1.297 1.297h8.433a2.112 2.112 0 0 0 2.015-2.743z"/><path fill="#A6D388" d="M27.499 21.008a1 1 0 0 1-.967-.749c-1.357-5.237-4.091-8.438-8.354-9.786-6.075-1.921-13.393-.323-13.466-.308a1 1 0 0 1-.438-1.952c.32-.072 7.909-1.733 14.506.352 4.905 1.55 8.165 5.316 9.688 11.191a1 1 0 0 1-.969 1.252z"/><circle fill="#F5F8FA" cx="29.185" cy="10.67" r="3.305"/><circle fill="#FFCC4D" cx="29.185" cy="10.67" r="2.292"/></svg>'
local load_venus_svg = renderer.load_svg(venus_svg, 25, 25)

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

        aim.start_position = lerp(aim.start_position,h/2+100+(i*30),globals.frametime()*15)

     
        rounded_rectangle(w/2 - renderer_measure_text("c", aim.text) / 2 - 5,aim.start_position - 10,renderer_measure_text("c", aim.text) + 10, 18,24,24,24,255,1,10)
       
        --renderer_text(w/2 - renderer_measure_text("c", aim.text) / 2 - 23,aim.start_position - 2,255,255,255,255,"cb",0,"V")
        renderer_text(w/2,aim.start_position - 2,255,255,255,255,"c",0,aim.text)


        if ui_get(menu["misc"].aim_logo) then 
            rounded_rectangle(w/2 - renderer_measure_text("c", aim.text) / 2 - 24 - ui_get(menu["misc"].logo_slider),aim.start_position - 10,21, 18,24,24,24,255,1,10)
            renderer_texture(load_venus_svg,w/2 - renderer_measure_text("c", aim.text) / 2 - 20 - ui_get(menu["misc"].logo_slider),aim.start_position - 9,15,15,255,255,255,255,"f")
        end

        local current_ongoing_tick = globals_tickcount()*globals.tickinterval()
        local text_timer = (aim.bullet_tick + 5) - current_ongoing_tick
        local text_timer_percentage = text_timer / 5        

        


        if h/2+200+(i*30) > h - 100 then
            table.remove(aim_logs,1)
            break
        end

        if globals_tickcount()*globals.tickinterval() > aim.bullet_tick + 5 then 
            table.remove(aim_logs,i)
            break
        end 
    end
end

functions["visuals"].watermark = function(w,h)
    

    if not ui_get(menu["visuals"].ot_watermark) then 
        return 
    end


    local get_ping = math.floor(math.min(1000,client.latency() * 1000))


    local watermark_text = string.format("%s | ping %s ms",obex_data.username,get_ping)
    rounded_rectangle(w - renderer.measure_text("c", watermark_text) - 12,10,renderer.measure_text("c", watermark_text) + 8, 17,24,24,24,255,1,10)
    renderer_text(w - renderer.measure_text("c", watermark_text) / 2 - 8,17,255,255,255,255,"c",0,watermark_text)

    if ui_get(menu["visuals"].watermark_logo) then
        rounded_rectangle(w - renderer.measure_text("c", watermark_text) - 48 - ui_get(menu["visuals"].watermark_spacing),10,40, 17,24,24,24,255,1,10)
        renderer_text(w - renderer.measure_text("c", watermark_text) - 28 - ui_get(menu["visuals"].watermark_spacing),17,255,255,255,255,"cb",0,"\a80CC23ffV\affffffffenus")
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

            for i = 1, globals.maxplayers() do 
                if entity_get_classname(i) == 'CCSPlayer' then

                    if entity_get_prop(i,"m_iTeamNum") ~= entity_get_prop(entity_get_local_player(),"m_iTeamNum") then 
                        plist.set(i, "Force body yaw", false)
                        plist.set(i, "Force body yaw value",0)
                    end
                end
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

ui_menu.main = ui.new_button(tab, container, "- Main -", function()
    ui_menu.selected_tab = ui_menu.easier_tab.main
end)

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


writefile("default config_gs.txt","dHJ1ZXx0cnVlfEN1c3RvbXw4NnxBdCB0YXJnZXRzfDE4MHxmYWxzZXwxfDB8MHxDZW50ZXJ8NzB8Sml0dGVyfDF8ZmFsc2V8ZmFsc2V8MnxmYWxzZXxSYW5kb218MHxTa2l0dGVyfDEwOHx0cnVlfHRydWV8Q3VzdG9tfDYyfExvY2FsIHZpZXd8MHxDZW50ZXJ8Mzh8Sml0dGVyfDF8ZmFsc2V8ZmFsc2V8MnxmYWxzZXxPZmZ8MHxPZmZ8MHx0cnVlfHRydWV8Q3VzdG9tfDg2fEF0IHRhcmdldHN8MTgwfGZhbHNlfDV8MzN8N3xTbG93IGppdHRlcnwtMzB8T3B0aW1pemVkIHNsb3d8MXxmYWxzZXxmYWxzZXwyfGZhbHNlfE9mZnwwfE9mZnwwfHRydWV8dHJ1ZXxNaW5pbWFsfDg1fEF0IHRhcmdldHN8MTgwfGZhbHNlfDZ8NDB8LTN8U2xvdyBqaXR0ZXJ8LTI4fFlhd1YyfDB8dHJ1ZXxmYWxzZXwyfGZhbHNlfEN1c3RvbXwtODl8U3Bpbnw2MHx0cnVlfHRydWV8TWluaW1hbHwwfEF0IHRhcmdldHN8MTgwfGZhbHNlfDF8MHwxNnxDZW50ZXJ8NjJ8Sml0dGVyfDExNXxmYWxzZXxmYWxzZXwyfGZhbHNlfE9mZnwwfE9mZnwwfHRydWV8dHJ1ZXxNaW5pbWFsfDg5fEF0IHRhcmdldHN8MTgwfGZhbHNlfDF8MHwwfENlbnRlcnw1N3xKaXR0ZXJ8MTE1fGZhbHNlfGZhbHNlfDJ8ZmFsc2V8T2ZmfDB8T2ZmfDB8dHJ1ZXx0cnVlfE1pbmltYWx8MHxBdCB0YXJnZXRzfDE4MHxmYWxzZXwxfDB8MHxDZW50ZXJ8MHxPcHRpbWl6ZWQgc2xvd3wwfGZhbHNlfGZhbHNlfDJ8ZmFsc2V8T2ZmfDB8T2ZmfDB8dHJ1ZXx0cnVlfE1pbmltYWx8ODl8QXQgdGFyZ2V0c3wxODB8ZmFsc2V8NXw0Nnw5fFNsb3cgaml0dGVyfC00NXxZYXdWMnwxMTV8ZmFsc2V8dHJ1ZXwyfGZhbHNlfFJhbmRvbXwtNjR8U3BpbnwyNXx0cnVlfHRydWV8TWluaW1hbHw4OXxBdCB0YXJnZXRzfDE4MHxmYWxzZXw1fDM0fDB8U2xvdyBqaXR0ZXJ8LTMzfFlhd1YyfC0xMTV8ZmFsc2V8dHJ1ZXwyfGZhbHNlfFJhbmRvbXwtNjV8U3BpbnwyOXxmYWxzZXx0cnVlfE9mZnwwfExvY2FsIHZpZXd8T2ZmfGZhbHNlfDF8MHwwfE9mZnwwfE9mZnwwfGZhbHNlfGZhbHNlfDJ8ZmFsc2V8T2ZmfDB8T2ZmfDB8dHJ1ZXx0cnVlfE1pbmltYWx8ODl8QXQgdGFyZ2V0c3wxODB8ZmFsc2V8MXwwfDB8T2ZmfDB8U3RhdGljfC0xMTV8ZmFsc2V8ZmFsc2V8MnxmYWxzZXxPZmZ8MHxPZmZ8MHxmYWxzZXx0cnVlfE9mZnwwfExvY2FsIHZpZXd8T2ZmfGZhbHNlfDF8MHwwfE9mZnwwfE9mZnwwfGZhbHNlfGZhbHNlfDJ8ZmFsc2V8T2ZmfDB8T2ZmfDB8")

local create_file = ui.new_button(tab,container, "Create config", function()
    writefile(tostring(ui_get(new_text) .. "_gs.txt"),"paste config in file")
end)

local remove_file = ui.new_button(tab, container, "Delete config", function()
	filesystem.remove_file(soundPath .. '/' .. get_configs()[ui_get(sounds) + 1],get_configs()[ui_get(sounds) + 1]);
end)

local save_file_cfg = ui.new_button(tab,container, "Save config", function()

    print("Config saved!")

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
            .. tostring(ui_get(menu["anti-aim"].builder[v].yaw_jitter2)) .. "|"
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

    print("Config loaded!")

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
            ui_set(menu["anti-aim"].builder[v].yaw_jitter2, tonumber(tbl[crescente]))
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

    print("Config exported!")

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
            .. tostring(ui_get(menu["anti-aim"].builder[v].yaw_jitter2)) .. "|"
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

    print("Config imported!")


    local tbl = str_to_sub(base64.decode(clipboard.get(), 'base64'), "|")
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
            ui_set(menu["anti-aim"].builder[v].yaw_jitter2, tonumber(tbl[crescente]))
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

functions["menu"].visibility = function()
    if ui.is_menu_open() then

        local skeet_tab = ui_get(menu["anti-aim"].anti_aim_selector) == "Skeet"
        
        ui_set_visible(menu["main"].welcome_label,ui_menu.selected_tab == ui_menu.easier_tab.main)
        ui_set_visible(ui_menu.aa,ui_menu.selected_tab == ui_menu.easier_tab.main)
        ui_set_visible(ui_menu.aa2,ui_menu.selected_tab == ui_menu.easier_tab.main)
        ui_set_visible(ui_menu.visuals,ui_menu.selected_tab == ui_menu.easier_tab.main)
        ui_set_visible(ui_menu.misc,ui_menu.selected_tab == ui_menu.easier_tab.main)
        ui_set_visible(ui_menu.cfg,ui_menu.selected_tab == ui_menu.easier_tab.main)
        ui_set_visible(ui_menu.main,ui_menu.selected_tab ~= ui_menu.easier_tab.main)

        ui_set_visible(menu["extras"].icon,false)
        ui_set_visible(menu["extras"].text,false)
        ui_set_visible(menu["extras"].gradient,false)
        ui_set_visible(menu["extras"].length,false)
        ui_set_visible(menu["extras"].width,false)
        ui_set_visible(menu["extras"].icon1,false)
        ui_set_visible(menu["extras"].text1,false)
        ui_set_visible(menu["extras"].gradient1,false)
        ui_set_visible(menu["extras"].dynamic,false)
        ui_set_visible(menu["extras"].length1,false)
        ui_set_visible(menu["extras"].width1,false)


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
                ui_set_visible(menu["anti-aim"].builder[v].delay_custom,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and (ui_get(menu["anti-aim"].builder[v].yaw_jitter) == "Slow jitter" or ui_get(menu["anti-aim"].builder[v].yaw_jitter) == "Slow 5-way") and skeet_tab)
                ui_set_visible(menu["anti-aim"].builder[v].yaw_jitter2,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and (ui_get(menu["anti-aim"].builder[v].yaw_jitter) == "Slow jitter" or ui_get(menu["anti-aim"].builder[v].yaw_jitter) == "L&R" or ui_get(menu["anti-aim"].builder[v].yaw_jitter) == "50/50") and skeet_tab)
            end

            ui_set_visible(menu["anti-aim"].builder[v].yaw_custom,ui_get(menu["anti-aim"].state_selector) == v and (v ~= "Manual" ) and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab and ui_get(menu["anti-aim"].builder[v].yaw) ~= "Off")
            ui_set_visible(menu["anti-aim"].builder[v].yaw_jitter,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].yaw_jitter_custom,ui_get(menu["anti-aim"].state_selector) == v and (v ~= "Manual") and ui_get(menu["anti-aim"].builder[v].yaw_jitter) ~= "Off" and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].body_yaw,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].body_yaw_custom,ui_get(menu["anti-aim"].state_selector) == v and ui_get(menu["anti-aim"].builder[v].body_yaw) ~= "Off" and ui_get(menu["anti-aim"].builder[v].body_yaw) ~= "Opposite" and ui_get(menu["anti-aim"].builder[v].body_yaw) ~= "Optimized slow" and ui_get(menu["anti-aim"].builder[v].body_yaw) ~= "Optimized jitter" 
            and ui_get(menu["anti-aim"].builder[v].body_yaw) ~= "YawV2" and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab )
            
            
            
            ui_set_visible(menu["anti-aim"].builder[v].defensive_enable,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].defensive_force,ui_get(menu["anti-aim"].state_selector) == v and ui_menu.selected_tab == ui_menu.easier_tab.aa and ui_get(menu["anti-aim"].builder[v].defensive_enable) and skeet_tab)
            ui_set_visible(menu["anti-aim"].builder[v].defensive_tick_stopper,false)
            ui_set_visible(menu["anti-aim"].builder[v].defensive_choke,false)
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



        ui_set_visible(menu["anti-aim"].disable_on_quickpeek,ui_menu.selected_tab == ui_menu.easier_tab.aa2  and skeet_tab)
        
        ui_set_visible(menu["anti-aim"].freestanding_disablers,ui_menu.selected_tab == ui_menu.easier_tab.aa2 and skeet_tab)
        ui_set_visible(menu["anti-aim"].anti_backstab,ui_menu.selected_tab == ui_menu.easier_tab.aa2)
        ui_set_visible(menu["anti-aim"].safe_anti_aim,ui_menu.selected_tab == ui_menu.easier_tab.aa2  and skeet_tab)
        ui_set_visible(menu["visuals"].indicator,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].indicator_scoped_animation,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].indicator) ~= "Disabled")
        ui_set_visible(menu["visuals"].indicator_color,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].indicator) == "Default")
        ui_set_visible(menu["visuals"].defensive_indicator,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].defensive_indicator_color,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].defensive_indicator))
        ui_set_visible(menu["visuals"].desync_indicator,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].desync_indicator_color,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].desync_indicator))
        ui_set_visible(menu["visuals"].slow_down_indicator,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].slow_down_indicator_color,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].slow_down_indicator))
        ui_set_visible(menu["visuals"].minimum_damage_indicator,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].manual_anti_aim_indicators,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].mi_type,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].manual_anti_aim_indicators))
        ui_set_visible(menu["visuals"].ot_watermark,ui_menu.selected_tab == ui_menu.easier_tab.visuals)
        ui_set_visible(menu["visuals"].watermark_logo,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].ot_watermark))
        ui_set_visible(menu["visuals"].watermark_spacing,ui_menu.selected_tab == ui_menu.easier_tab.visuals and ui_get(menu["visuals"].ot_watermark) and ui_get(menu["visuals"].watermark_logo))
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
        ui_set_visible(menu["misc"].fast_ladder_box, ui_menu.selected_tab == ui_menu.easier_tab.misc)
        ui_set_visible(menu["misc"].ladder_yaw_slider, ui_menu.selected_tab == ui_menu.easier_tab.misc and ui_get(menu["misc"].fast_ladder_box))
        ui_set_visible(menu["misc"].manual_r,ui_menu.selected_tab == ui_menu.easier_tab.aa2 and ui_get(menu["misc"].show_keybinds))
        ui_set_visible(menu["misc"].manual_b,ui_menu.selected_tab == ui_menu.easier_tab.aa2 and ui_get(menu["misc"].show_keybinds))
        ui_set_visible(menu["misc"].manual_l,ui_menu.selected_tab == ui_menu.easier_tab.aa2 and ui_get(menu["misc"].show_keybinds))
        ui_set_visible(menu["misc"].manual_f,ui_menu.selected_tab == ui_menu.easier_tab.aa2 and ui_get(menu["misc"].show_keybinds))
        ui_set_visible(menu["misc"].freestanding,ui_menu.selected_tab == ui_menu.easier_tab.aa2 and ui_get(menu["misc"].show_keybinds))
        ui_set_visible(menu["misc"].aim_logs,ui_menu.selected_tab == ui_menu.easier_tab.misc)
        ui_set_visible(menu["misc"].aim_logs_hit_color,ui_menu.selected_tab == ui_menu.easier_tab.misc and ui_get(menu["misc"].aim_logs))
        ui_set_visible(menu["misc"].aim_logs_miss_color,ui_menu.selected_tab == ui_menu.easier_tab.misc and ui_get(menu["misc"].aim_logs))
        ui_set_visible(menu["misc"].aim_logs_hit_label,ui_menu.selected_tab == ui_menu.easier_tab.misc and ui_get(menu["misc"].aim_logs))
        ui_set_visible(menu["misc"].aim_logo,ui_menu.selected_tab == ui_menu.easier_tab.misc and ui_get(menu["misc"].aim_logs))
        ui_set_visible(menu["misc"].logo_slider,ui_menu.selected_tab == ui_menu.easier_tab.misc and ui_get(menu["misc"].aim_logs) and ui_get(menu["misc"].aim_logo))
        ui_set_visible(menu["misc"].aim_logs_miss_label,ui_menu.selected_tab == ui_menu.easier_tab.misc and ui_get(menu["misc"].aim_logs))
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
    functions["visuals"].watermark(w,h)
    get_bots_players()
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
    functions["visuals"].side_defensive_menu(w,h)
    functions["visuals"].defensive_open(w,h)
    functions["visuals"].side_slow_menu(w,h)
    functions["visuals"].slow_open(w,h)
    collidable()
    

    if ui.get(menu["misc"].fps_boost) and has_checked == false then 
        functions["visuals"].fps_boost(0)
        has_checked = true 
    elseif not ui.get(menu["misc"].fps_boost) and has_checked == true then 
        functions["visuals"].fps_boost(1)
        has_checked = false
    end

    functions["visuals"].defensive_indicator(w,h)
    functions["misc"].sunset()

    if functions["anti-aim"].sim_time ~= nil and functions["anti-aim"].sim_time < 0 then
        functions["anti-aim"].sim_tick=globals_tickcount()
    end

    functions["misc"].resolver()

    logs.three = {}
    dbs.size = 0

end

local function main_paint_ui()

    local w,h = client.screen_size()
    functions["menu"].visibility()

    if entity.get_local_player() == nil then 
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

    functions["misc"].fast_ladder(cmd)

    if not should_shoot then
        cmd.in_attack = false
        cmd.in_attack2 = 0
    end

    should_shoot = true

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
        for i = 1, globals.maxplayers() do 
            if entity_get_prop(i,"m_iTeamNum") ~= entity_get_prop(entity_get_local_player(),"m_iTeamNum") then 
                plist.set(i, "Force body yaw", false)
                plist.set(i, "Force body yaw value",0)
            end
        end
    end

    if functions["misc"].sunset_active == true then
        local sun_prop = entity.get_all('CCascadeLight')[1]
        entity.set_prop(sun_prop,"m_envLightShadowDirection",functions["misc"].old_sun.x,functions["misc"].old_sun.y,functions["misc"].old_sun.z)
    end

    if has_checked then 
        functions["visuals"].fps_boost(1)
    end

    database.write("def_indicator_x", dbs.defensive_x)
    database.write("def_indicator_y", dbs.defensive_y)
    database.write("slow_indicator_x", dbs.slow_x)
    database.write("slow_indicator_y", dbs.slow_y)
end

client_set_event_callback("bomb_exploded",function()
    functions["anti-aim"].bomb_was_bombed = true
end)

client_set_event_callback("bomb_defused",function()
    functions["anti-aim"].bomb_was_defused = true
end)

client_set_event_callback("round_start",function()
    functions["anti-aim"].bomb_was_defused=false
    functions["anti-aim"].bomb_was_bombed=false
    miss_sp = {}
end)


client_set_event_callback("net_update_end", functions["misc"].safe_point)

LPH_NO_VIRTUALIZE(function() client_set_event_callback("bullet_impact",main_bullet_impact) end)()

client_set_event_callback("paint", main_paint)
client_set_event_callback("paint_ui", main_paint_ui)
client_set_event_callback("pre_render", main_pre_render)
client_set_event_callback("setup_command", main_setup)
client_set_event_callback("shutdown", main_shutdown)