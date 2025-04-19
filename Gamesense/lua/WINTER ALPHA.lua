local lua_name = "winter"
local lua_color = {r = 155, g = 157, b = 217}
local obex_data = obex_fetch and obex_fetch() or {username = 'alpha', build = 'alpha', discord='https://discord.gg/auTEU8dcv6'}
    

local vector = require("vector")

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


ffi.cdef [[
    struct animation_layer_t {
		bool m_bClientBlend;		 //0x0000
		float m_flBlendIn;			 //0x0004
		void* m_pStudioHdr;			 //0x0008
		int m_nDispatchSequence;     //0x000C
		int m_nDispatchSequence_2;   //0x0010
		uint32_t m_nOrder;           //0x0014
		uint32_t m_nSequence;        //0x0018
		float m_flPrevCycle;       //0x001C
		float m_flWeight;          //0x0020
		float m_flWeightDeltaRate; //0x0024
		float m_flPlaybackRate;    //0x0028
		float m_flCycle;           //0x002C
		void* m_pOwner;              //0x0030
		char pad_0038[4];            //0x0034
    };
    struct c_animstate { 
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84   
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334
        float m_flMinYaw; //0x330
    };
]]

local classptr = ffi.typeof('void***')
local rawientitylist = client.create_interface('client.dll', 'VClientEntityList003') or
                           error('VClientEntityList003 wasnt found', 2)

local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)
local get_client_networkable = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][0]) or
                                   error('get_client_networkable_t is nil', 2)
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or
                              error('get_client_entity is nil', 2)

local rawivmodelinfo = client.create_interface('engine.dll', 'VModelInfoClient004')
local ivmodelinfo = ffi.cast(classptr, rawivmodelinfo) or error('rawivmodelinfo is nil', 2)
-- @region basic ffi start 

local ffi = require 'ffi'

ffi.cdef[[
    typedef void*(__thiscall* get_net_channel_info_t)(void*);

    typedef float(__thiscall* get_avg_latency_t)(void*, int);
    typedef float(__thiscall* get_avg_loss_t)(void*, int);
    typedef float(__thiscall* get_avg_choke_t)(void*, int);
]]

local interface_ptr = ffi.typeof('void***')
local rawivengineclient = client.create_interface('engine.dll', 'VEngineClient014') or error('VEngineClient014 wasnt found', 2)
local ivengineclient = ffi.cast(interface_ptr, rawivengineclient) or error('rawivengineclient is nil', 2)
local get_net_channel_info = ffi.cast('get_net_channel_info_t', ivengineclient[0][78]) or error('ivengineclient is nil')

local timers = (function()local b={}b.timers={}function b:update(c,d)local e=false;if self.timers[c]==nil or self.timers[c]-globals.realtime()<=0 then self.timers[c]=globals.realtime()+d;e=true end;return e end;return b end)()
local gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end
local gram_update = function(tab, value, forced) local new_tab = tab; if forced or new_tab[#new_tab] ~= value then table.insert(new_tab, value); table.remove(new_tab, 1); end; tab = new_tab; end

local get_average = function(tab) local elements, sum = 0, 0; for k, v in pairs(tab) do sum = sum + v; elements = elements + 1; end return sum / elements; end

local loss_data = gram_create(0, 16)
local ffi_loss = {
    tr = 0,
    tr_ex = 0,
    maximum = 0.00,
}



-- @region DATABASE & OBEX start

local login = {
    username = obex_data.username,
    version = "1.0.0",
    build = obex_data.build,
}

if login.build == 'User' then
    login.build = 'alpha'
end
--[winter] ~
client.exec("clear")
client.color_log(159,202,43, "[winter] ~\0")
client.color_log(255, 255, 255, " Welcome back,\0")
client.color_log(159,202,43, " " .. login.username .. "!")
client.color_log(159,202,43, "[winter] ~\0")
client.color_log(255, 255, 255, " Your build is:\0")
client.color_log(159,202,43, ' ' .. login.build:lower() .. '!')
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
    AntiAimCorrect = ui.reference("RAGE", "Other", "Anti-aim correction"),
    CorrectEnable = ui.reference("PLAYERS", "Adjustments", "Correction active"),
    ForceBodyYawValue = {ui.reference("PLAYERS", "Adjustments", "Force body yaw value")},
    ForceBodyYaw = ui.reference("PLAYERS", "Adjustments", "Force body yaw"),
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
    intToS = {[1] = "Global", [2] = "Standing", [3] = "Moving", [4] = "Slowwalk", [5] = "Ducking", [6] = "Jumping", [7] = "Jumping+", [8] = "Legit"},
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


local kill = {
    "ты не иглок",
    "гет гуд гет winter",
    "пздц ты немощ",
    "pfdnhf d irjke, cgb csyjr t,fyysq",
    "слоу пидарас",
    "пошел нахуй",
    "лижи мне пятки уебанец",
    "я тя вытрахал под самые гланды",
    "тебе уже пора осознать что ты слоу",
    "ты как *ANYA HVH* так же отсасываешь мою дикулю",
    "сынок, пора тебе покупать лучший скрипт на gamesense (https://discord.gg/auTEU8dcv6)",
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
        
        client.delay_call(3, function() 
            client.exec(say)
        end)
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
			print("[!] Failed fetch the country image, please contact admin to fix this issue!")
            return
		end

		download = response.body
	end)
end

downloadFile()

-- @region FUNCS end

-- @region UI_LAYOUT start
local tab, container = "AA", "Anti-aimbot angles"
local masterSwitch = ui.new_checkbox(tab, container, 'winter - ' .. login.username:lower())
local tabPicker = ui.new_combobox(tab, container, "\nTab", "Anti-aim", "Builder", "Visuals", "Misc", "Config")

local menu = {
    aaTab = {
        aamenushka = ui.new_multiselect(tab, container, "\nTasdasdsadsadsadasdad", "Adjust fakelag limit", "Discharge Exploit", "Safe Knife", "Freestand", "Edge Yaw", "Avoid~Backstab", "Manuals", "Static on manuals"),
--        BombEfix = ui.new_checkbox(tab, container, "Fix E Bombsite"),
        freestandHotkey = ui.new_hotkey(tab, container, "Freestand"),
        freestandDisablers = ui.new_multiselect(tab, container, "› Disablers", {"Air", "Slowmo", "Duck", "Manual"}),
        edgeYawHotkey = ui.new_hotkey(tab, container, "Edge Yaw"),
        manualTab = {
            manualLeft = ui.new_hotkey(tab, container, "› Manual " .. func.hex({200,200,200}) .. "left"),
            manualRight = ui.new_hotkey(tab, container, "› Manual " .. func.hex({200,200,200}) .. "right"),
            manualReset = ui.new_hotkey(tab, container, "› Manual " .. func.hex({200,200,200}) .. "reset"),
            manualForward = ui.new_hotkey(tab, container, "› Manual " .. func.hex({200,200,200}) .. "forward"),
        },
    },
    builderTab = {
        state = ui.new_combobox(tab, container, "Anti-aim state", vars.aaStates)
    },
    visualsTab = {
        space = ui.new_label(tab, container, '\nTab3'),
        BackgroundColorLabel = ui.new_label(tab, container, 'Background Color'),
        BackgroundColor = ui.new_color_picker(tab, container, "Background Color", lua_color.r, lua_color.g, lua_color.b, 255),
        space9 = ui.new_label(tab, container, '\nTab4'),
        indicators = ui.new_combobox(tab, container, "Indicators", "Disabled", "Soft"),
        indicatorsClr = ui.new_color_picker(tab, container, "Main Color", lua_color.r, lua_color.g, lua_color.b, 255),
        indicatorsStyle = ui.new_multiselect(tab, container, "\n Elements", "Name", "State", "Doubletap", "Hideshots", "Freestand", "Safepoint", "Body aim", "Fakeduck"),
        arrows = ui.new_combobox(tab, container, "Arrows", "Disabled", "TS", "Default"),
        arrowClr = ui.new_color_picker(tab, container, "Arrow Color", lua_color.r, lua_color.g, lua_color.b, 255),
        watermarkMenu = ui.new_combobox(tab, container, "Watermark", "Disabled",  "LS", "winter", "winter #2"),
        watermarkClr2 = ui.new_color_picker(tab, container, "Watermark Color", lua_color.r, lua_color.g, lua_color.b, 255),
        minDmgIndicator2 = ui.new_combobox(tab, container, "Minimum Damage Indicator", "Disabled", "Bind", "Always on"),
        logs = ui.new_multiselect(tab, container, "Logs", "On screen", "Console"),
        logsClr = ui.new_color_picker(tab, container, "Logs Color", lua_color.r, lua_color.g, lua_color.b, 255),
        logOffset = ui.new_slider(tab, container, "› Offset", 0, 700, 160, true, "px", 1),
        space3 = ui.new_label(tab, container, '\n'),
    },
    miscTab = {
        miscmenushka = ui.new_multiselect(tab, container, "\nTaadssadadasdadasdsadasdasda", "Clantag", "Trashtalk", "Fast Ladder", "Animation Breaker", func.hex({170,170,96}) .. "Jitter Fix *WIP*", func.hex({170,170,96}) .. "Network Fix *WIP*", func.hex({170,170,96}) .. "Defensive Fix *WIP*"),
        trashTalk = ui.new_checkbox(tab, container, "Trashtalk"),
        fastLadderEnabled = ui.new_checkbox(tab, container, "Fast ladder"),
        fastLadder = ui.new_multiselect(tab, container, "\n fast ladder", "Up", "Down"),
        animationsEnabled = ui.new_checkbox(tab, container, "Animation Breakers"),
        animations = ui.new_multiselect(tab, container, "\n animation breakers", "Backward Legs", "In air", "0 Pitch on land", "Leg fucker", "Moonwalking", "Walking in Air", "Freezed legs", "Earthquake"),
        jitterFixEnabled = ui.new_checkbox(tab, container, func.hex({170,170,96}) .. "Jitter Fix *WIP*"),
        jitterFix = ui.new_combobox(tab, container, "\n jitterfix", "Recommended", "By One Side", "By Two Side", "By Delta"),
        jitterFixOffset = ui.new_slider(tab, container, "› Offset", 1, 10, 3, true, "t", 1),
        jitterwarning3 = ui.new_label(tab, container, func.hex({170,170,96}) .. "May accures a delay!"),
        jitterwarning4 = ui.new_label(tab, container, '\nZaebal'),
        jitterwarning = ui.new_label(tab, container, func.hex({170,170,96}) .. "You're ping needed be lower than 85ms"),
        jitterwarning2 = ui.new_label(tab, container, func.hex({170,170,96}) .. "Or you will get a negative experience")

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
        enableState = ui.new_checkbox(tab, container, "Redefine " .. func.hex({170,170,96}) .. vars.aaStates[i] .. func.hex({200,200,200}) .. " Condition"),
        pitch = ui.new_combobox(tab, container, "Pitch\n" .. aaContainer[i], "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
        pitchSlider = ui.new_slider(tab, container, "\nPitch add" .. aaContainer[i], -89, 89, 0, true, "°", 1),
        yawBase = ui.new_combobox(tab, container, "Yaw base\n" .. aaContainer[i], "Local view", "At targets"),
        yaw = ui.new_combobox(tab, container, "Yaw\n" .. aaContainer[i], "Off", "180", "Spin", "180 Z"),
        yawCondition = ui.new_combobox(tab, container, "Yaw condition\n" .. aaContainer[i], "Static", "L & R", "Slow Jitter"),
        yawStatic = ui.new_slider(tab, container, "\nyaw limit" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawLeft = ui.new_slider(tab, container, "Left\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawRight = ui.new_slider(tab, container, "Right\nyaw" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawSpeed = ui.new_slider(tab, container, "Yaw Ticks\nyaw" .. aaContainer[i], 3, 16, 6, 0),
        yawJitter = ui.new_combobox(tab, container, "Yaw jitter\n" .. aaContainer[i], "Off", "Offset", "Center", "3-Way", "Random"),
        yawJitterCondition = ui.new_combobox(tab, container, "Yaw jitter condition\n" .. aaContainer[i], "Static", "L & R"),
        yawJitterStatic = ui.new_slider(tab, container, "\nyaw jitter limit" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterLeft = ui.new_slider(tab, container, "Left\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterRight = ui.new_slider(tab, container, "Right\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        yawJitterDisablers = ui.new_multiselect(tab, container, "Jitter disablers\n" .. aaContainer[i], "Head safety", "Height advantage"),
        bodyYaw = ui.new_combobox(tab, container, "Body yaw\n" .. aaContainer[i], "Off", "Opposite", "Jitter", "Static"),
        bodyYawSlider = ui.new_slider(tab, container, "\nbody yaw limit" .. aaContainer[i], -180, 180, 0, true, "°", 1),
        defensiveOpt = ui.new_combobox(tab, container, "Defensive options\n" .. aaContainer[i], "-", "Elusive mode", "Always on", "Always on Tick"),
        defensiveOptSlider = ui.new_slider(tab, container, "\nDefensiveOptSlider" .. aaContainer[i], 3, 50, 0, true, "t", 1),
        defensiveYaw = ui.new_combobox(tab, container, "Defensive yaw\n" .. aaContainer[i], "-", "Random",  "Spin", "Jitter", "Custom"),
        defensiveYawSlider = ui.new_slider(tab, container, "\nDefensiveYawSlider" .. aaContainer[i], -180, 180, 0, true, "", 1),
        defensiveYawSlider2 = ui.new_slider(tab, container, "\nDefensiveYawSlider2" .. aaContainer[i], -180, 180, 0, true, "", 1),
        defensivePitch = ui.new_combobox(tab, container, "Defensive pitch\n" .. aaContainer[i], "-", "Custom", "Random", "Jitter"),
        defensivePitchSlider = ui.new_slider(tab, container, "\nDefensivePitchSlider" .. aaContainer[i], -89, 89, 0, true, "°", 1),
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

    local link = "https://text.is/O6L3/raw"

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

-- @region winter resolver ceo

local function NormalizeAngle(angle)
    while angle > 180 do
        angle = angle - 360
    end

    while angle < -180 do
        angle = angle + 360
    end

    return angle
end

local function GetAnimationState(player)
    if not ui.get(menu.miscTab.jitterFixEnabled) then return end
    if not (player) then
        return
    end
    local player_ptr = ffi.cast("void***", get_client_entity(ientitylist, player))
    local animstate_ptr = ffi.cast("char*", player_ptr) + 0x9960
    local state = ffi.cast("struct c_animstate**", animstate_ptr)[0]
    return state
end

local eye_yaw = 1
local ent_name = "none"
local side = -1
local side2 = -1


local function ResolveJitter(player)
    if not ui.get(menu.miscTab.jitterFixEnabled) then return end
    local animstate = GetAnimationState(player)
    local lpent = get_client_entity(ientitylist, player)

    local delta = entity.get_prop(player, "m_angEyeAngles[1]") - entity.get_prop(player, "m_flPoseParameter", 11)

    eye_yaw = animstate.m_flEyeYaw

    ent_name = entity.get_player_name(player)

    local yaws

    local yaw1 = (entity.get_prop(player, "m_flPoseParameter", 11) or 1) * 116 - 58


    side = globals.tickcount() % 2 == 1 and -1 or 1
    side2 = (globals.tickcount() % 3) - 1

    if ui.get(menu.miscTab.jitterFix) == "By One Side" then
        yaws = delta * yaw1 * animstate.m_flPlaybackRate
    elseif ui.get(menu.miscTab.jitterFix) == "Recommended" then
        yaws = side * math.abs(delta * yaw1 * animstate.m_flPlaybackRate)
    elseif ui.get(menu.miscTab.jitterFix) == "By Two Side" then
        yaws = side2 * math.abs(delta * yaw1 * animstate.m_flPlaybackRate)
    else
        yaws = (delta * yaw1 * animstate.m_flPlaybackRate)/ui.get(menu.miscTab.jitterFixOffset)
    end

    yaws = NormalizeAngle(yaws)

    plist.set(player, "Force body yaw", true)
    plist.set(player, "Force body yaw value", yaws) 
end

local function Resolver(player)
    if ui.get(menu.miscTab.jitterFixEnabled) then 
        if entity.is_dormant(player) or entity.get_prop(player, "m_bDormant") then
            return
        end
        ResolveJitter(player)
    else
        plist.set(player, "Force body yaw", false)
    end
end

local function RefreshingResolver()
    if not ui.get(menu.miscTab.jitterFixEnabled) then return end
    local enemies = entity.get_players(true)
    for i, enemy_ent in ipairs(enemies) do
        if enemy_ent and entity.is_alive(enemy_ent) then
            Resolver(enemy_ent)
        end
    end
end


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

                local data = {rounding = 6, size = 5.5, glow = 10, time = 2.5}

                if notif.time + data.time - globals.curtime() > 0 then
                    notif.fraction = func.clamp(notif.fraction + globals.frametime() / anim_time, 0.01, 1)
                else
                    notif.fraction = func.clamp(notif.fraction - globals.frametime() / anim_time, 0.01, 1)
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

                Offset = Offset + (strh + paddingy*2 + 	math.sqrt(data.glow/60)*10 + 5) * fraction
                glow_module(x/2 - (strw + strw2)/2 - paddingx, y - offsetY - strh/2 - paddingy - Offset, strw + strw2 + paddingx*2, strh + paddingy*2, data.glow, data.rounding, {r, g, b, 45 * fraction}, {25,25,25,255 * fraction})
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
        if entity.get_prop(e.target, 'm_iHealth') == 0 then
            notifications.new(string.format(" Killed $%s$ in $%s$ for $%d$" .. '! ', entity.get_player_name(e.target), group:lower(), e.damage), r, g, b) 
        else
            notifications.new(string.format(" Hit $%s$ in $%s$ for $%d$" .. '! ', entity.get_player_name(e.target), group:lower(), e.damage), r, g, b) 
        end
    --    client.color_log(lua_color.r, lua_color.g, lua_color.b, "> Registered Fired at " .. entity.get_player_name(e.target))
end

local function onMiss(e)
    local group = vars.hitgroup_names[e.hitgroup + 1] or '?'
    local r, g, b, a = ui.get(menu.visualsTab.logsClr)
    e.reason = e.reason == "?" and "resolver" or e.reason
    notifications.new(string.format(" Missed $%s's$ $%s$ due to $%s$" .. '', entity.get_player_name(e.target), group:lower(), e.reason), r, g, b)
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

notifications.new(string.format(" Welcome, $%s$" .. '! ',login.username:lower()), lua_color.r, lua_color.g, lua_color.b) 

local animate_text = function(time, string, r, g, b, a)
    local t_out, t_out_iter = { }, 1

    local l = string:len( ) - 1
    local mainClr = {}
    mainClr.r, mainClr.g, mainClr.b, mainClr.a = ui.get(menu.visualsTab.BackgroundColor)

    local r_add = (mainClr.r - r)
    local g_add = (mainClr.g - g)
    local b_add = (mainClr.b - b)
    local a_add = (mainClr.a - a)

    for i = 1, #string do
        local iter = (i - 1)/(#string - 1) + time
        t_out[t_out_iter] = "\a" .. func.RGBAtoHEX( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )

        t_out[t_out_iter + 1] = string:sub( i, i )

        t_out_iter = t_out_iter + 2
    end

    return t_out
end

local animate_text2 = function(time, string, r, g, b, a)
    local t_out, t_out_iter = { }, 1

    local l = string:len( ) - 1
    --159, 202, 43
    local r_add = (159 - r)
    local g_add = (202 - g)
    local b_add = (43 - b)
    local a_add = (255 - a)

    for i = 1, #string do
        local iter = (i - 1)/(#string - 1) + time
        t_out[t_out_iter] = "\a" .. func.RGBAtoHEX( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )

        t_out[t_out_iter + 1] = string:sub( i, i )

        t_out_iter = t_out_iter + 2
    end

    return t_out
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
    local safeKnife = entity.get_classname(weapon) == "CKnife"

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

    if globals.tickcount() % 2 == 1 then
        vars.switch2 = not vars.switch2
    end

    local randomticks = client.random_int(2, 8)

    if globals.tickcount() % randomticks == 1 then
        vars.switch3 = not vars.switch3
    end
    if globals.tickcount() % 2 then
        client.delay_call(1, function() 
            vars.switch4 = not vars.switch4
        end)
    end

    local tickcount = globals.tickcount()

    local side = bodyYaw > 0 and 1 or -1

        -- manual aa
        local isStatic = func.includes(ui.get(menu.aaTab.aamenushka), "Static on manuals")

        ui.set(menu.aaTab.manualTab.manualLeft, "On hotkey")
        ui.set(menu.aaTab.manualTab.manualRight, "On hotkey")
        ui.set(menu.aaTab.manualTab.manualReset, "On hotkey")
        ui.set(menu.aaTab.manualTab.manualForward, "On hotkey")

        if aa.input + 0.182 < globals.curtime() then
            if aa.manualAA == 0 then
                if ui.get(menu.aaTab.manualTab.manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                elseif ui.get(menu.aaTab.manualTab.manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                elseif ui.get(menu.aaTab.manualTab.manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                elseif ui.get(menu.aaTab.manualTab.manualReset) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                end
            elseif aa.manualAA == 1 then
                if ui.get(menu.aaTab.manualTab.manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                elseif ui.get(menu.aaTab.manualTab.manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                elseif ui.get(menu.aaTab.manualTab.manualLeft) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                elseif ui.get(menu.aaTab.manualTab.manualReset) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()    
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                end
            elseif aa.manualAA == 2 then
                if ui.get(menu.aaTab.manualTab.manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                elseif ui.get(menu.aaTab.manualTab.manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                elseif ui.get(menu.aaTab.manualTab.manualRight) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                elseif ui.get(menu.aaTab.manualTab.manualReset) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()    
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                end
            elseif aa.manualAA == 3 then
                if ui.get(menu.aaTab.manualTab.manualForward) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                elseif ui.get(menu.aaTab.manualTab.manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                elseif ui.get(menu.aaTab.manualTab.manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
                elseif ui.get(menu.aaTab.manualTab.manualReset) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()    
                    if not client.key_state(0x45) then 
                        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider)) 
                    end
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
        local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])

        if ui.get(aaBuilder[vars.pState].defensiveOpt) == "Always on" and isDt then
            cmd.force_defensive = true
        end

        if cmd.chokedcommands > 1 then
            cmd.allow_send_packet = false
        else
            cmd.allow_send_packet = true
        end

        if ui.get(aaBuilder[vars.pState].defensiveOpt) == "Elusive mode" and isDt then
            ui.set(refs.dt[3], "Defensive")

            if tickcount % 3 == 1 then
                ui.set(refs.dt[3], "Offensive")
            end
            cmd.force_defensive = tickcount % 3 ~= 1
        end

        
        
        if ui.get(aaBuilder[vars.pState].defensiveOpt) == "Always on Tick" and isDt then
            if tickcount % ui.get(aaBuilder[vars.pState].defensiveOptSlider) == 1 then
                cmd.force_defensive = true
            end
        end
        

        if aa.ignore then return end

        local manul = func.includes(ui.get(menu.aaTab.freestandDisablers), "Manual") and (aa.manualAA == 2 or aa.manualAA == 1)         

        if ui.get(aaBuilder[vars.pState].defensivePitch) == "Custom" and isDefensive and isDt and not manul then
            ui.set(refs.pitch[1], "Custom")
            ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].defensivePitchSlider))
        elseif ui.get(aaBuilder[vars.pState].defensivePitch) == "Random" and isDefensive and isDt and not manul then
            ui.set(refs.pitch[1], "Custom")
            ui.set(refs.pitch[2], math.random(-89, 89))
        elseif ui.get(aaBuilder[vars.pState].defensivePitch) == "Jitter" and isDefensive and isDt and not manul then
            local wtf = math.random(1, 2)
            ui.set(refs.pitch[1], "Custom") 
            if vars.switch3 then
                ui.set(refs.pitch[2], vars.switch2 and 69 or -69)
            else 
                ui.set(refs.pitch[2], vars.switch2 and -69 or 69)
            end
        else
            ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
            ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
        end

    
        ui.set(refs.yawBase, ui.get(aaBuilder[vars.pState].yawBase))

        ui.set(refs.yaw[1], ui.get(aaBuilder[vars.pState].yaw))
        if ui.get(aaBuilder[vars.pState].defensiveYaw) == "Random" and isDefensive and isDt then
            local randomyaw = client.random_int(-180, 180)
            ui.set(refs.yaw[2], randomyaw)
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
            --ui.set(refs.bodyYaw[1], "Off")
        elseif ui.get(aaBuilder[vars.pState].defensiveYaw) == "Jitter" and isDefensive and isDt then
            ui.set(refs.yaw[2], vars.switch2 and -100 or 100)
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
            --ui.set(refs.bodyYaw[1], "Off") 
        elseif ui.get(aaBuilder[vars.pState].defensiveYaw) == "Spin" and isDefensive and isDt then
            ui.set(refs.yaw[1], "Spin")
            ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].defensiveYawSlider2))
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
        elseif ui.get(aaBuilder[vars.pState].defensiveYaw) == "Backward Jitter" and isDefensive and isDt and not manul then
            ui.set(refs.yaw[2], vars.switch2 and -150 or 150)
            ui.set(refs.yawJitter[1], "Off")
            ui.set(refs.yawJitter[2], 0)
            --ui.set(refs.bodyYaw[1], "Off")
        elseif ui.get(aaBuilder[vars.pState].defensiveYaw) == "Custom" and isDefensive and isDt then
--            ui.set(refs.yaw[2], "Custom")
            ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].defensiveYawSlider))
        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "L & R" then

            ui.set(refs.yaw[2],(side == 1 and ui.get(aaBuilder[vars.pState].yawLeft) or ui.get(aaBuilder[vars.pState].yawRight)))

        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "Slow Jitter" then
            ui.set(refs.yaw[1], "180")
            ui.set(refs.yaw[2],(side == 1 and ui.get(aaBuilder[vars.pState].yawLeft) or ui.get(aaBuilder[vars.pState].yawRight)))
            ui.set(refs.bodyYaw[2], vars.switch and -60 or 60)
        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "Static" then
            ui.set(refs.yaw[2], ui.get(aaBuilder[vars.pState].yawStatic))
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
        local plocal = entity.get_local_player()
        local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")
        local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 5
        local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
        local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
        local isFd = ui.get(refs.fakeDuck)
        if ui.get(aaBuilder[vars.pState].yawCondition) == "Slow Jitter" then
            if not isFd then
                if isDt or isOs then
                    ui.set(refs.bodyYaw[1], "Static")
                else
                    ui.set(refs.bodyYaw[1], "Jitter")
                    ui.set(refs.bodyYaw[2], -1)                
                end
            else
                ui.set(refs.bodyYaw[1], "Jitter")
                ui.set(refs.bodyYaw[2], -1)  
            end
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
    if func.includes(ui.get(menu.aaTab.aamenushka), "Safe Knife") then
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
	if func.includes(ui.get(menu.aaTab.aamenushka), "Adjust fakelag limit") then
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
    if func.includes(ui.get(menu.aaTab.aamenushka), "Avoid~Backstab") then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        if players == nil then return end
        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = distance_knife.anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= 200 then
                ui.set(refs.yaw[2], 180)
                ui.set(refs.yawBase, "At targets")
            end
        end
    end
    
    -- fast ladder
    if ui.get(menu.miscTab.fastLadderEnabled) then
        local pitch, yaw = client.camera_angles()
        if entity.get_prop(vars.localPlayer, "m_MoveType") == 9 then
            cmd.yaw = math.floor(cmd.yaw+0.5)
            cmd.roll = 0
    
            if func.includes(ui.get(menu.miscTab.fastLadder), "Up") then
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
            if func.includes(ui.get(menu.miscTab.fastLadder), "Down") then
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
    if func.includes(ui.get(menu.aaTab.aamenushka), "Edge Yaw") then
        ui.set(refs.edgeYaw, ui.get(menu.aaTab.edgeYawHotkey))
    else
        ui.set(refs.edgeYaw, false)
    end
end)
client.set_event_callback("setup_command", function (cmd)
    local lp = ent.get_local_player()
    local m_fFlags = lp:get_prop("m_fFlags")
    local is_onground = bit.band(m_fFlags, 1) ~= 0 

    if func.includes(ui.get(menu.aaTab.aamenushka), "Discharge Exploit") and not is_onground then
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
    
end)

client.set_event_callback("setup_command", function(e)
	local flags = entity.get_prop(vars.localPlayer, "m_fFlags")
    local onground = bit.band(flags, 1) ~= 0 and e.in_jump == 0
    local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])

    local air = func.includes(ui.get(menu.aaTab.freestandDisablers), "Air") and not onground
    local duck = func.includes(ui.get(menu.aaTab.freestandDisablers), "Duck") and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1
    local slow = func.includes(ui.get(menu.aaTab.freestandDisablers), "Slowmo") and isSlow
    local manul = func.includes(ui.get(menu.aaTab.freestandDisablers), "Manual") and (aa.manualAA == 2 or aa.manualAA == 1) and aa.ignore
    local fs_disabler = air or duck or slow or manul

    if ui.get(menu.aaTab.freestandHotkey) and not fs_disabler and func.includes(ui.get(menu.aaTab.aamenushka), "Freestand") then
        vars.fs = true
        ui.set(refs.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
        ui.set(refs.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
        ui.set(refs.freeStand[2], "Always on")
        ui.set(refs.freeStand[1], true)
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

    if not vars.should_disable and client.key_state(0x45) and not using and not defusing and ui.get(aaBuilder[8].enableState) then
        cmd.in_use = 0
        if ui.get(menu.aaTab.freestandHotkey)  then
            vars.fs = false
            ui.set(refs.freeStand[1], false)
            ui.set(refs.freeStand[2], "On hotkey")
        end

        
    end
end)
local function clantag_set()
    if func.includes(ui.get(menu.miscTab.miscmenushka), "Clantag") then
        if ui.get(ui.reference("Misc", "Miscellaneous", "Clan tag spammer")) then return end

		local clan_tag = clantag_anim('winter.gs ', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24})

        if entity.get_prop(entity.get_game_rules(), "m_gamePhase") == 5 then
            clan_tag = clantag_anim('winter.gs ', {6})
            client.set_clan_tag(clan_tag)
        elseif entity.get_prop(entity.get_game_rules(), "m_timeUntilNextPhaseStarts") ~= 0 then
            clan_tag = clantag_anim('winter.gs ', {11})
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

ui.set_callback(menu.miscTab.trashTalk, function() 
    local callback = menushka and client.set_event_callback or client.unset_event_callback
    callback('player_death', trashtalk)
end)

client.set_event_callback("aim_miss", onMiss)
client.set_event_callback("aim_hit", onHit)



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
    local lp = entity.get_local_player()
    if not lp then return end
    local is_on_ground = e.in_jump == 0
    if func.includes(ui.get(menu.miscTab.animations), "Leg fucker") then
        if func.includes(ui.get(menu.miscTab.animations), "Leg fucker") then
            ui.set(refs.legMovement, e.command_number % 3 == 0 and "Off" or "Always slide")
        end
    end
end)

client.set_event_callback("pre_render", function()
    local lp = entity.get_local_player()
    if not lp then return end
    if ui.get(menu.miscTab.animationsEnabled) == false then return end
    local flags = entity.get_prop(lp, "m_fFlags")
    ground_ticks = bit.band(flags, 1) == 0 and 0 or (ground_ticks < 5 and ground_ticks + 1 or ground_ticks)

    if func.includes(ui.get(menu.miscTab.animations), "Backward Legs") then
        entity.set_prop(lp, "m_flPoseParameter", 1, 0) 
    end

    if func.includes(ui.get(menu.miscTab.animations), "In air") and bit.band(flags, 1) == 0 then
        entity.set_prop(lp, "m_flPoseParameter", 1, 6) 
    end

    if func.includes(ui.get(menu.miscTab.animations), "Leg fucker") then
        entity.set_prop(lp, "m_flPoseParameter", 1, globals.tickcount() % 4 > 1 and 5 / 10 or 1)
    end

    if func.includes(ui.get(menu.miscTab.animations), "0 Pitch on land") then
        ground_ticks = bit.band(flags, 1) == 1 and ground_ticks + 1 or 0

        if ground_ticks > 20 and ground_ticks < 150 then
            entity.set_prop(lp, "m_flPoseParameter", 0.5, 12)
        end
    end

    if func.includes(ui.get(menu.miscTab.animations), "Moonwalking") then
        entity.set_prop(lp, "m_flPoseParameter", 1, 7)
        ui.set(refs.legMovement, "Never slide")
    end

    if func.includes(ui.get(menu.miscTab.animations), "Earthquake") then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 5)/2, 2)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 5)/2, 4)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 5)/2, 6)
    end

    if func.includes(ui.get(menu.miscTab.animations), "Walking in Air") then
        if entity.get_prop(vars.localPlayer, "m_MoveType") ~= 9 then
            local lp = ent.get_local_player()
            local m_fFlags = lp:get_prop("m_fFlags")
            local is_onground = bit.band(m_fFlags, 1) ~= 0 
            
            if not is_onground then 
                local my_animlayer = lp:get_anim_overlay(6)
                my_animlayer.weight = 1 
                entity.set_prop(lp, "m_flPoseParameter", 1, 6) 
            end
        end
    end

    if func.includes(ui.get(menu.miscTab.animations), "Freezed legs") then
        entity.set_prop(lp, "m_flPoseParameter", 0, 8)
        entity.set_prop(lp, "m_flPoseParameter", 0, 9)
        entity.set_prop(lp, "m_flPoseParameter", 0, 10)
    end
end)
-- @region AA_CALLBACKS end

-- @region INDICATORS start
local alpha = 0
local scopedFraction = 0
local acatelScoped = 1
local dtModifier = 0
local barMoveY = 0

local activeFraction = 0
local inactiveFraction = 0
local defensiveFraction = 0
local hideFraction = 0
local hideInactiveFraction = 0
local alpha = 0
local scopedFraction = 0
local dtPos = {y = 0}
local osPos = {y = 0}

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

    local indicators = 0


    if ui.get(menu.visualsTab.watermarkMenu) == "winter" then
        indicators = indicators + 1
        wAlpha = func.lerp(wAlpha, 255, globals.frametime() * 3)
    else
        wAlpha = func.lerp(wAlpha, 0, globals.frametime() * 11)
    end

    local watermarkClr = {}
    watermarkClr.r, watermarkClr.g, watermarkClr.b = ui.get(menu.visualsTab.watermarkClr2)

        local mainY = 4
        local marginX, marginY = renderer.measure_text("-d", lua_name:upper())
        renderer.text(0, sizeY/2 + 6, 255, 255, 255, wAlpha, "-d", nil, lua_name:upper() .. "\a" .. func.RGBAtoHEX(watermarkClr.r, watermarkClr.g, watermarkClr.b, wAlpha) .. ".DEV")
        renderer.text(0, sizeY/2 + 14, 255, 255, 255, wAlpha, "-d", nil, "USER - " .. login.username:upper() .. "\a" .. func.RGBAtoHEX(watermarkClr.r, watermarkClr.g, watermarkClr.b, wAlpha) .. " [" .. login.build:upper() .. "]")

    if ui.get(menu.visualsTab.watermarkMenu) == "winter #2" then
        indicators = indicators + 1
        local flagimg = renderer.load_png(download, 25, 25)
        if flagimg ~= nil and download ~= nil then
            local mainY = 35
            local marginX, marginY = renderer.measure_text("-d", lua_name:upper())
            renderer.gradient(1, sizeY/2 + mainY - 2, marginX*2, marginY*2 - 1, watermarkClr.r, watermarkClr.g, watermarkClr.b, 125, watermarkClr.r, watermarkClr.g, watermarkClr.b, 0, true)
            renderer.texture(flagimg, 2, sizeY/2.012 + mainY, 28, marginY*2.45, 255, 255, 255, 255, "f")
            renderer.text(30, sizeY/2 - 2 + mainY, 255, 255, 255, 255, "-d", nil, "WINTER" .. func.hex({watermarkClr.r, watermarkClr.g, watermarkClr.b}) .. ".DEV")
            renderer.text(30, sizeY/2 - 4 + marginY + mainY, 255, 255, 255, 255, "-d", nil, 'USER: ' .. login.username:upper() .. func.hex({watermarkClr.r, watermarkClr.g, watermarkClr.b}) .. " [alpha]")
        else
            downloadFile()
        end
    end


    -- draw arrows
    if ui.get(menu.visualsTab.arrows) then
        if ui.get(menu.visualsTab.arrows) == "Default" then
            alpha = (aa.manualAA == 2 or aa.manualAA == 1) and func.lerp(alpha, 255, globals.frametime() * 20) or func.lerp(alpha, 0, globals.frametime() * 20)
            renderer.text(sizeX / 2 + 45, sizeY / 2 - 2.5, aa.manualAA == 2 and arrowClr.r or 200, aa.manualAA == 2 and arrowClr.g or 200, aa.manualAA == 2 and arrowClr.b or 200, alpha, "c+", 0, '>')
            renderer.text(sizeX / 2 - 45, sizeY / 2 - 2.5, aa.manualAA == 1 and arrowClr.r or 200, aa.manualAA == 1 and arrowClr.g or 200, aa.manualAA == 1 and arrowClr.b or 200, alpha, "c+", 0, '<')
        end
    
        if ui.get(menu.visualsTab.arrows) == "TS" then
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
    if ui.get(menu.visualsTab.indicators) == "Soft" then
        local dpi = ui.get(ui.reference("MISC", "Settings", "DPI scale")):gsub('%%', '') - 100
        local globalFlag = "cd"
        local globalMoveY = globalFlag == "cd-" and 5 + dpi/10 or 9 + dpi/10
        local indX, indY = renderer.measure_text(globalFlag, "DT")
        local yDefault = func.includes(ui.get(menu.visualsTab.indicatorsStyle), "State") and 18 or 9
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
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "Name") then
            indicators = indicators + 1
            local lua_name1 = 'winter.tech'
            local namex, namey = renderer.measure_text(globalFlag, globalFlag == "cd-" and lua_name1:lower() or lua_name1:lower())
            local logo = animate_text(globals.curtime(), globalFlag == "cd" and lua_name1:lower() or lua_name1:lower(), mainClr.r, mainClr.g, mainClr.b, 255)
    
            renderer.text(sizeX/2 + ((namex + 2)/2) * scopedFraction * 1.150, sizeY/2 + 20 - dpi/10, 255, 255, 255, 255, globalFlag, nil, unpack(logo))
            renderer.text(sizeX/2 + ((namex + 2)/2) * scopedFraction * 1.150, sizeY/2 + 20 - dpi/10, 255, 255, 255, 255, globalFlag, nil, unpack(logo))
            
        end 
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "State") then
            indicators = indicators + 1
            local namex, namey = renderer.measure_text(globalFlag, globalFlag == "cd-" and lua_name:lower() or lua_name:lower())
            local stateX, stateY = renderer.measure_text(globalFlag, state:lower())
            local string = state:lower()
            if string == "moving" then
                renderer.text(sizeX/2 + (stateX + 2)/2 * scopedFraction * 1.2, sizeY/2 + 20 + namey/1.2, 255, 255, 255, 255, globalFlag, 0, string)
            else
                renderer.text(sizeX/2 + (stateX + 2)/2 * scopedFraction * 1.2, sizeY/2 + 20 + namey/1.2, 255, 255, 255, 255, globalFlag, 0, string)
            end
        end
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "Doubletap") then
            indicators = indicators + 1
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
    
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "dt" or "dt") + 2)/2) * scopedFraction * 1.65  , sizeY / 2 + dtInd.y + 13 + globalMoveY, dtClr.r, dtClr.g, dtClr.b, dtClr.a, globalFlag, dtInd.w, globalFlag == "cd-" and "dt" or "dt")
        end
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "Hideshots") then
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
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "HS" or "hs") + 2)/2) * scopedFraction * 1.53, sizeY / 2 + osInd.y + 13 + globalMoveY, 255, 255, 255, osInd.a, globalFlag, osInd.w, globalFlag == "cd-" and "HS" or "hs")
        end
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "Freestand") then
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
            local fs_col = vars.fs and {255,255,255} or {222,55,55}
            renderer.text(sizeX / 2 + fsInd.x + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "FS" or "fs") + 2)/2) * scopedFraction * 1.75, sizeY / 2 + fsInd.y + 13 + globalMoveY, fs_col[1], fs_col[2], fs_col[3], fsInd.a, globalFlag, fsInd.w, globalFlag == "cd-" and "FS" or "fs")
        end
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "Safepoint") then
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
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "SP" or "sp") + 2)/2) * scopedFraction * 1.8, sizeY / 2 + spInd.y + 13 + globalMoveY, 255, 255, 255, spInd.a, globalFlag, 0, globalFlag == "cd-" and "SP" or "sp")
        end
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "Body aim") then
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
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "BA" or "ba") + 2)/2) * scopedFraction * 1.5, sizeY / 2 + baInd.y + 13 + globalMoveY, 255, 255, 255, baInd.a, globalFlag, 0, globalFlag == "cd-" and "BA" or "ba")
        end
    
        if func.includes(ui.get(menu.visualsTab.indicatorsStyle), "Fakeduck") then
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
            renderer.text(sizeX / 2 + ((renderer.measure_text(globalFlag, globalFlag == "cd-" and "FD" or "fd") + 2)/2) * scopedFraction * 1.8, sizeY / 2 + fdInd.y + 13 + globalMoveY, 255, 255, 255, fdInd.a, globalFlag, 0, globalFlag == "cd-" and "FD" or "fd")
        end
    end

    -- draw dmg indicator
    if ui.get(menu.visualsTab.minDmgIndicator2) ~= "Disabled" and entity.get_classname(weapon) ~= "CKnife"  then
        if ui.get(menu.visualsTab.minDmgIndicator2) == "Always on" then
            if ( ui.get(refs.dmgOverride[1]) and ui.get(refs.dmgOverride[2]) ) == false then
                renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, ui.get(refs.minDmg))
            else
                renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, ui.get(refs.dmgOverride[3]))
            end
        elseif ui.get(refs.dmgOverride[1]) and ui.get(refs.dmgOverride[2]) and ui.get(menu.visualsTab.minDmgIndicator2) == "Bind" then
            dmg = ui.get(refs.dmgOverride[3])
            renderer.text(sizeX / 2 + 3, sizeY / 2 - 15, 255, 255, 255, 255, "", 0, dmg)
        end
    end
    -- draw watermark
    if ui.get(menu.visualsTab.watermarkMenu) == "LS" then
        local watermarkX, watermarkY = renderer.measure_text("cd", "W I N T E R")
        local lua_watermarkname = 'W I N T E R'
        local logo = animate_text(globals.curtime(), globalFlag == "cd" and lua_watermarkname:upper() or lua_watermarkname:upper(), 255,255,255,255)

        renderer.text(sizeX/15-watermarkX/1, sizeY/2.11, 255, 255, 255, 255, "c", 0, unpack(logo))
        renderer.text(sizeX/15-watermarkX/1, sizeY/2.11, 255, 255, 255, 255, "c", 0, unpack(logo))
        renderer.text(sizeX/15-watermarkX/1, sizeY/2.11, 255, 255, 255, 255, "c", 0, unpack(logo))
    end

    -- draw logs
    local call_back = ui.get(menu.visualsTab.logs) and client.set_event_callback or client.unset_event_callback

    if call_back then
        notifications.render()
    end

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
        notifications.new(string.format(' Successfully loaded "$%s$" ', name), r, g, b)
    else
        notifications.new(string.format(' Failed to load "$%s$" ', name), 255, 120, 120)
    end
end)

ui.set_callback(menu.configTab.save, function()
    local r, g, b = ui.get(menu.visualsTab.logsClr)

    local name = ui.get(menu.configTab.name)
    if name == "" then return end

    for i, v in pairs(presets) do
        if v.name == name:gsub('*Default', '') then
            notifications.new(string.format(' You can`t save built-in preset "$%s$" ', name:gsub('*', '')), 255, 120, 120)
            return
        end
    end


    if name:match("[^%w]") ~= nil then
        notifications.new(string.format(' Failed to save "$%s$" due to invalid characters ', name), 255, 120, 120)
        return
    end

    local protected = function()
        saveConfig(name)
        ui.update(menu.configTab.list, getConfigList())
    end
    if pcall(protected) then
        notifications.new(string.format(' Successfully saved "$%s$" ', name), r, g, b)
    else
        notifications.new(string.format(' Failed to save "$%s$" ', name), 255, 120, 120)
    end
end)

ui.set_callback(menu.configTab.delete, function()
    local name = ui.get(menu.configTab.name)
    if name == "" then return end
    local r, g, b = ui.get(menu.visualsTab.logsClr)
    if deleteConfig(name) == false then
        notifications.new(string.format(' Failed to delete "$%s$" ', name), 255, 120, 120)
        ui.update(menu.configTab.list, getConfigList())
        return
    end

    for i, v in pairs(presets) do
        if v.name == name:gsub('*', '') then
            notifications.new(string.format(' You can`t delete built-in preset "$%s$" ', name:gsub('*', '')), 255, 120, 120)
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
        notifications.new(string.format(' Successfully deleted "$%s$" ', name), r, g, b)
    end
end)

ui.set_callback(menu.configTab.import, function()
    local r, g, b = ui.get(menu.visualsTab.logsClr)

    local protected = function()
        importSettings()
    end

    if pcall(protected) then
        notifications.new(string.format(' Successfully imported settings! ', name), r, g, b)
    else
        notifications.new(string.format(' Failed to import settings! ', name), 255, 120, 120)
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
        notifications.new(string.format(' Successfully exported settings! ', name), r, g, b)
    else
        notifications.new(string.format(' Failed to export settings! ', name), 255, 120, 120)
    end
end)
-- @region UI_CALLBACKS end

-- @region UI_RENDER start
client.set_event_callback("paint_ui", function()
    vars.activeState = vars.sToInt[ui.get(menu.builderTab.state)]
    local isEnabled = ui.get(masterSwitch)
    ui.set_visible(tabPicker, isEnabled)
    local isAATab = ui.get(tabPicker) == "Anti-aim" 
    local isBuilderTab = ui.get(tabPicker) == "Builder" 
    local isVisualsTab = ui.get(tabPicker) == "Visuals" 
    local isMiscTab = ui.get(tabPicker) == "Misc" 
    local isCFGTab = ui.get(tabPicker) == "Config"

    ui.set(aaBuilder[1].enableState, true)
    for i = 1, #vars.aaStates do
        local stateEnabled = ui.get(aaBuilder[i].enableState)
        ui.set_visible(aaBuilder[i].enableState, vars.activeState == i and isBuilderTab and isEnabled)
        ui.set_visible(aaBuilder[i].pitch, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].pitchSlider , vars.activeState == i and isBuilderTab and stateEnabled and ui.get(aaBuilder[i].pitch) == "Custom" and isEnabled)
        ui.set_visible(aaBuilder[i].yawBase, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawCondition, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawStatic, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "Static" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawLeft, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) ~= "Static" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawRight, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) ~= "Static" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawSpeed, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "Slow Jitter" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitter, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterCondition, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterStatic, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "Static" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterLeft, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "L & R" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterRight, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "L & R" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].yawJitterDisablers, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].bodyYawSlider, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off" and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].defensiveOpt, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].defensiveOptSlider, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ui.get(aaBuilder[i].defensiveOpt) == "Always on Tick")
        ui.set_visible(aaBuilder[i].defensiveYaw, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].defensiveYawSlider, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ui.get(aaBuilder[i].defensiveYaw) == "Custom")
        ui.set_visible(aaBuilder[i].defensiveYawSlider2, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ui.get(aaBuilder[i].defensiveYaw) == "Spin")
        ui.set_visible(aaBuilder[i].defensivePitch, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled)
        ui.set_visible(aaBuilder[i].defensivePitchSlider, vars.activeState == i and isBuilderTab and stateEnabled and isEnabled and ui.get(aaBuilder[i].defensivePitch) == "Custom")
    end

    for i, feature in pairs(menu.aaTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isAATab and isEnabled)
        end
	end 

    for i, feature in pairs(menu.aaTab.manualTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isAATab and isEnabled)
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
    ui.set_visible(menu.aaTab.freestandHotkey, func.includes(ui.get(menu.aaTab.aamenushka), "Freestand") and isAATab and isEnabled)
    ui.set_visible(menu.aaTab.freestandDisablers, func.includes(ui.get(menu.aaTab.aamenushka), "Freestand") and isAATab and isEnabled)
    ui.set_visible(menu.aaTab.edgeYawHotkey, func.includes(ui.get(menu.aaTab.aamenushka), "Edge Yaw" ) and isAATab and isEnabled)
    ui.set_visible(menu.aaTab.manualTab.manualLeft, func.includes(ui.get(menu.aaTab.aamenushka), "Manuals") and isAATab and isEnabled)
    ui.set_visible(menu.aaTab.manualTab.manualRight, func.includes(ui.get(menu.aaTab.aamenushka), "Manuals") and isAATab and isEnabled)
    ui.set_visible(menu.aaTab.manualTab.manualReset, func.includes(ui.get(menu.aaTab.aamenushka), "Manuals") and isAATab and isEnabled)
    ui.set_visible(menu.aaTab.manualTab.manualForward, func.includes(ui.get(menu.aaTab.aamenushka), "Manuals") and isAATab and isEnabled)



    ui.set_visible(menu.visualsTab.space3, ui.get(menu.visualsTab.space3) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.BackgroundColorLabel, ui.get(menu.visualsTab.BackgroundColorLabel) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.logsClr, func.includes(ui.get(menu.visualsTab.logs), "On screen" ) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.logOffset, func.includes(ui.get(menu.visualsTab.logs), "On screen" ) and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.indicatorsStyle, ui.get(menu.visualsTab.indicators) == "Soft" and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.indicatorsClr, ui.get(menu.visualsTab.indicators) == "Soft" and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.arrowClr, ui.get(menu.visualsTab.arrows) ~= "Disabled" and isVisualsTab and isEnabled)
    ui.set_visible(menu.visualsTab.watermarkClr2, ui.get(menu.visualsTab.watermarkMenu) ~= "Disabled" and ui.get(menu.visualsTab.watermarkMenu) ~= "LS" and isVisualsTab and isEnabled)
    
    for i, feature in pairs(menu.miscTab) do
        if type(feature) ~= "table" then
            ui.set_visible(feature, isMiscTab and isEnabled)
        end
	end
    ui.set_visible(menu.miscTab.trashTalk, func.includes(ui.get(menu.miscTab.miscmenushka), "Trashtalk" ) and isMiscTab and isEnabled)
    ui.set_visible(menu.miscTab.fastLadderEnabled, func.includes(ui.get(menu.miscTab.miscmenushka), "Fast Ladder" ) and isMiscTab and isEnabled)
    ui.set_visible(menu.miscTab.animationsEnabled, func.includes(ui.get(menu.miscTab.miscmenushka), "Animation Breaker" ) and isMiscTab and isEnabled)
    ui.set_visible(menu.miscTab.fastLadder, ui.get(menu.miscTab.fastLadderEnabled) and func.includes(ui.get(menu.miscTab.miscmenushka), "Fast Ladder" ) and isMiscTab and isEnabled)
    ui.set_visible(menu.miscTab.animations, ui.get(menu.miscTab.animationsEnabled) and func.includes(ui.get(menu.miscTab.miscmenushka), "Animation Breaker" ) and isMiscTab and isEnabled)
    ui.set_visible(menu.miscTab.jitterFixEnabled, func.includes(ui.get(menu.miscTab.miscmenushka), func.hex({170,170,96}) .. "Jitter Fix *WIP*") and ui.get(menu.miscTab.jitterFix) and isMiscTab and isEnabled)
    ui.set_visible(menu.miscTab.jitterFix, func.includes(ui.get(menu.miscTab.miscmenushka), func.hex({170,170,96}) .. "Jitter Fix *WIP*") and ui.get(menu.miscTab.jitterFixEnabled) and isMiscTab and isEnabled)
    ui.set_visible(menu.miscTab.jitterFixOffset, ui.get(menu.miscTab.jitterFix) == "By Delta" and ui.get(menu.miscTab.jitterFix) and isMiscTab and isEnabled)
    --ui.get(menu.visualsTab.logOffset) func.includes(ui.get(menu.miscTab.jitterFix), "› Offset")

    ui.set_visible(menu.miscTab.animations, ui.get(menu.miscTab.animationsEnabled) and func.includes(ui.get(menu.miscTab.miscmenushka), "Animation Breaker" ) and isMiscTab and isEnabled)
    ui.set_visible(menu.miscTab.jitterwarning, ui.get(menu.miscTab.jitterFixEnabled) and isMiscTab and isEnabled)
    ui.set_visible(menu.miscTab.jitterwarning2, ui.get(menu.miscTab.jitterFixEnabled) and isMiscTab and isEnabled)
    ui.set_visible(menu.miscTab.jitterwarning3, ui.get(menu.miscTab.jitterFixEnabled) and isMiscTab and isEnabled)
    ui.set_visible(menu.miscTab.jitterwarning4, ui.get(menu.miscTab.jitterFixEnabled) and isMiscTab and isEnabled)


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

        
    if func.includes(ui.get(menu.miscTab.miscmenushka), func.hex({170,170,96}) .. "Jitter Fix *WIP*") then
        if ui.get(menu.miscTab.jitterFixEnabled) then 
            ui.set(refs.ForceBodyYaw, true)
            ui.set_visible(refs.AntiAimCorrect, false)
            ui.set_visible(refs.CorrectEnable, false)
            ui.set_visible(refs.ForceBodyYaw, false)
            ui.set_visible(refs.ForceBodyYawValue[1], false)
        else
            ui.set_visible(refs.AntiAimCorrect, true)
            ui.set_visible(refs.CorrectEnable, true)
            ui.set_visible(refs.ForceBodyYaw, true)
            ui.set_visible(refs.ForceBodyYawValue[1], true)  
            ui.set(refs.ForceBodyYaw, false)
        end
    end

end)

client.set_event_callback('run_command', function()
    if func.includes(ui.get(menu.miscTab.miscmenushka), func.hex({170,170,96}) .. "Network Fix *WIP*") then
        local netchaninfo = ffi.cast('void***', get_net_channel_info(ivengineclient)) or error('netchaninfo is nil')
        local data = ffi.cast('get_avg_loss_t', netchaninfo[0][11])(netchaninfo, 1)

        gram_update(loss_data, data, timers:update('loss', 4))

        local average = get_average(loss_data)

        if ffi_loss.maximum < data then
            ffi_loss.maximum = data
        end

        if average >= 0.005 and ffi_loss.tr == 0 then 
            ffi_loss.tr = 1
            notifications.new(string.format(' Currently experiencing an elevated level of connectivity errors ', data*100), 255,165,0)
        end

        if average > 0.08 and ffi_loss.tr_ex == 0 then
            ffi_loss.tr_ex = 1
            notifications.new(string.format(' A stable high connectivity failure may decrease cheat performance ', data*100), 255, 120, 120)
        end

        if math.max(unpack(loss_data)) == 0 then
            if ffi_loss.tr == 1 then
                notifications.new(string.format(' The connectivity returning back to normal ', data*100), 173,255,43)
                losswas = 1
            end

            ffi_loss.tr = 0
            ffi_loss.tr_ex = 0
            ffi_loss.maximum = data
        end
    end
end)

client.set_event_callback( "setup_command", function( cmd )
    local lp = ent.get_local_player()
    local m_fFlags = lp:get_prop("m_fFlags")
    local is_onground = bit.band(m_fFlags, 1) ~= 0 
    local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])

    if not func.includes(ui.get(menu.miscTab.miscmenushka), func.hex({170,170,96}) .. "Defensive Fix *WIP*") then
        return
    end

    if not is_onground then return end

    local function vec_3( _x, _y, _z ) 
        return { x = _x or 0, y = _y or 0, z = _z or 0 } 
    end
    
    local function ticks_to_time()
        return globals.tickinterval( ) * 16
    end 
    

    local function player_will_peek( )
        local enemies = entity.get_players( true )
        local m_fFlags = lp:get_prop("m_fFlags")
        local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])

        if not enemies then
            return false
        end
        
        if not isDt then return end

        local eye_position = vec_3( client.eye_position( ) )
        local velocity_prop_local = vec_3( entity.get_prop( entity.get_local_player( ), "m_vecVelocity" ) )
        local predicted_eye_position = vec_3( eye_position.x + velocity_prop_local.x * ticks_to_time( predicted ), eye_position.y + velocity_prop_local.y * ticks_to_time( predicted ), eye_position.z + velocity_prop_local.z * ticks_to_time( predicted ) )
    
        for i = 1, #enemies do
            local player = enemies[ i ]
            
            local velocity_prop = vec_3( entity.get_prop( player, "m_vecVelocity" ) )
            
            -- Store and predict player origin
            local origin = vec_3( entity.get_prop( player, "m_vecOrigin" ) )
            local predicted_origin = vec_3( origin.x + velocity_prop.x * ticks_to_time(), origin.y + velocity_prop.y * ticks_to_time(), origin.z + velocity_prop.z * ticks_to_time() )
            
            -- Set their origin to their predicted origin so we can run calculations on it
            entity.get_prop( player, "m_vecOrigin", predicted_origin )
            
            -- Predict their head position and fire an autowall trace to see if any damage can be dealt
            local head_origin = vec_3( entity.hitbox_position( player, 0 ) )
            local predicted_head_origin = vec_3( head_origin.x + velocity_prop.x * ticks_to_time(), head_origin.y + velocity_prop.y * ticks_to_time(), head_origin.z + velocity_prop.z * ticks_to_time() )
            local trace_entity, damage = client.trace_bullet( entity.get_local_player( ), predicted_eye_position.x, predicted_eye_position.y, predicted_eye_position.z, predicted_head_origin.x, predicted_head_origin.y, predicted_head_origin.z )
            
            -- Restore their origin to their networked origin
            entity.get_prop( player, "m_vecOrigin", origin )
            
            -- Check if damage can be dealt to their predicted head
            if damage > 0 then
                return true
            end
        end
        
        return false
    end
    

    if not isDt then
        return
    end 

    
    if player_will_peek() and is_onground then
        cmd.force_defensive = true
    else
        cmd.force_defensive = false
    end
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

client.set_event_callback('aim_hit', function(e)
    if ui.get(menu.miscTab.jitterFixEnabled) then
        local group = vars.hitgroup_names[e.hitgroup + 1] or '?';
        local P = e.target;
        local method = ui.get(menu.miscTab.jitterFix):lower()
        client.delay_call(0.001, function() 
            if entity.get_prop(e.target, 'm_iHealth') == 0 then
                client.color_log(159, 202, 43, "[winter] ~\0")
                client.color_log(255, 255, 255, ' Killed ' .. entity.get_player_name(e.target) .. " in " .. group:lower() .. ' for ' .. e.damage .. ' damage ( method: ' .. method ..' ~ eye: ' .. math.floor(eye_yaw) .. ' ~ '.. 'riptide fix? : ' .. ' yes' .. ' )')
            else
                client.color_log(159, 202, 43, "[winter] ~\0")
                client.color_log(255, 255, 255, ' Hit ' .. entity.get_player_name(e.target) .. " in " .. group:lower() .. ' for ' .. e.damage .. ' damage ( method: ' .. method .. ' ~ ' .. entity.get_prop(e.target, 'm_iHealth') ..' health remaining ~ eye: ' .. math.floor(eye_yaw) .. ' ~ riptide fix? : ' .. 'yes' .. ' )')
            end
        end)
    end

    if func.includes(ui.get(menu.visualsTab.logs), "Console") then
        if ui.get(menu.miscTab.jitterFixEnabled) then return end
        local group = vars.hitgroup_names[e.hitgroup + 1] or '?';
        client.delay_call(0.001, function() 
            if entity.get_prop(e.target, 'm_iHealth') == 0 then
                client.color_log(159, 202, 43, "[winter] ~\0")
                client.color_log(255, 255, 255, ' Killed ' .. entity.get_player_name(e.target) .. ' in ' .. group:lower() .. ' for ' .. e.damage .. ' damage')
            else
                client.color_log(159, 202, 43, "[winter] ~\0")
                client.color_log(255, 255, 255, ' Hit ' .. entity.get_player_name(e.target) .. ' in ' .. group:lower() .. ' for ' .. e.damage .. ' damage ( '.. entity.get_prop(e.target, 'm_iHealth') ..' health remaining )' )
            end
        end)    
    end

end)

client.set_event_callback('aim_miss', function(e)
    if ui.get(menu.miscTab.jitterFixEnabled) then
        local group = vars.hitgroup_names[e.hitgroup + 1] or '?';
        local method = ui.get(menu.miscTab.jitterFix):lower()
        client.delay_call(0.001, function() 
            if e.reason == "resolver" then 
                client.color_log(255, 120, 120, "[winter] ~\0")
                client.color_log(255, 255, 255, ' Missed shot at ' .. entity.get_player_name(e.target) .. ' in ' .. group:lower() .. ' due to ? ( method: ' .. method .. ' ~ eye: ' .. math.floor(eye_yaw) .. ' ~ riptide fix? : yes )')
            else
                client.color_log(255, 120, 120, "[winter] ~\0")
                client.color_log(255, 255, 255, ' Missed shot at ' .. entity.get_player_name(e.target) .. ' in ' .. group:lower() .. ' due to ' .. e.reason .. ' ( method: ' .. method .. ' ~ eye: ' .. math.floor(eye_yaw) .. ' ~ riptide fix? : yes )')
            end
        end)
    end

    if func.includes(ui.get(menu.visualsTab.logs), "Console") then
        if ui.get(menu.miscTab.jitterFixEnabled) then return end
        local group = vars.hitgroup_names[e.hitgroup + 1] or '?';
        client.delay_call(0.001, function() 
            client.color_log(255, 120, 120, "[winter] ~\0")
            client.color_log(255, 255, 255, ' Missed shot at ' .. entity.get_player_name(e.target) .. ' in ' .. group:lower() .. ' due to ' .. e.reason)
        end)    
    end
end)

local x_ind, y_ind = client.screen_size()
local function paint_indicator()
    if not ui.get(menu.miscTab.jitterFixEnabled) then return end
    local enemies = entity.get_players(true)
    if entity.is_dormant(enemies) and entity.is_alive(vars.localPlayer) then
        if ent_name == none then
            renderer.text(125, y_ind/2.5+46, 255, 255, 255, 255, "-c", 0, "[+/- WINTER JITTER ASSISTANCE] ENEMY: WAITING")
            renderer.text(125, y_ind/2.5+36, 255, 255, 255, 255, "-c", 0, "[+/- WINTER JITTER ASSISTANCE] EYE: WAITING")
        else
            renderer.text(125, y_ind/2.5+46, 255, 255, 255, 255, "-c", 0, "[+/- WINTER JITTER ASSISTANCE] ENEMY: " .. ent_name:upper())
            renderer.text(125, y_ind/2.5+36, 255, 255, 255, 255, "-c", 0, "[+/- WINTER JITTER ASSISTANCE] EYE: " .. math.floor(eye_yaw))
        end
    end
end

client.set_event_callback("round_prestart", function ()
    ent_name = 'none'
    eye_yaw = 0
end)

client.set_event_callback("paint", paint_indicator)
client.set_event_callback("setup_command", RefreshingResolver)
client.set_event_callback('shutdown', function()
    ui.set_visible(refs.AntiAimCorrect, true)
    ui.set_visible(refs.CorrectEnable, true)
    ui.set_visible(refs.ForceBodyYaw, false)
    ui.set_visible(refs.ForceBodyYawValue[1], false)  
end)