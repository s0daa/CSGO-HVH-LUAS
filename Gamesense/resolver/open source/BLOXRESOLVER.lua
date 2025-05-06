--[[

██████╗░██╗░░░░░░█████╗░██╗░░██╗██████╗░███████╗░██████╗░█████╗░██╗░░░░░██╗░░░██╗███████╗██████╗░
██╔══██╗██║░░░░░██╔══██╗╚██╗██╔╝██╔══██╗██╔════╝██╔════╝██╔══██╗██║░░░░░██║░░░██║██╔════╝██╔══██╗
██████╦╝██║░░░░░██║░░██║░╚███╔╝░██████╔╝█████╗░░╚█████╗░██║░░██║██║░░░░░╚██╗░██╔╝█████╗░░██████╔╝
██╔══██╗██║░░░░░██║░░██║░██╔██╗░██╔══██╗██╔══╝░░░╚═══██╗██║░░██║██║░░░░░░╚████╔╝░██╔══╝░░██╔══██╗
██████╦╝███████╗╚█████╔╝██╔╝╚██╗██║░░██║███████╗██████╔╝╚█████╔╝███████╗░░╚██╔╝░░███████╗██║░░██║
╚═════╝░╚══════╝░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝╚═════╝░░╚════╝░╚══════╝░░░╚═╝░░░╚══════╝╚═╝░░╚═╝
          darov ! | ds server https://discord.gg/MaE6Tvx4ZB  | (reliz) bloxresolver reliznyt

]]--
local ffi = require("ffi")
local vector = require("vector")
function Clamp(value, min, max) return math.min(math.max(value, min), max) end
local function AngleModifier(a) return (360 / 65536) * bit.band(math.floor(a * (65536 / 360)), 65535) end
local function Approach(target, value, speed)
	target = AngleModifier(target)
	value = AngleModifier(value)
	local delta = target - value
	if speed < 0 then speed = -speed end
	if delta < -179 then delta = delta + 360
	elseif delta > 179 then delta = delta - 360 end
	if delta > speed then value = value + speed
	elseif delta < -speed then value = value - speed
    else value = target
	end
	return value
end
local function NormalizeAngle(angle)
    if angle == nil then return 0 end
	while angle > 179 do angle = angle - 359 end
	while angle < -180 do angle = angle + 360 end
	return angle
end
local function AngleDifference(dest_angle, src_angle)
	local delta = math.fmod(dest_angle - src_angle, 360)
	if dest_angle > src_angle then
		if delta >= 180 then delta = delta - 360 end
	else
		if delta <= -180 then delta = delta + 360 end
	end
	return delta
end
local function AngleVector(pitch, yaw)
    if pitch ~= nil and yaw ~= nil then 
        local p, y = math.rad(pitch), math.rad(yaw)
        local sp, cp, sy, cy = math.sin(p), math.cos(p), math.sin(y), math.cos(y)
        return cp*cy, cp*sy, -sp
    end
    return 0,0,0
end
local function CalcAngle(localplayerxpos, localplayerypos, enemyxpos, enemyypos)
    local relativeyaw = math.atan( (localplayerypos - enemyypos) / (localplayerxpos - enemyxpos) )
    return relativeyaw * 180 / math.pi
end
local function AngleFromVectors(a, b)
    local angles = {}
    local delta = a - b
    local hyp = delta:length2d()
    angles.y = math.atan(delta.y / delta.x) * 57.2957795131
    angles.x = math.atan(delta.z / hyp) * 57.2957795131
    angles.z = 0.0
    if delta.x >= 0.0 then angles.y = angles.y + 180.0 end
    return angles
end
local function DegToRad(Deg) return Deg * (math.pi / 180) end
local function RadToDeg(Rad) return Rad * (180 / math.pi) end
local Lerp = function(a, b, t) return a + (b - a) * t end

local VTable = {
    Entry = function(instance, index, type) return ffi.cast(type, (ffi.cast("void***", instance)[0])[index]) end,
    Bind = function(self, module, interface, index, typestring)
        local instance = client.create_interface(module, interface)
        local fnptr = self.Entry(instance, index, ffi.typeof(typestring))
        return function(...) return fnptr(instance, ...) end
    end
}

local animstate_t = ffi.typeof 'struct { char pad0[0x18]; float anim_update_timer; char pad1[0xC]; float started_moving_time; float last_move_time; char pad2[0x10]; float last_lby_time; char pad3[0x8]; float run_amount; char pad4[0x10]; void* entity; void* active_weapon; void* last_active_weapon; float last_client_side_animation_update_time; int	 last_client_side_animation_update_framecount; float eye_timer; float eye_angles_y; float eye_angles_x; float goal_feet_yaw; float current_feet_yaw; float torso_yaw; float last_move_yaw; float lean_amount; char pad5[0x4]; float feet_cycle; float feet_yaw_rate; char pad6[0x4]; float duck_amount; float landing_duck_amount; char pad7[0x4]; float current_origin[3]; float last_origin[3]; float velocity_x; float velocity_y; char pad8[0x4]; float unknown_float1; char pad9[0x8]; float unknown_float2; float unknown_float3; float unknown; float m_velocity; float jump_fall_velocity; float clamped_velocity; float feet_speed_forwards_or_sideways; float feet_speed_unknown_forwards_or_sideways; float last_time_started_moving; float last_time_stopped_moving; bool on_ground; bool hit_in_ground_animation; char pad10[0x4]; float time_since_in_air; float last_origin_z; float head_from_ground_distance_standing; float stop_to_full_running_fraction; char pad11[0x4]; float magic_fraction; char pad12[0x3C]; float world_force; char pad13[0x1CA]; float min_yaw; float max_yaw; } **'
local animlayer_t = ffi.typeof 'struct { char pad_0x0000[0x18]; uint32_t sequence; float prev_cycle; float weight; float weight_delta_rate; float playback_rate; float cycle; void *entity;char pad_0x0038[0x4]; } **'
local NativeGetClientEntity = VTable:Bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")

local NullPtr, CharPtr, ClassPtr = ffi.new "void*", ffi.typeof "char*", ffi.typeof "void***"

local EnableResolver = ui.new_checkbox("Lua", "A", "BloxResolver\aCFCFCFCF  [UPDATED]")

local GetAnimState = function(ent)
    if not ent then return false end
    local Address = type(ent) == "cdata" and ent or NativeGetClientEntity(ent)
    if not Address or Address == ffi.NULL then return false end
    local AddressVtable = ffi.cast("void***", Address)
    return ffi.cast(animstate_t, ffi.cast("char*", AddressVtable) + 0x9960)[0]
end

local GetSimulationTime = function(ent)
    local pointer = NativeGetClientEntity(ent)
    if pointer then return entity.get_prop(ent, "m_flSimulationTime"), ffi.cast("float*", ffi.cast("uintptr_t", pointer) + 0x26C)[0] else return 0 end
end

local GetAnimlayers = function (ent, layer)
    local pointer = NativeGetClientEntity(ent)
    if pointer then return ffi.cast(animlayer_t, ffi.cast('char*', ffi.cast("void***", pointer)) + 0x3914)[0][layer or 0] end
end

local IsPlayerValid = function(player)
    if not player then return false end
    if not entity.is_alive(player) then return false end
    return true
end

local GetMaxDesync = function(player)
    local Animstate = GetAnimState(player)
    if not Animstate then return 0 end
    local speedfactor = Clamp(Animstate.feet_speed_forwards_or_sideways, 0, 1)
    local avg_speedfactor = (Animstate.stop_to_full_running_fraction * -0.3 - 0.2) * speedfactor + 1
    local duck_amount = Animstate.duck_amount
    if duck_amount > 0 then avg_speedfactor = avg_speedfactor + ((duck_amount * speedfactor) * (0.5 - avg_speedfactor)) end
    return Clamp(avg_speedfactor, .5, 1)
end

local IsPlayerAnimating = function(player)
    local CurrentSimulationTime, RecordSimulationTime = GetSimulationTime(player)
    CurrentSimulationTime, RecordSimulationTime = toticks(CurrentSimulationTime), toticks(RecordSimulationTime)
    return toticks(CurrentSimulationTime) ~= nil and toticks(RecordSimulationTime) ~= nil
end

local GetChokedPackets = function(player)
    if not IsPlayerAnimating(player) then return 0 end
    local CurrentSimulationTime, PreviousSimulationTime = GetSimulationTime(player)
    local SimulationTimeDifference = globals.curtime() - CurrentSimulationTime
    local ChokedCommands = Clamp(toticks(math.max(0.0, SimulationTimeDifference - client.latency())), 0, cvar.sv_maxusrcmdprocessticks:get_string() - 2)
    return ChokedCommands
end

function RebuildServerYaw(player)
    local Animstate = GetAnimState(player)
    if not Animstate then return 0 end
    
    local m_flGoalFeetYaw = Animstate.goal_feet_yaw
    local eye_feet_delta = AngleDifference(Animstate.eye_angles_y, Animstate.goal_feet_yaw)
    local flRunningSpeed = Clamp(Animstate.feet_speed_forwards_or_sideways, 0.0, 1.0)
    
    local flYawModifier = (((Animstate.stop_to_full_running_fraction * -0.3) - 0.2) * flRunningSpeed) + 1.0
    if Animstate.duck_amount > 0.0 then
        local flDuckingSpeed = Clamp(Animstate.feet_speed_forwards_or_sideways, 0.0, 1.0)
        flYawModifier = flYawModifier + ((Animstate.duck_amount * flDuckingSpeed) * (0.5 - flYawModifier))
    end
   
    local flMaxYawModifier = flYawModifier * Animstate.max_yaw
    local flMinYawModifier = flYawModifier * Animstate.min_yaw
   
    if eye_feet_delta <= flMaxYawModifier then
        if flMinYawModifier > eye_feet_delta then
            m_flGoalFeetYaw = math.abs(flMinYawModifier) + Animstate.eye_angles_y
        end
    else
        m_flGoalFeetYaw = Animstate.eye_angles_y - math.abs(flMaxYawModifier)
    end

	return NormalizeAngle(m_flGoalFeetYaw)
end

local Cache = {}

local JitterBuffer = 6
local Resolver = { 
    Jitter = { Jittering = false, JitterTicks = 0, StaticTicks = 0, YawCache = {}, JitterCache = 0, Difference = 0 },
    Main = { Mode = 0, Side = 0, Angles = 0 }
}

local Cache = {}

local CDetectJitter = function(player)
    local Data = Resolver.Jitter
    local EyeAnglesX, EyeAnglesY, EyeAnglesZ = entity.get_prop(player, "m_angEyeAngles")
    Data.YawCache[Data.JitterCache % JitterBuffer] = EyeAnglesY
    if Data.JitterCache >= JitterBuffer + 1 then
        Data.JitterCache = 0
    else
        Data.JitterCache = Data.JitterCache + 1
    end
    for i = 0, JitterBuffer, 1 do
        if i < JitterBuffer then
            local Difference = (Data.YawCache[i - Data.JitterCache % JitterBuffer] ~= nil and Data.YawCache[Data.JitterCache % JitterBuffer] ~= nil) and math.abs(Data.YawCache[i - Data.JitterCache % JitterBuffer] - Data.YawCache[Data.JitterCache % JitterBuffer]) or 0
            if Difference ~= nil and Difference ~= 0.0 then
                NormalizeAngle(Difference)
                Data.Jittering = Difference >= (45.0 * GetMaxDesync(player)) and true or false
                Data.Difference = Difference
            end
        end
    end
end

local CProcessImpact = function(player) return Resolver.Jitter.Jittering and 1 or 0 end

local CGetPointDirection = function(player)
    local fw = vector()
    local LocalOriginX, LocalOriginY, LocalOriginZ = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
    local LocalOrigin = vector(LocalOriginX, LocalOriginY)
    local PlayerOriginX, PlayerOriginY, PlayerOriginZ = entity.get_prop(player, "m_vecOrigin")
    local PlayerOrigin = vector(PlayerOriginX, PlayerOriginY)
    local AtTarget = AngleFromVectors(LocalOrigin, PlayerOrigin).y
    AngleVector(AtTargetX, AtTargetY)
    return fw
end

local CDetectDesyncSide = function(player)
    local Animstate = GetAnimState(player)
    if not Animstate then return 0 end
    local EyeAnglesX, EyeAnglesY, EyeAnglesZ = entity.get_prop(player, "m_angEyeAngles")
    local InverseSide = function(player)
        local VecOriginX, VecOriginY, VecOriginZ = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local AbsOriginX, AbsOriginY, AbsOriginZ = entity.get_prop(entity.get_local_player(), "m_vecAbsOrigin")
        local EyeAnglesX, EyeAnglesY, EyeAnglesZ = entity.get_prop(player, "m_angEyeAngles")
        
        local VecOrigin = vector(VecOriginX, VecOriginY, VecOriginZ)
        local AbsOrigin = vector(AbsOriginX, AbsOriginY, AbsOriginZ)
        local EyeAngles = vector(EyeAnglesX, EyeAnglesY, EyeAnglesZ)
        
        local AtTarget = NormalizeAngle(AngleFromVectors(VecOrigin, AbsOrigin).y)
        local Angle = NormalizeAngle(EyeAngles.y)
        local SidewaysLeft = math.abs(NormalizeAngle(Angle - NormalizeAngle(AtTarget - 90.0))) < 45.0
        local SidewaysRight = math.abs(NormalizeAngle(Angle - NormalizeAngle(AtTarget + 90.0))) < 45.0
        local Forward = math.abs(NormalizeAngle(Angle - NormalizeAngle(AtTarget + 180.0))) < 45.0
        return Forward and not (SidewaysLeft or SidewaysRight)
    end

    if Resolver.Jitter.Jittering and GetChokedPackets(player) < 3 then
        Cache.FirstNormalizedAngle = NormalizeAngle(Resolver.Jitter.YawCache[JitterBuffer - 1])
        Cache.SecondNormalizedAngle = NormalizeAngle(Resolver.Jitter.YawCache[JitterBuffer - 2])

        Cache.FirstSinAngle = math.sin(DegToRad(Cache.FirstNormalizedAngle))
        Cache.SecondSinAngle = math.sin(DegToRad(Cache.SecondNormalizedAngle))

        Cache.FirstCosAngle = math.cos(DegToRad(Cache.FirstNormalizedAngle))
        Cache.SecondCosAngle = math.cos(DegToRad(Cache.SecondNormalizedAngle))

        Cache.AVGYaw = NormalizeAngle(RadToDeg(math.atan2((Cache.FirstSinAngle + Cache.SecondSinAngle) / 2.0, (Cache.FirstCosAngle + Cache.SecondCosAngle) / 2.0)))
        Cache.Difference = NormalizeAngle(Animstate.eye_angles_y - Cache.AVGYaw)
        if Cache.Difference ~= 0.0 then Resolver.Main.Side = Cache.Difference > 0.0 and 1 or -1 else Resolver.Main.Side = 0 end
    end

    return Resolver.Main.Side
end

local CResolverInstance = function(player)
    local Animstate = GetAnimState(player)
    if not Animstate then return end

    CProcessImpact(player)
    CDetectJitter(player)
    CDetectDesyncSide(player)

    local ChokedPackets = GetChokedPackets(player)
    local SimulationTime, PreviousSimulationTime = GetSimulationTime(player)
    for i = 0, ChokedPackets, 1 do
        local NotSentTick = i == ChokedPackets - 1
        local BackupSimulationTime = SimulationTime
        if IsPlayerAnimating(player) then BackupSimulationTime = SimulationTime - totime(ChokedPackets - i - 1) end
        if Resolver.Jitter.Jittering and not NotSentTick then
            Resolver.Main.Angles = Cache.Difference ~= nil and (Cache.Difference * GetMaxDesync(player)) * Resolver.Main.Side or (45.0 * GetMaxDesync(player)) * Resolver.Main.Side
            Resolver.Main.Mode = 1
        else
            Resolver.Main.Angles = 0
            Resolver.Main.Mode = 0
        end
    end
end

client.set_event_callback("net_update_end", function()
    if not entity.get_local_player() then return end
    if not entity.is_alive(entity.get_local_player()) then Resolver.Main.Mode = 0 return end
    local Players = entity.get_players() client.update_player_list()
    for i = 1, #Players do
        local idx = Players[i]
        if entity.is_enemy(idx) and IsPlayerAnimating(idx) and ui.get(EnableResolver) then
            CResolverInstance(idx)
            plist.set(idx, "Force body yaw value", Resolver.Main.Mode ~= 0 and Resolver.Main.Angles or 0)
            plist.set(idx, "Force body yaw", Resolver.Main.Mode ~= 0)
        else
            plist.set(idx, "Force body yaw", false)
        end
    end
end)

client.register_esp_flag("JITTER", 200, 200, 200, function(e) return (entity.is_enemy(e) and ui.get(EnableResolver) and Resolver.Main.Mode == 1) and true or false end)
local sentences = {
    "$name, I'M ＨＶＨＫＩＮＧ t.me/BloxResolver", 
    "$name, 《Убийца резиков》 t.me/BloxResolver",
    "$name, Выебал шлюху  t.me/BloxResolver",
    "$name, JOHNPORK CALLING - t.me/BloxResolver ", 
    "$name, кушай калл свинота by t.me/BloxResolver ",
    "$name, ТАПНУЛ ТЯ ВЫБЛЯДОК t.me/BloxResolver ",
    "$name, Че в хуй? Че деду? Че бабке? Че матухе? EZ", 
    "$name, Я ВЪЕБАЛ ТЕБЯ ЛОШАРА ХАХАХАХАХАХАХ ", 
    "$name, КАК ТЫ УМЕР ХАХВПВХПХВПХХПАХПВХАП t.me/BloxResolver",
    "$name, 1 by t.me/BloxResolver", 
    "$name 𝙩𝙞 𝙯𝙖𝙗𝙚𝙧𝙚𝙢𝙚𝙣𝙞𝙡𝙖 𝙨𝙝𝙡𝙪𝙝𝙖 ! t.me/BloxResolver",
    "$name ✈ ТЫ КАК СЫН МИЯГИ ЗАЛЕТЕЛ ОТ МЕНЯ ^-^",
    "$name мой кд это 10.62   t.me/BloxResolver",
    "$name 𝘒𝘜𝘔𝘚𝘩𝘖𝘛𝘐𝘒 t.me/BloxResolver",
    "$name, ЕБАТЬ Я ТЕБЯ ТРАХНУЛ ШЛЮХА t.me/BloxResolver",
    "*DEAD* $name : <--- Сосущий педик",
    "$name, КАКОЙ ТВОЙ НИК ПОЗОРИЩЕ t.me/BloxResolver",
    "$name  НАКОНЧАЛ ТУПОМУ БИЧУ В РОТ t.me/BloxResolver",
    "$name 1 ЖИРДЯЙ t.me/BloxResolver",

	}

local ui = {
    new_checkbox = ui.new_checkbox,
    get = ui.get
}

local client = {
    set_event_callback = client.set_event_callback,
    userid_to_entindex = client.userid_to_entindex,
    exec = client.exec,
    log = client.log
}

local entity = {
    get_local_player = entity.get_local_player,
    get_player_name = entity.get_player_name
}

local killsay_enabled = ui.new_checkbox("LUA", "A", "[BloxResolver] TRASHTALK")
local killsayName_enabled = ui.new_checkbox("LUA","A","[BloxResolver] NAME [TRASHTALK]")

local function on_player_death(event)
    if not ui.get(killsay_enabled) then return end

    local local_player = entity.get_local_player()
    local attacker = client.userid_to_entindex(event.attacker)
    local victim = client.userid_to_entindex(event.userid)

    if local_player == nil or attacker == nil or victim == nil then
        return
    end

    if attacker == local_player and victim ~= local_player then
	
		if ui.get(killsayName_enabled) then
		
		local killsay = "say " .. sentences[math.random(#sentences)]
        killsay = string.gsub(killsay, "$name", entity.get_player_name(victim))
        client.log(killsay)
        client.exec(killsay)
		
		else
		
		local killsay = "say " .. sentences[math.random(#sentences)]
        killsay = string.gsub(killsay, "$name,", " ")
        client.log(killsay)
        client.exec(killsay)
		
		end
	end
end
math.randomseed(133742069)
math.random(); math.random(); math.random()

client.set_event_callback("player_death", on_player_death)
local unhittable_aa_enabled = ui.new_checkbox("LUA", "B", "[BloxResolver] UNHITTABLE AA")

if ui.get(unhittable_aa_enabled) then
    cmd.yaw = cmd.yaw + math.random(-60, 60)
    cmd.pitch = math.random(80, 89)
end
local quantum_desync_enabled = ui.new_checkbox("LUA", "B", "[BloxResolver] QUATUM DESYNC")

if ui.get(quantum_desync_enabled) then
    cmd.yaw = cmd.yaw + math.random(-80, 80)
end
local shot_sync_fix_enabled = ui.new_checkbox("LUA", "B", "[BloxResolver] Shot Sync Fix")
    
if ui.get(shot_sync_fix_enabled) then
    cmd.tickcount = cmd.tickcount - 8 -- Fixes shot timing
end
local auto_headshot_enabled = ui.new_checkbox("LUA", "A", "[BloxResolver] ONLY HS")
    
if ui.get(auto_headshot_enabled) then
    cmd.hitbox = 0 -- Locks onto head first
end
local shots = {
    hit = {},
    missed = { 0, 0, 0, 0, 0 },
    total = 0
}
local hitgroups = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "unknown", "gear" }

client.set_event_callback("aim_hit", function(shot)
    table.insert(shots.hit, {
        entity.get_player_name(shot.target),
        shot.hit_chance,
        shot.damage,
        hitgroups[shot.hitgroup + 1] or "unknown"
    })
end)
client.set_event_callback("aim_miss", function(shot)
    if shot.reason == "spread" then shots.missed[1] = shots.missed[1] + 1 end;if shot.reason == "prediction error" then shots.missed[2] = shots.missed[2] + 1 end;if shot.reason == "death" then shots.missed[3] = shots.missed[3] + 1 end;if shot.reason == "?" then shots.missed[4] = shots.missed[4] + 1 end
end)

client.set_event_callback("paint", function()
    shots.missed[5] = shots.missed[1] + shots.missed[2] + shots.missed[4]
    renderer.text(5, 500, 255, 255, 255, 255, "", 0, string.format("%d / %d (%s)", #shots.hit, shots.missed[5], #shots.hit+shots.missed[5] ~= 0 and string.format("%.1f%%", (#shots.hit/(#shots.hit+shots.missed[5]))*100) or "no data"))
end)

client.set_event_callback("console_input", function(inp)
    if inp:sub(1, 12) == "print_misses" then
        client.color_log(180, 180, 180, string.format("spread: %d\nprediction errors: %d\ndeath: %d\nunknown: %d", shots.missed[1], shots.missed[2], shots.missed[3], shots.missed[4]))
        return true
    end
    if inp:sub(1, 10) == "print_hits" then
        for i=1, #shots.hit do
            curr = shots.hit[i]
            client.color_log(180, 180, 180, string.format("[%d] %s's %s - hc:%d%%, dmg:%d", i, curr[1], curr[4], curr[2], curr[3]))
        end
        return true
    end
end)
client.set_event_callback("player_connect_full", function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        shots.missed[1] = 0;shots.missed[2] = 0;shots.missed[3] = 0;shots.missed[4] = 0
        for k in pairs(shots.hit) do shots.hit[k] = nil end
    end
end)
