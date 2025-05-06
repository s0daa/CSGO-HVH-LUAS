local ffi = require('ffi')

ffi.cdef([[
    typedef struct c_con_command_base {
        void *vtable;
        void *next;
        bool registered;
        const char *name;
        const char *help_string;
        int flags;
        void *s_cmd_base;
        void *accessor;
    } c_con_command_base;
]])

local unlock_hidden_cvars = ui.new_checkbox('misc', 'Miscellaneous', 'Unlock hidden cvars')
local v_engine_cvar = client.create_interface('vstdlib.dll', 'VEngineCvar007')
local hidden_cvars = {}
local original_flags = {}

local con_command_base = ffi.cast('c_con_command_base ***', ffi.cast('uint32_t', v_engine_cvar) + 0x34)[0][0]
local cmd = ffi.cast('c_con_command_base *', con_command_base.next)

while ffi.cast('uint32_t', cmd) ~= 0 do
    if bit.band(cmd.flags, 18) ~= 0 then
        table.insert(hidden_cvars, cmd)
        table.insert(original_flags, cmd.flags)
    end
    cmd = ffi.cast('c_con_command_base *', cmd.next)
end

function show_hidden_cvars(show)
    for i = 1, #hidden_cvars do
        if show then
            hidden_cvars[i].flags = bit.band(hidden_cvars[i].flags, -19)
        else
            hidden_cvars[i].flags = original_flags[i]
        end
    end
end

ui.set_callback(unlock_hidden_cvars, function()
    show_hidden_cvars(ui.get(unlock_hidden_cvars))
end)

client.set_event_callback('shutdown', function()
    show_hidden_cvars(false)
end)