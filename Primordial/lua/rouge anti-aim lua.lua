-- FFI
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

-- Requires
local state = require("primordial/Player state library.641")
local base64 = require("primordial/base64.371")
local json = require("primordial/JSON Library.97")
local clipboard = require("primordial/clipboard lib.131")

local build = "Alpha"

-- Selection
local menuselection = menu.add_selection("Lua", "Selection", {"Home", "Anti-aim","Misc", "Visuals"})
local ss2 = menu.add_text("Lua", "Welcome Back, " .. user.name .. "")
local ss3 = menu.add_text("Lua", "Build: "..build.."")
-- Anti-Aim
local antiaim_mode = menu.add_selection("Main", "Mode", {"Builder"})
local animation_breakers = menu.add_multi_selection("Main", "Anim. Breakers", {"Static Legs In Air", "Zero Pitch On Land"})

-- Misc
local trashtalk = menu.add_checkbox("Main","Trashtalk",false)
local breaklcinair = menu.add_checkbox("Main","Break lagcomp in air",false)

--Visuals
local aimbotlogs = menu.add_checkbox("Main","Aimbot logs",false)
local infopanel = menu.add_checkbox("Main","Infopanel",false)
local infopanel_color = infopanel:add_color_picker("Infopanel color")


local refs = {
    fakelag_ticks = menu.find("antiaim", "main", "fakelag", "amount"),
    slowwalk_key = unpack(menu.find("misc", "main", "movement", "slow walk")),
    pitch = menu.find("antiaim", "main", "angles", "pitch"),
    yawbase = menu.find("antiaim", "main", "angles", "Yaw Base"),
    yawadd = menu.find("antiaim", "main", "angles", "Yaw Add"),
    rotate = menu.find("antiaim", "main", "angles", "rotate"),
    rotate_range = menu.find("antiaim", "main", "angles", "rotate", "rotate range"),
    rotate_speed = menu.find("antiaim", "main", "angles", "rotate", "rotate speed"),
    jittermode = menu.find("antiaim", "main", "angles", "jitter mode"),
    jittertype = menu.find("antiaim", "main", "angles", "jitter type"),
    jitteradd = menu.find("antiaim", "main", "angles", "jitter add"),
}


-- Notify
local main_font = render.create_font("Verdana", 12, 400, e_font_flags.DROPSHADOW)
local x,y = render.get_screen_size().x, render.get_screen_size().y
notifyarray = {}
local function logs()
    if #notifyarray > 0 then
        if globals.tick_count() >= notifyarray[1][2] then
            if notifyarray[1][3] > 0 then
                notifyarray[1][3] = notifyarray[1][3] - 20
            elseif notifyarray[1][3] <= 0 then
                table.remove(notifyarray, 1)
            end
        end
        if #notifyarray > 6 then
            table.remove(notifyarray, 1)
        end
        if engine.is_connected() == false then
            table.remove(notifyarray, #notifyarray)
        end
        for i = 1, #notifyarray do
            if notifyarray[i][3] < 255 then 
                notifyarray[i][3] = notifyarray[i][3] + 10 
            end
            local stringsize = render.get_text_size(main_font, notifyarray[i][1])
            render.text(main_font, notifyarray[i][1], vec2_t(x/2 - (stringsize.x/2 ), y - (notifyarray[i][3]/5) - 22 * i + 4), color_t(255, 255, 255, 255))
        end
    end
end

notifyarray[#notifyarray+1] = {(" Welcome to rouge"), globals.tick_count() + 150, 0}

-- Anti-Aim
Antiaim = {}

local var = {
    player_states = {"Standing", "Moving", "Jumping", "Jumping-Duck", "Crouching", "Slowwalk"},
	player_states_idx = {["Standing"] = 1, ["Moving"] = 2, ["Jumping"] = 3, ["Jumping-Duck"] = 4, ["Crouching"] = 5, ["Slowwalk"] = 6},
    p_state = 0
}

Antiaim[0] = {
    Condition = menu.add_selection("AA-Builder", "Condition", var.player_states),
}

for i = 1,6 do
	Antiaim[i] ={
        pitch = menu.add_selection("AA-Builder", "Pitch", {"None", "Down", "Up", "Zero", "Jitter"}),
        yawbase = menu.add_selection("AA-Builder", "Yaw Base", {"None", "Viewangle", "At Target (Crosshair)", "At Target (Distance)", "Velocity"}),
        yawl = menu.add_slider("AA-Builder", "Yaw left", -90, 90),
        yawr = menu.add_slider("AA-Builder", "Yaw right", -90, 90),
        yawoffset = menu.add_slider("AA-Builder", "Yaw Offset", -180, 180),
        jittertype = menu.add_selection("AA-Builder", "Jitter Type", {"Offset", "Center"}),
        jitteradd = menu.add_slider("AA-Builder", "Jitter Add", -180, 180),
        desyncl = menu.add_slider("AA-Builder", "Desync left", 0, 60),
        desyncr = menu.add_slider("AA-Builder", "Desync right", 0, 60),
	}
end


local function on_antiaim(ctx)
    local local_player = entity_list.get_local_player()
    local inverter = local_player:get_prop("m_flPoseParameter", 11) * 120 - 60 <= 0 and true or false
    local player_state = state.get_state()
    if player_state == 1 then
        var.p_state = 1
    elseif player_state == 2 then
        var.p_state = 2
    elseif player_state == 3 then
        var.p_state = 6
    elseif player_state == 4 then
        var.p_state = 5
    elseif player_state == 5 then
        var.p_state = 3
    elseif player_state == 6 then
        var.p_state = 4
    end
    if antiaim_mode:get() == 1 then
        refs.jittermode:set(2)
        refs.pitch:set(Antiaim[var.p_state].pitch:get())
        refs.yawbase:set(Antiaim[var.p_state].yawbase:get())
        refs.jittertype:set(Antiaim[var.p_state].jittertype:get())
        refs.jitteradd:set(Antiaim[var.p_state].jitteradd:get())
        refs.yawadd:set(antiaim.get_desync_side() == 1 and Antiaim[var.p_state].yawl:get() + Antiaim[var.p_state].yawoffset:get() or Antiaim[var.p_state].yawr:get() + Antiaim[var.p_state].yawoffset:get())
    end
end

local function antiaim_visibler()
    Antiaim[0].Condition:set_visible(menuselection:get() == 2 and antiaim_mode:get() == 1)
    if Antiaim[0].Condition:get() == 1 then
        playerstate_idx = 1
    elseif Antiaim[0].Condition:get() == 2 then
        playerstate_idx = 2
    elseif Antiaim[0].Condition:get() == 3 then
        playerstate_idx = 3
    elseif Antiaim[0].Condition:get() == 4 then
        playerstate_idx = 4
    elseif Antiaim[0].Condition:get() == 5 then
        playerstate_idx = 5
    elseif Antiaim[0].Condition:get() == 6 then
        playerstate_idx = 6
    end
    for i = 1, 6 do
        Antiaim[i].pitch:set_visible(i == playerstate_idx  and menuselection:get() == 2 and antiaim_mode:get() == 1)
        Antiaim[i].yawbase:set_visible(i == playerstate_idx  and menuselection:get() == 2 and antiaim_mode:get() == 1)
        Antiaim[i].yawl:set_visible(i == playerstate_idx  and menuselection:get() == 2 and antiaim_mode:get() == 1)
        Antiaim[i].yawr:set_visible(i == playerstate_idx  and menuselection:get() == 2 and antiaim_mode:get() == 1)
        Antiaim[i].yawoffset:set_visible(i == playerstate_idx  and menuselection:get() == 2 and antiaim_mode:get() == 1)
        Antiaim[i].jittertype:set_visible(i == playerstate_idx  and menuselection:get() == 2 and antiaim_mode:get() == 1)
        Antiaim[i].jitteradd:set_visible(i == playerstate_idx  and menuselection:get() == 2 and antiaim_mode:get() == 1)
        Antiaim[i].desyncl:set_visible(i == playerstate_idx  and menuselection:get() == 2 and antiaim_mode:get() == 1)
        Antiaim[i].desyncr:set_visible(i == playerstate_idx  and menuselection:get() == 2 and antiaim_mode:get() == 1)
    end
end

-- Animation Breakers
local entityList = ffi.cast( "void***", memory.create_interface( "client.dll", "VClientEntityList003" ) )
local getEntityFN = ffi.cast( "GetClientEntity_4242425_t", entityList[ 0 ][ 3 ] ) 
local function getEntityAddress( idx ) return getEntityFN( entityList, idx ) end
local function getAnimstate( pPlayer ) return ffi.cast( "CCSGOPlayerAnimationState_534535_t**", ffi.cast( "uintptr_t", pPlayer ) + 0x9960 )[ 0 ] end

local function anim_breakers(ctx)
    local ground_ticks = 1
    local end_time = 0
    local player = entity_list.get_local_player()
    local lpPtr = getEntityAddress( player:get_index( ) )

    if not lpPtr or lpPtr == 0x0 then
        return
    end
    if (player == nil or not player:is_alive()) then
        return
    end
    local on_ground = player:has_player_flag(e_player_flags.ON_GROUND)
    if (animation_breakers:get(1)) then
        if (not on_ground) then
            ctx:set_render_pose(e_poses.JUMP_FALL, 1)
        end
    end
    if (animation_breakers:get(2)) then
        if on_ground and getAnimstate( lpPtr ).bHitGroundAnimation then
            ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
        end
    end
end

local killsays = {
	"1 ",
    "ez ",
}

local function on_event(event)
    if not trashtalk:get() then return end
    local lp = entity_list.get_local_player()
    local kill_cmd = 'say '..killsays[math.random(1, #killsays)] 
    if event.name ~= "player_death" then return end
    if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() then return end
    engine.execute_cmd(kill_cmd)
end

local function are_have_weapon(ent)
    if not ent:is_alive() or not ent:get_active_weapon() then return end
    local t_cur_wep = ent:get_active_weapon():get_class_name()
    return t_cur_wep ~= "CKnife" and t_cur_wep ~= "CC4" and t_cur_wep ~= "CMolotovGrenade" and t_cur_wep ~= "CSmokeGrenade" and t_cur_wep ~= "CHEGrenade" and t_cur_wep ~= "CWeaponTaser"
end
local function are_them_visibles(ent)
    local local_p = entity_list:get_local_player()
    local generic_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
    local left_arm_pos = ent:get_hitbox_pos(e_hitgroups.LEFT_ARM)
    local right_arm_pos = ent:get_hitbox_pos(e_hitgroups.RIGHT_ARM)
    if local_p:is_point_visible(generic_pos) or local_p:is_point_visible(left_arm_pos) or local_p:is_point_visible(right_arm_pos) then return true else return false end
end
local function strangerdranger(cmd)
    if not breaklcinair:get() then return end
    if ragebot.get_autopeek_pos() then return end
    local enemies = entity_list.get_players(true)
    for i,v in ipairs(enemies) do
        if are_them_visibles(v) and are_have_weapon(v) then
            exploits.force_uncharge()
            exploits.block_recharge()
        else
            exploits.allow_recharge()
        end
    end
end
local hit_hitbox = 'x'
local function on_aimbot_hit(hit)
    if not aimbotlogs:get() then return end
    if hit.hitgroup == 1 then
        hit_hitbox = "head"
    elseif hit.hitgroup == 2 then
        hit_hitbox = "chest"
    elseif hit.hitgroup == 3 then
        hit_hitbox = "stomach"
    elseif hit.hitgroup == 7 then
        hit_hitbox = "feet"
    elseif hit.hitgroup == 5 then
        hit_hitbox = "arm"
    elseif hit.hitgroup == 6 then
        hit_hitbox = "leg"
    end
    notifyarray[#notifyarray+1] = {("rouge ~ hit "..hit.player:get_name().."'s "..hit_hitbox.." for "..hit.damage.." damage"), globals.tick_count() + 150, 0}
end

local mis_hitbox = 'x'
local function on_aimbot_miss(shot)
    if not aimbotlogs:get() then return end
    if shot.aim_hitgroup == 1 then
        mis_hitbox = "head"
    elseif shot.aim_hitgroup == 2 then
        mis_hitbox = "chest"
    elseif shot.aim_hitgroup == 3 then
        mis_hitbox = "stomach"
    elseif shot.aim_hitgroup == 7 then
        mis_hitbox = "feet"
    elseif shot.aim_hitgroup == 5 then
        mis_hitbox = "arm"
    elseif shot.aim_hitgroup == 6 then
        mis_hitbox = "leg"
    end
    notifyarray[#notifyarray+1] = {("rouge ~ missed "..shot.player:get_name().."'s "..mis_hitbox.." due to "..shot.reason_string), globals.tick_count() + 150, 0}
end

local main_font_2 = render.create_font("Verdana", 10, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE, e_font_flags.ANTIALIAS) -- font
local function infopanel_func()
    if not infopanel:get() then return end
    local x,y = render.get_screen_size().x, render.get_screen_size().y
    render.rect_fade(vec2_t(x/x,y/2.01 - 5), vec2_t(x/x + 100, -y/y - 25), color_t(infopanel_color:get().r,infopanel_color:get().g,infopanel_color:get().b,150), color_t(infopanel_color:get().r,infopanel_color:get().g,infopanel_color:get().b,0), true)
    render.text(main_font_2, "ROUGE ~ PRIMORDIAL", vec2_t(x/x + 4,y/2.12), color_t(255, 255, 255, 255))
    render.text(main_font_2, "VERSION ~ ALPHA", vec2_t(x/x + 4,y/2.08), color_t(255, 255, 255, 255))
end


-- Callbacks
callbacks.add(e_callbacks.AIMBOT_MISS, on_aimbot_miss)
callbacks.add(e_callbacks.EVENT, on_event)
callbacks.add(e_callbacks.SETUP_COMMAND, strangerdranger)
callbacks.add(e_callbacks.AIMBOT_HIT, on_aimbot_hit)

-- Paint
callbacks.add(e_callbacks.PAINT, antiaim_visibler)
callbacks.add(e_callbacks.PAINT, logs)
callbacks.add(e_callbacks.PAINT, infopanel_func)


-- Anti-Aim
callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
callbacks.add(e_callbacks.ANTIAIM,  anim_breakers)




-- Config System

local data = {
	bools = {},
	tables = {},
	ints = {},
	numbers = {},
}

function sorting(t)  
	local a = {}  
	for n in pairs(t) do a[#a+1] = n  
	end  
	table.sort(a)  
	local i = 0  
	return 
    function()  
		i = i + 1 return a[i], t[a[i]]  
	end  
end 

for i, v in sorting(var.player_states) do
	for _, v in sorting(Antiaim[i]) do
		if type(v:get()) == "boolean" then
			table.insert(data.bools,v)
		elseif type(v:get()) == "table" then
			table.insert(data.tables,v)
		elseif type(v:get()) == "string" then
			table.insert(data.ints,v)
		else
			table.insert(data.numbers,v)
		end
	end
end

for _, v in sorting(Antiaim[0]) do
    if type(v:get()) == "boolean" then
        table.insert(data.bools,v)
    elseif type(v:get()) == "table" then
        table.insert(data.tables,v)
    elseif type(v:get()) == "string" then
        table.insert(data.ints,v)
    else
        table.insert(data.numbers,v)
    end
end

local export = menu.add_button("Configs", "Export", function()
    engine.execute_cmd("playvol buttons/bell1.wav 1")  
	local configs = {{},{},{},{},{},{}}
		for _, bools in pairs(data.bools) do
			table.insert(configs[1], bools:get())
		end
		
		for _, tables in pairs(data.tables) do
			table.insert(configs[2], tables:get())
		end
		
		for _, ints in pairs(data.ints) do
			table.insert(configs[3], ints:get())
		end
		
		for _, numbers in pairs(data.numbers) do
			table.insert(configs[4], numbers:get())
		end
		
		clipboard.set(base64.encode(json.encode(configs)))
        engine.execute_cmd("playvol buttons/bell1.wav 1")  
end)

local import = menu.add_button("Configs", "Import", function()
    engine.execute_cmd("playvol buttons/bell1.wav 1")  
	local config = clipboard.get()
	for k, v in pairs(json.parse(base64.decode(config))) do
		k = ({[1] = "bools", [2] = "tables",[3] = "ints",[4] = "numbers"})[k]
		for k2, v2 in pairs(v) do
			if (k == "bools") then
				data[k][k2]:set(v2)
			end
	
			if (k == "tables") then
				data[k][k2]:set(v2)
			end
	
			if (k == "ints") then
				data[k][k2]:set(v2)
			end
				
			if (k == "numbers") then
				data[k][k2]:set(v2)
			end

		end
	end
end)

local default = menu.add_button("Configs", "Default", function()
    engine.execute_cmd("playvol buttons/bell1.wav 1")  
	local config = "W1tdLFtdLFtdLFs2MCw2MCwxNiwyLDIsMywtOSwwLDksNjAsNjAsMzgsMiwyLDMsLTYsMCw4LDYwLDYwLDM3LDIsMiwzLC0xNCwwLDE0LDYwLDYwLDIzLDIsMiwzLC05LDAsOSw2MCw2MCwxMiwyLDIsMywtNCwwLDQsNjAsNjAsMjgsMiwyLDMsLTcsMCw3LDZdLFtdLFtdXQ=="
	for k, v in pairs(json.parse(base64.decode(config))) do
		k = ({[1] = "bools", [2] = "tables",[3] = "ints",[4] = "numbers"})[k]
		for k2, v2 in pairs(v) do
			if (k == "bools") then
				data[k][k2]:set(v2)
			end
	
			if (k == "tables") then
				data[k][k2]:set(v2)
			end
	
			if (k == "ints") then
				data[k][k2]:set(v2)
			end
				
			if (k == "numbers") then
				data[k][k2]:set(v2)
			end

		end
	end
end)


local function visiblity()
    local selection = menuselection:get()
    ss2:set_visible(selection == 1)
    ss3:set_visible(selection == 1)
    antiaim_mode:set_visible(selection == 2)
    animation_breakers:set_visible(selection == 2)
    default:set_visible(selection == 2)
    import:set_visible(selection == 2)
    export:set_visible(selection == 2)
    antiaim_mode:set_visible(selection == 2)
    animation_breakers:set_visible(selection == 2)
    trashtalk:set_visible(selection == 3)
    breaklcinair:set_visible(selection == 3)
    aimbotlogs:set_visible(selection == 4)
    infopanel:set_visible(selection == 4)
    infopanel_color:set_visible(selection == 4)
end
callbacks.add(e_callbacks.PAINT, visiblity)