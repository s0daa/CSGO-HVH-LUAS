-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local pui = require("gamesense/pui")
local vector = require("vector")
local base64 = require("gamesense/base64")
local clipboard = require("gamesense/clipboard")
local inspect = require("gamesense/inspect")
local weapons = require("gamesense/csgo_weapons")
local entity_lib = require("gamesense/entity")
local anti_aim = require("gamesense/antiaim_funcs")
local trace = require('gamesense/trace')

local native_GetNetChannelInfo = vtable_bind("engine.dll", "VEngineClient014", 78, "void* (__thiscall*)(void* ecx)")
local native_GetLatency = vtable_thunk(9, "float(__thiscall*)(void*, int)")

local global_data_saved_somewhere = [[{"t":{"hideshots":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"jitter","yaw_jitter_add":5,"hold_time":2,"body_yaw_add":-1,"hold_delay":2,"defensive_yaw_mode":"spin","yaw_add":0,"yaw_jitter":"center","yaw_add_r":0,"defensive_pitch_mode":"up","defensive_builder":"default"},"slow walk":{"enable":false,"yaw_base":"local view","options":["~"],"body_yaw":"off","yaw_jitter_add":0,"hold_time":2,"body_yaw_add":0,"hold_delay":2,"defensive_yaw_mode":"spin","yaw_add":0,"yaw_jitter":"off","yaw_add_r":0,"defensive_pitch_mode":"up","defensive_builder":"defensive"},"run":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"hold yaw","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":-1,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":-25,"yaw_jitter":"off","yaw_add_r":28,"defensive_pitch_mode":"zero","defensive_builder":"default"},"duck jump":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","air tick","safe head (lc)","~"],"body_yaw":"hold yaw","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":1,"hold_delay":3,"defensive_yaw_mode":"spin - static","yaw_add":-22,"yaw_jitter":"center","yaw_add_r":25,"defensive_pitch_mode":"ambani","defensive_builder":"default"},"global":{"defensive_builder":"defensive","yaw_base":"at targets","options":["anti-backstab","safe head (lc)","~"],"body_yaw":"jitter","hold_time":2,"yaw_jitter_add":61,"hold_delay":2,"defensive_yaw_mode":"spin - static","yaw_add":0,"yaw_jitter":"center","yaw_add_r":0,"body_yaw_add":0,"defensive_pitch_mode":"ambani"},"duck":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"hold yaw","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":-1,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":-24,"yaw_jitter":"center","yaw_add_r":36,"defensive_pitch_mode":"up","defensive_builder":"default"},"stand":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","force lag","~"],"body_yaw":"hold yaw","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":-180,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":-20,"yaw_jitter":"center","yaw_add_r":20,"defensive_pitch_mode":"ambani","defensive_builder":"default"},"duck move":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"hold yaw","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":0,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":-24,"yaw_jitter":"center","yaw_add_r":36,"defensive_pitch_mode":"ambani","defensive_builder":"defensive"},"jump":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","defensive yaw","~"],"body_yaw":"jitter","yaw_jitter_add":-16,"hold_time":5,"body_yaw_add":1,"hold_delay":4,"defensive_yaw_mode":"spin - static","yaw_add":13,"yaw_jitter":"center","yaw_add_r":13,"defensive_pitch_mode":"ambani","defensive_builder":"defensive"}},"ct":{"hideshots":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"jitter","yaw_jitter_add":5,"hold_time":2,"body_yaw_add":-1,"hold_delay":2,"defensive_yaw_mode":"spin","yaw_add":0,"yaw_jitter":"center","yaw_add_r":0,"defensive_pitch_mode":"up","defensive_builder":"default"},"slow walk":{"enable":true,"yaw_base":"at targets","options":["defensive yaw","safe head (lc)","force lag","~"],"body_yaw":"hold yaw","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":0,"hold_delay":26,"defensive_yaw_mode":"spin","yaw_add":-20,"yaw_jitter":"off","yaw_add_r":20,"defensive_pitch_mode":"ambani","defensive_builder":"defensive"},"run":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"hold yaw","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":-1,"hold_delay":3,"defensive_yaw_mode":"spin - static","yaw_add":-30,"yaw_jitter":"off","yaw_add_r":41,"defensive_pitch_mode":"zero","defensive_builder":"defensive"},"duck jump":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","air tick","safe head (lc)","~"],"body_yaw":"hold yaw","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":-1,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":-18,"yaw_jitter":"off","yaw_add_r":37,"defensive_pitch_mode":"up","defensive_builder":"default"},"global":{"defensive_builder":"defensive","yaw_base":"at targets","options":["anti-backstab","safe head (lc)","~"],"body_yaw":"jitter","hold_time":2,"yaw_jitter_add":61,"hold_delay":2,"defensive_yaw_mode":"spin - static","yaw_add":0,"yaw_jitter":"center","yaw_add_r":0,"body_yaw_add":0,"defensive_pitch_mode":"ambani"},"duck":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"hold yaw","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":-1,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":-31,"yaw_jitter":"center","yaw_add_r":36,"defensive_pitch_mode":"up","defensive_builder":"default"},"stand":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","force lag","~"],"body_yaw":"hold yaw","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":-180,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":-20,"yaw_jitter":"center","yaw_add_r":20,"defensive_pitch_mode":"ambani","defensive_builder":"default"},"duck move":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"hold yaw","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":0,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":-24,"yaw_jitter":"off","yaw_add_r":36,"defensive_pitch_mode":"ambani","defensive_builder":"defensive"},"jump":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"jitter","yaw_jitter_add":-16,"hold_time":5,"body_yaw_add":1,"hold_delay":4,"defensive_yaw_mode":"spin - static","yaw_add":13,"yaw_jitter":"center","yaw_add_r":13,"defensive_pitch_mode":"up","defensive_builder":"default"}}}]]
local global_data_saved_somewhere2 = [[{"t":{"hideshots":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"jitter","yaw_jitter_add":0,"hold_time":2,"body_yaw_add":-1,"hold_delay":2,"defensive_yaw_mode":"spin","yaw_add":0,"yaw_jitter":"center","yaw_add_r":0,"defensive_pitch_mode":"up","defensive_builder":"default"},"slow walk":{"enable":false,"yaw_base":"local view","options":["~"],"body_yaw":"off","yaw_jitter_add":0,"hold_time":2,"body_yaw_add":0,"hold_delay":2,"defensive_yaw_mode":"spin","yaw_add":0,"yaw_jitter":"off","yaw_add_r":0,"defensive_pitch_mode":"up","defensive_builder":"defensive"},"run":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"strong","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":0,"hold_delay":3,"defensive_yaw_mode":"spin - static","yaw_add":45,"yaw_jitter":"off","yaw_add_r":-18,"defensive_pitch_mode":"zero","defensive_builder":"default"},"duck jump":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","air tick","~"],"body_yaw":"strong","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":0,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":45,"yaw_jitter":"off","yaw_add_r":-13,"defensive_pitch_mode":"ambani","defensive_builder":"default"},"global":{"defensive_builder":"defensive","yaw_base":"at targets","options":["safe head (lc)","~"],"body_yaw":"jitter","hold_time":2,"yaw_jitter_add":61,"hold_delay":2,"defensive_yaw_mode":"spin - static","yaw_add":0,"yaw_jitter":"center","yaw_add_r":0,"body_yaw_add":0,"defensive_pitch_mode":"ambani"},"duck":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"jitter","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":-1,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":-25,"yaw_jitter":"off","yaw_add_r":36,"defensive_pitch_mode":"up","defensive_builder":"default"},"stand":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"hold yaw","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":0,"hold_delay":3,"defensive_yaw_mode":"spin - static","yaw_add":-20,"yaw_jitter":"off","yaw_add_r":20,"defensive_pitch_mode":"ambani","defensive_builder":"default"},"duck move":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"strong","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":0,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":44,"yaw_jitter":"off","yaw_add_r":-18,"defensive_pitch_mode":"ambani","defensive_builder":"default"},"jump":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","air tick","~"],"body_yaw":"strong","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":0,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":41,"yaw_jitter":"off","yaw_add_r":-15,"defensive_pitch_mode":"ambani","defensive_builder":"default"}},"ct":{"hideshots":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"jitter","yaw_jitter_add":0,"hold_time":2,"body_yaw_add":-1,"hold_delay":2,"defensive_yaw_mode":"spin","yaw_add":0,"yaw_jitter":"center","yaw_add_r":0,"defensive_pitch_mode":"up","defensive_builder":"default"},"slow walk":{"enable":true,"yaw_base":"at targets","options":["defensive yaw","safe head (lc)","force lag","~"],"body_yaw":"hold yaw","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":0,"hold_delay":26,"defensive_yaw_mode":"spin","yaw_add":-20,"yaw_jitter":"off","yaw_add_r":20,"defensive_pitch_mode":"ambani","defensive_builder":"defensive"},"run":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"strong","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":0,"hold_delay":3,"defensive_yaw_mode":"spin - static","yaw_add":44,"yaw_jitter":"off","yaw_add_r":-18,"defensive_pitch_mode":"zero","defensive_builder":"default"},"duck jump":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","air tick","~"],"body_yaw":"strong","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":0,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":45,"yaw_jitter":"off","yaw_add_r":-13,"defensive_pitch_mode":"ambani","defensive_builder":"default"},"global":{"defensive_builder":"defensive","yaw_base":"at targets","options":["anti-backstab","defensive yaw","safe head (lc)","~"],"body_yaw":"jitter","hold_time":2,"yaw_jitter_add":61,"hold_delay":2,"defensive_yaw_mode":"spin - static","yaw_add":0,"yaw_jitter":"center","yaw_add_r":0,"body_yaw_add":0,"defensive_pitch_mode":"ambani"},"duck":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"jitter","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":-1,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":-31,"yaw_jitter":"off","yaw_add_r":36,"defensive_pitch_mode":"up","defensive_builder":"default"},"stand":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"hold yaw","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":0,"hold_delay":3,"defensive_yaw_mode":"spin - static","yaw_add":-20,"yaw_jitter":"off","yaw_add_r":20,"defensive_pitch_mode":"ambani","defensive_builder":"default"},"duck move":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","~"],"body_yaw":"strong","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":0,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":46,"yaw_jitter":"off","yaw_add_r":-18,"defensive_pitch_mode":"ambani","defensive_builder":"default"},"jump":{"enable":true,"yaw_base":"at targets","options":["anti-backstab","air tick","~"],"body_yaw":"strong","yaw_jitter_add":0,"hold_time":5,"body_yaw_add":0,"hold_delay":5,"defensive_yaw_mode":"spin - static","yaw_add":40,"yaw_jitter":"off","yaw_add_r":-15,"defensive_pitch_mode":"ambani","defensive_builder":"default"}}}]]

json.encode_sparse_array(true)

local unpack = unpack
local next = next
local line = renderer.line
local world_to_screen = renderer.world_to_screen
local unpack_vec = vector().unpack
local resolver_flag = {}
local resolver_status = false

local function construct_points(origin, min, max)
	local points = {
		-- construct initial 4 points, we can extrapolate vertically in a moment
		vector(origin.x + min.x, origin.y + min.y, origin.z + min.z),
		vector(origin.x + max.x, origin.y + min.y, origin.z + min.z),
		vector(origin.x + max.x, origin.y + max.y, origin.z + min.z),
		vector(origin.x + min.x, origin.y + max.y, origin.z + min.z),
	}

	-- create our top 4 points
	for i = 1, 4 do
		local point = points[i]
		points[#points + 1] = vector(point.x, point.y, point.z + min.z + max.z)
	end
	
	-- replace all of our points with w2s results
	for i = 1, 8 do
		points[i] = {world_to_screen(unpack_vec(points[i]))}
	end

	return points
end

local function draw_box(origin, min, max, r, g, b, a)
	local points = construct_points(origin, min, max)
	local connections = {
		[1] = { 2, 4, 5 },
		[2] = { 3, 6 },
		[3] = { 4, 7 },
		[4] = { 8 },
		[5] = { 6, 8 },
		[6] = { 7 },
		[7] = { 8 }
	}

	for idx, point_list in next, connections do
		local fx, fy = unpack(points[idx])
		for _, connecting_point in next, point_list do
			local tx, ty = unpack(points[connecting_point])
			line(fx, fy, tx, ty, r, g, b, a)
		end
	end
end

local flags = {
	['H'] = {0, 1},
	['K'] = {1, 2},
	['HK'] = {2, 4},
	['ZOOM'] = {3, 8},
	['BLIND'] = {4, 16},
	['RELOAD'] = {5, 32},
	['C4'] = {6, 64},
	['VIP'] = {7, 128},
	['DEFUSE'] = {8, 256},
	['FD'] = {9, 512},
	['PIN'] = {10, 1024},
	['HIT'] = {11, 2048},
	['O'] = {12, 4096},
	['X'] = {13, 8192},
	-- beta flag
	-- beta flag
	-- beta flag
	['DEF'] = {17, 131072}
}

local function entity_has_flag(entindex, flag_name)
	if not entindex or not flag_name then
		return false
	end

	local flag_data = flags[flag_name]

	if flag_data == nil then
		return false
	end

	local esp_data = entity.get_esp_data(entindex) or {}

	return bit.band(esp_data.flags or 0, bit.lshift(1, flag_data[1])) == flag_data[2]
end



local new_class = function()
	local mt, mt_data, this_mt = { }, { }, { }

	mt.__metatable = false
	mt_data.struct = function(self, name)
		assert(type(name) == 'string', 'invalid class name')
		assert(rawget(self, name) == nil, 'cannot overwrite subclass')

		return function(data)
			assert(type(data) == 'table', 'invalid class data')
			rawset(self, name, setmetatable(data, {
				__metatable = false,
				__index = function(self, key)
					return
						rawget(mt, key) or
						rawget(this_mt, key)
				end
			}))

			return this_mt
		end
	end

	this_mt = setmetatable(mt_data, mt)

	return this_mt
end

local ctx = new_class()
	:struct 'globals' {
		states = {"stand", "slow walk", "run", "duck", "duck move", "jump", "duck jump", "hideshots"},
		extended_states = {"global", "stand", "slow walk", "run", "duck", "duck move", "jump", "duck jump", "hideshots"},
		teams = {"t", "ct"},
		in_ladder = 0,
		nade = 0,
		resolver_data = {}
	}

	:struct 'ref' {
		aa = {
			enabled = {ui.reference("aa", "anti-aimbot angles", "enabled")},
			pitch = {ui.reference("aa", "anti-aimbot angles", "pitch")},
			yaw_base = {ui.reference("aa", "anti-aimbot angles", "Yaw base")},
			yaw = {ui.reference("aa", "anti-aimbot angles", "Yaw")},
			yaw_jitter = {ui.reference("aa", "anti-aimbot angles", "Yaw Jitter")},
			body_yaw = {ui.reference("aa", "anti-aimbot angles", "Body yaw")},
			freestanding_body_yaw = {ui.reference("aa", "anti-aimbot angles", "Freestanding body yaw")},
			freestand = {ui.reference("aa", "anti-aimbot angles", "Freestanding")},
			roll = {ui.reference("aa", "anti-aimbot angles", "Roll")},
			edge_yaw = {ui.reference("aa", "anti-aimbot angles", "Edge yaw")}
		},
		fakelag = {
			enable = {ui.reference("aa", "fake lag", "enabled")},
			amount = {ui.reference("aa", "fake lag", "amount")},
			variance = {ui.reference("aa", "fake lag", "variance")},
			limit = {ui.reference("aa", "fake lag", "limit")},
		},
		rage = {
			dt = {ui.reference("rage", "aimbot", "Double tap")},
			dt_limit = {ui.reference("rage", "aimbot", "Double tap fake lag limit")},
			fd = {ui.reference("rage", "other", "Duck peek assist")},
			os = {ui.reference("aa", "other", "On shot anti-aim")},
			silent = {ui.reference("rage", "Other", "Silent aim")},
			quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
			quickpeek2 = {ui.reference("RAGE", "Other", "Quick peek assist mode")},
			mindmg = {ui.reference('rage', 'aimbot', 'minimum damage')},
			ovr = {ui.reference('rage', 'aimbot', 'minimum damage override')}
		},
		slow_motion = {ui.reference("aa", "other", "Slow motion")},
	}

	:struct 'ui' {
		menu = {
			global = {},
			aa = {},
			vis = {},
			misc = {},
			cfg = {},
			debug = {}
		},

		execute = function(self)
			local group = pui.group("AA", "anti-aimbot angles")
			local debug_group = pui.group("AA", "Other")

			self.menu.global.label = group:label("\badcbff\bffadb4[A M B A N I]\n")
			self.menu.global.tab = group:combobox(" \ntab", {"aa", "misc", "vis", "cfg"})

			-- aa
			self.menu.aa.mode = group:combobox("configuration mode", {"preset", "builder"})
			self.menu.aa.preset_list = group:listbox("presets", {"ambani", "STRONK"}):depend({self.menu.aa.mode, "preset"})

			self.menu.aa.state = group:combobox("state", self.globals.extended_states):depend({self.menu.aa.mode, "builder"})
			self.menu.aa.team = group:combobox("\nteam", self.globals.teams):depend({self.menu.aa.mode, "builder"})

			self.menu.aa.states = {}

			for _, team in ipairs(self.globals.teams) do
				self.menu.aa.states[team] = {}
				for _, state in ipairs(self.globals.extended_states) do
					self.menu.aa.states[team][state] = {}
					local menu = self.menu.aa.states[team][state]

					if state ~= "global" then
						menu.enable = group:checkbox("activate " .. state .. "\n" .. team)
					end
					menu.options = group:multiselect("options" .. "\n" .. state .. team, {"anti-backstab", "defensive yaw", "air tick", "safe head (lc)", "force lag", "e spam"})
					-- just in here to hide other things
					menu.defensive_builder = group:combobox("builder: " .. "\n" .. state .. team, {"default", "defensive"})
					menu.defensive_pitch_mode = group:combobox("pitch mode" .. "\n" .. state .. team, {"up", "ambani", "zero"}):depend({menu.defensive_builder, "defensive", false})
					menu.defensive_yaw_mode = group:combobox("yaw mode" .. "\n" .. state .. team, {"spin", "spin - static"}):depend({menu.defensive_builder, "defensive", false})
					menu.yaw_base = group:combobox("yaw base" .. "\n" .. state .. team, {"local view", "at targets"}):depend({menu.defensive_builder, "defensive", true})
					menu.yaw_add = group:slider("yaw add (l)" .. "\n" .. state .. team, -180, 180, 0, true, "°", 1):depend({menu.defensive_builder, "defensive", true})
					menu.yaw_add_r = group:slider("yaw add (r)" .. "\n" .. state .. team, -180, 180, 0, true, "°", 1):depend({menu.defensive_builder, "defensive", true})
					menu.yaw_jitter = group:combobox("yaw jitter" .. "\n" .. state .. team, {"off", "offset", "center", "random", "skitter", "x-way [x]"}):depend({menu.defensive_builder, "defensive", true})
					menu.yaw_jitter_add = group:slider("\nyaw jitter add" .. state .. team, -180, 180, 0, true, "°", 1):depend({menu.yaw_jitter, "off", true}):depend({menu.defensive_builder, "defensive", true})
					menu.body_yaw = group:combobox("body yaw" .. "\n" .. state .. team, {"off", "static", "opposite", "jitter", "hold yaw", "strong"}):depend({menu.defensive_builder, "defensive", true})
					menu.body_yaw_add = group:slider("\nbody yaw add" .. state .. team, -180, 180, 0, true, "°", 1):depend({menu.body_yaw, "hold yaw", true}, {menu.body_yaw, "off", true}):depend({menu.body_yaw, "off", true}):depend({menu.defensive_builder, "defensive", true})
					--menu.body_yaw_options = group:multiselect("\nbody yaw options" .. state .. team, {"hold yaw", "hide animations"}):depend(true, {menu.body_yaw, "hold yaw"}):depend({menu.body_yaw, "off", true}):depend({menu.defensive_builder, "defensive", true})
					menu.hold_time = group:slider("hold time (ticks)" .. "\n" .. state .. team, 1, 5, 2, true, "t", 1):depend({menu.body_yaw, "hold yaw"}):depend({menu.defensive_builder, "defensive", true})
					menu.hold_delay = group:slider("hold delay (cycles)" .. "\n" .. state .. team, 1, 32, 2, true, "x", 1, {["1"] = "delayed jitter"}):depend({menu.body_yaw, "hold yaw"}):depend({menu.defensive_builder, "defensive", true})

					for _, v in pairs(menu) do
						local arr =  { {self.menu.aa.state, state}, {self.menu.aa.team, team}, {self.menu.aa.mode, "builder"} }
						if _ ~= "enable" and state ~= "global" then
							arr =  { {self.menu.aa.state, state}, {self.menu.aa.team, team}, {self.menu.aa.mode, "builder"}, {menu.enable, true} }
						end

						v:depend(table.unpack(arr))
						end
					end
				end

			self.menu.aa.space = group:label(" ")
			self.menu.aa.export_from = group:combobox("export:", {"selected state", "selected team"}):depend({self.menu.aa.mode, "builder"})
			self.menu.aa.export_to = group:combobox("to:", {"opposite team", "clipboard"}):depend({self.menu.aa.mode, "builder"})
			self.menu.aa.export = group:button("export", function ()
				local type = "team"
				local team = self.menu.aa.team:get() == "ct" and "t" or "ct"
				if self.menu.aa.export_from:get() == "selected state" then
					type = "state"
				end

				data = self.config:export(type, self.menu.aa.team:get(), self.menu.aa.state:get())

				if self.menu.aa.export_to:get() == "clipboard" then
					clipboard.set(data)
				else
					self.config:import(data, type, team, self.menu.aa.state:get())
				end
			end):depend({self.menu.aa.mode, "builder"})
			self.menu.aa.import = group:button("import", function ()
				local data = clipboard.get()
				local type = data:match("{ambani:(.+)}")
						self.config:import(data, type, self.menu.aa.team:get(), self.menu.aa.state:get())
			end):depend({self.menu.aa.mode, "builder"})

			--misc
			self.menu.misc.freestanding = group:multiselect("freestanding", {"activate disablers", "force static", "force local view"}, 0x0)
			self.menu.misc.freestanding_disablers = group:multiselect("\nfreestanding disablers", self.globals.states):depend({self.menu.misc.freestanding, "activate disablers"})
			self.menu.misc.edge_yaw = group:label("edge yaw", 0x0)
			self.menu.misc.manual_aa = group:checkbox("manual aa")
			self.menu.misc.manual_left = group:hotkey("manual left"):depend({self.menu.misc.manual_aa, true})
			self.menu.misc.manual_right = group:hotkey("manual right"):depend({self.menu.misc.manual_aa, true})
			self.menu.misc.manual_forward = group:hotkey("manual forward"):depend({self.menu.misc.manual_aa, true})
			self.menu.misc.resolver = group:checkbox("activate jitter helper")
			self.menu.misc.resolver_flag = group:checkbox("activate jitter helper flags"):depend({self.menu.misc.resolver, true})
			self.menu.misc.animations = group:checkbox("activate animations")
			self.menu.misc.animations_selector = group:multiselect("animations", {"walk in air", "static legs", "moon walk"}):depend({self.menu.misc.animations, true})
			self.menu.misc.aipeek = group:hotkey("\ac0abffff[debug]\r peek bot")
			self.menu.misc.quickpeekdefault = group:multiselect("\ac0abffff[debug]\r quick peek default settings", {"retreat on shot", "retreat on key release"})
			self.menu.misc.quickpeekmode = group:combobox("\ac0abffff[debug]\r quick peek default mode", {"on hotkey", "toggle"})
			--self.menu.misc.peekbotdesign = group:combobox("\ac0abffff[debug]\r visualize peekbot", {"disabled", "lines", "box"}, {255, 255, 255})
			--vis
			self.menu.vis.indicators = group:checkbox("enable indicators", {140, 125, 255})
			
			self.menu.vis.indicatorfont = group:combobox("indicator font", {"small", "normal", "bold"}):depend({self.menu.vis.indicators, true})
			--config
			self.menu.cfg.list = group:listbox("configs", {})
			self.menu.cfg.list:set_callback(function() self.config:update_name() end)
			self.menu.cfg.name = group:textbox("config name")
			self.menu.cfg.save = group:button("save", function() self.config:save() end)
			self.menu.cfg.load = group:button("load", function() self.config:load() end)
			self.menu.cfg.delete = group:button("delete", function() self.config:delete() end)
			self.menu.cfg.export = group:button("export", function() clipboard.set(self.config:export("config")) end)
			self.menu.cfg.import = group:button("import", function() self.config:import(clipboard.get(), "config") end)

			--debug
			self.menu.global.export_preset = debug_group:button("\ac0abffff[debug]\r export current preset", function ()
				local config = pui.setup(self.menu.aa.states)
				local data = config:save()

				local serialized = json.stringify(data)

				clipboard.set(serialized)
			end)

			-- set item dependencies (visibility)
			for tab, arr in pairs(self.menu) do
				if type(arr) == "table" and tab ~= "global" then
					Loop = function (arr, tab)
						for _, v in pairs(arr) do
							if type(v) == "table" then
								if v.__type == "pui::element" then
									v:depend({self.menu.global.tab, tab})
								else
									Loop(v, tab)
								end
							end
						end
					end

					Loop(arr, tab)
				end
			end
			
		end,

		shutdown = function(self)
			self.helpers:menu_visibility(true)
		end
	}

	:struct 'helpers' {
		contains = function(self, tbl, val)
			print(tbl)
			for k, v in pairs(tbl) do
				if v == val then
					return true
				end
			end
			return false
		end,

		get_lerp_time = function(self)
			local ud_rate = cvar.cl_updaterate:get_int()
			
			local min_ud_rate = cvar.sv_minupdaterate:get_int()
			local max_ud_rate = cvar.sv_maxupdaterate:get_int()
			
			if (min_ud_rate and max_ud_rate) then
				ud_rate = max_ud_rate
			end

			local ratio = cvar.cl_interp_ratio:get_float()
			
			if (ratio == 0) then
				ratio = 1
			end

			local lerp = cvar.cl_interp:get_float()
			local c_min_ratio = cvar.sv_client_min_interp_ratio:get_float()
			local c_max_ratio = cvar.sv_client_max_interp_ratio:get_float()
			
			if (c_min_ratio and  c_max_ratio and  c_min_ratio ~= 1) then
				ratio = clamp(ratio, c_min_ratio, c_max_ratio)
			end

			return math.max(lerp, (ratio / ud_rate));
		end,

		rgba_to_hex = function(self, r, g, b, a)
			return bit.tohex(
			(math.floor(r + 0.5) * 16777216) + 
			(math.floor(g + 0.5) * 65536) + 
			(math.floor(b + 0.5) * 256) + 
			(math.floor(a + 0.5))
			)
		end,

		easeInOut = function(self, t)
			return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
		end,

		animate_text = function(self, time, string, r, g, b, a)
			local t_out, t_out_iter = { }, 1

			local l = string:len( ) - 1
	
			local r_add = (255 - r)
			local g_add = (255 - g)
			local b_add = (255 - b)
			local a_add = (155 - a)
	
			for i = 1, #string do
				local iter = (i - 1)/(#string - 1) + time
				t_out[t_out_iter] = "\a" .. self:rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )
	
				t_out[t_out_iter + 1] = string:sub( i, i )
	
				t_out_iter = t_out_iter + 2
			end
	
			return t_out
		end,

		clamp = function(self, val, lower, upper)
			assert(val and lower and upper, "not very useful error message here")
			if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
			return math.max(lower, math.min(upper, val))
		end,

		get_damage = function(self)
			local mindmg = ui.get(self.ref.rage.mindmg[1])
			if ui.get(self.ref.rage.ovr[1]) and ui.get(self.ref.rage.ovr[2]) then
				return ui.get(self.ref.rage.ovr[3])
			else
				return mindmg
			end
		end,

		normalize = function(self, angle)
			angle =  angle % 360 
			angle = (angle + 360) % 360
			if (angle > 180)  then
				angle = angle - 360
			end
			return angle
		end,

		fetch_data = function(self, ent)
			return {
				origin = vector(entity.get_origin(ent)), -- +
				vev_velocity = vector(entity.get_prop(ent, "m_vecVelocity")),
				view_offset = entity.get_prop(ent, "m_vecViewOffset[2]"), -- +
				eye_angles = vector(entity.get_prop(ent, "m_angEyeAngles")), -- +
				lowerbody_target = entity.get_prop(ent, "m_flLowerBodyYawTarget"),
				simulation_time = self.helpers:time_to_ticks(entity.get_prop(ent, "m_flSimulationTime")),
				tickcount = globals.tickcount(),
				curtime = globals.curtime(),
				tickbase = entity.get_prop(ent, "m_nTickBase"),
				origin = vector(entity.get_prop(ent, "m_vecOrigin")),
				flags = entity.get_prop(ent, "m_fFlags"),
			}
		end,

		time_to_ticks = function(self, t)
			return math.floor(0.5 + (t / globals.tickinterval()))
		end,

		menu_visibility = function(self, visible)
			for _, v in pairs(self.ref.aa) do
				for _, item in ipairs(v) do
					ui.set_visible(item, visible)
				end
			end
		end,

		in_ladder = function(self)
			local me = entity.get_local_player()

			if entity.is_alive(me) then
				if entity.get_prop(me, "m_MoveType") == 9 then
					self.globals.in_ladder = globals.tickcount() + 8
				end
			else
				self.globals.in_ladder = 0
			end

		end,

		in_air = function(self, ent)
			local flags = entity.get_prop(ent, "m_fFlags")
			return bit.band(flags, 1) == 0
		end,

		in_duck = function(self, ent)
			local flags = entity.get_prop(ent, "m_fFlags")
			return bit.band(flags, 4) == 4
		end,

		get_freestanding_side = function(self)
			local me = entity.get_local_player()
			local target = client.current_threat()
			local pitch, yaw, roll = client.camera_angles()
			local pos = vector(client.eye_position())
			
			if target then
				pitch, yaw = (pos - vector(entity.get_origin(target))):angles()
			end
			
			local yaw_offset = ui.get(self.ref.aa.yaw[2])
			local yaw_jitter_type = ui.get(self.ref.aa.yaw_jitter[1])
			local yaw_jitter_amount = ui.get(self.ref.aa.yaw_jitter[2])
			
			local offset = math.abs(yaw_jitter_amount)
			
			if yaw_jitter_type == 'Skitter' then
				offset = math.abs(yaw_jitter_amount) + 33
			elseif yaw_jitter_type == 'Offset' then
				offset = math.max(0, yaw_jitter_amount)
			elseif yaw_jitter_type == 'Center' then
				offset = math.abs(yaw_jitter_amount)/2
			end
			
			local max_yaw = yaw + 180 + yaw_offset + offset
			
			local min_offset = offset
			if yaw_jitter_type == 'Offset' then
				min_offset = math.abs(math.min(0, yaw_jitter_amount))
			end
			
			local min_yaw = yaw + 180 + yaw_offset - min_offset
			
			local current_yaw = vector(entity.get_prop(me, 'm_angEyeAngles')).y
			
			if self.helpers:normalize(current_yaw - max_yaw) > 0 then
				return 0
			elseif self.helpers:normalize(current_yaw - min_yaw) < 0 then
				return 1
			end
			
			return 2
		end,

		get_state = function(self)
			local me = entity.get_local_player()
			local velocity = vector(entity.get_prop(me, "m_vecVelocity")):length2d()
			if ui.get(self.ref.rage.os[2]) and not ui.get(self.ref.rage.dt[2]) then
				return "hideshots"
			elseif self:in_air(me) then
				return self:in_duck(me) and "duck jump" or "jump"
			elseif velocity > 1.5 and self:in_duck(me) then
					return "duck move"
				elseif ui.get(self.ref.slow_motion[1]) and ui.get(self.ref.slow_motion[2]) then
					return "slow walk"
				elseif self:in_duck(me) then
					return "duck"
				else
					return velocity > 1.5 and "run" or "stand"
				end
		end,

		get_team = function(self)
			local me = entity.get_local_player()
			local index = entity.get_prop(me, "m_iTeamNum")

			return index == 2 and "t" or "ct"
		end,

		loop = function (arr, func)
			if type(arr) == "table" and arr.__type == "pui::element" then
				func(arr)
			else
				for k, v in pairs(arr) do
					loop(v, func)
				end
			end
		end,

		get_charge = function ()
			local me = entity.get_local_player()
			local simulation_time = entity.get_prop(entity.get_local_player(), "m_flSimulationTime")
			return (globals.tickcount() - simulation_time/globals.tickinterval())
		end
	}

	:struct 'config' {
		configs = {},

		write_file = function (self, path, data)
			if not data or type(path) ~= "string" then
				return
			end

			return writefile(path, json.stringify(data))
		end,

		update_name = function (self)
			local index = self.ui.menu.cfg.list()
			local i = 1

			for k, v in pairs(self.configs) do
				if index == i or index == 0 then
					return self.ui.menu.cfg.name(k)
				end
				i = i + 1
			end
		end,

		update_configs = function (self)
			local names = {}
			for k, v in pairs(self.configs) do
				table.insert(names, k)
			end
			
			if #names > 0 then
				self.ui.menu.cfg.list:update(names)
			end
			self:write_file("ambani_configs.txt", self.configs)
			self:update_name()
		end,

		setup = function (self)
			local data = readfile('ambani_configs.txt')
			if data == nil then
				self.configs = {}
				return
			end

			self.configs = json.parse(data)

			self:update_configs()

			self:update_name()
		end,

		export_config = function(self, ...)
			local config = pui.setup({self.ui.menu.global, self.ui.menu.aa, self.ui.menu.misc, self.ui.menu.vis})

			local data = config:save()
			local encrypted = base64.encode( json.stringify(data) )

			return encrypted
		end,

		export_state = function (self, team, state)
			local config = pui.setup({self.ui.menu.aa.states[team][state]})

			local data = config:save()
			local encrypted = base64.encode( json.stringify(data) )

			return encrypted
		end,

		export_team = function (self, team)
			local config = pui.setup({self.ui.menu.aa.states[team]})

			local data = config:save()
			local encrypted = base64.encode( json.stringify(data) )

			return encrypted
		end,

		export = function (self, type, ...)
			local success, result = pcall(self['export_' .. type], self, ...)
			if not success then
				print(result)
				return
			end

			return "{ambani:" .. type .. "}:" .. result
		end,

		import_config = function (self, encrypted)
			local data = json.parse(base64.decode(encrypted))

			local config = pui.setup({self.ui.menu.global, self.ui.menu.aa, self.ui.menu.misc, self.ui.menu.vis})
			config:load(data)
		end,

		import_state = function (self, encrypted, team, state)
			local data = json.parse(base64.decode(encrypted))

			local config = pui.setup({self.ui.menu.aa.states[team][state]})
			config:load(data)
		end,

		import_team = function (self, encrypted, team)
			local data = json.parse(base64.decode(encrypted))

			local config = pui.setup({self.ui.menu.aa.states[team]})
			config:load(data)
		end,

		import = function (self, data, type, ...)
			local name = data:match("{ambani:(.+)}")
			if not name or name ~= type then
				return error('This is not valid ambani data. 1')
			end

			local success, err = pcall(self['import_'..name], self, data:gsub("{ambani:" .. name .. "}:", ""), ...)
			if not success then
				print(err)
				return error('This is not valid ambani data. 2')
			end
		end,

		save = function (self)
			local name = self.ui.menu.cfg.name()
			if name:match("%w") == nil then
				return print("Invalid config name")
			end

			local data = self:export("config")

			self.configs[name] = data

			self:update_configs()
		end,

		load = function (self)
			local name = self.ui.menu.cfg.name()
			local data = self.configs[name]
			if not data then
				return print("Invalid config name")
			end

			self:import(data, "config")
		end,

		delete = function(self)
			local name = self.ui.menu.cfg.name()
			local data = self.configs[name]
			if not data then
				return print("Invalid config name")
			end

			self.configs[name] = nil

			self:update_configs()
		end,


	}

	:struct 'fakelag' {
		send_packet = true,

		get_limit = function (self)
			if not ui.get(self.ref.fakelag.enable[1]) then
				return 1
			end

			local limit = ui.get(self.ref.fakelag.limit[1])
			local charge = self.helpers:get_charge()

			if ui.get(self.ref.rage.dt[1]) and ui.get(self.ref.rage.dt[2]) and not ui.get(self.ref.rage.fd[1]) then
				if charge > 0 then
					limit = 1
				else
					limit = ui.get(self.ref.rage.dt_limit[1])
				end
			end
			
			return limit
		end,

		run = function (self, cmd)
			local limit = self:get_limit()
			if cmd.chokedcommands < limit and (not cmd.no_choke) then
				self.send_packet = false
				cmd.no_choke = false
			else
				cmd.no_choke = true
				self.send_packet = true
			end

			cmd.allow_send_packet = self.send_packet

			return self.send_packet
		end
	}

	:struct 'desync' {
		switch_move = true,

		get_yaw_base = function (self, base)
			local threat = client.current_threat()
			local _, yaw = client.camera_angles()
			if base == "at targets" and threat then
				local pos = vector(entity.get_origin(entity.get_local_player()))
				local epos = vector(entity.get_origin(threat))
		
				_, yaw = pos:to(epos):angles()
			end
		
			return yaw
		end,

		do_micromovements = function(self, cmd, send_packet)
			local me = entity.get_local_player()
			local speed = 1.01
			local vel = vector(entity.get_prop(me, "m_vecVelocity")):length2d()

			if vel > 3 then
				return
			end

			if self.helpers:in_duck(me) or ui.get(self.ref.rage.fd[1]) then
				speed = speed * 2.94117647
			end

			self.switch_move = self.switch_move or false

			if self.switch_move then
				cmd.sidemove = cmd.sidemove + speed
			else
				cmd.sidemove = cmd.sidemove - speed
			end

			self.switch_move = not self.switch_move
		end,

		can_desync = function (self, cmd)
			local me = entity.get_local_player()

			if cmd.in_use == 1 then
				return false
			end
			local weapon_ent = entity.get_player_weapon(me)
			if cmd.in_attack == 1 then
				local weapon = entity.get_classname(weapon_ent)
				if weapon == nil then
					return false
				end
				if weapon:find("Grenade") then
					self.globals.nade = globals.tickcount()
				else
					if math.max(entity.get_prop(weapon_ent, "m_flNextPrimaryAttack"), entity.get_prop(me, "m_flNextAttack")) - globals.tickinterval() - globals.curtime() < 0 then
						return false
					end
				end
			end
			local throw = entity.get_prop(weapon_ent, "m_fThrowTime")

			if self.globals.nade + 15 == globals.tickcount() or (throw ~= nil and throw ~= 0) then 
				return false 
			end
			if entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod") == 1 then
				return false
			end
		
			if entity.get_prop(me, "m_MoveType") == 9 or self.globals.in_ladder > globals.tickcount() then
				return false
			end
			if entity.get_prop(me, "m_MoveType") == 10 then
				return false
			end
		
			return true
		end,

		run = function (self, cmd, send_packet, data)
			if not self:can_desync(cmd) then
				return
			end

			self:do_micromovements(cmd, send_packet)

			local yaw = self:get_yaw_base(data.base)

			if send_packet then
				cmd.pitch = data.pitch or 88.9
				cmd.yaw = yaw + 180 + data.offset
			else
				cmd.pitch = 88.9
				cmd.yaw = yaw + 180 + data.offset + (data.side == 2 and (math.random(0, 1) == 1 and 120 or -120) or (data.side == 0 and 120 or -120))
			end
		end
	}

	:struct 'antiaim' {
		switch = true,
		switch2 = true,
		hold_time = 0,
		hold_delay = 0,
		manual_angle = 0,
		last_press = 0,
		peeked = 0,
		reset = 0,
		old_yaw = 0,
		has_updated = true,
		jitter = false,
		cache = 0,

		runmanual = function(self)
			if self.ui.menu.misc.manual_right:get() and self.last_press + 0.2 < globals.curtime() then
				self.manual_angle = self.manual_angle == 90 and 0 or 90
				self.last_press = globals.curtime()
			elseif self.ui.menu.misc.manual_left:get() and self.last_press + 0.2 < globals.curtime() then
				self.manual_angle = self.manual_angle == -90 and 0 or -90
				self.last_press = globals.curtime()
			elseif self.ui.menu.misc.manual_forward:get() and self.last_press + 0.2 < globals.curtime() then
				self.manual_angle = self.manual_angle == 180 and 0 or 180
				self.last_press = globals.curtime()
			elseif self.last_press > globals.curtime() then
				self.last_press = globals.curtime()
			end
		end,

		run = function (self, cmd)
			local me = entity.get_local_player()

			if not entity.is_alive(me) then
				return
			end

			self.runmanual(self)

			local state = self.helpers:get_state()
			local team = self.helpers:get_team()

			if self.ui.menu.aa.mode() == "builder" then
				self:set_builder(cmd, state, team)
			else
				self:set_preset(cmd, state, team)
			end

		end,

		set_builder = function (self, cmd, state, team)
			if not self.ui.menu.aa.states[team][state].enable() then
				state = "global"
			end
		
			local data = {}

			for k, v in pairs(self.ui.menu.aa.states[team][state]) do
				data[k] = v()
			end
			
			self:set(cmd, data)
		end,

		set_preset = function (self, cmd, state, team)
			local preset = self.ui.menu.aa.preset_list:get()

			local presets = {
				[0] = function ()
					local preset_data = json.parse(global_data_saved_somewhere)

					if not preset_data[team][state].enable then
						state = "global"
					end

					local data = {}

					for k, v in pairs(preset_data[team][state]) do
						data[k] = v
					end
				
					self:set(cmd, data)
				end,
				[1] = function ()
					local preset_data = json.parse(global_data_saved_somewhere2)

					if not preset_data[team][state].enable then
						state = "global"
					end

					local data = {}

					for k, v in pairs(preset_data[team][state]) do
						data[k] = v
					end
				
					self:set(cmd, data)
				end

			}

			return presets[preset](cmd)
		end,

		airtick = function(self, cmd)
			cmd.force_defensive = true
		end, 

		animations = function(self)
			local me = entity.get_local_player()

			if not entity.is_alive(me) then
				return
			end

			local self_index = entity_lib.new(me)
			local self_anim_overlay = self_index:get_anim_overlay(6)
			
			if not self_anim_overlay then
				return
			end

			local x_velocity = entity.get_prop(me, "m_flPoseParameter", 7)
			local state = self.helpers:get_state()

			if string.find(state, "jump") and self.helpers:contains(self.ui.menu.misc.animations_selector:get(), "walk in air") then
				self_anim_overlay.weight = 1
				self_anim_overlay.cycle = 0
			end

			if self.helpers:contains(self.ui.menu.misc.animations_selector:get(), "moon walk") then
				self_anim_overlay.cycle = 0.5
			end

			if self.helpers:contains(self.ui.menu.misc.animations_selector:get(), "static legs") then
				entity.set_prop(me, "m_flPoseParameter", 1, 6) 
			end
			--self_anim_overlay.sequence = 232--globals.tickcount() % 4 == 0 and 232 or 11
		end,

		set = function (self, cmd, data)
			local me = entity.get_local_player()

			local desyncbodyyaw = entity.get_prop(me, "m_flPoseParameter", 11) * 120 - 60

			local side = desyncbodyyaw > 0 and true or false

			local state = self.helpers:get_state()

			local defensive = (self.defensive.defensive > 2 and self.defensive.defensive < 14 and self.defensive.defensive ~= 11 and self.defensive.defensive ~= 5)
		
			if not self.helpers:contains(self.ui.menu.misc.freestanding_disablers:get(), state) then
				ui.set(self.ref.aa.freestand[2], self.ui.menu.misc.freestanding:get_hotkey() and "Always on" or "On hotkey")
				ui.set(self.ref.aa.freestand[1], self.ui.menu.misc.freestanding:get_hotkey())
			end
			
			if self.helpers:contains(data.options, "air tick") and string.find(state, "jump") then
				self.airtick(self, cmd)
			end

			local freestandside = self.helpers:get_freestanding_side()

			local send_packet = self.fakelag:run(cmd)
			if send_packet then
				if data.body_yaw == "hold yaw" then
					if self.hold_delay + 1 >= data.hold_delay then -- hold_delay
						if self.hold_time >= data.hold_time then -- hold_time
							self.switch = not self.switch
							self.hold_delay = 0
							self.hold_time = 0
						else
							self.hold_time = self.hold_time + 1 -- hold_time
						end
					else
						self.switch = not self.switch
						self.hold_delay = self.hold_delay + 1 -- hold_delay
					end
				else
					self.switch = not self.switch
				end
			end

			if cmd.chokedcommands == 0 then
				self.switch2 = not self.switch2
			end

			local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
			local side = bodyyaw > 0 and 1 or -1

			yaw_offset = self.switch and data.yaw_add or data.yaw_add_r
			
			if data.body_yaw ~= "strong" or self.ui.menu.misc.freestanding:get_hotkey() then
				if self.helpers:contains(self.ui.menu.misc.freestanding:get(), "force static") and self.ui.menu.misc.freestanding:get_hotkey() and not self.helpers:contains(self.ui.menu.misc.freestanding_disablers:get(), state) then
					ui.set(self.ref.aa.pitch[1], "default")
					ui.set(self.ref.aa.yaw_base[1], "local view")
					ui.set(self.ref.aa.yaw[1], "180")
					ui.set(self.ref.aa.yaw[2], 0) -- calculate l/r
					ui.set(self.ref.aa.yaw_jitter[1], "off")
					ui.set(self.ref.aa.yaw_jitter[2], 0)
					ui.set(self.ref.aa.body_yaw[1], "static")
					ui.set(self.ref.aa.body_yaw[2], -180)
				elseif defensive and self.helpers:contains(data.options, "defensive yaw") then
					if data.defensive_pitch_mode == "ambani" then
						ui.set(self.ref.aa.pitch[1], "custom")
						ui.set(self.ref.aa.pitch[2], -55)
					elseif data.defensive_pitch_mode == "up" then
						ui.set(self.ref.aa.pitch[1], self.defensive.defensive and "up" or "down")
					elseif data.defensive_pitch_mode == "zero" then
						ui.set(self.ref.aa.pitch[1], "custom")
						ui.set(self.ref.aa.pitch[2], 0)
					end
					ui.set(self.ref.aa.yaw_base[1], data.yaw_base)
					ui.set(self.ref.aa.yaw[1], data.defensive_yaw_mode == "spin" and "spin" or "spin")
					ui.set(self.ref.aa.yaw[2], data.defensive_yaw_mode == "spin" and (self.switch2 and -89 or 89) or (defensive and -29 or 61))
					ui.set(self.ref.aa.yaw_jitter[1], "Center")
					ui.set(self.ref.aa.yaw_jitter[2], 0)
					ui.set(self.ref.aa.body_yaw[1], "Jitter")
					ui.set(self.ref.aa.body_yaw[2], -2)
				else
					ui.set(self.ref.aa.pitch[1], "default")
					ui.set(self.ref.aa.yaw_base[1], data.yaw_base)
					ui.set(self.ref.aa.yaw[1], "180")
					ui.set(self.ref.aa.yaw[2], data.body_yaw == "hold yaw" and yaw_offset or (side == 1 and data.yaw_add or data.yaw_add_r)) -- calculate l/r
					ui.set(self.ref.aa.yaw_jitter[1], data.yaw_jitter)
					ui.set(self.ref.aa.yaw_jitter[2], data.body_yaw == "hold yaw" and 0 or data.yaw_jitter_add)
					ui.set(self.ref.aa.body_yaw[1], (data.body_yaw == "hold yaw" or data.body_yaw == "strong") and "off" or data.body_yaw)
					ui.set(self.ref.aa.body_yaw[2], (data.body_yaw == "hold yaw" or data.body_yaw == "strong") and 0 or data.body_yaw_add)
				end

				if self.helpers:contains(data.options, "safe head (lc)") and self.defensive.player_data[me] and self.defensive.player_data[me].breaking_lc then
					ui.set(self.ref.aa.yaw[1], "180")
					ui.set(self.ref.aa.yaw[2], 0)
					ui.set(self.ref.aa.yaw_jitter[1], "off")
					ui.set(self.ref.aa.body_yaw[1], "static")
					ui.set(self.ref.aa.body_yaw[2], 0)
				end

				if self.manual_angle ~= 0 then
					ui.set(self.ref.aa.yaw[2], self.manual_angle)
				end

			elseif data.body_yaw == "strong" and not self.ui.menu.misc.freestanding:get_hotkey() then
				side = math.random(0, 1)
				ui.set(self.ref.aa.body_yaw[1], "off")
				if cmd.command_number % math.random(2,6) == 1 then
					self.jitter = not self.jitter
					self.cache = self.jitter and data.yaw_add or data.yaw_add_r
					side = 2
				end

				yaw_offset = self.cache

				if self.manual_angle ~= 0 then
					yaw_offset = self.manual_angle
				end

				self.desync:run(cmd, send_packet, {
                    base = data.yaw_base,
                    side = side,
                    offset = yaw_offset,
					pitch = 88.9,
                })
			end

			local ent = client.current_threat()
			if entity_has_flag(ent, "HIT") then
				if self.helpers:contains(data.options, "force lag") then
					cmd.force_defensive = true
				end
				--if self.reset < globals.tickcount() then
				self.peeked = globals.tickcount() + 30
				--end
			end

			if self.helpers:contains(data.options, "anti-backstab") then
				local players = entity.get_players(true)
				local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
				for i=1, #players do
					local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
					local distance = math.sqrt((x - lx)^2 + (y - ly)^2 + (z - lz)^2)
					local weapon = entity.get_player_weapon(players[i])
					if entity.get_classname(weapon) == "CKnife" and distance <= 250 then
						ui.set(self.ref.aa.yaw[2], 180)
						ui.set(self.ref.aa.body_yaw[1], "static")
					end
				end
			end

			if self.peeked > globals.tickcount() and defensive and self.has_updated and self.helpers:contains(data.options, "e spam") then
				--self.reset = globals.tickcount() + 30
				self.has_updated = false
				ui.set(self.ref.aa.pitch[1], "Custom")
				ui.set(self.ref.aa.pitch[2], 0)
				ui.set(self.ref.aa.yaw_base[1], "at targets")
				ui.set(self.ref.aa.yaw[1], "Off")
				ui.set(self.ref.aa.yaw_jitter[1], "Offset")
				ui.set(self.ref.aa.yaw_jitter[2], -15)
				ui.set(self.ref.aa.yaw[2], 15)
				ui.set(self.ref.aa.body_yaw[1], "Static")
				ui.set(self.ref.aa.body_yaw[2], -180)
			else
				if globals.chokedcommands() == 0 then
					self.has_updated = true
				end
			end
			self.old_yaw = vector(entity.get_prop(me, "m_angEyeAngles")).y
		end

	}

	:struct 'resolver' {
		state = {},
		counter = {},
		jitterhelper = function(self)
			if self.ui.menu.misc.resolver() then
				local players = entity.get_players(true)      
				if #players == 0 then
					return
				end
				resolver_status = self.ui.menu.misc.resolver_flag()
				for _, i in next, players do

					local target = i
					if self.globals.resolver_data[target] == nil then
						local data = self.helpers:fetch_data(target)
						self.globals.resolver_data[target] = {
							current = data,
							last_valid_record = data
						}
					else
						local simulation_time = self.helpers:time_to_ticks(entity.get_prop(target, "m_flSimulationTime"))
						if simulation_time ~= self.globals.resolver_data[target].current.simulation_time then
							table.insert(self.globals.resolver_data[target], 1, self.globals.resolver_data[target].current)
							local data = self.helpers:fetch_data(target)
							if simulation_time - self.globals.resolver_data[target].current.simulation_time >= 1 then
								self.globals.resolver_data[target].last_valid_record = data
							end
							self.globals.resolver_data[target].current = data
							for i = #self.globals.resolver_data[target], 1, -1 do
								if #self.globals.resolver_data[target] > 16 then 
									table.remove(self.globals.resolver_data[target], i)
								end
							end
						end
					end
					--print(self.globals.resolver_data[target].current.eye_angles.y)

					if self.globals.resolver_data[target][1] == nil or self.globals.resolver_data[target][2] == nil or self.globals.resolver_data[target][3] == nil or self.globals.resolver_data[target][6] == nil or self.globals.resolver_data[target][7] == nil then
						return
					end
					
					local yaw_delta = self.helpers:normalize(self.globals.resolver_data[target].current.eye_angles.y - self.globals.resolver_data[target][1].eye_angles.y)
					local yaw_delta2 = self.helpers:normalize(self.globals.resolver_data[target][2].eye_angles.y - self.globals.resolver_data[target][3].eye_angles.y)
					local yaw_delta3 = self.helpers:normalize(self.globals.resolver_data[target][6].eye_angles.y - self.globals.resolver_data[target][7].eye_angles.y)

					if math.abs(yaw_delta) >= 33 then
						self.globals.resolver_data[target].lastyawupdate = globals.tickcount() + 10
						self.globals.resolver_data[target].side = yaw_delta
					end

					if self.globals.resolver_data[target].lastyawupdate == nil then self.globals.resolver_data[target].lastyawupdate = 0 end
					if self.globals.resolver_data[target].lastplistupdate == nil then self.globals.resolver_data[target].lastplistupdate = 0 end
					if self.globals.resolver_data[target].skitterupdate == nil then self.globals.resolver_data[target].skitterupdate = 0 end

					if math.abs(yaw_delta2 - yaw_delta3) > 90 then
						self.globals.resolver_data[target].skitterupdate = globals.tickcount() + 10
					end
					if self.globals.resolver_data[target].skitterupdate - globals.tickcount() > 0 then
						--print("skitter")
						self.state[target] = "SKITTER"
						resolver_flag[target] = "SKITTER"
						if math.abs(yaw_delta2 - yaw_delta3) == 0 then
							plist.set(target, "Force body yaw value", 0)
						else
							plist.set(target, "Force body yaw value", (yaw_delta) > 0 and 60 or -60)
						end
					elseif self.globals.resolver_data[target].lastyawupdate > globals.tickcount() and yaw_delta == 0 and self.globals.resolver_data[target].skitterupdate - globals.tickcount() < 0 then
						plist.set(target, "Force body yaw", true)
						plist.set(target, "Force body yaw value", (self.globals.resolver_data[target].side) > 0 and 60 or -60)
						self.globals.resolver_data[target].lastplistupdate = globals.tickcount() + 10
						self.state[target] = "CENTER"
						resolver_flag[target] = "JITTER"
					elseif math.abs(yaw_delta) >= 33 then
						plist.set(target, "Force body yaw", true)
						plist.set(target, "Force body yaw value", (yaw_delta) > 0 and 60 or -60)
						self.state[target] = "CENTER"
						resolver_flag[target] = "JITTER"
						self.globals.resolver_data[target].lastplistupdate = globals.tickcount() + 10
					elseif self.globals.resolver_data[target].lastplistupdate < globals.tickcount() then
						plist.set(target, "Force body yaw", false)
						self.state[target] = ""
						resolver_flag[target] = ""
					else
						plist.set(target, "Force body yaw", false)
						self.state[target] = ""
						resolver_flag[target] = ""
					end

				end

			end

		end,
	}

	:struct 'defensive' {
		cmd = 0,
		check = 0,
		defensive = 0,
		player_data = {},

		predict = function(self)
			local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
			self.defensive = math.abs(tickbase - self.check)
			self.check = math.max(tickbase, self.check or 0)
			self.cmd = 0
		end,

		reset = function(self)
			self.check, self.defensive = 0, 0
		end,

		defensivestatus = function(self)
			local player = entity.get_local_player()
			if not entity.is_alive(player) then
				return
			end

			local origin = vector(entity.get_prop(entity.get_local_player(), "m_vecOrigin"))
			local simtime = entity.get_prop(player, "m_flSimulationTime")
			local sim_time = self.helpers:time_to_ticks(simtime)
			local player_data = self.player_data[player]
			if player_data == nil then
				self.player_data[player] = {
					last_sim_time = sim_time,
					defensive_active_until = 0,
					origin = origin
				}
			else
				local delta = sim_time - player_data.last_sim_time
				if delta < 0 then
					player_data.defensive_active_until = globals.tickcount() + math.abs(delta)
				elseif delta > 0 then
					player_data.breaking_lc = (player_data.origin - origin):length2dsqr() > 4096
					player_data.origin = origin
				end
				player_data.last_sim_time = sim_time    
			end
		end
	}

	:struct 'net_channel' {
		native_GetNetChannelInfo = vtable_bind("engine.dll", "VEngineClient014", 78, "void* (__thiscall*)(void* ecx)"),
		native_GetLatency = vtable_thunk(9, "float(__thiscall*)(void*, int)"),

		get_lerp_time = function ()
			local ud_rate = cvar.cl_updaterate:get_int()
		
			local min_ud_rate = cvar.sv_minupdaterate:get_int()
			local max_ud_rate = cvar.sv_maxupdaterate:get_int()
		
			if (min_ud_rate and max_ud_rate) then
				ud_rate = max_ud_rate
			end
			local ratio = cvar.cl_interp_ratio:get_float()
		
			if (ratio == 0) then
				ratio = 1
			end
			local lerp = cvar.cl_interp:get_float()
			local c_min_ratio = cvar.sv_client_min_interp_ratio:get_float()
			local c_max_ratio = cvar.sv_client_max_interp_ratio:get_float()
		
			if (c_min_ratio and  c_max_ratio and  c_min_ratio ~= 1) then
				ratio = clamp(ratio, c_min_ratio, c_max_ratio)
			end
			return math.max(lerp, (ratio / ud_rate));
		end
	}

	:struct 'predict' {

		accelerate = function (self, forward, target_speed, velocity)
			local current_speed = velocity.x * forward.x + velocity.y * forward.y + velocity.z * forward.z

			local speed_delta = target_speed - current_speed

			if speed_delta > 0 then
				local acceleration_speed = cvar.sv_accelerate:get_float() * globals.tickinterval() * math.max(250, target_speed)
			
				if acceleration_speed > speed_delta then
					acceleration_speed = speed_delta
				end
			
				velocity = velocity + (acceleration_speed * forward)
			end
		
			return velocity
		end,

		calculate_velocity = function (self, forward, velocity)
			local me = entity.get_local_player()
			local target_speed = 450
			local max_speed = entity.get_prop(me, "m_flMaxspeed")
		
			--local target_velocity = forward:normalized() * math.min(max_speed, target_speed)
		
			velocity = self:accelerate(forward, target_speed, velocity)
		
			if velocity:lengthsqr() > max_speed^2 then
				velocity = (velocity / velocity:length()) * max_speed
			end
		
			return velocity
		end,

		run = function (self, origin, ticks, ent, forward)
			local velocity = vector(entity.get_prop(ent, 'm_vecVelocity'))

			local positions = {}
			for i = 1, ticks do
				velocity = self:calculate_velocity(forward, velocity)
				origin = origin + (velocity * globals.tickinterval())
				positions[i] = origin
			end

			return positions
		end
	}

	:struct 'peekbot' {
		last_target = nil,
		last_tick = 0,
		last_point = vector(),
		active = false,
		was_enabled = false,
		origin = vector(),
		renderpoints = vector(),

		get_target = function (self)
			local me = entity.get_local_player()
			local target = client.current_threat()
			if not target or entity.is_dormant(target) then
				return
			end

			local hitboxes = {}
			for i = 0, 17 do
				hitboxes[i] = vector(entity.hitbox_position(target, i))
			end

			local from = vector(entity.get_origin(me))
			local to = vector(entity.get_origin(target))
			local pitch, yaw, roll = (to - from):angles()

			return {
				ent = target,
				pos = to,
				hitboxes = hitboxes,
				angle = yaw
			}
		end,

		validate_weapon = function(self)
			local me = entity.get_local_player()

			local weapon_ent = entity.get_player_weapon(entity.get_local_player())
			if not weapon_ent then
				return
			end
		
			local weapon = weapons(weapon_ent)
			if not weapon then
				return
			end
		
			if weapon.type == "knife" or weapon.type == "grenade" or weapon.type == "c4" or weapon.type == "taser" then
				return
			end
		
			if math.max(entity.get_prop(weapon_ent, "m_flNextPrimaryAttack"), entity.get_prop(me, "m_flNextAttack")) - globals.tickinterval() - globals.curtime() >= 0 then
				return
			end
		
			if entity.get_prop(weapon_ent, "m_zoomLevel") ~= nil and entity.get_prop(weapon_ent, "m_zoomLevel") == 0 and (weapon.type == "sniper" or weapon.type == "sniperrifle") then
				return false
			end
		
			return true
		end,

		get_max_backtrack = function (self)
			local nci = self.net_channel.native_GetNetChannelInfo()

			if not nci then
				return 0
			end
		
			local sv_maxunlag = cvar.sv_maxunlag:get_float()
			--local is_dead = simtime < math.floor(entity.get_prop(entity.get_local_player(), "m_nTickBase")*globals.tickinterval() - sv_maxunlag)--flDeadTime
			local max_ticks = globals.curtime() - math.floor(entity.get_prop(entity.get_local_player(), "m_nTickBase")*globals.tickinterval() - sv_maxunlag)
		
			local outgoing, incoming = self.net_channel.native_GetLatency(nci, 0), self.net_channel.native_GetLatency(nci, 1)
			local correct = self.helpers:clamp( outgoing + incoming + self.net_channel:get_lerp_time(), 0, sv_maxunlag );
			return self.helpers:clamp(sv_maxunlag + correct*2, 0, max_ticks) / globals.tickinterval()
		end,

		generate_points = function (self, target, ticks, deadzone)
			local me = entity.get_local_player()

			local points = {}
			for _, angle in ipairs({90, -90}) do
				local forward = vector():init_from_angles(0, target.angle + angle, 0)
				local cur_points = self.predict:run(self.origin, ticks - deadzone, me, forward)

				for _,v in ipairs(cur_points) do
					table.insert(points, v)
				end
			end

			return points
		end,

		collide_point = function (self, point)
			local me = entity.get_local_player()
			local min = vector(entity.get_prop(me, 'm_vecMins'))
			local max = vector(entity.get_prop(me, 'm_vecMaxs'))

			local from = vector(entity.get_origin(me)) + vector((min.x + max.x)/2, (min.y + max.y)/2, (min.z + max.z)/2 + 10)
			local to = point + vector((min.x + max.x)/2, (min.y + max.y)/2, (min.z + max.z)/2 + 10)

			local tr = trace.hull(from, to, min, max, {
				skip = me,
				mask = 'MASK_SHOT',
				type = 'TRACE_EVERYTHING'
			})

			return tr.end_pos - vector((min.x + max.x)/2, (min.y + max.y)/2, (min.z + max.z)/2 + 10)
		end,

		get_best_point = function (self, target, points, amount)
			local me = entity.get_local_player()
			local pos = vector(entity.get_origin(me))
			local len = #points

			local best_point = {damage = 0, point = nil, ticks = 0}
			for i = 1, len, len/(amount*2) do
				local i = self.helpers:clamp(math.floor(i + 0.5), 1, len)
				points[i] = self:collide_point(points[i])
				self.renderpoints = points[i]
				local point = points[i] + vector(0, 0, entity.get_prop(me, 'm_vecViewOffset[2]'))

				local best_damage = 0
				local hitbox_pos
				for _, hitbox in ipairs(target.hitboxes) do
					local _, damage = client.trace_bullet(me, point.x, point.y, point.z, hitbox.x, hitbox.y, hitbox.z, me)

					if damage > best_damage then
						best_damage = damage
						hitbox_pos = hitbox
					end
				end

				if best_damage > best_point.damage or (best_point.point and best_damage == best_point.damage and pos:dist2d(best_point.point) > pos:dist2d(points[i]) ) then
					best_point.damage = best_damage
					best_point.point = points[i]
					best_point.hitbox = hitbox_pos
					best_point.ticks = i
				end
			end

			if best_point.ticks > len/2 then
				best_point.ticks = best_point.ticks - len/2
			end

			if not best_point.point then
				return
			end
			
			return best_point
		end,

		can_peek = function (self, target)
			if not target then
				--print('NO TARGET')
				return
			end

			if not self:validate_weapon() then
				--print('CANT SHOOT')
				return
			end
			
			local max_backtrack = self:get_max_backtrack()

			local deadzone = max_backtrack > 24 and 12 or 6
			local points = self:generate_points(target, max_backtrack, deadzone)

			self.available_points = points

			local point_amount = 6
			local best_point = self:get_best_point(target, points, point_amount)

			if not best_point then
				return
			end

			if best_point.damage < math.min(self.helpers:get_damage(), entity.get_prop(target.ent, 'm_iHealth')) then
				return
			end

			--print(best_point.hitbox)

			return {
				tick_time = best_point.ticks,
				tick = max_backtrack - deadzone,
				point = best_point.point,
				hitbox = best_point.hitbox,
				target = target.ent
			}
		end,

		check_safety = function (self, target, point, ticks, allowed_damage)
			if ticks < 14 then
				return
			else
				ticks = ticks - 14
			end

			local me = entity.get_local_player()

			local min = vector(entity.get_prop(target, 'm_vecMins'))
			local max = vector(entity.get_prop(target, 'm_vecMaxs'))

			local origin = vector(entity.get_origin(target)) + vector(0,0, entity.get_prop('m_vecViewOffset[2]'))
			local eye = origin + vector(entity.get_prop(target, 'm_vecVelocity')) * globals.tickinterval() * ticks

			--local tr = trace.hull(origin, eye, min, max, {
			--    skip = target,
			--    mask = 'MASK_SHOT',
			--    type = 'TRACE_EVERYTHING'
			--})

			local fraction = client.trace_line(target, origin.x, origin.y, origin.z, eye.x, eye.y, eye.z)

			eye = origin:lerp(eye, fraction)

			local offset = point - vector(entity.get_origin(me))
			local best_damage = 0
			for i = 2, 8 do
				local hitbox = vector(entity.hitbox_position(me, i)) + offset
				local _, damage = client.trace_bullet(target, eye.x, eye.y, eye.z, hitbox.x, hitbox.y, hitbox.z, target)

				if damage > best_damage then
					best_damage = damage
				end
			end

			return best_damage <= allowed_damage
		end,

		move_to = function (self, cmd, point)
			local me = entity.get_local_player()
			local origin = vector(entity.get_origin(me))
			local _, yaw = origin:to(point):angles()

			cmd.in_forward = 1
			cmd.in_back = 0
			cmd.in_moveleft = 0
			cmd.in_moveright = 0
			cmd.in_speed = 0

			cmd.forwardmove = 800
			cmd.sidemove = 0

			cmd.move_yaw = yaw
		end,

		run = function (self, cmd)
			if not self.ui.menu.misc.aipeek:get() then
				ui.set(self.ref.rage.quickpeek[1], true)
				ui.set(self.ref.rage.quickpeek[2], self.ui.menu.misc.quickpeekmode:get())
				ui.set(self.ref.rage.quickpeek2[1], unpack(self.ui.menu.misc.quickpeekdefault:get()))
				self.was_enabled = false
				return
			end

			ui.set(self.ref.rage.quickpeek[1], true)
			ui.set(self.ref.rage.quickpeek[2], 'Always on')
			ui.set(self.ref.rage.quickpeek2[1], 'Retreat on shot', 'Retreat on key release')

			local me = entity.get_local_player()
			if not self.was_enabled then
				self.origin = vector(entity.get_origin(me))
				self.was_enabled = true
			end

			local target = self:get_target()

			if not self.active then
				local data = self:can_peek(target)
				if data then
					self.tick_time = data.tick_time
					self.last_tick = data.tick + globals.tickcount()
					self.last_target = target.ent
					self.last_point = data.point
					self.last_hitbox = data.hitbox
					self.active = true
				end
			end

			if false and self.active and not self:check_safety(self.last_target, self.last_point, self.tick_time, 25) and self.active then
				self.active = false
				--cmd.discharge_pending = true
				return
			end

			if self.last_tick - globals.tickcount() < 0 or (target and self.last_target ~= target.ent) then
				self.active = false
			end

			if self.active then
				self:move_to(cmd, self.last_point)
			elseif vector(entity.get_origin(me)):dist2d(self.origin) > 32 then
				self:move_to(cmd, self.origin)
			end
		end
	}
	:struct 'visuals' {
		active_fraction2 = 0,
		enabled_fraction = 0,
		origin = vector(),
		point = vector(),
		hitbox = vector(),
		max_delta = 0,
		delta = 0,
		scoped = 0,
		active_fraction = 0,
		inactive_fraction = 0,
		hide_fraction = 0,
		scoped_fraction = 0,
		ap_fraction = 0,
		weapon_fraction = 0,
		fraction = 0,
		render = function(self)
			local me = entity.get_local_player()

			if not me or not entity.is_alive(me) then
				return
			end
			local state = self.helpers:get_state()

			local ss = {client.screen_size()}
			self.ss = {
				x = ss[1],
				y = ss[2]
			}

			local visual_size = self.ui.menu.vis.indicatorfont:get()
	
			local size = ""
			if visual_size == "small" then
				size = "-"
			elseif visual_size == "bold" then
				size = "b"
			elseif visual_size == "normal" then
				size = "c"
			end

			local r, g, b, a = self.ui.menu.vis.indicators:get_color()

			renderer.text(self.ss.x/2, self.ss.y/2 * 1.99, 255, 255, 255, 255, "c-", 0, "AMBANI RECODE")

			local scoped_frac

			if not self.ui.menu.vis.indicators:get() then
				return
			end

			if entity.get_prop(me, "m_bIsScoped") == 1 then
				self.scoped = self.helpers:clamp(self.scoped + globals.frametime()/0.2, 0, 1)
				scoped_frac = self.scoped ^ (1/2)
			else
				self.scoped = self.helpers:clamp(self.scoped - globals.frametime()/0.2, 0, 1)
				scoped_frac = self.scoped ^ 2
			end

			local func = string[size == "-" and "upper" or "lower"]

			local strike_w, strike_h = renderer.measure_text(size, func"ambani recode")

			local weapon_ent = entity.get_player_weapon(me)
			local weapon = entity.get_classname(weapon_ent)
			if weapon ~= nil then
				if weapon:find("Grenade") then
					self.weapon_fraction = self.helpers:clamp(self.weapon_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.weapon_fraction = self.helpers:clamp(self.weapon_fraction - globals.frametime()/0.15, 0, 1)
				end
			end
				--ctx.m_render:glow_module(x/2 + ((strike_w + 2)/2) * scoped_frac - strike_w/2 + 4, y/2 + 20, strike_w - 3, 0, 10, 0, {r, g, b, 100 * math.abs(math.cos(globals.curtime()*2))}, {r, g, b, 100 * math.abs(math.cos(globals.curtime()*2))})
			renderer.text(self.ss.x/2 + ((strike_w + 2)/2) * scoped_frac, self.ss.y/2 + 20, 255, 255, 255, 255-(150*self.weapon_fraction), size .. "c", 0, func"ambani ", func("\a" .. self.helpers:rgba_to_hex( r, g, b, ((255-(150*self.weapon_fraction)) * math.abs(math.cos(globals.curtime()*2)))) .. "recode"))

			local next_attack = entity.get_prop(me, "m_flNextAttack")
			local next_primary_attack = entity.get_prop(entity.get_player_weapon(me), "m_flNextPrimaryAttack")

			local dt_toggled = ui.get(self.ref.rage.dt[1]) and ui.get(self.ref.rage.dt[2])
			local dt_active = not (math.max(next_primary_attack, next_attack) > globals.curtime()) --or (ctx.helpers.defensive and ctx.helpers.defensive > ui.get(ctx.ref.dt_fl))

			if dt_toggled and dt_active then
				self.active_fraction = self.helpers:clamp(self.active_fraction + globals.frametime()/0.15, 0, 1)
			else
				self.active_fraction = self.helpers:clamp(self.active_fraction - globals.frametime()/0.15, 0, 1)
			end

			if self.ui.menu.misc.aipeek:get() then
				self.ap_fraction = self.helpers:clamp(self.ap_fraction + globals.frametime()/0.15, 0, 1)
			else
				self.ap_fraction = self.helpers:clamp(self.ap_fraction - globals.frametime()/0.15, 0, 1)
			end

			if dt_toggled and not dt_active then
				self.inactive_fraction = self.helpers:clamp(self.inactive_fraction + globals.frametime()/0.15, 0, 1)
			else
				self.inactive_fraction = self.helpers:clamp(self.inactive_fraction - globals.frametime()/0.15, 0, 1)
			end

			if ui.get(self.ref.rage.os[1]) and ui.get(self.ref.rage.os[2]) and not dt_toggled then
				self.hide_fraction = self.helpers:clamp(self.hide_fraction + globals.frametime()/0.15, 0, 1)
			else
				self.hide_fraction = self.helpers:clamp(self.hide_fraction - globals.frametime()/0.15, 0, 1)
			end

			if math.max(self.hide_fraction, self.inactive_fraction, self.active_fraction) > 0 then
				self.fraction = self.helpers:clamp(self.fraction + globals.frametime()/0.2, 0, 1)
			else
				self.fraction = self.helpers:clamp(self.fraction - globals.frametime()/0.2, 0, 1)
			end

			local dt_size, dt_h = renderer.measure_text(size, func"DT ")
			local ready_size = renderer.measure_text(size, func"READY")
			renderer.text(self.ss.x/2 + ((dt_size + ready_size + 2)/2) * scoped_frac, self.ss.y/2 + 20 + strike_h, 255, 255, 255, self.active_fraction * (255 - (150*self.weapon_fraction)), size .. "c", dt_size + self.active_fraction * ready_size + 1, func"DT ", func("\a" .. self.helpers:rgba_to_hex(155, 255, 155, 255 * self.active_fraction - (150*self.weapon_fraction)) .. "READY"))

			local charging_size = renderer.measure_text(size, func"CHARGING")
			local ret = self.helpers:animate_text(globals.curtime(), func"CHARGING", 255, 100, 100, 255 - (150*self.weapon_fraction))
			renderer.text(self.ss.x/2 + ((dt_size + charging_size + 2)/2) * scoped_frac, self.ss.y/2 + 20 + strike_h, 255, 255, 255, self.inactive_fraction * (255 - (150*self.weapon_fraction)), size .. "c", dt_size + self.inactive_fraction * charging_size + 1, func"DT ", unpack(ret))

			local hide_size = renderer.measure_text(size, func"HIDE ")
			local active_size = renderer.measure_text(size, func"ACTIVE")
			renderer.text(self.ss.x/2 + ((hide_size + active_size + 2)/2) * scoped_frac, self.ss.y/2 + 20 + strike_h, 255, 255, 255, self.hide_fraction * (255 - (150*self.weapon_fraction)), size .. "c", hide_size + self.hide_fraction * active_size + 1, func"HIDE ", func("\a" .. self.helpers:rgba_to_hex(155, 155, 200, (255 - (150*self.weapon_fraction)) * self.hide_fraction) .. "ACTIVE"))
			
			local ap_size, ap_h = renderer.measure_text(size, func'a-p ')
			renderer.text(self.ss.x/2 + ((ap_size + 2)/2) * scoped_frac, self.ss.y/2 + 20 + strike_h + dt_h * self.helpers:easeInOut(self.fraction), 255, 255, 255, (255 - (150*self.weapon_fraction)) * self.ap_fraction, size .. "c", ap_size * self.ap_fraction, func('a-p'))
			
			local state_size = renderer.measure_text(size, '- ' .. func(state) .. ' -')
			renderer.text(self.ss.x/2 + ((state_size + 2)/2) * scoped_frac, self.ss.y/2 + 20 + (strike_h + dt_h * self.helpers:easeInOut(self.fraction)) + (ap_h * self.helpers:easeInOut(self.ap_fraction)), 255, 255, 255, 255 - (150*self.weapon_fraction), size .. "c", 0, func('- ' .. state .. ' -'))
			
		end
	}

for _, eid in ipairs({
	{
		"load", function()
			ctx.ui:execute()
			ctx.config:setup()
		end
	},
	{
		"setup_command", function(cmd)
			--cmd.force_defensive = 1
			ctx.antiaim:run(cmd)
			ctx.peekbot:run(cmd)
		end
	},
	{
		"shutdown", function()
			ctx.ui:shutdown()
		end
	},
	{
		"run_command", function()
			ctx.helpers:in_ladder()
		end
	},
	{
		"paint", function()
			ctx.visuals:render()
			local me = entity.get_local_player()

			if ctx.ui.menu.misc.aipeek:get() and ctx.peekbot.active then
				ctx.visuals.enabled_fraction = ctx.visuals.helpers:clamp(ctx.visuals.enabled_fraction + globals.frametime()*10, 0, 1)
			else
				ctx.visuals.enabled_fraction = ctx.visuals.helpers:clamp(ctx.visuals.enabled_fraction - globals.frametime()*10, 0, 1)
				return
			end

			ctx.visuals.origin = ctx.visuals.origin:lerp(ctx.peekbot.origin, globals.frametime()*20)
			ctx.visuals.point = ctx.visuals.point:lerp(ctx.peekbot.last_point,  globals.frametime()*20)
			ctx.visuals.hitbox = ctx.visuals.hitbox:lerp(ctx.peekbot.last_hitbox,  globals.frametime()*20)

			local point = vector(renderer.world_to_screen(ctx.visuals.point.x, ctx.visuals.point.y, ctx.visuals.point.z))
			local origin = vector(renderer.world_to_screen(ctx.visuals.origin.x, ctx.visuals.origin.y, ctx.peekbot.origin.z))

			if point.x and point.y and origin.x and origin.y then
				renderer.line(point.x, point.y, origin.x, origin.y, 255, 255, 255, 200 * ctx.visuals.enabled_fraction)
			end

			local mins = vector(entity.get_prop(me, "m_vecMins"))
			local maxs = vector(entity.get_prop(me, "m_vecMaxs"))

			draw_box(ctx.visuals.point, mins, maxs, 255, 255, 255, 150 * ctx.visuals.enabled_fraction)

			local view_offset = entity.get_prop(me, 'm_vecViewOffset[2]')
			local eye = ctx.visuals.point + vector(0,0,view_offset) --vector((mins.x + maxs.x)/2, (mins.y + maxs.y)/2, mins.z + view_offset)
			
			local hitbox_ws = vector(renderer.world_to_screen(ctx.visuals.hitbox.x, ctx.visuals.hitbox.y, ctx.visuals.hitbox.z))
			local eye_ws = vector(renderer.world_to_screen(eye.x, eye.y, eye.z))
			if eye_ws.x and eye_ws.y and hitbox_ws.x and hitbox_ws.y then
				renderer.line(hitbox_ws.x, hitbox_ws.y, eye_ws.x, eye_ws.y, 255, 255, 255, 255 * ctx.visuals.enabled_fraction)
			end
		end
	},
	{
		"paint_ui", function()
			ctx.helpers:menu_visibility(false)
		end
	},
	{
		"pre_render", function()
			ctx.antiaim:animations()
		end
	},
	{
		"predict_command", function()
			ctx.defensive:predict()
		end
	},
	{
		"level_init", function()
			ctx.defensive:reset()
			ctx.antiaim.peeked = 0
			ctx.globals.in_ladder = 0
		end
	},
	{
		"net_update_start", function()
			ctx.resolver:jitterhelper()
		end
	},
	{
		"net_update_end", function()
			ctx.defensive:defensivestatus()
		end
	},
}) do
	if eid[1] == "load" then
		eid[2]()
	else
		client.set_event_callback(eid[1], eid[2])
	end
end
client.register_esp_flag("", 255, 246, 210, function(arg) return resolver_status, resolver_flag[arg] end)
