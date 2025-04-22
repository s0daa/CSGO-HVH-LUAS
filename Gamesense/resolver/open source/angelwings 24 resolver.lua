-- #Libraries

local vector = require('vector', 'Missing vector')
local images = require('gamesense/images', 'Download images library: https://gamesense.pub/forums/viewtopic.php?id=22917')
local ffi = require('ffi', 'Failed to require FFI, please make sure Allow unsafe scripts is enabled!')
local antiaim_funcs = require('gamesense/antiaim_funcs', 'Download anti-aim functions library: https://gamesense.pub/forums/viewtopic.php?id=29665')
local c_entity = require('gamesense/entity', 'Download entity library: https://gamesense.pub/forums/viewtopic.php?id=27529')
local http = require('gamesense/http', 'Download HTTP library: https://gamesense.pub/forums/viewtopic.php?id=21619')
local clipboard = require('gamesense/clipboard', 'Download clipboard library: https://gamesense.pub/forums/viewtopic.php?id=28678')
local base64 = require('gamesense/base64', 'Module base64 not found')

-- #creating checkbox
local experimental_resolver = ui.new_checkbox("RAGE", "Other", "\aFF0000FF⚠Experimental resolver")
if not experimental_resolver then
    print("Checkbox creation failed, 'experimental_resolver' is nil.")
end

--#expect sum trubles with "safecall"
local safecall = function(name, report, f)
    return function(...)
        local s, ret = pcall(f, ...)

        if not s then
            local retmessage = "safe call failed [" .. name .. "] -> " .. ret

            if report then
                print(retmessage)
            end

            return false, retmessage
        else
            return ret, s
        end
    end
end

--#operating principle
expres = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}

expres.get_prev_simtime = function(ent)
    local ent_ptr = native_GetClientEntity(ent)    
	if ent_ptr ~= nil then 
		return ffi.cast('float*', ffi.cast('uintptr_t', ent_ptr) + 0x26C)[0] 
	end
end

expres.restore = function ()
	for i = 1, 64 do plist.set(i, "Force body yaw", false) end
end

expres.body_yaw, expres.eye_angles = {}, {}

expres.get_max_desync = function (animstate)
	local speedfactor = math.clamp(animstate.feet_speed_forwards_or_sideways, 0, 1)
	local avg_speedfactor = (animstate.stop_to_full_running_fraction * -0.3 - 0.2) * speedfactor + 1

	local duck_amount = animstate.duck_amount
	if duck_amount > 0 then
		avg_speedfactor = avg_speedfactor + (duck_amount * speedfactor * (0.5 - avg_speedfactor))
	end

	return math.clamp(avg_speedfactor, .5, 1)
end

expres.handle = safecall('experimental_resolver.handle', true, function()
	if not (experimental_resolver and experimental_resolver:get()) then 
		return
	end

	local current_threat = client.current_threat()

    if current_threat == nil or not entity.is_alive(current_threat) or entity.is_dormant(current_threat) then 
		return 
	end

    if expres.body_yaw[current_threat] == nil then 
		expres.body_yaw[current_threat], expres.eye_angles[current_threat] = {}, {}
	end

    local simtime = toticks(entity.get_prop(current_threat, 'm_flSimulationTime'))
	local prev_simtime = toticks(expres.get_prev_simtime(current_threat))
    expres.body_yaw[current_threat][simtime] = entity.get_prop(current_threat, 'm_flPoseParameter', 11) * 120 - 60
    expres.eye_angles[current_threat][simtime] = select(2, entity.get_prop(current_threat, "m_angEyeAngles"))

    if expres.body_yaw[current_threat][prev_simtime] ~= nil then
		local ent = c_entity.new(current_threat)
		local animstate = ent:get_anim_state()
		local max_desync = expres.get_max_desync(animstate)

        local should_correct = (simtime - prev_simtime >= 1) and math.abs(max_desync) < 45 and expres.body_yaw[current_threat][prev_simtime] ~= 0

		if should_correct then
			-- local side = math.clamp(math.normalize_yaw(animstate.goal_feet_yaw - expres.eye_angles[current_threat][simtime]), -1, 1)
			-- local value = expres.body_yaw[current_threat][prev_simtime] * side * max_desync
			local value = math.random(0, expres.body_yaw[current_threat][prev_simtime] * math.random(-1, 1)) * .25

			plist.set(current_threat, 'Force body yaw value', value) 
		end
		plist.set(current_threat, 'Force body yaw', should_correct)     
    end

    plist.set(current_threat, 'Correction active', true)
end)