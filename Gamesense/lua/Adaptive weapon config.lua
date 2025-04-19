--------------------------------------------------------------------------------
-- Cache common functions
--------------------------------------------------------------------------------
local uix = require 'gamesense/uix'
local bit_band, client_error_log, entity_get_local_player, entity_get_player_weapon, entity_get_prop, json_parse, json_stringify, ui_get, pairs, pcall, string_format, ui_new_string, ui_set_callback, ui_set_visible, unpack, func, ipairs, ui_new_label, ui_set, assert = bit.band, client.error_log, entity.get_local_player, entity.get_player_weapon, entity.get_prop, json.parse, json.stringify, ui.get, pairs, pcall, string.format, ui.new_string, ui.set_callback, ui.set_visible, unpack, func, ipairs, ui.new_label, ui.set, assert

--------------------------------------------------------------------------------
-- Constants and variables
--------------------------------------------------------------------------------
local enable_ref
local config_ref
local legacy_ref

local references = {}
local references_builtin = {}

local config_name_to_idx = {}
local config_idx_to_name = {}
local config_idx_to_settings = {}
local weapon_id_to_config_idx = {}

local IDX_GLOBAL = 1
local active_config_idx

local config_idx_to_legacy = {}

--------------------------------------------------------------------------------
-- Utility functions
--------------------------------------------------------------------------------
local function write_settings(config_idx)
    if config_idx then
        local config_settings = config_idx_to_settings[config_idx]
        for setting_key, ref in pairs(references_builtin) do
            config_settings[setting_key] = ui_get(ref)
        end
    end
end

local function save_settings(config_idx)
    if config_idx then
        local config_settings = config_idx_to_settings[config_idx]
        ui_set(references[config_idx], json_stringify(config_settings))
    end
end

local function load_settings(config_idx)
    if config_idx then
        local raw_config_settings = ui_get(references[config_idx])
        local config_settings = json_parse(raw_config_settings)
        for setting_key, value in pairs(config_settings) do
            local set_successful = pcall(ui_set, references_builtin[setting_key], value)
        end
    end
end

local function update_config(config_idx)
    if active_config_idx ~= config_idx then
        write_settings(active_config_idx)
        save_settings(active_config_idx)
        load_settings(config_idx)
        active_config_idx = config_idx
        ui_set(config_ref, config_idx_to_name[config_idx])
    end
end

local function allow_config_change()
    local local_player = entity_get_local_player()
    if local_player then
        return entity.is_alive(local_player) == false
    end
    return true
end

local function init_config(name, ...)
    local config_idx = #references+1
    references[config_idx] = ui_new_string(name.." adaptive settings", "{}")
    
    config_idx_to_legacy[config_idx] = {}

    config_name_to_idx[name] = config_idx
    config_idx_to_name[config_idx] = name
    config_idx_to_settings[config_idx] = {}

    for _, weapon_id in ipairs({...}) do
        weapon_id_to_config_idx[weapon_id] = config_idx
    end
end

local function init_setting(tab, container, name, setting_key, default_value)
    local ref_successful, ref = pcall(ui.reference, tab, container, name)
    if ref_successful then
        references_builtin[setting_key] = ref
        for config_idx=IDX_GLOBAL, #config_idx_to_settings do
            local config_settings = config_idx_to_settings[config_idx]
            config_settings[setting_key] = ui_get(ref)
        end
    end
end

--------------------------------------------------------------------------------
-- Legacy code
--------------------------------------------------------------------------------
local function duplicate(tab, container, name, ui_func, setting_key, ...)
    for config_idx=IDX_GLOBAL, #config_idx_to_settings do
        local config_name = config_idx_to_name[config_idx]
        local ref = ui_func(tab, container, config_name .. " " .. name:lower(), ...)
        ui_set_visible(ref, false)
        config_idx_to_legacy[config_idx][setting_key] = ref
    end
end

local function convert_settings()
    for config_idx=IDX_GLOBAL, #config_idx_to_legacy do
        local legacy_refs = config_idx_to_legacy[config_idx]
        local config_settings = config_idx_to_settings[config_idx]
        for setting_key, ref in pairs(legacy_refs) do
            config_settings[setting_key] = ui_get(ref)
        end
        save_settings(config_idx)
    end
    load_settings(active_config_idx)
end

--------------------------------------------------------------------------------
-- Callback functions
--------------------------------------------------------------------------------
local function on_setup_command()
    local local_player = entity_get_local_player()
    local weapon = entity_get_player_weapon(local_player)
    if weapon then
        local weapon_id = bit_band(entity_get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)
        update_config(weapon_id_to_config_idx[weapon_id] or IDX_GLOBAL)
    end
end

local function on_pre_config_save()
    write_settings(active_config_idx)
    save_settings(active_config_idx)
end

local function on_pre_config_load()
    active_config_idx = nil
end

local function on_post_config_load()
    if ui_get(legacy_ref) then
        convert_settings()
        enable_ref:set(true)
        ui_set(legacy_ref, false)
        enable_ref:set(true)
    end
end

local function on_config_selected(ref)
    if allow_config_change() then
        local config_idx = config_name_to_idx[ui_get(ref)]
        if active_config_idx then
            update_config(config_idx)
        end
        active_config_idx = config_idx
    end
end

local function on_weapon_config_toggle(ref, value)
    ui_set_visible(config_ref, value)
end

--------------------------------------------------------------------------------
-- Initialization code
--------------------------------------------------------------------------------
do
    init_config("Global")
    init_config("Auto", 11, 38)
    init_config("Awp", 9)
    init_config("Scout", 40)
    init_config("Desert Eagle", 1)
    init_config("Revolver", 64)
    init_config("Pistol", 2, 3, 4, 30, 32, 36, 61, 63)
    init_config("Rifle", 7, 8, 10, 13, 16, 39, 60)
    init_config("Submachine gun", 17, 19, 23, 24, 26, 33, 34)
    init_config("Shotgun", 25, 27, 29, 35)
    init_config("Machine gun", 14, 28)

    init_setting("RAGE", "Aimbot", "Target selection", "target_selection")
    init_setting("RAGE", "Aimbot", "Target hitbox", "target_hitbox")
    init_setting("RAGE", "Aimbot", "Multi-point", "multi_point")
    init_setting("RAGE", "Aimbot", "Multi-point scale", "multi_point_scale")
    init_setting("RAGE", "Aimbot", "Prefer safe point", "safe_point_prefer")
    init_setting("RAGE", "Aimbot", "Avoid unsafe hitboxes", "avoid_unsafe_hitboxes")
    init_setting("RAGE", "Aimbot", "Automatic fire", "automatic_fire")
    init_setting("RAGE", "Aimbot", "Automatic penetration", "automatic_penetration")
    init_setting("RAGE", "Aimbot", "Silent aim", "silent_aim")
    init_setting("RAGE", "Aimbot", "Minimum hit chance", "hit_chance")
    init_setting("RAGE", "Aimbot", "Minimum damage", "minimum_damage")
    init_setting("RAGE", "Aimbot", "Automatic scope", "automatic_scope")
    init_setting("RAGE", "Aimbot", "Maximum FOV", "maximum_fov")
    init_setting("RAGE", "Other", "Accuracy boost", "accuracy_boost")
    init_setting("RAGE", "Other", "Delay shot", "delay_shot")
    init_setting("RAGE", "Other", "Quick stop", "quick_stop")
    init_setting("RAGE", "Other", "Quick stop options", "quick_stop_options")
    init_setting("RAGE", "Other", "Prefer body aim", "prefer_baim")
    init_setting("RAGE", "Other", "Prefer body aim disablers", "prefer_baim_disablers")
    init_setting("RAGE", "Other", "Force body aim on peek", "force_baim_peek")
    init_setting("AA", "Other", "On shot anti-aim", "on_shot_aa")

    client.delay_call(0, function()
        init_setting("RAGE", "Other", "Minimum damage override", "damage_override_enable")
        init_setting("RAGE", "Other", "Restore damage", "damage_override_restore")
        init_setting("RAGE", "Other", "Override damage", "damage_override_override")
    end)

    -- Temproary function for converting settings
    duplicate("RAGE", "Aimbot", "Target selection", ui.new_combobox, "target_selection", "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance")
    duplicate("RAGE", "Aimbot", "Target hitbox", ui.new_multiselect, "target_hitbox", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet")
    duplicate("RAGE", "Aimbot", "Multi-point", ui.new_multiselect, "multi_point", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet")
    duplicate("RAGE", "Aimbot", "Multi-point scale", ui.new_slider, "multi_point_scale", 24, 100, 24, true, "%", 1)
    duplicate("RAGE", "Aimbot", "Prefer safe point", ui.new_checkbox, "safe_point_prefer")
    duplicate("RAGE", "Aimbot", "Force safe point on limbs", ui.new_checkbox, "safe_point_limbs")
    duplicate("RAGE", "Aimbot", "Automatic fire", ui.new_checkbox, "automatic_fire")
    duplicate("RAGE", "Aimbot", "Automatic penetration", ui.new_checkbox, "automatic_penetration")
    duplicate("RAGE", "Aimbot", "Silent aim", ui.new_checkbox, "silent_aim")
    duplicate("RAGE", "Aimbot", "Minimum hit chance", ui.new_slider, "hit_chance", 0, 100, 50, true, "%", 1)
    duplicate("RAGE", "Aimbot", "Minimum damage", ui.new_slider, "minimum_damage", 0, 126, 0, true, "%", 1)
    duplicate("RAGE", "Aimbot", "Automatic scope", ui.new_checkbox, "automatic_scope")
    duplicate("RAGE", "Aimbot", "Maximum FOV", ui.new_slider, "maximum_fov", 1, 180, 180, true, "°")
    duplicate("RAGE", "Other", "Accuracy boost", ui.new_combobox, "accuracy_boost", "Off", "Low", "Medium", "High", "Maximum")
    duplicate("RAGE", "Other", "Delay shot", ui.new_checkbox, "delay_shot")
    duplicate("RAGE", "Other", "Quick stop", ui.new_checkbox, "quick_stop")
    duplicate("RAGE", "Other", "Quick stop options", ui.new_multiselect, "quick_stop_options", "Early", "Slow motion", "Duck", "Fake duck", "Move between shots", "Ignore molotov")
    duplicate("RAGE", "Other", "Prefer body aim", ui.new_checkbox, "prefer_baim")
    duplicate("RAGE", "Other", "Prefer body aim disablers", ui.new_multiselect, "prefer_baim_disablers", "Low inaccuracy", "Target shot fired", "Target resolved", "Safe point headshot", "Low damage")
    duplicate("RAGE", "Other", "Force body aim on peek", ui.new_checkbox, "force_baim_peek")
    duplicate("AA", "Other", "On shot anti-aim", ui.new_checkbox, "on_shot_aa") 

    -- save the default config settings
    for config_idx=IDX_GLOBAL, #references do
        save_settings(config_idx)
    end

    enable_ref = uix.new_checkbox("RAGE", "Other", "Weapon configs")
    config_ref = ui.new_combobox("RAGE", "Other", "\nActive config", config_idx_to_name)

    legacy_ref = ui.new_checkbox("RAGE", "Other", "Adaptive config")
    ui_set_visible(legacy_ref, false)
    
    enable_ref:on("change", on_weapon_config_toggle)
    enable_ref:on("setup_command", on_setup_command)
    enable_ref:on("pre_config_save", on_pre_config_save)

    -- Invoke post config load callback regardless of script state so that settings can be converted
    client.set_event_callback("post_config_load", on_post_config_load)
    client.set_event_callback("pre_config_load", on_pre_config_load)

    -- Update the active config idx when the script is loaded.
    ui_set_callback(config_ref, on_config_selected)
end