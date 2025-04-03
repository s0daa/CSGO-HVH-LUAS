local ____modules = {}
local ____moduleCache = {}
local ____originalRequire = require
local c_entity = require("gamesense/entity")
local antiaim_funcs = require("gamesense/antiaim_funcs")
local ffi =  require "ffi"
local clipboard = (function()
    local ffi = require "ffi"
    local string_len, tostring, ffi_string = string.len, tostring, ffi.string

    --
    -- our module
    --

    local M = {}

    --
    -- game funcs (https://github.com/perilouswithadollarsign/cstrike15_src/blob/master/public/vgui/ISystem.h)
    --

    local native_GetClipboardTextCount = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
    local native_SetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 9,
        "void(__thiscall*)(void*, const char*, int)")
    local native_GetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 11,
        "int(__thiscall*)(void*, int, const char*, int)")

    local new_char_arr = ffi.typeof("char[?]")

    -- returns (pastes) clipboard text
    function M.get()
        local len = native_GetClipboardTextCount()

        if len > 0 then
            local char_arr = new_char_arr(len)
            native_GetClipboardText(0, char_arr, len)
            return ffi_string(char_arr, len - 1)
        end
    end

    M.paste = M.get

    -- sets (copies) the clipboard text
    function M.set(text)
        text = tostring(text)

        native_SetClipboardText(text, string_len(text))
    end

    M.copy = M.set

    return M
end)()

local angle_t = ffi.typeof("struct { float pitch; float yaw; float roll; }")
local vector3_t = ffi.typeof("struct { float x; float y; float z; }")
local usercmd_t =
    ffi.typeof(
    [[
    struct
    {
        uintptr_t vfptr;
        int command_number;
        int tick_count;
        $ viewangles;
        $ aimdirection;
        float forwardmove;
        float sidemove;
        float upmove;
        int buttons;
        uint8_t impulse;
        int weaponselect;
        int weaponsubtype;
        int random_seed;
        short mousedx;
        short mousedy;
        bool hasbeenpredicted;
        $ headangles;
        $ headoffset;
    }
    ]],
    angle_t,
    vector3_t,
    angle_t,
    vector3_t
)

local get_user_cmd_t = ffi.typeof("$* (__thiscall*)(uintptr_t ecx, int nSlot, int sequence_number)", usercmd_t)

local input_vtbl_t =
    ffi.typeof(
    [[
    struct
    {
        uintptr_t padding[8];
        $ GetUserCmd;
    }
    ]],
    get_user_cmd_t
)

local input_t = ffi.typeof([[
    struct
    {
        $* vfptr;
    }*
    ]], input_vtbl_t)

local g_pInput =
    ffi.cast(
    input_t,
    ffi.cast(
        "uintptr_t**",
        tonumber(
            ffi.cast(
                "uintptr_t",
                client.find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85") or
                    error("client.dll!:input not found.")
            )
        ) + 1
    )[0]
)

base64 = {}

local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' -- You will need this for encoding/decoding

-- encoding
function base64.enc(data)
    return ((data:gsub('.', function(x)
            local r, b = '', x:byte()
            for i = 8, 1, -1 do r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0') end
            return r;
        end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
            if (#x < 6) then return '' end
            local c = 0
            for i = 1, 6 do c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0) end
            return b:sub(c + 1, c + 1)
        end) .. ({ '', '==', '=' })[#data % 3 + 1])
end

-- decoding
function base64.dec(data)
    data = string.gsub(data, '[^' .. b .. '=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r, f = '', (b:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c = 0
        for i = 1, 8 do c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0) end
        return string.char(c)
    end))
end

local function require(file, ...)
    if ____moduleCache[file] then
        return ____moduleCache[file].value
    end
    if ____modules[file] then
        local module = ____modules[file]
        ____moduleCache[file] = { value = (select("#", ...) > 0) and module(...) or module(file) }
        return ____moduleCache[file].value
    else
        if ____originalRequire then
            return ____originalRequire(file)
        else
            error("module '" .. file .. "' not found")
        end
    end
end
____modules = {
    ["main"] = function(...)
        -- Lua Library inline imports
        local function __TS__ArrayForEach(self, callbackFn, thisArg)
            for i = 1, #self do
                callbackFn(thisArg, self[i], i - 1, self)
            end
        end

        local function __TS__Class(self)
            local c = { prototype = {} }
            c.prototype.__index = c.prototype
            c.prototype.constructor = c
            return c
        end

        local __TS__Symbol, Symbol
        do
            local symbolMetatable = {
                __tostring = function(self)
                    return ("Symbol(" .. (self.description or "")) .. ")"
                end
            }
            function __TS__Symbol(description)
                return setmetatable({ description = description }, symbolMetatable)
            end

            Symbol = {
                iterator = __TS__Symbol("Symbol.iterator"),
                hasInstance = __TS__Symbol("Symbol.hasInstance"),
                species = __TS__Symbol("Symbol.species"),
                toStringTag = __TS__Symbol("Symbol.toStringTag")
            }
        end

        local __TS__Iterator
        do
            local function iteratorGeneratorStep(self)
                local co = self.____coroutine
                local status, value = coroutine.resume(co)
                if not status then
                    error(value, 0)
                end
                if coroutine.status(co) == "dead" then
                    return
                end
                return true, value
            end
            local function iteratorIteratorStep(self)
                local result = self:next()
                if result.done then
                    return
                end
                return true, result.value
            end
            local function iteratorStringStep(self, index)
                index = index + 1
                if index > #self then
                    return
                end
                return index, string.sub(self, index, index)
            end
            function __TS__Iterator(iterable)
                if type(iterable) == "string" then
                    return iteratorStringStep, iterable, 0
                elseif iterable.____coroutine ~= nil then
                    return iteratorGeneratorStep, iterable
                elseif iterable[Symbol.iterator] then
                    local iterator = iterable[Symbol.iterator](iterable)
                    return iteratorIteratorStep, iterator
                else
                    return ipairs(iterable)
                end
            end
        end

        local Map
        do
            Map = __TS__Class()
            Map.name = "Map"
            function Map.prototype.____constructor(self, entries)
                self[Symbol.toStringTag] = "Map"
                self.items = {}
                self.size = 0
                self.nextKey = {}
                self.previousKey = {}
                if entries == nil then
                    return
                end
                local iterable = entries
                if iterable[Symbol.iterator] then
                    local iterator = iterable[Symbol.iterator](iterable)
                    while true do
                        local result = iterator:next()
                        if result.done then
                            break
                        end
                        local value = result.value
                        self:set(value[1], value[2])
                    end
                else
                    local array = entries
                    for ____, kvp in ipairs(array) do
                        self:set(kvp[1], kvp[2])
                    end
                end
            end

            function Map.prototype.clear(self)
                self.items = {}
                self.nextKey = {}
                self.previousKey = {}
                self.firstKey = nil
                self.lastKey = nil
                self.size = 0
            end

            function Map.prototype.delete(self, key)
                local contains = self:has(key)
                if contains then
                    self.size = self.size - 1
                    local next = self.nextKey[key]
                    local previous = self.previousKey[key]
                    if next ~= nil and previous ~= nil then
                        self.nextKey[previous] = next
                        self.previousKey[next] = previous
                    elseif next ~= nil then
                        self.firstKey = next
                        self.previousKey[next] = nil
                    elseif previous ~= nil then
                        self.lastKey = previous
                        self.nextKey[previous] = nil
                    else
                        self.firstKey = nil
                        self.lastKey = nil
                    end
                    self.nextKey[key] = nil
                    self.previousKey[key] = nil
                end
                self.items[key] = nil
                return contains
            end

            function Map.prototype.forEach(self, callback)
                for ____, key in __TS__Iterator(self:keys()) do
                    callback(nil, self.items[key], key, self)
                end
            end

            function Map.prototype.get(self, key)
                return self.items[key]
            end

            function Map.prototype.has(self, key)
                return self.nextKey[key] ~= nil or self.lastKey == key
            end

            function Map.prototype.set(self, key, value)
                local isNewValue = not self:has(key)
                if isNewValue then
                    self.size = self.size + 1
                end
                self.items[key] = value
                if self.firstKey == nil then
                    self.firstKey = key
                    self.lastKey = key
                elseif isNewValue then
                    self.nextKey[self.lastKey] = key
                    self.previousKey[key] = self.lastKey
                    self.lastKey = key
                end
                return self
            end

            Map.prototype[Symbol.iterator] = function(self)
                return self:entries()
            end
            function Map.prototype.entries(self)
                local items = self.items
                local nextKey = self.nextKey
                local key = self.firstKey
                return {
                    [Symbol.iterator] = function(self)
                        return self
                    end,
                    next = function(self)
                        local result = { done = not key, value = { key, items[key] } }
                        key = nextKey[key]
                        return result
                    end
                }
            end

            function Map.prototype.keys(self)
                local nextKey = self.nextKey
                local key = self.firstKey
                return {
                    [Symbol.iterator] = function(self)
                        return self
                    end,
                    next = function(self)
                        local result = { done = not key, value = key }
                        key = nextKey[key]
                        return result
                    end
                }
            end

            function Map.prototype.values(self)
                local items = self.items
                local nextKey = self.nextKey
                local key = self.firstKey
                return {
                    [Symbol.iterator] = function(self)
                        return self
                    end,
                    next = function(self)
                        local result = { done = not key, value = items[key] }
                        key = nextKey[key]
                        return result
                    end
                }
            end

            Map[Symbol.species] = Map
        end

        local function __TS__New(target, ...)
            local instance = setmetatable({}, target.prototype)
            instance:____constructor(...)
            return instance
        end

        local function __TS__StringSubstring(self, start, ____end)
            if ____end ~= ____end then
                ____end = 0
            end
            if ____end ~= nil and start > ____end then
                start, ____end = ____end, start
            end
            if start >= 0 then
                start = start + 1
            else
                start = 1
            end
            if ____end ~= nil and ____end < 0 then
                ____end = 0
            end
            return string.sub(self, start, ____end)
        end
        -- End of Lua Library inline imports
        local table_contains = function(tbl, val)
            for i = 1, #tbl do
                if tbl[i] == val then
                    return true
                end
            end
            return false
        end
        local status = {
            build = "Beta",
            last_updatetime = "23/3/17",
            username = 'Beta user'
        }

        local _u = { visual = {} }
        local animate = (function()
            local anim = {}

            local lerp = function(start, vend)
                local anim_speed = 10
                return start + (vend - start) * (globals.frametime() * anim_speed)
            end

            local lerp_notify = function(start, vend)
                return start + (vend - start) * (globals.frametime() * 8)
            end


            anim.new_notify = function(value, startpos, endpos, condition)
                if condition ~= nil then
                    if condition then
                        return lerp_notify(value, startpos)
                    else
                        return lerp_notify(value, endpos)
                    end
                else
                    return lerp_notify(value, startpos)
                end
            end



            anim.new = function(value, startpos, endpos, condition)
                if condition ~= nil then
                    if condition then
                        return lerp(value, startpos)
                    else
                        return lerp(value, endpos)
                    end
                else
                    return lerp(value, startpos)
                end
            end

            anim.new_color = function(color, color2, end_value, condition)
                if condition ~= nil then
                    if condition then
                        color.r = lerp(color.r, color2.r)
                        color.g = lerp(color.g, color2.g)
                        color.b = lerp(color.b, color2.b)
                        color.a = lerp(color.a, color2.a)
                    else
                        color.r = lerp(color.r, end_value.r)
                        color.g = lerp(color.g, end_value.g)
                        color.b = lerp(color.b, end_value.b)
                        color.a = lerp(color.a, end_value.a)
                    end
                else
                    color.r = lerp(color.r, color2.r)
                    color.g = lerp(color.g, color2.g)
                    color.b = lerp(color.b, color2.b)
                    color.a = lerp(color.a, color2.a)
                end

                return { r = color.r, g = color.g, b = color.b, a = color.a }
            end

            anim.new_flash = function(cur, min, max, target, step, speed)
                local step = step or 1
                local speed = speed or 0.1

                if cur < min + step then
                    target = max
                elseif cur > max - step then
                    target = min
                end


                return cur + (target - cur) * speed * (globals.absoluteframetime() * 10)
            end

            return anim
        end)()

        local render_w_text = function(x, y, r, g, b, a, flags, width, text)
            renderer.text(x + 1, y - 1, 12, 12, 12, a * 0.4, flags, width, text)
            renderer.text(x + 1, y + 1, 12, 12, 12, a * 0.4, flags, width, text)
            renderer.text(x - 1, y + 1, 12, 12, 12, a * 0.4, flags, width, text)
            renderer.text(x - 1, y - 1, 12, 12, 12, a * 0.4, flags, width, text)
            renderer.text(x, y, r, g, b, a, flags, width, text)
        end

        local render_notify = function(x, y, r, g, b, a, flags, width, text, anim)
            local svg =
            '<svg t="1650815150236" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1757" width="200" height="200"><path d="M750.688207 480.651786c-40.458342 65.59852-115.105654 102.817686-205.927943 117.362627 2.382361 26.853806 0.292571 62.00408 20.897903 102.232546 40.77181 79.621013 76.486328 166.28462 88.356337 229.897839 69.819896 30.824408 215.958937-42.339153 257.671154-134.540705 44.721514-98.847085 0-202.082729-74.103967-210.755359-74.083069-8.651732-117.655198 31.555835-109.902076 78.65971 7.732224 47.103875 51.868597 47.918893 96.485622 16.822812 44.617024-31.075183 85.869486 32.517138 37.992389 60.562125-47.897995 28.044987-124.133548 44.867799-168.228125-5.642434-44.094577-50.489335-40.458342-228.205109 143.65219-211.716662 184.110532 16.509344 176.127533 261.683551 118.804583 344.042189C894.465785 956.497054 823.600993 1024.519731 616.37738 1023.997283h-167.18323V814.600288 1023.997283h-168.269921c-83.424432 0-24.743118-174.267619 51.826801-323.750324 20.584435-40.228465 18.494645-75.378739 20.897904-102.232546C262.784849 583.469472 188.137536 546.250306 147.679195 480.651786H93.867093A20.814312 20.814312 0 0 1 73.031883 459.753882c0-11.535643 9.46675-20.897904 20.83521-20.897903H127.993369a236.480679 236.480679 0 0 1-10.093687-41.795808H52.071285A20.814312 20.814312 0 0 1 31.236075 376.162267c0-11.535643 9.46675-20.897904 20.83521-20.897903H114.82769v-0.877712c0-57.009481 15.171878-103.131155 41.795808-139.514406V28.379353c0-11.535643 8.630834-17.136281 19.267867-12.517844l208.979037 90.864085c20.793414-2.08979 42.318255-3.113788 64.323748-3.113787s43.530333 1.044895 64.344646 3.134685l208.979037-90.884983c10.616135-4.618437 19.246969 0.982201 19.246969 12.538742v186.471995c26.623929 36.38325 41.795807 82.504924 41.795808 139.514406V355.264364h62.756405c11.493847 0 20.83521 9.278669 20.83521 20.897903 0 11.535643-9.46675 20.897904-20.83521 20.897904h-65.828397a236.480679 236.480679 0 0 1-10.093688 41.795808h34.126277c11.493847 0 20.83521 9.278669 20.83521 20.897903 0 11.535643-9.46675 20.897904-20.83521 20.897904h-53.833z" p-id="1758" fill="#ffffff"></path></svg>'
            anim = anim or 1
            local icon_w, icon_h = 30 / 3 * anim, 25 / 3 * anim
            local icon = renderer.load_svg(svg, icon_w, icon_h)
            local textx, texty = renderer.measure_text(flags, text)
            local w, h = math.floor((textx + 20) * anim), math.floor((texty + 10) * anim)


            --BACKGROUND_BLUR
            renderer.blur(x, y + 3, w, h - 4, 0, 0)
            renderer.rectangle(x, y + 3, w, h - 4, 40, 40, 40, 150 * anim)
            --bottom
            renderer.gradient(x, y + h, w, 2, r, g, b, a, b, g, r, a, true)

            --left
            renderer.rectangle(x, y, 2, h, r, g, b, a)
            renderer.gradient(x, y, w / 4, 2, r, g, b, a, b, g, r, a, true)

            --right
            renderer.rectangle(x + (w - 2), y, 2, h, b, g, r, a)
            renderer.gradient(x + (w - 2), y, -(w / 4), 2, b, g, r, a, r, g, b, a, true)

            local textxd, textyd = renderer.measure_text('-', 'ATARAXIA.PUB')

            renderer.texture(icon, x + w / 2 - textxd / 2 - 5 + 1, y - (h / 4) + 3 + 1, icon_w, icon_h, 40, 40, 40,
                175 * anim, 'f')
            renderer.texture(icon, x + w / 2 - textxd / 2 - 5 - 1, y - (h / 4) + 3 - 1, icon_w, icon_h, 40, 40, 40,
                175 * anim, 'f')
            renderer.texture(icon, x + w / 2 - textxd / 2 - 5 - 1, y - (h / 4) + 3 + 1, icon_w, icon_h, 40, 40, 40,
                175 * anim, 'f')
            renderer.texture(icon, x + w / 2 - textxd / 2 - 5 + 1, y - (h / 4) + 3 - 1, icon_w, icon_h, 40, 40, 40,
                175 * anim, 'f')


            renderer.texture(icon, x + w / 2 - textxd / 2 - 5, y - (h / 4) + 3, icon_w, icon_h, r, g, b, a, 'f')
            renderer.text(x + w / 2 - textxd / 2 + 5, y - (h / 4) + 2, r, g, b, a, '-', 0, 'ATARAXIA.PUB')
            --main text
            render_w_text(x + 10, y + h / 4, 255, 255, 255, a, flags, width, text)
        end
        local colorful_text = {}

        colorful_text.lerp = function(self, from, to, duration)
            if type(from) == 'table' and type(to) == 'table' then
                return {
                    self:lerp(from[1], to[1], duration),
                    self:lerp(from[2], to[2], duration),
                    self:lerp(from[3], to[3], duration)
                }
            end

            return from + (to - from) * duration;
        end

        colorful_text.console = function(self, ...)
            for i, v in ipairs({ ... }) do
                if type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
                    for k = 1, #v[3] do
                        local l = self:lerp(v[1], v[2], k / #v[3]);
                        client.color_log(l[1], l[2], l[3], v[3]:sub(k, k) .. '\0')
                    end
                elseif type(v[1]) == 'table' and type(v[2]) == 'string' then
                    client.color_log(v[1][1], v[1][2], v[1][3], v[2] .. '\0')
                end
            end
        end

        colorful_text.text = function(self, ...)
            local menu = false
            local alpha = 255
            local f = ''

            for i, v in ipairs({ ... }) do
                if type(v) == 'boolean' then
                    menu = v;
                elseif type(v) == 'number' then
                    alpha = v;
                elseif type(v) == 'string' then
                    f = f .. v;
                elseif type(v) == 'table' then
                    if type(v[1]) == 'table' and type(v[2]) == 'string' then
                        f = f .. ('\a%02x%02x%02x%02x'):format(v[1][1], v[1][2], v[1][3], alpha) .. v[2]
                    elseif type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
                        for k = 1, #v[3] do
                            local g = self:lerp(v[1], v[2], k / #v[3])
                            f = f .. ('\a%02x%02x%02x%02x'):format(g[1], g[2], g[3], alpha) .. v[3]:sub(k, k)
                        end
                    end
                end
            end

            return ('%s\a%s%02x'):format(f, (menu) and 'cdcdcd' or 'ffffff', alpha)
        end

        colorful_text.log = function(self, ...)
            for i, v in ipairs({ ... }) do
                if type(v) == 'table' then
                    if type(v[1]) == 'table' then
                        if type(v[2]) == 'string' then
                            self:console({ v[1], v[1], v[2] })
                            if (v[3]) then
                                self:console({ { 255, 255, 255 }, '\n' })
                            end
                        elseif type(v[2]) == 'table' then
                            self:console({ v[1], v[2], v[3] })
                            if v[4] then
                                self:console({ { 255, 255, 255 }, '\n' })
                            end
                        end
                    elseif type(v[1]) == 'string' then
                        self:console({ { 205, 205, 205 }, v[1] });
                        if v[2] then
                            self:console({ { 255, 255, 255 }, '\n' })
                        end
                    end
                end
            end
        end

        local log = function(...)
            local ret = { ... };

            local rs, gs, bs, as = 240, 128, 128, 255

            colorful_text:log(
                { { rs, gs, bs }, { bs, gs, rs }, "Ataraxia" },
                { { 100, 100, 100 }, " >> " },
                { { 255, 255, 255 }, string.format(unpack(ret)), true }
            )
        end
        local screen = { client.screen_size() }
        local sx, sy = screen[1], screen[2]
        local cx, cy = sx / 2, sy / 2
        local g_handle_notify = {}

        g_handle_notify = {
            table = {},
            table2 = {},
            ['value'] = {

            },
            render = function()
                local y = sy - 50
                local y3 = 10
                for k, info in pairs(g_handle_notify.table) do
                    if k > 10 then
                        table.remove(g_handle_notify.table, k)
                    end
                    if info.text ~= nil and info ~= '' then
                        local r, g, b, a = ui.get(_u.visual.main_color)

                        info.notify = animate.new_notify(info.notify, 0, 1, info.timer + 3.8 < globals.realtime())
                        info.g_alpha = animate.new_notify(info.g_alpha, 0, 1,
                            info.timer + 3.8 < globals.realtime() and info.notify <= 0.5)
                        info.addy = animate.new_notify(info.addy, (sy + 800), y, info.timer + 3.8 < globals.realtime())

                        local add_y = math.floor(info.addy)
                        local alpha = math.floor(255 * info.g_alpha)
                        local text_sizex, text_sizey = renderer.measure_text('', info.text)

                        if table_contains(ui.get(_u.visual.list), 'Notifications') then
                            renderer.rectangle(cx - text_sizex / 2 - 5, y - 5, text_sizex + 10, text_sizey + 10, 25, 25,
                                25, 150 * info.g_alpha)
                            renderer.gradient(cx - text_sizex / 2 - 5, y - 5, text_sizex / 6 * info.g_alpha, 2, r, g, b,
                                a * info.g_alpha, b, g, r, a * info.g_alpha, true)
                            renderer.gradient(cx - text_sizex / 2 - 5, y - 5, 2, 14 * info.g_alpha, r, g, b,
                                a * info.g_alpha, b, g, r, a * info.g_alpha, false)

                            renderer.gradient(cx - text_sizex / 2 + text_sizex / 6 - 6, y - 5,
                                math.floor(text_sizex / 6 * info.notify), 2, b, g, r, a * info.notify, r, g, b,
                                0 * info.notify, true)


                            renderer.gradient(cx - text_sizex / 2 + text_sizex - text_sizex / 6 + 6,
                                y - 5 + text_sizey + 10, text_sizex / 6 * -info.notify, 2, b, g, r, a * info.notify, r, g,
                                b,
                                0 * info.notify, true)

                            renderer.gradient(cx - text_sizex / 2 + text_sizex - text_sizex / 6 + 6 + text_sizex / 6 - 1,
                                y - 5 + text_sizey + 10, text_sizex / 6 * -info.g_alpha, 2, r, g, b, a * info.g_alpha, b,
                                g,
                                r, a * info.g_alpha, true)

                            renderer.gradient(cx - text_sizex / 2 + text_sizex - text_sizex / 6 + 6 + text_sizex / 6 - 3,
                                y - 5 + text_sizey + 10, 2, -12 * info.g_alpha, r, g, b, a * info.g_alpha, b, g, r,
                                a * info.g_alpha, false)

                            render_w_text(cx - text_sizex / 2, y, 255, 255, 255, alpha, '', 0, info.text)
                        end
                    end

                    y = y - (40 * info.g_alpha)
                    y3 = y3 + (30 * info.g_alpha)

                    if info.timer + 4 < globals.realtime() then
                        table.remove(g_handle_notify.table, k)
                    end
                end
            end,
            paint = function(text)
                table.insert(g_handle_notify.table, {
                    text = text,
                    addy = cy + 200,
                    notify = 0,
                    timer = globals.realtime(),
                    g_alpha = 0
                })
            end,
            paint_2 = function(text, types)
                table.insert(g_handle_notify.table2, {
                    text = text,
                    addy = cy + 200,
                    notify = 0,
                    timer = globals.realtime(),
                    g_alpha = 0,
                    type = types,
                })
            end
        }
        local ____exports = {}
        local TABS = { "antiaim", "visual", "misc" }
        local tabs = { antiaim = {}, visual = {}, misc = {} }
        local tab_callbacks = {
            antiaim = function()
            end,
            visual = function()
            end,
            misc = function()
            end
        }
        local tab_controller = ui.new_combobox(
            "AA",
            "Anti-aimbot angles",
            "Tab controller",
            "antiaim",
            "visual",
            "misc"
        )
        local function isValidKey(key, object)
            return object[key] ~= nil
        end
        local function contains(tbl, val)
            for i = 1, #tbl do
                if tbl[i] == val then
                    return true
                end
            end
            return false
        end

        local ANTIAIM_MOTION = "Global"
        local function antiaim_main()
            local function calc_angle(start_pos, end_pos)
                if start_pos[1] == nil or end_pos[1] == nil then
                    return { 0, 0 }
                end
                local delta_x = end_pos[1] - start_pos[1]
                local delta_y = end_pos[2] - start_pos[2]
                local delta_z = end_pos[3] - start_pos[3]
                if delta_x == 0 and delta_y == 0 then
                    return { delta_z > 0 and 270 or 90, 0 }
                else
                    local hyp = math.sqrt(delta_x * delta_x + delta_y * delta_y)
                    local pitch = math.deg(math.atan2(-delta_z, hyp))
                    local yaw = math.deg(math.atan2(delta_y, delta_x))
                    return { pitch, yaw }
                end
            end
            local enabled  = ui.new_checkbox("AA", "Anti-aimbot angles", "Enabled")

            local left_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Global Left Key", false)

            table.insert(tabs.antiaim, left_key)
            local right_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Global Right Key", false)
            table.insert(tabs.antiaim, right_key)
            local back_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Global Back Key", false)
            table.insert(tabs.antiaim, back_key)
            local Foward_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Global Forward Key", false)
            table.insert(tabs.antiaim, Foward_key)
            local freestanding = ui.new_hotkey("AA", "Anti-aimbot angles", "Key Freestanding", false)
            table.insert(tabs.antiaim, freestanding)

            local lastLeftStatus           = false;
            local lastRightStatus          = false;
            local isFacingLeft             = false;
            local isFacingRight            = false;
            local lastBackStatus           = false;
            local lastForwardStatus        = false;
            local isFacingForward          = false;

            local manual_aa_direction_parm = 0
            local back                     = false;
            local function onFacing()
                if (not ui.get(left_key) == lastLeftStatus) then
                    lastLeftStatus = ui.get(left_key)

                    if (isFacingLeft == true) then
                        isFacingLeft = false
                    else
                        isFacingLeft    = true
                        isFacingRight   = false
                        lastBackStatus  = false;
                        isFacingForward = false
                    end
                end
                if (not ui.get(right_key) == lastRightStatus) then
                    lastRightStatus = ui.get(right_key)
                    if (isFacingRight == true) then
                        isFacingRight = false
                    else
                        isFacingRight   = true
                        isFacingLeft    = false
                        lastBackStatus  = false;
                        isFacingForward = false
                    end
                end

                if (not ui.get(Foward_key) == lastForwardStatus) then
                    lastForwardStatus = ui.get(Foward_key)
                    if (isFacingForward == true) then
                        isFacingForward = false
                    else
                        isFacingRight   = false
                        isFacingLeft    = false
                        lastBackStatus  = false;
                        isFacingForward = true
                    end
                end
                if (not ui.get(back_key) == back) then
                    back = ui.get(back_key)

                    if lastBackStatus then
                        lastBackStatus = false
                    else
                        lastBackStatus = true
                        if (isFacingRight == true) then
                            isFacingRight = false
                        end

                        if (isFacingLeft == true) then
                            isFacingLeft = false
                        end
                        lastForwardStatus = false
                    end
                end

                manual_aa_direction_parm = 0 --初始化掉

                if (isFacingLeft == true) then
                    manual_aa_direction_parm = -90
                elseif (isFacingRight == true) then
                    manual_aa_direction_parm = 90
                elseif (lastBackStatus) then
                    manual_aa_direction_parm = 0
                elseif (isFacingForward) then
                    manual_aa_direction_parm = 180
                end

                if (manual_aa_direction_parm == 0) then

                else

                end
            end

            local ____tabs_antiaim_0 = tabs.antiaim
            ____tabs_antiaim_0[#____tabs_antiaim_0 + 1] = enabled
            local motions = {
                "Global",
                "Standing",
                "Moving",
                "Slow-walking",
                "T-Duck",
                "CT-Duck",
                "Air",
                "Air-duck"
            }
            local motions_selector = ui.new_combobox(
                "AA",
                "Anti-aimbot angles",
                "Motions",
                "Global",
                "Standing",
                "Moving",
                "Slow-walking",
                "T-Duck",
                "CT-Duck",
                "Air",
                "Air-duck"
            )
            local ____tabs_antiaim_1 = tabs.antiaim
            ____tabs_antiaim_1[#____tabs_antiaim_1 + 1] = motions_selector
            local antiaim_uis = __TS__New(Map)
            local function ui_callback()
                antiaim_uis:forEach(function(____, element, index)
                    local vis1 = ui.get(motions_selector) == index and ui.get(enabled)
                    for ____, _index in __TS__Iterator(element:keys()) do
                        local vis2 = true
                        local vis3 = true
                        if index ~= "Global" then
                            vis3 = ui.get(element:get("enable"))
                        end
                        if _index == "enable" then
                            vis3 = true
                        end
                        if _index == "yaw_custom1" then
                            vis2 = ui.get(element:get("yaw")) == "180" or ui.get(element:get("yaw")) == "Spin" or
                                ui.get(element:get("yaw")) == "3-Way" or ui.get(element:get("yaw")) == "5-Way"
                        end
                        if _index == "yaw_custom2" then
                            vis2 = ui.get(element:get("yaw")) == "3-Way" or ui.get(element:get("yaw")) == "5-Way"
                        end
                        if _index == "yaw_custom3" then
                            vis2 = ui.get(element:get("yaw")) == "3-Way" or ui.get(element:get("yaw")) == "5-Way"
                        end
                        if _index == "yaw_custom4" then
                            vis2 = ui.get(element:get("yaw")) == "5-Way"
                        end
                        if _index == "yaw_custom5" then
                            vis2 = ui.get(element:get("yaw")) == "5-Way"
                        end
                        if _index == "jitter_custom1" then
                            vis2 = ui.get(element:get("jitter")) ~= "Off"
                        end
                        ui.set_visible(
                            element:get(_index),
                            vis1 and vis2 and vis3
                        )
                    end
                end)
            end
            tab_callbacks.antiaim = ui_callback
            ui.set_callback(motions_selector, ui_callback)
            ui.set_callback(enabled, ui_callback)
            local hide_og = (function()
                local pitch                   = ui.reference("AA", "Anti-aimbot angles", "Pitch")
                local base                    = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
                local yaw, yaw_slider         = ui.reference("AA", "Anti-aimbot angles", "Yaw")
                local jitter, jitter_slider   = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
                local bodyyaw, bodyyaw_slider = ui.reference("AA", "Anti-aimbot angles", "Body Yaw")
                local fby                     = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")

              
                local Edgeyaw                 = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
                local Freestanding            = ui.reference("AA", "Anti-aimbot angles", "Freestanding")

                return function(bool)
                    bool = not bool

                    ui.set_visible(pitch, bool)
                    ui.set_visible(base, bool)
                    ui.set_visible(yaw, bool)
                    ui.set_visible(yaw_slider, bool)
                    ui.set_visible(jitter, bool)
                    ui.set_visible(jitter_slider, bool)
                    ui.set_visible(bodyyaw, bool)
                    ui.set_visible(bodyyaw_slider, bool)
                    ui.set_visible(fby, bool)

              
                    ui.set_visible(Edgeyaw, bool)
                    ui.set_visible(Freestanding, bool)
                end
            end)()
            local references = {
             
                aa_enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
                body_freestanding = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
                pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
                yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
                body_yaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
                yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
                jitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
         
                edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
                freestanding = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
                fake_lag = ui.reference("AA", "Fake lag", "Amount"),
                fake_lag_limit = ui.reference("AA", "Fake lag", "Limit"),
                fakeduck = ui.reference("Rage", "Other", "Duck peek assist"),
                legmovement = ui.reference("AA", "Other", "Leg movement"),
                slow_walk = { ui.reference("AA", "Other", "Slow motion") },
                roll = { ui.reference("AA", "Anti-aimbot angles", "Roll") },
                doubletap = { ui.reference("Rage", "Aimbot", "Double Tap") },
               
                dt_hit_chance = ui.reference("Rage", "Aimbot", "Double tap hit chance"),
                osaa = { ui.reference("AA", "Other", "On shot anti-aim") },
                mindmg = ui.reference("Rage", "Aimbot", "Minimum damage"),
                fba_key = ui.reference("Rage", "Aimbot", "Force body aim"),
                fsp_key = ui.reference("Rage", "Aimbot", "Force safe point"),
                ap = ui.reference("Rage", "Other", "Delay shot"),
                slowmotion_key = ui.reference("AA", "Other", "Slow motion"),
                quick_peek = { ui.reference("Rage", "Other", "Quick peek assist") },
                untrust = ui.reference("Misc", "Settings", "Anti-untrusted"),

                third = ui.reference("Visuals", "Effects", "Force Third Person (alive)")
            }

            local function normalize_yaw(yaw)
                while yaw > 180 do yaw = yaw - 360 end
                while yaw < -180 do yaw = yaw + 360 end
                return yaw
            end

            __TS__ArrayForEach(
                motions,
                function(____, Element)
                    local antiaim = __TS__New(Map)
                    if Element ~= "Global" then
                        antiaim:set(
                            "enable",
                            ui.new_checkbox("AA", "Anti-aimbot angles", "Enable " .. Element)
                        )
                        local ____tabs_antiaim_2 = tabs.antiaim
                        ____tabs_antiaim_2[#____tabs_antiaim_2 + 1] = antiaim:get("enable")
                        ui.set_callback(
                            antiaim:get("enable"),
                            ui_callback
                        )
                    end
                    antiaim:set(
                        "yaw_base",
                        ui.new_combobox(
                            "AA",
                            "Anti-aimbot angles",
                            Element .. " Yaw Base",
                            "Local view",
                            "At targets"
                        )
                    )
                    local ____tabs_antiaim_3 = tabs.antiaim
                    ____tabs_antiaim_3[#____tabs_antiaim_3 + 1] = antiaim:get("yaw_base")
                    antiaim:set(
                        "pitch",
                        ui.new_combobox(
                            "AA",
                            "Anti-aimbot angles",
                            Element .. " Pitch",
                            "Off",
                            "Up",
                            "Down"
                        )
                    )
                    local ____tabs_antiaim_4 = tabs.antiaim
                    ____tabs_antiaim_4[#____tabs_antiaim_4 + 1] = antiaim:get("pitch")
                    antiaim:set(
                        "yaw",
                        ui.new_combobox(
                            "AA",
                            "Anti-aimbot angles",
                            Element .. " Yaw",
                            "Off",
                            "180",
                            "3-Way",
                            "5-Way",
                            "Spin"
                        )
                    )
                    local ____tabs_antiaim_5 = tabs.antiaim
                    ____tabs_antiaim_5[#____tabs_antiaim_5 + 1] = antiaim:get("yaw")
                    antiaim:set(
                        "yaw_custom1",
                        ui.new_slider(
                            "AA",
                            "Anti-aimbot angles",
                            ("\n" .. Element) .. " Yaw_c1",
                            -180,
                            180,
                            0
                        )
                    )
                    local ____tabs_antiaim_6 = tabs.antiaim
                    ____tabs_antiaim_6[#____tabs_antiaim_6 + 1] = antiaim:get("yaw_custom1")
                    antiaim:set(
                        "yaw_custom2",
                        ui.new_slider(
                            "AA",
                            "Anti-aimbot angles",
                            ("\n" .. Element) .. " Yaw_c2",
                            -180,
                            180,
                            0
                        )
                    )
                    local ____tabs_antiaim_7 = tabs.antiaim
                    ____tabs_antiaim_7[#____tabs_antiaim_7 + 1] = antiaim:get("yaw_custom2")
                    antiaim:set(
                        "yaw_custom3",
                        ui.new_slider(
                            "AA",
                            "Anti-aimbot angles",
                            ("\n" .. Element) .. " Yaw_c3",
                            -180,
                            180,
                            0
                        )
                    )
                    local ____tabs_antiaim_8 = tabs.antiaim
                    ____tabs_antiaim_8[#____tabs_antiaim_8 + 1] = antiaim:get("yaw_custom3")
                    antiaim:set(
                        "yaw_custom4",
                        ui.new_slider(
                            "AA",
                            "Anti-aimbot angles",
                            ("\n" .. Element) .. " Yaw_c4",
                            -180,
                            180,
                            0
                        )
                    )
                    local ____tabs_antiaim_9 = tabs.antiaim
                    ____tabs_antiaim_9[#____tabs_antiaim_9 + 1] = antiaim:get("yaw_custom4")
                    antiaim:set(
                        "yaw_custom5",
                        ui.new_slider(
                            "AA",
                            "Anti-aimbot angles",
                            ("\n" .. Element) .. " Yaw_c5",
                            -180,
                            180,
                            0
                        )
                    )
                    local ____tabs_antiaim_10 = tabs.antiaim
                    ____tabs_antiaim_10[#____tabs_antiaim_10 + 1] = antiaim:get("yaw_custom5")
                    antiaim:set(
                        "jitter",
                        ui.new_combobox(
                            "AA",
                            "Anti-aimbot angles",
                            Element .. " Jitter",
                            "Off",
                            "Offset",
                            "Center",
                            "Random"
                        )
                    )
                    local ____tabs_antiaim_11 = tabs.antiaim
                    ____tabs_antiaim_11[#____tabs_antiaim_11 + 1] = antiaim:get("jitter")
                    antiaim:set(
                        "jitter_custom1",
                        ui.new_slider(
                            "AA",
                            "Anti-aimbot angles",
                            ("\n" .. Element) .. " jitter_c1 \a" .. Element,
                            -180,
                            180,
                            0
                        )
                    )
                    local ____tabs_antiaim_12 = tabs.antiaim
                    ____tabs_antiaim_12[#____tabs_antiaim_12 + 1] = antiaim:get("jitter_custom1")
                    antiaim:set(
                        "bodyyaw_side",
                        ui.new_combobox(
                            "AA",
                            "Anti-aimbot angles",
                            "Fake Yaw Side\n" .. Element,
                            "Left",
                            "Right",
                            "TANK"
                        )
                    )
                    local ____tabs_antiaim_13 = tabs.antiaim
                    ____tabs_antiaim_13[#____tabs_antiaim_13 + 1] = antiaim:get("bodyyaw_side")
                    antiaim:set(
                        "fake_yaw_limit",
                        ui.new_slider(
                            "AA",
                            "Anti-aimbot angles",
                            "Fake yaw Limit\n" .. Element,
                            0,
                            60,
                            60
                        )
                    )
                    local ____tabs_antiaim_14 = tabs.antiaim
                    ____tabs_antiaim_14[#____tabs_antiaim_14 + 1] = antiaim:get("fake_yaw_limit")
                    ui.set_callback(
                        antiaim:get("yaw"),
                        ui_callback
                    )
                    ui.set_callback(
                        antiaim:get("jitter"),
                        ui_callback
                    )
                    antiaim_uis:set(Element, antiaim)
                end
            )

            if ui.get(tab_controller) == "antiaim" then
                ui_callback()
            end

           -- local break_lagcomp = ui.new_checkbox("AA", "Anti-aimbot angles", "Break lag compensation")
            local ____tabs_antiaim_15 = tabs.antiaim
            ____tabs_antiaim_15[#____tabs_antiaim_15 + 1] = break_lagcomp
            local break_lagcomp_hotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "blc", true)
            local ____tabs_antiaim_16 = tabs.antiaim
            ____tabs_antiaim_16[#____tabs_antiaim_16 + 1] = break_lagcomp_hotkey

            local enable_roll = ui.new_hotkey("AA", "Anti-aimbot angles", "Enable Force Roll", false)
            table.insert(tabs.antiaim,enable_roll)
            local roll_value = ui.new_slider(
                "AA",
                "Anti-aimbot angles",
                "Roll value",
                0,
                90,
                0
            )
            table.insert(tabs.antiaim,roll_value)
            local function velocity()
                local me = entity.get_local_player()
                if me == nil then
                    return 0
                end
                local velocity = { entity.get_prop(me, "m_vecVelocity") }
                return math.floor(math.sqrt(velocity[1] * velocity[1] + velocity[2] * velocity[2]) + 0.5)
            end
            local function inair()
                local localplayer = entity.get_local_player()
                if localplayer == nil then
                    return false
                end
                return bit.band(
                        entity.get_prop(localplayer, "m_fFlags"),
                        1
                    ) == 0
            end
            local function crouching()
                local localplayer = entity.get_local_player()
                if localplayer == nil then
                    return false
                end
                return entity.get_prop(localplayer, "m_flDuckAmount") ~= 0
            end
            local Slowwalk = { ui.reference("AA", "Other", "Slow motion") }
            local function get_motion()
                local localplayer = entity.get_local_player()
                if localplayer == nil then
                    return "Global"
                end
                if inair() and crouching() and ui.get(antiaim_uis:get("Air-duck"):get("enable")) then
                    return "Air-duck"
                end
                if inair() and ui.get(antiaim_uis:get("Air"):get("enable")) then
                    return "Air"
                end
                if crouching() and entity.get_prop(localplayer, "m_iTeamNum") == 3 and ui.get(antiaim_uis:get("CT-Duck"):get("enable")) then
                    return "CT-Duck"
                end
                if crouching() and entity.get_prop(localplayer, "m_iTeamNum") == 2 and ui.get(antiaim_uis:get("T-Duck"):get("enable")) then
                    return "T-Duck"
                end
                if ui.get(Slowwalk[1]) and ui.get(Slowwalk[2]) and ui.get(antiaim_uis:get("Slow-walking"):get("enable")) then
                    return "Slow-walking"
                end
                if (velocity() > 3 and ui.get(antiaim_uis:get("Moving"):get("enable"))) and not inair() then
                    return "Moving"
                elseif ui.get(antiaim_uis:get("Standing"):get("enable")) then
                    return "Standing"
                end
                return "Global"
            end
            local ground_time = 0
            local function break_lc_exploit(cmd)
                cmd.force_defensive = false
          --     if ui.get(break_lagcomp) == false or ui.get(break_lagcomp_hotkey) == false or (ui.get(references.doubletap[1]) and ui.get(references.doubletap[2])) == false then
              --      return
              --  end
               
                cmd.force_defensive = true
            end
            local step = 1
            local flip = true
            local req_roll = 0
            client.set_event_callback(
                "paint_ui",
                function()
                    if ui.get(enabled) then
                        hide_og(true)
                    end
                end
            )
            client.set_event_callback(
                "shutdown",
                function()
                    hide_og(false)
                end
            )
            
            client.set_event_callback(
                "setup_command",
                function(e)
                    if not ui.get(enabled) then
                        return
                    end

                    local localplayer = entity.get_local_player()
                    if localplayer == nil then
                        return
                    end

                    local motion = get_motion()
                    local antiaim_ui = antiaim_uis:get(get_motion())
                    ANTIAIM_MOTION = motion
			                    local camera_angles = { client.camera_angles() }
                    local pitch = camera_angles[1]

                    local stop_cmd_yaw = false

                    ui.set(references.pitch, "Off")
                    if ui.get(antiaim_ui:get("pitch")) == "Down" then
                        pitch = 90
                        ui.set(references.pitch, "Down")
                    elseif ui.get(antiaim_ui:get("pitch")) == "Up" then
                        pitch = -90
                        ui.set(references.pitch, "Up")
                    end
                    local yaw = 0
                    repeat
                        local ____switch60 = ui.get(antiaim_ui:get("yaw"))
                        local ____cond60 = ____switch60 == "Off"
                        if ____cond60 then
                            yaw = -180
                            break
                        end
                        ____cond60 = ____cond60 or ____switch60 == "180"
                        if ____cond60 then
                            yaw = ui.get(antiaim_ui:get("yaw_custom1"))
                            break
                        end
                        ____cond60 = ____cond60 or ____switch60 == "Spin"
                        if ____cond60 then
                            yaw = 360 * (globals.curtime() % 2) * (2 * (ui.get(antiaim_ui:get("yaw_custom1")) / 180))
                            break
                        end
                        do
                            yaw = ui.get(antiaim_ui:get("yaw_custom" .. tostring(step)))
                            break
                        end
                    until true
                    local jitter = 0
                    repeat
                        local ____switch61 = ui.get(antiaim_ui:get("jitter"))
                        local ____cond61 = ____switch61 == "Off"
                        if ____cond61 then
                            break
                        end
                        ____cond61 = ____cond61 or ____switch61 == "Offset"
                        if ____cond61 then
                            local ____flip_17
                            if flip then
                                ____flip_17 = ui.get(antiaim_ui:get("jitter_custom1"))
                            else
                                ____flip_17 = 0
                            end
                            jitter = ____flip_17
                            break
                        end
                        ____cond61 = ____cond61 or ____switch61 == "Center"
                        if ____cond61 then
                            local ____flip_18
                            if flip then
                                ____flip_18 = ui.get(antiaim_ui:get("jitter_custom1"))
                            else
                                ____flip_18 = -ui.get(antiaim_ui:get("jitter_custom1"))
                            end
                            jitter = ____flip_18
                            jitter = jitter / 2
                            break
                        end
                        ____cond61 = ____cond61 or ____switch61 == "Random"
                        if ____cond61 then
                            jitter = math.random(
                                ui.get(antiaim_ui:get("jitter_custom1")),
                                -ui.get(antiaim_ui:get("jitter_custom1"))
                            )
                            break
                        end
                    until true
                    if e.chokedcommands == 0 then
                        flip = not flip
                        if ui.get(antiaim_ui:get("yaw")) == "3-Way" then
                            step = step + 1
                            if step > 3 then
                                step = 1
                            end
                        elseif ui.get(antiaim_ui:get("yaw")) == "5-Way" then
                            step = step + 1
                            if step > 5 then
                                step = 1
                            end
                        end
                    end

                    if e.chokedcommands < 3 then
                        e.allow_send_packet = false
                    end
                    local yaw_base = camera_angles[2] + 180
                    if ui.get(antiaim_ui:get("yaw_base")) == "At targets" then
                        local target = client.current_threat()
                        if target and entity.is_alive(target) then
                            local pos = { entity.get_origin(target) }
                            if pos[1] then
                                local pos2 = { client.eye_position() }
                                local angle = calc_angle(pos2, pos)
                                yaw_base = normalize_yaw(angle[2] + 180)
                            end
                        end
                    else
                        yaw_base = camera_angles[2] + 180
                    end
                    onFacing()
                    if isFacingLeft or isFacingRight or lastBackStatus or lastForwardStatus then
                        yaw_base = normalize_yaw(camera_angles[2] + 180 + manual_aa_direction_parm)
                    else
                        yaw_base = normalize_yaw(yaw_base + yaw + jitter)
                        ui.set(references.yaw[1], "180")
                        if (yaw+jitter) <=180 and (yaw+jitter)>=-180 then
                        ui.set(references.yaw[2], yaw + jitter)
                        end
                    end
                    if ui.get(freestanding) then
                        ui.set(references.freestanding[1], true)
                        ui.set(references.freestanding[2], "Always on")
                    else
                        ui.set(references.freestanding[1], false)
                        ui.set(references.freestanding[2], "Always on")
                    end
                    local me = entity.get_local_player()
                    local my_weapon = entity.get_player_weapon(me)

                
                    if my_weapon ~= nil then
                        local timer = globals.curtime()
                        local can_Fire = entity.get_prop(me, "m_flNextAttack") <= timer and
                            entity.get_prop(my_weapon, "m_flNextPrimaryAttack") <= timer
                        local wpn = entity.get_prop(my_weapon, "m_iItemDefinitionIndex")

                        local holding_grenade = wpn >= 43 and wpn <= 48
                        --print((e.in_attack ~=0 or e.in_attack2 ~=0 or e.in_grenade1 ~= 0 or e.in_grenade2 ~=0))
                       
                        if holding_grenade or (e.in_attack ~= 0 or e.in_attack2 ~= 0 or e.in_grenade1 ~= 0 or e.in_grenade2 ~= 0) or (entity.get_prop(me, "m_MoveType") or 0) == 9 then
                            stop_cmd_yaw = true
                        end
                        
                        if (((e.in_attack == 0) or not can_Fire) and not stop_cmd_yaw and e.in_use == 0) and not ui.get(freestanding) then
                            if e.chokedcommands == 0 then
                                e.yaw = yaw_base + ui.get(references.body_yaw[2])
                            else
                                e.yaw = yaw_base
                            end
                            
                            e.pitch = pitch
                            
                            if   ui.get(enable_roll) then
                                
                                req_roll =  antiaim_funcs.get_desync(1) > 0 and ui.get(roll_value)  or -ui.get(roll_value) 
                            else
                                req_roll = 0
                            end
                        else
                            e.yaw = camera_angles[2]
                            e.pitch = camera_angles[1]
                        end
                    end
                    ui.set(references.body_yaw[1], "Static")
                    local fake_yaw = ui.get(antiaim_ui:get("fake_yaw_limit"))
                    if ui.get(antiaim_ui:get("bodyyaw_side")) == "Left" then
                        ui.set(references.body_yaw[2], 60 + fake_yaw)
                    elseif ui.get(antiaim_ui:get("bodyyaw_side")) == "Right" then
                        ui.set(references.body_yaw[2], -60 - fake_yaw)
                    else
                        ui.set(references.body_yaw[2], flip and -60 - fake_yaw or 60 + fake_yaw)
                    end
                    local air = inair()
                    if not air then
                        ground_time = ground_time + 1
                    else
                        ground_time = 0
                    end

                    break_lc_exploit(e)
                end
            )
            client.set_event_callback("run_command",function(e)
                if req_roll ~= 0 then
                    local pUserCmd = g_pInput.vfptr.GetUserCmd(ffi.cast("uintptr_t", g_pInput), 0, e.command_number)
                            if (pUserCmd ~= nil) and req_roll ~= 0 then
                                pUserCmd.viewangles.roll = req_roll
                            end
                end
            end)

            
        end
        antiaim_main()
        local function visual_main()
            local _draggable = (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=ui.new_slider("LUA","A",u.." window position",0,x,v/j*x)local z=ui.new_slider("LUA","A","\n"..u.." window position y",0,x,w/k*x)ui.set_visible(y,false)ui.set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals.framecount()~=b then c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)()
            local debug_panle = _draggable.new("debug_panle", 310, 100)
            local tab1, tab2           = "AA", "Anti-Aimbot angles"
            _u.visual.main_color_lable = ui.new_label(tab1, tab2, 'Main Color')
            _u.visual.main_color       = (ui.new_color_picker(tab1, tab2, 'Color', 240, 128, 128, 255))
            _u.visual.animation_speed  = (ui.new_slider(tab1, tab2, "Animations Speed", 4, 24, 12, true, "fr", 0.4))
            _u.visual.list             = (ui.new_multiselect(tab1, tab2, 'Settings', { "Center", "Notifications","Debug Info" }))

            _u.visual.notifications    = (ui.new_multiselect(tab1, tab2, 'Notifications', { 'Log ragebot', 'Log antiaim' }))

            for i, v in pairs(_u.visual) do
                table.insert(tabs.visual, v)
            end
            local rounded_gradient_rectangle = function(x, y, w, h, r, color1, color2, color3, color4, background, max_alpha, padding, thickness, percent)
                x = math.floor(x)
                y = math.floor(y)
                w = math.floor(w)
                h = math.floor(h)
        
                color1[4] = math.min(color1[4], max_alpha)
                color2[4] = math.min(color2[4], max_alpha)
                color3[4] = math.min(color3[4], max_alpha)
                color4[4] = math.min(color4[4], max_alpha)
                background[4] = math.min(background[4], max_alpha)
        
                local anims = {}
        
                anims[1] = math.max(0, math.min(percent * 2, 1))
                anims[2] = anims[1] == 1 and math.max(0, math.min((percent - 0.5) * 2, 1)) or 0
        
                --Background
                renderer.rectangle(x + r, y + r, w - r * 2, h - r * 2, background[1], background[2], background[3], background[4] * anims[1])
        
                renderer.rectangle(x + r, y, w - (r * 2), r, background[1], background[2], background[3], background[4] * anims[1])
                renderer.rectangle(x, y + r, r, h - (r * 2), background[1], background[2], background[3], background[4] * anims[1])
                renderer.rectangle(x + r, y + h - r, w - (r * 2), r, background[1], background[2], background[3], background[4] * anims[1])
                renderer.rectangle(x + w - r, y + r, r, h - (r * 2), background[1], background[2], background[3], background[4] * anims[1])
        
                renderer.circle(x + r, y + r, background[1], background[2], background[3], background[4] * anims[1], r, 180, 0.25)
                renderer.circle(x + w - r, y + r, background[1], background[2], background[3], background[4] * anims[1], r, 90, 0.25)
                renderer.circle(x + r, y + h - r, background[1], background[2], background[3], background[4] * anims[1], r, 270, 0.25)
                renderer.circle(x + w - r, y + h - r, background[1], background[2], background[3], background[4] * anims[1], r, 0, 0.25)
        
                --Gradient outline
                renderer.gradient(x + r, y + padding, (w - (r * 2)), thickness, color1[1], color1[2], color1[3], color1[4] * anims[2], color2[1], color2[2], color2[3], color2[4] * anims[2], true)
                renderer.gradient(x + w - padding - thickness, y + r, thickness, (h - (r * 2)), color2[1], color2[2], color2[3], color2[4] * anims[2], color3[1], color3[2], color3[3], color3[4] * anims[2], false)
                renderer.gradient(x + w - padding - r + 1, y + h - padding - thickness, -((w) - (r * 2)), thickness, color3[1], color3[2], color3[3], color3[4] * anims[2], color4[1], color4[2], color4[3], color4[4] * anims[2], true)
                renderer.gradient(x + padding, y + h - r, thickness, -(h - (r * 2)), color4[1], color4[2], color4[3], color4[4] * anims[2], color1[1], color1[2], color1[3], color1[4] * anims[2], false)
        
                renderer.circle_outline(x + r + padding, y + r + padding, color1[1], color1[2], color1[3], color1[4] * anims[2], r, 180, 0.25, thickness)
                renderer.circle_outline(x + w - r - padding, y + r + padding, color2[1], color2[2], color2[3], color2[4] * anims[2], r, 270, 0.25, thickness)
                renderer.circle_outline(x + r + padding, y + h - r - padding, color4[1], color4[2], color4[3], color4[4] * anims[2], r, 90, 0.25, thickness)
                renderer.circle_outline(x + w - r - padding, y + h - r - padding, color3[1], color3[2], color3[3], color3[4] * anims[2], r, 0, 0.25, thickness)
            end

            local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
                local output = ''

                local len = #text - 1

                local rinc = (r2 - r1) / len
                local ginc = (g2 - g1) / len
                local binc = (b2 - b1) / len
                local ainc = (a2 - a1) / len

                for i = 1, len + 1 do
                    output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))

                    r1 = r1 + rinc

                    g1 = g1 + ginc
                    b1 = b1 + binc
                    a1 = a1 + ainc
                end

                return output
            end

            local function velocity()
                local me = entity.get_local_player()
                if me == nil then
                    return 0
                end
                local velocity = { entity.get_prop(me, "m_vecVelocity") }
                return math.floor(math.sqrt(velocity[1] * velocity[1] + velocity[2] * velocity[2]) + 0.5)
            end

            
            local cat_svg =
            [[<svg t="1650815150236" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1757" width="200" height="200"><path d="M750.688207 480.651786c-40.458342 65.59852-115.105654 102.817686-205.927943 117.362627 2.382361 26.853806 0.292571 62.00408 20.897903 102.232546 40.77181 79.621013 76.486328 166.28462 88.356337 229.897839 69.819896 30.824408 215.958937-42.339153 257.671154-134.540705 44.721514-98.847085 0-202.082729-74.103967-210.755359-74.083069-8.651732-117.655198 31.555835-109.902076 78.65971 7.732224 47.103875 51.868597 47.918893 96.485622 16.822812 44.617024-31.075183 85.869486 32.517138 37.992389 60.562125-47.897995 28.044987-124.133548 44.867799-168.228125-5.642434-44.094577-50.489335-40.458342-228.205109 143.65219-211.716662 184.110532 16.509344 176.127533 261.683551 118.804583 344.042189C894.465785 956.497054 823.600993 1024.519731 616.37738 1023.997283h-167.18323V814.600288 1023.997283h-168.269921c-83.424432 0-24.743118-174.267619 51.826801-323.750324 20.584435-40.228465 18.494645-75.378739 20.897904-102.232546C262.784849 583.469472 188.137536 546.250306 147.679195 480.651786H93.867093A20.814312 20.814312 0 0 1 73.031883 459.753882c0-11.535643 9.46675-20.897904 20.83521-20.897903H127.993369a236.480679 236.480679 0 0 1-10.093687-41.795808H52.071285A20.814312 20.814312 0 0 1 31.236075 376.162267c0-11.535643 9.46675-20.897904 20.83521-20.897903H114.82769v-0.877712c0-57.009481 15.171878-103.131155 41.795808-139.514406V28.379353c0-11.535643 8.630834-17.136281 19.267867-12.517844l208.979037 90.864085c20.793414-2.08979 42.318255-3.113788 64.323748-3.113787s43.530333 1.044895 64.344646 3.134685l208.979037-90.884983c10.616135-4.618437 19.246969 0.982201 19.246969 12.538742v186.471995c26.623929 36.38325 41.795807 82.504924 41.795808 139.514406V355.264364h62.756405c11.493847 0 20.83521 9.278669 20.83521 20.897903 0 11.535643-9.46675 20.897904-20.83521 20.897904h-65.828397a236.480679 236.480679 0 0 1-10.093688 41.795808h34.126277c11.493847 0 20.83521 9.278669 20.83521 20.897903 0 11.535643-9.46675 20.897904-20.83521 20.897904h-53.833z" p-id="1758" fill="#ffffff"></path></svg>           ]]
            local cat_outline_png =
            [[iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAABGdBTUEAALGPC/xhBQAACklpQ0NQc1JHQiBJRUM2MTk2Ni0yLjEAAEiJnVN3WJP3Fj7f92UPVkLY8LGXbIEAIiOsCMgQWaIQkgBhhBASQMWFiApWFBURnEhVxILVCkidiOKgKLhnQYqIWotVXDjuH9yntX167+3t+9f7vOec5/zOec8PgBESJpHmomoAOVKFPDrYH49PSMTJvYACFUjgBCAQ5svCZwXFAADwA3l4fnSwP/wBr28AAgBw1S4kEsfh/4O6UCZXACCRAOAiEucLAZBSAMguVMgUAMgYALBTs2QKAJQAAGx5fEIiAKoNAOz0ST4FANipk9wXANiiHKkIAI0BAJkoRyQCQLsAYFWBUiwCwMIAoKxAIi4EwK4BgFm2MkcCgL0FAHaOWJAPQGAAgJlCLMwAIDgCAEMeE80DIEwDoDDSv+CpX3CFuEgBAMDLlc2XS9IzFLiV0Bp38vDg4iHiwmyxQmEXKRBmCeQinJebIxNI5wNMzgwAABr50cH+OD+Q5+bk4eZm52zv9MWi/mvwbyI+IfHf/ryMAgQAEE7P79pf5eXWA3DHAbB1v2upWwDaVgBo3/ldM9sJoFoK0Hr5i3k4/EAenqFQyDwdHAoLC+0lYqG9MOOLPv8z4W/gi372/EAe/tt68ABxmkCZrcCjg/1xYW52rlKO58sEQjFu9+cj/seFf/2OKdHiNLFcLBWK8ViJuFAiTcd5uVKRRCHJleIS6X8y8R+W/QmTdw0ArIZPwE62B7XLbMB+7gECiw5Y0nYAQH7zLYwaC5EAEGc0Mnn3AACTv/mPQCsBAM2XpOMAALzoGFyolBdMxggAAESggSqwQQcMwRSswA6cwR28wBcCYQZEQAwkwDwQQgbkgBwKoRiWQRlUwDrYBLWwAxqgEZrhELTBMTgN5+ASXIHrcBcGYBiewhi8hgkEQcgIE2EhOogRYo7YIs4IF5mOBCJhSDSSgKQg6YgUUSLFyHKkAqlCapFdSCPyLXIUOY1cQPqQ28ggMor8irxHMZSBslED1AJ1QLmoHxqKxqBz0XQ0D12AlqJr0Rq0Hj2AtqKn0UvodXQAfYqOY4DRMQ5mjNlhXIyHRWCJWBomxxZj5Vg1Vo81Yx1YN3YVG8CeYe8IJAKLgBPsCF6EEMJsgpCQR1hMWEOoJewjtBK6CFcJg4Qxwicik6hPtCV6EvnEeGI6sZBYRqwm7iEeIZ4lXicOE1+TSCQOyZLkTgohJZAySQtJa0jbSC2kU6Q+0hBpnEwm65Btyd7kCLKArCCXkbeQD5BPkvvJw+S3FDrFiOJMCaIkUqSUEko1ZT/lBKWfMkKZoKpRzame1AiqiDqfWkltoHZQL1OHqRM0dZolzZsWQ8ukLaPV0JppZ2n3aC/pdLoJ3YMeRZfQl9Jr6Afp5+mD9HcMDYYNg8dIYigZaxl7GacYtxkvmUymBdOXmchUMNcyG5lnmA+Yb1VYKvYqfBWRyhKVOpVWlX6V56pUVXNVP9V5qgtUq1UPq15WfaZGVbNQ46kJ1Bar1akdVbupNq7OUndSj1DPUV+jvl/9gvpjDbKGhUaghkijVGO3xhmNIRbGMmXxWELWclYD6yxrmE1iW7L57Ex2Bfsbdi97TFNDc6pmrGaRZp3mcc0BDsax4PA52ZxKziHODc57LQMtPy2x1mqtZq1+rTfaetq+2mLtcu0W7eva73VwnUCdLJ31Om0693UJuja6UbqFutt1z+o+02PreekJ9cr1Dund0Uf1bfSj9Rfq79bv0R83MDQINpAZbDE4Y/DMkGPoa5hpuNHwhOGoEctoupHEaKPRSaMnuCbuh2fjNXgXPmasbxxirDTeZdxrPGFiaTLbpMSkxeS+Kc2Ua5pmutG003TMzMgs3KzYrMnsjjnVnGueYb7ZvNv8jYWlRZzFSos2i8eW2pZ8ywWWTZb3rJhWPlZ5VvVW16xJ1lzrLOtt1ldsUBtXmwybOpvLtqitm63Edptt3xTiFI8p0in1U27aMez87ArsmuwG7Tn2YfYl9m32zx3MHBId1jt0O3xydHXMdmxwvOuk4TTDqcSpw+lXZxtnoXOd8zUXpkuQyxKXdpcXU22niqdun3rLleUa7rrStdP1o5u7m9yt2W3U3cw9xX2r+00umxvJXcM970H08PdY4nHM452nm6fC85DnL152Xlle+70eT7OcJp7WMG3I28Rb4L3Le2A6Pj1l+s7pAz7GPgKfep+Hvqa+It89viN+1n6Zfgf8nvs7+sv9j/i/4XnyFvFOBWABwQHlAb2BGoGzA2sDHwSZBKUHNQWNBbsGLww+FUIMCQ1ZH3KTb8AX8hv5YzPcZyya0RXKCJ0VWhv6MMwmTB7WEY6GzwjfEH5vpvlM6cy2CIjgR2yIuB9pGZkX+X0UKSoyqi7qUbRTdHF09yzWrORZ+2e9jvGPqYy5O9tqtnJ2Z6xqbFJsY+ybuIC4qriBeIf4RfGXEnQTJAntieTE2MQ9ieNzAudsmjOc5JpUlnRjruXcorkX5unOy553PFk1WZB8OIWYEpeyP+WDIEJQLxhP5aduTR0T8oSbhU9FvqKNolGxt7hKPJLmnVaV9jjdO31D+miGT0Z1xjMJT1IreZEZkrkj801WRNberM/ZcdktOZSclJyjUg1plrQr1zC3KLdPZisrkw3keeZtyhuTh8r35CP5c/PbFWyFTNGjtFKuUA4WTC+oK3hbGFt4uEi9SFrUM99m/ur5IwuCFny9kLBQuLCz2Lh4WfHgIr9FuxYji1MXdy4xXVK6ZHhp8NJ9y2jLspb9UOJYUlXyannc8o5Sg9KlpUMrglc0lamUycturvRauWMVYZVkVe9ql9VbVn8qF5VfrHCsqK74sEa45uJXTl/VfPV5bdra3kq3yu3rSOuk626s91m/r0q9akHV0IbwDa0b8Y3lG19tSt50oXpq9Y7NtM3KzQM1YTXtW8y2rNvyoTaj9nqdf13LVv2tq7e+2Sba1r/dd3vzDoMdFTve75TsvLUreFdrvUV99W7S7oLdjxpiG7q/5n7duEd3T8Wej3ulewf2Re/ranRvbNyvv7+yCW1SNo0eSDpw5ZuAb9qb7Zp3tXBaKg7CQeXBJ9+mfHvjUOihzsPcw83fmX+39QjrSHkr0jq/dawto22gPaG97+iMo50dXh1Hvrf/fu8x42N1xzWPV56gnSg98fnkgpPjp2Snnp1OPz3Umdx590z8mWtdUV29Z0PPnj8XdO5Mt1/3yfPe549d8Lxw9CL3Ytslt0utPa49R35w/eFIr1tv62X3y+1XPK509E3rO9Hv03/6asDVc9f41y5dn3m978bsG7duJt0cuCW69fh29u0XdwruTNxdeo94r/y+2v3qB/oP6n+0/rFlwG3g+GDAYM/DWQ/vDgmHnv6U/9OH4dJHzEfVI0YjjY+dHx8bDRq98mTOk+GnsqcTz8p+Vv9563Or59/94vtLz1j82PAL+YvPv655qfNy76uprzrHI8cfvM55PfGm/K3O233vuO+638e9H5ko/ED+UPPR+mPHp9BP9z7nfP78L/eE8/stRzjPAAAAIGNIUk0AAHomAACAhAAA+gAAAIDoAAB1MAAA6mAAADqYAAAXcJy6UTwAAAAJcEhZcwAALiMAAC4jAXilP3YAAAVQSURBVGiB3ZrrT9tWGMZ/oSHOZZRyCYxLWtpu6zpNUztp2v7/b5smTWM3elkphUIpBcYlYSFc9uE5R8cYJ/axTSrtkawozrF9nvf+vk7p8vKS/wPKCb/XgUfAiVn73hxFYxaYAc6BCvAncOpzg1KCRmaBBvDKPGgCuIWIrQNn3lt2qAAtIDD32Qd2kOB2gD2fmyVp5NIc4LTRMBv4AugB28ChxzPHkVDKwAWwigRjcW7OeyGJSBzawArSzAKwBHSRBHeAElA1nxfAv+Y6q9HArN3ss+GSObyQhYjFOfDGHNNA03yeAiNIk5ZMxVyzjafJpEUeImF8MEcd2XvYUQOkvU5Bz4pFUUQs4jbbLfgZsRgZxkOGgSQipRRrioa3o0PyJqvAaJYb50DFPNcLSURuIyceJnZRqPbCICILSBvDJrKF9uVFZhCRJjcU81PgEPjU54J+REZQwtvKu6OMeI9yT2r0I1JH9c9QckAMjlBiHUt7QT8i3lHjBtDDYx/hzL4E1JAmmsC7QrfljxO0pwaykCPUOsQi3I98D/yIk0IXV8J/DJRQnQaqoH8A1ujjt2GNHACLqFqtAceoWv1YmDf7aKM0sMeAVBAmsmouOEaqfID6C+8mpwAEqDv9HfnKJ8hCev0uCBPpmmMB2WXN3PAk5rqbhi39W0gjif4a7dnngLvAT4hkXwkMAbbG+xZ4QUJyjvYj+8isppCj30HJ6ajQLQ7GHdRp7qH97aR5ftwUZdQcHWRm88DPDCeClYEnSAMHuJI+8dlJ4yCAe0hDv6Ky5aYwCnyOIlMHFY1nKNhUkZkfI6u5FoDSEAFpZgF4yc0Ukk1ctXtqjh4uUtWQ89dQa7FOJBSnJQKy3RbSyjbqG/KiiarcI1QujaKpzKBIeRvN1LYJZXofIhZzwCSS1oX53MXNrwahZq4NzMYD4C0SzgNgGflDFVmAnYs1kJmt48z7O5TlN7ISCW9qynzWgWcJZMaAz1Cv0UWmYdc/RSa7ZojeB/5BAuoYIrOG4EqI3FfAL8BZnnHQCUYaSJrVBCINlNz+jpyvIGJrKGo9REIJj2FPkZPPAV+jKNpGJB8Cz4qakIyQPNDu4iaOYQS4vmcGaaHfLHkLCfBL8/0dKl8KGfVUkWm1E9bZpBa1glu4PFHies6oIqnfNd9XMZtHpM+hGCLzuFnvIFiNRXvxHi7x7aJB9wTyvXvIr85QtFpC5tRF2R+MgIoYmU4jKaWBtfON0Lk2krD1oTeoneghAi9wpvfEfB7iarEu5CfSMjfaSbn+LdLIPHqtYNFF5rOMG4hH0cRpNTyNLEF+05rFvyXe4vrMagWZ5mNcVwja3yRy7kWkLXB5BUy5kkcj8+Ymvl3kJkp2M1x9H/kH8omW+T6Cwm4Z+cVz3LuWKsozYEwsD5Fpsr8Y/YC0Gb7evoYDSbyMisRoobpoztleKVf4HUcmsJG0sA/WkCTrfX5vozI+rtqewNVYNUxuykpkEUkrKy6Q2bSSFkbwGCVEW7DOkTOPVFAEyoMtPCaJqAwK0Dt4i3FMsMlCZBZFDJ9X0nHYRXY+mWLtI+QLv4XO3UeRbhuyEZmiuKFEB9n8oGc9ReazjPOZMRT1VuzCLFEr4GoyywPb0oZRRhFxHDnza1QRWFRQ+f6SULXtS6SCpFLUy59NJHX7f5dK5BnRLrQCfIMS45XffInUkVkVNYS4RM47icLxPgq7cS3BBGpxXxOThH2JhEvuonDG4MRaRxk/QD5xELfIl0gHqTeubygSDVxvH6AE+degC7L07LY7e4UEkem9OO6/KgHuVcYo7g8558jUUvnjf4WFZF5zAVglAAAAAElFTkSuQmCC]]
            cat_outline_png = renderer.load_png(base64.dec(cat_outline_png), 50, 50)
            local label = ui.new_label("AA", "Anti-Aimbot angles", "Main Color 1")
            local main_color1 = ui.new_color_picker("AA", "Anti-Aimbot angles", "Main Color1", 255, 0, 0, 255)
            local label2 = ui.new_label("AA", "Anti-Aimbot angles", "Main Color 2")
            local main_color2 = ui.new_color_picker("AA", "Anti-Aimbot angles", "Main Color2", 0, 255, 0, 255)

            local label3 = ui.new_label("AA", "Anti-Aimbot angles", "Logo Color")
            local logo_color = ui.new_color_picker("AA", "Anti-Aimbot angles", "Logo_color", 255, 255, 255, 255)
            local lable4 = ui.new_label("AA", "Anti-Aimbot angles", "Logo Outline Color")
            local logo_outline_color = ui.new_color_picker("AA", "Anti-Aimbot angles", "Logo_outline_color", 0, 0, 0, 255)

            local lable6 = ui.new_label("AA", "Anti-Aimbot angles", "Bar Color")
            local bar_color = ui.new_color_picker("AA", "Anti-Aimbot angles", "Bar_color", 255, 255, 255, 255)

            local lable5 = ui.new_label("AA", "Anti-Aimbot angles", "Status Color")
            local status_color = ui.new_color_picker("AA", "Anti-Aimbot angles", "Status_color", 255, 255, 255, 255)

            table.insert(tabs.visual, label)
            table.insert(tabs.visual, main_color1)
            table.insert(tabs.visual, label2)
            table.insert(tabs.visual, main_color2)
            table.insert(tabs.visual, label3)
            table.insert(tabs.visual, logo_color)
            table.insert(tabs.visual, lable6)
            table.insert(tabs.visual, logo_outline_color)
            table.insert(tabs.visual, lable4)
            table.insert(tabs.visual, bar_color)
            table.insert(tabs.visual, lable5)
            table.insert(tabs.visual, status_color)

            local glow_color = function(x, y, long, width, color_r, color_g, color_b, alpha)
                renderer.rectangle(x, y + 0, long, width, color_r, color_g, color_b, alpha)

                for radius = 4, 12 do
                    local radius = radius / 2;
                    renderer.rectangle(x - radius, y - radius, long + radius * 2, width + radius * 2,
                        color_r,
                        color_g,
                        color_b, (12 - radius * 2))
                end
            end;

            cat_svg = renderer.load_svg(cat_svg, 50, 50)
            cat_outline_svg = renderer.load_svg(cat_outline_svg, 50, 50)
            local doubletap = { ui.reference("RAGE", "Aimbot", "Double tap") }

            local doubletap_limit = ui.reference("RAGE", "Aimbot", "Double tap fake lag limit")

            local animate = (function()
                local anim = {}
        
                local lerp = function(start, vend)
                    local anim_speed = ui.get(_u.visual.animation_speed)
                    return start + (vend - start) * (globals.frametime() * anim_speed)
                end
        
                local lerp_notify = function(start, vend)
                    return start + (vend - start) * (globals.frametime() * 8)
                end
        
                
                anim.new_notify = function(value,startpos,endpos,condition)
                    if condition ~= nil then
                        if condition then
                            return lerp_notify(value,startpos)
                        else
                            return lerp_notify(value,endpos)
                        end
        
                    else
                        return lerp_notify(value,startpos)
                    end
                end
        
        
        
                anim.new = function(value,startpos,endpos,condition)
                    if condition ~= nil then
                        if condition then
                            return lerp(value,startpos)
                        else
                            return lerp(value,endpos)
                        end
        
                    else
                        return lerp(value,startpos)
                    end
        
                end
        
                anim.new_color = function(color,color2,end_value,condition)
                    if condition ~= nil then
                        if condition then
                            color.r = lerp(color.r,color2.r)
                            color.g = lerp(color.g,color2.g)
                            color.b = lerp(color.b,color2.b)
                            color.a = lerp(color.a,color2.a)
                        else
                            color.r = lerp(color.r,end_value.r)
                            color.g = lerp(color.g,end_value.g)
                            color.b = lerp(color.b,end_value.b)
                            color.a = lerp(color.a,end_value.a)
                        end
                    else
                        color.r = lerp(color.r,color2.r)
                        color.g = lerp(color.g,color2.g)
                        color.b = lerp(color.b,color2.b)
                        color.a = lerp(color.a,color2.a)
                    end
        
                    return { r = color.r , g = color.g , b = color.b , a = color.a }
                end
        
                anim.new_flash = function(cur,min,max,target,step,speed)
                    local step = step or 1
                    local speed = speed or 0.1
        
                    if cur < min + step then
                        target = max
                    elseif cur > max - step then
                        target = min
                    end
                    
                     
                    return cur + (target - cur) * speed * (globals.absoluteframetime()*10)
                end
        
                return anim
            end)()
            local offset = 0

            local doubletap_charged = function()
                if not ui.get(doubletap[1]) and not ui.get(doubletap[2]) then
                    return false
                end
                if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then
                    return
                end
                local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
                if weapon == nil then
                    return false
                end
        
                local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
                local jewfag = entity.get_prop(weapon, "m_flNextPrimaryAttack")
                if jewfag == nil then
                    return
                end
                local next_primary_attack = jewfag + 0.5
                if next_attack == nil or next_primary_attack == nil then
                    return false
                end
                return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
            end
            client.set_event_callback(
                "paint",
                function()
                    if entity.is_alive(entity.get_local_player()) then
                    else
                        return
                    end
                    local screen_size = { client.screen_size() }
                    local is_scoped = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_zoomLevel") ==
                        1 or entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_zoomLevel") == 2
                        offset = animate.new(offset,1,0,is_scoped)
                        screen_size[1] = screen_size[1] + 60 * offset
                        local modifier = entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") ~= 1
                    if not table_contains(ui.get(_u.visual.list), 'Center') then
                        return
                    end
                    local r, g, b, a = ui.get(main_color1)
                    local r2, g2, b2, a2 = ui.get(main_color2)

                    local render_text = gradient_text(
                        r,
                        g,
                        b,
                        a,
                        r2,
                        g2,
                        b2,
                        a2,
                        "Ataraxia"
                    )
                    local text_x = renderer.measure_text("b", render_text)
                    renderer.text(
                        screen_size[1] / 2 - text_x / 2,
                        screen_size[2] / 2 + 15,
                        r2,
                        g2,
                        b2,
                        a2,
                        "b",
                        0,
                        render_text
                    )

                    
                    local logo = { ui.get(logo_color) }
                    local logo_outline = { ui.get(logo_outline_color) }
                    local dt_anim = antiaim_funcs.get_tickbase_shifting() / (14 - ui.get(doubletap_limit))
                    
                    if doubletap_charged() then
                        if dt_anim < 0.01 then
                            dt_anim = 1
                        end
                       
                    end

                    if ui.get(doubletap[1]) and ui.get(doubletap[2]) then

                    else
                        dt_anim = 0
                    end
                    renderer.texture(cat_svg, screen_size[1] / 2 + text_x / 2, screen_size[2] / 2 + 2, 25, 25, logo[1],
                        logo[2],
                        logo[3],
                        logo[4] * dt_anim, "f")
                    renderer.texture(cat_outline_png, screen_size[1] / 2 + text_x / 2, screen_size[2] / 2 + 2, 25, 25,
                        logo_outline[1],
                        logo_outline[2],
                        logo_outline[3],
                        logo_outline[4], "f")
                    renderer.texture(cat_outline_png, screen_size[1] / 2 + text_x / 2 - 1, screen_size[2] / 2 + 2 - 1,
                        25 + 2, 25 + 2, logo_outline[1],
                        logo_outline[2],
                        logo_outline[3],
                        logo_outline[4], "f")
                    local barcolor = { ui.get(bar_color) }

                    if modifier then
                        barcolor[1] = 255
                        barcolor[2] = 0
                        barcolor[3] = 0
                    end

                    glow_color(screen_size[1] / 2 - text_x / 2, screen_size[2] / 2 + 32,
                        (velocity() / 250) * 45 > 45 and 45 or (velocity() / 250) * 45, 3, barcolor[1], barcolor[2],
                        barcolor[3], 255)
                    local statuscolor = { ui.get(status_color) }
                    render_w_text(
                        (screen_size[1] / 2 - text_x / 2) + 47, screen_size[2] / 2 + 30,
                        statuscolor[1],
                        statuscolor[2],
                        statuscolor[3],
                        statuscolor[4],
                        "-",
                        0,
                        string.upper(ANTIAIM_MOTION)                 
                    )
                end
            )
            local panle_height = 100
             
            client.set_event_callback(
                "paint",
                function()
                    if not table_contains(ui.get(_u.visual.list), 'Debug Info') then
                        return
                    end

                    local x,y = debug_panle:get()
                    local r, g, b, a = ui.get(main_color1)
                    local r2, g2, b2, a2 = ui.get(main_color2)
                    --render_glow_rectangle(500,500,100,50,0,0,0,55,5,10,10)
                    rounded_gradient_rectangle(x,y,150, panle_height,5,{r, g, b, a},{r, g, b, a},{r2, g2, b2, a2},{r2, g2, b2, a2},{0,0,0,155},255,0,1,5)
                    debug_panle:drag(150, panle_height)
                    render_w_text(
                        x+5,y+2,
                       255,
                        255,
                        255,
                        255,
                        "b",
                        150,
                        "Debug Info \n" ..tostring(status.username) ..
                        " - Build: " .. status.build 
                    )
                    render_w_text(
                        x+5,y+2+25,
                       255,
                        255,
                        255,
                        255,
                        "b",
                        150,
                        "Anti-Aim - Debuger"  
                    )
                    
                    local barcolor = { ui.get(bar_color) }
                    glow_color(x+5,y+2+25+15,
                        125*(math.abs(antiaim_funcs.get_desync())/60) , 3, barcolor[1], barcolor[2],
                        barcolor[3], 255)
                        render_w_text(
                            x+5,y+2+45+2,
                            255,
                            255,
                            255,
                            255,
                            "b",
                            150,
                            "Threat Target - " ..   entity.get_player_name(client.current_threat())
                        )
                        render_w_text(
                            x+5,y+2+45+10+3,
                            255,
                            255,
                            255,
                            255,
                            "b",
                            150,
                            "Motion Type - " .. ANTIAIM_MOTION  
                        )
                        panle_height = 80
                        if ui.get(doubletap[1]) and ui.get(doubletap[2]) then
                            panle_height = 100
                        local temp_string = "OFF"
                        if ((antiaim_funcs.get_tickbase_shifting() / (14 - ui.get(doubletap_limit))) > 0.9) then
                            temp_string = "Ready"
                        end
                        glow_color(x+5,y+2+45+10+3+17,
                        125*((antiaim_funcs.get_tickbase_shifting() / (14 - ui.get(doubletap_limit)))), 3, barcolor[1], barcolor[2],
                        barcolor[3], 255)
                        render_w_text(
                            x+5,y+2+45+10+3+22,
                            255,
                            255,
                            255,
                            255,
                            "b",
                            150,
                            "Double tap - " ..  temp_string
                        )
                    end
                    
                    
                end)


            client.set_event_callback("player_hurt", function(e)
                if table_contains(ui.get(_u.visual.notifications), 'Log ragebot') then
                    local attacker_id = client.userid_to_entindex(e.attacker)
                    if attacker_id == nil then
                        return
                    end

                    if attacker_id ~= entity.get_local_player() then
                        return
                    end

                    local hitgroup_names = { "Body", "Head", "Chest", "Stomach", "Left arm", "Right arm", "Left leg",
                        "Right leg", "Neck", "?" }
                    local group = hitgroup_names[e.hitgroup + 1] or "?"
                    local target_id = client.userid_to_entindex(e.userid)
                    local target_name = entity.get_player_name(target_id)
                    local enemy_health = entity.get_prop(target_id, "m_iHealth")
                    local rem_health = enemy_health - e.dmg_health
                    if rem_health <= 0 then
                        rem_health = 0
                    end

                    local message = "Hit " ..
                        string.lower(target_name) ..
                        ", Group: " .. group .. "  Damage: " .. e.dmg_health .. "  Health remain: " .. rem_health
                    if rem_health <= 0 then
                        message = message .. "  death "
                    end
                    g_handle_notify.paint_2(message, 'hit')
                    g_handle_notify.paint(message)
                end
            end)

            client.set_event_callback("aim_miss", function(e)
                if table_contains(ui.get(_u.visual.notifications), 'Log ragebot') then
                    if e == nil then return end
                    local hitgroup_names = { "Body", "Head", "Chest", "Stomach", "Left arm", "Right arm", "Left leg",
                        "Right leg", "Neck", "?" }
                    local group = hitgroup_names[e.hitgroup + 1] or "?"
                    local target_name = entity.get_player_name(e.target)
                    local reason
                    if e.reason == "?" then
                        reason = "resolver"
                    else
                        reason = e.reason .. " "
                    end

                    local message = "Missed " .. string.lower(target_name) ..
                        ", Group: " .. group .. ", Reason: " .. reason .. " "

                    g_handle_notify.paint(message)
                    g_handle_notify.paint_2(message, 'miss')
                end
            end)
            local last_hit = 0
            client.set_event_callback("bullet_impact", function(e)
                local me = entity.get_local_player()

                if not entity.is_alive(me) then return end

                local shooter_id = e.userid
                local shooter = client.userid_to_entindex(shooter_id)

                if not entity.is_enemy(shooter) or entity.is_dormant(shooter) then return end

                local lx, ly, lz = entity.hitbox_position(me, "head_0")

                local ox, oy, oz = entity.get_prop(me, "m_vecOrigin")
                local ex, ey, ez = entity.get_prop(shooter, "m_vecOrigin")

                local dist = ((e.y - ey) * lx - (e.x - ex) * ly + e.x * ey - e.y * ex) /
                    math.sqrt((e.y - ey) ^ 2 + (e.x - ex) ^ 2)

                if math.abs(dist) <= 35 and globals.curtime() - last_hit > 0.015 and table_contains(ui.get(_u.visual.notifications), 'Log antiaim') then
                    g_handle_notify.paint('Received data from miss angle')
                    g_handle_notify.paint_2('Received data from miss angle', 'miss')

                    last_hit = globals.curtime()
                end
            end)
        end
        visual_main()

        local export_config = function()
            local cache_items = { ver = 0, uis = { antiaim = {} } }
            cache_items.uis.visuals = nil
            cache_items.uis.misc = nil

            for i, v in ipairs(tabs.antiaim) do
                cache_items.uis.antiaim[i] = ui.get(v)
                cache_items.ver = cache_items.ver + 1
            end


            clipboard.set(base64.enc(json.stringify(cache_items)))
        end

        local load_config = function()
            local tbl = base64.dec(clipboard.get())
            tbl = json.parse(tbl)
            local p = 1
            if #tabs.antiaim == tbl.ver then
                for i, v in ipairs(tabs.antiaim) do
                    pcall(function()
                        ui.set(tabs.antiaim[i], tbl.uis.antiaim[i])
                    end)
                end
            else
                log("error when loading config : verison error")
            end
        end

        local load_config = ui.new_button("AA", "Anti-aimbot angles", "Load config from clipboard", load_config)
        table.insert(tabs.misc, load_config)
        local export_config = ui.new_button("AA", "Anti-aimbot angles", "Export config from clipboard", export_config)
        table.insert(tabs.misc, export_config)
        local function misc_main()
            local local_animation = ui.new_multiselect(
                "AA",
                "Anti-aimbot angles",
                "Local Animation",
                "Pitch 0 on Land",
                "Static Legs",
                "Sky Walk"
            )
            local ____tabs_misc_19 = tabs.misc
            ____tabs_misc_19[#____tabs_misc_19 + 1] = local_animation
            local vars = { ground_ticks = 0, end_time = 0 }
            client.set_event_callback(
                "pre_render",
                function()
                    local local_player = entity.get_local_player()
                    if local_player == nil then
                        return
                    end
                    if not entity.is_alive(local_player) then
                        return
                    end
                    local static_leg = contains(
                        ui.get(local_animation),
                        "Static Legs"
                    )
                    local pitch = contains(
                        ui.get(local_animation),
                        "Pitch 0 on Land"
                    )
                    local space_walk = contains(
                        ui.get(local_animation),
                        "Sky Walk"
                    )

                    if static_leg then
                        entity.set_prop(local_player, "m_flPoseParameter", 1, 6)
                    end
                    if pitch then
                        local on_ground = bit.band(
                            entity.get_prop(local_player, "m_fFlags"),
                            1
                        )
                        if on_ground == 1 then
                            vars.ground_ticks = vars.ground_ticks + 1
                        else
                            vars.ground_ticks = 0
                            vars.end_time = globals.curtime() + 1
                        end

                        if vars.ground_ticks > 3 and vars.end_time > globals.curtime() then
                            entity.set_prop(local_player, "m_flPoseParameter", 0.5, 12)
                        end
                    end

                    if space_walk then
                        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 9)
                        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1,
                            globals.tickcount() % 4 > 1 and 5 / 10 or
                            1)
                        local gz = c_entity.new(entity.get_local_player())
                        if not gz then return end
                        local gA = gz:get_anim_overlay(12)
                        local gB = gz:get_anim_overlay(6)
                        if not gA then return end
                        local gC = entity.get_prop(entity.get_local_player(), "m_vecVelocity[0]")
                        if math.abs(gC) >= 3 then gA.weight = 1 end
                        gB.weight = 1
                    end
                end
            )
        end
        misc_main()
        local function update_tabs()
            __TS__ArrayForEach(
                TABS,
                function(____, e)
                    local element = e
                    if element == ui.get(tab_controller) then
                        if isValidKey(element, tabs) then
                            local target_tab = tabs[element]
                            __TS__ArrayForEach(
                                target_tab,
                                function(____, element)
                                    ui.set_visible(element, true)
                                end
                            )
                            local func = tab_callbacks[element]
                            func()
                        end
                    else
                        if isValidKey(element, tabs) then
                            local target_tab = tabs[element]
                            __TS__ArrayForEach(
                                target_tab,
                                function(____, element)
                                    ui.set_visible(element, false)
                                end
                            )
                        end
                    end
                end
            )
        end
        ui.set_callback(tab_controller, update_tabs)
        update_tabs()
        client.delay_call(0.2, update_tabs)


        g_handle_notify.paint("Welcome! " ..
            tostring(status.username) .. " Build: " .. status.build .. " Last update time: " .. status.last_updatetime)
        g_handle_notify.paint_2(
            "Welcome! " .. tostring(status.username) ..
            " Build: " .. status.build .. " Last update time: " .. status.last_updatetime, 'hit')

        client.set_event_callback("paint_ui", function()
            g_handle_notify.render()
        end)
        return ____exports
    end,
}
return require("main")
