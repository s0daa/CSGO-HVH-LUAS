--[[ \Modules needed/ ]]
local AESI_SIGNATURE = '[AESI - PROJECT]'
local ffi = require('ffi') or error(('%s Allow unsafe scripts'):format(AESI_SIGNATURE))
local bit = require('bit') or error(('%s Allow unsafe scripts'):format(AESI_SIGNATURE))
local vector = require('vector') or error(('%s Allow unsafe scripts'):format(AESI_SIGNATURE))

local debug_log = function(...) --dunno
    local args = ({...})
    for i,v in pairs(args) do
        if i > 1 then
            args[i] = ' ' .. tostring(args[i])
        end
    end

    client.color_log(0, 121, 211, AESI_SIGNATURE .. ' \0')
    client.color_log(255, 255, 255, unpack(args))
end

local ida_to_bytes = function(sig) --sapphyrus
    return (sig:gsub(' ', ''):gsub('?', 'CC'):gsub('..', function(c) return string.char(tonumber(c, 16)) end))
end

local find_sig = function(module, signature, ida_sig)
    ida_sig = ida_sig or false
    return client.find_signature(module, (ida_sig and ida_to_bytes(signature) or signature)) or error('[' .. module .. ']:sig failed to find!', 2)
end

local create_itf = function(module, interface)
    return client.create_interface(module, interface) or error('[' .. module .. ']:' .. interface .. ' failed to find!', 2)
end

local split = function(inputstr, sep)
    if sep == nil then
        sep = '%s'
    end
    local t={}
    for str in string.gmatch(inputstr, '([^'..sep..']+)') do
        table.insert(t, str)
    end
    return t
end

local convert_address = function(val) return string.format('0x%X', tonumber(val or 0)) end
local jmp_ecx = find_sig('engine.dll', 'FF E1', true)

local get_process_address_sig = find_sig('engine.dll', 'FF 15 ? ? ? ? A3 ? ? ? ? EB 05', true)
local get_proc_address_ptr = ffi.cast('uint32_t**', ffi.cast('uint32_t', get_process_address_sig) + 2)[0][0]
local get_proc_address_fn = ffi.cast('uint32_t(__thiscall*)(unsigned int, uint32_t, const char*)', jmp_ecx)
local GetProcAddress = function(module_handle, function_name)
    return get_proc_address_fn(get_proc_address_ptr, module_handle, function_name)
end

local get_module_handle_sig = find_sig('engine.dll', 'FF 15 ? ? ? ? 85 C0 74 0B', true)
local get_module_handle_ptr = ffi.cast('uint32_t**', ffi.cast('uint32_t', get_module_handle_sig) + 2)[0][0]
local get_module_handle_fn = ffi.cast('uint32_t(__thiscall*)(unsigned int, const char*)', jmp_ecx)
local GetModuleHandleA = function(module_name)
    return get_module_handle_fn(get_module_handle_ptr, module_name)
end

local addr_bind = function(address, typedef)
    local split = split(typedef, '(')
    typedef = split[1] .. '(' .. split[2] .. '(unsigned int, ' .. split[3]

    local call_fn = ffi.cast(ffi.typeof(typedef), jmp_ecx)

    return function(...)
        return call_fn(address, ...)
    end
end

local winapi = setmetatable({}, {
    __call = function(self, ModuleName)
        assert(type(ModuleName) == 'string', 'ModuleName not string #1')

        local Module = GetModuleHandleA(ModuleName)
        if Module == 0 then
            return error('Module not found #2')
        end
        assert(Module ~= nil, 'Module not found #2')

        local cache = {
            [tostring(ModuleName)] = 0
        }
        return setmetatable({
            module_address = Module,
        }, {
            __index = function(self, ProcAddress)
                assert(type(ProcAddress) == 'string', 'ProcAddress not string #1')

                local Address = GetProcAddress(Module, ProcAddress)
                if Address == 0 then
                    return error('Address not found #2')
                end
                assert(Address ~= nil, 'Address not found #2')

                cache[ModuleName] = cache[ModuleName] + 1

                return function(typestring)
                    return addr_bind(Address, typestring)
                end
            end
        })
    end,
})

local kernel32 = winapi('kernel32.dll') -- Used for: VirtualProtect - Import
local native_virtual_protect = kernel32.VirtualProtect'bool(__thiscall*)(void* address, unsigned long size, unsigned long new_protect, unsigned long* old_protect)'

local vmt_hook_lib = (function()
    local vmt_hook = {}

    function vmt_hook:new(vmt)
        if not vmt then
            return error('Virtual Table[VMT] could not be found.', 2)
        end

        local hook = {}
        hook.vmt = ffi.cast('void***', vmt)[0]
        hook.hooked_list = {}

        setmetatable(hook, self)
        self.__index = self

        client.set_event_callback('shutdown', function( ) return hook:un_hook_all( ) end)
        return hook
    end

    function vmt_hook:hook_func(name, index, typedef, new_func)
        local old_protection = ffi.new('unsigned long[1]')

        local original_func = self.vmt[index]
        table.insert(self.hooked_list, {index_of_function = index, original_address = original_func})
        native_virtual_protect(ffi.cast('void*', self.vmt + index), 4, 0x4, old_protection)
        self.vmt[index] = ffi.cast('void*', ffi.cast(typedef, new_func))
        native_virtual_protect(ffi.cast('void*', self.vmt + index), 4, old_protection[0], old_protection)

        self[name] = ffi.cast(typedef, original_func)
        return true
    end

    function vmt_hook:un_hook_all()
        for i, func in pairs(self.hooked_list) do
            local old_protection = ffi.new('unsigned long[1]')
            native_virtual_protect(ffi.cast('void*', self.vmt + func.index_of_function), 4, 0x4, old_protection)
            self.vmt[func.index_of_function] = func.original_address
            native_virtual_protect(ffi.cast('void*', self.vmt + func.index_of_function), 4, old_protection[0], old_protection)
        end
        self.hooked_list = {}
        return true
    end
    return vmt_hook
end)( )



local user_cmd_t = ffi.typeof([[
    struct {
        uintptr_t       vfptr;
        int             command_number;
        int             tick_count;
        Vector          view_angles;
        Vector          aim_direction;
        float           forwardmove;
        float           sidemove;
        float           upmove;
        int             buttons;
        uint8_t         impulse;
        int             weapon_select;
        int             weapon_subtype;
        int             random_seed;
        short           mousedeltax;
        short           mousedeltay;
        bool            has_been_predicted;
        Vector          head_angles;
        Vector          head_offset;
    }
]])

local input_t = ffi.typeof([[
    struct {
        char                pad0[0xC];
        bool                track_ir_available;
        bool                mouse_initialized;
        bool                mouse_active;
        char                pad1[0x9A];
        bool                camera_in_thirdperson;
        char                pad2[0x2];
        Vector              camera_offset;
        char                pad3[0x38];
        $*                  m_commands;
        uintptr_t*          m_verifiedcmds;
    }
]], user_cmd_t)

local globals_t = ffi.typeof([[
    struct
    {
        float           real_time;
        int             frame_count;
        float           abs_frame_time;
        float           abs_frame_start;
        float           current_time;
        float           frame_time;
        int             max_clients;
        int             tick_count;
        float           interval_per_tick;
        float           interpolation_amount;
        int             frame_simulation_ticks;
        int             network_protocol;
        void*           save_data;
        bool            client;
        bool            remote_client;
        int             networking_base;
        int             networking_window;
    }
]])

local net_channel_t = ffi.typeof([[
    struct
    {
        char        pad0[0x14];
        bool        processing_messages;
        bool        should_delete;
        bool        stop_processing;
        char        pad1[0x1];
        int         out_sequence_nr;
        int         in_sequence_nr;
        int         out_sequence_ack;
        int         out_reliable_state;
        int         in_reliable_state;
        int         choked_packets;
    }
]])

local client_state_t = ffi.typeof([[
    struct
    {
        char            pad0[0x9C];
        $*              net_channel;
        int             challenge_nr;
        char            pad1[0x64];
        int             sigon_state;
        char            pad2[0x8];
        float           next_cmd_time;
        int             server_count;
        int             current_sequence;
        char            pad3[0x54];
        int             delta_tick;
        bool            is_paused;
        char            pad4[0x7];
        int             view_entity;
        int             player_slot;
        char            level_name[255];
        char            level_name_short[80];
        char            map_grou_name[80];
        char            last_map_group_name[80];
        char            pad5[0xC];
        int             max_clients;
        char            pad6[0x498C];
        float           last_server_tick_time;
        bool            in_simulation;
        char            pad7[0x3];
        int             old_tick_count;
        float           tick_remainder;
        float           frame_time;
        int             last_outgoing_command;
        int             choked_commands;
        int             last_command_ack;
        int             command_ack;
    }
]], net_channel_t)

local chlclientvmt = vmt_hook_lib:new(create_itf('client.dll', 'VClient018'))

local CInput = ffi.cast(ffi.typeof('$**', input_t), ffi.cast('char*', chlclientvmt.vmt[ 16 ]) + 0x1)[ 0 ]
local Globals = ffi.cast(ffi.typeof('$***', globals_t), ffi.cast('char*', chlclientvmt.vmt[ 11 ]) + 0xA)[ 0 ][ 0 ]
local ClientState = ffi.cast(ffi.typeof('$***', client_state_t), ffi.cast('char*', find_sig('engine.dll', 'A1 ? ? ? ? 8B 88 ? ? ? ? 85 C9 75 07', true)) + 0x1)[ 0 ][ 0 ]

local did_spawn = false
local send_team_request = false

ui.new_label("CONFIG", "Presets", "[ Toggles ] \0")
local break_lua = ui.new_checkbox("CONFIG", "Presets", "[ + ] Disable TP")
ui.new_label("CONFIG", "Presets", " \0")

ui.new_label("CONFIG", "Presets", "[ Important / Testing ] \0")
local force_tp = ui.new_checkbox("CONFIG", "Presets", "[ + ] Force TP")
local reconnect_on_end = ui.new_checkbox("CONFIG", "Presets", "[ + ] Reconnect on round end")
local reconnect_on_death = ui.new_checkbox("CONFIG", "Presets", "[ + ] Reconnect on death")

local last_server_time = globals.curtime ( )
local Targeted = "Unsafe"

function write_user_cmd_delta_to_buffer_hk(ecx, edx, slot, buf, from, to, new_command)
    local new_commands = ffi.cast("int*", ffi.cast("uintptr_t", buf) - 0x2C)[0]
    local backup_commands = ffi.cast("int*", ffi.cast("uintptr_t", buf) - 0x30)[0]

    if not did_spawn and not entity.is_alive(entity.get_local_player( )) and not ui.get( break_lua ) or ui.get( force_tp ) and ui.get( break_lua ) then
        local this_cmd = CInput.m_commands[from % 150]
        local next_cmd =  CInput.m_commands[to % 150]
        local third_cmd = CInput.m_commands[slot % 150]
        if this_cmd == nil or next_cmd == nil or third_cmd == nil then

        else
            third_cmd.command_number = next_cmd.command_number
            third_cmd.tick_count = next_cmd.tick_count

            next_cmd.command_number = this_cmd.command_number
            next_cmd.tick_count = this_cmd.tick_count

            this_cmd.tick_count = globals.tickcount( ) + 200
        end

        ClientState.net_channel.choked_packets = 200;
        local cmd_number = globals.lastoutgoingcommand( ) + globals.chokedcommands( ) + 1

        pcall(function( )
            if globals.curtime( ) - last_server_time > 0.2 and not ui.get(force_tp) then
                cvar.spec_mode:invoke_callback("6")
                local position = {2060.7819824219, -6149.4443359375, 1439.3687744141, -0.5, 1}
                cvar.spec_goto:invoke_callback(unpack(position))
                cvar.clear:invoke_callback()

                chlclientvmt["write_user_cmd_delta_to_buffer"](ecx, edx, slot, buf, cmd_number, cmd_number + 1, new_command)
                last_server_time = globals.curtime( )
                debug_log('team: ', Targeted, ' shifted: ', math.abs(from - cmd_number) + 1, ' max_shift: ', math.abs(from - cmd_number) + client.random_int(2, 9), ' position: ', list, ' requesting: ', send_team_request)
            end
        end)

        return chlclientvmt["write_user_cmd_delta_to_buffer"](ecx, edx, slot, buf, cmd_number, cmd_number + 1, new_command)
    else
        return chlclientvmt["write_user_cmd_delta_to_buffer"](ecx, edx, slot, buf, from, to, new_command)
    end
end

--hooks
chlclientvmt:hook_func("write_user_cmd_delta_to_buffer", 24, "bool(__fastcall*)(void* ecx, void* edx, int slot, void* buf, int from, int to, bool isnewcommand)", write_user_cmd_delta_to_buffer_hk)

--callbacks
client.set_event_callback("player_spawn", function(event)
    if client.userid_to_entindex(event.userid) == entity.get_local_player() and not ui.get( break_lua ) then
        did_spawn = true
        send_team_request = false
    end
end)

client.set_event_callback("jointeam_failed", function(event)
    if client.userid_to_entindex(event.userid) == entity.get_local_player() and not ui.get( break_lua ) then
        did_spawn = false
        send_team_request = true
    end
end)

client.set_event_callback("player_team", function(event)
    if client.userid_to_entindex(event.userid) == entity.get_local_player() and not ui.get( break_lua ) then
        did_spawn = false
        send_team_request = true
    end
end)

client.set_event_callback("player_death", function(event)
    if client.userid_to_entindex(event.userid) == entity.get_local_player() and ui.get(reconnect_on_death) and not ui.get( break_lua ) then
        did_spawn = false
        cvar.retry:invoke_callback("")
        send_team_request = true
    end
end)

client.set_event_callback("player_connect_full", function(event)
    if client.userid_to_entindex(event.userid) == entity.get_local_player() and not ui.get( break_lua ) then
        did_spawn = false
        send_team_request = true
    end
end)

client.set_event_callback("round_end", function(event)
    if ui.get(reconnect_on_end) and not ui.get( break_lua ) then
        cvar.retry:invoke_callback("")
    end
end)

client.set_event_callback("console_input", function(text)
    if (text:lower():find("retry") or text:lower():find("disconnect") or text:lower():find("connect") or text:lower():find("force")) and not ui.get( break_lua ) then
        cvar.retry:invoke_callback("")
        did_spawn = false
        last_server_time = globals.curtime( )
    end
end)

client.set_event_callback("string_cmd", function(cmd)
    local text = tostring(cmd.text)
    if text:lower( ):find("jointeam") then
        local len = #text
        text = text:sub(10, 10)
        text = tonumber(text)
        Targeted = text == 2 and 'Terrorist' or text == 3 and 'Counter Terrorist' or Targeted
    end
end)

debug_log('Note that this hooks WriteUserCmdDeltaToBuffer, use on insecure gameplay :ok_hand: 1337')
