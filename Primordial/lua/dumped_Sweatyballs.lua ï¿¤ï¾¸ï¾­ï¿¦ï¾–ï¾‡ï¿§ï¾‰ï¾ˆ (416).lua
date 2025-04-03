local conditions_names = { " 慢走", "空中", "蹲", "站立", "移动" }

local references = {
    lua = {
        active_tab = menu.add_list( "汗球", "aa条件 / 反自瞄条件", conditions_names ),
        inAir = menu.add_checkbox( "汗球", " 空中固定腿" ),
        onGround = menu.add_checkbox( "汗球", " 陆地反向滑步" ),
        onLand = menu.add_checkbox( "汗球", " 落地抬头" ),
        lean = menu.add_checkbox( "汗球", " 倾斜模式" ),
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
        menu.add_text( "[COND] - " .. conditions_names[ i ], "--假身--" ),
        menu.add_selection( "[COND] - " .. conditions_names[ i ], "方向模式",  {"没有任何", "左", "右", "抖动", "偷窥假身", "偷窥真身", "身体 摇摆" } ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "左边假身大小", 0, 100 ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "右边假身大小", 0, 100 ),
        menu.add_selection( "[COND] - " .. conditions_names[ i ], "身体倾斜", { "没有任何", "静态", "静态抖动", "随机抖动", "摇摆" } ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "身体 瘦 价值", -50, 50 ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "身体 瘦 抖动", 0, 100 ),
        menu.add_text( "[COND] - " .. conditions_names[ i ], "--真身--" ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "添加左偏航", -180, 180 ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "添加右偏航", -180, 180 ),
        menu.add_checkbox( "[COND] - " .. conditions_names[ i ], "旋转", false ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "旋转角度", 0, 360 ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "旋转速度", 0, 100 ),
        menu.add_selection( "[COND] - " .. conditions_names[ i ], "抖动模式", { "无", "静态", "随机" } ),
        menu.add_slider( "[COND] - " .. conditions_names[ i ], "抖动大小", -180, 180 ),
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


-- set our colors here ig --
local colors = {
    white = color_t(255, 255, 255),
    red   = color_t(255, 0, 0),
    gray  = color_t(100, 100, 100)
}

-- references cuz i couldn't be fucked to type this everytime --
local ref = {
	aimbot = {
		dt_ref = menu.find("aimbot","general","exploits","doubletap","enable"),
		hs_ref = menu.find("aimbot","general","exploits","hideshots","enable"),
		hitbox_override = menu.find("aimbot", "auto", "target overrides", "force hitbox"),
        safepoint_ovride = menu.find("aimbot", "auto", "target overrides", "force safepoint")
	},
}

local globals = {
    crouching          = false,
    standing           = false,
    jumping            = false,
    running            = false,
    pressing_move_keys = false
}

local screen_size    = render.get_screen_size()

local indicator = menu.add_checkbox("基本", "指示器")
local ind_col = indicator:add_color_picker("指示器 颜色")

local function indicators()
    if not engine.is_in_game() then return end
    local local_player = entity_list.get_local_player()
    if not local_player:is_alive() then return end
    if not indicator:get() then return end

    local lethal         = local_player:get_prop("m_iHealth") <= 92
	local font_inds      = render.create_font("Smallest Pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE) -- font
	local x, y           = screen_size.x / 2, screen_size.y / 2
    local indi_color     = ind_col:get()
    local text_size      = render.get_text_size(font_inds, "汗球")
    local text_size2     = render.get_text_size(font_inds, "lethal")
    local cur_weap       = local_player:get_prop("m_hActiveWeapon")
    local current_state  = "汗球"
    local ind_offset     = 0

    if globals.jumping then
        current_state = "*跳"
    elseif globals.running then
        current_state = "*走"
    elseif globals.standing then
        current_state = "*站立"
    elseif globals.crouching then
        current_state = "*鸭"
    end
    
    -- LETHAL --
    if lethal then
        render.text(font_inds, "致命", vec2_t(x + 2, y + 23), indi_color, true)
    end

    render.text(font_inds, current_state, vec2_t(x + 1, y + 33), indi_color, true)

    render.text(font_inds, "汗球", vec2_t(x + 2, y + 43), indi_color, true)

    -- DT --
    if ref.aimbot.dt_ref[2]:get() then
        if exploits.get_charge() < 1 then
            render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.red, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
        else
            render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.white, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
        end
    else
        render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
    end

    -- HS --
    if ref.aimbot.hs_ref[2]:get() then
        render.text(font_inds, "HS", vec2_t(x - 20 + ind_offset, y + 53), colors.white, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "HS")[0] + 5
    else
        render.text(font_inds, "HS", vec2_t(x - 20 + ind_offset, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "HS")[0] + 5
    end

    -- BA --
    if ref.aimbot.hitbox_override[2]:get() then
        render.text(font_inds, "BA", vec2_t(x - 20 + ind_offset, y + 53), colors.white, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "BA")[0] + 5
    else
        render.text(font_inds, "BA", vec2_t(x - 20 + ind_offset, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "BA")[0] + 5
    end

    -- SP --
    if ref.aimbot.safepoint_ovride[2]:get() then
        render.text(font_inds, "SP", vec2_t(x - 20 + ind_offset, y + 53), colors.white, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "SP")[0] + 5
    else
        render.text(font_inds, "SP", vec2_t(x - 20 + ind_offset, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "SP")[0] + 5
    end
end

callbacks.add(e_callbacks.PAINT, function()
    ind_col:set_visible(indicator:get())

    indicators()
end)

callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
    local local_player = entity_list.get_local_player()
    globals.pressing_move_keys = (cmd:has_button(e_cmd_buttons.MOVELEFT) or cmd:has_button(e_cmd_buttons.MOVERIGHT) or cmd:has_button(e_cmd_buttons.FORWARD) or cmd:has_button(e_cmd_buttons.BACK))

    if (not local_player:has_player_flag(e_player_flags.ON_GROUND)) or (local_player:has_player_flag(e_player_flags.ON_GROUND) and cmd:has_button(e_cmd_buttons.JUMP)) then
        globals.jumping = true
    else
        globals.jumping = false
    end

    if globals.pressing_move_keys then
        if not globals.jumping then
            if cmd:has_button(e_cmd_buttons.DUCK) then
                globals.crouching = true
                globals.running = false
            else
                globals.running = true
                globals.crouching = false
            end
        elseif globals.jumping and not cmd:has_button(e_cmd_buttons.JUMP) then
            globals.running = false
            globals.crouching = false
        end

        globals.standing = false
    elseif not globals.pressing_move_keys then
        if not globals.jumping then
            if cmd:has_button(e_cmd_buttons.DUCK) then
                globals.crouching = true
                globals.standing = false
            else
                globals.standing = true
                globals.crouching = false
            end
        else
            globals.standing = false
            globals.crouching = false
        end
        
        globals.running = false
    end
end)

--thanks the thought from other forum
--paste by NOT Remine again hahahahaha
local switch_id = menu.add_selection( "电击枪快速切换 ", "武器",  {"主武器", "服务器", "刀" } )

local function new_wpn()
    local choice = switch_id:get()
    if choice == 1 then return "slot1" end
    if choice == 2 then return "slot2" end
    if choice == 3 then return "slot3" end
end

local function on_aimbot_shoot(shot)
local local_player = entity_list:get_local_player()
local weapon = entity_list.get_entity(local_player:get_prop("m_hActiveWeapon"))
local weapon_name = weapon:get_name()
if weapon_name ~= "taser" then return end
    engine.execute_cmd(new_wpn())
end
    
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_aimbot_shoot)



local function watermarkDraw()
    return ""
end

callbacks.add(e_callbacks.DRAW_WATERMARK, watermarkDraw)

local buybot_ref = menu.find("misc", "utility", "buybot", "enable")

local function OnEvent(event)
    if event.name == "round_prestart" then
        local is_valve = game_rules.get_prop("m_bIsValveDS") == 1
        if is_valve and buybot_ref:get() then
            buybot_ref:set(false)
            print("Disabled buybot due to Valve server")
        elseif not is_valve and not buybot_ref:get() then
            buybot_ref:set(true)
            print("Enabled buybot due to community server")
        end
    end
end

callbacks.add(e_callbacks.EVENT, OnEvent)

local kill_say = {}
local ui = {}
kill_say.phrases = {}

-- just found all phrases on github
table.insert(kill_say.phrases, {
    name = "汗球",
    phrases = {
        "you need sweatyballs.lua.",
        "go download sweatyballs.lua to stop being owned",
        "getting mad that my balls are in your face? get sweatyballs.lua",
        "sweatyballs.lua, carrying primordial since 1990",
        "god i love sweatyballs",
        "i just be sucking on femboy cock n shit - sweatyballs.lua",
        "are you a femboy? send your feet pics to crypt#5173",
		        "are you a femboy? send your feet pics to crypt#5173",
				        "are you a femboy? send your feet pics to crypt#5173",
						        "are you a femboy? send your feet pics to crypt#5173",
		"i just love sucking on femboy balls - sweatyballs.lua",
		"primordial.dev turned me gay so i use sweatyballs.lua",
		"bro i just love sweatyballs.lua",
		"show me your feet",
		"show me your feet",
		"show me your feet",
		"show me your feet"
    }
})

table.insert(kill_say.phrases, {
    name = "中文",
    phrases = {
        "你需要汗水球.lua。",
        "去下载汗球lua以停止被拥有",
        "生气我的蛋蛋在你脸上？得到汗水球.lua",
        "汗球 lua，自 1990 年以来一直携带 primo",
        "上帝，我喜欢汗球",
        "我只是在吮吸 femboy 公鸡 n 狗屎 - 汗球 lua",
        "你是一个女人味的男孩吗？把你的脚照片发到 crypt#5173",
		        "你是一个女人味的男孩吗？把你的脚照片发到 crypt#5173",
				        "你是一个女人味的男孩吗？把你的脚照片发到 crypt#5173",
						        "你是一个女人味的男孩吗？把你的脚照片发到 crypt#5173",
		"我只是喜欢吮吸 femboy 球 - 汗球 lua",
		"primordial.dev 把我变成了同性恋，所以我用汗球 lua",
		"兄弟，我只是喜欢汗水球.lua",
		"让我看看你的脚",
		"让我看看你的脚",
		"让我看看你的脚",
		"让我看看你的脚",
		"让我看看你的脚",
		"让我看看你的脚",
		"让我看看你的脚"
    }
})

ui.group_name = "击杀喊话"
ui.is_enabled = menu.add_checkbox(ui.group_name, "击杀喊话", false)

ui.current_list = menu.add_selection(ui.group_name, "语言列表", (function()
    local tbl = {}
    for k, v in pairs(kill_say.phrases) do
        table.insert(tbl, ("%d. %s"):format(k, v.name))
    end

    return tbl
end)())

kill_say.player_death = function(event)

    if event.attacker == event.userid or not ui.is_enabled:get() then
        return
    end

    local attacker = entity_list.get_player_from_userid(event.attacker)
    local localplayer = entity_list.get_local_player()

    if attacker ~= localplayer then
        return
    end

    local current_killsay_list = kill_say.phrases[ui.current_list:get()].phrases
    local current_phrase = current_killsay_list[client.random_int(1, #current_killsay_list)]:gsub('\"', '')
    
    engine.execute_cmd(('say "%s"'):format(current_phrase))
end

callbacks.add(e_callbacks.EVENT, kill_say.player_death, "player_death")

local enabled = true

local screen_size = render.get_screen_size()
local x = screen_size.x / 1.98
local y = screen_size.y / 2.01

local main_font = render.create_font("Verdana", 12, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

local min_damage_a = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local min_damage_s = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local min_damage_h = menu.find("aimbot", "deagle", "target overrides", "force min. damage")
local min_damage_k = menu.find("aimbot", "revolver", "target overrides", "force min. damage")
local min_damage_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local min_damage_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage")

local amount_auto = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local amount_scout = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local amount_awp = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))
local amount_deagle = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage"))
local amount_revolver = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local amount_pistol = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))

local function getweapon()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end

    local weapon_name = nil

    if local_player:get_prop("m_iHealth") > 0 then
    
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end

        weapon_name = active_weapon:get_name()


    else return end

    return weapon_name

end

local function on_paint()
    if enabled then

        if menu.is_open() then return end

        if getweapon() == "ssg08" then
            if min_damage_s[2]:get() then
                render.text(main_font, tostring(amount_scout:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "deagle" then
            if min_damage_h[2]:get() then
                render.text(main_font, tostring(amount_deagle:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "revolver" then
            if min_damage_k[2]:get() then
                render.text(main_font, tostring(amount_revolver:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "awp" then
            if min_damage_awp[2]:get() then
                render.text(main_font, tostring(amount_awp:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
            if min_damage_a[2]:get() then
                render.text(main_font, tostring(amount_auto:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
            if min_damage_p[2]:get() then
                render.text(main_font, tostring(amount_pistol:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
            end
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)


local enableSwag = menu.add_checkbox(" | 一般", "开启日志", false)
local printtoConsole = menu.add_checkbox(" | 一般", "控制台绘制日志", false)

local amountonscreen = menu.add_slider(" | 装饰", "屏幕的日志数量", 1, 10)
local timelogs = menu.add_slider(" | 装饰", "屏幕消失的时间", 0, 10)
local fontstyle = menu.add_selection(" | 装饰", "字体风格", {"正常正常", "大号字体"})

local logs = {}
local logrender = {}
local logtime = {}
local boollog = {true,true,true,true,true}
local curTime = {}
local hitgroup_names = {'通用的', '头', '胸部', '胃', '左臂', '右臂', '左腿', '右腿', '脖子', '?', '齿轮'}


local fonts = {
    normal = render.create_font("Tahoma", 12, 100, e_font_flags.ANTIALIAS),
    bold = render.create_font("Tahoma Bold", 13, 500, e_font_flags.ANTIALIAS)
}

function drawLog()
    if not enableSwag:get() then return end
    local screen_size = render.get_screen_size()
    for i = 1, #logs do
        if logrender[i] then
            if not logtime[i] or not logs[i] then return end
            render.text(fontstyle:get() == 1 and fonts.normal or fonts.bold, logs[i], vec2_t(screen_size.x/2, screen_size.y/(1.25+i/45)), color_t(255, 255, 255, logtime[i]), true)
        end
    end
end

function onHit(e)
    local hitString = string.format("[汗球]受到伤害 %s 于 %s [%s] 为了 %s [%s] (hc: %s bt: %s)", e.player:get_name(), hitgroup_names[e.hitgroup + 1] or '?', hitgroup_names[e.aim_hitgroup + 1], e.damage, e.aim_damage, math.floor(e.aim_hitchance).."%", e.backtrack_ticks)
    table.insert(logs, hitString); table.insert(logrender, true)
    if #logs > amountonscreen:get() then
        table.remove(logs, 1); table.remove(logrender, 1); table.remove(logtime, 1); table.remove(boollog, 1); table.remove(curTime, 1)
    end
    if printtoConsole:get() then
        client.log(hitString)
    end
    boollog[#logs] = true
end

function onMiss(e)
    local missString = string.format("[汗球]错过 %s %s 由于 %s [%s] (hc: %s bt: %s)", e.player:get_name().."'s", hitgroup_names[e.aim_hitgroup + 1] or '?', e.reason_string, e.aim_damage, math.floor(e.aim_hitchance).."%", e.backtrack_ticks)
    table.insert(logs, missString)
    table.insert(logrender, true)
    if #logs > amountonscreen:get() then
        table.remove(logs, 1); table.remove(logrender, 1); table.remove(logtime, 1); table.remove(boollog, 1); table.remove(curTime, 1)
    end
    if printtoConsole:get() then
        client.log(missString)
    end
    boollog[#logs] = true
end

function handleVisibility()
    for i = 1, #logs do
        if boollog[i] then
            curTime[i] = client.get_unix_time() + timelogs:get()
            boollog[i] = false
            logtime[i] = 255
        end
        if not curTime[i] then goto endrendering end
        if curTime[i] < client.get_unix_time() then
            logtime[i] = logtime[i] - 1
        end
        if logtime[i] == 10 then
            table.remove(logs, i);table.remove(logrender, i);table.remove(logtime, i);table.remove(boollog, i);table.remove(curTime, i)
        end
        ::endrendering::
    end 
end

callbacks.add(e_callbacks.AIMBOT_MISS, onMiss)
callbacks.add(e_callbacks.AIMBOT_HIT, onHit)

callbacks.add(e_callbacks.PAINT, function()
    drawLog(); handleVisibility()
end)