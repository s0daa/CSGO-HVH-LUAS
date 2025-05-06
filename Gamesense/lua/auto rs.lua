--region setup/config
-- Set this to either "a" or "b", depending on where you want the menu for the lua to be.
local script_menu_location = "b"
--endregion

--region gs_api
--region Client
local client = {
	latency = client.latency,
	log = client.log,
	userid_to_entindex = client.userid_to_entindex,
	set_event_callback = client.set_event_callback,
	screen_size = client.screen_size,
	eye_position = client.eye_position,
	color_log = client.color_log,
	delay_call = client.delay_call,
	visible = client.visible,
	exec = client.exec,
	trace_line = client.trace_line,
	draw_hitboxes = client.draw_hitboxes,
	camera_angles = client.camera_angles,
	draw_debug_text = client.draw_debug_text,
	random_int = client.random_int,
	random_float = client.random_float,
	trace_bullet = client.trace_bullet,
	scale_damage = client.scale_damage,
	timestamp = client.timestamp,
	set_clantag = client.set_clantag,
	system_time = client.system_time,
	reload_active_scripts = client.reload_active_scripts
}
--endregion

--region Entity
local entity = {
	get_local_player = entity.get_local_player,
	is_enemy = entity.is_enemy,
	hitbox_position = entity.hitbox_position,
	get_player_name = entity.get_player_name,
	get_steam64 = entity.get_steam64,
	get_bounding_box = entity.get_bounding_box,
	get_all = entity.get_all,
	set_prop = entity.set_prop,
	is_alive = entity.is_alive,
	get_player_weapon = entity.get_player_weapon,
	get_prop = entity.get_prop,
	get_players = entity.get_players,
	get_classname = entity.get_classname,
	get_game_rules = entity.get_game_rules,
	get_player_resource = entity.get_prop,
	is_dormant = entity.is_dormant,
}
--endregion

--region Globals
local globals = {
	realtime = globals.realtime,
	absoluteframetime = globals.absoluteframetime,
	tickcount = globals.tickcount,
	curtime = globals.curtime,
	mapname = globals.mapname,
	tickinterval = globals.tickinterval,
	framecount = globals.framecount,
	frametime = globals.frametime,
	maxplayers = globals.maxplayers,
	lastoutgoingcommand = globals.lastoutgoingcommand,
}
--endregion

--region Ui
local ui = {
	new_slider = ui.new_slider,
	new_combobox = ui.new_combobox,
	reference = ui.reference,
	set_visible = ui.set_visible,
	is_menu_open = ui.is_menu_open,
	new_color_picker = ui.new_color_picker,
	set_callback = ui.set_callback,
	set = ui.set,
	new_checkbox = ui.new_checkbox,
	new_hotkey = ui.new_hotkey,
	new_button = ui.new_button,
	new_multiselect = ui.new_multiselect,
	get = ui.get,
	new_textbox = ui.new_textbox,
	mouse_position = ui.mouse_position
}
--endregion

--region Renderer
local renderer = {
	text = renderer.text,
	measure_text = renderer.measure_text,
	rectangle = renderer.rectangle,
	line = renderer.line,
	gradient = renderer.gradient,
	circle = renderer.circle,
	circle_outline = renderer.circle_outline,
	triangle = renderer.triangle,
	world_to_screen = renderer.world_to_screen,
	indicator = renderer.indicator,
	texture = renderer.texture,
	load_svg = renderer.load_svg
}
--endregion
--endregion

--region globals
local kd_reset_threshold = 1.0
--endregion

--region ui
if (script_menu_location ~= "a" and script_menu_location ~= "b") then
	script_menu_location = "a"
end

local ui_enable_plugin = ui.new_checkbox(
	"lua",
	script_menu_location,
	"Enable Auto RS"
)

local ui_kd_reset_threshold = ui.new_slider(
	"lua",
	script_menu_location,
	"|   KD Reset Threshold",
	1,
	20,
	10,
	true,
	nil,
	0.1
)

ui.set_visible(ui_kd_reset_threshold, false)

local function handle_enable_plugin()
	local menu_visible = ui.get(ui_enable_plugin)
	ui.set_visible(ui_kd_reset_threshold, menu_visible)
end

local function handle_kd_reset_threshold()
	kd_reset_threshold = ui.get(ui_kd_reset_threshold) / 10
end
--endregion

--region helpers
local function assess_kd()
	if (ui.get(ui_enable_plugin) == false) then
		return
	end

	local local_player = entity.get_local_player()

	local kills = entity.get_prop(entity.get_all("CCSPlayerResource")[1], "m_iKills", local_player)
	local deaths = entity.get_prop(entity.get_all("CCSPlayerResource")[1], "m_iDeaths", local_player)

	if (kills == nil or deaths == nil) then
		return
	end

	if (deaths == 0) then
		return
	end

	local kd = kills / deaths

	if (kd >= kd_reset_threshold) then
		return
	end

	client.exec("sm_rs; rs")
end
--endregion

--region on_player_death
local function on_player_death(player)
	if (ui.get(ui_enable_plugin) == false) then
		return
	end

	local local_player = entity.get_local_player()
	local victim = client.userid_to_entindex(player.userid)

	if (local_player ~= victim) then
		return
	end

	client.delay_call(1, assess_kd)
end
--endregion

--region hooks
client.set_event_callback('player_death', on_player_death)

ui.set_callback(ui_enable_plugin, handle_enable_plugin)
ui.set_callback(ui_kd_reset_threshold, handle_kd_reset_threshold)
--endregion

--region overrides
assess_kd()
--endregion
