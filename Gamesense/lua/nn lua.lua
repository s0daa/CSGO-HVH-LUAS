local globals_realtime = globals.realtime
local globals_curtime = globals.curtime
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
local client_random_int = client.random_int
local client_random_float = client.random_float
local client_draw_text = client.draw_text
local client_draw_rectangle = client.draw_rectangle
local client_draw_line = client.draw_line
local client_world_to_screen = client.world_to_screen
local client_is_local_player = client.is_local_player
local client_delay_call = client.delay_call
local client_visible = client.visible

local ui_new_checkbox = ui.new_checkbox
local ui_new_slider = ui.new_slider
local ui_new_button = ui.new_button
local ui_new_combobox = ui.new_combobox
local ui_new_hotkey = ui.new_hotkey
local ui_reference = ui.reference
local ui_set = ui.set
local ui_get = ui.get

local entity_get_local_player = entity.get_local_player
local entity_get_all = entity.get_all
local entity_get_players = entity.get_players
local entity_get_classname = entity.get_classname
local entity_set_prop = entity.set_prop
local entity_get_prop = entity.get_prop
local entity_is_enemy = entity.is_enemy
local entity_get_player_name = entity.get_player_name
local entity_get_player_weapon = entity.get_player_weapon

local to_number = tonumber
local math_floor = math.floor
local math_random = math.random
local table_insert = table.insert
local table_remove = table.remove
local table_size = table.getn
local string_format = string.format

local function disconnect()

  client_console_cmd("disconnect")
  client_console_log("Disconected")

end

local function toggleconsole()

  client_console_cmd("toggleconsole")

end

local disconnect_button = ui_new_button("MISC", "Other", "Disconnect", disconnect)
local toggleconsole_button = ui_new_button("MISC", "Other", "Open console", toggleconsole)