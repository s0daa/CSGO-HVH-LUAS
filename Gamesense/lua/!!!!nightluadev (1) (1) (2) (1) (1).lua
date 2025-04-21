local ffi = require 'ffi'
local pui = require 'gamesense/pui';
local base64 = require 'gamesense/base64';
local clipboard = require 'gamesense/clipboard';
local vector = require 'vector';
local ent = require "gamesense/entity"
local http = require("gamesense/http")
local c_entity = require("gamesense/entity")
local inspect = require 'gamesense/inspect'
local images = require 'gamesense/images'
local gif_decoder = require 'gamesense/gif_decoder'
local easing1 = require("gamesense/easing")
local surface = require('gamesense/surface')
local color = require("gamesense/color")
local pui = require("gamesense/pui")
local websocket = require("gamesense/websockets")
local vector = require("vector")
local json = require("json")
local ffi = require('ffi')
local pui = require('gamesense/pui')
local base64 = require('gamesense/base64')
local clipboard = require('gamesense/clipboard')
local c_entity = require('gamesense/entity')
local http = require('gamesense/http')
local vector = require "vector"
local steamworks = require('gamesense/steamworks')
local surface = require 'gamesense/surface'

local inspect = require('gamesense/inspect'); _G.try_require = function(
    module, message)
    local success, result = pcall(require, module)

    if success then
        return result
    else
        return error(message)
    end
end
local charMap = {
    ['a'] = '@',
    ['b'] = '8',
    ['c'] = 'C',
    ['d'] = 'D',
    ['e'] = '3',
    ['f'] = '#',
    ['g'] = '6',
    ['h'] = '#',
    ['i'] = '!',
    ['j'] = '_|',
    ['k'] = '|<',
    ['l'] = '1',
    ['m'] = 'M',
    ['n'] = 'N',
    ['o'] = '0',
    ['p'] = '|*',
    ['q'] = '(_,)',
    ['r'] = '7',
    ['s'] = '$',
    ['t'] = 'T',
    ['u'] = 'U',
    ['v'] = 'V',
    ['w'] = 'W',
    ['x'] = '><',
    ['y'] = '`/',
    ['z'] = '2',
    [' '] = ' ',
    ['.'] = '.'
}
local function get_text_array(text)
    local arr = {}
    local size = #text

    for i = 1, size do
        arr[i] = text:sub(i, i)
    end

    return arr, size
end

local function strange(text, time)
    local arr, size = get_text_array(text)
    local index = math.floor(time % size) + 1
    arr[index] = string.format('\v%s\r', charMap[arr[index]])
    return table.concat(arr, nil, 1, size)
end
local anim = {}
local fart = {}
local client_userid_to_entindex
fart.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

local function oppositefix(c)
    local desync_amount = antiaim_funcs.get_desync(2)
    if math.abs(desync_amount) < 15 or c.chokedcommands ~= 0 then
        return
    end
end
local yaw_am, yaw_val = ui.reference("AA", "Anti-aimbot angles", "Yaw")
jyaw, jyaw_val = ui.reference("AA", "Anti-aimbot angles", "Yaw Jitter")
byaw, byaw_val = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
fs_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
local function set_og_menu(state)
    ui.set_visible(ref.pitch, state)
    ui.set_visible(ref.roll, state)
    ui.set_visible(ref.yawbase, state)
    ui.set_visible(ref.yaw[1], state)
    ui.set_visible(ref.yaw[2], state)
    ui.set_visible(ref.yawjitter[1], state)
    ui.set_visible(ref.yawjitter[2], state)
    ui.set_visible(ref.bodyyaw[1], state)
    ui.set_visible(ref.bodyyaw[2], state)
    ui.set_visible(ref.freestand[1], state)
    ui.set_visible(ref.freestand[2], state)
    ui.set_visible(ref.fsbodyyaw, state)
    ui.set_visible(ref.edgeyaw, state)
end

_G.dash_push =
    (function()
        _G.dash_notify_cache = {}
        local a = { callback_registered = false, maximum_count = 4 }

        function a:register_callback()
            if self.callback_registered then
                return
            end
            client.set_event_callback(
                "paint_ui",
                function()
                    local c = { client.screen_size() }
                    local d = { 0, 0, 0 }
                    local e = 1
                    local f = _G.dash_notify_cache
                    for g = #f, 1, -1 do
                        _G.dash_notify_cache[g].time = _G.dash_notify_cache[g].time - globals.frametime()
                        local h, i = 255, 0
                        local i2 = 0
                        local lerpy = 150
                        local lerp_circ = 0.5
                        local j = f[g]
                        if j.time < 0 then
                            table.remove(_G.dash_notify_cache, g)
                        else
                            local k = j.def_time - j.time
                            local k = k > 1 and 1 or k
                            if j.time < 1 or k < 1 then
                                i = (k < 1 and k or j.time) / 1
                                i2 = (k < 1 and k or j.time) / 1
                                h = i * 255
                                lerpy = i * 150
                                lerp_circ = i * 0.5
                                if i < 0.2 then
                                    e = e + 8 * (1.0 - i / 0.2)
                                end
                            end

                            local m = { math.floor(renderer.measure_text(nil, "" .. j.draw) * 1.03) }
                            local n = { renderer.measure_text(nil, " ") }
                            local o = { renderer.measure_text(nil, j.draw) }
                            local p = { c[1] / 2 - m[1] / 2 + 3, c[2] - c[2] / 100 * 13.4 + e }
                            local x, y = client.screen_size()

                            renderer.rectangle(p[1] - 1, p[2] - 20, m[1] + 2, 22, 18, 7, 8, h > 255 and 255 or h)
                            renderer.circle(p[1] - 1, p[2] - 8, 18, 7, 8, h > 255 and 255 or h, 12, 180, 0.5)
                            renderer.circle(p[1] + m[1] + 1, p[2] - 8, 18, 7, 8, h > 255 and 255 or h, 12, 0, 0.5)
                            renderer.circle_outline(
                                p[1] - 1,
                                p[2] - 9,
                                c1,
                                c2,
                                c3,
                                h > 200 and 200 or h,
                                13,
                                90,
                                lerp_circ,
                                2
                            )
                            renderer.circle_outline(
                                p[1] + m[1] + 1,
                                p[2] - 9,
                                c1,
                                c2,
                                c3,
                                h > 200 and 200 or h,
                                13,
                                -90,
                                lerp_circ,
                                2
                            )
                            renderer.line(
                                p[1] + m[1] + 1,
                                p[2] + 3,
                                p[1] + 149 - lerpy,
                                p[2] + 3,
                                c1,
                                c2,
                                c3,
                                h > 255 and 255 or h
                            )
                            renderer.line(
                                p[1] + m[1] + 1,
                                p[2] + 3,
                                p[1] + 149 - lerpy,
                                p[2] + 3,
                                c1,
                                c2,
                                c3,
                                h > 255 and 255 or h
                            )
                            renderer.line(
                                p[1] - 1,
                                p[2] - 21,
                                p[1] - 149 + m[1] + lerpy,
                                p[2] - 21,
                                c1,
                                c2,
                                c3,
                                h > 255 and 255 or h
                            )
                            renderer.line(
                                p[1] - 1,
                                p[2] - 21,
                                p[1] - 149 + m[1] + lerpy,
                                p[2] - 21,
                                c1,
                                c2,
                                c3,
                                h > 255 and 255 or h
                            )
                            renderer.text(p[1] + m[1] / 2 - o[1] / 2, p[2] - 9.5, c1, c2, c3, h, "cb", nil, "")
                            renderer.text(p[1] + m[1] / 2 + n[1] / 2, p[2] - 9.5, 255, 255, 255, h, "cb", nil, j.draw)
                            e = e - 33
                        end
                    end
                    self.callback_registered = true
                end
            )
        end

        function a:paint(q, r)
            local s = tonumber(q) + 1
            for g = self.maximum_count, 2, -1 do
                _G.dash_notify_cache[g] = _G.dash_notify_cache[g - 1]
            end
            _G.dash_notify_cache[1] = { time = s, def_time = s, draw = r }
            self:register_callback()
        end

        return a
    end)()
dash_push:paint(5, "Welcome to night.project :3")




function RGBtoHEX(redArg, greenArg, blueArg)
    return string.format("%.2x%.2x%.2xFF", redArg, greenArg, blueArg)
end

print("Welcome to night.project!")

function rgba(r, g, b, a, ...) return ("\a%x%x%x%x"):format(r, g, b, a) .. ... end

local w, h = client.screen_size()
local alpha = 69
local toggled = false
client.set_event_callback("paint_ui", function()
    local png = images.load_png(readfile('night.png'))
    if alpha > 0 and toggled then
        if alpha == 169 then
        end
        alpha = alpha - 0.9
    else
        if not toggled then
            alpha = alpha + 1
            if alpha == 254 then
                toggled = true
            end
            alpha = alpha + 1
        end
    end
    if alpha > 1 then
        renderer.gradient(0, 0, w, h, 0, 0, 0, alpha, 0, 0, 0, alpha, true)
    end
end)

local steamname = panorama.open("CSGOHud").MyPersonaAPI.GetName()
local js = panorama.open()
local MyPersonaAPI, LobbyAPI, PartyListAPI, SteamOverlayAPI =
    js.MyPersonaAPI,
    js.LobbyAPI,
    js.PartyListAPI,
    js.SteamOverlayAPI


calculateGradien = function(color1, color2, text, speed)
    local output = ''

    local curtime = globals.curtime()

    for idx = 0, #text - 1 do
        local x = idx * 10
        local wave = math.cos(8 * speed * curtime + x / 30)

        -- Интерполяция цвета
        local r = lerp(color1[1], color2[1], clamp(wave, 0, 1))
        local g = lerp(color1[2], color2[2], clamp(wave, 0, 1))
        local b = lerp(color1[3], color2[3], clamp(wave, 0, 1))
        local a = color1[4]

        -- Формируем цвет в HEX формате
        local color = ('\a%02x%02x%02x%02x'):format(r, g, b, a)

        output = output .. color .. text:sub(idx + 1, idx + 1) -- Индекс + 1 для Lua
    end

    return output
end

local function mcopy(o)
    if type(o) ~= "table" then return o end
    local res = {}
    for k, v in pairs(o) do res[mcopy(k)] = mcopy(v) end
    return res
end

local table, math, string = mcopy(table), mcopy(math), mcopy(string)
local ui, client = mcopy(ui), mcopy(client)

table.find = function(t, j)
    for k, v in pairs(t) do if v == j then return k end end
    return false
end
table.ifind = function(t, j) for i = 1, table.maxn(t) do if t[i] == j then return i end end end
table.qfind = function(t, j) for i = 1, #t do if t[i] == j then return i end end end
table.ihas = function(t, ...)
    local arg = { ... }
    for i = 1, table.maxn(t) do for j = 1, #arg do if t[i] == arg[j] then return true end end end
    return false
end

table.minn = function(t)
    local s = 0
    for i = 1, #t do
        if t[i] == nil then break end
        s = s + 1
    end
    return s
end
table.filter = function(t)
    local res = {}
    for i = 1, table.maxn(t) do if t[i] ~= nil then res[#res + 1] = t[i] end end
    return res
end
table.append = function(t, ...) for i, v in ipairs { ... } do table.insert(t, v) end end
table.copy = mcopy

math.max_lerp_low_fps = (1 / 45) * 100
math.clamp = function(x, a, b) if a > x then return a elseif b < x then return b else return x end end
math.vector_lerp = function(start, end_pos, time)
    local frametime = globals.frametime() * 100; time = time * math.min(frametime, math.max_lerp_low_fps); return start
        :lerp(end_pos, time)
end
math.lerp = function(start, end_pos, time)
    if start == end_pos then return end_pos end
    local frametime = globals.frametime() * 170; time = time * frametime; local val = start + (end_pos - start) * time; if (math.abs(val - end_pos) < 0.01) then
        return
            end_pos
    end
    return val
end
math.normalize_yaw = function(yaw)
    yaw = (yaw % 360 + 360) % 360
    return yaw > 180 and yaw - 360 or yaw
end
local try_require = function(module, msg)
    local success, result = pcall(require, module)
    if success then return result else return error(msg) end
end
local ternary = function(c, a, b) if c then return a else return b end end
local contend = function(func, callback, ...)
    local t = { pcall(func, ...) }
    if not t[1] then return type(callback) == "function" and callback(t[2]) or error(t[2], callback or 2) end
    return unpack(t, 2)
end

--dka
local x, y = client.screen_size()
--enddka

--nightpngloader
--endloader

if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function(...)
        return ...;
    end
end

local native_GetTimescale = vtable_bind('engine.dll', 'VEngineClient014', 91, 'float(__thiscall*)(void*)')

function solve(easing_fn, prev, target, clock, duration)
    local result = easing_fn(clock, prev, target - prev, duration)
    if type(result) == 'number' then
        if math.abs(target - result) <= 0.01 then return target end
        local fmod = result % 1
        if fmod < 0.001 then return math.floor(result) end
        if fmod > 0.999 then return math.ceil(result) end
    end
    return result
end

function create_animation(default)
    default = type(default) == 'boolean' and (default and 1 or 0) or (default or 0)

    local clock = 0
    local value = default
    local from = value
    local to = value
    local easing = function(t, b, c, d) return c * t / d + b end

    local function update(duration, target)
        if target == nil then return value end

        target = type(target) == 'boolean' and (target and 1 or 0) or target
        if type(target) ~= 'number' then return value end

        if target ~= to then
            clock = 0
            from = value
            to = target
        end

        local frame_time = globals.frametime() / native_GetTimescale()
        duration = duration or 0.07

        if frame_time <= 0 or clock >= duration then
            clock = 0
            from = target
            to = target
            value = target
            return target
        end

        clock = math.min(clock + frame_time, duration)
        value = solve(easing, from, to, clock, duration)
        return value
    end

    return update
end

local elements = {
    button       = { type = "function", arg = 2, unsavable = true },
    checkbox     = { type = "boolean", arg = 1, init = false },
    color_picker = { type = "table", arg = 5 },
    combobox     = { type = "string", arg = 2, variable = true },
    hotkey       = { type = "table", arg = 3, enum = { [0] = "Always on", "On hotkey", "Toggle", "Off hotkey" } },
    label        = { type = "string", arg = 1, unsavable = true },
    listbox      = { type = "number", arg = 2, init = 0, variable = true },
    multiselect  = { type = "table", arg = 2, init = {}, variable = true },
    slider       = { type = "number", arg = 8 },
    textbox      = { type = "string", arg = 1, init = "" },
    string       = { type = "string", arg = 2, init = "" },
    unknown      = { type = "string", arg = 2, init = "" } -- new_string type
}

local weapons = { "Global", "G3SG1 / SCAR-20", "SSG 08", "AWP", "R8 Revolver", "Desert Eagle", "Pistol", "Zeus", "Rifle",
    "Shotgun", "SMG", "Machine gun" }

function lerp(a, b, t) return a + (b - a) * t end

function clamp(x, minval, maxval) return x < minval and minval or (x > maxval and maxval or x) end

function calculateGradien(color1, color2, text, speed)
    local output = ''

    local curtime = globals.curtime()

    for idx = 0, #text - 1 do
        local x = idx * 10
        local wave = math.cos(8 * speed * curtime + x / 30)

        local r = lerp(color1[1], color2[1], clamp(wave, 0, 1))
        local g = lerp(color1[2], color2[2], clamp(wave, 0, 1))
        local b = lerp(color1[3], color2[3], clamp(wave, 0, 1))
        local a = color1[4]

        local color = ('\a%02x%02x%02x%02x'):format(r, g, b, a)

        output = output .. color .. text:sub(idx + 1, idx + 1)
    end

    return output
end

function mcopy(o)
    if type(o) ~= "table" then return o end
    local res = {}
    for k, v in pairs(o) do res[mcopy(k)] = mcopy(v) end
    return res
end

local table, math, string = mcopy(table), mcopy(math), mcopy(string)
local ui, client = mcopy(ui), mcopy(client)

function table.find(t, j)
    for k, v in pairs(t) do if v == j then return k end end
    return false
end

function table.ifind(t, j) for i = 1, table.maxn(t) do if t[i] == j then return i end end end

function table.qfind(t, j) for i = 1, #t do if t[i] == j then return i end end end

function table.ihas(t, ...)
    local arg = { ... }
    for i = 1, table.maxn(t) do for j = 1, #arg do if t[i] == arg[j] then return true end end end
    return false
end

function table.minn(t)
    local s = 0
    for i = 1, #t do
        if t[i] == nil then break end
        s = s + 1
    end
    return s
end

function table.filter(t)
    local res = {}
    for i = 1, table.maxn(t) do if t[i] ~= nil then res[#res + 1] = t[i] end end
    return res
end

function table.append(t, ...) for i, v in ipairs { ... } do table.insert(t, v) end end

table.copy = mcopy

math.max_lerp_low_fps = (1 / 45) * 100
function rgba_to_hex(b, c, d, e) return string.format("%02x%02x%02x%02x", b, c, d, e) end

function math.clamp(x, a, b) if a > x then return a elseif b < x then return b else return x end end

function math.vector_lerp(start, end_pos, time)
    local frametime = globals.frametime() * 100; time = time * math.min(frametime, math.max_lerp_low_fps); return start
        :lerp(end_pos, time)
end

function math.lerp1(start, end_pos, time)
    if start == end_pos then return end_pos end
    local frametime = globals.frametime() * 170; time = time * frametime; local val = start + (end_pos - start) * time; if (math.abs(val - end_pos) < 0.01) then
        return
            end_pos
    end
    return val
end

function math.normalize_yaw(yaw)
    yaw = (yaw % 360 + 360) % 360
    return yaw > 180 and yaw - 360 or yaw
end

function ternary(c, a, b) if c then return a else return b end end

function contend(func, callback, ...)
    local t = { pcall(func, ...) }
    if not t[1] then return type(callback) == "function" and callback(t[2]) or error(t[2], callback or 2) end
    return unpack(t, 2)
end

math.max_lerp_low_fps = (1 / 45) * 100
function math.lerp2(start, end_pos, time)
    if start == end_pos then return end_pos end
    local frametime = globals.frametime() * 170
    time = time * math.min(frametime, math.max_lerp_low_fps)
    local val = start + (end_pos - start) * globals.frametime() * time
    return math.abs(val - end_pos) < 0.01 and end_pos or val
end

local motion = { base_speed = 0.095, _list = {} }
function motion.new(name, new_value, speed, init)
    speed = speed or motion.base_speed
    motion._list[name] = motion._list[name] or (init or 0)
    motion._list[name] = math.lerp2(motion._list[name], new_value, speed)
    return motion._list[name]
end

local config, package, aa_config, aa_package
local dirs = {
    execute = function(t, path, func)
        local p, k
        for _, s in ipairs(path) do
            k, p, t = s, t, t[s]
            if t == nil then return end
        end
        if p[k] then func(p[k]) end
    end,
    replace = function(t, path, value)
        local p, k
        for _, s in ipairs(path) do
            k, p, t = s, t, t[s]
            if t == nil then return end
        end
        p[k] = value
    end,
    find = function(t, path)
        local p, k
        for _, s in ipairs(path) do
            k, p, t = s, t, t[s]
            if t == nil then return end
        end
        return p[k]
    end,
}

dirs.pave = function(t, place, path)
    local p = t
    for i, v in ipairs(path) do
        if type(p[v]) == "table" then
            p = p[v]
        else
            p[v] = (i < #path) and {} or place
            p = p[v]
        end
    end
    return t
end

dirs.extract = function(t, path)
    if not path or #path == 0 then return t end
    local j = dirs.find(t, path)
    return dirs.pave({}, j, path)
end

local ui_handler, ui_handler_mt, methods_mt = {}, {}, {
    element = {}, group = {}
}

local registry, ragebot, players = {}, {}, {}
do
    client.set_event_callback("shutdown", function()
        for k, v in next, registry do
            if v.__ref and not v.__rage then
                if v.overridden then ui.set(k, v.original) end
                ui.set_enabled(k, true)
                ui.set_visible(k, not v.__hidden)
            end
        end
    end)
    client.set_event_callback("pre_config_save", function()
        for k, v in next, registry do
            if v.__ref and not v.__rage and v.overridden then
                v.ovr_restore = { ui.get(k) }; ui.set(k, v.original)
            end
        end
        ragebot.cycle(function(active)
            for k, v in pairs(ragebot.context[active]) do
                if registry[k].overridden then
                    ragebot.cache[active][k] = ui.get(k); ui.set(k, v)
                end
            end
        end, true)
    end)
    client.set_event_callback("post_config_save", function()
        for k, v in next, registry do
            if v.__ref and not v.__rage and v.overridden then
                ui.set(k, unpack(v.ovr_restore)); v.ovr_restore = nil
            end
        end
        ragebot.cycle(function(active)
            for k, v in pairs(ragebot.context[active]) do
                if registry[k].overridden then
                    ui.set(k, ragebot.cache[active][k]); ragebot.cache[active][k] = nil
                end
            end
        end, true)
    end)
end

local elemence = {}
do
    local callbacks = function(this, isref)
        if this.name == "Weapon type" and string.lower(registry[this.ref].tab) == "rage" then return ui.get(this.ref) end

        ui.set_callback(this.ref, function(self)
            if registry[self].__rage and ragebot.silent then return end
            for i = 0, #registry[self].callbacks, 1 do
                if type(registry[self].callbacks[i]) == "function" then registry[self].callbacks[i](this) end
            end
        end)

        if this.type == "button" then
            return
        elseif this.type == "color_picker" or this.type == "hotkey" then
            registry[this.ref].callbacks[0] = function(self) this.value = { ui.get(self.ref) } end
            return { ui.get(this.ref) }
        else
            registry[this.ref].callbacks[0] = function(self) this.value = ui.get(self.ref) end
            if this.type == "multiselect" then
                this.value = ui.get(this.ref)
                registry[this.ref].callbacks[1] = function(self)
                    registry[this.ref].options = {}
                    for i = 1, #self.value do registry[this.ref].options[self.value[i]] = true end
                end
                registry[this.ref].callbacks[1](this)
            end
            return ui.get(this.ref)
        end
    end

    elemence.new = function(ref, add)
        local self = {}; add = add or {}

        self.ref = ref
        self.name, self.type = ui.name(ref), ui.type(ref)

        --
        registry[ref] = registry[ref] or {
            type = self.type,
            ref = ref,
            tab = add.__tab,
            container = add.__container,
            __ref = add.__ref,
            __hidden = add.__hidden,
            __init = add.__init,
            __list = add.__list,
            __rage = add.__rage,
            __plist = add.__plist and not (self.type == "label" or self.type == "button" or self.type == "hotkey"),

            overridden = false,
            original = self.value,
            donotsave = add.__plist or false,
            callbacks = { [0] = add.__callback },
            events = {},
            depend = { [0] = { ref }, {}, {} },
        }

        registry[ref].self = setmetatable(self, methods_mt.element)
        self.value = callbacks(self, add.__ref)

        if add.__rage then
            methods_mt.element.set_callback(self, ragebot.memorize)
        end
        if registry[ref].__plist then
            players.elements[#players.elements + 1] = self
            methods_mt.element.set_callback(self, players.slot_update, true)
        end

        return self
    end

    elemence.group = function(...)
        return setmetatable({ ... }, methods_mt.group)
    end

    elemence.string = function(name, default)
        local this = {}

        this.ref = ui.new_string(name, default or "")
        this.type = "string"
        this[0] = { savable = true }

        return setmetatable(this, methods_mt.element)
    end

    elemence.features = function(self, args)
        do
            local addition
            local v, kind = args[1], type(args[1])

            if not addition and (kind == "table" or kind == "cdata") and not v.r then
                addition = "color"
                local r, g, b, a = v[1] or 255, v[2] or 255, v[3] or 255, v[4] or 255
                self.color = elemence.new(
                    ui.new_color_picker(registry[self.ref].tab, registry[self.ref].container, self.name, r, g, b, a), {
                        __init = { r, g, b, a },
                        __plist = registry[self.ref].__plist
                    })
            elseif not addition and (kind == "table" or kind == "cdata") and v.r then
                addition = "color"
                self.color = elemence.new(
                    ui.new_color_picker(registry[self.ref].tab, registry[self.ref].container, self.name, v.r, v.g, v.b,
                        v.a),
                    {
                        __init = { v.r, v.g, v.b, v.a },
                        __plist = registry[self.ref].__plist
                    })
            elseif not addition and kind == "number" then
                addition = "hotkey"
                self.hotkey = elemence.new(ui.new_hotkey(registry[self.ref].tab, registry[self.ref].container, self.name,
                    true, v, {
                        __init = v
                    }))
            end
            registry[self.ref].depend[0][2] = addition and self[addition].ref
            registry[self.ref].__addon = addition
        end
        do
            registry[self.ref].donotsave = args[2] == false
        end
    end

    elemence.memorize = function(self, path, origin)
        if registry[self.ref].donotsave then return end

        if not elements[self.type].unsavable then
            dirs.pave(origin, self.ref, path)
        end

        if self.color then
            path[#path] = path[#path] .. "_c"
            dirs.pave(origin, self.color.ref, path)
        end
        if self.hotkey then
            path[#path] = path[#path] .. "_h"
            dirs.pave(origin, self.hotkey.ref, path)
        end
    end

    elemence.hidden_refs = {
        "Unlock hidden cVars", "Allow custom game events", "Faster grenade toss",
        "sv_maxunlag", "sv_maxusrcmdprocessticks", "sv_clockcorrection_msecs",
    }

    local cases = {
        combobox = function(v)
            if v[3] == true then
                return v[1].value ~= v[2]
            else
                for i = 2, #v do
                    if v[1].value == v[i] then return true end
                end
            end
            return false
        end,
        listbox = function(v)
            if v[3] == true then
                return v[1].value ~= v[2]
            else
                for i = 2, #v do
                    if v[1].value == v[i] then return true end
                end
            end
            return false
        end,
        multiselect = function(v)
            return table.ihas(v[1].value, unpack(v, 2))
        end,
        slider = function(v)
            return v[2] <= v[1].value and v[1].value <= (v[3] or v[2])
        end,
    }

    local depend = function(v)
        local condition = false

        if type(v[2]) == "function" then
            condition = v[2](v[1])
        else
            local f = cases[v[1].type]
            if f then
                condition = f(v)
            else
                condition = v[1].value == v[2]
            end
        end

        return condition and true or false
    end

    elemence.dependant = function(owner, dependant, dis)
        local count = 0

        for i = 1, #owner do
            if depend(owner[i]) then count = count + 1 else break end
        end

        local allow, action = count >= #owner, dis and "set_enabled" or "set_visible"

        for i, v in ipairs(dependant) do ui[action](v, allow) end
    end
end
local utils = {}

utils.time_to_ticks = function(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end

utils.rgb_to_hex = function(color)
    return string.format("%02X%02X%02X%02X", color[1], color[2], color[3], color[4] or 255)
end

utils.animate_text = function(time, string, r, g, b, a, r1, g1, b1, a1)
    local t_out, t_out_iter = {}, 1
    local l = string:len() - 1

    local r_add = (r1 - r)
    local g_add = (g1 - g)
    local b_add = (b1 - b)
    local a_add = (a1 - a)

    for i = 1, #string do
        local iter = (i - 1) / (#string - 1) + time
        t_out[t_out_iter] = "\a" ..
            utils.rgb_to_hex({ r + r_add * math.abs(math.cos(iter)), g + g_add * math.abs(math.cos(iter)), b +
            b_add * math.abs(math.cos(iter)), a + a_add * math.abs(math.cos(iter)) })

        t_out[t_out_iter + 1] = string:sub(i, i)
        t_out_iter = t_out_iter + 2
    end

    return table.concat(t_out)
end

utils.hex_to_rgb = function(hex)
    hex = hex:gsub("^#", "")
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16),
        tonumber(hex:sub(7, 8), 16) or 255
end

utils.gradient_text = function(text, colors, precision)
    local symbols, length = {}, #string.gsub(text, ".[\128-\191]*", "a")
    local s = 1 / (#colors - 1)
    precision = precision or 1

    local i = 0
    for letter in string.gmatch(text, ".[\128-\191]*") do
        i = i + 1

        local weight = i / length
        local cw = weight / s
        local j = math.ceil(cw)
        local w = (cw / j)
        local L, R = colors[j], colors[j + 1]

        local r = L[1] + (R[1] - L[1]) * w
        local g = L[2] + (R[2] - L[2]) * w
        local b = L[3] + (R[3] - L[3]) * w
        local a = L[4] + (R[4] - L[4]) * w

        symbols[#symbols + 1] = ((i - 1) % precision == 0) and ("\a%02x%02x%02x%02x%s"):format(r, g, b, a, letter) or
            letter
    end

    symbols[#symbols + 1] = "\aCDCDCDFF"

    return table.concat(symbols)
end

local gradients = function(col, text)
    local colors = {}; for w in string.gmatch(col, "\b%x+") do
        colors[#colors + 1] = { utils.hex_to_rgb(string.sub(w, 2)) }
    end
    if #colors > 0 then return utils.gradient_text(text, colors, #text > 8 and 2 or 1) end
end

utils.format = function(s)
    if type(s) == "string" then
        s = string.gsub(s, "\f<(.-)>", ui_handler.macros)
        s = string.gsub(s, "[\v\r\t]", { ["\v"] = "\a" .. ui_handler.accent, ["\r"] = "\aCDCDCDFF", ["\t"] = "    " })
        s = string.gsub(s, "([\b%x]-)%[(.-)%]", gradients)
    end
    return s
end

utils.unpack_color = function(...)
    local arg = { ... }
    local kind = type(arg[1])

    if kind == "table" or kind == "cdata" or kind == "userdata" then
        if arg[1].r then
            return { arg[1].r, arg[1].g, arg[1].b, arg[1].a }
        elseif arg[1][1] then
            return { arg[1][1], arg[1][2], arg[1][3], arg[1][4] }
        end
    end

    return arg
end

local dispensers = {
    color_picker = function(args)
        args[1] = string.sub(utils.format(args[1]), 1, 117)

        if type(args[2]) ~= "number" then
            local col = args[2]
            args.n, args.req, args[2] = args.n + 3, args.req + 3, col.r
            table.insert(args, 3, col.g)
            table.insert(args, 4, col.b)
            table.insert(args, 5, col.a)
        end

        for i = args.req + 1, args.n do
            args.misc[i - args.req] = args[i]
        end

        args.data.__init = { args[2] or 255, args[3] or 255, args[4] or 255, args[5] or 255 }
    end,
    listbox = function(args, variable)
        args[1] = string.sub(utils.format(args[1]), 1, 117)
        for i = args.req + 1, args.n do
            args.misc[i - args.req] = args[i]
        end

        args.data.__init, args.data.__list = 0, not variable and args[2] or { unpack(args, 2, args.n) }
    end,
    combobox = function(args, variable)
        args[1] = string.sub(utils.format(args[1]), 1, 117)
        for i = args.req + 1, args.n do
            args.misc[i - args.req] = args[i]
        end

        args.data.__init, args.data.__list = not variable and args[2][1] or args[2],
            not variable and args[2] or { unpack(args, 2, args.n) }
    end,
    multiselect = function(args, variable)
        args[1] = string.sub(utils.format(args[1]), 1, 117)
        for i = args.req + 1, args.n do
            args.misc[i - args.req] = args[i]
        end

        args.data.__init, args.data.__list = {}, not variable and args[2] or { unpack(args, 2, args.n) }
    end,
    slider = function(args)
        args[1] = string.sub(utils.format(args[1]), 1, 117)

        for i = args.req + 1, args.n do
            args.misc[i - args.req] = args[i]
        end

        args.data.__init = args[4] or args[2]
    end,
    button = function(args)
        args[2] = args[2] or function() end
        args[1] = string.sub(utils.format(args[1]), 1, 117)
        args.n, args.data.__callback = 2, args[2]
    end
}

utils.dispense = function(key, raw, ...)
    local args, group, ctx = { ... }, {}, elements[key]

    if type(raw) == "table" then
        group[1], group[2] = raw[1], raw[2]
        group.__plist = raw.__plist
    else
        group[1], group[2] = raw, args[1]
        table.remove(args, 1)
    end

    args.n, args.data = table.maxn(args), {
        __tab = group[1],
        __container = group[2],
        __plist = group.__plist and true or nil
    }

    local variable = (ctx and ctx.variable) and type(args[2]) == "string"
    args.req, args.misc = not variable and ctx.arg or args.n, {}

    if dispensers[key] then
        dispensers[key](args, variable)
    else
        for i = 1, args.n do
            if type(args[i]) == "string" then
                args[i] = string.sub(utils.format(args[i]), 1, 117)
            end

            if i > args.req then args.misc[i - args.req] = args[i] end
        end
        args.data.__init = ctx.init
    end

    return args, group
end

local render = renderer

do
    render.rec = function(x, y, w, h, radius, color)
        radius = math.min(x / 2, y / 2, radius)
        local r, g, b, a = unpack(color)
        renderer.rectangle(x, y + radius, w, h - radius * 2, r, g, b, a)
        renderer.rectangle(x + radius, y, w - radius * 2, radius, r, g, b, a)
        renderer.rectangle(x + radius, y + h - radius, w - radius * 2, radius, r, g, b, a)
        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
        renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
        renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
        renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
    end

    render.rec_outline = function(x, y, w, h, radius, thickness, color)
        radius = math.min(w / 2, h / 2, radius)
        local r, g, b, a = unpack(color)
        if radius == 1 then
            renderer.rectangle(x, y, w, thickness, r, g, b, a)
            renderer.rectangle(x, y + h - thickness, w, thickness, r, g, b, a)
        else
            renderer.rectangle(x + radius, y, w - radius * 2, thickness, r, g, b, a)
            renderer.rectangle(x + radius, y + h - thickness, w - radius * 2, thickness, r, g, b, a)
            renderer.rectangle(x, y + radius, thickness, h - radius * 2, r, g, b, a)
            renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius * 2, r, g, b, a)
            renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
            renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
            renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
            renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
        end
    end

    render.shadow = function(x, y, w, h, width, rounding, accent, accent_inner)
        local thickness = 1
        local Offset = 1
        local r, g, b, a = unpack(accent)
        if accent_inner then
            render.rec(x, y, w, h + 1, rounding, accent_inner)
        end
        for k = 0, width do
            if a * (k / width) ^ (1) > 5 then
                local accent = { r, g, b, a * (k / width) ^ (2) }
                render.rec_outline(x + (k - width - Offset) * thickness, y + (k - width - Offset) * thickness,
                    w - (k - width - Offset) * thickness * 2, h + 1 - (k - width - Offset) * thickness * 2,
                    rounding + thickness * (width - k + Offset), thickness, accent)
            end
        end
    end
end

ui_handler.macros = setmetatable({}, {
    __newindex = function(self, key, value) rawset(self, tostring(key), value) end,
    __index = function(self, key) return rawget(self, tostring(key)) end
})

ui_handler.accent, ui_handler.menu_open = nil, ui.is_menu_open()

do
    local reference = ui.reference("MISC", "Settings", "Menu color")
    ui_handler.accent = utils.rgb_to_hex { ui.get(reference) }
    local previous = ui_handler.accent

    ui.set_callback(reference, function()
        local color = { ui.get(reference) }
        ui_handler.accent = utils.rgb_to_hex(color)

        for idx, ref in next, registry do
            if ref.type == "label" and not ref.__ref then
                local new, count = string.gsub(ref.self.value, previous, ui_handler.accent)
                if count > 0 then
                    ui.set(idx, new)
                    ref.self.value = new
                end
            end
        end
        previous = ui_handler.accent
        client.fire_event("ui_handler::accent_color", color)
    end)
end


ui_handler.group = function(tab, container) return elemence.group(tab, container) end

ui_handler.format = utils.format

ui_handler.reference = function(tab, container, name)
    local found = { contend(ui.reference, 3, tab, container, name) }
    local total, hidden = #found, false

    -- done on purpose, don't blame me
    if string.lower(tab) == "misc" and string.lower(container) == "settings" then
        for i, v in ipairs(elemence.hidden_refs) do
            if string.find(name, "^" .. v) then
                hidden = true
                break
            end
        end
    end

    for i, v in ipairs(found) do
        found[i] = elemence.new(v, {
            __ref = true,
            __hidden = hidden or nil,
            __tab = tab,
            __container = container,
            __rage = container == "Aimbot" or nil,
        })
    end

    if total > 1 then
        local shift = 0
        for i = 1, total > 4 and total or 4, 2 do
            local m, j = i - shift, i + 1 - shift
            if found[j] and (found[j].type == "hotkey" or found[j].type == "color_picker") then
                local addition = found[j].type == "color_picker" and "color" or "hotkey"
                registry[found[m].ref].__addon, found[m][addition] = addition, found[j]

                table.remove(found, j)
                shift = shift + 1
            end
        end
        return unpack(found)
    else
        return found[1]
    end
end

ui_handler.traverse = function(t, f, p)
    p = p or {}

    if type(t) == "table" and t.__name ~= "ui_handler::element" and t[#t] ~= "~" then
        for k, v in next, t do
            local np = table.copy(p); np[#np + 1] = k
            ui_handler.traverse(v, f, np)
        end
    else
        f(t, p)
    end
end

do
    save = function(config, ...)
        local packed = {}

        ui_handler.traverse(dirs.extract(config, { ... }), function(ref, path)
            local value
            local etype = registry[ref].type

            if etype == "color_picker" then
                value = "#" .. utils.rgb_to_hex { ui.get(ref) }
            elseif etype == "hotkey" then
                local _, mode, key = ui.get(ref)
                value = { mode, key or 0 }
            else
                value = ui.get(ref)
            end

            if type(value) == "table" then value[#value + 1] = "~" end
            dirs.pave(packed, value, path)
        end)

        return packed
    end

    load = function(config, package, ...)
        if not package then return end

        local packed = dirs.extract(package, { ... })
        ui_handler.traverse(dirs.extract(config, { ... }), function(ref, path)
            pcall(function()
                local value, proxy = dirs.find(packed, path), registry[ref]
                local vtype, etype = type(value), proxy.type
                local object = elements[etype]

                if vtype == "string" and value:sub(1, 1) == "#" then
                    value, vtype = { utils.hex_to_rgb(value) }, "table"
                elseif vtype == "table" and value[#value] == "~" then
                    value[#value] = nil
                end

                if etype == "hotkey" and value and type(value[1]) == "number" then
                    value[1] = elements.hotkey.enum[value[1]]
                end

                if object and object.type == vtype then
                    if vtype == "table" and etype ~= "multiselect" then
                        ui.set(ref, unpack(value))
                        if etype == "color_picker" then methods_mt.element.invoke(proxy.self) end
                    else
                        ui.set(ref, value)
                    end
                else
                    if proxy.__init then ui.set(ref, proxy.__init) end
                end
            end)
        end)
    end

    --
    local package_mt = {
        __type = "ui_handler::package",
        __metatable = false,
        __call = function(self, raw, ...)
            return (type(raw) == "table" and load or save)(self[0], raw, ...)
        end,
        save = function(self, ...) return save(self[0], ...) end,
        load = function(self, ...) load(self[0], ...) end,
    }
    package_mt.__index = package_mt

    ui_handler.setup = function(t)
        local package = { [0] = {} }
        ui_handler.traverse(t, function(r, p) elemence.memorize(r, p, package[0]) end)
        return setmetatable(package, package_mt)
    end
end

methods_mt.element = {
    __type = "ui_handler::element",
    __name = "ui_handler::element",
    __metatable = false,
    __eq = function(this, that) return this.ref == that.ref end,
    __tostring = function(self) return string.format('ui_handler.%s[%d] "%s"', self.type, self.ref, self.name) end,
    __call = function(self, ...) if #{ ... } > 0 then ui.set(self.ref, ...) else return ui.get(self.ref) end end,

    depend = function(self, ...)
        local arg = { ... }
        local disabler = arg[1] == true

        local depend = registry[self.ref].depend[disabler and 2 or 1]
        local this = registry[self.ref].depend[0]

        for i = (disabler and 2 or 1), table.maxn(arg) do
            local v = arg[i]
            if v then
                if v.__name == "ui_handler::element" then v = { v, true } end
                depend[#depend + 1] = v

                local check = function() elemence.dependant(depend, this, disabler) end
                check()

                registry[v[1].ref].callbacks[#registry[v[1].ref].callbacks + 1] = check
            end
        end

        return self
    end,

    override = function(self, value)
        local is_hk = self.type == "hotkey"
        local ctx, wctx = registry[self.ref], ragebot.context[ragebot.ref.value]

        if value ~= nil then
            if not ctx.overridden then
                if is_hk then self.value = { ui.get(self.ref) } end
                if ctx.__rage then wctx[self.ref] = self.value else ctx.original = self.value end
            end
            ctx.overridden = true
            if is_hk then ui.set(self.ref, value[1], value[2]) else ui.set(self.ref, value) end
            if ctx.__rage then ctx.__ovr_v = value end
        else
            if ctx.overridden then
                local original = ctx.original
                if ctx.__rage then original, ctx.__ovr_v = wctx[self.ref], nil end
                if is_hk then
                    ui.set(self.ref, elements.hotkey.enum[original[2]], original[3] or 0)
                else
                    ui.set(self.ref, original)
                end
                ctx.overridden = false
            end
        end
    end,
    get_original = function(self)
        if registry[self.ref].__rage then
            if registry[self.ref].overridden then
                return ragebot.context[ragebot.ref.value][self.ref]
            else
                return self
                    .value
            end
        else
            if registry[self.ref].overridden then return registry[self.ref].original else return self.value end
        end
    end,

    set = function(self, ...)
        if self.type == "color_picker" then
            ui.set(self.ref, unpack(utils.unpack_color(...)))
            methods_mt.element.invoke(self)
        elseif self.type == "label" then
            local t = utils.format(...)
            ui.set(self.ref, t)
            self.value = t
        else
            ui.set(self.ref, ...)
        end
    end,
    get = function(self, value)
        if value and self.type == "multiselect" then
            return registry[self.ref].options[value] or false
        end
        return ui.get(self.ref)
    end,

    reset = function(self) if registry[self.ref].__init then ui.set(self.ref, registry[self.ref].__init) end end,

    update = function(self, t)
        ui.update(self.ref, t)
        registry[self.ref].__list = t

        local cap = #t - 1
        --if ui.get(self.ref) > cap then ui.set(self.ref, cap) end
    end,

    get_list = function(self) return registry[self.ref].__list end,

    get_color = function(self)
        if registry[self.ref].__addon then return ui.get(self.color.ref) end
    end,
    set_color = function(self, ...)
        if registry[self.ref].__addon then methods_mt.element.set(self.color, ...) end
    end,
    get_hotkey = function(self)
        if registry[self.ref].__addon then return ui.get(self.hotkey.ref) end
    end,
    set_hotkey = function(self, ...)
        if registry[self.ref].__addon then methods_mt.element.set(self.hotkey, ...) end
    end,

    is_reference = function(self) return registry[self.ref].__ref or false end,
    get_type = function(self) return self.type end,
    get_name = function(self) return self.name end,

    set_visible = function(self, visible)
        ui.set_visible(self.ref, visible)
        if registry[self.ref].__addon then ui.set_visible(self[registry[self.ref].__addon].ref, visible) end
    end,
    set_enabled = function(self, enabled)
        ui.set_enabled(self.ref, enabled)
        if registry[self.ref].__addon then ui.set_enabled(self[registry[self.ref].__addon].ref, enabled) end
    end,

    set_callback = function(self, func, once)
        if once == true then func(self) end
        registry[self.ref].callbacks[#registry[self.ref].callbacks + 1] = func
    end,
    unset_callback = function(self, func)
        table.remove(registry[self.ref].callbacks, table.qfind(registry[self.ref].callbacks, func) or 0)
    end,
    invoke = function(self, ...)
        for i = 0, #registry[self.ref].callbacks do registry[self.ref].callbacks[i](self, ...) end
    end,

    set_event = function(self, event, func, condition)
        local slot = registry[self.ref]
        if condition == nil then condition = true end
        local is_cond_fn, latest = type(condition) == "function", nil
        slot.events[func] = function(this)
            local permission
            if is_cond_fn then permission = condition(this) else permission = this.value == condition end

            local action = permission and client.set_event_callback or client.unset_event_callback
            if latest ~= permission then
                action(event, func)
                latest = permission
            end
        end
        slot.events[func](self)
        slot.callbacks[#slot.callbacks + 1] = slot.events[func]
    end,
    unset_event = function(self, event, func)
        client.unset_event_callback(event, func)
        methods_mt.element.unset_callback(self, registry[self.ref].events[func])
        registry[self.ref].events[func] = nil
    end,

    get_location = function(self) return registry[self.ref].tab, registry[self.ref].container end,
}
methods_mt.element.__index = methods_mt.element

methods_mt.group = {
    __name = "ui_handler::group",
    __metatable = false,
    __index = function(self, key) return rawget(methods_mt.group, key) or ui_handler_mt.__index(self, key) end,
    get_location = function(self) return self[1], self[2] end
}

do
    for k, v in next, elements do
        v.fn = function(origin, ...)
            local args, group = utils.dispense(k, origin, ...)
            local this = elemence.new(
                contend(ui["new_" .. k], 3, group[1], group[2], unpack(args, 1, args.n < args.req and args.n or args.req)),
                args.data)

            elemence.features(this, args.misc)
            return this
        end
    end

    ui_handler_mt.__name, ui_handler_mt.__metatable = "ui_handler::basement", false
    ui_handler_mt.__index = function(self, key)
        if not elements[key] then return ui[key] end
        if key == "string" then return elemence.string end

        return elements[key].fn
    end
end

ragebot = {
    ref = ui_handler.reference("RAGE", "Weapon type", "Weapon type"),
    context = {},
    cache = {},
    silent = false,
}
do
    local previous, cycle_action = ragebot.ref.value, nil
    for i, v in ipairs(weapons) do ragebot.context[v], ragebot.cache[v] = {}, {} end

    local neutral = ui.reference("RAGE", "Aimbot", "Enabled")
    ui.set_callback(neutral, function()
        if not ragebot.silent then
            client.delay_call(0, client.fire_event, "ui_handler::adaptive_weapon",
                ragebot.ref.value, previous)
        end
        if cycle_action then cycle_action(ragebot.ref.value) end
    end)

    ragebot.cycle = function(fn, mute)
        cycle_action = mute and fn or nil
        ragebot.silent = mute and true or false

        for i, v in ipairs(weapons) do
            ragebot.ref:override(v)
        end

        ragebot.ref:override()
        cycle_action, ragebot.silent = nil, false
    end

    ui.set_callback(ragebot.ref.ref, function(self)
        ragebot.ref.value = ui.get(self)

        if not ragebot.silent and previous ~= ragebot.ref.value then
            for i = 1, #registry[self].callbacks, 1 do registry[self].callbacks[i](ragebot.ref) end
        end

        previous = ragebot.ref.value
    end)

    ragebot.memorize = function(self)
        local ctx = ragebot.context[ragebot.ref.value]

        if registry[self.ref].overridden then
            if ctx[self.ref] == nil then
                ctx[self.ref] = self.value
                methods_mt.element.override(self, registry[self.ref].__ovr_v)
            end
        else
            if ctx[self.ref] then
                methods_mt.element.set(self, ctx[self.ref])
                ctx[self.ref] = nil
            end
        end
    end
end

players = {
    elements = {}, list = {},
}
do
    ui_handler.plist = elemence.group("PLAYERS", "Adjustments")
    ui_handler.plist.__plist = true

    local selected = 0
    local refs, slot = {
        list = ui_handler.reference("PLAYERS", "Players", "Player list"),
        reset = ui_handler.reference("PLAYERS", "Players", "Reset all"),
        apply = ui_handler.reference("PLAYERS", "Adjustments", "Apply to all"),
    }, {}

    local slot_mt = {
        __type = "ui_handler::player_slot",
        __metatable = false,
        __tostring = function(self)
            return string.format("ui_handler::player_slot[%d] of %s", self.idx,
                methods_mt.element.__tostring(registry[self.ref].self))
        end,
        set = function(self, ...) -- don't mind
            local ctx, value = registry[self.ref], { ... }

            local is_colorpicker = ctx.type == "color_picker"
            if is_colorpicker then
                value = utils.unpack_color(...)
            end

            if self.idx == selected then
                ui.set(self.ref, unpack(value))
                if is_colorpicker then
                    methods_mt.element.invoke(ctx.self)
                end
            else
                self.value = is_colorpicker and value or unpack(value)
            end
        end,
        get = function(self, find)
            if find and registry[self.ref].type == "multiselect" then
                return table.qfind(self.value, find) ~= nil
            end

            if registry[self.ref].type ~= "color_picker" then
                return self.value
            else
                return unpack(self.value)
            end
        end,
    }
    slot_mt.__index = slot_mt

    players.traverse = function(fn) for i, v in ipairs(players.elements) do fn(v) end end

    slot = {
        select = function(idx)
            for i, v in ipairs(players.elements) do
                methods_mt.element.set(v, v[idx].value)
            end
        end,
        add = function(idx)
            for i, v in ipairs(players.elements) do
                local default = ternary(registry[v.ref].__init ~= nil, registry[v.ref].__init, v.value)
                v[idx], players.list[idx] = setmetatable({
                    ref = v.ref, idx = idx, value = default
                }, slot_mt), true
            end
        end,
        remove = function(idx)
            for i, v in ipairs(players.elements) do
                v[idx], players.list[idx] = nil, nil
            end
        end,
    }

    players.slot_update = function(self)
        if self[selected] then
            self[selected].value = self.value
        else
            slot.add(selected)
        end
    end

    local silent = false
    update = function(e)
        selected = ui.get(refs.list.ref)

        local new, old = entity.get_players(), players.list
        local me = entity.get_local_player()

        for idx, v in next, old do
            if entity.get_classname(idx) ~= "CCSPlayer" then
                slot.remove(idx)
            end
        end

        for i, idx in ipairs(new) do
            if idx ~= me and not players.list[idx] and entity.get_classname(idx) == "CCSPlayer" then
                slot.add(idx)
            end
        end

        if not silent and not e.value then
            for i = #new, 1, -1 do
                if new[i] ~= me then
                    ui.set(refs.list.ref, new[i])
                    break
                end
            end
            client.update_player_list()
            silent = true
        else
            silent = false
        end

        slot.select(selected)
        client.fire_event("ui_handler::plist_update", selected)
    end

    do
        local function once()
            update {}
            client.unset_event_callback("pre_render", once)
        end
        client.set_event_callback("pre_render", once)
    end

    methods_mt.element.set_callback(refs.list, update, true)
    client.set_event_callback("player_connect_full", update)
    client.set_event_callback("player_disconnect", update)
    client.set_event_callback("player_spawned", update)
    client.set_event_callback("player_spawn", update)
    client.set_event_callback("player_death", update)
    client.set_event_callback("player_team", update)

    methods_mt.element.set_callback(refs.apply, function()
        players.traverse(function(v)
            for idx, _ in next, players.list do
                v[idx].value = v[selected].value
            end
        end)
    end)

    methods_mt.element.set_callback(refs.reset, function()
        players.traverse(function(v)
            for idx, _ in next, players.list do
                if idx == selected then
                    slot_mt.set(v[idx], registry[v.ref].__init)
                else
                    v[idx].value = registry[v.ref].__init
                end
            end
        end)
    end)
end

local config_system, protected, presets = {}, {}, {}

protected.database = {
    configs = 'nightly'
}

function ui.multiReference(tab, groupbox, name)
    local ref1, ref2, ref3 = ui.reference(tab, groupbox, name)
    return { ref1, ref2, ref3 }
end

local aa_group = ui_handler.group("aa", "anti-aimbot angles")
local fakelag_group = ui_handler.group("aa", "fake lag")
local other_group = ui_handler.group("aa", "other")
local antiaim_cond = { "Global\r", "Standing\r", "Running\r", "Walking\r", "Air\r", "Air-Crouch\r", "Crouch\r",
    "Crouch-Move\r" }

local ref = {
    enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
    forcebaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
    prefesafepoint = ui.reference("RAGE", "Aimbot", "Prefer safe point"),
    safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
    roll = { ui.reference("AA", "Anti-aimbot angles", "Roll") },
    clantag = ui.reference("Misc", "Miscellaneous", "Clan tag spammer"),
    other_slowmotion = ui.reference("AA", "Other", "Slow motion"),
    other_legmovement = ui.reference("AA", "Other", "Leg movement"),
    other_osaa = ui.reference("AA", "Other", "On shot anti-aim"),
    other_fkpeek = ui.reference("AA", "Other", "Fake peek"),
    pitch = { ui.reference("AA", "Anti-aimbot angles", "pitch") },
    rage = { ui.reference("RAGE", "Aimbot", "Enabled") },
    yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
    yawjitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
    bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
    freestand = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
    os = { ui.reference("AA", "Other", "On shot anti-aim") },
    slow = { ui.reference("AA", "Other", "Slow motion") },
    dt = { ui.reference("RAGE", "Aimbot", "Double tap") },
    minimum_damage_override = { ui.reference("RAGE", "Aimbot", "Minimum damage override") },
    autopeek = { ui.reference("RAGE", "Other", "Quick peek assist") },
    spread = ui.reference("Rage", "Other", "Log misses due to spread"),
    fakelag_enable = ui.reference("AA", "Fake lag", "Enabled"),
    ThirdPerson_Ref = { ui.reference("Visuals", "Effects", "Force third person (alive)") },
    scope_overlay = ui.reference('VISUALS', 'Effects', 'Remove scope overlay'),
    fakeping = ui.reference("MISC", "Miscellaneous", "Ping spike"),
    edge_jump = { ui.reference('misc', 'movement', 'jump at edge') },
}

local ref1 = {
    edge_jump = { pui.reference('misc', 'movement', 'jump at edge') },
    double_tap = { pui.reference('rage', 'aimbot', 'double tap') },
    body_aim = pui.reference('rage', 'aimbot', 'force body aim'),
    safe_point = pui.reference('rage', 'aimbot', 'force safe point'),
    fakeduck = pui.reference('rage', 'other', 'duck peek assist'),
    on_shot_anti_aim = { pui.reference('aa', 'other', 'on shot anti-aim') },
    ping = { pui.reference('misc', 'miscellaneous', 'ping spike') },
    minimum_damage_override = { pui.reference('rage', 'aimbot', 'minimum damage override') },
}

local binds = {
    legMovement = ui.multiReference("AA", "Other", "Leg movement"),
    slowmotion = ui.multiReference("AA", "Other", "Slow motion"),
    OSAAA = ui.multiReference("AA", "Other", "On shot anti-aim"),
    AAfake = ui.multiReference("AA", "Other", "Fake peek"),
}

local binds_fakelag = {
    flenabled = ui.multiReference("AA", "Fake lag", "Enabled"),
    fakelag_amount = ui.reference("AA", "Fake lag", "Amount"),
    fakelag_limit = ui.reference("AA", "Fake lag", "Limit"),
    fakelag_variance = ui.reference("AA", "Fake lag", "Variance"),
}







local tab = 0

local menu = {
    welcome = {
        asdsadsa = aa_group:label(
            '         \a7DBABCC4• · . · \aFFFFFFFF✧˚ \a7DBABCC4Night.Project \aFFFFFFFF˚ ✧ \a7DBABCC4· . · •'),
        name = aa_group:label('                     night \a7DBABCC4developer'),
        welcome = aa_group:label("              welcome back, \a7DBABCC4" .. cvar.name:get_string()),
        made = aa_group:label('          made by \a7DBABCC4bloor4 \aFFFFFFFFwith love..//'),
        curbuuld = aa_group:label('               current build: \a7DBABCC4recode '),
        night2024 = fakelag_group:label('              \a7DBABCC4night: 20\aFFFFFFFF24 - ∞'),
        Lastup = fakelag_group:label('       last update: \a7DBABCC430.03.2025'),
        curscript = fakelag_group:label('    current script: \a7DBABCC4night \aFFFFFFFF~ beta'),
        asdasdhh = aa_group:label('-------------------------------------------------'),
        cfggaa = aa_group:label('          \a7DBABCC4dont forget to \a7DBABCC4save the \a7DBABCC4config'),

        cfgaaaaa = aa_group:label(' because when you save your gamesense'),
        cfgaaaaaa = aa_group:label('config, the night lua config is NOT SAVED'),
        cfgaa = aa_group:label('-------------------------------------------------'),
        cfgggg = aa_group:label('            \aFFC0CBFFour team love ours users'),

        statistic = {
            buttonsd = other_group:button(
                "join night \a7DBABCC4:3",
                function()
                    SteamOverlayAPI.OpenExternalBrowserURL('https://dsc.gg/night-project')
                end
            )
        },
        telegramm = {
            buttonsdd = other_group:button(
                "join telegram \a7DBABCC4:3",
                function()
                    SteamOverlayAPI.OpenExternalBrowserURL('https://t.me/cfgbybloor4')
                end
            )
        },

        youtube = {
            buttonsda = other_group:button(
                "join owner youtube \a7DBABCC4:3",
                function()
                    SteamOverlayAPI.OpenExternalBrowserURL('https://www.youtube.com/@th3bloor4')
                end
            )
        },

        tgcont = {
            buttoncont = other_group:button(
                "contact developer \a7DBABCC4:3",
                function()
                    SteamOverlayAPI.OpenExternalBrowserURL('https://t.me/iqhvh')
                end
            )
        },


        neverlose = {
            buttonnl = other_group:button(
                "neverlose night beta \a7DBABCC4:3",
                function()
                    SteamOverlayAPI.OpenExternalBrowserURL('https://neverlose.cc/market/item?id=bxz0Bf')
                end
            )
        },


    },



    navigation = {

        tab = fakelag_group:combobox('~night navigation',
            { ' \a7D7D7DFFinformation', ' \aFFC0CBFFglobal', ' \a7D7D7DFFantiaim', ' \aFFC0CBFFvisuals',
                ' \a7D7D7DFFmisc' })
    },
    global = {
        lines21 = aa_group:label("        \a7DBABCC4night ~ \aFFFFFFFFconfigurations"),
        list_box = aa_group:listbox(" config", '', false),
        name = aa_group:textbox('\v\r config name', '', false),
        buttom_load = aa_group:button("\v\r load"),
        buttom_create = aa_group:button("\v\r save"),
        buttom_delete = aa_group:button("\v\r delete"),
        buttom_import = aa_group:button("\v\r import"),
        buttom_export = aa_group:button("\v\r export"),
    },
    antiaim = {
        nightasa = aa_group:label("              \a7DBABCC4night ~ \aFFFFFFFFanti-aims"),
        enable = aa_group:checkbox("~ antiaim master          "),
        antiaim_setting = aa_group:combobox("~ current settings", { "~ builder", "~ features" }),
        anim_state = aa_group:combobox("~ current state", antiaim_cond),
        features = aa_group:multiselect("~ features",
            { "~\a7DBABCC4safe head", "~\a7DBABCC4warmup aa", "~\a7DBABCC4avoid backstab" }),
        safe = aa_group:multiselect("~\a7DBABCC4safe head \aFFFFFFFFoverrides",
            { "~knife on air + duck", "~taser on air + duck", "~high distance" }),
        yaw_direction = aa_group:multiselect("Yaw Directions", { "~manuals" }),
        manuals_left = aa_group:hotkey(" ~manual left"),
        manuals_right = aa_group:hotkey(" ~manual right"),
        manuals_forward = aa_group:hotkey(" ~manual forward"),
        manuals_reset = aa_group:hotkey(" ~manual reset"),

        manuals_freestanding = aa_group:hotkey('~freestanding'),
        manuals_edgeyaw = aa_group:hotkey('~edge yaw')
    },
    visuals = {
        nightvisuals = aa_group:label("                \a7DBABCC4night ~ \aFFFFFFFFvisuals"),
        custom_gs_ind = aa_group:checkbox("~ \aFFFFFFFFcustom \a7DBABCC4indicators"),
        custom_gs_color = aa_group:color_picker(" ", 255, 255, 255),
        crosshair = aa_group:checkbox("\v\r~ \a7DBABCC4crosshair \aFFFFFFFFindicators"),
        crosshair_style = aa_group:combobox("~ \a7DBABCC4text \aFFFFFFFFmode", { "~static", "~gradient" }),
        cross_offset = aa_group:slider("~offset", 15, 100, 15, true, " ", 1),
        crosshair_color = aa_group:color_picker(" ", 255, 255, 255),
        crosshair_customind = aa_group:checkbox("\v\r~ \a7DBABCC4similar \a7DBABCC4indicator"),
        manual_arrows = aa_group:checkbox('manual arrows'),
        manual_color = aa_group:color_picker('   ', 255, 255, 255, 255),
        damage_ind = aa_group:checkbox("\v\r~ \aFFFFFFFFdamage \a7DBABCC4marker"),
        target_active = aa_group:checkbox(
            "\v\r~ \a7DBABCC4resolved \aFFFFFFFFlist \aFFFFFFFF(turn on \aFFFFFFFFnight\a7DBABCC4solver)"),
        viewmodels = aa_group:checkbox("\v\r~ \a7DBABCC4view\aFFFFFFFFmodel"),
        vS = aa_group:slider("~viewmodel fov", 0, 170, 68, true, " ", 1),
        xS = aa_group:slider("~viewmodel x", -250, 250, 0, true, " ", 0.1),
        yS = aa_group:slider("~viewmodel y", -250, 250, 0, true, " ", 0.1),
        zS = aa_group:slider("~viewmodel z", -250, 250, 0, true, " ", 0.1),
        third_person = aa_group:checkbox("~ \a7DBABCC4third \aFFFFFFFFperson"),
        third_person_value = aa_group:slider("~\a7DBABCC4amount", 30, 200, 1, true, " ", 1),
        aspectratio = aa_group:checkbox("~ \r\aFFFFFFFFaspect \a7DBABCC4ratio"),
        aspectratio_value = aa_group:slider("\r~\a7DBABCC4amount", 0, 200, 0.37, true, " ", 0.01,
            { [0.1] = "0.1", [0.025] = "5:4", [133] = "4:3", [160] = "16:9", [170] = "16:10" }),
        bullet_tracers = aa_group:checkbox("~ \a7DBABCC4bullet \aFFFFFFFFtracers"),
        scope_overlay = aa_group:checkbox("\v\r~ \aFFFFFFFFcustom \a7DBABCC4scope"),
        scope_color = aa_group:color_picker(" ", 255, 255, 255),
        scope_size = aa_group:slider("~size", 0, 500, 190),
        scope_gap = aa_group:slider("~gap", 0, 500, 15),
        scope_animation = aa_group:slider("\v\r~ animation fade", 3, 20, 12, true, 'fr', 1, { [3] = 'off' }),
        watermark = aa_group:combobox('~  \a7DBABCC4water\aFFFFFFFFmark', { '~basic', '~gradient', '~modern' }),
        watermark_visuals = aa_group:color_picker(" ", 255, 255, 255),
        aimbot_logs = aa_group:multiselect("\v\r~ \aFFFFFFFFaimbot \a7DBABCC4logs", { "~console", "~screen", }),
        aimbot_logs_hit = aa_group:color_picker("~hit", 255, 255, 255),
        aimbot_logs_miss = aa_group:color_picker("~miss", 255, 255, 255),
    },
    misc = {
        nightmisc = aa_group:label("              \a7DBABCC4night ~ \aFFFFFFFFmiscellaneous"),
        resolver = aa_group:checkbox("\v\r~ \aFFFFFFFFnight\a7DBABCC4solver"),
        predict = aa_group:checkbox("~ \aFFFFFFFFpredict \a7DBABCC4[BETA]"),
        predict_key = aa_group:hotkey(" ", true),
        fast_ladder = aa_group:checkbox("~ \a7DBABCC4fast \aFFFFFFFFladder"),
        hideshots1 = aa_group:checkbox("~ \a7DBABCC4hideshot \aFFFFFFFFfix"),
        jumpscout1 = aa_group:checkbox("~ \a7DBABCC4jump\aFFFFFFFFscout"),
        quick_switch = aa_group:checkbox("~ \a7DBABCC4quick \aFFFFFFFFswitch"),
        charge1 = aa_group:checkbox("~ \a7DBABCC4allow \aFFFFFFFFunsafe dt"),
        clantag = aa_group:checkbox("~ \a7DBABCC4clan\aFFFFFFFFtag"),
        clearcons = aa_group:checkbox("~ \a7DBABCC4filter \aFFFFFFFFconsole"),
        trash_talk = aa_group:checkbox("~ \a7DBABCC4kill\aFFFFFFFFsay"),
        animation = aa_group:checkbox("~ \a7DBABCC4animation \aFFFFFFFFbreakers"),
        animation_legs = aa_group:combobox("~ breaked legs", { "~disabled", "~static", "~jitter", "~kangaroo" }),
        animation_air = aa_group:combobox("~ breaked air", { "~disabled", "~static", "~kangaroo", "~air walk" }),
        animation_movelean = aa_group:slider('~ movelean', 0, 100, 0, true, '%', 1),
        animation_eatherquake = aa_group:checkbox('~ eatherquake')
    },
}




function traverse_table_on(tbl, prefix)
    prefix = prefix or ""
    local stack = { { tbl, prefix } }

    while #stack > 0 do
        local current = table.remove(stack)
        local current_tbl = current[1]
        local current_prefix = current[2]

        for key, value in pairs(current_tbl) do
            local full_key = current_prefix .. key
            if type(value) == "table" then
                table.insert(stack, { value, full_key .. "." })
            else
                ui.set_visible(value, true)
            end
        end
    end
end

function traverse_table(tbl, prefix)
    prefix = prefix or ""
    local stack = { { tbl, prefix } }

    while #stack > 0 do
        local current = table.remove(stack)
        local current_tbl = current[1]
        local current_prefix = current[2]

        for key, value in pairs(current_tbl) do
            local full_key = current_prefix .. key
            if type(value) == "table" then
                table.insert(stack, { value, full_key .. "." })
            else
                ui.set_visible(value, false)
            end
        end
    end
end

function hide_original_menu(state)
    ui.set_visible(ref.enabled, state)
    ui.set_visible(ref.pitch[1], state)
    ui.set_visible(ref.pitch[2], state)
    ui.set_visible(ref.yawbase, state)
    ui.set_visible(ref.yaw[1], state)
    ui.set_visible(ref.yaw[2], state)
    ui.set_visible(ref.yawjitter[1], state)
    ui.set_visible(ref.roll[1], state)
    ui.set_visible(ref.yawjitter[2], state)
    ui.set_visible(ref.bodyyaw[1], state)
    ui.set_visible(ref.bodyyaw[2], state)
    ui.set_visible(ref.fsbodyyaw, state)
    ui.set_visible(ref.edgeyaw, state)
    ui.set_visible(ref.freestand[1], state)
    ui.set_visible(ref.freestand[2], state)
end

local builder = {}

for i = 1, #antiaim_cond do
    builder[i] = {
        label = aa_group:label(" "),
        enable = aa_group:checkbox("Enable      "),
        pitch = aa_group:combobox("Pitch", { "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom" }),
        pitch_custom = aa_group:slider("Amount", -89, 89, 0, true, '°'),
        yaw_base = aa_group:combobox("Yaw base", { "Local view", "At targets" }),
        yaw = aa_group:combobox("Yaw", { "Off", "180", "Spin", "Static", "180 Z", "Crosshair" }),
        static = aa_group:slider("Amount", -180, 180, 0, true, '°'),
        jitter = aa_group:combobox("Yaw jitter", { 'Off', 'Offset', 'Center', 'Random', 'Skitter', 'X-Way' }),
        xway1 = aa_group:slider("Ways", 3, 7, 3, true, "w"),
        way1 = {
            [1] = aa_group:slider('Way 1', -180, 180, 0, true, '°'),
            [2] = aa_group:slider('Way 2', -180, 180, 0, true, '°'),
            [3] = aa_group:slider('Way 3', -180, 180, 0, true, '°'),
            [4] = aa_group:slider('Way 4', -180, 180, 0, true, '°'),
            [5] = aa_group:slider('Way 5', -180, 180, 0, true, '°'),
            [6] = aa_group:slider('Way 6', -180, 180, 0, true, '°'),
            [7] = aa_group:slider('Way 7', -180, 180, 0, true, '°')
        },
        range = aa_group:slider("Jitter range", -180, 180, 0, true, '°'),
        body = aa_group:combobox('Body Yaw', { 'Off', 'Opposite', 'Static', 'Jitter' }),
        body_amount = aa_group:slider("Fake amount", -180, 180, 0, true, '°'),
        delay = aa_group:slider("Delay", 1, 14, 1, true, "t", 1, { [1] = "Off" }),
        random = aa_group:slider("Randomize", 0, 100, 0, true, "%", 1, { [0] = "Off" }),
        freestanding_body = aa_group:checkbox("Freestanding body yaw"),
        defensive = other_group:checkbox("Defensive AA"),
        mode = other_group:combobox("Mode", { "On peek", "Always on" }),
        def_pitch = other_group:combobox("Pitch", { "Off", "Custom", "Jitter", "Random", "Spinable" }),
        custom_pitch = other_group:slider("Angle", -89, 89, 0, true, '°'),
        angle1 = other_group:slider("Angle 1", -89, 89, 0, true, '°'),
        angle2 = other_group:slider("Angle 2", -89, 89, 0, true, '°'),
        def_yaw = other_group:combobox("Yaw", { "Off", "Jitter", "Spinable", "X-Way" }),
        yaw1 = other_group:slider("Yaw amount", 0, 360, 0, true, '°'),
        yaw_speed = other_group:slider("Yaw Speed", -50, 50, 0, true, " ", 0.1),
        jitter_speed = other_group:slider("Jitter Speed", 2, 14, 0, true, "t", 1, { [2] = "Off" }),
        xway = other_group:slider("Ways", 3, 7, 3, true, "w"),
        way = {}
    }
end

function update_way_sliders1()
    for i = 1, #antiaim_cond do
        local visible = i == 1 and true or builder[i].enable:get()
        local check = tab == 2 and menu.antiaim.enable:get()
        local cond_check = menu.antiaim.enable:get() and
            menu.antiaim.anim_state:get() == antiaim_cond[i] and menu.antiaim.antiaim_setting:get() == '~ builder'
        for w = 1, 7 do
            builder[i].way1[w]:set_visible(
                check and visible and cond_check and
                builder[i].jitter:get() == "X-Way" and
                builder[i].xway1:get() >= w
            )
        end
    end
end

function update_way_sliders()
    for i = 1, #antiaim_cond do
        local ways_count = builder[i].xway:get() or 3

        local visible = i == 1 and true or builder[i].enable:get()
        local check = tab == 2 and menu.antiaim.enable:get()
        local cond_check = menu.antiaim.enable:get() and
            menu.antiaim.anim_state:get() == antiaim_cond[i] and menu.antiaim.antiaim_setting:get() == '~ builder'
        for w = 1, 7 do
            if w <= ways_count then
                if not builder[i].way[w] then
                    builder[i].way[w] = other_group:slider('Way ' .. w, -180, 180, 0, true, '°')
                end
                builder[i].way[w]:set_visible(
                    check and visible and cond_check and
                    builder[i].defensive:get() and
                    builder[i].def_yaw:get() == "X-Way" and
                    builder[i].xway:get() >= w
                )
            else
                if builder[i].way[w] then
                    builder[i].way[w]:set_visible(false)
                end
            end
        end
    end
end

function antiaim()
    for i = 1, #antiaim_cond do
        local visible = i == 1 and true or builder[i].enable:get()
        local check = tab == 2 and menu.antiaim.enable:get()
        local cond_check = menu.antiaim.enable:get() and
            menu.antiaim.anim_state:get() == antiaim_cond[i] and menu.antiaim.antiaim_setting:get() == '~ builder'
        builder[i].label:set_visible(check and cond_check)
        if i > 1 then
            builder[i].enable:set_visible(check and cond_check)
        else
            builder[i].enable:set_visible(false)
        end
        builder[i].pitch:set_visible(check and visible and cond_check)
        builder[i].pitch_custom:set_visible(check and visible and cond_check and builder[i].pitch:get() == "Custom")
        builder[i].yaw_base:set_visible(check and visible and cond_check)
        builder[i].yaw:set_visible(check and visible and cond_check)
        builder[i].static:set_visible(check and visible and cond_check and builder[i].yaw:get() ~= "Off")
        builder[i].jitter:set_visible(check and visible and cond_check)
        builder[i].range:set_visible(check and visible and cond_check and builder[i].jitter:get() ~= "Off" and
            builder[i].jitter:get() ~= "X-Way")
        builder[i].xway1:set_visible(check and visible and cond_check and builder[i].jitter:get() == "X-Way")
        builder[i].body:set_visible(check and visible and cond_check)
        builder[i].body_amount:set_visible(check and visible and cond_check and builder[i].body:get() == "Static")
        builder[i].delay:set_visible(check and visible and cond_check and builder[i].body:get() == "Jitter")
        builder[i].random:set_visible(check and visible and cond_check)
        builder[i].freestanding_body:set_visible(check and visible and cond_check)
        builder[i].defensive:set_visible(check and visible and cond_check)
        builder[i].mode:set_visible(check and visible and cond_check and builder[i].defensive:get())
        builder[i].def_pitch:set_visible(check and visible and cond_check and builder[i].defensive:get())
        builder[i].custom_pitch:set_visible(check and visible and cond_check and builder[i].defensive:get() and
            builder[i].def_pitch:get() == "Custom")
        builder[i].angle1:set_visible(check and visible and cond_check and builder[i].defensive:get() and
            builder[i].def_pitch:get() ~= "Custom" and builder[i].def_pitch:get() ~= "Off")
        builder[i].angle2:set_visible(check and visible and cond_check and builder[i].defensive:get() and
            builder[i].def_pitch:get() ~= "Custom" and builder[i].def_pitch:get() ~= "Off")
        builder[i].def_yaw:set_visible(check and visible and cond_check and builder[i].defensive:get())
        builder[i].yaw1:set_visible(check and visible and cond_check and builder[i].defensive:get() and
            builder[i].def_yaw:get() ~= "Off" and builder[i].def_yaw:get() ~= "X-Way")
        builder[i].yaw_speed:set_visible(check and visible and cond_check and builder[i].defensive:get() and
            builder[i].def_yaw:get() ~= "Off" and builder[i].def_yaw:get() ~= "X-Way" and
            builder[i].def_yaw:get() ~= "Jitter")
        builder[i].jitter_speed:set_visible(check and visible and cond_check and builder[i].defensive:get() and
            builder[i].def_yaw:get() == "Jitter")
        builder[i].xway:set_visible(check and visible and cond_check and builder[i].defensive:get() and
            builder[i].def_yaw:get() == "X-Way")
    end
    menu.welcome.statistic.buttonsd:set_visible(tab == 0)
    menu.welcome.telegramm.buttonsdd:set_visible(tab == 0)
    menu.welcome.youtube.buttonsda:set_visible(tab == 0)
    menu.welcome.tgcont.buttoncont:set_visible(tab == 0)
    menu.welcome.neverlose.buttonnl:set_visible(tab == 0)
    --[[        statistic = {
            buttonsd = other_group:button(
                "join night \a7DBABCC4:3",
                function()
                    SteamOverlayAPI.OpenExternalBrowserURL('https://dsc.gg/night-project')
                end
            )
        },
        telegramm = {
            buttonsdd = other_group:button(
                "join telegram \a7DBABCC4:3",
                function()
                    SteamOverlayAPI.OpenExternalBrowserURL('https://t.me/cfgbybloor4')
                end
            )
        },

        youtube = {
            buttonsda = other_group:button(
                "join owner youtube \a7DBABCC4:3",
                function()
                    SteamOverlayAPI.OpenExternalBrowserURL('https://www.youtube.com/@th3bloor4')
                end
            )
        },

        tgcont = {
            buttoncont = other_group:button(
                "contact developer \a7DBABCC4:3",
                function()
                    SteamOverlayAPI.OpenExternalBrowserURL('https://t.me/iqhvh')
                end
            )
        },


        neverlose = {
            buttonnl = other_group:button(
                "neverlose night beta \a7DBABCC4:3",
                function()
                    SteamOverlayAPI.OpenExternalBrowserURL('https://neverlose.cc/market/item?id=bxz0Bf')
                end
            )
        },


    },]]
end

local yaw_amount, current_tickcount, to_jitter, yaw_direction, last_press_t_dir = 0, 0, false, 0, 0
local id = 1
function player_state(cmd)
    local lp = entity.get_local_player()
    if lp == nil then return end

    local vecvelocity = { entity.get_prop(lp, "m_vecVelocity") }
    local flags = entity.get_prop(lp, "m_fFlags")
    local velocity = math.sqrt(vecvelocity[1] ^ 2 + vecvelocity[2] ^ 2)
    local groundcheck = bit.band(flags, 1) == 1
    local jumpcheck = bit.band(flags, 1) == 0 or cmd.in_jump == 1
    local ducked = entity.get_prop(lp, "m_flDuckAmount") > 0.7
    local duckcheck = ducked or ui.get(ref.fakeduck)
    local slowwalk_key = ui.get(ref.slow[1]) and ui.get(ref.slow[2])

    if jumpcheck and duckcheck then
        return "Air-Crouch"
    elseif jumpcheck then
        return "Air"
    elseif duckcheck and velocity > 10 then
        return "Crouch-Move"
    elseif duckcheck and velocity < 10 then
        return "Crouch"
    elseif groundcheck and slowwalk_key and velocity > 10 then
        return "Walking"
    elseif groundcheck and velocity > 5 then
        return "Running"
    elseif groundcheck and velocity < 5 then
        return "Standing"
    else
        return "Global"
    end
end

function randomize_value(original_value, percent)
    local min_range = original_value - (original_value * percent * 0.01)
    local max_range = original_value + (original_value * percent * 0.01)
    return math.random(min_range, max_range)
end

function desyncside()
    if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then return end
    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local side = bodyyaw > 0 and -1 or 1
    return side
end

local left, right, forward = false, false, false
local manual = 0
local get_manual = function()
    if not menu.antiaim.yaw_direction:get("~manuals") then return 0 end
    local yaw = {
        [1] = -90,
        [2] = 90,
        [3] = 180
    }
    local l = menu.antiaim.manuals_left:get()
    local r = menu.antiaim.manuals_right:get()
    local w = menu.antiaim.manuals_forward:get()
    if l ~= left then
        menu.antiaim.manuals_right:set(false)
        if manual == 1 then
            manual = 0
        else
            manual = 1
        end
    end
    if r ~= right then
        menu.antiaim.manuals_left:set(false)
        if manual == 2 then
            manual = 0
        else
            manual = 2
        end
    end
    if w ~= forward then
        menu.antiaim.manuals_left:set(false)
        menu.antiaim.manuals_right:set(false)
        if manual == 3 then
            manual = 0
        else
            manual = 3
        end
    end
    left, right, forward = l, r, w
    return yaw[manual] or 0
end

local pos = vector(client.screen_size()) / 2
function manual_indicator()
    if not menu.visuals.manual_arrows:get() then return end
    local me = entity.get_local_player()
    if not me then return end

    local r, g, b, a = menu.visuals.manual_color:get()
    if manual == 1 then
        renderer.text(pos.x - 48, pos.y, r, g, b, a, "bc", nil, "❮")
    end
    if manual == 2 then
        renderer.text(pos.x + 48, pos.y, r, g, b, a, "bc", nil, "❯")
    end
end

client.set_event_callback('paint', manual_indicator)
local breaker = {
    defensive = 0,
    defensive_check = 0,
    cmd = 0,
    tickbase = 0
}

client.set_event_callback("predict_command", function(cmd)
    me = entity.get_local_player()
    if not me or not entity.is_alive(me) then
        breaker.defensive = 0
        breaker.defensive_check = 0
        return
    end
    breaker.tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
    breaker.defensive_check = math.max(breaker.tickbase, breaker.defensive_check)
    breaker.cmd = 0
    if math.abs(breaker.tickbase - breaker.defensive_check) > 64 then
        breaker.defensive = 0
        breaker.defensive_check = 0
    end
    if breaker.defensive_check > breaker.tickbase then
        breaker.defensive = math.abs(breaker.tickbase - breaker.defensive_check)
    end
    breaker.tickbase_check = globals.tickcount() > entity.get_prop(me, "m_nTickbase")
end)

function is_defensive_active(lp)
    is_defensive = breaker.tickbase_check and breaker.defensive > 2 and breaker.defensive < 14
    return is_defensive
end

function is_vulnerable()
    for _, v in ipairs(entity.get_players(true)) do
        local flags = (entity.get_esp_data(v)).flags
        if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
            return true
        end
    end
    return false
end

function spin(speed, iterations, initial_value)
    local spin_value = builder[id].yaw1:get()


    if spin_value == 0 then
        spin_value = 1
    end

    local start = (speed * 35 * globals.curtime()) % spin_value
    local iterations = iterations or 1
    local value = initial_value

    return start, iterations, value
end

function spin_pitch(speed, iterations, initial_value)
    local slider1 = builder[id].angle1:get()
    local slider2 = builder[id].angle2:get()

    local progress = (globals.curtime() * speed / 15) % 1

    local start = slider1 + (slider2 - slider1) * progress

    local iterations = iterations or 1
    local value = initial_value

    return start, iterations, value
end

function xway(cmd)
    local ctx = builder[id]
    if ctx.def_yaw:get() == "X-Way" then
        local ways_count = ctx.xway:get()
        if ways_count > 0 then
            local way_index = (cmd.command_number % ways_count) + 1
            if ctx.way[way_index] then
                return ctx.way[way_index]:get()
            end
        end
    end
    return 0
end

function xway1(cmd)
    local ctx = builder[id]
    if ctx.jitter:get() == "X-Way" then
        local ways_count = ctx.xway1:get()
        if ways_count > 0 then
            local way_index = (cmd.command_number % ways_count) + 1
            if ctx.way1[way_index] then
                return ctx.way1[way_index]:get()
            end
        end
    end
    return 0
end

local to_defensive, first_execution = true, true

function defensive_peek()
    to_defensive = false
end

function defensive_disabler()
    to_defensive = true
end

function anti_knife_dist(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
end

function fastladder(e)
    if not menu.misc.fast_ladder:get() then return end
    local local_player = entity.get_local_player()
    local pitch, yaw = client.camera_angles()
    if entity.get_prop(local_player, "m_MoveType") == 9 then
        e.yaw = math.floor(e.yaw + 0.5)
        e.roll = 0
        if e.forwardmove == 0 then
            if e.sidemove ~= 0 then
                e.pitch = 89
                e.yaw = e.yaw + 180
                if e.sidemove < 0 then
                    e.in_moveleft = 0
                    e.in_moveright = 1
                end
                if e.sidemove > 0 then
                    e.in_moveleft = 1
                    e.in_moveright = 0
                end
            end
        end
        if e.forwardmove > 0 then
            if pitch < 45 then
                e.pitch = 89
                e.in_moveright = 1
                e.in_moveleft = 0
                e.in_forward = 0
                e.in_back = 1
                if e.sidemove == 0 then
                    e.yaw = e.yaw + 90
                end
                if e.sidemove < 0 then
                    e.yaw = e.yaw + 150
                end
                if e.sidemove > 0 then
                    e.yaw = e.yaw + 30
                end
            end
        end
        if e.forwardmove < 0 then
            e.pitch = 89
            e.in_moveleft = 1
            e.in_moveright = 0
            e.in_forward = 1
            e.in_back = 0
            if e.sidemove == 0 then
                e.yaw = e.yaw + 90
            end
            if e.sidemove > 0 then
                e.yaw = e.yaw + 150
            end
            if e.sidemove < 0 then
                e.yaw = e.yaw + 30
            end
        end
    end
end

function aa_setup(cmd)
    local lp = entity.get_local_player()
    if lp == nil then return end

    if player_state(cmd) == "Crouch-Move" and builder[8].enable:get() then
        id = 8
    elseif player_state(cmd) == "Crouch" and builder[7].enable:get() then
        id = 7
    elseif player_state(cmd) == "Air-Crouch" and builder[6].enable:get() then
        id = 6
    elseif player_state(cmd) == "Air" and builder[5].enable:get() then
        id = 5
    elseif player_state(cmd) == "Running" and builder[3].enable:get() then
        id = 3
    elseif player_state(cmd) == "Walking" and builder[4].enable:get() then
        id = 4
    elseif player_state(cmd) == "Standing" and builder[2].enable:get() then
        id = 2
    else
        id = 1
    end

    local defensive = is_defensive_active(lp)

    ui.set(ref.roll[1], 0)


    local delay_time = builder[id].delay:get()

    if not (defensive and builder[id].enable:get() and to_defensive and builder[id].mode:get() == "On peek" or defensive and builder[id].enable:get() and builder[id].mode:get() == "Always on") and globals.tickcount() > current_tickcount + delay_time then
        if cmd.chokedcommands == 0 then
            to_jitter = not to_jitter
            current_tickcount = globals.tickcount()
        end
    elseif globals.tickcount() < current_tickcount then
        current_tickcount = globals.tickcount()
    end
    if is_vulnerable() then
        if first_execution then
            first_execution = false
            to_defensive = true
            client.set_event_callback("setup_command", defensive_disabler)
        end
        if globals.tickcount() % 10 == 9 then
            defensive_peek()
            client.unset_event_callback("setup_command", defensive_disabler)
        end
    else
        first_execution = true
        to_defensive = false
    end

    yawjitter = randomize_value(builder[id].range:get(), builder[id].random:get())

    ui.set(ref.pitch[1], builder[id].pitch:get())
    ui.set(ref.pitch[2], builder[id].pitch_custom:get())
    ui.set(ref.yawbase, builder[id].yaw_base:get())
    if yaw_direction ~= 0 then
        ui.set(ref.yaw[1], "180")
    else
        ui.set(ref.yaw[1], builder[id].yaw:get())
    end
    if builder[id].body:get() == "Jitter" and builder[id].delay:get() > 0 then
        ui.set(ref.bodyyaw[1], "Static")
        ui.set(ref.bodyyaw[2], to_jitter and -1 or 1)
        ui.set(ref.yawjitter[1], "Off")
        ui.set(ref.yawjitter[2], 0)
        yaw_l = builder[id].static:get()
        yaw_r = builder[id].static:get()

        if builder[id].jitter:get() == 'Center' then
            if desyncside() == -1 then
                yaw_amount = (yaw_l + yawjitter / 2)
            else
                yaw_amount = (yaw_r - yawjitter / 2)
            end
        elseif builder[id].jitter:get() == 'Offset' then
            if desyncside() == -1 then
                yaw_amount = (yaw_l)
            else
                yaw_amount = (yaw_r - yawjitter / 2)
            end
        elseif builder[id].jitter:get() == 'Random' then
            if desyncside() == -1 then
                yaw_amount = math.random(yaw_l + yawjitter / 2 + 10, yaw_l + yawjitter / 2 - 10)
            else
                yaw_amount = math.random(yaw_r - yawjitter / 2 - 10, yaw_r - yawjitter / 2 + 10)
            end
        elseif builder[id].jitter:get() == 'Skitter' then
            if globals.tickcount() % 3 == 0 then
                if desyncside() == -1 then
                    yaw_amount = (yaw_l + yawjitter / 2)
                else
                    yaw_amount = (yaw_r)
                end
            elseif globals.tickcount() % 3 == 1 then
                if desyncside() == -1 then
                    yaw_amount = (yaw_l)
                else
                    yaw_amount = (yaw_r)
                end
            else
                if desyncside() then
                    yaw_amount = (yaw_l)
                else
                    yaw_amount = (yaw_r - yawjitter / 2)
                end
            end
        elseif builder[id].jitter:get() == "X-Way" then
            if desyncside() == -1 then
                yaw_amount = xway1(cmd) / 2 + yaw_l
            else
                yaw_amount = xway1(cmd) / 2 - yaw_r
            end
        end
    else
        if builder[id].jitter:get() == "X-Way" then
            ui.set(ref.bodyyaw[1], builder[id].body:get())
            ui.set(ref.bodyyaw[2], builder[id].body_amount:get())
            if desyncside() == -1 then
                yaw_amount = xway1(cmd) / 2 + builder[id].static:get()
            else
                yaw_amount = xway1(cmd) / 2 - builder[id].static:get()
            end
        else
            ui.set(ref.yawjitter[1], builder[id].jitter:get())
            ui.set(ref.yawjitter[2], math.max(-180, math.min(180, yawjitter)))
            ui.set(ref.bodyyaw[1], builder[id].body:get())
            ui.set(ref.bodyyaw[2], builder[id].body_amount:get())
            yaw_amount = builder[id].static:get()
        end
    end
    ui.set(ref.edgeyaw, menu.antiaim.manuals_edgeyaw:get())
    ui.set(ref.fsbodyyaw, builder[id].freestanding_body:get())
    if menu.antiaim.manuals_freestanding:get() then
        ui.set(ref.freestand[1], true)
        ui.set(ref.freestand[2], "Always on")
    else
        ui.set(ref.freestand[1], false)
        ui.set(ref.freestand[2], "On hotkey")
    end

    cmd.force_defensive = builder[id].defensive:get() and builder[id].mode:get() == "Always on" or
    builder[id].defensive:get() and builder[id].mode:get() == "On peek" and to_defensive

    if (globals.tickcount() % builder[id].jitter_speed:get()) == 1 then
        dele = not dele
    end
get_manual()
    if defensive and builder[id].defensive:get() and yaw_direction == 0 then
        if builder[id].def_pitch:get() == "Custom" then
            ui.set(ref.pitch[1], "Custom")
            ui.set(ref.pitch[2], builder[id].custom_pitch:get())
        elseif builder[id].def_pitch:get() == "Jitter" then
            if globals.tickcount() % 3 == 1 then
                ui.set(ref.pitch[1], "Custom")
                ui.set(ref.pitch[2], builder[id].angle1:get())
            else
                ui.set(ref.pitch[1], "Custom")
                ui.set(ref.pitch[2], builder[id].angle2:get())
            end
        elseif builder[id].def_pitch:get() == "Random" then
            ui.set(ref.pitch[1], "Custom")
            ui.set(ref.pitch[2], client.random_int(builder[id].angle1:get(), builder[id].angle2:get()))
        elseif builder[id].def_pitch:get() == "Spinable" then
            ui.set(ref.pitch[1], "Custom")
            ui.set(ref.pitch[2], spin_pitch)
        end

        if builder[id].def_yaw:get() == "Spinable" then
            ui.set(ref.yaw[1], "180")
            ui.set(ref.bodyyaw[1], "Jitter")
            ui.set(ref.bodyyaw[2], -1)
            local spin = spin(-builder[id].yaw_speed:get(), 1)
            yaw_amount = math.normalize_yaw(spin)
        elseif builder[id].def_yaw:get() == "X-Way" then
            ui.set(ref.yaw[1], "180")
            ui.set(ref.bodyyaw[1], "Jitter")
            ui.set(ref.bodyyaw[2], -1)
            yaw_amount = xway(cmd)
        elseif builder[id].def_yaw:get() == "Jitter" then
            ui.set(ref.yaw[1], "180")
            ui.set(ref.bodyyaw[1], "Off")
            ui.set(ref.bodyyaw[2], 1)
            yaw_amount = dele and builder[id].yaw1:get() * 0.5 or -builder[id].yaw1:get() * 0.5
        end
    end 
    ui.set(ref.yaw[2], manual == 0 and math.max(-180, math.min(180, yaw_amount)) or get_manual())

    local players = entity.get_players(true)
    if menu.antiaim.features:get("~\a7DBABCC4warmup aa") then
        if entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 1 then
            ui.set(ref.yaw[1], "Spin")
            ui.set(ref.yaw[2], 55)
            ui.set(ref.yawjitter[1], "Off")
            ui.set(ref.yawjitter[2], 0)
            ui.set(ref.bodyyaw[1], "Static")
            ui.set(ref.bodyyaw[2], 1)
            ui.set(ref.pitch[1], "Custom")
            ui.set(ref.pitch[2], 0)
        end
    end

    local threat = client.current_threat()

    local lp_weapon = entity.get_player_weapon(lp)
    local lp_orig_x, lp_orig_y, lp_orig_z = entity.get_prop(lp, "m_vecOrigin")
    local flags = entity.get_prop(lp, "m_fFlags")
    local jumpcheck = bit.band(flags, 1) == 0 or cmd.in_jump == 1
    local ducked = entity.get_prop(lp, "m_flDuckAmount") > 0.7

    if menu.antiaim.features:get("~\a7DBABCC4safe head") then
        if lp_weapon ~= nil then
            if menu.antiaim.safe:get("~knife on air + duck") then
                if jumpcheck and ducked and entity.get_classname(lp_weapon) == "CKnife" then
                    ui.set(ref.pitch[1], "Down")
                    ui.set(ref.yawjitter[1], "Off")
                    ui.set(ref.yaw[1], "180")
                    ui.set(ref.yaw[2], 14)
                    ui.set(ref.bodyyaw[1], "Off")
                end
            end
            if menu.antiaim.safe:get("~taser on air + duck") then
                if jumpcheck and ducked and entity.get_classname(lp_weapon) == "CWeaponTaser" then
                    ui.set(ref.pitch[1], "Down")
                    ui.set(ref.yawjitter[1], "Off")
                    ui.set(ref.yaw[1], "180")
                    ui.set(ref.yaw[2], 14)
                    ui.set(ref.bodyyaw[1], "Off")
                end
            end
            if menu.antiaim.safe:get("~high distance") then
                if threat ~= nil then
                    threat_x, threat_y, threat_z = entity.get_prop(threat, "m_vecOrigin")
                    threat_dist = anti_knife_dist(lp_orig_x, lp_orig_y, lp_orig_z, threat_x, threat_y, threat_z)
                    if threat_dist > 1500 then
                        ui.set(ref.pitch[1], "Down")
                        ui.set(ref.yawjitter[1], "Off")
                        ui.set(ref.yaw[1], "180")
                        ui.set(ref.yaw[2], 14)
                        ui.set(ref.bodyyaw[1], "Off")
                    end
                end
            end
        end
    end

    if menu.antiaim.features:get("~\a7DBABCC4avoid backstab") then
        for i = 1, #players do
            if players == nil then
                return
            end
            enemy_orig_x, enemy_orig_y, enemy_orig_z = entity.get_prop(players[i], "m_vecOrigin")
            distance_to = anti_knife_dist(lp_orig_x, lp_orig_y, lp_orig_z, enemy_orig_x, enemy_orig_y, enemy_orig_z)
            weapon = entity.get_player_weapon(players[i])
            if weapon == nil then
                return
            end
            if entity.get_classname(weapon) == "CKnife" and distance_to <= 350 then
                ui.set(ref.yaw[2], 180)
                ui.set(ref.yawbase, "At targets")
            end
        end
    end
end
local gram_create = function(value, count)
    local gram = {}; for i = 1, count do gram[i] = value; end
    return gram;
end
local gram_update = function(tab, value, forced)
    local new_tab = tab; if forced or new_tab[#new_tab] ~= value then
        table.insert(new_tab, value); table.remove(new_tab, 1);
    end; tab = new_tab;
end
local get_average = function(tab)
    local elements, sum = 0, 0; for k, v in pairs(tab) do
        sum = sum + v; elements = elements + 1;
    end
    return sum / elements;
end

local function doubletap_charged()
    if not ui.get(ref.dt[1]) or not ui.get(ref.dt[2]) or ui.get(ref.fakeduck) then return false end
    if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then return end
    local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
    if weapon == nil then return false end
    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.01
    local checkcheck = entity.get_prop(weapon, "m_flNextPrimaryAttack")
    if checkcheck == nil then return end
    local next_primary_attack = checkcheck + 0.01
    if next_attack == nil or next_primary_attack == nil then return false end
    return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
end





function visible()
    local tabs = {
        [' \a7D7D7DFFinformation'] = 0,
        [' \aFFC0CBFFglobal'] = 1,
        [' \a7D7D7DFFantiaim'] = 2,
        [' \aFFC0CBFFvisuals'] = 3,
        [' \a7D7D7DFFmisc'] = 4
    }
    tab = tabs[menu.navigation.tab:get()] or 0

    menu.welcome.asdasdhh:set_visible(tab == 0)
    menu.welcome.curbuuld:set_visible(tab == 0)
    menu.welcome.cfggaa:set_visible(tab == 0)
    menu.welcome.cfgaaaaa:set_visible(tab == 0)
    menu.welcome.cfgaaaaaa:set_visible(tab == 0)
    menu.welcome.cfgaa:set_visible(tab == 0)
    menu.welcome.cfgggg:set_visible(tab == 0)
    menu.welcome.asdsadsa:set_visible(tab == 0)
    menu.welcome.name:set_visible(tab == 0)
    menu.welcome.welcome:set_visible(tab == 0)
    menu.welcome.made:set_visible(tab == 0)
    menu.antiaim.nightasa:set_visible(tab == 2)
    menu.antiaim.enable:set_visible(tab == 2)
    menu.antiaim.antiaim_setting:set_visible(tab == 2 and menu.antiaim.enable:get())
    menu.antiaim.anim_state:set_visible(tab == 2 and menu.antiaim.enable:get() and
        menu.antiaim.antiaim_setting:get() == "~ builder")
    menu.antiaim.features:set_visible(tab == 2 and menu.antiaim.enable:get() and
        menu.antiaim.antiaim_setting:get() == "~ features")
    menu.antiaim.safe:set_visible(tab == 2 and menu.antiaim.enable:get() and
        menu.antiaim.antiaim_setting:get() == "~ features" and menu.antiaim.features:get("~\a7DBABCC4safe head"))
    menu.antiaim.yaw_direction:set_visible(tab == 2 and menu.antiaim.enable:get() and
        menu.antiaim.antiaim_setting:get() == "~ features")
    menu.antiaim.manuals_left:set_visible(tab == 2 and menu.antiaim.enable:get() and
        menu.antiaim.antiaim_setting:get() == "~ features" and menu.antiaim.yaw_direction:get("~manuals"))

    menu.antiaim.manuals_freestanding:set_visible(tab == 2 and menu.antiaim.enable:get() and
        menu.antiaim.antiaim_setting:get() == "~ features" and menu.antiaim.yaw_direction:get("~manuals"))
    menu.antiaim.manuals_edgeyaw:set_visible(tab == 2 and menu.antiaim.enable:get() and
        menu.antiaim.antiaim_setting:get() == "~ features" and menu.antiaim.yaw_direction:get("~manuals"))

    menu.antiaim.manuals_right:set_visible(tab == 2 and menu.antiaim.enable:get() and
        menu.antiaim.antiaim_setting:get() == "~ features" and menu.antiaim.yaw_direction:get("~manuals"))
    menu.antiaim.manuals_forward:set_visible(tab == 2 and menu.antiaim.enable:get() and
        menu.antiaim.antiaim_setting:get() == "~ features" and menu.antiaim.yaw_direction:get("~manuals"))
    menu.antiaim.manuals_reset:set_visible(tab == 2 and menu.antiaim.enable:get() and
        menu.antiaim.antiaim_setting:get() == "~ features" and menu.antiaim.yaw_direction:get("~manuals"))
    menu.global.buttom_load:set_visible(tab == 1)
    menu.global.buttom_create:set_visible(tab == 1)
    menu.global.buttom_delete:set_visible(tab == 1)
    menu.global.buttom_import:set_visible(tab == 1)
    menu.global.buttom_export:set_visible(tab == 1)
    menu.global.lines21:set_visible(tab == 1)
    menu.global.list_box:set_visible(tab == 1)
    menu.global.name:set_visible(tab == 1)
    menu.visuals.nightvisuals:set_visible(tab == 3)
    menu.visuals.custom_gs_ind:set_visible(tab == 3)
    menu.visuals.custom_gs_color:set_visible(tab == 3 and menu.visuals.custom_gs_ind:get())
    menu.visuals.crosshair:set_visible(tab == 3)
    menu.visuals.manual_arrows:set_visible(tab == 3)
    menu.visuals.manual_color:set_visible(tab == 3)
    menu.visuals.third_person:set_visible(tab == 3)
    menu.visuals.third_person_value:set_visible(tab == 3 and menu.visuals.third_person:get())
    menu.visuals.aspectratio:set_visible(tab == 3)
    menu.visuals.aspectratio_value:set_visible(tab == 3 and menu.visuals.aspectratio:get())
    menu.visuals.viewmodels:set_visible(tab == 3)
    menu.visuals.vS:set_visible(tab == 3 and menu.visuals.viewmodels:get())
    menu.visuals.zS:set_visible(tab == 3 and menu.visuals.viewmodels:get())
    menu.visuals.yS:set_visible(tab == 3 and menu.visuals.viewmodels:get())
    menu.visuals.xS:set_visible(tab == 3 and menu.visuals.viewmodels:get())
    menu.visuals.crosshair_style:set_visible(tab == 3 and menu.visuals.crosshair:get())
    menu.visuals.cross_offset:set_visible(tab == 3 and menu.visuals.crosshair:get())
    menu.visuals.crosshair_customind:set_visible(tab == 3 and menu.visuals.crosshair:get())
    menu.visuals.crosshair_color:set_visible(tab == 3 and menu.visuals.crosshair:get())
    menu.visuals.damage_ind:set_visible(tab == 3)
    menu.visuals.target_active:set_visible(tab == 3)
    menu.visuals.scope_overlay:set_visible(tab == 3)
    menu.visuals.scope_color:set_visible(tab == 3 and menu.visuals.scope_overlay:get())
    menu.visuals.scope_size:set_visible(tab == 3 and menu.visuals.scope_overlay:get())
    menu.visuals.scope_gap:set_visible(tab == 3 and menu.visuals.scope_overlay:get())
    menu.visuals.scope_animation:set_visible(tab == 3 and menu.visuals.scope_overlay:get())
    menu.visuals.aimbot_logs:set_visible(tab == 3)
    menu.visuals.bullet_tracers:set_visible(tab == 3)
    menu.visuals.aimbot_logs_hit:set_visible(tab == 3 and menu.visuals.aimbot_logs:get("~console") or
        tab == 3 and menu.visuals.aimbot_logs:get("~screen"))
    menu.visuals.aimbot_logs_miss:set_visible(tab == 3 and menu.visuals.aimbot_logs:get("~console") or
        tab == 3 and menu.visuals.aimbot_logs:get("~screen"))
    menu.visuals.watermark:set_visible(tab == 3)
    menu.visuals.watermark_visuals:set_visible(tab == 3 and menu.visuals.watermark:get())
    menu.misc.nightmisc:set_visible(tab == 4)
    menu.misc.resolver:set_visible(tab == 4)
    menu.misc.predict:set_visible(tab == 4)
    menu.misc.predict_key:set_visible(tab == 4 and menu.misc.predict:get())
    menu.misc.jumpscout1:set_visible(tab == 4)
    menu.misc.quick_switch:set_visible(tab == 4)
    menu.misc.charge1:set_visible(tab == 4)
    menu.misc.fast_ladder:set_visible(tab == 4)
    menu.misc.hideshots1:set_visible(tab == 4)
    menu.misc.clantag:set_visible(tab == 4)
    menu.misc.trash_talk:set_visible(tab == 4)
    menu.misc.clearcons:set_visible(tab == 4)
    menu.misc.animation:set_visible(tab == 4)
    menu.misc.animation_legs:set_visible(tab == 4 and menu.misc.animation:get())
    menu.misc.animation_air:set_visible(tab == 4 and menu.misc.animation:get())
    menu.misc.animation_movelean:set_visible(tab == 4 and menu.misc.animation:get())
    menu.misc.animation_eatherquake:set_visible(tab == 4 and menu.misc.animation:get())
end

function viewmodels()
    FOV = menu.visuals.vS:get()
    X = menu.visuals.xS:get() / 10
    Y = menu.visuals.yS:get() / 10
    Z = menu.visuals.zS:get() / 10
    if menu.visuals.viewmodels:get() then
        client.set_cvar("viewmodel_fov", FOV)
        client.set_cvar("viewmodel_offset_x", X)
        client.set_cvar("viewmodel_offset_y", Y)
        client.set_cvar("viewmodel_offset_z", Z)
    else
        client.set_cvar("viewmodel_fov", 68)
        client.set_cvar("viewmodel_offset_x", 2.5)
        client.set_cvar("viewmodel_offset_y", 0)
        client.set_cvar("viewmodel_offset_z", -1.5)
    end
end

local shot_logger = {}

shot_logger.add = function(...)
    args = { ... }
    len = #args
    for i = 1, len do
        arg = args[i]
        r, g, b = unpack(arg)

        msg = {}

        if #arg == 3 then
            table.insert(msg, " ")
        else
            for i = 4, #arg do
                table.insert(msg, arg[i])
            end
        end
        msg = table.concat(msg)

        if len > i then
            msg = msg .. "\0"
        end

        client.color_log(r, g, b, msg)
    end
end




shot_logger.bullet_impacts = {}
shot_logger.bullet_impact = function(e)
    local tick = globals.tickcount()
    local me = entity.get_local_player()
    local user = client.userid_to_entindex(e.userid)

    if user ~= me then
        return
    end

    if #shot_logger.bullet_impacts > 150 then
        shot_logger.bullet_impacts = {}
    end

    shot_logger.bullet_impacts[#shot_logger.bullet_impacts + 1] = {
        tick = tick,
        eye = vector(client.eye_position()),
        shot = vector(e.x, e.y, e.z)
    }
end

shot_logger.get_inaccuracy_tick = function(pre_data, tick)
    local spread_angle = -1
    for k, impact in pairs(shot_logger.bullet_impacts) do
        if impact.tick == tick then
            local aim, shot =
                (pre_data.eye - pre_data.shot_pos):angles(),
                (pre_data.eye - impact.shot):angles()

            spread_angle = vector(aim - shot):length2d()
            break
        end
    end

    return spread_angle
end

shot_logger.get_safety = function(aim_data, target)
    local has_been_boosted = aim_data.boosted
    local plist_safety = plist.get(target, 'Override safe point')
    local ui_safety = { ui.get(ref.prefesafepoint), ui.get(ref.safepoint) or plist_safety == 'On' }

    if not has_been_boosted then
        return -1
    end

    if plist_safety == 'Off' or not (ui_safety[1] or ui_safety[2]) then
        return 0
    end

    return ui_safety[2] and 2 or (ui_safety[1] and 1 or 0)
end

shot_logger.generate_flags = function(pre_data)
    return {
        pre_data.self_choke > 1 and 1 or 0,
        pre_data.velocity_modifier < 1.00 and 1 or 0,
        pre_data.flags.boosted and 1 or 0
    }
end

shot_logger.hitboxes = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck",
    "?", "gear" }
shot_logger.on_aim_fire = function(e)
    local p_ent = e.target
    local me = entity.get_local_player()

    shot_logger[e.id] = {
        original = e,
        dropped_packets = {},

        handle_time = globals.realtime(),
        self_choke = globals.chokedcommands(),

        flags = {
            boosted = e.boosted
        },

        feet_yaw = entity.get_prop(p_ent, 'm_flPoseParameter', 11) * 120 - 60,
        correction = plist.get(p_ent, 'Correction active'),

        safety = shot_logger.get_safety(e, p_ent),
        shot_pos = vector(e.x, e.y, e.z),
        eye = vector(client.eye_position()),
        view = vector(client.camera_angles()),

        velocity_modifier = entity.get_prop(me, 'm_flVelocityModifier'),
        total_hits = entity.get_prop(me, 'm_totalHitsOnServer'),

        history = globals.tickcount() - e.tick
    }
end

shot_logger.max_lerp_low_fps = (1 / 45) * 100
shot_logger.lerp = function(start, end_pos, time)
    if start == end_pos then
        return end_pos
    end

    local frametime = globals.frametime() * 170
    time = time * math.min(frametime, shot_logger.max_lerp_low_fps)

    local val = start + (end_pos - start) * math.clamp(time, 0.01, 1)

    if (math.abs(val - end_pos) < 0.01) then
        return end_pos
    end

    return val
end

shot_logger.rec = function(x, y, w, h, radius, color)
    radius = math.min(x / 2, y / 2, radius)
    local r, g, b, a = unpack(color)
    renderer.rectangle(x, y + radius, w, h - radius * 2, r, g, b, a)
    renderer.rectangle(x + radius, y, w - radius * 2, radius, r, g, b, a)
    renderer.rectangle(x + radius, y + h - radius, w - radius * 2, radius, r, g, b, a)
    renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
    renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
    renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
    renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
end

shot_logger.rec_outline = function(x, y, w, h, radius, thickness, color)
    radius = math.min(w / 2, h / 2, radius)
    local r, g, b, a = unpack(color)
    if radius == 1 then
        renderer.rectangle(x, y, w, thickness, r, g, b, a)
        renderer.rectangle(x, y + h - thickness, w, thickness, r, g, b, a)
    else
        renderer.rectangle(x + radius, y, w - radius * 2, thickness, r, g, b, a)
        renderer.rectangle(x + radius, y + h - thickness, w - radius * 2, thickness, r, g, b, a)
        renderer.rectangle(x, y + radius, thickness, h - radius * 2, r, g, b, a)
        renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius * 2, r, g, b, a)
        renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
        renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
        renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
        renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
    end
end

shot_logger.glow_module = function(x, y, w, h, width, rounding, accent, accent_inner)
    local thickness = 1
    local offset = 1
    local r, g, b, a = unpack(accent)

    if accent_inner then
        shot_logger.rec(x, y, w, h + 1, rounding, accent_inner)
    end

    for k = 0, width do
        if a * (k / width) ^ (1) > 5 then
            local accent = { r, g, b, a * (k / width) ^ (2) }

            shot_logger.rec_outline(x + (k - width - offset) * thickness, y + (k - width - offset) * thickness,
                w - (k - width - offset) * thickness * 2, h + 1 - (k - width - offset) * thickness * 2,
                rounding + thickness * (width - k + offset), thickness, accent)
        end
    end
end

shot_logger.aimbot_logs = {}

local png = images.load_png(readfile('night.png'))

function shot_logger.notifications()
    if not menu.visuals.aimbot_logs:get("~screen") then return end
    for i, logs in ipairs(shot_logger.aimbot_logs) do
        if logs.time + 1 > globals.realtime() and i <= 5 then
            logs.alpha = shot_logger.lerp(logs.alpha, 255, 0.05)
            logs.alpha_text = shot_logger.lerp(logs.alpha_text, 255, 0.05)
            logs.add_x = shot_logger.lerp(logs.add_x, 1, 0.05)
        end

        local string = tostring(logs.text)
        local size = renderer.measure_text("", string)

        if logs.alpha <= 0 then
            logs[i] = nil
        else
            logs.add_y = shot_logger.lerp(logs.add_y, i * 40, 0.05)

            shot_logger.glow_module(x / 2 - size / 2 - 12, y - 68 - logs.add_y, size + 34, 25, 17, 7,
                { logs.color[1], logs.color[2], logs.color[3], logs.alpha * 0.33 },
                { logs.color[1], logs.color[2], logs.color[3], logs.alpha * 0.33 })
            shot_logger.rec(x / 2 - size / 2 - 12, y - 68 - logs.add_y, size + 34, 25, 7,
                { 10, 10, 10, logs.alpha * 0.7 })


            local box_x = x / 2 - size / 2 - 12
            local box_y = y - 68 - logs.add_y
            png:draw(box_x + 5, box_y + 5, 15, 15, logs.color[1], logs.color[2], logs.color[3], logs.alpha)

            renderer.text(x / 2 + 15, y - 56 - logs.add_y, 255, 255, 255, logs.alpha_text, "c", 0, logs.text)

            if logs.time + 3 < globals.realtime() or i > 5 then
                logs.alpha = shot_logger.lerp(logs.alpha, 0, 0.05)
                logs.alpha_text = shot_logger.lerp(logs.alpha_text, 0, 0.05)
                logs.add_x = shot_logger.lerp(logs.add_x, 0, 0.05)
                logs.add_y = shot_logger.lerp(logs.add_y, i * 60, 0.05)
            end
        end

        if logs.alpha < 1 then
            table.remove(shot_logger.aimbot_logs, i)
        end
    end
end

shot_logger.on_aim_hit = function(e)
    if shot_logger[e.id] == nil then
        return
    end

    local info =
    {
        type = math.max(0, entity.get_prop(e.target, 'm_iHealth')) > 0,
        prefix = { menu.visuals.aimbot_logs_hit:get() },
        hit = { menu.visuals.aimbot_logs_hit:get() },
        name = entity.get_player_name(e.target),
        hitgroup = shot_logger.hitboxes[e.hitgroup + 1] or '?',
        flags = string.format('%s', table.concat(shot_logger.generate_flags(shot_logger[e.id]))),
        aimed_hitgroup = shot_logger.hitboxes[shot_logger[e.id].original.hitgroup + 1] or '?',
        aimed_hitchance = string.format('%d%%', math.floor(shot_logger[e.id].original.hit_chance + 0.5)),
        hp = math.max(0, entity.get_prop(e.target, 'm_iHealth')),
        spread_angle = string.format('%.2f°', shot_logger.get_inaccuracy_tick(shot_logger[e.id], globals.tickcount())),
        correction = string.format('%d:%d°', shot_logger[e.id].correction and 1 or 0,
            (shot_logger[e.id].feet_yaw < 10 and shot_logger[e.id].feet_yaw > -10) and 0 or shot_logger[e.id].feet_yaw)
    }

    local r, g, b, a = menu.visuals.aimbot_logs_hit:get()

    if menu.visuals.aimbot_logs:get("~screen") then
        table.insert(shot_logger.aimbot_logs, 1, {
            text = string.format("Hit %s in the %s for %s damage", info.name, info.hitgroup, e.damage),
            alpha = 0,
            alpha_text = 0,
            add_x = 0,
            add_y = 1,
            time = globals.realtime(),
            color = { r, g, b, a }
        })
    else
        shot_logger.aimbot_logs = {}
    end
    if menu.visuals.aimbot_logs:get("~console") then
        shot_logger.add({ info.prefix[1], info.prefix[2], info.prefix[3], '[night]' },
            { 134, 134, 134, ' » ' },
            { 200, 200, 200, info.type and 'damaged ' or 'killed ' },
            { info.hit[1], info.hit[2], info.hit[3], info.name },
            { 200, 200, 200, ' in the ' },
            { info.hit[1], info.hit[2], info.hit[3], info.hitgroup },
            { 200, 200, 200, info.type and info.hitgroup ~= info.aimed_hitgroup and ' (' or '' },
            { info.hit[1], info.hit[2], info.hit[3], info.type and
            (info.hitgroup ~= info.aimed_hitgroup and info.aimed_hitgroup) or '' },
            { 200, 200, 200, info.type and info.hitgroup ~= info.aimed_hitgroup and ')' or '' },
            { 200, 200, 200, info.type and ' for ' or '' },
            { info.hit[1], info.hit[2], info.hit[3], info.type and e.damage or '' },
            { 200, 200, 200, info.type and e.damage ~= shot_logger[e.id].original.damage and ' (' or '' },
            { info.hit[1], info.hit[2], info.hit[3], info.type and
            (e.damage ~= shot_logger[e.id].original.damage and shot_logger[e.id].original.damage) or '' },
            { 200, 200, 200, info.type and e.damage ~= shot_logger[e.id].original.damage and ')' or '' },
            { 200, 200, 200, info.type and ' damage' or '' },
            { 200, 200, 200, info.type and ' (' or '' },
            { info.hit[1], info.hit[2], info.hit[3], info.type and info.hp or '' },
            { 200, 200, 200, info.type and ' hp remaning)' or '' },
            { 200, 200, 200, ' [' }, { info.hit[1], info.hit[2], info.hit[3], info.spread_angle },
            { 200, 200, 200, ' | ' }, { info.hit[1], info.hit[2], info.hit[3], info.correction }, { 200, 200, 200, ']' },
            { 200, 200, 200, ' (hc: ' }, { info.hit[1], info.hit[2], info.hit[3], info.aimed_hitchance },
            { 200, 200, 200, ' | safety: ' }, { info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].safety },
            { 200, 200, 200, ' | history(Δ): ' }, { info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].history },
            { 200, 200, 200, ' | flags: ' }, { info.hit[1], info.hit[2], info.hit[3], info.flags },
            { 200, 200, 200, ')' })
    end
end

shot_logger.on_aim_miss = function(e)
    local me = entity.get_local_player()
    local info =
    {
        prefix = { menu.visuals.aimbot_logs_miss:get() },
        hit = { menu.visuals.aimbot_logs_miss:get() },
        name = entity.get_player_name(e.target),
        hitgroup = shot_logger.hitboxes[e.hitgroup + 1] or '?',
        flags = string.format('%s', table.concat(shot_logger.generate_flags(shot_logger[e.id]))),
        aimed_hitgroup = shot_logger.hitboxes[shot_logger[e.id].original.hitgroup + 1] or '?',
        aimed_hitchance = string.format('%d%%', math.floor(shot_logger[e.id].original.hit_chance + 0.5)),
        hp = math.max(0, entity.get_prop(e.target, 'm_iHealth')),
        reason = e.reason,
        spread_angle = string.format('%.2f°', shot_logger.get_inaccuracy_tick(shot_logger[e.id], globals.tickcount())),
        correction = string.format('%d:%d°', shot_logger[e.id].correction and 1 or 0,
            (shot_logger[e.id].feet_yaw < 10 and shot_logger[e.id].feet_yaw > -10) and 0 or shot_logger[e.id].feet_yaw)
    }

    if info.reason == '?' then
        info.reason = 'unknown';

        if shot_logger[e.id].total_hits ~= entity.get_prop(me, 'm_totalHitsOnServer') then
            info.reason = 'damage rejection';
        end
    end

    local r, g, b, a = menu.visuals.aimbot_logs_miss:get()

    if menu.visuals.aimbot_logs:get("~screen") then
        table.insert(shot_logger.aimbot_logs, 1, {
            text = string.format("Missed shot due to %s at %s in the %s", info.reason, info.name, info.hitgroup),
            alpha = 0,
            alpha_text = 0,
            add_x = 0,
            add_y = 1,
            time = globals.realtime(),
            color = { r, g, b, a }
        })
    else
        shot_logger.aimbot_logs = {}
    end
    if menu.visuals.aimbot_logs:get("~console") then
        shot_logger.add({ info.prefix[1], info.prefix[2], info.prefix[3], '[night]' },
            { 134, 134, 134, ' » ' },
            { 200, 200, 200, 'missed shot at ' },
            { info.hit[1], info.hit[2], info.hit[3], info.name },
            { 200, 200, 200, ' in the ' },
            { info.hit[1], info.hit[2], info.hit[3], info.hitgroup },
            { 200, 200, 200, ' due to ' },
            { info.hit[1], info.hit[2], info.hit[3], info.reason },
            { 200, 200, 200, ' [' }, { info.hit[1], info.hit[2], info.hit[3], info.spread_angle },
            { 200, 200, 200, ' | ' }, { info.hit[1], info.hit[2], info.hit[3], info.correction }, { 200, 200, 200, ']' },
            { 200, 200, 200, ' (hc: ' }, { info.hit[1], info.hit[2], info.hit[3], info.aimed_hitchance },
            { 200, 200, 200, ' | safety: ' }, { info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].safety },
            { 200, 200, 200, ' | history(Δ): ' }, { info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].history },
            { 200, 200, 200, ' | flags: ' }, { info.hit[1], info.hit[2], info.hit[3], info.flags },
            { 200, 200, 200, ')' })
    end
end

function config_system.get(name)
    local database = database.read(protected.database.configs) or {}

    for i, v in pairs(database) do
        if v.name == name then
            return {
                config = v.config,
                config2 = v.config2,
                index = i
            }
        end
    end

    for i, v in pairs(presets) do
        if v.name == name then
            return {
                config = v.config,
                config2 = v.config2,
                index = i
            }
        end
    end

    return false
end

local indicators_list = {
    {
        name = 'dt',
        anim = create_animation(0),
        sub = '',
        get = function() return ui.get(ref.dt[1]) and ui.get(ref.dt[2]) end
    },
    {
        name = 'hs',
        anim = create_animation(0),
        sub = '',
        get = function() return ui.get(ref.os[1]) and ui.get(ref.os[2]) and not (ui.get(ref.dt[1]) and ui.get(ref.dt[2])) end
    },
    {
        name = 'dmg',
        anim = create_animation(0),
        sub = '',
        get = function() return ui.get(ref.minimum_damage_override[2]) end
    },
    {
        name = 'baim',
        anim = create_animation(0),
        sub = '',
        get = function() return ui.get(ref.forcebaim) end
    },
    {
        name = 'fs',
        anim = create_animation(0),
        sub = '',
        get = function() return ui.get(ref.autopeek[2]) and ui.get(ref.freestand[2]) end
    }
}

local scoped_space = 0
local y_add = 0

to_hex2 = function(r, g, b, a)
    return string.format("%02x%02x%02x%02x", r, g, b, a) -- ARGB
end

breath2 = function(x)
    x = x % 2.0
    if x > 1.0 then
        x = 2.0 - x
    end
    return x
end

gradient_text2 = function(s, clock, r1, g1, b1, a1, r2, g2, b2, a2)
    local buffer = {}

    local len = #string.gsub(s, "[\128-\191]", "")
    local div
    if len <= 1 then
        div = 0
    else
        div = 1 / (len - 1)
    end

    local add_r = r2 - r1
    local add_g = g2 - g1
    local add_b = b2 - b1
    local add_a = a2 - a1

    for char in string.gmatch(s, ".[\128-\191]*") do
        local t = breath2(clock)

        local r = r1 + add_r * t
        local g = g1 + add_g * t
        local b = b1 + add_b * t
        local a = a1 + add_a * t

        buffer[#buffer + 1] = "\a"
        buffer[#buffer + 1] = to_hex2(r, g, b, a)
        buffer[#buffer + 1] = char

        clock = clock - div
    end

    return table.concat(buffer)
end

function crosshair()
    if not menu.visuals.crosshair:get() then return end

    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return end

    local r, g, b = menu.visuals.crosshair_color:get()
    local x, y = client.screen_size()
    local scpd = entity.get_prop(lp, "m_bIsScoped") == 1

    local y_offset = menu.visuals.cross_offset:get()

    scoped_space = math.lerp2(scoped_space, scpd and 35 or 0, 10)
    if menu.visuals.crosshair_style:get() == "~static" then
        renderer.text(x * 0.5 + scoped_space, y * 0.5 + 4.5 + y_offset, r, g, b, 255, 'cbd', nil, 'night.project')
    elseif menu.visuals.crosshair_style:get() == "~gradient" then
        renderer.text(x * 0.5 + scoped_space, y * 0.5 + 4.5 + y_offset, r, g, b, 255, 'cbd', nil,
            gradient_text2('night.project', globals.curtime() * 0.8, r, g, b, 255, 255, 255, 255, 255))
    end

    local movement_texts = {
        [1] = "~share~",
        [2] = "~stand~",
        [3] = "~run~",
        [4] = "~walk~",
        [5] = "~air~",
        [6] = "~airc~",
        [7] = "~crouch~",
        [8] = "~sneak~"
    }

    if movement_texts[id] then
        renderer.text(x * 0.5 + scoped_space + (id >= 5 and -2 or -1),
            y * 0.5 + 14 + y_offset, 255, 255, 255, 255, "cd", nil, movement_texts[id])
    end

    y_add = 0
    for i, element in ipairs(indicators_list) do
        local anim_value = element.anim(0.07, element.get() and 1 or 0)
        element.sub = string.sub(element.name, 1, math.floor(#element.name * anim_value))

        if anim_value > 0 then
            renderer.text(x * 0.5 - 2 + scoped_space, y * 0.5 + 24 + y_offset + y_add,
                255, 255, 255, 255 * anim_value, 'cd', nil, element.sub)
            y_add = y_add + 10 * anim_value
        end
    end
    if menu.visuals.crosshair_customind:get() and menu.visuals.crosshair_style:get() == "~static" then
        renderer.text(x * 0.5 + scoped_space + 1, y * 0.5 - 4.4 + y_offset, 255, 255, 255, 255, 'cd', nil,
            '  ⛧°. ⋆༺♱༻⋆. °⛧   ')
    elseif menu.visuals.crosshair_customind:get() and menu.visuals.crosshair_style:get() == "~gradient" then
        renderer.text(x * 0.5 + scoped_space + 1, y * 0.5 - 4.4 + y_offset, 255, 255, 255, 255, 'cd', nil,
            gradient_text2('  ⛧°. ⋆༺♱༻⋆. °⛧   ', globals.curtime() * 0.4, r, g, b, 255, 255, 255, 255, 255))
    end
end

to_hex = function(r, g, b, a)
    return string.format("%02x%02x%02x%02x", r, g, b, a or 255)
end
breath = function(x)
    x = x % 2.0

    if x > 1.0 then
        x = 2.0 - x
    end

    return x
end

math.exploit = function()
    local me = entity.get_local_player()
    if not me then return end
    local tickcount = globals.tickcount()
    local tickbase = entity.get_prop(me, 'm_nTickBase')
    return tickcount > tickbase
end

local mathematic = {}

mathematic.clamp = function(value, minimum, maximum)
    assert(value and minimum and maximum, '')
    if minimum > maximum then minimum, maximum = maximum, minimum end
    return math.max(minimum, math.min(maximum, value))
end

mathematic.interpolation = function(start, _end, time)
    return (_end - start) * time + start
end

mathematic.lerp = function(start, _end, time)
    time = time or 0.005
    time = mathematic.clamp(globals.frametime() * time * 175.0, 0.01, 1.0)
    local a = mathematic.interpolation(start, _end, time)
    if _end == 0.0 and a < 0.01 and a > -0.01 then
        a = 0.0
    elseif _end == 1.0 and a < 1.01 and a > 0.99 then
        a = 1.0
    end
    return a
end
function mathematic.lerp_color(r1, g1, b1, a1, r2, g2, b2, a2, t)
    local r = mathematic.lerp(r1, r2, t)
    local g = mathematic.lerp(g1, g2, t)
    local b = mathematic.lerp(b1, b2, t)
    local a = mathematic.lerp(a1, a2, t)

    return r, g, b, a
end

local lua = {}

lua.render = {}
do
    lua.render.lni = {
        center = {
            f = 0
        }
    }

    local function add_bind(icon, name, ref, gradient_fn, enabled_color, disabled_color)
        enabled_color = {
            [1] = 230,
            [2] = 230,
            [3] = 230,
            [4] = 230
        }
        disabled_color = {
            [1] = 155,
            [2] = 155,
            [3] = 155,
            [4] = 0
        }
        lua.render.indicators_table.binds[#lua.render.indicators_table.binds + 1] = {
            icon = string.sub(icon, 1, 2),
            full_icon =
                icon,
            name = string.sub(name, 1, 2),
            full_name = name,
            ref = ref,
            color = disabled_color,
            enabled_color =
                enabled_color,
            disabled_color = disabled_color,
            chars = 0,
            alpha = 0,
            gradient_progress = 0,
            gradient_fn =
                gradient_fn
        }
    end

    lua.render.indicators_table = {}
    lua.render.indicators_table.binds = {}
    add_bind('⛊ ', 'EJ', ref1.edge_jump[1].hotkey)
    add_bind(' ', 'FS', menu.antiaim.manuals_freestanding)
    add_bind(' ', 'MD', ref1.minimum_damage_override[1].hotkey)
    add_bind(' ', 'BODY', ref1.body_aim)
    add_bind(' ', 'SAFE', ref1.safe_point)
    add_bind(' ', 'DT', ref1.double_tap[1].hotkey)
    add_bind(' ', 'HS', ref1.on_shot_anti_aim[1].hotkey)
    add_bind(' ', 'DUCK', ref1.fakeduck)
    add_bind(' ', 'PING', ref1.ping[1].hotkey)

    local add_gamesense_text = function(x, y, r, g, b, a, re, ge, be, ae, icon, text, i_alpha, alpha)
        if alpha == nil then
            alpha = 1
        end

        if alpha <= 0 then
            return
        end

        local icon_wh = vector(render.measure_text('+', icon))
        local text_wh = vector(render.measure_text('+', text))

        local screen = { client.screen_size() }

        local width_ind = math.floor(text_wh.x / 2)
        local y = y + screen[2] / 2 + 50
        render.gradient(4, y + text_wh.y, width_ind + 24, text_wh.y + 4, 5, 5, 5, 0, 5, 5, 5, 55 * alpha, true)
        render.gradient(28 + width_ind, y + text_wh.y, 29 + width_ind, text_wh.y + 4, 5, 5, 5, 55 * alpha, 5, 5, 5, 0,
            true)

        render.text(x * alpha, y + icon_wh.y, re, ge, be, ae * i_alpha, '+', nil, icon)

        render.text(x + icon_wh.x * i_alpha, y + icon_wh.y + 1, r, g, b, a, '+', nil, text)

        lua.render.indicators_table.y = lua.render.indicators_table.y + 40 * alpha
    end

    lua.render.gamesense = function()
        lua.render.lni.center.f = mathematic.lerp(lua.render.lni.center.f, math.exploit() and 1 or 0, 0.03)
        local me = entity.get_local_player()
        if not me then return end
        lua.render.indicators_table.y = 15
        for index, bind in ipairs(lua.render.indicators_table.binds) do
            local alpha = mathematic.lerp(bind.alpha, entity.is_alive(me) and bind.ref:get() and 1 or 0.0, 0.05)
            local chars = mathematic.lerp(bind.chars, entity.is_alive(me) and bind.ref:get() and 1 or 0.0, 0.05)
            local n, y, k, w = menu.visuals.custom_gs_color:get()
            local r, g, b, a = mathematic.lerp_color(n, y, k, 255, n, y, k, 255, alpha)
            local icon = bind.full_icon
            local name = bind.full_name
            local clr = { r, g, b, 255 }

            if name == 'DT' then
                icon = lua.render.lni.center.f > .3 and ' ' or ' '
                clr = {
                    [1] = r,
                    [2] = g * lua.render.lni.center.f,
                    [3] = b * lua.render.lni.center.f,
                    [4] = 255
                }
            end

            add_gamesense_text(10, lua.render.indicators_table.y, clr[1], clr[2], clr[3], clr[4] * alpha, clr[1], clr[2],
                clr[3], clr[4] * alpha, icon, name, chars, alpha)
            lua.render.indicators_table.binds[index].alpha = alpha
            lua.render.indicators_table.binds[index].name = name
            lua.render.indicators_table.binds[index].chars = chars
            lua.render.indicators_table.binds[index].color = r, g, b, a
        end
    end
end

menu.visuals.custom_gs_ind:set_callback(function(self)
    if self:get() then
        client.set_event_callback("indicator", lua.render.gamesense)
    else
        client.unset_event_callback("indicator", lua.render.gamesense)
    end
end)

menu.visuals.custom_gs_ind:set_event("paint_ui", lua.render.gamesense)

gradient_text = function(s, clock, r1, g1, b1, a1, r2, g2, b2, a2)
    local buffer = {}

    local len = #string.gsub(s, "[\128-\191]", "")
    local div = 1 / (len - 1)

    local add_r = r2 - r1
    local add_g = g2 - g1
    local add_b = b2 - b1
    local add_a = a2 - a1

    for char in string.gmatch(s, ".[\128-\191]*") do
        local t = breath(clock)

        local r = r1 + add_r * t
        local g = g1 + add_g * t
        local b = b1 + add_b * t
        local a = a1 + add_a * t

        buffer[#buffer + 1] = "\a"
        buffer[#buffer + 1] = to_hex(r, g, b, a)
        buffer[#buffer + 1] = char

        clock = clock - div
    end

    return table.concat(buffer)
end

local name = panorama.open().MyPersonaAPI.GetName()
function watermark()
    local r, g, b, a = menu.visuals.watermark_visuals:get()
    local text2 = strange('night.project', globals.curtime() * 6)
    if menu.visuals.watermark:get() == '~basic' then
        local text = gradient_text(text2, globals.curtime(), r, g, b, 255, 155,
            155, 155, 200)
        local tx, ty = renderer.measure_text('cdb',
            string.format('%s\a%s %s', text, to_hex(r, g, b, 200), ''))
        renderer.text(x - tx / -100 - 990, y / 1.015, r, g, b, 200, 'cdb', nil,
            string.format('%s\a%s %s', text, to_hex(r, g, b, 200), ''))
        local text = gradient_text('', globals.curtime(), r, g, b, 255, 155,
            155, 155, 200)
        local tx, ty = renderer.measure_text('cd',
            string.format('%s\a%s %s', text, to_hex(r, g, b, 200), ''))
        renderer.text(x - tx / -99 - 993, y / 1.025, r, g, b, 10000, 'cdb', nil,
            string.format('%s\a%s %s', text, to_hex(r, g, b, 200), '☆☆☆'))
    end
    if menu.visuals.watermark:get() == '~gradient' then
        local text = gradient_text('N I G H T', globals.curtime(), r, g, b, 255, 155,
            155, 155, 200)
        local tx, ty = renderer.measure_text('cd',
            string.format('%s\a%s %s', text, to_hex(r, g, b, 200), '[DEBUG]'))
        renderer.text(x - tx / 2 - 1824, y / 2, r, g, b, 200, 'cd', nil,
            string.format('%s\a%s %s', text, to_hex(r, g, b, 200), '[DEBUG]'))
    end
    if menu.visuals.watermark:get() == '~modern' then
        local png = images.load_png(readfile('night.png'))
        local text = gradient_text('debug', globals.realtime(), r, g, b, 255, 155,
            155, 155, 200):upper()
        png:draw(15, y / 2 + 15, 25, 25, r, g, b)
        renderer.text(45, y / 2 + 20, 255, 255, 255, 200, '-', nil,
            string.format('night.project [%s\aFFFFFFFF]', text):upper())
        renderer.text(45, y / 2 + 28, 255, 255, 255, 200, '-', nil, string.format('user: %s', name):upper())
    end
end

local m_alpha = 0
function scope()
    if not menu.visuals.scope_overlay:get() then return end
    ui.set(ref.scope_overlay, false)

    local offset, initial_position, speed, color =
        menu.visuals.scope_gap:get() * y / 1080,
        menu.visuals.scope_size:get() * y / 1080,
        menu.visuals.scope_animation:get(), { menu.visuals.scope_color:get() }

    local me = entity.get_local_player()
    local wpn = entity.get_player_weapon(me)

    local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
    local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
    local resume_zoom = entity.get_prop(me, 'm_bResumeZoom') == 1

    local is_valid = entity.is_alive(me) and wpn ~= nil and scope_level ~= nil
    local act = is_valid and scope_level > 0 and scoped and not resume_zoom

    local FT = speed > 3 and globals.frametime() * speed or 1
    local alpha = easing1.linear(m_alpha, 0, 1, 1)

    renderer.gradient(x / 2 - initial_position + 2, y / 2, initial_position - offset, 1, color[1], color[2], color[3], 0,
        color[1], color[2], color[3], alpha * color[4], true)
    renderer.gradient(x / 2 + offset, y / 2, initial_position - offset, 1, color[1], color[2], color[3], alpha * color
        [4], color[1], color[2], color[3], 0, true)
    renderer.gradient(x / 2, y / 2 - initial_position + 2, 1, initial_position - offset, color[1], color[2], color[3], 0,
        color[1], color[2], color[3], alpha * color[4], false)
    renderer.gradient(x / 2, y / 2 + offset, 1, initial_position - offset, color[1], color[2], color[3], alpha * color
        [4], color[1], color[2], color[3], 0, false)
    m_alpha = clamp(m_alpha + (act and FT or -FT), 0, 1)
end

client.set_event_callback('grenade_thrown', function(e)
    if menu.misc.quick_switch:get() then
        local lp = entity.get_local_player();
        local userid = client.userid_to_entindex(e.userid);

        if userid ~= lp then
            return
        end

        client.exec('slot3; slot2; slot1');
    end
end);

client.set_event_callback('weapon_fire', function(e)
    if menu.misc.quick_switch:get() then
        if e.weapon ~= 'weapon_taser' then
            return
        end

        local lp = entity.get_local_player();
        local userid = client.userid_to_entindex(e.userid);

        if userid ~= lp then
            return
        end

        client.exec('slot3; slot2; slot1');
    end
end);


local ref32 = {
    minimum_damage = ui.reference("rage", "aimbot", "minimum damage")
}

local current_damage = 0
local animation_speed = 20

local png = images.load_png(readfile('night.png'))

local w, h = client.screen_size()
local alpha = 69
local toggled = false
-- client.set_event_callback("paint_ui", LPH_NO_VIRTUALIZE(function()
--     local png = images.load_png(readfile('nightaaa.png'))
--     if alpha > 0.1 and toggled then
--         if alpha == 169 then
--         end
--         alpha = alpha - 0.3
--     else
--         if not toggled then
--             alpha = alpha + 1
--             if alpha == 254 then
--                 toggled = true
--             end
--             alpha = alpha + 1
--         end
--     end
--     if alpha > 1 then
--         renderer.gradient(0, 0, w, h, 0, 0, 0, alpha, 0, 0, 0, alpha, true)
--         png:draw(x - 1150, y -900 + 25, 350, 390, r, g, b, alpha)
--     end
-- end))

function predict_keyaa()
    if not menu.misc.predict:get() then return end
    if not menu.misc.predict_key:get() then return end
    local idx = client.current_threat()
    if not entity.is_alive(idx) then return end
    if not entity.is_alive(entity.get_local_player()) then return end
    renderer.indicator(255, 255, 255, 255, "♰ Predict ")
end

local strafer = pui.reference('MISC', 'Movement', 'Air strafe')
local function jumpscout1(cmd)
    if menu.misc.jumpscout1:get() then
        local vel = vector(entity.get_prop(entity.get_local_player(), "m_vecVelocity")):length2d()
        --ui_set(aa_refs.air_strafe, not (cmd.in_jump and (vel < 10)) or ui_is_menu_open())
        strafer:override(vel > 35)
    end
end

client.set_event_callback('setup_command', function(cmd)
    jumpscout1(cmd)
end)
function damage()
    if not menu.visuals.damage_ind:get() then return end
    local local_player = entity.get_local_player()
    if not entity.is_alive(local_player) then return end
    local damage = ui.get(ref32.minimum_damage)
    local override_active = ui.get(ref.minimum_damage_override[2])

    local target_damage = damage
    if override_active then
        target_damage = ui.get(ref.minimum_damage_override[3])
    end

    if math.abs(current_damage - target_damage) > 0.1 then
        current_damage = current_damage + (target_damage - current_damage) / animation_speed
    else
        current_damage = target_damage
    end

    local displayed_damage = math.floor(current_damage + 0.5)
    renderer.text(x * 0.5 + 10, y * 0.5 + -12, 255, 255, 255, 225, "d", 0, displayed_damage .. "")
end

function g_paint_ui()
    if not menu.visuals.scope_overlay:get() then return end
    ui.set(ref.scope_overlay, true)
end

function active_target()
    if not menu.visuals.target_active:get() then return end
    if not menu.misc.resolver:get() then return end
    local idx = client.current_threat()
    local name = entity.get_player_name(idx)
    if not entity.is_alive(idx) then return end
    if not entity.is_alive(entity.get_local_player()) then return end
    renderer.indicator(255, 255, 255, 255, "Resolved: " .. name)
end

local function hideshots1()
    if menu.misc.hideshots1:get() then
        if ({ ref1.on_shot_anti_aim[1]:get_hotkey() })[1] then
            ui.set(binds_fakelag.fakelag_limit, 1)
        else
            ui.set(binds_fakelag.fakelag_limit, 15)
        end
    end
end
client.set_event_callback('setup_command', function()
    hideshots1()
end)

local tag = {
    'night.lua',
    'night.lu',
    'night.l',
    'night.',
    'night',
    'nigh',
    'nig',
    'ni',
    'n',
    '',
    'n',
    'ni',
    'nig',
    'nigh',
    'night',
    'night.',
    'night.l',
    'night.lu',
    'night.lua',
}

local function handle_aspect_ratio()
    local aspect_ratio = menu.misc.aspectratio:get()
        and menu.misc.aspectratio_value:get() / 25
        or 0
    aspectratio(aspect_ratio)
end

function aspectratio(value)
    if value then
        cvar.r_aspectratio:set_float(value)
    end
end

function clantag(e)
    local local_player = entity.get_local_player()
    if not local_player then return end
    local can_reset = true
    if menu.misc.clantag:get() then
        can_reset = false
        local realtime = math.floor((globals.curtime()) * 2.5)
        if old_time ~= realtime then
            client.set_clan_tag(tag[realtime % #tag + 1])
            old_time = realtime;
        end
    else
        can_reset = true
        local realtime = math.floor((globals.curtime()) * 0)
        if old_time ~= realtime then
            if can_reset then
                old_time = realtime;
                client.set_clan_tag('')
                can_reset = false
            end
        end
    end
end

local queue = {}
client.set_event_callback("bullet_impact", function(e)
    if not menu.visuals.bullet_tracers:get() then return end
    if client.userid_to_entindex(e.userid) ~= entity.get_local_player() then
        return
    end
    local lx, ly, lz = client.eye_position()
    queue[globals.tickcount()] = { lx, ly, lz, e.x, e.y, e.z, globals.curtime() + 2 }
end)

client.set_event_callback("paint", function()
    if not menu.visuals.bullet_tracers:get() then return end
    for tick, data in pairs(queue) do
        if globals.curtime() <= data[7] then
            local x1, y1 = renderer.world_to_screen(data[1], data[2], data[3])
            local x2, y2 = renderer.world_to_screen(data[4], data[5], data[6])
            if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
                renderer.line(x1, y1, x2, y2, 255, 255, 255, 255)
            end
        end
    end
end)
client.set_event_callback("round_prestart", function()
    queue = {}
end)

local killsays = { 'С какими словами на хай садился',
    'Что ты с языком на хуе',
    'Какой провокацией в рот ебан',
    'У тебя хуй во рту',
    'Как мать опередил?',
    'С хуя ты',
    'Скажи с хуя',
    'На какую провокацию у тебя отец пидор',
    'какой провокацией мать убил',
    'С языка матери сними сперму провокацией',
    'Кому говорю когда мать оппонента трахаю',
    'Ты мне с хуя ответил',
    'Отец твой с хуя ответил',
    'Все ты',
    'Пародируй ебыря',
    'Отрицай зеркалом еблю матери',
    'Скажи себе',
    'Скажи отцу',
    'Скажи матери',
    'Скажи зеркалу',
    'Кто ебал тебя',
    'На какую провокацию мой оппонент себе хуй в рот сует',
    'Бабку словом убей',
    'Молчанием прими хуй в рот',
    'Скажи словами пидора',
    'Словами хуй прими',
    'Что ты с языком на очке',
    'Какими определениями отца ебал',
    'представься отцом пидором',
    'Все на язык матери',
    'Че отцу сплюнул на язык',
    'Моим ртом харькнули тебе в ебало',
    'Мой язык батю твоего пидором называл',
    'Ты мне на это с хуя',
    'У все рот твой',
    'у всех жопа твоя',
    'На язык твой',
    'Язык твой меня ебал',
    'Зеркала разбиты',
    'Зеркала правдой в рот ебаны',
    'Я бук правды , на тебе язык пиздобола',
    'Под определениями выше твоя мать',
    'Рот твой в сперме',
    'Потом мой оппонент проснулся',
    'Че ты матери на меня ухо прошепчешь',
    'Мать шлюхой провокацией назови',
    'сегодня день на оборот',
    'Кому говорю когда мать оппонента трахаю',
    'Че с хуя ?',
    'Какими определениями ебан',
    'Провокацией без языка остался',
    'Зеркала разбиты',
    'Какие определения на надгробной плите матери твоей ?',
    'нонстопом в рот ебан',
    'Под каким тебя ебали ?',
    'Басбустом батю пидором называй',
    'Совру сказав что тебя не ебали',
    'Все определения мать твоя',
    'Какими словами в рот ебан',
    'На тебе язык пиздобола',
    'Язык с яиц убери скажи',
    'Пародируй ебыря',
    'Что у тебя на языке кроме спермы ?',
    'Ври если отец гей', '1', 'изи by night lua', 'хочешь играть так же? купи night.lua',
    'не можешь убить меня:( купи night.lua', 'ez', 'фу,жирный выблядок', 'аллах бабах чурки', 'изи выблядок',
    'iq?',
    '1 шлюха мать твою ебал', 'классно играешь', 'даже твоя мать с night.lua играет', 'ты старался',
    'бро почему сосал? потому что нет night.lua', 'спасибо за килл', 'ебать я тебя тапнул ущерб', 'l2p долбаеб',
    'ахахаха найс аа додик', 'че падаем?' }

function player_death(event)
    if not menu.misc.trash_talk:get() then return end
    local attacker = client.userid_to_entindex(event.attacker)
    local userid = client.userid_to_entindex(event.userid)
    if not attacker or not userid then
        return
    end
    if attacker == entity.get_local_player() then
        if userid ~= entity.get_local_player() then
            client.exec(string.format('say %s', killsays[math.random(#killsays)]))
        end
    end
end

function anim_breaker()
    local player = entity.get_local_player()

    if player == nil then return end

    local self_index = c_entity.new(player)
    local self_anim_state = self_index:get_anim_state()

    if not self_anim_state then return end

    if not menu.misc.animation:get() then return end

    if menu.misc.animation_air:get() == '~static' then
        entity.set_prop(player, 'm_flPoseParameter', 1, 6)
    end

    if menu.misc.animation_air:get() == '~kangaroo' then
        entity.set_prop(player, 'm_flPoseParameter', client.random_float(0, 1), 6)
    end

    if menu.misc.animation_legs:get() == '~static' then
        ui.set(ref.other_legmovement, 'Always slide')
        entity.set_prop(player, 'm_flPoseParameter', 1, 0)
    elseif menu.misc.animation_legs:get() == 'Jitter' then
        entity.set_prop(player, 'm_flPoseParameter', 1, globals.tickcount() % 4 > 1 and 0.5 or 1)
    elseif menu.misc.animation_legs:get() == "~kangaroo" then
        entity.set_prop(player, 'm_flPoseParameter', client.random_float(0, 1), 7)
        ui.set(ref.other_legmovement, 'Never slide')
    elseif menu.misc.animation_legs:get() == "~air walk" then
        local me = ent.get_local_player()
        local m_fFlags = me:get_prop("m_fFlags")
        local is_onground = bit.band(m_fFlags, 1) ~= 0
        if not is_onground then
            local animlayer = me:get_anim_overlay(6)
            animlayer.weight = 1
        end
    end

    local velocity = entity.get_prop(player, "m_vecVelocity[0]")
    if math.abs(velocity) > 5 or menu.misc.animation_eatherquake:get() then
        local animlayer = self_index:get_anim_overlay(12)
        local value = menu.misc.animation_movelean:get()
        animlayer.weight = menu.misc.animation_eatherquake:get() and math.random(0, value) / 100 or value / 100
    end
end

function predict()
    if menu.misc.predict:get() and menu.misc.predict_key:get() then
        local local_player = entity.get_local_player()
        local weapon = entity.get_player_weapon(local_player)
        cvar.sv_max_allowed_net_graph:set_int(2)
        cvar.cl_interpolate:set_int(2)
        cvar.cl_interp_ratio:set_int(1)
        if entity.get_classname(weapon) == 'CWeaponSSG08' then
            cvar.cl_interp:set_float(0.025000)
        else
            cvar.cl_interp:set_float(0.200000)
        end
    else
        cvar.sv_max_allowed_net_graph:set_int(1)
        cvar.cl_interpolate:set_int(1)
        cvar.cl_interp_ratio:set_int(2)
        cvar.cl_interp:set_float(0.015625)
    end
end

local client_latency, client_screen_size, client_set_event_callback, client_system_time, entity_get_local_player, entity_get_player_resource, entity_get_prop, globals_absoluteframetime, globals_tickinterval, math_ceil, math_floor, math_min, math_sqrt, renderer_measure_text, ui_reference, pcall, renderer_gradient, renderer_rectangle, renderer_text, string_format, table_insert, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_multiselect, ui_new_textbox, ui_set, ui_set_callback, ui_set_visible =
    client.latency, client.screen_size, client.set_event_callback, client.system_time, entity.get_local_player,
    entity.get_player_resource, entity.get_prop, globals.absoluteframetime, globals.tickinterval, math.ceil, math.floor,
    math.min, math.sqrt, renderer.measure_text, ui.reference, pcall, renderer.gradient, renderer.rectangle, renderer
    .text, string.format, table.insert, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_multiselect, ui.new_textbox,
    ui.set, ui.set_callback, ui.set_visible

ffi.cdef [[
    typedef struct {
        char pad[3];
        char m_bForceWeaponUpdate; // 0x4
        char pad1[91];
        void* m_pBaseEntity; // 0x60
        void* m_pActiveWeapon; // 0x64
        void* m_pLastActiveWeapon; // 0x68
        float m_flLastClientSideAnimationUpdateTime; // 0x6C
        int m_iLastClientSideAnimationUpdateFramecount; // 0x70
        float m_flAnimUpdateDelta; // 0x74
        float m_flEyeYaw; // 0x78
        float m_flPitch; // 0x7C
        float m_flGoalFeetYaw; // 0x80
        float m_flCurrentFeetYaw; // 0x84
        float m_flCurrentTorsoYaw; // 0x88
        float m_flUnknownVelocityLean; // 0x8C
        float m_flLeanAmount; // 0x90
        char pad2[4];
        float m_flFeetCycle; // 0x98
        float m_flFeetYawRate; // 0x9C
        char pad3[4];
        float m_fDuckAmount; // 0xA4
        float m_fLandingDuckAdditiveSomething; // 0xA8
        char pad4[4];
        float m_vOriginX; // 0xB0
        float m_vOriginY; // 0xB4
        float m_vOriginZ; // 0xB8
        float m_vLastOriginX; // 0xBC
        float m_vLastOriginY; // 0xC0
        float m_vLastOriginZ; // 0xC4
        float m_vVelocityX; // 0xC8
        float m_vVelocityY; // 0xCC
        char pad5[4];
        float m_flUnknownFloat1; // 0xD4
        char pad6[8];
        float m_flUnknownFloat2; // 0xE0
        float m_flUnknownFloat3; // 0xE4
        float m_flUnknown; // 0xE8
        float m_flSpeed2D; // 0xEC
        float m_flUpVelocity; // 0xF0
        float m_flSpeedNormalized; // 0xF4
        float m_flFeetSpeedForwardsOrSideWays; // 0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; // 0xFC
        float m_flTimeSinceStartedMoving; // 0x100
        float m_flTimeSinceStoppedMoving; // 0x104
        bool m_bOnGround; // 0x108
        bool m_bInHitGroundAnimation; // 0x109
        char pad7[2]; // Выравнивание до следующего float
        float m_flTimeSinceInAir; // 0x10A
        float m_flLastOriginZ; // 0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; // 0x112
        float m_flStopToFullRunningFraction; // 0x116
        char pad8[4]; // 0x11A
        float m_flMagicFraction; // 0x11E
        char pad9[60]; // 0x122
        float m_flWorldForce; // 0x15E
        char pad10[462]; // 0x162
        float m_flMaxYaw; // 0x330 (смещение указано в структуре)
        float velocity_subtract_x; // 0x334
        float velocity_subtract_y; // 0x338
        float velocity_subtract_z; // 0x33C
    } c_animstate;
    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    typedef struct
    {
        float m_anim_time;
        float m_fade_out_time;
        int m_flags;
        int m_activity;
        int m_priority;
        int m_order;
        int m_sequence;
        float m_prev_cycle;
        float m_weight;
        float m_weight_delta_rate;
        float m_playback_rate;
        float m_cycle;
        void* m_owner;
        int m_bits;
    } C_AnimationLayer;

    typedef uintptr_t(__thiscall* GetClientEntityHandle_4242425_t)(void*, uintptr_t);
]]

ffi.cdef [[
    typedef struct MaterialAdapterInfo_tt
    {
        char m_pDriverName[512];
        unsigned int m_VendorID;
        unsigned int m_DeviceID;
        unsigned int m_SubSysID;
        unsigned int m_Revision;
        int m_nDXSupportLevel;
        int m_nMinDXSupportLevel;
        int m_nMaxDXSupportLevel;
        unsigned int m_nDriverVersionHigh;
        unsigned int m_nDriverVersionLow;
    };

    typedef int(__thiscall* get_current_adapter_fn)(void*);
    typedef void(__thiscall* get_adapter_info_fn)(void*, int adapter, struct MaterialAdapterInfo_tt& info);
]]

math.clamp = function(value, min, max)
    return value < min and min or (value > max and max or value)
end


math.vec_length2d = function(vec)
    return math.sqrt(vec.x * vec.x + vec.y * vec.y)
end


math.vec_length3d = function(vec)
    return math.sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z)
end


math.dot2d = function(vec1, vec2)
    return vec1.x * vec2.x + vec1.y * vec2.y
end


math.dot3d = function(vec1, vec2)
    return vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z
end


math.cross3d = function(vec1, vec2)
    return {
        x = vec1.y * vec2.z - vec1.z * vec2.y,
        y = vec1.z * vec2.x - vec1.x * vec2.z,
        z = vec1.x * vec2.y - vec1.y * vec2.x
    }
end


math.angle_normalize = function(angle)
    return (angle % 360 + 360) % 360
end


math.angle_diff = function(dest, src)
    local delta = (dest - src + 540) % 360 - 180
    return delta
end


math.approach_angle = function(target, value, speed)
    target = math.angle_normalize(target)
    value = math.angle_normalize(value)

    local delta = math.angle_diff(target, value)
    speed = math.abs(speed)

    if delta > speed then
        value = value + speed
    elseif delta < -speed then
        value = value - speed
    else
        value = target
    end

    return math.angle_normalize(value)
end


math.lerp = function(a, b, t)
    return a + (b - a) * t
end


math.inv_lerp = function(a, b, value)
    return (value - a) / (b - a)
end


math.remap = function(value, in_min, in_max, out_min, out_max)
    return out_min + (value - in_min) * (out_max - out_min) / (in_max - in_min)
end


math.distance2d = function(point1, point2)
    local dx = point2.x - point1.x
    local dy = point2.y - point1.y
    return math.sqrt(dx * dx + dy * dy)
end


math.distance3d = function(point1, point2)
    local dx = point2.x - point1.x
    local dy = point2.y - point1.y
    local dz = point2.z - point1.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end


math.midpoint2d = function(point1, point2)
    return {
        x = (point1.x + point2.x) * 0.5,
        y = (point1.y + point2.y) * 0.5
    }
end


math.midpoint3d = function(point1, point2)
    return {
        x = (point1.x + point2.x) * 0.5,
        y = (point1.y + point2.y) * 0.5,
        z = (point1.z + point2.z) * 0.5
    }
end


math.angle_between2d = function(vec1, vec2)
    local dot = math.dot2d(vec1, vec2)
    local len1 = math.vec_length2d(vec1)
    local len2 = math.vec_length2d(vec2)
    return math.acos(dot / (len1 * len2))
end


math.angle_between3d = function(vec1, vec2)
    local dot = math.dot3d(vec1, vec2)
    local len1 = math.vec_length3d(vec1)
    local len2 = math.vec_length3d(vec2)
    return math.acos(dot / (len1 * len2))
end


math.point_in_bbox2d = function(point, bbox_min, bbox_max)
    return point.x >= bbox_min.x and point.x <= bbox_max.x and
        point.y >= bbox_min.y and point.y <= bbox_max.y
end


math.point_in_bbox3d = function(point, bbox_min, bbox_max)
    return point.x >= bbox_min.x and point.x <= bbox_max.x and
        point.y >= bbox_min.y and point.y <= bbox_max.y and
        point.z >= bbox_min.z and point.z <= bbox_max.z
end


math.signed_area_triangle2d = function(a, b, c)
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
end


math.point_in_triangle2d = function(point, a, b, c)
    local d1 = math.signed_area_triangle2d(point, a, b)
    local d2 = math.signed_area_triangle2d(point, b, c)
    local d3 = math.signed_area_triangle2d(point, c, a)

    local has_neg = d1 < 0 or d2 < 0 or d3 < 0
    local has_pos = d1 > 0 or d2 > 0 or d3 > 0

    return not (has_neg and has_pos)
end

local entity_list_ptr = ffi.cast("void***", client.create_interface("client.dll", "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("GetClientEntityHandle_4242425_t", entity_list_ptr[0][3])
local voidptr = ffi.typeof("void***")
local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or
    error("VClientEntityList003 wasn't found", 2)
local ientitylist = ffi.cast(voidptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)


entity.get_vector_prop = function(idx, prop, array)
    local v1, v2, v3 = entity.get_prop(idx, prop, array)
    return { x = v1, y = v2, z = v3 }
end

entity.get_address = function(idx)
    return get_client_entity_fn(entity_list_ptr, idx)
end

entity.get_animstate = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("c_animstate**", addr + 0x9960)[0]
end

entity.get_animlayer = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("C_AnimationLayer**", ffi.cast('uintptr_t', addr) + 0x9960)[0]
end


local function charge1()
    if not menu.misc.charge1:get() then
        return
    end

    local ref = {
        aimbot = ui.reference('RAGE', 'Aimbot', 'Enabled'),
        doubletap = { main = { ui.reference('RAGE', 'Aimbot', 'Double tap') }, fakelag_limit = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit') }
    }

    local local_player, callback_reg, dt_charged = nil, false, false

    function check_charge()
        local shift = math.floor(entity.get_prop(local_player, 'm_nTickBase') - globals.tickcount() - 3 -
            toticks(client.latency()) * .5 + .5 * (client.latency() * 10))
        dt_charged = shift <= -14 + (ui.get(ref.doubletap.fakelag_limit) - 1) + 3
    end

    client.set_event_callback('setup_command', function()
        if menu.misc.teleport:get() and menu.misc.teleport_key:get() then
            auto_tp(cmd)
        end

        if not ui.get(ref.doubletap.main[2]) or not ui.get(ref.doubletap.main[1]) or not menu.misc.charge1:get() then
            ui.set(ref.aimbot, true)
            if callback_reg then
                client.unset_event_callback('run_command', check_charge)
                callback_reg = false
            end
            return
        end

        if not callback_reg then
            local_player = entity.get_local_player()
            client.set_event_callback('run_command', check_charge)
            callback_reg = true
        end

        local threat = client.current_threat()
        ui.set(ref.aimbot,
            (dt_charged or not threat or bit.band(entity.get_prop(local_player, 'm_fFlags'), 1) ~= 0 or bit.band(entity.get_esp_data(threat).flags, bit.lshift(1, 11)) ~= 2048))
    end)
end

local resolver = {
    layers = {},
    prediction_time = 0.3,
    smoothing_factor = 0.1,
    max_prediction_time = 0.5,
    min_prediction_time = 0.1,
    history = {},
    max_history_size = 10
}

resolver.m_flMaxDelta = function(idx)
    local animstate = entity.get_animstate(idx)
    if not animstate then return 0 end

    local speedfactor = math.clamp(animstate.m_flFeetSpeedForwardsOrSideWays, 0, 1)
    local avg_speedfactor = (animstate.m_flStopToFullRunningFraction * -0.3 - 0.2) * speedfactor + 1
    local duck_amount = animstate.m_fDuckAmount

    if duck_amount > 0 then
        local max_velocity = math.clamp(animstate.m_flFeetSpeedForwardsOrSideWays, 0, 1)
        local duck_speed = duck_amount * max_velocity
        avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
    end

    return avg_speedfactor * animstate.m_flMaxYaw
end

resolver.update_layers = function(idx)
    local layers = entity.get_animlayer(idx)
    if not layers then return end
    if not resolver.layers[idx] then
        resolver.layers[idx] = {}
    end

    for i = 0, 13 do
        local layer = layers[i]
        if not resolver.layers[idx][i] then
            resolver.layers[idx][i] = {}
        end

        resolver.layers[idx][i].m_cycle = layer.m_cycle
        resolver.layers[idx][i].m_playback_rate = layer.m_playback_rate
        resolver.layers[idx][i].m_weight = layer.m_weight
        resolver.layers[idx][i].m_weight_delta_rate = layer.m_weight_delta_rate
    end
end

resolver.get_layers = function(idx)
    return resolver.layers[idx] or {}
end

resolver.predict_position = function(idx)
    local animstate = entity.get_animstate(idx)
    if not animstate then return end

    local velocity = entity.get_vector_prop(idx, "m_vecVelocity")
    local origin = entity.get_vector_prop(idx, "m_vecOrigin")


    local speed = math.vec_length2d(velocity)
    local acceleration = math.vec_length2d({
        x = animstate.velocity_subtract_x,
        y = animstate.velocity_subtract_y,
        z =
            animstate.velocity_subtract_z
    })
    local dynamic_prediction_time = math.clamp(resolver.prediction_time, resolver.min_prediction_time,
        resolver.max_prediction_time)
    dynamic_prediction_time = dynamic_prediction_time * (speed / 100) * (1 + acceleration / 1000)


    local future_position = {
        x = origin.x + velocity.x * dynamic_prediction_time,
        y = origin.y + velocity.y * dynamic_prediction_time,
        z = origin.z + velocity.z * dynamic_prediction_time
    }

    future_position.x = future_position.x + 0.5 * animstate.velocity_subtract_x * dynamic_prediction_time ^ 2
    future_position.y = future_position.y + 0.5 * animstate.velocity_subtract_y * dynamic_prediction_time ^ 2
    future_position.z = future_position.z + 0.5 * animstate.velocity_subtract_z * dynamic_prediction_time ^ 2


    if not resolver.history[idx] then
        resolver.history[idx] = {}
    end
    table.insert(resolver.history[idx], { position = future_position, time = globals.curtime() })
    if #resolver.history[idx] > resolver.max_history_size then
        table.remove(resolver.history[idx], 1)
    end

    return future_position
end

resolver.predict_yaw = function(idx, current_yaw)
    local animstate = entity.get_animstate(idx)
    if not animstate then return current_yaw end

    local velocity = entity.get_vector_prop(idx, "m_vecVelocity")
    local speed = math.vec_length2d(velocity)


    local acceleration = math.vec_length2d({
        x = animstate.velocity_subtract_x,
        y = animstate.velocity_subtract_y,
        z =
            animstate.velocity_subtract_z
    })
    local dynamic_prediction_time = math.clamp(resolver.prediction_time, resolver.min_prediction_time,
        resolver.max_prediction_time)
    dynamic_prediction_time = dynamic_prediction_time * (speed / 100) * (1 + acceleration / 1000)


    local predicted_yaw = animstate.m_flGoalFeetYaw + (animstate.m_flFeetYawRate * dynamic_prediction_time)


    local delta = math.abs(predicted_yaw - current_yaw)
    local smoothing_factor = resolver.smoothing_factor * (1 + speed / 300) * (1 + delta / 180)
    local smoothed_yaw = math.angle_normalize(current_yaw + (predicted_yaw - current_yaw) * smoothing_factor)

    return smoothed_yaw
end

function clearcons()
    if menu.misc.clearcons:get() then
        cvar.developer:set_int(0)
        cvar.con_filter_enable:set_int(1)
        cvar.con_filter_text:set_string("IrWL5106TZZKNFPz4P4Gl3pSN?J370f5hi373ZjPg%VOVh6lN")
        client.exec("con_filter_enable 1")
    end
end

client.set_event_callback("net_update_end", function()
    clearcons()
    local players = entity.get_players(true)
    if not players then return end

    for i = 1, #players do
        local ent = players[i]
        resolver.update_layers(ent)
    end
end)

local function find_layer(ent, act)
    local layers = entity.get_animlayer(ent)
    if not layers then return -1 end

    for i = 0, 13 do
        local layer = layers[i]
        if layer.m_activity == act then
            return i
        end
    end
    return -1
end


function paint()
    if not menu.misc.resolver:get() then return end

    local players = entity.get_players(true)
    for i = 1, #players do
        local ent = players[i]

        local lay = find_layer(ent, 1)
        if lay == -1 then goto skip end

        local animstate = entity.get_animstate(ent)
        if not animstate then return end

        local max_delta = resolver.m_flMaxDelta(ent)
        local delta = entity.get_prop(ent, "m_angEyeAngles[1]")
        local speed = entity.get_prop(ent, "m_vecVelocity[0]")

        delta = math.angle_diff(delta, 0)
        local feet_yaw = max_delta

        local clamped_delta = math.clamp(delta, -feet_yaw, feet_yaw)
        local ang = entity.get_prop(ent, "m_angEyeAngles[1]") + clamped_delta

        local predicted_yaw = resolver.predict_yaw(ent, animstate.m_flGoalFeetYaw)
        local approach_delta = math.approach_angle(predicted_yaw, ang, math.max(0.1, math.abs(predicted_yaw - ang) / 10))
        animstate.m_flGoalFeetYaw = approach_delta

        if speed <= 0.1 then
            animstate.m_flGoalFeetYaw = ang
        end

        ::skip::
    end
end

function config_system.save(name)
    local db = database.read(protected.database.configs) or {}

    if name:match('[^%w]') ~= nil then return end

    local config = base64.encode(json.stringify(package:save()))
    local config2 = base64.encode(json.stringify(aa_package:save()))

    local cfg = config_system.get(name)

    if not cfg then
        table.insert(db, { name = name, config = config, config2 = config2 })
    else
        db[cfg.index].config = config
        db[cfg.index].config2 = config2
    end

    database.write(protected.database.configs, db)
end

function config_system.delete(name)
    local db = database.read(protected.database.configs) or {}

    for i, v in pairs(db) do
        if v.name == name then
            table.remove(db, i)
            break
        end
    end

    for i, v in pairs(presets) do
        if v.name == name then
            return false
        end
    end

    database.write(protected.database.configs, db)
end

function config_system.config_list()
    local database = database.read(protected.database.configs) or {}
    local config = {}

    for i, v in pairs(presets) do
        table.insert(config, v.name)
    end

    for i, v in pairs(database) do
        table.insert(config, v.name)
    end

    return config
end

aa_package = ui_handler.setup(builder)
package = ui_handler.setup(menu)

function config_system.load_settings(e, e2)
    package:load(e)
    aa_package:load(e2)
end

function config_system.import_settings()
    local frombuffer = clipboard.get()
    local config = json.parse(base64.decode(frombuffer))
    config_system.load_settings(config.config, config.config2)
end

function config_system.export_settings(name)
    local config = { config = package:save(), config2 = aa_package:save() }
    local jsonString = json.stringify(config)
    local toExport = base64.encode(jsonString)
    clipboard.set(toExport)
end

function config_system.load(name)
    local fromDB = config_system.get(name)
    config_system.load_settings(json.parse(base64.decode(fromDB.config)), json.parse(base64.decode(fromDB.config2)))
end

menu.global.list_box:set_callback(function(value)
    if value == nil then
        return
    end
    local name = ''

    local configs = config_system.config_list()
    if configs == nil then
        return
    end

    name = configs[value:get() + 1] or ''
    menu.global.name:set(name)
end)

menu.global.buttom_load:set_callback(function()
    local name = menu.global.name:get()
    if name == '' then return end

    local s, p = pcall(config_system.load, name)

    if s then
        name = name:gsub('*', '')
        print('successfully loaded ' .. name)
    else
        print('failed to load ' .. name)
        print('debug: ', p)
    end
end)

menu.global.buttom_create:set_callback(function()
    local name = menu.global.name:get()
    if name == '' then return end

    for i, v in pairs(presets) do
        if v.name == name:gsub('*', '') then
            print("you can't save built-in preset")
            return
        end
    end

    if name:match('[^%w]') ~= nil then
        print('failed to save ' .. name .. ' due to invalid characters')
        return
    end

    local protected = function()
        config_system.save(name)
        menu.global.list_box:update(config_system.config_list())
    end

    if pcall(protected) then
        print('successfully saved ' .. name)
    else
        print('failed to save ' .. name)
    end
end)

menu.global.buttom_delete:set_callback(function()
    local name = menu.global.name:get()
    if name == '' then return end

    if config_system.delete(name) == false then
        print('failed to delete ' .. name)
        menu.global.list_box:update(config_system.config_list())
        return
    end

    for i, v in pairs(presets) do
        if v.name == name:gsub('*', '') then
            print('you can`t delete built-in preset ' .. name:gsub('*', ''))
            return
        end
    end

    config_system.delete(name)

    menu.global.list_box:update(config_system.config_list())
    menu.global.list_box:set((#presets) or '')
    menu.global.name:set(#database.read(protected.database.configs) == 0 and "" or config_system.config_list()[#presets])
    print('successfully deleted ' .. name)
end)

menu.global.buttom_import:set_callback(function()
    local protected = function()
        config_system.import_settings()
    end

    if pcall(protected) then
        print('successfully imported settings')
    else
        print('failed to import settings')
    end
end)

menu.global.buttom_export:set_callback(function()
    local name = menu.global.name:get()
    if name == '' then return end

    local protected = function()
        config_system.export_settings(name)
    end

    if pcall(protected) then
        print('successfully exported settings')
    else
        print('failed to export settings')
    end
end)

function initDatabase()
    if database.read(protected.database.configs) == nil then
        database.write(protected.database.configs, {})
    end

    local link =
    'eyJjb25maWcyIjpbeyJlbmFibGUiOmZhbHNlLCJhbmdsZTEiOi0zNiwicGl0Y2giOiJPZmYiLCJ5YXcxIjowLCJqaXR0ZXIiOiJPZmYiLCJjdXN0b21fcGl0Y2giOjAsInlhd19zcGVlZCI6MCwiYm9keV9hbW91bnQiOjAsImRlbGF5Ijo0LCJmcmVlc3RhbmRpbmciOnRydWUsImJvZHkiOiJPZmYiLCJyYW5nZSI6LTE4MCwieHdheSI6NywibW9kZSI6IkFsd2F5cyBvbiIsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsImZyZWVzdGFuZGluZ19ob3RrZXkiOlsxLDAsIn4iXSwic3RhdGljIjowLCJkZWZfeWF3IjoiWC1XYXkiLCJ4d2F5MSI6MywieWF3IjoiT2ZmIiwid2F5MSI6WzAsMCwwLDAsMCwwLDBdLCJhbmdsZTIiOjg5LCJkZWZlbnNpdmUiOnRydWUsImRlZl9waXRjaCI6IkppdHRlciIsImZyZWVzdGFuZGluZ19ib2R5Ijp0cnVlLCJyYW5kb20iOjAsImppdHRlcl9zcGVlZCI6MiwiZWRnZXlhdyI6ZmFsc2UsInBpdGNoX2N1c3RvbSI6MH0seyJlbmFibGUiOnRydWUsImFuZ2xlMSI6LTM2LCJwaXRjaCI6IkRvd24iLCJ5YXcxIjowLCJqaXR0ZXIiOiJSYW5kb20iLCJjdXN0b21fcGl0Y2giOjAsInlhd19zcGVlZCI6MCwiYm9keV9hbW91bnQiOjAsImRlbGF5IjoxLCJmcmVlc3RhbmRpbmciOnRydWUsImJvZHkiOiJKaXR0ZXIiLCJyYW5nZSI6MTc3LCJ4d2F5Ijo3LCJtb2RlIjoiT24gcGVlayIsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsImZyZWVzdGFuZGluZ19ob3RrZXkiOlsxLDAsIn4iXSwic3RhdGljIjoxODAsImRlZl95YXciOiJYLVdheSIsInh3YXkxIjozLCJ5YXciOiJTdGF0aWMiLCJ3YXkxIjpbMCwwLDAsMCwwLDAsMF0sImFuZ2xlMiI6ODksImRlZmVuc2l2ZSI6dHJ1ZSwiZGVmX3BpdGNoIjoiSml0dGVyIiwiZnJlZXN0YW5kaW5nX2JvZHkiOnRydWUsInJhbmRvbSI6MTAwLCJqaXR0ZXJfc3BlZWQiOjIsImVkZ2V5YXciOmZhbHNlLCJwaXRjaF9jdXN0b20iOjB9LHsiZW5hYmxlIjp0cnVlLCJhbmdsZTEiOjg5LCJwaXRjaCI6Ik1pbmltYWwiLCJ5YXcxIjowLCJqaXR0ZXIiOiJSYW5kb20iLCJjdXN0b21fcGl0Y2giOjAsInlhd19zcGVlZCI6MCwiYm9keV9hbW91bnQiOjAsImRlbGF5Ijo0LCJmcmVlc3RhbmRpbmciOnRydWUsImJvZHkiOiJPZmYiLCJyYW5nZSI6MTc3LCJ4d2F5IjozLCJtb2RlIjoiT24gcGVlayIsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsImZyZWVzdGFuZGluZ19ob3RrZXkiOlsxLDAsIn4iXSwic3RhdGljIjoxODAsImRlZl95YXciOiJYLVdheSIsInh3YXkxIjozLCJ5YXciOiJTcGluIiwid2F5MSI6WzAsMCwwLDAsMCwwLDBdLCJhbmdsZTIiOi04OSwiZGVmZW5zaXZlIjp0cnVlLCJkZWZfcGl0Y2giOiJKaXR0ZXIiLCJmcmVlc3RhbmRpbmdfYm9keSI6dHJ1ZSwicmFuZG9tIjowLCJqaXR0ZXJfc3BlZWQiOjIsImVkZ2V5YXciOmZhbHNlLCJwaXRjaF9jdXN0b20iOjB9LHsiZW5hYmxlIjp0cnVlLCJhbmdsZTEiOi0zNiwicGl0Y2giOiJEb3duIiwieWF3MSI6MCwiaml0dGVyIjoiU2tpdHRlciIsImN1c3RvbV9waXRjaCI6MCwieWF3X3NwZWVkIjowLCJib2R5X2Ftb3VudCI6MTMzLCJkZWxheSI6NCwiZnJlZXN0YW5kaW5nIjp0cnVlLCJib2R5IjoiU3RhdGljIiwicmFuZ2UiOjE3NywieHdheSI6NywibW9kZSI6IkFsd2F5cyBvbiIsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsImZyZWVzdGFuZGluZ19ob3RrZXkiOlsxLDAsIn4iXSwic3RhdGljIjoxODAsImRlZl95YXciOiJYLVdheSIsInh3YXkxIjozLCJ5YXciOiJTcGluIiwid2F5MSI6WzAsMCwwLDAsMCwwLDBdLCJhbmdsZTIiOjg5LCJkZWZlbnNpdmUiOnRydWUsImRlZl9waXRjaCI6IkppdHRlciIsImZyZWVzdGFuZGluZ19ib2R5Ijp0cnVlLCJyYW5kb20iOjAsImppdHRlcl9zcGVlZCI6MiwiZWRnZXlhdyI6ZmFsc2UsInBpdGNoX2N1c3RvbSI6MH0seyJlbmFibGUiOnRydWUsImFuZ2xlMSI6LTM2LCJwaXRjaCI6IkRvd24iLCJ5YXcxIjowLCJqaXR0ZXIiOiJSYW5kb20iLCJjdXN0b21fcGl0Y2giOjAsInlhd19zcGVlZCI6MCwiYm9keV9hbW91bnQiOjAsImRlbGF5IjoxMiwiZnJlZXN0YW5kaW5nIjp0cnVlLCJib2R5IjoiSml0dGVyIiwicmFuZ2UiOjE4MCwieHdheSI6NywibW9kZSI6IkFsd2F5cyBvbiIsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsImZyZWVzdGFuZGluZ19ob3RrZXkiOlsxLDAsIn4iXSwic3RhdGljIjo3LCJkZWZfeWF3IjoiWC1XYXkiLCJ4d2F5MSI6MywieWF3IjoiMTgwIiwid2F5MSI6WzAsMCwwLDAsMCwwLDBdLCJhbmdsZTIiOjg5LCJkZWZlbnNpdmUiOnRydWUsImRlZl9waXRjaCI6IkppdHRlciIsImZyZWVzdGFuZGluZ19ib2R5Ijp0cnVlLCJyYW5kb20iOjEwMCwiaml0dGVyX3NwZWVkIjoyLCJlZGdleWF3IjpmYWxzZSwicGl0Y2hfY3VzdG9tIjowfSx7ImVuYWJsZSI6ZmFsc2UsImFuZ2xlMSI6LTM2LCJwaXRjaCI6Ik9mZiIsInlhdzEiOjAsImppdHRlciI6IlJhbmRvbSIsImN1c3RvbV9waXRjaCI6MCwieWF3X3NwZWVkIjowLCJib2R5X2Ftb3VudCI6MCwiZGVsYXkiOjQsImZyZWVzdGFuZGluZyI6dHJ1ZSwiYm9keSI6Ik9mZiIsInJhbmdlIjoxNzcsInh3YXkiOjcsIm1vZGUiOiJBbHdheXMgb24iLCJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJmcmVlc3RhbmRpbmdfaG90a2V5IjpbMSwwLCJ+Il0sInN0YXRpYyI6MCwiZGVmX3lhdyI6IlgtV2F5IiwieHdheTEiOjMsInlhdyI6Ik9mZiIsIndheTEiOlswLDAsMCwwLDAsMCwwXSwiYW5nbGUyIjo4OSwiZGVmZW5zaXZlIjp0cnVlLCJkZWZfcGl0Y2giOiJKaXR0ZXIiLCJmcmVlc3RhbmRpbmdfYm9keSI6dHJ1ZSwicmFuZG9tIjowLCJqaXR0ZXJfc3BlZWQiOjIsImVkZ2V5YXciOmZhbHNlLCJwaXRjaF9jdXN0b20iOjB9LHsiZW5hYmxlIjpmYWxzZSwiYW5nbGUxIjotMzYsInBpdGNoIjoiT2ZmIiwieWF3MSI6MCwiaml0dGVyIjoiUmFuZG9tIiwiY3VzdG9tX3BpdGNoIjowLCJ5YXdfc3BlZWQiOjAsImJvZHlfYW1vdW50IjowLCJkZWxheSI6NCwiZnJlZXN0YW5kaW5nIjp0cnVlLCJib2R5IjoiT2ZmIiwicmFuZ2UiOjE3NywieHdheSI6NywibW9kZSI6IkFsd2F5cyBvbiIsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsImZyZWVzdGFuZGluZ19ob3RrZXkiOlsxLDAsIn4iXSwic3RhdGljIjowLCJkZWZfeWF3IjoiWC1XYXkiLCJ4d2F5MSI6MywieWF3IjoiT2ZmIiwid2F5MSI6WzAsMCwwLDAsMCwwLDBdLCJhbmdsZTIiOjg5LCJkZWZlbnNpdmUiOnRydWUsImRlZl9waXRjaCI6IkppdHRlciIsImZyZWVzdGFuZGluZ19ib2R5Ijp0cnVlLCJyYW5kb20iOjAsImppdHRlcl9zcGVlZCI6MiwiZWRnZXlhdyI6ZmFsc2UsInBpdGNoX2N1c3RvbSI6MH0seyJlbmFibGUiOmZhbHNlLCJhbmdsZTEiOi0zNiwicGl0Y2giOiJPZmYiLCJ5YXcxIjowLCJqaXR0ZXIiOiJSYW5kb20iLCJjdXN0b21fcGl0Y2giOjAsInlhd19zcGVlZCI6MCwiYm9keV9hbW91bnQiOjAsImRlbGF5Ijo0LCJmcmVlc3RhbmRpbmciOnRydWUsImJvZHkiOiJPZmYiLCJyYW5nZSI6MTc3LCJ4d2F5Ijo3LCJtb2RlIjoiQWx3YXlzIG9uIiwieWF3X2Jhc2UiOiJMb2NhbCB2aWV3IiwiZnJlZXN0YW5kaW5nX2hvdGtleSI6WzEsMCwifiJdLCJzdGF0aWMiOjAsImRlZl95YXciOiJYLVdheSIsInh3YXkxIjozLCJ5YXciOiJPZmYiLCJ3YXkxIjpbMCwwLDAsMCwwLDAsMF0sImFuZ2xlMiI6ODksImRlZmVuc2l2ZSI6dHJ1ZSwiZGVmX3BpdGNoIjoiSml0dGVyIiwiZnJlZXN0YW5kaW5nX2JvZHkiOnRydWUsInJhbmRvbSI6MCwiaml0dGVyX3NwZWVkIjoyLCJlZGdleWF3IjpmYWxzZSwicGl0Y2hfY3VzdG9tIjowfV0sImNvbmZpZyI6eyJhbnRpYWltIjp7ImVuYWJsZSI6dHJ1ZSwiYW50aWFpbV9zZXR0aW5nIjoifiBidWlsZGVyIiwibWFudWFsc19yZXNldCI6WzEsMCwifiJdLCJtYW51YWxzX2ZvcndhcmQiOlsxLDAsIn4iXSwieWF3X2RpcmVjdGlvbiI6WyJ+Il0sImFuaW1fc3RhdGUiOiJBaXJcciIsIm1hbnVhbHNfbGVmdCI6WzIsOTAsIn4iXSwiZmVhdHVyZXMiOlsifiJdLCJtYW51YWxzX3JpZ2h0IjpbMiw2NywifiJdLCJzYWZlIjpbIn4iXX0sImdsb2JhbCI6eyJsaXN0X2JveCI6MX0sInZpc3VhbHMiOnsiYnVsbGV0X3RyYWNlcnMiOmZhbHNlLCJjdXN0b21fZ3NfaW5kIjpmYWxzZSwidGFyZ2V0X2FjdGl2ZSI6dHJ1ZSwiYWltYm90X2xvZ3MiOlsifiJdLCJzY29wZV9jb2xvciI6IiNCQkJCQkJGRiIsIndhdGVybWFyayI6In5iYXNpYyIsImRhbWFnZV9pbmQiOnRydWUsInNjb3BlX2dhcCI6MTUsImNyb3NzaGFpcl9jb2xvciI6IiNGRkZGRkZGRiIsInNjb3BlX3NpemUiOjE5MCwiYWltYm90X2xvZ3NfbWlzcyI6IiNGRjhFOEVGRiIsImNyb3NzaGFpciI6dHJ1ZSwiY3VzdG9tX2dzX2NvbG9yIjoiI0ZGRkZGRkZGIiwic2NvcGVfb3ZlcmxheSI6dHJ1ZSwid2F0ZXJtYXJrX3Zpc3VhbHMiOiIjRjhGOEY4RkYiLCJzY29wZV9hbmltYXRpb24iOjEyLCJjcm9zc2hhaXJfc3R5bGUiOiJ+c3RhdGljIiwiY3Jvc3Nfb2Zmc2V0IjoxNSwiY3Jvc3NoYWlyX2N1c3RvbWluZCI6dHJ1ZSwiYWltYm90X2xvZ3NfaGl0IjoiI0E0QTRBNEZGIn0sIm1pc2MiOnsiY2xlYXJjb25zIjpmYWxzZSwiYW5pbWF0aW9uX2FpciI6In5kaXNhYmxlZCIsImNsYW50YWciOnRydWUsImp1bXBzY291dDEiOnRydWUsInJlc29sdmVyIjp0cnVlLCJhbmltYXRpb24iOnRydWUsInF1aWNrX3N3aXRjaCI6dHJ1ZSwicHJlZGljdCI6dHJ1ZSwicHJlZGljdF9rZXkiOlsxLDIwLCJ+Il0sInRyYXNoX3RhbGsiOnRydWUsImFuaW1hdGlvbl9sZWdzIjoifmRpc2FibGVkIiwibGFnY29tcGwiOnRydWUsImZhc3RfbGFkZGVyIjp0cnVlfX19'
    local link2 =
    'eyJjb25maWcyIjpbeyJlbmFibGUiOmZhbHNlLCJhbmdsZTEiOi0zNiwicGl0Y2giOiJPZmYiLCJ5YXcxIjowLCJqaXR0ZXIiOiJPZmYiLCJjdXN0b21fcGl0Y2giOjAsInlhd19zcGVlZCI6MCwiYm9keV9hbW91bnQiOjAsImRlbGF5Ijo0LCJmcmVlc3RhbmRpbmciOnRydWUsImJvZHkiOiJPZmYiLCJyYW5nZSI6LTE4MCwieHdheSI6NywibW9kZSI6IkFsd2F5cyBvbiIsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsImZyZWVzdGFuZGluZ19ob3RrZXkiOlsxLDAsIn4iXSwic3RhdGljIjowLCJkZWZfeWF3IjoiWC1XYXkiLCJ4d2F5MSI6MywieWF3IjoiT2ZmIiwid2F5MSI6WzAsMCwwLDAsMCwwLDBdLCJhbmdsZTIiOjg5LCJkZWZlbnNpdmUiOnRydWUsImRlZl9waXRjaCI6IkppdHRlciIsImZyZWVzdGFuZGluZ19ib2R5IjpmYWxzZSwicmFuZG9tIjowLCJqaXR0ZXJfc3BlZWQiOjIsImVkZ2V5YXciOmZhbHNlLCJwaXRjaF9jdXN0b20iOjB9LHsiZW5hYmxlIjp0cnVlLCJhbmdsZTEiOi0zNiwicGl0Y2giOiJEb3duIiwieWF3MSI6MCwiaml0dGVyIjoiUmFuZG9tIiwiY3VzdG9tX3BpdGNoIjowLCJ5YXdfc3BlZWQiOjAsImJvZHlfYW1vdW50IjowLCJkZWxheSI6MTIsImZyZWVzdGFuZGluZyI6dHJ1ZSwiYm9keSI6IkppdHRlciIsInJhbmdlIjoxNDcsInh3YXkiOjcsIm1vZGUiOiJPbiBwZWVrIiwieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwiZnJlZXN0YW5kaW5nX2hvdGtleSI6WzEsNCwifiJdLCJzdGF0aWMiOjEsImRlZl95YXciOiJYLVdheSIsInh3YXkxIjozLCJ5YXciOiIxODAiLCJ3YXkxIjpbMCwwLDAsMCwwLDAsMF0sImFuZ2xlMiI6ODksImRlZmVuc2l2ZSI6ZmFsc2UsImRlZl9waXRjaCI6IkppdHRlciIsImZyZWVzdGFuZGluZ19ib2R5IjpmYWxzZSwicmFuZG9tIjo1Nywiaml0dGVyX3NwZWVkIjoyLCJlZGdleWF3IjpmYWxzZSwicGl0Y2hfY3VzdG9tIjowfSx7ImVuYWJsZSI6dHJ1ZSwiYW5nbGUxIjo4OSwicGl0Y2giOiJEb3duIiwieWF3MSI6MCwiaml0dGVyIjoiUmFuZG9tIiwiY3VzdG9tX3BpdGNoIjowLCJ5YXdfc3BlZWQiOjAsImJvZHlfYW1vdW50IjowLCJkZWxheSI6MTAsImZyZWVzdGFuZGluZyI6dHJ1ZSwiYm9keSI6Ik9wcG9zaXRlIiwicmFuZ2UiOjIyLCJ4d2F5IjozLCJtb2RlIjoiT24gcGVlayIsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsImZyZWVzdGFuZGluZ19ob3RrZXkiOlsxLDQsIn4iXSwic3RhdGljIjotMSwiZGVmX3lhdyI6IlgtV2F5IiwieHdheTEiOjMsInlhdyI6IjE4MCIsIndheTEiOlswLDAsMCwwLDAsMCwwXSwiYW5nbGUyIjotODksImRlZmVuc2l2ZSI6ZmFsc2UsImRlZl9waXRjaCI6IkppdHRlciIsImZyZWVzdGFuZGluZ19ib2R5IjpmYWxzZSwicmFuZG9tIjowLCJqaXR0ZXJfc3BlZWQiOjIsImVkZ2V5YXciOmZhbHNlLCJwaXRjaF9jdXN0b20iOjB9LHsiZW5hYmxlIjp0cnVlLCJhbmdsZTEiOi0zNiwicGl0Y2giOiJEb3duIiwieWF3MSI6MCwiaml0dGVyIjoiU2tpdHRlciIsImN1c3RvbV9waXRjaCI6MCwieWF3X3NwZWVkIjowLCJib2R5X2Ftb3VudCI6LTE4MCwiZGVsYXkiOjQsImZyZWVzdGFuZGluZyI6dHJ1ZSwiYm9keSI6IlN0YXRpYyIsInJhbmdlIjoxMTAsInh3YXkiOjcsIm1vZGUiOiJBbHdheXMgb24iLCJ5YXdfYmFzZSI6IkF0IHRhcmdldHMiLCJmcmVlc3RhbmRpbmdfaG90a2V5IjpbMSw0LCJ+Il0sInN0YXRpYyI6LTEsImRlZl95YXciOiJYLVdheSIsInh3YXkxIjozLCJ5YXciOiIxODAiLCJ3YXkxIjpbMCwwLDAsMCwwLDAsMF0sImFuZ2xlMiI6ODksImRlZmVuc2l2ZSI6ZmFsc2UsImRlZl9waXRjaCI6IkppdHRlciIsImZyZWVzdGFuZGluZ19ib2R5IjpmYWxzZSwicmFuZG9tIjowLCJqaXR0ZXJfc3BlZWQiOjIsImVkZ2V5YXciOmZhbHNlLCJwaXRjaF9jdXN0b20iOjB9LHsiZW5hYmxlIjp0cnVlLCJhbmdsZTEiOi0zMCwicGl0Y2giOiJNaW5pbWFsIiwieWF3MSI6MzYwLCJqaXR0ZXIiOiJYLVdheSIsImN1c3RvbV9waXRjaCI6MCwieWF3X3NwZWVkIjo1MCwiYm9keV9hbW91bnQiOjAsImRlbGF5Ijo3LCJmcmVlc3RhbmRpbmciOnRydWUsImJvZHkiOiJKaXR0ZXIiLCJyYW5nZSI6MTU4LCJ4d2F5Ijo3LCJtb2RlIjoiQWx3YXlzIG9uIiwieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwiZnJlZXN0YW5kaW5nX2hvdGtleSI6WzEsNCwifiJdLCJzdGF0aWMiOjEsImRlZl95YXciOiJTcGluYWJsZSIsInh3YXkxIjo3LCJ5YXciOiIxODAiLCJ3YXkxIjpbNjQsLTQxLDE4MCwtMTQsLTE4MCwyOCwtMV0sImFuZ2xlMiI6NTMsImRlZmVuc2l2ZSI6ZmFsc2UsImRlZl9waXRjaCI6IkppdHRlciIsImZyZWVzdGFuZGluZ19ib2R5IjpmYWxzZSwicmFuZG9tIjo3MCwiaml0dGVyX3NwZWVkIjoyLCJlZGdleWF3IjpmYWxzZSwicGl0Y2hfY3VzdG9tIjowfSx7ImVuYWJsZSI6dHJ1ZSwiYW5nbGUxIjo2NywicGl0Y2giOiJNaW5pbWFsIiwieWF3MSI6MTMsImppdHRlciI6IlJhbmRvbSIsImN1c3RvbV9waXRjaCI6NDYsInlhd19zcGVlZCI6NTAsImJvZHlfYW1vdW50IjowLCJkZWxheSI6MTMsImZyZWVzdGFuZGluZyI6dHJ1ZSwiYm9keSI6IkppdHRlciIsInJhbmdlIjotMSwieHdheSI6NywibW9kZSI6IkFsd2F5cyBvbiIsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsImZyZWVzdGFuZGluZ19ob3RrZXkiOlsxLDAsIn4iXSwic3RhdGljIjo1LCJkZWZfeWF3IjoiU3BpbmFibGUiLCJ4d2F5MSI6MywieWF3IjoiMTgwIiwid2F5MSI6WzAsMCwwLDAsMCwwLDBdLCJhbmdsZTIiOi0yNywiZGVmZW5zaXZlIjpmYWxzZSwiZGVmX3BpdGNoIjoiUmFuZG9tIiwiZnJlZXN0YW5kaW5nX2JvZHkiOmZhbHNlLCJyYW5kb20iOjEwMCwiaml0dGVyX3NwZWVkIjoyLCJlZGdleWF3IjpmYWxzZSwicGl0Y2hfY3VzdG9tIjowfSx7ImVuYWJsZSI6dHJ1ZSwiYW5nbGUxIjotMzYsInBpdGNoIjoiRG93biIsInlhdzEiOjEzNiwiaml0dGVyIjoiQ2VudGVyIiwiY3VzdG9tX3BpdGNoIjoyMSwieWF3X3NwZWVkIjozMywiYm9keV9hbW91bnQiOi0xODAsImRlbGF5Ijo0LCJmcmVlc3RhbmRpbmciOnRydWUsImJvZHkiOiJTdGF0aWMiLCJyYW5nZSI6NDAsInh3YXkiOjcsIm1vZGUiOiJBbHdheXMgb24iLCJ5YXdfYmFzZSI6IkF0IHRhcmdldHMiLCJmcmVlc3RhbmRpbmdfaG90a2V5IjpbMSw0LCJ+Il0sInN0YXRpYyI6LTUsImRlZl95YXciOiJKaXR0ZXIiLCJ4d2F5MSI6MywieWF3IjoiMTgwIiwid2F5MSI6WzAsMCwwLDAsMCwwLDBdLCJhbmdsZTIiOjg5LCJkZWZlbnNpdmUiOmZhbHNlLCJkZWZfcGl0Y2giOiJDdXN0b20iLCJmcmVlc3RhbmRpbmdfYm9keSI6ZmFsc2UsInJhbmRvbSI6MCwiaml0dGVyX3NwZWVkIjo4LCJlZGdleWF3IjpmYWxzZSwicGl0Y2hfY3VzdG9tIjowfSx7ImVuYWJsZSI6dHJ1ZSwiYW5nbGUxIjotNDAsInBpdGNoIjoiTWluaW1hbCIsInlhdzEiOjEzNiwiaml0dGVyIjoiUmFuZG9tIiwiY3VzdG9tX3BpdGNoIjowLCJ5YXdfc3BlZWQiOjAsImJvZHlfYW1vdW50IjotMTE5LCJkZWxheSI6NCwiZnJlZXN0YW5kaW5nIjp0cnVlLCJib2R5IjoiU3RhdGljIiwicmFuZ2UiOjE3NywieHdheSI6NCwibW9kZSI6IkFsd2F5cyBvbiIsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsImZyZWVzdGFuZGluZ19ob3RrZXkiOlsxLDAsIn4iXSwic3RhdGljIjoyMiwiZGVmX3lhdyI6IkppdHRlciIsInh3YXkxIjozLCJ5YXciOiIxODAiLCJ3YXkxIjpbMCwwLDAsMCwwLDAsMF0sImFuZ2xlMiI6ODksImRlZmVuc2l2ZSI6ZmFsc2UsImRlZl9waXRjaCI6IkppdHRlciIsImZyZWVzdGFuZGluZ19ib2R5Ijp0cnVlLCJyYW5kb20iOjAsImppdHRlcl9zcGVlZCI6NSwiZWRnZXlhdyI6ZmFsc2UsInBpdGNoX2N1c3RvbSI6MH1dLCJjb25maWciOnsiYW50aWFpbSI6eyJlbmFibGUiOnRydWUsImFudGlhaW1fc2V0dGluZyI6In4gYnVpbGRlciIsIm1hbnVhbHNfcmVzZXQiOlsxLDAsIn4iXSwibWFudWFsc19mb3J3YXJkIjpbMSwwLCJ+Il0sInlhd19kaXJlY3Rpb24iOlsifiJdLCJhbmltX3N0YXRlIjoiQWlyXHIiLCJtYW51YWxzX2xlZnQiOlsyLDAsIn4iXSwiZmVhdHVyZXMiOlsifiJdLCJtYW51YWxzX3JpZ2h0IjpbMiwwLCJ+Il0sInNhZmUiOlsifiJdfSwiZ2xvYmFsIjp7Imxpc3RfYm94IjoyfSwidmlzdWFscyI6eyJidWxsZXRfdHJhY2VycyI6ZmFsc2UsImN1c3RvbV9nc19pbmQiOmZhbHNlLCJ0YXJnZXRfYWN0aXZlIjp0cnVlLCJhaW1ib3RfbG9ncyI6WyJ+Il0sInNjb3BlX2NvbG9yIjoiI0JCQkJCQkZGIiwid2F0ZXJtYXJrIjoifmJhc2ljIiwiZGFtYWdlX2luZCI6dHJ1ZSwic2NvcGVfZ2FwIjoxNSwiY3Jvc3NoYWlyX2NvbG9yIjoiIzU0NTQ1NEZGIiwic2NvcGVfc2l6ZSI6MTkwLCJhaW1ib3RfbG9nc19taXNzIjoiI0ZGOEU4RUZGIiwiY3Jvc3NoYWlyIjp0cnVlLCJjdXN0b21fZ3NfY29sb3IiOiIjRkZGRkZGRkYiLCJzY29wZV9vdmVybGF5Ijp0cnVlLCJ3YXRlcm1hcmtfdmlzdWFscyI6IiNGOEY4RjhGRiIsInNjb3BlX2FuaW1hdGlvbiI6MTIsImNyb3NzaGFpcl9zdHlsZSI6In5ncmFkaWVudCIsImNyb3NzX29mZnNldCI6MTYsImNyb3NzaGFpcl9jdXN0b21pbmQiOnRydWUsImFpbWJvdF9sb2dzX2hpdCI6IiNBNEE0QTRGRiJ9LCJtaXNjIjp7ImNsZWFyY29ucyI6ZmFsc2UsImFuaW1hdGlvbl9haXIiOiJ+ZGlzYWJsZWQiLCJjbGFudGFnIjp0cnVlLCJqdW1wc2NvdXQxIjp0cnVlLCJyZXNvbHZlciI6dHJ1ZSwiYW5pbWF0aW9uIjp0cnVlLCJxdWlja19zd2l0Y2giOnRydWUsInByZWRpY3QiOnRydWUsInByZWRpY3Rfa2V5IjpbMSwxNiwifiJdLCJ0cmFzaF90YWxrIjp0cnVlLCJhbmltYXRpb25fbGVncyI6In5kaXNhYmxlZCIsImxhZ2NvbXBsIjp0cnVlLCJmYXN0X2xhZGRlciI6dHJ1ZX19fQ=='
    local decode = base64.decode(link2, 'base64')
    local toTable = json.parse(decode)

    table.insert(presets,
        {
            name = '*agressive',
            config = base64.encode(json.stringify(toTable.config)),
            config2 = base64.encode(json
                .stringify(toTable.config2))
        })
    menu.global.name:set('*agressive')

    local decode = base64.decode(link, 'base64')
    local toTable = json.parse(decode)

    table.insert(presets,
        {
            name = '*defensive',
            config = base64.encode(json.stringify(toTable.config)),
            config2 = base64.encode(json
                .stringify(toTable.config2))
        })
    menu.global.name:set('*defensive')

    menu.global.list_box:update(config_system.config_list())

    menu.global.list_box:update(config_system.config_list())

    menu.global.list_box:update(config_system.config_list())
end

initDatabase()

client.set_event_callback("paint_ui", LPH_NO_VIRTUALIZE(function()
    hide_original_menu(false)
    traverse_table(binds)
    traverse_table(binds_fakelag)
    visible()
    viewmodels()
    antiaim()
    update_way_sliders()
    active_target()
    predict()
    predict_keyaa()
    g_paint_ui()
    update_way_sliders1()
end))

client.set_event_callback("paint", LPH_NO_VIRTUALIZE(function()
    crosshair()
    shot_logger.notifications()
    viewmodels()
    paint()
    watermark()
    scope()
    damage()
    offset = 40
end))

client.set_event_callback('aim_fire', shot_logger.on_aim_fire)
client.set_event_callback('aim_miss', shot_logger.on_aim_miss)
client.set_event_callback('aim_hit', shot_logger.on_aim_hit)
client.set_event_callback('bullet_impact', shot_logger.bullet_impact)

client.set_event_callback("setup_command", LPH_NO_VIRTUALIZE(function(cmd)
    aa_setup(cmd)
    fastladder(cmd)
end))

client.set_event_callback("net_update_end", LPH_NO_VIRTUALIZE(function(e)
    clantag(e)
end))

client.set_event_callback("player_death", LPH_NO_VIRTUALIZE(function(event)
    player_death(event)
end))

client.set_event_callback("pre_render", LPH_NO_VIRTUALIZE(function()
    anim_breaker()
end))

client.set_event_callback("run_command", LPH_NO_VIRTUALIZE(function(e)
    predict()
end))



local ref = {
    aimbot = ui.reference('RAGE', 'Aimbot', 'Enabled'),
    doubletap = {
        main = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
        fakelag_limit = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit')
    }
}

local local_player, callback_reg, dt_charged = nil, false, false

local function check_charge()
    local m_nTickBase = entity.get_prop(local_player, 'm_nTickBase')
    local client_latency = client.latency()
    local shift = math.floor(m_nTickBase - globals.tickcount() - 3 - toticks(client_latency) * .5 +
        .5 * (client_latency * 10))

    local wanted = -14 + (ui.get(ref.doubletap.fakelag_limit) - 1) + 3 --error margin

    dt_charged = shift <= wanted
end

client.set_event_callback('setup_command', function()
    if not ui.get(ref.doubletap.main[2]) or not ui.get(ref.doubletap.main[1]) then
        ui.set(ref.aimbot, true)

        if callback_reg then
            client.unset_event_callback('run_command', check_charge)
            callback_reg = false
        end
        return
    end

    local_player = entity.get_local_player()

    if not callback_reg then
        client.set_event_callback('run_command', check_charge)
        callback_reg = true
    end

    local threat = client.current_threat()

    if not dt_charged
        and threat
        and bit.band(entity.get_prop(local_player, 'm_fFlags'), 1) == 0
        and bit.band(entity.get_esp_data(threat).flags, bit.lshift(1, 11)) == 2048 then
        ui.set(ref.aimbot, false)
    else
        ui.set(ref.aimbot, true)
    end
end)


client.set_event_callback('shutdown', function()
    ui.set(ref.aimbot, true)
    aspectratio(0)
end)


client.set_event_callback('paint', function()
    local function thirdperson(value)
        cvar.cam_idealdist:set_int(value or 70)
    end

    local function handle_aspect_ratio()
        local aspect_ratio = menu.visuals.aspectratio:get()
            and menu.visuals.aspectratio_value:get() / 25
            or 0
        aspectratio(aspect_ratio)
    end

    if menu.visuals.third_person:get() then
        thirdperson(menu.visuals.third_person_value:get())
    else
        thirdperson()
    end

    handle_aspect_ratio()
end)


client.set_event_callback('shutdown', function()
    menu.visuals.third_person_value:set(70)
end)
