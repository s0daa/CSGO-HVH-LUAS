---@diagnostic disable: undefined-global
print("made with love")
local ffi = require 'ffi'
local crr_t = ffi.typeof('void*(__thiscall*)(void*)')
local cr_t = ffi.typeof('void*(__thiscall*)(void*)')
local gm_t = ffi.typeof('const void*(__thiscall*)(void*)')
local gsa_t = ffi.typeof('int(__fastcall*)(void*, void*, int)')

ffi.cdef[[
    struct animation_layer_t {
        char pad20[24];
        uint32_t m_nSequence;
        float m_flPrevCycle;
        float m_flWeight;
        float m_flWeightDeltaRate;
        float m_flPlaybackRate;
        float m_flCycle;
        uintptr_t m_pOwner;
        char pad_0038[4];
    };
    struct c_animstate {
        char pad[3];
        char m_bForceWeaponUpdate;
        char pad1[91];
        void* m_pBaseEntity;
        void* m_pActiveWeapon;
        void* m_pLastActiveWeapon;
        float m_flLastClientSideAnimationUpdateTime;
        int m_iLastClientSideAnimationUpdateFramecount;
        float m_flAnimUpdateDelta;
        float m_flEyeYaw;
        float m_flPitch;
        float m_flGoalFeetYaw;
        float m_flCurrentFeetYaw;
        float m_flCurrentTorsoYaw;
        float m_flUnknownVelocityLean;
        float m_flLeanAmount;
        char pad2[4];
        float m_flFeetCycle;
        float m_flFeetYawRate;
        char pad3[4];
        float m_fDuckAmount;
        float m_fLandingDuckAdditiveSomething;
        char pad4[4];
        float m_vOriginX;
        float m_vOriginY;
        float m_vOriginZ;
        float m_vLastOriginX;
        float m_vLastOriginY;
        float m_vLastOriginZ;
        float m_vVelocityX;
        float m_vVelocityY;
        char pad5[4];
        float m_flUnknownFloat1;
        char pad6[8];
        float m_flUnknownFloat2;
        float m_flUnknownFloat3;
        float m_flUnknown;
        float m_flSpeed2D;
        float m_flUpVelocity;
        float m_flSpeedNormalized;
        float m_flFeetSpeedForwardsOrSideWays;
        float m_flFeetSpeedUnknownForwardOrSideways;
        float m_flTimeSinceStartedMoving;
        float m_flTimeSinceStoppedMoving;
        bool m_bOnGround;
        bool m_bInHitGroundAnimation;
        float m_flTimeSinceInAir;
        float m_flLastOriginZ;
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation;
        float m_flStopToFullRunningFraction;
        char pad7[4];
        float m_flMagicFraction;
        char pad8[60];
        float m_flWorldForce;
        char pad9[462];
        float m_flMaxYaw;
    };
]]

local classptr = ffi.typeof('void***')
local rawientitylist = client.create_interface('client_panorama.dll', 'VClientEntityList003') or error('VClientEntityList003 was not found', 2)
local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)

local get_client_networkable = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][0]) or error('get_client_networkable_t is nil', 2)
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or error('get_client_entity is nil', 2)

local rawivmodelinfo = client.create_interface('engine.dll', 'VModelInfoClient004')
local ivmodelinfo = ffi.cast(classptr, rawivmodelinfo) or error('rawivmodelinfo is nil', 2)
local get_studio_model = ffi.cast('void*(__thiscall*)(void*, const void*)', ivmodelinfo[0][32])

local seq_activity_sig = client.find_signature('client_panorama.dll', '\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83')

local function get_model(entity)
    if entity then
        entity = ffi.cast(classptr, entity)
        local unknown = ffi.cast(crr_t, entity[0][0])(entity) or error('error getting client unknown', 2)
        if unknown then
            local renderable = ffi.cast(cr_t, ffi.cast(classptr, unknown)[0][5])(unknown) or error('error getting client renderable', 2)
            if renderable then
                return ffi.cast(gm_t, ffi.cast(classptr, renderable)[0][8])(renderable) or error('error getting model_t', 2)
            end
        end
    end
end

local function get_sequence_activity(entity, model, sequence)
    entity = ffi.cast(classptr, entity)
    local studio_model = get_studio_model(ivmodelinfo, get_model(model))
    if not studio_model then return -1 end
    local get_activity = ffi.cast(gsa_t, seq_activity_sig)
    return get_activity(entity, studio_model, sequence)
end

local function get_anim_layer(entity, layer)
    layer = layer or 1
    entity = ffi.cast(classptr, entity)
    return ffi.cast('struct animation_layer_t**', ffi.cast('char*', entity) + 0x2990)[0][layer]
end

local Tools = {}

Tools.Clamp = function(n, mn, mx)
    return math.max(mn, math.min(n, mx))
end

Tools.YawTo360 = function(yaw)
    return yaw < 0 and 360 + yaw or yaw
end

Tools.YawTo180 = function(yaw)
    return yaw > 180 and yaw - 360 or yaw
end

Tools.YawNormalizer = function(yaw)
    return yaw > 360 and yaw - 360 or (yaw < 0 and 360 + yaw or yaw)
end

local MenuV = {
    ["Anti-Aim Correction"] = ui.reference("Rage", "Other", "Anti-Aim Correction"),
    ["ResetAll"] = ui.reference("Players", "Players", "Reset All"),
    ["ForceBodyYaw"] = ui.reference("Players", "Adjustments", "Force Body Yaw"),
    ["CorrectionActive"] = ui.reference("Players", "Adjustments", "Correction Active"),
}

local MenuC = {
    ["Enable"] = ui.new_checkbox("Rage", "Other", "\affffff  Free Snxxz Resolves\aCFCFCFCF"),
}

local function Enable_Update()
    if ui.get(MenuC["Enable"]) then
        ui.set_visible(MenuV["ForceBodyYaw"], false)
        ui.set_visible(MenuV["CorrectionActive"], false)
    else
        ui.set_visible(MenuV["ForceBodyYaw"], true)
        ui.set_visible(MenuV["CorrectionActive"], true)
        ui.set(MenuV["ResetAll"], true)
    end
end
Enable_Update()

ui.set_callback(MenuC["Enable"], Enable_Update)

ui.set_callback(MenuC["Enable"], function()
    Enable_Update()
end)

local Animlayers = {}
local AnimParts = {}
local AnimList = {"m_flPrevCycle", "m_flWeight", "m_flWeightDeltaRate", "m_flPlaybackRate", "m_flCycle"}
local SideCount = {}
local Side = {}
local Desync = {}
local TempPitch = {}

for i = 1, 64, 1 do
    SideCount[i] = 0
    Side[i] = "Left"
    Desync[i] = 25
    TempPitch[i] = 0
end

function Resolver()
    if not ui.get(MenuC["Enable"]) then
        return
    end

    local Players = entity.get_players(true)

    for i, Player in pairs(Players) do
        local PlayerP = get_client_entity(ientitylist, Player)

        plist.set(Player, "Force Body Yaw", true)

        for u = 1, 13, 1 do
            Animlayers[u] = {}
            Animlayers[u]["Main"] = get_anim_layer(PlayerP, u)

            Animlayers[u]["m_flPrevCycle"] = Animlayers[u]["Main"].m_flPrevCycle
            Animlayers[u]["m_flWeight"] = Animlayers[u]["Main"].m_flWeight
            Animlayers[u]["m_flWeightDeltaRate"] = Animlayers[u]["Main"].m_flWeightDeltaRate
            Animlayers[u]["m_flPlaybackRate"] = Animlayers[u]["Main"].m_flPlaybackRate
            Animlayers[u]["m_flCycle"] = Animlayers[u]["Main"].m_flCycle

            AnimParts[u] = {}
            for y, val in pairs(AnimList) do
                AnimParts[u][val] = {}
                for i = 1, 13, 1 do
                    AnimParts[u][val][i] = math.floor(Animlayers[u][val] * (10^i)) - (math.floor(Animlayers[u][val] * (10^(i-1))) * 10)
                end
            end
        end

        local RSideR = AnimParts[6]["m_flPlaybackRate"][4] + AnimParts[6]["m_flPlaybackRate"][5] + AnimParts[6]["m_flPlaybackRate"][6] + AnimParts[6]["m_flPlaybackRate"][7]
        local RSideS = AnimParts[6]["m_flPlaybackRate"][6] + AnimParts[6]["m_flPlaybackRate"][7] + AnimParts[6]["m_flPlaybackRate"][8] + AnimParts[6]["m_flPlaybackRate"][9]

        local Tmp

        if AnimParts[6]["m_flPlaybackRate"][3] == 0 then -- Desync detection
            Tmp = -3.4117 * RSideS + 98.9393
            if Tmp < 64 then
                Desync[Player] = Tmp
            end
        else
            Tmp = -3.4117 * RSideR + 98.9393
            if Tmp < 64 then
                Desync[Player] = Tmp
            end
        end

        local Temp45 = tonumber(AnimParts[6]["m_flWeight"][4] .. AnimParts[6]["m_flWeight"][5])

        if AnimParts[6]["m_flWeight"][2] == 0 then
            if (Animlayers[6]["m_flWeight"] * 10^5 > 300) then
                SideCount[Player] = SideCount[Player] + 1
            else
                SideCount[Player] = 0
            end
        elseif AnimParts[6]["m_flWeight"][1] == 9 then
            if Temp45 == 29 then
                Side[Player] = "Left"
            elseif Temp45 == 30 then
                Side[Player] = "Right"
            elseif AnimParts[6]["m_flWeight"][2] == 9 then
                SideCount[Player] = SideCount[Player] + 2
            else
                SideCount[Player] = 0
            end
        end

        if SideCount[Player] >= 4 then
            Side[Player] = (Side[Player] == "Left" and "Right" or "Left")
            SideCount[Player] = 0
        end

        Desync[Player] = Tools.Clamp(math.abs(math.floor(Desync[Player])), 0, 60)

        --------------------------------------------------------------------------------------

        local PlayerPitch = ({entity.get_prop(Player, "m_angEyeAngles")})[1]

        if PlayerPitch < 0 and TempPitch[Player] > 0 then -- Defensive Correction
            plist.set(Player, "Force Pitch", true)
            plist.set(Player, "Force Pitch Value", TempPitch[Player])
        else
            plist.set(Player, "Force Pitch", false)
            TempPitch[Player] = PlayerPitch
        end

        --------------------------------------------------------------------------------------

        plist.set(Player, "force body yaw value", Side[Player] == "Right" and Desync[Player] or -Desync[Player])
    end
end

local trashcan = {
    -- Debugging lines (commented out)
}

client.set_event_callback("net_update_end", Resolver)

client.set_event_callback('shutdown', function()
    ui.set_visible(MenuV["ForceBodyYaw"], true)
    ui.set_visible(MenuV["CorrectionActive"], true)
    ui.set(MenuV["ResetAll"], true)
end)
