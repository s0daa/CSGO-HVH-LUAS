local var = cvars.sv_cheats
local noshadows1 = cvars.r_shadows
local noshadows2 = cvars.cl_csm_static_prop_shadows
local noshadows3 = cvars.cl_csm_shadows
local noshadows4 = cvars.cl_csm_world_shadows
local noshadows5 = cvars.cl_foot_contact_shadows
local noshadows6 = cvars.cl_csm_viewmodel_shadows
local noshadows7 = cvars.cl_csm_rope_shadows
local noshadows8 = cvars.cl_csm_sprite_shadows
local r_dynamic = cvars.r_dynamic
local cl_help = cvars.cl_showhelp
local cl_autohelp = cvars.cl_autohelp
--local draw_particles = cvar:find_var( "r_drawparticles");
local r_eye = cvars.r_eyesize
local r_eyez = cvars.r_eyeshift_z
local r_eyey = cvars.r_eyeshift_y
local r_eyex = cvars.r_eyeshift_x
local r_eyemove = cvars.r_eyemove
local r_eyegloss = cvars.r_eyegloss
local drawtracers = cvars.r_drawtracers_firstperson
local drawtracersgen = cvars.r_drawtracers
local water_fog = cvars.fog_enable_water_fog
local ppros = cvars.mat_postprocess_enable
local freezecam = cvars.cl_disablefreezecam
local freezepos = cvars.cl_freezecampanel_position_dynamic
local drawdecals = cvars.r_drawdecals
local muzzleflash = cvars.muzzleflash_light
local drawrope = cvars.r_drawropes
local drawspirtes = cvars.r_drawsprites
local disablehtml = cvars.cl_disablehtmlmotd
local freezecameffects = cvars.cl_freezecameffects_showholiday
local gameinstructor = cvars.gameinstructor_enable
local matqueue = cvars.mat_queue_mode
local fpsmax = cvars.fps_max
local fpsmaxmenu = cvars.fps_max_menu
local rawimput = cvars.m_rawinput
local bob1 = cvars.cl_bob_lower_amt
local detail = cvars.cl_detail_multiplier
local drawWater = cvars.mat_drawwater
--local matres = cvar:find_var ( "mat_showlowresimage");  

if var:get_int( ) == 0 then
    var:set_int( 1 )
end

local function on_paint()
    if(not engine.is_in_game()) then
        return
    else
	    drawWater:set_int(0)
	    detail:set_int(0)
	    bob1:set_int(0)
	    rawimput:set_int(1)
	    fpsmax:set_int(0)
		fpsmaxmenu:set_int(0)
        noshadows1:set_int(0)
        noshadows2:set_int(0)
        noshadows3:set_int(0)
        noshadows4:set_int(0)
        noshadows5:set_int(0)
        noshadows6:set_int(0)
        noshadows7:set_int(0)
        noshadows8:set_int(0)
		r_dynamic:set_int(0)
		cl_help:set_int(0)
		cl_autohelp:set_int(0)
		--draw_particles:set_int(0)
		r_eye:set_int(0)
		r_eyez:set_int(0)
		r_eyey:set_int(0)
		r_eyex:set_int(0)
		r_eyemove:set_int(0)
		r_eyegloss:set_int(0)
		drawtracers:set_int(0)
		drawrope:set_int(0)
		drawtracersgen:set_int(0)
		drawspirtes:set_int(0)
		water_fog:set_int(0)
		ppros:set_int(0)
		freezecam:set_int(0)
		freezepos:set_int(0)
		drawdecals:set_int(0)
		muzzleflash:set_int(0)
		disablehtml:set_int(0)
		freezecameffects:set_int(0)
		gameinstructor:set_int(0)
		matqueue:set_int(-1)
	--  matres:set_int(1) 
    end
end
callbacks.add(e_callbacks.PAINT, on_paint)