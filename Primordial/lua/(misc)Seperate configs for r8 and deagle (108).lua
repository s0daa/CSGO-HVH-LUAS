local weapon       = menu.add_selection("fumo targetting", "Weapon", {"deagle", "revolver"});
local hc_d         = menu.add_slider("fumo targetting", "hitchance", 0, 100);
local hc_r         = menu.add_slider("fumo targetting", "hitchance ", 0, 100);
local hcdt_d       = menu.add_slider("fumo targetting", "doubletap hitchance", 0, 100);
local hcdt_r       = menu.add_slider("fumo targetting", "doubletap hitchance ", 0, 100);
local dynhc_d      = menu.add_checkbox("fumo targetting", "Dynamic hitchance");
local dynhc_r      = menu.add_checkbox("fumo targetting", "Dynamic hitchance ");
local mindamage_d  = menu.add_slider("fumo targetting", "Min", 0, 100);
local mindamage_r  = menu.add_slider("fumo targetting", "Min ", 0, 100);
local overaw_d     = menu.add_checkbox("fumo targetting", "override autowall damage");
local overawdmg_d  = menu.add_slider("fumo targetting", "autowall", 0, 100);
local overaw_r     = menu.add_checkbox("fumo targetting", "autowall ");
local overawdmg_r  = menu.add_slider("fumo targetting", "autowall ", 0, 100);
local scaledmg_r   = menu.add_checkbox("fumo targetting", "scale damage based on hp");
local scaledmg_d   = menu.add_checkbox("fumo targetting", "scale damage based on hp "); 
local dmgacc_d     = menu.add_slider("fumo targetting", "damage accuracy", 0, 100);
local dmgacc_r     = menu.add_slider("fumo targetting", "damage accuracy ", 0, 100);
local target_d     = menu.add_selection("fumo targetting", "target selection", {"crosshair", "distance", "health"});
local target_r     = menu.add_selection("fumo targetting", "target selection ", {"crosshair", "distance", "health"});

local safe_d        = menu.add_selection("fumo accuracy", "safepoint", {"normal", "strict"});
local safe_r        = menu.add_selection("fumo accuracy", "safepoint ", {"normal", "strict"});
local safestates_d  = menu.add_multi_selection("fumo accuracy", "force safepoint states", {"in air", "second doubletap shot", "unresolved", "on peek", "on enemy peek", "lethal", "on enemy shot"});
local safestates_r  = menu.add_multi_selection("fumo accuracy", "force safepoint states ", {"in air", "second doubletap shot", "unresolved", "on peek", "on enemy peek", "lethal", "on enemy shot"});
local hcignore_d    = menu.add_checkbox("fumo accuracy", "ignore hitchance if fully accurate");
local hcignore_r    = menu.add_checkbox("fumo accuracy", "ignore hitchance if fully accurate ");
local astop_d       = menu.add_checkbox("fumo accuracy", "autostop");
local astopm_d      = menu.add_multi_selection("fumo accuracy", "autostop modes", {"full stop", "stop between shots", "early", "dont stop in fire", "delay shot until fully accurate", "crouch"});
local astop_r       = menu.add_checkbox("fumo accuracy", "autostop ");
local astopm_r      = menu.add_multi_selection("fumo accuracy", "autostop modes ", {"full stop", "stop between shots", "early", "dont stop in fire", "delay shot until fully accurate", "crouch"});

local hitbox_d      = menu.add_multi_selection("fumo hitbox selection", "hitbox", {"head","chest", "arms", "stomach","legs", "feet"});
local hitbox_r      = menu.add_multi_selection("fumo hitbox selection", "hitbox ", {"head","chest", "arms", "stomach","legs", "feet"});
local multipoints_d = menu.add_multi_selection("fumo hitbox selection", "multipoints", {"head","chest", "arms", "stomach","legs", "feet"});
local multipoints_r = menu.add_multi_selection("fumo hitbox selection", "multipoints ", {"head","chest", "arms", "stomach","legs", "feet"});
local prefer_d      = menu.add_multi_selection("fumo hitbox selection", "prefer", {"head","chest", "arms", "stomach","legs", "feet"});
local prefer_r      = menu.add_multi_selection("fumo hitbox selection", "prefer ", {"head","chest", "arms", "stomach","legs", "feet"});
local safeboxes_r   = menu.add_multi_selection("fumo hitbox selection", "safeboxes ", {"head","chest", "arms", "stomach","legs", "feet"});
local safeboxes_d   = menu.add_multi_selection("fumo hitbox selection", "safeboxes", {"head","chest", "arms", "stomach","legs", "feet"});
local ignorelimbs_d = menu.add_checkbox("fumo hitbox selection", "ignore limbs if moving");
local ignorelimbs_r = menu.add_checkbox("fumo hitbox selection", "ignore limbs if moving ");

local forcemd_d     = menu.add_slider("fumo target overrides", "force min. damage", 0, 100);
local forcemd_r     = menu.add_slider("fumo target overrides", "force min. damage ", 0, 100);
local forcehitbox_d = menu.add_multi_selection("fumo target overrides", "force hitbox", {"head","chest", "arms", "stomach","legs", "feet"});
local forcehitbox_r = menu.add_multi_selection("fumo target overrides ", "force hitbox", {"head","chest", "arms", "stomach","legs", "feet"});
local forcehc_d     = menu.add_slider("fumo target overrides", "force hitchance", 0, 100);
local forcehc_r     = menu.add_slider("fumo target overrides", "force hitchance ", 0, 100);


function on_paint(text)
    menu_stuff()

    return text;
end

function handleweapon() 
    local lp = entity_list.get_local_player();

    if lp == nil then
        return;
    end

    if not lp:is_alive() then 
        return;
    end

    local weapon_handle = entity_list.get_local_player():get_prop("m_hActiveWeapon");
    if weapon_handle == nil then
        return nil;
    end

    local weapon = entity_list.get_entity(weapon_handle);
    local weapon_name = weapon:get_name();

    local hp_hc          = menu.find("aimbot", "heavy pistols", "targeting", "hitchance");
    local hp_dthc        = menu.find("aimbot", "heavy pistols","targeting", "doubletap hitchance")
    local hp_dynhc       = menu.find("aimbot", "heavy pistols", "targeting","dynamic hitchance")
    local hp_md          = menu.find("aimbot", "heavy pistols", "targeting","min. damage")
    local hp_overaw      = menu.find("aimbot", "heavy pistols","targeting", "override autowall damage")
    local hp_overawdmg   = menu.find("aimbot", "heavy pistols","targeting", "autowall")
    local hp_scaledmg    = menu.find("aimbot", "heavy pistols","targeting", "scale damage based on hp")
    local hp_dmgacc      = menu.find("aimbot", "heavy pistols", "targeting", "damage accuracy")
    local hp_target      = menu.find("aimbot", "heavy pistols", "targeting", "target selection")
    
    local hp_safe        = menu.find("aimbot", "heavy pistols", "accuracy", "safepoint")
    local hp_safestates  = menu.find("aimbot", "heavy pistols", "accuracy", "force safepoint states")
    local hp_ignorehc    = menu.find("aimbot", "heavy pistols", "accuracy", "ignore hitchance if fully accurate")
    local hp_astop       = menu.find("aimbot", "heavy pistols", "accuracy", "autostop")
    local hp_astopm      = menu.find("aimbot", "heavy pistols", "accuracy", "options")

    local hp_boxes       = menu.find("aimbot", "heavy pistols", "hitbox selection", "hitboxes");
    local hp_multipoints = menu.find("aimbot", "heavy pistols", "hitbox selection", "multipoints");
    local hp_prefer      = menu.find("aimbot", "heavy pistols", "hitbox selection", "prefer hitboxes");
    local hp_safeboxes   = menu.find("aimbot", "heavy pistols", "hitbox selection", "safe hitboxes");
    local hp_ignorelimbs = menu.find("aimbot", "heavy pistols", "hitbox selection", "ignore limbs if moving");

    local hp_forcemd     = menu.find("aimbot", "heavy pistols", "target overrides", "force min. damage")
    local hp_forcehitbox = menu.find("aimbot", "heavy pistols", "target overrides", "force hitbox")
    local hp_forcesafe   = menu.find("aimbot", "heavy pistols", "target overrides", "force safepoint")
    local hp_forcehc     = menu.find("aimbot", "heavy pistols", "target overrides", "force hitchance")

    if weapon_name == "deagle" then 
        hp_hc:set(hc_d:get());
        hp_dthc:set(hcdt_d:get());
        hp_dynhc:set(dynhc_d:get());
        hp_md:set(mindamage_d:get());
        hp_overaw:set(overaw_d:get());
        hp_overawdmg:set(overawdmg_d:get());
        hp_scaledmg:set(scaledmg_d:get());
        hp_dmgacc:set(dmgacc_d:get());
        hp_target:set(target_d:get());

        hp_safe:set(safe_d:get());
        set_multi(hp_safestates, safestates_d)
        hp_ignorehc:set(hcignore_d:get());
        hp_astop:set(astop_d:get());
        set_multi(hp_astopm, astopm_d)

        set_multi(hp_boxes, hitbox_d)
        set_multi(hp_multipoints, multipoints_d)
        set_multi(hp_prefer, prefer_d)
        set_multi(hp_safeboxes, safeboxes_d)
        hp_ignorelimbs:set(ignorelimbs_d:get());

        hp_forcemd[1]:set(forcemd_d:get());
        set_multi(hp_forcehitbox[1], forcehitbox_d)
        hp_forcehc[1]:set(forcehc_d:get());
    elseif weapon_name == "revolver" then
        hp_hc:set(hc_r:get());
        hp_dthc:set(hcdt_r:get());
        hp_dynhc:set(dynhc_r:get());
        hp_md:set(mindamage_r:get());
        hp_overaw:set(overaw_r:get());
        hp_overawdmg:set(overawdmg_r:get());
        hp_scaledmg:set(scaledmg_r:get());
        hp_dmgacc:set(dmgacc_r:get());
        hp_target:set(target_r:get());

        hp_safe:set(safe_r:get());
        hp_ignorehc:set(hcignore_r:get());
        hp_astop:set(astop_r:get());
        set_multi(hp_astopm, astopm_r)

        set_multi(hp_boxes, hitbox_r)
        set_multi(hp_multipoints, multipoints_r)
        set_multi(hp_prefer, prefer_r)
        set_multi(hp_safeboxes, safeboxes_r)
        hp_ignorelimbs:set(ignorelimbs_r:get());

        hp_forcemd[1]:set(forcemd_r:get());
        set_multi(hp_forcehitbox[1], forcehitbox_r)
        hp_forcehc[1]:set(forcehc_r:get());
    end
end


function menu_stuff() 
    local current_category = weapon:get();
    local deagle = current_category == 1;
    local revolver = current_category == 2;

    hc_d:set_visible(deagle and true or false);
    hcdt_d:set_visible(deagle and true or false);
    dynhc_d:set_visible(deagle and true or false);
    mindamage_d:set_visible(deagle and true or false);
    overaw_d:set_visible(deagle and true or false);
    overawdmg_d:set_visible(deagle and true or false);
    scaledmg_d:set_visible(deagle and true or false);
    dmgacc_d:set_visible(deagle and true or false);
    target_d:set_visible(deagle and true or false);

    safe_d:set_visible(deagle and true or false);
    safestates_d:set_visible(deagle and true or false);
    hcignore_d:set_visible(deagle and true or false);
    astop_d:set_visible(deagle and true or false);
    astopm_d:set_visible(deagle and true or false);
    
    hitbox_d:set_visible(deagle and true or false);
    multipoints_d:set_visible(deagle and true or false);
    prefer_d:set_visible(deagle and true or false);
    safeboxes_d:set_visible(deagle and true or false);
    ignorelimbs_d:set_visible(deagle and true or false);

    forcemd_d:set_visible(deagle and true or false);
    forcehitbox_d:set_visible(deagle and true or false);
    forcehc_d:set_visible(deagle and true or false);

    hc_r:set_visible(revolver and true or false);
    hcdt_r:set_visible(revolver and true or false);
    dynhc_r:set_visible(revolver and true or false);
    mindamage_r:set_visible(revolver and true or false);
    overaw_r:set_visible(revolver and true or false);
    overawdmg_r:set_visible(revolver and true or false);
    scaledmg_r:set_visible(revolver and true or false);
    dmgacc_r:set_visible(revolver and true or false);
    target_r:set_visible(revolver and true or false);

    safe_r:set_visible(revolver and true or false);
    safestates_r:set_visible(revolver and true or false);
    hcignore_r:set_visible(revolver and true or false);
    astop_r:set_visible(revolver and true or false);
    astopm_r:set_visible(revolver and true or false);
    
    hitbox_r:set_visible(revolver and true or false);
    multipoints_r:set_visible(revolver and true or false);
    prefer_r:set_visible(revolver and true or false);
    safeboxes_r:set_visible(revolver and true or false);
    ignorelimbs_r:set_visible(revolver and true or false);

    forcemd_r:set_visible(revolver and true or false);
    forcehitbox_r:set_visible(revolver and true or false);
    forcehc_r:set_visible(revolver and true or false);
end

function set_multi(multi, value)
    local amt = value:get_items();

    for i = 1, #amt do 
        multi:set(i, value:get(i));
    end
end

callbacks.add(e_callbacks.DRAW_WATERMARK, on_paint)
callbacks.add(e_callbacks.NET_UPDATE, handleweapon)