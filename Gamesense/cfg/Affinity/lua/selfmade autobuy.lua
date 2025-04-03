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
local client_delay_call = client.delay_call
local client_visible = client.visible

local ui_new_checkbox = ui.new_checkbox
local ui_new_slider = ui.new_slider
local ui_new_button = ui.new_button
local ui_new_combobox = ui.new_combobox
local ui_new_multiselect = ui.new_multiselect
local ui_new_hotkey = ui.new_hotkey
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

local table_concat = table.concat
local table_insert = table.insert
local to_number = tonumber
local math_floor = math.floor
local table_remove = table.remove
local string_format = string.format

local delay = 0.03

local primary_weapons = {
	{name='-', command=""},
	{name='AWP', command="buy awp; "},
	{name='Auto-Sniper', command="buy scar20; buy g3sg1; "},
	{name='Scout', command="buy ssg08; "},
	{name='Shootgun', command="buy mag7; buy sawedoff "}
}

local secondary_weapons = {
	{name='-', command=""},
	{name='R8 Revolver / Deagle', command="buy deagle; "},
	{name='Dual Berettas', command="buy elite; "},
	{name='FN57 / Tec9 / CZ75-Auto', command="buy fn57; "}
}

local gear_weapons = {
	{name='Kevlar', command="buy vest; "},
	{name='Helmet', command="buy vesthelm; "},
	{name='Defuse Kit', command="buy defuser; "},
	{name='Grenade', command="buy hegrenade; "},
	{name='Molotov', command="buy incgrenade; "},
	{name='Smoke', command="buy smokegrenade; "},
	{name='Flashbang (x2)', command="buy flashbang; "},
	{name='Taser', command="buy taser; "},
}

local function get_names(table)
	local names = {}
	for i=1, #table do
		table_insert(names, table[i]["name"])
	end
	return names
end

local function get_command(table, name)
	for i=1, #table do
		if table[i]["name"] == name then
			return table[i]["command"]
		end
	end
end

local buybot_enabled = ui_new_checkbox("MISC", "Miscellaneous", "Auto-Buy")
local buybot_primary = ui_new_combobox("MISC", "Miscellaneous", "Auto-Buy: Primary", get_names(primary_weapons))
local buybot_pistol = ui_new_combobox("MISC", "Miscellaneous", "Auto-Buy: Secondary", get_names(secondary_weapons))
local buybot_gear = ui_new_multiselect("MISC", "Miscellaneous", "Auto-Buy: Gear", get_names(gear_weapons))

local function on_enabled_change()
	local enabled = ui_get(buybot_enabled)
	ui_set_visible(buybot_primary, enabled)
	ui_set_visible(buybot_pistol, enabled)
	ui_set_visible(buybot_gear, enabled)
end
on_enabled_change()
ui.set_callback(buybot_enabled, on_enabled_change)

local function run_buybot(e)
	local userid = e.userid
	if userid ~= nil then
		if client_userid_to_entindex(userid) ~= entity_get_local_player() then
			return
		end
	end

	if not ui_get(buybot_enabled) then
		return
	end

	local primary = ui_get(buybot_primary)
	local pistol = ui_get(buybot_pistol)
	local gear = ui_get(buybot_gear)

	local commands = {}

	table_insert(commands, get_command(primary_weapons, primary))
	table_insert(commands, get_command(secondary_weapons, pistol))
	
	for i=1, #gear do
		table_insert(commands, get_command(gear_weapons, gear[i]))
	end

	table_insert(commands, "use weapon_knife;")

	local command = table_concat(commands, "")
	client_console_cmd(command)
	--client_delay_call(delay, client_console_cmd, command)

end

--ui_new_button("MISC", "Miscellaneous", "Auto-Buy Test", run_buybot)

--client_set_event_callback("round_prestart", run_buybot)
client_set_event_callback("player_spawn", run_buybot)