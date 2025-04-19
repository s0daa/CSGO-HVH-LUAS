local set_console = ui.new_checkbox("misc", "miscellaneous", "Filter console")
ui.set_callback(set_console, function()
    if ui.get(set_console) then
        cvar.developer:set_int(0)
        cvar.con_filter_enable:set_int(1)
        cvar.con_filter_text:set_string("IrWL5106TZZKNFPz4P4Gl3pSN?J370f5hi373ZjPg%VOVh6lN")
    else
        cvar.con_filter_enable:set_int(0)
        cvar.con_filter_text:set_string("")
    end
end)
client.set_event_callback("shutdown", function()
    cvar.con_filter_enable:set_int(0)
    cvar.con_filter_text:set_string("")
end)