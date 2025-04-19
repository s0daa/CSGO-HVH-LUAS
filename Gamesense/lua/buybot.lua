local globals_realtime = globals.realtime
local globals_curltime = globals.curltime
local globals_frametime = globals.frametime
local globals_absolute_frametime = globals.absoluteframetime
local globals_maxplayers = globals.maxplayers
local globals_tickcount = globals.tickcount
local globals_tickinterval = globals.tickinterval
local globals_mapname = globals.mapname

local client_set_event_callback = client.set_event_callback
local client_console_log = client.log
local client_console_cmd = client.exec
local client_userid_to_entindex = client.userid_to_entindex
local client_get_cvar = client.get_cvar
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
local client_eye_position = client.eye_posistion

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
local meth_sqrt = math.sqrt
local table_insert = table.insert
local table_remove = table.remove
local table_size = table.getn
local table_sort = table.sort
local string_format = string.format
local bit_band = bit.band

--[[

    Author: NmChris
    Version: 1.0
    Functionality: Disables anti-aim on knife

    Change log:
        N/A

    To-Do:
        - Update using table / round end upload stats

]]--

-- Menu
local menu = {

    buybot = ui_new_checkbox("MISC", "Miscellaneous", "Buy bot"),
    buybot_primary = ui_new_combobox("MISC", "Miscellaneous", "Primary weapon", "Auto", "Scout", "Awp", "Primary rifle", "Scoped rifle", "Machine gun"),
    buybot_secondary = ui_new_combobox("MISC", "Miscellaneous", "Secondary weapon", "Default pistol", "P250", "Dual Berettas", "Light pistol", "Heavy pistol"),
    buybot_utility = ui_new_multiselect("MISC", "Miscellaneous", "Utility", "Grenade", "Smoke", "Incendiary", "Flashbang", "Kevlar + Helmet", "Defuse kit", "Zeus")

}

local function handle_menu()

    local buybot_status = ui_get(menu.buybot)

    ui_set_visible(menu.buybot_primary, buybot_status)
    ui_set_visible(menu.buybot_secondary, buybot_status)
    ui_set_visible(menu.buybot_utility, buybot_status)

end

handle_menu()
ui_set_callback(menu.buybot, handle_menu)

local function translate_menu(item)

    if item == "Auto" then

        return "scar20"

    elseif item == "Scout" then

        return "ssg08"

    elseif item == "Awp" then

        return "awp"

    elseif item == "Primary rifle" then

        return "ak47"

    elseif item == "Scoped rifle" then

        return "sg556"

    elseif item == "Machine gun" then

        return "negev"

    elseif item == "Default pistol" then

        return "glock"

    elseif item == "P250" then

        return "p250"

    elseif item == "Dual Berettas" then

        return "elite"

    elseif item == "Light pistol" then

        return "tec9"

    elseif item == "Heavy pistol" then

        return "deagle"

    elseif item == "Grenade" then

        return "hegrenade"

    elseif item == "Smoke" then

        return "smokegrenade"

    elseif item == "Incendiary" then

        return "molotov"

    elseif item == "Flashbang" then

        return "flashbang"

    elseif item == "Kevlar + Helmet" then

        return "vesthelm"

    elseif item == "Defuse kit" then

        return "defuser"

    elseif item == "Zeus" then

        return "Taser"

    else

        client_console_log("Unknown item: ", item)

    end

end

local function buy_custom()

    local primary_weapon = ui_get(menu.buybot_primary)
    local secondary_weapon = ui_get(menu.buybot_secondary)
    local utility = ui_get(menu.buybot_utility)
    
    local current_buy = nil

    if primary_weapon == "Auto" and entity_get_classname(entity_get_player_weapon(entity_get_local_player())) == "CWeaponSCAR20" then

        current_buy = "buy "..translate_menu(secondary_weapon)

    else

        current_buy = "buy "..translate_menu(primary_weapon).."; ".."buy "..translate_menu(secondary_weapon)
        
    end

    if #utility == 0 then

        client_console_cmd(current_buy)

    else

        for i = 1, #utility do

            current_buy = current_buy.."; buy "..translate_menu(utility[i])

        end

        client_console_cmd(current_buy)

    end

end

local function on_round_end_upload_stats()

    if ui_get(menu.buybot) == false then

        return

    end

    buy_custom()

end

client_set_event_callback("round_end_upload_stats", on_round_end_upload_stats)