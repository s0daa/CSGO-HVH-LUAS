local LICENSE = "MIT"
local VERSION = "2023-03-18"
local AUTOUPDATER = false

-- Cache globals for that $ performance boost $
local ui_is_menu_open, ui_get, ui_set, ui_update, ui_new_color_picker, ui_new_string, ui_reference, ui_set_visible, ui_new_listbox, ui_new_button, ui_new_checkbox, ui_new_label, ui_new_combobox, ui_new_multiselect, ui_new_slider, ui_new_hotkey, ui_set_callback, ui_new_textbox = ui.is_menu_open, ui.get, ui.set, ui.update, ui.new_color_picker, ui.new_string, ui.reference, ui.set_visible, ui.new_listbox, ui.new_button, ui.new_checkbox, ui.new_label, ui.new_combobox, ui.new_multiselect, ui.new_slider, ui.new_hotkey, ui.set_callback, ui.new_textbox
local globals_realtime, globals_curtime, globals_tickcount, globals_maxplayers = globals.realtime, globals.curtime, globals.tickcount, globals.maxplayers
local json_stringify, json_parse = json.stringify, json.parse
local unpack, table_remove, table_insert = table.unpack, table.remove, table.insert
local string_format = string.format
local math_abs, math_sqrt, math_floor, math_ceil = math.abs, math.sqrt, math.floor, math.ceil
local bit_band, bit_lshift = bit.band, bit.lshift
local entity_get_local_player, entity_get_player_weapon, entity_get_classname, entity_get_prop, entity_get_player_resource, entity_get_origin, entity_get_players, entity_get_esp_data, entity_get_game_rules, entity_is_enemy, entity_is_alive = entity.get_local_player, entity.get_player_weapon, entity.get_classname, entity.get_prop, entity.get_player_resource, entity.get_origin, entity.get_players, entity.get_esp_data, entity.get_game_rules, entity.is_enemy, entity.is_alive
local client_color_log, client_timestamp, error_log, client_reload_active_scripts, client_set_event_callback, client_latency, client_current_threat, client_userid_to_entindex, client_screen_size = client.color_log, client.timestamp, client.error_log, client.reload_active_scripts, client.set_event_callback, client.latency, client.current_threat, client.userid_to_entindex, client.screen_size
local database_read, database_write = database.read, database.write
local renderer_text, renderer_measure_text, renderer_gradient = renderer.text, renderer.measure_text, renderer.gradient
local select, setmetatable, toticks, require, tonumber, tostring, ipairs, pairs, type, pcall, writefile, assert, print, printf = select, setmetatable, toticks, require, tonumber, tostring, ipairs, pairs, type, pcall, writefile, assert, print, printf

-- Libraries
local vector = require("vector")
local http = nil

-- If the auto updater is disabled, then dont bother checking for the http library
if AUTOUPDATER then
    if not pcall(require, "gamesense/http") then
        error_log("The HTTP library is needed for the autoupdater to work.")
    else
        http = require("gamesense/http")
    end
end

-- Menu color hex codes. '\aRRGGBBAA'
local WHITE, LIGHTGRAY, GRAY, GREEN, YELLOW, LIGHTRED, RED = "\aFFFFFFE1", "\aAFAFAFE1", "\a646464E1", "\aAFFFAFE1", "\aFFFF96E1", "\aFFAFAFE1", "\aFF8080E1"

-- Local player flags
local FL_ONGROUND = bit_lshift(1, 0)

-- All of the current conditions and their descriptions
local CONDITIONS = {"Always", "Not moving", "Moving", "Slow motion", "On ground", "In air", "On peek", "Breaking LC", "Vulnerable", "Crouching", "Not crouching",  "Height advantage", "Height neutral", "Height disadvantage", "Knifeable", "Zeusable", "Doubletapping", "Defensive", "Terrorist", "Counter terrorist", "Dormant", "Pre round", "Round end"}
local DESCRIPTIONS = {
    ["Always"] = "Always true.",
    ["Not moving"] = "True when your horizontal velocity < 2.",
    ["Moving"] = "True when your horizontal velocity >= 2.",
    ["Slow motion"] = "True when you are moving and holding your slow walk key.",
    ["On ground"] = "True when you are touching the ground.",
    ["In air"] = "True when you are not touching the ground.",
    ["On peek"] = "True for the first 18 ticks you are vulnerable.",
    ["Breaking LC"] = "True when you are breaking lagcomp with fakelag.",
    ["Vulnerable"] = "True when enemies can shoot you.",
    ["Crouching"] = "True when you are crouching and not fake ducking.",
    ["Not crouching"] = "True when you are not crouching.",
    ["Height advantage"] = "True when you are 25 HMU above your anti-aim target.",
    ["Height neutral"] = "True when you are about even height with your anti-aim target",
    ["Height disadvantage"] = "True when you are 25 HMU below your anti-aim target.",
    ["Knifeable"] = "True when you are able to be knifed by an enemy.",
    ["Zeusable"] = "True when you can be zeused by an enemy.",
    ["Doubletapping"] = "True when you are holding your doubletap key and not choking.",
    ["Defensive"] = "True hen you break lagcomp with defensive.",
    ["Terrorist"] = "True when you are on the terrorist team.",
    ["Counter terrorist"] = "True when you are on the counter-terrorist team.",
    ["Dormant"] = "True when all enemies are dormant for you.",
    ["Pre round"] = "True before you can move at the beginning of a round.",
    ["Round end"] = "True when the round is over and there are no remaining alive enemies."
}

-- Will be set to true if an update is availablle on github
local update_available = false
local ignore_update = false

-- Storage for custom conditions
local custom_conditions = {}
local custom_descriptions = {}
local custom_funcs = {}

-- Storage for custom settings
local custom_used_refs = {}
local custom_settings = {}

-- Block data
local blocks = {}
local new_block = false
local current_block = nil
local active_block = nil
local fatal_block = nil

-- Current visible menu screen
local screen = 0

-- Cached ui visibility
local cached_reference_visibility = {}

-- Condition variables
local active_conditions = {}
local vulnerable_ticks = 0
local last_sim_time = 0
local defensive_until = 0
local last_origin = vector(0, 0, 0)
local on_ground_ticks = 0

-- Indicator variables
local sx, sy = client_screen_size()

-- A list of needed menu references
local references = {
    slow_motion = ui_reference("AA", "Other", "Slow motion"),
    slow_motion_key = select(2, ui_reference("AA", "Other", "Slow motion")),
    onshot_aa = ui_reference("AA", "Other", "On shot anti-aim"),
    onshot_aa_key = select(2, ui_reference("AA", "Other", "On shot anti-aim")),
    double_tap = ui_reference("RAGE", "Aimbot", "Double tap"),
    double_tap_key = select(2, ui_reference("RAGE", "Aimbot", "Double tap")),
    double_tap_lag = ui_reference("RAGE", "Aimbot", "Double tap fake lag limit"),
    enabled = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
    pitch_val = select(2, ui_reference("AA", "Anti-aimbot angles", "Pitch")),
    yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = ui_reference("AA", "Anti-aimbot angles", "Yaw"),
    yaw_val = select(2, ui_reference("AA", "Anti-aimbot angles", "Yaw")),
    jitter = ui_reference("AA", "Anti-aimbot angles", "Yaw jitter"),
    jitter_val = select(2, ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")),
    body = ui_reference("AA", "Anti-aimbot angles", "Body yaw"),
    body_val = select(2, ui_reference("AA", "Anti-aimbot angles", "Body yaw")),
    freestand_body = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    edge_yaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    freestanding = ui_reference("AA", "Anti-aimbot angles", "Freestanding"),
    freestanding_key = select(2, ui_reference("AA", "Anti-aimbot angles", "Freestanding")),
    roll = ui_reference("AA", "Anti-aimbot angles", "Roll"),
}

-- A list of created menu elements
-- (x) is the page that it appears on
local menu = {
    -- Main screen (0)
    browser = ui_new_listbox("AA", "Anti-aimbot angles", "browser", blocks),
    new = ui_new_button("AA", "Anti-aimbot angles", GREEN.. "New", function() end),
    edit = ui_new_button("AA", "Anti-aimbot angles", "Edit", function() end),
    edit_inactive = ui_new_button("AA", "Anti-aimbot angles", GRAY.. "Edit", function() end),
    toggle = ui_new_button("AA", "Anti-aimbot angles", "Toggle", function() end),
    toggle_inactive = ui_new_button("AA", "Anti-aimbot angles", GRAY.. "Toggle", function() end),
    move_up = ui_new_button("AA", "Anti-aimbot angles", "Move up", function() end),
    move_up_inactive = ui_new_button("AA", "Anti-aimbot angles", GRAY.. "Move up", function() end),
    move_down = ui_new_button("AA", "Anti-aimbot angles", "Move down", function() end),
    move_down_inactive = ui_new_button("AA", "Anti-aimbot angles", GRAY.. "Move down", function() end),
    delete = ui_new_button("AA", "Anti-aimbot angles", RED.. "Delete", function() end),
    delete_inactive = ui_new_button("AA", "Anti-aimbot angles", GRAY.. "Delete", function() end),
    updater_label = ui_new_label("AA", "Anti-aimbot angles", "Version x.x.x is available."),
    download = ui_new_button("AA", "Anti-aimbot angles", "Download update", function() end),
    ignore = ui_new_button("AA", "Anti-aimbot angles", "Ignore", function() end),

    -- Conditions editing screen (1)
    cond_type = ui_new_combobox("AA", "Anti-aimbot angles", "Conditions type", {"AND", "OR"}),
    cond_browser = ui_new_listbox("AA", "Anti-aimbot angles", "Conditions browser", DEFAULT_CONDITIONS),
    cond_toggle = ui_new_button("AA", "Anti-aimbot angles", "Toggle", function() end),
    finish = ui_new_button("AA", "Anti-aimbot angles", "Finish editing", function() end),
    back = ui_new_button("AA", "Anti-aimbot angles", "Back", function() end),
    descriptions = {},

    -- Preset editing screen (2)
    name_label = ui_new_label("AA", "Anti-aimbot angles", "Block name"),
    name = ui_new_textbox("AA", "Anti-aimbot angles", "\nBlock name"),
    pitch = ui_new_combobox("AA", "Anti-aimbot angles", "Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"}),
    pitch_val = ui_new_slider("AA", "Anti-aimbot angles", "\nPitch val", -89, 89, 0, true, "°"),
    yaw_base = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw base", {"Local view", "At targets"}),
    yaw = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
    yaw_val = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw slider", -180, 180, 8, true, "°"),
    jitter = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw jitter", {"Off", "Offset", "Center", "Random", "Skitter"}),
    jitter_val = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw jitter slider", -180, 180, 8, true, "°"),
    body = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw", {"Off", "Static", "Jitter", "Opposite"}),
    body_val = ui_new_slider("AA", "Anti-aimbot angles", "\nBody yaw slider", -180, 180, 60, true, "°"),
    freestand_body = ui_new_checkbox("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    edge_yaw = ui_new_checkbox("AA", "Anti-aimbot angles", "Edge yaw"),
    freestanding = ui_new_checkbox("AA", "Anti-aimbot angles", "Freestanding", {"Default"}),
    freestanding_key = ui_new_hotkey("AA", "Anti-aimbot angles", "\nFreestanding hotkey", true),
    roll = ui_new_slider("AA", "Anti-aimbot angles", "Roll", -45, 45, 0, true, "°"),
    force_defensive = ui_new_checkbox("AA", "Anti-aimbot angles", "Force defensive"),
    next = ui_new_button("AA", "Anti-aimbot angles", "Next", function() end),
    back2_saved = ui_new_button("AA", "Anti-aimbot angles", "Back", function() end),
    back2_unsaved = ui_new_button("AA", "Anti-aimbot angles", "Back".. RED.. " [unsaved]", function() end),

    -- Other (either always visible or never visible)
    show_active_block = ui_new_checkbox("AA", "Other", "Display blocks"),
    show_active_block_color = ui_new_color_picker("AA", "Other", "Active block color", 158, 196, 29, 225),
    config = ui_new_string("new_aa_config", "{}"), -- if this is a blank string the config system breaks ????
}

-- Returns true if a table contains a certain value
-- Does not work with key:pair tables
--- @param tab table The table we want to search
--- @param val any The value we want to search for
--- @return boolean boolean Returns true if the table contains the given value
local function includes(tab, val)
    for i,v in ipairs(tab) do
        if v == val then
            return true
        end
    end

    return false
end

--- @class Block
--- @field name string The name of the block that appears in the menu
--- @field enabled boolean False if the block should be ignored when running anti-aim
--- @field conditions table A table of conditions that are checked before the anti-aim is activated
--- @field cond_type string AND when all conditions must be true, OR when only 1 condition must be true
--- @field force_defensive boolean True when cmd.force_defensive should be set to 1 when the block is active
--- @field settings table A table of settings that should have corresponding anti-aim references
--- @field custom table A table of user added settings
local Block = {}
do
    Block.__index = Block
    Block.__metatable = "Block"
    local Block_mt = {}

    --- @param name string The name of the block that appears in the menu
    --- @param import_from_menu boolean Should the block be initialized with menu references instead of default values
    --- @return Block self Returns a Block object
    function Block.new(name, import_from_menu)
        name = name or "unknown"
        import_from_menu = import_from_menu or false

        local self = setmetatable({}, Block)

        self.name = name
        self.enabled = true
        self.conditions = {"Always"}
        self.cond_type = "AND"
        self.force_defensive = false
        self.settings = {
            pitch = "Off",
            pitch_val = 0,
            yaw_base = "Local view",
            yaw = "Off",
            yaw_val = -12,
            jitter = "Off",
            jitter_val = 0,
            body = "Off",
            body_val = 60,
            freestand_body = false,
            edge_yaw = false,
            freestanding = false,
            freestanding_key = false,
            roll = 0,
        }
        self.custom = {}

        for k,v in pairs(custom_settings) do
            self.custom[k] = ui_get(v[2])
        end

        -- If we import settings from the menu, change the name to 'gamesense'
        if import_from_menu then
            self.name = "default"
            for k in pairs(self.settings) do
                if references[k] and type(self.settings[k]) == type(ui_get(references[k])) then
                    self.settings[k] = ui_get(references[k])
                end
            end
        end

        return self
    end

    -- Copies a 'deblockified' block object into a block object
    -- Ill eventually update this to suck less
    --- @param tab table A block object that is not a block. Sounds confusing cuz it is.
    --- @return Block self Returns a Block object
    function Block.to_block(tab)
        -- Create a block object to use as a base
        local base = Block.new(tab.name or "Default")

        for k,v in pairs(base) do
            -- If there is a matching field in the tab table and they are of the same type
            -- set the base blocks value to the tabs value
            -- If the value is another table, do the same process on that table
            if type(tab[k]) == "table" and #tab[k] == 0 then -- Tables with 0 length are either empty or key:pair tables, either way it works
                for set, val in pairs(tab[k]) do
                    if base[k][set] ~= nil and type(base[k][set]) == type(val) then
                        base[k][set] = val
                    end
                end
            elseif base[k] ~= nil and type(base[k]) == type(tab[k]) then
                base[k] = tab[k]
            end
        end

        base:validate_conditions()

        return base
    end

    -- Removes all conditions that do not exist
    function Block:validate_conditions()
        for i = #self.conditions, 1, -1 do
            local cond = self.conditions[i]
            if not includes(CONDITIONS, cond) and not includes(custom_conditions, cond) then
                table_remove(self.conditions, i)
            end
        end
    end

    -- Adds/Removes a condition from a blocks list of conditions
    --- @param cond string The condition that should be toggled.
    function Block:toggle_condition(cond)
        if includes(self.conditions, cond) then
            for i,v in ipairs(self.conditions) do
                if v == cond then
                    table_remove(self.conditions, i)

                    if #self.conditions == 0 then
                        self.conditions = {"Always"}
                    end
                end
            end
        else
            self.conditions[#self.conditions+1] = cond
        end
    end

    --- @param local_conditions table A list of the local players active conditions
    --- @return boolean boolean Returns true if a Blocks conditions have been met
    function Block:conditions_met(local_conditions)
        local conditions = self.conditions
        local logic = self.cond_type

        -- If there are no conditions, don't bother checking
        if #conditions == 0 then
            return false
        end

        if logic == "AND" then
            for _,cond in ipairs(conditions) do
                if not local_conditions[cond] then
                    return false
                end
            end

            return true
        elseif logic == "OR" then
            for _,cond in ipairs(conditions) do
                if local_conditions[cond] then
                    return true
                end
            end

            return false
        end

        return false
    end

    -- Updates a blocks values
    -- Does not update conditions or enabled. These are done in different functions.
    function Block:update()
        self.name = ui_get(menu.name)
        self.cond_type = ui_get(menu.cond_type)
        self.force_defensive = ui_get(menu.force_defensive)

        for k in pairs(self.settings) do
            self.settings[k] = ui_get(menu[k])
        end

        for k,v in pairs(custom_settings) do
            self.custom[k] = ui_get(v[2])
        end
    end

    -- Sets the menus anti-aim settings to the blocks settings
    --- @param cmd userdata setup_commands arguement table
    function Block:set_antiaim(cmd)
        for k,v in pairs(self.settings) do
            local ref = references[k]

            -- Freestanding is special because we have a seperate hotkey to activate it.
            if ref and k ~= "freestanding" then
                ui_set(ref, v)
            else

                ui_set(ref, v and ui_get(menu.freestanding_key))
            end
        end

        for k,v in pairs(self.custom) do
            if custom_settings[k] then
                ui_set(custom_settings[k][1], v)
            end
        end

        if self.force_defensive then
            cmd.force_defensive = 1
        end

        if active_block ~= self then
            active_block = self
        end
    end

    -- Returns true if the active block is itself
    --- @return boolean boolean True if the given block is the active block
    function Block:is_active()
        return active_block == self
    end

    -- Prints a json representation of the block to the console
    function Block:print()
        print(json_stringify(self))
    end

    --- @param _ nil ignore this
    --- @param ... any The arguements used in Block.new
    --- @return Block Block a block object
    function Block_mt.__call(_, ...)
        return Block.new(...)
    end

    -- Set Block_mt as a metatable for Block
    setmetatable(Block, Block_mt)
end

-- Sets all of the given menu references to a certain visibility
--- @param b boolean The visibility of each reference in the table
--- @param ... number Every arg except the last one should be a menu reference.
local function set_table_visibility(b, ...)
    local args = {...}

    for i,v in ipairs(args) do
        ui_set_visible(v, b)
    end
end

-- Sets all of the anti-aim settings to a given visibility
--- @param b boolean Menu reference visibility
local function set_references_visibility(b)
    set_table_visibility(b, 
        references.pitch, references.pitch_val, references.yaw_base, references.yaw, 
        references.yaw_val, references.jitter, references.jitter_val, 
        references.body, references.body_val, references.freestand_body, 
        references.roll, references.edge_yaw, 
        references.freestanding, references.freestanding_key
    )
end

-- Displays all of the current blocks in the main listbox
-- Disabled blocks will appear grayed out
local function update_browser()
    local display = {}
    local num = 1
    for i,v in ipairs(blocks) do
        display[#display+1] = v.enabled and string_format("%s[%i] %s%s", LIGHTGRAY, num, WHITE, v.name) or string_format("%s[  ] %s%s", LIGHTGRAY, GRAY, v.name)

        if fatal_block == v then -- Indicate which block got you killed
            display[#display] = display[#display].. RED.. " [dead]"
        end
        
        num = v.enabled and num+1 or num
    end

    ui_update(menu.browser, display)
end

-- Displays all of the conditions. 
-- Custom conditions will have a [c] prefix.
-- Disabled conditions will appear grayed out.
local function update_cond_browser()
    -- We can't check the conditions of a block if there isnt a block
    if not current_block then
        return
    end

    local display = {}

    for _,v in ipairs(CONDITIONS) do
        display[#display+1] = string_format("%s%s", includes(current_block.conditions, v) and WHITE or GRAY, v)
    end

    -- Give custom conditions a prefix so users know they are custom
    for _,v in ipairs(custom_conditions) do
        display[#display+1] = string_format("%s[c] %s%s", YELLOW, includes(current_block.conditions, v) and WHITE or GRAY, v)
    end

    ui_update(menu.cond_browser, display)
end

-- Sets the 2 description labels according to the given conditions description
--- @param condition string The condition that we want the description of
local function update_cond_description(condition)
    if not condition then
        return
    end

    local description = condition.. ": ".. (DESCRIPTIONS[condition] or custom_descriptions[condition] or "None provided.")

    local lines = {}
    local len = 0
    
    -- If the description is longer than 30 characters, split it into multiple lines to help with readability
    local idx = 1
    for s in description:gmatch("%S+") do
        local s_ = s.. " "
        if len + #s_ <= 30 then
            lines[idx] = (lines[idx] or "").. s_
            len = len + #s_
        else
            idx = idx + 1
            lines[idx] = s_
            len = 0
        end
    end

    -- Go through our description. If there is not label available to set, create one
    for i,v in ipairs(lines) do
        if menu.descriptions[i] then
            ui_set_visible(menu.descriptions[i], screen == 2)
        else
            menu.descriptions[#menu.descriptions+1] = ui_new_label("AA", "Anti-aimbot angles", " ")
        end

        ui_set(menu.descriptions[i], LIGHTGRAY.. v)
    end

    -- Hide the labels not already in use
    if #menu.descriptions > #lines then
        for i = #lines+1, #menu.descriptions do
            ui_set_visible(menu.descriptions[i], false)
        end
    end
end

-- Sets all of the menu settings to the current blocks settings
local function update_values()
    if not current_block then
        return
    end

    ui_set(menu.name, current_block.name)
    ui_set(menu.force_defensive, current_block.force_defensive or false)
    ui_set(menu.cond_type, current_block.cond_type)

    for k,v in pairs(current_block.settings) do
        ui_set(menu[k], v)
    end

    for k,v in pairs(current_block.custom) do
        if custom_settings[k] then
            ui_set(custom_settings[k][2], v)
        end
    end

    update_cond_browser()
end

-- Updates the visibility of the created menu references
--- @param s number The screen that we want to show. [0-2]
local function update_visibility(s)
    local browser = ui_get(menu.browser)

    if type(s) == "number" then
        screen = s
    end

    set_table_visibility(screen == 0, menu.browser, menu.new)
    ui_set_visible(menu.edit, screen == 0 and browser)
    ui_set_visible(menu.edit_inactive, screen == 0 and not browser)
    ui_set_visible(menu.toggle, screen == 0 and browser)
    ui_set_visible(menu.toggle_inactive, screen == 0 and not browser)
    ui_set_visible(menu.move_up, screen == 0 and browser and browser > 0)
    ui_set_visible(menu.move_up_inactive, screen == 0 and not (browser and browser > 0))
    ui_set_visible(menu.move_down, screen == 0 and browser and browser < #blocks-1)
    ui_set_visible(menu.move_down_inactive, screen == 0 and not (browser and browser < #blocks-1))
    ui_set_visible(menu.delete, screen == 0 and browser and #blocks > 1)
    ui_set_visible(menu.delete_inactive, screen == 0 and not (browser and #blocks > 1))
    ui_set_visible(menu.updater_label, screen == 0 and update_available)
    ui_set_visible(menu.download, screen == 0 and update_available)
    ui_set_visible(menu.ignore, screen == 0 and update_available)

    set_table_visibility(screen == 2, menu.cond_type, menu.cond_browser, menu.cond_toggle, menu.finish, unpack(menu.descriptions))
    ui_set_visible(menu.back, screen == 2 and not new_block)

    set_table_visibility(screen == 1, menu.name_label, menu.name, menu.pitch, menu.yaw_base, menu.yaw, menu.body,
        menu.edge_yaw, menu.freestanding, menu.freestanding_key, menu.roll, menu.force_defensive, menu.next)
    ui_set_visible(menu.pitch_val, screen == 1 and ui_get(menu.pitch) == "Custom")
    ui_set_visible(menu.yaw_val, screen == 1 and ui_get(menu.yaw) ~= "Off")
    ui_set_visible(menu.jitter, screen == 1 and ui_get(menu.yaw) ~= "Off")
    ui_set_visible(menu.jitter_val, screen == 1 and ui_get(menu.yaw) ~= "Off" and ui_get(menu.jitter) ~= "Off")
    ui_set_visible(menu.body_val, screen == 1 and ui_get(menu.body) ~= "Off" and ui_get(menu.body) ~= "Opposite")
    ui_set_visible(menu.freestand_body, screen == 1 and ui_get(menu.body) ~= "Off")
    --ui_set_visible(menu.fake_limit, screen == 1 and ui_get(menu.body) ~= "Off")
    ui_set_visible(menu.back2_saved, screen == 1 and not new_block)
    ui_set_visible(menu.back2_unsaved, screen == 1 and new_block)

    for k,v in pairs(custom_settings) do
        ui_set_visible(v[2], screen == 1)
    end

    update_browser()
end

--- @return boolean boolean Returns true if the player can be hit by an enemy
local function is_vulnerable()
    for _, v in ipairs(entity_get_players(true)) do
        local flags = (entity_get_esp_data(v)).flags

        if bit_band(flags, bit_lshift(1, 11)) ~= 0 then
            vulnerable_ticks = vulnerable_ticks + 1
            return true
        end
    end

    -- If we aren't vulnerable then we have been vulnerable for 0 ticks
    vulnerable_ticks = 0
    return false
end

--- @return number count The number of alive enemies
local function get_total_enemies()
    local count = 0

    for e = 1, globals_maxplayers() do
        if entity_get_prop(entity_get_player_resource(), "m_bConnected", e) and entity_is_enemy(e) and entity_is_alive(e) then
            count = count + 1
        end
    end

    return count
end

-- I got help from JustiNN?id=1984 with this function. All credit goes to him
--- @credit JustiNN - uid 1984
--- @param local_player number The entindex of the local player
--- @return boolean boolean Returns true if defensive dt is currently active
local function is_defensive_active(local_player)
    local tickcount = globals_tickcount()
    local sim_time = toticks(entity_get_prop(local_player, "m_flSimulationTime"))
    local sim_diff = sim_time - last_sim_time

    if sim_diff < 0 then
        defensive_until = tickcount + math_abs(sim_diff) - toticks(client_latency())
    end
    
    last_sim_time = sim_time

    return defensive_until > tickcount
end

--- @param origin table A vector of the local players origin
--- @param enemies table A list of entindexes
--- @return boolean boolean Returns true if the local player is under the threat of being knifed
local function is_knifeable(origin, enemies)
    local knife_range = 128 -- Its actually 64 but thats too small of a range

    for _,v in ipairs(enemies) do
        local weapon = entity_get_player_weapon(v)
        local weapon_class = entity_get_classname(weapon)

        if weapon_class == "CKnife" then
            local enemy_origin = vector(entity_get_origin(v))
            local dist = origin:dist(enemy_origin)

            if dist <= knife_range then
                return true
            end
        end
    end

    return false
end

--- @param origin table A vector of the local players origin
--- @param enemies table A list of entindexes
--- @return boolean boolean Returns true if the local player is under the threat of being zeused
local function is_zeusable(origin, enemies)
    local taser_range = 230 -- 193 is the largest needed to one shot you
    
    for _,v in ipairs(enemies) do
        local weapon = entity_get_player_weapon(v)
        local weapon_class = entity_get_classname(weapon)

        if weapon_class == "CWeaponTaser" then
            local enemy_origin = vector(entity_get_origin(v))
            local dist = origin:dist(enemy_origin)

            if dist <= taser_range then
                return true
            end
        end
    end

    return false
end

-- Gets all of the possible conditions and calculated whether or not they are active
--- @param cmd userdata setup_commands arguement table
--- @param local_player number the entindex of the local player
--- @return table conditions a key:value table of conditions and whether or not they are active
local function get_conditions(cmd, local_player)
    local game_rules = entity_get_game_rules()
    local velocity = {entity_get_prop(local_player, "m_vecVelocity")}
    local speed = math_sqrt(velocity[1] * velocity[1] + velocity[2] * velocity[2])
    local flags = entity_get_prop(local_player, "m_fFlags")
    local on_ground = bit_band(flags, FL_ONGROUND) == FL_ONGROUND
    local duck_amount = entity_get_prop(local_player, "m_flDuckAmount")
    local team_num = entity_get_prop(entity_get_player_resource(), "m_iTeam", local_player)
    local origin = vector(entity_get_origin(local_player))
    local breaking_lc = (last_origin - origin):length2dsqr() > 4096
    local threat = client_current_threat()
    local height_to_threat = 0
    local vulnerable = is_vulnerable()
    local enemies = entity_get_players(true)
    local curtime = globals_curtime()
    local doubletapping = ui_get(references.double_tap) and ui_get(references.double_tap_key)
    local slowwalking =  ui_get(references.slow_motion) and ui_get(references.slow_motion_key)

    on_ground_ticks = on_ground and on_ground_ticks + 1 or 0
    
    if cmd.chokedcommands == 0 then
        last_origin = origin
    end

    if threat then
        local threat_origin = vector(entity_get_origin(threat))
        height_to_threat = origin.z-threat_origin.z
    end

    local conds = {
        ["Always"] = true,
        ["Not moving"] = speed < 2,
        ["Slow motion"] = slowwalking and speed >= 2,
        ["Moving"] = speed >= 2,
        ["On ground"] = on_ground_ticks > 1,
        ["In air"] = on_ground_ticks <= 1,
        ["On peek"] = vulnerable and vulnerable_ticks <= 16,
        ["Breaking LC"] = breaking_lc,
        ["Height advantage"] = threat and height_to_threat > 25,
        ["Height neutral"] = threat and math_abs(height_to_threat) < 25,
        ["Height disadvantage"] = threat and height_to_threat < -25,
        ["Vulnerable"] = vulnerable,
        ["Not crouching"] = duck_amount < 0.9,
        ["Crouching"] = duck_amount >= 0.9,
        ["Knifeable"] = is_knifeable(origin, enemies),
        ["Zeusable"] = is_zeusable(origin, enemies),
        ["Doubletapping"] = doubletapping and cmd.chokedcommands <= ui_get(references.double_tap_lag),
        ["Defensive"] = is_defensive_active(local_player),
        ["Terrorist"] = team_num == 2,
        ["Counter terrorist"] = team_num == 3,
        ["Dormant"] = #enemies == 0,
        ["Pre round"] = (entity_get_prop(game_rules, "m_fRoundStartTime") - curtime) > 0,
        ["Round end"] = entity_get_prop(game_rules, "m_iRoundWinStatus") ~= 0 and get_total_enemies() == 0
    }

    for _,v in ipairs(custom_conditions) do
        conds[v] = custom_funcs[v](local_player)
    end

    return conds
end

-- Searches through all of the blocks to find one where its conditions are met, then sets the anti-aim settings to the blocks settings
--- @param cmd userdata setup_commands arguement table
--- @param local_conditions table a key:value table of local player conditions
local function run_antiaim(cmd, local_conditions)
    if cmd.chokedcommands > 0 then
        return
    end

    if screen == 1 and ui_is_menu_open() then
        current_block:update()
        current_block:set_antiaim(cmd)
    else
        for i,block in ipairs(blocks) do
            if (block:conditions_met(local_conditions) or i == #blocks) and block.enabled then
                block:set_antiaim(cmd)
                break -- bad coding practice but it works so Im not changing it
            end
        end
    end

    set_references_visibility(false)
end

-- Runs every game tick
--- @param cmd userdata setup_commands arguement table
local function on_setup_command(cmd)
    -- Prevent unneeded calculations for that $ performance boost $
    if not ui_get(references.enabled) then
        return
    end

    local local_player = entity_get_local_player()
    active_conditions = get_conditions(cmd, local_player)

    run_antiaim(cmd, active_conditions)
end

-- Checks which block we had enabled if we died to a headshot
--- @param e userdata player_death event data
local function on_player_death(e)
    if not ui_get(references.enabled) then
        return
    end

    local local_player = entity_get_local_player()
    if client_userid_to_entindex(e.userid) == local_player then
        fatal_block = active_block
        update_browser()
    end
end

-- Calls once every frame
-- Displays all anti-aim blocks, highlighting the active one
local function on_paint()
    if not ui_get(references.enabled) or not ui_get(menu.show_active_block) then
        return
    end

    local local_player = entity_get_local_player()

    if not entity_is_alive(local_player) or not active_block then
        return
    end

    local active_color = {ui_get(menu.show_active_block_color)}
    local base_y = sy - 350
    local offset = 0

    for i = #blocks, 1, -1 do
        local r, g, b, a = unpack(blocks[i]:is_active() and active_color or {255, 255, 255, 200})

        local y = base_y - offset
        local tw, th = renderer_measure_text("rd+", blocks[i].name)

        if tw % 2 == 1 then
            tw = tw + 1
        end

        tw = tw + 40 -- esoterik moment (part 2)

        local tw2 = renderer_measure_text("rd+", "a")
        local half = math_ceil(tw*0.5)

        renderer_gradient(sx - half, y, -half, th + 4, 0, 0, 0, 50, 0, 0, 0, 0, true)
        renderer_gradient(sx- half, y, half, th + 4, 0, 0, 0, 50, 0, 0, 0, 0, true)
        renderer_text(sx - 20, y, r, g, b, a, "rd+", 0, blocks[i].name)

        offset = offset + th + 8
    end
end

-- Adds a setting to use with each block
--- @param name string The name of the setting
--- @param target_ref number The reference you want to modify with each block
--- @param block_ref number The reference you want to edit for each block
--- @param default any [optional] The default value of the setting
local function add_setting(name, target_ref, block_ref, default)
    assert(target_ref ~= block_ref, "The references must be different.")
    assert(not custom_settings[name], "That setting already exists")
    assert(not includes(custom_used_refs, target_ref), "That reference is already being used for a setting.")

    custom_used_refs[#custom_used_refs+1] = target_ref

    local def = default or ui_get(block_ref)

    custom_settings[name] = {
        target_ref, block_ref, def
    }

    for i,v in ipairs(blocks) do
        if not v.custom[name] then
            blocks[i].custom[name] = def
        end
    end

    if setting ~= 1 then
        ui_set_visible(block_ref, false)
    end
end

-- Adds a custom condition to the menu
--- @param name string The name of the condition
--- @param desc string A short description of the condition
--- @param func function A function that determines whether or not the condition is active. Should return a boolean.
local function add_condition(name, desc, func)
    -- make sure that the name becomes a key instead of an index
    name = tostring(name)
    
    -- Make sure the condition is set up correctly
    assert(#name > 0 and name ~= "nil", "The condition must have a name.")
    assert(type(desc) == "string" and #desc > 0, "The condition must have a description.")
    assert(type(func) == "function", "You must add a function to the condition.")
    assert(not includes(custom_conditions, name), "That custom condition already exists.")

    custom_conditions[#custom_conditions+1] = name
    custom_descriptions[name] = desc
    custom_funcs[name] = func
end

-- Returns true if the given condition is active
--- @param name string Case sensitive name of a condition in the condition browser
--- @return boolean boolean Returns true if the condition is active
local function get_condition(name)
    return active_conditions[name] or false
end

-- Returns a list of every condition, including custom one
--- @return table all_conditions Returns a list of every condition, including custom ones
local function get_condition_list()
    local all_conditions = {}

    for _,v in ipairs(CONDITIONS) do all_conditions[#all_conditions+1] = v end
    for _,v in ipairs(custom_conditions) do all_conditions[#all_conditions+1] = v end

    return all_conditions
end

-- Saves the current block table to a menu reference
local function save_config()
    local save_str = tostring(json_stringify(blocks))
    ui_set(menu.config, save_str)
    return save_str
end

-- Loads a config from the config menu reference
-- If there is no config, then create a config with a default block
local function load_config()
    local json_cfg = ui_get(menu.config)
    current_block = nil
    blocks = {}
    
    -- '{}' is the default and the cfg should only be {} when the lua is first loaded
    if json_cfg == "{}" then
        blocks[#blocks+1] = Block("Default", true)
        save_config()
    else
        local cfg = json_parse(ui_get(menu.config)) or {}

        for i,v in ipairs(cfg) do
            blocks[#blocks+1] = Block.to_block(v)
        end

        save_config()
    end

    update_visibility(0)
    set_references_visibility(false)
end

-- Returns the full path to the lua
--- @credit Flux - uid 2885
--- @return string path The full path to the lua, including its extension
local function get_file_path()
    -- _ should always be false
    local _, err = pcall(function() _G() end)
    return _ or err:match('\\(.*):[0-9]'):gsub("\\", "/")
end

-- Calls when the lua is first loaded
local function on_init()
    client_set_event_callback("setup_command", on_setup_command)
    client_set_event_callback("paint", on_paint)
    client_set_event_callback("pre_config_save", save_config)
    client_set_event_callback("post_config_load", load_config)
    client_set_event_callback("player_death", on_player_death)

    client_set_event_callback("shutdown", function()
        set_references_visibility(true)
        database_write("new_aa_cache", {globals_realtime(), blocks, ignore_update})
    end)

    -- Minimized because less lines of code = better
    ui_set_callback(menu.new, function() new_block = true; current_block = Block(); update_values(); update_visibility(1) end)
    ui_set_callback(menu.edit, function() new_block = false; current_block = blocks[ui_get(menu.browser)+1]; update_values(); update_visibility(1) end)
    ui_set_callback(menu.toggle, function() blocks[ui_get(menu.browser)+1].enabled = not blocks[ui_get(menu.browser)+1].enabled; update_browser() end)
    ui_set_callback(menu.delete, function() table_remove(blocks, ui_get(menu.browser)+1); update_browser(); if #blocks > 0 then ui_set(menu.browser, ui_get(menu.browser)-1) end; update_visibility(0) end)
    ui_set_callback(menu.next, function() update_visibility(2) end)
    ui_set_callback(menu.back, function() update_visibility(1) end)
    ui_set_callback(menu.pitch, function() if screen == 1 then update_visibility(1) end end)
    ui_set_callback(menu.yaw, function() if screen == 1 then update_visibility(1) end end)
    ui_set_callback(menu.jitter, function() if screen == 1 then update_visibility(1) end end)
    ui_set_callback(menu.body, function() if screen == 1 then update_visibility(1) end end)
    ui_set_callback(menu.finish, function() current_block:update(); if new_block then blocks[#blocks+1] = current_block end; current_block = nil; update_visibility(0) end)
    ui_set_callback(menu.back2_saved, function() current_block:update(); current_block = nil; update_visibility(0) end)
    ui_set_callback(menu.back2_unsaved, function() current_block = nil; update_visibility(0) end)

    ui_set_callback(menu.cond_toggle, function() 
        if not current_block then
            return
        end

        local idx = ui_get(menu.cond_browser) + 1

        local all_conditions = {}
        for _,v in ipairs(CONDITIONS) do all_conditions[#all_conditions+1] = v end
        for _,v in ipairs(custom_conditions) do all_conditions[#all_conditions+1] = v end 

        current_block:toggle_condition(all_conditions[idx]);
        
        update_cond_browser() 
    end)

    ui_set_callback(menu.move_up, function()
        local idx = ui_get(menu.browser) + 1
        local temp = table_remove(blocks, idx)
        table_insert(blocks, idx-1, temp)
        update_browser()
        ui_set(menu.browser, idx-2)
    end)

    ui_set_callback(menu.move_down, function()
        local idx = ui_get(menu.browser) + 1
        local temp = table_remove(blocks, idx)
        table_insert(blocks, idx+1, temp)
        update_browser()
        ui_set(menu.browser, idx)
    end)

    local prev_browser = {nil, nil}
    ui_set_callback(menu.browser, function(self)
        if not ui_get(self) then
            return
        end

        local idx = ui_get(self) + 1
        local realtime = globals_realtime()

        if idx == prev_browser[1] and realtime - prev_browser[2] <= 0.25 then
            ui_set(menu.edit, true)
        end

        prev_browser = {idx, realtime}
        update_visibility()
    end)

    local prev_cond_browser = {nil, nil}
    ui_set_callback(menu.cond_browser, function(self)
        if not ui_get(self) then
            return
        end

        local idx = ui_get(self) + 1
        local realtime = globals_realtime()

        if idx == prev_cond_browser[1] and realtime - prev_cond_browser[2] <= 0.25 then
            ui_set(menu.cond_toggle, true)
        end

        local all_conditions = {}
        for _,v in ipairs(CONDITIONS) do all_conditions[#all_conditions+1] = v end
        for _,v in ipairs(custom_conditions) do all_conditions[#all_conditions+1] = v end 

        update_cond_description(all_conditions[idx])
        prev_cond_browser = {idx, realtime}
    end)

    -- Read from the luas cache
    local cache = database_read("new_aa_cache")

    -- If the lua was reloaded, it will have been unloaded for 0 seconds
    -- We can use this to cache the block table between lua loads because tables are deleted on unload
    -- If the lua wasnt reloaded, call the load_config function to load blocks to the menu
    if cache and globals_realtime() - cache[1] == 0 then
        ignore_update = cache[3] or false

        for i,v in ipairs(cache[2]) do
            blocks[#blocks+1] = Block.to_block(v)
        end
    else
        load_config()
    end
    
    set_references_visibility(false)
    update_visibility(0)

    -- If the auto updater is off, the lua is in dev mode, or the user is not subscribed to the http library, do not run the autoupdater
    -- I could be using coroutines for this as its async but I don't really feel like it
    if AUTOUPDATER and http and not VERSION:find("d$") then
        -- Checks for an update on the github and sets the download button visible if there is one
        http.get("https://raw.githubusercontent.com/Infinity1G/lua/main/gamesense/aabuilder_version.txt", function(success, response)
            if success and response.status == 200 then
                local cloud_version = response.body
                cloud_version = cloud_version:gsub("\n$", "")

                --local ignored_version = database_read("new_aa_ignore_version") or nil
                --if cloud_version ~= VERSION and cloud_version ~= ignored_version then
                if cloud_version ~= VERSION and not ignore_update then
                    -- Ignore the update until the next update
                    ui_set_callback(menu.ignore, function()
                        update_available = false
                        ignore_update = true
                        --database_write("new_aa_ignore_version", cloud_version)
                        update_visibility()
                    end)

                    -- Overwrite the current lua with the new lua from github
                    ui_set_callback(menu.download, function()
                        http.get("https://raw.githubusercontent.com/Infinity1G/lua/main/gamesense/aabuilder.lua", function(success, response)
                            if success and response.status == 200 then
                                local path = get_file_path()
                                local body = response.body
                                local name = _NAME

                                writefile(path, body)
                                client_reload_active_scripts()
                            end
                        end)
                    end)

                    -- An update is available so set the update label, download button and ignore button to visible
                    update_available = true
                    ui_set(menu.updater_label, string_format("%sVersion %s%s%s is available to download.", LIGHTGRAY, GREEN, cloud_version, LIGHTGRAY))
                    update_visibility()
                end
            end
        end)
    end

    -- Create a global table for other scripts to use
    _G.builder = {}

    builder.add_setting = add_setting
    builder.add_condition = add_condition
    builder.get_condition = get_condition
    builder.get_condition_list = get_condition_list
    builder.save_config = function() return save_config() end
    builder.load_config = function() return load_config() end

    -- Creates a block object
    --- @param name string The name of the block that appears in the menu
    --- @param import_from_menu boolean Should the block be initialized with menu references instead of default values
    builder.add_block = function(name, import_from_menu)
        blocks[#blocks+1] = Block(name, import_from_menu)
        update_browser()
    end

    --- @return Block|nil _ The active block if there is one, nil if there isnt
    builder.get_active_block = function()
        return active_block
    end

    --- @return Block|nil _ The current block if there is one, nil if there isnt
    builder.get_current_block = function()
        return current_block
    end

    --- @return number ref The reference for the config ui string
    builder.get_config_reference = function()
        return menu.config
    end
end

-- Initiate the lua
on_init()
