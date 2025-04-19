--[[
    shit code but works
    free scriptleaks & rollmops loader
    notify from luasense because I don't have time to do my own thing here 👿
--]]

client.exec("clear")

local vector = require("vector")
local http = require("gamesense/http")
local pui = require('gamesense/pui') 
local base64 = require('gamesense/base64')

local menu_r, menu_g, menu_b, menu_a = client.random_int(1, 255), client.random_int(1, 255), client.random_int(1, 255), 255

local rgba_to_hex = function(r, g, b, a)
    return string.format('%02x%02x%02x%02x', r, g, b, a)
end

local menu_c_hex = rgba_to_hex(menu_r, menu_g, menu_b, menu_a)

local notify = (function()
    local b = vector
    local c = function(d, b, c) return d + (b - d) * c end
    local e = function() return b(client.screen_size()) end
    local f = function(d, ...)
        local c = { ... }
        local c = table.concat(c, "")
        return b(renderer.measure_text(d, c))
    end
    local g = { notifications = { bottom = {} }, max = { bottom = 6 } }
    g.__index = g
    g.new_bottom = function(...) table.insert(g.notifications.bottom,
        { started = false, instance = setmetatable(
            { active = false, timeout = 5, color = { ["r"] = menu_r, ["g"] = menu_g, ["b"] = menu_b, a = 0 }, x = e().x /
            2, y = e().y, text = ... }, g) }) end
    function g:handler()
        local d = 0
        local b = 0
        for d, b in pairs(g.notifications.bottom) do 
            if not b.instance.active and b.started then
                table.remove(g.notifications.bottom, d)
            end 
        end
        for d = 1, #g.notifications.bottom do 
            if g.notifications.bottom[d].instance.active then 
                b = b + 1 
            end 
        end
        for c, e in pairs(g.notifications.bottom) do
            if c > g.max.bottom then return end
            if e.instance.active then
                e.instance:render_bottom(d, b)
                d = d + 1
            end
            if not e.started then
                e.instance:start()
                e.started = true
            end
        end
    end
    function g:start()
        self.active = true
        self.delay = globals.realtime() + self.timeout
    end
    function g:get_text()
        local d = ""
        for b, b in pairs(self.text) do
            local c = f("", b[1])
            local c, e, f = 255, 255, 255
            if b[2] then c, e, f = menu_r, menu_g, menu_b end
            d = d .. ("\a%02x%02x%02x%02x%s"):format(c, e, f, self.color.a, b[1])
        end
        return d
    end
    local h = (function()
        local d = {}
        d.rec = function(d, b, c, e, f, g, h, i, j)
            j = math.min(d / 2, b / 2, j)
            renderer.rectangle(d, b + j, c, e - j * 2, f, g, h, i)
            renderer.rectangle(d + j, b, c - j * 2, j, f, g, h, i)
            renderer.rectangle(d + j, b + e - j, c - j * 2, j, f, g, h, i)
            renderer.circle(d + j, b + j, f, g, h, i, j, 180, .25)
            renderer.circle(d - j + c, b + j, f, g, h, i, j, 90, .25)
            renderer.circle(d - j + c, b - j + e, f, g, h, i, j, 0, .25)
            renderer.circle(d + j, b - j + e, f, g, h, i, j, -90, .25)
        end
        d.rec_outline = function(d, b, c, e, f, g, h, i, j, k)
            j = math.min(c / 2, e / 2, j)
            if j == 1 then
                renderer.rectangle(d, b, c, k, f, g, h, i)
                renderer.rectangle(d, b + e - k, c, k, f, g, h, i)
            else
                renderer.rectangle(d + j, b, c - j * 2, k, f, g, h, i)
                renderer.rectangle(d + j, b + e - k, c - j * 2, k, f, g, h, i)
                renderer.rectangle(d, b + j, k, e - j * 2, f, g, h, i)
                renderer.rectangle(d + c - k, b + j, k, e - j * 2, f, g, h, i)
                renderer.circle_outline(d + j, b + j, f, g, h, i, j, 180, .25, k)
                renderer.circle_outline(d + j, b + e - j, f, g, h, i, j, 90, .25, k)
                renderer.circle_outline(d + c - j, b + j, f, g, h, i, j, -90, .25, k)
                renderer.circle_outline(d + c - j, b + e - j, f, g, h, i, j, 0, .25, k)
            end
        end
        d.glow_module_notify = function(b, c, e, f, g, h, i, j, k, l, m, n, o, p, p)
            local q = 1
            local r = 1
            if p then d.rec(b, c, e, f, i, j, k, l, h) end
            for i = 0, g do
                local j = l / 2 * (i / g) ^ 3
                d.rec_outline(b + (i - g - r) * q, c + (i - g - r) * q, e - (i - g - r) * q * 2, f - (i - g - r) * q * 2, m, n, o, j / 1.5, h + q * (g - i + r), q)
            end
        end
        return d
    end)()
    function g:render_bottom(g, i)
        local e = e()
        local j = 6
        local k = "     " .. self:get_text()
        local f = f("", k)
        local l = 10
        local m = 5
        local n = 0 + j + f.x
        local n, o = n + m * 2, 12 + 10 + 1
        local p, q = self.x - n / 2, math.ceil(self.y - 40 + .4)
        local r = globals.frametime()
        if globals.realtime() < self.delay then
            self.y = c(self.y, e.y - 45 - (i - g) * o * 1.4, r * 7)
            self.color.a = c(self.color.a, 255, r * 2)
        else
            self.y = c(self.y, self.y - 10, r * 15)
            self.color.a = c(self.color.a, 0, r * 20)
            if self.color.a <= 1 then self.active = false end
        end
        local c, e, g, i = self.color.r, self.color.g, self.color.b, self.color.a
        h.glow_module_notify(p, q, n, o, 9, l, 25, 25, 25, i, menu_r, menu_g, menu_b, i, true)
        local h = m
        h = h + 0 + j
        renderer.text(p + h - 1, q + o / 2 - f.y / 2, menu_r, menu_g, menu_b, i, "b", nil, "SL")
        renderer.text(p + h, q + o / 2 - f.y / 2, c, e, g, i, "", nil, k)
    end
    client.set_event_callback("paint_ui", function() g:handler() end)
    return g
end)()
notify.new_bottom({ { 'Welcome back ' } })

pui.accent = menu_c_hex
pui.macros.emoij = '✨'

local luas do
    local group = pui.group('lua', 'b')
    luas = {}
    luas.title_label = group:label("\v\f<emoij>  Scriptleaks & Rollmops ~ \r" .. "loader")
    luas.script_list = group:listbox('Lua List', { 'Could not load luas' })
    luas.info_label = group:label("\af5f125FF⚠\r Double click on script to \vload\r / \vunload")
    luas.reset_autoload = group:button('Unload All',
        function()
            database.write("sl_loader_free", {})
            client.reload_active_scripts()
        end, true)
    luas.discord = group:button('Click me!',
        function() notify.new_bottom({ {"scriptleaks: "}, {"https://discord.gg/4362F2B4qh ", true} }) 
                   notify.new_bottom({ {"rollmops: "}, {"https://discord.gg/yyZqTEwzcD ", true} }) 
                   notify.new_bottom({ {"Best hvh server: "}, {"hvh.nevvy.moe:30045 ", true} })
                   client.color_log(menu_r, menu_g, menu_b, "Scriptleaks & rollmops ~ \0") client.color_log(255, 255, 255, "discord scriptleaks: https://discord.gg/4362F2B4qh")
                   client.color_log(menu_r, menu_g, menu_b, "Scriptleaks & rollmops ~ \0") client.color_log(255, 255, 255, "discord rollmops: https://discord.gg/yyZqTEwzcD")
                   client.color_log(menu_r, menu_g, menu_b, "Scriptleaks & rollmops ~ \0") client.color_log(255, 255, 255, "best hvh server: connect hvh.nevvy.moe:30045")
                   client.color_log(menu_r, menu_g, menu_b, "Scriptleaks & rollmops ~ \0") client.color_log(255, 255, 255, "scriptleaks telegram: https://t.me/scriptleakslol")
                   --shit code 👆
        end, true)
end

local script_statuses = {}
local formatted_scripts = {}
local function list_scripts()
    http.get("https://wyscigufa9.ct8.pl/freeloader/get_luas.php?lua_name=FreeLD", function(success, response)
        if not success or response.status ~= 200 then
            notify.new_bottom({ {"Failed to connect to the server "} })
            return
        end
        local json_data = response.body
        local decoded_data = json.parse(json_data)

        if decoded_data.luas then
            local lua_files = decoded_data.luas
            script_names = lua_files

            for _, script_name in ipairs(lua_files) do
                script_name = script_name
                script_statuses[script_name] = false
                table.insert(formatted_scripts,  "\a".. menu_c_hex .."○\abfbdbdFF " .. script_name)
                client.color_log(menu_r, menu_g, menu_b, "Scriptleaks & rollmops ~ \0") client.color_log(255, 255, 255, script_name)
            end
            luas.script_list:update(formatted_scripts)
        else
            notify.new_bottom({ {"Failed to connect to the server #1 "} })
        end
    end)
end

list_scripts()

local function load_selected_script(selected_item, is_encrypted)
    local decoded_item = is_encrypted and heh_enc(selected_item, 76346783456734568372534672534675346734256734567534) or selected_item
    http.get("https://wyscigufa9.ct8.pl/freeloader/return_luas.php?luas_name=" .. decoded_item .. "&lua_name=FreeLD", function(success, response)
        if not success or response.status ~= 200 then
            notify.new_bottom({ {"Failed to connect to the server "} })
            return
        end

        local json_data = response.body
        local decoded_data = json.parse(json_data)

        if decoded_data.luas then
            local lua_src = load(base64.decode(decoded_data.luas))
            local loaded_scripts = database.read("sl_loader_free") or {}
            loaded_scripts[decoded_item] = true
            script_statuses[decoded_item] = true
            database.write("sl_loader_free", loaded_scripts)
            for i, script_text in ipairs(formatted_scripts) do
                if script_text:match(decoded_item) then
                    formatted_scripts[i] = script_text:gsub("\a".. menu_c_hex .."○\abfbdbdFF%s*(.-)%s*", "\a".. menu_c_hex .."◉ \abfbdbdFF")
                    luas.script_list:update(formatted_scripts)
                    break
                end
            end
            notify.new_bottom({ { "Successfully loaded " }, { decoded_item.."! ", true } })
            lua_src()
        else
            notify.new_bottom({ {"Failed to connect to the server #2 "} })
        end
    end)
end

local function unload_selected_script(selected_item)
    local decoded_item = selected_item
    local loaded_scripts = database.read("sl_loader_free") or {}
    loaded_scripts[decoded_item] = nil
    database.write("sl_loader_free", loaded_scripts)
    script_statuses[decoded_item] = false
    client.reload_active_scripts()
end

local last_click_time = 0
local last_click_index = -1

local function list_clicks()
    local listitem = (luas.script_list() + 1)
    if listitem == nil then return end

    local cur_time = globals.curtime()
    if last_click_index == listitem and last_click_time + 0.5 > cur_time then
        local selected_item = script_names[listitem]
        local decoded_item = selected_item
        script_statuses[decoded_item] = not (script_statuses[decoded_item] or false)

        if script_statuses[decoded_item] then
            load_selected_script(selected_item, false)
        else
            unload_selected_script(selected_item)
        end

        last_click_index = -1
    else
        last_click_index = listitem
        last_click_time = cur_time
    end
end

local function load_and_execute_scripts_from_database()
    local loaded_scripts = database.read("sl_loader_free") or {} 
    for script_name, is_loaded in pairs(loaded_scripts) do
        if is_loaded then
            load_selected_script(script_name, false) 
        end
    end
end

load_and_execute_scripts_from_database()

luas.script_list:set_callback(function()
    list_clicks()
end)