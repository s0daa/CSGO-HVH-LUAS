local var_0_0 = require("vector")
local var_0_1 = {
	enabled = ui.new_checkbox("LUA", "A", "Enable Sonar"),
	volume = ui.new_slider("LUA", "A", "Sonar Volume", 0, 10, 10, true, "", 0.1),
	minDistance = ui.new_slider("LUA", "A", "Sonar Min Distance", 0, 1000, 0, true, "f"),
	maxDistance = ui.new_slider("LUA", "A", "Sonar Max Distance", 0, 1000, 250, true, "f"),
	teams = ui.new_checkbox("LUA", "A", "Sonar On Teammates")
}
local var_0_2 = 0

local function var_0_3()
	local var_1_0
	local var_1_1 = entity.get_local_player()
	local var_1_2 = var_0_0(entity.get_prop(var_1_1, "m_vecOrigin"))

	for iter_1_0, iter_1_1 in ipairs(entity.get_players(not ui.get(var_0_1.teams))) do
		local var_1_3 = var_0_0(entity.get_prop(iter_1_1, "m_vecOrigin"))
		local var_1_4 = var_1_2:dist(var_1_3)

		if var_1_0 == nil or var_1_4 < var_1_0 then
			var_1_0 = var_1_4
		end
	end

	if var_1_0 ~= nil then
		return var_1_0 * 0.0254 * 3.281
	end
end

local function var_0_4(arg_2_0)
	if globals.realtime() > var_0_2 + arg_2_0 then
		client.exec("playvol  ", "/buttons/blip1.wav ", ui.get(var_0_1.volume) * 0.1)

		var_0_2 = globals.realtime()
	end
end

client.set_event_callback("run_command", function()
	local var_3_0 = entity.get_local_player()

	if entity.is_alive(var_3_0) and ui.get(var_0_1.enabled) then
		local var_3_1 = var_0_3()
		local var_3_2 = ui.get(var_0_1.minDistance)
		local var_3_3 = ui.get(var_0_1.maxDistance)

		if var_3_1 ~= nil and (var_3_1 <= var_3_3 or var_3_3 == 0) and var_3_2 <= var_3_1 then
			var_0_4(var_3_1 / var_3_3 * 5)
		end
	end
end)
