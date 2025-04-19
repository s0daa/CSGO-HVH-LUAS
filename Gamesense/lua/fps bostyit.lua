-- UI Menu for FPS Boost Settings
local fps_boost_tab = "MISC"
local fps_boost_container = "Settings"

local enable_fps_boost = ui.new_checkbox(fps_boost_tab, fps_boost_container, "Enable FPS Boost")
local disable_bloom = ui.new_checkbox(fps_boost_tab, fps_boost_container, "Disable Bloom & HDR")
local disable_shadows = ui.new_checkbox(fps_boost_tab, fps_boost_container, "Disable Shadows")
local disable_fog = ui.new_checkbox(fps_boost_tab, fps_boost_container, "Disable Fog & Particles")
local disable_decals = ui.new_checkbox(fps_boost_tab, fps_boost_container, "Disable Decals & Effects")
local disable_ragdolls = ui.new_checkbox(fps_boost_tab, fps_boost_container, "Disable Ragdolls & Gibs")
local disable_reflections = ui.new_checkbox(fps_boost_tab, fps_boost_container, "Disable Reflections")
local disable_blood = ui.new_checkbox(fps_boost_tab, fps_boost_container, "Disable Blood Effects")
local disable_skybox = ui.new_checkbox(fps_boost_tab, fps_boost_container, "Disable Skybox")
local disable_weather = ui.new_checkbox(fps_boost_tab, fps_boost_container, "Disable Weather Effects")
local optimize_physics = ui.new_checkbox(fps_boost_tab, fps_boost_container, "Optimize Physics")
local show_fps = ui.new_checkbox(fps_boost_tab, fps_boost_container, "Show FPS Counter")


local original_cvars = {}


local function save_original_value(cvar_name)
    if cvar[cvar_name] then
        original_cvars[cvar_name] = cvar[cvar_name]:get_int()
    end
end


local function apply_fps_boost()
    if not ui.get(enable_fps_boost) then return end


    save_original_value("mat_bloomscale")
    save_original_value("mat_disable_bloom")
    save_original_value("mat_hdr_level")
    save_original_value("r_shadows")
    save_original_value("cl_csm_shadows")
    save_original_value("cl_csm_enabled")
    save_original_value("r_dynamic")
    save_original_value("fog_enable")
    save_original_value("fog_override")
    save_original_value("fog_enableskybox")
    save_original_value("r_drawparticles")
    save_original_value("r_drawtracers_firstperson")
    save_original_value("r_drawdecals")
    save_original_value("cl_showfps")
    save_original_value("r_drawmodeldecals")
    save_original_value("r_lod")
    save_original_value("r_drawropes")
    save_original_value("cl_ragdoll_fade_time")
    save_original_value("cl_ragdoll_gravity")
    save_original_value("r_3dsky")
    save_original_value("cl_phys_timescale")
    save_original_value("r_WaterDrawReflection")
    save_original_value("r_WaterDrawRefraction")
    save_original_value("cl_weather_enable")

    if ui.get(disable_bloom) then
        if cvar.mat_bloomscale then cvar.mat_bloomscale:set_float(0) end
        if cvar.mat_disable_bloom then cvar.mat_disable_bloom:set_int(1) end
        if cvar.mat_hdr_level then cvar.mat_hdr_level:set_int(0) end
        client.log("🌟 Bloom & HDR Disabled!")
    end

    if ui.get(disable_shadows) then
        if cvar.r_shadows then cvar.r_shadows:set_int(0) end
        if cvar.cl_csm_shadows then cvar.cl_csm_shadows:set_int(0) end
        if cvar.cl_csm_enabled then cvar.cl_csm_enabled:set_int(0) end
        if cvar.r_dynamic then cvar.r_dynamic:set_int(0) end
        client.log("🛑 Shadows Disabled!")
    end

    if ui.get(disable_fog) then
        if cvar.fog_enable then cvar.fog_enable:set_int(0) end
        if cvar.fog_override then cvar.fog_override:set_int(1) end
        if cvar.fog_enableskybox then cvar.fog_enableskybox:set_int(0) end
        if cvar.r_drawparticles then cvar.r_drawparticles:set_int(0) end
        if cvar.r_drawtracers_firstperson then cvar.r_drawtracers_firstperson:set_int(0) end
        client.log("🌫️ Fog & Particles Disabled!")
    end

    if ui.get(disable_decals) then
        if cvar.r_drawdecals then cvar.r_drawdecals:set_int(0) end
        if cvar.r_drawmodeldecals then cvar.r_drawmodeldecals:set_int(0) end
        client.log("🚫 Decals & Effects Disabled!")
    end

    if ui.get(disable_ragdolls) then
        if cvar.cl_ragdoll_fade_time then cvar.cl_ragdoll_fade_time:set_int(1) end
        if cvar.cl_ragdoll_gravity then cvar.cl_ragdoll_gravity:set_int(0) end
        client.log("🩸 Ragdolls & Gibs Disabled!")
    end

    if ui.get(disable_reflections) then
        if cvar.r_lod then cvar.r_lod:set_int(8) end
        if cvar.r_drawropes then cvar.r_drawropes:set_int(0) end
        if cvar.r_WaterDrawReflection then cvar.r_WaterDrawReflection:set_int(0) end
        if cvar.r_WaterDrawRefraction then cvar.r_WaterDrawRefraction:set_int(0) end
        client.log("🔳 Reflections Disabled!")
    end

    if ui.get(disable_skybox) then
        if cvar.r_3dsky then cvar.r_3dsky:set_int(0) end
        client.log("🌌 Skybox Disabled!")
    end

    if ui.get(disable_weather) then
        if cvar.cl_weather_enable then cvar.cl_weather_enable:set_int(0) end
        client.log("⛈️ Weather Effects Disabled!")
    end

    if ui.get(optimize_physics) then
        if cvar.cl_phys_timescale then cvar.cl_phys_timescale:set_float(0.5) end
        client.log("⚙️ Physics Optimized!")
    end

    if ui.get(show_fps) then
        if cvar.cl_showfps then cvar.cl_showfps:set_int(1) end
        client.log("📊 FPS Counter Enabled!")
    else
        if cvar.cl_showfps then cvar.cl_showfps:set_int(0) end
        client.log("📊 FPS Counter Disabled!")
    end

    client.log("🚀 FPS Boost Settings Applied!")
end


client.set_event_callback("unload", function()
    for cvar_name, value in pairs(original_cvars) do
        if cvar[cvar_name] then
            cvar[cvar_name]:set_int(value)
        end
    end
    client.log("🔄 Original Settings Restored!")
end)


ui.set_callback(enable_fps_boost, apply_fps_boost)
ui.set_callback(disable_bloom, apply_fps_boost)
ui.set_callback(disable_shadows, apply_fps_boost)
ui.set_callback(disable_fog, apply_fps_boost)
ui.set_callback(disable_decals, apply_fps_boost)
ui.set_callback(disable_ragdolls, apply_fps_boost)
ui.set_callback(disable_reflections, apply_fps_boost)
ui.set_callback(disable_skybox, apply_fps_boost)
ui.set_callback(disable_weather, apply_fps_boost)
ui.set_callback(optimize_physics, apply_fps_boost)
ui.set_callback(show_fps, apply_fps_boost)
