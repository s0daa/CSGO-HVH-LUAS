-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
	local requirements = {
		vector = require("vector"),
		bit = require("bit"),
		antiaim_funcs = require("gamesense/antiaim_funcs"),
		csgo_weapons = require("gamesense/csgo_weapons"),
		clipboard = require("gamesense/clipboard"),
		base64 = require 'gamesense/base64',
		obex_data = obex_fetch and obex_fetch() or {username = 'peti', build = 'source'},
	ent = require "gamesense/entity"

	}
	local bit_band, client_camera_angles, client_color_log, client_create_interface, client_delay_call, client_exec, client_eye_position, client_key_state, client_log, client_random_int, client_scale_damage, client_screen_size, client_set_event_callback, client_trace_bullet, client_userid_to_entindex, database_read, database_write, entity_get_local_player, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_enemy, math_abs, math_atan2, require, error, globals_absoluteframetime, globals_curtime, globals_realtime, math_atan, math_cos, math_deg, math_floor, math_max, math_min, math_rad, math_sin, math_sqrt, print, renderer_circle_outline, renderer_gradient, renderer_measure_text, renderer_rectangle, renderer_text, renderer_triangle, string_find, string_gmatch, string_gsub, string_lower, table_insert, table_remove, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_hotkey, ui_new_multiselect, ui_reference, tostring, ui_is_menu_open, ui_mouse_position, ui_new_combobox, ui_new_slider, ui_set, ui_set_callback, ui_set_visible, tonumber, pcall = bit.band, client.camera_angles, client.color_log, client.create_interface, client.delay_call, client.exec, client.eye_position, client.key_state, client.log, client.random_int, client.scale_damage, client.screen_size, client.set_event_callback, client.trace_bullet, client.userid_to_entindex, database.read, database.write, entity.get_local_player, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_enemy, math.abs, math.atan2, require, error, globals.absoluteframetime, globals.curtime, globals.realtime, math.atan, math.cos, math.deg, math.floor, math.max, math.min, math.rad, math.sin, math.sqrt, print, renderer.circle_outline, renderer.gradient, renderer.measure_text, renderer.rectangle, renderer.text, renderer.triangle, string.find, string.gmatch, string.gsub, string.lower, table.insert, table.remove, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_hotkey, ui.new_multiselect, ui.reference, tostring, ui.is_menu_open, ui.mouse_position, ui.new_combobox, ui.new_slider, ui.set, ui.set_callback, ui.set_visible, tonumber, pcall
	local ui_menu_position, ui_menu_size, math_pi, renderer_indicator, entity_is_dormant, client_set_clan_tag, client_trace_line, entity_get_all, entity_get_classname = ui.menu_position, ui.menu_size, math.pi, renderer.indicator, entity.is_dormant, client.set_clan_tag, client.trace_line, entity.get_all, entity.get_classname
	local ffi = require('ffi')
	local ffi_cast = ffi.cast

	ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
	]]
	local VGUI_System010 =  client_create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
	local VGUI_System = ffi_cast(ffi.typeof('void***'), VGUI_System010 )
	local get_clipboard_text_count = ffi_cast( "get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
	local set_clipboard_text = ffi_cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
	local get_clipboard_text = ffi_cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")


	
local angle3d_struct = ffi.typeof("struct { float pitch; float yaw; float roll; }")
local vec_struct = ffi.typeof("struct { float x; float y; float z; }")

local cUserCmd =
    ffi.typeof(
    [[
    struct
    {
        uintptr_t vfptr;
        int command_number;
        int tick_count;
        $ viewangles;
        $ aimdirection;
        float forwardmove;
        float sidemove;
        float upmove;
        int buttons;
        uint8_t impulse;
        int weaponselect;
        int weaponsubtype;
        int random_seed;
        short mousedx;
        short mousedy;
        bool hasbeenpredicted;
        $ headangles;
        $ headoffset;
        bool send_packet; 
    }
    ]],
    angle3d_struct,
    vec_struct,
    angle3d_struct,
    vec_struct
)

local client_sig = client.find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85") or error("client.dll!:input not found.")
local get_cUserCmd = ffi.typeof("$* (__thiscall*)(uintptr_t ecx, int nSlot, int sequence_number)", cUserCmd)
local input_vtbl = ffi.typeof([[struct{uintptr_t padding[8];$ GetUserCmd;}]],get_cUserCmd)
local input = ffi.typeof([[struct{$* vfptr;}*]], input_vtbl)
local get_input = ffi.cast(input,ffi.cast("uintptr_t**",tonumber(ffi.cast("uintptr_t", client_sig)) + 1)[0])
	local function clipboard_import( )
		local clipboard_text_length = get_clipboard_text_count( VGUI_System )
		local clipboard_data = ""

		if clipboard_text_length > 0 then
			buffer = ffi.new("char[?]", clipboard_text_length)
			size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)

			get_clipboard_text( VGUI_System, 0, buffer, size )

			clipboard_data = ffi.string( buffer, clipboard_text_length-1 )
		end
		return clipboard_data
	end

	local function clipboard_export(string)
		if string then
			set_clipboard_text(VGUI_System, string, string:len())
		end
	end
	--Important Functions
	local function contains(table, value)

		if table == nil then
			return false
		end

		table = ui.get(table)
		for i=0, #table do
			if table[i] == value then
				return true
			end
		end
		return false
	end


	local function SetTableVisibility(table, state)
		for i = 1, #table do
			ui.set_visible(table[i], state)
		end
	end

	local function oppositefix(c)
		local desync_amount = antiaim_funcs.get_desync(2)
		if math.abs(desync_amount) < 15 or c.chokedcommands ~= 0 then
			return
		end
	end

	--References
	local ref = {
		pitch = {ui.reference("AA", "Anti-aimbot angles", "Pitch")},
		yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
		yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
		jitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
		byaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
		fby = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
		edge = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
		freestanding = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
		roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
		os = {ui.reference("AA", "Other", "On shot anti-aim")},
		dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
		slowwalk = {ui.reference("AA","Other","Slow motion")},
		lm = ui.reference("AA","Other","Leg movement"),
		rollskeet = ui.reference("AA","Anti-aimbot angles", "Roll"),
		fake_duck = ui.reference("RAGE","Other","Duck peek assist"),
		enablefl = ui.reference("AA","Fake lag","Enabled"),
		fl_amount = ui.reference("AA", "Fake lag", "Amount"),
		fl_limit = ui.reference("AA","Fake lag","Limit"),
		fl_var = ui.reference("AA", "fake lag", "variance"),
		sp_key = ui.reference("RAGE", "Aimbot", "Force safe point"),
		baim_key = ui.reference("RAGE", "Aimbot", "Force body aim"),
		quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
		bt = {ui.reference("RAGE","Other","Accuracy boost")},
		force_safe_point = ui.reference("RAGE", "Aimbot", "Force safe point"),
		mindmg = ui.reference("RAGE", "Aimbot", "Minimum damage"),
		safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
		forcebaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
	}





	ui.new_label("AA", "Anti-aimbot angles", "\aE1DEFD99alien "..requirements.obex_data.build.." - \aFFFFFFFF"..requirements.obex_data.username.."")
	local menu = {
		retard = ui.new_combobox("AA", "Anti-aimbot angles", "[\aE1DEFD99Global\aFFFFFFFF] Tab", "Anti-Aim", "Anti-Bruteforce", "Visuals", "Misc"),
		subtab_antiaim = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFF88[\aE1DEFD99AA\aFFFFFF88] Section", "Anti-Aim", "Keybinds"),
		presets = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFF88[\aE1DEFD99AA\aFFFFFF88] Presets", "None", "Dynamic", "Builder"),
		debug = ui.new_checkbox("AA", "Anti-aimbot angles", "[\aE1DEFD99Debug\aFFFFFFFF] lol"),
		conditiontab = ui.new_combobox("AA", "Anti-aimbot angles",  "[\aE1DEFD99Builder\aFFFFFFFF] Player state", "Global", "Standing", "Moving", "Air", "Crouch-air", "Crouch", "Slowwalk", "Fakelag"),
		indicators = ui.new_checkbox("AA", "Anti-aimbot angles", "[\aE1DEFD99WIP\aFFFFFFFF] Crosshair Indicators"),
		notifications = ui.new_checkbox("AA", "Anti-aimbot angles", "[\aE1DEFD99Visuals\aFFFFFFFF] Notifications"),
		main_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "[\aE1DEFD99Visuals\aFFFFFFFF] Notifications", 150, 200, 60, 255),
		ui_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "[\aE1DEFD99Keys\aFFFFFFFF] Manual forward"),
		ui_left = ui.new_hotkey("AA","Anti-aimbot angles", "[\aE1DEFD99Keys\aFFFFFFFF] Manual left"),
		ui_right = ui.new_hotkey("AA","Anti-aimbot angles", "[\aE1DEFD99Keys\aFFFFFFFF] Manual right"),
		fs_toggle = ui.new_hotkey("AA", "Anti-aimbot angles", "[\aE1DEFD99Keys\aFFFFFFFF] Freestanding"),
		lagcomp = ui.new_checkbox("AA", "Anti-aimbot angles", "[\aE1DEFD99Misc\aFFFFFFFF] Low FL on on-shot"),
		main_clr4 = ui.new_color_picker("AA", "Anti-aimbot angles", "[\aE1DEFD99Visuals\aFFFFFFFF] Manual AA Arrows", 145, 145, 255, 255),
		arrows = ui.new_checkbox("AA", "Anti-aimbot angles", "[\aE1DEFD99Visuals\aFFFFFFFF] Manual AA Arrows"),
		state_panel = ui.new_checkbox("AA", "Anti-aimbot angles", "[\aE1DEFD99Visuals\aFFFFFFFF] State panel"),
		state_panel_color = ui.new_color_picker("AA", "Anti-aimbot angles", "[\aE1DEFD99Visuals\aFFFFFFFF] State panel", 145, 145, 255, 255),
		breaker_switch = ui.new_hotkey("AA", "Anti-aimbot angles", "[\aE1DEFD99Exploit\aFFFFFFFF] Breaker"),
		breaker = ui.new_combobox("AA", "Anti-aimbot angles", "\aE1DEFD99", "Off", "Pitch", "Sideways", "Custom"),
		checkbox = ui.new_checkbox("AA", "Anti-aimbot angles", "[\aE1DEFD99Keys\aFFFFFFFF] Spam Defensive Exploit"),
		antibrute_switch = ui_new_checkbox("AA", "Anti-aimbot angles", "[\aE1DEFD99Anti-Bruteforce\aFFFFFFFF] Enable"),
		contains = ui.new_combobox("AA", "Anti-aimbot angles", "[\aE1DEFD99Anti-Bruteforce\aFFFFFFFF] Modes", "Default", "Random", "Phases"),
		bruteforce = {
			phases = ui.new_combobox("AA", "Anti-aimbot angles", "[\aE1DEFD99Anti-Bruteforce\aFFFFFFFF] Phase", "Phase 1", "Phase 2", "Phase 3", "Phase 4", "Phase 5"),
		},
		exploits = {
		yaw_1st = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99Breaker\aFFFFFFFF] Yaw on first tick", -180, 180, 0),
		yaw_2nd = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99Breaker\aFFFFFFFF] Yaw on second tick", -180, 180, 0),
			pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[\aE1DEFD99Breaker\aFFFFFFFF] Pitch", "Up", "Down", "Random"),
			bodyyaw = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99Breaker\aFFFFFFFF] Body yaw", -180, 180, 0),	
		},
		animfucker = ui.new_multiselect('AA', 'Anti-aimbot angles', '[\aE1DEFD99AnimFucker\aFFFFFFFF] Features', 'Static legs in air', 'Zero pitch on land', 'Backward legs', "Moonwalk"),
		knife_hotkey = ui.new_checkbox("AA", "Anti-aimbot angles", "[\aE1DEFD99Misc\aFFFFFFFF] Avoid backstab"),
    knife_distance = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99Misc\aFFFFFFFF] Avoid backstab radius",0,300,150,true,"u"),
	}

	local render = {}
	render.notifications = {}
	render.notifications.table_text = {}
	render.notifications.c_var = {
		screen = {client.screen_size()},

	}
	function render:lerp(start, vend, time)
		return start + (vend - start) * time
	end
	local solus_render = (function()
		local solus_m = {};
		local RoundedRect = function(x, y, w, h, radius, r, g, b, a)
			renderer.rectangle(x + radius, y, w - radius * 2, radius, r, g, b, a)
			renderer.rectangle(x, y + radius, radius, h - radius * 2, r, g, b, a)
			renderer.rectangle(x + radius, y + h - radius, w - radius * 2, radius,
							r, g, b, a)
			renderer.rectangle(x + w - radius, y + radius, radius, h - radius * 2,
							r, g, b, a)
			renderer.rectangle(x + radius, y + radius, w - radius * 2,
							h - radius * 2, r, g, b, a)
			renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
			renderer.circle(x + w - radius, y + radius, r, g, b, a, radius, 90, 0.25)
			renderer.circle(x + radius, y + h - radius, r, g, b, a, radius, 270,
							0.25)
			renderer.circle(x + w - radius, y + h - radius, r, g, b, a, radius, 0,
							0.25)
		end;
		local rounding = 4;
		local rad = rounding + 2;
		local n = 45;
		local o = 20;
		local OutlineGlow = function(x, y, w, h, radius, r, g, b, a)
			renderer.rectangle(x + 2, y + radius + rad, 1, h - rad * 2 - radius * 2,
							r, g, b, a)
			renderer.rectangle(x + w - 3, y + radius + rad, 1,
							h - rad * 2 - radius * 2, r, g, b, a)
			renderer.rectangle(x + radius + rad, y + 2, w - rad * 2 - radius * 2, 1,
							r, g, b, a)
			renderer.rectangle(x + radius + rad, y + h - 3,
							w - rad * 2 - radius * 2, 1, r, g, b, a)
			renderer.circle_outline(x + radius + rad, y + radius + rad, r, g, b, a,
									radius + rounding, 180, 0.25, 1)
			renderer.circle_outline(x + w - radius - rad, y + radius + rad, r, g, b,
									a, radius + rounding, 270, 0.25, 1)
			renderer.circle_outline(x + radius + rad, y + h - radius - rad, r, g, b,
									a, radius + rounding, 90, 0.25, 1)
			renderer.circle_outline(x + w - radius - rad, y + h - radius - rad, r,
									g, b, a, radius + rounding, 0, 0.25, 1)
		end;
		local FadedRoundedRect = function(x, y, w, h, radius, r, g, b, a, glow)
			local n = a / 255 * n;
			renderer.rectangle(x + radius, y, w - radius * 2, 1, r, g, b, a)
			renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180,
									0.25, 1)
			renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius,
									270, 0.25, 1)
			renderer.gradient(x, y + radius, 1, h - radius * 2, r, g, b, a, r, g, b,
							n, false)
			renderer.gradient(x + w - 1, y + radius, 1, h - radius * 2, r, g, b, a,
							r, g, b, n, false)
			renderer.circle_outline(x + radius, y + h - radius, r, g, b, n, radius,
									90, 0.25, 1)
			renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, n,
									radius, 0, 0.25, 1)
			renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, n)
				for radius = 4, glow do
					local radius = radius / 2;
					OutlineGlow(x - radius, y - radius, w + radius * 2,
								h + radius * 2, radius, r, g, b, glow - radius * 2)
				end
			
		end;
		local HorizontalFadedRoundedRect = function(x, y, w, h, radius, r, g, b, a,
													glow, r1, g1, b1)
			local n = a / 255 * n;
			renderer.rectangle(x, y + radius, 1, h - radius * 2, r, g, b, a)
			renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180,
									0.25, 1)
			renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius,
									90, 0.25, 1)
			renderer.gradient(x + radius, y, w / 3.5 - radius * 2, 1, r, g, b, a, 0,
							0, 0, n / 0, true)
			renderer.gradient(x + radius, y + h - 1, w / 3.5 - radius * 2, 1, r, g,
							b, a, 0, 0, 0, n / 0, true)
			renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r1, g1, b1,
							n)
			renderer.rectangle(x + radius, y, w - radius * 2, 1, r1, g1, b1, n)
			renderer.circle_outline(x + w - radius, y + radius, r1, g1, b1, n,
									radius, -90, 0.25, 1)
			renderer.circle_outline(x + w - radius, y + h - radius, r1, g1, b1, n,
									radius, 0, 0.25, 1)
			renderer.rectangle(x + w - 1, y + radius, 1, h - radius * 2, r1, g1, b1,
							n)
				for radius = 4, glow do
					local radius = radius / 2;
					OutlineGlow(x - radius, y - radius, w + radius * 2,
								h + radius * 2, radius, r1, g1, b1,
								glow - radius * 2)
				end
			
		end;
		local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1,
										g1, b1)
			local n = a / 255 * n;
			renderer.rectangle(x + radius, y, w - radius * 2, 1, r, g, b, n)
			renderer.circle_outline(x + radius, y + radius, r, g, b, n, radius, 180,
									0.25, 1)
			renderer.circle_outline(x + w - radius, y + radius, r, g, b, n, radius,
									270, 0.25, 1)
			renderer.rectangle(x, y + radius, 1, h - radius * 2, r, g, b, n)
			renderer.rectangle(x + w - 1, y + radius, 1, h - radius * 2, r, g, b, n)
			renderer.circle_outline(x + radius, y + h - radius, r, g, b, n, radius,
									90, 0.25, 1)
			renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, n,
									radius, 0, 0.25, 1)
			renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, n)
			if ui_get(glow_enabled) then
				for radius = 4, glow do
					local radius = radius / 2;
					OutlineGlow(x - radius, y - radius, w + radius * 2,
								h + radius * 2, radius, r1, g1, b1,
								glow - radius * 2)
				end
			end
		end;
		solus_m.linear_interpolation = function(start, _end, time)
			return (_end - start) * time + start
		end
		solus_m.clamp = function(value, minimum, maximum)
			if minimum > maximum then
				return math.min(math.max(value, maximum), minimum)
			else
				return math.min(math.max(value, minimum), maximum)
			end
		end
		solus_m.lerp = function(start, _end, time)
			time = time or 0.005;
			time = solus_m.clamp(globals.frametime() * time * 175.0, 0.01, 1.0)
			local a = solus_m.linear_interpolation(start, _end, time)
			if _end == 0.0 and a < 0.01 and a > -0.01 then
				a = 0.0
			elseif _end == 1.0 and a < 1.01 and a > 0.99 then
				a = 1.0
			end
			return a
		end
		solus_m.outlined_glow = function(x, y, w, h, radius, r, g, b, a,glow)

			for radius = 4, glow do
				local radius = radius / 2;
				OutlineGlow(x - radius, y - radius, w + radius * 2,
							h + radius * 2, radius, r, g, b,
							glow - radius * 2)
			end
		end

		solus_m.container = function(x, y, w, h, r, g, b, a, alpha, fn)
			if a > 0 then
				renderer.blur(x, y, w, h)
			end

			RoundedRect(x, y, w, h, rounding, 17, 17, 17, a)
			FadedRoundedRect(x, y, w, h, rounding, r, g, b, alpha * 255, alpha * o)
			if not fn then return end
			fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
		end;
		solus_m.horizontal_container = function(x, y, w, h, r, g, b, a, alpha, r1,
												g1, b1, fn)
			if alpha * 255 > 0 then renderer.blur(x, y, w, h) end
			RoundedRect(x, y, w, h, rounding, 17, 17, 17, a)
			HorizontalFadedRoundedRect(x, y, w, h, rounding, r, g, b, alpha * 255,
									alpha * o, r1, g1, b1)
			if not fn then return end
			fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
		end;
		solus_m.container_glow = function(x, y, w, h, r, g, b, a, alpha, r1, g1, b1,
										fn)
			if alpha * 255 > 0 then renderer.blur(x, y, w, h) end
			RoundedRect(x, y, w, h, rounding, 17, 17, 17, a)
			FadedRoundedGlow(x, y, w, h, rounding, r, g, b, alpha * 255, alpha * o,
							r1, g1, b1)
			if not fn then return end
			fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
		end;
		solus_m.measure_multitext = function(flags, _table)
			local a = 0;
			for b, c in pairs(_table) do
				c.flags = c.flags or ''
				a = a + renderer.measure_text(c.flags, c.text)
			end
			return a
		end
		solus_m.multitext = function(x, y, _table)
			for a, b in pairs(_table) do
				b.flags = b.flags or ''
				b.limit = b.limit or 0;
				b.color = b.color or {255, 255, 255, 255}
				b.color[4] = b.color[4] or 255;
				renderer.text(x, y, b.color[1], b.color[2], b.color[3], b.color[4],
							b.flags, b.limit, b.text)
				x = x + renderer.measure_text(b.flags, b.text)
			end
		end
		return solus_m
	end)()


	local function noti()
		local y = render.notifications.c_var.screen[2] - 100

		
		for i, info in ipairs(render.notifications.table_text) do
			if i > 5 then
				table.remove(render.notifications.table_text,i)
			end
			if info.text ~= nil and info ~= "" then
				local text_size = {renderer.measure_text(nil,info.text)}
				local r,g,b,a = ui.get(menu.main_clr)
				if info.timer + 3.8 < globals.realtime() then
		
					info.box_left = render:lerp(info.box_left,text_size[1],globals.frametime() * 1)
					info.box_right = render:lerp(info.box_right,text_size[1],globals.frametime() * 1)
					info.box_left_1 = render:lerp(info.box_left_1,0,globals.frametime() * 1)
					info.box_right_1 = render:lerp(info.box_right_1,0 ,globals.frametime() * 1)
					info.smooth_y = render:lerp(info.smooth_y,render.notifications.c_var.screen[2] + 100,globals.frametime() * 2)
					info.alpha = render:lerp(info.alpha,0,globals.frametime() * 4)
					info.alpha2 = render:lerp(info.alpha2,0,globals.frametime() * 4)
					info.alpha3 = render:lerp(info.alpha3,0,globals.frametime() * 4)


				else
					info.alpha = render:lerp(info.alpha,a,globals.frametime() * 4)
					info.alpha2 = render:lerp(info.alpha2,1,globals.frametime() * 4)
					info.alpha3 = render:lerp(info.alpha3,255,globals.frametime() * 4)

					info.smooth_y = render:lerp(info.smooth_y,y,globals.frametime() * 2)
				
					info.box_left = render:lerp(info.box_left,text_size[1] - text_size[1] /2 -2,globals.frametime() * 1)
					info.box_right = render:lerp(info.box_right,text_size[1]  - text_size[1] /2 +4,globals.frametime() * 1)
					info.box_left_1 = render:lerp(info.box_left_1,text_size[1] +13,globals.frametime() * 2)
					info.box_right_1 = render:lerp(info.box_right_1,text_size[1] +14 ,globals.frametime() * 2)
				end

				local add_y = math.floor(info.smooth_y)
				local alpha = info.alpha
				local alpha2 = info.alpha2
				local alpha3 = info.alpha3

				local left_box = math.floor(info.box_left)
				local right_box = math.floor(info.box_right)
				local left_box_1 = math.floor(info.box_left_1)
				local right_box_1 = math.floor(info.box_right_1)

				solus_render.container(render.notifications.c_var.screen[1] / 2 - text_size[1] / 2 - 4 + 5,add_y - 21,text_size[1] +8 + 4 - 7 + 4 + 14 ,text_size[2] + 7 ,r,g,b,alpha,alpha2 )


				local svg = {
					32,
					32,
					'<svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="48" height="48" viewBox="0 0 48 48"> <path fill="#A1C2BA" d="M24,44c-6.9,0-7.1-6.5-8.6-8.3C13.6,34,5,30.7,5,22.3C5,13.9,8.5,4,24,4s19,10,19,18.3S34.4,34,32.6,35.7C31.1,37.5,30.9,44,24,44z"></path><path fill="#5D736D" d="M25,34.2c0,0.8,0.5,0.8,1,0.8s1,0,1-0.8c0-1.2-2-3.6-2-3.1C25,31.6,25,33,25,34.2z"></path><path fill="#003B3D" d="M26.3,28.7c0.3,0.3,6,1.1,9.2-2.1c3.2-3.2,2.5-8.8,2.1-9.2c-0.4-0.4-6-1.1-9.2,2.1S26,28.4,26.3,28.7z"></path><path fill="#5D736D" d="M23,31.1c0-0.5-2,1.9-2,3.1c0,0.8,0.5,0.8,1,0.8s1,0,1-0.8C23,33,23,31.6,23,31.1z"></path><path fill="#003B3D" d="M19.6,19.5c-3.2-3.2-8.8-2.5-9.2-2.1c-0.4,0.4-1.1,6,2.1,9.2s8.9,2.4,9.2,2.1C22,28.4,22.8,22.7,19.6,19.5z"></path><path fill="#006064" d="M33.7 19.4c-.2 0-2.3.5-3.6 1.7-1.2 1.2-1.8 3.3-1.8 3.6-.1.5.2 1.1.7 1.2.1 0 .2 0 .2 0 .5 0 .9-.3 1-.8.1-.5.6-1.9 1.3-2.6.7-.7 2.1-1.1 2.6-1.2.5-.1.9-.6.8-1.2C34.8 19.6 34.2 19.3 33.7 19.4zM17.9 21.1c-1.2-1.2-3.4-1.7-3.6-1.7-.5-.1-1.1.2-1.2.8-.1.5.2 1.1.8 1.2.5.1 1.9.5 2.6 1.2.7.7 1.2 2.1 1.3 2.6.1.5.5.8 1 .8.1 0 .2 0 .2 0 .5-.1.9-.7.7-1.2C19.7 24.4 19.1 22.3 17.9 21.1z"></path></svg>',
				}
				local svg = renderer.load_svg(svg[3], 12 , 12 )

				renderer.texture(svg,render.notifications.c_var.screen[1] / 2 - text_size[1] / 2  + 5,add_y - 19 + 1,12 ,12 ,r,g,b,alpha3)

				renderer.text(
					render.notifications.c_var.screen[1] / 2 - text_size[1] / 2  + 5 + 14,add_y - 19 + 1,
					255, 255, 255, 255,nil,0,info.text
				)
		
				y = y - 30
				if info.timer + 4 < globals.realtime() then
					table.remove(render.notifications.table_text,i)
				end
			end
		end
		
	end

	local brute = {
		yaw_status = "default",
		fs_side = 0,
		last_miss = 0,
		best_angle = 0,
		misses = { },
		hp = 0,
		misses_ind = { },
		can_hit_head = 0,
		can_hit = 0,
		hit_reverse = { },
		phase = 0,
		jitter = 0,
	}

	local best_enemy = nil


	local ingore = false
	local laa = 0
	local raa = 0
	local mantimer = 0
	local function normalize_yaw(yaw)
		while yaw > 180 do yaw = yaw - 360 end
			while yaw < -180 do yaw = yaw + 360 end
				return yaw
			end

			local function calc_angle(local_x, local_y, enemy_x, enemy_y)
				local ydelta = local_y - enemy_y
				local xdelta = local_x - enemy_x
				local relativeyaw = math.atan( ydelta / xdelta )
				relativeyaw = normalize_yaw( relativeyaw * 180 / math.pi )
				if xdelta >= 0 then
					relativeyaw = normalize_yaw(relativeyaw + 180)
				end
				return relativeyaw
			end

			local function ang_on_screen(x, y)
				if x == 0 and y == 0 then return 0 end

				return math.deg(math.atan2(y, x))
			end

			local function angle_vector(angle_x, angle_y)
				local sy = math.sin(math.rad(angle_y))
				local cy = math.cos(math.rad(angle_y))
				local sp = math.sin(math.rad(angle_x))
				local cp = math.cos(math.rad(angle_x))
				return cp * cy, cp * sy, -sp
			end

			local function get_damage(me, enemy, x, y,z)
				local ex = { }
				local ey = { }
				local ez = { }
				ex[0], ey[0], ez[0] = entity.hitbox_position(enemy, 1)
				ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
				ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
				ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
				ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
				ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
				ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
				local bestdamage = 0
				local bent = nil
				for i=0, 6 do
					local ent, damage = client.trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
					if damage > bestdamage then
						bent = ent
						bestdamage = damage
					end
				end
				return bent == nil and client.scale_damage(me, 1, bestdamage) or bestdamage
			end

			local function get_best_enemy()
				best_enemy = nil

				local enemies = entity.get_players(true)
				local best_fov = 180

				local lx, ly, lz = client.eye_position()
				local view_x, view_y, roll = client.camera_angles()

				for i=1, #enemies do
					local cur_x, cur_y, cur_z = entity.get_prop(enemies[i], "m_vecOrigin")
					local cur_fov = math.abs(normalize_yaw(ang_on_screen(lx - cur_x, ly - cur_y) - view_y + 180))
					if cur_fov < best_fov then
						best_fov = cur_fov
						best_enemy = enemies[i]
					end
				end
			end

			local function extrapolate_position(xpos,ypos,zpos,ticks,player)
				local x,y,z = entity.get_prop(player, "m_vecVelocity")
				for i=0, ticks do
					xpos =  xpos + (x*globals.tickinterval())
					ypos =  ypos + (y*globals.tickinterval())
					zpos =  zpos + (z*globals.tickinterval())
				end
				return xpos,ypos,zpos
			end

			local function get_velocity(player)
				local x,y,z = entity.get_prop(player, "m_vecVelocity")
				if x == nil then return end
				return math.sqrt(x*x + y*y + z*z)
			end

			local function get_body_yaw(player)
				local _, model_yaw = entity.get_prop(player, "m_angAbsRotation")
				local _, eye_yaw = entity.get_prop(player, "m_angEyeAngles")
				if model_yaw == nil or eye_yaw ==nil then return 0 end
				return normalize_yaw(model_yaw - eye_yaw)
			end

			local function get_best_angle()
				local me = entity.get_local_player()

				if best_enemy == nil then return end

				local origin_x, origin_y, origin_z = entity.get_prop(best_enemy, "m_vecOrigin")
				if origin_z == nil then return end
				origin_z = origin_z + 64

				local extrapolated_x, extrapolated_y, extrapolated_z = extrapolate_position(origin_x, origin_y, origin_z, 20, best_enemy)

				local lx,ly,lz = client.eye_position()
				local hx,hy,hz = entity.hitbox_position(entity.get_local_player(), 0)
				local _, head_dmg = client.trace_bullet(best_enemy, origin_x, origin_y, origin_z, hx, hy, hz, true)

				if head_dmg ~= nil and head_dmg > 1 then
					brute.can_hit_head = 1
				else
					brute.can_hit_head = 0
				end

				local view_x, view_y, roll = client.camera_angles()

				local e_x, e_y, e_z = entity.hitbox_position(best_enemy, 0)

				local yaw = calc_angle(lx, ly, e_x, e_y)
				local rdir_x, rdir_y, rdir_z = angle_vector(0, (yaw + 90))
				local rend_x = lx + rdir_x * 10
				local rend_y = ly + rdir_y * 10

				local ldir_x, ldir_y, ldir_z = angle_vector(0, (yaw - 90))
				local lend_x = lx + ldir_x * 10
				local lend_y = ly + ldir_y * 10

				local r2dir_x, r2dir_y, r2dir_z = angle_vector(0, (yaw + 90))
				local r2end_x = lx + r2dir_x * 100
				local r2end_y = ly + r2dir_y * 100

				local l2dir_x, l2dir_y, l2dir_z = angle_vector(0, (yaw - 90))
				local l2end_x = lx + l2dir_x * 100
				local l2end_y = ly + l2dir_y * 100

				local ldamage = get_damage(me, best_enemy, rend_x, rend_y, lz)
				local rdamage = get_damage(me, best_enemy, lend_x, lend_y, lz)

				local l2damage = get_damage(me, best_enemy, r2end_x, r2end_y, lz)
				local r2damage = get_damage(me, best_enemy, l2end_x, l2end_y, lz)

				if l2damage > r2damage or ldamage > rdamage or l2damage > ldamage then
					if ui.get(ref.freestanding[2]) then
						brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 1 or 2)
					else
						brute.best_angle = 1
					end
				elseif r2damage > l2damage or rdamage > ldamage or r2damage > rdamage then
					if ui.get(ref.freestanding[2]) then
						brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 2 or 1)
					else
						brute.best_angle = 2
					end
				end
			end


			local function brute_impact(e)
				if not ui.get(menu.antibrute_switch) then return end
				local me = entity.get_local_player()

				if not entity.is_alive(me) then return end

				local shooter_id = e.userid
				local shooter = client.userid_to_entindex(shooter_id)

				if not entity.is_enemy(shooter) or entity.is_dormant(shooter) then return end

				local lx, ly, lz = entity.hitbox_position(me, "head_0")

				local ox, oy, oz = entity.get_prop(me, "m_vecOrigin")
				local ex, ey, ez = entity.get_prop(shooter, "m_vecOrigin")
				local target = entity.get_player_name(client.current_threat())

				local dist = ((e.y - ey)*lx - (e.x - ex)*ly + e.x*ey - e.y*ex) / math.sqrt((e.y-ey)^2 + (e.x - ex)^2)

				if math.abs(dist) <= 80 and globals.curtime() - brute.last_miss > 0.015 then
					
					if ui.get(menu.contains) == "Default" then
						table.insert(render.notifications.table_text, {
							text = "Switched side due to shot [target: "..target.."]",
							timer = globals.realtime(),
						
							smooth_y = render.notifications.c_var.screen[2] + 100,
							alpha = 0,
							alpha2 = 0,
							alpha3 = 0,
						
						
							box_left = 0,
							box_right = 0,
						
							box_left_1 = 0,
							box_right_1 = 0
						}) 
						
					elseif ui.get(menu.contains) == "Random" then
						brute.jitter = math.random(60, 75)
						ui.set(ref.jitter[2], brute.jitter)
						table.insert(render.notifications.table_text, {
							text = "Generated random jitter [target: "..target.." | jitter: "..brute.jitter.."]",
							timer = globals.realtime(),
						
							smooth_y = render.notifications.c_var.screen[2] + 100,
							alpha = 0,
							alpha2 = 0,
							alpha3 = 0,
						
						
							box_left = 0,
							box_right = 0,
						
							box_left_1 = 0,
							box_right_1 = 0
						}) 

					else
						brute.phase = brute.phase + 1
						table.insert(render.notifications.table_text, {
							text = "Switched side due to shot [target: "..target.." | phase "..brute.phase.."]",
							timer = globals.realtime(),
						
							smooth_y = render.notifications.c_var.screen[2] + 100,
							alpha = 0,
							alpha2 = 0,
							alpha3 = 0,
						
						
							box_left = 0,
							box_right = 0,
						
							box_left_1 = 0,
							box_right_1 = 0
						}) 
					end
					brute.last_miss = globals.curtime()
					if brute.misses[shooter] == nil then
						brute.misses[shooter] = 1
						brute.misses_ind[shooter] = 1
					elseif brute.misses[shooter] >= 2 then
						brute.misses[shooter] = nil
					else
						brute.misses_ind[shooter] = brute.misses_ind[shooter] + 1
						brute.misses[shooter] = brute.misses[shooter] + 1
					end
				end
			end

			brute.reset = function()
			brute.fs_side = 0
			brute.last_miss = 0
			brute.best_angle = 0
			brute.misses_ind = { }
			brute.misses = { }
			brute.phase = 0
			if ui.get(menu.antibrute_switch) then
				table.insert(render.notifications.table_text, {
					text = "Anti-bruteforce data has been reset",
					timer = globals.realtime(),
				
					smooth_y = render.notifications.c_var.screen[2] + 100,
					alpha = 0,
					alpha2 = 0,
					alpha3 = 0,
				
				
					box_left = 0,
					box_right = 0,
				
					box_left_1 = 0,
					box_right_1 = 0
				}) 

			end
		end

		local function brute_death(e)

			local victim_id = e.userid
			local victim = client.userid_to_entindex(victim_id)

			if victim ~= entity.get_local_player() then return end

			local attacker_id = e.attacker
			local attacker = client.userid_to_entindex(attacker_id)

			if not entity.is_enemy(attacker) then return end

			if not e.headshot then return end

			if brute.misses[attacker] == nil or (globals.curtime() - brute.last_miss < 0.06 and brute.misses[attacker] == 1) then
				if brute.hit_reverse[attacker] == nil then
					brute.hit_reverse[attacker] = true
				else
					brute.hit_reverse[attacker] = nil
				end
			end
		end


		local import_antibrute = function(to_import)
		pcall(function()
		local num_tbl = {}
		local settings = json.parse(requirements.base64.decode(clipboard_import(), base64))

		for key, value in pairs(settings) do
			if type(value) == 'table' then
				for k, v in pairs(value) do
					if type(k) == 'number' then
						table.insert(num_tbl, v)
						ui.set(antibrute[key], num_tbl)
					else
						ui.set(antibrute[key][k], v)
					end
				end
			else
				ui.set(antibrute[key], value)
			end
		end



		table.insert(render.notifications.table_text, {
			text = "Imported anti-bruteforce phases",
			timer = globals.realtime(),
		
			smooth_y = render.notifications.c_var.screen[2] + 100,
			alpha = 0,
			alpha2 = 0,
			alpha3 = 0,
		
		
			box_left = 0,
			box_right = 0,
		
			box_left_1 = 0,
			box_right_1 = 0
		}) 

		end)
	end

	local export_antibrute = function()
	local settings = {}

	pcall(function()
	for key, value in pairs(antibrute) do
		if value then
			settings[key] = {}

			if type(value) == 'table' then
				for k, v in pairs(value) do
					settings[key][k] = ui.get(v)
				end
			else
				settings[key] = ui.get(value)
			end
		end
	end


	clipboard_export(requirements.base64.encode(json.stringify(settings), base64))
	table.insert(render.notifications.table_text, {
		text = "Exported anti-bruteforce phases to clipboard",
		timer = globals.realtime(),

		smooth_y = render.notifications.c_var.screen[2] + 100,
		alpha = 0,
		alpha2 = 0,
		alpha3 = 0,


		box_left = 0,
		box_right = 0,

		box_left_1 = 0,
		box_right_1 = 0
	}) 

	end)
	end
	import_antibrute = ui.new_button("AA", "Anti-aimbot angles", "Import phases", import_antibrute)
	export_antibrute = ui.new_button("AA", "Anti-aimbot angles", "Export phases", export_antibrute)
	local var = {
	p_state = 1,
	}

	local function player_state() -- Got from a leaked script :shrug:
	local vx, vy = entity.get_prop(entity.get_local_player(), 'm_vecVelocity')
	local player_standing = math.sqrt(vx ^ 2 + vy ^ 2) < 2
	local player_jumping = bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) == 0
	local player_duck_peek_assist = ui.get(ref.fake_duck)
	local player_crouching = entity.get_prop(entity.get_local_player(), "m_flDuckAmount") > 0.5 and not player_duck_peek_assist
	local player_slow_motion = ui.get(ref.slowwalk[1]) and ui.get(ref.slowwalk[2])
	local is_exploiting = ui.get(ref.dt[2]) or ui.get(ref.os[2])
	local antibrute_active = brute.last_miss + 3 > globals.curtime() and ui.get(menu.antibrute_switch)


	if antibrute_active then
		return 'antibrute'
	elseif player_duck_peek_assist and not antibrute_active then
		return 'fakeduck'
	elseif player_slow_motion and is_exploiting and not antibrute_active  then
		var.p_state = 6
		return 'slowmotion'
	elseif player_crouching and is_exploiting and not player_jumping and not antibrute_active  then
		var.p_state = 5
		return 'crouch'
	elseif player_jumping and not player_crouching and is_exploiting  and not antibrute_active then
		var.p_state = 3
		return 'jump'
	elseif player_jumping and player_crouching and is_exploiting and not antibrute_active  then
		var.p_state = 4
		return "duckjump"
	elseif player_standing and is_exploiting and not antibrute_active  then
		var.p_state = 1
		return 'stand'
	elseif not player_standing and is_exploiting and not antibrute_active  then
		var.p_state = 2
		return 'move'
	elseif not is_exploiting  and not antibrute_active then
		var.p_state = 7
		return "fakelag"
	end
	end

	local numtotext = {
	[1] = "Standing",
	[2] = "Moving",
	[3] = "Air",
	[4] = "Crouch-air",
	[5] = "Crouch",
	[6] = "Slowwalk",
	[7] = "Fakelag",
	[8] = "Global",
	}
	local brutenumtotext = {
		[1] = "Phase 1",
		[2] = "Phase 2",
		[3] = "Phase 3",
		[4] = "Phase 4",
		[5] = "Phase 5",
	}
	anti_aim = {}

	for i = 1, 8 do
	anti_aim[i] = {
		override = ui.new_checkbox("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] Override state"),
		yaw_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] yaw mode", "Default", "L/R", "Superior", "3 Way", "5 Way", "Yaw Manipulation"),
		yaw_manipulation_add_left = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] manipulation add left", -90, 90, 0),
		yaw_manipulation_add_right = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] manipulation add right", -90, 90, 0),
		yaw_default = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] yaw add", -90, 90, 0),
		yaw_superior = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] superior yaw add", -90, 90, 0),
		yaw_left = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] yaw add left", -90, 90, 0),
		yaw_right = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] yaw add right", -90, 90, 0),
		fiveway_yaw_add = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] 3-way yaw add", -90, 90, 0),
		threeway_yaw_add = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] 5-way yaw add", -90, 90, 0),
		body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] body yaw", "Off", "Opposite", "Jitter", "Static"),
		body_yaw_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] body yaw mode", "normal", "l/r"),
		body_yaw_val = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] body yaw value", -180, 180, 0),
		left_byaw_val = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] left body yaw value", -90, 90, 0),
		right_byaw_val = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] right body yaw value", -90, 90, 0),
		jitter = ui.new_combobox("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] jitter", "Off", "Offset", "Center", "Random", "Random Center", "lol", "5 Way", "Skitter"),
		jitter_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] jitter mode", "normal", "l/r"),
		left_jitter_val = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] left jitter value", -90, 90, 0),
		right_jitter_val = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] right jitter value", -90, 90, 0),
		jitter_val = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] jitter value", -90, 90, 0),
		lolway_yaw_add = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] meta jitter value", -90, 90, 0),
		threeway_jitter_val = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..numtotext[i].."\aFFFFFFFF] 5-way jitter value", -90, 90, 0),
	}
	end

	antibrute = {}
	for i = 1, 5 do
	antibrute[i] = {
		yaw_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] yaw mode", "Default", "L/R", "Superior", "3 Way", "5 Way"),
		yaw_default = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] yaw add", -90, 90, 0),
		yaw_superior = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] superior yaw add", -90, 90, 0),
		yaw_left = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] yaw add left", -90, 90, 0),
		yaw_right = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] yaw add right", -90, 90, 0),
		fiveway_yaw_add = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] 3-way yaw add", -90, 90, 0),
		threeway_yaw_add = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] 5-way yaw add", -90, 90, 0),
		body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] body yaw", "Off", "Opposite", "Jitter", "Static"),
		body_yaw_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] body yaw mode", "normal", "l/r"),
		body_yaw_val = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] body yaw value", -180, 180, 0),
		left_byaw_val = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] left body yaw value", -90, 90, 0),
		right_byaw_val = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] right body yaw value", -90, 90, 0),
		jitter = ui.new_combobox("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] jitter", "Off", "Offset", "Center", "Random", "Random Center", "lol", "5 Way", "Skitter"),
		jitter_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] jitter mode", "normal", "l/r"),
		left_jitter_val = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] left jitter value", -90, 90, 0),
		right_jitter_val = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] right jitter value", -90, 90, 0),
		jitter_val = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] jitter value", -90, 90, 0),
		lolway_yaw_add = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] meta jitter value", -90, 90, 0),
		threeway_jitter_val = ui.new_slider("AA", "Anti-aimbot angles", "[\aE1DEFD99"..brutenumtotext[i].."\aFFFFFFFF] 5-way jitter value", -90, 90, 0),
	}
	end



	






	local function gradient_text_anim(rr, gg, bb, aa, rrr, ggg, bbb, aaa, text, speed)
	local r1, g1, b1, a1 = rr, gg, bb, aa
	local r2, g2, b2, a2 = rrr, ggg, bbb, aaa
	local highlight_fraction =  (globals.realtime() / 2 % 1.2 * speed) - 1.2
	local output = ""
	for idx = 1, #text do
		local character = text:sub(idx, idx)
		local character_fraction = idx / #text

		local r, g, b, a = r1, g1, b1, a1
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
		output = output .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, 255, text:sub(idx, idx))
	end
	return output
	end








					local current_phase = 1
					local current_phase_jit = 1
					local current_phase_yaw = 1
					local Mode = "Off"
					local last_sim_time = 0
					local defensive_until = 0
					local leftReady = false
					local rightReady = false
					local forwardReady = false

					local function is_defensive_active()
						local tickcount = globals.tickcount()
						local local_player = entity.get_local_player()
						local sim_time = toticks(entity.get_prop(local_player, "m_flSimulationTime"))
						local sim_diff = sim_time - last_sim_time

						if sim_diff < 0 then
							defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
						end

						last_sim_time = sim_time

						return defensive_until > tickcount
					end



					local last_press_t_dir = 0
					local yaw_direction = 0
					local antibrute_active = false
					local breaker_active = false
					local aa_tbl = {
						jitter = 0,
						fakeyaw = 0,
						yaw = 0,
						bodyyaw = 0,
					}
					misc = {}

						misc.knife_isactive = false
						
						misc.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
							return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
						end
						
						misc.anti_knife = function()
							if ui.get(menu.knife_hotkey) then
								local players = entity.get_players(true)
								local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
						
								for i=1, #players do
									local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
									local distance = misc.anti_knife_dist(lx, ly, lz, x, y, z)
									local weapon = entity.get_player_weapon(players[i])
									if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(menu.knife_distance) then
										misc.knife_isactive = true
										ui.set(ref.yaw[2],180)
										ui.set(ref.pitch[1],"Off")
									else
										misc.knife_isactive = false
										--ui.set(ref.pitch[1],"Minimal")
									end
								end
							end
						end   
						
					

						local function apply_tickbase(cmd, ticks_to_shift)
							local usrcmd = get_input.vfptr.GetUserCmd(ffi.cast("uintptr_t", get_input), 0, cmd.command_number)
						
							if cmd.chokedcommands == 0 then return end
						
							cmd.no_choke = true
							cmd.allow_send_packet = true
							usrcmd.send_packet = true
						--	usrcmd.tick_count = globals.tickcount() + ticks_to_shift
							return
						end
					client.set_event_callback("setup_command", function(c)
						misc.anti_knife()
					local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
					local side = bodyyaw > 0 and 1 or -1
					if brute.phase > 5 then
						brute.phase = 0
					end
			
					if brute.last_miss + 3 > globals.curtime() and brute.phase > 0 and misc.knife_isactive == false then
						if ui.get(menu.contains) == "Phases" then
							ui.set(ref.yaw[1], 180)
if c.chokedcommands ~= 0 then
else
if ui.get(antibrute[brute.phase].yaw_mode) == "Default" then
    ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(antibrute[brute.phase].yaw_default) or yaw_direction)
elseif ui.get(antibrute[brute.phase].yaw_mode) == "L/R" then
    ui.set(ref.yaw[2], (yaw_direction == 0 and (side == 1 and ui.get(antibrute[brute.phase].yaw_left) or ui.get(antibrute[brute.phase].yaw_right)) or yaw_direction))
elseif ui.get(antibrute[brute.phase].yaw_mode) == "Superior" then
    ui.set(ref.yaw[2], yaw_direction == 0 and client.random_int(ui.get(antibrute[brute.phase].yaw_superior), ui.get(antibrute[brute.phase].yaw_superior)+client.random_int(-10, 10) or yaw_direction))
elseif ui.get(antibrute[brute.phase].yaw_mode) == "3 Way" then
    local yaw_list = { -ui.get(antibrute[brute.phase].fiveway_yaw_add), 0, ui.get(antibrute[brute.phase].fiveway_yaw_add)}
    if globals.tickcount() % 1 < 1 then
        current_phase = current_phase + 1
    end
    if current_phase > 3 then
        current_phase = 1
    end
    ui.set(ref.yaw[2], yaw_direction == 0 and yaw_list[current_phase] or yaw_direction)
else
    local yaw_list = { -ui.get(antibrute[brute.phase].threeway_yaw_add), -ui.get(antibrute[brute.phase].threeway_yaw_add)/2, 0, ui.get(antibrute[brute.phase].threeway_yaw_add)/2, ui.get(antibrute[brute.phase].threeway_yaw_add)}
    if globals.tickcount() % 1 < 1 then
        current_phase = current_phase + 1
    end
    if current_phase > 5 then
        current_phase = 1
    end
    ui.set(ref.yaw[2], yaw_direction == 0 and yaw_list[current_phase] or yaw_direction)
end
end 
ui.set(ref.byaw[1], ui.get(antibrute[brute.phase].body_yaw))

    if ui.get(antibrute[brute.phase].body_yaw_mode) == "normal" then
        ui.set(ref.byaw[1], ui.get(antibrute[brute.phase].body_yaw))
        ui.set(ref.byaw[2], ui.get(antibrute[brute.phase].body_yaw_val))
    else
        ui.set(ref.byaw[1], ui.get(antibrute[brute.phase].body_yaw))
        ui.set(ref.byaw[2], (side == 1 and ui.get(antibrute[brute.phase].left_byaw_val) or ui.get(antibrute[brute.phase].right_byaw_val)))
    end

if ui.get(antibrute[brute.phase].jitter_mode) == "normal" then
    if ui.get(antibrute[brute.phase].jitter) == "Random Center" then
        ui.set(ref.jitter[1], "Center")
        ui.set(ref.jitter[2], client.random_int(ui.get(antibrute[brute.phase].jitter_val), ui.get(antibrute[brute.phase].jitter_val)+client.random_int(-12, 18)))
   
    elseif ui.get(antibrute[brute.phase].jitter) == "5 Way" then
        local jitter_list = { -ui.get(antibrute[brute.phase].threeway_jitter_val), -ui.get(antibrute[brute.phase].threeway_jitter_val)/2, 0, ui.get(antibrute[brute.phase].threeway_jitter_val)/2, ui.get(antibrute[brute.phase].threeway_jitter_val)}
        if globals.tickcount() % 1 < 1 then
            current_phase_jit = current_phase_jit + 1
        end
        if current_phase_jit > 5 then
            current_phase_jit = 1
        end
        ui.set(ref.jitter[2], jitter_list[current_phase_jit])
    else
        ui.set(ref.jitter[2], ui.get(antibrute[brute.phase].jitter_val))
        ui.set(ref.jitter[1], ui.get(antibrute[brute.phase].jitter))
    end
else
    if ui.get(antibrute[brute.phase].jitter) == "Random Center" then
		ui.set(ref.jitter[1], "Center")
		ui.set(ref.jitter[2], client.random_int(ui.get(antibrute[brute.phase].jitter_val), ui.get(antibrute[brute.phase].jitter_val)+client.random_int(-12, 18)))
	
	elseif ui.get(antibrute[brute.phase].jitter) == "lol" then
		local current_val = side == 1 and ui.get(antibrute[brute.phase].left_jitter_val) or ui.get(antibrute[brute.phase].right_jitter_val)
		local jitter_list = { -current_val/2, current_val, current_val/2, -current_val}
		
		if globals.tickcount() % 1 < 1 then
			current_phase_jit = current_phase_jit + 1
		end
		if current_phase_jit == 4 then
			current_phase_jit = 1
		end
		ui.set(ref.jitter[2], jitter_list[current_phase_jit])
	elseif ui.get(antibrute[brute.phase].jitter) == "5 Way" then
		local current_val = side == 1 and ui.get(antibrute[brute.phase].left_jitter_val) or ui.get(antibrute[brute.phase].right_jitter_val)
		local jitter_list = { -current_val, -current_val/2, 0, current_val/2, current_val}
		if globals.tickcount() % 1 < 1 then
			current_phase_jit = current_phase_jit + 1
		end
		if current_phase_jit > 5 then
			current_phase_jit = 1
		end
		ui.set(ref.jitter[2], jitter_list[current_phase_jit])
	else
		ui.set(ref.jitter[1], ui.get(antibrute[brute.phase].jitter))
		ui.set(ref.jitter[2], side == 1 and ui.get(antibrute[brute.phase].left_jitter_val) or ui.get(antibrute[brute.phase].right_jitter_val))
	end
end


						end
					end
					if brute.last_miss + 3 > globals.curtime() and contains(menu.contains, "Override body yaw") or contains(menu.contains, "Jitter") then
						antibrute_active = true
					else
						antibrute_active = false
					end
					player_state()
					if ui.get(menu.presets) == "Builder" then
						for i = 1, 7 do
							if var.p_state == i and breaker_active == false and brute.last_miss + 3 < globals.curtime() and misc.knife_isactive == false then
								if not ui.get(anti_aim[i].override) then
									ui.set(ref.yaw[1], 180)
									if c.chokedcommands ~= 0 then
									else
									if ui.get(anti_aim[8].yaw_mode) == "Default" then
										ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(anti_aim[8].yaw_default) or yaw_direction)
									elseif ui.get(anti_aim[8].yaw_mode) == "L/R" then
										ui.set(ref.yaw[2], (yaw_direction == 0 and (side == 1 and ui.get(anti_aim[8].yaw_left) or ui.get(anti_aim[8].yaw_right)) or yaw_direction))
									elseif ui.get(anti_aim[8].yaw_mode) == "Superior" then
										ui.set(ref.yaw[2], yaw_direction == 0 and client.random_int(ui.get(anti_aim[8].yaw_superior), ui.get(anti_aim[8].yaw_superior)+client.random_int(-10, 10) or yaw_direction))
									elseif ui.get(anti_aim[8].yaw_mode) == "3 Way" then
										local yaw_list = { -ui.get(anti_aim[8].fiveway_yaw_add), 0, ui.get(anti_aim[8].fiveway_yaw_add)}
										if globals.tickcount() % 1 < 1 then
											current_phase = current_phase + 1
										end
										if current_phase > 3 then
											current_phase = 1
										end
										ui.set(ref.yaw[2], yaw_direction == 0 and yaw_list[current_phase] or yaw_direction)
									else
										local yaw_list = { -ui.get(anti_aim[8].threeway_yaw_add), -ui.get(anti_aim[8].threeway_yaw_add)/2, 0, ui.get(anti_aim[8].threeway_yaw_add)/2, ui.get(anti_aim[8].threeway_yaw_add)}
										if globals.tickcount() % 1 < 1 then
											current_phase = current_phase + 1
										end
										if current_phase > 5 then
											current_phase = 1
										end
										ui.set(ref.yaw[2], yaw_direction == 0 and yaw_list[current_phase] or yaw_direction)
									end
								end 
									ui.set(ref.byaw[1], ui.get(anti_aim[8].body_yaw))
									
										if ui.get(anti_aim[8].body_yaw_mode) == "normal" then
											ui.set(ref.byaw[1], ui.get(anti_aim[8].body_yaw))
											ui.set(ref.byaw[2], ui.get(anti_aim[8].body_yaw_val))
										else
											ui.set(ref.byaw[1], ui.get(anti_aim[8].body_yaw))
											ui.set(ref.byaw[2], (side == 1 and ui.get(anti_aim[8].left_byaw_val) or ui.get(anti_aim[8].right_byaw_val)))
										end
								
									if ui.get(anti_aim[8].jitter_mode) == "normal" then
										if ui.get(anti_aim[8].jitter) == "Random Center" then
											ui.set(ref.jitter[1], "Center")
											ui.set(ref.jitter[2], client.random_int(ui.get(anti_aim[8].jitter_val), ui.get(anti_aim[8].jitter_val)+client.random_int(-12, 18)))
										
										elseif ui.get(anti_aim[8].jitter) == "5 Way" then
											local jitter_list = { -ui.get(anti_aim[8].threeway_jitter_val), -ui.get(anti_aim[8].threeway_jitter_val)/2, 0, ui.get(anti_aim[8].threeway_jitter_val)/2, ui.get(anti_aim[8].threeway_jitter_val)}
											if globals.tickcount() % 1 < 1 then
												current_phase_jit = current_phase_jit + 1
											end
											if current_phase_jit > 5 then
												current_phase_jit = 1
											end
											ui.set(ref.jitter[2], jitter_list[current_phase_jit])
										else
											ui.set(ref.jitter[2], ui.get(anti_aim[8].jitter_val))
											ui.set(ref.jitter[1], ui.get(anti_aim[8].jitter))
										end
									else
										if ui.get(anti_aim[8].jitter) == "Random Center" then
											ui.set(ref.jitter[1], "Center")
											ui.set(ref.jitter[2], client.random_int(ui.get(anti_aim[8].jitter_val), ui.get(anti_aim[8].jitter_val)+client.random_int(-12, 18)))
										
										elseif ui.get(anti_aim[8].jitter) == "lol" then
											local current_val = side == 1 and ui.get(anti_aim[8].left_jitter_val) or ui.get(anti_aim[8].right_jitter_val)
											local jitter_list = { -current_val/2, current_val, current_val/2, -current_val}
											
											if globals.tickcount() % 1 < 1 then
												current_phase_jit = current_phase_jit + 1
											end
											if current_phase_jit == 4 then
												current_phase_jit = 1
											end
											ui.set(ref.jitter[2], jitter_list[current_phase_jit])
										elseif ui.get(anti_aim[8].jitter) == "5 Way" then
											local current_val = side == 1 and ui.get(anti_aim[8].left_jitter_val) or ui.get(anti_aim[8].right_jitter_val)
											local jitter_list = { -current_val, -current_val/2, 0, current_val/2, current_val}
											if globals.tickcount() % 1 < 1 then
												current_phase_jit = current_phase_jit + 1
											end
											if current_phase_jit > 5 then
												current_phase_jit = 1
											end
											ui.set(ref.jitter[2], jitter_list[current_phase_jit])
										else
											ui.set(ref.jitter[1], ui.get(anti_aim[8].jitter))
											ui.set(ref.jitter[2], side == 1 and ui.get(anti_aim[8].left_jitter_val) or ui.get(anti_aim[8].right_jitter_val))
										end
									end

									

								else
									if brute.last_miss + 3 > globals.curtime() then return end
									ui.set(ref.yaw[1], 180)
								if c.chokedcommands ~= 0 then
								else
									if ui.get(anti_aim[i].yaw_mode) == "Default" then
										ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(anti_aim[i].yaw_default) or yaw_direction)
									elseif ui.get(anti_aim[i].yaw_mode) == "L/R" then
										ui.set(ref.yaw[2], (yaw_direction == 0 and (side == 1 and ui.get(anti_aim[i].yaw_left) or ui.get(anti_aim[i].yaw_right)) or yaw_direction))
									elseif ui.get(anti_aim[i].yaw_mode) == "Superior" then
										ui.set(ref.yaw[2], yaw_direction == 0 and client.random_int(ui.get(anti_aim[i].yaw_superior), ui.get(anti_aim[i].yaw_superior)+client.random_int(-10, 10) or yaw_direction))
									elseif ui.get(anti_aim[i].yaw_mode) == "3 Way" then
										local yaw_list = { -ui.get(anti_aim[i].fiveway_yaw_add), 0, ui.get(anti_aim[i].fiveway_yaw_add)}
										if globals.tickcount() % 1 < 1 then
											current_phase = current_phase + 1
										end
										if current_phase > 3 then
											current_phase = 1
										end
										ui.set(ref.yaw[2], yaw_direction == 0 and yaw_list[current_phase] or yaw_direction)
									else
										local yaw_list = { -ui.get(anti_aim[i].threeway_yaw_add), -ui.get(anti_aim[i].threeway_yaw_add)/2, 0, ui.get(anti_aim[i].threeway_yaw_add)/2, ui.get(anti_aim[i].threeway_yaw_add)}
										if globals.tickcount() % 1 < 1 then
											current_phase = current_phase + 1
										end
										if current_phase > 5 then
											current_phase = 1
										end
										ui.set(ref.yaw[2], yaw_direction == 0 and yaw_list[current_phase] or yaw_direction)
									end
								end
									ui.set(ref.byaw[1], ui.get(anti_aim[i].body_yaw))
									
										if ui.get(anti_aim[i].body_yaw_mode) == "normal" then
											ui.set(ref.byaw[1], ui.get(anti_aim[i].body_yaw))
											ui.set(ref.byaw[2], ui.get(anti_aim[i].body_yaw_val))
										else
											ui.set(ref.byaw[1], ui.get(anti_aim[i].body_yaw))
											ui.set(ref.byaw[2], (side == 1 and ui.get(anti_aim[i].left_byaw_val) or ui.get(anti_aim[i].right_byaw_val)))
										end
									
									if ui.get(anti_aim[i].jitter_mode) == "normal" then
										if ui.get(anti_aim[i].jitter) == "Random Center" then
											ui.set(ref.jitter[1], "Center")
											ui.set(ref.jitter[2], client.random_int(ui.get(anti_aim[i].jitter_val), ui.get(anti_aim[i].jitter_val)+client.random_int(-12, 18)))
							
										elseif ui.get(anti_aim[i].jitter) == "lol" then
											local jitter_list = { -ui.get(anti_aim[i].lolway_yaw_add)/2, ui.get(anti_aim[i].lolway_yaw_add), ui.get(anti_aim[i].lolway_yaw_add)/2, -ui.get(anti_aim[i].lolway_yaw_add)}
											if globals.tickcount() % 1 < 1 then
												current_phase_jit = current_phase_jit + 1
											end
											if current_phase_jit == 4 then
												current_phase_jit = 1
											end
											ui.set(ref.jitter[2], jitter_list[current_phase_jit])
										elseif ui.get(anti_aim[i].jitter) == "5 Way" then
											local jitter_list = { -ui.get(anti_aim[i].threeway_jitter_val), -ui.get(anti_aim[i].threeway_jitter_val)/2, 0, ui.get(anti_aim[i].threeway_jitter_val)/2, ui.get(anti_aim[i].threeway_jitter_val)}
											if globals.tickcount() % 1 < 1 then
												current_phase_jit = current_phase_jit + 1
											end
											if current_phase_jit > 5 then
												current_phase_jit = 1
											end
											ui.set(ref.jitter[2], jitter_list[current_phase_jit])
										else
											ui.set(ref.jitter[2], ui.get(anti_aim[i].jitter_val))
											ui.set(ref.jitter[1], ui.get(anti_aim[i].jitter))
										end
									else
										if ui.get(anti_aim[i].jitter) == "Random Center" then
											ui.set(ref.jitter[1], "Center")
											ui.set(ref.jitter[2], client.random_int(ui.get(anti_aim[i].jitter_val), ui.get(anti_aim[i].jitter_val)+client.random_int(-12, 18)))
							
										elseif ui.get(anti_aim[i].jitter) == "lol" then
											local current_val = side == 1 and ui.get(anti_aim[i].left_jitter_val) or ui.get(anti_aim[i].right_jitter_val)
											local jitter_list = { -current_val/2, current_val, current_val/2, -current_val}
											
											if globals.tickcount() % 1 < 1 then
												current_phase_jit = current_phase_jit + 1
											end
											if current_phase_jit > 4 then
												current_phase_jit = 1
											end
											ui.set(ref.jitter[2], jitter_list[current_phase_jit])
										elseif ui.get(anti_aim[i].jitter) == "5 Way" then
											local current_val = side == 1 and ui.get(anti_aim[i].left_jitter_val) or ui.get(anti_aim[i].right_jitter_val)
											local jitter_list = { -current_val, -current_val/2, 0, current_val/2, current_val}
											if globals.tickcount() % 1 < 1 then
												current_phase_jit = current_phase_jit + 1
											end
											if current_phase_jit > 5 then
												current_phase_jit = 1
											end
											ui.set(ref.jitter[2], jitter_list[current_phase_jit])
										else
											ui.set(ref.jitter[1], ui.get(anti_aim[i].jitter))
											ui.set(ref.jitter[2], side == 1 and ui.get(anti_aim[i].left_jitter_val) or ui.get(anti_aim[i].right_jitter_val))
										end
									end

									
									end
								end
							end
						elseif ui.get(menu.presets) == "Dynamic" and brute.last_miss + 3 < globals.curtime() and misc.knife_isactive == false then
							if globals.tickcount() % 20 == 1 then
								aa_tbl = {
									jitter = math.random(50, 60),
									fakeyaw = math.random(50, 60),
									yaw = math.random(-10,10),
									bodyyaw = 0,
								}
								if ui.get(menu.debug) then
									table.insert(render.notifications.table_text, {
										text = "Picked preset "..math.random(1,2),
										timer = globals.realtime(),
									
										smooth_y = render.notifications.c_var.screen[2] + 100,
										alpha = 0,
										alpha2 = 0,
										alpha3 = 0,
									
									
										box_left = 0,
										box_right = 0,
									
										box_left_1 = 0,
										box_right_1 = 0
									}) 

								end
							end
								ui.set(ref.yaw[1], "180")
									ui.set(ref.yaw[2], aa_tbl.yaw)
										ui.set(ref.byaw[2], aa_tbl.bodyyaw)
								ui.set(ref.byaw[1], "Jitter")
									ui.set(ref.jitter[1], "Center")
								ui.set(ref.jitter[2], aa_tbl.jitter)
						
	
						end
						local defensive_active = is_defensive_active()
						if ui.get(menu.checkbox)  then
						--if c.command_number % 16 < 2 then

							if player_state() ~= "duckjump" or player_state() ~= "jump" then
								c.force_defensive = true
							end
						end

						
						

						ui.set(menu.ui_forward, 'On hotkey')
						ui.set(menu.ui_left, 'On hotkey')
						ui.set(menu.ui_right, 'On hotkey')
						if (ui.get(menu.fs_toggle)) then
							yaw_direction = 0
							last_press_t_dir = 0
							Mode = "Off"
						else
							if ui.get(menu.ui_forward) and last_press_t_dir + 0.2 < globals.curtime() then
								Mode = "Forward"
								yaw_direction = yaw_direction == 180 and 0 or 180
								last_press_t_dir = globals.curtime()
							elseif ui.get(menu.ui_right) and last_press_t_dir + 0.2 < globals.curtime() then
								Mode = "Right"
								yaw_direction = yaw_direction == 90 and 0 or 90
								last_press_t_dir = globals.curtime()
							elseif ui.get(menu.ui_left) and last_press_t_dir + 0.2 < globals.curtime() then
								Mode = "Left"
								yaw_direction = yaw_direction == -90 and 0 or -90
								last_press_t_dir = globals.curtime()
							elseif last_press_t_dir > globals.curtime() then
								Mode = "Off"
								last_press_t_dir = globals.curtime()
								yaw_direction = 0
							end
						end




						if ui.get(menu.lagcomp) and ui.get(ref.os[2]) and not ui.get(ref.fake_duck) then
							ui.set(ref.enablefl, false)
							ui.set(ref.fl_limit, 1)
						elseif ui.get(menu.lagcomp) and ui.get(ref.os[2]) and ui.get(ref.fake_duck) then
							ui.set(ref.enablefl, true)
							ui.set(ref.fl_limit, 14)
						elseif ui.get(menu.lagcomp) and not ui.get(ref.os[2]) then
							ui.set(ref.enablefl, true)
							ui.set(ref.fl_limit, 14)
						else
							ui.set(ref.enablefl, true)
							ui.set(ref.fl_limit, 14)
						end
						if ui.get(menu.fs_toggle) then
							ui.set(ref.freestanding[2], "Always on")
							ui.set(ref.freestanding[1], true)
						else
							ui.set(ref.freestanding[2], "On hotkey")
							ui.set(ref.freestanding[1], false)
						end
						end)	


						


					
						client.set_event_callback("setup_command", function(cmd)
							
							


							local nn_list = { -120, -90, -60, 60, 90, 120}
						if globals.tickcount() % 1 < 1 then
							current_phase_yaw = current_phase_yaw + 1
						end
						if current_phase_yaw > 6 then
							current_phase_yaw = 1
						end
							if misc.knife_isactive == false then
								if ui.get(menu.breaker) == "Pitch" and ui.get(menu.breaker_switch) then
									if is_defensive_active() then
										breaker_active = true
										ui.set(ref.pitch[1], "Up")
									else
										breaker_active = false
										ui.set(ref.pitch[1], "Down")
									end
								elseif ui.get(menu.breaker) == "Sideways" and ui.get(menu.breaker_switch) then
									if is_defensive_active() then
										breaker_active = true
										ui.set(ref.pitch[1], "Up")
										ui.set(ref.jitter[2], 10)
										ui.set(ref.yaw[1], "180")
										ui.set(ref.yaw[2], yaw_direction == 0 and (nn_list[current_phase_yaw]) or yaw_direction)
										ui.set(ref.byaw[2], 0)
		
									else
										breaker_active = false
										ui.set(ref.pitch[1], "Down")
									end
								elseif ui.get(menu.breaker) == "Custom" and ui.get(menu.breaker_switch) then
									if is_defensive_active() then
										breaker_active = true
										ui.set(ref.pitch[1], ui.get(menu.exploits.pitch))
										ui.set(ref.yaw[2], yaw_direction == 0 and (globals.tickcount() % 5 <= 2 and ui.get(menu.exploits.yaw_1st) or ui.get(menu.exploits.yaw_2nd)) or yaw_direction)
										ui.set(ref.byaw[2], ui.get(menu.exploits.bodyyaw))
		
									else
										breaker_active = false
										ui.set(ref.pitch[1], "Down")
									end
								elseif ui.get(menu.breaker) == "Off" then
									breaker_active = false
									ui.set(ref.pitch[1], "Down")
								end
							end
								if not ui.get(menu.breaker_switch) then
									breaker_active = false
									ui.set(ref.pitch[1], "Down")
								end
						end)

						client.set_event_callback("bullet_impact", function(e)
						brute_impact(e)
						end)

						client.set_event_callback("player_death", function(e)
						brute_death(e)
						if client.userid_to_entindex(e.userid) == entity.get_local_player() then
							brute.reset()
						end
						end)

						client.set_event_callback("client_disconnect", function()
						brute.reset()
						end)

						client.set_event_callback("game_newmap", function()
						brute.reset()
						end)

						client.set_event_callback("csaliename_disconnected", function()
						brute.reset()
						end)

						local fakelag = ui.reference("AA", "Fake lag", "Limit")
						local ground_ticks, end_time = 1, 0

						

						client.set_event_callback("pre_render", function()
							if not entity.get_local_player() then return end
						if contains(menu.animfucker, 'Static legs in air') then
							entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
						end

						if contains(menu.animfucker, 'Backward legs') then
							entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 6)
						end

						if entity.is_alive(entity.get_local_player()) then

							if contains(menu.animfucker, 'Zero pitch on land') then
								local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)

								if on_ground == 1 then
									ground_ticks = ground_ticks + 1
								else
									ground_ticks = 0
									end_time = globals.curtime() + 1
								end

								if ground_ticks > ui.get(fakelag)+1 and end_time > globals.curtime() then
									entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
								end

							end
						end
						if contains(menu.animfucker, "Moonwalk") then
							local me = requirements.ent.get_local_player()
				local m_fFlags = me:get_prop("m_fFlags")
				local is_onground = bit.band(m_fFlags, 1) ~= 0
				if not is_onground then
					local my_animlayer = me:get_anim_overlay(6) -- MOVEMENT_MOVE
					my_animlayer.weight = 1
				end
						end
						end)

						local function doubletap_charged()
							if not ui.get(ref.dt[1]) or not ui.get(ref.dt[2]) or ui.get(ref.fake_duck) then return false end
							if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then return end
							local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
							if weapon == nil then return false end
							local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
							local checkcheck = entity.get_prop(weapon, "m_flNextPrimaryAttack")
							if checkcheck == nil then return end
							local next_primary_attack = checkcheck + 0.5
							if next_attack == nil or next_primary_attack == nil then return false end
							return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
						end


						local function arrows()
							local localp = entity.get_local_player()
							local x, y = client.screen_size()

							local me = entity.get_local_player()

							if not entity.is_alive(me) then return end
							local mr2,mg2,mb2,ma2 = ui.get(menu.main_clr4)

							local bodyyaw = entity.get_prop(localp, "m_flPoseParameter", 11) * 120 - 60

							if ui.get(menu.arrows) then
								renderer.triangle(x / 2 + 55, y / 2 + 2, x / 2 + 42, y / 2 - 7, x / 2 + 42, y / 2 + 11,
								yaw_direction == 90 and mr2 or 25,
								yaw_direction == 90 and mg2 or 25,
								yaw_direction == 90 and mb2 or 25,
								yaw_direction == 90 and ma2 or 160)

								renderer.triangle(x / 2 - 55, y / 2 + 2, x / 2 - 42, y / 2 - 7, x / 2 - 42, y / 2 + 11,
								yaw_direction == -90 and mr2 or 25,
								yaw_direction == -90 and mg2 or 25,
								yaw_direction == -90 and mb2 or 25,
								yaw_direction == -90 and ma2 or 160)

								renderer.rectangle(x / 2 + 38, y / 2 - 7, 2, 18,
								bodyyaw < -1 and mr2 or 25,
								bodyyaw < -1 and mg2 or 25,
								bodyyaw < -1 and mb2 or 25,
								bodyyaw < -1 and ma2 or 160)
								renderer.rectangle(x / 2 - 40, y / 2 - 7, 2, 18,
								bodyyaw > 1 and mr2 or 25,
								bodyyaw > 1 and mg2 or 25,
								bodyyaw > 1 and mb2 or 25,
								bodyyaw > 1 and ma2 or 160)
							end
						end
						local function state_panel()
							local center = {client.screen_size()/2}
							local lp = entity.get_local_player()
							if not entity.is_alive(lp) then return end
   			 renderer.gradient(center[1], 100, 200, 50, 255, 0, 0, 255, 0, 0, 255, 255, true)
						end


						local function color(desync)
							local r, g, b = 255, 0, 0
							if desync < 0 then
								r, g = 0, 255
							end
							return r, g, b
						end
						
						local function gradient_text(rr, gg, bb, aa, rrr, ggg, bbb, aaa, text)
							local r1, g1, b1, a1 = rr, gg, bb, aa
							local r2, g2, b2, a2 = rrr, ggg, bbb, aaa
							local highlight_fraction = (globals.realtime() / 2 % 1.2 * speed) - 1.2
							local output = ""
							for idx = 1, #text do
								local character = text:sub(idx, idx)
								local character_fraction = idx / #text
								local r, g, b, a = r1, g1, b1, a1
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
								output = output .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, 255, text:sub(idx, idx))
							end
							return output
						end
						
						
						  
						  
						  
						local fs_a = 100
						local os_a = 100
						local dt_a = 100
						local add_x = 0
						local add_x1 = 0
						local function animation(check, name, value, speed)
							if check then
								return name + (value - name) * globals.frametime() * speed
							else
								return name - (value + name) * globals.frametime() * speed

							end
						end
						
						
						
						
						  
						  
						  
						  
						client.set_event_callback("paint_ui", function()

							
						SetTableVisibility({ref.pitch[1], ref.yaw[1], ref.yaw[2], ref.yaw_base, ref.byaw[1], ref.byaw[2], ref.jitter[1], ref.jitter[2], ref.fby, ref.edge, ref.freestanding[1], ref.freestanding[2], ref.roll}, false)
						if ui.get(menu.retard) == "Visuals" then
						SetTableVisibility({menu.indicators, menu.notifications, menu.main_clr, menu.arrows, menu.main_clr4, menu.state_panel, menu.state_panel_color}, true)
						else
						SetTableVisibility({menu.indicators, menu.notifications, menu.main_clr, menu.arrows, menu.main_clr4, menu.state_panel, menu.state_panel_color}, false)
						end
						if ui.get(menu.retard) == "Anti-Aim" then
					
						SetTableVisibility({menu.subtab_antiaim, menu.presets, menu.debug}, true)
						SetTableVisibility({menu.conditiontab, export_btn, import_btn}, ui.get(menu.subtab_antiaim) ~= "Keybinds" and ui.get(menu.presets) == "Builder")
						SetTableVisibility({menu.ui_left, menu.ui_right, menu.ui_forward, menu.fs_toggle, menu.checkbox}, ui.get(menu.subtab_antiaim) == "Keybinds")
						else
						SetTableVisibility({menu.subtab_antiaim, menu.presets, menu.conditiontab, export_btn, import_btn, menu.ui_left, menu.ui_right, menu.ui_forward, menu.fs_toggle, menu.checkbox}, false)
						end
						if ui.get(menu.retard) == "Misc" then
						SetTableVisibility({menu.lagcomp, menu.animfucker, menu.breaker, menu.breaker_switch, menu.knife_hotkey}, true)
						SetTableVisibility({menu.exploits.yaw_1st, menu.exploits.yaw_2nd, menu.exploits.pitch, menu.exploits.bodyyaw}, ui.get(menu.breaker) == "Custom")
						SetTableVisibility({menu.knife_distance}, ui.get(menu.knife_hotkey))
						else
						SetTableVisibility({menu.lagcomp, menu.animfucker, menu.breaker, menu.breaker_switch, menu.knife_hotkey, menu.knife_distance}, false)
						SetTableVisibility({menu.exploits.yaw_1st, menu.exploits.yaw_2nd, menu.exploits.pitch, menu.exploits.bodyyaw}, false)
						end
						if ui.get(menu.retard) == "Anti-Bruteforce" then
						for i = 1, 5 do
					
							ui.set_visible(antibrute[i].yaw_mode, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(menu.contains) == "Phases")
							ui.set_visible(antibrute[i].yaw_default, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].yaw_mode) == "Default" and ui.get(menu.contains) == "Phases")
							ui.set_visible(antibrute[i].yaw_superior, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].yaw_mode) == "Superior" and ui.get(menu.contains) == "Phases")
							ui.set_visible(antibrute[i].fiveway_yaw_add, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].yaw_mode) == "3 Way" and ui.get(menu.contains) == "Phases")
							ui.set_visible(antibrute[i].lolway_yaw_add, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].jitter) == "lol" and ui.get(antibrute[i].jitter_mode) == "normal")
							ui.set_visible(antibrute[i].threeway_yaw_add, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].yaw_mode) == "5 Way" and ui.get(menu.contains) == "Phases")
							ui.set_visible(antibrute[i].yaw_left, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].yaw_mode) == "L/R" and ui.get(menu.contains) == "Phases")
							ui.set_visible(antibrute[i].yaw_right, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].yaw_mode) == "L/R"and ui.get(menu.contains) == "Phases") 
							ui.set_visible(antibrute[i].body_yaw, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(menu.contains) == "Phases")
							ui.set_visible(antibrute[i].body_yaw_mode, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].body_yaw) ~= "Off" and ui.get(menu.contains) == "Phases")
							ui.set_visible(antibrute[i].body_yaw_val, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].body_yaw_mode) ~= "l/r" and ui.get(menu.contains) == "Phases" and ui.get(antibrute[i].body_yaw) ~= "Off")
							ui.set_visible(antibrute[i].left_byaw_val, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].body_yaw_mode) == "l/r" and ui.get(menu.contains) == "Phases")
							ui.set_visible(antibrute[i].right_byaw_val, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].body_yaw_mode) == "l/r" and ui.get(menu.contains) == "Phases")
							ui.set_visible(antibrute[i].jitter, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(menu.contains) == "Phases")
							ui.set_visible(antibrute[i].jitter_mode, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].jitter) ~= "Off" and ui.get(menu.contains) == "Phases")
							ui.set_visible(antibrute[i].jitter_val, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].jitter_mode) ~= "l/r" and ui.get(menu.contains) == "Phases" and ui.get(antibrute[i].jitter) ~= "5 Way" and ui.get(antibrute[i].jitter) ~= "Off" and ui.get(antibrute[i].jitter) ~= "lol")
							ui.set_visible(antibrute[i].left_jitter_val, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].jitter_mode) == "l/r" and ui.get(menu.contains) == "Phases")
							ui.set_visible(antibrute[i].right_jitter_val, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].jitter_mode) == "l/r" and ui.get(menu.contains) == "Phases")
							
							ui.set_visible(antibrute[i].threeway_jitter_val, ui.get(menu.bruteforce.phases) == brutenumtotext[i] and ui.get(antibrute[i].jitter) == "5 Way" and ui.get(antibrute[i].jitter_mode) ~= "l/r" and ui.get(menu.contains) == "Phases")
					
						end
						SetTableVisibility({import_antibrute, export_antibrute, menu.antibrute_switch}, true)
						SetTableVisibility({menu.contains}, ui.get(menu.antibrute_switch))
						SetTableVisibility({menu.bruteforce.phases}, ui.get(menu.antibrute_switch) and ui.get(menu.contains) == "Phases")
					
						else
						SetTableVisibility({menu.contains, import_antibrute, export_antibrute, menu.antibrute_switch, menu.bruteforce.phases}, false)
						for i = 1, 5 do
							ui.set_visible(antibrute[i].yaw_left, false)
							ui.set_visible(antibrute[i].yaw_mode, false)
							ui.set_visible(antibrute[i].yaw_default, false)
							ui.set_visible(antibrute[i].yaw_superior, false)
							ui.set_visible(antibrute[i].threeway_yaw_add, false)
							ui.set_visible(antibrute[i].yaw_right, false)
							ui.set_visible(antibrute[i].body_yaw, false)
							ui.set_visible(antibrute[i].body_yaw_val, false)
							ui.set_visible(antibrute[i].lolway_yaw_add, false)
							ui.set_visible(antibrute[i].left_byaw_val, false)
							ui.set_visible(antibrute[i].right_byaw_val, false)
							ui.set_visible(antibrute[i].jitter, false)
							ui.set_visible(antibrute[i].jitter_val, false)
							ui.set_visible(antibrute[i].left_jitter_val, false)
							ui.set_visible(antibrute[i].right_jitter_val, false)
							ui.set_visible(antibrute[i].fiveway_yaw_add, false)
							ui.set_visible(antibrute[i].threeway_jitter_val, false)
							ui.set_visible(antibrute[i].jitter_mode, false)
							ui.set_visible(antibrute[i].body_yaw_mode, false)
						end
						end
					
						if ui.get(menu.retard) == "Anti-Aim" and ui.get(menu.subtab_antiaim) == "Anti-Aim" and ui.get(menu.presets) == "Builder" then
						SetTableVisibility({anti_aim[8].override}, false)
						for i = 1, 8 do
							for i = 1, 7 do
								SetTableVisibility({anti_aim[i].override} ,ui.get(menu.conditiontab) == numtotext[i] )
							end
							ui.set_visible(anti_aim[i].yaw_mode, ui.get(menu.conditiontab) == numtotext[i] )
							ui.set_visible(anti_aim[i].yaw_default, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].yaw_mode) == "Default")
							ui.set_visible(anti_aim[i].yaw_superior, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].yaw_mode) == "Superior")
							ui.set_visible(anti_aim[i].fiveway_yaw_add, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].yaw_mode) == "3 Way")
							ui.set_visible(anti_aim[i].lolway_yaw_add, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].jitter) == "lol" and ui.get(anti_aim[i].jitter_mode) == "normal")
							ui.set_visible(anti_aim[i].threeway_yaw_add, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].yaw_mode) == "5 Way")
							ui.set_visible(anti_aim[i].yaw_left, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].yaw_mode) == "L/R")
							ui.set_visible(anti_aim[i].yaw_right, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].yaw_mode) == "L/R")
							ui.set_visible(anti_aim[i].yaw_manipulation_add_left, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].yaw_mode) == "Yaw Manipulation")
							ui.set_visible(anti_aim[i].yaw_manipulation_add_right, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].yaw_mode) == "Yaw Manipulation")
							ui.set_visible(anti_aim[i].body_yaw, ui.get(menu.conditiontab) == numtotext[i])
							ui.set_visible(anti_aim[i].body_yaw_mode, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].body_yaw) ~= "Off")
							ui.set_visible(anti_aim[i].body_yaw_val, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].body_yaw_mode) ~= "l/r" and ui.get(anti_aim[i].body_yaw) ~= "Off")
							ui.set_visible(anti_aim[i].left_byaw_val, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].body_yaw_mode) == "l/r")
							ui.set_visible(anti_aim[i].right_byaw_val, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].body_yaw_mode) == "l/r")
							ui.set_visible(anti_aim[i].jitter, ui.get(menu.conditiontab) == numtotext[i])
							ui.set_visible(anti_aim[i].jitter_mode, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].jitter) ~= "Off")
							ui.set_visible(anti_aim[i].jitter_val, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].jitter_mode) ~= "l/r" and ui.get(anti_aim[i].jitter) ~= "5 Way" and ui.get(anti_aim[i].jitter) ~= "Off" and ui.get(anti_aim[i].jitter) ~= "lol")
							ui.set_visible(anti_aim[i].left_jitter_val, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].jitter_mode) == "l/r")
							ui.set_visible(anti_aim[i].right_jitter_val, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].jitter_mode) == "l/r")
							
							ui.set_visible(anti_aim[i].threeway_jitter_val, ui.get(menu.conditiontab) == numtotext[i] and ui.get(anti_aim[i].jitter) == "5 Way" and ui.get(anti_aim[i].jitter_mode) ~= "l/r")
						end
						else
						for i = 1, 8 do
							ui.set_visible(anti_aim[i].override, false)
							ui.set_visible(anti_aim[i].yaw_left, false)
							ui.set_visible(anti_aim[i].yaw_mode, false)
							ui.set_visible(anti_aim[i].yaw_default, false)
							ui.set_visible(anti_aim[i].yaw_superior, false)
							ui.set_visible(anti_aim[i].yaw_manipulation_add_left, false)
							ui.set_visible(anti_aim[i].yaw_manipulation_add_right, false)
							ui.set_visible(anti_aim[i].threeway_yaw_add, false)
							ui.set_visible(anti_aim[i].yaw_right, false)
							ui.set_visible(anti_aim[i].body_yaw, false)
							ui.set_visible(anti_aim[i].body_yaw_val, false)
							ui.set_visible(anti_aim[i].lolway_yaw_add, false)
							ui.set_visible(anti_aim[i].left_byaw_val, false)
							ui.set_visible(anti_aim[i].right_byaw_val, false)
							ui.set_visible(anti_aim[i].jitter, false)
							ui.set_visible(anti_aim[i].jitter_val, false)
							ui.set_visible(anti_aim[i].left_jitter_val, false)
							ui.set_visible(anti_aim[i].right_jitter_val, false)

							ui.set_visible(anti_aim[i].fiveway_yaw_add, false)
							ui.set_visible(anti_aim[i].threeway_jitter_val, false)
							ui.set_visible(anti_aim[i].jitter_mode, false)
							ui.set_visible(anti_aim[i].body_yaw_mode, false)
						end
						end
						end)
					
						client.set_event_callback("shutdown", function()
						SetTableVisibility({ref.pitch[1], ref.yaw[1], ref.yaw[2], ref.yaw_base, ref.byaw[1], ref.byaw[2], ref.jitter[1], ref.jitter[2], ref.fby, ref.edge, ref.freestanding[1], ref.freestanding[2], ref.roll}, true)
						end)
						
						  
						  
						  

						  

						  
	



					
						
						local function animation(check, name, value, speed)
							if check then
								return name + (value - name) * globals.frametime() * speed
							else
								return name - (value + name) * globals.frametime() * speed

							end
						end


						local lolpos1 = 0
						local lolpos2 = 0
						local xpos = 0
						local xpos2 = 0
						local xpos3 = 0
						local xpos4 = 0
						local xpos5 = 0
						local indi_anim = 0
						local flag = "c-"
						local deez = 0
						local fs_a, body_a, sp_a = 150, 150, 150
						local ypos  = 0
						local alpha1 = 0
						local dt_r, dt_g, dt_b, dt_a = 0, 0, 0, 0
						local value2 = 0
						local hitler = {}

						hitler.lerp = function(start, vend, time)
   							 return start + (vend - start) * time
						end
						client.set_event_callback("paint", function()
						arrows()
						--state_panel()
						

					

						local lp = entity.get_local_player()
						local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
						local side = bodyyaw > 0 and 1 or -1		
						local sr, sg, sb, sa = (side == 1 and 142 or 255), (side == 1 and 165 or 255), (side == 1 and 229 or 255), 255
						local lr, lg, lb, la = (side == 1 and 255 or 142), (side == 1 and 255 or 165), (side == 1 and 255 or 229), 255
						local x, y = client.screen_size()
						local me = entity.get_local_player()

						local scoped = entity.get_prop(me, 'm_bIsScoped')
						local me = entity.get_local_player()
						local wpn = entity.get_player_weapon(me)

						local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
						local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
						local resume_zoom = entity.get_prop(me, 'm_bResumeZoom') == 1

						local is_valid = entity.is_alive(me) and wpn ~= nil and scope_level ~= nil
						local act = is_valid and scope_level > 0 and scoped and not resume_zoom
						if not entity.is_alive(me) then return end
						if me == nil then return end
						if not ui.get(menu.indicators) then return end
						if act then
							xpos = animation(scoped, xpos, 26, 10)
							xpos2 = animation(scoped, xpos2, 2, 10)
							xpos5 = animation(scoped, xpos5, 24, 10)
							ypos = animation(scoped, ypos, -6, 10)
							deez = animation(scoped, deez, -6, 10)
							flag = "-"
						else
							xpos = animation(scoped ~= 1, xpos, 0, 10)
							xpos2 = animation(scoped ~= 1, xpos2, 0, 10)
							ypos = animation(scoped ~= 1, ypos, 0, 10)
							deez = animation(scoped ~= 1, deez, 0, 10)
							xpos5 = animation(scoped ~= 1, xpos5, 0, 10)
							flag = "c-"
						end
						if ui.get(ref.dt[2]) or ui.get(ref.os[2]) then
							alpha1 = hitler.lerp(alpha1, 8, globals.frametime() * 8)
						else
							alpha1 = hitler.lerp(alpha1, 0, globals.frametime() * 8)
						end
						if ui.get(ref.dt[2]) and ui.get(ref.os[2]) then
							xpos3 = hitler.lerp(xpos3, -4, globals.frametime() * 8)
							xpos4 = hitler.lerp(xpos3, 20, globals.frametime() * 8)
						else
							xpos3 = hitler.lerp(xpos3, 0, globals.frametime() * 8)
							xpos4 = hitler.lerp(xpos3, 0, globals.frametime() * 8)
						end
						if requirements.antiaim_funcs.get_double_tap() then
							dt_r = 0
							dt_g = 255
							dt_b = 0
							dt_a = 200
						else
							dt_r = 255
							dt_g = 0
							dt_b = 0
							dt_a = 200
						end
						if ui.get(ref.freestanding[2]) then 
							fs_a = 255
						else
							fs_a = 150
						end	
						if ui.get(ref.baim_key) then
							body_a = 255
						else
							body_a = 150
						end
						if ui.get(ref.safepoint) then
							sp_a = 255
						else
							sp_a = 150
						end
						renderer.text(x/2-23+xpos5, y/2+28+alpha1, 255, 255, 255, sp_a, '-', 0, "SP")
						renderer.text(x/2-9+xpos5, y/2+28+alpha1, 255, 255, 255, body_a, '-', 0, "BODY")
						renderer.text(x/2+14+xpos5, y/2+28+alpha1, 255, 255, 255, fs_a, '-', 0, "FS")
						renderer.text(x/2-23+xpos, y/2+8, sr, sg, sb, sa, 'b', 0, "alien")
						renderer.text(x/2+1+xpos, y/2+8, lr, lg, lb, la, 'b', 0, "yaw°")
					--	renderer.text(x/2+xpos2, y/2+24+ypos, 255, 255, 255, 150, flag, 0, "/"..player_state():upper().."/")
						if ui.get(ref.dt[2]) and ui.get(ref.os[2]) then
							renderer.text(x/2+xpos2, y/2+24+alpha1+deez, dt_r, dt_g, dt_b, (ui.get(ref.dt[2]) and dt_a or 0), flag, 0, "DT")
						elseif ui.get(ref.os[2]) and not ui.get(ref.dt[2]) then
							renderer.text(x/2+xpos2, y/2+24+alpha1+deez, 255, 255, 255, 255, flag, 0, "OS")
						elseif ui.get(ref.dt[2]) and not ui.get(ref.os[2]) then
							renderer.text(x/2+xpos2, y/2+24+alpha1+deez, dt_r, dt_g, dt_b, (ui.get(ref.dt[2]) and dt_a or 0), flag, 0, "DT")
						end


							-- Get the center of the screen
							local screen_width, screen_height = client.screen_size()
							local center_x, center_y = screen_width / 2, screen_height / 2
						  
							-- Get the desync value
							local desync = math.abs(requirements.antiaim_funcs.get_body_yaw(2))
						  
							-- Round up desync to an integer value
							desync = math.ceil(desync)
						  
							-- Set the text color based on the desync value
							local text_color = {255, 255, 255}
						
						  
							-- Calculate the gradient color based on the desync value
							local gradient_color = {255, 255, 255}
						  
						  
							-- Calculate the size and position of the indicator based on screen size
							local text = "ALIEN " .. requirements.obex_data.build:upper()
							local text_width, text_height = renderer.measure_text(requirements.obex_data.build:upper(), "ALIEN ")
	
							local indicator_width = text_width + 25
							local indicator_height = screen_height * 0.006
						  
							local scoped = entity.get_prop(me, 'm_bIsScoped')
							local me = entity.get_local_player()
							local wpn = entity.get_player_weapon(me)
	
							local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
							local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
							local resume_zoom = entity.get_prop(me, 'm_bResumeZoom') == 1
	
							local is_valid = entity.is_alive(me) and wpn ~= nil and scope_level ~= nil
							local act = is_valid and scope_level > 0 and scoped and not resume_zoom
	
	
							if act then
								lolpos1  = animation(act, lolpos1, 28, 10)
								lolpos2  = animation(act, lolpos2, 29, 10)
	
							else
								lolpos1  = animation(not act, lolpos1, 0, 10)
								lolpos2  = animation(not act, lolpos2, 0, 10)
							end
	
							-- Draw the box outline
							renderer.rectangle(center_x - (indicator_width / 2)+1+lolpos1, center_y + 21, indicator_width, indicator_height, 0, 0, 0, 150)
						  
						
							-- Draw the fill
							local fill_width = math.min(desync / 60, 1) * (indicator_width - 2)
							renderer.gradient(center_x - (indicator_width / 2)+2+lolpos2 , center_y + 22, fill_width, indicator_height - 2, gradient_color[1], gradient_color[2], gradient_color[3], 255, 0, 0, 0, 0, true)
						end)

						local import_cfg = function(to_import)
						pcall(function()
						local num_tbl = {}
						local settings = json.parse(requirements.base64.decode(clipboard_import(), base64))

						for key, value in pairs(settings) do
							if type(value) == 'table' then
								for k, v in pairs(value) do
									if type(k) == 'number' then
										table.insert(num_tbl, v)
										ui.set(anti_aim[key], num_tbl)
									else
										ui.set(anti_aim[key][k], v)
									end
								end
							else
								ui.set(anti_aim[key], value)
							end
						end



						table.insert(render.notifications.table_text, {
							text = 'Imported anti-aim config',
							timer = globals.realtime(),
						
							smooth_y = render.notifications.c_var.screen[2] + 100,
							alpha = 0,
							alpha2 = 0,
							alpha3 = 0,
						
						
							box_left = 0,
							box_right = 0,
						
							box_left_1 = 0,
							box_right_1 = 0
						}) 
						
						end)
					end

					local export_cfg = function()
					local settings = {}

					pcall(function()
					for key, value in pairs(anti_aim) do
						if value then
							settings[key] = {}

							if type(value) == 'table' then
								for k, v in pairs(value) do
									settings[key][k] = ui.get(v)
								end
							else
								settings[key] = ui.get(value)
							end
						end
					end


					clipboard_export(requirements.base64.encode(json.stringify(settings), base64))
					table.insert(render.notifications.table_text, {
						text = 'Exported anti-aim config to clipboard',
						timer = globals.realtime(),
					
						smooth_y = render.notifications.c_var.screen[2] + 100,
						alpha = 0,
						alpha2 = 0,
						alpha3 = 0,
					
					
						box_left = 0,
						box_right = 0,
					
						box_left_1 = 0,
						box_right_1 = 0
					}) 
					
					end)
				end
				import_btn = ui.new_button("AA", "Anti-aimbot angles", "Import settings", import_cfg)
				export_btn = ui.new_button("AA", "Anti-aimbot angles", "Export settings", export_cfg)


				client.set_event_callback("paint_ui",noti)
