local ui_get, ui_set, ui_reference, ui_set_visible, ui_set_callback, ui_new_slider, ui_new_combobox, ui_is_menu_open, ui_new_color_picker, ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_new_label, ui_new_listbox, ui_new_textbox = ui.get, ui.set, ui.reference, ui.set_visible, ui.set_callback, ui.new_slider, ui.new_combobox, ui.is_menu_open, ui.new_color_picker, ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.new_label, ui.new_listbox, ui.new_textbox
local entity_get_local_player, entity_get_players, entity_is_alive, entity_is_enemy, entity_get_player_weapon, entity_get_classname, entity_hitbox_position, entity_get_prop, entity_set_prop, entity_get_player_name, entity_get_player_resource, entity_get_game_rules, entity_get_bounding_box = entity.get_local_player, entity.get_players, entity.is_alive, entity.is_enemy, entity.get_player_weapon, entity.get_classname, entity.hitbox_position, entity.get_prop, entity.set_prop, entity.get_player_name, entity.get_player_resource, entity.get_game_rules, entity.get_bounding_box
local client_eye_position, client_camera_angles, client_screen_size, client_userid_to_entindex, client_trace_bullet, client_visible, client_latency, client_key_state, client_trace_line, client_set_clan_tag = client.eye_position, client.camera_angles, client.screen_size, client.userid_to_entindex, client.trace_bullet, client.visible, client.latency, client.key_state, client.trace_line, client.set_clan_tag
local globals_realtime, globals_absoluteframetime, globals_curtime, globals_tickcount, globals_tickinterval, table_insert, table_remove = globals.realtime, globals.absoluteframetime, globals.curtime, globals.tickcount, globals.tickinterval, table.insert, table.remove
local math_random, math_pi, math_atan2, math_floor, math_sqrt, math_pow, math_abs, math_min, math_max, math_deg, math_rad, math_sin, math_cos, math_atan, math_acos, math_fmod, math_ceil = math.random, math.pi, math.atan2, math.floor, math.sqrt, math.pow, math.abs, math.min, math.max, math.deg, math.rad, math.sin, math.cos, math.atan, math.acos, math.fmod, math.ceil
local renderer_measure_text, renderer_text, renderer_indicator, renderer_rectangle, renderer_gradient, renderer_world_to_screen, renderer_circle, renderer_circle_outline = renderer.measure_text, renderer.text, renderer.indicator, renderer_rectangle, renderer.gradient, renderer.world_to_screen, renderer_rectangle, renderer_rectangle_outline
local string_format, string_len, string_reverse, string_sub = string.format, string.len, string.reverse, string.sub
local ui_mouse_position = ui.mouse_position
local client_set_event_callback = client.set_event_callback

local ffi

for k, v in pairs(package["loaded"]) do
    if tostring(package["loaded"][k]) == "table: NULL" and package["loaded"][k]["arch"] then
        ffi = v
    end
end

ffi.cdef("typedef bool(__thiscall* lgts)(float, float, float, float, float, float, short);typedef void***(__thiscall* FindHudElement_t)(void*, const char*);typedef void(__cdecl* ChatPrintf_t)(void*, int, int, const char*, ...);")

local lgts_found = client.find_signature("client.dll", "\x55\x8B\xEC\x83\xEC\x08\x8B\x15\xCC\xCC\xCC\xCC\x0F\x57") or error("lgts not found")
local line_goes_through_smoke = ffi.cast("lgts", lgts_found) or error("line_goes_through_smoke is nil")

local gHud_found = client.find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\x88\x46\x09") or error("gHud not found")
local hud = ffi.cast("void**", ffi.cast("char*", gHud_found) + 1)[0] or error("hud is nil")

gHud_found = client.find_signature("client.dll", "\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x57\x8B\xF9\x33\xF6\x39\x77\x28") or error("FindHudElement not found")
local find_hud_element = ffi.cast("FindHudElement_t", gHud_found)
local hudchat = find_hud_element(hud, "CHudChat") or error("CHudChat not found")

local chudchat_vtbl = hudchat[0] or error("CHudChat instance vtable is nil")
local print_to_chat = ffi.cast("ChatPrintf_t", chudchat_vtbl[27])

local screen_transform_found = client.find_signature("client.dll", "\x56\x8B\xF1\x8B\x0D\xCC\xCC\xCC\xCC\x57\x8B\xFA\x8B\x01") or error("transform not found")
local ScreenTransform = ffi.cast("int(__fastcall*)(float*, float*)", screen_transform_found)
local weapon_system_place = client.find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\x50\xFF\x56\x08\x85\xC0\x75\x0F") or error("can't find weaponinfo")
local CCSWeaponSystem = ffi.cast("int8_t**",  ffi.cast("int8_t*", weapon_system_place) + 1)[0]
local get_wpn_data = ffi.cast("int8_t*(__thiscall***)(int8_t*, int32_t)", CCSWeaponSystem)[0][2];

local s_1, s_2, s_3

local ui = {
    fakelag_cache = nil,

    -- Ragebot:
    ragebot_enable, ragebot_enable_mode,
    ragebot_baim_key,
    ragebot_aimstep = ui_reference("RAGE", "Other", "Reduce aim step"),
    ragebot_target_selection = ui_reference("RAGE", "Aimbot", "Target selection"),
    ragebot_maximum_fov = ui_reference("RAGE", "Other", "Maximum FOV"),
    ragebot_mindmg = ui_reference("RAGE", "Aimbot", "Minimum damage"),
    ragebot_minhc = ui_reference("RAGE", "Aimbot", "Minimum hit chance"),
    ragebot_autofire = ui_reference("RAGE", "Other", "Automatic fire"),
    ragebot_autowall = ui_reference("RAGE", "Other", "Automatic penetration"),
    ragebot_silent = ui_reference("RAGE", "Other", "Silent aim"),
    ragebot_recoil = ui_reference("RAGE", "Other", "Remove recoil"),
    ragebot_hitbox = ui_reference("RAGE", "Aimbot", "Target hitbox"),
    --ragebot_prefer_baim = ui_reference("RAGE", "Other", "Prefer body aim"),
    ragebot_quick_peek, ragebot_quick_peek_key,
    --ragebot_prefer_baim_disable = ui_reference("RAGE", "Other", "Prefer body aim disablers"),
    ragebot_mp, ragebot_mp_key, ragebot_mp_mode,
    ragebot_mp_slider = ui_reference("RAGE", "Aimbot", "Multi-point scale"),
    ragebot_resolver = ui_reference("RAGE", "Other", "Anti-aim correction"),
    ragebot_resolver_override_key,
    ragebot_dt, ragebot_dt_key,

    -- Anti-aim:
    aa_enable = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
    aa_pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
    aa_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    aa_rageyaw, aa_rageyaw_slider,
    aa_yawjitter, aa_yawjitter_slider,
    aa_bodyyaw, aa_bodyyaw_slider,
    aa_bodyyaw_freestand = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    --aa_limit = ui_reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
    aa_edgeyaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    aa_autodirection, autodirection_key,
    aa_inf_duck = ui_reference("MISC", "Movement", "Infinite duck"),
    aa_fake_duck = ui_reference("RAGE", "Other", "Duck peek assist"),
    aa_fakewalk, aa_fakewalk_key,
    --aa_fakewalk_mode = ui_reference("AA", "Other", "Slow motion type"),

    -- Other:
    other_tp_alive, other_tp_alive_key,
    other_fakelag, other_fakelag_key,
    other_fakelag_limit = ui_reference("AA", "Fake lag", "Limit"),
    other_tp_dead = ui_reference("VISUALS", "Effects", "Force third person (dead)"),
    other_clantag = ui_reference("MISC", "Miscellaneous", "Clan tag spammer"),
    other_flags = ui_reference("VISUALS", "Player ESP", "Flags"),
    other_esp_name = ui_reference("VISUALS", "Player ESP", "Name"),
    
    -- Playerlist:
    players_target = ui_reference("Players", "Players", "Player list"),
    players_reset = ui_reference("Players", "Players", "Reset all"),
    players_highpr = ui_reference("Players", "Adjustments", "High priority"),
    players_prefer = ui_reference("Players", "Adjustments", "Override prefer body aim"),
    players_corr = ui_reference("Players", "Adjustments", "Correction active"),
    players_body_yaw = ui_reference("Players", "Adjustments", "Force body yaw"),
    players_body_yaw_val = ui_reference("Players", "Adjustments", "Force body yaw value"),

    -- Misc:
    misc_dpi_scale = ui_reference("MISC", "Settings", "DPI scale"),
    misc_steal_name = ui_reference("MISC", "Miscellaneous", "Steal player name"),
    misc_knifebot = ui_reference("MISC", "Miscellaneous", "Knifebot"),
    misc_zeusbot = ui_reference("MISC", "Miscellaneous", "Zeusbot"),
    misc_pingspike, misc_pingspike_key, misc_pingspike_slider,
    --sv_maxusrcmdprocessticks = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
}

s_1, s_2 = ui_reference("AA", "Anti-aimbot angles", "Yaw")
ui.aa_rageyaw = s_1
ui.aa_rageyaw_slider = s_2
s_1, s_2 = ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")
ui.aa_yawjitter = s_1
ui.aa_yawjitter_slider = s_2
s_1, s_2 = ui_reference("AA", "Anti-aimbot angles", "Body yaw")
ui.aa_bodyyaw = s_1
ui.aa_bodyyaw_slider = s_2
s_1, s_2 = ui_reference("AA", "Anti-aimbot angles", "Freestanding")
ui.aa_autodirection = s_1
ui.aa_autodirection_key = s_2
s_1, s_2 = ui_reference("AA", "Other", "Slow motion")
ui.aa_fakewalk = s_1
ui.aa_fakewalk_key = s_2
s_1, s_2 = ui_reference("RAGE", "Aimbot", "Double tap")
ui.ragebot_dt = s_1
ui.ragebot_dt_key = s_2
--s_3 = ui_reference("AA", "Other", "Slow motion type")
--ui.aa_fakewalk_mode = s_3
s_1 = ui_reference("RAGE", "Aimbot", "Force safe point")
ui.ragebot_force_sp = s_1
s_1, s_2 = ui_reference("RAGE", "Aimbot", "Enabled")
s_3 = ui_reference("RAGE", "Aimbot", "Force body aim")
ui.ragebot_enable = s_1
ui.ragebot_enable_mode = s_2
ui.ragebot_baim_key = s_3
s_1, s_2, s_3 = ui_reference("RAGE", "Aimbot", "Multi-point")
ui.ragebot_mp = s_1
ui.ragebot_mp_key = s_2
ui.ragebot_mp_mode = s_3
s_1, s_2 = ui_reference("RAGE", "Other", "Quick peek assist")
ui.ragebot_quick_peek = s_1
ui.ragebot_quick_peek_key = s_2
s_1, s_2 = ui_reference("VISUALS", "Effects", "Force third person (alive)")
ui.other_tp_alive = s_1
ui.other_tp_alive_key = s_2
s_1, s_2 = ui_reference("AA", "Fake lag", "Enabled")
ui.other_fakelag = s_1
ui.other_fakelag_key = s_2
--s_1 = ui_reference("RAGE", "Other", "Anti-aim correction override")
ui.ragebot_resolver_override_key = s_1
s_1, s_2, s_3 = ui_reference("MISC", "Miscellaneous", "Ping spike")
ui.misc_pingspike = s_1
ui.misc_pingspike_key = s_2
ui.misc_pingspike_slider = s_3

local frametimes = {}
local mshots = {}
local allshots = {}

local misc = {
    vote_option = {},
    fps_prev = 0,
    fps_last_update_time = 0,
    
    lby_target = 0,
    prev_dur = 0,
    prev_time,

    ticks_to_lag,
    me,

    manual_mode = 0,
    was_switched = false,

    choked_cmds,
    old_name,
    weapon_switch = "",
    weapon_was_switched = false,
    weapon_current = "",
}

local entity_resolve = {
    is_resolved = {},
    is_bruteforced = {},
    anti_brute = {},
    shot_data = {},
    time_stamps = {},
    timings = {t = {}, dsc = {}, updated = {}, bchanged = {}, btotal = {}},
    aa_type = {},
    aa_state = {},
}

local aa_state = ui_get(ui.aa_bodyyaw_slider) == 90 and "RIGHT" or "LEFT"
local aa_draw = ui_get(ui.aa_bodyyaw_slider) == 90 and "RIGHT" or "LEFT"
local val_to_set = ui_get(ui.aa_bodyyaw_slider)
local dpi_scale = 1
local new_x, new_y = client_screen_size()

local adaptive_a, adaptive_b = "LUA", "A"
local adaptive_c, adaptive_d = "LUA", "B"
local legit_a, legit_b = "AA", "Anti-aimbot angles"
local misc_a, misc_b = "MISC", "Miscellaneous"


local list = {
    dmg = function()
        local damage_list = { }
        damage_list[0] = "Auto"
    
        for i = 1, 100 do
            damage_list[i] = i
        end
    
        for i = 1, 26 do
            damage_list[100 + i] = "HP+" .. i
        end

        return damage_list
    end,

    hc = function()
        local hc_list = { }
        hc_list[0] = "Off"
    
        return hc_list
    end,

    mp = function()
        local mp_list = { }
        mp_list[24] = "Auto"
    
        return mp_list
    end,
}

local weapons = {
    [1] = "Global",
    ["CWeaponGlock"] = "Glock-18",
    ["CWeaponHKP2000"] = "USP-S",
    ["CDEagle"] = "Desert Eagle",
    ["CWeaponAWP"] = "AWP",
    ["CWeaponSSG08"] = "SSG08",
    ["CWeaponG3SG1"] = "G3SG1",
    ["CWeaponSCAR20"] = "SCAR-20",
    ["CAK47"] = "AK-47",
    ["CWeaponM4A1"] = "M4A1",
    ["CWeaponTaser"] = "Zeus",
    ["CKnife"] = "Knife",
}

local weapon_settings = {aimbot_improvements, target_selection, weapon_name}
local cached_weapon_info = {}

local function initialize_weapons(weapon_table)
    weapon_settings.label = ui_new_label(adaptive_a, adaptive_b, "-------------------------[\a3EE826FFEternity\aFFFFFFFF]-------------------------")
    weapon_settings.aimbot_improvements = ui_new_checkbox(adaptive_a, adaptive_b, "Aimbot improvements")
    weapon_settings.target_selection = ui_new_combobox(adaptive_a, adaptive_b, "Target selection", "Crosshair", "Damage")
    weapon_settings.weapon_name = ui_new_combobox(adaptive_a, adaptive_b, "Weapon name", "Global", "Glock-18", "USP-S", "Desert Eagle", "AWP", "SSG08", "G3SG1", "SCAR-20", "AK-47", "M4A1", "Zeus", "Knife")
    weapon_settings.label = ui_new_label(adaptive_a, adaptive_b, "-------------------------[\a3EE826FFEternity\aFFFFFFFF]-------------------------")

    for k, v in pairs(weapon_table) do
        local console_name, normal_name = k, v

        weapon_settings[normal_name] = {
            ragebot_settings = ui_new_checkbox(adaptive_a, adaptive_b, "Use global settings on " .. normal_name),
            ragebot_restrict = ui_new_multiselect(adaptive_a, adaptive_b, "Disable aimbot on " .. normal_name, "Smoke", "Flash", "In air"),
            ragebot = ui_new_checkbox(adaptive_a, adaptive_b, "Use ragebot on " .. normal_name),
            ragebot_key = ui_new_hotkey(adaptive_a, adaptive_b, normal_name .. " ragebot key", true),
            magnet = ui_new_checkbox(adaptive_a, adaptive_b, normal_name .. " magnet triggerbot"),
            magnet_key = ui_new_hotkey(adaptive_a, adaptive_b, normal_name .. " magnet key", true),
            hitbox = ui_new_checkbox(adaptive_a, adaptive_b, normal_name .. " hitbox selection"),
            hitbox_mode = ui_new_combobox(adaptive_a, adaptive_b, "\n hitbox_mode_" .. normal_name, "Normal", "Near crosshair", "Smart"),
            hitbox_hitboxes = ui_new_multiselect(adaptive_a, adaptive_b, normal_name .. " target hitbox", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
            hitbox_multipoints = ui_new_multiselect(adaptive_a, adaptive_b, normal_name ..  " multi-point", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
            hitbox_multipoints_scale = ui_new_slider(adaptive_a, adaptive_b, normal_name .. " multi-point scale", 24, 100, 60, true, "%", 1, list.mp()),
            hitbox_override = ui_new_checkbox(adaptive_a, adaptive_b, normal_name .. " hitbox override"),
            hitbox_override_key = ui_new_hotkey(adaptive_a, adaptive_b, "Hitbox override key", true),
            hitbox_override_hitboxes = ui_new_multiselect(adaptive_a, adaptive_b, normal_name .. " override hitboxes", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
            hitbox_override_multipoints =  ui_new_multiselect(adaptive_a, adaptive_b, normal_name .. " override multi-points", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
            bodyaim_prefer = ui_new_checkbox(adaptive_a, adaptive_b, normal_name .. " prefer body aim"),
            bodyaim_prefer_disable = ui_new_multiselect(adaptive_a, adaptive_b, normal_name .. " body aim disablers", {"Low inaccuracy", "Target shot fired", "Target resolved", "Safe point headshot", "Low damage"}),
            fov = ui_new_checkbox(adaptive_a, adaptive_b, normal_name .. " field of view"),
            fov_mode = ui_new_combobox(adaptive_a, adaptive_b, "\n fov_mode_" .. normal_name, "Distance", "Factor"),
            fov_min = ui_new_slider(adaptive_a, adaptive_b, normal_name .. " minimum FOV", 1, 180, 3, true, "°", 1),
            fov_max = ui_new_slider(adaptive_a, adaptive_b, normal_name .. " maximum FOV", 1, 180, 8, true, "°", 1),
            fov_factor = ui_new_slider(adaptive_a, adaptive_b, normal_name .. " FOV multiplier", 75, 200, 1, true, "x", 0.01),
            autowall = ui_new_checkbox(adaptive_a, adaptive_b, normal_name .. " automatic penetration"),
            autowall_key = ui_new_hotkey(adaptive_a, adaptive_b, normal_name .. " automatic penetration key", true),
            autowall_mode = ui_new_combobox(adaptive_a, adaptive_b, "\n ragebot_autowall_mode_" .. normal_name, "Manual", "Adaptive"),
            autowall_triggers = ui_new_multiselect(adaptive_a, adaptive_b, normal_name .. " customize triggers", {"Lethal", "Visible"}),
            autowall_visible_hitboxes = ui_new_slider(adaptive_a, adaptive_b, normal_name .. " hitbox visibility amount", 1, 18, 4, true, "", 1),
            adaptive = ui_new_checkbox(adaptive_a, adaptive_b, normal_name .. " adaptive settings"),
            adaptive_hc = ui_new_slider(adaptive_a, adaptive_b, normal_name .. " minimum hit chance", 0, 100, 50, true, "%", 1, list.hc()),
            adaptive_dmg = ui_new_slider(adaptive_a, adaptive_b, normal_name .. " minimum damage", 0, 126, 20, true, "", 1, list.dmg()),
            adaptive_dmg_vis = ui_new_slider(adaptive_a, adaptive_b, normal_name .. " visible minimum damage", 0, 126, 20, true, "", 1, list.dmg()),
            adaptive_override = ui_new_checkbox(adaptive_a, adaptive_b, normal_name .. " override settings"),
            adaptive_override_key = ui_new_hotkey(adaptive_a, adaptive_b, normal_name .. " override settings key", true),
            adaptive_override_hc = ui_new_slider(adaptive_a, adaptive_b, normal_name .. " override hit chance", 0, 100, 50, true, "%", 1, list.hc()),
            adaptive_override_dmg = ui_new_slider(adaptive_a, adaptive_b, normal_name .. " override damage", 0, 126, 20, true, "", 1, list.dmg()),
        }
    end
end
initialize_weapons(weapons)

local menu = {
    -- Anti-aim resolver
    label = ui_new_label("PLAYERS", "Adjustments", "-------------------------[\a3EE826FFEternity\aFFFFFFFF]-------------------------"),
    resolver = ui_new_checkbox("PLAYERS", "Adjustments", "Anti-aim resolver"),
    resolver_pred = ui_new_combobox("PLAYERS", "Adjustments", "\n pred", "Smart", "Manual"),  
    resolver_override = ui_new_hotkey("PLAYERS", "Adjustments", "Anti-aim resolver override", false),
    resolver_manual_switch_key = ui_new_hotkey("PLAYERS", "Adjustments", "Switch resolver mode", false),
    resolver_manual_draw = ui_new_checkbox("PLAYERS", "Adjustments", "Show resolver position"),
    resolver_manual_draw_cp = ui_new_color_picker("PLAYERS", "Adjustments", "Draw resolver color picker", 124, 195, 13, 255),
    resolver_manual_draw_mode = ui_new_combobox("PLAYERS", "Adjustments", "\n resolver_manual_draw_mode", "Default", "Opposite"),
    label = ui_new_label("PLAYERS", "Adjustments", "-------------------------[\a3EE826FFEternity\aFFFFFFFF]-------------------------"),

    -- Anti-aims:
        -- Legit anti-aim:
        aa_legit = ui_new_checkbox(legit_a, legit_b, "Legit anti-aim"),

        aa_legit_base = ui_new_combobox(legit_a, legit_b, "\n aa_legit_base", "Manual", "Dynamic"),
        aa_legit_base_key = ui_new_hotkey(legit_a, legit_b, "Anti-aim switch key", false),

        aa_legit_state = ui_new_combobox(legit_a, legit_b, "Anti-aim state", "Standing", "Moving", "In air"),
        aa_legit_stand_master = ui_new_checkbox(legit_a, legit_b, "Standing: enable"),
        aa_legit_stand_master_key = ui_new_hotkey(legit_a, legit_b, "Standing: enable_key", true),
        aa_legit_stand_at_targets = ui_new_checkbox(legit_a, legit_b, "Standing: at targets"),
        aa_legit_stand_at_targets_key = ui_new_hotkey(legit_a, legit_b, "Standing: at targets key", true),
        aa_legit_stand_jitter = ui_new_checkbox(legit_a, legit_b, "Standing: body yaw jitter"),
        aa_legit_stand_jitter_key = ui_new_hotkey(legit_a, legit_b, "Standing: jitter key", true),
        aa_legit_stand_limit = ui_new_slider(legit_a, legit_b, "Standing: body yaw limit", 0, 60, 60, true, "°", 1),
        --aa_legit_stand_crooked = ui_new_checkbox(legit_a, legit_b, "Standing: crooked"),
        --aa_legit_stand_crooked_key = ui_new_hotkey(legit_a, legit_b, "Standing: crooked_key", true),

        aa_legit_moving_master = ui_new_checkbox(legit_a, legit_b, "Moving: enable"),
        aa_legit_moving_master_key = ui_new_hotkey(legit_a, legit_b, "Moving: enable_key", true),
        aa_legit_moving_at_targets = ui_new_checkbox(legit_a, legit_b, "Moving: at targets"),
        aa_legit_moving_at_targets_key = ui_new_hotkey(legit_a, legit_b, "Moving: at targets key", true),
        aa_legit_moving_jitter = ui_new_checkbox(legit_a, legit_b, "Moving: body yaw jitter"),
        aa_legit_moving_jitter_key = ui_new_hotkey(legit_a, legit_b, "Moving: jitter key", true),
        aa_legit_moving_limit = ui_new_slider(legit_a, legit_b, "Moving: body yaw limit", 0, 60, 60, true, "°", 1),

        aa_legit_air_master = ui_new_checkbox(legit_a, legit_b, "In air: enable"),
        aa_legit_air_master_key = ui_new_hotkey(legit_a, legit_b, "In air: enable_key", true),
        aa_legit_air_at_targets = ui_new_checkbox(legit_a, legit_b, "In air: at targets"),
        aa_legit_air_at_targets_key = ui_new_hotkey(legit_a, legit_b, "In air: at targets key", true),
        aa_legit_air_jitter = ui_new_checkbox(legit_a, legit_b, "In air: body yaw jitter"),
        aa_legit_air_jitter_key = ui_new_hotkey(legit_a, legit_b, "In air: jitter key", true),
        aa_legit_air_limit = ui_new_slider(legit_a, legit_b, "In air: body yaw limit", 0, 60, 60, true, "°", 1),

        aa_legit_stand_fs_invert = ui_new_checkbox(legit_a, legit_b, "Standing: invert freestanding"),
        aa_legit_stand_fs_invert_key = ui_new_hotkey(legit_a, legit_b, "Standing: invert freestanding key", true),
        aa_legit_moving_fs_invert = ui_new_checkbox(legit_a, legit_b, "Moving: invert freestanding"),
        aa_legit_moving_fs_invert_key = ui_new_hotkey(legit_a, legit_b, "Moving: invert freestanding key", true),
        aa_legit_air_fs_invert = ui_new_checkbox(legit_a, legit_b, "In air: invert freestanding"),
        aa_legit_air_fs_invert_key = ui_new_hotkey(legit_a, legit_b, "In air: invert freestanding key", true),

        aa_legit_antibrute = ui_new_checkbox(legit_a, legit_b, "Anti-bruteforce"),
        aa_legit_antibrute_multi = ui_new_multiselect(legit_a, legit_b, "\n aa_legit_antibrute_multi", {"On hit", "On miss"}),
        aa_legit_yaw_rotate = ui_new_checkbox(legit_a, legit_b, "Yaw rotation"),
        aa_legit_yaw_rotate_key = ui_new_hotkey(legit_a, legit_b, "Yaw rotation key", true),
        aa_legit_safe = ui_new_checkbox(legit_a, legit_b, "Safe anti-aim triggers"),
        aa_legit_safe_trig = ui_new_multiselect(legit_a, legit_b, "\n aa_legit_safe_trig", "Low FPS", "Packet loss", "Fake lag", "Fake duck", "Grenade"),
        aa_legit_slowmo = ui_new_checkbox(legit_a, legit_b, "Slow walk"),
        aa_legit_slowmo_key = ui_new_hotkey(legit_a, legit_b, "Slow walk key", true),
        aa_legit_slowmo_slider = ui_new_slider(legit_a, legit_b, "Slow walk speed", 0, 100, 100, true, "%", 1, {[0.0] = "Best anti-aim", [100.0] = "Best speed"}),
        aa_legit_slowmo_lowd = ui_new_checkbox(legit_a, legit_b, "Low delta while slowwalking"),
        aa_legit_slowmo_jitter = ui_new_checkbox(legit_a, legit_b, "Disable jitter while slowwalking"),
        aa_legit_indicator = ui_new_checkbox(legit_a, legit_b, "Anti-aim direction"),
        aa_legit_indicator_mode = ui_new_combobox(legit_a, legit_b, "\n aa_legit_indicator", "Small", "Normal"),

        -- Fake lag:
        aa_legit_fl = ui_new_checkbox("AA", "Fake lag", "Fake lag"),
        aa_legit_fl_key = ui_new_hotkey("AA", "Fake lag", "Fake lag hotkey", true),
        aa_legit_fl_mode = ui_new_multiselect("AA", "Fake lag", "\n aa_legit_fl_mode", {"In air", "While moving", "While standing"}),
        aa_legit_fl_shoot = ui_new_checkbox("AA", "Fake lag", "Fake lag while shooting"),

    -- Player flags:
    label = ui_new_label(adaptive_c, adaptive_d, "-------------------------[\a3EE826FFEternity\aFFFFFFFF]-------------------------"),
    flags = ui_new_checkbox(adaptive_c, adaptive_d, "Player flags"),
    flags_multi = ui_new_multiselect(adaptive_c, adaptive_d, "\n flags_multi", {"Desync", "Slow walk", "Body aim", "Override"}),

    -- Indicators:
    indicators = ui_new_checkbox(adaptive_c, adaptive_d, "Indicators"),
    indicators_multi = ui_new_multiselect(adaptive_c, adaptive_d, "\n indicators_multi", {"Automatic penetration", "Automatic fire", "Force body aim", "Safe point", "Override settings", "Override hitbox", "Quick peek assist", "Minimum damage", "Fake duck", "Field of view", "Fake lag", "Latency", "Anti-aim state", "Anti-aim resolver"}),
    indicators_combo = ui_new_combobox(adaptive_c, adaptive_d, "Indicators style", "Default", "Old", "Centered", "Container"),
    indicators_centered_mode = ui_new_combobox(adaptive_c, adaptive_d, "Indicators size", "Default", "Small"),
    indicators_color = ui_new_color_picker(adaptive_c, adaptive_d, "Indicators color", 255, 255, 255, 230),
    indicators_repos_default = ui_new_slider(adaptive_c, adaptive_d, "Reposition indicators", 1, 50, 1, true, "x"),
    indicators_repos_old = ui_new_slider(adaptive_c, adaptive_d, "Reposition old indicators", 1, 50, 1, true, "x"),
    indicators_repos_small = ui_new_slider(adaptive_c, adaptive_d, "Reposition text", 1, 100, 1, true, "x"),
    label = ui_new_label(adaptive_c, adaptive_d, "-------------------------[\a3EE826FFEternity\aFFFFFFFF]-------------------------"),
    label = ui_new_label(misc_a, misc_b, "-------------------------[\a3EE826FFEternity\aFFFFFFFF]-------------------------"),
    watermark_mode = ui_new_combobox(misc_a, misc_b, "Watermark", "-", "Classic Watermark", "Minimalistic Watermark", "Text"),
    watermark_color = ui_new_color_picker(misc_a, misc_b, "Watermark color", 255, 0, 0, 255),
    watermark_color_body = ui_new_color_picker(misc_a, misc_b, "Watermark color (body)", 45, 45, 50, 255),
    spectators = ui_new_checkbox(misc_a, misc_b, "Spectator list"),
    data_mm = ui_new_checkbox(misc_a, misc_b, "Matchmaking data"),

    print_data = ui_new_multiselect(misc_a, misc_b, "Print to chat", {"Missed shots", "Hit shots", "Votes", "Bought weapons", "Weapon change"}),

    shittalk = ui_new_checkbox(misc_a, misc_b, "Trashtalk"),

    indicators_pen_dmg = ui_new_checkbox(misc_a, misc_b, "Wallbang DMG indicator"),

    indicators_fov = ui_new_checkbox(misc_a, misc_b, "Show FOV circle"),
    indicators_fov_color = ui_new_color_picker(misc_a, misc_b, "Color", 124, 195, 13, 35),
    indicators_fov_mode = ui_new_combobox(misc_a, misc_b, "\n mode", "Normal", "Filled"),

    rainbow = ui_new_checkbox(misc_a, misc_b, "Rainbowize all containers"),
}

client_set_event_callback("paint_ui", function()
    new_x, new_y = client_screen_size()
end)

client_set_event_callback("paint_ui", function()
    dpi_scale = (ui_get(ui.misc_dpi_scale) == "100%" and 1) or (ui_get(ui.misc_dpi_scale) == "125%" and 1.25) or (ui_get(ui.misc_dpi_scale) == "150%" and 1.5) or (ui_get(ui.misc_dpi_scale) == "175%" and 1.75) or (ui_get(ui.misc_dpi_scale) == "200%" and 2)
end)

local aimbot_bool = {
    autofire = false,
    override_settings = false,
    override_hitbox = false,
}

local pos = {
    ["Small watermark"] = {
        new_x_pos, new_y_pos = 0, 0,
        x_pos = ui_new_slider("RAGE", "Other", "X \nsmall", 1, 4500, 10, true, "px"),
        y_pos = ui_new_slider("RAGE", "Other", "Y \nsmall", 1, 4500, 10, true, "px"),
        clicked = false,
        dragging = false,
    },

    ["Normal watermark"] = {
        new_x_pos, new_y_pos = 0, 0,
        x_pos = ui_new_slider("RAGE", "Other", "X \nbig", 1, 4500, 30, true, "px"),
        y_pos = ui_new_slider("RAGE", "Other", "Y \nbig", 1, 4500, 30, true, "px"),
        clicked = false,
        dragging = false,
    },

    ["Matchmaking data"] = {
        new_x_pos, new_y_pos = 0, 0,
        x_pos = ui_new_slider("RAGE", "Other", "X \nmm", 1, 4500, 10, true, "px"),
        y_pos = ui_new_slider("RAGE", "Other", "Y \nmm", 1, 4500, 150, true, "px"),
        clicked = false,
        dragging = false,
    },

    ["Spectators"] = {
        new_x_pos, new_y_pos = 0, 0,
        x_pos = ui_new_slider("RAGE", "Other", "X \nsp", 1, 4500, 10, true, "px"),
        y_pos = ui_new_slider("RAGE", "Other", "Y \nsp", 1, 4500, 60, true, "px"),
        clicked = false,
        dragging = false,
    },

    ["Indicators"] = {
        new_x_pos, new_y_pos = 0, 0,
        x_pos = ui_new_slider("RAGE", "Other", "X \nind", 1, 4500, 10, true, "px"),
        y_pos = ui_new_slider("RAGE", "Other", "Y \nind", 1, 4500, 100, true, "px"),
        clicked = false,
        dragging = false,
    },
}

local function accumulate_fps()
    local rt, ft = globals_realtime(), globals_absoluteframetime()

    if ft > 0 then
        table_insert(frametimes, 1, ft)
    end

    local count = #frametimes
    if count == 0 then
        return 0
    end

    local accum = 0
    local i = 0
    while accum < 0.5 do
        i = i + 1
        accum = accum + frametimes[i]
        if i >= count then
            break
        end
    end
    
    accum = accum / i
    
    while i < count do
        i = i + 1
        table_remove(frametimes)
    end
    
    local fps = 1 / accum
    local time_since_update = rt - misc.fps_last_update_time
    if math_abs(fps - misc.fps_prev) > 4 or time_since_update > 1 then
        misc.fps_prev = fps
        misc.fps_last_update_time = rt
    else
        fps = misc.fps_prev
    end

    return math_floor(fps + 0.5)
end

local float_for_color = {
	{0, 124, 195, 13},
	{0.125, 176, 205, 10},
	{0.25, 213, 201, 19},
	{0.375, 220, 169, 16},
	{0.5, 228, 126, 10},
	{0.625, 229, 104, 8},
	{0.75, 235, 63, 6},
	{0.875, 237, 27, 3},
	{1, 255, 0, 0}
}


local color = {
    rgb_prediction = function(float, inverse)
        local float = math_min(math_max(float, 0.000001), 9.999999)

        if float > 1 then
            float = 1
        end

        local color_lower 
        local color_higher 
        local distance_lower = 1
        local distance_higher = 1

        if inverse then
            for i = 1, #float_for_color do 
                local color = float_for_color[i]
                local color_float = 1 - color[1]
                if color_float == float then 
                    return color[2], color[3], color[4], color[5]
                elseif color_float > float then 
                    local distance = color_float - float 
                    if distance < distance_higher then 
                        color_higher = color 
                        distance_higher = distance
                    end
                elseif color_float < float then 
                    local distance = float - color_float
                    if distance < distance_lower then 
                        color_lower = color 
                        distance_lower = distance
                    end
                end
            end
        else
            for i = 1, #float_for_color do 
                local color = float_for_color[i]
                local color_float = color[1]
                if color_float == float then 
                    return color[2], color[3], color[4], color[5]
                elseif color_float > float then 
                    local distance = color_float - float 
                    if distance < distance_higher then 
                        color_higher = color 
                        distance_higher = distance
                    end
                elseif color_float < float then 
                    local distance = float - color_float
                    if distance < distance_lower then 
                        color_lower = color 
                        distance_lower = distance
                    end
                end
            end
        end

        local distance_difference = distance_lower + distance_higher
        local red = (color_lower[2] * distance_higher + color_higher[2] * distance_lower) / distance_difference
        local green = (color_lower[3] * distance_higher + color_higher[3] * distance_lower) / distance_difference
        local blue = (color_lower[4] * distance_higher + color_higher[4] * distance_lower) / distance_difference

        return red, green, blue
    end,

    convert_hsv = function(h, s, v, a)
        local r, g, b

        local i = math_floor(h * 6);
        local f = h * 6 - i;
        local p = v * (1 - s);
        local q = v * (1 - f * s);
        local t = v * (1 - (1 - f) * s);

        i = i % 6

        if i == 0 then r, g, b = v, t, p
        elseif i == 1 then r, g, b = q, v, p
        elseif i == 2 then r, g, b = p, v, t
        elseif i == 3 then r, g, b = p, q, v
        elseif i == 4 then r, g, b = t, p, v
        elseif i == 5 then r, g, b = v, p, q
        end

        return r * 255, g * 255, b * 255, a * 255
    end,

    convert_hex = function(num)
        local charset = {"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"}
        local tmp = {}
        
        repeat
            table_insert(tmp, 1 , charset[num % 16 + 1])
            num = math_floor(num / 16)
        until num == 0

        return table.concat(tmp)
    end,
}

local rainbowize = {
    rgb = function(frequency, rgb_split_ratio)
        local r, g, b, a = color.convert_hsv(globals.realtime() * frequency, 1, 1, 1)

        r = r * rgb_split_ratio
        g = g * rgb_split_ratio
        b = b * rgb_split_ratio

        return r, g, b
    end,
}

-- Get tables
local array = {
    contains = 
    function(table, key, data)
        if data then
            for index, value in ipairs(table) do
                if value == key then return true, index end
            end
            return false
        else
            for i = 1, #table do
                if table[i] == key then 
                    return true
                end
            end
            return false
        end
    end,

    remove =
    function(table, key)
        local tbl_new = {}
        for i=1, #table do
            if table[i] ~= key then
                table_insert(tbl_new, table[i])
            end
        end
        return tbl_new
    end,

    invert =
    function(table, value) 
            for k, v in pairs(table) do
                if v == value then return k end
            end
        return nil
    end,

    at_least = 
    function(table, boolean)
        local is_equal = false
        local amount = 0

        for i = 1, #table do
            if table[i] == boolean then
                is_equal = true
                amount = amount + 1
            end
        end

        return is_equal, amount
    end,
}

-- Clamp values
local clamp = {
    val = 
    function(cur_val, min_val, max_val)
        return math_min(math_max(cur_val, (min_val >= max_val) and max_val or min_val), (min_val >= max_val) and min_val or max_val)
    end,

    ang = 
    function(angle)
        local updated_angle = (angle % 360 + 360) % 360
        return (updated_angle > 180 and updated_angle - 360) or updated_angle
    end
}


local data = {
    velocity = 
    function(entindex)
        local vel_x, vel_y = entity_get_prop(entindex, "m_vecVelocity")
        return math_sqrt(vel_x^2 + vel_y^2)
    end,

    distance = 
    function(entindex, i)
        local x, y, z = client_eye_position()
        local a, b, c = entity_hitbox_position(entindex, i)
        return math_sqrt((a - x)^2 + (b - y)^2 + (c - z)^2)
    end,

    angles = 
    function(entindex, i)
        local x, y, z = client_eye_position()
        local a, b, c = entity_hitbox_position(entindex, i)
        local distance = math_sqrt((a - x)^2 + (b - y)^2)
        return -math_deg(math_atan2(c - z, distance)), math_deg(math_atan2(b - y, a - x))
    end,

    angles_for_enemy = 
    function(entindex, i)
        local x, y, z = entity_hitbox_position(entindex, i)
        local a, b, c = client_eye_position()
        local distance = math_sqrt((a - x)^2 + (b - y)^2)
        return -math_deg(math_atan2(c - z, distance)), math_deg(math_atan2(b - y, a - x))
    end,

    angles_dif = 
    function(pitch, yaw, distance)
        local own_pitch, own_yaw = client_camera_angles()
        local pitch_dif = math_abs(own_pitch - pitch) % 360
        local yaw_dif = math_abs(own_yaw % 360 - yaw % 360) % 360

        if yaw_dif > 180 then
            yaw_dif = yaw_dif - 360
        end

        local abs_dif = math_sqrt(pitch_dif^2 + yaw_dif^2)
        return abs_dif, pitch_dif, yaw_dif
    end,

    angles_dif_enemy =
    function(pitch, yaw, distance, entindex)
        local own_pitch, own_yaw = entity_get_prop(entindex, "m_angEyeAngles")
        own_yaw = clamp.ang(own_yaw)

        local pitch_dif = math_abs(own_pitch - pitch) % 360
        local yaw_dif = (own_yaw % 360 - yaw % 360) % 360

        if yaw_dif > 180 then
            yaw_dif = yaw_dif - 360
        end

        local abs_dif = math_sqrt(pitch_dif^2 + yaw_dif^2)
        return abs_dif, pitch_dif, yaw_dif
    end,

    in_flash = 
    function(entindex)
        local is_in_flash = false

        if entindex ~= nil then
            local flash_duration = entity_get_prop(entindex, "m_flFlashDuration")
            local current_time = client.timestamp() / 1000

            if flash_duration > 0 then
                if misc.prev_dur ~= flash_duration then
                    misc.prev_dur = flash_duration
                    misc.prev_time = client.timestamp() / 1000
                end

                if flash_duration > 1 then
                    if current_time - misc.prev_time < flash_duration - 2.5 then
                        is_in_flash = true
                    end
                end
            end
        end

        return is_in_flash
    end,

    in_air = 
    function(entindex)
        local is_in_air = false

        if entindex ~= nil then
            local in_air = entity_get_prop(entindex, "m_hGroundEntity")

            if in_air == nil then
                is_in_air = true
            end
        end

        return is_in_air
    end,

    freestand_local = 
    function(entindex, distance)
        local edge, freestand

        local players = entity_get_players(true)
        local _, yaw = client_camera_angles()
        local data_x, data_y, data_z = client_eye_position()
        local st_x, st_y, st_z = entity_hitbox_position(entity_get_local_player(), 4)
        local feet_x, feet_y, feet_z = entity_hitbox_position(entity_get_local_player(), 9)

        local start_angle = 60
        local offset = 15
        local loops = 8
        local edge_angle_x, edge_angle_y = 0, 0
        local edge_hits_l, edge_hits_r = 0, 0
    
        for i = 1, 4 do
            local extrapol_yaw_rad_edge_l, extrapol_yaw_rad_edge_r = math_rad(clamp.ang(yaw - 60) + 15 * (i - 1)), math_rad(clamp.ang(yaw + 60) - 15 * (i - 1))
            local extrapol_x_edge_l, extrapol_y_edge_l = data_x + distance * math_cos(extrapol_yaw_rad_edge_l), data_y + distance * math_sin(extrapol_yaw_rad_edge_l)
            local extrapol_x_edge_r, extrapol_y_edge_r = data_x + distance * math_cos(extrapol_yaw_rad_edge_r), data_y + distance * math_sin(extrapol_yaw_rad_edge_r)
            local fraction_edge_l, _ = client_trace_line(entity_get_local_player(), data_x, data_y, data_z, extrapol_x_edge_l, extrapol_y_edge_l, st_z)
            local fraction_edge_r, _ = client_trace_line(entity_get_local_player(), data_x, data_y, data_z, extrapol_x_edge_r, extrapol_y_edge_r, st_z)
            
            local dist_x_l = ((distance * math_cos(extrapol_yaw_rad_edge_l)) * fraction_edge_l)
            local dist_y_l = ((distance * math_sin(extrapol_yaw_rad_edge_l)) * fraction_edge_l)
            local dist_x_r = ((distance * math_cos(extrapol_yaw_rad_edge_r)) * fraction_edge_r)
            local dist_y_r = ((distance * math_sin(extrapol_yaw_rad_edge_r)) * fraction_edge_r)
            local dist_l, dist_r = math_sqrt(((distance * math_cos(extrapol_yaw_rad_edge_l)) * fraction_edge_l)^2 + ((distance * math_sin(extrapol_yaw_rad_edge_l)) * fraction_edge_l)^2), math_sqrt(((distance * math_cos(extrapol_yaw_rad_edge_r)) * fraction_edge_r)^2 + ((distance * math_sin(extrapol_yaw_rad_edge_r)) * fraction_edge_r)^2)  
    
            if fraction_edge_l < 0.8 or fraction_edge_r < 0.8 then
                if dist_r >= dist_l then
                    edge_hits_r = edge_hits_r + 1
                elseif dist_r < dist_l then
                    edge_hits_l = edge_hits_l + 1
                end
            end
        end
    
        if edge_hits_l > 2 or edge_hits_r > 2 then
            if edge_hits_r >= edge_hits_l then
                edge = "RIGHT"
            elseif edge_hits_r < edge_hits_l then
                edge = "LEFT"
            end
        end
    
        if #players ~= 0 then
            if entindex ~= nil then
                local enemy_x, enemy_y, enemy_z = entity_hitbox_position(entindex, 0)
                local freestand_angle_x, freestand_angle_y = 0, 0
                local freestand_hit = 0
    
                for i = 1, 8 do
                    local extrapol_yaw_rad = math_rad(clamp.ang(yaw - 60) + 15 * (i - 1))
                    local extrapol_x_fs, extrapol_y_fs = data_x + (distance + 25) * math_cos(extrapol_yaw_rad), data_y + (distance + 25) * math_sin(extrapol_yaw_rad)
                    
                    if enemy_x ~= nil then
                        local index, damage = client_trace_bullet(entity_get_local_player(), extrapol_x_fs, extrapol_y_fs, enemy_z, enemy_x, enemy_y, enemy_z)
                        local fraction_fs, _ = client_trace_line(entity_get_local_player(), data_x, data_y, data_z, extrapol_x_fs, extrapol_y_fs, data_z)
                        
                        damage = clamp.val(damage, 0, 100)
                        if damage > 5 then
                            freestand_hit = freestand_hit + 1
                        end
    
                        if fraction_fs == 1 then
                            freestand_angle_x, freestand_angle_y = freestand_angle_x + math_cos(extrapol_yaw_rad) * damage, freestand_angle_y + math_sin(extrapol_yaw_rad) * damage
                        end
                    end
                end
    
                if freestand_hit > 2 and freestand_hit < 8 then
                    local avg_dmg = math_atan2(freestand_angle_y, freestand_angle_x) + math_pi
                    local avg_dmg_x, avg_dmg_y = data_x + (distance + 25) * math_cos(avg_dmg), data_y + (distance + 25) * math_sin(avg_dmg)
    
                    local calc_freestand_yaw = math_deg(avg_dmg) + 180                   
                    local calc_extrapol_yaw = (yaw + 180) - calc_freestand_yaw

                    if calc_extrapol_yaw > 180 then
                        calc_freestand_yaw = calc_freestand_yaw + 360
                    elseif calc_extrapol_yaw < -180 then
                        calc_freestand_yaw = calc_freestand_yaw - 360
                    end
                    
                    if (yaw + 180) > calc_freestand_yaw then
                        freestand = "RIGHT"
                    else
                        freestand = "LEFT"
                    end
                end
            end
        end
    
        return edge, freestand
    end,

    freestand_global = 
    function(entindex, distance, add_yaw)
        local edge, freestand = "UNK", "UNK"

        local players = entity_get_players(true)
        local _, yaw_c = entity_get_prop(entindex, "m_angEyeAngles")
        local data_x, data_y, data_z = entity_hitbox_position(entindex, 0)
        local enemy_x, enemy_y, enemy_z = entity_hitbox_position(entity_get_local_player(), 0)
        local freestand_angle_x, freestand_angle_y = 0, 0
        local edge_hits_l, edge_hits_r = 0, 0
        local freestand_hit = 0
        local yaw = clamp.ang(clamp.ang(yaw_c) + add_yaw)

        if #players ~= 0 then
            for i = 1, 6 do
                local extrapol_yaw_rad_edge_l, extrapol_yaw_rad_edge_r = math_rad(yaw - 60 + 15 * (i - 1)), math_rad(yaw + 60 - 15 * (i - 1))
                local extrapol_x_edge_l, extrapol_y_edge_l = data_x + distance * math_cos(extrapol_yaw_rad_edge_l), data_y + distance * math_sin(extrapol_yaw_rad_edge_l)
                local extrapol_x_edge_r, extrapol_y_edge_r = data_x + distance * math_cos(extrapol_yaw_rad_edge_r), data_y + distance * math_sin(extrapol_yaw_rad_edge_r)
                local fraction_edge_l, _ = client_trace_line(entindex, data_x, data_y, data_z, extrapol_x_edge_l, extrapol_y_edge_l, data_z - 20)
                local fraction_edge_r, _ = client_trace_line(entindex, data_x, data_y, data_z, extrapol_x_edge_r, extrapol_y_edge_r, data_z - 20)
                
                local dist_x_l = ((distance * math_cos(extrapol_yaw_rad_edge_l)) * fraction_edge_l)
                local dist_y_l = ((distance * math_sin(extrapol_yaw_rad_edge_l)) * fraction_edge_l)
                local dist_x_r = ((distance * math_cos(extrapol_yaw_rad_edge_r)) * fraction_edge_r)
                local dist_y_r = ((distance * math_sin(extrapol_yaw_rad_edge_r)) * fraction_edge_r)
                local dist_l, dist_r = math_sqrt(((distance * math_cos(extrapol_yaw_rad_edge_l)) * fraction_edge_l)^2 + ((distance * math_sin(extrapol_yaw_rad_edge_l)) * fraction_edge_l)^2), math_sqrt(((distance * math_cos(extrapol_yaw_rad_edge_r)) * fraction_edge_r)^2 + ((distance * math_sin(extrapol_yaw_rad_edge_r)) * fraction_edge_r)^2)  
        
                if fraction_edge_l < 1 or fraction_edge_r < 1 then
                    if dist_r >= dist_l then
                        edge_hits_r = edge_hits_r + 1
                    elseif dist_r < dist_l then
                        edge_hits_l = edge_hits_l + 1
                    end
                end
            end
        
            if edge_hits_l > 2 or edge_hits_r > 2 then
                if edge_hits_r >= edge_hits_l then
                    edge = "RIGHT"
                elseif edge_hits_r < edge_hits_l then
                    edge = "LEFT"
                end
            end

            for i = 1, 8 do
                local extrapol_yaw_rad = math_rad(yaw - 60 + 15 * (i - 1))
                local extrapol_x_fs, extrapol_y_fs = data_x + (distance + 25) * math_cos(extrapol_yaw_rad), data_y + (distance + 25) * math_sin(extrapol_yaw_rad)
                
                if enemy_x ~= nil then
                    local index, damage = client_trace_bullet(entindex, extrapol_x_fs, extrapol_y_fs, enemy_z, enemy_x, enemy_y, enemy_z)
                    local fraction_fs, _ = client_trace_line(entindex, data_x, data_y, data_z, extrapol_x_fs, extrapol_y_fs, data_z)
                    
                    damage = clamp.val(damage, 0, 100)
                    if damage > 5 then
                        freestand_hit = freestand_hit + 1
                    end

                    if fraction_fs == 1 then
                        freestand_angle_x, freestand_angle_y = freestand_angle_x + math_cos(extrapol_yaw_rad) * damage, freestand_angle_y + math_sin(extrapol_yaw_rad) * damage
                    end
                end
            end

            if freestand_hit > 2 and freestand_hit < 8 then
                local avg_dmg = math_atan2(freestand_angle_y, freestand_angle_x) + math_pi
                local avg_dmg_x, avg_dmg_y = data_x + (distance + 25) * math_cos(avg_dmg), data_y + (distance + 25) * math_sin(avg_dmg)

                local calc_freestand_yaw = math_deg(avg_dmg) + 180                   
                local calc_extrapol_yaw = (yaw + 180) - calc_freestand_yaw

                if calc_extrapol_yaw > 180 then
                    calc_freestand_yaw = calc_freestand_yaw + 360
                elseif calc_extrapol_yaw < -180 then
                    calc_freestand_yaw = calc_freestand_yaw - 360
                end
                
                if (yaw + 180) > calc_freestand_yaw then
                    freestand = "RIGHT"
                else
                    freestand = "LEFT"
                end
            end
        end

        return edge, freestand
    end,

    get_weapon_info = 
    function(item_definition_index)
        if cached_weapon_info[item_definition_index] ~= nil then
            return cached_weapon_info[item_definition_index]
        end
    
        local weapon_data_ptr = get_wpn_data(CCSWeaponSystem, item_definition_index)
    
        cached_weapon_info[item_definition_index] = {
            max_player_speed = ffi.cast("float*", weapon_data_ptr + 0x0130)[0],
            max_player_speed_alt = ffi.cast("float*", weapon_data_ptr + 0x0134)[0]
        }
            
        return cached_weapon_info[item_definition_index]
    end,

    desync_lby = 
    function(entindex)
        if entindex ~= nil then
            local lby = entity_get_prop(entindex, "m_flLowerBodyYawTarget")
            local _, enemy_yaw = entity_get_prop(entindex, "m_angEyeAngles")

            local yaw = clamp.ang(enemy_yaw)
            local desync = clamp.ang(yaw - lby)
            
            return desync
        end
    end,

    setup_aa =
    function(activate, rageyaw, rageyaw_slider, at_targets, limit)
        ui_set(ui.aa_enable, activate)
        ui_set(ui.aa_base, at_targets)
        ui_set(ui.aa_rageyaw, rageyaw)
        ui_set(ui.aa_rageyaw_slider, rageyaw_slider)
        ui_set(ui.aa_bodyyaw, "Static")
        --ui_set(ui.aa_limit, limit)
        ui_set(ui.aa_pitch, "Off")
        ui_set(ui.aa_yawjitter, "Off")
        ui_set(ui.aa_edgeyaw, false)
        ui_set(ui.aa_bodyyaw_freestand, false)
        ui_set(ui.aa_autodirection_key, "On hotkey")
    end,    
}

local ent = {
    closest = 
    function()
        local enemy_players = entity_get_players(true)
        local closest_enemy = nil
        local crosshair = math.huge

        if #enemy_players ~= 0 then
            for i = 1, #enemy_players do
                local enemy_player = enemy_players[i]
                local pitch, yaw = data.angles(enemy_player, 0)
                local distance = data.distance(enemy_player, 0)
                local abs_dif = data.angles_dif(pitch, yaw, distance)
    
                if crosshair > abs_dif then
                    crosshair = abs_dif
                    closest_enemy = enemy_player
                end
            end
        end
    
        return closest_enemy
    end,

    bestdmg = 
    function()
        local enemy_players = entity_get_players(true)
        local highest_enemy = nil
        local dmg = 0

        if #enemy_players ~= 0 then    
            for i = 1, #enemy_players do
                local enemy_player = enemy_players[i]
                local ex, ey, ez = entity_hitbox_position(enemy_player, 0)
                local x, y, z = client_eye_position()
                local ent, damage = client_trace_bullet(entity_get_local_player(), x, y, z, ex, ey, ez)
    
                if damage > dmg then
                    dmg = damage
                    highest_enemy = enemy_player
                end
            end
        end
    
        return highest_enemy
    end,

    in_smoke =
    function(entindex)
        local bool_smoked = false

        if entindex ~= nil then
            local local_pos = { entity_hitbox_position(entity_get_local_player(), 0) }
            local enemy_pos = { entity_hitbox_position(entindex, 0) }
            bool_smoked = line_goes_through_smoke(local_pos[1], local_pos[2], local_pos[3], enemy_pos[1], enemy_pos[2], enemy_pos[3], 1)
        end

        return bool_smoked
    end,
}

local hitbox_table = {
    [0] = "Head", [1] = "Head", [2] = "Stomach", [3] = "Stomach", [4] = "Stomach", [5] = "Chest", [6] = "Chest", [7] = "Legs", [8] = "Legs", [9] = "Legs", [10] = "Legs", [11] = "Feet", [12] = "Feet", [13] = "Chest", [14] = "Chest", [15] = "Arms", [16] = "Arms", [17] = "Arms", [18] = "Arms"
}

local ent_hitbox = {
    closest = 
    function(entindex)
        local own_x, own_y, own_z = client_eye_position()
        local crosshair_hitbox = math.huge
        local closest_hitbox = nil
        local hitbox_data = {}

        for j = 0, 18 do
            hitbox_data[j] = {}
        end

        if entindex ~= nil then  
            for i = 0, 18 do
                local x, y, z = entity_hitbox_position(entindex, i)
                local pitch, yaw = data.angles(entindex, i)
                local distance = data.distance(entindex, i)
                local abs_dif, pitch_dif = data.angles_dif(pitch, yaw, distance)
    
                table_insert(hitbox_data[i], hitbox_table[i])
                table_insert(hitbox_data[i], pitch_dif)

                if crosshair_hitbox > pitch_dif then
                    crosshair_hitbox = pitch_dif
                    closest_hitbox = i    
                end
            end
        end
    
        return closest_hitbox, hitbox_data
    end,

    lethal = 
    function(entindex)
        local own_x, own_y, own_z = client_eye_position()
        local lethal = false

        if entindex ~= nil then
            local health = entity_get_prop(entindex, "m_iHealth")
            for i = 0, 18 do 
                local enemy_x, enemy_y, enemy_z = entity_hitbox_position(entindex, i)

                local _, dmg = client_trace_bullet(entity_get_local_player(), own_x, own_y, own_z, enemy_x, enemy_y, enemy_z)
                if dmg > health then
                    lethal = true
                end
            end
        end

        return lethal
    end,

    visible = 
    function(entindex, j, mode)
        local own_x, own_y, own_z = client_eye_position()
        local fake_vis = false
        local amount = 0

        if mode then
            if entindex ~= nil then
                for i = 0, 18 do 
                    local enemy_x, enemy_y, enemy_z = entity_hitbox_position(entindex, i)

                    local _, hitindex = client_trace_line(entity_get_local_player(), own_x, own_y, own_z, enemy_x, enemy_y, enemy_z)
                    if hitindex == entindex then
                        fake_vis = true
                        amount = amount + 1
                    end
                end
            end
        else
            if entindex ~= nil and j ~= nil then
                local enemy_x, enemy_y, enemy_z = entity_hitbox_position(entindex, j)

                local _, hitindex = client_trace_line(entity_get_local_player(), own_x, own_y, own_z, enemy_x, enemy_y, enemy_z)
                if hitindex == entindex then
                    fake_vis = true
                    amount = amount + 1
                end
            end
        end

        return fake_vis, amount
    end,
}

local local_player = {
    aa_state = 
    function()
        local angle_lby = entity_get_prop(entity_get_local_player(), "m_flLowerBodyYawTarget")
        local float_yaw = entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11)
        local _, angle_yaw = client_camera_angles()
        local bodyyaw = float_yaw * 120 - 60

        local yaw = clamp.ang(angle_yaw)
        local lby = clamp.ang(angle_lby)
        local desync = yaw - lby

        local vel = data.velocity(entity_get_local_player())
        local desync_perc = vel <= 1.5 and ((math_abs(bodyyaw - desync)) / 120) or (math_abs(bodyyaw) / 60)

        local r, g, b = color.rgb_prediction(desync_perc, true)

        return desync_perc, r, g, b
    end,
}

local render = {
    wts = 
    function(x, y, z)
        local origin = ffi.new("float[3]")
        local result = ffi.new("float[3]")
        origin[0], origin[1], origin[2] = x, y, z
        result[0], result[1], result[2] = 0, 0, 0
    
        if ScreenTransform(origin, result) == 0 then
            local screen_x, screen_y = client_screen_size()
            local x = screen_x / 2 + 0.5 * result[0] * screen_x + 0.5;
            local y = screen_y / 2 - 0.5 * result[1] * screen_y + 0.5;
            return x, y
        else 
            return nil, nil
        end
    end,

    circle = 
    function(offset_x, offset_y, x_delta, y_delta, percentage, r, g, b)
        local outline = outline == nil and true or outline
        local radius = 9
        local start_degrees = 0

        if outline then
            renderer.circle_outline(offset_x * dpi_scale - x_delta * dpi_scale, offset_y + y_delta, 0, 0, 0, 200, radius * dpi_scale, start_degrees, 1.0, 5 * dpi_scale)
        end
        renderer.circle_outline(offset_x * dpi_scale - x_delta * dpi_scale, offset_y + y_delta, r, g, b, 255, radius * dpi_scale - 1 * dpi_scale, start_degrees, percentage, 3 * dpi_scale)
    end,

    dragging =
    function(container, width, height)
        local mouse_x, mouse_y = ui_mouse_position()
        local click = client_key_state(0x01)
        
        local last_pos_x, last_pos_y = ui_get(pos[container].x_pos), ui_get(pos[container].y_pos)

        if not pos[container].dragging then
            if (mouse_x - last_pos_x <= width + 10 * dpi_scale) and (mouse_x - last_pos_x >= 0) and (mouse_y - last_pos_y <= height * dpi_scale) and (mouse_y - last_pos_y >= 0) then
                if click and not pos[container].clicked then
                    pos[container].dragging = true
                    pos[container].new_x_pos, pos[container].new_y_pos = mouse_x - last_pos_x, mouse_y - last_pos_y
                end
            end
        end

        if pos[container].dragging then
            last_pos_x, last_pos_y = mouse_x - pos[container].new_x_pos, mouse_y - pos[container].new_y_pos

            if not client_key_state(0x01) then
                pos[container].dragging = false
                ui_set(pos[container].x_pos, clamp.val(last_pos_x, 1, new_x - width - (10 * dpi_scale)))
                ui_set(pos[container].y_pos, clamp.val(last_pos_y, 1, new_y - (height * dpi_scale)))
            end
        end

        pos[container].clicked = click
        ui_set(pos[container].x_pos, clamp.val(last_pos_x, 1, new_x - width - (10 * dpi_scale)))
        ui_set(pos[container].y_pos, clamp.val(last_pos_y, 1, new_y - (height * dpi_scale)))
    end,

    container = {
        body = 
        function(type, width, height, r, g, b, a, r1, g1, b1, a1, watermark, height_d)
            renderer.rectangle(ui_get(pos[type].x_pos), ui_get(pos[type].y_pos), width + (10 * dpi_scale), height * dpi_scale, r, g, b, a)
            renderer.rectangle(ui_get(pos[type].x_pos), ui_get(pos[type].y_pos), width + (10 * dpi_scale), 2 * dpi_scale, r1, g1, b1, 255)
            renderer.rectangle(ui_get(pos[type].x_pos), ui_get(pos[type].y_pos) + 20, width + (10 * dpi_scale), 2 * dpi_scale, r1, g1, b1, 255)

            if not watermark then                
                renderer.rectangle(ui_get(pos[type].x_pos), ui_get(pos[type].y_pos) + 22 * dpi_scale, width + 10 * dpi_scale, height_d, r, g, b, a)
                renderer.text(ui_get(pos[type].x_pos) + ((width + 10 * dpi_scale) / 2), ui_get(pos[type].y_pos) + 10 * dpi_scale, 255, 255, 255, 255, "cd", 0, type)
            end
        end,

        info = 
        function(type, offset_x, offset_y, index, flags, text, watermark)
            local dpi_scale_new = string.match(flags, "c") == "c" and 1 or dpi_scale

            if watermark then
                local new_dpi_scale = dpi_scale == 1 and 0 or dpi_scale
                renderer.text(ui_get(pos[type].x_pos) + offset_x * dpi_scale_new, ui_get(pos[type].y_pos) + offset_y * dpi_scale + 1 * new_dpi_scale, 255, 255, 255, 255, flags, 0, text)
            else
                renderer.text(ui_get(pos[type].x_pos) + offset_x * dpi_scale_new, ui_get(pos[type].y_pos) + offset_y * dpi_scale + 12 * dpi_scale * (index - 1), 255, 255, 255, 255, flags, 0, text)
            end
        end,
    },    
}
-- UI Handler
ui_set_visible(pos["Small watermark"].x_pos, false)
ui_set_visible(pos["Small watermark"].y_pos, false)
ui_set_visible(pos["Normal watermark"].x_pos, false)
ui_set_visible(pos["Normal watermark"].y_pos, false)
ui_set_visible(pos["Matchmaking data"].x_pos, false)
ui_set_visible(pos["Matchmaking data"].y_pos, false)
ui_set_visible(pos["Spectators"].x_pos, false)
ui_set_visible(pos["Spectators"].y_pos, false)
ui_set_visible(pos["Indicators"].x_pos, false)
ui_set_visible(pos["Indicators"].y_pos, false)

local function handleFlags()
    if not ui_is_menu_open() then return end
    ui_set_visible(menu.flags_multi, ui_get(menu.flags))
    if ui_get(menu.flags) then
        ui_set(ui.other_flags, true)
    end
end
handleFlags()
client_set_event_callback("paint_ui", handleFlags)

local function handleFOV()
    if not ui_is_menu_open() then return end
    ui_set_visible(menu.indicators_fov_color, ui_get(menu.indicators_fov))
    ui_set_visible(menu.indicators_fov_mode, ui_get(menu.indicators_fov))
end
handleFOV()
client_set_event_callback("paint_ui", handleFOV)

local function handleFL()
    if not ui_is_menu_open() then return end
    local fl = ui_get(menu.aa_legit_fl)
    local mode = ui_get(menu.aa_legit_fl_mode)
    ui_set_visible(menu.aa_legit_fl_mode, fl)
    ui_set_visible(menu.aa_legit_fl_key, fl)
    ui_set_visible(menu.aa_legit_fl_shoot, fl)
end
handleFL()
client_set_event_callback("paint_ui", handleFL)

local function handleIndicators()
    if not ui_is_menu_open() then return end
    local ind = ui_get(menu.indicators)
    local multi = ui_get(menu.indicators_multi)
    local combo = ui_get(menu.indicators_combo)
    ui_set_visible(menu.indicators_multi, ind)
    ui_set_visible(menu.indicators_combo, (ind and #multi ~= 0))
    ui_set_visible(menu.indicators_centered_mode, (ind and #multi ~= 0 and combo == "Centered"))
    ui_set_visible(menu.indicators_repos_default, (ind and #multi ~= 0 and combo == "Default"))
    ui_set_visible(menu.indicators_repos_old, (ind and #multi ~= 0 and combo == "Old"))
    ui_set_visible(menu.indicators_repos_small, (ind and #multi ~= 0 and combo == "Centered"))
    ui_set_visible(menu.indicators_color, (ind and #multi ~= 0 and combo == "Container"))
end
handleIndicators()
client_set_event_callback("paint_ui", handleIndicators)

local function handleResolver()
    if not ui_is_menu_open() then return end
    ui_set_visible(menu.resolver_pred, ui_get(menu.resolver))
    ui_set_visible(menu.resolver_override, (ui_get(menu.resolver) and ui_get(menu.resolver_pred) == "Smart"))
    ui_set_visible(menu.resolver_manual_switch_key, (ui_get(menu.resolver) and ui_get(menu.resolver_pred) == "Manual"))
    ui_set_visible(menu.resolver_manual_draw, ui_get(menu.resolver))
    ui_set_visible(menu.resolver_manual_draw_cp, (ui_get(menu.resolver) and ui_get(menu.resolver_manual_draw)))
    ui_set_visible(menu.resolver_manual_draw_mode, (ui_get(menu.resolver) and ui_get(menu.resolver_pred) == "Manual" and ui_get(menu.resolver_manual_draw)))
end
handleResolver()
client_set_event_callback("paint_ui", handleResolver)

local function handleResolverReset()
    if not ui_get(menu.resolver) then
        ui_set(ui.players_reset, true)
    end
end
handleResolverReset()
ui_set_callback(menu.resolver, handleResolverReset)

local function handleAA()
    if not ui_is_menu_open() then return end
    local aa = ui_get(menu.aa_legit)

    local state = ui_get(menu.aa_legit_state)
    local mode = ui_get(menu.aa_legit_base)
    local ind = ui_get(menu.aa_legit_indicator)
    local safe = ui_get(menu.aa_legit_safe)
    local slowmo = ui_get(menu.aa_legit_slowmo)

    ui_set_visible(menu.aa_legit_base, aa)
    ui_set_visible(menu.aa_legit_state, aa)
    ui_set_visible(menu.aa_legit_indicator, aa)
    ui_set_visible(menu.aa_legit_safe, aa)
    ui_set_visible(menu.aa_legit_slowmo, aa)
    ui_set_visible(menu.aa_legit_antibrute, aa)
    ui_set_visible(menu.aa_legit_antibrute_multi, (aa and ui_get(menu.aa_legit_antibrute)))
    ui_set_visible(menu.aa_legit_yaw_rotate, aa)
    ui_set_visible(menu.aa_legit_yaw_rotate_key, (aa and ui_get(menu.aa_legit_yaw_rotate)))
    ui_set_visible(menu.aa_legit_slowmo_key, (aa and slowmo))
    ui_set_visible(menu.aa_legit_slowmo_slider, (aa and slowmo))
    ui_set_visible(menu.aa_legit_slowmo_lowd, (aa and slowmo))
    ui_set_visible(menu.aa_legit_slowmo_jitter, (aa and slowmo and (ui_get(menu.aa_legit_stand_jitter) or ui_get(menu.aa_legit_moving_jitter) or ui_get(menu.aa_legit_air_jitter))))
    ui_set_visible(menu.aa_legit_indicator_mode, (aa and ind))
    ui_set_visible(menu.aa_legit_base_key, (aa and mode == "Manual"))
    ui_set_visible(menu.aa_legit_safe_trig, (aa and safe))

    ui_set_visible(menu.aa_legit_stand_master, (aa and state == "Standing"))
    ui_set_visible(menu.aa_legit_stand_master_key, (aa and state == "Standing" and ui_get(menu.aa_legit_stand_master)))
    ui_set_visible(menu.aa_legit_stand_at_targets, (aa and state == "Standing" and ui_get(menu.aa_legit_stand_master)))
    ui_set_visible(menu.aa_legit_stand_at_targets_key, (aa and state == "Standing" and ui_get(menu.aa_legit_stand_master) and ui_get(menu.aa_legit_stand_at_targets)))
    ui_set_visible(menu.aa_legit_stand_jitter, (aa and state == "Standing" and ui_get(menu.aa_legit_stand_master)))
    ui_set_visible(menu.aa_legit_stand_jitter_key, (aa and state == "Standing" and ui_get(menu.aa_legit_stand_master) and ui_get(menu.aa_legit_stand_jitter)))
    ui_set_visible(menu.aa_legit_stand_limit, (aa and state == "Standing" and ui_get(menu.aa_legit_stand_master)))
    --ui_set_visible(menu.aa_legit_stand_crooked, (aa and state == "Standing" and ui_get(menu.aa_legit_stand_master)))
    --ui_set_visible(menu.aa_legit_stand_crooked_key, (aa and state == "Standing" and ui_get(menu.aa_legit_stand_master) and ui_get(menu.aa_legit_stand_crooked)))
    ui_set_visible(menu.aa_legit_stand_fs_invert, (aa and mode == "Dynamic" and state == "Standing" and ui_get(menu.aa_legit_stand_master)))
    ui_set_visible(menu.aa_legit_stand_fs_invert_key, (aa and mode == "Dynamic" and state == "Standing" and ui_get(menu.aa_legit_stand_master) and ui_get(menu.aa_legit_stand_fs_invert)))

    ui_set_visible(menu.aa_legit_moving_master, (aa and state == "Moving"))
    ui_set_visible(menu.aa_legit_moving_master_key, (aa and state == "Moving" and ui_get(menu.aa_legit_moving_master)))
    ui_set_visible(menu.aa_legit_moving_at_targets, (aa and state == "Moving" and ui_get(menu.aa_legit_moving_master)))
    ui_set_visible(menu.aa_legit_moving_at_targets_key, (aa and state == "Moving" and ui_get(menu.aa_legit_moving_master) and ui_get(menu.aa_legit_moving_at_targets)))
    ui_set_visible(menu.aa_legit_moving_jitter, (aa and state == "Moving" and ui_get(menu.aa_legit_moving_master)))
    ui_set_visible(menu.aa_legit_moving_jitter_key, (aa and state == "Moving" and ui_get(menu.aa_legit_moving_master) and ui_get(menu.aa_legit_moving_jitter)))
    ui_set_visible(menu.aa_legit_moving_limit, (aa and state == "Moving" and ui_get(menu.aa_legit_moving_master)))
    ui_set_visible(menu.aa_legit_moving_fs_invert, (aa and mode == "Dynamic" and state == "Moving" and ui_get(menu.aa_legit_moving_master)))
    ui_set_visible(menu.aa_legit_moving_fs_invert_key, (aa and mode == "Dynamic" and state == "Moving" and ui_get(menu.aa_legit_moving_master) and ui_get(menu.aa_legit_moving_fs_invert)))

    ui_set_visible(menu.aa_legit_air_master, (aa and state == "In air"))
    ui_set_visible(menu.aa_legit_air_master_key, (aa and state == "In air" and ui_get(menu.aa_legit_air_master)))
    ui_set_visible(menu.aa_legit_air_at_targets, (aa and state == "In air" and ui_get(menu.aa_legit_air_master)))
    ui_set_visible(menu.aa_legit_air_at_targets_key, (aa and state == "In air" and ui_get(menu.aa_legit_air_master) and ui_get(menu.aa_legit_air_at_targets)))
    ui_set_visible(menu.aa_legit_air_jitter, (aa and state == "In air" and ui_get(menu.aa_legit_air_master)))
    ui_set_visible(menu.aa_legit_air_jitter_key, (aa and state == "In air" and ui_get(menu.aa_legit_air_master) and ui_get(menu.aa_legit_air_jitter)))
    ui_set_visible(menu.aa_legit_air_limit, (aa and state == "In air" and ui_get(menu.aa_legit_air_master)))
    ui_set_visible(menu.aa_legit_air_fs_invert, (aa and mode == "Dynamic" and state == "In air" and ui_get(menu.aa_legit_air_master)))
    ui_set_visible(menu.aa_legit_air_fs_invert_key, (aa and mode == "Dynamic" and state == "In air" and ui_get(menu.aa_legit_air_master) and ui_get(menu.aa_legit_air_fs_invert)))

    ui_set_visible(ui.aa_enable, not aa)
    ui_set_visible(ui.aa_pitch, not aa)
    ui_set_visible(ui.aa_base, not aa)
    ui_set_visible(ui.aa_rageyaw, not aa)
    ui_set_visible(ui.aa_rageyaw_slider, not aa)
    ui_set_visible(ui.aa_yawjitter, not aa)
    ui_set_visible(ui.aa_yawjitter_slider, not aa)
    ui_set_visible(ui.aa_bodyyaw, not aa)
    ui_set_visible(ui.aa_bodyyaw_slider, not aa)
    ui_set_visible(ui.aa_bodyyaw_freestand, not aa)
    --ui_set_visible(ui.aa_limit, not aa)
    ui_set_visible(ui.aa_edgeyaw, not aa)
    ui_set_visible(ui.aa_autodirection, not aa)
    ui_set_visible(ui.aa_autodirection_key, not aa)
    ui_set(ui.aa_enable, aa)
    ui_set(ui.aa_rageyaw, aa and 180 or "Off")
    ui_set(ui.aa_rageyaw_slider, 180)
end
handleAA()
client_set_event_callback("paint_ui", handleAA)

local function handleAimbot()
    local aimbot = ui_get(weapon_settings.aimbot_improvements)
    local aimbot_weapon = ui_get(weapon_settings.weapon_name)

    ui_set_visible(weapon_settings.weapon_name, aimbot)
    ui_set_visible(weapon_settings.target_selection, aimbot)
    
    if entity_is_alive(entity_get_local_player()) then
        local aimbot_current_weapon = entity_get_classname(entity_get_player_weapon(entity_get_local_player()))
        misc.weapon_current = weapons[aimbot_current_weapon] ~= nil and weapons[aimbot_current_weapon] or "Global"

        if misc.weapon_switch == nil then
            misc.weapon_switch = aimbot_current_weapon
        end

        if aimbot_current_weapon ~= misc.weapon_switch then
            if not misc.weapon_was_switched then
                misc.weapon_was_switched = true
                misc.weapon_switch = aimbot_current_weapon
            end
        else
            if misc.weapon_was_switched then
                misc.weapon_was_switched = false
            end
        end

        if misc.weapon_was_switched then
            ui_set(weapon_settings.weapon_name, weapons[aimbot_current_weapon] ~= "" and weapons[aimbot_current_weapon] or "Global")
        end
    end

    for k, v in pairs(weapon_settings) do
        if type(weapon_settings[k]) == "table" then
            if #ui_get(weapon_settings[k].hitbox_hitboxes) == 0 then ui_set(weapon_settings[k].hitbox_hitboxes, {"Head", "Chest", "Stomach", "Arms"}) end
            if #ui_get(weapon_settings[k].hitbox_override_hitboxes) == 0 then ui_set(weapon_settings[k].hitbox_override_hitboxes, {"Head", "Chest", "Stomach", "Arms"}) end            
            ui_set_visible(weapon_settings[k].ragebot_settings, (aimbot and k == aimbot_weapon and k ~= "Global"))
            ui_set_visible(weapon_settings[k].ragebot_restrict, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon))
            ui_set_visible(weapon_settings[k].ragebot, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon))
            ui_set_visible(weapon_settings[k].ragebot_key, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].ragebot)))
            ui_set_visible(weapon_settings[k].magnet, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon))
            ui_set_visible(weapon_settings[k].magnet_key, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].magnet)))
            ui_set_visible(weapon_settings[k].fov, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon))
            ui_set_visible(weapon_settings[k].fov_mode, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].fov)))
            ui_set_visible(weapon_settings[k].fov_min, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].fov)))
            ui_set_visible(weapon_settings[k].fov_max, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].fov)))
            ui_set_visible(weapon_settings[k].fov_factor, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].fov) and ui_get(weapon_settings[k].fov_mode) == "Factor"))
            ui_set_visible(weapon_settings[k].autowall, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon))
            ui_set_visible(weapon_settings[k].autowall_mode, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].autowall)))
            ui_set_visible(weapon_settings[k].autowall_key, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].autowall)))
            ui_set_visible(weapon_settings[k].autowall_triggers, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].autowall) and ui_get(weapon_settings[k].autowall_mode) == "Adaptive"))
            ui_set_visible(weapon_settings[k].autowall_visible_hitboxes, (aimbot and k == aimbot_weapon and ui_get(weapon_settings[k].autowall) and ui_get(weapon_settings[k].autowall_mode) == "Adaptive" and array.contains(ui_get(weapon_settings[k].autowall_triggers), "Visible", false)))
            ui_set_visible(weapon_settings[k].hitbox, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon))
            ui_set_visible(weapon_settings[k].hitbox_mode, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].hitbox)))
            ui_set_visible(weapon_settings[k].hitbox_hitboxes, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].hitbox)))
            ui_set_visible(weapon_settings[k].hitbox_multipoints, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].hitbox)))
            ui_set_visible(weapon_settings[k].hitbox_multipoints_scale, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].hitbox)))
            ui_set_visible(weapon_settings[k].bodyaim_prefer, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].hitbox)))
            ui_set_visible(weapon_settings[k].bodyaim_prefer_disable, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].hitbox) and ui_get(weapon_settings[k].bodyaim_prefer)))
            ui_set_visible(weapon_settings[k].hitbox_override, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].hitbox)))
            ui_set_visible(weapon_settings[k].hitbox_override_key, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].hitbox_override)))
            ui_set_visible(weapon_settings[k].hitbox_override_hitboxes, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].hitbox_override)))
            ui_set_visible(weapon_settings[k].hitbox_override_multipoints, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].hitbox_override)))
            ui_set_visible(weapon_settings[k].adaptive, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon))
            ui_set_visible(weapon_settings[k].adaptive_hc, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].adaptive)))
            ui_set_visible(weapon_settings[k].adaptive_dmg, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].adaptive)))
            ui_set_visible(weapon_settings[k].adaptive_dmg_vis, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].adaptive)))
            ui_set_visible(weapon_settings[k].adaptive_override, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].adaptive)))
            ui_set_visible(weapon_settings[k].adaptive_override_key, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].adaptive) and ui_get(weapon_settings[k].adaptive_override)))
            ui_set_visible(weapon_settings[k].adaptive_override_hc, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].adaptive) and ui_get(weapon_settings[k].adaptive_override)))
            ui_set_visible(weapon_settings[k].adaptive_override_dmg, (aimbot and not ui_get(weapon_settings[k].ragebot_settings) and k == aimbot_weapon and ui_get(weapon_settings[k].adaptive) and ui_get(weapon_settings[k].adaptive_override)))
        end
    end
end
handleAimbot()
client_set_event_callback("paint_ui", handleAimbot)

-- Cache choked commands
client_set_event_callback("setup_command", function(c)
    misc.choked_cmds = c.chokedcommands
end)

-- Limit choked commands
client_set_event_callback("paint_ui", function()
    local valve = entity_get_prop(entity.get_all("CCSGameRulesProxy")[1], "m_bIsValveDS", entity_get_local_player())
    local bEngage = false

    local js = panorama.open()
    if js.GameStateAPI.IsQueuedMatchmakingMode_Team() then
        bEngage = true
    end

    --ui_set(ui.sv_maxusrcmdprocessticks, (((valve ~= nil and valve == 1 and bEngage) and 4) or ((valve ~= nil and valve == 1) and 7)) or 15)
end)

-- Allow thirdperson 
client_set_event_callback("paint_ui", function()   
    ui_set(ui.other_tp_dead, ui_get(ui.other_tp_alive) and ui_get(ui.other_tp_alive_key))
end)

client_set_event_callback("setup_command", function(c)
    local default_triggers = ui_get(menu.aa_legit_fl_mode)
    local activated = {}
    local while_shooting = false

    local freeze_time = entity_get_prop(entity_get_game_rules(), "m_bFreezePeriod")
    if (freeze_time) == 1 then return end

    if ui_get(menu.aa_legit_fl) then
        if ui_get(menu.aa_legit_fl_shoot) then
            local shooting = entity_get_prop(entity_get_local_player(), "m_iShotsFired")

            if shooting > 0 then
                -- if misc.ticks_to_lag == nil then
                --     misc.ticks_to_lag = globals_tickcount() - 1)
                -- end

                if misc.ticks_to_lag ~= nil then
                    if globals_tickcount() <= misc.ticks_to_lag then
                        while_shooting = true
                    else
                        while_shooting = false
                    end

                    if globals_tickcount() > misc.ticks_to_lag then
                        misc.ticks_to_lag = nil
                    end
                end
            else
                if misc.ticks_to_lag ~= nil then
                    if globals_tickcount() <= misc.ticks_to_lag then
                        while_shooting = true
                    else
                        while_shooting = false
                    end

                    if globals_tickcount() > misc.ticks_to_lag then
                        misc.ticks_to_lag = nil
                    end
                end
            end
        end

        if #default_triggers > 0 then
            if array.contains(default_triggers, "While moving", false) then
                local vel = data.velocity(entity_get_local_player())
                local in_air = entity_get_prop(entity_get_local_player(), "m_hGroundEntity")

                if vel >= 1.125 and in_air == 0 then
                    if not array.contains(activated, "While moving", false) then
                        table_insert(activated, "While moving")
                    end
                end
            end

            if array.contains(default_triggers, "While standing", false) then
                local vel = data.velocity(entity_get_local_player())
                if vel < 1.125 then
                    if not array.contains(activated, "While standing", false) then
                        table_insert(activated, "While standing")
                    end
                end
            end

            if array.contains(default_triggers, "In air", false) then
                local in_air = entity_get_prop(entity_get_local_player(), "m_hGroundEntity")
                if in_air == nil then
                    if not array.contains(activated, "In air", false) then
                        table_insert(activated, "In air")
                    end
                end
            end
        end

        if (#activated > 0 or while_shooting) and ui_get(menu.aa_legit_fl_key) then
            c.allow_send_packet = misc.choked_cmds >= - 1
        else
            c.allow_send_packet = true
        end
    end
end)

-- Desync detection
client_set_event_callback("run_command", function()
    local players = entity_get_players(true)
    if ui_get(menu.resolver_override) then return end

    for i = 1, #players do
        local ent = players[i]
        
        local vel = data.velocity(ent)
        local _, angle = entity_get_prop(ent, "m_angEyeAngles")
        local lby = entity_get_prop(ent, "m_flLowerBodyYawTarget")
        
        local yaw = clamp.ang(angle)
        local desync = clamp.ang(yaw - lby)

        if vel < 1.125 then
            if math_abs(desync) >= 55 then
                if entity_resolve.time_stamps[ent] == nil then
                    entity_resolve.time_stamps[ent] = client.timestamp()
                end

                if entity_resolve.time_stamps[ent] ~= nil then
                    local new_ts = client.timestamp() - entity_resolve.time_stamps[ent]

                    if new_ts > 1000 then
                        if entity_resolve.is_resolved[ent] == nil then
                            entity_resolve.is_resolved[ent] = true
                        end
                    end
                end
            end
        end
    end
end)

client_set_event_callback("run_command", function()
    local players = entity_get_players(true)

    for i = 1, #players do
        local ent = players[i]
        
        local vel = data.velocity(ent)
        local _, angle = entity_get_prop(ent, "m_angEyeAngles")
        local lby = entity_get_prop(ent, "m_flLowerBodyYawTarget")

        local yaw = clamp.ang(angle)
        local desync = clamp.ang(yaw - lby)

        if vel < 1.125 then
            if math_abs(desync) > 40 then
                if entity_resolve.timings.t[ent] == nil then
                    entity_resolve.timings.t[ent] = globals_tickcount()
                    entity_resolve.timings.updated[ent] = false
                    entity_resolve.timings.dsc[ent] = 0
                    entity_resolve.timings.btotal[ent] = 0
                    entity_resolve.timings.bchanged[ent] = 0
                end

                if globals_tickcount() - entity_resolve.timings.t[ent] > 64 then
                    entity_resolve.timings.t[ent] = globals_tickcount()
                    entity_resolve.timings.updated[ent] = false
                    entity_resolve.timings.dsc[ent] = 0
                    entity_resolve.timings.btotal[ent] = 0
                    entity_resolve.timings.bchanged[ent] = 0
                end

                if entity_resolve.timings.t[ent] + 6 == globals_tickcount()  then
                    if (math_floor(desync + 0.5) > 0 and entity_resolve.timings.dsc[ent] < 0) or (math_floor(desync + 0.5) < 0 and entity_resolve.timings.dsc[ent] > 0) then
                        entity_resolve.timings.bchanged[ent] = entity_resolve.timings.bchanged[ent] + 1
                    end
                end

                if entity_resolve.timings.t[ent] + 6 == globals_tickcount() then
                    entity_resolve.timings.t[ent] = globals_tickcount()
                    entity_resolve.timings.updated[ent] = true
                    entity_resolve.timings.dsc[ent] = math_floor(desync + 0.5)
                    entity_resolve.timings.btotal[ent] = entity_resolve.timings.btotal[ent] + 1
                else
                    entity_resolve.timings.updated[ent] = false
                end
            end
        end

        if entity_resolve.timings.t[ent] ~= nil then
            if entity_resolve.timings.bchanged[ent] / entity_resolve.timings.btotal[ent] > 0.1 then
                entity_resolve.aa_state[ent] = true 
            else
                entity_resolve.aa_state[ent] = false 
            end
        end
    end
end)

------------------------------------------------------------

-- String tables
local teams = {[0] = "None", [1] = "Spec", [2] = "T", [3] = "CT"}
local observer_modes = {[0] = "None", [1] = "Deathcam", [2] = "Freezecam", [3] = "Fixed 3rd person", [4] = "1st person", [5] = "3rd person", [6] = "Noclip"}
local ranks_mmwing = {"No rank", "S I", "S II", "S III", "S IV", "SE", "SEM", "GN I", "GN II", "GN III", "GNM", "MG I", "MG II", "MGE", "DMG", "LE", "LEM", "SMFC", "GE"}
local ranks_danger = {"No rank", "LR I", "LR II", "SH I", "SH II", "WS I", "WS II", "WSE", "HF I", "HF II", "HF III", "HFE", "TW", "EW", "WW", "THA"}
local talkshit = {"blasted lachkick HAHAHAHAHAHAHAHA", ", sit nn dog HHHHHH", ", laff you suck HAHAHAHAHA", ", hhhhhhh 1 shot by the NNblaster", ", RESOLVED habibi $$$", ", e-dating tranny down HAHAHAHAHAHA", ", shamed by true legende $ lachi", ", go RQ noone needs you hhhhhhhhhhh", ", hhh you just got blasted by Eternity", ", HHHHHHHHHHHHHHHH nice 10 iq monkey with BOT playstyle", ", FEMBOY BLASTED HAHAHAHAHAHA", ", 1tap laff sit fucking dog", ", did you know that duke is a qt? well now u know. 1 btw hrsn newfag", " , covid joiner blasted hhhhhhhhh", " , genderconfused noname owned LMAO ", "no Eternity no talk d0g", " , thats a 1 on my screen ROFLCOPTER", " , imagine still no Eternity in 2022 LACHBOMBE", " , go fucking hang yourself hrsn gypsy", " , estrogen addict kys hhhhhhhh","1", "just go rq ur trash", "why r u so shit", "1 nn down", "kys ur so bad", "menu -> quit game pls", "skeetless nn raped", "raped dog", "1", "weak rat", "bow down to me nn", "rekt", "mad got killed? hhh", "sit down nn", "owNNed", "dude look at that kd", "1", "owned LOL!", "shithead raped", "nn deported back to hell", "1 1 1 1 1", "wow that's a 1", "get 1'd", "h$", "EZ BOTS", "why so ez bro?", "raped", "that's a 1", "1 on my screen", "kys", "Did you actually sell your anal virginity for that trash hack?", "$$$ OwNeD DeGeNeRaTe $$$", "yourpaste.cc/refund.php", "I thought trump is the biggest retard on earth but u are atleast 2 steps ahead", "YOU BETTER RAGEQUIT NOW HAHA", "shitted on", "is that the best you can do?", "get on my level retard", "honestly just quit hvh", "aptal noname", "headshot!!!", "katie stack better", "1 dog", "nice suicide peek, do it irl too pls", "get out of my game", "imagine being Eternityless in 2022", "1 on my screen", "thats going in my media compilation right there get shamed retard rofl"}

local votes = {
	no_team = {
		[0] = "kick",
		[1] = "changelevel",
		[3] = "scrambleteams",
		[4] = "swapteams",
    },
    
	team = {
		[1] = "starttimeout",
		[2] = "surrender"
    },
    
	description = {
		changelevel = "change the map",
		scrambleteams = "scramble the teams",
		starttimeout = "start a timeout",
		surrender = "surrender",
		kick = "kick"
	},

	current_votes = {},
	options = {}
}

local function print_chat(text)
	print_to_chat(hudchat, 0, 0, text)
end

-- Talk shit
local function misc_chat_spam(alp)
    if ui_get(menu.shittalk) then
        local victim_userid, attacker_userid = alp.userid, alp.attacker
        if victim_userid == nil or attacker_userid == nil then
            return
        end

        local escape_text = panorama.loadstring("return {a:function(text){return text.match(/.{1,2}/g).join(\x22\x5Cu200C\x22)}}")().a
        local table_length = #talkshit

        local victim_entindex = client_userid_to_entindex(victim_userid)
        local attacker_entindex = client_userid_to_entindex(attacker_userid)
        
        if attacker_entindex == entity_get_local_player() and entity_is_enemy(victim_entindex) then
            local message = "say " .. escape_text(talkshit[math_floor(math_random(1, table_length) + 0.5)])
            client.exec(message)
        end
    end
end

-- Print to chat
client_set_event_callback("vote_options", function(alp)
    if alp ~= nil then
        votes.options = {alp.option1, alp.option2, alp.option3, alp.option4, alp.option5}
    end
end)

local function print_hit(alp)
    local chat_table = ui_get(menu.print_data)

	if array.contains(chat_table, "Hit shots", false) then
        local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear" }
        local group = hitgroup_names[alp.hitgroup + 1] or "?"

        local target_name = entity_get_player_name(alp.target)
        local team_name = teams[entity_get_prop(alp.target, "m_iTeamNum")]
        local health = entity_get_prop(alp.target, "m_iHealth") == nil and 0 or entity_get_prop(alp.target, "m_iHealth")
        local damage = alp.damage
        local team_color = (team_name == "T" and "\x07") or (team_name == "CT" and "\x0B") or "\x05"
        local hit_text = string.format(" \x01[\x06Eternity\x01] Hit %s%s%s in the %s for %s damage (%s health remaining)", team_color, target_name, "\x01", group, damage, health)

        print_chat(hit_text)
    end

end
client_set_event_callback("aim_hit", print_hit)

local function print_miss(alp)
    local chat_table = ui_get(menu.print_data)

    if array.contains(chat_table, "Missed shots", false) and alp ~= nil then
        local target_name = entity_get_player_name(alp.target)
        local team_name = teams[entity_get_prop(alp.target, "m_iTeamNum")]
        local reason = alp.reason == "?" and "resolver" or alp.reason
        local team_color = (team_name == "T" and "\x07") or (team_name == "CT" and "\x0B") or "\x05"
        local miss_text = string.format(" \x01[\x02Eternity\x01] Missed shot on %s%s%s due to %s%s%s", team_color, target_name, "\x01", "\x05", reason, "\x01")

        print_chat(miss_text)
    end    
end
client_set_event_callback("aim_miss", print_miss)

local function print_vote(alp)
    client.delay_call(0.3, function()
        local chat_table = ui_get(menu.print_data)
        if alp == nil then return end

        if array.contains(chat_table, "Votes", false) and alp.entityid ~= nil then
            if votes.options then
                local team = alp.team
        
                local controller
                local vote_controllers = entity.get_all("CVoteController")

                for i = 1, #vote_controllers do
                    if entity_get_prop(vote_controllers[i], "m_iOnlyTeamToVote") == team then
                        controller = vote_controllers[i]
                        break
                    end
                end

                if controller then
                    local issue_index = entity_get_prop(controller, "m_iActiveIssueIndex")
                    local current_vote = {
                        team = team,
                        options = votes.options,
                        controller = controller,
                        issue = issue_index,
                        type = (team ~= -1 and votes.team[issue_index]) and votes.team[issue_index] or votes.no_team[issue_index],
                        votes = {}
                    }

                    for i = 1, #votes.options do
                        current_vote.votes[votes.options[i]] = {}
                    end

                    votes.current_votes["team"] = current_vote
                end
                votes.options = nil
            end

            local current_vote = votes.current_votes["team"]

            if current_vote then
                local target_name = entity_get_player_name(alp.entityid)
                local team_name = teams[entity_get_prop(alp.entityid, "m_iTeamNum")]
                local option = current_vote.options[alp.vote_option + 1]

                local team_color = (team_name == "T" and "\x07") or (team_name == "CT" and "\x0B") or "\x05"
                local vote_color = option == "Yes" and "\x04" or "\x02"

                table_insert(current_vote.votes[option], alp.entityid)

                if option == "Yes" and current_vote.caller == nil then
                    current_vote.caller = alp.entityid

                    if current_vote.type ~= "kick" then
                        local vote_text = string.format(" \x01[\x10Eternity\x01] %s%s%s called a vote to %s%s", team_color, entity_get_player_name(alp.entityid), "\x01", votes.description[current_vote.type], "\x01")
                        print_chat(vote_text)
                    end
                end

                if current_vote.type == "kick" then
                    if option == "No" then
                        if current_vote.target == nil then
                            current_vote.target = alp.entityid

                            local vote_text = string.format(" \x01[\x10Eternity\x01] %s%s%s called a vote to %s %s%s", team_color, team_name, "\x01", votes.description[current_vote.type], team_color, entity_get_player_name(current_vote.target), "\x01")
                            print_chat(vote_text)
                        end
                    end
                end

                local vote_text = string.format(" \x01[\x10Eternity\x01] %s%s%s voted %s%s", team_color, entity.get_player_name(alp.entityid), "\x01", vote_color, option)
                print_chat(vote_text)
            end
        end
    end)
end
client_set_event_callback("vote_cast", print_vote)

local function print_bought_weapons(alp)
    client.delay_call(0.3, function()
        local chat_table = ui_get(menu.print_data)

        if array.contains(chat_table, "Bought weapons", false) and alp ~= nil then
            local target = client_userid_to_entindex(alp.userid)
            local target_name = entity_get_player_name(target)
            local team_name = teams[entity_get_prop(target, "m_iTeamNum")]
            local local_team = teams[entity_get_prop(entity_get_local_player(), "m_iTeamNum")]
            local team_color = (team_name == "T" and "\x07") or (team_name == "CT" and "\x0B") or "\x05"
            
            local weapon_text = string.format(" \x01[\x10Eternity\x01] %s%s%s bought %s%s%s", team_color, target_name, "\x01", "\x05", alp.weapon, "\x01")
            
            if local_team ~= team_name then
                print_chat(weapon_text)
            end
        end
    end)
end
client_set_event_callback("item_purchase", print_bought_weapons)

local function print_weapon_change()
    local chat_table = ui_get(menu.print_data) 
    
    
    if array.contains(chat_table, "Weapon change", false) then
        if misc.weapon_was_switched then
            local change_text = string.format(" \x01[\x10Eternity\x01] Weapon%schanged to %s%s%s", weapons[misc.weapon_switch] == nil and " group " or " ", "\x05", weapons[misc.weapon_switch] == nil and "Global" or weapons[misc.weapon_switch], "\x01")
            print_chat(change_text)
        end
    end
end
client_set_event_callback("paint_ui", print_weapon_change)
local lua_user = {username = 'scriptleaks', build = 'Boosters', discord='https://discord.gg/scriptleaks'}

------------------------------------------------------------

local strClantag = "Eternity"
local active = {}
local strPlaceholder = ""
local strPrevious = ""
local refEnable = ui_new_checkbox("MISC", "Miscellaneous", "Clan tag spammer")
local function update()
local fltTime = globals_curtime() + client.real_latency()
local intStep = math_floor((fltTime) / 0.5)
local intLength = math_abs(intStep % (#strClantag * 4) - #strClantag * 2)
local intSeed = intStep - (intStep % (#strClantag))
-- renderer.indicator(255, 255, 0, 255, intLength .. " | " .. intSeed)
local strCurrent = strClantag
if intLength > #strClantag * 1.5 then
    if intLength % 2 < 1 then
        strCurrent = "(/._.)/"
    else
        strCurrent = "\\(._.\\)"
    end
elseif intLength < #strClantag then
    math.randomseed(intSeed)
    local tblCurrent = {}
    for i = 1, #strClantag, 1 do
        tblCurrent[i] = strPlaceholder
    end
    local tblLeft = {}
    for i = 1, #strClantag, 1 do
        tblLeft[i] = {strClantag:sub(i, i), i}
    end
    for i = 1, intLength, 1 do
        local strChar, intIndex = unpack(table_remove(tblLeft, math_random(#tblLeft)))
        tblCurrent[intIndex] = strChar
    end
    strCurrent = table.concat(tblCurrent)
end
-- renderer.indicator(255, 255, 0, 255, strCurrent)
if strCurrent ~= strPrevious then
    client_set_clan_tag(strCurrent)
    strPrevious = strCurrent
end
end
local function shutdown()
client_set_clan_tag("")
end
ui_set_callback(refEnable, function()
if ui_get(refEnable) then
    client_set_event_callback("paint", update)
    client_set_event_callback("shutdown", shutdown)
else
    shutdown()
    client.unset_event_callback("paint", update)
    client.unset_event_callback("shutdown", shutdown)
end
end)
--------------------
-- Main functions --
--------------------
local is_in_game = vtable_bind('engine.dll', 'VEngineClient014', 26, 'bool(__thiscall*)(void*)')
-- Watermark
client_set_event_callback("paint_ui", function()
    local r, g, b
    local r_b, g_b, b_b, a_b = ui_get(menu.watermark_color_body)

    if ui_get(menu.rainbow) then
        r, g, b = rainbowize.rgb(0.5, 1)
    else
        r, g, b = ui_get(menu.watermark_color)
    end

    --local role = (lua_role == "Coder" and " [coder]") or (lua_role == "Nword" and " [debug]") or (lua_role == "Alpha" and " [alpha]") or ""

    if ui_get(menu.watermark_mode) == "Classic Watermark" then
        local ping = client_latency() * 1000
        local fpsdraw = accumulate_fps()
        local fpsString = tostring(fpsdraw)
        local fps = string.rep(" ", 3 - #fpsString) .. fpsString
        local hours_lua, minutes_lua, seconds_lua = client.system_time()
        local hours, minutes, seconds = string.format("%02d", hours_lua), string.format("%02d", minutes_lua), string.format("%02d", seconds_lua)
        
        local text = string.format("Eternity [%s]   %s   fps: %s   %s:%s:%s", lua_user.build, lua_user.username, fps, hours, minutes, seconds)
        if is_in_game() == true then
            local latency_text = 
                ping > 1 and ('  %dms'):format(ping) or ''
                text = string.format("Eternity [%s]   %s  %s   fps: %s   %s:%s:%s", lua_user.build, lua_user.username, latency_text, fps, hours, minutes, seconds)
        end
        
        local width, height = renderer_measure_text("d", text)

        render.dragging("Normal watermark", width, 20)
        render.container.body("Normal watermark", width, 20, r_b, g_b, b_b, a_b, r, g, b, 255, true)
        render.container.info("Normal watermark", 5, 4, 0, "d", text, true)
    elseif ui_get(menu.watermark_mode) == "Minimalistic Watermark" then
        local text = string.format("%s", lua_user.username)
        local width, height = renderer_measure_text("d", text)

        render.dragging("Small watermark", width, 20)
        render.container.body("Small watermark", width, 20, r_b, g_b, b_b, a_b, r, g, b, 255, true)
        render.container.info("Small watermark", 5, 4, 0, "d", text, true)
    elseif ui_get(menu.watermark_mode) == "Text" then
        local text = string.format("Eternity %s ", lua_user.build)
        local text_lower = string.format("%s is immortal", lua_user.username)
        renderer_text(7 * dpi_scale, 6 * dpi_scale, r, g, b, 255, "d+", 0, text)
        renderer_text(7 * dpi_scale, 27 * dpi_scale, r, g, b, 255, "d+", 0, text_lower)
    end
end)

local function aimbot_improvements()
    if weapon_settings[misc.weapon_current] then 

        local aimbot = ui_get(weapon_settings.aimbot_improvements)
        local weapon_current = ui_get(weapon_settings[misc.weapon_current].ragebot_settings) and "Global" or misc.weapon_current

        if aimbot then
            local aimbot_target = ui_get(weapon_settings.target_selection)
            local aimbot_checks = ui_get(weapon_settings[weapon_current].ragebot_restrict)

            local players = entity_get_players(true)
            local local_player = entity_get_local_player()
            local closest_enemy = ent.closest() ~= nil and ent.closest() or local_player
            local highest_enemy = ent.bestdmg() ~= nil and ent.bestdmg() or local_player

            local target = aimbot_target == "Crosshair" and closest_enemy or highest_enemy
            ui_set(ui.ragebot_target_selection, aimbot_target == "Crosshair" and "Near crosshair" or "Highest damage")
            
            local _, _, button_code = ui_get(ui.ragebot_enable_mode)
            
            if button_code ~= nil then
                client.color_log(255, 0, 0, "Unbind ragebot key (RAGEBOT -> Enabled -> Key and press ESC)")
            end
            
            local function do_ragebot()
                local smoke_check = (ent.in_smoke(target) and array.contains(aimbot_checks, "Smoke", false))
                local flash_check = (data.in_flash(local_player) and array.contains(aimbot_checks, "Flash", false))
                local air_check = (data.in_air(target) and array.contains(aimbot_checks, "In air", false))

                if (ui_get(weapon_settings[weapon_current].ragebot) or ui_get(weapon_settings[weapon_current].magnet)) and not ui_is_menu_open() and not smoke_check and not flash_check and not air_check then
                    if (ui_get(weapon_settings[weapon_current].ragebot) and ui_get(weapon_settings[weapon_current].ragebot_key)) or (ui_get(weapon_settings[weapon_current].magnet) and ui_get(weapon_settings[weapon_current].magnet_key)) then
                        ui_set(ui.ragebot_enable_mode, "Always on")

                        aimbot_bool.autofire = true
                    else
                        ui_set(ui.ragebot_enable_mode, "On hotkey")

                        aimbot_bool.autofire = false
                    end
                else
                    ui_set(ui.ragebot_enable_mode, "On hotkey")

                    aimbot_bool.autofire = false
                end
            end

            local function do_adaptive()
                if ui_get(weapon_settings[weapon_current].adaptive) then
                    local visible, amount = ent_hitbox.visible(target, nil, true)

                    if ui_get(weapon_settings[weapon_current].adaptive_override) and ui_get(weapon_settings[weapon_current].adaptive_override_key) then
                        ui_set(ui.ragebot_minhc, ui_get(weapon_settings[weapon_current].adaptive_override_hc))
                        ui_set(ui.ragebot_mindmg, ui_get(weapon_settings[weapon_current].adaptive_override_dmg))

                        aimbot_bool.override_settings = true
                    else
                        ui_set(ui.ragebot_minhc, ui_get(weapon_settings[weapon_current].adaptive_hc))
                        if visible and amount >= 10 then
                            ui_set(ui.ragebot_mindmg, ui_get(weapon_settings[weapon_current].adaptive_dmg_vis))
                        else
                            ui_set(ui.ragebot_mindmg, ui_get(weapon_settings[weapon_current].adaptive_dmg))
                        end

                        aimbot_bool.override_settings = false
                    end
                else
                    aimbot_bool.override_settings = false
                end
            end

            local function do_hitbox()
                -- if ui_get(weapon_settings[weapon_current].hitbox) then
                --     if ui_get(weapon_settings[weapon_current].bodyaim_prefer) then
                --         ui_set(ui.ragebot_prefer_baim, true)
                --         ui_set(ui.ragebot_prefer_baim_disable, ui_get(weapon_settings[weapon_current].bodyaim_prefer_disable))
                --     else
                --         ui_set(ui.ragebot_prefer_baim, false)
                --     end

                    if ui_get(weapon_settings[weapon_current].hitbox_override) and ui_get(weapon_settings[weapon_current].hitbox_override_key) then
                        ui_set(ui.ragebot_hitbox, #ui_get(weapon_settings[weapon_current].hitbox_override_hitboxes) == 0 and {"Head"} or ui_get(weapon_settings[weapon_current].hitbox_override_hitboxes))
                        ui_set(ui.ragebot_mp, ui_get(weapon_settings[weapon_current].hitbox_override_multipoints))
                        ui_set(ui.ragebot_mp_slider, ui_get(weapon_settings[weapon_current].hitbox_multipoints_scale))

                        aimbot_bool.override_hitbox = true
                    else
                        ui_set(ui.ragebot_mp, ui_get(weapon_settings[weapon_current].hitbox_multipoints))
                        ui_set(ui.ragebot_mp_slider, ui_get(weapon_settings[weapon_current].hitbox_multipoints_scale))

                        if ui_get(weapon_settings[weapon_current].hitbox_mode) == "Normal" then
                            ui_set(ui.ragebot_hitbox, #ui_get(weapon_settings[weapon_current].hitbox_hitboxes) == 0 and {"Head", "Chest", "Stomach", "Arms"} or ui_get(weapon_settings[weapon_current].hitbox_hitboxes))
                        elseif ui_get(weapon_settings[weapon_current].hitbox_mode) == "Near crosshair" then
                            if #players == 0 then
                                ui_set(ui.ragebot_hitbox, #ui_get(weapon_settings[weapon_current].hitbox_hitboxes) == 0 and {"Head", "Chest", "Stomach", "Arms"} or ui_get(weapon_settings[weapon_current].hitbox_hitboxes))
                            else
                                local i = ent_hitbox.closest(target)
                                if array.contains(ui_get(weapon_settings[weapon_current].hitbox_hitboxes), hitbox_table[i], false) then
                                    ui_set(ui.ragebot_hitbox, hitbox_table[i])
                                end
                            end
                        elseif ui_get(weapon_settings[weapon_current].hitbox_mode) == "Smart" then
                            if #players == 0 then
                                ui_set(ui.ragebot_hitbox, #ui_get(weapon_settings[weapon_current].hitbox_hitboxes) == 0 and {"Head", "Chest", "Stomach", "Arms"} or ui_get(weapon_settings[weapon_current].hitbox_hitboxes))
                            else
                                local i, hitboxes = ent_hitbox.closest(target)
                                local i_vis = ent_hitbox.visible(target, i, false)

                                table.sort(hitboxes, function(a, b) return a[2] < b[2] end)
                                local hitbox = ""

                                for k = 1, #hitboxes do
                                    local table_key = array.invert(hitbox_table, hitboxes[k][1])
                                    local is_visible = ent_hitbox.visible(target, table_key, false)

                                    if is_visible and array.contains(ui_get(weapon_settings[weapon_current].hitbox_hitboxes), hitboxes[k][1], false) then
                                        hitbox = hitboxes[k][1]
                                        break
                                    end
                                end
                                
                                ui_set(ui.ragebot_hitbox, (#ui_get(weapon_settings[weapon_current].hitbox_hitboxes) == 0 or hitbox == "") and {"Head", "Chest", "Stomach", "Arms"} or hitbox)
                            end
                        end
                        aimbot_bool.override_hitbox = false
                    end
                -- else
                --     ui_set(ui.ragebot_prefer_baim, false)
                --     aimbot_bool.override_hitbox = false
                --end
            end

            local function do_dynamic_fov()
                if ui_get(weapon_settings[weapon_current].fov) then
                    if #players == 0 then
                        if ui_get(ui.ragebot_maximum_fov) ~= ui_get(weapon_settings[weapon_current].fov_max) then
                            ui_set(ui.ragebot_maximum_fov, ui_get(weapon_settings[weapon_current].fov_max))
                        end
                    else
                        local distance = data.distance(target, 0)
                        local dynamicfov_new_fov = ui_get(weapon_settings[weapon_current].fov_mode) == "Distance" and clamp.val(ui_get(weapon_settings[weapon_current].fov_max) - ((ui_get(weapon_settings[weapon_current].fov_max) - ui_get(weapon_settings[weapon_current].fov_min)) * (distance - 250) / 1000), ui_get(weapon_settings[weapon_current].fov_min), ui_get(weapon_settings[weapon_current].fov_max)) or clamp.val((3800 / distance) * (0.01 * ui_get(weapon_settings[weapon_current].fov_factor)), ui_get(weapon_settings[weapon_current].fov_min), ui_get(weapon_settings[weapon_current].fov_max)) 

                        if ui_get(ui.ragebot_maximum_fov) ~= dynamicfov_new_fov  then
                            ui_set(ui.ragebot_maximum_fov, dynamicfov_new_fov)
                        end
                    end
                end
            end

            local function do_autowall()
                if ui_get(weapon_settings[weapon_current].autowall) then
                    if ui_get(weapon_settings[weapon_current].autowall_mode) == "Manual" then
                        ui_set(ui.ragebot_autowall, ui_get(weapon_settings[weapon_current].autowall_key))
                    elseif ui_get(weapon_settings[weapon_current].autowall_mode) == "Adaptive" then
                        if ui_get(weapon_settings[weapon_current].autowall_key) then
                            ui_set(ui.ragebot_autowall, true)
                        else
                            if #ui_get(weapon_settings[weapon_current].autowall_triggers) == 0 then ui_set(ui.ragebot_autowall, false) end
                            local damage_check, visibility_check = array.contains(ui_get(weapon_settings[weapon_current].autowall_triggers), "Lethal", false), array.contains(ui_get(weapon_settings[weapon_current].autowall_triggers), "Visible", false)
                            local is_vis, vis_amount = ent_hitbox.visible(target, nil, true)
                            local is_lethal = ent_hitbox.lethal(target)

                            if #ui_get(weapon_settings[weapon_current].autowall_triggers) == 1 then
                                ui_set(ui.ragebot_autowall, ((damage_check and is_lethal) and true or false) or ((visibility_check and is_vis and vis_amount >= ui_get(weapon_settings[weapon_current].autowall_visible_hitboxes)) and true or false) or false)
                            elseif #ui_get(weapon_settings[weapon_current].autowall_triggers) == 2 then
                                ui_set(ui.ragebot_autowall, (damage_check and is_lethal and visibility_check and is_vis and vis_amount >= ui_get(weapon_settings[weapon_current].autowall_visible_hitboxes)))
                            end
                        end
                    end
                else
                    ui_set(ui.ragebot_autowall, false)
                end
            end

            do_ragebot()
            do_adaptive()
            do_dynamic_fov()
            do_hitbox()
            do_autowall()
        end
    end
end

local function aa_optim()
    ui.fakelag_cache = ui.fakelag_cache ~= nil and ui.fakelag_cache or ui_get(ui.other_fakelag_limit)

    local engage = 0
    local aa, fake_duck = ui_get(menu.aa_legit), ui_get(ui.aa_fake_duck)
    
    local js = panorama.open()
    if js.GameStateAPI.IsQueuedMatchmakingMode_Team() then
        engage = 1
    end

    local sv_proccess = 7

    if fake_duck then
        ui_set(ui.other_fakelag_limit, clamp.val(14, 1, sv_proccess))
    else
        if ui.fakelag_cache ~= nil then
            ui_set(ui.other_fakelag_limit, clamp.val(ui.fakelag_cache, 1, sv_proccess))
            ui.fakelag_cache = nil
        end
    end
end

local function aa_impact(alp)
    if not ui_get(menu.aa_legit) then return end

    local target = client_userid_to_entindex(alp.userid)
    if target ~= nil then
        if not entity_is_enemy(target) then return end

        if ui_get(menu.aa_legit_antibrute) and array.contains(ui_get(menu.aa_legit_antibrute_multi), "On miss", false) then
            entity_resolve.anti_brute[target] = entity_resolve.anti_brute[target] ~= nil and entity_resolve.anti_brute[target] or aa_state
            local pitch, yaw = data.angles_for_enemy(target, 0)
            local distance = data.distance(target, 0)
            local abs_dif, pitch_dif, yaw_dif = data.angles_dif_enemy(pitch, yaw, distance, target)

            if yaw_dif < clamp.val(825 / distance, 0.5, 10) and yaw_dif > -clamp.val(825 / distance, 0.5, 10) then
                if entity_resolve.anti_brute[target] == "RIGHT" then
                    entity_resolve.anti_brute[target] = "LEFT"
                elseif entity_resolve.anti_brute[target] == "LEFT" then
                    entity_resolve.anti_brute[target] = "RIGHT"
                end
            end
        end
    end
end
client_set_event_callback("bullet_impact", aa_impact)

local function aa_hurt(alp)
    if not ui_get(menu.aa_legit) then return end

    local victim = client_userid_to_entindex(alp.userid)
    local attacker = client_userid_to_entindex(alp.attacker)
    if victim == entity_get_local_player() and attacker ~= entity_get_local_player() then
        if not entity_is_enemy(attacker) then return end

        if ui_get(menu.aa_legit_antibrute) and array.contains(ui_get(menu.aa_legit_antibrute_multi), "On hit", false) then
            entity_resolve.anti_brute[attacker] = entity_resolve.anti_brute[attacker] ~= nil and entity_resolve.anti_brute[attacker] or aa_state
            if entity_resolve.anti_brute[attacker] == "RIGHT" then
                entity_resolve.anti_brute[attacker] = "LEFT"
            elseif entity_resolve.anti_brute[attacker] == "LEFT" then
                entity_resolve.anti_brute[attacker] = "RIGHT"
            end
        end
    end
end
client_set_event_callback("player_hurt", aa_hurt)

local function aa_brute_reset(alp)
    if not ui_get(menu.aa_legit) then return end

    local dead, lp = alp.userid, alp.attacker
    local dead_id, lp_id = client_userid_to_entindex(dead), client_userid_to_entindex(lp)
    if (lp_id == entity_get_local_player() and entity_is_enemy(dead_id)) or dead_id == entity_get_local_player() then
        if ui_get(menu.aa_legit_antibrute) then
            entity_resolve.anti_brute = { }
        end
    end
end
client_set_event_callback("player_death", aa_brute_reset)

local function aa_breaker()
    local aa, aa_mode, aa_key, aa_safe, aa_safe_triggers, aa_brute, aa_brute_multi = ui_get(menu.aa_legit), ui_get(menu.aa_legit_base), ui_get(menu.aa_legit_base_key), ui_get(menu.aa_legit_safe), ui_get(menu.aa_legit_safe_trig)
    local bad_fps, pl, fd, fl, disable_jitter, gren, aa_safe_allow = false, false, false, false, false, false, false, false, false

    local local_player = entity_get_local_player()
    local players = entity_get_players(true)
    local freeze_time = entity_get_prop(entity_get_game_rules(), "m_bFreezePeriod")

    if not aa then return end
    if not entity_is_alive(entity_get_local_player()) then return end
    if (freeze_time) == 1 then return end

    local fps, velocity = accumulate_fps(), data.velocity(local_player)

    local weapon_name = entity_get_classname(entity_get_player_weapon(local_player))
    local weapon_id = entity_get_prop(entity_get_player_weapon(local_player), "m_iItemDefinitionIndex")
    local throw = entity_get_prop(entity_get_player_weapon(local_player), "m_fThrowTime")  

    local aimbot_target = ui_get(weapon_settings.target_selection)
    local closest_enemy = ent.closest() ~= nil and ent.closest() or local_player
    local highest_enemy = ent.bestdmg() ~= nil and ent.bestdmg() or local_player
    local target = aimbot_target == "Crosshair" and closest_enemy or highest_enemy

    local in_air = entity_get_prop(entity_get_local_player(), "m_hGroundEntity") == nil and true or false
    local standing, moving = (velocity <= 1.5 and not in_air), (velocity > 1.5 and not in_air)
    local aa_enable, aa_enable_key, aa_jitter, aa_jitter_key, aa_crooked, aa_style, aa_targets, aa_targets_key, aa_invert, aa_invert_key
    local aa_rotate, aa_rotate_key = ui_get(menu.aa_legit_yaw_rotate), ui_get(menu.aa_legit_yaw_rotate_key)
    
    if standing then
        aa_enable, aa_enable_key, aa_jitter, aa_jitter_key, aa_crooked, aa_targets, aa_targets_key, aa_invert, aa_invert_key = ui_get(menu.aa_legit_stand_master), ui_get(menu.aa_legit_stand_master_key), ui_get(menu.aa_legit_stand_jitter), ui_get(menu.aa_legit_stand_jitter_key), ui_get(menu.aa_legit_stand_limit), false, ui_get(menu.aa_legit_stand_at_targets), ui_get(menu.aa_legit_stand_at_targets_key), ui_get(menu.aa_legit_stand_fs_invert), ui_get(menu.aa_legit_stand_fs_invert_key)
    elseif moving then
        aa_enable, aa_enable_key, aa_jitter, aa_jitter_key, aa_crooked, aa_targets, aa_targets_key, aa_invert, aa_invert_key = ui_get(menu.aa_legit_moving_master), ui_get(menu.aa_legit_moving_master_key), ui_get(menu.aa_legit_moving_jitter), ui_get(menu.aa_legit_moving_jitter_key), ui_get(menu.aa_legit_moving_limit), false, ui_get(menu.aa_legit_moving_at_targets), ui_get(menu.aa_legit_moving_at_targets_key), ui_get(menu.aa_legit_moving_fs_invert), ui_get(menu.aa_legit_moving_fs_invert_key)
    elseif in_air then
        aa_enable, aa_enable_key, aa_jitter, aa_jitter_key, aa_crooked, aa_targets, aa_targets_key, aa_invert, aa_invert_key = ui_get(menu.aa_legit_air_master), ui_get(menu.aa_legit_air_master_key), ui_get(menu.aa_legit_air_jitter), ui_get(menu.aa_legit_air_jitter_key), ui_get(menu.aa_legit_air_limit), false, ui_get(menu.aa_legit_air_at_targets), ui_get(menu.aa_legit_air_at_targets_key), ui_get(menu.aa_legit_air_fs_invert), ui_get(menu.aa_legit_air_fs_invert_key)
    end

    if aa_safe then
        bad_fps = (array.contains(aa_safe_triggers, "Low FPS", false) and fps < 60)
        fl = (array.contains(aa_safe_triggers, "Fake lag", false) and misc.choked_cmds > 6)
        fd = (array.contains(aa_safe_triggers, "Fake duck", false) and ui_get(ui.aa_fake_duck))
        pl = (array.contains(aa_safe_triggers, "Packet loss", false) and (globals.frametime() > globals.tickinterval()))
        gren = (array.contains(aa_safe_triggers, "Grenade", false) and ((weapon_name == "CSmokeGrenade" or weapon_name == "CFlashbang" or weapon_name == "CHEGrenade" or weapon_name == "CDecoyGrenade" or weapon_name == "CIncendiaryGrenade" or weapon_name == "CMolotovGrenade" or weapon_name == "CSensorGrenade") and throw > 0))

        if bad_fps or fl or fd or pl or gren then
            aa_safe_allow = true
        end
    end

    if aa and aa_enable and aa_enable_key then
        local aa_bruteforce = (((entity_resolve.anti_brute[target] ~= nil and entity_resolve.anti_brute[target] == "RIGHT") and 90) or ((entity_resolve.anti_brute[target] ~= nil and entity_resolve.anti_brute[target] == "LEFT") and -90)) or nil
        local new_val

        if not ui_get(menu.aa_legit_antibrute) then
            entity_resolve.anti_brute = { }
            aa_bruteforce = nil
        end

        local yaw_rotate = 180
        if aa_mode == "Manual" then
            ui_set(menu.aa_legit_base_key, "Toggle")
            if aa_key then
                aa_state, aa_draw, val_to_set = "RIGHT", (aa_bruteforce ~= nil and (aa_bruteforce == 90 and "RIGHT" or "LEFT")) or "RIGHT", (aa_bruteforce ~= nil and aa_bruteforce) or 90
                if aa_rotate and aa_rotate_key then
                    yaw_rotate = 90
                end
            else
                aa_state, aa_draw, val_to_set = "LEFT", (aa_bruteforce ~= nil and (aa_bruteforce == 90 and "RIGHT" or "LEFT")) or "LEFT", (aa_bruteforce ~= nil and aa_bruteforce) or -90
                if aa_rotate and aa_rotate_key then
                    yaw_rotate = -90
                end
            end
        elseif aa_mode == "Dynamic" then
            local closest_to_crosshair = ent.closest()
            local edge, freestand = data.freestand_local(closest_to_crosshair, 125)

            if edge ~= nil and edge ~= "UNK" then                  
                aa_state = edge
            else
                if freestand ~= nil and freestand ~= "UNK" then
                    aa_state = freestand
                end
            end

            if aa_rotate and aa_rotate_key then
                if (freestand ~= nil and freestand ~= "UNK") or (edge ~= nil and edge ~= "UNK") then
                    yaw_rotate = aa_state == "RIGHT" and 90 or -90
                end
            end
            
            if aa_invert and aa_invert_key then
                val_to_set = (aa_bruteforce ~= nil and aa_bruteforce) or ((aa_state == "RIGHT" and -90) or 90)
                aa_draw = (aa_bruteforce ~= nil and (aa_bruteforce == 90 and "LEFT" or "RIGHT")) or ((aa_state == "RIGHT" and "LEFT") or "RIGHT")
            else
                val_to_set = (aa_bruteforce ~= nil and aa_bruteforce) or ((aa_state == "RIGHT" and 90) or -90)
                aa_draw = (aa_bruteforce ~= nil and (aa_bruteforce == 90 and "RIGHT" or "LEFT")) or aa_state
            end
        end

        new_val = val_to_set
        if ui_get(menu.aa_legit_slowmo) and ui_get(menu.aa_legit_slowmo_key) then
            if ui_get(menu.aa_legit_slowmo_jitter) then
                disable_jitter = true
            end

            local max_speed = weapon_id ~= nil and data.get_weapon_info(weapon_id) or {max_player_speed = 250}
            misc.me = misc.me == nil and 1 or misc.me + 1
            if misc.me > ui_get(ui.other_fakelag_limit) + 1 then
                misc.me = 1
            end
            
            if ui_get(menu.aa_legit_slowmo_slider) == 0 then
                local favor_aa = 300 / (15 + 1 - (globals.tickcount() % 15))
                
                client.set_cvar("cl_sidespeed", favor_aa)
                client.set_cvar("cl_backspeed", favor_aa)
                client.set_cvar("cl_forwardspeed", favor_aa)
            else
                local favor_speed = 100 * ui_get(menu.aa_legit_slowmo_slider) / 100
                
                client.set_cvar("cl_sidespeed", favor_speed)
                client.set_cvar("cl_backspeed", favor_speed)
                client.set_cvar("cl_forwardspeed", favor_speed)
            end
        else
            client.set_cvar("cl_sidespeed", 450)
            client.set_cvar("cl_backspeed", 450)
            client.set_cvar("cl_forwardspeed", 450)
        end

        if (aa_jitter and aa_jitter_key) and not disable_jitter and aa_bruteforce == nil then 
            local cmd_to_proccess = ((aa_style == "Fake" and misc.choked_cmds) or (aa_style == "Real" and 4) or 2)
            new_val = (globals_tickcount() % cmd_to_proccess == 0) and val_to_set or -val_to_set
        end
        
        data.setup_aa(not aa_safe_allow, aa_safe_allow and "Off" or "180", yaw_rotate, (aa_targets and aa_targets_key) and "At targets" or "Local view")
        ui_set(ui.aa_bodyyaw_slider, new_val)
    else
        data.setup_aa(false, "Off", "180", "Local view", "60")
    end
end

client_set_event_callback("aim_fire", function(alp)
    if not ui_get(ui.ragebot_resolver) then return end
    if not ui_get(menu.resolver) then return end
    local target = alp.target

    if target ~= nil then
        local table_to_insert = entity_resolve.shot_data[target] ~= nil and entity_resolve.shot_data[target] or {vec = {x = {}, y = {}, z = {}}, vel = {}, angle = {init = {}, eye_yaw = {}, lby = {}}, hitgroup = {}, ts = {}, hit = {}, miss = {bool = {}, reason = {}}}

        local normal_angle = (entity_get_prop(target, "m_flPoseParameter", 11)) * 120 - 60
        local lby_angle = entity_get_prop(target, "m_flLowerBodyYawTarget")
        local _, eye_angle = entity_get_prop(target, "m_angEyeAngles")
        local velocity = data.velocity(target)
        local hg = alp.hitgroup
        local ts = client.timestamp()

        table_to_insert.vec.x[#table_to_insert.vec.x + 1] = alp.x
        table_to_insert.vec.y[#table_to_insert.vec.y + 1] = alp.y
        table_to_insert.vec.z[#table_to_insert.vec.z + 1] = alp.z
        table_to_insert.vel[#table_to_insert.vel + 1] = velocity
        table_to_insert.angle.init[#table_to_insert.angle.init + 1] = normal_angle
        table_to_insert.angle.lby[#table_to_insert.angle.lby + 1] = lby_angle
        table_to_insert.angle.eye_yaw[#table_to_insert.angle.eye_yaw + 1] = eye_angle
        table_to_insert.hitgroup[#table_to_insert.hitgroup + 1] = hg
        table_to_insert.ts[#table_to_insert.ts + 1] = ts
        table_to_insert.hit[#table_to_insert.hit + 1] = false
        table_to_insert.miss.bool[#table_to_insert.miss.bool + 1] = false
        table_to_insert.miss.reason[#table_to_insert.miss.reason + 1] = "unknown"

        entity_resolve.shot_data[target] = table_to_insert
    end
end)

client_set_event_callback("aim_hit", function(alp)
    if not ui_get(ui.ragebot_resolver) then return end
    if not ui_get(menu.resolver) then return end
    local target = alp.target

    if target ~= nil then
        if entity_resolve.shot_data[target] ~= nil then
            local table_update = entity_resolve.shot_data[target]

            table_update.hit[#table_update.hit] = true
        end
    end
end)

client_set_event_callback("aim_miss", function(alp)
    if not ui_get(ui.ragebot_resolver) then return end
    if not ui_get(menu.resolver) then return end
    local target = alp.target

    if target ~= nil then
        if entity_resolve.shot_data[target] ~= nil then
            local table_update = entity_resolve.shot_data[target]

            table_update.miss.bool[#table_update.miss.bool] = true

            if alp.reason == "?" then
                table_update.miss.reason[#table_update.miss.reason] = "resolver"
            else
                table_update.miss.reason[#table_update.miss.reason] = alp.reason
            end
        end
    end
end)

client_set_event_callback("aim_miss", function(alp)
    if not ui_get(ui.ragebot_resolver) then return end
    if not ui_get(menu.resolver) then return end

    local target = alp.target
    local reason = alp.reason

    if target ~= nil then
        if reason == "?" then
            allshots[target] = allshots[target] == nil and 1 or allshots[target] + 1
            mshots[target] = mshots[target] == nil and 1 or mshots[target] + 1

            if mshots[target] == 3 then
                mshots[target] = 0
            end

            if entity_resolve.is_resolved[target] == nil then
                entity_resolve.is_resolved[target] = true
            end

            if mshots[target] > 0 then
                entity_resolve.is_bruteforced[target] = true
            else
                entity_resolve.is_bruteforced[target] = false
            end
        end
    end
end)

local function playerlist_aa_type()
    if not ui_get(ui.ragebot_resolver) then return end
    if not ui_get(menu.resolver) then return end

    local players = entity_get_players(true)

    if players ~= 0 then
        for i = 1, #players do
            local target = players[i]

            if entity_resolve.is_resolved[target] ~= nil and not ui_get(menu.resolver_override) then
                if allshots[target] ~= nil then
                    if allshots[target] > 0 then
                        local shot_data = entity_resolve.shot_data[target]

                        local velocity, last_angle, eye_yaw, lby, desync = 0, 0, 0, 0, 0
                        local ts = 0

                        for j = 1, #shot_data.vel do
                            if shot_data.miss.bool[j] == true and shot_data.miss.reason[j] == "resolver" then
                                if shot_data.ts[j] > ts then
                                    velocity = shot_data.vel[j]
                                    last_angle = shot_data.angle.init[j]
                                    eye_yaw = clamp.ang(shot_data.angle.eye_yaw[j])
                                    lby = shot_data.angle.lby[j]
                                    desync = clamp.ang(eye_yaw - lby)

                                    ts = shot_data.ts[j]
                                end
                            end
                        end

                        if velocity < 1.125 then
                            if (desync > 50 and last_angle < 0) or (desync < 50 and last_angle > 0) then
                                entity_resolve.aa_type[target] = true -- inverse
                            elseif (desync > 50 and last_angle > 0) or (desync < 50 and last_angle < 0) then
                                entity_resolve.aa_type[target] = false -- normal
                            end
                        end
                    end
                end
            end
        end
    end
end

local function playerlist_deaths(alp)
    if not ui_get(ui.ragebot_resolver) and not ui_get(menu.resolver) then return end

    local dead, lp = alp.userid, alp.attacker
    local dead_id, lp_id = client_userid_to_entindex(dead), client_userid_to_entindex(lp)
    if (lp_id == entity_get_local_player() and entity_is_enemy(dead_id)) or dead_id == entity_get_local_player() then
        entity_resolve.is_bruteforced[dead_id] = false
        mshots[dead_id] = 0
    end
end

-- Anti-aim resolver
local function playerlist_resolver()
    local players = entity_get_players(true)
    if ui_get(menu.resolver) and ui_get(menu.resolver_pred) == "Smart" then
        if #players ~= 0 then
            for i = 1, #players do 
                local enemy_resolver = players[i]

                if enemy_resolver ~= nil then
                    if ui_is_menu_open() then
                        return
                    else
                        local player_flags = entity_get_prop(enemy_resolver, "m_fFlags")
                        if player_flags and bit.band(player_flags, 0x200) == 0x200 then
                            ui_set(ui.players_target, enemy_resolver)
                            ui_set(ui.players_corr, false)
                            ui_set(ui.players_body_yaw, true)
                            ui_set(ui.players_body_yaw_val, 0)

                            if entity_resolve.is_resolved[enemy_resolver] then
                                entity_resolve.is_resolved[enemy_resolver] = nil
                            end

                            if entity_resolve.is_bruteforced[enemy_resolver] then
                                entity_resolve.is_bruteforced[enemy_resolver] = nil
                            end
                        else
                            local edge_legit, freestand_legit = data.freestand_global(enemy_resolver, 125, 0)
                            local enemy_x, enemy_y, enemy_z = entity_hitbox_position(enemy_resolver, 0)
                            local weapon_id = entity_get_prop(entity_get_player_weapon(enemy_resolver), "m_iItemDefinitionIndex")

                            local desync = data.desync_lby(enemy_resolver)
                            local bodyyaw = (entity_get_prop(enemy_resolver, "m_flPoseParameter", 11)) * 120 - 60

                            local abs_vel = data.velocity(enemy_resolver)
                            local max_desync = math_abs(60 - 59 * abs_vel / 590) <= 60 and (60 - 59 * abs_vel / 590) or 60
                            local max_speed = weapon_id ~= nil and data.get_weapon_info(weapon_id) or {max_player_speed = 250}

                            local render_x, render_y = render.wts(enemy_x, enemy_y, enemy_z)
                            local xs, ys = client_screen_size()

                            if ui_get(menu.resolver_override) then
                                ui_set(ui.players_target, enemy_resolver)
                                ui_set(ui.players_corr, false)
                                ui_set(ui.players_body_yaw, true)

                                if render_x ~= nil then
                                    if render_x > 0 and render_x < xs then
                                        if render_x > (xs / 2) then
                                            ui_set(ui.players_body_yaw_val, -max_desync)
                                        elseif render_x < (xs / 2) then
                                            ui_set(ui.players_body_yaw_val, max_desync)
                                        elseif render_x == (xs / 2) then
                                            ui_set(ui.players_body_yaw_val, 0)
                                        end
                                    end
                                end
                            else
                                if entity_resolve.is_resolved[enemy_resolver] then
                                    ui_set(ui.players_target, enemy_resolver)
                                    ui_set(ui.players_corr, false)
                                    ui_set(ui.players_body_yaw, true)

                                    local shot_data = entity_resolve.shot_data[enemy_resolver]
                        
                                    local is_in_pos = false
                                    local angle_to_set = 0
                                    
                                    if shot_data ~= nil then
                                        for j = 1, #shot_data.vec.x do
                                            local x_hit = shot_data.vec.x[j]
                                            local y_hit = shot_data.vec.y[j]
                                            local z_hit = shot_data.vec.z[j]
                                            local angle = shot_data.angle.init[j]
                                            local ts = shot_data.ts[j]

                                            local eq1 = math_sqrt((x_hit - enemy_x)^2 + (y_hit - enemy_y)^2)
                                            local eq2 = math_abs(z_hit - enemy_z)

                                            if eq1 < 150 and eq2 < 10 then
                                                is_in_pos = true
                                                if shot_data.hit[j] == true then
                                                    angle_to_set = angle
                                                elseif shot_data.miss.bool[j] == true and shot_data.miss.reason[j] == "resolver" then
                                                    angle_to_set = -angle
                                                end
                                            end
                                        end
                                    end

                                    if entity_resolve.is_bruteforced[enemy_resolver] then
                                        local last_bodyyaw = shot_data.angle.init[#shot_data.angle.init]

                                        ui_set(ui.players_body_yaw, true)
                                        if abs_vel <= 1.125 then
                                            if mshots[enemy_resolver] < 2 then
                                                ui_set(ui.players_body_yaw_val, (last_bodyyaw >= 0 and -60) or (last_bodyyaw < 0 and 60) or 0)
                                            elseif mshots[enemy_resolver] == 2 then
                                                ui_set(ui.players_body_yaw_val, 0)
                                            end
                                        elseif abs_vel > 1.125 and abs_vel <= (max_speed.max_player_speed / (8 / 3)) then
                                            ui_set(ui.players_body_yaw_val, (math_abs(last_bodyyaw) >= 45 and (last_bodyyaw >= 0 and -23) or 23) or (last_bodyyaw < 0 and 60) or (last_bodyyaw > 0 and -60) or 0)
                                        elseif abs_vel > (max_speed.max_player_speed / (8 / 3)) then
                                            ui_set(ui.players_body_yaw_val, (last_bodyyaw >= 0 and -60) or (last_bodyyaw < 0 and 60) or 0)
                                        end
                                        
                                        if ui_get(menu.resolver_override) then
                                            entity_resolve.is_bruteforced[enemy_resolver] = false
                                        end
                                    else
                                        ui_set(ui.players_body_yaw, true)
                                
                                        if abs_vel <= 1.125 then
                                            if entity_resolve.aa_state[enemy_resolver] == nil or not entity_resolve.aa_state[enemy_resolver] then
                                                if desync > 20 then
                                                    if entity_resolve.aa_type[enemy_resolver] == nil or not entity_resolve.aa_type[enemy_resolver] then
                                                        ui_set(ui.players_body_yaw_val, -max_desync)
                                                    elseif entity_resolve.aa_type[enemy_resolver] then
                                                        ui_set(ui.players_body_yaw_val, max_desync)
                                                    end
                                                elseif desync < -20 then
                                                    if entity_resolve.aa_type[enemy_resolver] == nil or not entity_resolve.aa_type[enemy_resolver] then
                                                        ui_set(ui.players_body_yaw_val, max_desync)
                                                    elseif entity_resolve.aa_type[enemy_resolver] then
                                                        ui_set(ui.players_body_yaw_val, -max_desync)
                                                    end
                                                end
                                            elseif entity_resolve.aa_state[enemy_resolver] then
                                                if edge_legit == "UNK" and freestand_legit == "UNK" then
                                                    if is_in_pos then
                                                        ui_set(ui.players_body_yaw_val, (angle_to_set > 0 and 60) or (angle_to_set < 0 and -60) or 0)
                                                    end
                                                else
                                                    if edge_legit ~= "UNK" then
                                                        if edge_legit == "LEFT" then
                                                            ui_set(ui.players_body_yaw_val, -max_desync)
                                                        elseif edge_legit == "RIGHT" then
                                                            ui_set(ui.players_body_yaw_val, max_desync)
                                                        end
                                                    else
                                                        if freestand_legit ~= "UNK" then
                                                            if freestand_legit == "LEFT" then
                                                                ui_set(ui.players_body_yaw_val, -max_desync)
                                                            elseif freestand_legit == "RIGHT" then
                                                                ui_set(ui.players_body_yaw_val, max_desync)
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        elseif abs_vel > 1.125 then
                                            if edge_legit == "UNK" and freestand_legit == "UNK" then
                                                if is_in_pos then
                                                    ui_set(ui.players_body_yaw_val, (angle_to_set > 0 and 60) or (angle_to_set < 0 and -60) or 0)
                                                end
                                            else
                                                if edge_legit ~= "UNK" then
                                                    if edge_legit == "LEFT" then
                                                        ui_set(ui.players_body_yaw_val, -max_desync)
                                                    elseif edge_legit == "RIGHT" then
                                                        ui_set(ui.players_body_yaw_val, max_desync)
                                                    end
                                                else
                                                    if freestand_legit ~= "UNK" then
                                                        if freestand_legit == "LEFT" then
                                                            ui_set(ui.players_body_yaw_val, -max_desync)
                                                        elseif freestand_legit == "RIGHT" then
                                                            ui_set(ui.players_body_yaw_val, max_desync)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                else
                                    ui_set(ui.players_target, enemy_resolver)
                                    ui_set(ui.players_body_yaw, false)
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif ui_get(menu.resolver) and ui_get(menu.resolver_pred) == "Manual" then
        ui_set(menu.resolver_manual_switch_key, "On hotkey")
        if ui_get(menu.resolver_manual_switch_key) then 
            if not misc.was_switched then 
                misc.was_switched = true
                misc.manual_mode = (misc.manual_mode + 1) % 3
            end
        else
            misc.was_switched = false
        end

        if #players ~= 0 then
            for i = 1, #players do
                local enemy_resolver = players[i]
                ui_set(ui.players_target, enemy_resolver)
                ui_set(ui.players_corr, false)

                local player_flags = entity_get_prop(enemy_resolver, "m_fFlags")
                if player_flags and bit.band(player_flags, 0x200) == 0x200 then
                    ui_set(ui.players_body_yaw, true)
                    ui_set(ui.players_body_yaw_val, 0)
                else
                    if misc.manual_mode == 0 or misc.manual_mode == nil then
                        ui_set(ui.players_body_yaw, false)
                    elseif misc.manual_mode == 1 then
                        ui_set(ui.players_body_yaw, true)
                        ui_set(ui.players_body_yaw_val, -60)
                    elseif misc.manual_mode == 2 then
                        ui_set(ui.players_body_yaw, true)
                        ui_set(ui.players_body_yaw_val, 60)
                    end
                end
            end
        end
    end
end

--spaceholder #3

client.register_esp_flag("FAKE", 255, 255, 255, function(entindex)
    if ui_get(menu.flags) and array.contains(ui_get(menu.flags_multi), "Desync", false) then
        if entity_resolve.is_resolved[entindex] then
            return true
        end
    end
end)

client.register_esp_flag("SW", 255, 255, 255, function(entindex)    
    if not entity.is_dormant(entindex) then
        local weapon_id = entity_get_prop(entity_get_player_weapon(entindex), "m_iItemDefinitionIndex")
        local max_speed = weapon_id ~= nil and data.get_weapon_info(weapon_id) or {max_player_speed = 250}
        local velocity = data.velocity(entindex)

        if ui_get(menu.flags) and array.contains(ui_get(menu.flags_multi), "Slow walk", false) then
            if velocity >= 1.125 and velocity <= max_speed.max_player_speed / (8 / 3) then
                return true
            end
        end
    end
end)

client.register_esp_flag("OVR", 255, 255, 255, function(entindex)
    if ui_get(menu.flags) and array.contains(ui_get(menu.flags_multi), "Override", false) then
        if ui_get(ui.ragebot_resolver_override_key) or (ui_get(menu.resolver) and ui_get(menu.resolver_override)) then
            return true
        end
    end
end)

client.register_esp_flag("FB", 255, 255, 255, function(entindex)
    if ui_get(menu.flags) and array.contains(ui_get(menu.flags_multi), "Body aim", false) then
        if ui_get(ui.ragebot_baim_key) then
            return true
        else
            if not ui_is_menu_open() then
                ui_set(ui.players_target, entindex)
    
                if ui_get(ui.players_prefer) ~= "-" and ui_get(ui.players_prefer) ~= "Off" then
                    return true
                end
            end
        end
    end
end)

local function draw_manual_resolver()
    if not entity_is_alive(entity_get_local_player()) then return end
    if ui_get(menu.resolver) then
        if ui_get(menu.resolver_manual_draw) then
            local players = entity_get_players(true)

            for i = 1, #players do 
                local player = players[i]
                local x1, y1, x2, y2, amp = entity_get_bounding_box(player)
                local r, g, b, a = ui_get(menu.resolver_manual_draw_cp)

                if x1 ~= nil then
                    local xc = x1 + (x2 - x1) / 2

                    local player_flags = entity_get_prop(player, "m_fFlags")
                    if player_flags and bit.band(player_flags, 0x200) == 0x200 then
                        if xc ~= nil then
                            renderer_text(xc, ui_get(ui.other_esp_name) and (y1 - 17) or (y1 - 6), r, g, b, a * amp, "cd", 0, "BOT")
                        end
                    else
                        if ui_get(menu.resolver_pred) == "Manual" then
                            if xc ~= nil then
                                if ui_get(menu.resolver_manual_draw_mode) == "Default" then
                                    renderer_text(xc, ui_get(ui.other_esp_name) and (y1 - 17) or (y1 - 6), r, g, b, a * amp, "cd", 0, ((misc.manual_mode == nil or misc.manual_mode == 0) and "OFF") or (misc.manual_mode == 1 and "LEFT") or (misc.manual_mode == 2 and "RIGHT"))
                                elseif ui_get(menu.resolver_manual_draw_mode) == "Opposite" then
                                    renderer_text(xc, ui_get(ui.other_esp_name) and (y1 - 17) or (y1 - 6), r, g, b, a * amp, "cd", 0, ((misc.manual_mode == nil or misc.manual_mode == 0) and "OFF") or (misc.manual_mode == 1 and "RIGHT") or (misc.manual_mode == 2 and "LEFT"))
                                end
                            end
                        elseif ui_get(menu.resolver_pred) == "Smart" then
                            if xc ~= nil then
                                if ui_get(menu.resolver_override) then
                                    renderer_text(xc, ui_get(ui.other_esp_name) and (y1 - 17) or (y1 - 6), r, g, b, a * amp, "cd", 0, "OVERRIDE")
                                else
                                    if entity_resolve.is_resolved[player] == true then
                                        renderer_text(xc, ui_get(ui.other_esp_name) and (y1 - 17) or (y1 - 6), r, g, b, a * amp, "cd", 0, "AUTO")
                                    else
                                        renderer_text(xc, ui_get(ui.other_esp_name) and (y1 - 17) or (y1 - 6), r, g, b, a * amp, "cd", 0, "OFF")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function draw_fov_ind()
    if not ui_get(weapon_settings.aimbot_improvements) or not entity_is_alive(entity_get_local_player()) then return end

    local bFreezeTime = entity_get_prop(entity.get_game_rules(), "m_bFreezePeriod")
    if (bFreezeTime) == 1 then return end

    local fov = ui_get(menu.indicators_fov)
    local fov_ind_mode = ui_get(menu.indicators_fov_mode)
    local r, g, b, a = ui_get(menu.indicators_fov_color)

    if fov then
        local x, y = client_screen_size()
        local mid_x, mid_y = x / 2, y / 2
        local vm_fov = cvar.viewmodel_fov:get_int()
        local fov_radius = ui_get(ui.ragebot_maximum_fov) / vm_fov * x / 2

        if fov_ind_mode == "Normal" then
            renderer.circle_outline(mid_x, mid_y, r, g, b, a, fov_radius, 0, 1.0, 1)
        elseif fov_ind_mode == "Filled" then
            renderer.circle(mid_x, mid_y, r, g, b, a, fov_radius, 0, 1.0)            
        end
    end
end

local function draw_aa_dir()
    if not ui_get(menu.aa_legit) or not entity_is_alive(entity_get_local_player()) then return end

    local bFreezeTime = entity_get_prop(entity.get_game_rules(), "m_bFreezePeriod")
    if (bFreezeTime) == 1 then return end

    if not ui_get(ui.aa_enable) or ui_get(ui.aa_rageyaw) == "Off" then return end
    
    local screen_x, screen_y = client_screen_size()
    local desync_perc, r, g, b = local_player.aa_state()

    if ui_get(menu.aa_legit_indicator) then
        if ui_get(menu.aa_legit_indicator_mode) == "Small" then
            if aa_draw == "LEFT" then
                renderer.triangle((screen_x / 2) - 40 * dpi_scale, screen_y / 2 + 1 * dpi_scale, (screen_x / 2) - 32 * dpi_scale, screen_y / 2 - 3 * dpi_scale, (screen_x / 2) - 32 * dpi_scale, screen_y / 2 + 5 * dpi_scale, r, g, b, 255)
            elseif aa_draw == "RIGHT" then
                renderer.triangle((screen_x / 2) + 40 * dpi_scale, screen_y / 2 + 1 * dpi_scale, (screen_x / 2) + 32 * dpi_scale, screen_y / 2 - 3 * dpi_scale, (screen_x / 2) + 32 * dpi_scale, screen_y / 2 + 5 * dpi_scale, r, g, b, 255)
            end
        elseif ui_get(menu.aa_legit_indicator_mode) == "Normal" then
            if aa_draw == "LEFT" then
                renderer.triangle((screen_x / 2) - 50 * dpi_scale, screen_y / 2 + 1 * dpi_scale, (screen_x / 2) - 34 * dpi_scale, screen_y / 2 - 7 * dpi_scale, (screen_x / 2) - 34 * dpi_scale, screen_y / 2 + 9 * dpi_scale, r, g, b, 255)
            elseif aa_draw == "RIGHT" then
                renderer.triangle((screen_x / 2) + 50 * dpi_scale, screen_y / 2 + 1 * dpi_scale, (screen_x / 2) + 34 * dpi_scale, screen_y / 2 - 7 * dpi_scale, (screen_x / 2) + 34 * dpi_scale, screen_y / 2 + 9 * dpi_scale, r, g, b, 255)
            end
        end
    end
end

local function draw_awall_dmg()
    if not entity_is_alive(entity_get_local_player()) then return end

    local local_weapon = entity_get_player_weapon(entity_get_local_player())
    local weapon_name = entity_get_classname(local_weapon)
    if weapon_name == "CKnife" or weapon_name == "CSmokeGrenade" or weapon_name == "CFlashbang" or weapon_name == "CHEGrenade" or weapon_name == "CDecoyGrenade" or weapon_name == "CIncendiaryGrenade" or weapon_name == "CWeaponTaser" or weapon_name == "CC4" or weapon_name == "CMolotovGrenade" or weapon_name == "CSensorGrenade" then return end

    local screen_x, screen_y = client_screen_size()

    if ui_get(menu.indicators_pen_dmg) then
        local own_x, own_y, own_z = client_eye_position()
        local own_pitch, own_yaw = client_camera_angles()
        local enemy = false
        local r, g, b = ui_get(menu.watermark_color)

        local yaw_rad = math_rad(own_yaw)
        local pitch_rad = math_rad(own_pitch)

        local ext_x = own_x + 8192 * (math_cos(yaw_rad) * math_cos(pitch_rad))
        local ext_y = own_y + 8192 * (math_sin(yaw_rad) * math_cos(pitch_rad))
        local ext_z = own_z - 8192 * (math_sin(pitch_rad))

        local fraction, _ = client_trace_line(entity_get_local_player(), own_x, own_y, own_z, ext_x, ext_y, ext_z)

        if fraction < 1 then
            local end_x, end_y, end_z = own_x + (8192 * fraction + 128) * (math_cos(yaw_rad) * math_cos(pitch_rad)), own_y + (8192 * fraction + 128) * (math_sin(yaw_rad) * math_cos(pitch_rad)), own_z - (8192 * fraction + 128) * (math_sin(pitch_rad))
            local entindex, damage = client_trace_bullet(entity_get_local_player(), own_x, own_y, own_z, end_x, end_y, end_z)

            if entindex ~= nil then
                enemy = true
            end

            if damage > 0 then
                if enemy then 
                    renderer_text((screen_x / 2) + 1, (screen_y / 2) + 20 * dpi_scale, r, g, b, 255, "cbd", 0, damage)
                else
                    renderer_text((screen_x / 2) + 1, (screen_y / 2) + 20 * dpi_scale, r, g, b, 255, "cbd", 0, damage)
                end
            end
        end
    end
end

local function draw_data_mm()
    local valve = entity_get_prop(entity.get_all("CCSGameRulesProxy")[1], "m_bIsValveDS", entity_get_local_player())
    local allow_drawing = false
    local mm_mode = 0

    if valve ~= nil then
        local game_mode, game_type = cvar.game_mode:get_int(), cvar.game_type:get_int()
        local queued_mm = entity_get_prop(entity_get_game_rules(), "m_bIsQueuedMatchmaking") == 1
        
        if queued_mm then
            if game_type == 0 and game_mode == 2 then
                allow_drawing = true
                mm_mode = 1
            elseif game_type == 0 and game_mode == 1 then
                allow_drawing = true
                mm_mode = 1
            elseif game_type == 6 and game_mode == 0 then
                allow_drawing = true
                mm_mode = 2
            else
                allow_drawing = false -- false
            end
        end
    else
        allow_drawing = false -- false
    end

    if allow_drawing then
        if ui_get(menu.data_mm) then
            local players = entity_get_players(false)
            local names = {}
            local wins = {}
            local rank = {}

            local width = renderer_measure_text("d", "Matchmaking data") + 10 * dpi_scale
            local r, g, b, a
            local r_b, g_b, b_b, a_b = ui_get(menu.watermark_color_body)

            if ui_get(menu.rainbow) then
                r, g, b, a = rainbowize.rgb(0.5, 1)
            else
                r, g, b, a = ui_get(menu.watermark_color)
            end

            for i = 1, globals.maxplayers() do
                if entity_get_classname(i) == "CCSPlayer" then
                    local name = entity_get_player_name(i)
                    if name:len() >= 20 then
                        name = name:sub(1, 15)
                    end

                    local wins_amount = entity_get_prop(entity_get_player_resource(), "m_iCompetitiveWins", i)
                    local cur_rank = entity_get_prop(entity_get_player_resource(), "m_iCompetitiveRanking", i)

                    local text = (mm_mode == 1 and name .. " - " .. wins_amount .. " wins - " .. ranks_mmwing[cur_rank + 1]) or (mm_mode == 2 and name .. " - " .. wins_amount .. " wins - " .. ranks_danger[cur_rank + 1])
                    local text_width = renderer_measure_text("d", text)

                    if text_width > width then
                        width = text_width
                    end

                    if name ~= "GOTV" and not string.match(name, "BOT") then
                        names[#names + 1] = name
                        wins[#wins + 1] = wins_amount
                        rank[#rank + 1] = cur_rank
                    end
                end
            end
            
            local height_d = #names == 1 and 22 * dpi_scale or (22 * dpi_scale + (12 * dpi_scale * (#names - 1)))

            if #names > 0 and (client.key_state(0x09) or ui_is_menu_open()) then
                render.dragging("Matchmaking data", width, height_d + 20)
                render.container.body("Matchmaking data", width, 20, r_b, g_b, b_b, a_b, r, g, b, 255, false, height_d)
                for i = 1, #names do
                    local cur_name = names[i]
                    local wins = wins[i]
                    local rank = rank[i]
        
                    local text = (mm_mode == 1 and cur_name .. " - " .. wins .. " wins - " .. ranks_mmwing[rank + 1]) or (mm_mode == 2 and cur_name .. " - " .. wins .. " wins - " .. ranks_danger[rank + 1])
                    render.container.info("Matchmaking data", 5, 26, i, "d", text, false)
                end
            end
        end
    end
end

local function draw_data_sp()
    if ui_get(menu.spectators) then
        local r_bg, g_bg, b_bg, a_bg
        local r_b, g_b, b_b, a_b = ui_get(menu.watermark_color_body)

        local spectators = {}
        local width = renderer_measure_text("d", "Spectators") + 10 * dpi_scale

        if ui_get(menu.rainbow) then
            r_bg, g_bg, b_bg, a_bg = rainbowize.rgb(0.5, 1)
        else
            r_bg, g_bg, b_bg, a_bg = ui_get(menu.watermark_color)
        end
    
        local local_player_observing = entity_get_local_player()
        if not entity_is_alive(local_player_observing) then
            local_player_observing = entity_get_prop(entity_get_local_player(), "m_hObserverTarget")
        end
    
        for i = 1, globals.maxplayers() do
            if entity_get_classname(i) == "CCSPlayer" then
                local observer_target = entity_get_prop(i, "m_hObserverTarget")
                if observer_target ~= nil and not entity_is_alive(i) and entity_get_prop(observer_target, "m_lifeState") == 0 and observer_target == local_player_observing then
                    local name = entity_get_player_name(i)
    
                    if name:len() > 20 then 
                        name = name:sub(1, 15);
                    end
    
                    local text_width = renderer_measure_text("сd", name)
    
                    if text_width > width then
                        width = text_width
                    end
    
                    table_insert(spectators, name)
                end
            end
        end
    
        local height_d = #spectators == 1 and 20 * dpi_scale or (20 * dpi_scale + (12 * dpi_scale * (#spectators - 1)))

        if #spectators > 0 or ui_is_menu_open() then
            render.dragging("Spectators", width, height_d + 20)
            render.container.body("Spectators", width, 20, r_b, g_b, b_b, a_b, r_bg, g_bg, b_bg, 255, false, height_d)
            for i = 1, #spectators do
                local cur_name = spectators[i]
                render.container.info("Spectators", (width + 10 * dpi_scale) / 2, 32, i, "cd", cur_name, false)
            end
        end
    end
end

local function draw_ind()
    if not ui_get(menu.indicators) or not entity_is_alive(entity_get_local_player()) then return end

    local ind = ui_get(menu.indicators_multi)
    local type = ui_get(menu.indicators_combo)
    if #ind == 0 then return end

    local drawing = { }

    if array.contains(ind, "Automatic fire", false) then
        if aimbot_bool.autofire then
            if not array.contains(drawing, "Automatic fire", false) then
                table_insert(drawing, "Automatic fire")
            end
        else
            if array.contains(drawing, "Automatic fire", false) then
                drawing = array.remove(drawing, "Automatic fire")
            end
        end
    end

    if array.contains(ind, "Automatic penetration", false) then
        if ui_get(ui.ragebot_autowall) then
            if not array.contains(drawing, "Automatic penetration", false) then
                table_insert(drawing, "Automatic penetration")
            end
        else
            if array.contains(drawing, "Automatic penetration", false) then
                drawing = array.remove(drawing, "Automatic penetration")
            end
        end
    end

    if array.contains(ind, "Force body aim", false) then
        if ui_get(ui.ragebot_baim_key) then
            if not array.contains(drawing, "Force body aim", false) then
                table_insert(drawing, "Force body aim")
            end
        else
            if array.contains(drawing, "Force body aim", false) then
                drawing = array.remove(drawing, "Force body aim")
            end
        end
    end

    if array.contains(ind, "Override hitbox", false) then
        if aimbot_bool.override_hitbox then
            if not array.contains(drawing, "Override hitbox", false) then
                table_insert(drawing, "Override hitbox")
            end
        else
            if array.contains(drawing, "Override hitbox", false) then
                drawing = array.remove(drawing, "Override hitbox")
            end
        end
    end

    if array.contains(ind, "Override settings", false) then
        if aimbot_bool.override_settings then
            if not array.contains(drawing, "Override settings", false) then
                table_insert(drawing, "Override settings")
            end
        else 
            if array.contains(drawing, "Override settings", false) then
                drawing = array.remove(drawing, "Override settings")
            end
        end
    end

    if array.contains(ind, "Quick peek assist", false) then
        if ui_get(ui.ragebot_quick_peek) and ui_get(ui.ragebot_quick_peek_key) then
            if not array.contains(drawing, "Quick peek assist", false) then
                table_insert(drawing, "Quick peek assist")
            end
        else
            if array.contains(drawing, "Quick peek assist", false) then
                drawing = array.remove(drawing, "Quick peek assist")
            end
        end
    end

    if array.contains(ind, "Anti-aim resolver", false) then
        if not array.contains(drawing, "Anti-aim resolver", false) then
            table_insert(drawing, "Anti-aim resolver")
        end
    else
        if array.contains(drawing, "Anti-aim resolver", false) then
            drawing = array.remove(drawing, "Anti-aim resolver")
        end
    end

    if array.contains(ind, "Safe point", false) then
        if ui_get(ui.ragebot_force_sp) then
            if not array.contains(drawing, "Safe point", false) then
                table_insert(drawing, "Safe point")
            end
        else
            if array.contains(drawing, "Safe point", false) then
                drawing = array.remove(drawing, "Safe point")
            end
        end
    end

    if array.contains(ind, "Field of view", false) then
        if not array.contains(drawing, "Field of view", false) then
            table_insert(drawing, "Field of view")
        end
    else
        if array.contains(drawing, "Field of view", false) then
            drawing = array.remove(drawing, "Field of view")
        end
    end

    if array.contains(ind, "Latency", false) then
        if not array.contains(drawing, "Latency", false) then
            table_insert(drawing, "Latency")
        end
    else
        if array.contains(drawing, "Latency", false) then
            drawing = array.remove(drawing, "Latency")
        end
    end

    if array.contains(ind, "Fake duck", false) then
        if ui_get(ui.aa_fake_duck) then
            if not array.contains(drawing, "Fake duck", false) then
                table_insert(drawing, "Fake duck")
            end
        else
            if array.contains(drawing, "Fake duck", false) then
                table_insert(drawing, "Fake duck")
            end
        end
    end

    if array.contains(ind, "Minimum damage", false) then
        if not array.contains(drawing, "Minimum damage", false) then
            table_insert(drawing, "Minimum damage")
        end
    else
        if array.contains(drawing, "Minimum damage", false) then
            drawing = array.remove(drawing, "Minimum damage")
        end
    end

    if array.contains(ind, "Fake lag", false) then
        if not array.contains(drawing, "Fake lag", false) then
            table_insert(drawing, "Fake lag")
        end
    else
        if array.contains(drawing, "Fake lag", false) then
            drawing = array.remove(drawing, "Fake lag")
        end
    end

    if array.contains(ind, "Anti-aim state", false) then
        if not array.contains(drawing, "Anti-aim state", false) then
            table_insert(drawing, "Anti-aim state")
        end
    else
        if array.contains(drawing, "Anti-aim state", false) then
            drawing = array.remove(drawing, "Anti-aim state")
        end
    end
    
    local fov_text, mt_text, aw_text, fb_text, sp_text, os_text, ob_text, ar_text, dmg_text, qp_text = "FOV", "TM", "AW", "FB", "SP", "OVERRIDE", "OB", "R", "DMG", "PEEK"
    local fov_bool, fov_index = array.contains(drawing, "Field of view", true)
    local mt_bool, mt_index = array.contains(drawing, "Automatic fire", true)
    local aw_bool, aw_index = array.contains(drawing, "Automatic penetration", true)
    local fb_bool, fb_index = array.contains(drawing, "Force body aim", true) 
    local sp_bool, sp_index = array.contains(drawing, "Safe point", true) 
    local lc_bool, lc_index = array.contains(drawing, "Latency", true)
    local fd_bool, fd_index = array.contains(drawing, "Fake duck", true)
    local fl_bool, fl_index = array.contains(drawing, "Fake lag", true)
    local aa_bool, aa_index = array.contains(drawing, "Anti-aim state", true)
    local os_bool, os_index = array.contains(drawing, "Override settings", true)
    local qp_bool, qp_index = array.contains(drawing, "Quick peek assist", true)
    local ob_bool, ob_index = array.contains(drawing, "Override hitbox", true) 
    local ar_bool, ar_index = array.contains(drawing, "Anti-aim resolver", true)
    local dmg_bool, dmg_index = array.contains(drawing, "Minimum damage", true)
    
    local screen_x, screen_y = client_screen_size()
    local center_x, center_y = screen_x / 2, screen_y / 2
    local old_y = screen_y - 70 * dpi_scale
    local small_y = center_y + (center_y * 3 / 4) 
    local r_color, g_color, b_color, alpha
    local r_b, g_b, b_b, a_b = ui_get(menu.watermark_color_body)
    local text_fl, add_y = ui_get(menu.indicators_centered_mode) == "Default" and "cbd" or "cd-", ui_get(menu.indicators_centered_mode) == "Default" and 12 * dpi_scale or 9 * dpi_scale

    if ui_get(menu.rainbow) then
        rb, gb, bb = rainbowize.rgb(0.5, 1)
        a = 255
    else
        rb, gb, bb = ui_get(menu.watermark_color)
        a = 255
    end

    for i = ui_get(menu.indicators_repos_default), 2, -1 do
        renderer_indicator(0, 0, 0, 0, i)
    end

    for i = ui_get(menu.indicators_repos_old), 2, -1 do
        old_y = old_y - 30 * dpi_scale
    end

    for i = ui_get(menu.indicators_repos_small), 2, -1 do
        if ui_get(menu.indicators_centered_mode) == "Default" then
            small_y = small_y - 12
        elseif ui_get(menu.indicators_centered_mode) == "Small" then
            small_y = small_y - 9 
        end
    end

    local dmg_array = list.dmg()

    if type == "Default" then
        local outline = outline == nil and true or outline
        local radius = 9
        local start_degrees = 0
        local circle_delta = (dpi_scale == 1 and 20) or (dpi_scale == 1.25 and 24) or dpi_scale * 18
        local dpi_rend_delta = dpi_scale == 1 and 0 or (10 / (3 - dpi_scale))

        if fov_bool then
            renderer_indicator(124, 195, 13, 255, fov_text, ": ", ui_get(ui.ragebot_maximum_fov), "°")
        end

        if mt_bool then
            renderer_indicator(124, 195, 13, 255, mt_text)
        end

        if os_bool then
            renderer_indicator(124, 195, 13, 255, os_text)
        end

        if ob_bool then
            renderer_indicator(124, 195, 13, 255, ob_text)
        end
 
        if aw_bool then
            renderer_indicator(124, 195, 13, 255, aw_text)
        end

        if fb_bool then
            renderer_indicator(124, 195, 13, 255, fb_text)
        end

        if sp_bool then
            renderer_indicator(124, 195, 13, 255, sp_text)
        end

        if qp_bool then
            renderer_indicator(124, 195, 13, 255, qp_text)
        end

        if dmg_bool then
            renderer_indicator(124, 195, 13, 255, dmg_text, ": ", dmg_array[ui_get(ui.ragebot_mindmg)])
        end

        if lc_bool then
            local ping_limit = ui_get(ui.misc_pingspike_slider)
            local ping = entity_get_prop(entity.get_all("CCSPlayerResource")[1], "m_iPing", entity_get_local_player())
            local r, g, b = color.rgb_prediction((ui_get(ui.misc_pingspike) and ui_get(ui.misc_pingspike_key)) and ping / ping_limit or ping / 100, (ui_get(ui.misc_pingspike) and ui_get(ui.misc_pingspike_key)))
            local percent_ping = (ui_get(ui.misc_pingspike) and ui_get(ui.misc_pingspike_key)) and (ping / ping_limit) or (ping / 100)
            local x_set = (ping < 10 and 50) or ((ping >= 10 and ping < 100) and 60) or (ping >= 100 and 71)

            local lc = renderer_indicator(r, g, b, 255, ping)
            render.circle(x_set, lc, dpi_rend_delta, circle_delta, percent_ping, r, g, b)
        end

        if fl_bool then
            local cmd = (misc.choked_cmds == nil and 0) or misc.choked_cmds
            --local percent_fl = cmd / (ui_get(ui.sv_maxusrcmdprocessticks) - 1)
            local r, g, b = color.rgb_prediction(cmd / 14, true)
 
            local fl = renderer_indicator(r, g, b, 255, "FL")
            render.circle(63, fl, dpi_rend_delta, circle_delta, percent_fl, r, g, b)
        end

        if fd_bool then
            local duck_amount = entity_get_prop(entity_get_local_player(), "m_flDuckAmount")
            local r, g, b = color.rgb_prediction(duck_amount, 1, true)

            local fd = renderer_indicator(r, g, b, 255, "FD")
            render.circle(70, fd, dpi_rend_delta, circle_delta, duck_amount, r, g, b)
        end

        if aa_bool then
            local desync_perc, r, g, b = local_player.aa_state()
            local aa = renderer_indicator(r, g, b, 255, "AA")
            render.circle(73, aa, dpi_rend_delta, circle_delta, desync_perc, r, g, b)
        end

        if ar_bool then
            if ui_get(menu.resolver_pred) == "Smart" then
                if ui_get(menu.resolver_override) then
                    renderer_indicator(124, 195, 13, 255, ar_text, ": OVR")
                else
                    renderer_indicator(124, 195, 13, 255, ar_text, ": AUTO")
                end
            elseif ui_get(menu.resolver_pred) == "Manual" then
                if ui_get(menu.resolver_manual_draw_mode) == "Default" then
                    if misc.manual_mode == 0 then
                        renderer_indicator(124, 195, 13, 255, ar_text, ": OFF")
                    elseif misc.manual_mode == 1 then
                        renderer_indicator(124, 195, 13, 255, ar_text, ": LEFT")
                    elseif misc.manual_mode == 2 then
                        renderer_indicator(124, 195, 13, 255, ar_text, ": RIGHT")
                    end
                elseif ui_get(menu.resolver_manual_draw_mode) == "Opposite" then
                    if misc.manual_mode == 0 then
                        renderer_indicator(124, 195, 13, 255, ar_text, ": OFF")
                    elseif misc.manual_mode == 1 then
                        renderer_indicator(124, 195, 13, 255, ar_text, ": RIGHT")
                    elseif misc.manual_mode == 2 then
                        renderer_indicator(124, 195, 13, 255, ar_text, ": LEFT")
                    end
                end
            end
        end
    elseif type == "Old" then
        local outline = outline == nil and true or outline
        local radius = 9
        local start_degrees = 0
        local draw_x, delta_y = 10 * dpi_scale, 30 * dpi_scale

        if fov_bool and fov_index ~= nil then
            renderer_text(draw_x, old_y - delta_y * (fov_index - 1), 124, 195, 13, 255, "d+", 0, fov_text, ": ", ui_get(ui.ragebot_maximum_fov), "°")
        end

        if mt_bool and mt_index ~= nil then
            renderer_text(draw_x, old_y - delta_y * (mt_index - 1), 124, 195, 13, 255, "d+", 0, mt_text)
        end

        if aw_bool and aw_index ~= nil then
            renderer_text(draw_x, old_y - delta_y * (aw_index - 1), 124, 195, 13, 255, "d+", 0, aw_text)
        end

        if os_bool and os_index ~= nil then
            renderer_text(draw_x, old_y - delta_y * (os_index - 1), 124, 195, 13, 255, "d+", 0, os_text)
        end

        if ob_bool and ob_index ~= nil then
            renderer_text(draw_x, old_y - delta_y * (ob_index - 1), 124, 195, 13, 255, "d+", 0, ob_text)
        end

        if sp_bool and sp_index ~= nil then
            renderer_text(draw_x, old_y - delta_y * (sp_index - 1), 124, 195, 13, 255, "d+", 0, sp_text)
        end

        if fb_bool and fb_index ~= nil then
            renderer_text(draw_x, old_y - delta_y * (fb_index - 1), 124, 195, 13, 255, "d+", 0, fb_text)
        end

        if dmg_bool and dmg_index ~= nil then
            renderer_text(draw_x, old_y - delta_y * (dmg_index - 1), 124, 195, 13, 255, "d+", 0, dmg_text, ": ", dmg_array[ui_get(ui.ragebot_mindmg)])
        end

        if qp_bool and qp_index ~= nil then
            renderer_text(draw_x, old_y - delta_y * (qp_index - 1), 124, 195, 13, 255, "d+", 0, qp_text)
        end

        if lc_bool and lc_index ~= nil then
            local ping_limit = ui_get(ui.misc_pingspike_slider)
            local ping = entity_get_prop(entity.get_all("CCSPlayerResource")[1], "m_iPing", entity_get_local_player())
            local r, g, b = color.rgb_prediction((ui_get(ui.misc_pingspike) and ui_get(ui.misc_pingspike_key)) and ping / ping_limit or ping / 100, (ui_get(ui.misc_pingspike) and ui_get(ui.misc_pingspike_key)))
            local percent_ping = (ui_get(ui.misc_pingspike) and ui_get(ui.misc_pingspike_key)) and (ping / ping_limit) or (ping / 100)
            local x_set = (ping < 10 and 40) or ((ping >= 10 and ping < 100) and 50) or (ping >= 100 and 61)

            renderer_text(draw_x, old_y - delta_y * (lc_index - 1), r, g, b, 255, "d+", 0, ping)
            render.circle(x_set, old_y - delta_y * (lc_index - 1), 0, 16 * dpi_scale, percent_ping, r, g, b)
        end

        if fd_bool and fd_index ~= nil then
            local duck_amount = entity_get_prop(entity_get_local_player(), "m_flDuckAmount")
            local r, g, b = color.rgb_prediction(duck_amount, 1, true)

            renderer_text(draw_x, old_y - delta_y * (fd_index - 1), r, g, b, 255, "d+", 0, "FD")
            render.circle(52, old_y - delta_y * (fd_index - 1), 0, 16 * dpi_scale, duck_amount, r, g, b)
        end

        if fl_bool and fl_index ~= nil then
            local cmd = (misc.choked_cmds == nil and 0) or misc.choked_cmds
            --local percent_fl = cmd / (ui_get(ui.sv_maxusrcmdprocessticks) - 1)
            local r, g, b = color.rgb_prediction(cmd / 14, true)
        
            renderer_text(draw_x, old_y - delta_y * (fl_index - 1), r, g, b, 255, "d+", 0, "FL")
            render.circle(48, old_y - delta_y * (fl_index - 1), 0, 16 * dpi_scale, percent_fl, r, g, b)
        end

        if aa_bool and aa_index ~= nil then
            local desync_perc, r, g, b = local_player.aa_state()
            renderer_text(draw_x, old_y - delta_y * (aa_index - 1), r, g, b, 255, "d+", 0, "AA")
            render.circle(55, old_y - delta_y * (aa_index - 1), 0, 16 * dpi_scale, desync_perc, r, g, b)
        end

        if ar_bool and ar_index ~= nil then
            if ui_get(menu.resolver_pred) == "Smart" then
                if ui_get(menu.resolver_override) then
                    renderer_text(draw_x, old_y - delta_y * (ar_index - 1), 124, 195, 13, 255, "d+", 0, ar_text, ": OVR")
                else
                    renderer_text(draw_x, old_y - delta_y * (ar_index - 1), 124, 195, 13, 255, "d+", 0, ar_text, ": AUTO")
                end
            elseif ui_get(menu.resolver_pred) == "Manual" then
                if ui_get(menu.resolver_manual_draw_mode) == "Default" then
                    if misc.manual_mode == 0 then
                        renderer_text(draw_x, old_y - delta_y * (ar_index - 1), 124, 195, 13, 255, "d+", 0, ar_text, ": OFF")
                    elseif misc.manual_mode == 1 then
                        renderer_text(draw_x, old_y - delta_y * (ar_index - 1), 124, 195, 13, 255, "d+", 0, ar_text, ": LEFT")
                    elseif misc.manual_mode == 2 then
                        renderer_text(draw_x, old_y - delta_y * (ar_index - 1), 124, 195, 13, 255, "d+", 0, ar_text, ": RIGHT")
                    end
                elseif ui_get(menu.resolver_manual_draw_mode) == "Opposite" then
                    if misc.manual_mode == 0 then
                        renderer_text(draw_x, old_y - delta_y * (ar_index - 1), 124, 195, 13, 255, "d+", 0, ar_text, ": OFF")
                    elseif misc.manual_mode == 1 then
                        renderer_text(draw_x, old_y - delta_y * (ar_index - 1), 124, 195, 13, 255, "d+", 0, ar_text, ": RIGHT")
                    elseif misc.manual_mode == 2 then
                        renderer_text(draw_x, old_y - delta_y * (ar_index - 1), 124, 195, 13, 255, "d+", 0, ar_text, ": LEFT")
                    end
                end
            end
        end
    elseif type == "Centered" then
        if fov_bool and fov_index ~= nil then
            renderer_text((screen_x / 2), small_y + add_y * (fov_index - 1), 124, 195, 13, 255, text_fl, 0, fov_text, ": ", ui_get(ui.ragebot_maximum_fov), "°")
        end

        if mt_bool and mt_index ~= nil then
            renderer_text((screen_x / 2), small_y + add_y * (mt_index - 1), 124, 195, 13, 255, text_fl, 0, mt_text)
        end

        if aw_bool and aw_index ~= nil then
            renderer_text((screen_x / 2), small_y + add_y * (aw_index - 1), 124, 195, 13, 255, text_fl, 0, aw_text)
        end

        if os_bool and os_index ~= nil then
            renderer_text((screen_x / 2), small_y + add_y * (os_index - 1), 124, 195, 13, 255, text_fl, 0, os_text)
        end

        if ob_bool and ob_index ~= nil then
            renderer_text((screen_x / 2), small_y + add_y * (ob_index - 1), 124, 195, 13, 255, text_fl, 0, ob_text)
        end

        if sp_bool and sp_index ~= nil then
            renderer_text((screen_x / 2), small_y + add_y * (sp_index - 1), 124, 195, 13, 255, text_fl, 0, sp_text)
        end

        if fb_bool and fb_index ~= nil then
            renderer_text((screen_x / 2), small_y + add_y * (fb_index - 1), 124, 195, 13, 255, text_fl, 0, fb_text)
        end

        if qp_bool and qp_index ~= nil then
            renderer_text((screen_x / 2), small_y + add_y * (qp_index - 1), 124, 195, 13, 255, text_fl, 0, qp_text)
        end

        if dmg_bool and dmg_index ~= nil then
            renderer_text((screen_x / 2), small_y + add_y * (dmg_index - 1), 124, 195, 13, 255, text_fl, 0, dmg_text, ": ", dmg_array[ui_get(ui.ragebot_mindmg)])
        end

        if lc_bool and lc_index ~= nil then
            local ping_limit = ui_get(ui.misc_pingspike_slider)
            local ping = entity_get_prop(entity.get_all("CCSPlayerResource")[1], "m_iPing", entity_get_local_player())
            local r, g, b = color.rgb_prediction((ui_get(ui.misc_pingspike) and ui_get(ui.misc_pingspike_key)) and ping / ping_limit or ping / 100, (ui_get(ui.misc_pingspike) and ui_get(ui.misc_pingspike_key)))
            local percent_ping = (ui_get(ui.misc_pingspike) and ui_get(ui.misc_pingspike_key)) and ping / ping_limit or ping / 100

            renderer_text(screen_x / 2, small_y + add_y * (lc_index - 1), r, g, b, 255, text_fl, 0, "RT")
        end

        if fl_bool and fl_index ~= nil then
            local cmd = (misc.choked_cmds == nil and 0) or misc.choked_cmds
            --local percent_fl = cmd / (ui_get(ui.sv_maxusrcmdprocessticks) - 1)
            local r, g, b = color.rgb_prediction(cmd / 14, true)
        
            renderer_text((screen_x / 2), small_y + add_y * (fl_index - 1), r, g, b, 255, text_fl, 0, "FL")
        end

        if fd_bool and fd_index ~= nil then
            local duck_amount = entity_get_prop(entity_get_local_player(), "m_flDuckAmount")
            local r, g, b = color.rgb_prediction(duck_amount, 1, true)

            renderer_text((screen_x / 2), small_y + add_y * (fd_index - 1), r, g, b, 255, text_fl, 0, "FD")
        end

        if aa_bool and aa_index ~= nil then
            local desync_perc, r, g, b = local_player.aa_state()
            renderer_text((screen_x / 2), small_y + add_y * (aa_index - 1), r, g, b, 255, text_fl, 0, "AA")
        end

        if ar_bool and ar_index ~= nil then
            if ui_get(menu.resolver_pred) == "Smart" then
                if ui_get(menu.resolver_override) then
                    renderer_text((screen_x / 2), small_y + add_y * (ar_index - 1), 124, 195, 13, 255, text_fl, 0, ar_text, ": OVR")                
                else
                    renderer_text((screen_x / 2), small_y + add_y * (ar_index - 1), 124, 195, 13, 255, text_fl, 0, ar_text, ": AUTO")
                end
            elseif ui_get(menu.resolver_pred) == "Manual" then
                if ui_get(menu.resolver_manual_draw_mode) == "Default" then
                    if misc.manual_mode == 0 then
                        renderer_text((screen_x / 2), small_y + add_y * (ar_index - 1), 124, 195, 13, 255, text_fl, 0, ar_text, ": OFF")
                    elseif misc.manual_mode == 1 then
                        renderer_text((screen_x / 2), small_y + add_y * (ar_index - 1), 124, 195, 13, 255, text_fl, 0, ar_text, ": LEFT")
                    elseif misc.manual_mode == 2 then
                        renderer_text((screen_x / 2), small_y + add_y * (ar_index - 1), 124, 195, 13, 255, text_fl, 0, ar_text, ": RIGHT")
                    end
                elseif ui_get(menu.resolver_manual_draw_mode) == "Opposite" then
                    if misc.manual_mode == 0 then
                        renderer_text((screen_x / 2), small_y + add_y * (ar_index - 1), 124, 195, 13, 255, text_fl, 0, ar_text, ": OFF")
                    elseif misc.manual_mode == 1 then
                        renderer_text((screen_x / 2), small_y + add_y * (ar_index - 1), 124, 195, 13, 255, text_fl, 0, ar_text, ": RIGHT")
                    elseif misc.manual_mode == 2 then
                        renderer_text((screen_x / 2), small_y + add_y * (ar_index - 1), 124, 195, 13, 255, text_fl, 0, ar_text, ": LEFT")
                    end
                end
            end
        end
    elseif type == "Container" then
        local function rectangle_outline(x, y, w, h, r, g, b, a, s)
            s = 1 * dpi_scale
            renderer_rectangle(x, y, w, s, r, g, b, a)
            renderer_rectangle(x, y+h-s, w, s, r, g, b, a)
            renderer_rectangle(x, y+s, s, h-s*2, r, g, b, a)
            renderer_rectangle(x+w-s, y+s, s, h-s*2, r, g, b, a)
        end

        local height_d = #drawing == 1 and 22 * dpi_scale or (22 * dpi_scale + (14 * dpi_scale * (#drawing - 1))) + 1

        local x, y = ui_get(pos["Indicators"].x_pos), ui_get(pos["Indicators"].y_pos)

        render.dragging("Indicators", 200 * dpi_scale, height_d + 20)
        render.container.body("Indicators", 200 * dpi_scale, 20, r_b, g_b, b_b, a_b, rb, gb, bb, 255, false, height_d)

        if fov_bool and fov_index ~= nil then
            local rectangle_width = 108 * dpi_scale
            local rectangle_real = (rectangle_width * (ui_get(ui.ragebot_maximum_fov) / 20) > 108 * dpi_scale and 108 * dpi_scale) or ((rectangle_width * (ui_get(ui.ragebot_maximum_fov) / 20) <= 2 * dpi_scale and 2 * dpi_scale) or rectangle_width * (ui_get(ui.ragebot_maximum_fov) / 20))

            renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (fov_index - 1), 255, 255, 255, 255, "d", 0, "Field of view")
            rectangle_outline(x + 94 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (fov_index - 1), rectangle_width, 8 * dpi_scale, 0, 0, 0, 160)
            renderer_rectangle(x + 95 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (fov_index - 1), rectangle_width - 2 * dpi_scale, 8 * dpi_scale - 2 * dpi_scale, r_b, g_b, b_b, a_b)
            renderer_rectangle(x + 95 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (fov_index - 1), rectangle_real - 2 * dpi_scale, 8 * dpi_scale - 2 * dpi_scale, rb, gb, bb, a)
        end

        if mt_bool and mt_index ~= nil then
            renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (mt_index - 1), 255, 255, 255, 255, "d", 0, "Automatic fire")
            rectangle_outline(x + 162 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (mt_index - 1), 40 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
            renderer_rectangle(x + 163 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (mt_index - 1), 38 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
            renderer_rectangle(x + 183 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (mt_index - 1), 18 * dpi_scale, 7 * dpi_scale, 124, 195, 13, 255)
            renderer_text(x + 171 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (mt_index - 1), 124, 195, 13, 255, "cd-", 0, "ON")
        end

        if aw_bool and aw_index ~= nil then
            renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (aw_index - 1), 255, 255, 255, 255, "d", 0, "Penetration")
            rectangle_outline(x + 162 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (aw_index - 1), 40 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
            renderer_rectangle(x + 163 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (aw_index - 1), 38 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
            renderer_rectangle(x + 183 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (aw_index - 1), 18 * dpi_scale, 7 * dpi_scale, 124, 195, 13, 255)
            renderer_text(x + 171 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (aw_index - 1), 124, 195, 13, 255, "cd-", 0, "ON")
        end

        if os_index and os_index ~= nil then
            renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (os_index - 1), 255, 255, 255, 255, "d", 0, "Override settings")
            rectangle_outline(x + 162 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (os_index - 1), 40 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
            renderer_rectangle(x + 163 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (os_index - 1), 38 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
            renderer_rectangle(x + 183 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (os_index - 1), 18 * dpi_scale, 7 * dpi_scale, 124, 195, 13, 255)
            renderer_text(x + 171 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (os_index - 1), 124, 195, 13, 255, "cd-", 0, "ON")
        end

        if ob_index and ob_index ~= nil then
            renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (ob_index - 1), 255, 255, 255, 255, "d", 0, "Override hitbox")
            rectangle_outline(x + 162 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (ob_index - 1), 40 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
            renderer_rectangle(x + 163 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (ob_index - 1), 38 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
            renderer_rectangle(x + 183 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (ob_index - 1), 18 * dpi_scale, 7 * dpi_scale, 124, 195, 13, 255)
            renderer_text(x + 171 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (ob_index - 1), 124, 195, 13, 255, "cd-", 0, "ON")
        end

        if sp_bool and sp_index ~= nil then
            renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (sp_index - 1), 255, 255, 255, 255, "d", 0, "Safe point")
            rectangle_outline(x + 162 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (sp_index - 1), 40 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
            renderer_rectangle(x + 163 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (sp_index - 1), 38 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
            renderer_rectangle(x + 183 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (sp_index - 1), 18 * dpi_scale, 7 * dpi_scale, 124, 195, 13, 255)
            renderer_text(x + 171 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (sp_index - 1), 124, 195, 13, 255, "cd-", 0, "ON")
        end

        if fd_bool and fd_index ~= nil then
            renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (fd_index - 1), 255, 255, 255, 255, "d", 0, "Fake duck")
            rectangle_outline(x + 162 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (fd_index - 1), 40 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
            renderer_rectangle(x + 163 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (fd_index - 1), 38 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
            renderer_rectangle(x + 183 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (fd_index - 1), 18 * dpi_scale, 7 * dpi_scale, 124, 195, 13, 255)
            renderer_text(x + 171 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (fd_index - 1), 124, 195, 13, 255, "cd-", 0, "ON")
        end

        if fb_bool and fb_index ~= nil then
            renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (fb_index - 1), 255, 255, 255, 255, "d", 0, "Force body aim")
            rectangle_outline(x + 162 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (fb_index - 1), 40 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
            renderer_rectangle(x + 163 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (fb_index - 1), 38 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
            renderer_rectangle(x + 183 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (fb_index - 1), 18 * dpi_scale, 7 * dpi_scale, 124, 195, 13, 255)
            renderer_text(x + 171 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (fb_index - 1), 124, 195, 13, 255, "cd-", 0, "ON")
        end

        if qp_bool and qp_index ~= nil then
            renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (qp_index - 1), 255, 255, 255, 255, "d", 0, "Quick peek assist")
            rectangle_outline(x + 162 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (qp_index - 1), 40 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
            renderer_rectangle(x + 163 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (qp_index - 1), 38 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
            renderer_rectangle(x + 183 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (qp_index - 1), 18 * dpi_scale, 7 * dpi_scale, 124, 195, 13, 255)
            renderer_text(x + 171 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (qp_index - 1), 124, 195, 13, 255, "cd-", 0, "ON")
        end

        if dmg_bool and dmg_index ~= nil then
            renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (dmg_index - 1), 255, 255, 255, 255, "d", 0, "Minimum damage")
            rectangle_outline(x + 182 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale* (dmg_index - 1), 20 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
            renderer_rectangle(x + 183 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (dmg_index - 1), 18 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
            renderer_text(x + 191 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (dmg_index - 1), 124, 195, 13, 255, "cd-", 0, dmg_array[ui_get(ui.ragebot_mindmg)])
        end

        if lc_bool and lc_index ~= nil then
            local ping_limit = ui_get(ui.misc_pingspike_slider)
            local ping = entity_get_prop(entity.get_all("CCSPlayerResource")[1], "m_iPing", entity_get_local_player())
            local r, g, b = color.rgb_prediction((ui_get(ui.misc_pingspike) and ui_get(ui.misc_pingspike_key)) and ping / ping_limit or ping / 100, (ui_get(ui.misc_pingspike) and ui_get(ui.misc_pingspike_key)))
            local percent_ping = (ui_get(ui.misc_pingspike) and ui_get(ui.misc_pingspike_key)) and ping / ping_limit or ping / 100

            local rectangle_width = 108 * dpi_scale
            local rectangle_real = ((percent_ping * rectangle_width) > 108 * dpi_scale and 108 * dpi_scale) or ((percent_ping * rectangle_width) <= 2 * dpi_scale and 2 * dpi_scale) or percent_ping * rectangle_width

            renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (lc_index - 1), 255, 255, 255, 255, "d", 0, "Latency")
            rectangle_outline(x + 94 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (lc_index - 1), rectangle_width, 8 * dpi_scale, 0, 0, 0, 160)
            renderer_rectangle(x + 95 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (lc_index - 1), rectangle_width - 2 * dpi_scale, 8 * dpi_scale - 2 * dpi_scale, r_b, g_b, b_b, a_b)
            renderer_rectangle(x + 95 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (lc_index - 1), rectangle_real - 2 * dpi_scale, 8 * dpi_scale - 2 * dpi_scale, rb, gb, bb, a)
        end

        if fl_bool and fl_index ~= nil then
            local cmd = (misc.choked_cmds == nil and 0) or misc.choked_cmds
            --local percent_fl = cmd / (ui_get(ui.sv_maxusrcmdprocessticks) - 1)
            local r, g, b = color.rgb_prediction(cmd / 14, true)

            local rectangle_width = 108 * dpi_scale
            local rectangle_real = ((percent_fl * rectangle_width) > 108 * dpi_scale and 108 * dpi_scale) or ((percent_fl * rectangle_width) <= 2 * dpi_scale and 2 * dpi_scale) or (percent_fl * rectangle_width)

            renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (fl_index - 1), 255, 255, 255, 255, "d", 0, "Fake lag")
            rectangle_outline(x + 94 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (fl_index - 1), rectangle_width, 8 * dpi_scale, 0, 0, 0, 160)
            renderer_rectangle(x + 95 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (fl_index - 1), rectangle_width - 2 * dpi_scale, 8 * dpi_scale - 2 * dpi_scale, r_b, g_b, b_b, a_b)
            renderer_rectangle(x + 95 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (fl_index - 1), rectangle_real - 2 * dpi_scale, 8 * dpi_scale - 2 * dpi_scale, rb, gb, bb, a)
        end

        if aa_bool and aa_index ~= nil then
            local desync_perc, r, g, b = local_player.aa_state()
            local rectangle_width = 108 * dpi_scale
            local rectangle_real = ((desync_perc * rectangle_width) > 108 * dpi_scale and 108 * dpi_scale) or ((desync_perc * rectangle_width) <= 2 * dpi_scale and 2 * dpi_scale) or (desync_perc * rectangle_width)

            renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (aa_index - 1), 255, 255, 255, 255, "d", 0, "Body yaw")
            rectangle_outline(x + 94 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (aa_index - 1), rectangle_width, 8 * dpi_scale, 0, 0, 0, 160)
            renderer_rectangle(x + 95 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (aa_index - 1), rectangle_width - 2 * dpi_scale, 8 * dpi_scale - 2 * dpi_scale, r_b, g_b, b_b, a_b)
            renderer_rectangle(x + 95 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (aa_index - 1), ui_get(ui.aa_rageyaw) ~= "Off" and rectangle_real - 2 * dpi_scale or 0, 8 * dpi_scale - 2 * dpi_scale, rb, gb, bb, a)
        end

        if ar_bool and ar_index ~= nil then
            if ui_get(menu.resolver_pred) == "Smart" then
                if ui_get(menu.resolver_override) then
                    renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 255, 255, 255, 255, "d", 0, "Anti-aim resolver")
                    rectangle_outline(x + 179 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 23 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
                    renderer_rectangle(x + 180 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 21 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
                    renderer_text(x + 189 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 124, 195, 13, 255, "cd-", 0, "OVR")                
                else
                    renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 255, 255, 255, 255, "d", 0, "Anti-aim resolver")
                    rectangle_outline(x + 177 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 25 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
                    renderer_rectangle(x + 178 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 23 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
                    renderer_text(x + 187 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 124, 195, 13, 255, "cd-", 0, "AUTO")
                end
            elseif ui_get(menu.resolver_pred) == "Manual" then
                if ui_get(menu.resolver_manual_draw_mode) == "Default" then
                    if misc.manual_mode == 0 then
                        renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 255, 255, 255, 255, "d", 0, "Anti-aim resolver")
                        rectangle_outline(x + 179 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 23 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
                        renderer_rectangle(x + 180 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 21 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
                        renderer_text(x + 188 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 124, 195, 13, 255, "cd-", 0, "OFF")                
                    elseif misc.manual_mode == 1 then
                        renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 255, 255, 255, 255, "d", 0, "Anti-aim resolver")
                        rectangle_outline(x + 179 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 23 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
                        renderer_rectangle(x + 180 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 21 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
                        renderer_text(x + 189 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 124, 195, 13, 255, "cd-", 0, "LEFT")
                    elseif misc.manual_mode == 2 then
                        renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 255, 255, 255, 255, "d", 0, "Anti-aim resolver")
                        rectangle_outline(x + 175 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 26 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
                        renderer_rectangle(x + 177 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 23 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
                        renderer_text(x + 186 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 124, 195, 13, 255, "cd-", 0, "RIGHT")
                    end
                elseif ui_get(menu.resolver_manual_draw_mode) == "Opposite" then
                    if misc.manual_mode == 0 then
                        renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 255, 255, 255, 255, "d", 0, "Anti-aim resolver")
                        rectangle_outline(x + 179 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 23 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
                        renderer_rectangle(x + 180 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 21 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
                        renderer_text(x + 188 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 124, 195, 13, 255, "cd-", 0, "OFF")                
                    elseif misc.manual_mode == 1 then
                        renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 255, 255, 255, 255, "d", 0, "Anti-aim resolver")
                        rectangle_outline(x + 175 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 26 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
                        renderer_rectangle(x + 177 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 23 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
                        renderer_text(x + 186 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 124, 195, 13, 255, "cd-", 0, "RIGHT")
                    elseif misc.manual_mode == 2 then
                        renderer_text(x + 6 * dpi_scale, y + 26 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 255, 255, 255, 255, "d", 0, "Anti-aim resolver")
                        rectangle_outline(x + 179 * dpi_scale, y + 29 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 23 * dpi_scale, 9 * dpi_scale, 0, 0, 0, 160)
                        renderer_rectangle(x + 180 * dpi_scale, y + 30 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 21 * dpi_scale, 7 * dpi_scale, r_b, g_b, b_b, a_b)
                        renderer_text(x + 189 * dpi_scale, y + 33 * dpi_scale + 14 * dpi_scale * (ar_index - 1), 124, 195, 13, 255, "cd-", 0, "LEFT")
                    end
                end
            end
        end
    end
end


local function on_run_command()
    aimbot_improvements()
    aa_optim()
    aa_breaker()
    playerlist_resolver()
end

local function on_paint()
    playerlist_aa_type()
    draw_aa_dir()
    draw_manual_resolver()
    draw_data_mm()
    draw_data_sp()
    draw_awall_dmg()
    draw_fov_ind()
    draw_ind()
    --misc_tag_run()
end

local function on_paint_ui()
    local function handleAA_F()
        local aa = ui_get(menu.aa_legit)
        ui_set_visible(ui.aa_enable, not aa)
        ui_set_visible(ui.aa_pitch, not aa)
        ui_set_visible(ui.aa_base, not aa)
        ui_set_visible(ui.aa_rageyaw, not aa)
        ui_set_visible(ui.aa_rageyaw_slider, not aa)
        ui_set_visible(ui.aa_yawjitter, not aa)
        ui_set_visible(ui.aa_yawjitter_slider, not aa)
        ui_set_visible(ui.aa_bodyyaw, not aa)
        ui_set_visible(ui.aa_bodyyaw_slider, not aa)
        ui_set_visible(ui.aa_bodyyaw_freestand, not aa)
        --ui_set_visible(ui.aa_limit, not aa)
        ui_set_visible(ui.aa_edgeyaw, not aa)
        ui_set_visible(ui.aa_autodirection, not aa)
        ui_set_visible(ui.aa_autodirection_key, not aa)
    end

    handleAA_F()
end

local function on_shutdown()
    client.set_clan_tag("\n")
    ui_set_visible(ui.aa_enable, true)
    ui_set_visible(ui.aa_pitch, true)
    ui_set_visible(ui.aa_base, true)
    ui_set_visible(ui.aa_rageyaw, true)
    ui_set_visible(ui.aa_rageyaw_slider, true)
    ui_set_visible(ui.aa_yawjitter, true)
    ui_set_visible(ui.aa_yawjitter_slider, true)
    ui_set_visible(ui.aa_bodyyaw, true)
    ui_set_visible(ui.aa_bodyyaw_slider, true)
    ui_set_visible(ui.aa_bodyyaw_freestand, true)
    --ui_set_visible(ui.aa_limit, true)
    ui_set_visible(ui.aa_edgeyaw, true)
    ui_set_visible(ui.aa_autodirection, true)
    ui_set_visible(ui.aa_autodirection_key, true)
    --ui_set(ui.sv_maxusrcmdprocessticks, 15)
end

local function reset_ids()
    ui_set(ui.players_reset, true)
end

local function reset_data()
    entity_resolve.is_bruteforced = { }
    mshots = { }
    misc.weapon_switch = nil
    misc.weapon_was_switched = false
    misc.weapon_current = ""
end

local function reset_angles()
    allshots = { }
    entity_resolve = {
        anti_brute = { },
        is_resolved = { },
        is_bruteforced = { },
        shot_data = { },
        time_stamps = { },
        timings = {t = { }, dsc = { }, updated = { }, bchanged = { }, btotal = { }},
        aa_type = { },
        aa_state = { },
    }
end

local function full_reset()
    reset_ids()
    reset_data()
    reset_angles()
end
ui_new_button("Players", "Players", "Reset resolver data", full_reset)

client_set_event_callback("player_death", playerlist_deaths)
client_set_event_callback("run_command", on_run_command)
client_set_event_callback("paint", on_paint)
client_set_event_callback("paint_ui", on_paint_ui)
client_set_event_callback("shutdown", on_shutdown)
client_set_event_callback("player_death", misc_chat_spam)

client_set_event_callback("game_newmap", full_reset)
client_set_event_callback("round_start", reset_data)

namecombo = ui_new_combobox("MISC", "Miscellaneous", "Eternity Name Spammer", "All", "Get Good")
function spammer(name)
client.set_cvar("name", name)
end
namesteal = ui_reference("misc", "miscellaneous", "Steal player name")
ui_new_button("MISC", "Miscellaneous", "spam", function()
oldName = client.get_cvar("name")
if ui_get(namecombo) == "All" then
    ui_set(namesteal, true)
    spammer( "Eternity > All ")
    client.delay_call(0.2, spammer, "Eternity > All  ")
    client.delay_call(0.4, spammer, "Eternity > All   ")
    client.delay_call(0.6, spammer, "Eternity > All    ")
    client.delay_call(0.8, spammer, oldName)
    
elseif ui_get(namecombo) == "Get Good" then
    ui_set(namesteal, true)
    spammer( "Get. ")
    client.delay_call(0.2, spammer, "Get Good.  ")
    client.delay_call(0.4, spammer, "Get Good Get.   ")
    client.delay_call(0.6, spammer, "Get Good Get Eternity.    ")
    client.delay_call(0.8, spammer, oldName)
end
end)
label = ui_new_label(misc_a, misc_b, "-------------------------[\a3EE826FFEternity\aFFFFFFFF]-------------------------")

local r_print, g_print, b_print = ui_get(menu.watermark_color)
client.color_log(r_print, g_print, b_print, "Welcome to Eternity, ", lua_user.username)
client.color_log(r_print, g_print, b_print, "Current version: ", lua_user.build)
client.color_log(r_print, g_print, b_print, "Join the Discord : ", lua_user.discord)