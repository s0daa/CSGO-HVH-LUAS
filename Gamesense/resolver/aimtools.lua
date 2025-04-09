-- aimtools
---@diagnostic disable: undefined-global
local ffi = require 'ffi'

local crr_t = ffi.typeof('void*(__thiscall*)(void*)')

local cr_t = ffi.typeof('void*(__thiscall*)(void*)')

local gm_t = ffi.typeof('const void*(__thiscall*)(void*)')

local gsa_t = ffi.typeof('int(__fastcall*)(void*, void*, int)')

ffi.cdef[[

    struct animation_layer_t

    {

	    char pad20[24];

	    uint32_t m_nSequence;

	    float m_flPrevCycle;

	    float m_flWeight;

	    float m_flWeightDeltaRate;

	    float m_flPlaybackRate;

	    float m_flCycle;

	    uintptr_t m_pOwner;

	    char pad_0038[ 4 ];

    };

    struct c_animstate { 

        char pad[ 3 ];

        char m_bForceWeaponUpdate; //0x4

        char pad1[ 91 ];

        void* m_pBaseEntity; //0x60

        void* m_pActiveWeapon; //0x64

        void* m_pLastActiveWeapon; //0x68

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

    };

]]



local classptr = ffi.typeof('void***')

local rawientitylist = client.create_interface('client_panorama.dll', 'VClientEntityList003') or error('VClientEntityList003 wasnt found', 2)



local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)

local get_client_networkable = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][0]) or error('get_client_networkable_t is nil', 2)

local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or error('get_client_entity is nil', 2)



local rawivmodelinfo = client.create_interface('engine.dll', 'VModelInfoClient004')

local ivmodelinfo = ffi.cast(classptr, rawivmodelinfo) or error('rawivmodelinfo is nil', 2)

local get_studio_model = ffi.cast('void*(__thiscall*)(void*, const void*)', ivmodelinfo[0][32])



local seq_activity_sig = client.find_signature('client_panorama.dll','\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83')



local function get_model(b)if b then b=ffi.cast(classptr,b)local c=ffi.cast(crr_t,b[0][0])local d=c(b)or error('error getting client unknown',2)if d then d=ffi.cast(classptr,d)local e=ffi.cast(cr_t,d[0][5])(d)or error('error getting client renderable',2)if e then e=ffi.cast(classptr,e)return ffi.cast(gm_t,e[0][8])(e)or error('error getting model_t',2)end end end end

local function get_sequence_activity(b,c,d)b=ffi.cast(classptr,b)local e=get_studio_model(ivmodelinfo,get_model(c))if e==nil then return-1 end;local f=ffi.cast(gsa_t, seq_activity_sig)return f(b,e,d)end

local function get_anim_layer(b,c)c=c or 1;b=ffi.cast(classptr,b)return ffi.cast('struct animation_layer_t**',ffi.cast('char*',b)+0x2990)[0][c]end



local Tools = {}



Tools.Clamp = function(n, mn, mx)

    if n > mx then

        return mx;

    elseif n < mn then

        return mn;

    else

        return n;

    end

end



Tools.YawTo360 = function(yawbruto)

    if yawbruto < 0 then

        return 360 + yawbruto;

    end



    return yawbruto;

end



Tools.YawTo180 = function(yawbruto)

    if yawbruto > 180 then

        return yawbruto - 360;

    end



    return yawbruto;

end



Tools.YawNormalizer = function(yawbruto)

    if yawbruto > 360 then

        return yawbruto - 360;

    elseif yawbruto < 0 then

        return 360 + yawbruto;

    end



    return yawbruto;

end



local MenuV = {};



MenuV["Anti-Aim Correction"] =  ui.reference("Rage", "Other", "Anti-Aim Correction");

MenuV["ResetAll"] =             ui.reference("Players", "Players", "Reset All");

MenuV["ForceBodyYaw"] =         ui.reference("Players", "Adjustments", "Force Body Yaw");

MenuV["CorrectionActive"] =     ui.reference("Players", "Adjustments", "Correction Active");



local MenuC = {};



MenuC["Enable"] =               ui.new_checkbox("Rage", "Other", "\affffff  aimtools\aCFCFCFCF  [experemintal]");



function Enable_Update()

    if ui.get(MenuC["Enable"]) then

        --ui.set_visible(MenuV["Anti-Aim Correction"], false);

        ui.set_visible(MenuV["ForceBodyYaw"], false);

        ui.set_visible(MenuV["CorrectionActive"], false);

        --ui.set(MenuV["Anti-Aim Correction"], false);

    else

        --ui.set_visible(MenuV["Anti-Aim Correction"], true);

        ui.set_visible(MenuV["ForceBodyYaw"], true);

        ui.set_visible(MenuV["CorrectionActive"], true);

        --ui.set(MenuV["Anti-Aim Correction"], true);

        ui.set(MenuV["ResetAll"], true);

    end

end

Enable_Update();



ui.set_callback(MenuC["Enable"], function()

    Enable_Update();

end)



local Animlayers =  {};

local AnimParts =   {};

local AnimList =    {"m_flPrevCycle", "m_flWeight", "m_flWeightDeltaRate", "m_flPlaybackRate", "m_flCycle"};

local SideCount =   {};

local Side =        {};

local Desync =      {};

local TempPitch =   {};



for i = 1, 64, 1 do

    SideCount[i] = 0;

    Side[i] = "Left";

    Desync[i] = 25;

    TempPitch[i] = 0;

end



function Resolver()

    if not ui.get(MenuC["Enable"]) then

        return;

    end



    --local Lp =          entity.get_local_player();



    local Players =     entity.get_players(true);



    for i, Player in pairs(Players) do

        local PlayerP = get_client_entity(ientitylist, Player);



        plist.set(Player, "Force Body Yaw", true);



        for u = 1, 13, 1 do

            Animlayers[u] = {};

            Animlayers[u]["Main"] =                 get_anim_layer(PlayerP, u);



            Animlayers[u]["m_flPrevCycle"] =        Animlayers[u]["Main"].m_flPrevCycle;

            Animlayers[u]["m_flWeight"] =           Animlayers[u]["Main"].m_flWeight;

            Animlayers[u]["m_flWeightDeltaRate"] =  Animlayers[u]["Main"].m_flWeightDeltaRate;

            Animlayers[u]["m_flPlaybackRate"] =     Animlayers[u]["Main"].m_flPlaybackRate;

            Animlayers[u]["m_flCycle"] =            Animlayers[u]["Main"].m_flCycle;



            AnimParts[u] = {};

            for y, val in pairs(AnimList) do

                AnimParts[u][val] = {};

                for i = 1, 13, 1 do

                    AnimParts[u][val][i] = math.floor(Animlayers[u][val]*(10^i)) - (math.floor(Animlayers[u][val]*(10^(i-1)))*10);

                end

            end

        end



        local RSideR = AnimParts[6]["m_flPlaybackRate"][4]+AnimParts[6]["m_flPlaybackRate"][5]+AnimParts[6]["m_flPlaybackRate"][6]+AnimParts[6]["m_flPlaybackRate"][7];

        local RSideS = AnimParts[6]["m_flPlaybackRate"][6]+AnimParts[6]["m_flPlaybackRate"][7]+AnimParts[6]["m_flPlaybackRate"][8]+AnimParts[6]["m_flPlaybackRate"][9];



        local Tmp;



        if AnimParts[6]["m_flPlaybackRate"][3] == 0 then --Desync detection

            Tmp = -3.4117*RSideS + 98.9393;

            if Tmp < 64 then

                Desync[Player] = Tmp;

            end

        else

            Tmp = -3.4117*RSideR + 98.9393;

            if Tmp < 64 then

                Desync[Player] = Tmp;

            end

        end



        local Temp45 = tonumber(AnimParts[6]["m_flWeight"][4]..AnimParts[6]["m_flWeight"][5]);



        if AnimParts[6]["m_flWeight"][2] == 0 then

            if (Animlayers[6]["m_flWeight"]*10^5 > 300) then

                SideCount[Player] = SideCount[Player] + 1;

            else

                SideCount[Player] = 0;

            end

        elseif AnimParts[6]["m_flWeight"][1] == 9 then

            if Temp45 == 29 then

                Side[Player] = "Left";

            elseif Temp45 == 30 then

                Side[Player] = "Right";

            elseif AnimParts[6]["m_flWeight"][2] == 9 then

                SideCount[Player] = SideCount[Player] + 2;

            else

                SideCount[Player] = 0;

            end

        end



        if SideCount[Player] >= 4 then

            if Side[Player] == "Left" then

                Side[Player] = "Right";

            else

                Side[Player] = "Left";

            end

            SideCount[Player] = 0;

        end



        Desync[Player] = Tools.Clamp(math.abs(math.floor(Desync[Player])), 0, 60);



        --------------------------------------------------------------------------------------



        local PlayerPitch = ({entity.get_prop(Player, "m_angEyeAngles")})[1];



        if PlayerPitch < 0 and TempPitch[Player] > 0 then-- Defensive Correction

            plist.set(Player, "Force Pitch", true);

            plist.set(Player, "Force Pitch Value", TempPitch[Player]);

        else

            plist.set(Player, "Force Pitch", false);

            TempPitch[Player] = PlayerPitch;

        end



        --------------------------------------------------------------------------------------



        if Side[Player] == "Right" then

            plist.set(Player, "force body yaw value", Desync[Player]);

        else

            plist.set(Player, "force body yaw value", -Desync[Player]);

        end

    end

end



local trashcan = {

    --if Animlayers["m_flPlaybackRate"][3] == 0 then

        --print(string.format("Anim67: %s | Anim89: %s | Diff: %s", Anim67, Anim89, math.abs(Anim67-Anim89)));

        --print(Anim6789);

        --if RSideS > 30 then

        --print(RSideS);

        --end

    --else

        --print(string.format("Anim45: %s | Anim67: %s | Diff: %s", Anim45, Anim67, math.abs(Anim45-Anim67)));

        --print(Anim4567);

        --print(RSideR);

    --end



    --print(string.format("Desync: %s | Side: %s", Desync[Player], Side[Player]));  



    --entity.get_prop(Player, "m_fFlags");

    --entity.get_prop(Player, "m_bSpotted");

    --entity.get_prop(Player, "m_flSimulationTime"); 



    --local EnemyOrigin =     {entity.get_origin(Player)};

    --local EnemyHeadPos =    {entity.hitbox_position(Player, 1)};



    --local LpToCenter =      ({client.trace_line(-1, LpEyeAngle[1], LpEyeAngle[2], LpEyeAngle[3], EnemyOrigin[1], EnemyOrigin[2], EnemyOrigin[3]+56)})[1];

    --local LpToHead =       ({client.trace_line(-1, LpEyeAngle[1], LpEyeAngle[2], LpEyeAngle[3], EnemyHeadPos[1], EnemyHeadPos[2], EnemyHeadPos[3])})[1];



    --local Angulo =  math.cos(LpToEnemy/LpToHead)*(10^2); --50

    --local Angulo1 = Angulo*(10^2) - (math.floor(Angulo)*10^2);

    --local RDesync = Angulo*10 - (math.floor(Angulo/(10^1))*10^2);



    --print(string.format("Center Pos: %s | Head Pos: %s | Difference: %s", LpToCenter, LpToHead, LpToCenter-LpToHead));



    --if LpToCenter > LpToHead then

    --    ResolverWorking[Player] = true;



    --    if LpToCenter-LpToHead >= 0.014 then

    --        Side[Player] = "Left";

    --    else

    --        Side[Player] = "Right"

    --    end



    --    Desync[Player] = 60;

    --else

    --    ResolverWorking[Player] = false;

    --end

};



client.set_event_callback("net_update_end", Resolver);







client.set_event_callback('shutdown', function()

    --ui.set_visible(MenuV["Anti-Aim Correction"], true);

    ui.set_visible(MenuV["ForceBodyYaw"], true);

    ui.set_visible(MenuV["CorrectionActive"], true);

    --ui.set(MenuV["Anti-Aim Correction"], true);

    ui.set(MenuV["ResetAll"], true);

end)