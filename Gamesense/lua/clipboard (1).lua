-- all credits to sapphyrus
local string_len, tostring, ffi_string = string.len, tostring, ffi.string

local vgui_sys = ffi.cast(ffi.typeof("void***"), utils.find_interface("vgui2.dll", "VGUI_System010"))
local native_GetClipboardTextCount = ffi.cast("int(__thiscall*)(void*)", vgui_sys[0][7])
local native_SetClipboardText = ffi.cast("void(__thiscall*)(void*, const char*, int)", vgui_sys[0][9])
local native_GetClipboardText = ffi.cast("int(__thiscall*)(void*, int, const char*, int)", vgui_sys[0][11])
local new_char_arr = ffi.typeof("char[?]")

local M = {}
function M.get()
    local len = native_GetClipboardTextCount(vgui_sys)

    if len > 0 then
        local char_arr = new_char_arr(len)
        native_GetClipboardText(vgui_sys, 0, char_arr, len)
        return ffi_string(char_arr, len-1)
    end
end

function M.set(text)
    text = tostring(text)

    native_SetClipboardText(vgui_sys, text, string_len(text))
end

M.paste = M.get
M.copy  = M.set
return M