local var_0_0 = require("gamesense/chat")
local var_0_1 = ui.get
local var_0_2 = {
	"Red",
	"Dark Red",
	"Light Red",
	"Violet",
	"Purple",
	"Blue",
	"Dark Blue",
	"Blue-Grey",
	"Green",
	"Light Green",
	"Lime",
	"Yellow",
	"Orange",
	"White",
	"Grey"
}
local var_0_3 = {}

for iter_0_0, iter_0_1 in pairs(var_0_2) do
	var_0_3[iter_0_1] = "{" .. iter_0_1:gsub("[ %-]", ""):lower() .. "}"
end

local var_0_4 = ui.new_checkbox("MISC", "Miscellaneous", "Chat damage logging")
local var_0_5 = ui.new_textbox("MISC", "Miscellaneous", "Custom prefix")
local var_0_6 = ui.new_combobox("MISC", "Miscellaneous", "Custom colors", var_0_2)
local var_0_7 = ui.new_combobox("MISC", "Miscellaneous", "\nCustom color 2", var_0_2)

ui.set(var_0_6, "Green")
ui.set(var_0_7, "Green")
ui.set(var_0_5, database.read("roundDamageLogJessica") or "FACEIT^")
ui.set_visible(var_0_5, false)
ui.set_visible(var_0_6, false)
ui.set_visible(var_0_7, false)

local var_0_8 = {}
local var_0_9 = {}

local function var_0_10()
	local var_1_0 = entity.get_player_resource()
	local var_1_1 = {}

	for iter_1_0 = 1, globals.maxplayers() do
		if entity.get_prop(var_1_0, "m_bConnected", iter_1_0) == 1 and entity.is_enemy(iter_1_0) then
			table.insert(var_1_1, iter_1_0)
		end
	end

	return var_1_1
end

local function var_0_11()
	table.clear(var_0_8)
	table.clear(var_0_9)
end

local function var_0_12(arg_3_0)
	local var_3_0 = client.userid_to_entindex(arg_3_0.attacker)
	local var_3_1 = client.userid_to_entindex(arg_3_0.userid)
	local var_3_2 = entity.get_local_player()
	local var_3_3 = var_3_1 == var_3_2
	local var_3_4 = var_3_3 and var_3_0 or var_3_1

	if entity.is_enemy(var_3_4) and (var_3_3 and var_3_1 or var_3_0) == var_3_2 then
		local var_3_5 = var_3_3 and var_0_8 or var_0_9

		var_3_5[var_3_4] = var_3_5[var_3_4] or {}
		var_3_5[var_3_4].damage = (var_3_5[var_3_4].damage or 0) + arg_3_0.dmg_health
		var_3_5[var_3_4].count = (var_3_5[var_3_4].count or 0) + 1
	end
end

local function var_0_13(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	return string.format("%s%s: [%s%d / %d hits%s]", arg_4_3, arg_4_0, arg_4_2, arg_4_1.damage or 0, arg_4_1.count or 0, arg_4_3)
end

local function var_0_14()
	client.delay_call(0.2, function()
		local var_6_0 = ui.get(var_0_5)

		for iter_6_0, iter_6_1 in ipairs(var_0_10()) do
			local var_6_1 = (entity.get_esp_data(iter_6_1) or {}).health or 0
			local var_6_2 = var_0_3[ui.get(var_0_6)]
			local var_6_3 = var_0_3[ui.get(var_0_7)]
			local var_6_4 = string.format("%s[%s%s%s] %s %s %s- %s%s %s(%s%d hp%s)", var_6_3, var_6_2, var_6_0, var_6_3, var_0_13("To", var_0_9[iter_6_1] or {}, var_6_2, var_6_3), var_0_13("From", var_0_8[iter_6_1] or {}, var_6_2, var_6_3), var_6_3, var_6_3, entity.get_player_name(iter_6_1), var_6_3, var_6_2, var_6_1, var_6_3)

			var_0_0.print(var_6_4)
		end

		var_0_11()
	end)
end

local function var_0_15()
	database.write("roundDamageLogJessica", var_0_1(var_0_5))
end

ui.set_callback(var_0_4, function()
	local var_8_0 = ui.get(var_0_4)
	local var_8_1 = var_8_0 and client.set_event_callback or client.unset_event_callback

	var_8_1("player_hurt", var_0_12)
	var_8_1("round_end", var_0_14)
	var_8_1("level_init", var_0_11)
	var_8_1("shutdown", var_0_15)
	ui.set_visible(var_0_5, var_8_0)
	ui.set_visible(var_0_6, var_8_0)
	ui.set_visible(var_0_7, var_8_0)

	if not var_8_0 then
		var_0_11()
	end
end)
