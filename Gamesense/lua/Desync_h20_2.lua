-- Local variables
local client_set_event_callback, client_get_cvar, renderer_indicator, renderer_text, client_screensize = client.set_event_callback, client.get_cvar, renderer.indicator, renderer.text, client.screen_size
local ui_get, ui_set, ui_set_visible, ui_ref, ui_set_callback = ui.get, ui.set, ui.set_visible, ui.reference, ui.set_callback
local entity_get_local_player, entity_get_prop, entity_is_alive = entity.get_local_player, entity.get_prop, entity.is_alive
local lby_updated = false
local next_update = 0
local last_value = 0

-- Anti-aim references
local pitch = ui_ref("AA", "Anti-aimbot angles", "Pitch")
local base = ui_ref("AA", "Anti-aimbot angles", "Yaw base")
local yaw, yaw_slider = ui_ref("AA", "Anti-aimbot angles", "Yaw")
local yawjitter, yawjitter_slider = ui_ref("AA", "Anti-aimbot angles", "Yaw jitter")
local bodyyaw, bodyyaw_slider = ui_ref("AA", "Anti-aimbot angles", "Body yaw")
local limit = ui_ref("AA", "Anti-aimbot angles", "Fake yaw limit")
local edgeyaw = ui_ref("AA", "Anti-aimbot angles", "Edge yaw")
local freestanding = ui_ref("AA", "Anti-aimbot angles", "Freestanding")
local lby = ui_ref("AA", "Anti-aimbot angles", "Lower body yaw")

-- New UI elements
local desync = ui.new_checkbox("AA", "Other", "Desync anti-aim")
local desyncmode = ui.new_combobox("AA", "Other", "Desync mode", "Off", "Default", "Break LBY")
local desyncstyle = ui.new_combobox("AA", "Other", "Desync behaviour", "Off", "Static", "Jitter")
local desynckey = ui.new_hotkey("AA", "Other", "Switch key")
local indmulti = ui.new_multiselect("AA", "Other", "Anti-aim angle indicator", "Text", "Arrows")
local color = ui.new_color_picker("AA", "Other", "Arrow color", 124, 195, 13, 220)
local indmulti2 = ui.new_multiselect("AA", "Other", "Desync data", "Sync", "LBY")

-- Multiselect table
local function contains(table, val)
	for i=1, #table do
		if table[i] == val then 
			return true
		end
	end
	return false
end

-- Anti-aim setup
local function aa_setup()
    ui_set(pitch, "Default")
    ui_set(base, "At targets")
    ui_set(yaw, "180")
    ui_set(limit, "60")
    ui_set(edgeyaw, "Off")
    ui_set(freestanding, "-")
    ui_set(lby, false)
end

-- Menu callback
local function aa_menu_call()
    if not ui_get(desync) then
        ui_set_visible(desyncmode, false)
        ui_set_visible(desyncstyle, false)
        ui_set_visible(desynckey, false)
        ui_set_visible(indmulti, false)
        ui_set_visible(color, false)
        ui_set_visible(indmulti2, false)
    else if ui_get(desync) then
        ui_set_visible(desyncmode, true)
        ui_set_visible(desyncstyle, true)
        ui_set_visible(desynckey, true)
        ui_set_visible(indmulti, true)
        ui_set_visible(color, true)
        ui_set_visible(indmulti2, true)
    end
    end
end
aa_menu_call()
ui_set_callback(desync, aa_menu_call)

-- Manual anti-aims
client_set_event_callback("paint", function()
    if not ui_get(desync) or ui_get(desyncmode) == "Off" or ui_get(desyncstyle) == "Off" or entity_get_local_player() == nil or entity_get_prop(entity_get_local_player(), "m_lifeState") ~= 0 then return end
    
    local value = ui_get(indmulti)
    
    local bFreezeTime = entity_get_prop(entity.get_game_rules(), "m_bFreezePeriod")
    if (bFreezeTime) == 1 then return end
    
    local scrsize_x, scrsize_y = client_screensize()
    local center_x, center_y = scrsize_x / 2, scrsize_y / 2
    local ind_r, ind_g, ind_b, ind_a = ui_get(color)

    local vel_x, vel_y = entity_get_prop(entity_get_local_player(), "m_vecVelocity")
    local vel = math.sqrt(vel_x^2 + vel_y^2)

    ui_set(desynckey, "Toggle")

    if ui_get(desyncmode) == "Default" then
        if ui_get(desyncstyle) == "Static" then
            if ui_get(desynckey) then
                aa_setup()
                ui_set(yaw_slider, "-33")
                ui_set(yawjitter, "Offset")
                ui_set(yawjitter_slider, "0")
                ui_set(bodyyaw, "Static")
                ui_set(bodyyaw_slider, "-180")
                if contains(value, "Text") then
                    renderer_indicator(124, 195, 13, 237, "LEFT")
                end
                if contains(value, "Arrows") then
                    renderer_text(center_x - 40, center_y, ind_r, ind_g, ind_b, ind_a, "c+", 0, "◄")
                    renderer_text(center_x + 40, center_y, 255, 255, 255, 220, "c+", 0, "►")
                end
            else
                aa_setup()
                ui_set(yaw_slider, "8")
                ui_set(yawjitter, "Offset")
                ui_set(yawjitter_slider, "0")
                ui_set(bodyyaw, "Static")
                ui_set(bodyyaw_slider, "180")
                if contains(value, "Text") then
                    renderer_indicator(124, 195, 13, 237, "RIGHT")
                end
                if contains(value, "Arrows") then
                    renderer_text(center_x + 40, center_y, ind_r, ind_g, ind_b, ind_a, "c+", 0, "►")
                    renderer_text(center_x - 40, center_y, 255, 255, 255, 220, "c+", 0, "◄")
                end
            end
        end
        if ui_get(desyncstyle) == "Jitter" then
            if ui_get(desynckey) then
                aa_setup()
                ui_set(yaw_slider, "0")
                ui_set(yawjitter, "Offset")
                ui_set(yawjitter_slider, "20")
                ui_set(bodyyaw, "Opposite")
                if contains(value, "Text") then
                    renderer_indicator(124, 195, 13, 237, "LEFT")
                end
                if contains(value, "Arrows") then
                    renderer_text(center_x - 40, center_y, ind_r, ind_g, ind_b, ind_a, "c+", 0, "◄")
                    renderer_text(center_x + 40, center_y, 255, 255, 255, 220, "c+", 0, "►")
                end
            else
                aa_setup()
                ui_set(yaw_slider, "0")
                ui_set(yawjitter, "Offset")
                ui_set(yawjitter_slider, "-20")
                ui_set(bodyyaw, "Opposite")
                if contains(value, "Text") then
                    renderer_indicator(124, 195, 13, 237, "RIGHT")
                end
                if contains(value, "Arrows") then
                    renderer_text(center_x + 40, center_y, ind_r, ind_g, ind_b, ind_a, "c+", 0, "►")
                    renderer_text(center_x - 40, center_y, 255, 255, 255, 220, "c+", 0, "◄")
                end
            end
        end
    else if ui_get(desyncmode) == "Break LBY" then
        if ui_get(desyncstyle) == "Static" then
            if ui_get(desynckey) then
                aa_setup()
                ui_set(yaw_slider, "0")
                ui_set(yawjitter, "Off")
                ui_set(bodyyaw, "Static")
                ui_set(bodyyaw_slider, "-90")
                if contains(value, "Text") then
                    renderer_indicator(124, 195, 13, 237, "LEFT")
                end
                if contains(value, "Arrows") then
                    renderer_text(center_x - 40, center_y, ind_r, ind_g, ind_b, ind_a, "c+", 0, "◄")
                    renderer_text(center_x + 40, center_y, 255, 255, 255, 220, "c+", 0, "►")
                end
            else
                aa_setup()
                ui_set(yaw_slider, "0")
                ui_set(yawjitter, "Off")
                ui_set(bodyyaw, "Static")
                ui_set(bodyyaw_slider, "90")
                if contains(value, "Text") then
                    renderer_indicator(124, 195, 13, 237, "RIGHT")
                end
                if contains(value, "Arrows") then
                    renderer_text(center_x + 40, center_y, ind_r, ind_g, ind_b, ind_a, "c+", 0, "►")
                    renderer_text(center_x - 40, center_y, 255, 255, 255, 220, "c+", 0, "◄")
                end
            end
        end
        if ui_get(desyncstyle) == "Jitter" then
            if ui_get(desynckey) then
                if vel < 0.0014 then
                    aa_setup()
                    ui_set(yaw_slider, "0")
                    ui_set(yawjitter, "Center")
                    ui_set(yawjitter_slider, "58")
                    ui_set(bodyyaw, "Static")
                    ui_set(bodyyaw_slider, "-90")
                    if contains(value, "Text") then
                        renderer_indicator(124, 195, 13, 237, "LEFT")
                    end
                    if contains(value, "Arrows") then
                        renderer_text(center_x - 40, center_y, ind_r, ind_g, ind_b, ind_a, "c+", 0, "◄")
                        renderer_text(center_x + 40, center_y, 255, 255, 255, 220, "c+", 0, "►")
                    end
                else if vel >= 0.0014 then
                    aa_setup()
                    ui_set(yaw_slider, "0")
                    ui_set(yawjitter, "Center")
                    ui_set(yawjitter_slider, "20")
                    ui_set(bodyyaw, "Opposite")
                    if contains(value, "Text") then
                        renderer_indicator(124, 195, 13, 237, "LEFT")
                    end
                    if contains(value, "Arrows") then
                        renderer_text(center_x - 40, center_y, ind_r, ind_g, ind_b, ind_a, "c+", 0, "◄")
                        renderer_text(center_x + 40, center_y, 255, 255, 255, 220, "c+", 0, "►")
                    end
                end
                end
            else
                if vel < 0.0014 then
                    aa_setup()
                    ui_set(yaw_slider, "0")
                    ui_set(yawjitter, "Center")
                    ui_set(yawjitter_slider, "-58")
                    ui_set(bodyyaw, "Static")
                    ui_set(bodyyaw_slider, "90")
                    if contains(value, "Text") then
                        renderer_indicator(124, 195, 13, 237, "RIGHT")
                    end
                    if contains(value, "Arrows") then
                        renderer_text(center_x + 40, center_y, ind_r, ind_g, ind_b, ind_a, "c+", 0, "►")
                        renderer_text(center_x - 40, center_y, 255, 255, 255, 220, "c+", 0, "◄")
                    end
                else if vel >= 0.0014 then
                    aa_setup()
                    ui_set(yaw_slider, "0")
                    ui_set(yawjitter, "Center")
                    ui_set(yawjitter_slider, "-20")
                    ui_set(bodyyaw, "Opposite")
                    if contains(value, "Text") then
                        renderer_indicator(124, 195, 13, 237, "RIGHT")
                    end
                    if contains(value, "Arrows") then
                        renderer_text(center_x + 40, center_y, ind_r, ind_g, ind_b, ind_a, "c+", 0, "►")
                        renderer_text(center_x - 40, center_y, 255, 255, 255, 220, "c+", 0, "◄")
                    end
                end
            end
        end
    end
end
end
end)

-- Static body yaw
client_set_event_callback("setup_command", function(cmd)
    if not ui_get(desync) or ui_get(desyncmode) == "Off" or ui_get(desyncstyle) == "Off" or ui_get(desyncmode) == "Break LBY" or entity_get_local_player() == nil or entity_get_prop(entity_get_local_player(), "m_lifeState") ~= 0 then return end    
    
    local bFreezeTime = entity_get_prop(entity.get_game_rules(), "m_bFreezePeriod")
    if (bFreezeTime) == 1 then return end
    
    if ui_get(desyncmode) == "Default" then
        if cmd.in_jump ~= 0 then return end
            local sm = cmd.in_duck ~= 0 and 2.941177 or 1.000001
	        sm = cmd.command_number % 4 < 2 and -sm or sm
            cmd.sidemove = cmd.sidemove ~= 0 and cmd.sidemove or sm
        else return
    end
end)

-- LBY breaker
client_set_event_callback("run_command", function()
    if not ui_get(desync) or ui_get(desyncmode) == "Off" or ui_get(desyncstyle) == "Off" or ui_get(desyncmode) == "Default" or entity_get_local_player() == nil or entity_get_prop(entity_get_local_player(), "m_lifeState") ~= 0 then return end

    local bFreezeTime = entity_get_prop(entity.get_game_rules(), "m_bFreezePeriod")
    if (bFreezeTime) == 1 then return end

    if ui_get(desyncmode) == "Break LBY" then
        if ui.is_menu_open() then
            last_value = ui_get(yaw_slider)
        else
            local on_ground = bit.band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1)
            local vel_x, vel_y = entity_get_prop(entity_get_local_player(), "m_vecVelocity")
            local vel = math.sqrt(vel_x^2 + vel_y^2)
            local curtime = globals.curtime()
            if vel > 0.0014 then
                lby_updated = false
                if on_ground then
                    next_update = curtime + 0.22
                else
                    next_update = curtime + 1.1
                end
            end
            if curtime > next_update then
                lby_updated = true
                next_update = curtime + 1.1
                last_value = ui_get(yaw_slider)
                ui_set(yaw_slider, ui_get(bodyyaw_slider))
            else
                ui_set(yaw_slider, last_value)
            end
        end
    else return
    end
end)

-- Color interp
local function g_math(int, max, declspec)
	local int = (int > max and max or int)

	local tmp = max / int;
	local i = (declspec / tmp)
	i = (i >= 0 and math.floor(i + 0.5) or math.ceil(i - 0.5))

	return i
end

local function interpolate_c(number, max)
	local colors = {
        { 255, 0, 0 },
        { 237, 27, 3 },
        { 235, 63, 6 },
        { 229, 104, 8 },
        { 228, 126, 10 },
        { 220, 169, 16 },
        { 213, 201, 19 },
        { 176, 205, 10 },
		{ 124, 195, 13 }	
	}

	i = g_math(number, max, #colors)
	return
	colors[i <= 1 and 1 or i][1], 
    colors[i <= 1 and 1 or i][2],
    colors[i <= 1 and 1 or i][3]
end

-- Desync data
client_set_event_callback("paint", function()
    if not ui_get(desync) or entity_get_local_player() == nil or entity_get_prop(entity_get_local_player(), "m_lifeState") ~= 0 then
        return
    end
    
    local value = ui_get(indmulti2)
    if #value == 0 then return end


    local bFreezeTime = entity_get_prop(entity.get_game_rules(), "m_bFreezePeriod")
    if (bFreezeTime) == 1 then return end

    local scrsize_x, scrsize_y = client_screensize()
    local center_x, center_y = scrsize_x / 2, scrsize_y / 2

    local r = lby_updated and 124 or 255
    local g = lby_updated and 195 or 0
    local b = lby_updated and 13 or 0

    local vel_x, vel_y = entity_get_prop(entity_get_local_player(), "m_vecVelocity")
    local vel = math.sqrt(vel_x^2 + vel_y^2)
    local max_desync = (59 - 58 * vel / 580)
    local c_r, c_g, c_b = interpolate_c(max_desync, 59)

    if contains(value, "Sync") then
        renderer_text(10, center_y - 8, c_r, c_g, c_b, 255, "+", 0, "SYNC")
    end

    if contains(value, "LBY") then
        local outline = outline == nil and true or outline
        local radius = 9
        local start_degrees = 0
        local percent = (next_update - globals.curtime()) / 1.1
        renderer_text(10, center_y - 38, r, g, b, 255, "+", 0, "LBY")
        if vel < 0.0014 then
            if outline then
                renderer.circle_outline(70, center_y - 23.5, 0, 0, 0, 200, radius, start_degrees, 1.0, 5)
            end
            renderer.circle_outline(70, center_y - 23.5, r, g, b, 255, radius - 1, start_degrees, percent, 3)
        else
            return
        end
    end
end)