--region gs_api
--region client
local client_latency, client_log, client_userid_to_entindex, client_set_event_callback, client_screen_size, client_eye_position, client_color_log, client_delay_call, client_visible, client_exec, client_trace_line, client_draw_hitboxes, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float, client_trace_bullet, client_scale_damage, client_timestamp, client_set_clan_tag, client_system_time, client_reload_active_scripts, client_update_player_list = client.latency, client.log, client.userid_to_entindex, client.set_event_callback, client.screen_size, client.eye_position, client.color_log, client.delay_call, client.visible, client.exec, client.trace_line, client.draw_hitboxes, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float, client.trace_bullet, client.scale_damage, client.timestamp, client.set_clan_tag, client.system_time, client.reload_active_scripts, client.update_player_list
--endregion

--region entity
local entity_get_local_player, entity_is_enemy, entity_hitbox_position, entity_get_player_name, entity_get_steam64, entity_get_bounding_box, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname, entity_get_game_rules, entity_get_player_resource, entity_is_dormant = entity.get_local_player, entity.is_enemy, entity.hitbox_position, entity.get_player_name, entity.get_steam64, entity.get_bounding_box, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname, entity.get_game_rules, entity.get_prop, entity.is_dormant
--endregion

--region globals
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers, globals_lastoutgoingcommand = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers, globals.lastoutgoingcommand
--endregion

--region ui
local ui_new_slider, ui_new_combobox, ui_reference, ui_set_visible, ui_is_menu_open, ui_new_color_picker, ui_set_callback, ui_set, ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_get, ui_new_textbox, ui_mouse_position = ui.new_slider, ui.new_combobox, ui.reference, ui.set_visible, ui.is_menu_open, ui.new_color_picker, ui.set_callback, ui.set, ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.get, ui.new_textbox, ui.mouse_position
--endregion

--region renderer
local renderer_text, renderer_measure_text, renderer_rectangle, renderer_line, renderer_gradient, renderer_circle, renderer_circle_outline, renderer_triangle, renderer_world_to_screen, renderer_indicator, renderer_texture, renderer_load_svg = renderer.text, renderer.measure_text, renderer.rectangle, renderer.line, renderer.gradient, renderer.circle, renderer.circle_outline, renderer.triangle, renderer.world_to_screen, renderer.indicator, renderer.texture, renderer.load_svg
--endregion

--region database
local database_read, database_write = database.read, database.write
--endregion
--endregion

--region dependencies
--region dependency: havoc_menu_1_0_0
-- v1.0.0

--region menu_assert
local function menu_assert(expression, level, message, ...)
	if (not expression) then
		error(string.format(message, ...), level)
	end
end
--endregion

--region menu_map
local menu_map = {
	rage = {"aimbot", "other"},
	aa = {"anti-aimbot angles", "fake lag", "other"},
	legit = {"weapon type", "aimbot", "triggerbot", "other"},
	visuals = {"player esp", "other esp", "colored models", "effects"},
	misc = {"miscellaneous", "settings", "lua", "other"},
	skins = {"weapon skin", "knife options", "glove options"},
	players = {"players", "adjustments"},
	lua = {"a", "b"}
}

for tab, containers in pairs(menu_map) do
	menu_map[tab] = {}

	for i=1, #containers do
		menu_map[tab][containers[i]] = true
	end
end
--endregion

--region menu_item
local menu_item = {}

local menu_item_mt = {
	__index = menu_item
}

function menu_item_mt.__call(item, ...)
	local args = {...}

	if (#args == 0) then
		return item:get()
	end

	local do_ui_set = {pcall(item.set, item, unpack(args))}

	menu_assert(do_ui_set[1], 4, do_ui_set[2])
end

function menu_item.new(element, tab, container, name, ...)
	local reference
	local is_menu_reference = false

	if ((type(element)) == "function") then
		local do_ui_new = { pcall(element, tab, container, name, ...)}

		menu_assert(do_ui_new[1], 4, "Cannot create menu item because: %s", do_ui_new[2])

		reference = do_ui_new[2]
	else
		reference = element
		is_menu_reference = true
	end

	return setmetatable(
		{
			tab = tab,
			container = container,
			name = name,
			reference = reference,
			visible = true,
			hidden_value = nil,
			children = {},
			ui_callback = nil,
			callbacks = {},
			is_menu_reference = is_menu_reference,
			getter = {
				callback = nil,
				data = nil
			},
			setter = {
				callback = nil,
				data = nil
			},
			parent_value_or_callback = nil
		},
		menu_item_mt
	)
end

function menu_item:set_hidden_value(value)
	self.hidden_value = value
end

function menu_item:set(...)
	local args = {...}

	if (self.setter.callback ~= nil) then
		args = self.setter.callback(unpack(args))
	end

	local do_ui_set = {pcall(ui.set, self.reference, unpack(args))}

	menu_assert(do_ui_set[1], 3, "Cannot set values of menu item because: %s", do_ui_set[2])
end

function menu_item:get()
	if (self.visible == false and self.hidden_value ~= nil) then
		return self.hidden_value
	end

	local get = {ui.get(self.reference)}

	if (self.getter.callback ~= nil) then
		return self.getter.callback(get)
	end

	return unpack(get)
end

function menu_item:set_setter_callback(callback, data)
	menu_assert(type(callback) == "function", 3, "Cannot set menu item setter callback: argument must be a function.")

	self.setter.callback = callback
	self.setter.data = data
end

function menu_item:set_getter_callback(callback, data)
	menu_assert(type(callback) == "function", 3, "Cannot set menu item getter callback: argument must be a function.")

	self.getter.callback = callback
	self.getter.data = data
end

function menu_item:add_children(children, value_or_callback)
	if (value_or_callback == nil) then
		value_or_callback = true
	end

	if (getmetatable(children) == menu_item_mt) then
		children = {children}
	end

	for _, child in pairs(children) do
		menu_assert(getmetatable(child) == menu_item_mt, 3, "Cannot add child to menu item: children must be menu item objects. Make sure you are not trying to parent a UI reference.")
		menu_assert(child.reference ~= self.reference, 3, "Cannot parent a menu item to iself.")

		child.parent_value_or_callback = value_or_callback
		self.children[child.reference] = child
	end

	menu_item._process_callbacks(self)
end

function menu_item:add_callback(callback)
	menu_assert(self.is_menu_reference == false, 3, "Cannot add callbacks to built-in menu items.")
	menu_assert(type(callback) == "function", 3, "Callbacks for menu items must be functions.")

	table.insert(self.callbacks, callback)

	menu_item._process_callbacks(self)
end

function menu_item._process_callbacks(item)
	local callback = function()
		for _, child in pairs(item.children) do
			local is_child_visible

			if (type(child.parent_value_or_callback) == "function") then
				is_child_visible = child.parent_value_or_callback()
			else
				is_child_visible = item:get() == child.parent_value_or_callback
			end

			local is_visible = (is_child_visible == true) and (item.visible == true)
			child.visible = is_visible

			ui.set_visible(child.reference, is_visible)

			if (child.ui_callback ~= nil) then
				child.ui_callback()
			end
		end

		for i = 1, #item.callbacks do
			item.callbacks[i]()
		end
	end

	ui.set_callback(item.reference, callback)
	item.ui_callback = callback

	callback()
end
--endregion

--region menu_manager
local menu_manager = {}

local menu_manager_mt = {
	__index = menu_manager
}

function menu_manager.new(tab, container)
	menu_manager._validate_tab_container(tab, container)

	return setmetatable(
		{
			tab = tab,
			container = container,
			children = {}
		},
		menu_manager_mt
	)
end

function menu_manager:parent_all_to(item, value_or_callback)
	local children = self.children

	children[item.reference] = nil

	item:add_children(children, value_or_callback)
end

function menu_manager.reference(tab, container, name)
	menu_manager._validate_tab_container(tab, container)

	local do_reference = {pcall(ui.reference, tab, container, name)}

	menu_assert(do_reference[1], 3, "Cannot reference Gamesense menu item because: %s", do_reference[2])

	local references = {select(2, unpack(do_reference))}
	local items = {}

	for i = 1, #references do
		table.insert(
			items,
			menu_item.new(
				references[i],
				tab,
				container,
				name
			)
		)
	end

	return unpack(items)
end

function menu_manager:checkbox(name)
	return self:_create_item(ui.new_checkbox, name)
end

function menu_manager:slider(name, min, max, default_or_options, show_tooltip, unit, scale, tooltips)
	if (type(default_or_options) == "table") then
		local options = default_or_options

		default_or_options = options.default
		show_tooltip = options.show_tooltip
		unit = options.unit
		scale = options.scale
		tooltips = options.tooltips
	end

	default_or_options = default_or_options or nil
	show_tooltip = show_tooltip or true
	unit = unit or nil
	scale = scale or 1
	tooltips = tooltips or nil

	menu_assert(type(min) == "number", 3, "Slider min value must be a number.")
	menu_assert(type(max) == "number", 3, "Slider max value must be a number.")
	menu_assert(min < max, 3, "Slider min value must be below the max value.")

	if (default_or_options ~= nil) then
		menu_assert(default_or_options >= min and default_or_options <= max, 3, "Slider default must be between min and max values.")
	end

	return self:_create_item(ui.new_slider, name, min, max, default_or_options, show_tooltip, unit, scale, tooltips)
end

function menu_manager:combobox(name, ...)
	local args = {...}

	if (type(args[1]) == "table") then
		args = args[1]
	end

	return self:_create_item(ui.new_combobox, name, args)
end

function menu_manager:multiselect(name, ...)
	local args = {...}

	if (type(args[1]) == "table") then
		args = args[1]
	end

	return self:_create_item(ui.new_multiselect, name, args)
end

function menu_manager:hotkey(name, inline)
	if (inline == nil) then
		inline = false
	end

	menu_assert(type(inline) == "boolean", 3, "Hotkey inline argument must be a boolean.")

	return self:_create_item(ui.new_hotkey, name, inline)
end

function menu_manager:button(name, callback)
	menu_assert(type(callback) == "function", 3, "Cannot set button callback because the callback argument must be a function.")

	return self:_create_item(ui.new_button, name, callback)
end

function menu_manager:color_picker(name, r, g, b, a)
	r = r or 255
	g = g or 255
	b = b or 255
	a = a or 255

	menu_assert(type(r) == "number" and r >= 0 and r <= 255, 3, "Cannot set color picker red channel value. It must be between 0 and 255.")
	menu_assert(type(g) == "number" and g >= 0 and g <= 255, 3, "Cannot set color picker green channel value. It must be between 0 and 255.")
	menu_assert(type(b) == "number" and b >= 0 and b <= 255, 3, "Cannot set color picker blue channel value. It must be between 0 and 255.")
	menu_assert(type(a) == "number" and a >= 0 and a <= 255, 3, "Cannot set color picker alpha channel value. It must be between 0 and 255.")

	return self:_create_item(ui.new_color_picker, name, r, g, b, a)
end

function menu_manager:textbox(name)
	return self:_create_item(ui.new_textbox, name)
end

function menu_manager:listbox(name, ...)
	local args = {...}

	if (type(args[1]) == "table") then
		args = args[1]
	end

	local item = self:_create_item(ui.new_listbox, name, args)

	item:set_getter_callback(
		function(get)
			return item.getter.data[get + 1]
		end,
		args
	)

	return item
end

function menu_manager:_create_item(element, name, ...)
	menu_assert(type(name) == "string" and name ~= "", 3, "Cannot create menu item: name must be a non-empty string.")

	local item = menu_item.new(element, self.tab, self.container, name, ...)
	self.children[item.reference] = item

	return item
end

function menu_manager._validate_tab_container(tab, container)
	menu_assert(type(tab) == "string" and tab ~= "", 4, "Cannot create menu manager: tab name must be a non-empty string.")
	menu_assert(type(container) == "string" and container ~= "", 4, "Cannot create menu manager: tab name must be a non-empty string.")

	tab = tab:lower()

	menu_assert(menu_map[tab] ~= nil, 4, "Cannot create menu manager: tab name does not exist.")
	menu_assert(menu_map[tab][container:lower()] ~= nil, 4, "Cannot create menu manager: container name does not exist.")
end
--endregion
--endregion
--endregion

--region color32
local color32 = {}

--- Convert an RGB value to an integer.
function color32.rgb_to_int(r, g, b)
	local r_byte = color32._decimal_to_byte(r)
	local g_byte = color32._decimal_to_byte(g)
	local b_byte = color32._decimal_to_byte(b)

	return color32._binary_to_decimal(b_byte .. g_byte .. r_byte)
end

--- Convert a decimal to a byte.
function color32._decimal_to_byte(integer)
	local bin = ''

	while integer ~= 0 do
		if integer % 2 == 0 then
			bin = '0' .. bin
		else
			bin = '1' .. bin
		end

		integer = math.floor(integer / 2)
	end

	local length = string.len(bin)
	local byte = ''

	for _ = 1, 8 - length do
		byte = byte .. '0'
	end

	return byte .. bin
end

--- Convert a binary number to decimal.
function color32._binary_to_decimal(binary)
	binary = string.reverse(binary)

	local sum = 0
	local num

	for i = 1, string.len(binary) do
		num = string.sub(binary, i,i) == "1" and 1 or 0
		sum = sum + num * math.pow(2, i-1)
	end

	return sum
end
--endregion

--region c_fog_controller
local c_fog_controller = {
	entity = entity_get_all("CFogController")[1],
	fog_color = 0,
	fog_start = 0,
	fog_end = 0,
	fog_max_density = 0
}
--endregion

--region menu
local menu = menu_manager.new("misc", "miscellaneous")

local enable_fog = menu:checkbox("Enable Havoc Fog")
local fog_color = menu:color_picker("Fog Color", 255, 255, 255, 255)
local fog_start = menu:slider("Fog Start", 0, 16384)
local fog_end = menu:slider("Fog End", 0, 16384)
local fog_max_density = menu:slider("Fog Max Density", 0, 100, {unit = "%"})

enable_fog:add_children({
	fog_color,
	fog_start,
	fog_end,
	fog_max_density
})

fog_start:add_callback(function()
	local fog_start_value = fog_start()
	local fog_end_value = fog_end()

	if (fog_start_value > fog_end_value) then
		fog_end(fog_start_value)
	end

	c_fog_controller.fog_start = fog_start_value

	entity_set_prop(c_fog_controller.entity, "m_fog.start", fog_start_value)
	entity_set_prop(entity_get_local_player(), "m_skybox3d.fog.start", fog_start_value)
end)

fog_end:add_callback(function()
	local fog_start_value = fog_start()
	local fog_end_value = fog_end()

	if (fog_end_value < fog_start_value) then
		fog_start(fog_end_value)
	end

	c_fog_controller.fog_end = fog_end_value

	entity_set_prop(c_fog_controller.entity, "m_fog.end", fog_end_value)
	entity_set_prop(entity_get_local_player(), "m_skybox3d.fog.end", fog_end_value)
end)

fog_max_density:add_callback(function()
	local fog_max_density_value = fog_max_density() / 100

	c_fog_controller.fog_max_density = fog_max_density_value

	entity_set_prop(c_fog_controller.entity, "m_fog.maxdensity", fog_max_density_value)
	entity_set_prop(entity_get_local_player(), "m_skybox3d.fog.maxdensity", fog_max_density_value)
end)

fog_color:add_callback(function()
	local r, g, b = fog_color()
	local color32 = color32.rgb_to_int(r, g, b)

	c_fog_controller.fog_color = color32

	entity_set_prop(c_fog_controller.entity, "m_fog.colorPrimary", color32)
	entity_set_prop(entity_get_local_player(), "m_skybox3d.fog.colorPrimary", color32)
end)
--endregion

--region hooks
client_set_event_callback("player_connect_full", function(data)
	local player = client_userid_to_entindex(data.userid)

	if (player == entity_get_local_player()) then
		c_fog_controller.entity = entity_get_all("CFogController")[1]
	end
end)

client_set_event_callback("paint", function()
	entity_set_prop(c_fog_controller.entity, "m_fog.enable", enable_fog() and 1 or 0)
	entity_set_prop(entity_get_local_player(), "m_skybox3d.fog.enable", enable_fog() and 1 or 0)

	entity_set_prop(c_fog_controller.entity, "m_fog.start", c_fog_controller.fog_start)
	entity_set_prop(entity_get_local_player(), "m_skybox3d.fog.start", c_fog_controller.fog_start)

	entity_set_prop(c_fog_controller.entity, "m_fog.end", c_fog_controller.fog_end)
	entity_set_prop(entity_get_local_player(), "m_skybox3d.fog.end", c_fog_controller.fog_end)

	entity_set_prop(c_fog_controller.entity, "m_fog.maxdensity", c_fog_controller.fog_max_density)
	entity_set_prop(entity_get_local_player(), "m_skybox3d.fog.maxdensity", c_fog_controller.fog_max_density)

	entity_set_prop(c_fog_controller.entity, "m_fog.colorPrimary", c_fog_controller.fog_color)
	entity_set_prop(entity_get_local_player(), "m_skybox3d.fog.colorPrimary", c_fog_controller.fog_color)
end)
--endregion
