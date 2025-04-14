    local ffi = require("ffi")
    ffi.cdef[[
        struct cusercmd
        {
            struct cusercmd (*cusercmd)();
            int     command_number;
            int     tick_count;
        };
        typedef struct cusercmd*(__thiscall* get_user_cmd_t)(void*, int, int);
    ]]

    local signature_ginput = "\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85"
    local match = client.find_signature("client.dll", signature_ginput) or error("sig1 not found")
    local g_input = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("match is nil")
    local g_inputclass = ffi.cast("void***", g_input)
    local g_inputvtbl = g_inputclass[0]
    local rawgetusercmd = g_inputvtbl[8]
    local get_user_cmd = ffi.cast("get_user_cmd_t", rawgetusercmd)

    local airstuck = ui.new_hotkey("misc", "miscellaneous", "Airstuck")
    local get = ui.get

    client.set_event_callback("setup_command", function(e)
        local cmd = get_user_cmd(g_inputclass , 0, e.command_number)
        if get(airstuck) then    
    		cmd.tick_count = 0x7F7FFFFF
    		cmd.command_number = 0x00000 -- if this is = to cmd.tick_count then when someone peeks you'll instantly crash.
        end
    end)
    -- we're gonna have to turn off aimbot when the airstuck is enabled cheat thinks its shooting and uncharge's dt..
