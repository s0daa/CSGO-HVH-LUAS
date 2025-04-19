
local lua_name = "anxiety"
local promote = ui.new_label("AA", "Other", "*currently playing with anxiety.rip*")


local lua_color = {r = 190 , g = 180, b = 214}


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

-- Fetch Anxiety data or default values
local anxiety_data = anxiety_fetch and anxiety_fetch() or {username = 'alynsense', build = 'dev', discord = ''}


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
    "dont talking pls",
	"when u miss, cry u dont hev alynsense",
	"you think you are is good but im best 1",
	"fokin dog, get ownet by ÃÃ¡ÃÃ¾ÃÃ·ÃÃ´ÃÃ°ÃÃ¢¬Å¡ÃÃµÃÃ»ÃÃ js rezolver",
	"if im lose = my team is dog",
	"never talking bad to me again, im always top1",
	"umad that you're miss? hs dog",
	"vico (top1 eu) vs all kelbs on hvh.",
	"you is mad that im ur papi?",
	"im will rape u're mother after i killed you",
	"stay mad that im unhitable",
	"god night brother, cya next raund ;)",
	"get executed from presidend of argentina",
	"you thinking ur have chencse vs boss?",
	"i killed gejmsense, now im kill you",
	"by luckbaysed config, cya twitter bro o/",
	"cy@ https://gamesense.pub/forums/viewforum.php?id=6",
	"Ã¢Ã¢¬¢Ã­Ã¢Ã Ã©Ã¢Ã¢¬¢Ã®(Ã¢Ã¢¬Ã£_Ã¢Ã¢¬Ã¢)Ã¢Ã¢¬¢Ã­Ã¢Ã Ã©Ã¢Ã¢¬¢Ã®(its fuck)",
	"dont play vs me on train, im live there -.-",
	"by top1 uzbekistan holder umed?",
	"courage for play de_shortnuke vs me, my home there.",
	"bich.. dont test g4ngst3r in me.",
	"im rich princ here, dont toxic dog.",
	"for all thet say gamesense best, im try on parsec and is dog.",
	"WEAK DOG sanchezj vs ru bossman (owned on mein map)",
	"im want gamesense only for animbrejker, neverlose always top.",
	"this dog brandog thinking hes top, but reality say no.",
	"fawk you foking treny",
	"ur think ur good but its falsee.",
	"topdog nepbot get baits 24/7 -.-",
	"who this bot malva? im own him 9-0",
	"im beat all romania dogs with 1 finker",
	"im rejp this dog noobers with no problems",
	"gamesense hazey vs all -.-",
	"irelevent dog jompan try to stay popular but fail",
	"im user dev and ur dont, stay mad.",
	"dont talking, no anxiety red no talk pls",
	"when u miss, cry u dont hev alynsense",
	"you think you are is good but anxiety is best",
	"fkn dog, get own by anxiety js rezolver",
	"if you luse = no anxiety issue",
	"never talking bad to me again, anxiety boosing me to top1",
	"umad that you're miss? get anxiety d0g",
	"stay med that im unhitable ft anxiety",
	"get executed from anxiety rednology",
	"you thinking ur have chencse vs anxiety?",
	"first i killed gejmsense, now anxiety kill you",
	"by anxiety boss aa, cya twitter bro o/",
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
            local size = vector(renderer.measure_text(text))
            renderer.text(x + x_Offset, y, r, g, b, a, 0, text)
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

    http.get("https://cdn.discordapp.com/attachments/1259577598988779573/1259598017036550274/076012ed753944aad1f961b68816825e652d676e01b69.png?ex=668c4391&is=668af211&hm=f1b1096fe7c716622f901122ff76acdf30ecae0f2eff6c52d1c1aa514aac8593&", function(success, response)
		if not success or response.status ~= 200 then
			print("couldnt fetch the logo image")
            return
		end

		writefile("logo.png", response.body)
	end)
end
-- downloadFile()
-- @region FUNCS end

-- @region UI_LAYOUT start
local tab, container = "AA", "Anti-aimbot angles"
local label = ui.new_label(tab, container, lua_name)
local tabPicker = ui.new_combobox(tab, container, "\nTab", "Anti-aim", "Builder", "Visuals", "Misc", "Config")

local menu = {
    aaTab = {
        freestandHotkey = ui.new_hotkey(tab, container, "Freestand"),
        legitAAHotkey = ui.new_hotkey(tab, container, "Legit Anti-\aCBC5E0E6aim"),
        edgeYawHotkey = ui.new_hotkey(tab, container, "Edge \aCBC5E0E6Yaw"),
        avoidBackstab = ui.new_slider(tab, container, "Avoid Back\aCBC5E0E6stab", 0, 300, 0, true, "u", 1, {[0] = "Off"}),
        manuals = ui.new_combobox(tab, container, "Manu\aCBC5E0E6als", "Off", "Default", "Static"),
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
        indicators = ui.new_checkbox(tab, container, "Indi\aCBC5E0E6cators"),
        indicatorsClr = ui.new_color_picker(tab, container, "Main Color", lua_color.r, lua_color.g, lua_color.b, 255),
        indicatorsType = ui.new_combobox(tab, container, "\n indicators type", "-", "Style 1", "Style 2"),
        indicatorsStyle = ui.new_multiselect(tab, container, "Ele\aCBC5E0E6ments", "Name", "State", "Doubletap", "Hideshots", "Freestand", "Safepoint", "Body aim", "Fakeduck"),
        arrows = ui.new_checkbox(tab, container, "Arr\aCBC5E0E6ows"),
        arrowClr = ui.new_color_picker(tab, container, "Arrow Color", lua_color.r, lua_color.g, lua_color.b, 255),
        arrowIndicatorStyle = ui.new_combobox(tab, container, "\n arrows style", "-", "Teamskeet", "Modern"),
        watermark = ui.new_checkbox(tab, container, "Branded \aCBC5E0E6Watermark"),
        watermarkClr = ui.new_color_picker(tab, container, "Watermark Color", lua_color.r, lua_color.g, lua_color.b, 255),
        minDmgIndicator = ui.new_checkbox(tab, container, "Minimum \aCBC5E0E6Damage Indicator"),
        logs = ui.new_checkbox(tab, container, "Lo\aCBC5E0E6gs"),
        logsClr = ui.new_color_picker(tab, container, "Logs Color", lua_color.r, lua_color.g, lua_color.b, 255),
        logOffset = ui.new_slider(tab, container, "Offset", 0, 500, 100, true, "px", 1)
    },
    miscTab = {
        fixHideshots = ui.new_checkbox(tab, container, "Fix hide\aCBC5E0E6shots"),
        manualsOverFs = ui.new_checkbox(tab, container, "Manuals over free\aCBC5E0E6standing"),
        dtDischarge = ui.new_checkbox(tab, container, "Auto DT Dis\aCBC5E0E6charge"),
        clanTag = ui.new_checkbox(tab, container, "Clan\aCBC5E0E6tag"),
        trashTalk = ui.new_checkbox(tab, container, "Trash\aCBC5E0E6talk"),
        fastLadderEnabled = ui.new_checkbox(tab, container, "Fast \aCBC5E0E6ladder"),
        fastLadder = ui.new_multiselect(tab, container, "\n fast ladder", "Ascending", "Descending"),
        animationsEnabled = ui.new_checkbox(tab, container, "Anim \aCBC5E0E6breakers"),
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
        enableState = ui.new_checkbox(tab, container, "Ena\aCBC5E0E6ble " .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({200,200,200}) .. " state"),
        forceDefensive = ui.new_checkbox(tab, container, "Force \aCBC5E0E6Defensive\n" .. aaContainer[i]),
        pitch = ui.new_combobox(tab, container, "Pitch\n" .. aaContainer[i], "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
        pitchSlider = ui.new_slider(tab, container, "\nPitch add" .. aaContainer[i], -89, 89, 0, true, "ÃÃ°", 1),
        yawBase = ui.new_combobox(tab, container, "Yaw base\n" .. aaContainer[i], "Local view", "At targets"),
        yaw = ui.new_combobox(tab, container, "Yaw\n" .. aaContainer[i], "Off", "180", "180 Z", "Spin", "Slow Yaw", "L&R"),
        yawStatic = ui.new_slider(tab, container, "\nyaw" .. aaContainer[i], -180, 180, 0, true, "ÃÃ°", 1),
        yawLeft = ui.new_slider(tab, container, "Left\nyaw" .. aaContainer[i], -180, 180, 0, true, "ÃÃ°", 1),
        yawRight = ui.new_slider(tab, container, "Right\nyaw" .. aaContainer[i], -180, 180, 0, true, "ÃÃ°", 1),
        yawJitter = ui.new_combobox(tab, container, "Yaw jitter\n" .. aaContainer[i], "Off", "Offset", "Center", "Skitter", "Random", "3-Way", "L&R"),
        wayFirst = ui.new_slider(tab, container, "First\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "", 1),
        waySecond = ui.new_slider(tab, container, "Second\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "ÃÃ°", 1),
        wayThird = ui.new_slider(tab, container, "Third\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "ÃÃ°", 1),
        yawJitterStatic = ui.new_slider(tab, container, "\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "ÃÃ°", 1),
        yawJitterLeft = ui.new_slider(tab, container, "Left\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "ÃÃ°", 1),
        yawJitterRight = ui.new_slider(tab, container, "Right\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "ÃÃ°", 1),
        bodyYaw = ui.new_combobox(tab, container, "Body yaw\n" .. aaContainer[i], "Off", "Opposite", "Jitter", "Static"),
        bodyYawStatic = ui.new_slider(tab, container, "\nbody yaw" .. aaContainer[i], -180, 180, 0, true, "ÃÃ°", 1),
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

    local link = "nofile"

    http.get(link, function(success, response)
        if not success then
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
local icon = base64.decode("iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAMAAADVRocKAAADAFBMVEVHcEw6NTV5bW4yISFKRkVPRkjMzMxXQ0Wyq6tjV1e3ra1xaWjk4+Pqs7swLCytpqbXlZnmyMvqztFoW1s5LCznyc7m09XcwMGsqKePgoOjiYqShYVANziLd3nDl5tvZ2fkz9LVrLHctrrNu7uvpKWzpKR0a2y9qavVoaTgl53bvsDd0tTKr7LOqazz1NZHNjWxnZ/bs7Ti09XKjI7LxcahgYJdV1NSQUDm2NjTw8Tk4uXkzM/nxcrYwcTn0dThyMvWvL7dur3i0NPUrrS8m5zhyMrq1tm4jo+0nZ8sJSXKoaVYPT2/np+WaWaTW1e7YmPEkJTReHpJQT86MDHUqrK3gYS6jY7Jsa/p29qwiIm9goOaUU/NmJ26dnfNfIBxMzVLPTxYSEmddnXKoaTex8nar7KZRT7ToKPRoaSiXlyoenvLjZR4cnJcV1YvJyTkt73m2djbvr7n0dPCiYnw3d6klJWnZWRkPzxwVFBfSUmIYV/UmqA1LC7iwsbmvsPhxcnnyc7kxMbivsTnx8zrzdHfvr7kxMngwMHiwcTjwsflzM/kyczjurvmxcnlwcPnwcXgu7/qys/nycvgs7rlxsvlxsfp0dTkvb/nzM/gvcLeuLvjvMHmvcDitrjewcTpxMvmx8nlys3eqbDu1Nfr09bgt73kxMPixsboztHetLXjq7Hkx8nburvoxMbs2Nnmur7isbbmwsjn0dPYrrLjrrPdt7nesLTfrrDgw8Xrysvqx8zjv8Hox8nepazboqjt0NTjub/hu7zZnqLkwMbty9DhysvcvsLu29zdsLbYs7fqxsjqwcjowcHnt7vgnqLmusPv2dvltbjz3d7pzc3x0NTaq6/mp67dvL/aqKvswMTrusDiwcLizc7jtbwpGxreqKvk0NDdtLnr0NHvz9DvxcjdxcftyM704eHw3t7p19bz2NrQkpPUpKfpsLPBeXzUnaDHhYfewMHio6fRmJvdkZXRh4nbiY7Eam3axcGsZGPXg4LGlpNRJiN8LS7RbXNDKCj/v/QQAAAA7HRSTlMAEA/+BQoOAQECBxgW/hYn/tvyQvzmh9oZL2dGHFeTKZ/k02QyVzdD8v60Z439/SpQ/UX5LXaY+3h6OLT2o86sm+eUu4HIttNcIaJRaarO+rL+xtLRpftz24ne5uzv/vtGtc/O6ff+vtv87Nd1bOrz6fxS5+B74eCt/Ybod////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////gLro/gAAA7dSURBVGje7Fd5UJN3Gg4k5Ps+UGTEiigeO7UqWrSIeKxHp63rfe96V+2qa6vttt3pbtvdGUggB5gDEhICISSYC0ICgVwkEK4EQ0AgcsVkIGAQESIRiIh4tN39otuxg4y7ruGPnek7k8kfmXmfvM/7PO/7/hCIX+PX+P8OAACmND+EDkRMIQKIWL1vX2wQasogwFXb91+4uHc3NFX8+O21PBg/ffDkO9DU1ACEfjtUaRl7+NPJ3QFTggCtWBYzLHWPjg2dDZ0KABA9u1A9FGO1G0PGzgZNAQKw8Jwhv8M+WllRYazcFQT6PD9ixZEoSk+2e7hSYLUuOxrgcwBwOYHQxkyKtqqsnN6VYfN87WlgqcdQ2iq/m95barjS316+y6tVH+oVAPZE9VAlkjZy1UoVQXS394M5IIhaFeE7DUEfRrmjksrptZiVGflR/St734YB/rzW31c1QIu3tDfUq2hULF/SVlbP7xeGLYFgZQX5aG6AqPUrr14uY9fX4/kmpZKlbBWR3/WDEVBo3yBAwdt6NbY4+mUaU+R0KCVKpRz7u50AAoAHuC8cASJ+uz2KUJCbrmjHmwZccAVKFn7m297dAKF9o6ENugK9gcJ121gOh9mldCmVVVc3A88mCOQTly2ippVS3MNPea1yk0npcprNdFyYv/e3OXMAXwy6MG51b1uB211r7jf3yfh8fhWO/Zd53tToGYAvbLyJoE+/1daZipebB+R8EoYpY7JTtnq3JzgN5QORvlualxdX3i7pw7aaB/ol/EwelskWf/Rspk7zf2MdgQv/kNpGJl5OczoxrNb+/gEHySTDEjm/ebZ40Og3BoDe+6AuvgyH4ZmU+D7RQP+AyEHCkMjUr+Z6FYRCv2kTwIDZX00XXL9DMmFwEr5JbjazlCQ+2URuWgCbGQyYBk2q7NcACH6/6lqLoCuZ5DQ5nA6WXC7JlDjIRN3t7auAyQEAv53BrwEQsVHY28io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")
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
		local clan_tag = clantag("anxiety", {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22})
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
        local marginX, marginY = renderer.measure_text( "A N X I E T Y")
        local png = images.load_png(readfile("logo.png"))
        png:draw(15, sizeY/2 - 9, 32, 42, 255, 255, 255, wAlpha, true, "f")
        renderer.text(47, sizeY/2 - 2 + mainY, watermarkClr.r, watermarkClr.g, watermarkClr.b, wAlpha, nil, "A N X I E T Y\a" .. func.RGBAtoHEX(255, 255, 255, wAlpha) .. " [" .. userdata.build:upper() .. "]")
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
        local watermarkX, watermarkY = renderer.measure_text("c", "discord.gg/FYcbcS9tY3")
        glow_module(sizeX - 58 - watermarkX/2, 10, watermarkX - 3, 0, 10, 0, {255, 255, 255, 100 * math.abs(math.cos(globals.curtime()*2))}, {255, 255, 255, 100 * math.abs(math.cos(globals.curtime()*2))})
        renderer.text(sizeX - 60, 10,  mainClr.r, mainClr.g, mainClr.b, 255, "c", 0, func.hex({255, 255, 255}) .. "discord.gg/" .. func.hex({210, 166, 255}) .. "FYcbcS9tY3")
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

    local aA = func.create_color_array(lua_color.r, lua_color.g, lua_color.b, "Ã¢Å¨ anxiety")
    ui.set(label, string.format("Ã¢Å¨ \a%sA \a%sN \a%sX \a%sI \a%sE \a%sT \a%sY \a%s [DEV]", func.RGBAtoHEX(unpack(aA[1])), func.RGBAtoHEX(unpack(aA[2])), func.RGBAtoHEX(unpack(aA[3])), func.RGBAtoHEX(unpack(aA[4])), func.RGBAtoHEX(unpack(aA[5])), func.RGBAtoHEX(unpack(aA[6])),  func.RGBAtoHEX(unpack(aA[7])),  func.RGBAtoHEX(unpack(aA[8])) ) )
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