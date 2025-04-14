local collision = ui.new_checkbox("Misc", "Settings", "Cam collision")

local set_console = ui.new_checkbox("misc", "Settings", "Filter console")

ui.set_callback(collision, function()
    if ui.get(collision) then
         client.exec("cam_collision 0")
    else
         client.exec("cam_collision 1")
    end
end)

ui.set_callback(set_console, function()
    if ui.get(set_console) then
        cvar.developer:set_int(0)
        cvar.con_filter_enable:set_int(1)
        cvar.con_filter_text:set_string("IrWL5106TZZKNFPz4P4Gl3pSN?J370f5hi373ZjPg%VOVh6lN")
        client.exec("con_filter_enable 1")
    else
        cvar.con_filter_enable:set_int(0)
        cvar.con_filter_text:set_string("")
        client.exec("con_filter_enable 0")
    end
end)

client.set_event_callback("shutdown", function()
    cvar.con_filter_enable:set_int(0)
    cvar.con_filter_text:set_string("")
    client.exec("con_filter_enable 0")
end)