--[[
	primordial.dev | 2022
	Author: Classy
]]

local aimbot_text = menu.add_text("chicken aimbot", "enable")
local aimbot_render = menu.add_checkbox("chicken aimbot", "render target")
local aimbot_key = aimbot_text:add_keybind("enable")

--@math functions begin
local function vector_angles(vec1, vec2) -- ty aviarita 4 math
    local origin_x, origin_y, origin_z
    local target_x, target_y, target_z
    if x2 == nil then
        target_x, target_y, target_z = vec1.x, vec1.y, vec1.z
        origin_x, origin_y, origin_z = vec2.x, vec2.y, vec2.z
        if origin_x == nil then
            return
        end
    else
        origin_x, origin_y, origin_z = vec1.x, vec1.y, vec1.z
        target_x, target_y, target_z = vec2.x, vec2.y, vec2.z
    end

    local delta_x, delta_y, delta_z = target_x-origin_x, target_y-origin_y, target_z-origin_z

    if delta_x == 0 and delta_y == 0 then
        return (delta_z > 0 and 270 or 90), 0
    else
        local yaw = math.deg(math.atan2(delta_y, delta_x))

        local hyp = math.sqrt(delta_x*delta_x + delta_y*delta_y)
        local pitch = math.deg(math.atan2(-delta_z, hyp))

        return vec2_t(pitch, yaw)
    end
end
--@math functions end

--@aimbot functions begin
local function get_best_target()
	--@entity variables
	local m_local = entity_list.get_local_player()
	local m_chickens = entity_list.get_entities_by_name("CChicken")

	--@target variables
	local best_target = nil

	--@target selection
	for i = 1, #m_chickens do
		local chicken = m_chickens[i]
		if not chicken:is_dormant() then
			local chicken_origin = chicken:get_prop("m_vecOrigin")

			local trace_data = trace.line(m_local:get_eye_position(), chicken_origin, m_local, "MASK_SHOT")

			if (trace_data.entity) and (trace_data.fraction > 0.9) then
				best_target = chicken
			end
		end
	end

	--@target selected
	return best_target
end
--@aimbot functions end

--@callbacks begin
local function on_paint()
	local target = get_best_target()
	if (target and aimbot_render:get()) then
		local origin = target:get_prop("m_vecOrigin")
		local w2s = render.world_to_screen(origin)

		if not w2s then
			return
		end

		render.circle_filled(w2s, 3, color_t(255,255,255))
	end
end

local function on_setup_command(cmd)
	local target = get_best_target()
	local m_local = entity_list.get_local_player()
	
	if not cmd or not target then
		return
	end

	local origin = target:get_prop("m_vecOrigin")
	local shot_angles = vector_angles(origin, m_local:get_eye_position())

	if aimbot_key:get() then
		cmd.viewangles.x = shot_angles.x - 1.5
		cmd.viewangles.y = shot_angles.y
	end
end

callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)
callbacks.add(e_callbacks.PAINT, on_paint)
--@callbacks end