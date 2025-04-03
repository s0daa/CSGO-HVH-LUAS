local var_0_0 = require("gamesense/named_pipes")
local var_0_1 = require("ffi")
local var_0_2 = var_0_1.cast
local var_0_3 = vtable_bind("engine.dll", "VEngineClient014", 26, "bool(__thiscall*)(void*)")
local var_0_4 = vtable_bind("engine.dll", "VEngineClient014", 27, "bool(__thiscall*)(void*)")
local var_0_5 = vtable_bind("engine.dll", "VEngineClient014", 28, "bool(__thiscall*)(void*)")
local var_0_6 = 0
local var_0_7 = 1
local var_0_8 = 2
local var_0_9 = 3
local var_0_10 = 4
local var_0_11 = {
	join_request = "ACTIVITY_JOIN_REQUEST",
	spectate_game = "ACTIVITY_SPECTATE",
	join_game = "ACTIVITY_JOIN"
}
local var_0_12 = {
	ERRORED = "error"
}

local function var_0_13(arg_1_0, arg_1_1)
	if arg_1_0 == arg_1_1 then
		return true
	elseif type(arg_1_0) == "table" and type(arg_1_1) == "table" then
		for iter_1_0, iter_1_1 in pairs(arg_1_0) do
			local var_1_0 = arg_1_1[iter_1_0]

			if var_1_0 == nil then
				return false
			elseif iter_1_1 ~= var_1_0 then
				if type(iter_1_1) == "table" and type(var_1_0) == "table" then
					if not var_0_13(iter_1_1, var_1_0) then
						return false
					end
				else
					return false
				end
			end
		end

		for iter_1_2, iter_1_3 in pairs(arg_1_1) do
			if arg_1_0[iter_1_2] == nil then
				return false
			end
		end

		return true
	end

	return false
end

local function var_0_14(arg_2_0, ...)
	local var_2_0 = {
		...
	}

	for iter_2_0 = 1, #var_2_0 do
		if arg_2_0 == nil then
			return nil
		end

		arg_2_0 = arg_2_0[var_2_0[iter_2_0]]
	end

	return arg_2_0 or nil
end

local function var_0_15()
	local var_3_0 = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

	return (string.gsub(var_3_0, "[xy]", function(arg_4_0)
		local var_4_0 = arg_4_0 == "x" and math.random(0, 15) or math.random(8, 11)

		return string.format("%x", var_4_0)
	end))
end

local function var_0_16(arg_5_0)
	return var_0_1.string(var_0_1.cast("const char*", var_0_1.new("uint32_t[1]", arg_5_0)), 4)
end

local function var_0_17(arg_6_0)
	return tonumber(var_0_1.cast("uint32_t*", var_0_1.cast("const char*", arg_6_0))[0])
end

local function var_0_18(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1:len()

	return var_0_16(arg_7_0) .. var_0_16(var_7_0) .. arg_7_1
end

local function var_0_19(arg_8_0)
	local var_8_0 = arg_8_0:read(8)

	if var_8_0 == nil then
		return
	end

	local var_8_1 = var_0_17(var_8_0:sub(1, 4))
	local var_8_2 = var_0_17(var_8_0:sub(5, 8))
	local var_8_3 = arg_8_0:read(var_8_2)

	if var_8_3 == nil then
		return
	end

	local var_8_4 = json.parse(var_8_3)

	return var_8_1, var_8_4
end

local var_0_20 = {}

local function var_0_21(arg_9_0, arg_9_1, ...)
	if arg_9_0.event_handlers[arg_9_1] ~= nil then
		arg_9_0.event_handlers[arg_9_1](arg_9_0, ...)
	end
end

local function var_0_22(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_0.pipe ~= nil then
		local var_10_0, var_10_1 = pcall(arg_10_0.pipe.write, arg_10_0.pipe, var_0_18(arg_10_1, arg_10_2))

		if not var_10_0 then
			arg_10_0.pipe = nil
			arg_10_0.open = false
			arg_10_0.ready = false

			var_0_21(arg_10_0, "error", var_10_1)
		else
			return true
		end
	end
end

local function var_0_23(arg_11_0)
	if arg_11_0.pipe == nil then
		local var_11_0
		local var_11_1
		local var_11_2

		for iter_11_0 = 0, 10 do
			var_11_0, var_11_1 = pcall(var_0_0.open_pipe, "\\\\?\\pipe\\discord-ipc-" .. iter_11_0)

			if var_11_0 then
				break
			end

			if var_11_2 == nil or var_11_1 ~= "Failed to open pipe: File not found" then
				var_11_2 = var_11_1
			end
		end

		if var_11_0 then
			arg_11_0.pipe = var_11_1
			arg_11_0.open = true
			arg_11_0.ready = false

			local var_11_3 = string.format("{\"v\":1,\"client_id\":%s}", json.stringify(arg_11_0.client_id))

			arg_11_0:write(var_0_6, var_11_3)
		else
			var_0_21(arg_11_0, "failed", var_11_2:gsub("^Failed to open pipe: ", ""))
		end
	end
end

local function var_0_24(arg_12_0)
	if arg_12_0.pipe ~= nil then
		arg_12_0:write(var_0_8, string.format("{\"v\":1,\"client_id\":%s}", json.stringify(arg_12_0.client_id)))

		local var_12_0, var_12_1 = pcall(var_0_0.close_pipe, arg_12_0.pipe)

		arg_12_0.pipe = nil
		arg_12_0.open = false
		arg_12_0.ready = false

		var_0_21(arg_12_0, "closed")

		if var_12_0 then
			return true
		end
	end

	return false
end

local function var_0_25(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = arg_13_2 == nil and "" or string.format("\"args\":%s,", json.stringify(arg_13_2))
	local var_13_1 = arg_13_3 == nil and "" or string.format("\"evt\":%s,", json.stringify(arg_13_3))
	local var_13_2 = var_0_15()
	local var_13_3 = string.format("{\"cmd\":%s,%s%s\"nonce\":%s}", json.stringify(arg_13_1), var_13_0, var_13_1, json.stringify(var_13_2))

	if arg_13_4 ~= nil then
		arg_13_0.request_callbacks[var_13_2] = arg_13_4
	end

	arg_13_0:write(var_0_7, var_13_3)
end

local function var_0_26(arg_14_0)
	if arg_14_0.timestamp_delta_max ~= nil and arg_14_0.timestamp_delta_max > 0 then
		if type(var_0_14(arg_14_0.activity, "timestamps", "start")) == "number" and type(var_0_14(arg_14_0.activity_prev, "timestamps", "start")) == "number" and math.abs(arg_14_0.activity_prev.timestamps.start - arg_14_0.activity.timestamps.start) < arg_14_0.timestamp_delta_max then
			arg_14_0.activity.timestamps.start = arg_14_0.activity_prev.timestamps.start
		end

		if type(var_0_14(arg_14_0.activity, "timestamps", "end")) == "number" and type(var_0_14(arg_14_0.activity_prev, "timestamps", "end")) == "number" and math.abs(arg_14_0.activity_prev.timestamps["end"] - arg_14_0.activity.timestamps["end"]) < arg_14_0.timestamp_delta_max then
			arg_14_0.activity.timestamps["end"] = arg_14_0.activity_prev.timestamps["end"]
		end
	end

	if arg_14_0.ready and not var_0_13(arg_14_0.activity, arg_14_0.activity_prev) then
		local var_14_0

		if arg_14_0.activity ~= nil and arg_14_0.activity.assets ~= nil and (arg_14_0.activity.assets.small_image ~= nil or arg_14_0.activity.assets.large_image ~= nil) then
			var_14_0 = {
				small_image = arg_14_0.activity.assets.small_image,
				large_image = arg_14_0.activity.assets.large_image
			}
		end

		arg_14_0:request("SET_ACTIVITY", {
			pid = 4,
			activity = arg_14_0.activity
		}, nil, function(arg_15_0, arg_15_1)
			if var_14_0 ~= nil and arg_15_1.evt == json.null then
				local var_15_0 = false

				for iter_15_0, iter_15_1 in pairs(var_14_0) do
					if arg_15_1.data.assets[iter_15_0] == nil and not arg_15_0.failed_images[iter_15_1] then
						arg_15_0.failed_images[iter_15_1] = true

						var_0_21(arg_15_0, "image_failed_to_load", iter_15_1)
					end
				end
			end
		end)

		arg_14_0.activity_prev = arg_14_0.activity
	end
end

local function var_0_27(arg_16_0)
	if arg_16_0.pipe == nil then
		return
	end

	for iter_16_0 = 1, 100 do
		local var_16_0, var_16_1, var_16_2 = pcall(var_0_19, arg_16_0.pipe)

		if not var_16_0 then
			arg_16_0.pipe = nil
			arg_16_0.open = false
			arg_16_0.ready = false

			var_0_21(arg_16_0, "error", var_16_1)

			return
		elseif var_16_1 == nil then
			break
		elseif var_16_1 == var_0_7 and var_16_2.cmd == "DISPATCH" then
			if type(var_16_2.evt) == "string" then
				local var_16_3 = var_0_12[var_16_2.evt] or var_16_2.evt:lower()

				var_0_21(arg_16_0, var_16_3, var_16_2.data)

				if var_16_2.evt == "READY" then
					arg_16_0:update_event_handlers()

					arg_16_0.ready = true

					var_0_26(arg_16_0)
				end
			end
		elseif var_16_1 == var_0_7 then
			local var_16_4 = arg_16_0.request_callbacks[var_16_2.nonce]

			if var_16_4 ~= nil then
				arg_16_0.request_callbacks[var_16_2.nonce] = nil

				var_16_4(arg_16_0, var_16_2)
			end
		elseif var_16_1 == var_0_9 then
			var_0_22(arg_16_0, var_0_10, "")
		elseif var_16_1 == var_0_8 then
			arg_16_0.pipe = nil
			arg_16_0.open = false
			arg_16_0.ready = false

			var_0_21(arg_16_0, "error", var_16_1)
		end
	end
end

local function var_0_28(arg_17_0, arg_17_1)
	arg_17_0.activity = arg_17_1

	var_0_26(arg_17_0)
end

local function var_0_29(arg_18_0)
	for iter_18_0, iter_18_1 in pairs(var_0_11) do
		if not arg_18_0.event_handlers_subscribed[iter_18_0] and arg_18_0.event_handlers[iter_18_0] ~= nil then
			arg_18_0:request("SUBSCRIBE", nil, iter_18_1)

			arg_18_0.event_handlers_subscribed[iter_18_0] = true
		elseif arg_18_0.event_handlers_subscribed[iter_18_0] and arg_18_0.event_handlers[iter_18_0] == nil then
			arg_18_0:request("UNSUBSCRIBE", nil, iter_18_1)

			arg_18_0.event_handlers_subscribed[iter_18_0] = false
		end
	end
end

client.set_event_callback("paint_ui", function()
	for iter_19_0 = 1, #var_0_20 do
		var_0_27(var_0_20[iter_19_0])
	end
end)

local var_0_30 = {
	__index = {
		connect = var_0_23,
		close = var_0_24,
		request = var_0_25,
		write = var_0_22,
		set_activity = var_0_28,
		update_event_handlers = var_0_29
	}
}

local function var_0_31(arg_20_0, arg_20_1)
	local var_20_0 = setmetatable({
		ready = false,
		timestamp_delta_max = 300,
		client_id = arg_20_0,
		event_handlers = {},
		event_handlers_subscribed = {},
		failed_images = {},
		request_callbacks = {}
	}, var_0_30)

	for iter_20_0, iter_20_1 in pairs(arg_20_1) do
		var_20_0.event_handlers[iter_20_0] = iter_20_1
	end

	table.insert(var_0_20, var_20_0)

	return var_20_0
end

local var_0_32 = vtable_bind("engine.dll", "VEngineClient014", 78, "void*(__thiscall*)(void*)")
local var_0_33 = vtable_thunk(1, "const char*(__thiscall*)(void*)")
local var_0_34 = vtable_thunk(6, "bool(__thiscall*)(void*)")
local var_0_35 = panorama.open()
local var_0_36 = var_0_35.LobbyAPI
local var_0_37 = var_0_35.PartyListAPI
local var_0_38 = var_0_35.GameStateAPI
local var_0_39 = var_0_35.FriendsListAPI
local var_0_40 = 0
local var_0_41 = 1
local var_0_42 = 2
local var_0_43 = 3
local var_0_44 = 4
local var_0_45 = 5
local var_0_46 = panorama.loadstring("\treturn {\n\t\tlocalize: (str, params) => {\n\t\t\tif(params == null)\n\t\t\t\treturn $.Localize(str)\n\n\t\t\tvar panel = $.CreatePanel(\"Panel\", $.GetContextPanel(), \"\")\n\n\t\t\tfor(key in params) {\n\t\t\t\tpanel.SetDialogVariable(key, params[key])\n\t\t\t}\n\n\t\t\tvar result = $.Localize(str, panel)\n\n\t\t\tpanel.DeleteAsync(0.0)\n\n\t\t\treturn result\n\t\t}\n\t}\n")().localize
local var_0_47 = {}

local function var_0_48(arg_21_0, arg_21_1)
	if arg_21_0 == nil then
		return ""
	end

	if var_0_47[arg_21_0] == nil then
		var_0_47[arg_21_0] = {}
	end

	local var_21_0 = arg_21_1 ~= nil and json.stringify(arg_21_1) or true

	if var_0_47[arg_21_0][var_21_0] == nil then
		var_0_47[arg_21_0][var_21_0] = var_0_46(arg_21_0, arg_21_1)
	end

	return var_0_47[arg_21_0][var_21_0]
end

local var_0_49 = setmetatable({
	["Playing CS:GO"] = "In Game",
	HauptmenÜ = "Im Hauptmenü",
	["Main Menu"] = "In Main Menu",
	Offline = "Local Server",
	["Practice With Bots"] = "Local Server"
}, {
	__index = function(arg_22_0, arg_22_1)
		arg_22_0[arg_22_1] = arg_22_1

		return arg_22_1
	end
})
local var_0_50 = panorama.loadstring("return Date.now()/1000")() - globals.realtime()

local function var_0_51()
	return math.floor(var_0_50 + globals.realtime() + 0.5)
end

local function var_0_52(arg_24_0)
	local var_24_0 = {}

	for iter_24_0 = 1, #arg_24_0 do
		var_24_0[arg_24_0[iter_24_0]] = true
	end

	return var_24_0
end

local function var_0_53(arg_25_0)
	local var_25_0 = var_0_38.GetMapDisplayNameToken(arg_25_0)

	if arg_25_0 == var_25_0 then
		return arg_25_0
	end

	return var_0_48(var_25_0)
end

local function var_0_54(arg_26_0)
	if arg_26_0:find("ag_texture") then
		return "aim_ag_texture2"
	elseif arg_26_0:find("dust2") then
		return "de_dust2"
	elseif arg_26_0:find("dust") then
		return "de_dust"
	elseif arg_26_0:find("mirage") then
		return "de_mirage"
	end

	return arg_26_0:gsub("_scrimmagemap$", "")
end

local function var_0_55(arg_27_0)
	return arg_27_0:sub(1, 1) .. arg_27_0:sub(2, -1):lower()
end

local function var_0_56(arg_28_0)
	return arg_28_0:gsub("%u%u+", var_0_55)
end

local var_0_57 = ui.new_checkbox("MISC", "Miscellaneous", "Discord Rich Presence")
local var_0_58 = ui.new_multiselect("MISC", "Miscellaneous", "Rich Presence Options", {
	"Custom Text",
	"Hide gamesense.pub"
})
local var_0_59 = ui.new_textbox("MISC", "Miscellaneous", "2nd Line Text")
local var_0_60 = ui.new_label("MISC", "Miscellaneous", "Status: Not connected")
local var_0_61 = ui.new_string("Discord RPC custom text")

local function var_0_62(arg_29_0)
	if arg_29_0 ~= nil then
		ui.set(var_0_60, "> " .. arg_29_0)
		ui.set_visible(var_0_60, ui.get(var_0_57))
	else
		ui.set(var_0_60, "")
		ui.set_visible(var_0_60, false)
	end
end

var_0_62(nil)

local var_0_63
local var_0_64 = 0
local var_0_65 = globals.realtime() + 5
local var_0_66 = "^" .. var_0_48("SFUI_Scoreboard_ServerName", {
	s1 = "(.*)"
}) .. "$"
local var_0_67 = var_0_48("SFUI_PlayMenu_Online"):gsub(".", function(arg_30_0)
	return string.format("[%s%s]", arg_30_0:lower(), arg_30_0:upper())
end)

local function var_0_68()
	local var_31_0 = var_0_52(ui.get(var_0_58))
	local var_31_1 = {
		instance = true,
		assets = {
			large_image = "csgo-logo2",
			large_text = "Counter-Strike: Global Offensive"
		}
	}

	if not var_31_0["Hide gamesense.pub"] then
		var_31_1.assets.small_image = "gamesense"
		var_31_1.assets.small_text = "gamesense.pub"
	end

	local var_31_2 = globals.mapname()

	if var_31_2 ~= nil then
		local var_31_3 = var_0_32()
		local var_31_4 = entity.get_game_rules()

		if var_31_0["Custom Text"] then
			local var_31_5 = ui.get(var_0_61)

			if var_31_5:gsub(" ", "") ~= "" then
				var_31_1.state = var_31_5
			end
		else
			var_31_1.state = var_0_49[var_0_48("SFUI_Lobby_StatusPlayingCSGO")]

			if var_31_3 ~= nil then
				if var_0_34(var_31_3) then
					var_31_1.state = var_0_49[var_0_48("play_setting_offline")]
				elseif var_0_38.IsDemoOrHltv() then
					var_31_1.state = var_0_48("SFUI_Lobby_StatusWatchingCSGO")
				elseif var_31_4 ~= nil and entity.get_prop(var_31_4, "m_bIsValveDS") == 1 then
					var_31_1.state = var_0_49[var_0_48("play_setting_online"):gsub(var_0_67, var_0_48("Panorama_Vote_Server"))]
				elseif var_0_38.GetServerName() ~= "" then
					var_31_1.state = var_0_38.GetServerName():match(var_0_66)
				end
			end
		end

		local var_31_6 = json.parse(tostring(var_0_38.GetTimeDataJSO()))
		local var_31_7 = globals.curtime()
		local var_31_8
		local var_31_9
		local var_31_10 = var_0_38.GetGameModeName(true)

		if var_31_6.gamephase == var_0_40 or var_31_6.gamephase == var_0_44 then
			var_31_1.details = string.format("%s [%s]", var_31_10, var_0_48("gamephase_" .. var_31_6.gamephase))

			if var_31_6.gamephase == var_0_40 and var_31_6.time ~= nil then
				var_31_8 = var_31_7 - cvar.mp_warmuptime:get_float() + var_31_6.time
				var_31_9 = var_31_8 + cvar.mp_warmuptime:get_float()
			end
		elseif var_31_6.gamephase == var_0_45 then
			local var_31_11 = entity.get_local_player()
			local var_31_12
			local var_31_13

			if var_31_11 ~= nil and entity.get_prop(var_31_11, "m_iTeamNum") == 2 then
				if entity.get_prop(var_31_11, "m_iTeamNum") == 2 then
					var_31_12, var_31_13 = "TERRORIST", "CT"
				elseif entity.get_prop(var_31_11, "m_iTeamNum") == 3 then
					var_31_12, var_31_13 = "CT", "TERRORIST"
				end
			end

			local var_31_14 = json.parse(tostring(var_0_38.GetScoreDataJSO()))

			if var_31_12 ~= nil then
				local var_31_15 = var_31_14.teamdata[var_31_12].score
				local var_31_16 = var_31_14.teamdata[var_31_13].score

				if var_31_15 == 0 and var_31_16 == 0 then
					local var_31_17 = entity.get_player_resource()

					if var_31_17 ~= nil then
						local var_31_18 = entity.get_prop(var_31_17, "m_iKills", var_31_11) or 0
						local var_31_19 = entity.get_prop(var_31_17, "m_iAssists", var_31_11) or 0
						local var_31_20 = entity.get_prop(var_31_17, "m_iDeaths", var_31_11) or 0

						var_31_1.details = string.format("%s [ %d | %d | %d ]", var_31_10, var_31_18, var_31_19, var_31_20)
					end
				elseif var_31_15 ~= nil and var_31_16 ~= nil then
					var_31_1.details = string.format("%s [%d:%d %s]", var_31_10, var_31_15, var_31_16, var_0_48(var_31_15 == var_31_16 and "eom-result-tie2" or var_31_16 < var_31_15 and "eom-result-win2" or "eom-result-loss2"))
				end
			end

			if var_31_1.details == nil then
				var_31_1.details = string.format("%s [%s]", var_31_10, var_0_48("gamephase_5"))
			end
		elseif var_31_6.gamephase == var_0_41 or var_31_6.gamephase == var_0_42 or var_31_6.gamephase == var_0_43 then
			if var_31_6.roundtime_remaining >= var_31_6.roundtime then
				var_31_9 = entity.get_prop(var_31_4, "m_fRoundStartTime")

				if var_31_9 ~= nil then
					var_31_8 = var_31_9 - cvar.mp_freezetime:get_float()
				end
			elseif var_31_6.roundtime > var_31_6.roundtime_remaining then
				var_31_8 = entity.get_prop(var_31_4, "m_fRoundStartTime") + 0.5
			end

			local var_31_21
			local var_31_22 = var_0_38.GetGameModeInternalName(true)
			local var_31_23 = entity.get_local_player()

			if var_31_22 == "casual" or var_31_22 == "competitive" or var_31_22 == "scrimcomp2v2" or var_31_22 == "demolition" then
				local var_31_24 = json.parse(tostring(var_0_38.GetScoreDataJSO()))
				local var_31_25 = "CT"
				local var_31_26 = "TERRORIST"

				if var_31_23 ~= nil and entity.get_prop(var_31_23, "m_iTeamNum") == 2 then
					var_31_25, var_31_26 = "TERRORIST", "CT"
				end

				if var_31_24.teamdata[var_31_25] ~= nil and var_31_24.teamdata[var_31_26] ~= nil then
					var_31_21 = string.format("%d : %d", var_31_24.teamdata[var_31_25].score, var_31_24.teamdata[var_31_26].score)
				end
			else
				local var_31_27 = entity.get_player_resource()

				if var_31_27 ~= nil then
					local var_31_28 = entity.get_prop(var_31_27, "m_iKills", var_31_23) or 0
					local var_31_29 = entity.get_prop(var_31_27, "m_iAssists", var_31_23) or 0
					local var_31_30 = entity.get_prop(var_31_27, "m_iDeaths", var_31_23) or 0

					var_31_21 = string.format("%d | %d | %d", var_31_28, var_31_29, var_31_30)
				end
			end

			var_31_1.details = var_31_10 .. (var_31_21 and " [ " .. var_31_21 .. " ]" or "")
		end

		var_31_1.assets = {
			large_image = "map_" .. var_0_54(var_31_2),
			large_text = var_0_38.IsDemoOrHltv() and var_0_48("SFUI_Lobby_StatusWatchingCSGO") or var_0_48("matchdraft_final_map", {
				mapname = var_0_38.GetMapName()
			}),
			small_image = var_31_0["Hide gamesense.pub"] and "csgo-logo2" or "gamesense",
			small_text = var_31_0["Hide gamesense.pub"] and "Counter-Strike: Global Offensive" or "Using gamesense.pub"
		}

		if var_0_63.failed_images[var_31_1.assets.large_image] then
			var_31_1.assets.large_image = "bg_default"
		end

		if var_31_8 ~= nil then
			local var_31_31 = var_0_51() - globals.curtime()

			var_31_1.timestamps = {
				start = math.floor((var_31_31 + var_31_8) * 1000)
			}

			if var_31_9 ~= nil and var_31_8 < var_31_9 then
				var_31_1.timestamps["end"] = math.floor((var_31_31 + var_31_9) * 1000)
			end
		end
	elseif var_0_5() then
		var_31_1.state = var_0_48("LoadingProgress_Connecting")
	else
		var_31_1.details = var_0_49[var_0_56(var_0_48("SFUI_MAINMENU"))]

		if var_0_36.IsSessionActive() then
			local var_31_32 = json.parse(tostring(var_0_36.GetSessionSettings()))

			if var_31_32.system.network == "LIVE" then
				var_31_1.details = var_0_49[var_0_48("SFUI_Lobby_StatusInLobby")]
			end

			local var_31_33 = var_0_36.GetMatchmakingStatusString()

			if var_31_32.system.network == "LIVE" or var_31_33 ~= nil and var_31_33 ~= "" then
				local var_31_34 = var_31_32.game.mode ~= nil and var_0_48("SFUI_GameMode" .. var_31_32.game.mode) or var_0_49[var_0_56(var_0_48("SFUI_MAINMENU"))]

				if var_31_33 ~= nil and var_31_33 ~= "" then
					local var_31_35 = var_31_33 ~= nil and var_0_48(var_31_33) or nil

					if (var_31_35 == nil or var_31_35 == "") and var_31_32.game ~= nil and var_31_32.game.mmqueue ~= nil then
						var_31_35 = var_0_56(var_31_32.game.mmqueue)
					end

					var_31_1.state = string.format("%s - %s", var_31_34, var_31_35 or "")
					var_31_1.timestamps = {
						start = (var_0_51() - var_0_36.GetTimeSpentMatchmaking()) * 1000
					}

					local var_31_36 = var_0_37.GetPartySessionSetting("game/mmqueue")

					if var_31_36 == "reserved" or var_31_36 == "connect" then
						local var_31_37 = var_0_37.GetPartySessionSetting("game/map")

						var_31_1.assets.large_image = var_31_37 ~= nil and var_31_37 ~= "" and not var_31_37:find(",") and "map_" .. var_31_37 or "bg_blurry"
						var_31_1.assets.large_text = var_0_53(var_31_37)

						if var_0_63.failed_images[var_31_1.assets.large_image] then
							var_31_1.assets.large_image = "bg_blurry"
						end
					end
				else
					var_31_1.state = var_31_34
				end

				local var_31_38 = 5

				if var_31_32.game.mode == "scrimcomp2v2" or var_31_32.game.mode == "cooperative" or var_31_32.game.mode == "coopmission" then
					var_31_38 = 2
				elseif var_31_32.game.mode == "survival" then
					var_31_38 = 2
				end

				if var_31_32.system.network == "LIVE" then
					var_31_1.party = {
						size = {
							var_0_37.GetCount(),
							var_31_38
						}
					}
				end
			end
		end
	end

	var_0_63:set_activity(var_31_1)
end

local function var_0_69()
	var_0_64 = 0
end

var_0_63 = var_0_31("774277207451107398", {
	ready = function(arg_33_0, arg_33_1)
		var_0_68()

		local var_33_0 = "Connected to " .. arg_33_1.user.username .. "#" .. arg_33_1.user.discriminator

		var_0_62(var_33_0)
		client.delay_call(10, function()
			if ui.get(var_0_60) == "> " .. var_33_0 then
				var_0_62(nil)
			end
		end)
	end,
	failed = function(arg_35_0, arg_35_1)
		if arg_35_1 == "File not found" then
			var_0_62("Connection failed: Discord not found.")
		else
			var_0_62("Connection failed: " .. tostring(arg_35_1))
		end

		var_0_65 = globals.realtime() + 5
	end,
	error = function(arg_36_0, arg_36_1)
		var_0_65 = globals.realtime() + 5

		var_0_62("Error: " .. arg_36_1)
	end,
	join_game = function(arg_37_0)
		return
	end,
	join_request = function(arg_38_0)
		return
	end,
	spectate_game = function(arg_39_0)
		return
	end,
	image_failed_to_load = var_0_68
})

local var_0_70 = {
	paint_ui = function()
		local var_40_0 = globals.realtime()

		if not var_0_63.open and var_0_65 ~= nil and var_40_0 > var_0_65 then
			var_0_62("Connecting...")

			var_0_65 = var_40_0

			var_0_63:connect()
		elseif var_0_63.open and not var_0_63.ready and var_40_0 > var_0_65 + 150 then
			var_0_62("Connection timed out.")

			var_0_65 = var_0_65 + 150 + 30

			var_0_63:close()
		elseif var_0_63.open and var_0_63.ready and var_40_0 - var_0_64 > 1 then
			ui.set(var_0_61, ui.get(var_0_59))

			var_0_64 = var_40_0

			var_0_68()
		end
	end,
	player_death = var_0_69,
	bomb_planted = var_0_69,
	round_start = var_0_69,
	round_end = var_0_69,
	buytime_ended = var_0_69,
	cs_game_disconnected = var_0_69,
	cs_win_panel_match = var_0_69,
	cs_match_end_restart = var_0_69
}

local function var_0_71()
	local var_41_0 = ui.get(var_0_57)
	local var_41_1 = var_0_52(ui.get(var_0_58))

	ui.set_visible(var_0_58, var_41_0)
	ui.set_visible(var_0_59, var_41_0 and var_41_1["Custom Text"])

	if not var_41_0 then
		ui.set_visible(var_0_60, false)
	end

	var_0_69()
end

ui.set_callback(var_0_58, var_0_71)
var_0_71()
ui.set_callback(var_0_57, function()
	local var_42_0 = ui.get(var_0_57)

	for iter_42_0, iter_42_1 in pairs(var_0_70) do
		if var_42_0 then
			client.set_event_callback(iter_42_0, iter_42_1)
		else
			client.unset_event_callback(iter_42_0, iter_42_1)

			if var_0_63.open and var_0_63.ready then
				var_0_63:set_activity(nil)
			end
		end
	end

	if not var_42_0 and var_0_63 ~= nil then
		local var_42_1 = var_0_65

		client.delay_call(60, function()
			if not ui.get(var_0_57) and var_0_63.open and var_42_1 == var_0_65 then
				var_0_65 = globals.realtime() + 10

				var_0_63:close()
			end
		end)
	end

	var_0_71()
end)
client.set_event_callback("pre_config_save", function()
	ui.set(var_0_61, ui.get(var_0_59))
end)
client.set_event_callback("post_config_load", function()
	ui.set(var_0_59, ui.get(var_0_61) or "")
end)
client.delay_call(0, function()
	ui.set(var_0_59, ui.get(var_0_61) or "")
end)
client.set_event_callback("shutdown", function()
	if var_0_63.open then
		var_0_62(nil)
		var_0_63:close()
	end
end)
