--- @param: expression: boolean
--- @param: level: number
--- @param: message: string
--- @vararg: any
--- @return: void
local function assert(expression, level, message, ...)
	if (not expression) then
		error((message):format(...), level)
	end
end

--- @info: Sorted pairs iteration
--- @param: t: table
--- @param: order: function
--- @return: any
local function spairs(t, order)
    -- Collect the keys
    local keys = {}

    for k in pairs(t) do keys[#keys+1] = k end
    -- If order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0

    -- Return the iterator function.
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

--- @info: JSON Library
local json = require("JSON")

--- @info: Base64 Library
local base64 = require "Base64"
--- @endregion

--- @region: enumerations
local e_conditions = {
    SHARED = 1,
    STANDING = 2,
    RUNNING = 3,
    WALKING = 4,
    AIR = 5,
    CROUCH = 6
}

local e_jiter_mode = {
    NONE = 1,
    STATIC = 2,
    RANDOM = 3
}

local e_jitter_type = {
    OFFSET = 2,
    CENTER = 3
}

local e_menu = {
    PITCH = menu.find("antiaim", "main", "angles", "pitch"),
    YAW_BASE = menu.find("antiaim", "main", "angles", "yaw base"),
    YAW_ADD = menu.find("antiaim", "main", "angles", "yaw add"),

    ROTATE = menu.find("antiaim", "main", "angles", "rotate"),
    ROTATE_RANGE = menu.find("antiaim", "main", "angles", "rotate range"),
    ROTATE_SPEED = menu.find("antiaim", "main", "angles", "rotate speed"),

    JITTER_MODE = menu.find("antiaim", "main", "angles", "jitter mode"),
    JITTER_TYPE = menu.find("antiaim", "main", "angles", "jitter type"),
    JITTER_ADD = menu.find("antiaim", "main", "angles", "jitter add"),

    BODY_LEAN = menu.find("antiaim", "main", "angles", "body lean"),
    BODY_LEAN_VALUE = menu.find("antiaim", "main", "angles", "body lean value"),
    BODY_LEAN_JITTER = menu.find("antiaim", "main", "angles", "body lean jitter"),

    SIDE_STAND = menu.find("antiaim", "main", "desync","side#stand"),
    LEFT_AMOUNT_STAND = menu.find("antiaim", "main", "desync","left amount#stand"),
    RIGHT_AMOUNT_STAND = menu.find("antiaim", "main", "desync","right amount#stand"),

    SIDE_MOVE = menu.find("antiaim", "main", "desync","side#move"),
    LEFT_AMOUNT_MOVE = menu.find("antiaim", "main", "desync","left amount#move"),
    RIGHT_AMOUNT_MOVE = menu.find("antiaim", "main", "desync","right amount#move"),

    SIDE_SLOW = menu.find("antiaim", "main", "desync","side#slow walk"),
    LEFT_AMOUNT_SLOW = menu.find("antiaim", "main", "desync","left amount#slow walk"),
    RIGHT_AMOUNT_SLOW = menu.find("antiaim", "main", "desync","right amount#slow walk"),

    FAKELAG_AMOUNT = menu.find("antiaim", "main", "fakelag", "amount")
}

local e_binds = {
    DOUBLE_TAP = menu.find("aimbot", "general", "exploits", "doubletap", "enable"),
    HIDE_SHOTS = menu.find("aimbot", "general", "exploits", "hideshots", "enable"),
    MIN_DMG = menu.find("aimbot", "scout", "target overrides", "force min. damage"),
    AUTO_PEEK = menu.find("aimbot", "general", "misc", "autopeek"),
    FAKE_DUCK = menu.find("antiaim", "main", "general", "fake duck"),
    INVERT = menu.find("antiaim", "main", "manual", "invert desync"),
    SLOW_WALK = menu.find("misc", "main", "movement", "slow walk"),
    FAKE_PING = menu.find("aimbot", "general", "fake ping", "enable")
}
--- @endregion

--- @region: math
--- @info: Round a number to the nearest precision, or none by default.
--- @param: number: number
--- @param: precision: number
--- @return: number
function math.round(number, precision)
	local mult = math.pow(10, (precision or 0))

	return math.floor(number * mult + 0.5) / mult
end

--- @param: yaw: number
--- @return: number
function math.normalize_yaw(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end

    return yaw
end

--- @param: xdelta: number
--- @param: ydelta: number
--- @return: number
function math.world_to_screen(xdelta, ydelta)
    if xdelta == 0 and ydelta == 0 then
        return 0
    end
    
    return math.deg(math.atan2(ydelta, xdelta))
end
--- @endregion

--- @region: string
--- @param: self: string
--- @param: search_string: string
--- @return: number
function string.count(self, search_string)
	local count = 0

    for i = 1, #self do
        if (self:sub(i, i) == search_string) then
            count = count + 1
        end
    end

    return count
end
--- @endregion

--- @region: table
--- @info: Returns true if the table contains the value being searched for.
--- @param: search_table: table
--- @param: search_value: any
--- @return: boolean
function table.contains(search_table, search_value)
	for _, value in pairs(search_table) do
		if (search_value == value) then
			return true
		end
	end

	return false
end

--- @param: tbl: table
--- @return: number
function table.count(tbl)
    if tbl == nil then 
        return 0 
    end

    if #tbl == 0 then 
        local count = 0

        for data in pairs(tbl) do 
            count = count + 1 
        end

        return count 
    end
    return #tbl
end
--- @endregion

--- @region: vector
local vector = {}

--- @param: vec_1: vec3_t
--- @return: vec3_t
function vector.to_angle(vec_1)
    local temp, pitch, yaw = 0, 0, 0

    if vec_1.y == 0 and vec_1.x == 0 then
        yaw = 0

        if vec_1.z > 0 then 
            pitch = 270
        else 
            pitch = 90
        end
    else 
        yaw = math.atan2(vec_1.y, vec_1.x) * 180 / math.pi

        if yaw < 0 then 
            yaw = yaw + 360
        end

        temp = math.sqrt(vec_1.x * vec_1.x + vec_1.y * vec_1.y)
        pitch = math.atan2(-vec_1.z, temp) * 180 / math.pi

        if pitch < 0 then 
            pitch = pitch + 360
        end
    end

    return vec3_t(pitch, yaw, 0)
end

--- @param: vec_1: vec3_t
--- @param: vec_2: vec3_t
--- @return: vec3_t
function vector.calc_angle(vec_1, vec_2)
    local vecdelta = vec3_t(vec_1.x - vec_2.x, vec_1.y - vec_2.y, vec_1.z - vec_2.z)
    
    local angles = vec3_t(math.atan2(-vecdelta.z, math.sqrt(vecdelta.x^2 + vecdelta.y^2)) * 180.0 / math.pi, (math.atan2(vecdelta.y, vecdelta.x) * 180.0 / math.pi), 0.0)
    
    return angles
end
--- @endregion

--- @region: vtable
local vtable = {}

function vtable.bind(module, interface, index, typestring)
    local iface = memory.create_interface(module, interface) or error(interface .. ": invalid interface")
    local instance = memory.get_vfunc(iface, index) or error(index .. ": invalid index")
    local success, typeof = pcall(ffi.typeof, typestring)

    if (not success) then
        error(typeof, 2)
    end

    local fnptr = ffi.cast(typeof, instance) or error(typestring .. ": invalid typecast")

    return function(...)
        return fnptr(tonumber(ffi.cast("void***", iface)), ...)
    end
end
--- @endregion

--- @region: ffi
local jmp_ecx = memory.find_pattern("engine.dll", "FF E1")
local fnGetModuleHandle = ffi.cast("uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)", jmp_ecx)
local fnGetProcAddress = ffi.cast("uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)", jmp_ecx)

local pGetProcAddress = ffi.cast("uint32_t**", ffi.cast("uint32_t", memory.find_pattern("engine.dll", "FF 15 ?? ?? ?? ?? A3 ?? ?? ?? ?? EB 05")) + 2)[0][0]
local pGetModuleHandle = ffi.cast("uint32_t**", ffi.cast("uint32_t", memory.find_pattern("engine.dll", 'FF 15 ?? ?? ?? ?? 85 C0 74 0B')) + 2)[0][0]
local BindExports = function(sModuleName, sFunctionName, sTypeOf) local ctype = ffi.typeof(sTypeOf) return function(...) return ffi.cast(ctype, jmp_ecx)(fnGetProcAddress(pGetProcAddress, 0, fnGetModuleHandle(pGetModuleHandle, 0, sModuleName), sFunctionName), 0, ...) end end

local fnEnumDisplaySettingsA = BindExports("user32.dll", "EnumDisplaySettingsA", "int(__fastcall*)(unsigned int, unsigned int, unsigned int, unsigned long, void*)");
local pLpDevMode = ffi.new("struct { char pad_0[120]; unsigned long dmDisplayFrequency; char pad_2[32]; }[1]")
--- @endregion

--- @region: clipboard
local clipboard_c = {}

clipboard_c.get_clipboard_text_count = vtable.bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
clipboard_c.set_clipboard_text = vtable.bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
clipboard_c.get_clipboard_text = vtable.bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")

function clipboard_c.import()
    local len = clipboard_c.get_clipboard_text_count()

    if (len > 0) then
        local char_arr = ffi.typeof("char[?]")(len)
        clipboard_c.get_clipboard_text(0, char_arr, len)

        return ffi.string(char_arr, len - 1)
    end
end

function clipboard_c.export(text)
    text = tostring(text)

    clipboard_c.set_clipboard_text(text, text:len())
end
--- @endregion

--- @region: animation
local animation_data = {}
local animation = {}

--- @info: Lerp animation.
--- @param: start: any
--- @param: end_pos: any
--- @param: time: number
--- @return: any
function animation.lerp(start, end_pos, time)
    if (type(start) == "userdata") then
        local color_data = {0, 0, 0, 0}

        for key, value in ipairs({"r", "g", "b", "a"}) do
            color_data[key] = animation.lerp(start[value], end_pos[value], time)
        end

        return color_t(unpack(color_data))
    end

    return (end_pos - start) * (global_vars.frame_time() * time) + start
end

--- @param: name: string
--- @param: value: any
--- @param: time: number
--- @return: any
function animation.create(name, value, time)
    if (animation_data[name] == nil) then
        animation_data[name] = value
    end

    animation_data[name] = animation.lerp(animation_data[name], value, time)

    return animation_data[name]
end
--- @endregion

--- @region: menu_item
--- @class: menu_item_c
--- @field: public: group: string
--- @field: public: name: string
--- @field: public: reference: any
--- @field: public: is_menu_reference: boolean
--- @field: public: to_save: boolean
--- @field: public: condition: function
local menu_item_c = {}
local menu_item_mt = { __index = menu_item_c }

--- @info: Create a new menu_item_c.
--- @param: element: function
--- @param: group: string
--- @param: name: string
--- @param: to_save: boolean
--- @param: condition: function
--- @vararg: any
--- @return: menu_item_c
function menu_item_c.new(element, group, name, to_save, condition, ...)
	local reference
	local is_menu_reference = false

	if ((type(element)) == "function") then
		local do_ui_new = {pcall(element, group, name, ...)}

		assert(do_ui_new[1], 4, "Cannot create menu item because: %s", do_ui_new[2])

		reference = do_ui_new[2]
	else
		reference = element
		is_menu_reference = true
	end

	return setmetatable({
		group = group,
		name = name,
		reference = reference,
		is_menu_reference = is_menu_reference,

		to_save = to_save,
		condition = condition,
	}, menu_item_mt)
end

--- @vararg: any
--- @return: void
function menu_item_c:set(...)
	local args = {...}

	if (type(self.reference) == "table") then
		self.reference[2]:set(unpack(args))
	else
		self.reference:set(unpack(args))
	end
end

--- @vararg: string
--- @return: void
function menu_item_c:set_items(...)
	local args = {...}

	if (type(args[1]) == "table") then
		args = args[1]
	end

	if (type(self.reference) == "table") then
		self.reference[2]:set_items(args)
	else
		self.reference:set_items(args)
	end
end

--- @return: table
function menu_item_c:get_items()
	if (type(self.reference) == "table") then
		return self.reference[2]:get_items()
	else
		return self.reference:get_items()
	end
end

--- @vararg: any
--- @return: any
function menu_item_c:get(...)
	local args = {...}

	if (type(self.reference) == "table") then
		return self.reference[2]:get(unpack(args))
	else
		return self.reference:get(unpack(args))
	end
end

--- @param: value: boolean
--- @return: any
function menu_item_c:set_visible(value)
	if (type(self.reference) == "table") then
		self.reference[1]:set_visible(value)
		self.reference[2]:set_visible(value)
	else
		self.reference:set_visible(value)
	end
end

--- @param: group: string
--- @param: name: string
--- @param: default_color: color_t: optional
--- @param: alpha: boolean: optional
--- @return: color_picker
function menu_item_c.new_color_picker(group, name, default_color, alpha)
	local color_picker_text = menu.add_text(group, name)
	local color_picker_item = color_picker_text:add_color_picker(("Color %s"):format(name), default_color, alpha)

	return {color_picker_text, color_picker_item}
end
--- @endregion

--- @region: menu_manager
--- @class: menu_manager_c
--- @field: public: tab: string
--- @field: public: group: string
--- @field: public: name: string
--- @field: public: to_save: boolean
--- @field: public: condition: function
--- @field: public: reference: menu item
local menu_manager_c = {}
local menu_manager_mt = { __index = menu_manager_c }

local menu_manager_current_tab = menu.add_selection("Main", "Current Tab:", {"none"})
local menu_manager_tabs = {}
local menu_manager_items = {}

--- @info: Create a new menu_manager_c.
--- @param: tab: string
--- @param: group: string
--- @param: name: string
--- @param: to_save: boolean
--- @param: condition: function: optional
--- @return: menu_manager_c
function menu_manager_c.new(tab, group, name, to_save, condition)
	return setmetatable({
		tab = tab == nil and "Global" or tab,
		group = group == nil and "Main" or group,
		name = name,

		to_save = to_save == nil and true or to_save,

		condition = condition == nil and function()
			return true
		end or condition,
	}, menu_manager_mt)
end

--- @param: tab: string
--- @param: name: string
--- @return: menu_item_c
function menu_manager_c.reference(tab, group, name)
	return menu_manager_items[tab][group][name].reference
end

--- @return: menu_item_c
function menu_manager_c:checkbox(default_value)
	local item = self:_create_item(menu.add_checkbox, false)
	if (default_value ~= nil) then
		item:set(default_value)
	end

	return item
end

--- @return: menu_item_c
function menu_manager_c:text()
	self.to_save = false

	return self:_create_item(menu.add_text, false)
end

--- @param: callback: function
--- @return: menu_item_c
function menu_manager_c:button(callback)
	assert(type(callback) == "function", 3, "Cannot set button callback because the callback argument must be a function.")

	self.to_save = false

	return self:_create_item(menu.add_button, false, callback)
end

--- @param: min: number
--- @param: max: number
--- @param: default_value: number: optional
--- @return: menu_item_c
function menu_manager_c:slider(min, max, default_value)
	assert(type(min) == "number", 3, "Slider min value must be a number.")
	assert(type(max) == "number", 3, "Slider max value must be a number.")
	assert(min < max, 3, "Slider min value must be below the max value.")

	local item = self:_create_item(menu.add_slider, false, min, max)
	if (default_value ~= nil) then
		item:set(default_value)
	end

	return item
end

--- @param: name: string
--- @param: r: number
--- @param: g: number
--- @param: b: number
--- @param: a: number
--- @return: menu_item_c
function menu_manager_c:color_picker(r, g, b, a)
	r = r or 255
	g = g or 255
	b = b or 255
	a = a or 255

	assert(type(r) == "number" and r >= 0 and r <= 255, 3, "Cannot set color picker red channel value. It must be between 0 and 255.")
	assert(type(g) == "number" and g >= 0 and g <= 255, 3, "Cannot set color picker green channel value. It must be between 0 and 255.")
	assert(type(b) == "number" and b >= 0 and b <= 255, 3, "Cannot set color picker blue channel value. It must be between 0 and 255.")
	assert(type(a) == "number" and a >= 0 and a <= 255, 3, "Cannot set color picker alpha channel value. It must be between 0 and 255.")

	return self:_create_item(menu_item_c.new_color_picker, false, color_t(r, g, b, a), true)
end

--- @vararg: string
--- @return: menu_item_c
function menu_manager_c:selection(...)
	local args = {...}

	if (type(args[1]) == "table") then
		args = args[1]
	end

	return self:_create_item(menu.add_selection, false, args)
end

--- @vararg: string
--- @return: menu_item_c
function menu_manager_c:multi_selection(...)
	local args = {...}

	if (type(args[1]) == "table") then
		args = args[1]
	end

	return self:_create_item(menu.add_multi_selection, true, args)
end

--- @param: element: function
--- @param: name: string
--- @vararg: any
--- @return: menu_item_c
function menu_manager_c:_create_item(element, is_multi_selection, ...)
	assert(type(self.name) == "string" and self.name ~= "", 3, "Cannot create menu item: name must be a non-empty string.")

	local item = menu_item_c.new(element, self.group, self.name, self.to_save, self.condition, ...)

	if (menu_manager_items[self.tab] == nil) then
        menu_manager_items[self.tab] = {}

        table.insert(menu_manager_tabs, self.tab)
        menu_manager_current_tab:set_items(menu_manager_tabs)
	end

	if (menu_manager_items[self.tab][self.group] == nil) then
		menu_manager_items[self.tab][self.group] = {}
	end

	menu_manager_items[self.tab][self.group][self.name] = { 
        reference = item.reference,
        to_save = self.to_save,
        condition = self.condition,
        is_multi_selection = is_multi_selection
	}

	return item
end

--- @return: void
function menu_manager_c.visible()
	for tab_name, group_value in pairs(menu_manager_items) do
		for group_name, item_value in pairs(group_value) do
			for item_name, value in pairs(item_value) do
				local tabs = menu_manager_current_tab:get_items()
				local condition = tabs[menu_manager_current_tab:get()] == tab_name and value.condition()

				if (type(value.reference) == "table") then
					value.reference[1]:set_visible(condition)
					value.reference[2]:set_visible(condition)
				else
					value.reference:set_visible(condition)
				end
			end
		end
	end
end
--- @endregion

--- @region: drag
--- @class: drag_c
--- @field: public: x: number
--- @field: public: y: number
--- @field: public: width: number
--- @field: public: height: number
--- @field: public: d_x: number
--- @field: public: d_y: number
--- @field: public: dragging: boolean
--- @field: public: unlocked: boolean
local drag_c = {}
local drag_mt = { __index = drag_c }

--- @info: Instantiate an object of drag_c.
--- @param: x: number
--- @param: y: number
--- @return drag_c
function drag_c.new(x, y, name, tab, group)
    tab = tab or "Widgets"
    group = group or "Widgets"

    local screen = render.get_screen_size()

	return setmetatable({
		x = menu_manager_c.new(tab, group, ("[ %s ] x"):format(name), true, function() return false end):slider(0, screen.x, x),
		y = menu_manager_c.new(tab, group, ("[ %s ] y"):format(name), true, function() return false end):slider(0, screen.y, y),

		d_x = 0,
		d_y = 0,

		dragging = false,
		unlocked = false
	}, drag_mt)
end

--- @info: Unlock the dragging position.
--- @return void
function drag_c:unlock()
	self.unlocked = true
end

--- @info: Lock the dragging position.
--- @return void
function drag_c:lock()
	self.unlocked = false
end

--- @info: Handle dragging.
--- @param: width: number
--- @param: height: number
--- @return: void
function drag_c:handle(width, height)
	self.width = width
	self.height = height

	local screen = render.get_screen_size()
	local mouse_position = input.get_mouse_pos()

	if (input.is_mouse_in_bounds(vec2_t(self.x:get(), self.y:get()), vec2_t(self.width, self.height))) then
		if (input.is_key_held(e_keys.MOUSE_LEFT) and not self.dragging) then
            self.dragging = true

            self.d_x = self.x:get() - mouse_position.x
            self.d_y = self.y:get() - mouse_position.y
		end
	end

    if (not input.is_key_held(e_keys.MOUSE_LEFT)) then 
        self.dragging = false
    end

    if (self.dragging and menu.is_open()) then
        local new_x = math.max(0, math.min(screen.x - self.width, mouse_position.x + self.d_x))
        local new_y = math.max(0, math.min(screen.y - self.height, mouse_position.y + self.d_y))
        new_x = self.unlocked and mouse_position.x + self.d_x or new_x
        new_y = self.unlocked and mouse_position.y + self.d_y or new_y

        self.x:set(new_x)
        self.y:set(new_y)
    end
end

--- @info: Getting drag position.
--- @return: position<x: number, y:number>
function drag_c:get()
	return self.x:get(), self.y:get()
end
--- @endregion

--- @region: note
--- @class: note_c
--- @field: public: name: string
local note_c = {}
local note_mt = { __index = note_c }

--- @info: Instantiate an object of note_c.
--- @param: name: string
--- @return: note_c
function note_c.new(name)
    if (package.sonicNotes == nil) then 
        package.sonicNotes = {}
    end

	return setmetatable({
		name = name
	}, note_mt)
end

--- @param: packages: table
--- @param: sort_function: function
--- @return: any
function note_c.sort(packages, sort_function)
    local tbl = {}

    for value in pairs(packages) do 
        table.insert(tbl, value)
    end

    table.sort(tbl, sort_function)

    local index = 0
    local function update_table()
        index = index + 1

        if (tbl[index] == nil) then 
            return nil 
        else 
            return tbl[index], packages[tbl[index]]
        end 
    end

    return update_table
end

--- @param: func: function 
--- @return: number
function note_c:get(func)
    local index = 0
    local tbl = {}

    for key, value in note_c.sort(package.sonicNotes) do
        if (value == true) then
            index = index + 1

            table.insert(tbl, {key, index})
        end
    end

    for key, value in ipairs(tbl) do
        if (value[1] == self.name) then
            return func(value[2] - 1)
        end
    end
end

--- @param: value: boolean
--- @return: void
function note_c:set_state(value)
    package.sonicNotes[self.name] = value

    table.sort(package.sonicNotes)
end

--- @return: void
function note_c:unload()
    if (package.sonicNotes[self.name] ~= nil) then 
        package.sonicNotes[self.name] = nil 
    end
end
--- @endregion

--- @region: render
local render_c = {}

--- @param: font: font
--- @param: tbl: table
--- @return: number
function render_c.get_multitext_width(font, tbl)
    local width = 0

    for key, value in pairs(tbl) do
        if (font == nil) then
            return
        end

        width = width + render.get_text_size(font, tostring(value.text)).x
    end

    return width
end

--- @param: font: font
--- @param: vec_start: vec2_t
--- @param: tbl: table
--- @param: alpha: number
--- @return: void
function render_c.multitext(font, vec_start, tbl, alpha)
	if (vec_start == nil and type(vec_start) ~= "userdata") then
		return
	end

	if (alpha == nil) then
		alpha = 1
	end

	local x, y = vec_start.x, vec_start.y

	for key, value in pairs(tbl) do
		if (font == nil) then
            return
        end

        value.centered = value.centered or false
        value.color = value.color or color_t(255, 255, 255, 255)
        value.alpha = value.alpha or 1

        render.push_alpha_modifier(value.alpha)
        render.text(font, tostring(value.text), vec2_t(x, y), value.color)
        render.pop_alpha_modifier()

		x = x + render.get_text_size(font, value.text).x
	end
end

--- @param: vec_start: vec2_t
--- @param: vec_end: vec2_t
--- @param: container_color: color_t
--- @param: outline: boolean
--- @return: void
function render_c.container(vec_start, vec_end, container_color, style, outline)
	if (vec_start == nil and type(vec_start) ~= "userdata") then
		return
	end

	if (vec_end == nil and type(vec_end) ~= "userdata") then
		return
	end

	if (outline == nil) then
		outline = true
	end

    if (style == nil) then
        style = 1
    end

	local x, y = vec_start.x, vec_start.y
	local w, h = vec_end.x, vec_end.y

	local r, g, b, a = container_color.r, container_color.g, container_color.b, container_color.a

    local rounding = 3

    local half_modifier = 25
    local half_alpha = (half_modifier / 255) * a

	if (style == 1) then
		render.rect_filled(vec2_t(x, y), vec2_t(w, h), color_t(0, 0, 0, 120))

		if (outline) then
			render.rect_filled(vec2_t(x, y), vec2_t(w, 2), color_t(r, g, b, 255))
		end
	elseif (style == 2) then
	    render.rect_filled(vec2_t(x, y), vec2_t(w, h), color_t(0, 0, 0, 120), rounding)

	    if (outline) then
		    render.rect_filled(vec2_t(x + rounding, y), vec2_t(w - rounding * 2, 1), color_t(r, g, b, 255))

		    render.push_clip(vec2_t(x, y), vec2_t(rounding, rounding + 2))
		    render.progress_circle(vec2_t(x + rounding, y + rounding), rounding, color_t(r, g, b, 255), 1, 88)
		    render.pop_clip()

		    render.push_clip(vec2_t(x + w - rounding, y), vec2_t(rounding + 1, rounding + 2))
		    render.progress_circle(vec2_t(x + w - rounding, y + rounding), rounding, color_t(r, g, b, 255), 1, 90)
		    render.pop_clip()

		    render.rect_fade(vec2_t(x, y + rounding), vec2_t(1, h - rounding * 2), color_t(r, g, b, 255), color_t(r, g, b, 0), false)
		    render.rect_fade(vec2_t(x + w, y + rounding), vec2_t(1, h - rounding * 2), color_t(r, g, b, 255), color_t(r, g, b, 0), false)
	    end

	    render.rect(vec2_t(x, y), vec2_t(w, h), color_t(r, g, b, half_alpha), rounding)
	elseif (style == 3) then
		render.rect_filled(vec2_t(x, y), vec2_t(w, h), color_t(0, 0, 0, 120))

		if (outline) then
			render.rect_fade(vec2_t(x, y), vec2_t(w, h), color_t(r, g, b, 100), color_t(r, g, b, 0), false)
			render.rect_filled(vec2_t(x, y), vec2_t(w, 2), color_t(r, g, b, 255))

			render.rect_fade(vec2_t(x, y), vec2_t(2, h), color_t(r, g, b, 255), color_t(r, g, b, 0), false)
			render.rect_fade(vec2_t(x + w - 2, y), vec2_t(2, h), color_t(r, g, b, 255), color_t(r, g, b, 0), false)
		end
	elseif (style == 4) then
		render.rect_filled(vec2_t(x, y), vec2_t(w, h), color_t(0, 0, 0, 120), 6)

		if (outline) then
			render.rect(vec2_t(x, y), vec2_t(w, h), color_t(r, g, b, 255), 6)
		end
	end
end
--- @endregion

--- @region: engine
--- @return: number
function engine.get_condition()
	local player = entity_list.get_local_player()

	if (player == nil or not player:is_alive()) then
		return e_conditions.SHARED
	end

	local velocity = math.sqrt(math.pow(player:get_prop("m_vecVelocity[0]"), 2) + math.pow(player:get_prop("m_vecVelocity[1]"), 2))

    if (not player:has_player_flag(e_player_flags.ON_GROUND)) then
        return e_conditions.AIR
    end

    if (player:has_player_flag(e_player_flags.DUCKING)) then
        return e_conditions.CROUCH
    end

    if velocity > 5 then
        if e_binds.SLOW_WALK[2]:get() then
            return e_conditions.WALKING
        end

        return e_conditions.RUNNING
    end

    return e_conditions.STANDING
end

--- @param: con_id: number
--- @return: string
function engine.get_condition_name(con_id)
    for key, value in spairs(e_conditions, function(t, a, b)
        return t[b] > t[a]
    end) do
    	if (value == con_id) then
	        local new_name = key:lower()
	        new_name = new_name:gsub("(%l)(%w*)", function(a, b)
	            return a:upper() .. b
	        end)

	        return new_name
	    end
    end
end

--- @return: entity
function engine.get_closet_enemy()
	local player = entity_list.get_local_player()

	if (player == nil or not player:is_alive()) then
		return
	end

	local players = entity_list.get_players(true)

	if (players == nil) then
		return
	end

	local eye_pos = player:get_eye_position()
	local view_angles = engine.get_view_angles()

	local target = nil

	local fov = 180

	for key, enemy in pairs(players) do 
		local origin = enemy:get_render_origin()

		local current_fov = math.abs(math.normalize_yaw(math.world_to_screen(eye_pos.x - origin.x, eye_pos.y - origin.y) - view_angles.y + 180))

        if (current_fov < fov) then
            fov = current_fov

            target = enemy
        end
	end

	return target
end
--- @endregion

--- @region: unnamed
--- @element: script vars
local script_name = "youtuberi.lua"
local script_type = "stable"
local script_color = color_t(255, 192, 118, 255)

--- @element: fonts
local fonts = {}

fonts.verdana = {}
fonts.verdana.shadow = render.create_font("Verdana", 12, 400, e_font_flags.DROPSHADOW)

fonts.small = {}
fonts.small.outline = render.create_font("Small Fonts", 8, 400, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE)
--- @endregion

--- @region: ui
--- @group: Global
local ui_global = {}

ui_global.script_name = menu_manager_c.new("Global", "Main", ("Script Name: %s"):format(script_name)):text()
---ui_global.discord_link = menu_manager_c.new("Global", "Main", "Copy Discord Link"):button(function()
	--local link = "https://discord.gg/tPfYp4WeXq"

	--clipboard_c.export(link)
--end)

--- @group: Settings
local ui_settings = {}

ui_settings.solus_animation_speed = menu_manager_c.new("Settings", "Animation", "Solus Animation Speed"):slider(0, 25, 12)
ui_settings.hit_log_animation_speed = menu_manager_c.new("Settings", "Animation", "Hit Log Animation Speed"):slider(0, 25, 4)
ui_settings.manual_arrows_animation_speed = menu_manager_c.new("Settings", "Animation", "Manual Arrows Animation Speed"):slider(0, 25, 12)

ui_settings.indicators_offset = menu_manager_c.new("Settings", "Other", "Indicators Offset"):slider(0, 150, 40)
ui_settings.hit_log_offset = menu_manager_c.new("Settings", "Other", "Hit Log Offset"):slider(100, 500, 200)

--- @group: Ragebot
local ui_ragebot = {}

ui_ragebot.dormant_aimbot = menu_manager_c.new("Ragebot", "Ragebot", "Enable Dormant Aimbot"):checkbox()
ui_ragebot.dormant_aimbot_hotkey = ui_ragebot.dormant_aimbot.reference:add_keybind("Dormant Aimbot Hotkey")
ui_ragebot.dormant_aimbot_condition = function() return ui_ragebot.dormant_aimbot:get() end
ui_ragebot.dormant_aimbot_team_check = menu_manager_c.new("Ragebot", "Ragebot", "Team Check", true, ui_ragebot.dormant_aimbot_condition):checkbox()
ui_ragebot.dormant_aimbot_auto_scope = menu_manager_c.new("Ragebot", "Ragebot", "Auto Scope", true, ui_ragebot.dormant_aimbot_condition):checkbox()
ui_ragebot.dormant_aimbot_min_dmg = menu_manager_c.new("Ragebot", "Ragebot", "Minimum Damage", true, ui_ragebot.dormant_aimbot_condition):slider(1, 130, 10)

--- @group: Anti-Aim
local ui_anti_aim = {}

ui_anti_aim.switch = menu_manager_c.new("Anti-Aim", "Anti-Aim", "Master Switch"):checkbox()
ui_anti_aim.switch_condition = function() return ui_anti_aim.switch:get() end

ui_anti_aim.mode = menu_manager_c.new("Anti-Aim", "Anti-Aim", "Anti-Aim Mode", true, ui_anti_aim.switch_condition):selection("None", "Condition")
ui_anti_aim.animation_breakers = menu_manager_c.new("Anti-Aim", "Anti-Aim", "Animation Breakers", true, ui_anti_aim.switch_condition):multi_selection("Static Legs In Air", "Zero Pitch On Land", "Static Legs On Slow Walk", "Reverse Slide", "Body Lean")

--- @group: Widgets
local ui_widgets = {}

ui_widgets.switch = menu_manager_c.new("Widgets", "Widgets", "Master Switch"):checkbox()
ui_widgets.switch_condition = function() return ui_widgets.switch:get() end

ui_widgets.widgets_list = {"Watermark", "Keybinds", "Fake Indication", "Fake Lag Indication", "Exploit Indication", "Frequency Update Indication", "Crosshair Indicators"}
ui_widgets.widgets = menu_manager_c.new("Widgets", "Widgets", "Widgets", true, ui_widgets.switch_condition):multi_selection(ui_widgets.widgets_list)

ui_widgets.accent = menu_manager_c.new("Widgets", "Widgets", "Accent", true, function()
	return ui_widgets.switch_condition() and ui_widgets.widgets:get(1) or ui_widgets.widgets:get(2) or ui_widgets.widgets:get(3) or ui_widgets.widgets:get(4) or ui_widgets.widgets:get(5) or ui_widgets.widgets:get(6) or ui_widgets.widgets:get(7)
end):color_picker(script_color.r, script_color.g, script_color.b, script_color.a)
ui_widgets.style = menu_manager_c.new("Widgets", "Widgets", "Windows Style", true, function()
	return ui_widgets.switch_condition() and ui_widgets.widgets:get(1) or ui_widgets.widgets:get(2) or ui_widgets.widgets:get(3) or ui_widgets.widgets:get(4) or ui_widgets.widgets:get(5) or ui_widgets.widgets:get(6)
end):selection("Solus V1", "Solus V2", "Medusa", "Rounded")
ui_widgets.indicators_style = menu_manager_c.new("Widgets", "Widgets", "Indicators Style", true, function()
	return ui_widgets.widgets:get(7)
end):selection("Default", "Alternative", "Legacy")

ui_widgets.manual_arrows = menu_manager_c.new("Widgets", "Widgets", "Enable Manual Arrows", true, ui_widgets.switch_condition):checkbox()
ui_widgets.manual_arrows_condition = function() return ui_widgets.switch_condition() and ui_widgets.manual_arrows:get() end
ui_widgets.manual_arrows_color = menu_manager_c.new("Widgets", "Widgets", "Manual Arrows Color", true, ui_widgets.manual_arrows_condition):color_picker(script_color.r, script_color.g, script_color.b, script_color.a)
ui_widgets.manual_arrows_inverted_color = menu_manager_c.new("Widgets", "Widgets", "Manual Arrows Inverted Color", true, ui_widgets.manual_arrows_condition):color_picker(script_color.r, script_color.g, script_color.b, script_color.a)

ui_widgets.hit_log = menu_manager_c.new("Widgets", "Widgets", "Enable Hit Log", true, ui_widgets.switch_condition):checkbox()
ui_widgets.hit_log_condition = function() return ui_widgets.switch_condition() and ui_widgets.hit_log:get() end
ui_widgets.manage_color = menu_manager_c.new("Widgets", "Widgets", "Manage Colors", true, ui_widgets.hit_log_condition):checkbox()
ui_widgets.manage_color_condition = function() return ui_widgets.hit_log_condition() and ui_widgets.manage_color:get() end
ui_widgets.hit_color = menu_manager_c.new("Widgets", "Widgets", "Hit Color", true, ui_widgets.manage_color_condition):color_picker(47, 255, 72, 255)
ui_widgets.miss_color = menu_manager_c.new("Widgets", "Widgets", "Miss Color", true, ui_widgets.manage_color_condition):color_picker(255, 150, 150, 255)

--[[
--- @group: Other
local ui_other = {}

ui_other.switch = menu_manager_c.new("Widgets", "Other", "Master Switch"):checkbox()
ui_other.switch_condition = function() return ui_other.switch:get() end
]]
--- @endregion

--- @region: ragebot
--- @item: Dormant Aimbot
local dormant_aimbot = {}

dormant_aimbot.round_started = 0

function dormant_aimbot.auto_stop(cmd)
	cmd.move.x = cmd.move.x - cmd.move.x / 1.5
	cmd.move.y = cmd.move.y - cmd.move.y / 1.5
end

function dormant_aimbot.auto_scope(player, weapon_data, cmd)
	local scoped = player:get_prop("m_bIsScoped") > 0

	if (not scoped and weapon_data.type == 5 and not cmd:has_button(e_cmd_buttons.JUMP) and player:has_player_flag(e_player_flags.ON_GROUND)) then
		cmd:add_button(e_cmd_buttons.ATTACK2)
	end
end

function dormant_aimbot.handle(cmd)
	if (not ui_ragebot.dormant_aimbot:get()) then
		return
	end

	local player = entity_list.get_local_player()

	if (player == nil or not player:is_alive()) then
		return
	end

	local player_weapon = player:get_active_weapon()

	if (player_weapon == nil) then
		return
	end

	local weapon_inaccuracy = player_weapon:get_weapon_inaccuracy()

	local eye_pos = player:get_eye_position()

	local simtime = player:get_prop("m_flSimulationTime")
	local scoped = player:get_prop("m_bIsScoped") > 0 

	local weapon_data = player_weapon:get_weapon_data()

	if (global_vars.tick_count() < dormant_aimbot.round_started) then 
		return 
	end

	local can_shoot

	if (weapon_data.console_name == "weapon_revolver") then
		can_shoot = simtime > player_weapon:get_prop("m_flNextPrimaryAttack")
	elseif (weapon_data.type == 0) then
		can_shoot = false
	else
		can_shoot = simtime > math.max(player:get_prop("m_flNextAttack"), player_weapon:get_prop("m_flNextPrimaryAttack"), player_weapon:get_prop("m_flNextSecondaryAttack"))
	end

	local player_info = {}
	local players = entity_list.get_players(true)

	local hitboxes = {e_hitboxes.HEAD, e_hitboxes.PELVIS, e_hitboxes.BODY, e_hitboxes.THORAX, e_hitboxes.CHEST, e_hitboxes.UPPER_CHEST}

	for key, enemy in pairs(players) do
		if (not enemy:is_alive() or not enemy:is_dormant()) then
			goto skip
		end

		local origin = enemy:get_hitbox_pos(e_hitboxes.PELVIS)

		if (origin == nil) then
			goto skip
		end

        local target = origin

        local hitbox_num = 2
        local best_damage = 0

        for i, hitbox in ipairs(hitboxes) do
        	local hb_origin = enemy:get_hitbox_pos(hitbox)

        	local bullet = trace.bullet(eye_pos, hb_origin, player)

        	if (bullet.damage > best_damage) then
                target = hb_origin

                hitbox_num = hitbox
                best_damage = bullet.damage
            else
            	best_damage = trace.bullet(eye_pos, target, player).damage
        	end
        end

		local trace = trace.line(eye_pos, target, player, 0x200400B)
        local hit_ent = trace.entity and trace.entity:is_player() and not trace.entity:is_enemy()

        local passed_teamcheck = true
        if (ui_ragebot.dormant_aimbot_team_check:get()) then
        	passed_teamcheck = trace.fraction < 1 and not hit_ent
        end

        local can_hit = best_damage >= 1 and passed_teamcheck 

        if (can_shoot and can_hit) then
        	if (ui_ragebot.dormant_aimbot_hotkey:get()) then
	        	if (best_damage >= ui_ragebot.dormant_aimbot_min_dmg:get()) then
	        		local forward = target - eye_pos
	        		local angles = vector.to_angle(forward)

	        		dormant_aimbot.auto_stop(cmd)

	        		if (ui_ragebot.dormant_aimbot_auto_scope:get()) then
	        			dormant_aimbot.auto_scope(player, weapon_data, cmd)
	        		end

	        		if (weapon_inaccuracy < 0.009 and engine.get_choked_commands() == 0) then
	        			cmd.viewangles.x = angles.x
						cmd.viewangles.y = angles.y

						cmd:add_button(e_cmd_buttons.ATTACK)

						can_shoot = false
	        		end
	        	end
	        end
        end

		::skip::
	end
end

function dormant_aimbot.resetter()
	local freezetime = (cvars.mp_freezetime:get_float() + 1) / global_vars.interval_per_tick()

	dormant_aimbot.round_started = global_vars.tick_count() + freezetime
end
--- @endregion

--- @region: anti-aim
--- @item: Condition Anti-Aim Mode
local condition_anti_aim = {}

condition_anti_aim.list = {}

condition_anti_aim.switch = false
condition_anti_aim.yaw = 0

condition_anti_aim.mode_condition = function() return ui_anti_aim.mode:get() == 2 end
condition_anti_aim.conditions = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", "Current Condition", true, condition_anti_aim.mode_condition):selection("none")

function condition_anti_aim.update_items()
	local conditions = {}

    for key, value in spairs(e_conditions, function(t, a, b)
        return t[b] > t[a]
    end) do
        local new_name = key:lower()
        new_name = new_name:gsub("(%l)(%w*)", function(a, b)
            return a:upper() .. b
        end)

        table.insert(conditions, new_name)
    end

    condition_anti_aim.conditions:set_items(conditions)
end; condition_anti_aim.update_items()

function condition_anti_aim.create_items()
	local items = condition_anti_aim.conditions:get_items()

	for key, value in ipairs(items) do
		local function name(text)
			return ("[%s] %s"):format(value, text)
		end

		if (condition_anti_aim.list[key] == nil) then
			condition_anti_aim.list[key] = {}
		end

		local setup = condition_anti_aim.list[key]

		setup.override = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Override"), true, function()
			return condition_anti_aim.conditions:get() == key and condition_anti_aim.mode_condition()
		end):checkbox()

		local function visible_condition()
			return condition_anti_aim.conditions:get() == key and condition_anti_aim.mode_condition() and setup.override:get()
		end

		setup.yaw_base = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Yaw Base"), true, visible_condition):selection("None", "Viewangle", "At Target (Crosshair)", "At Target (Distance)", "Velocity")
		setup.yaw_add = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Yaw Add"), true, visible_condition):slider(-180, 180)

		setup.jitter_type = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Jitter Type"), true, visible_condition):selection("None", "Offset", "Center")
		local function jitter_type_condition()
			return visible_condition() and setup.jitter_type:get() ~= 1
		end
		setup.jitter_add = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Jitter Add"), true, jitter_type_condition):slider(-180, 180)

		setup.disable_jitter = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Disable Jitter On Manual"), true, visible_condition):checkbox()

		setup.body_lean = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Body Lean"), true, visible_condition):selection("None", "Static", "Static Jitter", "Random Jitter", "Sway")
		local function body_lean_condition()
			return visible_condition() and setup.body_lean:get() ~= 1 and setup.body_lean:get() ~= 5
		end
		setup.body_lean_value = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Body Lean Value"), true, function()
			return body_lean_condition() and setup.body_lean:get() == 2
		end):slider(-50, 50)
		setup.body_lean_jitter = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Body Lean Jitter"), true, function()
			return body_lean_condition() and setup.body_lean:get() == 3 or setup.body_lean:get() == 4
		end):slider(0, 100)

		setup.desync_side = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Desync Side"), true, visible_condition):selection("None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real")
		setup.desync_amount = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Desync Amount"), true, visible_condition):slider(0, 60)
	end
end; condition_anti_aim.create_items()

function condition_anti_aim.handle(ctx)
	if (not ui_anti_aim.switch:get() or ui_anti_aim.mode:get() ~= 2) then
		return
	end

	local player = entity_list.get_local_player()

	if (player == nil or not player:is_alive()) then
		return
	end

	local target = engine.get_closet_enemy()

	local current_condition = engine.get_condition()
	local item = condition_anti_aim.list[current_condition]

	if (not item.override:get()) then
		return
	end

	local yaw_add = item.yaw_add:get()
	local is_manual = antiaim.get_manual_override() == 1 or antiaim.get_manual_override() == 2 or antiaim.get_manual_override() == 3

	if (item.jitter_type:get() == 1) then
		e_menu.YAW_ADD:set(yaw_add)
	end

	e_menu.YAW_BASE:set(item.yaw_base:get())

	if (engine.get_choked_commands() == 0) then
		if (item.jitter_type:get() ~= 1) then
			e_menu.JITTER_MODE:set(1)

			if (item.jitter_type:get() == e_jitter_type.OFFSET) then
				if (condition_anti_aim.switch) then
					condition_anti_aim.yaw = yaw_add
				else
					condition_anti_aim.yaw = yaw_add + item.jitter_add:get()
				end
			elseif (item.jitter_type:get() == e_jitter_type.CENTER) then
				if (condition_anti_aim.switch) then
					condition_anti_aim.yaw = yaw_add - item.jitter_add:get() / 2
				else
					condition_anti_aim.yaw = yaw_add + item.jitter_add:get() / 2
				end
			end

			condition_anti_aim.switch = not condition_anti_aim.switch

			e_menu.YAW_ADD:set(condition_anti_aim.yaw)
		end
	end

	e_menu.JITTER_ADD:set(item.jitter_add:get())

    e_menu.BODY_LEAN:set(item.body_lean:get())
    e_menu.BODY_LEAN_VALUE:set(item.body_lean_value:get())
    e_menu.BODY_LEAN_JITTER:set(item.body_lean_jitter:get())

    e_menu.SIDE_STAND:set((is_manual and item.disable_jitter:get()) and 2 or item.desync_side:get())
    e_menu.SIDE_MOVE:set((is_manual and item.disable_jitter:get()) and 2 or item.desync_side:get())
    e_menu.SIDE_SLOW:set((is_manual and item.disable_jitter:get()) and 2 or item.desync_side:get())

    local desync_left_amount = (item.desync_amount:get() / 2) * (10 / 6)
	local desync_right_amount = item.desync_amount:get() * (10 / 6)

    e_menu.LEFT_AMOUNT_MOVE:set(desync_left_amount)
    e_menu.RIGHT_AMOUNT_MOVE:set(desync_right_amount)
    e_menu.LEFT_AMOUNT_SLOW:set(desync_left_amount)
    e_menu.RIGHT_AMOUNT_SLOW:set(desync_right_amount)
    e_menu.LEFT_AMOUNT_STAND:set(desync_left_amount)
    e_menu.RIGHT_AMOUNT_STAND:set(desync_right_amount)
end

--- @item: Animation Breakers
local anim_breaker = {}

anim_breaker.ground_ticks = 1
anim_breaker.end_time = 0

function anim_breaker.handle(ctx)
	local player = entity_list.get_local_player()

	if (player == nil or not player:is_alive()) then
		return
	end

	local on_ground = player:has_player_flag(e_player_flags.ON_GROUND)

	if (ui_anti_aim.animation_breakers:get(1)) then
		if (not on_ground) then
			ctx:set_render_pose(e_poses.JUMP_FALL, 1)
		end
	end

	if (ui_anti_aim.animation_breakers:get(2)) then
		if (on_ground) then
			anim_breaker.ground_ticks = anim_breaker.ground_ticks + 1
		else
            anim_breaker.ground_ticks = 0
            anim_breaker.end_time = global_vars.cur_time() + 1
		end

		if (anim_breaker.ground_ticks > (e_menu.FAKELAG_AMOUNT:get() + 1) and anim_breaker.end_time > global_vars.cur_time()) then
			ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
		end
	end

	if (ui_anti_aim.animation_breakers:get(3)) then
		if (e_binds.SLOW_WALK[2]:get()) then
			ctx:set_render_pose(e_poses.MOVE_BLEND_WALK, 0)
		end
	end

	if (ui_anti_aim.animation_breakers:get(4)) then
		ctx:set_render_pose(e_poses.RUN, 0)
	end

	if (ui_anti_aim.animation_breakers:get(5)) then
		if (not on_ground) then
			ctx:set_render_animlayer(e_animlayers.LEAN, 0.75, 1)
		end
	end
end
--- @endregion

--- @region: widgets
--- @item: Watermark
local watermark_c = {}

watermark_c.note = note_c.new("a_watermark")

function watermark_c.handle()
	watermark_c.note:set_state(ui_widgets.widgets:get(1) and ui_widgets.switch:get())
	watermark_c.note:get(function(id)
		local accent_color = ui_widgets.accent:get()
		local r, g, b = accent_color.r, accent_color.g, accent_color.b

        local hours, minutes, seconds = client.get_local_time()
        local actual_time = ("%02d:%02d:%02d"):format(hours, minutes, seconds)

        local nickname = user.name

        local prefix = {
            first = script_name:sub(1, #script_name / 2),
            second = script_name:sub((#script_name / 2) + 1, #script_name),
        }

        local text = {
            {text = prefix.first},
            {text = prefix.second, color = ui_widgets.style:get() == 2 and color_t(r, g, b, 255) or color_t(255, 255, 255, 255)},
            {text = (" [%s]"):format(script_type)},

            {text = (" | %s"):format(nickname), shadow = true}
        }

        if (engine.is_in_game()) then
            local latency = math.floor(engine.get_latency(e_latency_flows.INCOMING))

            if (latency > 5) then
                local latency_text = (" | delay: %dms"):format(latency)

                table.insert(text, {text = latency_text})
            end
        end

        table.insert(text, {text = (" | %s"):format(actual_time)})

        local text_width, text_height = render_c.get_multitext_width(fonts.verdana.shadow, text), 12

        local x, y = render.get_screen_size().x, 8 + (27*id)

        local width, height = animation.create("watermark [width]", text_width + 10, 8), 22

        x = x - width - 10

        render_c.container(vec2_t(x, y), vec2_t(width, height), color_t(r, g, b, 255), ui_widgets.style:get())
        render_c.multitext(fonts.verdana.shadow, vec2_t(x + (width / 2) - (text_width / 2), y + (height / 2) - (text_height / 2)), text)
	end)
end

--- @item: Keybinds
local keybinds_c = {}

keybinds_c.active = {}

keybinds_c.list = {
    ["Minimum damage"] = e_binds.MIN_DMG,
    ["Double tap"] = e_binds.DOUBLE_TAP,
    ["On shot anti-aim"] = e_binds.HIDE_SHOTS,
    ["Anti-aim inverter"] = e_binds.INVERT,
    ["Duck peek assist"] = e_binds.FAKE_DUCK,
    ["Quick peek assist"] = e_binds.AUTO_PEEK,
    ["Slow motion"] = e_binds.SLOW_WALK,
    ["Fake Ping"] = e_binds.FAKE_PING,
    ["Dormant Aimbot"] = {nil, ui_ragebot.dormant_aimbot_hotkey}
}

keybinds_c.modes = { 
    [0] = "toggled",
    [1] = "holding",
    [2] = "holding",
    [3] = "always"
}

keybinds_c.dragging = drag_c.new(0, 0, "Keybinds")

function keybinds_c.handle()
	if (not ui_widgets.widgets:get(2) or not ui_widgets.switch:get()) then
		return
	end

	local accent_color = ui_widgets.accent:get()
	local r, g, b = accent_color.r, accent_color.g, accent_color.b

	local latest_item = false
    local maximum_offset = 66

    for bind_name, bind_value in pairs(keybinds_c.list) do
    	local item_active = bind_value[2]:get()

    	if (item_active) then
    		latest_item = true

    		if (keybinds_c.active[bind_name] == nil) then
    			keybinds_c.active[bind_name] = {mode = "", alpha = 0, offset = 0, active = false}
    		end

    		local bind_name_size = render.get_text_size(fonts.verdana.shadow, bind_name)

    		keybinds_c.active[bind_name].mode = keybinds_c.modes[ bind_value[2]:get_mode() ]

    		keybinds_c.active[bind_name].alpha = animation.lerp(keybinds_c.active[bind_name].alpha, 1, ui_settings.solus_animation_speed:get())
    		keybinds_c.active[bind_name].offset = bind_name_size.x

            keybinds_c.active[bind_name].active = true
        elseif (keybinds_c.active[bind_name] ~= nil) then
            keybinds_c.active[bind_name].alpha = animation.lerp(keybinds_c.active[bind_name].alpha, 0, ui_settings.solus_animation_speed:get())
            keybinds_c.active[bind_name].active = false

            if (keybinds_c.active[bind_name].alpha < 0.1) then
                keybinds_c.active[bind_name] = nil
            end
    	end

        if (keybinds_c.active[bind_name] ~= nil and keybinds_c.active[bind_name].offset > maximum_offset) then
            maximum_offset = keybinds_c.active[bind_name].offset
        end
    end

    if (true) then
		local case_name = "Menu toggled"
		local text_size = render.get_text_size(fonts.verdana.shadow, case_name)
		
		maximum_offset = maximum_offset < text_size.x and text_size.x or maximum_offset

		keybinds_c.active[case_name] = {
			active = true,
			offset = text_size.x,
			mode = "~",
			alpha = animation.create("keybinds [alpha|open menu]", menu.is_open() and 1 or 0, ui_settings.solus_animation_speed:get())
		}
	end

    local alpha = animation.create("keybinds [alpha]", (menu.is_open() or table.count(keybinds_c.active) > 0 and latest_item) and 1 or 0, 12)

    local text = "keybinds"
    local text_size = render.get_text_size(fonts.verdana.shadow, text)

    local x, y = keybinds_c.dragging:get()

    local width, height = animation.create("keybinds [width]", 75 + maximum_offset, 8), 22
    local height_offset = height + 3

    render.push_alpha_modifier(alpha)
    render_c.container(vec2_t(x, y), vec2_t(width, height), color_t(r, g, b, 255), ui_widgets.style:get())
    render.text(fonts.verdana.shadow, text, vec2_t(x + (width / 2) - (text_size.x / 2), y + (height / 2) - (text_size.y / 2) + 1), color_t(255, 255, 255, 255))
    render.pop_alpha_modifier()
   	
   	for bind_name, value in pairs(keybinds_c.active) do
        local key_type = "[" .. (value.mode or "?") .. "]"
        local key_type_size = render.get_text_size(fonts.verdana.shadow, key_type)

        render.push_alpha_modifier(alpha*value.alpha)
        render.text(fonts.verdana.shadow, bind_name, vec2_t(x + 5, y + height_offset), color_t(255, 255, 255, 255))
        render.text(fonts.verdana.shadow, key_type, vec2_t(x + width - key_type_size.x - 5, y + height_offset), color_t(255, 255, 255, 255))
        render.pop_alpha_modifier()

        height_offset = height_offset + 15 * value.alpha
   	end

   	keybinds_c.dragging:handle(width, (table.count(keybinds_c.active) > 0 and ((3 + (15 * table.count(keybinds_c.active))) * 2) or height))
end

--- @item: Anti-Aimbot Indications
local anti_aim_indication_c = {}

anti_aim_indication_c.note = note_c.new("a_wbantiaim")

anti_aim_indication_c.last_sent = 0
anti_aim_indication_c.current_choke = 0

function anti_aim_indication_c.setup_command()
    local choke = engine.get_choked_commands()

    if choke == 0 then
        anti_aim_indication_c.last_sent = anti_aim_indication_c.current_choke
    end

    anti_aim_indication_c.current_choke = choke
end

function anti_aim_indication_c.handle()
    local player = entity_list.get_local_player()

    if (player == nil or not player:is_alive()) then
    	anti_aim_indication_c.note:set_state(false)
        return
    end

    local fake = animation.create("anti-aimbot indication [fake alpha]", ui_widgets.widgets:get(3) and 1 or 0, 12)
    local fakelag = animation.create("anti-aimbot indication [fakelag alpha]", ui_widgets.widgets:get(4) and 1 or 0, 12)
    local exploit = animation.create("anti-aimbot indication [exploit alpha]", (exploits.get_charge() > 1 and ui_widgets.widgets:get(5)) and 1 or 0, 12)

    anti_aim_indication_c.note:set_state(ui_widgets.switch:get() and (fake > 0.01 or fakelag > 0.01 or exploit > 0.01))
    anti_aim_indication_c.note:get(function(id)
    	local accent_color = ui_widgets.accent:get()
		local r, g, b = accent_color.r, accent_color.g, accent_color.b

		local screen = render.get_screen_size()

        local x, y = screen.x - 10, 8 + (27*id)
        local height = 22

        if (exploit > 0.01) then
            local text = "EXPLOITING"
            local text_size = render.get_text_size(fonts.verdana.shadow, text)

            local width = text_size.x + 8

            x = x - width

            render.push_alpha_modifier(exploit)
            render_c.container(vec2_t(x, y), vec2_t(width, height), color_t(r, g, b, 255), ui_widgets.style:get(), false)

            render.rect_fade(vec2_t(x, y + (height - 1)), vec2_t((width / 2) + 1, 1), color_t(0, 0, 0, 25), color_t(r, g, b, 255), true)
            render.rect_fade(vec2_t(x + (width / 2) + 1, y + (height - 1)), vec2_t(width - (width / 2), 1), color_t(r, g, b, 255), color_t(0, 0, 0, 25), true)

            render.text(fonts.verdana.shadow, text, vec2_t(x + 4, y + (height / 2) - (text_size.y / 2) + 1), color_t(255, 255, 255, 255))
            render.pop_alpha_modifier()

            x = x + width - (width + 5) * exploit
        end

        if (fakelag > 0.01) then
            local text = ("FL: %s"):format((function()
                if (anti_aim_indication_c.last_sent < 10) then
                    return "\x20\x20" .. anti_aim_indication_c.last_sent
                end

                return anti_aim_indication_c.last_sent
            end)())
            local text_size = render.get_text_size(fonts.verdana.shadow, text)

            local width = text_size.x + 8

            x = x - width

            render.push_alpha_modifier(fakelag)
            render_c.container(vec2_t(x, y), vec2_t(width, height), color_t(r, g, b, 255), ui_widgets.style:get(), false)
            render.text(fonts.verdana.shadow, text, vec2_t(x + 4, y + (height / 2) - (text_size.y / 2) + 1), color_t(255, 255, 255, 255))
            render.pop_alpha_modifier()

            x = x + width - (width + 5) * fakelag
        end

        if (fake > 0.01) then
            local text = ("FAKE (%.1f°)"):format(antiaim.get_max_desync_range())
            local text_size = render.get_text_size(fonts.verdana.shadow, text)

            local width = text_size.x + 8

            x = x - width + 3

            render.push_alpha_modifier(fake)
            render_c.container(vec2_t(x - 4, y), vec2_t(width, height), color_t(r, g, b, 255), ui_widgets.style:get(), false)
            render.text(fonts.verdana.shadow, text, vec2_t(x, y + (height / 2) - (text_size.y / 2) + 1), color_t(255, 255, 255, 255))
            render.pop_alpha_modifier()
        end
    end)
end

--- @item: Frequency Update Indication
local ilstate = {}

ilstate.request_time = global_vars.frame_time()
ilstate.frametime = global_vars.cur_time()

ilstate.frametimes = {}

ilstate.note = note_c.new("a_winput")

fnEnumDisplaySettingsA(0, 4294967295, pLpDevMode[0])

function ilstate.formatting(avg)
    if (avg < 1) then 
    	return ("%.2f"):format(avg) 
    end

    if (avg < 10) then 
    	return ("%.1f"):format(avg) 
    end

    return ("%d"):format(avg)
end

function ilstate.handle()
	ilstate.note:set_state(ui_widgets.switch:get() and ui_widgets.widgets:get(6))
    ilstate.note:get(function(id)
    	local accent_color = ui_widgets.accent:get()
		local r, g, b = accent_color.r, accent_color.g, accent_color.b

		local screen = render.get_screen_size()

	    if ((ilstate.request_time + 1) < global_vars.cur_time()) then
	        ilstate.frametime = global_vars.frame_time()
	        ilstate.request_time = global_vars.cur_time()

	        table.insert(ilstate.frametimes, 1, ilstate.frametime)

	        if (#ilstate.frametimes > 4) then
	            table.remove(ilstate.frametimes, #ilstate.frametimes)
	        end
    	end

        local avg = math.abs(ilstate.frametime * 1000)
        local display_frequency = tonumber(pLpDevMode[0].dmDisplayFrequency)
		local text = ("%sms / %dhz"):format(ilstate.formatting(math.min(avg, display_frequency)), display_frequency)

		local text_size = render.get_text_size(fonts.verdana.shadow, text)

		local height, width	= 22, text_size.x + 8
		local x, y = screen.x, 8 + (27*id)

		x = x - width - 10

		render_c.container(vec2_t(x, y), vec2_t(width, height), color_t(r, g, b, 255), ui_widgets.style:get(), false)

        render.rect_fade(vec2_t(x, y + (height - 1)), vec2_t((width / 2), 1), color_t(0, 0, 0, 25), color_t(r, g, b, 255), true)
        render.rect_fade(vec2_t(x + (width / 2), y + (height - 1)), vec2_t(width - (width / 2), 1), color_t(r, g, b, 255), color_t(0, 0, 0, 25), true)

        render.text(fonts.verdana.shadow, text, vec2_t(x + (width / 2) - (text_size.x / 2), y + (height / 2) - (text_size.y / 2)), color_t(255, 255, 255, 255))

        local text = "IO | "
        local sub = text .. "\x20\x20\x20\x20\x20\x20\x20"

        local text_size = render.get_text_size(fonts.verdana.shadow, sub)

        local height, width = 22, text_size.x + 8
        local ie_width = render.get_text_size(fonts.verdana.shadow, text).x + 4

        render_c.container(vec2_t(x - width - 6, y), vec2_t(width, height), color_t(r, g, b, 255), ui_widgets.style:get(), false)

        render.text(fonts.verdana.shadow, text, vec2_t(x - width, y + (height / 2) - (text_size.y / 2)), color_t(255, 255, 255, 255))

        for key, value in ipairs(ilstate.frametimes) do
        	local height = math.max(2, math.floor(math.min((text_size.y - 1),  (value / 1) * 1000)))

        	render.rect_fade(vec2_t(x - width + ie_width - (5 * key) + 15, y + 16 - (height - 1)), vec2_t(5, height - 1), color_t(r, g, b, 0), color_t(r, g, b, 255), false)
        end
    end)
end

--- @item: Indicators
local indicators_c = {}

function indicators_c.handle()
	if (not ui_widgets.widgets:get(7) or not ui_widgets.switch:get()) then
		return
	end

    local player = entity_list.get_local_player()

    if (player == nil or not player:is_alive()) then
        return
    end

    local scoped = player:get_prop("m_bIsScoped") > 0

	local accent_color = ui_widgets.accent:get()
	local r, g, b = accent_color.r, accent_color.g, accent_color.b

	local condition_name = engine.get_condition_name(engine.get_condition()):upper()

	local blink = math.sin(math.abs(-math.pi + (global_vars.cur_time() * 2) % (math.pi * 2)))

	local desync_side = {
		[0] = "O",
		[1] = "R",
		[2] = "L"
	}

    local list = {
    	[1] = {
	        {text = {{text = script_name:upper()},{text = (" %s"):format(script_type:upper()), color = color_t(r, g, b)}}},
	        {bar = {value = antiaim.get_max_desync_range(), max_value = 58, color = color_t(r, g, b)}},
	        {text = condition_name, text_color = color_t(r, g, b)},
	        {text = "DT", state = e_binds.DOUBLE_TAP[2]:get()},
	        {text = "HS", state = e_binds.HIDE_SHOTS[2]:get()},
	        {text = "DMG", state = e_binds.MIN_DMG[2]:get()},
	        {text = "PING", state = e_binds.FAKE_PING[2]:get()}
	    },

	    [2] = {
	    	{text = {{text = script_name:upper()},{text = (" %s"):format(script_type:upper()), color = color_t(r, g, b), alpha = blink}}},
	    	--{text = condition_name, text_color = color_t(r, g, b)},
	    	{text = {
	    		{text = "FAKE YAW: ", color = color_t(r, g, b)},
	    		{text = desync_side[antiaim.get_desync_side()]}
	    	}},
	    	{text = "DT", text_color = exploits.get_charge() > 1 and color_t(27, 225, 52) or color_t(255, 47, 72), state = e_binds.DOUBLE_TAP[2]:get()},
	        {text = "HS", state = e_binds.HIDE_SHOTS[2]:get()},
	        {text = "DMG", state = e_binds.MIN_DMG[2]:get()},
	        {text = "PING", state = e_binds.FAKE_PING[2]:get()}
	    },

	    [3] = {
	    	{text = script_type:upper()},
	    	{text = script_name:upper()},
	    	{text = ("%s%%"):format(antiaim.get_max_desync_range())},
	    	{text = "DT", alpha = exploits.get_charge() > 1 and 1 or 0.5, state = e_binds.DOUBLE_TAP[2]:get()},
	    	{text = {
	    		{text = "HS  ", alpha = e_binds.HIDE_SHOTS[2]:get() and 1 or 0.5},
	    		{text = "DMG  ", alpha = e_binds.MIN_DMG[2]:get() and 1 or 0.5},
	    		{text = "PING  ", alpha = e_binds.FAKE_PING[2]:get() and 1 or 0.5}
	    	}}
	    }
    }

    local screen = render.get_screen_size()

    local additional = ui_settings.indicators_offset:get()
    local scope_additional = 4
    local x, y = screen.x / 2, (screen.y / 2) + additional

    local offset = 0
    for key, value in ipairs(list[ui_widgets.indicators_style:get()]) do
        if (value.state == nil) then
            value.state = true
        end

        if (value.text_color == nil) then
            value.text_color = color_t(255, 255, 255)
        end

        if (value.alpha == nil) then
        	value.alpha = 1
        end

        local t_r, t_g, t_b = value.text_color.r, value.text_color.g, value.text_color.b

        local alpha = animation.create(("indicators [alpha] [index: %s]"):format(key), value.state and 1 or 0, 12)

        render.push_alpha_modifier(alpha * value.alpha)
        if (type(value.text) == "table" and value.text ~= nil) then
            local text_size = render_c.get_multitext_width(fonts.small.outline, value.text)
            local scope_x = animation.create(("indicators [scope x|table] [index: %s]"):format(key), scoped and x + scope_additional or x - (text_size / 2), 12)

            render_c.multitext(fonts.small.outline, vec2_t(scope_x, y + offset), value.text)
        elseif (type(value.text) == "string" and value.text ~= nil) then
        	local text_size = render.get_text_size(fonts.small.outline, tostring(value.text))
        	local scope_x = animation.create(("indicators [scope x|string] [index: %s]"):format(key), scoped and x + scope_additional or x - (text_size.x / 2), 12)

        	render.text(fonts.small.outline, value.text, vec2_t(scope_x, y + offset), color_t(t_r, t_g, t_b, 255))
      	end

        if (value.bar ~= nil) then
            local bar_color = value.bar.color ~= nil and value.bar.color or color_t(255, 255, 255)
            local b_r, b_g, b_b = bar_color.r, bar_color.g, bar_color.b

            local bar_width = value.bar.width or 50
            local bar_anim_value = animation.create(("indicators [bar width] [index: %s]"):format(key), (value.bar.value / value.bar.max_value) * bar_width, 8)

            local scope_x = animation.create(("indicators [scope x|bar] [index: %s]"):format(key), scoped and x + scope_additional or x - (bar_width / 2), 12)

            render.rect_filled(vec2_t(scope_x, y + offset + 1), vec2_t(bar_width, 5), color_t(12, 12, 12, 255))
            render.rect_fade(vec2_t(scope_x + 1, y + offset + 2), vec2_t(bar_anim_value - 2, 5 - 2), color_t(b_r, b_g, b_b, 255), color_t(b_r, b_g, b_b, 0), true)
        end
        render.pop_alpha_modifier()

        offset = offset + (value.bar ~= nil and 6 or 8) * alpha
    end
end

--- @item: Manual Arrows
local arrows_c = {}

function arrows_c.handle()
	if (not ui_widgets.manual_arrows:get() or not ui_widgets.switch:get()) then
		return
	end

	local player = entity_list.get_local_player()

	if (player == nil or not player:is_alive()) then
		return
	end

	local scoped = player:get_prop("m_bIsScoped") > 0

	local manual_arrows_color = ui_widgets.manual_arrows_color:get()
	local manual_arrows_inverted_color = ui_widgets.manual_arrows_inverted_color:get()

	local left_active_color = antiaim.get_manual_override() == 1 and manual_arrows_color or color_t(17, 17, 17, 130)
	local right_active_color = antiaim.get_manual_override() == 3 and manual_arrows_color or color_t(17, 17, 17, 130)

    local inverted_left_color = antiaim.get_desync_side() == 2 and color_t(17, 17, 17, 130) or manual_arrows_inverted_color
    local inverted_right_color = antiaim.get_desync_side() == 2 and manual_arrows_inverted_color or color_t(17, 17, 17, 130)

    local distance = 43
    local size = 14

    local scope_anim = animation.create("manual arrows [scope]", scoped and 1 or 0, ui_settings.manual_arrows_animation_speed:get())
    local additional = 20

    local screen = render.get_screen_size()

    local x, y = screen.x / 2, screen.y / 2 - (additional * scope_anim)

    render.polygon({vec2_t(x - distance, y - (size - 5)), vec2_t(x - (distance + size), y), vec2_t(x - distance, y + (size - 5))}, left_active_color)
    render.polygon({vec2_t(x + distance, y - (size - 5)), vec2_t(x + (distance + size), y), vec2_t(x + distance, y + (size - 5))}, right_active_color)

    render.rect_filled(vec2_t(x - (distance - 2), y - (size - 4)), vec2_t(2, size + 6), inverted_left_color)
    render.rect_filled(vec2_t(x + (distance - 4), y - (size - 4)), vec2_t(2, size + 6), inverted_right_color)
end

--- @item: Hit Log
local hit_log_c = {}

hit_log_c.groups = {"head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "gear"}
hit_log_c.list = {}

hit_log_c.hitchance = 0

function hit_log_c.shoot_event(event)
	hit_log_c.hitchance = event.hitchance
end

function hit_log_c.hit_event(event)
	if (event.player == nil) then
		return
	end

    local color_hit = ui_widgets.manage_color:get() and ui_widgets.hit_color:get() or color_t(47, 255, 72, 255)

    local text = {
        {text = "Hit "},
        {text = event.player:get_name(), color = color_hit},
        {text = " in the "},
        {text = hit_log_c.groups[event.hitgroup] or "?", color = color_hit},
        {text = " for "},
        {text = tostring(event.damage), color = color_hit},
        {text = " damage ("},
        {text = tostring(event.player:get_prop("m_iHealth")), color = color_hit},
        {text = " health remaining)"}
    }

    table.insert(hit_log_c.list, 1, {text = text, time = 6, alpha = 0, animate = -90})
end

function hit_log_c.miss_event(event)
	if (event.player == nil) then
		return
	end

	local color_miss = ui_widgets.manage_color:get() and ui_widgets.miss_color:get() or color_t(255, 150, 150, 255)

	local text = {
		{text = "Missed "},
		{text = event.player:get_name(), color = color_miss},
		{text = "`s "},
		{text = hit_log_c.groups[event.aim_hitgroup] or "?", color = color_miss},
		{text = " due to "},
		{text = event.reason_string, color = color_miss},
		{text = " ("},
		{text = tostring(hit_log_c.hitchance), color = color_miss},
		{text = "% HC)"}
	}

	table.insert(hit_log_c.list, 1, {text = text, time = 6, alpha = 0, animate = -90})
end

function hit_log_c.handle()
	if (not ui_widgets.hit_log:get() or not ui_widgets.switch:get()) then
		return
	end

	local player = entity_list.get_local_player()

	if (player == nil or not player:is_alive()) then
		hit_log_c.list = {}

		return
	end

	local screen = render.get_screen_size()

    local additional = ui_settings.hit_log_offset:get()
    local x, y = screen.x / 2, (screen.y / 2) + additional

    local offset = 0
    for key, value in ipairs(hit_log_c.list) do
        value.time = value.time - global_vars.frame_time()

        value.alpha = animation.lerp(value.alpha, value.time <= 0 and 0 or 1, 12)
        value.animate = animation.lerp(value.animate, value.time <= 0.1 and 90 or 0, ui_settings.hit_log_animation_speed:get())

        local text_size = render_c.get_multitext_width(fonts.verdana.shadow, value.text)

        render.push_alpha_modifier(value.alpha)
        render_c.multitext(fonts.verdana.shadow, vec2_t(x - (text_size / 2) + value.animate, y + offset), value.text)
        render.pop_alpha_modifier()

        if (#hit_log_c.list > 6 or value.alpha < 0.01) then
            table.remove(hit_log_c.list, key)
        end

        offset = offset + 13 * value.alpha
    end
end
--- @endregion

--- @region: config
local config_c = {}

--- @return: void
function config_c.export()
	local status, message = pcall(function()
		local items = {}

		for tab_name, group_value in pairs(menu_manager_items) do
			items[tab_name] = {}

			for group_name, item_value in pairs(group_value) do
				items[tab_name][group_name] = {}

				for item_name, value in pairs(item_value) do
					local temp = {}

					if (not value.to_save) then
						goto skip
					end

		            if (value.is_multi_selection) then
						local selection_value = {}
						
						local items = value.reference:get_items()
						
						for key, svalue in ipairs(items) do
							local data = value.reference:get(key)

							table.insert(selection_value, data)
						end

						temp.value = {selection = true, selection_value = selection_value}

						print(unpack(selection_value))
					else
						if (type(value.reference) == "table") then
							temp.value = value.reference[2]:get()
						else
							temp.value = value.reference:get()
						end

			            if (type(temp.value) == "userdata") then
			                temp.value = {temp.value.r, temp.value.g, temp.value.b, temp.value.a}
			            end
					end

		            if (temp.value == nil) then
		            	goto skip
		            end

		            items[tab_name][group_name][item_name] = temp
		            ::skip::
				end
			end
		end

		local config = json.encode(items)
		config = base64.encode(config)
		config = ("<%s>%s"):format(script_name, config)

		clipboard_c.export(config)

		client.log("Config exported to clipboard.")
	end)

	if (not status) then
		client.log("Failed to export config:", message)

		return
	end
end

--- @param: text: string
--- @return: void
function config_c.import(text)
	local status, message = pcall(function()
		text = text:gsub(("<%s>"):format(script_name), "")

		local config = base64.decode(text)
		config = json.parse(config)

		if (config == nil) then
			error("Wrong config")

			return
		end

		for tab_name, group_value in pairs(config) do
			for group_name, item_value in pairs(group_value) do
				for item_name, config_value in pairs(item_value) do
					local item = menu_manager_items[tab_name][group_name][item_name]

					if (item == nil or config_value.value == nil) then
						goto skip
					end
 
					if (type(config_value.value) == "table") then
						if (config_value.value.selection) then
							for key, value in pairs(config_value.value.selection_value) do
								item.reference:set(key, value)
							end
						end

						if (type(item.reference) == "table") then
							item.reference[2]:set(color_t(unpack(config_value.value)))
						end
					else
						if (type(item.reference) ~= "table") then
							item.reference:set(config_value.value)
						end
					end

					::skip::
				end
			end
		end

		client.log("Config successfully loaded!")
	end)

	if (not status) then
		client.log("Failed to import config:", message)

		return
	end
end

ui_global.export_button = menu_manager_c.new("Global", "Main", "Export config to clipboard", false):button(config_c.export)
ui_global.import_button = menu_manager_c.new("Global", "Main", "Import config from clipboard", false):button(function()
	local data = clipboard_c.import()
    
	config_c.import(data)
end)
ui_global.import_default_button = menu_manager_c.new("Global", "Main", "Load Default Config", false):button(function()
	--- pizdec
	local data = "<youtuberi.lua>eyJHbG9iYWwiOnsiTWFpbiI6W119LCJBbnRpLUFpbSI6eyJDb25kaXRpb24gQW50aS1BaW0iOnsiW1J1bm5pbmddIEppdHRlciBBZGQiOnsidmFsdWUiOjYyfSwiW1NoYXJlZF0gQm9keSBMZWFuIFZhbHVlIjp7InZhbHVlIjowfSwiW0Fpcl0gSml0dGVyIFR5cGUiOnsidmFsdWUiOjN9LCJDdXJyZW50IENvbmRpdGlvbiI6eyJ2YWx1ZSI6M30sIltDcm91Y2hdIEJvZHkgTGVhbiBWYWx1ZSI6eyJ2YWx1ZSI6MH0sIltTaGFyZWRdIEJvZHkgTGVhbiI6eyJ2YWx1ZSI6MX0sIltDcm91Y2hdIERlc3luYyBTaWRlIjp7InZhbHVlIjo0fSwiW1dhbGtpbmddIEJvZHkgTGVhbiBKaXR0ZXIiOnsidmFsdWUiOjB9LCJbQWlyXSBPdmVycmlkZSI6eyJ2YWx1ZSI6dHJ1ZX0sIltSdW5uaW5nXSBKaXR0ZXIgVHlwZSI6eyJ2YWx1ZSI6M30sIltTdGFuZGluZ10gT3ZlcnJpZGUiOnsidmFsdWUiOnRydWV9LCJbUnVubmluZ10gRGVzeW5jIEFtb3VudCI6eyJ2YWx1ZSI6NjB9LCJbU3RhbmRpbmddIFlhdyBCYXNlIjp7InZhbHVlIjo0fSwiW0Fpcl0gWWF3IEJhc2UiOnsidmFsdWUiOjN9LCJbV2Fsa2luZ10gWWF3IEJhc2UiOnsidmFsdWUiOjR9LCJbV2Fsa2luZ10gRGVzeW5jIEFtb3VudCI6eyJ2YWx1ZSI6NjB9LCJbU2hhcmVkXSBZYXcgQmFzZSI6eyJ2YWx1ZSI6MX0sIltTdGFuZGluZ10gRGVzeW5jIFNpZGUiOnsidmFsdWUiOjR9LCJbU3RhbmRpbmddIERpc2FibGUgSml0dGVyIE9uIE1hbnVhbCI6eyJ2YWx1ZSI6ZmFsc2V9LCJbU3RhbmRpbmddIEJvZHkgTGVhbiBWYWx1ZSI6eyJ2YWx1ZSI6MH0sIltTdGFuZGluZ10gRGVzeW5jIEFtb3VudCI6eyJ2YWx1ZSI6NjB9LCJbV2Fsa2luZ10gSml0dGVyIEFkZCI6eyJ2YWx1ZSI6Njh9LCJbUnVubmluZ10gQm9keSBMZWFuIEppdHRlciI6eyJ2YWx1ZSI6MH0sIltTaGFyZWRdIERpc2FibGUgSml0dGVyIE9uIE1hbnVhbCI6eyJ2YWx1ZSI6ZmFsc2V9LCJbU3RhbmRpbmddIEppdHRlciBUeXBlIjp7InZhbHVlIjozfSwiW1J1bm5pbmddIEJvZHkgTGVhbiI6eyJ2YWx1ZSI6MX0sIltDcm91Y2hdIERlc3luYyBBbW91bnQiOnsidmFsdWUiOjYwfSwiW1NoYXJlZF0gRGVzeW5jIEFtb3VudCI6eyJ2YWx1ZSI6MH0sIltXYWxraW5nXSBCb2R5IExlYW4iOnsidmFsdWUiOjF9LCJbQ3JvdWNoXSBPdmVycmlkZSI6eyJ2YWx1ZSI6dHJ1ZX0sIltTdGFuZGluZ10gQm9keSBMZWFuIjp7InZhbHVlIjoxfSwiW1NoYXJlZF0gSml0dGVyIEFkZCI6eyJ2YWx1ZSI6MH0sIltDcm91Y2hdIEJvZHkgTGVhbiBKaXR0ZXIiOnsidmFsdWUiOjB9LCJbV2Fsa2luZ10gRGVzeW5jIFNpZGUiOnsidmFsdWUiOjF9LCJbU3RhbmRpbmddIFlhdyBBZGQiOnsidmFsdWUiOi0xfSwiW0Nyb3VjaF0gQm9keSBMZWFuIjp7InZhbHVlIjoxfSwiW1J1bm5pbmddIERlc3luYyBTaWRlIjp7InZhbHVlIjo0fSwiW1J1bm5pbmddIE92ZXJyaWRlIjp7InZhbHVlIjp0cnVlfSwiW1NoYXJlZF0gT3ZlcnJpZGUiOnsidmFsdWUiOmZhbHNlfSwiW1J1bm5pbmddIFlhdyBCYXNlIjp7InZhbHVlIjozfSwiW0Fpcl0gRGlzYWJsZSBKaXR0ZXIgT24gTWFudWFsIjp7InZhbHVlIjp0cnVlfSwiW0Nyb3VjaF0gWWF3IEFkZCI6eyJ2YWx1ZSI6OH0sIltBaXJdIEJvZHkgTGVhbiBKaXR0ZXIiOnsidmFsdWUiOjB9LCJbUnVubmluZ10gQm9keSBMZWFuIFZhbHVlIjp7InZhbHVlIjowfSwiW0Fpcl0gRGVzeW5jIEFtb3VudCI6eyJ2YWx1ZSI6NjB9LCJbQ3JvdWNoXSBKaXR0ZXIgVHlwZSI6eyJ2YWx1ZSI6M30sIltTaGFyZWRdIFlhdyBBZGQiOnsidmFsdWUiOjB9LCJbU2hhcmVkXSBCb2R5IExlYW4gSml0dGVyIjp7InZhbHVlIjowfSwiW1NoYXJlZF0gRGVzeW5jIFNpZGUiOnsidmFsdWUiOjF9LCJbU3RhbmRpbmddIEppdHRlciBBZGQiOnsidmFsdWUiOjU4fSwiW1dhbGtpbmddIEppdHRlciBUeXBlIjp7InZhbHVlIjozfSwiW1N0YW5kaW5nXSBCb2R5IExlYW4gSml0dGVyIjp7InZhbHVlIjowfSwiW1dhbGtpbmddIERpc2FibGUgSml0dGVyIE9uIE1hbnVhbCI6eyJ2YWx1ZSI6ZmFsc2V9LCJbQ3JvdWNoXSBKaXR0ZXIgQWRkIjp7InZhbHVlIjo1Nn0sIltBaXJdIEppdHRlciBBZGQiOnsidmFsdWUiOjU3fSwiW1dhbGtpbmddIE92ZXJyaWRlIjp7InZhbHVlIjp0cnVlfSwiW0Nyb3VjaF0gWWF3IEJhc2UiOnsidmFsdWUiOjN9LCJbQWlyXSBCb2R5IExlYW4iOnsidmFsdWUiOjF9LCJbV2Fsa2luZ10gWWF3IEFkZCI6eyJ2YWx1ZSI6OX0sIltDcm91Y2hdIERpc2FibGUgSml0dGVyIE9uIE1hbnVhbCI6eyJ2YWx1ZSI6ZmFsc2V9LCJbUnVubmluZ10gRGlzYWJsZSBKaXR0ZXIgT24gTWFudWFsIjp7InZhbHVlIjpmYWxzZX0sIltBaXJdIEJvZHkgTGVhbiBWYWx1ZSI6eyJ2YWx1ZSI6MH0sIltBaXJdIFlhdyBBZGQiOnsidmFsdWUiOjB9LCJbQWlyXSBEZXN5bmMgU2lkZSI6eyJ2YWx1ZSI6NH0sIltXYWxraW5nXSBCb2R5IExlYW4gVmFsdWUiOnsidmFsdWUiOjB9LCJbUnVubmluZ10gWWF3IEFkZCI6eyJ2YWx1ZSI6MH0sIltTaGFyZWRdIEppdHRlciBUeXBlIjp7InZhbHVlIjoxfX0sIkFudGktQWltIjp7IkFuaW1hdGlvbiBCcmVha2VycyI6eyJ2YWx1ZSI6eyJzZWxlY3Rpb25fdmFsdWUiOlt0cnVlLGZhbHNlLGZhbHNlLHRydWUsZmFsc2VdLCJzZWxlY3Rpb24iOnRydWV9fSwiTWFzdGVyIFN3aXRjaCI6eyJ2YWx1ZSI6dHJ1ZX0sIkFudGktQWltIE1vZGUiOnsidmFsdWUiOjJ9fX0sIlJhZ2Vib3QiOnsiUmFnZWJvdCI6eyJNaW5pbXVtIERhbWFnZSI6eyJ2YWx1ZSI6NX0sIkVuYWJsZSBEb3JtYW50IEFpbWJvdCI6eyJ2YWx1ZSI6dHJ1ZX0sIkF1dG8gU2NvcGUiOnsidmFsdWUiOnRydWV9LCJUZWFtIENoZWNrIjp7InZhbHVlIjp0cnVlfX19LCJXaWRnZXRzIjp7IldpZGdldHMiOnsiTWFudWFsIEFycm93cyBDb2xvciI6eyJ2YWx1ZSI6WzAsMCwwLDIyMF19LCJXaWRnZXRzIjp7InZhbHVlIjp7InNlbGVjdGlvbl92YWx1ZSI6W3RydWUsdHJ1ZSx0cnVlLHRydWUsZmFsc2UsdHJ1ZSx0cnVlXSwic2VsZWN0aW9uIjp0cnVlfX0sIk1hbmFnZSBDb2xvcnMiOnsidmFsdWUiOnRydWV9LCJJbmRpY2F0b3JzIFN0eWxlIjp7InZhbHVlIjoyfSwiTWFzdGVyIFN3aXRjaCI6eyJ2YWx1ZSI6dHJ1ZX0sIlsgS2V5YmluZHMgXSB4Ijp7InZhbHVlIjoxNTJ9LCJNYW51YWwgQXJyb3dzIEludmVydGVkIENvbG9yIjp7InZhbHVlIjpbMTczLDE3OSwyNTUsMjU1XX0sIldpbmRvd3MgU3R5bGUiOnsidmFsdWUiOjJ9LCJFbmFibGUgTWFudWFsIEFycm93cyI6eyJ2YWx1ZSI6dHJ1ZX0sIkVuYWJsZSBIaXQgTG9nIjp7InZhbHVlIjp0cnVlfSwiTWlzcyBDb2xvciI6eyJ2YWx1ZSI6WzI1NSwxNzMsMTczLDI1NV19LCJBY2NlbnQiOnsidmFsdWUiOlsxNzMsMTc5LDI1NSwyNTVdfSwiWyBLZXliaW5kcyBdIHkiOnsidmFsdWUiOjQyNn0sIkhpdCBDb2xvciI6eyJ2YWx1ZSI6WzE3MywxNzksMjU1LDI1NV19fX0sIlNldHRpbmdzIjp7IkFuaW1hdGlvbiI6eyJIaXQgTG9nIEFuaW1hdGlvbiBTcGVlZCI6eyJ2YWx1ZSI6MjB9LCJNYW51YWwgQXJyb3dzIEFuaW1hdGlvbiBTcGVlZCI6eyJ2YWx1ZSI6MTZ9LCJTb2x1cyBBbmltYXRpb24gU3BlZWQiOnsidmFsdWUiOjE4fX0sIk90aGVyIjp7IkluZGljYXRvcnMgT2Zmc2V0Ijp7InZhbHVlIjoyMH0sIkhpdCBMb2cgT2Zmc2V0Ijp7InZhbHVlIjozMDB9fX19"
	
	config_c.import(data)
end)
--- @endregion

--- @region: callbacks
--- @callback: paint
callbacks.add(e_callbacks.PAINT, menu_manager_c.visible)

callbacks.add(e_callbacks.PAINT, watermark_c.handle)
callbacks.add(e_callbacks.PAINT, keybinds_c.handle)
callbacks.add(e_callbacks.PAINT, hit_log_c.handle)
callbacks.add(e_callbacks.PAINT, indicators_c.handle)
callbacks.add(e_callbacks.PAINT, anti_aim_indication_c.handle)
callbacks.add(e_callbacks.PAINT, arrows_c.handle)
callbacks.add(e_callbacks.PAINT, ilstate.handle)

--- @callback: aimbot
callbacks.add(e_callbacks.AIMBOT_HIT, hit_log_c.hit_event)
callbacks.add(e_callbacks.AIMBOT_MISS, hit_log_c.miss_event)
callbacks.add(e_callbacks.AIMBOT_SHOOT, hit_log_c.shoot_event)

--- @callback: anti-aim
callbacks.add(e_callbacks.ANTIAIM, anim_breaker.handle)
callbacks.add(e_callbacks.ANTIAIM, condition_anti_aim.handle)

--- @callback: other
callbacks.add(e_callbacks.SHUTDOWN, function()
	watermark_c.note:unload()
	anti_aim_indication_c.note:unload()
end)
callbacks.add(e_callbacks.SETUP_COMMAND, anti_aim_indication_c.setup_command)
callbacks.add(e_callbacks.SETUP_COMMAND, dormant_aimbot.handle)

--- @callback: event
callbacks.add(e_callbacks.EVENT, dormant_aimbot.resetter, "round_prestart")
--- @endregion