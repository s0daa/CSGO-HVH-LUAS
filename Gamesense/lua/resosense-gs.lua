-- downloaded from dsc.gg/southwestcfgs

local ffi = require 'ffi'

local tab, container = "Rage", "Other"

local current = {
    check_access = true,
}

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
local get_studio_model = ffi.cast('void*(__thiscall*)(void*, const void*)', ivmodelinfo[0][32])


local misc = {
    enable = ui.new_checkbox(tab, container, "Reso\a9FCA2BFFSense"),
    type = ui.new_combobox(tab, container, "Type", {"Default", "Jitter", "Alternative", "Custom"}),
    delta = ui.new_slider(tab, container, 'Delta', 1, 10, 3, true, "°")
}

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
    local animstate = GetAnimationState(player)
    local lpent = get_client_entity(ientitylist, player)

    local delta = entity.get_prop(player, "m_angEyeAngles[1]") - entity.get_prop(player, "m_flPoseParameter", 11)

    eye_yaw = animstate.m_flEyeYaw

    ent_name = entity.get_player_name(player)

    local yaws

    local yaw1 = (entity.get_prop(player, "m_flPoseParameter", 11) or 1) * 116 - 58


    side = globals.tickcount() % 2 == 0 and -1 or 1
    side2 = (globals.tickcount() % 3) - 1

    if ui.get(misc.type) == "Default" then
        yaws = delta * yaw1 * animstate.m_flPlaybackRate
    elseif ui.get(misc.type) == "Jitter" then
        yaws = side * math.abs(delta * yaw1 * animstate.m_flPlaybackRate)
    elseif ui.get(misc.type) == "Alternative" then
        yaws = side2 * math.abs(delta * yaw1 * animstate.m_flPlaybackRate)
    else
        yaws = (delta * yaw1 * animstate.m_flPlaybackRate)/ui.get(misc.delta)
    end

    yaws = NormalizeAngle(yaws)

    plist.set(player, "Force body yaw", true)
    plist.set(player, "Force body yaw value", yaws) 
end

local function Resolver(player)
    if ui.get(misc.enable) then
        if entity.is_dormant(player) or entity.get_prop(player, "m_bDormant") then
            return
        end
        ResolveJitter(player)
    else
        plist.set(player, "Force body yaw", false)
    end
end

local function ResolverUpdate()
    if current.check_access == false then return end
    local enemies = entity.get_players(true)
    for i, enemy_ent in ipairs(enemies) do
        if enemy_ent and entity.is_alive(enemy_ent) then
            Resolver(enemy_ent)
        end
    end
end

local x_ind, y_ind = client.screen_size()
local function paint_indicator()
    if current.check_access == false then return end
    if not ui.get(misc.enable) then return end
    if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
    renderer.text(20, y_ind/1.9, 255, 255, 255, 255, "", 0, "> reso\a9FCA2BFFsense \aEE4444FF[alpha]")
    renderer.text(20, y_ind/1.9+12, 255, 255, 255, 255, "", 0, "> resolver type: \aEE4444FF"..ui.get(misc.type))
    renderer.text(20, y_ind/1.9+24, 255, 255, 255, 255, "", 0, "> Enemy: \aEE4444FF"..ent_name)
    renderer.text(20, y_ind/1.9+36, 255, 255, 255, 255, "", 0, "> Eye: \aEE4444FF"..math.floor(eye_yaw))
end



local function visibility()
    ui.set_visible(misc.enable, current.check_access)
    ui.set_visible(misc.type, ui.get(misc.enable) and current.check_access)
    ui.set_visible(misc.delta, ui.get(misc.type) == "Custom" and ui.get(misc.enable) and current.check_access)
end

client.set_event_callback("paint_ui", visibility)
client.set_event_callback("paint", paint_indicator)
client.set_event_callback("setup_command", ResolverUpdate)