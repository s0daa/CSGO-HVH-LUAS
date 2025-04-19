local ffi = require("ffi")
local surface = require 'gamesense/surface'
local bit = require("bit")

local ui_newstring = ui.new_string
local ui_get = ui.get
local ui_set = ui.set
local callback = client.set_event_callback
local set_cvar = client.set_cvar
local ui_newlable = ui.new_label
local get_cvar = client.get_cvar
local ui_button = ui.new_button
local find_sig = client.find_signature
local ui_text = ui.new_textbox
local ui_slider = ui.new_slider
local new_string = ui.new_string
local ui_multiselset = ui.new_multiselect
local ui_combobox = ui.new_combobox



--Store old cvar value
local net_graph_oldval = cvar.net_graph:get_int()
local net_graphpos_oldval = cvar.net_graphpos:get_int()


ui_newlable("LUA","A", "Enter font name:")
local textbox = ui_text("LUA", "A", "Font_name")
local size = ui_slider("LUA", "A", "Font size", 1, 40, 25)
local pos_t = ui_slider("LUA", "A", "Position", 1, 3, net_graphpos_oldval)

local new_string = new_string("Verdana")
local font_flags = ui_multiselset("LUA", "A", "Font Flags", {"ITALIC", "UNDERLINE","STRIKEOUT", "ANTIALIAS", "DROPSHADOW", "OUTLINE"})
local new_combo = ui_combobox("LUA", "A", "Width", {"THIN", "EXTRALIGHT", "LIGHT", "NORMAL", "MEDIUM", "SEMIBOLD", "BOLD", "EXTRABOLD", "HEAVY"})


ui_newlable("LUA","A", "Default Color")
local net_graph_color_def = ui.new_color_picker("LUA", "A", "nc_api_clr_default", 229,229,178,255)
ui_newlable("LUA","A", "Warning 1 Color")
local net_graph_color_w1 = ui.new_color_picker("LUA", "A", "nc_api_clr_warning1", 255,255,31,255)
ui_newlable("LUA","A", "Warning 2 Color")
local net_graph_color_w2 = ui.new_color_picker("LUA", "A", "nc_api_clr_warning2", 255,125,31,255)
ui_newlable("LUA","A", "Warning 3 Color")
local net_graph_color_w3 = ui.new_color_picker("LUA", "A", "nc_api_clr_warning3", 255,31,31,255)
ui_set(textbox, ui_get(new_string))


ffi.cdef[[

	struct color_net_graph{
        unsigned char r, g, b, a; 
	};
	
	// reversed using reclass, todo: get the x coord of netgraph out of memory stack
	struct CNetGraphPanel
	{
		char pad_0x0000[0x1A5]; 
		
		struct color_net_graph textColorDefault;
		struct color_net_graph textColorWarn1;
		struct color_net_graph textColorWarn2; 
		struct color_net_graph textColorWarn3; 

		char pad_0x01B5[0x13053]; 

		unsigned int m_font_small;  
		unsigned int m_font_proportional; 
		unsigned int m_font_font; 

		char pad_0x13214[0x20]; 

		int m_EstimatedWidth; 
		int m_nNetGraphHeight; 
		char pad_0x1323C[0x35E8]; 
	}; //Size=0x16838
	typedef int(__thiscall* get_clipboard_text_count_fsdjfdjsjfjfj)(void*);
	typedef void(__thiscall* set_clipboard_text_fsdjfdjsjfjfj)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text_fsdjfdjsjfjfj)(void*, int, const char*, int);

]]

local VGUI_System010 =  client.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi.cast( ffi.typeof( "void***" ), VGUI_System010 )

local get_clipboard_text_count = ffi.cast( "get_clipboard_text_count_fsdjfdjsjfjfj", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi.cast( "set_clipboard_text_fsdjfdjsjfjfj", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi.cast( "get_clipboard_text_fsdjfdjsjfjfj", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")


local constructor_signature = find_sig("client.dll", "\x89\x1D\xCC\xCC\xCC\xCC\x8B\xC3")
local net_graph_pointer = ffi.cast("char*", constructor_signature) + 0x2

local CNetGraphpanel_t = ffi.cast("struct CNetGraphPanel***", net_graph_pointer)[0][0]


local function get_clipboard()
	local clipboard_text_length = get_clipboard_text_count( VGUI_System )
	if clipboard_text_length > 0 then
	  local buffer = ffi.new("char[?]", clipboard_text_length)
	  local size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)
	  get_clipboard_text( VGUI_System, 0, buffer, size )
	  local clipboard_data = ffi.string( buffer, clipboard_text_length-1 )
	  return clipboard_data
	else
	  return nil
	end
  end


callback("run_command", function()

	--net_graph position cvar
	cvar.net_graphpos:set_int(ui.get(pos_t)) 

	--Default color
	local r_default, g_default, b_default, a_default = ui_get(net_graph_color_def)
	CNetGraphpanel_t.textColorDefault.r = r_default
    CNetGraphpanel_t.textColorDefault.g = g_default
	CNetGraphpanel_t.textColorDefault.b = b_default
	CNetGraphpanel_t.textColorDefault.a = a_default
	--Default color

	--Warning1 color
	local r_warning1, g_warning1, b_warning1, a_warning1 = ui_get(net_graph_color_w1)
	CNetGraphpanel_t.textColorWarn1.r = r_warning1
    CNetGraphpanel_t.textColorWarn1.g = g_warning1
	CNetGraphpanel_t.textColorWarn1.b = b_warning1
	CNetGraphpanel_t.textColorWarn1.a = a_warning1
	--Warning1 color
	
	--Warning2 color
	local r_warning2, g_warning2, b_warning2, a_warning2 = ui_get(net_graph_color_w2)
	CNetGraphpanel_t.textColorWarn1.r = r_warning2
    CNetGraphpanel_t.textColorWarn2.g = g_warning2
	CNetGraphpanel_t.textColorWarn2.b = b_warning2
	CNetGraphpanel_t.textColorWarn2.a = a_warning2
	--Warning2 color

	--Warning3 color
	local r_warning3, g_warning3, b_warning3, a_warning3 = ui_get(net_graph_color_w3)
	CNetGraphpanel_t.textColorWarn3.r = r_warning3
    CNetGraphpanel_t.textColorWarn3.g = g_warning3
	CNetGraphpanel_t.textColorWarn3.b = b_warning3
	CNetGraphpanel_t.textColorWarn3.a = a_warning3
	--Warning3 color
end)

local STRTOBITMASK = {
	["ITALIC"]		  = 0x001,
	["UNDERLINE"]	   = 0x002,
	["STRIKEOUT"]	   = 0x004,
	["ANTIALIAS"]	   = 0x010,
	["DROPSHADOW"]	  = 0x080,
	["OUTLINE"]		 = 0x200,
}

local STRTONUM = {
	["THIN"]			= 100,
	["EXTRALIGHT"]	  = 200,
	["LIGHT"]		   = 300,
	["NORMAL"]		  = 400,
	["MEDIUM"]		  = 500,
	["SEMIBOLD"]		= 600,
	["BOLD"]			= 700,
	["EXTRABOLD"]	   = 800,
	["HEAVY"]		   = 900,
}

local insert_font_name = ui_button("LUA", "A", "Get Font Name from Clipboard", function ()
	ui_set(textbox,get_clipboard())
end)

local button = ui_button("LUA", "A", "Apply font", function ()
	--Add/Remove our surface font flags
	local font_table = {}
	for _, v in pairs(ui_get(font_flags)) do
		table.insert(font_table, STRTOBITMASK[v])
	end
	--Add/Remove our surface font flags
   
	-- Our custom font handle
	local font = surface.create_font(ui_get(textbox), ui_get(size), STRTONUM[ui_get(new_combo)],  bit.bor(table.unpack(font_table) or 0))
	CNetGraphpanel_t.m_font_small = font
	CNetGraphpanel_t.m_font_proportional = font
	CNetGraphpanel_t.m_font_font = font
	-- Our custom font handle

	--Update net_graph fonts
	cvar.net_graph:set_int(0)
	cvar.net_graph:set_int(net_graph_oldval)
	--Update net_graph fonts
end)

callback("post_config_load", function()
	ui_set(textbox, ui_get(new_string))
	ui_set(button, true)
end)
callback("pre_config_save", function()
	ui_set(new_string, ui_get(textbox))
end)