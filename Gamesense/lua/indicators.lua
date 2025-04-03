local ui_get, ui_set_visible = ui.get, ui.set_visible

local is_alive, localplayer = entity.is_alive, entity.get_local_player

local outlined_circle, skeet_indicator = renderer.circle_outline, renderer.indicator

local enabled = ui.new_checkbox("Visuals", "Effects", "Enable extra indicators")
local colorpicker = ui.new_color_picker("Visuals", "Effects", "Enable extra indicators", 150, 200, 60, 255)
local label = ui.new_label("Visuals", "Effects", "Secondary color")
local colorpicker2 = ui.new_color_picker("Visuals", "Effects", "Secondary color", 255, 0, 0, 255)
local indicators = ui.new_multiselect("Visuals", "Effects", "Extra indicators", "Local desync", "Fake lag", "Hide shots", "Fake peek", "Resolver override", "Force safe point", "Force body aim")
local showcircle = ui.new_checkbox("Visuals", "Effects", "Deync circle indicator")
local showcircle2 = ui.new_checkbox("Visuals", "Effects", "Fake lag circle indicator")

local get = {

	uiscale = ui.reference("misc", "Settings", "DPI scale"),

	angle = 0,
	aaenabled = ui.reference("aa", "Anti-aimbot angles", "Enabled"),
	yaw = ui.reference("aa", "Anti-aimbot angles", "Body yaw"),

	fakelag = {ui.reference("aa", "Fake lag", "Enabled")},
	fakelaglimit = ui.reference("aa", "Fake lag", "Limit"),
	chockedcmds = {0, 0, 0, 0, 0},

	hideshots = {ui.reference("aa", "Other", "On shot anti-aim")},
	fakepeek = {ui.reference("aa", "Other", "Fake peek")},
	safe = ui.reference("Rage", "Aimbot", "Force safe point"),
	baim = ui.reference("Rage", "Aimbot", "Force body aim")

}

local inds = {
	desync = false,
	fakelag = false,
	hideshots = false,
	fakepeek = false,
	resolver = false,
	safe = false,
	baim = false,

	uiscale = 1
}

local function Lerp(delta, from, to) -----ty t0ny for giving me these fire funcs 
	if (delta > 1) then
		return to
	end
	if (delta < 0) then
		return from
	end
	return from + ( to - from ) * delta
end

local function ColorLerp(value, ranges)
	if value <= ranges[1].start then return ranges[1].color end
	if value >= ranges[#ranges].start then return ranges[#ranges].color end

	local selected = #ranges
	for i = 1, #ranges - 1 do
		if value < ranges[i + 1].start then
			selected = i
			break
		end
	end
	local minColor = ranges[selected]
	local maxColor = ranges[selected + 1]
	local lerpValue = (value - minColor.start) / (maxColor.start - minColor.start)
	return {r = Lerp( lerpValue, minColor.color.r, maxColor.color.r ), g = Lerp( lerpValue, minColor.color.g, maxColor.color.g ), b = Lerp( lerpValue, minColor.color.b, maxColor.color.b )}
end

local function table_contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

local function setvis()
	local indz = ui_get(indicators)
	local on = ui_get(enabled)

	ui_set_visible(colorpicker, on)
	ui_set_visible(indicators, on)

	ui_set_visible(label, on)
	ui_set_visible(colorpicker2, on)

	ui_set_visible(showcircle, on and table_contains(indz, "Local desync") )
	ui_set_visible(showcircle2, on and table_contains(indz, "Fake lag") )

	if on then -- put this beat in here cuz i would assume that my table contains function would cause a lil lag and this reduces it
		inds.desync = table_contains(indz, "Local desync")
		inds.fakelag = table_contains(indz, "Fake lag")
		inds.hideshots = table_contains(indz, "Hide shots")
		inds.fakepeek = table_contains(indz, "Fake peek")
		inds.resolver = table_contains(indz, "Resolver override")
		inds.safe = table_contains(indz, "Force safe point")
		inds.baim = table_contains(indz, "Force body aim")
	end

	local uiscale = ui_get(get.uiscale)

	if uiscale == "100%" then -- i also assume that this would probz reduce lag
		inds.uiscale = 1
	elseif uiscale == "125%" then
		inds.uiscale = 2
	elseif uiscale == "150%" then
		inds.uiscale = 3
	elseif uiscale == "175%" then
		inds.uiscale = 4
	else
		inds.uiscale = 5
	end
end

ui.set_callback(enabled, setvis)
ui.set_callback(indicators, setvis)
ui.set_callback(get.uiscale, setvis)
setvis()

client.set_event_callback("setup_command", function(c) --stolen from rave1337 lmao
	if ui_get(enabled) then
		if inds.desync and ui_get(get.aaenabled) and ui_get(get.yaw) ~= "Off" then
			if c.chokedcommands == 0 then
				if c.in_use == 1 then
					get.angle = 0
				else
					get.angle = math.min(57, math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)*120-60))
				end
			end
		end

		table.insert(get.chockedcmds, 1, c.chokedcommands)
		table.remove(get.chockedcmds, 6)
	end
end)

client.set_event_callback("paint", function()
	if ui_get(enabled) and is_alive(localplayer()) then
		local r, g, b, a = ui_get(colorpicker)
		local r2, g2, b2, a2 = ui_get(colorpicker2)

		if inds.desync and ui_get(get.aaenabled) and ui_get(get.yaw) ~= "Off" then
			
			local percent = get.angle/57
			local color = ColorLerp(percent, {[1] = {start = 0, color = {r = r2, g = g2, b = b2}}, [2] = {start = 1, color = {r = r, g = g, b = b}}})

			local ind_y = skeet_indicator(color.r, color.g, color.b, 255, "FAKE")

			if ui_get(showcircle) then
				ind_y = ind_y + 20 + ((inds.uiscale - 1) * 3.5)
				local ind_x = 86 + ((inds.uiscale - 1) * 20)
				local size = 10 + ((inds.uiscale - 1) * 4)
				local thickness = 6 + ((inds.uiscale - 1) * 2)
				outlined_circle(ind_x, ind_y, 0, 0, 0, 155, size, 0, 1, thickness)
				if percent >= 0.99 then percent = percent + 0.01 end -- i do the little + 0.01 to make the circle full even if it isnt at 100% desync, it looks way nicer then without it 
				outlined_circle(ind_x, ind_y, color.r, color.g, color.b, 255, size - 1, 0, percent, thickness - 2) 
			end
		end

		if inds.fakelag and ui_get(get.fakelag[1]) and ui_get(get.fakelag[2]) then -- this part is horrible cuz i wanted to get it done
			local percent = get.chockedcmds[1]/ui_get(get.fakelaglimit)
			local color = ColorLerp(percent, {[1] = {start = 0, color = {r = r2, g = g2, b = b2}}, [2] = {start = 1, color = {r = r, g = g, b = b}}})
			if ui_get(showcircle2) then
				local ind_y = skeet_indicator(color.r, color.g, color.b, 255, "FL")
				ind_y = ind_y + 20 + ((inds.uiscale - 1) * 3.5)
				local ind_x = 60 + ((inds.uiscale - 1) * 10)
				local size = 10 + ((inds.uiscale - 1) * 4)
				local thickness = 6 + ((inds.uiscale - 1) * 2)
				outlined_circle(ind_x, ind_y, 0, 0, 0, 155, size, 0, 1, thickness)
				outlined_circle(ind_x, ind_y, color.r, color.g, color.b, 255, size - 1, 0, percent, thickness - 2)  
			else
				local str = "FL "
				for i, v in ipairs(get.chockedcmds) do
					if i ~= 5 then
						str = str.. tostring(v).. " - "
					else
						str = str.. tostring(v)
					end
				end
				skeet_indicator(color.r, color.g, color.b, 255, str)
			end
		end

		if inds.hideshots and ui_get(get.hideshots[1]) and ui_get(get.hideshots[2]) then
			skeet_indicator(r, g, b, 255, "HS")
		end

		if inds.fakepeek and ui_get(get.fakepeek[1]) and ui_get(get.fakepeek[2]) then
			skeet_indicator(r, g, b, 255, "FP")
		end

		if inds.safe and ui_get(get.safe) then
			skeet_indicator(r, g, b, 255, "SAFE")
		end

		if inds.baim and ui_get(get.baim) then
			skeet_indicator(r, g, b, 255, "BAIM")
		end
	end
end)