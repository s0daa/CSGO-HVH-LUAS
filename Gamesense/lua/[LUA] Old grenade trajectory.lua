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

local menu = {

    grenade_prediction = ui_new_checkbox("VISUALS", "Other ESP", "Grenade prediction"),
    grenade_color = ui_new_color_picker("VISUALS", "Other ESP", "Grenade color", 255, 255, 255, 255),

}

local grenade_trajectory, grenade_color = ui_reference("VISUALS", "Other ESP", "Grenade trajectory")

local function handle_menu()

    if ui_get(menu.grenade_prediction) == true then

        ui_set_visible(grenade_trajectory, false)

    else

        ui_set_visible(grenade_trajectory, true)

    end

end

ui_set_callback(menu.grenade_prediction, handle_menu)

local function on_run_command(e)

    if ui_get(menu.grenade_prediction) == false then

        return

    end

    local r, g, b, a = ui_get(menu.grenade_color)
    ui_set(grenade_color, r, g, b, a)

    local weapon_id = entity_get_player_weapon(entity_get_local_player())
    local grenade_pulled = entity_get_prop(weapon_id, "m_bPinPulled")

    if grenade_pulled == 1 then

        ui_set(grenade_trajectory, true)

    else

        ui_set(grenade_trajectory, false)

    end

end

client_set_event_callback("run_command", on_run_command)