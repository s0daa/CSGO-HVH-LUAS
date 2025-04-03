local var_0_0 = entity.get_player_name
local var_0_1 = entity.get_prop
local var_0_2 = globals.curtime
local var_0_3 = math.max
local var_0_4 = renderer.text
local var_0_5 = renderer.rectangle
local var_0_6 = renderer.measure_text
local var_0_7 = table.insert
local var_0_8 = table.remove
local var_0_9 = ui.get
local var_0_10 = ui.set_visible
local var_0_11 = client.set_event_callback
local var_0_12 = client.unset_event_callback
local var_0_13, var_0_14 = client.screen_size()
local var_0_15 = {
	var_0_13 / 2,
	var_0_14 / 2
}
local var_0_16
local var_0_17
local var_0_18
local var_0_19
local var_0_20
local var_0_21
local var_0_22 = {}

local function var_0_23()
	local var_1_0 = {}

	for iter_1_0 = 1, #var_0_22 do
		local var_1_1 = 0
		local var_1_2 = 0
		local var_1_3 = 0
		local var_1_4 = var_0_21 * var_0_3(0, 0 - (var_0_2() - var_0_22[iter_1_0][3] - var_0_17) / var_0_17)

		if var_1_4 <= 0 or var_1_4 > 255 then
			var_1_0[#var_1_0 + 1] = iter_1_0
		else
			cur_shot = var_0_22[iter_1_0]

			local var_1_5 = "r"

			if cur_shot[1] == 2 then
				var_1_1, var_1_2, var_1_3 = 255, 255, 70
				var_1_5 = "rb"
			elseif cur_shot[1] == 1 then
				var_1_1, var_1_2, var_1_3 = 0, 255, 0
			else
				var_1_1, var_1_2, var_1_3 = 255, 50, 0
			end

			local var_1_6 = var_0_16 >= 0 and var_0_15[2] - var_0_16 - iter_1_0 * 12 or var_0_15[2] - var_0_16 + iter_1_0 * 12

			var_0_4(var_0_15[1] - 2, var_1_6, var_1_1, var_1_2, var_1_3, var_1_4, var_1_5, 0, cur_shot[2])
			var_0_4(var_0_15[1] + 2, var_1_6, var_0_18, var_0_19, var_0_20, var_1_4, "b", 0, cur_shot[4])

			if cur_shot[5] then
				var_0_5(var_0_15[1] + 3, var_1_6 + 7, var_0_6("b", cur_shot[4]) + 2, 2, 0, 0, 0, var_1_4 / 2)
				var_0_5(var_0_15[1] + 2, var_1_6 + 6, var_0_6("b", cur_shot[4]) + 2, 2, 255, 50, 0, var_1_4)
			end
		end
	end

	for iter_1_1 = 1, #var_1_0 do
		var_0_8(var_0_22, var_1_0[iter_1_1])
	end
end

local function var_0_24(arg_2_0)
	var_0_7(var_0_22, {
		arg_2_0.hitgroup == 1 and 2 or 1,
		arg_2_0.damage,
		var_0_2(),
		var_0_0(arg_2_0.target),
		var_0_1(arg_2_0.target, "m_iHealth") <= 0
	})
end

local function var_0_25(arg_3_0)
	var_0_7(var_0_22, {
		0,
		arg_3_0.reason,
		var_0_2(),
		var_0_0(arg_3_0.target),
		false
	})
end

local function var_0_26()
	var_0_22 = {}
end

local var_0_27
local var_0_28
local var_0_29
local var_0_30

local function var_0_31(arg_5_0)
	local var_5_0 = var_0_9(arg_5_0)
	local var_5_1 = var_5_0 and var_0_11 or var_0_12

	var_5_1("paint", var_0_23)
	var_5_1("aim_hit", var_0_24)
	var_5_1("aim_miss", var_0_25)
	var_5_1("level_init", var_0_26)
	var_0_10(var_0_28, var_5_0)
	var_0_10(var_0_29, var_5_0)
	var_0_10(var_0_30, var_5_0)
end

local var_0_32 = ui.new_checkbox("VISUALS", "Effects", "Simple hitlog")

var_0_28 = ui.new_color_picker("VISUALS", "Effects", "Simple hitlog color", 255, 255, 255, 255)
var_0_29 = ui.new_slider("VISUALS", "Effects", "\nHitlog offset", -500, 500, 128, true, "px")
var_0_30 = ui.new_slider("VISUALS", "Effects", "\nHitlog fade time", 1, 15, 4, true, "s")

ui.set_callback(var_0_28, function(arg_6_0)
	var_0_18, var_0_19, var_0_20, var_0_21 = var_0_9(arg_6_0)
end)

var_0_18, var_0_19, var_0_20, var_0_21 = var_0_9(var_0_28)

ui.set_callback(var_0_29, function(arg_7_0)
	var_0_16 = var_0_9(arg_7_0)
end)

var_0_16 = var_0_9(var_0_29)

ui.set_callback(var_0_30, function(arg_8_0)
	var_0_17 = var_0_9(arg_8_0)
end)

var_0_17 = var_0_9(var_0_30)

ui.set_callback(var_0_32, var_0_31)
var_0_31(var_0_32)
