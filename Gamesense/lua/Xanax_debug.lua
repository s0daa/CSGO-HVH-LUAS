-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
--     #######################################################################################################
--   ###########################################################################################################
--  ##                                                                                                         ##
--  ##   xxxxx       xxxxx         xxxxxxxxx       xxxx       xxx        xxxxxxxxx      xxxxx       xxxxx      ##
--  ##    xxxxx     xxxx          xxxxxxxxxxx      xxxxxxx    xxx       xxxxxxxxxxx      xxxxx     xxxxx       ##
--  ##      xxxxxxxxxx           xxxx     xxxx     xxxx  xxxx xxx      xxxx     xxxx        xxxxxxxxxx         ##
--  ##    xxxxx     xxxxxx      xxxxxxxxxxxxxxx    xxxx    xxxxxx     xxxxxxxxxxxxxxx     xxxxx    xxxxx       ##
--  ##  xxxxxx       xxxxxxx   xxxx        xxxxx   xxxx      xxxx    xxxx        xxxxx  xxxxxx       xxxxxx    ##
--  ##                                                                                                         ##
--   ###########################################################################################################
--     #######################################################################################################

--                                      xanax.lua created by the Wombat (GAMESENSE)
--                                       discord.gg/F7ggu6jgJN |  wombat#0001

-- [DEPENDENCIES]:

-- default
local ffi = require "ffi"
local bit = require "bit"
local vector = require "vector"
-- libs
local http = require "gamesense/http"
local base64 = require "gamesense/base64"
local steamworks = require "gamesense/steamworks"
local anti_aim = require 'gamesense/antiaim_funcs'
local easing = require 'gamesense/easing'
local clipboard = require "gamesense/clipboard"

local notify = {} notify.__index = notify notify.invoke_callback = function(timeout) return setmetatable({ active = false, delay = 0, laycoffset = -11, layboffset = -11 }, notify) end notify.setup_color = function(color, sec_color) if type(color) ~= 'table' then notify:setup() return end if notify.color == nil then notify:setup() end if color ~= nil then notify.color[1] = color end if sec_color ~= nil then notify.color[2] = sec_color end end notify.add = function(time, is_right, ...) if notify.color == nil then notify:setup() end table.insert(notify.__list, { ["tick"] = globals.tickcount(), ["invoke"] = notify.invoke_callback(), ["text"] = { ... }, ["time"] = time, ["color"] = notify.color, ["right"] = is_right, ["first"] = false }) end function notify:setup() notify.color = { { 150, 185, 1 }, { 0, 0, 0 } } if notify.__list == nil then notify.__list = {} client.delay_call(0.05, function() notify.setup_color({ 25, 118, 210 }) end) end end function notify:listener() local count_left = 0 local count_right = 0 local old_tick = 0 if notify.__list == nil then notify:setup() end for i=1, #notify.__list do local layer = notify.__list[i] if layer.tick ~= old_tick then notify:setup() end if layer.right == true then layer.invoke:show_right(count_right, layer.color, layer.text) if layer.invoke.active then count_right = count_right + 1 end else layer.invoke:show(count_left, layer.color, layer.text) if layer.invoke.active then count_left = count_left + 1 end end if layer.first == false then layer.invoke:start(layer.time) notify.__list[i]["first"] = true end old_tick = layer.tick end end function notify:start(timeout) self.active = true self.delay = globals.realtime() + timeout end function notify:get_text_size(lines_combo) local x_offset_text = 0 for i=1, #lines_combo do local r, g, b, message = unpack(lines_combo[i]) local width, height = renderer.measure_text("", message) x_offset_text = x_offset_text + width end return x_offset_text end function notify:string_ends_with(str, ending) return ending == "" or str:sub(-#ending) == ending end function notify:multicolor_text(x, y, flags, lines_combo) local line_height_temp = 0 local x_offset_text = 0 local y_offset = 0 for i=1, #lines_combo do local r, g, b, message = unpack(lines_combo[i]) message = message .. "\0" renderer.text(x + x_offset_text, y + y_offset, r, g, b, 255, flags, 0, message) if self:string_ends_with(message, "\0") then local width, height = renderer.measure_text(flags, message) x_offset_text = x_offset_text + width else x_offset_text = 0 y_offset = y_offset + line_height_temp end end end function notify:show(count, color, text) if self.active ~= true then return end local x, y = client.screen_size() local y = 5 + (27 * count) local text_w, text_h = self:get_text_size(text) local max_width = text_w local max_width = max_width < 150 and 150 or max_width if color == nil then color = self.color end local factor = 255 / 25 * globals.frametime() if globals.realtime() < self.delay then if self.laycoffset < max_width then self.laycoffset = self.laycoffset + (max_width - self.laycoffset) * factor end if self.laycoffset > max_width then self.laycoffset = max_width end if self.laycoffset > max_width / 1.09 then if self.layboffset < max_width - 6 then self.layboffset = self.layboffset + ((max_width - 6) - self.layboffset) * factor end end if self.layboffset > max_width - 6 then self.layboffset = max_width - 6 end else if self.layboffset > -11 then self.layboffset = self.layboffset - (((max_width-5)-self.layboffset) * factor) + 0.01 end if self.layboffset < (max_width - 11) and self.laycoffset >= 0 then self.laycoffset = self.laycoffset - (((max_width + 1) - self.laycoffset) * factor) + 0.01 end if self.laycoffset < 0 then self.active = false end end renderer.rectangle(self.laycoffset - self.laycoffset, y, self.laycoffset + 16, 25, color[1][1], color[1][2], color[1][3], 255) renderer.rectangle(self.layboffset - self.laycoffset, y, self.layboffset + 22, 25, color[2][1], color[2][2], color[2][3], 255) self:multicolor_text(self.layboffset - max_width + 11, y + 6, "", text) end function notify:show_right(count, color, text) if self.active ~= true then return end local x, y = client.screen_size() local y = y - 68 - (27 * count) local text_w, text_h = self:get_text_size(text) local max_width = text_w + 22 local max_width = max_width < 150 and 150 or max_width if color == nil then color = self.color end local factor = 255 / 25 * globals.frametime() if globals.realtime() < self.delay then if self.laycoffset < max_width then self.laycoffset = self.laycoffset + (max_width - self.laycoffset) * factor end if self.laycoffset > max_width then self.laycoffset = max_width end if self.laycoffset > max_width / 1.09 then if self.layboffset < max_width - 6 then self.layboffset = self.layboffset + ((max_width - 6) - self.layboffset) * factor end end if self.layboffset > max_width - 6 then self.layboffset = max_width - 6 end else if self.layboffset > 0 then self.layboffset = self.layboffset - (((max_width-5)-self.layboffset) * factor) + 0.01 end if self.layboffset < (max_width - 11) and self.laycoffset >= 0 then self.laycoffset = self.laycoffset - (((max_width + 1) - self.laycoffset) * factor) + 0.01 end if self.laycoffset < 0 then self.active = false end end renderer.rectangle(x - self.laycoffset + 3, y, self.laycoffset + 3 + self.laycoffset, 25, color[1][1], color[1][2], color[1][3], 255) renderer.rectangle(x - self.layboffset + 3, y, self.layboffset + 3 + self.layboffset, 25, color[2][1], color[2][2], color[2][3], 255) self:multicolor_text(x - self.layboffset + 10, y + 6, "", text) end

-- obex.pink vars
local obex_data = obex_fetch and obex_fetch() or {username = 'UNKNOWN', build = 'Source'}
local username = obex_data.username
local build = obex_data.build

local ISteamUser = steamworks.ISteamUser
-- # VARS & FUNCTIONS

-- MYZARFIN COLORLOG
local client_color_log, type = client.color_log, type; local colorful_text = {}; colorful_text.lerp = function(self, from, to, duration) if type(from) == 'table' and type(to) == 'table' then return { self:lerp(from[1], to[1], duration), self:lerp(from[2], to[2], duration), self:lerp(from[3], to[3], duration) }; end return from + (to - from) * duration; end colorful_text.console = function(self, ...) for i, v in ipairs({ ... }) do if type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then for k = 1, #v[3] do local l = self:lerp(v[1], v[2], k / #v[3]); client_color_log(l[1], l[2], l[3], v[3]:sub(k, k) .. '\0'); end elseif type(v[1]) == 'table' and type(v[2]) == 'string' then client_color_log(v[1][1], v[1][2], v[1][3], v[2] .. '\0'); end end end colorful_text.text = function(self, ...) local menu = false; local alpha = 255 local f = ''; for i, v in ipairs({ ... }) do if type(v) == 'boolean' then menu = v; elseif type(v) == 'number' then alpha = v; elseif type(v) == 'string' then f = f .. v; elseif type(v) == 'table' then if type(v[1]) == 'table' and type(v[2]) == 'string' then f = f .. ('\a%02x%02x%02x%02x'):format(v[1][1], v[1][2], v[1][3], alpha) .. v[2]; elseif type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then for k = 1, #v[3] do local g = self:lerp(v[1], v[2], k / #v[3]) f = f .. ('\a%02x%02x%02x%02x'):format(g[1], g[2], g[3], alpha) .. v[3]:sub(k, k) end end end end return ('%s\a%s%02x'):format(f, (menu) and 'cdcdcd' or 'ffffff', alpha); end colorful_text.log = function(self, ...) for i, v in ipairs({ ... }) do if type(v) == 'table' then if type(v[1]) == 'table' then if type(v[2]) == 'string' then self:console({ v[1], v[1], v[2] }) if (v[3]) then self:console({ { 255, 255, 255 }, '\n' }) end elseif type(v[2]) == 'table' then self:console({ v[1], v[2], v[3] }) if v[4] then self:console({ { 255, 255, 255 }, '\n' }) end end elseif type(v[1]) == 'string' then self:console({ { 205, 205, 205 }, v[1] }); if v[2] then self:console({ { 255, 255, 255 }, '\n' }) end end end end end

local function time_to_ticks(time)
	return math.floor(time / globals.tickinterval() + .5)
end

local function set_visiblity(b,c)for d,e in pairs(b)do if type(e)=='table'then set_visiblity(e,c)else ui.set_visible(e,c)end end end
local function contains(b,c)for d,e in pairs(b)do if e==c then return true end end;return false end
local function lerp(b,c,d)if type(b)=='table'and type(c)=='table'then return{lerp(b[1],c[1],d),lerp(b[2],c[2],d),lerp(b[3],c[3],d)}end;return b+(c-b)*d end
local function blendMenuText(b,c,d)local e=""for f=1,#d do local g=lerp(b,c,f/#d)e=e..("\a%02x%02x%02xFF"):format(g[1],g[2],g[3])..d:sub(f,f)end;return e.."\aCDCDCDFF"end
local function blendConsoleLog(b,c,d)local e,f,g=b[1],b[2],b[3]local h,i,j=c[1],c[2],c[3]for k=1,#d do local l=lerp(b,c,k/#d)client.color_log(l[1],l[2],l[3],d:sub(k,k).."\0")end end

local function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local fps_prev = 0
local ft_prev = 0
local function get_fps()
	ft_prev = ft_prev * 0.9 + globals.absoluteframetime() * 0.1
	return round(1 / ft_prev)
end

local has_discord = false
-- # MENU

-- welcome text
function newLine() ui.new_label("CONFIG", "Presets", "\n") end

if(build ~= 'Source') then
    client.exec("clear")
end

blendConsoleLog({ 255, 102, 102 }, { 189, 24, 9 }, "              _________\n")
blendConsoleLog({ 255, 102, 102 }, { 189, 24, 9 }, "             {_________}\n")
blendConsoleLog({ 255, 102, 102 }, { 189, 24, 9 }, "              )=======(\n")
blendConsoleLog({ 255, 102, 102 }, { 189, 24, 9 }, "             /         \\\n")
blendConsoleLog({ 255, 102, 102 }, { 189, 24, 9 }, "            | _________ |\n")
blendConsoleLog({ 255, 102, 102 }, { 189, 24, 9 }, "            ||   _     ||\n" )
blendConsoleLog({ 255, 102, 102 }, { 189, 24, 9 }, "            ||  |_)    ||\n" )
blendConsoleLog({ 255, 102, 102 }, { 189, 24, 9 }, "            ||  | \\/   ||\n" )
blendConsoleLog({ 255, 102, 102 }, { 189, 24, 9 }, "      __    ||    /\\   ||\n" )
blendConsoleLog({ 255, 102, 102 }, { 189, 24, 9 }, " __  (_|)   |'---------'|\n")
blendConsoleLog({ 255, 102, 102 }, { 189, 24, 9 }, "(_|)        `-.........-'\n")
blendConsoleLog({ 255, 102, 102 }, { 189, 24, 9 }, "     xanax.lua " .. username .. " (" .. build .. ") \n"  )
blendConsoleLog({ 255, 102, 102 }, { 189, 24, 9 }, "\n\n"  )

newLine()
local menuStartText = ui.new_label("CONFIG", "Presets", (
    "           " .. colorful_text:text(
        { { 158, 158, 158 }, "--===[ ", true },
        { { 255, 102, 102 }, { 189, 24, 9 }, "xanax", true },
        { { 158, 158, 158 }, " ]===--", true }
    ) .. "           "
))

local menuFeature = ui.new_combobox("CONFIG", "Presets", (
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "features", true }
    )
), "clantag", "killsay", "indicators", "logs", "server browser", "cloud")

-- AA ------------------------------------------------------------------------------------------------------------------------------
local edge_yaws = ui.reference("AA", "Anti-Aimbot Angles", "Edge yaw")
local edge_yaw_bind = ui.new_hotkey("AA", "Anti-Aimbot Angles", "Edge yaw", false)

local aa_type = ui.new_combobox("AA", "Anti-Aimbot Angles", (
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "mode", true }
    )
), "none", "presets", "builder")

local aa_preset = ui.new_listbox("AA", "Anti-Aimbot Angles", 
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "presets", true }
    )
, {"none"})

local http_data = {
    ['api-key'] = 'Cwzc8YGvOWnPHyjFc0Od', -- password
}

local function decodeAngles (number)
    local values = mysplit(number, ',')
    local returnValue = ""

    for i,v in ipairs(values) do
        if(string.find(v, "/")) then
            local random = mysplit(values[i], "/")

            for i2,v2 in ipairs(random) do
                random[i2] = (random[i2] - 15) / 12
            end

            values[i] = table.concat(random, '/')
        else
            values[i] = (values[i] - 15) / 12
        end
    end

    return table.concat(values, ',')
end

local presets      = {}
local preset_names = {}

http.get("https://gamesenseloader.vip:8443/xanax/assets/", {headers = http_data, require_ssl = true}, function(success, response)
    local aa_preset_saved = json.parse(response.body)

    for index, value in pairs(aa_preset_saved) do

        local vars = {
            yaw_base_amount   = "yaw_base_amount",
            yaw_jitter_amount = "yaw_jitter_amount",
            body_yaw_amount   = "body_yaw_amount",
            fakelag_amount    = "fakelag_amount",
            fakelag_variance  = "fakelag_variance",
        }

        for i,v in pairs(vars) do
            aa_preset_saved[index][vars[i]] = decodeAngles(aa_preset_saved[index][vars[i]])
        end

    end

    presets = aa_preset_saved

    table.insert(preset_names, 'none')

    for index, value in pairs(presets) do
        table.insert(preset_names, presets[index]['name'])
    end

    ui.update(aa_preset, preset_names)
end)

local aa_builder_state = ui.new_combobox("AA", "Anti-Aimbot Angles", (
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "state", true }
    )
), "standing", "running", "in-air", "slow walk")

local standing = {
    modifier = ui.new_combobox("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "yaw", true })), "Off", "180 Z", "Spin", "Static"),
    offset = (ui.new_slider("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "offset", true })), -180, 180, 0, true)),

    jitter = ui.new_combobox("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "jitter", true })), "Off", "Center", "Center", "Random"),
    jitter_offset = (ui.new_slider("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "offset", true })), -180, 180, 0, true)),

    body_yaw = ui.new_combobox("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "body yaw", true })), "Off", "Opposite", "Jitter", "Static"),
    body_yaw_offset = (ui.new_slider("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "offset", true })), -180, 180, 0, true)),
}

local running = {
    modifier = ui.new_combobox("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "yaw", true })), "Off", "180 Z", "Spin", "Static"),
    offset = (ui.new_slider("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "offset", true })), -180, 180, 0, true)),

    jitter = ui.new_combobox("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "jitter", true })), "Off", "Center", "Center", "Random"),
    jitter_offset = (ui.new_slider("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "offset", true })), -180, 180, 0, true)),

    body_yaw = ui.new_combobox("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "body yaw", true })), "Off", "Opposite", "Jitter", "Static"),
    body_yaw_offset = (ui.new_slider("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "offset", true })), -180, 180, 0, true)),
}

local inair = {
    modifier = ui.new_combobox("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "yaw", true })), "Off", "180 Z", "Spin", "Static"),
    offset = (ui.new_slider("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "offset", true })), -180, 180, 0, true)),

    jitter = ui.new_combobox("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "jitter", true })), "Off", "Center", "Center", "Random"),
    jitter_offset = (ui.new_slider("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "offset", true })), -180, 180, 0, true)),

    body_yaw = ui.new_combobox("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "body yaw", true })), "Off", "Opposite", "Jitter", "Static"),
    body_yaw_offset = (ui.new_slider("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "offset", true })), -180, 180, 0, true)),
}

local slow = {
    modifier = ui.new_combobox("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "yaw", true })), "Off", "180 Z", "Spin", "Static"),
    offset = (ui.new_slider("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "offset", true })), -180, 180, 0, true)),

    jitter = ui.new_combobox("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "jitter", true })), "Off", "Center", "Center", "Random"),
    jitter_offset = (ui.new_slider("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "offset", true })), -180, 180, 0, true)),

    body_yaw = ui.new_combobox("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "body yaw", true })), "Off", "Opposite", "Jitter", "Static"),
    body_yaw_offset = (ui.new_slider("AA", "Anti-Aimbot Angles", (colorful_text:text({ { 255, 102, 102 }, { 189, 24, 9 }, "offset", true })), -180, 180, 0, true)),
}

-- VISUALS --------------------------------------------------------------------------------------------------------------------------
local watermark = ui.new_checkbox("CONFIG", "Presets", (
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "watermark", true }
    )
))
local crosshair_indicator = ui.new_combobox("CONFIG", "Presets", (
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "indicator", true }
    )
), "off", "dynamic","basic")
local crosshair_color = ui.new_color_picker("CONFIG", "Presets", "xhaircolor")
local crosshair_flags = ui.new_multiselect("CONFIG", "Presets", (
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "flags", true }
    )
), "conditional state", "dt", "hs", "baim", "fd", "quick peek", "mindmg")
-- MISC TAB -------------------------------------------------------------------------------------------------------------------------
local shotlogger_checkbox = ui.new_checkbox("CONFIG", "Presets", (
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "logs", true }
    )
))
local shotlogger_options = ui.new_multiselect("CONFIG", "Presets", (
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "options", true }
    )
), "chat", "console", "screen")
local clantag_checkbox = ui.new_checkbox("CONFIG", "Presets", (
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "clantag", true }
    )
))
local clantag_options = ui.new_combobox("CONFIG", "Presets", (
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "options", true }
    )
), "animated", "static", "rx")
local killsay = ui.new_checkbox("CONFIG", "Presets", (
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "killsay", true }
    )
))
local killsayTimer = ui.new_slider("CONFIG", "Presets", (
    colorful_text:text(
    { { 255, 102, 102 }, { 189, 24, 9 }, "delay", true }
	)
), 0, 5, 0, true, "s")
local killsaySelection = ui.new_combobox("CONFIG", "Presets", (
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "options", true }
    )
), "community", "a", "b", "c")

local killsayInfo = ui.new_label("CONFIG", "Presets", 
    "* lists A-C require you to link your discord to modify."
)
-- CLOUD TAB ------------------------------------------------------------------------------------------------------------------------\

local cloudEnabled = ui.new_checkbox("CONFIG", "Presets", (
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "stop cloud", true }
    )
))

ui.set(cloudEnabled, false)

local cloudIncognito = ui.new_checkbox("CONFIG", "Presets", (
    colorful_text:text(
        { { 255, 102, 102 }, { 189, 24, 9 }, "incognito", true }
    )
))
local cloudButton = ui.new_button("CONFIG", "Presets", "GET DISCORD CODE", function()
    local http_data = {
        ['api-key'] = 'Cwzc8YGvOWnPHyjFc0Od', -- password
        ['username'] = username, -- username
    }

    http.get("https://gamesenseloader.vip:8443/xanax/discord/code", {headers = http_data, require_ssl = true}, function(success, response)
        if not success or response.status ~= 200 or response == 'u_u' then
            return print('Cloud Services are not currently unreachable...')
        end

        if(response.body ~= "u_u" and response.body ~= "alr") then
            print("code: " .. response.body)
            notify.add(10, false, { 189, 76, 68, "Your code was copied to clipboard. " }, { 219, 219, 219, "(" .. response.body .. ")" })
            clipboard.set(response.body)
        elseif(response.body == "alr") then
            print("You already have a discord account linked. If you believe this is an error, contact a moderator.")
            notify.add(10, false, { 189, 76, 68, "Error. " }, { 219, 219, 219, "You already have an account linked." })
        else
            print("Failed to get code.")
            notify.add(10, false, { 189, 76, 68, "Error. " }, { 219, 219, 219, "Failed to reach." })
        end

    end)
end)

function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

-- SERVER BROWSER TAB + CODE
local servers_http_headers = {
    ['api-key'] = 'Cwzc8YGvOWnPHyjFc0Od', -- password
}
local servers_names = {}
local servers_ips = {}

local selection = 0

function connect()
    client.exec('connect ' .. servers_ips[selection + 1])
end

local server_join = ui.new_button("CONFIG", "Presets", "Connect", connect)    
local servers_select = ui.new_listbox("CONFIG", "Presets", "Servers", {"none"})

http.get("https://gamesenseloader.vip:8443/xanax/servers/", {headers = servers_http_headers, require_ssl = true}, function(success, response)
    serverList = json.parse(response.body)
    
    for index, value in ipairs(serverList) do
        local data = mysplit(value, "/")

        servers_names[table.getn(servers_names) + 1] = data[1]
        servers_ips[table.getn(servers_ips) + 1] = data[2]
    end

    ui.update(servers_select, servers_names)
end)
-------------------------------------------------------------------------------------------------------------------------------------
local function hsv_to_rgb(h, s, v)
    local r, g, b

    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return r * 255, g * 255, b * 255
end

local string_okay = {}

local j2 = 0
local u2 = 0

local function hsv_to_rgb(h, s, v)
    local r, g, b

    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return r * 255, g * 255, b * 255
end


local function vmt_entry(instance, index, type)
	return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end

local function vmt_thunk(index, typestring)
	local t = ffi.typeof(typestring)
	return function(instance, ...)
		assert(instance ~= nil)
		if instance then
			return vmt_entry(instance, index, t)(instance, ...)
		end
	end
end

local function vmt_bind(module, interface, index, typestring)
	local instance = client.create_interface(module, interface) or error("invalid interface")
	local fnptr = vmt_entry(instance, index, ffi.typeof(typestring)) or error("invalid vtable")
	return function(...)
		return fnptr(instance, ...)
	end
end


local function gamesense_anim(indices)
	local text_anim = "xanax"
	local tickinterval = globals.tickinterval()
	local tickcount = globals.tickcount() + time_to_ticks(globals.curtime() / 1000)
	local i = tickcount / time_to_ticks(0.3)
	i = math.floor(i % #indices)
	i = indices[i+1]+1

    if(i < 2) then
        return ('℞')	
    elseif(i < 4) then
        return ('℞ x')
    elseif(i < 6) then
        return ('℞ xa')
    elseif(i < 8) then
        return ('℞ xan')
    elseif(i < 10) then
        return ('℞ xana')
    elseif(i < 17) then
        return ('℞ xanax')
    elseif(i < 18) then
        return ('℞ xana')
    elseif(i < 20) then
        return ('℞ xan')
    elseif(i < 22) then
        return ('℞ xa')
    elseif(i < 24) then
        return ('℞ x')
    elseif(i < 26) then
        return ('℞')
    else
        return ('℞')
    end
end

local function run_tag_animation()
	if ui.get(clantag_checkbox) then
        needsReset = true
		local clan_tag = gamesense_anim({0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36})
		if(ui.get(clantag_options) == "static") then
            client.set_clan_tag("℞ xanax")
        elseif(ui.get(clantag_options) == "rx") then
            client.set_clan_tag("℞")
        else
            if (clan_tag ~= clan_tag_prev and ui.get(clantag_checkbox) ~= false) then
                client.set_clan_tag(clan_tag)
            end
            clan_tag_prev = clan_tag
        end

	end
end

local function clantagtab(status)
    ui.set_visible(clantag_checkbox, status)
    if(ui.get(clantag_checkbox)) then
        ui.set_visible(clantag_options, status)
    else
        ui.set_visible(clantag_options, false)
    end
end

local function killsaytab(status)
    ui.set_visible(killsay, status)
    if(ui.get(killsay)) then
        ui.set_visible(killsayTimer, status)
        ui.set_visible(killsaySelection, status)
        ui.set_visible(killsayInfo, status)
    else
        ui.set_visible(killsayTimer, false)
        ui.set_visible(killsaySelection, false)
        ui.set_visible(killsayInfo, false)
    end
end

local function indicatortab(status)
    ui.set_visible(watermark, status)
    ui.set_visible(crosshair_indicator, status)
    if(ui.get(crosshair_indicator) ~= 'off') then
        if(ui.get(crosshair_indicator) == 'basic') then
            ui.set_visible(crosshair_color, status)
        end
        ui.set_visible(crosshair_flags, status) 
    else
        ui.set_visible(crosshair_color, false)
        ui.set_visible(crosshair_flags, false) 
    end

end

local function logtab(status)
    ui.set_visible(shotlogger_checkbox, status)
    if(ui.get(shotlogger_checkbox) and status) then
        ui.set_visible(shotlogger_options, true)
    else
        ui.set_visible(shotlogger_options, false)
    end
end

local function serverbrowsertab(status)
    ui.set_visible(servers_select, status)
    ui.set_visible(server_join, status)
end

local function cloudtab(status)
    ui.set_visible(cloudEnabled, status)
    ui.set_visible(cloudIncognito, status)
    ui.set_visible(cloudButton, status)
end

local function standingTab(status)
    local s = standing
    ui.set_visible(s.modifier, status)
    ui.set_visible(s.offset, status)
    ui.set_visible(s.jitter, status)
    ui.set_visible(s.jitter_offset, status)
    ui.set_visible(s.body_yaw, status)
    ui.set_visible(s.body_yaw_offset, status)
end

local function runningTab(status)
    local s = running
    ui.set_visible(s.modifier, status)
    ui.set_visible(s.offset, status)
    ui.set_visible(s.jitter, status)
    ui.set_visible(s.jitter_offset, status)
    ui.set_visible(s.body_yaw, status)
    ui.set_visible(s.body_yaw_offset, status)
end

local function inairTab(status)
    local s = inair
    ui.set_visible(s.modifier, status)
    ui.set_visible(s.offset, status)
    ui.set_visible(s.jitter, status)
    ui.set_visible(s.jitter_offset, status)
    ui.set_visible(s.body_yaw, status)
    ui.set_visible(s.body_yaw_offset, status)
end

local function slowTab(status)
    local s = slow
    ui.set_visible(s.modifier, status)
    ui.set_visible(s.offset, status)
    ui.set_visible(s.jitter, status)
    ui.set_visible(s.jitter_offset, status)
    ui.set_visible(s.body_yaw, status)
    ui.set_visible(s.body_yaw_offset, status)
end

-- [SCRIPTS]

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local player_list = {}
local fail_counter = 0

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function cloudHeartbeat()

    local steam64 = ISteamUser.GetSteamID()

    local http_data = {
        ['api-key'] = 'Cwzc8YGvOWnPHyjFc0Od', -- password
        ['username'] = username, -- username
        ['steam64'] = steam64,
        ['incognito'] = ui.get(cloudIncognito),
        ['cheat'] = 'gamesense'
    }

    http.get("https://gamesenseloader.vip:8443/xanax/hb/", {headers = http_data, require_ssl = true}, function(success, response)
        if not success or response.status ~= 200 then
            if(fail_counter == 0) then
                print('Cloud Services are not currently reachable...')
                fail_counter = fail_counter + 1
            elseif(fail_counter <= 4) then
                fail_counter = fail_counter + 1
            else
                print('Turning off cloud, the servers are not reachable.')
                ui.set(cloudEnabled, true)
            end

            return
        end
        
        fail_counter = 0
        local i = 0
        local list = response.body
        
        if(list ~= nil) then
            for word in string.gmatch(list, '([^;]+)') do
                i = i + 1
                player_list[i] = word
            end
        end

    end)

    return
end

-- [ANTIAIM]

local antiaim = {
    --angles
    angles = {
        yaw_base               = { ui.reference("AA", "Anti-aimbot angles", "Yaw") }, 
        -- [0] multi
        -- Off, 180, Spin, Static, 180 Z, Crosshair
        -- [1] slider
        -- -180 to 180
        yaw_jitter        = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
        -- [0] multi
        -- Off, Offset, Center, Random
        -- [1] slider
        -- -180 to 180
        body_yaw          = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
        -- [0] multi
        -- Off, Opposite, Jitter, Static
        -- [1] slider
        -- -180, 180
        freestanding_b_y  = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
        -- true or false, 1 or 0
        fake_yaw_limit    = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
        -- 0 to 60
        freestanding      = ui.reference("AA", "Anti-aimbot angles", "Freestanding"),
        -- [1]
        -- Default
        roll_amount       = ui.reference("AA", "Anti-aimbot angles", "Roll"),
        -- -50 to 50
    },
    --fakelag
    fakelag = {
        mode   = ui.reference("AA", "Fake lag", "Amount"),
        -- Dynamic, Maximum, Fluctuate
        variance = ui.reference("AA", "Fake lag", "Variance"),
        -- 0 to 100 (%)
        amount = ui.reference("AA", "Fake lag", "Limit")
        -- 1 to 15
    },
    --misc
    other = {
        slow_motion = { ui.reference("AA", "Other", "Slow motion") },
        fake_duck = ui.reference("RAGE", "Other", "Duck peek assist"),
    }
}
--ANTI AIM
local function GetState(player)
    local local_player     = entity.get_local_player()
    --local x, y, z          = entity.get_prop(local_player, "m_vecVelocity[0]"), entity.get_prop(local_player, "m_vecVelocity[1]"), entity.get_prop(local_player, "m_vecVelocity[2]")
    local local_velocity   = vector(x, y, z)
    local velo             = vector(entity.get_prop(local_player, 'm_vecVelocity'))
    local is_fake_ducking  = ui.get(antiaim.other.fake_duck)
    local is_slow_motion   = ui.get(antiaim.other.slow_motion[2])
    local is_crouching     = entity.get_prop(local_player, "m_flDuckAmount") > 0.5 and (not is_fake_ducking)
    local is_jumping       = bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 0
    local is_standing      = math.abs(velo.x) < 4 or math.abs(velo.y) < 4
    local is_running       = math.abs(velo.x) > 90 or math.abs(velo.y) > 90

    if is_slow_motion then  
        return 'slow walk'
    elseif is_crouching and is_jumping then
        return 'c in air'
    elseif is_crouching then
        return 'crouch'
    elseif is_jumping then
        return 'in air'
    elseif is_standing then 
        return 'standing'
    elseif is_running then
        return 'running'
    else
        return 'none'
    end
end

-- [LOGS]

local pairs = pairs local replacements = { ["{white}"] = "\x01", ["{darkred}"] = "\x02", ["{team}"] = "\x03", ["{green}"] = "\x04", ["{lightgreen}"] = "\x05", ["{lime}"] = "\x06", ["{red}"] = "\x07", ["{grey}"] = "\x08", ["{yellow}"] = "\x09", ["{bluegrey}"] = "\x0A", ["{blue}"] = "\x0B", ["{darkblue}"] = "\x0C", ["{purple}"] = "\x0D", ["{violet}"] = "\x0E", ["{lightred}"] = "\x0F", ["{orange}"] = "\x10", ["\u{202E}"] = "", ["\u{2029}"] = "", ["  +"] = function(c) return " " .. ("\x18 "):rep(c:len()-1) end } local function find_sig(mdlname, pattern, typename, offset, deref_count) local raw_match = client.find_signature(mdlname, pattern) or error("signature not found", 2) local match = ffi.cast("uintptr_t", raw_match) if offset ~= nil and offset ~= 0 then match = match + offset end if deref_count ~= nil then for i = 1, deref_count do match = ffi.cast("uintptr_t*", match)[0] if match == nil then return error("signature not found", 2) end end end return ffi.cast(typename, match) end local function table_concat_tostring(tbl, sep) local result = "" for i=1, #tbl do result = result .. tostring(tbl[i]) .. (i == #tbl and "" or sep) end return result end local hud = find_sig("client.dll", "\xB9\xCC\xCC\xCC\xCC\x88\x46\x09", "void*", 1, 1) local native_FindHudElement = find_sig("client.dll", "\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x57\x8B\xF9\x33\xF6\x39\x77\x28", "void***(__thiscall*)(void*, const char*)") local native_ChatPrintf = vtable_thunk(27, "void(__cdecl*)(void*, int, int, const char*, ...)") local hud_chat = native_FindHudElement(hud, "CHudChat") local function print_player(entindex, ...) local text = table_concat_tostring(entindex == 0 and {" ", ...} or {...}, "") for res, rep in pairs(replacements) do text = string.gsub(text, res, rep) end native_ChatPrintf(hud_chat, entindex, 0, text) end

local lastCheck = 0

local ffi_typeof, ffi_cast = ffi.typeof, ffi.cast

local prefer_safe_point = ui.reference('RAGE', 'Aimbot', 'Prefer safe point')
local force_safe_point = ui.reference('RAGE', 'Aimbot', 'Force safe point')

local num_format = function(b) local c=b%10;if c==1 and b~=11 then return b..'st'elseif c==2 and b~=12 then return b..'nd'elseif c==3 and b~=13 then return b..'rd'else return b..'th'end end
local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }
local weapon_to_verb = { knife = 'Knifed', hegrenade = 'Naded', inferno = 'Burned' }

local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }

function log_print(message)
    if(has_value(ui.get(shotlogger_options), "chat")) then
        print_player(0, "{red}【℞】{white} " .. message)
    end

    if(has_value(ui.get(shotlogger_options), "console")) then
        colorful_text:log(
            { { 255, 102, 102 }, { 189, 24, 9 }, "xanax - ", false },
            { message, true }
        )
    end

    if(has_value(ui.get(shotlogger_options), "screen")) then
        notify.add(5, false, {255, 102, 102, "[XANAX] "}, {255,255,255, message})
    end
end

local classes = {
    net_channel = function()
        local this = { }

        local class_ptr = ffi_typeof('void***')
        local engine_client = ffi_cast(class_ptr, client.create_interface("engine.dll", "VEngineClient014"))
        local get_channel = ffi_cast("void*(__thiscall*)(void*)", engine_client[0][78])

        local netc_bool = ffi_typeof("bool(__thiscall*)(void*)")
        local netc_bool2 = ffi_typeof("bool(__thiscall*)(void*, int, int)")
        local netc_float = ffi_typeof("float(__thiscall*)(void*, int)")
        local netc_int = ffi_typeof("int(__thiscall*)(void*, int)")
        local net_fr_to = ffi_typeof("void(__thiscall*)(void*, float*, float*, float*)")

        client.set_event_callback('net_update_start', function()
            local ncu_info = ffi_cast(class_ptr, get_channel(engine_client)) or error("net_channel:update:info is nil")
            local seqNr_out = ffi_cast(netc_int, ncu_info[0][17])(ncu_info, 1)
        
            for name, value in pairs({
                seqNr_out = seqNr_out,
        
                is_loopback = ffi_cast(netc_bool, ncu_info[0][6])(ncu_info),
                is_timing_out = ffi_cast(netc_bool, ncu_info[0][7])(ncu_info),
        
                latency = {
                    crn = function(flow) return ffi_cast(netc_float, ncu_info[0][9])(ncu_info, flow) end,
                    average = function(flow) return ffi_cast(netc_float, ncu_info[0][10])(ncu_info, flow) end,
                },
        
                loss = ffi_cast(netc_float, ncu_info[0][11])(ncu_info, 1),
                choke = ffi_cast(netc_float, ncu_info[0][12])(ncu_info, 1),
                got_bytes = ffi_cast(netc_float, ncu_info[0][13])(ncu_info, 1),
                sent_bytes = ffi_cast(netc_float, ncu_info[0][13])(ncu_info, 0),
        
                is_valid_packet = ffi_cast(netc_bool2, ncu_info[0][18])(ncu_info, 1, seqNr_out-1),
            }) do
                this[name] = value
            end
        end)

        function this:get()
            return (this.seqNr_out ~= nil and this or nil)
        end

        return this
    end,

    aimbot = function(net_channel)
        local this = { }
        local aim_data = { }
        local bullet_impacts = { }

        local generate_flags = function(pre_data)
            return {
                pre_data.self_choke > 1 and 1 or 0,
                pre_data.velocity_modifier < 1.00 and 1 or 0,
                pre_data.flags.boosted and 1 or 0
            }
        end

        local get_safety = function(aim_data, target)
            local has_been_boosted = aim_data.boosted
            local plist_safety = plist.get(target, 'Override safe point')
            local ui_safety = { ui.get(prefer_safe_point), ui.get(force_safe_point) or plist_safety == 'On' }
    
            if not has_been_boosted then
                return -1
            end
    
            if plist_safety == 'Off' or not (ui_safety[1] or ui_safety[2]) then
                return 0
            end
    
            return ui_safety[2] and 2 or (ui_safety[1] and 1 or 0)
        end

        local get_inaccuracy_tick = function(pre_data, tick)
            local spread_angle = -1
            for k, impact in pairs(bullet_impacts) do
                if impact.tick == tick then
                    local aim, shot = 
                        (pre_data.eye-pre_data.shot_pos):angles(),
                        (pre_data.eye-impact.shot):angles()
        
                        spread_angle = vector(aim-shot):length2d()
                    break
                end
            end

            return spread_angle
        end

        this.fired = function(e)
            local this = { }
            local p_ent = e.target
            local me = entity.get_local_player()
        
            aim_data[e.id] = {
                original = e,
                dropped_packets = { },
        
                handle_time = globals.realtime(),
                self_choke = globals.chokedcommands(),
        
                flags = {
                    boosted = e.boosted
                },

                safety = get_safety(e, p_ent),
                correction = plist.get(p_ent, 'Correction active'),
        
                shot_pos = vector(e.x, e.y, e.z),
                eye = vector(client.eye_position()),
                view = vector(client.camera_angles()),
        
                velocity_modifier = entity.get_prop(me, 'm_flVelocityModifier'),
                total_hits = entity.get_prop(me, 'm_totalHitsOnServer'),

                history = (globals.tickcount() - e.tick) or 0
            }
        end
        
        this.missed = function(e)
            if aim_data[e.id] == nil then
                return
            end
        
            local pre_data = aim_data[e.id]
            
            local net_data = net_channel:get()
        
            local ping, avg_ping = 
                net_data.latency.crn(0)*1000, 
                net_data.latency.average(0)*1000
        
            local net_state = string.format(
                'delay: %d:%.2f | dropped: %d', 
                avg_ping, math.abs(avg_ping-ping), #pre_data.dropped_packets
            )
        
            local uflags = {
                math.abs(avg_ping-ping) < 1 and 0 or 1,
                cvar.cl_clock_correction:get_int() == 1 and 0 or 1,
                cvar.cl_clock_correction_force_server_tick:get_int() == 999 and 0 or 1
            }
        
            local spread_angle = get_inaccuracy_tick( pre_data, globals.tickcount() )
            
            -- smol stuff
            local me = entity.get_local_player()
            local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
            local target_name = string.lower(entity.get_player_name(e.target))
            local hit_chance = math.floor(pre_data.original.hit_chance + 0.5)
            local pflags = generate_flags(pre_data)

            if(not pre_data.history) then
                pre_data.history = 0
            end

            local reasons = {
                ['event_timeout'] = function()
                    log_print(string.format(
                        'Missed shot due to timeout [%s]/[%s]', 
                        string.gsub(target_name, '%s+', ''), net_state
                    ))
                end,

                ['death'] = function()
                    log_print(string.format(
                        'Missed shot at %s\'s %s(%s) due to death', 
                        string.gsub(target_name, '%s+', ''), hgroup, hit_chance
                    ))
                end,
        
                ['prediction_error'] = function(type)
                    local type = type == 'unregistered shot' and (' [' .. type .. ']') or ''
                    log_print(string.format(
                        'Missed shot at %s\'s %s(%s) due to prediction error%s [%s] [vel: %.1f / bt: %d]', 
                        string.gsub(target_name, '%s+', ''), hgroup, hit_chance, type, net_state, entity.get_prop(me, 'm_flVelocityModifier'), pre_data.history, table.concat(uflags)
                    ))
                end,

                ['spread'] = function()
                    log_print(string.format(
                        'Missed shot at %s\'s %s(%s) due to spread [hc: %d / ang: %d / damage: %d / safe: %d / bt: %d]',
                        string.gsub(target_name, '%s+', ''), hgroup, hit_chance, spread_angle, 
                        pre_data.original.damage, pre_data.safety, (pre_data.history or 0)
                    ))
                end,
        
                ['unknown'] = function(type)
                    local _type = {
                        ['damage_rejected'] = 'damage rejection',
                        ['unknown'] = string.format('resolver')
                    }

                    log_print(string.format(
                        'Missed shot at %s\'s %s(%s) due to %s [dmg: %d / safety: %d / bt: %d]',
                        string.gsub(target_name, '%s+', ''), hgroup, hit_chance, _type[type or 'unknown'],
                        pre_data.original.damage, pre_data.safety, pre_data.history
                    ))
                end
            }
        
            local post_data = {
                event_timeout = (globals.realtime() - pre_data.handle_time) >= 0.5,
                damage_rejected = e.reason == '?' and pre_data.total_hits ~= entity.get_prop(me, 'm_totalHitsOnServer'),
                prediction_error = e.reason == 'prediction error' or e.reason == 'unregistered shot'
            }
        
            if post_data.event_timeout then 
                reasons.event_timeout()
            elseif post_data.prediction_error then 
                reasons.prediction_error(e.reason)
            elseif e.reason == 'spread' then
                reasons.spread()
            elseif e.reason == '?' then
                reasons.unknown(post_data.damage_rejected and 'damage_rejected' or 'unknown')
            elseif e.reason == 'death' then
                reasons.death()
            end
        
            aim_data[e.id] = nil
        end
        
        this.hit = function(e)
            if aim_data[e.id] == nil then
                return
            end
        
            local p_ent = e.target

            local pre_data = aim_data[e.id]

            local me = entity.get_local_player()
            local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
            local aimed_hgroup = hitgroup_names[pre_data.original.hitgroup + 1] or '?'

            local target_name = string.lower(entity.get_player_name(e.target))
            local hit_chance = math.floor(pre_data.original.hit_chance + 0.5)
            local pflags = generate_flags(pre_data)

            local spread_angle = get_inaccuracy_tick( pre_data, globals.tickcount() )
            
            local _verification = function()
                local text = ''

                local hg_diff = hgroup ~= aimed_hgroup
                local dmg_diff = e.damage ~= pre_data.original.damage

                if hg_diff or dmg_diff then
                    text = string.format(
                        ' | mismatch: [ %s ]', (function()
                            local addr = ''

                            if dmg_diff then addr = 'dmg: ' .. pre_data.original.damage .. (hg_diff and ' | ' or '') end
                            if hg_diff then addr = addr .. (hg_diff and 'hitgroup: ' .. aimed_hgroup or '') end

                            return addr
                        end)()
                    )
                end

                return text
            end

            log_print(string.format(
                'Registered shot in %s\'s %s for %d damage [hc: %d / safe: %s / bt: %d]',
                string.gsub(target_name, '%s+', ''), hgroup, e.damage,
                hit_chance, pre_data.safety, pre_data.history, _verification()
            ))
        end
        
        this.bullet_impact = function(e)
            local tick = globals.tickcount()
            local me = entity.get_local_player()
            local user = client.userid_to_entindex(e.userid)
            
            if user ~= me then
                return
            end
        
            if #bullet_impacts > 150 then
                bullet_impacts = { }
            end
        
            bullet_impacts[#bullet_impacts+1] = {
                tick = tick,
                eye = vector(client.eye_position()),
                shot = vector(e.x, e.y, e.z)
            }
        end
        
        this.net_listener = function()
            local net_data = net_channel:get()
        
            if net_data == nil then
                return
            end

            if not net_channel.is_valid_packet then
                for id in pairs(aim_data) do
                    table.insert(aim_data[id].dropped_packets, net_channel.seqNr_out)
                end
            end
        end

        return this
    end
}

local net_channel = classes.net_channel()
local aimbot = classes.aimbot(net_channel)

local g_player_hurt = function(e)
    local attacker_id = client.userid_to_entindex(e.attacker)
	
    if attacker_id == nil or attacker_id ~= entity.get_local_player() then
        return
    end

    local group = hitgroup_names[e.hitgroup + 1] or "?"
	
    if group == "generic" and weapon_to_verb[e.weapon] ~= nil then
        local target_id = client.userid_to_entindex(e.userid)
		local target_name = entity.get_player_name(target_id)

        log_print(string.format("%s %s for %i damage (%i remaining)", weapon_to_verb[e.weapon], string.lower(target_name), e.dmg_health, e.health))
	end
end

local interface_callback = function(c)
    local addr = not ui.get(c) and 'un' or ''
    local _func = client[addr .. 'set_event_callback']

    _func('aim_fire', aimbot.fired)
    _func('aim_miss', aimbot.missed)
    _func('aim_hit', aimbot.hit)
    _func('bullet_impact', aimbot.bullet_impact)
    _func('net_update_start', aimbot.net_listener)
    _func('player_hurt', g_player_hurt)
end

ui.set_callback(shotlogger_checkbox, interface_callback)
interface_callback(shotlogger_checkbox)

local coolVar1 = 0
local coolVar2 = 0

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function setFlags(e)
    if(e ~= nil) then
        local id = steamworks.SteamID(entity.get_steam64(e))
        
        if(id) then
            if(has_value(player_list, id:render_steam64())) then
                return true
            else
                return false
            end
        end
    else
        return false
    end
end

client.register_esp_flag("xanax", 255, 255, 255, setFlags)


local nigger = require 'gamesense/panorama_events'

local js = panorama.open()
local game_state = js.GameStateAPI

local offset = 0
local watermark_text2 = "   | " .. build .. ": " .. username 
local j2 = 0

local function hsv_to_rgb(h, s, v)
	local r, g, b

	local i = math.floor(h * 6);
	local f = h * 6 - i;
	local p = v * (1 - s);
	local q = v * (1 - f * s);
	local t = v * (1 - (1 - f) * s);

	i = i % 6

	if i == 0 then r, g, b = v, t, p
	elseif i == 1 then r, g, b = q, v, p
	elseif i == 2 then r, g, b = p, v, t
	elseif i == 3 then r, g, b = p, q, v
	elseif i == 4 then r, g, b = t, p, v
	elseif i == 5 then r, g, b = v, p, q
	end

	return r * 255, g * 255, b * 255
end

local string_okay = {}

local function shoot_your_self() 
    local in_server = game_state.IsConnectedOrConnectingToServer()
    local screen_width, screen_height = client.screen_size()
    local latency = math.floor(client.latency()*1000+0.5)
    local fps = get_fps()
    local hours, minutes, seconds = client.system_time()
    local margin, padding, flags = 18, 4, nil
    

    local watermark_text1 = {
        "x", "a", "n", "a", "x",".", "l", "u", "a",
    }
    renderer.rectangle(screen_width - margin - padding - (j2 - 1) * 9 - renderer.measure_text("b", watermark_text2), margin - padding + 6, (j2 - 1) * 9 + renderer.measure_text("b", watermark_text2),  20, 20, 20, 20, 200)
    renderer.rectangle(screen_width - margin - padding - renderer.measure_text("b", "FPS: 000") - 9, margin - padding + 6 + 22, renderer.measure_text("b", "FPS: 000") + 9,  20, 20, 20, 20, 200)
    
    amount = fps / 500  
    if amount > 1 then
        amount = 1
    end 
    local r, g, b = hsv_to_rgb( fps / 720, 1, 1)

    for k = 0, ((j2 - 1) * 9 + renderer.measure_text("b", watermark_text2)) - 2, 2 do
        renderer.rectangle(screen_width - margin - padding - (j2 - 1) * 9 - renderer.measure_text("b", watermark_text2) + k , margin - padding + 6, 2, 1,  255, 255, 255, ((k) / (((j2 - 1) * 9 + renderer.measure_text("b", watermark_text2)) - 2)) * 255)
    end

    if in_server then
    
        renderer.rectangle(screen_width - margin - padding  - renderer.measure_text("b", "FPS: 000") - 9, 
        margin - padding + 6 + 22, (renderer.measure_text("b", "FPS: 000") + 9) * amount,  1, r, g, b, 200)

        local latency_text = string.format("PING: %i", latency)
        renderer.rectangle(screen_width - margin - padding - renderer.measure_text("b", "FPS: 000") - renderer.measure_text("b", latency_text) - 9 - 11,
        margin - padding + 6 + 22, (renderer.measure_text("b", latency_text) + 9), 20, 20, 20, 20, 200)

        renderer.text(screen_width - margin - padding - renderer.measure_text("b", "FPS: 000") - renderer.measure_text("b", latency_text) - 9 - 11 + 4,
        margin - padding + 10 + 22, 255, 255, 255, 200, "b", 200, latency_text)

        renderer.text(screen_width - margin - padding + 4 - renderer.measure_text("b", "FPS: 000") - 9, margin - padding + 10 + 22, r, g, b, 200, "b", 200, "FPS: ".. fps)
    end

    for j in pairs(watermark_text1) do
        renderer.text(screen_width - (margin - 2)- padding - (j2 - 1) * 9 - renderer.measure_text("b", watermark_text2) + j * 8 , margin - padding + 10 + math.sin(offset + j / 2) * 2, 255, 255, 255, 0 + math.abs(math.cos(offset + j / 4) * 200), "br", 200, watermark_text1[j])
        if j2 < j then
            j2 = j
        end
    end

    renderer.text( (screen_width - (margin - 2)- padding - renderer.measure_text("br", watermark_text2)) - 6 , margin - padding + 10, 255, 255, 255, 200, "b", 200, watermark_text2)
    
end


local function get_pos(player)
    local min = vector(entity.get_prop(player, "m_vecMins"))
    local max = vector(entity.get_prop(player, "m_vecMaxs"))
    local pos = vector(entity.get_origin(player))

    if min == nil or max == nil or pos == nil then return end

    local mpoints = {
	  vector(min.x, min.y, min.z),
	  vector(min.x, max.y, min.z),
	  vector(max.x, max.y, min.z),
	  vector(max.x, min.y, min.z),
	  vector(max.x, max.y, max.z),
	  vector(min.x, max.y, max.z),
	  vector(min.x, min.y, max.z),
	  vector(max.x, min.y, max.z)
	}

    local points = {
        pos + mpoints[1],
        pos + mpoints[2],
        pos + mpoints[3],
        pos + mpoints[4],
        pos + mpoints[5],
        pos + mpoints[6],
        pos + mpoints[7],
        pos + mpoints[8]
    }

    local screen_points = {}
    
    for i = 1, 8, 1 do
        --debug_overlay.add_sphere(points[i], 4, 10, 10, color_t(255,255,255,255), 0.1)
        screen_points[i] = vector(renderer.world_to_screen(points[i]:unpack()))
    end
    if screen_points[1] == nil then return end
    local left = screen_points[1].x
    local bot = screen_points[1].y
    for i = 1, 8, 1 do
    if screen_points[i] == nil then return end
        
        if left > screen_points[i].x then
        left = screen_points[i].x end
        if bot < screen_points[i].y then
        bot= screen_points[i].y end
    end
    
    return vector(left, bot, 0)
end

local x = 36
local y = 14

local old_pos = {
    x = 36, y = 14,
    x2 = 0, y2 = 0,
}

local x2 = 0
local y2 = 0

local okay_old = vector()

local time = 0
local set = false
local done = false

local function render_mid()
    if(ui.get(crosshair_indicator) == "dynamic") then
        active_binds = {}
        if(has_value(ui.get(crosshair_flags), "conditional state")) then
            -- table.insert(active_binds, GetState(), #active_binds + 1)
            active_binds[#active_binds + 1] = GetState()
        end 
    
        local doubletap, key = ui.reference("RAGE", "Other", "Double tap")
        local hs, key2 = ui.reference("AA", "Other", "On shot anti-aim")
        local ref_baim = ui.reference("RAGE", "Other", "Force body aim")
        local qp_a, key3 = ui.reference("RAGE", "Other", "Quick peek assist")
        local mindmg = ui.reference("RAGE", "Aimbot", "Minimum Damage")
        if(has_value(ui.get(crosshair_flags), "dt") and ui.get(doubletap) and ui.get(key)) then 
            active_binds[#active_binds + 1] = "dt"
        end
    
        if(has_value(ui.get(crosshair_flags), "hs") and ui.get(hs) and ui.get(key2)) then 
            active_binds[#active_binds + 1] = "hs"
        end
    
        if(has_value(ui.get(crosshair_flags), "baim") and ui.get(ref_baim)) then 
            active_binds[#active_binds + 1] = "baim"
        end
    
        if(has_value(ui.get(crosshair_flags), "fd") and ui.get(antiaim.other.fake_duck)) then 
            active_binds[#active_binds + 1] = "fake duck"
        end
    
        if(has_value(ui.get(crosshair_flags), "quick peek") and ui.get(qp_a) and ui.get(key3)) then 
            active_binds[#active_binds + 1] = "quick peek"
        end
    
        if(has_value(ui.get(crosshair_flags), "mindmg")) then 
            active_binds[#active_binds + 1] = ui.get(mindmg)
        end
    
        local lp = entity.get_local_player()
        local screen_width, screen_height = client.screen_size()
        local okay = get_pos(lp)
        local text1 = {
            "x", "a", "n", "a", "x",".", "l", "u", "a",
        }
        local scoped = entity.get_prop(lp , 'm_bIsScoped') == 1
        --fake_duck = ui.reference("RAGE", "Other", "Duck peek assist")
        local thirdperson = {ui.reference("VISUALS", "Effects", "Force third person (alive)")}
        
        if not ui.get(thirdperson[2]) then
            if x > 40 then
                if scoped then
                    x = x - 70
                else
                    x = x - 70
                end
            end
            if scoped then
                if x > 0 then
                    x = x - 18
                end
                if y > 4 then 
                    y = y - 2
                end
            else
                if x < 37 then
                    x = x + 18
                end
                if y < 15 then
                    y = y + 2
                end
            end
            -- for i = 1, #active_binds, 1 do
            --     if scoped then
            --         active_binds_offset[i] = .01
            --     else
            --         active_binds_offset[i] = renderer.measure_text("b", active_binds[i]) / 2
            --     end
            --     active_binds_offset[i] = easing.quad_out_in(1, active_binds_offset_old[i], active_binds_offset[i] - active_binds_offset_old[i], 20)
            --     active_binds_offset_old[i] = active_binds_offset[i]
            -- end   
        else
            if scoped then
                x = 36
                -- for i = 1, #active_binds, 1 do
                --         active_binds_offset[i] = 0
                -- end   
            else
                x = 0
                -- for i = 1, #active_binds, 1 do
                --     active_binds_offset[i] = renderer.measure_text("b", active_binds[i]) / 2
                -- end   
            end
        end
    
        -- for i = 1, #active_binds, 1 do
        --     active_binds_offset[i] = easing.quad_out_in(1, active_binds_offset_old[i], active_binds_offset[i] - active_binds_offset_old[i], 20)
    
        --     active_binds_offset_old[i] = active_binds_offset[i]
        -- end
        okay.x = easing.quad_out(1, okay_old.x, okay.x - okay_old.x, 50)
        okay.y = easing.quad_out(1, okay_old.y, okay.y - okay_old.y, 50)
    
        
        x = easing.quad_out_in(1, old_pos.x, x - old_pos.x, 20)
        y = easing.quad_out_in(1, old_pos.y, y - old_pos.y, 20)
        
        for j in pairs(text1) do
            if not ui.get(thirdperson[2]) then
                renderer.text((screen_width / 2 + j * 8) - x, screen_height / 2 + y, 255, 255, 255, 20 + math.abs(math.cos(offset + j / 4) * 200), "br", 200, text1[j])
            else
                renderer.text((okay.x + j * 8) - 72, screen_height / 2 + 15, 255, 255, 255, 20 + math.abs(math.cos(offset + j / 4) * 200), "br", 200, text1[j])
            end
        end
        
        if ui.get(thirdperson[2]) then
            renderer.gradient(okay.x - 76, screen_height / 2 + 13, 80, 1, 255, 255, 255, 0, 255, 255, 255, 200, true)
            renderer.gradient(okay.x + 4, screen_height / 2 + 13, 1, 80, 255, 255, 255, 200, 255, 255, 255, 0, false)
        end
    
        
        for a in pairs(active_binds) do
    
            local rgb_r = 255
            local rgb_g = 255
            local rgb_b = 255
    
            if(active_binds[a] == "dt") then
                if(anti_aim.get_double_tap()) then
                    rgb_r, rgb_g, rgb_b = 235, 73, 86
                end
            end

            if(active_binds[a] == "fake duck") then
                rgb_r, rgb_g, rgb_b = 235, 163, 16
            end

            if(active_binds[a] == "baim") then
                rgb_r, rgb_g, rgb_b = 60, 56, 171
            end

            if(active_binds[a] == "quick peek") then
                rgb_r, rgb_g, rgb_b = 181, 31, 184
            end

            if(active_binds[a] == "hs") then
                rgb_r, rgb_g, rgb_b = 130, 16, 46
            end
            

            if not ui.get(thirdperson[2]) then
                if scoped then 
                    renderer.text((screen_width / 2) + 3, screen_height / 2 + y + a * 12.5 + 4,
                    rgb_r, rgb_g, rgb_b, 200, "b", 200, active_binds[a])
                else 
                    renderer.text((screen_width / 2), screen_height / 2 + y + a * 12.5 + 10,
                    rgb_r, rgb_g, rgb_b, 200, "bc", 200, active_binds[a])
                end
            else
                renderer.text(okay.x - renderer.measure_text("b", active_binds[a]), screen_height / 2 + 15 + a * 12.5,
                rgb_r, rgb_g, rgb_b, 200, "b", 200, active_binds[a])
            end
        end
    
        old_pos.x = x;
        old_pos.y = y;
        old_pos.x2 = x2;
        old_pos.y2 = y2;
        okay_old = okay
    end
end

local recent = 0
local pp_check = 0
local upping = false

function on_paint()
    --@heartbeat

    render_mid()
    local screen_width, screen_height = client.screen_size()

    if(needsReset and not ui.get(clantag_checkbox)) then
        client.set_clan_tag("")
        needsReset = false
    end

    if ui.get(clantag_checkbox) then
		local local_player = entity.get_local_player()
		if local_player ~= nil and (not entity.is_alive(local_player)) and globals.tickcount() % 2 == 0 then --missing noclip check
            recentlyReset = true
			run_tag_animation()
		end
	end

    -- CROSSHAIR
    if(ui.get(crosshair_indicator) == "basic") then
        function getOpacity()
            if(client.unix_time() > pp_check + 1) then
                if(recent > 240) then
                    upping = false
                    recent = recent - 1
                    return recent
                elseif(recent <= 0) then 
                    upping = true
                    recent = recent + 1
                    return recent
                else    
                    if(upping) then
                        recent = recent + 1
                    else
                        recent = recent - 1
                    end
                    return recent
                end
            end
        end

        if(entity.is_alive(entity.get_local_player())) then
            local opacity = getOpacity()
            local ch_color_r, ch_color_g, ch_color_b, ch_color_a = ui.get(crosshair_color)
            renderer.text(screen_width/2 + 15, screen_height/2, ch_color_r, ch_color_g, ch_color_b, opacity, "b", 300, "xanax")
            renderer.line(screen_width/2 + 14, screen_height/2 + 14, screen_width/2 + 48, screen_height/2 + 14, 255, 255, 255, 255)

            local padding = 0

            if(has_value(ui.get(crosshair_flags), "conditional state")) then
                renderer.text(screen_width/2 + 31, screen_height/2 + 22 + padding, 255, 255, 255, 255, "c", 300, tostring(GetState()))
                padding = padding + 10
            end

            local color_r, color_g, color_b = 255, 0, 0

            local doubletap, key = ui.reference("RAGE", "Other", "Double tap")
            local hs, key2 = ui.reference("AA", "Other", "On shot anti-aim")
            local ref_baim = ui.reference("RAGE", "Other", "Force body aim")
            local qp_a, key3 = ui.reference("RAGE", "Other", "Quick peek assist")
            local mindmg = ui.reference("RAGE", "Aimbot", "Minimum Damage")
            if(has_value(ui.get(crosshair_flags), "dt") and ui.get(doubletap) and ui.get(key)) then 
                if(anti_aim.get_double_tap()) then
                    renderer.text(screen_width/2 + 31, screen_height/2 + 22 + padding, 235, 66, 71, 255, "c", 300, "dt")
                else
                    renderer.text(screen_width/2 + 31, screen_height/2 + 22 + padding, 255, 255, 255, 255, "c", 300, "dt")
                end
                padding = padding + 10
            end

            if(has_value(ui.get(crosshair_flags), "hs") and ui.get(hs) and ui.get(key2)) then 
                renderer.text(screen_width/2 + 31, screen_height/2 + 22 + padding, 186, 140, 0, 255, "c", 300, "hs")
                padding = padding + 10
            end

            if(has_value(ui.get(crosshair_flags), "baim") and ui.get(ref_baim)) then 
                renderer.text(screen_width/2 + 31, screen_height/2 + 22 + padding, 207, 28, 235, 255, "c", 300, "baim")
                padding = padding + 10
            end

            if(has_value(ui.get(crosshair_flags), "fd") and ui.get(antiaim.other.fake_duck)) then 
                renderer.text(screen_width/2 + 31, screen_height/2 + 22 + padding, 31, 132, 143, 255, "c", 300, "fake duck")
                padding = padding + 10
            end

            if(has_value(ui.get(crosshair_flags), "quick peek") and ui.get(qp_a) and ui.get(key3)) then 
                renderer.text(screen_width/2 + 31, screen_height/2 + 22 + padding, 255, 255, 255, 255, "c", 300, "auto peek")
                padding = padding + 10
            end

            if(has_value(ui.get(crosshair_flags), "mindmg")) then 
                renderer.text(screen_width/2 + 31, screen_height/2 + 22 + padding, 255, 255, 255, 255, "c", 300, ui.get(mindmg))
                padding = padding + 10
            end

        end

        
    end
end


function on_paint_ui()

    notify:listener()

    --no touchy
    offset = offset + .01

    -- WATERMARK
    if(ui.get(watermark)) then
        shoot_your_self();
    end

    selection = ui.get(servers_select)

    if(not ui.get(cloudEnabled)) then
        if(client.unix_time() > lastCheck + 8) then
            lastCheck = client.unix_time()
            cloudHeartbeat()
        end
    end

    if(ui.get(aa_type) == "builder" and ui.get(aa_builder_state) == "standing") then
        standingTab(true)
    else
        standingTab(false)
    end

    if(ui.get(aa_type) == "builder" and ui.get(aa_builder_state) == "running") then
        runningTab(true)
    else
        runningTab(false)
    end

    if(ui.get(aa_type) == "builder" and ui.get(aa_builder_state) == "in-air") then
        inairTab(true)
    else
        inairTab(false)
    end

    if(ui.get(aa_type) == "builder" and ui.get(aa_builder_state) == "slow walk") then
        slowTab(true)
    else
        slowTab(false)
    end

    ui.set_visible(ui.reference("AA", "Anti-Aimbot Angles", "Edge yaw"), false)
    if(ui.get(edge_yaw_bind)) then
        ui.set(ui.reference("AA", "Anti-Aimbot Angles", "Edge yaw"), true)
    else
        ui.set(ui.reference("AA", "Anti-Aimbot Angles", "Edge yaw"), false)
    end    

    -- AA TABS
    if(ui.get(crosshair_indicator) == 'off') then
        ui.set_visible(crosshair_flags, false)
    else
        ui.set_visible(crosshair_flags, true)
    end

    -- AA
    ui.set_visible(aa_builder_state, false)
    if(ui.get(aa_type) == "builder") then
        ui.set_visible(aa_preset, false)
        ui.set_visible(aa_builder_state, true)

        ui.set_visible(antiaim.angles.yaw_base[1], false)
        ui.set_visible(antiaim.angles.yaw_base[2], false)
        ui.set_visible(antiaim.angles.yaw_jitter[1], false)
        ui.set_visible(antiaim.angles.yaw_jitter[2], false)
        ui.set_visible(antiaim.angles.body_yaw[1], false)
        ui.set_visible(antiaim.angles.body_yaw[2], false)
    elseif(ui.get(aa_type) == "presets") then
        ui.set_visible(aa_preset, true)
        ui.set_visible(aa_builder_state, false)

        ui.set_visible(antiaim.angles.yaw_base[1], false)
        ui.set_visible(antiaim.angles.yaw_base[2], false)
        ui.set_visible(antiaim.angles.yaw_jitter[1], false)
        ui.set_visible(antiaim.angles.yaw_jitter[2], false)
        ui.set_visible(antiaim.angles.body_yaw[1], false)
        ui.set_visible(antiaim.angles.body_yaw[2], false)
    elseif(ui.get(aa_type) == "none") then
        ui.set(aa_preset, 0)
        ui.set_visible(aa_preset, false)
        ui.set_visible(aa_builder_state, false)

        ui.set_visible(antiaim.angles.yaw_base[1], true)
        ui.set_visible(antiaim.angles.yaw_base[2], true)
        ui.set_visible(antiaim.angles.yaw_jitter[1], true)
        ui.set_visible(antiaim.angles.yaw_jitter[2], true)
        ui.set_visible(antiaim.angles.body_yaw[1], true)
        ui.set_visible(antiaim.angles.body_yaw[2], true)
    end

    -- MENU HANDLER
    if(ui.get(menuFeature) == "clantag") then
        clantagtab(true)
    else
        clantagtab(false)
    end

    if(ui.get(menuFeature) == "killsay") then
        killsaytab(true)
    else
        killsaytab(false)
    end

    if(ui.get(menuFeature) == "indicators") then
        indicatortab(true)
    else
        indicatortab(false)
    end

    if(ui.get(menuFeature) == "logs") then
        logtab(true)
    else
        logtab(false)
    end

    if(ui.get(menuFeature) == "server browser") then
        serverbrowsertab(true)
    else
        serverbrowsertab(false)
    end

    if(ui.get(menuFeature) == "cloud") then
        cloudtab(true)
    else
        cloudtab(false)
    end
end

function on_run_command(e)
    --preset handling
    ui.set(ui.reference("AA", "Anti-aimbot angles", "Enabled"), true)
    ui.set(ui.reference("AA", "Anti-aimbot angles", "Pitch"), "Down")
    ui.set(ui.reference("AA", "Anti-aimbot angles", "Yaw base"), "At targets")

    if(ui.get(aa_preset) ~= 0) then

        local preset_name = preset_names[ui.get(aa_preset) + 1]
        local preset_values = {
             yaw_base_array = mysplit(presets[tonumber(ui.get(aa_preset))]['yaw_base'], ','),
             yaw_base_modifier_array = mysplit(presets[tonumber(ui.get(aa_preset))]['yaw_base_amount'], ','),
             yaw_jitter = mysplit(presets[tonumber(ui.get(aa_preset))]['yaw_jitter'], ','),
             yaw_jitter_modifier_array = mysplit(presets[tonumber(ui.get(aa_preset))]['yaw_jitter_amount'], ','),
             body_yaw_array = mysplit(presets[tonumber(ui.get(aa_preset))]['body_yaw'], ','),
             body_yaw_modifier_array = mysplit(presets[tonumber(ui.get(aa_preset))]['body_yaw_amount'], ','),
    
             fakelag_amount_array = mysplit(presets[tonumber(ui.get(aa_preset))]['fakelag_amount'], ','),
             fakelag_var_array = mysplit(presets[tonumber(ui.get(aa_preset))]['fakelag_variance'], ','),
        }

        for i,v in pairs(preset_values) do

            for index, value in pairs(preset_values[i]) do

                if(string.find(preset_values[i][index], "/")) then
                    local randomize = mysplit(preset_values[i][index], "/")
                    preset_values[i][index] = math.random(randomize[1], randomize[2])
                end

            end

        end

        if(GetState() == 'standing') then
            ui.set(antiaim.angles.yaw_base[1], preset_values.yaw_base_array[1])
            ui.set(antiaim.angles.yaw_base[2], tonumber(preset_values.yaw_base_modifier_array[1]))
            ui.set(antiaim.angles.body_yaw[1], preset_values.body_yaw_array[1])
            ui.set(antiaim.angles.body_yaw[2], tonumber(preset_values.body_yaw_modifier_array[1]))
            ui.set(antiaim.angles.yaw_jitter[1], preset_values.yaw_jitter[1])     
            ui.set(antiaim.angles.yaw_jitter[2], tonumber(preset_values.yaw_jitter_modifier_array[1]))
            ui.set(antiaim.fakelag.mode, "Maximum")
            ui.set(antiaim.fakelag.variance, tonumber(preset_values.fakelag_var_array[1]))
            ui.set(antiaim.fakelag.amount, tonumber(preset_values.fakelag_amount_array[1]))
        end

        if(GetState() == 'running') then
            ui.set(antiaim.angles.yaw_base[1], preset_values.yaw_base_array[2])
            ui.set(antiaim.angles.yaw_base[2], tonumber(preset_values.yaw_base_modifier_array[2]))
            ui.set(antiaim.angles.body_yaw[1], preset_values.body_yaw_array[2])
            ui.set(antiaim.angles.body_yaw[2], tonumber(preset_values.body_yaw_modifier_array[2]))
            ui.set(antiaim.angles.yaw_jitter[1], preset_values.yaw_jitter[2])     
            ui.set(antiaim.angles.yaw_jitter[2], tonumber(preset_values.yaw_jitter_modifier_array[2]))
            ui.set(antiaim.fakelag.mode, "Maximum")
            ui.set(antiaim.fakelag.variance, tonumber(preset_values.fakelag_var_array[2]))
            ui.set(antiaim.fakelag.amount, tonumber(preset_values.fakelag_amount_array[2]))
        end

        if(GetState() == 'in air' or GetState() == 'c in air') then
            ui.set(antiaim.angles.yaw_base[1], preset_values.yaw_base_array[3])
            ui.set(antiaim.angles.yaw_base[2], tonumber(preset_values.yaw_base_modifier_array[3]))
            ui.set(antiaim.angles.body_yaw[1], preset_values.body_yaw_array[3])
            ui.set(antiaim.angles.body_yaw[2], tonumber(preset_values.body_yaw_modifier_array[3]))
            ui.set(antiaim.angles.yaw_jitter[1], preset_values.yaw_jitter[3])     
            ui.set(antiaim.angles.yaw_jitter[2], tonumber(preset_values.yaw_jitter_modifier_array[3]))
            ui.set(antiaim.fakelag.mode, "Maximum")
            ui.set(antiaim.fakelag.variance, tonumber(preset_values.fakelag_var_array[3]))
            ui.set(antiaim.fakelag.amount, tonumber(preset_values.fakelag_amount_array[3]))
        end

        if(GetState() == 'slow walk') then
            ui.set(antiaim.angles.yaw_base[1], preset_values.yaw_base_array[4])
            ui.set(antiaim.angles.yaw_base[2], tonumber(preset_values.yaw_base_modifier_array[4]))
            ui.set(antiaim.angles.body_yaw[1], preset_values.body_yaw_array[4])
            ui.set(antiaim.angles.body_yaw[2], tonumber(preset_values.body_yaw_modifier_array[4]))
            ui.set(antiaim.angles.yaw_jitter[1], preset_values.yaw_jitter[4])     
            ui.set(antiaim.angles.yaw_jitter[2], tonumber(preset_values.yaw_jitter_modifier_array[4]))
            ui.set(antiaim.fakelag.mode, "Maximum")
            ui.set(antiaim.fakelag.variance, tonumber(preset_values.fakelag_var_array[4]))
            ui.set(antiaim.fakelag.amount, tonumber(preset_values.fakelag_amount_array[4]))
        end

    end

    if(ui.get(aa_type) == "builder") then


        if(GetState() == 'standing') then
            local s = standing
            ui.set(antiaim.angles.yaw_base[1], ui.get(s.modifier))
            ui.set(antiaim.angles.yaw_base[2], ui.get(s.offset))
            ui.set(antiaim.angles.body_yaw[1], ui.get(s.body_yaw))
            ui.set(antiaim.angles.body_yaw[2], ui.get(s.body_yaw_offset))
            ui.set(antiaim.angles.yaw_jitter[1],  ui.get(s.jitter))
            ui.set(antiaim.angles.yaw_jitter[2],  ui.get(s.jitter_offset))
            ui.set(antiaim.fakelag.mode, "Maximum")
            ui.set(antiaim.fakelag.variance, 12)
            ui.set(antiaim.fakelag.amount, 15)
        end

        if(GetState() == 'running') then
            local s = running
            ui.set(antiaim.angles.yaw_base[1], ui.get(s.modifier))
            ui.set(antiaim.angles.yaw_base[2], ui.get(s.offset))
            ui.set(antiaim.angles.body_yaw[1], ui.get(s.body_yaw))
            ui.set(antiaim.angles.body_yaw[2], ui.get(s.body_yaw_offset))
            ui.set(antiaim.angles.yaw_jitter[1],  ui.get(s.jitter))
            ui.set(antiaim.angles.yaw_jitter[2],  ui.get(s.jitter_offset))
            ui.set(antiaim.fakelag.mode, "Maximum")
            ui.set(antiaim.fakelag.variance, 12)
            ui.set(antiaim.fakelag.amount, 15)
        end

        if(GetState() == 'in air' or GetState == 'c in air') then
            local s = inair
            ui.set(antiaim.angles.yaw_base[1], ui.get(s.modifier))
            ui.set(antiaim.angles.yaw_base[2], ui.get(s.offset))
            ui.set(antiaim.angles.body_yaw[1], ui.get(s.body_yaw))
            ui.set(antiaim.angles.body_yaw[2], ui.get(s.body_yaw_offset))
            ui.set(antiaim.angles.yaw_jitter[1],  ui.get(s.jitter))
            ui.set(antiaim.angles.yaw_jitter[2],  ui.get(s.jitter_offset))
            ui.set(antiaim.fakelag.mode, "Maximum")
            ui.set(antiaim.fakelag.variance, 12)
            ui.set(antiaim.fakelag.amount, 15)
        end

        if(GetState() == 'slow walk') then
            local s = slow
            ui.set(antiaim.angles.yaw_base[1], ui.get(s.modifier))
            ui.set(antiaim.angles.yaw_base[2], ui.get(s.offset))
            ui.set(antiaim.angles.body_yaw[1], ui.get(s.body_yaw))
            ui.set(antiaim.angles.body_yaw[2], ui.get(s.body_yaw_offset))
            ui.set(antiaim.angles.yaw_jitter[1],  ui.get(s.jitter))
            ui.set(antiaim.angles.yaw_jitter[2],  ui.get(s.jitter_offset))
            ui.set(antiaim.fakelag.mode, "Maximum")
            ui.set(antiaim.fakelag.variance, 12)
            ui.set(antiaim.fakelag.amount, 15)
        end
    end

    --ctag handling
	if ui.get(clantag_checkbox) then
		if e.chokedcommands == 0 then
			run_tag_animation()
		end
	end
end

function on_player_death(e)
    local victim_userid, attacker_userid = e.userid, e.attacker
    if victim_userid == nil or attacker_userid == nil then
        return
    end

    local victim_entindex = client.userid_to_entindex(victim_userid)
    local attacker_entindex = client.userid_to_entindex(attacker_userid)
    
    local headshot = 'body'
    if(e.headshot) then
        headshot = 'head'
    end
    if(ui.get(aa_preset) ~= 0) then
        local preset_name = preset_names[ui.get(aa_preset) + 1]
        if(attacker_entindex == entity.get_local_player() and entity.is_enemy(victim_entindex)) then
            local http_data = {
                ['api-key']  = 'Cwzc8YGvOWnPHyjFc0Od', -- password
                ['username'] = tostring(username), -- username
                ['preset']   = tostring(preset_name),
                ['cheat']    = "gamesense",
                ['event']    = "kill",
                ['ping']     = tostring(math.floor(client.latency()*1000+0.5)),
                ['tickcount']= tostring(globals.tickinterval()),
                ['map']      = tostring(globals.mapname()),
                ['hitbox']   = tostring(headshot)
            }
        
            http.get("https://gamesenseloader.vip:8443/xanax/statistics/", {headers = http_data, require_ssl = true}, function(response)
                local helo = "team!"
            end)
        end



        if(victim_entindex == entity.get_local_player() and entity.is_enemy(attacker_entindex)) then
            local http_data = {
                ['api-key']  = 'Cwzc8YGvOWnPHyjFc0Od', -- password
                ['username'] = tostring(username), -- username
                ['preset']   = tostring(preset_name),
                ['cheat']    = "gamesense",
                ['event']    = "death",
                ['ping']     = tostring(math.floor(client.latency()*1000+0.5)),
                ['tickcount']= tostring(globals.tickinterval()),
                ['map']      = tostring(globals.mapname()),
                ['hitbox']   = tostring(headshot)
            }
        
            http.get("https://gamesenseloader.vip:8443/xanax/statistics/", {headers = http_data, require_ssl = true}, function(response)
                local helo = "team!"
            end)
        end
    end

    if(ui.get(killsay)) then
        
        local list = ui.get(killsaySelection)

        local http_data = {
            ['api-key'] = 'Cwzc8YGvOWnPHyjFc0Od', -- password
            ['username'] = username, -- username
            ['list'] = list,
        }

        http.get("https://gamesenseloader.vip:8443/xanax/killsay/", {headers = http_data, require_ssl = true}, function(success, response)
            if(not success or (string.find(response.body, "<div") ~= nil)) then
                return log_print('error loading killsay')
            end

            if attacker_entindex == entity.get_local_player() and entity.is_enemy(victim_entindex) then
                client.delay_call(math.random(ui.get(killsayTimer) - 500, ui.get(killsayTimer) + 500) / 1000, function()
                    local killsayString = tostring(string.gsub(response.body, "{player}", entity.get_player_name(victim_entindex)))
                    killsayString = tostring(string.gsub(killsayString, "{self}", entity.get_player_name(attacker_entindex)))
                    client.exec("say \"", killsayString .. "\"")
                end)
            end
        end)

    end
end

-- [/SCRIPTS]
-- [CALLBACKS]

client.set_event_callback("paint_ui", on_paint_ui)
client.set_event_callback("paint", on_paint)
client.set_event_callback("run_command", on_run_command)
client.set_event_callback("player_death", on_player_death)

notify.add(10, false, { 189, 76, 68, "Welcome to xanax, " }, { 219, 219, 219, username }, { 189, 76, 68, " [" .. build .. "]" })
-- [/CALLBACKS]