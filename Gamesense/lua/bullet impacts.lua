local ffi = require("ffi")

local bullet_impacts = ui.new_checkbox("visuals", "effects", "Bullet impacts")
local server_color = ui.new_color_picker("visuals", "effects", "Server impacts", 0, 0, 255, 127)
local bullet_impacts_duration = ui.new_slider("visuals", "effects", "\nbullet_impacts_duration", 1, 20, 4, true, "s")
local client_color = ui.new_color_picker("visuals", "effects", "Client impacts", 255, 0, 0, 127)

ui.set_callback(bullet_impacts, function(s)
    local state = ui.get(s)
    ui.set_visible(server_color, state)
    ui.set_visible(bullet_impacts_duration, state)
    ui.set_visible(client_color, state)
end)

ffi.cdef[[
    struct vec3_t_piajndfhijnad8fnh8uandfh {
		float x;
		float y;
		float z;	
    };
    struct CCSWeaponData_t_anuihjzfdhnadf8zuhadfnh {
        char _0x0000[0x108];
        float flRange;
    };
    typedef struct CCSWeaponData_t_anuihjzfdhnadf8zuhadfnh*(__thiscall* get_ccs_weapon_info_t)(void*);
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef void(__thiscall* add_box_overlay_t)(void*, const struct vec3_t_piajndfhijnad8fnh8uandfh&, const struct vec3_t_piajndfhijnad8fnh8uandfh&, const struct vec3_t_piajndfhijnad8fnh8uandfh&, struct vec3_t_piajndfhijnad8fnh8uandfh const&, int, int, int, int, float);
]]

local get = ui.get
local new, cast = ffi.new, ffi.cast
local get_local_player, get_player_weapon, get_prop = entity.get_local_player, entity.get_player_weapon, entity.get_prop
local weapon_accuracy_nospread, weapon_recoil_scale = cvar.weapon_accuracy_nospread, cvar.weapon_recoil_scale
local userid_to_entindex, key_state, camera_angles, eye_position, trace_line = client.userid_to_entindex, client.key_state, client.camera_angles, client.eye_position, client.trace_line

local voidptr = ffi.typeof("void***")
local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = cast(voidptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)

local debug_overlay = cast(voidptr, client.create_interface("engine.dll", "VDebugOverlay004"))
local add_box_overlay = cast("add_box_overlay_t", debug_overlay[0][1])
local nrcl = ui.reference("rage", "other", "remove recoil")
local rbot, rbothk = ui.reference("rage", "aimbot", "enabled")

local sin, cos, rad = math.sin, math.cos, math.rad
function angle_forward( angle ) -- angle -> direction vector (forward)
    if angle[1] ~= nil and angle[2] ~= nil then 
        local sin_pitch = sin( rad( angle[1] ) )
        local cos_pitch = cos( rad( angle[1] ) )
        local sin_yaw   = sin( rad( angle[2] ) )
        local cos_yaw   = cos( rad( angle[2] ) )
    
        return {        
            cos_pitch * cos_yaw,
            cos_pitch * sin_yaw,
            -sin_pitch
        }
    end
    return {
        nil
    }
end

local function draw_impact(x,y,z, color)
    local r,g,b,a = get(color)
    local dur = get(bullet_impacts_duration)

    local position = new("struct vec3_t_piajndfhijnad8fnh8uandfh")
    position.x = x position.y = y position.z = z
    local mins = new("struct vec3_t_piajndfhijnad8fnh8uandfh")
    mins.x = -2 mins.y = -2 mins.z = -2
    local maxs = new("struct vec3_t_piajndfhijnad8fnh8uandfh")
    maxs.x = 2 maxs.y = 2 maxs.z = 2
    local ori = new("struct vec3_t_piajndfhijnad8fnh8uandfh")
    ori.x = 0 ori.y = 0 ori.z = 0

    add_box_overlay(debug_overlay, position, mins, maxs, ori, r, g, b, a, dur)
end

client.set_event_callback("aim_fire", function(e)
    if get(bullet_impacts) then 
        draw_impact(e.x,e.y,e.z, client_color)
    end
end)

client.set_event_callback("bullet_impact", function(e)
    local entindex = userid_to_entindex(e.userid)
    local me = get_local_player()
    if entindex == me and get(bullet_impacts) then 
        draw_impact(e.x,e.y,e.z, server_color)
    end
end)

client.set_event_callback("weapon_fire", function(e)
    local entindex = userid_to_entindex(e.userid)
    local me = get_local_player()

    if entindex == me and key_state(0x01) and get(bullet_impacts) and not e.weapon:find("knife") then 
        local pitch, yaw = camera_angles()
        local punch = {get_prop(me, "m_aimPunchAngle")}

        if weapon_accuracy_nospread:get_int() == 0 and not get(nrcl) then 
            pitch = pitch + (punch[1] * weapon_recoil_scale:get_float())
            yaw = yaw + (punch[2] * weapon_recoil_scale:get_float())
        end

        local wpnent = cast(voidptr, get_client_entity(ientitylist, get_player_weapon(me)))
        if wpnent == nil then return end
        local get_ccs_weapon_info = cast("get_ccs_weapon_info_t", wpnent[0][460])
        local ccsweaponinfo = get_ccs_weapon_info(wpnent)
        local range = ccsweaponinfo.flRange

        local fwd = angle_forward( { pitch, yaw } )
        if fwd[1] == nil then 
            return
        end
        local start_pos = { eye_position() }
        local fraction = trace_line(me, 
            start_pos[1],
            start_pos[2],
            start_pos[3],
            start_pos[1] + (fwd[1] * range),
            start_pos[2] + (fwd[2] * range),
            start_pos[3] + (fwd[3] * range))

        if fraction < 1 then 
            local end_pos = {
                start_pos[1] + (fwd[1] * (range * fraction)),
                start_pos[2] + (fwd[2] * (range * fraction)),
                start_pos[3] + (fwd[3] * (range * fraction)),
            }
            draw_impact(end_pos[1],end_pos[2],end_pos[3], client_color)
        end
    end
end)