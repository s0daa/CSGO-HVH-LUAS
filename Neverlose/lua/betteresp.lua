-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local _, l_result_0 = pcall(require, "neverlose/beams");
local l_information_0 = require("neverlose/bomb_information");
local l_manager_0 = require("neverlose/file_manager");
local v4 = cvar.mat_autoexposure_max_multiplier:int();
local v5 = false;
local v6 = common.get_game_directory();
local v7 = {
    ragebot = ui.find("Aimbot", "Ragebot", "Main", "Enabled"), 
    dormant_aimbot = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
    doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
    slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
    oof_arrows = ui.find("Visuals", "Players", "Enemies", "ESP", "Offscreen ESP"), 
    oof_arrows_radius = ui.find("Visuals", "Players", "Enemies", "ESP", "Offscreen ESP", "Radius"), 
    enemy_weapon_chams = ui.find("Visuals", "Players", "Enemies", "Chams", "Weapon")
};
local v8 = {
    yellow = "\aB6B665FF", 
    default = "\aDEFAULT"
};
local v12 = setmetatable({}, {
    __index = function(v9, v10)
        local v11 = ui.get_icon(v10);
        rawset(v9, v10, v11);
        return v11;
    end
});
local v13 = {
    main = {
        group = ui.create("Main", 1)
    }
};
v13.main.welcome_text = v13.main.group:label(""):disabled(true);
v13.main.version_text = v13.main.group:label(""):disabled(true);
v13.discord = {
    group = ui.create("", 1)
};
v13.discord.text = v13.discord.group:label("");
v13.discord.button = v13.discord.group:button("  Join  ", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.com/invite/kapPFV2zhd");
end, true);
v13.flags = {
    group = ui.create("ESP - Flags", 1)
};
v13.flags.text = v13.flags.group:label(""):tooltip("[CN] \233\128\137\233\161\185\228\189\141\228\186\142 ESP \229\134\133\233\131\168" .. "\n" .. "[RU] \208\158\208\191\209\134\208\184\208\184 \208\189\208\176\209\133\208\190\208\180\209\143\209\130\209\129\209\143 \208\178\208\189\209\131\209\130\209\128\208\184 ESP");
v13.flags.location = v13.flags.group:label("");
v13.features = {
    group = ui.create("ESP - Features", 2)
};
v13.features.esp_corrections = v13.features.group:selectable("ESP Corrections", "Spectator Glow", "Chams Color", "Weapon Chams"):tooltip("\194\183 Spectator Glow: forces correct glow color when spectating.\n\n\194\183 Chams Color: corrects chams color on certain maps.\n\n\194\183 Weapon Chams: disables enemy weapon chams when spectating an enemy.");
v13.features.oof_arrows = {
    switch = v13.features.group:switch("OOF Arrows"):tooltip("\226\139\133 Out Of Fov Arrows with additional features.")
};
v13.features.oof_arrows.show_dormancy = v13.features.oof_arrows.switch:create():switch("Show Dormancy");
v13.features.oof_arrows.arrow_pulse = v13.features.oof_arrows.switch:create():switch("Arrow Pulse");
v13.features.oof_arrows.radius = v13.features.oof_arrows.switch:create():slider("Radius", 5, 95, 33, 1, "%");
v13.features.oof_arrows.color = v13.features.oof_arrows.switch:create():color_picker("Color", color(110, 170, 255, 255));
v13.features.last_dormant_position = {
    switch = v13.features.group:switch("Last Dormant Position"):tooltip("\194\183 Indicates the last known dormant position of the player.")
};
v13.features.last_dormant_position.style = v13.features.last_dormant_position.switch:create():combo("Style", "Gamesense", "Modern");
v13.features.last_dormant_position.font = v13.features.last_dormant_position.switch:create():combo("Font", "Default", "Small", "Console");
v13.features.last_dormant_position.show_offscreen = v13.features.last_dormant_position.switch:create():switch("Show Offscreen");
v13.features.last_dormant_position.color = v13.features.last_dormant_position.switch:create():color_picker("Color", color(255, 0, 0, 150));
v13.features.zeus_warning = {
    switch = v13.features.group:switch("Zeus Warning"):tooltip("\226\139\133 Indicates if enemy is having a Taser in his inventory/hand." .. "\n\n" .. v8.yellow .. v12["triangle-exclamation"] .. "  This feature requires intensive render processing. Enabling it may lead to lower FPS")
};
v13.features.zeus_warning.style = v13.features.zeus_warning.switch:create():combo("Style", "Gamesense", "Thunder");
v13.features.zeus_warning.position = v13.features.zeus_warning.switch:create():combo("Position", "Left", "Above", "Right");
v13.features.zeus_warning.colors = v13.features.zeus_warning.switch:create():color_picker("Colors", {
    Inventory = {
        color(255, 242, 0, 255)
    }, 
    Holding = {
        color(255, 82, 82, 255)
    }
}):tooltip("\226\139\133 Set custom colors for diffrent states." .. "\n\n" .. v8.yellow .. v12["lightbulb-on"] .. "  You can disable a state by setting the color alpha to 0");
v13.features.beam_sound_esp = {
    switch = v13.features.group:switch("Beam Sound ESP"):tooltip("\194\183 Indicates if enemy makes a sound.")
};
v13.features.beam_sound_esp.color = v13.features.beam_sound_esp.switch:color_picker(color(255, 200, 200, 255));
v13.features.lagcomp_box = {
    switch = v13.features.group:switch("Lagcomp Box"):tooltip("\194\183 Shows the enemy's Lagcompensation debug box.")
};
v13.features.lagcomp_box.color = v13.features.lagcomp_box.switch:color_picker(color(63, 147, 255, 255));
v13.features.hostage_esp = {
    text = v13.features.group:label("Hostage ESP"):tooltip("\194\183 Indicates if enemy makes a sound.")
};
v13.features.hostage_esp.show_icon = v13.features.hostage_esp.text:create():switch("Icon");
v13.features.hostage_esp.icon_color = v13.features.hostage_esp.show_icon:color_picker();
v13.features.hostage_esp.show_text = v13.features.hostage_esp.text:create():switch("Text");
v13.features.hostage_esp.text_color = v13.features.hostage_esp.show_text:color_picker();
v13.features.hostage_esp.show_distance = v13.features.hostage_esp.text:create():switch("Distance");
v13.features.hostage_esp.distance_color = v13.features.hostage_esp.show_distance:color_picker();
v13.features.hostage_esp.distance = v13.features.hostage_esp.text:create():slider("Max Distance:", 1, 6, 4, 1, function(v14)
    if v14 == 6 then
        return "Inf.";
    else
        return v14 * 20 .. "m";
    end;
end);
local function v31(v15, v16, v17, v18, v19, v20, v21, v22, v23)
    local v24 = "";
    local v25 = #v23 - 1;
    local v26 = (v19 - v15) / v25;
    local v27 = (v20 - v16) / v25;
    local v28 = (v21 - v17) / v25;
    local v29 = (v22 - v18) / v25;
    for v30 = 1, v25 + 1 do
        v24 = v24 .. ("\a%02x%02x%02x%02x%s"):format(v15, v16, v17, v18, v23:sub(v30, v30));
        v15 = v15 + v26;
        v16 = v16 + v27;
        v17 = v17 + v28;
        v18 = v18 + v29;
    end;
    return v24;
end;
local function v35(v32, v33)
    for v34 = 1, #v32 do
        if v32[v34] == v33 then
            return true;
        end;
    end;
    return false;
end;
local function v38(v36, v37)
    if v37 <= #v36 then
        v36 = string.sub(v36, 1, v37 - 4) .. "...";
    end;
    return v36;
end;
local function v46(v39, v40)
    local v41 = v39:get_player_weapon(true);
    for _, v43 in pairs(v41) do
        if type(v40) == "table" then
            for _, v45 in pairs(v40) do
                if v43:get_weapon_index() == v45 then
                    return true;
                end;
            end;
        elseif v43:get_weapon_index() == v40 then
            return true;
        end;
    end;
    return false;
end;
local function v53(v47, v48)
    local v49 = v47:get_origin():dist((v48:get_hitbox_position(3)));
    local v50 = v47:get_player_weapon();
    if v50 and v50:is_weapon() then
        local v51 = v50:get_weapon_info();
        if v51.weapon_type ~= 0 and v51.weapon_type ~= 7 and v51.weapon_type ~= 9 then
            local v52 = (v48.m_ArmorValue == 0 and v51.damage or v51.damage * v51.armor_ratio / 2) * 1.244186046511628 * v51.range_modifier ^ (v49 / 500);
            return v52, v48.m_iHealth <= v52;
        end;
    end;
    return -1, false;
end;
local function v60()
    local v54 = {};
    local v55 = entity.get_local_player();
    if not v55 then
        return v54;
    else
        local l_m_hObserverTarget_0 = v55.m_hObserverTarget;
        local l_m_iObserverMode_0 = v55.m_iObserverMode;
        if not l_m_hObserverTarget_0 or l_m_iObserverMode_0 == 1 or l_m_iObserverMode_0 == 2 or l_m_iObserverMode_0 == 6 or v55.m_iTeamNum == 1 and l_m_iObserverMode_0 == 6 or l_m_hObserverTarget_0.m_iTeamNum == v55.m_iTeamNum then
            v54 = entity.get_players(true, true);
        else
            for _, v59 in pairs(entity.get_players(false, true)) do
                if v59 ~= v55 and v59:is_alive() and v59.m_iTeamNum ~= l_m_hObserverTarget_0.m_iTeamNum then
                    table.insert(v54, v59);
                end;
            end;
        end;
        return v54;
    end;
end;
local function v65()
    local v61 = {};
    local v62 = entity.get_players(true, true);
    for _, v64 in pairs(v62) do
        if not v64:is_bot() then
            table.insert(v61, v64:get_name());
        end;
    end;
    if #v61 < 1 then
        v61 = {
            [1] = "\t\t     No Players Found"
        };
    end;
    return v61;
end;
local function v79(v66, v67, v68)
    if not v66 or not v67 or not v66:is_alive() then
        return false;
    else
        local v69 = {};
        local v70 = v67:get_origin();
        local v71 = v66:get_eye_position();
        if v67:is_dormant() then
            v69[1] = v70 + vector(0, 0, 48);
            v69[2] = v70 + vector(0, 0, 32);
            v69[3] = v70 + vector(0, 0, 16);
        else
            if not v68 then
                v68 = {
                    [1] = 0, 
                    [2] = 11, 
                    [3] = 12, 
                    [4] = 13, 
                    [5] = 14
                };
            end;
            for v72, v73 in pairs(v68) do
                v69[v72] = v67:get_hitbox_position(v73);
            end;
        end;
        for _, v75 in pairs(v69) do
            local v77, v78 = utils.trace_bullet(v66, v71, v75, function(v76)
                -- upvalues: v67 (ref)
                return v76 == v67;
            end);
            if v78 and v78:did_hit() and v77 > 0 and not v78.start_solid then
                return true;
            end;
        end;
        return false;
    end;
end;
local v83 = esp.enemy:new_text("Custom", "Custom", function(v80)
    if custom_dormant:get() and v80:is_dormant() then
        return;
    else
        for _, v82 in pairs(custom_combo:get()) do
            if custom_combo:list()[v82] == v80:get_name() then
                return custom_text:get();
            end;
        end;
        return;
    end;
end):create();
custom_combo = v83:listable("", v65());
custom_button = v83:button("                       Update List                       ", function()
    -- upvalues: v65 (ref)
    if unpack(v65()) ~= unpack(custom_combo:list()) then
        common.add_notify("ESP Additions", "Updated Playerlist");
    end;
    custom_combo:update(v65());
end);
custom_text = v83:input(v12.comment .. "  Text", "AX User");
custom_dormant = v83:switch("Disable if Dormant");
custom_label = v83:label("Indicates a custom Flag for selected players"):disabled(true);
local v85 = esp.enemy:new_text("Healthshot", "Healthshot", function(v84)
    -- upvalues: v46 (ref)
    if healthshot_dormant:get() and v84:is_dormant() then
        return;
    elseif v46(v84, 57) then
        return healthshot_combo:get();
    else
        return;
    end;
end);
healthshot_combo = v85:create():combo("Flag Style", "Healthshot", "Stim", "Heal");
healthshot_dormant = v85:create():switch("Disable if Dormant", true);
healthshot_label = v85:create():label("Indicates if enemy is having a healthshot in his inventory"):disabled(true);
local v87 = esp.enemy:new_text("AFK", "AFK", function(v86)
    if afk_dormant:get() and v86:is_dormant() then
        return;
    elseif v86:is_bot() then
        return;
    elseif v86.m_bHasMovedSinceSpawn == false then
        return "AFK";
    else
        return;
    end;
end);
afk_dormant = v87:create():switch("Disable if Dormant", true);
afk_label = v87:create():label("Indicates if enemy is AFK in spawn"):disabled(true);
local v91 = esp.enemy:new_text("Ping Carried", "Ping Carried", function(v88)
    -- upvalues: v12 (ref)
    if v88:is_bot() then
        return;
    elseif ping_dormant:get() and v88:is_dormant() then
        return;
    else
        local l_m_iPing_0 = v88:get_resource().m_iPing;
        local v90 = v88:is_dormant() and color(255, 30, 30, 255):grayscale(1) or color(255, 30, 30, 255);
        if l_m_iPing_0 <= ping_trigger:get() then
            return "\a" .. v90:to_hex() .. v12["triangle-exclamation"] .. " Ping Carried (" .. l_m_iPing_0 .. ")";
        elseif not ping_trigger_check:get() then
            return l_m_iPing_0 .. " ms";
        else
            return;
        end;
    end;
end);
ping_trigger = v91:create():slider("Trigger:", 1, 20, 10, 1, "ms"):tooltip("\226\139\133 Set the ping at which the warning is triggered");
ping_trigger_check = v91:create():switch("Only show warning", true):tooltip("\226\139\133 Only show the Flag if player ping is under set trigger");
ping_dormant = v91:create():switch("Disable if Dormant", true);
ping_label = v91:create():label("Indicates if enemy ping is under/over set value"):disabled(true);
local v96 = esp.enemy:new_text("Revolver Helper", "Revolver Helper", function(v92)
    -- upvalues: v53 (ref)
    if revolver_dormant:get() and v92:is_dormant() then
        return;
    else
        local v93 = entity.get_local_player();
        if not v93 or not v93:is_alive() then
            return;
        else
            local v94 = v93:get_player_weapon();
            if not v94 then
                return;
            elseif v94:get_weapon_index() ~= 64 then
                return;
            elseif v53(v93, v92) >= v92.m_iHealth then
                return "DMG+";
            elseif revolver_show_non_lethal:get() then
                if v92:is_dormant() then
                    local v95 = color(255, 40, 40, 255):grayscale(1);
                    colored_dmg = ("\a%02x%02x%02x%02x%s"):format(v95.r, v95.g, v95.b, v95.a, "DMG-");
                else
                    colored_dmg = ("\a%02x%02x%02x%02x%s"):format(255, 40, 40, 255, "DMG-");
                end;
                return colored_dmg;
            else
                return;
            end;
        end;
    end;
end);
revolver_lethal_tracers = v96:create():listable("Lethal Tracers", "Self", "Enemies"):tooltip("\226\139\133 Shows a line to whoever is currently lethal to a revolver shot");
revolver_lethal_tracers_colors = revolver_lethal_tracers:color_picker({
    Self = {
        color(255, 100, 100, 255)
    }, 
    Enemies = {
        color(100, 255, 100, 255)
    }
});
revolver_show_non_lethal = v96:create():switch("Show non-lethal"):tooltip("\226\139\133 Indicates who is not killable in 1 hit");
revolver_dormant = v96:create():switch("Disable if Dormant", true);
revolver_label = v96:create():label("Indicates if enemy is killable in 1 hit with revolver"):disabled(true);
local function v110()
    -- upvalues: v96 (ref), v53 (ref)
    if not v96:get() then
        return;
    else
        local v97 = entity.get_local_player();
        if not v97 or not v97:is_alive() then
            return;
        else
            if #revolver_lethal_tracers:get() > 0 then
                for _, v99 in pairs(entity.get_players(true, false)) do
                    if v99:is_alive() then
                        if revolver_lethal_tracers:get(1) then
                            local v100 = v99:get_player_weapon();
                            if v100 and v100:get_weapon_index() == 64 then
                                local _, v102 = v53(v99, v97);
                                if v102 then
                                    local v103 = v99:get_hitbox_position(3):to_screen();
                                    if v103 then
                                        if common.is_in_thirdperson() then
                                            local v104 = v97:get_hitbox_position(3):to_screen();
                                            if v104 then
                                                render.line(v104, v103, unpack(revolver_lethal_tracers_colors:get("Self")));
                                            end;
                                        else
                                            render.line(vector(render.screen_size().x / 2, render.screen_size().y), v103, unpack(revolver_lethal_tracers_colors:get("Self")));
                                        end;
                                    end;
                                end;
                            end;
                        end;
                        if revolver_lethal_tracers:get(2) then
                            local v105 = v97:get_player_weapon();
                            if v105 and v105:get_weapon_index() == 64 then
                                local _, v107 = v53(v97, v99);
                                if v107 then
                                    local v108 = v99:get_hitbox_position(3):to_screen();
                                    if v108 then
                                        if common.is_in_thirdperson() then
                                            local v109 = v97:get_hitbox_position(3):to_screen();
                                            if v109 then
                                                render.line(v109, v108, unpack(revolver_lethal_tracers_colors:get("Enemies")));
                                            end;
                                        else
                                            render.line(vector(render.screen_size().x / 2, render.screen_size().y), v108, unpack(revolver_lethal_tracers_colors:get("Enemies")));
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            return;
        end;
    end;
end;
local v114 = esp.enemy:new_text("Distance", "Distance", function(v111)
    if dist_dormant:get() and v111:is_dormant() then
        return;
    else
        local v112 = entity.get_local_player();
        if not v112 then
            return;
        else
            local v113 = v112:get_origin():dist(v111:get_origin());
            if dist_combo:get() == "Meters" then
                return tostring(math.floor(v113 / 39.37 + 0.5)) .. "m";
            elseif dist_combo:get() == "Units" then
                return tostring(math.floor(v113 + 0.5)) .. "u";
            elseif dist_combo:get() == "Feet" then
                return tostring(math.floor(v113 / 16 + 0.5)) .. "Ft";
            else
                return;
            end;
        end;
    end;
end);
dist_combo = v114:create():combo("Style", "Meters", "Units", "Feet");
dist_dormant = v114:create():switch("Disable if Dormant");
dist_label = v114:create():label("Indicates distance to enemy"):disabled(true);
fake_label = esp.enemy:new_text("Fake", "Fake", function(v115)
    if v115:is_dormant() then
        return;
    elseif v115:is_bot() then
        return;
    elseif v115["m_angEyeAngles[0]"] >= 88 then
        return "Fake";
    else
        return;
    end;
end):create():label("Indicates if enemy is likely using Anti-Aim"):disabled(true);
local v116 = {};
local v117 = {};
local function v125(v118, _, v120)
    -- upvalues: v35 (ref)
    if v35(entity.get_players(false, true), v118) then
        local v121 = v118.m_vecVelocity.z > 0 and cvar.sv_gravity:float() * globals.tickinterval or cvar.sv_jump_impulse:float() * globals.tickinterval;
        local l_m_vecVelocity_0 = v118.m_vecVelocity;
        local v123 = v118:get_origin();
        local v124 = v123 + vector(l_m_vecVelocity_0.x * v120 * globals.tickinterval, l_m_vecVelocity_0.y * v120 * globals.tickinterval, l_m_vecVelocity_0.z * v120 * globals.tickinterval + v121 * (v120 * globals.tickinterval * v120 * globals.tickinterval) / 2);
        return utils.trace_line(v123, v124, v118, 1).end_pos:clone();
    else
        return;
    end;
end;
local function v135()
    -- upvalues: v13 (ref), v60 (ref), v116 (ref), v117 (ref), v125 (ref)
    if shifting_tickbase_flag:get() or lagcomp_breaker_flag:get() or v13.features.lagcomp_box.switch:get() then
        if not globals.is_in_game or not globals.is_connected then
            return;
        else
            for _, v127 in pairs(v60()) do
                local v128 = v127:get_index();
                if v127:is_dormant() or not v127:is_alive() then
                    v116[v128] = nil;
                    v117[v128] = nil;
                elseif not v127:is_dormant() then
                    local v129 = v117[v128];
                    local l_m_flSimulationTime_0 = v127.m_flSimulationTime;
                    local v131 = v127:get_origin():clone();
                    if v129 then
                        local v132 = l_m_flSimulationTime_0 - v129.sim_time;
                        if v132 ~= 0 then
                            local v133 = (v129.origin - v131):lengthsqr();
                            local v134 = v125(v127, v127.m_fFlags, to_ticks(v132) - 1);
                            v116[v128] = {
                                ent = v127, 
                                alive = v127.m_iHealth > 0, 
                                origin = v131, 
                                extrapolated = v134, 
                                lagcomp = v133 > 4000 and v133 < 6000 and v127:is_bot() == false, 
                                shifting = l_m_flSimulationTime_0 / globals.tickinterval - globals.tickcount < 0
                            };
                        end;
                    end;
                    v117[v128] = {
                        sim_time = l_m_flSimulationTime_0, 
                        origin = v131
                    };
                end;
            end;
        end;
    end;
end;
local v136 = {
    [1] = {
        [1] = 0, 
        [2] = 1
    }, 
    [2] = {
        [1] = 1, 
        [2] = 2
    }, 
    [3] = {
        [1] = 2, 
        [2] = 3
    }, 
    [4] = {
        [1] = 3, 
        [2] = 0
    }, 
    [5] = {
        [1] = 5, 
        [2] = 6
    }, 
    [6] = {
        [1] = 6, 
        [2] = 7
    }, 
    [7] = {
        [1] = 1, 
        [2] = 4
    }, 
    [8] = {
        [1] = 4, 
        [2] = 8
    }, 
    [9] = {
        [1] = 0, 
        [2] = 4
    }, 
    [10] = {
        [1] = 1, 
        [2] = 5
    }, 
    [11] = {
        [1] = 2, 
        [2] = 6
    }, 
    [12] = {
        [1] = 3, 
        [2] = 7
    }, 
    [13] = {
        [1] = 5, 
        [2] = 8
    }, 
    [14] = {
        [1] = 7, 
        [2] = 8
    }, 
    [15] = {
        [1] = 3, 
        [2] = 4
    }
};
local function v149()
    -- upvalues: v13 (ref), v60 (ref), v116 (ref), v136 (ref)
    if v13.features.lagcomp_box.switch:get() and globals.is_in_game and globals.is_connected then
        for _, v138 in pairs(v60()) do
            local v139 = v116[v138:get_index()];
            if v139 and v139.alive and v139.lagcomp and not v139.shifting then
                local v140 = v138.m_vecMins + v139.extrapolated;
                local v141 = v138.m_vecMaxs + v139.extrapolated;
                local v142 = {
                    v140, 
                    vector(v140.x, v141.y, v140.z), 
                    vector(v141.x, v141.y, v140.z), 
                    vector(v141.x, v140.y, v140.z), 
                    vector(v140.x, v140.y, v141.z), 
                    vector(v140.x, v141.y, v141.z), 
                    v141, 
                    vector(v141.x, v140.y, v141.z)
                };
                if v139.origin:dist(v140) < 150 then
                    for v143, v144 in pairs(v136) do
                        if v143 == 1 then
                            local v145 = v139.origin:to_screen();
                            local v146 = v140:to_screen();
                            if v145 and v146 then
                                render.line(v145, v146, v13.features.lagcomp_box.color:get());
                            end;
                        end;
                        if v142[v144[1]] and v142[v144[2]] then
                            local v147 = v142[v144[1]]:to_screen();
                            local v148 = v142[v144[2]]:to_screen();
                            if v147 and v148 then
                                render.line(v147, v148, v13.features.lagcomp_box.color:get());
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
shifting_tickbase_flag = esp.enemy:new_text("Shifting Tickbase", "Shifting Tickbase", function(v150)
    -- upvalues: v116 (ref)
    if v116[v150:get_index()] and v116[v150:get_index()].shifting and not v116[v150:get_index()].lagcomp then
        return shifting_tickbase_combo:get();
    else
        return;
    end;
end);
shifting_tickbase_combo = shifting_tickbase_flag:create():combo("Flag Style", "Shifting Tickbase", "Shifting", "Tickbase", "Exploiting", "DT");
shifting_tickbase_label = shifting_tickbase_flag:create():label("Indicates if enemy is Shifting Tickbase"):disabled(true);
lagcomp_breaker_flag = esp.enemy:new_text("Lagcomp Breaker", "Lagcomp Breaker", function(v151)
    -- upvalues: v116 (ref)
    if v116[v151:get_index()] and v116[v151:get_index()].lagcomp then
        return lagcomp_breaker_combo:get();
    else
        return;
    end;
end);
lagcomp_breaker_combo = lagcomp_breaker_flag:create():combo("Flag Style", "Lagcomp Breaker", "LC Breaker", "Breaking LC", "Lagcomp", "LCB");
lagcomp_breaker_label = lagcomp_breaker_flag:create():label("Indicates if enemy is Breaking Lagcompensation"):disabled(true):disabled(true);
da_label = esp.enemy:new_text("Dormant Aimbot", "Dormant Aimbot", function(v152)
    -- upvalues: v7 (ref), v79 (ref)
    if not v7.dormant_aimbot:get() then
        return;
    elseif not v152:is_dormant() then
        return;
    else
        local v153 = entity.get_local_player();
        if not v153 or not v153:is_alive() then
            return;
        elseif v79(v153, v152) then
            return "DA";
        else
            return;
        end;
    end;
end):create():label("Indicates when enemy is hittable while dormant"):disabled(true);
local v162 = esp.enemy:new_text("Jumpshot", "Jumpshot", function(v154)
    -- upvalues: v7 (ref), v79 (ref)
    if ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get() then
        return;
    else
        local v155 = entity.get_local_player();
        if not v155 then
            return;
        else
            if not v154:is_visible() and not v154:is_dormant() and bit.band(v155.m_fFlags, 1) == 1 then
                local v156 = entity.get_local_player().m_vecVelocity:length2d();
                if (math.floor(v156) <= 5 or v7.slowwalk:get()) and not v79(v155, v154) then
                    local v157 = v155:get_hitbox_position(1);
                    local v158 = v154:get_hitbox_position(1);
                    local v159 = v154:get_hitbox_position(3);
                    local v160 = utils.trace_bullet(v155, v157 + vector(0, 0, 64), v158);
                    local v161 = utils.trace_bullet(v155, v157 + vector(0, 0, 64), v159);
                    if v160 >= 1 or v161 >= 1 then
                        return jumpshot_combo:get();
                    end;
                end;
            end;
            return;
        end;
    end;
end);
jumpshot_combo = v162:create():combo("Flag Style", "Jumpshot", "J-Shot", "Jump", "J");
jumpshot_label = v162:create():label("Indicates if enemy is only hittable with a jumpshot"):disabled(true);
local v171 = esp.enemy:new_text("Predicted Damage", "Predicted Damage", function(v163)
    -- upvalues: v53 (ref), v7 (ref), v35 (ref)
    if v163:is_dormant() then
        return;
    else
        local v164 = entity.get_local_player();
        if not v164 or not v164:is_alive() or not v163:is_alive() then
            return;
        else
            local v165 = v164:get_player_weapon();
            if not v165 then
                return;
            else
                local v166 = v165:get_weapon_index();
                local v167 = v53(v164, v163);
                if v167 > 0 then
                    local v168 = 1;
                    if predict_damage_with_dt:get() and v7.doubletap:get() and rage.exploit:get() == 1 then
                        local v169 = {
                            [1] = 1, 
                            [2] = 2, 
                            [3] = 3, 
                            [4] = 4, 
                            [5] = 30, 
                            [6] = 32, 
                            [7] = 36, 
                            [8] = 61, 
                            [9] = 63
                        };
                        if v35(v169, v166) then
                            v168 = 2;
                        end;
                    end;
                    local v170 = math.floor(v167 * v168 + 0.5);
                    if v163.m_iHealth <= v170 then
                        return "\aFFFFFFFF-" .. ("\a%02x%02x%02x%02x%s"):format(predict_damage_lethal_color:get().r, predict_damage_lethal_color:get().g, predict_damage_lethal_color:get().b, predict_damage_lethal_color:get().a, "") .. tostring(v170) .. "\aFFFFFFFF-";
                    else
                        return "\aFFFFFFFF-\aDEFAULT" .. tostring(v170) .. "\aFFFFFFFF-";
                    end;
                else
                    return;
                end;
            end;
        end;
    end;
end);
predict_damage_with_dt = v171:create():switch("Factor Pistols"):tooltip("\226\139\133 Multiply damage with doubletap for pistols");
predict_damage_lethal_color = v171:create():color_picker("Lethal Color", color(255, 100, 100, 255));
predict_damage_label = v171:create():label("Predicts the body damage of your current weapon"):disabled(true);
local v182 = esp.enemy:new_text("Stats", "Stats", function(v172)
    if stats_flag_dormant:get() and v172:is_dormant() then
        return;
    else
        local v173 = v172:get_resource();
        local l_m_iNumRoundKills_0 = v172.m_iNumRoundKills;
        local l_m_iKills_0 = v173.m_iKills;
        local l_m_iDeaths_0 = v173.m_iDeaths;
        local l_m_iMatchStats_HeadShotKills_Total_0 = v173.m_iMatchStats_HeadShotKills_Total;
        local v178 = {};
        if stats_flag_options:get(1) and stats_flag_kills_trigger:get() <= l_m_iNumRoundKills_0 then
            table.insert(v178, tostring(l_m_iNumRoundKills_0 .. "k"));
        end;
        if stats_flag_options:get(2) and l_m_iKills_0 > 0 then
            table.insert(v178, l_m_iKills_0 .. " Kills");
        end;
        if stats_flag_options:get(3) and l_m_iDeaths_0 > 0 then
            table.insert(v178, l_m_iDeaths_0 .. " Deaths");
        end;
        if stats_flag_options:get(4) and (l_m_iKills_0 > 0 or l_m_iDeaths_0 > 0) then
            local v179 = nil;
            if l_m_iDeaths_0 == 0 then
                v179 = "\226\136\158 KD";
            else
                local v180 = l_m_iKills_0 / l_m_iDeaths_0;
                v179 = string.format("%.2f", v180) .. " KD";
            end;
            table.insert(v178, v179);
        end;
        if stats_flag_options:get(5) and l_m_iMatchStats_HeadShotKills_Total_0 > 0 then
            local v181 = math.floor(math.clamp(l_m_iMatchStats_HeadShotKills_Total_0 * (100 / l_m_iKills_0), 0, 100) + 0.5);
            table.insert(v178, tostring(v181) .. " HS%");
        end;
        if #v178 == 0 then
            return "";
        else
            return table.concat(v178, "\n");
        end;
    end;
end);
stats_flag_options = v182:create():listable("", "Round kills", "Match kills", "Deaths", "KD ratio", "Headshot percentage");
stats_flag_kills_trigger = v182:create():slider("Trigger:", 1, 5, 2, 1, "k"):tooltip("\226\139\133 Set the kills at which the flag is triggered");
stats_flag_dormant = v182:create():switch("Disable if Dormant", true);
stats_label = v182:create():label("Indicates enemy scoreboard statistics"):disabled(true);
local v183 = {
    [1] = "accurate", 
    [2] = "shared", 
    [3] = "sounds", 
    [4] = "outdated", 
    [-1] = "accurate"
};
local v188 = esp.enemy:new_text("Dormancy State", "Dormancy State", function(v184)
    -- upvalues: v183 (ref)
    if not v184:is_dormant() then
        return;
    elseif dormancy_mode:get() == "Percentage" then
        local v185 = 60 + 40 * (1 - math.min(0.8, math.max(0, v184:get_bbox().alpha)) / 0.8);
        return "Dormant (" .. tostring(math.floor(v185 + 0.5)) .. "%)";
    elseif #dormancy_states_selected:get() == 0 then
        return;
    else
        for v186, v187 in pairs(v183) do
            if v186 == v184:get_network_state() and dormancy_states_selected:get(v187) then
                return v187;
            end;
        end;
        return;
    end;
end);
dormancy_mode = v188:create():combo("Mode", "Percentage", "States");
dormancy_states_selected = v188:create():listable("", "accurate", "shared", "sounds", "outdated");
dormancy_label = v188:create():label("Indicates enemy dormancy state"):disabled(true);
local v196 = esp.enemy:new_text("Grenades", "Grenades", function(v189)
    -- upvalues: v46 (ref)
    if better_nades_dormant:get() and v189:is_dormant() then
        return;
    else
        local v190 = unpack(better_nades_color:get("Frag"));
        local v191 = unpack(better_nades_color:get("Fire"));
        local v192 = unpack(better_nades_color:get("Smoke"));
        if better_nades_use_color:get() then
            if v189:is_dormant() then
                local v193 = v190:grayscale(1);
                local v194 = v191:grayscale(1);
                local v195 = v192:grayscale(1);
                he = ("\a%02x%02x%02x%02x%s"):format(v193.r, v193.g, v193.b, v193.a, "HE");
                ml = ("\a%02x%02x%02x%02x%s"):format(v194.r, v194.g, v194.b, v194.a, "ML");
                sm = ("\a%02x%02x%02x%02x%s"):format(v195.r, v195.g, v195.b, v195.a, "SM");
            else
                he = ("\a%02x%02x%02x%02x%s"):format(v190.r, v190.g, v190.b, v190.a, "HE");
                ml = ("\a%02x%02x%02x%02x%s"):format(v191.r, v191.g, v191.b, v191.a, "ML");
                sm = ("\a%02x%02x%02x%02x%s"):format(v192.r, v192.g, v192.b, v192.a, "SM");
            end;
        else
            he = "HE";
            ml = "ML";
            sm = "SM";
        end;
        if better_nades_vertical:get() then
            seperator = "\n";
        elseif not better_nades_vertical:get() then
            seperator = ("\a%02x%02x%02x%02x%s\aDEFAULT"):format(200, 200, 200, 255, "+");
        elseif not better_nades_vertical:get() and not better_nades_use_color:get() then
            seperator = "+";
        end;
        nades = "";
        if v46(v189, 44) and not v46(v189, 46) and not v46(v189, 48) and not v46(v189, 45) then
            nades = he;
        elseif not v46(v189, 44) and (v46(v189, 46) or v46(v189, 48)) and not v46(v189, 45) then
            nades = ml;
        elseif not v46(v189, 44) and not v46(v189, 46) and not v46(v189, 48) and v46(v189, 45) then
            nades = sm;
        elseif v46(v189, 44) and (v46(v189, 46) or v46(v189, 48)) and not v46(v189, 45) then
            nades = he .. seperator .. ml;
        elseif v46(v189, 44) and not v46(v189, 46) and not v46(v189, 48) and v46(v189, 45) then
            nades = he .. seperator .. sm;
        elseif not v46(v189, 44) and (v46(v189, 46) or v46(v189, 48)) and v46(v189, 45) then
            nades = ml .. seperator .. sm;
        elseif v46(v189, 44) and (v46(v189, 46) or v46(v189, 48)) and v46(v189, 45) then
            nades = he .. seperator .. ml .. seperator .. sm;
        end;
        return nades;
    end;
end);
better_nades_use_color = v196:create():switch("Use Custom Color"):tooltip("\226\139\133 Set custom colors for each grenade");
better_nades_color = better_nades_use_color:color_picker({
    Frag = {
        color(255, 223, 187, 255)
    }, 
    Fire = {
        color(255, 182, 182, 255)
    }, 
    Smoke = {
        color(177, 211, 255, 255)
    }
});
better_nades_vertical = v196:create():switch("Vertical");
better_nades_dormant = v196:create():switch("Disable if Dormant", false);
better_nades_label = v196:create():label("Indicates enemy grenades in text style"):disabled(true);
local v203 = esp.enemy:new_text("Lethal", "Lethal", function(v197)
    -- upvalues: v46 (ref)
    if lethal_dormant:get() and v197:is_dormant() then
        return;
    else
        local v198 = entity.get_local_player();
        if not v198 then
            return;
        else
            if lethal_scout_check:get() == "Holding" then
                local v199 = v198:get_player_weapon();
                if v199 and v199:get_weapon_index() ~= 40 then
                    return;
                end;
            elseif lethal_scout_check:get() == "Inventory" and not v46(v198, 40) then
                return;
            end;
            if v197:is_alive() then
                local v200 = v198:get_origin():dist((v197:get_hitbox_position(3)));
                local v201 = (v197.m_ArmorValue == 0 and 88 or 74.800002098083) * 1.24;
                local v202 = 0.98000001907349 ^ (v200 / 500);
                if math.floor(v201 * v202 + 0.5) >= v197.m_iHealth then
                    return lethal_combo:get();
                end;
            end;
            return;
        end;
    end;
end);
lethal_scout_check = v203:create():combo("Scout Check", "Disabled", "Holding", "Inventory");
lethal_combo = v203:create():combo("Flag Style", "Lethal", "Baim", "Baimable", "FBP+", "L");
lethal_dormant = v203:create():switch("Disable if Dormant", true);
lethal_label = v203:create():label("Indicates if enemy is lethal"):disabled(true);
local v210 = esp.enemy:new_text("Knifeable", "Knifeable", function(v204)
    if v204:is_dormant() then
        return;
    else
        if knife_only_show_on_knife:get() then
            local v205 = entity.get_local_player();
            if not v205 then
                return;
            else
                local v206 = v205:get_player_weapon();
                if not v206 then
                    return;
                else
                    local v207 = v206:get_weapon_info();
                    if not v207 then
                        return;
                    elseif v207.weapon_type ~= 0 or v207.damage ~= 50 then
                        return;
                    end;
                end;
            end;
        end;
        local v208 = 34;
        local v209 = 55;
        if v204.m_iHealth <= v208 or v204.m_iHealth <= v209 then
            return "Knifeable";
        else
            return;
        end;
    end;
end);
knife_only_show_on_knife = v210:create():switch("Only show on knife");
knife_label = v210:create():label("Indicates if enemy can be killed in 1 knife hit (ignores backstabbing)"):disabled(true);
local v217 = esp.enemy:new_text("Bomb Information", "Bomb", function(v211)
    -- upvalues: l_information_0 (ref), v46 (ref)
    if bomb_options:get("Planting") and l_information_0.state == 1 and l_information_0.planter == v211 then
        local _, v213 = l_information_0:get_plant_duration();
        return "Planting: " .. tostring(math.floor(v213 + 0.5)) .. "%";
    elseif bomb_options:get("Defuse") and l_information_0.state == 3 and v211.m_bIsDefusing then
        if l_information_0:can_defuse(v211) then
            local _, v215 = l_information_0:get_defuse_duration();
            return "Defusing: " .. tostring(math.floor(v215 + 0.5)) .. "%";
        else
            return "Defusing: no time";
        end;
    elseif bomb_options:get("Carry") and (v211 == entity.get(v211:get_resource().m_iPlayerC4) or v46(v211, 49)) then
        return bomb_carry_style:get();
    else
        if bomb_options:get("Damage") and l_information_0.state == 2 then
            if v211:is_dormant() then
                return;
            else
                local v216 = l_information_0:calculate_damage(v211);
                if v216 > 0 then
                    if v211.m_iHealth <= v216 then
                        return l_information_0.site .. ": Fatal";
                    elseif not bomb_only_fatal:get() then
                        return l_information_0.site .. ": -" .. v216;
                    end;
                end;
            end;
        end;
        return;
    end;
end);
bomb_carry_style = v217:create():combo("Flag Style", "C4", "Bomb", "B", v12.bomb);
bomb_options = v217:create():listable("", "Carry", "Planting", "Defuse", "Damage");
bomb_only_fatal = v217:create():switch("Only show fatal damage");
bomb_label = v217:create():label("Indicates the selected bomb information"):disabled(true);
local v219 = esp.enemy:new_text("Money", "Money", function(v218)
    if v218:is_dormant() then
        return;
    else
        return (money_color:get() and "\a66A012FF" or "") .. "$" .. v218.m_iAccount;
    end;
end):create();
money_color = v219:switch("Use Gamesense Color", true);
money_label = v219:label("Indicates enemy money in gamesense style"):disabled(true);
local v223 = esp.enemy:new_text("Hostage", "Hostage", function(v220)
    if hostage_dormant:get() and v220:is_dormant() then
        return;
    elseif hostage_res_combo:get() ~= "\aB6B665FFDisabled" and v220.m_bIsGrabbingHostage then
        local v221 = v220:is_dormant() and color(255, 30, 30, 255):grayscale(1) or color(255, 30, 30, 255);
        return ("\a%02x%02x%02x%02x"):format(v221.r, v221.g, v221.b, v221.a) .. hostage_res_combo:get();
    elseif hostage_carry_combo:get() ~= "\aB6B665FFDisabled" and v220.m_bIsRescuing then
        local v222 = v220:is_dormant() and color(255, 30, 30, 255):grayscale(1) or color(255, 30, 30, 255);
        return ("\a%02x%02x%02x%02x"):format(v222.r, v222.g, v222.b, v222.a) .. hostage_carry_combo:get();
    else
        return;
    end;
end);
hostage_res_combo = v223:create():combo("Rescuing", "\aB6B665FFDisabled", "Rescuing", "Rescue", "VIP", "Hostage", "Host");
hostage_res_color = hostage_res_combo:color_picker(color(255, 180, 100, 255));
hostage_carry_combo = v223:create():combo("Carrying", "\aB6B665FFDisabled", "Carrying", "Carry", "Saving", "VIP", "Hostage", "Host");
hostage_carry_color = hostage_carry_combo:color_picker(color(255, 100, 100, 255));
hostage_dormant = v223:create():switch("Disable if Dormant");
hostage_label = v223:create():label("Indicates if enemy is carrying/rescuing the hostage"):disabled(true);
local v224 = {
    [1] = {
        [1] = 128512, 
        [2] = 128591
    }, 
    [2] = {
        [1] = 127744, 
        [2] = 128511
    }, 
    [3] = {
        [1] = 128640, 
        [2] = 128767
    }, 
    [4] = {
        [1] = 9728, 
        [2] = 9983
    }, 
    [5] = {
        [1] = 9984, 
        [2] = 10175
    }, 
    [6] = {
        [1] = 65024, 
        [2] = 65039
    }, 
    [7] = {
        [1] = 129280, 
        [2] = 129535
    }, 
    [8] = {
        [1] = 127462, 
        [2] = 127487
    }, 
    [9] = {
        [1] = 917536, 
        [2] = 917631
    }
};
local function v235(v225)
    -- upvalues: v224 (ref)
    local v226 = {};
    local v227 = 1;
    while v227 <= #v225 do
        local v228 = v225:byte(v227);
        local v229 = 1;
        if v228 >= 240 then
            v229 = 4;
        elseif v228 >= 224 then
            v229 = 3;
        elseif v228 >= 192 then
            v229 = 2;
        end;
        local l_v228_0 = v228;
        if v229 > 1 then
            l_v228_0 = bit.band(v228, 7);
            for v231 = 1, v229 - 1 do
                l_v228_0 = bit.bor(bit.lshift(l_v228_0, 6), bit.band(v225:byte(v227 + v231), 63));
            end;
        end;
        local v232 = false;
        for _, v234 in ipairs(v224) do
            if v234[1] <= l_v228_0 and l_v228_0 <= v234[2] then
                v232 = true;
                break;
            end;
        end;
        table.insert(v226, v232 and "?" or v225:sub(v227, v227 + v229 - 1));
        v227 = v227 + v229;
    end;
    return table.concat(v226);
end;
clear_name_flag_label = esp.enemy:new_text("Name", "Name", function(v236)
    -- upvalues: v235 (ref), v38 (ref)
    local v237 = v236:get_name();
    local v238 = v235(v237);
    return (v38(v238, 30));
end):create():label("Indicates enemy name without emojis"):disabled(true);
local v243 = esp.self:new_text("Low Ammo Warning", "Low Ammo", function(v239)
    -- upvalues: v12 (ref)
    local v240 = v239:get_player_weapon();
    if v240 and v240.m_iPrimaryReserveAmmoCount ~= 0 and v240:get_weapon_reload() == -1 then
        local l_m_iClip1_0 = v240.m_iClip1;
        if l_m_iClip1_0 <= 2 then
            local v242 = self_reload_warning_style:get();
            if self_reload_warning_options:get(2) then
                v242 = v242 .. " (" .. tostring(l_m_iClip1_0) .. ")";
            end;
            if self_reload_warning_options:get(1) then
                v242 = (l_m_iClip1_0 == 0 and v12["gun-slash"] or v12.gun) .. "  " .. v242;
            end;
            return v242;
        end;
    end;
end);
self_reload_warning_style = v243:create():combo("Flag Style:", "Low Ammo", "Reload Warning", "Reload needed soon", "Reload", "Ammo");
self_reload_warning_options = v243:create():listable("Options", "Show Icon", "Show Ammo"):tooltip("\226\139\133 Select additional Flag options:" .. "\n\n" .. "\226\136\153 Show Icon: Shows an Icon infront of Flag name." .. "\n\n" .. "\226\136\153 Show Ammo: Indicates how much ammo your weapon has left, before you have to reload");
self_reload_warning_label = v243:create():label("If possible, indicates if weapon will need a reload soon"):disabled(true);
self_lethal_warning_label = esp.self:new_text("Lethal Warning", "Lethal", function(v244)
    if v244.m_iHealth < 92 or v244.m_ArmorValue == 0 then
        return "Lethal";
    else
        return;
    end;
end):create():label("Indicates if you are baimable"):disabled(true);
local v245 = {};
local v246 = {
    [1] = 330, 
    [2] = 302, 
    [3] = 282, 
    [4] = 268, 
    [5] = 256, 
    [6] = 245, 
    [7] = 238, 
    [8] = 229, 
    [9] = 223, 
    [10] = 216, 
    [11] = 210, 
    [12] = 205, 
    [13] = 199, 
    [14] = 195, 
    [15] = 188, 
    [16] = 184, 
    [17] = 179, 
    [18] = 175, 
    [19] = 171, 
    [20] = 167, 
    [21] = 163, 
    [22] = 159, 
    [23] = 154, 
    [24] = 151, 
    [25] = 147, 
    [26] = 144, 
    [27] = 140, 
    [28] = 136, 
    [29] = 133, 
    [30] = 128, 
    [31] = 126, 
    [32] = 123, 
    [33] = 119, 
    [34] = 115, 
    [35] = 111, 
    [36] = 109, 
    [37] = 105, 
    [38] = 102, 
    [39] = 97, 
    [40] = 94, 
    [41] = 90, 
    [42] = 87, 
    [43] = 83, 
    [44] = 79, 
    [45] = 75, 
    [46] = 70, 
    [47] = 67, 
    [48] = 62, 
    [49] = 57, 
    [50] = 52, 
    [51] = 47, 
    [52] = 40, 
    [53] = 33, 
    [54] = 23, 
    [55] = 7, 
    [56] = 2
};
local v247 = {
    [1] = 347, 
    [2] = 323, 
    [3] = 304, 
    [4] = 298, 
    [5] = 286, 
    [6] = 279, 
    [7] = 272, 
    [8] = 265, 
    [9] = 254, 
    [10] = 247, 
    [11] = 240, 
    [12] = 235, 
    [13] = 232, 
    [14] = 228, 
    [15] = 224, 
    [16] = 222, 
    [17] = 218, 
    [18] = 214, 
    [19] = 209, 
    [20] = 205, 
    [21] = 201, 
    [22] = 198, 
    [23] = 198, 
    [24] = 194, 
    [25] = 191, 
    [26] = 187, 
    [27] = 183, 
    [28] = 181, 
    [29] = 180, 
    [30] = 180, 
    [31] = 177, 
    [32] = 171, 
    [33] = 166, 
    [34] = 165, 
    [35] = 159, 
    [36] = 159, 
    [37] = 157, 
    [38] = 154, 
    [39] = 154, 
    [40] = 151, 
    [41] = 146, 
    [42] = 148, 
    [43] = 143, 
    [44] = 143, 
    [45] = 141, 
    [46] = 136, 
    [47] = 137, 
    [48] = 134, 
    [49] = 133, 
    [50] = 131, 
    [51] = 127, 
    [52] = 126, 
    [53] = 124, 
    [54] = 118, 
    [55] = 119, 
    [56] = 116, 
    [57] = 113, 
    [58] = 111, 
    [59] = 108, 
    [60] = 107, 
    [61] = 106, 
    [62] = 102, 
    [63] = 104, 
    [64] = 100, 
    [65] = 96, 
    [66] = 92, 
    [67] = 90, 
    [68] = 89, 
    [69] = 85, 
    [70] = 81, 
    [71] = 77, 
    [72] = 73, 
    [73] = 70, 
    [74] = 66, 
    [75] = 62, 
    [76] = 58, 
    [77] = 55, 
    [78] = 51, 
    [79] = 47, 
    [80] = 43, 
    [81] = 38, 
    [82] = 35, 
    [83] = 31, 
    [84] = 24, 
    [85] = 24, 
    [86] = 16, 
    [87] = 16, 
    [88] = 16, 
    [89] = 16, 
    [90] = 16, 
    [91] = 16, 
    [92] = 16, 
    [93] = 16
};
local v250 = esp.self:new_text("Grenade Warning", "Grenade Warning", function(v248)
    -- upvalues: v245 (ref), v12 (ref)
    if v245.type ~= "Frag" or not v245.damage or v245.expire_time <= globals.curtime then
        return;
    elseif v245.damage >= v248.m_iHealth then
        local v249 = self_nade_warning_style:get();
        if self_nade_warning_options:get(1) then
            v249 = v12.bomb .. "  " .. v249;
        end;
        if self_nade_warning_options:get(2) then
            v249 = v249 .. " (-" .. v245.damage .. ")";
        end;
        return v249;
    else
        return;
    end;
end);
self_nade_warning_style = v250:create():combo("Flag Style:", "Grenade Warning", "Incoming Grenade", "Lethal Grenade", "Nade", "Warning", "Dangerous");
self_nade_warning_options = v250:create():listable("Options", "Show Icon", "Show Damage", "Lethal Tracers", "Lethal Radius"):tooltip("\226\136\153 Show Icon: Shows an Icon infront of Flag name \n\n\226\136\153 Show Damage: Indicates how much damage the incoming HE-Grenade deals. \n\n\226\136\153 Lethal Tracers: Show tracers to lethal HE-\n\n\226\136\153 Lethal Radius: Show 3D lethal radius of HE-Grenades");
self_nade_warning_options_colors = self_nade_warning_options:color_picker({
    ["Lethal Tracers"] = {
        color(255, 160, 100, 255)
    }, 
    ["Lethal Radius"] = {
        color(255, 160, 100, 80)
    }
});
self_nade_warning_label = v250:create():label("Indicates if you are lethal to incoming grenades"):disabled(true);
local function v252()
    -- upvalues: v250 (ref), v245 (ref)
    if not v250:get() or not self_nade_warning_options:get(3) then
        return;
    elseif v245.type ~= "Frag" or not v245.damage or v245.expire_time <= globals.curtime then
        return;
    else
        local v251 = entity.get_local_player();
        if not v251 or not v251:is_alive() or v245.damage <= v251.m_iHealth or not common.is_in_thirdperson() then
            return;
        else
            render.line(entity.get_local_player():get_hitbox_position(3):to_screen(), v245.closest_point:to_screen(), unpack(self_nade_warning_options_colors:get("Lethal Tracers")));
            return;
        end;
    end;
end;
local function v260()
    -- upvalues: v250 (ref), v245 (ref), v247 (ref), v246 (ref)
    if not v250:get() or not self_nade_warning_options:get(4) then
        return;
    else
        local v253 = entity.get_local_player();
        if not v253 or not v253:is_alive() then
            return;
        else
            if v245.type == "Frag" and v245.damage and v245.expire_time >= globals.curtime then
                local v254 = v245.path[#v245.path];
                if v253:get_origin():dist(v254) < 1000 then
                    local v255 = v253.m_ArmorValue == 0 and v247[v253.m_iHealth + 1] or v246[v253.m_iHealth + 1] or nil;
                    if not v255 then
                        return;
                    else
                        for v256 = 0, 180, 6 do
                            local v257 = v255 * math.sin(math.rad(v256));
                            local v258 = v255 * math.cos(math.rad(v256));
                            local v259 = v254 + vector(0, 0, v258);
                            render.circle_3d_outline(v259, unpack(self_nade_warning_options_colors:get("Lethal Radius")), v257, 0, 1, 5);
                        end;
                    end;
                end;
            end;
            return;
        end;
    end;
end;
local v265 = esp.self:new_text("Slowed Down", "Slowed", function(v261)
    -- upvalues: v12 (ref)
    local l_m_flVelocityModifier_0 = v261.m_flVelocityModifier;
    if l_m_flVelocityModifier_0 < 1 then
        local v263 = math.floor(100 - l_m_flVelocityModifier_0 * 100 + 0.5);
        local v264 = self_slowed_down_style:get();
        if self_slowed_down_options:get(1) then
            v264 = v12["gauge-low"] .. "  " .. v264;
        end;
        if self_slowed_down_options:get(2) then
            v264 = v264 .. " (" .. tostring(v263) .. "%)";
        end;
        return v264;
    else
        return;
    end;
end);
self_slowed_down_style = v265:create():combo("Style", "Slowed", "Slowed Down", "Slow", "S");
self_slowed_down_options = v265:create():listable("Options", "Show Icon", "Show Percentage"):tooltip("\226\139\133 Select additional Flag options: \n\n\226\136\153 Show Icon: Shows an Icon infront of Flag name\n\n\226\136\153 Show Percentage: indicates the slowed down percentage");
self_slowed_down_label = v265:create():label("Indicates if your movement speed is slowed down"):disabled(true);
local v266 = esp.enemy:new_item("Safepoints");
local v267 = v266:create():color_picker("Color", color(102, 216, 102, 255));
local _ = v266:create():label("Indicates the ragebot safepoints, behaves similar to the NL Hitboxes Visualizer." .. "\n\n" .. v8.yellow .. v12["triangle-exclamation"] .. "  This feature requires intensive processing. Enabling it may lead to lower FPS."):disabled(true);
local v269 = {
    Head = {
        [1] = 0
    }, 
    Chest = {
        [1] = 4
    }, 
    Stomach = {
        [1] = 3
    }, 
    Arms = {
        [1] = 15, 
        [2] = 17
    }, 
    Legs = {
        [1] = 7, 
        [2] = 8
    }, 
    Feet = {
        [1] = 9, 
        [2] = 10
    }
};
local function v276()
    -- upvalues: v266 (ref), v7 (ref), v269 (ref), v267 (ref), v79 (ref)
    if not v266:get() then
        return;
    elseif not v7.ragebot:get() then
        return;
    else
        local v270 = entity.get_local_player();
        if not v270 then
            return;
        elseif v270.m_nRenderMode == 2048 then
            return;
        elseif not v270:is_alive() then
            return;
        else
            local v271 = v270:get_player_weapon();
            if not v271 then
                return;
            elseif v271.m_iClip1 < 1 then
                return;
            else
                for _, v273 in pairs(entity.get_players(true)) do
                    if v273 and v273:is_alive() and not v273:is_dormant() then
                        for _, v275 in pairs(ui.find("Aimbot", "Ragebot", "Safety", "Ensure Hitbox Safety"):get()) do
                            if v271:get_index() == 31 then
                                if v273:is_visible() and v270:get_origin():dist(v273:get_origin()) < 180 then
                                    render.highlight_hitbox(v273, v269[v275], v267:get());
                                end;
                            elseif v79(v270, v273, v269[v275]) then
                                render.highlight_hitbox(v273, v269[v275], v267:get());
                            end;
                        end;
                    end;
                end;
                return;
            end;
        end;
    end;
end;
local function v277()
    -- upvalues: v13 (ref)
    if not globals.is_in_game or not globals.is_connected then
        return;
    else
        cvar.glow_outline_effect_enable:int(v13.features.esp_corrections:get("Spectator Glow") and 0 or 1, true);
        return;
    end;
end;
local function v278()
    -- upvalues: v13 (ref), v5 (ref), v4 (ref)
    if v13.features.esp_corrections:get("Chams Color") then
        cvar.mat_autoexposure_max_multiplier:float(0, true);
        v5 = false;
    elseif not v5 then
        cvar.mat_autoexposure_max_multiplier:float(v4 or 1, true);
        v5 = true;
    end;
end;
local function v280()
    -- upvalues: v13 (ref), v35 (ref), v7 (ref)
    if v13.features.esp_corrections:get("Weapon Chams") then
        local v279 = entity.get_local_player();
        if not v279 then
            return;
        elseif v279.m_iObserverMode ~= 6 and v35(entity.get_players(true), v279.m_hObserverTarget) then
            v7.enemy_weapon_chams:override(false);
        else
            v7.enemy_weapon_chams:override();
        end;
    end;
end;
local function v291()
    -- upvalues: v13 (ref), v7 (ref), v60 (ref)
    if v13.features.oof_arrows.switch:get() then
        v7.oof_arrows:override(false);
        for _, v282 in pairs(v60()) do
            if v282:is_alive() then
                local l_show_dormancy_0 = v13.features.oof_arrows.show_dormancy;
                local v284 = v282:is_dormant();
                if v284 and not l_show_dormancy_0 then
                    return;
                elseif v282:get_network_state() ~= 5 then
                    local v285, v286, v287 = render.get_offscreen(v282:get_origin(), v13.features.oof_arrows.radius:get() / 100);
                    if v287 then
                        local v288 = v13.features.oof_arrows.color:get();
                        v288.a = (l_show_dormancy_0 and v284 and v282:get_bbox().alpha or v13.features.oof_arrows.arrow_pulse:get() and math.clamp(math.sin(math.abs(-math.pi + globals.curtime * 1.4285714285714286 % (math.pi * 2))), 0.12, 1) or 1) * v288.a;
                        local v289 = {
                            a = v285 + vector(-10, -10), 
                            b = v285 + vector(-10, 10), 
                            c = v285 + vector(10, 0)
                        };
                        local v290 = v286 - render.camera_angles().y + 180;
                        render.push_rotation(v290);
                        render.poly(l_show_dormancy_0 and v284 and v288:grayscale(1) or v288, v289.a, v289.b, v289.c);
                        render.pop_rotation();
                    end;
                end;
            end;
        end;
    else
        v7.oof_arrows:override();
    end;
end;
local v292 = {
    Small = 2, 
    Default = 1, 
    Console = 3
};
local v293 = {};
local function v298()
    -- upvalues: v13 (ref), v293 (ref)
    if not v13.features.last_dormant_position.switch:get() then
        return;
    else
        for _, v295 in pairs(entity.get_players(true, true)) do
            if v295 ~= entity.get_local_player() then
                local v296 = v295:get_index();
                if v295:is_alive() then
                    local v297 = v295:get_network_state();
                    v293[v296] = v293[v296] or {};
                    v293[v296].index = v296;
                    v293[v296].network_state = v297;
                    if v297 ~= 5 then
                        v293[v296].ent = v295;
                        v293[v296].name = v295:get_name();
                        v293[v296].alive = v295:is_alive();
                        v293[v296].origin = v295:get_origin():clone();
                        v293[v296].hp = v295.m_iHealth;
                        v293[v296].place = #v295.m_szLastPlaceName > 1 and v295.m_szLastPlaceName or "unknown";
                    end;
                else
                    v293[v296] = nil;
                end;
            end;
        end;
        return;
    end;
end;
local function v327()
    -- upvalues: v13 (ref), v293 (ref), v35 (ref), v235 (ref), v38 (ref), v7 (ref), v292 (ref)
    if not v13.features.last_dormant_position.switch:get() then
        return;
    else
        local v299 = entity.get_local_player();
        if not v299 then
            return;
        elseif not v299:is_alive() then
            return;
        else
            for _, v301 in pairs(v293) do
                do
                    local l_v301_0 = v301;
                    if l_v301_0.alive and l_v301_0.network_state == 5 then
                        local v303 = entity.get_players();
                        if not v35(v303, l_v301_0.ent) then
                            v293[l_v301_0.index] = nil;
                            return;
                        else
                            local l_origin_0 = l_v301_0.origin;
                            local v306 = utils.trace_line(render.camera_position(), vector(l_origin_0.x, l_origin_0.y, l_origin_0.z + 50), function(v305)
                                -- upvalues: l_v301_0 (ref)
                                return v305 == l_v301_0.ent;
                            end);
                            if v306 and v306:is_visible() then
                                v293[l_v301_0.index] = nil;
                                return;
                            else
                                local v307 = v13.features.last_dormant_position.font:get();
                                local v308 = v13.features.last_dormant_position.color:get();
                                local v309 = v235(string.upper(v38(l_v301_0.name, 20)));
                                if v13.features.last_dormant_position.show_offscreen:get() then
                                    local v310, v311, v312 = render.get_offscreen(l_v301_0.origin, (v13.features.oof_arrows.switch:get() and v13.features.oof_arrows.radius:get() or v7.oof_arrows:get() and math.clamp(v7.oof_arrows_radius:get(), 0, 95) or 33) / 100);
                                    if v312 then
                                        local v313 = v310 - vector(10, 14);
                                        local v314 = v310 + vector(10, 14);
                                        if v13.features.last_dormant_position.style:get() == "Gamesense" then
                                            render.text(v292[v307], vector(v314.x + 4, v313.y - 2), v308, nil, "LAST SEEN\n" .. v309);
                                        else
                                            render.text(v292[v307], v310 - vector(0, 23), v308, "c", v309);
                                            local v315 = l_v301_0.hp == 0 and 100 or l_v301_0.hp;
                                            local v316 = v315 * 0.01;
                                            render.rect(vector(v313.x - 7, v313.y), vector(v313.x - 5, v314.y), color(0, 0, 0, math.clamp(v308.a, 0, 125)));
                                            render.rect(vector(v313.x - 7, v314.y - (v314.y - v313.y) * v316), vector(v313.x - 5, v314.y), v308);
                                            render.rect_outline(vector(v313.x - 8, v313.y - 1), vector(v313.x - 4, v314.y + 1), color(0, 0, 0, math.clamp(v308.a, 0, 175)));
                                            if v315 <= 92 then
                                                render.text(2, vector(v313.x - 4, v314.y - (v314.y - v313.y) * v316 - 3), v308, "c", tostring(v315));
                                            end;
                                        end;
                                        local v317 = {
                                            a = v310 + vector(-10, -10), 
                                            b = v310 + vector(-10, 10), 
                                            c = v310 + vector(10, 0)
                                        };
                                        local v318 = v311 - render.camera_angles().y + 180;
                                        render.push_rotation(v318);
                                        render.poly(v308, v317.a, v317.b, v317.c);
                                        render.pop_rotation();
                                    end;
                                end;
                                local v319 = vector(l_origin_0.x, l_origin_0.y, l_origin_0.z + 100):to_screen();
                                local v320 = l_origin_0:to_screen();
                                if v319 and v320 then
                                    local v321 = v320.y - v319.y;
                                    local v322 = v321 * 0.3;
                                    local v323 = v319.x - v322;
                                    local v324 = v319.x + v322;
                                    render.rect_outline(vector(v323 + 1, v319.y + 1), vector(v324 - 1, v320.y - 1), color(0, 0, 0, math.clamp(v308.a, 0, 175)));
                                    render.rect_outline(vector(v323 - 1, v319.y - 1), vector(v324 + 1, v320.y + 1), color(0, 0, 0, math.clamp(v308.a, 0, 175)));
                                    render.rect_outline(vector(v323, v319.y), vector(v324, v320.y), v308);
                                    if v13.features.last_dormant_position.style:get() == "Gamesense" then
                                        render.text(v292[v307], vector(v324 + 1, v319.y - 2), v308, nil, "LAST SEEN \n" .. v309);
                                    else
                                        local v325 = l_v301_0.hp == 0 and 100 or l_v301_0.hp;
                                        local v326 = v325 * 0.01;
                                        render.rect(vector(v323 - 6, v319.y - 1), vector(v323 - 2, v320.y + 1), color(0, 0, 0, math.clamp(v308.a, 0, 100)));
                                        render.rect_outline(vector(v323 - 6, v319.y - 1), vector(v323 - 2, v320.y + 1), color(0, 0, 0, math.clamp(v308.a, 0, 100)));
                                        render.rect(vector(v323 - 5, v320.y - v321 * v326), vector(v323 - 3, v320.y), v308);
                                        render.text(v292[v307], vector(v319.x, v319.y - 7), v308, "c", v309);
                                        render.text(v292[v307], vector((v323 + v324) / 2, v320.y + 6), v308, "c", string.upper(l_v301_0.place));
                                        if v325 <= 92 then
                                            render.text(v292[v307], vector(v323 - 4, v320.y - 2 - v321 * v326), v308, "c", v325);
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            return;
        end;
    end;
end;
local v328 = {
    blue = false, 
    downloaded = false, 
    yellow = false
};
local function v329()
    -- upvalues: v6 (ref), l_manager_0 (ref), v328 (ref)
    files.create_folder(v6 .. "/materials");
    if not l_manager_0.exists(v6 .. "/materials/thunder.png") then
        l_manager_0.download("https://gitlab.com/mogel/misc/-/raw/main/thunder.png?inline=false", v6 .. "/materials/thunder.png");
    end;
    v328.downloaded = true;
end;
local function v338(v330)
    -- upvalues: v13 (ref)
    if not v330:get_bbox().pos1 or not v330:get_bbox().pos2 then
        return;
    else
        if v13.features.zeus_warning.position:get() == "Left" then
            pre_position = vector(v330:get_bbox().pos1.x - 20, v330:get_bbox().pos1.y);
        elseif v13.features.zeus_warning.position:get() == "Above" then
            local v331 = render.measure_text(1, "s", "x");
            local l_pos1_0 = v330:get_bbox().pos1;
            local v333 = vector(v330:get_bbox().pos2.x, v330:get_bbox().pos1.y);
            local v334 = vector(l_pos1_0.x - v333.x, l_pos1_0.y - v333.y):length();
            local v335 = vector(v330:get_bbox().pos1.x + v334 / 2, v330:get_bbox().pos1.y);
            local v336 = v330:get_bbox().pos1.y - v331.y;
            local v337 = vector(v335.x, v336 - v331.y * 2 - 2);
            pre_position = vector(v337.x - v331.x, v337.y + 10);
        elseif v13.features.zeus_warning.position:get() == "Right" then
            pre_position = vector(v330:get_bbox().pos2.x, v330:get_bbox().pos1.y);
        end;
        return pre_position;
    end;
end;
local function v343()
    -- upvalues: v13 (ref), v328 (ref), v329 (ref), v6 (ref), v60 (ref), v46 (ref), v338 (ref)
    if not v13.features.zeus_warning.switch:get() then
        return;
    else
        if v13.features.zeus_warning.style:get() == "Gamesense" and not v328.yellow then
            v328.yellow = render.load_image("<svg id=\"svg\" version=\"1.1\" width=\"608\" height=\"689\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" ><g id=\"svgg\"><path id=\"path0\" d=\"M185.803 18.945 C 184.779 19.092,182.028 23.306,174.851 35.722 C 169.580 44.841,157.064 66.513,147.038 83.882 C 109.237 149.365,100.864 163.863,93.085 177.303 C 88.686 184.901,78.772 202.072,71.053 215.461 C 63.333 228.849,53.959 245.069,50.219 251.505 C 46.480 257.941,43.421 263.491,43.421 263.837 C 43.421 264.234,69.566 264.530,114.025 264.635 L 184.628 264.803 181.217 278.618 C 179.342 286.217,174.952 304.128,171.463 318.421 C 167.974 332.714,160.115 364.836,153.999 389.803 C 147.882 414.770,142.934 435.254,143.002 435.324 C 143.127 435.452,148.286 428.934,199.343 364.145 C 215.026 344.243,230.900 324.112,234.619 319.408 C 238.337 314.704,254.449 294.276,270.423 274.013 C 286.397 253.750,303.090 232.582,307.519 226.974 C 340.870 184.745,355.263 166.399,355.263 166.117 C 355.263 165.937,323.554 165.789,284.798 165.789 C 223.368 165.789,214.380 165.667,214.701 164.831 C 215.039 163.949,222.249 151.366,243.554 114.474 C 280.604 50.317,298.192 19.768,298.267 19.444 C 298.355 19.064,188.388 18.576,185.803 18.945 \" stroke=\"none\" fill=\"#FFFFFFFF\" fill-rule=\"evenodd\"></path></g></svg>", vector(20, 40));
        end;
        if v13.features.zeus_warning.style:get() == "Thunder" and not v328.blue then
            if not v328.downloaded then
                v329();
            end;
            v328.blue = render.load_image_from_file(v6 .. "/materials/thunder.png", vector(20, 20));
        end;
        local v339 = v13.features.zeus_warning.style:get() == "Gamesense" and v328.yellow or v328.blue;
        for _, v341 in pairs(v60()) do
            if not v341:is_dormant() then
                local v342 = v341:get_player_weapon();
                if v342 and v341:get_bbox().pos1 and v341:get_bbox().pos1 and v46(v341, 31) then
                    render.texture(v339, v338(v341), vector(20, 20), v13.features.zeus_warning.style:get() == "Gamesense" and (v342:get_weapon_index() == 31 and unpack(v13.features.zeus_warning.colors:get("Holding")) or unpack(v13.features.zeus_warning.colors:get("Inventory")) or nil));
                end;
            end;
        end;
        return;
    end;
end;
local function v345(v344)
    -- upvalues: l_result_0 (ref), v13 (ref)
    if not l_result_0 then
        return;
    else
        l_result_0.m_nType = 0;
        l_result_0.m_pszModelName = "sprites/purplelaser1.vmt";
        l_result_0.m_nModelIndex = -1;
        l_result_0.m_pszHaloName = "sprites/purplelaser1.vmt";
        l_result_0.m_nHaloIndex = -1;
        l_result_0.m_flHaloScale = 0;
        l_result_0.m_flLife = 0.85;
        l_result_0.m_flWidth = 7;
        l_result_0.m_flFadeLength = 0;
        l_result_0.m_flAmplitude = 0;
        l_result_0.m_flSpeed = 0;
        l_result_0.m_nStartFrame = 0;
        l_result_0.m_flFrameRate = 0;
        l_result_0.m_color = v13.features.beam_sound_esp.color:get();
        l_result_0.m_nSegments = 0;
        l_result_0.m_bRenderable = true;
        l_result_0.m_nFlags = 8;
        l_result_0.m_vecCenter = v344:get_origin() + vector(0, 0, 5);
        l_result_0.m_flStartRadius = 20;
        l_result_0.m_flEndRadius = 700;
        l_result_0.create_beam_ring_point();
        return;
    end;
end;
local v346 = {};
local v347 = {};
local function v352()
    -- upvalues: v13 (ref), v60 (ref), v346 (ref), v347 (ref), v345 (ref)
    if not v13.features.beam_sound_esp.switch:get() then
        return;
    else
        for _, v349 in pairs(v60()) do
            if not v349:is_dormant() and v349:is_alive() then
                local v350 = v349:get_index();
                if v346[v350] == nil then
                    v346[v350] = v349.m_flLastMadeNoiseTime;
                end;
                if v347[v350] == nil then
                    v347[v350] = true;
                end;
                do
                    local l_v350_0 = v350;
                    if v346[l_v350_0] ~= v349.m_flLastMadeNoiseTime then
                        if v347[l_v350_0] == true then
                            v345(v349);
                            v347[l_v350_0] = false;
                            utils.execute_after(0.5, function()
                                -- upvalues: v347 (ref), l_v350_0 (ref)
                                v347[l_v350_0] = true;
                            end);
                        end;
                        v346[l_v350_0] = v349.m_flLastMadeNoiseTime;
                    end;
                end;
            end;
        end;
        return;
    end;
end;
local function v367()
    -- upvalues: v13 (ref), v12 (ref)
    if not v13.features.hostage_esp.show_icon:get() and not v13.features.hostage_esp.show_text:get() and not v13.features.hostage_esp.show_distance:get() then
        return;
    elseif not entity.get_game_rules() then
        return;
    elseif entity.get_game_rules().m_iHostagesRemaining == 0 then
        return;
    else
        local v353 = entity.get_local_player();
        if not v353 then
            return;
        else
            for _, v355 in pairs(entity.get_entities("CHostage", true)) do
                if v355.m_nHostageState == 0 then
                    local v356 = v355:get_origin();
                    local v357 = v356:to_screen();
                    if v357 then
                        local v358 = vector(0, 0);
                        local v359 = v353:get_origin():dist(v356);
                        local v360 = math.floor(v359 / 39.37 + 0.5);
                        local v361 = math.min(1, math.max(0, 1 - (v359 - 300) / (v13.features.hostage_esp.distance:get() == 6 and math.huge or v13.features.hostage_esp.distance:get() * 20 * 39.37 - 300)));
                        local v362 = v13.features.hostage_esp.distance_color:get();
                        local v363 = v13.features.hostage_esp.text_color:get();
                        local v364 = v13.features.hostage_esp.icon_color:get();
                        local v365 = v361 * v362.a;
                        local v366 = v361 * v363.a;
                        v364.a = v361 * v364.a;
                        v363.a = v366;
                        v362.a = v365;
                        if v13.features.hostage_esp.show_distance:get() then
                            render.text(1, v357, v362, "c", "(" .. tostring(v360) .. "m)");
                            v358.y = v358.y + render.measure_text(1, nil, "(" .. tostring(v360) .. "m)").y;
                        end;
                        if v13.features.hostage_esp.show_text:get() then
                            render.text(1, v357 - v358, v363, "c", "Hostage");
                            v358.y = v358.y + render.measure_text(1, nil, "Hostage").y;
                        end;
                        if v13.features.hostage_esp.show_icon:get() then
                            render.shadow(v357 - v358 - vector(1, 0), v357 - v358 + vector(2, 0), v364);
                            render.text(1, v357 - v358, v364, "c", v12["person-praying"]);
                        end;
                    end;
                end;
            end;
            return;
        end;
    end;
end;
local function v371()
    -- upvalues: v8 (ref), v31 (ref), v12 (ref), v13 (ref), v38 (ref)
    if ui.get_alpha() > 0 then
        local v368 = ui.get_style("Link Active");
        local v369 = ui.get_style("Sidebar Text");
        v8.primary = "\a" .. v368:to_hex();
        ui.sidebar(v31(v368.r, v368.g, v368.b, v368.a, v369.r, v369.g, v369.b, v369.a, "ESP Additions"), "user-plus");
        local v370 = v8.primary .. v12["eye-slash"] .. v8.default .. "  Disable if Dormant";
        if string.find(custom_combo:list()[1], "No Players Found") ~= nil then
            custom_combo:disabled(true);
            custom_combo:set({});
        else
            custom_combo:disabled(false);
        end;
        stats_flag_kills_trigger:visibility(stats_flag_options:get("Round kills"));
        v13.features.zeus_warning.colors:visibility(v13.features.zeus_warning.style:get() ~= "Thunder");
        dormancy_states_selected:visibility(dormancy_mode:get() == "States");
        v13.main.welcome_text:name(v8.primary .. v12.user .. v8.default .. "    Welcome back, " .. v8.primary .. v38(common.get_username(), 15));
        v13.main.version_text:name(v8.primary .. v12["code-branch"] .. v8.default .. "    " .. "Beta" .. "  -  " .. v8.primary .. "1.9.3");
        v13.discord.text:name(v8.primary .. v12.discord .. v8.default .. "   Community");
        v13.discord.button:name("  " .. v8.primary .. v12["right-to-bracket"] .. v8.default .. "  Join  ");
        v13.flags.text:name(v8.primary .. v12["brake-warning"] .. v8.default .. "   Options are located inside the ESP");
        v13.flags.location:name(v8.primary .. v12["caret-right"] .. v8.default .. "  Navigate to:" .. "\n" .. v8.primary .. "Players" .. v8.default .. " \226\134\146 " .. v8.primary .. "ESP-Preview" .. v8.default .. " \226\134\146 " .. v8.primary .. "Manage Elements");
        v13.flags.location:tooltip("[ " .. v8.primary .. "Visuals" .. v8.default .. " ]\n" .. "   \226\148\148\226\148\128\226\148\128 [ " .. v8.primary .. "Players" .. v8.default .. " ]\n" .. "       \226\148\148\226\148\128\226\148\128 [ " .. v8.primary .. "ESP Preview" .. v8.default .. " ]\n" .. "           \226\148\148\226\148\128\226\148\128 [ " .. v8.primary .. "Manage Elements" .. v8.default .. " ]");
        v13.features.esp_corrections:name(v8.primary .. v12.stars .. v8.default .. "    ESP Corrections");
        v13.features.oof_arrows.switch:name(v8.primary .. v12["location-arrow"] .. v8.default .. "     OOF Arrows");
        v13.features.last_dormant_position.switch:name(v8.primary .. v12["user-group"] .. v8.default .. "   Last Dormant Position");
        v13.features.zeus_warning.switch:name(v8.primary .. v12.bolt .. v8.default .. "     Zeus Warning");
        v13.features.beam_sound_esp.switch:name(v8.primary .. v12["street-view"] .. v8.default .. "    Beam Sound ESP");
        v13.features.lagcomp_box.switch:name(v8.primary .. v12.cube .. v8.default .. "    Lagcompensation Box");
        v13.features.hostage_esp.text:name(v8.primary .. v12["person-praying"] .. v8.default .. "     Hostage ESP");
        custom_text:name(v8.primary .. v12.comment .. v8.default .. "  Text");
        custom_dormant:name(v370);
        healthshot_combo:name(v8.primary .. v12["bars-staggered"] .. v8.default .. "  Flag Style");
        healthshot_dormant:name(v370);
        afk_dormant:name(v370);
        hostage_res_combo:name(v8.primary .. v12["bars-staggered"] .. v8.default .. "  Rescuing");
        hostage_carry_combo:name(v8.primary .. v12["bars-staggered"] .. v8.default .. "  Carrying");
        hostage_dormant:name(v370);
        better_nades_use_color:name(v8.primary .. v12.palette .. v8.default .. "  Use Custom Colors");
        better_nades_vertical:name(v8.primary .. v12["up-down"] .. v8.default .. "  Vertical");
        better_nades_dormant:name(v370);
        lethal_scout_check:name(v8.primary .. v12["bars-staggered"] .. v8.default .. "  Scout Check");
        lethal_combo:name(v8.primary .. v12["bars-staggered"] .. v8.default .. "  Flag Style");
        lethal_dormant:name(v370);
        knife_only_show_on_knife:name(v8.primary .. v12["knife-kitchen"] .. v8.default .. "  Only show on knife");
        ping_trigger:name(v8.primary .. v12["arrows-left-right"] .. v8.default .. "  Trigger:");
        ping_trigger_check:name(v8.primary .. v12["circle-exclamation-check"] .. v8.default .. "  Only show warning");
        ping_dormant:name(v370);
        revolver_lethal_tracers:name(v8.primary .. v12.gears .. v8.default .. "  Lethal Tracers");
        revolver_show_non_lethal:name(v8.primary .. v12["user-shield"] .. v8.default .. "  Show non-lethal");
        revolver_dormant:name(v370);
        dist_combo:name(v8.primary .. v12["bars-staggered"] .. v8.default .. "  Style");
        dist_dormant:name(v370);
        money_color:name(v8.primary .. v12.palette .. v8.default .. "  Use Gamesense Color");
        shifting_tickbase_combo:name(v8.primary .. v12["bars-staggered"] .. v8.default .. "  Flag Style");
        lagcomp_breaker_combo:name(v8.primary .. v12["bars-staggered"] .. v8.default .. "  Flag Style");
        jumpshot_combo:name(v8.primary .. v12["bars-staggered"] .. v8.default .. "  Flag Style");
        stats_flag_kills_trigger:name(v8.primary .. v12["arrows-left-right"] .. v8.default .. "  Trigger:");
        stats_flag_dormant:name(v370);
        bomb_carry_style:name(v8.primary .. v12["bars-staggered"] .. v8.default .. "  Flag Style");
        bomb_only_fatal:name(v8.primary .. v12.skull .. v8.default .. "  Only show fatal damage");
        predict_damage_with_dt:name(v8.primary .. v12["calculator-simple"] .. v8.default .. "  Factor Pistols");
        predict_damage_lethal_color:name(v8.primary .. v12.palette .. v8.default .. "  Lethal color");
        dormancy_mode:name(v8.primary .. v12["bars-staggered"] .. v8.default .. "  Mode");
        self_reload_warning_style:name(v8.primary .. v12["bars-staggered"] .. v8.default .. "  Flag Style");
        self_reload_warning_options:name(v8.primary .. v12.gears .. v8.default .. "  Options");
        self_nade_warning_style:name(v8.primary .. v12["bars-staggered"] .. v8.default .. "  Flag Style");
        self_nade_warning_options:name(v8.primary .. v12.gears .. v8.default .. "  Options");
        self_slowed_down_style:name(v8.primary .. v12["bars-staggered"] .. v8.default .. "  Flag Style");
        self_slowed_down_options:name(v8.primary .. v12.gears .. v8.default .. "  Options");
    end;
end;
events.net_update_start:set(function()
    -- upvalues: v298 (ref)
    v298();
end);
events.pre_render:set(function()
    -- upvalues: v298 (ref), v135 (ref)
    v298();
    v135();
end);
events.render:set(function()
    -- upvalues: v371 (ref), v277 (ref), v278 (ref), v280 (ref), v343 (ref), v276 (ref), v327 (ref), v352 (ref), v110 (ref), v149 (ref), v291 (ref), v367 (ref), v252 (ref), v260 (ref)
    v371();
    v277();
    v278();
    v280();
    v343();
    v276();
    v327();
    v352();
    v110();
    v149();
    v291();
    v367();
    v252();
    v260();
end);
events.grenade_warning:set(function(v372)
    -- upvalues: v245 (ref)
    v245 = v372;
end);
events.round_poststart:set(function()
    -- upvalues: v293 (ref), v116 (ref), v346 (ref)
    for _, v374 in pairs(v293) do
        v374.place = "spawn";
    end;
    v116 = {};
    v346 = {};
end);
events.level_init:set(function()
    -- upvalues: v293 (ref), v116 (ref), v346 (ref), v4 (ref)
    v293 = {};
    v116 = {};
    v346 = {};
    v4 = cvar.mat_autoexposure_max_multiplier:int();
end);
events.config_state:set(function(_)
    config_loaded = true;
end);
if not config_loaded then
    bomb_options:set({
        [1] = "Carry", 
        [2] = "Planting", 
        [3] = "Defuse", 
        [4] = "Damage"
    });
    stats_flag_options:set({
        [1] = "Round kills", 
        [2] = "KD ratio"
    });
    dormancy_states_selected:set({
        [1] = "accurate", 
        [2] = "outdated"
    });
    lethal_scout_check:set("inventory");
    better_nades_use_color:set(true);
    better_nades_vertical:set(true);
    hostage_carry_combo:set("Carry");
    hostage_res_combo:set("Rescue");
    v13.features.last_dormant_position.font:set("Small");
end;
events.shutdown:set(function()
    -- upvalues: v4 (ref), v7 (ref)
    cvar.glow_outline_effect_enable:int(1, true);
    cvar.mat_autoexposure_max_multiplier:float(v4 or 1, true);
    v7.oof_arrows:override();
end);