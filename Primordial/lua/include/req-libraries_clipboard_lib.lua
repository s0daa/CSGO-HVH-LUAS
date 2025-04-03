local vgui_sys = 'VGUI_System010'
local vgui2 = 'vgui2.dll'

local function VTableBind(mod, face, n, type)
	local iface = memory.create_interface(mod, face) or error(face .. ": invalid interface")
	local instance = memory.get_vfunc(iface, n) or error(index .. ": invalid index")
	local success, typeof = pcall(ffi.typeof, type)
	if not success then
		error(typeof, 2)
	end
	local fnptr = ffi.cast(typeof, instance) or error(type .. ": invalid typecast")
	return function(...)
		return fnptr(tonumber(ffi.cast("void***", iface)), ...)
	end
end

local native_GetClipboardTextCount = VTableBind(vgui2, vgui_sys, 7, "int(__thiscall*)(void*)")
local native_SetClipboardText = VTableBind(vgui2, vgui_sys, 9, "void(__thiscall*)(void*, const char*, int)")
local native_GetClipboardText = VTableBind(vgui2, vgui_sys, 11, "int(__thiscall*)(void*, int, const char*, int)")

return {
	get = function( )
        local len = native_GetClipboardTextCount( )
        if ( len > 0 ) then
            local char_arr = ffi.typeof("char[?]")( len )
            native_GetClipboardText( 0, char_arr, len )
            return ffi.string( char_arr, len - 1 )
        end
    end,
	set = function( text )
        text = tostring( text )
	    native_SetClipboardText( text, string.len( text ) )
    end
}