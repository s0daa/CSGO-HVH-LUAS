local square_root = math.sqrt
local math_ceil = math.ceil
local math_floor = math.floor
local math_abs = math.abs

local globals_curtime = globals.curtime
local globals_tickinterval = globals.tickinterval
local globals_tickcount = globals.tickcount

local ui_get = ui.get
local ui_set = ui.set

local entity_get_prop = entity.get_prop
local entity_get_local_player = entity.get_local_player

local ref_pitch = ui.reference("AA", "Anti-aimbot angles", "pitch")
local ref_twist = ui.reference("AA", "Anti-aimbot angles", "twist")

local lbyflickup = ui.new_checkbox("AA", "Other", "LBY Flick Up")

local stored_pitch = nil
local last_inair_tick = nil

local ticks_till_update = 0
local predicted_lby_update = 0

local do_only_once = true
local should_break = false
local should_break1 = false

local function time_to_ticks(dt)
	return math_floor(0.5 + dt / globals_tickinterval() - 3)
end
local function run_command(e)

	if not ui_get(lbyflickup) then return end
	local local_player = entity_get_local_player()
	local current_pitch = ui_get(ref_pitch)
	if local_player == nil or entity_get_prop(local_player, "m_lifeState") ~= 0 then 
		if current_pitch ~= stored_pitch then
			ui_set(ref_pitch, stored_pitch)
		end
	return
	end
	
	if not should_break and not should_break1 then
		if stored_pitch ~= current_pitch then
			stored_pitch = current_pitch
		end
	
		should_break = false
		should_break1 = false
	end
	
	local notchoking = e.chokedcommands == 0
	
	local velocity_x, velocity_y, velocity_z  = entity_get_prop(local_player, "m_vecVelocity")
	local velocity = square_root(velocity_x^2 + velocity_y^2)
	local onground = velocity_z == 0
	if not onground then
		last_inair_tick = globals_tickcount()
	end
	if last_inair_tick ~= nil and last_inair_tick + 3 > globals_tickcount() then
		onground = false
	end
	
	if not onground then
		should_break = false
		should_break1 = false
		return
	end
	
	if predicted_lby_update ~= nil then
		ticks_till_update = time_to_ticks(predicted_lby_update - globals_curtime())
	end
	if notchoking and onground then
		if velocity > 0.1 then
			predicted_lby_update = globals_curtime() + 0.22
			should_break = false
			should_break1 = false
		else
			if predicted_lby_update ~= nil then
				if globals_curtime() > predicted_lby_update then	
					should_break = true	
					predicted_lby_update = globals_curtime() + 1.1 
				else
					should_break = false
				end
			end
		end 
	end
	
	
	if predicted_lby_update == nil or math_abs(predicted_lby_update) <= -25 then
		if stored_pitch ~= current_pitch then
			stored_pitch = current_pitch
		end
		should_break = false
		should_break1 = false
		return
	end
	
	if ui_get(ref_twist) then
		if ticks_till_update ~= nil then 
			if (ticks_till_update <= -3 or ticks_till_update == 65 or ticks_till_update == 64) and not should_break then
				should_break1 = true
			else
				should_break1 = false
			end
		end
	end
	
	if should_break or should_break1 then
		if current_pitch ~= "Up" then
			ui_set(ref_pitch, "Up")
		end
	else
		if current_pitch ~= stored_pitch then
			ui_set(ref_pitch, stored_pitch)
		end
	end
end

client.set_event_callback("run_command", run_command)