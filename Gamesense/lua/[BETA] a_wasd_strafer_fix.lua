local strafer = ui.reference('MISC', 'Movement', 'Air strafe')
local strafer_direction = ui.reference('MISC', 'Movement', 'Air strafe direction')
local strafer_smoothing = ui.reference('MISC', 'Movement', 'Air strafe smoothing')

local contains = function(tab, val) for i = 1, #tab do if tab[i] == val then return true; end end; return false end
local clamp = function(val, min, max) local value = val; value = value < min and min or value; value = value > max and max or value; return value end

local command = function(e)
    if not ui.get(strafer) or not contains(ui.get(strafer_direction), 'Movement keys') or e.in_jump == 0 then
        ui.set(strafer_smoothing, 0)
        return
    end

    local list = {
        e.in_forward, 
        e.in_back,
        e.in_moveleft,
        e.in_moveright
    }
    
    local air_accel = cvar.sv_airaccelerate:get_int()
    local end_val = -0.614*air_accel + 686/11

    ui.set(strafer_smoothing, clamp(end_val, 1, 60))

    if air_accel <= 45 and not contains(list, 1) then
        ui.set(strafer_smoothing, 0)
    end
end

client.set_event_callback('setup_command', command)
