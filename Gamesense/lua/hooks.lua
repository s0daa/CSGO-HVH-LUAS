local pGetModuleHandle_sig =
    utils.find_pattern("engine.dll", " FF 15 ? ? ? ? 85 C0 74 0B") or error("Couldn't find signature #1")
local pGetProcAddress_sig =
    utils.find_pattern("engine.dll", " FF 15 ? ? ? ? A3 ? ? ? ? EB 05") or error("Couldn't find signature #2")

local jmp_ecx = utils.find_pattern("engine.dll", " FF E1")

local pGetProcAddress = ffi.cast("uint32_t**", ffi.cast("uint32_t", pGetProcAddress_sig) + 2)[0][0]
local fnGetProcAddress = ffi.cast("uint32_t(__stdcall*)(uint32_t, const char*)", pGetProcAddress)

local pGetModuleHandle = ffi.cast("uint32_t**", ffi.cast("uint32_t", pGetModuleHandle_sig) + 2)[0][0]
local fnGetModuleHandle = ffi.cast("uint32_t(__stdcall*)(const char*)", pGetModuleHandle)

local function proc_bind(module_name, function_name, typedef)
    local ctype = ffi.typeof(typedef)
    local module_handle = fnGetModuleHandle(module_name)
    local proc_address = fnGetProcAddress(module_handle, function_name)
    local call_fn = ffi.cast(ctype, proc_address)

    return call_fn
end

local nativeVirtualProtect =
    proc_bind(
    "kernel32.dll",
    "VirtualProtect",
    "int(__stdcall*)(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect)"
)
local nativeVirtualAlloc =
    proc_bind(
    "kernel32.dll",
    "VirtualAlloc",
    "void*(__stdcall*)(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect)"
)
local nativeVirtualFree =
    proc_bind(
    "kernel32.dll",
    "VirtualFree",
    "int(__stdcall*)(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType)"
)

local function copy(dst, src, len)
    --if 1==1 then print(dst,src,len) return  end
    return ffi.copy(ffi.cast("void*", dst), ffi.cast("const void*", src), len)
end

local buff = {free = {}}

local function VirtualProtect(lpAddress, dwSize, flNewProtect, lpflOldProtect)
    return nativeVirtualProtect(ffi.cast("void*", lpAddress), dwSize, flNewProtect, lpflOldProtect)
end

local function VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect, blFree)
    local alloc = nativeVirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect)
    if blFree then
        table.insert(buff.free, alloc)
    end
    return ffi.cast("intptr_t", alloc)
end

local buffer = VirtualAlloc(nil, 10, 0x1000, 0x40, true)

--VMT HOOKS
local vmt_hook = {hooks = {}}
function vmt_hook.new(vt)
    local new_hook = {}
    local org_func = {}
    local old_prot = ffi.new("unsigned long[1]")
    local virtual_table = ffi.cast("intptr_t**", vt)[0]
    new_hook.this = virtual_table
    new_hook.hookMethod = function(cast, func, method)
        org_func[method] = virtual_table[method]
        VirtualProtect(virtual_table + method, 4, 0x4, old_prot)
        virtual_table[method] = ffi.cast("intptr_t", ffi.cast(cast, func(ffi.cast(cast, org_func[method]))))
        VirtualProtect(virtual_table + method, 4, old_prot[0], old_prot)
        return
    end
    new_hook.unHookMethod = function(method)
        VirtualProtect(virtual_table + method, 4, 0x4, old_prot)
        virtual_table[method] = org_func[method]
        VirtualProtect(virtual_table + method, 4, old_prot[0], old_prot)
        org_func[method] = nil
    end
    new_hook.unHookAll = function()
        for method, func in pairs(org_func) do
            new_hook.unHookMethod(method)
        end
    end
    table.insert(vmt_hook.hooks, new_hook.unHookAll)
    return new_hook
end
--VMT HOOKS
--JMP HOOKS
local jmp_hook = {hooks = {}}
function jmp_hook.new(cast, callback, hook_addr, size, trampoline, org_bytes_tramp)
    local size = size or 5
    local trampoline = trampoline or false
    local new_hook, mt = {}, {}
    local detour_addr
    local old_prot = ffi.new("unsigned long[1]")
    local org_bytes = ffi.new("uint8_t[?]", size)
    copy(org_bytes, hook_addr, size)
    if trampoline then
        local alloc_addr = VirtualAlloc(nil, size + 5, 0x1000, 0x40, true)
        detour_addr = tonumber(ffi.cast("intptr_t", ffi.cast(cast, callback(ffi.cast(cast,alloc_addr)))))
        local trampoline_bytes = ffi.new("uint8_t[?]", size + 5, 0x90)
        if org_bytes_tramp then
            local i = 0
            for byte in string.gmatch(org_bytes_tramp,"(%x%x)") do
                trampoline_bytes[i] = tonumber(byte, 16)
                i = i + 1
            end
        else
            copy(trampoline_bytes, org_bytes, size)
        end
        trampoline_bytes[size] = 0xE9
        ffi.cast("int32_t*", trampoline_bytes + size + 1)[0] = hook_addr - tonumber(alloc_addr) - size + (size - 5)
        copy(alloc_addr, trampoline_bytes, size + 5)
        new_hook.call = ffi.cast(cast, alloc_addr)
        mt = {
            __call = function(self, ...)
                return self.call(...)
            end
        }
    else
        detour_addr = tonumber(ffi.cast("intptr_t", ffi.cast(cast, callback(ffi.cast(cast,hook_addr)))))
        new_hook.call = ffi.cast(cast, hook_addr)
        mt = {
            __call = function(self, ...)
                self.stop()
                local res = self.call(...)
                self.start()
                return res
            end
        }
    end
    local hook_bytes = ffi.new("uint8_t[?]", size, 0x90)
    hook_bytes[0] = 0xE9
    ffi.cast("int32_t*", hook_bytes + 1)[0] = (detour_addr-hook_addr - 5)
    new_hook.status = false
    local function set_status(bool)
        new_hook.status = bool
        VirtualProtect(hook_addr, size, 0x40, old_prot)
        copy(hook_addr, bool and hook_bytes or org_bytes, size)
        VirtualProtect(hook_addr, size, old_prot[0], old_prot)
    end
    new_hook.stop = function()
        set_status(false)
    end
    new_hook.start = function()
        set_status(true)
    end
    new_hook.start()
    if org_bytes[0] == 0xE9 or org_bytes[0] == 0xE8 then
        print("[WARNING] rewrote another hook" .. (trampoline and " (old hook was disabled, through trampoline)" or ""))
    end
    table.insert(jmp_hook.hooks, new_hook)
    return setmetatable(new_hook, mt)
end
--JMP HOOKS
--CALL HOOKS
local call_hook = {hooks = {}}
function call_hook.new(cast, callback, hook_addr)
    if ffi.cast("uint8_t*", hook_addr)[0] ~= 0xE8 then
        return
    end
    local new_hook = {}
    new_hook.call = ffi.cast(cast, ffi.cast("intptr_t*", hook_addr + 1)[0] + hook_addr + 5)
    local detour_addr = tonumber(ffi.cast("intptr_t", ffi.cast(cast, callback(new_hook.call))))
    local void_addr = ffi.cast("void*", hook_addr)
    local old_prot = ffi.new("unsigned long[1]")
    local org_bytes = ffi.new("uint8_t[?]", 5)
    copy(org_bytes, void_addr, 5)
    local hook_bytes = ffi.new("uint8_t[?]", 5, 0xE8)
    ffi.cast("uint32_t*", hook_bytes + 1)[0] = detour_addr - hook_addr - 5
    new_hook.status = false
    local function set_status(bool)
        new_hook.status = bool
        nativeVirtualProtect(void_addr, 5, 0x40, old_prot)
        copy(void_addr, bool and hook_bytes or org_bytes, 5)
        nativeVirtualProtect(void_addr, 5, old_prot[0], old_prot)
    end
    new_hook.stop = function()
        set_status(false)
    end
    new_hook.start = function()
        set_status(true)
    end
    new_hook.start()
    table.insert(call_hook.hooks, new_hook)
    return setmetatable(
        new_hook,
        {
            __call = function(self, ...)
                local res = self.call(...)
                return res
            end
        }
    )
end
--CALL HOOKS

function on_shutdown()
    for i, hook in ipairs(jmp_hook.hooks) do
        if hook.status then
            hook.stop()
        end
    end
    for i, hook in ipairs(call_hook.hooks) do
        if hook.status then
            hook.stop()
        end
    end
    for i, addr in ipairs(buff.free) do
        nativeVirtualFree(addr, 0, 0x8000)
    end
    for i, unHookFunc in ipairs(vmt_hook.hooks) do
        unHookFunc()
    end
end

return {vmt = vmt_hook, jmp = jmp_hook, call = call_hook, proc_bind = proc_bind}
