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

local ui_new_checkbox = ui.new_checkbox
local ui_new_slider = ui.new_slider
local ui_new_combobox = ui.new_combobox
local ui_new_multiselect = ui.new_multiselect
local ui_new_hotkey = ui.new_hotkey
local ui_new_button = ui.new_button
local ui_reference = ui.reference
local ui_set = ui.set
local ui_get = ui.get
local ui_set_callback = ui.set_callback
local ui_set_visible = ui.set_visible

local math_floor = math.floor
local math_random = math.random
local table_insert = table.insert
local table_remove = table.remove
local table_size = table.getn
local string_format = string.format

-- Menu
local round_end_aa = ui_new_checkbox("AA", "Other", "Disable anti-aim on round end.")

-- References
local reference = {

  pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
  yaw = ui_reference("AA", "Anti-aimbot angles", "Yaw"),
  jitter = ui_reference("AA", "Anti-aimbot angles", "Yaw jitter"),
  running = ui_reference("AA", "Anti-aimbot angles", "Yaw while running"),
  fake = ui_reference("AA", "Anti-aimbot angles", "Fake yaw"),
  freestanding = ui_reference("AA", "Anti-aimbot angles", "Freestanding"),
  fakelag = ui_reference("AA", "Fake lag", "Enabled")

}

-- Cache
local cache = {

  pitch = nil,
  yaw = nil,
  jitter = nil,
  running = nil,
  fake = nil,
  freestanding = nil,
  fakelag = nil,
  cached = nil

}

-- Variables
local variable = {

  aa_status = nil

}

local function check_players()

  local enemies = entity_get_players(true)

  if #enemies == 0 then

    if cache.cached == nil then

      cache.pitch = ui_get(reference.pitch)
      cache.yaw = ui_get(reference.yaw)
      cache.jitter = ui_get(reference.jitter)
      cache.running = ui_get(reference.running)
      cache.fake = ui_get(reference.fake)
      cache.freestanding = ui_get(reference.freestanding)
      cache.fakelag = ui_get(reference.fakelag)
      cache.cached = true

    elseif cache.pitch ~= ui_get(reference.pitch) or cache.yaw ~= ui_get(reference.yaw) or cache.jitter ~= ui_get(reference.jitter) or cache.running ~= ui_get(reference.running) or cache.fake ~= ui_get(reference.fake) or cache.freestanding ~= ui_get(reference.freestanding) or cache.fakelag ~= ui_get(reference.fakelag) then

      cache.pitch = ui_get(reference.pitch)
      cache.yaw = ui_get(reference.yaw)
      cache.jitter = ui_get(reference.jitter)
      cache.running = ui_get(reference.running)
      cache.fake = ui_get(reference.fake)
      cache.freestanding = ui_get(reference.freestanding)
      cache.fakelag = ui_get(reference.fakelag)

    end

    ui_set(reference.pitch, "Off")
    ui_set(reference.yaw, "Off")
    ui_set(reference.jitter, "Off")
    ui_set(reference.running, "Off")
    ui_set(reference.fake, "Off")
    ui_set(reference.freestanding, {})
    ui_set(reference.fakelag, false)

    variable.aa_status = 0
    client_console_log("Disabled anti-aim.")

  else

    client_console_log("Players alive.")

  end

end

local function on_round_end()

  if ui_get(round_end_aa) == false then

    return

  end

  client_delay_call(0.2, check_players)

end

local function on_round_prestart()

  if ui_get(round_end_aa) == false then

    return

  end

  if variable.aa_status == nil then

    return

  elseif variable.aa_status == 0 then

    ui_set(reference.pitch, cache.pitch)
    ui_set(reference.yaw, cache.yaw)
    ui_set(reference.jitter, cache.jitter)
    ui_set(reference.running, cache.running)
    ui_set(reference.fake, cache.fake)
    ui_set(reference.freestanding, cache.freestanding)
    ui_set(reference.fakelag, cache.fakelag)

    variable.aa_status = 1
    client_console_log("Enabled anti-aim.")

  end

end

local function on_game_disconnected()

  if variable.aa_status == nil then

    return

  elseif variable.aa_status == 0 then

    ui_set(reference.pitch, cache.pitch)
    ui_set(reference.yaw, cache.yaw)
    ui_set(reference.jitter, cache.jitter)
    ui_set(reference.running, cache.running)
    ui_set(reference.fake, cache.fake)
    ui_set(reference.freestanding, cache.freestanding)
    ui_set(reference.fakelag, cache.fakelag)

    variable.aa_status = 1
    client_console_log("Enabled anti-aim.")

  end

end

client_set_event_callback("round_end", on_round_end)
client_set_event_callback("round_prestart", on_round_prestart)
client_set_event_callback("cs_game_disconnected", on_game_disconnected)