-- @param: Custom API Calls
local ffi = require "ffi"

local Utils = {}
local Engine = {}
local Entity = {}
local Hooks = {}
local LagRecord = {}
local LogRecord = {}
local ResRecord = {}

function InitUtils()
    Utils.SafeError = function(m_szFunction, m_szError, ret)
        print('[metaset](' .. m_szFunction .. ') ' .. m_szError)
        return ret
    end
    
    Utils.GetVFunc = function(vtable, index)
        return ffi.cast("uintptr_t**", vtable)[0][index]
    end
    
    Utils.CreateInterface = function(module, interface)
        return client.create_interface(module, interface)
    end
    
    Utils.FindSignature = function(module, sequence)
        return client.find_signature(module, sequence)   
    end
end
InitUtils()

function InitEngine()
    Engine.Connected = function()
        return entity.get_local_player() and entity.is_alive(entity.get_local_player())
    end
    
    Engine.GetTickcount = function()
        return globals.tickcount()
    end

    Engine.m_MaxUserCommandProcessTicks = function()
        return cvar.sv_maxusrcmdprocessticks:get_int()
    end
end
InitEngine()

function InitMath()
    math.lerp = function(a, b, t)
        return a + (b - a) * t 
    end

    math.TICK_INTERVAL = function()
        return globals.tickinterval()
    end
    
    math.TIME_TO_TICKS = function(dt)
        return math.floor(0.5 + dt) / math.TICK_INTERVAL()
    end
    
    math.TICKS_TO_TIME = function(t)
        return math.TICK_INTERVAL() * t
    end
    
    math.angle_diff = function(dest, src)
        local delta = 0.0
    
        delta = math.fmod(dest - src, 360.0)
    
        if dest > src then
            if delta >= 180 then delta = delta - 360 end
        else
            if delta <= -180 then delta = delta + 360 end
        end
    
        return delta
    end
    
    math.clamp = function(v, min, max)
        if min > max then min, max = max, min end
        if v > max then return max end
        if v < min then return min end
        return v
    end
    
    math.lerp = function(a, b, t)
        return a + (b - a) * t
    end
    
    math.angle_normalize = function(angle)
        local ang = 0.0
        ang = math.fmod(angle, 360.0)
    
        if ang < 0.0 then ang = ang + 360 end
    
        return ang
    end
    
    math.anglemod = function(a)
        local num = (360 / 65536) * bit.band(math.floor(a * (65536 / 360.0), 65535))
        return num
    end
    
    math.ApproachAngle = function(target, value, speed)
        target = math.anglemod(target)
        value = math.anglemod(value)
    
        local delta = target - value
    
        if speed < 0 then speed = -speed end
    
        if delta < -180 then
            delta = delta + 360
        elseif delta > 180 then
            delta = delta - 360
        end
    
        if delta > speed then
            value = value + speed
        elseif delta < -speed then
            value = value - speed
        else
            value = target
        end
    
        return value
    end

    entity.get_vector_prop = function(idx, prop, array)
        local v1, v2, v3 = entity.get_prop(idx, prop, array)
        return {
            x = v1, y = v2, z = v3
        }
    end
    
    math.VectorLength2d = function(vec3d)
        if not vec3d.x or not vec3d.y then return Utils.SafeError("math.VectorLength2d", 'unable to get ' .. (vec3d.x and "vec3d.y" or "vec3d.x"), 0) end
        root = 0.0
        sqst = vec3d.x * vec3d.x + vec3d.y * vec3d.y
        root = math.sqrt(sqst)
        return root
    end
end
InitMath()

--[[ -- we don t use hooks atm
function InitHooks()
    local raw = {}
    raw.pGetModuleHandle_sig = Utils.FindSignature("engine.dll", " FF 15 ? ? ? ? 85 C0 74 0B") or error('[Hooks] Failed to init pGetModuleHandle')
    raw.pGetProcAddress_sig = Utils.FindSignature("engine.dll", " FF 15 ? ? ? ? A3 ? ? ? ? EB 05") or error('[Hooks] Failed to init pGetProcAddress')
    raw.pGetProcAddress = ffi.cast("uint32_t**", ffi.cast("uint32_t", raw.pGetProcAddress_sig) + 2)[0][0]
    raw.fnGetProcAddress = ffi.cast("uint32_t(__stdcall*)(uint32_t, const char*)", raw.pGetProcAddress)
    raw.pGetModuleHandle = ffi.cast("uint32_t**", ffi.cast("uint32_t", raw.pGetModuleHandle_sig) + 2)[0][0]
    raw.fnGetModuleHandle = ffi.cast("uint32_t(__stdcall*)(const char*)", raw.pGetModuleHandle)

    local helpers = {}
    helpers.procBind = function(moduleName, functionName, typedef)
        return ffi.cast(ffi.typeof(typedef), raw.fnGetProcAddress(raw.fnGetModuleHandle(moduleName), functionName))
    end

    raw.nativeVirtualProtect = helpers.procBind("kernel32.dll", "VirtualProtect", "int(__stdcall*)(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect)")

    helpers.virtualProtect = function(lpAddress, dwSize, flNewProtect, lpflOldProtect)
        return raw.nativeVirtualProtect(ffi.cast("void*", lpAddress), dwSize, flNewProtect, lpflOldProtect)
    end

    Hooks.hooks = {}
    Hooks.Create = function(vt)
        local cache = {
            newHook = {},
            orgFunc = {},
            oldProt = ffi.new("unsigned long[1]"),
            virtualTable = ffi.cast("intptr_t**", vt)[0]
        }

        cache.newHook.this = cache.virtualTable
        cache.newHook.hookMethod = function(cast, func, method)
            cache.orgFunc[method] = cache.virtualTable[method]
            helpers.virtualProtect(cache.virtualTable + method, 4, 0x4, cache.oldProt)

            cache.virtualTable[method] = ffi.cast("intptr_t", ffi.cast(cast, func))
            helpers.virtualProtect(cache.virtualTable + method, 4, cache.oldProt[0], cache.oldProt)

            return ffi.cast(cast, cache.orgFunc[method])
        end
        cache.newHook.unHookMethod = function(method)
            helpers.virtualProtect(cache.virtualTable + method, 4, 0x4, cache.oldProt)
            cache.virtualTable[method] = cache.orgFunc[method]

            helpers.virtualProtect(cache.virtualTable + method, 4, cache.oldProt[0], cache.oldProt)
            cache.orgFunc[method] = nil
        end
        cache.newHook.unHookAll = function()
            for method, func in pairs(cache.orgFunc) do
                cache.newHook.unHookMethod(method)
            end
        end

        table.insert(Hooks.hooks, cache.newHook.unHookAll)
        return cache.newHook
    end

    callbacks.add(e_callbacks.SHUTDOWN, function()
        bUnloaded = true
        for i, unHookFunc in ipairs(Hooks.hooks) do
            unHookFunc()
        end
    end)
end
InitHooks()]]

ffi.cdef[[
    typedef struct
    {
        float x;
        float y;
        float z;
    } vec3_t;

    typedef struct
    {
        float   m_anim_time;		
        float   m_fade_out_time;	
        int     m_flags;			
        int     m_activity;			
        int     m_priority;			
        int     m_order;			
        int     m_sequence;			
        float   m_prev_cycle;		
        float   m_weight;			
        float   m_weight_delta_rate;
        float   m_playback_rate;	
        float   m_cycle;			
        void* m_owner;			
        int     m_bits;				
    } C_AnimationLayer;

    typedef struct
    {
        char        pad0[0x60]; // 0x00
        void*       pEntity; // 0x60
        void*       pActiveWeapon; // 0x64
        void*       pLastActiveWeapon; // 0x68
        float        flLastUpdateTime; // 0x6C
        int            iLastUpdateFrame; // 0x70
        float        flLastUpdateIncrement; // 0x74
        float        flEyeYaw; // 0x78
        float        flEyePitch; // 0x7C
        float        flGoalFeetYaw; // 0x80
        float        flLastFeetYaw; // 0x84
        float        flMoveYaw; // 0x88
        float        flLastMoveYaw; // 0x8C // changes when moving/jumping/hitting ground
        float        flLeanAmount; // 0x90
        char        pad1[0x4]; // 0x94
        float        flFeetCycle; // 0x98 0 to 1
        float        flMoveWeight; // 0x9C 0 to 1
        float        flMoveWeightSmoothed; // 0xA0
        float        flDuckAmount; // 0xA4
        float        flHitGroundCycle; // 0xA8
        float        flRecrouchWeight; // 0xAC
        vec3_t    vecOrigin; // 0xB0
        vec3_t    vecLastOrigin;// 0xBC
        vec3_t    vecVelocity; // 0xC8
        vec3_t    vecVelocityNormalized; // 0xD4
        vec3_t    vecVelocityNormalizedNonZero; // 0xE0
        float        flVelocityLenght2D; // 0xEC
        float        flJumpFallVelocity; // 0xF0
        float        flSpeedNormalized; // 0xF4 // clamped velocity from 0 to 1
        float        flRunningSpeed; // 0xF8
        float        flDuckingSpeed; // 0xFC
        float        flDurationMoving; // 0x100
        float        flDurationStill; // 0x104
        bool        bOnGround; // 0x108
        bool        bHitGroundAnimation; // 0x109
        char        pad2[0x2]; // 0x10A
        float        flNextLowerBodyYawUpdateTime; // 0x10C
        float        flDurationInAir; // 0x110
        float        flLeftGroundHeight; // 0x114
        float        flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
        float        flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
        char        pad3[0x4]; // 0x120
        float        flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
        char        pad4[0x208]; // 0x128
        char pad_because_yes[0x4]; // 0x330
        float        flMinBodyYaw; // 0x330 + 0x4
        float        flMaxBodyYaw; // 0x334 + 0x4
        float        flMinPitch; //0x338 + 0x4
        float        flMaxPitch; // 0x33C + 0x4
        int            iAnimsetVersion; // 0x340 + 0x4
    } CCSGOPlayerAnimationState_t;

    
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef uintptr_t (__thiscall* GetClientEntityHandle_4242425_t)(void*, uintptr_t);
]]

function INT(var)
    return ffi.cast('int', var)
end

function UINTPTR_T(var)
    return ffi.cast('uintptr_t', var)
end

local utilitize = {
    this_call = function(call_function, parameters)
        return function(...)
            return call_function(parameters, ...)
        end
    end;

    entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), client.create_interface("client.dll", "VClientEntityList003"));
}
local get_entity_address = utilitize.this_call(ffi.cast("get_client_entity_t", utilitize.entity_list_003[0][3]), utilitize.entity_list_003);

function InitEntity()
    local engine_client = Utils.CreateInterface( "engine.dll", "VEngineClient014" )
    local VClientEntityList003 = Utils.CreateInterface( "client.dll", "VClientEntityList003" )

    local engine_client_vftable = ffi.cast( "void***", engine_client )
    local entity_list_vftable = ffi.cast( "void***", VClientEntityList003 )

    local get_local_player = ffi.cast( "int( __thiscall* )( void* )", Utils.GetVFunc( engine_client, 12 ) )
    local get_client_entity = ffi.cast( "void*( __thiscall* )( void*, int )", Utils.GetVFunc( VClientEntityList003, 3 ) )
    local get_handle_entity = ffi.cast( "void*( __thiscall* )( void*, int )", Utils.GetVFunc( VClientEntityList003, 4 ) )

    Entity.Registered = {
        m_iIndex = -1,
        m_szType = 'Entity',
        m_hAddress = nil
    }

    function Entity.Registered:new(o)
        o = o or {}
        setmetatable(o, self)
        self.__index = self
        return o
    end

    function Entity.Registered:m_iHealth()
        return ffi.cast('int*', ffi.cast('unsigned int', self.m_hAddress) + 0x100)[0]
    end

    function Entity.Registered:m_iTeamNum()
        return ffi.cast('int*', ffi.cast('unsigned int', self.m_hAddress) + 0xF4)[0]
    end

    function Entity.Registered:m_nAnimationLayers()
        return ffi.cast("C_AnimationLayer**", ffi.cast("uintptr_t", self.m_hAddress) + 0x2990)[0]
    end

    -- local m_PlayerAnimState = ffi.cast("uintptr_t*", Utils.FindSignature("client.dll", "\x8B\x8E\xCC\xCC\xCC\xCC\xF3\x0F\x10\x48\x04\xE8\xCC\xCC\xCC\xCC\xE9") + 2)[0]
    function Entity.Registered:m_nAnimationState(index)
        local player_ptr = get_entity_address(index)
        return ffi.cast("CCSGOPlayerAnimationState_t**", ffi.cast("uintptr_t", player_ptr) + 0x9960)[0]
    end

    function Entity.Registered:m_nPoses()
        return ffi.cast("float*", ffi.cast("uintptr_t", self.m_hAddress) + 10104)
    end

    function Entity.Registered:m_bDormant()
        return ffi.cast("bool*", ffi.cast("uintptr_t", self.m_hAddress) + 0xED)[0]
    end

    function Entity.Registered:m_fFlags()
        return ffi.cast("float*", ffi.cast("uintptr_t", self.m_hAddress) + 0x104)[0]
    end

    function Entity.Registered:m_vecVelocity()
        return ffi.cast('vec3_t*', ffi.cast('unsigned int', self.m_hAddress) + 0x114)[0]
    end

    function Entity.Registered:m_flVelocityLength()
        return math.VectorLength2d(self:m_vecVelocity())
    end

    function Entity.Registered:m_flSimulationTime()
        return ffi.cast('float*', ffi.cast('uintptr_t', self.m_hAddress) + 0x268)[0]
    end

    function Entity.Registered:m_flOldSimulationTime()
        return ffi.cast('float*', ffi.cast('uintptr_t', self.m_hAddress) + 0x268 + ffi.sizeof('float'))[0]
    end

    function Entity.Registered:m_flLowerBodyYawTarget()
        return ffi.cast('float*', ffi.cast('uintptr_t', self.m_hAddress) + 0x9ADC)[0]
    end

    Entity.GetLocalPlayer = function()
        return get_local_player(engine_client_vftable)
    end

    Entity.Get = function(m_iIndex, m_bHandle, m_nEntity, m_nGetCheatEntity)
        if m_iIndex < 0 then return end
        if not Engine.Connected() then return end
        local addr = m_nEntity -- as void*
        if not addr then
            if m_bHandle then
                addr = get_handle_entity(entity_list_vftable, m_iIndex)
            else
                addr = get_client_entity(entity_list_vftable, m_iIndex)
            end
        end
        return Entity.Registered:new({
            m_iIndex = m_iIndex,
            m_szType = m_bHandle and 'Handle' or 'Entity',
            m_hAddress = addr
        })
    end

    Entity.GetProp = function(_type, address, offset)
        return ffi.cast(_type .. '*', ffi.cast('unsigned int', address) + offset)[0]
    end
end
InitEntity()

-- @param: Function Call Tables
local LagRecordHelpers = {}
local Resolver = {}
local PlayerList = {
    flDurationStill = {},
    iSide = {},
    iStandingSide = {},
    iCountStaticSwitch = {},
    flWalkToRunTransition = {},
    bWalkToRunTransitionState = {}
}

LagRecordHelpers.Init = function(m_iIndex, m_nAnimationLayers, m_nAnimationState, m_ChokedCommands, flLowerBodyYawTarget)
    if not LagRecord[m_iIndex] then LagRecord[m_iIndex] = {} end

    LagRecord[m_iIndex][3] = LagRecord[m_iIndex][2]
    LagRecord[m_iIndex][2] = LagRecord[m_iIndex][1]

    LagRecord[m_iIndex][1] = {
        m_nAnimationLayers = {
            [3] = {
                m_weight = m_nAnimationLayers[3].m_weight,
                m_cycle = m_nAnimationLayers[3].m_cycle,
                m_playback_rate = m_nAnimationLayers[3].m_playback_rate
            },
            [6] = {
                m_weight = m_nAnimationLayers[6].m_weight,
                m_cycle = m_nAnimationLayers[6].m_cycle,
                m_playback_rate = m_nAnimationLayers[6].m_playback_rate,
                m_sequence = m_nAnimationLayers[6].m_sequence
            }
        },
        m_nAnimationState = {
            flEyeYaw = m_nAnimationState.flEyeYaw,
            flGoalFeetYaw = m_nAnimationState.flGoalFeetYaw,
            flLastUpdateIncrement = m_nAnimationState.flLastUpdateIncrement,
            flVelocityLenght2D = m_nAnimationState.flVelocityLenght2D,
            flMoveYaw = m_nAnimationState.flMoveYaw,
            flWalkToRunTransition = m_nAnimationState.flWalkToRunTransition
        },
        m_ChokedCommands = m_ChokedCommands,
        flLowerBodyYawTarget = flLowerBodyYawTarget
    }
end

Resolver.UpdateAnimationState = function(m_player, m_nAnimationState)
    return {
        flEyeYaw = m_nAnimationState.flEyeYaw,
        flGoalFeetYaw = m_nAnimationState.flGoalFeetYaw,
        flLastUpdateIncrement = m_nAnimationState.flLastUpdateIncrement,
        flVelocityLenght2D = m_nAnimationState.flVelocityLenght2D,
        flMoveYaw = m_nAnimationState.flMoveYaw,
        flWalkToRunTransition = m_nAnimationState.flWalkToRunTransition
    }
end

Resolver.UpdateAnimationLayers = function(m_player)
    local m_nAnimationLayers = m_player:m_nAnimationLayers()
    return {
        [3] = {
            m_weight = m_nAnimationLayers[3].m_weight,
            m_cycle = m_nAnimationLayers[3].m_cycle,
            m_playback_rate = m_nAnimationLayers[3].m_playback_rate
        },
        [6] = {
            m_weight = m_nAnimationLayers[6].m_weight,
            m_cycle = m_nAnimationLayers[6].m_cycle,
            m_playback_rate = m_nAnimationLayers[6].m_playback_rate,
            m_sequence = m_nAnimationLayers[6].m_sequence
        }
    }
end

Resolver.DetectMicroMovement = function(m_player, m_record)
    if not m_player then return Utils.SafeError("DetectMicroMovement", 'Unable to get m_player', false) end
    if not m_record then return Utils.SafeError("DetectMicroMovement", 'Unable to get m_record', false) end

    return m_player:m_flVelocityLength() < 1 and m_record.m_nAnimationState.flVelocityLenght2D > 0
end

Resolver.IsSideChanged = function(m_player, m_record)
    if not m_player then return Utils.SafeError("IsSideChanged", 'Unable to get m_player', 0) end
    if not m_record then return Utils.SafeError("IsSideChanged", 'Unable to get m_record', 0) end

    local flVelocity = m_player:m_flVelocityLength()
    if flVelocity >= 1.1 and flVelocity <= 1.4 then
		flVelocity = 1.0
    end

    if Resolver.DetectMicroMovement(m_player, m_record) then
        return (m_record.m_nAnimationLayers[6].m_playback_rate / flVelocity * 100000 > 5.9 and 1 or -1)
    end

    local flMoveYaw = m_record.m_nAnimationState.flMoveYaw
    local bBackwards = flMoveYaw > 175 or flMoveYaw < -175
    local bForward = flMoveYaw == 0
    local bLeft = flMoveYaw >= -180 and flMoveYaw < -0
    local bLeftBack = flMoveYaw >= -140 and flMoveYaw <= -120
    local bRight = flMoveYaw > 0 and flMoveYaw <= 180

    if bRight then return -1 end
    if bBackwards then return -1 end
    return 1
end

Resolver.UpdateStandingTimer = function(m_player, m_record)
    if not m_player then return Utils.SafeError("UpdateStandingTimer", 'Unable to get m_player') end
    if not m_record then return Utils.SafeError("UpdateStandingTimer", 'Unable to get m_record') end

    if not PlayerList.flDurationStill then PlayerList.flDurationStill = {} end
    if not PlayerList.flDurationStill[m_player.m_iIndex] then PlayerList.flDurationStill[m_player.m_iIndex] = 0 end

    if m_player:m_flVelocityLength() > 1 then
        PlayerList.flDurationStill[m_player.m_iIndex] = 0
    else
        PlayerList.flDurationStill[m_player.m_iIndex] = (PlayerList.flDurationStill[m_player.m_iIndex] or 0) + m_record.m_nAnimationState.flLastUpdateIncrement * 20
    end
end

Resolver.DetectSwitchSide = function(m_player, m_record, m_oldrecord, m_evenolderrecord) 
    if not m_player then return Utils.SafeError("DetectSwitchSide", 'Unable to get m_player', false) end
    if not m_record then return Utils.SafeError("DetectSwitchSide", 'Unable to get m_record', false) end
    if not m_oldrecord then return Utils.SafeError("DetectSwitchSide", 'Unable to get m_oldrecord', false) end
    if not m_evenolderrecord then return Utils.SafeError("DetectSwitchSide", 'Unable to get m_evenolderrecord', false) end

    Resolver.UpdateStandingTimer(m_player, m_record)

    local flWeight = m_record.m_nAnimationLayers[6].m_weight
    local flPrevWeight = m_oldrecord.m_nAnimationLayers[6].m_weight

    local flOlderPrevPlaybackrate = m_evenolderrecord.m_nAnimationLayers[6].m_playback_rate * 100000
    local flPrevPlaybackrate = m_oldrecord.m_nAnimationLayers[6].m_playback_rate * 100000
    local flPlaybackrate = m_record.m_nAnimationLayers[6].m_playback_rate * 100000

    local flPreviousPlaybackrateDiff = (flOlderPrevPlaybackrate - flPrevPlaybackrate)
    local flPlaybackrateDiff = (flPlaybackrate - flPrevPlaybackrate)

    if Resolver.DetectMicroMovement(m_player, m_record) then
        if PlayerList.flDurationStill[m_player.m_iIndex] > 0 and PlayerList.flDurationStill[m_player.m_iIndex] <= (m_record.m_nAnimationState.flLastUpdateIncrement * 20) then
            return false
        end

        if flWeight > 0.0 then return true end

        return flPreviousPlaybackrateDiff == 0 and math.abs(flPlaybackrateDiff) > 1
    end

    if m_record.m_nAnimationState.flWalkToRunTransition < 1 then
        if flWeight ~= 1 then
            if flWeight ~= flPrevWeight then return true end
        else
            return math.floor(flPreviousPlaybackrateDiff + 0.5) == 0 and math.abs(flPlaybackrateDiff) > 1
        end
    end

    return false
end

Resolver.OnDirectionChange = function(m_player, bMicroMovement, m_record, m_oldrecord)
    if not m_player then return Utils.SafeError("OnDirectionChange", 'Unable to get m_player', 0) end
    if not m_record then return Utils.SafeError("OnDirectionChange", 'Unable to get m_record', 0) end
    if not m_oldrecord then return Utils.SafeError("OnDirectionChange", 'Unable to get m_oldrecord', 0) end

    if m_player:m_bDormant() then return false end
    if not bMicroMovement and not Resolver.DetectMicroMovement(m_player, m_record) then return false end

    return m_record.m_nAnimationState.flMoveYaw ~= m_oldrecord.m_nAnimationState.flMoveYaw
end

Resolver.UpdatePlayerDesyncSideMove = function(m_player, m_record, m_oldrecord, m_evenolderrecord, m_diff)
    if not m_player then return Utils.SafeError("UpdatePlayerDesyncSideMove", 'Unable to get m_player', 0) end
    local m_iIndex = m_player.m_iIndex
    if not PlayerList.iSide then PlayerList.iSide = {} end
    if not PlayerList.iSide[m_iIndex] then PlayerList.iSide[m_iIndex] = -1 end
    if not m_record then return Utils.SafeError("UpdatePlayerDesyncSideMove", 'Unable to get m_record', PlayerList.iSide[m_iIndex] or 0) end
    if not m_oldrecord then return Utils.SafeError("UpdatePlayerDesyncSideMove", 'Unable to get m_oldrecord', PlayerList.iSide[m_iIndex] or 0) end
    if not m_evenolderrecord then return Utils.SafeError("UpdatePlayerDesyncSideMove", 'Unable to get m_evenolderrecord', PlayerList.iSide[m_iIndex] or 0) end

    local flWeight = m_record.m_nAnimationLayers[6].m_weight
    local flPrevWeight = m_oldrecord.m_nAnimationLayers[6].m_weight

    local flOlderPrevPlaybackrate = m_evenolderrecord.m_nAnimationLayers[6].m_playback_rate * 100000
    local flPrevPlaybackrate = m_oldrecord.m_nAnimationLayers[6].m_playback_rate * 100000
    local flPlaybackrate = m_record.m_nAnimationLayers[6].m_playback_rate * 100000

    local flPreviousPlaybackrateDiff = (flOlderPrevPlaybackrate - flPrevPlaybackrate)
    local flPlaybackrateDiff = (flPlaybackrate - flPrevPlaybackrate)

    local bIsMoving = m_player:m_flVelocityLength() > 1
    local bIsMicromovement = Resolver.DetectMicroMovement(m_player, m_record)

    local bMovingCursor = bIsMicromovement and Resolver.OnDirectionChange(m_player, true, m_record, m_oldrecord)
    local flMinimalizer = bMovingCursor and 0.1 or 1

    if math.abs(flPlaybackrateDiff) > 0.1 / flMinimalizer and math.abs(flPreviousPlaybackrateDiff) > 0.1 / flMinimalizer then
        if math.abs(flPlaybackrateDiff - flPreviousPlaybackrateDiff) < 0.1  / flMinimalizer then
            return PlayerList.iSide[m_iIndex]
        end
    end

    local flJitteryDifference = math.abs(flPlaybackrate - flOlderPrevPlaybackrate)
    local bJitteryMicromovement = false

    if flPrevPlaybackrate <= 1 then
        if flOlderPrevPlaybackrate > 0 then
            if math.abs(flPlaybackrate - flPrevPlaybackrate) > 0.0 then
                if flJitteryDifference > 0 then
                    bJitteryMicromovement = true
                end
            end
        end
    end

    local bDetectSwitchKey = Resolver.DetectSwitchSide(m_player, m_record, m_oldrecord, m_evenolderrecord)
    if bDetectSwitchKey then
        --if PlayerList.iSide[m_iIndex] == 0 then client.log_screen('sex') end
        if not bJitteryMicromovement then
            -- m_diff
            --if m_player:m_flVelocityLength() >= 250 then
            --    PlayerList.iSide[m_iIndex] = Resolver.IsSideChanged(m_player, m_record)
            --else
            PlayerList.iSide[m_iIndex] = (m_diff < 0) and 1 or -1
            --end
        else
            PlayerList.iSide[m_iIndex] = (flJitteryDifference > 0.1 * flMinimalizer) and 1 or -1

            if bit.band(m_player:m_fFlags(), bit.lshift(1, 1)) ~= 0 then -- FL_DUCKING
                PlayerList.iSide[m_iIndex] = PlayerList.iSide[m_iIndex] * -1
            end
        end
    end

    return PlayerList.iSide[m_iIndex]
end

Resolver.GetMaxDesync = function(m_nAnimationState)
    local speedfactor = m_nAnimationState.flSpeedNormalized
    local avg_speedfactor = (m_nAnimationState.flAffectedFraction * -0.3 - 0.2) * speedfactor + 1

    local duck_amount = m_nAnimationState.flDuckAmount
    if duck_amount > 0 then
        local duck_speed = duck_amount * speedfactor

        avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
    end

    return avg_speedfactor
end

Resolver.CalculatePredictedWalkToRunTransition = function(m_flWalkToRunTransition, m_bWalkToRunTransitionState, m_flLastUpdateIncrement, m_flVelocityLengthXY)
    ANIM_TRANSITION_WALK_TO_RUN = false
    ANIM_TRANSITION_RUN_TO_WALK = true
    CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED = 2.0
    CS_PLAYER_SPEED_RUN = 260.0
    CS_PLAYER_SPEED_DUCK_MODIFIER = 0.34
    CS_PLAYER_SPEED_WALK_MODIFIER = 0.52

    if m_flWalkToRunTransition > 0 and m_flWalkToRunTransition < 1 then
        if m_bWalkToRunTransitionState == ANIM_TRANSITION_WALK_TO_RUN then
            m_flWalkToRunTransition = m_flWalkToRunTransition +  m_flLastUpdateIncrement * CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED
        else
            m_flWalkToRunTransition = m_flWalkToRunTransition - m_flLastUpdateIncrement * CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED
        end

        m_flWalkToRunTransition = math.clamp(m_flWalkToRunTransition, 0, 1)
    end

    if m_flVelocityLengthXY > (CS_PLAYER_SPEED_RUN * CS_PLAYER_SPEED_WALK_MODIFIER) and
        m_bWalkToRunTransitionState == ANIM_TRANSITION_RUN_TO_WALK then
        m_bWalkToRunTransitionState = ANIM_TRANSITION_WALK_TO_RUN
        m_flWalkToRunTransition = math.max(0.01, m_flWalkToRunTransition)
    elseif m_flVelocityLengthXY < (CS_PLAYER_SPEED_RUN * CS_PLAYER_SPEED_WALK_MODIFIER) and
        m_bWalkToRunTransitionState == ANIM_TRANSITION_WALK_TO_RUN then
        m_bWalkToRunTransitionState = ANIM_TRANSITION_RUN_TO_WALK
        m_flWalkToRunTransition = math.min(0.99, m_flWalkToRunTransition)
    end

    return m_flWalkToRunTransition, m_bWalkToRunTransitionState
end

Resolver.CalculatePredictedFootYaw = function(m_flFootYawLast, m_flEyeYaw, m_flLowerBodyYawTarget, m_flWalkToRunTransition, m_vecVelocity, m_flMinBodyYaw, m_flMaxBodyYaw)
    local m_flVelocityLengthXY = math.min(math.VectorLength2d(m_vecVelocity), 260.0)

    local m_flFootYaw = math.clamp(m_flFootYawLast, -360, 360)
    local flEyeFootDelta = math.angle_diff(m_flEyeYaw, m_flFootYaw)

    if flEyeFootDelta > m_flMaxBodyYaw then
        m_flFootYaw = m_flEyeYaw - math.abs(m_flMaxBodyYaw)
    elseif flEyeFootDelta < m_flMinBodyYaw then
        m_flFootYaw = m_flEyeYaw + math.abs(m_flMinBodyYaw)
    end

    m_flFootYaw = math.angle_normalize(m_flFootYaw)

    local m_flLastUpdateIncrement = math.TICK_INTERVAL()

    if m_flVelocityLengthXY > 0.1 or m_vecVelocity.z > 100 then
        m_flFootYaw = math.ApproachAngle(m_flEyeYaw, m_flFootYaw, m_flLastUpdateIncrement * (30.0 + 20.0 * m_flWalkToRunTransition))
    else
        m_flFootYaw = math.ApproachAngle(m_flLowerBodyYawTarget, m_flFootYaw, m_flLastUpdateIncrement * 100)
    end

    return m_flFootYaw
end

Resolver.Init = function(bShouldResolveYaw, m_player, m_iIndex, m_local, m_nAnimationState, m_record, m_oldrecord, m_olderrecord)
    if not bShouldResolveYaw then return end

    local m_nPrevAnimationState = m_oldrecord.m_nAnimationState
    local flLowerBodyYawDiff = math.angle_diff(m_record.flLowerBodyYawTarget, m_record.m_nAnimationState.flGoalFeetYaw)

    local flEyeFeetYawDiff = math.angle_diff(m_nAnimationState.flEyeYaw, m_nAnimationState.flGoalFeetYaw)
    local flPositiveAngleDiff = math.abs(flEyeFeetYawDiff)
    local flPrevEyeFeetYawDiff = math.angle_diff(m_nPrevAnimationState.flEyeYaw, m_nPrevAnimationState.flGoalFeetYaw)
    local flPositivePreviousAngleDiff = math.abs(flPrevEyeFeetYawDiff)

    local flServerVelocity2D = m_player:m_flVelocityLength()
    local bUpdatingAnimations = (((m_record.m_nAnimationState.flVelocityLenght2D > 0 and flServerVelocity2D <= 1) or flServerVelocity2D > 1 ) and true or false)

    local flMaxAllowedDesyncDeltaAngle = 57.295779513082
    local flDesyncDelta = Resolver.GetMaxDesync(m_nAnimationState) * flMaxAllowedDesyncDeltaAngle

    if flPositiveAngleDiff > 0 and flPositivePreviousAngleDiff > 0 then
        local bSafeToUseAngleDiff = true

        if flPositiveAngleDiff < flPositivePreviousAngleDiff then
            bSafeToUseAngleDiff = false

            if m_nAnimationState.flVelocityLenght2D > m_nPrevAnimationState.flVelocityLenght2D then
                bSafeToUseAngleDiff = true
            end
        end

        if m_record.m_nAnimationLayers[6].m_sequence == 979 then -- ACT_CSGO_IDLE_TURN_BALANCEADJUST
            bSafeToUseAngleDiff = true
        end

        if bSafeToUseAngleDiff then
            if flPositiveAngleDiff <= 10.0 and flPositivePreviousAngleDiff <= 10.0 then
                flDesyncDelta = math.max(flPositiveAngleDiff, flPositivePreviousAngleDiff)
            elseif flPositiveAngleDiff <= 35.0 and flPositivePreviousAngleDiff <= 35.0 then
                flDesyncDelta = math.max(29.0, math.max(flPositiveAngleDiff, flPositivePreviousAngleDiff))
            else
                flDesyncDelta = math.clamp(math.max(flPositiveAngleDiff, flPositivePreviousAngleDiff), 29.0, 58.0)
            end
        end
    end

    --[[
    if not PlayerList.iStandingSide[m_iIndex] then PlayerList.iStandingSide[m_iIndex] = 0 end
    if not PlayerList.iCountStaticSwitch[m_iIndex] then PlayerList.iCountStaticSwitch[m_iIndex] = 0 end

    if not bUpdatingAnimations then
        local weight = m_record.m_nAnimationLayers[6].m_weight * 1000
        if math.abs(weight) > 0 then
            PlayerList.iCountStaticSwitch[m_iIndex] = PlayerList.iCountStaticSwitch[m_iIndex] + 1
            if PlayerList.iCountStaticSwitch[m_iIndex] >= 2 then
                PlayerList.iStandingSide[m_iIndex] = PlayerList.iStandingSide[m_iIndex] * -1
                PlayerList.iCountStaticSwitch[m_iIndex] = 0
            end
        end
    end

    if bUpdatingAnimations then
        if flLowerBodyYawDiff > 1 then
            PlayerList.iStandingSide[m_iIndex] = -1
        elseif flLowerBodyYawDiff < -1 then
            PlayerList.iStandingSide[m_iIndex] = 1
        else
            PlayerList.iStandingSide[m_iIndex] = 0
        end
        PlayerList.iCountStaticSwitch[m_iIndex] = 0
    end]]
    

    --if not PlayerList.iSide[m_iIndex] then PlayerList.iSide[m_iIndex] = 0 end

    local m_iCurrentSide = Resolver.UpdatePlayerDesyncSideMove(m_player, m_record, m_oldrecord, m_olderrecord, flLowerBodyYawDiff, flServerVelocity2D < 20 and flLowerBodyYawDiff or flEyeFeetYawDiff)

    --if flPositiveAngleDiff > 2 and flPositivePreviousAngleDiff > 2 then
        --if flServerVelocity2D > 1 then
            --m_iCurrentSide = Resolver.UpdatePlayerDesyncSideMove(m_player, m_record, m_oldrecord, m_olderrecord)
        --else
        --    m_iCurrentSide = PlayerList.iStandingSide[m_iIndex] or 0
        --end
    --end

    flDesyncDelta = flDesyncDelta * m_iCurrentSide *-1

    ResRecord[m_iIndex] = flDesyncDelta


   
    
    -- client.log_screen(tostring(flDesyncDelta))

    PlayerList.flWalkToRunTransition[m_iIndex], PlayerList.bWalkToRunTransitionState[m_iIndex] = Resolver.CalculatePredictedWalkToRunTransition(
        (PlayerList.flWalkToRunTransition[m_iIndex] or 0), 
        (PlayerList.bWalkToRunTransitionState[m_iIndex] or false),
        math.TICK_INTERVAL(),
        m_nAnimationState.flVelocityLenght2D
    )
    

    return Resolver.CalculatePredictedFootYaw(
        m_nAnimationState.flGoalFeetYaw,
        m_nAnimationState.flEyeYaw + flDesyncDelta,
        m_record.flLowerBodyYawTarget,
        PlayerList.flWalkToRunTransition[m_iIndex],
        m_player:m_vecVelocity(),
        -flMaxAllowedDesyncDeltaAngle, flMaxAllowedDesyncDeltaAngle
    )
    --local pr = Resolver.UpdatePlayerDesyncSideMove(m_player, m_record, m_oldrecord, m_olderrecord)
end

Resolver.yawto180 = function(yawbruto)
    if yawbruto > 180 then
        return yawbruto - 360;
    end

    return yawbruto;
end

Resolver.Create = function()
    local get_players = entity.get_players(true)
    if not get_players then return end

    local m_local = Entity.Get(Entity.GetLocalPlayer())
    if not m_local or not m_local.m_hAddress then return end

    for _, m_cheat_player in pairs(get_players) do
        if not m_cheat_player then goto next_player end
        if entity.get_prop(m_cheat_player, "m_iHealth") < 1 then goto next_player end
        local m_iTeamNum = entity.get_prop(m_cheat_player, "m_iTeamNum")
        if m_iTeamNum ~= 2 and m_iTeamNum ~= 3 then goto next_player end
        -- if m_cheat_player:has_player_flag(e_player_flags.FAKE_CLIENT) then goto next_player end

        local m_iIndex = m_cheat_player

        local m_player = Entity.Get(m_iIndex)
        if not m_player or not m_player.m_hAddress then goto next_player end

        local m_nCurrentAnimationState = m_player:m_nAnimationState(m_cheat_player)
        local m_nAnimationState = Resolver.UpdateAnimationState(m_player, m_nCurrentAnimationState)
        local m_nAnimationLayers = Resolver.UpdateAnimationLayers(m_player)

        local flSimulationTime = m_player:m_flSimulationTime() --ffi.cast('float*', ffi.cast('uintptr_t', m_nEntity) + 0x268)[0]
        local flOldSimulationTime = m_player:m_flOldSimulationTime()--ffi.cast('float*', ffi.cast('uintptr_t', m_nEntity) + 0x268 + ffi.sizeof('float'))[0]

        local m_ChokedCommands = math.TIME_TO_TICKS(flSimulationTime - flOldSimulationTime)

        LagRecordHelpers.Init(m_iIndex, m_nAnimationLayers, m_nAnimationState, m_ChokedCommands, m_player:m_flLowerBodyYawTarget())

        local m_record = LagRecord[m_iIndex][1]
        local m_oldrecord = LagRecord[m_iIndex][2] or LagRecord[m_iIndex][1]
        local m_olderrecord = LagRecord[m_iIndex][3] or LagRecord[m_iIndex][2] or LagRecord[m_iIndex][1]
        --print(Resolver.Init(true, m_player, m_iIndex, m_local, m_nCurrentAnimationState, m_record, m_oldrecord, m_olderrecord))
        local m_flLastAngle, desync = Resolver.Init(true, m_player, m_iIndex, m_local, m_nCurrentAnimationState, m_record, m_oldrecord, m_olderrecord) or {m_nAnimationState.flEyeYaw , 0}

        --local desync = m_nAnimationState.flEyeYaw - Resolver.yawto180(m_flLastAngle)

        plist.set(m_iIndex, "Correction active", false)
        plist.set(m_iIndex, "Force body yaw", true)
        plist.set(m_iIndex, "Force body yaw value", -ResRecord[m_iIndex])

        ::next_player::
    end
end

-- @param: Primordial NET_UPDATE_START callback
client.set_event_callback("net_update_end", function()
    Resolver.Create()
end)

-- @param: Primordial SETUP_COMMAND callback
client.set_event_callback("setup_command", function(cmd)
    local tickcount = globals.tickcount()

    local get_players = entity.get_players(true)
    if not get_players then return end
    for _, enemy in pairs(get_players) do
        local index = enemy
        if not LogRecord[index] then LogRecord[index] = {} end
        LogRecord[index][tickcount] = ResRecord[index]
        if LogRecord[index][tickcount - 40] then LogRecord[index][tickcount - 40] = nil end
    end
end)

-- @param: Primordial AIMBOT_SHOOT callback
client.set_event_callback("aim_fire", function(ctx)
    if not ResRecord[ctx.target] then return end
    print(string.format("aim_fire: %s desync delta %0.2f backtrack: %i", entity.get_player_name(ctx.target), LogRecord[ctx.target][ctx.tick] or 0, globals.tickcount() - ctx.tick))
end)
