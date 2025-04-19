local globals_realtime = globals.realtime
local client_userid_to_entindex = client.userid_to_entindex
local entity_get_local_player = entity.get_local_player
local entity_get_prop = entity.get_prop
local client_exec = client.exec
local client_draw_line = client.draw_line
local client_draw_rectangle = client.draw_rectangle
local client_get_cvar = client.get_cvar
local ui_set = ui.set
local ui_get = ui.get
local math_sqrt = math.sqrt

local remove_zoom_reference = ui.reference("VISUALS", "Effects", "Remove scope overlay")
local wallbang_crosshair_reference = ui.reference("VISUALS", "Other ESP", "Penetration reticle")
local fov_changer_reference = ui.reference("MISC", "Miscellaneous", "Override FOV")
local fov_changer_old = nil
local fov_changer_default = 90
local fov_changer_hidezoom = 80
local fov_changer_hidezoom_high_vel = 89

local crosshaircolor_r_old = nil
local crosshaircolor_g_old = nil
local crosshaircolor_b_old = nil

local has_applicable_weapon = false

local function calculate_velocity(entindex)
	local velocityX, velocityY = entity_get_prop(entindex, "m_vecVelocity[0]"), entity_get_prop(entindex, "m_vecVelocity[1]")
	local velocity = math_sqrt(velocityX^2 + velocityY^2)
	return velocity
end

local function on_item_equip(e)
	local userid, item = e.userid, e.item
	if userid == nil then
		has_applicable_weapon = false
		return
	end
	local entindex = client_userid_to_entindex(userid)
	if entindex == entity_get_local_player() then
		has_applicable_weapon = (item == "aug" or item == "sg556")
	end
end

local function on_paint(ctx)
	local screen_width, screen_height = client.screen_size()
	local local_player = entity_get_local_player()
	if local_player == nil then
		return
	end
	if fov_changer_old == nil then
		if has_applicable_weapon then
			local is_scoped = entity_get_prop(local_player, "m_bIsScoped")
			if is_scoped == 1 then
				fov_changer_old = ui_get(fov_changer_reference)
				if ui_get(remove_zoom_reference) == true then
					ui_set(fov_changer_reference, fov_changer_hidezoom)
					crosshaircolor_r_old = client_get_cvar("cl_crosshaircolor_r")
					crosshaircolor_g_old = client_get_cvar("cl_crosshaircolor_r")
					crosshaircolor_b_old = client_get_cvar("cl_crosshaircolor_r")
					client_exec("cl_crosshaircolor_r 0; cl_crosshaircolor_g 0; cl_crosshaircolor_b 0")
				else
					ui_set(fov_changer_reference, fov_changer_default)
				end
			end
		end
	else
		local is_scoped = entity_get_prop(local_player, "m_bIsScoped")
		if is_scoped == 1 then
			local fov_changer = ui_get(fov_changer_reference)
			if fov_changer == fov_changer_hidezoom or fov_changer == fov_changer_hidezoom_high_vel then
				if calculate_velocity(local_player) > 220 then
					ui_set(fov_changer_reference, fov_changer_hidezoom_high_vel)
				else
					if ui_get(wallbang_crosshair_reference) then
						--draw x line
						client_draw_line(ctx, 0, screen_height/2, screen_width/2-1, screen_height/2, 0, 0, 0, 255)
						client_draw_line(ctx, screen_width/2+1, screen_height/2, screen_width, screen_height/2, 0, 0, 0, 255)
						--draw y line
						client_draw_line(ctx, screen_width/2, 0, screen_width/2, screen_height/2-1, 0, 0, 0, 255)
						client_draw_line(ctx, screen_width/2, screen_height/2+1, screen_width/2, screen_height, 0, 0, 0, 255)

					else
						--draw x line
						client_draw_line(ctx, 0, screen_height/2, screen_width, screen_height/2, 0, 0, 0, 255)
						--draw y line
						client_draw_line(ctx, screen_width/2, 0, screen_width/2, screen_height, 0, 0, 0, 255)
					end
					ui_set(fov_changer_reference, fov_changer_hidezoom)
				end
			end
		else
			ui_set(fov_changer_reference, fov_changer_old)
			if crosshaircolor_r_old ~= nil and crosshaircolor_g_old ~= nil and crosshaircolor_b_old ~= nil then
				client_exec("cl_crosshaircolor_r ", crosshaircolor_r_old, "; cl_crosshaircolor_g ", crosshaircolor_g_old, "; cl_crosshaircolor_b ", crosshaircolor_b_old)
			end
			fov_changer_old = nil
			crosshaircolor_r_old = nil
			crosshaircolor_g_old = nil
			crosshaircolor_b_old = nil
		end
	end
end

client.set_event_callback("paint", on_paint)
client.set_event_callback("item_equip", on_item_equip)