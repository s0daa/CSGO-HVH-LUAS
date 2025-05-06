-- "From community, for community" © qhouz

local ffi = require "ffi"

local item_crash_fix do
    local CS_UM_SendPlayerItemFound = 63

    -- https://gitlab.com/KittenPopo/csgo-2018-source/-/blob/main/game/client/cdll_client_int.cpp#L883
    local DispatchUserMessage_t = ffi.typeof [[
        bool(__thiscall*)(void*, int msg_type, int nFlags, int size, const void* msg)
    ]]

    local VClient018 = client.create_interface("client.dll", "VClient018")

    local pointer = ffi.cast("uintptr_t**", VClient018)
    local vtable = ffi.cast("uintptr_t*", pointer[0])

    local size = 0

    while vtable[size] ~= 0x0 do
       size = size + 1
    end

    local hooked_vtable = ffi.new("uintptr_t[?]", size)

    for i = 0, size - 1 do
        hooked_vtable[i] = vtable[i]
    end

    pointer[0] = hooked_vtable

    local oDispatch = ffi.cast(DispatchUserMessage_t, vtable[38])

    local function hkDispatch(thisptr, msg_type, nFlags, size, msg)
        if msg_type == CS_UM_SendPlayerItemFound then
            return false
        end

        return oDispatch(thisptr, msg_type, nFlags, size, msg)
    end

    client.set_event_callback("shutdown", function()
        hooked_vtable[38] = vtable[38]
        pointer[0] = vtable
    end)

    hooked_vtable[38] = ffi.cast("uintptr_t", ffi.cast(DispatchUserMessage_t, hkDispatch))
end
