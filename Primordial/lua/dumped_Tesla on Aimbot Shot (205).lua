----------------------------------------tables----------------------------------------

local SetCatimes_script_var = {
    --info
    info                    = {
        lua_name            = "Tesla on hit",
        coder               = "SetCatimes"
    },

    --menu var
    menu                    = {

    },

    --functions
    functions               = {

    },

    --ffi
    ffi                     = require("ffi"),

    ffi_vars                = {
        match               = memory.find_pattern("client.dll", "55 8B EC 81 EC ? ? ? ? 56 57 8B F9 8B 47 18"),
    },

    ffi_functions           = {

    },

}

---------------------------------------ffi cdef---------------------------------------

SetCatimes_script_var.ffi.cdef[[
    typedef struct { 
        float x,y,z; 
    } vec3_t; 
    
    struct tesla_info_t { 
        vec3_t m_pos; 
        vec3_t m_ang;
        int m_entindex;
        const char *m_spritename;
        float m_flbeamwidth;
        int m_nbeams;
        vec3_t m_color;
        float m_fltimevis;
        float m_flradius;
    }; 
    
    typedef void(__thiscall* FX_TeslaFn)(struct tesla_info_t&); 
    typedef int(__fastcall* clantag_t)(const char*, const char*);
]]

SetCatimes_script_var.ffi_functions.fs_tesla = ffi.cast("FX_TeslaFn", SetCatimes_script_var.ffi_vars.match)

-----------------------------------------menu-----------------------------------------

SetCatimes_script_var.menu = {
    menu.add_checkbox(SetCatimes_script_var.info.lua_name, "Tesla on hit Enable", false),
    menu.add_slider(SetCatimes_script_var.info.lua_name, "Tesla width", 0, 30),
    menu.add_slider(SetCatimes_script_var.info.lua_name, "Tesla radius", 0, 1000),
    menu.add_slider(SetCatimes_script_var.info.lua_name, "Tesla Beams", 0, 100),
	menu.add_slider(SetCatimes_script_var.info.lua_name, "Tesla Show times(ms)", 0, 3),
}

SetCatimes_script_var.menu.tesla_color = SetCatimes_script_var.menu[1]:add_color_picker("tesla_color")

---------------------------------------function---------------------------------------

SetCatimes_script_var.functions.tesla = function(shot)
    local x,y,z = 0,0,0
    local tesla_info = SetCatimes_script_var.ffi.new("struct tesla_info_t")
    local color = SetCatimes_script_var.menu.tesla_color

    tesla_info.m_flbeamwidth = SetCatimes_script_var.menu[2]:get()
    tesla_info.m_flradius = SetCatimes_script_var.menu[3]:get()
    tesla_info.m_entindex = engine.get_local_player_index()
    tesla_info.m_color = {color:get().r/255, color:get().g/255, color:get().b/255}
    tesla_info.m_pos = { shot.hitpoint_pos.x+10, shot.hitpoint_pos.y, shot.hitpoint_pos.z+10 }
    tesla_info.m_fltimevis = SetCatimes_script_var.menu[5]:get()
    tesla_info.m_nbeams = SetCatimes_script_var.menu[4]:get()
    tesla_info.m_spritename = true and "sprites/physbeam.vmt" or "sprites/purplelaser1.vmt"
    SetCatimes_script_var.ffi_functions.fs_tesla(tesla_info)
end

---------------------------------------callback---------------------------------------

callbacks.add(e_callbacks.AIMBOT_SHOOT, SetCatimes_script_var.functions.tesla)

--------------------------------------The-End-T---------------------------------------