 -- {{ libraries }}
local ffi = require("ffi")
local pui = require("gamesense/pui")
local http = require("gamesense/http")
local base64 = require("gamesense/base64")
local vector = require("vector")

-- {{ useful }}
local ref = {
    aa_enable = ui.reference("AA","anti-aimbot angles","enabled"),
    pitch = ui.reference("AA","anti-aimbot angles","pitch"),
    pitch_value = select(2, ui.reference("AA","anti-aimbot angles","pitch")),
    yaw_base = ui.reference("AA","anti-aimbot angles","yaw base"),
    yaw = ui.reference("AA","anti-aimbot angles","yaw"),
    yaw_value = select(2, ui.reference("AA","anti-aimbot angles","yaw")),
    yaw_jitter = ui.reference("AA","Anti-aimbot angles","Yaw Jitter"),
    yaw_jitter_value = select(2, ui.reference("AA","Anti-aimbot angles","Yaw Jitter")),
    body_yaw = ui.reference("AA","Anti-aimbot angles","Body yaw"),
    body_yaw_side = select(2, ui.reference("AA","Anti-aimbot angles","Body yaw")),
    freestand_body_yaw = ui.reference("AA","Anti-aimbot angles","freestanding body yaw"),
    edgeyaw = ui.reference("AA","anti-aimbot angles","edge yaw"),
    freestand = {ui.reference("AA","anti-aimbot angles","freestanding")},
    roll = ui.reference("AA","anti-aimbot angles","roll"),
    slide = {ui.reference("AA","Other","slow motion")},
    fakeduck = ui.reference("rage","Other","duck peek assist"),
    quick_peek = {ui.reference("rage", "Other", "quick peek assist")},
    doubletap = {ui.reference("rage", "aimbot", "double tap")},
    damage = {ui.reference("rage", "aimbot", "minimum damage override")},
    osaa = {ui.reference("aa", "Other", "on shot anti-aim")},
    safe = {ui.reference("rage", "aimbot", "force safe point")},
    baim = {ui.reference("rage", "aimbot", "force body aim")},
    fl = ui.reference("aa", "fake lag", "limit"),
    legs = ui.reference("AA", "Other", "Leg movement")
}

-- { functions }
function get_velocity()
    if not entity.get_local_player() then return end
    local first_velocity, second_velocity = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    local speed = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))
    
    return speed
end

local ground_tick = 1
function get_state(speed)
    if not entity.is_alive(entity.get_local_player()) then return end
    local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    local land = bit.band(flags, bit.lshift(1, 0)) ~= 0
    if land == true then ground_tick = ground_tick + 1 else ground_tick = 0 end

    if bit.band(flags, 1) == 1 then
        if ground_tick < 10 then if bit.band(flags, 4) == 4 then return 5 else return 4 end end
        if bit.band(flags, 4) == 4 or ui.get(ref.fakeduck) then 
            return 6 -- crouching
        else
            if speed <= 3 then
                return 2 -- standing
            else
                if ui.get(ref.slide[2]) then
                    return 7 -- slowwalk
                else
                    return 3 -- moving
                end
            end
        end
    elseif bit.band(flags, 1) == 0 then
        if bit.band(flags, 4) == 4 then
            return 5 -- air-c
        else
            return 4 -- air
        end
    end
end

ffi.cdef[[
    struct animation_layer_t {
        char pad20[24];
        uint32_t m_nSequence;
        int iOutSequenceNr;
        int iInSequenceNr;
        int iOutSequenceNrAck;
        int iOutReliableState;
        int iInReliableState;
        int iChokedPackets;
        bool m_bIsBreakingLagComp;
        float m_flPrevCycle;
        float m_flWeight;
        char pad20[8];
        float m_flCycle;
        void *m_pOwner;
        char pad_0038[ 4 ]; 
    };

    struct c_animstate { 
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x5
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
        float m_flLeanAomunt; //0x90
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

    typedef uintptr_t (__thiscall* GetClientEntityHandle_4242425_t)(void*, uintptr_t);

    typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
    typedef bool(__thiscall* console_is_visible)(void*);
]]

local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')
local VGUI_System010 =  client.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010 )
local get_clipboard_text_count = ffi.cast("get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi.cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi.cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")

local classptr = ffi.typeof('void***')
local rawientitylist = client.create_interface('client.dll', 'VClientEntityList003') or error('VClientEntityList003 wasnt found', 2)
local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or error('get_client_entity is nil', 2)
local get_client_entity_bind = vtable_bind("client_panorama.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*,int)")
local get_inaccuracy = vtable_thunk(483, "float(__thiscall*)(void*)")

local angle3d_struct = ffi.typeof("struct { float pitch; float yaw; float roll; }")
local vec_struct = ffi.typeof("struct { float x; float y; float z; }")

local cUserCmd =
    ffi.typeof(
    [[
    struct
    {
        uintptr_t vfptr;
        int command_number;
        int tick_count;
        $ viewangles;
        $ aimdirection;
        float forwardmove;
        float sidemove;
        float upmove;
        int buttons;
        uint8_t impulse;
        int weaponselect;
        int weaponsubtype;
        int random_seed;
        short mousedx;
        short mousedy;
        bool hasbeenpredicted;
        $ headangles;
        $ headoffset;
        bool send_packet;
        int unknown_float2;
        int tickbase_shift;
        int unknown_float3;
        int unknown_float4;
    }
    ]],
    angle3d_struct,
    vec_struct,
    angle3d_struct,
    vec_struct
)

local client_sig = client.find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85") or error("client.dll!:input not found.")
local get_cUserCmd = ffi.typeof("$* (__thiscall*)(uintptr_t ecx, int nSlot, int sequence_number)", cUserCmd)
local input_vtbl = ffi.typeof([[struct{uintptr_t padding[8];$ GetUserCmd;}]],get_cUserCmd)
local input = ffi.typeof([[struct{$* vfptr;}*]], input_vtbl)
local get_input = ffi.cast(input,ffi.cast("uintptr_t**",tonumber(ffi.cast("uintptr_t", client_sig)) + 1)[0])

clipboard_import = function()
    local clipboard_text_length = get_clipboard_text_count(VGUI_System)
   
    if clipboard_text_length > 0 then
        local buffer = ffi.new("char[?]", clipboard_text_length)
        local size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)
   
        get_clipboard_text(VGUI_System, 0, buffer, size )
   
        return ffi.string( buffer, clipboard_text_length-1)
    end

    return ""
end

local function clipboard_export(string)
	if string then
		set_clipboard_text(VGUI_System, string, string:len())
	end
end

local last_sim_time = 0
local defensive_until = 0
local function is_defensive_active()
    local tickcount = globals.tickcount()
    local sim_time = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local sim_diff = sim_time - last_sim_time

    if sim_diff < 0 then
        defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
    end

    last_sim_time = sim_time

    return defensive_until > tickcount
end

local function is_vulnerable()
    for _, v in ipairs(entity.get_players(true)) do
        local flags = (entity.get_esp_data(v)).flags

        if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
            return true
        end
    end

    return false
end

contains = function(tbl, arg)
    for index, value in next, tbl do 
        if value == arg then 
            return true end 
        end 
    return false
end

local animations = {anim_list = {}}
animations.math_clamp = function(value, min, max) return math.min(max, math.max(min, value)) end
animations.math_lerp = function(a, b_, t) local t = animations.math_clamp(globals.frametime() * (0.045 * 175), 0, 1) if type(a) == 'userdata' then r, g, b, a = a.r, a.g, a.b, a.a e_r, e_g, e_b, e_a = b_.r, b_.g, b_.b, b_.a r = math_lerp(r, e_r, t) g = math_lerp(g, e_g, t) b = math_lerp(b, e_b, t) a = math_lerp(a, e_a, t) return color(r, g, b, a) end local d = b_ - a d = d * t d = d + a if b_ == 0 and d < 0.01 and d > -0.01 then d = 0 elseif b_ == 1 and d < 1.01 and d > 0.99 then d = 1 end return d end
animations.new = function(name, new, remove, speed) if not animations.anim_list[name] then animations.anim_list[name] = {} animations.anim_list[name].color = {0, 0, 0, 0} animations.anim_list[name].number = 0 animations.anim_list[name].call_frame = true end if remove == nil then animations.anim_list[name].call_frame = true end if speed == nil then speed = 0.010 end if type(new) == 'userdata' then lerp = animations.math_lerp(animations.anim_list[name].color, new, speed) animations.anim_list[name].color = lerp return lerp end lerp = animations.math_lerp(animations.anim_list[name].number, new, speed) animations.anim_list[name].number = lerp return lerp end

local function choking(cmd)
    local choke = false

    if cmd.allow_send_packet == false or cmd.chokedcommands > 1 then
        choke = true
    else
        choke = false
    end

    return choke
end

local rgba_to_hex = function(b, c, d, e)
    return string.format('%02x%02x%02x%02x', b, c, d, e)
end
local hex_to_rgba = function(hex)
    hex = hex:gsub('#', '')
    return tonumber('0x' .. hex:sub(1, 2)), tonumber('0x' .. hex:sub(3, 4)), tonumber('0x' .. hex:sub(5, 6)), tonumber('0x' .. hex:sub(7, 8)) or 255
end
function d_lerp(a, b, t)
    return a + (b - a) * t
end
function d_clamp(x, minval, maxval)
    if x < minval then
        return minval
    elseif x > maxval then
        return maxval
    else
        return x
    end
end

local function animated_text(x, y, speed, color1, color2, flags, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local x = i * 10  
        local wave = math.cos(1 * speed * curtime / 2 + x / 400)

        local color = rgba_to_hex(
            math.max(0, d_lerp(color1.r, color2.r, d_clamp(wave, 0, 1))),
            math.max(0, d_lerp(color1.g, color2.g, d_clamp(wave, 0, 1))),
            math.max(0, d_lerp(color1.b, color2.b, d_clamp(wave, 0, 1))),
            math.max(0, d_lerp(color1.a, color2.a, d_clamp(wave, 0, 1)))
        )
        final_text = final_text .. '\a' .. color .. text:sub(i, i) 
    end
    
    renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, flags, nil, final_text)
end

prevent_mouse = function(cmd)
    if ui.is_menu_open() then
        cmd.in_attack = false
    end
end

local printc do
    ffi.cdef[[
        typedef struct { uint8_t r; uint8_t g; uint8_t b; uint8_t a; } color_struct_t;
    ]]

	local print_interface = ffi.cast("void***", client.create_interface("vstdlib.dll", "VEngineCvar007"))
	local color_print_fn = ffi.cast("void(__cdecl*)(void*, const color_struct_t&, const char*, ...)", print_interface[0][25])

    -- 
    local hex_to_rgb = function (hex)
        return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16), tonumber(hex:sub(7, 8), 16)
    end
	
	local raw = function(text, r, g, b, a)
		local col = ffi.new("color_struct_t")
		col.r, col.g, col.b, col.a = r or 217, g or 217, b or 217, a or 255
	
		color_print_fn(print_interface, col, tostring(text))
	end

	printc = function (...)
		for i, v in ipairs{...} do
			local r = "\aD9D9D9"..v
			for col, text in r:gmatch("\a(%x%x%x%x%x%x)([^\a]*)") do
				raw(text, hex_to_rgb(col))
			end
		end
		raw "\n"
	end
end

in_bounds = function(x1, y1, x2, y2)
    mouse_x, mouse_y = ui.mouse_position()

    if (mouse_x > x1 and mouse_x < x2) and (mouse_y > y1 and mouse_y < y2) then
        return true
    end
    
    return false
end

function extrapolate_position(xpos,ypos,zpos,ticks,player)
    local x,y,z = entity.get_prop(player, "m_vecVelocity")
    for i = 0, ticks do
        xpos =  xpos + (x * globals.tickinterval())
        ypos =  ypos + (y * globals.tickinterval())
        zpos =  zpos + (z * globals.tickinterval())
    end
    return xpos,ypos,zpos
end

math.clamp = function(v, min, max)
    if min > max then min, max = max, min end
    if v > max then return max end
    if v < min then return v end
    return v
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

math.approach_angle = function(target, value, speed)
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

math.vec_length2d = function(vec)
    root = 0.0
    sqst = vec.x * vec.x + vec.y * vec.y
    root = math.sqrt(sqst)
    return root
end

function samdadn(ent, tbl, array)
    local x, y, z = entity.get_prop(ent, tbl, (array or nil))
    return {x = x, y = y, z = z}
end

function globals.is_connected()
    local lp = entity.get_local_player()

    if lp ~= nil and lp > 0 then return false
        else return true end
end

local entity_list_ptr = ffi.cast("void***", client.create_interface("client.dll",
                                                                 "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("GetClientEntityHandle_4242425_t",
                                      entity_list_ptr[0][3])
local get_client_entity_by_handle_fn = ffi.cast(
                                           "GetClientEntityHandle_4242425_t",
                                           entity_list_ptr[0][4])

entity.get_address = function(idx)
    return get_client_entity_fn(entity_list_ptr, idx)
end

entity.get_animstate = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("struct c_animstate**", addr + 0x9960)[0]
end

entity.get_animlayer = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end

    return ffi.cast("C_AnimationLayer**", ffi.cast('uintptr_t', addr) + 0x9960)[0]
end

renderer.circle_3d = function(pos, radius, start_at, percentage, segment, filled, r, g, b, a)
    local x, y, z = pos.x, pos.y, pos.z
    local old_x, old_y
    local end_at = math.floor(percentage * 360)
    local degrees = end_at - start_at
    local step = degrees / segment

    for rot = start_at, end_at, step do
        local rot_r = rot * (math.pi / 180)
        local line_x = radius * math.cos(rot_r) + x
        local line_y = radius * math.sin(rot_r) + y

        local curr = { renderer.world_to_screen(line_x, line_y, z) }
        local cur = { renderer.world_to_screen(x, y, z) }

        if curr[1] ~= nil and curr[2] ~= nil and old_x ~= nil then
            if filled then
                renderer.triangle(curr[1], curr[2], old_x, old_y, cur[1], cur[2], r, g, b, a)
            else
                renderer.line(curr[1], curr[2], old_x, old_y, r, g, b, a)
            end
        end

        old_x, old_y = curr[1], curr[2]
    end
end

nigger = function(val)
    if val < 0 then
        return val*-1
    else
        return val
    end
end

local degree_to_radian = function(degree)
	return (math.pi / 180) * degree
end

local angle_to_vector = function(x, y)
	local pitch = degree_to_radian(x)
	local yaw = degree_to_radian(y)
	return math.cos(pitch) * math.cos(yaw), math.cos(pitch) * math.sin(yaw), -math.sin(pitch)
end

local set_movement = function(cmd, desired_pos)
    local local_player = entity.get_local_player()
	local vec_angles = {
		vector(
			entity.get_origin( local_player )
		):to(
			desired_pos
		):angles()
	}

    local pitch, yaw = vec_angles[1], vec_angles[2]

    cmd.in_forward = 1
    cmd.in_back = 0
    cmd.in_moveleft = 0
    cmd.in_moveright = 0
    cmd.in_speed = 0
    cmd.forwardmove = 800
    cmd.sidemove = 0
    cmd.move_yaw = yaw
end

local function clamp(num, min, max)
    if num < min then
        num = min
    elseif num > max then
        num = max
    end

    return num
end

local function TIME_TO_TICKS( time )
    local t_Return = time / globals.tickinterval()
    return math.floor(t_Return)
end

local function calc_lerp()
	local update_rate = clamp( cvar.cl_updaterate:get_float(), cvar.sv_minupdaterate:get_float(), cvar.sv_maxupdaterate:get_float() )
	local lerp_ratio = clamp( cvar.cl_interp_ratio:get_float(), cvar.sv_client_min_interp_ratio:get_float(), cvar.sv_client_max_interp_ratio:get_float() )
  
	return clamp( lerp_ratio / update_rate, cvar.cl_interp:get_float(), 6 )
end

local function player()
    local enemies = entity.get_players(true)

    for itter = 1, #enemies do
        i = enemies[itter]
    end

    if i == nil then i = 0 end
    
    return i
end

function animation_layer_t_struct(_Entity)
    if not (_Entity) then
        return
    end
    local player_ptr = ffi.cast( "void***", get_client_entity(ientitylist, _Entity))
    local animstate_ptr = ffi.cast( "char*" , player_ptr ) + 0x9960
    local state = ffi.cast( "struct animation_layer_t**", animstate_ptr )[0]

    return state
end

local function hook_value(buf)
    local ptr = ffi.cast("uintptr_t",ffi.cast("unsigned long", buf))
    local ptr_s = ffi.cast("uintptr_t", ffi.cast(ptr, client_sig))
    local result_hook = tonumber(ptr_s)
    return result_hook
end

local function getspeed(player_index)
    return vector(entity.get_prop(player_index, "m_vecVelocity")):length()
end

local limiter = function(limit_min, value_to_limit, limit_max)
    if value_to_limit > limit_max then
        return limit_max
    elseif value_to_limit < limit_min then
        return limit_min
    elseif value_to_limit < limit_max then
        return value_to_limit
    elseif value_to_limit > limit_min then
        return value_to_limit
    end
end

local renderer_gs_rect_with_text = function(x, y, text, flags, centered, r, g, b, a)

    local do_centered = centered and renderer.measure_text(flags, text)/2 or 0

    renderer.rectangle((x) - 7 - do_centered, y - 7, renderer.measure_text(flags, text) + 14, 27, 0,0,0,255)
    renderer.rectangle((x) - 6 - do_centered, y - 6, renderer.measure_text(flags, text) + 12, 25, 66,66,66,255)
    renderer.rectangle((x) - 5 - do_centered, y - 5, renderer.measure_text(flags, text) + 10, 23, 41,41,41,255)
    renderer.rectangle((x) - 4 - do_centered, y - 4, renderer.measure_text(flags, text) + 8, 21, 66,66,66,255)
    renderer.rectangle((x) - 3 - do_centered, y - 3, renderer.measure_text(flags, text) + 6, 19, 18,18,18,255)

    renderer.rectangle((x) - 3 - do_centered, y - 3, renderer.measure_text(flags, text) + 6, 19, 18,18,18,255)
    renderer.rectangle((x) - 3 - do_centered, y - 3, renderer.measure_text(flags, text) + 6, 1, r,g,b,a)

    renderer.text(x - do_centered, y, 255, 255, 255, 255, flags, 0, text)
end

-- { images }
-- background
http.get("http://cloudpusy.ct8.pl/loader/gamesensetools/gst_menu_background.png", function(success, response) if not success or response.status ~= 200 then print("couldnt fetch the image") return end writefile("gst_menu_background.png", response.body) end)
-- Ragebot
http.get("http://cloudpusy.ct8.pl/loader/gamesensetools/gst_menu_icon_ragebot.png", function(success, response) if not success or response.status ~= 200 then print("couldnt fetch the image") return end writefile("gst_menu_icon_ragebot.png", response.body) end)
-- Antiaim
http.get("http://cloudpusy.ct8.pl/loader/gamesensetools/gst_menu_icon_antiaim.png", function(success, response) if not success or response.status ~= 200 then print("couldnt fetch the image") return end writefile("gst_menu_icon_antiaim.png", response.body) end)
-- Visuals
http.get("http://cloudpusy.ct8.pl/loader/gamesensetools/gst_menu_icon_visuals.png", function(success, response) if not success or response.status ~= 200 then print("couldnt fetch the image") return end writefile("gst_menu_icon_visuals.png", response.body) end)
-- Other
http.get("http://cloudpusy.ct8.pl/loader/gamesensetools/gst_menu_icon_other.png", function(success, response) if not success or response.status ~= 200 then print("couldnt fetch the image") return end writefile("gst_menu_icon_other.png", response.body) end)
-- taser icon
http.get("http://cloudpusy.ct8.pl/loader/gamesensetools/taser_icon.png", function(success, response) if not success or response.status ~= 200 then print("couldnt fetch the image") return end writefile("taser_icon.png", response.body) end)


local menu_background = renderer.load_png(readfile("gst_menu_background.png"), 531, 130)
local menu_icon_ragebot = renderer.load_png(readfile("gst_menu_icon_ragebot.png"), 531, 130)
local menu_icon_antiaim = renderer.load_png(readfile("gst_menu_icon_antiaim.png"), 531, 130)
local menu_icon_visuals = renderer.load_png(readfile("gst_menu_icon_visuals.png"), 531, 130)
local menu_icon_other = renderer.load_png(readfile("gst_menu_icon_other.png"), 531, 130)

local obex_data = obex_fetch and obex_fetch() or {username = "admin"}
local build = "\aDB90E2FFalpha\affffffff"

local selected_tab, hovered_tab, clr_ragebot, clr_antiaim, clr_visuals, clr_other, rect_pos_x = nil, nil, 90, 90, 90, 90, client.screen_size()/2 - 500/2
local aa_state = {[1] = "Global", [2] = "Standing", [3] = "Moving", [4] = "In air", [5] = "In air-crouch", [6] = "Crouch", [7] = "Slow walk"}
local tables = {notify = {}}
local vars = {
    simtime_backup = 0,     
    shot_time = 0,
    in_attack = 0,
    last_press_t = globals.curtime()
}

pui.accent = "9DDB64FF"
--"DB90E2FF"

--{{ script ui }}
local group = pui.group("aa","anti-aimbot angles")
local _ui = {
    lua = {
        enable = group:checkbox("\vgamesense\r.tools"),
        tab = group:combobox("tab", "Ragebot", "Antiaim", "Visuals", "Other"),
        --group:label("   ")
    },
    
    start = {
        group:label("   "),
        hello_im_braindead = group:label(" \a5F5F5FFF»  \rHello,  \aFFFFFFFF"..obex_data.username),
        look_i_shit_myself = group:label(" \a5F5F5FFF»  \rScript build: "..build),
        my_iq_is_lower_then_my_age = group:label(" \a5F5F5FFF»  \rScript version: \aFFFFFFFF 1.0"),
        group:label(" "),
        anal_boom_warning = group:label("\aD69D47FF{!}  \rIf icons didnt loaded"),
        anal_boom_warning2 = group:label("       reload the script."),
    },

    ragebot = {
        group:label("\a515151FF—  Tweaks"),
        resolver = group:checkbox("\aDB90E2FF{alpha} \rResolver"),
        defensive_aa_resolver = group:checkbox("Defensive anti-aim resolver"),
        group:label("\a515151FF—  Other"),
        shot_logs = group:checkbox("Aimbot logs"),
        peekbot = group:checkbox("Peek bot"),
        peekbot_bind = group:hotkey("Peek bot bind"),
        peekbot_distance = group:slider("Tracing distance", 30, 100, 60),
        peekbot_visualize = group:checkbox("Renderer trace positions"),
        group:label("\a515151FF—  Exploits & Unsafe"),
        backtrack_exploit = group:checkbox("Backtrack exploit"),
    },

    antiaim = {
        _global = {
            autismus = group:label("\a515151FF—  Main"),
            enable = group:checkbox("Enable"),
            tab = group:combobox("\n  ", "Anti-aim builder", "Anti-aim settings")
        },

        builder = {
            group:label("\a515151FF—  Builder"),
            condition = group:combobox("Player condition", aa_state)
        },

        settings = {
            group:label("\a515151FF—  Tweaks"),
            backstab = group:checkbox("Backstab protection"),
            safehead = group:checkbox("Safehead"),
            fakelag_on_shot = group:checkbox("Modify onshot fakelag"),
            --group:label(" ")
        },

        binds = {
            group:label("\a515151FF—  Keybinds"),
            freestanding = group:hotkey("\a5F5F5FFF»  \rFreestanding"),
            edge_yaw = group:hotkey("\a5F5F5FFF»  \rEdge yaw"),
            manual_right = group:hotkey("\a5F5F5FFF»  \rManual right"),
            manual_left = group:hotkey("\a5F5F5FFF»  \rManual left"),
            peek_baiter = group:hotkey("\a5F5F5FFF»  \rPeek baiter"),
        },

        configs = {
            --group:label(" "),
            group:label("\a515151FF—  Configs"),
            cfg_export = group:button("Export anti-aim settings", function() config.export() end),
            cfg_import = group:button("Import anti-aim settings", function() config.import() end)
        }
    },

    visuals = {
        group:label("\a515151FF—  Global"),
        accent_color = group:label("Accent color", {hex_to_rgba(pui.accent)}),
        group:label("\a515151FF—  Indication"),
        watermark_mode = group:combobox("Watermark style", "Simple", "Detailed"),
        watermark_pos = group:combobox("Watermark position", "Left", "Bottom"),
        indicators = group:checkbox("Crosshair indicators"),
        indicators_elements = group:multiselect("  \a5F5F5FFF»  \rElements", "Player state", "Desync side", "Binds"),
        indicators_binds = group:multiselect("  \a5F5F5FFF»  \rBinds", "Double tap", "Hide shots", "Damage override", "Quick peek", "Freestanding", "Edgeyaw", "Fakeduck"),
        indicators_scope = group:combobox("  \a5F5F5FFF»  \rScope position modifier", "Off", "Right", "Left"),
        taser_warning = group:checkbox("Taser warning"),
        group:label("\a515151FF—  Player"),
        tracer = group:checkbox("Target tracer", {255,255,255,255})
    },

    other = {
        group:label("\a515151FF—  Miscellaneous"),
        auto_teleport = group:checkbox("Automatic teleport"),
        console_filter = group:checkbox("Console filter"),
        clantag = group:checkbox("Clantag"),
        shit_talk = group:checkbox("Shit-talking"),
        st_mode = group:combobox("  \a5F5F5FFF»  \rMode", "[RU] Aggressive", "[RU] Retarded", "[ENG] Aggressive", "[CN] Aggressive"),
        st_revenge = group:checkbox("  \a5F5F5FFF»  \rRevenge"),
        anim_breakers_enable = group:checkbox("Animation breakers"),
        anim_breakers = group:multiselect("\n        ", "Legs", "Landing"),
        anim_breakers_move = group:combobox("Moving legs type", "-", "Static", "Walking"),
        anim_breakers_air = group:combobox("In air legs type", "-", "Static", "Walking"),
    }
}

aa_builder = {}

for i = 1, 7 do
    aa_builder[i] = {}
    aa_builder[i].override = group:checkbox("Override \v"..aa_state[i].."\r condition")
    aa_builder[i].yaw_value = group:slider("\v"..aa_state[i].."  \a5F5F5FFF»\r  Yaw value", -180, 180, 0)
    aa_builder[i].yaw_modifier = group:combobox("\v"..aa_state[i].."  \a5F5F5FFF»\r  Yaw modifier", "Off", "Center", "Random", "3-Way", "5-Way", "Delayed")
    aa_builder[i].yaw_modifier_value = group:slider("\v"..aa_state[i].."  \a5F5F5FFF»\r  Yaw modifier value", -180, 180, 0)
    aa_builder[i].yaw_modifier_delay_value = group:slider("\v"..aa_state[i].."  \a5F5F5FFF»\r  Yaw modifier delay", 2, 20, 9)
    aa_builder[i].body_yaw = group:combobox("\v"..aa_state[i].."  \a5F5F5FFF»\r  Body yaw", "Off", "Opposite", "Jitter", "Static", "Delayed jitter", "Experimental")
    aa_builder[i].body_yaw_side = group:combobox("\v"..aa_state[i].."  \a5F5F5FFF»\r  Body yaw side", "Default", "Left", "Right")
    aa_builder[i].body_yaw_delay_value = group:slider("\v"..aa_state[i].."  \a5F5F5FFF»\r  Body yaw delay", 2, 20, 9)
    aa_builder[i].freestand_body_yaw = group:checkbox("\v"..aa_state[i].."  \a5F5F5FFF»\r  Freestanding body yaw")

    aa_builder[i].defensive_modifiers = group:checkbox("\v"..aa_state[i].."  \a5F5F5FFF»\r  Defensive modifiers")
    aa_builder[i].force_defensive = group:checkbox("\v"..aa_state[i].."  \a5F5F5FFF»\r  Force defensive")
    aa_builder[i].defensive_antiaim = group:combobox("\v"..aa_state[i].."  \a5F5F5FFF»\r  Defensive antiaim", "Off", "Spin", "Random", "Custom")

    aa_builder[i].defensive_pitch = group:combobox("\v"..aa_state[i].."  \a5F5F5FFF»\r  Defensive pitch", "Off", "Custom", "Random")
    aa_builder[i].defensive_pitch_value = group:slider("\v"..aa_state[i].."  \a5F5F5FFF»\r  Defensive pitch value", -89, 89, 0)
    aa_builder[i].defensive_yaw_mode = group:combobox("\v"..aa_state[i].."  \a5F5F5FFF»\r  Defensive yaw mode", "180", "Spin")
    aa_builder[i].defensive_yaw_value = group:slider("\v"..aa_state[i].."  \a5F5F5FFF»\r  Defensive yaw value", -180, 180, 0)
    aa_builder[i].defensive_yaw_modifier = group:combobox("\v"..aa_state[i].."  \a5F5F5FFF»\r  Defensive yaw modifier", "Off", "Center", "Random", "3-way", "5-way", "Delayed")
    aa_builder[i].defensive_yaw_modifier_value = group:slider("\v"..aa_state[i].."  \a5F5F5FFF»\r  Defensive yaw modifier value", -180, 180, 0)
    aa_builder[i].defensive_yaw_modifier_delay_value = group:slider("\v"..aa_state[i].."  \a5F5F5FFF»\r  Defensive Yaw modifier delay", 2, 20, 9)
    aa_builder[i].defensive_body_yaw = group:combobox("\v"..aa_state[i].."  \a5F5F5FFF»\r  Defensive body yaw", "Off", "Opposite", "Jitter", "Static", "Delayed jitter", "Experimental")
    aa_builder[i].defensive_body_yaw_side = group:combobox("\v"..aa_state[i].."  \a5F5F5FFF»\r  Defensive body yaw side", "Default", "Left", "Right")
    aa_builder[i].defensive_body_yaw_delay_value = group:slider("\v"..aa_state[i].."  \a5F5F5FFF»\r  Defensive Body yaw delay", 2, 20, 9)
end

-- { visiblity }
local visiblity = function()
    for i, v in pairs(_ui.start) do ui.set_visible(v.ref, (selected_tab == nil and _ui.lua.enable.value) and true or false) end
    for i, v in pairs(_ui.ragebot) do ui.set_visible(v.ref, (selected_tab == "Ragebot" and _ui.lua.enable.value) and true or false) end
    for i, v in pairs({_ui.ragebot.peekbot_bind.ref, _ui.ragebot.peekbot_distance.ref, _ui.ragebot.peekbot_visualize.ref}) do ui.set_visible(v, (selected_tab == "Ragebot" and _ui.lua.enable.value and _ui.ragebot.peekbot.value) and true or false) end
    for i, v in pairs(_ui.antiaim._global) do ui.set_visible(v.ref, (selected_tab == "Antiaim" and _ui.lua.enable.value and _ui.antiaim._global.enable.value) and true or false) end
    for i, v in pairs(_ui.antiaim.builder) do ui.set_visible(v.ref, (selected_tab == "Antiaim" and _ui.antiaim._global.tab.value == "Anti-aim builder" and _ui.lua.enable.value and _ui.antiaim._global.enable.value) and true or false) end
    for i, v in pairs(_ui.antiaim.settings) do ui.set_visible(v.ref, (selected_tab == "Antiaim" and _ui.antiaim._global.tab.value == "Anti-aim settings" and _ui.lua.enable.value and _ui.antiaim._global.enable.value) and true or false) end
    for i, v in pairs(_ui.antiaim.binds) do ui.set_visible(v.ref, (selected_tab == "Antiaim" and _ui.antiaim._global.tab.value == "Anti-aim settings" and _ui.lua.enable.value and _ui.antiaim._global.enable.value) and true or false) end
    for i, v in pairs(_ui.antiaim.configs) do ui.set_visible(v.ref, (selected_tab == "Antiaim" and _ui.antiaim._global.tab.value == "Anti-aim settings" and _ui.lua.enable.value and _ui.antiaim._global.enable.value) and true or false) end
    for i, v in pairs(_ui.visuals) do ui.set_visible(v.ref, (selected_tab == "Visuals" and _ui.lua.enable.value) and true or false) end
    for i, v in pairs(_ui.other) do ui.set_visible(v.ref, (selected_tab == "Other" and _ui.lua.enable.value) and true or false) end
    for i, v in pairs({_ui.other.anim_breakers.ref, _ui.other.anim_breakers_move.ref, _ui.other.anim_breakers_air.ref}) do ui.set_visible(v, (selected_tab == "Other" and _ui.lua.enable.value and _ui.other.anim_breakers_enable.value) and true or false) end

    for i = 1, 7 do
        local req = _ui.lua.enable.value and selected_tab == "Antiaim" and _ui.antiaim._global.enable.value and _ui.antiaim._global.tab.value == "Anti-aim builder" and aa_builder[i].override.value and _ui.antiaim.builder.condition.value == aa_state[i]

        for i, v in pairs({aa_builder[i].override.ref, aa_builder[i].yaw_value.ref, aa_builder[i].yaw_modifier.ref, aa_builder[i].body_yaw.ref, aa_builder[i].defensive_modifiers.ref}) do
            ui.set_visible(v, req)
        end

        ui.set_visible(aa_builder[i].yaw_modifier_value.ref, req and aa_builder[i].yaw_modifier.value ~= "Off")
        ui.set_visible(aa_builder[i].body_yaw_side.ref, req and not ((aa_builder[i].body_yaw.value == "Delayed jitter") or (aa_builder[i].body_yaw.value == "Experimental") or (aa_builder[i].body_yaw.value == "Off") or (aa_builder[i].body_yaw.value == "Opposite")))
        ui.set_visible(aa_builder[i].freestand_body_yaw.ref, req and aa_builder[i].body_yaw.value ~= "Off" and aa_builder[i].body_yaw.value ~= "Experimental" and aa_builder[i].body_yaw.value ~= "Delayed jitter")
        ui.set_visible(aa_builder[i].force_defensive.ref, req and aa_builder[i].defensive_modifiers.value)
        ui.set_visible(aa_builder[i].defensive_antiaim.ref, req and aa_builder[i].defensive_modifiers.value)

        ui.set_visible(aa_builder[i].yaw_modifier_delay_value.ref, req and aa_builder[i].yaw_modifier.value == "Delayed")
        ui.set_visible(aa_builder[i].body_yaw_delay_value.ref, req and aa_builder[i].body_yaw.value == "Delayed jitter")

        ui.set_visible(aa_builder[i].defensive_pitch.ref, req and aa_builder[i].defensive_modifiers.value and aa_builder[i].defensive_antiaim.value == "Custom")
        ui.set_visible(aa_builder[i].defensive_pitch_value.ref, req and aa_builder[i].defensive_modifiers.value and aa_builder[i].defensive_antiaim.value == "Custom" and aa_builder[i].defensive_pitch.value == "Custom")
        ui.set_visible(aa_builder[i].defensive_yaw_mode.ref, req and aa_builder[i].defensive_modifiers.value and aa_builder[i].defensive_antiaim.value == "Custom")
        ui.set_visible(aa_builder[i].defensive_yaw_value.ref, req and aa_builder[i].defensive_modifiers.value and aa_builder[i].defensive_antiaim.value == "Custom")
        ui.set_visible(aa_builder[i].defensive_yaw_modifier.ref, req and aa_builder[i].defensive_modifiers.value and aa_builder[i].defensive_antiaim.value == "Custom")
        ui.set_visible(aa_builder[i].defensive_yaw_modifier_value.ref, req and aa_builder[i].defensive_modifiers.value and aa_builder[i].defensive_antiaim.value == "Custom" and aa_builder[i].defensive_yaw_modifier.value ~= "Off")
        ui.set_visible(aa_builder[i].defensive_yaw_modifier_delay_value.ref, req and aa_builder[i].defensive_modifiers.value and aa_builder[i].defensive_antiaim.value == "Custom" and aa_builder[i].defensive_yaw_modifier.value == "Delayed")
        ui.set_visible(aa_builder[i].defensive_body_yaw.ref, req and aa_builder[i].defensive_modifiers.value and aa_builder[i].defensive_antiaim.value == "Custom")
        ui.set_visible(aa_builder[i].defensive_body_yaw_side.ref, req and aa_builder[i].defensive_modifiers.value and aa_builder[i].defensive_antiaim.value == "Custom" and not ((aa_builder[i].defensive_body_yaw.value == "Delayed jitter") or (aa_builder[i].defensive_body_yaw.value == "Experimental") or (aa_builder[i].defensive_body_yaw.value == "Off") or (aa_builder[i].defensive_body_yaw.value == "Opposite")))
        ui.set_visible(aa_builder[i].defensive_body_yaw_delay_value.ref, req and aa_builder[i].defensive_modifiers.value and aa_builder[i].defensive_antiaim.value == "Custom" and aa_builder[i].defensive_body_yaw.value == "Delayed jitter")
    end
    for i = 2, 7 do ui.set_visible(aa_builder[i].override.ref, _ui.lua.enable.value and selected_tab == "Antiaim" and _ui.antiaim._global.enable.value and _ui.antiaim._global.tab.value == "Anti-aim builder" and _ui.antiaim.builder.condition.value == aa_state[i]) end ui.set_visible(aa_builder[1].override.ref, false) ui.set(aa_builder[1].override.ref, true)

    ui.set_visible(_ui.visuals.accent_color.color.ref, selected_tab == "Visuals" and _ui.lua.enable.value)
    ui.set_visible(_ui.visuals.tracer.color.ref, selected_tab == "Visuals" and _ui.lua.enable.value)
    ui.set_visible(_ui.other.st_mode.ref, selected_tab == "Other" and _ui.lua.enable.value and _ui.other.shit_talk.value)
    ui.set_visible(_ui.other.st_revenge.ref, selected_tab == "Other" and _ui.lua.enable.value and _ui.other.shit_talk.value)
    ui.set_visible(_ui.other.anim_breakers_move.ref, selected_tab == "Other" and _ui.lua.enable.value and _ui.other.anim_breakers_enable.value and contains(_ui.other.anim_breakers.value, "Legs"))
    ui.set_visible(_ui.other.anim_breakers_air.ref, selected_tab == "Other" and _ui.lua.enable.value and _ui.other.anim_breakers_enable.value and contains(_ui.other.anim_breakers.value, "Legs"))

    ui.set_visible(_ui.visuals.watermark_pos.ref, selected_tab == "Visuals" and _ui.lua.enable.value and _ui.visuals.watermark_mode.value == "Simple")
    ui.set_visible(_ui.visuals.indicators_elements.ref, selected_tab == "Visuals" and _ui.lua.enable.value and _ui.visuals.indicators.value)
    ui.set_visible(_ui.visuals.indicators_scope.ref, selected_tab == "Visuals" and _ui.lua.enable.value and _ui.visuals.indicators.value)
    ui.set_visible(_ui.visuals.indicators_binds.ref, selected_tab == "Visuals" and _ui.lua.enable.value and _ui.visuals.indicators.value and contains(_ui.visuals.indicators_elements.value, "Binds"))

    ui.set_visible(_ui.lua.tab.ref, false)
    ui.set_visible(_ui.antiaim._global.enable.ref, selected_tab == "Antiaim" and _ui.lua.enable.value)
    ui.set_visible(_ui.antiaim._global.autismus.ref, selected_tab == "Antiaim" and _ui.lua.enable.value)
end

local hide_refs = function(value)
    value = not value
    ui.set_visible(ref.aa_enable, value) ui.set_visible(ref.pitch, value) ui.set_visible(ref.pitch_value, value)
    ui.set_visible(ref.yaw_base, value) ui.set_visible(ref.yaw, value) ui.set_visible(ref.yaw_value, value)
    ui.set_visible(ref.yaw_jitter, value) ui.set_visible(ref.yaw_jitter_value, value) ui.set_visible(ref.body_yaw, value)
    ui.set_visible(ref.body_yaw_side, value) ui.set_visible(ref.edgeyaw, value) ui.set_visible(ref.freestand[1], value)
    ui.set_visible(ref.freestand[2], value) ui.set_visible(ref.roll, value) ui.set_visible(ref.freestand_body_yaw, value)
end

-- {{ configs }}

local config_items = {
    _ui.antiaim._global,
    _ui.antiaim.builder,
    _ui.antiaim.settings,
    aa_builder,
}

local package, data, encrypted, decrypted = pui.setup(config_items), "", "", ""
config = {}

config.export = function()
    data = package:save()
    encrypted = base64.encode(json.stringify(data))
    clipboard_export(encrypted)

    setup_notification("Antiaim settings exported", false)
end

config.import = function(input)
    decrypted = json.parse(base64.decode(input ~= nil and input or clipboard_import()))
    package:load(decrypted)

    print(package:load(decrypted))

    setup_notification("Antiaim settings loaded", false)
end

-- {{ notifications }}

setup_notification = function(str, is_warning_or_i_should_kill_my_self)
    table.insert(tables.notify, {
        string = str,

        timer = 0,
        alpha = 0,
        is_warning = is_warning_or_i_should_kill_my_self
    })
end

local renderer_notification = function()
    local add_y = 0
    local x, y = client.screen_size()
    local frametime = globals.frametime() * 100
    local position_x = x/2
    local position_y = y/2 + 150
    local color = {_ui.visuals.accent_color.color:get()}

    for i, v in ipairs(tables.notify) do
        local clr_r, clr_g, clr_b = v.is_warning and 255 or color[1] , v.is_warning and 103 or color[2], v.is_warning and 103 or color[3]
        v.timer = v.timer + (0.19*vector(renderer.measure_text(nil, v.string)).x*0.0115)*frametime

        if math.max(0,(renderer.measure_text(nil, v.string) + 1 - v.timer)) > 0 then
            v.alpha = animations.math_lerp(v.alpha, 1, frametime)
        end
    
        renderer.rectangle((position_x - renderer.measure_text(nil, v.string)/2) - 7, (position_y + add_y) - 7, renderer.measure_text(nil, v.string) + 13, 27, 0,0,0,v.alpha*255)
        renderer.rectangle((position_x - renderer.measure_text(nil, v.string)/2) - 6, (position_y + add_y) - 6, renderer.measure_text(nil, v.string) + 11, 25, 66,66,66,v.alpha*255)
        renderer.rectangle((position_x - renderer.measure_text(nil, v.string)/2) - 5, (position_y + add_y) - 5, renderer.measure_text(nil, v.string) + 9, 23, 41,41,41,v.alpha*255)
        renderer.rectangle((position_x - renderer.measure_text(nil, v.string)/2) - 4, (position_y + add_y) - 4, renderer.measure_text(nil, v.string) + 7, 21, 66,66,66,v.alpha*255)

        renderer.rectangle((position_x - renderer.measure_text(nil, v.string)/2) - 3, (position_y + add_y) - 3, renderer.measure_text(nil, v.string) + 5, 19, 18,18,18,v.alpha*255)

        renderer.rectangle((position_x - renderer.measure_text(nil, v.string)/2) - 3, (position_y + add_y) - 3, renderer.measure_text(nil, v.string) + 5, 1, 0,0,0,v.alpha*255)
        renderer.rectangle((position_x - renderer.measure_text(nil, v.string)/2) - 3, (position_y + add_y) - 3, math.max(0,(renderer.measure_text(nil, v.string) + 1 - v.timer)), 1, clr_r ,clr_g ,clr_b ,v.alpha*255)

        --renderer.text(position_x - renderer.measure_text(nil,  "gs.tools   » ")/2 - renderer.measure_text(nil, v.string)/2, position_y + add_y, clr_r, clr_g, clr_b, v.alpha*255, nil, 0, "gs.tools  »")
        renderer.text(position_x - renderer.measure_text(nil, v.string)/2 - 1, position_y + add_y, 255, 255, 255, v.alpha*255, "nil", 0, v.string)

        if math.max(0,(renderer.measure_text(nil, v.string) + 1 - v.timer)) == 0 or #tables.notify > 7 then
            v.alpha = animations.math_lerp(v.alpha, 0, frametime)
        end

        if v.alpha < 0.01 or #tables.notify > 7 then
            table.remove(tables.notify, i)
        end

        add_y = math.floor(add_y + 30 * v.alpha)
    end
end

local menu_alpha = 255
local menu_timer = 0
local anims_m = {menu = 0, menu_tab = 0, menu_alpha = 0, menu_alpha_additional = 0}
local custom_menu_control = function()
    local is_ui_open = ui.is_menu_open()
    local frametime = globals.frametime() * 15

    anims_m.menu = d_lerp(anims_m.menu, (is_ui_open and _ui.lua.enable.value) and 0 or 140, frametime)
    anims_m.menu_tab = d_lerp(anims_m.menu_tab, rect_pos_x, frametime)
    anims_m.menu_alpha = d_lerp(anims_m.menu_alpha, menu_alpha, frametime)
    anims_m.menu_alpha_additional = d_lerp(anims_m.menu_alpha_additional, menu_alpha < 100 and 25 or 0, frametime)

    if anims_m.menu > 138 then return end

    local x, y = client.screen_size()
    menu_timer = ((anims_m.menu < 130) and not in_bounds(x/2 - 267, y - 137 + anims_m.menu, x/2 + 525/2, y - 6)) and menu_timer + 1 or 0
    menu_alpha = menu_timer > 500 and 35 or 255
    
    if in_bounds(x/2 - 522/2, y - 130, x/2 - 253/2, y - 14) then
        hovered_tab = "Ragebot"
        if selected_tab ~= "Ragebot" then
            clr_ragebot = 167
        end

        if client.key_state(0x01) then
            selected_tab = "Ragebot"
            clr_ragebot = 209
            
            rect_pos_x = x/2 - 500/2
        end
    elseif (selected_tab ~= "Ragebot") then
        clr_ragebot = 90
    end

    if in_bounds(x/2 - 253/2, y - 130, x/2 - 5/2, y - 14) then
        hovered_tab = "Antiaim"
        if selected_tab ~= "Antiaim" then
            clr_antiaim = 167
        end

        if client.key_state(0x01) then
            selected_tab = "Antiaim"
            clr_antiaim = 209
                        
            rect_pos_x = x/2 - 243/2
        end
    elseif (selected_tab ~= "Antiaim") then
        clr_antiaim = 90
    end

    if in_bounds(x/2 - 5/2, y - 130, x/2 + 257/2, y - 14) then
        hovered_tab = "Visuals"
        if selected_tab ~= "Visuals" then
            clr_visuals = 167
        end
        
        if client.key_state(0x01) then
            selected_tab = "Visuals"
            clr_visuals = 209
                        
            rect_pos_x = x/2 + 13/2
        end
    elseif (selected_tab ~= "Visuals") then
        clr_visuals = 90
    end

    if in_bounds(x/2 + 257/2, y - 130, x/2 + 512/2, y - 14) then
        hovered_tab = "Other"
        if selected_tab ~= "Other" then
            clr_other = 167
        end

        if client.key_state(0x01) then
            selected_tab = "Other"
            clr_other = 209
                        
            rect_pos_x = x/2 + 268/2
        end
    elseif (selected_tab ~= "Other")then
        clr_other = 90
    end

    renderer.rectangle(x/2 - 515/2 - 7, y - 135 + anims_m.menu, 529, 129, 0, 0, 0,  anims_m.menu_alpha - (anims_m.menu_alpha_additional/2))
    renderer.rectangle(x/2 - 515/2 - 6, y - 134 + anims_m.menu, 527, 127, 66,66,66, anims_m.menu_alpha - (anims_m.menu_alpha_additional/2))
    renderer.rectangle(x/2 - 515/2 - 5, y - 133 + anims_m.menu, 525, 125, 40,40,40, anims_m.menu_alpha - (anims_m.menu_alpha_additional/2))
    renderer.rectangle(x/2 - 515/2 - 4, y - 132 + anims_m.menu, 523, 123, 41,41,41, anims_m.menu_alpha - (anims_m.menu_alpha_additional/2))
    renderer.rectangle(x/2 - 515/2 - 3, y - 131 + anims_m.menu, 521, 121, 40,40,40, anims_m.menu_alpha - (anims_m.menu_alpha_additional/2))
    renderer.rectangle(x/2 - 515/2 - 2, y - 130 + anims_m.menu, 519, 119, 66,66,66, anims_m.menu_alpha - (anims_m.menu_alpha_additional/2))
    renderer.rectangle(x/2 - 515/2 - 1, y - 129 + anims_m.menu, 517, 117, 33,33,33, anims_m.menu_alpha - (anims_m.menu_alpha_additional/2))
    renderer.rectangle(x/2 - 515/2, y - 128 + anims_m.menu, 515, 115, 12,12,12, anims_m.menu_alpha - (anims_m.menu_alpha_additional/2))

    if rect_pos_x then
        renderer.rectangle(anims_m.menu_tab - 1, y - 129 + anims_m.menu, 117, 118, 66,66,66, selected_tab ~= nil and anims_m.menu_alpha or 0)
        renderer.texture(menu_background, anims_m.menu_tab, y - 130 + anims_m.menu, 115, 119, 255, 255, 255, selected_tab ~= nil and anims_m.menu_alpha - anims_m.menu_alpha_additional or 0, "f")
    end

    renderer.texture(menu_icon_ragebot, x/2 - 470/2, y - 113 + anims_m.menu, 85, 85, clr_ragebot, clr_ragebot, clr_ragebot, anims_m.menu_alpha, "f")
    renderer.texture(menu_icon_antiaim, x/2 - 260/2 + 23, y - 113 + anims_m.menu, 85, 85, clr_antiaim, clr_antiaim, clr_antiaim, anims_m.menu_alpha, "f")
    renderer.texture(menu_icon_visuals, x/2 - 50/2 + 46, y - 113 + anims_m.menu, 85, 85, clr_visuals, clr_visuals, clr_visuals, anims_m.menu_alpha, "f")
    renderer.texture(menu_icon_other, x/2 + 167/2 + 66, y - 113 + anims_m.menu, 85, 85, clr_other, clr_other, clr_other, anims_m.menu_alpha, "f")

    if selected_tab then
        ui.set(_ui.lua.tab.ref, selected_tab)
    end
end

-- {{ ragebot features }}

-- { resolver }

local RESOLVER = {
    ORIGINAL = 0,
    NEGATIVE = -1,
    POSITIVE = 1,
    HALF_NEGATIVE = -0.5,
    HALF_POSITIVE = 0.5
}

local ANIMLAYERS = {
    AIMMATRIX = 0 ,
	WEAPON_ACTION = 1 ,
	WEAPON_ACTION_RECROUCH = 2 ,
	ADJUST = 3 ,
	JUMP_OR_FALL = 4 ,
	LAND_OR_CLIMB = 5 ,
	MOVE = 6 ,
	STRAFECHANGE = 7 ,
	WHOLE_BODY = 8 ,
	FLASHED = 9 ,
	FLINCH = 10 ,
	ALIVELOOP = 11 ,
	LEAN = 12 ,
}

local m_iMaxRecords = 26

local loopsaid = {}
    function loopsaid.deepcopy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end

    local s = seen or {}
    local res = {}
    s[obj] = res
    for k, v in next, obj do res[loopsaid.deepcopy(k, s)] = loopsaid.deepcopy(v, s) end
    return setmetatable(res, getmetatable(obj))
end

function loopsaid.push_back(tbl, push, max)
    local ret_tbl = loopsaid.deepcopy(tbl)
    if not max then max = #ret_tbl end
    for i = max - 1, 1, -1 do
        if ret_tbl[i] ~= nil then
            ret_tbl[i + 1] = ret_tbl[i] 
        end
        if i == 1 then
            ret_tbl[i] = push
        end
    end
    return ret_tbl
end

local resolver = {}
local records = {}
resolver.get_layers = function(idx)
    local layers = {}
    local get_layers = entity.get_animlayer(idx)
    for i = 1, 12 do
        local layer = get_layers[i]
        if not layer then goto continue end

        if not layers[i] then
            layers[i] = {}
        end

        layers[i].m_playback_rate = layer.m_playback_rate
        layers[i].m_sequence = layer.m_sequence
        
        ::continue::
    end
    return layers
end

records.layers = {}
resolver.update_layers = function(idx)
    if not records.layers[idx] then
        records.layers[idx] = {}
    end
    local current_layer = entity.get_animlayer(idx)
    records.layers[idx] = loopsaid.push_back(records.layers[idx], current_layer, m_iMaxRecords)
end

resolver.get_data = function(idx)
    local animstate = entity.get_animstate(idx)
    if not animstate then return end

    local ent = idx
    local ret = {}
    ret.m_flGoalFeetYaw = animstate.m_flGoalFeetYaw
    ret.m_flEyeYaw = animstate.m_flEyeYaw
    ret.m_iEntity = ent > 0 and ent or nil
    ret.m_vecVelocity = ret.m_iEntity and samdadn(ent, 'm_vecVelocity') or {x = 0, y = 0, z = 0}
    ret.m_flDifference = math.angle_diff(animstate.m_flEyeYaw, animstate.m_flGoalFeetYaw)
    ret.m_flFeetSpeedForwardsOrSideWays = animstate.m_flFeetSpeedForwardsOrSideWays
    ret.m_flStopToFullRunningFraction = animstate.m_flStopToFullRunningFraction
    ret.m_fDuckAmount = animstate.m_fDuckAmount
    ret.m_flPitch = animstate.m_flPitch

    return ret
end

records.angles = {}
resolver.update_angles = function(idx)
    if not records.angles[idx] then
        records.angles[idx] = {}
    end
    local current_angles = resolver.get_data(idx)
    records.angles[idx] = loopsaid.push_back(records.angles[idx], current_angles, m_iMaxRecords)
end

local ROTATION = {
    SERVER = 1,
    CENTER = 2,
    LEFT = 3,
    RIGHT = 4
}

records.safepoints_container = {}
resolver.get_safepoints = function(idx, side, desync)
    if not records.safepoints_container[idx] then
        records.safepoints_container[idx] = {}
    end
    for i = 1, 4 do
        if not records.safepoints_container[idx][i] then
            records.safepoints_container[idx][i] = {}
            records.safepoints_container[idx][i].m_playback_rate = 0
        end
        
    end
    records.safepoints_container[idx][1].m_playback_rate = records.layers[idx][1][6].m_playback_rate

    local m_flDesync = side * desync
    if side < 0 then
        if m_flDesync <= -44 then
            records.safepoints_container[idx][4].m_playback_rate = records.safepoints_container[idx][1].m_playback_rate
        end
    elseif side > 0 then
        if m_flDesync >= 44 then
            records.safepoints_container[idx][3].m_playback_rate = records.safepoints_container[idx][1].m_playback_rate
        end
    else
        if desync <= 29 then
            records.safepoints_container[idx][2].m_playback_rate = records.safepoints_container[idx][1].m_playback_rate
        end
    end

    return records.safepoints_container[idx]
end

resolver.safepoints = {}
resolver.update_safepoints = function(idx, side, desync)
    if not resolver.safepoints[idx] then
        resolver.safepoints[idx] = {}
    end
    
    local current_safepoints = resolver.get_safepoints(idx, side, desync)
    resolver.safepoints[idx] = loopsaid.push_back(resolver.safepoints[idx], current_safepoints, m_iMaxRecords)
end

resolver.get_layer_side = function(idx, record)
    local m_iVelocity = math.vec_length2d(records.angles[idx][record].m_vecVelocity)
    if m_iVelocity < 2 then return end
    local layer = resolver.safepoints[idx][record]

    local m_center_layer = math.abs(layer[1].m_playback_rate - layer[2].m_playback_rate)
    local m_left_layer = math.abs(layer[1].m_playback_rate - layer[3].m_playback_rate)
    local m_right_layer = math.abs(layer[1].m_playback_rate - layer[4].m_playback_rate)

    if m_center_layer < m_left_layer or m_right_layer <= m_left_layer then
        if m_center_layer >= m_right_layer or m_left_layer > m_right_layer then
            return 1
        end
    end
    return -1
end

function m_flMaxDesyncDelta(record)
    local speedfactor = math.clamp(record.m_flFeetSpeedForwardsOrSideWays, 0, 1)
    local avg_speedfactor = (record.m_flStopToFullRunningFraction * -0.3 - 0.2) * speedfactor + 1

    local duck_amount = record.m_fDuckAmount

    if duck_amount > 0 then
        local max_velocity = math.clamp(record.m_flFeetSpeedForwardsOrSideWays, 0, 1)
        local duck_speed = duck_amount * max_velocity

        avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
    end

    return avg_speedfactor
end

resolver.run = function(idx, record, force)
    if not records.angles[idx] or not records.angles[idx][record] or not records.angles[idx][record + 1] then return end

    local animstate = records.angles[idx][record]
    local previous = records.angles[idx][record + 1]

    if not animstate.m_iEntity or not previous.m_iEntity then return false end

    local m_flMaxDesyncFloat = m_flMaxDesyncDelta(animstate)
    local m_flDesync = m_flMaxDesyncFloat * 58

    local m_flAbsDiff = animstate.m_flDifference
    local m_flPrevAbsDiff = previous.m_flDifference

    local m_iVelocity = math.vec_length2d(animstate.m_vecVelocity)
    local m_iPrevVelocity = math.vec_length2d(previous.m_vecVelocity)

    local side = RESOLVER.ORIGINAL
    if animstate.m_flDifference <= 1 then
        side = RESOLVER.POSITIVE
    elseif animstate.m_flDifference >= 1 then
        side = RESOLVER.NEGATIVE
    end

    local m_bShouldResolve = true

    if m_flAbsDiff > 0 or m_flPrevAbsDiff > 0 then
        if m_flAbsDiff < m_flPrevAbsDiff then
            m_bShouldResolve = false

            if m_iVelocity >= m_iPrevVelocity then
                m_bShouldResolve = true
            end
        end

        if m_bShouldResolve then
            local m_flCurrentAngle = math.max(m_flAbsDiff, m_flPrevAbsDiff)
            if m_flAbsDiff <= 10.0 and m_flPrevAbsDiff <= 10.0 then
                m_flDesync = m_flCurrentAngle
            elseif m_flAbsDiff <= 35.0 and m_flPrevAbsDiff <= 35.0 then
                m_flDesync = math.max(29.0, m_flCurrentAngle)
            else
                m_flDesync = math.clamp(m_flCurrentAngle, 29.0, 58)
            end
        end
    end

    if (m_flAbsDiff < 1 or m_flPrevAbsDiff < 1 or side == 0) and not force then
        return
    end

    return {
        angle = m_flDesync,
        side = side,
        record = record,
        pitch = animstate.m_flPitch
    }
end

resolver.init = function()
    local lp = entity.get_local_player()

    if not globals.is_connected() then
        resolver.hkResetBruteforce()
    elseif globals.is_connected() and entity.get_prop(lp, 'm_iHealth') < 1 then
        resolver.hkResetBruteforce()
    elseif _ui.ragebot.resolver.value and _ui.lua.enable.value then
        resolver.hkResetBruteforce()
    end
    if globals.is_connected() or not _ui.ragebot.resolver.value or not _ui.lua.enable.value then return end

    local available_clients = entity.get_players(true) 

    if entity.get_prop(lp, 'm_iHealth') >= 1 then
        resolver.reset_bruteforce = true
    end

    for array = 1, #available_clients do
        local idx = available_clients[array]

        if idx == lp then goto continue end

        if not _ui.ragebot.resolver.value or not _ui.lua.enable.value then 
            plist.set(idx, 'Force body yaw', false)
            goto continue 
        end

        resolver.update_angles(idx)

        local info = nil
        local forced = false
        for record = 1, m_iMaxRecords - 1 do
            info = resolver.run(idx, record)
            if info then
                goto set_angle
            elseif record == (m_iMaxRecords - 1) then
                forced = true
                info = resolver.run(idx, 1, true)
            end
        end

        ::set_angle::
        if not info then goto continue end


        resolver.apply(idx, info.angle, info.side, info.pitch)

        ::continue::
    end
end

resolver.apply = function(m_iEntityIndex, m_flDesync, m_iSide, m_flPitch)
    local m_flFinalAngle = m_flDesync * m_iSide
    if m_flFinalAngle < 0 then
        m_flFinalAngle = math.ceil(m_flFinalAngle - 0.5)
    else
        m_flFinalAngle = math.floor(m_flFinalAngle + 0.5)
    end
    if m_iSide == 0 then
        plist.set(m_iEntityIndex, 'Force body yaw', false)
        return
    end
    plist.set(m_iEntityIndex, 'Force body yaw', true)
    plist.set(m_iEntityIndex, 'Force body yaw value', m_flFinalAngle)
end

resolver.bruteforce = {}
resolver.reset_bruteforce = false

resolver.hkResetBruteforce = function()
    for i = 1, 64 do
        resolver.bruteforce[i] = 0
        if i == 64 then
            resolver.reset_bruteforce = false
        end
    end
end

-- { defensive resolver }

defensive_data = {}
local defensive_resolver = function()
    if not _ui.ragebot.defensive_aa_resolver.value or not _ui.lua.enable.value then return end

    local enemies = entity.get_players(true)
    for i, enemy_ent in ipairs(enemies) do
        if defensive_data[enemy_ent] == nil then
            defensive_data[enemy_ent] = {
                pitch = 0,
                vl_p = 0,
                timer = 0,
            }
        else
            defensive_data[enemy_ent].pitch = entity.get_prop(enemy_ent, "m_angEyeAngles[0]")
            if is_defensive_active(enemy_ent) then
                if defensive_data[enemy_ent].pitch < 70 then
                    defensive_data[enemy_ent].vl_p = defensive_data[enemy_ent].vl_p + 1
                    defensive_data[enemy_ent].timer = globals.realtime() + 5
                end
            else
                if defensive_data[enemy_ent].timer - globals.realtime() < 0 then
                    defensive_data[enemy_ent].vl_p = 0
                    defensive_data[enemy_ent].timer = 0
                end
            end
        end

        if defensive_data[enemy_ent].vl_p > 3 then
            plist.set(enemy_ent,"force pitch", true)
            plist.set(enemy_ent,"force pitch value", 89)
        else
            plist.set(enemy_ent,"force pitch", false)
        end
    end
end

-- { aimbot logs }

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
local aimbot_logs_hit = function(e)
    if not _ui.ragebot.shot_logs.value or not _ui.lua.enable.value then return end

    local who = entity.get_player_name(e.target)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local dmg = e.damage
    local health = entity.get_prop(e.target, "m_iHealth")
    local bt = globals.tickcount() - e.tick
    local hc = math.floor(e.hit_chance)
    local log = ""

    if health ~= 0 then
        log = string.lower(string.format("\afafafahurt \a9DDB64%s\afafafa in the \a9DDB64%s\afafafa for \a9DDB64%d\afafafa damage (\a9DDB64%d\afafafa hp remaining) [bt: \a9DDB64%d\afafafa, hc: \a9DDB64%d\afafafa%%.].",
        who, group, dmg, health, bt, hc))

    else 
        log = string.lower(string.format("\afafafakilled \a9DDB64%s\afafafa in the \a9DDB64%s\afafafa [bt: \a9DDB64%d\afafafa, hc: \a9DDB64%d\afafafa%%.].",
        who, group, bt, hc))
    end

    printc("\a9DDB64 aimbot » "..log)
    setup_notification(string.lower(health ~= 0 and string.format("hurt %s in the %s for %d damage (%d hp remaining).", who, group, dmg, health) or string.format("killed %s in the %s.", who, group)), false)
end

local aimbot_logs_miss = function(e)
    if not _ui.ragebot.shot_logs.value or not _ui.lua.enable.value then return end

    local who = entity.get_player_name(e.target)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local reason = e.reason
    local log = string.lower(string.format(
        "\afafafamissed in \aFF6767%s\afafafa's \aFF6767%s\afafafa due to \aFF6767%s\afafafa.",
        who, group, reason
    ))
    
    printc("\aFF6767 aimbot » "..log)
    setup_notification(string.lower(string.format("Missed in %s's %s due to %s.", who, group, reason)), true)
end

-- { peek bot }

local hitboxes = {
    ind = {
        1, 
        2, 
        3, 
        4, 
        5, 
        6, 
        7
    }, 

    name = {
        "head", 
        "chest", 
        "stomach", 
        "left_arm", 
        "right_arm", 
        "left_leg", 
        "right_leg"
    }
}

local bot_data = {
    start_position = vector(0,0,0),
    cache_eye_left = vector(0,0,0), 
    cache_eye_right = vector(0,0,0),
    left_trace_active,
    right_trace_active,
    peekbot_active,
    calculate_wall_dist_left = 0, 
    calculate_wall_dist_right = 0,
    set_location = true,
    shot_fired = false,
    reload_timer = 0,
    reached_max_distance = false,
    should_return = false,
    tracer_position,
    lerp_distance = 0
}

local do_return = function(cmd)
	if bot_data.start_position and bot_data.should_return then
		local lp_origin = vector(entity.get_origin(entity.get_local_player()))
		if bot_data.start_position:dist2d(lp_origin) > 5 then
            if not client.key_state(0x57) and not client.key_state(0x41) and not client.key_state(0x53) and not client.key_state(0x44) and not ui.get(ref.quick_peek[2]) then
			    set_movement( cmd, bot_data.start_position )
            end
		else
			bot_data.should_return = false
            bot_data.shot_fired = false
            bot_data.reached_max_distance = false
		end
	end
end

local peek_bot = function(cmd)
    ui.set(_ui.ragebot.peekbot_bind.ref, "on hotkey")
    local frametime = globals.frametime() * 15
    bot_data.lerp_distance = d_lerp(bot_data.lerp_distance, _ui.ragebot.peekbot.value and _ui.ragebot.peekbot_distance.value or 0, frametime)

    if not _ui.lua.enable.value or not _ui.ragebot.peekbot.value then return end

    if not ui.get(_ui.ragebot.peekbot_bind.ref) then 
        bot_data.set_location = true 
        bot_data.lerp_distance = 0
        return 
    end
    
    local lp_eyepos = vector(client.eye_position())
    local lp_origin = vector(entity.get_origin(entity.get_local_player()))

    if bot_data.set_location then
        bot_data.start_position = lp_origin
        bot_data.set_location = false
    end

    -- should i kill my self or not? (ofc yes)
    do_return(cmd)

    local target = client.current_threat()
    if not target or entity.is_dormant(target) then return end

    if bot_data[target] == nil then
        bot_data[target] = {
            head = false,
            chest = false,
            stomach = false,
            left_arm = false,
            right_arm = false,
            left_leg = false,
            right_leg = false
        }
    end

    local enemy_origin = vector(entity.get_origin(target))

	local enemy_x, enemy_y = lp_eyepos.x - enemy_origin.x, lp_eyepos.y - enemy_origin.y
	local enemy_ang = math.atan2(enemy_y, enemy_x) * (180 / math.pi)
	local left_x, left_y, left_z = angle_to_vector(0, enemy_ang - 90)
    local right_x, right_y, right_z = angle_to_vector(0, enemy_ang + 90)

    local eye_left = vector(left_x * math.max(0,bot_data.lerp_distance - bot_data.calculate_wall_dist_left) + lp_eyepos.x, left_y * math.max(0,bot_data.lerp_distance - bot_data.calculate_wall_dist_left) + lp_eyepos.y, lp_eyepos.z)
	local eye_right = vector(right_x * math.max(0,bot_data.lerp_distance - bot_data.calculate_wall_dist_right) + lp_eyepos.x, right_y * math.max(0,bot_data.lerp_distance - bot_data.calculate_wall_dist_right) + lp_eyepos.y, lp_eyepos.z)
    local eye_left_ext = vector(left_x * bot_data.lerp_distance*1.2 + lp_eyepos.x, left_y * bot_data.lerp_distance*1.2 + lp_eyepos.y, lp_eyepos.z)
	local eye_right_ext = vector(right_x * bot_data.lerp_distance*1.2 + lp_eyepos.x, right_y * bot_data.lerp_distance*1.2 + lp_eyepos.y, lp_eyepos.z)

    bot_data.cache_eye_left = eye_left
    bot_data.cache_eye_right = eye_right

    for i, v in pairs(hitboxes.ind) do
        hitbox = vector(entity.hitbox_position(target, v))

        left, damage_left = client.trace_bullet(entity.get_local_player(), eye_left.x, eye_left.y, eye_left.z, hitbox.x, hitbox.y, hitbox.z, false)
        right, damage_right = client.trace_bullet(entity.get_local_player(), eye_right.x, eye_right.y, eye_right.z, hitbox.x, hitbox.y, hitbox.z, false)

        trace_wall_left = client.trace_line(0, eye_left.x, eye_left.y, eye_left.z, eye_left_ext.x, eye_left_ext.y, eye_left_ext.z)
        trace_wall_right = client.trace_line(0, eye_right.x, eye_right.y, eye_right.z, eye_right_ext.x, eye_right_ext.y, eye_right_ext.z)
        
        if trace_wall_left ~= 1 then
            bot_data.calculate_wall_dist_left = (1 - trace_wall_left)*(_ui.ragebot.peekbot_distance.value/(_ui.ragebot.peekbot_distance.value/100))
        else
            bot_data.calculate_wall_dist_left = 0
        end

        if trace_wall_right ~= 1 then
            bot_data.calculate_wall_dist_right = (1 - trace_wall_right)*(_ui.ragebot.peekbot_distance.value/(_ui.ragebot.peekbot_distance.value/100))
        else
            bot_data.calculate_wall_dist_right = 0
        end

        if left or right then
            bot_data[target][hitboxes.name[v]] = true

            if left and not bot_data.right_trace_active then
                bot_data.tracer_position = eye_left
                bot_data.left_trace_active = true
            else
                bot_data.left_trace_active = false
            end
    
            if right and not bot_data.left_trace_active then
                bot_data.tracer_position = eye_right
                bot_data.right_trace_active = true
            else
                bot_data.right_trace_active = false
            end
        else
            bot_data[target][hitboxes.name[v]] = false
        end
    end

    if bot_data[target].head or bot_data[target].chest or bot_data[target].stomach or bot_data[target].left_arm or bot_data[target].right_arm or bot_data[target].left_leg or bot_data[target].right_leg then
        bot_data.peekbot_active = true
    elseif not bot_data[target].head and not bot_data[target].chest and not bot_data[target].stomach and not bot_data[target].left_arm and not bot_data[target].right_arm and not bot_data[target].left_leg and not bot_data[target].right_leg then
        bot_data.peekbot_active = false
    end

    if bot_data.start_position:dist2d(lp_origin) > _ui.ragebot.peekbot_distance.value then
        bot_data.reached_max_distance = true
    end
    
    if bot_data.peekbot_active and not bot_data.shot_fired and (bot_data.reload_timer < globals.realtime()) and not bot_data.reached_max_distance then
        --if not client.key_state(0x57) and not client.key_state(0x41) and not client.key_state(0x53) and not client.key_state(0x44) then
        if bot_data.peekbot_active and bot_data.left_trace_active then
			set_movement(cmd, eye_left)
        elseif bot_data.peekbot_active and bot_data.right_trace_active then
			set_movement(cmd, eye_right)
        end
        --end
    else
        bot_data.should_return = true
    end
end

local renderer_trace_positions = function()
    local target = client.current_threat()
    if _ui.lua.enable.value and _ui.ragebot.peekbot.value and ui.get(_ui.ragebot.peekbot_bind.ref) and _ui.ragebot.peekbot_visualize.value and (target and not entity.is_dormant(target)) then

        local lp_origin = vector(entity.get_origin(entity.get_local_player()))
        local target_origin = vector(entity.get_origin(target))

        renderer.circle_3d(vector(bot_data.start_position.x, bot_data.start_position.y, lp_origin.z), 10, 0, 1, 4, false, (bot_data.shot_fired or bot_data.reached_max_distance) and 149 or 255, (bot_data.shot_fired or bot_data.reached_max_distance) and 186 or 255, (bot_data.shot_fired or bot_data.reached_max_distance) and 255 or 255, 255)
        renderer.circle_3d(vector(bot_data.cache_eye_left.x, bot_data.cache_eye_left.y, lp_origin.z), 13, 0, 1, 4, false, (bot_data.peekbot_active and bot_data.left_trace_active) and 149 or 149, (bot_data.peekbot_active and bot_data.left_trace_active) and 255 or 186, (bot_data.peekbot_active and bot_data.left_trace_active) and 162 or 255, (bot_data.peekbot_active and bot_data.right_trace_active) and 100 or 255)
        renderer.circle_3d(vector(bot_data.cache_eye_right.x, bot_data.cache_eye_right.y, lp_origin.z), 13, 0, 1, 4, false, (bot_data.peekbot_active and bot_data.right_trace_active) and 149 or 149, (bot_data.peekbot_active and bot_data.right_trace_active) and 255 or 186, (bot_data.peekbot_active and bot_data.right_trace_active) and 162 or 255, (bot_data.peekbot_active and bot_data.left_trace_active) and 100 or 255)
    
        renderer.circle_3d(vector(target_origin.x, target_origin.y, target_origin.z), 13, 0, 1, 4, false, 149, 255, 162, 255)
    end
end

-- { backtrack exploit }

local function track_exploit(cmd, player)
    if not _ui.ragebot.backtrack_exploit.value or not _ui.lua.enable.value then return end
    if player == 0 or getspeed(player) < 5 then return end
    local simtime = entity.get_prop(player, "m_flSimulationTime")
    if simtime == nil or vars.simtime_backup == nil then return end
    local track_time = globals.curtime() - simtime
    local usrcmd = get_input.vfptr.GetUserCmd(ffi.cast("uintptr_t", get_input), 0, cmd.command_number)
    local S_animationState_t = animation_layer_t_struct(entity.get_local_player())
    local lagcomp_check = cvar.cl_lagcompensation:get_int() == 1
    local ping = client.latency()

    if track_time < ping then
        S_animationState_t.m_bIsBreakingLagComp = true
    else
        S_animationState_t.m_bIsBreakingLagComp = false
    end

    if (track_time > 0.2 and track_time <= 0.6) and lagcomp_check then
        if entity.is_alive(entity.get_local_player()) then
            S_animationState_t.iOutSequenceNrAck = hook_value(math.max(0, clamp(0, cvar.sv_maxunlag:get_float(), vars.simtime_backup)))
            S_animationState_t.iOutSequenceNr = hook_value(globals.lastoutgoingcommand())
            S_animationState_t.iInSequenceNr = S_animationState_t.iOutSequenceNrAck - S_animationState_t.iChokedPackets
            S_animationState_t.m_nSequence = S_animationState_t.iInSequenceNr + S_animationState_t.iOutSequenceNr + S_animationState_t.iOutSequenceNrAck
            S_animationState_t.iOutReliableState = globals.lastoutgoingcommand()
            S_animationState_t.iInReliableState = hook_value(math.max(0, clamp(0, cvar.sv_maxunlag:get_float(), vars.simtime_backup)))
        end
        if usrcmd.weaponselect == 0 then
            usrcmd.tick_count = TIME_TO_TICKS(vars.simtime_backup + calc_lerp())
        end
    end
end

-- {{ antiaim features }}

-- { antiaim builder }

-- manuals
local right_dir, left_dir = false, false
local function manual_direction()
    if not ui.get(_ui.antiaim.binds.freestanding.ref) then
        if ui.get(_ui.antiaim.binds.manual_right.ref) then
            if right_dir == true and vars.last_press_t + 0.07 < globals.realtime() then
                right_dir = false
                left_dir = false
            elseif right_dir == false and vars.last_press_t + 0.07 < globals.realtime() then
                right_dir = true
                left_dir = false
            end
            vars.last_press_t = globals.realtime()
        elseif ui.get(_ui.antiaim.binds.manual_left.ref) then
            if left_dir == true and vars.last_press_t + 0.07 < globals.realtime() then
                back_dir = true
                left_dir = false
            elseif left_dir == false and vars.last_press_t + 0.07 < globals.realtime() then
                left_dir = true
                right_dir = false
            end
            vars.last_press_t = globals.realtime()
        end
    else
        right_dir = false 
        left_dir = false
    end

    return right_dir, left_dir
end

local modifier_delayed_stage, modifier_5way_stage, body_yaw_delayed_jitter_stage, body_yaw_experimental_stage = 1, 1, 1, 1
local yaw, yaw_value, yaw_jitter, yaw_jitter_value, body_yaw, body_yaw_side = "Off", 0, "Off", 0, "Off", 0
local threat_origin_wts_x = 0
local antiaim_builder = function(cmd)
    if not _ui.lua.enable.value or not _ui.antiaim._global.enable.value or not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then return end

    local state = get_state(get_velocity())
    local players = entity.get_players(true)
    local get_override = aa_builder[state].override.value and state or 1
    local defensive = is_defensive_active(entity.get_local_player())
    local right_dir, left_dir = manual_direction()

    ui.set(ref.roll, 0)
    ui.set(ref.freestand[2], "always on")
    ui.set(_ui.antiaim.binds.manual_right.ref, "On hotkey")
    ui.set(_ui.antiaim.binds.manual_left.ref, "On hotkey")

    stages = {
        modifier_delayed = {
            [1] = not (defensive and aa_builder[get_override].defensive_modifiers.value) and aa_builder[get_override].yaw_modifier_value.value or aa_builder[get_override].defensive_yaw_modifier_value.value,
            [2] = not (defensive and aa_builder[get_override].defensive_modifiers.value) and -aa_builder[get_override].yaw_modifier_value.value or -aa_builder[get_override].defensive_yaw_modifier_value.value
        },

        modifier_5way = {
            [1] = not (defensive and aa_builder[get_override].defensive_modifiers.value) and aa_builder[get_override].yaw_modifier_value.value or aa_builder[get_override].defensive_yaw_modifier_value.value,
            [2] = not (defensive and aa_builder[get_override].defensive_modifiers.value) and aa_builder[get_override].yaw_modifier_value.value/2 or aa_builder[get_override].defensive_yaw_modifier_value.value/2,
            [3] = 0,
            [4] = not (defensive and aa_builder[get_override].defensive_modifiers.value) and -aa_builder[get_override].yaw_modifier_value.value/2 or -aa_builder[get_override].defensive_yaw_modifier_value.value/2,
            [5] = not (defensive and aa_builder[get_override].defensive_modifiers.value) and -aa_builder[get_override].yaw_modifier_value.value or -aa_builder[get_override].defensive_yaw_modifier_value.value
        },

        body_yaw_delayed_jitter = {
            [1] = 180,
            [2] = -180
        },
        
        body_yaw_experimental = {
            [1] = 180,
            [2] = 0,
            [3] = -180
        }
    }

    local short_modifier_delayed = not (defensive and aa_builder[get_override].defensive_modifiers.value) and aa_builder[get_override].yaw_modifier_delay_value.value or aa_builder[get_override].defensive_yaw_modifier_delay_value.value
    local short_body_yaw_delayed_jitter = not (defensive and aa_builder[get_override].defensive_modifiers.value) and aa_builder[get_override].body_yaw_delay_value.value or aa_builder[get_override].defensive_body_yaw_delay_value.value

    if cmd.command_number % (short_modifier_delayed) == ((short_modifier_delayed)-1) and not choking(cmd) then modifier_delayed_stage = modifier_delayed_stage + 1 end
    if (modifier_delayed_stage == 3) or (modifier_delayed_stage > 3) then modifier_delayed_stage = 1 end
    if cmd.command_number % 2 == 1 and not choking(cmd) then modifier_5way_stage = modifier_5way_stage + 1 end
    if (modifier_5way_stage == 6) or (modifier_5way_stage > 6) then modifier_5way_stage = 1 end
    if cmd.command_number % (short_body_yaw_delayed_jitter) == ((short_body_yaw_delayed_jitter)-1) and not choking(cmd) then body_yaw_delayed_jitter_stage = body_yaw_delayed_jitter_stage + 1 end
    if (body_yaw_delayed_jitter_stage == 3) or (body_yaw_delayed_jitter_stage > 3) then body_yaw_delayed_jitter_stage = 1 end
    if cmd.command_number % 2 == 1 and not choking(cmd) then body_yaw_experimental_stage = body_yaw_experimental_stage + 1 end
    if (body_yaw_experimental_stage == 4) or (body_yaw_experimental_stage > 4) then body_yaw_experimental_stage = 1 end

    local allow_defensive = defensive and aa_builder[get_override].defensive_modifiers.value and not (aa_builder[get_override].defensive_antiaim.value == "Off")
    
    -- retard code, please dont read
    if allow_defensive and not choking(cmd) then
        if aa_builder[get_override].defensive_antiaim.value == "Spin" then
            ui.set(ref.pitch, "Custom")
            ui.set(ref.pitch_value, -46)
            ui.set(ref.yaw_base, "at targets")
            ui.set(ref.yaw, "Spin")
            ui.set(ref.yaw_value, 87)
            ui.set(ref.yaw_jitter, "Off")
            ui.set(ref.yaw_jitter_value, 0)
            ui.set(ref.body_yaw, "Jitter")
            ui.set(ref.body_yaw_side, 0)
            ui.set(ref.freestand_body_yaw, false)        
        elseif aa_builder[get_override].defensive_antiaim.value == "Random" then
            ui.set(ref.pitch, "Random")
            ui.set(ref.pitch_value, 0)
            ui.set(ref.yaw_base, "at targets")
            ui.set(ref.yaw, "180")
            ui.set(ref.yaw_value, client.random_int(-180, 180))
            ui.set(ref.yaw_jitter, "Random")
            ui.set(ref.yaw_jitter_value, client.random_int(-180, 180))
            ui.set(ref.body_yaw, "Static")
            ui.set(ref.body_yaw_side, stages.body_yaw_experimental[body_yaw_experimental_stage])
            ui.set(ref.freestand_body_yaw, false)   
        elseif aa_builder[get_override].defensive_antiaim.value == "Custom" then
            yaw = aa_builder[get_override].defensive_yaw_mode.value

            if aa_builder[get_override].defensive_yaw_modifier.value == "Delayed" then
                yaw_value = stages.modifier_delayed[modifier_delayed_stage] + aa_builder[get_override].defensive_yaw_value.value
            elseif aa_builder[get_override].defensive_yaw_modifier.value == "5-Way" then
                yaw_value = stages.modifier_5way[modifier_5way_stage] + aa_builder[get_override].defensive_yaw_value.value
            elseif not (aa_builder[get_override].defensive_yaw_modifier.value == "Delayed") and not (aa_builder[get_override].defensive_yaw_modifier.value == "5-Way") then
                yaw_value = aa_builder[get_override].defensive_yaw_value.value
            end

            if aa_builder[get_override].defensive_yaw_modifier.value == "Delayed" or aa_builder[get_override].defensive_yaw_modifier.value == "5-Way" then
                yaw_jitter = "Off"
            elseif aa_builder[get_override].defensive_yaw_modifier.value == "3-Way" then
                yaw_jitter = "Skitter"
            elseif not (aa_builder[get_override].defensive_yaw_modifier.value == "Delayed") and not (aa_builder[get_override].defensive_yaw_modifier.value == "5-Way") and not (aa_builder[get_override].defensive_yaw_modifier.value == "3-Way") then
                yaw_jitter = aa_builder[get_override].defensive_yaw_modifier.value
            end

            yaw_jitter_value = aa_builder[get_override].defensive_yaw_modifier_value.value

            if aa_builder[get_override].defensive_body_yaw.value == "Delayed jitter" or aa_builder[get_override].defensive_body_yaw.value == "Experimental" then
                body_yaw = "Static"
            else
                body_yaw = aa_builder[get_override].defensive_body_yaw.value
            end

            if aa_builder[get_override].defensive_body_yaw.value == "Static" or aa_builder[get_override].defensive_body_yaw.value == "Jitter" then
                if aa_builder[get_override].defensive_body_yaw_side.value == "Left" then
                    body_yaw_side = -180
                elseif aa_builder[get_override].defensive_body_yaw_side.value == "Right" then
                    body_yaw_side = 180
                elseif aa_builder[get_override].defensive_body_yaw_side.value == "Default" then
                    body_yaw_side = 0
                end
            elseif aa_builder[get_override].defensive_body_yaw.value == "Delayed jitter" then
                body_yaw_side = stages.body_yaw_delayed_jitter[body_yaw_delayed_jitter_stage]
            elseif aa_builder[get_override].defensive_body_yaw.value == "Experimental" then
                body_yaw_side = stages.body_yaw_experimental[body_yaw_experimental_stage]
            end
        end
    else
        yaw = "180"

        if aa_builder[get_override].yaw_modifier.value == "Delayed" then
            yaw_value = stages.modifier_delayed[modifier_delayed_stage] + aa_builder[get_override].yaw_value.value
        elseif aa_builder[get_override].yaw_modifier.value == "5-Way" then
            yaw_value = stages.modifier_5way[modifier_5way_stage] + aa_builder[get_override].yaw_value.value
        elseif not (aa_builder[get_override].yaw_modifier.value == "Delayed") and not (aa_builder[get_override].yaw_modifier.value == "5-Way") then
            yaw_value = aa_builder[get_override].yaw_value.value
        end

        if aa_builder[get_override].yaw_modifier.value == "Delayed" or aa_builder[get_override].yaw_modifier.value == "5-Way" then
            yaw_jitter = "Off"
        elseif aa_builder[get_override].yaw_modifier.value == "3-Way" then
            yaw_jitter = "Skitter"
        elseif not (aa_builder[get_override].yaw_modifier.value == "Delayed") and not (aa_builder[get_override].yaw_modifier.value == "5-Way") and not (aa_builder[get_override].yaw_modifier.value == "3-Way") then
            yaw_jitter = aa_builder[get_override].yaw_modifier.value
        end

        yaw_jitter_value = aa_builder[get_override].yaw_modifier_value.value

        if aa_builder[get_override].body_yaw.value == "Delayed jitter" or aa_builder[get_override].body_yaw.value == "Experimental" then
            body_yaw = "Static"
        else
            body_yaw = aa_builder[get_override].body_yaw.value
        end

        if aa_builder[get_override].body_yaw.value == "Static" or aa_builder[get_override].body_yaw.value == "Jitter" then
            if aa_builder[get_override].body_yaw_side.value == "Left" then
                body_yaw_side = -180
            elseif aa_builder[get_override].body_yaw_side.value == "Right" then
                body_yaw_side = 180
            elseif aa_builder[get_override].body_yaw_side.value == "Default" then
                body_yaw_side = 0
            end
        elseif aa_builder[get_override].body_yaw.value == "Delayed jitter" then
            body_yaw_side = stages.body_yaw_delayed_jitter[body_yaw_delayed_jitter_stage]
        elseif aa_builder[get_override].body_yaw.value == "Experimental" then
            body_yaw_side = stages.body_yaw_experimental[body_yaw_experimental_stage]
        end
    end

    if not (allow_defensive and (aa_builder[get_override].defensive_antiaim.value == "Spin" or aa_builder[get_override].defensive_antiaim.value == "Random")) and not (right_dir or left_dir) then
        ui.set(ref.pitch, not ((allow_defensive) and aa_builder[get_override].defensive_antiaim.value == "Custom") and "minimal" or aa_builder[get_override].defensive_pitch.value)
        ui.set(ref.pitch_value, aa_builder[get_override].defensive_pitch_value.value)
        ui.set(ref.yaw_base, "at targets")
        ui.set(ref.yaw, yaw)
        ui.set(ref.yaw_value, limiter(-180, yaw_value, 180))
        ui.set(ref.yaw_jitter, yaw_jitter)
        ui.set(ref.yaw_jitter_value, limiter(-180, yaw_jitter_value, 180))
        ui.set(ref.body_yaw, body_yaw)
        ui.set(ref.body_yaw_side, body_yaw_side)
        ui.set(ref.freestand_body_yaw, not (aa_builder[get_override].body_yaw.value == "Delayed jitter" or aa_builder[get_override].body_yaw.value == "Experimental") and aa_builder[get_override].freestand_body_yaw.value or false)
    end

    cmd.force_defensive = aa_builder[get_override].defensive_modifiers.value and aa_builder[get_override].force_defensive.value and true

    -- safe head
    if _ui.antiaim.settings.safehead.value then
        for i, v in pairs(players) do
            local local_player_origin = vector(entity.get_origin(entity.get_local_player()))
            local player_origin = vector(entity.get_origin(v))
            local difference = (local_player_origin.z - player_origin.z)
            local local_player_weapon = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))

            if (((local_player_weapon == "CKnife" or local_player_weapon == "CWeaponTaser") and state == 5 and difference > -70) or difference > 65) then    
                if defensive then
                    ui.set(ref.pitch, "down")
                    ui.set(ref.yaw, "180")
                    ui.set(ref.yaw_value, -1)
                    ui.set(ref.yaw_base, "At targets")
                    ui.set(ref.yaw_jitter, "Off")
                    ui.set(ref.body_yaw, "Static")
                    ui.set(ref.body_yaw_side, 0)
                    ui.set(ref.freestand_body_yaw, false)
                end
            end
        end
    end
    
    -- anti-backstab
    if _ui.antiaim.settings.backstab.value then
        for i, v in pairs(players) do
            local player_weapon = entity.get_classname(entity.get_player_weapon(v))
            local player_distance = math.floor(vector(entity.get_origin(v)):dist(vector(entity.get_origin(entity.get_local_player()))) / 7)
    
            if player_weapon == "CKnife" then
                if player_distance < 25 then
                    ui.set(ref.yaw, "180")
                    ui.set(ref.yaw_value, -180)
                    ui.set(ref.yaw_base, "At targets")
                    ui.set(ref.yaw_jitter, "Off")
                end
            end
        end
    end

    -- fakelag on shot
    if _ui.antiaim.settings.fakelag_on_shot.value then
        if vars.in_attack > globals.realtime() then
            pui.reference("aa", "fake lag", "limit"):override(1)
        else
            pui.reference("aa", "fake lag", "limit"):override(nil)
        end
    end

    -- manuals
    if right_dir then
        ui.set(ref.pitch, "Down")
        ui.set(ref.yaw_base, "Local view")
        ui.set(ref.yaw_jitter, "Off")
        ui.set(ref.yaw, "180")
        ui.set(ref.yaw_value, 90)
    elseif left_dir then
        ui.set(ref.pitch, "Down")
        ui.set(ref.yaw_base, "Local view")
        ui.set(ref.yaw_jitter, "Off")
        ui.set(ref.yaw, "180")
        ui.set(ref.yaw_value, -90)
    end

    if ui.get(_ui.antiaim.binds.freestanding.ref) then
        ui.set(ref.pitch, "Down")
        ui.set(ref.yaw_base, "Local view")
        ui.set(ref.yaw_jitter, "Off")
        ui.set(ref.yaw, "180")
        ui.set(ref.yaw_value, 90)
    end

    -- peek baiter
    if ui.get(_ui.antiaim.binds.peek_baiter.ref) then
        if client.current_threat() then
            local threat_origin = vector(entity.get_origin(client.current_threat()))
            local screen_size = vector(client.screen_size())

            cmd.force_defensive = true
            if defensive then
                if threat_origin_wts_x then
                    if threat_origin_wts_x > screen_size.x/2 then
                        ui.set(ref.yaw_value, 90)
                    elseif threat_origin_wts_x < screen_size.x/2 then
                        ui.set(ref.yaw_value, -90)
                    end
                end
            end
        end
    end

    -- binds
    ui.set(ref.freestand[1], ui.get(_ui.antiaim.binds.freestanding.ref) and true or false)
    ui.set(ref.edgeyaw, ui.get(_ui.antiaim.binds.edge_yaw.ref) and true or false)
end
inattack = function() if not _ui.antiaim.settings.fakelag_on_shot.value then return end vars.shot_time = globals.realtime() vars.in_attack = vars.shot_time + 0.035 return vars.in_attack end

-- {{ visual features }}

-- { watermark }

local anims_wm = {menu = 0, position_simple_x = 0, position_simple_y = 0}
local watermark = function()

    if _ui.visuals.indicators.value then return end

    local color = {_ui.visuals.accent_color.color:get()}
    local screen_size = vector(client.screen_size())
    local frametime = globals.frametime() * 11
    local p_x = _ui.visuals.watermark_pos.value == "Bottom" and (screen_size.x/2 - renderer.measure_text("b", "G A M E S E N S E . T O O L S")/2) or 15
    local p_y = _ui.visuals.watermark_pos.value == "Bottom" and (screen_size.y - 20 - anims_wm.menu) or (screen_size.y/2 - 30)
    
    anims_wm.menu = d_lerp(anims_wm.menu, ui.is_menu_open() and 136 or 0, frametime)
    anims_wm.position_simple_x = d_lerp(anims_wm.position_simple_x, p_x, frametime)
    anims_wm.position_simple_y = d_lerp(anims_wm.position_simple_y, p_y, frametime)

    if _ui.visuals.watermark_mode.value == "Simple" then
        animated_text(anims_wm.position_simple_x, anims_wm.position_simple_y, -6, {r=color[1], g=color[2], b=color[3], a=255}, {r=50, g=50, b=50, a=255}, "b", "G A M E S E N S E . T O O L S")
    else
        renderer_gs_rect_with_text(screen_size.x/2, screen_size.y - 24 - anims_wm.menu, "gamesense.tools   ~   build : "..build.."   user : "..obex_data.username, nil, true, color[1], color[2], color[3], 255)
    end
end

-- { crosshair indicators }

anims_ind = {state_measure = 0, desync_side_y = 0, scope = 0, enable_1 = 0, enable_2 = 0, enable_3 = 0, alpha = 0}
for i = 1, 8 do
    anims_ind[i] = {}
    anims_ind[i].y_adding = 0
    anims_ind[i].alpha = 0
    anims_ind[i].enable = 0
end

local indicators = function()

    local frametime = globals.frametime() * 20
    local screen_size = vector(client.screen_size())
    local color = {_ui.visuals.accent_color.color:get()}
    
    anims_ind.enable_1 = d_lerp(anims_ind.enable_1, (_ui.lua.enable.value and _ui.visuals.indicators.value and entity.get_local_player() and entity.is_alive(entity.get_local_player())) and 0 or -666, frametime/2.5)
    anims_ind.enable_2 = d_lerp(anims_ind.enable_2, (_ui.lua.enable.value and _ui.visuals.indicators.value and entity.get_local_player() and entity.is_alive(entity.get_local_player())) and 0 or -666, frametime/3.5)
    anims_ind.enable_3 = d_lerp(anims_ind.enable_3, (_ui.lua.enable.value and _ui.visuals.indicators.value and entity.get_local_player() and entity.is_alive(entity.get_local_player())) and 0 or -666, frametime/3.9)
    anims_ind.alpha = d_lerp(anims_ind.alpha, (_ui.lua.enable.value and _ui.visuals.indicators.value and entity.get_local_player() and entity.is_alive(entity.get_local_player())) and 255 or 0, frametime)

    if anims_ind.alpha < 2 then return end

    local req = contains(_ui.visuals.indicators_elements.value, "Binds") and _ui.visuals.indicators.value and _ui.lua.enable.value and entity.get_local_player() and entity.is_alive(entity.get_local_player())
    local binds_table = {
        ["DOUBLE TAP"] = (req and contains(_ui.visuals.indicators_binds.value, "Double tap") and anims_ind.alpha > 5) and (ui.get(ref.doubletap[1]) and ui.get(ref.doubletap[2])),
        ["IDEALPEEK"] = (req and contains(_ui.visuals.indicators_binds.value, "Freestanding") and contains(_ui.visuals.indicators_binds.value, "Quick peek") and anims_ind.alpha > 5) and ((ui.get(ref.quick_peek[1]) and ui.get(ref.quick_peek[2])) and (ui.get(ref.freestand[1]) and ui.get(ref.freestand[2]))),
        ["FREESTAND"] = (req and contains(_ui.visuals.indicators_binds.value, "Freestanding") and anims_ind.alpha > 5) and ((ui.get(ref.freestand[1]) and ui.get(ref.freestand[2])) and not (contains(_ui.visuals.indicators_binds.value, "Quick peek") and (ui.get(ref.quick_peek[1]) and ui.get(ref.quick_peek[2])))),
        ["AUTOPEEK"] = (req and contains(_ui.visuals.indicators_binds.value, "Quick peek") and anims_ind.alpha > 5) and ((ui.get(ref.quick_peek[1]) and ui.get(ref.quick_peek[2])) and not (contains(_ui.visuals.indicators_binds.value, "Freestanding") and (ui.get(ref.freestand[1]) and ui.get(ref.freestand[2])))),
        ["FAKEDUCK"] = (req and contains(_ui.visuals.indicators_binds.value, "Fakeduck") and anims_ind.alpha > 5) and (ui.get(ref.fakeduck)),
        ["EDGEYAW"] = (req and contains(_ui.visuals.indicators_binds.value, "Edgeyaw") and anims_ind.alpha > 5) and (ui.get(_ui.antiaim.binds.edge_yaw.ref)),
        ["DMG: "..ui.get(ref.damage[3])] = (req and contains(_ui.visuals.indicators_binds.value, "Damage override")) and (ui.get(ref.damage[1]) and ui.get(ref.damage[2])),
        ["OS-AA"] = (req and contains(_ui.visuals.indicators_binds.value, "Hide shots") and anims_ind.alpha > 5) and ((ui.get(ref.osaa[1]) and ui.get(ref.osaa[2])) and not (ui.get(ref.doubletap[1]) and ui.get(ref.doubletap[2]))),
    }

    local add_y = (contains(_ui.visuals.indicators_elements.value, "Desync side") and contains(_ui.visuals.indicators_elements.value, "Player state")) and 6 or (contains(_ui.visuals.indicators_elements.value, "Desync side") and not contains(_ui.visuals.indicators_elements.value, "Player state")) and -4 or (not contains(_ui.visuals.indicators_elements.value, "Desync side") and contains(_ui.visuals.indicators_elements.value, "Player state")) and 0 or (not contains(_ui.visuals.indicators_elements.value, "Desync side") and not contains(_ui.visuals.indicators_elements.value, "Player state")) and -11
    local desync_side_y = contains(_ui.visuals.indicators_elements.value, "Player state") and 1 or -10
    local active_binds = 0

    local state = aa_state[get_state(get_velocity())] ~= nil and aa_state[get_state(get_velocity())] or "nil"
    local angle = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) ~= nil and  math.floor(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60) or 0
    local side = angle > 0 and "r" or "l"
    
    anims_ind.state_measure = d_lerp(anims_ind.state_measure, renderer.measure_text("-", "-  "..string.upper(state).."  -")/2, frametime)
    anims_ind.desync_side_y = d_lerp(anims_ind.desync_side_y, desync_side_y, frametime)
    anims_ind.scope = d_lerp(anims_ind.scope, (entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1 or entity.get_prop(entity.get_local_player(), "m_bIsScoped") == nil) and (_ui.visuals.indicators_scope.value == "Right" and -50 or _ui.visuals.indicators_scope.value == "Left" and 50 or _ui.visuals.indicators_scope.value == "Off" and 0) or 0, frametime)

    for i, bind in ipairs({"DOUBLE TAP", "IDEALPEEK", "FREESTAND", "AUTOPEEK", "FAKEDUCK", "EDGEYAW", "DMG: "..ui.get(ref.damage[3]), "OS-AA"}) do
        anims_ind[i].enable = d_lerp(anims_ind[i].enable, (_ui.lua.enable.value and _ui.visuals.indicators.value and entity.get_local_player() and entity.is_alive(entity.get_local_player())) and 0 or -666, (frametime / 5) / ((i == 2 or i == 3) and i - i/2.35 or i > 4 and i - i/1.25 or 1))
        
        if binds_table[bind] then
            add_y = add_y + 9
            active_binds = active_binds + 1
            anims_ind[i].y_adding = d_lerp(anims_ind[i].y_adding, add_y, frametime)
            anims_ind[i].alpha = d_lerp(anims_ind[i].alpha, 255, frametime*2)
        else
            anims_ind[i].y_adding = d_lerp(anims_ind[i].y_adding, 0, frametime)
            anims_ind[i].alpha = d_lerp(anims_ind[i].alpha, 0, frametime)
        end

        renderer.text(screen_size.x/2 - renderer.measure_text("-", string.upper(bind))/2 - anims_ind.scope, screen_size.y/2 + 30 + math.floor(anims_ind[i].y_adding)+2+((math.floor(anims_ind[i].y_adding)+2 == 8 or math.floor(anims_ind[i].y_adding)+2 == 17) and 1 or 0) - anims_ind[i].enable, anims_ind[i].alpha, anims_ind[i].alpha, anims_ind[i].alpha, anims_ind[i].alpha, "-", 0, string.upper(bind))
    end

    animated_text(screen_size.x/2 - renderer.measure_text("b", "gamesense.tools")/2 - anims_ind.scope, screen_size.y/2 + 18 - anims_ind.enable_1, -5, {r=color[1], g=color[2], b=color[3], a=anims_ind.alpha}, {r=50, g=50, b=50, a=anims_ind.alpha}, "b", "gamesense.tools")
    if contains(_ui.visuals.indicators_elements.value, "Player state") then
        renderer.text(screen_size.x/2 - anims_ind.state_measure - anims_ind.scope, screen_size.y/2 + 30 - anims_ind.enable_2, 211, 211, 211, anims_ind.alpha, "-", 0, "-  "..string.upper(state).."  -")
    end
    if contains(_ui.visuals.indicators_elements.value, "Desync side") then
        renderer.rectangle(screen_size.x/2 - 40/2 - anims_ind.scope, screen_size.y/2 + 42 + math.floor(anims_ind.desync_side_y) + ((math.floor(anims_ind.desync_side_y) == 1) and -1 or (math.floor(anims_ind.desync_side_y) == -11) and 1 or (not (math.floor(anims_ind.desync_side_y) == 1) and not (math.floor(anims_ind.desync_side_y) == -11)) and 0) - anims_ind.enable_3, 42, 3, 12, 12, 12, anims_ind.alpha)
        if side == "r" then
            renderer.rectangle(screen_size.x/2 - 40/2 + 1 - anims_ind.scope, screen_size.y/2 + 43 + math.floor(anims_ind.desync_side_y) + ((math.floor(anims_ind.desync_side_y) == 1) and -1 or (math.floor(anims_ind.desync_side_y) == -11) and 1 or (not (math.floor(anims_ind.desync_side_y) == 1) or not (math.floor(anims_ind.desync_side_y) == -11)) and 0) - anims_ind.enable_3, 20, 1, color[1], color[2], color[3], anims_ind.alpha)
        else
            renderer.rectangle(screen_size.x/2 + 1 - anims_ind.scope, screen_size.y/2 + 43 + math.floor(anims_ind.desync_side_y) + ((math.floor(anims_ind.desync_side_y) == 1) and -1 or (math.floor(anims_ind.desync_side_y) == -11) and 1 or (not (math.floor(anims_ind.desync_side_y) == 1) or not (math.floor(anims_ind.desync_side_y) == -11)) and 0) - anims_ind.enable_3, 20, 1, color[1], color[2], color[3], anims_ind.alpha)
        end
    end
end

-- { taser warning }

anims_tw = {enable = 0, alpha = 0, active = false}
local taser_icon = renderer.load_png(readfile("taser_icon.png"), 25, 19)
local taser_warning = function()
    
    local frametime = globals.frametime() * 20
    local screen_size = vector(client.screen_size())
    local color = {_ui.visuals.accent_color.color:get()}

    if _ui.lua.enable.value and _ui.visuals.taser_warning.value then
        local enemies = entity.get_players(true)
        for i, enemy in pairs(enemies) do
            local enemy_weapon = entity.get_classname(entity.get_player_weapon(enemy))
            local enemy_origin = vector(entity.get_origin(enemy))
            local lp_origin = vector(entity.get_origin(entity.get_local_player()))
            local distance = (enemy_origin:dist(lp_origin) / 17)

            if (distance < 20) and enemy_weapon == "CWeaponTaser" then
                anims_tw.active = true
            else
                anims_tw.active = false
            end
        end
    end

    anims_tw.enable = d_lerp(anims_tw.enable, ((_ui.lua.enable.value and _ui.visuals.taser_warning.value and entity.get_local_player() and entity.is_alive(entity.get_local_player()) and anims_tw.active) or _ui.lua.enable.value and _ui.visuals.taser_warning.value and ui.is_menu_open()) and 0 or 40, frametime)
    anims_tw.alpha = d_lerp(anims_tw.alpha, ((_ui.lua.enable.value and _ui.visuals.taser_warning.value and entity.get_local_player() and entity.is_alive(entity.get_local_player()) and anims_tw.active) or _ui.lua.enable.value and _ui.visuals.taser_warning.value and ui.is_menu_open()) and 255 or 0, frametime)

    renderer.rectangle((screen_size.x/2) - 7 - 11, screen_size.y/2 - 74 - 40 - math.floor(anims_tw.enable), 38, 38, 0,0,0, anims_tw.alpha)
    renderer.rectangle((screen_size.x/2) - 6 - 11, screen_size.y/2 - 73 - 40 - math.floor(anims_tw.enable), 36, 36, 66,66,66, anims_tw.alpha)
    renderer.rectangle((screen_size.x/2) - 5 - 11, screen_size.y/2 - 72 - 40 - math.floor(anims_tw.enable), 34, 34, 41,41,41, anims_tw.alpha)
    renderer.rectangle((screen_size.x/2) - 4 - 11, screen_size.y/2 - 71 - 40 - math.floor(anims_tw.enable), 32, 32, 66,66,66, anims_tw.alpha)
    renderer.rectangle((screen_size.x/2) - 3 - 11, screen_size.y/2 - 70 - 40 - math.floor(anims_tw.enable), 30, 30, 18,18,18, anims_tw.alpha)

    renderer.rectangle((screen_size.x/2) - 3 - 11, screen_size.y/2 - 70 - 40 - math.floor(anims_tw.enable), 30, 30, 18,18,18, anims_tw.alpha)
    renderer.rectangle((screen_size.x/2) - 3 - 11, screen_size.y/2 - 70 - 40 - math.floor(anims_tw.enable), 30, 1, color[1],color[2],color[3], anims_tw.alpha)

    renderer.texture(taser_icon, (screen_size.x/2) - 10, screen_size.y/2 - 102 - math.floor(anims_tw.enable), 20, 15, 230, 230, 230, anims_tw.alpha, "f")
    renderer.text(screen_size.x/2 - renderer.measure_text("-", "YOU  CAN  BE  ZEUSED")/2, screen_size.y/2 - 73 - math.floor(anims_tw.enable), 255, 255, 255, anims_tw.alpha, "-", 0, "YOU  CAN  BE  ZEUSED")
end

-- { target tracer }

local target_tracer = function()
    if not _ui.visuals.tracer.value then return end

    local target = client.current_threat()

    if not target then
        return
    end

    local color = {_ui.visuals.tracer.color:get()}
    local to_origin = vector(entity.get_origin(client.current_threat()))
    local origin_to_screen = vector(renderer.world_to_screen(to_origin.x, to_origin.y, to_origin.z))
    local screen_size = vector(client.screen_size())

    if  ((origin_to_screen.x ~= nil) and (origin_to_screen.y ~= nil)) and ((origin_to_screen.x ~= 0) and (origin_to_screen.y ~= 0)) then
        renderer.line(screen_size.x/2, screen_size.y, origin_to_screen.x, origin_to_screen.y, color[1], color[2], color[3], color[4])
    end
end

-- {{ misc features }}

-- { automatic teleport }

local teleport = function(cmd)
    if not _ui.other.auto_teleport.value or not _ui.lua.enable.value or ui.get(ref.quick_peek[2]) or not ui.get(ref.doubletap[2]) or 
    (entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponSSG08" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponAWP") then return end

    local vel_2 = math.floor(entity.get_prop(entity.get_local_player(), "m_vecVelocity[2]"))

    if is_vulnerable() and vel_2 < 20 then
        cmd.in_jump = false
        cmd.discharge_pending = true
    end
end

-- { console filter }

ui.set_callback(_ui.other.console_filter.ref, function()
    cvar.con_filter_text:set_string("cool text")
    cvar.con_filter_enable:set_int(1)
end)

-- { clantag }

local call_once = false
local clantag = function()
    if not _ui.other.clantag.value then if call_once then client.set_clan_tag("") call_once = false end return end
    client.set_clan_tag("gamesense.tools")
    call_once = true
end

-- { shit talking }

local phrases = {
    ru_aggressive = {"1 петушара ебаная", "кузя ко мне", "соуфиф напастил, но тебе не помогло", "Такого даже скит не забустит", "Уебак, опять тебя убил","Такого даже фиксики не починят", "Такого даже wraith recode не забустит", "Тебе даже кряк не поможет","Иди конфиг прикупи","Аситеч байни, но он не поможет","Джутикс за тебя играет?","Ты что адреналин вьебал?","Зай, не плачь","Опять умер","1","Брокси не поможет","Иди поспи","В *death*","Хорошо глатаешь", "Опять тебя унизили","Не плачь, завтра в школу", "ебать я тебе по голове наебашил", "отключаю тебе сознание", "print(string.rep('ez', 228))", "кто здесь", "?", "В *spectator*","gamesense.tools - лучший ресольвер","здаров", "effortless", "всем ку пидорасы", "oh my god vot eto one tap", "попался хлопец", "кузя", "Хуя ты улетел", "f12", "трештолк (успокаивающий)", "зубы выпали, но не ссы, это молочные", "оправдания?", "1 дегенерат нерусский", "юид полиция подъехала открывай дверь уебыч", "iqless kid wanna be ahead", "jatos подал мне скаут и я тапнул тебя", "За тебя sky играет?", "Ты что скай что бы так играть?", "За такого даже бекап не выйдут", "Даже джутикс без чита лучше играет","Пиздец, крякера убили","Ру паста не забустила","Улетел с ванвея","Скит забустил","Куда бежишь?","gamesense.tools - Лучшая луа на маркете"},
    ru_retarded = {"когда видишь жопу горилы и такой кончаешь 3 раза","ЪЪЪЪ)))) ооппоповап ЪЪЪ БББЮ","world of tanks blitz (◣_◢)","ты когда срал последний раз?","бля яйцо почесал заеюись ваще","а у вас тоже говно на улице летает?","Тронуло до самой души! Читать всем! Звонок в час ночи: -Алло.","как же я хочу насрать тебе горячего поносика на личико","мяу я срать хочу","у вас тоже залупа начинает светиться после 4:61?","сколько у тебя волос на яйцах? У меня вот 482","кто хохол + в чат","all dogs scared when i pull out my black dick (◣_◢)","от меня вчера убежал хуй","моё говно превратилось в монстра и выебало мою собаку","ёбля армян на 8 марта","евромайдан","We are still in some last-minute testing phase; GameSense #counterstrike2 will be pushed to live builds within 24hrs-72hrs max; it probably will be sooner than that","собачий хуй на вкус как сковородка","Кастюм шалбар сатылады почти новый екеуы 55 мын +7 778 839 24 15","каловый голем  celsh rayaль","ЩЕДРОЕ НАСеКОМОЕ 913","FURUNKUL","#Coca-Cola","калькулятр когда у множил на 0","ликвидирован","СВО","varikoz","бог седит на небе","адольф гитлер 19 срать дрочить говно сиськи мясо карандаш комбайн 78","кабинет лучевой диагностики","я помню вместо залупы прикрутил пропеллер и улетел бомбить ирак","ты когда-нибудь ебал лошадь микрофоном?","а ты умеешь срать с трюками?"},
    eng_aggresive = {"is your monitor on?", "the only thing lower than your kd ratio is your iq", "1 (ez)", "nice iq", "?", "what did u just try to do?", "nigga wha u doin", "next time use ur brain", "nice try nigger", "problem?", "big iq gaming:", "1", "well played, have a good day", "missed? try rebooting the computer", "seems like u have not enabled ragebot", "The only one dumber than you is", "gamesense.tools - buy or lose again", "Are you able to think?", "insert > ragebot > enable", "my balls play better than you"},
    cn_aggressive = {"一个该死的混蛋","库兹亚给我","即使是天鹅也比不上","连巫师重码都打不过","就算是裂缝也帮不了你","去换个配置吧","Jutix在为你演奏吗？","你把你的肾上腺素搞砸了？","别哭","又死了","1","布洛克西不会帮忙的","去睡会儿吧","在死亡中","你真差劲","你又被羞辱了","别哭，明天还要上学","我他妈的打了你的头","把你打晕了","print(string.rep('ez',228))","谁在这里？","?", "在*观望者*","你好","不费吹灰之力","你们这些基佬","天啊，这是HS","我抓到你了","库兹亚","你他妈的飞走了","f12", "TRESHTALK（舒缓）","牙齿掉了，但别撒尿，那是乳牙","借口？","一个堕落的人","警察来了 开门，混蛋","没智商的孩子想出人头地","贾托斯给了我一个球探，我挖了你","天空在为你演奏吗？","你是天空吗？","你甚至不能为这样的人找个替补","连Jutix不读都能打得更好","妈的，他们杀了饼干","RU面条不要助推","斯基特被干掉了","你要去哪儿？","gamesense.tools"}
}

local revenge_target = nil
local current_phrase_index = 1 
local shit_talking = function(e)
    if not _ui.other.shit_talk.value then return end

    local who = e.userid
    local attacker = e.attacker
    local get_phrases = _ui.other.st_mode.value == "[RU] Aggressive" and phrases.ru_aggressive or _ui.other.st_mode.value == "[RU] Retarded" and phrases.ru_retarded or _ui.other.st_mode.value == "[ENG] Aggressive" and phrases.eng_aggresive or _ui.other.st_mode.value == "[CN] Aggressive" and phrases.cn_aggressive
    local get_phrase = get_phrases[current_phrase_index]

    if _ui.other.st_revenge.value then 
        if client.userid_to_entindex(who) == entity.get_local_player() then 
            revenge_target = client.userid_to_entindex(attacker) 
        elseif client.userid_to_entindex(who) == revenge_target and revenge_target ~= entity.get_local_player() then
            client.delay_call(math.random(0.5, 2), function() client.exec("say 1.") end)
        end
    end

    if client.userid_to_entindex(attacker) == entity.get_local_player() and client.userid_to_entindex(who) ~= entity.get_local_player() then
        client.delay_call(math.random(0.5, 2), function() client.exec("say "..get_phrase) end)
        current_phrase_index = (current_phrase_index % #get_phrases) + 1
    end
end

-- { anim breakers }

local char_ptr = ffi.typeof('char*')
local nullptr = ffi.new('void*')
local class_ptr = ffi.typeof('void***')
local animation_layer_t = ffi.typeof([[
    struct {										char pad0[0x18];
        uint32_t	sequence;
        float		prev_cycle;
        float		weight;
        float		weight_delta_rate;
        float		playback_rate;
        float		cycle;
        void		*entity;						char pad1[0x4];
    } **
]])

local animation_breakers = function()
    if not _ui.other.anim_breakers_enable.value or not entity.get_local_player() then return end

    local pEnt = ffi.cast(class_ptr, native_GetClientEntity(entity.get_local_player()))
    if pEnt == nullptr then return end
    local anim_layers = ffi.cast(animation_layer_t, ffi.cast(char_ptr, pEnt) + 0x2990)[0][6]
    local state = get_state(get_velocity())
    
    if contains(_ui.other.anim_breakers.value, "Legs") then
        if _ui.other.anim_breakers_move.value == "Static" then
            ui.set(ref.legs, "Always slide")
            entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 1, 0)
        elseif _ui.other.anim_breakers_move.value == "Walking" then
            entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 0.5, 7)
            ui.set(ref.legs, 'Never slide')
        end

        if state == 4 or state == 5 then
            if _ui.other.anim_breakers_air.value == "Static" then
                entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 1, 6)
            elseif _ui.other.anim_breakers_air.value == "Walking" then
                anim_layers.weight = 1
            end
        end
    end

    if contains(_ui.other.anim_breakers.value, "Landing") and ground_tick > 5 and ground_tick < 100 then
        entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 0.5, 12)
    end
end

-- {{ callbacks }}
client.set_event_callback("paint_ui", function()
    if ui.is_menu_open() then
        hide_refs(_ui.lua.enable.value)
        visiblity()
    end

    local target = client.current_threat()
    if target then local threat_origin = vector(entity.get_origin(target)) threat_origin_wts_x = renderer.world_to_screen(threat_origin.x, threat_origin.y, threat_origin.z) end

    custom_menu_control()
    renderer_notification()
    renderer_trace_positions()
    indicators()
    watermark()
    taser_warning()
    target_tracer()
end)

client.set_event_callback("setup_command", function(cmd)
    local player = player()

    prevent_mouse(cmd)
    peek_bot(cmd)
    track_exploit(cmd, player)
    antiaim_builder(cmd)
    teleport(cmd)
end)

client.set_event_callback('net_update_end', function()
    local player = player()

    resolver.init()
    defensive_resolver()
    clantag()

    if player ~= 0 then
        vars.simtime_backup = entity.get_prop(player, "m_flSimulationTime")
    end
end)

client.set_event_callback("pre_render", function()
    animation_breakers()
end)

client.set_event_callback("aim_hit", function(e)
    if resolver.bruteforce[e.target] and resolver.bruteforce[e.target] > 0 and entity.get_prop(e.target, 'm_iHealth') < 1 then
        resolver.bruteforce[e.target] = 0
    end

    aimbot_logs_hit(e)
end)

client.set_event_callback("aim_miss", function(e)
    if e.reason == '?' then
        if not resolver.bruteforce[e.target] then
            resolver.bruteforce[e.target] = 0
        end

        resolver.bruteforce[e.target] = resolver.bruteforce[e.target] + 1

        if resolver.bruteforce[e.target] > 2 then
            resolver.bruteforce[e.target] = 0
        end
    end

    aimbot_logs_miss(e)
end)

client.set_event_callback("aim_fire", function(e)
    bot_data.shot_fired = true
    bot_data.reload_timer = globals.realtime() + 1.23

    inattack()
end)

client.set_event_callback("player_death", function(e)
    shit_talking(e)
    if revenge_target ~= nil and client.userid_to_entindex(e.userid) == revenge_target and client.userid_to_entindex(e.attacker) == entity.get_local_player() then revenge_target = nil end
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        right_dir = false
        left_dir = false
    end
end)

client.set_event_callback("round_start", function()
    revenge_target = nil     
    right_dir = false 
    left_dir = false 
end)

client.set_event_callback("shutdown", function()
    hide_refs(false)
    client.set_clan_tag("")
end)