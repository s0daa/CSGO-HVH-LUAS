local var_0_0 = require("ffi")
local var_0_1 = require("gamesense/http")
local var_0_2 = require("gamesense/panorama_events")
local var_0_3 = panorama.open()
local var_0_4 = var_0_3.NewsAPI
local var_0_5 = var_0_3.GameStateAPI
local var_0_6 = 0
local var_0_7 = false
local var_0_8 = var_0_0.cast("uint32_t**", var_0_0.cast("char*", client.find_signature("engine.dll", "\xFF5\xCC\xCC\xCC̍L$\x10")) + 2)[0][0]

local function var_0_9()
	if var_0_7 then
		return
	end

	var_0_1.get("https://api.steampowered.com/ISteamApps/UpToDateCheck/v1/?appid=730&version=" .. var_0_8, function(arg_2_0, arg_2_1)
		if not arg_2_0 or arg_2_1.status ~= 200 then
			return
		end

		local var_2_0 = json.parse(arg_2_1.body)

		if var_2_0.response.required_version ~= nil then
			var_0_0.cast("uint32_t**", var_0_0.cast("char*", client.find_signature("engine.dll", "\xFF5\xCC\xCC\xCC̍L$\x10")) + 2)[0][0] = var_2_0.response.required_version
		end
	end)
end

local function var_0_10()
	local var_3_0 = vtable_bind("vstdlib.dll", "VEngineCvar007", 35, "void(__thiscall*)(void*, int, char*, unsigned int)")
	local var_3_1 = 1048576
	local var_3_2 = var_0_0.typeof("char[$]", var_3_1)()

	var_3_0(0, var_3_2, var_3_1)

	return var_0_0.string(var_3_2)
end

local function var_0_11()
	client.exec("clear")

	var_0_7 = true

	local var_4_0 = 0

	client.delay_call(0.5, function()
		local var_5_0 = var_0_10():match("server version (.+)")

		if not var_5_0 then
			return
		end

		var_4_0 = var_5_0:gsub("\n(.+)", "") + 0
		var_0_0.cast("uint32_t**", var_0_0.cast("char*", client.find_signature("engine.dll", "\xFF5\xCC\xCC\xCC̍L$\x10")) + 2)[0][0] = var_4_0

		client.exec("retry")
	end)
	client.delay_call(2, function()
		if var_0_10():match("Connected to (.+)") and var_4_0 ~= 0 then
			var_0_7 = false
			var_0_8 = var_4_0

			var_0_9()
		end
	end)
end

client.set_event_callback("paint_ui", function()
	if (globals.mapname() ~= nil or var_0_5.IsConnectedOrConnectingToServer()) and not entity.get_local_player() then
		if var_0_6 == 0 then
			var_0_11()

			var_0_6 = 1
		end
	else
		var_0_6 = 0
	end
end)
client.set_event_callback("cs_win_panel_match", var_0_9)
var_0_2.register_event("CSGOShowMainMenu", var_0_9)
var_0_9()
