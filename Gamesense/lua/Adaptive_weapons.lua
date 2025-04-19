local globals_realtime = globals.realtime
local globals_curtime = globals.curtime
local globals_frametime = globals.frametime
local globals_absolute_frametime = globals.absoluteframetime
local globals_maxplayers = globals.maxplayers
local globals_tickcount = globals.tickcount
local globals_tickinterval = globals.tickinterval
local globals_mapname = globals.mapname

local client_set_event_callback = client.set_event_callback
local client_console_log = client.log
local client_color_log = client.color_log
local client_console_cmd = client.exec
local client_userid_to_entindex = client.userid_to_entindex
local client_get_cvar = client.get_cvar
local client_set_cvar = client.set_cvar
local client_draw_debug_text = client.draw_debug_text
local client_draw_hitboxes = client.draw_hitboxes
local client_draw_indicator = client.draw_indicator
local client_random_int = client.random_int
local client_random_float = client.random_float
local client_draw_text = client.draw_text
local client_draw_rectangle = client.draw_rectangle
local client_draw_line = client.draw_line
local client_draw_gradient = client.draw_gradient
local client_draw_cricle = client.draw_circle
local client_draw_circle_outline = client.draW_circle_outline
local client_world_to_screen = client.world_to_screen
local client_screen_size = client.screen_size
local client_visible = client.visible
local client_delay_call = client.delay_call
local client_latency = client.latency
local client_camera_angles = client.camera_angles
local client_trace_line = client.trace_line
local client_eye_position = client.eye_position
local client_set_clan_tag = client.set_clan_tag
local client_system_time = client.system_time

local entity_get_local_player = entity.get_local_player
local entity_get_all = entity.get_all
local entity_get_players = entity.get_players
local entity_get_classname = entity.get_classname
local entity_set_prop = entity.set_prop
local entity_get_prop = entity.get_prop
local entity_is_enemy = entity.is_enemy
local entity_get_player_name = entity.get_player_name
local entity_get_player_weapon = entity.get_player_weapon
local entity_hitbox_position = entity.hitbox_position
local entity_get_steam64 = entity.get_steam64
local entity_get_bounding_box = entity.get_bounding_box
local entity_is_alive = entity.is_alive
local entity_is_dormant = entity.is_dormant

local ui_new_checkbox = ui.new_checkbox
local ui_new_slider = ui.new_slider
local ui_new_combobox = ui.new_combobox
local ui_new_multiselect = ui.new_multiselect
local ui_new_hotkey = ui.new_hotkey
local ui_new_button = ui.new_button
local ui_new_color_picker = ui.new_color_picker
local ui_reference = ui.reference
local ui_set = ui.set
local ui_get = ui.get
local ui_set_callback = ui.set_callback
local ui_set_visible = ui.set_visible
local ui_is_menu_open = ui.is_menu_open

local math_floor = math.floor
local math_random = math.random
local math_sqrt = math.sqrt
local table_insert = table.insert
local table_remove = table.remove
local table_size = table.getn
local table_sort = table.sort
local string_format = string.format
local string_length = string.len
local string_reverse = string.reverse
local string_sub = string.sub

--[[

    Author: NmChris
    Version: 1.0
    Functionality: Per weapon ragebot configs

    Change log:
        N/A

    To-Do:
        - Add multipoint type (High, Medium, Low)

]]--

-- Menu
local menu = {

    adaptive_weapon_config = ui_new_checkbox("RAGE", "Other", "Adaptive weapon config"),
    adaptive_config = ui_new_combobox("RAGE", "Aimbot", "Weapon config", "Global", "Auto", "Scout", "AWP", "Pistols", "Desert Eagle", "R8 Revolver", "Rifles", "Machine guns", "Submachine guns", "Shotguns"),
    adaptive_hide = ui_new_checkbox("MISC", "Settings", "Hide adaptive weapon config"),

}

ui_set_visible(menu.adaptive_config, false)
ui_set_visible(menu.adaptive_hide, false)

local mp_override = {

    [24] = "Auto",

}

local hc_override = {

    [0] = "Off",

}

local md_override = {

    [0] = "Auto",
    [101] = "HP + 1",
    [102] = "HP + 2",
    [103] = "HP + 3",
    [104] = "HP + 4",
    [105] = "HP + 5",
    [106] = "HP + 6",
    [107] = "HP + 7",
    [108] = "HP + 8",
    [109] = "HP + 9",
    [110] = "HP + 10",
    [111] = "HP + 11",
    [112] = "HP + 12",
    [113] = "HP + 13",
    [114] = "HP + 14",
    [115] = "HP + 15",
    [116] = "HP + 16",
    [117] = "HP + 17",
    [118] = "HP + 18",
    [119] = "HP + 19",
    [120] = "HP + 20",
    [121] = "HP + 21",
    [122] = "HP + 22",
    [123] = "HP + 23",
    [124] = "HP + 24",
    [125] = "HP + 25",
    [126] = "HP + 26",

}

-- Adaptive
local adaptive = {

    global = {

        target_selection = ui_new_combobox("RAGE", "Aimbot", "Global target selection", "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"),
        target_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Global target hitbox", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        avoid_limbs = ui_new_checkbox("RAGE", "Aimbot", "Global avoid limbs if moving"),
        avoid_head = ui_new_checkbox("RAGE", "Aimbot", "Global avoid head if jumping"),
        multipoint_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Global multi-point", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        multipoint_scale = ui_new_slider("RAGE", "Aimbot", "Global multi-point scale", 24, 100, 0, true, "%", 1, mp_override),
        dynamic_multipoint = ui_new_checkbox("RAGE", "Aimbot", "Global dynamic multi-point"),
        stomach_scale = ui_new_slider("RAGE", "Aimbot", "Global stomach hitbox scale", 1, 100, 0, true, "%"),
        min_hitchance = ui_new_slider("RAGE", "Aimbot", "Global minimum hit chance", 0, 100, 0, true, "%", 1, hc_override),
        min_damage = ui_new_slider("RAGE", "Aimbot", "Global minimum damage", 0, 126, 0, true, "%", 1, md_override),
        accuracy_boost = ui_new_combobox("RAGE", "Other", "Global accuracy boost", "Off", "Low", "Medium", "High", "Maximum"),
        accuracy_options = ui_new_multiselect("RAGE", "Other", "Global accuracy boost options", "Refine shot", "Extended backtrack"),
        quickstop = ui_new_combobox("RAGE", "Other", "Global quick stop", "Off", "On", "On + duck", "On + slow motion"),
        prefer_baim = ui_new_combobox("RAGE", "Other", "Global prefer body aim", "Off", "Always on", "Moving targets", "Aggressive", "High inaccuracy")

    },

    auto = {

        target_selection = ui_new_combobox("RAGE", "Aimbot", "Auto target selection", "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"),
        target_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Auto target hitbox", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        avoid_limbs = ui_new_checkbox("RAGE", "Aimbot", "Auto avoid limbs if moving"),
        avoid_head = ui_new_checkbox("RAGE", "Aimbot", "Auto avoid head if jumping"),
        multipoint_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Auto multi-point", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        multipoint_scale = ui_new_slider("RAGE", "Aimbot", "Auto multi-point scale", 24, 100, 0, true, "%", 1, mp_override),
        dynamic_multipoint = ui_new_checkbox("RAGE", "Aimbot", "Auto dynamic multi-point"),
        stomach_scale = ui_new_slider("RAGE", "Aimbot", "Auto stomach hitbox scale", 1, 100, 0, true, "%"),
        min_hitchance = ui_new_slider("RAGE", "Aimbot", "Auto minimum hit chance", 0, 100, 0, true, "%", 1, hc_override),
        min_damage = ui_new_slider("RAGE", "Aimbot", "Auto minimum damage", 0, 126, 0, true, "%", 1, md_override),
        accuracy_boost = ui_new_combobox("RAGE", "Other", "Auto accuracy boost", "Off", "Low", "Medium", "High", "Maximum"),
        accuracy_options = ui_new_multiselect("RAGE", "Other", "Auto accuracy boost options", "Refine shot", "Extended backtrack"),
        quickstop = ui_new_combobox("RAGE", "Other", "Auto quick stop", "Off", "On", "On + duck", "On + slow motion"),
        prefer_baim = ui_new_combobox("RAGE", "Other", "Auto prefer body aim", "Off", "Always on", "Moving targets", "Aggressive", "High inaccuracy")

    },

    scout = {

        target_selection = ui_new_combobox("RAGE", "Aimbot", "Scout target selection", "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"),
        target_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Scout target hitbox", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        avoid_limbs = ui_new_checkbox("RAGE", "Aimbot", "Scout avoid limbs if moving"),
        avoid_head = ui_new_checkbox("RAGE", "Aimbot", "Scout avoid head if jumping"),
        multipoint_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Scout multi-point", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        multipoint_scale = ui_new_slider("RAGE", "Aimbot", "Scout multi-point scale", 24, 100, 0, true, "%", 1, mp_override),
        dynamic_multipoint = ui_new_checkbox("RAGE", "Aimbot", "Scout dynamic multi-point"),
        stomach_scale = ui_new_slider("RAGE", "Aimbot", "Scout stomach hitbox scale", 1, 100, 0, true, "%"),
        min_hitchance = ui_new_slider("RAGE", "Aimbot", "Scout minimum hit chance", 0, 100, 0, true, "%", 1, hc_override),
        min_damage = ui_new_slider("RAGE", "Aimbot", "Scout minimum damage", 0, 126, 0, true, "%", 1, md_override),
        accuracy_boost = ui_new_combobox("RAGE", "Other", "Scout accuracy boost", "Off", "Low", "Medium", "High", "Maximum"),
        accuracy_options = ui_new_multiselect("RAGE", "Other", "Scout accuracy boost options", "Refine shot", "Extended backtrack"),
        quickstop = ui_new_combobox("RAGE", "Other", "Scout quick stop", "Off", "On", "On + duck", "On + slow motion"),
        prefer_baim = ui_new_combobox("RAGE", "Other", "Scout prefer body aim", "Off", "Always on", "Moving targets", "Aggressive", "High inaccuracy")

    },

    awp = {

        target_selection = ui_new_combobox("RAGE", "Aimbot", "Awp target selection", "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"),
        target_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Awp target hitbox", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        avoid_limbs = ui_new_checkbox("RAGE", "Aimbot", "Awp avoid limbs if moving"),
        avoid_head = ui_new_checkbox("RAGE", "Aimbot", "Awp avoid head if jumping"),
        multipoint_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Awp multi-point", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        multipoint_scale = ui_new_slider("RAGE", "Aimbot", "Awp multi-point scale", 24, 100, 0, true, "%", 1, mp_override),
        dynamic_multipoint = ui_new_checkbox("RAGE", "Aimbot", "Awp dynamic multi-point"),
        stomach_scale = ui_new_slider("RAGE", "Aimbot", "Awp stomach hitbox scale", 1, 100, 0, true, "%"),
        min_hitchance = ui_new_slider("RAGE", "Aimbot", "Awp minimum hit chance", 0, 100, 0, true, "%", 1, hc_override),
        min_damage = ui_new_slider("RAGE", "Aimbot", "Awp minimum damage", 0, 126, 0, true, "%", 1, md_override),
        accuracy_boost = ui_new_combobox("RAGE", "Other", "Awp accuracy boost", "Off", "Low", "Medium", "High", "Maximum"),
        accuracy_options = ui_new_multiselect("RAGE", "Other", "Awp accuracy boost options", "Refine shot", "Extended backtrack"),
        quickstop = ui_new_combobox("RAGE", "Other", "Awp quick stop", "Off", "On", "On + duck", "On + slow motion"),
        prefer_baim = ui_new_combobox("RAGE", "Other", "Awp prefer body aim", "Off", "Always on", "Moving targets", "Aggressive", "High inaccuracy")

    },

    pistols = {

        target_selection = ui_new_combobox("RAGE", "Aimbot", "Pistol target selection", "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"),
        target_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Pistol target hitbox", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        avoid_limbs = ui_new_checkbox("RAGE", "Aimbot", "Pistol avoid limbs if moving"),
        avoid_head = ui_new_checkbox("RAGE", "Aimbot", "Pistol avoid head if jumping"),
        multipoint_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Pistol multi-point", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        multipoint_scale = ui_new_slider("RAGE", "Aimbot", "Pistol multi-point scale", 24, 100, 0, true, "%", 1, mp_override),
        dynamic_multipoint = ui_new_checkbox("RAGE", "Aimbot", "Pistol dynamic multi-point"),
        stomach_scale = ui_new_slider("RAGE", "Aimbot", "Pistol stomach hitbox scale", 1, 100, 0, true, "%"),
        min_hitchance = ui_new_slider("RAGE", "Aimbot", "Pistol minimum hit chance", 0, 100, 0, true, "%", 1, hc_override),
        min_damage = ui_new_slider("RAGE", "Aimbot", "Pistol minimum damage", 0, 126, 0, true, "%", 1, md_override),
        accuracy_boost = ui_new_combobox("RAGE", "Other", "Pistol accuracy boost", "Off", "Low", "Medium", "High", "Maximum"),
        accuracy_options = ui_new_multiselect("RAGE", "Other", "Pistol accuracy boost options", "Refine shot", "Extended backtrack"),
        quickstop = ui_new_combobox("RAGE", "Other", "Pistol quick stop", "Off", "On", "On + duck", "On + slow motion"),
        prefer_baim = ui_new_combobox("RAGE", "Other", "Pistol prefer body aim", "Off", "Always on", "Moving targets", "Aggressive", "High inaccuracy")

    },

    deagle = {

        target_selection = ui_new_combobox("RAGE", "Aimbot", "Deagle target selection", "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"),
        target_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Deagle target hitbox", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        avoid_limbs = ui_new_checkbox("RAGE", "Aimbot", "Deagle avoid limbs if moving"),
        avoid_head = ui_new_checkbox("RAGE", "Aimbot", "Deagle avoid head if jumping"),
        multipoint_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Deagle multi-point", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        multipoint_scale = ui_new_slider("RAGE", "Aimbot", "Deagle multi-point scale", 24, 100, 0, true, "%", 1, mp_override),
        dynamic_multipoint = ui_new_checkbox("RAGE", "Aimbot", "Deagle dynamic multi-point"),
        stomach_scale = ui_new_slider("RAGE", "Aimbot", "Deagle stomach hitbox scale", 1, 100, 0, true, "%"),
        min_hitchance = ui_new_slider("RAGE", "Aimbot", "Deagle minimum hit chance", 0, 100, 0, true, "%", 1, hc_override),
        min_damage = ui_new_slider("RAGE", "Aimbot", "Deagle minimum damage", 0, 126, 0, true, "%", 1, md_override),
        accuracy_boost = ui_new_combobox("RAGE", "Other", "Deagle accuracy boost", "Off", "Low", "Medium", "High", "Maximum"),
        accuracy_options = ui_new_multiselect("RAGE", "Other", "Deagle accuracy boost options", "Refine shot", "Extended backtrack"),
        quickstop = ui_new_combobox("RAGE", "Other", "Deagle quick stop", "Off", "On", "On + duck", "On + slow motion"),
        prefer_baim = ui_new_combobox("RAGE", "Other", "Deagle prefer body aim", "Off", "Always on", "Moving targets", "Aggressive", "High inaccuracy")

    },

    revolver = {

        target_selection = ui_new_combobox("RAGE", "Aimbot", "Revolver target selection", "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"),
        target_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Revolver target hitbox", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        avoid_limbs = ui_new_checkbox("RAGE", "Aimbot", "Revolver avoid limbs if moving"),
        avoid_head = ui_new_checkbox("RAGE", "Aimbot", "Revolver avoid head if jumping"),
        multipoint_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Revolver multi-point", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        multipoint_scale = ui_new_slider("RAGE", "Aimbot", "Revolver multi-point scale", 24, 100, 0, true, "%", 1, mp_override),
        dynamic_multipoint = ui_new_checkbox("RAGE", "Aimbot", "Revolver dynamic multi-point"),
        stomach_scale = ui_new_slider("RAGE", "Aimbot", "Revolver stomach hitbox scale", 1, 100, 0, true, "%"),
        min_hitchance = ui_new_slider("RAGE", "Aimbot", "Revolver minimum hit chance", 0, 100, 0, true, "%", 1, hc_override),
        min_damage = ui_new_slider("RAGE", "Aimbot", "Revolver minimum damage", 0, 126, 0, true, "%", 1, md_override),
        accuracy_boost = ui_new_combobox("RAGE", "Other", "Revolver accuracy boost", "Off", "Low", "Medium", "High", "Maximum"),
        accuracy_options = ui_new_multiselect("RAGE", "Other", "Revolver accuracy boost options", "Refine shot", "Extended backtrack"),
        quickstop = ui_new_combobox("RAGE", "Other", "Revolver quick stop", "Off", "On", "On + duck", "On + slow motion"),
        prefer_baim = ui_new_combobox("RAGE", "Other", "Revolver prefer body aim", "Off", "Always on", "Moving targets", "Aggressive", "High inaccuracy")

    },

    rifles = {

        target_selection = ui_new_combobox("RAGE", "Aimbot", "Rifle target selection", "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"),
        target_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Rifle target hitbox", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        avoid_limbs = ui_new_checkbox("RAGE", "Aimbot", "Rifle avoid limbs if moving"),
        avoid_head = ui_new_checkbox("RAGE", "Aimbot", "Rifle avoid head if jumping"),
        multipoint_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Rifle multi-point", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        multipoint_scale = ui_new_slider("RAGE", "Aimbot", "Rifle multi-point scale", 24, 100, 0, true, "%", 1, mp_override),
        dynamic_multipoint = ui_new_checkbox("RAGE", "Aimbot", "Rifle dynamic multi-point"),
        stomach_scale = ui_new_slider("RAGE", "Aimbot", "Rifle stomach hitbox scale", 1, 100, 0, true, "%"),
        min_hitchance = ui_new_slider("RAGE", "Aimbot", "Rifle minimum hit chance", 0, 100, 0, true, "%", 1, hc_override),
        min_damage = ui_new_slider("RAGE", "Aimbot", "Rifle minimum damage", 0, 126, 0, true, "%", 1, md_override),
        accuracy_boost = ui_new_combobox("RAGE", "Other", "Rifle accuracy boost", "Off", "Low", "Medium", "High", "Maximum"),
        accuracy_options = ui_new_multiselect("RAGE", "Other", "Rifle accuracy boost options", "Refine shot", "Extended backtrack"),
        quickstop = ui_new_combobox("RAGE", "Other", "Rifle quick stop", "Off", "On", "On + duck", "On + slow motion"),
        prefer_baim = ui_new_combobox("RAGE", "Other", "Rifle prefer body aim", "Off", "Always on", "Moving targets", "Aggressive", "High inaccuracy")

    },

    machine_guns = {

        target_selection = ui_new_combobox("RAGE", "Aimbot", "Machine gun target selection", "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"),
        target_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Machine gun target hitbox", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        avoid_limbs = ui_new_checkbox("RAGE", "Aimbot", "Machine gun avoid limbs if moving"),
        avoid_head = ui_new_checkbox("RAGE", "Aimbot", "Machine gun avoid head if jumping"),
        multipoint_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Machine gun multi-point", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        multipoint_scale = ui_new_slider("RAGE", "Aimbot", "Machine gun multi-point scale", 24, 100, 0, true, "%", 1, mp_override),
        dynamic_multipoint = ui_new_checkbox("RAGE", "Aimbot", "Machine gun dynamic multi-point"),
        stomach_scale = ui_new_slider("RAGE", "Aimbot", "Machine gun stomach hitbox scale", 1, 100, 0, true, "%"),
        min_hitchance = ui_new_slider("RAGE", "Aimbot", "Machine gun minimum hit chance", 0, 100, 0, true, "%", 1, hc_override),
        min_damage = ui_new_slider("RAGE", "Aimbot", "Machine gun minimum damage", 0, 126, 0, true, "%", 1, md_override),
        accuracy_boost = ui_new_combobox("RAGE", "Other", "Machine gun accuracy boost", "Off", "Low", "Medium", "High", "Maximum"),
        accuracy_options = ui_new_multiselect("RAGE", "Other", "Machine gun accuracy boost options", "Refine shot", "Extended backtrack"),
        quickstop = ui_new_combobox("RAGE", "Other", "Machine gun quick stop", "Off", "On", "On + duck", "On + slow motion"),
        prefer_baim = ui_new_combobox("RAGE", "Other", "Machine gun prefer body aim", "Off", "Always on", "Moving targets", "Aggressive", "High inaccuracy")

    },

    submachine_guns = {

        target_selection = ui_new_combobox("RAGE", "Aimbot", "Submachine gun target selection", "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"),
        target_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Submachine gun target hitbox", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        avoid_limbs = ui_new_checkbox("RAGE", "Aimbot", "Submachine gun avoid limbs if moving"),
        avoid_head = ui_new_checkbox("RAGE", "Aimbot", "Submachine gun avoid head if jumping"),
        multipoint_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Submachine gun multi-point", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        multipoint_scale = ui_new_slider("RAGE", "Aimbot", "Submachine gun multi-point scale", 24, 100, 0, true, "%", 1, mp_override),
        dynamic_multipoint = ui_new_checkbox("RAGE", "Aimbot", "Submachine gun dynamic multi-point"),
        stomach_scale = ui_new_slider("RAGE", "Aimbot", "Submachine gun stomach hitbox scale", 1, 100, 0, true, "%"),
        min_hitchance = ui_new_slider("RAGE", "Aimbot", "Submachine gun minimum hit chance", 0, 100, 0, true, "%", 1, hc_override),
        min_damage = ui_new_slider("RAGE", "Aimbot", "Submachine gun minimum damage", 0, 126, 0, true, "%", 1, md_override),
        accuracy_boost = ui_new_combobox("RAGE", "Other", "Submachine gun accuracy boost", "Off", "Low", "Medium", "High", "Maximum"),
        accuracy_options = ui_new_multiselect("RAGE", "Other", "Submachine gun accuracy boost options", "Refine shot", "Extended backtrack"),
        quickstop = ui_new_combobox("RAGE", "Other", "Submachine gun quick stop", "Off", "On", "On + duck", "On + slow motion"),
        prefer_baim = ui_new_combobox("RAGE", "Other", "Submachine gun prefer body aim", "Off", "Always on", "Moving targets", "Aggressive", "High inaccuracy")

    },

    shotguns = {

        target_selection = ui_new_combobox("RAGE", "Aimbot", "Shotgun target selection", "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"),
        target_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Shotgun target hitbox", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        avoid_limbs = ui_new_checkbox("RAGE", "Aimbot", "Shotgun avoid limbs if moving"),
        avoid_head = ui_new_checkbox("RAGE", "Aimbot", "Shotgun avoid head if jumping"),
        multipoint_hitbox = ui_new_multiselect("RAGE", "Aimbot", "Shotgun multi-point", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet"),
        multipoint_scale = ui_new_slider("RAGE", "Aimbot", "Shotgun multi-point scale", 24, 100, 0, true, "%", 1, mp_override),
        dynamic_multipoint = ui_new_checkbox("RAGE", "Aimbot", "Shotgun dynamic multi-point"),
        stomach_scale = ui_new_slider("RAGE", "Aimbot", "Shotgun stomach hitbox scale", 1, 100, 0, true, "%"),
        min_hitchance = ui_new_slider("RAGE", "Aimbot", "Shotgun minimum hit chance", 0, 100, 0, true, "%", 1, hc_override),
        min_damage = ui_new_slider("RAGE", "Aimbot", "Shotgun minimum damage", 0, 126, 0, true, "%", 1, md_override),
        accuracy_boost = ui_new_combobox("RAGE", "Other", "Shotgun accuracy boost", "Off", "Low", "Medium", "High", "Maximum"),
        accuracy_options = ui_new_multiselect("RAGE", "Other", "Shotgun accuracy boost options", "Refine shot", "Extended backtrack"),
        quickstop = ui_new_combobox("RAGE", "Other", "Shotgun quick stop", "Off", "On", "On + duck", "On + slow motion"),
        prefer_baim = ui_new_combobox("RAGE", "Other", "Shotgun prefer body aim", "Off", "Always on", "Moving targets", "Aggressive", "High inaccuracy")

    },

}

-- Reference
local reference = {

    target_selection = ui_reference("RAGE", "Aimbot", "Target selection"),
    target_hitbox = ui_reference("RAGE", "Aimbot", "Target hitbox"),
    avoid_limbs = ui_reference("RAGE", "Aimbot", "Avoid limbs if moving"),
    avoid_head = ui_reference("RAGE", "Aimbot", "Avoid head if jumping"),
    multipoint_hitbox = ui_reference("RAGE", "Aimbot", "Multi-point"),
    multipoint_scale = ui_reference("RAGE", "Aimbot", "Multi-point scale"),
    dynamic_multipoint = ui_reference("RAGE", "Aimbot", "Dynamic multi-point"),
    stomach_scale = ui_reference("RAGE", "Aimbot", "Stomach hitbox scale"),
    min_hitchance = ui_reference("RAGE", "Aimbot", "Minimum hit chance"),
    min_damage = ui_reference("RAGE", "Aimbot", "Minimum damage"),
    accuracy_boost = ui_reference("RAGE", "Other", "Accuracy boost"),
    accuracy_options = ui_reference("RAGE", "Other", "Accuracy boost options"),
    quickstop = ui_reference("RAGE", "Other", "Quick stop"),
    prefer_baim = ui_reference("RAGE", "Other", "Prefer body aim")

}

-- Variables
local variable = {

    current_weapon = nil,
    current_item_index = nil,
    current_active_config = nil,
    current_menu = nil,
    current_key = nil,
    cached_key = nil

}

local function handle_menu()

    if ui_get(menu.adaptive_weapon_config) == true then

        ui_set_visible(menu.adaptive_config, true)
        ui_set_visible(menu.adaptive_hide, true)

        for config, settings in pairs(adaptive) do

            for setting_name, setting_reference in pairs(settings) do

                if config == variable.current_key then

                    if ui_get(menu.adaptive_hide) == true then

                        ui_set_visible(setting_reference, false)

                    else

                        ui_set_visible(setting_reference, true)

                    end

                end

            end

        end

    else

        ui_set_visible(menu.adaptive_config, false)
        ui_set_visible(menu.adaptive_hide, false)

        for config, settings in pairs(adaptive) do

            for setting_name, setting_reference in pairs(settings) do

                ui_set_visible(setting_reference, false)

            end

        end

    end

end

handle_menu()
ui_set_callback(menu.adaptive_weapon_config, handle_menu)
ui_set_callback(menu.adaptive_hide, handle_menu)

local function update_adaptive_config()

    if variable.current_menu == nil then

        variable.current_menu = ui_get(menu.adaptive_config)

    end

    if variable.current_menu ~= ui_get(menu.adaptive_config) then

        variable.current_menu = ui_get(menu.adaptive_config)

    end

    if variable.current_menu == "Global" then

        variable.cached_key = variable.current_key
        variable.current_key = "global"

    elseif variable.current_menu == "Auto" then

        variable.cached_key = variable.current_key
        variable.current_key = "auto"

    elseif variable.current_menu == "Scout" then

        variable.cached_key = variable.current_key
        variable.current_key = "scout"

    elseif variable.current_menu == "AWP" then

        variable.cached_key = variable.current_key
        variable.current_key = "awp"

    elseif variable.current_menu == "Pistols" then

        variable.cached_key = variable.current_key
        variable.current_key = "pistols"

    elseif variable.current_menu == "Desert Eagle" then

        variable.cached_key = variable.current_key
        variable.current_key = "deagle"

    elseif variable.current_menu == "R8 Revolver" then

        variable.cached_key = variable.current_key
        variable.current_key = "revolver"

    elseif variable.current_menu == "Rifles" then

        variable.cached_key = variable.current_key
        variable.current_key = "rifles"

    elseif variable.current_menu == "Machine guns" then

        variable.cached_key = variable.current_key
        variable.current_key = "machine_guns"

    elseif variable.current_menu == "Submachine guns" then

        variable.cached_key = variable.current_key
        variable.current_key = "submachine_guns"

    elseif variable.current_menu == "Shotguns" then

        variable.cached_key = variable.current_key
        variable.current_key = "shotguns"

    end

    if ui_get(menu.adaptive_hide) == true then

        return

    else

        for config, settings in pairs(adaptive) do

            for setting_name, setting_reference in pairs(settings) do

                if config == variable.cached_key then

                    ui_set_visible(setting_reference, false)

                end

                if config == variable.current_key then

                    ui_set_visible(setting_reference, true)

                end

            end

        end

    end

end

ui_set_callback(menu.adaptive_config, update_adaptive_config)

local function handle_adaptive_menu()

    for config, settings in pairs(adaptive) do

        if #ui_get(settings.target_hitbox) == 0 then

            ui_set(settings.target_hitbox, "Head")

        end

        if config == variable.current_key then

            if variable.current_active_config == variable.current_menu then

                ui_set(reference.target_selection, ui_get(settings.target_selection))
                ui_set(reference.target_hitbox, ui_get(settings.target_hitbox))
                ui_set(reference.avoid_limbs, ui_get(settings.avoid_limbs))
                ui_set(reference.avoid_head, ui_get(settings.avoid_head))
                ui_set(reference.multipoint_hitbox, ui_get(settings.multipoint_hitbox))
                ui_set(reference.multipoint_scale, ui_get(settings.multipoint_scale))
                ui_set(reference.dynamic_multipoint, ui_get(settings.dynamic_multipoint))
                ui_set(reference.stomach_scale, ui_get(settings.stomach_scale))
                ui_set(reference.min_hitchance, ui_get(settings.min_hitchance))
                ui_set(reference.min_damage, ui_get(settings.min_damage))
                ui_set(reference.accuracy_boost, ui_get(settings.accuracy_boost))
                ui_set(reference.accuracy_options, ui_get(settings.accuracy_options))
                ui_set(reference.quickstop, ui_get(settings.quickstop))
                ui_set(reference.prefer_baim, ui_get(settings.prefer_baim))

            end

        end

    end

end

for config, settings in pairs(adaptive) do

    for setting_name, setting_reference in pairs(settings) do

        ui_set_callback(setting_reference, handle_adaptive_menu)

    end

end

local function set_config(config)

    if variable.current_active_config == config and variable.current_active_config ~= nil then

        return

    end

    if config == "Global" then

        variable.current_active_config = "Global"
        ui_set(menu.adaptive_config, "Global")

        update_adaptive_config()
        client_console_log("Global config loaded.")

    elseif config == "Auto" then

        variable.current_active_config = "Auto"
        ui_set(menu.adaptive_config, "Auto")
        
        update_adaptive_config()
        client_console_log("Auto config loaded.")

    elseif config == "Scout" then

        variable.current_active_config = "Scout"
        ui_set(menu.adaptive_config, "Scout")
        
        update_adaptive_config()
        client_console_log("Scout config loaded.")

    elseif config == "AWP" then

        variable.current_active_config = "AWP"
        ui_set(menu.adaptive_config, "AWP")
        
        update_adaptive_config()
        client_console_log("AWP config loaded.")

    elseif config == "Pistols" then

        variable.current_active_config = "Pistols"
        ui_set(menu.adaptive_config, "Pistols")
        
        update_adaptive_config()
        client_console_log("Pistols config loaded.")

    elseif config == "Desert Eagle" then

        variable.current_active_config = "Desert Eagle"
        ui_set(menu.adaptive_config, "Desert Eagle")
        
        update_adaptive_config()
        client_console_log("Desert Eagle config loaded.")

    elseif config == "R8 Revolver" then

        variable.current_active_config = "R8 Revolver"
        ui_set(menu.adaptive_config, "R8 Revolver")
        
        update_adaptive_config()
        client_console_log("R8 Revolver config loaded.")

    elseif config == "Rifles" then

        variable.current_active_config = "Rifles"
        ui_set(menu.adaptive_config, "Rifles")
        
        update_adaptive_config()
        client_console_log("Rifles config loaded.")

    elseif config == "Machine guns" then

        variable.current_active_config = "Machine guns"
        ui_set(menu.adaptive_config, "Machine guns")
        
        update_adaptive_config()
        client_console_log("Machine guns config loaded.")

    elseif config == "Submachine guns" then

        variable.current_active_config = "Submachine guns"
        ui_set(menu.adaptive_config, "Submachine guns")
        
        update_adaptive_config()
        client_console_log("Submachine guns config loaded.")

    elseif config == "Shotguns" then

        variable.current_active_config = "Shotguns"
        ui_set(menu.adaptive_config, "Shotguns")
        
        update_adaptive_config()
        client_console_log("Shotguns config loaded.")

    else

        client_console_log("Error loading config: ", config)

    end

    for config, settings in pairs(adaptive) do

        if config == variable.current_key then

            ui_set(reference.target_selection, ui_get(settings.target_selection))
            ui_set(reference.target_hitbox, ui_get(settings.target_hitbox))
            ui_set(reference.avoid_limbs, ui_get(settings.avoid_limbs))
            ui_set(reference.avoid_head, ui_get(settings.avoid_head))
            ui_set(reference.multipoint_hitbox, ui_get(settings.multipoint_hitbox))
            ui_set(reference.multipoint_scale, ui_get(settings.multipoint_scale))
            ui_set(reference.dynamic_multipoint, ui_get(settings.dynamic_multipoint))
            ui_set(reference.stomach_scale, ui_get(settings.stomach_scale))
            ui_set(reference.min_hitchance, ui_get(settings.min_hitchance))
            ui_set(reference.min_damage, ui_get(settings.min_damage))
            ui_set(reference.accuracy_boost, ui_get(settings.accuracy_boost))
            ui_set(reference.accuracy_options, ui_get(settings.accuracy_options))
            ui_set(reference.quickstop, ui_get(settings.quickstop))
            ui_set(reference.prefer_baim, ui_get(settings.prefer_baim))

        end

    end

end

local function get_weapon(entindex)

    local weapon_id = entity_get_player_weapon(entindex)
    local weapon_item_index = entity_get_prop(weapon_id, "m_iItemDefinitionIndex")

    if variable.current_item_index == weapon_item_index and variable.current_item_index ~= nil then

        return variable.current_weapon

    end

    if weapon_item_index > 200000 then

        weapon_item_index = weapon_item_index % 65536

    end

    if weapon_item_index == 1 then

        variable.current_weapon = "Desert Eagle"
        variable.current_item_index = weapon_item_index
        set_config("Desert Eagle")

    elseif weapon_item_index == 2 then

        variable.current_weapon = "Dual Berettas"
        variable.current_item_index = weapon_item_index
        set_config("Pistols")

    elseif weapon_item_index == 3 then

        variable.current_weapon = "Five-SeveN"
        variable.current_item_index = weapon_item_index
        set_config("Pistols")

    elseif weapon_item_index == 4 then

        variable.current_weapon = "Glock-18"
        variable.current_item_index = weapon_item_index
        set_config("Pistols")

    elseif weapon_item_index == 7 then

        variable.current_weapon = "AK-47"
        variable.current_item_index = weapon_item_index
        set_config("Rifles")

    elseif weapon_item_index == 8 then

        variable.current_weapon = "AUG"
        variable.current_item_index = weapon_item_index
        set_config("Rifles")

    elseif weapon_item_index == 9 then

        variable.current_weapon = "AWP"
        variable.current_item_index = weapon_item_index
        set_config("AWP")

    elseif weapon_item_index == 10 then

        variable.current_weapon = "FAMAS"
        variable.current_item_index = weapon_item_index
        set_config("Rifles")

    elseif weapon_item_index == 11 then

        variable.current_weapon = "G3SG1"
        variable.current_item_index = weapon_item_index
        set_config("Auto")

    elseif weapon_item_index == 13 then

        variable.current_weapon = "Galil AR"
        variable.current_item_index = weapon_item_index
        set_config("Rifles")

    elseif weapon_item_index == 14 then

        variable.current_weapon = "M249"
        variable.current_item_index = weapon_item_index
        set_config("Machine guns")

    elseif weapon_item_index == 16 then

        variable.current_weapon = "M4A4"
        variable.current_item_index = weapon_item_index
        set_config("Rifles")

    elseif weapon_item_index == 17 then

        variable.current_weapon = "MAC-10"
        variable.current_item_index = weapon_item_index
        set_config("Submachine guns")

    elseif weapon_item_index == 19 then

        variable.current_weapon = "P90"
        variable.current_item_index = weapon_item_index
        set_config("Submachine guns")

    elseif weapon_item_index == 23 then

        variable.current_weapon = "MP5-SD"
        variable.current_item_index = weapon_item_index
        set_config("Submachine guns")

    elseif weapon_item_index == 24 then

        variable.current_weapon = "UMP-45"
        variable.current_item_index = weapon_item_index
        set_config("Submachine guns")

    elseif weapon_item_index == 25 then

        variable.current_weapon = "XM1014"
        variable.current_item_index = weapon_item_index
        set_config("Shotguns")

    elseif weapon_item_index == 26 then

        variable.current_weapon = "PP-Bizon"
        variable.current_item_index = weapon_item_index
        set_config("Submachine guns")

    elseif weapon_item_index == 27 then

        variable.current_weapon = "MAG-7"
        variable.current_item_index = weapon_item_index
        set_config("Shotguns")

    elseif weapon_item_index == 28 then

        variable.current_weapon = "Negev"
        variable.current_item_index = weapon_item_index
        set_config("Machine guns")

    elseif weapon_item_index == 29 then

        variable.current_weapon = "Sawed-Off"
        variable.current_item_index = weapon_item_index
        set_config("Shotguns")

    elseif weapon_item_index == 30 then

        variable.current_weapon = "Tec-9"
        variable.current_item_index = weapon_item_index
        set_config("Pistols")

    elseif weapon_item_index == 32 then

        variable.current_weapon = "P2000"
        variable.current_item_index = weapon_item_index
        set_config("Pistols")

    elseif weapon_item_index == 33 then

        variable.current_weapon = "MP7"
        variable.current_item_index = weapon_item_index
        set_config("Submachine guns")

    elseif weapon_item_index == 34 then

        variable.current_weapon = "MP9"
        variable.current_item_index = weapon_item_index
        set_config("Submachine guns")

    elseif weapon_item_index == 35 then

        variable.current_weapon = "Nova"
        variable.current_item_index = weapon_item_index
        set_config("Shotguns")

    elseif weapon_item_index == 36 then

        variable.current_weapon = "P250"
        variable.current_item_index = weapon_item_index
        set_config("Pistols")

    elseif weapon_item_index == 38 then

        variable.current_weapon = "SCAR-20"
        variable.current_item_index = weapon_item_index
        set_config("Auto")

    elseif weapon_item_index == 39 then

        variable.current_weapon = "SG 553"
        variable.current_item_index = weapon_item_index
        set_config("Rifles")

    elseif weapon_item_index == 40 then

        variable.current_weapon = "SSG 08"
        variable.current_item_index = weapon_item_index
        set_config("Scout")

    elseif weapon_item_index == 60 then

        variable.current_weapon = "M4A1-S"
        variable.current_item_index = weapon_item_index
        set_config("Rifles")

    elseif weapon_item_index == 61 then

        variable.current_weapon = "USP-S"
        variable.current_item_index = weapon_item_index
        set_config("Pistols")

    elseif weapon_item_index == 63 then

        variable.current_weapon = "CZ75-Auto"
        variable.current_item_index = weapon_item_index
        set_config("Pistols")

    elseif weapon_item_index == 64 then

        variable.current_weapon = "R8 Revolver"
        variable.current_item_index = weapon_item_index
        set_config("R8 Revolver")

    else

        variable.current_weapon = "Other"
        variable.current_item_index = weapon_item_index
        set_config("Global")

    end

    return variable.current_weapon

end

local function on_run_command(e)

    if ui_get(menu.adaptive_weapon_config) == false then

        return

    end

    local local_player = entity_get_local_player()

    if not entity_is_alive(local_player) or local_player == nil then

        return

    end

    if variable.current_weapon ~= get_weapon(local_player) then

        get_weapon(local_player)

    end

end

client_set_event_callback("run_command", on_run_command)