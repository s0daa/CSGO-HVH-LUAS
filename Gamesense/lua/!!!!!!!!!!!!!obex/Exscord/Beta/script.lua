-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local ffi = require 'ffi'
local vector = require 'vector'

local base64 = (function ()
    local shl, shr, band = bit.lshift, bit.rshift, bit.band
    local char, byte, gsub, sub, format, concat, tostring, error, pairs = string.char, string.byte, string.gsub, string.sub, string.format, table.concat, tostring, error, pairs

    local extract = function(v, from, width)
    	return band(shr(v, from), shl(1, width) - 1)
    end

    local function makeencoder(alphabet)
    	local encoder, decoder = {}, {}
    	for i=1, 65 do
    		local chr = byte(sub(alphabet, i, i)) or 32 -- or ' '
    		if decoder[chr] ~= nil then
    			error('invalid alphabet: duplicate character ' .. tostring(chr), 3)
    		end
    		encoder[i-1] = chr
    		decoder[chr] = i-1
    	end
    	return encoder, decoder
    end

    local encoders, decoders = {}, {}

    encoders['base64'], decoders['base64'] = makeencoder('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=')
    encoders['base64url'], decoders['base64url'] = makeencoder('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_')

    local alphabet_mt = {
    	__index = function(tbl, key)
    		if type(key) == 'string' and key:len() == 64 or key:len() == 65 then
    			-- if key is a valid looking base64 alphabet, try to make an encoder/decoder pair from it
    			encoders[key], decoders[key] = makeencoder(key)
    			return tbl[key]
    		end
    	end
    }

    setmetatable(encoders, alphabet_mt)
    setmetatable(decoders, alphabet_mt)

    local function encode(str, encoder)
    	encoder = encoders[encoder or 'base64'] or error('invalid alphabet specified', 2)

    	str = tostring(str)

    	local t, k, n = {}, 1, #str
    	local lastn = n % 3
    	local cache = {}

    	for i = 1, n-lastn, 3 do
    		local a, b, c = byte(str, i, i+2)
    		local v = a*0x10000 + b*0x100 + c
    		local s = cache[v]

    		if not s then
    			s = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
    			cache[v] = s
    		end

    		t[k] = s
    		k = k + 1
    	end

    	if lastn == 2 then
    		local a, b = byte(str, n-1, n)
    		local v = a*0x10000 + b*0x100
    		t[k] = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[64])
    	elseif lastn == 1 then
    		local v = byte(str, n)*0x10000
    		t[k] = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[64], encoder[64])
    	end

    	return concat(t)
    end

    local function decode(b64, decoder)
    	decoder = decoders[decoder or 'base64'] or error('invalid alphabet specified', 2)

    	local pattern = '[^%w%+%/%=]'
    	if decoder then
    		local s62, s63
    		for charcode, b64code in pairs(decoder) do
    			if b64code == 62 then s62 = charcode
    			elseif b64code == 63 then s63 = charcode
    			end
    		end
    		pattern = format('[^%%w%%%s%%%s%%=]', char(s62), char(s63))
    	end

    	b64 = gsub(tostring(b64), pattern, '')

    	local cache = {}
    	local t, k = {}, 1
    	local n = #b64
    	local padding = sub(b64, -2) == '==' and 2 or sub(b64, -1) == '=' and 1 or 0

    	for i = 1, padding > 0 and n-4 or n, 4 do
    		local a, b, c, d = byte(b64, i, i+3)

    		local v0 = a*0x1000000 + b*0x10000 + c*0x100 + d
    		local s = cache[v0]
    		if not s then
    			local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40 + decoder[d]
    			s = char(extract(v,16,8), extract(v,8,8), extract(v,0,8))
    			cache[v0] = s
    		end

    		t[k] = s
    		k = k + 1
    	end

    	if padding == 1 then
    		local a, b, c = byte(b64, n-3, n-1)
    		local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40
    		t[k] = char(extract(v,16,8), extract(v,8,8))
    	elseif padding == 2 then
    		local a, b = byte(b64, n-3, n-2)
    		local v = decoder[a]*0x40000 + decoder[b]*0x1000
    		t[k] = char(extract(v,16,8))
    	end
    	return concat(t)
    end

    return {
    	encode = encode,
    	decode = decode
    }
end)()

local vers = {
    ['Beta'] = 'Nightly',
    ['User'] = 'Stable'
}

local user_data = obex_fetch and obex_fetch() or {
    username = 'admin',
    build = 'Source'
}

user_data.build = vers[ user_data.build ] or user_data.build

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

local f = string.format
local typeof = type

local message = function(r, g, b, ...)
    client.color_log(164, 193, 255, 'exscord\0')
    client.color_log(150, 150, 150, ' ~ \0')
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
            'Force Defensive',
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
            pitch = { ui.reference('AA', 'Anti-aimbot angles', 'Pitch') },
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

            result = f('%s, debug info: key = %s, event_name = %s', result, key, event_name)

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
        user = user_data.username or 'unknown',
        date = '12.12.2012',
        build = user_data.build,
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

configs.data_slot = database.read('exscord')
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

    database.write('exscord', encoded)
end

local math_clamp = function (x, min, max)
    return math.max(min, math.min(x, max))
end

local colored_label = ui.new_label('AA', 'Anti-aimbot angles', f('exscord %s [%s]', user_data.build, user_data.username))

do
    menu.new('exscord', 'Groups', ui.new_combobox, { 'AA', 'Anti-Aimbot angles', 'Tab Selection', unpack(enum.tab) })
    menu.prod['exscord']['Groups']:add_as_parent(function(self)
        return self.m_group == menu.prod['exscord']['Groups']:get()
    end)
end

do
    menu.new(tabs.antiaim, 'Controller', ui.new_checkbox, { 'AA', 'Anti-aimbot angles', 'Enable Anti Aim' })
    menu.prod[ tabs.antiaim ]['Controller']:add_as_parent(function(self)
        if self.m_group ~= tabs.antiaim then
            return true
        end
        return menu.prod[ tabs.antiaim ]['Controller']:get()
    end)
end

menu.new(tabs.antiaim, 'AAController', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Sub Group', { 'Main', 'Angles' }})

menu.new(tabs.antiaim, 'Functions', ui.new_multiselect, { 'AA', 'Anti-aimbot angles', '• Anti Aim Features', unpack(enum.anti_aimbot.functions) }, {
    callback = function ()
        return menu.prod[ tabs.antiaim ]['AAController']:get() == 'Main'
    end
}) do
    menu.new(tabs.antiaim, 'LeftManual', ui.new_hotkey, { 'AA', 'Anti-aimbot angles', ' »  Manual Left' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Manual anti-aim')
            and menu.prod[ tabs.antiaim ]['AAController']:get() == 'Main'
        end
    })

    menu.new(tabs.antiaim, 'RightManual', ui.new_hotkey, { 'AA', 'Anti-aimbot angles', ' »  Manual Right' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Manual anti-aim')
            and menu.prod[ tabs.antiaim ]['AAController']:get() == 'Main'
        end
    })

    menu.new(tabs.antiaim, 'ForwardManual', ui.new_hotkey, { 'AA', 'Anti-aimbot angles', ' »  Manual Forward' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Manual anti-aim')
            and menu.prod[ tabs.antiaim ]['AAController']:get() == 'Main'
        end
    })

    menu.new(tabs.antiaim, 'ResetManual', ui.new_hotkey, { 'AA', 'Anti-aimbot angles', ' »  Manual Reset' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Manual anti-aim')
            and menu.prod[ tabs.antiaim ]['AAController']:get() == 'Main'
        end
    })

    menu.new(tabs.antiaim, 'StaticManuals', ui.new_checkbox, { 'AA', 'Anti-aimbot angles', '• Use Static On Manual' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Manual anti-aim')
            and menu.prod[ tabs.antiaim ]['AAController']:get() == 'Main'
        end
    })

    menu.new(tabs.antiaim, 'Freestanding', ui.new_hotkey, { 'AA', 'Anti-aimbot angles', ' »  Freestanding' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Freestanding')
            and menu.prod[ tabs.antiaim ]['AAController']:get() == 'Main'
        end
    })

    menu.new(tabs.antiaim, 'EdgeYaw', ui.new_hotkey, { 'AA', 'Anti-aimbot angles', ' »  Edge Yaw' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Edge yaw')
            and menu.prod[ tabs.antiaim ]['AAController']:get() == 'Main'
        end
    })

    menu.new(tabs.antiaim, 'DefensiveConditions', ui.new_multiselect, { 'AA', 'Anti-aimbot angles', '• Force Defensive On', { 'Stand', 'Move', 'Slow-motion', 'Air', 'Air + Crouch', 'Crouch' } }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Force Defensive')
            and menu.prod[ tabs.antiaim ]['AAController']:get() == 'Main'
        end
    })

    menu.new(tabs.antiaim, 'DefensivePitch', ui.new_combobox, { 'AA', 'Anti-aimbot angles', '• Defensive Pitch', { 'Off', 'Down', 'Up', 'Up-Switch', 'Down-Switch', 'Zero' } }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Defensive Anti-aim')
            and menu.prod[ tabs.antiaim ]['AAController']:get() == 'Main'
        end
    })

    menu.new(tabs.antiaim, 'DefensiveYaw', ui.new_combobox, { 'AA', 'Anti-aimbot angles', '• Defensive Yaw', { 'Off', '180', 'Spin', 'Sideways', 'Random' } }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Defensive Anti-aim')
            and menu.prod[ tabs.antiaim ]['AAController']:get() == 'Main'
        end
    })

    menu.new(tabs.antiaim, 'DefensiveYawAmount', ui.new_slider, { 'AA', 'Anti-aimbot angles', '\n Defensive Yaw', -180, 180, 0, true, '°' }, {
        callback = function()
            return table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Defensive Anti-aim')
            and menu.prod[ tabs.antiaim ]['AAController']:get() == 'Main'
            and menu.prod[ tabs.antiaim ]['DefensiveYaw']:get() == '180'
        end
    })
end

menu.new(tabs.antiaim, 'Type', ui.new_combobox, { 'AA', 'Anti-aimbot angles', '• Anti-Aim Type', { 'Preset', 'Anti-Aim Builder' } }, {
    callback = function ()
        return menu.prod[ tabs.antiaim ]['AAController']:get() == 'Angles'
    end
})

menu.new(tabs.antiaim, 'PlayerCondition', ui.new_combobox, { 'AA', 'Anti-aimbot angles', 'Player Condition', unpack(enum.anti_aimbot.states) }, {
    config = false,
    callback = function()
        return menu.prod[ tabs.antiaim ]['Type']:get() == 'Anti-Aim Builder'
        and menu.prod[ tabs.antiaim ]['AAController']:get() == 'Angles'
    end
})

do
    local spacing = ''

    for key, value in ipairs(enum.anti_aimbot.states) do
        local is_visible = function ()
            return menu.prod[ tabs.antiaim ]['Type']:get() == 'Anti-Aim Builder'
            and menu.prod[ tabs.antiaim ]['PlayerCondition']:get() == value
            and menu.prod[ tabs.antiaim ]['AAController']:get() == 'Angles'
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
                and menu.prod[ tabs.antiaim ]['AAController']:get() == 'Angles'
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


menu.new(tabs.visuals, 'Indicators', ui.new_checkbox, { 'AA', 'Anti-aimbot angles', 'Crosshair Indicators' })
menu.new(tabs.visuals, 'DamageIndicator', ui.new_checkbox, {'AA', 'Anti-aimbot angles', 'Damage Indicator'})
menu.new(tabs.visuals, 'Arrows', ui.new_checkbox, { 'AA', 'Anti-aimbot angles', 'Manual Arrows' })
menu.new(tabs.visuals, 'Watermark', ui.new_checkbox, { 'AA', 'Anti-aimbot angles', 'Watermark'})

do
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

menu.new(tabs.misc, 'DefaultConfig', ui.new_button, { 'AA', 'Anti-aimbot angles', 'Default Config', function() end })
menu.new(tabs.misc, 'ExportConfig', ui.new_button, { 'AA', 'Anti-aimbot angles', 'Export to clipboard', function() end })
menu.new(tabs.misc, 'ImportConfig', ui.new_button, { 'AA', 'Anti-aimbot angles', 'Import from clipboard', function() end })


menu.prod[ tabs.misc ]['DefaultConfig']:register_callback(function ()
    local decoded = configs.import('exscord::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')
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
    is_legit = false,

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
        anti_aim.defensive = globals.tickcount() + toticks(delta - client.latency())
        return
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

        if anti_aim.is_legit then
        return enum.anti_aimbot.states[8]
    end

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

local way_3 = { -1, 0, 1 }
local way_5 = { -1, -0.5, 0, 0.5, 1 }

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

    menu.override(reference.AA.angles.pitch[1], preset.pitch or enum.ui.pitch[4])
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


    menu.override(reference.AA.angles.pitch[1], menu.prod[ tabs.antiaim ][ condition .. '::pitch' ]:get())
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

do
    local ents = { 'CHostage', 'CPlantedC4' }
    local tick = -1

    local function scan_entities(my_origin, ents)
        for idx, ent in next, ents do
            local position = vector(entity.get_origin(ent))

            if my_origin:dist(position) < 128 then
                return true
            end
        end

        return false
    end

    anti_aim.using = function(cmd)
        anti_aim.is_legit = false
        if not menu.prod[ tabs.antiaim ]['Controller']:get() or
            not table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Allow anti-aim on use') then
            return
        end

        local lp = entity.get_local_player()
        if lp == nil then
            return
        end

        if cmd.in_use == 0 then
            tick = -1
            return
        end

        local weapon = entity.get_player_weapon(lp)
        if weapon == nil then
            return
        end

        if entity.get_classname(weapon) == 'CC4' then
            return
        end

        local my_origin = vector(entity.get_origin(lp))
        if my_origin == nil then
            return
        end

        for i = 1, #ents do
            if scan_entities(my_origin, entity.get_all(ents[ i ])) then
                return
            end
        end

        if tick == -1 then
            tick = globals.tickcount() + 1
        end

        cmd.in_use = tick > globals.tickcount() and 1 or 0

        if not menu.prod[ tabs.antiaim ]['Type']:get() == 'Anti-Aim Builder' then
            menu.override(reference.AA.angles.pitch[1], enum.ui.pitch[1])
            menu.override(reference.AA.angles.yaw_base, enum.ui.yaw_base[1])
            menu.override(reference.AA.angles.yaw[1], enum.ui.yaw[2])
            menu.override(reference.AA.angles.yaw[2], 180)
        end

        anti_aim.is_legit = true

        return true
    end
end

anti_aim.defensive_antiaim = function(cmd)
    if not menu.prod[ tabs.antiaim ]['Controller']:get() or not table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Defensive Anti-aim') then
        return
    end

    if globals.tickcount() > anti_aim.defensive then
        return
    end

    local pitch = menu.prod[ tabs.antiaim ]['DefensivePitch']:get();
    local pitch_val = cmd.pitch

    if pitch == 'Up-Switch' then
        pitch = 'Custom'
        pitch_val = client.random_float(-45, -65)
    elseif pitch == 'Down-Switch' then
        pitch = 'Custom'
        pitch_val = client.random_float(45, 65)
    elseif pitch == 'Zero' then
        pitch = 'Custom'
        pitch_val = 0
    end

    local yaw = menu.prod[ tabs.antiaim ]['DefensiveYaw']:get();
    local yaw_val = menu.prod[ tabs.antiaim ]['DefensiveYawAmount']:get();

    if yaw == 'Sideways' then
        yaw = '180'
        yaw_val = anti_aim.last_body_yaw > 0 and -90 or 90
    elseif yaw == 'Random' then
        yaw = '180'
        yaw_val = client.random_float(-180, 180)
    elseif yaw == 'Spin' then
        yaw = '180'
        yaw_val = -180 + (globals.tickcount() % 9) * 40 + client.random_float(-30, 30)
    end

    if pitch ~= 'Off' then
        menu.override(reference.AA.angles.pitch[1], pitch)
        menu.override(reference.AA.angles.pitch[2], pitch_val)
    end

    if yaw ~= 'Off' then
        menu.override(reference.AA.angles.yaw[1], yaw)
        menu.override(reference.AA.angles.yaw[2], normalize(yaw_val, -180, 180))
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
            anti_aim.defensive_antiaim(cmd)
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

anti_aim.force_defensive = function (cmd)
    if not menu.prod[ tabs.antiaim ]['Controller']:get() then
        return
    end

    local aa_condition = callback.get('antiaim::condition', true)
    if not aa_condition then
        return
    end

    local enabled = table.find(menu.prod[ tabs.antiaim ]['Functions']:get(), 'Force Defensive')
    if not enabled then
        return
    end

    local check_passed = false
    for _, condition in next, menu.prod[ tabs.antiaim ]['DefensiveConditions']:get() do
        if aa_condition == condition then
            check_passed = true
            break
        end
    end

    if not check_passed then
        return
    end

    cmd.force_defensive = 1
end


do -- crosshair indicators

    local elements = {
        {
            text = 'DT',

            condition = function ()
                return ui.get(reference.RAGE.aimbot.double_tap[2])
            end,

            color = function ()
                local r, g, b = lerp({ 255, 25, 25, 255 }, { 255, 255, 255, 255 }, animations:process('Double Tap', anti_aim.dt_charge()))
                return { r, g, b, 255 }
            end
        },

        {
            text = 'OS',

            condition = function ()
                return ui.get(reference.AA.other.on_shot_antiaim[2])
            end
        },

        {
            text = 'FS',

            condition = function ()
                return ui.get(menu.prod[ tabs.antiaim ]['Freestanding'].m_reference)
            end
        },

        {
            text = 'BAIM',

            condition = function ()
                return ui.get(reference.RAGE.aimbot.force_body_aim)
            end
        },

        {
            text = 'SAFE',

            condition = function ()
                return ui.get(reference.RAGE.aimbot.force_safe_point)
            end
        },

        {
            text = 'DUCK',

            condition = function ()
                return ui.get(reference.RAGE.other.duck_peek_assist)
            end
        },

        {
            text = 'DMG',

            condition = function ()
                return ui.get(reference.RAGE.aimbot.min_damage_override[1]) and ui.get(reference.RAGE.aimbot.min_damage_override[2])
            end
        }
    }

    visuals.inidcators = function()
        local lp = entity.get_local_player()
        local global_alpha = animations:process('Global', menu.prod[tabs.visuals]['Indicators']:get() and lp ~= nil and entity.is_alive(lp))
        if global_alpha < 0.01 or valid then
            return
        end

        local pulsation = math.max(0.2, math.abs(math.sin(globals.realtime() * 2.5)))
        local align = animations:process('Scope', not (lp and entity.get_prop(lp, 'm_bIsScoped') == 1 or false), 10)

        local clr = { menu.prod[ tabs.visuals ][ 'MainColor' ]:get() }
        local state = callback.get('antiaim::condition', true)
        if not state then
            state = 'unknown'
        end

        local offset = 0

        local area = screen:clone() do
            area.x = area.x * .5 + (1 - align)
            area.y = area.y * .5 + 20
        end

        local heading = 'EXSCORD' do
            heading = string.format('%s %s%s', heading, hex(clr[1], clr[2], clr[3], 255 * pulsation * global_alpha), user_data.build:upper())
            local heading_size = vector(renderer.measure_text('-', heading))

            local new_area = area:clone() do
                new_area.x = new_area.x - heading_size.x * .5 * align
            end

            renderer.text(new_area.x, new_area.y, 255, 255, 255, 255 * global_alpha, '-', 0, heading)
            area.y = area.y + heading_size.y - 2
        end

        local condition = string.upper(state) do
            local condition_size = vector(renderer.measure_text('-', condition))

            local new_area = area:clone() do
                new_area.x = new_area.x - condition_size.x * .5 * align
            end

            renderer.text(new_area.x, new_area.y, clr[1], clr[2], clr[3], 255 * global_alpha, '-', 0, condition)
            area.y = area.y + condition_size.y - 2
        end

        for _, indicator in next, elements do
            local text = indicator.text
            local animation = animations:process(text, indicator.condition(), 6)
            if animation <= 0 then
                goto skip
            end

            local bind_clr = indicator.color and indicator.color() or { 255, 255, 255, 255 }
            local bind_size = vector(renderer.measure_text('-', text))

            local new_area = area:clone() do
                new_area.x = new_area.x - bind_size.x * .5 * align
                new_area.y = new_area.y + offset
            end

            renderer.text(new_area.x, new_area.y, bind_clr[1], bind_clr[2], bind_clr[3], 255 * animation * global_alpha, '-', 0, text)

            offset = offset + 8 * animation
            ::skip::
        end
    end
end

do

    local function get_minimum_damage()
        if ui.get(reference.RAGE.aimbot.min_damage_override[1]) and ui.get(reference.RAGE.aimbot.min_damage_override[2]) then
            return ui.get(reference.RAGE.aimbot.min_damage_override[3])
        end

        return ui.get(reference.RAGE.aimbot.min_damage)
    end

    local damage_anim = 0
    local start = screen / 2 + vector(0, 15)
    local dmg_drag = g_drag.new(start.x + 10, start.y - 40, 28, 16)

    visuals.damage_indicator = function ()
        local lp = entity.get_local_player()
        local global_alpha = animations:process('Damage Indicator', menu.prod[tabs.visuals]['DamageIndicator']:get() and lp ~= nil and entity.is_alive(lp))
        if global_alpha < 0.01 then
            return
        end

        local clr = { menu.prod[ tabs.visuals ][ 'MainColor' ]:get() }
        local damage = get_minimum_damage()

        damage_anim = animations:lerp(damage_anim, damage, 0.045)
        local dmg_string = damage == 0 and "AUTO" or tostring(int(damage_anim))

        renderer.text(dmg_drag.x, dmg_drag.y, 255, 255, 255, clr[4] * global_alpha, 'c-', nil, dmg_string)
    end
end

do
    visuals.arrows = function ()
        local lp = entity.get_local_player()
        local global_alpha = animations:process('Arrows', menu.prod[tabs.visuals]['Arrows']:get() and lp ~= nil and entity.is_alive(lp))
        if global_alpha < 0.01 then
            return
        end

        local blind_alpha = animations:process('Arrows Blind', lp and entity.get_prop(lp, 'm_bIsScoped') or false)
        if blind_alpha <= 0 then
            return
        end

        local clr = { menu.prod[ tabs.visuals ][ 'MainColor' ]:get() }

        local r1, g1, b1, a1 = lerp({ 200, 200, 200, 60 }, { clr[1], clr[2], clr[3], 255 }, animations:process('Left Manual', anti_aim.manual_yaw == 1, 8))
        local r2, g2, b2, a2 = lerp({ 200, 200, 200, 60 }, { clr[1], clr[2], clr[3], 255 }, animations:process('Right Manual', anti_aim.manual_yaw == 2, 8))

        renderer.text(screen.x / 2 - 50, screen.y / 2 - 6, r1, g1, b1, a1 * global_alpha * blind_alpha, nil, 0, '❰')
        renderer.text(screen.x / 2 + 50, screen.y / 2 - 6, r2, g2, b2, a2 * global_alpha * blind_alpha, nil, 0, '❱')
    end
end

do

    string.wave = function (str, clr1, clr2, speed)
        local i = 0
        local n = 1 / (#str:gsub('[\128-\191]', '') - 1)

        local out = str:gsub('(.[\128-\191]*)', function(char)
            local factor = breathe(i, speed)
            local r, g, b, a = lerp({ clr1[1], clr1[2], clr1[3], 255 }, { clr2[1], clr2[2], clr2[3], 255 }, factor)

            i = i + n
            return string.format('%s%s', hex(r, g, b, a), char)
        end)

        return out
    end

    visuals.watermark = function ()
        local lp = entity.get_local_player()
        local global_alpha = animations:process('Watermark', menu.prod[tabs.visuals]['Watermark']:get() and lp ~= nil and entity.is_alive(lp))
        if global_alpha < 0.01 then
            return
        end

        local clr = { menu.prod[ tabs.visuals ][ 'MainColor' ]:get() }

        local str = string.wave(f('exscord %s', user_data.build), clr, { 255, 255, 255, 255 }, 2.5)

        renderer.text(screen.x / 2, screen.y - 10, 255, 255, 255, 255 * global_alpha, 'c', 0, str)
    end
end


do -- anim breakers
    local char_ptr = ffi.typeof('char*')
    local nullptr = ffi.new('void*')
    local class_ptr = ffi.typeof('void***')

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

    local text = f('exscord ~ %s', user_data.username)
    local length = #text + 1
    local light = ''

    local main_color = { ui.get(reference.MISC.color) }

    for idx = 1, length do
        local letter = text:sub(idx, idx)

        local factor = (idx - 1) / length
        local breathe = breathe(factor * 1.5, 2)

        local r, g, b, a = lerp({ main_color[1], main_color[2], main_color[3], 255 }, { 255, 255, 255, 200 }, breathe)

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
callback.new('antiaim::defensive', 'setup_command', anti_aim.force_defensive)
callback.new('antiaim::player_death', 'player_death', anti_aim.on_death)

callback.new('visuals::handle_draggables', 'paint_ui', g_drag.paint_ui)

callback.new('visuals::indicators', 'paint', visuals.inidcators)
callback.new('visuals::arrows', 'paint', visuals.arrows)
callback.new('visuals::watermark', 'paint', visuals.watermark)
callback.new('visuals::damageind', 'paint', visuals.damage_indicator)


callback.new('menu::visibility', 'paint_ui', menu.visibility)
callback.new('menu::restore', 'pre_config_save', menu.shutdown)
callback.new('menu::shutdown_vis', 'shutdown', menu.visibility_shutdown)
callback.new('menu::color_label', 'paint_ui', menu.handle_colorushka)

callback.new('visuals::prevent_mouse', 'setup_command', menu.prevent_mouse)
callback.new('clantag::run', 'paint', misc.clan_tag)
callback.new('legbreaker::pre_render', 'pre_render', misc.leg_breaker)


callback.new('configs::shutdown', 'shutdown', configs.shutdown)
configs.load_startup()