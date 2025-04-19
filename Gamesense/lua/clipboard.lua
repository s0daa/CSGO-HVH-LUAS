--
-- dependencies
--

local ffi = require "ffi"
local string_len, tostring, ffi_string = string.len, tostring, ffi.string

--
-- our module
--

local M = {}

--
-- game funcs (https://github.com/perilouswithadollarsign/cstrike15_src/blob/master/public/vgui/ISystem.h)
--

local native_GetClipboardTextCount = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
local native_SetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
local native_GetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")

local new_char_arr = ffi.typeof("char[?]")

-- returns (pastes) clipboard text
function M.get()
	local len = native_GetClipboardTextCount()

	if len > 0 then
		local char_arr = new_char_arr(len)
		native_GetClipboardText(0, char_arr, len)
		return ffi_string(char_arr, len-1)
	end
end
M.paste = M.get

-- sets (copies) the clipboard text
function M.set(text)
	text = tostring(text)

	native_SetClipboardText(text, string_len(text))
end
M.copy = M.set

return M