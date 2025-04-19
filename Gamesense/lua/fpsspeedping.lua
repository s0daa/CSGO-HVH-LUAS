local bit = require "bit"

-- Cache commonly used functions
local renderer = renderer
local gradient, rectangle, text, measure_text = renderer.gradient, renderer.rectangle, renderer.text, renderer.measure_text
local get_screen_size, get_latency = client.screen_size, client.latency
local get_absoluteframetime, get_tickinterval = globals.absoluteframetime, globals.tickinterval
local get_local_player, get_prop = entity.get_local_player, entity.get_prop
local min, max, abs, sqrt, floor = math.min, math.max, math.abs, math.sqrt, math.floor
local band, bnot, bor = bit.band, bit.bnot, bit.bor

-- Average FPS over the last 64 frames (up to 500ms)
local FRAME_SAMPLE_COUNT = 64
local FRAME_SAMPLE_TIME = 0.5
local NAME   = 1
local UPDATE = 2
local VALUE  = 3
local RED    = 4
local GREEN  = 5
local BLUE   = 6

-- Declare script variables
local frametimes = {}
local frametimes_index = 0
local variance = 0
local avg_fps = 0
local blocks = {}

-- round to whole number
local function tointeger(n)
	return floor(n + 0.5)
end

-- round up to an even number
local function make_even(x)
	return band(x + 1, bnot(1))
end

local function accumulate_fps()
	-- insert frame time into the ring buffer
	local ft = get_absoluteframetime()
	if ft > 0 then
		frametimes[frametimes_index] = ft
		frametimes_index = frametimes_index + 1
		if frametimes_index >= FRAME_SAMPLE_COUNT then
			frametimes_index = 0
		end
	end

	local accum = 0
	local accum_count = 0
	local idx = frametimes_index
	local prev_ft = nil
	variance = 0
	for i = 0, FRAME_SAMPLE_COUNT-1 do
		idx = idx - 1
		if idx < 0 then
			idx = FRAME_SAMPLE_COUNT-1
		end
		ft = frametimes[idx]
		if ft == 0 then
			break
		end
		accum = accum + ft
		accum_count = accum_count + 1
		if prev_ft then
			variance = max(variance, abs(ft - prev_ft))
		end
		prev_ft = ft
		if accum >= FRAME_SAMPLE_TIME then
			break
		end
	end
	if accum_count == 0 then
		return 0
	end
	accum = accum / accum_count

	local fps = tointeger(1 / accum)
	if abs(fps - avg_fps) > 5 then
		avg_fps = fps
	else
		fps = avg_fps
	end
	return fps
end

local function color_red() return 255, 60, 80 end
local function color_yellow() return 255, 222, 0 end
local function color_green() return 159, 202, 43 end

local function update_color(t, r, g, b)
	t[RED] = r
	t[GREEN] = g
	t[BLUE] = b
end

local function update_value(t, val)
	t[VALUE] = val
end

local function update_ping(t)
	local val = tointeger(min(1000, get_latency()*1000))
	if val < 40 then
		update_color(t, color_green())
	elseif val < 100 then
		update_color(t, color_yellow())
	else
		update_color(t, color_red())
	end
	update_value(t, val)
end

local function update_fps(t)
	local val = accumulate_fps()
	if val < (1 / get_tickinterval()) then
		-- FPS is below the server tickrate
		update_color(t, color_red())
	else
		update_color(t, color_green())
	end
	update_value(t, val)
end

-- variance is the difference between average FPS and current FPS
local function update_fps_variance(t)
	local val = variance
	local threshold = get_tickinterval()
	if val > threshold then
		update_color(t, color_red())
	elseif val > threshold*0.5 then
		update_color(t, color_yellow())
	else
		update_color(t, color_green())
	end
	update_value(t, tointeger(val * 1000))
end

local function update_speed(t)
	local vx, vy = get_prop(get_local_player(), "m_vecVelocity")
	update_value(t, vx and tointeger(min(10000, sqrt(vx*vx + vy*vy))) or 0)
end

local function paint()
	local char_width, char_height = measure_text("d", "0")
	char_width = make_even(char_width)
	local padding_y = tointeger(char_height * 0.5)
	local block_width = char_width * 13
	local subscript_width, subscript_height = measure_text("d-", "0")
	local subscript_offset = char_height - subscript_height
	local height = padding_y + char_height + padding_y
	local bw = block_width * #blocks
	local hw = bw * 0.5

	local sw, sh = get_screen_size()
	local x = tointeger(sw*0.5)
	local y = sh - height

	gradient(x - bw, y, hw, height, 0, 0, 0, 0, 0, 0, 0, 80, true)
	rectangle(x - hw, y, bw, height, 0, 0, 0, 80)
	gradient(x + hw, y, hw, height, 0, 0, 0, 80, 0, 0, 0, 0, true)

	x = x - hw + (block_width * 0.5)
	y = y + padding_y

	for i = 1, #blocks do
		local var = blocks[i]
		var[UPDATE](var)
		text(x, y, var[RED], var[GREEN], var[BLUE], 255, "dr", 0, var[VALUE])
		text(x + subscript_width, y + subscript_offset, 255, 255, 255, 175, "d-", 0, var[NAME])
		x = x + block_width
	end
end

local function add_block(name, updater, r, g, b)
	blocks[#blocks + 1] = { name, updater, 0, r, g, b }
end

local function init()
	local ft = get_absoluteframetime()
	for i = FRAME_SAMPLE_COUNT-1, 0, -1 do
		frametimes[i] = ft
	end

	add_block("PING", update_ping, 255, 255, 255)
	add_block("FPS", update_fps, 255, 255, 255)
	add_block("VAR", update_fps_variance, 255, 255, 255)
	add_block("SPEED", update_speed, 255, 255, 255)

	client.set_event_callback("paint", paint)
end

init()