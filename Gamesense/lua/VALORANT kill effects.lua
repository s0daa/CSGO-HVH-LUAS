local var_0_0 = globals.realtime
local var_0_1 = globals.mapname
local var_0_2 = require("ffi")
local var_0_3 = require("gamesense/gif_decoder")
local var_0_4 = require("gamesense/http")
local var_0_5 = {
	surface = {
		playsound = 82
	}
}
local var_0_6 = {
	ok = 200
}
local var_0_7 = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", var_0_5.surface.playsound, "void (__thiscall*)(void* ecx, const char* sPath)")
local var_0_8 = ui.new_checkbox("VISUALS", "Effects", "VALORANT kill effects")
local var_0_9 = "https://aether.moe/gamesense"
local var_0_10 = 6
local var_0_11 = 0
local var_0_12 = 0
local var_0_13 = 0
local var_0_14 = 0
local var_0_15
local var_0_16
local var_0_17

function on_player_death(arg_1_0)
	local var_1_0 = entity.get_local_player()

	if client.userid_to_entindex(arg_1_0.attacker) ~= var_1_0 or arg_1_0.attacker == arg_1_0.userid or var_0_12 >= var_0_10 then
		return
	end

	var_0_12 = var_0_12 + 1

	var_0_7(string.format("valorant_%d.wav", var_0_12))

	var_0_13 = globals.realtime()
	var_0_14 = var_0_13 + var_0_15[var_0_12].duration
	var_0_16, var_0_17 = client.screen_size()
	var_0_16 = var_0_16 / 2
	var_0_16 = var_0_16 - var_0_15[var_0_12].width / 2
	var_0_17 = var_0_17 * 0.9
	var_0_17 = var_0_17 - var_0_15[var_0_12].height
end

function on_player_spawn(arg_2_0)
	local var_2_0 = entity.get_local_player()

	if client.userid_to_entindex(arg_2_0.userid) ~= var_2_0 then
		return
	end

	reset_vars()
end

function on_paint_ui()
	local var_3_0 = var_0_0()

	if var_3_0 < var_0_14 and var_0_1() ~= nil then
		local var_3_1 = var_0_15[var_0_12]

		var_3_1:draw(var_3_0 - var_0_13, var_0_16, var_0_17, var_3_1.width, var_3_1.height, 255, 255, 255, 255)
	end
end

function reset_vars()
	var_0_12 = 0
	var_0_13 = 0
	var_0_14 = 0
end

function set_callbacks(arg_5_0)
	local var_5_0 = arg_5_0 and client.set_event_callback or client.unset_event_callback

	var_5_0("player_death", on_player_death)
	var_5_0("player_spawn", on_player_spawn)
	var_5_0("paint_ui", on_paint_ui)

	if arg_5_0 and var_0_15 == nil then
		if not load_files() then
			var_0_15 = nil

			ui.set(var_0_8, false)
			client.error_log("Some assets could not be found. Attempting to retrieve them...")
		else
			client.log("VALORANT assets loaded.")
		end
	end
end

function on_menu_kill_effects_enabled_callback(arg_6_0)
	set_callbacks(ui.get(arg_6_0))
end

function download_file(arg_7_0)
	var_0_4.get(string.format("%s/%s", var_0_9, arg_7_0), function(arg_8_0, arg_8_1)
		if not arg_8_0 or arg_8_1.status ~= var_0_6.ok then
			client.error_log(string.format("Could not retrieve asset \"%s\" from server. Error code: %d", arg_7_0, arg_8_1.status))

			return
		end

		writefile(arg_7_0, arg_8_1.body)

		var_0_11 = var_0_11 - 1

		client.log(string.format("Successfully installed asset at path \"%s\".", arg_7_0))

		if var_0_11 == 0 then
			client.log("VALORANT assets downloaded. Loading them.. this might take a while.")
			client.delay_call(globals.tickinterval(), ui.set, var_0_8, true)
		end
	end)
end

function check_and_download(arg_9_0)
	if not readfile(arg_9_0) then
		var_0_11 = var_0_11 + 1

		download_file(arg_9_0)
	end
end

function load_files()
	var_0_15 = {}
	var_0_11 = 0

	for iter_10_0 = 1, var_0_10 do
		check_and_download(string.format("csgo/sound/valorant_%d.wav", iter_10_0))
		check_and_download(string.format("csgo/materials/valorant_%d.gif", iter_10_0))
	end

	if var_0_11 == 0 then
		for iter_10_1 = 1, var_0_10 do
			var_0_15[iter_10_1] = var_0_3.load_gif(readfile(string.format("csgo/materials/valorant_%d.gif", iter_10_1)))
		end
	end

	return var_0_11 == 0
end

ui.set_callback(var_0_8, on_menu_kill_effects_enabled_callback)
