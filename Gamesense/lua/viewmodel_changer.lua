local console_command = client.exec
local client_userid_to_entindex = client.userid_to_entindex
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
local clatency = client.latency
local indicator = client.draw_indicator
local client_visible = client.visible
local cvar_is = client.get_cvar
local cvar = client.set_cvar
local entity_get_local_player, entity_is_enemy, entity_hitbox_position, entity_get_player_name, entity_get_steam64, entity_get_bounding_box, entity_get_all, entity_set_prop = entity.get_local_player, entity.is_enemy, entity.hitbox_position, entity.get_player_name, entity.get_steam64, entity.get_bounding_box, entity.get_all, entity.set_prop 

local ui_new_checkbox = ui.new_checkbox
local ui_new_slider = ui.new_slider
local ui_new_button = ui.new_button
local ui_new_combobox = ui.new_combobox
local ui_new_hotkey = ui.new_hotkey
local color_picker = ui.new_color_picker
local ui_reference = ui.reference
local ui_set = ui.set
local ui_get = ui.get
local ui_set_visible = ui.set_visible

local entity_get_local_player = entity.get_local_player
local entity_get_all = entity.get_all
local entity_get_players = entity.get_players
local entity_get_classname = entity.get_classname
local entity_set_prop = entity.set_prop
local entity_get_prop = entity.get_prop
local entity_is_enemy = entity.is_enemy
local entity_get_player_name = entity.get_player_name
local entity_get_player_weapon = entity.get_player_weapon
local delay_time = 0
local client_draw_rectangle = client.draw_rectangle
local client_draw_text = client.draw_text
local ui_new_checkbox = ui.new_checkbox
local ui_new_combobox = ui.new_combobox
local ui_get = ui.get
local math_fmod = math.fmod
local screen_width, screen_height = client.screen_size()

local to_number = tonumber
local math_floor = math.floor
local math_random = math.random
local table_insert = table.insert
local table_remove = table.remove
local table_size = table.getn
local string_format = string.format
local xO = 0
local yO = 0
local zO = 0
local fO = 0
local function cache()
    xO = cvar_is("viewmodel_offset_x")
    yO = cvar_is("viewmodel_offset_y")
    zO = cvar_is("viewmodel_offset_z")
  --  fO = cvar_is("viewmodel_fov")
end

cache()
-------------------------------------Menu Elements-----------------------------------------------------

local xS = ui.new_slider("Visuals", "Effects", "Additional Viewmodel X", -20, 20, xO)
local yS = ui.new_slider("Visuals", "Effects", "Additional Viewmodel Y", -100, 100, yO)
local zS = ui.new_slider("Visuals", "Effects", "Additional Viewmodel Z", -20, 20, zO)
local vS = ui_new_slider("Visuals", "Effects", "Additional Viewmodel FOV", -60, 60, fO)

--hide_on_load()
local function on_paint(ctx)
    local viewmodel = 68 + ui_get(vS)
    local x         = ui_get(xS)
    local y         = ui_get(yS)
    local z         = ui_get(zS)
    cvar("viewmodel_offset_x", x)
    cvar("viewmodel_offset_y", y)
    cvar("viewmodel_offset_z", z)
    cvar("viewmodel_fov",      viewmodel)
end

client.set_event_callback("paint", on_paint)