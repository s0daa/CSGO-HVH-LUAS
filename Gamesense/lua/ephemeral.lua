
local lua_name = "ephemeral"
local promote = ui.new_label("AA", "Other", "*currently playing with ephemeral.tools*")


local lua_color = {r = 154 , g = 140, b = 212}


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


local ephemeral_data = ephemeral_fetch and ephemeral_fetch() or {username = 'ephemeral', build = 'dev', discord = ''}

-- Process user data
local userdata = {
    username = ephemeral_data.username or 'alynsense',  -- If username is nil, fallback to default
    build = ephemeral_data.build and ephemeral_data.build:gsub("[Pp]rivate", "dev"):gsub("[Bb]eta", "dev"):gsub("[Uu]ser", "live") or 'recode' -- Replace occurrences of Private, Beta, and User with dev and live accordingly
}



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
	"when u miss, cry u dont hev ephemeral",
	"you think you are is good but im best 1",
	"fokin dog, get ownet by ephemeral js rezolver",
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
	"_w_(its fuck)",
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
	"dont talking, no ephemeral red no talk pls",
	"when u miss, cry u dont hev ephemeral",
	"you think you are is good but ephemeral is best",
	"fkn dog, get own by ephemeral js rezolver",
	"if you luse = no ephemeral issue",
	"never talking bad to me again, ephemeral boosing me to top1",
	"umad that you're miss? get ephemeral d0g",
	"stay med that im unhitable ft ephemeral",
	"get executed from ephemeral rednology",
	"you thinking ur have chencse vs ephemeral?",
	"first i killed gejmsense, now ephemeral kill you",
	"by ephemeral boss aa, cya twitter bro o/",
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

    http.get("https://cdn.discordapp.com/attachments/1261070580980125897/1261384339074187335/3123123-removebg-preview.png?ex=6692c335&is=669171b5&hm=f1ced5260a91da6a86b4932c62da62d97d7b2ab498ae3aa436a0fe88e52b4387&", function(success, response)
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
        freestandHotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "• Free\aB797E7FFstand"),
        legitAAHotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "• Legit Anti-\aB797E7FFaim"),
        edgeYawHotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "• Edge \aB797E7FFYaw"),
        avoidBackstab = ui.new_slider("AA", "Anti-aimbot angles", "• Avoid Back\aB797E7FFstab", 0, 300, 0, true, "u", 1, {[0] = "Off"}),
        manuals = ui.new_combobox("AA", "Anti-aimbot angles", "• Manu\aB797E7FFals", "Off", "Default", "Static"),
        manualTab = {
            manualLeft = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual " .. func.hex({200,200,200}) .. "left"),
            manualRight = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual " .. func.hex({200,200,200}) .. "right"),
            manualForward = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual " .. func.hex({200,200,200}) .. "forward"),
        },
    },
    builderTab = {
        state = ui.new_combobox(tab, container, "Anti-aim state", vars.aaStates)
    },
    visualsTab = {
        indicators = ui.new_checkbox(tab, container, "• Indi\aB797E7FFcators"),
        indicatorsClr = ui.new_color_picker(tab, container, "• Main Color", lua_color.r, lua_color.g, lua_color.b, 255),
        indicatorsType = ui.new_combobox(tab, container, "\n indicators type", "-", "Style 1", "Style 2"),
        indicatorsStyle = ui.new_multiselect(tab, container, "• Ele\aB797E7FFments", "Name", "State", "Doubletap", "Hideshots", "Freestand", "Safepoint", "Body aim", "Fakeduck"),
        arrows = ui.new_checkbox(tab, container, "• Arr\aB797E7FFows"),
        arrowClr = ui.new_color_picker(tab, container, "• Arrow Color", lua_color.r, lua_color.g, lua_color.b, 255),
        arrowIndicatorStyle = ui.new_combobox(tab, container, "\n arrows style", "-", "Teamskeet", "Modern"),
        watermark = ui.new_checkbox(tab, container, "• Branded \aB797E7FFWatermark"),
        watermarkClr = ui.new_color_picker(tab, container, "• Watermark Color", lua_color.r, lua_color.g, lua_color.b, 255),
        minDmgIndicator = ui.new_checkbox(tab, container, "• Minimum \aB797E7FFDamage Indicator"),
        logs = ui.new_checkbox(tab, container, "• Lo\aB797E7FFgs"),
        logsClr = ui.new_color_picker(tab, container, "• Logs Color", lua_color.r, lua_color.g, lua_color.b, 255),
        logOffset = ui.new_slider(tab, container, "• Offset", 0, 500, 100, true, "px", 1)
    },
    miscTab = {
        fixHideshots = ui.new_checkbox(tab, container, "• Fix hide\aB797E7FFshots"),
        manualsOverFs = ui.new_checkbox(tab, container, "• Manuals over free\aB797E7FFstanding"),
        dtDischarge = ui.new_checkbox(tab, container, "• Auto DT Dis\aB797E7FFcharge"),
        clanTag = ui.new_checkbox(tab, container, "• Clan\aB797E7FFtag"),
        trashTalk = ui.new_checkbox(tab, container, "• Trash\aB797E7FFtalk"),
        fastLadderEnabled = ui.new_checkbox(tab, container, "• Fast \aB797E7FFladder"),
        fastLadder = ui.new_multiselect(tab, container, "\n fast ladder", "Ascending", "Descending"),
        animationsEnabled = ui.new_checkbox(tab, container, "• Anim \aB797E7FFbreakers"),
        animations = ui.new_multiselect(tab, container, "\n animation breakers", "Static legs", "Leg fucker", "0 pitch on landing", "Allah legs"),
    },
    configTab = {
        list = ui.new_listbox(tab, container, "• Con\aB797E7FFfigs", ""),
        name = ui.new_textbox(tab, container, "• Con\aB797E7FFfig name", ""),
        load = ui.new_button(tab, container,  "• Lo\aB797E7FFad", function() end),
        save = ui.new_button(tab, container,  "• Sa\aB797E7FFve", function() end),
        delete = ui.new_button(tab, container,"• Del\aB797E7FFete", function() end),
        import = ui.new_button(tab, container,"• Im\aB797E7FFport", function() end),
        export = ui.new_button(tab, container,"• Ex\aB797E7FFport", function() end)
    }
}

local aaBuilder = {}
local aaContainer = {}
for i=1, #vars.aaStates do
    aaContainer[i] = func.hex({200,200,200}) .. "(" .. func.hex({222,55,55}) .. "" .. vars.pStates[i] .. "" .. func.hex({200,200,200}) .. ")" .. func.hex({155,155,155}) .. " "
    aaBuilder[i] = {
        enableState = ui.new_checkbox(tab, container, "Ena\aB797E7FFble " .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({200,200,200}) .. " state"),
        forceDefensive = ui.new_checkbox(tab, container, "Force \aB797E7FFDefensive\n" .. aaContainer[i]),
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
    
            local paddingx, paddingy = 7 * 3, data.size * 4  -- Increase border size
            local offsetY = ui.get(menu.visualsTab.logOffset)
    
            Offset = Offset + (strh + paddingy * 2 + math.sqrt(data.glow / 10) * 13 + 5) * fraction
            glow_module(x / 2 - (strw + strw2) / 2 - paddingx, y - offsetY - strh / 2 - paddingy - Offset, strw + strw2 + paddingx * 2, strh + paddingy * 2, data.glow, data.rounding, {r, g, b, 45 * fraction}, {25, 25, 25, 140 * fraction})
            renderer.text(x / 2 + strw2 / 2, y - offsetY - Offset, 255, 255, 255, 255 * fraction, "c", 0, string)
            local icon = images.load_png(icon, 8, 8)
            icon:draw(x / 2 - strw / 2 - 12.5, y - offsetY - Offset - 10, 20, 20, r, g, b, 255 * fraction, "f")
        end
    
        for i = #to_remove, 1, -1 do
            table.remove(data, to_remove[i])
        end
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
		local clan_tag = clantag("ephemeral", {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22})
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
        local marginX, marginY = renderer.measure_text("-d", "E P H E M E R AL ")
        local png = images.load_png(readfile("logo.png"))
        png:draw(15, sizeY/2 - 9, 32, 42, 255, 255, 255, wAlpha, true, "f")
        renderer.text(47, sizeY/2 - 2 + mainY, watermarkClr.r, watermarkClr.g, watermarkClr.b, wAlpha, "-d", nil, "E P H E M E R A L\a" .. func.RGBAtoHEX(255, 255, 255, wAlpha) .. " [" .. userdata.build:upper() .. "]")
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
        local watermarkX, watermarkY = renderer.measure_text("c", "discord.gg/ephemeral")
        glow_module(sizeX - 58 - watermarkX/2, 10, watermarkX - 3, 0, 10, 0, {255, 255, 255, 100 * math.abs(math.cos(globals.curtime()*2))}, {255, 255, 255, 100 * math.abs(math.cos(globals.curtime()*2))})
        renderer.text(sizeX - 60, 10,  mainClr.r, mainClr.g, mainClr.b, 255, "c", 0, func.hex({255, 255, 255}) .. "discord.gg/" .. func.hex({210, 166, 255}) .. "ephemeral")
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

    local aA = func.create_color_array(lua_color.r, lua_color.g, lua_color.b, "✨ ephemeral")
    ui.set(label, string.format("✨ \a%sE \a%sP \a%sH \a%sE \a%sM \a%sE \a%sR \a%sA \a%sL [DEV]", func.RGBAtoHEX(unpack(aA[1])), func.RGBAtoHEX(unpack(aA[2])), func.RGBAtoHEX(unpack(aA[3])), func.RGBAtoHEX(unpack(aA[4])), func.RGBAtoHEX(unpack(aA[5])), func.RGBAtoHEX(unpack(aA[6])),  func.RGBAtoHEX(unpack(aA[7])),  func.RGBAtoHEX(unpack(aA[8])), func.RGBAtoHEX(unpack(aA[9])) ) )
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