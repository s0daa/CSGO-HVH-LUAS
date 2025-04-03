local get_module_handle_sig = memory.find_pattern("engine.dll", " FF 15 ? ? ? ? 85 C0 74 0B") or
                                  error("couldn't find GetModuleHandle signature")
local get_proc_address_sig = memory.find_pattern("engine.dll", " FF 15 ? ? ? ? A3 ? ? ? ? EB 05") or
                                 error("Couldn't find GetProcAddress signature")

local get_proc_address_addr = ffi.cast("uint32_t**", ffi.cast("uint32_t", get_proc_address_sig) + 2)[0][0]
local get_proc_address = ffi.cast("void*(__stdcall*)(void*, const char*)", get_proc_address_addr)

local get_module_handle_addr = ffi.cast("uint32_t**", ffi.cast("uint32_t", get_module_handle_sig) + 2)[0][0]
local get_module_handle = ffi.cast("void*(__stdcall*)(const char*)", get_module_handle_addr)

ffi.cdef [[
    typedef void* (*get_interface_fn)();

    typedef struct {
        get_interface_fn get;
        char* name;
        void* next;
    } interface;
]]

local function create_interface(module, interface_name)
    local create_interface_addr = ffi.cast("int", get_proc_address(get_module_handle(module), "CreateInterface"))
    local interface = ffi.cast("interface***",
                          create_interface_addr + ffi.cast("int*", create_interface_addr + 5)[0] + 15)[0][0]

    while interface ~= ffi.NULL do
        if ffi.string(interface.name):match(interface_name .. "%d+") then
            return interface.get()
        end

        interface = ffi.cast("interface*", interface.next)
    end
end

return create_interface