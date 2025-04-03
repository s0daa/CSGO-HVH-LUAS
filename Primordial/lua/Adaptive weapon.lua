local wpns = {}
local wpn_selec = { "Deagle", "Revolver", "Rifles", "SMGs", "Shotgun", "Machinegun" }

local wpn_selection = menu.add_selection("Weapon override", "Weapons", wpn_selec)
for i=1, #wpn_selec do
    wpns[i] = {
        lab1 = menu.add_text("targeting", "===> "..wpn_selec[i].." <==="),
        hc = menu.add_slider("targeting", "hitchance", 0, 100, 1.0, 0, "%"),
        dt_hc = menu.add_slider("targeting", "doubletap hitchance", 0, 100, 1.0, 0, "%"),
        dyn_hc = menu.add_checkbox("targeting", "dynamic hitchance", false),
        min_dmg = menu.add_slider("targeting", "min. damage", 0, 100, 1.0, 0, "hp"),
        ove_aw_dmg = menu.add_checkbox("targeting", "override autowall damage", false),
        aw_dmg = menu.add_slider("targeting", "autowall", 0, 100, 1.0, 0, "hp"),
        scale_dmg = menu.add_checkbox("targeting", "scale damage based on hp", false),
        dmg_acc = menu.add_slider("targeting", "damage accuracy", 0, 100, 1.0, 0, "%"),
        target_selec = menu.add_selection("targeting", "target selection", { "crosshair", "distance", "health" }),
        lab2 = menu.add_text("accuracy", "===> "..wpn_selec[i].." <==="),
        safe_point = menu.add_selection("accuracy", "safepoint", { "normal", "strict" }),
        sp_states = menu.add_multi_selection("accuracy", "force safepoint states", { "in air", "second doubletap shot", "unresolved", "on peek", "on enemy peek", "lethal", "on enemy shot" }),
        ignore_hc = menu.add_checkbox("accuracy", "ignore hitchance if fully accurate", false),
        auto_stop = menu.add_checkbox("accuracy", "autostop", false),
        stop_options = menu.add_multi_selection("accuracy", "options", { "full stop", "stop between shots", "early", "dont stop in fire", "delay shot until fully accurate", "crouch" }),
        lab3 = menu.add_text("hitbox selection", "===> "..wpn_selec[i].." <==="),
        hitboxes = menu.add_multi_selection("hitbox selection", "hitboxes", { "head", "chest", "arms", "stomach", "legs", "feet" }),
        multipoints = menu.add_multi_selection("hitbox selection", "multipoints", { "head", "chest", "arms", "stomach", "legs", "feet" }),
        pre_hitboxes = menu.add_multi_selection("hitbox selection", "prefer hitboxes", { "head", "chest", "arms", "stomach", "legs", "feet" }),
        safe_hitboxes = menu.add_multi_selection("hitbox selection", "safe hitboxes", { "head", "chest", "arms", "stomach", "legs", "feet" }),
        ignore_limbs = menu.add_checkbox("hitbox selection", "ignore limbs if moving", false),
        lab4 = menu.add_text("target overrides", "===> "..wpn_selec[i].." <==="),
        force_dmg = menu.add_slider("target overrides", "force min. damage", 0, 100, 1.0, 0, "hp"),
        force_hitbox = menu.add_multi_selection("target overrides", "force hitbox", { "head", "chest", "arms", "stomach", "legs", "feet" }),
        force_hc = menu.add_slider("target overrides", "force hitchance", 0, 100, 1.0, 0, "%"),
    }
end

local wpn_settings = function(wpn_group,i)
    local ref = {
        hc = menu.find("aimbot", wpn_group, "targeting", "hitchance"),
        dt_hc = menu.find("aimbot", wpn_group, "targeting", "doubletap hitchance"),
        dyn_hc = menu.find("aimbot", wpn_group, "targeting", "dynamic hitchance"),
        min_dmg = menu.find("aimbot", wpn_group, "targeting", "min. damage"),
        ove_aw_dmg = menu.find("aimbot", wpn_group, "targeting", "override autowall damage"),
        aw_dmg = menu.find("aimbot", wpn_group, "targeting", "autowall"),
        scale_dmg = menu.find("aimbot", wpn_group, "targeting", "scale damage based on hp"),
        dmg_acc = menu.find("aimbot", wpn_group, "targeting", "damage accuracy"),
        target_selec = menu.find("aimbot", wpn_group, "targeting", "target selection"),
        safe_point = menu.find("aimbot", wpn_group, "accuracy", "safepoint"),
        sp_states = menu.find("aimbot", wpn_group, "accuracy", "force safepoint states"),
        ignore_hc = menu.find("aimbot", wpn_group, "accuracy", "ignore hitchance if fully accurate"),
        auto_stop = menu.find("aimbot", wpn_group, "accuracy", "autostop"),
        stop_options = menu.find("aimbot", wpn_group, "accuracy", "options"),
        hitboxes = menu.find("aimbot", wpn_group, "hitbox selection", "hitboxes"),
        multipoints = menu.find("aimbot", wpn_group, "hitbox selection", "multipoints"),
        pre_hitboxes = menu.find("aimbot", wpn_group, "hitbox selection", "prefer hitboxes"),
        safe_hitboxes = menu.find("aimbot", wpn_group, "hitbox selection", "safe hitboxes"),
        ignore_limbs = menu.find("aimbot", wpn_group, "hitbox selection", "ignore limbs if moving"),
        force_dmg = menu.find("aimbot", wpn_group, "target overrides", "force min. damage"),       
        force_hitbox = menu.find("aimbot", wpn_group, "target overrides", "force hitbox"),       
        force_hc = menu.find("aimbot", wpn_group, "target overrides", "force hitchance"),       
    }

    ref.hc:set(wpns[i].hc:get())
    ref.dt_hc:set(wpns[i].dt_hc:get())
    ref.dyn_hc:set(wpns[i].dyn_hc:get())
    ref.min_dmg:set(wpns[i].min_dmg:get())
    ref.ove_aw_dmg:set(wpns[i].ove_aw_dmg:get())
    ref.aw_dmg:set(wpns[i].aw_dmg:get())
    ref.scale_dmg:set(wpns[i].scale_dmg:get())
    ref.dmg_acc:set(wpns[i].dmg_acc:get())
    ref.target_selec:set(wpns[i].target_selec:get())
    ref.safe_point:set(wpns[i].safe_point:get())
    for k=1, 6 do
        ref.stop_options:set(k, wpns[i].stop_options:get(k))
        ref.hitboxes:set(k, wpns[i].hitboxes:get(k))
        ref.multipoints:set(k, wpns[i].multipoints:get(k))
        ref.pre_hitboxes:set(k, wpns[i].pre_hitboxes:get(k))
        ref.safe_hitboxes:set(k, wpns[i].safe_hitboxes:get(k))
        ref.force_hitbox[1]:set(k, wpns[i].force_hitbox:get(k))
    end
    for f=1, 7 do
        ref.sp_states:set(f, wpns[i].sp_states:get(f))
    end
    ref.ignore_hc:set(wpns[i].ignore_hc:get())
    ref.auto_stop:set(wpns[i].auto_stop:get())
    ref.ignore_limbs:set(wpns[i].ignore_limbs:get())
    ref.force_dmg[1]:set(wpns[i].force_dmg:get())
    ref.force_hc[1]:set(wpns[i].force_hc:get())
end

callbacks.add(e_callbacks.RUN_COMMAND, function(cmd, pre_cmd)
    local local_player = entity_list.get_local_player()
    local active_weapon = local_player:get_active_weapon()
    if local_player == nil then return end
    if active_weapon == nil then return end

    if active_weapon:get_weapon_data().console_name == "weapon_deagle" then
        wpn_settings("heavy pistols",1)
    elseif active_weapon:get_weapon_data().console_name == "weapon_revolver" then
        wpn_settings("heavy pistols",2)
    elseif active_weapon:get_weapon_data().type == e_weapon_types.RIFLE then
        wpn_settings("other",3)
    elseif active_weapon:get_weapon_data().type == e_weapon_types.SMG then
        wpn_settings("other",4)
    elseif active_weapon:get_weapon_data().type == e_weapon_types.SHOTGUN then
        wpn_settings("other",5)
    elseif active_weapon:get_weapon_data().type == e_weapon_types.MACHINE_GUN then
        wpn_settings("other",6)
    end
end)

function menu_visible_set()
    if not menu.is_open() then return end

    for i=1, #wpn_selec do
        local menu_show = wpn_selection:get_item_name(wpn_selection:get()) == wpn_selec[i] 
        wpns[i].lab1:set_visible(menu_show)
        wpns[i].lab2:set_visible(menu_show)
        wpns[i].lab3:set_visible(menu_show)
        wpns[i].lab4:set_visible(menu_show)
        wpns[i].hc:set_visible(menu_show)
        wpns[i].dt_hc:set_visible(menu_show)
        wpns[i].dyn_hc:set_visible(menu_show)
        wpns[i].min_dmg:set_visible(menu_show)
        wpns[i].ove_aw_dmg:set_visible(menu_show)
        wpns[i].aw_dmg:set_visible(menu_show and wpns[i].ove_aw_dmg:get())
        wpns[i].scale_dmg:set_visible(menu_show)
        wpns[i].dmg_acc:set_visible(menu_show)
        wpns[i].target_selec:set_visible(menu_show)
        wpns[i].safe_point:set_visible(menu_show)
        wpns[i].sp_states:set_visible(menu_show)
        wpns[i].ignore_hc:set_visible(menu_show)
        wpns[i].auto_stop:set_visible(menu_show)
        wpns[i].stop_options :set_visible(menu_show)
        wpns[i].hitboxes:set_visible(menu_show)
        wpns[i].multipoints:set_visible(menu_show)
        wpns[i].pre_hitboxes:set_visible(menu_show)
        wpns[i].safe_hitboxes:set_visible(menu_show)
        wpns[i].ignore_limbs:set_visible(menu_show)
        wpns[i].force_dmg:set_visible(menu_show)
        wpns[i].force_hitbox:set_visible(menu_show)
        wpns[i].force_hc:set_visible(menu_show)
    end
end

callbacks.add(e_callbacks.PAINT, menu_visible_set)