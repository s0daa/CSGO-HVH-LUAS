local var_0_0 = ui.get
local var_0_1 = ui.set
local var_0_2 = ui.new_checkbox("aa", "fake lag", "Disable fake lag on round end")
local var_0_3 = ui.reference("aa", "fake lag", "enabled")

local function var_0_4(arg_1_0)
	if var_0_0(var_0_2) then
		var_0_1(var_0_3, true)
	end
end

local function var_0_5(arg_2_0)
	if var_0_0(var_0_2) then
		var_0_1(var_0_3, false)
	end
end

client.set_event_callback("round_start", var_0_4)
client.set_event_callback("round_end", var_0_5)
