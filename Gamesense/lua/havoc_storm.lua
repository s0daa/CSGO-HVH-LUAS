-->>START_INFO_BLOCK
-- project_name=Havoc Storm;
-- version=1.1.0;
-- authors=Kessie;
--<<END_INFO_BLOCK

--region setup/config
-- Set this to either "a" or "b", depending on where you want the menu for the lua to be.
local script_menu_location = "b"

if (script_menu_location ~= "a" and script_menu_location ~= "b") then
	script_menu_location = "a"
end
--endregion

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
--region dependency: havoc_color_1_2_1
--region helpers
--- Convert HSL to RGB.
---
--- Original function by EmmanuelOga:
--- https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
---
--- @param color Color
local function update_rgb_space(color)
	local r, g, b

	if (color.s == 0) then
		r, g, b = color.l, color.l, color.l
	else
		function hue_to_rgb(p, q, t)
			if t < 0   then t = t + 1 end
			if t > 1   then t = t - 1 end
			if t < 1/6 then return p + (q - p) * 6 * t end
			if t < 1/2 then return q end
			if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end

			return p
		end

		local q = 0

		if (color.l < 0.5) then
			q = color.l * (1 + color.s)
		else
			q = color.l + color.s - color.l * color.s
		end

		local p = 2 * color.l - q

		r = hue_to_rgb(p, q, color.h + 1/3)
		g = hue_to_rgb(p, q, color.h)
		b = hue_to_rgb(p, q, color.h - 1/3)
	end

	color.r = r * 255
	color.g = g * 255
	color.b = b * 255
end

--- Convert RGB to HSL.
---
--- Original function by EmmanuelOga:
--- https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
---
--- @param color Color
local function update_hsl_space(color)
	local r, g, b = color.r / 255, color.g / 255, color.b / 255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, l

	l = (max + min) / 2

	if (max == min) then
		h, s = 0, 0
	else
		local d = max - min

		if (l > 0.5) then
			s = d / (2 - max - min)
		else
			s = d / (max + min)
		end

		if (max == r) then
			h = (g - b) / d

			if (g < b) then
				h = h + 6
			end
		elseif (max == g) then
			h = (b - r) / d + 2
		elseif (max == b) then
			h = (r - g) / d + 4
		end

		h = h / 6
	end

	color.h, color.s, color.l = h, s, l or 255
end

--- Validate the RGB+A space and clamp errors.
---
--- @param color Color
local function validate_rgba(color)
	color.r = math.min(255, math.max(0, color.r))
	color.g = math.min(255, math.max(0, color.g))
	color.b = math.min(255, math.max(0, color.b))
	color.a = math.min(255, math.max(0, color.a))
end

--- Validate the HSL+A space and clamp errors.
---
--- @param color Color
local function validate_hsla(color)
	color.h = math.min(1, math.max(0, color.h))
	color.s = math.min(1, math.max(0, color.s))
	color.l = math.min(1, math.max(0, color.l))

	color.a = math.min(1, math.max(0, color.a))
end
--endregion

--region class.color
local color = {}

--- Color metatable.
local color_mt = {
	__index = color,
	__call = function(tbl, ...) return color.new_rgba(...) end
}

--- Create new color object in using the RGB+A space.
---
--- @param r int
--- @param g int
--- @param b int
--- @param a int
--- @return Color
function color.new_rgba(r, g, b, a)
	if (a == nil) then
		a = 255
	end

	local object = setmetatable({r = r, g = g, b = b, a = a, h = 0, s = 0, l = 0}, color_mt)

	validate_rgba(object)
	update_hsl_space(object)

	return object
end

--- Create new color object in using the HSL+A space.
---
--- @param h int
--- @param s int
--- @param l int
--- @param a int
--- @return Color
function color.new_hsla(h, s, l, a)
	if (a == nil) then
		a = 255
	end

	h = h % 1

	local object = setmetatable({r = 0, g = 0, b = 0, a = a, h = h, s = s, l = l}, color_mt)

	validate_hsla(object)
	update_rgb_space(object)

	return object
end

--- Create a color from a UI reference.
---
--- @param ui_reference ui_reference
--- @return Color
--- @since 1.1.0-release
function color.new_from_ui_color_picker(ui_reference)
	local r, g, b, a = ui_get(ui_reference)

	return color.new_rgba(r, g, b, a)
end

--- Create a color from another color.
---
--- @param color Color
--- @return Color
--- @since 1.2.0-release
function color.new_from_other_color(color)
	local r, g, b, a = color:unpack_rgba()

	return color.new_rgba(r, g, b, a)
end

--- Overwrite current color using RGB+A space.
---
--- @param self Color
--- @param r int
--- @param g int
--- @param b int
--- @param a int
function color.set_rgba(self, r, g, b, a)
	if (a == nil) then
		a = self.a
	end

	self.r, self.g, self.b, self.a = r, g, b, a

	validate_rgba(self)
	update_hsl_space(self)
end

--- Overwrite current color using HSL+A space.
---
--- @param self Color
--- @param h int
--- @param s int
--- @param l int
--- @param a int
function color.set_hsla(self, h, s, l, a)
	if (a == nil) then
		a = self.a
	end

	h = h % 1

	self.h, self.s, self.l, self.a = h, s, l, a

	validate_hsla(self)
	update_rgb_space(self)
end

--- Overwrite current color using a UI reference.
---
--- @param self Color
--- @param ui_reference ui_reference
--- @since 1.1.0-release
function color.set_from_ui_color_picker(self, ui_reference)
	local r, g, b, a = ui_get(ui_reference)

	self:set_rgba(r, g, b, a)
end

--- Overwrite current color using another color.
---
--- @param self Color
--- @param color Color
--- @since 1.2.0-release
function color.set_from_other_color(self, color)
	local r, g, b, a = color:unpack_rgba()

	self:set_rgba(r, g, b, a)
end

--- Unpack RGB+A space.
---
--- @param self Color
function color.unpack_rgba(self)
	return self.r, self.g, self.b, self.a
end

--- Unpack HSL+A space.
---
--- @param self Color
function color.unpack_hsla(self)
	return self.h, self.s, self.l, self.a
end

--- Unpack RGB, HSL, and A space.
---
--- @param self Color
--- @since 1.1.0-release
function color.unpack_all(self)
	return self.r, self.g, self.b, self.h, self.s, self.l, self.a
end

--- Selects a color contrast.
---
--- Determines whether a colour is most visible against white or black, and returns white for 0, and 1 for black.
---
--- @param self Color
--- @return int
function color.select_contrast(self, tolerance)
	tolerance = tolerance or 150

	local contrast = self.r * 0.213 + self.g * 0.715 + self.b * 0.072

	if (contrast < tolerance) then
		return 0
	end

	return 1
end

--- Generates a color contrast.
---
--- Determines whether a colour is most visible against white or black, and returns a new color object for the one chosen.
---
--- @param self Color
--- @return Color
function color.generate_contrast(self, tolerance)
	local contrast = self:select_contrast(tolerance)

	if (contrast == 0) then
		return color.new_rgba(255, 255, 255)
	end

	return color.new_rgba(0, 0, 0)
end

--- Set the red channel value of the color.
---
--- @param self Color
--- @param r int
--- @since 1.2.0-release
function color.set_red(self, r)
	self.r = math.min(255, math.max(0, r))

	update_hsl_space(self)
end

--- Set the green channel value of the color.
---
--- @param self Color
--- @param g int
--- @since 1.2.0-release
function color.set_green(self, g)
	self.g = math.min(255, math.max(0, g))

	update_hsl_space(self)
end

--- Set the blue channel value of the color.
---
--- @param self Color
--- @param b int
--- @since 1.2.0-release
function color.set_blue(self, b)
	self.b = math.min(255, math.max(0, b))

	update_hsl_space(self)
end

--- Set the hue of the color.
---
--- @param self Color
--- @param h float
function color.set_hue(self, h)
	self.h = h % 1

	update_rgb_space(self)
end

--- Shift the hue of the color by a given amount.
---
--- Use negative numbers go to down the spectrum.
---
--- @param self Color
--- @param amount float
function color.shift_hue(self, amount)
	self.h = (self.h + amount) % 1

	update_rgb_space(self)
end

--- Shift the hue of the color by a given amount, but do not loop the spectrum.
---
--- Use negative numbers go to down the spectrum.
---
--- @param self Color
--- @param amount float
function color.shift_hue_clamped(self, amount)
	self.h = math.min(1, math.max(0, self.h + amount))

	update_rgb_space(self)
end

--- Shift the hue of the color by a given amount, but keep within an upper and lower hue bound.
---
--- Use negative numbers go to down the spectrum.
---
--- @param self Color
--- @param amount float
--- @param lower_bound float
--- @param upper_bound float
function color.shift_hue_within(self, amount, lower_bound, upper_bound)
	self.h = math.min(upper_bound, math.max(lower_bound, self.h + amount))

	update_rgb_space(self)
end

--- Returns true if hue is below or equal to a given hue.
---
--- @param self Color
--- @param h float
function color.hue_is_below(self, h)
	return self.h <= h
end

--- Returns true if hue is above or equal to a given hue.
---
--- @param self Color
--- @param h float
function color.hue_is_above(self, h)
	return self.h >= h
end

--- Returns true if hue is betwen two given hues.
---
--- @param self Color
--- @param lower_bound float
--- @param upper_bound float
function color.hue_is_between(self, lower_bound, upper_bound)
	return self.h >= lower_bound and self.h <= upper_bound
end

--- Returns true if the hue is within a given tolerance at a specific hue value. False if not.
---
--- @param self Color
--- @param h float
--- @param tolerance float
--- @since 1.2.0-release
function color.hue_is_within_tolerance(self, h, tolerance)
	return h <= self.h + tolerance and h >= self.h - tolerance
end

--- Set the saturation of the color.
---
--- @param self Color
--- @param s float
function color.set_saturation(self, s)
	self.s = math.min(1, math.max(0, s))

	update_rgb_space(self)
end

--- Shift the saturation of the color by a given amount.
---
--- Use negative numbers to decrease saturation.
---
--- @param self Color
--- @param amount float
function color.shift_saturation(self, amount)
	self.s = math.min(1, math.max(0, self.s + amount))

	update_rgb_space(self)
end

--- Shift the saturation of the color by a given amount, but keep within an upper and lower saturation bound.
---
--- Use negative numbers to decrease saturation.
---
--- @param self Color
--- @param amount float
function color.shift_saturation_within(self, amount, lower_bound, upper_bound)
	self.s = math.min(upper_bound, math.max(lower_bound, self.s + amount))

	update_rgb_space(self)
end

--- Returns true if saturation is below or equal to a given saturation.
---
--- @param self Color
--- @param s float
function color.saturation_is_below(self, s)
	return self.s <= s
end

--- Returns true if saturation is above or equal to a given saturation.
---
--- @param self Color
--- @param s float
function color.saturation_is_above(self, s)
	return self.s >= s
end

--- Returns true if saturation is betwen two given saturations.
---
--- @param self Color
--- @param lower_bound float
--- @param upper_bound float
function color.saturation_is_between(self, lower_bound, upper_bound)
	return self.s >= lower_bound and self.s <= upper_bound
end

--- Returns true if the saturation is within a given tolerance at a specific hue value. False if not.
---
--- @param self Color
--- @param s float
--- @param tolerance float
--- @since 1.2.0-release
function color.saturation_is_within_tolerance(self, s, tolerance)
	return s <= self.s + tolerance and s >= self.s - tolerance
end

--- Set the lightness of the color.
---
--- @param self Color
--- @param l float
function color.set_lightness(self, l)
	self.l = math.min(1, math.max(0, l))

	update_rgb_space(self)
end

--- Shift the lightness of the color within a given amount.
---
--- Use negative numbers to decrease lightness.
---
--- @param self Color
--- @param amount float
function color.shift_lightness(self, amount)
	self.l = math.min(1, math.max(0, self.l + amount))

	update_rgb_space(self)
end

--- Shift the lightness of the color by a given amount, but keep within an upper and lower lightness bound.
-----
----- Use negative numbers to decrease lightness.
---
--- @param self Color
--- @param amount float
function color.shift_lightness_within(self, amount, lower_bound, upper_bound)
	self.l = math.min(upper_bound, math.max(lower_bound, self.l + amount))

	update_rgb_space(self)
end

--- Returns true if lightness is below or equal to a given lightness.
---
--- @param self Color
--- @param l float
function color.lightness_is_below(self, l)
	return self.l <= l
end

--- Returns true if lightness is above or equal to a given lightness.
---
--- @param self Color
--- @param l float
function color.lightness_is_above(self, l)
	return self.l >= l
end

--- Returns true if lightness is betwen two given lightnesses.
---
--- @param self Color
--- @param lower_bound float
--- @param upper_bound float
function color.lightness_is_between(self, lower_bound, upper_bound)
	return self.l >= lower_bound and self.l <= upper_bound
end

--- Returns true if the lightness is within a given tolerance at a specific hue value. False if not.
---
--- @param self Color
--- @param l float
--- @param tolerance float
--- @since 1.2.0-release
function color.lightness_is_within_tolerance(self, l, tolerance)
	return l <= self.l + tolerance and l >= self.l - tolerance
end

--- Sets the alpha of the color.
---
--- @param self Color
--- @param alpha int
--- @since 1.1.0-release
function color.set_alpha(self, alpha)
	self.a = alpha

	validate_rgba(self)
end

--- Returns true if the color is truely invisible (0 alpha).
---
--- @param self Color
function color.is_invisible(self)
	return self.a == 0
end

--- Returns true if the color is invisible to within a given tolerance (0-255 alpha).
---
--- @param self Color
--- @param tolerance int
function color.is_invisible_within(self, tolerance)
	return self.a <= 0 + tolerance
end

--- Returns true if the color is truely visible (255 alpha).
---
--- @param self Color
function color.is_visible(self)
	return self.a == 255
end

--- Returns true if the color is visible to within a given tolerance (0-255 alpha).
---
--- @param self Color
--- @param tolerance int
function color.is_visible_within(self, tolerance)
	return self.a >= 255 - tolerance
end

--- Increase the alpha of the color by a given amount.
---
--- @param self Color
--- @param amount int
function color.fade_in(self, amount)
	if (self.a == 255) then
		return
	end

	self.a = self.a + amount

	if (self.a > 255) then
		self.a = 255
	end
end

--- Decrease the alpha of the color by a given amount.
---
--- @param self Color
--- @param amount int
function color.fade_out(self, amount)
	if (self.a == 0) then
		return
	end

	self.a = self.a - amount

	if (self.a < 0) then
		self.a = 0
	end
end
--endregion
--endregion

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

--region dependency: havoc_timer_3_0_0
local timer = {}
local timer_mt = {__index = timer}

function timer.new_curtime()
	return setmetatable(
		{
			current_time = globals_curtime,
			clock_started_at = nil,
			clock_paused_at = nil,
			is_using_ticks = false
		},
		timer_mt
	)
end

function timer.new_realtime()
	return setmetatable(
		{
			current_time = globals_realtime,
			clock_started_at = nil,
			clock_paused_at = nil,
			is_using_ticks = false
		},
		timer_mt
	)
end

function timer.new_tickcount()
	return setmetatable(
		{
			current_time = globals_tickcount,
			clock_started_at = nil,
			clock_paused_at = nil,
			is_using_ticks = true
		},
		timer_mt
	)
end

function timer.get_elapsed_time(self)
	if (self:has_started() == false) then
		return 0
	end

	if (self.clock_paused_at ~= nil) then
		return self.clock_paused_at - self.clock_started_at
	end

	return self.current_time() - self.clock_started_at
end

function timer.get_elapsed_time_and_stop(self)
	local elapsed_time = self:get_elapsed_time()

	self:stop()

	return elapsed_time
end

function timer.start(self)
	if (self:has_started() == true) then
		return
	end

	self.clock_started_at = self.current_time()
end

function timer.stop(self)
	self.clock_paused_at = nil
	self.clock_started_at = nil
end

function timer.restart(self)
	self:stop()
	self:start()
end

function timer.pause(self)
	if (self:has_started() == false) then
		return
	end

	self.clock_paused_at = self.current_time()
end

function timer.unpause(self)
	if (self:has_started() == false) then
		return
	end

	if (self:is_paused() == false) then
		return
	end

	local clock_paused_for = self.current_time() - self.clock_paused_at

	self.clock_started_at = self.clock_started_at + clock_paused_for
	self.clock_paused_at = nil
end

function timer.toggle_pause(self)
	if (self:is_paused() == true) then
		self:unpause()
	else
		self:pause()
	end
end

function timer.is_paused(self)
	return self.clock_paused_at ~= nil
end

function timer.has_started(self)
	return self.clock_started_at ~= nil
end
--endregion
--endregion

--region menu
local menu = menu_manager.new("lua", script_menu_location)
local enable_storm = menu:checkbox("Enable Havoc Storm")
local cover_detection_accuracy = menu:combobox("Indoor Detection Accuracy", "High Accuracy", "Low Accuracy")
local enable_thunder_fx = menu:checkbox("|   Enable Thunder FX")
local show_lightning = menu:checkbox("|      Show Lightning")
local enable_rain_fx = menu:checkbox("|   Enable Rain FX")
local rain_color = menu:color_picker("|      Rain Color", 200, 200, 255, 25)
local max_droplets = menu:slider("|      Maximum Rain Droplets", 50, 200, {default = 150})
local droplet_spawn_speed = menu:slider("|      Rain Droplet Spawn Delay", 1, 100, {default = 5})
--endregion

--region helpers
local sound = {}

function sound.playvol(sound_name, volume)
	client_exec(string.format("playvol %s %s", sound_name, volume))
end

function sound.play(sound_name)
	client_exec(string.format("play %s", sound_name))
end
--endregion

--region hvc_rain_droplet
local hvc_droplet = {}
local hvc_droplet_mt = { __index = hvc_droplet }

function hvc_droplet.new(id, x, distance)
	local object = setmetatable(
		{
			id = id,
			x = x,
			y = 0,
			distance = distance,
			width,
			height,
			render_width,
			render_height,
			speed
		},
		hvc_droplet_mt
	)

	object:setup()

	return object
end

function hvc_droplet:setup()
	self.width = self.distance / 2
	self.height = self.distance * 3
	self.speed = self.distance * 1.5

	self.render_width = self.width
	self.render_height = self.height
end
--endregion

--region hvc_rain_droplet
local hvc_storm_manager = {}
local hvc_storm_manager_mt = { __index = hvc_storm_manager }

function hvc_storm_manager.new()
	local object = setmetatable(
		{
			animation = {
				frametime_mod = 400,
				droplet = {
					color = {
						r = 0,
						g = 0,
						b = 0,
						a = 0
					}
				}
			},
			droplets = {},
			screen = {
				x = 0,
				y = 0
			},
			droplet_total_count = 0,
			droplet_current_count = 0,
			droplet_settings = {
				spawn_speed = 0.005,
				spawn_timer = timer.new_realtime(),
				max_droplets = 100
			},
			wind = {
				timer = timer.new_realtime(),
				delay = 0.1,
				increment = 0.001,
				in_reverse = false,
				current_reverse_state = false,
				max_speed = 1,
				speed_base = 0,
				speed = 0
			},
			cover_detection = {
				can_spawn_droplets = true,
				last_can_spawn_droplets = false,
				offsets = {
					current = {},
					accuracies = {
						["High Accuracy"] = "high_accuracy",
						["Low Accuracy"] = "low_accuracy"
					},
					low_accuracy = {
						total = 5,
						heights = {
							400,
							400,
							800,
							400,
							400
						},
						x = {
							-200,
							-100,
							0,
							100,
							200
						},
						y = {
							175,
							-175,
							0,
							175,
							-175
						}
					},
					high_accuracy = {
						total = 7,
						heights = {
							400,
							400,
							400,
							600,
							400,
							400,
							400
						},
						x = {
							200,
							-200,
							-100,
							0,
							100,
							200,
							-200
						},
						y = {
							0,
							175,
							-175,
							0,
							175,
							-175,
							0
						}
					}
				}
			},
			sounds = {
				rain = {
					timer = timer.new_realtime(),
					current,
					outdoors = "havoc_rain/rain_outdoors.wav",
					indoors = "havoc_rain/rain_indoors.wav"
				},
				thunder = {
					timer = timer.new_realtime(),
					outdoors = {
						"ambient/playonce/weather/thunder4.wav",
						"ambient/playonce/weather/thunder5.wav",
						"ambient/playonce/weather/thunder6.wav"
					},
					indoors = {
						"ambient/playonce/weather/thunder_distant_01.wav",
						"ambient/playonce/weather/thunder_distant_02.wav",
						"ambient/playonce/weather/thunder_distant_06.wav"
					}
				}
			},
			thunder = {
				color = color.new_rgba(255, 255, 255, 0),
				delay = 5,
				lightning_alpha = 200
			}
		},
		hvc_storm_manager_mt
	)

	object:setup()

	return object
end

function hvc_storm_manager:setup()
	local x, y = client_screen_size()

	self.screen.x = x
	self.screen.y = y
	self.droplet_settings.spawn_timer:start()
	self.wind.timer:start()
	self.sounds.rain.timer:start()
	self.sounds.thunder.timer:start()
end

function hvc_storm_manager:process()
	self:is_under_cover()
	self:wind_fx()
	self:rain_fx()
	self:thunder_fx()
end

function hvc_storm_manager:wind_fx()
	self.wind.speed = self.wind.speed_base * client_random_float(0.5, 1.5)

	if (self.wind.timer:get_elapsed_time() > self.wind.delay) then
		if (self.wind.speed_base >= self.wind.max_speed) then
			self.wind.in_reverse = true
		elseif (self.wind.speed_base <= 0 - self.wind.max_speed) then
			self.wind.in_reverse = false
		end

		if (self.wind.in_reverse == true) then
			self.wind.speed_base = self.wind.speed_base - (self.wind.increment + client_random_float(0, 0.005))
		else
			self.wind.speed_base = self.wind.speed_base + (self.wind.increment + client_random_float(0, 0.005))
		end

		if (self.wind.in_reverse ~= self.wind.current_reverse_state) then
			self.wind.delay = client_random_float(0.045, 0.2)
			self.wind.current_reverse_state = self.wind.in_reverse
		end

		self.wind.timer:restart()
	end
end

function hvc_storm_manager:thunder_fx()
	if (enable_thunder_fx() == false) then
		return
	end

	local a = 0

	if (self.sounds.thunder.timer:get_elapsed_time() > self.thunder.delay) then
		if (self.cover_detection.can_spawn_droplets == true) then
			client_delay_call(client_random_int(2, 4), function() sound.playvol(self.sounds.thunder.outdoors[client_random_int(1, 3)], 1) end)

			if (show_lightning() == true) then
				a = self.thunder.lightning_alpha
			end
		else
			client_delay_call(client_random_int(2, 4), function() sound.playvol(self.sounds.thunder.indoors[client_random_int(1, 3)], 1) end)
		end

		self.sounds.thunder.timer:restart()

		self.thunder.delay = client_random_int(5, 90)
	end

	if (show_lightning() == true) then
		renderer_rectangle(
			0, 0,
			self.screen.x, self.screen.y,
			self.thunder.color.r, self.thunder.color.g, self.thunder.color.b, a
		)
	end
end

function hvc_storm_manager:rain_fx()
	if (enable_rain_fx() == false) then
		return
	end

	self:rain_visuals()
	self:rain_sound()
end

function hvc_storm_manager:rain_sound()
	if (self.cover_detection.can_spawn_droplets ~= self.cover_detection.last_can_spawn_droplets) then
		if (self.cover_detection.can_spawn_droplets == true) then
			self.sounds.rain.current = self.sounds.rain.outdoors
		else
			self.sounds.rain.current = self.sounds.rain.indoors
		end

		self.cover_detection.last_can_spawn_droplets = self.cover_detection.can_spawn_droplets

		sound.play(self.sounds.rain.current)
	end

	if (self.sounds.rain.timer:get_elapsed_time() > 5) then
		sound.play(self.sounds.rain.current)
		self.sounds.rain.timer:restart()
	end
end

function hvc_storm_manager:rain_visuals()
	local frametime = globals_frametime()
	local camera_pitch, _ = math.abs(client_camera_angles())

	camera_pitch = 0 - (camera_pitch - 95) / 95

	for _, droplet in pairs(self.droplets) do
		self:translate_droplet(droplet, frametime, camera_pitch)
		self:render_droplet(droplet)
	end

	if (self.droplet_settings.spawn_timer:get_elapsed_time() < self.droplet_settings.spawn_speed) then
		return
	end

	self.droplet_settings.spawn_timer:restart()

	if (self.droplet_current_count >= self.droplet_settings.max_droplets) then
		return
	end

	if (self.cover_detection.can_spawn_droplets == false) then
		return
	end

	self:add_droplet()
end

function hvc_storm_manager:add_droplet()
	local id = self.droplet_total_count + 1
	local droplet = hvc_droplet.new(id, client_random_int(1, self.screen.x), client_random_int(1, 6))

	self.droplet_total_count = id
	self.droplet_current_count = self.droplet_current_count + 1

	self.droplets[id] = droplet
end

function hvc_storm_manager:translate_droplet(droplet, frametime, camera_pitch_mod)
	droplet.render_height = droplet.height * camera_pitch_mod + 1
	droplet.y = droplet.y + frametime * (droplet.speed / camera_pitch_mod) * self.animation.frametime_mod
	droplet.x = droplet.x + frametime * (self.wind.speed) * self.animation.frametime_mod

	if (droplet.y > self.screen.y) then
		self.droplets[droplet.id] = nil
		self.droplet_current_count = self.droplet_current_count - 1
	end
end

function hvc_storm_manager:render_droplet(droplet)
	renderer_rectangle(
		droplet.x,
		droplet.y,
		droplet.render_width,
		droplet.render_height,
		self.animation.droplet.color.r,
		self.animation.droplet.color.g,
		self.animation.droplet.color.b,
		self.animation.droplet.color.a
	)
end

function hvc_storm_manager:is_under_cover()
	local local_player = entity_get_local_player()
	local observer_mode = entity_get_prop(local_player, "m_iObserverMode")
	local player

	if (observer_mode == 4 or observer_mode == 5) then
		player = entity_get_prop(local_player, "m_hObserverTarget")
	else
		player = entity_get_local_player()
	end

	local origin_x, origin_y, origin_z = entity_get_prop(player, "m_vecOrigin")

	if (origin_x == nil or origin_y == nil or origin_z == nil) then
		return
	end

	local sky_x = origin_x
	local sky_y = origin_y
	local sky_z = origin_z
	local cover_detections = 0

	origin_z = origin_z + 64

	for i = 1, self.cover_detection.offsets.current.total do
		local x_offset = self.cover_detection.offsets.current.x[i]
		local y_offset = self.cover_detection.offsets.current.y[i]
		local z_offset = self.cover_detection.offsets.current.heights[i]

		local offset_sky_x = sky_x + x_offset
		local offset_sky_y = sky_y + y_offset
		local offset_sky_z = sky_z + z_offset
		local trace = client_trace_line(player, origin_x, origin_y, origin_z, offset_sky_x, offset_sky_y, offset_sky_z)

		--local origin_w2s_x, origin_w2s_y = renderer_world_to_screen(origin_x, origin_y, origin_z)
		--local sky_w2s_x, sky_w2s_y = renderer_world_to_screen(offset_sky_x, offset_sky_y, offset_sky_z)

		--local r = 200
		--local g = 200
		--local b = 200

		if (trace < 1) then
			cover_detections = cover_detections + 1

			--r = 200
			--g = 60
			--b = 60
		end

		--renderer_line(origin_w2s_x, origin_w2s_y, sky_w2s_x, sky_w2s_y, r, g, b, 255)

		if (cover_detections == self.cover_detection.offsets.current.total) then
			self.cover_detection.can_spawn_droplets = false
		else
			self.cover_detection.can_spawn_droplets = true
		end
	end
end
--endregion

--region globals
local storm_manager = hvc_storm_manager.new()
--endregion

--region on_paint
client_set_event_callback("paint", function()
	if (enable_storm() == false) then
		return
	end

	storm_manager:process()
end)
--endregion

--region on_round_start
client_set_event_callback("round_start", function()
	if (enable_storm() == false) then
		return
	end

	if (enable_rain_fx() == false) then
		return
	end

	client_delay_call(0.01, function() sound.play(storm_manager.sounds.rain.current) end)
end)
--endregion

--region menu_setup
--region defaults
enable_storm(true)
enable_thunder_fx(true)
show_lightning(true)
enable_rain_fx(true)
--endregion

--region children
enable_storm:add_children({
	cover_detection_accuracy,
	enable_thunder_fx,
	enable_rain_fx,
})

enable_thunder_fx:add_children({
	show_lightning
})

enable_rain_fx:add_children({
	rain_color,
	max_droplets,
	droplet_spawn_speed
})
--endregion

--region callbacks
cover_detection_accuracy:add_callback(function()
	local current = storm_manager.cover_detection.offsets.accuracies[cover_detection_accuracy()]

	storm_manager.cover_detection.offsets.current = storm_manager.cover_detection.offsets[current]
end)

rain_color:add_callback(function()
	local r, g, b, a = rain_color()

	storm_manager.animation.droplet.color.r = r
	storm_manager.animation.droplet.color.g = g
	storm_manager.animation.droplet.color.b = b
	storm_manager.animation.droplet.color.a = a
end)

max_droplets:add_callback(function()
	storm_manager.droplet_settings.max_droplets = max_droplets()
end)

droplet_spawn_speed:add_callback(function()
	storm_manager.droplet_settings.spawn_speed = droplet_spawn_speed() * 0.001
end)
--endregion
--endregion

