-- @region LUASETTINGS start
local lua_name = "bluhgang"
local lua_color = {r = 190, g = 190, b = 255}
local obex_data = obex_fetch and obex_fetch() or {username = 'Admin', build = 'Dev', discord=''}
    
local lua_banner = [[                                                                                                           
    ██████╗ ██╗     ██╗   ██╗██╗  ██╗ ██████╗  █████╗ ███╗   ██╗ ██████╗    ██╗     ██╗   ██╗ █████╗ 
    ██╔══██╗██║     ██║   ██║██║  ██║██╔════╝ ██╔══██╗████╗  ██║██╔════╝    ██║     ██║   ██║██╔══██╗
    ██████╔╝██║     ██║   ██║███████║██║  ███╗███████║██╔██╗ ██║██║  ███╗   ██║     ██║   ██║███████║
    ██╔══██╗██║     ██║   ██║██╔══██║██║   ██║██╔══██║██║╚██╗██║██║   ██║   ██║     ██║   ██║██╔══██║
    ██████╔╝███████╗╚██████╔╝██║  ██║╚██████╔╝██║  ██║██║ ╚████║╚██████╔╝██╗███████╗╚██████╔╝██║  ██║
    ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝                                                                                                                             
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
local ent = try_require("gamesense/entity")
local steamworks = try_require("gamesense/steamworks") or error('Missing https://gamesense.pub/forums/viewtopic.php?id=26526')
-- @region DEPENDENCIES end

-- @region DATABASE & OBEX start

local login = {
    username = obex_data.username,
    version = "1.0.0",
    build = obex_data.build,
}

if login.build == 'User' then
    login.build = 'Live'
end

client.exec("clear")
client.color_log(255, 255, 255, " \n \n \n \n \n ")
client.color_log(lua_color.r, lua_color.g, lua_color.b, lua_banner)
client.color_log(255, 255, 255, " \n \n \n \n \n ")
client.color_log(255, 255, 255, "Welcome to\0")
client.color_log(lua_color.r, lua_color.g, lua_color.b, " bluhgang\0")
client.color_log(255, 255, 255, ", " .. login.username)
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
    aaStates = {"Global", "Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching", "Legit-AA"},
    pStates = {"G", "S", "M", "SW", "C", "A", "AC", "LA"},
	sToInt = {["Global"] = 1, ["Standing"] = 2, ["Moving"] = 3, ["Slowwalking"] = 4, ["Crouching"] = 5, ["Air"] = 6, ["Air-Crouching"] = 7,["Legit-AA"] = 8},
    intToS = {[1] = "Global", [2] = "Stand", [3] = "Move", [4] = "Slowwalk", [5] = "Crouch", [6] = "Air", [7] = "Air+C", [8] = "Legit"},
    currentTab = 1,
    activeState = 1,
    pState = 1,
    should_disable = false,
    defensive_until = 0,
    defensive_prev_sim = 0,
    fs = false,
    choke1 = 0,
    choke2 = 0,
    choke3 = 0,
    choke4 = 0,
    switch = false,
}

local kill = {"нюхай пятку сын шаболды ёбаной",
"сосешь хуже мегионских цыпочек",
"омг nice small pisunchik",
"ты нихуя не ледженд",
"OWNED BY LEGENDICK сын шлюхи ёбаной",
"позволь моей писечке исследовать недры шахты твоей матери",
"целуй писичку fucking no legend",
"сука ебаный NO LEGEND без блюхгенг луа",
"твоя писичка такая же маленькая как и iqshe4ka",
"в следущей раз выйграешь ледженда",
"БЛЮХГЕНГ ЛУА ВГЕТАЙ ВЫБЛЯДЬ ЕБАНАЯ УЖЕ 2023 АУ",
"Are you legend? Пройдите проверку на писечку для уточнения вопроса - @top1btw",
"ВЫ ТАКОЙ ЖЕ ТАНЦОР КАК ЛЯСТИЧКИ NOLEGENDICKI",
"Твоя мать такая же жирная как idle legend (140)",
"накончал на твою лысинку она как у батька шамелисика",
"сука ебаный NO LEGEND без блюхгенг луа",
"твоя мамаша приготовила мне вкусные бутербродики как у gachi nolegend",
"ты очень хорошо лижешь пяточки научи клокедика legendicka",
"шлюха ебаная так же сдохла как бабка фиппа и маута",
"сын шлюхи у тебя такие же компьютерики как у vanino nolegend",
"твоя мамаша лижет мороженное ой блять это же моя писечка",
"Чтобы выйгрывать вы обязаны держать бренд bluhgang'a",
"у твоей матери такая же узкая пизда как глаза d4ssh legend",
"ты такой же ебаный пес как  l4fn nolegend",
"блюхгенг луа вгетай хуйня)) - bit.ly/bluhganglua",
"тварь мб антипопадайки вгетаешь? - bit.ly/bluhganglua",
"конфиг тебе бы не помешал - bit.ly/bluhganglua",
"мда играешь ты конечно хуево не то что d4ssh legendick",
"разбомбил тебе ебасосину как бомбят walper nolegend",
"БЛЮХГЕНГ ЛУА ВГЕТАЙ ВЫБЛЯДЬ ЕБАНАЯ УЖЕ 2023 АУ",
"ты никогда не будешь legend с такой small pise4ka",
"пока ты сосешь хуй мы чилим на острове legendickov",
"хочешь купить config by legendick? ПОШЕЛ НАХУЙ СЫН ШЛЮХИ ЁБАНОЙ",
"ЭХХХ КАК ЖЕ АХУЕННО СОСЕТ ТВОЯ МАМАША МОЙ PISUN4IK",
"Чтобы выйгрывать вы обязаны держать бренд bluhgang'a",
"рандерандерандеву твоя мать шлюха сосала наяву",
"пузо твоей матери шлюхи такое же большое как у shirazu nolegend",
"АХАХХАА БЛЯ ЧЕЛ ТЫ ИГРАЕШЬ ХУЖЕ HOLATV",
"NEW META FUCKING NO LEGEND?",
"СОСИ ХУЙ ПЛАКСА ЁБАНАЯ",
"блюхгенг луа вгетай хуйня)) - bit.ly/bluhganglua",
"тварь мб антипопадайки вгетаешь? - bit.ly/bluhganglua",
"конфиг тебе бы не помешал - bit.ly/bluhganglua",
"БЛЮХГЕНГ ЛУА ВГЕТАЙ ВЫБЛЯДЬ ЕБАНАЯ УЖЕ 2023 АУ",
"ИЗВИНЯЙСЯ СЫН ШЛЮХИ ЁБАНОЙ",
"бля сори писька на пробел нажала а ты как бомж ебаный здох by bluhgang",
"ВЫЕБАНА В ПОПЭПНЦИЮ FUCKING NO LEGEND",
"ЁБАНЫЙ СЫН ШЛЮХИ ТЫ ХОЧЕШЬ КАК ВИТМА И СТИВАХА МНЕ ПРОЕАТЬ",
"сын шлюхи ты думал моя писечка сравнится с твоей?",
"если хочешь я могу тебя на стриме обоссать",
"Чтобы выйгрывать вы обязаны держать бренд bluhgang'a",
"ТЫ НЕ ЗНАЕШЬ ЛЕДЖЕНДОВ? ЁБАНЫЙ СЫН ШЛЮХИ С 2023 ЛИВНИ",
"ты так же зафейлишь проверку на писечки как mishat nolegend",
"ты танцуешь с бутылкой как ебаный clocked legend?",
"бля сори писька на пробел нажала а ты как бомж ебаный здох by bluhgang",
"нахуй ты от меня убегаешь как батек virtual legend",
"сука ебаный NO LEGEND без блюхгенг луа",
"если хочешь можешь прикупить айфончик 5 s как у merlex nolegend",
"если хочешь научиться играть тебе нужно попасть в стак legend pise4ki",
"че пидорас цапнул в писечку?",
"БЛЮХГЕНГ ЛУА ВГЕТАЙ ВЫБЛЯДЬ ЕБАНАЯ УЖЕ 2023 АУ",
"сука ебаный NO LEGEND без блюхгенг луа",
"ты сдох раньше своей матери шлюхи ой или она уже сдохла ?",
"твоя мамка любит большие леджендские ололо",
"ёбаный ноу ледженд ты кого пытался убить?",
"блюхгенг луа вгетай хуйня)) - bit.ly/bluhganglua",
"тварь мб антипопадайки вгетаешь? - bit.ly/bluhganglua",
"конфиг тебе бы не помешал - bit.ly/bluhganglua",
"ой братан походу тебе нужно купить кфгешку леджендика",
"жду реванша сын ебаной шлюхи",
"переиграна 12 летка ебучая ",
 "знаешь чем пахнут мои яички? спроси у своей мамаши шлюхи ёбаной ",
 "может сначала купишь пкешочки как у леджендиков? ",
"че то ты мои грязные яички облизал сын ёбаной пизды"
}

local kill_eng = {"weak dog hahAHahAHahAH",
"LACHBOMBED n_N",
"deported to hell d0g",
"cya@yt",
"you're fucking NO LEGEND",
"get bluhgang.lua bozo =D - bit.ly/bluhganglua",
"ty4clip bot hhhh",
"take L or buy cfg - bit.ly/bluhganglua",
"why are you so ez?",
"b l u h g a n g  >  all",
"omfg you so bad ngl"
}

local js = panorama.open()
local MyPersonaAPI, LobbyAPI, PartyListAPI, SteamOverlayAPI = js.MyPersonaAPI, js.LobbyAPI, js.PartyListAPI, js.SteamOverlayAPI
-- @region VARIABLES end

-- @region FUNCS start
local func = {
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

local color_text = function(string, r, g, b, a)
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
    http.get("https://cdn.discordapp.com/attachments/1021472649345519698/1128769509487022090/bluh.png", function(success, response)
		if not success or response.status ~= 200 then
			print("couldnt fetch the logo image")
            return
		end

		writefile("bluh.png", response.body)
	end)

    http.get("https://cdn.discordapp.com/attachments/958255099019423754/1159474998323466270/hudv2.png?ex=6531283d&is=651eb33d&hm=0569fae6c7ce223299015a128b57829c15bd12173c210dfdbf53cb14d373c332&", function(success, response)
		if not success or response.status ~= 200 then
			print("couldnt fetch the logo image")
            return
		end

		writefile("bluhhudv2.png", response.body)
	end)

    http.get("https://media.discordapp.net/attachments/958255099019423754/1159474985224634389/hudv1.png?ex=6531283a&is=651eb33a&hm=27fae695b1dcbea2dbad4d01c0281ccbf24f9a9216c2805f598bf7fd658e2074&=", function(success, response)
		if not success or response.status ~= 200 then
			print("couldnt fetch the logo image")
            return
		end

		writefile("bluhhudv1.png", response.body)
	end)
end
downloadFile()
-- @region FUNCS end

-- @region UI_LAYOUT start
local tab, container = "AA", "Anti-aimbot angles"
local masterSwitch = ui.new_checkbox(tab, container, func.hex({lua_color.r, lua_color.g, lua_color.b}) .. '› ' .. lua_name)
local isEnabled = ui.get(masterSwitch)
local tabPicker1 = ui.new_combobox(tab, container, "\nTab", "General", "Settings")
local backBtn = ui.new_button(tab, container, "Return to menu", function() 
    vars.currentTab = 1
end)
local builderBtn = ui.new_button(tab, container, "\aff9bffFFAnti-aim\a", function() 
    vars.currentTab = 2
end)
local visBtn = ui.new_button(tab, container, "\acdffffFFVisuals / Misc\a", function() 
    vars.currentTab = 3
end)
local cfgBtn = ui.new_button(tab, container, "\ad47f17FFConfig\a", function() 
    vars.currentTab = 4
end)

local x, y = client.screen_size()

local menu = {
    builderTab = {
        text10 = ui.new_label('AA', 'Anti-aimbot angles', '\a95b806ff---------------------------------------------------', 'string'),
        text11 = ui.new_label('AA', 'Anti-aimbot angles', '\a       ------------- ~ \a95b806ffAnti-Aim Tweaks\a', 'string'),
        newline10 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        TweaksMultiselect = ui.new_multiselect(tab, container, "\a95b806ff› Select Tweaks", "Freestand", "Avoid Backstab", "Safe head on knife", "Fix E Bombsite", "Adjust fakelag limit", "Discharge Exploit", "Edge Yaw", "Manuals"),
        newline11 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        freestandHotkey = ui.new_hotkey(tab, container, "Freestand"),
        freestandDisablers = ui.new_multiselect(tab, container, "› Disablers", {"Air", "Slowmo", "Duck", "Manual"}),
        avoidBackstab = ui.new_slider(tab, container, "Avoid Backstab", 0, 300, 0, true, "u", 1, {[0] = "Off"}),
        edgeYawHotkey = ui.new_hotkey(tab, container, "Edge Yaw"),
        staticManuals = ui.new_checkbox(tab, container, "Static on manuals"),
        manualTab = {
            manualLeft = ui.new_hotkey(tab, container, "Manual \a95b806ffleft\a"),
            manualRight = ui.new_hotkey(tab, container, "Manual \a95b806ffright\a"),
            manualForward = ui.new_hotkey(tab, container, "Manual \a95b806ffforward\a"),
            manualReset = ui.new_hotkey(tab, container, "Manual reset"),
        },
        newline12 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        text12 = ui.new_label('AA', 'Anti-aimbot angles', '\a95b806ff---------------------------------------------------', 'string'),
        text13 = ui.new_label('AA', 'Anti-aimbot angles', '\a         ------------ ~ \a95b806ffAnti-Aim Builder\a', 'string'),
        newline13 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        LogicComboBox = ui.new_combobox(tab, container, "logica secret", "1", "2"),
        PresetComboBox = ui.new_combobox(tab, container, "Presets", "Disabled", "[beta] scalevillain"),
        buttonPresets = ui.new_button(tab, container, "Go to Presets", function() end),
        buttonBuilder = ui.new_button(tab, container, "Go to Builder", function() end),
        state = ui.new_combobox(tab, container, "Anti-aim state", vars.aaStates),
    },
    visualsTab = {
        text0 = ui.new_label('AA', 'Anti-aimbot angles', '\a95b806ff---------------------------------------------------', 'string'),
        text1 = ui.new_label('AA', 'Anti-aimbot angles', '\a       ------------------- ~ \a95b806ffVisuals\a', 'string'),
        newline0 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        VisualsMultiselect = ui.new_multiselect(tab, container, "\a95b806ff› Select Visuals", "Crosshair Indicators", "bluhgang menu", "Crosshair Arrows", "On screen logs"),
        newline1 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        watermark = ui.new_combobox(tab, container, "Watermark", "Default", "Old"),
        watermarkPosition = ui.new_combobox(tab, container, "\n watermark position", "Left", "Bottom", "Right"),
        indicators = ui.new_combobox(tab, container, "Indicators", "Disabled", "Soft", "Pixel"),
        indicatorsClr = ui.new_color_picker(tab, container, "Main Color", lua_color.r, lua_color.g, lua_color.b, 255),
        indicatorsStyle = ui.new_multiselect(tab, container, "\n Elements", "Name", "State", "Doubletap", "Hideshots", "Freestand", "Safepoint", "Body aim", "Fakeduck"),
        watermarkClr = ui.new_color_picker(tab, container, "Watermark Color", lua_color.r, lua_color.g, lua_color.b, 255),
        hud = ui.new_combobox(tab, container, "bluhgang menu", "Disabled", "v1", "v2"),
        hudX = ui.new_slider(tab, container, "Width", -100, 3840, 0, true, "px"),
        hudY = ui.new_slider(tab, container, "Height", -100, 2160, y - y/2, true, "px"),
        arrowClr = ui.new_color_picker(tab, container, "Arrow Color", lua_color.r, lua_color.g, lua_color.b, 255),
        arrowIndicatorStyle = ui.new_combobox(tab, container, "Arrows", "-", "Teamskeet", "Standart"),
        logs = ui.new_checkbox(tab, container, "On Screen Logs"),
        logsClr = ui.new_color_picker(tab, container, "Logs Color", lua_color.r, lua_color.g, lua_color.b, 255),
        logOffset = ui.new_slider(tab, container, "Offset", 0, 500, 100, true, "px", 1),
        newline2 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        text2 = ui.new_label('AA', 'Anti-aimbot angles', '\a95b806ff---------------------------------------------------', 'string'),
        text3 = ui.new_label('AA', 'Anti-aimbot angles', '\a         ------------------- ~ \a95b806ffMisc\a', 'string'),
        newline3 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        MiscMultiselect = ui.new_multiselect(tab, container, "\a95b806ff› Select Misc", "Fast ladder", "Anim breakers", "Min DMG indicator", "Old console logs", "Clantag", "Trashtalk", "Console filter"),
        newline4 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        fastLadder = ui.new_multiselect(tab, container, "Fast ladder", "Ascending", "Descending"),
        animations = ui.new_multiselect(tab, container, "Animation breakers", "Static legs", "In air", "On land", "Leg fucker", "Allah legs", "Haram legs", "Blend legs"),
        devPrint = ui.new_checkbox(tab, container, "Old console logs"),
        trashTalk = ui.new_checkbox(tab, container, "Trashtalk"),
        TrashTalkLanguage = ui.new_combobox(tab, container, "\n language", "Russian", "English"),
        newline4 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline41 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline42 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline43 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline44 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline45 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline46 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline47 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline48 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline49 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline50 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline51 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline52 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline53 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline54 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline55 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline56 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline57 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        newline58 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    },
    configTab = {
        list = ui.new_listbox(tab, container, "Configs", ""),
        name = ui.new_textbox(tab, container, "Config name", ""),
        load = ui.new_button(tab, container, "Load", function() end),
        save = ui.new_button(tab, container, "Save", function() end),
        delete = ui.new_button(tab, container, "Delete", function() end),
        import = ui.new_button(tab, container, "Import", function() end),
        export = ui.new_button(tab, container, "Export", function() end)
    },
    configTab2 = {
        WarningConfig = ui.new_checkbox(tab, container, "* There's nothing because AA preset is active"),
        WarningConfig2 = ui.new_checkbox(tab, container, "* Disable preset to activate Config AA builder")
    },
    GeneralTab = {
        newline1 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        text1 = ui.new_label('AA', 'Anti-aimbot angles', 'bluhgang.lua \a95b806ff[beta] build', 'string'),
        text2 = ui.new_label('AA', 'Anti-aimbot angles', 'last upd ~ 06.10.2023', 'string'),
        text3 = ui.new_label('AA', 'Anti-aimbot angles', 'if you find a bug, open discord ticket', 'string'),
        newline2 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
        discord = ui.new_button(tab, container, "Copy discord link in clipboard", function() clipboard.set("https://discord.gg/GSzmkMfK6H") end)
    }
}

local aaBuilder = {}
local aaContainer = {}
for i=1, #vars.aaStates do
    aaContainer[i] = func.hex({200,200,200}) .. "(" .. func.hex({222,55,55}) .. "" .. vars.pStates[i] .. "" .. func.hex({200,200,200}) .. ")" .. func.hex({155,155,155}) .. " "
    aaBuilder[i] = {
        enableState = ui.new_checkbox(tab, container, "Enable " .. func.hex({lua_color.r, lua_color.g, lua_color.b}) .. vars.aaStates[i] .. func.hex({200,200,200}) .. " state"),
        pitch = ui.new_combobox(tab, container, "Pitch\n" .. aaContainer[i], "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
        pitchSlider = ui.new_slider(tab, container, "\nPitch add" .. aaContainer[i], -89, 89, 0, true, "°", 1),
        yawBase = ui.new_combobox(tab, container, "Yaw base\n" .. aaContainer[i], "Local view", "At targets"),
        yaw = ui.new_combobox(tab, container, "Yaw\n" .. aaContainer[i], "Off", "180", "Spin", "180 Z"),
        yawCondition = ui.new_combobox(tab, container, "Yaw condition\n" .. aaContainer[i], "Static", "L & R", "Slow", "Hold"),
        yawStatic = ui.new_slider(tab, container, "\nyaw limit" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawLeft = ui.new_slider(tab, container, "Left\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawRight = ui.new_slider(tab, container, "Right\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawSpeed = ui.new_slider(tab, container, "Speed\nyaw" .. aaContainer[i], 1, 14, 6, 0),
        yawJitter = ui.new_combobox(tab, container, "Yaw jitter\n" .. aaContainer[i], "Off", "Offset", "Center", "3-Way", "Random"),
        yawJitterCondition = ui.new_combobox(tab, container, "Yaw jitter condition\n" .. aaContainer[i], "Static", "L & R"),
        yawJitterStatic = ui.new_slider(tab, container, "\nyaw jitter limit" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterLeft = ui.new_slider(tab, container, "Left\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterRight = ui.new_slider(tab, container, "Right\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterDisablers = ui.new_multiselect(tab, container, "Jitter disablers\n" .. aaContainer[i], "Head safety", "Height advantage"),
        bodyYaw = ui.new_combobox(tab, container, "Body yaw\n" .. aaContainer[i], "Off", "Opposite", "Jitter", "Static"),
        bodyYawSlider = ui.new_slider(tab, container, "\nbody yaw limit" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        defensiveOpt = ui.new_multiselect(tab, container, "Defensive options\n" .. aaContainer[i], "Elusive mode", "Always on"),
        defensiveYaw = ui.new_combobox(tab, container, "Defensive yaw\n" .. aaContainer[i], "-", "Random", "Jitter", "Custom"),
        defensiveYawSlider = ui.new_slider(tab, container, "\nDefensiveYawSlider" .. aaContainer[i], -180, 180, 0, true, "", 1),
        defensivePitch = ui.new_combobox(tab, container, "Defensive pitch\n" .. aaContainer[i], "-", "Custom"),
        defensivePitchSlider = ui.new_slider(tab, container, "\nDefensivePitchSlider" .. aaContainer[i], -89, 89, 0, true, "°", 1),
    }
end

local trashtalk = function(e)

    local victim_userid, attacker_userid = e.userid, e.attacker
    if victim_userid == nil or attacker_userid == nil then
        return
    end

    local victim_entindex   = client.userid_to_entindex(victim_userid)
    local attacker_entindex = client.userid_to_entindex(attacker_userid)
    if attacker_entindex == entity.get_local_player() and entity.is_enemy(victim_entindex) then
        if ui.get(menu.visualsTab.TrashTalkLanguage) == "Russian" then
            local phrase = kill[math.random(1, #kill)]
            local say = 'say ' .. phrase
            client.exec(say)
        elseif ui.get(menu.visualsTab.TrashTalkLanguage) == "English" then
            local phrase = kill_eng[math.random(1, #kill_eng)]
            local say = 'say ' .. phrase
            client.exec(say)
        end
    end
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
    local frombuffer = "eyJpbmRleCI6NywiY29uZmlnIjp7IkxBIjp7InBpdGNoIjoiT2ZmIiwicGl0Y2hTbGlkZXIiOjAsImJvZHlZYXdTbGlkZXIiOjAsInlhd0ppdHRlckxlZnQiOjAsInlhd0ppdHRlclJpZ2h0IjowLCJib2R5WWF3IjoiT2ZmIiwiZGVmZW5zaXZlUGl0Y2giOiItIiwiZGVmZW5zaXZlUGl0Y2hTbGlkZXIiOjAsImVuYWJsZVN0YXRlIjpmYWxzZSwiZGVmZW5zaXZlWWF3IjoiLSIsInlhd1JpZ2h0IjowLCJ5YXdKaXR0ZXJEaXNhYmxlcnMiOnt9LCJ5YXdTdGF0aWMiOjAsInlhdyI6Ik9mZiIsInlhd0NvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlckNvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlciI6Ik9mZiIsInlhd1NwZWVkIjo2LCJ5YXdKaXR0ZXJTdGF0aWMiOjAsImRlZmVuc2l2ZU9wdCI6e30sInlhd0xlZnQiOjAsImRlZmVuc2l2ZVlhd1NsaWRlciI6MCwieWF3QmFzZSI6IkxvY2FsIHZpZXcifSwiU1ciOnsicGl0Y2giOiJPZmYiLCJwaXRjaFNsaWRlciI6MCwiYm9keVlhd1NsaWRlciI6MCwieWF3Sml0dGVyTGVmdCI6MCwieWF3Sml0dGVyUmlnaHQiOjAsImJvZHlZYXciOiJPZmYiLCJkZWZlbnNpdmVQaXRjaCI6Ii0iLCJkZWZlbnNpdmVQaXRjaFNsaWRlciI6MCwiZW5hYmxlU3RhdGUiOmZhbHNlLCJkZWZlbnNpdmVZYXciOiItIiwieWF3UmlnaHQiOjAsInlhd0ppdHRlckRpc2FibGVycyI6e30sInlhd1N0YXRpYyI6MCwieWF3IjoiT2ZmIiwieWF3Q29uZGl0aW9uIjoiU3RhdGljIiwieWF3Sml0dGVyQ29uZGl0aW9uIjoiU3RhdGljIiwieWF3Sml0dGVyIjoiT2ZmIiwieWF3U3BlZWQiOjYsInlhd0ppdHRlclN0YXRpYyI6MCwiZGVmZW5zaXZlT3B0Ijp7fSwieWF3TGVmdCI6MCwiZGVmZW5zaXZlWWF3U2xpZGVyIjowLCJ5YXdCYXNlIjoiTG9jYWwgdmlldyJ9LCJTIjp7InBpdGNoIjoiRGVmYXVsdCIsInBpdGNoU2xpZGVyIjowLCJib2R5WWF3U2xpZGVyIjotMSwieWF3Sml0dGVyTGVmdCI6MCwieWF3Sml0dGVyUmlnaHQiOjAsImJvZHlZYXciOiJKaXR0ZXIiLCJkZWZlbnNpdmVQaXRjaCI6Ii0iLCJkZWZlbnNpdmVQaXRjaFNsaWRlciI6MCwiZW5hYmxlU3RhdGUiOnRydWUsImRlZmVuc2l2ZVlhdyI6Ii0iLCJ5YXdSaWdodCI6NDIsInlhd0ppdHRlckRpc2FibGVycyI6e30sInlhd1N0YXRpYyI6MCwieWF3IjoiMTgwIiwieWF3Q29uZGl0aW9uIjoiTCAmIFIiLCJ5YXdKaXR0ZXJDb25kaXRpb24iOiJTdGF0aWMiLCJ5YXdKaXR0ZXIiOiJPZmYiLCJ5YXdTcGVlZCI6NiwieWF3Sml0dGVyU3RhdGljIjowLCJkZWZlbnNpdmVPcHQiOnt9LCJ5YXdMZWZ0IjotMjMsImRlZmVuc2l2ZVlhd1NsaWRlciI6MCwieWF3QmFzZSI6IkF0IHRhcmdldHMifSwiQUMiOnsicGl0Y2giOiJEZWZhdWx0IiwicGl0Y2hTbGlkZXIiOjAsImJvZHlZYXdTbGlkZXIiOi0xLCJ5YXdKaXR0ZXJMZWZ0IjowLCJ5YXdKaXR0ZXJSaWdodCI6MCwiYm9keVlhdyI6IkppdHRlciIsImRlZmVuc2l2ZVBpdGNoIjoiLSIsImRlZmVuc2l2ZVBpdGNoU2xpZGVyIjotNDUsImVuYWJsZVN0YXRlIjp0cnVlLCJkZWZlbnNpdmVZYXciOiItIiwieWF3UmlnaHQiOjM4LCJ5YXdKaXR0ZXJEaXNhYmxlcnMiOnt9LCJ5YXdTdGF0aWMiOjAsInlhdyI6IjE4MCIsInlhd0NvbmRpdGlvbiI6IkwgJiBSIiwieWF3Sml0dGVyQ29uZGl0aW9uIjoiU3RhdGljIiwieWF3Sml0dGVyIjoiT2ZmIiwieWF3U3BlZWQiOjYsInlhd0ppdHRlclN0YXRpYyI6MCwiZGVmZW5zaXZlT3B0IjpbIkFsd2F5cyBvbiJdLCJ5YXdMZWZ0IjotMTYsImRlZmVuc2l2ZVlhd1NsaWRlciI6MCwieWF3QmFzZSI6IkF0IHRhcmdldHMifSwiQSI6eyJwaXRjaCI6IkRlZmF1bHQiLCJwaXRjaFNsaWRlciI6MCwiYm9keVlhd1NsaWRlciI6LTEsInlhd0ppdHRlckxlZnQiOjAsInlhd0ppdHRlclJpZ2h0IjowLCJib2R5WWF3IjoiSml0dGVyIiwiZGVmZW5zaXZlUGl0Y2giOiItIiwiZGVmZW5zaXZlUGl0Y2hTbGlkZXIiOjg5LCJlbmFibGVTdGF0ZSI6dHJ1ZSwiZGVmZW5zaXZlWWF3IjoiLSIsInlhd1JpZ2h0IjozOCwieWF3Sml0dGVyRGlzYWJsZXJzIjp7fSwieWF3U3RhdGljIjowLCJ5YXciOiIxODAiLCJ5YXdDb25kaXRpb24iOiJMICYgUiIsInlhd0ppdHRlckNvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlciI6Ik9mZiIsInlhd1NwZWVkIjo2LCJ5YXdKaXR0ZXJTdGF0aWMiOjAsImRlZmVuc2l2ZU9wdCI6WyJBbHdheXMgb24iXSwieWF3TGVmdCI6LTMzLCJkZWZlbnNpdmVZYXdTbGlkZXIiOjAsInlhd0Jhc2UiOiJBdCB0YXJnZXRzIn0sIk0iOnsicGl0Y2giOiJEZWZhdWx0IiwicGl0Y2hTbGlkZXIiOjAsImJvZHlZYXdTbGlkZXIiOi0xLCJ5YXdKaXR0ZXJMZWZ0IjowLCJ5YXdKaXR0ZXJSaWdodCI6MCwiYm9keVlhdyI6IkppdHRlciIsImRlZmVuc2l2ZVBpdGNoIjoiLSIsImRlZmVuc2l2ZVBpdGNoU2xpZGVyIjowLCJlbmFibGVTdGF0ZSI6dHJ1ZSwiZGVmZW5zaXZlWWF3IjoiLSIsInlhd1JpZ2h0IjozNywieWF3Sml0dGVyRGlzYWJsZXJzIjp7fSwieWF3U3RhdGljIjowLCJ5YXciOiIxODAiLCJ5YXdDb25kaXRpb24iOiJMICYgUiIsInlhd0ppdHRlckNvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlciI6Ik9mZiIsInlhd1NwZWVkIjozLCJ5YXdKaXR0ZXJTdGF0aWMiOjAsImRlZmVuc2l2ZU9wdCI6e30sInlhd0xlZnQiOi0yOSwiZGVmZW5zaXZlWWF3U2xpZGVyIjowLCJ5YXdCYXNlIjoiQXQgdGFyZ2V0cyJ9LCJDIjp7InBpdGNoIjoiRGVmYXVsdCIsInBpdGNoU2xpZGVyIjowLCJib2R5WWF3U2xpZGVyIjotMSwieWF3Sml0dGVyTGVmdCI6MCwieWF3Sml0dGVyUmlnaHQiOjAsImJvZHlZYXciOiJKaXR0ZXIiLCJkZWZlbnNpdmVQaXRjaCI6Ii0iLCJkZWZlbnNpdmVQaXRjaFNsaWRlciI6LTQ1LCJlbmFibGVTdGF0ZSI6dHJ1ZSwiZGVmZW5zaXZlWWF3IjoiLSIsInlhd1JpZ2h0IjoyMywieWF3Sml0dGVyRGlzYWJsZXJzIjp7fSwieWF3U3RhdGljIjoyOCwieWF3IjoiMTgwIiwieWF3Q29uZGl0aW9uIjoiU2xvdyIsInlhd0ppdHRlckNvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlciI6Ik9mZiIsInlhd1NwZWVkIjozLCJ5YXdKaXR0ZXJTdGF0aWMiOjAsImRlZmVuc2l2ZU9wdCI6WyJBbHdheXMgb24iXSwieWF3TGVmdCI6LTE5LCJkZWZlbnNpdmVZYXdTbGlkZXIiOjAsInlhd0Jhc2UiOiJBdCB0YXJnZXRzIn0sIkciOnsicGl0Y2giOiJEZWZhdWx0IiwicGl0Y2hTbGlkZXIiOjAsImJvZHlZYXdTbGlkZXIiOi0xLCJ5YXdKaXR0ZXJMZWZ0IjowLCJ5YXdKaXR0ZXJSaWdodCI6MCwiYm9keVlhdyI6IkppdHRlciIsImRlZmVuc2l2ZVBpdGNoIjoiLSIsImRlZmVuc2l2ZVBpdGNoU2xpZGVyIjowLCJlbmFibGVTdGF0ZSI6dHJ1ZSwiZGVmZW5zaXZlWWF3IjoiLSIsInlhd1JpZ2h0IjozOSwieWF3Sml0dGVyRGlzYWJsZXJzIjp7fSwieWF3U3RhdGljIjowLCJ5YXciOiIxODAiLCJ5YXdDb25kaXRpb24iOiJTbG93IiwieWF3Sml0dGVyQ29uZGl0aW9uIjoiU3RhdGljIiwieWF3Sml0dGVyIjoiT2ZmIiwieWF3U3BlZWQiOjUsInlhd0ppdHRlclN0YXRpYyI6MCwiZGVmZW5zaXZlT3B0Ijp7fSwieWF3TGVmdCI6LTI4LCJkZWZlbnNpdmVZYXdTbGlkZXIiOjAsInlhd0Jhc2UiOiJBdCB0YXJnZXRzIn19fQ=="
    local decode = base64.decode(frombuffer, alph)
    local toTable = json.parse(decode)
    loadSettings(toTable.config)
end
local function importPresetClear()
    local frombuffer = "eyJpbmRleCI6OCwiY29uZmlnIjp7IkxBIjp7InBpdGNoIjoiT2ZmIiwicGl0Y2hTbGlkZXIiOjAsImJvZHlZYXdTbGlkZXIiOjAsInlhd0ppdHRlckxlZnQiOjAsInlhd0ppdHRlclJpZ2h0IjowLCJib2R5WWF3IjoiT2ZmIiwiZGVmZW5zaXZlUGl0Y2giOiItIiwiZGVmZW5zaXZlUGl0Y2hTbGlkZXIiOjAsImVuYWJsZVN0YXRlIjpmYWxzZSwiZGVmZW5zaXZlWWF3IjoiLSIsInlhd1JpZ2h0IjowLCJ5YXdKaXR0ZXJEaXNhYmxlcnMiOnt9LCJ5YXdTdGF0aWMiOjAsInlhdyI6Ik9mZiIsInlhd0NvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlckNvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlciI6Ik9mZiIsInlhd1NwZWVkIjo2LCJ5YXdKaXR0ZXJTdGF0aWMiOjAsImRlZmVuc2l2ZU9wdCI6e30sInlhd0xlZnQiOjAsImRlZmVuc2l2ZVlhd1NsaWRlciI6MCwieWF3QmFzZSI6IkxvY2FsIHZpZXcifSwiU1ciOnsicGl0Y2giOiJPZmYiLCJwaXRjaFNsaWRlciI6MCwiYm9keVlhd1NsaWRlciI6MCwieWF3Sml0dGVyTGVmdCI6MCwieWF3Sml0dGVyUmlnaHQiOjAsImJvZHlZYXciOiJPZmYiLCJkZWZlbnNpdmVQaXRjaCI6Ii0iLCJkZWZlbnNpdmVQaXRjaFNsaWRlciI6MCwiZW5hYmxlU3RhdGUiOmZhbHNlLCJkZWZlbnNpdmVZYXciOiItIiwieWF3UmlnaHQiOjAsInlhd0ppdHRlckRpc2FibGVycyI6e30sInlhd1N0YXRpYyI6MCwieWF3IjoiT2ZmIiwieWF3Q29uZGl0aW9uIjoiU3RhdGljIiwieWF3Sml0dGVyQ29uZGl0aW9uIjoiU3RhdGljIiwieWF3Sml0dGVyIjoiT2ZmIiwieWF3U3BlZWQiOjYsInlhd0ppdHRlclN0YXRpYyI6MCwiZGVmZW5zaXZlT3B0Ijp7fSwieWF3TGVmdCI6MCwiZGVmZW5zaXZlWWF3U2xpZGVyIjowLCJ5YXdCYXNlIjoiTG9jYWwgdmlldyJ9LCJTIjp7InBpdGNoIjoiT2ZmIiwicGl0Y2hTbGlkZXIiOjAsImJvZHlZYXdTbGlkZXIiOjAsInlhd0ppdHRlckxlZnQiOjAsInlhd0ppdHRlclJpZ2h0IjowLCJib2R5WWF3IjoiT2ZmIiwiZGVmZW5zaXZlUGl0Y2giOiItIiwiZGVmZW5zaXZlUGl0Y2hTbGlkZXIiOjAsImVuYWJsZVN0YXRlIjpmYWxzZSwiZGVmZW5zaXZlWWF3IjoiLSIsInlhd1JpZ2h0IjowLCJ5YXdKaXR0ZXJEaXNhYmxlcnMiOnt9LCJ5YXdTdGF0aWMiOjAsInlhdyI6Ik9mZiIsInlhd0NvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlckNvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlciI6Ik9mZiIsInlhd1NwZWVkIjo2LCJ5YXdKaXR0ZXJTdGF0aWMiOjAsImRlZmVuc2l2ZU9wdCI6e30sInlhd0xlZnQiOjAsImRlZmVuc2l2ZVlhd1NsaWRlciI6MCwieWF3QmFzZSI6IkxvY2FsIHZpZXcifSwiQUMiOnsicGl0Y2giOiJPZmYiLCJwaXRjaFNsaWRlciI6MCwiYm9keVlhd1NsaWRlciI6MCwieWF3Sml0dGVyTGVmdCI6MCwieWF3Sml0dGVyUmlnaHQiOjAsImJvZHlZYXciOiJPZmYiLCJkZWZlbnNpdmVQaXRjaCI6Ii0iLCJkZWZlbnNpdmVQaXRjaFNsaWRlciI6MCwiZW5hYmxlU3RhdGUiOmZhbHNlLCJkZWZlbnNpdmVZYXciOiItIiwieWF3UmlnaHQiOjAsInlhd0ppdHRlckRpc2FibGVycyI6e30sInlhd1N0YXRpYyI6MCwieWF3IjoiT2ZmIiwieWF3Q29uZGl0aW9uIjoiU3RhdGljIiwieWF3Sml0dGVyQ29uZGl0aW9uIjoiU3RhdGljIiwieWF3Sml0dGVyIjoiT2ZmIiwieWF3U3BlZWQiOjYsInlhd0ppdHRlclN0YXRpYyI6MCwiZGVmZW5zaXZlT3B0Ijp7fSwieWF3TGVmdCI6MCwiZGVmZW5zaXZlWWF3U2xpZGVyIjowLCJ5YXdCYXNlIjoiTG9jYWwgdmlldyJ9LCJBIjp7InBpdGNoIjoiT2ZmIiwicGl0Y2hTbGlkZXIiOjAsImJvZHlZYXdTbGlkZXIiOjAsInlhd0ppdHRlckxlZnQiOjAsInlhd0ppdHRlclJpZ2h0IjowLCJib2R5WWF3IjoiT2ZmIiwiZGVmZW5zaXZlUGl0Y2giOiItIiwiZGVmZW5zaXZlUGl0Y2hTbGlkZXIiOjAsImVuYWJsZVN0YXRlIjpmYWxzZSwiZGVmZW5zaXZlWWF3IjoiLSIsInlhd1JpZ2h0IjowLCJ5YXdKaXR0ZXJEaXNhYmxlcnMiOnt9LCJ5YXdTdGF0aWMiOjAsInlhdyI6Ik9mZiIsInlhd0NvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlckNvbmRpdGlvbiI6IlN0YXRpYyIsInlhd0ppdHRlciI6Ik9mZiIsInlhd1NwZWVkIjo2LCJ5YXdKaXR0ZXJTdGF0aWMiOjAsImRlZmVuc2l2ZU9wdCI6e30sInlhd0xlZnQiOjAsImRlZmVuc2l2ZVlhd1NsaWRlciI6MCwieWF3QmFzZSI6IkxvY2FsIHZpZXcifSwiTSI6eyJwaXRjaCI6Ik9mZiIsInBpdGNoU2xpZGVyIjowLCJib2R5WWF3U2xpZGVyIjowLCJ5YXdKaXR0ZXJMZWZ0IjowLCJ5YXdKaXR0ZXJSaWdodCI6MCwiYm9keVlhdyI6Ik9mZiIsImRlZmVuc2l2ZVBpdGNoIjoiLSIsImRlZmVuc2l2ZVBpdGNoU2xpZGVyIjowLCJlbmFibGVTdGF0ZSI6ZmFsc2UsImRlZmVuc2l2ZVlhdyI6Ii0iLCJ5YXdSaWdodCI6MCwieWF3Sml0dGVyRGlzYWJsZXJzIjp7fSwieWF3U3RhdGljIjowLCJ5YXciOiJPZmYiLCJ5YXdDb25kaXRpb24iOiJTdGF0aWMiLCJ5YXdKaXR0ZXJDb25kaXRpb24iOiJTdGF0aWMiLCJ5YXdKaXR0ZXIiOiJPZmYiLCJ5YXdTcGVlZCI6NiwieWF3Sml0dGVyU3RhdGljIjowLCJkZWZlbnNpdmVPcHQiOnt9LCJ5YXdMZWZ0IjowLCJkZWZlbnNpdmVZYXdTbGlkZXIiOjAsInlhd0Jhc2UiOiJMb2NhbCB2aWV3In0sIkMiOnsicGl0Y2giOiJPZmYiLCJwaXRjaFNsaWRlciI6MCwiYm9keVlhd1NsaWRlciI6MCwieWF3Sml0dGVyTGVmdCI6MCwieWF3Sml0dGVyUmlnaHQiOjAsImJvZHlZYXciOiJPZmYiLCJkZWZlbnNpdmVQaXRjaCI6Ii0iLCJkZWZlbnNpdmVQaXRjaFNsaWRlciI6MCwiZW5hYmxlU3RhdGUiOmZhbHNlLCJkZWZlbnNpdmVZYXciOiItIiwieWF3UmlnaHQiOjAsInlhd0ppdHRlckRpc2FibGVycyI6e30sInlhd1N0YXRpYyI6MCwieWF3IjoiT2ZmIiwieWF3Q29uZGl0aW9uIjoiU3RhdGljIiwieWF3Sml0dGVyQ29uZGl0aW9uIjoiU3RhdGljIiwieWF3Sml0dGVyIjoiT2ZmIiwieWF3U3BlZWQiOjYsInlhd0ppdHRlclN0YXRpYyI6MCwiZGVmZW5zaXZlT3B0Ijp7fSwieWF3TGVmdCI6MCwiZGVmZW5zaXZlWWF3U2xpZGVyIjowLCJ5YXdCYXNlIjoiTG9jYWwgdmlldyJ9LCJHIjp7InBpdGNoIjoiT2ZmIiwicGl0Y2hTbGlkZXIiOjAsImJvZHlZYXdTbGlkZXIiOjAsInlhd0ppdHRlckxlZnQiOjAsInlhd0ppdHRlclJpZ2h0IjowLCJib2R5WWF3IjoiT2ZmIiwiZGVmZW5zaXZlUGl0Y2giOiItIiwiZGVmZW5zaXZlUGl0Y2hTbGlkZXIiOjAsImVuYWJsZVN0YXRlIjp0cnVlLCJkZWZlbnNpdmVZYXciOiItIiwieWF3UmlnaHQiOjAsInlhd0ppdHRlckRpc2FibGVycyI6e30sInlhd1N0YXRpYyI6MCwieWF3IjoiT2ZmIiwieWF3Q29uZGl0aW9uIjoiU3RhdGljIiwieWF3Sml0dGVyQ29uZGl0aW9uIjoiU3RhdGljIiwieWF3Sml0dGVyIjoiT2ZmIiwieWF3U3BlZWQiOjYsInlhd0ppdHRlclN0YXRpYyI6MCwiZGVmZW5zaXZlT3B0Ijp7fSwieWF3TGVmdCI6MCwiZGVmZW5zaXZlWWF3U2xpZGVyIjowLCJ5YXdCYXNlIjoiTG9jYWwgdmlldyJ9fX0="
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
-- @region UI_LAYOUT end

-- @region NOTIFICATION_ANIM start
local anim_time = 0.5
local max_notifs = 6
local data = {}
local notifications = {

    new = function(string, r, g, b)
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

            local data = {rounding = 4, size = 3, glow = 2, time = 2}

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

            local paddingx, paddingy = 7, data.size
            local offsetY = ui.get(menu.visualsTab.logOffset)

            Offset = Offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 + 5) * fraction
            glow_module(x/2 - (strw + strw2)/2 - paddingx, y - offsetY - strh/2 - paddingy - Offset, strw + strw2 + paddingx*2, strh + paddingy*2, data.glow, data.rounding, {r, g, b, 45 * fraction}, {25,25,25,140 * fraction})
            renderer.text(x/2 + strw2/2, y - offsetY - Offset, 255, 255, 255, 255 * fraction, "c", 0, string)
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
    if entity.get_prop(e.target, 'm_iHealth') <= 0 then
	    notifications.new(string.format("Killed %s $%s$ for $%d$ damage", entity.get_player_name(e.target), group:lower(), e.damage), r, g, b)
    else
        notifications.new(string.format("Hit %s's $%s$ for $%d$ damage ($%d$ health remaining)", entity.get_player_name(e.target), group:lower(), e.damage, entity.get_prop(e.target, 'm_iHealth')), r, g, b) 
    end

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
client.set_event_callback("setup_command", function(cmd)
    vars.localPlayer = entity.get_local_player()

    if not vars.localPlayer or not entity.is_alive(vars.localPlayer) or not ui.get(masterSwitch) then return end
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

    local weapon = entity.get_player_weapon(vars.localPlayer)

    local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
	local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
	local isFd = ui.get(refs.fakeDuck)
	local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    local isLegitAA = ui.get(aaBuilder[8].enableState) and client.key_state(0x45)
    local isDefensive = (func.defensive.defensive > 1 and func.defensive.defensive < 14)
    local safeKnife = func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Safe head on knife") and entity.get_classname(weapon) == "CKnife"

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

    if isLegitAA and not vars.should_disable then
        vars.pState = 8
    end

    local nextAttack = entity.get_prop(vars.localPlayer, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(vars.localPlayer), "m_flNextPrimaryAttack")
    local dtActive = false
    local isFl = ui.get(ui.reference("AA", "Fake lag", "Enabled"))
    local isFl2 = ui.get(ui.reference("AA", "Fake lag", "Enabled")) and not isDt and not isOs
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
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
        local isStatic = ui.get(menu.builderTab.staticManuals)

        ui.set(menu.builderTab.manualTab.manualLeft, "On hotkey")
        ui.set(menu.builderTab.manualTab.manualRight, "On hotkey")
        ui.set(menu.builderTab.manualTab.manualReset, "On hotkey")
        ui.set(menu.builderTab.manualTab.manualForward, "On hotkey")

        if aa.input + 0.182 < globals.curtime() then
            if aa.manualAA == 0 then
                if ui.get(menu.builderTab.manualTab.manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()    
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
                elseif ui.get(menu.builderTab.manualTab.manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
                elseif ui.get(menu.builderTab.manualTab.manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.builderTab.manualTab.manualReset) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                end
            elseif aa.manualAA == 1 then
                if ui.get(menu.builderTab.manualTab.manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.builderTab.manualTab.manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.builderTab.manualTab.manualLeft) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.builderTab.manualTab.manualReset) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()    
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                end
            elseif aa.manualAA == 2 then
                if ui.get(menu.builderTab.manualTab.manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.builderTab.manualTab.manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.builderTab.manualTab.manualRight) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.builderTab.manualTab.manualReset) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()    
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                end
            elseif aa.manualAA == 3 then
                if ui.get(menu.builderTab.manualTab.manualForward) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.builderTab.manualTab.manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.builderTab.manualTab.manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                    ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(menu.builderTab.manualTab.manualReset) then
                    aa.manualAA = 0
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
                elseif not isStatic and ui.get(aaBuilder[vars.pState].enableState) then
                    if ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                        ui.set(refs.yawJitter[1], "Center")
                        ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft)*math.random(-1, 1)  or ui.get(aaBuilder[vars.pState].yawJitterRight)*math.random(-1, 1) ))
                    elseif ui.get(aaBuilder[vars.pState].yawJitter) == "L & R" then
                        ui.set(refs.yawJitter[1], "Center")
                        ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) or ui.get(aaBuilder[vars.pState].yawJitterRight)))
                    else
                        ui.set(refs.yawJitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
                        ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic))
                    end

                    if ui.get(aaBuilder[vars.pState].yawCondition) == "L & R" then
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

        if ((bodyYaw >= 40 or bodyYaw <= -40) and func.headVisible(enemies[i])) then
			safetyAlert = true
		else
			safetyAlert = false
		end
	end

    if ui.get(aaBuilder[vars.pState].enableState) then

        if func.includes(ui.get(aaBuilder[vars.pState].defensiveOpt), "Always on") then
            cmd.force_defensive = true
        end

        if func.includes(ui.get(aaBuilder[vars.pState].defensiveOpt), "Elusive mode") then
            ui.set(refs.dt[3], "Defensive")

            if tickcount % 3 == 1 then
                ui.set(refs.dt[3], "Offensive")
            end
            cmd.force_defensive = tickcount % 3 ~= 1
        end
        

        if aa.ignore then return end

        if ui.get(aaBuilder[vars.pState].defensivePitch) == "Custom" and isDefensive then
            ui.set(refs.pitch[1], "Custom")
            ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].defensivePitchSlider))
        else
            ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
            ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
        end                

        ui.set(refs.yawBase, ui.get(aaBuilder[vars.pState].yawBase))

        ui.set(refs.yaw[1], ui.get(aaBuilder[vars.pState].yaw))

        if ui.get(aaBuilder[vars.pState].defensiveYaw) == "Random" and isDefensive then
            local randomyaw = client.random_int(61, 180)
            ui.set(refs.yaw[2], func.aa_clamp((tickcount % 6 < 3 and randomyaw or -randomyaw)))
        elseif ui.get(aaBuilder[vars.pState].defensiveYaw) == "Jitter" and isDefensive then
            ui.set(refs.yaw[2], tickcount % 3 == 0 and client.random_int(90, -90) or tickcount % 3 == 1 and 180 or tickcount % 3 == 2 and client.random_int(-90, 90) or 0)
        elseif ui.get(aaBuilder[vars.pState].defensiveYaw) == "Custom" and isDefensive then
--            ui.set(refs.yaw[2], "Custom")
            ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].defensiveYawSlider))
        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "L & R" then

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
        else
            ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawStatic))
            side_yaw = 2
        end

        local switch = false
        if ((func.includes(ui.get(aaBuilder[vars.pState].yawJitterDisablers), "Height advantage" ) and heightAdvantage) or (func.includes(ui.get(aaBuilder[vars.pState].yawJitterDisablers), "Head safety") and safetyAlert)) then
            ui.set(refs.yawJitter[1], "Off") 
        elseif ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
            ui.set(refs.yawJitter[1], "Center")
        else
            ui.set(refs.yawJitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
        end
        if ui.get(aaBuilder[vars.pState].yawJitterCondition) == "L & R" then
            if ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft)*math.random(-1, 1)  or ui.get(aaBuilder[vars.pState].yawJitterRight)*math.random(-1, 1) ))
            elseif ui.get(aaBuilder[vars.pState].yawJitter) == "Slow Jitter" then
                ui.set(refs.yaw[2], switch and ui.get(aaBuilder[vars.pState].yawJitterRight) or ui.get(aaBuilder[vars.pState].yawJitterLeft))
            else
                ui.set(refs.yawJitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) or ui.get(aaBuilder[vars.pState].yawJitterRight)))
            end
            
        else
            if  ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic)*math.random(-1, 1) )
            elseif ui.get(aaBuilder[vars.pState].yawJitter) == "Slow Jitter" then
                ui.set(refs.yaw[2], switch and ui.get(aaBuilder[vars.pState].yawJitterStatic) or -ui.get(aaBuilder[vars.pState].yawJitterStatic))
            else
                ui.set(refs.yawJitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic) )
            end
        end

        if ui.get(aaBuilder[vars.pState].yawCondition) == "Slow" then
            ui.set(refs.bodyYaw[1], "Static")
            ui.set(refs.bodyYaw[2], 0)
        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "Hold" then
            ui.set(refs.bodyYaw[1], "Static")
            ui.set(refs.bodyYaw[2], 0)
        else
            ui.set(refs.bodyYaw[1], ui.get(aaBuilder[vars.pState].bodyYaw))
            ui.set(refs.bodyYaw[2], ui.get(aaBuilder[vars.pState].bodyYawSlider))
        end

        if reversed and ui.get(aaBuilder[vars.pState].antiBruteSet) then
            ui.set(refs.yaw[2], angle)
        end

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

    --safe safe
    if func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Safe head on knife") then
        if entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CKnife" and vars.pState == 7 then
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

    -- fix hideshots
	if func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Adjust fakelag limit") then
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
    if ui.get(menu.builderTab.avoidBackstab) ~= 0 and func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Avoid Backstab") then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        if players == nil then return end
        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = distance_knife.anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(menu.builderTab.avoidBackstab) then
                ui.set(refs.yaw[2], 180)
                ui.set(refs.yawBase, "At targets")
            end
        end
    end
    
    -- dt discharge
    if func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Discharge Exploit") then
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
    if func.includes(ui.get(menu.visualsTab.MiscMultiselect), "Fast ladder") then
        local pitch, yaw = client.camera_angles()
        if entity.get_prop(vars.localPlayer, "m_MoveType") == 9 then
            cmd.yaw = math.floor(cmd.yaw+0.5)
            cmd.roll = 0
    
            if func.includes(ui.get(menu.visualsTab.fastLadder), "Ascending") then
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
            if func.includes(ui.get(menu.visualsTab.fastLadder), "Descending") then
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
    if func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Edge Yaw") then
        ui.set(refs.edgeYaw, ui.get(menu.builderTab.edgeYawHotkey))
    end

    ui.set_callback(menu.builderTab.TweaksMultiselect, function()
        if func.includes(ui.get(menu.visualsTab.MiscMultiselect), "Console filter") then
            cvar.con_filter_text:set_string("cool text")
            cvar.con_filter_enable:set_int(1)
        else
            cvar.con_filter_enable:set_int(0)
        end
    end)
end)

client.set_event_callback("setup_command", function(e)
    if not vars.localPlayer or not entity.is_alive(vars.localPlayer) or not ui.get(masterSwitch) then return end
	local flags = entity.get_prop(vars.localPlayer, "m_fFlags")
    local onground = bit.band(flags, 1) ~= 0 and e.in_jump == 0
    local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])

    local air = func.includes(ui.get(menu.builderTab.freestandDisablers), "Air") and not onground
    local duck = func.includes(ui.get(menu.builderTab.freestandDisablers), "Duck") and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1
    local slow = func.includes(ui.get(menu.builderTab.freestandDisablers), "Slowmo") and isSlow
    local manul = func.includes(ui.get(menu.builderTab.freestandDisablers), "Manual") and (aa.manualAA == 2 or aa.manualAA == 1) and aa.ignore
    local fs_disabler = air or duck or slow or manul

    if ui.get(menu.builderTab.freestandHotkey) and func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Freestand") and not fs_disabler then
        vars.fs = true
        ui.set(refs.freeStand[2], "Always on")
        ui.set(refs.freeStand[1], true)
    else
        vars.fs = false
        ui.set(refs.freeStand[1], false)
        ui.set(refs.freeStand[2], "On hotkey")
    end    
end)

local function command2(e)
    if func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Fix E Bombsite") then
        if e.in_use == 0 then
            return
        end

        local me = entity.get_local_player()

        if me == nil then
            return
        end

        local m_bInBombZone = entity.get_prop(me, "m_bInBombZone")

        if m_bInBombZone == 1 then
            e.in_use = 0
        end
    end
end

client.set_event_callback("setup_command", command2)
local function clantag_set()
    local lua_name = "#bluhgang.LUA"
    if func.includes(ui.get(menu.visualsTab.MiscMultiselect), "Clantag") then
        if ui.get(ui.reference("Misc", "Miscellaneous", "Clan tag spammer")) then return end

		local clan_tag = clantag_anim(lua_name, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25})

        if entity.get_prop(entity.get_game_rules(), "m_gamePhase") == 5 then
            clan_tag = clantag_anim('#bluhgang.LUA', {13})
            client.set_clan_tag(clan_tag)
        elseif entity.get_prop(entity.get_game_rules(), "m_timeUntilNextPhaseStarts") ~= 0 then
            clan_tag = clantag_anim('#bluhgang.LUA', {13})
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
        if globals.tickcount() % 2 == 0 then
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

ui.set_callback(menu.visualsTab.trashTalk, function() 
    if func.includes(ui.get(menu.visualsTab.MiscMultiselect), "Trashtalk") then
        local callback = ui.get(menu.visualsTab.trashTalk) and client.set_event_callback or client.unset_event_callback
        callback('player_death', trashtalk)
    end
end)

ui.set_callback(menu.visualsTab.logs, function() 
    local callback = ui.get(menu.visualsTab.logs) and client.set_event_callback or client.unset_event_callback
    callback("aim_miss", onMiss)
    callback("aim_hit", onHit)
end)

client.set_event_callback("player_death", function(e)
    local v, a = e.userid, e.attacker
    local lp_death = client.userid_to_entindex(v)
    if lp_death ~= entity.get_local_player() then return end
    client.delay_call(1, notifications.clear)
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
    if func.includes(ui.get(menu.visualsTab.animations), "Leg fucker") then
        if func.includes(ui.get(menu.visualsTab.animations), "Leg fucker") then
            ui.set(refs.legMovement, e.command_number % 3 == 0 and "Off" or "Always slide")
        end
    end
end)

client.set_event_callback("pre_render", function()
    local lp = entity.get_local_player()
    if not lp then return end
    if not func.includes(ui.get(menu.visualsTab.MiscMultiselect), "Anim breakers") then return end
    local flags = entity.get_prop(lp, "m_fFlags")
    ground_ticks = bit.band(flags, 1) == 0 and 0 or (ground_ticks < 5 and ground_ticks + 1 or ground_ticks)

    if func.includes(ui.get(menu.visualsTab.animations), "Static legs") then
        entity.set_prop(lp, "m_flPoseParameter", 1, 0) 
    end

    if func.includes(ui.get(menu.visualsTab.animations), "In air") and bit.band(flags, 1) == 0 then
        entity.set_prop(lp, "m_flPoseParameter", 1, 6) 
    end

    if func.includes(ui.get(menu.visualsTab.animations), "Leg fucker") then
        entity.set_prop(lp, "m_flPoseParameter", 1, globals.tickcount() % 4 > 1 and 5 / 10 or 1)
    end

    if func.includes(ui.get(menu.visualsTab.animations), "On land") then
        ground_ticks = bit.band(flags, 1) == 1 and ground_ticks + 1 or 0

        if ground_ticks > 20 and ground_ticks < 150 then
            entity.set_prop(lp, "m_flPoseParameter", 0.5, 12)
        end
    end

    if func.includes(ui.get(menu.visualsTab.animations), "Allah legs") then
        entity.set_prop(lp, "m_flPoseParameter", 1, 7)
        ui.set(refs.legMovement, "Never slide")
    end

    if func.includes(ui.get(menu.visualsTab.animations), "Haram legs") then
        local lp = ent.get_local_player()
        local m_fFlags = lp:get_prop("m_fFlags")
        local is_onground = bit.band(m_fFlags, 1) ~= 0 
        
        if not is_onground then 
            local my_animlayer = lp:get_anim_overlay(6)
            my_animlayer.weight = 1 
            entity.set_prop(lp, "m_flPoseParameter", 1, 6) 
        end
    end

    if func.includes(ui.get(menu.visualsTab.animations), "Blend legs") then
        entity.set_prop(lp, "m_flPoseParameter", 0, 8)
        entity.set_prop(lp, "m_flPoseParameter", 0, 9)
        entity.set_prop(lp, "m_flPoseParameter", 0, 10)
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
client.set_event_callback("paint", function()
    local local_player = entity.get_local_player()
    if local_player == nil or entity.is_alive(local_player) == false then return end
    local sizeX, sizeY = client.screen_size()
    local weapon = entity.get_player_weapon(local_player)
    local bodyYaw = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
    local side = bodyYaw > 0 and 1 or -1
    local state = vars.intToS[vars.pState]:upper()
    local mainClr = {}
    mainClr.r, mainClr.g, mainClr.b, mainClr.a = ui.get(menu.visualsTab.indicatorsClr)
    local arrowClr = {}
    arrowClr.r, arrowClr.g, arrowClr.b, arrowClr.a = ui.get(menu.visualsTab.arrowClr)
    local fake = math.floor(antiaim_funcs.get_desync(1))

    if ui.get(menu.visualsTab.watermark) == "Old" then
        wAlpha = func.lerp(wAlpha, 255, globals.frametime() * 3)
    else
        wAlpha = func.lerp(wAlpha, 0, globals.frametime() * 11)
    end

    local watermarkClr = {}
    watermarkClr.r, watermarkClr.g, watermarkClr.b = ui.get(menu.visualsTab.watermarkClr)

    if readfile("bluh.png") ~= nil and ui.get(menu.visualsTab.watermark) == "Old" then
        local mainY = 4
        local marginX, marginY = renderer.measure_text("-d", lua_name:upper())
        local png = images.load_png(readfile("bluh.png"))
        png:draw(5, sizeY/2 - 9, 61, 64, 255, 255, 255, wAlpha, true, "f")
        renderer.text(69, sizeY/2 + 15, 255, 255, 255, wAlpha, "-d", nil, lua_name:upper() .. "\a" .. func.RGBAtoHEX(watermarkClr.r, watermarkClr.g, watermarkClr.b, wAlpha) .. ".LUA")
        renderer.text(69, sizeY/2 + 23, 255, 255, 255, wAlpha, "-d", nil, "USER - " .. login.username:upper() .. "\a" .. func.RGBAtoHEX(watermarkClr.r, watermarkClr.g, watermarkClr.b, wAlpha) .. " [" .. login.build:upper() .. "]")
    end
    
    if readfile("bluhhudv1.png") ~= nil and ui.get(menu.visualsTab.hud) == "v1" and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "bluhgang menu") then
        local png = images.load_png(readfile("bluhhudv1.png"))
        png:draw(ui.get(menu.visualsTab.hudX), ui.get(menu.visualsTab.hudY), 267, 172)
    end

    if readfile("bluhhudv2.png") ~= nil and ui.get(menu.visualsTab.hud) == "v2" and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "bluhgang menu") then
        local png = images.load_png(readfile("bluhhudv2.png"))
        png:draw(ui.get(menu.visualsTab.hudX), ui.get(menu.visualsTab.hudY), 273, 142)
    end


    -- draw arrows
    if func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "Crosshair Arrows") then
        if ui.get(menu.visualsTab.arrowIndicatorStyle) == "Standart" then
            alpha = (aa.manualAA == 2 or aa.manualAA == 1) and func.lerp(alpha, 255, globals.frametime() * 20) or func.lerp(alpha, 0, globals.frametime() * 20)
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
    if ui.get(menu.visualsTab.indicators) == "Soft" and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "Crosshair Indicators") then
        local dpi = ui.get(ui.reference("MISC", "Settings", "DPI scale")):gsub('%%', '') - 100
        local globalFlag = "cd"
        local globalMoveY = globalFlag == "cd-" and 5 + dpi/10 or 9 + dpi/10
        local indX, indY = renderer.measure_text(globalFlag, "DT")
        local yDefault = func.includes(ui.get(menu.visualsTab.indicatorsStyle), "State") and 18 or 9
        local indCount = 0
        indY = globalFlag == "cd-" and indY - 3 or indY - 2
    
        local isCharged = antiaim_funcs.get_double_tap()
        local isFs = ui.get(menu.builderTab.freestandHotkey)
        local isBa = ui.get(refs.forceBaim)
        local isSp = ui.get(refs.safePoint)
        local isQp = ui.get(refs.quickPeek[2])
        local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
        local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
        local isFd = ui.get(refs.fakeDuck)
        local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    
        local state = vars.intToS[vars.pState]:upper()
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "Name") then
            local namex, namey = renderer.measure_text(globalFlag, globalFlag == "cd-" and lua_name:upper() or lua_name:lower())
            local logo = animate_text(globals.curtime(), globalFlag == "cd-" and lua_name:upper() or lua_name:lower(), mainClr.r, mainClr.g, mainClr.b, 255)
    
            renderer.text(sizeX/2 + ((namex + 2)/2) * scopedFraction, sizeY/2 + 20 - dpi/10, 255, 255, 255, 255, globalFlag, nil, unpack(logo))
        end 
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "State") then
            local namex, namey = renderer.measure_text(globalFlag, globalFlag == "cd-" and lua_name:upper() or lua_name:lower())
            local stateX, stateY = renderer.measure_text(globalFlag, state:lower())
            local string = state:lower()
            renderer.text(sizeX/2 + (stateX + 2)/2 * scopedFraction, sizeY/2 + 20 + namey/1.2, 255, 255, 255, 255, globalFlag, 0, string)
        end
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "Doubletap") then
            if isDt then 
                dtClr.a = func.lerp(dtClr.a, 255, time)
                if dtInd.y < yDefault + indY * indCount then
                    dtInd.y = func.lerp(dtInd.y, yDefault + indY * indCount + 1, time)
                else
                    dtInd.y = yDefault + indY * indCount
                end
                chargeInd.w = 0.1
                if not isCharged and func.defensive.defensive > 1 then
                    dtClr.r = func.lerp(dtClr.r, 144, time)
                    dtClr.g = func.lerp(dtClr.g, 238, time)
                    dtClr.b = func.lerp(dtClr.b, 144, time)
                elseif not isCharged then
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
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "Hideshots") then
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
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "Freestand") then
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
            local fs_col = vars.fs and {255,255,255} or {222,55,55}
            renderer.text(sizeX / 2 + fsInd.x + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "FS" or "fs") + 2)/2) * scopedFraction, sizeY / 2 + fsInd.y + 13 + globalMoveY, fs_col[1], fs_col[2], fs_col[3], fsInd.a, globalFlag, fsInd.w, globalFlag == "cd-" and "FS" or "fs")
        end
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "Safepoint") then
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
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "Body aim") then
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
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "Fakeduck") then
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
    -- indicator d4ssh
    
    if ui.get(menu.visualsTab.indicators) == "Pixel" and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "Crosshair Indicators") then
        local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        local side = bodyyaw > 0 and 1 or -1
    
        local mr,mg,mb,ma = ui.get(menu.visualsTab.indicatorsClr)
    
        local x, y = client.screen_size()
    
        local me = entity.get_local_player()
    
        if not entity.is_alive(me) then return end
    
        local is_charged = antiaim_funcs.get_double_tap()
        local is_dt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
        local is_os = ui.get(refs.os[1]) and ui.get(refs.os[2])
        local is_fs = ui.get(refs.edgeYaw)
        local is_ba = ui.get(refs.forceBaim)
        local is_sp = ui.get(refs.safePoint)
        local is_qp = ui.get(refs.quickPeek[2])
    
        if is_charged then dr,dg,db,da=167, 252, 121,255 elseif is_os then dr,dg,db,da=255,255,255,255 else dr,dg,db,da=255,0,0,255 end;if is_qp then qr,qg,qb,qa=255,255,255,255 else qr,qg,qb,qa=255,255,255,150 end;if is_ba then br,bg,bb,ba=255,255,255,255 else br,bg,bb,ba=255,255,255,150 end;if is_fs then fr,fg,fb,fa=255,255,255,255 else fr,fg,fb,fa=255,255,255,150 end;if is_sp then sr,sg,sb,sa=255,255,255,255 else sr,sg,sb,sa=255,255,255,150 end
        --sine_in
        
    
        local _, y2 = client.screen_size()
    
        local realtime = globals.realtime() % 3
        local alpha = math.floor(math.sin(realtime * 4) * (180 / 2 - 1) + 180 / 2) or 180
    
        local exp_ind = ""
    
        if is_dt then
            exp_ind = "DT"
        elseif is_os then
            exp_ind = "HS"
        end
    
        local me = entity.get_local_player()
        local wpn = entity.get_player_weapon(me)
    
        local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
        local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
        local resume_zoom = entity.get_prop(me, 'm_bResumeZoom') == 1
    
        local is_valid = entity.is_alive(me) and wpn ~= nil and scope_level ~= nil
        local act = is_valid and scope_level > 0 and scoped and not resume_zoom
    
        local flag = "c-"
        local ting = 0
        local testting = 0
    
        --animation shit
    
        if is_dt or is_os then
            n4_x = hitler.lerp(n4_x, 8, globals.frametime() * 8)
        else
            n4_x = hitler.lerp(n4_x, -1, globals.frametime() * 8)
        end
    
        if act then
            flag = "-"
            ting = 23
            testting = 11
    
            testx = hitler.lerp(testx, 30, globals.frametime() * 5)
    
            n2_x = hitler.lerp(n2_x, 11, globals.frametime() * 5)
    
            n3_x = hitler.lerp(n3_x, 5, globals.frametime() * 5)
    
        else
            testx = hitler.lerp(testx, 0, globals.frametime() * 5)
    
            n2_x = hitler.lerp(n2_x, 0, globals.frametime() * 5)
    
            n3_x = hitler.lerp(n3_x, 0, globals.frametime() * 5)
    
            flag = "c-"
            ting = 28
        end
    
        if is_dt then if dt_a<255 then dt_a=dt_a+5 end;if dt_w<10 then dt_w=dt_w+0.28 end;if dt_y<36 then dt_y=dt_y+1 end;if fs_x<11 then fs_x=fs_x+0.25 end elseif not is_dt then if dt_a>0 then dt_a=dt_a-5 end;if dt_w>0 then dt_w=dt_w-0.2 end;if dt_y>25 then dt_y=dt_y-1 end;if fs_x>0 then fs_x=fs_x-0.25 end end;if is_os and not is_dt then if os_a<255 then os_a=os_a+5 end;if os_w<12 then os_w=os_w+0.28 end;if os_y<36 then os_y=os_y+1 end;if fs_x<12 then fs_x=fs_x+0.5 end elseif not is_os and not is_dt then if os_a>0 then os_a=os_a-5 end;if os_w>0 then os_w=os_w-0.2 end;if os_y>25 then os_y=os_y-1 end;if fs_x>0 then fs_x=fs_x-0.5 end end;if is_fs then if fs_w<10 then fs_w=fs_w+0.35 end;if fs_a<255 then fs_a=fs_a+5 end;if dt_x>-7 then dt_x=dt_x-0.5 end;if os_x>-7 then os_x=os_x-0.5 end;if fs_y<36 then fs_y=fs_y+1 end elseif not is_fs then if fs_a>0 then fs_a=fs_a-5 end;if fs_w>0 then fs_w=fs_w-0.2 end;if dt_x<0 then dt_x=dt_x+0.5 end;if os_x<0 then os_x=os_x+0.5 end;if fs_y>25 then fs_y=fs_y-1 end end
    
        if ui.get(menu.visualsTab.indicators) == "Pixel" and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "Crosshair Indicators") then
            if is_dt then
                renderer.text(x / 2 - 0.5, y2 / 2 + os_y + 10, dr, dg, db, os_a, "c-", os_w, " ")
            else
                renderer.text(x / 2 - 0.5, y2 / 2 + os_y+ 10, dr, dg, db, os_a, "c-", os_w, "OS ")
            end
            renderer.text(x / 2 - 0.5, y2 / 2 + dt_y+ 10, dr, dg, db, dt_a, "c-", dt_w, "DT")
    
            --renderer.text(x / 2 - 0.5 + fs_x + n3_x, y2 / 2 + fs_y+ 10, 255, 255, 255, fs_a, "c-", fs_w, "FS")
    
            local wx, wy = client.screen_size()
            
            --round_rect(wx - 30, wy - wy - 180, 89, 52, 235)
    
            local desync_type = antiaim_funcs.get_overlap(float)
            local desync_type2 = antiaim_funcs.get_desync(2)
    
            renderer.text(x / 2-28, y / 2 + 25, mr,mg,mb, 255, "-", 0, 'BLUHGANG')
            renderer.text(x / 2+13, y / 2 + 25, 255, 161, 161, 255, "-", 0, login.build:upper())
            renderer.text(wx / 2-1, y / 2 + 38.5 , 255,255,255, 255, "c-", 0, state)
            renderer.text(x / 2-15, y / 2 + 47 + n4_x, br, bg, bb, ba, "c-", 0, "BAIM")
            renderer.text(x / 2, y / 2 + 47 + n4_x, qr,qg,qb,qa, "c-", 0, "QP")
            renderer.text(x / 2+10, y / 2 + 47 + n4_x, sr, sg, sb, sa, "c-", 0, "SP")
            renderer.text(x / 2+20, y / 2 + 47 + n4_x, fr, fg, fb, fa, "c-", 0, "FS")
        end
    
        local localp = entity.get_local_player()
    
        local bodyyaw = entity.get_prop(localp, "m_flPoseParameter", 11) * 120 - 60
        -- ⯇ ⯈ ⯅ ⯆
    
	end

    -- draw dmg indicator
    if func.includes(ui.get(menu.visualsTab.MiscMultiselect), "Min DMG indicator") and entity.get_classname(weapon) ~= "CKnife" and ui.get(refs.dmgOverride[1]) and ui.get(refs.dmgOverride[2]) then
        local dmg = ui.get(refs.dmgOverride[3])
        renderer.text(sizeX / 2 + 2, sizeY / 2 - 14, 255, 255, 255, 255, "d", 0, dmg)
    end

    -- draw watermark
    if ui.get(menu.visualsTab.watermark) == "Default" then
        local me = entity.get_local_player()
        if me == nil then return end
        local rr,gg,bb = 87, 235, 61
        local width, height = client.screen_size()
        local r2, g2, b2, a2 = 55, 55, 55,255
        local highlight_fraction =  (globals.realtime() / 2 % 1.2 * 2) - 1.2
        local output = ""
        local text_to_draw = "B L U H G A N G"
        for idx = 1, #text_to_draw do
            local character = text_to_draw:sub(idx, idx)
            local character_fraction = idx / #text_to_draw
            local r1, g1, b1, a1 = 255, 255, 255, 255
            local highlight_delta = (character_fraction - highlight_fraction)
            if highlight_delta >= 0 and highlight_delta <= 1.4 then
                if highlight_delta > 0.7 then
                highlight_delta = 1.4 - highlight_delta
                end
                local r_fraction, g_fraction, b_fraction, a_fraction = r2 - r1, g2 - g1, b2 - b1
                r1 = r1 + r_fraction * highlight_delta / 0.8
                g1 = g1 + g_fraction * highlight_delta / 0.8
                b1 = b1 + b_fraction * highlight_delta / 0.8
            end
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, 255, text_to_draw:sub(idx, idx))
        end
        output = output
        
        local r,g,b,a = 87, 235, 61
        if ui.get(menu.visualsTab.watermarkPosition) == "Left" then
            renderer.text(width - (width-80), height - (height/2 - height/20), r, g, b, 255, "c", 0, output .. ' \afa5757FF [beta]')
        elseif ui.get(menu.visualsTab.watermarkPosition) == "Bottom" then
            renderer.text(width - (width/2), height - (height/32), r, g, b, 255, "c", 0, output .. ' \afa5757FF [beta]')
        elseif ui.get(menu.visualsTab.watermarkPosition) == "Right" then
            renderer.text(width-83, height - (height/2 - height/20), r, g, b, 255, "c", 0, output .. ' \afa5757FF [beta]')
        end
    end


    -- draw logs
    local call_back = ui.get(menu.visualsTab.logs) and client.set_event_callback or client.unset_event_callback

    notifications.render()
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

client.set_event_callback("paint_ui", function()
    if not ui.get(menu.visualsTab.devPrint) then return end
    device:on_update()
    notify:should_draw()
    notify:on_paint_ui()
end)

client.set_event_callback("output", function(e)
    notify:on_output(e)
end)

client.set_event_callback("console_input", function(e)
    if not ui.get(menu.visualsTab.devPrint) then return end
    notify:on_console_input(e)
end)

ui.set_callback(menu.visualsTab.devPrint, function() 
    local callback = ui.get(menu.visualsTab.devPrint) and client.set_event_callback or client.unset_event_callback
    callback("output", function(e) notify:on_output(e) end)
end)

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
    if ui.get(menu.builderTab.PresetComboBox) == "[beta] scalevillain" then
        local r, g, b = ui.get(menu.visualsTab.logsClr)

        local protected = function()
            importPreset()
        end

        if pcall(protected) then
            notifications.new(string.format('Successfully enabled [beta] scalevillain', name), r, g, b)
        else
            notifications.new(string.format('Error with presets scalevillain, bugreport this please', name), 255, 120, 120)
        end
    end
end)

ui.set_callback(menu.builderTab.buttonPresets, function()
    local r, g, b = ui.get(menu.visualsTab.logsClr)

    local protected = function()
        ui.set(menu.builderTab.LogicComboBox, "2")
    end

    if pcall(protected) then
        notifications.new(string.format('Successfully enabled presets mode', name), r, g, b)
    else
        notifications.new(string.format('Failed to enable presets mode', name), 255, 120, 120)
    end
end)

ui.set_callback(menu.builderTab.buttonBuilder, function()
    local r, g, b = ui.get(menu.visualsTab.logsClr)

    local protected = function()
        ui.set(menu.builderTab.LogicComboBox, "1")
        ui.set(menu.builderTab.PresetComboBox, "Disabled")
        importPresetClear()
    end

    if pcall(protected) then
        notifications.new(string.format('Successfully enabled builder mode', name), r, g, b)
    else
        notifications.new(string.format('Failed to enable builder mode', name), 255, 120, 120)
    end
end)

-- @region UI_CALLBACKS end

local uifix = {
    newline19 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline14 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline15 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline16 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline17 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline18 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline193 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline143 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline153 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline163 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline173 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline183 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline1732 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline1832 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline1731 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline1831 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline1735 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
    newline1835 = ui.new_label('AA', 'Anti-aimbot angles', '\n', 'string'),
}

-- @region UI_RENDER start
client.set_event_callback("paint_ui", function()
    vars.activeState = vars.sToInt[ui.get(menu.builderTab.state)]
    local isEnabled = ui.get(masterSwitch)
    local isGeneralTab = ui.get(tabPicker1) == "General"
    local isSettingsTab = ui.get(tabPicker1) == "Settings"
    local isBuilderTab = vars.currentTab == 2 and isSettingsTab
    local isVisualsTab = vars.currentTab == 3 and isSettingsTab
    local isCFGTab = vars.currentTab == 4 and isSettingsTab
    local ispresetdisabled = ui.get(menu.builderTab.PresetComboBox) == "Disabled"
    local isLogicBuilder = ui.get(menu.builderTab.LogicComboBox) == "1"
    local isLogicPresets = ui.get(menu.builderTab.LogicComboBox) == "2"
    ui.set_visible(tabPicker1, isEnabled)
    ui.set_visible(menu.GeneralTab.text1, isEnabled and isGeneralTab)
    ui.set_visible(menu.GeneralTab.text2, isEnabled and isGeneralTab)
    ui.set_visible(menu.GeneralTab.text3, isEnabled and isGeneralTab)
    ui.set_visible(menu.GeneralTab.discord, isEnabled and isGeneralTab)
    ui.set_visible(menu.GeneralTab.newline1, isEnabled and isGeneralTab)
    ui.set_visible(menu.GeneralTab.newline2, isEnabled and isGeneralTab)
    ui.set_visible(builderBtn, vars.currentTab == 1 and isEnabled and isSettingsTab)
    ui.set_visible(visBtn, vars.currentTab == 1 and isEnabled and isSettingsTab)
    ui.set_visible(cfgBtn, vars.currentTab == 1 and isEnabled and isSettingsTab)
    ui.set_visible(backBtn, vars.currentTab ~= 1 and isEnabled and isSettingsTab)

    for i, feature in pairs(menu.builderTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isBuilderTab and isEnabled)
        end
	end 

    for i, feature in pairs(menu.builderTab.manualTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isBuilderTab and isEnabled)
        end
	end 
    
    ui.set(aaBuilder[1].enableState, true)
    for i = 1, #vars.aaStates do
        local stateEnabled = ui.get(aaBuilder[i].enableState)
        ui.set_visible(aaBuilder[i].enableState, vars.activeState == i and isBuilderTab and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].pitch, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].pitchSlider , vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].pitch) == "Custom" and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawBase, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawCondition, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawStatic, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "Static" and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawLeft, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) ~= "Static" and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawRight, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) ~= "Static" and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawSpeed, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "Slow" and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawJitter, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawJitterCondition, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawJitterStatic, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "Static" and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawJitterLeft, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "L & R" and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawJitterRight, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "L & R" and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].yawJitterDisablers, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].bodyYaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].bodyYawSlider, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensiveOpt, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensiveYaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensiveYawSlider, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ui.get(aaBuilder[i].defensiveYaw) == "Custom" and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensivePitch, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ispresetdisabled and isLogicBuilder)
        ui.set_visible(aaBuilder[i].defensivePitchSlider, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ui.get(aaBuilder[i].defensivePitch) == "Custom" and ispresetdisabled and isLogicBuilder)
    end

    -- builderTab
    ui.set_visible(menu.builderTab.state, ui.get(menu.builderTab.PresetComboBox) == "Disabled" and isBuilderTab and isEnabled and isLogicBuilder)
    ui.set_visible(menu.builderTab.buttonBuilder, isBuilderTab and isEnabled and isLogicPresets)
    ui.set_visible(menu.builderTab.buttonPresets, isBuilderTab and isEnabled and isLogicBuilder)
    ui.set_visible(menu.builderTab.PresetComboBox, isBuilderTab and isEnabled and isLogicPresets)
    ui.set_visible(menu.builderTab.LogicComboBox, isBuilderTab and isEnabled and logica1337 == "1")
    ui.set_visible(menu.builderTab.freestandHotkey, isBuilderTab and isEnabled and func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Freestand"))
    ui.set_visible(menu.builderTab.freestandDisablers, isBuilderTab and isEnabled and func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Freestand"))
    ui.set_visible(menu.builderTab.avoidBackstab, isBuilderTab and isEnabled and func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Avoid Backstab"))
    ui.set_visible(menu.builderTab.edgeYawHotkey, isBuilderTab and isEnabled and func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Edge Yaw"))
    ui.set_visible(menu.builderTab.staticManuals, isBuilderTab and isEnabled and func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Manuals"))
    ui.set_visible(menu.builderTab.manualTab.manualLeft, isBuilderTab and isEnabled and func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Manuals"))
    ui.set_visible(menu.builderTab.manualTab.manualRight, isBuilderTab and isEnabled and func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Manuals"))
    ui.set_visible(menu.builderTab.manualTab.manualForward, isBuilderTab and isEnabled and func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Manuals"))
    ui.set_visible(menu.builderTab.manualTab.manualReset, isBuilderTab and isEnabled and func.includes(ui.get(menu.builderTab.TweaksMultiselect), "Manuals"))

    for i, feature in pairs(uifix) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isBuilderTab and isEnabled)
        end
	end 


    for i, feature in pairs(menu.visualsTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isVisualsTab and isEnabled)
        end
	end 
    ui.set_visible(menu.visualsTab.logs, isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "On screen logs"))
    ui.set_visible(menu.visualsTab.logOffset, ui.get(menu.visualsTab.logs) and isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "On screen logs"))
    ui.set_visible(menu.visualsTab.logsClr, ui.get(menu.visualsTab.logs) and isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "On screen logs"))
    ui.set_visible(menu.visualsTab.indicators, isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "Crosshair Indicators"))
    ui.set_visible(menu.visualsTab.indicatorsStyle, ui.get(menu.visualsTab.indicators) == "Soft" and isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "Crosshair Indicators"))
    ui.set_visible(menu.visualsTab.indicatorsClr, isVisualsTab and isEnabled and ui.get(menu.visualsTab.indicators) ~= "Disabled" and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "Crosshair Indicators"))
    ui.set_visible(menu.visualsTab.arrowIndicatorStyle, isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "Crosshair Arrows"))
    ui.set_visible(menu.visualsTab.arrowClr, isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "Crosshair Arrows"))
    ui.set_visible(menu.visualsTab.watermarkClr, ui.get(menu.visualsTab.watermark) == "Old" and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.watermarkPosition, ui.get(menu.visualsTab.watermark) == "Default" and isVisualsTab and isEnabled)
    ui.set_visible(menu.configTab.export, isLogicBuilder and isCFGTab and isEnabled)
    ui.set_visible(menu.configTab2.WarningConfig, isLogicPresets and isCFGTab and isEnabled)
    ui.set_visible(menu.configTab2.WarningConfig2, isLogicPresets and isCFGTab and isEnabled)
    ui.set_visible(menu.visualsTab.fastLadder, isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.MiscMultiselect), "Fast ladder"))
    ui.set_visible(menu.visualsTab.animations, isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.MiscMultiselect), "Anim breakers"))
    ui.set_visible(menu.visualsTab.devPrint, isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.MiscMultiselect), "Old console logs"))
    ui.set_visible(menu.visualsTab.hud, isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "bluhgang menu"))
    ui.set_visible(menu.visualsTab.hudX, ui.get(menu.visualsTab.hud) ~= "Disabled" and isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "bluhgang menu"))
    ui.set_visible(menu.visualsTab.hudY, ui.get(menu.visualsTab.hud) ~= "Disabled" and isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.VisualsMultiselect), "bluhgang menu"))
    ui.set_visible(menu.visualsTab.trashTalk, isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.MiscMultiselect), "Trashtalk"))
    ui.set_visible(menu.visualsTab.TrashTalkLanguage, ui.get(menu.visualsTab.trashTalk) and isVisualsTab and isEnabled and func.includes(ui.get(menu.visualsTab.MiscMultiselect), "Trashtalk"))
    
    for i, feature in pairs(menu.configTab) do
		ui.set_visible(feature, isLogicBuilder and isCFGTab and isEnabled)
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