local ffi = require 'ffi'
local vector = require 'vector'
local base64 = require 'gamesense/base64'
local images = require 'gamesense/images'
local http = require 'gamesense/http'
local vector = require 'vector'

local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')

local native_GetClipboardTextCount = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
local native_SetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 9,  "void(__thiscall*)(void*, const char*, int)")
local native_GetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")

local clipboard = {
    get = function ()
        local len = native_GetClipboardTextCount()
        if (len > 0) then
            local char_arr = ffi.typeof("char[?]")(len)
            native_GetClipboardText(0, char_arr, len)
            local text = ffi.string(char_arr, len - 1)
            local suffix = text:find('_exscord')

            if suffix then
                text = text:sub(1, suffix)
            end

            return text
        end
    end,

    set = function (text)
        text = tostring(text)
	    native_SetClipboardText(text, string.len(text))
    end
}

local username = username or 'mishkat'
local version = build or 'debug'

local f = string.format
local typeof = type

local message = function(r, g, b, ...)
    client.color_log(164, 193, 255, 'exscord\0')
    client.color_log(150, 150, 150, ' » \0')
    client.color_log(r, g, b, f(...))
end

local die = function(...)
    message(255, 145, 145, ...)
    error()
end

local function breathe(offset, multiplier)
    local speed = globals.realtime() * (multiplier or 1.0);
    local factor = speed % math.pi;

    local sin = math.sin(factor + (offset or 0));
    local abs = math.abs(sin);

    return abs
end

local function hex(r, g, b, a)
    return f('\a%02X%02X%02X%02X', r, g, b, a or 255)
end

local function int(x)
    return math.floor(x + 0.5)
end

local function get_curtime(offset)
    return globals.curtime() - (offset * globals.tickinterval())
end

local function lerp(x, v, t)
    if type(x) == 'table' then
        return lerp(x[1], v[1], t), lerp(x[2], v[2], t), lerp(x[3], v[3], t), lerp(x[4], v[4], t)
    end

    local delta = v - x

    if type(delta) == 'number' then
        if math.abs(delta) < 0.005 then
            return v
        end
    end

    return delta * t + x
end

local function normalize(x, min, max)
    local delta = max - min
    while x < min do
        x = x + delta
    end

    while x > max do
        x = x - delta
    end

    return x
end

local function clamp(value, min, max)
    return math.max(min, math.min(value, max))
end

local function clamp_str(str, max)
	str = tostring(str)
	if str:len() > max then
	  	str = str:sub(0, max) .. '...'
	end
	return str
end

local function angle_to_forward(angle_x, angle_y)
    local sy = math.sin(math.rad(angle_y))
    local cy = math.cos(math.rad(angle_y))
    local sp = math.sin(math.rad(angle_x))
    local cp = math.cos(math.rad(angle_x))
    return cp * cy, cp * sy, -sp
end

table.find = function(list, value)
    for _, v in pairs(list) do
        if v == value then
            return _
        end
    end
    return false
end

table.length = function(list)
    local length = 0
    for _ in pairs(list) do
        length = length + 1
    end

    return length
end

local animations = {
    data = { },

    process = function (self, name, bool, time)
        if not self.data[name] then
            self.data[name] = 0
        end

        local animation = globals.frametime() * (bool and 1 or -1) * (time or 4)
        self.data[name] = clamp(self.data[name] + animation, 0, 1)
        return self.data[name]
    end,

    lerp = function (self, start, end_, speed, delta)
        if (math.abs(start - end_) < (delta or 0.01)) then
            return end_
        end
        speed = speed or 0.095
        local time = globals.frametime() * (175 * speed)
        return ((end_ - start) * time + start)
    end,
}

local enum = {
    tab = {
        'Anti-Aimbot',
        'Visuals',
        'Misc'
    },

    ui = {
        hotkey_states = {
            [0] = 'Always on',
            'On hotkey',
            'Toggle',
            'Off hotkey'
        },

        pitch = {
            'Off',
            'Default',
            'Up',
            'Down',
            'Minimal',
            'Random'
        },

        yaw_base = {
            'Local view',
            'At targets'
        },

        yaw = {
            'Off',
            '180',
            'Spin',
            'Static',
            '180 Z',
            'Crosshair',
            '180 Left/Right'
        },

        yaw_jitter = {
            'Off',
            'Offset',
            'Center',
            'Skitter',
            'Random',
            '3 Way',
            '5 Way'
        },

        body_yaw = {
            'Off',
            'Opposite',
            'Jitter',
            'Static'
        },
    },

    anti_aimbot = {
        states = {
            'Global',
            'Stand',
            'Move',
            'Slow-motion',
            'Air',
            'Air + Crouch',
            'Crouch',
            'Using'
        },


        functions = {
            'Anti-backstab',
            'Adjust on-shot fakelag',
            'Allow anti-aim on use',
            'Manual anti-aim',
            'Freestanding',
            'Edge yaw',
            'Force Defensive in Air',
            'Defensive Anti-aim'
        },
    },

    misc = {
        functions = {
            'Animation Breakers',
            'Clantag Spammer'
        },
    },

    team = {
        none = 0,
        spec = 1,
        t    = 2,
        ct   = 3,
    },
}

local tabs = {
    antiaim = enum.tab[1],
    visuals = enum.tab[2],
    misc = enum.tab[3],
}

local reference = {
    RAGE = {
        aimbot = {
            min_damage = ui.reference('RAGE', 'Aimbot', 'Minimum damage'),
            min_damage_override = {ui.reference('RAGE', 'Aimbot', 'Minimum damage override')},
            force_safe_point = ui.reference('RAGE', 'Aimbot', 'Force safe point'),
            force_body_aim = ui.reference('RAGE', 'Aimbot', 'Force body aim'),
            double_tap = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
        },

        other = {
            quick_peek_assist = { ui.reference('RAGE', 'Other', 'Quick peek assist') },
            duck_peek_assist = ui.reference('RAGE', 'Other', 'Duck peek assist'),
        },
    },

    AA = {
        angles = {
            enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
            pitch = ui.reference('AA', 'Anti-aimbot angles', 'Pitch'),
            yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
            yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') },
            yaw_jitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
            body_yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
            freestanding_body_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw'),
            edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
            freestanding = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
            roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
        },

        fakelag = {
            enabled = ui.reference('AA', 'Fake lag', 'Enabled'),
            amount = ui.reference('AA', 'Fake lag', 'Amount'),
            variance = ui.reference('AA', 'Fake lag', 'Variance'),
            limit = ui.reference('AA', 'Fake lag', 'Limit'),
        },

        other = {
            slow_motion = { ui.reference('AA', 'Other', 'Slow motion') },
            leg_movement = ui.reference('AA', 'Other', 'Leg movement'),
            on_shot_antiaim = { ui.reference('AA', 'Other', 'On shot anti-aim') },
            fake_peek = ui.reference('AA', 'Other', 'Fake peek'),
        },
    },

    MISC = {
        clantag = ui.reference('Misc', 'Miscellaneous', 'Clan tag spammer'),
        color = ui.reference('Misc', 'Settings', 'Menu color'),
    },
}

local g_drag = {}
g_drag.items = {}
g_drag.target = nil
g_drag.bound = nil

local drag_mt = {}
drag_mt.__index = drag_mt;
local screen = vector(client.screen_size())

function drag_mt:get()
    return self.x, self.y, self.w, self.h
end

function drag_mt:set(x, y, w, h)
    if x ~= nil then
        self.x = x
    end

    if y ~= nil then
        self.y = y
    end

    if w ~= nil then
        self.w = w
    end

    if h ~= nil then
        self.h = h
    end
end

function drag_mt:is_hovered()
    local cursor = vector(ui.mouse_position())

    if cursor.x < self.x then
        return false
    end

    if cursor.x > self.x + self.w then
        return false
    end

    if cursor.y < self.y then
        return false
    end

    if cursor.y > self.y + self.h then
        return false
    end

    return true
end

g_drag.new = function(x, y, w, h)
    local drag_t = {
        x = x or 0,
        y = y or 0,
        w = w or 130,
        h = h or 20
    }

    table.insert(g_drag.items, drag_t)
    setmetatable(drag_t, drag_mt)
    return drag_t
end

g_drag.get_target = function()
    if not client.key_state(0x01) then
        g_drag.target = nil
        return g_drag.target
    end

    if g_drag.target ~= nil then
        return g_drag.target
    end

    local target
    for _, value in ipairs(g_drag.items) do
        if value:is_hovered() then
            target = value
        end
    end

    if target == nil then
        return
    end

    local cursor = vector(ui.mouse_position())
    local pos = vector(target.x, target.y)

    g_drag.bound = pos - cursor
    g_drag.target = target
    return target
end

g_drag.paint_ui = function()
    local target = g_drag.get_target()

    if target == nil then
        return
    end

    local cursor = vector(ui.mouse_position())
    local new = cursor + g_drag.bound

    target:set(
        clamp(new.x, 0, screen.x - target.w),
        clamp(new.y, 0, screen.y - target.h)
    )
end


local callback = {}
local menu_mt = {}
local menu = {}

if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function(...) return ... end
end

LPH_NO_VIRTUALIZE(function()
    callback.thread = 'main'
    callback.history = {}

    callback.get = function(key, result_only)
        local this = callback.history[key]
        if not this then
            return
        end

        if result_only then
            return unpack(this.m_result)
        end

        return this
    end

    callback.new = function(key, event_name, func)
        local this = {}
        this.m_key = key
        this.m_event_name = event_name
        this.m_func = func
        this.m_result = {}

        local handler = function(...)
            callback.thread = event_name
            this.m_result = { func(...) }
        end

        local protect = function(...)
            local success, result = pcall(handler, ...)

            if success then
                return
            end

            if isDebug then
                result = f('%s, debug info: key = %s, event_name = %s', result, key, event_name)
            end

            die('|!| callback::new - %s', result)
        end

        client.set_event_callback(event_name, protect)
        this.m_protect = protect

        callback.history[key] = this
        return this
    end

    menu_mt.register_callback = function(self, callback)
        if not callback then
            return false
        end

        if typeof(self) == 'table' then
            self = self.m_reference
        end

        if not self then
            return false
        end

        if menu.binds[self] == nil then
            menu.binds[self] = {}

            local refresh = function(item)
                for k, v in ipairs(menu.binds[self]) do
                    v(item)
                end
            end

            ui.set_callback(self, refresh)
        end

        table.insert(menu.binds[self], callback)
        return true
    end


    menu_mt.get = function(self, refresh)
        if not refresh then
            return unpack(self.m_value)
        end

        local protect = function()
            return { ui.get(self.m_reference) }
        end

        local success, result = pcall(protect)

        if not success then
            return
        end

        return unpack(result)
    end

    menu_mt.set = function(self, ...)
        if pcall(ui.set, self.m_reference, ...) then
            self.m_value = { self:get(true) }
        end
    end

    menu_mt.set_bypass = function(self, ...)
        local args = { ... }

        client.delay_call(-1, function()
            self:set(unpack(args))
        end)
    end

    menu_mt.set_visible = function(self, value)
        if pcall(ui.set_visible, self.m_reference, value) then
            self.m_visible = value
        end
    end

    menu_mt.update = function(self, ...)
        pcall(ui_update, self.m_reference, ...)
    end

    menu_mt.override = function(self, ...)
        pcall(menu.override, self.m_reference, ...)
    end

    menu_mt.add_as_parent = function(self, callback)
        self.m_parent = true

        local this = {}
        this.original = self
        this.callback = callback

        table.insert(menu.parents, this)
        this.idx = #menu.parents
    end

    menu.prod = {}
    menu.binds = {}
    menu.parents = {}
    menu.updates = {}
    menu.history = {}

    menu.list = {};

    menu.override = function(id, ...)
        if menu.history[callback.thread] == nil then
            menu.history[callback.thread] = {}

            local handler = function()
                local dir = menu.history[callback.thread]

                for k, v in pairs(dir) do
                    if v.active then
                        v.active = false;
                        goto skip;
                    end

                    ui.set(k, unpack(v.value));
                    dir[k] = nil;

                    ::skip::
                end
            end

            callback.new('menu::override::' .. callback.thread, callback.thread, handler)
        end

        local args = { ... }

        if #args == 0 then
            return
        end

        if menu.history[callback.thread][id] == nil then
            local item = { };
            local value = { ui.get(id) };

            if ui.type(id) == "hotkey" then
                value = {enum.ui.hotkey_states[value[2]]};
            end

            item.value = value;
            menu.history[callback.thread][id] = item;
        end

        menu.history[callback.thread][id].active = true;
        ui.set(id, ...);
    end

    menu.shutdown = function()
        for k, v in pairs(menu.history) do
            for x, y in pairs(v) do
                if y.backup == nil then
                    goto skip
                end

                ui.set(x, unpack(y.backup))
                y.backup = nil
                ::skip::
            end
        end
    end

    menu.set_visible = function(x, b)
        if typeof(x) == 'table' then
            for k, v in pairs(x) do
                menu.set_visible(v, b)
            end

            return
        end

        ui.set_visible(x, b)
    end

    menu.refresh = function()
        for k, v in pairs(menu.prod) do
            for x, y in pairs(v) do
                local protect = function()
                    local state = true

                    if y.m_parameters.callback ~= nil then
                        state = y.m_parameters.callback()
                    end

                    for k, v in pairs(menu.parents) do
                        if y.m_parameters.bypass then
                            if y.m_parameters.bypass[k] then
                                goto continue
                            end
                        end

                        if y == v.original then
                            break
                        end

                        if not v.callback(y) then
                            state = false
                            break
                        end

                        ::continue::
                    end

                    y:set_visible(state)
                end

                local isSuccess, output = pcall(protect)

                if isSuccess then
                    goto continue
                end

                if isDebug then
                    output = f('%s, debug info: group = %s, name = %s', output, y.m_group, y.name)
                end

                die('|!| menu::refresh - %s', output)
                ::continue::
            end
        end
    end

    menu.new = function(group, name, method, arguments, parameters)
        if menu.prod[group] == nil then
            menu.prod[group] = {}
        end

        if menu.prod[group][name] ~= nil then
            die('|!| menu::new - unable to create element with already used arguments: group = %s, name = %s', group, name)
        end

        local this = {}
        this.m_group = group
        this.name = name
        this.m_method = method
        this.m_arguments = arguments
        this.m_parameters = parameters or {}
        this.m_grouped = menu.allow_group
        this.m_visible = true

        setmetatable(this, {
            __index = menu_mt
        })

        local createReference = function()
            this.m_reference = this.m_method(unpack(this.m_arguments))
        end

        local isSuccess, output = pcall(createReference)

        if not isSuccess then
            if isDebug then
                output = f('%s, debug info: group = %s, name = %s', output, group, name)
            end

            die('|!| menu::new - %s', output)
        end

        menu.prod[group][name] = this

        if this.m_method == ui_new_button then
            this:register_callback(this.m_arguments[4])
        end

        local createCallback = function(item)
            local value = { ui.get(item) }
            this.m_value = value
        end

        local protect = function(item)
            pcall(createCallback, item)
            menu.refresh()
        end

        this:register_callback(protect)
        protect(this.m_reference)

        if this.m_parameters.update_per_frame then
            table.insert(menu.updates, this)

            if not callback.get('menu::update_per_frame') then
                callback.new('menu::update_per_frame', 'paint_ui', function()
                    for k, v in pairs(menu.updates) do
                        if v:get(true) == v:get() then
                            goto skip
                        end

                        v:set(v:get(true))
                        menu.refresh()
                        ::skip::
                    end
                end)
            end
        end
        return this
    end

    menu.register_callback = menu_mt.register_callback
    callback.new('menu::shutdown', 'shutdown', menu.shutdown)
end)()

local configs = {
    prefix = 'exscord::',
    suffix = '_exscord',
    key = 'ILOVEexscordABCDFGHJKMNPQRSTUWXYZabfghijklmnpqtuvwyz0123456789+/='
}

configs.export = function()
    local slot = {};

    for k, v in pairs(menu.prod) do
        local group = {}

        for x, y in pairs(v) do
            if y.m_parameters.config == false then
                goto skip
            end

            local value = { y:get(true) }

            if #value == 0 then
                goto skip
            end

            group[x] = value
            ::skip::
        end

        if table.length(group) ~= 0 then
            slot[k] = group
        end
    end

    if table.length(slot) == 0 then
        return false
    end

    local config = {
        data = slot,
        user = username or 'unknown',
        date = '12.12.2012',
        build = 'unknown',
    }

    local success, stringify = pcall(json.stringify, config)
    if not success then
        return message(255, 255, 255, 'Failed to stringify configuration.')
    end

    local success, encoded = pcall(base64.encode, stringify, configs.key)
    if not success then
        return message(255, 255, 255, 'Failed to encode configuration.')
    end

    return configs.prefix .. encoded .. configs.suffix
end

configs.import = function(s)
    local config = clipboard.get()
    local converted = false;

    if typeof(s) == 'string' then
        config = s
    end

    local prefix_length = #configs.prefix

    if config:sub(1, prefix_length) ~= configs.prefix then
        return
    end

    if config:find('_exscord') then
        config = config:gsub('_exscord', '')
    end

    config = config:sub(1 + prefix_length)
    local success, decoded = pcall(base64.decode, config, configs.key)
    if not success then
        return message(255, 255, 255, 'Failed to decode configuration.')
    end

    local success, parsed = pcall(json.parse, decoded)
    if not success then
        return message(255, 255, 255, 'Failed to parse configuration.')
    end

    if parsed.data == nil then
        return
    end

    for k, v in pairs(parsed.data) do
        if menu.prod[k] == nil then
            goto skip
        end

        for x, y in pairs(v) do
            if menu.prod[k][x] == nil then
                goto skip
            end

            local value = y;

            if type(value[1]) == "boolean" and type(value[2]) == "number" then
                menu.prod[k][x]:set(enum.ui.hotkey_states[value[2]]);
                goto skip
            end

            menu.prod[k][x]:set(unpack(value))
            ::skip::
        end

        ::skip::
    end

    return config
end

configs.data_slot = database.read('exscord::data_slot')
configs.load_startup = function()
    if not configs.data_slot then
        return
    end

    client.delay_call(-1, function()
        configs.import(configs.data_slot)
    end)
end

configs.shutdown = function()
    local encoded = configs.export()

    if not encoded then
        return
    end

    database.write('exscord::data_slot', encoded)
end

local math_clamp = function (x, min, max)
    return math.max(min, math.min(x, max))
end

local colored_label = ui.new_label('AA', 'Anti-aimbot angles', 'exscord Renewed')

do
    menu.new('exscord', 'Groups', ui.new_combobox, { 'AA', 'Anti-Aimbot angles', 'Group Controller', unpack(enum.tab) })
    menu.prod['exscord']['Groups']:add_as_parent(function(self)
        return self.m_group == menu.prod['exscord']['Groups']:get()
    end)
end

do
    menu.new(tabs.antiaim, 'Controller', ui.new_checkbox, { 'AA', 'Anti-aimbot angles', 'exscord ~ anti-aimbot switch' })
    menu.prod[ tabs.antiaim ]['Controller']:add_as_parent(function(self)
        if self.m_group ~= tabs.antiaim then
            return true
        end
        return menu.prod[ tabs.antiaim ]['Controller']:get()
    end)
end

menu.new(tabs.antiaim, 'Functions', ui.new_multiselect, { 'AA', 'Anti-aimbot angles', 'Anti-aim features', unpack(enum.anti_aimbot.functions) }) do
    menu.new(tabs.antiaim, 'LeftManual', ui.new_hotkey, { 'AA', 'Anti-aimbot angles', 'Manual Left' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Manual anti-aim')
        end
    })

    menu.new(tabs.antiaim, 'RightManual', ui.new_hotkey, { 'AA', 'Anti-aimbot angles', 'Manual Right' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Manual anti-aim')
        end
    })

    menu.new(tabs.antiaim, 'ForwardManual', ui.new_hotkey, { 'AA', 'Anti-aimbot angles', 'Manual Forward' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Manual anti-aim')
        end
    })

    menu.new(tabs.antiaim, 'ResetManual', ui.new_hotkey, { 'AA', 'Anti-aimbot angles', 'Manual Reset' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Manual anti-aim')
        end
    })

    menu.new(tabs.antiaim, 'StaticManuals', ui.new_checkbox, { 'AA', 'Anti-aimbot angles', 'Use Static On Manual' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Manual anti-aim')
        end
    })

    menu.new(tabs.antiaim, 'Freestanding', ui.new_hotkey, { 'AA', 'Anti-aimbot angles', 'Freestanding' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Freestanding')
        end
    })

    menu.new(tabs.antiaim, 'EdgeYaw', ui.new_hotkey, { 'AA', 'Anti-aimbot angles', 'Edge Yaw' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Edge yaw')
        end
    })

    menu.new(tabs.antiaim, 'DefensivePitch', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Defensive Pitch', enum.ui.pitch }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Defensive Anti-aim')
        end
    })

    menu.new(tabs.antiaim, 'DefensiveYaw', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Defensive Yaw', { 'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair' } }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Defensive Anti-aim')
        end
    })

    menu.new(tabs.antiaim, 'DefensiveYawAmount', ui.new_slider, { 'AA', 'Anti-aimbot angles', '\n Defensive Yaw', -180, 180, 0, true, '°' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Defensive Anti-aim')
            and menu.prod[ tabs.antiaim ]['DefensiveYaw']:get() ~= 'Off'
            and menu.prod[ tabs.antiaim ]['DefensiveYaw']:get() ~= '180 Left/Right'
        end
    })

    menu.new(tabs.antiaim, 'DefensiveYawLeft', ui.new_slider, { 'AA', 'Anti-aimbot angles', 'Yaw Left\n Defensive Yaw', -180, 180, 0, true, '°' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Defensive Anti-aim')
            and menu.prod[ tabs.antiaim ]['DefensiveYaw']:get() == '180 Left/Right'
        end
    })

    menu.new(tabs.antiaim, 'DefensiveYawRight', ui.new_slider, { 'AA', 'Anti-aimbot angles', 'Yaw Right\n Defensive Yaw', -180, 180, 0, true, '°' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Defensive Anti-aim')
            and menu.prod[ tabs.antiaim ]['DefensiveYaw']:get() == '180 Left/Right'
        end
    })
end

menu.new(tabs.antiaim, 'Type', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Anti-Aim Type', { 'Preset', 'Anti-Aim Builder' } })

menu.new(tabs.antiaim, 'PlayerCondition', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Player Condition', unpack(enum.anti_aimbot.states) }, {
    config = false,
    callback = function()
        return menu.prod[ tabs.antiaim ]['Type']:get() == 'Anti-Aim Builder'
    end
})

do
    local spacing = ''

    for key, value in ipairs(enum.anti_aimbot.states) do
        local is_visible = function ()
            return menu.prod[ tabs.antiaim ]['Type']:get() == 'Anti-Aim Builder'
            and menu.prod[ tabs.antiaim ]['PlayerCondition']:get() == value
        end

        if value ~= enum.anti_aimbot.states[ 1 ] then
            local override = value .. '::override'

            menu.new(tabs.antiaim, override, ui.new_checkbox, { 'AA', 'Anti-aimbot angles', 'Redefine\x20' .. value .. ' Condition' }, {
                callback = is_visible
            })

            is_visible = function()
                return menu.prod[ tabs.antiaim ]['Type']:get() == 'Anti-Aim Builder'
                and menu.prod[ tabs.antiaim ]['PlayerCondition']:get() == value
                and menu.prod[ tabs.antiaim ][value .. '::override']:get()
            end
        end

        menu.new(tabs.antiaim, value .. '::pitch', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Pitch' .. spacing, unpack(enum.ui.pitch) }, {
            callback = is_visible
        })

        menu.new(tabs.antiaim, value .. '::yaw_base', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Yaw Base' .. spacing, unpack(enum.ui.yaw_base) }, {
            callback = is_visible
        })

        menu.new(tabs.antiaim, value .. '::yaw', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Yaw' .. spacing, unpack(enum.ui.yaw) }, {
            callback = is_visible
        })

        menu.new(tabs.antiaim, value .. '::yaw_amount', ui.new_slider, { 'AA', 'Anti-aimbot angles', '\n yaw_amount' .. spacing, -180, 180, 0, true, '°' }, {
            callback = function()
                return is_visible()
                and menu.prod[ tabs.antiaim ][value .. '::yaw']:get() ~= enum.ui.yaw[1]
                and menu.prod[ tabs.antiaim ][value .. '::yaw']:get() ~= enum.ui.yaw[#enum.ui.yaw]
            end
        })

        menu.new(tabs.antiaim, value .. '::yaw_left', ui.new_slider, { 'AA', 'Anti-aimbot angles', 'Yaw Left' .. spacing, -180, 180, 0, true, '°' }, {
            callback = function()
                return is_visible()
                and menu.prod[ tabs.antiaim ][value .. '::yaw']:get() == enum.ui.yaw[#enum.ui.yaw]
            end
        })

        menu.new(tabs.antiaim, value .. '::yaw_right', ui.new_slider, { 'AA', 'Anti-aimbot angles', 'Yaw Right' .. spacing, -180, 180, 0, true, '°' }, {
            callback = function()
                return is_visible()
                and menu.prod[ tabs.antiaim ][value .. '::yaw']:get() == enum.ui.yaw[#enum.ui.yaw]
            end
        })

        menu.new(tabs.antiaim, value .. '::yaw_jitter', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Yaw Jitter' .. spacing, unpack(enum.ui.yaw_jitter) }, {
            callback = is_visible
        })

        menu.new(tabs.antiaim, value .. '::yaw_jitter_type', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Yaw Jitter Type' .. spacing, { 'Static', 'Switch Min/Max', 'Random' } }, {
            callback = function ()
                return is_visible()
                and menu.prod[ tabs.antiaim ][value .. '::yaw_jitter']:get() ~= enum.ui.yaw_jitter[ 1 ]
            end
        })

        menu.new(tabs.antiaim, value .. '::jitter_amount', ui.new_slider, { 'AA', 'Anti-aimbot angles', '\n jitter_amount' .. spacing, -180, 180, 0, true, '°' }, {
            callback = function()
                return is_visible()
                and menu.prod[ tabs.antiaim ][value .. '::yaw_jitter']:get() ~= enum.ui.yaw_jitter[1]
            end
        })

        menu.new(tabs.antiaim, value .. '::jitter_amount2', ui.new_slider, { 'AA', 'Anti-aimbot angles', '\n jitter_amount 2' .. spacing, -180, 180, 0, true, '°' }, {
            callback = function()
                return is_visible()
                and menu.prod[ tabs.antiaim ][value .. '::yaw_jitter']:get() ~= enum.ui.yaw_jitter[ 1 ]
                and menu.prod[ tabs.antiaim ][value .. '::yaw_jitter_type']:get() ~= 'Static'
            end
        })

        menu.new(tabs.antiaim, value .. '::body_yaw', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Body yaw' .. spacing, unpack(enum.ui.body_yaw) }, {
            callback = is_visible
        })

        menu.new(tabs.antiaim, value .. '::body_yaw_amount', ui.new_slider, { 'AA', 'Anti-aimbot angles', '\n body_yaw_amount' .. spacing, -180, 180, 0, true, '°' }, {
            callback = function()
                return is_visible()
                and menu.prod[ tabs.antiaim ][value .. '::body_yaw']:get() ~= enum.ui.body_yaw[1]
            end
        })

        menu.new(tabs.antiaim, value .. '::freestanding_body_yaw', ui.new_checkbox, { 'AA', 'Anti-aimbot angles', 'Freestanding body yaw' .. spacing, false }, {
            callback = function()
                return is_visible()
                and menu.prod[ tabs.antiaim ][value .. '::body_yaw']:get() ~= enum.ui.body_yaw[1]
                and menu.prod[ tabs.antiaim ][value .. '::body_yaw']:get() ~= enum.ui.body_yaw[3]
            end
        })

        spacing = spacing .. '\x20'
    end
end


menu.new(tabs.visuals, 'Indicators', ui.new_checkbox, { 'AA', 'Anti-aimbot angles', 'Crosshair Indicators' }) do

    menu.new(tabs.visuals, 'Ind_Style', ui.new_combobox, {'AA', 'Anti-aimbot angles', 'Indicator Type', {'Default', 'Fade'}}, {
        callback = function ()
            return menu.prod[ tabs.visuals ]['Indicators']:get()
        end
    })

end


menu.new(tabs.visuals, 'Arrows', ui.new_checkbox, { 'AA', 'Anti-aimbot angles', 'Manual Arrows' })

menu.new(tabs.visuals, 'Watermark', ui.new_checkbox, { 'AA', 'Anti-aimbot angles', 'Watermark'}) do
    menu.new(tabs.visuals, 'Watermark_Type', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Watermark Type', { 'Country Based', 'Fade' } }, {
        callback = function ()
            return menu.prod[ tabs.visuals ]['Watermark']:get()
        end
    })
end

do
    menu.new(tabs.visuals, 'Separator', ui.new_label, {'AA', 'Anti-aimbot angles', '> Additional Indicator Features <'})

    menu.new(tabs.visuals, 'Anim_Type', ui.new_combobox, {'AA', 'Anti-aimbot angles', 'Fade Animation Type', {'Right to Left', 'Left to Right'}})

    menu.new(tabs.visuals, 'DamageIndicator', ui.new_checkbox, {'AA', 'Anti-aimbot angles', 'Damage Indicator'}, {
        callback = function ()
            return menu.prod[ tabs.visuals ]['Indicators']:get()
        end
    })

    menu.new(tabs.visuals, 'DamageIndicatorFont', ui.new_combobox, {'AA', 'Anti-aimbot angles', 'Damage Font', {'Default', 'Pixel'}}, {
        callback = function ()
            return menu.prod[ tabs.visuals ]['Indicators']:get()
            and menu.prod[ tabs.visuals ]['DamageIndicator']:get()
        end
    })


    menu.new(tabs.visuals, 'Adjustments', ui.new_checkbox, { 'AA', 'Anti-aimbot angles', 'Adjust Position While Scoped' }, {
        callback = function()
            return menu.prod[ tabs.visuals ]['Indicators']:get()
        end
    })

    menu.new(tabs.visuals, 'HideArrows', ui.new_checkbox, { 'AA', 'Anti-aimbot angles', 'Hide Arrows In Scope' }, {
        callback = function()
            return menu.prod[ tabs.visuals ]['Arrows']:get()
        end
    })

    menu.damage_key = menu.new(tabs.visuals, 'DamageOverride', ui.new_hotkey, { 'AA', 'Anti-aimbot angles', 'Damage Override Key' }, {
        callback = function()
            return menu.prod[ tabs.visuals ]['Indicators']:get()
        end
    })

    menu.new(tabs.visuals, 'Avatar_Type', ui.new_combobox, {'AA', 'Anti-aimbot angles', 'Avatar Type', {'Country', 'Steam'}}, {
        callback = function ()
            return menu.prod[ tabs.visuals ]['Watermark']:get()
            and menu.prod[ tabs.visuals ]['Watermark_Type']:get() == 'Country Based'
        end
    })

    menu.new(tabs.visuals, 'CustomInputLabel', ui.new_label, { 'AA', 'Anti-aimbot angles', 'Custom Username' }, {
        callback = function()
            return menu.prod[ tabs.visuals ]['Watermark']:get()
        end
    })

    menu.new(tabs.visuals, 'CustomInput', ui.new_textbox, { 'AA', 'Anti-aimbot angles', 'Custom Username' }, {
        config = false,
        callback = function()
            return menu.prod[ tabs.visuals ]['Watermark']:get()
        end
    })

    menu.new(tabs.visuals, 'MainColorLabel', ui.new_label, { 'AA', 'Anti-aimbot angles', 'Main Color' }, {
        callback = function()
            return menu.prod[ tabs.visuals ]['Indicators']:get()
            or menu.prod[ tabs.visuals ]['Arrows']:get()
            or menu.prod[ tabs.visuals ]['Watermark']:get()
        end
    })

    menu.new(tabs.visuals, 'MainColor', ui.new_color_picker, { 'AA', 'Anti-aimbot angles', 'Main Color', 164, 193, 255, 255 }, {
        callback = function()
            return menu.prod[ tabs.visuals ]['Indicators']:get()
            or menu.prod[ tabs.visuals ]['Arrows']:get()
            or menu.prod[ tabs.visuals ]['Watermark']:get()
        end
    })

    menu.new(tabs.visuals, 'AltolorLabel', ui.new_label, { 'AA', 'Anti-aimbot angles', 'Alt Color' }, {
        callback = function()
            return menu.prod[ tabs.visuals ]['Indicators']:get()
            or menu.prod[ tabs.visuals ]['Arrows']:get()
            or menu.prod[ tabs.visuals ]['Watermark']:get()
        end
    })

    menu.new(tabs.visuals, 'AltColor', ui.new_color_picker, { 'AA', 'Anti-aimbot angles', 'Alt Color', 255, 255, 255, 255 }, {
        callback = function()
            return menu.prod[ tabs.visuals ]['Indicators']:get()
            or menu.prod[ tabs.visuals ]['Arrows']:get()
            or menu.prod[ tabs.visuals ]['Watermark']:get()
        end
    })

    menu.new(tabs.visuals, 'BackgroundColorLabel', ui.new_label, { 'AA', 'Anti-aimbot angles', 'Background Color' }, {
        callback = function()
            return (menu.prod[ tabs.visuals ]['Watermark']:get() or menu.prod[ tabs.visuals ]['Indicators']:get())
            and (menu.prod[ tabs.visuals ]['Watermark_Type']:get() == 'Fade' or menu.prod[ tabs.visuals ]['Ind_Style']:get() == 'Fade')
        end
    })

    menu.new(tabs.visuals, 'BackgroundColor', ui.new_color_picker, { 'AA', 'Anti-aimbot angles', 'Background Color', 17, 17, 17, 255 }, {
        callback = function()
            return (menu.prod[ tabs.visuals ]['Watermark']:get() or menu.prod[ tabs.visuals ]['Indicators']:get())
            and (menu.prod[ tabs.visuals ]['Watermark_Type']:get() == 'Fade' or menu.prod[ tabs.visuals ]['Ind_Style']:get() == 'Fade')
        end
    })
end


menu.new(tabs.misc, 'Functions', ui.new_multiselect, { 'AA', 'Anti-aimbot angles', 'Misc functions', unpack(enum.misc.functions) })

menu.new(tabs.misc, 'AnimationBreakers', ui.new_multiselect, { 'AA', 'Anti-aimbot angles', 'Animation Breakers', { 'Leg Breaker', 'Air Legs', 'Zero Pitch on Land' }}, {
    callback = function ()
        return table.find(menu.prod[ tabs.misc ][ 'Functions' ]:get(), enum.misc.functions[ 1 ])
    end
})

menu.new(tabs.misc, 'LegsType', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Leg Breaker Type', { 'Static', 'Walking' }}, {
    callback = function ()
        return table.find(menu.prod[ tabs.misc ][ 'Functions' ]:get(), enum.misc.functions[ 1 ])
        and table.find(menu.prod[ tabs.misc ][ 'AnimationBreakers' ]:get(), 'Leg Breaker')
    end
})

menu.new(tabs.misc, 'AirLegsType', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Air Legs Type', { 'Static', 'Walking' }}, {
    callback = function ()
        return table.find(menu.prod[ tabs.misc ][ 'Functions' ]:get(), enum.misc.functions[ 1 ])
        and table.find(menu.prod[ tabs.misc ][ 'AnimationBreakers' ]:get(), 'Air Legs')
    end
})

menu.new(tabs.misc, 'DefaultConfig', ui.new_button, { 'AA', 'Anti-aimbot angles', 'Load Default Config', function() end })
menu.new(tabs.misc, 'ExportConfig', ui.new_button, { 'AA', 'Anti-aimbot angles', 'Export settings to clipboard', function() end })
menu.new(tabs.misc, 'ImportConfig', ui.new_button, { 'AA', 'Anti-aimbot angles', 'Import settings from clipboard', function() end })


menu.prod[ tabs.misc ]['DefaultConfig']:register_callback(function ()
    local decoded = configs.import('exscord::Xyo1U2MycfkbTNhzSxqaWOcpcio1SNwgcfkbWN5nTi93TbcpciGaWxEbCjpbFN50SH1LSN1bT3FbCjpbF3ouWNBkCfl5QPUbChpbAJZvcEwhRjGUd1olR2a0ch0pchB0QN5gCfl5QPWYQN1uWN50cflTAe0pcgelUbIncEByT3MfSVk6RienRM95QPWYTxhqSPGYUihjSsFbChp2Ae0pcgWpT2oaTVk6XNe3P3olR2a0cflTAe0pcgWpT2oaTVk6XNe3P2whRjFbChpvPHvbMPBlTiU6CjhaW19aTN91TjFbChpqAJZvPHvbK3GaTiF6Ci92RPoySNGhcflTWso1RM0pchBpT3UqTN90SN9tCfl5QPWYSih0WxMycflTcfKZM2e5ch0pchBpT3UqTN90SN9tCfliQNqhP3haW19pSN1lWe9pRNR0cflTAfMWdOoBT3RhCfl5QPWYSih0WxMycflTcgBhTjGhUboWdOoJTx93dN1uWxhuTfk6XNe3P3olR2a0cflTAe0pcgWpT2oaTVk6XNe3cflTcg9iRboWdOoJTx93dN1uWxhuTfk6RjohRPB0QN5gSN5jP2ouRshYXNe3cflTRiepU2MWdOoLSPc6CjhaW19ySNWkWOc6NzEzPHvbK3GaTiF6CiRaS2MYXNe3P2wlTNh0P2whRjFbChp2Ae0pcgByT3MfSVk6RjohRPB0QN5gSN5jP2ouRshYXNe3cflTRiepU2MWdOoLSPc6CjhaW19pRNR0cflTdJEzPHvbMPBlTiU6CiouRshYXNe3cflTcgllWsGhUboWdOoBT3RhCfliQNqhP3haW19pSN1lWe9pRNR0cflTBfLWdOoBT3RhCflvSPGfSOc6NyoERNRaWNw0ch0pchMzSN5jCflvSPGfSOc6NyoDRiQbPHvbFNhycOpZF3ouWNBkCfliQNqhP3haW19pSN1lWe9pQNohTOc6NyoxQNqhcehaWyLASN1lWOIZcOIZch0pcg1uWiK6CjhaW19mSPG0RPoYWshvRHc6NyoJWxe0SNAbPHvbF3ouWNBkCfliQNqhP3haW19pSN1lWe9pQNohTOc6NyoxQNqhcehaWyLASN1lWOIZcOIZcOoWdOoVUi91Q2Z6CillWsGhUh9aTN91TjFbChp0Ae0pcgRuUjWaUiGBQN51QNvbChqiQNwzRHvydVA4PHvbG2wuQiepCflmSPG0RPoYQN1uWN50cflTAe0pcg1uWiK6CjhaW19pRNR0cflTdJE2PHvbFNhycOpZF3ouWNBkCflvSPGfSOc6NyoERNRaWNw0ch0pchMzSN5jCflmSPG0RPoYQN1uWN50cflTAJWWdOoLSPcZryLVUi91Q2Z6CjhaW19aTN91TjFbChpvPHvbFNhycOpZF3ouWNBkCfl5QPWYQiezRHc6NyoLWOL0QPojRPGzch0pcgWpT2oaTVk6Qi9gXM95QPUbChpbJ2Rich0pcgByT3MfSVk6XNe3P2whRjFbChpqBh0pcgelUbIncEByT3MfSVk6Qi9gXM95QPWYQN1uWN50cflTAe0pchG5UxKbChpbFN50SH1LSN0ZFjMlTxGhUboWdOoBT3RhCfliQNqhP3haW19pSN1lWe9pQNohTOc6NyoxQNqhcehaWyLASN1lWOIZch0pcgelUfk6T3RhUjolRxKbChq0UjMhPHvbFNhyCfl5QPWYSih0WxMycflTcgBhTjGhUboWdOoMU2htRzk6XNe3cflTcfE4AOoWdOoJTx93dN1uWxhuTfk6Uxh0Q2ZbChpbGxMiQPMpWOoWdOoMU2htRzk6RjohRPB0QN5gSN5jP2ouRshYXNe3cflTRiepU2MWdOoJWxetRVk6Qi9gXM95QPUbChpbHih0WxMych0pcg1uWiK6CiRyRNMzWxetRxhtR19bT2G5P3haWyc6N2RaTsBhPHvbK3GaTiF6CiRaS2MYXNe3P2wlTNh0P2waQiMpcflTcgRaS2KZNNe3cEwlTNh0cOoWdOoBT3RhCflbT2G5P3haW19aTN91TjFbChpvPHvbMPBlTiU6CjhaW19mSPG0RPcbChpbF2MtWxMych0pchB0QN5gCflmSPG0RPoYQN1uWN50cflTAzLWdOoMU2htRzk6RienRM95QPWYTxhqSPGYTxebRNvbChpbGienRHLRQPUZJxhqSPFZcOIZcOIZch0pcgWpT2oaTVk6RienRM95QPWYTxhqSPGYTxMiWOc6NzQvPHvbFNhycOpZF3ouWNBkCfl5QPWYSih0WxMycflTcgBhTjGhUboWdOosTx9bQNv6CjhaW19mSPG0RPoYWshvRHc6NyoJWxe0SNAbPHvbMPBlTiU6CiouRshYXNe3P2eqT3MtWOc6NzLWdOosTx9bQNv6CjhaW19mSPG0RPcbChpbJ2Rich0pcg1uWiK6Ci92RPoySNGhcflTWso1RM0pchBpT3UqTN90SN9tCfluWiMyUihgRHc6N3GyWNMWdOoJTx93dN1uWxhuTfk6RienRM95QPWYTxhqSPGYUihjSsFbChpwAe0pchB0QN5gCflmSPG0RPoYQN1uWN50Abc6NzLWdOoBT3RhCflmSPG0RPoYQN1uWN50cflTBJoWdOoMU2htRzk6XNe3P2llWsGhUh90XPLhcflTchB0QPGlQyoWdOoJWxetRVk6XNe3P2llWsGhUh90XPLhcflTchB0QPGlQyoWdOoJWxetRVk6XNe3P2oaU2KbChpbFPFZWxeyR2M0UyoWdOoJTx93dN1uWxhuTfk6XNe3P2oaU2KbChpbFPFZWxeyR2M0UyoWdOosTx9bQNv6CjhaW19aTN91TjFbChpvPHvbF3ouWNBkCflbT2G5P3haWyc6NyorSPG0RPcbPHvbK3GaTiF6CjhaW19ySNWkWOc6NzcyPHvbJN92RJk6XNe3P2eqT3MtWOc6NzLWdOoLSPc6CiouRshYXNe3cflTcgllWsGhUboWdOoVUi91Q2Z6CiouRshYXNe3P2eqT3MtWOc6NzLWdOoJTx93dN1uWxhuTfk6XNe3cflTcfE4AOoWdOoBT3RhCflmSPG0RPoYQN1uWN50Abc6Ny02BM0pchB0QN5gCfl5QPWYTxMiWOc6Ny0wBM0pchBpT3UqTN90SN9tCfliQNqhP3haW19pSN1lWe9pQNohTOc6NyoxQNqhcehaWyLASN1lWOIZcOoWdOoVT250Ui9pTxMycflTWso1RM0pcg1uWiK6CiRaS2MYXNe3P2wlTNh0P3olR2a0cflTBfLWdOoLSPcZryLVUi91Q2Z6CjhaW19pRNR0cflTdJEzPHvbF3ouWNBkCfl5QPWYQN1uWN50cflTAe0pcgelUbIncEByT3MfSVk6XNe3cflTcfE4AOLARNR0PO9HSNWkWOoWdOoJTx93dN1uWxhuTfk6Sih0WxMyP2eqT3MtWOc6NzKvPHvbK3GaTiF6CiRaS2MYXNe3P2wlTNh0P3olR2a0cflTBfLWdOoLSPcZryLVUi91Q2Z6CiRyRNMzWxetRxhtR19bT2G5P3haWyc6N2RaTsBhPHvbFNhycOpZF3ouWNBkCfluWiMyUihgRHc6N3GyWNMWdOoLSPc6CiouRshYXNe3P2eqT3MtWOc6NzLWdOoJWxetRVk6RjohRPB0QN5gSN5jP2ouRshYXNe3cflTRiepU2MWdOoLSPcZryLVUi91Q2Z6CillWsGhUh9aTN91TjFycflTAe0pcgWpT2oaTVk6Sih0WxMyP2eqT3MtWVcbChpvPHvbF3ouWNBkCfl5QPWYSih0WxMycflTcgBhTjGhUboWdOoVUi91Q2Z6CjhaW19bQPBhcflTcge0csGaUiWhWsAbPHvbFNhyCfl5QPWYQiezRHc6NyoLWOL0QPojRPGzch0pcgelUfk6RienRM95QPWYTxhqSPGYTxebRNvbChpbGienRHLRQPUZJxhqSPFZcOIZch0pcgelUfk6RienRM95QPWYTxhqSPGYTxMiWOc6NzQvPHvbK3GaTiF6CjhaWyc6NycwCVIZJxMiWevuKihjSsFbPHvbMPBlTiU6Ci92RPoySNGhcflTWso1RM0pcgWpT2oaTVk6RienRM95QPWYTxhqSPGYTxebRNvbChpbGienRHLRQPUZJxhqSPFbPHvbG2wuQiepCfliQNqhP3haW19pSN1lWe9ySNWkWOc6NzQvPHvbJN92RJk6XNe3cflTcfE4AOLARNR0PO9HSNWkWOoWdOoBT3RhCfl5QPWYUihjSsFbChp2PHvbFNhyCflmSPG0RPoYQN1uWN50Abc6NzLWdOoJWxetRVk6Qi9gXM95QPWYQN1uWN50cflTAe0pchMzSN5jCfliQNqhP3haW19pSN1lWe9ySNWkWOc6NzQvPHvbF3ouWNBkCfliQNqhP3haW19pSN1lWe9pRNR0cflTBfLWdOoMU2htRzk6XNe3P2oaU2KbChpbFPFZWxeyR2M0UyoWdOosTx9bQNv6CjLlWxBkcflTcg9iRboWdOoJTx93dN1uWxhuTfk6Sih0WxMyP2eqT3MtWVcbChpvPHvbJxMiWE1aTjMaTOc6N3GyWNKpAbvzCM0pcgelUfk6XNe3cflTcfE4AOLARNR0PO9HSNWkWOoWdOoLSPc6CillWsGhUh9aTN91TjFbChpzBM0pchBpT3UqTN90SN9tCfl5QPWYTxMiWOc6NzLWdOoJTx93dN1uWxhuTfk6XNe3P2llWsGhUh90XPLhcflTchB0QPGlQyoWdOoBT3RhCflbT2G5P3haWyc6NyorSPG0RPcbPHvbG2wuQiepCflbT2G5P3haW19aTN91TjFbChpvPHvbJN92RJk6XNe3P2oaU2KbChpbFPFZWxeyR2M0UyoWdOoLSPcZryLVUi91Q2Z6CiouRshYXNe3cflTcgllWsGhUboWdOosTx9bQNv6CjhaW19bQPBhcflTcgwuQ2epcsRlRPUbPHvbFNhycOpZF3ouWNBkCflmSPG0RPoYQN1uWN50cflTBVLWdOoVUi91Q2Z6CiRaS2MYXNe3P2wlTNh0P3olR2a0cflTBfLWdOoLSPcZryLVUi91Q2Z6CjhaW19mSPG0RPoYWshvRHc6NyoJWxe0SNAbPHvbFNhycOpZF3ouWNBkCfl5QPWYUihjSsFbChpwA10pcgByT3MfSVk6XNe3P3olR2a0cflTAJLWdOoJTx93dN1uWxhuTfk6XNe3P2eqT3MtWOc6NzGWdOoJWxetRVk6XNe3P2llWsGhUbc6NyoVRN50RPcbPHvbKihjSsGBQN51QNvbChq0UjMhdVcpAzWWdOoVUi91Q2Z6Ci92RPoySNGhcflTWso1RM0pchBpT3UqTN90SN9tCflbT2G5P3haW19aTN91TjFbChpvPHvbK3GaWxhfJNetWNepUyc6N3GyWNMWdOoLSPcZryLVUi91Q2Z6CiRaS2MYXNe3P2wlTNh0P2whRjFbChp2Ae0pcgelUfk6XNe3P2llWsGhUh90XPLhcflTchB0QPGlQyoWdOoJTx93dN1uWxhuTfk6Qi9gXM95QPUbChpbHih0WxMych0pcgMgR2MRQPUbChqiQNwzRHvwPHvbMPBlTiU6CillWsGhUh9aTN91TjFycflTAe0pcgelUfk6XNe3P2eqT3MtWOc6NzLWdOosTx9bQNv6CiRyRNMzWxetRxhtR19bT2G5P3haWyc6N2RaTsBhPHvbGjMtQ3GlT25zcflTNyoLTjGldNoaQ2qzWxebcbvbFNGmWPB0cx9tdPBkT3FZRienRNwaRycpcgepTx93cxetWxgqQNhqcx9tcsMzRHcpcg1aTjMaTOLaTjGldNelTHcpcgRyRNMzWxetRxhtRyoWPHvbK3GaTiF6CjLlWxBkcflTcgGhRie1TsFbPHvbMPBlTiU6CjhaW19pRNR0cflTAe0pcgByT3MfSVk6XNe3P2llWsGhUh90XPLhcflTchB0QPGlQyoWdOoHRPBhWE1aTjMaTOc6N2RaTsBhdVoWdOoLSPc6CiRyRNMzWxetRxhtR19bT2G5P3haWyc6N2RaTsBhPHvbMPBlTiU6CjhaW19ySNWkWOc6NzLWdOoLSPc6CiRaS2MYXNe3P2wlTNh0P3olR2a0cflTBfLWdOoMU2htRzk6RienRM95QPWYTxhqSPGYTxMiWOc6NzQvPHvbFNhyCflvSPGfSOc6NyoERNRaWNw0ch0pcgRyRNMzWxetRxhtRyc6N2RaTsBhdVEpAJaWdOoVUi91Q2Z6CillWsGhUh9aTN91TjFycflTdJUwPHvbF3ouWNBkCflvSPGfSOc6NyoERNRaWNw0ch19dOohXsBfT3ogcfl7cgWyT3MvUyc6NyoBSPBfch19dOoNSPB1QNwzcfl7cghtRe9JWshpRHc6NyoERNRaWNw0ch0pcgGaTNejRKhtRxhfQPGuUbc6N2RaTsBhPHvbFNGmWPB0TNMtWsAbChq0UjMhPHvbGxeqQNWhJ3RhUjolRxKbChqiQNwzRHvwdVRWdOoPQPGhUi1aUipbChq0UjMhPHvbK2MvQPoaWx9ycflTcf4ZFNGgSPGlT25aTOLoTiGlQ2e0T3cZGiMaWsMyRPAZDOoWdOocSNGhFPoyT3WzcflTRiepU2MWdOoLTsGuTx9yJxebRNvbChpbFNw0cEBuTx9ych0pcgetSN1YMshvRHc6NyoARNR0csGuceolR2a0ch0pcgGaTNejRKhtRxhfQPGuUgRuTjFbChpbKxh4RNvbPHvbFNw0F29pT3cbChpyBJKpAfK1dVc1BHvyBJMWdOoLUjouW3AbChq0UjMhPHvbHN5gSNBaWx9yUyc6N3GyWNMWdOoOQNBnR3ouWN5gF29pT3cbChpvdVIpAOvyBJMWdOoOQNBnR3ouWN5gF29pT3oAQNohTOc6NyoOQNBnR3ouWN5gcEBuTx9ych0pchWaWxMyTNeyS19KXPLhcflTcgBuWN50UjgZFiezRNFbPHvbJNelTgBuTx9ycflTAJQ0dVE5AyvyBJKpAfK1PHvbF3MzWx9qHN5vWPGAQNohTOc6NyoVWPB0T20ZMPBhUi5aTNKbPHvbFPRaWxeyP1G5UxKbChpbF291TjGyXHoWdOoBQNhtF29pT3oAQNohTOc6NyoBQNhtcEBuTx9ych19dOoBSPBfcfl7cgwhR3BKXPLhcflTchWaTxqlTiUbPHvbFN5lTNe0SN9tFjohQNqhUjAbChqTcgwhRyLOUiMaS2MycbvbFNhycEwhR3AbPM0pcgR1TiB0SN9tUyc6N1pbFN5lTNe0SN9tcEoyRNenRPozch1WdOoLSPoARNWzMshvRHc6NyoPQNwnSN5jch19YHvbRxe0RHc6cfEydfEydfcvAJcbYF==')
    if not decoded then
        return
    end

    message(255, 255, 255, 'Succesfully loaded default script settings!')
end)


menu.prod[ tabs.misc ]['ExportConfig']:register_callback(function()
    local data = configs.export()
    clipboard.set(data)
end)

menu.prod[ tabs.misc ]['ImportConfig']:register_callback(function()
    local decoded = configs.import()
    if not decoded then
        return
    end

    message(255, 255, 255, 'Succesfully imported settings from clipboard!')
end)

local anti_aim = {
    manual_reset = 0,
    manual_yaw = 0,

    manual_items = {
        [ menu.prod[ tabs.antiaim ]['LeftManual'] ] = {
            yaw = 1,
            state = false,
        },

        [ menu.prod[ tabs.antiaim ]['RightManual'] ] = {
            yaw = 2,
            state = false,
        },

        [ menu.prod[ tabs.antiaim ]['ForwardManual'] ] = {
            yaw = 3,
            state = false,
        },

        [ menu.prod[ tabs.antiaim ]['ResetManual'] ] = {
            yaw = 0,
            state = false,
        },
    },

    manual_degree = {
        -90,
        90,
        180,
        0,
    },

    defensive = 0,

    ground_ticks = 0,
    last_body_yaw = 0,
}

ui.set(menu.prod[ tabs.antiaim ]['LeftManual'].m_reference, 'Toggle')
ui.set(menu.prod[ tabs.antiaim ]['RightManual'].m_reference, 'Toggle')
ui.set(menu.prod[ tabs.antiaim ]['ResetManual'].m_reference, 'Toggle')
ui.set(menu.prod[ tabs.antiaim ]['ForwardManual'].m_reference, 'Toggle')

local visuals = { }
local misc = { }

anti_aim.handle_ground = function()
    local lp = entity.get_local_player()
    if not lp then
        return
    end

    local flags = entity.get_prop(lp, 'm_fFlags')
    if not flags then
        return
    end

    if bit.band(flags, 1) == 0 then
        anti_aim.ground_ticks = 0
    elseif anti_aim.ground_ticks <= 5 then
        anti_aim.ground_ticks = anti_aim.ground_ticks + 1
    end
end

anti_aim.handle_defensive = function()
    local lp = entity.get_local_player()

    if lp == nil or not entity.is_alive(lp) then
        return
    end

    local Entity = native_GetClientEntity(lp)
    local m_flOldSimulationTime = ffi.cast("float*", ffi.cast("uintptr_t", Entity) + 0x26C)[0]
    local m_flSimulationTime = entity.get_prop(lp, "m_flSimulationTime")

    local delta = m_flOldSimulationTime - m_flSimulationTime;

    if delta > 0 then
        anti_aim.defensive = globals.tickcount() + toticks(delta - client.latency());
        return;
    end
end

anti_aim.on_ground = function()
    return anti_aim.ground_ticks >= 5
end

local jit_c = 1
local last_body_yaw = 0
local ground_ticks = 0

callback.new('AA INFO', 'setup_command', function (cmd)
    local lp = entity.get_local_player()
    if lp == nil or not entity.is_alive(lp) then
        return
    end

    if entity.get_prop(lp, 'm_hGroundEntity') then
        ground_ticks = ground_ticks + 1
    else
        ground_ticks = 0
    end

    anti_aim.handle_ground()

	if cmd.chokedcommands == 0 then
        jit_c = jit_c + 1
	end
end)

anti_aim.condition = function(cmd)
    anti_aim.handle_ground()

    if cmd.in_use == 1 then
        return enum.anti_aimbot.states[8]
    end

    local lp = entity.get_local_player()
    if not lp then
        return
    end

    local m_flags = entity.get_prop(lp, 'm_fFlags')
    if not m_flags then
        return
    end

    local duck_amount = entity.get_prop(lp, 'm_flDuckAmount')
    if not duck_amount then
        return
    end

    local velocity = vector(entity.get_prop(lp, 'm_vecVelocity')):length()
    if not velocity then
        return
    end

    local in_air = not anti_aim.on_ground()
    local in_crouch = duck_amount > 0 or ui.get(reference.RAGE.other.duck_peek_assist);

    if in_air then
        return enum.anti_aimbot.states[in_crouch and 6 or 5]
    end

    if in_crouch then
        return enum.anti_aimbot.states[7]
    end

    if velocity > 2 and not ui.get(reference.AA.other.slow_motion[2]) then
        return enum.anti_aimbot.states[3]
    end

    if ui.get(reference.AA.other.slow_motion[2]) then
        return enum.anti_aimbot.states[4]
    end

    return enum.anti_aimbot.states[2]
end

anti_aim.anti_backstab = function(cmd)
    if not table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), enum.anti_aimbot.functions[1]) then
        return
    end

    local lp = entity.get_local_player()
    if not lp then
        return
    end

    local eye = vector(client.eye_position())

    local target = {
        idx = nil,
        distance = 158,
    }

    local enemies = entity.get_players(true)

    for _, entindex in pairs(enemies) do
        local weapon = entity.get_player_weapon(entindex)
        if not weapon then
            goto skip
        end

        local weapon_name = entity.get_classname(weapon)
        if not weapon_name then
            goto skip
        end

        if weapon_name ~= 'CKnife' then
            goto skip
        end

        local origin = vector(entity.get_origin(entindex))
        local distance = eye:dist(origin)

        if distance > target.distance then
            goto skip
        end

        target.idx = entindex
        target.distance = distance
        ::skip::
    end

    if not target.idx then
        return
    end

    local origin = vector(entity.get_origin(target.idx))
    local delta = eye - origin
    local angle = vector(delta:angles())
    local camera = vector(client.camera_angles())
    local yaw = normalize(angle.y - camera.y, -180, 180)

    menu.override(reference.AA.angles.yaw_base, enum.ui.yaw_base[1])
    menu.override(reference.AA.angles.yaw[2], yaw)

    return true
end


anti_aim.handle_manuals = function(cmd)
    if not table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), enum.anti_aimbot.functions[4]) then
        anti_aim.manual_yaw = 0
    end

    for key, value in pairs(anti_aim.manual_items) do
        local state, m_mode = ui.get(key.m_reference)

        if state == value.state then
            goto skip
        end

        value.state = state

        if m_mode == 1 then
            anti_aim.manual_yaw = state and value.yaw or anti_aim.manual_reset
            goto skip
        end

        if m_mode == 2 then
            if anti_aim.manual_yaw == value.yaw then
                anti_aim.manual_yaw = anti_aim.manual_reset
            else
                anti_aim.manual_yaw = value.yaw
            end
            goto skip
        end

        ::skip::
    end
end

anti_aim.preset = {
    -- Stand
    [ enum.anti_aimbot.states[ 2 ] ] = {

        pitch = enum.ui.pitch[ 2 ],

        yaw = enum.ui.yaw[ 7 ],

        yaw_left = -12,
        yaw_right = 12,

        yaw_jitter = enum.ui.yaw_jitter[ 3 ],
        jitter_amount = 28,

        body_yaw = enum.ui.body_yaw[ 3 ],
        body_yaw_amount = -19,
      },
      -- move
      [ enum.anti_aimbot.states[ 3 ] ] = {

        pitch = enum.ui.pitch[ 2 ],

        yaw = enum.ui.yaw[ 7 ],

        yaw_left = -12,
        yaw_right = 6,

        yaw_jitter = enum.ui.yaw_jitter[ 3 ],
        jitter_amount = 45,

        body_yaw = enum.ui.body_yaw[ 3 ],
        body_yaw_amount = -19,
      },
      -- Slow-motion
      [ enum.anti_aimbot.states[ 4 ] ] = {

        pitch = enum.ui.pitch[ 2 ],

        yaw = enum.ui.yaw[ 7 ],

        yaw_left = -14,
        yaw_right = 14,

        yaw_jitter = enum.ui.yaw_jitter[ 3 ],
        jitter_amount = 43,

        body_yaw = enum.ui.body_yaw[ 3 ],
        body_yaw_amount = -19,
      },
      -- Aero
      [ enum.anti_aimbot.states[ 5 ] ] = {

        pitch = enum.ui.pitch[ 2 ],

        yaw = enum.ui.yaw[ 7 ],

        yaw_left = -13,
        yaw_right = 13,

        yaw_jitter = enum.ui.yaw_jitter[ 3 ],
        jitter_amount = 37,

        body_yaw = enum.ui.body_yaw[ 3 ],
        body_yaw_amount = -19,
      },
      -- Aero-
      [ enum.anti_aimbot.states[ 6 ] ] = {

        pitch = enum.ui.pitch[ 2 ],

        yaw = enum.ui.yaw[ 7 ],

        yaw_left = -12,
        yaw_right = 12,

        yaw_jitter = enum.ui.yaw_jitter[ 3 ],
        jitter_amount = 38,

        body_yaw = enum.ui.body_yaw[ 3 ],
        body_yaw_amount = -19,
      },
      -- Crouch
      [ enum.anti_aimbot.states[ 7 ] ] = {

        pitch = enum.ui.pitch[ 2 ],

        yaw = enum.ui.yaw[ 7 ],

        yaw_left = -6,
        yaw_right = 10,

        yaw_jitter = enum.ui.yaw_jitter[ 3 ],
        jitter_amount = 41,

        body_yaw = enum.ui.body_yaw[ 3 ],
        body_yaw_amount = -19,
      },
      -- Using
      [ enum.anti_aimbot.states[ 8 ] ] = {

        pitch = enum.ui.pitch[ 1 ],
        yaw_base = enum.ui.yaw_base[ 1 ],
        yaw = enum.ui.yaw[ 2 ],

        yaw_amount = 180,

        yaw_jitter = enum.ui.yaw_jitter[ 1 ],
        jitter_amount = 0,

        body_yaw = enum.ui.body_yaw[ 3 ],
        body_yaw_amount = -19,
    }
}

local step_3 = 1
local step_5 = 1
local prev_yaw = 0

local way_3 = {-1, 0, 1}
local way_5 = {-1, -0.5, 0, 0.5, 1}--{-0.25, 0, 1, 0.5, -0.5} --{-1, -0.5, 0, 0.5, 1}--{-1, 0, -0.5, 0.5, 1}  --{0, -0.5, 0.5, 1, -1} --{-1, -0.5, 0, 0.5, 1}

anti_aim.handle_preset = function(cmd)
    if menu.prod[ tabs.antiaim ]['Type']:get() ~= 'Preset' then
        return
    end

    local lp = entity.get_local_player()
    if not lp then
        return
    end

    local body_yaw = entity.get_prop(lp, 'm_flPoseParameter', 11)

    if cmd.chokedcommands == 0 then
        anti_aim.last_body_yaw = body_yaw * 120 - 60
    end

    local condition = callback.get('antiaim::condition', true)
    if not condition then
        return
    end

    local preset = anti_aim.preset[condition]
    if not preset then
        return
    end

    menu.override(reference.AA.angles.pitch, preset.pitch or enum.ui.pitch[4])
    menu.override(reference.AA.angles.yaw_base, preset.yaw_base or enum.ui.yaw_base[2])

    local yaw = preset.yaw or enum.ui.yaw[2]
    local yaw_amount = preset.yaw_amount or 0

    local jitter = preset.yaw_jitter or enum.ui.yaw_jitter[1]
    local jitter_amount = preset.jitter_amount or 0

    if yaw == enum.ui.yaw[ 7 ] then
        yaw = enum.ui.yaw[ 2 ]

        if anti_aim.last_body_yaw > 0 then
            yaw_amount = preset.yaw_left or 0
        elseif anti_aim.last_body_yaw < 0 then
            yaw_amount = preset.yaw_right or 0
        end

        if jitter == enum.ui.yaw_jitter[3] then
            jitter_amount = int(jitter_amount / 2)

            if anti_aim.last_body_yaw > 0 then
                yaw_amount = yaw_amount - jitter_amount
            elseif anti_aim.last_body_yaw < 0 then
                yaw_amount = yaw_amount + jitter_amount
            end

            jitter = enum.ui.yaw_jitter[1]
            jitter_amount = 0
        end
    end

    if jitter == '3 Way' then
        if cmd.chokedcommands == 0 then
            prev_yaw = jitter_amount * way_3[step_3]

            step_3 = step_3 + 1

            if step_3 > #way_3 then
                step_3 = 1
            end
        end

        jitter = 'Off'
        jitter_amount = 0
        yaw_amount = yaw_amount + prev_yaw
    end

    if jitter == '5 Way' then
        if cmd.chokedcommands == 0 then
            prev_yaw = jitter_amount * way_5[step_5]

            step_5 = step_5 + 1

            if step_5 > #way_5 then
                step_5 = 1
            end
        end

        jitter = 'Off'
        jitter_amount = 0

        yaw_amount = yaw_amount + prev_yaw
    end

    if yaw == enum.ui.yaw[4] then
        local angle = vector(client.camera_angles())
        yaw_amount = yaw_amount + angle.y

        yaw_amount = normalize(yaw_amount, -180, 180)
    end

    menu.override(reference.AA.angles.yaw[1], yaw)
    menu.override(reference.AA.angles.yaw[2], normalize(yaw_amount, -180, 180))

    menu.override(reference.AA.angles.yaw_jitter[1], jitter)
    menu.override(reference.AA.angles.yaw_jitter[2], jitter_amount)

    local body_yaw = preset.body_yaw or enum.ui.body_yaw[2]
    local freestanding_body_yaw = preset.freestanding_body_yaw or false

    if body_yaw == enum.ui.body_yaw[3] then
        freestanding_body_yaw = false
    end

    menu.override(reference.AA.angles.body_yaw[1], 'Static')
    menu.override(reference.AA.angles.body_yaw[2], 0)

    menu.override(reference.AA.angles.body_yaw[1], body_yaw)
    menu.override(reference.AA.angles.body_yaw[2], preset.body_yaw_amount or 180)
    menu.override(reference.AA.angles.freestanding_body_yaw, freestanding_body_yaw)

    menu.override(reference.AA.angles.roll, preset.roll or 0)
    return yaw_amount
end

local last_switch

anti_aim.builder = function(cmd)
    if not menu.prod[ tabs.antiaim ]['Controller']:get() or menu.prod[ tabs.antiaim ]['Type']:get() ~= 'Anti-Aim Builder' then
        return
    end

    local lp = entity.get_local_player();
    if not lp then
        return
    end

    local body_yaw = entity.get_prop(lp, 'm_flPoseParameter', 11)

    if cmd.chokedcommands == 0 then
        anti_aim.last_body_yaw = body_yaw * 120 - 60
    end

    local condition = callback.get('antiaim::condition', true)
    if not condition then
        return
    end


    if not menu.prod[ tabs.antiaim ][condition .. '::override']:get() then
        condition = enum.anti_aimbot.states[1]
    end


    menu.override(reference.AA.angles.pitch, menu.prod[ tabs.antiaim ][ condition .. '::pitch' ]:get())
    menu.override(reference.AA.angles.yaw_base, menu.prod[ tabs.antiaim ][ condition .. '::yaw_base' ]:get())

    local yaw = menu.prod[ tabs.antiaim ][ condition .. '::yaw' ]:get()
    local yaw_amount = menu.prod[ tabs.antiaim ][ condition .. '::yaw_amount' ]:get()

    local yaw_jitter = menu.prod[ tabs.antiaim ][ condition .. '::yaw_jitter' ]:get()
    local yaw_jitter_amt = menu.prod[ tabs.antiaim ][ condition .. '::jitter_amount' ]:get()
    local yaw_jitter_amt2 = menu.prod[ tabs.antiaim ][ condition .. '::jitter_amount2' ]:get()
    local yaw_jitter_type = menu.prod[ tabs.antiaim ][ condition .. '::yaw_jitter_type' ]:get()


    if yaw_jitter_type == 'Random' then
        if jit_c % 2 == 0 or last_switch == nil then
            last_switch = math.random( menu.prod[ tabs.antiaim ][ condition .. '::jitter_amount' ]:get(), menu.prod[ tabs.antiaim ][ condition .. '::jitter_amount2' ]:get())
        end

        yaw_jitter_amt = last_switch
    elseif yaw_jitter_type == 'Switch Min/Max' then
        yaw_jitter_amt = jit_c % 4 > 1 and menu.prod[ tabs.antiaim ][ condition .. '::jitter_amount' ]:get() or yaw_jitter_amt2
    else
        yaw_jitter_amt = menu.prod[ tabs.antiaim ][ condition .. '::jitter_amount' ]:get()
    end

    if yaw == enum.ui.yaw[ 7 ] then
        yaw = enum.ui.yaw[ 2 ]
        yaw_amount = 0
        if anti_aim.last_body_yaw > 0 then
            yaw_amount = menu.prod[ tabs.antiaim ][ condition .. '::yaw_left' ]:get()
        elseif anti_aim.last_body_yaw < 0 then
            yaw_amount = menu.prod[ tabs.antiaim ][ condition .. '::yaw_right' ]:get()
        end

        if yaw_jitter == 'Center' then
			yaw_jitter_amt = int(yaw_jitter_amt / 2)
			if anti_aim.last_body_yaw > 0 then
				yaw_amount = yaw_amount - yaw_jitter_amt
			elseif anti_aim.last_body_yaw < 0 then
				yaw_amount = yaw_amount + yaw_jitter_amt
			end

			yaw_jitter = 'Off'
			yaw_jitter_amt = 0
		end
    end

    if yaw_jitter == '3 Way' then
        if cmd.chokedcommands == 0 then
            prev_yaw = yaw_jitter_amt * way_3[step_3]

            step_3 = step_3 + 1

            if step_3 > #way_3 then
                step_3 = 1
            end
        end

        yaw_jitter = 'Off'
        yaw_jitter_amt = 0
        yaw_amount = yaw_amount + prev_yaw
    end

    if yaw_jitter == '5 Way' then
        if cmd.chokedcommands == 0 then
            prev_yaw = yaw_jitter_amt * way_5[step_5]

            step_5 = step_5 + 1

            if step_5 > #way_5 then
                step_5 = 1
            end
        end

        yaw_jitter = 'Off'
        yaw_jitter_amt = 0

        yaw_amount = yaw_amount + prev_yaw
    end

    menu.override(reference.AA.angles.yaw[1], yaw)
    menu.override(reference.AA.angles.yaw[2], normalize(yaw_amount, -180, 180))
    menu.override(reference.AA.angles.yaw_jitter[1], yaw_jitter)
    menu.override(reference.AA.angles.yaw_jitter[2], yaw_jitter_amt)

    local body_yaw = menu.prod[ tabs.antiaim ][ condition .. '::body_yaw']:get()
    local freestanding_body_yaw = menu.prod[ tabs.antiaim ][ condition .. '::freestanding_body_yaw']:get()
    if body_yaw == enum.ui.body_yaw[3] then
        freestanding_body_yaw = false
    end

    ui.set(reference.AA.angles.body_yaw[1], 'Static')
    ui.set(reference.AA.angles.body_yaw[2], 0)

    menu.override(reference.AA.angles.body_yaw[1], body_yaw)
    menu.override(reference.AA.angles.body_yaw[2], menu.prod[ tabs.antiaim ][ condition .. '::body_yaw_amount']:get())

    menu.override(reference.AA.angles.freestanding_body_yaw, freestanding_body_yaw)
    menu.override(reference.AA.angles.roll, 0)
    return yaw_amount
end

anti_aim.using = function(cmd)
    if not menu.prod[ tabs.antiaim ]['Controller']:get() or
        not table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Allow anti-aim on use') then
        return
    end

    if cmd.in_use == 0 then
        return
    end

    local lp = entity.get_local_player()
    if not lp then
        return
    end

    local crouch = entity.get_prop(lp, 'm_flDuckAmount') == 1
    local team = entity.get_prop(lp, 'm_iTeamNum')
    if not team then
        return
    end

    if team == enum.team.t then
        if entity.get_prop(lp, 'm_bInBombZone') == 0 then
            goto skip_check
        end

        local m_weapon = entity.get_player_weapon(lp)
        if not m_weapon then
            goto skip_check
        end

        local name = entity.get_classname(m_weapon)
        if name == 'CC4' then
            return
        end
        ::skip_check::
    elseif team == enum.team.ct then
        local planted_c4 = entity.get_all('CPlantedC4')
        if not planted_c4 then
            goto skip_check
        end

        local origin = vector(entity.get_origin(lp))
        if not origin then
            goto skip_check
        end

        local max_distance = crouch and 42.5 or 60

        for _, entity in pairs(planted_c4) do
            local position = vector(entity.get_origin(entity))
            if not position then
                goto skip_entity
            end

            local distance = origin:dist(position)
            if distance < max_distance then
                return
            end
            ::skip_entity::
        end
        ::skip_check::
    end

    local camera = vector(client.camera_angles())
    local forward = vector(angle_to_forward(camera:unpack()))

    local eye = vector(client.eye_position())
    local _end = eye + forward * 128

    local fraction, entindex = client.trace_line(lp, eye.x, eye.y, eye.z, _end.x, _end.y, _end.z)

    if fraction ~= 1 then
        if entindex == -1 then
            goto skip_check
        end

        local name = entity.get_classname(entindex)

        if name == 'CWorld' then
            goto skip_check
        end

        if name == 'CFuncBrush' then
            goto skip_check
        end

        if name == 'CCSPlayer' then
            goto skip_check
        end

        if name == 'CHostage' then
            local hostage_origin = vector(entity.get_origin(entindex))
            local distance = eye:dist(hostage_origin)
            local max_distance = crouch and 76 or 84

            if distance < max_distance then
                return
            end

            goto skip_check
        end

        if true then
            return
        end

        ::skip_check::
    end

    local interface = callback.get('antiaim::condition')

    if interface then
        interface.recent = {
            enum.anti_aimbot.states[8]
        }
    end

    if not menu.prod[ tabs.antiaim ]['Type']:get() == 'Anti-Aim Builder' then
        menu.override(reference.AA.angles.pitch, enum.ui.pitch[1])
        menu.override(reference.AA.angles.yaw_base, enum.ui.yaw_base[1])
        menu.override(reference.AA.angles.yaw[1], enum.ui.yaw[2])
        menu.override(reference.AA.angles.yaw[2], 180)
    end


    cmd.in_use = false
    return true
end

anti_aim.defensive_antiaim = function(cmd)
    if not menu.prod[ tabs.antiaim ]['Controller']:get() or
        not table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Defensive Anti-aim') then
        return
    end

    if globals.tickcount() > anti_aim.defensive then
        return;
    end

    local pitch = menu.prod[ tabs.antiaim ]['DefensivePitch']:get();
    local yaw = menu.prod[ tabs.antiaim ]['DefensiveYaw']:get();

    if pitch ~= 'Off' then
        menu.override(reference.AA.angles.pitch, pitch)
    end

    if yaw ~= 'Off' then
        menu.override(reference.AA.angles.yaw[1], yaw)

        if yaw == '180 Left/Right' then
            if anti_aim.last_body_yaw > 0 then
                menu.override(reference.AA.angles.yaw[2], normalize(menu.prod[ tabs.antiaim ]['DefensiveYawLeft']:get(), -180, 180))
            elseif anti_aim.last_body_yaw < 0 then
                menu.override(reference.AA.angles.yaw[2], normalize(menu.prod[ tabs.antiaim ]['DefensiveYawRight']:get(), -180, 180))
            else
                menu.override(reference.AA.angles.yaw[2], 0)
            end
        else
            menu.override(reference.AA.angles.yaw[2], normalize(menu.prod[ tabs.antiaim ]['DefensiveYawAmount']:get(), -180, 180))
        end
    end
end

anti_aim.main = function(cmd)
    if not menu.prod[ tabs.antiaim ]['Controller']:get() then
        return
    end

    local manual_yaw = anti_aim.manual_degree[anti_aim.manual_yaw]
    local modified_yaw = 0

    modified_yaw = modified_yaw + (anti_aim.handle_preset(cmd) or 0)
    modified_yaw = modified_yaw + (anti_aim.builder(cmd) or 0)
    local is_antibackstabing = anti_aim.anti_backstab(cmd)

    if table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), enum.anti_aimbot.functions[2]) then
        if not ui.get(reference.AA.other.on_shot_antiaim[1]) then
            goto skip_check
        end

        if not ui.get(reference.AA.other.on_shot_antiaim[2]) then
            goto skip_check
        end

        if ui.get(reference.RAGE.aimbot.double_tap[1]) and ui.get(reference.RAGE.aimbot.double_tap[2]) then
            goto skip_check
        end

        if ui.get(reference.RAGE.other.duck_peek_assist) then
            goto skip_check
        end

        menu.override(reference.AA.fakelag.limit, 2)
        ::skip_check::
    end

    local using = anti_aim.using(cmd)

    if using then
        return
    end

    if not manual_yaw then
        if not is_antibackstabing then
            anti_aim.defensive_antiaim(cmd);
        end

        if table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Freestanding') then
            if not ui.get(menu.prod[ tabs.antiaim ]['Freestanding'].m_reference) then
                goto skip_check
            end

            menu.override(reference.AA.angles.freestanding[1], true);
            menu.override(reference.AA.angles.freestanding[2], enum.ui.hotkey_states[0])
            ::skip_check::
        end

        if table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Edge yaw') then
            if not ui.get(menu.prod[ tabs.antiaim ]['EdgeYaw'].m_reference) then
                goto skip_check
            end

            menu.override(reference.AA.angles.edge_yaw, true)
            ::skip_check::
        end
        return
    end

    if menu.prod[ tabs.antiaim ]['StaticManuals']:get() then
        menu.override(reference.AA.angles.yaw_jitter[1], enum.ui.yaw_jitter[1])
        menu.override(reference.AA.angles.body_yaw[1], enum.ui.body_yaw[4])
    else
        manual_yaw = manual_yaw + modified_yaw
    end

    menu.override(reference.AA.angles.yaw_base, enum.ui.yaw_base[1])
    menu.override(reference.AA.angles.yaw[2], normalize(manual_yaw, -180, 180))
end

anti_aim.on_death = function (e)
    if client.userid_to_entindex(e.userid) ~= entity.get_local_player() then
        return
    end

    anti_aim.last_body_yaw = 0
end

anti_aim.dt_charge = function()
    local target = entity.get_local_player()
    if not target then
        return
    end

    local weapon = entity.get_player_weapon(target)

    if target == nil or weapon == nil then
        return false
    end

    if get_curtime(16) < entity.get_prop(target, 'm_flNextAttack') then
        return false
    end

    if get_curtime(0) < entity.get_prop(weapon, 'm_flNextPrimaryAttack') then
        return false
    end

    return true
end

anti_aim.air_defensive = function (cmd)
    if not menu.prod[ tabs.antiaim ]['Controller']:get() then
        return
    end

    local condition = callback.get('antiaim::condition', true)
    if not condition then
        return
    end

    local enabled = table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Force Defensive in Air')

    if condition == 'Air' or condition == 'Air + Crouch' then
        cmd.force_defensive = enabled and 1 or 0
    end
end


local start = screen / 2 + vector(0, 15)
local dmg_drag = g_drag.new(start.x + 10, start.y - 40, 28, 16)

local state_anim = 0
local damage_anim = 0

local anim = {
    damage_hovered = 0,
    wtr_hovered = 0,
}


local function render_rect_outline(x, y, w, h, r, g, b, a)
    renderer.rectangle(x + 1, y, w - 1, 1, r, g, b, a)
    renderer.rectangle(x + w - 1, y + 1, 1, h - 1, r, g, b, a)
    renderer.rectangle(x, y + h - 1, w - 1, 1, r, g, b, a)
    renderer.rectangle(x, y, 1, h - 1, r, g, b, a)
end

do

    local elements = {
        {'DT', reference.RAGE.aimbot.double_tap[2]},
        {'ON-SHOT', reference.AA.other.on_shot_antiaim[2]},
        {'FS', menu.prod[ tabs.antiaim ]['Freestanding'].m_reference},
        {'BAIM', reference.RAGE.aimbot.force_body_aim},
        {'SAFE', reference.RAGE.aimbot.force_safe_point},
        {'DUCK', reference.RAGE.other.duck_peek_assist},
        {'DMG', menu.damage_key.m_reference}
    }


    local txt_sizes = { }

    local got_sizes = false

    local function get_minimum_damage()
        if ui.get(reference.RAGE.aimbot.min_damage_override[1]) and ui.get(reference.RAGE.aimbot.min_damage_override[2]) then
            return ui.get(reference.RAGE.aimbot.min_damage_override[3])
        end

        return ui.get(reference.RAGE.aimbot.min_damage)
    end

    visuals.inidcators = function()
        local lp = entity.get_local_player()
        if not lp then
            return
        end
        local valid = lp ~= nil and entity.is_alive(lp)

        anim.global_alpha = animations:process('Global', menu.prod[tabs.visuals]['Indicators']:get() and valid)
        if anim.global_alpha < 0.01 or lp == nil then
            return
        end

        if not got_sizes then
            for i, v in pairs(elements) do
                txt_sizes[v[1]] = vector(renderer.measure_text('-', v[1]))
            end

            got_sizes = true
        end

        anim.pulse = math.min(255, 255 - animations:process("Pulse", not (globals.realtime() * 2.5 % 6 >= 1)) * 205) / 255
        anim.default = animations:process('Default', menu.prod[tabs.visuals]['Ind_Style']:get() == 'Default')
        anim.fade = animations:process('Fade', menu.prod[tabs.visuals]['Ind_Style']:get() == 'Fade')
        anim.damage = animations:process('Damage', menu.prod[tabs.visuals]['DamageIndicator']:get())
        anim.scope = animations:process('Scope', (entity.get_prop(lp, 'm_bIsScoped') == 1 and menu.prod[tabs.visuals]['Adjustments']:get()), 10)
        anim.doubletap = animations:process('Double Tap', anti_aim.dt_charge())

        anim.menu = animations:process('menu', ui.is_menu_open(), 6)
        anim.damage_hovered = animations:lerp(anim.damage_hovered, (dmg_drag:is_hovered() and client.key_state(1)) and 0.5 or 1, 0.045)

        local main_color = { menu.prod[tabs.visuals]['MainColor']:get() }
        local back_color = { menu.prod[tabs.visuals]['BackgroundColor']:get() }
        local bind_color = { menu.prod[tabs.visuals]['AltColor']:get() }

        local dt_r, dt_g, dt_b = lerp({ 255, 25, 25, 255 }, { bind_color[1], bind_color[2], bind_color[3], 255 }, anim.doubletap)

        local add_x = 34 * anim.scope

        if anim.damage > 0.01 then
            local font = menu.prod[tabs.visuals]['DamageIndicatorFont']:get() == 'Default' and '' or '-'
            local damage = get_minimum_damage();

            damage_anim = animations:lerp(damage_anim, damage, 0.075)
            local dmg_string = damage == 0 and "AUTO" or tostring(int(damage_anim))

            renderer.text(dmg_drag.x + 4, dmg_drag.y + 4, main_color[1], main_color[2], main_color[3], 255 * anim.damage * anim.damage_hovered * anim.global_alpha, font, nil, dmg_string)
            local measure = vector(renderer.measure_text(font, dmg_string))
            render_rect_outline(dmg_drag.x, dmg_drag.y, dmg_drag.w, dmg_drag.h, 255, 255, 255, 255 * anim.damage_hovered * anim.damage * anim.menu * anim.global_alpha)
            dmg_drag:set(nil, nil, 10 + measure.x, 10 + measure.y)
        end

        local offset = 0

        local condition = callback.get('antiaim::condition', true) or 'UNKNOWN'

        local cond_sz = vector(renderer.measure_text('-', condition:upper())) do
            local pixels = cond_sz.x + 1;
            state_anim = animations:lerp(state_anim, pixels, 0.075);

            if pixels < state_anim then
                state_anim = pixels;
            end
        end

        local cond_centered = (-math.ceil(state_anim) / 2) * (1 - anim.scope) + (5 * anim.scope)

        --[[
            local add_x = 34 * anim.scope
            renderer.text(start.x - 29 + add_x, start.y + 1, 255, 255, 255, 255 * anim.default * anim.global_alpha, '-', nil, 'EXSCORD')
            renderer.text(start.x + 5 + add_x, start.y + 1, main_color[1], main_color[2], main_color[3], 255 * anim.default * anim.pulse * anim.global_alpha, '-', nil, 'DEBUG')


            local add_x = 37 * anim.scope
            renderer.text(start.x - 32 + add_x, start.y + 1, 255, 255, 255, 255 * anim.default * anim.global_alpha, '-', nil, 'EXSCORD')
            renderer.text(start.x + 2 + add_x, start.y + 1, main_color[1], main_color[2], main_color[3], 255 * anim.default * anim.pulse * anim.global_alpha, '-', nil, 'NIGHTLY')

            local add_x = 36 * anim.scope
            renderer.text(start.x - 31 + add_x, start.y + 1, 255, 255, 255, 255 * anim.default * anim.global_alpha, '-', nil, 'EXSCORD')
            renderer.text(start.x + 3 + add_x, start.y + 1, main_color[1], main_color[2], main_color[3], 255 * anim.default * anim.pulse * anim.global_alpha, '-', nil, 'STABLE')
        ]]

        if anim.default > 0.01 then
            renderer.text(start.x - 29 + add_x, start.y + 1, 255, 255, 255, 255 * anim.default * anim.global_alpha, '-', nil, 'EXSCORD')
            renderer.text(start.x + 5 + add_x, start.y + 1, main_color[1], main_color[2], main_color[3], 255 * anim.default * anim.pulse * anim.global_alpha, '-', nil, 'DEBUG')
            renderer.text(start.x + cond_centered, start.y + 9, main_color[1], main_color[2], main_color[3], 255 * anim.default * anim.global_alpha, '-', math.ceil(state_anim), condition:upper())
        end

        if anim.fade > 0.01 then
            local text = 'exscord.lua'
            local text_len = #text + 1
            local light = ''
            local pos = start + vector(add_x, 5)

            add_x = 35 * anim.scope

            local anim_type = menu.prod[ tabs.visuals ]['Anim_Type']:get() == 'Right to Left' and 1 or -1

            for idx = 1, text_len do
                local letter = (idx == text_len) and '°' or text:sub(idx, idx)

                local m_factor = (idx - 1) / text_len
                local m_breathe = breathe(anim_type * m_factor * 1.5, 1.5)

                local r, g, b, a = lerp({ main_color[1], main_color[2], main_color[3], 255 }, { back_color[1], back_color[2], back_color[3], 255 }, m_breathe)
                a = 255 * anim.fade * anim.global_alpha

                local m_hex_color = hex(r, g, b, a)
                light = light .. (m_hex_color .. letter)
            end

            local measure = vector(renderer.measure_text('c', light))
            local offset = 0

            renderer.text(pos.x + 1, pos.y, 255, 255, 255, 255 * anim.fade * anim.global_alpha, 'c', nil, light)
            renderer.text(start.x + cond_centered, start.y + 9, main_color[1], main_color[2], main_color[3], 255 * anim.fade * anim.global_alpha, '-', nil, condition:upper())
            pos = pos + vector(0, measure.y * 0.85)
        end

        for _, element in ipairs(elements) do
            local bind_anim = animations:process(('Default_%s'):format(_), ui.get(element[2]), 6)
            local b_r, b_g, b_b, b_a = bind_color[1], bind_color[2], bind_color[3], 255 * anim.global_alpha * bind_anim
            if bind_anim ~= 0 then
                if element[1] == 'DT' then
                    b_r, b_g, b_b, b_a = dt_r, dt_g, dt_b, 255 * anim.global_alpha * bind_anim
                end

                local size_cur = txt_sizes[ element[ 1 ] ]
                local center_x = (-size_cur.x / 2) * (1 - anim.scope) + (5 * anim.scope)

                --print(size_cur.x)
                renderer.text(start.x + center_x, start.y + 17 + offset, b_r, b_g, b_b, b_a, '-', nil, element[1])
                offset = offset + 8 * bind_anim
            end
        end
    end
end

local ct = screen / 2 - vector(0, 1)

local r, g, b = 0, 0, 0
local r_1, g_1, b_1 = 0, 0, 0

visuals.manual_arrows = function()
    local lp = entity.get_local_player()
    if not lp then
        return
    end
    local valid = lp ~= nil and entity.is_alive(lp)

    local global_alpha = animations:process('Manual Arrows', menu.prod[ tabs.visuals ]['Arrows']:get() and valid)
    if global_alpha <= 0 then
        return
    end

    local main_color = { menu.prod[ tabs.visuals ][ 'MainColor' ]:get() }

    local not_scoped = animations:process('Not Scoped', not (entity.get_prop(lp, 'm_bIsScoped') == 1 and menu.prod[ tabs.visuals ]['HideArrows']:get()), 10)
    local manual_left = animations:process('manual::left', anti_aim.manual_yaw == 1)
    local manual_right = animations:process('manual::right', anti_aim.manual_yaw == 2)

    r = animations:lerp(r, anti_aim.last_body_yaw > 0 and main_color[1] or 35, 0.045)
    g = animations:lerp(g, anti_aim.last_body_yaw > 0 and main_color[2] or 35, 0.045)
    b = animations:lerp(b, anti_aim.last_body_yaw > 0 and main_color[3] or 35, 0.045)

    r_1 = animations:lerp(r_1, anti_aim.last_body_yaw < 0 and main_color[1] or 35, 0.045)
    g_1 = animations:lerp(g_1, anti_aim.last_body_yaw < 0 and main_color[2] or 35, 0.045)
    b_1 = animations:lerp(b_1, anti_aim.last_body_yaw < 0 and main_color[3] or 35, 0.045)

    if global_alpha > 0.01 then
        renderer.triangle(ct.x + 55, ct.y + 2, ct.x + 42, ct.y - 7, ct.x + 42, ct.y + 11, 17, 17, 17, 137 * global_alpha * not_scoped)
        renderer.triangle(ct.x - 55, ct.y + 2, ct.x - 42, ct.y - 7, ct.x - 42, ct.y + 11, 17, 17, 17, 137 * global_alpha * not_scoped)
        renderer.triangle(ct.x + 55, ct.y + 2, ct.x + 42, ct.y - 7, ct.x + 42, ct.y + 11, main_color[1], main_color[2], main_color[3], 255 * not_scoped * global_alpha * manual_right)
        renderer.triangle(ct.x - 55, ct.y + 2, ct.x - 42, ct.y - 7, ct.x - 42, ct.y + 11, main_color[1], main_color[2], main_color[3], 255 * not_scoped * global_alpha * manual_left)

        renderer.rectangle(ct.x + 38, ct.y - 7, 2, 18, 17, 17, 17, 137 * global_alpha * not_scoped)
        renderer.rectangle(ct.x - 40, ct.y - 7, 2, 18, 17, 17, 17, 137 * global_alpha * not_scoped)
        renderer.rectangle(ct.x + 38, ct.y - 7, 2, 18, r, g, b, 255 * global_alpha * not_scoped)
        renderer.rectangle(ct.x - 40, ct.y - 7, 2, 18, r_1, g_1, b_1, 255 * global_alpha * not_scoped)
    end
end


local db_data = database.read('exscord') or { }
local wtr = g_drag.new(db_data.wtr_x or 100, db_data.wtr_y or 100, 130, 25)


local flag

http.get('https://api.myip.com', function(success, response)
    if not success and response.status ~= 200 then
        return print('Failed to parse IP, country flag would be dissapeared.')
    end

    local success, parsed = pcall(json.parse, response.body)

    if not success or not parsed.cc then
        return print('JSON parse error, country flag would be dissapeared.')
    end

    http.get('https://countryflagsapi.com/png/' .. parsed.cc, function(success, response)
        if not success or response.status ~= 200 then
            return
        end

        flag = images.load(response.body)
    end)
end)

visuals.watermarks = function()
    local lp = entity.get_local_player()
    if not lp then
        return
    end
    local valid = lp ~= nil and entity.is_alive(lp)

    local global_alpha = animations:process('WAtermark Alpha', menu.prod[tabs.visuals]['Watermark']:get() and valid)
    if global_alpha <= 0 then
        return
    end

    local main_color = { menu.prod[tabs.visuals]['MainColor']:get() }
    local back_color = { menu.prod[tabs.visuals]['BackgroundColor']:get() }

    local country_wtr = animations:process('countrywtr', menu.prod[tabs.visuals]['Watermark_Type']:get() == 'Country Based')
    local fade_wtr = animations:process('fade_wtr', menu.prod[tabs.visuals]['Watermark_Type']:get() == 'Fade')
    anim.wtr_hovered = animations:lerp(anim.wtr_hovered, (wtr:is_hovered() and client.key_state(1) and ui.is_menu_open()) and 0.5 or 1, 0.045)

    local steam_id = entity.get_steam64(lp)
    local steam_avatar = images.get_steam_avatar(steam_id)

    local wtr_img = menu.prod[tabs.visuals]['Avatar_Type']:get() == 'Steam' and steam_avatar or flag

    local custom_user = menu.prod[tabs.visuals]['CustomInput']:get(true)

    if custom_user:gsub(' ', '') ~= '' then
        custom_usr_str = custom_user
    else
        custom_usr_str = username
    end

    custom_usr_str = clamp_str(custom_usr_str, 15)

    if country_wtr > 0.01 then
        local additional_off = wtr_img ~= nil and 25 or 0
        local cringe = vector(renderer.measure_text(nil, 'user: ')).x - 3
        renderer.text(wtr.x + additional_off, wtr.y, 255, 255, 255, 255 * country_wtr * global_alpha * anim.wtr_hovered, nil, nil, 'exscord.technologies')
        renderer.text(wtr.x + additional_off, wtr.y + 10, 255, 255, 255, 255 * country_wtr * global_alpha * anim.wtr_hovered, nil, nil, 'user: ' .. custom_usr_str)
        renderer.text(wtr.x + additional_off + vector(renderer.measure_text(nil, custom_usr_str)).x + 5 + cringe, wtr.y + 10, main_color[1], main_color[2], main_color[3], 255 * country_wtr * global_alpha * anim.wtr_hovered, nil, nil, '[' .. version .. ']')

        if wtr_img ~= nil then
            wtr_img:draw(wtr.x, wtr.y + 3, 23, 19, 255, 255, 255, 255 * country_wtr * global_alpha * anim.wtr_hovered)
        end
    end

    if fade_wtr > 0.01 then
        local m_text = 'exscord.technologies ~ ' .. custom_usr_str
        local m_length = #m_text + 1
        local m_pos = vector(wtr.x, wtr.y)
        local m_light = ''

        local anim_type = menu.prod[ tabs.visuals ]['Anim_Type']:get() == 'Right to Left' and 1 or -1

        for idx = 1, m_length do
            local m_letter = m_text:sub(idx, idx)

            local m_factor = (idx - 1) / m_length
            local m_breathe = breathe(anim_type * m_factor * 1.5, 1.5)

            local r, g, b, a = lerp({ main_color[1], main_color[2], main_color[3], 255 }, { back_color[1], back_color[2], back_color[3], 255 }, m_breathe)
            a = 255 * fade_wtr * global_alpha * anim.wtr_hovered

            local m_hex_color = hex(r, g, b, a)
            m_light = m_light .. (m_hex_color .. m_letter)
        end

        local m_text_measure = vector(renderer.measure_text(nil, m_light))
        renderer.text(m_pos.x + 1, m_pos.y, -1, -1, -1, 255 * global_alpha * fade_wtr * anim.wtr_hovered, nil, nil, m_light)
        m_pos = m_pos + vector(0, m_text_measure.y * 0.85)
    end

    db_data.wtr_x = wtr.x
    db_data.wtr_y = wtr.y

    database.write('exscord', db_data)
end


local char_ptr = ffi.typeof('char*')
local nullptr = ffi.new('void*')
local class_ptr = ffi.typeof('void***')

do
    local animation_layer_t = ffi.typeof([[
        struct {										char pad0[0x18];
            uint32_t	sequence;
            float		prev_cycle;
            float		weight;
            float		weight_delta_rate;
            float		playback_rate;
            float		cycle;
            void		*entity;						char pad1[0x4];
        } **
    ]])


    local this = menu.prod[ tabs.misc ]['AnimationBreakers']
    local leg_type = menu.prod[ tabs.misc ]['LegsType']
    local airlegs_type = menu.prod[ tabs.misc ]['AirLegsType']

    misc.leg_breaker = function()
        if not table.find(menu.prod[tabs.misc]['Functions']:get(), enum.misc.functions[1]) then
            return
        end

        local lp = entity.get_local_player()

        if not lp then
            return
        end

        local pEnt = ffi.cast(class_ptr, native_GetClientEntity(lp))
        if pEnt == nullptr then
            return
        end

        local anim_layers = ffi.cast(animation_layer_t, ffi.cast(char_ptr, pEnt) + 0x2990)[0][6]

        if table.find(this:get(), 'Leg Breaker') then
            if leg_type:get() == 'Static' then
                menu.override(reference.AA.other.leg_movement, 'Always slide')
                entity.set_prop(lp, 'm_flPoseParameter', 1, 0)
            elseif leg_type:get() == 'Walking' then
                entity.set_prop(lp, 'm_flPoseParameter', 0.5, 7)
                menu.override(reference.AA.other.leg_movement, 'Never slide')
            end
        end

        if table.find(this:get(), 'Air Legs') and not anti_aim.on_ground() then
            if airlegs_type:get() == 'Static' then
                entity.set_prop(lp, 'm_flPoseParameter', 1, 6)
            elseif airlegs_type:get() == 'Walking' then
                anim_layers.weight = 1
            end
        end

        if table.find(this:get(), 'Zero Pitch on Land') and ground_ticks > 5 and ground_ticks < 60 then
            entity.set_prop(lp, 'm_flPoseParameter', 0.5, 12)
        end
    end
end

misc.build_tag = function(str)
    local tag = { ' ', ' ', ' ' }
    local prev_tag = ''

    for i = 1, #str do
        local char = str:sub(i, i)
        prev_tag = prev_tag:lower() .. char:upper()
        tag[i] = prev_tag
    end

    tag[#tag + 1] = str

    for i = #tag, 1, -1 do
        table.insert(tag, tag[i])
    end

    tag[#tag + 1] = ' '
    tag[#tag + 1] = ' '
    tag[#tag + 1] = ' '

    return tag
end

local once, old_time = false, 0

misc.clan_tag = function()
    local tag = misc.build_tag("exscord")
    if table.find(menu.prod[ tabs.misc ]['Functions']:get(), enum.misc.functions[ 2 ]) then
        once = false
        local curtime = math.floor(globals.curtime() * 4.5)
        if old_time ~= curtime then
            client.set_clan_tag(tag[curtime % #tag + 1])
        end
        old_time = curtime
        menu.override(reference.MISC.clantag, false)
    else
        if old_time ~= curtime and not once then
            client.set_clan_tag('')
            once = true
        end
    end
end

callback.new('clantag::shutdown', 'shutdown', function ()
    client.set_clan_tag('')
end)

menu.visibility = function ()
    menu.set_visible(reference.AA.angles, false)
end

menu.visibility_shutdown = function ()
    menu.set_visible(reference.AA.angles, true)
end

menu.prevent_mouse = function (cmd)
    if ui.is_menu_open() then
        cmd.in_attack = false
    end
end

menu.handle_colorushka = function ()
    if not ui.is_menu_open() then
        return
    end

    local text = 'exscord Renewed'
    local length = #text + 1
    local light = ''

    local main_color = { menu.prod[ tabs.visuals ]['MainColor']:get() }
    local back_color = { menu.prod[ tabs.visuals ]['BackgroundColor']:get() }
    local anim_type = menu.prod[ tabs.visuals ]['Anim_Type']:get() == 'Right to Left' and 1 or -1

    for idx = 1, length do
        local letter = text:sub(idx, idx)

        local factor = (idx - 1) / length
        local breathe = breathe(anim_type * factor * 1.5, 1.5)

        local r, g, b, a = lerp({ main_color[1], main_color[2], main_color[3], 255 }, { back_color[1], back_color[2], back_color[3], 255 }, breathe)

        local hex_color = hex(r, g, b, a)
        light = light .. (hex_color .. letter)
    end

    ui.set(colored_label, light)
end


callback.new('antiaim::condition', 'setup_command', anti_aim.condition)
callback.new('antiaim::handle_manual', 'paint', anti_aim.handle_manuals)
callback.new('antiaim::handle_defensive', 'net_update_end', anti_aim.handle_defensive)
callback.new('antiaim::anti_backstab', 'setup_command', anti_aim.anti_backstab)
callback.new('antiaim::handle_builder', 'setup_command', anti_aim.builder)
callback.new('antiaim::main', 'setup_command', anti_aim.main)
callback.new('antiaim::air_defensive', 'setup_command', anti_aim.air_defensive)
callback.new('antiaim::player_death', 'player_death', anti_aim.on_death)

callback.new('visuals::handle_draggables', 'paint_ui', g_drag.paint_ui)

callback.new('visuals::indicators', 'paint', visuals.inidcators)
callback.new('visuals::watermarks', 'paint', visuals.watermarks)
callback.new('visuals::arrows', 'paint', visuals.manual_arrows)


callback.new('menu::visibility', 'paint_ui', menu.visibility)
callback.new('menu::restore', 'pre_config_save', menu.shutdown)
callback.new('menu::shutdown_vis', 'shutdown', menu.visibility_shutdown)
callback.new('menu::color_label', 'paint_ui', menu.handle_colorushka)

callback.new('visuals::prevent_mouse', 'setup_command', menu.prevent_mouse)
callback.new('clantag::run', 'paint', misc.clan_tag)
callback.new('legbreaker::pre_render', 'pre_render', misc.leg_breaker)


callback.new('configs::shutdown', 'shutdown', configs.shutdown)
configs.load_startup()