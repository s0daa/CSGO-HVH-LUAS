local strafer = ui.reference('MISC', 'Movement', 'Air strafe')
local strafer_direction = ui.reference('MISC', 'Movement', 'Air strafe direction')
local strafer_smoothing = ui.reference('MISC', 'Movement', 'Air strafe smoothing')
local slowmotion = { ui.reference('AA', 'Other', 'Slow motion') }

local movement_keys_only = ui.new_checkbox('MISC', 'Movement', 'WASD Strafe only')

local ffi_cache = { }
local invoke_cache = function(condition, should_call, a, b) local name = tostring(condition); ffi_cache[name] = ffi_cache[name] or ui.get(condition); if should_call then if type(a) == 'function' then a() else ui.set(condition, a); end else if ffi_cache[name] ~= nil then if b ~= nil and type(b) == 'function' then b(ffi_cache[name]); else ui.set(condition, ffi_cache[name]); end ffi_cache[name] = nil; end end end

local contains = function(tab, val) for i = 1, #tab do if tab[i] == val then return true; end end; return false end
local clamp = function(val, min, max) local value = val; value = value < min and min or value; value = value > max and max or value; return value end

local command = function(e)
    local wasd_only = ui.get(movement_keys_only)

    local air_accel = cvar.sv_airaccelerate:get_int()
    local end_val = -0.614*air_accel + 686/11

    local list = { e.in_forward, e.in_back, e.in_moveleft, e.in_moveright }
    local can_sharp = air_accel <= 45 and not contains(list, 1) or e.in_jump == 0

    local passed = false
    local in_speed = e.in_speed == 1
    local in_slowmo = ui.get(slowmotion[1]) and ui.get(slowmotion[2])

    if in_speed and in_slowmo then
        passed = true
        e.in_speed = 0
    end

    local me = entity.get_local_player()
    local vec_vel = { entity.get_prop(me, 'm_vecVelocity') }

    local in_air = e.in_jump == 1 or vec_vel[3]^2 > 0
    local velocity = math.floor(math.sqrt(vec_vel[1]^2 + vec_vel[2]^2) + 0.5)

    invoke_cache(strafer, not wasd_only and in_speed and in_air, false)
    ui.set(strafer_smoothing, can_sharp and 0 or clamp(end_val, 1, 60))
    
    if wasd_only then
        local dir = { 'View angles', 'Movement keys' }

        ui.set(strafer, in_air and velocity > 10 and not passed)
        ui.set(strafer_direction, contains(list, 1) and dir or { dir[1] })
    end
end

local shutdown = function()
    invoke_cache(strafer, false)
end

client.set_event_callback('setup_command', command)
client.set_event_callback('shutdown', shutdown)
