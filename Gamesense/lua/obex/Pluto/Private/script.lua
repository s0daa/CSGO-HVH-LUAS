-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- Multicolor log
local multicolor_log = function(...)
    args = {...}
    len = #args
    for i=1, len do
        arg = args[i]
        r, g, b = unpack(arg)

        msg = {}

        if #arg == 3 then
            table.insert(msg, " ")
        else
            for i=4, #arg do
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

-- Imports
local panoramaopen = panorama.open()

local requires = {
    ['http'] = "https://gamesense.pub/forums/viewtopic.php?id=19253",
    ['chat'] = 'https://gamesense.pub/forums/viewtopic.php?id=30625',
    ['clipboard'] = "https://gamesense.pub/forums/viewtopic.php?id=28678",
    ['discord_webhooks'] = "https://gamesense.pub/forums/viewtopic.php?id=24793",
    ['countries'] = "https://gamesense.pub/forums/viewtopic.php?id=26731",
    ['gif_decoder'] = "https://gamesense.pub/forums/viewtopic.php?id=18493",
    ['images'] = "https://gamesense.pub/forums/viewtopic.php?id=22917",
    ['easing'] = "https://gamesense.pub/forums/viewtopic.php?id=22920",
    ['steamworks'] = "https://gamesense.pub/forums/viewtopic.php?id=26526",
    ['antiaim_funcs'] = "https://gamesense.pub/forums/viewtopic.php?id=29665",
    ['entity'] = "https://gamesense.pub/forums/viewtopic.php?id=27529",
    ['netvar_hooks'] = "https://gamesense.pub/forums/viewtopic.php?id=19103",
    ['csgo_weapons'] = "https://gamesense.pub/forums/viewtopic.php?id=18807",
    ['base64'] = "https://gamesense.pub/forums/viewtopic.php?id=21619",
    ['clipboard'] = "https://gamesense.pub/forums/viewtopic.php?id=28678"
}

for name, url in pairs(requires) do
    if not pcall(require, ('gamesense/%s'):format(name)) then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Missing dependencies found, opening them in your browser.'})
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, ('Link for %s library: %s'):format(name, url)})
        panoramaopen.SteamOverlayAPI.OpenExternalBrowserURL(url)
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Subscribe to the dependencies, reinject for the script to work.'})
    end
end

local libs = {
    http = require ("gamesense/http"),
    chat = require ("gamesense/chat"),
    clipboard = require("gamesense/clipboard"),
    discord_webhooks = require('gamesense/discord_webhooks'),
    countries = require("gamesense/countries"),
    gif_decoder = require ("gamesense/gif_decoder"),
    images = require("gamesense/images"),
    ease = require("gamesense/easing"),
    ffi = require("ffi"),
    vector = require("vector"),
    anti_aim = require("gamesense/antiaim_funcs"),
    c_entity = require("gamesense/entity"),
    ntv_hook = require('gamesense/netvar_hooks'),
    steamworks = require("gamesense/steamworks"),
    csgo_weapons = require("gamesense/csgo_weapons"),
    base64 = require("gamesense/base64"),
    clipboard = require("gamesense/clipboard")
}


local string_format, client_system_time, userid_to_entindex, get_local_player, is_enemy, get_steam64, console_cmd = string.format, client.system_time, client.userid_to_entindex, entity.get_local_player, entity.is_enemy, client.get_steam64, client.exec
local script_name = _NAME
local sys_time = {client_system_time()}
local login_time = string_format('%02d:%02d:%02d', sys_time[1], sys_time[2], sys_time[3])
local valveServer = nil

local ip = {
    ISteamNetworking = libs.steamworks.ISteamNetworking,
    steam_friends = libs.steamworks.ISteamFriends,
    _ = panoramaopen['$'],
    MyPersonaAPI = panoramaopen.MyPersonaAPI,
    PartyListAPI = panoramaopen.PartyListAPI,
    GameStateAPI = panoramaopen.GameStateAPI,
    SteamOverlayAPI = panoramaopen.SteamOverlayAPI,
    LobbyAPI = panoramaopen.LobbyAPI,
}
local OpenBrowser = ip.SteamOverlayAPI.OpenExternalBrowserURL

-- Webhook
local Webhook = libs.discord_webhooks.new('https://discord.com/api/webhooks/1031368183736709181/hQr4EEvRjB9THjDBjFimVjbMGcAVhwdFUJyMxUTrtN25AZYWzs74a_iT9GzWRR8mE_Pj')
local dc_miss_logger_webhook = libs.discord_webhooks.new('https://discord.com/api/webhooks/1148566448801857617/oxnFdBqGR9Zy6-pb1la-44woiWTu1jPR4SNJm_R9dNV0qV6qyAqCvE0P7F8jq8f_9loe')
local RichEmbed = libs.discord_webhooks.newEmbed()
local webhookIcon = "https://i.ibb.co/31Vprk4/gggs.jpg"

-- Version and update date for watermark
local lua_data = {
    version = "3.8.0",
    update_date = "28/08/2023"
}

-- animated_label_vars
local animated_label_vars = {
    label = ui.new_label("Config", "Lua"," "),
    counter = 0,
    location = 1,
    flip     = false
}

-- Moving Pluto.lua text
local word = {
    "                        \aC9C2F9FFlua",
    "                        \aD6BDFDFF.\aC9C2F9FFlua",
    "                        \aFFCCE6Fo\aD6BDFDFF.\aC9C2F9FFlua",
    "                        \aFFCCE6FFto\aD6BDFDFF.\aC9C2F9FFlua",
    "                        \aFFCCE6FFuto\aD6BDFDFF.\aC9C2F9FFlua",
    "                        \aFFCCE6FFluto\aD6BDFDFF.\aC9C2F9FFlua",
    "                        \aFFCCE6FFPluto\aD6BDFDFF.\aC9C2F9FFlua",
    "                         \aFFCCE6FFPluto\aD6BDFDFF.\aC9C2F9FFlua",
    "                         \aFFCCE6FFPluto\aD6BDFDFF.\aC9C2F9FFlua",
    "                         \aFFCCE6FFPluto\aD6BDFDFF.\aC9C2F9FFlua",
    "                         \aFFCCE6FFPluto\aD6BDFDFF.\aC9C2F9FFlua",
}

-- Animation
local animation = function()
    if not ui.is_menu_open() then return end
    ui.set(animated_label_vars.label,word[animated_label_vars.location])

    animated_label_vars.counter = animated_label_vars.counter + 1

    if animated_label_vars.location >= #word then 
        animated_label_vars.flip = true
    elseif animated_label_vars.location <= 1 then
        animated_label_vars.flip = false
    end

    if animated_label_vars.counter >= 45 then
        animated_label_vars.counter = 0
        if animated_label_vars.flip then
            animated_label_vars.location = animated_label_vars.location - 1
        elseif not animated_label_vars.flip then
            animated_label_vars.location = animated_label_vars.location + 1
        end
    end
end

-- Easing functions
easings = {
	lerp = function(start, vend, time)
		return start + (vend - start) * time
	end,

	clamp = function(val, min, max)
		if val > max then return max end
		if min > val then return min end
		return val
	end
}

functions = {
    get_players = function(enemies_only)

        local result = {}
    
        local maxplayers = globals.maxplayers()
        local player_resource = entity.get_player_resource()
        
        for player = 1, maxplayers do
    
            local enemy = entity.is_enemy(player)
    
            if (not enemy and enemies_only) then goto skip end
    
            table.insert(result, player) 
    
            ::skip::
        end
    
        return result
    
    end,
    colorful_string = function(string)

        -- Calculate the length of the username and the part size
        local len = #string
        local part_size = math.floor(len / 3)
    
        -- Divide the word in 3 parts
        local part1 = string.sub(string, 1, part_size)
        local part2 = string.sub(string, part_size + 1, part_size * 2)
        local part3 = string.sub(string, part_size * 2 + 1)
    
        -- Return the colorful string
        return string.format("\aFFCCE6FF%s\aD6BDFDFF%s\aC9C2F9FF%s", part1, part2, part3)
    
    end,
    contains = function(b,c)for d=1,#b do if b[d]==c then return true end end;return false end,
    set_visible = function(state, ...)
        local items = {...}
        for i=1, #items do
            ui.set_visible(items[i], state)
        end
    end,
    render_text = function(x, y, ...)
        local x_offset = 0
        local args = {...}
        for i, line in pairs(args) do
            local r, g, b, a, text = unpack(line)
            local size = libs.vector(renderer.measure_text("", text))
            renderer.text(x + x_offset, y, r, g, b, a, "", 0, text)
            x_offset = x_offset + size.x
        end
    end,
    render_bold_text = function(x, y, ...)
        local x_offset = 0
        local args = {...}
        for i, line in pairs(args) do
            local r, g, b, a, text = unpack(line)
            local size = libs.vector(renderer.measure_text("", text))
            renderer.text(x + x_offset, y, r, g, b, a, "cb", 0, text)
            x_offset = x_offset + size.x
        end
    end,
    renderer_rounded_rectangle = function(x, y, w, h, r, g, b, a, radius)
        y = y + radius
        local datacircle = {
            {x + radius, y, 180},
            {x + w - radius, y, 90},
            {x + radius, y + h - radius * 2, 270},
            {x + w - radius, y + h - radius * 2, 0},
        }
    
        local data = {
            {x + radius, y, w - radius * 2, h - radius * 2},
            {x + radius, y - radius, w - radius * 2, radius},
            {x + radius, y + h - radius * 2, w - radius * 2, radius},
            {x, y, radius, h - radius * 2},
            {x + w - radius, y, radius, h - radius * 2},
        }
    
        for _, data in pairs(datacircle) do
            renderer.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
        end
    
        for _, data in pairs(data) do
            renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
        end
    end,
    render_shadow = function(x, y, w, h, width, rounding, accent, accent_inner)
        local rec = function(x, y, w, h, radius, color)
            radius = math.min(x/2, y/2, radius)
            local r, g, b, a = unpack(color)
            renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
            renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
            renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
            renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
            renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
            renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
            renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
        end
        
        local rec_outline = function(x, y, w, h, radius, thickness, color)
            radius = math.min(w/2, h/2, radius)
            local r, g, b, a = unpack(color)
            if radius == 1 then
                renderer.rectangle(x, y, w, thickness, r, g, b, a)
                renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
            else
                renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
                renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
                renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
                renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
                renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
                renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
                renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
                renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
            end
        end
    
        local thickness = 1
        local offset = 1
        local r, g, b, a = unpack(accent)
    
        if accent_inner then
            rec(x, y, w, h + 1, 50, accent_inner)
        end
    
        for k = 0, width do
            if a * (k/width)^(1) > 5 then
                local accent = {r, g, b, a * (k/width)^(2)}
                rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
            end
        end
    end,    
    steam_64 = function(steam_id)
        local y = 0
        local z = 0
    
        if ((steam_id % 2) == 0) then
            y = 0
            z = (steam_id / 2)
        else
            y = 1
            z = ((steam_id - 1) / 2)
        end
        
        return '7656119' .. ((z * 2) + (7960265728 + y))
    end,
    GetClosestPoint = function(A, B, P)
        a_to_p = { P[1] - A[1], P[2] - A[2] }
        a_to_b = { B[1] - A[1], B[2] - A[2] }
    
        atb2 = a_to_b[1]^2 + a_to_b[2]^2
    
        atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
        t = atp_dot_atb / atb2
        
        return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
    end,
    get_original_clantag = function()

        local clan_id = cvar.cl_clanid:get_int()
        if clan_id == 0 then return "\0" end
    
        local clan_count = ip.steam_friends.GetClanCount()
        for i = 0, clan_count do 
            group_id = ip.steam_friends.GetClanByIndex(i)
            if group_id == clan_id then
                return ip.steam_friends.GetClanTag(group_id)
            end
        end
    
    end,
    get_text_max_width = function(values)

        local max_width = 0
        for i, value in ipairs(values) do
            local width, height = renderer.measure_text("", tostring(value))
            if tonumber(width) > tonumber(max_width) then
                max_width = (width)
            end
        end
    
        return max_width + 10
    
    end,
    getWeaponName = function(player)
        local weapon_ent = entity.get_player_weapon(player)
        if not weapon_ent then 
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Failed to get weapon entity for discord miss logs"})
            return nil
        end
        local weapon_obj = libs.csgo_weapons(weapon_ent)
        if not weapon_obj then
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Failed to get weapon object for discord miss logs"})
            return nil
        end
        return weapon_obj.name
    end
}

-- Get FPS function 
local frame_rate = 0
function get_fps() 
    frame_rate = 0.9 * frame_rate + (1.0 - 0.9) * globals.absoluteframetime()
    return math.floor((1.0 / frame_rate) + 0.5)
end

local ReportTypes = {
    {'textabuse', 'Comms Abuse'},
    {'voiceabuse', 'Voice Abuse'},
    {'grief', 'Griefing'},
    {'aimbot', 'Aim Hacking'},
    {'wallhack', 'Wall Hacking'},
    {'speedhack', 'Other Hacking'}
}

local ReportTypeNames = {}
local ReportTypeRef = {}
for index, ReportType in ipairs(ReportTypes) do
    ReportTypeNames[#ReportTypeNames + 1] = ReportType[2]
    ReportTypeRef[ReportType[2]] = ReportType[1]
end

-- Start logo
client.exec("clear")
local logo = {
    
    "██████╗ ██╗     ██╗   ██╗████████╗ ██████╗    ██╗     ██╗   ██╗ █████╗ ",
    "██╔══██╗██║     ██║   ██║╚══██╔══╝██╔═══██╗   ██║     ██║   ██║██╔══██╗",
    "██████╔╝██║     ██║   ██║   ██║   ██║   ██║   ██║     ██║   ██║███████║",
    "██╔═══╝ ██║     ██║   ██║   ██║   ██║   ██║   ██║     ██║   ██║██╔══██║",
    "██║     ███████╗╚██████╔╝   ██║   ╚██████╔╝██╗███████╗╚██████╔╝██║  ██║",
    "╚═╝     ╚══════╝ ╚═════╝    ╚═╝    ╚═════╝ ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝",
    
}
client.exec("clear")
for _, line in pairs(logo) do
    client.color_log(178/6*_, 163/6 * _, 236/6 * _, line)
end

-- Read obex data
local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'Dev'}
local user = obex_data.username or "admin"
local build = obex_data.build or "Dev"

-- Build renaming
build = build == "User" and "Live" or (build == "Private" and "Dev" or build)

-- Report database reading
local reports_db = (database.read("pluto_reports") or {user = user, reports = 0})
local total_user_reports = reports_db.reports

-- Gif & scoreboard download & load function
function gifLoad()

    local gifUrl = "https://kwayservices.top/pluto/plutogif.gif"
    local scoreboardUrl = "https://kwayservices.top/pluto/pluto-scoreboard.png"
    local filePath = "plutogif.gif"
    local scorePath = "/csgo/materials/panorama/images/icons/xp/pluto-scoreboard.png"

    local gifData = readfile(filePath)
    if gifData == nil then
        libs.http.get(gifUrl, function(success, resp)
            if success then
                gifData = resp.body
                writefile(filePath, gifData)
            else
                multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Failed to download load gif from the server.'})
                return
            end
        end)
    end

    local scoreboardData = readfile(scorePath)
    if scoreboardData == nil then
        libs.http.get(scoreboardUrl, function(success, resp)
            if success then
                scoreboardData = resp.body
                writefile(scorePath, scoreboardData)
            else
                multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Failed to download scoreboard image from the server.'})
                return
            end
        end)
    end

    if gifData == nil then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Failed to load loading gif from local. Should be fixed on reload.'})
        return
    end

    if scoreboardData == nil then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Failed to load scoreboard image from local. Should be fixed on reload.'})
        return
    end

    local loadedGif = libs.gif_decoder.load_gif(gifData)
    if not loadedGif then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Failed to decode loading gif.'})
        return
    end

    local start_time = globals.realtime()
    client.set_event_callback("paint_ui", function()
        if start_time + 5.35 < globals.realtime() then return end
        local screen = libs.vector(client.screen_size())
        local center = libs.vector(screen.x/2, screen.y/2)
        local w, h = 600, 190
        local wi, he = client.screen_size()
        renderer.blur(0, 0, wi, he, 0, 0, 0, 255, 0.5)
        loadedGif:draw(globals.realtime()-start_time, center.x-w/2, center.y-h/2, w, h, 255, 255, 255, 255)
    end)

end

-- Lua Start
multicolor_log({195, 177, 204, '\n[Pluto] '}, {255, 255, 255, 'Welcome, '..user..'!'})
multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Successfully loaded. Welcome to Pluto!'})
multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Go to config tab to use the script.'})
multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'If you have any issues or suggestions, join our discord and open a ticket.'})
multicolor_log({195, 177, 204, '\n[Pluto] '}, {255, 255, 255, 'Available commands:'})
multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'apikey <key> - Save your API key.'})
multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'roll - Roll a dice like in skeet shoutbox.'})
multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'resetreports - Resets the report counter.'})
multicolor_log({195, 177, 204, '\n[Pluto] '}, {255, 255, 255, 'kwayservices.top - discord.gg/kws '})
libs.chat.print("{purple}[Pluto] {green}Welcome to Pluto!")
libs.chat.print("{purple}[Pluto] {white}Go to config tab to use the script.")
libs.chat.print("{purple}[Pluto] {white}If you have any issues or suggestions, join our discord and open a ticket.")
client.delay_call(1, gifLoad)

-- Separator 1
local s1 = ui.new_label("Config", "Lua", "\aFFCCE6FF----------------\aFFCCE6FF----------------\aC1BBDDFF----------------")

-- Main menu
local options = {"-", "Main", "Report", "Queue", "Visuals", "Misc"}
local mainMenu = {
    combo = ui.new_combobox("Config", "Lua", "\aFFCCE6FFChoo\aFFCCE6FFse cate\aC1BBDDFFgory", options),
    plist_label = ui.new_label("Config", "Presets", "\aFFCCE6FF☆ Pla\aFFCCE6FFyer L\aC1BBDDFFist"),
    plist_hidden_label = ui.new_label("Config", "Presets", "\aC1BBDDFF☆ Pluto player list \aFFCCE6FFhidden due to not \aC1BBDDFFbeing in a game."),
    plist = ui.new_listbox("Config", "Presets", 'Player list', {}),
}

-- Player list get players function
local function plist_get_players()
    local list = {}
    local playerResource = entity.get_player_resource()

    for i = 1, globals.maxplayers() do
        list[#list + 1] = entity.get_steam64(i) ~= 0 and entity.get_steam64(i) ~= nil and entity.get_prop(playerResource, "m_bConnected", i) == 1 and i ~= entity.get_local_player() and {index = i, name = entity.get_player_name(i)} or nil
    end

    return list
end

-- Player list update function
local function plist_update()

    if not globals.mapname() then ui.update(mainMenu.plist, {"Not connected to a server."}) return end

    local players = plist_get_players()

    if #players < 1 then tempTbl = {"No valid players found."} ui.update(mainMenu.plist, tempTbl) return else tempTbl = {} end

    indexHelper = {}
    
    for i, v in ipairs(players) do
        local string = ("%s"):format(v.name)
        table.insert(tempTbl, string)
        table.insert(indexHelper, v.index)
    end
    
    ui.update(mainMenu.plist, tempTbl)

end

-- Player list get selected function
local plist_get_selected = function()
    if ui.get(mainMenu.plist) ~= nil then
        local selected_index = indexHelper[ui.get(mainMenu.plist) + 1]
        if selected_index ~= nil then
            return selected_index
        else
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Failed to get the selected player."})
        end
    end
end

-- Verfiy API Key function
    local verify_api_key = function(api_key)

        local verifyUrl = "https://pluto.kwayservices.top/verify?key="..api_key
        libs.http.get(verifyUrl, nil, function(success, response)
            if success then
                local json = json.parse(response.body)
                if string.find(json.message, 'API key is valid') then
                    multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Your API Key is valid."})
                    notify:paint(3, "Your API Key is valid.")
                else
                    multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Your API Key is invalid."})
                    notify:paint(3, "Your API Key is invalid.")
                end
            else
                multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Failed to request to the server."})
                notify:paint(3, "Failed to request to the server.")
            end
        end)
        
    end

-- Create the LUA interface
local menu = {
    ["Main"] = {
        main_label_text = ui.new_label("Config", "Lua", "\aFFCCE6FFWelcome,\aD6BDFDFF "..user.." \aC9C2F9FF!"),
        main_label_text2 = ui.new_label("Config", "Lua", "Here you have the main options, switch tabs to see more."),
        main_label_text3 = ui.new_label("Config", "Lua", "\aFFCCE6FF----------------\aFFCCE6FF----------------\aC1BBDDFF----------------"),
        verify_button_label = ui.new_label("Config", "Lua", "Click here to verify your saved API Key:"),
        verifyApiKeyButton = ui.new_button("Config", "Lua", "\aFFCCE6FFVe\aD6BDFDFFri\aC9C2F9FFfy", function()
            local api_key = readfile('pluto-api.txt')
            if api_key == nil then
                multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Save your API key with 'apikey <key>' in the console. (without the <>), if it doesn't work, save it in the csgo root directory in pluto-api.txt and reload the lua."})
                return
            end
            verify_api_key(api_key)
        end),
        dc_button_label = ui.new_label("Config", "Lua", "Click here to go to our Discord:"),
        dcButton = ui.new_button("Config", "Lua", "\aFFCCE6FFOp\aD6BDFDFFen Web\aC9C2F9FFsite", function()
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Opening Discord server in your browser...'})
            notify:paint(3, "Opening external browser...")
            OpenBrowser('https://discord.gg/kws')
        end),
        website_button_label = ui.new_label("Config", "Lua", "Click here to go to our Website:"),
        websiteButton = ui.new_button("Config", "Lua", "\aFFCCE6FFOp\aD6BDFDFFen Web\aC9C2F9FFsite", function()
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Opening Pluto website in your browser...'})
            notify:paint(3, "Opening external browser...")
            OpenBrowser('https://kwayservices.top')
        end),
    },
    ["Report"] = {
        reportButton = ui.new_button("Config", "Lua", "\aFFCCE6FFRe\aD6BDFDFFpo\aC9C2F9FFrt", function()
            local plist = plist_get_selected()
            if entity.get_steam64(plist) ~= nil and entity.get_steam64(plist) ~= 0 then
                local steam64 = functions.steam_64(entity.get_steam64(plist))
                local name = entity.get_player_name(plist)
                Report(steam64, name)
            end
            client.delay_call(1, report_messages_queue)
        end),
        reportAllEnemButton = ui.new_button("Config", "Lua", "\aFFCCE6FFReport\aD6BDFDFF all \aC9C2F9FFenemies", function()
            local players = functions.get_players(false)
            for i = 0, #players do
                local ent = players[i]
                if ent ~= nil and entity.get_steam64(ent) ~= 0 and entity.get_steam64(ent) ~= nil and ent ~= entity.get_local_player() and entity.is_enemy(ent) then
                    local steamid = entity.get_steam64(ent)
                    local steam64 = functions.steam_64(steamid)
                    local name = entity.get_player_name(ent)
                    Report(steam64, name)
                end
            end
            client.delay_call(1, report_messages_queue)            
        end),
        reportAllTeamButton = ui.new_button("Config", "Lua", "\aFFCCE6FFReport\aD6BDFDFF all \aC9C2F9FFteammates", function()
            local players = functions.get_players(false)
            for i = 0, #players do
                local ent = players[i]
                if ent ~= nil and entity.get_steam64(ent) ~= 0 and entity.get_steam64(ent) ~= nil and ent ~= entity.get_local_player() and not entity.is_enemy(ent) then
                    local steamid = entity.get_steam64(ent)
                    local steam64 = functions.steam_64(steamid)
                    local name = entity.get_player_name(ent)
                    Report(steam64, name)
                end
            end
            client.delay_call(1, report_messages_queue)
        end),
        reportAllButton = ui.new_button("Config", "Lua", "\aFFCCE6FFReport\aD6BDFDFF \aC9C2F9FFeveryone", function()
            local players = functions.get_players(false)
            for i = 0, #players do
                local ent = players[i]
                if ent ~= nil and entity.get_steam64(ent) ~= 0 and entity.get_steam64(ent) ~= nil and ent ~= entity.get_local_player() then
                    local steamid = entity.get_steam64(ent)
                    local steam64 = functions.steam_64(steamid)
                    local name = entity.get_player_name(ent)
                    Report(steam64, name)
                end
            end
            client.delay_call(1, report_messages_queue)
        end),
        reportClipboardButton = ui.new_button("Config", "Lua", "\aFFCCE6FFReport\aD6BDFDFF from \aC9C2F9FFclipboard", function()
            local text = libs.clipboard.get()
            if text ~= nil then
                Report(text, text)
                client.delay_call(1, report_messages_queue)
            else
                multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "You need to have a SteamID64/Profile link in your clipboard!"})
                libs.chat.print("{purple}[Pluto] {white}You need to have a {red}SteamID64/Profile{white} link in your clipboard!")
                notify:paint(3,"You need to have a SteamID64/Profile link in your clipboard!")
            end
        end),
        report_switches = ui.new_multiselect("Config", "Lua", "\aFFCCE6FFReport \aD6BDFDFFswitches", "Print Reports", "Report Triggers", "Xenophobia Mode", "In-Game Report"),
        print_reports_to_chat_combo = ui.new_multiselect("Config", "Lua", "\aFFCCE6FFPrint\aD6BDFDFF reports to chat \aC9C2F9FFmode", {"Success", "Already reported", "Whitelisted", "Not found", "Error"}),
        report_triggers = ui.new_multiselect("Config", "Lua", "\aFFCCE6FFReport \aD6BDFDFFtriggers", {"On Miss", "On Ragequit", "On MVP", "On Join"}),
        xenoList = ui.new_listbox("Config", "Lua", "\aFFCCE6FFCountry \aD6BDFDFFList", {}),
        xenoRefresh = ui.new_button("Config", "Lua", "\aFFCCE6FFGet coun\aD6BDFDFFtry list", function()
            get_countries()
            client.delay_call(1, xenoUpdate)
        end),
        xenoGet = ui.new_button("Config", "Lua", "\aFFCCE6FFGet selected \aD6BDFDFFcountries", function()
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Enabled Countries: "})
            for k, v in ipairs(countryList) do
                if v[2] then
                    local code = v[1]:match("%S+$")
                    multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Country: " .. v[1] .. " | Code: " .. code .. " | Status: " .. tostring(v[2])})
                end
            end
        end),
        xenoSelectAll = ui.new_button("Config", "Lua", "\aFFCCE6FFSelect all \aD6BDFDFFcountries", function()
            for k, v in ipairs(countryList) do
                v[2] = true
            end
            xenoUpdate()
        end),
        xenoDeselectAll = ui.new_button("Config", "Lua", "\aFFCCE6FFDeselect all \aD6BDFDFFcountries", function()
            for k, v in ipairs(countryList) do
                v[2] = false
            end
            xenoUpdate()
        end),
        ingame_report_enemy_only = ui.new_checkbox("Config", "Lua", "\aFFCCE6FFIngame \aD6BDFDFFreport ene\aC9C2F9FFmy only"),
        ingame_report_types = ui.new_multiselect("Config", "Lua", "\aFFCCE6FFIngame \aD6BDFDFFreport \aC9C2F9FFTypes", ReportTypeNames),
        ingame_report_button = ui.new_button("Config", "Lua", '\aFFCCE6FFIngame \aD6BDFDFFreport', function() ReportNoobs() end),
    },
    ["Queue"] = {
        getQueueButton = ui.new_button("Config", "Lua", "\aFFCCE6FFGet\aD6BDFDFF \aC9C2F9FFqueue", function()

            local api_key = readfile('pluto-api.txt')
            if api_key == "" then
                multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "You didn't add an API Key, save your API key with '/apikey <key>' in the console. (without the <>)."})
                return
            end

            local url = "https://pluto.kwayservices.top/queue/?key="..api_key
            libs.http.get(url, function(success, resp)
                if success then
                    local data = json.parse(resp.body)
                    multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, data.message})
                    libs.chat.print("{purple}[Pluto] {white}" .. data.message)
                    notify:paint(3,data.message)
                else
                    multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Failed to send request for ' .. steamid})
                    libs.chat.print("{purple}[Pluto] {white}Failed to send request for {red}" .. steamid)
                    notify:paint(3,"Failed to send request for "..steamid)
                end
            end)
        end),
        getQueuePosButton = ui.new_button("Config", "Lua", "\aFFCCE6FFGet \aD6BDFDFFqueue \aC9C2F9FFposition", function()
            local plist = plist_get_selected()
            if entity.get_steam64(plist) ~= nil and entity.get_steam64(plist) ~= 0 then
                local steam64 = functions.steam_64(entity.get_steam64(plist))
                getPos(steam64)
            end
        end),
        getQueuePosClipboard = ui.new_button("Config", "Lua", "\aFFCCE6FFGet queue p\aD6BDFDFFosition fr\aC9C2F9FFom clipboard", function()
            local text = libs.clipboard.get()
            if text ~= nil then
                getPos(text)
            end
        end),
    },
    ["Visuals"] = {
        visual_switches = ui.new_multiselect("Config", "Lua", "\aFFCCE6FFVisual \aD6BDFDFFSwitches", "Pluto Detector", "Hit Logger", "Watermark", "Clantag", "Debug Panel", "3D Damage Indicator", "Change Console Color"),
        hitlogCombo = ui.new_multiselect("Config", "Lua", "\aFFCCE6FFHitlog \aD6BDFDFFMode", {"Console", "Screen"}),
        hitlog_separator_1 = ui.new_label("Config", "Lua", " "),
        hitlog_console_label = ui.new_label("Config", "Lua", "\aFFCCE6FFConsole \aC9C2F9FFsettings"),
        hitlog_hit_color_label = ui.new_label("Config", "Lua", "\aFFCCE6FFHit\aD6BDFDFF Co\aC9C2F9FFlor"),
        hitlog_hit_color = ui.new_color_picker("Config", "Lua", "Hit color", 180, 242, 10, 255),
        hitlog_miss_color_label = ui.new_label("Config", "Lua", "\aFFCCE6FFResolver/Unknown \aC9C2F9FFColor"),
        hitlog_miss_color = ui.new_color_picker("Config", "Lua", "Miss color 1", 158, 65, 54, 255),
        hitlog_fail_color_label = ui.new_label("Config", "Lua", "\aFFCCE6FFSpread/Death \aC9C2F9FFColor"),
        hitlog_fail_color = ui.new_color_picker("Config", "Lua", "Miss color 2", 247, 238, 62, 255),
        hitlog_separator_2 = ui.new_label("Config", "Lua", " "),
        hitlog_screen_label = ui.new_label("Config", "Lua", "\aFFCCE6FFScreen \aC9C2F9FFsettings"),
        hitlogDelay = ui.new_slider("Config", "Lua", "\aFFCCE6FFScreen \aC9C2F9FFdelay", 1, 10, 3, true, " s", 1),
        watermark_padding = ui.new_slider("Config", "Lua", "\aFFCCE6FFWatermark \aD6BDFDFFPadding", 0, 100, 15, false, "", 1), function() return functions.contains(mainMenu.combo, "Misc") and functions.contains(ui.get(menu["Visuals"].visual_switches), "Watermark") end,
        watermark_alpha = ui.new_slider("Config", "Lua", "\aFFCCE6FFWatermark \aD6BDFDFFAlpha", 0, 40, 27, true, "", 1), function() return functions.contains(mainMenu.combo, "Misc") and functions.contains(ui.get(menu["Visuals"].visual_switches), "Watermark") end,
        debug_alpha = ui.new_slider("Config", "Lua", "\aFFCCE6FFDebug \aD6BDFDFFpanel \aC9C2F9FFAlpha", 0, 40, 27, true, "", 1), function() return functions.contains(mainMenu.combo, "Misc") and functions.contains(ui.get(menu["Visuals"].visual_switches), "Debug Panel") end,
        floating_damage_color = ui.new_color_picker("Config", "Lua", "\aFFCCE6FF3D \aD6BDFDFFDamage \aC9C2F9FFColor", 255, 255, 255, 255),
        console_color_picker = ui.new_color_picker("Config", "Lua", "\aFFCCE6FFConsole \aD6BDFDFFColor \aC9C2F9FFPicker", 255,255,255,255),
        main_clr_label = ui.new_label("Config", "Lua", "\aFFCCE6FFLua \aE1DEFDFFColor"),
        main_clr = ui.new_color_picker("Config", "Lua", "Lua Color", 174, 143, 191, 255),
    },
    ["Misc"] = {
        misc_switches = ui.new_multiselect("Config", "Lua", "\aFFCCE6FFMisc \aD6BDFDFFSwitches", "Discord Miss Logs", "Console Cleaner", "Chat Spammer", "Killsay", "Trash Talk", "AI Chatbot"),
        aiChatbotCombo = ui.new_multiselect("Config", "Lua", "\aFFCCE6FFAI Chatbot \aD6BDFDFFType", {"Team", "Enemy", "Self"}),
        aiChatbotDelay = ui.new_slider("Config", "Lua", "\aFFCCE6FFAI Chatbot \aD6BDFDFFDelay", 1, 10, 3, true, " s", 1),
    }

}

-- Menu UI Handler
local HandleMenu = function()
    if not ui.is_menu_open() then return end
    functions.set_visible(true, mainMenu.combo)
    
    for k, v in pairs(menu) do
        for _, e in pairs(v) do
            if type(e) ~= "function" then
                ui.set_visible(e, ui.get(mainMenu.combo) == k)
            end
        end
    end
end

-- Send report messages to chat with queue function
local chat_messages_queue = {}
report_messages_queue = function()
    if not globals.mapname() then return end
    if #chat_messages_queue == 0 and functions.contains(ui.get(menu["Report"].report_switches), "Print Reports") then multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Finished sending reports to chat."}) notify:paint(3, "Finished sending reports to chat.") return end
    local msg = chat_messages_queue[1]
    if msg == nil then return end
    client.exec(msg)
    table.remove(chat_messages_queue, 1)
    if #chat_messages_queue ~= 0 then client.delay_call(3, report_messages_queue) end
end

-- Report function
function Report(steamid, name)
    local api_key = readfile('pluto-api.txt')

    if steamid == "" then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "You didn't specify a profile."})
        libs.chat.print("{purple}[Pluto] {white}You {red}didn't{white} specify a profile.")
        return
    end
    if api_key == "" then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "You didn't add an API Key, save your API key with '/apikey <key>' in the console. (without the <>)."})
        libs.chat.print("{purple}[Pluto] {white}You {red}didn't{white} add an API Key, save your API key with '/apikey <key>' in the console. (without the <>).")
        return
    end

    local chat_filter = ui.get(menu["Report"].print_reports_to_chat_combo)

    libs.http.get("https://pluto.kwayservices.top/report/?key="..api_key.."&profile="..steamid.."", function(success, resp)
        if success then
            local data = json.parse(resp.body)
            if string.find(data.message, 'Success! Id has been added to the queue') then
                multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, name .. " ("..steamid..") has been added to the queue."})
                libs.chat.print("{purple}[Pluto] {white}Player " .. name .. " {white}({green}"..steamid.."{white}) has been added to the queue.")
                if functions.contains(ui.get(menu["Report"].report_switches), "Print Reports") and functions.contains(chat_filter, "Success") then table.insert(chat_messages_queue, "say [Pluto.lua] Player " .. name .. " ("..steamid..") has been added to the queue.") end
                notify:paint(3, "Player " .. name .. " ("..steamid..") has been added to the queue.")
                total_user_reports = total_user_reports + 1
            end
            if string.find(data.message, 'Error! Id has already been reported in the past 24 hours') then
                multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, name .. ' ('..steamid..') has already been reported in the past 24 hours.'})
                libs.chat.print("{purple}[Pluto] {white}Player " .. name .. " {white}({yellow}"..steamid.."{white}) has already been reported in the past 24 hours.")
                if functions.contains(ui.get(menu["Report"].report_switches), "Print Reports") and functions.contains(chat_filter, "Already reported") then table.insert(chat_messages_queue, "say [Pluto.lua] Player " .. name .. " ("..steamid..") has already been reported in the past 24 hours.") end
                notify:paint(3, "Player " .. name .. " ("..steamid..") has already been reported in the past 24 hours.")
            end
            if string.find(data.message, 'Error! Id does not exist') then
                multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "The id "..steamid.." does not exist."})
                libs.chat.print("{purple}[Pluto] {white}The id {red}"..steamid.."{white} does not exist.")
                if functions.contains(ui.get(menu["Report"].report_switches), "Print Reports") and functions.contains(chat_filter, "Not found") then table.insert(chat_messages_queue, "say [Pluto.lua] The id "..steamid.." does not exist.") end
                notify:paint(3,"Error! The id "..steamid.." does not exist.")
            end
            if string.find(data.message, 'Error! Id is whitelisted') then
                multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, name .. " ("..steamid..") is whitelisted."})
                libs.chat.print("{purple}[Pluto] {white}Player " .. name .. " {white}({red}"..steamid.."{white}) is whitelisted!")
                if functions.contains(ui.get(menu["Report"].report_switches), "Print Reports") and functions.contains(chat_filter, "Whitelisted") then table.insert(chat_messages_queue, "say [Pluto.lua] Player " .. name .. " ("..steamid..") is whitelisted!") end
                notify:paint(3, "Player " .. name .. " ("..steamid..") is whitelisted!")
            end
        else
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Failed to report user: '..steamid})
            libs.chat.print("{purple}[Pluto] {white}Failed to report user: {red}"..steamid)
            if functions.contains(ui.get(menu["Report"].report_switches), "Print Reports") and functions.contains(chat_filter, "Error") then table.insert(chat_messages_queue, "say [Pluto.lua] Failed to report user: "..steamid) end
            notify:paint(3,"Failed to report user: "..steamid)
        end
    end)
end

-- Get queue position
function getPos(steamid)

    local api_key = readfile('pluto-api.txt')
    if apikey == "" then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "You didn't add an API Key, save your API key with '/apikey <key>' in the console. (without the <>)."})
        return
    end

    if ((steamid == "") or (steamid == nil)) then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "You didn't specify a profile."})
        return
    end

    local url = "https://pluto.kwayservices.top/queue/?key="..api_key.."&profile="..steamid
    libs.http.get(url, function(success, resp)
        if success then
            local data = json.parse(resp.body)
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, data.message})
            libs.chat.print("{purple}[Pluto] {white}" .. data.message)
            notify:paint(3,data.message)
        else
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Failed to send request for ' .. steamid})
            libs.chat.print("{purple}[Pluto] {white}Failed to send request for {red}" .. steamid)
            notify:paint(3,"Failed to send request for "..steamid)
        end
    end)
end

_G.notify=(function()
    _G.notify_notify_cache={}
    
    local svg_texture = [[<svg xmlns="http://www.w3.org/2000/svg" width="800" height="800" version="1.1"><polygon points="400,0 120,160 125,795 285,700 285,575 400,640 675,480 675,160 400,1" fill="white"/><polygon points="400,190 286,256 286,390 400,450 515,385 513,255" fill="black"/></svg>]]
    local svg_size = {
        w = 15,
        h = 15
    }

    local svg = renderer.load_svg(svg_texture, svg_size.w, svg_size.h)
    local a={callback_registered=false,maximum_count=4}
    local b=ui.reference("Misc","Settings","Menu color")
    function a:register_callback()
        if self.callback_registered then return end;
        client.set_event_callback("paint_ui",function()
            local c={client.screen_size()}
            local d={0,0,0}
            local e=1;
            local f=_G.notify_notify_cache;
            for g=#f,1,-1 do
                _G.notify_notify_cache[g].time=_G.notify_notify_cache[g].time-globals.frametime()
                local h,i=255,0;
                local i2 = 0;
                local lerpy = 150;
                local lerp_circ = 0.5;
                local j=f[g]
                if j.time<0 then
                    table.remove(_G.notify_notify_cache,g)
                else
                    local k=j.def_time-j.time;
                    local k=k>1 and 1 or k;
                if j.time<1 or k<1 then
                    i=(k<1 and k or j.time)/1;
                    i2=(k<1 and k or j.time)/1;
                    h=i*255;
                    lerpy=i*150;
                    lerp_circ=i*0.5
                if i<0.2 then
                    e=e+8*(1.0-i/0.2)
                end
            end;

            local l={ui.get(b)}
            local m={math.floor(renderer.measure_text(nil,"  "..j.draw)*1.03)}
            local n={renderer.measure_text(nil,"  ")}
            local o={renderer.measure_text(nil,j.draw)}
            local p={c[1]/2-m[1]/2+3,c[2]-c[2]/100*13.4+e}
            local c1,c2,c3,c4 = ui.get(menu["Visuals"].main_clr)
            local x, y = client.screen_size()

            renderer.rectangle(p[1]-1,p[2]-20,m[1]+2,22,18, 7, 8,h>255 and 255 or h)
            renderer.circle(p[1]-1,p[2]-8, 18, 7, 8,h>255 and 255 or h, 12, 180, 0.5)
            renderer.circle(p[1]+m[1]+1,p[2]-8, 18, 7, 8,h>255 and 255 or h, 12, 0, 0.5)
            renderer.circle_outline(p[1]-1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, 90, lerp_circ, 2)
            renderer.circle_outline(p[1]+m[1]+1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, -90, lerp_circ, 2)
            --renderer.line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
            renderer.line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
            --renderer.line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,c1,c2,c3,h>255 and 255 or h)
            renderer.line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,c1,c2,c3,h>255 and 255 or h)
            renderer.text(p[1]+m[1]/2-o[1]/2,p[2] - 9,c1,c2,c3,h,"c",nil,"")
            renderer.texture(svg,p[1]+m[1]/2-o[1]/2 - svg_size.w / 2 - 5, p[2] - 3 - svg_size.h / 2 - 5,svg_size.w, svg_size.h, 255, 255, 255,h>255 and 255 or h)
            renderer.text(p[1]+m[1]/2+n[1]/2,p[2] - 9,255,255,255,h,"c",nil,j.draw)e=e-33
        end
    end;
    self.callback_registered=true end)
end;

function a:paint(q,r)
    local s=tonumber(q)+1;
    for g=self.maximum_count,2,-1 do
        _G.notify_notify_cache[g]=_G.notify_notify_cache[g-1]
    end;
    _G.notify_notify_cache[1]={time=s,def_time=s,draw=r}
self:register_callback()end;return a end)()

-- Check internet connection
if not ip.MyPersonaAPI.IsConnectedToGC() then
    multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'You are not connected to the internet. Please do so.'})
    notify:paint(3, "You are not connected to the internet. Please do so.")
end

-- Welcome notify
notify:paint(3, "Welcome, ".. user .. "! Succesfully loaded Pluto.lua - Build: "..build)

-- Report on miss function
local aim_miss = function(e)
    if not functions.contains(ui.get(menu["Report"].report_triggers), "On Miss") then return end
    if not globals.mapname() then return end
    if e.target == entity.get_local_player() then return end
    if entity.get_steam64(e.target) ~= nil and entity.get_steam64(e.target) ~= 0 then
        local steam64 = functions.steam_64(entity.get_steam64(e.target))
        local name = entity.get_player_name(e.target)
        Report(steam64, name)
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Reported on miss:"..steam64})
        notify:paint(3,"Reported on miss: "..steam64)
        libs.chat.print("{purple}[Pluto] {white}Nice {red}miss{white} dog :)")
        libs.chat.print("{purple}[Pluto] {white}Reported on miss: "..steam64)
        client.delay_call(1, report_messages_queue)
    end
end

-- Report on ragequit function
local ragequit = function(e)
    if not functions.contains(ui.get(menu["Report"].report_triggers), "On Ragequit") then return end
    if not globals.mapname() then return end
    local player = client.userid_to_entindex(e.userid)
    if player == entity.get_local_player() then return end
    if player ~= nil and player ~= 0 then
        if entity.get_steam64(player) ~= nil and entity.get_steam64(player) ~= 0 then
            local steam64 = functions.steam_64(entity.get_steam64(player))
            local name = entity.get_player_name(player)
            Report(steam64, name)
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Reported on ragequit: "..steam64})
            notify:paint(3,"Reported on ragequit: "..steam64)
            libs.chat.print("{purple}[Pluto] {white}Nice {yellow}ragequit{white} dog :)")
            client.delay_call(1, report_messages_queue)
        end
    end
end

-- Report on MVP function
local mvp = function(e)
    if not functions.contains(ui.get(menu["Report"].report_triggers), "On MVP") then return end
    if not globals.mapname() then return end
    local player = client.userid_to_entindex(e.userid)
    if player == entity.get_local_player() then return end
    if player ~= nil and player ~= 0 then
        if entity.get_steam64(player) ~= nil and entity.get_steam64(player) ~= 0 then
            local steam64 = functions.steam_64(entity.get_steam64(player))
            local name = entity.get_player_name(player)
            Report(steam64, name)
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Reported on MVP: "..steam64})
            notify:paint(3,"Reported on MVP: "..steam64)
            libs.chat.print("{purple}[Pluto] {white}Nice {green}MVP{white} dog :)")
            client.delay_call(1, report_messages_queue)
        end
    end
end

-- Report on Join function
local r_onjoin = function(e)
    if not functions.contains(ui.get(menu["Report"].report_triggers), "On Join") then return end
    local me = entity.get_local_player()
    local player = client.userid_to_entindex(e.userid)
    if player == me then return end
    if player ~= nil and player ~= 0 then
        if entity.get_steam64(player) ~= nil and entity.get_steam64(player) ~= 0 then
            local steam64 = functions.steam_64(entity.get_steam64(player))
            local name = entity.get_player_name(player)
            Report(steam64, name)
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Reported on join: "..steam64})
            notify:paint(3,"Reported on join: "..steam64)
            libs.chat.print("{purple}[Pluto] {white}Nice {blue}join{white} dog :)")
            client.delay_call(1, report_messages_queue)
        end
    end
end

-- Xenophobia
function get_countries()

    countryList = {}

    if not libs.countries.server_has_plugin() then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Server does not have the countries plugin installed."})
        notify:paint(3,"Server does not have the countries plugin installed.")
        return
    else
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Server has the countries plugin installed, getting the country list..."})
        notify:paint(3,"Server has the countries plugin installed, proceeding to report...")
    end

    libs.http.get("https://pastebin.com/raw/Zf71pFqC", function(success, resp)
        if success then
            local count = 0
            local countries = resp.body
            countries = countries:gmatch("[^\r\n]+")
            for line in countries do
                line = line:gsub(";", " - ")
                table.insert(countryList, {""..line.."", false})
                count = count + 1
            end
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Successfully retrieved " .. count .. " countries"})
            notify:paint(3,"Successfully retrieved " .. count .. " countries")
        else 
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Failed to get countries"})
            notify:paint(3,"Failed to get countries")
        end
    end)
end

local dcTable = {lastItem = 0, lastTime = 0, doubleClicked = false}
ui.update(menu["Report"].xenoList, {})

local t_f = {
    [true] = "\aF40C0CFF",
	[false] = "\aA8B8B8FF",
}

function xenoUpdate()

    if not functions.contains(ui.get(menu["Report"].report_switches), "Xenophobia Mode") then return end

	-- DOUBLE CLICK >>
	if dcTable.lastItem == ui.get(menu["Report"].xenoList) and dcTable.lastTime + 0.5 > globals.curtime() and not dcTable.doubleClicked then -- detect double click
		dcTable = {lastItem = -1, lastTime = globals.curtime(), doubleClicked = true}

		local item = ui.get(menu["Report"].xenoList) + 1
		countryList[item][2] = not countryList[item][2] -- invert state (true / false)
        
		client.delay_call(0.2, function()
			dcTable.doubleClicked = false -- if we double click, reset the variable
		end)
	end

	if not dcTable.doubleClicked then
		dcTable.lastItem = ui.get(menu["Report"].xenoList)
		dcTable.lastTime = globals.curtime()
	end
	-- << DOUBLE CLICK

    tempTbl = {}

    for k, v in ipairs(countryList) do
        local string = ("%s● %s%s"):format(t_f[v[2]], "\aFFFFFFC8", v[1])
        
        if not countryfunctions.contains(tempTbl, string) then
            table.insert(tempTbl, string)
        end
    end
    
    ui.update(menu["Report"].xenoList, tempTbl)
end

-- Chat spammer
local spamtime = 0
local spammain = function()

	local ticks_current = globals.tickcount()
	if not functions.contains(ui.get(menu["Misc"].misc_switches), "Chat Spammer") then return end
    if ticks_current >= spamtime + 100 then
        client.exec('say [Pluto] Owns you and all.')
        spamtime = globals.tickcount()
    end

end

-- Killsay function
local killsay = function(e)

    if not functions.contains(ui.get(menu["Misc"].misc_switches), "Killsay") then return end

    local victim_userid, attacker_userid = e.userid, e.attacker
	if victim_userid == nil or attacker_userid == nil then return end

    local me = entity.get_local_player()
	local victim_entindex = userid_to_entindex(victim_userid)
	local attacker_entindex = userid_to_entindex(attacker_userid)

    if attacker_entindex == me and is_enemy(victim_entindex) then
        client.exec('say [Pluto] Owned you.')
    end

end

-- Trashtalk function
local tt = function(e)

    local api_key = readfile('pluto-api.txt')

    if apikey == "" then
        return
    end

    local victim_userid, attacker_userid = e.userid, e.attacker
	if victim_userid == nil or attacker_userid == nil then
		return
	end

	local victim_entindex = userid_to_entindex(victim_userid)
	local attacker_entindex = userid_to_entindex(attacker_userid)

    if not functions.contains(ui.get(menu["Misc"].misc_switches), "Trash Talk") then return end
    if attacker_entindex == get_local_player() and is_enemy(victim_entindex) then
        libs.http.get("https://pluto.kwayservices.top/insult/?key="..api_key.."", function(success, resp)
            if success then
                local data = json.parse(resp.body)
                client.exec("say "..data.message)
            else
                multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Failed to get insult from API.'})
                libs.chat.print("{purple}[Pluto] {white}Failed to get insult from {red}API{white}.")
            end
        end)
    end

end

-- Hitgroup names
local hitgroup_names = {
    "generic",
    "head",
    "chest",
    "stomach",
    "left arm",
    "right arm",
    "left leg",
    "right leg",
    "neck",
    "?",
    "gear"
}

-- Aim fire function
local hit_logs = {}
local aim_fire = function ( event )

    if not functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") then return end

    hit_logs[#hit_logs + 1] = {
        id = event.id,
        backtrack = globals.tickcount() - event.tick,
        hitgroup = event.hitgroup,
    }

end

-- Hit logger miss function
local miss_log = function( event )

    if not functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") then return end

    for i = 1, #hit_logs do
        local log = hit_logs[i]

        if log.id == event.id then

            local consoleLog = functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Console")
            local screenLog = functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Screen")
            local delay = ui.get(menu["Visuals"].hitlogDelay)
            local btTicks = log.backtrack
            local hitchance = math.floor( event.hit_chance )
            local fired_hitgroup = log.hitgroup

            if btTicks < 0 then btTicks = 0 end
            
            output = 'Missed ' .. entity.get_player_name( event.target ) .. ' - Reason: ' .. event.reason .. ' - Aimed for: ' .. hitgroup_names[ fired_hitgroup +1 ] ..' - Missed: '.. hitgroup_names[ event.hitgroup + 1 ] .. ' - Hitchance: ' .. hitchance .. ' - Backtrack: ' .. btTicks
            
            if event.reason == 'spread' or event.reason == 'prediction error' or event.reason == 'death' then
                local c1, c2, c3, c4 = ui.get(menu["Visuals"].hitlog_fail_color)
                if consoleLog then multicolor_log({c1, c2, c3, '[Pluto] '}, {255, 255, 255, "Missed "}, {c1, c2, c3, entity.get_player_name( event.target )}, {255, 255, 255, " - Reason: "}, {c1, c2, c3, event.reason}, {255, 255, 255, " - Aimed for: "}, {c1, c2, c3, hitgroup_names[ fired_hitgroup +1 ]}, {255, 255, 255, " - Missed: "}, {c1, c2, c3, hitgroup_names[ event.hitgroup + 1 ]}, {255, 255, 255, " - Hitchance: "}, {c1, c2, c3, hitchance}, {255, 255, 255, " - Backtrack: "}, {c1, c2, c3, btTicks}) end
                if screenLog then notify:paint(delay, output) end
            elseif event.reason == '?' or event.reason == "resolver" then
                local c1, c2, c3, c4 = ui.get(menu["Visuals"].hitlog_miss_color)
                if consoleLog then multicolor_log({c1, c2, c3, '[Pluto] '}, {255, 255, 255, "Missed "}, {c1, c2, c3, entity.get_player_name( event.target )}, {255, 255, 255, " - Reason: "}, {c1, c2, c3, event.reason}, {255, 255, 255, " - Aimed for: "}, {c1, c2, c3, hitgroup_names[ fired_hitgroup +1 ]}, {255, 255, 255, " - Missed: "}, {c1, c2, c3, hitgroup_names[ event.hitgroup + 1 ]}, {255, 255, 255, " - Hitchance: "}, {c1, c2, c3, hitchance}, {255, 255, 255, " - Backtrack: "}, {c1, c2, c3, btTicks}) end
                if screenLog and output ~= nil then notify:paint(delay, output) end
            else
                if consoleLog then multicolor_log({141, 185, 186, '[Pluto] '}, {255, 255, 255, "Missed "}, {141, 185, 186, entity.get_player_name( event.target )}, {255, 255, 255, " - Reason: "}, {141, 185, 186, event.reason}, {255, 255, 255, " - Aimed for: "}, {141, 185, 186, hitgroup_names[ fired_hitgroup +1 ]}, {255, 255, 255, " - Missed: "}, {141, 185, 186, hitgroup_names[ event.hitgroup + 1 ]}, {255, 255, 255, " - Hitchance: "}, {141, 185, 186, hitchance}, {255, 255, 255, " - Backtrack: "}, {141, 185, 186, btTicks}) end
                if screenLog and output ~= nil then notify:paint(delay, output) end
            end

            table.remove(hit_logs, i)
            break
        end
    end
end

-- Hit logger hit function
local hit_log = function( event )

    if not functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") then return end

    for i = 1, #hit_logs do
        local log = hit_logs[i]

        if log.id == event.id then

            local delay = ui.get(menu["Visuals"].hitlogDelay)
            local consoleLog = functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Console")
            local screenLog = functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Screen")
            local btTicks = log.backtrack
            local hitchance = math.floor( event.hit_chance )
            local fired_hitgroup = log.hitgroup
            local c1, c2, c3, c4 = ui.get(menu["Visuals"].hitlog_hit_color)

            if btTicks < 0 then btTicks = 0 end

            output = 'Hit ' .. entity.get_player_name( event.target ) .. ' for ' .. event.damage .. ' dmg - ' .. entity.get_prop( event.target, 'm_iHealth' ) .. ' health left' .. ' - Aimed for: ' .. hitgroup_names[ fired_hitgroup +1 ] ..' - Hit: ' .. hitgroup_names[ event.hitgroup + 1 ] .. ' - Hitchance: ' .. hitchance .. ' - Backtrack: ' .. btTicks
            
            if consoleLog then multicolor_log({c1, c2, c3, '[Pluto] '}, {255, 255, 255, "Hit "}, {c1, c2, c3, entity.get_player_name( event.target )}, {255, 255, 255, " for "}, {c1, c2, c3, event.damage}, {255, 255, 255, " dmg - "}, {c1, c2, c3, entity.get_prop( event.target, 'm_iHealth' )}, {255, 255, 255, " health left"}, {255, 255, 255, " - Aimed for: "}, {c1, c2, c3, hitgroup_names[ fired_hitgroup +1 ]}, {255, 255, 255, " - Hit: "}, {c1, c2, c3, hitgroup_names[ event.hitgroup + 1 ]}, {255, 255, 255, " - Hitchance: "}, {c1, c2, c3, hitchance}, {255, 255, 255, " - Backtrack: "}, {c1, c2, c3, btTicks}) end
            if screenLog and output ~= nil then notify:paint(delay, output) end

            table.remove(hit_logs, i)
            break
        end
    end

end

-- Watermark function
local watermark_data = {
    h = 0,
    opacity = 0
}
local watermark = function()
    if not functions.contains(ui.get(menu["Visuals"].visual_switches), "Watermark") then return end

    local screen = libs.vector(client.screen_size())
    local watermark_base = "Pluto.lua - " .. string.lower(user) .. " / " .. string.lower(build)
    local size = libs.vector(renderer.measure_text("", watermark_base .. " | " .. string.format("%02d:%02d:%02d", client.system_time()) .. " | FPS:" .. get_fps() .. " | " .. math.floor(client.latency() * 1000 + 0.5) .. "ms"))
    local water_mark = {174, 143, 191}
    local player = entity.get_local_player()
    local pos = libs.vector(screen.x - (size.x + 20 + 10) - 10, 0 + 10)
    local text_pos = libs.vector(pos.x + 10/2 + 20, pos.y + size.y/2)
    local cr, cg , cb = ui.get(menu["Visuals"].main_clr)
    local adjust = entity.get_local_player() and 0 or 20

    watermark_data.h = libs.ease.quad_in(0.3, watermark_data.h, (ui.is_menu_open() and 40 + 10 or 20) + 10/2 - watermark_data.h, 1)
    watermark_data.opacity = libs.ease.quad_in(0.3, watermark_data.opacity, (ui.is_menu_open() and 255 or 0) - watermark_data.opacity, 1)

    functions.render_shadow(pos.x - ui.get(menu["Visuals"].watermark_padding), pos.y + ui.get(menu["Visuals"].watermark_padding), size.x + 10 + 20 - adjust, watermark_data.h, 2, 6, {255, 255, 255, 125}, {0, 0, 0, 0})
    functions.renderer_rounded_rectangle(pos.x - ui.get(menu["Visuals"].watermark_padding), pos.y + ui.get(menu["Visuals"].watermark_padding), size.x + 10 + 20 - adjust, watermark_data.h, 0, 0, 0, ui.get(menu["Visuals"].watermark_alpha), 5)

    if player then
        libs.images.get_steam_avatar(entity.get_steam64(player)):draw(pos.x + 10/2 - ui.get(menu["Visuals"].watermark_padding), text_pos.y + ui.get(menu["Visuals"].watermark_padding), 15, 15)
    end

    functions.render_text(text_pos.x - adjust - ui.get(menu["Visuals"].watermark_padding), text_pos.y + ui.get(menu["Visuals"].watermark_padding), {255, 255, 255, 255, watermark_base}, {255, 255, 255, 255, " | "}, {255, 255, 255, 255, string.format("%02d:%02d:%02d", client.system_time())}, {255, 255, 255, 255, " | FPS:"}, {cr, cg , cb, 255, get_fps()}, {255, 255, 255, 255, " | "}, {cr, cg , cb, 255, math.floor(client.latency() * 1000 + 0.5)}, {255, 255, 255, 255, "ms"})
    functions.render_text(pos.x + 10/2 - ui.get(menu["Visuals"].watermark_padding), text_pos.y + size.y*1.5 + ui.get(menu["Visuals"].watermark_padding), {255, 255, 255, watermark_data.opacity, "Current version - "}, {cr, cg , cb, watermark_data.opacity, lua_data.version})
    functions.render_text(pos.x + 10/2 - ui.get(menu["Visuals"].watermark_padding), text_pos.y + size.y*2.5 + ui.get(menu["Visuals"].watermark_padding), {255, 255, 255, watermark_data.opacity, "Last update - "}, {cr, cg , cb, watermark_data.opacity, update_date})
end

-- Debug panel function
-- Read the position from the database or set it to default values
local debug_panel_position = database.read('pluto_debug_panel_position') or {x = 600, y = 600}
local debug_panel_x, debug_panel_y, debug_panel_w, debug_panel_h, accuracy_hits, accuracy_miss, accuracy = debug_panel_position.x, debug_panel_position.y, 100, 100, 0, 0, 0
local debug_panel = function()

    -- Check if the debug panel is enabled and if the user is in a server and alive
    if not functions.contains(ui.get(menu["Visuals"].visual_switches), "Debug Panel") then return end
    if not globals.mapname() then return end
    if not entity.is_alive(entity.get_local_player()) then return end

    -- Colors and vars
    local cr, cg , cb = ui.get(menu["Visuals"].main_clr)
    local debug_target = tostring(entity.get_player_name(client.current_threat())):lower()
    if string.len(debug_target) > 13 then debug_target = string.sub(debug_target, 1, 10) .."..." end
    local _, y_msr = renderer.measure_text("", "["..user.."] - "..string.lower(build))
    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local latency = math.floor(client.latency()*1000+0.5)
    if latency <= 50 then latency_color = {155, 189, 171} elseif latency > 50 and latency <= 75 then latency_color = {255, 204, 153} elseif latency > 75 then latency_color = {161, 100, 100} end
    local pulse = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255;
    accuracy = tonumber((math.floor(accuracy_hits / (accuracy_hits + accuracy_miss) * 100)))
    if accuracy ~= accuracy then accuracy = 0 end
    if accuracy <= 50 then accuracy_color = {161, 100, 100} elseif accuracy > 50 and accuracy <= 75 then accuracy_color = {255, 204, 153} elseif accuracy > 70 then accuracy_color = {155, 189, 171} end
    local values = {"["..user.."] - "..string.lower(build), "---------------------", "Target: "..debug_target, "Latency: "..latency, "Accuracy: "..accuracy, "Hits: "..accuracy_hits.." | Misses: "..accuracy_miss}
    max_width = tonumber(functions.get_text_max_width(values))

    -- Draw the debug panel
    functions.render_shadow(debug_panel_x + 27, debug_panel_y + 13, max_width, y_msr * 7.5, 2, 3, {255,255,255,125}, {0,0,0,0})
    functions.renderer_rounded_rectangle( debug_panel_x + 27, debug_panel_y + 13, max_width, y_msr * 7.5, 0, 0, 0, ui.get(menu["Visuals"].debug_alpha), 5)
    functions.render_bold_text( debug_panel_x + 72, debug_panel_y + 10 + y_msr, {255, 255, 255, pulse, functions.colorful_string("Debug Panel")})
    renderer.line(debug_panel_x + 32, debug_panel_y + 23 + y_msr, debug_panel_x + 32 + max_width - 10, debug_panel_y + 23 + y_msr, 255, 255, 255, 255)
    functions.render_text(debug_panel_x + 32, debug_panel_y + 14 + y_msr * 2.3, {255, 255, 255, 255, "Reports: "}, {cr, cg, cb, 255, total_user_reports})
    functions.render_text(debug_panel_x + 32, debug_panel_y + 14 + y_msr * 3.4, {255, 255, 255, 255, "Target: "}, {cr, cg, cb, 255, debug_target})
    functions.render_text(debug_panel_x + 32, debug_panel_y + 14 + y_msr * 4.3, {255, 255, 255, 255, "Latency: "}, {latency_color[1], latency_color[2], latency_color[3], 255, latency}, {cr, cg, cb, 255, " ms"})
    functions.render_text(debug_panel_x + 32, debug_panel_y + 14 + y_msr * 5.25, {255, 255, 255, 255, "Accuracy: "}, {accuracy_color[1], accuracy_color[2], accuracy_color[3], 255, accuracy}, {cr, cg, cb, 255, " %"})
    functions.render_text(debug_panel_x + 32, debug_panel_y + 14 + y_msr * 6.27, {255, 255, 255, 255, "Hits: "}, {155, 189, 171, pulse, accuracy_hits}, {0, 0, 0, 255, " | "}, {255, 255, 255, 255, "Misses: "}, {161, 100, 100, pulse, accuracy_miss})

    -- Make the debug panel draggable
    local mouseposx, mouseposy = ui.mouse_position()
    if client.key_state(0x01) and mouseposy <= debug_panel_y + debug_panel_h and mouseposy >= debug_panel_y and mouseposx <= debug_panel_x + debug_panel_w and mouseposx >= debug_panel_x then
        -- Update the position in the table
        debug_panel_x = mouseposx - debug_panel_w/2
        debug_panel_y = mouseposy - debug_panel_h/2
        debug_panel_position.x, debug_panel_position.y = debug_panel_x, debug_panel_y
        -- Save the updated position to the database
        database.write('pluto_debug_panel_position', debug_panel_position)
    end

end

-- In-Game reportbot
local ReportingActive
ReportNoobs = function()
    
    if not functions.contains(ui.get(menu["Report"].report_switches), "In-Game Report") then return end
    if ReportingActive then return end
    print("Reporting Noobs")
    local Types = ui.get(menu["Report"].ingame_report_types)
    local ReportTypes = ''
    for i, v in pairs(Types) do
        ReportTypes = ( i == 1 and ReportTypeRef[v] or ReportTypes..','..ReportTypeRef[v] )
    end

    -- Add players to queue
    local ReportQueue = {}
    local playerslist = ui.get(menu["Report"].ingame_report_enemy_only) and get_players(true) or functions.get_players(false)
    for Player=1, #playerslist do
        local SteamXUID = ip.GameStateAPI.GetPlayerXuidStringFromEntIndex(Player)
        if ( SteamXUID:len() > 5 and not Player == entity.get_local_player() ) then
            ReportQueue[#ReportQueue + 1] = SteamXUID
        end
    end

    -- Actual Reporting
    for index, Reportee in ipairs(ReportQueue) do
        ReportingActive = true
        client.delay_call((index - 1) * 1, function()
            ip.GameStateAPI.SubmitPlayerReport(Reportee, ReportTypes)
            if ( index == #ReportQueue ) then
                client.delay_call(1, function()
                    ReportingActive = false
                end)
            end
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Successfully reported in-game. ("..index.."/"..#ReportQueue..")"})
        end)
    end

end

-- AI Chatbot function
chatbot = function(e)

    if not functions.contains(ui.get(menu["Misc"].misc_switches), "AI Chatbot") then return end

    local me = entity.get_local_player()
    local sent_by = valveServer and e.entity or client.userid_to_entindex(e.userid)
    local delay = ui.get(menu["Misc"].aiChatbotDelay)

    local comboBox = ui.get(menu["Misc"].aiChatbotCombo)
    if (functions.contains(comboBox, "Enemy") and entity.is_enemy(sent_by)) or (functions.contains(comboBox, "Self") and sent_by == me or (functions.contains(comboBox, "Team") and not entity.is_enemy(sent_by))) then
        if functions.contains(comboBox, "Team") and not functions.contains(comboBox, "Self") and sent_by == me then return end
        local text = e.text
        if not text or text == '' then return end
        local api_key = readfile('pluto-api.txt')
        if api_key == "" or api_key == None then libs.chat.print("{purple}[Pluto] {white}No API Key detected! Please add one.") multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'No API Key detected! Please add one.'}) return end
        local browser_text = text:gsub(" ", "%%20")
        libs.http.get(("https://pluto.kwayservices.top/chat?key="..api_key.."&msg=%s"):format(browser_text), function(success, response)
            if not success or response.status ~= 200 then multicolor_log({195, 177, 204, '[Pluto] '}, {255, 204, 153, 'Failed getting answer from chatbot api'}) notify:paint(3, "Failed getting answer from chatbot api") return end
            local data = json.parse(response.body)
            if not data then multicolor_log({195, 177, 204, '[Pluto] '}, {255, 204, 153, 'Failed getting answer from chatbot json'}) notify:paint(3, "Failed getting answer from chatbot json") return end
            local output = data.message
            if not output or output == '' or output == nil then multicolor_log({195, 177, 204, '[Pluto] '}, {255, 204, 153, 'Failed getting answer from chatbot message'}) notify:paint(3, "Failed getting answer from chatbot message") return end
            if chat.is_open() then multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Close the chat while you use the chatbot!"}) notify:paint(3, "Close the chat while you use the chatbot!") return end
            if functions.contains(comboBox, "Self") and delay < 1.5 then delay = delay + 1.5 end
            client.delay_call(delay, function()
                client.exec(('say "%s"'):format(output))
            end)
        end)
    end

end

-- Chatbot callback function
local chatbotFunc = { ["player_chat"] = false , ["player_say"] = false}
local chatbot_callback = function()

    if not globals.mapname() then multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "You're not in a game."}) notify:paint(3, "You're not in a game.") return end

    local MatchStatsAPI = panoramaopen.MatchStatsAPI
    valveServer = MatchStatsAPI.IsServerWhitelistedValveOfficial()

    local current_callback = valveServer and "player_chat" or "player_say"

    if not functions.contains(ui.get(menu["Misc"].misc_switches), "AI Chatbot") then
        if chatbotFunc[current_callback] then
            client.unset_event_callback(current_callback, chatbot)
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Old callback unset."})
            notify:paint(3, "Old callback unset.")
            return
        else
            return
        end
    else 
        if not chatbotFunc[current_callback] then
            client.set_event_callback(current_callback, chatbot)
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Set event: " .. current_callback})
            notify:paint(3, "Set event: " .. current_callback)
            chatbotFunc[current_callback] = true

        end

        if current_callback == "player_chat" and chatbotFunc["player_say"] then
            client.unset_event_callback("player_say", chatbot)

        elseif current_callback == "player_say" and chatbotFunc["player_chat"] then
            client.unset_event_callback("player_chat", chatbot)
        end

    end    

end

-- 3D Damage Indicator
local floating_shot_data = {}

local floating_paint = function()

    if not functions.contains(ui.get(menu["Visuals"].visual_switches), "3D Damage Indicator") then return end
    local r, g, b = ui.get(menu["Visuals"].floating_damage_color)
    for i=1, #floating_shot_data do
        local shot = floating_shot_data[i]
        if shot.draw then
            if shot.z >= shot.target then
                shot.alpha = shot.alpha - 1
            end
            if shot.alpha <= 0 then
                shot.draw = false
            end
            local sx, sy = renderer.world_to_screen(shot.x, shot.y, shot.z)
            if sx ~= nil then
                renderer.text(sx, sy, r, g, b, shot.alpha, "cb", 0, shot.damage)
            end
            shot.z = shot.z + 0.25
        end
    end

end

local floating_player_hurt = function(e)

    if not functions.contains(ui.get(menu["Visuals"].visual_switches), "3D Damage Indicator") then return end
    local attacker_entindex = client.userid_to_entindex(e.attacker)
    local victim_entindex   = client.userid_to_entindex(e.userid)
    if attacker_entindex ~= entity.get_local_player() then
        return
    end
    local x, y, z       = entity.get_prop(victim_entindex, "m_vecOrigin")
    local duck_amount   = entity.get_prop(victim_entindex, "m_flDuckAmount")
    z = z + (46 + (1 - duck_amount) * 18)
    floating_shot_data[#floating_shot_data + 1] = {
        x       = x,
        y       = y,
        z       = z,
        target  = z + 25,
        damage  = e.dmg_health,
        alpha   = 255,
        draw    = true
    }

end

local floating_round_start = function()

    if not functions.contains(ui.get(menu["Visuals"].visual_switches), "3D Damage Indicator") then return end
    floating_shot_data = {}

end

-- Change console color
libs.ffi.cdef[[
    typedef bool(__thiscall* console_is_visible)(void*);
]]
local engine_client = libs.ffi.cast(libs.ffi.typeof("void***"), client.create_interface("engine.dll", "VEngineClient014"))
local console_is_visible = libs.ffi.cast("console_is_visible", engine_client[0][11])
local materials = { "vgui_white", "vgui/hud/800corner1", "vgui/hud/800corner2", "vgui/hud/800corner3", "vgui/hud/800corner4" }

local change_console_color = function()
    if (console_is_visible(engine_client)) then
        local r, g, b, a = 255, 255, 255, 255
        if (functions.contains(ui.get(menu["Visuals"].visual_switches), "Change Console Color")) then r, g, b, a = ui.get(menu["Visuals"].console_color_picker) else return end
        for i=1, #materials do 
            local mat = materials[i]
            materialsystem.find_material(mat):alpha_modulate(a)
            materialsystem.find_material(mat):color_modulate(r, g, b)
        end
    else
        for i=1, #materials do 
            local mat = materials[i]
            materialsystem.find_material(mat):alpha_modulate(255)
            materialsystem.find_material(mat):color_modulate(255, 255, 255)
        end
    end
end

local score_icon = panorama.loadstring([[
        let entity_panels = {}
        let entity_data = {}
        let event_callbacks = {}

        let SLOT_LAYOUT = `
            <root>
                <Panel style="min-width: 3px; padding-top: 2px; padding-left: 0px;" scaling='stretch-to-fit-y-preserve-aspect'>
                    <Image id="smaller" textureheight="15" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;"  />
                    <Image id="small" textureheight="17" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;" />
                    <Image id="image" textureheight="21" style="opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; padding: 3px 5px; margin: -3px -5px; margin-top: -5px;" />
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

                let scoreboard_context_panel = $.GetContextPanel().FindChildTraverse("ScoreboardContainer").FindChildTraverse("Scoreboard") || $.GetContextPanel().FindChildTraverse("id-eom-scoreboard-container").FindChildTraverse("Scoreboard")

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

        return {
            create: _Create,
            destroy: _Destroy,
            clear: _Clear,
            update_player: _UpdatePlayer,
            destroy_panel: _DestroyEntityPanels
        }
    ]], "CSGOHud")()

score_icon.create()

-- Get players by steam64
local get_player_ent_by_steam64 = function(enemies_only, steamid)

    local result = {}

    local maxplayers = globals.maxplayers()
    local player_resource = entity.get_player_resource()
    
    for player = 1, maxplayers do

        local enemy = entity.is_enemy(player)

        if player ~= nil and entity.get_steam64(player) ~= 0 and entity.get_steam64(player) ~= nil then

            local steamid64 = entity.get_steam64(player)
            local check_steamid = tostring(functions.steam_64(steamid64))

            if steamid ~= check_steamid then goto skip end
            --local pass = steamid == check_steamid and "OK" or "FAIL"
            --print(pass..": " .. check_steamid.. " | " .. steamid)

            if (not enemy and enemies_only) then goto skip end

            table.insert(result, player)

            ::skip::

        end

    end

    --print("Players: " .. #result)
    return result

end

local addOnlinePlayer = function()

    local api_key = readfile('pluto-api.txt')

    if api_key == "" then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "You didn't add an API Key, save your API key with '/apikey <key>' in the console. (without the <>)."})
        libs.chat.print("{purple}[Pluto] {white}You {red}didn't{white} add an API Key, save your API key with '/apikey <key>' in the console. (without the <>).")
        return
    end

    if user == "" then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "You have no user?!?!?!."})
        libs.chat.print("{purple}[Pluto] {white}You {red}have no{white} user?!?!?!.")
        return
    end

    local me = entity.get_local_player()
    local steam64id = entity.get_steam64(me)
    local steamid = functions.steam_64(steam64id)

    if steamid == "" then
        return
    end

    local url = "https://auth.kwayservices.top/online/add?key="..api_key.."&username="..user.."&steamid="..steamid
    --print(url)
    libs.http.get(url, nil, function(success, response)
        if success then
            local data = json.parse(response.body)
            --print("Data: "..response.body)
            if data.success then
                if data.message == "User is already online with same data!" then --[[ print("User is already online!") ]] return end
                    --print("Successfully added player "..user.." ("..steamid..") to the database.")
                return
            else
                local error_message = data.message
                --print("Failed to add player "..user.." ("..steamid..") to the database. Error: "..error_message)
                return
            end
        else
            --print("Failed to add player "..user.." ("..steamid..") to the database due to connection error.")
            return
        end
    end)

end

local removeOnlinePlayer = function()
    
    local api_key = readfile('pluto-api.txt')

    if api_key == "" then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "You didn't add an API Key, save your API key with '/apikey <key>' in the console. (without the <>)."})
        libs.chat.print("{purple}[Pluto] {white}You {red}didn't{white} add an API Key, save your API key with '/apikey <key>' in the console. (without the <>).")
        return
    end

    if user == "" then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "You didn't specify a profile."})
        libs.chat.print("{purple}[Pluto] {white}You {red}didn't{white} specify a profile.")
        return
    end

    local me = entity.get_local_player()
    local steam64id = entity.get_steam64(me)
    local steamid = functions.steam_64(steam64id)

    if steamid == "" then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "You didn't specify a profile."})
        libs.chat.print("{purple}[Pluto] {white}You {red}didn't{white} specify a profile.")
        return
    end

    local url = "https://auth.kwayservices.top/online/remove?key="..api_key.."&username="..user.."&steamid="..steamid
    libs.http.get(url, nil, function(success, response)
        if success then
            local data = json.parse(response.body)
            --print("Data: "..response.body)
            if data.success then
                --print("Successfully removed player "..user.." ("..steamid..") from the database.")
                return
            else
                --print("Failed to remove player "..user.." ("..steamid..") from the database.")
                return
            end
        else
            --print("Failed to remove player "..user.." ("..steamid..") from the database.")
            return
        end
    end)

end

local getOnlinePlayers = function(callback)

    local api_key = readfile('pluto-api.txt')

    if api_key == "" then
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "You didn't add an API Key, save your API key with '/apikey <key>' in the console. (without the <>)."})
        libs.chat.print("{purple}[Pluto] {white}You {red}didn't{white} add an API Key, save your API key with '/apikey <key>' in the console. (without the <>).")
        return
    end
    
    local url = "https://auth.kwayservices.top/online/get?key="..api_key
    libs.http.get(url, nil, function(success, response)
        if success then
            
            local data = json.parse(response.body)
            --print("Data: "..response.body)
            if data.success then
                if type(data.users) == "boolean" then --[[ print("There's no users online.") ]] return false end
                --print("Successfully got online players from the database. ("..#data.users..")")
                callback(data.users)
            else
                --print("Failed to get online players from the database 1.")
                return false
            end
        else
            --print("Failed to get online players from the database 2.")
            return false
        end
    end)

end

local function updateIcons()

    score_icon.destroy()
    score_icon.create()

    getOnlinePlayers(function(apiPlayers)
        for i, v in pairs(apiPlayers) do
            local player = get_player_ent_by_steam64(false, v.steamid)
            if player ~= nil then
                --multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'Updating icon for'}, {255, 255, 255, ' ('}, {195, 177, 204, v.steamid}, {255, 255, 255, ')'})
                score_icon.update_player(player, "file://{images}/icons/xp/pluto-scoreboard.png")
            end
        end
    end)

end

-- Console commands
local snake_eyes = 0
local console_commands = function(c)

    local args = { }
    for v in string.gmatch(c, "%S+") do
        table.insert(args, v)
    end

    if args[1] == "apikey" then -- apikey command
        if args[2] ~= nil then
            local apikey = args[2]
            local newapi = apikey:gsub("%s+", "")
            writefile('pluto-api.txt', newapi)
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, 'API Key saved successfully: ' .. newapi})
        else
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Please provide an API Key."})
        end
        return true
    end

    if args[1] == "roll" then -- roll command
        
        local roll = client.random_int(1, 6)
		local name = obex_data.username
        local str = string.format('%s rolled a %i', name, roll)
	
		if roll == 1 then
			if snake_eyes == 0 then
				libs.chat.print( "{purple}[Pluto] {white} "..str )
                multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, str})
			else
				libs.chat.print( "{purple}[Pluto] {white} "..str..'... snake eyes!' )
                multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, str..'... snake eyes!'})
			end
			snake_eyes = snake_eyes + 1
		else
			libs.chat.print( "{purple}[Pluto] {white} "..str )
            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, str})
			snake_eyes = 0
		end

        return true

    end

    if args[1] == "resetreports" then -- reset report counter
        
        local user = obex_data.username
        total_user_reports = 0
        local data_to_write = { user = user, reports = 0}
        database.write("pluto_reports", data_to_write)

        return true

    end

    if args[1] == "uicons" then -- update scoreboard icons
        
        updateIcons()
        multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Updating scoreboard icons."})
        notify:paint(3, "Updating scoreboard icons.")
        return true

    end

    if args[1] == "getonline" then -- get online users
        getOnlinePlayers(function(result)
            if result ~= nil and result ~= false then
                multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Online users: " .. #result})
                notify:paint(3, "Online users: " .. #result)
            end
        end)

        return true
    end    

end

-- Separator 2
local s2 = ui.new_label("Config", "Lua", "\aFFCCE6FF----------------\aFFCCE6FF----------------\aC1BBDDFF----------------")

-- Links
local version_label = ui.new_label("Config", "Lua", "\aFFCCE6FFVer\aFFCCE6FFsi\aC1BBDDFFon: ".. lua_data.version)
local update_label = ui.new_label("Config", "Lua", "\aFFCCE6FFLas\aFFCCE6FFt upd\aC1BBDDFFate: ".. lua_data.update_date)

-- Function callbacks
client.set_event_callback("paint_ui", animation)
client.set_event_callback("paint_ui", HandleMenu)
client.set_event_callback("console_input", console_commands)
client.set_event_callback('aim_miss', aim_miss)
client.set_event_callback('player_disconnect', ragequit)
client.set_event_callback('round_mvp', mvp)
client.set_event_callback("player_connect_full", r_onjoin)
client.set_event_callback('player_death', killsay)
client.set_event_callback('player_death', tt)
client.set_event_callback('paint_ui', watermark)
client.set_event_callback("aim_fire", aim_fire)
client.set_event_callback('aim_miss', miss_log)
client.set_event_callback('aim_hit', hit_log)
client.set_event_callback("net_update_start", spammain)
client.set_event_callback("paint_ui", debug_panel)
client.set_event_callback("paint_ui", plist_update)

-- Pluto user detection callbacks
client.set_event_callback("round_start", function(e)
    if not functions.contains(ui.get(menu["Visuals"].visual_switches), "Pluto Detector") then return end
    addOnlinePlayer()
    updateIcons()
end)

client.set_event_callback("player_connect_full", function(e)
    if not functions.contains(ui.get(menu["Visuals"].visual_switches), "Pluto Detector") then return end
    addOnlinePlayer()
    updateIcons()
end)

ui.set_callback(menu["Visuals"].visual_switches, function()
    if functions.contains(ui.get(menu["Visuals"].visual_switches), "Pluto Detector") then return end
    removeOnlinePlayer()
    score_icon.destroy()
end)

client.set_event_callback("shutdown", function()
    removeOnlinePlayer()
    score_icon.destroy()
end)

-- Clantag callback
client.set_event_callback("net_update_end", function()

    if not functions.contains(ui.get(menu["Visuals"].visual_switches), "Clantag") then return end

    local duration = 41
    local plutoTag = {"✩", "✩ P", "✩ Pl", "✩ Plu", "✩ Plut", "✩ Pluto", "✩ Pluto.", "✩ Pluto.l", "✩ Pluto.lu", "✩ Pluto.lua", "ⓅⓁⓊⓉⓄ", "✩ Pluto.lua", "✩ luto.lua", "✩ uto.lua", "✩ to.lua", "✩ o.lua", "✩ .lua", "✩ lua", "✩ ua", "✩ a", "✩" }
    local clantag_prev

    local cur = math.floor(globals.tickcount() / duration) % #plutoTag
    local clantag = plutoTag[cur+1]
    if clantag ~= clantag_prev then
        clantag_prev = clantag
        client.set_clan_tag(clantag)
    end

end)

ui.set_callback(menu["Visuals"].visual_switches, function()
    if functions.contains(ui.get(menu["Visuals"].visual_switches), "Clantag") then return end
    client.set_clan_tag(tostring(functions.get_original_clantag()))
end)

-- Debug panel callbacks
client.set_event_callback("aim_hit", function()
    accuracy_hits = accuracy_hits + 1
end)

client.set_event_callback("aim_miss", function()
    accuracy_miss = accuracy_miss + 1
end)

client.set_event_callback("cs_match_end_restart", function()
    accuracy_hits = 0
    accuracy_miss = 0
    notify:paint(3, "Accuracy % reset due to new game.")
    multicolor_log({195, 177, 204, '[Pluto.lua] '}, {255, 255, 255, "Accuracy % reset due to new game."})
end)

-- Chatbot callbacks
ui.set_callback(menu["Misc"].misc_switches, function(ref)
    if functions.contains(ui.get(menu["Misc"].misc_switches), "AI Chatbot") then chatbot_callback() end
end)

client.set_event_callback("player_connect_full", function(e)
    local entindex = client.userid_to_entindex(e.userid)
    if entindex == entity.get_local_player() then
        return
    end
    if functions.contains(ui.get(menu["Misc"].misc_switches), "AI Chatbot") then
        chatbot_callback()
    end
end)

-- Xeno callbacks
ui.set_callback(menu["Report"].xenoList, xenoUpdate)
client.set_event_callback("player_connect_full", function(e)

    if not functions.contains(ui.get(menu["Report"].report_switches), "Xenophobia Mode") then return end

    local entindex = client.userid_to_entindex(e.userid)

    if entindex == entity.get_local_player() then
        return
    end

    local country_code = libs.countries.get_player_country(entindex)

    if country_code ~= nil then
        local country_name = libs.countries.get_country_name(country_code)
        for k, v in ipairs(countryList) do
            if v[2] then
                local code = v[1]:match("%S+$")
                if code == country_code then
                    if entindex ~= nil and entity.get_steam64(entindex) ~= 0 and entity.get_steam64(entindex) ~= nil and entindex ~= get_local_player() then
                        if not countries.server_has_plugin() then
                            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Server does not have the countries plugin installed."})
                            notify:paint(3,"Server does not have the countries plugin installed.")
                            return
                        else
                            multicolor_log({195, 177, 204, '[Pluto] '}, {255, 255, 255, "Server has the countries plugin installed, proceeding to report..."})
                            notify:paint(3,"Server has the countries plugin installed, proceeding to report...")
                        end
                        local steamid = entity.get_steam64(entindex)
                        local steam64 = functions.steam_64(steamid)
                        local name = entity.get_player_name(entindex)
                        Report(steam64, name)
                    end
                end
            end
        end
        client.delay_call(1, report_messages_queue)
    end
end)

-- Debug panel shutdown callback
client.set_event_callback('shutdown', function()
    -- Save the position to the database when shutting down
    database.write('pluto_debug_panel_position', debug_panel_position)
end)

-- 3D Damage Indicator callbacks
client.set_event_callback("paint", floating_paint)
client.set_event_callback("player_hurt", floating_player_hurt)
client.set_event_callback("round_start", floating_round_start)

-- Change console color callback
client.set_event_callback("paint", change_console_color)

-- Console cleaner callbacks
ui.set_callback(menu["Misc"].misc_switches, function(ref)
    if functions.contains(ui.get(menu["Misc"].misc_switches), "Console Cleaner") then
        cvar.developer:set_int(0)
        cvar.con_filter_enable:set_int(1)
        cvar.con_filter_text:set_string("IrWL5106TZZKNFPz4P4Gl3pSN?J370f5hi373ZjPg%VOVh6lN")
    else
        cvar.con_filter_enable:set_int(0)
        cvar.con_filter_text:set_string("")
    end
end)

client.set_event_callback("shutdown", function()
    cvar.con_filter_enable:set_int(0)
    cvar.con_filter_text:set_string("")
end)

-- @region Discord Miss Logs start
local discord_miss_logs_data = {
    lastmiss = 0,
    shot_time = 0
}
local prev_health = entity.get_prop(entity.get_local_player(), 'm_iHealth')

-- Reset the previous health on round start
client.set_event_callback("round_start", function()
    if not functions.contains(ui.get(menu["Misc"].misc_switches), "Discord Miss Logs") then return end
    prev_health = entity.get_prop(entity.get_local_player(), 'm_iHealth')
end)

-- Reset the previous health on player connecing to a server
client.set_event_callback("player_connect_full", function()
    if not functions.contains(ui.get(menu["Misc"].misc_switches), "Discord Miss Logs") then return end
    prev_health = entity.get_prop(entity.get_local_player(), 'm_iHealth')
end)

-- Create a hook by specifying the data table and the prop's name.
libs.ntv_hook.hook_prop('DT_CSPlayer', 'm_iHealth', function(val, idx)
    if idx ~= entity.get_local_player() then return end
    prev_health = val
end)

client.set_event_callback("bullet_impact", function(e)
    -- Some checks
    if not functions.contains(ui.get(menu["Misc"].misc_switches), "Discord Miss Logs") then return end
    local me = entity.get_local_player()
    if not entity.is_alive(me) or entity.get_prop(me, 'm_iHealth') ~= prev_health then return end
    
    local attacker = client.userid_to_entindex(e.userid)
    if entity.is_dormant(attacker) or not entity.is_enemy(attacker) then return end
    
    -- Calculate miss
    local bodyyaw = entity.get_prop(me, "m_flPoseParameter", 11) * 120 - 60
    local ent_origin = { entity.get_prop(attacker, "m_vecOrigin") }
    ent_origin[3] = ent_origin[3] + entity.get_prop(attacker, "m_vecViewOffset[2]")
    local local_head = { entity.hitbox_position(me, 0) }
    local delta = { local_head[1]-functions.GetClosestPoint(ent_origin, { e.x, e.y, e.z }, local_head)[1], local_head[2]-functions.GetClosestPoint(ent_origin, { e.x, e.y, e.z }, local_head)[2] }
    local delta_2d = math.sqrt(delta[1]^2 + delta[2]^2)
    
    local local_weapon_name = functions.getWeaponName(me)
    local attacker_weapon_name = functions.getWeaponName(attacker)
    if not local_weapon_name or not attacker_weapon_name then return end

    user = #user > 12 and user:sub(1, 12).."..." or user
    local attacker_name = #entity.get_player_name(attacker) > 12 and entity.get_player_name(attacker):sub(1, 12).."..." or entity.get_player_name(attacker)

    -- Send the miss log if things match
    if math.abs(delta_2d) <= 35 and globals.curtime() - discord_miss_logs_data.lastmiss > 0.015 then
        discord_miss_logs_data.lastmiss = globals.curtime()
        local miss_log_embed = setmetatable({ Properties = {} }, {__index = RichEmbed})
        miss_log_embed:setTitle("Pluto.lua - Miss Logs")
        miss_log_embed:setDescription("User **"..user.."** got missed.")
        miss_log_embed:addField("Attacker", attacker_name, true)
        miss_log_embed:addField("Desync", math.floor(bodyyaw).."º", true)
        miss_log_embed:addField("Health", entity.get_prop(me, 'm_iHealth'), true)
        miss_log_embed:addField(user.."'s Weapon", local_weapon_name, true)
        miss_log_embed:addField(attacker_name.."'s Weapon", attacker_weapon_name, true)
        miss_log_embed:setColor(0x000000)
        miss_log_embed:setThumbnail(webhookIcon)
        miss_log_embed:setFooter("Pluto.lua - gamesense.pub - "..user)
        dc_miss_logger_webhook:send(miss_log_embed)
    end
end)
-- @region Discord Miss Logs end

-- UI Handling callbacks
client.set_event_callback("paint_ui", function()

    -- Rest of the Pluto UI handling
    functions.set_visible(ui.get(mainMenu.combo) == "Main", version_label)
    functions.set_visible(ui.get(mainMenu.combo) == "Main", update_label)
    functions.set_visible((ui.get(mainMenu.combo) == "Report" or ui.get(mainMenu.combo) == "Queue") and globals.mapname(), mainMenu.plist_label)
    functions.set_visible((ui.get(mainMenu.combo) == "Report" or ui.get(mainMenu.combo) == "Queue") and globals.mapname(), mainMenu.plist)
    functions.set_visible((ui.get(mainMenu.combo) == "Report" or ui.get(mainMenu.combo) == "Queue") and not globals.mapname(), mainMenu.plist_hidden_label)
    functions.set_visible(functions.contains(ui.get(menu["Report"].report_switches), "Report Triggers") and ui.get(mainMenu.combo) == "Report", menu["Report"].report_triggers)
    functions.set_visible(functions.contains(ui.get(menu["Report"].report_switches), "Print Reports") and ui.get(mainMenu.combo) == "Report", menu["Report"].print_reports_to_chat_combo)
    functions.set_visible(functions.contains(ui.get(menu["Report"].report_switches), "Xenophobia Mode") and ui.get(mainMenu.combo) == "Report", menu["Report"].xenoSelectAll)
    functions.set_visible(functions.contains(ui.get(menu["Report"].report_switches), "Xenophobia Mode") and ui.get(mainMenu.combo) == "Report", menu["Report"].xenoDeselectAll)
    functions.set_visible(functions.contains(ui.get(menu["Report"].report_switches), "Xenophobia Mode") and ui.get(mainMenu.combo) == "Report", menu["Report"].xenoList)
    functions.set_visible(functions.contains(ui.get(menu["Report"].report_switches), "Xenophobia Mode") and ui.get(mainMenu.combo) == "Report", menu["Report"].xenoRefresh)
    functions.set_visible(functions.contains(ui.get(menu["Report"].report_switches), "Xenophobia Mode") and ui.get(mainMenu.combo) == "Report", menu["Report"].xenoGet)
    functions.set_visible(functions.contains(ui.get(menu["Report"].report_switches), "In-Game Report") and ui.get(mainMenu.combo) == "Report", menu["Report"].ingame_report_enemy_only)
    functions.set_visible(functions.contains(ui.get(menu["Report"].report_switches), "In-Game Report") and ui.get(mainMenu.combo) == "Report", menu["Report"].ingame_report_types)
    functions.set_visible(functions.contains(ui.get(menu["Report"].report_switches), "In-Game Report") and ui.get(mainMenu.combo) == "Report", menu["Report"].ingame_report_button)
    functions.set_visible(functions.contains(ui.get(menu["Misc"].misc_switches), "AI Chatbot") and ui.get(mainMenu.combo) == "Misc", menu["Misc"].aiChatbotCombo)
    functions.set_visible(functions.contains(ui.get(menu["Misc"].misc_switches), "AI Chatbot") and ui.get(mainMenu.combo) == "Misc", menu["Misc"].aiChatbotDelay)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") and ui.get(mainMenu.combo) == "Visuals", menu["Visuals"].hitlogCombo)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") and ui.get(mainMenu.combo) == "Visuals" and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Screen") and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Console"), menu["Visuals"].hitlog_separator_1)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") and ui.get(mainMenu.combo) == "Visuals" and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Screen") and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Console"), menu["Visuals"].hitlog_console_label)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") and ui.get(mainMenu.combo) == "Visuals" and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Screen") and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Console"), menu["Visuals"].hitlog_screen_label)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") and ui.get(mainMenu.combo) == "Visuals" and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Screen") and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Console"), menu["Visuals"].hitlog_separator_2)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") and ui.get(mainMenu.combo) == "Visuals" and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Console"), menu["Visuals"].hitlog_hit_color_label)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") and ui.get(mainMenu.combo) == "Visuals" and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Console"), menu["Visuals"].hitlog_hit_color)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") and ui.get(mainMenu.combo) == "Visuals" and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Console"), menu["Visuals"].hitlog_miss_color_label)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") and ui.get(mainMenu.combo) == "Visuals" and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Console"), menu["Visuals"].hitlog_miss_color)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") and ui.get(mainMenu.combo) == "Visuals" and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Console"), menu["Visuals"].hitlog_fail_color_label)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") and ui.get(mainMenu.combo) == "Visuals" and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Console"), menu["Visuals"].hitlog_fail_color)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Hit Logger") and ui.get(mainMenu.combo) == "Visuals" and functions.contains(ui.get(menu["Visuals"].hitlogCombo), "Screen"), menu["Visuals"].hitlogDelay)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Keybinds List") and ui.get(mainMenu.combo) == "Visuals", menu["Visuals"].keybinds_list_opacity)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Keybinds List") and ui.get(mainMenu.combo) == "Visuals", menu["Visuals"].keybinds_show_list)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Watermark") and ui.get(mainMenu.combo) == "Visuals", menu["Visuals"].watermark_padding)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Watermark") and ui.get(mainMenu.combo) == "Visuals", menu["Visuals"].watermark_alpha)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Debug Panel") and ui.get(mainMenu.combo) == "Visuals", menu["Visuals"].debug_alpha)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "3D Damage Indicator") and ui.get(mainMenu.combo) == "Visuals", menu["Visuals"].floating_damage_color)
    functions.set_visible(functions.contains(ui.get(menu["Visuals"].visual_switches), "Change Console Color") and ui.get(mainMenu.combo) == "Visuals", menu["Visuals"].console_color_picker)

end)

-- Shutdown callback
client.set_event_callback("shutdown", function()
    local data_to_write = { user = user, reports = total_user_reports}
    database.write("pluto_reports", data_to_write)
end)