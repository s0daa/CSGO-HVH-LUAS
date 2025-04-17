LPH_JIT = function(...) return ... end
LPH_JIT_MAX = function(...) return ... end
LPH_NO_VIRTUALIZE = function(...) return ... end

local function Mcopy(o)
    if type(o) ~= 'table' then return o end
    local res = {} for k, v in pairs(o) do res[Mcopy(k)] = Mcopy(v) end return res
end

local tonumber, tostring, pairs, ipairs, next, unpack, select, type = tonumber, tostring, pairs, ipairs, next, unpack, select, type
local math, table, string, bit = Mcopy(math), Mcopy(table), Mcopy(string), Mcopy(bit)
local toticks, totime = toticks, totime
local ui, client, entity, globals, renderer = Mcopy(ui), Mcopy(client), Mcopy(entity), Mcopy(globals), Mcopy(renderer)

do
    local librarys = {
        { req_name = 'gamesense/easing', link = 'https://gamesense.pub/forums/viewtopic.php?id=22920' },
        { req_name = 'gamesense/images', link = 'https://gamesense.pub/forums/viewtopic.php?id=22917' },
        { req_name = 'gamesense/antiaim_funcs', link = 'https://gamesense.pub/forums/viewtopic.php?id=29665' },
        { req_name = 'gamesense/http', link = 'https://gamesense.pub/forums/viewtopic.php?id=19253' },
        { req_name = 'gamesense/clipboard', link = 'https://gamesense.pub/forums/viewtopic.php?id=28678' },
        -- { req_name = 'gamesense/surface', link = 'https://gamesense.pub/forums/viewtopic.php?id=18793' },
        { req_name = 'gamesense/csgo_weapons', link = 'https://gamesense.pub/forums/viewtopic.php?id=18807' },
        { req_name = 'gamesense/trace', link = 'https://gamesense.pub/forums/viewtopic.php?id=32949' },
        { req_name = 'gamesense/lzw', link = 'https://gamesense.pub/forums/viewtopic.php?id=41221' }
    }

    local missing = false

    for i, key in pairs(librarys) do
        local status, error = pcall(require, key.req_name)

        if not status then
            print('Missing library: ', key.req_name, ', make sure you are subscribed to it [link: ', key.link, ']')

            missing = true
        end
    end

    if missing then
        error('Missing librarys', 2)
    end
end

local ffi = require('ffi')
local vector = require('vector')
local easing = require('gamesense/easing')
local images = require('gamesense/images')
local anti_aim_f = require('gamesense/antiaim_funcs')
local http = require('gamesense/http')
local clipboard = require('gamesense/clipboard')
-- local surface = require('gamesense/surface')
local csgo_weapons = require('gamesense/csgo_weapons')
local trace_lib = require('gamesense/trace')
local string_compression = require('gamesense/lzw')

local new_class do (function()
    local M = {
        __index = {}
    }

    function M.__index:struct(name)
        return function(arr)
            setmetatable(arr, {__index = self})
            self[name] = arr
            return self
        end
    end

    function new_class()
        local o = {}
        setmetatable(o, M)
        return o
    end
end)() end

function math.clamp(value, min, max)
    return math.min(max, math.max(min, value))
end

function table.contains(tab, value)
    if tab == nil then
        return false
    end

    if type(tab) == 'number' then
        tab = ui.get(tab)
    end

    if type(tab) ~= 'table' then
        return false
    end

    for i = 0, #tab do
        if tab[i] == value then
            return true, i
        end
    end

    return false
end

function table.size(tab)
    if type(tab) ~= 'table' then
        return error('Argument #1 not a table', 2)
    end

    local sum = 0

    for k, v in pairs(tab) do
        sum = sum + 1
    end

    return sum
end

local experimental_data = function()
    return json.parse([[{
        "terrorist": {
            "stand": {
                "yaw": 8,
                "yaw_jitter": "Center",
                "yaw_jitter_value": 62,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            },
            "move": {
                "yaw": 9,
                "yaw_jitter": "Center",
                "yaw_jitter_value": 74,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            },
            "crouch": {
                "yaw": {
                    "left": -7,
                    "right": 26
                },
                "yaw_jitter": "Center",
                "yaw_jitter_value": 43,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            },
            "crouch move": {
                "yaw": {
                    "left": -7,
                    "right": 26
                },
                "yaw_jitter": "Center",
                "yaw_jitter_value": 43,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            },
            "slowwalk": {
                "yaw": {
                    "left": -14,
                    "right": 18
                },
                "yaw_jitter": "Center",
                "yaw_jitter_value": 42,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            },
            "air crouch": {
                "yaw": {
                    "left": -10,
                    "right": 14
                },
                "yaw_jitter": "Center",
                "yaw_jitter_value": 40,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            },
            "air": {
                "yaw": {
                    "left": -25,
                    "right": 25
                },
                "yaw_jitter": "Center",
                "yaw_jitter_value": 14,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            },
            "fakelag": {
                "yaw": {
                    "left": -35,
                    "right": 39
                },
                "yaw_jitter": "Center",
                "yaw_jitter_value": 9,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            }
        },
        "counter terrorist": {
            "stand": {
                "yaw": 8,
                "yaw_jitter": "Center",
                "yaw_jitter_value": 62,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            },
            "move": {
                "yaw": 9,
                "yaw_jitter": "Center",
                "yaw_jitter_value": 74,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            },
            "crouch": {
                "yaw": {
                    "left": -7,
                    "right": 26
                },
                "yaw_jitter": "Center",
                "yaw_jitter_value": 43,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            },
            "crouch move": {
                "yaw": {
                    "left": -7,
                    "right": 26
                },
                "yaw_jitter": "Center",
                "yaw_jitter_value": 43,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            },
            "slowwalk": {
                "yaw": {
                    "left": -14,
                    "right": 18
                },
                "yaw_jitter": "Center",
                "yaw_jitter_value": 42,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            },
            "air crouch": {
                "yaw": {
                    "left": -10,
                    "right": 14
                },
                "yaw_jitter": "Center",
                "yaw_jitter_value": 40,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            },
            "air": {
                "yaw": {
                    "left": -25,
                    "right": 25
                },
                "yaw_jitter": "Center",
                "yaw_jitter_value": 14,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            },
            "fakelag": {
                "yaw": {
                    "left": -35,
                    "right": 39
                },
                "yaw_jitter": "Center",
                "yaw_jitter_value": 9,
                "body_yaw": [ "custom jitter", 10 ],
                "body_yaw_value": 0,
                "freestanding_body_yaw": false
            }
        }
    }]])
end

local Ctext = {
    vmt_bind = function(self, module, interface, index, typestring) -- instance is bound to the callback as an upvalue
        local instance = client.create_interface(module, interface) or error('invalid interface')
        local success, typeof = pcall(ffi.typeof, typestring)
        if not success then error(typeof, 2) end
        local fnptr = ffi.cast(typeof, (ffi.cast('void***', instance)[0])[index]) or error('invalid vtable')
        return function(...)
            return fnptr(instance, ...)
        end
    end,

    init = function(self)
        self.new_intptr = ffi.typeof('int[1]')
        self.new_widebuffer = ffi.typeof('wchar_t[?]')

        self.native_Localize_ConvertAnsiToUnicode = self:vmt_bind(
            'localize.dll', 'Localize_001', 15,
            'int(__thiscall*)(void*, const char*, wchar_t*, int)'
        )
        self.native_Surface_DrawSetTextFont = self:vmt_bind(
            'vguimatsurface.dll', 'VGUI_Surface031', 23,
            'void(__thiscall*)(void*, unsigned long)'
        )
        self.native_Surface_DrawSetTextColor = self:vmt_bind(
            'vguimatsurface.dll', 'VGUI_Surface031', 25,
            'void(__thiscall*)(void*, int, int, int, int)'
        )
        self.native_Surface_DrawSetTextPos = self:vmt_bind(
            'vguimatsurface.dll', 'VGUI_Surface031', 26,
            'void(__thiscall*)(void*, int, int)'
        )
        self.native_Surface_DrawPrintText = self:vmt_bind(
            'vguimatsurface.dll', 'VGUI_Surface031', 28,
            'void(__thiscall*)(void*, const wchar_t*, int, int)'
        )
        self.native_Surface_CreateFont = self:vmt_bind(
            'vguimatsurface.dll', 'VGUI_Surface031', 71,
            'unsigned int(__thiscall*)(void*)'
        )
        self.native_Surface_SetFontGlyph = self:vmt_bind(
            'vguimatsurface.dll', 'VGUI_Surface031', 72,
            'void(__thiscall*)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int)'
        )
        self.native_Surface_GetTextSize = self:vmt_bind(
            'vguimatsurface.dll', 'VGUI_Surface031', 79,
            'void(__thiscall*)(void*, unsigned long, const wchar_t*, int&, int&)'
        )

        self.VGUI_Surface031_p = client.create_interface('vguimatsurface.dll', 'VGUI_Surface031')
        self.VGUI_Surface031 = ffi.cast('uintptr_t**', self.VGUI_Surface031_p)

        self.s_LimitDrawingArea = ffi.cast('void(__thiscall*)(void*, int, int, int, int)', self.VGUI_Surface031[0][147])

        self.VGUI_Surface031_p_address = ffi.cast('char*', self.VGUI_Surface031_p)

        self.m_bClippingEnabled = ffi.cast('bool*', self.VGUI_Surface031_p_address + 0x280)
    end,

    draw_print_text = LPH_NO_VIRTUALIZE(function(self, text)
        local wb_size = 1024
        local wide_buffer = self.new_widebuffer(wb_size)

        self.native_Localize_ConvertAnsiToUnicode(text, wide_buffer, wb_size)
        return self.native_Surface_DrawPrintText(wide_buffer, string.len(text), 0)
    end),

    font_cache = {},

    create_font = LPH_NO_VIRTUALIZE(function(self, windows_font_name, tall, weight, flags)
        local flags_i = 0
        local t = type(flags)
        if t == 'number' then
            flags_i = flags
        elseif t == 'table' then
            for i = 1, #flags do
                flags_i = flags_i + flags[i]
            end
        else
            error('invalid flags type, has to be number or table')
        end

        local cache_key = string.format('%s\0%d\0%d\0%d', windows_font_name, tall, weight, flags_i)
        if self.font_cache[cache_key] == nil then
            self.font_cache[cache_key] = self.native_Surface_CreateFont()
            self.native_Surface_SetFontGlyph(self.font_cache[cache_key], windows_font_name, tall, weight, 0, 0, bit.bor(flags_i), 0, 0)
        end

        return self.font_cache[cache_key]
    end),

    get_size = LPH_NO_VIRTUALIZE(function(self, font, text)
        local wide_buffer = self.new_widebuffer(1024)
        local w_ptr = self.new_intptr()
        local h_ptr = self.new_intptr()

        local text = string.gsub(text, '\a%x%x%x%x%x%x%x%x', '')

        self.native_Localize_ConvertAnsiToUnicode(text, wide_buffer, 1024)
        self.native_Surface_GetTextSize(font, wide_buffer, w_ptr, h_ptr)

        local w = tonumber(w_ptr[0])
        local h = tonumber(h_ptr[0])

        return vector(w, h)
    end),

    draw = LPH_NO_VIRTUALIZE(function(self, x, y, r, g, b, a, font, text, g_alpha)
        x = x + 1
        y = y + 1
        g_alpha = g_alpha or 255
        g_alpha = g_alpha / 255

        self.native_Surface_DrawSetTextFont(font)
        local offset = 0

        for word in string.gmatch(text, '\a%x%x%x%x%x%x%x%x[%w%s%^%$%(%)%%%[%]%*%+%-%?]*') do
            self.native_Surface_DrawSetTextPos(x + offset, y)
            self.native_Surface_DrawSetTextColor(
                tonumber(string.format('0x%s', string.sub(word, 2, 3))),
                tonumber(string.format('0x%s', string.sub(word, 4, 5))),
                tonumber(string.format('0x%s', string.sub(word, 6, 7))),
                tonumber(string.format('0x%s', string.sub(word, 8, 9))) * g_alpha
            )
            local txt = string.sub(word, 10)
            self:draw_print_text(txt)
            local size = self:get_size(font, txt)
            offset = offset + size.x
        end

        if offset == 0 then
            self.native_Surface_DrawSetTextPos(x, y)
            self.native_Surface_DrawSetTextColor(r, g, b, a)
            self:draw_print_text(text)
        end
    end),

    clip_rectangle = LPH_NO_VIRTUALIZE(function(self, x, y, w, h, visualize)
        self.m_bClippingEnabled[0] = true

        if x == nil then
            local screen_size = { client.screen_size() }
            self.s_LimitDrawingArea(self.VGUI_Surface031, 0, 0, screen_size[1], screen_size[2])
            return
        end

        if visualize then
            renderer.rectangle(x, y, w, h, 255, 255, 255, 30)
        end

        self.s_LimitDrawingArea(self.VGUI_Surface031, x, y, x + w, y + h)

        self.m_bClippingEnabled[0] = false
    end)
}

Ctext:init()

local smoothy = {
    to_pairs = {
        vector = { 'x', 'y', 'z' },
        imcolor =  { 'r', 'g', 'b', 'a' }
    },

    get_type = LPH_NO_VIRTUALIZE(function(self, value)
        local val_type = type(value)

        if val_type == 'cdata' and value.x and value.y and value.z then
            return 'vector'
        elseif val_type == 'cdata' and value.r and value.g and value.b and value.a then
            return 'imcolor'
        end

        if val_type == 'userdata' and value.__type then
            return string.lower(value.__type.name)
        end

        return val_type
    end),

    copy_tables = LPH_NO_VIRTUALIZE(function(self, destination, keysTable, valuesTable)
        valuesTable = valuesTable or keysTable
        local mt = getmetatable(keysTable)

        if mt and getmetatable(destination) == nil then
            setmetatable(destination, mt)
        end

        for k, v in pairs(keysTable) do
            if type(v) == 'table' then
                destination[k] = self:copy_tables({}, v, valuesTable[k])
            else
                local value = valuesTable[k]

                if type(value) == 'boolean' then
                    value = value and 1 or 0
                end

                destination[k] = value
            end
        end

        return destination
    end),

    resolve = LPH_NO_VIRTUALIZE(function(self, easing_fn, previous, new, clock, duration)
        if type(new) == 'boolean' then new = new and 1 or 0 end
        if type(previous) == 'boolean' then previous = previous and 1 or 0 end

        local previous = easing_fn(clock, previous, new - previous, duration)

        if type(new) == 'number' then
            if math.abs(new - previous) <= .001 then
                previous = new
            end

            if previous % 1 < .0001 then
                previous = math.floor(previous)
            elseif previous % 1 > .9999 then
                previous = math.ceil(previous)
            end
        end

        return previous
    end),

    perform_easing = LPH_NO_VIRTUALIZE(function(self, ntype, easing_fn, previous, new, clock, duration)
        if self.to_pairs[ntype] then
            for _, key in ipairs(self.to_pairs[ntype]) do
                previous[key] = self:perform_easing(
                    type(v), easing_fn,
                    previous[key], new[key],
                    clock, duration
                )
            end

            return previous
        end

        if ntype == 'table' then
            for k, v in pairs(new) do
                previous[k] = previous[k] or v
                previous[k] = self:perform_easing(
                    type(v), easing_fn,
                    previous[k], v,
                    clock, duration
                )
            end

            return previous
        end

        return self:resolve(easing_fn, previous, new, clock, duration)
    end),

    new = LPH_NO_VIRTUALIZE(function(this, default, easing_fn)
        if type(default) == 'boolean' then
            default = default and 1 or 0
        end

        local mt = { }
        local mt_data = {
            value = default or 0,
            easing = easing_fn or function(t, b, c, d)
                return c * t / d + b
            end
        }

        function mt.update(self, duration, value, easing)
            if type(value) == 'boolean' then
                value = value and 1 or 0
            end

            local clock = globals.frametime()
            local duration = duration or .15
            local value_type = this:get_type(value)
            local target_type = this:get_type(self.value)

            assert(value_type == target_type, string.format('type mismatch. expected %s (received %s)', target_type, value_type))

            if self.value == value then
                return value
            end

            if clock <= 0 or clock >= duration then
                if target_type == 'imcolor' or target_type == 'vector' then
                    self.value = value:clone()
                elseif target_type == 'table' then
                    this:copy_tables(self.value, value)
                else
                    self.value = value
                end
            else
                local easing = easing or self.easing

                self.value = this:perform_easing(
                    target_type, easing,
                    self.value, value,
                    clock, duration
                )
            end

            return self.value
        end

        return setmetatable(mt, {
            __metatable = false,
            __call = mt.update,
            __index = mt_data
        })
    end),

    new_interp = function(this, initial_value)
        return setmetatable({
            previous = initial_value or 0
        }, {
            __call = function(self, new_value, mul)
                local mul = mul or 1
                local tickinterval = globals.tickinterval() * mul
                local difference = math.abs(new_value - self.previous)

                if difference > 0 then
                    local time = math.min(tickinterval, globals.frametime()) / tickinterval
                    self.previous = self.previous + time * (new_value - self.previous)
                else
                    self.previous = new_value
                end

                self.previous = (self.previous % 1 < .0001) and 0 or self.previous

                return self.previous
            end
        })
    end
}

local Draw = {
    rectangle = LPH_JIT_MAX(function(position, size, clr, rounding)
        local r, g, b, a = clr.r, clr.g, clr.b, clr.a

        if not rounding or rounding == 0 then
            renderer.rectangle(position.x, position.y, size.x, size.y, r, g, b, a)
            return
        end

        if type(rounding) == 'number' then
            local rectangle_data = {
                { position.x + rounding, position.y + rounding, size.x - rounding * 2, size.y - rounding * 2 },
                { position.x + rounding, position.y, size.x - rounding * 2, rounding },
                { position.x + size.x - rounding, position.y + rounding, rounding, size.y - rounding * 2 },
                { position.x + rounding, position.y + size.y - rounding, size.x - rounding * 2, rounding },
                { position.x, position.y + rounding, rounding, size.y - rounding * 2 }
            }

            local circle_data = {
                { position.x + rounding, position.y + rounding, 180 },
                { position.x + size.x - rounding, position.y + rounding, 90 },
                { position.x + size.x - rounding, position.y + size.y - rounding, 360 },
                { position.x + rounding, position.y + size.y - rounding, 270 },
            }

            for i = 1, #rectangle_data do
                local data = rectangle_data[i]
                renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
            end

            for i = 1, #circle_data do
                local data = circle_data[i]
                renderer.circle(data[1], data[2], r, g, b, a, rounding, data[3], .25)
            end
        elseif type(rounding) == 'table' then
            local active_corners = rounding.active_corners
            local rounding = rounding.rounding

            local rectangle_data = {
                { position.x + rounding, position.y + rounding, size.x - rounding * 2, size.y - rounding * 2 },
                { position.x, position.y, size.x - rounding, rounding },
                { position.x + size.x - rounding, position.y, rounding, size.y - rounding },
                { position.x + rounding, position.y + size.y - rounding, size.x - rounding, rounding },
                { position.x, position.y + rounding, rounding, size.y - rounding }
            }

            for i = 1, #active_corners do
                local data = {
                    { position.x + rounding, position.y, size.x - rounding * 2, rounding },
                    { position.x + size.x - rounding, position.y + rounding, rounding, size.y - rounding * 2 },
                    { position.x + rounding, position.y + size.y - rounding, size.x - rounding * 2, rounding },
                    { position.x, position.y + rounding, rounding, size.y - rounding * 2 }
                }

                if active_corners[i] then
                    rectangle_data[i + 1] = data[i]
                end
            end

            local circle_data = {
                { position.x + rounding, position.y + rounding, 180 }, --left top
                { position.x + size.x - rounding, position.y + rounding, 90 }, --right top
                { position.x + size.x - rounding, position.y + size.y - rounding, 360 }, --right bottom
                { position.x + rounding, position.y + size.y - rounding, 270 }, --left bottom
            }

            for i = 1, #rectangle_data do
                local data = rectangle_data[i]
                renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
            end

            for i = 1, #circle_data do
                local data = circle_data[i]

                if active_corners[i] then
                    renderer.circle(data[1], data[2], r, g, b, a, rounding, data[3], .25)
                end
            end
        end
    end),

    rectangle_outline = LPH_JIT_MAX(function(position, size, clr, rounding, thickness)
        local r, g, b, a = clr.r, clr.g, clr.b, clr.a

        local rectangle_data = {
            { position.x + rounding, position.y, size.x - rounding * 2, thickness },
            { position.x + size.x - thickness, position.y + rounding, thickness, size.y - rounding * 2 },
            { position.x + rounding, position.y + size.y - thickness, size.x - rounding * 2, thickness },
            { position.x, position.y + rounding, thickness, size.y - rounding * 2 }
        }

        local circle_data = {
            { position.x + rounding, position.y + rounding, 180 },
            { position.x + size.x - rounding, position.y + rounding, 270 },
            { position.x + size.x - rounding, position.y + size.y - rounding, 360 },
            { position.x + rounding, position.y + size.y - rounding, 90 },
        }

        for i = 1, #rectangle_data do
            local data = rectangle_data[i]
            renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
        end

        if rounding > 0 then
            for i = 1, #circle_data do
                local data = circle_data[i]
                renderer.circle_outline(data[1], data[2], r, g, b, a, rounding, data[3], .25, thickness)
            end
        end
    end),

    gradient = LPH_JIT_MAX(function(position, size, clr1, clr2, ltr, percentage, fixed)
        local r1, g1, b1, a1 = clr1.r, clr1.g, clr1.b, clr1.a
        local r2, g2, b2, a2 = clr2.r, clr2.g, clr2.b, clr2.a

        percentage = percentage or 1

        if ltr then
            if percentage == 1 then
                renderer.gradient(position.x, position.y, size.x, size.y, r1, g1, b1, a1, r2, g2, b2, a2, true)
                return
            elseif percentage == 0 then
                renderer.gradient(position.x, position.y, size.x, size.y, r2, g2, b2, a2, r1, g1, b1, a1, true)
                return
            end

            renderer.gradient(
                position.x, position.y,
                size.x * percentage + (fixed and 1 or 0), size.y,
                r1, g1, b1, a1, r2, g2, b2, a2, true
            )

            renderer.gradient(
                position.x + size.x * percentage, position.y,
                size.x * (1 - percentage), size.y,
                r2, g2, b2, a2, r1, g1, b1, a1, true
            )
        else
            if percentage == 1 then
                renderer.gradient(position.x, position.y, size.x, size.y, r1, g1, b1, a1, r2, g2, b2, a2, false)
                return
            elseif percentage == 0 then
                renderer.gradient(position.x, position.y, size.x, size.y, r2, g2, b2, a2, r1, g1, b1, a1, false)
                return
            end

            renderer.gradient(
                position.x, position.y,
                size.x, size.y * percentage + (fixed and 1 or 0),
                r1, g1, b1, a1, r2, g2, b2, a2, false
            )

            renderer.gradient(
                position.x, position.y + size.y * percentage,
                size.x, size.y * (1 - percentage),
                r2, g2, b2, a2, r1, g1, b1, a1, false
            )
        end
    end),

    shadow = LPH_JIT_MAX(function(self, pos, size, clr, rounding, steps, inside)
        if clr.a <= 0 then
            return
        end

        local accuracy = 1
        local clr = { r = clr.r, g = clr.g, b = clr.b, a = clr.a }

        if inside then
            self.rectangle(pos, size, clr, rounding)
        end

        for i = 1, steps do
            clr.a = clr.a * ((steps - (i - 1)) / steps) ^ 2

            if clr.a > 1 then
                self.rectangle_outline(
                    vector(pos.x - i * accuracy, pos.y - i * accuracy), vector(size.x + i * accuracy * 2, size.y + i * accuracy * 2),
                    clr, rounding + i * accuracy, accuracy
                )
            end
        end
    end)
}

local ref = {
    enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
    pitch = ui.reference('AA', 'Anti-aimbot angles', 'Pitch'),
    yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') },
    yaw_jitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
    body_yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
    freestanding_body_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw'),
    edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
    freestanding = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
    slowwalk = { ui.reference('AA', 'Other', 'Slow motion') },
    leg_movement = ui.reference('AA', 'Other', 'Leg movement'),
    doubletap = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
    fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    safepoint = ui.reference('RAGE', 'Aimbot', 'Force safe point'),
	forcebaim = ui.reference('RAGE', 'Aimbot', 'Force body aim'),
    dmg_override = { ui.reference('RAGE', 'Aimbot', 'Minimum damage override') },
    quickpeek = { ui.reference('RAGE', 'Other', 'Quick peek assist') },
    reduce_aim_step = ui.reference('RAGE', 'Other', 'Reduce aim step'),
	onshotaa = { ui.reference('AA', 'Other', 'On shot anti-aim') },
	fakelag = { ui.reference('AA', 'Fake lag', 'Enabled') },
    fakelag_limit = ui.reference('AA', 'Fake lag', 'Limit'),
	ping_spike = { ui.reference('MISC', 'Miscellaneous', 'Ping spike') },
    third_person_alive = { ui.reference('VISUALS', 'Effects', 'Force third person (alive)') },
    dpi_scale = ui.reference('MISC', 'Settings', 'DPI scale'),
    feature_indicators = ui.reference('VISUALS', 'Other ESP', 'Feature indicators'),
    doubletap_mode = select(2, ui.reference('RAGE', 'Aimbot', 'Double tap')),
    target_hitbox = ui.reference('RAGE', 'Aimbot', 'Target hitbox'),
    minimum_damage = ui.reference('RAGE', 'Aimbot', 'Minimum damage'),
    auto_scope = ui.reference('RAGE', 'Aimbot', 'Automatic scope'),
    quickpeek_assist_mode = { ui.reference('RAGE', 'Other', 'Quick peek assist mode') },
    quickpeek_assist_distance = ui.reference('RAGE', 'Other', 'Quick peek assist distance'),
    antiaim_refs = {
        main = {
            select(2, ui.reference('AA', 'Anti-aimbot angles', 'Yaw')),
            select(1, ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')),
            select(2, ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')),
            select(1, ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')),
            select(2, ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')),
            ui.reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw')
        },
        other = {
            enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
            pitch_mode = select(1, ui.reference('AA', 'Anti-aimbot angles', 'Pitch')),
            pitch_value = select(2, ui.reference('AA', 'Anti-aimbot angles', 'Pitch')),
            yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
            yaw = select(1, ui.reference('AA', 'Anti-aimbot angles', 'Yaw')),
            edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
            roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
            freestanding_enable = select(1, ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')),
            freestanding_key = select(2, ui.reference('AA', 'Anti-aimbot angles', 'Freestanding'))
        }
    }
}

client.delay_call(.1, function()
    ref.dormantaim = nil do
        local status, result = pcall(ui.reference, 'RAGE', 'Aimbot', 'Dormant aimbot')

        if status then
            ref.dormantaim = { ui.reference('RAGE', 'Aimbot', 'Dormant aimbot') }
        end
    end

    ref.helper = nil do
        local status, result = pcall(ui.reference, 'VISUALS', 'Other ESP', 'Helper')

        if status then
            ref.helper = { ui.reference('VISUALS', 'Other ESP', 'Helper') }
        end
    end
end)

local ctx = new_class()
    :struct 'data' {
        name = 'risen',
        last_update = '12.03',
        menu_dir = { 'AA', 'Anti-aimbot angles' },
        versions = {
            live = 'live',
            beta = 'beta',
            debug = 'debug',
            private = 'sunset',
            dev = 'dev'
        },
        hidden_features = false,
        links = {
            notifier = {
                logo = 'https://euphemia.fun/scriptleaks/other/tutajpowinnabycnazwaok/risen/risen_logo.png',
                import = 'https://euphemia.fun/scriptleaks/other/tutajpowinnabycnazwaok/risen/import.png',
                export = 'https://euphemia.fun/scriptleaks/other/tutajpowinnabycnazwaok/risen/export.png',
                delete = ''
            },
            watermark = {
                logo = 'https://euphemia.fun/scriptleaks/other/tutajpowinnabycnazwaok/risen/risen_logo.png'
            },
            popups = {
                logo = 'https://euphemia.fun/scriptleaks/other/tutajpowinnabycnazwaok/risen/risen_logo.png'
            }
        },

        update_data = function(self)
            local obex_builds = {
                ['User'] = 'live',
                ['Beta'] = 'beta',
                ['Debug'] = 'debug',
                ['Private'] = 'private'
            }

            local info = obex_fetch and obex_fetch() or { username = 'shade', build = '', discord = '' }

            if info.username == 'Damekuchuj' then
                info.username = 'kdm'
                self.hidden_features = true
            elseif info.username == 'Mag' then
                self.hidden_features = true
            elseif info.username == 'Lunarek' then
                info.username = 'lunar'
            elseif info.username == 'Saddam3' then
                info.username = 'Zjeb czarny'
            end

            self.username = info.username:lower()
            self.discord_id = info.discord
            self.version = self.versions[obex_builds[info.build]]
            self.version_to_download = self.version
            self.source = LPH_OBFUSCATED == nil

            self.database_key = '[:]'.. self.name:upper() ..'[:]4321'
            self.database = database.read(self.database_key) or {}

            self.database.configs = self.database.configs or {}
            self.database.antiaim = self.database.antiaim or {}
            self.database.antiaim.antibruteforce = self.database.antiaim.antibruteforce or {}
            self.database.antiaim.dynamic = self.database.antiaim.dynamic or {}

            if self.source then
                self.username = 'admin'
                self.hidden_features = true
                self.version = self.versions.dev
                self.version_to_download = self.versions.debug
            else
                client.exec('clear')
            end
        end
    }

    :struct 'common' {
        vars = {
            sv_gravity = cvar.sv_gravity,
            sv_jump_impulse = cvar.sv_jump_impulse
        },

        lerp = LPH_NO_VIRTUALIZE(function(self, a, b, percentage)
            if a == b then
                return b
            end

            return a + (b - a) * percentage
        end),

        colored_text = LPH_NO_VIRTUALIZE(function(self, text, color)
            return string.format('\a%02x%02x%02x%02x%s', color[1], color[2], color[3], color[4], text)
        end),

        colored_single_text = LPH_NO_VIRTUALIZE(function(self, color1, text, color2)
            return string.format(
                '\a%02x%02x%02x%02x%s\a%02x%02x%02x%02x',
                color1[1], color1[2], color1[3], color1[4], text, color2[1], color2[2], color2[3], color2[4]
            )
        end),

        gradient_text_anim = LPH_NO_VIRTUALIZE(function(self, text, color1, color2, speed, delay, invert)
            local r1, g1, b1, a1 = unpack(color1)
            local r2, g2, b2, a2 = unpack(color2)

            speed = speed or 1
            delay = delay or 0
            delay = delay + 3

            local return_text = {}

            local text_lenght = string.len(text)

            local curtime = globals.curtime()
            local highlight_fraction = invert and -(curtime * speed) % delay - 2 or (curtime * speed) % delay - 2

            for i = 1, text_lenght do
                local character = string.sub(text, i, i)
                local character_fraction = (i - 1) / (text_lenght - 1)

                local highlight_delta = character_fraction - highlight_fraction

                if highlight_delta > 1 then
                    highlight_delta = 1 * 2 - highlight_delta
                end

                local r, g, b, a = r1, g1, b1, a1

                if highlight_delta >= 0 and highlight_delta <= 1 then
                    r = r + (r2 - r) * highlight_delta
                    g = g + (g2 - g) * highlight_delta
                    b = b + (b2 - b) * highlight_delta
                    a = a + (a2 - a) * highlight_delta
                end

                return_text[i] = string.format('\a%02x%02x%02x%02x%s', r, g, b, a, character)
            end

            return table.concat(return_text), highlight_fraction
        end),

        color_swap = LPH_NO_VIRTUALIZE(function(self, color1, color2, weight)
            weight = math.clamp(weight, 0, 1)

            if weight == 0 then
                return color1
            elseif weight == 1 then
                return color2
            end

            return {
                self:lerp(color1[1], color2[1], weight),
                self:lerp(color1[2], color2[2], weight),
                self:lerp(color1[3], color2[3], weight),
                self:lerp(color1[4], color2[4], weight)
            }
        end),

        gradient_text = LPH_NO_VIRTUALIZE(function(self, text, color1, color2, fraction, gradient)
            fraction = math.clamp(fraction, 0, 1)

            if fraction == 0 then
                return self:colored_text(text, color2)
            elseif fraction == 1 then
                return self:colored_text(text, color1)
            end

            local text_length = string.len(text)

            local return_text = {}

            for i = 1, text_length do
                local weight = gradient and ((1 - fraction) - (text_length - i) / (text_length - 1)) + (1 - fraction) or i - fraction * text_length
                local color = self:color_swap(color1, color2, weight)

                return_text[i] = self:colored_text(string.sub(text, i, i), color)
            end

            return table.concat(return_text)
        end),

        can_shoot = function(self, ent)
            ent = ent or entity.get_local_player()
            local NextAttack = entity.get_prop(ent, 'm_flNextAttack')
            local wpn = entity.get_player_weapon(ent)
            local NextPrimaryAttack = entity.get_prop(wpn, 'm_flNextPrimaryAttack')
            return math.max(0, NextAttack or 0, NextPrimaryAttack or 0) <= globals.curtime()
        end,

        set_movement = LPH_NO_VIRTUALIZE(function(self, cmd, destination, local_player)
            local move_yaw = vector(vector(entity.get_origin(local_player)):to(destination):angles()).y

            cmd.in_forward = 1
            cmd.in_back = 0
            cmd.in_moveleft = 0
            cmd.in_moveright = 0
            cmd.in_speed = 0
            cmd.forwardmove = 800
            cmd.sidemove = 0
            cmd.move_yaw = move_yaw
        end),

        extrapolate_position = LPH_NO_VIRTUALIZE(function(self, ent, origin, ticks, inverted)
            local tickinterval = globals.tickinterval()

            local sv_gravity = self.vars.sv_gravity:get_float() * tickinterval
            local sv_jump_impulse = self.vars.sv_jump_impulse:get_float() * tickinterval

            local p_origin, prev_origin = origin, origin

            local velocity = vector(entity.get_prop(ent, 'm_vecVelocity'))
            local gravity = velocity.z > 0 and -sv_gravity or sv_jump_impulse

            for i = 1, ticks do
                prev_origin = p_origin
                p_origin = vector(
                    p_origin.x + (inverted and -(velocity.x * tickinterval) or (velocity.x * tickinterval)),
                    p_origin.y + (inverted and -(velocity.y * tickinterval) or (velocity.y * tickinterval)),
                    p_origin.z + (inverted and -((velocity.z + gravity) * tickinterval) or (velocity.z + gravity) * tickinterval)
                )

                local fraction = client.trace_line(-1,
                    prev_origin.x, prev_origin.y, prev_origin.x,
                    p_origin.x, p_origin.y, p_origin.x
                )

                if fraction <= .99 then
                    return prev_origin
                end
            end

            return p_origin
        end),

        check_weapons = LPH_NO_VIRTUALIZE(function(self, ent, classname_table)
            if not ent then return false end
            local weapon_id = entity.get_player_weapon(ent)
            if not weapon_id then return false end
            local weapon_name = entity.get_classname(weapon_id)
            for i = 1, #classname_table do
                if weapon_name == classname_table[i] then return true end
            end
            return false
        end),

        ClosestPointOnRay = LPH_NO_VIRTUALIZE(function(self, target, rayStart, rayEnd)
            local to = target - rayStart
            local dir = rayEnd - rayStart
            local length = dir:length()
            dir = dir:normalized()

            local rangeAlong = dir:dot(to)

            if rangeAlong < .0 then
                return rayStart
            end

            if rangeAlong > length then
                return rayEnd
            end

            return rayStart + dir * vector(rangeAlong, rangeAlong, rangeAlong)
        end),

        extend_vector = LPH_NO_VIRTUALIZE(function(self, pos, length, angle)
            local rad = angle * math.pi / 180
            return vector(pos.x + (math.cos(rad) * length), pos.y + (math.sin(rad) * length), pos.z)
        end),

        get_players = LPH_NO_VIRTUALIZE(function(self, include_enemies, include_teammates, include_localplayer, include_dormant, include_invisible)
            local result = {}
            local player_resource = entity.get_player_resource()
            local maxplayers = globals.maxplayers()
            local plocal = entity.get_local_player()

            for player = 1, maxplayers do
                if entity.get_prop(player_resource, 'm_bConnected', player) ~= 1 then
                    goto skip
                end

                if entity.get_prop(player_resource, 'm_bAlive', player) ~= 1 then
                    goto skip
                end

                if not include_localplayer and player == plocal then
                    goto skip
                end

                if include_teammates then
                    if not include_enemies and entity.is_enemy(player) then
                        goto skip
                    end
                elseif not entity.is_enemy(player) then
                    goto skip
                end

                if not include_dormant and entity.is_dormant(player) then
                    goto skip
                end

                if not include_invisible and select(5, entity.get_bounding_box(player)) <= 0 then
                    goto skip
                end

                result[#result + 1] = player

                ::skip::
            end

            return result
        end),

        get_nearest_player = LPH_NO_VIRTUALIZE(function(self, players)
            local lp_eyepos = vector(client.eye_position())
            local lp_camera_angles = vector(client.camera_angles())

            local calc = function(xdelta, ydelta)
                if xdelta == 0 and ydelta == 0 then
                    return 0
                end

                return math.deg(math.atan2(ydelta, xdelta))
            end

            local bestenemy = nil
            local fov = 180

            for i = 1, #players do
                local player = players[i]

                local player_origin = vector(entity.get_origin(player))

                local cur_fov = math.abs(
                    anti_aim_f.normalize_angle(
                        calc(lp_eyepos.x - player_origin.x, lp_eyepos.y - player_origin.y) - lp_camera_angles.y + 180
                    )
                )

                if cur_fov < fov then
                    fov = cur_fov
                    bestenemy = player
                end
            end

            return bestenemy
        end),

        gram_create = LPH_NO_VIRTUALIZE(function(self, value, count)
            local gram = { }
            for i = 1, count do
                gram[i] = value
            end
            return gram
        end),

        gram_update = LPH_NO_VIRTUALIZE(function(self, tab, value, forced)
            local new_tab = tab
            if forced or new_tab[#new_tab] ~= value then
                table.insert(new_tab, value)
                table.remove(new_tab, 1)
            end
            tab = new_tab
        end),

        get_average = LPH_NO_VIRTUALIZE(function(tab)
            local elements, sum = 0, 0
            for k, v in pairs(tab) do
                sum = sum + v
                elements = elements + 1
            end
            return sum / elements
        end)
    }

local script = new_class()
    :struct 'vars' {
        p_state = {
            condition = 'stand',
            team = 'terrorist',
            fakelag = false,
            second_condition = 'normal',
            other_condition = false,
            velocity = 0,
            condition_number = 1
        },
        teams = { 'terrorist', 'counter terrorist' },
        conditions = { 'stand', 'move', 'crouch', 'crouch move', 'slowwalk', 'air crouch', 'air', 'fakelag', 'legit aa' },
        builder_conditions = { 'stand', 'move', 'crouch', 'crouch move', 'slowwalk', 'air crouch', 'air', 'fakelag' },
        conditions_to_int = {
            ['stand'] = 1,
            ['move'] = 2,
            ['crouch'] = 3,
            ['crouch move'] = 4,
            ['slowwalk'] = 5,
            ['air crouch'] = 6,
            ['air'] = 7,
            ['fakelag'] = 8,
            ['legit aa'] = 9
        },
        antibruteforce = {
            max_phases = 5
        },
        hitgroup_names = { [0] = 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' },
        hotkey_modes = {
            [0] = 'Always on',
            'On hotkey',
            'Toggle',
            'Off hotkey'
        },
        screen_size = vector(client.screen_size()),
        local_player = entity.get_local_player(),

        doubletap = {
            active = false,
            charged = false,
            defensive = {
                active = false,
                ticks = 0,
                ticks_from_activation = 0,
                active_until = 0
            }
        },

        fakelag = {
            choke = 0
        },

        values = {
            doubletap = {
                indicators = {},
                old_sim_time = 0
            },
            fakelag = {
                last_origin = nil,
                teleport = 0,
                teleport_data = ctx.common:gram_create(0, 3),
                current_choke = 0
            }
        },

        on_run_command = function(self, cmd)
            self.screen_size = vector(client.screen_size())
            -- self.local_player = entity.get_local_player()
        end,

        on_indicator = LPH_NO_VIRTUALIZE(function(self, indicator)
            self.values.doubletap.indicators[#self.values.doubletap.indicators + 1] = indicator
        end),

        native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'uintptr_t(__thiscall*)(void*, int)'),

        detect_defensive = LPH_JIT_MAX(function(self)
            local plocal = self.local_player
            local tickcount = globals.tickcount()
            local client_latency = client.latency()

            local sim_time = toticks(entity.get_prop(plocal, 'm_flSimulationTime'))
            local sim_diff = sim_time - self.values.doubletap.old_sim_time

            -- local ptr = self.native_GetClientEntity(plocal)

            -- local m_flOldSimulationTime = toticks(ffi.cast('float*', ptr + 0x26C)[0])

            -- print(self.values.doubletap.last_sim_time)
            -- print(m_flOldSimulationTime)

            if self.doubletap.charged then
                if sim_diff < 0 then
                    self.doubletap.defensive.active_until = tickcount + math.abs(sim_diff) - toticks(client_latency)
                    self.doubletap.defensive.ticks = math.abs(sim_diff)
                end

                self.doubletap.defensive.active = self.doubletap.defensive.active_until > tickcount
            else
                self.doubletap.defensive.active_until = 0
                self.doubletap.defensive.active = false
            end

            -- if self.doubletap.charged then
            --     if sim_diff < 0 then
            --         self.doubletap.defensive.active_until = tickcount + math.abs(sim_diff) - toticks(client.latency)
            --         self.doubletap.defensive.ticks = math.abs(sim_diff)
            --     end
            -- end

            if self.doubletap.defensive.active then
                self.doubletap.defensive.ticks_from_activation = self.doubletap.defensive.ticks - (self.doubletap.defensive.active_until - tickcount)
            end

            self.values.doubletap.old_sim_time = sim_time

            -- if self.doubletap.defensive.active_until > (tickcount + 32) then
            --     self.doubletap.defensive.active_until = 0
            -- end
        end),

        planting_started_at = nil,

        on_bomb_beginplant = function(self, e)
            self.planting_started_at = globals.curtime()
        end,

        force_feature_indicators = function(self, reference)
            if not table.contains(reference, 'Double tap') then
                local to_set = function()
                    local new_table = { 'Double tap' }

                    local indicators = ui.get(reference)

                    for i = 1, #indicators do
                        new_table[i + 1] = indicators[i]
                    end

                    return new_table
                end

                ui.set(reference, to_set())
            end
        end,

        on_paint_ui = LPH_NO_VIRTUALIZE(function(self)
            self.local_player = entity.get_local_player()

            self.doubletap.active = false
            self.doubletap.charged = false

            local h = self.screen_size.y

            local starting = h - 350

            for index, indicator in pairs(self.values.doubletap.indicators) do index = index - 1 -- this is how you fix lua tables lol
                local text = indicator.text
                local r, g, b, a = indicator.r, indicator.g, indicator.b, indicator.a

                if text == 'DT' then
                    self.doubletap.active = true

                    if indicator.g == 255 then
                        self.doubletap.charged = true
                    end

                    if ui.get(self.menu.other.disable_dt_indicator) then
                        goto skip
                    end
                end

                local width, height = renderer.measure_text('d+', text)
                local offset = index * (height + 12)

                local gradient_width = math.floor(width / 1.5)

                local y = starting - offset

                if (text == 'A' or text == 'B') and r == 252 and g == 243 and b == 105 then
                    if type(self.planting_started_at) == 'number' then
                        local radius = math.ceil(height * .33)

                        local pos = { 29 + width + radius + 7, y - 4 + radius * 2 }

                        local plant_percentage = (globals.curtime() - self.planting_started_at) / 3.125

                        renderer.circle_outline(pos[1], pos[2], 0, 0, 0, 210, radius, 0, 1, 5)
                        renderer.circle_outline(pos[1], pos[2], 200, 200, 200, 255, radius - 1, 0, plant_percentage, 3)

                        gradient_width = gradient_width + radius * 2
                    end
                end

                renderer.gradient(0, y, 29 + width / 2, height + 4, 0, 0, 0, 0, 0, 0, 0, 50, true)
                renderer.gradient(29 + width / 2, y, 29 + width / 2, height + 4, 0, 0, 0, 50, 0, 0, 0, 0, true)
                renderer.text(29, y + 2, r, g, b, a, 'd+', 0, text)

                ::skip::
            end

            self.values.doubletap.indicators = {}
        end)
    }

    :struct 'handlers' {
        console_message = function(self, color, message)
            client.color_log(255, 255, 255, '[\0')
            client.color_log(color[1], color[2], color[3], ctx.data.name ..'\0')
            client.color_log(255, 255, 255, '] \0')

            for i = 1, #message do
                local text = message[i]

                local color_value = text[2] and color or { 255, 255, 255 }

                client.color_log(color_value[1], color_value[2], color_value[3], (text[1] ..'\0'))
            end

            client.color_log(color[1], color[2], color[3], ' ')
        end,

        handle_error = function(self, error, icon)
            local error = error or { { '' } }
            local icon = icon or 'logo'

            self.notifier:add({
                color = { r = 255, g = 0, b = 0, a = 255 },
                time = self.notifier.time.long,
                text = error,
                icon = icon
            })

            self:console_message({ 255, 0, 0 }, error)
        end
    }

    :struct 'menu' {
        list = {},
        values = {
            amount = 0,
            config_elements = 0
        },

        visibility_handle = function(self)
            for k, v in pairs(self.list) do
                local visible = v.visible_state()

                ui.set_visible(v.element, visible)

                if v.label then
                    ui.set_visible(v.label, visible)
                end
            end
        end,

        get = LPH_JIT_MAX(function(self, index)
            return self.list[index] and ui.get(self.list[index].element)
        end),

        get_element = function(self, index)
            return self.list[index] and self.list[index].element
        end,

        contains = LPH_NO_VIRTUALIZE(function(self, index, value)
            local index = self:get(index)

            if type(index) ~= 'table' then
                return false
            end

            for i = 1, #index do
                if index[i] == value then
                    return true
                end
            end

            return false
        end),

        new = function(self, element_type, args, ...)
            assert(element_type, 'Type is nil')
            assert(args.name, 'Name is nil')
            assert(type(args.index) == 'string', 'Invalid type of index')

            self.list[args.index] = {}

            args.location = args.location or ctx.data.menu_dir

            self.values.amount = self.values.amount + 1

            local label_mode = false

            local tab, container = args.location[1], args.location[2]

            local name = args.name

            if not label_mode and name == '' then
                name = '\n'.. self.values.amount
            end

            local element_name = label_mode and string.format('\n%s%d', ctx.data.name, self.values.amount) or name

            local funcs = {
                ['checkbox'] = function(name, element_name)
                    local item, label
                    item = ui.new_checkbox(tab, container, element_name)
                    if label_mode and name ~= '' then
                        label = ui.new_label(tab, container, name)
                    end
                    return item, label
                end,
                ['combobox'] = function(name, element_name, args)
                    local item, label
                    if label_mode and name ~= '' then
                        label = ui.new_label(tab, container, name)
                    end
                    item = ui.new_combobox(tab, container, element_name, args)
                    return item, label
                end,
                ['multiselect'] = function(name, element_name, args)
                    local item, label
                    if label_mode and name ~= '' then
                        label = ui.new_label(tab, container, name)
                    end
                    item = ui.new_multiselect(tab, container, element_name, args)
                    return item, label
                end,
                ['hotkey'] = function(name, element_name, inline, default_key)
                    local item, label
                    if inline or not label_mode then
                        item = ui.new_hotkey(tab, container, element_name, inline, default_key or 0)
                    else
                        label = ui.new_label(tab, container, name)
                        item = ui.new_hotkey(tab, container, element_name, true, default_key or 0)
                    end
                    return item, label
                end,
                ['slider'] = function(name, element_name, min, max, init_value, show_tooltip, unit, scale, tooltips)
                    show_tooltip = show_tooltip or true
                    scale = scale or 1
                    local item, label
                    if label_mode and name ~= '' then
                        label = ui.new_label(tab, container, name)
                    end
                    item = ui.new_slider(tab, container, element_name, min, max, init_value, show_tooltip, unit, scale, tooltips)
                    return item, label
                end,
                ['color_picker'] = function(name, element_name, accent, inline)
                    local r, g, b, a = unpack(accent)
                    local item, label
                    if inline or not label_mode then
                        item = ui.new_color_picker(tab, container, element_name, r, g, b, a)
                    else
                        label = ui.new_label(tab, container, name)
                        item = ui.new_color_picker(tab, container, element_name, r, g, b, a)
                    end
                    return item, label
                end,
                ['label'] = function(name, element_name)
                    local item, label
                    label = ui.new_label(tab, container, name)
                    return item, label
                end,
            }

            self.list[args.index].name = args.name

            self.list[args.index].element, self.list[args.index].label = funcs[element_type](name, element_name, ...)

            self.list[args.index].flags = args.flags or ''

            if self.list[args.index].flags ~= '-' then
                self.values.config_elements = self.values.config_elements + 1
            end

            self.list[args.index].visible_state = function()
                if not args.conditions then
                    return true
                end

                for k, v in pairs(args.conditions) do
                    if not v() then
                        return false
                    end
                end

                return true
            end

            self.list[args.index].callbacks = {
                function()
                    self:visibility_handle()
                end
            }

            local call_callbacks = function()
                for i = 1, #self.list[args.index].callbacks do
                    self.list[args.index].callbacks[i]()
                end
            end

            ui.set_callback(self.list[args.index].element, call_callbacks)

            self:visibility_handle()
        end,

        add_callback = function(self, index, func)
            table.insert(self.list[index].callbacks, func)
        end,

        colors = {
            accent = { 162, 186, 215, 255 }
        },

        update_colors = function(self)
            self.colors.accent = { ui.get(self:get_element('accent_color')) }
        end,

        multiselects_values = {
            bind_selector = {},
            antibruteforce_reset_events = {},
            binds_freestand_disablers = {},
            binds_force_defensive_conditions = {},
            popups_elements = {},
            indicators_adjustments = {},
            animation_breakers = {}
        },

        initialize = function(self)
            self:new('combobox', {
                index = 'tab_selector',
                name = '',
                flags = '-'
            }, { 'aa', 'additions', 'visuals', 'misc', 'configs' })

            self:new('color_picker', {
                index = 'accent_color',
                name = '',
                flags = 'c'
            }, { 162, 186, 215, 255 }, true)

            self:new('checkbox', {
                index = 'aa:master_switch',
                name = '[aa] - enable',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end
                }
            })

            self.hidden_cfg_warning = {
                label1 = ui.new_label(ctx.data.menu_dir[1], ctx.data.menu_dir[2], '\aff3d3dff! This config is hidden !'),
                label2 = ui.new_label(ctx.data.menu_dir[1], ctx.data.menu_dir[2], '(if you want to unhide anti-aim tab'),
                label3 = ui.new_label(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'load different config)')
            }

            self.antibruteforce = {
                visible = false,
                buttons = {
                    antibruteforce = ui.new_button(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'go to antibruteforce tab', function()
                        self.antibruteforce.visible = true

                        self:visibility_handle()
                    end),
                    antiaim = ui.new_button(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'go to antiaim tab', function()
                        self.antibruteforce.visible = false

                        self:visibility_handle()
                    end)
                }
            }

            self:new('combobox', {
                index = 'aa:antiaim_preset',
                name = '[aa] - anti-aim preset:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return not self.config_system.hidden_config end,
                    function() return not self.antibruteforce.visible end
                }
            }, { 'experimental', 'dynamic', 'configurator' })

            self:new('multiselect', {
                index = 'aa:dynamic:antibruteforce:events',
                name = '[aa] - dynamic events:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return self:get('aa:antiaim_preset') == 'dynamic' end,
                    function() return not self.config_system.hidden_config end,
                    function() return not self.antibruteforce.visible end
                }
            }, { 'miss', 'hit' })

            -- self:new('slider', {
            --     index = 'aa:dynamic:xway_chance',
            --     name = '[aa] - xway chance:',
            --     flags = '',
            --     conditions = {
            --         function() return self:get('tab_selector') == 'aa' end,
            --         function() return self:get('aa:antiaim_preset') == 'dynamic' end,
            --         function() return not self.config_system.hidden_config end,
            --         function() return not self.antibruteforce.visible end
            --     }
            -- }, 0, 100, 0, true, '%', 1, { [0] = 'Off', [100] = 'Always on' })

            self:new('checkbox', {
                index = 'aa:antibruteforce:enable',
                name = '[aa] - enable anti-bruteforce',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return not self.config_system.hidden_config end,
                    function() return self.antibruteforce.visible end
                }
            })

            self:new('combobox', {
                index = 'aa:antibruteforce:type',
                name = '[bf] - type:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return self:get('aa:antibruteforce:enable') end,
                    function() return not self.config_system.hidden_config end,
                    function() return self.antibruteforce.visible end
                }
            }, { 'simple' }) -- , 'condition based'

            self:new('multiselect', {
                index = 'aa:antibruteforce:events',
                name = '[bf] - events:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return self:get('aa:antibruteforce:enable') end,
                    function() return not self.config_system.hidden_config end,
                    function() return self.antibruteforce.visible end
                }
            }, { 'miss', 'hit', 'headshot' })

            self:new('multiselect', {
                index = 'aa:antibruteforce:reset_events',
                name = '[bf] - reset events:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return self:get('aa:antibruteforce:enable') end,
                    function() return not self.config_system.hidden_config end,
                    function() return self.antibruteforce.visible end
                }
            }, { 'round start', 'shooter death', 'time' })

            self:new('slider', {
                index = 'aa:antibruteforce:reset_events:time',
                name = '[reset] - time:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return self:get('aa:antibruteforce:enable') end,
                    function() return self:contains('aa:antibruteforce:reset_events', 'time') end,
                    function() return not self.config_system.hidden_config end,
                    function() return self.antibruteforce.visible end
                }
            }, 2, 10, 4, true, 's')

            self:new('combobox', {
                index = 'aa:antibruteforce:simple:mode',
                name = '[bf] - mode:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return self:get('aa:antibruteforce:enable') end,
                    function() return self:get('aa:antibruteforce:type') == 'simple' end,
                    function() return not self.config_system.hidden_config end,
                    function() return self.antibruteforce.visible end
                }
            }, { 'jitter', 'static' })

            self:new('combobox', {
                index = 'aa:antibruteforce:simple:jitter:mode',
                name = '[jitter] - mode:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return self:get('aa:antibruteforce:enable') end,
                    function() return self:get('aa:antibruteforce:type') == 'simple' end,
                    function() return self:get('aa:antibruteforce:simple:mode') == 'jitter' end,
                    function() return not self.config_system.hidden_config end,
                    function() return self.antibruteforce.visible end
                }
            }, { 'automatic', 'phases' })

            self:new('slider', {
                index = 'aa:antibruteforce:simple:jitter:phases:amount',
                name = '[phases] - amount:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return self:get('aa:antibruteforce:enable') end,
                    function() return self:get('aa:antibruteforce:type') == 'simple' end,
                    function() return self:get('aa:antibruteforce:simple:mode') == 'jitter' end,
                    function() return self:get('aa:antibruteforce:simple:jitter:mode') == 'phases' end,
                    function() return not self.config_system.hidden_config end,
                    function() return self.antibruteforce.visible end
                }
            }, 1, self.vars.antibruteforce.max_phases, 1)

            for i = 1, self.vars.antibruteforce.max_phases do
                local base_condition = function()
                    return self:get('tab_selector') == 'aa'
                    and self:get('aa:antibruteforce:enable')
                    and self:get('aa:antibruteforce:type') == 'simple'
                    and self:get('aa:antibruteforce:simple:mode') == 'jitter'
                    and self:get('aa:antibruteforce:simple:jitter:mode') == 'phases'
                    and self:get('aa:antibruteforce:simple:jitter:phases:amount') >= i
                    and not self.config_system.hidden_config
                    and self.antibruteforce.visible
                end

                self:new('slider', {
                    index = string.format('aa:antibruteforce:simple:jitter:phases:%d:yaw_jitter', i),
                    name = string.format('[phase: %d] - yaw jitter:', i),
                    flags = '',
                    conditions = {
                        base_condition
                    }
                }, -180, 180, 0)
            end

            self:new('checkbox', {
                index = 'aa:antibruteforce:simple:static:detect_side',
                name = '[static] - detect side',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return self:get('aa:antibruteforce:enable') end,
                    function() return self:get('aa:antibruteforce:type') == 'simple' end,
                    function() return self:get('aa:antibruteforce:simple:mode') == 'static' end,
                    function() return not self.config_system.hidden_config end,
                    function() return self.antibruteforce.visible end
                }
            })

            self:new('multiselect', {
                index = 'aa:builder:builder_options',
                name = '[aa] - configurator options:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return self:get('aa:antiaim_preset') == 'configurator' end,
                    function() return not self.config_system.hidden_config end,
                    function() return not self.antibruteforce.visible end
                }
            }, { 'team based' })

            self:new('combobox', {
                index = 'aa:builder:team_selector',
                name = '[aa] - team:',
                flags = '-',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return self:get('aa:antiaim_preset') == 'configurator' end,
                    function() return self:contains('aa:builder:builder_options', 'team based') end,
                    function() return not self.config_system.hidden_config end,
                    function() return not self.antibruteforce.visible end
                }
            }, self.vars.teams)

            self:new('combobox', {
                index = 'aa:builder:condition_selector',
                name = '[aa] - condition:',
                flags = '-',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return self:get('aa:antiaim_preset') == 'configurator' end,
                    function() return not self.config_system.hidden_config end,
                    function() return not self.antibruteforce.visible end
                }
            }, self.vars.builder_conditions)

            self:new('checkbox', {
                index = 'aa:builder:preview_selected_state',
                name = '[aa] - preview selected state',
                flags = '-',
                conditions = {
                    function() return self:get('tab_selector') == 'aa' end,
                    function() return self:get('aa:antiaim_preset') == 'configurator' end,
                    function() return not self.config_system.hidden_config end,
                    function() return not self.antibruteforce.visible end
                }
            })

            self.builder = {
                configuring_label = ui.new_label(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'configuring: ')
            }

            for i, team in pairs(self.vars.teams) do
                for k, condition in pairs(self.vars.builder_conditions) do
                    local handle_name = function(name)
                        local short_names = {
                            team = {
                                [self.vars.teams[1]] = 'T',
                                [self.vars.teams[2]] = 'CT'
                            }
                        }

                        return string.format('%s\n%s%s', name, short_names.team[team], condition)
                    end

                    local handle_index = function(index)
                        return string.format('aa:builder:states:%s:%s:%s', team, condition, index)
                    end

                    local base_condition = function()
                        local show_team = team == 'terrorist'

                        if self:contains('aa:builder:builder_options', 'team based') then
                            show_team = self:get('aa:builder:team_selector') == team
                        end

                        return self:get('tab_selector') == 'aa'
                        and self:get('aa:antiaim_preset') == 'configurator'
                        and show_team
                        and self:get('aa:builder:condition_selector') == condition
                        and not self.config_system.hidden_config
                        and not self.antibruteforce.visible
                    end

                    self:new('combobox', {
                        index = handle_index('body_yaw'),
                        name = handle_name('body yaw:'),
                        flags = '',
                        conditions = {
                            base_condition
                        }
                    }, { 'Off', 'Opposite', 'Jitter', 'Static', 'custom jitter' })

                    self:new('slider', {
                        index = handle_index('custom_jitter_delay'),
                        name = handle_name('\ncustom jitter delay:'),
                        flags = '',
                        conditions = {
                            base_condition,
                            function() return self:get(handle_index('body_yaw')) == 'custom jitter' end
                        }
                    }, 2, 10, 2, true, nil, 2)

                    self:new('slider', {
                        index = handle_index('body_yaw_value'),
                        name = handle_name('\nbody yaw value:'),
                        flags = '',
                        conditions = {
                            base_condition,
                            function()
                                local body_yaw = self:get(handle_index('body_yaw'))

                                return body_yaw ~= 'Off' and body_yaw ~= 'Opposite' and body_yaw ~= 'custom jitter'
                            end
                        }
                    }, -180, 180, 0)

                    self:new('combobox', {
                        index = handle_index('yaw_mode'),
                        name = handle_name('yaw mode:'),
                        flags = '',
                        conditions = {
                            base_condition
                        }
                    }, { 'simple', 'body side based' })

                    self:new('slider', {
                        index = handle_index('yaw_value'),
                        name = handle_name('yaw:'),
                        flags = '',
                        conditions = {
                            base_condition,
                            function() return self:get(handle_index('yaw_mode')) == 'simple' end
                        }
                    }, -180, 180, 0)

                    self:new('slider', {
                        index = handle_index('yaw_left_value'),
                        name = handle_name('yaw left:'),
                        flags = '',
                        conditions = {
                            base_condition,
                            function() return self:get(handle_index('yaw_mode')) == 'body side based' end
                        }
                    }, -180, 180, 0)

                    self:new('slider', {
                        index = handle_index('yaw_right_value'),
                        name = handle_name('yaw right:'),
                        flags = '',
                        conditions = {
                            base_condition,
                            function() return self:get(handle_index('yaw_mode')) == 'body side based' end
                        }
                    }, -180, 180, 0)

                    self:new('combobox', {
                        index = handle_index('yaw_jitter'),
                        name = handle_name('yaw jitter:'),
                        flags = '',
                        conditions = {
                            base_condition,
                            function() return self:get(handle_index('body_yaw')) ~= 'custom jitter' end
                        }
                    }, { 'Off', 'Offset', 'Center', 'Random', 'Skitter', '3-way', '5-way' })

                    self:new('combobox', {
                        index = handle_index('yaw_jitter:xway:mode'),
                        name = handle_name('xway mode:'),
                        flags = '',
                        conditions = {
                            base_condition,
                            function()
                                local yaw_jitter = self:get(handle_index('yaw_jitter'))

                                return yaw_jitter == '3-way' or yaw_jitter == '5-way'
                            end,
                            function() return self:get(handle_index('body_yaw')) ~= 'custom jitter' end
                        }
                    }, { 'simple', 'manual' })

                    self:new('slider', {
                        index = handle_index('yaw_jitter_value'),
                        name = handle_name('yaw jitter value:'),
                        flags = '',
                        conditions = {
                            base_condition,
                            function()
                                local yaw_jitter = self:get(handle_index('yaw_jitter'))

                                if self:get(handle_index('body_yaw')) == 'custom jitter' then
                                    return true
                                end

                                if yaw_jitter == '3-way' or yaw_jitter == '5-way' then
                                    return self:get(handle_index('yaw_jitter:xway:mode')) == 'simple'
                                end

                                return yaw_jitter ~= 'Off'
                            end
                        }
                    }, -180, 180, 0)

                    self:new('slider', {
                        index = handle_index('xway:manual:value:1'),
                        name = handle_name('\n1'),
                        flags = '',
                        conditions = {
                            base_condition,
                            function()
                                local yaw_jitter = self:get(handle_index('yaw_jitter'))
                                local xway_mode = self:get(handle_index('yaw_jitter:xway:mode'))

                                return (yaw_jitter == '3-way' or yaw_jitter == '5-way') and xway_mode == 'manual'
                            end,
                            function() return self:get(handle_index('body_yaw')) ~= 'custom jitter' end
                        }
                    }, -180, 180, 0)

                    self:new('slider', {
                        index = handle_index('xway:manual:value:2'),
                        name = handle_name('\n2'),
                        flags = '',
                        conditions = {
                            base_condition,
                            function()
                                local yaw_jitter = self:get(handle_index('yaw_jitter'))
                                local xway_mode = self:get(handle_index('yaw_jitter:xway:mode'))

                                return (yaw_jitter == '3-way' or yaw_jitter == '5-way') and xway_mode == 'manual'
                            end,
                            function() return self:get(handle_index('body_yaw')) ~= 'custom jitter' end
                        }
                    }, -180, 180, 0)

                    self:new('slider', {
                        index = handle_index('xway:manual:value:3'),
                        name = handle_name('\n3'),
                        flags = '',
                        conditions = {
                            base_condition,
                            function()
                                local yaw_jitter = self:get(handle_index('yaw_jitter'))
                                local xway_mode = self:get(handle_index('yaw_jitter:xway:mode'))

                                return (yaw_jitter == '3-way' or yaw_jitter == '5-way') and xway_mode == 'manual'
                            end,
                            function() return self:get(handle_index('body_yaw')) ~= 'custom jitter' end
                        }
                    }, -180, 180, 0)

                    self:new('slider', {
                        index = handle_index('xway:manual:value:4'),
                        name = handle_name('\n4'),
                        flags = '',
                        conditions = {
                            base_condition,
                            function()
                                local yaw_jitter = self:get(handle_index('yaw_jitter'))
                                local xway_mode = self:get(handle_index('yaw_jitter:xway:mode'))

                                return yaw_jitter == '5-way' and xway_mode == 'manual'
                            end,
                            function() return self:get(handle_index('body_yaw')) ~= 'custom jitter' end
                        }
                    }, -180, 180, 0)

                    self:new('slider', {
                        index = handle_index('xway:manual:value:5'),
                        name = handle_name('\n5'),
                        flags = '',
                        conditions = {
                            base_condition,
                            function()
                                local yaw_jitter = self:get(handle_index('yaw_jitter'))
                                local xway_mode = self:get(handle_index('yaw_jitter:xway:mode'))

                                return yaw_jitter == '5-way' and xway_mode == 'manual'
                            end,
                            function() return self:get(handle_index('body_yaw')) ~= 'custom jitter' end
                        }
                    }, -180, 180, 0)

                    -- self:new('slider', {
                    --     index = handle_index('fake_limit'),
                    --     name = handle_name('fake limit:'),
                    --     flags = '',
                    --     conditions = {
                    --         base_condition,
                    --         function() return self:get(handle_index('body_yaw')) ~= 'Off' end
                    --     }
                    -- }, 0, 60, 60)
                end
            end

            self.builder.export_current_state = ui.new_button(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'export current state', function()
                local team = self.vars.teams[1]
                local condition = self:get('aa:builder:condition_selector')

                local curr_state = {}

                if self:contains('aa:builder:builder_options', 'team based') then
                    team = self:get('aa:builder:team_selector')

                    curr_state[#curr_state + 1] = self:get('aa:builder:team_selector')
                end

                curr_state[#curr_state + 1] = self:get('aa:builder:condition_selector')

                self.config_system:export(
                    true, false, false, (':builder:states:%s:%s:'):format(team, condition),
                    {
                        { 'Succesfully ' },
                        { 'exported', true },
                        { ' current state settings to clipboard [' },
                        { table.concat(curr_state, ' - '), true },
                        { ']' }
                    },
                    {
                        { 'Error while ' },
                        { 'exporting', true },
                        { ' current state settings' }
                    }
                )
            end)

            self.builder.import_current_state = ui.new_button(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'import to current state', function()
                local team = self.vars.teams[1]
                local condition = self:get('aa:builder:condition_selector')

                local curr_state = {}

                if self:contains('aa:builder:builder_options', 'team based') then
                    team = self:get('aa:builder:team_selector')

                    curr_state[#curr_state + 1] = self:get('aa:builder:team_selector')
                end

                curr_state[#curr_state + 1] = self:get('aa:builder:condition_selector')

                self.config_system:import(
                    clipboard.get(), (':builder:states:%s:%s:'):format(team, condition),
                    {
                        { 'Succesfully ' },
                        { 'imported', true },
                        { ' state settings to [' },
                        { table.concat(curr_state, ' - '), true },
                        { ']' }
                    },
                    {
                        { 'Error while ' },
                        { 'importing', true },
                        { ' state settings' }
                    }
                )
            end)


            self:new('multiselect', {
                index = 'additions:bind_selector',
                name = '[binds] - selector:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end
                }
            }, { 'legit anti-aim', 'freestand', 'manual anti-aim', 'breaker', 'force defensive', 'cross assistant', 'warmup anti-aim' })

            self:new('hotkey', {
                index = 'additions:binds:legitaa:key',
                name = '[~] - legit anti-aim',
                flags = '-',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end,
                    function() return self:contains('additions:bind_selector', 'legit anti-aim') end
                }
            }, false, 0x45)

            self:new('hotkey', {
                index = 'additions:binds:freestand:key',
                name = '[~] - freestand',
                flags = '-',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end,
                    function() return self:contains('additions:bind_selector', 'freestand') end
                }
            }, false)

            self:new('hotkey', {
                index = 'additions:binds:manual:key:left',
                name = '[~] - manual left',
                flags = '-',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end,
                    function() return self:contains('additions:bind_selector', 'manual anti-aim') end
                }
            }, false)

            self:new('hotkey', {
                index = 'additions:binds:manual:key:right',
                name = '[~] - manual right',
                flags = '-',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end,
                    function() return self:contains('additions:bind_selector', 'manual anti-aim') end
                }
            }, false)

            self:new('hotkey', {
                index = 'additions:binds:manual:key:forward',
                name = '[~] - manual forward',
                flags = '-',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end,
                    function() return self:contains('additions:bind_selector', 'manual anti-aim') end
                }
            }, false)

            self:new('hotkey', {
                index = 'additions:binds:manual:key:reset',
                name = '[~] - manual reset',
                flags = '-',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end,
                    function() return self:contains('additions:bind_selector', 'manual anti-aim') end
                }
            }, false)

            self:new('hotkey', {
                index = 'additions:binds:breaker:key',
                name = '[~] - breaker',
                flags = '-',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end,
                    function() return self:contains('additions:bind_selector', 'breaker') end
                }
            }, false)

            self:new('hotkey', {
                index = 'additions:binds:force_defensive:key',
                name = '[~] - force defensive',
                flags = '-',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end,
                    function() return self:contains('additions:bind_selector', 'force defensive') end
                }
            }, false)

            self:new('hotkey', {
                index = 'additions:binds:cross_assistant:key',
                name = '[~] - cross assistant',
                flags = '-',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end,
                    function() return self:contains('additions:bind_selector', 'cross assistant') end
                }
            }, false)

            self:new('hotkey', {
                index = 'additions:binds:automatic_peek:key',
                name = '[~] - automatic peek',
                flags = '-',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end,
                    function() return self:contains('additions:bind_selector', 'automatic peek') end
                }
            }, false)

            self:new('multiselect', {
                index = 'additions:binds:freestand:disablers',
                name = '[FREESTAND] - disablers:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end,
                    function() return self:contains('additions:bind_selector', 'freestand') end
                }
            }, { 'slowwalk', 'in air', 'crouch', 'move' })

            self:new('multiselect', {
                index = 'additions:binds:force_defensive:conditions',
                name = '[DEFENSIVE] - conditions:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end,
                    function() return self:contains('additions:bind_selector', 'force defensive') end
                }
            }, { 'stand', 'move', 'in air', 'quickpeeking' })

            self:new('combobox', {
                index = 'additions:binds:automatic_peek:target_mode',
                name = '[APEEK] - target mode:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end,
                    function() return self:contains('additions:bind_selector', 'automatic peek') end
                }
            }, { 'current threat', 'nearest to crosshair' })

            self:new('combobox', {
                index = 'additions:binds:automatic_peek:move_mode',
                name = '[APEEK] - move mode:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'additions' end,
                    function() return self:contains('additions:bind_selector', 'automatic peek') end
                }
            }, { 'Defensive', 'Offensive' })


            self:new('combobox', {
                index = 'visuals:notifier:prefix',
                name = '[vis] - notifier prefix:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'visuals' end
                }
            }, { 'text', 'icon' })

            -- self:new('multiselect', {
            --     index = 'visuals:notifier:style',
            --     name = '[vis] - notifier style:',
            --     flags = '',
            --     conditions = {
            --         function() return self:get('tab_selector') == 'visuals' end
            --     }
            -- }, { 'glow', 'gradient' })

            -- ui.set(self:get_element('visuals:notifier:style'), 'gradient')

            self:new('slider', {
                index = 'visuals:notifier:height',
                name = '[vis] - notifier height:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'visuals' end
                }
            }, 0, 400, 0, true, 'px')

            self:new('checkbox', {
                index = 'visuals:notifier:antibruteforce',
                name = '[vis] - notify antibruteforce',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'visuals' end
                }
            })

            self:new('multiselect', {
                index = 'visuals:popups:elements',
                name = '[vis] - popup elements:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'visuals' end
                }
            }, { 'defensive choking', 'slowdown warning' })

            self:new('checkbox', {
                index = 'visuals:popups:glow',
                name = '[vis] - popup glow',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'visuals' end
                }
            })

            self:new('checkbox', {
                index = 'visuals:watermark',
                name = '[vis] - watermark',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'visuals' end
                }
            })

            self:new('combobox', {
                index = 'visuals:indicators:style',
                name = '[vis] - center style:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'visuals' end
                }
            }, { '-', 'modern', 'new', 'test' })

            self:new('combobox', {
                index = 'visuals:indicators:font_style',
                name = '[center] - font style:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'visuals' end,
                    function() return self:get('visuals:indicators:style') ~= '-' end
                }
            }, { 'small', 'normal', 'bold' })

            self:new('slider', {
                index = 'visuals:indicators:height',
                name = '[center] - height:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'visuals' end,
                    function() return self:get('visuals:indicators:style') ~= '-' end
                }
            }, -100, 100, 25, true, 'px')

            self:new('checkbox', {
                index = 'visuals:indicators:glow',
                name = '[center] - glow',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'visuals' end,
                    function() return self:get('visuals:indicators:style') ~= '-' end
                }
            })

            self:new('combobox', {
                index = 'visuals:indicators:manual_arrows:style',
                name = '[arrows] - style',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'visuals' end
                }
            }, { '-', 'modern', 'default' })

            self:new('slider', {
                index = 'visuals:indicators:manual_arrows:padding',
                name = '[arrows] - padding',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'visuals' end,
                    function() return self:get('visuals:indicators:manual_arrows:style') ~= '-' end
                }
            }, -20, 100, 0, true, 'px')

            self:new('multiselect', {
                index = 'visuals:indicators:adjustments',
                name = '[vis] - adjustments',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'visuals' end
                }
            }, { 'move indicators on scope', 'move indicators on nade', 'move arrows on scope' })


            self:new('checkbox', {
                index = 'misc:cheat_revealer',
                name = '[misc] - cheat revealer',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'misc' end
                }
            })

            self:new('multiselect', {
                index = 'misc:aimbot_log',
                name = '[misc] - aimbot logs:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'misc' end
                }
            }, { 'notify', 'console' })

            self:new('multiselect', {
                index = 'misc:aimbot_log:types',
                name = '[logs] - types:',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'misc' end,
                    function() return #self:get('misc:aimbot_log') > 0 end
                }
            }, { 'hit', 'miss', 'utility', 'dormant' })

            self:new('multiselect', {
                index = 'misc:animation_breakers',
                name = '[misc] - animations',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'misc' end
                }
            }, { 'legs on ground', 'legs in air', 'pitch zero on land' })

            self:new('combobox', {
                index = 'misc:leg_breaker',
                name = '[misc] - leg breaker',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'misc' end,
                    function() return self:contains('misc:animation_breakers', 'legs on ground') end
                }
            }, { 'jitter', 'moonwalk' })

            self:new('checkbox', {
                index = 'misc:clantag',
                name = '[misc] - clantag',
                flags = '',
                conditions = {
                    function() return self:get('tab_selector') == 'misc' end
                }
            })

            self.configs_menu = {
                config_list = ui.new_listbox(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'configs', self.config_system.list),
                config_name = ui.new_textbox(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'name'),
                load_config = ui.new_button(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'load', function()
                    local item = ui.get(self.configs_menu.config_list)

                    self.config_system:load_config(item)
                end),
                save_config = ui.new_button(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'save', function()
                    local item = ui.get(self.configs_menu.config_list)

                    self.config_system:save_config(item)
                end),
                delete_config = ui.new_button(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'delete', function()
                    local item = ui.get(self.configs_menu.config_list)

                    self.config_system:delete_config(item)
                end),
                reset_config = ui.new_button(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'reset', function()
                    local item = ui.get(self.configs_menu.config_list)

                    self.config_system:reset_config(item)
                end),
                export_button = ui.new_button(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'export settings', function()
                    self.config_system:export(
                        true, false, false, nil,
                        {
                            { 'Succesfully ' },
                            { 'exported', true },
                            { ' settings to clipboard' }
                        },
                        {
                            { 'Error while ' },
                            { 'exporting', true },
                            { ' settings' }
                        }
                    )
                end),
                import_button = ui.new_button(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'import settings', function()
                    self.config_system:import(
                        clipboard.get(), nil,
                        {
                            { 'Succesfully ' },
                            { 'imported', true },
                            { ' settings from clipboard' }
                        },
                        {
                            { 'Error while ' },
                            { 'importing', true },
                            { ' settings' }
                        }
                    )
                end),
                export_hidden_button = ui.new_button(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'export settings as hidden', function()
                    self.config_system:export(
                        true, false, true, nil,
                        {
                            { 'Succesfully ' },
                            { 'exported', true },
                            { ' settings as ' },
                            { 'hidden', true },
                            { ' to clipboard' }
                        },
                        {
                            { 'Error while ' },
                            { 'exporting', true },
                            { ' settings as ' },
                            { 'hidden', true }
                        }
                    )
                end),
                toggle_autoload_config = ui.new_button(ctx.data.menu_dir[1], ctx.data.menu_dir[2], 'toggle to auto load', function()
                    local item = ui.get(self.configs_menu.config_list)

                    self.config_system:set_autoload(item)
                end)
            }

            self.other = {
                disable_dt_indicator = ui.new_checkbox('AA', 'Other', 'disable dt indicator'),
                debug_menu = nil,
                disable_custom_desync = nil,
                debug_freestand = nil,
                clear_database = nil,
                unhide_config = nil
            }

            if ctx.data.source or ctx.data.hidden_features then
                self.other.debug_menu = ui.new_checkbox('AA', 'Other', 'show skeet aa')
                self.other.disable_custom_desync = ui.new_checkbox('AA', 'Other', 'disable custom desync')
                self.other.debug_cheat_revealer = ui.new_checkbox('AA', 'Other', 'debug cheat revealer')
                -- self.other.clear_database = ui.new_button('AA', 'Other', 'clear database', function()
                --     database.write(ctx.data.database_key, nil)
                --     database.flush()
                -- end)
                self.other.unhide_config = ui.new_button('AA', 'Other', 'unhide config', function()
                    self.config_system.hidden_config = false
                end)
            end
        end,

        set_callbacks = function(self)
            local function antibruteforce_reset_events()
                local this = self.multiselects_values.antibruteforce_reset_events

                this['round start'] = self:contains('aa:antibruteforce:reset_events', 'round start')
                this['shooter death'] = self:contains('aa:antibruteforce:reset_events', 'shooter death')
                this['time'] = self:contains('aa:antibruteforce:reset_events', 'time')
            end

            antibruteforce_reset_events()
            self:add_callback('aa:antibruteforce:reset_events', antibruteforce_reset_events)

            local function bind_selector()
                local this = self.multiselects_values.bind_selector

                this['legit anti-aim'] = self:contains('additions:bind_selector', 'legit anti-aim')
                this['freestand'] = self:contains('additions:bind_selector', 'freestand')
                this['manual anti-aim'] = self:contains('additions:bind_selector', 'manual anti-aim')
                this['breaker'] = self:contains('additions:bind_selector', 'breaker')
                this['force defensive'] = self:contains('additions:bind_selector', 'force defensive')
                this['cross assistant'] = self:contains('additions:bind_selector', 'cross assistant')
                this['automatic peek'] = self:contains('additions:bind_selector', 'automatic peek')
                this['warmup anti-aim'] = self:contains('additions:bind_selector', 'warmup anti-aim')
            end

            bind_selector()
            self:add_callback('additions:bind_selector', bind_selector)

            local function binds_freestand_disablers()
                local this = self.multiselects_values.binds_freestand_disablers

                this['slowwalk'] = self:contains('additions:binds:freestand:disablers', 'slowwalk')
                this['in air'] = self:contains('additions:binds:freestand:disablers', 'in air')
                this['crouch'] = self:contains('additions:binds:freestand:disablers', 'crouch')
                this['move'] = self:contains('additions:binds:freestand:disablers', 'move')
            end

            binds_freestand_disablers()
            self:add_callback('additions:binds:freestand:disablers', binds_freestand_disablers)

            local function binds_force_defensive_conditions()
                local this = self.multiselects_values.binds_force_defensive_conditions

                this['stand'] = self:contains('additions:binds:force_defensive:conditions', 'stand')
                this['move'] = self:contains('additions:binds:force_defensive:conditions', 'move')
                this['in air'] = self:contains('additions:binds:force_defensive:conditions', 'in air')
                this['quickpeeking'] = self:contains('additions:binds:force_defensive:conditions', 'quickpeeking')
            end

            binds_force_defensive_conditions()
            self:add_callback('additions:binds:force_defensive:conditions', binds_force_defensive_conditions)

            local function popups_elements()
                local this = self.multiselects_values.popups_elements

                this['defensive choking'] = self:contains('visuals:popups:elements', 'defensive choking')
                this['slowdown warning'] = self:contains('visuals:popups:elements', 'slowdown warning')
            end

            popups_elements()
            self:add_callback('visuals:popups:elements', popups_elements)

            local function indicators_adjustments()
                local this = self.multiselects_values.indicators_adjustments

                this['move indicators on scope'] = self:contains('visuals:indicators:adjustments', 'move indicators on scope')
                this['move indicators on nade'] = self:contains('visuals:indicators:adjustments', 'move indicators on nade')
                this['move arrows on scope'] = self:contains('visuals:indicators:adjustments', 'move arrows on scope')
            end

            indicators_adjustments()
            self:add_callback('visuals:indicators:adjustments', indicators_adjustments)

            local function animation_breakers()
                local this = self.multiselects_values.animation_breakers

                this['legs on ground'] = self:contains('misc:animation_breakers', 'legs on ground')
                this['legs in air'] = self:contains('misc:animation_breakers', 'legs in air')
                this['pitch zero on land'] = self:contains('misc:animation_breakers', 'pitch zero on land')
            end

            animation_breakers()
            self:add_callback('misc:animation_breakers', animation_breakers)
        end,

        handle_configuring_label = LPH_JIT_MAX(function(self)
            local text = 'configuring: '

            if self:get('aa:builder:preview_selected_state') then
                text = 'previewing: '
            end

            local curr_state = {}

            local team_names = {
                ['terrorist'] = 'TT',
                ['counter terrorist'] = 'CT'
            }

            if self:contains('aa:builder:builder_options', 'team based') then
                curr_state[#curr_state + 1] = team_names[self:get('aa:builder:team_selector')]
            end

            curr_state[#curr_state + 1] = self:get('aa:builder:condition_selector')

            ui.set(self.builder.configuring_label, text .. table.concat(curr_state, ':'))
        end),

        handle_visibility = LPH_JIT_MAX(function(self)
            local tab = self:get('tab_selector')

            for i, item in pairs(self.builder) do
                if type(item) ~= 'table' then
                    ui.set_visible(
                        item,
                        tab == 'aa'
                        and self:get('aa:antiaim_preset') == 'configurator'
                        and not self.config_system.hidden_config
                        and not self.antibruteforce.visible
                    )
                end
            end

            for i, item in pairs(self.configs_menu) do
                ui.set_visible(item, tab == 'configs')
            end

            for i, item in pairs(self.hidden_cfg_warning) do
                ui.set_visible(item, self.config_system.hidden_config and tab == 'aa')
            end

            ui.set_visible(
                self.antibruteforce.buttons.antibruteforce,
                tab == 'aa'
                and not self.config_system.hidden_config
                and not self.antibruteforce.visible
                and self:get('aa:antiaim_preset') ~= 'dynamic'
            )
            ui.set_visible(
                self.antibruteforce.buttons.antiaim,
                tab == 'aa'
                and not self.config_system.hidden_config
                and self.antibruteforce.visible
                and self:get('aa:antiaim_preset') ~= 'dynamic'
            )

            if self:get('aa:antiaim_preset') == 'dynamic' then
                self.antibruteforce.visible = false
            end

            ui.set_visible(ref.leg_movement, not self:contains('misc:animation_breakers', 'legs on ground'))
        end),

        handle_skeet_menu = LPH_JIT_MAX(function(self, show)
            for i = 1, #ref.antiaim_refs.main do
                ui.set_visible(ref.antiaim_refs.main[i], show)
            end

            for key, item in pairs(ref.antiaim_refs.other) do
                ui.set_visible(item, show)
            end
        end),

        reset_antiaim = function(self)
            local values = { 0, 'Off', 0, 'Off', 0, false, 0 }

            for i = 1, #ref.antiaim_refs.main do
                ui.set(ref.antiaim_refs.main[i], values[i])
            end

            ui.set(ref.antiaim_refs.other.pitch_mode, 'Off')
            ui.set(ref.antiaim_refs.other.pitch_value, 0)
            ui.set(ref.antiaim_refs.other.yaw_base, 'Local view')
            ui.set(ref.antiaim_refs.other.yaw, 'Off')
            ui.set(ref.antiaim_refs.other.roll, 0)
        end
    }

    :struct 'config_system' {
        list = { '\aA9A95FFFdefault config' },
        code = 'l29W5AU6JX1CEVIjmNFZM4xv+twdQsHLBrYG3S7h/zkPpbyoaneKqcDR)Tigf0u8',
        hidden_config = false,
        hidden_name = ':hidden_config:',
        selected_item = 0,
        autoload_item = false,
        last_config = nil,
        configs = {},

        get_configs = function(self)
            self.configs.blank = self:export_raw(false, true)
            self.last_config = self.configs.blank

            -- http.get('https://pastebin.com/raw/pB7wU9j4', function(s, r)
            --     if s and r.status == 200 then
            --         self.configs.default = r.body
            --     end
            -- end)

            self.configs.default = [[+RplJBlilUBlwm23lUmltm2ylAfl+a2olU)ltB2zlUQlIBl2lx+l+m2pl6Eltmlpl9JlAmAql6mlwm2ylUQlQal2lml2+m2rlW/l+B2clU3ldllUlvJlIB2Kl6ml+m2qlUMlQalil9f2QB2elUflQB2zl9a2IB2GlWM2sm2GlUBlIB2)l6Ql+m2TlW/ldm2rlU)lsmlZlZ/lsBlZlvMltmlilWMllm5al2Q2JB53lF+21lASl9/2Cl5ylZl2EBAtlZM2Va5TlvEldl2ol6QlmBAplUplIB2TlU5lsa2LlU/lwmlwl432va2ElxalZBAFlNQ2sBl)lM32Al5il2a2tl2zlUElCB5DlZ52wl2Sll)2wl2qll52EBlclAm2Ja5SlFQ21m5PlFq2Ca5nlm/2sm2ylWE2JllKlxl2IlAqlW/2jl5ulx/2dlAylvl2Ea52lFJlZa27lU+lJB9Vl4+23lAtltJ2vlU4lxflSaUtltp2VBUslZ/l5BAPlUMldl2rllf2mmAWlMM2NaAglMp2ZmAjlZ5lsa5YlAM2GaA+l4/23aAsldQ2+mUHlx5lwm2el9llIaUqlw52amA5lM+2FlA1lvm2ZB5ilE32IB2ZlQp2GBAvlt52xaUMlZ/2blU+l4327BALldB2Im6tlZq2jaAPlxq2VaAhlJB2Qa66lQ/2Kl6zldl2ia6NlLJ2qa5Plxm2tB5Zlx32Rl6Wlsf2dlWUlvM2Za5eljf2ilUolQf2pBAHlZm2faUHlLM2/m6)lwm2Qm5klma9dm2oll+2zaAKlU3ldm2alUaltm9plHQ2PB6Ild52glUxlHf2ca6Fld326mX/l9llXlXDl5f2JaC5lHl2na6GlNm9ElCklsl2Em5Rlom2/l58lZf9WBJmlyJ2Tl67lml9ABJelSq2Vl1DlmM9ymUgldq2oaUYlxq2da5rl3l2mB6slFM9CmJmlFB91BJplY)9MaJnlBE9FlXtl7J2CmAylUmlIBAcl9a2da2bl9l9EaALl9m9XBJmlvq9tmlBlE32Pm6VlM+9UlXXlra9FaXYlpJ2RB6AlH52Za5Kl5m9rmJ9l3Q9gmUclLl2Yl1nlvE9vBXilS32zaUzlwp2rlJ2lrQ9EaCyl4B9UBJUlGa9jBXGlBq9GBX9lz59TmUYlSm9dB1xlGM9fmU/lGB9YBXVlk)95mJilWml3B1GlSM9da1)l3/9DB5ilk/9hlJpl7+lslW0lN59al1KlzM94a1+lhl9hB6JlPp9mm10lS52pmJolzE9zlJ5lpm9cl6xl+p9RmAllBf9GaJil2E9DaXpl/+9zm1vlG+9cl1ilx5lolUulQl2Pl1VlbB9)BU8ly/9AmXblzM97mCxlo+9TmXjlrJ9KaC0l/Q9flXdlom9smXRlh39+lXgl/l9zaUll/J9CBXTlvElHa5nlv)2BlU9lvJlEmA7llp2KlJplv3lwBXhl3+2dl2plUp98lCplS+9zBCZlyl9IBW4lsQ2ImJ3lFM9Hm2LljB2ha1klFBWNm1MlrB9qBColY)WxaUdl7JlVlEDlDa2IlIrlba9am1qlof9dal0lza95lVhlY391aJblPJ92Bjplt39ElVjlDM9XaXFlD/9PmA6lNp2+B2el6MlCa5HlRJl+a2jlxB9MaEill)WplAalUBl+ml4lZ52Vl9Ql7qWQBlAle/Waa1Qlv59NaAqlrf9MlE+l4qW4lVXl0l9jmEplKfWHajrlYJ9lmVIlyQ9MmXMlxElwlI+lm32da23lvQWIB2dlW5lVBlel9alEml)lW+lCllelW5lGlUClZMlvm24lR3Wbm1hl/3WCajYlhfWxaVNlD39BajPlGaWgm1Dlz39EBVWlDmlVmERlnl2/lJil0q9aB1kleqWPlEal0B2YBJLlh+W)aXAldlWBmIelflWFBjulol9EBjvly+9mBCzlSJ91mIclepWgB1RlkaWel1olR)9KBVZl0lWrmIDlipWUa1LlQ+9IaXVlqf2emISldl2JaCVlD/WvBI5lc+WRa1plKJW)mV7lyEW0mE4lnQWIB2ylUflUa5Vlx)WQB2Sllq2Hl9hlFf2Hl9XlvB2HB5ZlZ52lBm52U3lplABlD3l+BV3laB5VBA/la52sl2Gln+20BIzlK)WRBjzlK39glVIl0MWlaIulhBWDaVilu3WnBjiliE2eBjeluJW0lIKl0/WRBJo2139gmEClRmlHl1slhJlLlCVlnJWBaJY29)5aaIJlKl5cB66lf+9smjalTQWkl5TliBWFlm32CBWFaJ/2I)WEaNm2Eq9sB6glGpWIBmtlbfWjmmk2IQ9uBC7lLfW5mmil6llda2al6MlQllnldq2tm2bllQ2sllLltBWJBlUlx+l2a5/lGq9DlA/lUflwalQlxQlCBXGlxM2tl2Slx)lJl29lvJldB9W29JlzaEolrQ5UmNSlna5ZaASlWq97lAR26plLm2LlTB2UlNGlTM5taVzl)JWKljYlR+WTmjRlKp5ym5ll)a9lBIIleq5+mN+luJ9+a2DlGf5WmVQ2JlWNmFz29E5raES2l+99mVslopWvljjlcm5pBZalS3W6a1jlP55aBVx2jl9mmVql7M5PaCE25pWKaNelb55GlIflSl9clZFle)WamZclk)5Gmjvl0a5rBjslT39rBmXl7B2eajRlb+WDmC32IQWnljzlulWxamrl3QWolN42C)5TaZv2Ip5PaN9l/fWJB2z26a2UmI2lZf56lIFlFJW8lIll/q5CBXblWB2+alil9a9ta2LlUJWtmWelz)95lU/2E+5aBVv2IpWfaNbl+lWVaZR2EQ5RBmx2m/WgaErlSq5tBCtlDl5KmZT2Ef59lXhlmp9DmZ)lpB2gaZQlgQWelNE2VmWEavb2j39VBxP2EM90BAj2jM5oBVZ2XJ5haFM22p5/amillQ2+m2Yl9EW5B5MlF55blEG2QMW)BCF2I)5vaZ2l0M5mlEa2m/9jBNl26+WmaZYlgp5UBxqlp)5CBEh22)AmmZD2U+AqmJy2MlWuaN+2Z)AxBvNluM5IlMylf350lF7lMMAFlVM2NpA9lES24q9QaMc2vMATBER2HBW2BXk2Zq5aaFnlumWdB4R2+3AymXI22f9eBCElpp5rBxk2UJ5imjm25EAEa6P2jEWBBEY2FqATBF22LE9BaMf2Fp5DlIm2Ll5FBF124B5PmZ3lyJ5om1P2MQ5+mN/2xE51mFz2HQ9bm4824aAumIa2Zq5bmmElq55+aMX2xM95aIp2LBWXBZJliE2SBMz2ZfA7aMUlG55yB1g2HE5DaJ22NJ5laNzllM5Ka5J2Fl2hmFD2wmAHlxT24/5umU6ltQA8BUt2dq5zm4T2Z/Acmvr2V/52ljdlBqAQalj2MQ21mJylx3l9a5Z2mQ5ABMQlulAeBxKlHqAPljL2WEWyaVAlRQldm462x5W/mN12xBWIBl62232va9+26M57aZr2d)ARmNx2Z5Wflxe2LJAClZP2LB52lwQ24)AiBFilgaWNBV02wEAoavE2M)5rlMB2YpAxaMw2YmUtm5n2La5pavYls/9MBJAlvl2ua4ylW52+B2ulNqWSBNLl6/5LlNzl5)W9BAKlGqU9aAR2AplJBlQlFllElIm2lJUFmF82XEAmBMo2PMA0mMj2xEloBU+ldf26BmB2AMUTamS2732eBZk2Z5UsB4vlefAVmtL2FQU9mdm2sBA5lm92MpU2lxWlFfWtl2klC+5slFw2l52ZawklYlllaMdlRElJllClFll0B4b2JEWBmwW2BMArmw627)l+ml7lrQ2Bmtrl2/9sa9j2//5Ymtal9q93mmt2BQWXlxh2mf2Qlw0lcJ5LBMT2IEA3B422sp2cB4t2x/Ura4l2t)22Bw32kE27lxo2z/Atmty2y/5CawalPQUglv32ZmUimNzlQEAbaZA2d/5el4U2XfUdltz2Q5AZBEh2tfAVmZfle5AWamxlD/5mB5KlM+2QB2PlUJUZBA42PBAimEU2YfUIBt32G3A1BUq2B/U1BdH2hlA2mw92mf2nltr2d35NlZJ2YpUEawo2NqAjmZh2BpUeBwJ2L55jlZI2hpAfmjDlk5AnmZY2FaU8BwPlo5AVlMilCqUTl+ylDpAklZz2BM6daMG2o+U0BAt2lQU1ld/2k+UIBIZ2l)UtBEm2GQ5EB1llZ/l2B5olxElJlE5lx+9MmM4lmq6alvR2ofUvaXm2j/Ukl+U2g32xmIf2of2jl+dlMqUXlA92P/22amalLp5LaAKl5)AClJl2hB5ilmn2F)9MmtZ2z)UVlQZ2flUqaxylal6YaIElBE6GaME2kl5UBmL2im5pBVplcl5zBZflD5ltlV)lo/A+aWq2z5A8m+D2cE6dmUD2y/UAls+2G)2AaLY2b5ARa+Ul336vaM)2e5U4m4C22aUSlxGlFlA/B4o2c56was42n)U9BH02Mf6wmHy24/9gmwQl7)65BHC2cQUIm5R2iqUslxu23B5paZ723mWwldIlhp6kmtk2ipU0aAM2ilAVBF92T56PmxZ2)39CaL72vJU7lHR2HpUCm+x2DpAuB6fltl6ua+W2/m6/BQv2TMA9lZz2t)6PaHB2)a6LlIdlpfUQBUR2)/6eawplRB6iBZU2c55oaEb2Rq6hBM22c+6zBQ52gB64BwtlB+U6a1c2gf6vBmP2dpW3m+V2LQAFlMH2T+5Zlxt26+5La+YljMA6a5vlmE2YmAI2eaAVmQTlsp6bmtz2/E6kBw1lqq5mBx02fp9PBLT2i56hBUs2Q)6zmLF2kQ6DlsElg/A9mQ02Mf2)aw/28aUaaLg2KJ5EmQ/2QB6faLc2ka5GlvR2fl6hBmV2Sp6TaQr2f/WdaVnlcq2EmWZ2TQWamsh2d562asB2dB51lv62B+2emMm9C36uBHblR)68mQQ9Vf6qmsF2KBJ/m6T2r56DlsD2R56Zl1x2)MA1Brm2K+Jxmjh2BlJVlGF2d32Klsh2p)AoBsV95JJClYA28a66B1Glsq64mGX2fpAsase2M+JilCN2L/5LmE/9WE6UlYB2yMAUlQX27BJEBwF2g3UaB+/9l+JnlN+2c+JQlL520B5WlYk2Q/2Dm40lv+Url+ilUQl9lCQ2SEAvBBc9lJJKlEa2cqJwmYz20/6GBLu20)61BM292JJYBBJ2)Q6WmBa2zmJkBQR9A3JjaAE92QJdaYI9V+5tBYB9jB6ZBYj91JUQaGN2hMJ0mV4lNq6JlrC2vmlHm9Q2kqJpaEi2K)Umltul4flAm5plYQ6VB6P2n5AQlAF2zf5CmW4lxqlCBX7l5l6qlmE2HM9nlBdlQ+J1mJylrmA8avX9X+5Jl2U2GfUFlwWl032Qa9A2h5W1lX2la)5eaA32q+2UaAGl9llhltSlVpUfBHY9AfJMlGg2E)6GlGy9JBJSmBelufUCaBjl8JUEBGX2/QJZaYY2Ta9vlBv9ClJ/BmB2iM5JaralRJWCaE3lPM2lm5nlXpJ7BQ/9jEJwado9Xm6dlsp2M5J8BBQ2dE6UaB496p9/mBM9LMJhlrN9Jf6zarR9C/6laGn9W/J3aY/9VEWKmwv91q99BQj9l3JzB4QlBf23mBZ9dlU8aYP2naXYaBB9Z/XQmBD2YfU8amh9M/JAa399F+XUB739EM6xaG/2Z3XyltC9v/J7lBP2WEXylBf2q5UQaJnlxE6baN72cfliBrzlFq2QB2hlUMlKl1llgM5VlAc2X/2wlWu2HEJVl3I2nqXnmM894lXQm4796/6Flra9WMXXB4M2qfXkmEd9vJ6pmMn9t3Jtamf9JM6lmSI9vJXoa+D9lmJMaG82)BXJB+/9mQ9yBtzlw+J6mBb9QaUPlQR2rfUYmQoluM6pmBU94)69l3S9W52EB2h9Xf61ar)9VM9QlSY2+)XTBwGlSfldmmg2KfUlmwx9Qp6uaFM9ZpJZBrW92+XrBH29Fp5WlHT94QJ0mHI2R+Xrl7g9t)Jzm3d2fMXjlS89xm5+BY89x)XUa+F9waXaBHQ95pJhlQz2p3Xal7/9t5XQBBo2/EXblhF2KBXqa7h9tlXAlGU2d+JwlHG96mX7aXq2i+XUmYg2fB9ba3p9slXLmL69LBJnBdg9J598mYV92MXlar72/+XuaUF96M6amhu9tJXemXM9IEXga71lT3X9BLL9MMXYmGM2F)U+BBK9FE22l3j23f25Bt39NmUimsJlY39tBJqlE/XRl3D2/qA8mE)2jaXJBS29v36+BYd9LmJIa3R9la17mr59L)JyB3A9hJJRlH69M3XXaPt28l9fmhv9N/6qlLB9ZqJnahe9lEXhm3A94q6waIr9m/XEa9S9vQXiB7c9x+JXlPZ2351MlG89mMJPlYI2w)JEa/59y/WmBve9mE1Da309BBUhmH)9LmXAmQ89W)1dBBr9Zp1Sa309Mf2vaPy9x/JpBsw9Uq6Im/b9Gm1SBBa9Yp5EB/i9hB1Yahh2m51Ll7t2Ka1kBSB2cB1XmPz9N5Jcm7q2C+5fl+a9j3XEar79r/JZBVa93)18mSs9paX9arZ9dl5Qmzj9hE1/aQH9QQ6sBzP97MJglSY9l)1AmzU9rQ11a569xl6XlB19ZMlZm/r9r51ImYl9P+6/azl9HMUma/P9xmJMmSp91MUmlzu9JqUHldp2AflSB+cltBUrmBm9HMU2akV9Z31NB5plvJ2Qa2Rl6l2jB619Sm1nBh79QfA9mz)9xq1slk99Pl6Da7s2LQX+BMn9j/XYm//97qUVBkl2cQ6xB/i9z/6na749PE1gaMF9hpJTaCj94p1DahD2i51KasU2tJ1flSa9MBXSm3j9zMJblkp2o+18BF09k5UVBhJ9Ml18ake2pEXKB319uaUkBBR9/51RlkH9GqJHBPhlrm1gazT9QJ5glPx2R+JFBhH9zfJjBPB9bmXflPR9Jq1umrelH+13m/39cl1ZlSblsp1Im/v2EQJvB3t9/325l6r2D5l)aL/97a1CBsy9Y)JulS32LEUJmzP2ZMClaoT9yMXCa3d90E50lMI2wqWdm2Wlfa9tlU526B55aZQ2v3l4ld+9GM1VBtl9V3XWaonlk/JRB3Z9ulU5mpJ9i)Ufa/u95MJwBpT27QC+lrN9Pa1hmkv9Pm6IlzC9n)CXmb59uM13lPg9vQ1vl/39Mm1ylkw2vB1FmpJ9/mCYm3m9om1bmPh9431XBkl98/1GBLe9S)CJB/k97fCZaU/9hq1Bmbx9Sm6wB/i9vB1Iax+9ap6+lkm9m+CdByd9SlCSBkn2zB1/lzn9x3ULm20ll==]]
        end,

        set_callbacks = function(self)
            self.selected_item = ui.get(self.menu.configs_menu.config_list)

            if self.list[self.selected_item + 1] then
                ui.set(self.menu.configs_menu.config_name, self.list[self.selected_item + 1])
            end

            ui.set_callback(self.menu.configs_menu.config_list, function(ref)
                local selected_item = ui.get(ref)
                self.selected_item = selected_item

                if self.list[selected_item + 1] then
                    ui.set(self.menu.configs_menu.config_name, self.list[selected_item + 1])
                end
            end)
        end,

        encode = function(self, data)
            return ((data:gsub('.', function(x)
                local r, b = '', x:byte()
                for i = 8, 1, -1 do r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0') end
                return r;
            end) ..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
                if (#x < 6) then return '' end
                local c = 0
                for i = 1, 6 do c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0) end
                return self.code:sub(c + 1, c + 1)
            end) .. ({ '', '==', '=' })[ #data % 3 + 1 ])
        end,

        decode = function(self, data)
            data = string.gsub(data, '[^'.. self.code ..'=]', '')
            return (data:gsub('.', function(x)
                if (x == '=') then return '' end
                local r, f = '', (self.code:find(x) - 1)
                for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0') end
                return r;
            end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
                if (#x ~= 8) then return '' end
                local c = 0
                for i = 1, 8 do c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0) end
                return string.char(c)
            end))
        end,

        export_raw = function(self, to_clipboard, return_settings, hidden, search)
            local new_table = {
                settings = {}
            }

            if search and search ~= '' and type(search) == 'string' then
                for k, v in pairs(self.menu.list) do
                    if string.find(k, search) then
                        if v.flags == '-' then
                            goto skip
                        elseif v.flags == 'c' then
                            new_table.settings[k] = { ui.get(self.menu.list[k].element) }
                        else
                            new_table.settings[k] = ui.get(self.menu.list[k].element)
                        end

                        ::skip::
                    end
                end
            else
                new_table[self.hidden_name] = hidden and true or false

                for k, v in pairs(self.menu.list) do
                    if v.flags == '-' then
                        goto skip
                    elseif v.flags == 'c' then
                        new_table.settings[k] = { ui.get(self.menu.list[k].element) }
                    else
                        new_table.settings[k] = ui.get(self.menu.list[k].element)
                    end

                    ::skip::
                end
            end

            local settings_final = self:encode(string_compression.compress(json.stringify(new_table)))

            if to_clipboard then
                clipboard.set(settings_final)
            end

            if return_settings then
                return settings_final
            end
        end,

        import_raw = function(self, config, search)
            local data = json.parse(string_compression.decompress(self:decode(config)))

            local skipped_elements = 0

            if search and search ~= '' and type(search) == 'string' then
                for item, value in pairs(self.menu.list) do
                    if string.find(item, search) then
                        for k, v in pairs(data.settings) do
                            local data_strings = {}

                            for str in string.gmatch(k, '([^:]+)') do
                                data_strings[#data_strings + 1] = string.gsub(str, '\n', '')
                            end

                            local list_strings = {}

                            for str in string.gmatch(item, '([^:]+)') do
                                list_strings[#list_strings + 1] = string.gsub(str, '\n', '')
                            end

                            if list_strings[#list_strings] == data_strings[#data_strings] then
                                if self.menu.list[item].flags == 'c' then
                                    ui.set(self.menu:get_element(item), v[1], v[2], v[3], v[4])
                                else
                                    ui.set(self.menu:get_element(item), v)
                                end
                            end
                        end
                    end
                end
            else
                local sum = 0

                for item, value in pairs(data.settings) do
                    sum = sum + 1

                    if not self.menu.list[item] then
                        skipped_elements = skipped_elements + 1
                        goto skip
                    end

                    if self.menu.list[item].flags == 'c' then
                        ui.set(self.menu:get_element(item), value[1], value[2], value[3], value[4])
                    else
                        ui.set(self.menu:get_element(item), value)
                    end

                    ::skip::
                end

                if skipped_elements == 0 and sum == self.menu.values.config_elements then
                    self.hidden_config = data[self.hidden_name]
                end
            end

            if skipped_elements > 0 then
                return skipped_elements
            end
        end,

        export = function(self, to_clipboard, return_settings, hidden, find, text, error_text)
            if not hidden and self.hidden_config then
                self.handlers:handle_error({
                    { 'You can\'t export ' },
                    { 'hidden', true },
                    { ' settings as not ' },
                    { 'hidden', true }
                })
                return
            end

            local status, returned_value = pcall(self.export_raw, self, to_clipboard, return_settings, hidden, find)

            text = text or { { '' } }
            error_text = error_text or { { '' } }

            if status then
                self.notifier:add({
                    time = self.notifier.time.long,
                    text = text,
                    icon = 'export'
                })

                self.handlers:console_message(self.menu.colors.accent, text)

                if return_settings then
                    return returned_value
                end
            else
                self.handlers:handle_error(error_text, 'export')
            end
        end,

        import = function(self, config, find, text, error_text)
            local status, error = pcall(self.import_raw, self, config, find)

            text = text or { { '' } }
            error_text = error_text or { { '' } }

            if status then
                self.notifier:add({
                    time = self.notifier.time.long,
                    text = text,
                    icon = 'import'
                })

                self.handlers:console_message(self.menu.colors.accent, text)
            else
                self.handlers:handle_error(error_text, 'import')
            end
        end,

        set_autoload = function(self, item)
            if type(item) ~= 'number' then
                self.handlers:handle_error({
                    { 'You didn\'t ' },
                    { 'select', true },
                    { ' any config' }
                })

                return
            end

            item = item + 1

            local name = self.config_system.list[item]

            if self.autoload_item == item - 1 then
                local protected = function()
                    self.autoload_item = false

                    for i = 1, #self.list do
                        self.list[i] = string.gsub(self.list[i], '* ', '')
                    end

                    ui.update(self.menu.configs_menu.config_list, self.list)
                    ui.set(self.menu.configs_menu.config_name, self.list[item])
                end

                local status, error = pcall(protected)

                if status then
                    local message = {
                        { 'Succesfully ' },
                        { 'unset', true },
                        { ' config [' },
                        { name, true },
                        { '] as ' },
                        { 'auto load', true }
                    }

                    self.notifier:add({
                        time = self.notifier.time.long,
                        text = message
                    })

                    self.handlers:console_message(self.menu.colors.accent, message)
                else
                    local message = {
                        { 'Error while ' },
                        { 'unsetting', true },
                        { ' config [' },
                        { name, true },
                        { '] as ' },
                        { 'auto load', true }
                    }

                    self.handlers:handle_error(message)
                end

                return
            end

            local protected = function()
                self.autoload_item = item - 1

                for i = 1, #self.list do
                    self.list[i] = string.gsub(self.list[i], '* ', '')
                end

                self.list[item] = '* '.. self.list[item]

                ui.update(self.menu.configs_menu.config_list, self.list)
                ui.set(self.menu.configs_menu.config_name, self.list[item])
            end

            local status, error = pcall(protected)

            if status then
                local message = {
                    { 'Succesfully ' },
                    { 'set', true },
                    { ' config [' },
                    { name, true },
                    { '] as ' },
                    { 'auto load', true }
                }

                self.notifier:add({
                    time = self.notifier.time.long,
                    text = message
                })

                self.handlers:console_message(self.menu.colors.accent, message)
            else
                local message = {
                    { 'Error while ' },
                    { 'setting', true },
                    { ' config [' },
                    { name, true },
                    { '] as ' },
                    { 'auto load', true }
                }

                self.handlers:handle_error(message)
            end
        end,

        save_config = function(self, item)
            if type(item) ~= 'number' then
                self.handlers:handle_error({
                    { 'You didn\'t ' },
                    { 'select', true },
                    { ' any config' }
                })

                return
            end

            item = item + 1

            local name = ui.get(self.menu.configs_menu.config_name)

            if not table.contains(self.list, name) then
                if name == '' then
                    self.handlers:handle_error({
                        { 'You can\'t create ' },
                        { 'unnamed', true },
                        { ' config' }
                    })

                    return
                end

                local protected = function()
                    ctx.data.database.configs[#self.list + 1] = self:export_raw(false, true, self.hidden_config)

                    table.insert(self.list, name)
                    ui.update(self.menu.configs_menu.config_list, self.list)
                    ui.set(self.menu.configs_menu.config_list, item)
                end

                local status, error = pcall(protected)

                if status then
                    local message = {
                        { 'Succesfully ' },
                        { 'created', true },
                        { ' config [' },
                        { name, true },
                        { ']' }
                    }

                    self.notifier:add({
                        time = self.notifier.time.long,
                        text = message
                    })

                    self.handlers:console_message(self.menu.colors.accent, message)
                else
                    local message = {
                        { 'Error while ' },
                        { 'creating', true },
                        { ' config [' },
                        { name, true },
                        { ']' }
                    }

                    self.handlers:handle_error(message)
                end

                return
            end

            if not self.list[item] then
                self.handlers:handle_error({
                    { 'You didn\'t ' },
                    { 'select', true },
                    { ' any config' }
                })

                return
            end

            if item == 1 then
                self.handlers:handle_error({
                    { 'You can\'t ' },
                    { 'override', true },
                    { ' default config' }
                })

                return
            end

            local name = self.list[item]

            local protected = function()
                ctx.data.database.configs[item] = self:export_raw(false, true, self.hidden_config)
            end

            local status, error = pcall(protected)

            if status then
                local message = {
                    { 'Succesfully ' },
                    { 'saved', true },
                    { ' config [' },
                    { name, true },
                    { ']' }
                }

                self.notifier:add({
                    time = self.notifier.time.long,
                    text = message
                })

                self.handlers:console_message(self.menu.colors.accent, message)
            else
                local message = {
                    { 'Error while ' },
                    { 'saving', true },
                    { ' config [' },
                    { name, true },
                    { ']' }
                }

                self.handlers:handle_error(message)
            end
        end,

        load_config = function(self, item, autoload)
            if type(item) ~= 'number' then
                self.handlers:handle_error({
                    { 'You didn\'t ' },
                    { 'select', true },
                    { ' any config' }
                })

                return
            end

            item = item + 1

            if not self.list[item] then
                self.handlers:handle_error({
                    { 'You didn\'t ' },
                    { 'select', true },
                    { ' any config' }
                })

                return
            end

            local config = ctx.data.database.configs[item]

            local name = self.list[item]

            if item == 1 then
                if autoload then
                    local message = {
                        text = {
                            { 'Succesfully ' },
                            { 'loaded', true },
                            { ' your ' },
                            { 'auto load', true },
                            { ' config [' },
                            { 'default config', true },
                            { ']' }
                        },
                        error_text = {
                            { 'Error while ' },
                            { 'loading', true },
                            { ' your ' },
                            { 'auto load', true },
                            { ' config [' },
                            { 'default config', true },
                            { ']' }
                        }
                    }

                    self:import(self.configs.default, nil, message.text, message.error_text)

                    return
                end

                local message = {
                    text = {
                        { 'Succesfully ' },
                        { 'loaded', true },
                        { ' default settings' }
                    },
                    error_text = {
                        { 'Error while ' },
                        { 'loading', true },
                        { ' default settings' }
                    }
                }

                self:import(self.configs.default, nil, message.text, message.error_text)

                return
            end

            if not config or config == '' then
                self.handlers:handle_error({
                    { 'This config [' },
                    { name, true },
                    { '] is ' },
                    { 'blank', true }
                })

                return
            end

            local protected = function()
                self:import_raw(config)

                if autoload then
                    ui.set(self.menu.configs_menu.config_list, item - 1)
                end
            end

            local status, error = pcall(protected)

            if status then
                local message = {
                    { 'Succesfully ' },
                    { 'loaded', true },
                    { ' config [' },
                    { name, true },
                    { ']' }
                }

                if autoload then
                    message = {
                        { 'Succesfully ' },
                        { 'loaded', true },
                        { ' your ' },
                        { 'auto load', true },
                        { ' config [' },
                        { name, true },
                        { ']' }
                    }
                end

                self.notifier:add({
                    time = self.notifier.time.long,
                    text = message
                })

                self.handlers:console_message(self.menu.colors.accent, message)
            else
                local message = {
                    { 'Error while ' },
                    { 'loading', true },
                    { ' config [' },
                    { name, true },
                    { ']' }
                }

                if autoload then
                    message = {
                        { 'Error while ' },
                        { 'loading', true },
                        { ' your ' },
                        { 'auto load', true },
                        { ' config [' },
                        { name, true },
                        { ']' }
                    }
                end

                self.handlers:handle_error(message)
            end
        end,

        delete_config = function(self, item)
            if type(item) ~= 'number' then
                self.handlers:handle_error({
                    { 'You didn\'t ' },
                    { 'select', true },
                    { ' any config' }
                })

                return
            end

            item = item + 1

            if not self.list[item] then
                self.handlers:handle_error({
                    { 'You didn\'t ' },
                    { 'select', true },
                    { ' any config' }
                })

                return
            end

            if item == 1 then
                self.handlers:handle_error({
                    { 'You can\'t ' },
                    { 'delete', true },
                    { ' default config' }
                })

                return
            end

            local name = self.list[item]

            local protected = function()
                ctx.data.database.configs[item] = nil

                table.remove(self.list, item)
                ui.update(self.menu.configs_menu.config_list, self.list)
                ui.set(self.menu.configs_menu.config_list, item - 2)

                if self.autoload_item == item - 1 then
                    self.autoload_item = false
                end
            end

            local status, error = pcall(protected)

            if status then
                local message = {
                    { 'Succesfully ' },
                    { 'deleted', true },
                    { ' config [' },
                    { name, true },
                    { ']' }
                }

                self.notifier:add({
                    time = self.notifier.time.long,
                    text = message
                })

                self.handlers:console_message(self.menu.colors.accent, message)
            else
                local message = {
                    { 'Error while ' },
                    { 'deleting', true },
                    { ' config [' },
                    { name, true },
                    { ']' }
                }

                self.handlers:handle_error(message)
            end
        end,

        reset_config = function(self, item)
            if type(item) ~= 'number' then
                self.handlers:handle_error({
                    { 'You didn\'t ' },
                    { 'select', true },
                    { ' any config' }
                })

                return
            end

            item = item + 1

            if not self.list[item] then
                self.handlers:handle_error({
                    { 'You didn\'t ' },
                    { 'select', true },
                    { ' any config' }
                })

                return
            end

            if item == 1 then
                self.handlers:handle_error({
                    { 'You can\'t ' },
                    { 'reset', true },
                    { ' default config' }
                })

                return
            end

            local name = self.list[item]

            local protected = function()
                ctx.data.database.configs[item] = self.configs.blank

                self:import_raw(self.configs.blank)
            end

            local status, error = pcall(protected)

            if status then
                local message = {
                    { 'Succesfully ' },
                    { 'reset', true },
                    { ' config [' },
                    { name, true },
                    { ']' }
                }

                self.notifier:add({
                    time = self.notifier.time.long,
                    text = message
                })

                self.handlers:console_message(self.menu.colors.accent, message)
            else
                local message = {
                    { 'Error while ' },
                    { 'resetting', true },
                    { ' config [' },
                    { name, true },
                    { ']' }
                }

                self.handlers:handle_error(message)
            end
        end
    }

    :struct 'antibruteforce' {
        queue = {
            hit = {},
            missed = {}
        },
        data = {},
        all_stored_shots = {
            all = 0,
            hit = 0,
            overall_hits = 0,
            missed = 0,
            headshots = 0
        },
        cache = {
            backtrack = {
                pos = nil,
                state = nil
            },
            last_backtrack_ticks = 0
        },
        nonweapons = {
            'knife',
            'hegrenade',
            'inferno',
            'flashbang',
            'decoy',
            'smokegrenade',
            'taser'
        },
        values = {
            simple = {},
            conditional = {}
        },

        create_values = function(self)
            self.cache.backtrack.pos = ctx.common:gram_create(
                {
                    origin = vector(),
                    eyepos = vector(),
                    final_pos = vector()
                }, 32
            )

            self.cache.backtrack.state = ctx.common:gram_create(self.vars.p_state, 32)
        end,

        store_backtrack = LPH_JIT_MAX(function(self)
            local plocal = self.vars.local_player
            local lp_origin = vector(entity.get_origin(plocal))

            ctx.common:gram_update(
                self.cache.backtrack.pos,
                {
                    origin = lp_origin,
                    eyepos = vector(client.eye_position()),
                    final_pos = lp_origin + vector(entity.get_prop(plocal, 'm_vecViewOffset')) - vector(0, 0, 11)
                }
            )

            ctx.common:gram_update(self.cache.backtrack.state, self.vars.p_state)
        end),

        handle_values = function(self, abtype, entindex, steamid, data)
            if steamid == nil then
                return
            end

            local condition, team = data.p_state.condition, data.p_state.team

            local antibruteforce_simple = function()
                local events = 'aa:antibruteforce:events'

                local index_names = {
                    'miss',
                    'hit',
                    'headshot'
                }

                for i, index in pairs(index_names) do
                    if index ~= abtype or not self.menu:contains(events, index) then
                        goto skip
                    end

                    if self.values.simple[steamid] == nil then
                        self.values.simple[steamid] = {
                            jitter = {
                                phases = {
                                    phase = 0
                                },
                                automatic = {
                                    amount = 0
                                }
                            },
                            static = {
                                side = 'left'
                            },
                            active = true,
                            last_time = globals.curtime(),
                            entindex = entindex
                        }
                    end

                    local mode = self.menu:get('aa:antibruteforce:simple:mode')

                    if mode == 'jitter' then
                        local jitter_mode = self.menu:get('aa:antibruteforce:simple:jitter:mode')

                        if jitter_mode == 'automatic' then
                            local yaw_jitter_value = client.random_int(45, 90)

                            self.values.simple[steamid].jitter.automatic.amount = yaw_jitter_value

                            if self.menu:get('visuals:notifier:antibruteforce') then
                                local enemy_name = string.sub(entity.get_player_name(entindex), 1, 15)

                                local message = {
                                    { '[' },
                                    { 'bruteforce', true },
                                    { '] changed jitter due to ' },
                                    { index, true },
                                    { ' by \'' },
                                    { enemy_name, true },
                                    { '\' [' },
                                    { self.values.simple[steamid].jitter.automatic.amount, true },
                                    { ']' }
                                }

                                if data.backtrack_ticks > 0 then
                                    message = {
                                        { '[' },
                                        { 'bruteforce', true },
                                        { '] changed jitter due to ' },
                                        { index, true },
                                        { ' at ' },
                                        { 'backtrack', true },
                                        { ' [ticks: ' },
                                        { data.backtrack_ticks, true },
                                        { '] by \'' },
                                        { enemy_name, true },
                                        { '\' [' },
                                        { self.values.simple[steamid].jitter.automatic.amount, true },
                                        { ']' }
                                    }
                                end

                                self.notifier:add({
                                    time = self.notifier.time.short,
                                    text = message
                                })
                            end
                        elseif jitter_mode == 'phases' then
                            local phase_amount = self.menu:get('aa:antibruteforce:simple:jitter:phases:amount')

                            self.values.simple[steamid].jitter.phases.phase = self.values.simple[steamid].jitter.phases.phase % phase_amount
                            self.values.simple[steamid].jitter.phases.phase = self.values.simple[steamid].jitter.phases.phase + 1

                            if self.menu:get('visuals:notifier:antibruteforce') then
                                local enemy_name = string.sub(entity.get_player_name(entindex), 1, 15)

                                local message = {
                                    { '[' },
                                    { 'bruteforce', true },
                                    { '] changed jitter due to ' },
                                    { index, true },
                                    { ' by \'' },
                                    { enemy_name, true },
                                    { '\' [phase: ' },
                                    { self.values.simple[steamid].jitter.phases.phase, true },
                                    { ']' }
                                }

                                if data.backtrack_ticks > 0 then
                                    message = {
                                        { '[' },
                                        { 'bruteforce', true },
                                        { '] changed jitter due to ' },
                                        { index, true },
                                        { ' at ' },
                                        { 'backtrack', true },
                                        { ' [ticks: ' },
                                        { data.backtrack_ticks, true },
                                        { '] by \'' },
                                        { enemy_name, true },
                                        { '\' [phase: ' },
                                        { self.values.simple[steamid].jitter.phases.phase, true },
                                        { ']' }
                                    }
                                end

                                self.notifier:add({
                                    time = self.notifier.time.short,
                                    text = message
                                })
                            end
                        end
                    elseif mode == 'static' then
                        local detect_side = self.menu:get('aa:antibruteforce:simple:static:detect_side')

                        if detect_side then
                            self.values.simple[steamid].static.side = data.shot_side == 'left' and 'right' or 'left'
                        else
                            self.values.simple[steamid].static.side = self.values.simple[steamid].static.side == 'left' and 'right' or 'left'
                        end

                        if self.menu:get('visuals:notifier:antibruteforce') then
                            local enemy_name = string.sub(entity.get_player_name(entindex), 1, 15)

                            local message = {
                                { '[' },
                                { 'bruteforce', true },
                                { '] switched side to ' },
                                { self.values.simple[steamid].static.side, true },
                                { ' due to ' },
                                { index, true },
                                { ' by \'' },
                                { enemy_name, true },
                                { '\'' }
                            }

                            if data.backtrack_ticks > 0 then
                                message = {
                                    { '[' },
                                    { 'bruteforce', true },
                                    { '] switched side to ' },
                                    { self.values.simple[steamid].static.side, true },
                                    { ' due to ' },
                                    { index, true },
                                    { ' at ' },
                                    { 'backtrack', true },
                                    { ' [ticks: ' },
                                    { data.backtrack_ticks, true },
                                    { '] by \'' },
                                    { enemy_name, true },
                                    { '\'' }
                                }
                            end

                            self.notifier:add({
                                time = self.notifier.time.short,
                                text = message
                            })
                        end
                    end

                    self.values.simple[steamid].active = true
                    self.values.simple[steamid].last_time = globals.curtime()

                    ::skip::
                end
            end

            local dynamic = function()
                if abtype == 'headshot'
                and self.antiaim.dynamic.values.antiaim_data[steamid] ~= nil
                and self.antiaim.dynamic.values.data[steamid] ~= nil then
                    self.antiaim.dynamic.values.antiaim_data[steamid][team][condition] = nil
                    self.antiaim.dynamic.values.data[steamid] = nil

                    if self.menu:get('visuals:notifier:antibruteforce') then
                        local enemy_name = string.sub(entity.get_player_name(entindex), 1, 15)

                        local message = {
                            { '[' },
                            { 'dynamic', true },
                            { '] reset antiaim data for (' },
                            { ('%s - %s'):format(team, condition), true },
                            { ') due to ' },
                            { 'headshot', true },
                            { ' by \'' },
                            { enemy_name, true },
                            { '\'' }
                        }

                        if data.backtrack_ticks > 0 then
                            message = {
                                { '[' },
                                { 'dynamic', true },
                                { '] reset antiaim data for (' },
                                { ('%s - %s'):format(team, condition), true },
                                { ') due to ' },
                                { 'headshot', true },
                                { ' at ' },
                                { 'backtrack', true },
                                { ' [ticks: ' },
                                { data.backtrack_ticks, true },
                                { '] by \'' },
                                { enemy_name, true },
                                { '\'' }
                            }
                        end

                        self.notifier:add({
                            time = self.notifier.time.short,
                            text = message
                        })
                    end

                    return
                end

                local events = 'aa:dynamic:antibruteforce:events'

                local index_names = {
                    'miss',
                    'hit'
                }

                for i, index in pairs(index_names) do
                    if index ~= abtype or not self.menu:contains(events, index) then
                        goto skip
                    end

                    if self.antiaim.dynamic.values.data[steamid] == nil then
                        self.antiaim.dynamic.values.data[steamid] = {}
                        for i, team in pairs(self.vars.teams) do
                            self.antiaim.dynamic.values.data[steamid][team] = {}
                            for k, condition in pairs(self.vars.builder_conditions) do
                                self.antiaim.dynamic.values.data[steamid][team][condition] = {
                                    yaw = {
                                        left = 0,
                                        right = 0
                                    },
                                    yaw_jitter_value = 0
                                }
                            end
                        end
                    end

                    local yaw_add, yaw_jitter_value_add = client.random_int(-5, 5), client.random_int(-10, 10)

                    self.antiaim.dynamic.values.data[steamid][team][condition].yaw[data.shot_side] =
                    self.antiaim.dynamic.values.data[steamid][team][condition].yaw[data.shot_side] + yaw_add

                    self.antiaim.dynamic.values.data[steamid][team][condition].yaw_jitter_value =
                    self.antiaim.dynamic.values.data[steamid][team][condition].yaw_jitter_value + yaw_jitter_value_add

                    if self.menu:get('visuals:notifier:antibruteforce') then
                        local enemy_name = string.sub(entity.get_player_name(entindex), 1, 15)

                        local message = {
                            { '[' },
                            { 'dynamic', true },
                            { '] changed due to ' },
                            { index, true },
                            { ' by \'' },
                            { enemy_name, true },
                            { '\'' }
                        }

                        if data.backtrack_ticks > 0 then
                            message = {
                                { '[' },
                                { 'dynamic', true },
                                { '] changed due to ' },
                                { index, true },
                                { ' at ' },
                                { 'backtrack', true },
                                { ' [ticks: ' },
                                { data.backtrack_ticks, true },
                                { '] by \'' },
                                { enemy_name, true },
                                { '\'' }
                            }
                        end

                        self.notifier:add({
                            time = self.notifier.time.short,
                            text = message
                        })
                    end

                    ::skip::
                end
            end

            if condition == 'legit aa' or data.p_state.other_condition then
                return
            end

            if self.menu:get('aa:antiaim_preset') == 'dynamic' then
                dynamic()
            elseif self.menu:get('aa:antibruteforce:enable') then
                if self.menu:get('aa:antibruteforce:type') == 'simple' then
                    antibruteforce_simple()
                end
            end
        end,

        handle_shots = function(self)
            for abtype, v in pairs(self.queue) do
                for player, data in pairs(v) do
                    local steamid = entity.get_steam64(player)
                    local idx = tostring(steamid)

                    if idx == '0' then
                        idx = player
                    end

                    if abtype == 'hit' then
                        self.queue.missed[player] = nil
                    end

                    if self.data[idx] == nil then
                        self.data[idx] = {
                            shots = {
                                hit = {},
                                missed = {}
                            },
                            stored_shots = {
                                all = 0,
                                hit = 0,
                                overall_hits = 0,
                                missed = 0,
                                headshots = 0,
                                states = {}
                            },
                            last = {}
                        }

                        for i, team in pairs(self.vars.teams) do
                            self.data[idx].stored_shots.states[team] = {}
                            for k, condition in pairs(self.vars.conditions) do
                                self.data[idx].stored_shots.states[team][condition] = {
                                    all = 0,
                                    hit = 0,
                                    overall_hits = 0,
                                    missed = 0,
                                    headshots = 0
                                }
                            end
                        end
                    end

                    if self.data[idx].shots[abtype][#self.data[idx].shots[abtype]] ~= nil then
                        if self.data[idx].shots[abtype][#self.data[idx].shots[abtype]].time == data.time then
                            goto skip
                        end
                    end

                    table.insert(self.data[idx].shots[abtype], data)

                    self.data[idx].stored_shots.all = self.data[idx].stored_shots.all + 1

                    self.data[idx].stored_shots.states[data.p_state.team][data.p_state.condition].all =
                    self.data[idx].stored_shots.states[data.p_state.team][data.p_state.condition].all + 1

                    self.all_stored_shots.all = self.all_stored_shots.all + 1

                    if abtype == 'hit' then
                        if data.hitbox == 'head' then
                            self.data[idx].stored_shots.headshots = self.data[idx].stored_shots.headshots + 1

                            self.data[idx].stored_shots.states[data.p_state.team][data.p_state.condition].headshots =
                            self.data[idx].stored_shots.states[data.p_state.team][data.p_state.condition].headshots + 1

                            self.all_stored_shots.headshots = self.all_stored_shots.headshots + 1
                        else
                            self.data[idx].stored_shots.hit = self.data[idx].stored_shots.hit + 1

                            self.data[idx].stored_shots.states[data.p_state.team][data.p_state.condition].hit =
                            self.data[idx].stored_shots.states[data.p_state.team][data.p_state.condition].hit + 1

                            self.all_stored_shots.hit = self.all_stored_shots.hit + 1
                        end

                        self.data[idx].stored_shots.overall_hits = self.data[idx].stored_shots.overall_hits + 1

                        self.data[idx].stored_shots.states[data.p_state.team][data.p_state.condition].overall_hits =
                        self.data[idx].stored_shots.states[data.p_state.team][data.p_state.condition].overall_hits + 1

                        self.all_stored_shots.overall_hits = self.all_stored_shots.overall_hits + 1
                    elseif abtype == 'missed' then
                        self.data[idx].stored_shots.missed = self.data[idx].stored_shots.missed + 1

                        self.data[idx].stored_shots.states[data.p_state.team][data.p_state.condition].missed =
                        self.data[idx].stored_shots.states[data.p_state.team][data.p_state.condition].missed + 1

                        self.all_stored_shots.missed = self.all_stored_shots.missed + 1
                    end

                    self.data[idx].last = {
                        body_yaw_side = data.body_yaw_side,
                        shot_side = data.shot_side,
                        time = data.time
                    }

                    self:handle_values(
                        abtype == 'hit' and (data.hitbox == 'head' and 'headshot' or 'hit') or 'miss',
                        player, idx, data
                    )

                    ::skip::

                    self.queue[abtype][player] = nil
                end
            end
        end,

        bullet_impact = function(self, e)
            if e == nil then return end

            local plocal = self.vars.local_player
            local shooter = client.userid_to_entindex(e.userid)

            if not entity.is_alive(plocal)
            or not entity.is_enemy(shooter)
            or not entity.is_alive(shooter)
            or entity.is_dormant(shooter)
            or plist.get(shooter, 'Add to whitelist') then
                return
            end

            local shooter_origin = vector(entity.get_origin(shooter))
            local shooter_viewoffset = vector(entity.get_prop(shooter, 'm_vecViewOffset'))
            local shooter_eyepos = shooter_origin + shooter_viewoffset

            local lp_origin = vector(entity.get_origin(plocal))
            -- local lp_viewoffset = vector(entity.get_prop(plocal, 'm_vecViewOffset'))
            local lp_eyepos = vector(client.eye_position())
            -- local lp_head_pos = vector(entity.hitbox_position(plocal, 0))
            -- local lp_stomach_pos = vector(entity.hitbox_position(plocal, 3))
            -- local lp_final_pos = lp_origin + lp_viewoffset - vector(0, 0, 11)

            -- local duck_amount = entity.get_prop(plocal, 'm_flDuckAmount')
            -- local lp_final_pos = lp_origin + lp_viewoffset - vector(0, 0, 11) --vector(entity.get_origin(plocal)) + vector(0, 0, 57 - 13.5 * duck_amount)

            local angle_to_shooter = vector(lp_origin:to(shooter_origin):angles()).y

            local shooter_ping = entity.get_prop(entity.get_player_resource(), string.format('%03d', plocal))
            local shooter_ping_ticks = toticks(shooter_ping or 0) / 1000
            local max_backtrack_ticks = math.floor(math.max(16, math.min(32, shooter_ping_ticks * 2 + 1)))

            local impact = vector(e.x, e.y, e.z)
            local shot_pos_center = ctx.common:ClosestPointOnRay(lp_eyepos, shooter_eyepos, impact)

            local backtrack_positions do
                local cache = {}
                local positions = {}

                for i = #self.cache.backtrack.pos, 1, -1 do
                    local curr_backtrack = self.cache.backtrack.pos[i]
                    local curr_pos = curr_backtrack.origin

                    if i < max_backtrack_ticks then
                        goto skip
                    end

                    if i < #self.cache.backtrack.pos then
                        if curr_pos:dist(cache[i + 1]) < .8 then
                            goto skip
                        end
                    end

                    positions[#positions + 1] = curr_backtrack

                    ::skip::

                    cache[i] = curr_pos
                end

                backtrack_positions = positions
            end

            local closest_position do
                local distances = {}

                for i = 1, #backtrack_positions do
                    local curr_backtrack = backtrack_positions[i]
                    local curr_pos = curr_backtrack.final_pos

                    local distance_to_shoot_pos = curr_pos:dist(shot_pos_center)

                    distances[i] = distance_to_shoot_pos
                end

                local _, backtrack_tick = table.contains(distances, math.min(unpack(distances)))

                closest_position = {
                    pos = backtrack_positions[backtrack_tick],
                    backtrack_ticks = backtrack_tick - 1
                }
            end

            local p_state = self.cache.backtrack.state[closest_position.backtrack_ticks + 1]

            if p_state.other_condition then
                return
            end

            local shot_distance_to_closest_pos = shot_pos_center:dist(closest_position.pos.final_pos)

            local shot_side do
                local left_pos = ctx.common:extend_vector(closest_position.pos.eyepos, 5, anti_aim_f.normalize_angle(angle_to_shooter - 90 + 180))
                local right_pos = ctx.common:extend_vector(closest_position.pos.eyepos, 5, anti_aim_f.normalize_angle(angle_to_shooter + 90 + 180))

                local shot_distance_to_left = shot_pos_center:dist(left_pos)
                local shot_distance_to_right = shot_pos_center:dist(right_pos)

                shot_side = shot_distance_to_left > shot_distance_to_right and 'right' or 'left'
            end

            local minimal_distance = closest_position.backtrack_ticks > 0 and 25 or 20

            self.cache.last_backtrack_ticks = closest_position.backtrack_ticks

            local menu_body_yaw = ui.get(ref.body_yaw[2])

            if shot_distance_to_closest_pos < minimal_distance then
                self.queue.missed[shooter] = {
                    p_state = p_state,
                    shot_side = shot_side,
                    body_yaw_side = self.antiaim.body_yaw.side and 'left' or 'right',
                    slider_body_yaw = menu_body_yaw,
                    hitbox = nil,
                    antiaim_data = self.antiaim.current_antiaim,
                    backtrack_ticks = closest_position.backtrack_ticks,
                    time = globals.curtime()
                }
            end
        end,

        player_hurt = function(self, e)
            if e == nil then return end

            local plocal = self.vars.local_player
            local victim = client.userid_to_entindex(e.userid)
            local attacker = client.userid_to_entindex(e.attacker)

            if not entity.is_alive(plocal)
            or victim ~= plocal
            or not entity.is_enemy(attacker)
            or plist.get(attacker, 'Add to whitelist') then
                return
            end

            local p_state = self.cache.backtrack.state[self.cache.last_backtrack_ticks + 1]

            if p_state.other_condition then
                return
            end

            for i = 1, #self.nonweapons do
                if e.weapon == self.nonweapons[i] then
                    return
                end
            end

            local hitbox = self.vars.hitgroup_names[e.hitgroup]

            local menu_body_yaw = ui.get(ref.body_yaw[2])

            self.queue.hit[attacker] = {
                p_state = p_state,
                shot_side = menu_body_yaw > 0 and 'left' or 'right',
                body_yaw_side = self.antiaim.body_yaw.side and 'left' or 'right',
                slider_body_yaw = menu_body_yaw,
                hitbox = hitbox,
                antiaim_data = self.antiaim.current_antiaim,
                backtrack_ticks = self.cache.last_backtrack_ticks,
                time = globals.curtime()
            }
        end,

        handle_settings = function(self, entindex, steamid, team, condition, antiaim_data)
            local data = antiaim_data

            local antibruteforce_type = self.menu:get('aa:antibruteforce:type')

            if antibruteforce_type == 'simple' then
                if self.values.simple[steamid] == nil then
                    goto skip
                end

                local active = self.values.simple[steamid].active

                if not active then
                    goto skip
                end

                local type = self.menu:get('aa:antibruteforce:simple:mode')

                if type == 'jitter' then
                    local mode = self.menu:get('aa:antibruteforce:simple:jitter:mode')

                    if mode == 'automatic' then
                        data.yaw_jitter_value = self.values.simple[steamid].jitter.automatic.amount
                    elseif mode == 'phases' then
                        local phase = self.values.simple[steamid].jitter.phases.phase

                        if phase ~= 0 then
                            local yaw_jitter_value_ref = self.menu:get(string.format('aa:antibruteforce:simple:jitter:phases:%d:yaw_jitter', phase))

                            data.yaw_jitter_value = yaw_jitter_value_ref
                        end
                    end

                    data.yaw = 0
                elseif type == 'static' then
                    local side = self.values.simple[steamid].static.side

                    data.yaw = 0
                    data.yaw_jitter = 'Off'
                    data.yaw_jitter_value = 0
                    data.body_yaw = 'Static'
                    data.body_yaw_value = side == 'left' and 90 or -90
                    data.freestanding_body_yaw = false
                    data.fake_limit = 60
                end
            end

            ::skip::

            return data
        end,

        reset_on_round_start = function(self)
            self.values.simple = {}

            if self.menu:get('visuals:notifier:antibruteforce') then
                self.notifier:add({
                    time = self.notifier.time.medium,
                    text = {
                        { '[' },
                        { 'bruteforce', true },
                        { '] reset data for ' },
                        { 'all', true },
                        { ' enemies due to ' },
                        { 'round start', true }
                    }
                })
            end
        end,

        reset_on_shooter_death = function(self, e)
            local target = client.userid_to_entindex(e.userid)
            local target_steamid = tostring(entity.get_steam64(target))

            if self.values.simple[target_steamid] == nil then
                return
            end

            if not self.values.simple[target_steamid].active then
                return
            end

            -- self.values.simple[target_steamid].active = false
            self.values.simple[target_steamid] = nil

            if self.menu:get('visuals:notifier:antibruteforce') then
                local target_name = string.sub(entity.get_player_name(target), 1, 15)

                self.notifier:add({
                    time = self.notifier.time.medium,
                    text = {
                        { '[' },
                        { 'bruteforce', true },
                        { '] reset data for \'' },
                        { target_name, true },
                        { '\' due to ' },
                        { 'shooter death', true }
                    }
                })
            end
        end,

        last_curtime = globals.curtime(),

        reset_on_time = function(self)
            local reset_time = self.menu:get('aa:antibruteforce:reset_events:time')
            local current_time = globals.curtime()

            if self.last_curtime < current_time - 1 then
                for steamid, data in pairs(self.values.simple) do
                    if data.active and current_time > data.last_time + reset_time then
                        -- self.values.simple[steamid].active = false
                        self.values.simple[steamid] = nil

                        if self.menu:get('visuals:notifier:antibruteforce') then
                            local target_name = string.sub(entity.get_player_name(data.entindex), 1, 15)

                            self.notifier:add({
                                time = self.notifier.time.medium,
                                text = {
                                    { '[' },
                                    { 'bruteforce', true },
                                    { '] reset data for \'' },
                                    { target_name, true },
                                    { '\' due to ' },
                                    { 'time', true }
                                }
                            })
                        end
                    end
                end

                self.last_curtime = current_time
            elseif self.last_curtime > current_time then
                self.last_curtime = current_time
            end
        end
    }

    :struct 'antiaim' {
        condition = {
            second = 'normal',
            other = false
        },
        body_yaw = {
            side = false,
            value = 0
        },
        manual = {
            yaw = 0,
            vars = {
                last_press_time = 0
            }
        },
        freestanding = {
            hotkey = false,
            active = false,
            disabled = false,
            forced = false,
            force_on = false
        },
        edge_yaw = {
            hotkey = false,
            active = false,
            disabled = false,
            forced = false,
            force_on = false
        },
        xway = {
            stage = 1
        },
        skitter = {
            stage = 1
        },
        doubletap = {
            disable = false
        },
        defensive = {
            disable = false,
            force = true
        },
        desync = {
            cache = {
                nade_time = 0,
                tickcount = 0,
                ladder_time = 0
            },
            side = false
        },
        custom_jitter_side = false,
        override_leg_movement = false,
        current_antiaim = {
            yaw = 0,
            yaw_jitter = 'Off',
            yaw_jitter_value = 0,
            body_yaw = 'Off',
            body_yaw_value = 0,
            freestanding_body_yaw = false,
            fake_limit = 0
        },

        cross_assistant = {
            vars = {
                last_charge_time = 0,
                activated = false,
                charge_time = 0,
                ready = false
            }
        },

        handle_cross_assistant = function(self)
            local wait_ticks = 3

            if self.vars.doubletap.charged and not self.cross_assistant.vars.activated then
                self.cross_assistant.vars.last_charge_time = globals.curtime()
                self.cross_assistant.vars.activated = true
            end

            if not self.vars.doubletap.charged and self.vars.doubletap.defensive.active_until - globals.tickcount() < -wait_ticks then
                self.cross_assistant.vars.activated = false
                self.cross_assistant.vars.charge_time = 0
            else
                self.cross_assistant.vars.charge_time = globals.curtime() - self.cross_assistant.vars.last_charge_time
            end

            self.cross_assistant.vars.ready = self.cross_assistant.vars.charge_time > .6

            if self.cross_assistant.vars.ready
            and self.vars.doubletap.defensive.active_until - globals.tickcount() <= 0
            and self.vars.doubletap.defensive.active_until - globals.tickcount() >= -wait_ticks then
                return true
            end

            return false
        end,

        handle_force_defensive = function(self, condition)
            if condition == 'stand' and self.menu.multiselects_values.binds_force_defensive_conditions['stand']
            or (
                condition ~= 'stand'
                and condition ~= 'air crouch'
                and condition ~= 'air'
                and condition ~= 'crouch'
            ) and self.menu.multiselects_values.binds_force_defensive_conditions['move']
            or (condition == 'air crouch' or condition == 'air') and self.vars.p_state.velocity > 30
            and self.menu.multiselects_values.binds_force_defensive_conditions['in air']
            or self.vars.doubletap.charged and (ui.get(ref.quickpeek[1]) and ui.get(ref.quickpeek[2]))
            and self.menu.multiselects_values.binds_force_defensive_conditions['quickpeeking'] then
                return true
            end

            return false
        end,

        handle_freestand_disablers = function(self, condition)
            if condition == 'legit aa' then
                return true
            elseif self.condition.other then
                return true
            elseif condition == 'crouch' and self.menu.multiselects_values.binds_freestand_disablers['crouch']
            or (condition == 'air crouch' or condition == 'air') and self.menu.multiselects_values.binds_freestand_disablers['in air']
            or condition == 'slowwalk' and self.menu.multiselects_values.binds_freestand_disablers['slowwalk']
            or condition == 'move' and self.menu.multiselects_values.binds_freestand_disablers['move'] then
                return true
            end

            return false
        end,

        handle_manual_antiaim = function(self)
            local curtime = globals.curtime()

            if self.menu:get('additions:binds:manual:key:reset') then
                self.manual.yaw = 0
            end

            if self.menu:get('additions:binds:manual:key:right') and self.manual.vars.last_press_time + .2 < curtime then
                self.manual.yaw = self.manual.yaw == 90 and 0 or 90
                self.manual.vars.last_press_time = curtime
            elseif self.menu:get('additions:binds:manual:key:left') and self.manual.vars.last_press_time + .2 < curtime then
                self.manual.yaw = self.manual.yaw == -90 and 0 or -90
                self.manual.vars.last_press_time = curtime
            elseif self.menu:get('additions:binds:manual:key:forward') and self.manual.vars.last_press_time + .2 < curtime then
                self.manual.yaw = self.manual.yaw == 180 and 0 or 180
                self.manual.vars.last_press_time = curtime
            elseif self.manual.vars.last_press_time > curtime then
                self.manual.vars.last_press_time = curtime
            end
        end,

        get_target = function()
            local current_threat = client.current_threat()

            if current_threat == nil then
                return nil, nil
            end

            local steamid = tostring(entity.get_steam64(current_threat))

            if steamid == '0' then
                steamid = current_threat
            end

            return current_threat, steamid
        end,

        legit_antiaim = {
            vars = {
                classnames = {
                    'CWorld',
                    'CCSPlayer',
                    'CFuncBrush'
                }
            }
        },

        can_use_legit_antiaim = function(self)
            local plocal = self.vars.local_player

            local bomb = entity.get_all('CPlantedC4')[1]
            local bomb_pos = vector(entity.get_prop(bomb, 'm_vecOrigin'))

            local player_pos = vector(entity.get_prop(plocal, 'm_vecOrigin'))
            local distance = bomb_pos:dist(player_pos)

            local team_num = entity.get_prop(plocal, 'm_iTeamNum')
            local defusing = team_num == 3 and distance < 60

            local on_bombsite = entity.get_prop(plocal, 'm_bInBombZone')

            local holding_bomb = false do
                local lp_wpn = entity.get_player_weapon(plocal)

                if lp_wpn == 522 then
                    holding_bomb = true
                end
            end

            local eye_pos = vector(client.eye_position())
            local destination = eye_pos + vector():init_from_angles(client.camera_angles()) * 8192

            local fraction, entindex = client.trace_line(
                plocal,
                eye_pos.x, eye_pos.y, eye_pos.z,
                destination.x, destination.y, destination.z
            )

            local using = true

            if entindex ~= nil and entindex ~= -1 then
                for i = 1, #self.antiaim.legit_antiaim.vars.classnames do
                    if entity.get_classname(entindex) == self.antiaim.legit_antiaim.vars.classnames[i] then
                        using = false
                    end
                end
            end

            local bomb_carrier = entity.get_prop(entity.get_player_resource(), 'm_iPlayerC4')

            if not using
            and not defusing
            and not holding_bomb
            and (bomb_carrier == 0 or bomb_carrier ~= entindex) then
                return true
            end

            return false
        end,

        player_condition = function(self, cmd)
            local plocal = self.vars.local_player

            local legit_aa = self.menu:get('additions:binds:legitaa:key')
            and self.menu.multiselects_values.bind_selector['legit anti-aim']
            and self:can_use_legit_antiaim()
            local flags = entity.get_prop(plocal, 'm_fFlags')
            local onground = cmd.in_jump == 0 and bit.band(flags, 1) == 1
            local velocity = vector(entity.get_prop(plocal, 'm_vecVelocity')):length2d()
            local crouched = onground and entity.get_prop(plocal, 'm_flDuckAmount') == 1
            local slowwalking = onground and velocity > 1.02 and not crouched and ui.get(ref.slowwalk[2])
            local inair = not onground
            local inair_crouch = inair and cmd.in_duck == 1
            local fakeducking = onground and ui.get(ref.fakeduck)

            if entity.get_prop(entity.get_game_rules(), 'm_bFreezePeriod') == 1 then
                return self.vars.conditions_to_int['stand'], velocity
            end

            if legit_aa then
                return self.vars.conditions_to_int['legit aa'], velocity
            elseif inair_crouch then
                return self.vars.conditions_to_int['air crouch'], velocity
            elseif inair then
                return self.vars.conditions_to_int['air'], velocity
            elseif crouched or fakeducking then
                if velocity > 1.02 then
                    return self.vars.conditions_to_int['crouch move'], velocity
                end

                return self.vars.conditions_to_int['crouch'], velocity
            elseif slowwalking then
                return self.vars.conditions_to_int['slowwalk'], velocity
            elseif onground and velocity > 1.02 then
                return self.vars.conditions_to_int['move'], velocity
            else--if onground and velocity < 1.02 then
                return self.vars.conditions_to_int['stand'], velocity
            end
        end,

        update_vars = function(self, cmd)
            local plocal = self.vars.local_player

            local player_state_number, velocity = self:player_condition(cmd)

            local holding_exploit = (ui.get(ref.doubletap[1]) and ui.get(ref.doubletap[2])) or (ui.get(ref.onshotaa[1]) and ui.get(ref.onshotaa[2]))
            local exploiting = holding_exploit and not ui.get(ref.fakeduck)

            if cmd.chokedcommands == 0 then
                local lp_bodyyaw = entity.get_prop(plocal, 'm_flPoseParameter', 11) * 120 - 60

                self.body_yaw.value = lp_bodyyaw
                self.body_yaw.side = lp_bodyyaw > 0
            end

            local current_team_idx = entity.get_prop(plocal, 'm_iTeamNum')

            local team_index_to_name = {
                [2] = 'terrorist',
                [3] = 'counter terrorist'
            }

            local legitaa_on = self.vars.p_state.real_condition == 'legit aa'
            local in_air = self.vars.p_state.real_condition == 'air' or self.vars.p_state.real_condition == 'air crouch'

            local condition = self.vars.conditions[player_state_number]

            self.vars.p_state = {
                real_condition = condition,
                condition = (not exploiting and not legitaa_on and velocity > 1.02) and 'fakelag' or condition,
                team = team_index_to_name[current_team_idx] or team_index_to_name[2],
                fakelag = not exploiting and not legitaa_on and velocity > 1.02,
                second_condition = self.condition.second,
                other_condition = self.condition.other,
                velocity = velocity,
                condition_number = player_state_number
            }

            if (exploiting or velocity < 1.02) and not in_air then
                cmd.no_choke = true
            end

            ui.set(ref.reduce_aim_step, false)

            ui.set(ref.doubletap_mode, 'Defensive')
            ui.set(ref.doubletap[1], not self.doubletap.disable)

            self.doubletap.disable = false

            self.override_leg_movement = false

            if self.menu.multiselects_values.bind_selector['manual anti-aim'] then
                self:handle_manual_antiaim()
            else
                self.manual.yaw = 0
            end

            self.freestanding.forced = self.freestanding.force_on and not legitaa_on and self.manual.yaw == 0 and not in_air
            self.freestanding.hotkey = self.menu:get('additions:binds:freestand:key') and self.menu.multiselects_values.bind_selector['freestand']
            self.freestanding.disabled = not self.freestanding.forced and self:handle_freestand_disablers(self.vars.p_state.real_condition)
            self.freestanding.active = self.freestanding.forced or (self.freestanding.hotkey and not self.freestanding.disabled)

            ui.set(ref.antiaim_refs.other.freestanding_enable, self.freestanding.active)

            self.freestanding.force_on = false

            self.edge_yaw.forced = self.edge_yaw.force_on and not legitaa_on and self.manual.yaw == 0 and not in_air
            -- self.edge_yaw.hotkey = false
            -- self.edge_yaw.disabled = not self.edge_yaw.forced
            self.edge_yaw.active = self.edge_yaw.forced or (self.edge_yaw.hotkey and not self.edge_yaw.disabled)

            ui.set(ref.antiaim_refs.other.edge_yaw, self.edge_yaw.active)

            self.edge_yaw.force_on = false

            if self.menu.multiselects_values.bind_selector['force defensive'] then
                self.defensive.force = self:handle_force_defensive(self.vars.p_state.real_condition)

                if self.menu:get('additions:binds:force_defensive:key') then
                    self.defensive.force = true
                end
            end

            if self.menu:get('additions:binds:cross_assistant:key') and self.menu.multiselects_values.bind_selector['cross assistant'] then
                if self:handle_cross_assistant() then
                    self.doubletap.disable = true
                    ui.set(ref.doubletap[1], false)
                end

                self.defensive.force = false
            else
                self.cross_assistant.vars.activated = false
                self.cross_assistant.vars.charge_time = 0
                self.cross_assistant.vars.ready = false
            end

            -- cmd.force_defensive = (cmd.command_number % 28 == 0)

            -- if cmd.command_number % 7 == 0 then
            --     cmd.force_defensive = true
            -- end

            if not legitaa_on and self.defensive.force and not self.defensive.disable then
                cmd.force_defensive = true
            end

            self.defensive.force = false
            self.defensive.disable = false

            ui.set(ref.antiaim_refs.other.enabled, true)
            ui.set(ref.antiaim_refs.other.roll, 0)
            ui.set(ref.antiaim_refs.other.freestanding_key, 'Always on')

            ui.set(self.menu:get_element('additions:binds:manual:key:right'), 'On hotkey')
            ui.set(self.menu:get_element('additions:binds:manual:key:left'), 'On hotkey')
            ui.set(self.menu:get_element('additions:binds:manual:key:forward'), 'On hotkey')
            ui.set(self.menu:get_element('additions:binds:manual:key:reset'), 'On hotkey')
        end,

        manual_antiaim_settings = function(self, entindex, steamid, team, condition, cmd, roll)
            local data = {
                yaw = self.manual.yaw,
                yaw_jitter = 'Off',
                yaw_jitter_value = 0,
                body_yaw = 'Static',
                body_yaw_value = -180,
                freestanding_body_yaw = false,
                fake_limit = 60
            }

            if roll then
                cmd.roll = 50
            end

            return data
        end,

        legit_antiaim_settings = function(self, entindex, steamid, team, condition)
            local data = {
                yaw = -180,
                yaw_jitter = 'Off',
                yaw_jitter_value = -25,
                body_yaw = { 'custom jitter', 10 },
                -- body_yaw = 'Static',
                body_yaw_value = 0,
                freestanding_body_yaw = false,
                fake_limit = 60
            }

            if self.vars.doubletap.defensive.active then
                data.yaw_jitter = 'Off'
                data.body_yaw = 'Static'
                data.body_yaw_value = 0
                data.freestanding_body_yaw = false
            end

            return data
        end,

        builder_settings = function(self, entindex, steamid, team, condition)
            local builder_data = {
                yaw = 0,
                yaw_jitter = self.menu:get(string.format('aa:builder:states:%s:%s:yaw_jitter', team, condition)),
                yaw_jitter_value = self.menu:get(string.format('aa:builder:states:%s:%s:yaw_jitter_value', team, condition)),
                body_yaw = self.menu:get(string.format('aa:builder:states:%s:%s:body_yaw', team, condition)),
                body_yaw_value = self.menu:get(string.format('aa:builder:states:%s:%s:body_yaw_value', team, condition)),
                freestanding_body_yaw = false,
                fake_limit = self.menu:get(string.format('aa:builder:states:%s:%s:fake_limit', team, condition))
            }

            local yaw_mode = self.menu:get(string.format('aa:builder:states:%s:%s:yaw_mode', team, condition))

            if yaw_mode == 'simple' then
                builder_data.yaw = self.menu:get(string.format('aa:builder:states:%s:%s:yaw_value', team, condition))
            elseif yaw_mode == 'body side based' then
                builder_data.yaw = {
                    left = self.menu:get(string.format('aa:builder:states:%s:%s:yaw_left_value', team, condition)),
                    right = self.menu:get(string.format('aa:builder:states:%s:%s:yaw_right_value', team, condition)),
                }
            end

            if builder_data.body_yaw == 'custom jitter' then
                builder_data.body_yaw = {
                    builder_data.body_yaw,
                    self.menu:get(string.format('aa:builder:states:%s:%s:custom_jitter_delay', team, condition)) * 2
                }
            end

            if builder_data.yaw_jitter == '3-way' or builder_data.yaw_jitter == '5-way' then
                local xway_mode = self.menu:get(string.format('aa:builder:states:%s:%s:yaw_jitter:xway:mode', team, condition))

                if xway_mode == 'manual' then
                    builder_data.yaw_jitter_value = {
                        self.menu:get(string.format('aa:builder:states:%s:%s:xway:manual:value:1', team, condition)),
                        self.menu:get(string.format('aa:builder:states:%s:%s:xway:manual:value:2', team, condition)),
                        self.menu:get(string.format('aa:builder:states:%s:%s:xway:manual:value:3', team, condition)),
                        self.menu:get(string.format('aa:builder:states:%s:%s:xway:manual:value:4', team, condition)),
                        self.menu:get(string.format('aa:builder:states:%s:%s:xway:manual:value:5', team, condition))
                    }
                end
            end

            return builder_data
        end,

        dynamic = {
            values = {
                data = {},
                antiaim_data = {}
            }
        },

        dynamic_settings = function(self, entindex, steamid, team, condition)
            local dynamic_data = {
                yaw = {
                    left = 0,
                    right = 0
                },
                yaw_jitter = 'Off',
                yaw_jitter_value = 0,
                body_yaw = 'Off',
                body_yaw_value = 0,
                freestanding_body_yaw = false,
                fake_limit = 0
            }

            if steamid == nil then
                return dynamic_data
            end

            if self.dynamic.values.antiaim_data[steamid] == nil then
                self.dynamic.values.antiaim_data[steamid] = {}
            end

            if self.dynamic.values.antiaim_data[steamid][team] == nil then
                self.dynamic.values.antiaim_data[steamid][team] = {}
            end

            if self.dynamic.values.antiaim_data[steamid][team][condition] == nil then
                local yaw = client.random_int(-10, 10)
                -- local skitter = condition ~= 'fakelag'
                local yaw_jitter = 'Center' --condition ~= 'fakelag' and 'Skitter' or 'Center'
                local yaw_jitter_value = client.random_int(60, 90) --skitter and client.random_int(30, 50) or client.random_int(50, 90)

                self.dynamic.values.antiaim_data[steamid][team][condition] = {
                    yaw = yaw,
                    yaw_jitter = yaw_jitter,
                    yaw_jitter_value = yaw_jitter_value,
                    -- body_yaw = { 'custom jitter', 1 },
                    body_yaw = 'Jitter',
                    body_yaw_value = 0,
                    freestanding_body_yaw = false,
                    fake_limit = 60
                }
            end

            dynamic_data = self.dynamic.values.antiaim_data[steamid][team][condition]

            local yaw_left, yaw_right, yaw_jitter_value = 0, 0, 0

            if self.dynamic.values.data[steamid] ~= nil then
                yaw_left, yaw_right, yaw_jitter_value =
                self.dynamic.values.data[steamid][team][condition].yaw.left,
                self.dynamic.values.data[steamid][team][condition].yaw.right,
                self.dynamic.values.data[steamid][team][condition].yaw_jitter_value
            end

            local data = {
                yaw = {
                    left = dynamic_data.yaw + yaw_left,
                    right = dynamic_data.yaw + yaw_right
                },
                yaw_jitter = dynamic_data.yaw_jitter,
                yaw_jitter_value = dynamic_data.yaw_jitter_value + yaw_jitter_value,
                body_yaw = dynamic_data.body_yaw,
                body_yaw_value = dynamic_data.body_yaw_value,
                freestanding_body_yaw = dynamic_data.freestanding_body_yaw,
                fake_limit = dynamic_data.fake_limit
            }

            return data
        end,

        set_antiaim_values = function(self, antiaim_data)
            local final_data = {
                antiaim_data.yaw,
                antiaim_data.yaw_jitter,
                antiaim_data.yaw_jitter_value,
                antiaim_data.body_yaw,
                antiaim_data.body_yaw_value,
                antiaim_data.freestanding_body_yaw,
                antiaim_data.fake_limit
            }

            for i = 1, #ref.antiaim_refs.main do
                ui.set(ref.antiaim_refs.main[i], final_data[i])
            end
        end,

        handle_antiaim_data = function(self, cmd, antiaim_data, pitch_value)
            local data = antiaim_data

            local raw_data = data

            if ((type(data.body_yaw) == 'table' and data.body_yaw[1] == 'custom jitter') or data.body_yaw == 'custom jitter') and not self.vars.p_state.fakelag then
                if cmd.chokedcommands == 0 then
                    if type(data.body_yaw[2]) == 'number' then
                        local ticks = data.body_yaw[2]
                        self.custom_jitter_side = cmd.command_number % ticks >= (ticks / 2)
                    else
                        self.custom_jitter_side = cmd.command_number % 10 >= 5
                    end
                end

                local side = self.custom_jitter_side

                if type(data.yaw) == 'table' then
                    data.yaw = side and data.yaw.left or data.yaw.right
                end

                -- if data.yaw_jitter == 'Offset' then
                --     data.yaw = data.yaw + (side and 0 or antiaim_data.yaw_jitter_value)
                -- elseif data.yaw_jitter == 'Center' then
                --     data.yaw = data.yaw + (side and -antiaim_data.yaw_jitter_value / 2 or antiaim_data.yaw_jitter_value / 2)
                -- elseif data.yaw_jitter == 'Random' then
                --     data.yaw = data.yaw + client.random_int(-antiaim_data.yaw_jitter_value / 2, antiaim_data.yaw_jitter_value / 2)
                -- end

                data.yaw = data.yaw + (side and -antiaim_data.yaw_jitter_value / 2 or antiaim_data.yaw_jitter_value / 2)

                data.yaw_jitter = 'Off'
                data.yaw_jitter_value = 0
                data.body_yaw = 'Static'
                data.body_yaw_value = side and -180 or 180
            else
                local side = self.body_yaw.side

                if type(data.yaw) == 'table' then
                    data.yaw = side and data.yaw.left or data.yaw.right
                end
            end

            if data.yaw_jitter == 'Skitter' and not self.vars.p_state.fakelag then
                -- 131 231 232 132
                if cmd.chokedcommands == 0 then
                    self.skitter.stage = self.skitter.stage % 12
                    self.skitter.stage = self.skitter.stage + 1
                end

                local stages = {
                    -data.yaw_jitter_value,
                    data.yaw_jitter_value,
                    -data.yaw_jitter_value,
                    0,
                    data.yaw_jitter_value,
                    -data.yaw_jitter_value,
                    0,
                    data.yaw_jitter_value,
                    0,
                    -data.yaw_jitter_value,
                    data.yaw_jitter_value,
                    0
                }

                local value = math.clamp(stages[self.skitter.stage], -90, 90)

                data.yaw = data.yaw + value

                if data.body_yaw == 'Jitter' then
                    if value == 0 then
                        data.body_yaw = 'Off'
                        data.body_yaw_value = 0
                    else
                        data.body_yaw = 'Static'
                        data.body_yaw_value = value > 0 and 180 or -180
                    end
                end

                data.yaw_jitter = 'Off'
                data.yaw_jitter_value = 0
            elseif data.yaw_jitter == '3-way' or data.yaw_jitter == '5-way' then
                if cmd.command_number % 2 == 0 then
                    self.xway.stage = self.xway.stage % tonumber(string.sub(data.yaw_jitter, 1, 1))
                    self.xway.stage = self.xway.stage + 1
                end

                if type(data.yaw_jitter_value) == 'table' then
                    local stages = {
                        data.yaw_jitter_value[1],
                        data.yaw_jitter_value[2],
                        data.yaw_jitter_value[3],
                        data.yaw_jitter_value[4],
                        data.yaw_jitter_value[5]
                    }

                    data.yaw = data.yaw + stages[self.xway.stage]
                    data.yaw_jitter = 'Off'
                    data.yaw_jitter_value = 0
                else
                    local stages = {
                        ['3-way'] = {
                            -data.yaw_jitter_value / 2,
                            0,
                            data.yaw_jitter_value / 2
                        },
                        ['5-way'] = {
                            -data.yaw_jitter_value,
                            -data.yaw_jitter_value / 2,
                            0,
                            data.yaw_jitter_value / 2,
                            data.yaw_jitter_value
                        }
                    }

                    data.yaw = data.yaw + stages[data.yaw_jitter][math.clamp(self.xway.stage, 1, tonumber(string.sub(data.yaw_jitter, 1, 1)))]
                    data.yaw_jitter = 'Off'
                    data.yaw_jitter_value = 0
                end
            end

            if data.yaw_jitter == 'Off' then
                data.yaw_jitter_value = 0
            end

            if data.body_yaw == 'Off' then
                data.body_yaw_value = 0
            elseif (type(data.body_yaw) == 'table' and data.body_yaw[1] == 'custom jitter') or data.body_yaw == 'custom jitter' then
                data.body_yaw = 'Jitter'
            end

            -- if data.fake_limit == 60 then
            --     data.fake_limit = 59
            -- end

            data.yaw = anti_aim_f.normalize_angle(data.yaw, -180, 180)

            local pitch = 0 do
                local lp_viewangles = vector(client.camera_angles())

                local pitch_values = {
                    ['Off'] = lp_viewangles.x,
                    ['Default'] = 89,
                    ['Up'] = -89,
                    ['Down'] = 89,
                    ['Mininal'] = 89,
                    ['Random'] = ({ 89, 0, -89 })[client.random_int(1, 3)]
                }

                pitch = pitch_values[pitch_value] or pitch_value
            end

            return data, pitch, raw_data
        end,

        set_antiaim = function(self, cmd)
            local entindex, steamid = self.get_target()
            local condition, team, fakelag = self.vars.p_state.condition, self.vars.p_state.team, self.vars.p_state.fakelag

            local legitaa_on = self.vars.p_state.real_condition == 'legit aa'

            local pitch_value = 'Default'
            local yaw_base_value = 'At targets'
            local yaw_value = '180'

            local curr_preset = self.menu:get('aa:antiaim_preset')

            local antiaim_data = {
                yaw = 0,
                yaw_jitter = 'Off',
                yaw_jitter_value = 0,
                body_yaw = 'Off',
                body_yaw_value = 0,
                freestanding_body_yaw = false,
                fake_limit = 0
            }

            local custom_condition, other_condition = 'normal', false

            if legitaa_on then
                cmd.in_use = 0

                pitch_value = 'Off'
                yaw_base_value = 'Local view'

                antiaim_data = self:legit_antiaim_settings(entindex, steamid, team, condition)

                self.override_leg_movement = true
                ui.set(ref.leg_movement, 'Always slide')
            elseif entity.get_prop(entity.get_game_rules(), 'm_bFreezePeriod') == 1 then
                custom_condition = 'freezetime'
                other_condition = true
            elseif entity.get_prop(entity.get_game_rules(), 'm_bWarmupPeriod') == 1
            and self.menu.multiselects_values.bind_selector['warmup anti-aim'] then
                custom_condition = 'warmup'
                other_condition = true
            elseif self.manual.yaw ~= 0 then
                local roll = false
                local roll_index = roll and 'roll' or 'normal'

                local condition_names = {
                    normal = {
                        left = 'manual left',
                        right = 'manual right',
                        forward = 'manual forward'
                    },
                    roll = {
                        left = 'manual left roll',
                        right = 'manual right roll',
                        forward = 'manual forward roll'
                    }
                }

                custom_condition = self.manual.yaw ~= 180 and (
                    self.manual.yaw == 90
                    and condition_names[roll_index].right
                    or condition_names[roll_index].left
                ) or condition_names[roll_index].forward
                other_condition = true

                yaw_base_value = 'Local view'

                antiaim_data = self:manual_antiaim_settings(entindex, steamid, team, condition, cmd, roll)
            elseif self.vars.doubletap.defensive.active
            and self.menu:get('additions:binds:breaker:key')
            and self.menu.multiselects_values.bind_selector['breaker'] then
                custom_condition = 'breaker'
                other_condition = true

                local data = {
                    yaw = cmd.command_number % 4 <= 1 and 100 or -100,
                    yaw_jitter = 'Off',
                    yaw_jitter_value = 0,
                    body_yaw = 'Off',
                    body_yaw_value = 0,
                    freestanding_body_yaw = false,
                    fake_limit = 60
                }

                pitch_value = -50

                antiaim_data = data
            -- elseif (entity.get_prop(entindex, 'm_flNextAttack') or 0) > globals.curtime()
            -- and self.menu:get('additions:binds:breaker:key')
            -- and self.menu:contains('additions:bind_selector', 'breaker') then
            --     custom_condition = 'breaker'
            --     other_condition = true

            --     local data = {
            --         yaw = cmd.command_number % 4 >= 2 and 100 or -100,
            --         yaw_jitter = 'Off',
            --         yaw_jitter_value = 0,
            --         body_yaw = 'Off',
            --         body_yaw_value = 0,
            --         freestanding_body_yaw = false,
            --         fake_limit = 60
            --     }

            --     pitch_value = -10

            --     antiaim_data = data
            else
                if curr_preset == 'dynamic' then
                    antiaim_data = self:dynamic_settings(entindex, steamid, team, condition)
                else
                    if curr_preset == 'experimental' then
                        antiaim_data = experimental_data()[team][condition]
                    elseif curr_preset == 'configurator' then
                        local b_team, b_condition = self.vars.teams[1], condition

                        if self.menu:contains('aa:builder:builder_options', 'team based') then
                            b_team = team
                        end

                        local preview_state = self.menu:get('aa:builder:preview_selected_state')

                        if preview_state and ui.is_menu_open() then
                            b_team = self.menu:get('aa:builder:team_selector')
                            b_condition = self.menu:get('aa:builder:condition_selector')
                        end

                        antiaim_data = self:builder_settings(entindex, steamid, b_team, b_condition)
                    end

                    if self.menu:get('aa:antibruteforce:enable') then
                        antiaim_data = self.antibruteforce:handle_settings(entindex, steamid, team, condition, antiaim_data)
                    end
                end
            end

            self.current_antiaim = antiaim_data

            local antiaim_data_final, pitch_final, raw_data = self:handle_antiaim_data(cmd, antiaim_data, pitch_value)

            if (ctx.data.source and (self.menu.other.disable_custom_desync and ui.get(self.menu.other.disable_custom_desync))) or fakelag then
                self:set_antiaim_values(antiaim_data_final)
            else
                if self.freestanding.active then
                    self:set_antiaim_values({
                        yaw = 0,
                        yaw_jitter = 'Off',
                        yaw_jitter_value = 0,
                        body_yaw = 'Static',
                        body_yaw_value = 180,
                        freestanding_body_yaw = true,
                        fake_limit = 60
                    })
                else
                    self:custom_desync(cmd, entindex, antiaim_data_final, pitch_final, yaw_base_value, raw_data)

                    self:set_antiaim_values({
                        yaw = legitaa_on and -180 or 0,
                        yaw_jitter = 'Off',
                        yaw_jitter_value = 0,
                        body_yaw = 'Jitter',
                        body_yaw_value = 0,
                        freestanding_body_yaw = false,
                        fake_limit = 58
                    })
                end
            end

            ui.set(ref.antiaim_refs.other.pitch_mode, 'Custom')
            ui.set(ref.antiaim_refs.other.pitch_value, pitch_final)
            ui.set(ref.antiaim_refs.other.yaw_base, yaw_base_value)
            ui.set(ref.antiaim_refs.other.yaw, yaw_value)

            self.condition.other = other_condition
            self.condition.second = custom_condition
        end,

        ladder_check = LPH_JIT_MAX(function(self)
            local plocal = self.vars.local_player
            local lp_velocity = self.vars.p_state.velocity
            local on_ladder = entity.get_prop(plocal, 'm_MoveType') == 9 and lp_velocity ~= 0

            if on_ladder then
                self.desync.cache.ladder_time = globals.tickcount() + 5
            end

            if self.desync.cache.ladder_time > globals.tickcount() + 5.001 then
                self.desync.cache.ladder_time = 0
            end
        end),

        custom_desync = function(self, cmd, enemy, antiaim_data, pitch, yaw_base, raw_data)
            local plocal = self.vars.local_player

            local tickcount = globals.tickcount()

            local lp_wpn = entity.get_player_weapon(plocal)

            if self.desync.cache.ladder_time > tickcount
            or cmd.in_use == 1
            or entity.get_prop(entity.get_game_rules(), 'm_bFreezePeriod') == 1
            or ref.helper and ui.get(ref.helper[1]) and ui.get(ref.helper[2]) and string.find(tostring(entity.get_classname(lp_wpn)), 'Grenade') then
                return
            end

            if self.desync.cache.tickcount ~= tickcount then
                self.desync.cache.tickcount = tickcount
            end

            if cmd.in_attack == 1 then
                local weapon = entity.get_classname(lp_wpn)

                if string.find(weapon, 'Grenade') then
                    self.desync.cache.nade_time = tickcount
                else
                    if math.max(
                        entity.get_prop(lp_wpn, 'm_flNextPrimaryAttack') or 0,
                        entity.get_prop(plocal, 'm_flNextAttack') or 0
                    ) <= globals.curtime() then
                        return
                    end
                end
            end

            local throw_time = entity.get_prop(lp_wpn, 'm_fThrowTime')

            if self.desync.cache.nade_time + 8 == tickcount or (throw_time ~= nil and throw_time ~= 0) then
                return
            end

            local lp_viewangles = vector(client.camera_angles())

            local antiaim_angle = enemy and vector(vector(entity.get_origin(plocal)):to(vector(entity.get_origin(enemy))):angles()).y or lp_viewangles.y

            local yaw_base_values = {
                ['Local view'] = lp_viewangles.y,
                ['At targets'] = antiaim_angle,
            }

            local yaw = yaw_base_values[yaw_base] - 180

            if cmd.chokedcommands == 0 then
                self.desync.side = cmd.command_number % 4 >= 2
            end

            local body_yaw_value_final, fake_limit_final = 0, 0 do
                local mode = antiaim_data.body_yaw
                local fake_limit = 60 do
                    if type(antiaim_data.fake_limit) == 'number' then
                        fake_limit = antiaim_data.fake_limit
                    end
                end

                if mode ~= 'Off' then
                    if mode == 'Opposite' then
                        body_yaw_value_final, fake_limit_final = 1, fake_limit
                    elseif mode == 'Jitter' then
                        body_yaw_value_final, fake_limit_final = self.desync.side and -1 or 1, fake_limit
                    elseif mode == 'Static' then
                        local body_yaw_value = antiaim_data.body_yaw_value
                        local body_side = body_yaw_value > 0 and -1 or 1
                        local fake = math.min(math.abs(body_yaw_value), fake_limit)

                        if body_yaw_value == 0 then
                            fake = 0
                        end

                        body_yaw_value_final, fake_limit_final = body_side, fake
                    end

                    if bit.band(entity.get_prop(plocal, 'm_fFlags'), bit.lshift(1, 0)) == 1 and self.vars.p_state.velocity < 1.02 then
                        if not (cmd.in_forward == 1 or cmd.in_moveleft == 1 or cmd.in_moveright == 1 or cmd.in_back == 1 or cmd.in_jump == 1) then
                            cmd.sidemove = .1 * (self.desync.side and -1 or 1)
                        end
                    end
                end
            end

            local yaw_final = 0 do
                local body_yaw_mode = antiaim_data.body_yaw

                local yaw_side = false do
                    if body_yaw_mode == 'Jitter' then
                        yaw_side = body_yaw_value_final > 0
                    else
                        yaw_side = body_yaw_value_final < 0
                    end
                end

                local yawjitter_side = false do
                    if body_yaw_mode == 'Jitter' then
                        yawjitter_side = not self.desync.side
                    else
                        yawjitter_side = self.desync.side
                    end
                end

                local mode = antiaim_data.yaw_jitter
                local yaw_value = antiaim_data.yaw

                if type(raw_data.yaw) == 'table' then
                    yaw_value = yaw_side and raw_data.yaw.left or raw_data.yaw.right
                end

                if mode == 'Offset' then
                    yaw_final = yaw_value + (yawjitter_side and 0 or antiaim_data.yaw_jitter_value)
                elseif mode == 'Center' then
                    yaw_final = yaw_value + (yawjitter_side and -antiaim_data.yaw_jitter_value / 2 or antiaim_data.yaw_jitter_value / 2)
                elseif mode == 'Random' then
                    yaw_final = yaw_value + client.random_int(-antiaim_data.yaw_jitter_value / 2, antiaim_data.yaw_jitter_value / 2)
                else
                    yaw_final = yaw_value
                end
            end

            yaw = yaw + yaw_final

            if cmd.chokedcommands == 0 then
                cmd.allow_send_packet = false

                yaw = yaw + ((fake_limit_final * 2) * body_yaw_value_final)
            else
                yaw = yaw
            end

            cmd.yaw = yaw
            cmd.pitch = pitch
        end
    }

    :struct 'indicators' {
        nade_names = {
            'CHEGrenade', 'CFlashbang', 'CSmokeGrenade', 'CDecoyGrenade', 'CIncendiaryGrenade', 'CMolotovGrenade'
        },

        style_1_values = {
            scope = smoothy:new(),
            hurt_anim = 0,
            dt = {
                fraction = smoothy:new(1),
                alpha = 0,
                offset = smoothy:new(),
                last_text = '',
                values = { 0, 0, 0, 0, 0 }
            },
            hs = {
                fraction = smoothy:new(1),
                alpha = 0,
                values = { 0, 0, 0, 0, 0, 0 },
                offset = smoothy:new(),
                last_text = ''
            },
            fs = {
                fraction = smoothy:new(1),
                alpha = 0,
                values = { 0, 0, 0 },
                offset = smoothy:new(),
                last_text = ''
            },
            other_binds = {
                fb = {
                    active = 0
                },
                sp = {
                    active = 0
                },
                alpha = 0,
                offset = smoothy:new()
            },
            state = {
                fraction = smoothy:new(1)
            },
            other_items = nil
        },

        render_style_1 = LPH_JIT_MAX(function(self)
            local plocal = self.vars.local_player
            if not entity.is_alive(plocal) then return end

            local values = self.style_1_values

            local screen_size = self.vars.screen_size
            local pos = screen_size / 2 + vector(0, self.menu:get('visuals:indicators:height'))

            local color_ref = self.menu.colors.accent
            local color = { r = color_ref[1], g = color_ref[2], b = color_ref[3], a = 255 }

            local frametime = globals.frametime()
            local speed, state_speed, offset_speed, scope_speed = .045, .03, .05, .06

            local font_style = self.menu:get('visuals:indicators:font_style')

            local font = ({
                ['small'] = '-',
                ['normal'] = '',
                ['bold'] = 'b'
            })[font_style]

            local spacing = font == '-' and '  ' or ' '
            local string_func = font == '-' and string.upper or string.lower

            local offset = vector()

            local scoped = entity.get_prop(plocal, 'm_bIsScoped') == 1
            local scope_enabled = (scoped and self.menu.multiselects_values.indicators_adjustments['move indicators on scope'])
            or (self.menu.multiselects_values.indicators_adjustments['move indicators on nade']
            and ctx.common:check_weapons(plocal, self.nade_names))

            local doubletap = ui.get(ref.doubletap[1]) and ui.get(ref.doubletap[2])

            local waiting_wpn = false do
                local wpn = entity.get_player_weapon(plocal)
                local NextPrimaryAttack = entity.get_prop(wpn, 'm_flNextPrimaryAttack') or 0

                waiting_wpn = NextPrimaryAttack > globals.curtime()
            end

            local scope_fraction = math.clamp(values.scope(scope_speed, scope_enabled and 10.9 or -.9) / 10, 0, 1)

            do
                values.hurt_anim = math.clamp(values.hurt_anim - frametime * .7, 0, 1)
                local hurt_anim = easing.quad_out(values.hurt_anim, 0, 1, 1)

                local name_final = ctx.common:colored_text(
                    string_func(ctx.data.name),
                    ctx.common:color_swap({ 255, 255, 255, 255 }, { 255, 70, 70, 255 }, hurt_anim)
                )

                local version_final = ctx.common:gradient_text_anim(
                    string_func(ctx.data.version),
                    { 210, 210, 210, 120 }, { color.r, color.g, color.b, 255 }, 4
                )

                local text = name_final .. spacing .. version_final
                local text_size = vector(renderer.measure_text(font, text))
                print(text, ', ', text_size)

                local padding = math.floor(-(text_size.x / 2) * (1 - scope_fraction) + 3 * scope_fraction)

                if self.menu:get('visuals:indicators:glow') then
                    Draw:shadow(
                        pos + vector(0, offset.y) + vector(padding + 2, 3),
                        text_size + vector(-2, -5),
                        { r = color.r, g = color.g, b = color.b, a = math.max(30, math.abs(math.sin(globals.curtime())) * 80) },
                        2 + (font ~= '-' and 1 or 0), 12, true
                    )
                end

                renderer.text(pos.x + padding, pos.y, 255, 255, 255, 255, font, nil, text)

                offset.y = offset.y + (text_size.y - 1)
            end

            do
                local doubletap_charged = self.vars.doubletap.charged
                local defensive_choking = self.vars.doubletap.defensive.active
                local work = doubletap

                values.dt.alpha = math.clamp(values.dt.alpha + (work and frametime * 6 or -frametime * 6), 0, 1)
                local alpha = values.dt.alpha

                values.dt.values[3] = math.clamp(values.dt.values[3] + (waiting_wpn and frametime * 5 or -frametime * 5), 0, 1)
                local waiting = values.dt.values[3]

                local text = ctx.common:gradient_text(string_func('DT'), { 255, 255, 255, 255 }, { 255, 255, 255, 120 }, 1 - waiting)
                local text_size = vector(renderer.measure_text(font, text))

                local value = 0
                local second_text = ''

                if alpha > 0 then
                    if work and alpha > .1 then
                        value = text_size.x
                    end

                    values.dt.values[1] = math.clamp(
                        values.dt.values[1] + ((alpha == 1 and not waiting_wpn and doubletap_charged) and frametime * 4 or -frametime * 9), 0, 1
                    )
                    local recharge = values.dt.values[1]

                    values.dt.values[2] = math.clamp(values.dt.values[2] + ((recharge == 1 and doubletap_charged) and frametime * 4 or -frametime * 6), 0, 1)
                    local recharge_hide = values.dt.values[2]

                    values.dt.values[4] = math.clamp(values.dt.values[4] + (recharge_hide == 1 and frametime * 50 or -frametime * 50), 0, 1)
                    local active_pre = values.dt.values[4]

                    values.dt.values[5] = math.clamp(values.dt.values[5] + (active_pre == 1 and frametime * 3 or -frametime * 50), 0, 1)
                    local active = values.dt.values[5]

                    local recharge_text = string_func('CHARGING')
                    local ready_text = string_func('READY')
                    local active_text = string_func('ACTIVE')

                    if alpha == 1 then
                        value = text_size.x + renderer.measure_text(font, spacing .. recharge_text)
                    end

                    if recharge_hide > .6 then
                        second_text = spacing .. (
                            defensive_choking
                            and ctx.common:gradient_text(active_text, { 163, 223, 214, 255 }, { 255, 255, 255, 255 }, active, true)
                            or ctx.common:gradient_text(ready_text, { 203, 239, 172, 255 }, { 255, 255, 255, 255 }, active, true)
                        )
                    else
                        second_text = spacing .. ctx.common:gradient_text(
                            recharge_text,
                            ctx.common:color_swap({ 255, 50, 50, 255 }, { 203, 239, 172, 255 }, recharge),
                            ctx.common:color_swap({ 255, 50, 50, 120 }, { 203, 239, 172, 120 }, recharge), recharge
                        )
                    end

                    if recharge_hide > .1 then
                        value = text_size.x
                    end

                    if active_pre == 1 then
                        value = defensive_choking
                        and text_size.x + renderer.measure_text(font, spacing .. active_text)
                        or text_size.x + renderer.measure_text(font, spacing .. ready_text)
                    end

                    if alpha == 1 and waiting_wpn then
                        local waiting_text = string_func('WAITING')
                        second_text = spacing .. ctx.common:colored_text(waiting_text, { 255, 50, 50, 120 })
                        value = text_size.x + renderer.measure_text(font, spacing .. waiting_text)
                    end

                    if work then
                        values.dt.last_text = text .. second_text
                    else
                        value = 0
                    end

                    local fraction = values.dt.fraction(speed, value + 3)

                    local text_final = values.dt.last_text
                    local text_final_size = vector(renderer.measure_text(font, text_final))

                    local padding = math.floor(-(text_final_size.x / 2) * (1 - scope_fraction) * (fraction / (text_final_size.x + 3)) + 3 * scope_fraction)

                    renderer.text(pos.x + padding, pos.y + offset.y, 255, 255, 255, 255, font, fraction, text_final)
                end

                local h_offset = math.floor(.5 + values.dt.offset(offset_speed, work and (text_size.y - 1) or 0))

                offset.y = offset.y + h_offset
            end

            do
                local hideshots = ui.get(ref.onshotaa[1]) and ui.get(ref.onshotaa[2])
                local work = hideshots

                values.hs.alpha = math.clamp(values.hs.alpha + (work and frametime * 6 or -frametime * 6), 0, 1)
                local alpha = values.hs.alpha

                values.hs.values[6] = math.clamp(values.hs.values[6] + (doubletap and frametime * 5 or -frametime * 5), 0, 1)
                local inactive_hide = values.hs.values[6]

                local text = ctx.common:gradient_text(string_func('HIDE'), { 255, 255, 255, 255 }, { 255, 255, 255, 120 }, 1 - inactive_hide)
                local text_size = vector(renderer.measure_text(font, text))

                local value = 0
                local second_text = ''

                if alpha > 0 then
                    if work and alpha > .1 then
                        value = text_size.x
                    end

                    values.hs.values[1] = math.clamp(values.hs.values[1] + (doubletap and frametime * 3.5 or -frametime * 3.5), 0, 1)
                    local inactive = values.hs.values[1]

                    values.hs.values[2] = math.clamp(values.hs.values[2] + (inactive == 1 and frametime * 3.5 or -frametime * 3.5), 0, 1)
                    local inactive2 = values.hs.values[2]

                    values.hs.values[3] = math.clamp(values.hs.values[3] + ((alpha == 1 and inactive2 > .1) and frametime * 3 or -frametime * 50), 0, 1)
                    local inactive3 = values.hs.values[3]

                    values.hs.values[4] = math.clamp(values.hs.values[4] + ((alpha == 1 and inactive == 0) and frametime * 50 or -frametime * 50), 0, 1)
                    local active_pre = values.hs.values[4]

                    values.hs.values[5] = math.clamp(values.hs.values[5] + (active_pre == 1 and frametime * 3 or -frametime * 50), 0, 1)
                    local active = values.hs.values[5]

                    local inactive_text = string_func('INACTIVE')

                    if alpha == 1 and inactive2 ~= 1 then
                        if waiting_wpn then
                            local active_text = string_func('ACTIVE')
                            value = text_size.x + renderer.measure_text(font, spacing .. active_text)
                            second_text = spacing .. ctx.common:gradient_text(active_text, { 163, 223, 214, 255 }, { 255, 255, 255, 255 }, active, true)
                        else
                            local ready_text = string_func('READY')
                            second_text = spacing .. ctx.common:gradient_text(ready_text, { 203, 239, 172, 255 }, { 255, 255, 255, 255 }, active, true)
                            value = text_size.x + renderer.measure_text(font, spacing .. ready_text)
                        end
                    end

                    if alpha == 1 and inactive > 0 then
                        value = text_size.x
                    end

                    if alpha == 1 and inactive2 > 0 then
                        second_text = spacing .. ctx.common:gradient_text(inactive_text, { 255, 100, 50, 120 }, { 255, 255, 255, 120 }, inactive3, true)
                    end

                    if alpha == 1 and inactive == 1 then
                        value = text_size.x + renderer.measure_text(font, spacing .. inactive_text)
                    end

                    if work then
                        values.hs.last_text = second_text
                    else
                        value = 0
                    end

                    local fraction = values.hs.fraction(speed, value + 3)

                    local text_final = text .. values.hs.last_text
                    local text_final_size = vector(renderer.measure_text(font, text_final))

                    local padding = math.floor(-(text_final_size.x / 2) * (1 - scope_fraction) * (fraction / (text_final_size.x + 3)) + 3 * scope_fraction)

                    renderer.text(pos.x + padding, pos.y + offset.y, 255, 255, 255, 255, font, fraction, text_final)
                end

                local h_offset = math.floor(.5 + values.hs.offset(offset_speed, work and (text_size.y - 1) or 0))

                offset.y = offset.y + h_offset
            end

            do
                local freestand = self.antiaim.freestanding.hotkey
                local freestand_disabled = self.antiaim.freestanding.disabled
                -- local freestand_forced = self.antiaim.freestanding.forced
                local work = freestand

                values.fs.alpha = math.clamp(values.fs.alpha + (work and frametime * 6 or -frametime * 6), 0, 1)
                local alpha = values.fs.alpha

                local text = string_func('FREESTAND')
                local text_size = vector(renderer.measure_text(font, text))

                local text_short = string_func('FS')
                local text_short_size = vector(renderer.measure_text(font, text_short))

                local value = 0
                local first_text = text
                local second_text = ''

                if alpha > 0 then
                    if work and alpha > .1 then
                        value = text_size.x
                    end

                    values.fs.values[1] = math.clamp(values.fs.values[1] + (freestand_disabled and frametime * 4 or -frametime * 4), 0, 1)
                    local disabled = values.fs.values[1]

                    values.fs.values[2] = math.clamp(values.fs.values[2] + (disabled == 1 and frametime * 6 or -frametime * 6), 0, 1)
                    local disabled2 = values.fs.values[2]

                    values.fs.values[3] = math.clamp(values.fs.values[3] + ((alpha == 1 and disabled2 == 1) and frametime * 3 or -frametime * 3), 0, 1)
                    local disabled3 = values.fs.values[3]

                    local disabled_text = string_func('DISABLED')

                    if disabled > 0 then
                        value = text_short_size.x - 6.5
                    end

                    if disabled > .5 then
                        first_text = text_short
                    end

                    if disabled == 1 then
                        value = text_short_size.x
                    end

                    if disabled2 > 0 then
                        first_text = text_short .. spacing .. ctx.common:gradient_text(
                            disabled_text,
                            { 120, 120, 120, 255 }, { 255, 255, 255, 255 }, disabled3, true
                        )
                    end

                    if alpha == 1 and disabled2 == 1 then
                        value = text_short_size.x + renderer.measure_text(font, spacing .. disabled_text)
                    end

                    if work then
                        values.fs.last_text = first_text .. second_text
                    else
                        value = 0
                    end

                    local fraction = values.fs.fraction(speed, value + 3)

                    local text_final = values.fs.last_text
                    local text_final_size = vector(renderer.measure_text(font, text_final))

                    local padding = math.floor(-(text_final_size.x / 2) * (1 - scope_fraction) * (fraction / (text_final_size.x + 3)) + 3 * scope_fraction)

                    renderer.text(pos.x + padding, pos.y + offset.y, 255, 255, 255, 255, font, fraction, text_final)
                end

                local h_offset = math.floor(.5 + values.fs.offset(offset_speed, work and (text_size.y - 1) or 0))

                offset.y = offset.y + h_offset
            end

            do
                local baim = ui.get(ref.forcebaim)
                local safepoint = ui.get(ref.safepoint)
                local work = baim or safepoint

                values.other_binds.alpha = math.clamp(values.other_binds.alpha + (work and frametime * 2.5 or -frametime * 6), 0, 1)
                local alpha = values.other_binds.alpha

                local spacing = spacing ..' '
                local spacing_size = vector(renderer.measure_text(font, spacing))

                values.other_binds.fb.active = math.clamp(values.other_binds.fb.active + ((baim and alpha > .1) and frametime * 7 or -frametime * 9), 0, 1)
                local baim_active = values.other_binds.fb.active

                local baim_text = string_func('BAIM')
                local baim_text_size = vector(renderer.measure_text(font, baim_text))

                values.other_binds.sp.active = math.clamp(values.other_binds.sp.active + ((safepoint and alpha > .1) and frametime * 7 or -frametime * 9), 0, 1)
                local safepoint_active = values.other_binds.sp.active

                local safepoint_text = string_func('SAFE')
                local safepoint_text_size = vector(renderer.measure_text(font, safepoint_text))

                if alpha > 0 then
                    local baim_pos = math.floor(-(baim_text_size.x / 2) * (1 - scope_fraction) * baim_active + 3 * scope_fraction + (-(safepoint_text_size.x / 2 + spacing_size.x / 2) * safepoint_active) * (1 - scope_fraction))

                    renderer.text(pos.x + baim_pos, pos.y + offset.y, 255, 255, 255, 255, font, baim_text_size.x * baim_active + 3, baim_text)

                    local safepoint_pos = math.floor(-(safepoint_text_size.x / 2) * (1 - scope_fraction) * safepoint_active + 3 * scope_fraction + ((baim_text_size.x / 2 + spacing_size.x / 2) * baim_active) * (1 - scope_fraction) + ((baim_text_size.x + spacing_size.x) * baim_active) * scope_fraction)

                    renderer.text(pos.x + safepoint_pos, pos.y + offset.y, 255, 255, 255, 255, font, safepoint_text_size.x * safepoint_active + 3, safepoint_text)
                end

                local h_offset = math.floor(
                    .5 + values.other_binds.offset(offset_speed, work and ((math.max(baim_text_size.y, safepoint_text_size.y)) - 1) or 0)
                )

                offset.y = offset.y + h_offset
            end

            do
                local text = self.vars.p_state.other_condition and string_func(self.vars.p_state.second_condition)
                or string_func(
                    ({
                        ['stand'] = 'STANDING',
                        ['move'] = 'MOVING',
                        ['crouch'] = 'CROUCH',
                        ['crouch move'] = 'CROUCH MOVE',
                        ['slowwalk'] = 'SLOWWALK',
                        ['air crouch'] = 'AIR CROUCH',
                        ['air'] = 'AIR',
                        ['legit aa'] = 'LEGIT',
                        ['fakelag'] = 'FAKELAG'
                    })[self.vars.p_state.condition]
                )
                local text_size = vector(renderer.measure_text(font, text))

                local adder = '·'
                local adder_size = vector(renderer.measure_text(font, adder))

                local fraction = values.state.fraction(state_speed, text_size.x + 3)

                local padding = math.floor(-(text_size.x / 2) * (1 - scope_fraction) * (math.clamp(fraction, 1, (text_size.x + 3)) / (text_size.x + 3)) + (adder_size.x + 2) * scope_fraction + 3 * scope_fraction)

                renderer.text(pos.x + padding, pos.y + offset.y, 255, 255, 255, 255, font, fraction, text)

                local padding_adder_left = math.floor(((-fraction / 2) - adder_size.x) * (1 - scope_fraction) + 3 * scope_fraction)
                local padding_adder_right = math.floor((fraction / 2 + 1) * (1 + scope_fraction) + (adder_size.x - 1) * scope_fraction + 3 * scope_fraction)

                renderer.text(pos.x + padding_adder_left, pos.y + offset.y, 255, 255, 255, 255, font, nil, adder)
                renderer.text(pos.x + padding_adder_right, pos.y + offset.y, 255, 255, 255, 255, font, nil, adder)

                offset.y = offset.y + (text_size.y - 1)
            end
        end),

        style_2_values = {
            scope = smoothy:new(),
            main = {
                invert_gradient = false,
                time_last_invert = 0
            },
            state = {
                last_state = '',
                alpha = smoothy:new()
            },
            additional = {
                dt = smoothy:new({ 255, 255, 255, 255 }),
                fs = smoothy:new({ 255, 255, 255, 255 })
            },
            items = (function()
                local new_table = {}
                for i = 1, 10 do
                    new_table[i] = smoothy:new()
                end
                return new_table
            end)(),
            other_items = nil,
            offset = vector()
        },

        render_style_2 = LPH_JIT_MAX(function(self)
            local plocal = self.vars.local_player
            if not entity.is_alive(plocal) then return end

            local values = self.style_2_values

            local screen_size = self.vars.screen_size
            local pos = screen_size / 2 + vector(0, self.menu:get('visuals:indicators:height'))

            local color_ref = self.menu.colors.accent
            local color = { r = color_ref[1], g = color_ref[2], b = color_ref[3], a = 255 }

            local frametime = globals.frametime()
            local speed, state_speed, scope_speed = .045, .1, .06

            local font_style = self.menu:get('visuals:indicators:font_style')

            local font = ({
                ['small'] = '-',
                ['normal'] = '',
                ['bold'] = 'b'
            })[font_style]

            local spacing = font == '-' and '  ' or ' '
            local string_func = font == '-' and string.upper or string.lower

            local offset = vector()

            local scoped = entity.get_prop(plocal, 'm_bIsScoped') == 1
            local scope_enabled = (scoped and self.menu.multiselects_values.indicators_adjustments['move indicators on scope'])
            or (self.menu.multiselects_values.indicators_adjustments['move indicators on nade']
            and ctx.common:check_weapons(plocal, self.nade_names))

            local scope_fraction = math.clamp(values.scope(scope_speed, scope_enabled and 10.9 or -.9) / 10, 0, 1)

            do
                local items = values.other_items

                local items_offset = values.offset
                local this_offset = 0

                if items then
                    for i = 1, #items do
                        local this = items[i]

                        local alpha = values.items[i](speed, this.active() and true or false)

                        if alpha > 0 then
                            local text = string_func(this.text)
                            local text_size = vector(renderer.measure_text(font, text))

                            local clr = this.color()
                            clr[4] = clr[4] * alpha

                            local text_final = ctx.common:colored_text(text, clr)

                            local padding = math.floor(-(text_size.x / 2) * (1 - scope_fraction) * alpha + 3 * scope_fraction)

                            local curr_offset = math.ceil(items_offset.y / (1 + 1 * (1 - alpha)))

                            renderer.text(
                                pos.x + padding, pos.y + curr_offset + math.ceil(this_offset * alpha),
                                255, 255, 255, 255 * alpha, font, text_size.x * alpha + 2, text_final
                            )

                            this_offset = this_offset + math.floor(.5 + (text_size.y - 2) * alpha)
                        end
                    end
                end
            end

            do
                local text = string_func(ctx.data.version)
                local text_final = ctx.common:colored_text(text, { 120, 120, 120, 150 * math.abs(math.sin(globals.curtime())) })
                local text_size = vector(renderer.measure_text(font, text))

                local padding = math.floor(-(text_size.x / 2) * (1 - scope_fraction) + 3 * scope_fraction)

                renderer.text(pos.x + padding, pos.y + offset.y, 255, 255, 255, 255, font, nil, text_final)

                offset.y = offset.y + (text_size.y - 1)
            end

            do
                local scriptname = string_func(ctx.data.name)

                local text do
                    local txt = {}

                    for i = 1, #scriptname do
                        local curr_text = string.sub(scriptname, i, i)

                        txt[i] = curr_text
                    end

                    text = table.concat(txt, font == '-' and '    ' or ' ')
                end

                local text_final, highlight_fraction = ctx.common:gradient_text_anim(
                    text,
                    { 80, 80, 80, 255 }, { color.r, color.g, color.b, 255 },
                    4, 0, values.main.invert_gradient
                )

                if highlight_fraction < -1.88 and globals.curtime() - values.main.time_last_invert > .5 then
                    values.main.invert_gradient = not values.main.invert_gradient
                    values.main.time_last_invert = globals.curtime()
                end

                local text_size = vector(renderer.measure_text(font, text))

                local padding = math.floor(-(text_size.x / 2) * (1 - scope_fraction) + 3 * scope_fraction)

                if self.menu:get('visuals:indicators:glow') then
                    Draw:shadow(
                        pos + vector(0, offset.y) + vector(padding + 2, 3),
                        text_size + vector(-2, -5),
                        { r = color.r, g = color.g, b = color.b, a = math.max(30, math.abs(math.sin(globals.curtime())) * 80) },
                        2 + (font ~= '-' and 1 or 0), 12, true
                    )
                end

                renderer.text(pos.x + padding, pos.y + offset.y, 255, 255, 255, 255, font, nil, text_final)

                offset.y = offset.y + (text_size.y - 1)
            end

            do
                local text = self.vars.p_state.other_condition and string_func(self.vars.p_state.second_condition)
                or string_func(
                    ({
                        ['stand'] = 'STANDING',
                        ['move'] = 'MOVING',
                        ['crouch'] = 'CROUCH',
                        ['crouch move'] = 'CROUCH MOVE',
                        ['slowwalk'] = 'SLOWWALK',
                        ['air crouch'] = 'AIR CROUCH',
                        ['air'] = 'AIR',
                        ['legit aa'] = 'LEGIT',
                        ['fakelag'] = 'FAKELAG'
                    })[self.vars.p_state.condition]
                )
                local text_size = vector(renderer.measure_text(font, text))

                if text ~= values.state.last_state then
                    values.state.alpha.value = 0
                    values.state.last_state = text
                end

                local alpha = values.state.alpha(state_speed, 1)

                local padding = math.floor(-(text_size.x / 2) * (1 - scope_fraction) + 3 * scope_fraction)

                renderer.text(pos.x + padding, pos.y + offset.y, 200, 200, 200, 255 * alpha, font, nil, text)

                offset.y = offset.y + text_size.y
            end

            values.offset = offset
        end),

        style_3_values = {
            scope = 0,
            state = {
                fraction = smoothy:new()
            },
            dt = {
                fraction = 0,
                charge = 0,
                size = smoothy:new(),
                offset = smoothy:new(),
                last_text = ''
            },
            hs = {
                fraction = 0,
                charge = 0,
                size = smoothy:new(),
                offset = smoothy:new(),
                last_text = ''
            },
            other = {
                items = nil,
                values = {}
            }
        },

        font = nil,

        download_fonts = function(self)
            http.get('https://cdn.discordapp.com/attachments/884455063232348210/1049075775665606787/SMALL_FONTS.TTF', function(s, r)
                if s and r.status == 200 then
                    self.font = Ctext:create_font(r.body, 8, 0, { 0x010, 0x200 })
                end
            end)
        end,

        render_style_3 = LPH_JIT_MAX(function(self)
            local plocal = self.vars.local_player

            if not entity.is_alive(plocal) or not self.font then
                return
            end

            local values = self.style_3_values

            local screen_size = self.vars.screen_size
            local pos = screen_size / 2 + vector(0, self.menu:get('visuals:indicators:height'))

            local color_ref = self.menu.colors.accent
            local color = { r = color_ref[1], g = color_ref[2], b = color_ref[3], a = 255 }

            local frametime = globals.frametime()

            -- local font_style = self.menu:get('visuals:indicators:font_style')

            -- local font = ({
            --     ['small'] = '-',
            --     ['normal'] = '',
            --     ['bold'] = 'b'
            -- })[font_style]
            local font = '-'

            local spacing = font == '-' and ' ' or ' '
            local string_func = font == '-' and string.upper or string.lower

            local offset = vector()

            local scoped = entity.get_prop(plocal, 'm_bIsScoped') == 1
            local scope_enabled = (scoped and self.menu.multiselects_values.indicators_adjustments['move indicators on scope'])
            or (self.menu.multiselects_values.indicators_adjustments['move indicators on nade']
            and ctx.common:check_weapons(plocal, self.nade_names))

            local waiting_wpn = false do
                local wpn = entity.get_player_weapon(plocal)
                local NextPrimaryAttack = entity.get_prop(wpn, 'm_flNextPrimaryAttack') or 0

                local curtime = globals.curtime()

                waiting_wpn = NextPrimaryAttack > curtime + math.abs(NextPrimaryAttack - curtime) * .9
            end

            -- local scope_fraction = math.clamp(values.scope(.06, scope_enabled and 10.9 or -.9) / 10, 0, 1)

            values.scope = math.clamp(values.scope + (scope_enabled and frametime * 5 or -frametime * 5), 0, 1)
            local scope_fraction = easing.quad_in_out(values.scope, 0, 1, 1)

            do
                local version_final = ctx.common:gradient_text_anim(
                    string_func(ctx.data.version),
                    { 210, 210, 210, 120 }, { color.r, color.g, color.b, 255 }, 4
                )

                local text = string.format('\aFFFFFFFF%s%s%s', string_func(ctx.data.name), spacing, version_final)
                local text_size = Ctext:get_size(self.font, text)

                local padding = math.floor(-(text_size.x / 2) * (1 - scope_fraction) + 3 * scope_fraction)

                if self.menu:get('visuals:indicators:glow') then
                    Draw:shadow(
                        pos + vector(0, offset.y) + vector(padding + 2, 3),
                        text_size + vector(-2, -5),
                        { r = color.r, g = color.g, b = color.b, a = math.max(30, math.abs(math.sin(globals.curtime())) * 80) },
                        2 + (font ~= '-' and 1 or 0), 12, true
                    )
                end

                Ctext:draw(pos.x + padding, pos.y + offset.y, 255, 255, 255, 255, self.font, text)

                offset.y = offset.y + (text_size.y - 1)
            end

            do
                local text = self.vars.p_state.other_condition and string_func(self.vars.p_state.second_condition)
                or string_func(
                    ({
                        ['stand'] = 'STANDING',
                        ['move'] = 'MOVING',
                        ['crouch'] = 'CROUCH',
                        ['crouch move'] = 'CROUCH MOVE',
                        ['slowwalk'] = 'SLOWWALK',
                        ['air crouch'] = 'AIR CROUCH',
                        ['air'] = 'AIR',
                        ['legit aa'] = 'LEGIT',
                        ['fakelag'] = 'FAKELAG'
                    })[self.vars.p_state.condition]
                )
                local text_final = string.format('- %s -', text)
                local text_size = Ctext:get_size(self.font, text_final)

                local size = math.clamp(values.state.fraction(.05, text_size.x + 2), 0, text_size.x + 2)

                local padding = math.floor(-(text_size.x / 2) * (1 - scope_fraction) * (size / (text_size.x + 2)) + 3 * scope_fraction)

                Ctext:clip_rectangle(pos.x + padding + 1, pos.y + offset.y, size, text_size.y, false)
                Ctext:draw(pos.x + padding, pos.y + offset.y, 255, 255, 255, 255, self.font, text_final, 70)
                Ctext:clip_rectangle()

                offset.y = offset.y + text_size.y
            end

            local doubletap = ui.get(ref.doubletap[1]) and ui.get(ref.doubletap[2])

            do
                local doubletap_charged = self.vars.doubletap.charged
                local defensive_choking = self.vars.doubletap.defensive.active
                local quickpeek = ui.get(ref.quickpeek[1]) and ui.get(ref.quickpeek[2])

                values.dt.fraction = math.clamp(values.dt.fraction + (doubletap and frametime * 2.5 or -frametime * 2.5), 0, 1)
                local fraction = easing.quart_in_out(values.dt.fraction, 0, 1, 1)

                values.dt.charge = math.clamp(values.dt.charge + ((doubletap and fraction > .1 and not waiting_wpn) and frametime * 2 or -frametime * 2.4), 0, 1)
                local charge = easing.quart_in_out(values.dt.charge, 0, 1, 1)

                if waiting_wpn then
                    values.dt.charge = 0
                end

                if fraction > 0 then
                    local text = string.format('\aFFFFFFFF%s', quickpeek and 'IDEAL TICK' or 'DT') .. spacing .. (
                        waiting_wpn and ctx.common:colored_text(string_func('WAITING'), { 255, 0, 0, 120 })
                        or (
                            (charge == 1 and doubletap_charged) and (
                                defensive_choking
                                and ctx.common:colored_text(string_func('ACTIVE'), { 163, 223, 214, 255 })
                                or ctx.common:colored_text(string_func('READY'), { 203, 239, 172, 255 })
                            ) or ctx.common:colored_text(
                                string_func('CHARGING'),
                                ctx.common:color_swap({ 255, 50, 50, 255 }, { 203, 239, 172, 255 }, charge)
                            )
                        )
                    )

                    local text_final = values.dt.last_text
                    local text_final_size = Ctext:get_size(self.font, text_final)

                    local value = text_final_size.x

                    if doubletap then
                        values.dt.last_text = text
                    else
                        value = 0
                    end

                    local size = math.clamp(values.dt.size(.05, value + 2), 0, text_final_size.x + 2) * fraction

                    local padding = math.floor(-(text_final_size.x / 2) * (1 - scope_fraction) * (size / (text_final_size.x + 2)) + 3 * scope_fraction)

                    Ctext:clip_rectangle(pos.x + padding + 1, pos.y + offset.y, size, text_final_size.y, false)
                    Ctext:draw(pos.x + padding, pos.y + offset.y, 255, 255, 255, 255, self.font, text_final, 100)
                    Ctext:clip_rectangle()

                    Ctext:clip_rectangle(
                        pos.x + padding + 1, pos.y + offset.y,
                        (text_final_size.x + 2) * (charge * (size / (text_final_size.x + 2))), text_final_size.y, false
                    )
                    Ctext:draw(pos.x + padding, pos.y + offset.y, 255, 255, 255, 255, self.font, text_final)
                    Ctext:clip_rectangle()
                end

                offset.y = offset.y + math.floor(.5 + 10 * fraction)
            end

            do
                local hideshots = ui.get(ref.onshotaa[1]) and ui.get(ref.onshotaa[2])

                values.hs.fraction = math.clamp(values.hs.fraction + (hideshots and frametime * 2.5 or -frametime * 2.5), 0, 1)
                local fraction = easing.quart_in_out(values.hs.fraction, 0, 1, 1)

                values.hs.charge = math.clamp(values.hs.charge + (hideshots and frametime * 2 or -frametime * 2.4), 0, 1)
                local charge = easing.quart_in_out(values.hs.charge, 0, 1, 1)

                if doubletap then
                    values.hs.charge = 1
                end

                if fraction > 0 then
                    local text = string.format('\aFFFFFFFF%s', 'HIDE') .. spacing .. (
                        doubletap and ctx.common:colored_text(string_func('INACTIVE'), { 255, 50, 50, 120 })
                        or (
                            charge == 1 and (
                                waiting_wpn
                                and ctx.common:colored_text(string_func('ACTIVE'), { 163, 223, 214, 255 })
                                or ctx.common:colored_text(string_func('READY'), { 203, 239, 172, 255 })
                            ) or ctx.common:colored_text(
                                string_func('CHARGING'),
                                ctx.common:color_swap({ 255, 50, 50, 255 }, { 203, 239, 172, 255 }, charge)
                            )
                        )
                    )

                    local text_final = values.hs.last_text
                    local text_final_size = Ctext:get_size(self.font, text_final)

                    local value = text_final_size.x

                    if hideshots then
                        values.hs.last_text = text
                    else
                        value = 0
                    end

                    local size = math.clamp(values.hs.size(.05, value + 2), 0, text_final_size.x + 2) * fraction

                    local padding = math.floor(-(text_final_size.x / 2) * (1 - scope_fraction) * (size / (text_final_size.x + 2)) + 3 * scope_fraction)

                    Ctext:clip_rectangle(pos.x + padding + 1, pos.y + offset.y, size, text_final_size.y, false)
                    Ctext:draw(pos.x + padding, pos.y + offset.y, 255, 255, 255, 255, self.font, text_final, 100)
                    Ctext:clip_rectangle()

                    Ctext:clip_rectangle(
                        pos.x + padding + 1, pos.y + offset.y,
                        (text_final_size.x + 2) * (charge * (size / (text_final_size.x + 2))), text_final_size.y, false
                    )
                    Ctext:draw(pos.x + padding, pos.y + offset.y, 255, 255, 255, 255, self.font, text_final)
                    Ctext:clip_rectangle()
                end

                offset.y = offset.y + math.floor(.5 + 10 * fraction)
            end

            do
                local items = values.other.items
                local values = values.other.values

                if items then
                    for i = 1, #items do
                        local this = items[i]

                        if not values[i] then
                            values[i] = 0
                        end

                        values[i] = math.clamp(values[i] + (this.active() and frametime * 2.5 or -frametime * 2.5), 0, 1)
                        local fraction = easing.quart_in_out(values[i], 0, 1, 1)

                        if fraction > 0 then
                            local text = this.text
                            local text_size = vector(renderer.measure_text(font, text))

                            local clr = this.color

                            local text_final = ctx.common:colored_text(text, clr)

                            local padding = math.floor(-(text_size.x / 2) * (1 - scope_fraction) * fraction + 3 * scope_fraction)

                            Ctext:clip_rectangle(pos.x + padding + 1, pos.y + offset.y, (text_size.x + 2) * fraction, text_size.y, false)
                            Ctext:draw(pos.x + padding, pos.y + offset.y, 255, 255, 255, 255, self.font, text_final)
                            Ctext:clip_rectangle()

                            offset.y = offset.y + math.floor(.5 + 10 * fraction)
                        end
                    end
                end
            end
        end),

        create_other_items = function(self)
            local style_2_other_items = {
                {
                    text = 'BRUTE',
                    active = function()
                        local _, target_steamid = self.antiaim.get_target()

                        if not target_steamid or self.menu:get('aa:antiaim_preset') == 'dynamic' or not self.menu:get('aa:antibruteforce:enable') then
                            return false
                        end

                        return self.antibruteforce.values.simple[target_steamid] ~= nil and self.antibruteforce.values.simple[target_steamid].active
                    end,
                    color = function()
                        return { 223, 212, 255, 255 }
                    end
                },
                {
                    text = 'DT',
                    active = function()
                        return ui.get(ref.doubletap[1]) and ui.get(ref.doubletap[2])
                    end,
                    color = function()
                        local clr = { 255, 100, 100, 150 }

                        if self.vars.doubletap.charged then
                            clr = { 200, 255, 150, 255 }

                            if self.vars.doubletap.defensive.active then
                                clr = { 255, 255, 255, 255 }
                            end
                        end

                        return self.style_2_values.additional.dt(.05, clr)
                    end
                },
                {
                    text = 'HIDE',
                    active = function()
                        return ui.get(ref.onshotaa[1]) and ui.get(ref.onshotaa[2])
                    end,
                    color = function()
                        return { 212, 244, 255, 255 }
                    end
                },
                {
                    text = 'FS',
                    active = function()
                        return self.antiaim.freestanding.hotkey
                    end,
                    color = function()
                        local clr = { 255, 255, 255, 255 }

                        if self.antiaim.freestanding.disabled then
                            clr = { 100, 100, 100, 150 }
                        end

                        if self.antiaim.freestanding.forced then
                            clr = { 255, 150, 150, 255 }
                        end

                        return self.style_2_values.additional.fs(.05, clr)
                    end
                },
                {
                    text = 'SAFE',
                    active = function()
                        return ui.get(ref.safepoint)
                    end,
                    color = function()
                        return { 255, 255, 255, 255 }
                    end
                },
                {
                    text = 'BAIM',
                    active = function()
                        return ui.get(ref.forcebaim)
                    end,
                    color = function()
                        return { 255, 255, 255, 255 }
                    end
                },
                {
                    text = 'CROSS',
                    active = function()
                        return self.menu:get('additions:binds:cross_assistant:key') and self.menu.multiselects_values.bind_selector['cross assistant']
                    end,
                    color = function()
                        return { 255, 255, 255, 255 }
                    end
                },
                {
                    text = 'A-PEEK',
                    active = function()
                        return self.menu:get('additions:binds:automatic_peek:key') and self.menu.multiselects_values.bind_selector['automatic peek']
                    end,
                    color = function()
                        return { 255, 255, 255, 255 }
                    end
                },
                {
                    text = 'DMG',
                    active = function()
                        return ui.get(ref.dmg_override[1]) and ui.get(ref.dmg_override[2])
                    end,
                    color = function()
                        return { 255, 255, 255, 255 }
                    end
                },
                {
                    text = 'DORMANT',
                    active = function()
                        return ref.dormantaim and ui.get(ref.dormantaim[1]) and ui.get(ref.dormantaim[2])
                    end,
                    color = function()
                        return { 255, 255, 255, 120 }
                    end
                }
            }

            self.style_2_values.other_items = style_2_other_items

            local style_3_other_items = {
                {
                    text = 'FREESTAND',
                    active = function()
                        return self.antiaim.freestanding.hotkey
                    end,
                    color = { 255, 255, 255, 255 }
                },
                {
                    text = 'SAFE',
                    active = function()
                        return ui.get(ref.safepoint)
                    end,
                    color = { 255, 255, 255, 255 }
                },
                {
                    text = 'BAIM',
                    active = function()
                        return ui.get(ref.forcebaim)
                    end,
                    color = { 255, 255, 255, 255 }
                },
                {
                    text = 'DMG',
                    active = function()
                        return ui.get(ref.dmg_override[1]) and ui.get(ref.dmg_override[2])
                    end,
                    color = { 255, 255, 255, 255 }
                },
                {
                    text = 'A-PEEK',
                    active = function()
                        return self.menu:get('additions:binds:automatic_peek:key') and self.menu.multiselects_values.bind_selector['automatic peek']
                    end,
                    color = { 255, 255, 255, 255 }
                },
                {
                    text = 'DORMANT',
                    active = function()
                        return ref.dormantaim and ui.get(ref.dormantaim[1]) and ui.get(ref.dormantaim[2])
                    end,
                    color = { 200, 200, 200, 150 }
                }
            }

            self.style_3_values.other.items = style_3_other_items
        end,

        arrows_values = {
            fractions = { left = 0, right = 0, forward = 0 },
            scope = smoothy:new(),
            styles = {
                [1] = {
                    left = renderer.load_svg(
                        '<svg width="124" height="149" viewBox="0 0 124 149" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M111.382 1.24609L3.79564 67.7161C-1.27136 70.8461 -1.26336 78.2164 3.80864 81.3362L111.351 147.479C118.454 151.848 126.666 143.794 122.436 136.607L88.2884 78.5858C86.8173 76.0863 86.8143 72.9864 88.2804 70.484L122.489 12.0961C126.705 4.90008 118.477 -3.13791 111.382 1.24609Z" fill="white"/></svg>',
                        12, 12
                    ),
                    right = renderer.load_svg(
                        '<svg width="124" height="150" viewBox="0 0 124 150" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12.3725 148.088L119.959 81.618C125.026 78.488 125.018 71.1177 119.946 67.9979L12.4039 1.8547C5.30078 -2.51406 -2.91145 5.53994 1.31827 12.7267L35.4662 70.7483C36.9373 73.2478 36.9403 76.3477 35.4742 78.8501L1.26514 137.238C-2.9505 144.434 5.27804 152.472 12.3725 148.088Z" fill="white"/></svg>',
                        12, 12
                    ),
                    forward = renderer.load_svg(
                        '<svg width="149" height="124" viewBox="0 0 149 124" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M147.471 111.382L81.0005 3.79564C77.8705 -1.27136 70.5002 -1.26336 67.3804 3.80864L1.23721 111.351C-3.13155 118.454 4.92245 126.666 12.1092 122.436L70.1308 88.2884C72.6303 86.8173 75.7302 86.8143 78.2326 88.2804L136.621 122.489C143.817 126.705 151.855 118.477 147.471 111.382Z" fill="white"/></svg>',
                        12, 12
                    )
                }
            }
        },

        render_arrows = LPH_JIT_MAX(function(self)
            local plocal = self.vars.local_player
            if not entity.is_alive(plocal) then return end

            local values = self.arrows_values

            local screen_size = self.vars.screen_size

            local pos = screen_size / 2

            local color_ref = self.menu.colors.accent
            local color = { r = color_ref[1], g = color_ref[2], b = color_ref[3], a = 255 }

            local frametime = globals.frametime()

            local scoped = entity.get_prop(plocal, 'm_bIsScoped') == 1
            local scope_enabled = scoped and self.menu.multiselects_values.indicators_adjustments['move arrows on scope']

            values.scope(.06, scope_enabled and 10.9 or -.9)
            local scope_fraction = math.clamp(values.scope.value / 10, 0, 1)

            values.fractions.left = math.clamp(values.fractions.left + (self.antiaim.manual.yaw == -90 and frametime * 5 or -frametime * 5), 0, 1)
            values.fractions.right = math.clamp(values.fractions.right + (self.antiaim.manual.yaw == 90 and frametime * 5 or -frametime * 5), 0, 1)
            values.fractions.forward = math.clamp(values.fractions.forward + (self.antiaim.manual.yaw == 180 and frametime * 5 or -frametime * 5), 0, 1)

            local alpha_left = easing.linear(values.fractions.left, 0, 1, 1)
            local alpha_right = easing.linear(values.fractions.right, 0, 1, 1)
            local alpha_forward = easing.linear(values.fractions.forward, 0, 1, 1)

            local style = self.menu:get('visuals:indicators:manual_arrows:style') --{ 'modern', 'default' }
            local padding = self.menu:get('visuals:indicators:manual_arrows:padding')

            if style == 'modern' then
                if alpha_left > 0 then
                    renderer.texture(
                        values.styles[1].left,
                        pos.x - 35 - 12 + 1 - padding, pos.y - 6 - 15 * scope_fraction,
                        12, 12, color.r, color.g, color.b, 255 * alpha_left, 'f'
                    )
                end
                if alpha_right > 0 then
                    renderer.texture(
                        values.styles[1].right,
                        pos.x + 35 + padding, pos.y - 6 - 15 * scope_fraction,
                        12, 12, color.r, color.g, color.b, 255 * alpha_right, 'f'
                    )
                end
                if alpha_forward > 0 then
                    renderer.texture(values.styles[1].forward,
                    pos.x - 6, pos.y - 35 - padding - 10 - 12 * scope_fraction,
                    12, 12, color.r, color.g, color.b, 255 * alpha_forward, 'f'
                )
                end
            elseif style == 'default' then
                if alpha_left > 0 then
                    renderer.text(
                        pos.x - 35 - padding, pos.y - 2 - 15 * scope_fraction,
                        color.r, color.g, color.b, 255 * alpha_left, 'c', nil, '❰'
                    )
                end
                if alpha_right > 0 then
                    renderer.text(
                        pos.x + 35 + padding, pos.y - 2 - 15 * scope_fraction,
                        color.r, color.g, color.b, 255 * alpha_right, 'c', nil, '❱'
                    )
                end
                if alpha_forward > 0 then
                    renderer.text(
                        pos.x, pos.y - 30 - padding - 10 * scope_fraction,
                        color.r, color.g, color.b, 255 * alpha_forward, 'cb', nil, '^'
                    )
                end
            end
        end),

        on_player_hurt = function(self, e)
            local plocal = self.vars.local_player
            local victim = client.userid_to_entindex(e.userid)

            if victim ~= plocal then
                return
            end

            self.style_1_values.hurt_anim = 1
        end
    }

    :struct 'watermark' {
        images = {},
        images_downloaded = false,

        get_images = function(self)
            for key, value in pairs(ctx.data.links.watermark) do
                if value and value ~= '' then
                    self.images[key] = false

                    http.get(value, function(s, r)
                        if s and r.status == 200 then
                            self.images[key] = images.load(r.body)
                        end
                    end)
                end
            end
        end,

        outline = LPH_JIT_MAX(function(self, pos, size, thickness, rounding, clr, glow_steps)
            for i = 1, glow_steps do
                local g_alpha = math.max(80, math.abs(math.sin(globals.curtime() * 1.5)) * 150)
                g_alpha = g_alpha * ((glow_steps - (i - 1)) / glow_steps) ^ 2

                if g_alpha > 1 then
                    if glow_steps * .8 - i > 0 then
                        renderer.gradient(
                            pos.x - size.x - rounding - thickness - i, pos.y,
                            1, glow_steps * .8 - i,
                            clr.r, clr.g, clr.b, g_alpha, clr.r, clr.g, clr.b, 0, false
                        )
                    end

                    renderer.circle_outline(
                        pos.x - size.x - rounding - thickness,
                        pos.y + rounding - thickness,
                        clr.r, clr.g, clr.b, g_alpha, rounding - i, 270, .25, thickness
                    )

                    renderer.rectangle(
                        pos.x - size.x - thickness * 2 - i,
                        pos.y + rounding - thickness,
                        1, size.y - rounding * 2 + thickness * 2,
                        clr.r, clr.g, clr.b, g_alpha
                    )

                    renderer.circle_outline(
                        pos.x - size.x + rounding - thickness * 2,
                        pos.y + size.y - rounding + thickness,
                        clr.r, clr.g, clr.b, g_alpha, rounding + i, 90, .25, thickness
                    )

                    renderer.rectangle(
                        pos.x - size.x + rounding - thickness * 2,
                        pos.y + size.y + thickness - 1 + i,
                        size.x - rounding * 2 + thickness * 3, 1,
                        clr.r, clr.g, clr.b, g_alpha
                    )

                    renderer.circle_outline(
                        pos.x - rounding + thickness,
                        pos.y + size.y + rounding,
                        clr.r, clr.g, clr.b, g_alpha, rounding - i, 270, .25, thickness
                    )

                    if glow_steps * .8 - i > 0 then
                        renderer.gradient(
                            pos.x, pos.y + size.y + rounding - 1 + i,
                            i - glow_steps * .8, 1,
                            clr.r, clr.g, clr.b, g_alpha, clr.r, clr.g, clr.b, 0, true
                        )
                    end
                end
            end

            renderer.circle_outline(
                pos.x - size.x - rounding - thickness,
                pos.y + rounding - thickness,
                clr.r, clr.g, clr.b, clr.a, rounding, 270, .25, thickness
            )

            renderer.rectangle(
                pos.x - size.x - thickness * 2,
                pos.y + rounding - thickness,
                thickness, size.y - rounding * 2 + thickness * 2,
                clr.r, clr.g, clr.b, clr.a
            )

            renderer.circle_outline(
                pos.x - size.x + rounding - thickness * 2,
                pos.y + size.y - rounding + thickness,
                clr.r, clr.g, clr.b, clr.a, rounding, 90, .25, thickness
            )

            renderer.rectangle(
                pos.x - size.x + rounding - thickness * 2,
                pos.y + size.y,
                size.x - rounding * 2 + thickness * 3, thickness,
                clr.r, clr.g, clr.b, clr.a
            )

            renderer.circle_outline(
                pos.x - rounding + thickness,
                pos.y + size.y + rounding,
                clr.r, clr.g, clr.b, clr.a, rounding, 270, .25, thickness
            )
        end),

        inside = LPH_JIT_MAX(function(self, pos, size, thickness, rounding, clr)
            Draw.rectangle(
                pos - vector(size.x + thickness * 2 - 1),
                size + vector(thickness * 2 - 1, thickness),
                clr, {
                    active_corners = { false, false, false, true },
                    rounding = rounding
                }
            )

            renderer.circle_outline(
                pos.x - size.x - rounding + 1,
                pos.y + rounding - thickness,
                clr.r, clr.g, clr.b, clr.a, rounding, 270, .25, thickness + 1
            )

            renderer.circle_outline(
                pos.x - size.x - rounding + thickness * 2 + 3,
                pos.y + rounding - thickness,
                clr.r, clr.g, clr.b, clr.a, rounding, 270, .25, thickness + 2
            )

            renderer.circle_outline(
                pos.x - rounding + thickness,
                pos.y + size.y + rounding - thickness - 1,
                clr.r, clr.g, clr.b, clr.a, rounding, 270, .25, thickness + 1
            )

            renderer.circle_outline(
                pos.x - rounding + thickness,
                pos.y + size.y + rounding - thickness * 2 - 4,
                clr.r, clr.g, clr.b, clr.a, rounding, 270, .25, thickness + 2
            )
        end),

        render = LPH_JIT_MAX(function(self)
            if not self.images_downloaded then
                for key, value in pairs(self.images) do
                    if value == false then
                        return
                    end
                end

                self.images_downloaded = true
            end

            local screen_size = self.vars.screen_size
            local pos = vector(screen_size.x, 0)

            local color_ref = self.menu.colors.accent
            local color = { r = color_ref[1], g = color_ref[2], b = color_ref[3], a = 255 }

            local frametime = globals.frametime()

            local glow_steps = 7
            local thickness = 1
            local rounding = 11

            local username = ctx.data.username
            local username_size = vector(renderer.measure_text(nil, username))

            local version = ctx.data.version
            local version_size = vector(renderer.measure_text(nil, version))

            local name = string.upper(ctx.data.name)
            local name_size = vector(renderer.measure_text('b', name))

            local logo = self.images.logo
            local logo_size = vector(logo:measure()) * .8
            logo_size.x = math.floor(logo_size.x)
            logo_size.y = math.floor(logo_size.y)

            local size = vector(math.max(username_size.x, version_size.x) + 6 + math.max(name_size.x, logo_size.x) + 10, logo_size.y + name_size.y + 10)

            self:inside(pos, size, thickness, rounding, { r = 25, g = 25, b = 25, a = color.a })
            self:outline(pos, size, thickness, rounding, color, glow_steps)

            renderer.text(
                pos.x - 3,
                pos.y + size.y / 2 - username_size.y - 1,
                color.r, color.g, color.b, 200, 'r', nil, username
            )

            renderer.text(
                pos.x - 3,
                pos.y + size.y / 2 - 1,
                color.r, color.g, color.b, 200, 'r', nil, version
            )

            logo:draw(
                pos.x - size.x + thickness + logo_size.x / 2 + 1, pos.y + size.y / 2 - logo_size.y,
                logo_size.x, logo_size.y,
                color.r, color.g, color.b, math.max(200, math.abs(math.sin(globals.curtime() * 1.5)) * 255)
            )

            renderer.text(
                pos.x - size.x + thickness + logo_size.x + 1,
                pos.y + size.y / 2 + logo_size.y / 2,
                color.r, color.g, color.b, 255, 'cb', nil, name
            )
        end)
    }

    :struct 'popups' {
        logo = {
            alpha = smoothy:new()
        },
        values = {},
        all_active = false,

        images = {},
        images_downloaded = false,

        get_images = function(self)
            for key, value in pairs(ctx.data.links.popups) do
                if value and value ~= '' then
                    self.images[key] = false

                    http.get(value, function(s, r)
                        if s and r.status == 200 then
                            self.images[key] = images.load(r.body)
                        end
                    end)
                end
            end
        end,

        elements = {},

        create_elements = function(self)
            local elements = {
                {
                    index = 'cross_assistant',
                    vars = function()
                        local base_text = 'cross assistant'
                        local ready_text = 'ready'
                        local base_active = self.antiaim.cross_assistant.vars.charge_time > 0
                        local ready = self.antiaim.cross_assistant.vars.ready
                        local bar_fraction = self.antiaim.cross_assistant.vars.charge_time * 2

                        return base_text, ready_text, base_active, ready, bar_fraction
                    end
                },
                {
                    index = 'defensive_choke',
                    vars = function()
                        local ticks_from_discharge = self.vars.doubletap.defensive.active_until - globals.tickcount()

                        local base_text = 'defensive'
                        local ready_text = 'choking'
                        local base_active = ticks_from_discharge > -16
                        local ready = true
                        local bar_fraction = (self.vars.doubletap.defensive.ticks_from_activation + 1) / self.vars.doubletap.defensive.ticks

                        if not self.menu.multiselects_values.popups_elements['defensive choking'] then
                            base_active, ready = false, false
                        end

                        return base_text, ready_text, base_active, ready, bar_fraction
                    end
                },
                {
                    index = 'slowdown_warning',
                    vars = function()
                        local plocal = self.vars.local_player
                        local velocity_modifier = entity.get_prop(plocal, 'm_flVelocityModifier')

                        local base_text = 'slowed down'
                        local ready_text = string.format('%d%%', velocity_modifier * 100)
                        local base_active = velocity_modifier < 1
                        local ready = true
                        local bar_fraction = velocity_modifier

                        if not self.menu.multiselects_values.popups_elements['slowdown warning'] then
                            base_active, ready = false, false
                        end

                        return base_text, ready_text, base_active, ready, bar_fraction
                    end
                }
            }

            self.elements = elements
        end,

        render_element = LPH_JIT_MAX(function(self, index, base_text, ready_text, base_active, ready, bar_fraction, color, position, offset, glow)
            if self.values[index] == nil then
                self.values[index] = {
                    tweens = smoothy:new({
                        alpha = 0,
                        load_fraction = 0,
                        text_fraction = 1,
                        bar_fraction = 4,
                        offset = 0
                    })
                }
            end

            local speed, offset_speed = .04, .05
            local glow_steps = 9

            local this_values = self.values[index]
            local this_offset = vector()
            local spacing = ' '
            local curr_text, curr_text_size = '', 0

            this_values.tweens(speed, {
                alpha = base_active,
                load_fraction = base_active and ready
            })

            local tweens = this_values.tweens.value

            local alpha = tweens.alpha
            local load_fraction = tweens.load_fraction

            position.y = position.y + offset.y * alpha

            if alpha > 0 then
                local base_text_final = ctx.common:gradient_text(base_text, { 255, 255, 255, 255 * alpha }, { 210, 210, 210, 150 * alpha }, load_fraction)
                local base_text_size = vector(renderer.measure_text(nil, base_text))

                local ready_text_final = ctx.common:colored_text(ready_text, { color.r, color.g, color.b, 255 * alpha })
                local ready_text_size = vector(renderer.measure_text(nil, spacing .. ready_text))

                curr_text = base_text_final .. spacing .. ready_text_final
                curr_text_size = base_text_size.x

                if ready then
                    curr_text_size = base_text_size.x + ready_text_size.x
                end

                if not base_active then
                    curr_text_size = 0
                end

                this_values.tweens(speed, { text_fraction = curr_text_size + 2 })
                local text_fraction = tweens.text_fraction

                renderer.text(position.x, position.y, 255, 255, 255, 255 * alpha, 'c', text_fraction, curr_text)

                this_offset.y = this_offset.y + math.ceil(math.max(glow_steps + 2, math.max(base_text_size.y, ready_text_size.y) - 3) * alpha)

                local bar_width = base_text_size.x + ready_text_size.x
                local bar_pos = vector(position.x - math.ceil((bar_width / 2) * alpha), position.y + this_offset.y)

                if type(bar_fraction) == 'boolean' then
                    this_values.tweens(base_active and .14 or speed, {
                        bar_fraction = (bar_fraction and alpha > .9) and bar_width or 4
                    })
                elseif type(bar_fraction) == 'number' then
                    bar_fraction = math.clamp(bar_fraction, 0, 1)

                    this_values.tweens(base_active and .015 or speed, {
                        bar_fraction = alpha > .9 and math.max(bar_width * bar_fraction, 4) or 4
                    })
                end

                local bar_fraction_value = math.ceil(tweens.bar_fraction)

                if glow then
                    Draw:shadow(
                        bar_pos, vector(math.ceil((bar_width + 1) * alpha), 4),
                        { r = color.r, g = color.g, b = color.b, a = 80 * alpha }, 2, glow_steps
                    )
                end

                -- Draw.rectangle(
                --     bar_pos - vector(2, 1), vector(math.ceil((bar_width + 1) * alpha), 4) + vector(4, 2),
                --     { r = 20, g = 20, b = 20, a = 80 * alpha }, 3
                -- )

                Draw.rectangle(
                    vector(position.x - bar_fraction_value / 2, bar_pos.y), vector(bar_fraction_value + 1, 4),
                    { r = color.r, g = color.g, b = color.b, a = 255 * alpha }, 2
                )
            end

            this_values.tweens(offset_speed, { offset = alpha > .2 and 20 + glow_steps or 0 })

            local offset = math.floor(.5 + tweens.offset)

            return offset
        end),

        render = LPH_JIT_MAX(function(self)
            if not self.images_downloaded then
                for key, value in pairs(self.images) do
                    if value == false then
                        return
                    end
                end

                self.images_downloaded = true
            end

            local plocal = self.vars.local_player

            if not entity.is_alive(plocal) then
                return
            end

            local screen_size = self.vars.screen_size
            local pos = vector(screen_size.x / 2, 110)

            local color_ref = self.menu.colors.accent
            local color = { r = color_ref[1], g = color_ref[2], b = color_ref[3], a = 255 }

            local glow_enabled = self.menu:get('visuals:popups:glow')

            do
                local this_values = self.logo

                local alpha = this_values.alpha(.04, self.all_active)

                if alpha > 0 then
                    local image = self.images.logo

                    local logo_size = vector(image:measure())
                    local logo_size_final = vector(math.ceil(logo_size.x * alpha), math.ceil(logo_size.y * alpha))

                    image:draw(
                        pos.x - logo_size_final.x / 2, pos.y - (logo_size_final.y + 9) * alpha,
                        logo_size_final.x, logo_size_final.y,
                        color.r, color.g, color.b, 255 * alpha
                    )
                end
            end

            local all_active = false
            local offset = vector()

            for i = 1, #self.elements do
                local this = self.elements[i]

                if this.color then
                    color = this.color()
                end

                local base_text, ready_text, base_active, ready, bar_fraction = this.vars()

                local this_offset = self:render_element(
                    this.index, base_text, ready_text, base_active, ready, bar_fraction, color, pos, offset, glow_enabled
                )

                offset.y = offset.y + this_offset

                if base_active then
                    all_active = true
                end
            end

            self.all_active = all_active
        end)
    }

    :struct 'automatic_peek' {
        hitgroups_to_hitboxes = {
            ['Head'] = { 0 },
            ['Chest'] = { 4, 5, 6 },
            ['Stomach'] = { 2, 3 },
            ['Arms'] = { 13, 14, 15, 16, 17, 18 },
            ['Legs'] = { 7, 8, 9, 10 },
            ['Feet'] = { 11, 12 }
        },
        -- allowed_hitboxes = {
        --     0, 5, 2, 15, 17, 9, 10
        -- },
        allowed_hitboxes = {
            0, 4, 5, 6, 2, 3, 13, 14, 15, 16, 17, 18, 7, 8, 9, 10, 11, 12
        },
        -- hitgroup_names = {"generic"0, "head"1, "chest"2, "stomach"3, "left arm"4, "right arm"5, "left leg"6, "right leg"7, "neck"8, "?", "gear"}
        hitgroup_data = {
            ['Head'] = 1, -- 0
            ['Neck'] = 8, -- 1
            ['Pelvis'] = 3, -- 2
            ['Stomach'] = 3, -- 3
            ['Lower Chest'] = 2, -- 4
            ['Chest'] = 2, -- 5
            ['Upper Chest'] = 2, -- 6
            ['Left Upper Leg'] = 6, -- 7
            ['Right Upper Leg'] = 7, -- 8
            ['Left Lower Leg'] = 6, -- 9
            ['Right Lower Leg'] = 7, -- 10
            ['Left Foot'] = 6, -- 11
            ['Right Foot'] = 7, -- 12
            ['Left Hand'] = 4, -- 13
            ['Right Hand'] = 5, -- 14
            ['Left Upper Arm'] = 4, -- 15
            ['Left Lower Arm'] = 4, -- 16
            ['Right Upper Arm'] = 5, -- 17
            ['Right Lower Arm'] = 5 -- 18
        },
        hitboxes_names = {
            [0] = 'Head',
            'Neck',
            'Pelvis',
            'Stomach',
            'Lower Chest',
            'Chest',
            'Upper Chest',
            'Left Upper Leg',
            'Right Upper Leg',
            'Left Lower Leg',
            'Right Lower Leg',
            'Left Foot',
            'Right Foot',
            'Left Hand',
            'Right Hand',
            'Left Upper Arm',
            'Left Lower Arm',
            'Right Upper Arm',
            'Right Lower Arm',
        },
        active_hitboxes = {},
        returning = false,
        targeting = false,
        should_return = false,
        dt_teleport = false,
        disable_dt = false,
        cache = {
            hotkeys = {
                qickpeek_assist = {
                    enabled = nil,
                    hotkey_mode = nil,
                    mode = nil,
                    distance = nil
                },
                ping_spike = {
                    enabled = nil,
                    hotkey_mode = nil,
                    amount = nil
                }
            },
            middle_pos = vector(),
            active_point_index = 0,
            eyepos_positions = {},
            vectors_to_target = {},
            draw_data = {},
            last_returning_time = 0,
            current_target = 0
        },
        hotkeys = {
            main = false,
            force_baim = false
        },
        amount = 4,
        step_distance = 20,
        visual = {
            data = {},
            values = {
                global_alpha = smoothy:new(),
                tweens = {
                    pos = {},
                    alpha = {}
                }
            },
            active = false
        },
        skip_func = function(entindex, contents_mask)
            local ent_classname = entity.get_classname(entindex)

            if ent_classname == 'CCSPlayer' and entity.is_enemy(entindex) then
                return false
            end

            return true
        end,

        update_cached_hotkeys = function(self)
            self.cache.hotkeys.qickpeek_assist.enabled = ui.get(ref.quickpeek[1])
            self.cache.hotkeys.qickpeek_assist.hotkey_mode = self.vars.hotkey_modes[({ ui.get(ref.quickpeek[2]) })[2]]
            self.cache.hotkeys.qickpeek_assist.mode = ui.get(ref.quickpeek_assist_mode[1])
            self.cache.hotkeys.qickpeek_assist.distance = ui.get(ref.quickpeek_assist_distance)

            self.cache.hotkeys.ping_spike.enabled = ui.get(ref.ping_spike[1])
            self.cache.hotkeys.ping_spike.hotkey_mode = self.vars.hotkey_modes[({ ui.get(ref.ping_spike[2]) })[2]]
            self.cache.hotkeys.ping_spike.amount = ui.get(ref.ping_spike[3])
        end,

        create_values = function(self)
            for i = 0, self.amount do
                self.cache.vectors_to_target[i] = {}
                self.visual.data[i] = false

                self.visual.values.tweens.pos[i] = smoothy:new(vector())
                self.visual.values.tweens.alpha[i] = smoothy:new()
            end
        end,

        update_hitboxes = function(self, reference, force_baim)
            local new_hitboxes = {}
            local target_hitboxes = ui.get(reference)

            local force_baim_disabled_hitgroups = {
                'Head', 'Arms', 'Legs', 'Feet'
            }

            for i = 1, #target_hitboxes do
                if force_baim and table.contains(force_baim_disabled_hitgroups, target_hitboxes[i]) then
                    goto skip
                end

                local curr_hitgroup = self.hitgroups_to_hitboxes[target_hitboxes[i]]

                for j = 1, #curr_hitgroup do
                    local hitbox = curr_hitgroup[j]

                    if table.contains(self.allowed_hitboxes, hitbox) then
                        table.insert(new_hitboxes, hitbox)
                    end
                end

                ::skip::
            end

            self.active_hitboxes = new_hitboxes
        end,

        handle_point = function(self, position, view_offset, angle, step_distance, curr_step_mult, prev_pos, vec_mins, vec_maxs, max_step)
            local pos = (prev_pos and vector(position.x, position.y, prev_pos.z) - view_offset or position)
            local curr_pos = ctx.common:extend_vector(pos, step_distance * curr_step_mult, angle)

            if curr_step_mult > 1 then
                pos = ctx.common:extend_vector(curr_pos, -step_distance, angle)
            end

            local vertical_trace_up = trace_lib.hull(
                curr_pos,
                curr_pos + vector(0, 0, max_step),
                vec_mins, vec_maxs,
                { skip = self.skip_func, mask = 0x201400B }
            )
            local vertical_trace_up_endpos = vertical_trace_up.end_pos:clone()

            local height = vector(0, 0, math.min(max_step, math.abs(position.z - vertical_trace_up_endpos.z)))

            local horizontal_trace = trace_lib.hull(
                pos + height, curr_pos + height,
                vec_mins, vec_maxs,
                { skip = self.skip_func, mask = 0x201400B }
            )
            local horizontal_trace_endpos = horizontal_trace.end_pos:clone()

            if curr_pos:dist2d(horizontal_trace_endpos) > step_distance * .95 then
                return false
            end

            local vertical_trace_down = trace_lib.hull(
                horizontal_trace_endpos,
                vector(horizontal_trace_endpos.x, horizontal_trace_endpos.y, position.z - 240),
                vec_mins, vec_maxs,
                { skip = self.skip_func, mask = 0x201400B }
            )
            local vertical_trace_down_endpos = vertical_trace_down.end_pos:clone()

            local final_pos = vertical_trace_down_endpos + view_offset

            return final_pos
        end,

        setup_points = function(self, plocal, position, angle, amount, step_distance)
            local view_offset = vector(entity.get_prop(plocal, 'm_vecViewOffset'))
            local vec_mins = vector(entity.get_prop(plocal, 'm_vecMins'))
            local vec_maxs = vector(entity.get_prop(plocal, 'm_vecMaxs'))
            local max_step = 18

            local middle_point = self:handle_point(position, view_offset, angle, step_distance, 0, nil, vec_mins, vec_maxs, max_step)

            self.cache.eyepos_positions[0] = middle_point
            self.visual.data[0] = middle_point

            for side = 1, 2 do
                for i = 1, amount / 2 do
                    local curr_step = i
                    local index = side == 1 and i or i + amount / 2
                    local angle = side == 1 and angle - 90 or angle + 90

                    local prev_point = self.cache.eyepos_positions[index == (amount / 2) + 1 and 0 or index - 1]

                    local curr_point = self:handle_point(
                        position, view_offset, angle,
                        step_distance, curr_step, prev_point,
                        vec_mins, vec_maxs, max_step, index
                    )

                    if index >= 1 then
                        if prev_point and curr_point
                        and math.abs(prev_point.z - curr_point.z) > max_step then
                            for k = index, side == 1 and amount / 2 or amount do
                                self.cache.eyepos_positions[k] = false
                                self.visual.data[k] = false
                            end

                            break
                        elseif not curr_point then
                            for k = index, side == 1 and amount / 2 or amount do
                                self.cache.eyepos_positions[k] = false
                                self.visual.data[k] = false
                            end

                            break
                        end
                    end

                    self.cache.eyepos_positions[index] = curr_point
                    self.visual.data[index] = curr_point
                end
            end

            return self.cache.eyepos_positions
        end,

        trace_enemy = function(self, positions, plocal, target, hitboxes)
            local target_health = entity.get_prop(target, 'm_iHealth')
            local minimum_damage = (ui.get(ref.dmg_override[1]) and ui.get(ref.dmg_override[2])) and ui.get(ref.dmg_override[3]) or ui.get(ref.minimum_damage)

            for i = 1, #positions do
                local curr_pos = positions[i]

                self.cache.vectors_to_target[i] = {}

                if curr_pos then
                    for j = 1, #hitboxes do
                        local curr_hitbox = hitboxes[j]

                        local curr_hitbox_pos = vector(entity.hitbox_position(target, curr_hitbox))

                        -- local fraction, entindex = client.trace_line(
                        --     plocal,
                        --     curr_pos.x, curr_pos.y, curr_pos.z,
                        --     curr_hitbox_pos.x, curr_hitbox_pos.y, curr_hitbox_pos.z
                        -- ) -- doesnt trace through walls?

                        -- if entindex ~= 0 and entindex ~= -1 and entity.get_classname(entindex) == 'CCSPlayer' then
                        -- end

                        local hitbox_name = self.hitboxes_names[curr_hitbox]
                        local hitgroup = self.hitgroup_data[hitbox_name]

                        if hitbox_name == 'Head' then
                            local angle_from_head_to_origin = vector(curr_hitbox_pos:to(vector(entity.get_origin(target))):angles()).y
                            curr_hitbox_pos = ctx.common:extend_vector(
                                curr_hitbox_pos, -3.7, angle_from_head_to_origin
                            )
                            curr_hitbox_pos.z = curr_hitbox_pos.z + 3.6
                        end

                        local entindex, dmg = client.trace_bullet(
                            plocal,
                            curr_pos.x, curr_pos.y, curr_pos.z,
                            curr_hitbox_pos.x, curr_hitbox_pos.y, curr_hitbox_pos.z,
                            false
                        )

                        -- self.cache.vectors_to_target[i][j] = { curr_pos, curr_hitbox_pos, dmg, hitbox_name }

                        if dmg >= math.min(minimum_damage, target_health) and dmg > 0 then
                            return curr_pos, i
                        end
                    end
                end
            end

            return nil, 0
        end,

        weapon_can_fire = function(self, player, weapon)
            local lp_NextAttack = entity.get_prop(player, 'm_flNextAttack')
            local wpn_NextPrimaryAttack = entity.get_prop(weapon, 'm_flNextPrimaryAttack')

            if math.max(0, lp_NextAttack or 0, wpn_NextPrimaryAttack or 0) > globals.curtime() or entity.get_prop(weapon, 'm_iClip1') <= 0 then
                return false
            end

            return true
        end,

        can_target = function(self, plocal, target)
            local lp_wpn = entity.get_player_weapon(plocal)

            if not self:weapon_can_fire(plocal, lp_wpn) then
                return false
            end

            local need_scope = false do
                local scope_weapons = {
                    'CWeaponSSG08',
                    'CWeaponAWP',
                    'CWeaponG3SG1',
                    'CWeaponSCAR20'
                }

                if not ui.get(ref.auto_scope) and table.contains(scope_weapons, entity.get_classname(lp_wpn)) then
                    need_scope = entity.get_prop(plocal, 'm_bIsScoped') ~= 1
                end
            end

            if need_scope then
                return false
            end

            local need_charge = false do
                if self.vars.doubletap.active then
                    need_charge = not self.vars.doubletap.charged
                end
            end

            if need_charge then
                return false
            end

            local velocity_modifier = entity.get_prop(plocal, 'm_flVelocityModifier')

            local esp_data = entity.get_esp_data(target)
            local esp_alpha = esp_data and esp_data.alpha or 0

            return velocity_modifier == 1 and esp_alpha > .5
        end,

        handle = function(self, cmd)
            local main_key = self.menu:get('additions:binds:automatic_peek:key') and self.menu.multiselects_values.bind_selector['automatic peek']

            if main_key and not self.hotkeys.main then
                self.cache.hotkeys.qickpeek_assist.enabled = ui.get(ref.quickpeek[1])
                self.cache.hotkeys.qickpeek_assist.hotkey_mode = self.vars.hotkey_modes[({ ui.get(ref.quickpeek[2]) })[2]]
                self.cache.hotkeys.qickpeek_assist.mode = ui.get(ref.quickpeek_assist_mode[1])
                self.cache.hotkeys.qickpeek_assist.distance = ui.get(ref.quickpeek_assist_distance)

                self.cache.hotkeys.ping_spike.enabled = ui.get(ref.ping_spike[1])
                self.cache.hotkeys.ping_spike.hotkey_mode = self.vars.hotkey_modes[({ ui.get(ref.ping_spike[2]) })[2]]
                self.cache.hotkeys.ping_spike.amount = ui.get(ref.ping_spike[3])

                local plocal = self.vars.local_player
                local lp_origin = vector(entity.get_origin(plocal))
                local lp_pos = ctx.common:extrapolate_position(plocal, lp_origin, 13, true)

                self.cache.middle_pos = lp_pos

                self.hotkeys.main = true
            elseif not main_key and self.hotkeys.main then
                ui.set(ref.quickpeek[1], self.cache.hotkeys.qickpeek_assist.enabled)
                ui.set(ref.quickpeek[2], self.cache.hotkeys.qickpeek_assist.hotkey_mode)
                ui.set(ref.quickpeek_assist_mode[1], self.cache.hotkeys.qickpeek_assist.mode)
                ui.set(ref.quickpeek_assist_distance, self.cache.hotkeys.qickpeek_assist.distance)

                ui.set(ref.ping_spike[1], self.cache.hotkeys.ping_spike.enabled)
                ui.set(ref.ping_spike[2], self.cache.hotkeys.ping_spike.hotkey_mode)
                ui.set(ref.ping_spike[3], self.cache.hotkeys.ping_spike.amount)

                self.hotkeys.main = false
            end

            if ui.get(ref.forcebaim) and not self.hotkeys.force_baim then
                self:update_hitboxes(ref.target_hitbox, true)

                self.hotkeys.force_baim = true
            elseif not ui.get(ref.forcebaim) and self.hotkeys.force_baim then
                self:update_hitboxes(ref.target_hitbox)

                self.hotkeys.force_baim = false
            end

            if not main_key then
                self.returning = false
                self.targeting = false
                self.should_return = false
                self.dt_teleport = false
                self.disable_dt = false
                self.visual.active = false
                return
            end

            local plocal = self.vars.local_player

            local move_mode = self.menu:get('additions:binds:automatic_peek:move_mode')

            self.antiaim.defensive.disable = true

            self.antiaim.freestanding.force_on = true
            -- self.antiaim.edge_yaw.force_on = true

            ui.set(ref.quickpeek[1], true)
            ui.set(ref.quickpeek[2], 'Always on')
            -- ui.set(ref.quickpeek_assist_mode[1], { 'Retreat on shot', 'Retreat on key release' })
            ui.set(ref.quickpeek_assist_distance, math.floor((self.amount * self.step_distance) / 2) + 30)
            ui.set(ref.ping_spike[1], true)
            ui.set(ref.ping_spike[2], 'Always on')
            ui.set(ref.ping_spike[3], 200)

            local m_vecVelocity = vector(entity.get_prop(plocal, 'm_vecVelocity'))
            local lp_velocity = m_vecVelocity:length2d()

            local local_override = bit.band(entity.get_prop(plocal, 'm_fFlags'), bit.lshift(1, 0)) ~= 1
            or (cmd.in_forward == 1 or cmd.in_moveleft == 1 or cmd.in_moveright == 1 or cmd.in_back == 1 or cmd.in_jump == 1)

            local middle_pos = self.cache.middle_pos

            local lp_origin = vector(entity.get_origin(plocal))

            local dist_to_middle = middle_pos:dist2d(lp_origin)

            if (move_mode == 'Offensive') and not self.targeting and not self.returning
            or (dist_to_middle > .5 and (lp_velocity < 1.02 and lp_velocity ~= 0)) then
                self.cache.middle_pos = lp_origin
            end

            local target = self.menu:get('additions:binds:automatic_peek:target_mode') == 'current threat'
            and client.current_threat()
            or ctx.common:get_nearest_player(ctx.common:get_players(true, false, false, true, false))

            self.cache.current_target = target

            local angle = target and vector(middle_pos:to(vector(entity.get_origin(target))):angles()).y or vector(client.camera_angles()).y

            local positions = self:setup_points(plocal, middle_pos, angle, self.amount, self.step_distance)

            self.visual.active = true

            local active_point_pos, active_point_index = nil, 0

            if target and not local_override and self:can_target(plocal, target) then
                active_point_pos, active_point_index = self:trace_enemy(positions, plocal, target, self.active_hitboxes)
            end

            self.cache.active_point_index = active_point_index

            if active_point_pos then
                self.targeting = true
            else
                self.targeting = false
            end

            if move_mode == 'Defensive' then
                self.should_return = true
            end

            if self.targeting then
                ctx.common:set_movement(cmd, active_point_pos, plocal)
                self.returning = false
                self.should_return = true
                self.disable_dt = false
            elseif local_override then
                self.returning = false
                self.should_return = false
                self.dt_teleport = false
                self.disable_dt = false
            elseif self.should_return then
                self.returning = true
                self.dt_teleport = true
            end

            if self.returning then
                if dist_to_middle < .5 then
                    self.returning = false
                    self.should_return = false
                    self.dt_teleport = false
                    self.disable_dt = false
                elseif self.dt_teleport
                and self.vars.doubletap.charged
                and self.cache.last_returning_time == globals.tickcount() - 9 then --previous 5
                    cmd.discharge_pending = true
                    self.antiaim.doubletap.disable = true
                    self.dt_teleport = false
                    self.disable_dt = true
                else
                    self.antiaim.defensive.force = true
                    cmd.force_defensive = true
                end
            end

            ui.set(ref.quickpeek_assist_mode[1], self.returning and { 'Retreat on shot', 'Retreat on key release' } or self.cache.hotkeys.qickpeek_assist.mode)

            if not self.returning then
                self.cache.last_returning_time = globals.tickcount()
            end

            if self.disable_dt then
                self.antiaim.doubletap.disable = true
            end
        end,

        render = LPH_NO_VIRTUALIZE(function(self)
            local plocal = self.vars.local_player

            if not entity.is_alive(plocal) or not (ui.get(ref.third_person_alive[1]) and ui.get(ref.third_person_alive[2])) then
                return
            end

            local enabled = self.visual.active
            local values = self.visual.values

            local g_alpha = values.global_alpha(.04, enabled)

            if g_alpha <= 0 then
                return
            end

            local data = self.visual.data
            local color = self.menu.colors.accent
            local active_point = self.cache.active_point_index

            for i = 0, #data do
                local this = data[i]
                local curr_pos = this

                local alpha = values.tweens.alpha[i](.04, curr_pos and enabled)

                if alpha > 0 then
                    if curr_pos then
                        values.tweens.pos[i](
                            alpha > .15 and .015 or 0,
                            (active_point == i and curr_pos + vector(0, 0, 1.5) or curr_pos) + vector(0, 0, -26 + 4 * alpha)
                        )
                    end

                    local curr_pos_screen = vector(renderer.world_to_screen(values.tweens.pos[i].value:unpack()))

                    if curr_pos_screen.x ~= 0 then
                        local color_final = active_point == i and color or { 255, 255, 255, 255 }

                        renderer.circle(
                            curr_pos_screen.x, curr_pos_screen.y,
                            color_final[1], color_final[2], color_final[3], (100 + 155 * (active_point == i and 1 or 0)) * alpha,
                            2.5, 0, 1
                        )
                    end
                end

                local prev_index = i
                local curr_index = i + 1

                if i == (#data / 2) then
                    prev_index = 0
                end

                if curr_index <= #data then
                    local curr_alpha = values.tweens.alpha[curr_index].value

                    if curr_alpha > 0 then
                        local line_prev_screenpos = vector(renderer.world_to_screen(values.tweens.pos[prev_index].value:unpack()))
                        local line_curr_screenpos = vector(renderer.world_to_screen(values.tweens.pos[curr_index].value:unpack()))

                        if line_prev_screenpos.x ~= 0 and line_curr_screenpos.x ~= 0 then
                            renderer.line(
                                line_prev_screenpos.x, line_prev_screenpos.y,
                                line_curr_screenpos.x, line_curr_screenpos.y,
                                255, 255, 255, 50 * curr_alpha
                            )
                        end
                    end
                end
            end

            -- self.cache.vectors_to_target[i][j] = { curr_pos, curr_hitbox_pos, scaled_dmg, hitbox_name }

            -- for i = 1, #self.cache.vectors_to_target do
            --     local J = self.cache.vectors_to_target[i]

            --     for j = 1, #J do
            --         local this = J[j]

            --         local frompos = this[1]
            --         local topos = this[2]

            --         local frompos_screen = vector(renderer.world_to_screen(frompos:unpack()))
            --         local topos_screen = vector(renderer.world_to_screen(topos:unpack()))

            --         renderer.line(frompos_screen.x, frompos_screen.y, topos_screen.x, topos_screen.y, 255, 255, 255, 30 * g_alpha)
            --         -- renderer.text(topos_screen.x, topos_screen.y, 255, 255, 255, 255, 'c', nil, this[4])
            --         renderer.circle(topos_screen.x, topos_screen.y, 255, 255, 255, 255, 2, 0, 1)
            --     end
            -- end
        end)
    }

    :struct 'aimbot_logs' {
        weapon_to_verb = { knife = 'Knifed', hegrenade = 'Naded', inferno = 'Burned' },
        data = {},

        on_aim_fire = function(self, e)
            self.data[e.id] = e
        end,

        on_aim_hit = function(self, e)
            if self.data[e.id] == nil or not self.menu:contains('misc:aimbot_log:types', 'hit') then
                return
            end

            local on_fire_data = self.data[e.id]

            local target_health = entity.get_prop(e.target, 'm_iHealth')
            local target_name = string.sub(entity.get_player_name(e.target), 1, 15)
            local hitgroup = self.vars.hitgroup_names[e.hitgroup] or '?'
            local hitchance = math.floor(.5 + e.hit_chance)
            local on_fire_hitgroup = self.vars.hitgroup_names[on_fire_data.hitgroup] or '?'
            local on_fire_hitchance = math.floor(.5 + on_fire_data.hit_chance)

            if self.menu:contains('misc:aimbot_log', 'notify') then
                self.notifier:add({
                    time = self.notifier.time.medium,
                    text = {
                        { 'Hit ' },
                        { target_name, true },
                        { '\'s ' },
                        { hitgroup, true },
                        { ' for ' },
                        { e.damage, true },
                        { ' damage (' },
                        target_health > 0 and { target_health, true } or { 'dead', true },
                        target_health > 0 and { ' hp remaining)' } or { ')' }
                    }
                })
            end

            if self.menu:contains('misc:aimbot_log', 'console') then
                local color = self.menu.colors.accent

                if hitgroup == on_fire_hitgroup and e.damage == on_fire_data.damage then
                    self.handlers:console_message(color, {
                        { 'Hit ' },
                        { target_name, true },
                        { '\'s ' },
                        { hitgroup, true },
                        { ' for ' },
                        { e.damage, true },
                        { ' [remaining: ' },
                        target_health > 0 and { target_health, true } or { 'dead', true },
                        target_health > 0 and { ' hp, HC: ' } or { ', HC: ' },
                        { on_fire_hitchance ..'%', true },
                        { ']' }
                    })
                else
                    self.handlers:console_message(color, {
                        { 'Hit ' },
                        { target_name, true },
                        { '\'s ' },
                        { hitgroup, true },
                        { ' for ' },
                        { e.damage, true },
                        { ' [aimed: ' },
                        { on_fire_hitgroup, true },
                        { ':' },
                        { on_fire_data.damage, true },
                        { ' dmg, remaining: ' },
                        target_health > 0 and { target_health, true } or { 'dead', true },
                        target_health > 0 and { ' hp, HC: ' } or { ', HC: ' },
                        { on_fire_hitchance ..'%', true },
                        { ']' }
                    })
                end
            end
        end,

        on_aim_miss = function(self, e)
            if self.data[e.id] == nil or not self.menu:contains('misc:aimbot_log:types', 'miss') then
                return
            end

            local on_fire_data = self.data[e.id]

            local target_health = entity.get_prop(e.target, 'm_iHealth')
            local target_name = string.sub(entity.get_player_name(e.target), 1, 15)
            local hitgroup = self.vars.hitgroup_names[e.hitgroup] or '?'
            local hitchance = math.floor(.5 + e.hit_chance)
            local on_fire_hitgroup = self.vars.hitgroup_names[on_fire_data.hitgroup] or '?'
            local on_fire_hitchance = math.floor(.5 + on_fire_data.hit_chance)
            local reason = e.reason == '?' and 'correction' or e.reason

            if self.menu:contains('misc:aimbot_log', 'notify') then
                self.notifier:add({
                    time = self.notifier.time.medium,
                    color = { r = 255, g = 90, b = 90 },
                    text = {
                        { 'Missed ' },
                        { target_name, true },
                        { '\'s ' },
                        { on_fire_hitgroup, true },
                        { ' due to ' },
                        { reason, true }
                    }
                })
            end

            if self.menu:contains('misc:aimbot_log', 'console') then
                self.handlers:console_message({ 255, 90, 90 }, {
                    { 'Missed ' },
                    { target_name, true },
                    { '\'s ' },
                    { on_fire_hitgroup, true },
                    { ' due to ' },
                    { reason, true },
                    { ' [aimed: ' },
                    { on_fire_hitgroup, true },
                    { ':' },
                    { on_fire_data.damage, true },
                    { ' dmg, remaining: ' },
                    target_health > 0 and { target_health, true } or { 'dead', true },
                    target_health > 0 and { ' hp, HC: ' } or { ', HC: ' },
                    { on_fire_hitchance ..'%', true },
                    { ']' }
                })
            end
        end,

        on_player_death = function(self, e)

        end,

        on_player_hurt = function(self, e)
            if not self.menu:contains('misc:aimbot_log:types', 'utility') then
                return
            end

            local plocal = entity.get_local_player()
            local target = client.userid_to_entindex(e.userid)
            local attacker = client.userid_to_entindex(e.attacker)
            local target_health = entity.get_prop(target, 'm_iHealth')
            local hitgroup = self.vars.hitgroup_names[e.hitgroup] or '?'
            local action_name = self.weapon_to_verb[e.weapon]
            local target_name = string.sub(entity.get_player_name(target), 1, 15)

            if target_health == nil or target == plocal or attacker ~= plocal or hitgroup ~= 'generic' or action_name == nil then
                return
            end

            target_health = target_health - e.dmg_health

            if self.menu:contains('misc:aimbot_log', 'notify') then
                self.notifier:add({
                    time = self.notifier.time.medium,
                    text = {
                        { action_name ..' ' },
                        { target_name, true },
                        { ' for ' },
                        { e.dmg_health, true },
                        { ' (' },
                        target_health > 0 and { target_health, true } or { 'dead', true },
                        target_health > 0 and { ' hp remaining)' } or { ')' }
                    }
                })
            end

            if self.menu:contains('misc:aimbot_log', 'console') then
                local color = self.menu.colors.accent

                self.handlers:console_message(color, {
                    { action_name ..' ' },
                    { target_name, true },
                    { ' for ' },
                    { e.dmg_health, true },
                    target_health > 0 and { ' [remaining: ' } or { ' [' },
                    target_health > 0 and { target_health, true } or { 'dead', true },
                    target_health > 0 and { ' hp]' } or { ']' }
                })
            end
        end,

        on_dormant_hit = function(self, e)
            -- userid - user ID of who was hurt
            -- attacker - user ID of who attacked
            -- health - remaining health points
            -- armor - remaining armor points
            -- weapon - weapon name attacker used
            -- dmg_health - damage done to health
            -- dmg_armor - damage done to armor
            -- hitgroup - hitgroup that was damaged
            -- accuracy - accuracy of the shot that was taken
            -- aim_hitbox - targeted hitbox

            -- [gamesense] [DA] Hit xy0 in the stomach for 26 damage (74 health remaining) (98% accuracy)
            -- [gamesense] 3 2 74 97 ssg08 26 2 3 0.98440504074097 Stomach

            if not self.menu:contains('misc:aimbot_log:types', 'dormant') then
                return
            end

            local target = e.userid
            local accuracy = math.floor(.5 + e.accuracy * 100)
            local target_health = e.health
            local target_name = string.sub(entity.get_player_name(target), 1, 15)

            if self.menu:contains('misc:aimbot_log', 'notify') then
                self.notifier:add({
                    time = self.notifier.time.medium,
                    text = {
                        { 'Dormant Hit ' },
                        { target_name, true },
                        { '\'s ' },
                        { string.lower(e.aim_hitbox), true },
                        { ' for ' },
                        { e.dmg_health, true },
                        { ' (' },
                        target_health > 0 and { target_health, true } or { 'dead', true },
                        target_health > 0 and { ' hp remaining)' } or { ')' }
                    }
                })
            end

            if self.menu:contains('misc:aimbot_log', 'console') then
                local color = self.menu.colors.accent

                self.handlers:console_message(color, {
                    { 'Dormant Hit ' },
                    { target_name, true },
                    { '\'s ' },
                    { string.lower(e.aim_hitbox), true },
                    { ' for ' },
                    { e.dmg_health, true },
                    { ' [remaining: ' },
                    { target_health, true },
                    { ' hp, accuracy: ' },
                    { accuracy, true },
                    { '%]' }
                })
            end
        end,

        on_dormant_miss = function(self, e)
            -- userid - user ID of target
            -- aim_hitbox - targeted hitbox
            -- aim_point - targeted hitbox multi point position
            -- accuracy - accuracy of the shot that was taken

            -- [gamesense] [DA] Missed xy0's Stomach (mp=Middle) (67% accuracy)
            -- [gamesense] 3 Stomach Middle 0.66856378316879

            if not self.menu:contains('misc:aimbot_log:types', 'dormant') then
                return
            end

            local target = e.userid
            local accuracy = math.floor(.5 + e.accuracy * 100)
            local target_name = string.sub(entity.get_player_name(target), 1, 15)

            if self.menu:contains('misc:aimbot_log', 'notify') then
                self.notifier:add({
                    time = self.notifier.time.medium,
                    text = {
                        { 'Dormant Missed ' },
                        { target_name, true },
                        { '\'s ' },
                        { string.lower(e.aim_hitbox), true }
                    }
                })
            end

            if self.menu:contains('misc:aimbot_log', 'console') then
                local color = self.menu.colors.accent

                self.handlers:console_message(color, {
                    { 'Dormant Missed ' },
                    { target_name, true },
                    { '\'s ' },
                    { string.lower(e.aim_hitbox), true },
                    { ' [multipoint: ' },
                    { string.lower(e.aim_point), true },
                    { ', accuracy: ' },
                    { accuracy, true },
                    { '%]' }
                })
            end
        end,

        on_round_start = function(self)
            self.shots = {}
        end
    }

    :struct 'animation_breaker' {
        ground_ticks = 1,
        end_time = 0,

        handle = LPH_NO_VIRTUALIZE(function(self)
            local plocal = self.vars.local_player

            if not entity.is_alive(plocal) then
                return
            end

            if self.menu.multiselects_values.animation_breakers['legs on ground'] then
                local leg_breaker = self.menu:get('misc:leg_breaker')

                if leg_breaker == 'jitter' then
                    entity.set_prop(plocal, 'm_flPoseParameter', 1, globals.tickcount() % 2)

                    -- ui.set(ref.leg_movement, globals.tickcount() % 2 == 0 and 'Off' or 'Always slide')
                    if not self.antiaim.override_leg_movement then
                        ui.set(ref.leg_movement, 'Always slide')
                    end
                elseif leg_breaker == 'moonwalk' then
                    entity.set_prop(plocal, 'm_flPoseParameter', -1, 7)

                    if not self.antiaim.override_leg_movement then
                        ui.set(ref.leg_movement, 'Never slide')
                    end
                end
            end

            if self.menu.multiselects_values.animation_breakers['legs in air'] then
                entity.set_prop(plocal, 'm_flPoseParameter', 1, 6)
            end

            if self.menu.multiselects_values.animation_breakers['pitch zero on land'] then
                local on_ground = bit.band(entity.get_prop(plocal, 'm_fFlags'), 1)

                if on_ground == 1 then
                    self.ground_ticks = self.ground_ticks + 1
                else
                    self.ground_ticks = 0
                    self.end_time = globals.curtime() + 1
                end

                if self.ground_ticks > ui.get(ref.fakelag_limit) + 1 and self.end_time > globals.curtime() then
                    entity.set_prop(plocal, 'm_flPoseParameter', .5, 12)
                end
            end
        end)
    }

    :struct 'clantag' {
        clan_tag_prev = '',
        disable_clantag = false,

        gamesense_anim = LPH_JIT_MAX(function(self, text, indices)
            local text_anim = '               '.. text ..'                      '
            local tickinterval = globals.tickinterval()
            local tickcount = globals.tickcount() + toticks(client.latency())
            local i = tickcount / toticks(.3)
            i = math.floor(i % #indices)
            i = indices[i + 1] + 1

            return string.sub(text_anim, i, i + 15)
        end),

        run_animation = LPH_JIT_MAX(function(self)
            local clan_tag = self:gamesense_anim(
                string.lower(ctx.data.name),
                { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 }
            )
            if clan_tag ~= self.clan_tag_prev then
                client.set_clan_tag(clan_tag)
            end
            self.clan_tag_prev = clan_tag

            self.disable_clantag = true
        end),

        on_paint = LPH_JIT_MAX(function(self)
            local plocal = self.vars.local_player
            if plocal ~= nil and (not entity.is_alive(plocal)) and globals.tickcount() % 2 == 0 then
                self:run_animation()
            end
        end),

        on_run_command = LPH_JIT_MAX(function(self, cmd)
            if cmd.chokedcommands == 0 then
                self:run_animation()
            end
        end),

        reset = LPH_JIT_MAX(function(self)
            if self.disable_clantag then
                client.set_clan_tag('\0')
                self.disable_clantag = false
            end
        end)
    }

    :struct 'notifier' {
        data = {
            queue = {},
            active = {}
        },
        types = {},
        time = {
            long = 6,
            medium = 4,
            short = 3
        },
        max = 5,

        images = {},
        images_downloaded = false,

        get_images = function(self)
            for key, value in pairs(ctx.data.links.notifier) do
                if value and value ~= '' then
                    self.images[key] = false

                    http.get(value, function(s, r)
                        if s and r.status == 200 then
                            self.images[key] = images.load(r.body)
                        end
                    end)
                end
            end
        end,

        render = LPH_JIT_MAX(function(self)
            if not self.images_downloaded then
                for key, value in pairs(self.images) do
                    if value == false then
                        return
                    end
                end

                self.images_downloaded = true
            end

            local screen_size = self.vars.screen_size

            local realtime = globals.realtime()
            local frametime = globals.frametime()

            local rounding = 6
            local glow_steps = 8
            local h_offset = glow_steps + 1
            local text_offset = 5

            local initpos = vector(screen_size.x / 2, screen_size.y - 50 - self.menu:get('visuals:notifier:height'))

            for i = #self.data.active, 1, -1 do
                local this = self.data.active[i]
                if not this then return end

                if not this.time.created then
                    this.time.value = realtime + this.time_add + 999
                    this.time.created = true
                end

                if i > self.max then
                    self.data.active[1].started_hiding = true
                end

                this.alpha = math.clamp(this.alpha + (not this.started_hiding and frametime * 5 or -frametime * 5), 0, 1)
                local alpha = easing.quad_in_out(this.alpha, 0, 1, 1)

                if alpha <= 0 or (i == 1 and this.started_hiding and #self.data.active > self.max + 1) then
                    table.remove(self.data.queue, i)
                    table.remove(self.data.active, i)
                end

                local color = { r = this.color.r, g = this.color.g, b = this.color.b, a = 255 * alpha }

                local prefix_text = ctx.data.name
                local prefix_text_size = vector(renderer.measure_text('b', prefix_text))

                local prefix_logo = self.images[this.icon]
                local prefix_logo_size = vector(prefix_logo:measure())

                local prefix_size = this.prefix == 'icon' and prefix_logo_size or prefix_text_size

                local text do
                    local txt = {}

                    for i = 1, #this.text do
                        local curr_text = this.text[i]

                        local curr_color = curr_text[2] and this.color or { r = 255, g = 255, b = 255 }

                        txt[i] = ctx.common:colored_text(curr_text[1], { curr_color.r, curr_color.g, curr_color.b, color.a })
                    end

                    text = table.concat(txt)
                end

                local text_size = vector(renderer.measure_text(nil, text))

                local pos = initpos:clone()
                local height = 21

                local curr_offset = i do
                    if i > 1 and self.data.active[1].started_hiding then
                        curr_offset = curr_offset - 1
                    end
                end

                if not this.created then
                    this.fraction.value = vector(0, -(height + h_offset) * (curr_offset - 2))
                    this.size.value = text_offset * 3
                    this.created = true
                end

                local position = vector(0, -((height + h_offset) * (curr_offset - 1)))

                if this.started_hiding and i == 1 then
                    position.y = height + h_offset
                end

                local this_fraction = this.fraction(.1, position)

                pos.y = pos.y + math.floor(.5 + this_fraction.y)

                local left_box_size = vector(text_offset + prefix_size.x + text_offset, height - 2)
                local right_box_size = vector(text_offset + text_size.x + text_offset, height)

                local rwidth = math.floor(
                    .5 + this.size(
                        .06,
                        (alpha == 1 and not (realtime > this.time.value and i == 1)) and right_box_size.x or text_offset * 3
                    )
                )

                pos.x = pos.x - math.floor(math.ceil((left_box_size.x + 1) * alpha) / 2 + rwidth / 2)

                if not this.time.started and rwidth + 1 > right_box_size.x then
                    this.time.value = realtime + this.time_add
                    this.time.started = true
                end

                if this.time.started and rwidth - 1 < text_offset * 3 then
                    this.started_hiding = true
                end

                local offset = 0

                Draw.rectangle(
                    pos + vector(0, 1),
                    vector(math.max(rounding * 2, left_box_size.x * alpha + rounding / 2), left_box_size.y),
                    { r = 30, g = 30, b = 30, a = color.a }, {
                        active_corners = { true, false, false, true },
                        rounding = rounding
                    }
                )

                offset = offset + math.ceil(left_box_size.x * alpha) + 1

                Draw.rectangle(
                    pos + vector(offset),
                    vector(rwidth, height),
                    { r = 30, g = 30, b = 30, a = color.a }, rounding
                )

                renderer.rectangle(
                    pos.x - 1 + offset, pos.y + rounding,
                    1, height - rounding * 2, color.r, color.g, color.b, color.a
                )
                renderer.circle_outline(
                    pos.x + rounding + offset, pos.y + rounding,
                    color.r, color.g, color.b, color.a, rounding + 1, 180, .25, 1
                )
                renderer.circle_outline(
                    pos.x + rounding + offset, pos.y + height - rounding,
                    color.r, color.g, color.b, color.a, rounding + 1, 90, .25, 1
                )
                renderer.gradient(
                    pos.x + rounding + offset, pos.y - 1,
                    left_box_size.x * .25, 1, color.r, color.g, color.b, color.a, 0, 0, 0, 0, true
                )
                renderer.gradient(
                    pos.x + rounding + offset, pos.y + height,
                    left_box_size.x * .25, 1, color.r, color.g, color.b, color.a, 0, 0, 0, 0, true
                )

                renderer.rectangle(
                    pos.x + offset + rwidth, pos.y + rounding,
                    1, height - rounding * 2, color.r, color.g, color.b, color.a
                )
                renderer.circle_outline(
                    pos.x + offset + rwidth - rounding, pos.y + rounding,
                    color.r, color.g, color.b, color.a, rounding + 1, 270, .25, 1
                )
                renderer.circle_outline(
                    pos.x + offset + rwidth - rounding, pos.y + height - rounding,
                    color.r, color.g, color.b, color.a, rounding + 1, 0, .25, 1
                )
                renderer.gradient(
                    pos.x + offset + rwidth - rounding, pos.y - 1,
                    -left_box_size.x * .25, 1, color.r, color.g, color.b, color.a, 0, 0, 0, 0, true
                )
                renderer.gradient(
                    pos.x + offset + rwidth - rounding, pos.y + height,
                    -left_box_size.x * .25, 1, color.r, color.g, color.b, color.a, 0, 0, 0, 0, true
                )

                if this.prefix == 'icon' then
                    prefix_logo:draw(
                        pos.x + text_offset, pos.y + height / 2 - prefix_logo_size.y / 2,
                        prefix_logo_size.x, prefix_logo_size.y,
                        color.r, color.g, color.b, color.a
                    )
                else
                    renderer.text(
                        pos.x + text_offset,
                        pos.y + math.floor(height / 2 - prefix_text_size.y / 2),
                        color.r, color.g, color.b, color.a,
                        'b', math.max(1, left_box_size.x * alpha), prefix_text
                    )
                end

                renderer.text(
                    pos.x + text_offset + offset,
                    pos.y + math.floor(height / 2 - text_size.y / 2),
                    255, 255, 255, color.a,
                    '', math.max(1, rwidth - 1 > text_offset * 3 and rwidth - text_offset - 2 or 0), text
                )
            end
        end),

        handle = LPH_JIT_MAX(function(self)
            -- for i = 1, #self.data.queue do
            --     if i > self.max then
            --         goto skip
            --     end

            --     if self.data.active[i] == nil then
            --         table.insert(self.data.active, self.data.queue[i])
            --     end

            --     ::skip::
            -- end

            self:render()
        end),

        add = function(self, args)
            local color_ref = self.menu.colors.accent
            local prefix = self.menu:get('visuals:notifier:prefix')

            args = args or {}

            args.color = args.color or { r = color_ref[1], g = color_ref[2], b = color_ref[3] }
            args.time = args.time or self.time.short
            args.text = args.text or { { '' } }
            args.prefix = args.prefix or prefix
            args.icon = args.icon or 'logo'

            table.insert(self.data.active, {
                fraction = smoothy:new(vector()),
                size = smoothy:new(),
                created = false,
                alpha = .0001,
                time = { created = false, started = false, value = 0 },
                started_hiding = false,
                type = args.type,
                time_add = args.time,
                color = args.color,
                text = args.text,
                prefix = args.prefix,
                icon = args.icon
            })
        end,

        on_load = function(self)
            local color_ref = self.menu.colors.accent

            local message = {
                { 'Welcome ' },
                { ctx.data.username, true },
                { ' [build: ' },
                { ctx.data.version, true },
                { ']' }
            }

            self.handlers:console_message(color_ref, message)

            self:add({
                time = 6,
                text = message
            })
        end
    }

    :struct 'cheat_revealer' {
        js = panorama.loadstring([[
            let entity_panels = {}
            let entity_data = {}
            let event_callbacks = {}

            let SLOT_LAYOUT = `
                <root>
                    <Panel style="min-width: 3px; padding-top: 2px; padding-left: 0px;" scaling='stretch-to-fit-y-preserve-aspect'>
                        <Image id="smaller" textureheight="15" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s      ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;"  />
                        <Image id="small" textureheight="17" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s        ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;" />
                        <Image id="image" textureheight="21" style="opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; padding:       3px 5px; margin: -3px -5px; margin-top: -5px;" />
                    </Panel>
                </root>
            `

            let _DestroyEntityPanel = function (key) {
                let panel = entity_panels[key]

                if(panel != null && panel.IsValid()) {
                    var parent = panel.GetParent()
                    let musor = parent.GetChild(0)

                    musor.visible = true
                    if(parent.FindChildTraverse("id-sb-skillgroup-image") != null) {
                        parent.FindChildTraverse("id-sb-skillgroup-image").style.margin = "0px 0px 0px 0px"
                    }

                    panel.DeleteAsync(0.0)
                }
                delete entity_panels[key]
            }

            let _DestroyEntityPanels = function() {
                for(key in entity_panels){
                    _DestroyEntityPanel(key)
                }
            }

            let _GetOrCreateCustomPanel = function(xuid) {
                if(entity_panels[xuid] == null || !entity_panels[xuid].IsValid()){
                    entity_panels[xuid] = null

                    let scoreboard_context_panel = $.GetContextPanel().FindChildTraverse("ScoreboardContainer").FindChildTraverse("Scoreboard") || $.GetContextPanel().     FindChildTraverse("id-eom-scoreboard-container").FindChildTraverse("Scoreboard")

                    if(scoreboard_context_panel == null){
                        _Clear()
                        _DestroyEntityPanels()

                        return
                    }

                    scoreboard_context_panel.FindChildrenWithClassTraverse("sb-row").forEach(function(el){
                        let scoreboard_el

                        if(el.m_xuid == xuid) {
                            el.Children().forEach(function(child_frame){
                                let stat = child_frame.GetAttributeString("data-stat", "")
                                if(stat == "rank")
                                    scoreboard_el = child_frame.GetChild(0)
                            })

                            if(scoreboard_el) {
                                let scoreboard_el_parent = scoreboard_el.GetParent()

                                let custom_icons = $.CreatePanel("Panel", scoreboard_el_parent, "custom-weapons", {
                                })

                                if(scoreboard_el_parent.FindChildTraverse("id-sb-skillgroup-image") != null) {
                                    scoreboard_el_parent.FindChildTraverse("id-sb-skillgroup-image").style.margin = "0px 0px 0px 0px"
                                }

                                scoreboard_el_parent.MoveChildAfter(custom_icons, scoreboard_el_parent.GetChild(1))

                                let prev_panel = scoreboard_el_parent.GetChild(0)
                                prev_panel.visible = false

                                let panel_slot_parent = $.CreatePanel("Panel", custom_icons, `icon`)

                                panel_slot_parent.visible = false
                                panel_slot_parent.BLoadLayoutFromString(SLOT_LAYOUT, false, false)

                                entity_panels[xuid] = custom_icons

                                return custom_icons
                            }
                        }
                    })
                }

                return entity_panels[xuid]
            }

            let _UpdatePlayer = function(entindex, path_to_image) {
                if(entindex == null || entindex == 0)
                    return

                entity_data[entindex] = {
                    applied: false,
                    image_path: path_to_image
                }
            }

            let _ApplyPlayer = function(entindex) {
                let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)

                let panel = _GetOrCreateCustomPanel(xuid)

                if(panel == null)
                    return

                let panel_slot_parent = panel.FindChild(`icon`)
                panel_slot_parent.visible = true

                let panel_slot = panel_slot_parent.FindChild("image")
                panel_slot.visible = true
                panel_slot.style.opacity = "1"
                panel_slot.SetImage(entity_data[entindex].image_path)

                return true
            }

            let _ApplyData = function() {
                for(entindex in entity_data) {
                    entindex = parseInt(entindex)

                    let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)

                    if(!entity_data[entindex].applied || entity_panels[xuid] == null || !entity_panels[xuid].IsValid()) {
                        if(_ApplyPlayer(entindex)) {
                            entity_data[entindex].applied = true
                        }
                    }
                }
            }

            let _Create = function() {
                event_callbacks["OnOpenScoreboard"] = $.RegisterForUnhandledEvent("OnOpenScoreboard", _ApplyData)
                event_callbacks["Scoreboard_UpdateEverything"] = $.RegisterForUnhandledEvent("Scoreboard_UpdateEverything", function(){
                    _ApplyData()
                })
                event_callbacks["Scoreboard_UpdateJob"] = $.RegisterForUnhandledEvent("Scoreboard_UpdateJob", _ApplyData)
            }

            let _Clear = function() {
                entity_data = {}
            }

            let _Destroy = function() {
                // clear entity data
                _Clear()
                _DestroyEntityPanels()

                for(event in event_callbacks){
                    $.UnregisterForUnhandledEvent(event, event_callbacks[event])

                    delete event_callbacks[event]
                }
            }

            let _GetSpeakingPlayers = function() {
                let children = $.GetContextPanel().FindChildTraverse("VoicePanel").Children()
                let result = []
                children.forEach((panel) => {
                    if(!panel.BHasClass("Hidden")) {
                        try {
                            let avatar = panel.GetChild(1).GetChild(1)
                            result.push(avatar.steamid)
                        } catch (err) {
                            // ignored
                        }
                    }
                })
                if(result.length > 0) {
                    let lookup = {}
                    for(let i=1; i <= 64; i++) {
                        let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(i)
                        if(xuid && xuid != "0")
                            lookup[xuid] = i
                    }
                    for(let i=0; i < result.length; i++)
                        result[i] = lookup[ result[i] ]
                }
                return result
            }

            return {
                create: _Create,
                destroy: _Destroy,
                clear: _Clear,
                update_player: _UpdatePlayer,
                destroy_panel: _DestroyEntityPanels,
                get_speaking_players: _GetSpeakingPlayers
            }
        ]], "CSGOHud")(),

        icon_links = {
            gamesense = 'https://cdn.discordapp.com/attachments/884455063232348210/1097008136713424956/gamesense.png',
            neverlose = 'https://cdn.discordapp.com/attachments/884455063232348210/1097008137095090257/neverlose.png',
            pandora = 'https://cdn.discordapp.com/attachments/884455063232348210/1097008137736818768/pandora.png',
            onetap = 'https://cdn.discordapp.com/attachments/884455063232348210/1097008137514532934/onetap.png',
            primordial = 'https://cdn.discordapp.com/attachments/884455063232348210/1097008137988493423/primordial.png',
            fatality = 'https://cdn.discordapp.com/attachments/884455063232348210/1097008139003515001/fatality.png',
            nixware = 'https://cdn.discordapp.com/attachments/884455063232348210/1097008137321599076/nixware.png',
            legendware = 'https://cdn.discordapp.com/attachments/884455063232348210/1097008136893776023/legendware.png',
            evolve = 'https://cdn.discordapp.com/attachments/884455063232348210/1097008138760228934/evolve.png',
            rifk7 = 'https://cdn.discordapp.com/attachments/884455063232348210/1097008138500194345/rifk7.png'
        },

        init = function(self)
            self.js.create()

            for cheat, link in pairs(self.icon_links) do
                http.get(link, function(s, r)
                    if s and r.status == 200 then
                        writefile(string.format('\\csgo\\materials\\panorama\\images\\icons\\%s.png', cheat), r.body)
                    end
                end)
            end
        end,

        p_voice_data = {},
        icon_data = {},

        check_occurencies = LPH_NO_VIRTUALIZE(function(xuids, pattern, length)
            local concat = table.concat(xuids)

            if string.find(concat, pattern) == nil then
                return 0
            end

            -- local additional = length and string_rep('%d', length) or ''
            local final_pattern = length and pattern .. string.rep('%d', length) or pattern

            if string.find(concat, final_pattern) == nil then
                return 0
            end

            local sum = 0

            for text in string.gmatch(concat, final_pattern) do
                -- print(text)
                sum = sum + 1
            end

            return sum
        end),

        SVCMsg_VoiceData_t = ffi.typeof([[
            struct {
                char        pad_0000[8];                //0x0000
                int32_t     client;                     //0x0008
                int32_t     audible_mask;               //0x000C
                uint32_t    xuid_low;
                uint32_t    xuid_high;
                void*       voide_data_;                //0x0018
                int32_t     proximity;                  //0x001C
                int32_t     format;                     //0x0020
                int32_t     sequence_bytes;             //0x0024
                uint32_t    section_number;             //0x0028
                uint32_t    uncompressed_sample_offset; //0x002C
            } *
        ]]),

        plocal_updated = false,
        MAX = 16,

        update_local_player = LPH_JIT_MAX(function(self, e)
            if self.vars.local_player == client.userid_to_entindex(e.userid) then
                self.js.update_player(client.userid_to_entindex(e.userid), string.format('file://{images}/icons/%s.png', 'gamesense'))
            end
        end),

        SVCMsg_VoiceData = LPH_JIT_MAX(function
            -- (ecx, edx, msg)
            (self, msg)
            -- local voice_data = ffi.cast(SVCMsg_VoiceData_t, ffi.cast('char*', msg))[0]
            local voice_data = ffi.cast(self.SVCMsg_VoiceData_t, msg.data)[0]

            local MAX = self.MAX

            local entindex = voice_data.client + 1
            local steamid = entity.get_steam64(entindex)

            local xuid_low = voice_data.xuid_low
            local xuid_high = voice_data.xuid_high

            local p_voice_data = self.p_voice_data
            local icon_data = self.icon_data

            if p_voice_data[entindex] == nil then
                p_voice_data[entindex] = {
                    cheat = '',
                    last_xuid_low = {},
                    last_xuid_high = {},
                    last_cheat_detected = {},
                    fails = 0
                }
            end

            local p_data = p_voice_data[entindex]

            if xuid_low == steamid then
                -- if xuid_high == 17825793 and not player_speaking(entindex) then
                --     table.insert(p_data.last_cheat_detected, 'primordial')
                -- end
            else
                local static_cheats = {
                    xuid_low = {
                        [420187] = 'pandora',
                        [6969] = 'pandora',
                        [29804] = 'legendware' --i guess?
                    },
                    xuid_high = {
                        [0] = 'nixware',
                        [1337] = 'legendware'
                    }
                }

                table.insert(p_data.last_xuid_low, xuid_low)
                table.insert(p_data.last_xuid_high, xuid_high)

                if #p_data.last_xuid_low > MAX then
                    table.remove(p_data.last_xuid_low, 1)
                end

                if #p_data.last_xuid_high > MAX then
                    table.remove(p_data.last_xuid_high, 1)
                end

                if #p_data.last_cheat_detected > MAX then
                    table.remove(p_data.last_cheat_detected, 1)
                end

                if self.menu.other.debug_cheat_revealer and ui.get(self.menu.other.debug_cheat_revealer) and p_data.cheat == '' then
                    print(
                        entity.get_player_name(entindex),
                        ' ', p_data.cheat,
                        ' low ', xuid_low, ' high ', xuid_high,
                        ' ft ', voice_data.format, ' sb ', voice_data.sequence_bytes,
                        ' sn ', voice_data.section_number, ' uso ', voice_data.uncompressed_sample_offset
                    )
                end

                if #p_data.last_xuid_low >= MAX and #p_data.last_xuid_high >= MAX then
                    if xuid_low <= 64 and xuid_high == 0 then
                        table.insert(p_data.last_cheat_detected, 'neverlose')
                        table.remove(p_data.last_xuid_low)
                        table.remove(p_data.last_xuid_high)
                    elseif static_cheats.xuid_low[p_data.last_xuid_low[1]] ~= nil
                    and static_cheats.xuid_low[xuid_low] ~= nil
                    and static_cheats.xuid_low[p_data.last_xuid_low[1]] == static_cheats.xuid_low[xuid_low] then
                        table.insert(p_data.last_cheat_detected, static_cheats.xuid_low[p_data.last_xuid_low[1]])
                    elseif static_cheats.xuid_high[p_data.last_xuid_high[1]] ~= nil
                    and static_cheats.xuid_high[xuid_high] ~= nil
                    and static_cheats.xuid_high[p_data.last_xuid_high[1]] == static_cheats.xuid_high[xuid_high] then
                        table.insert(p_data.last_cheat_detected, static_cheats.xuid_high[p_data.last_xuid_high[1]])
                    elseif #tostring(xuid_low) >= 6
                    and #tostring(xuid_high) >= 9
                    and self.check_occurencies(p_data.last_xuid_low, xuid_low) == 1
                    and self.check_occurencies(p_data.last_xuid_high, string.sub(xuid_high, 1, 3), 6) == MAX then
                        table.insert(p_data.last_cheat_detected, 'neverlose')
                    elseif #tostring(xuid_low) <= 3
                    and #tostring(xuid_high) >= 8
                    and self.check_occurencies(p_data.last_xuid_low, xuid_low) >= math.floor(MAX / 2)
                    and self.check_occurencies(p_data.last_xuid_high, string.sub(xuid_high, 1, 3), 5) == MAX then
                        table.insert(p_data.last_cheat_detected, 'rifk7')
                    elseif #tostring(xuid_low) >= 7
                    and #tostring(xuid_high) >= 8
                    and p_data.last_xuid_low[1] == xuid_low
                    and self.check_occurencies(p_data.last_xuid_low, xuid_low) == MAX
                    and self.check_occurencies(p_data.last_xuid_high, xuid_high) == 1
                    and self.check_occurencies(p_data.last_xuid_high, string.sub(xuid_high, 1, 1), 7) == MAX then
                        table.insert(p_data.last_cheat_detected, 'onetap')
                    elseif #tostring(xuid_low) <= 2 and (
                        xuid_high == p_data.last_xuid_low[MAX - 1]
                    ) or (
                        math.abs(xuid_high - globals.tickcount()) <= 6
                        and xuid_high - p_data.last_xuid_high[1] < 20
                        and xuid_high - p_data.last_xuid_high[1] >= 0
                        and p_data.last_xuid_high[1] < xuid_high
                        and self.check_occurencies(p_data.last_xuid_low, xuid_low) >= math.floor(MAX / 3)
                    ) then --MEH
                        table.insert(p_data.last_cheat_detected, 'fatality')

                        if #tostring(xuid_low) <= 2 then
                            table.remove(p_data.last_xuid_high)
                        end
                    elseif #tostring(xuid_low) >= 7
                    and #tostring(xuid_high) >= 7
                    and math.abs(xuid_low - p_data.last_xuid_low[1]) > 1000000
                    and math.abs(xuid_high - p_data.last_xuid_high[1]) > 1000000
                    and self.check_occurencies(p_data.last_xuid_low, xuid_low) == 1
                    and self.check_occurencies(p_data.last_xuid_high, xuid_high) == 1 then
                        table.insert(p_data.last_cheat_detected, 'gamesense')
                    end
                end
            end

            if #p_data.last_cheat_detected >= MAX then
                if p_data.last_cheat_detected[1] == p_data.last_cheat_detected[MAX] then
                    p_data.cheat = p_data.last_cheat_detected[1]
                    p_data.fails = 0
                elseif p_data.fails >= 3 then
                    p_data.cheat = ''
                else
                    p_data.fails = p_data.fails + 1
                end

                p_data.last_cheat_detected = {}
            end

            if icon_data[entindex] == nil then
                icon_data[entindex] = ''
            end

            if icon_data[entindex] ~= p_data.cheat then
                self.js.update_player(entindex, string.format('file://{images}/icons/%s.png', p_data.cheat))
                icon_data[entindex] = p_data.cheat
            end
        end)
    }

ctx.data:update_data()

script.menu:initialize()
script.menu:set_callbacks()
script.config_system:get_configs()
script.config_system:set_callbacks()
script.antibruteforce:create_values()
script.indicators:download_fonts()
script.indicators:create_other_items()
client.delay_call(.1, function()
    script.automatic_peek:update_cached_hotkeys()
end)
script.automatic_peek:create_values()
script.notifier:get_images()
script.watermark:get_images()
script.popups:get_images()
script.popups:create_elements()

script.vars:force_feature_indicators(ref.feature_indicators)
ui.set_callback(ref.feature_indicators, function(ref)
    script.vars:force_feature_indicators(ref)
end)

script.menu:update_colors()
ui.set_callback(script.menu:get_element('accent_color'), function()
    script.menu:update_colors()
end)

script.automatic_peek:update_hitboxes(ref.target_hitbox)
ui.set_callback(ref.target_hitbox, function(ref)
    script.automatic_peek:update_hitboxes(ref)
end)

client.delay_call(1, function()
    script.notifier:on_load()
end)

script.cheat_revealer:init()

client.register_esp_flag('1', 255, 170, 170, LPH_NO_VIRTUALIZE(function(entindex)
    if not script.automatic_peek.visual.active or not entity.is_alive(script.vars.local_player) then return false end

    if entindex == script.automatic_peek.cache.current_target then
        return true, 'PEEK'
    end

    return false
end))

client.register_esp_flag('1', 255, 255, 255, LPH_NO_VIRTUALIZE(function(entindex)
    local steamid = tostring(entity.get_steam64(entindex))
    if steamid == '0' then steamid = entindex end
    if script.menu:get('aa:antiaim_preset') == 'dynamic' then return false end
    if not script.menu:get('aa:antibruteforce:enable') then return false end
    if not entity.is_alive(script.vars.local_player) or entity.is_dormant(entindex) or script.antibruteforce.values.simple[steamid] == nil then return false end
    if not script.antibruteforce.values.simple[steamid].active then return false end

    local type = script.menu:get('aa:antibruteforce:simple:mode')

    if type == 'jitter' then
        local mode = script.menu:get('aa:antibruteforce:simple:jitter:mode')

        if mode == 'automatic' then
            return true, string.format('JITTER:%d', script.antibruteforce.values.simple[steamid].jitter.automatic.amount)
        elseif mode == 'phases' then
            local phase = script.antibruteforce.values.simple[steamid].jitter.phases.phase

            if phase ~= 0 then
                return true, string.format('PHASE:%d', phase)
            end
        end
    elseif type == 'static' then
        local side = script.antibruteforce.values.simple[steamid].static.side

        return true, string.format('SIDE:%s', string.upper(side))
    end
end))

local callbacks = {
    run_command = LPH_NO_VIRTUALIZE(function(cmd)
        script.vars:on_run_command()

        if script.menu:get('aa:master_switch') then
            script.antibruteforce:store_backtrack()

            if script.menu:get('aa:antiaim_preset') ~= 'dynamic' and script.menu:get('aa:antibruteforce:enable') then
                if script.menu.multiselects_values.antibruteforce_reset_events['time'] then
                    script.antibruteforce:reset_on_time()
                end
            end

            script.antiaim:ladder_check()
        end

        if script.menu:get('misc:clantag') then
            script.clantag:on_run_command(cmd)
        end
    end),

    setup_command = LPH_NO_VIRTUALIZE(function(cmd)
        script.antiaim:update_vars(cmd)

        if script.menu:get('aa:master_switch') then
            script.antiaim:set_antiaim(cmd)
        end

        script.automatic_peek:handle(cmd)
    end),

    predict_command = function(cmd)
        script.vars:detect_defensive()
    end,

    net_update_end = function()

    end,

    indicator = function(indicator)
        script.vars:on_indicator(indicator)
    end,

    paint_ui = LPH_NO_VIRTUALIZE(function()
        script.vars:on_paint_ui()

        script.antibruteforce:handle_shots()

        script.notifier:handle()

        if not ui.is_menu_open() then
            return
        end

        local show_skeet_menu = script.menu.other.debug_menu and ui.get(script.menu.other.debug_menu)

        script.menu:handle_skeet_menu(show_skeet_menu)
        script.menu:handle_visibility()

        script.menu:handle_configuring_label()
    end),

    paint = LPH_NO_VIRTUALIZE(function()
        local curr_indicators = script.menu:get('visuals:indicators:style')

        if curr_indicators ~= '-' then
            if curr_indicators == 'modern' then
                script.indicators:render_style_1()
            elseif curr_indicators == 'new' then
                script.indicators:render_style_2()
            elseif curr_indicators == 'test' then
                script.indicators:render_style_3()
            end
        end

        if script.menu:get('visuals:indicators:manual_arrows:style') ~= '-' then
            script.indicators:render_arrows()
        end

        if script.menu:get('visuals:watermark') then
            script.watermark:render()
        elseif curr_indicators == '-' then
            local screen_size = script.vars.screen_size

            local color_ref = script.menu.colors.accent
            color_ref[4] = 255

            local text = ctx.common:gradient_text(
                string.format('%s - %s', ctx.data.name, ctx.data.version),
                color_ref, { 255, 255, 255, 255 }, math.abs(math.sin(globals.curtime() / 2)), true
            )
            local text_size = vector(renderer.measure_text(nil, text))

            renderer.text(0, screen_size.y - text_size.y, 255, 255, 255, 255, nil, nil, text)
        end

        script.popups:render()

        script.automatic_peek:render()

        if script.menu:get('misc:clantag') then
            script.clantag:on_paint()
        else
            script.clantag:reset()
        end
    end),

    bullet_impact = function(e)
        script.antibruteforce:bullet_impact(e)
    end,

    player_hurt = function(e)
        script.antibruteforce:player_hurt(e)

        script.indicators:on_player_hurt(e)

        script.aimbot_logs:on_player_hurt(e)
    end,

    round_start = function()
        if script.menu:get('aa:antiaim_preset') ~= 'dynamic' and script.menu:get('aa:antibruteforce:enable') then
            if script.menu.multiselects_values.antibruteforce_reset_events['round start'] then
                script.antibruteforce:reset_on_round_start()
            end
        end

        if #script.menu:get('misc:aimbot_log') > 0 then
            script.aimbot_logs:on_round_start()
        end
    end,

    aim_fire = function(e)
        if #script.menu:get('misc:aimbot_log') > 0 then
            script.aimbot_logs:on_aim_fire(e)
        end
    end,

    aim_hit = function(e)
        if #script.menu:get('misc:aimbot_log') > 0 then
            script.aimbot_logs:on_aim_hit(e)
        end
    end,

    aim_miss = function(e)
        if #script.menu:get('misc:aimbot_log') > 0 then
            script.aimbot_logs:on_aim_miss(e)
        end
    end,

    player_death = function(e)
        if script.menu:get('aa:antiaim_preset') ~= 'dynamic' and script.menu:get('aa:antibruteforce:enable') then
            if script.menu.multiselects_values.antibruteforce_reset_events['shooter death'] then
                script.antibruteforce:reset_on_shooter_death(e)
            end
        end

        if #script.menu:get('misc:aimbot_log') > 0 then
            script.aimbot_logs:on_player_death(e)
        end
    end,

    player_spawn = function(e)
        if script.menu:get('misc:cheat_revealer') then
            script.cheat_revealer:update_local_player(e)
        end
    end,

    player_connect_full = function(e)
        if script.menu:get('misc:cheat_revealer') then
            script.cheat_revealer:update_local_player(e)
        end
    end,

    pre_render = LPH_NO_VIRTUALIZE(function()
        local animation_breakers = script.menu:get('misc:animation_breakers')

        if #animation_breakers ~= 0 then
            script.animation_breaker:handle()
        end
    end),

    bomb_beginplant = function(e)
        script.vars:on_bomb_beginplant(e)
    end,

    bomb_abortplant = function()

    end,

    pre_config_save = function()
        script.menu:reset_antiaim()

        if not ctx.data.source and script.config_system.hidden_config then
            script.config_system.last_config = script.config_system:export_raw(false, true, script.config_system.hidden_config)
            script.config_system:import_raw(script.config_system.configs.blank)
        end
    end,

    post_config_save = function()
        if not ctx.data.source and script.config_system.hidden_config then
            script.config_system:import_raw(script.config_system.last_config)
        end
    end,

    dormant_hit = function(e)
        script.aimbot_logs:on_dormant_hit(e)
    end,

    dormant_miss = function(e)
        script.aimbot_logs:on_dormant_miss(e)
    end,

    voice = function(data)
        if script.menu:get('misc:cheat_revealer') then
            script.cheat_revealer:SVCMsg_VoiceData(data)
        end
    end,

    shutdown = function()
        script.menu:handle_skeet_menu(true)

        if not ctx.data.source then
            script.menu:reset_antiaim()
        end

        ui.set_visible(ref.leg_movement, true)

        if script.clantag.disable_clantag then
            client.set_clan_tag('\0')
        end

        if script.cheat_revealer.js and script.cheat_revealer.js.destroy then
            script.cheat_revealer.js.destroy()
        end

        ui.set(ref.quickpeek[1], script.automatic_peek.cache.hotkeys.qickpeek_assist.enabled)
        ui.set(ref.quickpeek[2], script.automatic_peek.cache.hotkeys.qickpeek_assist.hotkey_mode)
        ui.set(ref.quickpeek_assist_mode[1], script.automatic_peek.cache.hotkeys.qickpeek_assist.mode)
        ui.set(ref.quickpeek_assist_distance, script.automatic_peek.cache.hotkeys.qickpeek_assist.distance)
        ui.set(ref.ping_spike[1], script.automatic_peek.cache.hotkeys.ping_spike.enabled)
        ui.set(ref.ping_spike[2], script.automatic_peek.cache.hotkeys.ping_spike.hotkey_mode)
        ui.set(ref.ping_spike[3], script.automatic_peek.cache.hotkeys.ping_spike.amount)

        ctx.data.database.configs.hidden_config = script.config_system.hidden_config
        ctx.data.database.configs.autoload_config = script.config_system.autoload_item
        ctx.data.database.configs.list = script.config_system.list
        -- script_db.database.antiaim.antibruteforce = {
        --     data = antibruteforce.data,
        --     all_stored_shots = antibruteforce.all_stored_shots
        -- }
        ctx.data.database.antiaim.dynamic = {
            values = script.antiaim.dynamic.values.data,
            antiaim_data = script.antiaim.dynamic.values.antiaim_data
        }

        database.write(ctx.data.database_key, ctx.data.database)
    end
}

do
    if ctx.data.database.configs.hidden_config ~= nil then
        script.config_system.hidden_config = ctx.data.database.configs.hidden_config
    end

    if ctx.data.database.configs.list ~= nil then
        script.config_system.list = ctx.data.database.configs.list
        ui.update(script.menu.configs_menu.config_list, script.config_system.list)
    end

    if ctx.data.database.configs.autoload_config then
        script.config_system.autoload_item = ctx.data.database.configs.autoload_config

        client.delay_call(1, function()
            script.config_system:load_config(ctx.data.database.configs.autoload_config, true)
            script.menu:visibility_handle()
        end)
    end

    -- if script_db.database.antiaim.antibruteforce.data ~= nil then
    --     antibruteforce.data = script_db.database.antiaim.antibruteforce.data
    -- end

    -- if script_db.database.antiaim.antibruteforce.all_stored_shots ~= nil then
    --     antibruteforce.all_stored_shots = script_db.database.antiaim.antibruteforce.all_stored_shots
    -- end

    if ctx.data.database.antiaim.dynamic.values ~= nil then
        -- script.antiaim.dynamic.values.data = ctx.data.database.antiaim.dynamic.values
    end

    if ctx.data.database.antiaim.dynamic.antiaim_data ~= nil then
        -- script.antiaim.dynamic.values.antiaim_data = ctx.data.database.antiaim.dynamic.antiaim_data
    end

    script.menu:visibility_handle()
end

for key, value in pairs(callbacks) do
    client.set_event_callback(key, value)
end

-- if ctx.data.source then
--     writefile('risen_db.json', inspect(script))
-- end