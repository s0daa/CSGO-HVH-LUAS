local ffi = require 'ffi'

local defer, error, getfenv, setfenv, getmetatable, setmetatable,
ipairs, pairs, next, printf, rawequal, rawset, rawlen, readfile, writefile, require, select,
tonumber, tostring, toticks, totime, type, unpack, pcall, xpcall =
defer, error, getfenv, setfenv, getmetatable, setmetatable,
ipairs, pairs, next, printf, rawequal, rawset, rawlen, readfile, writefile, require, select,
tonumber, tostring, toticks, totime, type, unpack, pcall, xpcall

local VTable = {
    Entry = function(instance, index, type) return ffi.cast(type, (ffi.cast("void***", instance)[0])[index]) end,
    Bind = function(self, module, interface, index, typestring)
        local instance = client.create_interface(module, interface)
        local fnptr = self.Entry(instance, index, ffi.typeof(typestring))
        return function(...) return fnptr(instance, ...) end
    end
}

local native_get_client_entity = VTable:Bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
local animstate_t = ffi.typeof 'struct { char pad0[0x18]; float anim_update_timer; char pad1[0xC]; float started_moving_time; float last_move_time; char pad2[0x10]; float last_lby_time; char pad3[0x8]; float run_amount; char pad4[0x10]; void* entity; void* active_weapon; void* last_active_weapon; float last_client_side_animation_update_time; int	 last_client_side_animation_update_framecount; float eye_timer; float eye_angles_y; float eye_angles_x; float goal_feet_yaw; float current_feet_yaw; float torso_yaw; float last_move_yaw; float lean_amount; char pad5[0x4]; float feet_cycle; float feet_yaw_rate; char pad6[0x4]; float duck_amount; float landing_duck_amount; char pad7[0x4]; float current_origin[3]; float last_origin[3]; float velocity_x; float velocity_y; char pad8[0x4]; float unknown_float1; char pad9[0x8]; float unknown_float2; float unknown_float3; float unknown; float m_velocity; float jump_fall_velocity; float clamped_velocity; float feet_speed_forwards_or_sideways; float feet_speed_unknown_forwards_or_sideways; float last_time_started_moving; float last_time_stopped_moving; bool on_ground; bool hit_in_ground_animation; char pad10[0x4]; float time_since_in_air; float last_origin_z; float head_from_ground_distance_standing; float stop_to_full_running_fraction; char pad11[0x4]; float magic_fraction; char pad12[0x3C]; float world_force; char pad13[0x1CA]; float min_yaw; float max_yaw; } **'

entity.get_animstate = function(ent)
    local pointer = native_get_client_entity(ent)
    if pointer then return ffi.cast(animstate_t, ffi.cast("char*", ffi.cast("void***", pointer)) + 0x9960)[0] end
end

entity.get_simtime = function(ent)
    local pointer = native_get_client_entity(ent)
    if pointer then return entity.get_prop(ent, "m_flSimulationTime"), ffi.cast("float*", ffi.cast("uintptr_t", pointer) + 0x26C)[0] else return 0 end
end

local Clamp = function(value, min, max) return math.min(math.max(value, min), max) end

local function NormalizeAngle(angle)
    if angle == nil then return 0 end
	while angle > 180 do angle = angle - 360 end
	while angle < -180 do angle = angle + 360 end
	return angle
end

entity.get_max_desync = function(animstate)
    local speedfactor = Clamp(animstate.feet_speed_forwards_or_sideways, 0.0, 1.0)
    local avg_speedfactor = (animstate.stop_to_full_running_fraction * -0.3 - 0.2) * speedfactor + 1

    local duck_amount = animstate.duck_amount
    if duck_amount > 0 then
        local duck_speed = duck_amount * speedfactor

        avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
    end

    return Clamp(avg_speedfactor, .5, 1)
end

local JitterResolver = ui.new_checkbox("RAGE", "Other", "MONSTRYRESOLVER")
local Records = {}
local CResolverMain = function()
    client.update_player_list()
    local Players = entity.get_players()
    for i = 1, #Players do
        local v = Players[i]
        if entity.is_enemy(v) then
            local st_cur, st_pre = entity.get_simtime(v)
            st_cur, st_pre = toticks(st_cur), toticks(st_pre)

            if not Records[v] then Records[v] = setmetatable({}, {__mode = "kv"}) end
            local slot = Records[v]

            slot[st_cur] = {
                pose = entity.get_prop(v, "m_flPoseParameter", 11) * 120 - 60,
                eye = select(2, entity.get_prop(v, "m_angEyeAngles"))
            }

            --
            local value
            local allow = (slot[st_pre] and slot[st_cur]) ~= nil

            if allow then
                local animstate = entity.get_animstate(v)
                local max_desync = entity.get_max_desync(animstate)

                if (slot[st_pre] and slot[st_cur]) and max_desync < .85 and (st_cur - st_pre < 2) then
                    local side = Clamp(NormalizeAngle(animstate.goal_feet_yaw - slot[st_cur].eye), -1, 1)
                    value = slot[st_pre] and (slot[st_pre].pose * side * max_desync) or nil
                end

                if value then plist.set(v, "Force body yaw value", value) end
            end

            plist.set(v, "Force body yaw", value ~= nil)
            plist.set(v, "Correction active", true)
        end
    end
end

local CResolverRestore = function()
    for i = 1, 64 do plist.set(i, "Force body yaw", false) end
    Records = {}
end

local CResolverRun = function()
    if ui.get(JitterResolver) then CResolverMain() else CResolverRestore() end
end

client.set_event_callback("net_update_end", function()
    local LocalPlayer = entity.get_local_player()
    if not LocalPlayer then return end
    CResolverRun()
end)