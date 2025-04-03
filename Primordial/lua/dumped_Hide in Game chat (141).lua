local chat_tog = menu.add_checkbox("Invisible shit talk!", "Hide chat in game", false)
	
local function hide_chat()
	if chat_tog:get() then
		cvars.cl_chatfilters:set_int(0)
	else
		cvars.cl_chatfilters:set_int(63)   									
	end	
end
local function on_shutdown()
    cvars.cl_chatfilters:set_int(63)
end

callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.PAINT, hide_chat)