-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_screen_size, client_set_cvar, math_fmod, tonumber, ui_get, ui_new_slider, ui_set_callback, ui_set_visible = client.screen_size, client.set_cvar, math.fmod, tonumber, ui.get, ui.new_slider, ui.set_callback, ui.set_visible

local function set_aspect_ratio(aspect_ratio_multiplier)
	local screen_width, screen_height = client_screen_size()
	local aspectratio_value = (screen_width*aspect_ratio_multiplier)/screen_height

	if aspect_ratio_multiplier == 1 then
		aspectratio_value = 0
	end
	client_set_cvar("r_aspectratio", tonumber(aspectratio_value))
end

local function gcd(m, n)
	while m ~= 0 do
		m, n = math_fmod(n, m), m
	end

	return n
end

local screen_width, screen_height, aspect_ratio_reference

local function on_aspect_ratio_changed()
	local aspect_ratio = ui_get(aspect_ratio_reference)*0.01
	aspect_ratio = 2 - aspect_ratio
	set_aspect_ratio(aspect_ratio)
end

local multiplier = 0.01
local steps = 200

local function setup(screen_width_temp, screen_height_temp)
	screen_width, screen_height = screen_width_temp, screen_height_temp
	local aspect_ratio_table = {}

	for i=1, steps do
		local i2=(steps-i)*multiplier
		local divisor = gcd(screen_width*i2, screen_height)
		if screen_width*i2/divisor < 100 or i2 == 1 then
			aspect_ratio_table[i] = screen_width*i2/divisor .. ":" .. screen_height/divisor
		end
	end

	if aspect_ratio_reference ~= nil then
		ui_set_visible(aspect_ratio_reference, false)
		ui_set_callback(aspect_ratio_reference, function() end)
	end

	aspect_ratio_reference = ui_new_slider("VISUALS", "Effects", "Force aspect ratio", 0, steps-1, steps/2, true, "%", 1, aspect_ratio_table)
	ui_set_callback(aspect_ratio_reference, on_aspect_ratio_changed)
end
setup(client_screen_size())

local function on_paint(ctx)
	local screen_width_temp, screen_height_temp = client_screen_size()
	if screen_width_temp ~= screen_width or screen_height_temp ~= screen_height then
		setup(screen_width_temp, screen_height_temp)
	end
end
client.set_event_callback("paint", on_paint)