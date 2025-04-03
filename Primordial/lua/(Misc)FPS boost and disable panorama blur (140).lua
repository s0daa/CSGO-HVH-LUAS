--By Remine :)
--Makes ur FPS higher maybe
cvar4 = cvars.r_shadows
cvar5 = cvars.cl_csm_static_prop_shadows
cvar6 = cvars.r_3dsky
cvar7 = cvars.cl_csm_shadows
cvar8 = cvars.cl_csm_world_shadows
cvar9 = cvars.cl_foot_contact_shadows
cvar10 = cvars.cl_csm_viewmodel_shadows
cvar11 = cvars.cl_csm_rope_shadows
cvar12 = cvars.cl_csm_sprite_shadows
cvar14 = cvars.r_drawropes
cvar15 = cvars.r_drawsprites
cvar17 = cvars.func_break_max_pieces
cvar18 = cvars.r_dynamic
cvar19 = cvars.r_dynamiclighting
cvar24 = cvars.mat_queue_mode
local function fps_call()
local local_player = entity_list:get_local_player()
if not local_player then return end
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
cvar17:set_int(0)
cvar18:set_int(0)
cvar19:set_int(0)
cvar24:set_int(2)      
end
local function fps_back()
local local_player = entity_list:get_local_player()
if not local_player then return end
cvar4:set_int(1)
cvar5:set_int(1)
cvar6:set_int(1)
cvar7:set_int(1)
cvar8:set_int(1)
cvar9:set_int(1)
cvar10:set_int(1)
cvar11:set_int(1)
cvar12:set_int(1)
cvar14:set_int(1)
cvar15:set_int(1)
cvar17:set_int(1)
cvar18:set_int(1)
cvar19:set_int(1)
end
local buttonfps = menu.add_button("FPS BOOST", "BOOST BUTTON", fps_call)
local buttonfps1 = menu.add_button("FPS BOOST", "DISABLE BUTTON", fps_back)

callbacks.add(e_callbacks.SHUTDOWN, function ()
    cvar4:set_int(1)
    cvar5:set_int(1)
    cvar6:set_int(1)
    cvar7:set_int(1)
    cvar8:set_int(1)
    cvar9:set_int(1)
    cvar10:set_int(1)
    cvar11:set_int(1)
    cvar12:set_int(1)
    cvar14:set_int(1)
    cvar15:set_int(1)
    cvar17:set_int(1)
    cvar18:set_int(1)
    cvar19:set_int(1)
end)