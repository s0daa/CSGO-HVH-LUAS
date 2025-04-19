-- 🟂 antarctica ✶ gamesense ✹ recode ✼ --
--[[
	API: https://docs.gamesense.gs/docs/api
]]--

local render = renderer
local events = client

local cold = 'antarctica'

local ffi = require 'ffi'
local vector = require 'vector'
local entitys = require 'gamesense/entity'
local images = require 'gamesense/images'
-- local pui = require 'gamesense/pui'

local VGUI_System010 =  events.create_interface('vgui2.dll', 'VGUI_System010')
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010)

ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
	]]

	local get_clipboard_text_count = ffi.cast('get_clipboard_text_count', VGUI_System[0][7])
	local set_clipboard_text = ffi.cast('set_clipboard_text', VGUI_System[0][9])
	local get_clipboard_text = ffi.cast('get_clipboard_text', VGUI_System[0][11])

	local clipboard_import = function()
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

local lua = {}

lua.sub = '_' --'lifetime' 
local default_config = '{"duck moving":{"yaw_modifieroffset":37,"body_yaw":"process","yaw_valuel":0,"defensive_yaw_valuel":-90,"defensive_yawmod":"off","defensive_yaw_valueoffset":0,"defensive_yaw_base":"at targets","yaw":"180","yaw_valueovon":false,"yaw_valuer":0,"pitch":89,"body_yaw_del":1,"yaw_valueoffset":0,"trigger1":3,"defensive_on":true,"trigger2":11,"defensive_yaw_valueovon":true,"defensive_body_yaw_del":1,"defensive_pitch":0,"yaw_base":"at targets","info_defensive":"override duck moving","defensive_yaw":"180","body_yaw_sw":false,"defensive_body_yaw_sw":false,"defensive_yaw_valuer":90,"defensive_disabler":false,"defensive_yaw_modifierdel":2,"defensive_body_yaw":"process","yaw_modifierdel":1,"defensive_aa_on":true,"override":true,"defensive_yaw_modifieroffset":0,"yawmod":"center","defensive_rdom":false},"shared":{"yaw_modifieroffset":0,"body_yaw":"static","yaw_valuel":0,"defensive_yaw_valuel":0,"defensive_yawmod":"off","defensive_yaw_valueoffset":0,"defensive_yaw_base":"local view","yaw":"180","yaw_valueovon":false,"yaw_valuer":0,"pitch":89,"body_yaw_del":2,"yaw_valueoffset":0,"trigger1":3,"defensive_on":false,"trigger2":11,"defensive_yaw_valueovon":false,"defensive_body_yaw_del":2,"defensive_pitch":0,"yaw_base":"at targets","info_defensive":"override shared","defensive_yaw":"off","body_yaw_sw":false,"defensive_body_yaw_sw":false,"defensive_yaw_valuer":0,"defensive_disabler":false,"defensive_yaw_modifierdel":2,"defensive_body_yaw":"off","yaw_modifierdel":2,"defensive_aa_on":false,"override":false,"defensive_yaw_modifieroffset":0,"yawmod":"off","defensive_rdom":false},"mode":"defensive","stand":{"yaw_modifieroffset":23,"body_yaw":"process","yaw_valuel":0,"defensive_yaw_valuel":0,"defensive_yawmod":"center","defensive_yaw_valueoffset":0,"defensive_yaw_base":"at targets","yaw":"180","yaw_valueovon":false,"yaw_valuer":0,"pitch":89,"body_yaw_del":1,"yaw_valueoffset":0,"trigger1":3,"defensive_on":false,"trigger2":11,"defensive_yaw_valueovon":false,"defensive_body_yaw_del":1,"defensive_pitch":48,"yaw_base":"at targets","info_defensive":"override stand","defensive_yaw":"180","body_yaw_sw":false,"defensive_body_yaw_sw":false,"defensive_yaw_valuer":0,"defensive_disabler":false,"defensive_yaw_modifierdel":1,"defensive_body_yaw":"process","yaw_modifierdel":1,"defensive_aa_on":false,"override":true,"defensive_yaw_modifieroffset":41,"yawmod":"center","defensive_rdom":false},"moving":{"yaw_modifieroffset":0,"body_yaw":"process","yaw_valuel":41,"defensive_yaw_valuel":0,"defensive_yawmod":"off","defensive_yaw_valueoffset":0,"defensive_yaw_base":"local view","yaw":"180","yaw_valueovon":true,"yaw_valuer":-32,"pitch":89,"body_yaw_del":1,"yaw_valueoffset":0,"trigger1":3,"defensive_on":false,"trigger2":11,"defensive_yaw_valueovon":false,"defensive_body_yaw_del":2,"defensive_pitch":0,"yaw_base":"at targets","info_defensive":"override moving","defensive_yaw":"off","body_yaw_sw":false,"defensive_body_yaw_sw":false,"defensive_yaw_valuer":0,"defensive_disabler":false,"defensive_yaw_modifierdel":2,"defensive_body_yaw":"off","yaw_modifierdel":2,"defensive_aa_on":false,"override":true,"defensive_yaw_modifieroffset":0,"yawmod":"off","defensive_rdom":false},"air duck":{"yaw_modifieroffset":0,"body_yaw":"process","yaw_valuel":46,"defensive_yaw_valuel":0,"defensive_yawmod":"off","defensive_yaw_valueoffset":64,"defensive_yaw_base":"at targets","yaw":"180","yaw_valueovon":true,"yaw_valuer":-32,"pitch":89,"body_yaw_del":1,"yaw_valueoffset":0,"trigger1":3,"defensive_on":true,"trigger2":11,"defensive_yaw_valueovon":false,"defensive_body_yaw_del":1,"defensive_pitch":-55,"yaw_base":"at targets","info_defensive":"override air duck","defensive_yaw":"spin","body_yaw_sw":false,"defensive_body_yaw_sw":false,"defensive_yaw_valuer":0,"defensive_disabler":false,"defensive_yaw_modifierdel":2,"defensive_body_yaw":"process","yaw_modifierdel":2,"defensive_aa_on":true,"override":true,"defensive_yaw_modifieroffset":0,"yawmod":"off","defensive_rdom":false},"air":{"yaw_modifieroffset":0,"body_yaw":"process","yaw_valuel":30,"defensive_yaw_valuel":0,"defensive_yawmod":"hidden","defensive_yaw_valueoffset":-65,"defensive_yaw_base":"at targets","yaw":"180","yaw_valueovon":true,"yaw_valuer":-28,"pitch":89,"body_yaw_del":1,"yaw_valueoffset":0,"trigger1":3,"defensive_on":true,"trigger2":11,"defensive_yaw_valueovon":false,"defensive_body_yaw_del":2,"defensive_pitch":-70,"yaw_base":"at targets","info_defensive":"override air","defensive_yaw":"180 z","body_yaw_sw":false,"defensive_body_yaw_sw":false,"defensive_yaw_valuer":0,"defensive_disabler":false,"defensive_yaw_modifierdel":2,"defensive_body_yaw":"off","yaw_modifierdel":2,"defensive_aa_on":true,"override":true,"defensive_yaw_modifieroffset":0,"yawmod":"off","defensive_rdom":false},"manual left":{"yaw_modifieroffset":0,"body_yaw":"off","yaw_valuel":0,"defensive_yaw_valuel":0,"defensive_yawmod":"off","defensive_yaw_valueoffset":0,"defensive_yaw_base":"local view","yaw":"off","yaw_valueovon":false,"yaw_valuer":0,"pitch":0,"body_yaw_del":2,"yaw_valueoffset":0,"trigger1":3,"defensive_on":false,"trigger2":11,"defensive_yaw_valueovon":false,"defensive_body_yaw_del":2,"defensive_pitch":0,"yaw_base":"local view","info_defensive":"override manual left","defensive_yaw":"off","body_yaw_sw":false,"defensive_body_yaw_sw":false,"defensive_yaw_valuer":0,"defensive_disabler":false,"defensive_yaw_modifierdel":2,"defensive_body_yaw":"off","yaw_modifierdel":2,"defensive_aa_on":false,"override":false,"defensive_yaw_modifieroffset":0,"yawmod":"off","defensive_rdom":false},"duck":{"yaw_modifieroffset":23,"body_yaw":"process","yaw_valuel":0,"defensive_yaw_valuel":-90,"defensive_yawmod":"off","defensive_yaw_valueoffset":0,"defensive_yaw_base":"at targets","yaw":"180","yaw_valueovon":false,"yaw_valuer":0,"pitch":89,"body_yaw_del":1,"yaw_valueoffset":0,"trigger1":3,"defensive_on":true,"trigger2":11,"defensive_yaw_valueovon":true,"defensive_body_yaw_del":1,"defensive_pitch":0,"yaw_base":"at targets","info_defensive":"override duck","defensive_yaw":"180","body_yaw_sw":false,"defensive_body_yaw_sw":false,"defensive_yaw_valuer":90,"defensive_disabler":false,"defensive_yaw_modifierdel":2,"defensive_body_yaw":"process","yaw_modifierdel":1,"defensive_aa_on":true,"override":true,"defensive_yaw_modifieroffset":0,"yawmod":"center","defensive_rdom":false},"state":"duck","slow moving":{"yaw_modifieroffset":39,"body_yaw":"process","yaw_valuel":0,"defensive_yaw_valuel":0,"defensive_yawmod":"off","defensive_yaw_valueoffset":0,"defensive_yaw_base":"local view","yaw":"180","yaw_valueovon":false,"yaw_valuer":0,"pitch":89,"body_yaw_del":4,"yaw_valueoffset":0,"trigger1":3,"defensive_on":false,"trigger2":11,"defensive_yaw_valueovon":false,"defensive_body_yaw_del":2,"defensive_pitch":0,"yaw_base":"at targets","info_defensive":"override slow moving","defensive_yaw":"off","body_yaw_sw":false,"defensive_body_yaw_sw":false,"defensive_yaw_valuer":0,"defensive_disabler":false,"defensive_yaw_modifierdel":2,"defensive_body_yaw":"off","yaw_modifierdel":4,"defensive_aa_on":false,"override":true,"defensive_yaw_modifieroffset":0,"yawmod":"center","defensive_rdom":false},"manual right":{"yaw_modifieroffset":0,"body_yaw":"off","yaw_valuel":0,"defensive_yaw_valuel":0,"defensive_yawmod":"off","defensive_yaw_valueoffset":0,"defensive_yaw_base":"local view","yaw":"off","yaw_valueovon":false,"yaw_valuer":0,"pitch":0,"body_yaw_del":2,"yaw_valueoffset":0,"trigger1":3,"defensive_on":false,"trigger2":11,"defensive_yaw_valueovon":false,"defensive_body_yaw_del":2,"defensive_pitch":0,"yaw_base":"local view","info_defensive":"override manual right","defensive_yaw":"off","body_yaw_sw":false,"defensive_body_yaw_sw":false,"defensive_yaw_valuer":0,"defensive_disabler":false,"defensive_yaw_modifierdel":2,"defensive_body_yaw":"off","yaw_modifierdel":2,"defensive_aa_on":false,"override":false,"defensive_yaw_modifieroffset":0,"yawmod":"off","defensive_rdom":false}}'

local software = {}
local motion = {}
local backup = {}
local timer = {}
local ragebot = {}
local gui = {}
local g_ctx = {}
local builder = {}
local indicators = {}
local corrections = {}
local cwar = {}
local round = {}
local def = {}
local textures = {}

do
	gui.find = function(tbl, arg)
		for index, value in next, tbl do 
			if value == arg then 
				return true end 
			end 
		return false
	end
end

do
	function software.init()
		software.rage = {
			binds = {
				minimum_damage = ui.reference('rage', 'aimbot', 'minimum damage'),
				minimum_damage_override = {ui.reference('rage', 'aimbot', 'minimum damage override')},
				minimum_hitchance = ui.reference('rage', 'aimbot', 'minimum hit chance'),
				double_tap = {ui.reference('rage', 'aimbot', 'double tap')},
				ps = { ui.reference('misc', 'miscellaneous', 'ping spike') },
				quickpeek = {ui.reference('rage', 'other', 'quick peek assist')},
				on_shot_anti_aim = {ui.reference('aa', 'other', 'on shot anti-aim')},
				usercmd = ui.reference('misc', 'settings', 'sv_maxusrcmdprocessticks2')
			}
		}
		software.antiaim = {
			angles = {
				enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
				pitch = { ui.reference('AA', 'Anti-aimbot angles', 'Pitch') },
				roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
				yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
				yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') },
				freestanding_body_yaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
				edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
				yaw_jitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
				body_yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
				freestanding = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
				roll_aa = ui.reference('AA', 'Anti-aimbot angles', 'Roll')
			},
			fakelag = {
				on = {ui.reference('AA', 'Fake lag', 'Enabled')},
				amount = ui.reference('AA', 'Fake lag', 'Amount'),
				variance = ui.reference('AA', 'Fake lag', 'Variance'),
				limit = ui.reference('AA', 'Fake lag', 'Limit')
			},
			other = {
				slide = {ui.reference('AA','other','slow motion')},
				fakeduck = ui.reference('rage','other','duck peek assist'),
				slow_motion = {ui.reference('AA', 'Other', 'Slow motion')},
				fake_peek = {ui.reference('AA', 'Other', 'Fake peek')},
				leg_movement = ui.reference('AA', 'Other', 'Leg movement')
			}
		}
		software.visuals = {
			effects = {
				thirdperson = { ui.reference('VISUALS', 'Effects', 'Force third person (alive)') },
				dpi = ui.reference('misc', 'settings', 'dpi scale'),
				output = ui.reference('misc', 'miscellaneous', 'draw console output')
			}
		}
	end
end

do
	local function linear(t, b, c, d)
		return c * t / d + b
	end

	local function get_deltatime()
		return globals.frametime()
	end

	local function solve(easing_fn, prev, new, clock, duration)
		if clock <= 0 then return new end
		if clock >= duration then return new end

		prev = easing_fn(clock, prev, new - prev, duration)

		if type(prev) == 'number' then
			if math.abs(new - prev) < 0.001 then
				return new
			end

			local remainder = math.fmod(prev, 1.0)

			if remainder < 0.001 then
				return math.floor(prev)
			end

			if remainder > 0.999 then
				return math.ceil(prev)
			end
		end

		return prev
	end

	function motion.interp(a, b, t, easing_fn)
		easing_fn = easing_fn or linear

		if type(b) == 'boolean' then
			b = b and 1 or 0
		end

		return solve(easing_fn, a, b, get_deltatime(), t)
	end

	function motion.lerp(a, b, t)
		return (b - a) * t + a
	end

	function motion.lerp_color(r1, g1, b1, a1, r2, g2, b2, a2, t)
		local r = motion.lerp(r1, r2, t)
		local g = motion.lerp(g1, g2, t)
		local b = motion.lerp(b1, b2, t)
		local a = motion.lerp(a1, a2, t)

		return r, g, b, a
	end

	function motion.normalize_acid(x, min, max)
		local delta = max - min

		while x < min do
			x = x + delta
		end

		while x > max do
			x = x - delta
		end

		return x
	end

	function motion.normalize_yaw_acid(x)
		return motion.normalize_acid(x, -180, 180)
	end

	motion.clamp = function (x, a, b) if a > x then return a elseif b < x then return b else return x end end
    motion.normalize_yaw = function (yaw) return (yaw + 180) % -360 + 180 end
    motion.normalize_pitch = function (pitch) return motion.clamp(pitch, -89, 89) end

	function motion.animation(name, value, speed)
		return name + (value - name) * globals.frametime() * speed
	end

	function motion.logs()
		local offset, x, y = 0, 8, -9
		for idx, data in ipairs(lua) do
			if globals.curtime() - data[3] < 5 and not (#lua > 7 and idx < #lua - 7) then
				data[2] = motion.animation(data[2], 255, 4)
			else
				data[2] = motion.animation(data[2], 0, 4)
			end
	
	 
			offset = offset - 16 * (data[2] / 255)
			local text_log = data[5] and data[1] or data[1]


			local text_sizex, text_sizey = render.measure_text('', text_log)

			if data[4] then
			--	render.shadow(vector(x, y - offset + text_size.y / 2 + 0.5), vector(x + text_size.x * (data[2] / 255), y - offset + text_size.y / 2 - 0.5), color(gui.menu.colorlogs:get().r, gui.menu.colorlogs:get().g, gui.menu.colorlogs:get().b, (data[2] / 255) * 100), 15, 0, 4)
			end

			render.text(x, y - offset, 255, 255, 255, 255 * (data[2] / 255), '', math.floor(2.5 + text_sizex * (data[2] / 255)), text_log)

			if data[7] then
				if data[4] then
				--	render.shadow(vector(x + g_ctx.screen.x / 2 - text_size.x / 2, y + g_ctx.screen.y - 300 - offset + text_size.y / 2 + 0.5), vector(x + g_ctx.screen.x / 2 - text_size.x / 2 + text_size.x * (data[2] / 255), y + g_ctx.screen.y - 300 - offset + text_size.y / 2 - 0.5), color(gui.menu.colorlogs:get().r, gui.menu.colorlogs:get().g, gui.menu.colorlogs:get().b, (data[2] / 255) * 100), 15, 0, 4)
				end
		
				render.text(x + g_ctx.screen[1] / 2 - text_sizex / 2, y + g_ctx.screen[2] - 300 - offset, 255, 255, 255, 255 * (data[2] / 255), '', nil, string.sub(text_log, 1, 3 + #text_log * (data[2] / 255)))
			end
			
			if data[2] < .1 then table.remove(lua, idx) end
		end
	end
	
	function motion.push(text, shadow, icon, font, center)
		table.insert(lua, { text, 0, globals.curtime(), shadow, icon, font, center })
	end
end

local _DEBUGFEATURESENABLE = 0

do
	function gui.init()
		gui.menu = {}
		gui.aa = 'aa'
		gui.ab = 'anti-aimbot angles'
		gui.abc = 'fake lag'
		gui.abcd = 'other'

		gui.menu.lua = ui.new_combobox(gui.aa, gui.abc, cold, 'rage', 'anti-aim', 'visuals', 'misc')
		gui.thirdperson = ui.new_slider(gui.aa,gui.ab, 'thirdperson distance', 30, 300, 70)
		gui.aspectratio = ui.new_slider(gui.aa,gui.ab, 'aspect ratio', .0, 30, .0, true, nil, .1)
		gui.menu.miscellaneous = ui.new_combobox(gui.aa, gui.abc, 'miscellaneous', 'main', 'other')

		gui.menu.airanim = ui.new_combobox(gui.aa, gui.abc, 'air animations', 'off', 'walking', 'static', 'jitter')
		gui.menu.groundanim = ui.new_combobox(gui.aa, gui.abc, 'ground animations', 'off', 'walking', 'static', 'jitter')
		-- @lordmouse: мне лень потом как нить доделаю я хз или сами сделаете
		gui.menu.config_list = ui.new_listbox(gui.aa, gui.abcd, 'config list', '\n', false)
		gui.menu.config_name = ui.new_textbox(gui.aa, gui.abcd, 'config name')
		gui.menu.config_create = ui.new_button(gui.aa, gui.abcd, 'create', function() end)
		gui.menu.config_save = ui.new_button(gui.aa, gui.abcd, 'save', function() end)
		gui.menu.config_load = ui.new_button(gui.aa, gui.abcd, 'load', function() end)
		gui.menu.config_delete = ui.new_button(gui.aa, gui.abcd, 'delete', function() end)
	end

		local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')
		local char_ptr = ffi.typeof('char*')
		local nullptr = ffi.new('void*')
		local class_ptr = ffi.typeof('void***')
		local animation_layer_t = ffi.typeof([[
		struct {										char pad0[0x18];
			uint32_t	sequence;
			float		prev_cycle;
			float		weight;
			float		weight_delta_rate;
			float		playback_rate;
			float		cycle;
			void		*entity;				char pad1[0x4];
		} **
		]])
	
		def.gui = {
			hide_aa_tab = function(boolean)
				ui.set_visible(software.antiaim.angles.enabled, not boolean)
				ui.set_visible(software.antiaim.angles.pitch[1], not boolean)
				ui.set_visible(software.antiaim.angles.pitch[2], not boolean)
				ui.set_visible(software.antiaim.angles.roll, not boolean)
				ui.set_visible(software.antiaim.angles.yaw_base, not boolean)
				ui.set_visible(software.antiaim.angles.yaw[1], not boolean)
				ui.set_visible(software.antiaim.angles.yaw[2], not boolean)
				ui.set_visible(software.antiaim.angles.yaw_jitter[1], not boolean)
				ui.set_visible(software.antiaim.angles.yaw_jitter[2], not boolean)
				ui.set_visible(software.antiaim.angles.body_yaw[1], not boolean)
				ui.set_visible(software.antiaim.angles.body_yaw[2], not boolean)
				ui.set_visible(software.antiaim.angles.freestanding[1], not boolean)
				ui.set_visible(software.antiaim.angles.freestanding[2], not boolean)
				ui.set_visible(software.antiaim.angles.freestanding_body_yaw, not boolean)
				ui.set_visible(software.antiaim.angles.edge_yaw, not boolean)
				ui.set_visible(software.antiaim.fakelag.on[1], not boolean)
				ui.set_visible(software.antiaim.fakelag.on[2], not boolean)
				ui.set_visible(software.antiaim.fakelag.variance, not boolean)
				ui.set_visible(software.antiaim.fakelag.amount, not boolean)
				ui.set_visible(software.antiaim.fakelag.limit, not boolean)
				ui.set_visible(software.rage.binds.on_shot_anti_aim[1], not boolean)	
				ui.set_visible(software.rage.binds.on_shot_anti_aim[2], not boolean)
				ui.set_visible(software.antiaim.other.slow_motion[1], not boolean)
				ui.set_visible(software.antiaim.other.slow_motion[2], not boolean)
				ui.set_visible(software.antiaim.other.fake_peek[1], not boolean)
				ui.set_visible(software.antiaim.other.fake_peek[2], not boolean)
				ui.set_visible(software.antiaim.other.leg_movement, not boolean)
			end,
			anim = function()
				local player_ptr = ffi.cast(class_ptr, native_GetClientEntity(g_ctx.lp))
				if player_ptr == nullptr then
					return
				end
	
				local airfl = ui.get(gui.menu.airanim)
				local grfl = ui.get(gui.menu.groundanim)
	
				local realtime6 = globals.realtime() / 2 % 1
				local nolag6 = realtime6
			
				local anim_layers = ffi.cast(animation_layer_t, ffi.cast(char_ptr, player_ptr) + 0x2990)[0]
		
				if g_ctx.grtck then
					if grfl == 'walking' then
						entity.set_prop(g_ctx.lp, 'm_flPoseParameter', 1, 7)
					elseif grfl == 'static' then
						entity.set_prop(g_ctx.lp, 'm_flPoseParameter', 1, 0)
					elseif grfl == 'jitter' then
						entity.set_prop(g_ctx.lp, 'm_flPoseParameter', events.random_float(0.0, 1.0), 7)
					end
				else
					if airfl == 'walking' then
						anim_layers[6]['weight'] = 1
						anim_layers[6]['cycle'] = nolag6
					elseif airfl == 'static' then
						entity.set_prop(g_ctx.lp, 'm_flPoseParameter', 1, 6)
					elseif airfl == 'jitter' then
						entity.set_prop(g_ctx.lp, 'm_flPoseParameter', events.random_float(0.0, 1.0), 6)
					end
				end
	
			end,
			hex_label = function(self, rgb)
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
			end,
			text = function(color1, color11, color111, color1111, color2, color22, color222, color2222, text, speed)
				local r1, g1, b1, a1 = color1, color11, color111, color1111
				local r2, g2, b2, a2 = color2, color22, color222, color2222
				local highlight_fraction =  (globals.realtime() / 2 % 1.2 * speed) - 1.2
				local output = ''
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
			end,
		}

		function gui.shut()
			def.gui.hide_aa_tab(false)
		end

		function gui.render()
			local luatabrage = ui.get(gui.menu.lua) == 'rage'
			local luatabaa = ui.get(gui.menu.lua) == 'anti-aim'
			local luatabvis = ui.get(gui.menu.lua) == 'visuals'
			local luatabmisc = ui.get(gui.menu.lua) == 'misc'
			local manul = ui.get(gui.indicators.manual2arrows)

			ui.set_visible(gui.corrections.fix_defensive, luatabrage)
			ui.set_visible(gui.menu.miscellaneous, luatabaa)
			ui.set_visible(gui.indicators.manual2arrows, luatabvis)
			ui.set_visible(gui.indicators.maincolor, luatabvis)
			ui.set_visible(gui.indicators.backcolor, luatabvis)
			ui.set_visible(gui.indicators.maincolorl, luatabvis)
			ui.set_visible(gui.indicators.backcolorl, luatabvis)
			ui.set_visible(gui.indicators.ind, luatabvis)
			ui.set_visible(gui.indicators.ind_style, luatabvis and ui.get(gui.indicators.ind))
			ui.set_visible(gui.indicators.logs, luatabvis)
			ui.set_visible(gui.indicators.logs_select, luatabvis and ui.get(gui.indicators.logs))
			ui.set_visible(gui.thirdperson, luatabmisc)
			ui.set_visible(gui.aspectratio, luatabmisc)
			ui.set_visible(gui.menu.airanim, luatabmisc)
			ui.set_visible(gui.menu.groundanim, luatabmisc)
			ui.set_visible(gui.menu.config_list, luatabmisc)
			ui.set_visible(gui.menu.config_name, luatabmisc)
			ui.set_visible(gui.menu.config_create, luatabmisc)
			ui.set_visible(gui.menu.config_save, luatabmisc)
			ui.set_visible(gui.menu.config_load, luatabmisc)
			ui.set_visible(gui.menu.config_delete, luatabmisc)
		end

		function gui.animbuilder()
			if not entity.is_alive(g_ctx.lp) then
				return
			end
			def.gui:anim()
		end
end

do 
	function g_ctx.render()
		g_ctx.lp = entity.get_local_player()
		g_ctx.screen = {events.screen_size()}
	end
end

do
	body = function(animstate)
		local yaw = animstate.eye_angles_y - animstate.goal_feet_yaw
		yaw = motion.normalize_yaw_acid(yaw)
		return yaw
	end

	def.values = {
		cmd = 0,
		check = 0,
		defensive = 0,
		flags = 0,
        packets = 0,
		body = 0,
		choking = 0,
		spin = 0,
		choking_bool = false,
		run = function(cmd)
			def.values.cmd = cmd.command_number
			def.values.choking = 1
			def.values.choking_bool = false
		end,
		predict = function(cmd)
			if cmd.command_number == def.values.cmd then
				local tickbase = entity.get_prop(entity.get_local_player(), 'm_nTickBase')
				def.values.defensive = math.abs(tickbase - def.values.check)
				def.values.check = math.max(tickbase, def.values.check or 0)
				def.values.cmd = 0
			end
		end,
		net = function(cmd)
			if g_ctx.lp == nil then return end
			local my_data = entitys(g_ctx.lp)
            if my_data == nil then return end

            local animstate = entitys.get_anim_state(my_data)
            if animstate == nil then return end

			local chokedcommands = globals.chokedcommands()
            if chokedcommands == 0 then
                def.values.packets = def.values.packets + 1
                def.values.choking = def.values.choking * -1
                def.values.choking_bool = not def.values.choking_bool
				def.values.body = body(animstate)
            end
		end
	}
end

do
	local ctx = {}

	function builder.init()
		ctx.onground = false
		ctx.ticks = -1
		ctx.state = 'shared'
		ctx.condition_names = {'shared', 'manual left', 'manual right', 'stand', 'moving', 'slow moving', 'duck', 'duck moving', 'air', 'air duck'}
		
		gui.conditions = {}
		gui.conditions.state = ui.new_combobox(gui.aa, gui.ab, 'state', 'shared', 'manual left', 'manual right', 'stand', 'moving', 'slow moving', 'duck', 'duck moving', 'air', 'air duck')
		gui.conditions.mode = ui.new_combobox(gui.aa, gui.ab, 'condition', 'default', 'defensive')
		
		gui.spinwhendead = ui.new_checkbox(gui.aa,gui.ab, 'spin when enemies dead')
		gui.fl_amount = ui.new_combobox(gui.aa, gui.abc, 'amount', 'dynamic', 'maximum', 'fluctuate')
		gui.fl_variance = ui.new_slider(gui.aa, gui.abc, 'variance', 0, 100, 0, "", "%")
		gui.fl_limit = ui.new_slider(gui.aa, gui.abc, 'limit', 1, 15, 0, "", "t")
		gui.fl_break = ui.new_slider(gui.aa, gui.abc, 'break', 0, 15, 0, "", "t")
		gui.ot_leg = ui.new_combobox(gui.aa, gui.abcd, 'leg movement', 'off', 'never slide', 'always slide')
		gui.manual_left = ui.new_hotkey(gui.aa, gui.ab, 'manual left')
		gui.manual_right = ui.new_hotkey(gui.aa, gui.ab, 'manual right')
		gui.freestand = ui.new_hotkey(gui.aa, gui.ab, 'freestand')
		gui.hideshots = ui.new_hotkey(gui.aa, gui.ab, 'hideshots')
		gui.defensive_disabler = ui.new_hotkey(gui.aa, gui.ab, 'disable defensive aa')
		gui.export = ui.new_button(gui.aa, gui.ab, 'export config anti-aim', function() def.antiaim:export_cfg() end)
		gui.import = ui.new_button(gui.aa, gui.ab, 'import config anti-aim', function() def.antiaim:import_cfg() end)
		gui.default = ui.new_button(gui.aa, gui.ab, 'default config anti-aim', function() def.antiaim:default_cfg() end)

		for i, name in pairs(ctx.condition_names) do
			gui.state = '\a00000000'..name..''
			gui.defensive = 'defensive'
			gui.conditions[name] = {
				override = ui.new_checkbox(gui.aa,gui.ab, 'override '..name),
				pitch = ui.new_slider(gui.aa,gui.ab, 'pitch', -89, 89, 0),
				yaw_base = ui.new_combobox(gui.aa,gui.ab, 'yaw base'..gui.state, 'local view', 'at targets'),
				yaw = ui.new_combobox(gui.aa,gui.ab, 'yaw'..gui.state, 'off', '180'),
				yaw_valueoffset = ui.new_slider(gui.aa,gui.ab, 'yaw offset'..gui.state, -180, 180, 0),
				yawmod = ui.new_combobox(gui.aa,gui.ab, 'yaw modifier'..gui.state, 'off', 'center', 'offset', 'original', 'hidden'),
				yaw_modifierdel = ui.new_slider(gui.aa,gui.ab, 'yaw modifier delay'..gui.state, 1, 10, 2),
				yaw_modifieroffset = ui.new_slider(gui.aa,gui.ab, 'yaw modifier offset'..gui.state, -180, 180, 0),
				yaw_valueovon = ui.new_checkbox(gui.aa,gui.ab, 'left / right offset'..gui.state),
				yaw_valuel = ui.new_slider(gui.aa,gui.ab, 'yaw offset left'..gui.state, -180, 180, 0),
				yaw_valuer = ui.new_slider(gui.aa,gui.ab, 'yaw offset right'..gui.state, -180, 180, 0),
				body_yaw = ui.new_combobox(gui.aa,gui.abcd, 'body yaw'..gui.state, 'off', 'static', 'process'),
				body_yaw_sw = ui.new_hotkey(gui.aa, gui.abcd, 'body invert'..gui.state),
				body_yaw_del = ui.new_slider(gui.aa,gui.abcd, 'body yaw tick'..gui.state, 1, 10, 2),
				defensive_on = ui.new_checkbox(gui.aa,gui.ab, gui.defensive..' always on'..gui.state),
				defensive_aa_on = ui.new_checkbox(gui.aa,gui.ab, gui.defensive..' enable'..gui.state),
				info_defensive = ui.new_label(gui.aa,gui.ab, 'override '..name),
				trigger1 = ui.new_slider(gui.aa,gui.abc, gui.defensive..' - trigger'..gui.state, 1, 16, 3),
				trigger2 = ui.new_slider(gui.aa,gui.abc, gui.defensive..' + trigger'..gui.state, 1, 16, 11),
				defensive_pitch = ui.new_slider(gui.aa,gui.ab, gui.defensive..' pitch'..gui.state, -89, 89, 0),
				defensive_rdom = ui.new_checkbox(gui.aa,gui.ab, gui.defensive..' pitch randomize'..gui.state),
				defensive_yaw_base = ui.new_combobox(gui.aa,gui.ab, gui.defensive..' yaw base'..gui.state, 'local view', 'at targets'),
				defensive_yaw = ui.new_combobox(gui.aa,gui.ab, gui.defensive..' yaw'..gui.state, 'off', '180', 'spin', 'static', '180 z', 'crosshair'),
				defensive_yawmod = ui.new_combobox(gui.aa,gui.ab,  gui.defensive..' yaw modifier'..gui.state, 'off', 'center', 'offset', 'original', 'hidden'),
				defensive_yaw_modifierdel = ui.new_slider(gui.aa,gui.ab, gui.defensive..' yaw modifier delay'..gui.state, 1, 10, 2),
				defensive_yaw_modifieroffset = ui.new_slider(gui.aa,gui.ab, gui.defensive..' yaw modifier offset'..gui.state, -180, 180, 0),
				defensive_yaw_valueoffset = ui.new_slider(gui.aa,gui.ab, gui.defensive..' yaw offset'..gui.state, -180, 180, 0),
				defensive_yaw_valueovon = ui.new_checkbox(gui.aa,gui.ab, gui.defensive..' left / right offset'..gui.state),
				defensive_yaw_valuel = ui.new_slider(gui.aa,gui.ab, gui.defensive..' yaw offset left'..gui.state, -180, 180, 0),
				defensive_yaw_valuer = ui.new_slider(gui.aa,gui.ab, gui.defensive..' yaw offset right'..gui.state, -180, 180, 0),
				defensive_body_yaw = ui.new_combobox(gui.aa,gui.abcd, gui.defensive..' body yaw'..gui.state, 'off', 'static', 'process'),
				defensive_body_yaw_sw = ui.new_hotkey(gui.aa, gui.abcd, gui.defensive..' body invert'..gui.state),
				defensive_body_yaw_del = ui.new_slider(gui.aa,gui.abcd, gui.defensive..' body yaw tick'..gui.state, 1, 10, 2),
			}
		end
	end

	function builder.render() 
		local selected_state = ui.get(gui.conditions.state) 
		local luatabaacfg = ui.get(gui.menu.lua) == 'anti-aim' and ui.get(gui.menu.miscellaneous) == 'other'
		local luatabaa = ui.get(gui.menu.lua) == 'anti-aim' and ui.get(gui.menu.miscellaneous) == 'main'
		local luatabaafl = ui.get(gui.menu.lua) == 'anti-aim' and ui.get(gui.menu.miscellaneous) == 'other'
		local luatabaaot = ui.get(gui.menu.lua) == 'anti-aim' and ui.get(gui.menu.miscellaneous) == 'other'
		local tab = ui.get(gui.conditions.mode) == 'defensive'

		ui.set_visible(gui.fl_amount, luatabaafl)
		ui.set_visible(gui.fl_break, luatabaafl)
		ui.set_visible(gui.fl_variance, luatabaafl)
		ui.set_visible(gui.fl_limit, luatabaafl)
		ui.set_visible(gui.ot_leg, luatabaaot)
		ui.set_visible(gui.manual_left, luatabaaot)
		ui.set_visible(gui.manual_right, luatabaaot)
		ui.set_visible(gui.freestand, luatabaaot)
		ui.set_visible(gui.hideshots, luatabaaot)
		ui.set_visible(gui.defensive_disabler, luatabaaot)
		ui.set_visible(gui.export, luatabaacfg)
		ui.set_visible(gui.import, luatabaacfg)
		ui.set_visible(gui.default, luatabaacfg)
		ui.set_visible(gui.spinwhendead, luatabaaot)

		for i, name in pairs(ctx.condition_names) do
			local enabled = name == selected_state

			local dchk = ui.get(gui.conditions[name].defensive_aa_on)
			local ik = ui.get(gui.conditions[name].body_yaw) == 'process'
			local ik2 = ui.get(gui.conditions[name].defensive_body_yaw) == 'process'	
			ui.set_visible(gui.conditions[name].override, enabled and i > 1 and luatabaa and not tab)
			ui.set_visible(gui.conditions.state, luatabaa)
			ui.set_visible(gui.conditions.mode, luatabaa)

			local overriden = i == 1 or ui.get(gui.conditions[name].override)

			def.gui.hide_aa_tab(true)
			ui.set_visible(gui.conditions[name].pitch, enabled and overriden and luatabaa and not tab)
			ui.set_visible(gui.conditions[name].yaw_base, enabled and overriden and luatabaa and not tab)
			ui.set_visible(gui.conditions[name].yaw, enabled and overriden and luatabaa and not tab)
			ui.set_visible(gui.conditions[name].yawmod, enabled and overriden and luatabaa and not tab)
			ui.set_visible(gui.conditions[name].yaw_modifierdel, enabled and overriden and luatabaa and not tab  and ui.get(gui.conditions[name].yawmod) ~= 'off' and ui.get(gui.conditions[name].yawmod) ~= 'hidden')
			ui.set_visible(gui.conditions[name].yaw_modifieroffset, enabled and overriden and luatabaa and not tab and ui.get(gui.conditions[name].yawmod) ~= 'off' and ui.get(gui.conditions[name].yawmod) ~= 'hidden')
			ui.set_visible(gui.conditions[name].yaw_valueoffset, enabled and overriden and luatabaa and not tab)
			ui.set_visible(gui.conditions[name].yaw_valueovon, enabled and overriden and luatabaa and not tab)
			ui.set_visible(gui.conditions[name].yaw_valuel, enabled and overriden and luatabaa and not tab and ui.get(gui.conditions[name].yaw_valueovon))
			ui.set_visible(gui.conditions[name].yaw_valuer, enabled and overriden and luatabaa and not tab and ui.get(gui.conditions[name].yaw_valueovon))		
			ui.set_visible(gui.conditions[name].body_yaw, enabled and overriden and luatabaa and not tab)
			ui.set_visible(gui.conditions[name].body_yaw_sw, enabled and overriden and luatabaa and not ik and ui.get(gui.conditions[name].body_yaw) == 'static' and not tab)
			ui.set_visible(gui.conditions[name].body_yaw_del, enabled and overriden and luatabaa and ik and not tab)
			ui.set_visible(gui.conditions[name].defensive_on, enabled and overriden and luatabaa and tab)
			ui.set_visible(gui.conditions[name].defensive_aa_on, enabled and overriden and luatabaa and tab)
			ui.set_visible(gui.conditions[name].info_defensive, enabled and not overriden and luatabaa and tab)
			ui.set_visible(gui.conditions[name].trigger1, enabled and overriden and luatabaa and dchk and tab)
			ui.set_visible(gui.conditions[name].trigger2, enabled and overriden and luatabaa and dchk and tab)
			ui.set_visible(gui.conditions[name].defensive_pitch, enabled and overriden and luatabaa and dchk and tab)
			ui.set_visible(gui.conditions[name].defensive_rdom, enabled and overriden and luatabaa and dchk and tab)
			ui.set_visible(gui.conditions[name].defensive_yaw_base, enabled and overriden and luatabaa and dchk and tab)
			ui.set_visible(gui.conditions[name].defensive_yaw, enabled and overriden and luatabaa and dchk and tab)
			ui.set_visible(gui.conditions[name].defensive_yawmod, enabled and overriden and luatabaa and dchk and tab)
			ui.set_visible(gui.conditions[name].defensive_yaw_modifierdel, enabled and overriden and luatabaa and dchk and tab and ui.get(gui.conditions[name].defensive_yawmod) ~= 'off' and ui.get(gui.conditions[name].defensive_yawmod) ~= 'hidden')
			ui.set_visible(gui.conditions[name].defensive_yaw_modifieroffset, enabled and overriden and luatabaa and dchk and tab and ui.get(gui.conditions[name].defensive_yawmod) ~= 'off' and ui.get(gui.conditions[name].defensive_yawmod) ~= 'hidden')	
			ui.set_visible(gui.conditions[name].defensive_yaw_valueoffset, enabled and overriden and luatabaa and dchk and tab)
			ui.set_visible(gui.conditions[name].defensive_yaw_valueovon, enabled and overriden and luatabaa and dchk and tab)
			ui.set_visible(gui.conditions[name].defensive_yaw_valuel, enabled and overriden and luatabaa and dchk and tab and ui.get(gui.conditions[name].defensive_yaw_valueovon))
			ui.set_visible(gui.conditions[name].defensive_yaw_valuer, enabled and overriden and luatabaa and dchk and tab and ui.get(gui.conditions[name].defensive_yaw_valueovon))
			ui.set_visible(gui.conditions[name].defensive_body_yaw, enabled and overriden and luatabaa and dchk and tab)
			ui.set_visible(gui.conditions[name].defensive_body_yaw_sw, enabled and overriden and luatabaa and dchk and not ik2 and ui.get(gui.conditions[name].defensive_body_yaw) == 'static' and tab)
			ui.set_visible(gui.conditions[name].defensive_body_yaw_del, enabled and overriden and luatabaa and dchk and ik2 and tab)
		end
	end

	def.antistab = {
		is_active = false,
		backstab = 220 * 220,
		get_enemies_with_knife = function()
			local enemies = entity.get_players(true)
			if next(enemies) == nil then
				return { }
			end
			local list = { }

			for i = 1, #enemies do
				local enemy = enemies[i]
				local wpn = entity.get_player_weapon(enemy)
	
				if wpn == nil then
					goto continue
				end
	
				local wpn_class = entity.get_classname(wpn)
	
				if wpn_class == 'CKnife' then
					list[#list + 1] = enemy
				end
	
				::continue::
			end
	
			return list
		end,
        get_closest_target = function(me)
			local targets, deadz = def.antistab.get_enemies_with_knife()
			if next(targets) == nil then return end
	
			local best_delta
			local best_target
	
			local my_origin = vector(entity.get_origin(me))
			local best_distance = def.antistab.backstab
	
			for i = 1, #targets do
				local target = targets[i]
	
				local origin = vector(entity.get_origin(target))
				local delta = origin - my_origin
	
				local distance = delta:lengthsqr()
	
				if distance < best_distance then
					best_delta = delta
					best_target = target
	
					best_distance = distance
				end
			end
	
			return best_distance, best_delta
		end,
	}

	get_state = function()
		if not entity.is_alive(g_ctx.lp) then
			return 'shared'
		end

		local first_velocity, second_velocity = entity.get_prop(g_ctx.lp, 'm_vecVelocity')
		local speed = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))

		if g_ctx.selected_manual == 1 then
			return 'manual left'
		end

		if g_ctx.selected_manual == 2 then
			return 'manual right'
		end

		if entity.get_prop(g_ctx.lp, 'm_hGroundEntity') == 0 then
			ctx.ticks = ctx.ticks + 1
		else
			ctx.ticks = 0
		end

		g_ctx.grtck = ctx.onground
		
		ctx.onground = ctx.ticks > 32
		
		if not ctx.onground then
			if entity.get_prop(g_ctx.lp, 'm_flDuckAmount') == 1 then
				return 'air duck'
			end
	
			return 'air'
		end
		
		if entity.get_prop(g_ctx.lp, 'm_flDuckAmount') == 1 or ui.get(software.antiaim.other.fakeduck) then
			if speed > 5 then
				return 'duck moving'
			end
	
			return 'duck'
		end
	
		if speed > 5 then
			if ui.get(software.antiaim.other.slide[2]) then
				return 'slow moving'
			end

			return 'moving'
		end
	
		return 'stand'
	end

	def.antiaim = {
		brute = 0,
		brute_end = 0,
		off_while = function()
			if not ui.get(gui.spinwhendead) then
				return
			end

            local alive = 0

            for i = 1, globals.maxplayers() do
                if entity.get_classname(i) ~= 'CCSPlayer' then
                    goto skip
                end

                if not entity.is_alive(i) or not entity.is_enemy(i) then
                    goto skip
                end

                alive = alive + 1
                ::skip::
            end

            return alive
		end,
		enable = function(cmd)
			--cmd.discharge_pending = false
			cmd.allow_send_packet = false
			ui.set(software.antiaim.angles.enabled, true)
			ui.set(software.antiaim.angles.edge_yaw, false)
		end,
		check = function(state, defensive_aa, default_aa)
			if def.values.defensive > ui.get(gui.conditions[state].trigger1) and def.values.defensive < ui.get(gui.conditions[state].trigger2) and ui.get(gui.conditions[state].defensive_aa_on) then
				return defensive_aa
			end

			if not ui.get(software.rage.binds.double_tap[2]) then
				return default_aa
			end

			if not ui.get(software.rage.binds.on_shot_anti_aim[2]) then
				return default_aa
			end
			
			return default_aa
		end,
		hideshot = function()
			ui.set(software.rage.binds.on_shot_anti_aim[2], 'always on')
			ui.set(software.rage.binds.on_shot_anti_aim[1], ui.get(gui.hideshots))
		end,
		manual = function()
			ui.set(gui.manual_left, 'On hotkey')
			ui.set(gui.manual_right, 'On hotkey')
	
			if g_ctx.selected_manual == nil then
				g_ctx.selected_manual = 0
			end
		
			local left_pressed = ui.get(gui.manual_left)
			if left_pressed and not g_ctx.left_pressed then
				if g_ctx.selected_manual == 1 then
					g_ctx.selected_manual = 0
				else
					g_ctx.selected_manual = 1
				end
			end
		
			local right_pressed = ui.get(gui.manual_right)
			if right_pressed and not g_ctx.right_pressed then
				if g_ctx.selected_manual == 2 then
					g_ctx.selected_manual = 0
				else
					g_ctx.selected_manual = 2
				end
			end
			
			g_ctx.left_pressed = left_pressed
			g_ctx.right_pressed = right_pressed
		end,
		freestand = function()
			local fs = ui.get(gui.freestand)
			if g_ctx.selected_manual ~= 0 then
				fs = false
			end

			ui.set(software.antiaim.angles.freestanding[2], 'always on')
			ui.set(software.antiaim.angles.freestanding[1], fs)
		end,
		pitch = function()
			ctx.state = get_state()
			if not ui.get(gui.conditions[ctx.state].override) then
				ctx.state = 'shared'
			end

			local mode = 'custom'
			local pitch = def.antiaim.check(ctx.state, ui.get(gui.conditions[ctx.state].defensive_pitch), ui.get(gui.conditions[ctx.state].pitch))

			if def.antiaim:off_while() == 0 then
				pitch = 0
			elseif ui.get(gui.conditions[ctx.state].defensive_rdom) then
				pitch = def.antiaim.check(ctx.state, events.random_int(events.random_int(-1, 1) * ui.get(gui.conditions[ctx.state].defensive_pitch), events.random_int(-1, 1) * ui.get(gui.conditions[ctx.state].defensive_pitch)), ui.get(gui.conditions[ctx.state].pitch))
			else			
				pitch = def.antiaim.check(ctx.state, ui.get(gui.conditions[ctx.state].defensive_pitch), ui.get(gui.conditions[ctx.state].pitch))
			end

			ui.set(software.antiaim.angles.pitch[1], mode)
			ui.set(software.antiaim.angles.pitch[2], pitch)
		end,
		desync_and_yaw = function(cmd)
			ctx.state = get_state()
			if not ui.get(gui.conditions[ctx.state].override) then
				ctx.state = 'shared'
			end
			local yawl = ui.get(gui.conditions[ctx.state].yaw_valuel)
			local yawr = ui.get(gui.conditions[ctx.state].yaw_valuer)
			local offsetyaw = ui.get(gui.conditions[ctx.state].yaw_valueoffset)
			local delayedzv = ui.get(gui.conditions[ctx.state].body_yaw_del)
			local yoffset = def.antiaim.check(ctx.state, ui.get(gui.conditions[ctx.state].defensive_yaw_valueoffset), offsetyaw)
			local yawmod = def.antiaim.check(ctx.state, ui.get(gui.conditions[ctx.state].defensive_yawmod), ui.get(gui.conditions[ctx.state].yawmod))
			local yawmodofs = def.antiaim.check(ctx.state, ui.get(gui.conditions[ctx.state].defensive_yaw_modifieroffset), ui.get(gui.conditions[ctx.state].yaw_modifieroffset))
			local checklr = def.antiaim.check(ctx.state, ui.get(gui.conditions[ctx.state].defensive_yaw_valueovon), ui.get(gui.conditions[ctx.state].yaw_valueovon))
		    local inverted = def.values.body < 0
			local delayed = def.values.body < 0
			local yaw_value = def.antiaim.check(ctx.state, inverted and ui.get(gui.conditions[ctx.state].defensive_yaw_valuel) or ui.get(gui.conditions[ctx.state].defensive_yaw_valuer), inverted and yawl or yawr)
			if not checklr then
				yaw_value = 0
			end
			local yaw = def.antiaim.check(ctx.state, ui.get(gui.conditions[ctx.state].defensive_yaw), ui.get(gui.conditions[ctx.state].yaw))
			local yaw_base = def.antiaim.check(ctx.state) and ui.get(gui.conditions[ctx.state].defensive_yaw_base) or ui.get(gui.conditions[ctx.state].yaw_base)
			local distance, delta = def.antistab.get_closest_target(g_ctx.lp)
			local body_yaw_value = def.antiaim.check(ctx.state, ui.get(gui.conditions[ctx.state].defensive_body_yaw_sw), ui.get(gui.conditions[ctx.state].body_yaw_sw)) and -1 or 1
			local body_yaw = def.antiaim.check(ctx.state, ui.get(gui.conditions[ctx.state].defensive_body_yaw), ui.get(gui.conditions[ctx.state].body_yaw))
			local yawmodofs_delay = def.antiaim.check(ctx.state, ui.get(gui.conditions[ctx.state].defensive_yaw_modifierdel), ui.get(gui.conditions[ctx.state].yaw_modifierdel))

			local body_yaw_delay = def.antiaim.check(ctx.state, ui.get(gui.conditions[ctx.state].defensive_body_yaw_del), delayedzv)
			local freestanding_body_yaw = false

			local delays = yawmodofs_delay
			local targetz = delays * 2
			delayed = (def.values.packets % targetz) >= delays
	
			if def.antiaim:off_while() == 0 then
				yaw = 'spin'
				yaw_value = 33
				yawmodofs = 0
				yaw_base = 'local view'
				body_yaw = 'off'
			elseif distance ~= nil and distance < 35000 then
				yaw = '180'
				yaw_value = 180
				yawmodofs = 0
				yaw_base = 'at targets'
				body_yaw = 'static'
			elseif g_ctx.selected_manual == 1 and not ui.get(gui.conditions['manual left'].override) then
				yaw = '180'
				yaw_value = -90
				yawmodofs = 0
				yaw_base = 'local view'
				body_yaw = 'static'
			elseif g_ctx.selected_manual == 2 and not ui.get(gui.conditions['manual right'].override) then
				yaw = '180'
				yaw_value = 90
				yawmodofs = 0
				yaw_base = 'local view'
				body_yaw = 'static'
			elseif ui.get(software.antiaim.angles.freestanding[2]) and ui.get(software.antiaim.angles.freestanding[1]) and ctx.state == 'moving' then
				yaw = '180'
				yaw_value = 0
				yawmodofs = 0
				yaw_base = 'local view'
				body_yaw = 'opposite'
			elseif body_yaw == 'process' then
				local delay = body_yaw_delay
				local target = delay * 2
				inverted = (def.values.packets % target) >= delay
				local val = inverted and 1 or -1

				yaw = def.antiaim.check(ctx.state, ui.get(gui.conditions[ctx.state].defensive_yaw), ui.get(gui.conditions[ctx.state].yaw))
				body_yaw = 'static'
				body_yaw_value = val

				local chokedcommands = globals.chokedcommands()
				if chokedcommands == 0 then
					def.values.spin = def.values.spin + 25
				end
				if def.values.spin > 180 then
					def.values.spin = -180
				end

				if yawmod == 'center' then
					yawmodofs = delayed and yawmodofs or -yawmodofs
				elseif yawmod == 'offset' then
					yawmodofs = delayed and yawmodofs or 0
				elseif yawmod == 'original' then
					yawmodofs = def.values.packets % targetz == 1 and yawmodofs or def.values.packets % targetz == 2 and 0 or -yawmodofs
				elseif yawmod == 'hidden' then
					yawmodofs = def.values.spin
				else
					yawmodofs = 0
				end

				if checklr then
					yaw_value = yawmod == 'hidden' and 0 or def.antiaim.check(ctx.state, inverted and ui.get(gui.conditions[ctx.state].defensive_yaw_valuel) or ui.get(gui.conditions[ctx.state].defensive_yaw_valuer), inverted and yawl or yawr)
				end
			else
				yaw = def.antiaim.check(ctx.state, ui.get(gui.conditions[ctx.state].defensive_yaw), ui.get(gui.conditions[ctx.state].yaw))
				inverted = def.values.body < 0
				if checklr then
					yaw_value = yawmod == 'hidden' and 0 or def.antiaim.check(ctx.state, inverted and ui.get(gui.conditions[ctx.state].defensive_yaw_valuel) or ui.get(gui.conditions[ctx.state].defensive_yaw_valuer), inverted and yawl or yawr)
				end

				local delay = body_yaw_delay
				local target = delay * 2
				inverted = (def.values.packets % target) >= delay
				local val = inverted and 1 or -1

				local chokedcommands = globals.chokedcommands()
				if chokedcommands == 0 then
					def.values.spin = def.values.spin + 25
				end
				if def.values.spin > 180 then
					def.values.spin = -180
				end	

				if yawmod == 'center' then
					yawmodofs = delayed and yawmodofs or -yawmodofs
				elseif yawmod == 'offset' then
					yawmodofs = delayed and yawmodofs or 0
				elseif yawmod == 'original' then
					yawmodofs = def.values.packets % targetz == 1 and -yawmodofs or def.values.packets % targetz == 2 and yawmodofs or 0
				elseif yawmod == 'hidden' then
					yawmodofs = def.values.spin - yoffset - yaw_value
				else
					yawmodofs = 0
				end
			end

			ui.set(software.antiaim.angles.body_yaw[1], body_yaw)
			ui.set(software.antiaim.angles.body_yaw[2], body_yaw_value)
			ui.set(software.antiaim.angles.freestanding_body_yaw, freestanding_body_yaw)
			ui.set(software.antiaim.angles.yaw_base, yaw_base)
			ui.set(software.antiaim.angles.yaw[1], yaw)
			ui.set(software.antiaim.angles.yaw[2], yoffset + yawmodofs + yaw_value)
		end,	
		yaw_jitter = function()
			ui.set(software.antiaim.angles.yaw_jitter[1], 'off')
			ui.set(software.antiaim.angles.yaw_jitter[2], 0)
		end,
		roll = function()
			local roll = 0
			ui.set(software.antiaim.angles.roll, roll)
		end,
		leg_movement = function()
			local leg = ui.get(gui.ot_leg)
			if def.antiaim:off_while() == 0 then
				leg = 'off'
			else			
				leg = ui.get(gui.ot_leg)
			end

			ui.set(software.antiaim.other.leg_movement, leg)
		end,
		fakelag = function()
			ui.set( software.antiaim.fakelag.amount,         ui.get( gui.fl_amount   ))
			ui.set( software.antiaim.fakelag.variance,       ui.get( gui.fl_variance ))
			if ui.get(gui.fl_break) > 0 and not ui.get(software.antiaim.other.fakeduck) then
				ui.set( software.antiaim.fakelag.limit,          events.random_int(ui.get( gui.fl_break    ), ui.get( gui.fl_limit    )))
			else
				ui.set( software.antiaim.fakelag.limit,          ui.get( gui.fl_limit    ))
			end
		end,
		clipboard_export = function(string)
			if string then
				set_clipboard_text(VGUI_System, string, #string)
			end
		end,
		export_cfg = function()
			local settings = {}
			pcall(function()
				for key, value in pairs(gui.conditions) do
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
		
				def.antiaim.clipboard_export(json.stringify(settings))
				print('export to buffer')
				cvar.play:invoke_callback('buttons/light_power_on_switch_01')
			end)
		end,
		import_cfg = function(to_import)
			pcall(function()
				local num_tbl = {}
				local settings = json.parse(clipboard_import())
		
				for key, value in pairs(settings) do
					if type(value) == 'table' then
						for k, v in pairs(value) do
							if type(k) == 'number' then
								table.insert(num_tbl, v)
								ui.set(gui.conditions[key], num_tbl)
							else
								ui.set(gui.conditions[key][k], v)
							end
						end
					else
						ui.set(gui.conditions[key], value)
					end
				end
		
				print('imported from buffer')
				cvar.play:invoke_callback('buttons/light_power_on_switch_01')
			end)
		end,
		default_cfg = function(to_import)
			pcall(function()
				local num_tbl = {}
				local settings = json.parse(default_config)
		
				for key, value in pairs(settings) do
					if type(value) == 'table' then
						for k, v in pairs(value) do
							if type(k) == 'number' then
								table.insert(num_tbl, v)
								ui.set(gui.conditions[key], num_tbl)
							else
								ui.set(gui.conditions[key][k], v)
							end
						end
					else
						ui.set(gui.conditions[key], value)
					end
				end
		
				print('default config applied')
				cvar.play:invoke_callback('buttons/light_power_on_switch_01')
			end)
		end,
		writedfile = function(path, data)
			if not data or type(path) ~= 'string' then
				return
			end
	
			return writefile(path, json.stringify(data))
		end,
		fast_ladder = function(cmd)
			local pitch,yaw = events.camera_angles()
			local move_type = entity.get_prop(g_ctx.lp, 'm_MoveType')
			local weapon = entity.get_player_weapon(g_ctx.lp)
			local throw = entity.get_prop(weapon, 'm_fThrowTime')

			if move_type ~= 9 then
				return
			end

			if weapon == nil then
				return
			end

			if throw ~= nil and throw ~= 0 then
				return
			end	

			if cmd.forwardmove > 0 then
				if cmd.pitch < 45 then
					cmd.pitch = 89
					cmd.in_moveright = 1
					cmd.in_moveleft = 0
					cmd.in_forward = 0
					cmd.in_back = 1

					if cmd.sidemove == 0 then
						cmd.yaw = cmd.yaw + 90
					end

					if cmd.sidemove < 0 then
						cmd.yaw = cmd.yaw + 150
					end

					if cmd.sidemove > 0 then
						cmd.yaw = cmd.yaw + 30
					end
				end
			elseif cmd.forwardmove < 0 then
				cmd.pitch = 89
				cmd.in_moveleft = 1
				cmd.in_moveright = 0
				cmd.in_forward = 1
				cmd.in_back = 0

				if cmd.sidemove == 0 then
					cmd.yaw = cmd.yaw + 90
				end

				if cmd.sidemove > 0 then
					cmd.yaw = cmd.yaw + 150
				end

				if cmd.sidemove < 0 then
					cmd.yaw = cmd.yaw + 30
				end
			end
		end,
		--slide_walk = function()
			--if ui.get(gui.ot_leg) == 'never slide' then
			--	g_ctx.never()
			--elseif ui.get(gui.ot_leg) == 'always slide' then
			--	g_ctx.always()
			--else
			--	g_ctx.never()
			--end
		--end
	}

	function builder.setup_createmove(cmd)
		if not entity.is_alive(g_ctx.lp) then
			return
		end
		def.antiaim:enable(cmd)
		def.antiaim:hideshot()
		def.antiaim:manual()
		def.antiaim:freestand()
		def.antiaim:pitch()
		def.antiaim.desync_and_yaw(cmd)
		def.antiaim:yaw_jitter()
		def.antiaim:roll()
		def.antiaim:leg_movement()
		def.antiaim:fakelag()
		def.antiaim.fast_ladder(cmd)
	end
end

textures = {
	cold = render.load_svg(
		'<svg style="color: white" xmlns="http://www.w3.org/2000/svg" width="512px" height="512px" fill="currentColor" viewBox="0 0 24 24"> <path d="M13.142,.053C6.015-.609,.018,5.008,.015,12h-.015v7c0,.552,.448,1,1,1s1-.448,1-1v-6c0-.552,.448-1,1-1s1,.448,1,1v7.484c0,.296,.126,.582,.353,.771,1.521,1.262,3.354,2.156,5.359,2.531,2.232,.418,4.368,.19,6.288-.497v-2.288c0-.552,.448-1,1-1s1,.448,1,1v2c0,.552,.448,1,1,1s1-.448,1-1V13c0-.552,.448-1,1-1s1,.448,1,1v8c0,.552,.448,1,1,1s1-.448,1-1V12.355C24,6.104,19.367,.632,13.142,.053Zm-4.142,17.947h-1c-1.105,0-2-.895-2-2s.895-2,2-2h1v4Zm-.5-7c-.828,0-1.5-.672-1.5-1.5s.672-1.5,1.5-1.5,1.5,.672,1.5,1.5-.672,1.5-1.5,1.5Zm4.5,7h-2v-4h2v4Zm1-8.5c0-.828,.672-1.5,1.5-1.5s1.5,.672,1.5,1.5-.672,1.5-1.5,1.5-1.5-.672-1.5-1.5Zm2,8.5h-1v-4h1c1.105,0,2,.895,2,2s-.897,2-2,2Z" fill="white"/></svg>', 
		51.2, 51.2),
	star = render.load_svg(
		'<svg style="color: white" xmlns="http://www.w3.org/2000/svg" width="800px" height="800px" fill="currentColor" viewBox="0 0 24 24"> <path d="M11.2691 4.41115C11.5006 3.89177 11.6164 3.63208 11.7776 3.55211C11.9176 3.48263 12.082 3.48263 12.222 3.55211C12.3832 3.63208 12.499 3.89177 12.7305 4.41115L14.5745 8.54808C14.643 8.70162 14.6772 8.77839 14.7302 8.83718C14.777 8.8892 14.8343 8.93081 14.8982 8.95929C14.9705 8.99149 15.0541 9.00031 15.2213 9.01795L19.7256 9.49336C20.2911 9.55304 20.5738 9.58288 20.6997 9.71147C20.809 9.82316 20.8598 9.97956 20.837 10.1342C20.8108 10.3122 20.5996 10.5025 20.1772 10.8832L16.8125 13.9154C16.6877 14.0279 16.6252 14.0842 16.5857 14.1527C16.5507 14.2134 16.5288 14.2807 16.5215 14.3503C16.5132 14.429 16.5306 14.5112 16.5655 14.6757L17.5053 19.1064C17.6233 19.6627 17.6823 19.9408 17.5989 20.1002C17.5264 20.2388 17.3934 20.3354 17.2393 20.3615C17.0619 20.3915 16.8156 20.2495 16.323 19.9654L12.3995 17.7024C12.2539 17.6184 12.1811 17.5765 12.1037 17.56C12.0352 17.5455 11.9644 17.5455 11.8959 17.56C11.8185 17.5765 11.7457 17.6184 11.6001 17.7024L7.67662 19.9654C7.18404 20.2495 6.93775 20.3915 6.76034 20.3615C6.60623 20.3354 6.47319 20.2388 6.40075 20.1002C6.31736 19.9408 6.37635 19.6627 6.49434 19.1064L7.4341 14.6757C7.46898 14.5112 7.48642 14.429 7.47814 14.3503C7.47081 14.2807 7.44894 14.2134 7.41394 14.1527C7.37439 14.0842 7.31195 14.0279 7.18708 13.9154L3.82246 10.8832C3.40005 10.5025 3.18884 10.3122 3.16258 10.1342C3.13978 9.97956 3.19059 9.82316 3.29993 9.71147C3.42581 9.58288 3.70856 9.55304 4.27406 9.49336L8.77835 9.01795C8.94553 9.00031 9.02911 8.99149 9.10139 8.95929C9.16534 8.93081 9.2226 8.8892 9.26946 8.83718C9.32241 8.77839 9.35663 8.70162 9.42508 8.54808L11.2691 4.41115Z" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="white"/></svg>', 
		51.2, 51.2)
} do
	local ctx = {}
	local cur_state = 0
	local current_state = 'none'

	local function add_bind(name, ref, gradient_fn, enabled_color, disabled_color)
		enabled_color = {
			[1] = 230,
			[2] = 230,
			[3] = 230,
			[4] = 230,
		}
		disabled_color = {
			[1] = 0,
			[2] = 0,
			[3] = 0,
			[4] = 0,
		}
		ctx.crosshair_indicator.binds[#ctx.crosshair_indicator.binds + 1] = { name = string.sub(name, 1, 2), full_name = name, ref = ref, color = disabled_color, enabled_color = enabled_color, disabled_color = disabled_color, chars = 0, alpha = 0, gradient_progress = 0, gradient_fn = gradient_fn }
	end

	function indicators.init()
		gui.indicators = {}
		
		ctx.anims = {
			a = 0,
			b = 0,
			c = 0,
			d = 0,
			e = 0,
			f = 0,
			g = 0,
			h = 0,
			i = 0,
			j = 0,
			k = 0,
			l = 0,
			m = 0,
			n = 0,
			o = 0,
			p = 0,
			q = 0,
			r = 0,
			s = 0,
			t = 0,
			u = 0,
			v = 0,
			w = 0,
			x = 0,
			y = 0,
			z = 0,
		}

		gui.indicators.ind = ui.new_checkbox(gui.aa,gui.ab,'indicator')
		gui.indicators.ind_style = ui.new_combobox(gui.aa,gui.ab,'\n indicator style', 'small', 'verdana', 'verdana bold')
		gui.indicators.manual2arrows = ui.new_checkbox(gui.aa,gui.ab,'manual arrows')
		gui.indicators.logs = ui.new_checkbox(gui.aa,gui.ab,'logs')
		gui.indicators.logs_select = ui.new_combobox(gui.aa,gui.ab,'\n logs select', 'default', 'renewed')
		gui.indicators.maincolorl = ui.new_label(gui.aa,gui.abcd,'main color')
		gui.indicators.maincolor = ui.new_color_picker(gui.aa,gui.abcd,'main color', 97, 120, 146)
		gui.indicators.backcolorl = ui.new_label(gui.aa,gui.abcd,'back color')
		gui.indicators.backcolor = ui.new_color_picker(gui.aa,gui.abcd,'back color', 55,55,55)

		local white_color =  {215, 215, 215, 255}
		local green_color =  {55, 255, 55, 255}
		local yellow_color = {255, 255, 55, 255}
		local red_color =    {255, 0, 55, 255}

		ctx.crosshair_indicator = {}
		ctx.crosshair_indicator.binds = {}

		add_bind(cold, gui.indicators.ind)
		add_bind('doubletap', software.rage.binds.double_tap[2])
		add_bind('hide', software.rage.binds.on_shot_anti_aim[1])
		add_bind('dmg', software.rage.binds.minimum_damage_override[2])
		add_bind('state', gui.indicators.ind)

		gui.indicator_color = def.gui:hex_label({255,0,55})
		gui.indicator_color2 = def.gui:hex_label({215,215,215})
	end

	add_crosshair_text = function(x, y, r, g, b, a, fl, opt, text, alpha)

		if alpha == nil then
			alpha = 1
		end

		if alpha <= 0 then
			return
		end
		
		local offset = 1
		if ctx.crosshair_indicator.scope > 0 then
			offset = offset - ctx.crosshair_indicator.scope
		end
			
		local text_size = render.measure_text(fl, text)
		x = x - text_size * offset / 2 + 5 * ctx.crosshair_indicator.scope
		
		render.text(x, y, r, g, b, a, fl, opt, text)
		
		ctx.crosshair_indicator.y = ctx.crosshair_indicator.y + 12 * alpha
	end

	def.visuals = {
		interlerpfuncs = function()
			backup.visual = {}
			ctx.anims.c = motion.interp(ctx.anims.c, entity.get_prop(g_ctx.lp, 'm_bIsScoped'), 0.1)
			ctx.anims.n = motion.interp(ctx.anims.n, entity.get_prop(g_ctx.lp, 'm_bResumeZoom'), 0.1)
			ctx.anims.d = motion.interp(ctx.anims.d, ui.get(software.visuals.effects.thirdperson[2]), 0.1)
			ctx.anims.e = motion.interp(ctx.anims.e, ui.get(gui.indicators.manual2arrows), 0.1)
			local state = render.measure_text('d', get_state())
			local gnom = get_state()
			local state_all = gnom
			ctx.anims.z = motion.interp(ctx.anims.z, state == cur_state, 0.05)
			ctx.anims.k = motion.interp(ctx.anims.z, ui.get(gui.indicators.ind), 0.01)
			
			backup.visual.state = ctx.anims.z or 1
			backup.visual.ind = ctx.anims.k or 0
			backup.visual.scoped = ctx.anims.c + ctx.anims.n or 0
			backup.visual.thirdperson = ctx.anims.d or 1
			backup.visual.manualenable = ctx.anims.e or ui.get(gui.indicators.manual2arrows) and 1 or 0

			if ctx.anims.z < .1 then
				cur_state = state
				current_state = state_all
			end
		end,
		indicator = function()
			
			ctx.crosshair_indicator.y = 15
			ctx.crosshair_indicator.scope = backup.visual.scoped
	
			for index, bind in ipairs(ctx.crosshair_indicator.binds) do
				local alpha = motion.interp(bind.alpha, ui.get(gui.indicators.ind) and ui.get(bind.ref), 0.07)
				local chars = motion.interp(bind.chars, ui.get(gui.indicators.ind) and ui.get(bind.ref) and backup.visual.ind > .1, 0.07)
				local name = backup.visual.ind > .1 and string.sub(bind.full_name, 1, math.floor(.5 + #bind.full_name * chars)) or bind.full_name
				local n, y, e, w = ui.get(gui.indicators.maincolor)
				local r, g, b, a = motion.lerp_color(bind.disabled_color[1], bind.disabled_color[2], bind.disabled_color[3], bind.disabled_color[4], bind.enabled_color[1], bind.enabled_color[2], bind.enabled_color[3], bind.enabled_color[4], alpha)
				local r12, g12, b12, a12 = ui.get(gui.indicators.backcolor)
				local text = name
				local alphaz = alpha
				local flag = '-'
				if ui.get(gui.indicators.ind_style) == 'verdana' then
					flag = ''
				elseif ui.get(gui.indicators.ind_style) == 'verdana bold' then
					flag = 'b'
				end
				if bind.full_name == cold then
					local aaa = cold .. " recode"
					if ui.get(gui.indicators.ind_style) == 'small' then text = aaa:upper() else text = aaa:lower() end
					alphaz = alpha
					clr = {
						[1] = n,
						[2] = y,
						[3] = e,
						[4] = a,
					}
				elseif bind.full_name == 'state' then
					local state_text = '`'..string.sub(current_state, 1,  math.floor(0.5 + #current_state * backup.visual.state))..'`'
					if ui.get(gui.indicators.ind_style) == 'small' then text = state_text:upper() else text = state_text:lower() end
					alphaz = backup.visual.state
					clr = {
						[1] = 230,
						[2] = 230,
						[3] = 230,
						[4] = a * backup.visual.state,
					}
				else
					if ui.get(gui.indicators.ind_style) == 'small' then text = name:upper() else text = name:lower() end
					alphaz = alpha
					clr = {
						[1] = r,
						[2] = g,
						[3] = b,
						[4] = a,
					}
				end

				add_crosshair_text(g_ctx.screen[1] / 2, g_ctx.screen[2] / 2 + ctx.crosshair_indicator.y, clr[1], clr[2], clr[3], clr[4], flag, 0, text, alphaz)
				
				ctx.crosshair_indicator.binds[index].alpha = alpha
				ctx.crosshair_indicator.binds[index].name = name
				ctx.crosshair_indicator.binds[index].chars = chars
				ctx.crosshair_indicator.binds[index].color = r, g, b, a
			end	
		end,
		manual_arrows = function()
			local bodyyaw = def.values.body < 0
			local r, g, b, a = ui.get(gui.indicators.maincolor)
			local r12, g12, b12, a12 = ui.get(gui.indicators.backcolor)

			local le = render.measure_text('+', '<')
			local re = render.measure_text('+', '>')

			ctx.crosshair_indicator.scope = backup.visual.scoped

			local move = math.sin(globals.realtime() * 2.3) * 9

			render.text(
			g_ctx.selected_manual == 2 and g_ctx.screen[1] / 2 - re / 2 + 55 + move or g_ctx.screen[1] / 2 - re / 2 + 55, 
			g_ctx.screen[2] / 2 - re - 5 - (re / 2 + 5) * ctx.crosshair_indicator.scope, 
			g_ctx.selected_manual == 2 and r or r12, 
			g_ctx.selected_manual == 2 and g or g12, 
			g_ctx.selected_manual == 2 and b or b12, 
			g_ctx.selected_manual == 2 and a * backup.visual.manualenable or a12 * backup.visual.manualenable,
			'+',
			nil,
			'>')
			render.text(
			g_ctx.selected_manual == 1 and g_ctx.screen[1] / 2 - le / 2 - 55 - move or g_ctx.screen[1] / 2 - le / 2 - 55, 
			g_ctx.screen[2] / 2 - le - 5 - (le / 2 + 5) * ctx.crosshair_indicator.scope,
			g_ctx.selected_manual == 1 and r or r12, 
			g_ctx.selected_manual == 1 and g or g12, 
			g_ctx.selected_manual == 1 and b or b12, 
			g_ctx.selected_manual == 1 and a * backup.visual.manualenable or a12 * backup.visual.manualenable,
			'+',
			nil,
			'<')
		end,
		watermark = function()
			local r, g, b, a = ui.get(gui.indicators.maincolor)
			local r12, g12, b12, a12 = ui.get(gui.indicators.backcolor)
			local text_size = render.measure_text('c', cold .. " beta")

			render.texture(textures.cold, g_ctx.screen[1] - text_size / 1.4, g_ctx.screen[2] * 0.002, 51.4, 51.4, r, g, b, 200)
			-- render.text(g_ctx.screen[1] - 100, g_ctx.screen[2] * 0.019, 215, 215, 215, 255, 'c', nil, def.gui.text(r12, g12, b12, a12, r, g, b, a, cold .. " beta", 2.5))
		end
	}

	function indicators.render()
		if not entity.is_alive(g_ctx.lp) then
			return
		end

		def.visuals:interlerpfuncs()
		def.visuals:watermark()
		def.visuals:indicator()
		def.visuals:manual_arrows()
	end
end

do
	local ctx = {}

	function corrections.init()
		gui.corrections = {}
		gui.corrections.fix_defensive = ui.new_checkbox(gui.aa,gui.abc, 'qol defensive')
	end

	def.corr = {
		peeking = function()
			if not entity.is_alive(g_ctx.lp) then
				return
			end
			local enemies = entity.get_players(true)
			if not enemies then
				return false
			end
			local predict_amt = 0.25
			local eye_position = vector(events.eye_position())
			local velocity_prop_local = vector(entity.get_prop(entity.get_local_player(), 'm_vecVelocity'))
			local predicted_eye_position = vector(eye_position.x + velocity_prop_local.x * predict_amt, eye_position.y + velocity_prop_local.y * predict_amt, eye_position.z + velocity_prop_local.z * predict_amt)
			for i = 1, #enemies do
				local player = enemies[i]
				local velocity_prop = vector(entity.get_prop(player, 'm_vecVelocity'))
				local origin = vector(entity.get_prop(player, 'm_vecOrigin'))
				local predicted_origin = vector(origin.x + velocity_prop.x * predict_amt, origin.y + velocity_prop.y * predict_amt, origin.z + velocity_prop.z * predict_amt)
				entity.get_prop(player, 'm_vecOrigin', predicted_origin)
				local head_origin = vector(entity.hitbox_position(player, 0))
				local predicted_head_origin = vector(head_origin.x + velocity_prop.x * predict_amt, head_origin.y + velocity_prop.y * predict_amt, head_origin.z + velocity_prop.z * predict_amt)
				local trace_entity, damage = events.trace_bullet(entity.get_local_player(), predicted_eye_position.x, predicted_eye_position.y, predicted_eye_position.z, predicted_head_origin.x, predicted_head_origin.y, predicted_head_origin.z)
				entity.get_prop( player, 'm_vecOrigin', origin )
				if damage > 0 then
					return true
				end
			end
			return false
	    end,
		fix_defensive = function(cmd)
			ctx.state = get_state()
			if not ui.get(gui.conditions[ctx.state].override) then
				ctx.state = 'shared'
			end
			if not ui.get(software.rage.binds.double_tap[2]) or ui.get(gui.defensive_disabler) then
				return
			end		
			if ui.get(gui.conditions[ctx.state].defensive_on) then
				cmd.force_defensive = true
			elseif def.corr:peeking() and ui.get(gui.corrections.fix_defensive) then
				cmd.force_defensive = true
			else
				cmd.force_defensive = false
			end
		end
	}
	
	local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
	events.set_event_callback("aim_miss", function(e)
		if not ui.get(gui.indicators.logs) then
			return
		end

		local group = hitgroup_names[e.hitgroup + 1] or '?'
		local r, g, b, a = ui.get(gui.indicators.maincolor)

		if ui.get(gui.indicators.logs_select) == 'renewed' then
			ui.set(software.visuals.effects.output, false)
			motion.push(string.format("missed shot at %s's %s due to %s", entity.get_player_name(e.target):lower(), group, e.reason), true, true, true, false)
			print(string.format("missed shot at %s's %s due to %s", entity.get_player_name(e.target):lower(), group, e.reason))
		else
			ui.set(software.visuals.effects.output, true) 
			client.log(string.format(
				"missed shot at %s's %s due to %s",
				entity.get_player_name(e.target):lower(), group, e.reason
			))
		end
	end)

	events.set_event_callback('aim_fire', function(e)
		if not ui.get(gui.indicators.logs) then
			return
		end

		local r, g, b, a = ui.get(gui.indicators.maincolor)
		backtrack = globals.tickcount() - e.tick

		local flags = {
			e.teleported and 'flag=teleported' or '',
			e.interpolated and 'flag=interpolated' or '',
			e.extrapolated and 'flag=extrapolated' or '',
			e.boosted and 'flag=boosted' or '',
			e.high_priority and 'flag=high priority' or ''
		}
	
		local group = hitgroup_names[e.hitgroup + 1] or '?'

		if ui.get(gui.indicators.logs_select) == 'renewed' then
			ui.set(software.visuals.effects.output, false)
			motion.push(string.format("fired at %s's %s for %d damage (%d%%) bt=%dt (%dms) %s", entity.get_player_name(e.target):lower(), group, e.damage,math.floor(e.hit_chance + 0.5), backtrack, client.real_latency(), table.concat(flags)), true, true, true, false)
			print(string.format("fired at %s's %s for %d damage (%d%%) bt=%dt (%dms) %s", entity.get_player_name(e.target):lower(), group, e.damage,math.floor(e.hit_chance + 0.5), backtrack, client.real_latency(), table.concat(flags)))
		else
			ui.set(software.visuals.effects.output, true)
			client.log(string.format(
				"fired at %s's %s for %d damage (%d%%) bt=%dt (%dms) %s",
				entity.get_player_name(e.target):lower(), group, e.damage,
				math.floor(e.hit_chance + 0.5), backtrack,
				client.latency(), table.concat(flags)
			))
		end
	end)

	events.set_event_callback('aim_hit', function(e)
		if not ui.get(gui.indicators.logs) then
			return
		end

		local group = hitgroup_names[e.hitgroup + 1] or '?'

		if ui.get(gui.indicators.logs_select) == 'renewed' then 
			ui.set(software.visuals.effects.output, false)
			motion.push(string.format('hit %s in the %s for %d damage (%d health remaining)', entity.get_player_name(e.target):lower(), group, e.damage, entity.get_prop(e.target, 'm_iHealth')), true, true, true, false)
			print(string.format('hit %s in the %s for %d damage (%d health remaining)', entity.get_player_name(e.target):lower(), group, e.damage, entity.get_prop(e.target, 'm_iHealth')))
		else
			ui.set(software.visuals.effects.output, true)
			client.log(string.format('hit %s in the %s for %d damage (%d health remaining)', entity.get_player_name(e.target):lower(), group, e.damage, entity.get_prop(e.target, 'm_iHealth')))
		end
	end)

	function corrections.createmove(cmd)
		if not entity.is_alive(g_ctx.lp) then
			return
		end
		def.corr.fix_defensive(cmd)
	end
end

do
	function cwar.createmove()
		if entity.is_alive(g_ctx.lp) then
			cvar.cam_idealdist:set_float(ui.get(gui.thirdperson) * backup.visual.thirdperson)
		end

		--ui.set(software.rage.binds.usercmd, 18)
		--cvar.sv_maxusrcmdprocessticks:set_int(18)
		cvar.sv_airaccelerate:set_int(100)
		cvar.r_aspectratio:set_float(ui.get(gui.aspectratio) * 0.1)
	end

	function cwar.shutdown()
		cvar.con_filter_enable:set_int(0)
		cvar.con_filter_text:set_string('')
		--cvar.sv_maxusrcmdprocessticks:set_int(16)
		--ui.set(software.rage.binds.usercmd, 16)
		cvar.sv_airaccelerate:set_int(12)
		cvar.r_aspectratio:set_int(0)
		cvar.cam_idealdist:set_int(100)
	end
end

do
	software.init()
	gui.init()
	builder.init()
	indicators.init()
	corrections.init()
	cvar.con_filter_enable:set_int(1)
	cvar.con_filter_text:set_string("[gamesense] antarctica")

	events.set_event_callback('paint', g_ctx.render)
	events.set_event_callback('paint_ui', motion.logs)
	events.set_event_callback('paint_ui', gui.render)
	events.set_event_callback('paint_ui', indicators.render)
	events.set_event_callback('paint_ui', builder.render)

	events.set_event_callback('run_command', def.values.run)
	events.set_event_callback('setup_command', builder.setup_createmove)
	events.set_event_callback('setup_command', corrections.createmove)
	events.set_event_callback('setup_command', cwar.createmove)
	events.set_event_callback('predict_command', def.values.predict)
	events.set_event_callback('shutdown', gui.shut)
	events.set_event_callback('shutdown', cwar.createmove)
	events.set_event_callback('net_update_end', def.values.net)
	events.set_event_callback('level_init', function() def.values.check, def.values.defensive = 0, 0 end)
	events.set_event_callback('pre_render', gui.animbuilder)
end