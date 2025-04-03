local hook local lib_found = pcall(function() hook = require("primordial/hooking library.174") end)

if (lib_found) then
    local command = {} command.__index, command.functions, command.function_id = {}, {}, 0

    command.add_callback = function(fn)
        if (type(fn) == "function") then 
            table.insert(command.functions, { fn = fn, id = command.function_id })

            command.function_id = command.function_id + 1
            return command.function_id
        end
    end

    command.remove_callback = function(id)
        for i = #command.functions, 1, -1 do
            if (command.functions[i].id == id) then
                table.remove(command.functions, i)

                return
            end
        end
    end

    local function __thiscall(func, this)
        return function(...)
            return func(this, ...)
        end
    end

    command.command_input = function(text)
        for i, tbl in pairs(command.functions) do
            local return_value = tbl.fn(text)

            if (return_value) then
                text = return_value
            end
        end

        return text
    end

    function client_cmd_unrestricted_hook(original)
        local original = original
        
        function client_cmd_unrestricted(this, text, bl)
            return original(this, command.command_input(ffi.string(text)), bl)
        end
        return client_cmd_unrestricted
    end

    function client_cmd_hook(original)
        local original = original
        
        function client_cmd(this, text)
            return original(this, command.command_input(ffi.string(text)))
        end
        return client_cmd
    end

    local engine_hook = hook.vmt.new(memory.create_interface("engine.dll", "VEngineClient014"))

    engine_hook.hookMethod("void*(__thiscall*)(void*, const char*, bool)", client_cmd_hook, 7)
    engine_hook.hookMethod("void*(__thiscall*)(void*, const char*, bool)", client_cmd_unrestricted_hook, 114)

    callbacks.add(e_callbacks.SHUTDOWN, function()
        engine_hook.unHookAll()
    end)

    return command
else
    print("Required library (Hooking Library) missing, subscribe to https://primordial.dev/resources/hooking-library.174/")
end