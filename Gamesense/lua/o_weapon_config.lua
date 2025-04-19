--------------------------------------------------------------------------------
-- Constants and variables
--------------------------------------------------------------------------------
local enable_ref
local config_ref
local label_ref
-- local config_ref_visible = true

-- Array of aimbot references
-- references[IDX_BUILTIN] is an array of references to the built-in menu items
-- references[IDX_GLOBAL] is an array of references to the global config
local references  = {}
local IDX_BUILTIN = 1
local IDX_GLOBAL  = 2

local config_idx_to_name = {}
local config_name_to_idx = {}
local weapon_id_to_config_idx = {}

-- Active weapon config is managed by the script when the local player is alive
-- Active weapon config is managed by the user (via the menu) while the local player is dead
local active_config_idx = nil

local SPECATOR_TEAM_ID = 1

--------------------------------------------------------------------------------
-- Utility functions
--------------------------------------------------------------------------------
local function copy_settings(config_idx_src, config_idx_dst)
    local src_refs = references[config_idx_src]
    local dst_refs = references[config_idx_dst]
    for i=1, #dst_refs do
        ui.set(dst_refs[i], ui.get(src_refs[i]))
    end
end

local function load_config(config_idx)
    if active_config_idx ~= config_idx then
        active_config_idx = config_idx
        copy_settings(config_idx, IDX_BUILTIN)
        ui.set(label_ref, "Active weapon config: " .. config_idx_to_name[config_idx])
    end
end

local function update_config_visibility(state)
    local display_config = state
    local script_state = ui.get(enable_ref)
    if display_config == nil then
        display_config = entity.is_alive(entity.get_local_player()) == false
    end
    local display_label = not display_config
    -- config_ref_visible = display_config
    ui.set_visible(config_ref, display_config and script_state)
    ui.set_visible(label_ref, display_label and script_state)
    return display_config
end

local function save_reference(config_idx, setting_idx, ref)
    references[config_idx][setting_idx] = ref
    return ref
end

local function bind(func, ...)
    local args = {...}
    return function(ref)
        func(ref, unpack(args))
    end
end

local function delayed_bind(func, delay, ...)
    local args = {...}
    return function(ref)
        client.delay_call(delay, func, ref, unpack(args))
    end
end

-- Temporary function for enabling config in the menu
local function temp_task()
    update_config_visibility()
    client.delay_call(5, temp_task)
end
--------------------------------------------------------------------------------
-- Callback functions
--------------------------------------------------------------------------------
local function on_setup_command()
    local local_player = entity.get_local_player()
    -- Get the local players weapon so we can find its item definition index
    local weapon = entity.get_player_weapon(local_player)
    -- Get the weapons item definition and toggle off the 16th bit to get the real item def index
    local weapon_id = bit.band(entity.get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)
    -- Use the weapon_id_to_config_idx lookup table to get the new config index and attempt to load the config
    load_config(weapon_id_to_config_idx[weapon_id] or IDX_GLOBAL)
end

local function on_player_death(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        update_config_visibility(true)
    end
end

local function on_player_spawn(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        update_config_visibility(false)
    end
end

local function on_player_team_change(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        -- Check if the team the local player switched to is spectator(1)
        if e.team == SPECATOR_TEAM_ID then
            update_config_visibility(true)
        end
    end
end

local function on_game_disconnect(e)
    update_config_visibility(true)
end

-- Called when a user selects a different weapon config with the combobox
local function on_weapon_config_selected(ref)
    -- If the local player is alive then do nothing and hide this combobox
    if update_config_visibility() == false then
        -- This should never happen
        -- client.error_log("Weapon config selected while local player is alive!")
        return
    end

    -- Load settings from the selected weapon config
    local config_name = ui.get(ref)
    local config_idx = config_name_to_idx[config_name]
    load_config(config_idx)
end

-- Called when a user changes the value of a built-in menu item (e.g. checking "Automatic penetrationn")
-- Also called when a config is loaded
local function on_builtin_setting_change(ref, setting_idx)
    -- Propagate built-in setting changes to the adaptive settings
    if active_config_idx ~= nil and ui.get(enable_ref) == true then
        ui.set(references[active_config_idx][setting_idx], ui.get(ref))
    end
end

-- Called when a user changes the value of a weapon configs menu item (e.g. checking "Global automatic penetration")
-- Also called when a config is loaded
local function on_adaptive_setting_changed(ref, config_idx, setting_idx)
    -- Propagate adaptive setting changes to the built-in settings
    if config_idx == active_config_idx and ui.get(enable_ref) == true then
        ui.set(references[IDX_BUILTIN][setting_idx], ui.get(ref))
    end
end

-- Called when a user toggles the main script checkbox
-- Also called on script load
local function on_adaptive_config_toggled(ref)
    local script_state = ui.get(ref)
    -- Update the configs visibility when the script is toggled
    update_config_visibility()
    -- Set / unset event callbacks based on the state of the script so that we aren't just invoking callbacks for no reason
	local update_callback = script_state and client.set_event_callback or client.unset_event_callback
    update_callback("setup_command", on_setup_command)
    update_callback("player_death", on_player_death)
    update_callback("player_spawn", on_player_spawn)
    update_callback("player_team", on_player_team_change)
    update_callback("cs_game_disconnected", on_game_disconnect)
end

--------------------------------------------------------------------------------
-- Initialization code
--------------------------------------------------------------------------------
local function duplicate(tab, container, name, ui_func, ...)
    -- This menu item will have the same index across all weapon configs
    local setting_index = #references[IDX_BUILTIN] + 1
    -- Create hidden menu items to store values
    for i=IDX_GLOBAL, #references do
        local config_name = config_idx_to_name[i]
        -- Create a duplicate menu item to store settings that can be copied later
        local ref = save_reference(i, setting_index, ui_func(tab, container, config_name .. " " .. name:lower(), ...))
        -- Set a default value for the target hitbox as this multiselect cannot be empty
        if name == "Target hitbox" then
            ui.set(ref, {"Head"})
        end
        ui.set_visible(ref, false)
        ui.set_callback(ref, bind(on_adaptive_setting_changed, i, setting_index))
    end
    local ref = save_reference(IDX_BUILTIN, setting_index, ui.reference(tab, container, name))
    -- Set a callback on the built-in menu items so that settings are not overwritten whenever we are loading a new config
    ui.set_callback(ref, delayed_bind(on_builtin_setting_change, 0.01, setting_index))
end

local function init_config(name, ...)
    local config_idx = #references + 1
    references[config_idx] = {}
    config_idx_to_name[config_idx] = name
    config_name_to_idx[name] = config_idx
    -- Populate the weapon_id_to_config_idx lookup table so we can easily get a configs index from a weapon id
    for _, weapon_id in ipairs({...}) do
        weapon_id_to_config_idx[weapon_id] = config_idx
    end
    return config_idx
end

local function init()
    IDX_BUILTIN = init_config("Built-in menu items")
	init_config("Global")
	init_config("Awp", 9)
	init_config("Scout", 40)
    init_config("Desert Eagle", 1)
    
    init_config("Auto", 11, 38)
    init_config("Revolver", 64)
    init_config("Pistol", 2, 3, 4, 30, 32, 36, 61, 63)
	init_config("Rifle", 7, 8, 10, 13, 16, 39, 60)
	init_config("Submachine gun", 17, 19, 23, 24, 26, 33, 34)
	init_config("Machine gun", 14, 28)
    init_config("Shotgun", 25, 27, 29, 35)
    
    assert(config_idx_to_name[IDX_GLOBAL] == "Global")

    enable_ref = ui.new_checkbox("RAGE", "Other", "Adaptive config")
    config_ref = ui.new_combobox("RAGE", "Other", "\nAdaptive config", config_idx_to_name)
    label_ref = ui.new_label("RAGE", "Other", "Active weapon config: " .. ui.get(config_ref))
    
    -- duplicate("RAGE", "Aimbot", "Target selection", ui.new_combobox, "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance")
	duplicate("RAGE", "Aimbot", "Target hitbox", ui.new_multiselect, "Head", "Chest", "Stomach", "Arms", "Legs", "Feet")
	duplicate("RAGE", "Aimbot", "Multi-point", ui.new_multiselect, "Head", "Chest", "Stomach", "Arms", "Legs", "Feet")
	duplicate("RAGE", "Aimbot", "Multi-point scale", ui.new_slider, 24, 100, 24, true, "%", 1, multipoint_override)
	--duplicate("RAGE", "Aimbot", "Dynamic multi-point", ui.new_checkbox)
    duplicate("RAGE", "Aimbot", "Prefer safe point", ui.new_checkbox)
    duplicate("RAGE", "Aimbot", "Avoid unsafe hitboxes", ui.new_multiselect, "Head", "Chest", "Stomach", "Arms", "Legs")
	-- duplicate("RAGE", "Aimbot", "Automatic fire", ui.new_checkbox)
	-- duplicate("RAGE", "Aimbot", "Automatic penetration", ui.new_checkbox)
	-- duplicate("RAGE", "Aimbot", "Silent aim", ui.new_checkbox)
	duplicate("RAGE", "Aimbot", "Minimum hit chance", ui.new_slider, 0, 100, 50, true, "%", 1, hitchance_override)
	duplicate("RAGE", "Aimbot", "Minimum damage", ui.new_slider, 0, 126, 0, true, "%", 1, mindamage_override)
	-- duplicate("RAGE", "Aimbot", "Automatic scope", ui.new_checkbox)
    -- duplicate("RAGE", "Aimbot", "Maximum FOV", ui.new_slider, 1, 180, 180, true, "°")
    -- duplicate("RAGE", "Other", "Remove recoil", ui.new_checkbox)
    duplicate("RAGE", "Other", "Accuracy boost", ui.new_combobox, "Off", "Low", "Medium", "High", "Maximum")
    duplicate("RAGE", "Other", "Delay shot", ui.new_checkbox)
    duplicate("RAGE", "Other", "Quick stop", ui.new_checkbox)
    duplicate("RAGE", "Other", "Quick stop options", ui.new_multiselect, "Early", "Slow motion", "Duck", "Move between shots", "Ignore molotov", "Taser")
	duplicate("RAGE", "Other", "Prefer body aim", ui.new_checkbox)
	duplicate("RAGE", "Other", "Prefer body aim disablers", ui.new_multiselect, "Low inaccuracy", "Target shot fired", "Target resolved", "Safe point headshot", "Low damage")
    duplicate("RAGE", "Other", "Force body aim on peek", ui.new_checkbox)
    duplicate("RAGE", "Other", "Double tap quick stop", ui.new_multiselect, "Slow motion", "Duck", "Move between shots")
    duplicate("RAGE", "Other", "Double tap hit chance", ui.new_slider, 0, 100, 50, true, "%", 1)
    duplicate("RAGE", "Other", "Double tap fake lag limit", ui.new_slider, 1, 10, 1)
    --duplicate("RAGE", "Other", "Double tap", ui.new_checkbox)

    local create_custom_reference = function(req, ref)
        local reference_if_exists = function(...)
            if pcall(ui.reference, ...) then
                 return true
            end
        end

        local get_script_name = function()
            local funca, err = pcall(function() _G() end)
            return (not funca and err:match("\\(.*):"):sub(1, -3) or nil)
        end

        if not reference_if_exists(ref[1], ref[2], ref[3]) then
            if pcall(require, req) and reference_if_exists(ref[1], ref[2], ref[3]) then
                duplicate(unpack(ref))
            else
                client.log(string.format('%s: Unable to reference - %s (%s.lua/ljbc)', get_script_name(), ref[3], req))
            end
        else
            duplicate(unpack(ref))
        end
    end

    create_custom_reference("o_weapon_super_safety", { "RAGE", "Other", "Force safe point", ui.new_checkbox })
    create_custom_reference("o_weapon_mindmg", { "RAGE", "Other", "Minimum damage override", ui.new_checkbox })
    create_custom_reference("o_weapon_mindmg", { "RAGE", "Other", "Override damage", ui.new_slider, 0, 126, 0, true, "%", 1, mindamage_override })
    create_custom_reference("o_weapon_mindmg", { "RAGE", "Other", "Restore damage", ui.new_slider, 0, 126, 0, true, "%", 1, mindamage_override })

    --[[
        local el = {
            prefer_head = { 'Target shot fired', 'In air', 'Is crouching', 'Is walking', 'Backwards/Forwards', 'Sideways' },
            prefer_body = { 'Force condition', 'Target shot fired', 'In air', 'Is crouching', 'Is walking', 'Backwards/Forwards', 'Sideways', '2 Shots', 'Lethal', '<x HP', 'Correction active' },
        }
    
        create_custom_reference("m_threat_scan", { "RAGE", "Other", "Prefer head-aim", ui.new_multiselect, el.prefer_head })
        create_custom_reference("m_threat_scan", { "RAGE", "Other", "Prefer body-aim", ui.new_multiselect, el.prefer_body })
        create_custom_reference("m_threat_scan", { "RAGE", "Other", "Force body-aim", ui.new_multiselect, el.prefer_body })
        create_custom_reference("m_threat_scan", { "RAGE", "Other", "Force safety", ui.new_multiselect, el.prefer_body })
        create_custom_reference("m_threat_scan", { "RAGE", "Other", "Force safety after x misses", ui.new_slider, 0, 10, 0, true, "", 1, { [0] = 'Off' } })
        create_custom_reference("m_threat_scan", { "RAGE", "Other", "<x HP Condition", ui.new_slider, 1, 100, 25 })
    ]]

    ui.set_callback(config_ref, on_weapon_config_selected)
	ui.set_callback(enable_ref, on_adaptive_config_toggled)
    
    temp_task()
	on_adaptive_config_toggled(enable_ref)
end

init()