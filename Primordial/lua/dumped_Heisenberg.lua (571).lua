--- @region: dependencies
--- @info: Assert.
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

local function watermarkDraw()
    return ""
end

callbacks.add(e_callbacks.DRAW_WATERMARK, watermarkDraw)

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
local json = require "JSON"
local base64 = require "Base64"
local panorama = require "Panorama"
local avatars = require "Avatars"

--- @region: enumerations
local e_conditions = {
    GLOBAL = 1,
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
	ANTIAIM_ENABLE = menu.find("antiaim", "main", "general", "enable"),
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

    FAKELAG_AMOUNT = menu.find("antiaim", "main", "fakelag", "amount"),

	MENU_ACCENT = menu.find("misc", "main", "config", "accent color")[2]
}

local e_binds = {
    DOUBLE_TAP = menu.find("aimbot", "general", "exploits", "doubletap", "enable"),
    HIDE_SHOTS = menu.find("aimbot", "general", "exploits", "hideshots", "enable"),
    MIN_DMG = menu.find("aimbot", "scout", "target overrides", "force min. damage"),
	HITCHANCE = menu.find("aimbot", "scout", "target overrides", "force hitchance"),
    AUTO_PEEK = menu.find("aimbot", "general", "misc", "autopeek"),
    FAKE_DUCK = menu.find("antiaim", "main", "general", "fake duck"),
    INVERT = menu.find("antiaim", "main", "manual", "invert desync"),
    SLOW_WALK = menu.find("misc", "main", "movement", "slow walk"),
    FAKE_PING = menu.find("aimbot", "general", "fake ping", "enable"),
    FREESTAND = menu.find("antiaim", "main", "auto direction", "enable"),
    EXTENDED_ANGLES = menu.find("antiaim", "main", "extended angles", "enable"),
    BODY_LEAN_RESOLVER = menu.find("aimbot", "general", "aimbot", "body lean resolver")
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
    tab = tab or "Visuals"
    group = group or "Visuals"

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
    if (package.NecronNotes == nil) then 
        package.NecronNotes = {}
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

    for key, value in note_c.sort(package.NecronNotes) do
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
    package.NecronNotes[self.name] = value

    table.sort(package.NecronNotes)
end

--- @return: void
function note_c:unload()
    if (package.NecronNotes[self.name] ~= nil) then 
        package.NecronNotes[self.name] = nil 
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

	local blink = math.sin(math.abs(-math.pi + (global_vars.cur_time() * 2) % (math.pi * 2)))

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
	elseif (style == 3) then
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
		return e_conditions.GLOBAL
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
    if (con_id == nil) then
        con_id = e_conditions.GLOBAL
    end
    
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

--- @region: entity
--- @return: number
function entity_t.get_body_yaw(player)
	local pose = player:get_prop("m_flPoseParameter", 11)

	return math.floor(math.min(60, (pose * 120 - 60)))
end
--- @endregion

--- @region: engine
--- @return: number
function engine.get_condition()
	local player = entity_list.get_local_player()

	if (player == nil or not player:is_alive()) then
		return e_conditions.GLOBAL
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
    if (con_id == nil) then
        con_id = e_conditions.GLOBAL
    end
    
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

--- @param: type: number
--- @return: entity
function engine.get_closet_enemy(type)
	local player = entity_list.get_local_player()

	if (player == nil or not player:is_alive()) then
		return
	end

	local players = entity_list.get_players(true)

	if (players == nil and #players < 1) then
		return
	end

	if (type == nil) then
		type = 2
	end

	local target = nil

	if (type == 2) then
		local fov = 180

		local eye_pos = player:get_eye_position()
		local view_angles = engine.get_view_angles()

		for key, enemy in pairs(players) do 
			local origin = enemy:get_render_origin()

			local current_fov = math.abs(math.normalize_yaw(math.world_to_screen(eye_pos.x - origin.x, eye_pos.y - origin.y) - view_angles.y + 180))

	        if (current_fov < fov) then
	            fov = current_fov

	            target = enemy
	        end
		end
	elseif (type == 3) then
		local player_origin = player:get_render_origin()

	    local distance = 10000

	    for key, enemy in pairs(players) do 
	        local origin = enemy:get_render_origin()

	        local cur_distance = vector.dist_to(origin, player_origin)

	        if (cur_distance < distance) then
	            distance = cur_distance

	            target = enemy
	        end
	    end
	end

	return target
end
--- @endregion

local ui_global = {}

ui_global.welcome = menu_manager_c.new("Global", "Main", ("Welcome, %s!"):format(user.name)):text()
ui_global.welcome = menu_manager_c.new("Global", "Main", ("Updated: 11/1/2022 05:09 PM"):format(user.name)):text()
ui_global.discord_link = menu_manager_c.new("Global", "Main", "Discord"):button(function()
	panorama.eval[[
		SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/Reqz42vKqM")
	]]
end)

--- @region: unnamed
--- @element: script vars
local script_name = "Heisenberg"
local script_type = "DEBUG"
local script_color = color_t(255, 192, 118, 255)

--- @element: fonts
local fonts = {}

fonts.verdana = {}
fonts.verdana.shadow = render.create_font("Verdana", 12, 400, e_font_flags.DROPSHADOW)

fonts.small = {}
fonts.small.outline = render.create_font("Small Fonts", 8, 400, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE)

fonts.arial = {}
fonts.arial.main = render.create_font("Arial", 14, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

fonts.icons = {}
fonts.icons.warning = render.create_font("Nadofont", 29, 100, e_font_flags.ANTIALIAS)
--- @endregion

--- @region: ui
--- @group: Anti-Aim
local ui_anti_aim = {}

ui_anti_aim.switch = menu_manager_c.new("Anti-Aim", "Anti-Aim", "Master Switch"):checkbox()
ui_anti_aim.switch_condition = function() return ui_anti_aim.switch:get() end

ui_anti_aim.mode = menu_manager_c.new("Anti-Aim", "Anti-Aim", "Anti-Aim Mode", true, ui_anti_aim.switch_condition):selection("None", "Condition")
ui_anti_aim.animation_breakers = menu_manager_c.new("Anti-Aim", "Anti-Aim", "Animation Breakers", true, ui_anti_aim.switch_condition):multi_selection("Static Legs In Air", "Zero Pitch On Land", "Static Legs On Slow Walk", "Reverse Slide", "Body Lean")

--- @group: Visuals
local ui_Visuals = {}

ui_Visuals.switch = menu_manager_c.new("Visuals", "Visuals", "Master Switch"):checkbox()
ui_Visuals.switch_condition = function() return ui_Visuals.switch:get() end

ui_Visuals.Visuals_list = {"Watermark", "Keybinds", "Spectators", "Crosshair Indicators", "Slow Down Indicator", "Manual Arrows", "Hit Log"}
ui_Visuals.Visuals = menu_manager_c.new("Visuals", "Visuals", "Visuals", true, ui_Visuals.switch_condition):multi_selection(ui_Visuals.Visuals_list)

ui_Visuals.style = menu_manager_c.new("Visuals", "Visuals", "Windows Style", true, ui_Visuals.switch_condition, function()
	return ui_Visuals.switch_condition() and ui_Visuals.Visuals:get(1) or ui_Visuals.Visuals:get(2) or ui_Visuals.Visuals:get(3)
end):selection("Solus V1", "Solus V2", "Rounded")
ui_Visuals.indicators_style = menu_manager_c.new("Visuals", "Visuals", "Indicators Style", true, ui_Visuals.switch_condition, function()
	return ui_Visuals.Visuals:get(4)
end):selection("Default", "Modern", "Legacy")

ui_Visuals.custom_watermark_pos = menu_manager_c.new("Visuals", "Visuals", "Custom Watermark Position", true, function()
	return ui_Visuals.switch_condition() and ui_Visuals.Visuals:get(1)
end):checkbox()

--- @group: Other
local ui_other = {}

ui_other.clan_tag = menu_manager_c.new("Misc", "Misc", "Enable Clantag", true, ui_other.switch_condition):checkbox()
ui_other.info_panel = menu_manager_c.new("Misc", "Misc", "Enable Information Panel", true, ui_other.switch_condition):checkbox()

ui_Visuals.accent = menu_manager_c.new("Misc", "Misc", "Color", true, function()
	return ui_Visuals.switch_condition() and ui_Visuals.Visuals:get(1) or ui_Visuals.Visuals:get(2) or ui_Visuals.Visuals:get(3) or ui_Visuals.Visuals:get(4) or ui_Visuals.Visuals:get(5) or ui_Visuals.Visuals:get(6) or ui_Visuals.Visuals:get(7)
end):color_picker(script_color.r, script_color.g, script_color.b, script_color.a)

--- @region: anti-aim
--- @item: Anti-Aim Tweaks
local anti_aim_tweaks = {}

anti_aim_tweaks.cache = {}

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
		
        setup.yaw_add_type = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Yaw Add Type"), true, visible_condition):selection("Default", "Alternative")
        setup.yaw_add = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Yaw Add"), true, function()
            return visible_condition() and setup.yaw_add_type:get() == 1
        end):slider(-180, 180)
        setup.left_yaw_add = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Left Yaw Add"), true, function()
            return visible_condition() and setup.yaw_add_type:get() == 2
        end):slider(-180, 180)
        setup.right_yaw_add = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Right Yaw Add"), true, function()
            return visible_condition() and setup.yaw_add_type:get() == 2
        end):slider(-180, 180)

		setup.jitter_type = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Jitter Type"), true, visible_condition):selection("None", "Offset", "Center")
		local function jitter_type_condition()
			return visible_condition() and setup.jitter_type:get() ~= 1
		end
		setup.jitter_add_center = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Center Jitter Add"), true, function()
			return jitter_type_condition() and setup.jitter_type:get() == 3
		end):slider(-180, 180)
		setup.jitter_add_offset = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Offset Jitter Add"), true, function()
			return jitter_type_condition() and setup.jitter_type:get() == 2
		end):slider(0, 180)

		setup.disable_jitter = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Disable Jitter"), true, visible_condition):multi_selection("On Manual", "On Auto Direction")

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
		
		setup.desync_amount_type = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Desync Amount Type"), true, visible_condition):selection("Default", "Alternative")
		setup.desync_amount = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Desync Amount"), true, function()
			return visible_condition() and setup.desync_amount_type:get() == 1
		end):slider(0, 60)
		setup.left_desync_amount = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Left Desync Amount"), true, function()
			return visible_condition() and setup.desync_amount_type:get() == 2
		end):slider(0, 100)
		setup.right_desync_amount = menu_manager_c.new("Anti-Aim", "Condition Anti-Aim", name("Right Desync Amount"), true, function()
			return visible_condition() and setup.desync_amount_type:get() == 2
		end):slider(0, 100)
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

	local current_condition = engine.get_condition()
	local item = condition_anti_aim.list[current_condition]
	item = condition_anti_aim.conditions:get() == e_conditions.GLOBAL and condition_anti_aim.list[e_conditions.GLOBAL] or item

	if (not item.override:get()) then
		return
	end

    local is_manual = antiaim.get_manual_override() == 1 or antiaim.get_manual_override() == 2 or antiaim.get_manual_override() == 3
    local is_left = entity_t.get_body_yaw(player) > 0

	local yaw_add = 0
    if (item.yaw_add_type:get() == 1) then
        yaw_add = item.yaw_add:get()
    elseif (item.yaw_add_type:get() == 2) then
        yaw_add = is_left and item.left_yaw_add:get() or item.right_yaw_add:get()
    end

	if (item.jitter_type:get() == 1) then
		e_menu.YAW_ADD:set(yaw_add)
	end

    local setup_value = item.desync_side:get()
    if ((item.disable_jitter:get(1) and is_manual) or (item.disable_jitter:get(2) and e_binds.FREESTAND[2]:get())) then
    	setup_value = nil
    end

	e_menu.YAW_BASE:set(item.yaw_base:get())

	if (engine.get_choked_commands() == 0) then
		if (item.jitter_type:get() ~= 1 and setup_value ~= nil) then
			e_menu.JITTER_MODE:set(1)

			if (item.jitter_type:get() == e_jitter_type.OFFSET) then
				if (condition_anti_aim.switch) then
					condition_anti_aim.yaw = yaw_add
				else
					condition_anti_aim.yaw = yaw_add + item.jitter_add_offset:get()
				end
			elseif (item.jitter_type:get() == e_jitter_type.CENTER) then
				if (condition_anti_aim.switch) then
					condition_anti_aim.yaw = yaw_add - item.jitter_add_center:get() / 2
				else
					condition_anti_aim.yaw = yaw_add + item.jitter_add_center:get() / 2
				end
			end

			condition_anti_aim.switch = not condition_anti_aim.switch

			e_menu.YAW_ADD:set(condition_anti_aim.yaw)
		end
	end

    e_menu.BODY_LEAN:set(item.body_lean:get())
    e_menu.BODY_LEAN_VALUE:set(item.body_lean_value:get())
    e_menu.BODY_LEAN_JITTER:set(item.body_lean_jitter:get())

    e_menu.SIDE_STAND:set(setup_value == nil and 2 or setup_value)
    e_menu.SIDE_MOVE:set(setup_value == nil and 2 or setup_value)
    e_menu.SIDE_SLOW:set(setup_value == nil and 2 or setup_value)

    local desync_left_amount = 0
	local desync_right_amount = 0

	if (item.desync_amount_type:get() == 1) then
		desync_left_amount = (item.desync_amount:get() / 2) * (10 / 6)
		desync_right_amount = item.desync_amount:get() * (10 / 6)
	elseif (item.desync_amount_type:get() == 2) then
		desync_left_amount = item.left_desync_amount:get()
		desync_right_amount = item.right_desync_amount:get()
	end

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

local watermark_c = {}

watermark_c.note = note_c.new("a_watermark")
watermark_c.dragging = drag_c.new(0, 0, "Watermark")

function watermark_c.handle()
	watermark_c.note:set_state(ui_Visuals.Visuals:get(1) and ui_Visuals.switch:get())
	watermark_c.note:get(function(id)
		local accent_color = ui_Visuals.accent:get()
		local r, g, b = accent_color.r, accent_color.g, accent_color.b

		local pixel = render.create_font("Smallest Pixel-7", 10, 20)

        local hours, minutes, seconds = client.get_local_time()
        local actual_time = ("%02d:%02d:%02d"):format(hours, minutes, seconds)

        local nickname = user.name

        local text = {
            {text = ("HEISENBERG"):format(script_type), color = color_t(255, 255, 255, 255)},

            {text = (" | DEBUG"):format(nickname), color = color_t(255, 255, 255, 255)},
        }

        table.insert(text, {text = (" | %s"):format(actual_time)})

        local text_width, text_height = render_c.get_multitext_width(fonts.verdana.shadow, text), 12

        local x, y = render.get_screen_size().x, 8 + (27*id)

        local width, height = animation.create("watermark [width]", text_width + 10, 8), 22

        x = x - width - 10

        if (ui_Visuals.custom_watermark_pos:get()) then
        	x, y = watermark_c.dragging:get()
        end
 
        render_c.container(vec2_t(x, y), vec2_t(width, height), color_t(r, g, b, 255), ui_Visuals.style:get())
        render_c.multitext(fonts.verdana.shadow, vec2_t(x + (width / 2) - (text_width / 2), y + (height / 2) - (text_height / 2)), text)

        if (ui_Visuals.custom_watermark_pos:get()) then
        	watermark_c.dragging:handle(width, height)
        end
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
    ["Extended Angles"] = e_binds.EXTENDED_ANGLES,
    ["Body Lean Resolver"] = e_binds.BODY_LEAN_RESOLVER,
	["Hitchance Override"] = e_binds.HITCHANCE,
}

keybinds_c.modes = { 
    [0] = "toggled",
    [1] = "holding",
    [2] = "holding",
    [3] = "always"
}

keybinds_c.dragging = drag_c.new(0, 0, "Keybinds")

local pixel = render.create_font("Smallest Pixel-7", 10, 20)

function keybinds_c.handle()
	if (not ui_Visuals.Visuals:get(2) or not ui_Visuals.switch:get()) then
		return
	end

	local accent_color = ui_Visuals.accent:get()
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

    		keybinds_c.active[bind_name].alpha = animation.lerp(keybinds_c.active[bind_name].alpha, 1, 8)
    		keybinds_c.active[bind_name].offset = bind_name_size.x

            keybinds_c.active[bind_name].active = true
        elseif (keybinds_c.active[bind_name] ~= nil) then
            keybinds_c.active[bind_name].alpha = animation.lerp(keybinds_c.active[bind_name].alpha, 0, 8)
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
			alpha = animation.create("keybinds [alpha|open menu]", menu.is_open() and 1 or 0, 8)
		}
	end

    local alpha = animation.create("keybinds [alpha]", (menu.is_open() or table.count(keybinds_c.active) > 0 and latest_item) and 1 or 0, 12)

    local text = "keybinds"
    local text_size = render.get_text_size(fonts.verdana.shadow, text)

    local x, y = keybinds_c.dragging:get()

    local width, height = animation.create("keybinds [width]", 75 + maximum_offset, 8), 22
    local height_offset = height + 4

    render.push_alpha_modifier(alpha)
    render_c.container(vec2_t(x, y), vec2_t(width, height), color_t(r, g, b, 255), ui_Visuals.style:get())
    render.text(fonts.verdana.shadow, text, vec2_t(x + (width / 2) - (text_size.x / 2), y + (height / 2) - (text_size.y / 2) + 1), color_t(255, 255, 255, 255))
    render.pop_alpha_modifier()
   	
   	for bind_name, value in pairs(keybinds_c.active) do
        local key_type = "[" .. (value.mode or "?") .. "]"
        local key_type_size = render.get_text_size(fonts.verdana.shadow, key_type)

        render.push_alpha_modifier(alpha*value.alpha)
        render.text(fonts.verdana.shadow, bind_name, vec2_t(x + 4, y + height_offset), color_t(255, 255, 255, 255))
        render.text(fonts.verdana.shadow, key_type, vec2_t(x + width - key_type_size.x - 4, y + height_offset), color_t(255, 255, 255, 255))
        render.pop_alpha_modifier()

        height_offset = height_offset + 15 * value.alpha
   	end

   	keybinds_c.dragging:handle(width, (table.count(keybinds_c.active) > 0 and ((3 + (15 * table.count(keybinds_c.active))) * 2) or height))
end

--- @item: Spectators
local spectators_c = {}

spectators_c.active = {}
spectators_c.unsorted = {}
spectators_c.contents = {}

spectators_c.dragging = drag_c.new(0, 0, "Spectators")

function spectators_c.get_players()
	local player = entity_list.get_local_player()

	if (player == nil) then
		return
	end

	local players, observing = {}, player

	for i = 1, global_vars.max_clients() do
		local ent = entity_list.get_entity(i)

		if (ent == nil) then
			goto skip
		end

		if (ent:get_class_name() == "CCSPlayer" and ent:is_player()) then
			local m_iObserverMode = ent:get_prop("m_iObserverMode")
			local m_hObserverTarget = entity_list.get_entity(ent:get_prop("m_hObserverTarget"))

			if (m_hObserverTarget ~= nil) then
				m_hObserverTarget = m_hObserverTarget:get_index()

				if (m_hObserverTarget ~= nil and m_hObserverTarget <= 64 and not ent:is_alive()) then
					if (players[m_hObserverTarget] == nil) then
						players[m_hObserverTarget] = {}
					end

					if (ent == player) then
						observing = m_hObserverTarget
					end

					table.insert(players[m_hObserverTarget], ent:get_index())
				end
			end
		end

		::skip::
	end

	local to_return = player
	if (type(observing) == "number" and observing ~= nil) then
		to_return = observing
	elseif (type(observing) ~= "number" and observing ~= nil) then
		to_return = observing:get_index()
	end

	to_return = to_return == nil and player:get_index() or to_return

	return players, to_return
end

function spectators_c.handle()
	if (not ui_Visuals.Visuals:get(3) or not ui_Visuals.switch:get()) then
		return
	end

	local accent_color = ui_Visuals.accent:get()
	local r, g, b = accent_color.r, accent_color.g, accent_color.b

	local latest_item = false
    local maximum_offset = 85

	local player = entity_list.get_local_player()
	local spectators, ent = spectators_c.get_players()

	if (ent == nil and player == nil) then
		return
	end

	for i = 1, 64 do 
		spectators_c.unsorted[i] = {
			idx = i,
			active = false
		}
	end

	if spectators[ent] ~= nil then
		for _, spectator in pairs(spectators[ent]) do
			spectators_c.unsorted[spectator] = {
				idx = spectator,
		
				active = (function()
					if (spectator == player) then
						return false
					end

					return true
				end)(),

				avatar = (function()
					local steamID3, steamID64 = entity_list.get_entity(spectator):get_steamids()
					local avatar = avatars.get(steamID64)

					if (avatar == nil) then
						return nil
					end

					if (spectators_c.contents[spectator] == nil) then
						spectators_c.contents[spectator] = {
							texture = avatar
						}
					end

					return spectators_c.contents[spectator].texture
				end)()
			}
		end
	end

	for _, c_ref in pairs(spectators_c.unsorted) do
		local c_id = c_ref.idx

		local c_entity = entity_list.get_entity(c_id)

		if (c_entity == nil) then
			goto skip
		end

		local c_nickname = c_entity:get_name()
		
		if (c_ref.active) then
			latest_item = true
		
			if (spectators_c.active[c_id] == nil) then
				spectators_c.active[c_id] = {alpha = 0, offset = 0, active = true}
			end

    		local spectator_name_size = render.get_text_size(fonts.verdana.shadow, c_nickname)

    		spectators_c.active[c_id].avatar = c_ref.avatar
			spectators_c.active[c_id].name = c_nickname

    		spectators_c.active[c_id].alpha = animation.lerp(spectators_c.active[c_id].alpha, 1, 10)
    		spectators_c.active[c_id].offset = spectator_name_size.x

            spectators_c.active[c_id].active = true
        elseif (spectators_c.active[c_id] ~= nil) then
            spectators_c.active[c_id].alpha = animation.lerp(spectators_c.active[c_id].alpha, 0, 10)
            spectators_c.active[c_id].active = false

            if (spectators_c.active[c_id].alpha < 0.1) then
                spectators_c.active[c_id] = nil
            end
    	end

        if (spectators_c.active[c_id] ~= nil and spectators_c.active[c_id].offset > maximum_offset) then
            maximum_offset = spectators_c.active[c_id].offset
        end

		::skip::
	end

    local alpha = animation.create("spectators [alpha]", (menu.is_open() or table.count(spectators_c.active) > 0 and latest_item) and 1 or 0, 12)

    local text = "spectators"
    local text_size = render.get_text_size(fonts.verdana.shadow, text)

    local x, y = spectators_c.dragging:get()

    local width, height = animation.create("spectators [width]", 75 + maximum_offset, 8), 22
    local height_offset = height + 4

	local right_offset = true

    render.push_alpha_modifier(alpha)
    render_c.container(vec2_t(x, y), vec2_t(width, height), color_t(r, g, b, 255), ui_Visuals.style:get())
    render.text(fonts.verdana.shadow, text, vec2_t(x + (width / 2) - (text_size.x / 2), y + (height / 2) - (text_size.y / 2) + 1), color_t(255, 255, 255, 255))
    render.pop_alpha_modifier()

	for c_name, value in pairs(spectators_c.active) do
		local text_size = render.get_text_size(fonts.verdana.shadow, value.name)

        render.push_alpha_modifier(alpha*value.alpha)
        render.text(fonts.verdana.shadow, value.name, vec2_t(x + ((value.avatar and not right_offset) and text_size.y or -5) + 10, y + height_offset), color_t(255, 255, 255, 255))

		if (value.avatar) then
			render.texture(value.avatar.id, vec2_t(x + (right_offset and width - 18 or 5), y + height_offset), vec2_t(text_size.y, text_size.y))
		end

        render.pop_alpha_modifier()

        height_offset = height_offset + 15 * value.alpha
   	end

   	spectators_c.dragging:handle(width, (table.count(spectators_c.active) > 0 and height_offset or height))
end

--- @item: Indicators
local indicators_c = {}

function indicators_c.handle()
	if (not ui_Visuals.Visuals:get(4) or not ui_Visuals.switch:get()) then
		return
	end

    local player = entity_list.get_local_player()

    if (player == nil or not player:is_alive()) then
        return
    end

    local scoped = player:get_prop("m_bIsScoped") > 0

	local accent_color = ui_Visuals.accent:get()
	local r, g, b = accent_color.r, accent_color.g, accent_color.b

	local condition_name = engine.get_condition_name(engine.get_condition()):upper()

	local blink = math.sin(math.abs(-math.pi + (global_vars.cur_time() * 2) % (math.pi * 2)))

	local body_yaw = entity_t.get_body_yaw(player)

	local desync_side = {
		[0] = "O",
		[1] = "R",
		[2] = "L"
	}

    local list = {
    	[1] = {
			{text = {
	    		{text = ("HEISENBERG"):format(script_type:upper()), color = color_t(255, 255, 255)},
	    		{text = (" DEBUG"):format(script_type:upper()), color = color_t(r, g, b, 100), alpha = blink}
	    	}},
			{bar = {value = antiaim.get_max_desync_range(), max_value = 58, color = color_t(r, g, b)}},
			{text = condition_name, text_color = color_t(r, g, b)},
			{text = "PING", state = e_binds.FAKE_PING[2]:get()},
			{text = "DMG", state = e_binds.MIN_DMG[2]:get()},
			{text = "HS", state = e_binds.HIDE_SHOTS[2]:get()},
			{text = "DT", text_color = exploits.get_charge() > 1 and color_t(27, 225, 52) or color_t(255, 47, 72), state = e_binds.DOUBLE_TAP[2]:get()}
	    },

	    [2] = {
			{text = {
	    		{text = ("HEISENBERG"):format(script_type:upper()), color = color_t(255, 255, 255)},
	    		{text = (" DEBUG"):format(script_type:upper()), color = color_t(r, g, b, 100), alpha = blink}
	    	}},
	    	{text = {
	    		{text = "FAKE YAW: ", color = color_t(r, g, b)},
	    		{text = desync_side[antiaim.get_desync_side()]}
	    	}},
			{text = "PING", state = e_binds.FAKE_PING[2]:get()},
			{text = "DMG", state = e_binds.MIN_DMG[2]:get()},
	        {text = "HS", state = e_binds.HIDE_SHOTS[2]:get()},
			{text = "DT", text_color = exploits.get_charge() > 1 and color_t(27, 225, 52) or color_t(255, 47, 72), state = e_binds.DOUBLE_TAP[2]:get()}
	    },

		[3] = {
			{text = {
	    		{text = ("HEISENBERG"):format(script_type:upper()), color = color_t(255, 255, 255)},
	    		{text = (" DEBUG"):format(script_type:upper()), color = color_t(r, g, b, 100), alpha = blink}
	    	}},
			{text = condition_name, text_color = color_t(r, g, b)},
	    	{text = {
	    		{text = "HS  ", alpha = e_binds.HIDE_SHOTS[2]:get() and 1 or 0.5},
				{text = "DT  ", alpha = exploits.get_charge() > 1 and 1 or 0.5, state = e_binds.DOUBLE_TAP[2]:get()},
				{text = "DMG  ", alpha = e_binds.MIN_DMG[2]:get() and 1 or 0.5},
				{text = "PING  ", alpha = e_binds.FAKE_PING[2]:get() and 1 or 0.5}
	    	}},
		}
    }

    local screen = render.get_screen_size()

    local additional = 20
    local scope_additional = 6
    local x, y = screen.x / 2, (screen.y / 2) + additional

    local offset = 0
    for key, value in ipairs(list[ui_Visuals.indicators_style:get()]) do
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


--- @item: Information Panel
local info_panel_c = {}

function info_panel_c.handle()
	if (not ui_other.info_panel:get()) then
		return
	end

	local player = entity_list.get_local_player()

	if (player == nil or not player:is_alive()) then
		return
	end

	local accent_color = ui_Visuals.accent:get()
	local r, g, b = accent_color.r, accent_color.g, accent_color.b

	local steamID3, steamID64 = player:get_steamids()
	local avatar = avatars.get(steamID64, 64)

	local screen = render.get_screen_size()

	local x, y = 5, screen.y / 2

	local avatar_size = vec2_t(35, 35)

	local condition_name = engine.get_condition_name(engine.get_condition()):upper()

	render.texture(avatar.id, vec2_t(x, y - (avatar_size.y / 2)), avatar_size)
	render.text(fonts.verdana.shadow, ("heisenberg.lua - version 1.2 debug - %s"):format(user.name), vec2_t(x + avatar_size.x + 5, y - (avatar_size.y / 2)), color_t(255, 255, 255))
	render.text(fonts.verdana.shadow, ("anti aim: side - %s [1 = left - 2 = right]"):format(antiaim.get_desync_side()), vec2_t(x + avatar_size.x + 5, y - ( 12.1 / 2)), color_t(255, 255, 255))
	render.text(fonts.verdana.shadow, ("player info state: %s"):format(condition_name), vec2_t(x + avatar_size.x + 5, y - ( -9.9 / 2)), color_t(255, 255, 255))

end

--- @item: Slowed Down
local slowd_down_c = {}

slowd_down_c.interval = 0

function slowd_down_c.convert_color(percentage)
    local r = math.floor(124*2 - 124 * percentage)
    local g = math.floor(195 * percentage)
    local b = math.floor(13)

    return r, g, b
end

function slowd_down_c.remap(val, newmin, newmax, min, max, clamp)
    min = min or 0
    max = max or 1

    local pct = (val-min)/(max-min)

    if clamp ~= false then
        pct = math.min(1, math.max(0, pct))
    end

    return newmin+(newmax-newmin)*pct
end

function slowd_down_c.bar(modifier, r, g, b, a, text)
    slowd_down_c.interval = slowd_down_c.interval + (1-modifier) * 0.7 + 0.3
    local wa = math.floor(math.abs(slowd_down_c.interval*0.025 % 2 - 1) * 255)
    
    local screen = render.get_screen_size()
    local x, y = screen.x / 2 - 95, screen.y*0.35
    
    render.text(fonts.icons.warning, "a", vec2_t.new(x + 25, y - 19), color_t(255, 255, 255, 255))
    render.text(fonts.arial.main, string.format("%s %d%%", text, modifier * 100), vec2_t.new(x + 57, y - 15), color_t.new(255, 255, 255, 255 * a))

    local rx, ry, rw, rh = x + 55, y, 95, 12
    render.rect(vec2_t.new(rx, ry), vec2_t.new(rw + 1, rh), color_t.new(0, 0, 0, 255))
    render.rect_filled(vec2_t.new(rx + 1, ry + 1), vec2_t.new(rw - 1, rh - 2), color_t.new(16, 16, 16, 180 * a))
    render.rect_filled(vec2_t.new(rx + 1, ry + 1), vec2_t.new(math.floor(modifier * 94), rh-2), color_t.new(r, g, b, 180 * a))
end

function slowd_down_c.handle()
	if (not ui_Visuals.Visuals:get(5) or not ui_Visuals.switch:get()) then
		return
	end

    local player = entity_list.get_local_player()

    if (player == nil or not player:is_alive()) then
        return
    end

    local modifier = player:get_prop("m_flVelocityModifier")

    if (modifier == 1) then
        return
    end

    local r, g, b = slowd_down_c.convert_color(modifier)
    local a = math.floor(slowd_down_c.remap(modifier, 1, 0, 1, 1))

    slowd_down_c.bar(modifier, r, g, b, a, "Slowed down")
end
--- @item: Manual Arrows
local arrows_c = {}

function arrows_c.handle()
	if (not ui_Visuals.Visuals:get(6) or not ui_Visuals.switch:get()) then
		return
	end

	local player = entity_list.get_local_player()

	if (player == nil or not player:is_alive()) then
		return
	end

	local scoped = player:get_prop("m_bIsScoped") > 0

	local body_yaw = entity_t.get_body_yaw(player)

	local accent_color = ui_Visuals.accent:get()
	local r, g, b = accent_color.r, accent_color.g, accent_color.b

	local left_active_color = antiaim.get_manual_override() == 1 and accent_color or color_t(17, 17, 17, 130)
	local right_active_color = antiaim.get_manual_override() == 3 and accent_color or color_t(17, 17, 17, 130)

    local inverted_left_color = antiaim.get_desync_side() == 2 and color_t(17, 17, 17, 130) or accent_color
    local inverted_right_color = antiaim.get_desync_side() == 2 and accent_color or color_t(17, 17, 17, 130)

    local distance = 43
    local size = 14

    local scope_anim = animation.create("manual arrows [scope]", scoped and 1 or 0, 15)
    local additional = 15

    local screen = render.get_screen_size()

    local x, y = screen.x / 2, screen.y / 2 - (additional * scope_anim)

    render.polygon({vec2_t(x - distance, y - (size - 5)), vec2_t(x - (distance + size), y), vec2_t(x - distance, y + (size - 5))}, left_active_color)
    render.polygon({vec2_t(x + distance, y - (size - 5)), vec2_t(x + (distance + size), y), vec2_t(x + distance, y + (size - 5))}, right_active_color)

    render.rect_filled(vec2_t(x - (distance - 2), y - (size - 4)), vec2_t(2, size + 6), inverted_left_color)
    render.rect_filled(vec2_t(x + (distance - 4), y - (size - 4)), vec2_t(2, size + 6), inverted_right_color)
end

--- @item: notify
local notify = {}

notify.list = {}

function notify.push(text)
	table.insert(notify.list, 1, {text = text, time = 6, alpha = 0})
end

function notify.handle()
	local accent_color = ui_Visuals.accent:get()
	local r, g, b = accent_color.r, accent_color.g, accent_color.b

	local screen = render.get_screen_size()

    local additional = 350
    local x, y = screen.x / 2, (screen.y / 2) + additional

    local space = 6
    local height = 27

    local offset = 0
    for key, value in ipairs(notify.list) do
        value.time = value.time - global_vars.frame_time()

        value.alpha = animation.lerp(value.alpha, value.time <= 0 and 0 or 1, 12)

        local prefix_text_size = render.get_text_size(fonts.verdana.shadow, ("[%s] "):format(script_name))
        local text_size = render.get_text_size(fonts.verdana.shadow, value.text)

        local width = text_size.x + 10

        render.push_alpha_modifier(value.alpha)

        render.text(fonts.verdana.shadow, ("[%s] "):format(script_name), vec2_t(x - (text_size.x / 2) - (prefix_text_size.x / 2), y + (height / 2) - (text_size.y / 2) - offset + 1), color_t(r, g, b, 255))
        render.text(fonts.verdana.shadow, value.text, vec2_t(x - (text_size.x / 2) + (prefix_text_size.x / 2), y + (height / 2) - (text_size.y / 2) - offset + 1), color_t(255, 255, 255, 255))

       	render.pop_alpha_modifier()

        if (#notify.list > 6 or value.alpha < 0.01) then
            table.remove(notify.list, key)
        end

        offset = offset + (height + space) * value.alpha
    end
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

    local text = {
        {text = "Hit "},
        {text = event.player:get_name()},
		{text = " for "},
        {text = tostring(event.damage)},
        {text = " in the "},
        {text = hit_log_c.groups[event.hitgroup] or "?"},
        {text = " [hc: "},
		{text = tostring(hit_log_c.hitchance)},
		{text = "%, "},
        {text = ("bt(Δ): %s]"):format(event.backtrack_ticks)}
    }

	local exp_time = 6

	table.insert(hit_log_c.list, 1, {text = text, max_time = exp_time, time = exp_time, alpha = 0, animate = 90})
end

function hit_log_c.miss_event(event)
	if (event.player == nil) then
		return
	end

	local text = {	
		{text = "Missed "},
		{text = event.player:get_name()},
		{text = "`s "},
		{text = hit_log_c.groups[event.aim_hitgroup] or "?"},
		{text = " due to "},
		{text = event.reason_string},
        {text = " [hc:"},
		{text = tostring(hit_log_c.hitchance)},
		{text = "%, "},
        {text = ("bt(Δ): %s]"):format(event.backtrack_ticks)},
	}

	local exp_time = 6

	table.insert(hit_log_c.list, 1, {text = text, max_time = exp_time, time = exp_time, alpha = 0, animate = 90})
end

function hit_log_c.handle()
    if (not ui_Visuals.Visuals:get(7) or not ui_Visuals.switch:get()) then
        return
    end

    local player = entity_list.get_local_player()

    if (player == nil) then
        hit_log_c.list = {}

        return
    end

    local screen = render.get_screen_size()
    local pixel = render.create_font("Smallest Pixel-7", 10, 20)

    local additional = 550
    local x, y = screen.x / 2, (screen.y / 2) + additional

	local accent_color = ui_Visuals.accent:get()
	local r, g, b = accent_color.r, accent_color.g, accent_color.b

    local offset = 0
    for key, value in ipairs(hit_log_c.list) do
        value.time = value.time - global_vars.frame_time()

        value.alpha = animation.lerp(value.alpha, value.time <= 0 and 0 or 1, 12)
        value.animate = animation.lerp(value.animate, value.time <= 0 and 0 or 0, 3)

        local text_size = render_c.get_multitext_width(fonts.verdana.shadow, value.text)
        local text_height = render.get_text_size(fonts.verdana.shadow, tostring(value.text)).y
        
        local space = 15

		offset = offset - 35 * value.alpha

        local width, height = text_size + space + 18, text_height + 9
        local nx, ny = x - (width / 2) + (space / 2), y + (height / 2) - (text_height / 2) + offset

        render.push_alpha_modifier(value.alpha)

		--[[ render_c.container(vec2_t(x - (width / 2) + value.animate, y + offset - 5), vec2_t(width, height), color_t(r, g, b, 255), ui_Visuals.style:get(4)) --]]
		render.rect_filled(vec2_t(x - (width / 2), y + offset - 5), vec2_t(width, height), color_t(100, 100, 100, 50), 6)

		render.progress_circle(vec2_t(x - (width / 2) + width - 12, y + offset + 6), 4, color_t(33, 33, 33, 255), 2, 1)
		render.progress_circle(vec2_t(x - (width / 2) + width - 12, y + offset + 6), 4, color_t(r, g, b, 255), 2, value.time / value.max_time)

        render_c.multitext(fonts.verdana.shadow, vec2_t(nx, ny - 4), value.text)
        render.pop_alpha_modifier()

        if (#hit_log_c.list > 4 or value.alpha < 0.1) then
            table.remove(hit_log_c.list, key)
        end
    end
end
--- @endregion


--- @item: Clantag Spammer
local clan_tag = {}

clan_tag.func = ffi.cast("int(__fastcall*)(const char*, const char*)", memory.find_pattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15"))
clan_tag.last = nil

function clan_tag.set(text)
	if (text == nil) then
		return
	end

    if (clan_tag.last == text) then 
        return 
    end

    clan_tag.func(text, text)

    clan_tag.last = text
end

local string_mul = function(text, mul)

    mul = math.floor(mul)

    local to_add = text

    for i = 1, mul-1 do
        text = text .. to_add
    end

    return text
end

clan_tag.last_time_update = -1
clan_tag.update = function(tag)
    local current_tick = global_vars.tick_count()

    if current_tick > clan_tag.last_time_update then
        tag = tostring(tag)
        ffi_handler.change_tag_fn(tag, tag)
        clan_tag.last_time_update = current_tick + 40
    end
end

function clan_tag.create(text)
	if (text == nil) then
		return
	end

    local orig_text = text
    local list = {}

    text = string_mul(" ", #text * 2) .. text .. string_mul(" ", #text * 2)

    for i = 1, math.floor(#text / 1.5) do
        local add_text = text:sub(i, (i + math.floor(#orig_text * 2) % #text))

        table.insert(list, add_text .. "\t")
    end

    return list
end

clan_tag.tag = clan_tag.create("heisenberg [Debug]")

function clan_tag.handle()
	if (not ui_other.clan_tag:get()) then
		return
	end

	local player = entity_list.get_local_player()

	if (player == nil) then
		return
	end

	local latency = engine.get_latency(e_latency_flows.OUTGOING) / global_vars.interval_per_tick()
    local tickcount_pred = global_vars.tick_count() + latency
    local index = math.floor(math.fmod(tickcount_pred / 40, #clan_tag.tag)) + 2

    clan_tag.set(clan_tag.tag[index])
end

function clan_tag.unload()
	clan_tag.set(" ")
end

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
		config = ("%s%s"):format(script_name, config)

		clipboard_c.export(config)

		client.log("Config exported to clipboard.")
		notify.push("Config exported to clipboard.")
		engine.play_sound("survival/buy_item_01.wav", 1.0, 100)
	end)

	if (not status) then
		client.log("Failed to export config")
		notify.push("Failed to export config")
		engine.play_sound("training/puck_fail.wav", 1.0, 100)

		return
	end
end

--- @param: text: string
--- @return: void
function config_c.import(text)
	local status, message = pcall(function()
		text = text:gsub(("%s"):format(script_name), "")

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
		notify.push("Config successfully loaded!")
		engine.play_sound("survival/buy_item_01.wav", 1.0, 100)

	end)

	if (not status) then
		client.log("Failed to import config:")
		notify.push("Failed to import config!")
		engine.play_sound("training/puck_fail.wav", 1.0, 100)

		return
	end
end


local ui_Global = {}

ui_Global.import_default_button = menu_manager_c.new("Misc", "Config", "Load Default Config", false):button(function()

	local data = "eyJBbnRpLUFpbSI6eyJDb25kaXRpb24gQW50aS1BaW0iOnsiW0Fpcl0gSml0dGVyIFR5cGUiOnsidmFsdWUiOjN9LCJDdXJyZW50IENvbmRpdGlvbiI6eyJ2YWx1ZSI6Nn0sIltHbG9iYWxdIEJvZHkgTGVhbiBWYWx1ZSI6eyJ2YWx1ZSI6MH0sIltXYWxraW5nXSBEaXNhYmxlIEppdHRlciI6eyJ2YWx1ZSI6eyJzZWxlY3Rpb25fdmFsdWUiOltmYWxzZSxmYWxzZV0sInNlbGVjdGlvbiI6dHJ1ZX19LCJbQ3JvdWNoXSBEZXN5bmMgU2lkZSI6eyJ2YWx1ZSI6NH0sIltXYWxraW5nXSBCb2R5IExlYW4gSml0dGVyIjp7InZhbHVlIjowfSwiW0Fpcl0gT3ZlcnJpZGUiOnsidmFsdWUiOnRydWV9LCJbUnVubmluZ10gSml0dGVyIFR5cGUiOnsidmFsdWUiOjN9LCJbUnVubmluZ10gUmlnaHQgRGVzeW5jIEFtb3VudCI6eyJ2YWx1ZSI6OTl9LCJbU3RhbmRpbmddIFlhdyBBZGQgVHlwZSI6eyJ2YWx1ZSI6Mn0sIltTdGFuZGluZ10gT3ZlcnJpZGUiOnsidmFsdWUiOnRydWV9LCJbU3RhbmRpbmddIFJpZ2h0IFlhdyBBZGQiOnsidmFsdWUiOjEyfSwiW1J1bm5pbmddIERlc3luYyBBbW91bnQiOnsidmFsdWUiOjB9LCJbUnVubmluZ10gQ2VudGVyIEppdHRlciBBZGQiOnsidmFsdWUiOjQ3fSwiW1J1bm5pbmddIExlZnQgWWF3IEFkZCI6eyJ2YWx1ZSI6LTE4fSwiW1N0YW5kaW5nXSBSaWdodCBEZXN5bmMgQW1vdW50Ijp7InZhbHVlIjo4OH0sIltTdGFuZGluZ10gQ2VudGVyIEppdHRlciBBZGQiOnsidmFsdWUiOjQ3fSwiW1J1bm5pbmddIFlhdyBBZGQiOnsidmFsdWUiOjB9LCJbQ3JvdWNoXSBZYXcgQWRkIFR5cGUiOnsidmFsdWUiOjJ9LCJbV2Fsa2luZ10gWWF3IEJhc2UiOnsidmFsdWUiOjN9LCJbU3RhbmRpbmddIExlZnQgWWF3IEFkZCI6eyJ2YWx1ZSI6LTEyfSwiW1dhbGtpbmddIERlc3luYyBBbW91bnQiOnsidmFsdWUiOjB9LCJbQWlyXSBZYXcgQWRkIFR5cGUiOnsidmFsdWUiOjJ9LCJbUnVubmluZ10gT2Zmc2V0IEppdHRlciBBZGQiOnsidmFsdWUiOjB9LCJbU3RhbmRpbmddIE9mZnNldCBKaXR0ZXIgQWRkIjp7InZhbHVlIjowfSwiW0dsb2JhbF0gSml0dGVyIFR5cGUiOnsidmFsdWUiOjF9LCJbUnVubmluZ10gRGVzeW5jIEFtb3VudCBUeXBlIjp7InZhbHVlIjoyfSwiW1N0YW5kaW5nXSBEZXN5bmMgU2lkZSI6eyJ2YWx1ZSI6NH0sIltHbG9iYWxdIFlhdyBCYXNlIjp7InZhbHVlIjoxfSwiW1N0YW5kaW5nXSBCb2R5IExlYW4gVmFsdWUiOnsidmFsdWUiOjB9LCJbU3RhbmRpbmddIERlc3luYyBBbW91bnQiOnsidmFsdWUiOjB9LCJbV2Fsa2luZ10gUmlnaHQgWWF3IEFkZCI6eyJ2YWx1ZSI6MjB9LCJbU3RhbmRpbmddIERlc3luYyBBbW91bnQgVHlwZSI6eyJ2YWx1ZSI6Mn0sIltSdW5uaW5nXSBCb2R5IExlYW4gSml0dGVyIjp7InZhbHVlIjowfSwiW0Fpcl0gRGVzeW5jIEFtb3VudCBUeXBlIjp7InZhbHVlIjoyfSwiW1dhbGtpbmddIFlhdyBBZGQgVHlwZSI6eyJ2YWx1ZSI6Mn0sIltHbG9iYWxdIERlc3luYyBBbW91bnQgVHlwZSI6eyJ2YWx1ZSI6MX0sIltTdGFuZGluZ10gSml0dGVyIFR5cGUiOnsidmFsdWUiOjN9LCJbUnVubmluZ10gQm9keSBMZWFuIjp7InZhbHVlIjoxfSwiW0Nyb3VjaF0gQ2VudGVyIEppdHRlciBBZGQiOnsidmFsdWUiOjMxfSwiW0Nyb3VjaF0gRGVzeW5jIEFtb3VudCI6eyJ2YWx1ZSI6MH0sIltDcm91Y2hdIFJpZ2h0IFlhdyBBZGQiOnsidmFsdWUiOjEyfSwiW0Nyb3VjaF0gTGVmdCBZYXcgQWRkIjp7InZhbHVlIjotMTJ9LCJbU3RhbmRpbmddIFlhdyBCYXNlIjp7InZhbHVlIjozfSwiW0dsb2JhbF0gTGVmdCBZYXcgQWRkIjp7InZhbHVlIjowfSwiW0dsb2JhbF0gTGVmdCBEZXN5bmMgQW1vdW50Ijp7InZhbHVlIjowfSwiW0dsb2JhbF0gQm9keSBMZWFuIEppdHRlciI6eyJ2YWx1ZSI6MH0sIltTdGFuZGluZ10gQm9keSBMZWFuIEppdHRlciI6eyJ2YWx1ZSI6MH0sIltXYWxraW5nXSBCb2R5IExlYW4iOnsidmFsdWUiOjF9LCJbU3RhbmRpbmddIERpc2FibGUgSml0dGVyIjp7InZhbHVlIjp7InNlbGVjdGlvbl92YWx1ZSI6W2ZhbHNlLHRydWVdLCJzZWxlY3Rpb24iOnRydWV9fSwiW0Nyb3VjaF0gQm9keSBMZWFuIFZhbHVlIjp7InZhbHVlIjowfSwiW0Nyb3VjaF0gT3ZlcnJpZGUiOnsidmFsdWUiOnRydWV9LCJbU3RhbmRpbmddIEJvZHkgTGVhbiI6eyJ2YWx1ZSI6MX0sIltSdW5uaW5nXSBZYXcgQWRkIFR5cGUiOnsidmFsdWUiOjJ9LCJbQWlyXSBPZmZzZXQgSml0dGVyIEFkZCI6eyJ2YWx1ZSI6MH0sIltHbG9iYWxdIFlhdyBBZGQgVHlwZSI6eyJ2YWx1ZSI6MX0sIltXYWxraW5nXSBPdmVycmlkZSI6eyJ2YWx1ZSI6dHJ1ZX0sIltHbG9iYWxdIERlc3luYyBBbW91bnQiOnsidmFsdWUiOjB9LCJbQ3JvdWNoXSBCb2R5IExlYW4gSml0dGVyIjp7InZhbHVlIjowfSwiW0Fpcl0gRGVzeW5jIFNpZGUiOnsidmFsdWUiOjR9LCJbR2xvYmFsXSBEaXNhYmxlIEppdHRlciI6eyJ2YWx1ZSI6eyJzZWxlY3Rpb25fdmFsdWUiOltmYWxzZSxmYWxzZV0sInNlbGVjdGlvbiI6dHJ1ZX19LCJbR2xvYmFsXSBPZmZzZXQgSml0dGVyIEFkZCI6eyJ2YWx1ZSI6MH0sIltBaXJdIENlbnRlciBKaXR0ZXIgQWRkIjp7InZhbHVlIjo0NH0sIltXYWxraW5nXSBEZXN5bmMgU2lkZSI6eyJ2YWx1ZSI6NH0sIltBaXJdIExlZnQgWWF3IEFkZCI6eyJ2YWx1ZSI6LTEwfSwiW0Fpcl0gTGVmdCBEZXN5bmMgQW1vdW50Ijp7InZhbHVlIjo5OX0sIltDcm91Y2hdIEJvZHkgTGVhbiI6eyJ2YWx1ZSI6MX0sIltSdW5uaW5nXSBEZXN5bmMgU2lkZSI6eyJ2YWx1ZSI6NH0sIltBaXJdIFJpZ2h0IFlhdyBBZGQiOnsidmFsdWUiOjEwfSwiW0Fpcl0gUmlnaHQgRGVzeW5jIEFtb3VudCI6eyJ2YWx1ZSI6ODh9LCJbUnVubmluZ10gT3ZlcnJpZGUiOnsidmFsdWUiOnRydWV9LCJbR2xvYmFsXSBDZW50ZXIgSml0dGVyIEFkZCI6eyJ2YWx1ZSI6MH0sIltDcm91Y2hdIE9mZnNldCBKaXR0ZXIgQWRkIjp7InZhbHVlIjowfSwiW1N0YW5kaW5nXSBZYXcgQWRkIjp7InZhbHVlIjowfSwiW0dsb2JhbF0gUmlnaHQgRGVzeW5jIEFtb3VudCI6eyJ2YWx1ZSI6MH0sIltSdW5uaW5nXSBZYXcgQmFzZSI6eyJ2YWx1ZSI6M30sIltHbG9iYWxdIFlhdyBBZGQiOnsidmFsdWUiOjB9LCJbR2xvYmFsXSBPdmVycmlkZSI6eyJ2YWx1ZSI6ZmFsc2V9LCJbR2xvYmFsXSBSaWdodCBZYXcgQWRkIjp7InZhbHVlIjowfSwiW1J1bm5pbmddIERpc2FibGUgSml0dGVyIjp7InZhbHVlIjp7InNlbGVjdGlvbl92YWx1ZSI6W2ZhbHNlLGZhbHNlXSwic2VsZWN0aW9uIjp0cnVlfX0sIltSdW5uaW5nXSBCb2R5IExlYW4gVmFsdWUiOnsidmFsdWUiOjB9LCJbQ3JvdWNoXSBZYXcgQWRkIjp7InZhbHVlIjowfSwiW1dhbGtpbmddIENlbnRlciBKaXR0ZXIgQWRkIjp7InZhbHVlIjo1M30sIltHbG9iYWxdIEJvZHkgTGVhbiI6eyJ2YWx1ZSI6MX0sIltBaXJdIEJvZHkgTGVhbiBKaXR0ZXIiOnsidmFsdWUiOjB9LCJbQ3JvdWNoXSBEaXNhYmxlIEppdHRlciI6eyJ2YWx1ZSI6eyJzZWxlY3Rpb25fdmFsdWUiOltmYWxzZSxmYWxzZV0sInNlbGVjdGlvbiI6dHJ1ZX19LCJbQWlyXSBEZXN5bmMgQW1vdW50Ijp7InZhbHVlIjowfSwiW0Nyb3VjaF0gSml0dGVyIFR5cGUiOnsidmFsdWUiOjN9LCJbV2Fsa2luZ10gRGVzeW5jIEFtb3VudCBUeXBlIjp7InZhbHVlIjoyfSwiW0dsb2JhbF0gRGVzeW5jIFNpZGUiOnsidmFsdWUiOjF9LCJbQWlyXSBZYXcgQmFzZSI6eyJ2YWx1ZSI6M30sIltBaXJdIFlhdyBBZGQiOnsidmFsdWUiOjB9LCJbV2Fsa2luZ10gSml0dGVyIFR5cGUiOnsidmFsdWUiOjN9LCJbV2Fsa2luZ10gTGVmdCBEZXN5bmMgQW1vdW50Ijp7InZhbHVlIjo5OX0sIltBaXJdIEJvZHkgTGVhbiI6eyJ2YWx1ZSI6MX0sIltSdW5uaW5nXSBMZWZ0IERlc3luYyBBbW91bnQiOnsidmFsdWUiOjk5fSwiW1N0YW5kaW5nXSBMZWZ0IERlc3luYyBBbW91bnQiOnsidmFsdWUiOjk5fSwiW0Nyb3VjaF0gUmlnaHQgRGVzeW5jIEFtb3VudCI6eyJ2YWx1ZSI6ODB9LCJbQ3JvdWNoXSBZYXcgQmFzZSI6eyJ2YWx1ZSI6M30sIltDcm91Y2hdIExlZnQgRGVzeW5jIEFtb3VudCI6eyJ2YWx1ZSI6ODV9LCJbV2Fsa2luZ10gWWF3IEFkZCI6eyJ2YWx1ZSI6MH0sIltXYWxraW5nXSBSaWdodCBEZXN5bmMgQW1vdW50Ijp7InZhbHVlIjo5OX0sIltXYWxraW5nXSBPZmZzZXQgSml0dGVyIEFkZCI6eyJ2YWx1ZSI6MH0sIltBaXJdIEJvZHkgTGVhbiBWYWx1ZSI6eyJ2YWx1ZSI6MH0sIltBaXJdIERpc2FibGUgSml0dGVyIjp7InZhbHVlIjp7InNlbGVjdGlvbl92YWx1ZSI6W2ZhbHNlLGZhbHNlXSwic2VsZWN0aW9uIjp0cnVlfX0sIltDcm91Y2hdIERlc3luYyBBbW91bnQgVHlwZSI6eyJ2YWx1ZSI6Mn0sIltXYWxraW5nXSBCb2R5IExlYW4gVmFsdWUiOnsidmFsdWUiOjB9LCJbV2Fsa2luZ10gTGVmdCBZYXcgQWRkIjp7InZhbHVlIjotMjN9LCJbUnVubmluZ10gUmlnaHQgWWF3IEFkZCI6eyJ2YWx1ZSI6MTh9fSwiQW50aS1BaW0iOnsiQW5pbWF0aW9uIEJyZWFrZXJzIjp7InZhbHVlIjp7InNlbGVjdGlvbl92YWx1ZSI6W3RydWUsZmFsc2UsZmFsc2UsZmFsc2UsdHJ1ZV0sInNlbGVjdGlvbiI6dHJ1ZX19LCJNYXN0ZXIgU3dpdGNoIjp7InZhbHVlIjp0cnVlfSwiQW50aS1BaW0gTW9kZSI6eyJ2YWx1ZSI6Mn19fSwiR2xvYmFsIjp7Ik1haW4iOltdfSwiVmlzdWFscyI6eyJWaXN1YWxzIjp7IlsgV2F0ZXJtYXJrIF0geSI6eyJ2YWx1ZSI6MTA1OH0sIlZpc3VhbHMiOnsidmFsdWUiOnsic2VsZWN0aW9uX3ZhbHVlIjpbdHJ1ZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZV0sInNlbGVjdGlvbiI6dHJ1ZX19LCJbIEtleWJpbmRzIF0geSI6eyJ2YWx1ZSI6NTIwfSwiWyBLZXliaW5kcyBdIHgiOnsidmFsdWUiOjE2NzF9LCJXaW5kb3dzIFN0eWxlIjp7InZhbHVlIjoxfSwiWyBTcGVjdGF0b3JzIF0geSI6eyJ2YWx1ZSI6MjkyfSwiWyBTcGVjdGF0b3JzIF0geCI6eyJ2YWx1ZSI6OTh9LCJDdXN0b20gV2F0ZXJtYXJrIFBvc2l0aW9uIjp7InZhbHVlIjpmYWxzZX0sIk1hc3RlciBTd2l0Y2giOnsidmFsdWUiOnRydWV9LCJJbmRpY2F0b3JzIFN0eWxlIjp7InZhbHVlIjoyfSwiWyBXYXRlcm1hcmsgXSB4Ijp7InZhbHVlIjo4NzR9fX0sIk1pc2MiOnsiTWlzYyI6eyJDb2xvciI6eyJ2YWx1ZSI6WzYwLDE0MywyNTMsMjU1XX0sIkVuYWJsZSBDbGFudGFnIjp7InZhbHVlIjp0cnVlfSwiRW5hYmxlIEluZm9ybWF0aW9uIFBhbmVsIjp7InZhbHVlIjp0cnVlfX0sIkNvbmZpZyI6W119fQ=="
	
	config_c.import(data)
end)
ui_Global.export_button = menu_manager_c.new("Misc", "Config", "Export config to clipboard", false):button(config_c.export)

ui_Global.import_button = menu_manager_c.new("Misc", "Config", "Import config from clipboard", false):button(function()
	local data = clipboard_c.import()

	config_c.import(data)
end)

engine.play_sound("survival/buy_item_01.wav", 1.0, 100)
--- @endregion

local animation = {}
local Anim_If_Menu_Open = 0

animation.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

function on_paint()
    local RainbowColor = (global_vars.real_time() * 5) % 100

    local pixel = render.create_font("Smallest Pixel-7", 10, 20)

    local accent_color = ui_Visuals.accent:get()
    local r, g, b = accent_color.r, accent_color.g, accent_color.b
    detail = accent_color

    Anim_If_Menu_Open = animation.lerp(Anim_If_Menu_Open, menu.is_open() and 20 or -160, global_vars.frame_time() * 3)

    local screen = render.get_screen_size()

    local width, height = 112, 75
    local x, y = (screen.x / 2) - (width / 2), 50 + Anim_If_Menu_Open

    local space = 10

    render.rect_filled(vec2_t(x, y), vec2_t(width, height), color_t(30, 30, 30, 255), 6)
    render.rect(vec2_t(x, y), vec2_t(width, height), color_t(70, 70, 70, 255), 6)

    render.text(pixel, "WELCOME TO HEISENBERG", vec2_t(x + space, y + 15), detail)

    render.text(pixel, "Build: [DEBUG]", vec2_t(x + space, y + 30), detail)

    render.text(pixel, ("NAME: %s"):format(user.name), vec2_t(x + space, y + 40), detail)
    render.text(pixel, ("UID: %s"):format(user.uid), vec2_t(x + space, y + 50), detail)
end

notify.push(("Welcome to Heisenberg, %s!"):format(user.name))

--[[

██████╗ ██████╗ ███╗   ██╗███████╗ ██████╗ ██╗     ███████╗
██╔════╝██╔═══██╗████╗  ██║██╔════╝██╔═══██╗██║     ██╔════╝
██║     ██║   ██║██╔██╗ ██║███████╗██║   ██║██║     █████╗  
██║     ██║   ██║██║╚██╗██║╚════██║██║   ██║██║     ██╔══╝  
╚██████╗╚██████╔╝██║ ╚████║███████║╚██████╔╝███████╗███████╗
 ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚══════╝╚══════╝
                                                            
--]]
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("")
print("Current build: DEBUG")
print("Last Update: 8/31/22 02:34 AM")
print("Username:", user.name)
print("UID:", user.uid)
print("")
print("")

--[[

██████╗ █████╗ ██╗     ██╗     ██████╗  █████╗  ██████╗██╗  ██╗███████╗
██╔════╝██╔══██╗██║     ██║     ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔════╝
██║     ███████║██║     ██║     ██████╔╝███████║██║     █████╔╝ ███████╗
██║     ██╔══██║██║     ██║     ██╔══██╗██╔══██║██║     ██╔═██╗ ╚════██║
╚██████╗██║  ██║███████╗███████╗██████╔╝██║  ██║╚██████╗██║  ██╗███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝

--]]

--------------------------------------------------------------------------------

callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.PAINT, menu_manager_c.visible)
callbacks.add(e_callbacks.PAINT, watermark_c.handle)
callbacks.add(e_callbacks.PAINT, keybinds_c.handle)
callbacks.add(e_callbacks.PAINT, hit_log_c.handle)
callbacks.add(e_callbacks.PAINT, indicators_c.handle)
callbacks.add(e_callbacks.PAINT, notify.handle)
callbacks.add(e_callbacks.PAINT, arrows_c.handle)
callbacks.add(e_callbacks.PAINT, slowd_down_c.handle)
callbacks.add(e_callbacks.PAINT, clan_tag.handle)
callbacks.add(e_callbacks.AIMBOT_HIT, hit_log_c.hit_event)
callbacks.add(e_callbacks.AIMBOT_MISS, hit_log_c.miss_event)
callbacks.add(e_callbacks.AIMBOT_SHOOT, hit_log_c.shoot_event)
callbacks.add(e_callbacks.ANTIAIM, anim_breaker.handle)
callbacks.add(e_callbacks.ANTIAIM, condition_anti_aim.handle)
callbacks.add(e_callbacks.PAINT, spectators_c.handle)
callbacks.add(e_callbacks.PAINT, info_panel_c.handle)
callbacks.add(e_callbacks.SHUTDOWN, function()
	watermark_c.note:unload()

	clan_tag.unload()
end)
--------------------------------------------------------------------------------