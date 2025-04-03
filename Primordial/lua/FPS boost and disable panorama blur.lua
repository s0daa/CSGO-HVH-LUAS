--By Remine :)
--Makes ur FPS higher maybe also u can disable the panorama blur
local fps_tog = menu.add_checkbox("Fps Boooooost", "Improve some FPS", false)
local disable_blur = menu.add_checkbox("Fps Boooooost", "Disable panorama blur", false)
local cvar1 = cvars.cl_showerror
local cvar4 = cvars.r_shadows
local cvar5 = cvars.cl_csm_static_prop_shadows
local cvar6 = cvars.r_3dsky
local cvar7 = cvars.cl_csm_shadows
local cvar8 = cvars.cl_csm_world_shadows
local cvar9 = cvars.cl_foot_contact_shadows
local cvar10 = cvars.cl_csm_viewmodel_shadows
local cvar11 = cvars.cl_csm_rope_shadows
local cvar12 = cvars.cl_csm_sprite_shadows
local cvar14 = cvars.r_drawropes
local cvar15 = cvars.r_drawsprites
local cvar16 = cvars.fog_enable_water_fog
local cvar17 = cvars.func_break_max_pieces
local cvar18 = cvars.r_dynamic
local cvar19 = cvars.r_dynamiclighting
local cvar20 = cvars.cl_disable_ragdolls
local cvar21 = cvars.dsp_slow_cpu
local cvar22 = cvars.r_eyegloss
local cvar23 = cvars.r_eyemove

local function fix()
    if fps_tog:get() then
    cvar1:set_int(0)
    cvar4:set_int(0)
    cvar5:set_int(0)
    cvar6:set_int(0)
    cvar7:set_int(0)
    cvar8:set_int(0)
    cvar9:set_int(0)
    cvar10:set_int(0)
    cvar11:set_int(0)
    cvar12:set_int(0)
    cvar14:set_int(0)
    cvar15:set_int(0)
    cvar16:set_int(0)
    cvar17:set_int(0)
    cvar18:set_int(0)
    cvar19:set_int(0)
    cvar20:set_int(1)
    cvar21:set_int(1)
    cvar22:set_int(0)
    cvar23:set_int(0)
end
    if disable_blur:get() then
        engine.execute_cmd("@panorama_disable_blur 1")
    else
        engine.execute_cmd("@panorama_disable_blur 0")
    end

end

local function on_shutdown()
    engine.execute_cmd("@panorama_disable_blur 0")
end
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.PAINT, fix)