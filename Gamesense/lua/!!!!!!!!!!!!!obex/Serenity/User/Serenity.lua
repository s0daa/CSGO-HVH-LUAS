-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- @region LUASETTINGS start
local lua_name = "serenity"
local lua_color = {r = 253, g = 157, b = 177}

local lua_banner = [[
                                                                                          
                                                                                          
                                                           *         *                    
                                                          ***       **                    
                                                           *        **                    
   ****              ***  ****                                    ******** **   ****      
  * **** *    ***     **** **** *    ***    ***  ****    ***     ********   **    ***  *  
 **  ****    * ***     **   ****    * ***    **** **** *  ***       **      **     ****   
****        *   ***    **          *   ***    **   ****    **       **      **      **    
  ***      **    ***   **         **    ***   **    **     **       **      **      **    
    ***    ********    **         ********    **    **     **       **      **      **    
      ***  *******     **         *******     **    **     **       **      **      **    
 ****  **  **          **         **          **    **     **       **      **      **    
* **** *   ****    *   ***        ****    *   **    **     **       **       *********    
   ****     *******     ***        *******    ***   ***    *** *     **        **** ***   
             *****                  *****      ***   ***    ***                      ***  
                                                                              *****   *** 
                                                                            ********  **  
                                                                           *      ****    
                                                                                          
                                                                                          
]]
-- @region LUASETTINGS end


-- @region DEPENDENCIES start
local function try_require(module, msg)
    local success, result = pcall(require, module)
    if success then return result else return error(msg) end
end

local images = try_require("gamesense/images", "Download images library: https://gamesense.pub/forums/viewtopic.php?id=22917")
local bit = try_require("bit")
local base64 = try_require("gamesense/base64", "Download base64 encode/decode library: https://gamesense.pub/forums/viewtopic.php?id=21619")
local antiaim_funcs = try_require("gamesense/antiaim_funcs", "Download anti-aim functions library: https://gamesense.pub/forums/viewtopic.php?id=29665")
local ffi = try_require("ffi", "Failed to require FFI, please make sure Allow unsafe scripts is enabled!")
local vector = try_require("vector", "Missing vector")
local http = try_require("gamesense/http", "Download HTTP library: https://gamesense.pub/forums/viewtopic.php?id=21619")
local clipboard = try_require("gamesense/clipboard", "Download Clipboard library: https://gamesense.pub/forums/viewtopic.php?id=28678")
local ent = try_require("gamesense/entity", "Download Entity Object library: https://gamesense.pub/forums/viewtopic.php?id=27529")
local csgo_weapons = try_require("gamesense/csgo_weapons", "Download CS:GO weapon data library: https://gamesense.pub/forums/viewtopic.php?id=18807")
-- @region DEPENDENCIES end

-- @region USERDATA start
local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'nightly', discord=''}
local userdata = {
    username = obex_data.username == nil or obex_data.username,
    build = obex_data.build ~= nil and obex_data.build:gsub("Private", "nightly"):gsub("Beta", "beta"):gsub("User", "live")
}
client.exec("clear")
client.color_log(lua_color.r, lua_color.g, lua_color.b, lua_banner)
client.color_log(255, 255, 255, " \n \n \n \n \n \n \n ")
client.color_log(255, 255, 255, "Welcome to\0")
client.color_log(lua_color.r, lua_color.g, lua_color.b, " serenity\0")
client.color_log(255, 255, 255, ", " .. userdata.username)

local lua = {}
lua.database = {
    configs = ":" .. lua_name .. "::configs:"
}
local presets = {}
-- @region USERDATA end

-- @region REFERENCES start
local refs = {
    legit = ui.reference("LEGIT", "Aimbot", "Enabled"),
    dmgOverride = {ui.reference("RAGE", "Aimbot", "Minimum damage override")},
    fakeDuck = ui.reference("RAGE", "Other", "Duck peek assist"),
    minDmg = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    hitChance = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),
    safePoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
    forceBaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
    dtLimit = ui.reference("RAGE", "Aimbot", "Double tap fake lag limit"),
    quickPeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
    dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
    enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = {ui.reference("AA", "Anti-aimbot angles", "pitch")},
    roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
    yawBase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    flLimit = ui.reference("AA", "Fake lag", "Limit"),
    fsBodyYaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeYaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    yawJitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    bodyYaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    freeStand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    os = {ui.reference("AA", "Other", "On shot anti-aim")},
    slow = {ui.reference("AA", "Other", "Slow motion")},
    fakeLag = {ui.reference("AA", "Fake lag", "Limit")},
    legMovement = ui.reference("AA", "Other", "Leg movement"),
    indicators = {ui.reference("VISUALS", "Other ESP", "Feature indicators")},
    ping = {ui.reference("MISC", "Miscellaneous", "Ping spike")},
}
-- @region REFERENCES end

-- @region VARIABLES start
local vars = {
    localPlayer = 0,
    hitgroup_names = { 'Generic', 'Head', 'Chest', 'Stomach', 'Left arm', 'Right arm', 'Left leg', 'Right leg', 'Neck', '?', 'Gear' },
    aaStates = {"Global", "Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching"},
    pStates = {"G", "S", "M", "SW", "C", "A", "AC"},
	sToInt = {["Global"] = 1, ["Standing"] = 2, ["Moving"] = 3, ["Slowwalking"] = 4, ["Crouching"] = 5, ["Air"] = 6, ["Air-Crouching"] = 7},
    intToS = {[1] = "Global", [2] = "Stand", [3] = "Move", [4] = "Slowwalk", [5] = "Crouch", [6] = "Air", [7] = "Air+C"},
    currentTab = 1,
    activeState = 1,
    pState = 1
}

local slurs = {
    "retard",
    "1",
    "HAHAHAHAHAA",
    "what are you doing LOL",
    "wp bro",
    "nice one",
    "iq???",
    "good job",
    "?",
    "u suck",
    "wyd",
    "nice",
    "thats gotta hurt",
    "nice cfg",
}

local js = panorama.open()
local MyPersonaAPI, LobbyAPI, PartyListAPI, SteamOverlayAPI = js.MyPersonaAPI, js.LobbyAPI, js.PartyListAPI, js.SteamOverlayAPI
-- @region VARIABLES end

-- @region FUNCS start
local func = {
    render_text = function(x, y, ...)
        local x_Offset = 0
        
        local args = {...}
    
        for i, line in pairs(args) do
            local r, g, b, a, text = unpack(line)
            local size = vector(renderer.measure_text("-d", text))
            renderer.text(x + x_Offset, y, r, g, b, a, "-d", 0, text)
            x_Offset = x_Offset + size.x
        end
    end,
    easeInOut = function(t)
        return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
    end,
    rec = function(x, y, w, h, radius, color)
        radius = math.min(x/2, y/2, radius)
        local r, g, b, a = unpack(color)
        renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
        renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
        renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
        renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
        renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
        renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
    end,
    rec_outline = function(x, y, w, h, radius, thickness, color)
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
    end,
    clamp = function(x, min, max)
        return x < min and min or x > max and max or x
    end,
    table_contains = function(tbl, value)
        for i = 1, #tbl do
            if tbl[i] == value then
                return true
            end
        end
        return false
    end,
    setAATab = function(ref)
        ui.set_visible(refs.enabled, ref)
        ui.set_visible(refs.pitch[1], ref)
        ui.set_visible(refs.pitch[2], ref)
        ui.set_visible(refs.roll, ref)
        ui.set_visible(refs.yawBase, ref)
        ui.set_visible(refs.yaw[1], ref)
        ui.set_visible(refs.yaw[2], ref)
        ui.set_visible(refs.yawJitter[1], ref)
        ui.set_visible(refs.yawJitter[2], ref)
        ui.set_visible(refs.bodyYaw[1], ref)
        ui.set_visible(refs.bodyYaw[2], ref)
        ui.set_visible(refs.freeStand[1], ref)
        ui.set_visible(refs.freeStand[2], ref)
        ui.set_visible(refs.fsBodyYaw, ref)
        ui.set_visible(refs.edgeYaw, ref)
    end,
    findDist = function (x1, y1, z1, x2, y2, z2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    end,
    resetAATab = function()
        ui.set(refs.enabled, false)
        ui.set(refs.pitch[1], "Off")
        ui.set(refs.pitch[2], 0)
        ui.set(refs.roll, 0)
        ui.set(refs.yawBase, "local view")
        ui.set(refs.yaw[1], "Off")
        ui.set(refs.yaw[2], 0)
        ui.set(refs.yawJitter[1], "Off")
        ui.set(refs.yawJitter[2], 0)
        ui.set(refs.bodyYaw[1], "Off")
        ui.set(refs.bodyYaw[2], 0)
        ui.set(refs.freeStand[1], false)
        ui.set(refs.freeStand[2], "On hotkey")
        ui.set(refs.fsBodyYaw, false)
        ui.set(refs.edgeYaw, false)
    end,
    type_from_string = function(input)
        if type(input) ~= "string" then return input end

        local value = input:lower()

        if value == "true" then
            return true
        elseif value == "false" then
            return false
        elseif tonumber(value) ~= nil then
            return tonumber(value)
        else
            return tostring(input)
        end
    end,
    lerp = function(start, vend, time)
        return start + (vend - start) * time
    end,
    vec_angles = function(angle_x, angle_y)
        local sy = math.sin(math.rad(angle_y))
        local cy = math.cos(math.rad(angle_y))
        local sp = math.sin(math.rad(angle_x))
        local cp = math.cos(math.rad(angle_x))
        return cp * cy, cp * sy, -sp
    end,
    hex = function(arg)
        local result = "\a"
        for key, value in next, arg do
            local output = ""
            while value > 0 do
                local index = math.fmod(value, 16) + 1
                value = math.floor(value / 16)
                output = string.sub("0123456789ABCDEF", index, index) .. output 
            end
            if #output == 0 then 
                output = "00" 
            elseif #output == 1 then 
                output = "0" .. output 
            end 
            result = result .. output
        end 
        return result .. "FF"
    end,
    split = function( inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
    end,
    RGBAtoHEX = function(redArg, greenArg, blueArg, alphaArg)
        return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
    end,
    create_color_array = function(r, g, b, string)
        local colors = {}
        for i = 0, #string do
            local color = {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + i * 5 / 30))}
            table.insert(colors, color)
        end
        return colors
    end,
    textArray = function(string)
        local result = {}
        for i=1, #string do
            result[i] = string.sub(string, i, i)
        end
        return result
    end,
    gradient_text = function(r1, g1, b1, a1, r2, g2, b2, a2, text)
        local output = ''
    
        local len = #text-1
    
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len
    
        for i=1, len+1 do
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
    
            r1 = r1 + rinc
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc
        end
    
        return output
    end
,    
    time_to_ticks = function(t)
        return math.floor(0.5 + (t / globals.tickinterval()))
    end,
    headVisible = function(enemy)
        local_player = entity.get_local_player()
        if local_player == nil then return end
        local ex, ey, ez = entity.hitbox_position(enemy, 1)
    
        local hx, hy, hz = entity.hitbox_position(local_player, 1)
        local head_fraction, head_entindex_hit = client.trace_line(enemy, ex, ey, ez, hx, hy, hz)
        if head_entindex_hit == local_player or head_fraction == 1 then return true else return false end
    end
}

local clantag = function(text, indices)
    local text_anim = "               " .. text .. "                      " 
    local tickinterval = globals.tickinterval()
    local tickcount = globals.tickcount() + func.time_to_ticks(client.latency())
    local i = tickcount / func.time_to_ticks(0.3)
    i = math.floor(i % #indices)
    i = indices[i+1]+1

    return string.sub(text_anim, i, i+15)
end

local trashtalk = function(e)

    local victim_userid, attacker_userid = e.userid, e.attacker
    if victim_userid == nil or attacker_userid == nil then
        return
    end

    local victim_entindex   = client.userid_to_entindex(victim_userid)
    local attacker_entindex = client.userid_to_entindex(attacker_userid)
    if attacker_entindex == entity.get_local_player() and entity.is_enemy(victim_entindex) then
        local phrase = slurs[math.random(1, #slurs)]
        local say = 'say ' .. phrase
        client.exec(say)
    end
end

local color_text = function( string, r, g, b, a)
    local accent = "\a" .. func.RGBAtoHEX(r, g, b, a)
    local white = "\a" .. func.RGBAtoHEX(255, 255, 255, a)

    local str = ""
    for i, s in ipairs(func.split(string, "$")) do
        str = str .. (i % 2 ==( string:sub(1, 1) == "$" and 0 or 1) and white or accent) .. s
    end

    return str
end

local animate_text = function(time, string, r, g, b, a)
    local t_out, t_out_iter = { }, 1

    local l = string:len( ) - 1

    local r_add = (255 - r)
    local g_add = (255 - g)
    local b_add = (255 - b)
    local a_add = (155 - a)

    for i = 1, #string do
        local iter = (i - 1)/(#string - 1) + time
        t_out[t_out_iter] = "\a" .. func.RGBAtoHEX( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )

        t_out[t_out_iter + 1] = string:sub( i, i )

        t_out_iter = t_out_iter + 2
    end

    return t_out
end

local glow_module = function(x, y, w, h, width, rounding, accent, accent_inner)
    local thickness = 1
    local Offset = 1
    local r, g, b, a = unpack(accent)
    if accent_inner then
        func.rec(x, y, w, h + 1, rounding, accent_inner)
    end
    for k = 0, width do
        if a * (k/width)^(1) > 5 then
            local accent = {r, g, b, a * (k/width)^(2)}
            func.rec_outline(x + (k - width - Offset)*thickness, y + (k - width - Offset) * thickness, w - (k - width - Offset)*thickness*2, h + 1 - (k - width - Offset)*thickness*2, rounding + thickness * (width - k + Offset), thickness, accent)
        end
    end
end

local colorful_text = {
    lerp = function(self, from, to, duration)
        if type(from) == 'table' and type(to) == 'table' then
            return { 
                self:lerp(from[1], to[1], duration), 
                self:lerp(from[2], to[2], duration), 
                self:lerp(from[3], to[3], duration) 
            };
        end
    
        return from + (to - from) * duration;
    end,
    console = function(self, ...)
        for i, v in ipairs({ ... }) do
            if type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
                for k = 1, #v[3] do
                    local l = self:lerp(v[1], v[2], k / #v[3]);
                    client.color_log(l[1], l[2], l[3], v[3]:sub(k, k) .. '\0');
                end
            elseif type(v[1]) == 'table' and type(v[2]) == 'string' then
                client.color_log(v[1][1], v[1][2], v[1][3], v[2] .. '\0');
            end
        end
    end,
    text = function(self, ...)
        local menu = false;
        local alpha = 255
        local f = '';
        
        for i, v in ipairs({ ... }) do
            if type(v) == 'boolean' then
                menu = v;
            elseif type(v) == 'number' then
                alpha = v;
            elseif type(v) == 'string' then
                f = f .. v;
            elseif type(v) == 'table' then
                if type(v[1]) == 'table' and type(v[2]) == 'string' then
                    f = f .. ('\a%02x%02x%02x%02x'):format(v[1][1], v[1][2], v[1][3], alpha) .. v[2];
                elseif type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
                    for k = 1, #v[3] do
                        local g = self:lerp(v[1], v[2], k / #v[3])
                        f = f .. ('\a%02x%02x%02x%02x'):format(g[1], g[2], g[3], alpha) .. v[3]:sub(k, k)
                    end
                end
            end
        end
    
        return ('%s\a%s%02x'):format(f, (menu) and 'cdcdcd' or 'ffffff', alpha);
    end,
    log = function(self, ...)
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
}
local download
local function downloadFile()
	http.get(string.format("https://flagsapi.com/%s/flat/64.png", MyPersonaAPI.GetMyCountryCode()), function(success, response)
		if not success or response.status ~= 200 then
			print("couldnt fetch the flag image")
            return
		end

		download = response.body
	end)

    http.get("https://cdn.discordapp.com/attachments/1094887320412504114/1095963815813861397/serenitygirl.png", function(success, response)
		if not success or response.status ~= 200 then
			print("couldnt fetch the logo image")
            return
		end

		writefile("logo.png", response.body)
	end)
end
downloadFile()
-- @region FUNCS end

-- @region UI_LAYOUT start
local tab, container = "AA", "Anti-aimbot angles"
local label = ui.new_label(tab, container, lua_name)
local tabPicker = ui.new_combobox(tab, container, "\nTab", "Anti-aim", "Builder", "Visuals", "Misc", "Config")

local menu = {
    aaTab = {
        freestandHotkey = ui.new_hotkey(tab, container, "Freestand"),
        legitAAHotkey = ui.new_hotkey(tab, container, "Legit AA"),
        edgeYawHotkey = ui.new_hotkey(tab, container, "Edge Yaw"),
        avoidBackstab = ui.new_slider(tab, container, "Avoid Backstab", 0, 300, 0, true, "u", 1, {[0] = "Off"}),
        manuals = ui.new_combobox(tab, container, "Manuals", "Off", "Default", "Static"),
        manualTab = {
            manualLeft = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "left"),
            manualRight = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "right"),
            manualForward = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "forward"),
        },
    },
    builderTab = {
        state = ui.new_combobox(tab, container, "Anti-aim state", vars.aaStates)
    },
    visualsTab = {
        indicators = ui.new_checkbox(tab, container, "Indicators"),
        indicatorsClr = ui.new_color_picker(tab, container, "Main Color", lua_color.r, lua_color.g, lua_color.b, 255),
        indicatorsType = ui.new_combobox(tab, container, "\n indicators type", "-", "Style 1", "Style 2"),
        indicatorsStyle = ui.new_multiselect(tab, container, "Elements", "Name", "State", "Doubletap", "Hideshots", "Freestand", "Safepoint", "Body aim", "Fakeduck"),
        arrows = ui.new_checkbox(tab, container, "Arrows"),
        arrowClr = ui.new_color_picker(tab, container, "Arrow Color", lua_color.r, lua_color.g, lua_color.b, 255),
        arrowIndicatorStyle = ui.new_combobox(tab, container, "\n arrows style", "-", "Teamskeet", "Modern"),
        watermark = ui.new_checkbox(tab, container, "Branded Watermark"),
        watermarkClr = ui.new_color_picker(tab, container, "Watermark Color", lua_color.r, lua_color.g, lua_color.b, 255),
        minDmgIndicator = ui.new_checkbox(tab, container, "Minimum Damage Indicator"),
        logs = ui.new_checkbox(tab, container, "Logs"),
        logsClr = ui.new_color_picker(tab, container, "Logs Color", lua_color.r, lua_color.g, lua_color.b, 255),
        logOffset = ui.new_slider(tab, container, "Offset", 0, 500, 100, true, "px", 1)
    },
    miscTab = {
        fixHideshots = ui.new_checkbox(tab, container, "Fix hideshots"),
        manualsOverFs = ui.new_checkbox(tab, container, "Manuals over freestanding"),
        dtDischarge = ui.new_checkbox(tab, container, "Auto DT Discharge"),
        clanTag = ui.new_checkbox(tab, container, "Clantag"),
        trashTalk = ui.new_checkbox(tab, container, "Trashtalk"),
        fastLadderEnabled = ui.new_checkbox(tab, container, "Fast ladder"),
        fastLadder = ui.new_multiselect(tab, container, "\n fast ladder", "Ascending", "Descending"),
        animationsEnabled = ui.new_checkbox(tab, container, "Anim breakers"),
        animations = ui.new_multiselect(tab, container, "\n animation breakers", "Static legs", "Leg fucker", "0 pitch on landing", "Allah legs"),
    },
    configTab = {
        list = ui.new_listbox(tab, container, "Configs", ""),
        name = ui.new_textbox(tab, container, "Config name", ""),
        load = ui.new_button(tab, container, "Load", function() end),
        save = ui.new_button(tab, container, "Save", function() end),
        delete = ui.new_button(tab, container, "Delete", function() end),
        import = ui.new_button(tab, container, "Import", function() end),
        export = ui.new_button(tab, container, "Export", function() end)
    }
}

local aaBuilder = {}
local aaContainer = {}
for i=1, #vars.aaStates do
    aaContainer[i] = func.hex({200,200,200}) .. "(" .. func.hex({222,55,55}) .. "" .. vars.pStates[i] .. "" .. func.hex({200,200,200}) .. ")" .. func.hex({155,155,155}) .. " "
    aaBuilder[i] = {
        enableState = ui.new_checkbox(tab, container, "Enable " .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({200,200,200}) .. " state"),
        forceDefensive = ui.new_checkbox(tab, container, "Force Defensive\n" .. aaContainer[i]),
        pitch = ui.new_combobox(tab, container, "Pitch\n" .. aaContainer[i], "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
        pitchSlider = ui.new_slider(tab, container, "\nPitch add" .. aaContainer[i], -89, 89, 0, true, "°", 1),
        yawBase = ui.new_combobox(tab, container, "Yaw base\n" .. aaContainer[i], "Local view", "At targets"),
        yaw = ui.new_combobox(tab, container, "Yaw\n" .. aaContainer[i], "Off", "180", "180 Z", "Spin", "Slow Yaw", "L&R"),
        yawStatic = ui.new_slider(tab, container, "\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawLeft = ui.new_slider(tab, container, "Left\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawRight = ui.new_slider(tab, container, "Right\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitter = ui.new_combobox(tab, container, "Yaw jitter\n" .. aaContainer[i], "Off", "Offset", "Center", "Skitter", "Random", "3-Way", "L&R"),
        wayFirst = ui.new_slider(tab, container, "First\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        waySecond = ui.new_slider(tab, container, "Second\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        wayThird = ui.new_slider(tab, container, "Third\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterStatic = ui.new_slider(tab, container, "\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterLeft = ui.new_slider(tab, container, "Left\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterRight = ui.new_slider(tab, container, "Right\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        bodyYaw = ui.new_combobox(tab, container, "Body yaw\n" .. aaContainer[i], "Off", "Opposite", "Jitter", "Static"),
        bodyYawStatic = ui.new_slider(tab, container, "\nbody yaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
    }
end

local function getConfig(name)
    local database = database.read(lua.database.configs) or {}

    for i, v in pairs(database) do
        if v.name == name then
            return {
                config = v.config,
                index = i
            }
        end
    end

    for i, v in pairs(presets) do
        if v.name == name then
            return {
                config = v.config,
                index = i
            }
        end
    end

    return false
end
local function saveConfig(name)
    local db = database.read(lua.database.configs) or {}
    local config = {}

    if name:match("[^%w]") ~= nil then
        return
    end

    for key, value in pairs(vars.pStates) do
        config[value] = {}
        for k, v in pairs(aaBuilder[key]) do
            config[value][k] = ui.get(v)
        end
    end

    local cfg = getConfig(name)

    if not cfg then
        table.insert(db, { name = name, config = config })
    else
        db[cfg.index].config = config
    end

    database.write(lua.database.configs, db)
end
local function deleteConfig(name)
    local db = database.read(lua.database.configs) or {}

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

    database.write(lua.database.configs, db)
end
local function getConfigList()
    local database = database.read(lua.database.configs) or {}
    local config = {}

    for i, v in pairs(presets) do
        table.insert(config, v.name)
    end

    for i, v in pairs(database) do
        table.insert(config, v.name)
    end

    return config
end
local function typeFromString(input)
    if type(input) ~= "string" then return input end

    local value = input:lower()

    if value == "true" then
        return true
    elseif value == "false" then
        return false
    elseif tonumber(value) ~= nil then
        return tonumber(value)
    else
        return tostring(input)
    end
end
local function loadSettings(config)
    for key, value in pairs(vars.pStates) do
        for k, v in pairs(aaBuilder[key]) do
            if (config[value][k] ~= nil) then
                ui.set(v, config[value][k])
            end
        end 
    end
end
local function importSettings()
    loadSettings(json.parse(clipboard.get()))
end
local function exportSettings(name)
    local config = getConfig(name)
    clipboard.set(json.stringify(config.config))
end
local function loadConfig(name)
    local config = getConfig(name)
    loadSettings(config.config)
end

local function initDatabase()
    if database.read(lua.database.configs) == nil then
        database.write(lua.database.configs, {})
    end

    local link = "https://pastebin.com/raw/4Ax2RnYY"

    http.get(link, function(success, response)
        if not success then
            print("Failed to get presets")
            return
        end
    
        data = json.parse(response.body)
    
        for i, preset in pairs(data.presets) do
            table.insert(presets, { name = "*"..preset.name, config = preset.config})
            ui.set(menu.configTab.name, "*"..preset.name)
        end
        ui.update(menu.configTab.list, getConfigList())
    end)
end
initDatabase()
-- @region UI_LAYOUT end

-- @region NOTIFICATION_ANIM start
local anim_time = 0.75
local max_notifs = 6
local data = {}
local icon = base64.decode("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")
local notifications = {

    new = function( string, r, g, b)
        table.insert(data, {
            time = globals.curtime(),
            string = string,
            color = {r, g, b, 255},
            fraction = 0
        })
        local time = 5
        for i = #data, 1, -1 do
            local notif = data[i]
            if #data - i + 1 > max_notifs and notif.time + time - globals.curtime() > 0 then
                notif.time = globals.curtime() - time
            end
        end
    end,

    render = function()
        local x, y = client.screen_size()
        local to_remove = {}
        local Offset = 0
        for i = 1, #data do
            local notif = data[i]

            local data = {rounding = 4, size = 3, glow = 2, time = 4}

            if notif.time + data.time - globals.curtime() > 0 then
                notif.fraction = func.clamp(notif.fraction + globals.frametime() / anim_time, 0, 1)
            else
                notif.fraction = func.clamp(notif.fraction - globals.frametime() / anim_time, 0, 1)
            end

            if notif.fraction <= 0 and notif.time + data.time - globals.curtime() <= 0 then
                table.insert(to_remove, i)
            end
            local fraction = func.easeInOut(notif.fraction)

            local r, g, b, a = unpack(notif.color)
            local string = color_text(notif.string, r, g, b, a * fraction)

            local strw, strh = renderer.measure_text("", string)
            local strw2 = renderer.measure_text("b", "      ")

            local paddingx, paddingy = 7, data.size
            local offsetY = ui.get(menu.visualsTab.logOffset)

            Offset = Offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 + 5) * fraction
            glow_module(x/2 - (strw + strw2)/2 - paddingx, y - offsetY - strh/2 - paddingy - Offset, strw + strw2 + paddingx*2, strh + paddingy*2, data.glow, data.rounding, {r, g, b, 45 * fraction}, {25,25,25,140 * fraction})
            renderer.text(x/2 + strw2/2, y - offsetY - Offset, 255, 255, 255, 255 * fraction, "c", 0, string)
            local icon = images.load_png(icon, 10, 10)
            icon:draw(x/2 - strw/2 - 12.5, y - offsetY - Offset - 10, 20, 20, r, g, b, 255 * fraction, "f")
        
        end

        for i = #to_remove, 1, -1 do
            table.remove(data, to_remove[i])
        end
    end,

    clear = function()
        data = {}
    end
}

local function onHit(e)
    local group = vars.hitgroup_names[e.hitgroup + 1] or '?'
	local r, g, b, a = ui.get(menu.visualsTab.logsClr)
	notifications.new(string.format("Hit %s's $%s$ for $%d$ damage ($%d$ health remaining)", entity.get_player_name(e.target), group:lower(), e.damage, entity.get_prop(e.target, 'm_iHealth')), r, g, b) 

end

local function onMiss(e)
    local group = vars.hitgroup_names[e.hitgroup + 1] or '?'
    local ping = math.min(999, client.real_latency() * 1000)
    local ping_col = (ping >= 100) and { 255, 0, 0 } or { 150, 200, 60 }
    local hc = math.floor(e.hit_chance + 0.5);
    local hc_col = (hc < ui.get(refs.hitChance)) and { 255, 0, 0 } or { 150, 200, 60 };
    e.reason = e.reason == "?" and "resolver" or e.reason
	notifications.new(string.format("Missed %s's $%s$ due to $%s$", entity.get_player_name(e.target), group:lower(), e.reason), 255, 120, 120)
end

client.set_event_callback("client_disconnect", function()  notifications.clear() end)
client.set_event_callback("level_init", function() notifications.clear() end)
client.set_event_callback('player_connect_full', function(e) if client.userid_to_entindex(e.userid) == entity.get_local_player() then notifications.clear() end end)
-- @region NOTIFICATION_ANIM end

-- @region AA_CALLBACKS start
local aa = {
	ignore = false,
	manualAA= 0,
	input = 0,
}
client.set_event_callback("player_connect_full", function() 
	aa.ignore = false
	aa.manualAA= 0
	aa.input = 0
end) 

local current_tick = func.time_to_ticks(globals.realtime())
client.set_event_callback("setup_command", function(cmd)
    vars.localPlayer = entity.get_local_player()
    if ui.get(menu.miscTab.clanTag) then
        if clanTag == nil then
            clanTag = true
        end
		local clan_tag = clantag("serenity", {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22})
		if clan_tag ~= clan_tag_prev then
			client.set_clan_tag(clan_tag)
		end
		clan_tag_prev = clan_tag
    elseif clanTag == true then
        client.set_clan_tag("")
        clanTag = false
    end

    if not vars.localPlayer  or not entity.is_alive(vars.localPlayer) then return end
	local flags = entity.get_prop(vars.localPlayer, "m_fFlags")
    local onground = bit.band(flags, 1) ~= 0 and cmd.in_jump == 0
	local valve = entity.get_prop(entity.get_game_rules(), "m_bIsValveDS")
	local origin = vector(entity.get_prop(vars.localPlayer, "m_vecOrigin"))
	local velocity = vector(entity.get_prop(vars.localPlayer, "m_vecVelocity"))
	local camera = vector(client.camera_angles())
	local eye = vector(client.eye_position())
	local speed = math.sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y) + (velocity.z * velocity.z))
    local weapon = entity.get_player_weapon()
	local pStill = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2) < 5
    local bodyYaw = entity.get_prop(vars.localPlayer, "m_flPoseParameter", 11) * 120 - 60

    local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
	local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
	local isFd = ui.get(refs.fakeDuck)
	local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    local isLegitAA = ui.get(menu.aaTab.legitAAHotkey)

    local manualsOverFs = ui.get(menu.miscTab.manualsOverFs) == true and true or false

    
    -- search for states
    vars.pState = 1
    if pStill then vars.pState = 2 end
    if not pStill then vars.pState = 3 end
    if isSlow then vars.pState = 4 end
    if entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 5 end
    if not onground then vars.pState = 6 end
    if not onground and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 7 end

    if ui.get(aaBuilder[vars.pState].enableState) == false and vars.pState ~= 1 then
        vars.pState = 1
    end

    local nextAttack = entity.get_prop(vars.localPlayer, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(vars.localPlayer), "m_flNextPrimaryAttack")
    local dtActive = false
    local isFl = ui.get(ui.reference("AA", "Fake lag", "Enabled"))
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
    end

    -- apply antiaim set
    local side = bodyYaw > 0 and 1 or -1

        -- manual aa
        if ui.get(menu.aaTab.manuals) ~= "Off" then
            ui.set(menu.aaTab.manualTab.manualLeft, "On hotkey")
            ui.set(menu.aaTab.manualTab.manualRight, "On hotkey")
            ui.set(menu.aaTab.manualTab.manualForward, "On hotkey")
            if aa.input + 0.22 < globals.curtime() then
                if aa.manualAA == 0 then
                    if ui.get(menu.aaTab.manualTab.manualLeft) then
                        aa.manualAA = 1
                        aa.input = globals.curtime()
                    elseif ui.get(menu.aaTab.manualTab.manualRight) then
                        aa.manualAA = 2
                        aa.input = globals.curtime()
                    elseif ui.get(menu.aaTab.manualTab.manualForward) then
                        aa.manualAA = 3
                        aa.input = globals.curtime()
                    end
                elseif aa.manualAA == 1 then
                    if ui.get(menu.aaTab.manualTab.manualRight) then
                        aa.manualAA = 2
                        aa.input = globals.curtime()
                    elseif ui.get(menu.aaTab.manualTab.manualForward) then
                        aa.manualAA = 3
                        aa.input = globals.curtime()
                    elseif ui.get(menu.aaTab.manualTab.manualLeft) then
                        aa.manualAA = 0
                        aa.input = globals.curtime()
                    end
                elseif aa.manualAA == 2 then
                    if ui.get(menu.aaTab.manualTab.manualLeft) then
                        aa.manualAA = 1
                        aa.input = globals.curtime()
                    elseif ui.get(menu.aaTab.manualTab.manualForward) then
                        aa.manualAA = 3
                        aa.input = globals.curtime()
                    elseif ui.get(menu.aaTab.manualTab.manualRight) then
                        aa.manualAA = 0
                        aa.input = globals.curtime()
                    end
                elseif aa.manualAA == 3 then
                    if ui.get(menu.aaTab.manualTab.manualForward) then
                        aa.manualAA = 0
                        aa.input = globals.curtime()
                    elseif ui.get(menu.aaTab.manualTab.manualLeft) then
                        aa.manualAA = 1
                        aa.input = globals.curtime()
                    elseif ui.get(menu.aaTab.manualTab.manualRight) then
                        aa.manualAA = 2
                        aa.input = globals.curtime()
                    end
                end
            end
            if aa.manualAA == 1 or aa.manualAA == 2 or aa.manualAA == 3 then
                aa.ignore = true

                if ui.get(menu.aaTab.manuals) == "Static" then
                    ui.set(refs.yawJitter[1], "Off")
                    ui.set(refs.yawJitter[2], 0)
                    ui.set(refs.bodyYaw[1], "Static")
                    ui.set(refs.bodyYaw[2], -180)

                    if aa.manualAA == 1 then
                        ui.set(refs.yawBase, "local view")
                        ui.set(refs.yaw[1], "180")
                        ui.set(refs.yaw[2], -90)
                    elseif aa.manualAA == 2 then
                        ui.set(refs.yawBase, "local view")
                        ui.set(refs.yaw[1], "180")
                        ui.set(refs.yaw[2], 90)
                    elseif aa.manualAA == 3 then
                        ui.set(refs.yawBase, "local view")
                        ui.set(refs.yaw[1], "180")
                        ui.set(refs.yaw[2], 180)
                    end
                elseif ui.get(menu.aaTab.manuals) == "Default" and ui.get(aaBuilder[vars.pState].enableState) then
                    if ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                        ui.set(refs.yawJitter[1], "Center")
                        ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft)*math.random(-1, 1)  or ui.get(aaBuilder[vars.pState].yawJitterRight)*math.random(-1, 1) ))
                    elseif ui.get(aaBuilder[vars.pState].yawJitter) == "L&R" then
                        ui.set(refs.yawJitter[1], "Center")
                        ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) or ui.get(aaBuilder[vars.pState].yawJitterRight)))
                    else
                        ui.set(refs.yawJitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
                        ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic))
                    end

                    ui.set(refs.bodyYaw[1], "Static")
                    ui.set(refs.bodyYaw[2], -180)

                    if aa.manualAA == 1 then
                        ui.set(refs.yawBase, "local view")
                        ui.set(refs.yaw[1], "180")
                        ui.set(refs.yaw[2], -90)
                    elseif aa.manualAA == 2 then
                        ui.set(refs.yawBase, "local view")
                        ui.set(refs.yaw[1], "180")
                        ui.set(refs.yaw[2], 90)
                    elseif aa.manualAA == 3 then
                        ui.set(refs.yawBase, "local view")
                        ui.set(refs.yaw[1], "180")
                        ui.set(refs.yaw[2], 180)
                    end
                end
            else
                aa.ignore = false
            end
        else
            aa.ignore = false
            aa.manualAA= 0
            aa.input = 0
        end

    if not ui.get(menu.aaTab.legitAAHotkey) and aa.ignore == false then
        if ui.get(aaBuilder[vars.pState].enableState) then

            cmd.force_defensive = ui.get(aaBuilder[vars.pState].forceDefensive)

            if ui.get(aaBuilder[vars.pState].pitch) ~= "Custom" then
                ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
            else
                ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
            end

            ui.set(refs.yawBase, ui.get(aaBuilder[vars.pState].yawBase))

            local switch = false
            if ui.get(aaBuilder[vars.pState].yaw) == "Slow Yaw" then
                ui.set(refs.yaw[1], "180")
                local switch_ticks = func.time_to_ticks(globals.realtime()) - current_tick
            
                if switch_ticks * 2 >= 3 then
                    switch = true
                else
                    switch = false
                end
                if switch_ticks >= 3 then
                    current_tick = func.time_to_ticks(globals.realtime())
                end
                ui.set(refs.yaw[2], switch and ui.get(aaBuilder[vars.pState].yawRight) or ui.get(aaBuilder[vars.pState].yawLeft))
            elseif ui.get(aaBuilder[vars.pState].yaw) == "L&R" then
                ui.set(refs.yaw[1], "180")
                ui.set(refs.yaw[2],(side == 1 and ui.get(aaBuilder[vars.pState].yawLeft) or ui.get(aaBuilder[vars.pState].yawRight)))
            else
                ui.set(refs.yaw[1], ui.get(aaBuilder[vars.pState].yaw))
                ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawStatic))
            end


            if ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                ui.set(refs.yawJitter[1], "Center")
                local ways = {
                    ui.get(aaBuilder[vars.pState].wayFirst),
                    ui.get(aaBuilder[vars.pState].waySecond),
                    ui.get(aaBuilder[vars.pState].wayThird)
                }
                    ui.set(refs.yawJitter[2], ways[(globals.tickcount()%3) + 1])
            elseif ui.get(aaBuilder[vars.pState].yawJitter) == "L&R" then 
                ui.set(refs.yawJitter[1], "Center")
                ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) or ui.get(aaBuilder[vars.pState].yawJitterRight)))
            else
                ui.set(refs.yawJitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
                ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic))
            end

            ui.set(refs.bodyYaw[1], ui.get(aaBuilder[vars.pState].bodyYaw))
            ui.set(refs.bodyYaw[2], (ui.get(aaBuilder[vars.pState].bodyYawStatic)))
            ui.set(refs.fsBodyYaw, false)
        elseif not ui.get(aaBuilder[vars.pState].enableState) then
            ui.set(refs.pitch[1], "Off")
            ui.set(refs.yawBase, "Local view")
            ui.set(refs.yaw[1], "Off")
            ui.set(refs.yaw[2], 0)
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
            ui.set(refs.bodyYaw[1], "Off")
            ui.set(refs.bodyYaw[2], 0)
            ui.set(refs.fsBodyYaw, false)
            ui.set(refs.edgeYaw, false)
            ui.set(refs.roll, 0)
        end
    elseif ui.get(menu.aaTab.legitAAHotkey) and aa.ignore == false then
        if entity.get_classname(entity.get_player_weapon(vars.localPlayer)) == "CC4" then 
            return 
        end
    
        local should_disable = false
        local planted_bomb = entity.get_all("CPlantedC4")[1]
    
        if planted_bomb ~= nil then
            bomb_distance = vector(entity.get_origin(vars.localPlayer)):dist(vector(entity.get_origin(planted_bomb)))
            
            if bomb_distance <= 64 and entity.get_prop(vars.localPlayer, "m_iTeamNum") == 3 then
                should_disable = true
            end
        end
    
        local pitch, yaw = client.camera_angles()
        local direct_vec = vector(func.vec_angles(pitch, yaw))
    
        local eye_pos = vector(client.eye_position())
        local fraction, ent = client.trace_line(vars.localPlayer, eye_pos.x, eye_pos.y, eye_pos.z, eye_pos.x + (direct_vec.x * 8192), eye_pos.y + (direct_vec.y * 8192), eye_pos.z + (direct_vec.z * 8192))
    
        if ent ~= nil and ent ~= -1 then
            if entity.get_classname(ent) == "CPropDoorRotating" then
                should_disable = true
            elseif entity.get_classname(ent) == "CHostage" then
                should_disable = true
            end
        end
        
        if should_disable ~= true and cmd.in_use == 1 then
            ui.set(refs.pitch[1], "Off")
            ui.set(refs.yawBase, "Local view")
            ui.set(refs.yaw[1], "Off")
            ui.set(refs.yaw[2], 0)
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
            ui.set(refs.bodyYaw[1], "Opposite")
            ui.set(refs.fsBodyYaw, true)
            ui.set(refs.edgeYaw, false)
            ui.set(refs.roll, 0)
    
            cmd.in_use = 0
            cmd.roll = 0
        end
    end

    -- fix hideshots
	if ui.get(menu.miscTab.fixHideshots) then
		if isOs and not isDt and not isFd then
            if not hsSaved then
                hsValue = ui.get(refs.fakeLag[1])
                hsSaved = true
            end
			ui.set(refs.fakeLag[1], 1)
		elseif hsSaved then
			ui.set(refs.fakeLag[1], hsValue)
            hsSaved = false
		end
	end

    -- Avoid backstab
    if ui.get(menu.aaTab.avoidBackstab) ~= 0 then
        local players = entity.get_players(true)
        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = func.findDist(origin.x, origin.y, origin.z, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(menu.aaTab.avoidBackstab) then
                ui.set(refs.yaw[2], 180)
                ui.set(refs.pitch[1], "Off")
            end
        end
    end

    -- freestand
    if ( ui.get(menu.aaTab.freestandHotkey)) then
        if manualsOverFs == true and aa.ignore == true then
            ui.set(refs.freeStand[2], "On hotkey")
            return
        else
            ui.set(refs.freeStand[2], "Always on")
            ui.set(refs.freeStand[1], true)
        end
    else
        ui.set(refs.freeStand[1], false)
        ui.set(refs.freeStand[2], "On hotkey")
    end

    -- dt discharge
    if ui.get(menu.miscTab.dtDischarge) then
        if dtEnabled == nil then
            dtEnabled = true
        end
        local enemies = entity.get_players(true)
        local vis = false
        local health = entity.get_prop(vars.localPlayer, "m_iHealth")
        for i=1, #enemies do
            local entindex = enemies[i]
            local body_x,body_y,body_z = entity.hitbox_position(entindex, 1)
            if client.visible(body_x, body_y, body_z + 20) then
                vis = true
            end
        end	

        if vis then
            ui.set(refs.dt[1],false)
            client.delay_call(0.01, function() 
                ui.set(refs.dt[1],true)
            end)
        end
    else
        if dtEnabled == true then
            ui.set(refs.dt[1], dtEnabled)
            dtEnabled = false
        end
    end
    
    -- fast ladder
    if ui.get(menu.miscTab.fastLadderEnabled) then
        local pitch, yaw = client.camera_angles()
        if entity.get_prop(vars.localPlayer, "m_MoveType") == 9 then
            cmd.yaw = math.floor(cmd.yaw+0.5)
            cmd.roll = 0
    
            if func.table_contains(ui.get(menu.miscTab.fastLadder), "Ascending") then
                if cmd.forwardmove > 0 then
                    if pitch < 45 then
                        cmd.pitch = 89
                        cmd.in_moveright = 1
                        cmd.in_moveleft = 0
                        cmd.in_forward = 0
                        cmd.in_back = 1
                        if cmd.sidemove == 0 then
                            cmd.yaw = cmd.yaw + 90
                        end
                        if cmd.sidemove < 0 then
                            cmd.yaw = cmd.yaw + 150
                        end
                        if cmd.sidemove > 0 then
                            cmd.yaw = cmd.yaw + 30
                        end
                    end 
                end
            end
            if func.table_contains(ui.get(menu.miscTab.fastLadder), "Descending") then
                if cmd.forwardmove < 0 then
                    cmd.pitch = 89
                    cmd.in_moveleft = 1
                    cmd.in_moveright = 0
                    cmd.in_forward = 1
                    cmd.in_back = 0
                    if cmd.sidemove == 0 then
                        cmd.yaw = cmd.yaw + 90
                    end
                    if cmd.sidemove > 0 then
                        cmd.yaw = cmd.yaw + 150
                    end
                    if cmd.sidemove < 0 then
                        cmd.yaw = cmd.yaw + 30
                    end
                end
            end
        end
    end

    -- edgeyaw
    ui.set(refs.edgeYaw, ui.get(menu.aaTab.edgeYawHotkey))
    
end)

ui.set_callback(menu.miscTab.trashTalk, function() 
    local callback = ui.get(menu.miscTab.trashTalk) and client.set_event_callback or client.unset_event_callback
    callback('player_death', trashtalk)
end)

ui.set_callback(menu.visualsTab.logs, function() 
    local callback = ui.get(menu.visualsTab.logs) and client.set_event_callback or client.unset_event_callback
    callback("aim_miss", onMiss)
    callback("aim_hit", onHit)
end)

local legsSaved = false
local legsTypes = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
local ground_ticks = 0
client.set_event_callback("pre_render", function()
    if not entity.get_local_player() then return end
    if ui.get(menu.miscTab.animationsEnabled) == false then return end
    local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    ground_ticks = bit.band(flags, 1) == 0 and 0 or (ground_ticks < 5 and ground_ticks + 1 or ground_ticks)

    if func.table_contains(ui.get(menu.miscTab.animations), "Static legs") then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
    end

    if func.table_contains(ui.get(menu.miscTab.animations), "Leg fucker") then
        if not legsSaved then
            legsSaved = ui.get(refs.legMovement)
        end
        ui.set_visible(refs.legMovement, false)
        if func.table_contains(ui.get(menu.miscTab.animations), "Leg fucker") then
            ui.set(refs.legMovement, legsTypes[math.random(1, 3)])
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
        end

    elseif (legsSaved == "Off" or legsSaved == "Always slide" or legsSaved == "Never slide") then
        ui.set_visible(refs.legMovement, true)
        ui.set(refs.legMovement, legsSaved)
        legsSaved = false
    end

    if func.table_contains(ui.get(menu.miscTab.animations), "0 pitch on landing") then
        ground_ticks = bit.band(flags, 1) == 1 and ground_ticks + 1 or 0

        if ground_ticks > 20 and ground_ticks < 150 then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
        end
    end

    if func.table_contains(ui.get(menu.miscTab.animations), "Allah legs") then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
    end
end)
-- @region AA_CALLBACKS end

-- @region INDICATORS start
local alpha = 0
local scopedFraction = 0

local mainIndClr = {r = 0, g = 0, b = 0, a = 0}
local dtClr = {r = 0, g = 0, b = 0, a = 0}
local chargeClr = {r = 0, g = 0, b = 0, a = 0}
local chargeInd = {w = 0, x = 0, y = 25}
local psClr = {r = 0, g = 0, b = 0, a = 0}
local dtInd = {w = 0, x = 0, y = 25}
local qpInd = {w = 0, x = 0, y = 25, a = 0}
local fdInd = {w = 0, x = 0, y = 25, a = 0}
local spInd = {w = 0, x = 0, y = 25, a = 0}
local baInd = {w = 0, x = 0, y = 25, a = 0}
local fsInd = {w = 0, x = 0, y = 25, a = 0}
local osInd = {w = 0, x = 0, y = 25, a = 0}
local psInd = {w = 0, x = 0, y = 25}
local wAlpha = 0
client.set_event_callback("paint", function()
    local local_player = entity.get_local_player()
    if local_player == nil or entity.is_alive(local_player) == false then return end
    local sizeX, sizeY = client.screen_size()
    local weapon = entity.get_player_weapon(local_player)
    local bodyYaw = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
    local side = bodyYaw > 0 and 1 or -1
    local state = "MOVING"
    local mainClr = {}
    mainClr.r, mainClr.g, mainClr.b, mainClr.a = ui.get(menu.visualsTab.indicatorsClr)
    local arrowClr = {}
    arrowClr.r, arrowClr.g, arrowClr.b, arrowClr.a = ui.get(menu.visualsTab.arrowClr)
    local fake = math.floor(antiaim_funcs.get_desync(1))

    local indicators = 0

    if ui.get(menu.visualsTab.watermark) then
        indicators = indicators + 1
        wAlpha = func.lerp(wAlpha, 255, globals.frametime() * 3)
    else
        wAlpha = func.lerp(wAlpha, 0, globals.frametime() * 11)
    end

    local watermarkClr = {}
    watermarkClr.r, watermarkClr.g, watermarkClr.b = ui.get(menu.visualsTab.watermarkClr)

    if readfile("logo.png") ~= nil then
        local mainY = 10
        local marginX, marginY = renderer.measure_text("-d", "SERENITY")
        local png = images.load_png(readfile("logo.png"))
        png:draw(15, sizeY/2 - 9, 32, 42, 255, 255, 255, wAlpha, true, "f")
        renderer.text(47, sizeY/2 - 2 + mainY, watermarkClr.r, watermarkClr.g, watermarkClr.b, wAlpha, "-d", nil, "SERENITY\a" .. func.RGBAtoHEX(255, 255, 255, wAlpha) .. " [" .. userdata.build:upper() .. "]")
        renderer.text(47, sizeY/2 - 4 + marginY + mainY, 255, 255, 255, wAlpha, "-d", nil, "USER - \a" .. func.RGBAtoHEX(watermarkClr.r, watermarkClr.g, watermarkClr.b, wAlpha) .. userdata.username:upper())
    end
    
    -- draw arrows
    if ui.get(menu.visualsTab.arrows) then
        if ui.get(menu.visualsTab.arrowIndicatorStyle) == "Modern" then
            alpha = (aa.manualAA == 2 or aa.manualAA == 1) and func.lerp(alpha, 255, globals.frametime() * 3) or func.lerp(alpha, 0, globals.frametime() * 11)
            renderer.text(sizeX / 2 + 45, sizeY / 2 - 2.5, aa.manualAA == 2 and arrowClr.r or 200, aa.manualAA == 2 and arrowClr.g or 200, aa.manualAA == 2 and arrowClr.b or 200, alpha, "c+", 0, '>')
            renderer.text(sizeX / 2 - 45, sizeY / 2 - 2.5, aa.manualAA == 1 and arrowClr.r or 200, aa.manualAA == 1 and arrowClr.g or 200, aa.manualAA == 1 and arrowClr.b or 200, alpha, "c+", 0, '<')
        end
    
        if ui.get(menu.visualsTab.arrowIndicatorStyle) == "Teamskeet" then
            renderer.triangle(sizeX / 2 + 55, sizeY / 2 + 2, sizeX / 2 + 42, sizeY / 2 - 7, sizeX / 2 + 42, sizeY / 2 + 11, 
            aa.manualAA == 2 and arrowClr.r or 25, 
            aa.manualAA == 2 and arrowClr.g or 25, 
            aa.manualAA == 2 and arrowClr.b or 25, 
            aa.manualAA == 2 and arrowClr.a or 160)
    
            renderer.triangle(sizeX / 2 - 55, sizeY / 2 + 2, sizeX / 2 - 42, sizeY / 2 - 7, sizeX / 2 - 42, sizeY / 2 + 11, 
            aa.manualAA == 1 and arrowClr.r or 25, 
            aa.manualAA == 1 and arrowClr.g or 25, 
            aa.manualAA == 1 and arrowClr.b or 25, 
            aa.manualAA == 1 and arrowClr.a or 160)
        
            renderer.rectangle(sizeX / 2 + 38, sizeY / 2 - 7, 2, 18, 
            bodyYaw < -10 and arrowClr.r or 25,
            bodyYaw < -10 and arrowClr.g or 25,
            bodyYaw < -10 and arrowClr.b or 25,
            bodyYaw < -10 and arrowClr.a or 160)
            renderer.rectangle(sizeX / 2 - 40, sizeY / 2 - 7, 2, 18,			
            bodyYaw > 10 and arrowClr.r or 25,
            bodyYaw > 10 and arrowClr.g or 25,
            bodyYaw > 10 and arrowClr.b or 25,
            bodyYaw > 10 and arrowClr.a or 160)
        end
    end

    -- move on scope
    local scopeLevel = entity.get_prop(weapon, 'm_zoomLevel')
    local scoped = entity.get_prop(local_player, 'm_bIsScoped') == 1
    local resumeZoom = entity.get_prop(local_player, 'm_bResumeZoom') == 1
    local isValid = weapon ~= nil and scopeLevel ~= nil
    local act = isValid and scopeLevel > 0 and scoped and not resumeZoom
    local time = globals.frametime() * 30

    if act then
        if scopedFraction < 1 then
            scopedFraction = func.lerp(scopedFraction, 1 + 0.1, time)
        else
            scopedFraction = 1
        end
    else
        scopedFraction = func.lerp(scopedFraction, 0, time)
    end

    -- draw indicators
    if ui.get(menu.visualsTab.indicators) and ui.get(menu.visualsTab.indicatorsType) ~= "-" then
        local dpi = ui.get(ui.reference("MISC", "Settings", "DPI scale")):gsub('%%', '') - 100
        local globalFlag = ui.get(menu.visualsTab.indicatorsType) == "Style 1" and "cd-" or "cd"
        local globalMoveY = 0
        local indX, indY = renderer.measure_text(globalFlag, "DT")
        local yDefault = 16
        local indCount = 0
        indY = globalFlag == "cd-" and indY - 3 or indY - 2
    
        local isCharged = antiaim_funcs.get_double_tap()
        local isFs = ui.get(menu.aaTab.freestandHotkey)
        local isBa = ui.get(refs.forceBaim)
        local isSp = ui.get(refs.safePoint)
        local isQp = ui.get(refs.quickPeek[2])
        local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
        local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
        local isFd = ui.get(refs.fakeDuck)
        local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    
        local state = vars.intToS[vars.pState]:upper()
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Name") then
            indicators = indicators + 1
            local namex, namey = renderer.measure_text(globalFlag, globalFlag == "cd-" and lua_name:upper() or lua_name:lower())
            local logo = animate_text(globals.curtime(), globalFlag == "cd-" and lua_name:upper() or lua_name:lower(), mainClr.r, mainClr.g, mainClr.b, 255)
    
            renderer.text(sizeX/2 + ((namex + 2)/2) * scopedFraction, sizeY/2 + 20 - dpi/10, 255, 255, 255, 255, globalFlag, nil, unpack(logo))
        end 
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "State") then
            indicators = indicators + 1
            indCount = indCount + 1
            local namex, namey = renderer.measure_text(globalFlag, globalFlag == "cd-" and lua_name:upper() or lua_name:lower())
            local stateX, stateY = renderer.measure_text(globalFlag, globalFlag == "cd-" and func.hex({mainClr.r, mainClr.g, mainClr.b}) .. '%' .. func.hex({255, 255, 255}) ..  state:upper() .. func.hex({mainClr.r, mainClr.g, mainClr.b}) .. '%' or userdata.build:lower())
            local string = globalFlag == "cd-" and func.hex({mainClr.r, mainClr.g, mainClr.b}) .. '%' .. func.hex({255, 255, 255}) ..  state:upper() .. func.hex({mainClr.r, mainClr.g, mainClr.b}) .. '%' or userdata.build:lower()
            renderer.text(sizeX/2 + (stateX + 2)/2 * scopedFraction, sizeY/2 + 20 + namey/1.2, 255, 255, 255, globalFlag == "cd-" and 255 or math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255, globalFlag, 0, string)
        end
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Doubletap") then
            indicators = indicators + 1
            if isDt then 
                dtClr.a = func.lerp(dtClr.a, 255, time)
                if dtInd.y < yDefault + indY * indCount then
                    dtInd.y = func.lerp(dtInd.y, yDefault + indY * indCount + 1, time)
                else
                    dtInd.y = yDefault + indY * indCount
                end
                chargeInd.w = 0.1
                if not isCharged then
                    dtClr.r = func.lerp(dtClr.r, 222, time)
                    dtClr.g = func.lerp(dtClr.g, 55, time)
                    dtClr.b = func.lerp(dtClr.b, 55, time)
                else
                    dtClr.r = func.lerp(dtClr.r, 144, time)
                    dtClr.g = func.lerp(dtClr.g, 238, time)
                    dtClr.b = func.lerp(dtClr.b, 144, time)
                end
                indCount = indCount + 1
            elseif not isDt then 
                dtClr.a = func.lerp(dtClr.a, 0, time)
                dtInd.y = func.lerp(dtInd.y, yDefault - 5, time)
            end
    
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "DT" or "dt") + 2)/2) * scopedFraction , sizeY / 2 + dtInd.y + 13 + globalMoveY, dtClr.r, dtClr.g, dtClr.b, dtClr.a, globalFlag, dtInd.w, globalFlag == "cd-" and "DT" or "dt")
        end
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Hideshots") then
            indicators = indicators + 1
            if isOs then 
                osInd.a = func.lerp(osInd.a, 255, time)
                if osInd.y < yDefault + indY * indCount then
                    osInd.y = func.lerp(osInd.y, yDefault + indY * indCount + 1, time)
                else
                    osInd.y = yDefault + indY * indCount
                end
        
                indCount = indCount + 1
            elseif not isOs then
                osInd.a = func.lerp(osInd.a, 0, time)
                osInd.y = func.lerp(osInd.y, yDefault - 5, time)
            end
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "HS" or "hs") + 2)/2) * scopedFraction, sizeY / 2 + osInd.y + 13 + globalMoveY, 255, 255, 255, osInd.a, globalFlag, osInd.w, globalFlag == "cd-" and "HS" or "hs")
        end
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Freestand") then
            indicators = indicators + 1
            if isFs then 
                fsInd.a = func.lerp(fsInd.a, 255, time)
                if fsInd.y < yDefault + indY * indCount then
                    fsInd.y = func.lerp(fsInd.y, yDefault + indY * indCount + 1, time)
                else
                    fsInd.y = yDefault + indY * indCount
                end
                indCount = indCount + 1
            elseif not isFs then 
                fsInd.a = func.lerp(fsInd.a, 0, time)
                fsInd.y = func.lerp(fsInd.y, yDefault - 5, time)
            end
            renderer.text(sizeX / 2 + fsInd.x + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "FS" or "fs") + 2)/2) * scopedFraction, sizeY / 2 + fsInd.y + 13 + globalMoveY, 255, 255, 255, fsInd.a, globalFlag, fsInd.w, globalFlag == "cd-" and "FS" or "fs")
        end
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Safepoint") then
            indicators = indicators + 1
            if isSp then 
                spInd.a = func.lerp(spInd.a, 255, time)
                if spInd.y < yDefault + indY * indCount then
                    spInd.y = func.lerp(spInd.y, yDefault + indY * indCount + 1, time)
                else
                    spInd.y = yDefault + indY * indCount
                end
                indCount = indCount + 1
            elseif not isSp then 
                spInd.a = func.lerp(spInd.a, 0, time)
                spInd.y = func.lerp(spInd.y, yDefault - 5, time)
            end
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "SP" or "sp") + 2)/2) * scopedFraction, sizeY / 2 + spInd.y + 13 + globalMoveY, 255, 255, 255, spInd.a, globalFlag, 0, globalFlag == "cd-" and "SP" or "sp")
        end
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Body aim") then
            indicators = indicators + 1
            if isBa then
                baInd.a = func.lerp(baInd.a, 255, time)
                if baInd.y < yDefault + indY * indCount then
                    baInd.y = func.lerp(baInd.y, yDefault + indY * indCount + 1, time)
                else
                    baInd.y = yDefault + indY * indCount
                end
                indCount = indCount + 1
            elseif not isBa then 
                baInd.a = func.lerp(baInd.a, 0, time)
                baInd.y = func.lerp(baInd.y, yDefault - 5, time)
            end
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "BA" or "ba") + 2)/2) * scopedFraction, sizeY / 2 + baInd.y + 13 + globalMoveY, 255, 255, 255, baInd.a, globalFlag, 0, globalFlag == "cd-" and "BA" or "ba")
        end
    
        if func.table_contains(ui.get(menu.visualsTab.indicatorsStyle), "Fakeduck") then
            indicators = indicators + 1
            if isFd then
                fdInd.a = func.lerp(fdInd.a, 255, time)
                if fdInd.y < yDefault + indY * indCount then
                    fdInd.y = func.lerp(fdInd.y, yDefault + indY * indCount + 1, time)
                else
                    fdInd.y = yDefault + indY * indCount
                end
                indCount = indCount + 1
            elseif not isFd then 
                fdInd.a = func.lerp(fdInd.a, 0, time)
                fdInd.y = func.lerp(fdInd.y, yDefault - 5, time)
            end
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "FD" or "fd") + 2)/2) * scopedFraction, sizeY / 2 + fdInd.y + 13 + globalMoveY, 255, 255, 255, fdInd.a, globalFlag, 0, globalFlag == "cd-" and "FD" or "fd")
        end
    end

    -- draw dmg indicator
    if ui.get(menu.visualsTab.minDmgIndicator) and entity.get_classname(weapon) ~= "CKnife" and ui.get(refs.dmgOverride[1]) and ui.get(refs.dmgOverride[2]) then
        local dmg = ui.get(refs.dmgOverride[3])
        renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, dmg)
    end

    -- draw watermark
    if indicators == 0 then
        local watermarkX, watermarkY = renderer.measure_text("c", "discord.gg/serenitylua")
        glow_module(sizeX - 58 - watermarkX/2, 10, watermarkX - 3, 0, 10, 0, {255, 255, 255, 100 * math.abs(math.cos(globals.curtime()*2))}, {255, 255, 255, 100 * math.abs(math.cos(globals.curtime()*2))})
        renderer.text(sizeX - 60, 10,  mainClr.r, mainClr.g, mainClr.b, 255, "c", 0, func.hex({255, 255, 255}) .. "discord.gg/" .. func.hex({210, 166, 255}) .. "serenitylua")
    end

    -- draw logs
    local call_back = ui.get(menu.visualsTab.logs) and client.set_event_callback or client.unset_event_callback

    notifications.render()
end)
-- @region INDICATORS end

-- @region UI_CALLBACKS start
ui.update(menu.configTab.list,getConfigList())
if database.read(lua.database.configs) == nil then
    database.write(lua.database.configs, {})
end
ui.set(menu.configTab.name, #database.read(lua.database.configs) == 0 and "" or database.read(lua.database.configs)[ui.get(menu.configTab.list)+1].name)
ui.set_callback(menu.configTab.list, function(value)
    local protected = function()
        if value == nil then return end
        local name = ""
    
        local configs = getConfigList()
        if configs == nil then return end
    
        name = configs[ui.get(value)+1] or ""
    
        ui.set(menu.configTab.name, name)
    end

    if pcall(protected) then

    end
end)

ui.set_callback(menu.configTab.load, function()
    local r, g, b = ui.get(menu.visualsTab.logsClr)
    local name = ui.get(menu.configTab.name)
    if name == "" then return end
    local protected = function()
        loadConfig(name)
    end

    if pcall(protected) then
        name = name:gsub('*', '')
        notifications.new(string.format('Successfully loaded "$%s$"', name), r, g, b)
    else
        notifications.new(string.format('Failed to load "$%s$"', name), 255, 120, 120)
    end
end)

ui.set_callback(menu.configTab.save, function()
    local r, g, b = ui.get(menu.visualsTab.logsClr)

        local name = ui.get(menu.configTab.name)
        if name == "" then return end
    
        for i, v in pairs(presets) do
            if v.name == name:gsub('*', '') then
                notifications.new(string.format('You can`t save built-in preset "$%s$"', name:gsub('*', '')), 255, 120, 120)
                return
            end
        end

        if name:match("[^%w]") ~= nil then
            notifications.new(string.format('Failed to save "$%s$" due to invalid characters', name), 255, 120, 120)
            return
        end
    local protected = function()
        saveConfig(name)
        ui.update(menu.configTab.list, getConfigList())
    end
    if pcall(protected) then
        notifications.new(string.format('Successfully saved "$%s$"', name), r, g, b)
    end
end)

ui.set_callback(menu.configTab.delete, function()
    local name = ui.get(menu.configTab.name)
    if name == "" then return end
    local r, g, b = ui.get(menu.visualsTab.logsClr)
    if deleteConfig(name) == false then
        notifications.new(string.format('Failed to delete "$%s$"', name), 255, 120, 120)
        ui.update(menu.configTab.list, getConfigList())
        return
    end

    for i, v in pairs(presets) do
        if v.name == name:gsub('*', '') then
            notifications.new(string.format('You can`t delete built-in preset "$%s$"', name:gsub('*', '')), 255, 120, 120)
            return
        end
    end

    local protected = function()
        deleteConfig(name)
    end

    if pcall(protected) then
        ui.update(menu.configTab.list, getConfigList())
        ui.set(menu.configTab.list, #presets + #database.read(lua.database.configs) - #database.read(lua.database.configs))
        ui.set(menu.configTab.name, #database.read(lua.database.configs) == 0 and "" or getConfigList()[#presets + #database.read(lua.database.configs) - #database.read(lua.database.configs)+1])
        notifications.new(string.format('Successfully deleted "$%s$"', name), r, g, b)
    end
end)

ui.set_callback(menu.configTab.import, function()
    local r, g, b = ui.get(menu.visualsTab.logsClr)

    local protected = function()
        importSettings()
    end

    if pcall(protected) then
        notifications.new(string.format('Successfully imported settings', name), r, g, b)
    else
        notifications.new(string.format('Failed to import settings', name), 255, 120, 120)
    end
end)

ui.set_callback(menu.configTab.export, function()
    local name = ui.get(menu.configTab.name)
    if name == "" then return end

    local protected = function()
        exportSettings(name)
    end
    local r, g, b = ui.get(menu.visualsTab.logsClr)
    if pcall(protected) then
        notifications.new(string.format('Successfully exported settings', name), r, g, b)
    else
        notifications.new(string.format('Failed to export settings', name), 255, 120, 120)
    end
end)
-- @region UI_CALLBACKS end

-- @region UI_RENDER start
client.set_event_callback("paint_ui", function()
    vars.activeState = vars.sToInt[ui.get(menu.builderTab.state)]
    local isEnabled = true
    local isAATab = ui.get(tabPicker) == "Anti-aim" 
    local isBuilderTab = ui.get(tabPicker) == "Builder" 
    local isVisualsTab = ui.get(tabPicker) == "Visuals" 
    local isMiscTab = ui.get(tabPicker) == "Misc" 
    local isCFGTab = ui.get(tabPicker) == "Config" 

    local aA = func.create_color_array(lua_color.r, lua_color.g, lua_color.b, "serenity")
    ui.set(label, string.format("                   \a%ss\a%se\a%sr\a%se\a%sn\a%si\a%st\a%sy", func.RGBAtoHEX(unpack(aA[1])), func.RGBAtoHEX(unpack(aA[2])), func.RGBAtoHEX(unpack(aA[3])), func.RGBAtoHEX(unpack(aA[4])), func.RGBAtoHEX(unpack(aA[5])), func.RGBAtoHEX(unpack(aA[6])),  func.RGBAtoHEX(unpack(aA[7])),  func.RGBAtoHEX(unpack(aA[8])) ) )
    ui.set(aaBuilder[1].enableState, true)
    for i = 1, #vars.aaStates do
        local stateEnabled = ui.get(aaBuilder[i].enableState)
        ui.set_visible(aaBuilder[i].enableState, vars.activeState == i and i~=1 and isBuilderTab and isEnabled)
        ui.set_visible(aaBuilder[i].forceDefensive, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].pitch, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].pitchSlider , vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].pitch) == "Custom" and isEnabled)
        ui.set_visible(aaBuilder[i].yawBase, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawStatic, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yaw) ~= "Slow Yaw" and ui.get(aaBuilder[i].yaw) ~= "L&R" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawLeft, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and (ui.get(aaBuilder[i].yaw) == "Slow Yaw" or ui.get(aaBuilder[i].yaw) == "L&R") and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawRight, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and (ui.get(aaBuilder[i].yaw) == "Slow Yaw" or ui.get(aaBuilder[i].yaw) == "L&R") and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitter, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].wayFirst, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) == "3-Way"  and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].waySecond, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) == "3-Way"  and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].wayThird, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) == "3-Way"  and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterStatic, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitter) ~= "L&R" and ui.get(aaBuilder[i].yawJitter) ~= "3-Way" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterLeft, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) == "L&R" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterRight, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawJitter) == "L&R" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawStatic, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and ui.get(aaBuilder[i].bodyYaw) ~= "Opposite" and isBuilderTab and stateEnabled and isEnabled)
    end

    for i, feature in pairs(menu.aaTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isAATab and isEnabled)
        end
	end 

    for i, feature in pairs(menu.aaTab.manualTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isAATab and isEnabled and ui.get(menu.aaTab.manuals) ~= "Off")
        end
	end 

    for i, feature in pairs(menu.builderTab) do
		ui.set_visible(feature, isBuilderTab and isEnabled)
	end

    for i, feature in pairs(menu.visualsTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isVisualsTab and isEnabled)
        end
	end 
    ui.set_visible(menu.visualsTab.logOffset, ui.get(menu.visualsTab.logs) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.logsClr, ui.get(menu.visualsTab.logs) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.indicatorsStyle, ui.get(menu.visualsTab.indicatorsType) ~= "-" and ui.get(menu.visualsTab.indicators) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.indicatorsClr, ui.get(menu.visualsTab.indicators) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.indicatorsType, ui.get(menu.visualsTab.indicators) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.arrowIndicatorStyle, ui.get(menu.visualsTab.arrows) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.arrowClr, ui.get(menu.visualsTab.arrows) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.watermarkClr, ui.get(menu.visualsTab.watermark) and isVisualsTab and isEnabled)
    
    for i, feature in pairs(menu.miscTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isMiscTab and isEnabled)
        end
	end
    ui.set_visible(menu.miscTab.fastLadder, ui.get(menu.miscTab.fastLadderEnabled) and isMiscTab and isEnabled)
    ui.set_visible(menu.miscTab.animations, ui.get(menu.miscTab.animationsEnabled) and isMiscTab and isEnabled)

    for i, feature in pairs(menu.configTab) do
		ui.set_visible(feature, isCFGTab and isEnabled)
	end

    if not isEnabled and not saved then
        func.resetAATab()
        ui.set(refs.fsBodyYaw, isEnabled)
        ui.set(refs.enabled, isEnabled)
        saved = true
    elseif isEnabled and saved then
        ui.set(refs.fsBodyYaw, not isEnabled)
        ui.set(refs.enabled, isEnabled)
        saved = false
    end
    func.setAATab(not isEnabled)

end)
-- @region UI_RENDER end

client.set_event_callback("shutdown", function()
    if legsSaved ~= false then
        ui.set(refs.legMovement, legsSaved)
    end
    if hsValue ~= nil then
        ui.set(refs.fakeLag[1], hsValue)
    end
    if clanTag ~= nil then
        client.set_clan_tag("")
    end
    if dtSaved ~= nil then
        ui.set(refs.dt[3], "Defensive")
    end
    func.setAATab(true)
end)