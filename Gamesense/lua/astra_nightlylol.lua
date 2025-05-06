local username = "bozo"
local build = "Nightly"--_G.astra and loader_decode_string(loader_get_user_build()) or "Private"
local weapons = require "gamesense/csgo_weapons"
local ffi = require('ffi')
local l_images = require "gamesense/images"
local images = require "gamesense/images"
local vector = require 'vector'
local pui = require 'gamesense/pui'
local base64 = require 'gamesense/base64'
local c_entity = require 'gamesense/entity'
local c_weapon = require 'gamesense/csgo_weapons'
local msgpack = require 'gamesense/msgpack'
local http = require 'gamesense/http'
local md5 = require 'gamesense/md5'
local discord = require "gamesense/discord_webhooks"

local timer = client.timestamp()

local C = function (t) local c = {} if type(t) ~= "table" then return t end for k, v in next, t do c[k] = v end return c end

-- local table, math, string = C(table), C(math), C(string)
-- local ui, client, database, entity, ffi, globals, panorama, renderer = C(ui), C(client), C(database), C(entity), C(require "ffi"), C(globals), C(panorama), C(renderer)
local renderer_world_to_screen,
renderer_line,
-- globals_tickinterval,
-- renderer_indicator,
-- entity_get_esp_data,
bit_lshift,
renderer_circle,
table_insert,
-- globals.framecount,
renderer_triangle,
client_exec,
entity_get_players,
math_cos,
entity_is_enemy,
client_userid_to_entindex,
globals_curtime,
entity_get_player_weapon,
entity_get_local_player,
entity_is_alive,
renderer_text,
renderer_rectangle,
globals_realtime,
globals_frametime =
renderer.world_to_screen,
renderer.line,
bit.lshift,
renderer.circle,
table.insert,
renderer.triangle,
client.exec,
entity.get_players,
math.cos,
entity.is_enemy,
client.userid_to_entindex,
globals.curtime,
entity.get_player_weapon,
entity.get_local_player,
entity.is_alive,
renderer.text,
renderer.rectangle,
globals.realtime,
globals.frametime
           

local entity_get_prop = entity.get_prop

local js = panorama.open()
local steam_name = js.MyPersonaAPI.GetName()
local steam64 = js.MyPersonaAPI.GetXuid()

-- local Webhook = discord.new("https://discord.com/api/webhooks/1188185948534620222/tO8dKe_5N-XAs-SteAwoAMKdrr2D0uLXwePbkhT_SReoBWzwHUsP50us_8Z6n7CZuyC7")
-- local RichEmbed = discord.newEmbed()

-- Webhook:setUsername("Astra.lua")
-- Webhook:setAvatarURL("http://cloudpusy.ct8.pl/cloud/api/neverlose/astra_menu_glow.png")
-- RichEmbed:setTitle(username .. " just loaded Astra " .. build)
-- RichEmbed:setColor(7661062)
-- RichEmbed:addField("Steam Profile", "Name: ".. steam_name.."\n[Profile Link](https://steamcommunity.com/profiles/" .. steam64 .. ")", true)
-- Webhook:send(RichEmbed)

                    
local reference
do
    reference = { }

    reference.AA = { }

    reference.logging = {
        spread = pui.reference('Rage', 'Other', 'Log misses due to spread'),
        damage = pui.reference('Misc', 'Miscellaneous', 'Log damage dealt'),
        purchases = pui.reference('Misc', 'Miscellaneous', 'Log weapon purchases')
    }

    reference.AA.angles = {
        enabled = { pui.reference('AA', 'Anti-aimbot angles', 'Enabled') },
        pitch =  { pui.reference('AA', 'Anti-aimbot angles', 'Pitch') },
        yaw_base = { pui.reference('AA', 'Anti-aimbot angles', 'Yaw Base') },
        yaw = { pui.reference('AA', 'Anti-aimbot angles', 'Yaw') },
        body_yaw = { pui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
        yaw_modifier = { pui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
        freestanding = { pui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
        freestanding_byaw = { pui.reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw') },
        edge_yaw = { pui.reference('AA', 'Anti-aimbot angles', 'Edge yaw') },
        roll = { pui.reference('AA', 'Anti-aimbot angles', 'Roll') }
    }

    reference.AA.other = {
        leg_movement = pui.reference('AA', 'Other', 'Leg movement')
    }

    reference.AA.fakelag = {
        enabled = { pui.reference('AA', 'Fake lag', 'Enabled') },
        amount = pui.reference('AA', 'Fake lag', 'Amount'),
        variance = pui.reference('AA', 'Fake lag', 'Variance'),
        limit = pui.reference('AA', 'Fake lag', 'Limit')
    }

    reference.RAGE = {
        enabled = pui.reference('Rage', 'Aimbot', 'Enabled'),
        hitchance = pui.reference('Rage', 'Aimbot', 'Minimum hit chance'),
        autoscope = pui.reference('Rage', 'Aimbot', 'Automatic scope'),
        min_damage = pui.reference('RAGE', 'Aimbot', 'Minimum damage'),
        damage_override = { pui.reference('RAGE', 'Aimbot', 'Minimum damage override') },
        force_safe_point = pui.reference('RAGE', 'Aimbot', 'Force safe point'),
        force_body_aim = pui.reference('RAGE', 'Aimbot', 'Force body aim'),
        double_tap = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
        hide_shots = { ui.reference('AA', 'Other', 'On shot anti-aim') },
        autopeek = { pui.reference('RAGE', 'Other', 'Quick peek assist') },
        fakeduck = pui.reference('RAGE', 'Other', 'Duck peek assist'),
        slowwalk = { ui.reference('AA', 'Other', 'Slow motion') }
    }

    reference.MISC = {
        clantag = pui.reference('Misc', 'Miscellaneous', 'Clan tag spammer'),
        ticks = pui.reference("Misc", "Settings", "sv_maxusrcmdprocessticks2"),
        color = pui.reference('Misc', 'Settings', 'Menu color')
    }

    function reference.is_doubletap()
        return ui.get(reference.RAGE.double_tap[1]) and ui.get(reference.RAGE.double_tap[2])
    end

    function reference.is_slowwalk()
        return ui.get(reference.RAGE.slowwalk[1]) and ui.get(reference.RAGE.slowwalk[2])
    end

    function reference.is_freestanding()
        local is_active = reference.AA.angles.freestanding[1]:get_hotkey()
        return is_active and reference.AA.angles.freestanding[1]:get()
    end

    function reference.is_mindamage_override()
        return reference.RAGE.damage_override[1]:get() and reference.RAGE.damage_override[1]:get_hotkey()
    end

    function reference.get_damage()
        if reference.is_mindamage_override() then
            return reference.RAGE.damage_override[2]:get()
        end

        return reference.RAGE.min_damage:get()
    end
end

local absf, ceil, cosf, floor = math.abs, math.ceil, math.cos, math.floor;


local iengineclient = { };
local motion = { };
local localplayer = { };

    
    local function u8(s)
        return string.gsub(s, "[\128-\191]", "");
    end
    
    local function clamp(x, min, max)
        return math.max(min, math.min(x, max));
    end
    
    local function lerp(a, b, t)
        return a + t * (b - a);
    end
    
    local function sign(x)
        if x > 0 then return 1 end
        if x < 0 then return -1 end
    
        return 0;
    end
    
    local function round(x)
        if x < 0 then
            return ceil(x - 0.5);
        end
    
        return floor(x + 0.5);
    end
    
    local function empty(list)
        return next(list) == nil;
    end
    
    local function table_keys(list)
        local keys = { };
    
        for k, v in pairs(list) do
            keys[v] = k;
        end
    
        return keys;
    end

    do
    
        local native_IsInGame = vtable_bind("engine.dll", "VEngineClient014", 20, "bool(__thiscall*)(void*)");
        local native_GetTimescale = vtable_bind("engine.dll", "VEngineClient014", 91, "float(__thiscall*)(void*)");
    
        function iengineclient.is_in_game()
            return native_IsInGame();
        end
    
    
        function iengineclient.get_timescale()
            return native_GetTimescale();
        end
    end
    
    do
        local function linear(t, b, c, d)
            return c * t / d + b;
        end
    
        local function get_deltatime()
            return globals_frametime() / iengineclient.get_timescale();
        end
    
        local function solve(easing_fn, prev, new, clock, duration)
            if clock <= 0 then return new end
            if clock >= duration then return new end
    
            prev = easing_fn(clock, prev, new - prev, duration);
    
            if type(prev) == "number" then
                if absf(new - prev) < 0.001 then
                    return new;
                end
    
                local remainder = math.fmod(prev, 1.0);
    
                if remainder < 0.001 then
                    return floor(prev);
                end
    
                if remainder > 0.999 then
                    return ceil(prev);
                end
            end
    
            return prev;
        end
    
        function motion.interp(a, b, t, easing_fn)
            easing_fn = easing_fn or linear;
    
            if type(b) == "boolean" then
                b = b and 1 or 0;
            end
    
            return solve(easing_fn, a, b, get_deltatime(), t);
        end
    end
    local panorama_loadstring, panorama_open = panorama.loadstring, panorama.open;


    local table_new = require('table.new')
    local plistelo = {
        reset = {
            ForceBodyYaw = {},
            ForceBodyYawCheckbox = {},
            CorrectionActive = {},
        },
        values = {
            ForceBodyYaw = {},
            ForceBodyYawCheckbox = {},
            CorrectionActive = {},
        },
        ref = {
            selected_player = ui.reference('PLAYERS', 'Players', 'Player list', false)
        }
    }
    
    function plistelo.GetPlayer()
        return ui.get(plistelo['ref'].selected_player)
    end
    
    function plistelo.sprawdzczyjest(ent)
        return plist.get(ent, 'Correction active')
    end
    
    function plistelo.ustawcorrectionato(ent, val)
        return plist.set(ent, 'Correction active', val)
    end
    
    -- Body yaw
    function plistelo.forcujbodycheckbox(ent)
        if not ent then
            return
        end
        
        return plist.get(ent, 'Force body yaw')
    end
    
    function plistelo.nokurwaustawto(ent, val)
        if not ent or plistelo['values'].ForceBodyYawCheckbox[ent] == val  then
            return
        end
        plist.set(ent, 'Force body yaw', val)
        plistelo['values'].ForceBodyYawCheckbox[ent] = val
    end
    
    function plistelo.GetBodyYaw(ent)
        if not ent then
            return
        end
        plistelo['values'].ForceBodyYaw[ent] = plistelo['values'].ForceBodyYaw[ent] or 0
        return plist.get(ent, 'Force body yaw value')
    end
    
    function plistelo.ustawtokurwa(ent, val)
        if not ent or plistelo['values'].ForceBodyYaw[ent] == val then
            return
        end
        plist.set(ent, 'Force body yaw value', val)
        plistelo['values'].ForceBodyYaw[ent] = val
    end
    
    local function round( num, decimals )
        num = num or 0
        decimals = decimals or 0
    
        local mult = 10 ^ (decimals)
        return math.floor(num * mult + 0.5) / mult
    end
    
    local function between( v, min, max )
        v = v or false
        min = min or false
        max = max or false
    
        return (v and min and max) and (v > min and v < max) or false
    end
    
    local function normalize_yaw(yaw)
        return (yaw + 180) % 360 - 180
    end
    
    local function clamp( x, min, max )
        x = x or 0
        max = max or 0
        min = min or 0
    
        return math.min(math.max(min, x), max)
    end
    
    local function contains(tbl, val)
        for i=1,#tbl do
            if tbl[i] == val then
                return true
            end
        end
        return false
    end
    
    local function bin_value(value, num_bits)
        local scale_factor = 2 ^ num_bits
        local scaled_value = math.floor(value * scale_factor + 0.5)
        local bits = {}
        for i = num_bits, 1, -1 do
            local bit_value = 2 ^ (i - 1)
            if scaled_value >= bit_value then
                bits[i] = 1
                scaled_value = scaled_value - bit_value
            else
                bits[i] = 0
            end
        end
        return bits
    end
    
    local function normalize(value, min, max)
      return (value - min) / (max - min)
    end
    
    local function insert_first_index(tbl, value, maxSize)
        if #tbl >= maxSize then
            table.remove(tbl)
        end
    
        table.insert(tbl, 1, value)
    end
    
    local average = function( t )
        t = t or { }
    
        local sum = 0
        for _,v in pairs(t) do
            sum = sum + v
        end
        return sum / #t
    end
    
    local ent_c = {}
    ent_c.get_client_entity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')
    
    local animation_state_t =
        ffi.typeof('\13\10\9\115\116\114\117\99\116\32\123\13\10\9\9\99\104\97\114\9\117\48\91\32\48\120\49\56\32\93\59\13\10\9\9\102\108\111\97\116\9\97\110\105\109\95\117\112\100\97\116\101\95\116\105\109\101\114\59\13\10\9\9\99\104\97\114\9\117\49\91\32\48\120\67\32\93\59\13\10\9\9\102\108\111\97\116\9\115\116\97\114\116\101\100\95\109\111\118\105\110\103\95\116\105\109\101\59\13\10\9\9\102\108\111\97\116\9\108\97\115\116\95\109\111\118\101\95\116\105\109\101\59\13\10\9\9\99\104\97\114\9\117\50\91\32\48\120\49\48\32\93\59\13\10\9\9\102\108\111\97\116\9\108\97\115\116\95\108\98\121\95\116\105\109\101\59\13\10\9\9\99\104\97\114\9\117\51\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\114\117\110\95\97\109\111\117\110\116\59\13\10\9\9\99\104\97\114\9\117\52\91\32\48\120\49\48\32\93\59\13\10\9\9\118\111\105\100\9\42\101\110\116\105\116\121\59\13\10\9\9\95\95\105\110\116\51\50\32\97\99\116\105\118\101\95\119\101\97\112\111\110\59\13\10\9\9\95\95\105\110\116\51\50\32\108\97\115\116\95\97\99\116\105\118\101\95\119\101\97\112\111\110\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\76\97\115\116\67\108\105\101\110\116\83\105\100\101\65\110\105\109\97\116\105\111\110\85\112\100\97\116\101\84\105\109\101\59\13\10\9\9\95\95\105\110\116\51\50\32\109\95\105\76\97\115\116\67\108\105\101\110\116\83\105\100\101\65\110\105\109\97\116\105\111\110\85\112\100\97\116\101\70\114\97\109\101\99\111\117\110\116\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\65\110\105\109\85\112\100\97\116\101\68\101\108\116\97\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\69\121\101\89\97\119\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\80\105\116\99\104\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\71\111\97\108\70\101\101\116\89\97\119\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\67\117\114\114\101\110\116\70\101\101\116\89\97\119\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\67\117\114\114\101\110\116\84\111\114\115\111\89\97\119\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\85\110\107\110\111\119\110\86\101\108\111\99\105\116\121\76\101\97\110\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\76\101\97\110\65\109\111\117\110\116\59\13\10\9\9\99\104\97\114\9\117\53\91\32\48\120\52\32\93\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\70\101\101\116\67\121\99\108\101\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\70\101\101\116\89\97\119\82\97\116\101\59\13\10\9\9\99\104\97\114\9\117\54\91\32\48\120\52\32\93\59\13\10\9\9\102\108\111\97\116\9\109\95\102\68\117\99\107\65\109\111\117\110\116\59\13\10\9\9\102\108\111\97\116\9\109\95\102\76\97\110\100\105\110\103\68\117\99\107\65\100\100\105\116\105\118\101\83\111\109\101\116\104\105\110\103\59\13\10\9\9\99\104\97\114\9\117\55\91\32\48\120\52\32\93\59\13\10\9\9\102\108\111\97\116\32\9\109\95\118\79\114\105\103\105\110\88\59\32\47\47\48\120\66\48\13\10\9\9\102\108\111\97\116\32\9\109\95\118\79\114\105\103\105\110\89\59\32\47\47\48\120\66\52\13\10\9\9\102\108\111\97\116\32\9\109\95\118\79\114\105\103\105\110\90\59\32\47\47\48\120\66\56\13\10\9\9\102\108\111\97\116\32\9\109\95\118\76\97\115\116\79\114\105\103\105\110\88\59\32\47\47\48\120\66\67\13\10\9\9\102\108\111\97\116\32\9\109\95\118\76\97\115\116\79\114\105\103\105\110\89\59\32\47\47\48\120\67\48\13\10\9\9\102\108\111\97\116\32\9\109\95\118\76\97\115\116\79\114\105\103\105\110\90\59\32\47\47\48\120\67\52\13\10\9\9\102\108\111\97\116\9\109\95\118\86\101\108\111\99\105\116\121\88\59\13\10\9\9\102\108\111\97\116\9\109\95\118\86\101\108\111\99\105\116\121\89\59\13\10\9\9\99\104\97\114\9\117\56\91\32\48\120\49\48\32\93\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\85\110\107\110\111\119\110\70\108\111\97\116\49\59\32\47\47\109\111\118\101\95\100\105\114\101\99\116\105\111\110\95\49\13\10\9\9\102\108\111\97\116\9\109\95\102\108\85\110\107\110\111\119\110\70\108\111\97\116\50\59\32\47\47\109\111\118\101\95\100\105\114\101\99\116\105\111\110\95\50\13\10\9\9\99\104\97\114\9\117\57\91\32\48\120\52\32\93\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\83\112\101\101\100\50\68\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\85\112\86\101\108\111\99\105\116\121\59\32\13\10\9\9\102\108\111\97\116\9\109\95\102\108\83\112\101\101\100\78\111\114\109\97\108\105\122\101\100\59\32\13\10\9\9\102\108\111\97\116\9\109\95\102\108\70\101\101\116\83\112\101\101\100\70\111\114\119\97\114\100\115\79\114\83\105\100\101\87\97\121\115\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\70\101\101\116\83\112\101\101\100\85\110\107\110\111\119\110\70\111\114\119\97\114\100\79\114\83\105\100\101\119\97\121\115\59\32\13\10\9\9\102\108\111\97\116\9\109\95\102\108\84\105\109\101\83\105\110\99\101\83\116\97\114\116\101\100\77\111\118\105\110\103\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\84\105\109\101\83\105\110\99\101\83\116\111\112\112\101\100\77\111\118\105\110\103\59\13\10\9\9\98\111\111\108\9\109\95\98\79\110\71\114\111\117\110\100\59\13\10\9\9\98\111\111\108\9\109\95\98\73\110\72\105\116\71\114\111\117\110\100\65\110\105\109\97\116\105\111\110\59\13\10\9\9\99\104\97\114\9\117\49\48\91\32\48\120\52\32\93\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\76\97\115\116\79\114\105\103\105\110\90\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\72\101\97\100\72\101\105\103\104\116\79\114\79\102\102\115\101\116\70\114\111\109\72\105\116\116\105\110\103\71\114\111\117\110\100\65\110\105\109\97\116\105\111\110\59\13\10\9\9\102\108\111\97\116\9\109\95\102\108\83\116\111\112\84\111\70\117\108\108\82\117\110\110\105\110\103\70\114\97\99\116\105\111\110\59\13\10\9\9\99\104\97\114\9\117\49\49\91\32\48\120\49\52\32\93\59\13\10\9\9\95\95\105\110\116\51\50\32\109\95\102\108\85\110\107\110\111\119\110\70\114\97\99\116\105\111\110\59\13\10\9\9\99\104\97\114\9\117\49\50\91\32\48\120\50\48\32\93\59\13\10\9\9\102\108\111\97\116\9\108\97\115\116\95\97\110\105\109\95\117\112\100\97\116\101\95\116\105\109\101\59\13\10\9\9\102\108\111\97\116\9\109\111\118\105\110\103\95\100\105\114\101\99\116\105\111\110\95\120\59\13\10\9\9\102\108\111\97\116\9\109\111\118\105\110\103\95\100\105\114\101\99\116\105\111\110\95\121\59\13\10\9\9\102\108\111\97\116\9\109\111\118\105\110\103\95\100\105\114\101\99\116\105\111\110\95\122\59\13\10\9\9\99\104\97\114\9\117\49\51\91\32\48\120\52\52\32\93\59\13\10\9\9\95\95\105\110\116\51\50\32\115\116\97\114\116\101\100\95\109\111\118\105\110\103\59\13\10\9\9\99\104\97\114\9\117\49\52\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\108\101\97\110\95\121\97\119\59\13\10\9\9\99\104\97\114\9\117\49\53\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\112\111\115\101\115\95\115\112\101\101\100\59\13\10\9\9\99\104\97\114\9\117\49\54\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\108\97\100\100\101\114\95\115\112\101\101\100\59\13\10\9\9\99\104\97\114\9\117\49\55\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\108\97\100\100\101\114\95\121\97\119\59\13\10\9\9\99\104\97\114\9\117\49\56\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\115\111\109\101\95\112\111\115\101\59\13\10\9\9\99\104\97\114\9\117\49\57\91\32\48\120\49\52\32\93\59\13\10\9\9\102\108\111\97\116\9\98\111\100\121\95\121\97\119\59\13\10\9\9\99\104\97\114\9\117\50\48\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\98\111\100\121\95\112\105\116\99\104\59\13\10\9\9\99\104\97\114\9\117\50\49\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\100\101\97\116\104\95\121\97\119\59\13\10\9\9\99\104\97\114\9\117\50\50\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\115\116\97\110\100\59\13\10\9\9\99\104\97\114\9\117\50\51\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\106\117\109\112\95\102\97\108\108\59\13\10\9\9\99\104\97\114\9\117\50\52\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\97\105\109\95\98\108\101\110\100\95\115\116\97\110\100\95\105\100\108\101\59\13\10\9\9\99\104\97\114\9\117\50\53\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\97\105\109\95\98\108\101\110\100\95\99\114\111\117\99\104\95\105\100\108\101\59\13\10\9\9\99\104\97\114\9\117\50\54\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\115\116\114\97\102\101\95\121\97\119\59\13\10\9\9\99\104\97\114\9\117\50\55\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\97\105\109\95\98\108\101\110\100\95\115\116\97\110\100\95\119\97\108\107\59\13\10\9\9\99\104\97\114\9\117\50\56\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\97\105\109\95\98\108\101\110\100\95\115\116\97\110\100\95\114\117\110\59\13\10\9\9\99\104\97\114\9\117\50\57\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\97\105\109\95\98\108\101\110\100\95\99\114\111\117\99\104\95\119\97\108\107\59\13\10\9\9\99\104\97\114\9\117\51\48\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\109\111\118\101\95\98\108\101\110\100\95\119\97\108\107\59\13\10\9\9\99\104\97\114\9\117\51\49\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\109\111\118\101\95\98\108\101\110\100\95\114\117\110\59\13\10\9\9\99\104\97\114\9\117\51\50\91\32\48\120\56\32\93\59\13\10\9\9\102\108\111\97\116\9\109\111\118\101\95\98\108\101\110\100\95\99\114\111\117\99\104\59\13\10\9\9\99\104\97\114\9\117\51\51\91\32\48\120\52\32\93\59\13\10\9\9\102\108\111\97\116\9\115\112\101\101\100\59\13\10\9\9\95\95\105\110\116\51\50\32\109\111\118\105\110\103\95\105\110\95\97\110\121\95\100\105\114\101\99\116\105\111\110\59\13\10\9\9\102\108\111\97\116\9\97\99\99\101\108\101\114\97\116\105\111\110\59\13\10\9\9\99\104\97\114\9\117\51\52\91\32\48\120\55\52\32\93\59\13\10\9\9\102\108\111\97\116\9\99\114\111\117\99\104\95\104\101\105\103\104\116\59\13\10\9\9\95\95\105\110\116\51\50\32\105\115\95\102\117\108\108\95\99\114\111\117\99\104\101\100\59\13\10\9\9\99\104\97\114\9\117\51\53\91\32\48\120\52\32\93\59\13\10\9\9\102\108\111\97\116\9\118\101\108\111\99\105\116\121\95\115\117\98\116\114\97\99\116\95\120\59\13\10\9\9\102\108\111\97\116\9\118\101\108\111\99\105\116\121\95\115\117\98\116\114\97\99\116\95\121\59\13\10\9\9\102\108\111\97\116\9\118\101\108\111\99\105\116\121\95\115\117\98\116\114\97\99\116\95\122\59\13\10\9\9\102\108\111\97\116\9\115\116\97\110\100\105\110\103\95\104\101\97\100\95\104\101\105\103\104\116\59\13\10\9\125\32\42\42\13\10')
    
    local animation_layer_t =
        ffi.typeof('\13\10\9\115\116\114\117\99\116\32\123\9\9\9\9\9\9\9\9\9\9\99\104\97\114\32\112\97\100\48\91\48\120\49\56\93\59\13\10\9\9\117\105\110\116\51\50\95\116\9\109\95\110\83\101\113\117\101\110\99\101\59\13\10\9\9\102\108\111\97\116\9\9\109\95\102\108\80\114\101\118\67\121\99\108\101\59\13\10\9\9\102\108\111\97\116\9\9\109\95\102\108\87\101\105\103\104\116\59\13\10\9\9\102\108\111\97\116\9\9\109\95\102\108\87\101\105\103\104\116\68\101\108\116\97\82\97\116\101\59\13\10\9\9\102\108\111\97\116\9\9\109\95\102\108\80\108\97\121\98\97\99\107\82\97\116\101\59\13\10\9\9\102\108\111\97\116\9\9\109\95\102\108\67\121\99\108\101\59\13\10\9\9\118\111\105\100\9\9\42\101\110\116\105\116\121\59\9\9\9\9\9\9\99\104\97\114\32\112\97\100\49\91\48\120\52\93\59\13\10\9\125\32\42\42\13\10')
    
    local offsetykurwa = {
        animstate = 0x9960,
        layers = 0x2990
    }
    
    local function animstate(ent)
        local ent_ptr = ffi.cast('void***', ent_c.get_client_entity(ent))
        local animstate_ptr = ffi.cast("char*", ent_ptr) + offsetykurwa.animstate
        local entity_animstate = ffi.cast(animation_state_t, animstate_ptr)[0]
        return entity_animstate
    end
    
    local function layerik(ent, layer)
        local ent_ptr = ffi.cast('void***', ent_c.get_client_entity(ent or entity.get_local_player()))
        local layers_ptr = ffi.cast('char*', ent_ptr) + offsetykurwa.layers
        local entity_layers = ffi.cast(animation_layer_t, layers_ptr)[0][layer]
        return entity_layers
    end
    
    local ACTIVATION_RESPONSE = 1
    
    local ResolverDATA = {
        transfer = function(x)
            return 1 / (1 + math.exp(-x / ACTIVATION_RESPONSE))
        end, 
        transfer_inverse = function(y)
            return ACTIVATION_RESPONSE * math.log(y / (1 - y))
        end	
    }
    
    function ResolverDATA.create(_numInputs, _numOutputs, _numHiddenLayers, _neuronsPerLayer, _learningRate)
        _numInputs = _numInputs or 1
        _numOutputs = _numOutputs or 1
        _numHiddenLayers = _numHiddenLayers or math.ceil(_numInputs / 2)
        _neuronsPerLayer = _neuronsPerLayer or math.ceil(_numInputs * .66666 + _numOutputs)
        _learningRate = _learningRate or .5
    
        local network = setmetatable(
            {
                learningRate = _learningRate
            },
            {__index = ResolverDATA}
        )
    
        network[1] = table_new(_numInputs, 0) 
        for i = 1, _numInputs do
            network[1][i] = table_new(0, 0)
        end
        for i = 2, _numHiddenLayers + 2 do 
            local neuronsInLayer = _neuronsPerLayer
            if i == _numHiddenLayers + 2 then
                neuronsInLayer = _numOutputs
            end
            network[i] = table_new(neuronsInLayer, 0)
            for j = 1, neuronsInLayer do
                network[i][j] = table_new(_numInputs, 1)
                network[i][j].bias = math.random() * 2 - 1
                local numNeuronInputs = #(network[i - 1])
                for k = 1, numNeuronInputs do
                    network[i][j][k] = math.random() * 2 - 1 
                end
            end
        end
        return network
    end
    
    function ResolverDATA:forewardPropagate(...)
        local arg = {...}
        if #(arg) ~= #(self[1]) and type(arg[1]) ~= "table" then
            error(
                "Neural Network received " ..
                    #(arg) .. " input[s] (expected " .. #(self[1]) .. " input[s])",
                2
            )
        elseif type(arg[1]) == "table" and #(arg[1]) ~= #(self[1]) then
            error(
                "Neural Network received " ..
                    #(arg[1]) .. " input[s] (expected " .. #(self[1]) .. " input[s])",
                2
            )
        end
        local outputs = {}
        for i = 1, #(self) do
            for j = 1, #(self[i]) do
                if i == 1 then
                    if type(arg[1]) == "table" then
                        self[i][j].result = arg[1][j]
                    else
                        self[i][j].result = arg[j]
                    end
                else
                    self[i][j].result = self[i][j].bias
                    for k = 1, #(self[i][j]) do
                        self[i][j].result = self[i][j].result + (self[i][j][k] * self[i - 1][k].result)
                    end
                    self[i][j].result = ResolverDATA.transfer(self[i][j].result)
                    if i == #(self) then
                        table.insert(outputs, self[i][j].result)
                    end
                end
                self[i][j].active = self[i][j].result > 0.5
            end
        end
        return outputs
    end
    
    
    function ResolverDATA:backwardPropagate(inputs, desiredOutputs)
        if #(inputs) ~= #(self[1]) then
            error(
                "Neural Network received " ..
                    #(inputs) .. " input[s] (expected " .. #(self[1]) .. " input[s])",
                2
            )
        elseif #(desiredOutputs) ~= #(self[#self]) then
            error(
                "Neural Network received " ..
                    #(desiredOutputs) ..
                        " desired output[s] (expected " .. #(self[#self]) .. " desired output[s])",
                2
            )
        end
        self:forewardPropagate(inputs)
        for i = #self, 2, -1 do 
            local tempResults = {}
            for j = 1, #self[i] do
                if i == #self then 
                    self[i][j].delta = (desiredOutputs[j] - self[i][j].result) * self[i][j].result * (1 - self[i][j].result)
                else
                    local weightDelta = 0
                    for k = 1, #self[i + 1] do
                        weightDelta = weightDelta + self[i + 1][k][j] * self[i + 1][k].delta
                    end
                    self[i][j].delta = self[i][j].result * (1 - self[i][j].result) * weightDelta
                end
            end
        end
        for i = 2, #self do
            for j = 1, #self[i] do
                self[i][j].bias = self[i][j].delta * self.learningRate
                for k = 1, #self[i][j] do
                    self[i][j][k] = self[i][j][k] + self[i][j].delta * self.learningRate * self[i - 1][k].result
                end
            end
        end
    end
    
    local scr_w, scr_h = client.screen_size()
    
    function ResolverDATA:train( trainingSet, attempts)
        while attempts > 0 do
            for i = 1,#trainingSet do
                self:backwardPropagate(trainingSet[i].input,trainingSet[i].output)
            end
            attempts = attempts - 1
        end
    end
    
    function ResolverDATA:save()
        local data =
            "|INFO|FF BP NN|I|" ..
            tostring(#(self[1])) ..
                "|O|" ..
                    tostring(#(self[#self])) ..
                        "|HL|" ..
                            tostring(#self - 2) ..
                                "|NHL|" .. tostring(#(self[2])) .. "|LR|" .. tostring(self.learningRate) .. "|BW|"
        for i = 2, #self do -- nothing to save for input layer
            for j = 1, #self[i] do
                local neuronData = tostring(self[i][j].bias) .. "{"
                for k = 1, #(self[i][j]) do
                    neuronData = neuronData .. tostring(self[i][j][k])
                    neuronData = neuronData .. ","
                end
                data = data .. neuronData .. "}"
            end
        end
        data = data .. "|END|"
        return data
    end
    
    function ResolverDATA.load(data)
        local dataPos = string.find(data, "|") + 1
        local currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
        local dataPos = string.find(data, "|", dataPos) + 1
        local _inputs, _outputs, _hiddenLayers, _neuronsPerLayer, _learningRate
        local biasWeights = {}
        local errorExit = false
        while currentChunk ~= "END" and not errorExit do
            if currentChuck == "INFO" then
                currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
                dataPos = string.find(data, "|", dataPos) + 1
                if currentChunk ~= "FF BP NN" then
                    errorExit = true
                end
            elseif currentChunk == "I" then
                currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
                dataPos = string.find(data, "|", dataPos) + 1
                _inputs = tonumber(currentChunk)
            elseif currentChunk == "O" then
                currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
                dataPos = string.find(data, "|", dataPos) + 1
                _outputs = tonumber(currentChunk)
            elseif currentChunk == "HL" then
                currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
                dataPos = string.find(data, "|", dataPos) + 1
                _hiddenLayers = tonumber(currentChunk)
            elseif currentChunk == "NHL" then
                currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
                dataPos = string.find(data, "|", dataPos) + 1
                _neuronsPerLayer = tonumber(currentChunk)
            elseif currentChunk == "LR" then
                currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
                dataPos = string.find(data, "|", dataPos) + 1
                _learningRate = tonumber(currentChunk)
            elseif currentChunk == "BW" then
                currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
                dataPos = string.find(data, "|", dataPos) + 1
                local subPos = 1
                local subChunk
                for i = 1, _hiddenLayers + 1 do
                    biasWeights[i] = {}
                    local neuronsInLayer = _neuronsPerLayer
                    if i == _hiddenLayers + 1 then
                        neuronsInLayer = _outputs
                    end
                    for j = 1, neuronsInLayer do
                        biasWeights[i][j] = {}
                        biasWeights[i][j].bias =
                            tonumber(string.sub(currentChunk, subPos, string.find(currentChunk, "{", subPos) - 1))
                        subPos = string.find(currentChunk, "{", subPos) + 1
                        subChunk = string.sub(currentChunk, subPos, string.find(currentChunk, ",", subPos) - 1)
                        local maxPos = string.find(currentChunk, "}", subPos)
                        while subPos < maxPos do
                            table.insert(biasWeights[i][j], tonumber(subChunk))
                            subPos = string.find(currentChunk, ",", subPos) + 1
                            if string.find(currentChunk, ",", subPos) ~= nil then
                                subChunk = string.sub(currentChunk, subPos, string.find(currentChunk, ",", subPos) - 1)
                            end
                        end
                        subPos = maxPos + 1
                    end
                end
            end
            currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
            dataPos = string.find(data, "|", dataPos) + 1
        end
    
        if errorExit then
            error("Failed to load Neural Network:" .. currentChunk, 2)
        end
    
        local network = setmetatable(
            {
                learningRate = _learningRate
            },
            {__index = ResolverDATA}
        )
            
        network[1] = {} 
        for i = 1, _inputs do
            network[1][i] = {}
        end
        for i = 2, _hiddenLayers + 2 do 
            network[i] = {}
            local neuronsInLayer = _neuronsPerLayer
            if i == _hiddenLayers + 2 then
                neuronsInLayer = _outputs
            end
            for j = 1, neuronsInLayer do
                network[i][j] = {bias = biasWeights[i - 1][j].bias}
                local numNeuronInputs = #(network[i - 1])
                for k = 1, numNeuronInputs do
                    network[i][j][k] = biasWeights[i - 1][j][k]
                end
            end
        end
        return network
    end
    

    local function create_ui_element(element_type, category, name, args, visible, callback)
        local element
        if element_type == 'slider' then
            element = ui.new_slider(category, 'A', name, args[1], args[2], args[3], true, "", args[4])
        elseif element_type == 'multiselect' then
            element = ui.new_multiselect("AA", 'Other', name, args)
        elseif element_type == 'button' then
            element = ui.new_button(category, 'A', name, args or function() end)
        end
        ui.set_visible(element, visible)
        
        if callback and element_type ~= 'button' then
            ui.set_callback(element, callback)
        end
    
        return element
    end
    
    
    local clear, merge, table_insert, table_remove, table_sort = table.clear, table.concat, table.insert, table.remove, table.sort;
    local utils = { };
    --- region utils
    do

            local js = panorama_loadstring [[
                const MONTH_NAMES = [
                    "January", "February", "March",
                    "April", "May", "June",
                    "July", "August", "September",
                    "October", "November", "December"
                ];
        
                return {
                    new_date(timestamp) {
                        return new Date(timestamp);
                    },
        
                    get_month_name(month) {
                        return MONTH_NAMES[month];
                    }
                }
            ]]();
        
            function utils.is_odd(x)
                return bit.band(x, 1) ~= 0;
            end
        
            function utils.to_hex(r, g, b, a)
                return string.format("%02x%02x%02x%02x", r, g, b, a);
            end
        
            function utils.from_hex(hex)
                hex = string.gsub(hex, "#", "");
        
                local r = tonumber(string.sub(hex, 1, 2), 16);
                local g = tonumber(string.sub(hex, 3, 4), 16);
                local b = tonumber(string.sub(hex, 5, 6), 16);
                local a = tonumber(string.sub(hex, 7, 8), 16);
        
                return r, g, b, a or 255;
            end
        
            function utils.normalize(x, min, max)
                local delta = max - min;
        
                while x < min do
                    x = x + delta;
                end
        
                while x > max do
                    x = x - delta;
                end
        
                return x;
            end
        
            function utils.normalize_yaw(x)
                return utils.normalize(x, -180, 180);
            end
        
            function utils.new_date(timestamp)
                return js.new_date(timestamp);
            end
          
    end

local decorations = { };

--- region decorations
do
    local tohex = utils.to_hex;
    local HALF_PI = math.pi / 2;


        function decorations.wave(s, clock, r1, g1, b1, a1, r2, g2, b2, a2)
            local buffer = { };

            local len = string.len(u8(s));
            local div = 1 / (len - 1);

            local add_r = r2 - r1;
            local add_g = g2 - g1;
            local add_b = b2 - b1;
            local add_a = a2 - a1;

            for char in string.gmatch(s, ".[\128-\191]*") do
                local t = clock; do
                    t = t % 2;

                    if t > 1 then
                        t = 2 - t;
                    end
                end

                local r = r1 + add_r * t;
                local g = g1 + add_g * t;
                local b = b1 + add_b * t;
                local a = a1 + add_a * t;

                buffer[#buffer + 1] = "\a";
                buffer[#buffer + 1] = tohex(r, g, b, a);
                buffer[#buffer + 1] = char;

                clock = clock + div;
            end

            return merge(buffer);
        end

        function decorations.fade(s, pct, r1, g1, b1, a1, r2, g2, b2, a2)
            local buffer = { };

            local len = string.len(u8(s));
            local div = 1 / (len - 1);

            local add_r = r2 - r1;
            local add_g = g2 - g1;
            local add_b = b2 - b1;
            local add_a = a2 - a1;

            local clock = 0;
            local transform = math.sin;

            if pct < 0 then
                transform = cosf;
                pct = pct + 1;
            end

            if pct == 0 then
                return merge { "\a", utils.to_hex(r2, g2, b2, a2), s };
            end

            if pct == 1 then
                return merge { "\a", utils.to_hex(r1, g1, b1, a1), s };
            end

            for char in string.gmatch(s, ".[\128-\191]*") do
                local t = transform(HALF_PI * (1 - clock * pct) * (1 - pct * pct));

                local r = r1 + add_r * t;
                local g = g1 + add_g * t;
                local b = b1 + add_b * t;
                local a = a1 + add_a * t;

                buffer[#buffer + 1] = "\a";
                buffer[#buffer + 1] = tohex(r, g, b, a);
                buffer[#buffer + 1] = char;

                clock = clock + div;
            end

            return merge(buffer);
        end
end


local icons1 = {
    main = nil,
    miss = nil
}

local icons4 = {}


http.get('https://i.imgur.com/1kpDb7F.png', function(s, r)
    if s and r.status == 200 then
        icons1.main = l_images.load(r.body)
    end
end)


local f = string.format

local defines = {
    user = username,
    build = build,

    dev = build == 'source',

    screen = vector(client.screen_size()),
    screen_center = vector(client.screen_size()) / 2,

    accent = { 192, 168, 255, 255 },

    conditions = { 'Global', 'Stand', 'Move', 'Slow Walk', 'Air', 'Aero + Crouch', 'Crouch', "Fake Lag" },

    functions = {
        legit = false,
        manual = false,
        backstab = false,
        safe = false
    }
}

local db do
    db = { }

    setmetatable(db, {
        __index = function (self, key)
            return database.read(key)
        end,

        __newindex = function (self, key, value)
            return database.write(key, value)
        end
    })
end


    local utilities do
        utilities = { }
        
    
        function utilities.contains(tbl, key)
            local state = false
            for i, item in next, tbl do
                if item == key then
                    state = true
                    break
                end
            end
    
            return state
        end
    
        function utilities.normalize(yaw)
            return (yaw + 180) % -360 + 180
        end
    
        local sv_gravity = cvar.sv_gravity
        function utilities.extrapolate(ent, pos)
            local tick_interval = globals.tickinterval()
    
            local velocity = vector(entity.get_prop(ent, "m_vecVelocity"))
            local new_pos = pos:clone()
    
            local ticks = 16
            if #velocity < 32 then
                ticks = 32
            end
    
            new_pos.x = new_pos.x + velocity.x * tick_interval * ticks
            new_pos.y = new_pos.y + velocity.y * tick_interval * ticks
    
            if entity.get_prop(ent, "m_hGroundEntity") == nil then
                new_pos.z = new_pos.z + velocity.z * tick_interval * ticks - sv_gravity:get_float() * tick_interval
            end
    
            return new_pos
        end
    
        function utilities.lerp(a, b, t)
            return a + t * (b - a)
        end
    
        function utilities.extended_lerp(start, end_pos, time, delta)
            if math.abs(start - end_pos) < (delta or 0.01) then
                return end_pos
            end
    
            time = globals.frametime() * (time * 175)
            if time < 0 then
                time = 0.01
            elseif time > 1 then
                time = 1
            end
    
            return (end_pos - start) * time + start
        end
    
        function utilities.color_lerp(r1, g1, b1, a1, r2, g2, b2, a2, t)
            local r = utilities.lerp(r1, r2, t)
            local g = utilities.lerp(g1, g2, t)
            local b = utilities.lerp(b1, b2, t)
            local a = utilities.lerp(a1, a2, t)
    
            return r, g, b, a
        end
    
        function utilities.strip(str)
            while str:sub(1, 1) == ' ' do
                str = str:sub(2)
            end
    
            while str:sub(#str, #str) == ' ' do
                str = str:sub(1, #str - 1)
            end
    
            if #str == 0 or str == '' then
                str = string.format('%s ~ %s', defines.user, 'Config')
            end
    
            return str
        end
    
        function utilities.get_eye_position(ent)
            local x1, y1, z1 = entity.get_origin(ent)
            if x1 == nil then return end
    
            local x2, y2, z2 = entity.get_prop(ent, "m_vecViewOffset")
            if x2 == nil then return end
    
            return x1 + x2, y1 + y2, z1 + z2
        end
    
        function utilities.clamp(value, min, max)
            if value < min then
                return min
            elseif value > max then
                return max
            else
                return value
            end
        end
    
        function utilities.breathe(offset, multiplier)
            local speed = globals.realtime() * (multiplier or 1.0)
            local factor = speed % math.pi
    
            local sin = math.sin(factor + (offset or 0))
            local abs = math.abs(sin)
    
            return abs
        end
    
        function utilities.table_convert(tbl)
            if tbl == nil then
                return { }
            end
    
            local final = { }
    
            for i = 1, #tbl do
                final[ tbl[i] ] = true
            end
    
            return final
        end
    
        function utilities.table_invert(tbl)
            if tbl == nil then
                return { }
            end
    
            local final = { }
    
            for name, enabled in next, tbl do
                if enabled then
                    final[ #final + 1 ] = name
                end
            end
    
            return final
        end
    
        function utilities.to_hex(r, g, b, a)
            return f('%02x%02x%02x%02x', r, g, b, a or 255)
        end
    
        function utilities.to_rgb(hex)
            hex = hex:gsub('#', '')
            return tonumber('0x' .. hex:sub(1, 2)), tonumber('0x' .. hex:sub(3, 4)), tonumber('0x' .. hex:sub(5, 6))
        end
    
        function utilities.format(str, r, g, b, a)
            if type(str) ~= 'string' then
                return str
            end
    
            str = string.gsub(str, '[\v\r\f]', {
                ['\v'] = r and '\a' .. utilities.to_hex(r, g, b, a) or '\a' .. pui.accent,
                ['\r'] = r and '\aFFFFFFFF' or '\aCDCDCDFF',
                ['\f'] = '\aFF5065FF'
            })
    
            return str
        end
    
        function utilities.gradient(str, r, g, b, a, r1, g1, b1, a1, speed)
            local i = 0
            local n = 1 / (#str:gsub('[\128-\191]', '') - 1)
    
            local out = str:gsub('(.[\128-\191]*)', function(char)
                local factor = utilities.breathe(i, speed)
                local r, g, b, a = utilities.color_lerp(r, g, b, a, r1, g1, b1, a1, factor)
    
                i = i + n
                return f('\a%s%s', utilities.to_hex(r, g, b, a), char)
            end)
    
            return out
        end
    
        function utilities.clean_up(str)
            local text = str:gsub('(\a%x%x%x%x%x%x)%x%x', '%1')
            return text
        end
    
        function utilities.alpha_modulate(str, alpha)
            local result = string.gsub(str, '\a(%x%x%x%x%x%x)(%x%x)', function(rgb, a)
                return f('\a%s%02x', rgb, tonumber(a, 16) * alpha)
            end)
    
            return result
        end
    end
    
    local printc do
        printc = function (...)
            for i, v in ipairs{...} do
                local r = '\aD9D9D9' .. v
                for col, text in r:gmatch('\a(%x%x%x%x%x%x)([^\a]*)') do
                    local r, g, b = utilities.to_rgb(col)
                    client.color_log(r, g, b, string.format('%s\0', text))
                end
                client.color_log(255, 255, 255, '\n\0')
            end
        end
    end
    
    local print_format do
        print_format = function (...)
            return printc(utilities.clean_up(utilities.format(f(...))))
        end
    end
    
    local lp_info do
        lp_info = {
            flags = 0,
            movetype = 0,
            velocity = 0,
            air = false,
            is_moving = false,
            on_ground = false,
            ducking = false,
            landing = false,
            choking = 1,
            body_yaw = 0,
            inverted = false,
            chokes = 0,
            condition = 'Stand'
        }
    end
    
    local main_funcs = {
        delay_air = 0,
        in_air = function(self)
            local ent = entity_get_local_player()
            local flag = bit.band(entity.get_prop(entity_get_local_player(), "m_fFlags"), 1)
            if flag == 1 then
                if self.delay_air < 15 then
                self.delay_air = self.delay_air + 1
                end
            else
                self.delay_air = 0
            end 
            return flag == 0 or self.delay_air < 15
        end,
        clamp = function(_, value, minimum, maximum)
            return math.min( math.max( value, minimum ), maximum )
        end,
        lerp = function(self, delta, from, to)
            if from == nil then from = 0 end
            if ( delta > 1 ) then return to end
            if ( delta < 0 ) then return from end
            return from + ( to - from ) * delta
        end,
        smooth_lerp = function(self, time, s, e, no_rounding) 
            if (math.abs(s - e) < 1 or s == e) and not no_rounding then return e end
            local time = self:clamp(globals_frametime() * time * 165, 0.01, 1.0) 
            local value = self:lerp(time, s, e)
            return value 
        end,
        last_sim_time = 0,
        def = 0,
        blocked_types = {
            ["knife"] = true,
            ["c4"] = true,
            ["grenade"] = true,
            ["taser"] = true
        },
        get_weapon_index = function(player)
            local wpn = entity_get_player_weapon(player)
            if wpn == nil then return end
            return entity.get_prop(wpn, "m_iItemDefinitionIndex")
        end,
        get_weapon_struct = function(player)
            local wpn = entity_get_player_weapon(player)
            if wpn == nil then return end
            local wep = weapons[entity.get_prop(wpn, "m_iItemDefinitionIndex")]
            if wep == nil then return end
            return wep
        end,

        is_freezetime = function()
            return entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod") == 1
        end,
        defensive_state = function(self, delay, entity)
            delay = delay or 0
            local ent = entity_get_local_player()
            if entity == nil and not entity_is_alive(ent) or not ui.get(reference.RAGE.double_tap[2]) or not entity_is_alive(ent) then return end
            ent = entity ~= nil and entity or ent
            local tickcount = globals.tickcount()
            local sim_time = toticks(entity_get_prop(ent, "m_flSimulationTime"))

            local diff = sim_time - self.last_sim_time
            if diff < 0 then
                self.def = tickcount + math.abs(diff) - toticks(client.latency())
            end
            self.last_sim_time = sim_time
            if delay <= -6 then return not self:is_freezetime() and not self.blocked_types[self.get_weapon_struct(ent).type] end
            local extra_check = entity ~= nil and true or (not self:is_freezetime() and not self.blocked_types[self.get_weapon_struct(ent).type])
            return self.def > tickcount + delay and extra_check
        end,
        rgba_to_hex = function(b, c, d, e) e = e or 255 return string.format('%02x%02x%02x%02x', b, c, d, e) end,
        hex_to_rgba = function(hex) return tonumber('0x' .. hex:sub(1, 2)), tonumber('0x' .. hex:sub(3, 4)), tonumber('0x' .. hex:sub(5, 6)), tonumber('0x' .. hex:sub(7, 8)) or 255 end,
        text_animation = function(self, speed, color1, color2, text)
            local final_text = ''
            local curtime = globals_curtime()
            for i = 0, #text do
                local x = i * 10  
                local wave = math_cos(2 * speed * curtime / 4 + x / 30)
                local color = self.rgba_to_hex(
                    self:lerp(self:clamp(wave, 0, 1), color1[1], color2[1]),
                    self:lerp(self:clamp(wave, 0, 1), color1[2], color2[2]),
                    self:lerp(self:clamp(wave, 0, 1), color1[3], color2[3]),
                    color1[4]
                ) 
                final_text = final_text .. '\a' .. color .. text:sub(i, i) 
            end
            
            return final_text
        end,
        color_log = function(self, str)  
            for color_code, message in str:gmatch("(%x%x%x%x%x%x%x%x)([^\aFFFFFFFF]+)") do
                local r, g, b = self.hex_to_rgba(color_code)
                message = message:gsub("\a" .. color_code, "")
    
                client.color_log(r, g, b, message .. "\0")
            end
            client.color_log(255, 255, 255, " ")
        end,
        rectangle_outline = function(x, y, w, h, r, g, b, a, s)
            renderer_rectangle(x, y, w, s, r, g, b, a)
            renderer_rectangle(x, y+h-s, w, s, r, g, b, a)
            renderer_rectangle(x, y+s, s, h-s*2, r, g, b, a)
            renderer_rectangle(x+w-s, y+s, s, h-s*2, r, g, b, a)
        end,
        rounded_rectangle = function(x, y, w, h, r, g, b, a, radius, side)
            y = y + radius
            local data_circle = {
                {x + radius, y, 180},
                side and {} or {x + w - radius, y, 90},
                {x + radius, y + h - radius * 2, 270},
                side and {} or {x + w - radius, y + h - radius * 2, 0},
            }
        
            local data = {
                {x + radius, y, w - radius * 2, h - radius * 2},
                {x + radius, y - radius, w - radius * 2, radius},
                {x + radius, y + h - radius * 2, w - radius * 2, radius},
                {x, y, radius, h - radius * 2},
                side and {} or {x + w - radius, y, radius, h - radius * 2},
            }
        
            for _, data in next, data_circle do
                if data ~= nil then
                renderer_circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
                end
            end
    
            for _, data in next, data do
                if data ~= nil then
                renderer_rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
                end
            end
        end,

    }

    local rounding = 4
    local o = 20
    local rad = rounding + 2
    local n = 45

    local RoundedRect = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+radius,y,w-radius*2,radius,r,g,b,a)renderer.rectangle(x,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)renderer.rectangle(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)renderer.circle(x+radius,y+radius,r,g,b,a,radius,180,0.25)renderer.circle(x+w-radius,y+radius,r,g,b,a,radius,90,0.25)renderer.circle(x+radius,y+h-radius,r,g,b,a,radius,270,0.25)renderer.circle(x+w-radius,y+h-radius,r,g,b,a,radius,0,0.25) end
    local OutlineGlow = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+2,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+w-3,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+radius+rad,y+2,w-rad*2-radius*2,1,r,g,b,a)renderer.rectangle(x+radius+rad,y+h-3,w-rad*2-radius*2,1,r,g,b,a)renderer.circle_outline(x+radius+rad,y+radius+rad,r,g,b,a,radius+rounding,180,0.25,1)renderer.circle_outline(x+w-radius-rad,y+radius+rad,r,g,b,a,radius+rounding,270,0.25,1)renderer.circle_outline(x+radius+rad,y+h-radius-rad,r,g,b,a,radius+rounding,90,0.25,1)renderer.circle_outline(x+w-radius-rad,y+h-radius-rad,r,g,b,a,radius+rounding,0,0.25,1) end
    local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) local n=a/255*n;renderer.rectangle(x+radius,y,w-radius*2,1,r,g,b,n)renderer.circle_outline(x+radius,y+radius,r,g,b,n,radius,180,0.25,1)renderer.circle_outline(x+w-radius,y+radius,r,g,b,n,radius,270,0.25,1)renderer.rectangle(x,y+radius,1,h-radius*2,r,g,b,n)renderer.rectangle(x+w-1,y+radius,1,h-radius*2,r,g,b,n)renderer.circle_outline(x+radius,y+h-radius,r,g,b,n,radius,90,0.25,1)renderer.circle_outline(x+w-radius,y+h-radius,r,g,b,n,radius,0,0.25,1)renderer.rectangle(x+radius,y+h-1,w-radius*2,1,r,g,b,n) for radius=4,glow do local radius=radius/2;OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r1,g1,b1,glow-radius*2)end end
    
    local container_glow = function(x, y, w, h, r, g, b, a, alpha,r1, g1, b1, fn) if alpha*255>0 then renderer.blur(x,y,w,h)end;RoundedRect(x,y,w,h,rounding,17,17,17,a)FadedRoundedGlow(x,y,w,h,rounding,r,g,b,alpha*255,alpha*o,r1,g1,b1)if not fn then return end;fn(x+rounding,y+rounding,w-rounding*2,h-rounding*2.0) end


    local clipboard do
        clipboard = { }
    
        local GetClipboardTextCount = vtable_bind('vgui2.dll', 'VGUI_System010', 7, 'int(__thiscall*)(void*)')
        local SetClipboardText = vtable_bind('vgui2.dll', 'VGUI_System010', 9, 'void(__thiscall*)(void*, const char*, int)')
        local GetClipboardText = vtable_bind('vgui2.dll', 'VGUI_System010', 11, 'int(__thiscall*)(void*, int, const char*, int)')
    
        local function set(...)
            local text = tostring(table.concat({ ... }))
    
            SetClipboardText(text, string.len(text))
        end
    
        local function get()
            local len = GetClipboardTextCount()
    
            if len > 0 then
                local char_arr = ffi.typeof('char[?]')(len)
                GetClipboardText(0, char_arr, len)
                local text = ffi.string(char_arr, len - 1)
    
                local text_end do
                    text_end = text:find('_astra')
    
                    if text_end then
                        text = text:sub(1, text_end)
                    end
                end
    
                return text
            end
        end
    
        clipboard.set = set
        clipboard.get = get
    end
    
    local callbacks do
        callbacks = { }
        callbacks.DEV_MODE = defines.dev
    
        local stored_data = { }
        local function set_callback_data(callback)
            if stored_data[callback] == nil then
                stored_data[callback] = {
                    local_player = nil,
                    is_valid = nil
                }
    
                client.set_event_callback(callback, function (ctx)
                    local this = stored_data[callback]
    
                    this.local_player = entity.get_local_player()
                    this.is_valid = this.local_player ~= nil and entity.is_alive(this.local_player)
                end)
    
                return stored_data[callback]
            end
    
            return stored_data[callback]
        end
    
        local events_mt = {
            __index = function (self, index)
    
                local methods = {
                    set = function (_self, fun)
                        local data = set_callback_data(index)
    
                        local callback
                        if not callbacks.DEV_MODE then
                            callback = function (ctx)
                                local status, result
    
                                if ctx == nil then
                                    status, result = pcall(fun, data.local_player, data.is_valid)
                                else
                                    status, result = pcall(fun, ctx, data.local_player, data.is_valid)
                                end
    
                                return result
                            end
                        else
                            callback = function (ctx)
                                if ctx == nil then
                                    return fun(data.local_player, data.is_valid)
                                else
                                    return fun(ctx, data.local_player, data.is_valid)
                                end
                            end
                        end
    
                        client.set_event_callback(index, callback)
                    end
                }
    
                return methods
            end,
    
            __tostring = function (self)
                return self.name
            end
        }
    
        local data = { }
        local function get_callback(name)
            if data[name] == nil then
                data[name] = setmetatable({ name = name }, events_mt)
            end
    
            return data[name]
        end
    
        local mt = {
            __index = function (self, name)
                return get_callback(name)
            end
        }
    
        setmetatable(callbacks, mt)
    end

    
    local anti_aim do
        anti_aim = { }
        local all = { }
    
        local references = reference.AA.angles
    
        local override_values = { }
        local push_refs = { } do
            for name, ref in next, references do
                local is_table = type(ref) == 'table'
    
                push_refs[name] = is_table
    
                if is_table then
                    override_values[name] = { }
    
                    for subname, _ in next, ref  do
                        override_values[name][subname] = { 0, -1 }
                    end
                else
                    override_values[name] = { 0, -1 }
                end
            end
        end
    
        local highest_layer_overriden = -1
    
        local methods = {
            run = function (self)
                highest_layer_overriden = math.max(self.layer, highest_layer_overriden)
    
                for name, value in next, self.overrides do
                    local this = override_values[name]
    
                    if push_refs[name] then
                        for subname, subvalue in next, value do
                            if subname ~= '__mt' then
                                if this[subname][2] <= self.layer then
                                    this[subname][1] = subvalue
                                    this[subname][2] = self.layer
                                end
                            end
                        end
                    else
                        this[1] = value
                        this[2] = self.layer
                    end
                end
            end,
    
            tick = function (self)
                self.overrides = { }
            end
        }
    
        local mt = { }
        mt.__newindex = function (self, idx, value)
            if push_refs[idx] ~= nil then
                if not push_refs[idx] then
                    self.overrides[idx] = value
                end
            else
                print('[Anti Aim] Failed to index', idx)
            end
        end
    
        mt.__index = function (self, idx)
            if methods[idx] then
                return methods[idx]
            end
    
            if push_refs[idx] ~= nil then
                if push_refs[idx] then
                    if self.overrides[idx] == nil then
                        self.overrides[idx] = { }
    
                        self.overrides[idx].__mt = setmetatable({ }, {
                            __newindex = function (_, i, value)
                                self.overrides[idx][i] = value
                            end
                        })
                    end
    
                    return self.overrides[idx].__mt
                end
            else
                print('[Anti Aim] Failed to index', idx)
            end
        end
    
        local used_layers = { }
        function anti_aim.new(name, layer)
            assert(all[name] == nil, 'aa name already used')
            assert(used_layers[layer] == nil, 'aa layer already used')
    
            used_layers[layer] = true
    
            all[name] = {
                name  = name,
                layer = layer,
    
                overrides = { }
            }
    
            return setmetatable(all[name], mt)
        end

    function anti_aim.on_cm()
        for name, reference in next, references do
            if type(reference) == 'table' then
                for subname, subreference in next, reference do
                    --subreference:override()
                end
            else
                reference:override()
            end
        end

        for name, override in next, override_values do
            if push_refs[name] then
                for subname, suboverride in next, override do
                    if suboverride[2] ~= -1 then
                        references[name][subname]:override(suboverride[1])
                        suboverride[2] = -1
                    else
                        references[name][subname]:override()
                    end
                end
            else
                if override[2] ~= -1 then
                    references[name]:override(override[1])
                    override[2] = -1
                else
                    references[name]:override()
                end
            end
        end

        highest_layer_overriden = -1
    end

    function anti_aim.condition(ignore_fl)
        local is_duck = lp_info.ducking or reference.RAGE.fakeduck:get()

        local fakelag = ignore_fl and not (ui.get(reference.RAGE.double_tap[2]) or ui.get(reference.RAGE.hide_shots[2]))

        if fakelag then
            return defines.conditions[ 8 ]
        end

        if lp_info.air then
            return defines.conditions [ is_duck and 6 or 5 ]
        end

        if is_duck then
            return defines.conditions[ 7 ]
        end

        if lp_info.velocity > 2 then
            return defines.conditions[ reference.is_slowwalk() and 4 or 3 ]
        end

        return defines.conditions[ 2 ]
    end
end

local tweening do
    tweening = { }

    local native_GetTimescale = vtable_bind('engine.dll', 'VEngineClient014', 91, 'float(__thiscall*)(void*)')

    local function solve(easings_fn, prev, new, clock, duration)
        local prev = easings_fn(clock, prev, new - prev, duration)

        if type(prev) == 'number' then
            if math.abs(new - prev) <= .01 then
                return new
            end

            local fmod = prev % 1

            if fmod < .001 then
                return math.floor(prev)
            end

            if fmod > .999 then
                return math.ceil(prev)
            end
        end

        return prev
    end

    local mt = { } do
        local function update(self, duration, target, easings_fn)
            local value_type = type(self.value)
            local target_type = type(target)

            if target_type == 'boolean' then
                target = target and 1 or 0
                target_type = 'number'
            end

            assert(value_type == target_type, string.format('type mismatch, expected %s (received %s)', value_type, target_type))

            if target ~= self.to then
                self.clock = 0

                self.from = self.value
                self.to = target
            end

            local clock = globals.frametime() / native_GetTimescale()
            local duration = duration or .15

            if self.clock == duration then
                return target
            end

            if clock <= 0 and clock >= duration then
                self.clock = 0

                self.from = target
                self.to = target

                self.value = target

                return target
            end

            self.clock = math.min(self.clock + clock, duration)
            self.value = solve(easings_fn or self.easings, self.from, self.to, self.clock, duration)

            return self.value
        end

        mt.__metatable = false
        mt.__call = update
        mt.__index = mt
    end

    function tweening.new(default, easings_fn)
        if type(default) == 'boolean' then
            default = default and 1 or 0
        end

        local this = { }

        this.clock = 0
        this.value = default or 0

        this.easings = easings_fn or function(t, b, c, d)
            return c * t / d + b
        end

        return setmetatable(this, mt)
    end
end

local exploit do
    exploit = { }

    local LAG_COMPENSATION_TELEPORTED_DISTANCE_SQR = 64 * 64

    local data = {
        old_origin = vector(),
        old_simtime = 0.0,

        shift = false,
        breaking_lc = false,
        defensive_tick = 0,

        defensive = {
            begin = 0,
            duration = 0
        },

        lagcompensation = {
            distance = 0.0,
            teleport = false
        }
    }

    local function update_tickbase(me)
        local tickcount = globals.tickcount()
        local m_nTickBase = entity.get_prop(me, "m_nTickBase")

        data.shift = tickcount > m_nTickBase
    end

    local function update_defensive(tick)
        data.breaking_lc = true

        data.defensive.begin = globals.tickcount()
        data.defensive.duration = tick
    end

    local function update_teleport(old_origin, new_origin)
        local delta = new_origin - old_origin
        local distance = delta:lengthsqr()

        local is_teleport = distance > LAG_COMPENSATION_TELEPORTED_DISTANCE_SQR

        data.breaking_lc = is_teleport

        data.lagcompensation.distance = distance
        data.lagcompensation.teleport = is_teleport
    end

    local function update_lagcompensation(me)
        local old_origin = data.old_origin
        local old_simtime = data.old_simtime

        local origin = vector(entity.get_origin(me))
        local simtime = toticks(entity.get_prop(me, 'm_flSimulationTime'))

        if old_simtime ~= nil then
            local delta = simtime - old_simtime

            if delta < 0 or delta > 0 and delta <= 64 then
                local tick = delta - 1

                update_teleport(old_origin, origin)

                if delta < 0 then
                    update_defensive(math.abs(tick))
                end
            end
        end

        data.old_origin = origin
        data.old_simtime = simtime
    end

    function exploit.get()
        return data
    end

    function exploit.setup_command(cmd, me)
        update_tickbase(me)
    end

    function exploit.net_update(me)
        if me == nil then
            return
        end

       update_lagcompensation(me)
    end

    local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')

    function exploit.update_defensive(lp)
        if lp == nil then
            return
        end

        local ent = native_GetClientEntity(lp)
        local old_simtime = ffi.cast('float*', ffi.cast('uintptr_t', ent) + 0x26C)[0]
        local simtime = entity.get_prop(lp, 'm_flSimulationTime')

        local delta = old_simtime - simtime

        if delta > 0 then
            data.defensive_tick = globals.tickcount() + toticks(delta - client.real_latency())
            return
        end
    end

    callbacks['Exploits']['net_update_end']:set(function (lp, valid)
        exploit.net_update(lp)
        exploit.update_defensive(lp)
    end)
end

local easings do
    easings = { }

    function easings.outQuad(t, b, c, d)
        t = t / d
        return -c * t * (t - 2) + b
    end

    function easings.outCirc(t, b, c, d)
        t = t / d - 1
        return (c * math.sqrt(1 - math.pow(t, 2)) + b)
    end
end

local vars = { }
    do
        pui.macros.dot = '\v•  \r'
    
        local ui_group = pui.group('AA', 'Anti-aimbot angles')
        local group = pui.group('AA', 'Anti-aimbot angles')
    
        local selection do
            vars.selection = { }
    
            vars.selection.label = ui_group:label(string.format('A S T R A', defines.user, defines.build))
            vars.selection.label2 = ui_group:label(string.format('A S T R A', defines.user, defines.build))
            vars.selection.label23 = ui_group:label(string.format('\n', defines.user, defines.build))
    
            vars.selection.tab = ui_group:combobox('\f<dot>Sele\vctor', {'Anti Aim', 'Visuals', 'Misc', 'Configs' }, false, false)
            vars.selection.aa_tab = ui_group:combobox('\nAA Tab', { 'Builder', 'Keybinds', "Defensive Builder", "Other" }, false, false):depend({ vars.selection.tab, 'Anti Aim' })
    
        end
    
        local rage do
            vars.rage = { }
    
        end
    
        local antiaim do
            vars.aa = { }
    
            vars.aa_binds = { }
            do
                vars.aa_binds.manual = { }
                vars.aa_binds.manual.enable = group:checkbox("\f<dot>Key\vbinds"):depend({ vars.selection.tab, 'Anti Aim' },  vars.aa_binds.manual.enable, { vars.selection.aa_tab, 'Keybinds' })
                vars.aa_binds.manual.left = group:hotkey('\f<dot>Manual \vleft'):depend({ vars.selection.tab, 'Anti Aim' },  vars.aa_binds.manual.enable, { vars.selection.aa_tab, 'Keybinds' })
                vars.aa_binds.manual.right = group:hotkey('\f<dot>Manual \vright'):depend({ vars.selection.tab, 'Anti Aim' },  vars.aa_binds.manual.enable, { vars.selection.aa_tab, 'Keybinds' })
                vars.aa_binds.manual.forward = group:hotkey('\f<dot>Manual f\vorward'):depend({ vars.selection.tab, 'Anti Aim' },  vars.aa_binds.manual.enable, { vars.selection.aa_tab, 'Keybinds' })
                vars.aa_binds.manual.reset = group:hotkey('\f<dot>Manual \vreset'):depend({ vars.selection.tab, 'Anti Aim' },  vars.aa_binds.manual.enable, { vars.selection.aa_tab, 'Keybinds' })
            end
    
            do
                vars.aa.freestanding = { }
    
                vars.aa.freestanding.main = group:hotkey('\f<dot>Freest\vanding'):depend({ vars.selection.tab, 'Anti Aim' },  vars.aa_binds.manual.enable, { vars.selection.aa_tab, 'Keybinds' })
    
                vars.aa.freestanding.disablers = group:multiselect('\f<dot>Disablers', { 'Stand', 'Move', 'Slow Walk', 'Air', 'Aero + Crouch', 'Crouch' }):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Keybinds' }, vars.aa_binds.manual.enable)
            end
    
            do
                vars.aa.defensive = { }
                vars.aa.defensive.main = group:checkbox('\f<dot>Enable \vDefensive'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Defensive Builder' })
    
                vars.aa.defensive.conditions = group:multiselect('\f<dot>Defensive \vConditions', { 'Stand', 'Move', 'Slow Walk', 'Air', 'Aero + Crouch', 'Crouch', 'On Peek' }):depend(vars.aa.defensive.main, { vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Defensive Builder' })
                vars.aa.defensive.pitch = group:combobox('\f<dot>Defensive \vPitch', { 'Default', 'Zero', 'Up', 'Pitch Swap', 'Random' }):depend(vars.aa.defensive.main, { vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Defensive Builder' })
                vars.aa.defensive.yaw = group:combobox('\f<dot>Defensive \vYaw', { 'Force Defensive', 'Default', 'Sideways', 'Spin', 'Random' }):depend(vars.aa.defensive.main, { vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Defensive Builder' })
    
            end
    
            vars.aa.backstab = group:checkbox('\f<dot>Anti Backstab'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Other' })
            vars.aa.safe = group:multiselect('\f<dot>Safe Head \vConditions', {'Knife', 'Zeus' }):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Other' })
        end
    
        local angles do
            vars.angles = { }
    
            vars.angles.condition = group:combobox('\vAnti-Aim \rState', defines.conditions):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' })
    
        end
    
        local conditions do
            vars.conditions = { }
    
            for idx, condition in next, defines.conditions do
                vars.conditions[ condition ] = { }
    
                if condition ~= defines.conditions[ 1 ] then
                    vars.conditions[ condition ].enabled = group:checkbox(f('\vOverride \r' .. condition .. " \vState", condition))
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition })
                end
    
                do
                    vars.conditions[ condition ].pitch = group:combobox(f("\v" .. condition .. ' \rPitch \n%s', condition), { 'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random', 'Custom' })
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].pitch_value = group:slider(f('\nPitch Value %s', condition), -89, 89, 0, true, '°')
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition }, { vars.conditions[ condition ].pitch, 'Custom' }, vars.conditions[ condition ].enabled)
                end
    
                do
                    vars.conditions[ condition ].yaw_base = group:combobox(f("\v" .. condition .. ' \rYaw Base \n%s', condition), { 'Local view', 'At targets' })
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition }, vars.conditions[ condition ].enabled)
                end
    
                do
                    vars.conditions[ condition ].yaw = group:combobox(f("\v" .. condition .. ' \rYaw \n%s', condition), { 'Off', 'L & R', '180', 'Spin', 'Static', '180 Z', 'Crosshair'})
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].yaw_offset = group:slider(f('\nYaw Offset %s', condition), -180, 180, 0, true, '°')
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, '180', 'Spin', 'Static', '180 Z', 'Crosshair' }, vars.conditions[ condition ].enabled)
    
    
                    vars.conditions[ condition ].yaw_left = group:slider(f("\v" .. condition .. ' \f<dot>Left Offset \n%s', condition), -180, 180, 0, true, '°')
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'L & R' }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].yaw_right = group:slider(f("\v" .. condition .. ' \f<dot>Right Offset \n%s', condition), -180, 180, 0, true, '°')
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'L & R' }, vars.conditions[ condition ].enabled)

                    vars.conditions[ condition ].multikulti = group:combobox(f("\v" .. condition .. ' \rExtra \n%s', condition), { 'Off', 'Delayed'})
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'L & R' }, vars.conditions[ condition ].enabled)
                    
                    vars.conditions[ condition ].yaw_delay = group:slider(f('\n\f<dot>Delay \n%s', condition), 1, 10, 5, true, 't')
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'L & R' }, {vars.conditions[ condition ].multikulti, "Delayed"}, vars.conditions[ condition ].enabled)
                end

    
                do
                    vars.conditions[ condition ].yaw_modifier = group:combobox(f("\v" .. condition .. ' \rYaw Modifier \n%s', condition), { 'Off', 'Offset', 'Center', 'Random', 'Skitter' })
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'Off', true }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].yaw_modifier_offset = group:slider(f('\nModifier Offset \n%s', condition), -180, 180, 0, true, '°')
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'Off', true }, { vars.conditions[ condition ].yaw_modifier, 'Off', true }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].yaw_modifier_randomize = group:slider(f("\v" .. condition .. ' \r\f<dot>Randomize Jitter \n%s', condition), 0, 180, 0, true, '°', 1, { [0] = 'Off' })
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition }, { vars.conditions[ condition ].yaw, 'Off', true }, { vars.conditions[ condition ].yaw_modifier, 'Off', true }, vars.conditions[ condition ].enabled)
                end
    
                do
                    vars.conditions[ condition ].body_yaw = group:combobox(f("\v" .. condition .. ' \rBody Yaw \n%s', condition), { 'Off', 'Opposite', 'Jitter', 'Static' })
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition }, vars.conditions[ condition ].enabled)
    
                    vars.conditions[ condition ].body_yaw_offset = group:slider(f('\nBody Yaw Offset \n%s', condition), -180, 180, 0, true, '°')
                    :depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builder' },  { vars.angles.condition, condition }, { vars.conditions[ condition ].body_yaw, 'Jitter', 'Static' }, vars.conditions[ condition ].enabled)
                end
    
                vars.conditions[ condition ].freestanding = group:checkbox(f("\v" .. condition .. ' \rFreestanding Body Yaw \n%s', condition))
                :depend({ vars.selection.tab, 'Anti Aims' }, { vars.selection.aa_tab, 'Builders' },  { vars.angles.condition, condition }, { vars.conditions[ condition ].body_yaw, 'Offs', true }, vars.conditions[ condition ].enabled)
            end
    
            vars.angles.copy = group:button('Export'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builders' })
            vars.angles.import = group:button('Import'):depend({ vars.selection.tab, 'Anti Aim' }, { vars.selection.aa_tab, 'Builders' })
            
            vars.angles.copy:set_enabled(defines.dev)
            vars.angles.import:set_enabled(defines.dev)
        end
        
        
    
        local visuals do
            vars.visuals = { }
    
            vars.visuals.indicators = group:checkbox('\f<dot>Crosshair \vIndicators'):depend({ vars.selection.tab, 'Visuals' })
            vars.visuals.indicators_style = group:combobox('\f<dot>Style', { 'Disabled', 'Default', 'New' }):depend({ vars.selection.tab, 'Visuals' },vars.visuals.indicators)
            vars.visuals.indicators_color = group:label('\f<dot>Indicators Color', defines.accent):depend({ vars.selection.tab, 'Visuals' }, vars.visuals.indicators)
            vars.visuals.indicators.odstep2 = group:label('\n' ):depend({ vars.selection.tab, 'Visuals' }, vars.visuals.indicators)


            
            do
                vars.rage.logger = { }
    
                vars.rage.logger.main = group:checkbox('\f<dot>Screen \vLogs'):depend({ vars.selection.tab, 'Visuals' })
                vars.rage.logger.events = group:multiselect('\f<dot>Events', { 'Aimbot Shots', 'Damage Dealt', 'Purchases' }):depend({ vars.selection.tab, 'Visuals' }, vars.rage.logger.main)
                vars.rage.logger.output = group:multiselect('\f<dot>Output', { 'Screen' }):depend({ vars.selection.tab, 'Visuals' }, vars.rage.logger.main)
                vars.rage.logger.hit = group:label('\f<dot>Hit Color', { 182, 231, 23, 255 }):depend({ vars.selection.tab, 'Visuals' }, vars.rage.logger.main, { vars.rage.logger.events, 'Aimbot Shots', 'Damage Dealt' })
                vars.rage.logger.miss = group:label('\f<dot>Miss Color', { 255, 80, 101, 255 }):depend({ vars.selection.tab, 'Visuals' }, vars.rage.logger.main, { vars.rage.logger.events, 'Aimbot Shots' })
                vars.rage.logger.purchase = group:label('\f<dot>Purchases Color', { 255, 184, 79, 255 }):depend({ vars.selection.tab, 'Visuals' }, vars.rage.logger.main, { vars.rage.logger.events, 'Purchases' })
                vars.rage.logger.leftside = group:label('\f<dot>Left side', { 255, 255, 255, 255 }):depend({ vars.selection.tab, 'Visuals' }, vars.rage.logger.main)
                vars.rage.logger.rightside = group:label('\f<dot>Right side', { 12, 12, 12, 255 }):depend({ vars.selection.tab, 'Visuals' }, vars.rage.logger.main)
                vars.rage.logger.odstep = group:label('\n' ):depend({ vars.selection.tab, 'Visuals' }, vars.rage.logger.main)
                
    
                vars.rage.logger.main:set_callback(function (self)
                    local val = self.value
                    for _, item in next, reference.logging do
                        item:set_enabled(not val)
                        if val then
                            item:override(false)
                        else
                            item:override()
                        end
                    end
                end, true)
            end

            vars.visuals.otherxd = group:multiselect('\f<dot>Additionals', {'Defensive Indicator', "Velocity Indicator [SOON]", "Kibit Indicator [SOON]"}):depend({ vars.selection.tab, 'Visuals' })
            vars.visuals.colorxd = group:label('\f<dot>Defensive Indicator Color', defines.accent):depend({ vars.selection.tab, 'Visuals' }, {vars.visuals.otherxd, "Defensive Indicator"})
            vars.visuals.colorxd2 = group:label('\n'):depend({ vars.selection.tab, 'Visuals' })
           -- vars.visuals.otherxd2:set_enabled(false)

        end
    
        local misc do
            vars.misc = { }
    
            do

                vars.misc.clantag = group:checkbox('\f<dot>Enable \vClantag'):depend({ vars.selection.tab, 'Misc' })
                vars.misc.teleport = group:checkbox('\f<dot>Automatic \vDisrecharge \aFF6B89FF[ALPHA]', 0x00):depend({ vars.selection.tab, 'Misc' })
                vars.misc.resolver = group:checkbox('\f<dot>Premium \vResolver\aFF6B89FF [ALPHA]'):depend({ vars.selection.tab, 'Misc' })
                vars.misc.resolver_mode = group:combobox('\f<dot>Mode', {'Modern', 'AI'}):depend({ vars.selection.tab, 'Misc' },vars.misc.resolver)
    
                local function utililize_clantag()
                    if vars.misc.clantag.value then
                        reference.MISC.clantag:set_enabled(false)
                        reference.MISC.clantag:override(false)
                    else
                        reference.MISC.clantag:set_enabled(true)
                        client.set_clan_tag ''
                        reference.MISC.clantag:override()
                    end
                end
    
                vars.misc.clantag:set_callback(utililize_clantag, true)
                reference.MISC.clantag:set_callback(utililize_clantag, true)
            end
    
            vars.misc.ladder = group:checkbox('\f<dot>Fast \vLadder'):depend({ vars.selection.tab, 'Misc' })
    
            do

                vars.misc.breakers = { }
    
                vars.misc.breakers.main = group:checkbox('\f<dot>Animation \vBreaker'):depend({ vars.selection.tab, 'Misc' })
    
                vars.misc.breakers.air = group:combobox('\f<dot>Air', { 'Disabled', 'Static', 'Jitter' }):depend({ vars.selection.tab, 'Misc' }, vars.misc.breakers.main)
                vars.misc.breakers.ground = group:combobox('\f<dot>Ground', { 'Disabled', 'Static', 'Jitter' }):depend({ vars.selection.tab, 'Misc' }, vars.misc.breakers.main)

    
                reference.AA.other.leg_movement:depend(true, { vars.misc.breakers.main, false })
            end
    
            vars.misc.filter = group:checkbox('\f<dot>Console \vFilter'):depend({ vars.selection.tab, 'Misc' }) do
                vars.misc.filter:set_callback(function (self)
                    cvar.con_filter_text:set_string('[gamesense]')
                    cvar.con_filter_enable:set_raw_int(self.value and 1 or 0)
                end, true)
    
                defer(function ()
                    cvar.con_filter_enable:set_raw_int(tonumber(cvar.con_filter_enable:get_string()))
                end)
            end
        end
    
        local configs do
        
            vars.configs = { }

            vars.configs.selector = group:combobox("\nConfigs" , {"Local", "Cloud"}):depend({ vars.selection.tab, 'Configs' })


    
            vars.configs.list = group:listbox('\nConfig List', { 'No Configs!' }, '', false):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Local"})
            vars.configs.name = group:textbox('\nConfig Name', '', false):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Local"})
            vars.configs.load = group:button('Load', nil, true):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Local"})
            vars.configs.save = group:button('Save', nil, true):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Local"})
            vars.configs.export = group:button('Export', nil, true):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Local"})
            vars.configs.import = group:button('Import', nil, true):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Local"})
            vars.configs.remove = group:button('Remove', nil, true):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Local"})
            vars.configs.upload = group:button('Upload / Update Config', nil, true):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Local"})
            vars.configs.default = group:button('Default', nil, true):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Local"})
            vars.configs.autosave = group:checkbox("\vEnable auto save to cloud"):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Local"})

            vars.configs.list2 = group:listbox('\nConfig List', { 'Could not load configs. Open ticket' }, '', false):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Cloud"})
            vars.configs.author = group:label("Created by: \vunknown"):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Cloud"})
            vars.configs.updatedat = group:label("Updated at: \vunknown"):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Cloud"})
            vars.configs.load2 = group:button('Load', nil, true):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Cloud"})
            vars.configs.remove2 = group:button('Remove', nil, true):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Cloud"})
            vars.configs.refresh = group:button('Refresh', nil, true):depend({ vars.selection.tab, 'Configs' }, {vars.configs.selector, "Cloud"})


        end
    
        local function set_skeet_ui(state)
            for _, ref in next, reference.AA.angles do
                for __, subref in next, ref do
                    subref:set_visible(state)
                end
            end
        end
    
        local function reset_overrides()
            for _, ref in next, reference.AA.angles do
                for __, subref in next, ref do
                    subref:override()
                end
            end
        end
    
        callbacks['Vars']['paint_ui']:set(function ()
            if not ui.is_menu_open() then
                return
            end
    
            set_skeet_ui(false)
        end)
    
        callbacks['Vars']['shutdown']:set(function ()
            set_skeet_ui(true)
            reset_overrides()
        end)
    end
    

    local w, h = client.screen_size()

    local dragging_fn = function(name, base_x, base_y)
        return (function()
            local a = {}
            local b, menu_open, m_x, m_y, old_m_x, old_m_y, m1_active, old_m1, x, y, dragging, old_dragging
            local p = {__index = {drag = function(self, w, h, ...)
                        local x, y = self:get()
                        local s, t = a.drag(x, y, self.w, self.h, self, ...)
                        if x ~= s or y ~= t then
                            self:set(s, t)
                        end
                        return s, t
                    end, set = function(self, x, y)
                        self.x_reference:set(x)
                        self.y_reference:set(y)
                    end, get = function(self)
                        self.x_reference:set_visible(false)
                        self.y_reference:set_visible(false)
                        return self.x_reference:get(), self.y_reference:get()
                    end, set_w_h = function(self, w, h)
                        self.w = w
                        self.h = h
                    end}}
            function a.new(name, ref_x, ref_y)
                return setmetatable({name = name, x_reference = ref_x, y_reference = ref_y, w = 0, h = 0, alpha = 0}, p)
            end
            function a.drag(pos_x, pos_y, w, h, self, C, D)
                if globals.framecount() ~= b then
                    menu_open = ui.is_menu_open()
                    old_m_x, old_m_y = m_x, m_y
                    m_x, m_y = ui.mouse_position()
                    old_m1 = m1_active
                    m1_active = client.key_state(0x01) == true
                    old_dragging = dragging
                    dragging = false
                    x, y = client.screen_size()
                end
                if menu_open and old_m1 ~= nil then
                    w = w + 6
                    h = h + 5
                    local dragging_value = old_dragging and 1 or 0
                    if dragging_value ~= self.alpha then
                    self.alpha = main_funcs:lerp(8 * globals_frametime(), self.alpha, dragging_value)
                    end
                    if self.alpha > 0 then
                    main_funcs.rounded_rectangle(pos_x - 8, 50, 108, y - 100, 186, 186, 186, self.alpha * 60, 5) 
                    end
                    if (not old_m1 or old_dragging) and m1_active and old_m_x > pos_x and old_m_y > pos_y and old_m_x < pos_x + w and old_m_y < pos_y + h then
                        dragging = true
                        --pos_x, pos_y = pos_x + m_x - old_m_x, pos_y + m_y - old_m_y
                        pos_y = pos_y + m_y - old_m_y
                        if not D then
                            pos_x = math.max(0, math.min(x - w, pos_x))
                            pos_y = math.max(0, math.min(y - h, pos_y))
                        end
                    elseif client.key_state(0x02) and old_m_x > pos_x and old_m_y > pos_y and old_m_x < pos_x + w and old_m_y < pos_y + h then
                        pos_x, pos_y = x/2 - 50, 250
                    end
                end
                return pos_x, pos_y, w, h
            end
            return a
        end)().new(name, base_x, base_y)
    end
    local xdxd = pui.group("AA", "Anti-aimbot angles")
    local elements = {
        dragging = {
            def_x = pui.slider(xdxd, "\nX Defensive", 0, w, w/2-50),
            def_y = pui.slider(xdxd, "\nY Defensive", 0, h, 250),
        }
    }

    elements.dragging.def_x:set_visible(false)
    
    elements.dragging.def_y:set_visible(false)

local defensive = dragging_fn("Defensive", elements.dragging.def_x, elements.dragging.def_y)
local alpha, length = 0, 0
local r0, g0, b0, a0 = 71, 71, 71, 255;
local r1, g1, b1, a1 = vars.visuals.indicators_color:get_color()
local r, g, b, a = r1, g1, b1, a1;
local defensive_indicator = function()
    if not vars.visuals.otherxd:get("Defensive Indicator") then
        return
    end
    local x, y = defensive:get()
    local r, g, b, a = 255, 255, 255, 255
    defensive:drag()
    defensive:set_w_h(95, 20)

    local ent = entity.get_local_player()
    local menu = ui.is_menu_open()
    alpha = menu and 1 or main_funcs:clamp(alpha + (globals.tickcount() <= main_funcs.def and 1 * globals_frametime() or -1 * globals_frametime()),0,1)
    local defensive_active = main_funcs:defensive_state(condition ~= nil and vars.aa.defensive.yaw.value or 0)
    if defensive_active or menu then
        length = defensive_active and main_funcs:lerp(4 * globals_frametime() * 2, length, (main_funcs.last_sim_time - globals.tickcount()) * -1) or 8.2
        length = length > 16 and 16 or length
        local hex = main_funcs.rgba_to_hex(255, 255, 255, 255)
        local offset_x, offset_y = 3, 2
        local r, g, b = vars.visuals.colorxd:get_color()
        local start, en = {r, g, b, 255}, {12, 12, 12, 100}
        local text = main_funcs:text_animation(5, start, en, "defensive choking")

        container_glow(x + offset_x - 7, y + offset_y, 100, 25, 30, 30, 30, 255, 0.7, 255, 255, 255)
        renderer_text(x + offset_x, y + offset_y, 255, 255, 255, 255, nil, 0, text)
        main_funcs.rectangle_outline(x + offset_x, y + offset_y + 14, 85, 6, 12, 12, 12, 100, 5)
        renderer_rectangle(x + offset_x + 45, y + offset_y + 15, (length * 3) - 3, 4, r, g, b, a)
        renderer_rectangle(x + offset_x + 45, y + offset_y + 15, (-length * 3) - 3, 4, r, g, b, a)
    end
end


client.set_event_callback("paint_ui", function()
    defensive_indicator()
end)

local notification = (function()
    local notification = {}
    local notif = { callback_created = false, max_count = 5 }

    notif.register_callback = function(self)
        if self.callback_created then return end

        local screen_x, screen_y = client.screen_size()
        local pos = { x = screen_x / 2, y = screen_y / 1.2 }

        client.set_event_callback("paint_ui", function()
            local extra_space = 0

            for i = #notification, 1, -1 do
                local data = notification[i]

                if data == nil then return end

                local icon1 = icons1.main

                if data.alpha < 1 and data.real_time + data.time < globals_realtime() then
                    table.remove(notification, i)
                else
                    data.alpha = main_funcs:lerp(4 * globals_frametime(), data.alpha, data.real_time + data.time - 0.1 < globals_realtime() and 0 or 255)

                    if data.alpha <= 120 then
                        data.move = data.move - 0.2
                    end

                    local text_size_x, text_size_y = renderer.measure_text(nil, data.text)
                    --local col = data.color
                    local col = {vars.rage.logger.leftside:get_color()}
                    local col2 = {vars.rage.logger.rightside:get_color()}
                    local img_w, img_h = 5, 36
                    local x, y = pos.x - text_size_x / 2 - img_w / 2, pos.y - data.move - extra_space
                    local smooth_location =  math.floor(data.alpha - 5) / 255
                    data.text = data.text:gsub("\a(%x%x)(%x%x)(%x%x)(%x%x)", ("\a%%1%%2%%3%02X"):format(data.alpha))

                    --rounded_rectangle = function(x, y, w, h, r, g, b, a, radius, side)           

                    main_funcs.rounded_rectangle(x, y, text_size_x + img_w + 5, img_h / 2 + 7, col2[1], col2[2], col2[3], data.alpha / 1.3, 2, true)

                   -- renderer_rectangle(x, y, text_size_x + img_w + 5, img_h / 2 + 7, col2[1], col2[2], col2[3], data.alpha / 1.3)
                   main_funcs.rounded_rectangle(x - 30, y, 20 + 7, img_h / 2 + 7, 8, 8, 8, data.alpha / 1.3, 1, true)
                    renderer_rectangle(x - 30, y, 2, (img_h / 2 + 7) * smooth_location, col[1], col[2], col[3], data.alpha)
                    renderer_rectangle(x + text_size_x + img_w + 2, y, 2, (img_h / 2 + 7) * smooth_location, col[1], col[2], col[3], data.alpha)
                    icon1:draw(x - 32, y - 4, nil, 32, col[1], col[2], col[3], data.alpha)
                    renderer_text(x + img_w, y + 6, 255, 255, 255, data.alpha, nil, 0, data.text)

                    extra_space = extra_space +  math.floor(data.alpha / 255 * (text_size_y - 42) + 0.5)
                end
            end
        end)

        self.callback_created = true
    end

    notif.add = function(self, t, txt)
        for i = self.max_count, 2, -1 do
            notification[i] = notification[i - 1]
        end

        local col = {vars.visuals.indicators_color:get_color()}
        notification[1] = { alpha = 50, text = txt, real_time = globals_realtime(), time = t, move = 100, color = col }
        self:register_callback()
    end

    return notif
end)()



    local function tableToJSON(tbl)
        local result = "{"
        for key, value in pairs(tbl) do
            result = result .. '"' .. key .. '":"' .. tostring(value) .. '",'
        end
        result = result:sub(1, -2) .. "}" 
        return result
    end

    local configs do
        configs = { }
        configscloud = { }
        updatedates = { }
        authors = { }
        configs.instancecloud = pui.setup({vars.conditions, vars.aa, vars.angles})

        function configs.refresh()
            local http_data_refresh = {
                ["username"] = username,
                ["key"] = "fpGQysQr3Sq8UZQUOYZsLxjyGCBGq9o4",
                ["type"] = "refresh"
            }

            -- http.post("http://cloudpusy.ct8.pl/cloud/api/refresh.php", {
            --         body = tableToJSON(http_data_refresh)
            --     },
            --     function(success, response)
            --         if not success or response.status ~= 200 then
            --             print_format('\vastra \r· Something went wrong(21), Response: ' ..response.status)
            --             notification:add(5, 'Something went wrong(21), Response: ' ..response.status)
            --             return
            --         end
                    
            
            --         -- Attempt to parse the JSON data
            --         local json_data = response.body
            --         local decoded_data = json.parse(json_data)

            --         if type(decoded_data) == "table" and decoded_data.configNames then
            --             configscloud = decoded_data.configNames
            --             updatedates = decoded_data.configUpdates
            --             authors = decoded_data.configUsernames
            --             vars.configs.list2:update(configscloud)
            --             configs.update_datas()
            --             configs.update_author()
            --             print_format('\vastra \r· Config list refreshed!')
            --             notification:add(5,'Config list refreshed!')
            --         else
            --             print_format('\vastra \r· Something went wrong(26)')
            --             notification:add(5, 'Something went wrong(26)')
            --         end
            --     end
            -- )
            
        end

        function configs.remove2()
            if vars.configs.list2() == nil then
                return
            end
            local index = vars.configs.list2()
            local cfgpos = index + 1
            if configscloud == nil then
                return
            end
            local cfgname = configscloud[cfgpos]

            local http_data = {
                ["key"] = "fpGQysQr3Sq8UZQUOYZsLxjyGCBGq9o4",
                ["username"] = username,
                ["configname"] = cfgname,
                ["type"] = "delete"
            }
            -- Convert the table to a JSON string
            local json_data = tableToJSON(http_data)
            
            -- http.post("http://cloudpusy.ct8.pl/cloud/api/upload.php", {
            --         body = json_data
            --     },
            --     function(success, response)
            --         local data = json.parse(response.body)
            --         if not success or response.status ~= 200 then
            --             print(data.message)
            --             notification:add(5, data.message)
            --             return
            --         end
            --         notification:add(5, data.message)
            --         print(data.message)
            --         configs.refresh()
            --     end
            -- )
        end

        function configs.update_author()
            local index = vars.configs.list2()
            if index == nil then
                return
            end
            local cfgpos = index + 1
            if authors == nil  then
                return
            end
            
            local author = authors[cfgpos]
                return vars.configs.author("Created by: \a" ..pui.accent.. author)
        end

        function configs.update_datas()
            local index = vars.configs.list2()
            if index == nil then
                return
            end
            local cfgpos = index + 1
            if updatedates == nil then
                return
            end
            local updatedate = updatedates[cfgpos]
                return vars.configs.updatedat("Updated at: \a" ..pui.accent.. updatedate)
        end

        vars.configs.remove2:set_callback(function()
            configs.remove2()
        end)

        vars.configs.refresh:set_callback(function()
            configs.refresh()
        end)

        vars.configs.list2:set_callback(function()
            configs.update_author()
            configs.update_datas()
        end)

        configs.instance = pui.setup(vars)
        configs.prefix = 'astra:'
    
        local data = db.astra or { }
        if type(data) ~= 'table' then
            data = { }
        end
    
        function configs.export()
            local config = configs.instance:save()
            if config == nil then
                return
            end
    
            local data = {
                author = defines.user,
                data = config,
                name = vars.configs.name.value
            }
    
            local success, packed = pcall(msgpack.pack, data)
            if not success then
                return
            end
    
            local success, encode = pcall(base64.encode, packed)
            if not success then
                return
            end
    
            return f('astra:%s_astra', encode)
        end

        function configs.exportcloud()
            local config = configs.instancecloud:save()
            if config == nil then
                return
            end
    
            local data = {
                author = defines.user,
                data = config,
                name = vars.configs.name.value
            }
    
            local success, packed = pcall(msgpack.pack, data)
            if not success then
                return
            end
    
            local success, encode = pcall(base64.encode, packed)
            if not success then
                return
            end
    
            return f('astra:%s_astra', encode)
        end
    
        function configs.import(str)
            local config = str or clipboard.get()
            if config == nil then
                return print_format('\vastra \r· Empty file.')
            end
    
            if string.sub(config, 1, #configs.prefix) ~= configs.prefix then
                return print_format('\vastra \r· Config data issue')
            end
    
            config = config:gsub('astra:', ''):gsub('_astra', '')
    
            local success, decoded = pcall(base64.decode, config)
            if not success then
                return print_format('\vastra \r· Failed {301}')
            end
    
            local success, data = pcall(msgpack.unpack, decoded)
            if not success then
                return print_format('\vastra \r· Failed {303}')
            end
    
            configs.instance:load(data.data)
            print_format('\vastra \r· Config loaded successfully!')
            notification:add(5, 'Config loaded successfully!')
        end

        function configs.importcloud(str)
            local config = str
            if config == nil then
                return print_format('\vastra \r· Empty file.')
            end
    
            if string.sub(config, 1, #configs.prefix) ~= configs.prefix then
                return print_format('\vastra \r· Config data issue')
            end
    
            config = config:gsub('astra:', ''):gsub('_astra', '')
    
            local success, decoded = pcall(base64.decode, config)
            if not success then
                return print_format('\vastra \r· Failed {301}')
            end
    
            local success, data = pcall(msgpack.unpack, decoded)
            if not success then
                return print_format('\vastra \r· Failed {303}')
            end
            configs.instancecloud:load(data.data)
            print_format('\vastra \r· Config loaded successfully!')
            notification:add(5, 'Config loaded successfully!')
        end
    
        local configs_mt = {
            __index = {
                load = function(self)
                    configs.import(self.data)
                end,
    
                export = function(self)
                    if not self.data:find('_astra') then
                        self.data = f('%s_astra', self.data)
                    end
    
                    clipboard.set(self.data)
                end,
    
                save = function(self, data)
                    if data == nil then
                        data = configs.export()
                    end
    
                    self.data = data
                    self.author = defines.user
                end,
    
                to_db = function(self)
                    return {
                        name = self.name,
                        data = self.data,
                        author = defines.user
                    }
                end
            }
        }
    
        local database_mt = setmetatable({ }, {
            __index = function(self, key)
                local storage = data.configs
    
                if storage == nil then
                    return nil
                end
    
                local success, parsed = pcall(json.parse, storage)
                if not success then
                    return nil
                end
    
                return parsed[ key ]
            end,
    
            __newindex = function(self, key, v)
                local storage = data.configs
    
                if storage == nil then
                    storage = '{}'
                end
    
                local success, parsed = pcall(json.parse, storage)
                if not success then
                    parsed = { }
                end
    
                parsed[ key ] = v
    
                data.configs = json.stringify(parsed)
            end
        })
    
        local database_name = 'astra'
        local live_list = { }
    
        function configs.update_list()
            local list_names = { }
    
            local val = vars.configs.list:get() + 1
    
            for i = 1, #live_list do
                local obj = live_list[ i ]
    
                list_names[ #list_names + 1 ] = f('%s%s', val == i and '\a' .. pui.accent .. '• ' or '', obj.name)
            end
    
            if #list_names == 0 then
                list_names[ #list_names + 1 ] = 'Config list is empty!'
            end
    
            vars.configs.list:update(list_names)
        end

        function configs.load2()
            if vars.configs.list2() == nil then
                return
            end
            local index = vars.configs.list2()
            local cfgpos = index + 1
            if configscloud == nil then
                return
            end
            local cfgname = configscloud[cfgpos]

            local http_data = {
                ["username"] = username,
                ["key"] = "fpGQysQr3Sq8UZQUOYZsLxjyGCBGq9o4",
                ["configname"] = cfgname,
                ["type"] = "load"
            }
            
            local json_data = tableToJSON(http_data)
            
            -- http.post("http://cloudpusy.ct8.pl/cloud/api/load.php", {
            --         body = json_data
            --     },
            --     function(success, response)
            --         if not success or response.status ~= 200 then
            --             print_format('\vastra \r· Something went wrong(31), Response: ' ..response.status)
            --             notification:add(5, 'Something went wrong(31), Response: ' ..response.status)
            --             return
            --         end
            --         local json_data = response.body
            --         local decoded_data = json.parse(json_data)
            --         configs.importcloud(decoded_data.configContent)
            --     end
            -- )
        end

        vars.configs.load2:set_callback(function()
            configs.load2()
        end)

        function configs.share()
            local http_data = {
                ["key"] = "fpGQysQr3Sq8UZQUOYZsLxjyGCBGq9o4",
                ["username"] = username,
                ["configname"] = vars.configs.name:get(),
                ["type"] = "save",
                ["content"] = configs.exportcloud()
            }
            
            -- Convert the table to a JSON string
            local json_data = tableToJSON(http_data)
            
            
            -- http.post("http://cloudpusy.ct8.pl/cloud/api/upload.php", {
            --         body = json_data
            --     },
            --     function(success, response)
            --         if response.status == 409 then
            --             notification:add(5, 'Config with the same name already exists')
            --             print_format('\vastra \r· Config with the same name already exists')
            --             return
            --         end
            --         if not success or response.status ~= 200 then
            --             notification:add(5, 'Something went wrong(11), Response: ' ..response.status)
            --             print_format('\vastra \r· Something went wrong(11), Response: ' .. response.status)
            --             return
            --         end
            --         local data = json.parse(response.body)
            --         notification:add(5, data.message)
            --         print_format('\vastra \r· ' ..data.message)
            --     end
            -- )
        end

        vars.configs.upload:set_callback(function()
            configs.share()
        end)

        function configs.lookup(name)
            name = utilities.strip(name)
    
            for i = 1, #live_list do
                local obj = live_list[ i ]
    
                if obj.name == name then
                    return obj, i
                end
            end
        end
    
        function configs.create(name, data, author)
            name = utilities.strip(name)
    
            local new_preset = {
                name = name,
                data = data or configs.export(),
                author = author or defines.user
            }
    
            live_list[ #live_list + 1 ] = setmetatable(new_preset, configs_mt)
    
            configs.update_list()
            configs.flush()
        end
    
        function configs.on_list_name()
            if #live_list == 0 then
                return vars.configs.name:set('')
            end
    
            local selected_preset = live_list[ vars.configs.list:get() + 1 ]
    
            if selected_preset == nil then
                selected_preset = live_list[ #live_list ]
            end
    
            vars.configs.name:set(selected_preset.name)
        end
    
        function configs.destroy(preset)
            for i = 1, #live_list do
                local obj = live_list[ i ]
    
                if obj.name == preset.name then
                    table.remove(live_list, i)
                    break
                end
            end
    
            configs.update_list()
            configs.flush()
            configs.on_list_name()
        end
    
        function configs.init()
            local db_info = database_mt[ database_name ]
    
            if db_info == nil then
                db_info = { }
            end
    
            for i = 1, #db_info do
                local obj = db_info[ i ]
    
                live_list[ i ] = setmetatable(obj, configs_mt)
            end
    
            configs.update_list()
            configs.on_list_name()
            configs.refresh()
        end
    
        function configs.flush()
            local db_info = { }
    
            for i = 1, #live_list do
                local obj = live_list[ i ]
    
                db_info[ #db_info + 1 ] = obj:to_db()
            end
    
            database_mt[ database_name ] = db_info
        end
    
        function configs.startup()
            if not data.stored_config then
                return print_format('\vastra \r· Successfully inited config database.')
            end
        end
    
        local basic_controls = { 'load', 'export' }
        local sentences = {
            ['load'] = 'loaded',
            ['export'] = 'copied'
        }
    
        for _, type in next, basic_controls do
            vars.configs[ type ]:set_callback(function()
                local selected_name = vars.configs.name:get()
                local selected_preset, id = configs.lookup(selected_name)
    
                if selected_preset == nil then
                    return print_format('\vastra \r· Failed to \v%s\r, configuration doesnt exist.', type)
                end
    
                print_format('\vastra \r· Successfully %s \v%s\r.', sentences[ type ], selected_preset.name)
                selected_preset[type](selected_preset)
    
                configs.on_list_name()
                configs.update_buttons()
            end)
        end
    
        vars.configs.save:set_callback(function()
            local selected_name = vars.configs.name:get()
            local selected_preset, id = configs.lookup(selected_name)
    
            if selected_preset == nil then
                configs.create(selected_name)
                vars.configs.list:set(#live_list)
                print_format('\vastra \r· Config \v%s \rwas successfully saved.', utilities.strip(selected_name))
                notification:add(5, 'Config '..utilities.strip(selected_name)..' was successfully saved.')
            else
                print_format('\vastra \r· Config \v%s \rwas successfully overwrited.', utilities.strip(selected_name))
                notification:add(5, 'Config '..utilities.strip(selected_name)..' was successfully overwrited.')
                selected_preset:save()
            end
    
            configs.on_list_name()
            configs.update_buttons()
             if vars.configs.autosave.value then
                 configs.share()
             end
        end)
    
        vars.configs.import:set_callback(function ()
            local clipboard_text = clipboard.get()
            local s = clipboard_text
            if s == nil then
                return print_format('\vastra \r· Your clipboard is empty.')
            end
    
            do
                if s:sub(1, #configs.prefix) ~= configs.prefix then
                    return print_format('\vastra \r· Looks like this config is not for astra...')
                end
    
                s = s:sub(#configs.prefix + 1)
    
                if s:find('_astra') then
                    s = s:gsub('_astra', '')
                end
            end
    
            local success, decoded = pcall(base64.decode, s)
            if not success then
                return print_format('\vastra \r· Failed to decode your configuration.')
            end
    
            local success, unpacked = pcall(msgpack.unpack, decoded)
            if not success then
                return print_format('\vastra \r· Failed to unpack your configuration.')
            end
    
            local selected_preset, id = configs.lookup(unpacked.name)
            if selected_preset == nil then
                print_format('\vastra \r· Added \v%s \rby \v%s\r.', utilities.strip(unpacked.name), unpacked.author)
                configs.create(unpacked.name, clipboard_text, unpacked.author)
                vars.configs.list:set(#live_list)
            else
                print_format('\vastra \r· Config \v%s \rwas successfully overwrited.', utilities.strip(unpacked.name))
                selected_preset:save(clipboard_text)
            end
    
            configs.import(clipboard_text)
            configs.on_list_name()
            configs.update_buttons()
        end)
    
        vars.configs.remove:set_callback(function()
            local selected_name = vars.configs.name:get()
            local selected_preset, id = configs.lookup(selected_name)
    
            if selected_preset == nil then
                return
            end
    
            print_format('\vastra \r· Config \v%s \rwas successfully removed.', selected_preset.name)
    
            configs.destroy(selected_preset)
            configs.update_buttons()
        end)
    
        function configs.update_buttons()
            local selected_name = vars.configs.name:get()
            local selected_preset, id = configs.lookup(selected_name)
    
            local state = selected_preset ~= nil
            vars.configs.load:set_enabled(state)
            vars.configs.export:set_enabled(state)
            vars.configs.remove:set_enabled(state)
        end
    
        vars.configs.list:set_callback(function (self)
            local selected_name = vars.configs.name:get()
            local selected_preset, id = configs.lookup(selected_name)
    
            configs.on_list_name()
            configs.update_list()
            configs.update_buttons()
        end, true)
    
        configs.init()
        configs.startup()
        client.delay_call(.1, function ()
            configs.on_list_name()
            configs.update_buttons()
        end)
    
        vars.configs.default:set_callback(function (self)
            self:set_enabled(false)
            configs.import("astra:g6RuYW1loKRkYXRhhqZhbmdsZXOBqWNvbmRpdGlvbq1BZXJvICsgQ3JvdWNopG1pc2OFpmZpbHRlcsOmc2hhcmVkwqhicmVha2Vyc4OkbWFpbsKjYWlyqERpc2FibGVkpmdyb3VuZKZKaXR0ZXKnY2xhbnRhZ8KmbGFkZGVywqJhYYaoYmFja3N0YWLCpm1hbnVhbIWmZW5hYmxlw6RsZWZ0kwIAoX6nZm9yd2FyZJMCAKF+pXJlc2V0kwIAoX6lcmlnaHSTAgChfqlkaXNhYmxlcnPCrGZyZWVzdGFuZGluZ4KkbWFpbpMBBaF+qWRpc2FibGVyc5KtQWVybyArIENyb3VjaKF+qWRlZmVuc2l2ZYSkbWFpbsKlcGl0Y2imUmFuZG9to3lhd6hTaWRld2F5c6pjb25kaXRpb25zk6VTdGFuZK1BZXJvICsgQ3JvdWNooX6kc2FmZZGhfqd2aXN1YWxzgqxpbmRpY2F0b3JzX2OpIzg0ODlGRkZGqmluZGljYXRvcnPDqmNvbmRpdGlvbnOJpE1vdmXeABCoYm9keV95YXemSml0dGVyqHlhd19iYXNlqkxvY2FsIHZpZXelcGl0Y2inRGVmYXVsdKl5YXdfZGVsYXkDqnlhd19vZmZzZXQAq3BpdGNoX3ZhbHVlAKN5YXelTCAmIFKnZW5hYmxlZMOzeWF3X21vZGlmaWVyX29mZnNldACvYm9keV95YXdfb2Zmc2V0/6x5YXdfbW9kaWZpZXKjT2ZmrGRlbGF5ZWRfc3dhcMKsZnJlZXN0YW5kaW5nwqh5YXdfbGVmdOSpeWF3X3JpZ2h0JbZ5YXdfbW9kaWZpZXJfcmFuZG9taXplAK1BZXJvICsgQ3JvdWNo3gAQqGJvZHlfeWF3pkppdHRlcqh5YXdfYmFzZapBdCB0YXJnZXRzpXBpdGNop0RlZmF1bHSpeWF3X2RlbGF5Aqp5YXdfb2Zmc2V0AKtwaXRjaF92YWx1ZQCjeWF3pUwgJiBSp2VuYWJsZWTDs3lhd19tb2RpZmllcl9vZmZzZXQAr2JvZHlfeWF3X29mZnNldP+seWF3X21vZGlmaWVyo09mZqxkZWxheWVkX3N3YXDCrGZyZWVzdGFuZGluZ8KoeWF3X2xlZnTuqXlhd19yaWdodC22eWF3X21vZGlmaWVyX3JhbmRvbWl6ZQCoRmFrZSBMYWfeABCoYm9keV95YXejT2ZmqHlhd19iYXNlqkxvY2FsIHZpZXelcGl0Y2ijT2ZmqXlhd19kZWxheQWqeWF3X29mZnNldACrcGl0Y2hfdmFsdWUAo3lhd6NPZmanZW5hYmxlZMKzeWF3X21vZGlmaWVyX29mZnNldACvYm9keV95YXdfb2Zmc2V0AKx5YXdfbW9kaWZpZXKjT2ZmrGRlbGF5ZWRfc3dhcMKsZnJlZXN0YW5kaW5nwqh5YXdfbGVmdACpeWF3X3JpZ2h0ALZ5YXdfbW9kaWZpZXJfcmFuZG9taXplAKZPbiBVc2XeABCoYm9keV95YXejT2ZmqHlhd19iYXNlqkxvY2FsIHZpZXelcGl0Y2ijT2ZmqXlhd19kZWxheQWqeWF3X29mZnNldACrcGl0Y2hfdmFsdWUAo3lhd6NPZmanZW5hYmxlZMKzeWF3X21vZGlmaWVyX29mZnNldACvYm9keV95YXdfb2Zmc2V0AKx5YXdfbW9kaWZpZXKjT2ZmrGRlbGF5ZWRfc3dhcMKsZnJlZXN0YW5kaW5nwqh5YXdfbGVmdACpeWF3X3JpZ2h0ALZ5YXdfbW9kaWZpZXJfcmFuZG9taXplAKNBaXLeABCoYm9keV95YXemSml0dGVyqHlhd19iYXNlqkF0IHRhcmdldHOlcGl0Y2inRGVmYXVsdKl5YXdfZGVsYXkFqnlhd19vZmZzZXQAq3BpdGNoX3ZhbHVlAKN5YXelTCAmIFKnZW5hYmxlZMOzeWF3X21vZGlmaWVyX29mZnNldACvYm9keV95YXdfb2Zmc2V0/6x5YXdfbW9kaWZpZXKjT2ZmrGRlbGF5ZWRfc3dhcMKsZnJlZXN0YW5kaW5nwqh5YXdfbGVmdO+peWF3X3JpZ2h0IrZ5YXdfbW9kaWZpZXJfcmFuZG9taXplAKlTbG93IFdhbGveABCoYm9keV95YXejT2ZmqHlhd19iYXNlqkxvY2FsIHZpZXelcGl0Y2inRGVmYXVsdKl5YXdfZGVsYXkFqnlhd19vZmZzZXQAq3BpdGNoX3ZhbHVlAKN5YXejT2Zmp2VuYWJsZWTCs3lhd19tb2RpZmllcl9vZmZzZXQAr2JvZHlfeWF3X29mZnNldACseWF3X21vZGlmaWVyo09mZqxkZWxheWVkX3N3YXDCrGZyZWVzdGFuZGluZ8KoeWF3X2xlZnQAqXlhd19yaWdodAC2eWF3X21vZGlmaWVyX3JhbmRvbWl6ZQCmR2xvYmFsj6h5YXdfYmFzZapMb2NhbCB2aWV3pXBpdGNop0RlZmF1bHSpeWF3X2RlbGF5Bahib2R5X3lhd6ZKaXR0ZXKqeWF3X29mZnNldA6jeWF3pUwgJiBSq3BpdGNoX3ZhbHVlAKx5YXdfbW9kaWZpZXKjT2Zms3lhd19tb2RpZmllcl9vZmZzZXQAr2JvZHlfeWF3X29mZnNldP+sZGVsYXllZF9zd2FwwqxmcmVlc3RhbmRpbmfCqHlhd19sZWZ05Kl5YXdfcmlnaHQktnlhd19tb2RpZmllcl9yYW5kb21pemUApkNyb3VjaN4AEKhib2R5X3lhd6ZKaXR0ZXKoeWF3X2Jhc2WqQXQgdGFyZ2V0c6VwaXRjaKdEZWZhdWx0qXlhd19kZWxheQOqeWF3X29mZnNldACrcGl0Y2hfdmFsdWUAo3lhd6VMICYgUqdlbmFibGVkw7N5YXdfbW9kaWZpZXJfb2Zmc2V0AK9ib2R5X3lhd19vZmZzZXT/rHlhd19tb2RpZmllcqNPZmasZGVsYXllZF9zd2Fww6xmcmVlc3RhbmRpbmfCqHlhd19sZWZ0Aql5YXdfcmlnaHQAtnlhd19tb2RpZmllcl9yYW5kb21pemUApVN0YW5k3gAQqGJvZHlfeWF3pkppdHRlcqh5YXdfYmFzZapBdCB0YXJnZXRzpXBpdGNop0RlZmF1bHSpeWF3X2RlbGF5Bap5YXdfb2Zmc2V0AKtwaXRjaF92YWx1ZQCjeWF3pUwgJiBSp2VuYWJsZWTDs3lhd19tb2RpZmllcl9vZmZzZXQAr2JvZHlfeWF3X29mZnNldP+seWF3X21vZGlmaWVyo09mZqxkZWxheWVkX3N3YXDCrGZyZWVzdGFuZGluZ8KoeWF3X2xlZnTsqXlhd19yaWdodBm2eWF3X21vZGlmaWVyX3JhbmRvbWl6ZQCkcmFnZYGmbG9nZ2VyhqZtaXNzX2OpI0ZGNTA2NUZGpmV2ZW50c5SsQWltYm90IFNob3RzrERhbWFnZSBEZWFsdKlQdXJjaGFzZXOhfqRtYWluw6VoaXRfY6kjQjZFNzE3RkaqcHVyY2hhc2VfY6kjRkZCODRGRkamb3V0cHV0kqZTY3JlZW6hfqZhdXRob3KmUEVURVJP_astra")
            self:set_enabled(true)
            print_format('\vastra \r· Successfully loaded default settings.')
        end)
    
        callbacks['Configs']['shutdown']:set(function ()
            configs.flush()
            data.stored_config = configs.export()
            db.astra = data
        end)
    end

    -- { automatic teleport }

    local function is_vulnerable()
        for _, v in ipairs(entity.get_players(true)) do
            local flags = (entity.get_esp_data(v)).flags
    
            if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
                return true
            end
        end
    
        return false
    end
    

    local logger do
        logger = {
            hitgroups = {
                [0] = 'generic',
                'head', 'chest', 'stomach',
                'left arm', 'right arm',
                'left leg', 'right leg',
                'neck', 'generic', 'gear'
            },
    
            weapon_verb = {
                ['hegrenade'] = 'Naded',
                ['inferno'] = 'Burned',
                ['knife'] = 'Knifed',
                ['taser'] = 'Tasered'
            },
    
            wanted_damage = 0,
            wanted_hitgroup = 0,
            backtrack = 0
        }
    
        function logger.push(str, notify_str)
            local ref = vars.rage.logger.output.value
            if #ref == 0 then
                return
            end
    
            local convert = utilities.table_convert(ref)
    
            if convert['Console'] then
                printc(utilities.clean_up(str))
            end
    
            if convert['Notifications'] then
                notifications(5, notify_str)
            end
        end
    
        callbacks['Logger']['aim_fire']:set(function (shot, lp, valid)
            if not vars.rage.logger.main.value or not valid then
                return
            end
    
            if not utilities.contains(vars.rage.logger.events.value, 'Aimbot Shots') then
                return
            end
    
            logger.wanted_damage = shot.damage
            logger.wanted_hitgroup = shot.hitgroup
            logger.backtrack = globals.tickcount() - shot.tick
        end)
    
        callbacks['Logger']['aim_hit']:set(function (shot, lp, valid)
            if not vars.rage.logger.main.value or not valid then
                return
            end
    
            if not utilities.contains(vars.rage.logger.events.value, 'Aimbot Shots') then
                return
            end
    
            local output = vars.rage.logger.output.value
            if #output == 0 then
                return
            end
    
            local convert = utilities.table_convert(output)
    
            local target = shot.target
            if target == nil then
                return
            end
    
            local r, g, b = vars.rage.logger.hit:get_color()
    
            local name = entity.get_player_name(target)
            local health = entity.get_prop(target, 'm_iHealth')
            local hitgroup = logger.hitgroups[ shot.hitgroup ]
    
            -- if convert['Console'] then
            --     local info = {
            --         '\vastra \r· ',
            --         health > 0 and 'Hit ' or 'Hit ',
            --         f('\v%s\r ', name),
            --         'in the ',
            --         shot.hitgroup ~= logger.wanted_hitgroup and f('\v%s\r (aimed: \v%s\r) ', hitgroup, logger.hitgroups[ logger.wanted_hitgroup ]) or f('\v%s\r ', hitgroup),
            --         health > 0 and 'for ' or "for",
            --         health > 0 and (shot.damage ~= logger.wanted_damage and f('\v%d\r(\v%d\r) ', shot.damage, logger.wanted_damage) or f('\v%d\r ', shot.damage)) or (shot.damage ~= logger.wanted_damage and f('\v%d\r(\v%d\r) ', shot.damage, logger.wanted_damage)),
            --         health > 0 and 'damage ' or '',
            --         logger.backtrack ~= 0 and f('(history: \v%d\r) ', logger.backtrack) or '',
            --         health > 0 and f('(\v%d \rhealth remaining)', health) or ''
            --     }
                
            --     printc(utilities.clean_up(utilities.format(table.concat(info, ''), r, g, b)))
            -- end
    
            if convert['Screen'] then
                local notify_data = {
                    health > 0 and 'Hit ' or 'Hit ',
                    f('\v%s\r ', name),
                    'in the ',
                    f('\v%s\r ', hitgroup),
                    health > 0 and 'for ' or 'for ',
                    health > 0 and f('\v%d\r ', shot.damage) or f('\v%d\r ', shot.damage),
                    health > 0 and 'damage' or 'damage'
                }

                notification:add(5, utilities.format(table.concat(notify_data, ''), r, g, b))

        
            end
        end)
    
        callbacks['Logger']['aim_miss']:set(function (shot, lp, valid)
            if not vars.rage.logger.main.value or not valid then
                return
            end
    
            if not utilities.contains(vars.rage.logger.events.value, 'Aimbot Shots') then
                return
            end
    
            local output = vars.rage.logger.output.value
            if #output == 0 then
                return
            end
    
            local convert = utilities.table_convert(output)
    
            local target = shot.target
            if target == nil then
                return
            end
    
            local r, g, b = vars.rage.logger.miss:get_color()
    
            local name = entity.get_player_name(target)
    
    
            if convert['Screen'] then
                local notify_data = {
                    'Missed at ',
                    f('\v%s\r ', name),
                    'due to ',
                    f('\v%s\r ', shot.reason)
                }
    
                notification:add(5, utilities.format(table.concat(notify_data, ''), r, g, b))
            end
        end)
    
        callbacks['Logger']['player_hurt']:set(function (e, lp, valid)
            if not vars.rage.logger.main.value or not valid then
                return
            end
    
            if not utilities.contains(vars.rage.logger.events.value, 'Damage Dealt') then
                return
            end
    
            local output = vars.rage.logger.output.value
            if #output == 0 then
                return
            end
    
            local convert = utilities.table_convert(output)
    
            local victim = client.userid_to_entindex(e.userid)
            local attacker = client.userid_to_entindex(e.attacker)
            if victim == nil or victim == lp or attacker ~= lp then
                return
            end
    
            local verb = logger.weapon_verb[ e.weapon ]
            if verb == nil then
                return
            end
    
            local r, g, b = vars.rage.logger.hit:get_color()
            local name = entity.get_player_name(victim)
    
    
            if convert['Screen'] then
                local notify_data = {
                    verb,
                    f(' \v%s\r ', name),
                    'for ',
                    f('\v%s \rdamage ', e.dmg_health or 0)
                }
    
                notification:add(5, utilities.format(table.concat(notify_data, ''), r, g, b))
            end
        end)
    
        callbacks['Logger']['item_purchase']:set(function (e, lp, valid)
            if not vars.rage.logger.main.value or not valid then
                return
            end
    
            if not utilities.contains(vars.rage.logger.events.value, 'Purchases') then
                return
            end
    
            local output = vars.rage.logger.output.value
            if #output == 0 then
                return
            end
    
            local convert = utilities.table_convert(output)
    
            local player = client.userid_to_entindex(e.userid)
            if player == nil or not entity.is_enemy(player) then
                return
            end
    
            local weapon = e.weapon
            if weapon == 'weapon_unknown' then
                return
            end
    
            local r, g, b, a = vars.rage.logger.purchase:get_color()
            local name = entity.get_player_name(player)
    
    
            if convert['Screen'] then
                local notify_data = {
                    f('\v%s\r ', name),
                    'bought ',
                    f('\v%s\r', weapon)
                }
                
                notification:add(5, utilities.format(table.concat(notify_data, ''), r, g, b))
            end
        end)
    end


local manuals = { }


    
    do
        manuals = {
            reset = 0,
            yaw = 0,
    
            items = {
                [ vars.aa_binds.manual.left.ref ] = {
                    yaw = 1,
                    state = false,
                },
    
                [ vars.aa_binds.manual.right.ref ] = {
                    yaw = 2,
                    state = false,
                },
    
                [ vars.aa_binds.manual.forward.ref ] = {
                    yaw = 3,
                    state = false,
                },
    
                [ vars.aa_binds.manual.reset.ref ] = {
                    yaw = 0,
                    state = false,
                }
            },
    
            degree = {
                -90,
                90,
                180,
                0
            }
        }
    
        for manual in next, manuals.items do
            ui.set(manual, 'Toggle')
        end
    
        local layer = anti_aim.new('Manual Yaw', 5)
    
        callbacks['Manual Yaw']['setup_command']:set(function (cmd, lp, valid)
            defines.functions.manual = false
            -- if not vars.aa.manual.main.value then
            --     manuals.yaw = 0
            --     return
            -- end
    
            for key, value in pairs(manuals.items) do
                local state, mode = ui.get(key)
    
                if state == value.state then
                    goto skip
                end
    
                value.state = state
    
                if mode == 1 then
                    manuals.yaw = state and value.yaw or manuals.reset
                    goto skip
                end
    
                if mode == 2 then
                    if manuals.yaw == value.yaw then
                        manuals.yaw = manuals.reset
                    else
                        manuals.yaw = value.yaw
                    end
    
                    goto skip
                end
    
                ::skip::
            end
    
            local manual_yaw = manuals.degree[ manuals.yaw ]
            if manual_yaw == nil then
                return
            end
    
            layer:tick()
    
            layer.enabled[1] = true
            layer.yaw_base[1] = 'Local view'
            layer.yaw[2] = manual_yaw
    
                layer.yaw_modifier[1] = 'Off'
                layer.body_yaw[1] = 'Static'
                layer.body_yaw[2] = 120
    
            layer.freestanding[1] = false
    
            defines.functions.manual = true
    
            layer:run()
        end)
    end
    
    local legit_aa do
        local function is_nearby(lp_origin, entities)
            for _, ent in next, entities do
                local origin = vector(entity.get_origin(ent))
    
                if lp_origin:dist(origin) < 128 then
                    return true
                end
            end
    
            return false
        end
    
        local entities = { 'CHostage', 'CPlantedC4' }
        local tick = -1
    
        local layer = anti_aim.new('Legit AA', 6)
    end
    
    local defensive_aa do
        defensive_aa = { }
        local layer = anti_aim.new('Defensive', 7)
    
        local modes = {
            ['Double Tap'] = reference.RAGE.double_tap,
            ['Hide Shots'] = reference.RAGE.hide_shots
        }
    
        local manual_offsets = {
            [1] = 90,
            [2] = -90,
            [3] = 0
        }
    
        callbacks['Defensive']['setup_command']:set(function (cmd, lp, valid)
            if not vars.aa.defensive.main.value then
                return
            end
    
            local work_on_mode = true
            --hideshots here defensive
    
            local double_tap = exploit.get()
    
            if not work_on_mode or not double_tap.shift then
                return
            end
    
            local should_work = false
            local on_peek = false
            for _, condition in next, vars.aa.defensive.conditions.value do
                if condition == 'On Peek' then
                    should_work = true
                    on_peek = true
                    break
                else
                    if condition == lp_info.condition then
                        should_work = true
                        break
                    end
                end
            end
    
            if not should_work then
                return
            end
    
            if not on_peek then
                cmd.force_defensive = true
            end
    
            local manual_yaw = manuals.yaw
            local should_flick = false
            local should_skip = reference.is_freestanding() or (manual_yaw ~= 0 and not should_flick)
    
            local pitch_value, pitch_mode = 0, 'Default'
            do
                local val = vars.aa.defensive.pitch.value
                if val == 'Zero' then
                    pitch_value, pitch_mode = 0, 'Custom'
                elseif val == 'Up' then
                    pitch_mode = 'Up'
                elseif val == 'Pitch Swap' then
                    pitch_value, pitch_mode = client.random_float(45, 65) * -1, 'Custom'
                elseif val == 'Down-Switch' then
                    pitch_value, pitch_mode = client.random_float(45, 65), 'Custom'
                elseif val == 'Random' then
                    pitch_value, pitch_mode = client.random_float(-89, 89), 'Custom'
                end
    
                if manual_yaw ~= 0 and should_flick then
                    pitch_value, pitch_mode = client.random_float(-5, 10), 'Custom'
                end
            end
    
            local yaw_value, yaw_mode = 0, '180'
            do
                local val = vars.aa.defensive.yaw.value
                if val == 'Sideways' then
                    yaw_value = lp_info.choking * 90 + client.random_float(-30, 30)
                elseif val == 'Force Defensive' then
                    yaw_value = yaw_mode == 0
                elseif val == 'Spin' then
                    yaw_value = -180 + (globals.tickcount() % 9) * 40 + client.random_float(-30, 30)
                elseif val == 'Random' then
                    yaw_value = client.random_float(-180, 180)
                end
    
                if manual_yaw ~= 0 and should_flick then
                    yaw_value = manual_offsets[ manual_yaw ] + client.random_float(0, 10)
                end
            end
    
            if should_skip or defines.functions.backstab  then 
                return
            end
    
            layer:tick()
    
            layer.enabled[1] = true
    
            if should_flick then
                layer.body_yaw[1] = 'Static'
                layer.body_yaw[2] = 180
            end
    
            if globals.tickcount() > double_tap.defensive_tick - 2 then
                return
            end
    
            layer.pitch[1] = pitch_mode
            layer.pitch[2] = pitch_value
    
            layer.yaw[1] = yaw_mode
            layer.yaw[2] = utilities.normalize(yaw_value)
    
            layer:run()

        end)
    end
    
    local anti_backstab do
        local layer = anti_aim.new('Anti Backstab', 24)
    
        callbacks['Anti Backstab']['setup_command']:set(function (cmd, lp, valid)
            defines.functions.backstab = false
            if not vars.aa.backstab.value or not valid then
                return
            end
    
            if defines.functions.legit then
                return
            end
    
            local target = {
                ent = nil,
                distance = 220
            }
    
            local eye = vector(client.eye_position())
            local enemies = entity.get_players(true)
    
            for _, ent in pairs(enemies) do
                local weapon = entity.get_player_weapon(ent)
                if weapon == nil then
                    goto skip
                end
    
                local weapon_name = entity.get_classname(weapon)
                if weapon_name ~= 'CKnife' then
                    goto skip
                end
    
                local origin = vector(entity.get_origin(ent))
                local distance = eye:dist(origin)
    
                if distance > target.distance then
                    goto skip
                end
    
                target.ent = ent
                target.distance = distance
                ::skip::
            end
    
            if not target.ent then
                return
            end
    
            local origin = vector(entity.get_origin(target.ent))
            local delta = eye - origin
            local angle = vector(delta:angles())
            local camera = vector(client.camera_angles())
            local yaw = utilities.normalize(angle.y - camera.y)
    
            layer:tick()
    
            layer.enabled[1] = true
            layer.yaw_base[1] = 'Local view'
            layer.yaw[2] = yaw
    
            layer:run()
    
            defines.functions.backstab = true
        end)
    end
    
    local fs_disablers do
        local layer = anti_aim.new('Freestanding', 3)
    
        callbacks['Freestanding']['setup_command']:set(function (cmd, lp, valid)
            if not vars.aa_binds.manual.enable then
                return
            end
    
            layer:tick()
    
            local condition = anti_aim.condition(false)
            local should_disable = false
            for _, item in next, vars.aa.freestanding.disablers.value do
                if item == condition then
                    should_disable = true
                    break
                end
            end
    
            local is_active, key = true
    
            layer.freestanding[1] = vars.aa.freestanding.main:get()

            if vars.aa.freestanding.main:get() then
                layer.yaw_modifier[1] = 'Off'
                layer.body_yaw[1] = 'Static'
                layer.body_yaw[2] = 120
            end
            reference.AA.angles.freestanding[1].hotkey:override(is_active and { 'Always on', 0 } or nil)
    
            layer:run()
        end)
    end

    local cur_cmd_num = 0
    local tp_tick = 0
    local pre_tick = nil
    local tp_turn = false
    local teleportsetts = {
        auto_teleport = function(cmd)
            if not vars.misc.teleport:get_hotkey() or not ui.get(reference.RAGE.double_tap[2]) then return end
            

            if main_funcs:in_air() and (cmd.in_forward == 1 or cmd.in_back == 1 or cmd.in_moveleft == 1 or cmd.in_moveright == 1 or cmd.in_jump == 1) then

                    local active = false
                    local players = entity_get_players(true)
                    if players ~= nil then
                        for _, enemy in pairs(players) do
                            local vulnerable = bit.band(entity.get_esp_data(enemy).flags, bit_lshift(1, 11)) == 2048
                            if vulnerable then active = true end
                        end
                    end

                    if active then
                    cmd.force_defensive = true
                    if tp_tick >= 14 then
                        tp_turn = true
                    end
                    if tp_turn and tp_tick == 0 then
                        cmd.discharge_pending = true
                        

                        client.delay_call(0.1, function() cmd.discharge_pending = false end)
                        tp_turn = false
                    end
                end
            end
        end,
        auto_teleport_level_init = function()
            pre_tick, cur_cmd_num = nil, 0
        end,
        auto_teleport_run_cmd = function(cmd)
           if not vars.misc.teleport:get_hotkey() then return end
            cur_cmd_num = cmd.command_number
        end,
        auto_teleport_predict_cmd = function(cmd)
           if not vars.misc.teleport:get_hotkey() then return end
            if cmd.command_number == cur_cmd_num then
                cur_cmd_num = 0
                local lp = entity_get_local_player()
                local tick_base = entity.get_prop(lp, "m_nTickBase")
        
                if pre_tick ~= nil then
                    tp_tick = tick_base - pre_tick
                end
        
                pre_tick = math.max(tick_base, pre_tick or 0)
            end
        end
    }
    
    vars.misc.teleport:set_event("setup_command", teleportsetts.auto_teleport)
    vars.misc.teleport:set_event("run_command", teleportsetts.auto_teleport_run_cmd)
    vars.misc.teleport:set_event("level_init", teleportsetts.auto_teleport_level_init)
    vars.misc.teleport:set_event("predict_command", teleportsetts.auto_teleport_predict_cmd)
    --- region correction
            local correction = { };
    do
            local records = { };

            local function get_server_time(player)
                return entity_get_prop(player, "m_nTickBase") * globals.tickinterval();
            end

            local function get_simulation_time(player)
                return entity_get_prop(player, "m_flSimulationTime");
            end

            local function new_record()
                local record = {
                    is_simtime_update = false,

                    is_jittering = false,
                    is_jittering_prev = false,

                    server_tick = 0,

                    prev_simtime = 0,
                    simtime = 0,

                    prev_eye_yaw = 0,
                    eye_angles = vector(),

                    prev_rotation = 0,
                    rotation = vector(),

                    prev_delta = 0,
                    delta = 0,

                    fakelag_ticks = 0,
                    choked_ticks = 0
                };

                return record;
            end

            local function update_records(player)
                records[player] = records[player]
                    or new_record();

                local record = records[player];

                local simtime = get_simulation_time(player);
                local server_tick = get_server_time(player);

                local rotation = vector(entity_get_prop(player, "m_angRotation"));
                local eye_angles = vector(entity_get_prop(player, "m_angEyeAngles"));

                record.server_tick = server_tick;

                record.old_simtime = record.simtime;
                record.simtime = simtime;

                record.is_simtime_update = record.simtime ~= record.old_simtime;

                if record.is_simtime_update then
                    record.fakelag_ticks = record.choked_ticks;
                    record.choked_ticks = 0;

                    record.prev_eye_yaw = record.eye_angles.y;
                    record.eye_angles = eye_angles;

                    record.prev_rotation = record.rotation.y;
                    record.rotation = rotation;

                    record.prev_delta = record.delta;
                    record.delta = utils.normalize_yaw(record.eye_angles.y - record.prev_eye_yaw);

                    record.is_prev_jittering = record.is_jittering;

                    record.is_jittering = (record.delta > 0 and record.prev_delta < 0)
                        or (record.delta < 0 and record.prev_delta > 0);
                else
                    record.choked_ticks = record.choked_ticks + 1;
                end
            end

            local function remove_correction(player)
                plist.set(player, "Force body yaw", false);
                plist.set(player, "Force body yaw value", 0);
            end

            local function update_correction(player)
                local val23 = vars.misc.resolver_mode.value
                if vars.misc.resolver:get() and vars.misc.resolver_mode.value == "Modern" then
                    local record = records[player];
                    if record == nil then return end

                    local tickcount = globals.tickcount();

                    local jitter_fix = false;
                    local jitter_side = -1;

                    if record.delta > 0 then
                        jitter_side = 1;
                    end

                    local server_tick = toticks(record.server_tick);
                    local latency_tick = toticks(client.real_latency());

                    local arrival_tick = server_tick + latency_tick + 1;
                    local current_tick = arrival_tick - server_tick - 1;

                    local ticks_to_predict_before_arrival = math.min(math.max(arrival_tick - current_tick, 0) + (tickcount - record.server_tick), 8);

                    for tick = 1, ticks_to_predict_before_arrival do
                        jitter_side = -jitter_side;
                    end

                    local avg_body_yaw = (utils.normalize_yaw(record.eye_angles.y) - utils.normalize_yaw(record.prev_eye_yaw)) * jitter_side;
                    

                    if record.is_prev_jittering and record.is_jittering then
                        local abs_body_yaw = math.abs(avg_body_yaw);
                        jitter_fix = abs_body_yaw > 8 and abs_body_yaw < 64;
                        -- print("Correction: ", jitter_fix)
                        -- print("Yaw:", clamp(avg_body_yaw, -60, 60))
                    end

                    plist.set(player, "Force body yaw", jitter_fix);
                    plist.set(player, "Force body yaw value", clamp(avg_body_yaw, -60, 60));
                end
            end

            local function shutdown()
                local enemies = entity.get_players(true);

                for i = 1, #enemies do
                    remove_correction(enemies[i]);
                end
            end


            function correction.shutdown()
                shutdown();
            end

            function correction.net_update()
                
                local val23 = vars.misc.resolver_mode.value
                if not vars.misc.resolver:get() then 
                    return;
                elseif not vars.misc.resolver:get() and not vars.misc.resolver_mode.value == 'Modern' then
                    return;
                end


                local enemies = entity.get_players(true);

                for i = 1, #enemies do
                    local enemy = enemies[i];

                    update_records(enemy);
                    update_correction(enemy);
                end
            end
    end

    client.set_event_callback("shutdown", correction.shutdown);
    client.set_event_callback("net_update_end", correction.net_update);

    
    local fast_ladder do
        callbacks['Fast Ladder']['setup_command']:set(function (cmd, lp, valid)
            if not vars.misc.ladder.value or not valid then
                return
            end
    
            if entity.get_prop(lp, 'm_MoveType') ~= 9 then
                return
            end
    
            local weapon = entity.get_player_weapon(lp)
            if weapon == nil then
                return
            end
    
            local throw_time = entity.get_prop(weapon, 'm_fThrowTime')
    
            if throw_time ~= nil and throw_time ~= 0 then
                return
            end
    
            if cmd.forwardmove > 0 then
                if cmd.pitch < 45 then
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
            elseif cmd.forwardmove < 0 then
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
        end)
    end
    
    local safe_head do
        safe_head = {
            presets = {
                ['Stand'] = {
                    [3] = {
                        offset = 5,
    
                        inverter = false,
    
                        left_limit = 20,
                        right_limit = 20
                    },
    
                    [2] = {
                        offset = 0,
    
                        inverter = false,
    
                        left_limit = 20,
                        right_limit = 25
                    }
                },
    
                ['Crouch'] = {
                    [3] = {
                        offset = -5,
    
                        inverter = true,
    
                        left_limit = 35,
                        right_limit = 60
                    },
    
                    [2] = {
                        offset = 17,
    
                        inverter = false,
    
                        left_limit = 20,
                        right_limit = 26
                    }
                },
    
                ['Aero + Crouch'] = {
                    [3] = {
                        offset = 0,
    
                        inverter = false,
    
                        left_limit = 25,
                        right_limit = 25
                    },
    
                    [2] = {
                        offset = 0,
    
                        inverter = false,
    
                        left_limit = 25,
                        right_limit = 25
                    }
                },
    
                ['CKnife'] = {
                    [3] = {
                        offset = 0,
    
                        inverter = true,
    
                        left_limit = 60,
                        right_limit = 60
                    },
    
                    [2] = {
                        offset = 0,
    
                        inverter = true,
    
                        left_limit = 60,
                        right_limit = 60
                    }
                },
    
                ['CWeaponTaser'] = {
                    [3] = {
                        offset = 23,
    
                        inverter = false,
    
                        left_limit = 60,
                        right_limit = 30
                    },
    
                    [2] = {
                        offset = 17,
    
                        inverter = false,
    
                        left_limit = 20,
                        right_limit = 60
                    }
                }
            },
    
            weapon = false,
            on_condition = false,
            is_air_weapon = false
        }
    
        local layer = anti_aim.new('Safe Head', 15)
    
        callbacks['Safe Head']['setup_command']:set(function (cmd, lp, valid)
            defines.functions.safe = false
            safe_head.weapon = false
    
            if #vars.aa.safe.value == 0 or defines.functions.legit or manuals.yaw ~= 0 then
                return
            end
    
            safe_head.on_condition = false
            safe_head.is_air_weapon = false
            safe_head.classname = 0
    
            local condition = lp_info.condition
    
            if condition == 'Aero + Crouch' and not safe_head.on_condition then
                local weapon = entity.get_player_weapon(lp)
    
                if weapon then
                    local classname = entity.get_classname(weapon)
                    safe_head.classname = classname
                    if classname == 'CKnife' then
                        safe_head.on_condition = vars.aa.safe:get('Knife')
                    elseif classname == 'CWeaponTaser' then
                        safe_head.on_condition = vars.aa.safe:get('Zeus')
                    end
    
                    safe_head.is_air_weapon = true
                end
            end
    
            if not safe_head.on_condition then
                for _, condition in next, vars.aa.safe.value do
                    if lp_info.condition == condition then
                        safe_head.on_condition = true
                        break
                    end
                end
            end
    
            if not safe_head.on_condition then
                return
            end
    
            defines.functions.safe = safe_head.is_air_weapon
    
            if not defines.functions.safe then
                local start = vector(entity.get_origin(lp))
                local player = client.current_threat()
                local z_origin = 0
    
                if player and entity.is_alive(player) then
                    local eye_pos = utilities.extrapolate(player, vector(utilities.get_eye_position(player)))
                    local head_pos = vector(entity.hitbox_position(lp, 0))
                    eye_pos.z = eye_pos.z + 5
    
                    if head_pos.z > eye_pos.z then
                        local entindex, damage = client.trace_bullet(player, eye_pos.x, eye_pos.y, eye_pos.z, head_pos.x, head_pos.y, head_pos.z + 6, player)
    
                        defines.functions.safe = damage > 0
                    end
                end
            end
    
            safe_head.weapon = safe_head.is_air_weapon
    
            layer:tick()
    
            if defines.functions.safe then
                local current_preset = safe_head.is_air_weapon and safe_head.presets[ safe_head.classname ] or safe_head.presets[ lp_info.condition ]
                if not current_preset then
                    return
                end
    
                local preset_for_team = current_preset[ entity.get_prop(lp, 'm_iTeamNum') ]
                if not preset_for_team then
                    return
                end
    
                layer.enabled[1] = true
                layer.yaw_base[1] = 'At targets'
                layer.yaw[2] = preset_for_team.offset
                layer.yaw_modifier[1] = 'Off'
                layer.body_yaw[1] = 'Static'
                layer.body_yaw[2] = preset_for_team.inverter and -120 or 120
                layer.pitch[1] = 'Default'
            end
    
            layer:run()
        end)
    end
    
    local builder do
        local layer = anti_aim.new('Builder', 1)
        local randomized_val = 0
    
        callbacks['Builder']['setup_command']:set(function (cmd, lp, valid)
            if not valid then
                return
            end
        

            local condition = anti_aim.condition(vars.conditions['Fake Lag'].enabled.value)
            if not vars.conditions[ condition ].enabled.value then
                condition = 'Global'
            end
        
            layer:tick()
        
            local yaw = vars.conditions[ condition ].yaw.value
            local yaw_offset = vars.conditions[ condition ].yaw_offset.value
        
            local yaw_modifier = vars.conditions[ condition ].yaw_modifier.value
            local yaw_modifier_offset = vars.conditions[ condition ].yaw_modifier_offset.value
            local yaw_modifier_randomize = vars.conditions[ condition ].yaw_modifier_randomize.value
        
            local body_yaw = vars.conditions[ condition ].body_yaw.value
            local body_yaw_offset = vars.conditions[ condition ].body_yaw_offset.value
            local bodyYaw = entity.get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * 120 - 60
            local side = bodyYaw > 0 and 1 or -1
        
            if yaw == 'L & R' then

                
                yaw = '180'
        
                local inverted = lp_info.body_yaw > 0
        
                if vars.conditions[ condition ].multikulti.value == "Delayed" then
                    local delay = vars.conditions[ condition ].yaw_delay.value
                    local target = delay * 2

                    
        
                    inverted = (lp_info.chokes % target) >= delay
                   -- yaw_offset = inverted and vars.conditions[ condition ].yaw_left.value or vars.conditions[ condition ].yaw_right.value
        
                    body_yaw = 'Static'
                    body_yaw_offset = inverted and 1 or -1
                end
        
                yaw_offset = side == 1 and vars.conditions[ condition ].yaw_left.value or vars.conditions[ condition ].yaw_right.value
            end
        
            if yaw_modifier_randomize ~= 0 then
                if lp_info.chokes % 2 == 0 or randomized_val == nil then
                    randomized_val = client.random_int(0, (yaw_modifier_offset > 0 and 1 or -1) * yaw_modifier_randomize)
                end
        
                yaw_modifier_offset = utilities.normalize(yaw_modifier_offset + randomized_val)
            end
        
            layer.enabled[1] = true
            layer.pitch[1] = vars.conditions[ condition ].pitch.value
            layer.pitch[2] = vars.conditions[ condition ].pitch_value.value
        
            layer.yaw_base[1] = vars.conditions[ condition ].yaw_base.value
            layer.yaw[1] = yaw
            layer.yaw[2] = utilities.normalize(yaw_offset)
        
            layer.yaw_modifier[1] = yaw_modifier
            layer.yaw_modifier[2] = yaw_modifier_offset
        
            layer.body_yaw[1] = body_yaw
            layer.body_yaw[2] = body_yaw_offset
            layer.freestanding_byaw[1] = vars.conditions[ condition ].freestanding.value
        
            layer:run()
        end)
    end
    
local indicate_state = { };


    local indicators do
        indicators = {
            alpha = tweening.new(),
            align = tweening.new(0, easings.outCirc),
            dt = tweening.new(),
            blind = tweening.new(0, easings.outQuad),
    
            damage = tweening.new(),
            damage_num = tweening.new()
        }
    
        indicators.items = {
            {
                text = 'DT',
    
                state = function ()
                    local status, key = ui.get(reference.RAGE.double_tap[2])
                    return status
                end,
    
                clr = function ()
                    local data = exploit.get()
    
                    local color = { utilities.color_lerp(255, 0, 0, 255, 255, 255, 255, 255, indicators.dt(.2, data.shift)) }
    
                    return color
                end,
    
                alpha = tweening.new()
            },
    
            {
                text = 'OS',
    
                state = function ()
                    local status, key = ui.get(reference.RAGE.hide_shots[2])
                    return status
                end,
    
                alpha = tweening.new()
            },
    
            {
                text = 'DUCK',
    
                state = function ()
                    local status, key = reference.RAGE.fakeduck:get()
                    return status
                end,
    
                alpha = tweening.new()
            },
    
            {
                text = 'BAIM',
    
                state = function ()
                    local status, key = reference.RAGE.force_body_aim:get()
                    return status
                end,
    
                alpha = tweening.new()
            },
    
            {
                text = 'SAFE',
    
                state = function ()
                    local status, key = reference.RAGE.force_safe_point:get()
                    return status
                end,
    
                alpha = tweening.new()
            },
    
            {
                text = 'FS',
    
                state = function ()
                    local status, key = reference.AA.angles.freestanding[1]:get_hotkey()
                    return status and reference.AA.angles.freestanding[1]:get()
                end,
    
                alpha = tweening.new()
            }
        }
    
        function indicators.get_state()
            if defines.functions.backstab then
                return 'BACKSTAB'
            end
    
            if defines.functions.safe then
                return 'SAFE'
            end
    
            return lp_info.condition
        end
    
        callbacks['Indicators']['paint']:set(function (lp, valid)
            local modes = vars.visuals.indicators_style.value
            if vars.visuals.indicators:get() and modes == "Default" then

                local global_alpha = indicators.alpha(.2, 255 and valid)
                local modes = vars.visuals.indicators_style

                if global_alpha < 0.001 then
                    return
                end
            
                local weapon = entity.get_player_weapon(lp)
                if weapon == nil then
                    return
                end
            
                local c_weapon = c_weapon(weapon)
                if c_weapon == nil then
                    return
                end

                local blind = indicators.blind(.2, c_weapon.is_grenade and 0.3 or 1)
            
                local scoped = lp and entity.get_prop(lp, 'm_bIsScoped') == 1 or false
                local scoped_anim = indicators.align(.1, not scoped)
            
                local zone = defines.screen_center:clone() do
                    zone.x = zone.x + (5 - 5 * scoped_anim)
                    zone.y = zone.y + 20
                end
            
                local r, g, b, a = vars.visuals.indicators_color:get_color()
                local pulseSpeed = 1.5
                local alpha = math.abs(math.sin(globals.realtime() * pulseSpeed)) * 255
                a = 255 * global_alpha * blind
            
                local heading = string.format('ASTRA \a%s%s', utilities.to_hex(r, g, b, alpha), defines.build:upper()) do
                    local heading_size = renderer.measure_text('-', heading) * .5 * scoped_anim
            
                    renderer.text(zone.x - heading_size, zone.y, 255, 255, 255, a, '-', nil, heading)
                    zone.y = zone.y + 8
                end
            
                local condition = string.upper(indicators.get_state()) do
                    local condition_size = renderer.measure_text('-', condition) * .5 * scoped_anim
            
                    renderer.text(zone.x - condition_size, zone.y, r, g, b, a, '-', nil, condition)
                    zone.y = zone.y + 8
                end
            
                local offset = 0
                for _, item in next, indicators.items do
                    local bind_alpha = item.alpha(.1, item.state())
                    if bind_alpha < 0.001 then
                        goto skip
                    end
            
                    local clr = item.clr and item.clr() or { 255, 255, 255, 255 }
                    local b_r, b_g, b_b = unpack(clr)
                    local text_size = renderer.measure_text('-', item.text) * .5 * scoped_anim
            
                    renderer.text(zone.x - text_size, zone.y + offset, b_r, b_g, b_b, a * bind_alpha, '-', nil, item.text)
                    offset = offset + 8 * bind_alpha
                    ::skip::
                end
            elseif vars.visuals.indicators:get() and modes == "New" then
            end            
                
        end)
    end

    local software = {};
do
    software.rage = {
        weapon = {
            weapon_type = ui.reference("Rage", "Weapon type", "Weapon type")
        },

        aimbot = {
            enabled = { ui.reference("Rage", "Aimbot", "Enabled") },
            target_selection = ui.reference("Rage", "Aimbot", "Target selection"),
            minimum_damage = ui.reference("Rage", "Aimbot", "Minimum damage"),
            minimum_damage_override = { ui.reference("Rage", "Aimbot", "Minimum damage override") },
            prefer_safe_point = ui.reference("Rage", "Aimbot", "Prefer safe point"),
            force_safe_point = ui.reference("Rage", "Aimbot", "Force safe point"),
            force_body_aim = ui.reference("Rage", "Aimbot", "Force body aim"),
            double_tap = { ui.reference("Rage", "Aimbot", "Double tap") }
        },

        other = {
            quick_peek_assist = { ui.reference("Rage", "Other", "Quick peek assist") },
            duck_peek_assist = ui.reference("Rage", "Other", "Duck peek assist")
        }
    };

    software.aa = {
        angles = {
            enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
            pitch = { ui.reference("AA", "Anti-aimbot angles", "Pitch") },
            yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
            yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
            yaw_jitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
            body_yaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
            freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
            edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
            freestanding = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
            roll = ui.reference("AA", "Anti-aimbot angles", "Roll")
        },

        fakelag = {
            enabled = { ui.reference("AA", "Fake lag", "Enabled") },
            amount = ui.reference("AA", "Fake lag", "Amount"),
            variance = ui.reference("AA", "Fake lag", "Variance"),
            limit = ui.reference("AA", "Fake lag", "Limit")
        },

        other = {
            slow_motion = { ui.reference("AA", "Other", "Slow motion") },
            leg_movement = ui.reference("AA", "Other", "Leg movement"),
            on_shot_antiaim = { ui.reference("AA", "Other", "On shot anti-aim") },
            fake_peek = { ui.reference("AA", "Other", "Fake peek") }
        }
    };

    software.visuals = {
        colored_models = {
            local_player_transparency =ui.reference("Visuals", "Colored models", "Local player transparency")
        }
    };

    software.misc = {
        miscellaneous = {
            clan_tag_spammer = { ui.reference("Misc", "Miscellaneous", "Clan tag spammer") },
            ping_spike = { ui.reference("Misc", "Miscellaneous", "Ping spike") }
        },

        settings = {
            menu_color = ui.reference("Misc", "Settings", "Menu color"),
            dpi_scale = ui.reference("Misc", "Settings", "DPI scale"),
            sv_maxusrcmdprocessticks = ui.reference("Misc", "Settings", "sv_maxusrcmdprocessticks2")
        }
    };

    function software.is_double_tap()
        return ui.get(software.rage.aimbot.double_tap[1])
            and ui.get(software.rage.aimbot.double_tap[2]);
    end

    function software.is_minimum_damage()
        return ui.get(software.rage.aimbot.minimum_damage_override[1])
            and ui.get(software.rage.aimbot.minimum_damage_override[2]);
    end

    function software.is_quick_peek_assist()
        return ui.get(software.rage.other.quick_peek_assist[1])
            and ui.get(software.rage.other.quick_peek_assist[2]);
    end

    function software.is_on_shot_antiaim()
        return ui.get(software.aa.other.on_shot_antiaim[1])
            and ui.get(software.aa.other.on_shot_antiaim[2]);
    end

    function software.is_slow_motion()
        return ui.get(software.aa.other.slow_motion[1])
            and ui.get(software.aa.other.slow_motion[2]);
    end

    function software.get_color()
        return ui.get(software.misc.settings.menu_color);
    end

    function software.get_dpi_scale()
        local value = ui.get(software.misc.settings.dpi_scale);
        local unit = string_match(value, "(%d+)%%");

        return unit * 0.01;
    end
end

--- constants
local PLAYER_FLAGS = {
    FL_ONGROUND = bit_lshift(1, 0),
    FL_FROZEN   = bit_lshift(1, 5)
};

local ESP_FLAGS = {
    HIT = bit_lshift(1, 11)
};



--  client.set_event_callback("net_update_end", localplayer.net_update);




    local traditional = { }; do
            local last_state = "STATE";
    
            local alpha = 0.0;
            local align = 0.0;
    
            local statement_alpha = 0.0;
            local statement_value = 0.0;
    
            local dmg_alpha = 0.0;
            local dmg_value = 0.0;
    
            local dt_alpha = 0.0;
            local dt_value = 0.0;
    
            local osaa_alpha = 0.0;
            local osaa_value = 0.0;
    
            local fs_alpha = 0.0;
            local fs_value = 0.0;
    
            local function get_state()
    
                return string.upper(indicators.get_state());
            end
    
            local function update_global_animations()
                if vars.visuals.indicators:get() and modes == "New" then
                    alpha = motion.interp(alpha, 0.0, 0.05);
                    align = motion.interp(align, 1.0, 0.05);
    
                    return;
                end
    
                local me = entity_get_local_player();
                if me == nil then return end
    
                local wpn = entity_get_player_weapon(me);
                local m_bIsScoped = entity.get_prop(me, "m_bIsScoped");
    
                local target_alpha = 0.0;
                local target_align = 0.0;
    
                if entity_is_alive(me) then
                    target_alpha = 1.0;
                end
    
                -- if weapon is grenade
    
                if wpn ~= nil then
                    local wpn_info = c_weapon(wpn);
    
                    if wpn_info.weapon_type_int == 9 then
                            target_alpha = 0.25;
                            target_align = 0.0;
                    end
                end
    
                if m_bIsScoped == 1 then
                        target_alpha = 0.75;
                        target_align = 1.0;
                end
    
                alpha = motion.interp(alpha, target_alpha, 0.05);
                align = motion.interp(align, target_align, 0.05);
            end
    
            local function update_feature_animations()
                if alpha == 0.0 then
                    return;
                end
    
                local shift = exploit.get().shift;
                local state = get_state();
    
                statement_alpha = motion.interp(statement_alpha, true, 0.05);
                statement_value = motion.interp(statement_value, state == last_state, 0.075);
    
                dmg_alpha = motion.interp(dmg_alpha, software.is_minimum_damage(), 0.05);
                dmg_value = motion.interp(dmg_value, true, 0.05);
    
                dt_alpha = motion.interp(dt_alpha, software.is_double_tap(), 0.05);
                dt_value = motion.interp(dt_value, shift, 0.05);
    
                osaa_alpha = motion.interp(osaa_alpha, software.is_on_shot_antiaim(), 0.05);
                osaa_value = motion.interp(osaa_value, shift or dt_alpha > 0.0, 0.05);
    
                if statement_value < 0.1 then
                    last_state = state;
                end
            end
    
            function traditional.think()
                update_global_animations();
                update_feature_animations();
            end
            function traditional.draw()
                if alpha == 0.0 then
                    return;
                end
    
                local clock = globals_realtime() * 1.25;
    
                local screen = vector(client.screen_size());
                local position = screen * 0.5;
    
                local r0, g0, b0, a0 = 71, 71, 71, 255;
                local r1, g1, b1, a1 = vars.visuals.indicators_color:get_color()
    
                a1 = math.max(a1, 55);
                a0 = a1;
    
                position.x = position.x + round(10 * align);
                position.y = position.y + 18;
    
                do
                    local text_pos = position:clone();
                    local text_alpha = alpha;
    
                    local text = "astrasys";
                    local flags = "db";
                    
    
                    local r, g, b, a = r1, g1, b1, a1;
    
                    local measure = vector(renderer.measure_text(flags, text));
                    local offset = (measure.x * 0.5) * (1 - align);
    
                    text_pos.x = round(text_pos.x - offset);
    
                    text = decorations.wave(text, clock, r1, g1, b1, a1 * text_alpha, r0, g0, b0, a0 * text_alpha);
                    renderer_text(text_pos.x, text_pos.y, r, g, b, a * alpha, flags, 0, text);
    
    
                    position.y = position.y + measure.y;
                end
    
                if statement_alpha > 0.0 then
                    local text_pos = position:clone();
                    local text_alpha = alpha * statement_alpha;
    
                    local text = last_state;
                    local flags = "-d";
    
                    local r, g, b, a = r1, g1, b1, a1;
    
                    local measure = vector(renderer.measure_text(flags, text));
                    local offset = (measure.x * 0.5) * (1 - align);
    
                    text_pos.x = round(text_pos.x - offset) - 1;
    
                    text = decorations.fade(text, statement_value, r1, g1, b1, a1 * text_alpha, r0, g0, b0, a0 * text_alpha);
                    renderer_text(text_pos.x, text_pos.y, r, g, b, a * text_alpha, flags, 0, text);
    
                    position.y = position.y + round(measure.y * statement_alpha);
                end
    
                if dmg_alpha > 0.0 then
                    local text_pos = position:clone();
                    local text_alpha = alpha * dmg_alpha;
    
                    local text = "DMG";
                    local flags = "-d";
    
                    local r, g, b, a = r1, g1, b1, a1;
    
                    local measure = vector(renderer.measure_text(flags, text));
                    local offset = (measure.x * 0.5) * (1 - align);
    
                    text_pos.x = round(text_pos.x - offset) - 1;
    
                    text = decorations.fade(text, dmg_value, r1, g1, b1, a1 * text_alpha, r0, g0, b0, a0 * text_alpha);
                    renderer_text(text_pos.x, text_pos.y, r, g, b, a * text_alpha, flags, 0, text);
    
                    position.y = position.y + round(measure.y * dmg_alpha);
                end
    
                if dt_alpha > 0.0 then
                    local text_pos = position:clone();
                    local text_alpha = alpha * dt_alpha;
    
                    local text = "DT";
                    local flags = "-d";
    
                    local r, g, b, a = r1, g1, b1, a1;
    
                    local measure = vector(renderer.measure_text(flags, text));
    
                    local radius = round(measure.y * 0.33);
                    local thickness = round(radius * 0.25);
    
                    local gap = 4;
                    local margin = radius + gap;
    
                    local offset = (measure.x + margin) * (0.5) * (1 - align);
    
                    text_pos.x = round(text_pos.x - offset) - 1;
    
                    text = decorations.fade(text, dt_value, r1, g1, b1, a1 * text_alpha, r0, g0, b0, a0 * text_alpha);
                    renderer_text(text_pos.x, text_pos.y, r, g, b, a * text_alpha, flags, 0, text);
    
                    text_pos.x = text_pos.x + measure.x;
                    renderer.circle_outline(text_pos.x + margin, text_pos.y + measure.y * 0.5, r, g, b, a * text_alpha, radius, 180, dt_value, thickness);
    
                    position.y = position.y + round(measure.y * dt_alpha);
                end
    
                if osaa_alpha > 0.0 then
                    local text_pos = position:clone();
                    local text_alpha = alpha * osaa_alpha;
    
                    local text = "OSAA";
                    local flags = "-d";
    
                    local r, g, b, a = r1, g1, b1, a1;
    
                    local measure = vector(renderer.measure_text(flags, text));
                    local offset = (measure.x * 0.5) * (1 - align);
    
                    text_pos.x = round(text_pos.x - offset) - 1;
    
                    text = decorations.fade(text, osaa_value, r1, g1, b1, a1 * text_alpha, r0, g0, b0, a0 * text_alpha);
                    renderer_text(text_pos.x, text_pos.y, r, g, b, a * text_alpha, flags, 0, text);
    
                    position.y = position.y + round(measure.y * osaa_alpha);
                end
    
                if fs_alpha > 0.0 then
                    local text_pos = position:clone();
                    local text_alpha = alpha * fs_alpha;
    
                    local text = "FS";
                    local flags = "-d";
    
                    local r, g, b, a = r1, g1, b1, a1;
    
                    local measure = vector(renderer.measure_text(flags, text));
                    local offset = (measure.x * 0.5) * (1 - align);
    
                    text_pos.x = round(text_pos.x - offset) - 1;
    
                    text = decorations.fade(text, fs_value, r1, g1, b1, a1 * text_alpha, r0, g0, b0, a0 * text_alpha);
                    renderer_text(text_pos.x, text_pos.y, r, g, b, a * text_alpha, flags, 0, text);
    
                    position.y = position.y + round(measure.y * fs_alpha);
                end
            end
    end

    function indicate_state.frame()
        if not iengineclient.is_in_game() then
            return;
        end

        local modes = vars.visuals.indicators_style.value
        if vars.visuals.indicators:get() and modes == "New" then

            traditional.think();
            traditional.draw();
        end
    end
    client.set_event_callback("paint_ui", indicate_state.frame);


    
    local watermark do
        watermark = {
            alpha = tweening.new(),
            width = tweening.new(0, easings.outQuad),
    
            latency = nil,
            latency_update = 0,
    
            framerate = nil,
            framerate_update = 0,
    
            time = nil,
            time_update = 0
        }
    
        local framerate = 0
        local last_framerate = 0
    
        local function get_framerate()
            framerate = 0.9 * framerate + (1.0 - 0.9) * globals.absoluteframetime()
            return last_framerate
        end

        local separator = ' \a96B0BAFF|\aFFFFFFFF '
    
    end
    
    local animations do
        animations = {
            reset = false
        }
    
        function animations.backups()
            if animations.reset then
                animations.reset = false
                reference.AA.other.leg_movement:override()
            end
        end
    
        callbacks['Animation Breakers']['pre_render']:set(function (lp, valid)
            if not vars.misc.breakers.main.value or not valid then
                return animations.backups()
            end
    
            local ent = c_entity(lp)
            if ent == nil then
                return animations.backups()
            end
    
            if lp_info.move_type == 8 or lp_info.move_type == 9 then
                return animations.backups()
            end
    
            if lp_info.on_ground and not lp_info.air then
                local mode = vars.misc.breakers.ground.value
                if mode ~= 'Disabled' then
                    if mode == 'Static' then
                        entity.set_prop(lp, 'm_flPoseParameter', 1, 0)
                        reference.AA.other.leg_movement:override('Always slide')
                        animations.reset = true
                    elseif mode == 'Jitter' then
                        entity.set_prop(lp, 'm_flPoseParameter', .5, 7)
                        reference.AA.other.leg_movement:override('Never slide')
                        animations.reset = true
                    end
                else
                    animations.backups()
                end
            else
                local mode = vars.misc.breakers.air.value
                if mode ~= 'Disabled' then
                    if mode == 'Static' then
                        entity.set_prop(lp, 'm_flPoseParameter', 1, 6)
                    elseif mode == 'Jitter' then
                        local layers = ent:get_anim_overlay(6)
                        layers.weight = 1
                    end
                end
            end
        end)
    end

    local clantag do
        clantag = { }
    
        local clantag_prefix = '\t'
        local clantag_suffix = '\t'
        local clantag_index = -1
        local clantag_array = ''
    
        function clantag.build(x)
            local temp = { }
            local len = #x
    
            if len < 2 then
                table.insert(temp, x)
                return temp
            end
    
            for i = 1, 8 do
                table.insert(temp, string.format('%s%s%s', clantag_prefix, x, clantag_suffix))
            end
    
            for i = 1, len do
                local part = x:sub(i, len)
                table.insert(temp, string.format('%s%s%s', clantag_prefix, part, clantag_suffix))
            end
    
            table.insert(temp, string.format('%s%s', clantag_prefix, clantag_suffix))
    
            for i = math.min(2, len), len do
                local part = x:sub(1, i)
                table.insert(temp, string.format('%s%s%s', clantag_prefix, part, clantag_suffix))
            end
    
            for i = 1, 4 do
                table.insert(temp, string.format('%s%s%s', clantag_prefix, x, clantag_suffix))
            end
    
            return temp
        end
    
        local clantag_array = clantag.build('astra')
    
        callbacks['Clantag']['net_update_end']:set(function (me, alive)
            if not vars.misc.clantag.value then
                return
            end
    
            if me == nil or entity.get_prop(me, 'm_iTeamNum') == 0 then
                return
            end
    
            local latency = client.real_latency() / globals.tickinterval()
            local predicted = globals.tickcount() + latency
    
            local idx = math.floor(predicted * 0.0625) % #clantag_array + 1
    
            if idx == clantag_index then
                return
            end
    
            clantag_index = idx
    
            client.set_clan_tag(clantag_array[ idx ] or '')
        end)
    end

    local mul, wielkosc = 1000000000, 20 
    local preset1 = '|INFO|FF BP NN|I|40|O|1|HL|1|NHL|10|LR|0.3|BW|-1.1559066392366e-05{-1.1202450064138,-0.43692358428945,-0.13930987099988,1.2473693747317,-1.0512952920563,1.3270403255733,-1.3048390365862,0.67144977762124,0.22895362182248,-0.80409868646125,0.80970370419299,-0.094876011124505,1.8085297300312,-3.1213051697127,0.15564586269487,1.243941161686,-0.63451864091975,0.85274078529101,1.2094977572229,0.62863360591113,-0.65126689180398,-0.59910446978325,-0.27530302959635,-0.37900970996814,-0.45176552529037,0.55370533700818,0.64138597420234,0.55680960465419,-0.61526474930497,0.3636652929368,-0.065175113965139,-0.36903881731361,0.12405837818835,-0.73977745618948,0.63540725046327,-0.45414746029774,0.79157121985721,-0.42317748048187,0.079063967276199,0.94263076966404,}3.1873687881385e-07{-0.33085972681749,1.3974765045622,-0.53805929633813,-0.67028441463719,0.9546600346727,-0.20504330455771,0.14603469737588,-0.22584991835587,-0.59708982950384,-0.096585443153326,-0.40914869100385,0.15252807361841,0.76983088009555,0.1135895273262,-0.046635440565021,0.052936898188129,0.43810347271126,0.7730153833329,0.66231510990403,0.58338534121945,0.86213212067021,0.87378351704409,-0.91200616034745,0.96259979650566,0.48645308856345,-0.62811218755657,0.37356359696407,0.85840784699586,0.53809980261285,0.67041507564095,-0.28260659218288,-0.83469318664078,-0.71786782846342,0.20177599197934,0.5580614689448,-0.14722750093401,-0.8674737129836,-0.12700793895558,0.18537378239585,0.64549671395507,}4.2982839371136e-06{-0.25445981857133,0.13249673996283,-0.2718035127553,-0.72430954461389,1.4232117247034,-0.33952965981642,1.6825855658027,0.4430270099209,0.15716956679741,1.1364623417016,-1.2811299615557,-2.467200066115,-0.36174012131967,2.7037878931814,-0.34114087452533,-1.7333547565663,-1.0167292273294,-0.80970388354612,0.1237717895204,0.36641949687082,-0.11871201536506,-0.8181383753111,-0.25342722612542,0.38346749694153,0.33325877812144,-0.26414654291822,0.14819168394517,-0.077031835047591,-0.16050719194423,0.21618455873618,-0.54693088064852,-0.23786000247078,-0.59803675764093,1.0923008303097,0.17366075046142,0.54290923518083,0.60140644190717,0.05974144182409,-0.10139665145658,-0.15275546046583,}5.1234789449184e-08{-0.18017558513543,-0.18146265689724,0.19828598581944,0.44190756360128,-0.22332667322822,0.30169325630054,0.97082021620136,-0.23322485853026,-0.65912975643021,1.3692117676815,-0.72319483106828,-1.0883591535332,-0.46589031854902,-0.073792583922551,0.36310819165966,-0.0053283265286844,0.47961491373351,1.0974451087232,-0.70320902143542,-0.087953350778685,1.0191600187128,0.17360115911924,0.069900569787577,-0.16813379753614,0.58380508079408,0.059608837989604,-0.73024469728429,0.13274871928125,0.11332417366227,-0.31200221713205,0.23947432231531,1.0454803228932,0.8758172416385,-0.46659133456749,-0.01452242480419,0.48269143866338,-0.1505119234022,-0.53428273563778,1.1124781201795,0.7158579485146,}-1.5923623174481e-07{0.85339968189486,-0.0031680515790833,-0.39202082971167,-0.01225315528781,-0.57344056356219,1.2631862215949,0.047128925306942,-1.4902526401776,-0.090282461185964,0.0051083609777073,0.31153197386897,0.17016429041934,1.659032504245,-0.73128928650677,0.4670939328216,0.028794360062452,-0.835364828446,1.0444326143459,0.32932243316448,0.19423058285795,0.064800248455427,0.44604158652933,-0.88846000046558,0.26087480381279,-0.31110295966076,-0.29340717912116,0.3893207825555,-0.12011290761793,0.74345863790375,0.91991374081139,0.58451763390618,1.0669202255176,0.9151380516102,-0.48160558880747,0.92929454785814,0.28369332396192,0.51683013032091,-0.90813461356797,0.11724769174449,-0.95568308718194,}-2.6915435839416e-06{0.15231248617089,-0.53598711108745,-1.0728578555855,0.36259922426732,0.031027769372601,0.26773876558409,0.64368096063365,-0.25774347079668,-0.54249611885042,-0.37569923896152,1.3102568839229,1.3606470022779,1.315893134815,-1.3041749157242,-0.11526832004411,0.92184110918755,-0.093661224545601,-0.88577712061228,0.63818458911472,-0.26442642654138,-1.1176712678031,0.25360377550678,0.3515439997362,-0.69789425814896,-0.4687938342845,0.82667253233937,0.467816069347,0.44591920582718,0.05545307746697,-0.60233019250446,-0.71215641270195,-0.53751447248309,-0.45065874409576,0.42354298216433,-0.0014788537422028,-0.73425343246317,0.47007202514344,-0.46357977355352,-1.2892936180133,-0.048225560467511,}-2.2203811792948e-07{-0.35923888252987,-0.20438667385787,-0.19124147250491,0.76882231523259,0.60367368248321,-1.0389538006775,-0.61313909750184,0.40870492709999,-0.72515795426014,-1.0689391477852,0.87347072473302,0.91819843344018,-0.20062971447343,0.40036925489807,-0.041060377554657,-0.49109735768139,-0.66679007149362,-0.36921711689963,0.22104603934927,-0.16034076612188,0.14148837206228,0.30385765762427,0.77164356236879,0.84512822072436,0.45189599713861,-0.32517192253332,0.97068735065427,0.93647534203954,0.88377609020537,-0.70700992716569,0.93760202670951,0.059062141340008,0.54097694578813,-0.53362426864334,-0.33198341878765,-0.84667381438854,1.095885343958,0.66440180345932,-0.53341022968168,-0.31280200102565,}-7.7144999220949e-08{0.2099088837233,0.41124969823218,0.26237623960241,0.010632764815006,-0.69550129162016,1.0309324303167,-2.3945268806069,-1.0900830278076,-0.97074897000463,-0.64712273581935,-0.14397363140143,-0.62111675762407,-0.50609306043648,-1.1836989201552,-0.27635932911943,-0.021133962558542,-0.71273397289237,-0.76600974074245,-0.25077719867282,-0.81734393863832,0.47239605660163,-0.66353076564059,0.86867198848571,-0.79615191780073,-0.0022895055875506,0.64980972601548,-0.16107170872416,0.80976610335076,0.94472563914824,-0.53645065120444,0.030698189248155,0.34301072287199,-0.3691108833124,-0.12511525153045,-1.1246609938741,-0.41765170598958,-0.30162418790371,-0.28050202302667,0.84343770289887,0.34903091158625,}8.0352707438157e-08{-0.51405999934921,0.0044459209144511,0.30461398228033,0.95000878369673,0.16155907388394,0.42705049012585,0.65182535858805,0.65344203842455,0.27293328175436,1.1721316374074,-0.034035069744857,-0.43404730540217,-0.68429164676573,-0.32332730912654,0.56993065489951,-0.014621209625948,-0.11099663675097,1.3579581445072,-0.27863263894567,-0.55714914897038,-0.60478575969188,-0.49545399672518,0.71208007180686,0.48439443134997,0.12846042466121,0.55861815908385,1.0799294894551,0.12195062728068,-0.90166846045791,-0.51862481544792,-0.24235415755116,-0.19301095955542,1.1633646789943,0.84032850506353,-0.57698419406506,0.686434184688,0.37527363998036,0.010136967906187,-0.39289912738176,-0.52391641291929,}3.9142267087638e-06{-0.42098484784357,-0.25546825964372,-0.76476298796809,0.8142147066408,1.5127730763427,-0.75631497465614,0.28598238176559,-0.33012846499604,-0.91616485085432,0.81551319574826,0.53773987298677,0.26636333938819,-1.0291460002793,1.1510905341627,0.66077086811555,-1.0384144522199,-0.32567602055811,1.0394917903945,0.77196468624017,0.50600831732912,-0.26120500875638,-0.95893895895136,-0.064147992016425,0.072218774618524,-1.1388010084736,-0.73853337106534,-0.24610589258136,0.02514605332215,0.54960616687421,0.75275549013141,0.67453346700391,-0.60164983523389,0.50611628328965,-0.58695247773995,0.54917372627756,-0.32598410448479,0.57677346537166,0.77028748812782,-0.72799863028805,0.51131434164369,}-9.345162504613e-06{5.293159010446,-0.89468979823207,-5.2575120035085,-1.1118852011227,1.61133844062,3.2848256677548,0.1746561427601,3.4871115367329,-0.44974464033245,-2.588796188171,}|END|'
    local preset12 = '|INFO|FF BP NN|I|40|O|1|HL|1|NHL|10|LR|0.3|BW|-1.1559066392366e-05{-1.1202450064138,-0.43692358428945,-0.13930987099988,1.2473693747317,-1.0512952920563,1.3270403255733,-1.3048390365862,0.67144977762124,0.22895362182248,-0.80409868646125,0.80970370419299,-0.094876011124505,1.8085297300312,-3.1213051697127,0.15564586269487,1.243941161686,-0.63451864091975,0.85274078529101,1.2094977572229,0.62863360591113,-0.65126689180398,-0.59910446978325,-0.27530302959635,-0.37900970996814,-0.45176552529037,0.55370533700818,0.64138597420234,0.55680960465419,-0.61526474930497,0.3636652929368,-0.065175113965139,-0.36903881731361,0.12405837818835,-0.73977745618948,0.63540725046327,-0.45414746029774,0.79157121985721,-0.42317748048187,0.079063967276199,0.94263076966404,}3.1873687881385e-07{-0.33085972681749,1.3974765045622,-0.53805929633813,-0.67028441463719,0.9546600346727,-0.20504330455771,0.14603469737588,-0.22584991835587,-0.59708982950384,-0.096585443153326,-0.40914869100385,0.15252807361841,0.76983088009555,0.1135895273262,-0.046635440565021,0.052936898188129,0.43810347271126,0.7730153833329,0.66231510990403,0.58338534121945,0.86213212067021,0.87378351704409,-0.91200616034745,0.96259979650566,0.48645308856345,-0.62811218755657,0.37356359696407,0.85840784699586,0.53809980261285,0.67041507564095,-0.28260659218288,-0.83469318664078,-0.71786782846342,0.20177599197934,0.5580614689448,-0.14722750093401,-0.8674737129836,-0.12700793895558,0.18537378239585,0.64549671395507,}4.2982839371136e-06{-0.25445981857133,0.13249673996283,-0.2718035127553,-0.72430954461389,1.4232117247034,-0.33952965981642,1.6825855658027,0.4430270099209,0.15716956679741,1.1364623417016,-1.2811299615557,-2.467200066115,-0.36174012131967,2.7037878931814,-0.34114087452533,-1.7333547565663,-1.0167292273294,-0.80970388354612,0.1237717895204,0.36641949687082,-0.11871201536506,-0.8181383753111,-0.25342722612542,0.38346749694153,0.33325877812144,-0.26414654291822,0.14819168394517,-0.077031835047591,-0.16050719194423,0.21618455873618,-0.54693088064852,-0.23786000247078,-0.59803675764093,1.0923008303097,0.17366075046142,0.54290923518083,0.60140644190717,0.05974144182409,-0.10139665145658,-0.15275546046583,}5.1234789449184e-08{-0.18017558513543,-0.18146265689724,0.19828598581944,0.44190756360128,-0.22332667322822,0.30169325630054,0.97082021620136,-0.23322485853026,-0.65912975643021,1.3692117676815,-0.72319483106828,-1.0883591535332,-0.46589031854902,-0.073792583922551,0.36310819165966,-0.0053283265286844,0.47961491373351,1.0974451087232,-0.70320902143542,-0.087953350778685,1.0191600187128,0.17360115911924,0.069900569787577,-0.16813379753614,0.58380508079408,0.059608837989604,-0.73024469728429,0.13274871928125,0.11332417366227,-0.31200221713205,0.23947432231531,1.0454803228932,0.8758172416385,-0.46659133456749,-0.01452242480419,0.48269143866338,-0.1505119234022,-0.53428273563778,1.1124781201795,0.7158579485146,}-1.5923623174481e-07{0.85339968189486,-0.0031680515790833,-0.39202082971167,-0.01225315528781,-0.57344056356219,1.2631862215949,0.047128925306942,-1.4902526401776,-0.090282461185964,0.0051083609777073,0.31153197386897,0.17016429041934,1.659032504245,-0.73128928650677,0.4670939328216,0.028794360062452,-0.835364828446,1.0444326143459,0.32932243316448,0.19423058285795,0.064800248455427,0.44604158652933,-0.88846000046558,0.26087480381279,-0.31110295966076,-0.29340717912116,0.3893207825555,-0.12011290761793,0.74345863790375,0.91991374081139,0.58451763390618,1.0669202255176,0.9151380516102,-0.48160558880747,0.92929454785814,0.28369332396192,0.51683013032091,-0.90813461356797,0.11724769174449,-0.95568308718194,}-2.6915435839416e-06{0.15231248617089,-0.53598711108745,-1.0728578555855,0.36259922426732,0.031027769372601,0.26773876558409,0.64368096063365,-0.25774347079668,-0.54249611885042,-0.37569923896152,1.3102568839229,1.3606470022779,1.315893134815,-1.3041749157242,-0.11526832004411,0.92184110918755,-0.093661224545601,-0.88577712061228,0.63818458911472,-0.26442642654138,-1.1176712678031,0.25360377550678,0.3515439997362,-0.69789425814896,-0.4687938342845,0.82667253233937,0.467816069347,0.44591920582718,0.05545307746697,-0.60233019250446,-0.71215641270195,-0.53751447248309,-0.45065874409576,0.42354298216433,-0.0014788537422028,-0.73425343246317,0.47007202514344,-0.46357977355352,-1.2892936180133,-0.048225560467511,}-2.2203811792948e-07{-0.35923888252987,-0.20438667385787,-0.19124147250491,0.76882231523259,0.60367368248321,-1.0389538006775,-0.61313909750184,0.40870492709999,-0.72515795426014,-1.0689391477852,0.87347072473302,0.91819843344018,-0.20062971447343,0.40036925489807,-0.041060377554657,-0.49109735768139,-0.66679007149362,-0.36921711689963,0.22104603934927,-0.16034076612188,0.14148837206228,0.30385765762427,0.77164356236879,0.84512822072436,0.45189599713861,-0.32517192253332,0.97068735065427,0.93647534203954,0.88377609020537,-0.70700992716569,0.93760202670951,0.059062141340008,0.54097694578813,-0.53362426864334,-0.33198341878765,-0.84667381438854,1.095885343958,0.66440180345932,-0.53341022968168,-0.31280200102565,}-7.7144999220949e-08{0.2099088837233,0.41124969823218,0.26237623960241,0.010632764815006,-0.69550129162016,1.0309324303167,-2.3945268806069,-1.0900830278076,-0.97074897000463,-0.64712273581935,-0.14397363140143,-0.62111675762407,-0.50609306043648,-1.1836989201552,-0.27635932911943,-0.021133962558542,-0.71273397289237,-0.76600974074245,-0.25077719867282,-0.81734393863832,0.47239605660163,-0.66353076564059,0.86867198848571,-0.79615191780073,-0.0022895055875506,0.64980972601548,-0.16107170872416,0.80976610335076,0.94472563914824,-0.53645065120444,0.030698189248155,0.34301072287199,-0.3691108833124,-0.12511525153045,-1.1246609938741,-0.41765170598958,-0.30162418790371,-0.28050202302667,0.84343770289887,0.34903091158625,}8.0352707438157e-08{-0.51405999934921,0.0044459209144511,0.30461398228033,0.95000878369673,0.16155907388394,0.42705049012585,0.65182535858805,0.65344203842455,0.27293328175436,1.1721316374074,-0.034035069744857,-0.43404730540217,-0.68429164676573,-0.32332730912654,0.56993065489951,-0.014621209625948,-0.11099663675097,1.3579581445072,-0.27863263894567,-0.55714914897038,-0.60478575969188,-0.49545399672518,0.71208007180686,0.48439443134997,0.12846042466121,0.55861815908385,1.0799294894551,0.12195062728068,-0.90166846045791,-0.51862481544792,-0.24235415755116,-0.19301095955542,1.1633646789943,0.84032850506353,-0.57698419406506,0.686434184688,0.37527363998036,0.010136967906187,-0.39289912738176,-0.52391641291929,}3.9142267087638e-06{-0.42098484784357,-0.25546825964372,-0.76476298796809,0.8142147066408,1.5127730763427,-0.75631497465614,0.28598238176559,-0.33012846499604,-0.91616485085432,0.81551319574826,0.53773987298677,0.26636333938819,-1.0291460002793,1.1510905341627,0.66077086811555,-1.0384144522199,-0.32567602055811,1.0394917903945,0.77196468624017,0.50600831732912,-0.26120500875638,-0.95893895895136,-0.064147992016425,0.072218774618524,-1.1388010084736,-0.73853337106534,-0.24610589258136,0.02514605332215,0.54960616687421,0.75275549013141,0.67453346700391,-0.60164983523389,0.50611628328965,-0.58695247773995,0.54917372627756,-0.32598410448479,0.57677346537166,0.77028748812782,-0.72799863028805,0.51131434164369,}-9.345162504613e-06{5.293159010446,-0.89468979823207,-5.2575120035085,-1.1118852011227,1.61133844062,3.2848256677548,0.1746561427601,3.4871115367329,-0.44974464033245,-2.588796188171,}|END|'
    local nn_blank = '|INFO|FF BP NN|I|40|O|1|HL|1|NHL|10|LR|0.3|BW|-0.93686904343645{0.65860249354619,-0.55093759956191,-0.085488857280854,0.86134596533424,0.53907169796382,-0.36225928210421,-0.8544376789861,-0.068779758841607,0.17521620272266,0.89223798081995,-0.66998048219643,0.3385008968516,0.48586047969959,0.088816337421721,-0.20585504630895,-0.96429498997576,0.97512873375287,0.010210821454058,-0.35230395088441,-0.19598953598858,0.58161291966794,0.38323669388203,-0.824302608359,0.85220236657664,-0.49081616973603,-0.8546704645301,-0.99080536795593,-0.68969322237917,0.95832016981114,-0.12997079391403,0.4600813783716,0.10222621790176,0.37325979566196,0.844413620672,-0.49226322302289,0.2119774155036,0.55312917764715,0.81744148976723,-0.12362652189818,0.45840618148497,}0.6163986436929{-0.85512835773935,0.62336641420222,0.37694005636703,0.56104289665486,0.52527993280902,0.67023563143015,-0.69203693855433,-0.10679797872587,0.42032240478484,0.5773769077161,-0.033996271952736,-0.81861612343975,0.37403396197775,0.4026812173839,-0.37057325476036,-0.01363581688467,0.78602832753187,-0.8227318308381,0.26026774976016,0.74370609887907,-0.21098619498754,-0.72663212807498,-0.658207907822,-0.59521391656078,-0.57163830523715,0.3702562016375,0.88403996634637,0.055426863238811,0.93421123510894,-0.54821844093813,-0.84460293343869,0.89747992411648,-0.79300458881776,0.1853810772023,-0.20243529088114,-0.25262978517629,0.86704661478582,0.065460435364584,-0.31045678674236,0.40246417833772,}0.39790297263159{-0.62168647743986,0.26856547684127,-0.89317779509875,-0.12521817778254,-0.73032062211949,0.4556116941346,-0.76058531908096,-0.30284877017609,0.76553169283885,-0.42586641335947,0.2287210889369,-0.24517497191091,-0.69555530288281,0.45509972092011,0.14074819225824,-0.83507758567298,0.69969286132842,-0.26101959326786,0.30230998375133,-0.45202366917797,-0.27342332920811,0.25962179529927,0.84956441856052,0.49011091542067,0.19529037672127,0.71486633983629,0.47925610756697,-0.55870442624941,-0.66125804946936,0.38173452753024,-0.58845831871186,-0.067495066864782,0.36559418147231,-0.70008992886013,-0.082954547764263,-0.94073529424351,0.35853662025017,-0.18049741521472,-0.73969781017117,-0.46418196757937,}-0.11009690640545{0.93508295914959,-0.43888628530304,-0.13484611378779,-0.19518204868278,-0.21672974734769,0.42982304689326,0.73089782973689,0.048042703530428,0.717573229317,0.11331885101582,-0.91387887973058,-0.24755843787355,0.97799850700569,0.051562325400469,-0.20515274785811,-0.23431163568919,-0.7941237298951,0.37766785997572,0.69355188458555,0.43238593100331,-0.003891183339098,-0.62876848626616,0.1221092078154,-0.36448065038499,0.21140015981695,-0.17935850723446,-0.44078525252753,-0.88783134246791,-0.094393108370503,-0.17812453429963,-0.80822874330187,-0.38130442835115,0.11751744922518,-0.72408455143708,0.058013708501568,-0.55217776289818,0.69159492523912,0.69453588330327,-0.14653305874224,-0.76036367245539,}0.39478151355886{-0.75335418316717,0.78173318810982,0.60716161027706,0.84989324987602,0.027338987521652,0.40050163400498,0.46328496042628,0.31321517995469,0.73862811546343,0.15359205404652,-0.67195644407467,-0.7875491316033,0.10267989685801,0.0055483457015639,0.68227223377413,-0.90464198201393,-0.12267765863326,0.48473853020126,0.99979096211181,-0.32287581639714,-0.70100496861881,0.32515589970421,-0.71628128044458,0.93611040433604,0.22776796135255,-0.77780775057135,-0.65475506102496,0.31678029813109,0.87284653057766,-0.44125856583525,-0.076026553436074,0.41215506706537,0.16159338295198,0.82595760508279,0.60620320921477,-0.69637686397346,-0.96615966295357,-0.063146910731375,0.95251771060958,-0.30595159484548,}-0.46327569172073{-0.61796065696887,-0.74372935052069,0.90696300063416,0.27111555053155,-0.86332094588476,-0.049670378066236,0.91306018963708,0.56306967815977,-0.49617788362895,0.5890995056541,0.55416359280457,-0.1665144790789,-0.022963455556122,-0.48354437894463,-0.81262744658151,-0.49332252018538,-0.30593095405112,0.9991257455604,0.32878744014565,-0.35650882047982,-0.20426241509254,-0.80013403111775,-0.76075769767012,-0.29811784953197,-0.56159203735909,-0.92982598543615,0.39789433484356,-0.18567433153045,-0.44188562452422,-0.38877284562303,-0.0051825367508371,0.39777814038485,0.46611958329266,-0.091590986320115,-0.90092822493634,-0.41945968250147,-0.6824943603432,-0.32311711081685,0.81179044897247,0.54471769297952,}-0.52769260254563{0.55602418049698,-0.21032912062054,-0.58577054245539,-0.70613158251543,-0.79801714522568,-0.51255366539465,-0.43579904507502,-0.4286732521697,0.93967890550534,-0.74107366781698,0.79047044339273,0.16330776867702,0.11929178422224,-0.5727723232206,0.60787038317702,0.42652787325736,-0.95728817410938,-0.24006080153871,-0.78651953977371,-0.23716775999413,-0.71255229917811,0.29768605327665,-0.55723532540477,0.78457810266517,-0.88570517475311,-0.79689531935021,0.83799241245034,-0.23980225511348,0.50563854394355,-0.78738790709486,0.51924795586868,0.92885688026778,-0.66667836726072,-0.17215975379536,0.2006450661272,0.41235748918311,-0.87379219389341,0.36809277901883,-0.72529674097256,-0.75295127190538,}-0.093051340117079{0.31136440631295,-0.88099537476897,0.59524794314673,-0.40941003609243,0.77894033114231,-0.21306144083557,0.51463688306536,-0.13220003327716,-0.59579726276073,0.075254780170671,-0.40976343358461,0.21797782846281,0.43071660786193,-0.91949446895957,-0.68914147237825,0.69209034372894,0.28755868545791,-0.91678509588342,0.10325346952155,-0.8824004536599,0.0065544595735956,-0.042026199322932,-0.73656734856239,0.32188049745517,-0.27453705512013,-0.10333582274026,-0.49130636830332,0.58694295917699,0.63317068038494,-0.42988485498717,0.28598998612218,-0.31676676007228,0.41351037561927,0.95161377437299,0.5974526692978,-0.70779239520847,0.26619101269532,0.4992148172816,-0.83312168234421,-0.423954871039,}-0.20048539825744{-0.17330999053455,0.46606047648815,-0.87025254985342,0.48065288174231,0.83501068354483,-0.88804598604815,0.99123263603474,-0.85117414330312,0.13853893745112,0.10393931447879,0.22798819793186,0.62071866901923,-0.47119743909126,-0.79798277269789,-0.38748586556735,-0.91551806864376,0.2805353776144,0.75647968862541,0.30395641375337,-0.18570839699225,-0.64495705497961,-0.49182650138779,0.57368917127946,0.85471880185249,-0.25691122582664,0.81278188035517,-0.75125439569309,0.03608324508357,-0.79058281629842,-0.19865332201346,-0.53387082275029,0.078878572320046,-0.36848262225406,0.67755482644944,0.15742195306407,0.47586334354884,-0.43736655085445,-0.055684250775001,-0.68858619465421,-0.0057683112530058,}0.50941912970969{-0.31138065170086,0.10391256640598,0.70360592824683,-0.90370552388287,0.21811758012288,0.60467621438711,0.91918928025801,-0.57114167282836,-0.9694247732045,0.074233564313799,-0.39902085900249,0.44510862595552,-0.48247728896108,-0.6112577268886,0.21898114662785,-0.92632220865013,0.41676549503316,0.56554619923383,0.68711020413627,0.4692054312465,-0.21583925232799,0.1796707258041,0.4501695098872,-0.97500842972427,-0.46416249901026,-0.79368691818369,0.83084857540797,0.63318467188757,-0.79547553706465,-0.11710705920568,0.59498837696272,0.59295553372659,0.0089063701337357,0.0045756454231611,0.19553628989219,-0.72872280536205,-0.019436927048084,-0.48682752527193,0.96572208233122,0.11328373547299,}0.7561447676892{0.97539606109826,-0.12624359286462,-0.57414105778941,0.084207495202474,0.54148156316844,0.70124333331834,0.64835150336278,0.52850986805422,0.080003997896295,0.7340720151248,}|END|'

    local datik = ResolverDATA.create(40, 1, 1, 10, 0.3)
    
    
    local tab, container = "AA", "Other"
   -- local options_multibox = create_ui_element('multiselect', 'Anti-aimbot angles', 'AI \aFF6B89FFResolver', {'Enable'}, true) --("Players", "Adjustments")
    
    local resolver = {
        cache = {
            resolver_yaw_pattern_count = { },
            resolver_last_yaw_diff = { },
            resolver_pattern_yaw = { }, 
            layers = { },
            layers_c = { },
        },
        data = { },
        records = { },
        record_max_ticks = 8,
        record_old_tickcount = { },
        layer_data = { },
    }
    function resolver.set_round_data()
        return {
            antiaim = {
                ['extended'] = false,
                ['fake_yaw'] = 0,
                ['break_lc_count'] = 0,
                ['eye_yaw'] = false,
                ['jitter'] = false,
                ['mode'] = 'Legit',
            },
            layers = {
                ['is_desync'] = false,
                ['eye_yaw'] = false,
            },
            props = {
                ['m_flChokedPackets'] = 0,
                ['m_flLowerBodyYawTarget'] = 0,
                ['m_flLowerBodyYawMoving'] = 0,
                ['m_flLowerBodyYawStanding'] = 0,
                ['m_flLowerBodyDelta'] = 0,
                ['m_flOldEyeYaw'] = 0,
                ['m_angEyeAngles'] = vector(0, 0, 0),
                ['velocity'] = {},
                ['m_flVelocity2D'] = 0,
                ['lowdelta'] = false,
                ['highdelta'] = false,
                ['correction'] = nil,
                ['should_resolve'] = false,
                ['pref_packet'] = 0,
                ['bad_packets'] = 0,
                ['clean_packets'] = 0,
                ['m_flEyeYaw'] = 0,
                ['m_flGoalFeetYaw'] = 0,
                ['m_flOldGoalFeetYaw'] = 0,
                ['m_flGoalFeetDelta'] = 0,
                ['m_flFixedGoalFeetDelta'] = 0,
                ['m_flCurrentFeetYaw'] = 0,
                ['m_flServerFeetDelta'] = 0,
                ['m_flServerFeetYaw'] = 0,
                ['m_flLastChokedPackets'] = 0,
                ['m_flLastMaxChokedPackets'] = 0,
                ['m_flMaxChokedPackets'] = 0,
                ['m_flOldServerFeetYaw'] = 0,
                ['m_flDesync'] = 0,  
            },
        }
    end
    
    function resolver.get_player_records(ent)
        if ent ~= nil and resolver.records[ent] ~= nil then
            resolver.records[ent] = resolver.records[ent] or 0
            return resolver.records[ent]
        end
    end
    
    function resolver.reset(ent)
        resolver.records[ent] = { }
    end
    
    function updateplayers(ent)
        local player_record = resolver.records[ent]
        local sim_time = entity.get_prop(ent, "m_flSimulationTime")
    
        if player_record == nil then
            resolver.records[ent] = { }
            player_record = resolver.records[ent]
        end
        resolver.record_old_tickcount[ent] = resolver.record_old_tickcount[ent] or globals.servertickcount()
    
        if sim_time > 0 and (#player_record == 0 or (#player_record > 0 and player_record[1].simulation_time ~= sim_time)) then
            local anim_layer3 = layerik(ent, 3)
            local anim_layer6 = layerik(ent, 6)
            local anim_layer12 = layerik(ent, 12)
            local anim_layer = {
                [3] = {
                    m_flCycle = anim_layer3.m_flCycle,
                    m_flWeight = anim_layer3.m_flWeight,
                    m_flPlaybackRate = anim_layer3.m_flPlaybackRate,
                },
                [6] = {
                    m_flCycle = anim_layer6.m_flCycle,
                    m_flWeight = anim_layer6.m_flWeight,
                    m_flPlaybackRate = anim_layer6.m_flPlaybackRate,
                },
                [12] = {
                    m_flCycle = anim_layer12.m_flCycle,
                    m_flWeight = anim_layer12.m_flWeight,
                    m_flPlaybackRate = anim_layer12.m_flPlaybackRate,
                },
            }
    
            local new_record = {
                layers = anim_layer,
                m_flVelocity2D = resolver.data[ent].props['m_flVelocity2D'],
                m_flEyeYaw = resolver.data[ent].props['m_flEyeYaw'],
                m_flGoalFeetYaw = resolver.data[ent].props['m_flGoalFeetYaw'],
                m_flCurrentFeetYaw = resolver.data[ent].props['m_flCurrentFeetYaw'],
                m_flServerFeetDelta = resolver.data[ent].props['m_flServerFeetDelta'],
                simulation_time = entity.get_prop(ent, "m_flSimulationTime"),
                m_iTickCount = globals.servertickcount()
            }
    
            for i = resolver.record_max_ticks, 2, -1 do 
                resolver.records[ent][i] = resolver.records[ent][i-1]
            end
            resolver.record_old_tickcount[ent] = globals.servertickcount()
            resolver.records[ent][1] = new_record
        end
    end
    
    local layers_rec_t = {}
    local layers_average_t = {}
    local velocity_rec_t = {}
    
    local function layerik_rec(ent)
        layers_rec_t[ent] = layers_rec_t[ent] or 0
        return layers_rec_t[ent]
    end
    
    local function get_velocity_rec(ent)
        velocity_rec_t[ent] = velocity_rec_t[ent] or 0
        return velocity_rec_t[ent]
    end
    
    function preferenceshit(ent, layer)
        layer = layer or 1
        local anim_layer = layerik(ent, layer)
        local anim_layer6 = layerik(ent, 6)
        local anim_state = animstate(ent)
    
        local m_flLastClientSideAnimationUpdateTimeDelta = math.abs(anim_state.m_iLastClientSideAnimationUpdateFramecount - anim_state.m_iLastClientSideAnimationUpdateFramecount)
    
        local layers_c = {
            m_flCycle = 1,
            m_flWeight = 1,
            m_flPlaybackRate = 1,
        }
        local layers_t = {
            m_flPrevCycle = anim_layer.m_flCycle,
            m_flCycle = anim_layer.m_flCycle,
            m_flPrevWeight = anim_layer.m_flWeight,
            m_flWeight = anim_layer.m_flWeight,
            m_flPrevPlaybackRate = anim_layer.m_flPlaybackRate,
            m_flPlaybackRate = anim_layer.m_flPlaybackRate,
        }
    
        resolver.cache.layers_c[ent] = resolver.cache.layers_c[ent] or {}
        resolver.cache.layers_c[ent][layer] = resolver.cache.layers_c[ent][layer] or layers_c
        resolver.cache.layers[ent] = resolver.cache.layers[ent] or {}
        resolver.cache.layers[ent][layer] = resolver.cache.layers[ent][layer] or layers_t
    
        if anim_layer.m_flCycle ~= resolver.cache.layers[ent][layer].m_flCycle then
            resolver.cache.layers[ent][layer].m_flPrevCycle = resolver.cache.layers[ent][layer].m_flCycle
            resolver.cache.layers[ent][layer].m_flCycle = anim_layer.m_flCycle
    
            if resolver.cache.layers_c[ent][layer].m_flCycle == 3 then
                resolver.cache.layers_c[ent][layer].m_flCycle = 1
            else
                resolver.cache.layers_c[ent][layer].m_flCycle = resolver.cache.layers_c[ent][layer].m_flCycle + 1
            end
        end
        if anim_layer.m_flWeight ~= resolver.cache.layers[ent][layer].m_flWeight then
            resolver.cache.layers[ent][layer].m_flPrevWeight = resolver.cache.layers[ent][layer].m_flWeight
            resolver.cache.layers[ent][layer].m_flWeight = anim_layer.m_flWeight
    
            if resolver.cache.layers_c[ent][layer].m_flWeight == 3 then
                resolver.cache.layers_c[ent][layer].m_flWeight = 1
            else
                resolver.cache.layers_c[ent][layer].m_flWeight = resolver.cache.layers_c[ent][layer].m_flWeight + 1
            end
        end
        if anim_layer.m_flPlaybackRate ~= resolver.cache.layers[ent][layer].m_flPlaybackRate then
            resolver.cache.layers[ent][layer].m_flPrevPlaybackRate = resolver.cache.layers[ent][layer].m_flPlaybackRate
            resolver.cache.layers[ent][layer].m_flPlaybackRate = anim_layer.m_flPlaybackRate
    
            if resolver.cache.layers_c[ent][layer].m_flPlaybackRate == 3 then
                resolver.cache.layers_c[ent][layer].m_flPlaybackRate = 1
            else
                resolver.cache.layers_c[ent][layer].m_flPlaybackRate = resolver.cache.layers_c[ent][layer].m_flPlaybackRate + 1
            end
        end
    end
    
    function resolver.get_delta_size(ent)
        local anim_layer3 = layerik(ent, 3)
        local anim_layer6 = layerik(ent, 6)
    
        local records = resolver.get_player_records(ent)
        if not records[1] or not records[2] or not records[8] then return end
    
        local current_record, next_record = records[1], records[2]
        local goalfeet_diff = normalize_yaw(current_record.m_flGoalFeetYaw - next_record.m_flGoalFeetYaw)
        local eyeyaw_diff = math.abs(current_record.m_flEyeYaw)-math.abs(next_record.m_flEyeYaw)
        local cur_feetyaw = math.abs(current_record.m_flCurrentFeetYaw)-math.abs(next_record.m_flCurrentFeetYaw)
    
        resolver.cache.resolver_pattern_yaw[ent] = resolver.cache.resolver_pattern_yaw[ent] or 0
        resolver.cache.resolver_yaw_pattern_count[ent] = resolver.cache.resolver_yaw_pattern_count[ent] or 0
        resolver.cache.resolver_last_yaw_diff[ent] = resolver.cache.resolver_last_yaw_diff[ent] or 0
    
        if (math.abs(goalfeet_diff) > 0) and (current_record.m_flVelocity2D <= 1.02 and next_record.m_flVelocity2D <= 1.02) then      
            local count_max = resolver.data[ent]['layers']['eye_yaw'] and 1 or 3
            if math.abs(goalfeet_diff) == resolver.cache.resolver_last_yaw_diff[ent] then
                resolver.cache.resolver_yaw_pattern_count[ent] = resolver.cache.resolver_yaw_pattern_count[ent] + 1
            elseif resolver.cache.resolver_yaw_pattern_count[ent] >= count_max then
                resolver.cache.resolver_pattern_yaw[ent] = math.abs(goalfeet_diff)
                resolver.cache.resolver_yaw_pattern_count[ent] = 0
            else
                resolver.cache.resolver_yaw_pattern_count[ent] = 0
            end
    
            resolver.cache.resolver_last_yaw_diff[ent] = math.abs(goalfeet_diff)
        end
    
        if resolver.data[ent].props['m_flVelocity2D'] <= 1.02 then
    
            if not resolver.data[ent]['layers']['eye_yaw'] then
                if resolver.data[ent].props['highdelta'] then
                    resolver.data[ent]['layers']['fake_yaw'] = 60
                elseif between(anim_layer6.m_flCycle, 0.500090, 0.500100) and resolver.data[ent].props['lowdelta'] then
                    resolver.data[ent]['layers']['fake_yaw'] = 45
                elseif (((between(anim_layer6.m_flCycle, 0.350050, 0.350150) 
                    and between(resolver.cache.layers[ent][6].m_flPrevCycle, 0.500050, 0.591000)) 
                    or (between(anim_layer6.m_flCycle, 0.350050, 0.591000) 
                    and between(resolver.cache.layers[ent][6].m_flPrevCycle, 0.350050, 0.350150))) 
                    or (between(resolver.cache.resolver_pattern_yaw[ent], 10.76, 10.94))) 
                    and resolver.data[ent].props['lowdelta'] then
                    
                    resolver.data[ent]['layers']['fake_yaw'] = 25
                elseif resolver.data[ent].props['lowdelta'] then
                    resolver.data[ent]['layers']['fake_yaw'] = 40
                end
            elseif resolver.data[ent]['layers']['eye_yaw'] then
                if resolver.data[ent].props['highdelta'] then
                    resolver.data[ent]['layers']['fake_yaw'] = 60
                elseif (between(anim_layer6.m_flCycle, 0.500090, 0.500100) 
                    and between(resolver.cache.resolver_pattern_yaw[ent], 103.7, 104.5)) 
                    and resolver.data[ent].props['lowdelta'] then
                    resolver.data[ent]['layers']['fake_yaw'] = 45
                elseif (((between(anim_layer6.m_flCycle, 0.350050, 0.350150) 
                    and between(resolver.cache.layers[ent][6].m_flPrevCycle, 0.500050, 0.591000)) 
                    or (between(anim_layer6.m_flCycle, 0.350050, 0.591000) 
                        and between(resolver.cache.layers[ent][6].m_flPrevCycle, 0.350050, 0.350150))) 
                    and between(resolver.cache.resolver_pattern_yaw[ent], 2.700, 2.999)) and resolver.data[ent].props['lowdelta'] then
                    resolver.data[ent]['layers']['fake_yaw'] = 25
                elseif resolver.data[ent].props['lowdelta'] then
                    resolver.data[ent]['layers']['fake_yaw'] = 35
                end
            end
    
            if (
                ((between(anim_layer3.m_flCycle, 0.00, 0.02) 
                    or between(anim_layer3.m_flCycle, 0.998, 1)) 
                    or between(anim_layer3.m_flCycle, 0.5548, 0.5558))
                ) then
                resolver.data[ent]['layers']['eye_yaw'] = true
                resolver.data[ent]['layers']['is_desync'] = true
                resolver.data[ent].antiaim['eye_yaw'] = true
                if (
                    (between(anim_layer6.m_flWeight, 0.003, 0.008) 
                        and between(anim_layer6.m_flCycle, 0, 1) 
                        and anim_layer6.m_flPlaybackRate*1000 > 0.000) or
                        (between(resolver.cache.resolver_pattern_yaw[ent], 109.5, 109.8))
                    ) then
                    resolver.data[ent].props['highdelta'] = true
                    resolver.data[ent].props['lowdelta'] = false
                elseif (anim_layer3.m_flWeight == 1 and between(anim_layer3.m_flCycle, 0.0, 0.7)
                        and not between(anim_layer6.m_flWeight, 0.003, 0.008)              
                        and not between(records[2].layers[6].m_flWeight, 0.003, 0.008)              
                        and not between(records[3].layers[6].m_flWeight, 0.003, 0.008)              
                        and not between(records[4].layers[6].m_flWeight, 0.003, 0.008)              
                        and not between(records[5].layers[6].m_flWeight, 0.003, 0.008)              
                        and not between(records[6].layers[6].m_flWeight, 0.003, 0.008)              
                        and not between(records[7].layers[6].m_flWeight, 0.003, 0.008)              
                        and not between(records[8].layers[6].m_flWeight, 0.003, 0.008)
                        and (anim_layer6.m_flPlaybackRate*1000 > 0.000)
                    ) then
                    resolver.data[ent].props['highdelta'] = false
                    resolver.data[ent].props['lowdelta'] = true
                else
                    resolver.data[ent].props['highdelta'] = false
                    resolver.data[ent].props['lowdelta'] = false
                end
            elseif resolver.data[ent]['layers']['eye_yaw'] then
                resolver.data[ent]['layers']['eye_yaw'] = false
                resolver.data[ent].antiaim['eye_yaw'] = false
            end
    
            if (
                (between(anim_layer3.m_flWeight, 0.042, 0.044) 
                    and between(anim_layer3.m_flCycle, 0.005, 0.020) or
                    ((resolver.cache.layers[ent][3].m_flPrevCycle > 0.92 
                        and anim_layer3.m_flCycle > 0.92 and anim_layer3.m_flWeight == 0)) 
                    and between(anim_layer3.m_flWeightDeltaRate, 2.68, 2.69)) or
                    (between(resolver.cache.resolver_pattern_yaw[ent], 108.0, 108.5))
                ) and not resolver.data[ent]['layers']['eye_yaw'] then
                resolver.data[ent].antiaim['extended'] = true
                resolver.data[ent].props['highdelta'] = false
                resolver.data[ent].props['lowdelta'] = true
                resolver.data[ent]['layers']['is_desync'] = true
            elseif (
                (anim_layer3.m_flWeight == 0 and anim_layer3.m_flCycle == 0) or
                    (between(anim_layer6.m_flWeight, 0.0039, 0.008) or between(resolver.cache.resolver_pattern_yaw[ent], 111.0, 111.6)) and 
                    (between(anim_layer3.m_flWeightDeltaRate, 2.68, 2.69) and not resolver.data[ent]['layers']['eye_yaw'])
                ) then
                resolver.data[ent].antiaim['extended'] = true
                resolver.data[ent].props['highdelta'] = true
                resolver.data[ent].props['lowdelta'] = false
                resolver.data[ent]['layers']['is_desync'] = true
            elseif (anim_layer3.m_flWeight == 0 and between(anim_layer3.m_flCycle, 0.986, 1) and anim_layer3.m_flWeightDeltaRate == 0) and not resolver.data[ent]['layers']['eye_yaw'] then
                resolver.data[ent].antiaim['extended'] = false
                resolver.data[ent]['layers']['is_desync'] = false
                resolver.data[ent].props['highdelta'] = false
                resolver.data[ent].props['lowdelta'] = false
            elseif between(anim_layer3.m_flWeight, 0.042, 0.044) and between(anim_layer3.m_flCycle, 0.012, 0.013) and not resolver.data[ent]['layers']['eye_yaw'] then
                resolver.data[ent]['layers']['is_desync'] = true
            elseif between(resolver.cache.layers[ent][6].m_flPrevWeight, 0.002, 0.005) and between(resolver.cache.resolver_pattern_yaw[ent], 106.0, 108.0) and anim_layer3.m_flWeight == 0 and resolver.cache.layers[ent][3].m_flPrevWeight == 0 then
                resolver.data[ent].antiaim['extended'] = false
                resolver.data[ent].props['highdelta'] = false
                resolver.data[ent].props['lowdelta'] = true
                resolver.data[ent]['layers']['is_desync'] = true
            end
        end
    end
    
    function countshits(ent)
        local choked_packets = resolver.data[ent].props['m_flChokedPackets'] or 0
    
        if (resolver.data[ent].props['m_flVelocity2D'] > 0 and resolver.data[ent].props['should_resolve']) then
            return
        end
    
        if choked_packets == resolver.data[ent].props['pref_packet'] then
            resolver.data[ent].props['clean_packets'] = resolver.data[ent].props['clean_packets'] + 1
        else
            resolver.data[ent].props['bad_packets'] = resolver.data[ent].props['bad_packets'] + 1
        end
        resolver.data[ent].props['pref_packet'] = choked_packets
    
        if (resolver.data[ent].props['clean_packets'] > 3 and not resolver.data[ent]['layers']['is_desync']) or resolver.data[ent].props['clean_packets'] > 4 then
            resolver.data[ent].props['clean_packets'] = 0
            resolver.data[ent].props['bad_packets'] = 0
            resolver.data[ent].props['should_resolve'] = false
        elseif (resolver.data[ent].props['bad_packets'] > 10 and resolver.data[ent]['layers']['is_desync']) or
            (resolver.data[ent].antiaim['mode'] == 'Rage' and resolver.data[ent].props['bad_packets'] > 10) or
            resolver.data[ent].props['bad_packets'] > 16 then
            resolver.data[ent].props['bad_packets'] = 0
            resolver.data[ent].props['clean_packets'] = 0
            resolver.data[ent].props['should_resolve'] = true
        end
    end
    
    function get_prop(ent)
        local vec_velocity = {entity.get_prop(ent, "m_vecVelocity")}
        local anim_state = animstate(ent)
        local anim_layer6 = layerik(ent, 6)
    
        local eye_yaw = resolver.data[ent].props['m_flEyeYaw']
        local goal_feet_yaw = resolver.data[ent].props['m_flGoalFeetYaw']
        local simtime = resolver.data[ent].props['m_flSimulationTime']
    
        resolver.data[ent].props["m_flSimulationTime"] = entity.get_prop(ent, "m_flSimulationTime")
        resolver.data[ent].props["m_flOldSimulationTime"] = simtime or entity.get_prop(ent, "m_flSimulationTime")
        resolver.data[ent].props["m_flChokedPackets"] =
            resolver.data[ent].props["m_flSimulationTime"] == resolver.data[ent].props["m_flOldSimulationTime"] and
            resolver.data[ent].props["m_flChokedPackets"] + 1 or
            0
        resolver.data[ent].props["m_flVelocity2D"] = math.abs(math.sqrt(vec_velocity[1] ^ 2 + vec_velocity[2] ^ 2))
        resolver.data[ent].props["m_angEyeAngles"] =
            vector(entity.get_prop(ent, "m_angEyeAngles[0]"), entity.get_prop(ent, "m_angEyeAngles[1]"), 0)
        resolver.data[ent].props["m_flLowerBodyYawTarget"] = entity.get_prop(ent, "m_flLowerBodyYawTarget")
        resolver.data[ent].props["m_flLowerBodyDelta"] =
            normalize_yaw(resolver.data[ent].props["m_flLowerBodyYawTarget"] - resolver.data[ent].props["m_angEyeAngles"].y)
        resolver.data[ent].props["m_flLowerBodyYawMoving"] =
            resolver.data[ent].props["m_flVelocity2D"] > 0 and resolver.data[ent].props["m_flLowerBodyYawTarget"] or
            resolver.data[ent].props["m_flLowerBodyYawMoving"]
        resolver.data[ent].props["m_flLowerBodyYawStanding"] =
            resolver.data[ent].props["m_flVelocity2D"] == 0 and resolver.data[ent].props["m_flLowerBodyYawTarget"] or
            resolver.data[ent].props["m_flLowerBodyYawStanding"]
        resolver.data[ent].props["m_flEyeYaw"] = normalize_yaw(anim_state.m_flEyeYaw)
        resolver.data[ent].props["m_flOldEyeYaw"] = eye_yaw
        resolver.data[ent].props["m_flGoalFeetYaw"] = anim_state.m_flGoalFeetYaw
        resolver.data[ent].props["m_flOldGoalFeetYaw"] = goal_feet_yaw
        resolver.data[ent].props["m_flGoalFeetDelta"] =
            normalize_yaw(resolver.data[ent].props["m_flGoalFeetYaw"] - resolver.data[ent].props["m_flEyeYaw"])
        resolver.data[ent].props["m_flCurrentFeetYaw"] = normalize_yaw(anim_state.m_flCurrentFeetYaw)
        resolver.data[ent].antiaim["mode"] = math.abs(resolver.data[ent].props["m_angEyeAngles"].x) >= 75 and "Rage" or "Legit"
        
    end
    
    local run = {running = false, count = 0}
    
    local function updatething()
        local lp = entity.get_local_player()
        local enemies = entity.get_players(true)
    
        for i=1, #enemies do
            local ent = enemies[i]
            if not entity.is_alive(ent) or not entity.is_alive(lp) then
                return
            end
    
            resolver.data[ent] = resolver.data[ent] or resolver.set_round_data()
            get_prop(ent);
            updateplayers(ent);
            countshits(ent)
            preferenceshit(ent, 3)
            preferenceshit(ent, 6)
            resolver.get_delta_size(ent)
        end
    end
    client.set_event_callback("net_update_end", updatething)
    
    local function resetall(e)
        if e then
            local userid = e.userid
    
            if not userid then
                resolver.data = {}
                return
            end
    
            local ent = client.userid_to_entindex(userid)
            local entity_id = client.userid_to_entindex(userid)
            local attacker_id = client.userid_to_entindex(e.attacker)
            local me = entity.get_local_player()
            resolver.data = ent == me and {} or resolver.data
            
            return
        end
        resolver.data = {}
    end
    client.set_event_callback('player_spawned', resetall, e)
    client.set_event_callback("round_start", resetall)
    

    local function handle()
        if not run.running then return end
    
        local lp = entity.get_local_player()
        
        local enemies = entity.get_players(true)
    
        for i=1, #enemies do
            local ent = enemies[i] or lp
            if not entity.is_alive(ent) or not entity.is_alive(lp) then
                return
            end
    
            local anim_layer_6 = layerik(ent, 6)
            local velocity = { entity.get_prop(ent, "m_vecVelocity") }
    
            local m_flVelocity2D = normalize(math.sqrt(velocity[1]^2+velocity[2]^2), 0, 260)
    
            local m_flPlaybackRate = anim_layer_6.m_flPlaybackRate*mul
            if m_flPlaybackRate == nil then return end
            layers_average_t[ent] = layers_average_t[ent] or {m_flPlaybackRate}
            insert_first_index(layers_average_t[ent], m_flPlaybackRate, 18)
            local pbr = normalize(average(layers_average_t[ent]), 0, 21973819.471897)
            layers_rec_t[ent] = pbr
            velocity_rec_t[ent] = m_flVelocity2D	
        end
    end
    
    client.set_event_callback('net_update_start', handle)
    
    local function initresolver()
        if not run.running and not vars.misc.resolver_mode.value == 'AI' then return end 

        if vars.misc.resolver_mode.value == 'Modern' then return end 
        
        
        local enemies = entity.get_players(true)
    
      --  if vars.misc.resolver:get() and vars.misc.resolver_mode.value == 'AI' then

            for i=1, #enemies do
                local ent = enemies[i]
        
                local m_flVelocity2D = get_velocity_rec(ent)
                local m_flPlaybackRate = layerik_rec(ent)
                if m_flPlaybackRate == nil then return end
                local bin_pbr = bin_value(m_flPlaybackRate, wielkosc)
                local bin_vel = bin_value(m_flVelocity2D, wielkosc)
        
                local t = bin_pbr
                for i=1, #bin_vel do
                    table.insert(t, bin_vel[i])
                end
                local forward = datik:forewardPropagate( t )[1]
        
                if resolver.data[ent] then
                    if resolver.data[ent].props['should_resolve'] then
                        local desync_val = (not resolver.data[ent].antiaim['extended'] and not resolver.data[ent].props['highdelta']) and 60 or 35
                        plistelo.ustawcorrectionato(ent, true)
                        plistelo.nokurwaustawto(ent, true)
                        plistelo.ustawtokurwa(ent, (forward < 0.5 and -desync_val or desync_val))
                    elseif plistelo.sprawdzczyjest(ent) then
                        plistelo.ustawcorrectionato(ent, false)
                        plistelo.nokurwaustawto(ent, false)
                    end
                end
                -- print("elo23")
        
            end
            client.delay_call(1/10, initresolver)
      --  end
    end
    
    local function runthiselo()
        local enabled = vars.misc.resolver_mode.value
        -- if enabled == "AI" and not run.running then
        --     if vars.misc.resolver:get() and enabled == 'AI' then
        --     run.running = true
        --     initresolver()
        --     end
        -- elseif run.running and not vars.misc.resolver:get() then
        --     if not vars.misc.resolver:get() or not enabled == 'AI' then
        --         run.running = false
        --     end

        --     if enabled == 'Modern' then
        --         print("chuj")
        --     end
        -- end

        if vars.misc.resolver:get() and vars.misc.resolver_mode.value == 'AI' and not run.running then
            -- print("elo23")
            run.running = true
            initresolver()
        elseif not vars.misc.resolver_mode.value == 'AI' and run.running then
            run.running = false
        elseif not vars.misc.resolver:get() and run.running then
            run.running = false
        elseif vars.misc.resolver_mode.value == 'Modern' and run.running then
            run.running = false
        end

        
    end
    
    datik = ResolverDATA.load(preset1)

    client.set_event_callback('setup_command', runthiselo)
    client.set_event_callback("round_start", runthiselo)




    do
        local function get_body_yaw(animstate)
            local body_yaw = animstate.eye_angles_y - animstate.goal_feet_yaw
            body_yaw = utilities.normalize(body_yaw)
    
            return body_yaw
        end
    
        local pre_flags, post_flags = 0, 0
    
        function lp_info.pre_predict_command(e, me)
            pre_flags = entity.get_prop(me, 'm_fFlags')
        end
    
        function lp_info.predict_command(e, me)
            post_flags = entity.get_prop(me, 'm_fFlags')
        end
    
        function lp_info.net_update_end(me, valid)
            local data = c_entity(me)
            if data == nil then
                return
            end
    
            local animstate = c_entity.get_anim_state(data)
            if animstate == nil then
                return
            end
    
            local chokedcommands = globals.chokedcommands()
    
            local m_fFlags = entity.get_prop(me, 'm_fFlags')
            local m_movetype = entity.get_prop(me, 'm_movetype')
            local m_flDuckAmount = entity.get_prop(me, 'm_flDuckAmount')
    
            if chokedcommands == 0 then
                lp_info.chokes = lp_info.chokes + 1
                lp_info.choking = lp_info.choking * -1
                lp_info.body_yaw = get_body_yaw(animstate)
            end
    
            lp_info.flags = m_fFlags
            lp_info.movetype = m_movetype
            lp_info.velocity = animstate.m_velocity
            lp_info.is_moving = lp_info.velocity > 5
            lp_info.on_ground = animstate.on_ground
            lp_info.ducking = m_flDuckAmount > .89
            lp_info.landing = animstate.hit_in_ground_animation and lp_info.on_ground and not lp_info.air
            lp_info.air = bit.band(pre_flags, post_flags, 1) == 0
        end
    
        callbacks['Localplayer']['net_update_end']:set(lp_info.net_update_end)
        callbacks['Localplayer']['pre_predict_command']:set(lp_info.pre_predict_command)
        callbacks['Localplayer']['predict_command']:set(lp_info.predict_command)
        callbacks['Anti Aim']['setup_command']:set(function (cmd, me, valid)
            exploit.setup_command(cmd, me)
            anti_aim.on_cm()
            lp_info.condition = anti_aim.condition(false)
        end)
    end



    do
        local function watermark()
            local screen_x, screen_y = client.screen_size()
            local r, g, b = vars.visuals.indicators_color:get_color()
            local start, en = {r,g,b,255}, {12,12,12,100}
            local text = main_funcs:text_animation(5, start, en, "A S T R A S Y S")
            renderer.text(screen_x/2, screen_y-25, 255, 255, 255, 255, 'c', 0, text)
        end
        callbacks['Localplayer']['paint']:set(watermark)
    end






    do
        local name = 'A S T R A [' .. defines.build .. "]"
        --local name2 = 'A S T R A [' .. defines.build:upper() .. "]"
    
        local cache = { }
        for w in string.gmatch(name, '.[\128-\191]*') do
            cache[ #cache + 1 ] = {
                w = w,
                n = 0,
                d = false,
                p = { 0 }
            }
        end
    
        local function linear(t, d, s)
            t[ 1 ] = utilities.clamp(t[ 1 ] + (globals.frametime() * s * (d and 1 or -1)), 0, 1)
            return t[ 1 ]
        end
    
        callbacks['Sidebar']['paint_ui']:set(function ()
            if not ui.is_menu_open() then
                return
            end
    
            local result = { }
            local sidebar, accent = { 150, 176, 186, 255 }, { reference.MISC.color:get() }
            local realtime = globals.realtime()
    
            for i, v in ipairs(cache) do
                if realtime >= v.n then
                    v.d = not v.d
                    v.n = realtime + client.random_float(1, 3)
                end
    
                local alpha = linear(v.p, v.d, 1)
                local r, g, b, a = utilities.color_lerp(sidebar[1], sidebar[2], sidebar[3], sidebar[4], accent[1], accent[2], accent[3], accent[4], math.min(alpha + 0.5, 1))
    
                result[ #result + 1 ] = f('\a%02x%02x%02x%02x%s', r, g, b, 200 * alpha + 55, v.w)
            end
    
            vars.selection.label:set(table.concat(result))
        end)
    end



    do
        local name2 = 'User: ' .. username:lower()
    
        local cache2 = { }
        for w in string.gmatch(name2, '.[\128-\191]*') do
            cache2[ #cache2 + 1 ] = {
                w = w,
                n = 0,
                d = false,
                p = { 0 }
            }
        end
    
        local function linear(t, d, s)
            t[ 1 ] = utilities.clamp(t[ 1 ] + (globals.frametime() * s * (d and 1 or -1)), 0, 1)
            return t[ 1 ]
        end
    
        callbacks['Sidebar']['paint_ui']:set(function ()
            if not ui.is_menu_open() then
                return
            end
    
            local result2 = { }
            local sidebar, accent = { 150, 176, 186, 255 }, { reference.MISC.color:get() }
            local realtime = globals.realtime()
    
            for i, v in ipairs(cache2) do
                if realtime >= v.n then
                    v.d = not v.d
                    v.n = realtime + client.random_float(1, 3)
                end
    
                local alpha = linear(v.p, v.d, 1)
                local r, g, b, a = utilities.color_lerp(sidebar[1], sidebar[2], sidebar[3], sidebar[4], accent[1], accent[2], accent[3], accent[4], math.min(alpha + 0.5, 1))
    
                result2[ #result2 + 1 ] = f('\a%02x%02x%02x%02x%s', r, g, b, 200 * alpha + 55, v.w)
            end
    
            vars.selection.label2:set(table.concat(result2))
        end)
    end
    
    local y = 0
    local alpha = 0
    local startup_anim = true
    local chuj = true
    local show_text = false
    client.set_event_callback('paint_ui', function()
        local screen = vector(client.screen_size())
        local size = vector(screen.x, screen.y)
    
        if startup_anim == true then
            local r, g, b = pui.accent
            local start, en = {184, 184, 184, alpha}, {62, 62, 62, 100}
            local text = main_funcs:text_animation(5, start, en, "A S T R A S Y S")
            local rotation = lerp(0, 360, globals.realtime() % 1)
            if chuj == true then
            alpha = lerp(alpha, 255, globals.frametime() * 5)
            end
    
            renderer.rectangle(0, 0, size.x, size.y, 20, 20, 20, alpha)
            if icons4.main ~= nil then
            icons4.main:draw(screen.x/2 - (369/4) + 5, screen.y/2 - (373/4), 369/2, 373/2, 255, 255, 255, alpha)
            else
                http.get('https://i.imgur.com/iZoti3D.png', function(s, r)
                    if s and r.status == 200 then
                        icons4.main = l_images.load(r.body)
                    end
                end)
            end
            
            renderer.text(screen.x/2, screen.y/2 +50, 184, 184, 184, alpha, 'c', 0, text)
            if alpha > 210 then
                if chuj == true then
                    y = lerp(y, 150, globals.frametime() * 2.6)
                end
                show_text = true
            end
            if y > 149 then
                chuj = false
                alpha = lerp(alpha, 0, globals.frametime() * 5)
                
                if alpha < 1 then
                    startup_anim = false
                end
            end
            if show_text == true then
                renderer.text(screen.x/2, screen.y - y/2 + 65, 184, 184, 184, alpha, 'c', 0, 'https://astralua.pro/')
            end
        end
    end)