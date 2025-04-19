-- downloaded from dsc.gg/southwestcfgs

-- @region LUASETTINGS start
local lua_name = "interitus recode"
local lua_color = {r = 255, g = 115, b = 105}
local data = {username = 'user', build = 'renewed'}
    
local lua_banner = [[                                                                                                           
                                                                                                                           
]]
-- @region LUASETTINGS end

local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'renewed', discord=''}
local userdata = {
    username = obex_data.username == nil or obex_data.username,
    build = obex_data.build ~= nil and obex_data.build:gsub("Private", "?"):gsub("Beta", "beta"):gsub("User", "renewed")
}
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
local ent = try_require("gamesense/entity")
local steamworks = try_require("gamesense/steamworks") or error('Missing https://gamesense.pub/forums/viewtopic.php?id=26526')
-- @region DEPENDENCIES end

local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')
-- @region DATABASE & OBEX start

local login = {
    username = data.username,
    version = "1.0.0",
    build = data.build,

}

local antibrute_data = {
    miss_counter = 0,
    jitter_value = 0,
    entity = entity.get_local_player(),
    entity2 = nil,
    recorded_entity = nil,
    entity_changed = false,
    fixxer_nixxer = false,
    bruted_last_time = 0,
    recorded_state = 0,
    stored_misses = 0,
    final_side = 0,
    recorded_side = 0,
    last_side = "none",
    rdm = 0,
    time = {},
    stage = {},
    should_swap = {},
}

local function breathe(offset, multiplier)
    local speed = globals.realtime() * (multiplier or 1.0);
    local factor = speed % math.pi;

    local sin = math.sin(factor + (offset or 0));
    local abs = math.abs(sin);

    return abs
end

local function hex(r, g, b, a)
    return string.format('\a%02X%02X%02X%02X', r, g, b, a or 255)
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

if login.build == 'User' then
    login.build = 'Live'
end

client.exec("clear")
client.color_log(255, 255, 255, "Welcome to\0")
client.color_log(lua_color.r, lua_color.g, lua_color.b, " interitus\0")
client.color_log(255, 255, 255, ", " .. userdata.username)

local lua = {}

lua.database = {
    configs = ":" .. lua_name .. "::configs:"
}

local presets = {}
-- @region USERDATA end

ffi.cdef [[
    typedef unsigned long dword;
    typedef unsigned int size_t;

    typedef struct {
        uint8_t r, g, b, a;
    } color_t;
]]

-- @region REFERENCES start
local refs = {
    legit = ui.reference("LEGIT", "Aimbot", "Enabled"),
    aimbot = ui.reference('RAGE', 'Aimbot', 'Enabled'),
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

    doubletap = {
        main = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
        fakelag_limit = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit')
    },
}
-- @region REFERENCES end

-- @region VARIABLES start
local vars = {
    localPlayer = 0,
    hitgroup_names = { 'Generic', 'Head', 'Chest', 'Stomach', 'Left arm', 'Right arm', 'Left leg', 'Right leg', 'Neck', '?', 'Gear' },
    aaStates = {"Global", "Standing", "Moving", "Slowwalking", "Crouch-Moving", "Crouching", "Air", "Air-Crouching", "Fake Duck"},
    pStates = {"G", "S", "M", "SW", "C", "A", "AC", "CM", "DPA"},
	sToInt = {["Global"] = 1, ["Standing"] = 2, ["Moving"] = 3, ["Slowwalking"] = 4, ["Crouch-Moving"] = 5, ["Crouching"] = 6, ["Air"] = 7, ["Air-Crouching"] = 8, ["Fake Duck"] = 9},
    intToS = {[1] = "Global", [2] = "Stand", [3] = "Move", [4] = "Slowwalk", [5] = "Crouch-Moving", [6] = "Crouch", [7] = "Air", [8] = "Air-Crouching", [9] = "Fake Duck"},
    currentTab = 1,
    activeState = 1,
    pState = 1,
    m1_time = 0,
    should_disable = false,
    defensive_until = 0,
    defensive_prev_sim = 0,
    fs = false,
    cmd,
    choke1 = 1,
    choke2 = 1,
    choke3 = 1,
    choke4 = 1,
    switch = false,
}

local kill = {"ｉｎｔｅｒｉｔｕｓ．ｒｅｄ に犯された",
"どうやって死ぬの？",
"извини если трахнул(",
"sukin sin",
"bismillah",
"hs tank or what",
"1",
"AAHSHAHAHHASHAHHAHAHAH",
"HOWWWW AHSHASHSAHASHAHSHASH 1111",
"11111111111",
"hurensohn",
"hinsetzen",
"umgerollt",
"ouch",
"you should rq",
"sorry for luck",
"legend player with legend script",
"bro what did you expect?",
"cya in void",
"извини если не можешь выиграть, я использую ｉｎｔｅｒｉｔｕｓ．ｒｅｄ",
"ｉｎｔｅｒｉｔｕｓ．ｒｅｄ",
"malo",
"свежий кабанчик",
"teleported you in hell",
"no luck its skill wym",
"penta boost" ,
"ты бомж взорванный легендой",
"ｉｎｔｅｒｉｔｕｓ．ｒｅｄ greatest lua of all time",
"не забустил",
"wym lucky" ,
"Теба сука родители били",
"free kill farm ty <3",
"legend",
"what did you even try botik",
"config issue",
"ｉｎｔｅｒｉｔｕｓ．ｒｅｄ скрипт легенд",
"hinsetzen du hund",
"жестко",
"в рот", 
"упал(",
"slabo bratka",
"нахуи в ебало" ,
"penta taught me" ,
"delight taught me" ,
"new tactic by me" ,
"you like being raped that hard?" ,
"ｉ??ｎｔｅｒｉｔｕｓ．ｒ?????????: за маму!" ,
"ｉｎｔｅｒ?ｉｔ??．ｒｅｄ: за папу!" ,
"ｉｎｔｅ??ｒｉｔｕｓ．ｒｅｄ: за дедушку пидорас жирный!" ,
"ｉｎ?ｔ?ｒｉｔ??．ｒｅｄ: ggez / == 9 90 == ))", 
"im using interitus no chances"
}

local js = panorama.open()
local MyPersonaAPI, LobbyAPI, PartyListAPI, SteamOverlayAPI = js.MyPersonaAPI, js.LobbyAPI, js.PartyListAPI, js.SteamOverlayAPI
-- @region VARIABLES end

-- @region FUNCS start
local function get_curtime(offset)
    return globals.curtime() - (offset * globals.tickinterval())
end
local func = {
    get_charge = function ()
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
    end,
    fclamp = function(x, min, max)
        return math.max(min, math.min(x, max));
    end,
    frgba = function(hex)
        hex = hex:gsub("#", "");
    
        local r = tonumber(hex:sub(1, 2), 16);
        local g = tonumber(hex:sub(3, 4), 16);
        local b = tonumber(hex:sub(5, 6), 16);
        local a = tonumber(hex:sub(7, 8), 16) or 255;
    
        return r, g, b, a;
    end,
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
    includes = function(tbl, value)
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
    end,    
    time_to_ticks = function(t)
        return math.floor(0.5 + (t / globals.tickinterval()))
    end,
    headVisible = function(enemy)
        local local_player = entity.get_local_player()
        if local_player == nil then return end
        local ex, ey, ez = entity.hitbox_position(enemy, 1)
    
        local hx, hy, hz = entity.hitbox_position(local_player, 1)
        local head_fraction, head_entindex_hit = client.trace_line(enemy, ex, ey, ez, hx, hy, hz)
        if head_entindex_hit == local_player or head_fraction == 1 then return true else return false end
    end,
    defensive = {
        cmd = 0,
        check = 0,
        defensive = 0,
    },
    aa_clamp = function(x) if x == nil then return 0 end x = (x % 360 + 360) % 360 return x > 180 and x - 360 or x end,
}

client.set_event_callback("run_command", function(e)
    func.defensive.cmd = e.command_number
end)
client.set_event_callback("predict_command", function(e)
    if e.command_number == func.defensive.cmd then
        local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
        func.defensive.defensive = math.abs(tickbase - func.defensive.check)
        func.defensive.check = math.max(tickbase, func.defensive.check or 0)
        func.defensive.cmd = 0
    end
end)
client.set_event_callback("level_init", function() func.defensive.check, func.defensive.defensive = 0, 0 end)

local clantag_anim = function(text, indices)
    local text_anim = "               " .. text ..                       "" 
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
        local phrase = kill[math.random(1, #kill)]
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
    local a_add = (165 - a)

    for i = 1, #string do
        local iter = (i - 1)/(#string - 1) + time
        t_out[t_out_iter] = "\a" .. func.RGBAtoHEX( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )

        t_out[t_out_iter + 1] = string:sub( i, i )

        t_out_iter = t_out_iter + 2
    end

    return t_out
end

local glow_module = function(x, y, w, h, width, rounding, accent, accent_inner)
    local thickness = 2
    local Offset = 1
    local r, g, b, a = unpack(accent)
    if accent_inner then
        func.rec(x, y, w, h + 1, rounding, accent_inner, 55, 55, 55)
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
-- 	http.get(string.format("", MyPersonaAPI.GetMyCountryCode()), function(success, response)
-- 		if not success or response.status ~= 200 then
-- 			print("couldnt fetch the flag image")
--             return
-- 		end

-- 		download = response.body
-- 	end)

    http.get("https://media.discordapp.net/attachments/882593635638599773/1162054826264367334/inter.png?ex=653a8ae4&is=652815e4&hm=336588458d286ec162d88b1d2e4779a308797116ec88d01e9fb89163e28925b2&=", function(success, response)
 		if not success or response.status ~= 200 then
 			print("couldnt fetch the logo image")
             return
 		end

		writefile("inter.png", response.body)
 	end)

     http.get("https://media.discordapp.net/attachments/1160538876612452475/1164098719118020708/255px-Transgender_Pride_flag.svg.png?ex=6541fa6a&is=652f856a&hm=fbb87ff4454dd4d91df57dd640f72dbe5c2fa7910669577c9c3dbb2f7bb8e573&=", function(success, response)
        if not success or response.status ~= 200 then
            print("couldnt fetch the logo image")
            return
        end

       writefile("trans.png", response.body)
    end)

     http.get(string.format("https://flagcdn.com/w160/%s.png", MyPersonaAPI.GetMyCountryCode():lower()), function(success, response)
		if not success or response.status ~= 200 then
			print("couldnt fetch the flag image")
            return
		end

		download = response.body
	end)
 end
 downloadFile()
-- @region FUNCS end

-- @region UI_LAYOUT start
local tab, container = "AA", "Anti-aimbot angles"
local converted_color_top_bar = "interitus renewed"
local final_text = "interitus renewed"
local ignore_brute_fix = false
local colored_label = ui.new_label('AA', 'Anti-aimbot angles', 'Interitus Renewed')
local masterSwitch = ui.new_checkbox(tab, container,'⚶ ' .. "Enable")
local tabPicker = ui.new_combobox(tab, container, "\nTab", "Anti-aim", "Visuals", "Misc", "Config")

handle_colorushka = function ()
    if not ui.is_menu_open() then
        return
    end

    local text = 'interitus Renewed'
    local length = #text + 1
    local light = ''
    local main_color = { 255, 115, 105, 255 }
    local back_color = { 100, 30, 30 }
    local anim_type = -1

    for idx = 1, length do
        local letter = text:sub(idx, idx)

        local factor = (idx - 1) / length
        local breathe = breathe(anim_type * factor * 1.5, 1.5)

        local r, g, b, a = lerp({ main_color[1], main_color[2], main_color[3], 255 }, { back_color[1], back_color[2], back_color[3], 255 }, breathe)

        local hex_color = hex(r, g, b, a)
        light = light .. (hex_color .. letter)
    end

    ui.set(colored_label, light)
end

client.set_event_callback("pre_render", function()
    handle_colorushka()
    --local final_text = gradient_text(255, 45, 21, 255, 32, 233, 76, 255, converted_color_top_bar, 1)
    --ui.set(masterSwitch, "› " .. final_text)
end)

local menu = {
    selections = ui.new_combobox(tab, container, "❖ Selection", "Builder/Presets", "Additional", "Anti-Brute", "Keybinds"),
    aaTab = {  

        tweaks = ui.new_multiselect(tab, container, "✧ Tweaks", "Desync On Shot", "Hideshots Fix", "Automatic Exploit Release", "Avoid Backstab", "Static On Knife"),
        desync_on_shot = ui.new_combobox(tab, container, "Desync On Shot Type", "Right", "Left", "Jitter", "Random"),
        --fixHideshots = ui.new_checkbox(tab, container, "Adjust fakelag limit"),
        --dtDischarge = ui.new_checkbox(tab, container, "Discharge Exploit"),
        --safeKnife = ui.new_checkbox(tab, container, "Safe Knife"),
        --BombEfix = ui.new_checkbox(tab, container, "Fix E Bombsite"), // {[0] = "Off"}
        avoidBackstab = ui.new_slider(tab, container, "Avoid Backstab", 5, 300, 0, true, "u", 1),
        --staticManuals = ui.new_checkbox(tab, container, "Static on manuals"),

        manualTab = {

            features = ui.new_multiselect(tab, container, "✧ Keybinds List", "Manual-AA", "Freestand", "Edge Yaw"),
            freestandstatic = ui.new_combobox(tab, container, "Freestand Type", "Normal", "Static", "Jitter"),
            freestand_jitterValue = ui.new_slider(tab, container, "Jitter Value", -70, 70, 0, true, "°", 1),
            freestandHotkey = ui.new_hotkey(tab, container, "Freestand"),
            freestandDisablers = ui.new_multiselect(tab, container, "Disable Freestand When", {"Air", "Slowmo", "Duck", "Manual"}),
            edgeYawHotkey = ui.new_hotkey(tab, container, "Edge Yaw"),
            static = ui.new_checkbox(tab, container, "Static Manuals"),
            manualLeft = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "left"),
            manualRight = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "right"),
            manualForward = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "forward"),
        },
    },

    bruteTab = {
        enable = ui.new_checkbox(tab, container, "Enable"),
        phases = ui.new_slider(tab, container, "Phases", 1, 5, 0, true, "s", 1, {[0] = "???"}),

        resetter = ui.new_multiselect(tab, container, func.hex({189, 49, 49}) .. "Reset" .. func.hex({200,200,200}) .. " A-Brute when", {"Reached Time Line", "Target Death", "Target Change"}),
        disablers = ui.new_multiselect(tab, container, func.hex({189, 49, 49}) .. "Disable" .. func.hex({200,200,200}) .. " A-Brute when", {"Air", "Air-Crouching", "Slowmo", "Duck", "Standing", "Moving"}),
        reset_time = ui.new_slider(tab, container, "Reset Time", 1, 15, 5, true, "s", 1),

        ignore_enable = ui.new_checkbox(tab, container, func.hex({185, 62, 237}) .. "Ignore ".. func.hex({200,200,200}) .. "A-Brute when not missed State"),
        Ignore_condition = ui.new_multiselect(tab, container, func.hex({185, 62, 237}) .. "Ignore" .. func.hex({200,200,200}) .. " A-Brute when", {"Air", "Air-Crouching", "Slowmo", "Duck", "Standing", "Moving"}),

        additions = ui.new_multiselect(tab, container, func.hex({158, 235, 52}) .. "Additions", {"Flip Side"}),
        addition_states = ui.new_multiselect(tab, container, func.hex({158, 235, 52}) .. "Additions" .. func.hex({200,200,200}) .. " A-Brute when", {"Air", "Air-Crouching", "Slowmo", "Duck", "Standing", "Moving"}),

        jitter1 = ui.new_slider(tab, container, func.hex({52,52,52}) .. "[" .. func.hex({2, 163, 74}) .. "1" .. func.hex({52,52,52}) .. "]" .. func.hex({232, 151, 0}) .. " Change Jitter for", -100, 100, 0, true, "%", 1),
        Desync1 = ui.new_slider(tab, container, func.hex({52,52,52}) .. "[" .. func.hex({2, 163, 74}) .. "1" .. func.hex({52,52,52}) .. "]" .. func.hex({232, 151, 0}) .. " Body Yaw Limit", -180, 180, 0, true, "", 1),
        _1 = ui.new_label(tab, container, "\n#1"),
        jitter2 = ui.new_slider(tab, container, func.hex({52,52,52}) .. "[" .. func.hex({1, 143, 39}) .. "2" .. func.hex({52,52,52}) .. "]" .. func.hex({232, 151, 0}) .. " Change Jitter for", -100, 100, 0, true, "%", 1),
        Desync2 = ui.new_slider(tab, container, func.hex({52,52,52}) .. "[" .. func.hex({1, 143, 39}) .. "2" .. func.hex({52,52,52}) .. "]" .. func.hex({232, 151, 0}) .. " Body Yaw Limit", -180, 180, 0, true, "", 1),
        _2 = ui.new_label(tab, container, "\n#2"),
        jitter3 = ui.new_slider(tab, container, func.hex({52,52,52}) .. "[" .. func.hex({2, 156, 71}) .. "3" .. func.hex({52,52,52}) .. "]" .. func.hex({232, 151, 0}) .. " Change Jitter for", -100, 100, 0, true, "%", 1),
        Desync3 = ui.new_slider(tab, container, func.hex({52,52,52}) .. "[" .. func.hex({2, 156, 71}) .. "3" .. func.hex({52,52,52}) .. "]" .. func.hex({232, 151, 0}) .. " Body Yaw Limit", -180, 180, 0, true, "", 1),
        _3 = ui.new_label(tab, container, "\n#3"),
        jitter4 = ui.new_slider(tab, container, func.hex({52,52,52}) .. "[" .. func.hex({2, 153, 103}) .. "4" .. func.hex({52,52,52}) .. "]" .. func.hex({232, 151, 0}) .. " Change Jitter for", -100, 100, 0, true, "%", 1),
        Desync4 = ui.new_slider(tab, container, func.hex({52,52,52}) .. "[" .. func.hex({2, 153, 103}) .. "4" .. func.hex({52,52,52}) .. "]" .. func.hex({232, 151, 0}) .. " Body Yaw Limit", -180, 180, 0, true, "", 1),
        _4 = ui.new_label(tab, container, "\n#4"),
        jitter5 = ui.new_slider(tab, container, func.hex({52,52,52}) .. "[" .. func.hex({2, 153, 130}) .. "5" .. func.hex({52,52,52}) .. "]" .. func.hex({232, 151, 0}) .. " Change Jitter for", -100, 100, 0, true, "%", 1),
        Desync5 = ui.new_slider(tab, container, func.hex({52,52,52}) .. "[" .. func.hex({2, 153, 130}) .. "5" .. func.hex({52,52,52}) .. "]" .. func.hex({232, 151, 0}) .. " Body Yaw Limit", -180, 180, 0, true, "", 1),

    },

    builderTab = {
        defensivestring1 = ui.new_label(tab, container, func.hex({255, 205, 117}) .. "\nTest2\n"),
        PresetComboBox = ui.new_combobox(tab, container, "⛬ Presets", "Disabled", "Delight"),
        defensivestring2 = ui.new_label(tab, container, func.hex({255, 205, 117}) .. "\ntest24\n"),
        state = ui.new_combobox(tab, container, "✥ Anti-aim state", vars.aaStates),
    },

    visualsTab = {
        -- indicators = ui.new_combobox(tab, container, "Indicators", "Disabled", "Soft", "Pixel"),
        -- indicatorsClr = ui.new_color_picker(tab, container, "Main Color", lua_color.r, lua_color.g, lua_color.b, 255),
        -- indicatorsStyle = ui.new_multiselect(tab, container, "\n Elements", "Name", "State", "Doubletap", "Hideshots", "Freestand", "Safepoint", "Body aim", "Fakeduck"),
        
        visuals = ui.new_multiselect(tab, container, "✧ Visuals", "Indicators", "Arrows", "Show Minimum Damage", "Logging"),

        indicator_label = ui.new_label(tab, container, "Indicator"),
        indicator_color = ui.new_color_picker(tab, container, "Indicator Color", lua_color.r, lua_color.g, lua_color.b, 255),
        
        watermark_type =  ui.new_combobox(tab, container, "Text type", "INTERITUS", "INTERITUS.RED", "Legacy", "Country", "Trans"),

        watermark_color = ui.new_color_picker(tab, container, "Watermark Color", lua_color.r, lua_color.g, lua_color.b, 255),
        watermark =  ui.new_combobox(tab, container, "Interitus Watermark", "Bottom", "Left"),

        arrowClrL = ui.new_label(tab, container, "Arrow"),
        arrowClr = ui.new_color_picker(tab, container, "Arrow Color", lua_color.r, lua_color.g, lua_color.b, 255),

        
        arrowIndicatorStyle = ui.new_combobox(tab, container, "\n arrows style", "~", "Teamskeet Static", "TeamSkeet Dynamic", "Modern"),
        

        logs = ui.new_multiselect(tab, container, "Logs", "Aimbot", "Anti-Aim"),
        logs_type =  ui.new_combobox(tab, container, "Logs type", "New", "Legacy"),
        logsClr = ui.new_color_picker(tab, container, "Logs Color", lua_color.r, lua_color.g, lua_color.b, 255),
        logOffset = ui.new_slider(tab, container, "Offset", 0, 500, 100, true, "px", 1)
    },
    miscTab = {
        tweaks = ui.new_multiselect(tab, container, "✧ Features", "Allow Unsafe Charge", "Clantag Spammer", "Trashtalk Spammer", "Fast Ladder", "Anim Breakers"),
        fastLadder = ui.new_multiselect(tab, container, "Fast Ladder", "Ascending", "Descending"),
        animations = ui.new_multiselect(tab, container, "Animation Breakers", "Static Legs In Air", "Moonwalk", "Zero Pitch On Land", "Leg Fucker", "Static Legs"),
    },
    configTab = {
        list = ui.new_listbox(tab, container, "Configs", ""),
        name = ui.new_textbox(tab, container, "Config name", ""),
        load = ui.new_button(tab, container, "⛓ Load", function() end),
        save = ui.new_button(tab, container, "⛊ Save", function() end),
        delete = ui.new_button(tab, container, "⛆ Delete", function() end),
        export = ui.new_button(tab, container, "⥳ Export", function() end),
        import = ui.new_button(tab, container, "⥴ Import", function() end)

    },
    
}


local aaBuilder = {}
local aaContainer = {}
for i=1, #vars.aaStates do
    aaContainer[i] = func.hex({200,200,200}) .. "(" .. func.hex({222,55,55}) .. "" .. vars.pStates[i] .. "" .. func.hex({200,200,200}) .. ")" .. func.hex({155,155,155}) .. " "
    aaBuilder[i] = {
        enableState = ui.new_checkbox(tab, container, func.hex({200,200,200}) .. "Enable " .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i]),
        padding_string = ui.new_label(tab, container, "\nPadding\n"),
        pitch = ui.new_combobox(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Pitch\n" .. aaContainer[i], "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
        pitchSlider = ui.new_slider(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "\nCustom Pitch" .. aaContainer[i], -89, 89, 0, true, "°", 1),
        yawBase = ui.new_combobox(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Yaw Base\n" .. aaContainer[i], "Local view", "At targets"),
        yaw = ui.new_combobox(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Yaw\n" .. aaContainer[i], "Off", "180", "Spin", "180 Z"),
        yawCondition = ui.new_combobox(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Yaw Mod\n" .. aaContainer[i], "Static", "L/R", "Slow", "Hold", "Sway"),
        yawStatic = ui.new_slider(tab, container, "\nyaw limit" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawLeft = ui.new_slider(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Yaw Add {L}\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawRight = ui.new_slider(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Yaw Add {R}\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawStep = ui.new_slider(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Yaw Step\nyaw" .. aaContainer[i], 1, 20, 6, 0),
        yawSpeed = ui.new_slider(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Yaw Temp\nyaw" .. aaContainer[i], 1, 15, 6, 0),
        yawJitter = ui.new_combobox(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Yaw Jitter\n" .. aaContainer[i], "Off", "Offset", "Center", "3-Way", "Random", "Yaw manipulation", "AI Jitter"),
        yawJitterDisablers = ui.new_multiselect(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Mod Extras\n" .. aaContainer[i], "Ensure Head Safety", "High Ground Safety", "AI Jitter On Lowground"),
        yawJitterCondition = ui.new_combobox(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Yaw Mod condition\n" .. aaContainer[i], "Static", "L/R"),
        yawJitterStatic = ui.new_slider(tab, container, "\nYaw Mod limit" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterLeft = ui.new_slider(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Yaw Add {L}\nYaw Mod" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterRight = ui.new_slider(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Yaw Add {R}\nYaw Mod" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        
        desync_type = ui.new_combobox(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Desync Type\n" .. aaContainer[i], "Interitus", "Skeet"),
        bodyYawAllowOverride = ui.new_checkbox(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Allow Override"),
        bodyYaw = ui.new_combobox(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Body Yaw\n" .. aaContainer[i], "Off", "Opposite", "Jitter", "Static", "Manipulative"),
        fsBodyYaw = ui.new_multiselect(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({200,200,200}) .. "Freestanding Body Yaw\n" .. aaContainer[i], "Always On", "When Unsafe", "When Lethal"),
        bodyYawSlider = ui.new_slider(tab, container, "\nbody yaw limit" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        fakeYawLimit = ui.new_slider(tab, container, "\ndesync limit" .. aaContainer[i], -82, 82, 0, true, "°", 1),

        defensivestring1 = ui.new_label(tab, container, "\nDefensive\n"),
        defensivestring = ui.new_label(tab, container, func.hex({255, 205, 117}) .. "➝ Defensive\n"),
        defensiveOpt = ui.new_multiselect(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({255, 205, 117}) .. "Defensive Triggers\n" .. aaContainer[i], "Always On", "Cycle Switch", "Delayed Switch"),
        defensiveExploits = ui.new_multiselect(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({255, 205, 117}) .. "Allowed Exploits\n" .. aaContainer[i], "Double Tap", "Hide Shots"),
        defensivedelaySlider = ui.new_slider(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" ..  func.hex({255, 205, 117}) .. "Delay\n" .. aaContainer[i], 5, 75, 0, true, "t", 1),
        defensiveSensivity = ui.new_slider(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" ..  func.hex({255, 205, 117}) .. "Sensivity\n" .. aaContainer[i], 26, 100, 0, true, "", 1),
        defensivePitch = ui.new_combobox(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" ..  func.hex({255, 205, 117}) .. "Defensive Pitch\n" .. aaContainer[i], "~", "Custom", "Jitter", "Sway"),
        defensivePitchSlider = ui.new_slider(tab, container, "\n" .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" ..  func.hex({255, 205, 117}) .. "\nDefensivePitchSlider" .. aaContainer[i], -89, 89, 0, true, "°", 1),  
        defensivePitchSlider2 = ui.new_slider(tab, container, "\n" .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" ..  func.hex({255, 205, 117}) .. "\nDefensivePitchSlider2" .. aaContainer[i], -89, 89, 0, true, "°", 1),  
        defensivePitchStep = ui.new_slider(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({255, 205, 117}) .. "Yaw Step\nyaw" .. aaContainer[i], 1, 30, 6, 0),
        defensiveYaw = ui.new_combobox(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" ..  func.hex({255, 205, 117}) .. "Defensive Yaw\n" .. aaContainer[i], "~", "Random", "Jitter", "L/R", "Spin", "Sway", "Custom"),
        defensiveYawSlider = ui.new_slider(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" ..  func.hex({255, 205, 117}) .. "\nDefensiveYawSlider" .. aaContainer[i], -180, 180, 0, true, "", 1),
        defensiveYawStep = ui.new_slider(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->" .. func.hex({255, 205, 117}) .. "Step\nyaw" .. aaContainer[i], 1, 30, 6, 0),
        defensiveYawLeft = ui.new_slider(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->"  ..  func.hex({255, 205, 117}) .. "Defensive Yaw Add {L}\n" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        defensiveYawRight = ui.new_slider(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({52,52,52}) .. "->"  ..  func.hex({255, 205, 117}) .. "Defensive Yaw Add {R}\n" .. aaContainer[i], -180, 180, 0, true, "°", 1),
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
local inspect = try_require('gamesense/inspect')
local function loadSettings(e)
    for key, value in pairs(vars.pStates) do
        for k, v in pairs(aaBuilder[key]) do
            if (e[value][k] ~= nil) then
                ui.set(v, e[value][k])
            end
        end 
    end
end
local alph = "base64"
local function importSettings()
    local frombuffer = clipboard.get()
    local decode = base64.decode(frombuffer, alph)
    local toTable = json.parse(decode)
    loadSettings(toTable.config)
end
local function importPreset()
    local frombuffer = "eyJpbmRleCI6MywiY29uZmlnIjp7Ik0iOnsiYm9keVlhd1NsaWRlciI6LTEyOCwiZGVzeW5jX3R5cGUiOiJTa2VldCIsImRlZmVuc2l2ZVlhd1JpZ2h0IjowLCJkZWZlbnNpdmVZYXdTdGVwIjo2LCJ5YXdTdGF0aWMiOjAsInlhd0xlZnQiOjI5LCJkZWZlbnNpdmVzdHJpbmcxIjoiIiwiZGVmZW5zaXZlUGl0Y2hTbGlkZXIiOjAsImVuYWJsZVN0YXRlIjp0cnVlLCJ5YXciOiIxODAiLCJkZWZlbnNpdmVZYXdMZWZ0IjowLCJ5YXdDb25kaXRpb24iOiJIb2xkIiwiZGVmZW5zaXZlWWF3U2xpZGVyIjowLCJmYWtlWWF3TGltaXQiOi0zNCwicGl0Y2giOiJEZWZhdWx0IiwicGl0Y2hTbGlkZXIiOjAsInlhd0ppdHRlckxlZnQiOjcsImJvZHlZYXciOiJKaXR0ZXIiLCJkZWZlbnNpdmVQaXRjaCI6In4iLCJ5YXdCYXNlIjoiQXQgdGFyZ2V0cyIsInlhd1N0ZXAiOjYsImRlZmVuc2l2ZXN0cmluZyI6Ilx1MDAwN0ZGQ0Q3NUZG4p6dIERlZmVuc2l2ZVxuIiwiZGVmZW5zaXZlWWF3IjoifiIsImJvZHlZYXdBbGxvd092ZXJyaWRlIjpmYWxzZSwieWF3Sml0dGVyUmlnaHQiOi00LCJkZWZlbnNpdmVkZWxheVNsaWRlciI6NSwieWF3U3BlZWQiOjIsImRlZmVuc2l2ZU9wdCI6e30sInlhd0ppdHRlclN0YXRpYyI6NDcsInlhd0ppdHRlciI6IllhdyBtYW5pcHVsYXRpb24iLCJkZWZlbnNpdmVQaXRjaFNsaWRlcjIiOjAsInBhZGRpbmdfc3RyaW5nIjoiIiwiZGVmZW5zaXZlUGl0Y2hTdGVwIjo2LCJ5YXdKaXR0ZXJDb25kaXRpb24iOiJMXC9SIiwieWF3Sml0dGVyRGlzYWJsZXJzIjpbIkhpZ2ggR3JvdW5kIFNhZmV0eSJdLCJ5YXdSaWdodCI6LTE5fSwiU1ciOnsiYm9keVlhd1NsaWRlciI6LTE1NiwiZGVzeW5jX3R5cGUiOiJTa2VldCIsImRlZmVuc2l2ZVlhd1JpZ2h0IjowLCJkZWZlbnNpdmVZYXdTdGVwIjo2LCJ5YXdTdGF0aWMiOjAsInlhd0xlZnQiOjI0LCJkZWZlbnNpdmVzdHJpbmcxIjoiIiwiZGVmZW5zaXZlUGl0Y2hTbGlkZXIiOjAsImVuYWJsZVN0YXRlIjp0cnVlLCJ5YXciOiIxODAiLCJkZWZlbnNpdmVZYXdMZWZ0IjowLCJ5YXdDb25kaXRpb24iOiJIb2xkIiwiZGVmZW5zaXZlWWF3U2xpZGVyIjowLCJmYWtlWWF3TGltaXQiOjU5LCJwaXRjaCI6IkRlZmF1bHQiLCJwaXRjaFNsaWRlciI6MCwieWF3Sml0dGVyTGVmdCI6NiwiYm9keVlhdyI6Ik9mZiIsImRlZmVuc2l2ZVBpdGNoIjoifiIsInlhd0Jhc2UiOiJBdCB0YXJnZXRzIiwieWF3U3RlcCI6NiwiZGVmZW5zaXZlc3RyaW5nIjoiXHUwMDA3RkZDRDc1Rkbinp0gRGVmZW5zaXZlXG4iLCJkZWZlbnNpdmVZYXciOiJ+IiwiYm9keVlhd0FsbG93T3ZlcnJpZGUiOmZhbHNlLCJ5YXdKaXR0ZXJSaWdodCI6MiwiZGVmZW5zaXZlZGVsYXlTbGlkZXIiOjUsInlhd1NwZWVkIjo2LCJkZWZlbnNpdmVPcHQiOnt9LCJ5YXdKaXR0ZXJTdGF0aWMiOjAsInlhd0ppdHRlciI6IllhdyBtYW5pcHVsYXRpb24iLCJkZWZlbnNpdmVQaXRjaFNsaWRlcjIiOjAsInBhZGRpbmdfc3RyaW5nIjoiIiwiZGVmZW5zaXZlUGl0Y2hTdGVwIjo2LCJ5YXdKaXR0ZXJDb25kaXRpb24iOiJMXC9SIiwieWF3Sml0dGVyRGlzYWJsZXJzIjpbIkhpZ2ggR3JvdW5kIFNhZmV0eSJdLCJ5YXdSaWdodCI6LTIyfSwiUyI6eyJib2R5WWF3U2xpZGVyIjotMTM5LCJkZXN5bmNfdHlwZSI6IlNrZWV0IiwiZGVmZW5zaXZlWWF3UmlnaHQiOjAsImRlZmVuc2l2ZVlhd1N0ZXAiOjYsInlhd1N0YXRpYyI6MCwieWF3TGVmdCI6LTgsImRlZmVuc2l2ZXN0cmluZzEiOiIiLCJkZWZlbnNpdmVQaXRjaFNsaWRlciI6MCwiZW5hYmxlU3RhdGUiOnRydWUsInlhdyI6IjE4MCIsImRlZmVuc2l2ZVlhd0xlZnQiOjAsInlhd0NvbmRpdGlvbiI6IkxcL1IiLCJkZWZlbnNpdmVZYXdTbGlkZXIiOjAsImZha2VZYXdMaW1pdCI6LTgsInBpdGNoIjoiRGVmYXVsdCIsInBpdGNoU2xpZGVyIjowLCJ5YXdKaXR0ZXJMZWZ0IjoyNCwiYm9keVlhdyI6IkppdHRlciIsImRlZmVuc2l2ZVBpdGNoIjoifiIsInlhd0Jhc2UiOiJBdCB0YXJnZXRzIiwieWF3U3RlcCI6NiwiZGVmZW5zaXZlc3RyaW5nIjoiXHUwMDA3RkZDRDc1Rkbinp0gRGVmZW5zaXZlXG4iLCJkZWZlbnNpdmVZYXciOiJ+IiwiYm9keVlhd0FsbG93T3ZlcnJpZGUiOmZhbHNlLCJ5YXdKaXR0ZXJSaWdodCI6MTcsImRlZmVuc2l2ZWRlbGF5U2xpZGVyIjo1LCJ5YXdTcGVlZCI6NywiZGVmZW5zaXZlT3B0Ijp7fSwieWF3Sml0dGVyU3RhdGljIjowLCJ5YXdKaXR0ZXIiOiJDZW50ZXIiLCJkZWZlbnNpdmVQaXRjaFNsaWRlcjIiOjAsInBhZGRpbmdfc3RyaW5nIjoiIiwiZGVmZW5zaXZlUGl0Y2hTdGVwIjo2LCJ5YXdKaXR0ZXJDb25kaXRpb24iOiJMXC9SIiwieWF3Sml0dGVyRGlzYWJsZXJzIjpbIkVuc3VyZSBIZWFkIFNhZmV0eSIsIkhpZ2ggR3JvdW5kIFNhZmV0eSJdLCJ5YXdSaWdodCI6MTB9LCJBQyI6eyJib2R5WWF3U2xpZGVyIjowLCJkZXN5bmNfdHlwZSI6IlNrZWV0IiwiZGVmZW5zaXZlWWF3UmlnaHQiOjAsImRlZmVuc2l2ZVlhd1N0ZXAiOjYsInlhd1N0YXRpYyI6MCwieWF3TGVmdCI6MjYsImRlZmVuc2l2ZXN0cmluZzEiOiIiLCJkZWZlbnNpdmVQaXRjaFNsaWRlciI6MCwiZW5hYmxlU3RhdGUiOnRydWUsInlhdyI6IjE4MCIsImRlZmVuc2l2ZVlhd0xlZnQiOjAsInlhd0NvbmRpdGlvbiI6IkhvbGQiLCJkZWZlbnNpdmVZYXdTbGlkZXIiOjAsImZha2VZYXdMaW1pdCI6NTksInBpdGNoIjoiRGVmYXVsdCIsInBpdGNoU2xpZGVyIjowLCJ5YXdKaXR0ZXJMZWZ0IjoxLCJib2R5WWF3IjoiSml0dGVyIiwiZGVmZW5zaXZlUGl0Y2giOiJ+IiwieWF3QmFzZSI6IkF0IHRhcmdldHMiLCJ5YXdTdGVwIjo2LCJkZWZlbnNpdmVzdHJpbmciOiJcdTAwMDdGRkNENzVGRuKenSBEZWZlbnNpdmVcbiIsImRlZmVuc2l2ZVlhdyI6In4iLCJib2R5WWF3QWxsb3dPdmVycmlkZSI6ZmFsc2UsInlhd0ppdHRlclJpZ2h0IjozLCJkZWZlbnNpdmVkZWxheVNsaWRlciI6NSwieWF3U3BlZWQiOjYsImRlZmVuc2l2ZU9wdCI6e30sInlhd0ppdHRlclN0YXRpYyI6MCwieWF3Sml0dGVyIjoiWWF3IG1hbmlwdWxhdGlvbiIsImRlZmVuc2l2ZVBpdGNoU2xpZGVyMiI6MCwicGFkZGluZ19zdHJpbmciOiIiLCJkZWZlbnNpdmVQaXRjaFN0ZXAiOjYsInlhd0ppdHRlckNvbmRpdGlvbiI6IkxcL1IiLCJ5YXdKaXR0ZXJEaXNhYmxlcnMiOnt9LCJ5YXdSaWdodCI6LTE1fSwiQSI6eyJib2R5WWF3U2xpZGVyIjowLCJkZXN5bmNfdHlwZSI6IlNrZWV0IiwiZGVmZW5zaXZlWWF3UmlnaHQiOjAsImRlZmVuc2l2ZVlhd1N0ZXAiOjYsInlhd1N0YXRpYyI6OCwieWF3TGVmdCI6MzEsImRlZmVuc2l2ZXN0cmluZzEiOiIiLCJkZWZlbnNpdmVQaXRjaFNsaWRlciI6MCwiZW5hYmxlU3RhdGUiOnRydWUsInlhdyI6IjE4MCIsImRlZmVuc2l2ZVlhd0xlZnQiOjAsInlhd0NvbmRpdGlvbiI6IkhvbGQiLCJkZWZlbnNpdmVZYXdTbGlkZXIiOjAsImZha2VZYXdMaW1pdCI6NTksInBpdGNoIjoiRGVmYXVsdCIsInBpdGNoU2xpZGVyIjowLCJ5YXdKaXR0ZXJMZWZ0IjozLCJib2R5WWF3IjoiT2ZmIiwiZGVmZW5zaXZlUGl0Y2giOiJ+IiwieWF3QmFzZSI6IkF0IHRhcmdldHMiLCJ5YXdTdGVwIjo2LCJkZWZlbnNpdmVzdHJpbmciOiJcdTAwMDdGRkNENzVGRuKenSBEZWZlbnNpdmVcbiIsImRlZmVuc2l2ZVlhdyI6In4iLCJib2R5WWF3QWxsb3dPdmVycmlkZSI6ZmFsc2UsInlhd0ppdHRlclJpZ2h0IjotMSwiZGVmZW5zaXZlZGVsYXlTbGlkZXIiOjUsInlhd1NwZWVkIjo2LCJkZWZlbnNpdmVPcHQiOnt9LCJ5YXdKaXR0ZXJTdGF0aWMiOjAsInlhd0ppdHRlciI6IllhdyBtYW5pcHVsYXRpb24iLCJkZWZlbnNpdmVQaXRjaFNsaWRlcjIiOjAsInBhZGRpbmdfc3RyaW5nIjoiIiwiZGVmZW5zaXZlUGl0Y2hTdGVwIjo2LCJ5YXdKaXR0ZXJDb25kaXRpb24iOiJMXC9SIiwieWF3Sml0dGVyRGlzYWJsZXJzIjp7fSwieWF3UmlnaHQiOi0xMn0sIkNNIjp7ImJvZHlZYXdTbGlkZXIiOjAsImRlc3luY190eXBlIjoiU2tlZXQiLCJkZWZlbnNpdmVZYXdSaWdodCI6MCwiZGVmZW5zaXZlWWF3U3RlcCI6NiwieWF3U3RhdGljIjowLCJ5YXdMZWZ0IjozOCwiZGVmZW5zaXZlc3RyaW5nMSI6IiIsImRlZmVuc2l2ZVBpdGNoU2xpZGVyIjowLCJlbmFibGVTdGF0ZSI6dHJ1ZSwieWF3IjoiMTgwIiwiZGVmZW5zaXZlWWF3TGVmdCI6MCwieWF3Q29uZGl0aW9uIjoiSG9sZCIsImRlZmVuc2l2ZVlhd1NsaWRlciI6MCwiZmFrZVlhd0xpbWl0Ijo0NiwicGl0Y2giOiJEZWZhdWx0IiwicGl0Y2hTbGlkZXIiOjAsInlhd0ppdHRlckxlZnQiOi0zLCJib2R5WWF3IjoiT2ZmIiwiZGVmZW5zaXZlUGl0Y2giOiJ+IiwieWF3QmFzZSI6IkF0IHRhcmdldHMiLCJ5YXdTdGVwIjo2LCJkZWZlbnNpdmVzdHJpbmciOiJcdTAwMDdGRkNENzVGRuKenSBEZWZlbnNpdmVcbiIsImRlZmVuc2l2ZVlhdyI6In4iLCJib2R5WWF3QWxsb3dPdmVycmlkZSI6ZmFsc2UsInlhd0ppdHRlclJpZ2h0Ijo1LCJkZWZlbnNpdmVkZWxheVNsaWRlciI6NSwieWF3U3BlZWQiOjYsImRlZmVuc2l2ZU9wdCI6e30sInlhd0ppdHRlclN0YXRpYyI6MCwieWF3Sml0dGVyIjoiWWF3IG1hbmlwdWxhdGlvbiIsImRlZmVuc2l2ZVBpdGNoU2xpZGVyMiI6MCwicGFkZGluZ19zdHJpbmciOiIiLCJkZWZlbnNpdmVQaXRjaFN0ZXAiOjYsInlhd0ppdHRlckNvbmRpdGlvbiI6IkxcL1IiLCJ5YXdKaXR0ZXJEaXNhYmxlcnMiOlsiSGlnaCBHcm91bmQgU2FmZXR5Il0sInlhd1JpZ2h0IjotMTJ9LCJDIjp7ImJvZHlZYXdTbGlkZXIiOi0xLCJkZXN5bmNfdHlwZSI6IlNrZWV0IiwiZGVmZW5zaXZlWWF3UmlnaHQiOjAsImRlZmVuc2l2ZVlhd1N0ZXAiOjYsInlhd1N0YXRpYyI6MCwieWF3TGVmdCI6MjYsImRlZmVuc2l2ZXN0cmluZzEiOiIiLCJkZWZlbnNpdmVQaXRjaFNsaWRlciI6MCwiZW5hYmxlU3RhdGUiOnRydWUsInlhdyI6IjE4MCIsImRlZmVuc2l2ZVlhd0xlZnQiOjAsInlhd0NvbmRpdGlvbiI6IkhvbGQiLCJkZWZlbnNpdmVZYXdTbGlkZXIiOjAsImZha2VZYXdMaW1pdCI6NTksInBpdGNoIjoiRGVmYXVsdCIsInBpdGNoU2xpZGVyIjowLCJ5YXdKaXR0ZXJMZWZ0Ijo4LCJib2R5WWF3IjoiSml0dGVyIiwiZGVmZW5zaXZlUGl0Y2giOiJ+IiwieWF3QmFzZSI6IkF0IHRhcmdldHMiLCJ5YXdTdGVwIjo2LCJkZWZlbnNpdmVzdHJpbmciOiJcdTAwMDdGRkNENzVGRuKenSBEZWZlbnNpdmVcbiIsImRlZmVuc2l2ZVlhdyI6In4iLCJib2R5WWF3QWxsb3dPdmVycmlkZSI6ZmFsc2UsInlhd0ppdHRlclJpZ2h0IjozLCJkZWZlbnNpdmVkZWxheVNsaWRlciI6NSwieWF3U3BlZWQiOjgsImRlZmVuc2l2ZU9wdCI6e30sInlhd0ppdHRlclN0YXRpYyI6MCwieWF3Sml0dGVyIjoiWWF3IG1hbmlwdWxhdGlvbiIsImRlZmVuc2l2ZVBpdGNoU2xpZGVyMiI6MCwicGFkZGluZ19zdHJpbmciOiIiLCJkZWZlbnNpdmVQaXRjaFN0ZXAiOjYsInlhd0ppdHRlckNvbmRpdGlvbiI6IkxcL1IiLCJ5YXdKaXR0ZXJEaXNhYmxlcnMiOnt9LCJ5YXdSaWdodCI6LTEwfSwiRyI6eyJib2R5WWF3U2xpZGVyIjowLCJkZXN5bmNfdHlwZSI6IkludGVyaXR1cyIsImRlZmVuc2l2ZVlhd1JpZ2h0IjowLCJkZWZlbnNpdmVZYXdTdGVwIjo2LCJ5YXdTdGF0aWMiOjAsInlhd0xlZnQiOjAsImRlZmVuc2l2ZXN0cmluZzEiOiIiLCJkZWZlbnNpdmVQaXRjaFNsaWRlciI6MCwiZW5hYmxlU3RhdGUiOnRydWUsInlhdyI6Ik9mZiIsImRlZmVuc2l2ZVlhd0xlZnQiOjAsInlhd0NvbmRpdGlvbiI6IlN0YXRpYyIsImRlZmVuc2l2ZVlhd1NsaWRlciI6MCwiZmFrZVlhd0xpbWl0IjowLCJwaXRjaCI6Ik9mZiIsInBpdGNoU2xpZGVyIjowLCJ5YXdKaXR0ZXJMZWZ0IjowLCJib2R5WWF3IjoiT2ZmIiwiZGVmZW5zaXZlUGl0Y2giOiJ+IiwieWF3QmFzZSI6IkxvY2FsIHZpZXciLCJ5YXdTdGVwIjo2LCJkZWZlbnNpdmVzdHJpbmciOiJcdTAwMDdGRkNENzVGRuKenSBEZWZlbnNpdmVcbiIsImRlZmVuc2l2ZVlhdyI6In4iLCJib2R5WWF3QWxsb3dPdmVycmlkZSI6ZmFsc2UsInlhd0ppdHRlclJpZ2h0IjowLCJkZWZlbnNpdmVkZWxheVNsaWRlciI6NSwieWF3U3BlZWQiOjYsImRlZmVuc2l2ZU9wdCI6e30sInlhd0ppdHRlclN0YXRpYyI6MCwieWF3Sml0dGVyIjoiT2ZmIiwiZGVmZW5zaXZlUGl0Y2hTbGlkZXIyIjowLCJwYWRkaW5nX3N0cmluZyI6IiIsImRlZmVuc2l2ZVBpdGNoU3RlcCI6NiwieWF3Sml0dGVyQ29uZGl0aW9uIjoiU3RhdGljIiwieWF3Sml0dGVyRGlzYWJsZXJzIjp7fSwieWF3UmlnaHQiOjB9fX0="
    local decode = base64.decode(frombuffer, alph)
    local toTable = json.parse(decode)
    loadSettings(toTable.config)
end
local function importPresetClear()
    local frombuffer = "eyJpbmRleCI6MSwiY29uZmlnIjp7IkxBIjp7InBpdGNoIjoiT2ZmIiwicGl0Y2hTbGlkZXIiOjAsImJvZHlZYXdTbGlkZXIiOjAsInlhd0ppdHRlckxlZnQiOjAsInlhd1N0YXRpYyI6MCwiYm9keVlhdyI6Ik9mZiIsImVuYWJsZVN0YXRlIjpmYWxzZSwiZm9yY2VEZWZlbnNpdmUiOmZhbHNlLCJzd2l0Y2hUaWNrcyI6MywieWF3IjoiT2ZmIiwieWF3QmFzZSI6IkxvY2FsIHZpZXciLCJ5YXdMZWZ0IjowLCJ5YXdKaXR0ZXIiOiJPZmYiLCJ5YXdKaXR0ZXJDb25kaXRpb24iOiJTdGF0aWMiLCJ5YXdKaXR0ZXJTdGF0aWMiOjAsInlhd0NvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlclJpZ2h0IjowLCJ5YXdKaXR0ZXJEaXNhYmxlcnMiOnt9LCJ5YXdSaWdodCI6MH0sIlMiOnsicGl0Y2giOiJEZWZhdWx0IiwicGl0Y2hTbGlkZXIiOjAsImJvZHlZYXdTbGlkZXIiOi0xLCJ5YXdKaXR0ZXJMZWZ0IjowLCJ5YXdTdGF0aWMiOjAsImJvZHlZYXciOiJKaXR0ZXIiLCJlbmFibGVTdGF0ZSI6dHJ1ZSwiZm9yY2VEZWZlbnNpdmUiOmZhbHNlLCJzd2l0Y2hUaWNrcyI6MywieWF3IjoiMTgwIiwieWF3QmFzZSI6IkF0IHRhcmdldHMiLCJ5YXdMZWZ0IjotMjMsInlhd0ppdHRlciI6Ik9mZiIsInlhd0ppdHRlckNvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlclN0YXRpYyI6MCwieWF3Q29uZGl0aW9uIjoiTCAmIFIiLCJ5YXdKaXR0ZXJSaWdodCI6MCwieWF3Sml0dGVyRGlzYWJsZXJzIjp7fSwieWF3UmlnaHQiOjQyfSwiQSI6eyJwaXRjaCI6IkRlZmF1bHQiLCJwaXRjaFNsaWRlciI6MCwiYm9keVlhd1NsaWRlciI6LTEsInlhd0ppdHRlckxlZnQiOjAsInlhd1N0YXRpYyI6MCwiYm9keVlhdyI6IkppdHRlciIsImVuYWJsZVN0YXRlIjp0cnVlLCJmb3JjZURlZmVuc2l2ZSI6dHJ1ZSwic3dpdGNoVGlja3MiOjMsInlhdyI6IjE4MCIsInlhd0Jhc2UiOiJBdCB0YXJnZXRzIiwieWF3TGVmdCI6LTMzLCJ5YXdKaXR0ZXIiOiJPZmYiLCJ5YXdKaXR0ZXJDb25kaXRpb24iOiJTdGF0aWMiLCJ5YXdKaXR0ZXJTdGF0aWMiOjAsInlhd0NvbmRpdGlvbiI6IkwgJiBSIiwieWF3Sml0dGVyUmlnaHQiOjAsInlhd0ppdHRlckRpc2FibGVycyI6e30sInlhd1JpZ2h0IjozOH0sIlNXIjp7InBpdGNoIjoiT2ZmIiwicGl0Y2hTbGlkZXIiOjAsImJvZHlZYXdTbGlkZXIiOjAsInlhd0ppdHRlckxlZnQiOjAsInlhd1N0YXRpYyI6MCwiYm9keVlhdyI6Ik9mZiIsImVuYWJsZVN0YXRlIjpmYWxzZSwiZm9yY2VEZWZlbnNpdmUiOmZhbHNlLCJzd2l0Y2hUaWNrcyI6MywieWF3IjoiT2ZmIiwieWF3QmFzZSI6IkxvY2FsIHZpZXciLCJ5YXdMZWZ0IjowLCJ5YXdKaXR0ZXIiOiJPZmYiLCJ5YXdKaXR0ZXJDb25kaXRpb24iOiJTdGF0aWMiLCJ5YXdKaXR0ZXJTdGF0aWMiOjAsInlhd0NvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlclJpZ2h0IjowLCJ5YXdKaXR0ZXJEaXNhYmxlcnMiOnt9LCJ5YXdSaWdodCI6MH0sIk0iOnsicGl0Y2giOiJEZWZhdWx0IiwicGl0Y2hTbGlkZXIiOjAsImJvZHlZYXdTbGlkZXIiOi0xLCJ5YXdKaXR0ZXJMZWZ0IjowLCJ5YXdTdGF0aWMiOjAsImJvZHlZYXciOiJKaXR0ZXIiLCJlbmFibGVTdGF0ZSI6dHJ1ZSwiZm9yY2VEZWZlbnNpdmUiOmZhbHNlLCJzd2l0Y2hUaWNrcyI6MywieWF3IjoiMTgwIiwieWF3QmFzZSI6IkF0IHRhcmdldHMiLCJ5YXdMZWZ0IjotMjksInlhd0ppdHRlciI6Ik9mZiIsInlhd0ppdHRlckNvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlclN0YXRpYyI6MCwieWF3Q29uZGl0aW9uIjoiTCAmIFIiLCJ5YXdKaXR0ZXJSaWdodCI6MCwieWF3Sml0dGVyRGlzYWJsZXJzIjp7fSwieWF3UmlnaHQiOjM3fSwiREVGIjp7InBpdGNoIjoiT2ZmIiwicGl0Y2hTbGlkZXIiOjAsImJvZHlZYXdTbGlkZXIiOjAsInlhd0ppdHRlckxlZnQiOjAsInlhd1N0YXRpYyI6MCwiYm9keVlhdyI6Ik9mZiIsImVuYWJsZVN0YXRlIjpmYWxzZSwiZm9yY2VEZWZlbnNpdmUiOmZhbHNlLCJzd2l0Y2hUaWNrcyI6MywieWF3IjoiT2ZmIiwieWF3QmFzZSI6IkxvY2FsIHZpZXciLCJ5YXdMZWZ0IjowLCJ5YXdKaXR0ZXIiOiJPZmYiLCJ5YXdKaXR0ZXJDb25kaXRpb24iOiJTdGF0aWMiLCJ5YXdKaXR0ZXJTdGF0aWMiOjAsInlhd0NvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlclJpZ2h0IjowLCJ5YXdKaXR0ZXJEaXNhYmxlcnMiOnt9LCJ5YXdSaWdodCI6MH0sIkFDIjp7InBpdGNoIjoiRGVmYXVsdCIsInBpdGNoU2xpZGVyIjowLCJib2R5WWF3U2xpZGVyIjotMSwieWF3Sml0dGVyTGVmdCI6MCwieWF3U3RhdGljIjowLCJib2R5WWF3IjoiSml0dGVyIiwiZW5hYmxlU3RhdGUiOnRydWUsImZvcmNlRGVmZW5zaXZlIjp0cnVlLCJzd2l0Y2hUaWNrcyI6MywieWF3IjoiMTgwIiwieWF3QmFzZSI6IkF0IHRhcmdldHMiLCJ5YXdMZWZ0IjotMTYsInlhd0ppdHRlciI6Ik9mZiIsInlhd0ppdHRlckNvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlclN0YXRpYyI6MCwieWF3Q29uZGl0aW9uIjoiTCAmIFIiLCJ5YXdKaXR0ZXJSaWdodCI6MCwieWF3Sml0dGVyRGlzYWJsZXJzIjp7fSwieWF3UmlnaHQiOjM4fSwiQyI6eyJwaXRjaCI6IkRlZmF1bHQiLCJwaXRjaFNsaWRlciI6MCwiYm9keVlhd1NsaWRlciI6LTEsInlhd0ppdHRlckxlZnQiOjAsInlhd1N0YXRpYyI6MCwiYm9keVlhdyI6IkppdHRlciIsImVuYWJsZVN0YXRlIjp0cnVlLCJmb3JjZURlZmVuc2l2ZSI6ZmFsc2UsInN3aXRjaFRpY2tzIjozLCJ5YXciOiIxODAiLCJ5YXdCYXNlIjoiQXQgdGFyZ2V0cyIsInlhd0xlZnQiOi0zOCwieWF3Sml0dGVyIjoiT2ZmIiwieWF3Sml0dGVyQ29uZGl0aW9uIjoiU3RhdGljIiwieWF3Sml0dGVyU3RhdGljIjowLCJ5YXdDb25kaXRpb24iOiJMICYgUiIsInlhd0ppdHRlclJpZ2h0IjowLCJ5YXdKaXR0ZXJEaXNhYmxlcnMiOnt9LCJ5YXdSaWdodCI6NTF9LCJHIjp7InBpdGNoIjoiRGVmYXVsdCIsInBpdGNoU2xpZGVyIjowLCJib2R5WWF3U2xpZGVyIjotMSwieWF3Sml0dGVyTGVmdCI6MCwieWF3U3RhdGljIjowLCJib2R5WWF3IjoiSml0dGVyIiwiZW5hYmxlU3RhdGUiOnRydWUsImZvcmNlRGVmZW5zaXZlIjpmYWxzZSwic3dpdGNoVGlja3MiOjMsInlhdyI6IjE4MCIsInlhd0Jhc2UiOiJBdCB0YXJnZXRzIiwieWF3TGVmdCI6LTQxLCJ5YXdKaXR0ZXIiOiJPZmYiLCJ5YXdKaXR0ZXJDb25kaXRpb24iOiJTdGF0aWMiLCJ5YXdKaXR0ZXJTdGF0aWMiOjAsInlhd0NvbmRpdGlvbiI6IkwgJiBSIiwieWF3Sml0dGVyUmlnaHQiOjAsInlhd0ppdHRlckRpc2FibGVycyI6e30sInlhd1JpZ2h0IjozOX19fQ==="
    local decode = base64.decode(frombuffer, alph)
    local toTable = json.parse(decode)
    loadSettings(toTable.config)
end
local function exportSettings(name)
    local config = getConfig(name)
    local toString = json.stringify(config)
    local toExport = base64.encode(toString, alph)
    clipboard.set(toExport)
end
local function loadConfig(name)
    local config = getConfig(name)
    loadSettings(config.config)
end

local function initDatabase()
    if database.read(lua.database.configs) == nil then
        database.write(lua.database.configs, {})
    end

    local link = "https://pastebin.com/raw/afg2YkEv"

    http.get(link, function(success, response)
        if not success then
            print("Failed to get presets")
            return
        end
    
        local data = json.parse(response.body)
    
        for i, preset in pairs(data.presets) do
            table.insert(presets, { name = "*"..preset.name, config = preset.config})
            ui.set(menu.configTab.name, "*"..preset.name)
        end
        ui.update(menu.configTab.list, getConfigList())
    end)
end
initDatabase()
-- @region UI_LAYOUT end

function detectChange(initialValue, currentValue)
    if initialValue ~= currentValue then
        return true
    else
        return false
    end
end
-- Function to perform swaying motion

function fix_color(r, g, b, a)

    if r < 0 then
        
    end

end

local currentValue = 0
local direction = -1
function updateValue(IS_FOR_DEFENSIVE)

    if IS_FOR_DEFENSIVE then
    local minValue2 = ui.get(aaBuilder[vars.pState].defensiveYawLeft)
    local maxValue2 = ui.get(aaBuilder[vars.pState].defensiveYawRight)
    local step2 = ui.get(aaBuilder[vars.pState].defensiveYawStep)

    if detectChange(minValue, minValue2) or detectChange(maxValue, maxValue2) or detectChange(step, step2) then
        minValue = ui.get(aaBuilder[vars.pState].defensiveYawLeft)
        maxValue = ui.get(aaBuilder[vars.pState].defensiveYawRight)
        step = ui.get(aaBuilder[vars.pState].defensiveYawStep)
        currentValue = minValue
    end

    currentValue = currentValue + direction * step

    -- Check if we reached the maximum or minimum value
    if currentValue > maxValue then
        currentValue = maxValue
        direction = -1  -- Change direction to decrement
    elseif currentValue < minValue then
        currentValue = minValue
        direction = 1   -- Change direction to increment
    end
else
    local minValue2 = ui.get(aaBuilder[vars.pState].yawLeft)
    local maxValue2 = ui.get(aaBuilder[vars.pState].yawRight)
    local step2 = ui.get(aaBuilder[vars.pState].yawStep)

    if detectChange(minValue, minValue2) or detectChange(maxValue, maxValue2) or detectChange(step, step2) then
        minValue = ui.get(aaBuilder[vars.pState].yawLeft)
        maxValue = ui.get(aaBuilder[vars.pState].yawRight)
        step = ui.get(aaBuilder[vars.pState].yawStep)
        currentValue = minValue
    end

    currentValue = currentValue + direction * step

    -- Check if we reached the maximum or minimum value
    if currentValue > maxValue then
        currentValue = maxValue
        direction = -1  -- Change direction to decrement
    elseif currentValue < minValue then
        currentValue = minValue
        direction = 1   -- Change direction to increment
    end
end
end

local currentValue2 = 0
local direction2 = -1
function updateValue_pitch()

    local minValue2 = ui.get(aaBuilder[vars.pState].defensivePitchSlider)
    local maxValue2 = ui.get(aaBuilder[vars.pState].defensivePitchSlider2)
    local step2 = ui.get(aaBuilder[vars.pState].defensivePitchStep)

    if detectChange(minValue, minValue2) or detectChange(maxValue, maxValue2) or detectChange(step, step2) then
        minValue = ui.get(aaBuilder[vars.pState].defensivePitchSlider)
        maxValue = ui.get(aaBuilder[vars.pState].defensivePitchSlider2)
        step = ui.get(aaBuilder[vars.pState].defensivePitchStep)
        currentValue2 = minValue
    end

    currentValue2 = currentValue2 + direction2 * step

    -- Check if we reached the maximum or minimum value
    if currentValue2 > maxValue then
        currentValue2 = maxValue
        direction2 = -1  -- Change direction to decrement
    elseif currentValue2 < minValue then
        currentValue2 = minValue
        direction2 = 1   -- Change direction to increment
    end

end
-- @region NOTIFICATION_ANIM start
local anim_time = 0.6
local max_notifs = 8
local data = {}
local global_fraction = 0
local notifications = {

    new = function(string, r, g, b)
        table.insert(data, {
            time = globals.curtime(),
            string = string,
            color = {r, g, b, 255},
            fraction = 0
        })
        local time = 15
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

    if ui.get(menu.visualsTab.logs_type) == "New" then
        for i = 1, #data do
            local notif = data[i]

                      local data = {rounding = 5, size = 5, glow = 1, time = 4}

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
            local strw2 = renderer.measure_text("b", "")

            local interitus_x, interitus_y = renderer.measure_text("", "   ")
            
            local paddingx, paddingy = 7, data.size
            local offsetY = ui.get(menu.visualsTab.logOffset)
            global_fraction = fraction
            Offset = Offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 + 5) * fraction
            
            glow_module(x/2 - (strw + strw2 + interitus_x)/2 - paddingx, y - offsetY - strh/2 - paddingy - Offset, strw + strw2 + interitus_x + paddingx*2, strh + paddingy*2, data.glow, data.rounding, {r, g, b, 75 * fraction}, {15,15,15,255 * fraction})
            
            renderer.text(x/2 + interitus_x + strw2/2 , y - offsetY - Offset , 255, 255, 255, 255 * fraction, "c", 0, string)
            if readfile("inter.png") ~= nil then
            local png = images.load_png(readfile("inter.png"))

            png:draw(x/2 - (strw + strw2 + interitus_x)/2 + paddingx - 13, y - offsetY - Offset - 10, 18, 18, r, g, b, 255 * fraction, true, "f")
            end

        end
    end

    if ui.get(menu.visualsTab.logs_type) == "Legacy" then
        for i = 1, #data do
            local notif = data[i]

                      local data = {rounding = 5, size = 5, glow = 7, time = 4}

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
            local strw2 = renderer.measure_text("b", "")

            local interitus_x, interitus_y = renderer.measure_text("", "[INTERITUS] ")

            local paddingx, paddingy = 7, data.size
            local offsetY = ui.get(menu.visualsTab.logOffset)
            global_fraction = fraction
            Offset = Offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 + 5) * fraction
            glow_module(x/2 - (strw + strw2 + interitus_x)/2 - paddingx, y - offsetY - strh/2 - paddingy - Offset, strw + strw2 + interitus_x + paddingx*2, strh + paddingy*2, data.glow, data.rounding, {r, g, b, 75 * fraction}, {15,15,15,255 * fraction})
            renderer.text(x/2 + strw2/2, y - offsetY - Offset, 255, 255, 255, 255 * fraction, "c", 0, func.gradient_text(r, g, b, 255 * fraction, 50, 50, 50, 255 * fraction, "[INTERITUS] ") .. string)
        end
    end
        for i = #to_remove, 1, -1 do
            table.remove(data, to_remove[i])
        end
    end,

    clear = function()
        data = {}
    end
}

function vector3_distance (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x1 - x2)^2 + (y1 - y2)^2 + (z1 - z2)^2)
end

function closest_point_on_ray (tx, ty, tz, startx, starty, startz, endx, endy, endz)
    local tox, toy, toz = tx - startx, ty - starty, tz - startz
    local dirx, diry, dirz = endx - startx, endy - starty, endz - startz
    local length = math.sqrt(dirx^2 + diry^2 + dirz^2)
    dirx, diry, dirz = dirx / length, diry / length, dirz / length
    local range_along = dirx * tox + diry * toy + dirz * toz
    if range_along < 0 then
        return startx, starty, startz
    end
    if range_along > length then
        return endx, endy, endz
    end	
    return startx + dirx * range_along, starty + diry * range_along, startz + dirz * range_along
end

local function antibrute_resetter()
    local me = entity.get_local_player()
    -- print(string.format("antibrute_data.miss_counter == %s, globals.curtime() == %s",math.ceil(antibrute_data.bruted_last_time + 3), math.ceil(globals.curtime())))

    if not ui.get(menu.bruteTab.enable) then 
        antibrute_data.miss_counter = 0
        antibrute_data.entity = nil
        antibrute_data.entity2 = nil
        return
    end

    if antibrute_data.miss_counter == 0 then return end

    antibrute_data.recorded_entity = antibrute_data.entity2

    if func.includes(ui.get(menu.bruteTab.resetter), "Target Death") then
        if antibrute_data.fixxer_nixxer == true then
            if not entity.is_alive(antibrute_data.entity) then 
                antibrute_data.fixxer_nixxer = false
                antibrute_data.miss_counter = 0
            antibrute_data.entity_changed = false
            antibrute_data.entity = nil
            antibrute_data.entity2 = nil
                if func.includes(ui.get(menu.visualsTab.logs), "Anti-Aim") and func.includes(ui.get(menu.visualsTab.visuals), "Logging") then
                    notifications.new(string.format("$Anti-Brute$ resetted due to $target death$"), lua_color.r, lua_color.g, lua_color.b)
                end
            end
        end
    end

    if func.includes(ui.get(menu.bruteTab.resetter), "Target Change") then
        if antibrute_data.entity_changed then 
            antibrute_data.miss_counter = 0
            antibrute_data.entity_changed = false
            antibrute_data.entity = nil
            antibrute_data.entity2 = nil
            if func.includes(ui.get(menu.visualsTab.logs), "Anti-Aim") and func.includes(ui.get(menu.visualsTab.visuals), "Logging") then
                notifications.new(string.format("$Anti-Brute$ resetted due to $target change$"), lua_color.r, lua_color.g, lua_color.b)
            end
        end
    end

    if ui.get(menu.bruteTab.phases) < antibrute_data.miss_counter then 
        antibrute_data.miss_counter = 0
            antibrute_data.entity_changed = false
            antibrute_data.entity = nil
            antibrute_data.entity2 = nil
        if func.includes(ui.get(menu.visualsTab.logs), "Anti-Aim") and func.includes(ui.get(menu.visualsTab.visuals), "Logging") then
            notifications.new(string.format("$Anti-Brute$ resetted due to $reach max capacity$"), lua_color.r, lua_color.g, lua_color.b)
        end
    end

    if func.includes(ui.get(menu.bruteTab.resetter), "Reached Time Line") then
        if math.ceil(antibrute_data.bruted_last_time + ui.get(menu.bruteTab.reset_time)) == math.ceil(globals.curtime()) then
            antibrute_data.miss_counter = 0
            antibrute_data.entity_changed = false
            antibrute_data.entity = nil
            antibrute_data.entity2 = nil
            if func.includes(ui.get(menu.visualsTab.logs), "Anti-Aim") and func.includes(ui.get(menu.visualsTab.visuals), "Logging") then
                notifications.new(string.format("$Anti-Brute$ resetted due to $reached time-line$"), lua_color.r, lua_color.g, lua_color.b)
            end
        end
    end
end

local function brute_side()
    local stand = func.includes(ui.get(menu.bruteTab.disablers), "Standing") and vars.pState == 2
    local move = func.includes(ui.get(menu.bruteTab.disablers), "Moving") and vars.pState == 3
    local air = func.includes(ui.get(menu.bruteTab.disablers), "Air") and vars.pState == 7
    local cair = func.includes(ui.get(menu.bruteTab.disablers), "Air-Crouching") and vars.pState == 8
    local duck = func.includes(ui.get(menu.bruteTab.disablers), "Duck") and (vars.pState == 6 or vars.pState == 5)
    local slow = func.includes(ui.get(menu.bruteTab.disablers), "Slowmo") and vars.pState == 4
    local disabler = air or duck or slow or cair or stand or move

    local standIm = func.includes(ui.get(menu.bruteTab.addition_states), "Standing") and vars.pState == 2
    local moveIm = func.includes(ui.get(menu.bruteTab.addition_states), "Moving") and vars.pState == 3
    local airIm = func.includes(ui.get(menu.bruteTab.addition_states), "Air") and vars.pState == 7
    local cairIm = func.includes(ui.get(menu.bruteTab.addition_states), "Air-Crouching") and vars.pState == 8
    local duckIm = func.includes(ui.get(menu.bruteTab.addition_states), "Duck") and (vars.pState == 6 or vars.pState == 5)
    local slowIm = func.includes(ui.get(menu.bruteTab.addition_states), "Slowmo") and vars.pState == 4
    local disablerm = airIm or duckIm or slowIm or cairIm or standIm or moveIm

    local standI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Standing") and antibrute_data.recorded_state == 2
    local moveI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Moving") and antibrute_data.recorded_state == 3
    local airI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Air") and antibrute_data.recorded_state == 7
    local cairI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Air-Crouching") and antibrute_data.recorded_state == 8
    local duckI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Duck") and (antibrute_data.recorded_state == 6 or antibrute_data.recorded_state == 5)
    local slowI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Slowmo") and antibrute_data.recorded_state == 4
    local disablerI = airI or duckI or slowI or cairI or standI or moveI
   
    local nigger = disablerI and ignore_brute_fix

    if not ui.get(menu.bruteTab.enable) or not func.includes(ui.get(menu.bruteTab.additions), "Flip Side") or disabler or not disablerm or not nigger or antibrute_data.miss_counter == 0 then 
        antibrute_data.final_side = 0
        return
    end

    if antibrute_data.recorded_side == -1 then
        antibrute_data.final_side = 1
    else
        antibrute_data.final_side = -1
    end   

end

local function antibrute(e)
    local me = entity.get_local_player()
    local bodyYaw = entity.get_prop(me, "m_flPoseParameter", 11) * 120 - 60
    local side = bodyYaw > 0 and 1 or -1

    if not ui.get(menu.bruteTab.enable) then 
        antibrute_data.miss_counter = 0
        antibrute_data.entity = nil
        antibrute_data.entity2 = nil
            antibrute_data.entity_changed = false
        return
    end

    if antibrute_data.entity_changed then return end

    local stand = func.includes(ui.get(menu.bruteTab.disablers), "Standing") and vars.pState == 2
    local move = func.includes(ui.get(menu.bruteTab.disablers), "Moving") and vars.pState == 3
    local air = func.includes(ui.get(menu.bruteTab.disablers), "Air") and vars.pState == 7
    local cair = func.includes(ui.get(menu.bruteTab.disablers), "Air-Crouching") and vars.pState == 8
    local duck = func.includes(ui.get(menu.bruteTab.disablers), "Duck") and (vars.pState == 6 or vars.pState == 5)
    local slow = func.includes(ui.get(menu.bruteTab.disablers), "Slowmo") and vars.pState == 4

    local disabler = air or duck or slow or cair or stand or move

    local standI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Standing") and antibrute_data.recorded_state == 2
    local moveI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Moving") and antibrute_data.recorded_state == 3
    local airI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Air") and antibrute_data.recorded_state == 7
    local cairI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Air-Crouching") and antibrute_data.recorded_state == 8
    local duckI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Duck") and (antibrute_data.recorded_state == 6 or antibrute_data.recorded_state == 5)
    local slowI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Slowmo") and antibrute_data.recorded_state == 4
    local disablerI = airI or duckI or slowI or cairI or standI or moveI
   
    local nigger = disablerI and ignore_brute_fix

    if disabler then
        return 
    end

    if entity.is_alive(me) then
        if math.abs(antibrute_data.bruted_last_time - globals.curtime()) > 0.250 then
            local ent = client.userid_to_entindex(e.userid)
            if not entity.is_dormant(ent) and entity.is_enemy(ent) then
                local headx, heady, headz = entity.hitbox_position(me, 0)
                local eyex, eyey, eyez = entity.get_origin(ent)
                eyez = eyez + 64
                local x, y, z = closest_point_on_ray(headx, heady, headz, eyex, eyey, eyez, e.x, e.y, e.z)
                local r, g, b, a = ui.get(menu.visualsTab.logsClr)
                if vector3_distance(x, y, z, headx, heady, headz) < 88 then
                    antibrute_data.miss_counter = antibrute_data.miss_counter + 1
                    antibrute_data.rdm = math.random(1, 2)
                    antibrute_data.bruted_last_time = globals.curtime() 
                    antibrute_data.fixxer_nixxer = true
                    antibrute_data.entity = ent
                    antibrute_data.recorded_side = side
                    antibrute_data.recorded_state = vars.pState
                    antibrute_data.entity2 = ent
                    antibrute_data.time[ent] = globals.curtime() + 1
                    if func.includes(ui.get(menu.visualsTab.logs), "Anti-Aim") then
                        if ui.get(menu.bruteTab.phases) < antibrute_data.miss_counter then return end                       
                        notifications.new(string.format("$Anti-Aim$ Changed due to $%s$`s shot [$%s$]", entity.get_player_name(ent), antibrute_data.miss_counter), r, g, b) 
                    end
                end
            end
        end
    end
end

local function onHit(e)
    local group = vars.hitgroup_names[e.hitgroup + 1] or '?'
	local r, g, b, a = ui.get(menu.visualsTab.logsClr)
    local history_tick = globals.tickcount() - e.tick
	notifications.new(string.format("Hit %s's $%s$ for $%d$ damage ($%d$ health remaining)", entity.get_player_name(e.target), group:lower(), e.damage, entity.get_prop(e.target, 'm_iHealth'), history_tick), r, g, b) 
    print(string.format("Hit %s's %s for %d damage (%d health remaining)", entity.get_player_name(e.target), group:lower(), e.damage, entity.get_prop(e.target, 'm_iHealth'), history_tick))
end

local function onMiss(e)
    local group = vars.hitgroup_names[e.hitgroup + 1] or '?'
    local ping = math.min(999, client.real_latency() * 1000)
    local ping_col = (ping >= 100) and { 255, 0, 0 } or { 150, 200, 60 }
    local hc = math.floor(e.hit_chance + 0.5);
    local hc_col = (hc < ui.get(refs.hitChance)) and { 255, 0, 0 } or { 150, 200, 60 };
    e.reason = e.reason == "?" and "resolver" or e.reason
	notifications.new(string.format("Missed %s's $%s$ due to $%s$", entity.get_player_name(e.target), group:lower(), e.reason), 255, 120, 120)
    print(string.format("Missed %s's %s due to %s", entity.get_player_name(e.target), group:lower(), e.reason))
end
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
	aa.input = globals.curtime()
end)

local clantag = {
    steam = steamworks.ISteamFriends,
    prev_ct = "",
    orig_ct = "",
    enb = false,
}

local function get_original_clantag()
    local clan_id = cvar.cl_clanid.get_int()
    if clan_id == 0 then return "\0" end

    local clan_count = clantag.steam.GetClanCount()
    for i = 0, clan_count do 
        local group_id = clantag.steam.GetClanByIndex(i)
        if group_id == clan_id then
            return clantag.steam.GetClanTag(group_id)
        end
    end
end

local current_tick = func.time_to_ticks(globals.realtime())

local function get_desync(is_for_skeet)
    local desync

    if not ui.get(menu.bruteTab.enable) then 
          desync = ui.get(aaBuilder[vars.pState].bodyYawSlider)
        return desync
    end
    
    local stand = func.includes(ui.get(menu.bruteTab.disablers), "Standing") and vars.pState == 2
    local move = func.includes(ui.get(menu.bruteTab.disablers), "Moving") and vars.pState == 3
    local air = func.includes(ui.get(menu.bruteTab.disablers), "Air") and vars.pState == 7
    local cair = func.includes(ui.get(menu.bruteTab.disablers), "Air-Crouching") and vars.pState == 8
    local duck = func.includes(ui.get(menu.bruteTab.disablers), "Duck") and (vars.pState == 6 or vars.pState == 5)
    local slow = func.includes(ui.get(menu.bruteTab.disablers), "Slowmo") and vars.pState == 4
    local should_skip = false

    local standI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Standing") and antibrute_data.recorded_state == 2
    local moveI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Moving") and antibrute_data.recorded_state == 3
    local airI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Air") and antibrute_data.recorded_state == 7
    local cairI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Air-Crouching") and antibrute_data.recorded_state == 8
    local duckI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Duck") and (antibrute_data.recorded_state == 6 or antibrute_data.recorded_state == 5)
    local slowI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Slowmo") and antibrute_data.recorded_state == 4
    local disablerI = airI or duckI or slowI or cairI or standI or moveI
   
    local nigger = disablerI and ignore_brute_fix

    if is_for_skeet then
    if antibrute_data.miss_counter == 0 or ui.get(menu.bruteTab.phases) == 0 or disabler or nigger then       
        desync = ui.get(aaBuilder[vars.pState].bodyYawSlider)
    elseif antibrute_data.miss_counter == 1 then
        if ui.get(menu.bruteTab.jitter1) == 0 then
            desync = ui.get(aaBuilder[vars.pState].bodyYawSlider)
        else
            desync = antibrute_data.rdm == 1 and ui.get(menu.bruteTab.Desync1) or -ui.get(menu.bruteTab.Desync1)
        end
    elseif antibrute_data.miss_counter == 2 then
        desync = antibrute_data.rdm == 1 and ui.get(menu.bruteTab.Desync2) or -ui.get(menu.bruteTab.Desync2)
    elseif antibrute_data.miss_counter == 3 then
        desync = antibrute_data.rdm == 1 and ui.get(menu.bruteTab.Desync3) or -ui.get(menu.bruteTab.Desync3)
    elseif antibrute_data.miss_counter == 4 then
        desync = antibrute_data.rdm == 1 and ui.get(menu.bruteTab.Desync4) or -ui.get(menu.bruteTab.Desync4)
    elseif antibrute_data.miss_counter == 5 then
        desync = antibrute_data.rdm == 1 and ui.get(menu.bruteTab.Desync5) or -ui.get(menu.bruteTab.Desync5)
    elseif desync == nil then
        desync = ui.get(aaBuilder[vars.pState].bodyYawSlider)
    end 
else
    if antibrute_data.miss_counter == 0 or ui.get(menu.bruteTab.phases) == 0 or disabler then
        desync = ui.get(aaBuilder[vars.pState].fakeYawLimit)
    else
        local desyncValue = 0
        
        if antibrute_data.miss_counter == 1 then
            desyncValue = ui.get(menu.bruteTab.Desync1)
        elseif antibrute_data.miss_counter == 2 then
            desyncValue = ui.get(menu.bruteTab.Desync2)
        elseif antibrute_data.miss_counter == 3 then
            desyncValue = ui.get(menu.bruteTab.Desync3)
        elseif antibrute_data.miss_counter == 4 then
            desyncValue = ui.get(menu.bruteTab.Desync4)
        elseif antibrute_data.miss_counter == 5 then
            desyncValue = ui.get(menu.bruteTab.Desync5)
        end
    
        if antibrute_data.rdm == 1 then
            desync = math.min(59, math.max(-59, desyncValue))
        else
            desync = math.min(59, math.max(-59, -desyncValue))
        end
    end
    
    if desync == nil then
        desync = math.min(59, math.max(-59, ui.get(aaBuilder[vars.pState].fakeYawLimit)))
    end
end

 return desync

end

local function get_jitter(is_neg)
    local jitter
    local lp = entity.get_local_player()
    local bodyYaw = entity.get_prop(lp, "m_flPoseParameter", 11) * 120 - 60
    local side = bodyYaw > 0 and 1 or -1

    local stand = func.includes(ui.get(menu.bruteTab.disablers), "Standing") and vars.pState == 2
    local move = func.includes(ui.get(menu.bruteTab.disablers), "Moving") and vars.pState == 3
    local air = func.includes(ui.get(menu.bruteTab.disablers), "Air") and vars.pState == 7
    local cair = func.includes(ui.get(menu.bruteTab.disablers), "Air-Crouching") and vars.pState == 8
    local duck = func.includes(ui.get(menu.bruteTab.disablers), "Duck") and (vars.pState == 6 or vars.pState == 5)
    local slow = func.includes(ui.get(menu.bruteTab.disablers), "Slowmo") and vars.pState == 4

    local disabler = air or duck or slow or cair or stand or move

    local standI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Standing") and antibrute_data.recorded_state == 2
    local moveI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Moving") and antibrute_data.recorded_state == 3
    local airI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Air") and antibrute_data.recorded_state == 7
    local cairI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Air-Crouching") and antibrute_data.recorded_state == 8
    local duckI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Duck") and (antibrute_data.recorded_state == 6 or antibrute_data.recorded_state == 5)
    local slowI = func.includes(ui.get(menu.bruteTab.Ignore_condition), "Slowmo") and antibrute_data.recorded_state == 4
    local disablerI = airI or duckI or slowI or cairI or standI or moveI
   
    local nigger = disablerI and ignore_brute_fix

        if antibrute_data.miss_counter == 0 or ui.get(menu.bruteTab.phases) == 0 or disabler or nigger then
            if is_neg then
                jitter = -100
            else
                jitter = 100
            end
        end
    

        if antibrute_data.miss_counter == 1 then
            if ui.get(menu.bruteTab.jitter1) == 0 then
                if is_neg then
                    jitter = -100
                else
                    jitter = 100
                end
            else
                jitter = ui.get(menu.bruteTab.jitter1)
            end
        end
    
        if antibrute_data.miss_counter == 2 then
            if ui.get(menu.bruteTab.jitter2) == 0 then
                if is_neg then
                    jitter = -100
                else
                    jitter = 100
                end
            else
                jitter = ui.get(menu.bruteTab.jitter2)
            end
        end
    
        if antibrute_data.miss_counter == 3 then
            if ui.get(menu.bruteTab.jitter3) == 0 then
                if is_neg then
                    jitter = -100
                else
                    jitter = 100
                end
            else
                jitter = ui.get(menu.bruteTab.jitter3)
            end
        end
    
        if antibrute_data.miss_counter == 4 then
            if ui.get(menu.bruteTab.jitter4) == 0 then
                if is_neg then
                    jitter = -100
                else
                    jitter = 100
                end
            else
                jitter = ui.get(menu.bruteTab.jitter4)
            end
        end
    
        if antibrute_data.miss_counter == 5 then
            if ui.get(menu.bruteTab.jitter5) == 0 then
                if is_neg then
                    jitter = -100
                else
                    jitter = 100
                end
            else
                jitter = ui.get(menu.bruteTab.jitter5)
            end
        end  

        if antibrute_data.miss_counter > 5 then
            if ui.get(menu.bruteTab.jitter5) == 0 then
                if is_neg then
                    jitter = -100
                else
                    jitter = 100
                end
            else
                jitter = ui.get(menu.bruteTab.jitter5)
            end
        end  

    return jitter
end


local jitter_speed_test = false
local timer = 0

function loveupdate(toggleDelay)

    timer = timer + 1  

    if timer >= toggleDelay then
        jitter_speed_test = not jitter_speed_test 
        timer = 0  
    end

    return jitter_speed_test
end

local tickcount_spin = 0 -- Initialize tickcount to 0
local yawValue_spin = 0 -- Initialize yawValue to a default value
local spinSpeed_spin = 2 -- Adjust the spin speed as needed

local angle3d_struct = ffi.typeof("struct { float pitch; float yaw; float roll; }")
local vec_struct = ffi.typeof("struct { float x; float y; float z; }")

local cUserCmd =
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
        bool send_packet; 
    }
    ]],
    angle3d_struct,
    vec_struct,
    angle3d_struct,
    vec_struct
)

local client_sig = client.find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85") or error("client.dll!:input not found.")
local get_cUserCmd = ffi.typeof("$* (__thiscall*)(uintptr_t ecx, int nSlot, int sequence_number)", cUserCmd)
local input_vtbl = ffi.typeof([[struct{uintptr_t padding[8];$ GetUserCmd;}]],get_cUserCmd)
local input = ffi.typeof([[struct{$* vfptr;}*]], input_vtbl)
local get_input = ffi.cast(input,ffi.cast("uintptr_t**",tonumber(ffi.cast("uintptr_t", client_sig)) + 1)[0])

local function get_velocity(player)
    local x,y,z = entity.get_prop(player, "m_vecVelocity")
    if x == nil then return end
    return math.sqrt(x*x + y*y + z*z)
end

local local_player, callback_reg, dt_charged = nil, false, false

local function check_charge()
    local m_nTickBase = entity.get_prop(entity.get_local_player(), 'm_nTickBase')
    local client_latency = client.latency()
    local shift = math.floor(m_nTickBase - globals.tickcount() - 3 - toticks(client_latency) * .5 + .5 * (client_latency * 10))

    local wanted = -14 + (ui.get(refs.doubletap.fakelag_limit) - 1) + 3 --error margin

    dt_charged = shift <= wanted
end

local function can_desync(cmd)
    if entity.get_prop(entity.get_local_player(), "m_MoveType") == 9 then
        return false
    end

    if isAimFireRunning then 
        return true 
    end

    local client_weapon = entity.get_player_weapon(entity.get_local_player())

    if client_weapon == nil then
        return false
    end
    local weapon_classname = entity.get_classname(client_weapon)
    local in_use = cmd.in_use == 1
    local in_attack = cmd.in_attack == 1
    local in_attack2 = cmd.in_attack2 == 1
    if in_use then
        return false
    end
    if in_attack or in_attack2 then
        if weapon_classname:find("Grenade") then
            vars.m1_time = globals.curtime() + 0.15
        end
    end
    if vars.m1_time > globals.curtime() then
        return false
    end
    if in_attack then
        if client_weapon == nil then
            return false
        end
        if weapon_classname then
            return false
        end
        return false
    end
    return true
end

local function get_choke(cmd)
    local fl_limit = ui.get(refs.flLimit)
    local fl_p = fl_limit % 2 == 1
    local chokedcommands = cmd.chokedcommands
    local cmd_p = chokedcommands % 2 == 0
    local doubletap_ref = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    local osaa_ref = ui.get(refs.os[1]) and ui.get(refs.os[2])
    local fd_ref = ui.get(refs.fakeDuck)
    local velocity = get_velocity(entity.get_local_player())

    if doubletap_ref then
        if vars.choked > 2 then
            if cmd.chokedcommands >= 0 then
                cmd_p = false
            end
        end
    end

    vars.choked = cmd.chokedcommands
    
    if vars.dt_state ~= doubletap_ref then
        vars.doubletap_time = globals.curtime() + 0.25
    end

    if not doubletap_ref and not osaa_ref and not cmd.no_choke or fd_ref then
        if not fl_p then
            if vars.doubletap_time > globals.curtime() then
                if cmd.chokedcommands >= 0 and cmd.chokedcommands < fl_limit then
                    cmd_p = chokedcommands % 2 == 0
                else
                    cmd_p = chokedcommands % 2 == 1
                end
            else
                cmd_p = chokedcommands % 2 == 1
            end
        end
    end
    vars.dt_state = doubletap_ref
    return cmd_p
end

local DesyncJitterSwitch
local local_on_lowground = false
local function apply_desync(cmd, fake)
    local usrcmd = get_input.vfptr.GetUserCmd(ffi.cast("uintptr_t", get_input), 0, cmd.command_number)
    cmd.allow_send_packet = false

    local pitch, yaw = client.camera_angles()

    local can_desync = can_desync(cmd)
    local is_choke = get_choke(cmd)

    ui.set(refs.bodyYaw[1], "Opposite")

    if globals.tickcount() % 7 == 1 then
        DesyncJitterSwitch = not DesyncJitterSwitch
    end

    ui.set(refs.bodyYaw[2], DesyncJitterSwitch and -180 or 180)

    if cmd.chokedcommands == 0 then
        vars.yaw = (yaw + 180) - fake*2;
    end

    if vars.yaw == nil then return end

    if can_desync then
        if not usrcmd.hasbeenpredicted then
            if is_choke then
                cmd.yaw = vars.yaw;
            end
        end
    end
end

local isAimFireRunning = false
local desync_on_shot
local function aimFireCallback(e)
    if func.includes(ui.get(menu.aaTab.tweaks), "Desync On Shot") then
    isAimFireRunning = true

        if ui.get(menu.aaTab.desync_on_shot) == "Random" then 
            desync_on_shot = math.random(-90, 90)
        elseif ui.get(menu.aaTab.desync_on_shot) == "Left" then
            desync_on_shot = -90
        elseif ui.get(menu.aaTab.desync_on_shot) == "Right" then
            desync_on_shot = 90
        elseif ui.get(menu.aaTab.desync_on_shot) == "Jitter" then
            local yaw_method = math.random(0, 1) == 1 and -90 or 90
            desync_on_shot = yaw_method
        end

        apply_desync(vars.cmd, desync_on_shot)
    isAimFireRunning = false
    else
        isAimFireRunning = false
    end
end

client.set_event_callback("aim_fire", aimFireCallback)

local AI_Height_Diff = 0
local AI_Velocity = 0
local AI_Jitter = 0
local defensive_time = 0
local yawValue = 0 -- Initialize yawValue to a default value
local pitchValue = 0 -- Initialize yawValue to a default value
local jitter_intensity

function aa_builder(cmd)
    if not vars.localPlayer or not entity.is_alive(vars.localPlayer) or not ui.get(masterSwitch) or isAimFireRunning then return end
	local flags = entity.get_prop(vars.localPlayer, "m_fFlags")
    local onground = bit.band(flags, 1) ~= 0 and cmd.in_jump == 0
	local valve = entity.get_prop(entity.get_game_rules(), "m_bIsValveDS")
	local origin = vector(entity.get_prop(vars.localPlayer, "m_vecOrigin"))
	local velocity = vector(entity.get_prop(vars.localPlayer, "m_vecVelocity"))
	local camera = vector(client.camera_angles())
	local eye = vector(client.eye_position())
	local speed = math.sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y) + (velocity.z * velocity.z))
    --local weapon = entity.get_player_weapon()
	local pStill = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2) < 5
    local bodyYaw = entity.get_prop(vars.localPlayer, "m_flPoseParameter", 11) * 120 - 60

    local weapon = entity.get_player_weapon(vars.localPlayer)

    local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
	local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
	local isFd = ui.get(refs.fakeDuck)
	local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    local defensive_charged = (func.defensive.defensive > 1 and func.defensive.defensive < 14)

    if defensive_charged then
        defensive_time = globals.curtime()
        jitter_intensity = math.random(50, 100) / 100  -- Generates a random number between 0 and 1 for jitter intensity
    else
        jitter_intensity = 0  -- No jitter when the defensive condition is not met
    end

    local allowed_exploits = (func.includes(ui.get(aaBuilder[vars.pState].defensiveExploits), "Double Tap") and isDt) or (func.includes(ui.get(aaBuilder[vars.pState].defensiveExploits), "Hide Shots") and isOs)
    local isDefensive = defensive_charged and ((globals.curtime() - defensive_time + jitter_intensity) > (0.301 - (0.3 * ui.get(aaBuilder[vars.pState].defensiveSensivity) / 10) + jitter_intensity *2)) and allowed_exploits

    local safeKnife = func.includes(ui.get(menu.aaTab.tweaks), "Static On Knife") and entity.get_classname(weapon) == "CKnife"
    local isFd = ui.get(refs.fakeDuck)
    -- search for states
    vars.pState = 1
    if pStill then vars.pState = 2 end
    if not pStill then vars.pState = 3 end
    if isSlow then vars.pState = 4 end
    if entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 and not pStill then vars.pState = 5 end
    if entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 and pStill then vars.pState = 6 end
    if not onground then vars.pState = 7 end
    if not onground and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 8 end
    if isFd then vars.pState = 9 end

    if ui.get(aaBuilder[vars.pState].enableState) == false and vars.pState ~= 1 then
        vars.pState = 1
    end

    brute_side()

    local nextAttack = entity.get_prop(vars.localPlayer, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(vars.localPlayer), "m_flNextPrimaryAttack")
    local dtActive = false
    local isFl = ui.get(ui.reference("AA", "Fake lag", "Enabled"))
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
    end

    local Choke = false
    local way_3_yaw = 0
    local current_stage = 0
    if cmd.allow_send_packet == false or cmd.chokedcommands > 1 then
        Choke = true
    else
        Choke = false
    end

    if cmd.command_number % 4 > 1 and Choke == false then
        current_stage = current_stage + 1
    end

    if current_stage == 1 then
        way_3_yaw = ui.get(aaBuilder[vars.pState].yawJitterStatic) - ui.get(aaBuilder[vars.pState].yawJitterStatic) % 15
    end

    if current_stage == 2 then
        way_3_yaw = ui.get(aaBuilder[vars.pState].yawJitterStatic) 
    end

    if current_stage == 3 then
        way_3_yaw = ui.get(aaBuilder[vars.pState].yawJitterStatic) + ui.get(aaBuilder[vars.pState].yawJitterStatic) % 15
        current_stage = 0 
    end

    local side_yaw = 2
    if cmd.chokedcommands == 0 then
        vars.choke1 = vars.choke1 + 1
        vars.choke2 = vars.choke2 + 1
        vars.choke3 = vars.choke3 + 1
        vars.choke4 = vars.choke4 + 1
    end
    if vars.choke1 >= 5 then
        vars.choke1 = 0
    end
    if vars.choke2 >= 8 then
        vars.choke2 = 0
    end
    if vars.choke3 >= 8 then
        vars.choke3 = 5
    end

    if globals.tickcount() % ui.get(aaBuilder[vars.pState].yawSpeed) == 1 then
        vars.switch = not vars.switch
    end

    local tickcount = globals.tickcount()

    local side = bodyYaw > 0 and 1 or -1

        -- manual aa
        local isStatic = ui.get(menu.aaTab.manualTab.static)

        ui.set(menu.aaTab.manualTab.manualLeft, "On hotkey")
        ui.set(menu.aaTab.manualTab.manualRight, "On hotkey")
        ui.set(menu.aaTab.manualTab.manualForward, "On hotkey")

        if aa.input + 0.182 < globals.curtime() then
            if aa.manualAA == 0 then
                if ui.get(menu.aaTab.manualTab.manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()    
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
                elseif ui.get(menu.aaTab.manualTab.manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
                elseif ui.get(menu.aaTab.manualTab.manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                
                end
            elseif aa.manualAA == 1 then
                if ui.get(menu.aaTab.manualTab.manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.aaTab.manualTab.manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.aaTab.manualTab.manualLeft) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
               
                end
            elseif aa.manualAA == 2 then
                if ui.get(menu.aaTab.manualTab.manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.aaTab.manualTab.manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.aaTab.manualTab.manualRight) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                
                end
            elseif aa.manualAA == 3 then
                if ui.get(menu.aaTab.manualTab.manualForward) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.aaTab.manualTab.manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.aaTab.manualTab.manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
               
                end
            end

            if aa.manualAA == 1 or aa.manualAA == 2 or aa.manualAA == 3 then
                aa.ignore = true

                if isStatic then
                    ui.set(refs.yawJitter[1], "Off")
                    ui.set(refs.yawJitter[2], 0)
                    ui.set(refs.bodyYaw[1], "Static")
                    ui.set(refs.bodyYaw[2], 180)

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
                elseif not isStatic and ui.get(aaBuilder[vars.pState].enableState) then
                    if ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                        ui.set(refs.yawJitter[1], "Center")
                        ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft)*math.random(-1, 1)  or ui.get(aaBuilder[vars.pState].yawJitterRight)*math.random(-1, 1) ))
                    elseif ui.get(aaBuilder[vars.pState].yawJitter) == "L/R" then
                        ui.set(refs.yawJitter[1], "Center")
                        ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) or ui.get(aaBuilder[vars.pState].yawJitterRight)))
                    else
                        if (aa.manualAA == 1 or aa.manualAA == 2 or aa.manualAA == 3) then
                            ui.set(refs.yawJitter[1], "Center")
                        else
                            ui.set(refs.yawJitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
                        end
                        
                        ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic) % get_jitter(0 > ui.get(aaBuilder[vars.pState].yawJitterStatic)))

                    end

                    if ui.get(aaBuilder[vars.pState].yawCondition) == "L/R" then
                        ui.set(refs.bodyYaw[1], "Jitter")
                        ui.set(refs.bodyYaw[2], -1)
                    else
                        ui.set(refs.bodyYaw[1], "Static")
                        ui.set(refs.bodyYaw[2], -180)
                    end

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
        elseif aa.input > globals.curtime() then
        --    aa.ignore = false
        --    aa.manualAA = 0
            aa.input = globals.curtime()
        end
        
    -- check height advantage and head safety
    local heightAdvantage = false
    local safetyAlert = false
    local enemies = entity.get_players(true)
	for i=1, #enemies do
        if entity.is_dormant(enemies[i]) then heightAlert = false sidewaysAlert = false return end
		local playerX, playerY, playerZ  = entity.get_prop(enemies[i], "m_vecOrigin")
		local playerFlags = entity.get_prop(enemies[i], "m_fFlags")
		local playerOnGround = bit.band(playerFlags, 1) ~= 0
		local lengthDistance = math.sqrt((playerX - origin.x)^2 + (playerY - origin.y)^2 + (playerZ - origin.z)^2)
		if ((playerZ + 100 < origin.z) and lengthDistance <= 300) then
			heightAdvantage = true
		else
			heightAdvantage = false
		end

        if ((playerZ - 20 > origin.z) and lengthDistance < 800) then
            AI_Height_Diff = playerZ - origin.z
			local_on_lowground = true
		else
			local_on_lowground = false
		end

        if ((bodyYaw >= 40 or bodyYaw <= -40) and func.headVisible(enemies[i])) then
			safetyAlert = true
		else
			safetyAlert = false
		end
	end


    local isLethal = entity.get_prop(vars.localPlayer, "m_iHealth") < 92

    if func.includes(ui.get(aaBuilder[vars.pState].fsBodyYaw), "Always On") then
        ui.set(refs.fsBodyYaw, true)
    elseif func.includes(ui.get(aaBuilder[vars.pState].fsBodyYaw), "When Unsafe") and safetyAlert then
        ui.set(refs.fsBodyYaw, true)
    elseif func.includes(ui.get(aaBuilder[vars.pState].fsBodyYaw), "When Lethal") and isLethal then
        ui.set(refs.fsBodyYaw, true)
    else
        ui.set(refs.fsBodyYaw, false)
    end

    if ui.get(aaBuilder[vars.pState].enableState) then

        if func.includes(ui.get(aaBuilder[vars.pState].defensiveOpt), "Always On") then
            cmd.force_defensive = true
        end

        

        if func.includes(ui.get(aaBuilder[vars.pState].defensiveOpt), "Cycle Switch") then
             ui.set(refs.dt[3], "Defensive")

             if tickcount % 3 == 1 then
                 ui.set(refs.dt[3], "Offensive")
             end
             cmd.force_defensive = tickcount % 3 ~= 1
        end

        if func.includes(ui.get(aaBuilder[vars.pState].defensiveOpt), "Delayed Switch") then
            if loveupdate(ui.get(aaBuilder[vars.pState].defensivedelaySlider)) then
                cmd.force_defensive = false
            else
                cmd.force_defensive = true
            end
        else
            cmd.force_defensive = true
        end
        
        if aa.ignore then return end

        if ui.get(aaBuilder[vars.pState].defensivePitch) == "Custom" and isDefensive then
            defensive_time = globals.curtime()
            ui.set(refs.pitch[1], "Custom")
            ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].defensivePitchSlider))
        elseif ui.get(aaBuilder[vars.pState].defensivePitch) == "Jitter" and isDefensive then
            ui.set(refs.pitch[1], "Custom")
            if vars.choke2 == 0 then
                pitchValue = math.random(-89, -45) -- Set yawValue to 90 when tickcount % 3 == 0
            elseif vars.choke2 == 1 then
                pitchValue = -89 -- Set yawValue to 90 when tickcount % 3 == 0
            elseif vars.choke2 == 2 then
                pitchValue = -45 -- Set yawValue to 90 when tickcount % 3 == 0
            elseif vars.choke2 == 3 then
                pitchValue = -89 -- Set yawValue to 90 when tickcount % 3 == 0
            elseif vars.choke2 == 4 then
                pitchValue = 89 -- Set yawValue to 90 when tickcount % 3 == 0
            elseif vars.choke2 == 5 then
                pitchValue = -89 -- Set yawValue to 90 when tickcount % 3 == 0
            elseif vars.choke2 == 6 then
                pitchValue = -45 -- Set yawValue to 90 when tickcount % 3 == 0
            elseif vars.choke2 == 7 then
                pitchValue = -45 -- Set yawValue to 90 when tickcount % 3 == 0
            end
            
            ui.set(refs.pitch[2], math.random(-89, 89))
        elseif ui.get(aaBuilder[vars.pState].defensivePitch) == "Sway" and isDefensive then
            updateValue_pitch()
            ui.set(refs.pitch[1], "Custom")
            ui.set(refs.pitch[2], currentValue2)
        else
            ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
            ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
        end                

        ui.set(refs.yawBase, ui.get(aaBuilder[vars.pState].yawBase))

        ui.set(refs.yaw[1], ui.get(aaBuilder[vars.pState].yaw))

        if not (antibrute_data.final_side == 0) then
            if antibrute_data.final_side == 1 then
                ui.get(aaBuilder[vars.pState].yawRight)
            else
                ui.get(aaBuilder[vars.pState].yawLeft)
            end

        elseif ((func.includes(ui.get(aaBuilder[vars.pState].yawJitterDisablers), "AI Jitter On Lowground" ) and local_on_lowground)) then
            ui.set(refs.yaw[2], side == 1 and client.random_int(10, 21) or client.random_int(-21, 10))
        elseif ui.get(aaBuilder[vars.pState].defensiveYaw) == "Random" and isDefensive then
            local randomyaw = client.random_int(-180, 180)
            ui.set(refs.yaw[2], randomyaw)
        elseif ui.get(aaBuilder[vars.pState].defensiveYaw) == "L/R" and isDefensive then
            ui.set(refs.yaw[2],(side == 1 and ui.get(aaBuilder[vars.pState].defensiveYawLeft) or ui.get(aaBuilder[vars.pState].defensiveYawRight)))  
        elseif ui.get(aaBuilder[vars.pState].defensiveYaw) == "Jitter" and isDefensive then

            if vars.choke2 == 0 then
                yawValue = -77 -- Set yawValue to 90 when tickcount % 3 == 0
            elseif vars.choke2 == 1 then
                yawValue = 77 -- Set yawValue to 90 when tickcount % 3 == 0
            elseif vars.choke2 == 2 then
                yawValue = -77 -- Set yawValue to 90 when tickcount % 3 == 0
            elseif vars.choke2 == 3 then
                yawValue = -45 -- Set yawValue to 90 when tickcount % 3 == 0
            elseif vars.choke2 == 4 then
                yawValue = 45 -- Set yawValue to 90 when tickcount % 3 == 0
            elseif vars.choke2 == 5 then
                yawValue = -45 -- Set yawValue to 90 when tickcount % 3 == 0
            elseif vars.choke2 == 6 then
                yawValue = -77 -- Set yawValue to 90 when tickcount % 3 == 0
            elseif vars.choke2 == 7 then
                yawValue = 45 -- Set yawValue to 90 when tickcount % 3 == 0
            end
            ui.set(refs.yaw[1], "Spin")
            ui.set(refs.yaw[2], yawValue)
        elseif ui.get(aaBuilder[vars.pState].defensiveYaw) == "Spin" and isDefensive then
            tickcount_spin = tickcount_spin + 1 -- Increment tickcount on each tick
            -- Calculate the new yaw value based on tickcount and spin speed
            yawValue_spin = yawValue_spin + (ui.get(aaBuilder[vars.pState].defensiveYawStep) * 10) -- Adjust the multiplier to control the spin speed
            
            -- Update the yaw value in your UI or game logic
        
            -- Reset yawValue to prevent it from becoming too large (optional)
            if yawValue_spin >= 180 then
                yawValue_spin = -180
            else
                ui.set(refs.yaw[2], yawValue_spin)
            end


        elseif ui.get(aaBuilder[vars.pState].defensiveYaw) == "Sway" then
            updateValue(true)
            
            ui.set(refs.yaw[2], currentValue)
        elseif ui.get(aaBuilder[vars.pState].defensiveYaw) == "Custom" and isDefensive then
--            ui.set(refs.yaw[2], "Custom")
            ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].defensiveYawSlider))
        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "L/R" then
            ui.set(refs.yaw[2],(side == 1 and ui.get(aaBuilder[vars.pState].yawLeft) or ui.get(aaBuilder[vars.pState].yawRight)))
        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "Hold" then
            if vars.choke2 == 0 then
                ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawRight))
            elseif vars.choke2 == 1 then
                ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawLeft))
            elseif vars.choke2 == 2 then
                ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawLeft))
            elseif vars.choke2 == 3 then
                ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawLeft))
            elseif vars.choke2 == 4 then
                ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawRight))
            elseif vars.choke2 == 5 then
                ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawLeft))
            elseif vars.choke2 == 6 then
                ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawRight))
            elseif vars.choke2 == 7 then
                ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawRight))
            end

        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "Slow" then
            ui.set(refs.yaw[2], vars.switch and ui.get(aaBuilder[vars.pState].yawLeft) or ui.get(aaBuilder[vars.pState].yawRight))
            side_yaw = 0
        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "Sway" then
            updateValue(false)
            
            ui.set(refs.yaw[2], currentValue)
        else
            ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawStatic))
            side_yaw = 2
        end

        local switch = false
        if ((func.includes(ui.get(aaBuilder[vars.pState].yawJitterDisablers), "High Ground Safety" ) and heightAdvantage) or (func.includes(ui.get(aaBuilder[vars.pState].yawJitterDisablers), "Ensure Head Safety") and safetyAlert)) then
            ui.set(refs.yawJitter[1], "Off") 
        elseif ((func.includes(ui.get(aaBuilder[vars.pState].yawJitterDisablers), "AI Jitter On Lowground" ) and local_on_lowground)) then
            ui.set(refs.yawJitter[1], "Center")
        elseif ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
            ui.set(refs.yawJitter[1], "Center")
        elseif ui.get(aaBuilder[vars.pState].yawJitter) == "Yaw manipulation" then
            ui.set(refs.yawJitter[1], "Center")
        elseif ui.get(aaBuilder[vars.pState].yawJitter) == "AI Jitter" then
            ui.set(refs.yawJitter[1], "Center")
        else
            ui.set(refs.yawJitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
        end


        
            if ui.get(aaBuilder[vars.pState].yawJitterCondition) == "L/R" then
                if ((func.includes(ui.get(aaBuilder[vars.pState].yawJitterDisablers), "AI Jitter On Lowground" ) and local_on_lowground)) then
                    local yaw_method = math.abs(math.ceil((side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) or ui.get(aaBuilder[vars.pState].yawJitterRight)) and AI_Height_Diff or AI_Height_Diff * -1))
                    local lp = entity.get_local_player()
                    local velocity = vector(entity.get_prop(lp, "m_vecVelocity"))
                    local velocity_final = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2)
                    local method = (yaw_method / 1.2) + side == 1 and -velocity_final / 2 or velocity_final / 2
        
                    ui.set(refs.yawJitter[2],globals.tickcount() % 3 == 0 and (side == 1 and math.random(-45, -100) or math.random(45, 100)) or method * 0.5)
                elseif ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                        ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) % get_jitter(0 > ui.get(aaBuilder[vars.pState].yawJitterLeft))*math.random(-1, 1)  or ui.get(aaBuilder[vars.pState].yawJitterRight) % get_jitter(0 > ui.get(aaBuilder[vars.pState].yawJitterRight))*math.random(-1, 1) ))
                    elseif ui.get(aaBuilder[vars.pState].yawJitter) == "Slow Jitter" then
                        ui.set(refs.yaw[2], switch and ui.get(aaBuilder[vars.pState].yawJitterRight) % get_jitter(0 > ui.get(aaBuilder[vars.pState].yawJitterRight)) or ui.get(aaBuilder[vars.pState].yawJitterLeft) % get_jitter(0 > ui.get(aaBuilder[vars.pState].yawJitterLeft)))
                    elseif ui.get(aaBuilder[vars.pState].yawJitter) == "Yaw manipulation" then
                        local yaw_method = globals.tickcount() % 3 == 0 and ui.get(aaBuilder[vars.pState].yawJitterLeft) % get_jitter(0 > ui.get(aaBuilder[vars.pState].yawJitterLeft)) or ui.get(aaBuilder[vars.pState].yawJitterRight) % get_jitter(0 > ui.get(aaBuilder[vars.pState].yawJitterRight))
                        ui.set(refs.yawJitter[2], yaw_method)
                    else
                        ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) % get_jitter(0 > ui.get(aaBuilder[vars.pState].yawJitterLeft)) or ui.get(aaBuilder[vars.pState].yawJitterRight) % get_jitter(0 > ui.get(aaBuilder[vars.pState].yawJitterRight))))
                    end          
                else
                    if ((func.includes(ui.get(aaBuilder[vars.pState].yawJitterDisablers), "AI Jitter On Lowground" ) and local_on_lowground)) then
                        local yaw_method = math.ceil(0 > ui.get(aaBuilder[vars.pState].yawJitterStatic) and AI_Height_Diff or AI_Height_Diff * -1) - (AI_Height_Diff > 0 and ui.get(aaBuilder[vars.pState].yawJitterStatic) or ui.get(aaBuilder[vars.pState].yawJitterStatic) * -1)
                        local lp = entity.get_local_player()
                        local velocity = vector(entity.get_prop(lp, "m_vecVelocity"))
                        local velocity_final = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2)
                        local method = (yaw_method / 1.2) + side == 1 and -velocity_final / 2 or velocity_final / 2
                        ui.set(refs.yawJitter[2],globals.tickcount() % 3 == 0 and (side == 1 and math.random(-45, -100) or math.random(45, 100)) or method * 0.5)
                    elseif  ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                        ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic) % get_jitter(0 > ui.get(aaBuilder[vars.pState].yawJitterStatic))*math.random(-1, 1) )
                    elseif ui.get(aaBuilder[vars.pState].yawJitter) == "Slow Jitter" then
                        ui.set(refs.yaw[2], switch and ui.get(aaBuilder[vars.pState].yawJitterStatic) or -ui.get(aaBuilder[vars.pState].yawJitterStatic))
                    elseif ui.get(aaBuilder[vars.pState].yawJitter) == "Yaw manipulation" then
                        ui.set(refs.yawJitter[2], globals.tickcount() % 3 == 0 and ui.get(aaBuilder[vars.pState].yawJitterStatic)  % get_jitter(0 > ui.get(aaBuilder[vars.pState].yawJitterStatic)) or -ui.get(aaBuilder[vars.pState].yawJitterStatic)  % get_jitter(0 > ui.get(aaBuilder[vars.pState].yawJitterStatic)))
                    else
                        ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic) % get_jitter(0 > ui.get(aaBuilder[vars.pState].yawJitterStatic)))
                    end
                end

        

        if ui.get(aaBuilder[vars.pState].yawCondition) == "Slow" and not ui.get(aaBuilder[vars.pState].bodyYawAllowOverride) and not ui.get(menu.bruteTab.enable) then
            ui.set(refs.bodyYaw[1], "Static")
            ui.set(refs.bodyYaw[2], 0)
        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "Hold" and not ui.get(aaBuilder[vars.pState].bodyYawAllowOverride) and not ui.get(menu.bruteTab.enable) then
            ui.set(refs.bodyYaw[1], "Static")
            ui.set(refs.bodyYaw[2], 0)
        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "Slow" and not ui.get(aaBuilder[vars.pState].bodyYawAllowOverride) and ui.get(menu.bruteTab.enable) then
        if ui.get(aaBuilder[vars.pState].desync_type) == "Skeet" then
            if antibrute_data.miss_counter > 0 then
                ui.set(refs.bodyYaw[1],"Static")
                local get_desync_value = get_desync(true)
                ui.set(refs.bodyYaw[2], get_desync_value)
            else
                ui.set(refs.bodyYaw[1], "Static")
                ui.set(refs.bodyYaw[2], 0)
            end
        else
            ui.set(refs.bodyYaw[2], 0)
            local get_desync_value = get_desync(false)
                apply_desync(cmd, get_desync_value)
        end

        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "Hold" and not ui.get(aaBuilder[vars.pState].bodyYawAllowOverride) and ui.get(menu.bruteTab.enable) then
            if ui.get(aaBuilder[vars.pState].desync_type) == "Skeet" then
                if antibrute_data.miss_counter > 0 then
                    ui.set(refs.bodyYaw[1],"Static")
                    local get_desync_value = get_desync(true)
                    ui.set(refs.bodyYaw[2], get_desync_value)
                else
                    ui.set(refs.bodyYaw[1], "Static")
                    ui.set(refs.bodyYaw[2], 0)
                end
            elseif ui.get(aaBuilder[vars.pState].desync_type) == "Interitus" then
                ui.set(refs.bodyYaw[2], 0)
                local get_desync_value = get_desync(false)
                apply_desync(cmd, get_desync_value)
            end
        else
            if (ui.get(aaBuilder[vars.pState].bodyYaw) == "Jitter" or ui.get(aaBuilder[vars.pState].bodyYaw) == "Opposite" or ui.get(aaBuilder[vars.pState].bodyYaw) == "Static" or ui.get(aaBuilder[vars.pState].bodyYaw) == "Off") then
                if ui.get(aaBuilder[vars.pState].desync_type) == "Skeet" then
                ui.set(refs.bodyYaw[1], ui.get(aaBuilder[vars.pState].bodyYaw))
                local get_desync_value = get_desync(true)
                ui.set(refs.bodyYaw[2], get_desync_value)
            elseif ui.get(aaBuilder[vars.pState].desync_type) == "Interitus" then
                ui.set(refs.bodyYaw[2], 0)
                local get_desync_value = get_desync(false)
                apply_desync(cmd, get_desync_value)
                end
            elseif ui.get(aaBuilder[vars.pState].bodyYaw) == "Manipulative" then
                if ui.get(aaBuilder[vars.pState].desync_type) == "Skeet" then
                ui.set(refs.bodyYaw[1],"Static")
                local get_desync_value = get_desync(true)
                ui.set(refs.bodyYaw[2], globals.tickcount() % 3 == 0 and get_desync_value or -get_desync_value)
            elseif ui.get(aaBuilder[vars.pState].desync_type) == "Interitus" then
                ui.set(refs.bodyYaw[2], 0)
                local get_desync_value = get_desync(false)
                apply_desync(cmd, get_desync_value)
                end
            end
        end

        if reversed and ui.get(aaBuilder[vars.pState].antiBruteSet) then
            ui.set(refs.yaw[2], angle)
        end


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

    --safe safe
    if func.includes(ui.get(menu.aaTab.tweaks), "Static On Knife") then
        if entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CKnife" and vars.pState == 8 then
            ui.set(refs.pitch[1], "Default")
            ui.set(refs.yawBase, "At targets")
            ui.set(refs.yaw[1], "180")
            ui.set(refs.yaw[2], 0)
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
            ui.set(refs.bodyYaw[1], "Static")
            ui.set(refs.bodyYaw[2], 0)
            ui.set(refs.fsBodyYaw, false)
            ui.set(refs.edgeYaw, false)
            ui.set(refs.roll, 0)
        end
    end
end



client.set_event_callback("setup_command", function(cmd)
    vars.cmd = cmd
    vars.localPlayer = entity.get_local_player()

    aa_builder(cmd)
    antibrute_resetter()

    -- fix hideshots
	if func.includes(ui.get(menu.aaTab.tweaks), "Hideshots Fix") then
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

    distance_knife = {}
    distance_knife.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    end


    -- Avoid backstab
    if ui.get(menu.aaTab.avoidBackstab) ~= 0 then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        if players == nil then return end
        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = distance_knife.anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(menu.aaTab.avoidBackstab) then
                ui.set(refs.yaw[2], 180)
                ui.set(refs.yawBase, "At targets")
            end
        end
    end
    
    -- dt discharge
    if func.includes(ui.get(menu.aaTab.tweaks), "Automatic Exploit Release") then
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
    if func.includes(ui.get(menu.miscTab.tweaks), "Fast Ladder") then
        local pitch, yaw = client.camera_angles()
        if entity.get_prop(vars.localPlayer, "m_MoveType") == 9 then
            cmd.yaw = math.floor(cmd.yaw+0.5)
            cmd.roll = 0
    
            if func.includes(ui.get(menu.miscTab.fastLadder), "Ascending") then
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
            if func.includes(ui.get(menu.miscTab.fastLadder), "Descending") then
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
    ui.set(refs.edgeYaw, ui.get(menu.aaTab.manualTab.edgeYawHotkey))
end)

client.set_event_callback("setup_command", function(e)
    if not vars.localPlayer or not entity.is_alive(vars.localPlayer) or not ui.get(masterSwitch) then return end
	local flags = entity.get_prop(vars.localPlayer, "m_fFlags")
    local onground = bit.band(flags, 1) ~= 0 and e.in_jump == 0
    local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])

    local air = func.includes(ui.get(menu.aaTab.manualTab.freestandDisablers), "Air") and not onground
    local duck = func.includes(ui.get(menu.aaTab.manualTab.freestandDisablers), "Duck") and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1
    local slow = func.includes(ui.get(menu.aaTab.manualTab.freestandDisablers), "Slowmo") and isSlow
    local manul = func.includes(ui.get(menu.aaTab.manualTab.freestandDisablers), "Manual") and (aa.manualAA == 2 or aa.manualAA == 1) and aa.ignore
    local fs_disabler = air or duck or slow or manul

    if ui.get(menu.aaTab.manualTab.freestandHotkey) and not fs_disabler then
        vars.fs = true
        ui.set(refs.freeStand[2], "Always on")
        ui.set(refs.freeStand[1], true)
        ui.set(refs.pitch[1], "Minimal")

        if ui.get(menu.aaTab.manualTab.freestandstatic) == "Static" then
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
            ui.set(refs.yaw[2], 0)
            ui.set(refs.bodyYaw[1], "Static")
            ui.set(refs.bodyYaw[2], 180)
            
        end

        if ui.get(menu.aaTab.manualTab.freestandstatic) == "Jitter" then
            ui.set(refs.yawJitter[1], "Center")
            ui.set(refs.yawJitter[2], ui.get(menu.aaTab.manualTab.freestand_jitterValue))
            ui.set(refs.yaw[2], 0)
            ui.set(refs.bodyYaw[1], "Static")
            ui.set(refs.bodyYaw[2], 180)
        end

    else
        vars.fs = false
        ui.set(refs.freeStand[1], false)
        ui.set(refs.freeStand[2], "On hotkey")
    end    
end)

client.set_event_callback("setup_command", function(cmd)

    
    local using = true
    local defusing = false
    vars.should_disable = false

    if entity.get_classname(entity.get_player_weapon(vars.localPlayer)) == "CC4" then
        vars.should_disable = true
        return
    end

    local planted_bomb = entity.get_all("CPlantedC4")[1]
    local classnames = {"CWorld","CCSPlayer","CFuncBrush","CPropDoorRotating","CHostage"}

    if planted_bomb ~= nil then
        local bomb_distance = vector(entity.get_origin(vars.localPlayer)):dist(vector(entity.get_origin(planted_bomb)))
        
        if bomb_distance <= 64 and entity.get_prop(vars.localPlayer, "m_iTeamNum") == 3 then
            vars.should_disable = true
            defusing = true
        end
    end

    local pitch, yaw = client.camera_angles()
    local direct_vec = vector(func.vec_angles(pitch, yaw))

    local eye_pos = vector(client.eye_position())
    local fraction, ent = client.trace_line(vars.localPlayer, eye_pos.x, eye_pos.y, eye_pos.z, eye_pos.x + (direct_vec.x * 8192), eye_pos.y + (direct_vec.y * 8192), eye_pos.z + (direct_vec.z * 8192))

    local using = true

    if ent ~= nil and ent ~= -1 then
        for i=0, #classnames do
            if entity.get_classname(ent) == classnames[i] then
                using = false
            end
        end
    end

--    local key = ui.get(menu.aaTab.BombEfix)
end)

local function clantag_set()
    local lua_name = "interitus.red"
    if func.includes(ui.get(menu.miscTab.tweaks), "Clantag Spammer") then
        ui.set(ui.reference("Misc", "Miscellaneous", "Clan tag spammer") , false)

		local clan_tag = clantag_anim(lua_name, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 14,14,14,14,14,14, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25})

        if entity.get_prop(entity.get_game_rules(), "m_gamePhase") == 5 then
            clan_tag = clantag_anim('✩ interitus.red', {14})
            client.set_clan_tag(clan_tag)
        elseif entity.get_prop(entity.get_game_rules(), "m_timeUntilNextPhaseStarts") ~= 0 then
            clan_tag = clantag_anim('✬ interitus.red', {14})
            client.set_clan_tag(clan_tag)
        elseif clan_tag ~= clantag.prev_ct  then
            client.set_clan_tag(clan_tag)
        end

        clantag.prev_ct = clan_tag
        clantag.enb = true
    elseif clantag.enb == true then
        client.set_clan_tag(get_original_clantag())
        clantag.enb = false
    end
end

clantag.paint = function()
    if entity.get_local_player() ~= nil then
        if globals.tickcount() % 2 == 1 then
            clantag_set()
        end
    end
end

clantag.run_command = function(e)
    if entity.get_local_player() ~= nil then 
        if e.chokedcommands == 0 then
            clantag_set()
        end
    end
end

clantag.player_connect_full = function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then 
        clantag.orig_ct = get_original_clantag()
    end
end

clantag.shutdown = function()
    client.set_clan_tag(get_original_clantag())
end

client.set_event_callback("paint", clantag.paint)
client.set_event_callback("run_command", clantag.run_command)
client.set_event_callback("player_connect_full", clantag.player_connect_full)
client.set_event_callback("shutdown", clantag.shutdown)

client.set_event_callback("player_death", function(e)
    if func.includes(ui.get(menu.miscTab.tweaks), "Trashtalk Spammer") then trashtalk(e) end
end)

client.set_event_callback("aim_miss", function(e)


    local callback = func.includes(ui.get(menu.visualsTab.logs), "Aimbot") and func.includes(ui.get(menu.visualsTab.visuals), "Logging")
    if not callback then return end
    onMiss(e)
end)

client.set_event_callback("aim_hit", function(e)


    local callback = func.includes(ui.get(menu.visualsTab.logs), "Aimbot") and func.includes(ui.get(menu.visualsTab.visuals), "Logging")
    if not callback then return end
    onHit(e)
end)

client.set_event_callback("player_death", function(e)
    local v, a = e.userid, e.attacker
    local lp_death = client.userid_to_entindex(v)
    if lp_death ~= entity.get_local_player() then return end
    local r, g, b, a = ui.get(menu.visualsTab.logsClr)

    if lp_death then
        if func.includes(ui.get(menu.visualsTab.logs), "Anti-Aim") and func.includes(ui.get(menu.visualsTab.visuals), "Logging") then
            notifications.new("$Anti-Brute$ resetted due to $local death$", r, g, b)   
        end
        antibrute_data.miss_counter = 0
        antibrute_data.entity = nil
        antibrute_data.entity2 = nil
        client.delay_call(1, notifications.clear)
    end

end)

client.set_event_callback("player_connect_full", function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then 
        notifications.clear()
    end
end)

local legsTypes = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
local ground_ticks = 0
client.set_event_callback("setup_command", function(e)
    local is_on_ground = e.in_jump == 0
    if func.includes(ui.get(menu.miscTab.animations), "Leg fucker") then
        if func.includes(ui.get(menu.miscTab.animations), "Leg fucker") then
            ui.set(refs.legMovement, e.command_number % 3 == 0 and "Off" or "Always slide")
        end
    end
end)
client.set_event_callback("bullet_impact", function(e)
    antibrute(e)
end)

local char_ptr = ffi.typeof('char*')
local class_ptr = ffi.typeof('void***')

do
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
    local legsSaved = false
local legsTypes = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
client.set_event_callback("pre_render", function()
    local lp = entity.get_local_player()
    if not lp then return end
    if func.includes(ui.get(menu.miscTab.tweaks), "Anim Breakers") == false then return end
    local flags = entity.get_prop(lp, "m_fFlags")

    local pEnt = ffi.cast(class_ptr, native_GetClientEntity(lp))

    if pEnt == nullptr then
        return
    end

    local anim_layers = ffi.cast(animation_layer_t, ffi.cast(char_ptr, pEnt) + 0x2990)[0][6]

    ground_ticks = bit.band(flags, 1) == 0 and 0 or (ground_ticks < 5 and ground_ticks + 1 or ground_ticks)

    if func.includes(ui.get(menu.miscTab.animations), "Static Legs In Air") and bit.band(flags, 1) == 0 then
        entity.set_prop(lp, "m_flPoseParameter", 1, 6)
    end

	local velocity = vector(entity.get_prop(lp, "m_vecVelocity"))
	local pStill = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2) < 5

    if func.includes(ui.get(menu.miscTab.animations), "Moonwalk") and not pStill then
        anim_layers.weight = 1
    end

    if func.includes(ui.get(menu.miscTab.animations), "Leg Fucker") then
        entity.set_prop(lp, "m_flPoseParameter", 1, globals.tickcount() % 4 > 1 and 0.5 / 10 or 1)
    end

    if func.includes(ui.get(menu.miscTab.animations), "Zero Pitch On Land") then
        ground_ticks = bit.band(flags, 1) == 1 and ground_ticks + 1 or 0

        if ground_ticks > 20 and ground_ticks < 150 then
            entity.set_prop(lp, "m_flPoseParameter", 0.5, 12)
        end
    end

    if func.includes(ui.get(menu.miscTab.animations), "Static Legs") then
        if not (vars.pState == 7) and not (vars.pState == 8) then
        entity.set_prop(lp, "m_flPoseParameter", 0, 8)
        entity.set_prop(lp, "m_flPoseParameter", 0, 9)
        entity.set_prop(lp, "m_flPoseParameter", 0, 10)
        end
    end
end)
end
-- @region AA_CALLBACKS end

-- @region INDICATORS start
local alpha = 0
local scopedFraction = 0
local interitus_x_anim = 0
local x_add_dt = 0

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
local value = 0
local once1 = false
local once2 = false
local dt_a = 0
local dt_y = 45
local dt_x = 0
local dt_w = 0
local os_a = 0
local os_y = 45
local os_x = 0
local os_w = 0
local fs_a = 0
local fs_y = 45
local fs_x = 0
local fs_w = 0
local n_x = 0
local n2_x = 0
local n3_x = 0
local n4_x = 0
local testx = 0
local aaa = 0
local lele = 0
local hitler = {}

hitler.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

function animation(check, start_val, end_val, speed) 
	if check then 
		return math.max(start_val + (end_val - start_val) * globals.frametime() * speed, 0)
	else 
		return math.max(start_val - (end_val + start_val) * globals.frametime() * speed/2, 0)
	end
end

local indicators_anims = {
    dtxpos = 0,
    dtypos = 0,
    chargexpos = 0,

    osalypos = 0,
    
}

function quint_in(t, b, c, d)
    t = t / d
    return c * t * t * t * t * t + b
end
local dt_charged_indi, shift_indi, charged_indi
client.set_event_callback("paint", function()
    notifications.render()
    local local_player = entity.get_local_player()
    local textWidth = 0 
    local textHeight = 10
    local sizeX, sizeY = client.screen_size()
    local centerX = sizeX / 2 - textWidth / 2
    
    local centerY = sizeY - textHeight
    local bodyYaw = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
    local side = bodyYaw > 0 and 1 or -1
    
    if ui.get(menu.visualsTab.watermark) == "Bottom" and (ui.get(menu.visualsTab.watermark_type) == "INTERITUS" or ui.get(menu.visualsTab.watermark_type) == "INTERITUS.RED") then
        local text = '  [RENEWED]'
    local length = #text + 1
    local light = ''
    
    local anim_type = -1
    local watermark_color = {}
    watermark_color.r, watermark_color.g, watermark_color.b, watermark_color.a = ui.get(menu.visualsTab.watermark_color)

    local main_color = { watermark_color.r, watermark_color.g, watermark_color.b }
    local back_color = { watermark_color.r, watermark_color.g, watermark_color.b }
    for idx = 1, length do
        local letter = text:sub(idx, idx)

        local factor = (idx - 1) / length
        local breathe = breathe(anim_type * factor * 1.5, 1.5)

        local r, g, b, a = lerp({ main_color[1], main_color[2], main_color[3], 255 }, { back_color[1], back_color[2], back_color[3], 55 }, breathe)

        local hex_color = hex(r, g, b, a)
        light = light .. (hex_color .. letter)
    end

    local final_text = ui.get(menu.visualsTab.watermark_type) == "INTERITUS" and (side == -1 and func.gradient_text(watermark_color.r, watermark_color.g, watermark_color.b, 255, watermark_color.r, watermark_color.g, watermark_color.b, 55, "I N T E R I T U S") or func.gradient_text(watermark_color.r, watermark_color.g, watermark_color.b, 55, watermark_color.r, watermark_color.g, watermark_color.b, 255, "I N T E R I T U S")) or (side == -1 and func.gradient_text(watermark_color.r, watermark_color.g, watermark_color.b, 255, watermark_color.r, watermark_color.g, watermark_color.b, 55, "I N T E R I T U S . R E D") or func.gradient_text(watermark_color.r, watermark_color.g, watermark_color.b, 55, watermark_color.r, watermark_color.g, watermark_color.b, 255, "I N T E R I T U S . R E D"))

        renderer.text(centerX, centerY, 255, 255, 255, 255, "c", nil,final_text .. light )
    elseif ui.get(menu.visualsTab.watermark) == "Left" and (ui.get(menu.visualsTab.watermark_type) == "INTERITUS" or ui.get(menu.visualsTab.watermark_type) == "INTERITUS.RED") then
        local text = '  [RENEWED]'
        local length = #text + 1
        local light = ''

        local watermark_color = {}
        watermark_color.r, watermark_color.g, watermark_color.b, watermark_color.a = ui.get(menu.visualsTab.watermark_color)


        local main_color = { watermark_color.r, watermark_color.g, watermark_color.b }
        local back_color = { watermark_color.r, watermark_color.g, watermark_color.b }
        local anim_type = -1
    
        for idx = 1, length do
            local letter = text:sub(idx, idx)
    
            local factor = (idx - 1) / length
            local breathe = breathe(anim_type * factor * 1.5, 1.5)
    
            local r, g, b, a = lerp({ main_color[1], main_color[2], main_color[3], 255 }, { back_color[1], back_color[2], back_color[3], 55 }, breathe)
    
            local hex_color = hex(r, g, b, a)
            light = light .. (hex_color .. letter)
        end

      

        local final_text = ui.get(menu.visualsTab.watermark_type) == "INTERITUS" and (side == -1 and func.gradient_text(watermark_color.r, watermark_color.g, watermark_color.b, 255, watermark_color.r, watermark_color.g, watermark_color.b, 55, "I N T E R I T U S") or func.gradient_text(watermark_color.r, watermark_color.g, watermark_color.b, 55, watermark_color.r, watermark_color.g, watermark_color.b, 255, "I N T E R I T U S")) or (side == -1 and func.gradient_text(watermark_color.r, watermark_color.g, watermark_color.b, 255, watermark_color.r, watermark_color.g, watermark_color.b, 55, "I N T E R I T U S . R E D") or func.gradient_text(watermark_color.r, watermark_color.g, watermark_color.b, 55, watermark_color.r, watermark_color.g, watermark_color.b, 255, "I N T E R I T U S . R E D"))

        renderer.text(10, centerY / 2 + 5, 255, 255, 255, 255, "", nil,final_text .. light )

    else
        if ui.get(menu.visualsTab.watermark_type) == "Legacy" then
        local text = '  [RENEWED]'
        local length = #text + 1
        local light = ''
        local main_color = { 255, 115, 105, 255 }
        local back_color = { 100, 30, 30 }
        local anim_type = -1
        
        local watermark_color = {}
        watermark_color.r, watermark_color.g, watermark_color.b, watermark_color.a = ui.get(menu.visualsTab.watermark_color)

        local final_text = side == -1 and func.gradient_text(watermark_color.r, watermark_color.g, watermark_color.b, 255, watermark_color.r, watermark_color.g, watermark_color.b, 55, "INTERITUS.RED") or func.gradient_text(watermark_color.r, watermark_color.g, watermark_color.b, 55, watermark_color.r, watermark_color.g, watermark_color.b, 255, "INTERITUS.RED")

        renderer.text(centerX + 1, (centerY - 10) + 1, 0,0,0,255, "cb", 0, "INTERITUS.RED")
        renderer.text(centerX + 1, (centerY - 10) - 1, 0,0,0,255, "cb", 0, "INTERITUS.RED")
        renderer.text(centerX - 1, (centerY - 10) - 1, 0,0,0,255, "cb", 0, "INTERITUS.RED")
        renderer.text(centerX - 1, (centerY - 10) + 1, 0,0,0,255, "cb", 0, "INTERITUS.RED")
        renderer.text(centerX, centerY - 10, 255, 255, 255, 255, "cb", nil, final_text)
        renderer.text(centerX, centerY, watermark_color.r, watermark_color.g, watermark_color.b, watermark_color.a, "-c", nil, userdata.username:upper())
        end

        if ui.get(menu.visualsTab.watermark_type) == "Country" then
            local flagimg = renderer.load_png(download, 25, 15)
            if flagimg ~= nil and download ~= nil then
                local mainY = 35
                local marginX, marginY = renderer.measure_text("-d", lua_name:upper())
                local watermark_color = {}
        watermark_color.r, watermark_color.g, watermark_color.b, watermark_color.a = ui.get(menu.visualsTab.watermark_color)
                renderer.gradient(2.5, sizeY/2 + mainY - 2, marginX*2, marginY*2 - 1, watermark_color.r, watermark_color.g, watermark_color.b, 255, watermark_color.r, watermark_color.g, watermark_color.b, 0, true)
                renderer.texture(flagimg, 5, sizeY/2 + mainY, 25, marginY*1.4, 255, 255, 255, 255, "f")
                renderer.text(33, sizeY/2 - 2 + mainY, 255, 255, 255, 255, "-d", nil, "INTERITUS" .. func.hex({watermark_color.r, watermark_color.g, watermark_color.b}) .. ".RED")
                renderer.text(33, sizeY/2 - 4 + marginY + mainY, 255, 255, 255, 255, "-d", nil, func.hex({watermark_color.r, watermark_color.g, watermark_color.b}) .. "[RENEWED]")
            else
                downloadFile()
            end
        end

        if ui.get(menu.visualsTab.watermark_type) == "Trans" then


            if readfile("trans.png") ~= nill and download ~= nil then
                local mainY = 35
                local marginX, marginY = renderer.measure_text("-d", lua_name:upper())
                local watermark_color = {}
                watermark_color.r, watermark_color.g, watermark_color.b, watermark_color.a = ui.get(menu.visualsTab.watermark_color)
                renderer.gradient(2.5, sizeY/2 + mainY - 2, marginX*2, marginY*2 - 1, watermark_color.r, watermark_color.g, watermark_color.b, 255, watermark_color.r, watermark_color.g, watermark_color.b, 0, true)
                --renderer.texture(flagimg, 5, sizeY/2 + mainY, 25, marginY*1.4, 255, 255, 255, 255, "f")
                local flagimg = images.load_png(readfile("trans.png"))
                flagimg:draw(5, sizeY/2 + mainY, 25, marginY*1.4, 255, 255, 255, 255, 255, "f")

                renderer.text(33, sizeY/2 - 2 + mainY, 255, 255, 255, 255, "-d", nil, "INTERITUS" .. func.hex({watermark_color.r, watermark_color.g, watermark_color.b}) .. ".RED")
                renderer.text(33, sizeY/2 - 4 + marginY + mainY, 255, 255, 255, 255, "-d", nil, func.hex({watermark_color.r, watermark_color.g, watermark_color.b}) .. "[RENEWED]")
            else
                downloadFile()
            end
        end
    end

    if local_player == nil or entity.is_alive(local_player) == false then return end
    local weapon = entity.get_player_weapon(local_player)
    local state = vars.intToS[vars.pState]:upper()
    -- local mainClr = {}
    -- mainClr.r, mainClr.g, mainClr.b, mainClr.a = ui.get(menu.visualsTab.indicatorsClr)
    local arrowClr = {}
    arrowClr.r, arrowClr.g, arrowClr.b, arrowClr.a = ui.get(menu.visualsTab.arrowClr)
    local fake = math.floor(antiaim_funcs.get_desync(1))

    local indicators = 0

    -- draw arrows
    local is_arrows = func.includes(ui.get(menu.visualsTab.visuals), "Arrows")
    local side = bodyYaw > 0 and 1 or -1
    local velocity = vector(entity.get_prop(vars.localPlayer, "m_vecVelocity"))
    local speed = math.sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y) + (velocity.z * velocity.z))
    if is_arrows then
        if ui.get(menu.visualsTab.arrowIndicatorStyle) == "Standart" then
            alpha = (aa.manualAA == 2 or aa.manualAA == 1) and func.lerp(alpha, 255, globals.frametime() * 20) or func.lerp(alpha, 0, globals.frametime() * 20)
            renderer.text(sizeX / 2 + 45, sizeY / 2 - 2.5, aa.manualAA == 2 and arrowClr.r or 200, aa.manualAA == 2 and arrowClr.g or 200, aa.manualAA == 2 and arrowClr.b or 200, alpha, "c+", 0, '>')
            renderer.text(sizeX / 2 - 45, sizeY / 2 - 2.5, aa.manualAA == 1 and arrowClr.r or 200, aa.manualAA == 1 and arrowClr.g or 200, aa.manualAA == 1 and arrowClr.b or 200, alpha, "c+", 0, '<')
        end
        if ui.get(menu.visualsTab.arrowIndicatorStyle) == "TeamSkeet Dynamic" then
            if speed ~= nil then
                renderer.triangle(sizeX / 2 + 25 - speed/10 + 35, sizeY / 2 + 2, sizeX / 2 + 37 - speed/10 + 35, sizeY / 2 - 7, sizeX / 2 + 37 - speed/10 + 35, sizeY / 2 + 11, 
                aa.manualAA == 2 and arrowClr.r or 25, 
                aa.manualAA == 2 and arrowClr.g or 25, 
                aa.manualAA == 2 and arrowClr.b or 25, 
                aa.manualAA == 2 and arrowClr.a or 160)
        
                renderer.triangle(sizeX / 2 - 25 + speed/10 - 35, sizeY / 2 + 2, sizeX / 2 - 37 + speed/10 - 35, sizeY / 2 - 7, sizeX / 2 - 37 + speed/10 - 35, sizeY / 2 + 11, 
                aa.manualAA == 1 and arrowClr.r or 25, 
                aa.manualAA == 1 and arrowClr.g or 25, 
                aa.manualAA == 1 and arrowClr.b or 25, 
                aa.manualAA == 1 and arrowClr.a or 160)
                
                renderer.rectangle(sizeX / 2 + 38 - speed/10 + 35, sizeY / 2 - 7, 2, 18, 
                side == 1 and arrowClr.r or 25,
                side == 1 and arrowClr.g or 25,
                side == 1 and arrowClr.b or 25,
                side == 1 and arrowClr.a or 160)
                renderer.rectangle(sizeX / 2 - 40 + speed/10 - 35, sizeY / 2 - 7, 2, 18,			
                side == -1 and arrowClr.r or 25,
                side == -1 and arrowClr.g or 25,
                side == -1 and arrowClr.b or 25,
                side == -1 and arrowClr.a or 160)
            end
        end
        if ui.get(menu.visualsTab.arrowIndicatorStyle) == "Teamskeet Static" then
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
            side == 1 and arrowClr.r or 25,
            side == 1 and arrowClr.g or 25,
            side == 1 and arrowClr.b or 25,
            side == 1 and arrowClr.a or 160)
            renderer.rectangle(sizeX / 2 - 40, sizeY / 2 - 7, 2, 18,			
            side == -1 and arrowClr.r or 25,
            side == -1 and arrowClr.g or 25,
            side == -1 and arrowClr.b or 25,
            side == -1 and arrowClr.a or 160)
        end
    end

    -- move on scope
    local scopeLevel = entity.get_prop(weapon, 'm_zoomLevel')
    local scoped = entity.get_prop(local_player, 'm_bIsScoped') == 1
    local resumeZoom = entity.get_prop(local_player, 'm_bResumeZoom') == 1
    local isValid = weapon ~= nil and scopeLevel ~= nil
    local act = isValid and scopeLevel > 0 and scoped and not resumeZoom
    local time = globals.frametime() * 10

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
    
    -- draw dmg indicator
    if func.includes(ui.get(menu.visualsTab.visuals), "Show Minimum Damage") and entity.get_classname(weapon) ~= "CKnife" and ui.get(refs.dmgOverride[1]) and ui.get(refs.dmgOverride[2]) then
        local dmg = ui.get(refs.dmgOverride[3])
        renderer.text(sizeX / 2 + 2, sizeY / 2 - 14, 255, 255, 255, 255, "d", 0, dmg)
    end

    x_add_dt = animation(scoped, x_add_dt, 27, 13) or 0
    interitus_x_anim = animation(scoped, interitus_x_anim, 40, 10) or 0

    if (func.includes(ui.get(menu.visualsTab.visuals), "Indicators")) then
        local string = state:lower()
        local flag = "c"
        local stateX, stateY = renderer.measure_text(flag, state:upper())
        local namex, namey = renderer.measure_text(flag, flag == "c-" and lua_name:upper() or lua_name:upper())
        local text = "interitus"

        local m_nTickBase = entity.get_prop(entity.get_local_player(), 'm_nTickBase')
        local client_latency = client.latency()
        shift_indi = math.floor(m_nTickBase - globals.tickcount() - toticks(client_latency) * .5 + .5 * (client_latency * 10))
        local shift_curr = math.floor(m_nTickBase - globals.tickcount() - toticks(client_latency) * .5 + .5 * (client_latency * 10))
    
        local wanted = -14 + (ui.get(refs.doubletap.fakelag_limit) - 1) + 3 --error margin
        
        local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])

        if isDt then
            if shift_curr - 3 < wanted then
                charged_indi = true
            end
        else
            charged_indi = false
        end
        -- print(string.format("shift: %s wanted: %s tickbase: %s", shift, wanted, m_nTickBase))

        local length = #text + 1

        local light = ''

        local indicator_color = {}
        indicator_color.r, indicator_color.g, indicator_color.b, indicator_color.a = ui.get(menu.visualsTab.indicator_color)


        local main_color = { indicator_color.r, indicator_color.g, indicator_color.b }
        local back_color = { indicator_color.r, indicator_color.g, indicator_color.b }
        local anim_type = -1
    
        for idx = 1, length do
            local letter = text:sub(idx, idx)
    
            local factor = (idx - 1) / length
            local breathe = breathe(anim_type * factor * 1.5, 1.5)
    
            local r, g, b, a = lerp({ main_color[1], main_color[2], main_color[3], 255 }, { back_color[1], back_color[2], back_color[3], 100 }, breathe)
    
            local hex_color = hex(r, g, b, a)
            light = light .. (hex_color .. letter)
        end

        local text_x, text_y = renderer.measure_text(flag, text)
        local x = sizeX/2 - 18 + interitus_x_anim
        local y = sizeY/2 + 20
        local w = text_x - 2
        local h =  0
        local rounding = 25
        local accent = indicator_color
        local thickness = 1
        local Offset = 0
        local accent_inner = 25, 255, 25, 255
        local width = 13
        local r, g, b, a = indicator_color.r, indicator_color.g, indicator_color.b, 75

        for k = 0, width do
            if a * (k/width)^(1) > 5 then
                local accent = {r, g, b, a * (k/width)^(2)}
                func.rec_outline(x + (k - width - Offset)*thickness, y + (k - width - Offset) * thickness, w - (k - width - Offset)*thickness*2, h + 1 - (k - width - Offset)*thickness*2, rounding + thickness * (width - k + Offset), thickness, accent)
            end
        end

        local isCharged = antiaim_funcs.get_double_tap()
        local isFs = ui.get(menu.aaTab.manualTab.freestandHotkey)
        local isBa = ui.get(refs.forceBaim)
        local isSp = ui.get(refs.safePoint)
        local isQp = ui.get(refs.quickPeek[2])
        local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
        local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
        local isFd = ui.get(refs.fakeDuck)

        local test2 = math.floor((sizeY + 35 + 255 / 31 + 0 / 31 + 0 / 31 + 0 / 31)) 

        renderer.text(sizeX/2 + interitus_x_anim, sizeY/2 + 10 + namey/1.2, 255, 255, 255, 255, flag, 0, light)
        renderer.text(sizeX/2 + interitus_x_anim, sizeY/2 + 20 + namey/1.2, 255, 255, 255, 255, "c", 0, string)
        
        local lp = entity.get_local_player()
        local next_attack = entity.get_prop(lp, "m_flNextAttack")
		local next_primary_attack = entity.get_prop(entity.get_player_weapon(lp), "m_flNextPrimaryAttack")
		--local dt_active = not (math.max(next_primary_attack, next_attack) > globals.curtime()) --or (ctx.helpers.defensive and ctx.helpers.defensive > ui.get(ctx.ref.dt_fl))
        local get_charge = func.get_charge()
        local threat = client.current_threat()
        indicators_anims.dtypos = animation(isDt, indicators_anims.dtypos, 10, 15) or 0

        indicators_anims.dtxpos = animation(get_charge and charged_indi, indicators_anims.dtxpos, 15, 15) or 0
        indicators_anims.chargexpos = animation(isCharged, indicators_anims.chargexpos, 10, 15) or 0
        indicators_anims.osalypos = animation(isOs, indicators_anims.osalypos, 10, 15) or 0
        
        if indicators_anims.dtypos > 6 then
            if indicators_anims.dtxpos > 3 then
                renderer.text(interitus_x_anim + sizeX/2 - indicators_anims.dtxpos + 1, sizeY/2 + 30 + indicators_anims.dtypos, 255, 255, 255, 255, "c", 0, "dt")
                    renderer.text(interitus_x_anim + sizeX/2 + indicators_anims.dtxpos - 9, sizeY/2 + 30 + indicators_anims.dtypos, indicator_color.r, indicator_color.g, indicator_color.b, 255, "c", 0, "ready")
                else
                    renderer.text(interitus_x_anim + sizeX/2, sizeY/2 + 30 + indicators_anims.dtypos, 155, 0, 0, 255, "c", 0, "charging")
            end
        end

        if indicators_anims.osalypos > 6 and not (indicators_anims.dtypos > 6) then
            renderer.text(interitus_x_anim + sizeX/2, sizeY/2 + 30 + indicators_anims.osalypos, indicator_color.r, indicator_color.g, indicator_color.b, 255, "c", 0, "onshot")
        end

    end

    -- draw watermark
    -- if indicators == 0 then
    --     local watermarkX, watermarkY = renderer.measure_text("cd-", "")
    --     local lua_watermarkname = ''
    --     local logo = animate_text(globals.curtime(), globalFlag == "cd-" and lua_watermarkname:upper() or lua_watermarkname:upper(), mainClr.r, mainClr.g, mainClr.b, 255)
    --     renderer.text(sizeX/2-watermarkX/2+24, sizeY/1.025,  mainClr.r, mainClr.g, mainClr.b, 255, "c", 0, unpack(logo))
    -- end

    -- draw logs
end)
-- @region INDICATORS end

--Console
local u8, device, localize, surface, notify = {}, {}, {}, {}, {}

do 
    function u8:len(s)
        return #s:gsub("[\128-\191]", "");
    end

    local string_mod; do
        local float = 0;
        local to_alpha = 1 / 255;

        local function fn(rgb, alpha)
            return string.format("%s%02x", rgb, float * tonumber(alpha, 16));
        end

        function string_mod(s, alpha)
            float = alpha * to_alpha;
            return s:gsub("(\a%x%x%x%x%x%x)(%x%x)", fn);
        end
    end

    function device:on_update()
        local new_rect = vector(client.screen_size());

        if new_rect ~= self.rect then
            self.rect = new_rect;
        end
    end

    function device:draw_text(x, y, r, g, b, a, flags, max_width, ...)
        local text = table.concat {...};
        text = string.mod(text, a);

        renderer.text(x, y, r, g, b, a, flags, max_width, text);
    end

    local native_ConvertAnsiToUnicode = vtable_bind("localize.dll", "Localize_001", 15, "int(__thiscall*)(void* thisptr, const char *ansi, wchar_t *unicode, int buffer_size)")
    local native_ConvertUnicodeToAnsi = vtable_bind("localize.dll", "Localize_001", 16, "int(__thiscall*)(void* thisptr, wchar_t *unicode, char *ansi, int buffer_size)")

    function localize:ansi_to_unicode(ansi, unicode, buffer_size)
        return native_ConvertAnsiToUnicode(ansi, unicode, buffer_size);
    end

    function localize:unicode_to_ansi(ansi, unicode, buffer_size)
        return native_ConvertUnicodeToAnsi(ansi, unicode, buffer_size);
    end

    local native_SetTextFont = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 23, "void*(__thiscall*)(void *thisptr, dword font_id)");
    local native_SetTextColor = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 25, "void*(__thiscall*)(void *thisptr, int r, int g, int b, int a)");
    local native_SetTextPos = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 26, "void*(__thiscall*)(void *thisptr, int x, int y)");
    local native_DrawPrintText = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 28, "void*(__thiscall*)(void *thisptr, const wchar_t *text, int maxlen, int draw_type)");

    local native_GetTextSize = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 79, "void(__thiscall*)(void *thisptr, size_t font, const wchar_t *text, int &wide, int &tall)");

    local native_GetFontName = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 134, "const char*(__thiscall*)(void *thisptr, size_t font)");

    local buffer = ffi.new("wchar_t[65535]");
    local wide, tall = ffi.new("int[1]"), ffi.new("int[1]");

    local to_alpha = 1 / 255;

    function surface:get_font_name(font_id)
        return ffi.string(native_GetFontName(font_id));
    end

    function surface:text(font, x, y, r, g, b, a, ...)
        local text = table.concat {...};
        localize:ansi_to_unicode(text, buffer, 65535);

        native_GetTextSize(font, buffer, wide, tall);

        native_SetTextFont(font);
        native_SetTextPos(x, y);
        native_SetTextColor(r, g, b, a);

        native_DrawPrintText(buffer, u8:len(text), 0);

        return wide[0], tall[0];
    end

    function surface:color_text(font, x, y, r, g, b, a, ...)
        local text = table.concat {...};
        local i, j = text:find "\a";

        if i ~= nil then
            x = x + self:text(font, x, y, r, g, b, a, text:sub(1, i - 1))

            while i ~= nil do
                local new_r, new_g, new_b, new_a = r, g, b, a;

                if text:sub(i, j + 7) == "\adefault" then
                    text = text:sub(1 + j + 7);
                else
                    local hex = text:sub(i + 1, j + 8);
                    text = text:sub(1 + j + 8);

                    new_r, new_g, new_b, new_a = func.frgba(hex);
                    new_a = new_a * (a * to_alpha);
                end

                i, j = text:find "\a";

                local new_text = text;

                if i ~= nil then
                    new_text = text:sub(1, i - 1);
                end

                x = x + self:text(font, x, y, new_r, new_g, new_b, new_a, new_text);
            end

            return;
        end

        self:text(font, x, y, r, g, b, a, text);
    end

    local native_ConsoleIsVisible = vtable_bind("engine.dll", "VEngineClient014", 11, "bool(__thiscall*)(void*)");
    local native_ColorPrint = vtable_bind("vstdlib.dll", "VEngineCvar007", 25, "void(__cdecl*)(void*, const color_t&, const char*, ...)");

    local queue = {};
    local current;

    local times = 6;
    local duration = 8;

    local buffer = ffi.new("color_t");
    local to_alpha = 1 / 255;

    local function color_print(r, g, b, a, ...)
        buffer.r, buffer.g, buffer.b, buffer.a = r, g, b, a;
        native_ColorPrint(buffer, ...);
    end

    function notify:color_log(r, g, b, a, ...)
        local text = table.concat {...};
        local i, j = text:find "\a";

        if i ~= nil then
            color_print(r, g, b, a, text:sub(1, i - 1));

            while i ~= nil do
                local new_r, new_g, new_b, new_a = r, g, b, a;

                if text:sub(i, j + 7) == "\adefault" then
                    text = text:sub(1 + j + 7);
                else
                    local hex = text:sub(i + 1, j + 8);
                    text = text:sub(1 + j + 8);

                    new_r, new_g, new_b, new_a = rgba(hex);
                    new_a = new_a * a * to_alpha;
                end

                i, j = text:find "\a";

                local new_text = text;

                if i ~= nil then
                    new_text = text:sub(1, i - 1);
                end

                color_print(new_r, new_g, new_b, new_a, new_text);
            end

            color_print(0, 0, 0, 0, "\n");
            return;
        end

        color_print(r, g, b, a, text .. "\n");
    end

    function notify:add_to_queue(r, g, b, a, ...)
        local text = table.concat {...};

        local this =
        {
            text = text,
            colour = {r, g, b, a},
            colored = true,
            liferemaining = duration
        };

        queue[#queue + 1] = this;

        while #queue > times do
            table.remove(queue, 1);
        end

        return this;
    end

    function notify:should_draw()
        local is_visible = false;
        local host_frametime = globals.frametime();

        if not native_ConsoleIsVisible() then
            for i = #queue, 1, -1 do
                local v = queue[i];
                v.liferemaining = v.liferemaining - host_frametime;

                if v.liferemaining <= 0 then
                    table.remove(queue, i);
                    goto continue;
                end

                is_visible = true;
                ::continue::
            end
        end

        return is_visible;
    end

    function notify:on_paint_ui()
        local x, y = 8, 5;
        local flags = "d";

        for i = 1, #queue do
            local v = queue[i];

            local colour = v.colour;
            local r, g, b, a = colour[1], colour[2], colour[3], colour[4];

            local text = v.text:gsub("\n", "");
            local measure = vector(renderer.measure_text(flags, text));

            local tall = measure.y + 1;

            if v.liferemaining < .5 then
                local f = func.fclamp(v.liferemaining, 0, .5) / .5;
                a = a * f;

                if i == 1 and f < .2 then
                    y = y - tall * (1 - f / .2);
                end
            end

            if v.colored then
                surface:color_text(63, x, y, r, g, b, a, text);
            else
                surface:text(63, x, y, r, g, b, a, text);
            end

            y = y + tall;
        end
    end

    function notify:on_output(e)
        local text = string.format("\a%02x%02x%02x%02x%s", e.r, e.g, e.b, e.a, e.text);
        local i = text:find "\0";

        if i ~= nil then
            text = text:sub(1, i - 1);
        end

        if current ~= nil then
            current.text = current.text .. text;

            if i == nil then
                current = nil;
            end

            return current;
        end

        local this = self:add_to_queue(e.r, e.g, e.b, e.a, text);
        this.colored = text:find "\a" ~= nil;

        if i ~= nil then
            current = this;
        end

        return this;
    end

    function notify:on_console_input(e)
        if e:find("clear") == 1 then
            for i = 1, #queue do
                queue[i] = nil;
            end
        end
    end
end

device:on_update()



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



client.set_event_callback('setup_command', function()
    if not func.includes(ui.get(menu.miscTab.tweaks), "Allow Unsafe Charge") then return end
    if not ui.get(refs.doubletap.main[2]) or not ui.get(refs.doubletap.main[1]) then
        ui.set(refs.aimbot, true)

        if callback_reg then
            client.unset_event_callback('run_command', check_charge)
            callback_reg = false
        end
        return
    end


    local weapon = entity.get_player_weapon(vars.localPlayer)
    

    local_player = entity.get_local_player()

    if not callback_reg then
        client.set_event_callback('run_command', check_charge)
        callback_reg = true
    end

    local threat = client.current_threat()

    if not dt_charged
    and threat and entity.get_classname(weapon) == "SSG08" then
        ui.set(refs.aimbot, false)
    else
        ui.set(refs.aimbot, true)
    end
    
end)

client.set_event_callback('shutdown', function()
    ui.set(refs.aimbot, true)
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
    else
        notifications.new(string.format('Failed to save "$%s$"', name), 255, 120, 120)
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

local logica1337 = "2"

ui.set_callback(menu.builderTab.PresetComboBox, function()
    if ui.get(menu.builderTab.PresetComboBox) == "Delight" then
        local r, g, b = ui.get(menu.visualsTab.logsClr)

        local protected = function()
            importPreset()
        end

        if pcall(protected) then
            notifications.new(string.format('Delight`s preset was loaded', name), r, g, b)
        else
            notifications.new(string.format('Seems like an error', name), 255, 120, 120)
        end
    else
        local r, g, b = ui.get(menu.visualsTab.logsClr)

        local protected = function()
            importPresetClear()
        end

        if pcall(protected) then
            notifications.new(string.format('Delight`s preset was loaded', name), r, g, b)
        else
            notifications.new(string.format('Seems like an error', name), 255, 120, 120)
        end
    end
end)
-- @region UI_CALLBACKS end
-- @region UI_RENDER start

local function menu_handler()
    local isEnabled = ui.get(masterSwitch)
    vars.activeState = vars.sToInt[ui.get(menu.builderTab.state)]
    ui.set_visible(tabPicker, isEnabled)

    local isAATab = ui.get(tabPicker) == "Anti-aim"
    local isBuilderTab = isAATab and ui.get(menu.selections) == "Builder/Presets"
    local isVisualsTab = ui.get(tabPicker) == "Visuals"
    local isMiscTab = ui.get(tabPicker) == "Misc" 
    local isCFGTab = ui.get(tabPicker) == "Config"
    local isLogicBuilder = isAATab and ui.get(menu.selections) == "Builder/Presets" and ui.get(menu.builderTab.PresetComboBox) == "Disabled"

    ui.set_visible(menu.selections, isEnabled and isAATab)
   
    ui.set(aaBuilder[1].enableState, true)
    for i = 1, #vars.aaStates do
        local stateEnabled = ui.get(aaBuilder[i].enableState)
        ui.set_visible(aaBuilder[i].enableState, vars.activeState == i and isBuilderTab and isEnabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].pitch, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].pitchSlider , vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].pitch) == "Custom" and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawBase, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawCondition, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)

        ui.set_visible(aaBuilder[i].yawStatic, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "Static" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawLeft, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) ~= "Static" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawRight, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) ~= "Static" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawSpeed, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "Slow" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawStep, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "Sway" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)

        local is_allow_override = (ui.get(aaBuilder[i].yawCondition) == "Slow" or ui.get(aaBuilder[i].yawCondition)  == "Hold") and (ui.get(aaBuilder[i].bodyYawAllowOverride)) or not (ui.get(aaBuilder[i].yawCondition) == "Slow" or ui.get(aaBuilder[i].yawCondition)  == "Hold")

        ui.set_visible(aaBuilder[i].yawJitter, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawJitterCondition, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitter) ~= "AI Jitter" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        
        ui.set_visible(aaBuilder[i].yawJitterStatic, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitter) ~= "AI Jitter" and ui.get(aaBuilder[i].yawJitterCondition) == "Static" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder )
        ui.set_visible(aaBuilder[i].yawJitterLeft, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitter) ~= "AI Jitter" and ui.get(aaBuilder[i].yawJitterCondition) == "L/R" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawJitterRight, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitter) ~= "AI Jitter" and ui.get(aaBuilder[i].yawJitterCondition) == "L/R" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder) 
        ui.set_visible(aaBuilder[i].yawJitterDisablers, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)

        ui.set_visible(aaBuilder[i].desync_type, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)

        ui.set_visible(aaBuilder[i].bodyYaw, vars.activeState == i and is_allow_override and ui.get(aaBuilder[i].desync_type) == "Skeet" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].bodyYawSlider, vars.activeState == i and is_allow_override and ui.get(aaBuilder[i].desync_type) == "Skeet" and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].bodyYawAllowOverride, vars.activeState == i and ui.get(aaBuilder[i].desync_type) == "Skeet" and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder and (ui.get(aaBuilder[i].yawCondition) == "Hold" or ui.get(aaBuilder[i].yawCondition) == "Slow"))
        ui.set_visible(aaBuilder[i].fakeYawLimit, vars.activeState == i and ui.get(aaBuilder[i].desync_type) == "Interitus" and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].fsBodyYaw, vars.activeState == i and (ui.get(aaBuilder[i].bodyYaw) ~= "Off" or ui.get(aaBuilder[i].desync_type) == "Interitus") and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].padding_string, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensivestring, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensivestring1, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder )
        ui.set_visible(aaBuilder[i].defensiveYawStep, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled  and (ui.get(aaBuilder[i].defensiveYaw) == "Sway" or ui.get(aaBuilder[i].defensiveYaw) == "Spin")  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensiveOpt, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensiveSensivity, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensiveExploits, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensivedelaySlider, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder and func.includes(ui.get(aaBuilder[i].defensiveOpt), "Delayed Switch"))
        ui.set_visible(aaBuilder[i].defensiveYaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensiveYawSlider, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ui.get(aaBuilder[i].defensiveYaw) == "Custom"  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensivePitch, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensivePitchSlider, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and (ui.get(aaBuilder[i].defensivePitch) == "Custom" or ui.get(aaBuilder[i].defensivePitch) == "Sway")  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensivePitchSlider2, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ui.get(aaBuilder[i].defensivePitch) == "Sway"  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensivePitchStep, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ui.get(aaBuilder[i].defensivePitch) == "Sway"  and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensiveYawLeft, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and (ui.get(aaBuilder[i].defensiveYaw) == "L/R"  and isLogicBuilder or ui.get(aaBuilder[i].defensiveYaw) == "Sway"  and isLogicBuilder))
        ui.set_visible(aaBuilder[i].defensiveYawRight, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and (ui.get(aaBuilder[i].defensiveYaw) == "L/R"  and isLogicBuilder or ui.get(aaBuilder[i].defensiveYaw) == "Sway"  and isLogicBuilder))

    end

    for i, feature in pairs(menu.aaTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isAATab and isEnabled and ui.get(menu.selections) == "Additional")
        end
	end 

--     features = ui.new_multiselect(tab, container, "✧ Keybinds", "Manual-AA", "Freestand", "Edge Yaw"),
--     static = ui.new_checkbox(tab, container, "Static Manuals"),
--     freestandHotkey = ui.new_hotkey(tab, container, "Freestand"),
--     freestandDisablers = ui.new_multiselect(tab, container, "› Disablers", {"Air", "Slowmo", "Duck", "Manual"}),
--     edgeYawHotkey = ui.new_hotkey(tab, container, "Edge Yaw"),
--     manualLeft = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "left"),
--     manualRight = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "right"),
--     manualReset = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "reset"),
--     manualForward = ui.new_hotkey(tab, container, "Manual " .. func.hex({200,200,200}) .. "forward"),

    ui.set_visible(menu.aaTab.manualTab.features, isAATab and isEnabled and ui.get(menu.selections) == "Keybinds")
    ui.set_visible(menu.aaTab.manualTab.static, isAATab and isEnabled and ui.get(menu.selections) == "Keybinds" and func.includes(ui.get(menu.aaTab.manualTab.features), "Manual-AA"))
    ui.set_visible(menu.aaTab.manualTab.manualLeft, isAATab and isEnabled and ui.get(menu.selections) == "Keybinds" and func.includes(ui.get(menu.aaTab.manualTab.features), "Manual-AA"))
    ui.set_visible(menu.aaTab.manualTab.manualRight, isAATab and isEnabled and ui.get(menu.selections) == "Keybinds" and func.includes(ui.get(menu.aaTab.manualTab.features), "Manual-AA"))
    ui.set_visible(menu.aaTab.manualTab.manualForward, isAATab and isEnabled and ui.get(menu.selections) == "Keybinds" and func.includes(ui.get(menu.aaTab.manualTab.features), "Manual-AA"))
    ui.set_visible(menu.aaTab.manualTab.freestandHotkey, isAATab and isEnabled and ui.get(menu.selections) == "Keybinds" and func.includes(ui.get(menu.aaTab.manualTab.features), "Freestand"))
    ui.set_visible(menu.aaTab.manualTab.freestandstatic, isAATab and isEnabled and ui.get(menu.selections) == "Keybinds" and func.includes(ui.get(menu.aaTab.manualTab.features), "Freestand"))
    ui.set_visible(menu.aaTab.manualTab.freestand_jitterValue, isAATab and isEnabled and ui.get(menu.aaTab.manualTab.freestandstatic) == "Jitter" and ui.get(menu.selections) == "Keybinds" and func.includes(ui.get(menu.aaTab.manualTab.features), "Freestand"))
    ui.set_visible(menu.aaTab.manualTab.freestandDisablers, isAATab and isEnabled and ui.get(menu.selections) == "Keybinds" and func.includes(ui.get(menu.aaTab.manualTab.features), "Freestand"))
    ui.set_visible(menu.aaTab.manualTab.edgeYawHotkey, isAATab and isEnabled and ui.get(menu.selections) == "Keybinds" and func.includes(ui.get(menu.aaTab.manualTab.features), "Edge Yaw"))

    local is_avoid_backstab = func.includes(ui.get(menu.aaTab.tweaks), "Avoid Backstab")
    ui.set_visible(menu.aaTab.desync_on_shot, isEnabled  and isAATab and func.includes(ui.get(menu.aaTab.tweaks), "Desync On Shot") and ui.get(menu.selections) == "Additional")
    ui.set_visible(menu.aaTab.avoidBackstab, isEnabled  and isAATab and is_avoid_backstab and ui.get(menu.selections) == "Additional")

    -- builderTab
    ui.set_visible(menu.builderTab.state, isBuilderTab and isEnabled and isLogicBuilder)
    ui.set_visible(menu.builderTab.PresetComboBox, isBuilderTab and isEnabled)

    for i, feature in pairs(menu.visualsTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isVisualsTab and isEnabled)
        end
	end 

    local is_logs = func.includes(ui.get(menu.visualsTab.visuals), "Logging")

    ui.set_visible(menu.visualsTab.logs, isVisualsTab and isEnabled and is_logs)
    ui.set_visible(menu.visualsTab.logOffset, (func.includes(ui.get(menu.visualsTab.logs), "Aimbot") or func.includes(ui.get(menu.visualsTab.logs), "Anti-Aim")) and isVisualsTab and isEnabled and is_logs)
    ui.set_visible(menu.visualsTab.logsClr, (func.includes(ui.get(menu.visualsTab.logs), "Aimbot") or func.includes(ui.get(menu.visualsTab.logs), "Anti-Aim"))  and isVisualsTab and isEnabled and is_logs)
    ui.set_visible(menu.visualsTab.logs_type, (func.includes(ui.get(menu.visualsTab.logs), "Aimbot") or func.includes(ui.get(menu.visualsTab.logs), "Anti-Aim"))  and isVisualsTab and isEnabled and is_logs)
    -- ui.set_visible(menu.visualsTab.indicatorsStyle, ui.get(menu.visualsTab.indicators) == "Soft" and isVisualsTab and isEnabled)
    -- ui.set_visible(menu.visualsTab.indicatorsClr, ui.get(menu.visualsTab.indicators) == "Soft" or "Pixel" and isVisualsTab and isEnabled)
    local is_arrows = func.includes(ui.get(menu.visualsTab.visuals), "Arrows")
    ui.set_visible(menu.visualsTab.arrowIndicatorStyle,isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.arrowClrL, isVisualsTab and isEnabled and is_arrows)

    ui.set_visible(menu.visualsTab.arrowIndicatorStyle,is_arrows and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.arrowClr, is_arrows and isVisualsTab and isEnabled)

    local is_diff_watermark = ui.get(menu.visualsTab.watermark_type) == "Legacy" or ui.get(menu.visualsTab.watermark_type) == "Country" or ui.get(menu.visualsTab.watermark_type) == "Trans"

    ui.set_visible(menu.visualsTab.watermark_color, isVisualsTab and isEnabled) 
    ui.set_visible(menu.visualsTab.watermark, isVisualsTab and isEnabled and not is_diff_watermark) 
    ui.set_visible(menu.visualsTab.watermark_type, isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.indicator_color, isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.visuals), "Indicators")) 
    ui.set_visible(menu.visualsTab.indicator_label, isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.visuals), "Indicators")) 

    ui.set_visible(menu.configTab.export, isCFGTab and isEnabled)


    ui.set_visible(menu.bruteTab.enable,    isEnabled  and isAATab and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab.phases,    isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")

    ui.set_visible(menu.bruteTab.resetter,    isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")

    local is_reached_time = func.includes(ui.get(menu.bruteTab.resetter), "Reached Time Line")

    ui.set_visible(menu.bruteTab.reset_time,    isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and ui.get(menu.bruteTab.phases) and is_reached_time and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab.disablers,    isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab.additions,    isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab.addition_states,    isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute" and (func.includes(ui.get(menu.bruteTab.additions), "Flip Side")))
    ui.set_visible(menu.bruteTab.ignore_enable,    isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab.Ignore_condition,    isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute" and ui.get(menu.bruteTab.ignore_enable))
    ignore_brute_fix = ui.get(menu.bruteTab.ignore_enable)
    ui.set_visible(menu.bruteTab.jitter1,   isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and 0 < ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab.Desync1,   isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and 0 < ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab._1,        isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and 0 < ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab.jitter2,   isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and 1 < ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab.Desync2,   isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and 1 < ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab._2,        isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and 1 < ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab.jitter3,   isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and 2 < ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab.Desync3,   isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and 2 < ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab._3,        isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and 2 < ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab.jitter4,   isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and 3 < ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab.Desync4,   isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and 3 < ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab._4,        isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and 3 < ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab.jitter5,   isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and 4 < ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")
    ui.set_visible(menu.bruteTab.Desync5,   isEnabled  and isAATab and ui.get(menu.bruteTab.enable) and 4 < ui.get(menu.bruteTab.phases) and ui.get(menu.selections) == "Anti-Brute")

    for i, feature in pairs(menu.miscTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isMiscTab and isEnabled)
        end
	end

    ui.set_visible(menu.miscTab.fastLadder, func.includes(ui.get(menu.miscTab.tweaks), "Fast Ladder") and isMiscTab and isEnabled)
    ui.set_visible(menu.miscTab.animations, func.includes(ui.get(menu.miscTab.tweaks), "Anim Breakers") and isMiscTab and isEnabled)

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

    func.setAATab(false)

end

client.set_event_callback("paint_ui", function()
    menu_handler()
end)
-- @region UI_RENDER end

client.set_event_callback("shutdown", function()
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

notifications.new(string.format("Successfully loaded $Interitus.red $lua!", func.hex({lua_color.r, lua_color.g, lua_color.b}), func.hex({255, 255, 255})), lua_color.r, lua_color.g, lua_color.b)