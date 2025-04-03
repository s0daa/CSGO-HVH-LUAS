local var_0_0 = require("gamesense/netvar_hooks")
local var_0_1 = ui.new_checkbox("MISC", "Miscellaneous", "Hide error models")

local function var_0_2(arg_1_0)
	local var_1_0 = materialsystem.get_model_materials(arg_1_0)

	for iter_1_0, iter_1_1 in ipairs(var_1_0) do
		if iter_1_1:get_name() == "models/error/error" then
			iter_1_1:set_material_var_flag(2, true)
			entity.set_prop(arg_1_0, "m_fEffects", 32)
		end
	end
end

var_0_0.hook_prop("DT_BaseEntity", "m_fEffects", function(arg_2_0, arg_2_1)
	if ui.get(var_0_1) and entity.get_classname(arg_2_1) == "CDynamicProp" then
		var_0_2(arg_2_1)
		client.delay_call(0, var_0_2, arg_2_1)
	end
end)

local function var_0_3()
	if ui.get(var_0_1) then
		for iter_3_0, iter_3_1 in ipairs(entity.get_all("CDynamicProp")) do
			var_0_2(iter_3_1)
		end
	end
end

ui.set_callback(var_0_1, var_0_3)
