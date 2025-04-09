-- downloaded from dsc.gg/southwestcfgs

--region setup/config
local script_menu_location = "b"
--endregion

--region dependencies
--region dependency: havoc_color
-- version 1.2.0

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
		local function hue_to_rgb(p, q, t)
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
local Color = {}

--- Color metatable.
local color_mt = {
	__index = Color,
	__call = function(tbl, ...) return Color.new_rgba(...) end
}

--- Create new color object in using the RGB+A space.
---
--- @param r int
--- @param g int
--- @param b int
--- @param a int
--- @return Color
function Color.new_rgba(r, g, b, a)
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
--- @param self Color
--- @param h int
--- @param s int
--- @param l int
--- @param a int
--- @return Color
function Color.new_hsla(h, s, l, a)
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
---  1.1.0-release
function Color.new_from_ui_color_picker(ui_reference)
	local r, g, b, a = ui.get(ui_reference)

	return Color.new_rgba(r, g, b, a)
end

--- Create a color from another color.
---
--- @param color Color
--- @return Color
---  1.2.0-release
function Color.new_from_other_color(color)
	local r, g, b, a = color:unpack_rgba()

	return Color.new_rgba(r, g, b, a)
end

--- Overwrite current color using RGB+A space.
---
--- @param self Color
--- @param r int
--- @param g int
--- @param b int
--- @param a int
function Color.set_rgba(self, r, g, b, a)
	if (a == nil) then
		a = 255
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
function Color.set_hsla(self, h, s, l, a)
	if (a == nil) then
		a = 255
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
---  1.1.0-release
function Color.set_from_ui_color_picker(self, ui_reference)
	local r, g, b, a = ui.get(ui_reference)

	self:set_rgba(r, g, b, a)
end

--- Overwrite current color using another color.
---
--- @param self Color
--- @param color Color
---  1.2.0-release
function Color.set_from_other_color(self, color)
	local r, g, b, a = color:unpack_rgba()

	self:set_rgba(r, g, b, a)
end

--- Unpack RGB+A space.
---
--- @param self Color
function Color.unpack_rgba(self)
	return self.r, self.g, self.b, self.a
end

--- Unpack HSL+A space.
---
--- @param self Color
function Color.unpack_hsla(self)
	return self.h, self.s, self.l, self.a
end

--- Unpack RGB, HSL, and A space.
---
--- @param self Color
---  1.1.0-release
function Color.unpack_all(self)
	return self.r, self.g, self.b, self.h, self.s, self.l, self.a
end

--- Selects a color contrast.
---
--- Determines whether a colour is most visible against white or black, and returns white for 0, and 1 for black.
---
--- @param self Color
--- @return int
function Color.select_contrast(self, tolerance)
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
function Color.generate_contrast(self, tolerance)
	local contrast = self:select_contrast(tolerance)

	if (contrast == 0) then
		return Color.new_rgba(255, 255, 255)
	end

	return Color.new_rgba(0, 0, 0)
end

--- Set the red channel value of the color.
---
--- @param self Color
--- @param r int
---  1.2.0-release
function Color.set_red(self, r)
	self.r = math.min(255, math.max(0, r))

	update_hsl_space(self)
end

--- Set the green channel value of the color.
---
--- @param self Color
--- @param g int
---  1.2.0-release
function Color.set_green(self, g)
	self.g = math.min(255, math.max(0, g))

	update_hsl_space(self)
end

--- Set the blue channel value of the color.
---
--- @param self Color
--- @param b int
---  1.2.0-release
function Color.set_blue(self, b)
	self.b = math.min(255, math.max(0, b))

	update_hsl_space(self)
end

--- Set the hue of the color.
---
--- @param self Color
--- @param h float
function Color.set_hue(self, h)
	self.h = h % 1

	update_rgb_space(self)
end

--- Shift the hue of the color by a given amount.
---
--- Use negative numbers go to down the spectrum.
---
--- @param self Color
--- @param amount float
function Color.shift_hue(self, amount)
	self.h = (self.h + amount) % 1

	update_rgb_space(self)
end

--- Shift the hue of the color by a given amount, but do not loop the spectrum.
---
--- Use negative numbers go to down the spectrum.
---
--- @param self Color
--- @param amount float
function Color.shift_hue_clamped(self, amount)
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
function Color.shift_hue_within(self, amount, lower_bound, upper_bound)
	self.h = math.min(upper_bound, math.max(lower_bound, self.h + amount))

	update_rgb_space(self)
end

--- Returns true if hue is below or equal to a given hue.
---
--- @param self Color
--- @param h float
function Color.hue_is_below(self, h)
	return self.h <= h
end

--- Returns true if hue is above or equal to a given hue.
---
--- @param self Color
--- @param h float
function Color.hue_is_above(self, h)
	return self.h >= h
end

--- Returns true if hue is betwen two given hues.
---
--- @param self Color
--- @param lower_bound float
--- @param upper_bound float
function Color.hue_is_between(self, lower_bound, upper_bound)
	return self.h >= lower_bound and self.h <= upper_bound
end

--- Returns true if the hue is within a given tolerance at a specific hue value. False if not.
---
--- @param self Color
--- @param h float
--- @param tolerance float
---  1.2.0-release
function Color.hue_is_within_tolerance(self, h, tolerance)
	return h <= self.h + tolerance and h >= self.h - tolerance
end

--- Set the saturation of the color.
---
--- @param self Color
--- @param s float
function Color.set_saturation(self, s)
	self.s = math.min(1, math.max(0, s))

	update_rgb_space(self)
end

--- Shift the saturation of the color by a given amount.
---
--- Use negative numbers to decrease saturation.
---
--- @param self Color
--- @param amount float
function Color.shift_saturation(self, amount)
	self.s = math.min(1, math.max(0, self.s + amount))

	update_rgb_space(self)
end

--- Shift the saturation of the color by a given amount, but keep within an upper and lower saturation bound.
---
--- Use negative numbers to decrease saturation.
---
--- @param self Color
--- @param amount float
function Color.shift_saturation_within(self, amount, lower_bound, upper_bound)
	self.s = math.min(upper_bound, math.max(lower_bound, self.s + amount))

	update_rgb_space(self)
end

--- Returns true if saturation is below or equal to a given saturation.
---
--- @param self Color
--- @param s float
function Color.saturation_is_below(self, s)
	return self.s <= s
end

--- Returns true if saturation is above or equal to a given saturation.
---
--- @param self Color
--- @param s float
function Color.saturation_is_above(self, s)
	return self.s >= s
end

--- Returns true if saturation is betwen two given saturations.
---
--- @param self Color
--- @param lower_bound float
--- @param upper_bound float
function Color.saturation_is_between(self, lower_bound, upper_bound)
	return self.s >= lower_bound and self.s <= upper_bound
end

--- Returns true if the saturation is within a given tolerance at a specific hue value. False if not.
---
--- @param self Color
--- @param s float
--- @param tolerance float
---  1.2.0-release
function Color.saturation_is_within_tolerance(self, s, tolerance)
	return s <= self.s + tolerance and s >= self.s - tolerance
end

--- Set the lightness of the color.
---
--- @param self Color
--- @param l float
function Color.set_lightness(self, l)
	self.l = math.min(1, math.max(0, l))

	update_rgb_space(self)
end

--- Shift the lightness of the color within a given amount.
---
--- Use negative numbers to decrease lightness.
---
--- @param self Color
--- @param amount float
function Color.shift_lightness(self, amount)
	self.l = math.min(1, math.max(0, self.l + amount))

	update_rgb_space(self)
end

--- Shift the lightness of the color by a given amount, but keep within an upper and lower lightness bound.
-----
----- Use negative numbers to decrease lightness.
---
--- @param self Color
--- @param amount float
function Color.shift_lightness_within(self, amount, lower_bound, upper_bound)
	self.l = math.min(upper_bound, math.max(lower_bound, self.l + amount))

	update_rgb_space(self)
end

--- Returns true if lightness is below or equal to a given lightness.
---
--- @param self Color
--- @param l float
function Color.lightness_is_below(self, l)
	return self.l <= l
end

--- Returns true if lightness is above or equal to a given lightness.
---
--- @param self Color
--- @param l float
function Color.lightness_is_above(self, l)
	return self.l >= l
end

--- Returns true if lightness is betwen two given lightnesses.
---
--- @param self Color
--- @param lower_bound float
--- @param upper_bound float
function Color.lightness_is_between(self, lower_bound, upper_bound)
	return self.l >= lower_bound and self.l <= upper_bound
end

--- Returns true if the lightness is within a given tolerance at a specific hue value. False if not.
---
--- @param self Color
--- @param l float
--- @param tolerance float
---  1.2.0-release
function Color.lightness_is_within_tolerance(self, l, tolerance)
	return l <= self.l + tolerance and l >= self.l - tolerance
end

--- Sets the alpha of the color.
---
--- @param self Color
--- @param alpha int
---  1.1.0-release
function Color.set_alpha(self, alpha)
	self.a = alpha

	validate_rgba(self)
end

--- Returns true if the color is truely invisible (0 alpha).
---
--- @param self Color
function Color.is_invisible(self)
	return self.a == 0
end

--- Returns true if the color is invisible to within a given tolerance (0-255 alpha).
---
--- @param self Color
--- @param tolerance int
function Color.is_invisible_within(self, tolerance)
	return self.a <= 0 + tolerance
end

--- Returns true if the color is truely visible (255 alpha).
---
--- @param self Color
function Color.is_visible(self)
	return self.a == 255
end

--- Returns true if the color is visible to within a given tolerance (0-255 alpha).
---
--- @param self Color
--- @param tolerance int
function Color.is_visible_within(self, tolerance)
	return self.a >= 255 - tolerance
end

--- Increase the alpha of the color by a given amount.
---
--- @param self Color
--- @param amount int
function Color.fade_in(self, amount)
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
function Color.fade_out(self, amount)
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

--region dependency: havoc_timer
--region class.timer
--- @field seconds float
--- @field tick_count int
--- @field current_tick int
--- @field tickrate int
--- @field is_counting boolean
local Timer = {}

--- Shader metatable.
local Timer_mt = {
	__index = Timer,
	__call = function(tbl, ...) return Timer.new(...) end
}

--- Create a new timer.
---
--- @param use_curtime boolean if true then the timer will use globals.curtime. If false, the timer will use globals.realtime.
function Timer.new(use_curtime)
	local object = setmetatable(
		{
			current_time = use_curtime and globals.curtime or globals.realtime,
			clock_started_at = nil,
			clock_paused_at = nil,
		},
		Timer_mt
	)

	return object
end

--- Get the elapsed time of the timer.
---
--- @param self Timer
function Timer.get_elapsed_time(self)
	if (self:has_started() == false) then
		return 0
	end

	if (self.clock_paused_at ~= nil) then
		return self.clock_paused_at - self.clock_started_at
	end

	return self.current_time() - self.clock_started_at
end

--- Get the elapsed time of the timer and then stop the timer.
---
--- @param self Timer
function Timer.get_elapsed_time_and_stop(self)
	local elapsed_time = self:get_elapsed_time()

	self:stop()

	return elapsed_time
end

--- Start the timer.
---
--- @param self Timer
function Timer.start(self)
	if (self:has_started() == true) then
		return
	end

	self.clock_started_at = self.current_time()
end

--- Stop the timer. Resetting the elapsed time to 0.
---
--- @param self Timer
function Timer.stop(self)
	self.clock_paused_at = nil
	self.clock_started_at = nil
end

--- Stop the timer, and then start it again immediately.
---
--- @param self Timer
function Timer.restart(self)
	self:stop()
	self:start()
end

--- Pause the timer. Will not reset the elapsed time. Unpause using `Timer.unpause`.
---
--- @param self Timer
function Timer.pause(self)
	if (self:has_started() == false) then
		return
	end

	self.clock_paused_at = self.current_time()
end

--- Unpause the timer.
---
--- @param self Timer
function Timer.unpause(self)
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

--- Toggle between paused and unpaused.
---
--- @param self Timer
function Timer.toggle_pause(self)
	if (self:is_paused() == true) then
		self:unpause()
	else
		self:pause()
	end
end

--- Returns true if the timer is currently paused. False if not.
---
--- @param self Timer
function Timer.is_paused(self)
	return self.clock_paused_at ~= nil
end

--- Returns true if the timer has been started (regardless of pause state). Returns false if the timer has not been started.
---
--- @param self Timer
function Timer.has_started(self)
	return self.clock_started_at ~= nil
end
--endregion
--endregion

--region dependency: havoc_menu
-- v0.0.1
--region exception
local function _assert(value, message)
	if not value then
		error(string.format("[MenuBuilder] %s", message), 3)
	end
end

local exception = {
	menu_item = {
		parent_must_be_menu_item_type = "Cannot set parent on menu item. Parent must be a menu_item object. Make sure you are not using a UI reference.",
		child_must_be_menu_item_type = "Cannot add a child to menu item. Child must be a menu_item object. Make sure you are not using a UI reference.",
		gamesense_reference_invalid = "Cannot reference a Gamesense menu item: the menu item does not exist.",
		cannot_set_callbacks_on_gamesense_reference = "Cannot create children of, parent, or add callbacks to built-in menu references.",
		set_invalid_arguments = "Cannot set menu item values: '%s'"
	},
	menu_builder = {
		general = {
			category_invalid = "Cannot create a menu item with a tab that is not a string, or is empty.",
			tab_invalid = "Cannot create a menu item with a container that is not a string, or is empty.",
			name_invalid = "Cannot create a menu item with a name that is not a string, or is empty."
		},
		slider = {
			min_type_invalid = "Cannot create a slider: the minimum value must be a number.",
			max_type_invalid = "Cannot create a slider: the maximum value must be a number.",
			min_out_of_bounds = "Cannot create a slider: the minimum value must be lower than the maximum",
			default_type_invalid = "Cannot create a slider: the default value must be a number",
			default_out_of_bounds = "Cannot create a slider: the default value must be between the minimum and maximum values.",
			show_tooltip_type_invalid = "Cannot create a slider: the show_tooltip value must be boolean",
			unit_invalid_type = "Cannot create a slider: the unit must be a string.",
			unit_out_of_bounds = "Cannot create a slider: the unit must be 1 or 2 characters in length.",
			scale_invalid_type = "Cannot create a slider: the scale must be a number.",
			tooltips_invalid_type = "Cannot create a slider: the tooltips must be a table."
		},
		combobox = {
			item_invalid_type = "Cannot create a combobox: menu items must be strings or numbers."
		},
		multiselect = {
			item_invalid_type = "Cannot create a multiselect: menu items must be strings or numbers."
		},
		hotkey = {
			inline_invalid_type = "Cannot create a hotkey: the inline parameter is not a boolean value."
		},
		button = {
			callback_invalid_type = "Cannot create a button: the callback value given is not a function."
		},
		color_picker = {
			red_invalid_type = "Cannot create a color picker: its red channel value is not a number.",
			red_out_of_bounds= "Cannot create a color picker: its red channel value is not between 0-255.",
			green_invalid_type = "Cannot create a color picker: its green channel value is not a number.",
			green_out_of_bounds= "Cannot create a color picker: its green channel value is not between 0-255.",
			blue_invalid_type = "Cannot create a color picker: its blue channel value is not a number.",
			blue_out_of_bounds= "Cannot create a color picker: its blue channel value is not between 0-255.",
			alpha_invalid_type = "Cannot create a color picker: its alpha channel value is not a number.",
			alpha_out_of_bounds= "Cannot create a color picker: its alpha channel value is not between 0-255.",
		}
	}
}
--endregion

--region menu_item_child
local menu_item_child = {}

local menu_item_child_meta = {
	__index = menu_item_child
}

function menu_item_child.new(item, value, is_callback)
	local properties = {
		item = item,
		value = value,
		is_callback = is_callback
	}

	local object = setmetatable(
		properties,
		menu_item_child_meta
	)

	return object
end
--endregion

--region menu_item
local menu_item = {}

local menu_item_meta = {
	__index = menu_item
}

function menu_item_meta.__call(...)
	local args = {...}

	if (args[2] == nil) then
		return args[1]:get()
	else
		local attempt_set = {pcall(ui.set, args[1].reference, select(2, unpack(args)))}

		_assert(attempt_set[1] == true, string.format(exception.menu_item.set_invalid_arguments, attempt_set[2]))
	end
end

function menu_item.new(element, tab, container, name, ...)
	local reference
	local is_gamesense_reference = false

	if (type(element) == "function") then
		reference = element(tab, container, name, ...)
	else
		reference = element
		is_gamesense_reference = true
	end

	local properties = {
		tab = tab,
		container = container,
		name = name,
		reference = reference,
		visible = true,
		invisible_value,
		children = {},
		ui_callback,
		callbacks = {},
		is_gamesense_reference = is_gamesense_reference
	}

	local object = setmetatable(
		properties,
		menu_item_meta
	)

	return object
end

function menu_item.set_hidden_value(self, value)
	self.invisible_value = value
end

function menu_item.set(self, ...)
	local values = {...}

	local attempt_set = {pcall(ui.set, self.reference, unpack(values))}

	_assert(attempt_set[1] == true, string.format(exception.menu_item.set_invalid_arguments, attempt_set[2]))
end

function menu_item.get(self)
	if (self.visible == false and self.invisible_value ~= nil) then
		return self.invisible_value
	end

	return ui.get(self.reference)
end

function menu_item.add_children(self, children, value_or_callback)
	local is_callback = type(value_or_callback) == "function"

	value_or_callback = value_or_callback or true

	if (getmetatable(children) == menu_item_meta) then
		self.children[children.reference] = menu_item_child.new(children, value_or_callback, is_callback)
	else
		for i = 1, #children do
			local child = children[i]

			_assert(getmetatable(child) == menu_item_meta, exception.menu_item.child_must_be_menu_item_type)

			self.children[child.reference] = menu_item_child.new(child, value_or_callback, is_callback)
		end
	end

	menu_item._process_callbacks(self)
end

function menu_item.set_parent(self, item, value)
	_assert(getmetatable(item) == menu_item_meta, exception.menu_item.parent_must_be_menu_item_type)

	local is_callback = type(value) == "function"

	value = value or true
	item.children[self.reference] = menu_item_child.new(self, value, is_callback)

	menu_item._process_callbacks(item)
end

function menu_item.add_callback(self, callback)
	_assert(self.is_gamesense_reference == false, exception.menu_item.cannot_set_callbacks_on_gamesense_reference)

	table.insert(self.callbacks, callback)

	menu_item._process_callbacks(self)
end

function menu_item._process_callbacks(item)
	local callback = function()
		for _, child in pairs(item.children) do
			local child_visibility

			if (item.is_callback == true) then
				child_visibility = child.value()
			else
				child_visibility = item:get() == child.value
			end

			local is_visible = (child_visibility == true) and (item.visible == true)

			ui.set_visible(child.item.reference, is_visible)

			child.item.visible = is_visible

			if (child.item.ui_callback ~= nil) then
				child.item.ui_callback()
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

--region menu_builder
local menu_builder = {}

local menu_builder_meta = {
	__index = menu_builder
}

function menu_builder.new(tab, container)
	_assert(type(tab) == "string" and tab ~= "", exception.menu_builder.general.category_invalid)
	_assert(type(container) == "string" and container ~= "", exception.menu_builder.general.tab_invalid)

	local properties = {
		tab = tab,
		container = container,
		children = {}
	}

	local object = setmetatable(
		properties,
		menu_builder_meta
	)

	return object
end

function menu_builder.checkbox(self, name)
	_assert(type(name) == "string" and name ~= "", exception.menu_builder.general.name_invalid)

	local item = menu_item.new(ui.new_checkbox, self.tab, self.container, name)

	self.children[item.reference] = item

	return item
end

function menu_builder.slider(self, name, min, max, default, show_tooltip, unit, scale, tooltips)
	_assert(type(name) == "string" and name ~= "", exception.menu_builder.general.name_invalid)
	_assert(type(min) == "number", exception.menu_builder.slider.min_type_invalid)
	_assert(type(max) == "number", exception.menu_builder.slider.max_type_invalid)
	_assert(min < max, exception.menu_builder.slider.min_out_of_bounds)

	_assert(type(default) == "number" or type(default) == "nil", exception.menu_builder.slider.default_type_invalid)

	if (default ~= nil) then
		_assert(default >= min and default <= max, exception.menu_builder.slider.default_out_of_bounds)
	end

	_assert(type(show_tooltip) == "boolean" or type(show_tooltip) == "nil", exception.menu_builder.slider.show_tooltip_type_invalid)

	_assert(type(unit) == "string" or type(unit) == "nil", exception.menu_builder.slider.unit_invalid_type)

	if (unit ~= nil) then
		_assert(string.len(unit) > 0 and string.len(unit) < 3, exception.menu_builder.slider.unit_out_of_bounds)
	end

	_assert(type(scale) == "number" or type(scale) == "nil", exception.menu_builder.slider.scale_invalid_type)
	_assert(type(tooltips) == "table" or type(tooltips) == "nil", exception.menu_builder.slider.tooltips_invalid_type)

	default = default or nil
	show_tooltip = show_tooltip or true
	unit = unit or nil
	scale = scale or 1
	tooltips = tooltips or nil

	local item = menu_item.new(ui.new_slider, self.tab, self.container, name, min, max, default, show_tooltip, unit, scale, tooltips)

	self.children[item.reference] = item

	return item
end

function menu_builder.combobox(self, name, ...)
	_assert(type(name) == "string" and name ~= "", exception.menu_builder.general.name_invalid)

	local elements = {...}

	for _, element in pairs(elements) do
		_assert(type(element) == "string" or type(element) == "number", exception.menu_builder.combobox.item_invalid_type)
	end

	local item = menu_item.new(ui.new_combobox, self.tab, self.container, name, ...)

	self.children[item.reference] = item

	return item
end

function menu_builder.multiselect(self, name, ...)
	_assert(type(name) == "string" and name ~= "", exception.menu_builder.general.name_invalid)

	local elements = {...}

	for _, element in pairs(elements) do
		_assert(type(element) == "string" or type(element) == "number", exception.menu_builder.multiselect.item_invalid_type)
	end

	local item = menu_item.new(ui.new_multiselect, self.tab, self.container, name, ...)

	self.children[item.reference] = item

	return item
end

function menu_builder.hotkey(self, name, inline)
	inline = inline or false

	_assert(type(name) == "string" and name ~= "", exception.menu_builder.general.name_invalid)
	_assert(type(inline) == "boolean", exception.menu_builder.hotkey.inline_invalid_type)

	local item = menu_item.new(ui.new_hotkey, self.tab, self.container, name, inline)

	self.children[item.reference] = item

	return item
end

function menu_builder.button(self, name, callback)
	_assert(type(name) == "string" and name ~= "", exception.menu_builder.general.name_invalid)
	_assert(type(callback) == "function", exception.menu_builder.button.callback_invalid_type)

	local item = menu_item.new(ui.new_button, self.tab, self.container, name, callback)

	self.children[item.reference] = item

	return item
end

function menu_builder.color_picker(self, name, r, g, b, a)
	r = r or 255
	g = g or 255
	b = b or 255
	a = a or 255

	_assert(type(name) == "string" and name ~= "", exception.menu_builder.general.name_invalid)
	_assert(type(r) == "number", exception.menu_builder.color_picker.red_invalid_type)
	_assert(type(g) == "number", exception.menu_builder.color_picker.green_invalid_type)
	_assert(type(b) == "number", exception.menu_builder.color_picker.blue_invalid_type)
	_assert(type(a) == "number", exception.menu_builder.color_picker.alpha_invalid_type)
	_assert(r > 0 and r < 256, exception.menu_builder.color_picker.red_out_of_bounds)
	_assert(g > 0 and g < 256, exception.menu_builder.color_picker.green_out_of_bounds)
	_assert(b > 0 and b < 256, exception.menu_builder.color_picker.blue_out_of_bounds)
	_assert(a > 0 and a < 256, exception.menu_builder.color_picker.alpha_out_of_bounds)

	local item = menu_item.new(ui.new_color_picker, self.tab, self.container, name, r, g, b, a)

	self.children[item.reference] = item

	return item
end

function menu_builder.textbox(self, name)
	_assert(type(name) == "string" and name ~= "", exception.menu_builder.general.name_invalid)

	local item = menu_item.new(ui.new_textbox, self.tab, self.container, name)

	self.children[item.reference] = item

	return item
end

function menu_builder.reference(tab, container, name)
	local attempt_reference = {pcall(ui.reference, tab, container, name)}

	_assert(attempt_reference[1] == true, exception.menu_item.gamesense_reference_invalid)

	local references = {select(2, unpack(attempt_reference))}
	local items = {}

	for i = 1, #references do
		local reference = references[i]
		local item = menu_item.new(reference, tab, container, name)

		table.insert(items, item)
	end

	return unpack(items)
end
--endregion
--endregion
--endregion

--region globals
-- User set warning distance.
local enemy_player_threat_user_distance = false

-- Fatal warning distance.
local enemy_player_threat_fatal_distance = false

-- Zeus warning sound timer.
local zeus_warning_sound_timer = Timer.new()

-- Start timer.
zeus_warning_sound_timer:start()

-- Zeus indicator color.
local zeus_warning_indicator_color = Color.new_hsla(0, 0.8, 0.5, 255)

-- Zeus indicator border color.
local zeus_warning_indicator_color_border = Color.new_hsla(0, 0.8, 0.5, 255)

-- Alpha of the indicators. Used for flashing indicators.
local indicator_alpha = 255
--endregion

--region ui
if (script_menu_location ~= "a" and script_menu_location ~= "b") then
	script_menu_location = "a"
end

-- Create the menu builder. Sets tab and container for all menu items.
local menu = menu_builder.new("lua", "b")

-- Create our menu items.
local ui_checkbox_enable_plugin = menu:checkbox("Enable Havoc Zeus Warning")

local ui_color_warning_icon = menu:color_picker("|   Warning Indicator Color", zeus_warning_indicator_color:unpack_rgba())
local ui_slider_standing_warning_distance = menu:slider("|   Standing Warning Distance", 20, 60, 30, true, "ft")
local ui_slider_moving_warning_distance = menu:slider("|   Running/Bhop Warning Distance", 20, 60, 60, true, "ft")
local ui_checkbox_flashing_indicator = menu:checkbox("|   Enable Flashing Indicator")
local ui_checkbox_enable_indicator = menu:checkbox("|   Enable Indicator Icons")
local ui_checkbox_enable_sound = menu:checkbox("|   Enable Warning Sound")
local ui_slider_sound_volume = menu:slider("|      Warning Sound Volume", 0, 100, 100, true, "%")

-- Parent the main menu items to the enable_plugin checkbox.
-- These items will only be visible if enable_plugin is checked.
ui_checkbox_enable_plugin:add_children({
	ui_checkbox_flashing_indicator,
	ui_slider_standing_warning_distance,
	ui_slider_moving_warning_distance,
	ui_checkbox_enable_indicator,
	ui_checkbox_enable_sound
})

-- Parent the volume slider to enable_sound checkbox.
-- Slider will only be visible if both enable_plugin and enable_sound are visible and checked
-- because enable_sound is a child of enable_plugin.
ui_checkbox_enable_sound:add_children(ui_slider_sound_volume)

-- Set these items' values by default. Overriden by configs.
ui_checkbox_flashing_indicator(true)
ui_checkbox_enable_indicator(true)
ui_checkbox_enable_sound(true)

-- Add UI callbacks to menu items. Can add multiple callbacks per item.
ui_checkbox_flashing_indicator:add_callback(function()
	if (ui_checkbox_flashing_indicator() == false) then
		indicator_alpha = 255
	end
end)

ui_color_warning_icon:add_callback(function()
	local r, g, b, a = ui_color_warning_icon()

	zeus_warning_indicator_color:set_rgba(r, g, b, a)
	zeus_warning_indicator_color_border:set_rgba(r, g, b, a)

	local shift_direction = zeus_warning_indicator_color:select_contrast()

	if (shift_direction == 0) then
		shift_direction = 0.5
	else
		shift_direction = -0.5
	end

	zeus_warning_indicator_color_border:shift_lightness(shift_direction)
end)
--endregion

--region helpers
--- Play a sound from the CS:GO sound folder.
---  1.0.0-beta
local function play_sound(sound_name)
	client.exec(string.format("playvol %s%s %s", "havoc_zeus_warning/", sound_name, ui_slider_sound_volume() / 100))
end

--- Calculate unit distance between two world coordinates.
--- @param x2 float
--- @param y2 float
--- @param z2 float
--- @param x1 float
--- @param y1 float
--- @param z1 float
--- @return float
---  1.0.0-beta
local function distance_ft(x2, y2, z2, x1, y1, z1)
	return math.sqrt(
		math.pow(x2 - x1, 2) +
		math.pow(y2 - y1, 2) +
		math.pow(z2 - z1, 2)
	) * 0.0254 / 0.3048
end

--- Calculate the speed of an entity.
--- @param x float
--- @param y float
--- @param z float
---  1.0.0-beta
local function speed(x, y, z)
	return math.sqrt(
		math.pow(x, 2) +
		math.pow(y, 2) +
		math.pow(z, 2)
	)
end
--endregion

--region paint
--- Zeus warning (sound).
---  1.0.0-beta
local function warning_sound()
	if (ui_checkbox_enable_sound() == false) then
		return
	end

	-- Play warning sound.
	if (enemy_player_threat_fatal_distance == true and zeus_warning_sound_timer:get_elapsed_time() > 0.65) then
		zeus_warning_sound_timer:restart()
		play_sound("zeus_warning_fatal.wav")
	elseif (enemy_player_threat_user_distance == true and zeus_warning_sound_timer:get_elapsed_time() > 1.1) then
		zeus_warning_sound_timer:restart()
		play_sound("zeus_warning.wav")
	end
end

--- Zeus warning (indicator).
---  1.0.0-beta
local function warning_indicator(player, is_individual_in_fatal_distance)
	if (ui_checkbox_enable_indicator() == false) then
		return
	end

	local box_top_x, box_top_y, box_bottom_x, _, box_alpha = entity.get_bounding_box(player)

	if (box_top_x == nil or box_top_y == nil or box_alpha == 0) then
		return
	end

	local center_x = box_top_x / 2 + box_bottom_x / 2

	local r, g, b, _ = zeus_warning_indicator_color:unpack_rgba()
	local rb, gb, bb, _ = zeus_warning_indicator_color_border:unpack_rgba()
	local y_offset = -40
	local indicator_text = "!"
	local indicator_border_width = 19

	if (is_individual_in_fatal_distance == true) then
		indicator_border_width = 20
		indicator_text = "F"
	end

	renderer.circle(center_x, box_top_y + y_offset, rb, gb, bb, indicator_alpha, indicator_border_width, 0, 1)
	renderer.circle(center_x, box_top_y + y_offset, r, g, b, indicator_alpha, 18, 0, 1)
	renderer.text(center_x, box_top_y + y_offset, rb, gb, bb, indicator_alpha, "c+", 0, indicator_text)
end

--- On paint callback.
---  1.0.0-beta
local function on_paint()
	enemy_player_threat_user_distance = false
	enemy_player_threat_fatal_distance = false

	if (ui_checkbox_enable_plugin() == false) then
		return
	end

	local local_player = entity.get_local_player()

	if (entity.is_alive(local_player) == false) then
		return
	end

	local lp_x, lp_y, lp_z = entity.get_prop(local_player, "m_vecOrigin")
	local active_players = entity.get_players(true)

	for i = 1, #active_players do
		local enemy_player_is_threat = true
		local enemy_player = active_players[i]
		local ep_x, ep_y, ep_z = entity.get_prop(enemy_player, "m_vecOrigin")
		local eps_x, eps_y, eps_z = entity.get_prop(enemy_player, "m_vecVelocity")
		local distance_to_enemy = distance_ft(ep_x, ep_y, ep_z, lp_x, lp_y, lp_z)
		local warning_distance
		local enemy_speed = speed(eps_x, eps_y, eps_z)
		local weapon = entity.get_classname(entity.get_player_weapon(enemy_player))

		if (weapon ~= "CWeaponTaser") then
			enemy_player_is_threat = false
		end

		if (enemy_speed > 200) then
			warning_distance = ui_slider_moving_warning_distance()
		else
			warning_distance = ui_slider_standing_warning_distance()
		end

		local is_individual_in_fatal_distance = false

		if (distance_to_enemy < 14 and enemy_player_is_threat == true) then
			enemy_player_threat_fatal_distance = true
			is_individual_in_fatal_distance = true
		elseif (distance_to_enemy > 14 and distance_to_enemy <= warning_distance and enemy_player_is_threat == true) then
			enemy_player_threat_user_distance = true
		else
			enemy_player_is_threat = false
		end

		if (ui_checkbox_flashing_indicator() == true) then
			indicator_alpha = zeus_warning_sound_timer:get_elapsed_time() % 1 % 255 * 512
		end

		if (enemy_player_is_threat == true) then
			warning_indicator(enemy_player, is_individual_in_fatal_distance)
		end
	end

	warning_sound()
end
--endregion

--region player_spawn
--- On player spawn callback.
---  1.0.0-beta
local function on_player_spawn()
	zeus_warning_sound_timer:restart()
end
--endregion

--region hooks
client.set_event_callback('paint', on_paint)
client.set_event_callback('player_spawn', on_player_spawn)
--endregion
