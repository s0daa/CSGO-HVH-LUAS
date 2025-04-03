if (engine.is_connected()) then print("AdBlocker is enabled! Please reconnect to server for stable operation") end
engine.execute_cmd("con_filter_enable 1")
engine.execute_cmd("con_filter_text_out \"blocking\"");

engine.execute_cmd("cl_server_graphic1_enable 0")
engine.execute_cmd("cl_server_graphic2_enable 0")

local function on_paint()
	cvars.net_blockmsg:set_string("CNETMsg_StringCmd")
end

callbacks.add(e_callbacks.PAINT, on_paint)