print("Hello", user.name)
print("Lua loaded succsesfully")
print("Good luck with Compact.lua")

local text0 = menu.add_text("Welcome", "Thanks for using my pasted lua!")
local text1 = menu.add_text("Welcome", "Made by hersty, uid 2956 on forum")
local text2 = menu.add_text("Welcome", "Last update: 31/07/2022")
local text3 = menu.add_text("Welcome", "If u have ideas for script - join to my ds server")


--Compact.lua watermark disabler
local custom_watermark_disabler_active = menu.add_checkbox("Visual functions", "Custom watermark disable")

--Custom scope
local custom_scope_active = menu.add_checkbox("Visual functions", "Custom scope")
local scope_color = custom_scope_active:add_color_picker("Color")
local scope_scale = menu.add_slider("Visual functions", "Scale", 0, 150)
local scope_gap = menu.add_slider("Visual functions", "Gap", -150, 150)

--Transparency on nade
local transparency_on_nade_active = menu.add_checkbox("Visual functions", "Transparency on nade")
local transparency_on_nade_color = transparency_on_nade_active:add_color_picker("Transparency amount")
local text4 = menu.add_text("Visual functions", "Change alpha if u want custom transparency value")

--Custom logs
local logs_active = menu.add_checkbox("Visual functions", "Chat hit logs")

--Custom particles of molly
local custom_molly_particles_active = menu.add_checkbox("Visual functions", "Wireframe molly particles")

--Custom particles with zeus shoot
local party_mode_acitve = menu.add_checkbox("Visual functions", "Party mode(zeus x27)")

--Custom ragdolls
local custom_ragdolls_active = menu.add_checkbox("Visual functions", "Custom ragdoll physics")
local custom_ragdoll_gravity_selection = menu.add_selection("Visual functions", "Select", {"-", "Stay", "Levitation", "Astronaut"})

--Custom indicators
local custom_indicators_active = menu.add_checkbox("Visual functions", "Custom indicators")
local custom_indicators_selection = menu.add_multi_selection("Visual functions", "Select", {"Double tap", "Duck peek assistance", "Force baim", "Damage override", "On-Shot AA", "Auto peek" }) 

--Hands in scope
local hands_in_scope_active = menu.add_checkbox("Visual functions", "Hands in scope")

--Custom animations
local custom_animations_active = menu.add_checkbox("Visual functions", "Custom local animations")
local custom_animations_selection = menu.add_multi_selection("Visual functions", "Select", { "Dynamic model", "Static legs in run", "Static legs when slow motion", "Static legs in air" })

--Anti-Untrusted
local anti_untrusted_active = menu.add_checkbox("Ragebot assistance", "Anti-untrusted")
local text5 = menu.add_text("Ragebot assistance", "Only for valve servers, like MM or Wingman")

--Double tap speed changer
local custom_doubletap_speed_active = menu.add_checkbox("Ragebot assistance", "Double tap speed changer")

--Better autostop conditions
local better_autostop_active = menu.add_checkbox("Ragebot assistance", "Perfect autostop conditions")

--Better damage conditions
--local better_damage_accuracy_active = menu.add_checkbox("Ragebot assistance", "Better damage accuracy")

--Better strafe assistance
--local slider_value = menu.add_slider("Ragebot assistance", "Strafe smoothing", 0, 500)

scope_color:set(color_t(0, 0, 0))
scope_scale:set(1920)
scope_gap:set(-1920)

local strafer_smoothing = menu.find("misc", "main", "movement", "strafe smoothing")

local function handle_menu(reset)
    if reset == false then
        scope_color:set_visible(false)
        scope_scale:set_visible(false)
        scope_gap:set_visible(false)
        custom_ragdoll_gravity_selection:set_visible(false)
        custom_indicators_selection:set_visible(false)
        custom_animations_selection:set_visible(false)
        transparency_on_nade_color:set_visible(false)
        text4:set_visible(false)
        text5:set_visible(false)
        strafer_smoothing:set(25)

            if custom_scope_active:get() then

                scope_color:set_visible(true)
                scope_scale:set_visible(true)
                scope_gap:set_visible(true)

            end

            if custom_ragdolls_active:get() then

                custom_ragdoll_gravity_selection:set_visible(true)

            end

            if custom_indicators_active:get() then

                custom_indicators_selection:set_visible(true)

            end

            if custom_animations_active:get() then

                custom_animations_selection:set_visible(true)

            end

            if anti_untrusted_active:get() then

                custom_doubletap_speed_active:set_visible(false)
                custom_doubletap_speed_active:set(false)
                text5:set_visible(true)
                strafer_smoothing:set(53)

            else

                custom_doubletap_speed_active:set_visible(true)

            end

            if transparency_on_nade_active:get() then

                transparency_on_nade_color:set_visible(true)
                text4:set_visible(true)

        end
    end
end

local function menu_visibility()
    
    handle_menu(false)

end

callbacks.add(e_callbacks.PAINT, menu_visibility)

local autopeek_active = menu.find("aimbot", "general", "misc", "autopeek")[2]
local auto_as_c = menu.find("aimbot", "auto", "accuracy", "autostop options")
local scout_as_c = menu.find("aimbot", "scout", "accuracy", "autostop options")
local awp_as_c = menu.find("aimbot", "awp", "accuracy", "autostop options")
local deagle_as_c = menu.find("aimbot", "deagle", "accuracy", "autostop options")
local revolver_as_c = menu.find("aimbot", "revolver", "accuracy", "autostop options")
local pistols_as_c = menu.find("aimbot", "pistols", "accuracy", "autostop options")
local other_as_c = menu.find("aimbot", "other", "accuracy", "autostop options")

local function better_autostop_conditions(cmd)
	if better_autostop_active:get() and not anti_untrusted_active:get() then
        
        if autopeek_active:get() then auto_as_c[4]:set(1, false) else auto_as_c[4]:set(1, false) end
            if autopeek_active:get() then auto_as_c[4]:set(2, false) else auto_as_c[4]:set(2, true) end
                if autopeek_active:get() then auto_as_c[4]:set(3, true) else auto_as_c[4]:set(3, false) end
                    if autopeek_active:get() then auto_as_c[4]:set(4, false) else auto_as_c[4]:set(4, false) end
	                    if autopeek_active:get() then auto_as_c[4]:set(5, false) else auto_as_c[4]:set(5, true) end
                            if autopeek_active:get() then auto_as_c[4]:set(6, false) else auto_as_c[4]:set(6, false) end

        if autopeek_active:get() then scout_as_c[4]:set(1, false) else scout_as_c[4]:set(1, false) end
            if autopeek_active:get() then scout_as_c[4]:set(2, false) else scout_as_c[4]:set(2, false) end
	            if autopeek_active:get() then scout_as_c[4]:set(3, true) else scout_as_c[4]:set(3, false) end
                    if autopeek_active:get() then scout_as_c[4]:set(4, false) else scout_as_c[4]:set(4, false) end
	                    if autopeek_active:get() then scout_as_c[4]:set(5, false) else scout_as_c[4]:set(5, true) end
                            if autopeek_active:get() then scout_as_c[4]:set(6, false) else scout_as_c[4]:set(6, false) end

	    if autopeek_active:get() then awp_as_c[4]:set(1, false) else awp_as_c[4]:set(1, false) end
            if autopeek_active:get() then awp_as_c[4]:set(2, false) else awp_as_c[4]:set(2, false) end
                if autopeek_active:get() then awp_as_c[4]:set(3, true) else awp_as_c[4]:set(3, false) end
                    if autopeek_active:get() then awp_as_c[4]:set(4, false) else awp_as_c[4]:set(4, false) end
	                    if autopeek_active:get() then awp_as_c[4]:set(5, false) else awp_as_c[4]:set(5, true) end
                            if autopeek_active:get() then awp_as_c[4]:set(6, false) else awp_as_c[4]:set(6, false) end

        if autopeek_active:get() then deagle_as_c[4]:set(1, false) else deagle_as_c[4]:set(1, false) end
            if autopeek_active:get() then deagle_as_c[4]:set(2, false) else deagle_as_c[4]:set(2, true) end
	            if autopeek_active:get() then deagle_as_c[4]:set(3, true) else deagle_as_c[4]:set(3, false) end
                    if autopeek_active:get() then deagle_as_c[4]:set(4, false) else deagle_as_c[4]:set(4, false) end
	                    if autopeek_active:get() then deagle_as_c[4]:set(5, false) else deagle_as_c[4]:set(5, true) end
                            if autopeek_active:get() then deagle_as_c[4]:set(6, false) else deagle_as_c[4]:set(6, false) end

        if autopeek_active:get() then revolver_as_c[4]:set(1, false) else revolver_as_c[4]:set(1, false) end
            if autopeek_active:get() then revolver_as_c[4]:set(2, false) else revolver_as_c[4]:set(2, false) end
	            if autopeek_active:get() then revolver_as_c[4]:set(3, true) else revolver_as_c[4]:set(3, false) end
                    if autopeek_active:get() then revolver_as_c[4]:set(4, false) else revolver_as_c[4]:set(4, false) end
	                    if autopeek_active:get() then revolver_as_c[4]:set(5, false) else revolver_as_c[4]:set(5, true) end
                            if autopeek_active:get() then revolver_as_c[4]:set(6, false) else revolver_as_c[4]:set(6, false) end

        if autopeek_active:get() then pistols_as_c[4]:set(1, false) else pistols_as_c[4]:set(1, false) end
            if autopeek_active:get() then pistols_as_c[4]:set(2, false) else pistols_as_c[4]:set(2, true) end
	            if autopeek_active:get() then pistols_as_c[4]:set(3, true) else pistols_as_c[4]:set(3, false) end
                    if autopeek_active:get() then pistols_as_c[4]:set(4, false) else pistols_as_c[4]:set(4, false) end
	                    if autopeek_active:get() then pistols_as_c[4]:set(5, false) else pistols_as_c[4]:set(5, true) end
                            if autopeek_active:get() then pistols_as_c[4]:set(6, false) else pistols_as_c[4]:set(6, false) end

        if autopeek_active:get() then other_as_c[4]:set(1, false) else other_as_c[4]:set(1, false) end
            if autopeek_active:get() then other_as_c[4]:set(2, false) else other_as_c[4]:set(2, true) end
                if autopeek_active:get() then other_as_c[4]:set(3, true) else other_as_c[4]:set(3, false) end
                    if autopeek_active:get() then other_as_c[4]:set(4, false) else other_as_c[4]:set(4, false) end
                        if autopeek_active:get() then other_as_c[4]:set(5, false) else other_as_c[4]:set(5, true) end
                            if autopeek_active:get() then other_as_c[4]:set(6, false) else other_as_c[4]:set(6, false) end

    else

        if autopeek_active:get() then auto_as_c[4]:set(1, false) else auto_as_c[4]:set(1, false) end
            if autopeek_active:get() then auto_as_c[4]:set(2, false) else auto_as_c[4]:set(2, true) end
                if autopeek_active:get() then auto_as_c[4]:set(3, true) else auto_as_c[4]:set(3, false) end
                    if autopeek_active:get() then auto_as_c[4]:set(4, false) else auto_as_c[4]:set(4, false) end
                        if autopeek_active:get() then auto_as_c[4]:set(5, false) else auto_as_c[4]:set(5, false) end
                            if autopeek_active:get() then auto_as_c[4]:set(6, false) else auto_as_c[4]:set(6, false) end

        if autopeek_active:get() then scout_as_c[4]:set(1, false) else scout_as_c[4]:set(1, false) end
            if autopeek_active:get() then scout_as_c[4]:set(2, false) else scout_as_c[4]:set(2, false) end
                if autopeek_active:get() then scout_as_c[4]:set(3, true) else scout_as_c[4]:set(3, false) end
                    if autopeek_active:get() then scout_as_c[4]:set(4, false) else scout_as_c[4]:set(4, false) end
                        if autopeek_active:get() then scout_as_c[4]:set(5, false) else scout_as_c[4]:set(5, false) end
                            if autopeek_active:get() then scout_as_c[4]:set(6, false) else scout_as_c[4]:set(6, false) end
                
        if autopeek_active:get() then awp_as_c[4]:set(1, false) else awp_as_c[4]:set(1, false) end
            if autopeek_active:get() then awp_as_c[4]:set(2, false) else awp_as_c[4]:set(2, false) end
                if autopeek_active:get() then awp_as_c[4]:set(3, true) else awp_as_c[4]:set(3, false) end
                    if autopeek_active:get() then awp_as_c[4]:set(4, false) else awp_as_c[4]:set(4, false) end
                        if autopeek_active:get() then awp_as_c[4]:set(5, false) else awp_as_c[4]:set(5, false) end
                            if autopeek_active:get() then awp_as_c[4]:set(6, false) else awp_as_c[4]:set(6, false) end
                
        if autopeek_active:get() then deagle_as_c[4]:set(1, false) else deagle_as_c[4]:set(1, false) end
            if autopeek_active:get() then deagle_as_c[4]:set(2, false) else deagle_as_c[4]:set(2, true) end
                if autopeek_active:get() then deagle_as_c[4]:set(3, true) else deagle_as_c[4]:set(3, false) end
                    if autopeek_active:get() then deagle_as_c[4]:set(4, false) else deagle_as_c[4]:set(4, false) end
                        if autopeek_active:get() then deagle_as_c[4]:set(5, false) else deagle_as_c[4]:set(5, false) end
                           if autopeek_active:get() then deagle_as_c[4]:set(6, false) else deagle_as_c[4]:set(6, false) end
                
        if autopeek_active:get() then revolver_as_c[4]:set(1, false) else revolver_as_c[4]:set(1, false) end
            if autopeek_active:get() then revolver_as_c[4]:set(2, false) else revolver_as_c[4]:set(2, false) end
                if autopeek_active:get() then revolver_as_c[4]:set(3, true) else revolver_as_c[4]:set(3, false) end
                    if autopeek_active:get() then revolver_as_c[4]:set(4, false) else revolver_as_c[4]:set(4, false) end
                        if autopeek_active:get() then revolver_as_c[4]:set(5, false) else revolver_as_c[4]:set(5, false) end
                            if autopeek_active:get() then revolver_as_c[4]:set(6, false) else revolver_as_c[4]:set(6, false) end
                
        if autopeek_active:get() then pistols_as_c[4]:set(1, false) else pistols_as_c[4]:set(1, false) end
            if autopeek_active:get() then pistols_as_c[4]:set(2, false) else pistols_as_c[4]:set(2, true) end
                if autopeek_active:get() then pistols_as_c[4]:set(3, true) else pistols_as_c[4]:set(3, false) end
                    if autopeek_active:get() then pistols_as_c[4]:set(4, false) else pistols_as_c[4]:set(4, false) end
                        if autopeek_active:get() then pistols_as_c[4]:set(5, false) else pistols_as_c[4]:set(5, false) end
                            if autopeek_active:get() then pistols_as_c[4]:set(6, false) else pistols_as_c[4]:set(6, false) end
                
        if autopeek_active:get() then other_as_c[4]:set(1, false) else other_as_c[4]:set(1, false) end
            if autopeek_active:get() then other_as_c[4]:set(2, false) else other_as_c[4]:set(2, true) end
                if autopeek_active:get() then other_as_c[4]:set(3, true) else other_as_c[4]:set(3, false) end
                    if autopeek_active:get() then other_as_c[4]:set(4, false) else other_as_c[4]:set(4, false) end
                        if autopeek_active:get() then other_as_c[4]:set(5, false) else other_as_c[4]:set(5, false) end
                            if autopeek_active:get() then other_as_c[4]:set(6, false) else other_as_c[4]:set(6, false) end

    end
end

local ffi = require("ffi")

ffi.cdef[[
    typedef struct {
        unsigned short wYear;
        unsigned short wMonth;
        unsigned short wDayOfWeek;
        unsigned short wDay;
        unsigned short wHour;
        unsigned short wMinute;
        unsigned short wSecond;
        unsigned short wMilliseconds;
    } SYSTEMTIME, *LPSYSTEMTIME;
    
    void GetSystemTime(LPSYSTEMTIME lpSystemTime);
    void GetLocalTime(LPSYSTEMTIME lpSystemTime);

]]

local FindElement = ffi.cast("unsigned long(__thiscall*)(void*, const char*)", memory.find_pattern("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28"))
local CHudChat = FindElement(ffi.cast("unsigned long**", ffi.cast("uintptr_t", memory.find_pattern("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 8B 5D 08")) + 1)[0], "CHudChat")
local FFI_ChatPrint = ffi.cast("void(__cdecl*)(int, int, int, const char*, ...)", ffi.cast("void***", CHudChat)[0][27])

local function PrintInChat(text)

    FFI_ChatPrint(CHudChat, 0, 0, string.format("%s ", text))

end

local function custom_miss_logs(shot)
    if logs_active:get() then

        PrintInChat("aimbot missed due to " ..shot.reason_string.. "")

    end
end

local function custom_hit_logs(shot)
    if logs_active:get() then

        PrintInChat("aimbot hit "..shot.player:get_name().." for "..shot.damage.." damage")
	    print("aimbot hit "..shot.player:get_name().." for "..shot.damage.." damage")

    end
end

local scope_arc_remover = menu.find("visuals", "other", "removals", "scope arc")
local scope_color_from_cheat = menu.find("visuals", "other", "general", "scope type")[2]

local scope_color_old = menu.find("visuals", "other", "general", "scope type")[2]:get()

local function custom_scope()

    local screen_size = render.get_screen_size()
    local screen_center = vec2_t(screen_size.x / 2, screen_size.y / 2)
    local local_player = entity_list.get_local_player()

    if local_player == nil then return end
    local health = local_player:get_prop("m_iHealth")

    if health == 0 then return end
    local weap = local_player:get_active_weapon()

    if weap == nil then return end
    local is_scoped = weap:get_prop("m_zoomLevel")
    local scoped_prop = local_player:get_prop("m_bIsScoped")
    local in_scope = scoped_prop == 1 and true or false

    if in_scope == nil or not in_scope then return end

    if is_scoped == 0 or is_scoped == nil then return end
    local offset = scope_scale:get()
    
    if custom_scope_active:get() then
        scope_color_from_cheat:set(color_t(scope_color_from_cheat:get().r, scope_color_from_cheat:get().g, scope_color_from_cheat:get().b, 0))
        scope_arc_remover:set(true)
        pos = vec2_t(screen_center.x, screen_center.y - offset)
        size = vec2_t(1, offset)
        pos.y = pos.y - (scope_gap:get() - 1)
        render.rect_fade(pos, size, color_t(0, 0, 0, 0), scope_color:get())
    
        pos = vec2_t(screen_center.x, screen_center.y + (offset * 0 ))
        size = vec2_t(1, offset - ( offset * 0 ))
        pos.y = pos.y + scope_gap:get()
        render.rect_fade(pos, size, scope_color:get(), color_t(0, 0, 0, 0))
    
        pos = vec2_t(screen_center.x - offset, screen_center.y)
        size = vec2_t(offset, 1)
        pos.x = pos.x - (scope_gap:get() - 1)
        render.rect_fade(pos, size, color_t(0, 0, 0, 0), scope_color:get(), true)
    
        pos = vec2_t(screen_center.x + (offset * 0 ), screen_center.y)
        size = vec2_t(offset - ( offset * 0 ), 1)
        pos.x = pos.x + scope_gap:get()
        render.rect_fade(pos, size, scope_color:get(), color_t(0, 0, 0, 0), true)

    else

        scope_color_from_cheat:set(scope_color_old)

    end
end

local ragdolls_remover = menu.find("visuals", "other", "removals", "ragdolls")

local function custom_ragdolls()
    if custom_ragdolls_active:get() then
        ragdolls_remover:set(false)
    else
        ragdolls_remover:set(true)

        if custom_ragdoll_gravity_selection:get() == 2 then
            cvars.cl_ragdoll_physics_enable:set_int(0)

        else

            cvars.cl_ragdoll_physics_enable:set_int(1)

        end

        if custom_ragdoll_gravity_selection:get() == 3 then

            cvars.cl_ragdoll_gravity:set_int(0)

        elseif custom_ragdoll_gravity_selection:get() == 4 then

            cvars.cl_ragdoll_gravity:set_int(-1000)
        
        else

            cvars.cl_ragdoll_gravity:set_int(600)

        end
    end
end

local find_material = materials.find
local materials = {
    "particle/fire_burning_character/fire_env_fire_depthblend_oriented",
    "particle/fire_burning_character/fire_burning_character",
    "particle/fire_explosion_1/fire_explosion_1_oriented",
    "particle/fire_explosion_1/fire_explosion_1_bright",
    "particle/fire_burning_character/fire_burning_character_depthblend",
    "particle/fire_burning_character/fire_env_fire_depthblend",
}
 
local function custom_molly_particles(e)
   
    if e.name == "molotov_detonate" then
        for _, v in pairs(materials) do
            local molotov = find_material(v)
            if molotov ~= nil then
                if custom_molly_particles_active:get() then
                      molotov:set_flag(e_material_flags.NO_DRAW, false)
                     molotov:set_flag(e_material_flags.WIREFRAME, true)
                else
                     molotov:set_flag(e_material_flags.NO_DRAW, false)
                     molotov:set_flag(e_material_flags.WIREFRAME, false)
                 end
            end
        end
    end
end

local function party_mode()
    if party_mode_acitve:get() then
    cvars.sv_party_mode:set_int(1)
else
    cvars.sv_party_mode:set_int(0)
end
end


local calibri = render.create_font("Calibri", 30, 600, e_font_flags.ANTIALIAS)
local main_font = render.create_font("Calibri", 12, 400)
local screen_size = render.get_screen_size()
local ctx = screen_size.x / 2
local cty = screen_size.y / 2
local x = screen_size.x / 2
local y = screen_size.y / 2

local doubletap_active = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local hideshots_active = menu.find("aimbot", "general", "exploits", "hideshots", "enable")
local force_baim_active = menu.find("aimbot", "scout", "target overrides", "force hitbox")
local damage_override_active = menu.find("aimbot", "auto", "target overrides", "force min. damage"), menu.find("aimbot", "scout", "target overrides", "force min. damage"), menu.find("aimbot", "awp", "target overrides", "force min. damage")
local autopeek_active = menu.find("aimbot", "general", "misc", "autopeek")

local enabled = true

local function getweapon()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end

    local weapon_name = nil

    if local_player:get_prop("m_iHealth") > 0 then
    
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end

        weapon_name = active_weapon:get_name()


    else return end

    return weapon_name

end

local function custom_indication()

    if not engine.is_connected() then
        return
      end
      
    if not engine.is_in_game() then
        return
    end
      
    local local_player = entity_list.get_local_player()
      
    if not local_player:get_prop("m_iHealth") then
        return
    end

    local ind_dst = 0
    local ind_spr = 40
    
    if engine.is_connected() then
        if local_player:is_alive() then

            if custom_indicators_active:get() then

                local text = "DT"
                local size = render.get_text_size(calibri, text)
                
                if custom_indicators_selection:get(1) then
                    if doubletap_active[2]:get() then
                        if exploits.get_charge() >= 1 then
                            render.rect_fade(vec2_t(17, cty + 120 + ind_dst - 4), vec2_t(math.floor(size.x), 25), color_t(0, 0, 0, 180), color_t(0, 0, 0, 5),true)
                            render.text(calibri, "DT", vec2_t(16 + 1, cty + 114 + ind_dst + 1), color_t(0, 0, 0, 200))
                            render.text(calibri, "DT", vec2_t(16, cty + 114 + ind_dst), color_t(255,255,255,255))

                            ind_dst = ind_dst + ind_spr
                        end

                        if exploits.get_charge() < 1 then
                            render.rect_fade(vec2_t(17, cty + 120 + ind_dst - 4), vec2_t(math.floor(size.x), 25), color_t(0, 0, 0, 180), color_t(0, 0, 0, 5),true)
                            render.text(calibri, "DT", vec2_t(16 + 1, cty + 114 + ind_dst + 1), color_t(0, 0, 0, 200))
                            render.text(calibri, "DT", vec2_t(16, cty + 114 + ind_dst), color_t(255,0,0,255))

                            ind_dst = ind_dst + ind_spr
                        end
                    end
                end

                local text = "DUCK"
                local size = render.get_text_size(calibri, text)

                if custom_indicators_selection:get(2) then
                    if antiaim.is_fakeducking() then
                        render.rect_fade(vec2_t(17, cty + 120 + ind_dst - 4), vec2_t(math.floor(size.x), 25), color_t(0, 0, 0, 180), color_t(0, 0, 0, 5),true)
                        render.text(calibri, "DUCK", vec2_t(16 + 1, cty + 114 + ind_dst + 1), color_t(0, 0, 0, 200))
                        render.text(calibri, "DUCK", vec2_t(16, cty + 114 + ind_dst), color_t(255, 255, 255, 255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

                local text = "BAIM"
                local size = render.get_text_size(calibri, text)

                if custom_indicators_selection:get(3) then
                    if force_baim_active[2]:get() then
                        render.rect_fade(vec2_t(17, cty + 120 + ind_dst - 4), vec2_t(math.floor(size.x), 25), color_t(0, 0, 0, 180), color_t(0, 0, 0, 5),true)
                        render.text(calibri, "BAIM", vec2_t(16 + 1, cty + 114 + ind_dst + 1), color_t(0, 0, 0, 200))
                        render.text(calibri, "BAIM", vec2_t(16, cty + 114 + ind_dst), color_t(114, 201, 52 ,255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

                local text = "DMG"
                local size = render.get_text_size(calibri, text)

                if custom_indicators_selection:get(4) then
                    if damage_override_active[2]:get() then
                        render.rect_fade(vec2_t(17, cty + 120 + ind_dst - 4), vec2_t(math.floor(size.x), 25), color_t(0, 0, 0, 180), color_t(0, 0, 0, 5),true)
                        render.text(calibri, "DMG", vec2_t(16 + 1, cty + 114 + ind_dst + 1), color_t(0, 0, 0, 200))
                        render.text(calibri, "DMG", vec2_t(16, cty + 114 + ind_dst), color_t(255, 255, 255, 255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

                local text = "ONSHOT"
                local size = render.get_text_size(calibri, text)

                if custom_indicators_selection:get(5) then
                    if hideshots_active[2]:get() then
                        render.rect_fade(vec2_t(17, cty + 120 + ind_dst - 4), vec2_t(math.floor(size.x), 25), color_t(0, 0, 0, 180), color_t(0, 0, 0, 5),true)
                        render.text(calibri, "ONSHOT", vec2_t(16 + 1, cty + 114 + ind_dst + 1), color_t(0, 0, 0, 200))
                        render.text(calibri, "ONSHOT", vec2_t(16, cty + 114 + ind_dst), color_t(114, 201, 52 ,255))

                        ind_dst = ind_dst + ind_spr
                    end
                end

                    local text = "PEEK"
                    local size = render.get_text_size(calibri, text)
                    
                    if custom_indicators_selection:get(6) then
                        if autopeek_active[2]:get() then
                            render.rect_fade(vec2_t(17, cty + 120 + ind_dst - 4), vec2_t(math.floor(size.x), 25), color_t(0, 0, 0, 180), color_t(0, 0, 0, 5),true)
                                render.text(calibri, "PEEK", vec2_t(16 + 1, cty + 114 + ind_dst + 1), color_t(0, 0, 0, 200))
                                render.text(calibri, "PEEK", vec2_t(16, cty + 114 + ind_dst), color_t(255, 255, 255, 255))
    
                                ind_dst = ind_dst + ind_spr
                            end
                        end
                end                
            end
        end
end

local hidden_cvars = menu.find("misc", "utility", "general", "show hidden cvars")

local function hands_in_scope()
    if hands_in_scope_active:get() then
        hidden_cvars:set(true)
        cvars.fov_cs_debug:set_int(90)
    else
        cvars.fov_cs_debug:set_int(0)
    end
end

local find_slow_walk_name, find_slow_walk_key = unpack(menu.find("misc","main","movement","slow walk"))

callbacks.add(e_callbacks.ANTIAIM, function(ctx)
if custom_animations_active:get() then

    local local_player = entity_list.get_local_player()
	local lean_anim = local_player:get_prop("m_vecVelocity[1]") ~= 0	

	if custom_animations_selection:get(2) then
		ctx:set_render_pose(e_poses.RUN, 0, 2)
	end

    if find_slow_walk_key:get() and custom_animations_selection:get(3) then
		ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 0.0, 0.0)
	end

    if custom_animations_selection:get(1) then
        if lean_anim then
            ctx:set_render_animlayer(e_animlayers.LEAN, 1)
        end
    end

    if find_slow_walk_key:get() then
        ctx:set_render_animlayer(e_animlayers.LEAN, 0)
    end

    if custom_animations_selection:get(4) then
        ctx:set_render_pose(e_poses.JUMP_FALL, 1)
    end
end
end)

local font_watermark = render.create_font("Verdana", 13, 0)

local function custom_watermark()
    if not custom_watermark_disabler_active:get() then

    render.rect_filled(vec2_t(screen_size.x / 2 - 958, screen_size.y / 2 - 538), vec2_t(73, 17), color_t(17, 17, 17, 150))
    render.text(font_watermark, "Compact.lua", vec2_t(screen_size.x / 2 - 958, screen_size.y / 2 - 537), color_t(255, 255, 255, 255))

    return ""
    end
end

local function custom_doubletap_speed()
    if custom_doubletap_speed_active:get() then
    local local_player = entity_list.get_local_player()

    if local_player == nil then return end
    local dt_tick = exploits.get_charge()
    local cur_time = global_vars.cur_time()
    local speed = 0.06666
end

    if custom_doubletap_speed_active:get() and doubletap_active[2]:get() then
        cvars.sv_maxusrcmdprocessticks:set_int(17)
        cvars.cl_clock_correction:set_int(0)
        cvars.cl_clock_correction_adjustment_max_amount:set_int(450)
    else
        cvars.sv_maxusrcmdprocessticks:set_int(16)
        cvars.cl_clock_correction:set_int(1)
    end
end

transparency_on_nade_color:set(color_t(255, 255, 255, 150))

local function blend_with_grenade(ctx)
    if transparency_on_nade_active:get() then

    if not ctx.entity:is_valid() then return end
    local local_player = entity_list.get_local_player()

    if local_player == nil then return end
    
    if ctx.entity:get_index() ~= local_player:get_index() then return end
    local weapon = local_player:get_active_weapon()
    
    if weapon == nil then return end
    local class_name = weapon:get_class_name()

    if class_name ~= "CHEGrenade" and 
    class_name ~= "CIncendiaryGrenade" and 
    class_name ~= "CSmokeGrenade" and 
    class_name ~= "CFlashbang" and 
    class_name ~= "CDecoyGrenade" and 
    class_name ~= "CMolotovGrenade" then return end
    
    ctx.override_original = true

    ctx:draw_original(transparency_on_nade_color:get())
end
end

local function anti_untrusted()
    if anti_untrusted_active:get() then
        game_rules.set_prop("m_bIsValveDS",1)
    else
        game_rules.set_prop("m_bIsValveDS",0)
    end
end

local forcesendnextpacket = false

local function fakelag_on_shoot1(shot)
    forcesendnextpacket = true
end

local function fakelag_on_shoot2(ctx)
    if forcesendnextpacket then
    ctx:set_fakelag(false) 
    forcesendnextpacket = false
    end
end

--local function better_damage_accuracy()
--    if better_damage_accuracy_active:get() then
--        
--    end
--end

callbacks.add(e_callbacks.SETUP_COMMAND, better_autostop_conditions)
callbacks.add(e_callbacks.AIMBOT_HIT, custom_hit_logs)
callbacks.add(e_callbacks.AIMBOT_MISS, custom_miss_logs)
callbacks.add(e_callbacks.PAINT, custom_scope)
callbacks.add(e_callbacks.PAINT, custom_ragdolls)
callbacks.add(e_callbacks.EVENT, custom_molly_particles)
callbacks.add(e_callbacks.PAINT, party_mode)
callbacks.add(e_callbacks.PAINT, custom_indication)
callbacks.add(e_callbacks.PAINT, hands_in_scope)
callbacks.add(e_callbacks.DRAW_WATERMARK, custom_watermark)
callbacks.add(e_callbacks.PAINT, custom_doubletap_speed)
callbacks.add(e_callbacks.DRAW_MODEL, blend_with_grenade)
callbacks.add(e_callbacks.PAINT, anti_untrusted)
callbacks.add(e_callbacks.AIMBOT_SHOOT, fakelag_on_shoot1)
callbacks.add(e_callbacks.ANTIAIM, fakelag_on_shoot2)
--callbacks.add(e_callbacks.SETUP_COMMAND, better_damage_accuracy)
callbacks.add(e_callbacks.SHUTDOWN, function()
    cvars.cl_ragdoll_gravity:set_int(0)
    cvars.cl_ragdoll_physics_enable:set_int(1)  
    cvars.sv_party_mode:set_int(0)  
    cvars.fov_cs_debug:set_int(0)
    scope_color_from_cheat:set(color_t(scope_color_from_cheat:get().r, scope_color_from_cheat:get().g, scope_color_from_cheat:get().b, 255))
    cvars.sv_maxusrcmdprocessticks:set_int(16)
    cvars.cl_clock_correction:set_int(1)
    game_rules.set_prop("m_bIsValveDS", 0)
end)