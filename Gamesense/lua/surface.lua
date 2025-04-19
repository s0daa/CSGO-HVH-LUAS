local M = {}

local ffi = require "ffi"
local bit = require "bit"

local bit_bor = bit.bor
local ffi_string = ffi.string
local ffi_cast = ffi.cast

local function vmt_entry(instance, index, type)
	return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end

-- instance is bound to the callback as an upvalue
local function vmt_bind(module, interface, index, typestring)
	local instance = client.create_interface(module, interface) or error("invalid interface")
	local success, typeof = pcall(ffi.typeof, typestring)
	if not success then
		error(typeof, 2)
	end
	local fnptr = vmt_entry(instance, index, typeof) or error("invalid vtable")
	return function(...)
		return fnptr(instance, ...)
	end
end

-- instance will be passed to the function at runtime
local function vmt_thunk(index, typestring)
	local t = ffi.typeof(typestring)
	return function(instance, ...)
		assert(instance ~= nil)
		if instance then
			return vmt_entry(instance, index, t)(instance, ...)
		end
	end
end

local new_charbuffer = ffi.typeof("char[?]")
local new_intptr = ffi.typeof("int[1]")
local new_widebuffer = ffi.typeof("wchar_t[?]")

-- localize
local native_Localize_ConvertAnsiToUnicode 	= vmt_bind("localize.dll", "Localize_001", 15, "int(__thiscall*)(void*, const char*, wchar_t*, int)")
local native_Localize_ConvertUnicodeToAnsi 	= vmt_bind("localize.dll", "Localize_001", 16, "int(__thiscall*)(void*, wchar_t*, char*, int)")
local native_Localize_FindSafe 							= vmt_bind("localize.dll", "Localize_001", 12, "wchar_t*(__thiscall*)(void*, const char*)")

-- surface
local native_Surface_DrawSetColor 				= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 15, "void(__thiscall*)(void*, int, int, int, int)")
local native_Surface_DrawFilledRect 			= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 16, "void(__thiscall*)(void*, int, int, int, int)")
local native_Surface_DrawOutlinedRect 		= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 18, "void(__thiscall*)(void*, int, int, int, int)")
local native_Surface_DrawLine 						= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 19, "void(__thiscall*)(void*, int, int, int, int)")
local native_Surface_DrawPolyLine 				= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 20, "void(__thiscall*)(void*, int*, int*, int)")
local native_Surface_DrawSetTextFont 			= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 23, "void(__thiscall*)(void*, unsigned long)")
local native_Surface_DrawSetTextColor 		= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 25, "void(__thiscall*)(void*, int, int, int, int)")
local native_Surface_DrawSetTextPos 			= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 26, "void(__thiscall*)(void*, int, int)")
local native_Surface_DrawPrintText 				= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 28, "void(__thiscall*)(void*, const wchar_t*, int, int)")
local native_Surface_DrawGetTextureId 		= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 34, "int(__thiscall*)(void*, const char*)") -- new
local native_Surface_DrawGetTextureFile 	= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 35, "bool(__thiscall*)(void*, int, char*, int)") -- new
local native_Surface_DrawSetTextureFile 	= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 36, "void(__thiscall*)(void*, int, const char*, int, bool)") -- new
local native_Surface_DrawSetTextureRGBA 	= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 37, "void(__thiscall*)(void*, int, const wchar_t*, int, int)") -- new
local native_Surface_DrawSetTexture 			= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 38, "void(__thiscall*)(void*, int)") -- new
local native_Surface_DeleteTextureByID 		= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 39, "void(__thiscall*)(void*, int)") -- new
local native_Surface_DrawGetTextureSize 	= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 40, "void(__thiscall*)(void*, int, int&, int&)") -- new
local native_Surface_DrawTexturedRect 		= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 41, "void(__thiscall*)(void*, int, int, int, int)")
local native_Surface_IsTextureIDValid 		= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 42, "bool(__thiscall*)(void*, int)") -- new
local native_Surface_CreateNewTextureID 	= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 43, "int(__thiscall*)(void*, bool)") -- new
local native_Surface_UnlockCursor 				= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 66, "void(__thiscall*)(void*)")
local native_Surface_LockCursor 					= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 67, "void(__thiscall*)(void*)")
local native_Surface_CreateFont 					= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 71, "unsigned int(__thiscall*)(void*)")
local native_Surface_SetFontGlyph 				= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 72, "void(__thiscall*)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int)")
local native_Surface_GetTextSize 					= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 79, "void(__thiscall*)(void*, unsigned long, const wchar_t*, int&, int&)")
local native_Surface_GetCursorPos 				= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 100, "unsigned int(__thiscall*)(void*, int*, int*)")
local native_Surface_SetCursorPos					= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 101, "unsigned int(__thiscall*)(void*, int, int)")
local native_Surface_DrawOutlinedCircle 	= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 103, "void(__thiscall*)(void*, int, int, int, int)")
local native_Surface_DrawFilledRectFade 	= vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 123, "void(__thiscall*)(void*, int, int, int, int, unsigned int, unsigned int, bool)")

local function draw_print_text(text, localized)
	if localized then
		local cb_size = 1024
		local char_buffer = new_charbuffer(cb_size)
		native_Localize_ConvertUnicodeToAnsi(text, char_buffer, cb_size)

		local test = ffi_string(char_buffer)
		return native_Surface_DrawPrintText(text, test:len(), 0)
	else
		local wb_size = 1024
		local wide_buffer = new_widebuffer(wb_size)

		native_Localize_ConvertAnsiToUnicode(text, wide_buffer, wb_size)
		return native_Surface_DrawPrintText(wide_buffer, text:len(), 0)
	end
end

local function get_text_size(font, text)
	local wide_buffer = new_widebuffer(1024)
	local w_ptr = new_intptr()
	local h_ptr = new_intptr()

	native_Localize_ConvertAnsiToUnicode(text, wide_buffer, 1024)
	native_Surface_GetTextSize(font, wide_buffer, w_ptr, h_ptr)

	local w = tonumber(w_ptr[0])
	local h = tonumber(h_ptr[0])

	return w, h
end

--------------------------
-- renderer functions --
--------------------------

-- cache fonts since we cant delete them, so if multiple scripts create the same font they get the same ID
local font_cache = {}

function M.create_font(windows_font_name, tall, weight, flags)
	local flags_i = 0
	local t = type(flags)
	if t == "number" then
		flags_i = flags
	elseif t == "table" then
		for i=1, #flags do
			flags_i = flags_i + flags[i]
		end
	else
		error("invalid flags type, has to be number or table")
	end

	local cache_key = string.format("%s\0%d\0%d\0%d", windows_font_name, tall, weight, flags_i)
	if font_cache[cache_key] == nil then
		font_cache[cache_key] = native_Surface_CreateFont()
		native_Surface_SetFontGlyph(font_cache[cache_key], windows_font_name, tall, weight, 0, 0, bit_bor(flags_i), 0, 0)
	end

	return font_cache[cache_key]
end

function M.localize_string(str, buf_size)
	local res = native_Localize_FindSafe(str)
	local charbuffer = new_charbuffer(buf_size or 1024)
	native_Localize_ConvertUnicodeToAnsi(res, charbuffer, buf_size or 1024)
	return charbuffer and ffi_string(charbuffer) or nil
end

function M.draw_text(x, y, r, g, b, a, font, text)
	native_Surface_DrawSetTextPos(x, y)
	native_Surface_DrawSetTextFont(font)
	native_Surface_DrawSetTextColor(r, g, b, a)
	return draw_print_text(text, false)
end

function M.draw_localized_text(x, y, r, g, b, a, font, text)
	native_Surface_DrawSetTextPos(x, y)
	native_Surface_DrawSetTextFont(font)
	native_Surface_DrawSetTextColor(r, g, b, a)

	local localized_string = native_Localize_FindSafe(text)
	return draw_print_text(localized_string, true)
end

function M.draw_line(x0, y0, x1, y1, r, g, b, a)
	native_Surface_DrawSetColor(r, g, b, a)
	return native_Surface_DrawLine(x0, y0, x1, y1)
end

function M.draw_filled_rect(x, y, w, h, r, g, b, a)
	native_Surface_DrawSetColor(r, g, b, a)
	return native_Surface_DrawFilledRect(x, y, x + w, y + h)
end

function M.draw_outlined_rect(x, y, w, h, r, g, b, a)
	native_Surface_DrawSetColor(r, g, b, a)
	return native_Surface_DrawOutlinedRect(x, y, x + w, y + h)
end

function M.draw_filled_outlined_rect(x, y, w, h, r0, g0, b0, a0, r1, g1, b1, a1)
	native_Surface_DrawSetColor(r0, g0, b0, a0)
	native_Surface_DrawFilledRect(x, y, x + w, y + h)
	native_Surface_DrawSetColor(r1, g1, b1, a1)
	return native_Surface_DrawOutlinedRect(x, y, x + w, y + h)
end

function M.draw_filled_gradient_rect(x, y, w, h, r0, g0, b0, a0, r1, g1, b1, a1, horizontal)
	native_Surface_DrawSetColor(r0, g0, b0, a0)
	native_Surface_DrawFilledRectFade(x, y, x + w, y + h, 255, 255, horizontal)

	native_Surface_DrawSetColor(r1, g1, b1, a1)
	return native_Surface_DrawFilledRectFade(x, y, x + w, y + h, 0, 255, horizontal)
end

function M.draw_outlined_circle(x, y, r, g, b, a, radius, segments)
	native_Surface_DrawSetColor(r, g, b, a)
	return native_Surface_DrawOutlinedCircle(x, y, radius, segments)
end

function M.draw_poly_line(x, y, r, g, b, a, count)
	native_Surface_DrawSetColor(r, g, b, a)
	return native_Surface_DrawPolyLine(new_intptr(x), new_intptr(y), count)
end

function M.test_font(x, y, r, g, b, a, font)
	local _, height_offset = get_text_size(font, "a b c d e f g h i j k l m n o p q r s t u v w x y z")

	M.draw_text(x, y, r, g, b, a, font, "a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 ß + # ä ö ü , . -")
	M.draw_text(x, y + height_offset, r, g, b, a,  font, "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z = ! \" § $ % & / ( ) = ? { [ ] } \\ * ' _ : ; ~ ")
end

function M.get_text_size(font, text)
	return get_text_size(font, text)
end

function M.set_mouse_pos(x, y)
	return native_Surface_SetCursorPos(x, y)
end

function M.get_mouse_pos()
	local x_ptr = new_intptr()
	local y_ptr = new_intptr()

	native_Surface_GetCursorPos(x_ptr, y_ptr)

	local x = tonumber(x_ptr[0])
	local y = tonumber(y_ptr[0])

	return x, y
end

function M.unlock_cursor()
	return native_Surface_UnlockCursor()
end

function M.lock_cursor()
	return native_Surface_LockCursor()
end

function M.load_texture(filename)
	local texture = native_Surface_CreateNewTextureID(false)
	native_Surface_DrawSetTextureFile(texture, filename, true, true)

	local wide_ptr = new_intptr()
	local tall_ptr = new_intptr()
	native_Surface_DrawGetTextureSize(texture, wide_ptr, tall_ptr)

	local w = tonumber(wide_ptr[0])
	local h = tonumber(tall_ptr[0])

	return texture, w, h
end

-- fallback to built in renderer
setmetatable(M, {
	__index = renderer
})

return M