
local menu_get, menu_set, menu_checkbox, menu_slider, menu_combobox, menu_multiselect, menu_hotkey, menu_button, menu_colorpicker, menu_textbox, menu_listbox, menu_string, menu_label, menu_reference, menu_set_callback, menu_setvisible, client_set_event_callback, render_measure_text, client_trace_line, client_eye_position, client_trace_bullet, entity_get_game_rules, math_ceil = ui.get, ui.set, ui.new_checkbox, ui.new_slider, ui.new_combobox, ui.new_multiselect, ui.new_hotkey, ui.new_button, ui.new_color_picker, ui.new_textbox, ui.new_listbox, ui.new_string, ui.new_label, ui.reference, ui.set_callback, ui.set_visible, client.set_event_callback, renderer.measure_text, client.trace_line, client.eye_position, client.trace_bullet, entity.get_game_rules, math.ceil
local entity_get_prop, entity_get_local_player, entity_is_alive, entity_get_player_weapon, entity_get_classname, entity_get_origin, globals_frametime, client_screen_size, globals_framecount, is_menu_open, menu_mouse_position, client_key_state, table_insert, entity_get_steam64, render_circle_outline, entity_get_all, globals_tickinterval, client_set_clantag, client_current_threat, entity_get_esp_data = entity.get_prop, entity.get_local_player, entity.is_alive, entity.get_player_weapon, entity.get_classname, entity.get_origin, globals.frametime, client.screen_size, globals.framecount, ui.is_menu_open, ui.mouse_position, client.key_state, table.insert, entity.get_steam64, renderer.circle_outline, entity.get_all, globals.tickinterval, client.set_clan_tag, client.current_threat, entity.get_esp_data
local math_sqrt, bit_band, globals_curtime, math_floor, bit_lshift, globals_tickcount, entity_get_players, entity_get_player_name, entity_get_steam64, client_userid_to_entindex, entity_is_enemy, entity_is_dormant, entity_hitbox_position, math_max, math_abs, render_text, render_world_to_screen, client_exec, entity_get_bounding_box, client_create_interface, render_box, render_circle, render_gradient = math.sqrt, bit.band, globals.curtime, math.floor, bit.lshift, globals.tickcount, entity.get_players, entity.get_player_name, entity.get_steam64, client.userid_to_entindex, entity.is_enemy, entity.is_dormant, entity.hitbox_position, math.max, math.abs, renderer.text, renderer.world_to_screen, client.exec, entity.get_bounding_box, client.create_interface, renderer.rectangle, renderer.circle, renderer.gradient

local vector = require("vector")
local ffi = require("ffi")

local http = require 'gamesense/http'
local surface = require 'gamesense/surface'


ffi.cdef[[
    typedef unsigned char wchar_t;
	typedef void*(__thiscall* get_client_entity_t)(void*, int);

	typedef void*(__thiscall* getnetchannel_123t)(void*); //78
	typedef float(__thiscall* getlatency_123t)(void*, int); //9

]]

local engineclient = ffi.cast(ffi.typeof("void***"), client.create_interface("engine.dll", "VEngineClient014"))
local getnetchannel = ffi.cast("getnetchannel_123t", engineclient[0][78])

local VGUI_System010 =  client.create_interface('vgui2.dll', 'VGUI_System010')
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010)
ffi.cdef [[
    typedef int(__thiscall* get_clipboard_text_count)(void*);
    typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
    typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]
local get_clipboard_text_count = ffi.cast('get_clipboard_text_count', VGUI_System[0][7])
local set_clipboard_text = ffi.cast('set_clipboard_text', VGUI_System[0][9])
local get_clipboard_text = ffi.cast('get_clipboard_text', VGUI_System[0][11])


local gui = {}
local gui_extra = {}

gui_extra.hex_label = function(self, rgb)
    local hexadecimal= '\a'
    
    for key, value in pairs(rgb) do
        local hex = ''

        while value > 0 do
            local index = math.fmod(value, 16) + 1
            value = math.floor(value/16)
            hex = ('0123456789ABCDEF'):sub(index, index) .. hex
        end

        if #hex == 0 then 
            hex= '00' 
        elseif #hex == 1 then 
            hex= '0' .. hex 
        end

        hexadecimal = hexadecimal .. hex
    end 
    
    return hexadecimal .. 'FF'
end

local menu_r, menu_g, menu_b, menu_a = menu_get(menu_reference("misc", "settings", "menu color"))

gui_extra.clr = gui_extra:hex_label({menu_r, menu_g, menu_b})
gui_extra.clr_grey = gui_extra:hex_label({75, 75, 75})
gui_extra.clr_txt = gui_extra:hex_label({165,165,165})
gui_extra.clr_gstxt = gui_extra:hex_label({200,200,200})
gui_extra.clr_gsexploit = gui_extra:hex_label({170,170,95})

gui_extra.gradienttext = function(self, text_to_draw, speed)
    local base_r, base_g, base_b,base_a = 125, 125, 125, 255
    local r2, g2, b2, a2 = menu_r, menu_g, menu_b, 255
    local highlight_fraction =  (globals.realtime() / 2 % 1.2 * speed) - 1.2
    local output = ""
    for idx = 1, #text_to_draw do
        local character = text_to_draw:sub(idx, idx)
        local character_fraction = idx / #text_to_draw

        local r, g, b, a = base_r, base_g, base_b, base_a
        local highlight_delta = (character_fraction - highlight_fraction)
        if highlight_delta >= 0 and highlight_delta <= 1.4 then
            if highlight_delta > 0.7 then
                highlight_delta = 1.4 - highlight_delta
            end
            local r_fraction, g_fraction, b_fraction, a_fraction = r2 - r, g2 - g, b2 - b
            r = r + r_fraction * highlight_delta / 0.8
            g = g + g_fraction * highlight_delta / 0.8
            b = b + b_fraction * highlight_delta / 0.8
        end
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, 255, text_to_draw:sub(idx, idx))
    end
    return output
end


gui_extra.reference = function(self, x, mode)
	return { menu_reference("aa", mode == 1 and "anti-aimbot angles" or "fake lag", x) }
end

gui_extra.og_menu = {
	enable = gui_extra:reference("enabled", 1),
	pitch = gui_extra:reference("pitch", 1),
	base = gui_extra:reference("yaw base", 1),
	yaw = gui_extra:reference("yaw", 1),
	jitter = gui_extra:reference("yaw jitter", 1),
	body = gui_extra:reference("body yaw", 1),
	fs = gui_extra:reference("freestanding body yaw", 1),
	edge = gui_extra:reference("edge yaw", 1),
	freestand = gui_extra:reference("freestanding", 1),
	roll = gui_extra:reference("roll", 1),
	fl_enabled = gui_extra:reference("enabled", 2),
	fl_amount = gui_extra:reference("amount", 2),
	fl_variance = gui_extra:reference("variance", 2),
	fl_limit = gui_extra:reference("limit", 2),
}

gui_extra.refs = {
	slowmotion = { menu_reference("aa", "other", "Slow motion") },
	fd = menu_reference("rage", "other", "duck peek assist"),
	dt = { menu_reference("rage", "aimbot", "double tap") },
	hs = { menu_reference("aa", "other", "on shot anti-aim") },
	fl_enabled = menu_reference("aa", "fake lag", "enabled"),
	fl_limit = menu_reference("aa", "fake lag", "limit"),
	leg_movement = menu_reference("aa", "other", "leg movement"),
}

gui_extra.reset = function(self, bool)
	for x, z in next, self.og_menu do
		menu_setvisible(z[1], bool)
		if z[2] ~= nil then
			menu_setvisible(z[2], bool)
		end
	end
end

gui_extra:reset(false)

------------------------------------------------------------------------------------------------------------------------
gui_extra.menu_color = function(self, mode, txt)
	local txtMode = mode and "+" or "-"
	return gui_extra.clr_txt .. "     [ " .. gui_extra.clr .. txtMode .. gui_extra.clr_txt .. " ] " ..  "-" .. gui_extra.clr_txt .. " " .. txt
end

gui_extra.keys = { 
	["0"] = "Always on",
	["1"] = "On hotkey",
	["2"] = "Toggle",
	["3"] = "Off hotkey"
}

gui_extra.menu_color_clicked = function(self, mode, txt, extra)
	local txtMode = mode and "-" or "+"
	local clicked = extra and ">" or "-"
	local spaces = extra and "     " or "   "
	return gui_extra.clr_txt .. spaces .. "[ " .. gui_extra.clr .. txtMode .. gui_extra.clr_txt .. " ] " .. clicked .. gui_extra.clr .. " " .. txt
end

gui_extra.inactive = function(self, string)
	return ("%s     [ %s- %s] - %s%s"):format(gui_extra.clr_txt, gui_extra.clr_grey, gui_extra.clr_txt, "\aFFFFFFC8", string)
end

local list = {
	gui_extra.clr .. "Anti Aim",
	gui_extra:inactive("Builder"),
	gui_extra:inactive("Exploits"),
	gui_extra:inactive("Fakelag"),
	gui_extra:inactive("Miscellaneous"),
	gui_extra.clr .. "Visuals",
	gui_extra:inactive("Indicators"),
	gui_extra:inactive("Extras"),
	gui_extra:inactive("Colors"),
	gui_extra.clr .. "Miscellaneous",
	gui_extra:inactive("Main"),
	gui_extra:inactive("Animations"),
	gui_extra:inactive("Configurations"),
}

local listclick = {
	{gui_extra.clr .. "Anti Aim", false},
	{"Builder", false},
	{"Exploits", false},
	{"Fakelag", false},
	{"Miscellaneous", false},
	{gui_extra.clr .. "Visuals", false},
	{"Indicators", false},
	{"Extras", false},
	{"Colors", false},
	{gui_extra.clr .. "Miscellaneous", false},
	{"Main", false},
	{"Animations", false},
	{"Configurations", false},
}

gui_extra.getNames = function(self, tbl)
	local values = {}
	
	for idd, nname in pairs(tbl) do
		table.insert(values, {
			id = idd,
			name = nname
			}
		)
	end

	return values
end

gui_extra.getNames2 = function(self, tbl)
	local values2 = {}
	
	for name, __ in pairs(tbl) do
		table.insert(values2, name)
	end

	return values2
end

gui_extra.getNamesFromid = function(self, tbl, id)
	return self:getNames(tbl)[id]
end

gui_extra.getNamesFromid2 = function(self, tbl, id)
	return self:getNames2(tbl)[id]
end
--gui_extra.clr_txt .. "     [ " .. gui_extra.clr

--gui.label_space = menu_label("aa", "anti-aimbot angles", " *.✨｡✫･.*.✨｡✫･.*.✨｡✫･.*.✨｡✫･.*.✨｡✫･.*.✨｡✫･.*｡✫･.*")
gui.label_name = menu_label("aa", "anti-aimbot angles", "d")

gui.list_menu = menu_listbox("aa", "fake lag", "menu", list)


gui_extra.animate_astral = function(self)
	local animated_txt = "*                         " .. self:gradienttext("NOMERCY SYNC", 2) .. gui_extra.clr_txt .. "                          *"
	local debug = "☆.*｡✫･.*"

	menu_set(gui.label_name, animated_txt)
end

local delay = 0
gui_extra.double = {
	click = false,
	delay = 0,
	lastitem = 0,
	stored_item = 0,
}

gui_extra.double2 = {
	click = false,
	delay = 0,
	lastitem = 0,
	stored_item = 0,
}

local t_f = {
    [true] = gui_extra.clr,
	[false] = "\a4B4B4BFF",
}

local function contains(tbl, val) 
    for i=1, #tbl do
        if tbl[i] == val then return true end 
    end 
    return false 
end

gui_extra.list_clicks = function()
	local listitem = menu_get(gui.list_menu)
	if listitem == nil then return end
	local tbl = gui_extra:getNamesFromid(list, listitem + 1)

	-- check if its a header we click on
	if tbl.name:find("-") == nil then
		menu_set(gui.list_menu, tbl.id)
		tbl.id = tbl.id + 1
	end

	local x = gui_extra
	--print(x.double.delay .. " " .. globals.curtime())
	if x.double.lastitem == listitem and x.double.delay + 0.5 > globals.curtime() and not x.double.click and x.double.delay ~= globals_curtime() then
		x.double.lastitem = -1
		x.double.delay = globals_curtime()
		x.double.click = true

		listclick[tbl.id][2] = not listclick[tbl.id][2] -- invert state (true / false)

		client.delay_call(0.2, function()
			x.double.click = false -- if we double click, reset the variable
		end)
	end

	if not x.double.click then
		x.double.delay = globals_curtime()
		x.double.lastitem = menu_get(gui.list_menu)
	end
	
	local temp_list = {}

	for k, v in ipairs(listclick) do
		local string = ""
		local header = k == 1 or k == 6 or k == 10

		if v[2] then
			if k == tbl.id then
				string = header and ("%s%s"):format("\aFFFFFFC8", v[2]) or ("%s     [ %s+ %s] > %s%s"):format(gui_extra.clr_txt, gui_extra.clr, gui_extra.clr_txt, "\aFFFFFFC8", v[1])
			else
				string = header and ("%s%s"):format("\aFFFFFFC8", v[2]) or ("%s     [ %s+ %s] - %s%s"):format(gui_extra.clr_txt, gui_extra.clr, gui_extra.clr_txt, "\aFFFFFFC8", v[1])
			end
		else
			if k == tbl.id then
				string = ("%s     [ %s- %s] > %s%s"):format(gui_extra.clr_txt, gui_extra.clr_grey, gui_extra.clr_txt, "\aFFFFFFC8", v[1])
			else
				string = header and ("%s%s"):format("\aFFFFFFC8", v[1]) or ("%s     [ %s- %s] - %s%s"):format(gui_extra.clr_txt, gui_extra.clr_grey, gui_extra.clr_txt, "\aFFFFFFC8", v[1])
			end
		end
		if not contains(temp_list, string) then
            table.insert(temp_list, string)
        end

	end
	ui.update(gui.list_menu, temp_list)

end

menu_set_callback(gui.list_menu, function()
	gui_extra:list_clicks()
end)

local visuals = {}

visuals.filled_circle = function(self, x, y, r, g, b, a, radius, segments)
	for i=1, radius do
		surface.draw_outlined_circle(x, y, r, g, b, a, i, segments)
	end
end

gui.vis = {}
gui.vis.colors = {}

gui.vis.clr_logs_background = menu_label("aa", "anti-aimbot angles", "Logs -> Background\aFFFFffff")
gui.vis.clr_logs_background_1 = menu_colorpicker("aa", "anti-aimbot angles", "Lua name 1", 45, 45, 45, 255)

local easings = {
	lerp = function(self, start, vend, time)
		return start + (vend - start) * time
	end,

	clamp = function(self, val, min, max)
		if val > max then return max end
		if min > val then return min end
		return val
	end,

    ease_in_out_quart = function(self, x)
        local sqt = x^2
        return sqt / (2 * (sqt - x) + 1);
    
    end
}


visuals.rounded_box = function(self, x, y, w, h, radius, r, g, b, a)
	--renderer.rectangle(x+radius,y,w-radius*2,radius,r,g,b,a)
	--renderer.rectangle(x,y+radius,radius,h-radius*2,r,g,b,a)
	--renderer.rectangle(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)
	--renderer.rectangle(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a)
	--renderer.rectangle(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)

	renderer.circle(x+radius,y+radius,r,g,b,a,radius,180,0.25)
	renderer.circle(x+w-radius,y+radius,r,g,b,a,radius,90,0.25)
	renderer.circle(x+radius,y+h-radius,r,g,b,a,radius,270,0.25)
	renderer.circle(x+w-radius,y+h-radius,r,g,b,a,radius,0,0.25)

	surface.draw_filled_outlined_rect(x+radius,y,w-radius*2,radius,r,g,b,a,r,g,b,0)
	surface.draw_filled_outlined_rect(x,y+radius,radius,h-radius*2,r,g,b,a,r,g,b,0)
	surface.draw_filled_outlined_rect(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a,r,g,b,0)
	surface.draw_filled_outlined_rect(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a,r,g,b,0)
	surface.draw_filled_outlined_rect(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a,r,g,b,0)
end

visuals.half_rounded_box = function(self, x, y, w, h, radius, r, g, b, a)
	--renderer.rectangle(x+radius,y,w-radius*2,radius,r,g,b,a)
	--renderer.rectangle(x,y+radius,radius,h-radius*2,r,g,b,a)
	--renderer.rectangle(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)
	--renderer.rectangle(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a)
	--renderer.rectangle(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)

	--renderer.circle(x+radius,y+radius,r,g,b,a - 55,radius,180,0.25)
	renderer.circle(x+w-radius,y+radius,r,g,b,a - 55,radius,90,0.25)
	--renderer.circle(x+radius,y+h-radius,r,g,b,a - 55,radius,270,0.25)
	renderer.circle(x+w-radius,y+h-radius,r,g,b,a - 55,radius,0,0.25)

	surface.draw_filled_outlined_rect(x+radius,y,w-radius*2,radius,r,g,b,a - 5,r,g,b,0)
	--surface.draw_filled_outlined_rect(x,y+radius,radius,h-radius*2,r,g,b,a - 5,r,g,b,0)
	surface.draw_filled_outlined_rect(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a - 5,r,g,b,255)
	surface.draw_filled_outlined_rect(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a - 5,r,g,b,255)
	surface.draw_filled_outlined_rect(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a - 5,r,g,b,255)
end

visuals.tahoma = surface.create_font("Tahoma", 12, 400, {0x200})

visuals.drawMultiColoredText = function(self, x, y, vals)
	local drawnText = ""
	local done = false
	local _x = 0
	for i=1, #vals do 
		local text = vals[i][2]
		drawnText = drawnText .. text
		if i == #vals then 
			done = true
		end
	end
	if done then
		--local centerX = Render.CalcTextSize(drawnText, 12).x * 0.5
		local centerX = surface.get_text_size(self.tahoma, drawnText) * 0.5

		for i=1, #vals do 
			local r, g, b, a = vals[i][1][1], vals[i][1][2], vals[i][1][3], vals[i][1][4]
			local text = vals[i][2]

			--local textSize = Render.CalcTextSize(text, 12)
			local textSizeX, textsizeY = surface.get_text_size(self.tahoma, text)

			--Render.Text(text, Vector2.new(x + _x - centerX, y), clr, 12)
			surface.draw_text(x + _x, y, r, g, b, a, self.tahoma, text)
			_x = _x + textSizeX
		end
	end
end

local colors = {
	green = {163, 255, 15, 225},
	white = {250, 250, 250, 225},
	red = {231, 52, 52, 225},
	yellow = {252, 209, 4, 225},
	orange = {249, 140, 70, 225},
	blue = {61, 211, 236, 225},
}

local logs = {}


visuals.add_to_log = function(self, input, txt, _mode, event_player)
	local screen = {client.screen_size()}
	local center = {screen[1]/2, screen[2]/2} 
	
	alphatest = globals.realtime() + 15
	
	
	table.insert(logs, {
		text = input,
		ogTxt = txt,
		player = event_player,
		mode = _mode,
	
		timer = globals.realtime(),
		alpha = 0,
		clr = {},

		ypos = 25,
		ypos2 = screen[2],
	})
end	


local welcometxt =  {
	{colors.white, "Welcome to "},
	{colors.blue, "NOMERCY SYNC"},
}

visuals:add_to_log(welcometxt, "Welcome to NOMERCY SYNC", "notify", "me")

local test_lerp = 25
local last_ypos = 0

visuals.logs = function(self, x, y)

	local r, g, b, a = menu_get(gui.vis.clr_logs_background_1)

	for i, info in ipairs(logs) do
		if i > 35 then
			table.remove(logs, i)
		end

		if info.timer + 3.8 < globals.realtime() then
			if info.timer + 3.95 < globals.realtime() then
				info.text = ""
			end
			info.alpha = easings:lerp(
				info.alpha,
				0,
				globals.frametime() * 15
			)
		else
			info.alpha = easings:lerp(
				info.alpha,
				255,
				globals.frametime() * 5
			)
		end

		local alpha = math.ceil(info.alpha)

		if type(info.text) == "table" then
			for i, x in ipairs(info.text) do
				x[1][4] = alpha
			end
		end

		info.ypos = easings:lerp(
			info.ypos,
			y,
			globals.frametime() * 15
		)

		local textSizeX, textsizeY = surface.get_text_size(self.tahoma, info.ogTxt)

		self:rounded_box(x, info.ypos, textSizeX + 24, 17, 5, r, g, b, alpha)

		info.clr = colors.white
		if info.mode == "notify" then
			info.clr = colors.blue
		elseif mode == "red" then
			info.clr = colors.red
		end 

		renderer.circle(x + 8, info.ypos + 8, info.clr[1], info.clr[2], info.clr[3], alpha, 2, 1, 1)

		self:drawMultiColoredText(x + 15, info.ypos + 2, info.text)	

		y = y + 20

		last_ypos = y
		if info.timer + 4 < globals.realtime() then
			table.remove(logs, i) 
		end

	end

	--self:rounded_box(x, y, 310, 15, 5, r, g, b, a)

	--surface.draw_filled_outlined_rect(x, y, 45, 15, 50, 50, 50, 200, 50, 50, 50, 0)

	--self:half_rounded_box(x + 45, y, 50, 15, 5, 85, 85, 85, a)

	--surface.draw_filled_gradient_rect(x + 45, y, 1, 15, 255, 0, 0, 255, 255, 0, 0, 255, false)
	--self:half_rounded_box(x + 45, y, 125, 15, 5, r, g, b, a)

	--surface.draw_text(x + 55, y + 1, 255, 255, 255, 255, self.tahoma, "Player tyler due to black")


	
	--self:drawMultiColoredText(x + 15, y + 1, hits)	

end

visuals.main = function(self)
	local me = entity_get_local_player()
	if me == nil then
		return
	end

	--local x, y = client.screen_size()

	self:logs(3, 45)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
local tab, container = "aa", "anti-aimbot angles"
local manual_state = "reset"
gui.aa = {}
gui.aa.dyn = {}
gui.aa.build = {}
gui.aa.build.preset = {}

gui.label = menu_label(tab, container, "NOTE: Tab: ")

-------------------------- gui builder -------------------------
local conditions = {"Global", "Stand", "Slowwalk", "Move", "Air", "Air+Duck", "Duck","Left","Right"}
local cond_names = {"GLOBAL", "STAND", "SLOW", "MOVE", "AIR", "AIR+D", "DUCK","LEFT","RIGHT"}
--local manual_state = "reset"
gui.aa.build.show = menu_combobox("aa", "anti-aimbot angles", "\n", {"State builder", "Anti-Bruteforce"})
gui.aa.build.state = menu_combobox("aa", "anti-aimbot angles", "\n", conditions)
gui.aa.build.key_left = menu_hotkey(tab, container, string.format("%sManual left %s      -> key", gui_extra.clr, gui_extra.clr_txt))
gui.aa.build.key_right = menu_hotkey(tab, container, string.format("%sManual right %s    -> key", gui_extra.clr, gui_extra.clr_txt))
for i, x in ipairs(conditions) do
	if gui.aa.build[x] == nil then
		local name = string.format("%s[%s%s%s]%s - ", gui_extra.clr_grey, gui_extra.clr, cond_names[i], gui_extra.clr_grey, gui_extra.clr_gstxt)
		gui.aa.build[x] = {
			enable = menu_checkbox(tab, container, string.format("Enable%s %s %s", gui_extra.clr, x, gui_extra.clr_gstxt)),
			pitch = menu_combobox(tab, container, name .. "Pitch", "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
			pitch_s = menu_slider(tab, container, "\nPitch" .. name, -89, 89, 0, true, "°", 1),
			yaw_base = menu_combobox(tab, container, name .. "Yaw base", "Local view", "At targets"),
			yaw =  menu_combobox(tab, container, name .. "Yaw", "Off", "180"),
			yaw_amount = menu_slider(tab, container, "\nyaw_amount" .. name, -180, 180, 0, true, "°", 1),
			yaw_nolog = menu_checkbox(tab, container, string.format("Use %santi-log%s if tapped", gui_extra.clr_gsexploit, gui_extra.clr_gstxt)),
			yaw_modifier = menu_combobox(tab, container, name .. "Yaw modifier", "Off", "Offset", "Center", "Random", "Skitter (WIP)", "L & R"),
			yaw_modifier_l = menu_slider(tab, container, name .. "[L] Yaw", -180, 180, 0, true, "°", 1),
			yaw_modifier_r = menu_slider(tab, container, name .. "[R] Yaw", -180, 180, 0, true, "°", 1),
			yaw_modifier_m = menu_slider(tab, container, "\nyaw_modifier" .. name, -180, 180, 0, true, "°", 1),
			yaw_modifier_speed = menu_slider(tab, container, name .. "Modifier speed", 1, 10, 0),
			yaw_modifier_def = menu_checkbox(tab, container, string.format("Force %sdefensive%s on side switch", gui_extra.clr_gsexploit, gui_extra.clr_gstxt)),
			fake_yaw = menu_combobox(tab, container, name .. "Body yaw", "Off", "Opposite", "Jitter", "Static", "L & R Jitter"),
			fake_l_jitter = menu_slider(tab, container, name .. "[L] Jitter", -60, 60, 0, true, "°", 1),
			fake_r_jitter = menu_slider(tab, container, name .. "[R] Jitter", -60, 60, 0, true, "°", 1),
			fake_yaw_m = menu_slider(tab, container, "\nfake_modifier" .. name, -60, 60, 0, true, "°", 1),
			freestand_body = menu_checkbox(tab, container, name .. "Freestanding body yaw"),
			edge = menu_checkbox(tab, container, name .. "Edge yaw")

		}
	end
end

gui.aa.build.abf = {}
gui.aa.build.abf.reset = menu_multiselect(tab, container, "Resets", {"Timer", "New round", "Stay until local HS", "Enemy died"})
gui.aa.build.abf.timer =  menu_slider(tab, container, "Timer", 0, 10, 0, true, "s", 1)
gui.aa.build.abf.auto = menu_multiselect(tab, container, "Automatisations", {"Alter real jitter", "Alter desync value"})
----------------------------------------------------------------

--###############################################[ MENU MISC ]##############################################

local conditions = {"Global", "Stand", "Slowwalk", "Move", "Air", "Air+Duck", "Duck","Left","Right"}

gui.aa.misc = {}
gui.aa.misc.selector = menu_multiselect(tab, container, "Keybinds", {"Freestand", "Legit AA","Edge Yaw","Manual AA"})
---gui.aa.misc.freestand_disablers = menu_multiselect(tab, container, string.format("%sFreestand %sdisablers", gui_extra.clr, gui_extra.clr_txt), conds_disablers)
gui.aa.misc.freestand_options = menu_combobox(tab, container, string.format("%sFreestand %soptions", gui_extra.clr, gui_extra.clr_txt), {"Static", "Jitter"})

gui.aa.misc.legitaa_options = menu_combobox(tab, container, string.format("%sLegit AA %soptions", gui_extra.clr, gui_extra.clr_txt), {"Static", "Jitter"})
gui.aa.misc.manual_options = menu_combobox(tab, container, string.format("%sManual %soptions", gui_extra.clr, gui_extra.clr_txt), {"At targets", "Local view"})

gui.aa.misc.label_keys_split = menu_label(tab, container, "\n")
gui.aa.misc.label_keys = menu_label(tab, container, string.format("%s ⎯⎯⎯⎯⎯⎯⎯⎯ %s Keybinds %s⎯⎯⎯⎯⎯⎯⎯⎯", gui_extra.clr_txt, gui_extra.clr, gui_extra.clr_txt))
gui.aa.misc.key_freestand = menu_hotkey(tab, container, string.format("%sFreestand %s        -> key", gui_extra.clr, gui_extra.clr_txt))
gui.aa.misc.key_legit_aa = menu_hotkey(tab, container, string.format("%sLegit AA %s           -> key", gui_extra.clr, gui_extra.clr_txt))
gui.aa.misc.key_edge_yaw = menu_hotkey(tab, container, string.format("%sEdge Yaw %s         -> key", gui_extra.clr, gui_extra.clr_txt))
gui.aa.misc.key_left = menu_hotkey(tab, container, string.format("%sManual left %s      -> key", gui_extra.clr, gui_extra.clr_txt))
gui.aa.misc.key_right = menu_hotkey(tab, container, string.format("%sManual right %s    -> key", gui_extra.clr, gui_extra.clr_txt))
gui.aa.misc.key_forward = menu_hotkey(tab, container, string.format("%sManual forward %s-> key", gui_extra.clr, gui_extra.clr_txt))


--###############################################[ MENU EXPLOITS ]##############################################
gui.aa.x = {}

--gui_extra.x_name = string.format("%s[%sDEFENSIVE%s]%s - ", gui_extra.clr_grey, gui_extra.clr, gui_extra.clr_grey, gui_extra.clr_gstxt)
gui.aa.x.selctor = menu_combobox(tab, container, "\n", {"Defensive", "Invalid tick"})
gui.aa.x.def_enable = menu_checkbox(tab, container, string.format("Enable %sDefensive%s", gui_extra.clr, gui_extra.clr_gstxt))
gui.aa.x.def_mode = menu_combobox(tab, container, "Mode", {"m_nTickbase", "sim time check"})
gui.aa.x.def_speed = menu_slider(tab, container, "Delay", 0, 10, 0)
gui.aa.x.def_triggers = menu_multiselect(tab, container, "Triggers", {"Stand", "Slow", "Move", "Air", "Air+Duck", "Duck"})
gui.aa.x.def_hittable = menu_checkbox(tab, container, "Trigger: Hittable")
gui.aa.x.def_pitch = menu_combobox(tab, container, "Pitch", {"Off", "Down up", "Down zero", "Up zero", "Custom"})
gui.aa.x.def_pitch_1 = menu_slider(tab, container, "[1] Pitch", -89, 89, 0, true, "°", 1)
gui.aa.x.def_pitch_2 = menu_slider(tab, container, "[2] Pitch", -89, 89, 0, true, "°", 1)
gui.aa.x.def_yaw = menu_combobox(tab, container, "Yaw", {"Off", "Spin", "Distortion", "Random jitter"})
gui.aa.x.def_yaw_1 = menu_slider(tab, container, "Max spin range", -180, 180, 0, true, "°", 1)
gui.aa.x.def_yaw_speed = menu_slider(tab, container, "Speed", 0, 15, 0)
gui.aa.x.def_fake = menu_combobox(tab, container, "Desync", {"Off", "Jitter", "Jitter off on"})

--###############################################[ MENU FAKELAG ]##############################################
gui.aa.fl = {}
gui.aa.fl.amount = menu_combobox(tab, container, "Amount", {"Dynamic", "Maximum", "Fluctuate"})
gui.aa.fl.variance = menu_slider(tab, container, "Variance", 0, 100, 0, true, "%", 1)
gui.aa.fl.limit = menu_slider(tab, container, "Limit", 1, 15, 0, true, "t", 1)
gui.aa.fl.better_onshot = menu_checkbox(tab, container, string.format("Avoid %son-shot%s", gui_extra.clr, gui_extra.clr_gstxt))

--###############################################[ CONFIG SYSTEM ]##############################################
local configs = {}
local base64 = {}
extract = function(v, from, width)
    return bit.band(bit.rshift(v, from), bit.lshift(1, width) - 1)
end
function base64.makeencoder(alphabet)
    local encoder = {}
    local t_alphabet = {}
    for i = 1, #alphabet do
        t_alphabet[i - 1] = alphabet:sub(i, i)
    end
    for b64code, char in pairs(t_alphabet) do
        encoder[b64code] = char:byte()
    end
    return encoder
end
function base64.makedecoder(alphabet)
    local decoder = {}
    for b64code, charcode in pairs(base64.makeencoder(alphabet)) do
        decoder[charcode] = b64code
    end
    return decoder
end
DEFAULT_ENCODER = base64.makeencoder("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")
DEFAULT_DECODER = base64.makedecoder("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")

CUSTOM_ENCODER = base64.makeencoder("KmAWpuFBOhdbI1orP2UN5vnSJcxVRgazk97ZfQqL0yHCl84wTj3eYXiD6stEGM+/=")
CUSTOM_DECODER = base64.makedecoder("KmAWpuFBOhdbI1orP2UN5vnSJcxVRgazk97ZfQqL0yHCl84wTj3eYXiD6stEGM+/=")

function base64.encode(str, encoder, usecaching)
    str = tostring(str)

    encoder = encoder or DEFAULT_ENCODER
    local t, k, n = {}, 1, #str
    local lastn = n % 3
    local cache = {}
    for i = 1, n - lastn, 3 do
        local a, b, c = str:byte(i, i + 2)
        local v = a * 0x10000 + b * 0x100 + c
        local s
        if usecaching then
            s = cache[v]
            if not s then
                s = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[extract(v, 6, 6)],
                        encoder[extract(v, 0, 6)])
                cache[v] = s
            end
        else
            s = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[extract(v, 6, 6)],
                    encoder[extract(v, 0, 6)])
        end
        t[k] = s
        k = k + 1
    end
    if lastn == 2 then
        local a, b = str:byte(n - 1, n)
        local v = a * 0x10000 + b * 0x100
        t[k] = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[extract(v, 6, 6)],
                   encoder[64])
    elseif lastn == 1 then
        local v = str:byte(n) * 0x10000
        t[k] = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[64], encoder[64])
    end
    return table.concat(t)
end
function base64.decode(b64, decoder, usecaching)
    decoder = decoder or DEFAULT_DECODER
    local pattern = "[^%w%+%/%=]"
    if decoder then
        local s62, s63
        for charcode, b64code in pairs(decoder) do
            if b64code == 62 then
                s62 = charcode
            elseif b64code == 63 then
                s63 = charcode
            end
        end
        pattern = ("[^%%w%%%s%%%s%%=]"):format(string.char(s62), string.char(s63))
    end
    b64 = b64:gsub(pattern, "")
    local cache = usecaching and {}
    local t, k = {}, 1
    local n = #b64
    local padding = b64:sub(-2) == "==" and 2 or b64:sub(-1) == "=" and 1 or 0
    for i = 1, padding > 0 and n - 4 or n, 4 do
        local a, b, c, d = b64:byte(i, i + 3)
        local s
        if usecaching then
            local v0 = a * 0x1000000 + b * 0x10000 + c * 0x100 + d
            s = cache[v0]
            if not s then
                local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40 + decoder[d]
                s = string.char(extract(v, 16, 8), extract(v, 8, 8), extract(v, 0, 8))
                cache[v0] = s
            end
        else
            local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40 + decoder[d]
            s = string.char(extract(v, 16, 8), extract(v, 8, 8), extract(v, 0, 8))
        end
        t[k] = s
        k = k + 1
    end
    if padding == 1 then
        local a, b, c = b64:byte(n - 3, n - 1)
        local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40
        t[k] = string.char(extract(v, 16, 8), extract(v, 8, 8))
    elseif padding == 2 then
        local a, b = b64:byte(n - 3, n - 2)
        local v = decoder[a] * 0x40000 + decoder[b] * 0x1000
        t[k] = string.char(extract(v, 16, 8))
    end
    return table.concat(t)
end

local configs = {}
configs.validation_key = "aae93c994bd9f81ea4f55ced07e494f3"


-- color: userdata holding "r, g, b, a" as floats (0.0 - 1.0)
configs.convertColorToString = function(color)
	r = math_round(color.r * 255)
	g = math_round(color.g * 255)
	b = math_round(color.b * 255)
	a = math_round(color.a * 255)

    return string.format("%i, %i, %i, %i", r, g, b, a)
end


-- split "str" at "sep" and return a table of the resulting substrings
configs.splitString = function(str, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

-- loop through "tbl" and save content into "saveTbl"
configs.saveTable = function(tbl, saveTbl)
    -- table loop
    for k, v in pairs(tbl) do 
        -- if "v" is a table, call the function again with adjusted arguments, basic recursion
        if type(v) == "table" then
            -- since our value is a table we need to create an empty table
            -- in our "saveTbl" with our key as the name of the table
            saveTbl[k] = {}
            -- call this function again with adjusted arguments
            -- "v" is the table thats being looped over and our newly created table
            -- is the table that the values of "v" get saved in
            configs.saveTable(v, saveTbl[k])
        else
            -- since "v" isnt a table, we can safely assume its a menu element
            -- so get its value and save it in our "saveTbl"
			if string.find(k, "key") ~= nil then

				v = {
					type = "key",
					v = {ui.get(v)},
				}
			else
            if string.find(k, "clr") ~= nil then
                if string.find(k, "clr") > 0 and string.find(k, "_1") then
                    v = {
                    	type = "color",
                    	v = {ui.get(v)},
                    }
                else
                    v = ui.get(v)
                end
            else
				v = ui.get(v)
				if type(v) == "table" then
					v = {
						type = "multi",
						v = v
					}
				end
			end
            end
            --print(k .. " " .. json.stringify(v) .. " t: " .. json.stringify(type(v)))
            --v = ui.get
            -- if "v" is of type "userdata", it means that the menu element is a color picker
            -- so get the color and save that to "saveTbl"
            saveTbl[k] = v
        end
    end    
end

-- tbl: values to load, menuElementsTable: table to save values into, should be the table that holds the menu elements, tblName: ignore, just for debugging
configs.loadTable = function(tbl, menuElementsTable, tblName)
    -- set "tblName" to "tblName" if it isnt set
    tblName = tblName or ""
    -- loop through "tbl"
    for k, v in pairs(tbl) do 
        -- same thing as in "saveTable"
        -- if "v" is a table, call the function again with adjusted arguments
		if menuElementsTable[k] == nil then 
			if tonumber(k) then
				if menuElementsTable[tonumber(k)] ~= nil then
					configs.loadTable(v, menuElementsTable[tonumber(k)], tblName .. tonumber(k) .. ".")
				end
				goto skip

			else
				goto skip 
			end
		end
        if type(v) == "table" then
            if v.type ~= nil then 

				-- custom table, not a sub menu
        		-- meaning its either a color picker or a multiselect
        		if v.type == "color" then
        			-- yep, color picker
        			local r, g, b, a = unpack(v.v)
                    ui.set(menuElementsTable[k], r, g, b, a)
        		elseif v.type == "multi" then 
        			-- yep, multi select
        			ui.set(menuElementsTable[k], v.v)
				elseif v.type == "key" then
					local key = v.v[3]
					local mode = gui_extra.keys[tostring(v.v[2])]

					ui.set(menuElementsTable[k], mode, key)
        		end
        	else
	            -- our table to loop through becomes "v"
            	-- and the table to save values in becomes the table that has the same name as "km"
            	configs.loadTable(v, menuElementsTable[k], tblName .. k .. ".")
        	end
        else
        -- if the value contains spacebar it should be a color
		if menuElementsTable == nil then goto skip end
		if menuElementsTable[k] == nil then goto skip end

        if string.find(k, "key") ~= nil or string.find(k, "label") ~= nil then
            goto skip
        else
			local test = ui.get(menuElementsTable[k], v)
			if test == nil then goto skip end

			local success, err = pcall(function () ui.set(menuElementsTable[k], v) end)
        end
		--print("Setting " .. tblName .. k .. " to " .. tostring(v) .. " (prev " .. tostring(menuElementsTable[k]) .. ")")

			::skip::
            
        end      
		::skip::  
    end   
end

configs.clipboard_import = function(self)
    local clipboard_text_length = get_clipboard_text_count( VGUI_System )
    local clipboard_data = ''

  if clipboard_text_length > 0 then
      buffer = ffi.new('char[?]', clipboard_text_length)
      size = clipboard_text_length * ffi.sizeof('char[?]', clipboard_text_length)

      get_clipboard_text( VGUI_System, 0, buffer, size )
      clipboard_data = ffi.string( buffer, clipboard_text_length-1 )
  end

  return clipboard_data
end

configs.clipboard_export = function(self, string)
	if string then
		set_clipboard_text(VGUI_System, string, #string)
	end
end

--add to list
local db_configs = database.read("astralnew_configs") or {}
local cloud_presets = {} 

--array for storing
configs.getConfigNames = function()
	local values = {}

	for cconfig_name, __ in pairs(cloud_presets) do
		table.insert(values, cconfig_name)
	end	
	
	for config_name, _ in pairs(db_configs) do
		table.insert(values, config_name)
	end

	return values
end

configs.getConfigNameForID = function(id)
	return configs.getConfigNames()[id]
end

configs.list = menu_listbox("aa", "anti-aimbot angles", "configs list", function(self)
	--ui.set(configs.config_name, "asd")
	
end)

menu_set_callback(configs.list, function()
	local configID = menu_get(configs.list)
	if configID == nil then return end
	local name = configs.getConfigNameForID(configID + 1)
	if name == nil then return end

	menu_set(configs.config_name, name)
end)

--load from web
function init_database()
    if database.read(db_configs) == nil then
        database.write(db_configs, {})
    end

    local user, token = 'github username', 'auth token' -- get from github account settings (lmk if you need help, you probably wont need it unless your repo is private)

    http.get('https://starlua.net/cloud_cfgs/gamesense.json', function(success, response) -- {authorization = {user, token}} < ONLY USE IF YOUR REPO IS PRIVATE
        if not success then
            print('Failed to get presets')
            return
        end

		presets = json.parse(response.body)

        --local db = database.read(db_configs)

        for i, preset in pairs(presets.presets) do
			local name = '*'.. preset.name .. " (" .. preset.update .. ")"
			local config = preset.config
			cloud_presets[name] = config
            --table.insert(cloud_presets, { name = '*'..preset.name .. " (" .. preset.update .. ")", config = preset.config})
        end

        ui.update(configs.list, configs.getConfigNames())
    end) 
end

--init_database()

configs.config_name = menu_textbox("aa", "anti-aimbot angles", "Config")

local valueTable = {}

configs.save = menu_button("aa", "anti-aimbot angles", "Save", function(self)
	local txtbox = menu_get(configs.config_name)

    local configID = menu_get(configs.list)
	local name = ""

	if configID ~= nil then 
		name = configs.getConfigNameForID(configID + 1)
		if name == "" then 
			return 
		end
	end
	
	if txtbox == "" then
		return
	end

	if name == txtbox then
		-- get stuff
		configs.saveTable(gui, valueTable)
		valueTable[configs.validation_key] = true
		valueTable["clicks"] = listclick


		local json_config = json.stringify(valueTable)
		
		json_config = base64.encode(json_config, CUSTOM_ENCODER)

		db_configs[name] = json_config

		local loaded =  {
			{colors.white, "Succesfully "},
			{colors.blue, "saved "},
			{colors.white, "configuration "},
			{colors.blue, txtbox},
		}
		
		visuals:add_to_log(loaded, "Succesfully saved configuration " .. name, "notify", "me")

		print("Succesfully saved configuration " .. name)
	else
		configs.saveTable(gui, valueTable)
		valueTable[configs.validation_key] = true
		valueTable["clicks"] = listclick

		local json_config = json.stringify(valueTable)
		
		json_config = base64.encode(json_config, CUSTOM_ENCODER)
	
		db_configs[txtbox] = json_config

		local loaded =  {
			{colors.white, "Succesfully "},
			{colors.blue, "created "},
			{colors.white, "configuration "},
			{colors.blue, txtbox},
	
		}
	
		visuals:add_to_log(loaded, "Succesfully created configuration " .. txtbox, "notify", "me")
	
		print("Succesfully created configuration " .. txtbox)
	end

	database.write("astralnew_configs", db_configs)

	--update listbox
	ui.update(configs.list, configs.getConfigNames())
end)

configs.load = ui.new_button("aa", "anti-aimbot angles", "Load", function()
    local configID = menu_get(configs.list)
	if configID == nil then return end

    local name = configs.getConfigNameForID(configID + 1)

    local protected = function()
		local cfg = db_configs[name]

		if cfg == nil then
			cfg = cloud_presets[name]
		end

        local json_config = base64.decode(cfg, CUSTOM_DECODER)

        if json_config:match(configs.validation_key) == nil then
            error("cannot_find_validation_key")
            return
        end

		if json_config:match("clicks") then
            local to_table = json.parse(json_config)
            listclick = to_table["clicks"]
			gui_extra:list_clicks()
        end

        json_config = json.parse(json_config)


        if json_config == nil then
            error("wrong_json")
            return
        end

		local loaded =  {
			{colors.white, "Succesfully "},
			{colors.blue, "loaded "},
			{colors.white, "configuration "},
			{colors.blue, name},
		}
		
		visuals:add_to_log(loaded, "Succesfully loaded configuration " .. name, "notify", "me")
		
		print("Succesfully loaded configuration " .. name)
        configs.loadTable(json_config, gui)
    end

    local status, message = pcall(protected)

    if not status then
		local loaded =  {
			{colors.red, "Failed "},
			{colors.white, "to load configuration"},
			{colors.red, message},
		}
		
		visuals:add_to_log(loaded, "Failed to load configuration " .. message, "red", "me")

        print("Failed to load config:", message)
        return
    end
end)

configs.delete = ui.new_button("aa", "anti-aimbot angles", "Delete", function()
    local configID = menu_get(configs.list)
	if configID == nil then return end
	local txtbox = menu_get(configs.config_name)
	local name = configs.getConfigNameForID(configID + 1)

	if name == "" or txtbox == "" or name == nil then
		print("Configuration name is empty!")
		local loaded =  {
			{colors.white, "Configuration "},
			{colors.red, "name "},
			{colors.white, "is "},
			{colors.red, "empty!"},

		}
		
		visuals:add_to_log(loaded, "Configuration name is empty!", "red", "me")
		return
	end

	if cloud_presets[name] then
		print("You can't delete cloud configurations!")
		return
	end

	local loaded =  {
		{colors.white, "Succesfully "},
		{colors.blue, "deleted "},
		{colors.white, "configuration "},
		{colors.blue, name},

	}
	
	visuals:add_to_log(loaded, "Succesfully deleted configuration " .. name, "notify", "me")

	print("Succesfully deleted configuration " .. name)

	db_configs[name] = nil
	database.write("astralnew_configs", db_configs)

	--update listbox
	ui.update(configs.list, configs.getConfigNames())
end)

configs.empty_cfg = "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"
configs.reset = menu_button("aa", "anti-aimbot angles", "Reset", function()
    local configID = menu_get(configs.list)
	if configID == nil then return end
	local txtbox = menu_get(configs.config_name)
	local name = configs.getConfigNameForID(configID + 1)

	if name == nil then return end

	db_configs[name] = configs.empty_cfg
	database.write("astralnew_configs", db_configs)

	local loaded =  {
		{colors.white, "Succesfully "},
		{colors.blue, "reset "},
		{colors.white, "configuration "},
		{colors.blue, name},
		{colors.white, ". Please "},
		{colors.blue, "reload "},
		{colors.white, "config"},

	}
	
	visuals:add_to_log(loaded, "Succesfully reset configuration " .. name .. ". Please reload config", "notify", "me")

	print("Succesfully reset configuration " .. name .. ". Please load config again")
end)

--update listbox on load
ui.update(configs.list, configs.getConfigNames())

configs.import = menu_button("aa", "anti-aimbot angles", "Import from clipboard", function(self)
    local protected = function()
        local clipboard = text == nil and configs:clipboard_import() or text

        local json_config = base64.decode(clipboard, CUSTOM_DECODER)

        if json_config:match(configs.validation_key) == nil then
            error("cannot_find_validation_key")
            return
        end

        json_config = json.parse(json_config)

        if json_config == nil then
            error("wrong_json")
            return
        end

		local loaded =  {
			{colors.white, "Succesfully "},
			{colors.blue, "imported "},
			{colors.white, "configuration from "},
			{colors.blue, "clipboard"},
	
		}
		
		visuals:add_to_log(loaded, "Succesfully imported configuration from clipboard", "notify", "me")
	
		print("Succesfully loaded configuration from clipboard")
        configs.loadTable(json_config, gui)

    end

    local status, message = pcall(protected)

    if not status then
		local loaded =  {
			{colors.red, "Failed "},
			{colors.white, "to "},
			{colors.red, "load "},
			{colors.white, "configuration from "},
			{colors.red, "clipboard "},

		}
		
		visuals:add_to_log(loaded, "Failed to load configuration from clipboard", "notify", "me")

        print("Failed to load config:", message)
        return
    end
end)

configs.export = menu_button("aa", "anti-aimbot angles", "Export to clipboard", function()
    local configID = menu_get(configs.list)
	
	configs.saveTable(gui, valueTable)
	valueTable[configs.validation_key] = true
	valueTable["clicks"] = listclick


	local json_config = json.stringify(valueTable)
	
	json_config = base64.encode(json_config, CUSTOM_ENCODER)

	configs:clipboard_export(json_config)	

	local loaded =  {
		{colors.white, "Succesfully "},
		{colors.blue, "exported "},
		{colors.white, "configuration to "},
		{colors.blue, "clipboard"},

	}
	
	visuals:add_to_log(loaded, "Succesfully exported configuration to clipboard", "notify", "me")

	print("Succesfully exported configuration to clipboard")
end)

gui_extra.visibility = function(self)
	local listitem = menu_get(gui.list_menu)
	if listitem == nil then
		return
	end

	local tbl = gui_extra:getNamesFromid(list, listitem + 1)

	for k, v in ipairs(listclick) do
		local enabled = v[2]
		
		if tbl.name:find(v[1]) then
			local enabled = v[2] and "Enabled" or "Disabled"
			menu_set(gui.label, v[1] .. " is currently: " .. gui_extra.clr .. enabled .. "\n")
		end
		
		local method = menu_get(gui.aa.build.show)

		menu_setvisible(gui.aa.build.show, listitem == 1)

		local builder = listitem == 1 and method == "State builder"
		local antibf = listitem == 1 and method == "Anti-Bruteforce"

		menu_setvisible(gui.aa.build.abf.reset, listitem == 1 and antibf)
		menu_setvisible(gui.aa.build.abf.timer, listitem == 1 and antibf and contains(menu_get(gui.aa.build.abf.reset), "Timer"))

		menu_setvisible(gui.aa.build.abf.auto, listitem == 1 and antibf)

		menu_setvisible(gui.aa.build.state, builder)

		menu_setvisible(gui.aa.build.key_left, builder)
		menu_setvisible(gui.aa.build.key_right, builder)







		local build_state = menu_get(gui.aa.build.state)
		
		for i, x in ipairs(conditions) do
			local active = x == build_state and builder

			local fake_yaw = menu_get(gui.aa.build[x].fake_yaw)

			menu_set(gui.aa.build["Global"].enable, true)
			menu_setvisible(gui.aa.build[x].enable, x ~= "Global" and active and build_state ~= "Global")

 			local active = active and menu_get(gui.aa.build[x].enable)
			menu_setvisible(gui.aa.build[x].pitch, active)
			menu_setvisible(gui.aa.build[x].pitch_s, active and menu_get(gui.aa.build[x].pitch) == "Custom")
			menu_setvisible(gui.aa.build[x].yaw_base, active)
			menu_setvisible(gui.aa.build[x].yaw, active)
			menu_setvisible(gui.aa.build[x].yaw_amount, active and menu_get(gui.aa.build[x].yaw) ~= "Off")
			menu_setvisible(gui.aa.build[x].yaw_nolog, active and menu_get(gui.aa.build[x].yaw) ~= "Off")
			menu_setvisible(gui.aa.build[x].yaw_modifier, active)
			menu_setvisible(gui.aa.build[x].yaw_modifier_m, active and menu_get(gui.aa.build[x].yaw_modifier) ~= "Off" and menu_get(gui.aa.build[x].yaw_modifier) ~= "L & R")
			menu_setvisible(gui.aa.build[x].yaw_modifier_l, active and menu_get(gui.aa.build[x].yaw_modifier) == "L & R")
			menu_setvisible(gui.aa.build[x].yaw_modifier_r, active and menu_get(gui.aa.build[x].yaw_modifier) == "L & R")

			menu_setvisible(gui.aa.build[x].yaw_modifier_speed, active and menu_get(gui.aa.build[x].yaw_modifier) ~= "Off")
			menu_setvisible(gui.aa.build[x].yaw_modifier_def, active and menu_get(gui.aa.build[x].yaw_modifier) ~= "Off")
			menu_setvisible(gui.aa.build[x].fake_yaw, active)
			menu_setvisible(gui.aa.build[x].fake_l_jitter, active and fake_yaw == "L & R Jitter")
			menu_setvisible(gui.aa.build[x].fake_r_jitter, active and fake_yaw == "L & R Jitter")
			menu_setvisible(gui.aa.build[x].fake_yaw_m, active and fake_yaw ~= "Off" and fake_yaw ~= "L & R Jitter")
			menu_setvisible(gui.aa.build[x].freestand_body, active)
			menu_setvisible(gui.aa.build[x].edge, active)
		end

		local exploits = listitem == 2

		menu_setvisible(gui.aa.x.selctor, exploits)
		local x_defensive = exploits and menu_get(gui.aa.x.selctor) == "Defensive"
		menu_setvisible(gui.aa.x.def_enable, x_defensive)

		local x_defensive_on = x_defensive and menu_get(gui.aa.x.def_enable)
		menu_setvisible(gui.aa.x.def_mode, x_defensive_on)
		menu_setvisible(gui.aa.x.def_speed, x_defensive_on and menu_get(gui.aa.x.def_mode) ~= "sim time check")
		menu_setvisible(gui.aa.x.def_triggers, x_defensive_on)
		menu_setvisible(gui.aa.x.def_hittable, x_defensive_on)
		menu_setvisible(gui.aa.x.def_pitch, x_defensive_on)
		menu_setvisible(gui.aa.x.def_pitch_1, x_defensive_on and menu_get(gui.aa.x.def_pitch) == "Custom")
		menu_setvisible(gui.aa.x.def_pitch_2, x_defensive_on and menu_get(gui.aa.x.def_pitch) == "Custom")
		menu_setvisible(gui.aa.x.def_yaw, x_defensive_on)
		menu_setvisible(gui.aa.x.def_yaw_1, x_defensive_on)
		menu_setvisible(gui.aa.x.def_yaw_speed, x_defensive_on)
		menu_setvisible(gui.aa.x.def_fake, x_defensive_on)

		local fakelag = listitem == 3
		menu_setvisible(gui.aa.fl.amount, fakelag)
		menu_setvisible(gui.aa.fl.variance, fakelag)
		menu_setvisible(gui.aa.fl.limit, fakelag)
		menu_setvisible(gui.aa.fl.better_onshot, fakelag)

		local aa_misc = listitem == 4
		menu_setvisible(gui.aa.misc.selector, aa_misc)

		local freestand = aa_misc and contains(menu_get(gui.aa.misc.selector), "Freestand")
		menu_setvisible(gui.aa.misc.key_freestand, freestand)
	--	menu_setvisible(gui.aa.misc.freestand_disablers, freestand)
		menu_setvisible(gui.aa.misc.freestand_options, freestand)

		local legit_aa = aa_misc and contains(menu_get(gui.aa.misc.selector), "Legit AA")
		menu_setvisible(gui.aa.misc.key_legit_aa, legit_aa)
		menu_setvisible(gui.aa.misc.legitaa_options, legit_aa)

		local edge_yaw = aa_misc and contains(menu_get(gui.aa.misc.selector), "Edge Yaw")
		menu_setvisible(gui.aa.misc.key_edge_yaw, edge_yaw)

		local manual_aa = aa_misc and contains(menu_get(gui.aa.misc.selector), "Manual AA")
		menu_setvisible(gui.aa.misc.manual_options, manual_aa)
		menu_setvisible(gui.aa.misc.key_left, manual_aa)
		menu_setvisible(gui.aa.misc.key_right, manual_aa)
		menu_setvisible(gui.aa.misc.key_forward, manual_aa)

		menu_setvisible(gui.aa.misc.label_keys_split, freestand or legit_aa or edge_yaw or manual_aa)
		menu_setvisible(gui.aa.misc.label_keys, freestand or legit_aa or edge_yaw or manual_aa)

		local misc_configs = listitem == 12

		menu_setvisible(configs.list, misc_configs)
		menu_setvisible(configs.config_name, misc_configs)
		menu_setvisible(configs.save, misc_configs)
		menu_setvisible(configs.load, misc_configs)
		menu_setvisible(configs.delete, misc_configs)
		menu_setvisible(configs.reset, misc_configs)
	
		menu_setvisible(configs.import, misc_configs)
		menu_setvisible(configs.export, misc_configs)
	
		local visuals_clrs = listitem == 8

		menu_setvisible(gui.vis.clr_logs_background, visuals_clrs)
		menu_setvisible(gui.vis.clr_logs_background_1, visuals_clrs)
	end
end

------------------------------- entity handling ---------------------------
local entity = {}

entity.get_local = function(self)
	local player = entity_get_local_player()
	if player == nil or not entity_is_alive(player) then
		player = nil
	end
	return player
end

entity.get_velocity = function(self, player)
	if player == nil then return end
	local x,y,z = entity_get_prop(player, 'm_vecVelocity')
	return math_sqrt(x*x + y*y + z*z)
end

entity.land_delay = 0
entity.cur_state = "Global"
entity.state = function(self)
	-- {"Global", "Stand", "Slow", "Move", "Air", "Duck"}
	local player = self:get_local()

	if player == nil then return end

	local vel = self:get_velocity(player)
	local on_ground = bit_band(entity_get_prop(player, "m_fFlags"), 1) == 1
	local stand = on_ground and vel < 1.2
	local slowwalk = menu_get(gui_extra.refs.slowmotion[1]) and menu_get(gui_extra.refs.slowmotion[2])
	local move = on_ground and vel > 3 and not slowwalk
	local in_air = bit_band(entity_get_prop(player, "m_fFlags"), 1) == 0
	local ducking = entity_get_prop(player, "m_flDuckAmount") > 0.7
    local left = ui.get(gui.aa.build.key_left) and manual_state ~= "left"
	local right = ui.get(gui.aa.build.key_right) and manual_state ~= "right"
	if in_air then
		if ducking then
			entity.land_delay = globals_curtime() + 0.25
			entity.cur_state = "Air+Duck"
		else
			entity.land_delay = globals_curtime() + 0.25
			entity.cur_state = "Air"

		end
	end
	if  left  then
		entity.land_delay = globals_curtime() + 0.000001
		entity.cur_state = "Left"
  end

  if right then
	entity.land_delay = globals_curtime() + 0.000001
	entity.cur_state = "Right"
  end


	if entity.land_delay < globals_curtime() then
		if stand then
			entity.cur_state = "Stand"
		end
		if slowwalk then
			entity.cur_state = "Slowwalk"
		end
		if move then
			entity.cur_state = "Move"
		end




		if ducking then
			entity.cur_state = "Duck"
		end
	end
	return entity.cur_state
end



----------------------------------------------------------------------------





   




local antiaim = {}

antiaim.logs = {}

antiaim.log_check = function(self)
    for j, x in next, self.logs do
        local hp = entity_get_prop(x.idx, "m_iHealth")
        local team = entity_get_prop(x.idx, "m_iTeamNum")
        if hp == nil or team == nil then
            --print("id: " .. j .. " entid: " .. x.idx .. " hp: " .. tostring(hp))
            --print ("succesfully removed") 
            table.remove(self.logs, j)
        else
            if team == entity_get_prop(me, "m_iTeamNum") then
                --print ("succesfully removed " .. entity_get_player_name(j) .. " due to being same team") 
                table.remove(self.logs, j)
            end
        end
    end
end





antiaim.generate_log = function(self)
    local ents = entity_get_players(true)
    local me = entity_get_local_player()
    for i=1, #ents do
        local enemy = ents[i]
        local hp = entity_get_prop(enemy, "m_iHealth")
        if enemy == nil then goto skip end
        if entity_get_prop(enemy, "m_iTeamNum") == entity_get_prop(me, "m_iTeamNum") then goto skip end
        if player == me then goto skip end
            if self.logs[enemy] == nil then
                self.logs[enemy] = {
                    idx = enemy,
                    name = entity_get_player_name(enemy),
                    steam = entity_get_steam64(enemy),
					jitter = {real1 = 0, real2 = 0},
					fake = {f1 = 0, f2 = 0},	
                    should_update = false,
					should_update_bf = false,
					reset_bf = false,
					tapped_me = 0,
					last_miss = 0,
					misses = 0,
                }
				print("Succesfully generated anti-aim for " .. entity_get_player_name(enemy))
                self:log_check()
            end
            
        ::skip::
    end
end

antiaim.n_cache = {
	nade = 0,
	on_ladder = false,
	holding_nade = false
}

antiaim.run_command_check = function(self)
	local me = entity_get_local_player()
	if me == nil then return end

	self.n_cache.on_ladder = entity_get_prop(me, "m_MoveType") == 9 
end

antiaim.at_targets = function(self, threat, yaw_base)

	local pitch, yaw2 = client.camera_angles()
	if threat ~= nil and yaw_base == "At targets" then
		local eyepos = vector(client_eye_position())
		local origin = vector(entity_get_origin(threat))
		local target = origin + vector(0, 0, 40)
		pitch, yaw = eyepos:to(target):angles() 

		return pitch, yaw + 180
	else
		return pitch, yaw2 + 180
	end
end

antiaim.nade_check = function(self, weapon, cmd)
	local pin_pulled = entity_get_prop(weapon, "m_bPinPulled")
	local dt_on = menu_get(gui_extra.refs.dt[2]) and menu_get(gui_extra.refs.dt[1])

	if pin_pulled ~= nil then
		if pin_pulled == 0 or cmd.in_attack == 1 or cmd.in_attack2 == 1 then
			local throw_time = entity_get_prop(weapon, "m_fThrowTime")
			local check = dt_on and throw_time > globals_curtime() or throw_time < globals_curtime()
			if throw_time ~= nil and throw_time > 0 and check then
				local wpnclass = entity_get_classname(weapon)
				self.n_cache.holding_nade = wpnclass:find("Grenade")
				return true
			end
		end
	end
	return false
end

antiaim.can_desync = function(self, cmd, ent, count, vel)
	if self.var.fs_true then return end

	local weapon = entity_get_player_weapon(ent)
	if weapon == nil then return end
	local srv_time = entity_get_prop(ent, "m_nTickBase") * globals.tickinterval()
	local wpnclass = entity_get_classname(weapon)

	if wpnclass:find("Grenade") == nil and cmd.in_attack == 1 and srv_time > entity_get_prop(weapon, "m_flNextPrimaryAttack") - 0.1 and entity_get_classname(weapon) ~= "CC4" then
		-- fix cmd.in_attack =0 1
		return 
	end

	if self:nade_check(weapon, cmd) then return end
	if entity_get_prop(entity_get_game_rules(), "m_bFreezePeriod") == 1 then return false end
	if self.n_cache.on_ladder and vel ~= 0 then return false end
	if cmd.in_use == 1 then return false end

	return true
end

local delays = {
	choked = 0,
	mouse1 = 0,
	dt = 0,
	dt2 = 0,
}

antiaim.get_choke = function(self, cmd)
    local fakelag = menu_get(gui_extra.refs.fl_limit)

	local check_fakelag = fakelag % 2 == 1

    local choked = cmd.chokedcommands
    local check_choke = choked % 2 == 0

	local dt_on = menu_get(gui_extra.refs.dt[2]) and menu_get(gui_extra.refs.dt[1])
	local hs_on = menu_get(gui_extra.refs.hs[2]) and menu_get(gui_extra.refs.hs[1])
	local fd_on = menu_get(gui_extra.refs.fd)

	local vel = entity:get_velocity(entity:get_local())
	if dt_on then
		if delays.choked > 1 then
			if cmd.chokedcommands >= 0 then
				check_choke = false
			end
		end
	end

	delays.choked = cmd.chokedcommands

	if delays.dt ~= dt_on then
		delays.dt2 = globals_curtime() + 0.25
	end

	if not dt_on and not hs_on and not cmd.no_choke or fd_on then
        if not check_fakelag then
			if delays.dt2 > globals_curtime() then
				if cmd.chokedcommands >= 0 and cmd.chokedcommands < fakelag then
					check_choke = choked % 2 == 0
				else
					check_choke = choked % 2 == 1
				end
			else
				check_choke = choked % 2 == 1
			end
        end
    end
	
	delays.dt = dt_on
	return check_choke
end

antiaim.custom = {
	jitter = false,
	yaw = 0,
}

local counter = 0
local fag = false

local function is_hittable(ent)
    ent = ent == enemy and client.current_threat() or ent

    if entity_is_dormant(ent) or not entity_is_alive(ent) then
        return end

    return bit.band(entity_get_esp_data(ent).flags, 2048) ~= 0
end

antiaim.def_pitch = {
	["Down up"] = {"Down", "Up"},
	["Down zero"] = {"Down", "Off"},
	["Up zero"] = {"Up", "Off"}
}

local last_sim_time = 0 -- pasted :c
local defensive_until = 0

antiaim.toticks = function(self, ticks)
	return globals.tickinterval() * ticks;
end

antiaim.is_defensive_active = function(self)
    if entity_get_local_player() == nil or not entity_is_alive(entity_get_local_player()) then return end
    local tickcount = globals.tickcount()
    local sim_time = self:toticks(entity_get_prop(entity_get_local_player(), "m_flSimulationTime"))
    local sim_diff = sim_time - last_sim_time
	
    if sim_diff < 0.0 then
        defensive_until = tickcount + math.abs(sim_diff) - self:toticks(client.latency())
    end
    
    last_sim_time = sim_time

    return defensive_until > tickcount
end

local switch = false
local timer = 0
local data = {}
antiaim.distortion = function(self, cmd, name, speeds, distance)

    if data[name] == nil then
        data[name] = {
            switch = 0,
            timer = 0,
            switch2 = 0
        }
    end

    local speed = ( speeds * 0.01 ) * 0.0625
    local distortion_angle = distance * ( 1 - math.pow( 1 - data[name].timer, 2 ) ) - ( speeds * 0.5 );

    fag = data[name].switch and distortion_angle or -distortion_angle        
    --update timer and go back when we at the end if distortion flip
    data[name].timer = data[name].timer + speed;
    if ( data[name].timer >= 0.7 ) then
        data[name].timer = 0;
        data[name].switch = not data[name].switch
    end

    if data[name].switch2 ~= data[name].switch then
        --fag = fag * 2
        data[name].switch2 = data[name].switch
    end
    return fag
end

antiaim.spin = function(self, cmd, name, speeds, distance)
    if data[name] == nil then
        data[name] = {
            spin = 0,
            spin_reset = true,
        }
    end

    if data[name].spin_reset then
		data[name].spin = data[name].spin + speeds
		if data[name].spin >= distance then
			data[name].spin_reset = not data[name].spin_reset
		end
	else
		data[name].spin = data[name].spin - speeds
		if data[name].spin <= -distance then
			data[name].spin_reset = not data[name].spin_reset
		end
	end
	
	return data[name].spin
end


antiaim.defensive_on = false
antiaim.def_choke_delay = 0
antiaim.def_disable_custom = false
antiaim.def_local_shot = 0
antiaim.jitter2 = false
antiaim.defensive = function(self, cmd)
	local path = gui.aa.x
	local mode = menu_get(path.def_mode)
	local triggers = menu_get(path.def_triggers)
	local hittable = menu_get(path.def_hittable)

	local speed = menu_get(path.def_speed)

	local pitch = menu_get(path.def_pitch)
	local pitch_1 = menu_get(path.def_pitch_1)
	local pitch_2 = menu_get(path.def_pitch_2)

	local yaw = menu_get(path.def_yaw)
	local yaw_speed = menu_get(path.def_yaw_speed)
	local yaw_1 = menu_get(path.def_yaw_1)

	local desync = menu_get(path.def_fake)

	local me = entity_get_local_player()
	if me == nil then return end

	if self.def_local_shot + 1.5 > globals_curtime() then
		self.def_disable_custom = false
		return
	end

	local vel = entity:get_velocity(me)
	local count = globals.tickcount()

	local can_desync = self:can_desync(cmd, me, count, vel)

	local hs_on = menu_get(gui_extra.refs.hs[2]) and menu_get(gui_extra.refs.hs[1])
	local dt_on = menu_get(gui_extra.refs.dt[2]) and menu_get(gui_extra.refs.dt[1])

	local state = entity:state()
	local enablers = contains(triggers, state) and dt_on or hs_on

	local current_player = client.current_threat()
	local _, t_yaw = self:at_targets(current_player, "At targets")

	local _hittable = hittable and is_hittable(current_player) and dt_on or hs_on
	local exploits = dt_on or hs_on

	self.def_disable_custom = _hittable or enablers

	if hs_on or dt_on and enablers or _hittable then
		if mode == "m_nTickbase" then
			if speed == 1 then
				speed = 2
			end
			self.defensive_on = entity_get_prop(me, "m_nTickbase") % speed == 0

		elseif mode == "sim time check" then
			self.defensive_on = self:is_defensive_active()
			cmd.force_defensive = true
		end
		
		if not hs_on and not dt_on then
			cmd.allow_send_packet = false
		end

		local choke = self:get_choke(cmd)
		local pitchh = {89, 89}
		

		if pitch ~= "Off" then
			pitchh = self.def_pitch[pitch]
		end

		local _yaw = 0
		local _pitch_a = 0
		local _pitch_a2 = 0
		local _pitch = pitch ~= "Off" and pitchh or {"Off", "Off"}

		if pitch == "Custom" then
			_pitch = {"Custom", "Custom"}
			_pitch_a = pitch_1
			_pitch_a2 = pitch_2
		end

		if yaw == "Distortion" then
			_yaw = self:distortion(cmd, "hello", yaw_speed * 10, yaw_1)
		elseif yaw == "Spin" then
			_yaw = self:spin(cmd, "test", yaw_speed * 10, yaw_1)
		end

		if self.defensive_on then
			self.jitter2 = not self.jitter2
			cmd.force_defensive = true
			--_pitch = self.jitter and 89 or -89
			--cmd.pitch = self.jitter and pitchh[1] or pitchh[2]
			--_pitch = {_pitch[2], _pitch[1]}
		else
			--_yaw = self.jitter2 and 21 or -21
			--_pitch = {_pitch[1], _pitch[2]}
		end

		if _yaw >= 180 then
			_yaw = 180
		elseif _yaw <= -180 then
			_yaw = -180
		end

		local ref = gui_extra.og_menu
		menu_set(ref.enable[1], true)
		menu_set(ref.pitch[1], self.defensive_on and _pitch[2] or _pitch[1])
		menu_set(ref.pitch[2], self.defensive_on and _pitch_a or _pitch_a2)
		menu_set(ref.base[1], "At targets")
		menu_set(ref.yaw[1], "180")
		menu_set(ref.yaw[2], _yaw)
		--menu_set(ref.body[1], self.jitter2 and "Jitter" or "Static")

		if desync == "Jitter" then
			menu_set(ref.body[1], "Jitter")
		elseif desync == "Jitter off on" then
			menu_set(ref.body[1], self.defensive_on and "Off" or "Jitter")
		else
			menu_set(ref.body[1], "Off")
		end

		menu_set(ref.body[2], 2)
		menu_set(ref.jitter[1], "Off")
		menu_set(ref.jitter[2], 0)
		menu_set(ref.fs[1], false)
	end
end

local cac = 0
local fasg = 0
antiaim.custom_desync = function(self, cmd, real, fake, defensive, speed, _pitch, yaw_base)
	local me = entity_get_local_player()
	if me == nil then return end
	if self.def_disable_custom then return end

	local vel = entity:get_velocity(me)
	local count = globals.tickcount()

	local can_desync = self:can_desync(cmd, me, count, vel)

	counter = counter + 1
	if counter > 100 then
		counter = 1
	end

	local hs_on = menu_get(gui_extra.refs.hs[2]) and menu_get(gui_extra.refs.hs[1])
	local dt_on = menu_get(gui_extra.refs.dt[2]) and menu_get(gui_extra.refs.dt[1])

	if speed > 2 and dt_on or hs_on then
		choke = cmd.chokedcommands + counter % speed == 0
	else
		choke = self:get_choke(cmd)
	end

	local current_player = client.current_threat()
	local _, yaw = self:at_targets(current_player, yaw_base)

	if not hs_on and not dt_on then
		cmd.allow_send_packet = false
	end

	if can_desync then
		if choke and cmd.chokedcommands < 14 then
			cmd.allow_send_packet = false
			self.jitter = not self.jitter
			
			cmd.yaw = self.jitter and fake[1] + yaw or fake[2] + yaw
			--menu_set(gui_extra.og_menu.yaw[2], self.jitter and fake[1] or fake[2])
		else

			cmd.yaw = self.jitter and real[1] + yaw or real[2] + yaw
			if defensive then
				cmd.force_defensive = true
			end

			--cmd.yaw = self.jitter and real[1] + yaw or real[2] + yaw
			--menu_set(gui_extra.og_menu.yaw[2], self.jitter and real[1] or real[2])
		end

		cmd.pitch = _pitch

	end
end	

antiaim.micromovements_fake_flick = function(self, cmd, player)
    local velocity = math_floor(entity:get_velocity(player))

    local m_fFlags = entity_get_prop(player, "m_fFlags")
    local duck = entity_get_prop(player, "m_flDuckAmount") > 0.7

    local on_ground = bit_band(m_fFlags, bit_lshift(1, 0)) == 1

    --we dont rly need the vel check but lets just have it
    local micro = globals.tickcount() % 10
	local w, a, s, d = cmd.in_forward == 1, cmd.in_moveleft == 1, cmd.in_moveright == 1, cmd.in_back == 1

    if not on_ground then return end
    if w or a or s or d then return end

	local amount = duck and 3.25 or 5.1

	if micro > 0 and micro < 5 then
		cmd.sidemove = amount
	elseif micro > 5 then
		cmd.sidemove = -amount
	end
    --if velocity < 1.1 then
end

antiaim.t = {
	jitter = false,
	yaw = 0,
}


local aa = 1
antiaim.flick_sync = function(self, cmd, real, fake)
	local me = entity_get_local_player()
	if me == nil then return end

	local vel = entity:get_velocity(me)
	local count = globals.tickcount()

	local can_desync = self:can_desync(cmd, me, count, vel)

	local hs_on = menu_get(gui_extra.refs.hs[2]) and menu_get(gui_extra.refs.hs[1])
	local dt_on = menu_get(gui_extra.refs.dt[2]) and menu_get(gui_extra.refs.dt[1])

	self:micromovements_fake_flick(cmd, me)

	choke = self:get_choke(cmd)

	local current_player = client.current_threat()
	local _, yaw = self:at_targets(current_player, yaw_base)

	if not hs_on and not dt_on then
		cmd.allow_send_packet = false
	end

	if can_desync then
		if choke and cmd.chokedcommands < 14 then
			cmd.allow_send_packet = false

			self.jitter = not self.jitter
			
			cmd.yaw = self.jitter and 0 + yaw or 0 + yaw
			--menu_set(gui_extra.og_menu.yaw[2], self.jitter and fake[1] or fake[2])
		else
			aa = aa + 1
			if aa > 3 then
				aa = 1
			end

			if aa == 1 then
				cmd.yaw = -45 + yaw
			elseif aa == 2 then
				cmd.force_defensive = true

				cmd.yaw = self.jitter and -75 + yaw or 75 + yaw
			elseif aa == 3 then
				cmd.yaw = 25 + yaw
			end

			cmd.allow_send_packet = false
			--menu_set(gui_extra.og_menu.yaw[2], self.jitter and real[1] or real[2])
		end
		
		cmd.pitch = 89

	end
end	


antiaim.jitter_handle = function(self, cmd, mode, yaw, amount)
	local _amount = math_abs(amount)
	if yaw == nil then
		return
	end

	if mode == "Offset" then
		return {yaw, amount}
	elseif mode == "Center" then
		return {-_amount + yaw, _amount + yaw}
	elseif mode == "Random" then
		local _ran = math.random(-_amount, _amount)
		return {_ran + yaw, _ran + yaw}
	elseif mode == "Skitter" then
	end
end

antiaim.fake_handle = function(self, cmd, mode, yaw, amount)
	local _amount = math_abs(amount)

	if mode == "Offset" then
		return {yaw, amount}
	elseif mode == "Center" then
		return {-_amount + yaw, _amount + yaw}
	elseif mode == "Random" then
		local _ran = math.random(-_amount, _amount)
		return {_ran + yaw, _ran + yaw}
	elseif mode == "Skitter" then
	end
end

local nigger = 3
antiaim.pitch_handle = function(self, cmd, mode, amount)
	local _amount = math_abs(amount)
	local pitch, yaw2 = client.camera_angles()

	if mode == "Off" then
		return pitch
	elseif mode == "Default" then
		return 89
	elseif mode == "Up" then
		return -89
	elseif mode == "Down" then
		return 90
	elseif mode == "Minimal" then
		return 80
	elseif mode == "Random" then
		local _ran = math.random(-89, 89)
		return _ran
	elseif mode == "Custom" then
		return amount
	end
end

antiaim.og_real = 0
antiaim.real_handle = function(self, cmd, amount)
	self.og_real = amount

	local _amount = math_abs(amount)
	local current_player = client_current_threat()

	if current_player == nil then
		return amount
	end

	if self.logs[current_player] then
		local tap = self.logs[current_player].tapped_me

		if tap > 2 then
			self.logs[current_player].tapped_me = 0
		end

		if tap == 0 then
			return _amount
		elseif tap == 1 then
			return 0
		elseif tap == 2 then
			return -_amount
		end
	else
		return amount
	end
	-- lets switch between like 3 values with good variance
end

antiaim.generations = function(self, cmd, threat, jitter, desync)
	if self.logs[threat] then
		if self.logs[threat].should_update_bf then
			local side1 = math.random(jitter[1] - 9, jitter[1] + 14)
			local side2 = math.random(jitter[2] - 9, jitter[2] + 14)

			print("gen jitter: " .. side1 .. " " .. side2)
			self.logs[threat].jitter = {real1 = side1, real2 = side2}

			local sidef1 = math.random(0, desync[1])

			print("gen desync: " .. sidef1 .. " " .. -sidef1)
			self.logs[threat].fake = {f1 = sidef1, f2 = -sidef1}
			self.logs[threat].should_update_bf = false


		end
	end
end

antiaim.cur_aa = {}
antiaim.store = {}
antiaim.builder = function(self, cmd)
	local condition = entity:state()

	if gui.aa.build[condition] == false then return end

	local enabled = menu_get(gui.aa.build[condition].enable)
	if enabled == nil then return end

	local enemy = client.current_threat()

	local path = enabled and gui.aa.build[condition] or gui.aa.build["Global"]

	local pitch 				= menu_get(path.pitch)
	local pitch_s 				= menu_get(path.pitch_s)
	local yaw_base 				= menu_get(path.yaw_base)
	local yaw 					= menu_get(path.yaw)
	local yaw_amount 			= menu_get(path.yaw_amount)
	local yaw_anti_log	 		= menu_get(path.yaw_nolog)
	local yaw_modifier 			= menu_get(path.yaw_modifier)
	local yaw_modifier_m 		= menu_get(path.yaw_modifier_m)
	local yaw_modifier_l		= menu_get(path.yaw_modifier_l)
	local yaw_modifier_r		= menu_get(path.yaw_modifier_r)
	local yaw_modifier_speed 	= menu_get(path.yaw_modifier_speed)
	local yaw_modifier_def 		= menu_get(path.yaw_modifier_def)
	local fake_yaw				= menu_get(path.fake_yaw)
	local fake_l_jitter 		= menu_get(path.fake_l_jitter)
	local fake_r_jitter 		= menu_get(path.fake_r_jitter)
	local fake_yaw_m 			= menu_get(path.fake_yaw_m)
	local freestand_body 		= menu_get(path.freestand_body)
	local edge 					= menu_get(path.edge)

	self.cur_aa.pitch = pitch
	self.cur_aa.pitch_s = pitch_s
	self.cur_aa.yaw_base = yaw_base
	self.cur_aa.yaw = yaw
	self.cur_aa.yaw_amount = yaw_amount
	self.cur_aa.yaw_anti_log = yaw_anti_log
	self.cur_aa.yaw_modifier = yaw_modifier
	self.cur_aa.yaw_modifier_m = yaw_modifier_m
	self.cur_aa.yaw_modifier_speed = yaw_modifier_speed
	self.cur_aa.yaw_modifier_def = yaw_modifier_def
	self.cur_aa.fake_yaw = fake_yaw
	self.cur_aa.fake_l_jitter = fake_l_jitter * 2
	self.cur_aa.fake_r_jitter = fake_r_jitter * 2
	self.cur_aa.fake_yaw_m = fake_yaw_m * 2
	self.cur_aa.freestand_body = freestand_body
	self.cur_aa.edge = edge

	local _yaw = yaw_amount

	if yaw_anti_log then
		_yaw = self:real_handle(cmd, yaw_amount)
	end

	if _yaw == nil then
		_yaw = 0
	end

	local pitch = self:pitch_handle(cmd, pitch, pitch_s)

	local _jitter = self:jitter_handle(cmd, yaw_modifier, _yaw, yaw_modifier_m, yaw_modifier_speed, yaw_modifier_def)
	if _jitter == nil then _jitter = {0,0} end

	local anti_bf = menu_get(gui.aa.build.abf.auto)
	local alter_real = contains(anti_bf, "Alter real jitter")
	local alter_desync = contains(anti_bf, "Alter desync value")
		
	if yaw_modifier == "Off" then
		real = {_yaw, _yaw}
	elseif yaw_modifier == "L & R" then
		real = {yaw_modifier_l, yaw_modifier_r}
	end

	local fake = fake_yaw == "L & R Jitter" and {fake_l_jitter * 2 + _yaw, fake_r_jitter * 2 + _yaw} or {fake_yaw_m + _yaw, fake_yaw_m + _yaw}
	if fake_yaw == "Jitter" then
		fake = {fake_yaw_m * 2 + _yaw, -fake_yaw_m * 2 + _yaw}
	end

	local bf_reset = menu_get(gui.aa.build.abf.reset)
	if self.logs[enemy] then
		self:generations(cmd, enemy, _jitter, fake)

		if contains(bf_reset, "Timer") and self.logs[enemy].last_miss + menu_get(gui.aa.build.abf.timer) > globals_curtime() then
			if alter_real then
				_jitter = {self.logs[enemy].jitter.real1, self.logs[enemy].jitter.real2}
			end
			if alter_desync then
				fake = {self.logs[enemy].fake.f1, self.logs[enemy].fake.f2}
			end
		end
		if self.logs[enemy].reset_bf then
			if alter_real then
				_jitter = {self.logs[enemy].jitter.real1, self.logs[enemy].jitter.real2}
			end
			if alter_desync then
				fake = {self.logs[enemy].fake.f1, self.logs[enemy].fake.f2}
			end
		end
	end

	local real = _jitter ~= nil and {_jitter[1], _jitter[2]} or {0,0}
	
	menu_set(gui_extra.og_menu.enable[1], false)
	menu_set(gui_extra.og_menu.base[1], yaw_base)
	menu_set(gui_extra.og_menu.yaw[1], "180")

	self:custom_desync(cmd, real, fake, yaw_modifier_def, yaw_modifier_speed, pitch, yaw_base)
end

antiaim.set_gs_preset = function(self, yaw, jitter)
	if yaw == nil then yaw = 0 end
	local ref = gui_extra.og_menu
	menu_set(ref.enable[1], true)
	menu_set(ref.pitch[1], "Down")
	menu_set(ref.base[1], "At targets")
	menu_set(ref.yaw[1], "180")
	menu_set(ref.yaw[2], yaw)
	menu_set(ref.body[1], jitter and "Jitter" or "Static")
	menu_set(ref.body[2], 2)
	menu_set(ref.jitter[1], jitter and "Center" or "Off")
	menu_set(ref.jitter[2], jitter and 64 or 0)
	menu_set(ref.fs[1], false)
end

antiaim.var = {
	aa_dir = 0,
	last_press_t = 0,
	last_fs = 0,
	fs_true = false,
}


menu_set(gui_extra.og_menu.freestand[2], "Toggle")

antiaim.handle_keybinds = function(self, cmd)


--[[	if ui.get(gui.aa.build.key_right) and aa.last_pressed + 0.2 < globals.curtime() then
		aa.manual_state = aa.manual_state == "right" and "reset" or "right"
		aa.last_pressed = globals.curtime()
	elseif ui.get(gui.aa.build.key_left) and aa.last_pressed + 0.2 < globals.curtime() then
		aa.manual_state = aa.manual_state == "left" and "reset" or "left"
		aa.last_pressed = globals.curtime()
	elseif ui.get(new_menu_references["keys"].manual_forward) and aa.last_pressed + 0.2 < globals.curtime() then
		aa.manual_state = aa.manual_state == "forward" and "reset" or "forward"
		aa.last_pressed = globals.curtime()
	elseif ui.get(new_menu_references["keys"].manual_reset) and aa.last_pressed + 0.2 < globals.curtime() then
		aa.manual_state = "reset"
		aa.last_pressed = globals.curtime()
	elseif aa.last_pressed > globals.curtime() then
		aa.last_pressed = globals.curtime()
	end--]]























	local freestand = contains(menu_get(gui.aa.misc.selector), "Freestand")
	local freestand_active = { menu_get(gui.aa.misc.key_freestand) }

	local state = entity:state()
--	local fs_disablers = contains(menu_get(gui.aa.misc.freestand_disablers), state)
	local mode = menu_get(gui.aa.misc.freestand_options)

	local freestand = menu_get(gui.aa.misc.key_freestand) and not fs_disablers
	self.var.fs_true = freestand

    menu_set(gui_extra.og_menu.freestand[1], freestand)
    menu_set(gui_extra.og_menu.freestand[2], freestand and 'Always on' or 'Toggle')



	if freestand then
		self:set_gs_preset(0, mode == "Jitter")
	end
end

antiaim.antibf_impact = function(self, e)
    local me = entity_get_local_player()

    if not entity_is_alive(me) then return end

    local shooter_id = e.userid
    local shooter = client_userid_to_entindex(shooter_id)

	if shooter == me then
		self.def_local_shot = globals_curtime()
	end

    if not entity_is_enemy(shooter) or entity_is_dormant(shooter) then return end

    local lx, ly, lz = entity_hitbox_position(me, "head_0")
    
    local ox, oy, oz = entity_get_prop(me, "m_vecOrigin")
    local ex, ey, ez = entity_get_prop(shooter, "m_vecOrigin")

    local dist = ((e.y - ey)*lx - (e.x - ex)*ly + e.x*ey - e.y*ex) / math.sqrt((e.y-ey)^2 + (e.x - ex)^2)

	if self.logs[shooter] == nil then
	self.logs[shooter] = {
			idx = shooter,
			jitter = {real1 = 0, real2 = 0},
			fake = {c = 0, j = 0, f = 0},
			should_update = false,
			should_update_bf = false,
			reset_bf = false,
			last_miss = globals_curtime(),
			misses = 0,
			side = false,
		}
	end
    
	if math_abs(dist) <= 65 and globals_curtime() - self.logs[shooter].last_miss > 0.015 then

		self.logs[shooter].should_update_bf = true
		self.logs[shooter].reset_bf = true

		--local console_txt = 'Player ' .. entity_get_player_name( shooter ) .. " activated anti-bruteforce [" .. tostring(self.logs[shooter].side) .. "] total: " .. self.logs[shooter].misses
		
		local txt = entity_get_player_name( shooter ) .. " (nn) shot and missed xaxaxa (maybe anti bf happens now, or not who knows???+)"
		print(txt)

		local loaded =  {
			{colors.blue, entity_get_player_name(shooter)},
			{colors.white, " activated "},
			{colors.blue, "anti-bruteforce "},
		}
		
		visuals:add_to_log(loaded, entity_get_player_name(shooter) .. " activated anti-bruteforce ", "notify", "me")


		self.logs[shooter].misses = self.logs[shooter].misses + 1
		self.logs[shooter].last_miss = globals_curtime()
    end
end

antiaim.on_shot = {
	on = false,
	update = false,
	better_onshot = 0,
	cache_fakelag = 1,
}

antiaim.fakelag = function(self)
menu_set(gui_extra.og_menu.fl_amount[1], menu_get(gui.aa.fl.amount))
menu_set(gui_extra.og_menu.fl_variance[1], menu_get(gui.aa.fl.variance))
menu_set(gui_extra.og_menu.fl_limit[1], menu_get(gui.aa.fl.limit))

if menu_get(gui.aa.fl.better_onshot) then
	local refs = gui_extra.refs
	local dt_on = menu_get(refs.dt[2]) and menu_get(refs.dt[1])
	local hs_on = menu_get(refs.hs[2]) and menu_get(refs.hs[1])
	local fd_on = menu_get(refs.fd)

	self.on_shot.on = self.on_shot.better_onshot > globals_curtime()

	if self.on_shot.on then
		self.on_shot.update = true
		--if dt_on then
			if fd_on then
				menu_set(refs.fl_limit, 14)
				--debug.better_onshot = "antiaim:better_onshot() BLOCK -> L1490"
			else
				--debug.better_onshot = "antiaim:better_onshot() -> L1580"
				menu_set(refs.fl_limit, 1)
			end
		--end
	end
	
	if not self.on_shot.on and self.on_shot.update then
		--debug.better_onshot = "antiaim:better_onshot() RESET -> L1580"
		menu_set(refs.fl_limit, 14)
		self.on_shot.update = false
	end
end
end

antiaim.main = function(self, cmd)

	self:generate_log(cmd)

	if listclick[2][2] then
		self:builder(cmd)
	end

	if listclick[3][2] and menu_get(gui.aa.x.def_enable) then
		self:defensive(cmd)
	end

	if listclick[4][2] then
		self:fakelag(cmd)
	end
	menu_set(gui_extra.og_menu.fl_enabled[1], listclick[4][2])


	if listclick[5][2] then
		self:handle_keybinds(cmd)
	end


	--self:flick_sync(cmd)
end

client_set_event_callback("aim_fire", function()

	antiaim.on_shot.better_onshot = globals_curtime() + 1
end)

client_set_event_callback("override_view", function(e)

	--e.x = e.x + 35
end)


client_set_event_callback("round_end", function(e)
	if contains(menu_get(gui.aa.build.abf.reset), "New round") then
		for i, x in ipairs(antiaim.logs) do
			x.reset_bf = false
		end
	end
end)

client_set_event_callback("player_death", function(e)

    local victim = client_userid_to_entindex(e.userid)
    local attacker = client_userid_to_entindex(e.attacker)

	local me = entity_get_local_player()
	if me == victim then
		antiaim.var.fs_true = false
	end

    if victim ~= entity_get_local_player() then return end
    if not entity_is_enemy(attacker) then return end

	if antiaim.logs[attacker] then

		if contains(menu_get(gui.aa.build.abf.reset), "Enemy died") then
			antiaim.logs[attacker].reset_bf = false
		end

		if not e.headshot then return end

		if contains(menu_get(gui.aa.build.abf.reset), "Stay until local HS") then
			antiaim.logs[attacker].reset_bf = false
		end

		antiaim.logs[attacker].should_update = true
		antiaim.logs[attacker].should_update_bf = false
		antiaim.logs[attacker].tapped_me = antiaim.logs[attacker].tapped_me + 1
		antiaim.logs[attacker].side = nil
	end
end)
----------------------------------------------------------------------------
local table_insert, table_concat, string_rep, string_len, string_sub = table.insert, table.concat, string.rep, string.len, string.sub

local x = {}
local function len(str)
	local _, count = string.gsub(tostring(str), "[^\128-\193]", "")
	return count
end

local styles = {
	--					 1    2     3    4    5     6    7    8     9    10   11
	["ASCII"] = {"-", "|", "+"},
	["Compact"] = {"-", " ", " ", " ", " ", " ", " ", " "},
	["ASCII (Girder)"] = {"=", "||",  "//", "[]", "\\\\",  "|]", "[]", "[|",  "\\\\", "[]", "//"},
	["Unicode"] = {"═", "║",  "╔", "╦", "╗",  "╠", "╬", "╣",  "╚", "╩", "╝"},
	["Unicode (Single Line)"] = {"─", "│",  "┌", "┬", "┐",  "├", "┼", "┤",  "└", "┴", "┘"},
	["Markdown (Github)"] = {"-", "|", "|"}
}

--initialize missing style values (ascii etc)
for _, style in pairs(styles) do
	if #style == 3 then
		for j=4, 11 do
			style[j] = style[3]
		end
	end
end

local function justify_center(text, width)
	text = string_sub(text, 1, width)
	local length = len(text)
	return string_rep(" ", math_floor(width/2-length/2)) .. text .. string_rep(" ", math_ceil(width/2-length/2))
end

local function justify_left(text, width)
	text = string_sub(text, 1, width)
	return text .. string_rep(" ", width-len(text))
end

function generate_table(rows, headings, options)
	if type(options) == "string" or options == nil then
		options = {
			style=options or "ASCII",
		}
	end

	if options.top_line == nil then
		options.top_line = options.style ~= "Markdown (Github)"
	end

	if options.bottom_line == nil then
		options.bottom_line = options.style ~= "Markdown (Github)"
	end

	if options.header_seperator_line == nil then
		options.header_seperator_line = true
	end

	local seperators = styles[options.style] or styles["ASCII"]

	local rows_out, columns_width, columns_count = {}, {}, 0
	local has_headings = headings ~= nil and #headings > 0

	if has_headings then
		for i=1, #headings do
			columns_width[i] = len(headings[i])+2
		end
		columns_count = #headings
	else
		for i=1, #rows do
			columns_count = math_max(columns_count, #rows[i])
		end
	end

	for i=1, #rows do
		local row = rows[i]
		for c=1, columns_count do
			columns_width[c] = math_max(columns_width[c] or 2, len(row[c])+2)
		end
	end

	local column_seperator_rows = {}
	for i=1, columns_count do
		table_insert(column_seperator_rows, string_rep(seperators[1], columns_width[i]))
	end
	if options.top_line then
		table_insert(rows_out, seperators[3] .. table_concat(column_seperator_rows, seperators[4]) .. seperators[5])
	end

	if has_headings then
		local headings_justified = {}
		for i=1, columns_count do
			headings_justified[i] = justify_center(headings[i], columns_width[i])
		end
		table_insert(rows_out, seperators[2] .. table_concat(headings_justified, seperators[2]) .. seperators[2])
		if options.header_seperator_line then
			table_insert(rows_out, seperators[6] .. table_concat(column_seperator_rows, seperators[7]) .. seperators[8])
		end
	end

	for i=1, #rows do
		local row, row_out = rows[i], {}
		if #row == 0 then
			table_insert(rows_out, seperators[6] .. table_concat(column_seperator_rows, seperators[7]) .. seperators[8])
		else
			for j=1, columns_count do
				local justified = options.value_justify == "center" and justify_center(row[j] or "", columns_width[j]-2) or justify_left(row[j] or "", columns_width[j]-2)
				row_out[j] = " " .. justified .. " "
			end
			table_insert(rows_out, seperators[2] .. table_concat(row_out, seperators[2]) .. seperators[2])
		end
	end

	if options.bottom_line and seperators[9] then
		table_insert(rows_out, seperators[9] .. table_concat(column_seperator_rows, seperators[10]) .. seperators[11])
	end

	return table_concat(rows_out, "\n")
end

cvar.con_filter_enable:set_int(1)
cvar.con_filter_text:set_string("IrWL5106TZZKNFPz4P4Gl3pSN?J370f5hi373ZjPg%VOVh6lN")
local cmds = {}
cmds = {
    ["cfg"] = {
        help = function(addition)
            addition = addition or ""
            print(addition .. "cfg:")
            print(addition .. "     - export: export the current configuration to clipboard")
            print(addition .. "     - import: import a configuration from clipboard")
        end,
        ["export"] = function()
            -- export config to clipboard
            print("Exporting current configuration to clipboard")
        end,
        ["import"] = function()
            -- import config from clipboard
            print("Importing configuration from clipboard")
        end
    },
    ["get"] = {
        help = function(addition)
            addition = addition or ""
            print(addition .. "get:")
            print(addition .. "     - aa: get anti-aim settings")
        end,
        ["aa"] = {
            help = function(addition)
                addition = addition or ""
                print(addition .. "get aa:")
                print(addition .. "    - details: gets the current details of your anti-aim")
                print(addition .. "    - log(argument): gets current log for all or defined player logged entities")
            end,
			["details"] = function(extraInfo)
                -- set the yaw menu element or something
                -- yaw_menu_element:Set(extraInfo) or whatever
				print("====================== current aa =======================")
				local path = antiaim.cur_aa
				print(string.format("Pitch: %s, %i", path.pitch, path.pitch_s))
				print(string.format("Yaw: base %s, %s %i, anti_log: %s", path.yaw_base, path.yaw, path.yaw_amount, path.yaw_anti_log))
				print(string.format("Modifier: %s %i, speed: %i, defensive: %s", path.yaw_modifier, path.yaw_modifier_m, path.yaw_modifier_speed, path.yaw_modifier_def))
				print(string.format("Fake: %s %i, L: %i, R: %i", path.fake_yaw, path.fake_yaw_m, path.fake_l_jitter, path.fake_r_jitter))
				print("=========================================================")

            end,
			["log"] = function(extraInfo)
                -- set the yaw menu element or something
                -- yaw_menu_element:Set(extraInfo) or whatever
				local input = extraInfo[1]:lower()
				local c = 0

				if input == "help" then
					print("use argument 'get aa log all' or a unique player name like 'get aa log tyler'")
					return
				end

				local headings = {"id", "idx", "name", "steam64", "should_update", "tapped_me"}
				local rows = {}

                for i, x in pairs(antiaim.logs) do
					local path = antiaim.logs[i]
					c = c + 1

					if path.steam == 0 then path.steam = "BOT" end

					if input == "all" then
						rows[c] = {c, path.idx, path.name, path.steam, tostring(path.should_update), tostring(path.tapped_me)}
					elseif input == path.name:lower() then
						rows[1] = {c, path.idx, path.name, path.steam, tostring(path.should_update), tostring(path.tapped_me)}
						local table_out = generate_table(rows, headings, {
							style = "Unicode (Single Line)"
						})
		
						print("\n" .. table_out)
						return
					end
				end

				local table_out = generate_table(rows, headings, {
					style = "Unicode (Single Line)"
				})

				print("\n" .. table_out)
            end,
        },
    },
    ["set"] = {
        help = function(addition)
            addition = addition or ""
            print(addition .. "set:")
            print(addition .. "     - aa: set anti-aim settings")
        end,
        ["aa"] = {
            help = function(addition)
                addition = addition or ""
                print(addition .. "set aa:")
                print(addition .. "    - yaw: set yaw")
                print(addition .. "    - desync: set desync")
            end,
            ["yaw"] = function(extraInfo)
                -- set the yaw menu element or something
                -- yaw_menu_element:Set(extraInfo) or whatever
                print(":c")
            end,
            ["desync"] = function(extraInfo)
                -- set the yaw menu element or something
                -- yaw_menu_element:Set(extraInfo) or whatever
                print("desync correct: " .. extraInfo)
            end,
        },
    },
    ["help"] = function ()
        -- print all commands and their sub commands
        for k, v in pairs(cmds) do
            if k ~= "help" then
                if type(v) == "table" then
                    v.help("\t")
                    for k2, v2 in pairs(v) do
                        if type(v2) == "table" then
                            v2.help("\t\t")
                        end
                    end
                end
            end
        end
    end
}
--cmds.help()

local function splitString(str, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

-- fetch input from console
--local input = io.read()

local function handleCommand(input)
    -- our input could be "cfg export <file name>"
    -- split input string at " "
    -- cmd is the main command, for example "cfg"
    -- subCmd is the possible subCommand, for example "export"
    -- cmdInfo is the possible extra information that a command might need, for example "<file name> or <number> for menu settings"
    
    -- extract cmd and subCmd from the input and save the rest in a table
    local cmdInfo = splitString(input, " ")
    cmd = cmdInfo[1]
    subCmd = cmdInfo[2]

    if cmdInfo[3] ~= nil then
        subSubCmd = cmdInfo[3]
        subSubValueCmd = cmdInfo[4]
        table.remove(cmdInfo, 1) 
        table.remove(cmdInfo, 1) 
    end


    -- remove cmd and subCmd from cmdInfo and save the rest into cmdInfo
    table.remove(cmdInfo, 1) 
   -- table.remove(cmdInfo, 1)


    -- check if our command is valid
    if cmds[cmd] then
        -- if our command is valid, check if we have a sub command, by checking if its a table
        if type(cmds[cmd]) == "table" then
            -- check if the provided sub command exists for our current command
            if cmds[cmd][subCmd] then
                -- if so, call the command callback with the parameter "cmdInfo"
                if subSubCmd == nil or subSubValueCmd == nil then
                    if type(cmds[cmd][subCmd]) == "table" then
                        cmds[cmd][subCmd].help()
                    else
                        cmds[cmd][subCmd](cmdInfo)
                    end
                else
                    if subSubCmd ~= nil then
                        cmds[cmd][subCmd][subSubCmd](cmdInfo)
                    end
                end
            else
                -- if the provided sub command doesnt exist or wasn't provided, call the help function
                cmds[cmd].help("")
            end
        else
            -- our command wasn't a table, meaning it doesnt contain any sub commands, so call the command callback directly
            cmds[cmd]()
        end
    else
        -- our command was not valid, so let the user know
        print("Command not found")
    end
end

--handleCommand(input)


client_set_event_callback("console_input", function(input)

        handleCommand(input)

end)


client_set_event_callback("bullet_impact", function(e)
	antiaim:antibf_impact(e)
end)

client_set_event_callback("setup_command", function(cmd)

	antiaim:main(cmd)

end)

client_set_event_callback("run_command", function()
	antiaim:run_command_check()
end)

client_set_event_callback("paint_ui", function()

	gui_extra:animate_astral()

	if is_menu_open() then
		gui_extra:visibility()
		gui_extra:reset(false)

	end

	visuals:main()

end)


client_set_event_callback("shutdown", function()

	gui_extra:reset(true)

end)

for i, x in ipairs(configs.getConfigNames()) do
	if x:lower() == "default" then
		local protected = function()
			local cfg = db_configs[x]
	
			if cfg == nil then
				cfg = cloud_presets[x]
			end
	
			local json_config = base64.decode(cfg, CUSTOM_DECODER)
	
			if json_config:match(configs.validation_key) == nil then
				error("cannot_find_validation_key")
				return
			end
	
			if json_config:match("clicks") then
				local to_table = json.parse(json_config)
				list_click = to_table["clicks"]
				gui_extra:list_clicks()
			end
	
			json_config = json.parse(json_config)
	
	
			if json_config == nil then
				error("wrong_json")
				return
			end
	
			local loaded =  {
				{colors.white, "Succesfully "},
				{colors.blue, "loaded "},
				{colors.white, "configuration "},
				{colors.blue, x},
			}
			
			visuals:add_to_log(loaded, "Succesfully loaded configuration " .. x, "notify", "me")
			
			print("Succesfully loaded configuration " .. x)
			configs.loadTable(json_config, gui)
		end	

		local status, message = pcall(protected)
	end
end





