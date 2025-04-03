local var_0_0 = getfenv()
local var_0_1 = {
	{
		"websockets",
		"23653"
	},
	{
		"clipboard",
		"28678"
	},
	{
		"base64",
		"21619"
	}
}

for iter_0_0, iter_0_1 in ipairs(var_0_1) do
	local var_0_2, var_0_3 = pcall(require, (iter_0_1[2] and "gamesense/" or "lib/") .. iter_0_1[1])

	if var_0_2 then
		var_0_0[iter_0_1[1]] = var_0_3
	else
		local var_0_4 = iter_0_1[2] and " |  https://gamesense.pub/forums/viewtopic.php?id=" .. iter_0_1[2] or " | Local library not found in lib folder"

		error("Failed to load module: " .. (iter_0_1[2] and "gamesense/" or "lib/") .. iter_0_1[1] .. var_0_4, 2)
	end
end

local var_0_5 = require("gamesense/websockets")
local var_0_6 = require("gamesense/clipboard")
local var_0_7 = require("gamesense/base64")
local var_0_8 = entity.get_players
local var_0_9 = entity.get_local_player
local var_0_10 = false
local var_0_11
local var_0_12 = ""
local var_0_13 = ""
local var_0_14 = {
	["US Central"] = "us-central-csgocloud.zebratic.repl.co",
	["EU West"] = "cloud.odder.world"
}
local var_0_15 = {}

for iter_0_2, iter_0_3 in pairs(var_0_14) do
	table.insert(var_0_15, iter_0_2)
end

local var_0_16 = "LUA"
local var_0_17 = "A"
local var_0_18 = ui.new_label(var_0_16, var_0_17, "MSG_LABEL")

ui.set(var_0_18, "")

local var_0_19 = ui.new_combobox(var_0_16, var_0_17, "CSGO Cloud Server:", var_0_15)
local var_0_20 = ui.new_button(var_0_16, var_0_17, "\a00FF00FFStart CSGO Cloud", function()
	start_csgo_cloud()
end)
local var_0_21 = ui.new_textbox(var_0_16, var_0_17, "APIKEY", "")
local var_0_22 = ui.new_button(var_0_16, var_0_17, "\a00FF00FFUpdate API Key", function()
	update_apikey()
end)
local var_0_23 = ui.new_button(var_0_16, var_0_17, "\aFFFF00FFCopy URL", function()
	var_0_6.set(var_0_13)
	ShowMessage("warning", "URL copied to clipboard")
end)
local var_0_24 = ui.new_button(var_0_16, var_0_17, "\aFF0000FFStop CSGO Cloud", function()
	stop_csgo_cloud()
end)
local var_0_25 = ui.new_slider(var_0_16, var_0_17, "Refresh Rate", 0, 100, 1, true, "ms")

function upload_data()
	if var_0_12 == "" or var_0_11 == nil or var_0_10 == false then
		return
	end

	local var_5_0 = {
		apikey = var_0_12,
		players = get_all_players(),
		timestamp = client.unix_time()
	}

	var_0_11:send(var_0_7.encode(json.stringify(var_5_0)))
end

function loop()
	upload_data()
	client.delay_call(ui.get(var_0_25) / 1000, loop)
end

client.delay_call(1, loop)

function get_all_players()
	local var_7_0 = var_0_8(false)
	local var_7_1 = {}

	for iter_7_0 = 1, #var_7_0 do
		local var_7_2 = var_7_0[iter_7_0]
		local var_7_3 = entity.get_player_name(var_7_2)
		local var_7_4 = entity.get_prop(var_7_2, "m_flFOV")
		local var_7_5, var_7_6, var_7_7 = entity.get_origin(var_7_2)

		if var_7_2 == var_0_9() then
			pitch, yaw, roll = client.camera_angles()
		else
			pitch, yaw, roll = entity.get_prop(var_7_2, "m_angEyeAngles")
		end

		local var_7_8 = entity.get_prop(var_7_2, "m_flDuckAmount")
		local var_7_9 = entity.get_prop(var_7_2, "m_iHealth")
		local var_7_10 = entity.get_prop(var_7_2, "m_ArmorValue")
		local var_7_11 = entity.get_prop(var_7_2, "m_bIsScoped")
		local var_7_12 = entity.get_prop(var_7_2, "m_ZoomLevel")
		local var_7_13 = entity.is_dormant(var_7_2)
		local var_7_14 = entity.is_alive(var_7_2)
		local var_7_15 = entity.get_prop(var_7_2, "m_iShotsFired")
		local var_7_16 = entity.get_prop(var_7_2, "m_iTeamNum")
		local var_7_17 = entity.get_classname(entity.get_prop(var_7_2, "m_hActiveWeapon"))
		local var_7_18 = entity.get_steam64(var_7_2)
		local var_7_19 = entity.get_prop(var_7_2, "m_iAccount")

		var_7_1[iter_7_0] = {
			name = var_7_3,
			fov = var_7_4,
			x = var_7_5,
			y = var_7_6,
			z = var_7_7,
			pitch = pitch,
			yaw = yaw,
			roll = roll,
			duck_amount = var_7_8,
			health = var_7_9,
			armor = var_7_10,
			is_scoped = var_7_11,
			zoom_level = var_7_12,
			is_dormant = var_7_13,
			is_alive = var_7_14,
			is_shooting = var_7_15,
			team = var_7_16,
			current_weapon = var_7_17,
			steamid = var_7_18,
			money = var_7_19
		}
	end

	return var_7_1
end

function GenerateRandomString(arg_8_0)
	local var_8_0 = ""

	for iter_8_0 = 1, arg_8_0 do
		var_8_0 = var_8_0 .. string.char(math.random(97, 122))
	end

	return var_8_0
end

function Connect()
	var_0_11 = var_0_5.connect(ui.get(var_0_19) ~= "Local" and "wss://" .. var_0_14[ui.get(var_0_19)] or "ws://" .. var_0_14[ui.get(var_0_19)], {
		open = function(arg_10_0)
			ShowMessage("success", "Connected to CSGO Cloud " .. ui.get(var_0_19) .. " Server")
			ShowStartMenu(false)

			var_0_10 = true
		end,
		close = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			if arg_11_1 == 1006 then
				ShowMessage("error", "Failed to connect to CSGO Cloud")
			else
				ShowMessage("error", "Disconnected from CSGO Cloud")
			end

			ShowStartMenu(true)

			var_0_10 = false
			arg_11_0 = nil
			var_0_12 = ""
			var_0_13 = ""
		end
	})
end

function start_csgo_cloud()
	Connect()

	var_0_12 = GenerateRandomString(16)

	ui.set(var_0_21, var_0_12)
	update_apikey()
end

function stop_csgo_cloud()
	if var_0_11 ~= nil then
		pcall(var_0_11.close, var_0_11)
	end
end

function ShowStartMenu(arg_14_0)
	ui.set_visible(var_0_20, arg_14_0)
	ui.set_visible(var_0_24, not arg_14_0)
	ui.set_visible(var_0_25, not arg_14_0)
	ui.set_visible(var_0_23, not arg_14_0)
	ui.set_visible(var_0_21, not arg_14_0)
	ui.set_visible(var_0_22, not arg_14_0)
	ui.set_visible(var_0_19, arg_14_0)
end

ShowStartMenu(true)

function update_apikey()
	var_0_12 = ui.get(var_0_21)

	if string.len(var_0_12) < 4 then
		ShowMessage("error", "API Key must be more than 3 characters")

		return
	elseif string.len(var_0_12) > 32 then
		ShowMessage("error", "API Key must be less than 32 characters")

		return
	end

	var_0_13 = var_0_14[ui.get(var_0_19)] == "localhost" and "http://" .. var_0_14[ui.get(var_0_19)] .. "/?apikey=" .. var_0_12 or "https://" .. var_0_14[ui.get(var_0_19)] .. "/?apikey=" .. var_0_12

	ShowMessage("success", "API Key updated to '" .. var_0_12 .. "'")
end

ui.set_callback(var_0_21, update_apikey)

function ShowMessage(arg_16_0, arg_16_1)
	if arg_16_0 == "error" then
		ui.set(var_0_18, "\aFF0000FF" .. arg_16_1)
	elseif arg_16_0 == "warning" then
		ui.set(var_0_18, "\aFFFF00FF" .. arg_16_1)
	elseif arg_16_0 == "success" then
		ui.set(var_0_18, "\a00FF00FF" .. arg_16_1)
	end

	client.delay_call(3, function()
		ui.set(var_0_18, "")
	end)
end
