local ffi = require("ffi")
local hook = require("hooking library")

local function vtable_bind(module, interface, index, type)
    local addr = ffi.cast("void***", memory.create_interface(module, interface)) or error(interface .. " is nil.")
    return ffi.cast(ffi.typeof(type), addr[0][index]), addr
end

local function __thiscall(func, this) -- bind wrapper for __thiscall functions
    return function(...)
        return func(this, ...)
    end
end

local nativeCreateFont =
    __thiscall(vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 71, "unsigned int(__thiscall*)(void*)"))
local nativeSetFontGlyph =
    __thiscall(
    vtable_bind(
        "vguimatsurface.dll",
        "VGUI_Surface031",
        72,
        "void(__thiscall*)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int)"
    )
)

local text_primary_font=nativeCreateFont()
nativeSetFontGlyph(text_primary_font, "arial", 14, 400, 0, 0, 0, 0, 0)

local o_always_override = menu.add_checkbox("global", "always override", false)

local o_background = menu.add_checkbox("custom colors", "background color", false)
local o_background_color = o_background:add_color_picker("background_color", color_t(90, 136, 182, 255))

local o_secondary = menu.add_checkbox("custom colors", "secondary color", false)
local o_secondary_color = o_secondary:add_color_picker("secondary_color", color_t(90, 136, 182, 255))

local o_border = menu.add_checkbox("custom colors", "border color", false)
local o_border_color = o_border:add_color_picker("border_color", color_t(90, 136, 182, 255))

local o_subtab = menu.add_checkbox("custom colors", "subtab color", false)
local o_subtab_color = o_subtab:add_color_picker("subtab_color", color_t(90, 136, 182, 255))

local o_selected = menu.add_checkbox("custom colors", "selected color", false)
local o_selected_color = o_selected:add_color_picker("selected_color", color_t(90, 136, 182, 255))

local o_text_primary = menu.add_checkbox("custom fonts", "text primary color", false)
local o_text_primary_color = o_text_primary:add_color_picker("text_primary_color", color_t(90, 136, 182, 255))

local o_text_secondary = menu.add_checkbox("custom fonts", "text secondary color", false)
local o_text_secondary_color = o_text_secondary:add_color_picker("text_secondary_color", color_t(90, 136, 182, 255))

local o_text_tertiary = menu.add_checkbox("custom fonts", "text tertiary color", false)
local o_text_tertiary_color = o_text_tertiary:add_color_picker("text_tertiary_color", color_t(90, 136, 182, 255))

local o_fonts = menu.add_checkbox("custom fonts", "override fonts", false)

function DrawSetColorHook(originalFunction)
	local originalFunction=originalFunction
	function DrawSetColor(this,r,b,g,a)
		if not menu.is_open() and not o_always_override:get() then return originalFunction(this,r,b,g,a) end
		if o_secondary:get() and r==45 and g==45 and b==45 then
			local col=o_secondary_color:get()
			r=col.r
			b=col.g
			g=col.b
			a=col.a
		end
		if o_selected:get() and r==32 and g==32 and b==32 then
			local col=o_selected_color:get()
			r=col.r
			b=col.g
			g=col.b
			a=col.a
		end
		if o_border:get() and r==0 and g==0 and b==0 and a==170 then
			local col=o_border_color:get()
			r=col.r
			b=col.g
			g=col.b
			a=col.a
		end
		if o_subtab:get() and r==36 and g==36 and b==36 then
			local col=o_subtab_color:get()
			r=col.r
			b=col.g
			g=col.b
			a=col.a
		end
		if o_background:get() and r==28 and g==28 and b==28 then
			local col=o_background_color:get()
			r=col.r
			b=col.g
			g=col.b
			a=col.a
		end
		return originalFunction(this,r,b,g,a)
	end
	return DrawSetColor
end

function DrawSetTextColorHook(originalFunction)
	local originalFunction=originalFunction
	function DrawSetTextColor(this,r,b,g,a)
		if not menu.is_open() and not o_always_override:get() then return originalFunction(this,r,b,g,a) end
		if o_text_primary:get() and r<=200 and r>170 and g==r and b==r then
			local col=o_text_primary_color:get()
			r=col.r
			b=col.g
			g=col.b
			a=col.a
		end
		if o_text_tertiary:get() and r==140 and g==140 and b==140 then
			local col=o_text_tertiary_color:get()
			r=col.r
			b=col.g
			g=col.b
			a=col.a
		end
		if o_text_secondary:get() and r==170 and g==170 and b==170 then
			local col=o_text_secondary_color:get()
			r=col.r
			b=col.g
			g=col.b
			a=col.a
		end
		return originalFunction(this,r,b,g,a)
	end
	return DrawSetTextColor
end

function DrawSetTextFontHook(originalFunction)
	local originalFunction=originalFunction
	function DrawSetTextFont(this,id)
		if (menu.is_open() or o_always_override:get()) and o_fonts:get() and id==302 then id=text_primary_font end
		return originalFunction(this,id)
	end
	return DrawSetTextFont
end

function DrawPrintTextHook(originalFunction)
	local originalFunction=originalFunction
	function DrawPrintText(this,text,length,gggg)
		print(text)
		return originalFunction(this,text,length,gggg)
	end
	return DrawPrintText
end

local ISurface=hook.vmt.new(memory.create_interface("vguimatsurface.dll", "VGUI_Surface031"))

ISurface.hookMethod("void(__thiscall*)(void*, int, int, int, int)",DrawSetColorHook,15)
ISurface.hookMethod("void(__thiscall*)(void*, int, int, int, int)",DrawSetTextColorHook,25)
ISurface.hookMethod("void(__thiscall*)(void*, unsigned long)",DrawSetTextFontHook,23)
--ISurface.hookMethod("void(__thiscall*)(void*, const wchar_t*, int, int)",DrawPrintTextHook,28)

local function on_shutdown()
    ISurface.unHookAll()
end

callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)