local conditions_names = { "slow walk", "air", "duck", "stand", "move" }

extra_tab = menu.add_text( "godly.lua", "UID: " .. user.uid )
extra_tab = menu.add_text( "godly.lua", "Version 1.1" )

local references = {
    lua = {
        extra_tab = menu.add_checkbox( "Misc", "Roll Resolver (real)" ),
        active_tab = menu.add_list( "antiaim", "[AA] Condition", conditions_names ),
        inAir = menu.add_checkbox( "antiaim", "static legs in air" ),
        onGround = menu.add_checkbox( "antiaim", "leg movement on land" ),
        onLand = menu.add_checkbox( "antiaim", "0 pitch on land" ),
        lean = menu.add_checkbox( "antiaim", "lean spam" ),
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
        menu.add_text( "[AA Type] - " .. conditions_names[ i ], "-desync-" ),
        menu.add_selection( "[AA Type] - " .. conditions_names[ i ], "side",  {"none", "left", "right", "jitter", "peek fake", "peek real", "body sway" } ),
        menu.add_slider( "[AA Type] - " .. conditions_names[ i ], "left amount", 0, 100 ),
        menu.add_slider( "[AA Type] - " .. conditions_names[ i ], "right amount", 0, 100 ),
        menu.add_selection( "[AA Type] - " .. conditions_names[ i ], "body lean", { "none", "static", "static Jitter", "random Jitter", "sway" } ),
        menu.add_slider( "[AA Type] - " .. conditions_names[ i ], "body lean value", -50, 50 ),
        menu.add_slider( "[AA Type] - " .. conditions_names[ i ], "body lean jitter", 0, 100 ),
        menu.add_text( "[AA Type] - " .. conditions_names[ i ], "-real-" ),
        menu.add_slider( "[AA Type] - " .. conditions_names[ i ], "yaw add left", -180, 180 ),
        menu.add_slider( "[AA Type] - " .. conditions_names[ i ], "yaw add right", -180, 180 ),
        menu.add_checkbox( "[AA Type] - " .. conditions_names[ i ], "rotate", false ),
        menu.add_slider( "[AA Type] - " .. conditions_names[ i ], "rotate range", 0, 360 ),
        menu.add_slider( "[AA Type] - " .. conditions_names[ i ], "rotate speed", 0, 100 ),
        menu.add_selection( "[AA Type] - " .. conditions_names[ i ], "jitter mode", { "none", "static", "random" } ),
        menu.add_slider( "[AA Type] - " .. conditions_names[ i ], "jitter add", -180, 180 ),
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

local function on_draw_watermark()
    local fps = client.get_fps()
    local tickrate = client.get_tickrate()
    return "godly.lua | beta | "..user.name.." | "..fps.." fps | "..tickrate.." tick"
end

callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)

local pixel = render.create_font("Smallest Pixel-7", 10, 20, e_font_flags.OUTLINE)

--binds
local isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable") -- get doubletap
local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") -- get hideshots
local isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable") -- get autopeek
local isSW = menu.find("misc","main","movement","slow walk", "enable") -- get Slow Walk
local isMD = menu.find("aimbot", "scout", "target overrides", "force min. damage") -- get damage override
local isBA = menu.find("aimbot", "scout", "target overrides", "force hitbox") -- get froce baim
local isSP = menu.find("aimbot", "scout", "target overrides", "force safepoint") -- get safe point
local isAA = menu.find("antiaim", "main", "angles", "yaw base") -- get yaw base

--indicators
local fake = antiaim.get_fake_angle()
local currentTime = global_vars.cur_time
local function indicators2()
    if not engine.is_connected() then
        return
    end

    if not engine.is_in_game() then
        return
    end

    local local_player = entity_list.get_local_player()

    if not local_player:get_prop("m_iHealth") then
        return
    end
    --screen size
    local x = render.get_screen_size().x
    local y = render.get_screen_size().y

    --invert state
    if antiaim.is_inverting_desync() == false then
        invert ="R"
    else
        invert ="L"
    end

    --screen size
    local ay = 40
    local alpha = math.min(math.floor(math.sin((global_vars.real_time()%3) * 4) * 175 + 50), 255)
    if local_player:is_alive() then -- check if player is alive
    --render
    local eternal_ts = render.get_text_size(pixel, "ACATEL ")
    render.text(pixel, "godly.lua", vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
    render.text(pixel, "beta", vec2_t(x/1.975+eternal_ts.x-2, y/1.999+ay), color_t(255, 130, 130, alpha), 10, true)
    ay = ay + 10.5
    
    local text_ =""
    local clr0 = color_t(0, 0, 0, 0)
    if isSW[2]:get() then
        text_ ="DANGEROUS+ "
        clr0 = color_t(255, 50, 50, 255)
    else
        text_ ="DYNAMIC- "
        clr0 = color_t(255, 117, 107, 255)
    end

    local d_ts = render.get_text_size(pixel, text_)
    render.text(pixel, text_, vec2_t(x/2, y/2+ay), clr0, 10, true)
    render.text(pixel, math.floor(fake).."", vec2_t(x/2+d_ts.x, y/2+ay), color_t(255, 255, 255, 255), 10, true)
    ay = ay + 10.5
    
    local fake_ts = render.get_text_size(pixel, "FAKE YAW: ")
    render.text(pixel, "godly.yaw:", vec2_t(x/2, y/2+ay), color_t(130, 130, 255, 255), 10, true)
    render.text(pixel, invert, vec2_t(x/2+fake_ts.x, y/2+ay), color_t(255, 255, 255, 255), 10, true)
    ay = ay + 10.5

    local asadsa = math.min(math.floor(math.sin((exploits.get_charge()%2) * 1) * 122), 100)
    if isAP[2]:get() and isDT[2]:get() then 
        local ts_tick = render.get_text_size(pixel, "IDEALTICK ")
        render.text(pixel, "IDEALTICK", vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
        render.text(pixel, "x"..asadsa, vec2_t(x/2+ts_tick.x, y/2+ay), exploits.get_charge() == 1 and color_t(0, 255, 0, 255) or color_t(255, 0, 0, 255), 10, true)
        ay = ay + 10.5
    else
        if isAP[2]:get() then
            render.text(pixel, "PEEK", vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
        if isDT[2]:get() then
        if exploits.get_charge() >= 1 then
            render.text(pixel, "DT", vec2_t(x/2, y/2+ay), color_t(0, 255, 0, 255), 10, true)
            ay = ay + 10.5
        end
        if exploits.get_charge() < 1 then
            render.text(pixel, "DT", vec2_t(x/2, y/2+ay), color_t(255, 0, 0, 255), 10, true)
            ay = ay + 10.5
        end
    end
    end

    if isMD[2]:get() then
        render.text(pixel, "MD: "..tostring(isMD[2]:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
        ay = ay + 10.5
    end

    local ax = 0
    if isHS[2]:get() then
        render.text(pixel, "ONSHOT", vec2_t(x/2, y/2+ay), color_t(250, 173, 181, 255), 10, true)
        ay = ay + 10.5
    end

    render.text(pixel, "BAIM", vec2_t(x/2, y/2+ay), isBA[2]:get() == 2 and color_t(255, 255, 255, 255) or color_t(255, 255, 255, 128), 10, true)
    ax = ax + render.get_text_size(pixel, "BAIM ").x

    render.text(pixel, "FS", vec2_t(x/2+ax, y/2+ay), isAA:get() == 5 and color_t(255, 255, 255, 255) or color_t(255, 255, 255, 128), 10, true)
end
end

--callback
callbacks.add(e_callbacks.PAINT,indicators2)
local ffi_handler = {}
local tag_changer = {}
local ui = {}


tag_changer.custom_tag = {
    "⏳	",
    "⏳	g",
    "⏳	go",
    "⏳	god",
    "⏳	godl",
    "⏳	godly",
    "⏳	godly.",
    "⏳	godly.l",
    "⏳	godly.lu",
    "⏳	godly.lua",
    "⏳	godly.lu",
    "⏳	godly.l",
    "⏳	godly.",
    "⏳	godly",
    "⏳	godl",
    "⏳	god",
    "⏳	go",
    "⏳	g",
    "⏳  ",
}



local string_mul = function(text, mul)

    mul = math.floor(mul)

    local to_add = text

    for i = 1, mul-1 do
        text = text .. to_add
    end

    return text
end

ffi_handler.sigs = {}
ffi_handler.sigs.clantag = {"engine.dll", "53 56 57 8B DA 8B F9 FF 15"}
ffi_handler.change_tag_fn = ffi.cast("int(__fastcall*)(const char*, const char*)", memory.find_pattern(unpack(ffi_handler.sigs.clantag)))

tag_changer.last_time_update = -1
tag_changer.update = function(tag)
    local current_tick = global_vars.tick_count()

    if current_tick > tag_changer.last_time_update then
        tag = tostring(tag)
        ffi_handler.change_tag_fn(tag, tag)
        tag_changer.last_time_update = current_tick + 16
    end
end

tag_changer.build_first = function(text)

    local orig_text = text
    local list = {}

    text = string_mul(" ", #text * 2) .. text .. string_mul(" ", #text * 2)

    for i = 1, math.floor(#text / 1.5) do
        local add_text = text:sub(i, (i + math.floor(#orig_text * 2) % #text))

        table.insert(list, add_text .. "\t")
    end

    return list
end

tag_changer.build_second = function(text)
    local builded = {}

    for i = 1, #text do

        local tmp = text:sub(i, #text) .. text:sub(1, i-1)

        if tmp:sub(#tmp) == " " then
            tmp = tmp:sub(1, #tmp-1) .. "\t"
        end

        table.insert(builded, tmp)
    end

    return builded
end

ui.group_name = "extras"
ui.is_enabled = menu.add_checkbox(ui.group_name, "clan-tag spammer", false)
ui.type = menu.add_selection(ui.group_name, "animation type", {"first", "second", "advertise"})
ui.speed = menu.add_slider(ui.group_name, "tag speed", 0, 4)
ui.input = menu.add_text_input(ui.group_name, "tag")

tag_changer.current_build = tag_changer.build_first("primordial.dev")
tag_changer.current_tag = "empty_string"

tag_changer.disabled = true
tag_changer.on_paint = function()

    local is_enabled = ui.is_enabled:get()
    if not engine.is_in_game() or not is_enabled then

        if not is_enabled and not tag_changer.disabled then
            ffi_handler.change_tag_fn("", "")
            tag_changer.disabled = true
        end

        tag_changer.last_time_update = -1
        return
    end    

    local tag_type = ui.type:get()
    local ui_tag = ui.input:get()
    if tag_type ~= 3 and ui_tag ~= tag_changer.current_tag then
        tag_changer.current_build = tag_type == 1 and tag_changer.build_first(ui_tag) or tag_changer.build_second(ui_tag)
    elseif tag_type == 3 then
        tag_changer.current_build = tag_changer.custom_tag
    end

    local tag_speed = ui.speed:get()
    if tag_type == 3 then
        tag_speed = math.max(1, tag_speed)
    end

    if tag_speed == 0 then
        tag_changer.update(ui_tag)
        return
    end

    local current_tag = math.floor(global_vars.cur_time() * tag_speed % #tag_changer.current_build) + 1
    current_tag = tag_changer.current_build[current_tag]

    tag_changer.disabled = false
    tag_changer.update(current_tag)
end

callbacks.add(e_callbacks.PAINT, tag_changer.on_paint)

callbacks.add(e_callbacks.PAINT, on_paint)
local phrases = {
	kill = ' ENEMY ELIMINATED',		
	kill_plural = ' ENEMIES ELIMINATED',
	kill_zk = 'ENEMY ANNIHILATED',			
};

local kill_phrases = {
	'DOUBLE KILL',
	'MULTI KILL',
	'ULTRA KILL',
	'MONSTER KILL',
	'KILLING SPREE',
	'RAMPAGE',
	'DOMINATING',
	'UNSTOPPABLE',
	'GODLIKE',
	'COMBO WHORE'
};

local zk_phrases = {
	'Owned! ',
	'Outplayed by a true pro! ',
	'Outsmarted! ',
	'Sick move, dude! ',
	'Wonder if he will rq... ',
};

local nade_phrases = {
	he = {
		'BOOM! ',
		'Are you a basketball player? ',
		'No need for a weapon, huh? '
	},
	molly = {
		'Look at his ashes! ',
		'Reminds me of auschwitz...? ',
		'One fried retard and a cola, please! '
	}
};
local data = {
	game = {
		kills = 0,
	},
	round = {
		kills = 0,
	},
	anim = {
		prefix = '',
		counter = 0,
		counter_update = 0,
		should_announce = false,
		is_zk = false,
		global_alpha = 1,
		desc_alpha = 1,
		keys = {
			fade_in = 0,
			fade_in_stop = 0,
			fade_out = 0,
			fade_out_stop = 0,
			stop = 0,
		},
	},
	const = {
		fade_in_dur = 0.1,
		fade_out_dur = 0.5,
		fade_hold = 2,
		counter_dur = 0.025,
	},
};

local animation_fonts = {
	{ font = render.create_font('verdana', 92,500, e_font_flags.DROPSHADOW), color = { color_t(255,255,255, 255), color_t(255,255,255, 255) } },
	{ font = render.create_font('verdana', 84,500, e_font_flags.DROPSHADOW), color = { color_t(201,222,255, 255), color_t(255,186,171, 255) } },
	{ font = render.create_font('verdana', 72,500, e_font_flags.DROPSHADOW), color = { color_t(168,202,255, 255), color_t(255,128,135, 255) } },
	{ font = render.create_font('verdana', 64,500, e_font_flags.DROPSHADOW), color = { color_t(135,182,255, 255), color_t(255,94,103, 255) } },
	{ font = render.create_font('verdana', 52,500, e_font_flags.DROPSHADOW), color = { color_t(66, 135, 245, 255), color_t(255,66,76, 255) } },
};

local bold_font = render.create_font('verdanab', 24, e_font_flags.DROPSHADOW);
local norm_font = render.create_font('verdana', 16, e_font_flags.DROPSHADOW);

local function start_animation(is_zk, nade, hs, fire)
	is_zk = is_zk or false
	data.anim.counter = 0;
	data.anim.should_announce = true;
	data.anim.is_zk = is_zk;
	
	local prefix = '';
	if is_zk then
		prefix = zk_phrases[client.random_int(1, #zk_phrases)];
	elseif nade then
		prefix = nade_phrases.he[client.random_int(1, #nade_phrases.he)];
	elseif fire then
		prefix = nade_phrases.molly[client.random_int(1, #nade_phrases.molly)];
	end
	
	data.anim.prefix = prefix;
	
	local realtime = global_vars.real_time();
	data.anim.keys.fade_in = realtime + data.const.counter_dur * (#animation_fonts + 1);
	data.anim.keys.fade_in_stop = data.anim.keys.fade_in + data.const.fade_in_dur;
	data.anim.keys.fade_out = data.anim.keys.fade_in_stop + data.const.fade_hold;
	data.anim.keys.fade_out_stop = data.anim.keys.fade_out + data.const.fade_out_dur;
	data.anim.keys.stop = data.anim.keys.fade_out_stop;
	
	data.anim.global_alpha = 1;
	data.anim.desc_alpha = 0;
	data.anim.counter_update = realtime;
end

local zk_items = {
	'taser', 'knife', 'bayonet'
};

local function lerp(a, b, t)
	return (b - a) * t + a;
end

local function clamp(v, a, b)
	if v > a then return a end
	if v < b then return b end
	return v;
end

local function is_plural(n)
	return n ~= 1;
end




callbacks.add(e_callbacks.PAINT, on_paint)