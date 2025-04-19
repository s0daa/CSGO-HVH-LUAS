local skybox_bool_checkbox = gui.add_checkbox("Load skybox", "LUA>TAB a")
local skybox_value_textbox = gui.add_textbox("Skybox name", "LUA>TAB a")
local skybox = skybox_value_textbox:get_string()

function on_paint()
	if skybox_bool_checkbox:get_bool() then 
        cvar.sv_skyname:set_string(skybox_value_textbox:get_string())
		skybox_bool_checkbox:set_bool(false)
	end
end