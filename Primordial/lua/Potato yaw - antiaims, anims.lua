local conditions_names = { "Slow Walk", "Air", "Duck", "Stand", "Move" }

local references = {
    lua = {
        active_tab = menu.add_list( "Potato yaw", "[AA] Condition", conditions_names ),
        inAir = menu.add_checkbox( "Potato yaw", "[ANIM] Freeze legs in air" ),
        onGround = menu.add_checkbox( "Potato yaw", "[ANIM] Break legs on ground" ),
        onLand = menu.add_checkbox( "Potato yaw", "[ANIM] Pitch zero on land" ),
        lean = menu.add_checkbox( "Potato yaw", "[ANIM] Lean model" ),
    },
    menu = {
        antiaim_list = {
            menu.find("antiaim", "main", "desync", "side"),
            menu.find("antiaim", "main", "desync", "left amount"),
            menu.find("antiaim", "main", "desync", "right amount"),
            menu.find("antiaim", "main", "angles", "yaw add"),
            menu.find("antiaim", "main", "angles", "rotate"),
            menu.find("antiaim", "main", "angles", "rotate range"),
            menu.find("antiaim", "main", "angles", "rotate speed"),
            menu.find("antiaim", "main", "angles", "jitter mode"),
            menu.find("antiaim", "main", "angles", "jitter add"),
            menu.find("antiaim", "main", "angles", "body lean"),
            menu.find("antiaim", "main", "angles", "body lean value"),
            menu.find("antiaim", "main", "angles", "body lean jitter"),
        },
        slowwalk = menu.find("misc", "main", "movement", "slow walk"),
    },
}

local condition_elements = { }
local invisible_elements = { }
for i = 1, #conditions_names do
    condition_elements[ i ] = {
        menu.add_text( "[COND] - " .. conditions_names[ i ], "---desync---" ),
        menu.add_selection( "[COND] - " .. conditions_names[ i ], "side",  {"none", "left", "right", "jitter", "peek fake", "peek real", "body sway" } ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "left amount", 0, 100 ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "right amount", 0, 100 ),
        menu.add_selection( "[COND] - " .. conditions_names[ i ], "body lean", { "none", "static", "static Jitter", "random Jitter", "sway" } ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "body lean value", -50, 50 ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "body lean jitter", 0, 100 ),
        menu.add_text( "[COND] - " .. conditions_names[ i ], "---real---" ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "yaw add left", -180, 180 ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "yaw add right", -180, 180 ),
        menu.add_checkbox( "[COND] - " .. conditions_names[ i ], "rotate", false ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "rotate range", 0, 360 ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "rotate speed", 0, 100 ),
        menu.add_selection( "[COND] - " .. conditions_names[ i ], "jitter mode", { "none", "static", "random" } ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "jitter add", -180, 180 ),
    }

    invisible_elements[ i ] = menu.add_text( "invis" .. i, "lol bebra" ) --prevents from voids in menu
    invisible_elements[ i ]:set_visible( false )
end

local function get_condition_index( old_cmd )
    if references.menu.slowwalk[2]:get( ) then
        return 1
    end

    local localplayer = entity_list:get_local_player()

    if localplayer:has_player_flag( e_player_flags.ON_GROUND ) == false or old_cmd:has_player_flag( e_player_flags.ON_GROUND ) == false then
        return 2
    end

    if localplayer:has_player_flag( e_player_flags.DUCKING ) then
        return 3
    end

    local velocity = math.sqrt( math.pow( localplayer:get_prop( "m_vecVelocity[0]" ), 2 ) + math.pow( localplayer:get_prop( "m_vecVelocity[1]" ), 2 ) )
    
    if velocity <= 5 then
        return 4
    else
        return 5
    end
end

local function solve_preset( condition_index )
    local preset = condition_elements[ condition_index ]
    local is_right = antiaim.get_real_angle() - antiaim.get_fake_angle() > 0
    local yaw_add = preset[ is_right and 9 or 10 ]:get( )
    local body_lean_value = preset[ 5 ]:get( ) == 2 and preset[ 6 ]:get( ) or 0
    local body_lean_jitter = ( preset[ 5 ]:get( ) == 3 or preset[ 5 ]:get( ) == 4 ) and preset[ 7 ]:get( ) or 0

    local result = {
        preset[ 2 ]:get( ),
        preset[ 3 ]:get( ),
        preset[ 4 ]:get( ),
        yaw_add,
        preset[ 11 ]:get( ),
        preset[ 12 ]:get( ),
        preset[ 13 ]:get( ),
        preset[ 14 ]:get( ),
        preset[ 15 ]:get( ),
        preset[ 5 ]:get( ),
        body_lean_value,
        body_lean_jitter
    }

    return result
end

ffi.cdef[[
    typedef struct 
	{
		float x;
		float y;
		float z;
    } Vector_t;

    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);

    typedef struct
    {
        char	pad0[0x60]; // 0x00
        void* pEntity; // 0x60
        void* pActiveWeapon; // 0x64
        void* pLastActiveWeapon; // 0x68
        float		flLastUpdateTime; // 0x6C
        int			iLastUpdateFrame; // 0x70
        float		flLastUpdateIncrement; // 0x74
        float		flEyeYaw; // 0x78
        float		flEyePitch; // 0x7C
        float		flGoalFeetYaw; // 0x80
        float		flLastFeetYaw; // 0x84
        float		flMoveYaw; // 0x88
        float		flLastMoveYaw; // 0x8C // changes when moving/jumping/hitting ground
        float		flLeanAmount; // 0x90
        char	pad1[0x4]; // 0x94
        float		flFeetCycle; // 0x98 0 to 1
        float		flMoveWeight; // 0x9C 0 to 1
        float		flMoveWeightSmoothed; // 0xA0
        float		flDuckAmount; // 0xA4
        float		flHitGroundCycle; // 0xA8
        float		flRecrouchWeight; // 0xAC
        Vector_t		vecOrigin; // 0xB0
        Vector_t		vecLastOrigin;// 0xBC
        Vector_t		vecVelocity; // 0xC8
        Vector_t		vecVelocityNormalized; // 0xD4
        Vector_t		vecVelocityNormalizedNonZero; // 0xE0
        float		flVelocityLenght2D; // 0xEC
        float		flJumpFallVelocity; // 0xF0
        float		flSpeedNormalized; // 0xF4 // clamped velocity from 0 to 1 
        float		flRunningSpeed; // 0xF8
        float		flDuckingSpeed; // 0xFC
        float		flDurationMoving; // 0x100
        float		flDurationStill; // 0x104
        bool		bOnGround; // 0x108
        bool		bHitGroundAnimation; // 0x109
        char	pad2[0x2]; // 0x10A
        float		flNextLowerBodyYawUpdateTime; // 0x10C
        float		flDurationInAir; // 0x110
        float		flLeftGroundHeight; // 0x114
        float		flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
        float		flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
        char	pad3[0x4]; // 0x120
        float		flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
        char	pad4[0x208]; // 0x128
        float		flMinBodyYaw; // 0x330
        float		flMaxBodyYaw; // 0x334
        float		flMinPitch; //0x338
        float		flMaxPitch; // 0x33C
        int			iAnimsetVersion; // 0x340
    } CCSGOPlayerAnimationState_534535_t;
]]

local entityList = ffi.cast( "void***", memory.create_interface( "client.dll", "VClientEntityList003" ) )
local getEntityFN = ffi.cast( "GetClientEntity_4242425_t", entityList[ 0 ][ 3 ] ) 
local function getEntityAddress( idx ) return getEntityFN( entityList, idx ) end
local function getAnimstate( pPlayer ) return ffi.cast( "CCSGOPlayerAnimationState_534535_t**", ffi.cast( "uintptr_t", pPlayer ) + 0x9960 )[ 0 ] end

local on_ground = false
local function leg_breaker( antiaim_context_t, user_cmd_t, unpredicted_data_t )
    local localPlayer = entity_list.get_local_player( )

    if not localPlayer then
        return
    end

    if references.lua.lean:get( ) then
        antiaim_context_t:set_render_animlayer(e_animlayers.LEAN, 0.75, 1)
    end

    if references.lua.inAir:get( ) then
        antiaim_context_t:set_render_pose( e_poses.JUMP_FALL, 1 )
    end

    if references.lua.onGround:get( ) then
        antiaim_context_t:set_render_pose( e_poses.STRAFE_DIR, 180 )
    end

    if references.lua.onLand:get( ) == false then
        return
    end

    local lpPtr = getEntityAddress( localPlayer:get_index( ) )

    if not lpPtr or lpPtr == 0x0 then
        return
    end

    local is_on_ground = localPlayer:has_player_flag( e_player_flags.ON_GROUND )
    local on_ground = unpredicted_data_t:has_player_flag( e_player_flags.ON_GROUND ) and is_on_ground

    if on_ground and getAnimstate( lpPtr ).bHitGroundAnimation then
        antiaim_context_t:set_render_pose( e_poses.BODY_PITCH, 0.5 )
    end
end

local function on_antiaim( antiaim_context_t, user_cmd_t, unpredicted_data_t )
    local condition_index = get_condition_index( unpredicted_data_t )
    local preset = solve_preset( condition_index )

    for i = 1, #references.menu.antiaim_list do
        references.menu.antiaim_list[ i ]:set( preset[ i ] )
    end

    leg_breaker( antiaim_context_t, user_cmd_t, unpredicted_data_t )
end

local function on_paint( )
    if menu.is_open() == false then --lol
        return
    end

    for i = 1, #conditions_names do
        local main_arg = references.lua.active_tab:get( ) == i

        for n = 1, 15 do
            condition_elements[ i ][ n ]:set_visible( main_arg )
        end

        condition_elements[ i ][ 6 ]:set_visible( main_arg and condition_elements[ i ][ 5 ]:get( ) == 2 )
        condition_elements[ i ][ 7 ]:set_visible( main_arg and ( condition_elements[ i ][ 5 ]:get( ) == 3 or condition_elements[ i ][ 5 ]:get( ) == 4 ) )
        condition_elements[ i ][ 12 ]:set_visible( main_arg and condition_elements[ i ][ 11 ]:get( ) )
        condition_elements[ i ][ 13 ]:set_visible( main_arg and condition_elements[ i ][ 11 ]:get( ) )
        condition_elements[ i ][ 15 ]:set_visible( main_arg and condition_elements[ i ][ 14 ]:get( ) > 0 )
    end
end

callbacks.add( e_callbacks.ANTIAIM, on_antiaim)
callbacks.add( e_callbacks.PAINT, on_paint )