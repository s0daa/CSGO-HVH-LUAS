local var_0_0 = (function()
	local var_1_0 = require("ffi")
	local var_1_1 = client.find_signature("client.dll", "\xFF\xE1") or client.find_signature("engine.dll", "\xFF\xE1") or client.find_signature("engine.dll", "Q\xC3") or client.find_signature("client.dll", "Q\xC3") or error("sysstats.1")

	local function var_1_2()
		local var_2_0, var_2_1 = pcall(error, "", 4)

		return var_2_1
	end

	local function var_1_3(arg_3_0, arg_3_1)
		if arg_3_0 == nil then
			error(var_1_2() .. " is fucked", 2)
		end

		local var_3_0 = var_1_0.cast(arg_3_1, var_1_1)

		return function(...)
			local var_4_0, var_4_1 = pcall(var_3_0, arg_3_0, ...)

			if not var_4_0 then
				error(var_4_1, 2)
			end

			return var_4_1
		end
	end

	local var_1_4 = var_1_3(var_1_0.cast("void***", var_1_0.cast("uint32_t", client.find_signature("engine.dll", "\xFF\x15\xCC\xCC\xCC̣\xCC\xCC\xCC\xCC\xEB\x05") or error("no")) + 2)[0][0], "void*(__thiscall*)(void*, void*, const char*)")
	local var_1_5 = var_1_3(var_1_0.cast("void***", var_1_0.cast("uint32_t", client.find_signature("engine.dll", "\xFF\x15\xCC\xCC\xCC̅\xC0t\v") or error("no")) + 2)[0][0], "void*(__thiscall*)(void*, const char*)")
	local var_1_6 = var_1_5("kernel32.dll") or error("sysstats.4")
	local var_1_7 = var_1_5("psapi.dll") or error("sysstats.D")
	local var_1_8 = var_1_3(var_1_4(var_1_6, "GlobalMemoryStatusEx") or error("sysstats.6"), "int(__thiscall*)(void*, void*)")
	local var_1_9 = var_1_3(var_1_4(var_1_6, "GetSystemInfo") or error("sysstats.7"), "void(__thiscall*)(void*, void*)")
	local var_1_10 = var_1_3(var_1_4(var_1_7, "GetProcessMemoryInfo") or error("sysstats.D"), "int(__thiscall*)(void*, void*, void*, unsigned long)")
	local var_1_11 = var_1_3(var_1_4(var_1_6, "RegOpenKeyExA") or error("sysstats.9"), "long(__thiscall*)(void*, void*, const char*, unsigned long, unsigned long, void**)")
	local var_1_12 = var_1_3(var_1_4(var_1_6, "RegCloseKey") or error("sysstats.A"), "long(__thiscall*)(void*, void*)")
	local var_1_13 = var_1_3(var_1_4(var_1_6, "RegQueryValueExA") or error("sysstats.B"), "long(__thiscall*)(void*, void*, const char*, unsigned long*, unsigned long*, void*, unsigned long*)")
	local var_1_14 = var_1_3(var_1_4(var_1_6, "GetSystemTimes") or error("sysstats.C"), "int(__thiscall*)(void*, void*, void*, void*)")
	local var_1_15 = var_1_3(var_1_4(var_1_6, "GetProcessTimes") or error("sysstats.E"), "int(__thiscall*)(void*, void*, void*, void*, void*, void*)")
	local var_1_16 = var_1_3(var_1_4(var_1_6, "GetSystemTimeAsFileTime") or error("sysstats.10"), "void(__thiscall*)(void*, void*)")
	local var_1_17 = var_1_0.cast("void*", 2147483650)
	local var_1_18 = 131097
	local var_1_19 = var_1_0.cast("void*", 4294967295)

	local function var_1_20(arg_5_0)
		local var_5_0 = var_1_0.new("wchar_t[?]", #arg_5_0 + 1)

		for iter_5_0 = 1, #arg_5_0 do
			var_5_0[iter_5_0 - 1] = string.byte(string.sub(arg_5_0, iter_5_0, iter_5_0))
		end

		return var_5_0
	end

	local var_1_21 = var_1_0.new("struct {\n    unsigned long length;\n    unsigned long memoryload;\n    unsigned long long totalphys;\n    unsigned long long availphys;\n    unsigned long long totalpagefile;\n    unsigned long long availpagefile;\n    unsigned long long totalvirtual;\n    unsigned long long availvirtual;\n    unsigned long long availextendedvirtual;\n} [1] ")
	local var_1_22 = var_1_0.new("struct {\n    unsigned short processor_arch;\n    unsigned short reserved;\n    unsigned long pagesize;\n    void* minappstartaddr;\n    void* maxappstartaddr;\n    unsigned long* activeprocessormask;\n    unsigned long numprocessors;\n    unsigned long processortype;\n    unsigned long allocationgranularity;\n    unsigned short processorlevel;\n    unsigned short processorrevision;\n} [1] ")
	local var_1_23 = var_1_0.new("struct {\n    unsigned long cb;\n    unsigned long pagefaultcount;\n    unsigned long peakworkingsetsize;\n    unsigned long workingsetsize;\n    unsigned long quotapeakpagedpoolusage;\n    unsigned long quotapagedpoolusage;\n    unsigned long quotapeaknonpagedpoolusage;\n    unsigned long quotanonpagedpoolusage;\n    unsigned long pagefileusage;\n    unsigned long peakpagefileusage;\n    unsigned long privateusage;\n} [1] ")
	local var_1_24 = var_1_0.new("__declspec(align(8)) unsigned long long[10]")

	var_1_23[0].cb = var_1_0.sizeof(var_1_23)
	var_1_21[0].length = var_1_0.sizeof(var_1_21)

	local var_1_25

	local function var_1_26()
		function var_1_26()
			return
		end

		var_1_8(var_1_21)
		var_1_10(var_1_19, var_1_23, var_1_0.sizeof(var_1_23))
		client.set_event_callback("paint_ui", function()
			var_1_8(var_1_21)
			var_1_10(var_1_19, var_1_23, var_1_0.sizeof(var_1_23))
		end)
	end

	local function var_1_27()
		local var_9_0 = tonumber(var_1_21[0].totalphys)
		local var_9_1 = tonumber(var_1_21[0].totalphys - var_1_21[0].availphys)
		local var_9_2 = tonumber(var_1_21[0].availphys)

		return {
			total = var_9_0,
			used = var_9_1,
			available = var_9_2
		}
	end

	local function var_1_28()
		local var_10_0 = tonumber(var_1_23[0].workingsetsize)

		return {
			used = var_10_0
		}
	end

	local var_1_29 = 0
	local var_1_30 = 0
	local var_1_31 = {}
	local var_1_32 = 0.2
	local var_1_33

	local function var_1_34()
		function var_1_34()
			return
		end

		local var_11_0

		local function var_11_1()
			var_1_16(var_1_24)
			var_1_15(var_1_19, var_1_24 + 1, var_1_24 + 2, var_1_24 + 3, var_1_24 + 4)

			local var_13_0 = tonumber(var_1_24[3] + var_1_24[4])
			local var_13_1 = tonumber(var_1_24[0])
			local var_13_2 = tonumber(var_1_24[8] + var_1_24[9])
			local var_13_3 = tonumber(var_1_24[5])

			var_1_29 = (var_13_0 - var_13_2) / (var_13_1 - var_13_3)

			table.insert(var_1_31, var_1_29)

			if #var_1_31 > 1 / var_1_32 * 2 then
				table.remove(var_1_31, 1)
			end

			local var_13_4 = 0

			var_1_29 = 0

			for iter_13_0, iter_13_1 in ipairs(var_1_31) do
				var_13_4 = var_13_4 + 1
				var_1_29 = var_1_29 + iter_13_1
			end

			var_1_29 = var_1_29 / var_13_4
			var_1_24[5] = var_1_24[0]
			var_1_24[6] = var_1_24[1]
			var_1_24[7] = var_1_24[2]
			var_1_24[8] = var_1_24[3]
			var_1_24[9] = var_1_24[4]

			client.delay_call(var_1_32, var_11_1)
		end

		var_1_16(var_1_24 + 5)
		var_1_15(var_1_19, var_1_24 + 6, var_1_24 + 7, var_1_24 + 8, var_1_24 + 9)
		client.delay_call(var_1_32, var_11_1)
		var_1_9(var_1_22)

		local var_11_2 = var_1_0.new("void*[1]")

		if var_1_11(var_1_17, "HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0", 0, var_1_18, var_11_2) ~= 0 then
			print("sysstats cpu information not available.3")

			return
		end

		local var_11_3 = var_1_0.new("unsigned long[1]")
		local var_11_4 = var_1_0.new("unsigned long[1]")

		var_11_4[0] = var_1_0.sizeof(var_11_3)

		if var_1_13(var_11_2[0], "~MHz", nil, nil, var_11_3, var_11_4) ~= 0 then
			print("sysstats cpu information not available.4")
		else
			var_1_30 = var_11_3[0]
		end

		var_1_12(var_11_2[0])
	end

	local function var_1_35(arg_14_0)
		var_1_32 = math.min(1, math.max(0, arg_14_0))
	end

	local function var_1_36()
		return {
			mhz = var_1_30,
			logical_processors = var_1_22[0].numprocessors,
			usage = var_1_29
		}
	end

	return {
		requires_memory_information = var_1_26,
		requires_cpu_information = var_1_34,
		system_memory_information = var_1_27,
		system_cpu_information = var_1_36,
		process_memory_information = var_1_28,
		set_cpu_usage_update_interval = var_1_35
	}
end)()

;(function()
	local var_16_0 = require("gamesense/notifications")
	local var_16_1 = require("gamesense/chat")
	local var_16_2 = require("gamesense/websockets")
	local var_16_3 = require("ffi")

	var_0_0.requires_memory_information()
	var_0_0.requires_cpu_information()

	local var_16_4 = panorama.open().MyPersonaAPI.GetXuid()
	local var_16_5 = 0
	local var_16_6 = {}
	local var_16_7 = {}
	local var_16_8 = var_16_3.typeof("void***")
	local var_16_9 = var_16_3.new("float[1]")
	local var_16_10 = var_16_3.new("float[1]")
	local var_16_11 = var_16_3.new("float[1]")
	local var_16_12 = var_16_3.typeof("void(__thiscall*)(void*, float*, float*, float*)")
	local var_16_13 = client.create_interface("engine.dll", "VEngineClient014") or error("VEngineClient014 wasnt found", 2)
	local var_16_14 = var_16_3.cast(var_16_8, var_16_13) or error("rawivengineclient is nil", 2)
	local var_16_15 = var_16_3.cast("void*(__thiscall*)(void*)", var_16_14[0][78]) or error("ivengineclient is nil")

	local function var_16_16(arg_17_0)
		if arg_17_0 == nil then
			return 0, 0
		end

		local var_17_0 = 0
		local var_17_1 = 0

		var_16_3.cast(var_16_12, arg_17_0[0][25])(arg_17_0, var_16_9, var_16_10, var_16_11)

		if var_16_9 ~= nil and var_16_10 ~= nil and var_16_11 ~= nil and var_16_9[0] > 0 then
			var_17_0 = var_16_10[0] * 1000
			var_17_1 = var_16_9[0] * 1000
		end

		return var_17_1, var_17_0
	end

	local var_16_17 = vtable_bind("engine.dll", "VEngineClient014", 78, "void*(__thiscall*)(void*)")
	local var_16_18 = vtable_thunk(9, "float(__thiscall*)(void*, int)")
	local var_16_19 = vtable_thunk(10, "float(__thiscall*)(void*, int)")
	local var_16_20 = vtable_thunk(11, "float(__thiscall*)(void*, int)")
	local var_16_21 = vtable_thunk(12, "float(__thiscall*)(void*, int)")
	local var_16_22 = vtable_thunk(13, "float(__thiscall*)(void*, int)")
	local var_16_23 = vtable_thunk(14, "float(__thiscall*)(void*, int)")
	local var_16_24 = 0
	local var_16_25 = 0

	local function var_16_26()
		if not entity.get_local_player() then
			var_16_24, var_16_25 = 0, 0

			return
		end

		local var_18_0 = globals.tickcount()

		if var_16_24 ~= 0 then
			var_16_25 = math.min(1 / globals.tickinterval(), var_18_0 - var_16_24)
		end

		var_16_24 = var_18_0

		client.delay_call(1, var_16_26)
	end

	var_16_26()
	cvar.cpu_frequency_monitoring:set_float(1)

	local var_16_27 = client.find_signature("engine.dll", "\xFF\x15\xCC\xCC\xCC̃\xC4\xCC\x0F\x10\b") or error("nope")
	local var_16_28 = var_16_3.cast("double**", var_16_3.cast("unsigned char*", var_16_27) + 21)[0]
	local var_16_29 = var_16_3.cast("void**", var_16_3.cast("unsigned char***", var_16_3.cast("unsigned char*", var_16_27) + 2)[0][0] + 237)[0]

	var_16_28[0] = 1.7976931348623157e+308

	local var_16_30 = var_16_3.cast("struct {\n\tdouble timestamp;\n\tfloat ghz;\n\tfloat percent;\n\tfloat lpercent;\n    }*", var_16_29)
	local var_16_31 = {
		{
			"Frames per second",
			"fps",
			"",
			false,
			{
				0,
				500,
				0,
				false,
				{
					0,
					"Tickrate",
					function()
						return 1 / globals.tickinterval()
					end
				}
			}
		},
		{
			"Frametime",
			"frametime",
			"ms",
			true,
			{
				0,
				100,
				10,
				true
			}
		},
		{
			"Ping / Latency",
			"latency",
			"ms",
			true,
			{
				0,
				250,
				75,
				true
			}
		},
		{
			"Packet loss (avg)",
			"avg_loss",
			"%",
			true,
			{
				0,
				100,
				0,
				true
			}
		},
		{
			"Server FPS",
			"server_fps",
			"",
			false,
			{
				0,
				128,
				0,
				false,
				{
					0,
					"Tickrate",
					function()
						return 1 / globals.tickinterval()
					end
				}
			}
		},
		{
			"Server packet time",
			"svPacket",
			"ms",
			true,
			{
				0,
				50,
				10,
				true
			}
		},
		{
			"Server packet time (var)",
			"svPacketVar",
			"ms",
			true,
			{
				0,
				10,
				5,
				true
			}
		},
		{
			"Packets per second (avg)",
			"avg_packets",
			"/s"
		},
		{
			"Bytes per second (avg)",
			"avg_data",
			"/s"
		},
		{
			"Choke (%)",
			"avg_choke",
			"%"
		},
		{
			"Choked commands",
			"choke",
			""
		},
		{
			"CPU Usage (%)",
			"cpu_used",
			"%",
			true
		},
		{
			"CPU Speed (MHz)",
			"cpu_speed",
			" MHz",
			true
		},
		{
			"CPU Speed (GHz)",
			"cpu_speed_ghz",
			" GHz",
			true
		},
		{
			"RAM Usage (%)",
			"ram_used",
			"%",
			true,
			{
				0,
				100,
				75,
				true
			}
		},
		{
			"RAM Usage (MB)",
			"ram_used_mb",
			" MB",
			true
		},
		{
			"RAM Usage (GB)",
			"ram_used_gb",
			" GB",
			true
		},
		{
			"Entities",
			"entities",
			"",
			true
		}
	}

	local function var_16_32(arg_21_0, arg_21_1, arg_21_2)
		local var_21_0 = {
			"B",
			"KB",
			"MB",
			"GB",
			"TB"
		}
		local var_21_1 = 1

		if arg_21_1 ~= nil then
			for iter_21_0 = 1, #var_21_0 do
				if string.upper(var_21_0[iter_21_0]) == string.upper(arg_21_1) then
					var_21_1 = iter_21_0

					break
				end
			end
		end

		local var_21_2 = arg_21_0

		for iter_21_1 = 1, var_21_1 - 1 do
			var_21_2 = var_21_2 / 1024
		end

		if arg_21_2 then
			return var_21_2
		else
			return string.format("%.2f %s", var_21_2, var_21_0[var_21_1])
		end
	end

	local function var_16_33()
		local var_22_0 = {}

		for iter_22_0, iter_22_1 in pairs(var_16_31) do
			var_22_0[#var_22_0 + 1] = iter_22_1[1]
		end

		return var_22_0
	end

	local function var_16_34(arg_23_0)
		return arg_23_0 * globals.tickinterval() * 1000
	end

	local function var_16_35(arg_24_0, arg_24_1)
		local var_24_0 = {}

		for iter_24_0 = #arg_24_0 - arg_24_1 + 1, #arg_24_0 do
			var_24_0[#var_24_0 + 1] = arg_24_0[iter_24_0]
		end

		return var_24_0
	end

	local function var_16_36(arg_25_0, arg_25_1)
		for iter_25_0, iter_25_1 in ipairs(arg_25_0) do
			if iter_25_1 == arg_25_1 then
				return true
			end
		end

		return false
	end

	local function var_16_37(arg_26_0, arg_26_1, arg_26_2)
		local var_26_0 = string.format("%02X", arg_26_0)
		local var_26_1 = string.format("%02X", arg_26_1)
		local var_26_2 = string.format("%02X", arg_26_2)

		return var_26_0 .. var_26_1 .. var_26_2 .. "FF"
	end

	local function var_16_38(...)
		local var_27_0 = {
			...
		}
		local var_27_1 = {
			255,
			255,
			255
		}
		local var_27_2
		local var_27_3 = "No text"
		local var_27_4 = #var_27_0

		for iter_27_0, iter_27_1 in pairs(var_27_0) do
			if type(iter_27_1) == "table" then
				iter_27_1[1] = iter_27_1[1] or 255
				iter_27_1[2] = iter_27_1[2] or 255
				iter_27_1[3] = iter_27_1[3] or 255
				var_27_1 = iter_27_1
			else
				local var_27_5 = iter_27_1

				client.color_log(var_27_1[1], var_27_1[2], var_27_1[3], var_27_5 .. (iter_27_0 == var_27_4 and "" or "\x00"))
			end
		end
	end

	local function var_16_39(arg_28_0, arg_28_1)
		if #arg_28_0 == 0 then
			error("Data cannot be empty")
		end

		local var_28_0 = #arg_28_0
		local var_28_1 = math.min(var_28_0, arg_28_1 - 1)
		local var_28_2 = {}
		local var_28_3 = math.floor(var_28_0 / var_28_1)

		for iter_28_0 = 1, var_28_1 do
			local var_28_4 = (iter_28_0 - 1) * var_28_3 + 1

			table.insert(var_28_2, arg_28_0[var_28_4])
		end

		table.insert(var_28_2, arg_28_0[var_28_0])

		return var_28_2
	end

	local var_16_40 = {
		ui.get(ui.reference("MISC", "Settings", "Menu color"))
	}
	local var_16_41 = var_16_37(table.unpack(var_16_40))
	local var_16_42 = "\a" .. var_16_41 .. " [FlowStats] \aBDBDBDFF"
	local var_16_43 = {
		info = "\aA9A95FFF [?] \aFFFFFFFF ",
		warn = "\aFFA95FFF ⚠ \aFFFFFFAA "
	}
	local var_16_44 = {
		enabled = ui.new_checkbox("CONFIG", "Lua", var_16_42 .. "Enabled"),
		render_key = ui.new_hotkey("CONFIG", "Lua", var_16_42 .. "Render key", true, 9),
		enabled_graphs = ui.new_multiselect("CONFIG", "Lua", "\n", table.unpack(var_16_33())),
		enabled_view = ui.new_combobox("CONFIG", "Lua", var_16_42 .. "Navigation", "None", "Position & Size", "Elements & Colors", "Data Management", "Notifications", "Labels"),
		minimal_graph = ui.new_checkbox("CONFIG", "Lua", var_16_42 .. "Minimal mode"),
		graph_width = ui.new_slider("CONFIG", "Lua", var_16_42 .. "Graph width", 120, 800, 400, true, "px"),
		graph_height = ui.new_slider("CONFIG", "Lua", var_16_42 .. "Graph height", 15, 250, 30, true, "px"),
		graph_pos_x = ui.new_slider("CONFIG", "Lua", var_16_42 .. "Graph position (x)", 0, 100, 90, true, "%"),
		graph_pos_y = ui.new_slider("CONFIG", "Lua", var_16_42 .. "Graph position (y)", 0, 100, 5, true, "%"),
		text_color_label = ui.new_label("CONFIG", "Lua", var_16_42 .. "Graph text"),
		text_color = ui.new_color_picker("CONFIG", "Lua", var_16_42 .. "Graph text", 255, 255, 255, 255),
		bg_color_label = ui.new_label("CONFIG", "Lua", var_16_42 .. "Graph background"),
		bg_color = ui.new_color_picker("CONFIG", "Lua", var_16_42 .. "Graph background", 0, 0, 0, 185),
		disable_bg_blur = ui.new_checkbox("CONFIG", "Lua", var_16_42 .. "Disable background blur"),
		title_bg_color_label = ui.new_label("CONFIG", "Lua", var_16_42 .. "Graph title background"),
		title_bg_color = ui.new_color_picker("CONFIG", "Lua", var_16_42 .. "Graph title background", 0, 0, 0, 255),
		lines = ui.new_label("CONFIG", "Lua", var_16_42 .. "Graph lines"),
		lines_color = ui.new_color_picker("CONFIG", "Lua", var_16_42 .. "Graph line color", 105, 105, 255, 255),
		disable_points = ui.new_checkbox("CONFIG", "Lua", var_16_42 .. "Disable graph points", 0, 10, 0, true, "px"),
		points_size = ui.new_slider("CONFIG", "Lua", var_16_42 .. "Graph points size", 1, 6, 4, true, "px"),
		points_color_label = ui.new_label("CONFIG", "Lua", var_16_42 .. "Graph all points"),
		points_color = ui.new_color_picker("CONFIG", "Lua", var_16_42 .. "Graph all points", 255, 255, 255, 0),
		points_color_min_label = ui.new_label("CONFIG", "Lua", var_16_42 .. "Graph minimum point"),
		points_color_min = ui.new_color_picker("CONFIG", "Lua", var_16_42 .. "Graph minimum point", 255, 85, 85, 255),
		points_color_max_label = ui.new_label("CONFIG", "Lua", var_16_42 .. "Graph maximum point"),
		points_color_max = ui.new_color_picker("CONFIG", "Lua", var_16_42 .. "Graph maximum point", 85, 255, 85, 255),
		points_color_info_label = ui.new_label("CONFIG", "Lua", var_16_43.info .. "Set the alphas to zero to disable point types."),
		update_frequency = ui.new_slider("CONFIG", "Lua", var_16_42 .. "Update frequency", 0, 64, 1, true, "t"),
		max_indices = ui.new_slider("CONFIG", "Lua", var_16_42 .. "Maximum data points", 2, 2500, 200, true),
		max_indices_info_label = ui.new_label("CONFIG", "Lua", var_16_43.info .. "The maximum number of data points to draw on each graph."),
		spacer_label_i1 = ui.new_label("CONFIG", "Lua", "\n"),
		precision = ui.new_slider("CONFIG", "Lua", var_16_42 .. "Data point precision", 1, 100, 100, true, "%"),
		precision_info_label = ui.new_label("CONFIG", "Lua", var_16_43.info .. "How many data points out of the max data points to sample."),
		precision_warn_label = ui.new_label("CONFIG", "Lua", var_16_43.warn .. "Too high of a precision will impact your FPS significantly."),
		spacer_label_b1 = ui.new_label("CONFIG", "Lua", "\n"),
		notifications_enabled = ui.new_checkbox("CONFIG", "Lua", var_16_42 .. "Enable notifications"),
		notification_locations = ui.new_multiselect("CONFIG", "Lua", "\n", "Notify", "Console", "Chat"),
		notification_frequency = ui.new_slider("CONFIG", "Lua", "\n", 1, 60, 5, true, "s"),
		notification_frequency_type = ui.new_combobox("CONFIG", "Lua", "\n", "Per metric", "All")
	}

	for iter_16_0, iter_16_1 in pairs(var_16_31) do
		local var_16_45 = iter_16_1[1]
		local var_16_46 = iter_16_1[2]
		local var_16_47 = iter_16_1[3]
		local var_16_48 = iter_16_1[5]

		if var_16_48 then
			local var_16_49 = var_16_48[4]
			local var_16_50 = var_16_48[5]

			var_16_44["notification_type_enabled_" .. var_16_46] = ui.new_checkbox("CONFIG", "Lua", var_16_42 .. "When \aFFFFFFFF" .. var_16_45 .. " \aBDBDBDFFgoes " .. (var_16_49 and "above" or "below") .. ":")
			var_16_44["notification_type_threshold_" .. var_16_46] = ui.new_slider("CONFIG", "Lua", "\n", var_16_48[1], var_16_48[2], var_16_48[3], true, var_16_47, 1, var_16_50 and {
				[var_16_50[1]] = var_16_50[2]
			} or nil)
		end
	end

	var_16_44.information_labels = ui.new_checkbox("CONFIG", "Lua", var_16_42 .. "Show information labels")
	var_16_44.warning_labels = ui.new_checkbox("CONFIG", "Lua", var_16_42 .. "Show warning labels")

	local function var_16_51()
		local var_29_0 = ui.get(var_16_44.enabled)
		local var_29_1 = ui.get(var_16_44.enabled_view)
		local var_29_2 = not ui.get(var_16_44.disable_points)
		local var_29_3 = ui.get(var_16_44.notifications_enabled)
		local var_29_4 = var_29_1 == "Position & Size"
		local var_29_5 = var_29_1 == "Elements & Colors"
		local var_29_6 = var_29_1 == "Data Management"
		local var_29_7 = var_29_1 == "Notifications"
		local var_29_8 = var_29_1 == "Labels"
		local var_29_9 = ui.get(var_16_44.information_labels)
		local var_29_10 = ui.get(var_16_44.warning_labels)

		for iter_29_0, iter_29_1 in pairs(var_16_44) do
			if string.find(iter_29_0, "notification_type_enabled") then
				ui.set_visible(iter_29_1, var_29_0 and var_29_7 and var_29_3)
			end

			if string.find(iter_29_0, "notification_type_threshold") then
				local var_29_11 = iter_29_0:gsub("notification_type_threshold_", "")

				ui.set_visible(iter_29_1, var_29_0 and var_29_7 and var_29_3 and ui.get(var_16_44["notification_type_enabled_" .. var_29_11]))
			end
		end

		ui.set_visible(var_16_44.render_key, var_29_0)
		ui.set_visible(var_16_44.enabled_graphs, var_29_0)
		ui.set_visible(var_16_44.enabled_view, var_29_0)
		ui.set_visible(var_16_44.minimal_graph, var_29_0 and var_29_4)
		ui.set_visible(var_16_44.graph_width, var_29_0 and var_29_4)
		ui.set_visible(var_16_44.graph_height, var_29_0 and var_29_4)
		ui.set_visible(var_16_44.graph_pos_x, var_29_0 and var_29_4)
		ui.set_visible(var_16_44.graph_pos_y, var_29_0 and var_29_4)
		ui.set_visible(var_16_44.text_color_label, var_29_0 and var_29_5)
		ui.set_visible(var_16_44.text_color, var_29_0 and var_29_5)
		ui.set_visible(var_16_44.bg_color_label, var_29_0 and var_29_5)
		ui.set_visible(var_16_44.bg_color, var_29_0 and var_29_5)
		ui.set_visible(var_16_44.disable_bg_blur, var_29_0 and var_29_5)
		ui.set_visible(var_16_44.title_bg_color_label, var_29_0 and var_29_5)
		ui.set_visible(var_16_44.title_bg_color, var_29_0 and var_29_5)
		ui.set_visible(var_16_44.lines, var_29_0 and var_29_5)
		ui.set_visible(var_16_44.lines_color, var_29_0 and var_29_5)
		ui.set_visible(var_16_44.disable_points, var_29_0 and var_29_5)
		ui.set_visible(var_16_44.points_size, var_29_0 and var_29_5 and var_29_2)
		ui.set_visible(var_16_44.points_color_label, var_29_0 and var_29_5 and var_29_2)
		ui.set_visible(var_16_44.points_color, var_29_0 and var_29_5 and var_29_2)
		ui.set_visible(var_16_44.points_color_min_label, var_29_0 and var_29_5 and var_29_2)
		ui.set_visible(var_16_44.points_color_min, var_29_0 and var_29_5 and var_29_2)
		ui.set_visible(var_16_44.points_color_max_label, var_29_0 and var_29_5 and var_29_2)
		ui.set_visible(var_16_44.points_color_max, var_29_0 and var_29_5 and var_29_2)
		ui.set_visible(var_16_44.points_color_info_label, var_29_0 and var_29_5 and var_29_2 and var_29_9)
		ui.set_visible(var_16_44.update_frequency, var_29_0 and var_29_6)
		ui.set_visible(var_16_44.max_indices, var_29_0 and var_29_6)
		ui.set_visible(var_16_44.max_indices_info_label, var_29_0 and var_29_6 and var_29_9)
		ui.set_visible(var_16_44.spacer_label_i1, var_29_0 and var_29_6 and var_29_9)
		ui.set_visible(var_16_44.precision, var_29_0 and var_29_6)
		ui.set_visible(var_16_44.precision_info_label, var_29_0 and var_29_6 and var_29_9)
		ui.set_visible(var_16_44.precision_warn_label, var_29_0 and var_29_6 and var_29_10)
		ui.set_visible(var_16_44.spacer_label_b1, var_29_0 and var_29_6 and (var_29_9 or var_29_10))
		ui.set_visible(var_16_44.notifications_enabled, var_29_0 and var_29_7)
		ui.set_visible(var_16_44.notification_locations, var_29_0 and var_29_7 and var_29_3)
		ui.set_visible(var_16_44.notification_frequency, var_29_0 and var_29_7 and var_29_3)
		ui.set_visible(var_16_44.notification_frequency_type, var_29_0 and var_29_7 and var_29_3)
		ui.set_visible(var_16_44.information_labels, var_29_0 and var_29_8)
		ui.set_visible(var_16_44.warning_labels, var_29_0 and var_29_8)
		ui.set_visible(var_16_44.enabled, true)
	end

	var_16_51()

	for iter_16_2, iter_16_3 in pairs(var_16_44) do
		ui.set_callback(iter_16_3, var_16_51)
	end

	local function var_16_52(...)
		var_16_38(var_16_40, "[FlowStats] ", {
			255,
			255,
			255
		}, ...)
	end

	local var_16_53 = "ws://localhost:3000"
	local var_16_54
	local var_16_55 = false
	local var_16_56 = 0
	local var_16_57 = 0

	local function var_16_58(arg_31_0, arg_31_1)
		local var_31_0 = 10^(arg_31_1 or 0)

		return math.floor(arg_31_0 * var_31_0 + 0.5) / var_31_0
	end

	local var_16_59 = 0

	connection = {
		open = function()
			if var_16_54 == nil then
				local var_32_0 = 2500 * var_16_59

				client.delay_call(var_32_0 / 1000, function()
					local var_33_0 = var_16_53

					var_16_2.connect(var_33_0, callbacks)
					var_16_52("Socket | Connecting to ", var_33_0)

					var_16_59 = var_16_59 + 1
				end)
			else
				var_16_52("Socket | Connection already open.")
			end
		end,
		close = function()
			if var_16_54 ~= nil then
				var_16_54:close()
				var_16_52("Socket | Closing connection")
			else
				var_16_52("Socket | No open WebSocket connection.")
			end
		end
	}
	callbacks = {
		open = function(arg_35_0)
			var_16_52("Socket | connection to ", arg_35_0.url, " opened!")
			arg_35_0:send(json.stringify({
				action = "authenticate",
				data = {
					xuid = var_16_4
				}
			}))

			var_16_54 = arg_35_0
		end,
		message = function(arg_36_0, arg_36_1)
			var_16_52("Socket | Got message: ", arg_36_1)

			arg_36_1 = json.parse(arg_36_1)

			if arg_36_1.action then
				if arg_36_1.action == "ping" then
					arg_36_0:send("pong")

					var_16_57 = client.timestamp()
				elseif arg_36_1.action == "ping_result" then
					var_16_56 = client.timestamp() - var_16_57

					var_16_52("latency: ", var_16_56)
				elseif arg_36_1.action == "authenticated" then
					var_16_55 = true
				end
			end
		end,
		close = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
			var_16_52("Socket | Connection closed: code=", arg_37_1, " reason=", arg_37_2, " was_clean=", arg_37_3)

			var_16_54 = nil
			var_16_55 = false

			if not arg_37_3 then
				connection.open()
			end
		end,
		error = function(arg_38_0, arg_38_1)
			var_16_52("Socket | Error: ", arg_38_1)

			var_16_54 = nil
			var_16_55 = false
		end
	}

	local var_16_60 = {
		{
			name = "outgoing",
			index = 0
		},
		{
			name = "incoming",
			index = 1
		}
	}

	function FlowUpdate()
		(function()
			if not entity.get_local_player() then
				return
			end

			local var_40_0 = var_16_17()

			if var_40_0 == nil then
				return
			end

			local var_40_1 = var_16_3.cast("void***", var_16_15(var_16_14)) or error("netchaninfo is nil")
			local var_40_2, var_40_3 = var_16_16(var_40_1)
			local var_40_4 = var_16_30[0]
			local var_40_5 = var_0_0.system_cpu_information()
			local var_40_6 = var_0_0.system_memory_information()
			local var_40_7 = {
				flows = {}
			}

			for iter_40_0, iter_40_1 in ipairs(var_16_60) do
				local var_40_8 = {
					type = iter_40_1.name,
					fps = 1 / globals.absoluteframetime(),
					frametime = globals.absoluteframetime() * 1000,
					latency = var_16_18(var_40_0, iter_40_1.index) * 1000,
					avg_loss = var_16_20(var_40_0, 1),
					avg_data = var_16_22(var_40_0, iter_40_1.index),
					avg_packets = var_16_23(var_40_0, iter_40_1.index),
					server_fps = var_16_25,
					svPacket = var_40_2,
					svPacketVar = var_40_3,
					avg_choke = var_16_21(var_40_0, iter_40_1.index) * 100,
					choke = globals.chokedcommands(),
					cpu_used = var_40_5.usage,
					cpu_speed = var_40_4.ghz * 1000,
					cpu_speed_ghz = var_40_4.ghz,
					ram_used = var_16_58(var_40_6.used / var_40_6.total * 100, 2),
					ram_used_mb = var_16_32(var_40_6.used, "MB", true),
					ram_used_gb = var_16_32(var_40_6.used, "GB", true),
					entities = #entity.get_all()
				}

				var_40_7.flows[#var_40_7.flows + 1] = var_40_8
			end

			if var_16_54 and globals.curtime() - var_16_5 > 1 then
				var_16_54:send(json.stringify({
					action = "flow_stat",
					data = var_40_7
				}))

				var_16_5 = globals.curtime()
			end

			var_40_7.time = var_16_58(globals.curtime() * 1000, 1)
			var_16_6[#var_16_6 + 1] = var_40_7

			if #var_16_6 > 5000 then
				table.remove(var_16_6, 1)
			end

			var_16_7 = var_16_39(var_16_6, ui.get(var_16_44.max_indices) * (ui.get(var_16_44.precision) / 100))
		end)()
		client.delay_call(var_16_34(ui.get(var_16_44.update_frequency)) / 1000, FlowUpdate)
	end

	FlowUpdate()

	local function var_16_61(arg_41_0, arg_41_1)
		return var_16_58(arg_41_0, (arg_41_0 < 1 and 2 or arg_41_0 < 10 and 1 or 0) + (arg_41_1 or 0))
	end

	local function var_16_62(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6, arg_42_7, arg_42_8, arg_42_9)
		local var_42_0 = -69
		local var_42_1 = -69
		local var_42_2 = -69
		local var_42_3 = -69
		local var_42_4 = 0
		local var_42_5 = 0

		for iter_42_0, iter_42_1 in ipairs(arg_42_1) do
			if var_42_0 == -69 or var_42_0 > iter_42_1.x then
				var_42_0 = iter_42_1.x
			end

			if var_42_1 == -69 or var_42_1 < iter_42_1.x then
				var_42_1 = iter_42_1.x
			end

			if var_42_2 == -69 or var_42_2 > iter_42_1.y then
				var_42_2 = iter_42_1.y
			end

			if var_42_3 == -69 or var_42_3 < iter_42_1.y then
				var_42_3 = iter_42_1.y
			end

			var_42_5 = var_42_5 + iter_42_1.y
		end

		local var_42_6 = var_42_5 / #arg_42_1
		local var_42_7 = false
		local var_42_8 = false
		local var_42_9 = var_42_1 - var_42_0
		local var_42_10 = var_42_3 - var_42_2
		local var_42_11 = arg_42_2 / var_42_9
		local var_42_12 = arg_42_3 / var_42_10

		if var_42_12 == math.huge then
			var_42_12 = 1
		end

		local var_42_13 = 25
		local var_42_14, var_42_15, var_42_16, var_42_17 = ui.get(var_16_44.text_color)

		if not arg_42_8 then
			local var_42_18, var_42_19 = renderer.measure_text("l", arg_42_0)

			renderer.rectangle(arg_42_4 - var_42_13, arg_42_5 - var_42_13 * 2, arg_42_2 + var_42_13 * 2, var_42_13, ui.get(var_16_44.title_bg_color))
			renderer.text(arg_42_4 - var_42_13 / 1.5, arg_42_5 - var_42_13 * 2 + var_42_19 / 2, var_42_14, var_42_15, var_42_16, var_42_17, "l", 9999, arg_42_0)
			renderer.text(arg_42_4 - var_42_13 / 2.5 + (arg_42_2 + var_42_13 * 2) - var_42_13, arg_42_5 - var_42_13 * 2 + var_42_19 / 2, var_42_14, var_42_15, var_42_16, var_42_17, "r", 9999, string.format("%s /  %s  /  %s", var_16_61(var_42_2, 1) .. (arg_42_7 or ""), var_16_61(var_42_3, 1) .. (arg_42_7 or ""), var_16_61(var_42_6, 1) .. (arg_42_7 or "")))
		end

		renderer.rectangle(arg_42_4 - var_42_13, arg_42_5 - var_42_13, arg_42_2 + var_42_13 * 2, arg_42_3 + var_42_13 * 2, ui.get(var_16_44.bg_color))

		if not ui.get(var_16_44.disable_bg_blur) then
			renderer.blur(arg_42_4 - var_42_13, arg_42_5 - var_42_13, arg_42_2 + var_42_13 * 2, arg_42_3 + var_42_13 * 2, 1, 1)
		end

		if not arg_42_8 then
			renderer.rectangle(arg_42_4 - var_42_13, arg_42_5 - var_42_13, arg_42_2 + var_42_13 * 2, 1, ui.get(var_16_44.lines_color))
		end

		local var_42_20 = not ui.get(var_16_44.disable_points)
		local var_42_21 = ui.get(var_16_44.points_size)
		local var_42_22 = {
			ui.get(var_16_44.points_color)
		}
		local var_42_23 = {
			ui.get(arg_42_9 and var_16_44.points_color_max or var_16_44.points_color_min)
		}
		local var_42_24 = {
			ui.get(arg_42_9 and var_16_44.points_color_min or var_16_44.points_color_max)
		}

		for iter_42_2, iter_42_3 in ipairs(arg_42_1) do
			local var_42_25 = false
			local var_42_26 = arg_42_4 + (iter_42_3.x - var_42_0) / var_42_9 * arg_42_2
			local var_42_27 = arg_42_5 + arg_42_3 - (iter_42_3.y - var_42_2) * var_42_12
			local var_42_28 = var_16_61(iter_42_3.y)
			local var_42_29 = var_16_61(iter_42_3.y, 1)

			if iter_42_2 > 1 then
				local var_42_30 = arg_42_1[iter_42_2 - 1]
				local var_42_31 = arg_42_4 + (var_42_30.x - var_42_0) / var_42_9 * arg_42_2
				local var_42_32 = arg_42_5 + arg_42_3 - (var_42_30.y - var_42_2) * var_42_12

				renderer.line(var_42_31, var_42_32, var_42_26, var_42_27, ui.get(var_16_44.lines_color))
			end

			if not var_42_7 and iter_42_3.y == var_42_2 and var_42_2 ~= var_42_3 then
				var_42_7 = true

				local var_42_33 = var_42_26
				local var_42_34 = var_42_27 + 12

				renderer.text(var_42_33, var_42_34, var_42_14, var_42_15, var_42_16, var_42_17, "c", 0, tostring(var_42_29) .. (arg_42_7 or ""))

				if not var_42_25 and var_42_20 and var_42_21 > 0 and var_42_23[4] > 25 then
					renderer.rectangle(var_42_26 - var_42_21 / 2, var_42_27 - var_42_21 / 2, var_42_21, var_42_21, table.unpack(var_42_23))

					var_42_25 = true
				end
			end

			if #arg_42_1 <= 10 and iter_42_3.y ~= var_42_2 or var_42_3 ~= var_42_2 and not var_42_8 and iter_42_3.y == var_42_3 then
				var_42_8 = true

				local var_42_35 = var_42_26
				local var_42_36 = var_42_27 - 12

				renderer.text(var_42_35, var_42_36, var_42_14, var_42_15, var_42_16, var_42_17, "c", 0, tostring(var_42_29) .. (arg_42_7 or ""))

				if not var_42_25 and var_42_20 and var_42_21 > 0 and var_42_24[4] > 25 then
					renderer.rectangle(var_42_26 - var_42_21 / 2, var_42_27 - var_42_21 / 2, var_42_21, var_42_21, table.unpack(var_42_24))

					var_42_25 = true
				end
			end

			if not var_42_25 and var_42_20 and var_42_21 > 0 and var_42_22[4] > 25 then
				renderer.rectangle(var_42_26 - var_42_21 / 2, var_42_27 - var_42_21 / 2, var_42_21, var_42_21, table.unpack(var_42_22))
			end

			if iter_42_2 == 1 and (iter_42_3.y ~= var_42_2 or iter_42_3.y ~= var_42_3) then
				local var_42_37 = var_42_26 - 12
				local var_42_38 = var_42_27

				renderer.text(var_42_37, var_42_38, var_42_14, var_42_15, var_42_16, var_42_17, "c", 0, tostring(var_42_28))
			end

			if iter_42_2 == #arg_42_1 and (iter_42_3.y ~= var_42_2 or iter_42_3.y ~= var_42_3) then
				local var_42_39 = var_42_26 + 12
				local var_42_40 = var_42_27

				renderer.text(var_42_39, var_42_40, var_42_14, var_42_15, var_42_16, var_42_17, "c", 0, tostring(var_42_28))
			end
		end

		if arg_42_6 then
			for iter_42_4, iter_42_5 in ipairs(arg_42_1) do
				local var_42_41 = arg_42_4 + (iter_42_5.x - var_42_0) / var_42_9 * arg_42_2
				local var_42_42 = arg_42_5 + arg_42_3
				local var_42_43 = tostring(var_16_58(iter_42_5.x - arg_42_1[1].x, 1) + 1)
				local var_42_44, var_42_45 = renderer.measure_text("c", 0, var_42_43)
				local var_42_46 = var_42_41 - var_42_44 / 2 / 2
				local var_42_47 = var_42_42 + 10

				if iter_42_4 % 5 == 0 then
					renderer.text(var_42_46, var_42_47, var_42_14, var_42_15, var_42_16, var_42_17, "c", 0, var_42_43)
				end
			end
		end

		if arg_42_3 >= 50 then
			renderer.line(arg_42_4, arg_42_5 + arg_42_3, arg_42_4 + arg_42_2, arg_42_5 + arg_42_3, 255, 255, 255, 127.5)
			renderer.line(arg_42_4, arg_42_5 + arg_42_3, arg_42_4, arg_42_5, 255, 255, 255, 127.5)
		end
	end

	local var_16_63 = {}

	client.set_event_callback("paint", function()
		if not ui.get(var_16_44.enabled) then
			return
		end

		local var_43_0, var_43_1 = client.screen_size()
		local var_43_2 = ui.get(var_16_44.graph_width) < 250 and true or ui.get(var_16_44.minimal_graph)
		local var_43_3 = ui.get(var_16_44.graph_width)
		local var_43_4 = ui.get(var_16_44.graph_height)
		local var_43_5 = var_43_0 * ui.get(var_16_44.graph_pos_x) / 100
		local var_43_6 = var_43_1 * ui.get(var_16_44.graph_pos_y) / 100
		local var_43_7 = globals.curtime()
		local var_43_8 = ui.get(var_16_44.notification_locations)
		local var_43_9 = ui.get(var_16_44.notification_frequency)
		local var_43_10 = ui.get(var_16_44.notification_frequency_type)
		local var_43_11 = 0

		for iter_43_0, iter_43_1 in ipairs(var_16_31) do
			local var_43_12 = iter_43_1[1]
			local var_43_13 = iter_43_1[2]
			local var_43_14 = iter_43_1[3]
			local var_43_15 = iter_43_1[4]
			local var_43_16 = iter_43_1[5]
			local var_43_17 = {}

			for iter_43_2, iter_43_3 in pairs(ui.get(var_16_44.precision) == 100 and var_16_35(var_16_6, ui.get(var_16_44.max_indices)) or var_16_7) do
				var_43_17[#var_43_17 + 1] = {
					x = iter_43_3.time,
					y = iter_43_3.flows[1][var_43_13]
				}
			end

			if ui.get(var_16_44.render_key) and var_16_36(ui.get(var_16_44.enabled_graphs), var_43_12) then
				var_43_11 = var_43_11 + 1

				var_16_62(var_43_12, var_43_17, var_43_3, var_43_4, var_43_5 - (var_43_3 + 25) / 2, var_43_6 - 30 + (var_43_4 + (var_43_2 and 60 or 90)) * var_43_11, false, var_43_14, var_43_2, var_43_15 or false)
			end

			if ui.get(var_16_44.notifications_enabled) and var_43_16 and ui.get(var_16_44["notification_type_enabled_" .. var_43_13]) then
				local var_43_18 = var_43_16[5]
				local var_43_19 = ui.get(var_16_44["notification_type_threshold_" .. var_43_13])

				if var_43_18 and var_43_19 == var_43_18[1] then
					var_43_19 = var_43_18[3]()
				end

				if var_43_17[#var_43_17] then
					local var_43_20 = var_43_17[#var_43_17].y

					if var_43_20 ~= nil then
						local var_43_21 = var_43_16[4]
						local var_43_22

						if var_43_21 then
							var_43_22 = var_43_19 < var_43_20
						else
							var_43_22 = var_43_20 < var_43_19
						end

						local var_43_23 = (var_16_63[var_43_10 == "All" and "any" or var_43_13] or 0) < var_43_7 - var_43_9

						if var_43_22 and var_43_23 then
							if var_16_36(var_43_8, "Notify") then
								var_16_0.add("FlowStats", ("The {menu}%s {default}metric has gone %s {menu}%s {default}(is currently at {menu}%s{default})"):format(var_43_12, var_43_21 and "above" or "below", var_43_18 and var_43_18[2] or var_43_19 .. var_43_14, var_16_61(var_43_20, 2) .. var_43_14), 7500, "warning")
							end

							if var_16_36(var_43_8, "Console") then
								var_16_52("The ", var_16_40, var_43_12, {
									255,
									255,
									255
								}, " metric has gone " .. (var_43_21 and "above" or "below") .. " ", var_16_40, var_43_18 and var_43_18[2] or var_43_19 .. var_43_14, {
									255,
									255,
									255
								}, " (is currently at ", var_16_40, var_16_61(var_43_20, 2) .. var_43_14, {
									255,
									255,
									255
								}, ")")
							end

							if var_16_36(var_43_8, "Chat") then
								local var_43_24 = ("{blue}[FlowStats] {white}The {lime}%s {white}metric has gone %s {orange}%s%s{white} (is {orange}%s%s{white})"):format(var_43_12, var_43_21 and "above" or "below", var_43_18 and var_43_18[2] or var_43_19, var_43_18 and "" or var_43_14, var_16_61(var_43_20, 2), var_43_14)

								var_16_1.print(var_43_24)
							end

							var_16_63.any = var_43_7
							var_16_63[var_43_13] = var_43_7
						end
					end
				end
			end
		end
	end)
	client.set_event_callback("player_connect_full", function(arg_44_0)
		if client.userid_to_entindex(arg_44_0.userid) ~= entity.get_local_player() then
			return
		end

		var_16_6 = {}
		var_16_7 = {}
	end)
end)()
