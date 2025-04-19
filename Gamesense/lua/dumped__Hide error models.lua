function slot2(slot0)
	for slot5, slot6 in ipairs(materialsystem.get_model_materials(slot0)) do
		if slot6:get_name() == "models/error/error" then
			slot6:set_material_var_flag(2, true)
			entity.set_prop(slot0, "m_fEffects", 32)
		end
	end
end

require("gamesense/netvar_hooks").hook_prop("DT_BaseEntity", "m_fEffects", function (slot0, slot1)
	if ui.get(uv0) and entity.get_classname(slot1) == "CDynamicProp" then
		uv1(slot1)
		client.delay_call(0, uv1, slot1)
	end
end)
ui.set_callback(ui.new_checkbox("MISC", "Miscellaneous", "Hide error models"), function ()
	if ui.get(uv0) then
		for slot3, slot4 in ipairs(entity.get_all("CDynamicProp")) do
			uv1(slot4)
		end
	end
end)
