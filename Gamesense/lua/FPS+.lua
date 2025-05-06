local ui_fps_mode = ui.new_combobox("Visuals", "Effects", "FPS+ Mode", {"Off", "Optimal", "Extreme", "Devil"})

local first_boost = true
local current_mode = "Off"
local has_applied_settings = false
local last_map = nil

local ffi = require("ffi")
ffi.cdef([[
    typedef struct c_con_command_base {
        void *vtable; void *next; bool registered; const char *name; const char *help_string; int flags; void *s_cmd_base; void *accessor;
    } c_con_command_base;
]])
local success, err = pcall(function()
    local v_engine_cvar = client.create_interface("vstdlib.dll", "VEngineCvar007")
    local con_command_base = ffi.cast("c_con_command_base ***", ffi.cast("uint32_t", v_engine_cvar) + 0x34)[0][0]
    local hidden_cvars = {}
    local cmd = ffi.cast("c_con_command_base *", con_command_base.next)
    while ffi.cast("uint32_t", cmd) ~= 0 do
        if bit.band(cmd.flags, 18) then table.insert(hidden_cvars, cmd) end
        cmd = ffi.cast("c_con_command_base *", cmd.next)
    end
    function unlock_cvars(enable)
        for i = 1, #hidden_cvars do
            hidden_cvars[i].flags = enable and bit.band(hidden_cvars[i].flags, -19) or bit.bor(hidden_cvars[i].flags, 18)
        end
    end
    unlock_cvars(true)
end)
if not success then print("FFI Error: " .. err) end

local default_cvars = {
    mat_postprocess_enable = 1, mat_vignette_enable = 1, mat_bloom_scalefactor_scalar = 1,
    cl_csm_shadows = 1, violence_ablood = 1, violence_hblood = 1, r_drawparticles = 1,
    r_drawdecals = 1, r_lod = 1, mat_hdr_level = 1, mat_specular = 1, mat_bumpmap = 1,
    mat_phong = 1, r_shadows = 1, mat_antialias = 1, mat_forceaniso = 1, r_3dsky = 1,
    mat_showlowresimage = 0, mat_fullbright = 0, r_drawviewmodel = 1, cl_drawhud = 1,
    fog_override = 0, r_dynamic = 1, r_particle_lod = 1, mat_fog_enable = 1, r_drawentities = 1,
    mat_drawflat = 0, mat_wireframe = 0, r_drawbrushmodels = 1, r_drawstaticprops = 1,
    cl_detaildist = 150, r_drawskybox = 1, r_eyeglint = 1, r_waterforcenofog = 0,
    r_waterforcereflectentities = 1, r_waterdrawdecals = 1, r_waterforceexpensive = 1,
    cl_csm_static_prop_shadows = 1, r_drawothermodels = 1, cl_ragdoll_fade_time = 15,
    cl_phys_props_enable = 1, r_drawtracers = 1, r_drawtracers_firstperson = 1,
    mat_queue_mode = -1, r_drawmodeldecals = 1, cl_showfps = 0
}

local boost_cvars = {
    mat_postprocess_enable = 0, mat_vignette_enable = 0, mat_bloom_scalefactor_scalar = 0,
    cl_csm_shadows = 0, violence_ablood = 0, violence_hblood = 1, r_drawparticles = 1,
    r_drawdecals = 0, r_lod = 2, mat_hdr_level = 0, mat_specular = 0, mat_bumpmap = 0,
    mat_phong = 0, r_shadows = 0, mat_antialias = 0, mat_forceaniso = 0, r_3dsky = 0,
    mat_showlowresimage = 1, fps_max = 0, fog_override = 1, r_dynamic = 0, r_particle_lod = 3,
    mat_fog_enable = 0, cl_detaildist = 0, r_eyeglint = 0, r_waterforcenofog = 1,
    r_waterforcereflectentities = 0, r_waterdrawdecals = 0, r_waterforceexpensive = 0,
    cl_ragdoll_fade_time = 0, cl_phys_props_enable = 0, r_drawtracers = 0,
    r_drawtracers_firstperson = 0, r_drawmodeldecals = 0
}

local extreme_cvars = {
    mat_postprocess_enable = 0, mat_vignette_enable = 0, mat_bloom_scalefactor_scalar = 0,
    cl_csm_shadows = 0, violence_ablood = 0, violence_hblood = 0, r_drawparticles = 0,
    r_drawdecals = 0, r_lod = 2, mat_hdr_level = 0, mat_specular = 0, mat_bumpmap = 0,
    mat_phong = 0, r_shadows = 0, mat_antialias = 0, mat_forceaniso = 0, r_3dsky = 0,
    mat_showlowresimage = 1, fps_max = 0, fog_override = 1, r_dynamic = 0, r_particle_lod = 2,
    mat_fullbright = 1, r_drawviewmodel = 1, r_drawentities = 1, r_drawstaticprops = 1,
    r_drawmodeldecals = 0, r_cheapwaterend = 1, cl_phys_timescale = 0,
    r_dynamiclighting = 0, mat_disable_fancy_blending = 1, r_drawdetailprops = 0
}

local devil_cvars = {
    mat_postprocess_enable = 0, mat_vignette_enable = 0, mat_bloom_scalefactor_scalar = 0,
    cl_csm_shadows = 0, violence_ablood = 0, violence_hblood = 0, r_drawparticles = 0,
    r_drawdecals = 0, r_lod = 2, mat_hdr_level = 0, mat_specular = 0, mat_bumpmap = 0,
    mat_phong = 0, r_shadows = 0, mat_antialias = 0, mat_forceaniso = 0, r_3dsky = 0,
    mat_showlowresimage = 1, fps_max = 0, fog_override = 1, r_dynamic = 0, r_particle_lod = 2,
    mat_fullbright = 1, r_drawviewmodel = 0, cl_drawhud = 0, r_drawentities = 0,
    mat_fog_enable = 0, mat_drawflat = 1, mat_wireframe = 0, cl_csm_static_prop_shadows = 0,
    r_drawbrushmodels = 0, r_drawstaticprops = 0, cl_detaildist = 0, r_drawskybox = 0,
    r_eyeglint = 0, r_waterforcenofog = 1, r_waterforcereflectentities = 0,
    r_waterdrawdecals = 0, r_waterforceexpensive = 0, r_drawothermodels = 0,
    cl_ragdoll_fade_time = 0, cl_phys_props_enable = 0, r_drawtracers = 0,
    r_drawtracers_firstperson = 0, mat_queue_mode = -1, r_drawmodeldecals = 0,
    r_cheapwaterend = 1, cl_phys_timescale = 0, r_dynamiclighting = 0,
    mat_disable_fancy_blending = 1, r_drawdetailprops = 0, r_decalstaticprops = 0,
    mat_fastnobump = 1
}

local function safe_set_cvar(name, value)
    if cvar[name] then cvar[name]:set_int(value) end
end

local function apply_boost()
    local mode = ui.get(ui_fps_mode)
    if mode == current_mode then return end

    for k, v in pairs(default_cvars) do
        safe_set_cvar(k, v)
    end

    if mode == "Off" then
        first_boost = true
        current_mode = mode
        return
    end

    local cvars_to_apply = mode == "Optimal" and boost_cvars or mode == "Extreme" and extreme_cvars or mode == "Devil" and devil_cvars
    for k, v in pairs(cvars_to_apply) do
        safe_set_cvar(k, v)
    end

    if first_boost then
        client.exec("mat_reloadallmaterials")
        first_boost = false
    end
    current_mode = mode
end

local function reapply_mode()
    local mode = ui.get(ui_fps_mode)
    if mode == "Off" then return end
    local cvars_to_apply = mode == "Optimal" and boost_cvars or mode == "Extreme" and extreme_cvars or mode == "Devil" and devil_cvars
    for k, v in pairs(cvars_to_apply) do
        safe_set_cvar(k, v)
    end
end

local function reset_to_default()
    for k, v in pairs(default_cvars) do
        safe_set_cvar(k, v)
    end
end

client.set_event_callback("client_disconnect", function()
    reset_to_default()
    has_applied_settings = false
end)

client.set_event_callback("game_over", function()
    reset_to_default()
    has_applied_settings = false
end)

client.set_event_callback("paint", function()
    local current_map = globals.mapname()
    if last_map and not current_map then
        reset_to_default()
        has_applied_settings = false
    end
    last_map = current_map

    if has_applied_settings then return end
    local local_player = entity.get_local_player()
    if not local_player or not current_map then return end

    client.delay_call(3, function()
        if not entity.get_local_player() or not globals.mapname() then return end
        reapply_mode()
        has_applied_settings = true
    end)
end)

client.set_event_callback("paint", function()
    if ui.get(ui_fps_mode) ~= "Off" and globals.tickcount() % 120 == 0 then
        client.exec("r_cleardecals")
    end
end)

client.set_event_callback("player_connect_full", function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        has_applied_settings = false
    end
end)

ui.set_callback(ui_fps_mode, apply_boost)
client.set_event_callback("shutdown", function() if success then unlock_cvars(false) end end)

apply_boost()