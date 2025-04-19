-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_visible, entity_hitbox_position, math_ceil, math_pow, math_sqrt, renderer_indicator, unpack, tostring, pairs = client.visible, entity.hitbox_position, math.ceil, math.pow, math.sqrt, renderer.indicator, unpack, tostring, pairs
local ui_new_label, ui_reference, ui_new_checkbox, ui_new_combobox, ui_new_hotkey, ui_new_multiselect, ui_new_slider, ui_set, ui_get, ui_set_callback, ui_set_visible = ui.new_label, ui.reference, ui.new_checkbox, ui.new_combobox, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.set, ui.get, ui.set_callback, ui.set_visible
local client_log, client_color_log, client_set_event_callback, client_unset_event_callback = client.log, client.color_log, client.set_event_callback, client.unset_event_callback
local entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_is_alive = entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.is_alive
local bit_band = bit.band
local client_screen_size, renderer_text = client.screen_size, renderer.text
local config_names = { "Global", "Taser", "Revolver", "Pistol", "Auto", "Scout", "AWP", "Rifle", "SMG", "Shotgun", "Deagle" }
local name_to_num = { ["Global"] = 1, ["Taser"] = 2, ["Revolver"] = 3, ["Pistol"] = 4, ["Auto"] = 5, ["Scout"] = 6, ["AWP"] = 7, ["Rifle"] = 8, ["SMG"] = 9, ["Shotgun"] = 10, ["Deagle"] = 11 }
local weapon_idx = { [1] = 11, [2] = 4,[3] = 4,[4] = 4,[7] = 8,[8] = 8,[9] = 7,[10] = 8,[11] = 5,[13] = 8,[14] = 8,[16] = 8,[17] = 9,[19] = 9,[23] = 9,[24] = 9,[25] = 10,[26] = 9,[27] = 10,[28] = 8,[29] = 10,[30] = 4,[31] = 2,  [32] = 4,[33] = 9,[34] = 9,[35] = 10,[36] = 4,[38] = 5,[39] = 8,[40] = 6,[60] = 8,[61] = 4,[63] = 4,[64] = 3}
local damage_idx  = { [0] = "Auto", [101] = "HP + 1", [102] = "HP + 2", [103] = "HP + 3", [104] = "HP + 4", [105] = "HP + 5", [106] = "HP + 6", [107] = "HP + 7", [108] = "HP + 8", [109] = "HP + 9", [110] = "HP + 10", [111] = "HP + 11", [112] = "HP + 12", [113] = "HP + 13", [114] = "HP + 14", [115] = "HP + 15", [116] = "HP + 16", [117] = "HP + 17", [118] = "HP + 18", [119] = "HP + 19", [120] = "HP + 20", [121] = "HP + 21", [122] = "HP + 22", [123] = "HP + 23", [124] = "HP + 24", [125] = "HP + 25", [126] = "HP + 26" }
local min_damage, last_weapon = "visible", 0

local master_switch = ui_new_checkbox("LUA", "A", "Enable sigma adaptive wpn")
local ovr_key = ui_new_hotkey("LUA", "A", "Override minimum damage key")
local ovr_hc_key = ui_new_hotkey("LUA", "A", "Override hit chance key")


local active_wpn = ui_new_combobox("LUA", "A", "View weapon", config_names)

local target_hitbox_ovr = ui_new_multiselect("LUA", "A", "Target hitbox override", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" })
local target_hitbox_ovr_key = ui_new_hotkey("LUA", "A", "Target hitbox override key", true)

local unsafe_ovr = ui_new_multiselect("LUA", "A", "Avoid unsafe hitboxes override", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" })
local unsafe_ovr_key = ui_new_hotkey("LUA", "A", "Avoid unsafe hitboxes override key", true)

local global_dt_hc = ui_new_checkbox("LUA", "A", "Global double tap hitchance")



local rage = {}
local active_idx = 1
local scoped_wpn_idx = {
    name_to_num["Scout"],
    name_to_num["Auto"],
    name_to_num["AWP"],
    
}
for i=1, #config_names do
    rage[i] = {
        enabled = ui_new_checkbox("LUA", "A", "Enable " .. config_names[i] .. " config"),
        target_selection = ui_new_combobox("LUA", "A", "[" .. config_names[i] .. "] Target selection", {"Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"}),
        --accuracy_boost = ui_new_combobox("LUA", "A", "[" .. config_names[i] .. "] Accuracy boost", {"Off", "Low", "Medium", "High", "Maximum"}),
        target_hitbox = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] Target hitbox", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        multipoint = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] Multi-point", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        --multimode = ui_new_combobox("LUA", "A", "\n[" .. config_names[i] .. "] Multi-point mode", { "Low", "Medium", "High" }),
        multipoint_scale = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Multi-point scale", 24, 100, 60, true, "%", 1, { [24] = "Auto" }),
		unsafe = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] Avoid unsafe hitboxes", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        dt_mp_enable = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Custom DT multipoint"),
        dt_multipoint = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] DT Multi-point", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),   
        dt_multimode = ui_new_combobox("LUA", "A", "\n[" .. config_names[i] .. "] DT Multi-point mode", { "Low", "Medium", "High" }),   
        dt_multipoint_scale = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] DT Multi-point scale", 24, 100, 60, true, "%", 1, { [24] = "Auto" }),
        prefer_safe_point = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Prefer safe point"),
        dt_prefer_safe_point = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Prefer safe point on DT"),
        automatic_fire = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Automatic fire"),
        automatic_penetration = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Automatic penetration"),
        automatic_scope = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Automatic scope"),
        silent_aim = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Silent aim"),
        hitchance = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Hitchance", 0, 100, 50, true, "%", 1, {"Off"}),
        hitchance_ovr = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Hitchance override", 0, 100, 50, true, "%", 1, {"Off"}),        
        ns_hitchance = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Noscope hitchance", 0, 100, 50, true, "%", 1, {"Off"}),
        air_hc_enable = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Custom hitchance in air"),
        hitchance_air = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Hitchance in air", 0, 100, 50, true, "%", 1, {"Off"}),
        custom_damage = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] Custom min damage", { "Visible", "Double tap", "On-key" }),
        min_damage = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Minimum damage", 0, 126, 20, true, nil, 1, damage_idx),
        vis_min_damage = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Visible min damage", 0, 126, 20, true, nil, 1, damage_idx),
        wall_min_damage = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Autowall min damage", 0, 126, 20, true, nil, 1, damage_idx),
        dt_min_damage = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Double tap min damage", 0, 126, 20, true, nil, 1, damage_idx),
        ovr_min_damage = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] On-key min damage", 0, 126, 20, true, nil, 1, damage_idx),
        ovr_min_damage2 = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] On-key 2 min damage", -1, 126, -1, true, nil, 1, {[-1] = "Disabled", unpack(damage_idx)}),

        quick_stop = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Quick stop"),
        quick_stop_options = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] Quick stop options", {"Early", "Slow motion", "Duck", "Fake duck", "Move between shots", "Ignore molotov", "Taser"}),
        
        quick_stop_ns = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Quick stop noscope"),
        quick_stop_options_ns = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] Quick stop options ns", {"Early", "Slow motion", "Duck", "Fake duck", "Move between shots", "Ignore molotov", "Taser"}),
        
        prefer_baim = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Prefer body aim"),
        prefer_baim_disablers = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] Prefer body aim disablers", {"Low inaccuracy", "Target shot fired", "Target resolved", "Safe point headshot", "Low damage"}),
        delay_shot = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Delay shot"),
        force_baim_peek = ui_new_checkbox("LUA", "A", "[" .. config_names[i] .. "] Force body aim on peek"),
        doubletap_hc = ui_new_slider("LUA", "A", "[" .. config_names[i] .. "] Double tap hit chance", 0, 100, 0, true, "%", 1),
        doubletap_stop = ui_new_multiselect("LUA", "A", "[" .. config_names[i] .. "] Double tap quick stop", { "Slow motion", "Duck", "Move between shots" }),
    }
end
rage[scoped_wpn_idx[1]].js_settings = ui_new_checkbox("LUA", "A", "[Scout] Jump Scout settings")
rage[scoped_wpn_idx[1]].js_target_hitbox = ui_new_multiselect("LUA", "A", "[Jump Scout] Target hitbox", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" })
rage[scoped_wpn_idx[1]].js_multipoint = ui_new_multiselect("LUA", "A", "[Jump Scout] Multi-point", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" })
rage[scoped_wpn_idx[1]].js_multimode = ui_new_combobox("LUA", "A", "\n[Jump Scout] Multi-point mode", { "Low", "Medium", "High" })
rage[scoped_wpn_idx[1]].js_multipoint_scale = ui_new_slider("LUA", "A", "[Jump Scout] Multi-point scale", 24, 100, 60, true, "%", 1, { [24] = "Auto" })
rage[scoped_wpn_idx[1]].js_unsafe = ui_new_multiselect("LUA", "A", "[Jump Scout] Avoid unsafe hitboxes", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" })
rage[scoped_wpn_idx[1]].js_prefer_safe_point = ui_new_checkbox("LUA", "A", "[Jump Scout] Prefer safe point")
rage[scoped_wpn_idx[1]].js_automatic_scope = ui_new_checkbox("LUA", "A", "[Jump Scout] Automatic scope")
rage[scoped_wpn_idx[1]].js_hitchance = ui_new_slider("LUA", "A", "[Jump Scout] Hitchance", 0, 100, 50, true, "%", 1, {"Off"})
rage[scoped_wpn_idx[1]].js_min_damage = ui_new_slider("LUA", "A", "[Jump Scout] Minimum damage", 0, 126, 20, true, nil, 1, damage_idx)
rage[scoped_wpn_idx[1]].js_quick_stop = ui_new_checkbox("LUA", "A", "[Jump Scout] Quick stop")
rage[scoped_wpn_idx[1]].js_quick_stop_options = ui_new_multiselect("LUA", "A", "[Jump Scout] Quick stop options", {"Early", "Slow motion", "Duck", "Fake duck", "Move between shots", "Ignore molotov", "Taser"})
rage[scoped_wpn_idx[1]].js_prefer_baim = ui_new_checkbox("LUA", "A", "[Jump Scout] Prefer body aim")
rage[scoped_wpn_idx[1]].js_prefer_baim_disablers = ui_new_multiselect("LUA", "A", "[Jump Scout] Prefer body aim disablers", {"Low inaccuracy", "Target shot fired", "Target resolved", "Safe point headshot", "Low damage"})
rage[scoped_wpn_idx[1]].js_delay_shot = ui_new_checkbox("LUA", "A", "[Jump Scout] Delay shot")
rage[scoped_wpn_idx[1]].js_force_baim_peek = ui_new_checkbox("LUA", "A", "[Jump Scout] Force body aim on peek")

rage[scoped_wpn_idx[2]].doubletap_stop_ns = ui_new_multiselect("LUA", "A", "[Auto] Double tap quick stop noscope", { "Slow motion", "Duck", "Move between shots" })

local lethal_rev = ui_new_checkbox("LUA", "A", "Lethal revolver damage")
local prioritize_awp = ui_new_checkbox("LUA", "A", "Prioritize awpers")

--References
local ref_enabled, ref_enabledkey = ui_reference("RAGE", "Aimbot", "Enabled")
local ref_target_selection = ui_reference("RAGE", "Aimbot", "Target selection")
local ref_target_hitbox = ui_reference("RAGE", "Aimbot", "Target hitbox")
local ref_multipoint, ref_multipointkey = ui_reference("RAGE", "Aimbot", "Multi-point")
local ref_unsafe = ui_reference("RAGE", "Aimbot", "Avoid unsafe hitboxes")
local ref_multipoint_scale = ui_reference("RAGE", "Aimbot", "Multi-point scale")
local ref_prefer_safepoint = ui_reference("RAGE", "Aimbot", "Prefer safe point")
local ref_force_safepoint = ui_reference("RAGE", "Aimbot", "Force safe point")
local ref_automatic_fire = ui_reference("RAGE", "Other", "Automatic fire")
local ref_automatic_penetration = ui_reference("RAGE", "Other", "Automatic penetration")
local ref_silent_aim = ui_reference("RAGE", "Other", "Silent aim")
local ref_hitchance = ui_reference("RAGE", "Aimbot", "Minimum hit chance")
local ref_mindamage = ui_reference("RAGE", "Aimbot", "Minimum damage")
local ref_automatic_scope = ui_reference("RAGE", "Aimbot", "Automatic scope")
local ref_reduce_aimstep = ui_reference("RAGE", "Other", "Reduce aim step")
local ref_log_spread = ui_reference("RAGE", "Other", "Log misses due to spread")
local ref_low_fps_mitigations = ui_reference("RAGE", "Other", "Low FPS mitigations")
local ref_remove_recoil = ui_reference("RAGE", "Other", "Remove recoil")
local ref_accuracy_boost = ui_reference("RAGE", "Other", "Accuracy boost")
local ref_delay_shot = ui_reference("RAGE", "Other", "Delay shot")
local ref_quickstop, ref_quickstopkey, ref_quickstop_options = ui_reference("RAGE", "Aimbot", "Quick stop")
--local ref_quickstop_options = ui_reference("RAGE", "Other", "Quick stop options")
local ref_quickpeek, ref_quickpeek_key, ref_quickpeek_mode = ui_reference("RAGE", "Other", "Quick peek assist")
local ref_antiaim_correction = ui_reference("RAGE", "Other", "Anti-aim correction")
--local ref_antiaim_correction_override = ui_reference("RAGE", "Other", "Anti-aim correction override")
local ref_prefer_bodyaim = ui_reference("RAGE", "Aimbot", "Prefer body aim")
local ref_prefer_bodyaim_disablers = ui_reference("RAGE", "Aimbot", "Prefer body aim disablers")
local ref_force_baim_peek = ui_reference("RAGE", "Aimbot", "Force body aim on peek")
local ref_force_bodyaim = ui_reference("RAGE", "Aimbot", "Force body aim")
local ref_duck_peek_assist = ui_reference("RAGE", "Other", "Duck peek assist")
local ref_doubletap, ref_doubletapkey  = ui_reference("RAGE", "Aimbot", "Double tap")
local ref_slowwalk, ref_slowwalk_key = ui_reference("AA", "Other", "Slow motion")
local ref_osaa, ref_osaakey = ui_reference("AA", "Other", "On shot anti-aim")
local ref_doubletap_hc = ui_reference("RAGE", "Aimbot", "Double tap hit chance")
local ref_doubletap_stop = ui_reference("RAGE", "Aimbot", "Double tap quick stop")
--local ref_doubletap_mode = ui_reference("RAGE", "Aimbot", "Double tap mode", { "Slow motion", "Duck", "Move between shots" })

local in_speed

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

local function enemy_visible(idx)
    for i=0, 8 do
        local cx, cy, cz = entity_hitbox_position(idx, i)
        if client_visible(cx, cy, cz) then
            return true
        end
    end
    return false
end

local plist_set, plist_get = plist.set, plist.get

--#region rev lethal
local function Vector(x,y,z) 
	return {x=x or 0,y=y or 0,z=z or 0} 
end

local function Distance(from_x,from_y,from_z,to_x,to_y,to_z)  
  return math_ceil(math_sqrt(math_pow(from_x - to_x, 2) + math_pow(from_y - to_y, 2) + math_pow(from_z - to_z, 2)))
end

local function check_revolver_distance(player,victim)
	if player == nil then return end
	if victim == nil then return end
	
    local weap = entity.get_prop(entity.get_prop(player, "m_hActiveWeapon"), "m_iItemDefinitionIndex")
	if weap == nil then return end
	local vnum = bit.band(weap, 0xFFFF)
	local player_origin = Vector(entity.get_prop(player, "m_vecOrigin"))
	local victim_origin = Vector(entity.get_prop(victim, "m_vecOrigin"))


	local units = Distance(player_origin.x, player_origin.y, player_origin.z, victim_origin.x, victim_origin.y, victim_origin.z)
	local no_kevlar = entity.get_prop(victim, "m_ArmorValue") == 0	

	if not (vnum == 64 and no_kevlar) then
		return 0
    end
    
    if units < 585 and units > 511 then
		return 1
    elseif units < 511 then
		return 2
    else
		return 0
	end
end

local local_player

local ovr_key_state
local ovr_selected = 0
local ovr_add_disabled

local function handle_ovr()
    local ovr_k_temp = ui_get(ovr_key)
    if ovr_k_temp ~= ovr_key_state then 
        if ovr_add_disabled then 
            ovr_selected = ovr_selected == 0 and 1 or 0
        else
            ovr_selected = ovr_selected ~= 2 and ovr_selected + 1 or 0
        end
        ovr_key_state = ovr_k_temp
    end
end

local lethal_rev_active
local function run_adjustments()


    local players = entity_get_players(true)
    local visible_md = contains(ui_get(rage[active_idx].custom_damage), "Visible")
    local doubletap_md = ui_get(ref_doubletap) and ui_get(ref_doubletapkey) and contains(ui_get(rage[active_idx].custom_damage), "Double tap")

    if #players == 0 then
        min_damage = doubletap_md and "dt" or "default"
        return
    end

    local revolver
    local enemies_visible = false

    for i=1, #players do
        local entindex = players[i]	
		revolver = check_revolver_distance(local_player,entindex)
	

        if ui_get(prioritize_awp) then
            local weapon = entity_get_player_weapon(entindex)
            if weapon ~= nil then
                local weapon_id = bit_band(entity_get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)
                plist_set(entindex, "High priority", config_names[weapon_idx[weapon_id]] == "AWP")
            end
        end


        if visible_md and enemy_visible(entindex) then
            enemies_visible = true
        end
        
    end

    lethal_rev_active = false

    if revolver == 2 then
        min_damage = "lethal_rev"
        lethal_rev_active = true
    elseif doubletap_md then
        min_damage = "dt"
    elseif visible_md then
        min_damage = enemies_visible and "visible" or "wall"
    else
        min_damage = "default"
    end
end

local function run_visuals()
    local sx, sy = client_screen_size()
    local cx, cy = sx / 2, sy / 2

    if (ovr_selected ~= 0 and contains(ui_get(rage[active_idx].custom_damage), "On-key")) or (lethal_rev_active and ui_get(lethal_rev)) then
        renderer_text(cx + 2, cy -14, 255, 255, 255, 255, "d", 0, tostring(ui_get(ref_mindamage)))
	end

    if ui_get(unsafe_ovr_key) then
        renderer_indicator(255, 255, 255, 255, "UNSAFE OVR")
	end
	
	if ui_get(target_hitbox_ovr_key) then
		renderer_indicator(255, 255, 255, 255, "HITBOX OVR")
	end
	
	if ui_get(ovr_hc_key) then
		renderer_indicator(255, 255, 255, 255, "HITCHANCE OVR")
	end
end

local function handle_menu()
    local enabled = ui_get(master_switch)
    ui_set_visible(active_wpn, enabled)
    ui_set_visible(ovr_key, enabled)
    ui_set_visible(ovr_hc_key, enabled)
    ui_set_visible(unsafe_ovr, enabled)
    ui_set_visible(unsafe_ovr_key, enabled)
    ui_set_visible(target_hitbox_ovr, enabled)
    ui_set_visible(target_hitbox_ovr_key, enabled)
    ui_set_visible(global_dt_hc, enabled)
    ui_set_visible(prioritize_awp, enabled)
    ui_set_visible(lethal_rev, enabled)

    for i=1, #config_names do
        local show = ui_get(active_wpn) == config_names[i] and enabled

        ui_set_visible(rage[i].enabled, show and i > 1)
        ui_set_visible(rage[i].target_selection, show)
        ui_set_visible(rage[i].target_hitbox, show)
        ui_set_visible(rage[i].multipoint, show)
		ui_set_visible(rage[i].unsafe, show)
        --ui_set_visible(rage[i].multimode, show and #{unpack(ui_get(rage[i].multipoint))} > 0)
        ui_set_visible(rage[i].multipoint_scale, show and #{unpack(ui_get(rage[i].multipoint))} > 0)
        ui_set_visible(rage[i].dt_mp_enable, show)
        ui_set_visible(rage[i].dt_multipoint, show and ui_get(rage[i].dt_mp_enable))
        ui_set_visible(rage[i].dt_multimode, show and ui_get(rage[i].dt_mp_enable) and #{unpack(ui_get(rage[i].multipoint))} > 0)
        ui_set_visible(rage[i].dt_multipoint_scale, show and ui_get(rage[i].dt_mp_enable) and #{unpack(ui_get(rage[i].multipoint))} > 0)
        ui_set_visible(rage[i].prefer_safe_point, show)
        ui_set_visible(rage[i].dt_prefer_safe_point, show)
        ui_set_visible(rage[i].automatic_fire, show)
        ui_set_visible(rage[i].automatic_penetration, show)
        ui_set_visible(rage[i].silent_aim, show)
        ui_set_visible(rage[i].hitchance, show)
        ui_set_visible(rage[i].hitchance_ovr, show)
        ui_set_visible(rage[i].ns_hitchance, show and contains(scoped_wpn_idx, i))
        ui_set_visible(rage[i].air_hc_enable, show)
        ui_set_visible(rage[i].hitchance_air, show and ui_get(rage[i].air_hc_enable))
        ui_set_visible(rage[i].custom_damage, show)
        ui_set_visible(rage[i].min_damage, show and not contains(ui_get(rage[i].custom_damage), "Visible"))
        ui_set_visible(rage[i].vis_min_damage, show and contains(ui_get(rage[i].custom_damage), "Visible"))
        ui_set_visible(rage[i].wall_min_damage, show and contains(ui_get(rage[i].custom_damage), "Visible"))
        ui_set_visible(rage[i].dt_min_damage, show and contains(ui_get(rage[i].custom_damage), "Double tap"))
        ui_set_visible(rage[i].ovr_min_damage, show and contains(ui_get(rage[i].custom_damage), "On-key"))
        ui_set_visible(rage[i].ovr_min_damage2, show and contains(ui_get(rage[i].custom_damage), "On-key"))

        
        ui_set_visible(rage[i].automatic_scope, show)
        --ui_set_visible(rage[i].accuracy_boost, show)
        ui_set_visible(rage[i].delay_shot, show)
        ui_set_visible(rage[i].quick_stop, show)
        ui_set_visible(rage[i].quick_stop_options, show and ui_get(rage[i].quick_stop))

        ui_set_visible(rage[i].quick_stop_ns, show and ui_get(active_wpn) == "Auto")
        ui_set_visible(rage[i].quick_stop_options_ns, show and ui_get(rage[i].quick_stop_ns) and ui_get(active_wpn) == "Auto")

        ui_set_visible(rage[i].prefer_baim, show)
        ui_set_visible(rage[i].prefer_baim_disablers, show and ui_get(rage[i].prefer_baim))
        ui_set_visible(rage[i].force_baim_peek, show)
        ui_set_visible(rage[i].doubletap_hc, show and ui_get(ref_doubletap) and not ui_get(global_dt_hc))
        ui_set_visible(rage[i].doubletap_stop, show and ui_get(ref_doubletap))
    end

    ui_set_visible(rage[scoped_wpn_idx[1]].js_settings, enabled and ui_get(active_wpn) == "Scout")
    local js_enable = ui_get(rage[scoped_wpn_idx[1]].js_settings) and enabled and ui_get(active_wpn) == "Scout"

    ui_set_visible(rage[scoped_wpn_idx[1]].js_target_hitbox, js_enable)
    ui_set_visible(rage[scoped_wpn_idx[1]].js_multipoint, js_enable)
    ui_set_visible(rage[scoped_wpn_idx[1]].js_multimode, js_enable and #{unpack(ui_get(rage[scoped_wpn_idx[1]].js_multipoint))} > 0)
    ui_set_visible(rage[scoped_wpn_idx[1]].js_multipoint_scale, js_enable and #{unpack(ui_get(rage[scoped_wpn_idx[1]].js_multipoint))} > 0)
    ui_set_visible(rage[scoped_wpn_idx[1]].js_unsafe, js_enable)
    ui_set_visible(rage[scoped_wpn_idx[1]].js_prefer_safe_point, js_enable)
    ui_set_visible(rage[scoped_wpn_idx[1]].js_automatic_scope, js_enable)
    ui_set_visible(rage[scoped_wpn_idx[1]].js_hitchance, js_enable)
    ui_set_visible(rage[scoped_wpn_idx[1]].js_min_damage, js_enable)
    ui_set_visible(rage[scoped_wpn_idx[1]].js_quick_stop, js_enable)
    ui_set_visible(rage[scoped_wpn_idx[1]].js_quick_stop_options, js_enable and ui_get(rage[scoped_wpn_idx[1]].js_quick_stop))
    ui_set_visible(rage[scoped_wpn_idx[1]].js_prefer_baim, js_enable)
    ui_set_visible(rage[scoped_wpn_idx[1]].js_prefer_baim_disablers, js_enable and ui_get(rage[scoped_wpn_idx[1]].js_prefer_baim))
    ui_set_visible(rage[scoped_wpn_idx[1]].js_delay_shot, js_enable)
    ui_set_visible(rage[scoped_wpn_idx[1]].js_force_baim_peek, js_enable)   

    ui_set_visible(rage[scoped_wpn_idx[2]].doubletap_stop_ns, enabled and ui_get(ref_doubletap) and ui_get(active_wpn) == "Auto")   

    

end
handle_menu()

local function set_config(idx)
    local i = ui_get(rage[idx].enabled) and idx or 1
    local custom_damage = #{ui_get(rage[i].custom_damage)} > 0
    local target_hitboxes = ui_get(rage[i].target_hitbox)
    local target_hitboxes_ovr = ui_get(target_hitbox_ovr)

    if #target_hitboxes == 0 then
        ui_set(rage[i].target_hitbox, "Head")
    end

    if #target_hitboxes_ovr == 0 then
        ui_set(target_hitbox_ovr, "Head")
    end

    local damage_val = ui_get(rage[i].min_damage)
    local onground = (bit_band(entity_get_prop(local_player, "m_fFlags"), 1) == 1)
    local is_scoped = entity_get_prop(entity_get_player_weapon(local_player), "m_zoomLevel" )

    local js_selected = i == scoped_wpn_idx[1] and ui_get(rage[scoped_wpn_idx[1]].js_settings)
    local js_state = false

    if js_selected then
        if #{unpack(ui_get(rage[scoped_wpn_idx[1]].js_target_hitbox))} == 0 then
            ui_set(rage[scoped_wpn_idx[1]].js_target_hitbox, "Head")
        end
        js_state = (in_speed or (ui_get(ref_slowwalk) and ui_get(ref_slowwalk_key))) and not onground
    end


    if min_damage == "lethal_rev" and ui_get(lethal_rev) and onground then
        damage_val = 100
    elseif custom_damage then
        if ovr_selected == 0  or not contains(ui_get(rage[i].custom_damage), "On-key") then
            if min_damage == "wall" then
                damage_val = ui_get(rage[i].wall_min_damage)
            elseif min_damage == "dt" then
                damage_val = ui_get(rage[i].dt_min_damage)
            elseif min_damage == "visible" then
                damage_val = ui_get(rage[i].vis_min_damage)
            elseif min_damage == "default" then
                damage_val = ui_get(rage[i].min_damage)
            end
        else
            ovr_add_disabled = ui_get(rage[i].ovr_min_damage2) == -1

            damage_val = ovr_add_disabled and ui_get(rage[i].ovr_min_damage) or
            (ovr_selected == 1 and ui_get(rage[i].ovr_min_damage) or ui_get(rage[i].ovr_min_damage2))
        end
    end

    local hc_val =  (ui_get(ovr_hc_key) and ui_get(rage[i].hitchance_ovr)) or                              -- OVERRIDE HC
                    ((ui_get(rage[i].air_hc_enable) and not onground) and ui_get(rage[i].hitchance_air)) or -- IN AIR HC
                    (is_scoped == 0 and contains(scoped_wpn_idx, i) and ui_get(rage[i].ns_hitchance)) or -- NO SCOPE HC ON SCOPED WPNS
                    (ui_get(rage[i].hitchance))                                                          -- DEFAULT HC

    local doubletapping = ui_get(ref_doubletap) and ui_get(ref_doubletapkey)
    local custom_mp = ui_get(rage[i].dt_mp_enable) and doubletapping  
    local custom_psp = ui_get(rage[i].dt_prefer_safe_point) and doubletapping
    local psp_val = ui_get(rage[i].prefer_safe_point) and not doubletapping or custom_psp

    local thb_val = ui_get(target_hitbox_ovr_key) and ui_get(target_hitbox_ovr) or ui_get(rage[i].target_hitbox)
    local mp_val = custom_mp and ui_get(rage[i].dt_multipoint) or ui_get(rage[i].multipoint)
	local unsafe_val = ui_get(unsafe_ovr_key) and ui_get(unsafe_ovr) or ui_get(rage[i].unsafe)
    local mps_val = custom_mp and ui_get(rage[i].dt_multipoint_scale) or ui_get(rage[i].multipoint_scale)
    local mpm_val = custom_mp

    local qs_val = {ui_get(rage[i].quick_stop), ui_get(rage[i].quick_stop_options)}
    local dt_qs_val = ui_get(rage[i].doubletap_stop)
    
    if i == scoped_wpn_idx[2] then
        qs_val = is_scoped == 0 and {ui_get(rage[i].quick_stop_ns), ui_get(rage[i].quick_stop_options_ns)} or   -- 1. NO SCOPE QS
                {ui_get(rage[i].quick_stop), ui_get(rage[i].quick_stop_options)}                                -- DEFAULT QS

        dt_qs_val = is_scoped == 0 and ui_get(rage[i].doubletap_stop_ns) or ui_get(rage[i].doubletap_stop)
    end

    ui_set(ref_target_selection, ui_get(rage[i].target_selection))
    ui_set(ref_automatic_fire, ui_get(rage[i].automatic_fire))
    ui_set(ref_automatic_penetration, ui_get(rage[i].automatic_penetration))
    ui_set(ref_silent_aim, ui_get(rage[i].silent_aim))
    --ui_set(ref_accuracy_boost, ui_get(rage[i].accuracy_boost))
	
    
    if js_state then
        ui_set(ref_target_hitbox, ui_get(rage[scoped_wpn_idx[1]].js_target_hitbox))
        ui_set(ref_multipoint, ui_get(rage[scoped_wpn_idx[1]].js_multipoint))
        ui_set(ref_multipoint_mode, ui_get(rage[scoped_wpn_idx[1]].js_multimode))
        ui_set(ref_multipoint_scale, ui_get(rage[scoped_wpn_idx[1]].js_multipoint_scale))
        ui_set(ref_unsafe, ui_get(rage[scoped_wpn_idx[1]].js_unsafe))
        ui_set(ref_prefer_safepoint, ui_get(rage[scoped_wpn_idx[1]].js_prefer_safe_point))
        ui_set(ref_automatic_scope, ui_get(rage[scoped_wpn_idx[1]].js_automatic_scope))
        ui_set(ref_hitchance, ui_get(rage[scoped_wpn_idx[1]].js_hitchance))
        ui_set(ref_mindamage, ui_get(rage[scoped_wpn_idx[1]].js_min_damage))
        ui_set(ref_quickstop, ui_get(rage[scoped_wpn_idx[1]].js_quick_stop))
        ui_set(ref_quickstop_options, ui_get(rage[scoped_wpn_idx[1]].js_quick_stop_options))
        ui_set(ref_prefer_bodyaim, ui_get(rage[scoped_wpn_idx[1]].js_prefer_baim))
        ui_set(ref_prefer_bodyaim_disablers, ui_get(rage[scoped_wpn_idx[1]].js_prefer_baim_disablers))
        ui_set(ref_delay_shot, ui_get(rage[scoped_wpn_idx[1]].js_delay_shot))
        ui_set(ref_force_baim_peek, ui_get(rage[scoped_wpn_idx[1]].js_force_baim_peek))
    else
        ui_set(ref_target_hitbox, thb_val)
        ui_set(ref_multipoint, mp_val)
        --ui_set(ref_multipoint_mode, mpm_val)
        ui_set(ref_multipoint_scale, mps_val)
        ui_set(ref_unsafe, unsafe_val)
        ui_set(ref_prefer_safepoint, psp_val)
        ui_set(ref_automatic_scope, ui_get(rage[i].automatic_scope))
        ui_set(ref_hitchance, hc_val)
        ui_set(ref_mindamage, damage_val)
        ui_set(ref_quickstop, qs_val[1])
        ui_set(ref_quickstop_options, qs_val[2])
        ui_set(ref_prefer_bodyaim, ui_get(rage[i].prefer_baim))
        ui_set(ref_prefer_bodyaim_disablers, ui_get(rage[i].prefer_baim_disablers))
        ui_set(ref_delay_shot, ui_get(rage[i].delay_shot))
        --ui_set(ref_force_baim_peek, ui_get(rage[i].force_baim_peek))
    end

    if not ui_get(global_dt_hc) then
        ui_set(ref_doubletap_hc, ui_get(rage[i].doubletap_hc))
    end


    ui_set(ref_doubletap_stop, dt_qs_val)
    active_idx = i
end

local function on_setup_command(c)
    local_player = entity_get_local_player()

    if entity_is_alive(local_player) then run_adjustments() end

    local weapon_id = bit_band(entity_get_prop(entity_get_player_weapon(local_player), "m_iItemDefinitionIndex"), 0xFFFF)
    in_speed = c.in_speed == 1 or false

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
end

local function on_paint(c)
    if entity_is_alive(local_player) then else return end
    
    handle_ovr()
    run_visuals()
end


ui_set_callback(master_switch, function()
    local events = {['paint'] = on_paint, ['setup_command'] = on_setup_command}
    local update_cb = ui_get(master_switch) and client_set_event_callback or client_unset_event_callback
    for k,v in pairs(events) do update_cb(k, v) end

    handle_menu()
end)


local function init_callbacks()
    local update_menu_items = {active_wpn, rage[scoped_wpn_idx[1]].js_settings, rage[scoped_wpn_idx[1]].js_multipoint, rage[scoped_wpn_idx[1]].js_quick_stop, rage[scoped_wpn_idx[1]].js_prefer_baim}
    for i=1,#update_menu_items do ui_set_callback(update_menu_items[i], handle_menu) end

    for i=1, #config_names do
        ui_set_callback(rage[i].multipoint, handle_menu)
		ui_set_callback(rage[i].unsafe, handle_menu)
        ui_set_callback(rage[i].prefer_baim, handle_menu)
        ui_set_callback(rage[i].quick_stop, handle_menu)
        ui_set_callback(rage[i].quick_stop_ns, handle_menu)
        ui_set_callback(rage[i].dt_mp_enable, handle_menu)
        ui_set_callback(rage[i].air_hc_enable, handle_menu)
        ui_set_callback(rage[i].custom_damage, handle_menu)
    end
    ui_set_callback(ref_doubletap, handle_menu)

end

init_callbacks()

-- ez map by sativa