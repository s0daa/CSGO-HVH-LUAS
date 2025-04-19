
-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_visible, entity_hitbox_position, math_abs, math_atan, table_remove = client.visible, entity.hitbox_position, math.abs, math.atan, table.remove
local ui_new_label, ui_reference, ui_new_checkbox, ui_new_combobox, ui_new_hotkey, ui_new_multiselect, ui_new_slider, ui_set, ui_get, ui_set_callback, ui_set_visible = ui.new_label, ui.reference, ui.new_checkbox, ui.new_combobox, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.set, ui.get, ui.set_callback, ui.set_visible
local client_log, client_color_log, client_set_event_callback = client.log, client.color_log, client.set_event_callback
local entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_is_alive = entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.is_alive
local bit_band, bit_bend = bit.band, validate
local client_screen_size, renderer_text = client.screen_size, renderer.text

local config_names = { "Global", "Taser", "Revolver", "Pistol", "Auto", "Scout", "AWP", "Rifle", "SMG", "Shotgun", "Deagle" }
local name_to_num = { ["Global"] = 1, ["Taser"] = 2, ["Revolver"] = 3, ["Pistol"] = 4, ["Auto"] = 5, ["Scout"] = 6, ["AWP"] = 7, ["Rifle"] = 8, ["SMG"] = 9, ["Shotgun"] = 10, ["Deagle"] = 11 }
local weapon_idx = { [1] = 11, [2] = 4,[3] = 4,[4] = 4,[7] = 8,[8] = 8,[9] = 7,[10] = 8,[11] = 5,[13] = 8,[14] = 8,[16] = 8,[17] = 9,[19] = 9,[23] = 9,[24] = 9,[25] = 10,[26] = 9,[27] = 10,[28] = 8,[29] = 10,[30] = 4,[31] = 2,  [32] = 4,[33] = 9,[34] = 9,[35] = 10,[36] = 4,[38] = 5,[39] = 8,[40] = 6,[60] = 8,[61] = 4,[63] = 4,[64] = 3}
local damage_idx  = { [0] = "Auto", [101] = "HP + 1", [102] = "HP + 2", [103] = "HP + 3", [104] = "HP + 4", [105] = "HP + 5", [106] = "HP + 6", [107] = "HP + 7", [108] = "HP + 8", [109] = "HP + 9", [110] = "HP + 10", [111] = "HP + 11", [112] = "HP + 12", [113] = "HP + 13", [114] = "HP + 14", [115] = "HP + 15", [116] = "HP + 16", [117] = "HP + 17", [118] = "HP + 18", [119] = "HP + 19", [120] = "HP + 20", [121] = "HP + 21", [122] = "HP + 22", [123] = "HP + 23", [124] = "HP + 24", [125] = "HP + 25", [126] = "HP + 26" }
local high_pitch, side_ways, min_damage, custom_damage, last_weapon = false, false, "visible", false, 0

local master_switch = ui_new_checkbox("LUA", "A", "Enable adaptive weapon")
local ovr_key = ui_new_hotkey("LUA", "A", "Override minimum damage key")
local ovr_head = ui_new_hotkey("LUA", "A", "Force head hitbox")
local active_wpn = ui_new_combobox("LUA", "A", "View weapon", config_names)
local global_dt_hc = ui_new_checkbox("LUA", "A", "Global double tap hitchance")
local rage = {}
local active_idx = 1

for i=1, #config_names do
    rage[i] = {
        enabled = ui_new_checkbox("LUA", "A", "Enable " .. config_names[i] .. " config"),
        target_selection = ui_new_combobox("LUA", "A", "[" .. config_names[i] .. "] Target selection", {"Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"}),
        accuracy_boost = ui_new_combobox("LUA", "A", "[" .. config_names[i] .. "] Accuracy boost", {"Off", "Low", "Medium", "High", "Maximum"}),
        target_hitbox = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] Target hitbox", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        multipoint = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] Multi-point", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }), 
        multimode = ui_new_combobox("LUA", "A", "\n[" .. config_names[i] .. "] Multi-point mode", { "Low", "Medium", "High" }),
        multipoint_scale = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Multi-point scale", 24, 100, 60, true, "%", 1, { [24] = "Auto" }),
        dt_mp_enable = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Custom DT multipoint"),
        dt_multipoint = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] DT Multi-point", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),   
        dt_multimode = ui_new_combobox("LUA", "A", "\n[" .. config_names[i] .. "] DT Multi-point mode", { "Low", "Medium", "High" }),   
        dt_multipoint_scale = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] DT Multi-point scale", 24, 100, 60, true, "%", 1, { [24] = "Auto" }),
        prefer_safe_point = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Prefer safe point"),
        dt_prefer_safe_point = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Prefer safe point on DT"),
        force_safe_point_onlimbs = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Force safe point on limbs"),
        force_safe_point = ui_new_hotkey("LUA", "A", "[" .. config_names[i] .. "] Force safe point"),
        automatic_fire = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Automatic fire"),
        automatic_penetration = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Automatic penetration"),
        automatic_scope = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Automatic scope"),
 
        hitchance = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Hitchance", 0, 100, 50, true, "%", 1, {"Off"}),
        air_hc_enable = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Custom hitchance in air"),
        hitchance_air = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Hitchance in air", 0, 100, 50, true, "%", 1, {"Off"}),
        custom_damage = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] Custom min damage", { "Visible", "Double tap", "On-key" }),
        min_damage = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Minimum damage", 0, 126, 20, true, nil, 1, damage_idx),
        vis_min_damage = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Visible min damage", 0, 126, 20, true, nil, 1, damage_idx),
        wall_min_damage = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Autowall min damage", 0, 126, 20, true, nil, 1, damage_idx),
        dt_min_damage = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Double tap min damage", 0, 126, 20, true, nil, 1, damage_idx),
        ovr_min_damage = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] On-key min damage", 0, 126, 20, true, nil, 1, damage_idx),
        quick_stop = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Quick stop"),
        quick_stop_options = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] Quick stop options", {"Early", "Slow motion", "Duck", "Fake duck", "Move between shots", "Ignore molotov"}),
        prefer_baim = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Prefer body aim"),
        prefer_baim_disablers = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] Prefer body aim disablers", {"Low inaccuracy", "Target shot fired", "Target resolved", "Safe point headshot", "Low damage", "High pitch", "Sideways"}),
        delay_shot = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Delay shot"),
        force_baim_peek = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Force body aim on peek"),
        doubletap = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Double tap"),
        doubletap_hc = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Double tap hit chance", 0, 100, 0, true, "%", 1),
        doubletap_stop = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] Double tap quick stop", { "Slow motion", "Duck", "Move between shots" }),
    }
end

local prioritize_awp = ui_new_checkbox("LUA", "A", "Prioritize awpers")

--References
local ref_enabled, ref_enabledkey = ui_reference("RAGE", "Aimbot", "Enabled")
local ref_target_selection = ui_reference("RAGE", "Aimbot", "Target selection")
local ref_target_hitbox = ui_reference("RAGE", "Aimbot", "Target hitbox")
local ref_multipoint, ref_multipointkey, ref_multipoint_mode = ui_reference("RAGE", "Aimbot", "Multi-point")
local ref_multipoint_scale = ui_reference("RAGE", "Aimbot", "Multi-point scale")
local ref_prefer_safepoint = ui_reference("RAGE", "Aimbot", "Prefer safe point")
local ref_force_safepoint = ui_reference("RAGE", "Aimbot", "Force safe point")
local ref_automatic_fire = ui_reference("RAGE", "Aimbot", "Automatic fire")
local ref_automatic_penetration = ui_reference("RAGE", "Aimbot", "Automatic penetration")

local ref_hitchance = ui_reference("RAGE", "Aimbot", "Minimum hit chance")
local ref_mindamage = ui_reference("RAGE", "Aimbot", "Minimum damage")
local ref_automatic_scope = ui_reference("RAGE", "Aimbot", "Automatic scope")
local ref_reduce_aimstep = ui_reference("RAGE", "Aimbot", "Reduce aim step")
local ref_log_spread = ui_reference("RAGE", "Aimbot", "Log misses due to spread")
local ref_low_fps_mitigations = ui_reference("RAGE", "Aimbot", "Low FPS mitigations")
local ref_remove_recoil = ui_reference("RAGE", "Other", "Remove recoil")
local ref_accuracy_boost = ui_reference("RAGE", "Other", "Accuracy boost")
local ref_delay_shot = ui_reference("RAGE", "Other", "Delay shot")
local ref_quickstop, ref_quickstopkey = ui_reference("RAGE", "Other", "Quick stop")
local ref_quickstop_options = ui_reference("RAGE", "Other", "Quick stop options")
local ref_antiaim_correction = ui_reference("RAGE", "Other", "Anti-aim correction")
local ref_antiaim_correction_override = ui_reference("RAGE", "Other", "Anti-aim correction override")
local ref_prefer_bodyaim = ui_reference("RAGE", "Other", "Prefer body aim")
local ref_prefer_bodyaim_disablers = ui_reference("RAGE", "Other", "Prefer body aim disablers")
local ref_force_baim_peek = ui_reference("RAGE", "Other", "Force body aim on peek")
local ref_force_bodyaim = ui_reference("RAGE", "Other", "Force body aim")
local ref_duck_peek_assist = ui_reference("RAGE", "Other", "Duck peek assist")
local ref_doubletap, ref_doubletapkey = ui_reference("RAGE", "Other", "Double tap")
local ref_doubletap_hc = ui_reference("RAGE", "Other", "Double tap hit chance")
local ref_doubletap_stop = ui_reference("RAGE", "Other", "Double tap quick stop")
local ref_doubletap_mode = ui_reference("RAGE", "Other", "Double tap mode")

local load_text = "[shoppy.gg/@kanuwu] THE LUA HAS SUCCESSFULY LOADED!"

local function contains(table, val)
    if #table > 0 then
        for i=1, #table do
            if table[i] == val then
                return true
            end
        end
    end
    return false
end

local function pos_in_table(table, val)
    if #table > 0 then
        for i=1, #table do
            if table[i] == val then
                return i
            end
        end
    end
    return 0
end

local function normalize_yaw(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return yaw
end

local function calc_angle(localplayerxpos, localplayerypos, enemyxpos, enemyypos)
	local ydelta = localplayerypos - enemyypos
	local xdelta = localplayerxpos - enemyxpos
    local relativeyaw = math_atan( ydelta / xdelta )
	relativeyaw = normalize_yaw( relativeyaw * 180 / math.pi )
	if xdelta >= 0 then
		relativeyaw = normalize_yaw(relativeyaw + 180)
	end
    return relativeyaw
end

local function enemy_visible(idx)
    for i=0, 8 do
        local cx, cy, cz = entity_hitbox_position(idx, i)
        if client_visible(cx, cy, cz) then
            return true
        end
    end
    return false
end

local failed = false
local print_once = false

local plist_set, plist_get = plist.set, plist.get

local timer = 20
local function run_adjustments()

    local plocal = entity_get_local_player()

    timer = timer + 1

    if timer >= 20 then
    
        timer = 0
    end

    if not entity_is_alive(plocal) or not ui_get(master_switch)  then
        return
    end

    local doubletap_md = ui_get(ref_doubletap) and ui_get(ref_doubletapkey) and contains(ui_get(rage[active_idx].custom_damage), "Double tap")

    local players = entity_get_players(true)

    if #players == 0  then
        min_damage = doubletap_md and "dt" or "default"
        return
    end

    local lox, loy, loz = entity_get_prop(plocal, "m_vecOrigin")

    local enemies_visible = false

    for i=1, #players do

        local idx = players[i]

        if enemy_visible(idx) then
            enemies_visible = true
        end
        
        local pitch, yaw, roll = entity_get_prop(idx, "m_angEyeAngles")
        local enemy_high_pitch, enemy_side_ways = false, false

        if high_pitch then
            if pitch ~= nil then
                enemy_high_pitch = pitch < 10
            end
        end

        if side_ways then
            local eox, eoy, eoz = entity_get_prop(idx, "m_vecOrigin")
            if eox ~= nil and yaw ~= nil then

                local at_targets = normalize_yaw(calc_angle(lox, loy, eox, eoy) + 180)
                local left_delta = math_abs(normalize_yaw(yaw - (at_targets - 90)))
                local right_delta = math_abs(normalize_yaw(yaw - (at_targets + 90)))
                enemy_side_ways = left_delta < 30 or right_delta < 30
            end
        end

        local enemy_baim = enemy_high_pitch or enemy_side_ways
        plist_set(idx, "Override prefer body aim", enemy_baim and "Off" or "-")

        if ui_get(prioritize_awp) then
            local weapon = entity_get_player_weapon(idx)
            if weapon ~= nil then
                local weapon_id = bit_band(entity_get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)
                plist_set(idx, "High priority", config_names[weapon_idx[weapon_id]] == "AWP")
            end
        end
    end

    if doubletap_md then
        min_damage = "dt"
    elseif contains(ui_get(rage[active_idx].custom_damage), "Visible") then
        min_damage = enemies_visible and "visible" or "wall"
    else
        min_damage = "default"
    end
end

local function run_visuals()
    local plocal = entity_get_local_player()

    if not entity_is_alive(plocal) or not ui_get(master_switch) then
        return
    end

    local sx, sy = client_screen_size()
    local cx, cy = sx / 2, sy / 2

    if ui_get(ovr_key) and entity_is_alive(plocal) then
        renderer_text(cx + 19, cy - 30, 255, 255, 255, 255, "b", 0, tostring(ui_get(ref_mindamage)))
    end
end

local function handle_menu()
    local enabled = ui_get(master_switch)
    ui_set_visible(active_wpn, enabled)
    ui_set_visible(ovr_key, enabled)
    ui_set_visible(ovr_head, enabled)
    ui_set_visible(global_dt_hc, enabled)
    ui_set_visible(prioritize_awp, enabled)
    for i=1, #config_names do
        local show = ui_get(active_wpn) == config_names[i] and enabled

        ui_set_visible(rage[i].enabled, show and i > 1)
        ui_set_visible(rage[i].target_selection, show)
        ui_set_visible(rage[i].target_hitbox, show)
        ui_set_visible(rage[i].multipoint, show)
        ui_set_visible(rage[i].multipoint_scale, show and #{ui_get(rage[i].multipoint)} > 0)
        ui_set_visible(rage[i].multimode, show and #{ui_get(rage[i].multipoint)} > 0)
        ui_set_visible(rage[i].dt_mp_enable, show)
        ui_set_visible(rage[i].dt_multipoint, show and ui_get(rage[i].dt_mp_enable))
        ui_set_visible(rage[i].dt_multimode, show and ui_get(rage[i].dt_mp_enable) and #{ui_get(rage[i].multipoint)} > 0)
        ui_set_visible(rage[i].dt_multipoint_scale, show and ui_get(rage[i].dt_mp_enable) and #{ui_get(rage[i].multipoint)} > 0)
        ui_set_visible(rage[i].prefer_safe_point, show)
        ui_set_visible(rage[i].dt_prefer_safe_point, show)
        ui_set_visible(rage[i].force_safe_point_onlimbs, show)
        ui_set_visible(rage[i].force_safe_point, show)
        ui_set_visible(rage[i].automatic_fire, show)
        ui_set_visible(rage[i].automatic_penetration, show)
        ui_set_visible(rage[i].hitchance, show)
        ui_set_visible(rage[i].air_hc_enable, show)
        ui_set_visible(rage[i].hitchance_air, show and ui_get(rage[i].air_hc_enable))
        ui_set_visible(rage[i].custom_damage, show)
        ui_set_visible(rage[i].min_damage, show and not contains(ui_get(rage[i].custom_damage), "Visible"))
        ui_set_visible(rage[i].vis_min_damage, show and contains(ui_get(rage[i].custom_damage), "Visible"))
        ui_set_visible(rage[i].wall_min_damage, show and contains(ui_get(rage[i].custom_damage), "Visible"))
        ui_set_visible(rage[i].dt_min_damage, show and contains(ui_get(rage[i].custom_damage), "Double tap"))
        ui_set_visible(rage[i].ovr_min_damage, show and contains(ui_get(rage[i].custom_damage), "On-key"))
        ui_set_visible(rage[i].automatic_scope, show)
        ui_set_visible(rage[i].accuracy_boost, show)
        ui_set_visible(rage[i].delay_shot, show)
        ui_set_visible(rage[i].quick_stop, show)
        ui_set_visible(rage[i].quick_stop_options, show and ui_get(rage[i].quick_stop))
        ui_set_visible(rage[i].prefer_baim, show)
        ui_set_visible(rage[i].prefer_baim_disablers, show and ui_get(rage[i].prefer_baim))
        ui_set_visible(rage[i].force_baim_peek, show)
        ui_set_visible(rage[i].doubletap, show)
        ui_set_visible(rage[i].doubletap_hc, show and ui_get(rage[i].doubletap) and not ui_get(global_dt_hc))
        ui_set_visible(rage[i].doubletap_stop, show and ui_get(rage[i].doubletap))
    end
end
handle_menu()

local function set_config(idx)
    local i = ui_get(rage[idx].enabled) and idx or 1

    custom_damage = #{ui_get(rage[i].custom_damage)} > 0

    local rage_hitboxes = ui_get(rage[i].target_hitbox)

    if #rage_hitboxes == 0 then
        ui_set(rage[i].target_hitbox, "Head")
    end

    local table_prefer_baim = ui_get(rage[i].prefer_baim_disablers)
    
    high_pitch = contains(table_prefer_baim, "High pitch")

    if high_pitch then
        table_remove(table_prefer_baim, pos_in_table(table_prefer_baim, "High pitch"))
    end

    side_ways = contains(table_prefer_baim, "Sideways")

    if side_ways then
        table_remove(table_prefer_baim, pos_in_table(table_prefer_baim, "Sideways"))
    end

    local damage_val = ui_get(rage[i].vis_min_damage)

    if custom_damage then
        if not ui_get(ovr_key) or not contains(ui_get(rage[i].custom_damage), "On-key") then
            if min_damage == "wall" then
                damage_val = ui_get(rage[i].wall_min_damage)
            elseif min_damage == "dt" then
                damage_val = ui_get(rage[i].dt_min_damage)
            elseif min_damage == "default" then
                damage_val = ui_get(rage[i].min_damage)
            end
        else
            damage_val = ui_get(rage[i].ovr_min_damage)
        end
    else
        damage_val = ui_get(rage[i].min_damage)
    end

    local onground = (bit_band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) == 1)

    local hc_val = (ui_get(rage[i].air_hc_enable) and not onground)
        and ui_get(rage[i].hitchance_air) or ui_get(rage[i].hitchance)

    local doubletapping = ui_get(ref_doubletap) and ui_get(ref_doubletapkey)
    local custom_mp = ui_get(rage[i].dt_mp_enable) and doubletapping  
    local custom_psp = ui_get(rage[i].dt_prefer_safe_point) and doubletapping

    local mp_val = custom_mp and ui_get(rage[i].dt_multipoint) or ui_get(rage[i].multipoint)
    local mps_val = custom_mp and ui_get(rage[i].dt_multipoint_scale) or ui_get(rage[i].multipoint_scale)
    local mpm_val = custom_mp and ui_get(rage[i].dt_multimode) or ui_get(rage[i].multimode)

    ui_set(ref_target_selection, ui_get(rage[i].target_selection))
    ui_set(ref_target_hitbox, ui_get(ovr_head) and "Head" or ui_get(rage[i].target_hitbox))
    ui_set(ref_multipoint, mp_val)
    ui_set(ref_multipoint_scale, mps_val)
    ui_set(ref_multipoint_mode, mpm_val)
    ui_set(ref_prefer_safepoint, custom_psp and true or ui_get(rage[i].prefer_safe_point))
    ui_set(ref_force_safepoint, ui_get(rage[i].force_safe_point) and "Always on" or "On hotkey")
    ui_set(ref_automatic_fire, ui_get(rage[i].automatic_fire))
    ui_set(ref_automatic_penetration, ui_get(rage[i].automatic_penetration))
    ui_set(ref_hitchance, hc_val)
    ui_set(ref_mindamage, damage_val)
    ui_set(ref_automatic_scope, ui_get(rage[i].automatic_scope))
    ui_set(ref_accuracy_boost, ui_get(rage[i].accuracy_boost))
    ui_set(ref_delay_shot, ui_get(rage[i].delay_shot))
    ui_set(ref_quickstop, ui_get(rage[i].quick_stop))
    ui_set(ref_quickstop_options, ui_get(rage[i].quick_stop_options))
    ui_set(ref_prefer_bodyaim, ui_get(rage[i].prefer_baim))
    ui_set(ref_prefer_bodyaim_disablers, table_prefer_baim)
    ui_set(ref_force_baim_peek, ui_get(rage[i].force_baim_peek))
    ui_set(ref_doubletap, ui_get(rage[i].doubletap))
    if not ui_get(global_dt_hc) then
        ui_set(ref_doubletap_hc, ui_get(rage[i].doubletap_hc))
    end
    ui_set(ref_doubletap_stop, ui_get(rage[i].doubletap_stop))
    active_idx = i
end

client_set_event_callback("setup_command", function(c)
    local plocal = entity_get_local_player()
    local weapon = entity_get_player_weapon(plocal)
    local weapon_id = bit_band(entity_get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)

    local wpn_text = config_names[weapon_idx[weapon_id]]

    if wpn_text ~= nil then
        if last_weapon ~= weapon_id then
            ui_set(active_wpn, ui_get(rage[weapon_idx[weapon_id]].enabled) and wpn_text or "Global")
            last_weapon = weapon_id
        end
        set_config(weapon_idx[weapon_id])
    else
        if last_weapon ~= weapon_id then
            ui_set(active_wpn, "Global")
            last_weapon = weapon_id
        end
        set_config(1)
    end
end)

client_set_event_callback("paint", run_adjustments)
client_set_event_callback("paint", run_visuals)

local function init_callbacks()
    ui_set_callback(master_switch, handle_menu)
    ui_set_callback(active_wpn, handle_menu)

    for i=1, #config_names do
        ui_set_callback(rage[i].multipoint, handle_menu)
        ui_set_callback(rage[i].prefer_baim, handle_menu)
        ui_set_callback(rage[i].quick_stop, handle_menu)
        ui_set_callback(rage[i].dt_mp_enable, handle_menu)
        ui_set_callback(rage[i].air_hc_enable, handle_menu)
        ui_set_callback(rage[i].custom_damage, handle_menu)
        ui_set_callback(rage[i].doubletap, handle_menu)
    end
end

init_callbacks() 