-- Hide Chat
-- Original post by oxisDOG
-- https://gamesense.pub/forums/viewtopic.php?id=27572

hidechatbox = ui.new_checkbox("MISC", "Miscellaneous", "Hide chat")


local function hidechat()
    if hidechatbox then
        cvar.cl_chatfilters:set_int(0)
    else
        cvar.cl_chatfilters:set_int(63)
    end 
end

local function onshutdown()
    cvar.cl_chatfilters:set_int(63)
end

client.set_event_callback("shutdown", onshutdown)
client.set_event_callback("run_command", hidechat)