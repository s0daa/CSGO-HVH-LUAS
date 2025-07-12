local l_pui_0 = require("neverlose/pui");
local l_clipboard_0 = require("neverlose/clipboard");
local l_base64_0 = require("neverlose/base64");
local l_bomb_0 = require("neverlose/bomb");
ffi.cdef("    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);\n    bool DeleteUrlCacheEntryA(const char* lpszUrlName);\n\n    typedef void*(__thiscall* get_client_entity_t)(void*, int);\n    typedef struct {\n        char  pad_0000[20];\n        int m_nOrder;\n        int m_nSequence;\n        float m_flPrevCycle;\n        float m_flWeight;\n        float m_flWeightDeltaRate;\n        float m_flPlaybackRate;\n        float m_flCycle;\n        void *m_pOwner;\n        char  pad_0038[4];\n    } animstate_layer_t;\n");
local _ = ffi.typeof("uintptr_t**");
local v5 = utils.get_vfunc("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)");
local v6 = nil;
math.lerp = function(v7, v8, v9)
    return v7 + v9 * (v8 - v7);
end;
local v10 = {
    max_lerp_low_fps = 2.2222222222222223
};
v10.color_lerp = function(v11, v12, v13)
    -- upvalues: v10 (ref)
    local v14 = globals.frametime * 100;
    return v11:lerp(v12, v13 * math.min(v14, v10.max_lerp_low_fps));
end;
v10.lerp = function(v15, v16, v17)
    -- upvalues: v10 (ref)
    if v15 == v16 then
        return v16;
    else
        local v18 = globals.frametime * 170;
        v17 = v17 * math.min(v18, v10.max_lerp_low_fps);
        local v19 = v15 + (v16 - v15) * math.clamp(v17, 0.01, 1);
        if math.abs(v19 - v16) < 0.01 then
            return v16;
        else
            return v19;
        end;
    end;
end;
v10.base_speed = 0.095;
v10._list = {};
v10.new = function(v20, v21, v22, v23)
    -- upvalues: v10 (ref)
    if not v22 then
        v22 = v10.base_speed;
    end;
    local v24 = type(v21) == "userdata";
    if v10._list[v20] == nil then
        v10._list[v20] = v23 and v23 or v24 and color(255) or 0;
    end;
    local v25 = nil;
    if v24 then
        v25 = v10.color_lerp;
    else
        v25 = v10.lerp;
    end;
    v10._list[v20] = v25(v10._list[v20], v21, v22);
    return v10._list[v20];
end;
local v26 = render.screen_size();
local v36 = {
    black_background = 0, 
    hovered_something = false, 
    group = ui.create("##drag"), 
    data = {}, 
    items = {}, 
    sliders = {}, 
    updated_data = {}, 
    in_bounds = function(v27, v28, v29)
        return v27.x >= v28.x and v27.x <= v28.x + v29.x and v27.y >= v28.y and v27.y <= v28.y + v29.y;
    end, 
    lerp = function(v30, v31, v32)
        if not v32 then
            v32 = 0.095;
        end;
        if math.abs(v30 - v31) < 1 then
            return v31;
        else
            v32 = globals.frametime * v32 * 120;
            return v30 + (v31 - v30) * v32;
        end;
    end, 
    limit_positions = function(v33, v34, v35)
        if v33.x <= 0 then
            v33.x = 0;
        end;
        if v33.x + v34.x >= v35.x - 1 then
            v33.x = v35.x - v34.x - 1;
        end;
        if v33.y <= 0 then
            v33.y = 0;
        end;
        if v33.y + v34.y >= v35.y - 1 then
            v33.y = v35.y - v34.y - 1;
        end;
    end
};
v36.new = function(v37, v38, v39, v40, v41, v42)
    -- upvalues: v36 (ref), v26 (ref)
    if v37 == nil or type(v37) ~= "string" then
        error("Name of item is invalid!");
    end;
    if v38 == nil or type(v38) ~= "number" then
        v38 = 0;
    end;
    if v39 == nil or type(v39) ~= "userdata" then
        v39 = vector(0, 0);
    end;
    if v42 == nil or type(v42) ~= "userdata" then
        v42 = vector(0, 0);
    end;
    local v43 = {};
    if v43[v37] == nil then
        v43[v37] = {
            box = 0, 
            border = 0, 
            rulers = {}
        };
    end;
    if v36.updated_data[v37] == nil then
        v36.updated_data[v37] = {
            enabled = true, 
            position = vector(0, 0), 
            size = vector(0, 0)
        };
    end;
    v36.sliders[v37] = {
        x = v36.group:slider("slider_x_" .. v37, v41 and v41[1].x or 0, v41 and v41[2].x or v26.x, v39.x), 
        y = v36.group:slider("slider_y_" .. v37, v41 and v41[1].y or 0, v41 and v41[2].y or v26.y, v39.y)
    };
    v36.sliders[v37].x:visibility(false);
    v36.sliders[v37].y:visibility(false);
    return function(v44)
        -- upvalues: v36 (ref), v37 (ref), v42 (ref), v41 (ref), v43 (ref), v40 (ref), v38 (ref), v26 (ref)
        events.render(function()
            -- upvalues: v36 (ref), v37 (ref), v42 (ref), v41 (ref), v43 (ref), v40 (ref), v38 (ref), v44 (ref), v26 (ref)
            local v45 = ui.get_alpha();
            local v46 = ui.get_mouse_position();
            local v47 = common.is_button_down(1);
            v36.data[v37] = {
                enabled = true, 
                position = vector(v36.sliders[v37].x:get(), v36.sliders[v37].y:get()), 
                size = v42
            };
            if v36.items[v37] == nil then
                v36.items[v37] = {
                    is_hovered = false, 
                    position = vector(0, 0)
                };
            end;
            if v41 then
                v43[v37].border = v36.lerp(v43[v37].border, v36.updated_data[v37].enabled and v36.items[v37].is_hovered and 50 or 0);
                if v45 > 0 and v43[v37].border > 0 then
                    render.rect_outline(v41[1], v41[2], color(255, v45 * v43[v37].border), 1, 4);
                end;
            end;
            local v48 = {
                x = false, 
                y = false
            };
            if v40 then
                for v49, v50 in pairs(v40) do
                    local v51 = math.abs(v50[1] == "x" and v50[2].x - v46.x or v50[2].y - v46.y) < 10;
                    if v51 and v36.items[v37].is_hovered then
                        if v50[1] == "x" then
                            v48.x = true;
                            v36.sliders[v37].x:set(v50[2].x - v36.updated_data[v37].size.x * 0.5);
                        else
                            v48.y = true;
                            v36.sliders[v37].y:set(v50[2].y - v36.updated_data[v37].size.y * 0.5);
                        end;
                    end;
                    if v43[v37].rulers[v49] == nil then
                        v43[v37].rulers[v49] = 0;
                    end;
                    local l_rulers_0 = v43[v37].rulers;
                    local l_lerp_0 = v36.lerp;
                    local v54 = v43[v37].rulers[v49];
                    local v55;
                    if v36.updated_data[v37].enabled and v36.items[v37].is_hovered then
                        v55 = v51 and 150 or 50;
                    else
                        v55 = 0;
                    end;
                    l_rulers_0[v49] = l_lerp_0(v54, v55);
                    if v45 > 0 and v43[v37].rulers[v49] > 0 then
                        render.line(v50[2], v50[3], color(255, v45 * v43[v37].rulers[v49]), 1);
                    end;
                end;
            end;
            local v56 = v43[v37];
            local l_lerp_1 = v36.lerp;
            local l_box_0 = v43[v37].box;
            local v59;
            if v36.updated_data[v37].enabled then
                v59 = v36.items[v37].is_hovered and 75 or 25;
            else
                v59 = 0;
            end;
            v56.box = l_lerp_1(l_box_0, v59);
            if v45 > 0 then
                if v38 == 1 then
                    render.rect_outline(v36.updated_data[v37].position, v36.updated_data[v37].position + v36.updated_data[v37].size, color(255, v45 * v43[v37].box), 1, 4);
                elseif v38 == 2 then
                    render.rect(v36.updated_data[v37].position, v36.updated_data[v37].position + v36.updated_data[v37].size, color(200, v45 * v43[v37].box), 4);
                    render.rect_outline(v36.updated_data[v37].position, v36.updated_data[v37].position + v36.updated_data[v37].size, color(200, v45 * v43[v37].box), 1, 4);
                end;
            end;
            v44(v36.data[v37]);
            v36.updated_data[v37] = v36.data[v37];
            v56 = v36.in_bounds(v46, v36.data[v37].position, v36.data[v37].size);
            l_lerp_1 = v36.in_bounds(v46, vector(0, 0), v26);
            if v36.updated_data[v37].enabled and v56 and l_lerp_1 and not v36.hovered_something then
                v36.hovered_something = true;
                if v47 and not v36.items[v37].is_hovered then
                    v36.items[v37].position = v36.data[v37].position - v46;
                    v36.items[v37].is_hovered = true;
                end;
            end;
            if not l_lerp_1 then
                v36.items[v37].is_hovered = false;
            end;
            if not v47 then
                v36.items[v37].is_hovered = false;
                v36.hovered_something = false;
            end;
            if v36.updated_data[v37].enabled and v36.items[v37].is_hovered and v45 > 0 then
                l_box_0 = vector(v46.x + v36.items[v37].position.x, v46.y + v36.items[v37].position.y);
                v36.limit_positions(l_box_0, v36.data[v37].size, v41 and v41[2] or v26);
                if not v48.x then
                    v36.sliders[v37].x:set(l_box_0.x);
                end;
                if not v48.y then
                    v36.sliders[v37].y:set(l_box_0.y);
                end;
            end;
        end);
    end;
end;
events.render(function()
    -- upvalues: v36 (ref), v26 (ref)
    local v60 = ui.get_alpha();
    v36.black_background = v36.lerp(v36.black_background, v36.hovered_something and 125 or 0);
    if v60 > 0 and v36.black_background > 0 then
        render.rect(vector(0, 0), v26, color(0, v60 * v36.black_background), 0);
    end;
end);
local v61 = {
    pitch = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
    yaw = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Yaw", {
        base = "Base", 
        hidden = "Hidden", 
        offset = "Offset", 
        avoid_backstab = "Avoid Backstab"
    }), 
    yaw_modifier = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", {
        offset = "Offset"
    }), 
    body_yaw = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", {
        freestanding = "Freestanding", 
        left_limit = "Left Limit", 
        inverter = "Inverter", 
        options = "Options", 
        right_limit = "Right Limit"
    }), 
    freestanding = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Freestanding", {
        body_freestanding = "Body Freestanding", 
        disable_yaw_modifiers = "Disable Yaw Modifiers"
    }), 
    slow_walk = l_pui_0.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
    fake_duck = l_pui_0.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
    legs_movement = l_pui_0.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"), 
    lag_options = l_pui_0.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
    hide_shots_options = l_pui_0.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
    scope_overlay = l_pui_0.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"), 
    doubletap = l_pui_0.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
    hide_shots = l_pui_0.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
    minimum_damage = l_pui_0.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
    field_of_view = ui.find("Visuals", "World", "Main", "Field of View"), 
    override_zoom = l_pui_0.find("Visuals", "World", "Main", "Override Zoom", {
        force_viewmodel = "Force Viewmodel", 
        scope_overlay = "Scope Overlay"
    }), 
    fake_latency = l_pui_0.find("Miscellaneous", "Main", "Other", "Fake Latency"), 
    air_strafe = l_pui_0.find("Miscellaneous", "Main", "Movement", "Air Strafe"), 
    pistols_hitchance = l_pui_0.find("Aimbot", "Ragebot", "Selection", "Pistols", "Hit Chance"), 
    auto_snipers_hitchance = l_pui_0.find("Aimbot", "Ragebot", "Selection", "AutoSnipers", "Hit Chance"), 
    awp_hitchance = l_pui_0.find("Aimbot", "Ragebot", "Selection", "AWP", "Hit Chance"), 
    ssg08_hitchance = l_pui_0.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance"), 
    revolver_hitchance = l_pui_0.find("Aimbot", "Ragebot", "Selection", "R8 Revolver", "Hit Chance"), 
    body_aim = ui.find("Aimbot", "Ragebot", "Safety", "SSG-08", "Body Aim"), 
    safe_point = ui.find("Aimbot", "Ragebot", "Safety", "SSG-08", "Safe Points"), 
    dormant_aimbot = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
    weapon_actions = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions")
};
local _ = l_pui_0.sidebar("\vNyaHook", "paw");
local v71 = {
    icon_text = function(v63, v64, v65)
        v63 = v63 and ui.get_icon(v63) or "";
        if not v64 then
            v64 = "";
        end;
        if not v65 then
            v65 = "\v";
        end;
        local _ = "";
        local v67 = "";
        local l_x_0 = render.measure_text(1, nil, v63).x;
        local v69 = 12 - l_x_0 * 0.5;
        v69 = math.floor(v69 + 0.5) - 2;
        if math.fmod(l_x_0, 2) ~= 0 then
            v67 = " ";
            v69 = v69 - 1;
        end;
        for _ = 1, v69 do
            v67 = v67 .. "\226\128\175";
        end;
        return v65 .. v63 .. "\aDEFAULT" .. v67 .. "" .. v64;
    end, 
    tabs = {
        home = {
            nyahook = l_pui_0.create("\f<house-night>", "##nyahook", 1), 
            under_nyahook = l_pui_0.create("\f<house-night>", "##under_nyahook", 1), 
            under_nyahook_2 = l_pui_0.create("\f<house-night>", "##under_nyahook_2", 1), 
            image = l_pui_0.create("\f<house-night>", "##image", 2)
        }, 
        anti_aim = {
            left_branch = l_pui_0.create("\f<user-shield>", "##left_branch", 1), 
            left_builder_state = l_pui_0.create("\f<user-shield>", "##left_builder_state", 1), 
            left_builder = l_pui_0.create("\f<user-shield>", "##left_builder", 1), 
            left_builder_2 = l_pui_0.create("\f<user-shield>", "##left_builder_2", 1), 
            left_builder_3 = l_pui_0.create("\f<user-shield>", "##left_builder_3", 1), 
            left_builder_presets = l_pui_0.create("\f<user-shield>", "##left_builder_presets", 1), 
            right_builder_branch = l_pui_0.create("\f<user-shield>", "##right_builder_branch", 2), 
            right_builder = l_pui_0.create("\f<user-shield>", "##right_builder", 2), 
            right_builder_down = l_pui_0.create("\f<user-shield>", "##right_builder_down", 2), 
            right_builder_down_2 = l_pui_0.create("\f<user-shield>", "##right_builder_down_2", 2), 
            right_builder_down_3 = l_pui_0.create("\f<user-shield>", "##right_builder_down_3", 2), 
            right_enhancements = l_pui_0.create("\f<user-shield>", "##right_enhancements", 2)
        }, 
        other = {
            select_tab = l_pui_0.create("\f<gears>", "##select_tab", 1), 
            right_visuals_on_screen = l_pui_0.create("\f<gears>", "##right_visuals_on_screen", 2), 
            left_visuals_widgets = l_pui_0.create("\f<gears>", "##left_visuals_widgets", 1), 
            right_visuals_modifications = l_pui_0.create("\f<gears>", "##right_visuals_modifications", 2), 
            right_misc_in_game = l_pui_0.create("\f<gears>", "##right_misc_in_game", 2), 
            right_misc_ragebot = l_pui_0.create("\f<gears>", "##right_misc_ragebot", 2), 
            left_misc_movement = l_pui_0.create("\f<gears>", "##left_misc_movement", 1), 
            left_misc_other = l_pui_0.create("\f<gears>", "##left_misc_other", 1), 
            right_configs = l_pui_0.create("\f<gears>", "##right_configs", 2)
        }
    }
};
v71.home = {
    select_tab = v71.tabs.other.select_tab:list("\n", {
        [1] = "Visuals", 
        [2] = "Misc"
    }), 
    welcome = v71.tabs.home.nyahook:label("Welcome to the \vDebug\r version of \vNyaHook\r!"), 
    user = v71.tabs.home.under_nyahook:label(v71.icon_text("hand-wave", "Welcome back, \v" .. common.get_username())), 
    current_build = v71.tabs.home.under_nyahook:label(v71.icon_text("rectangle-terminal", "Current build: \vDebug")), 
    socials = v71.tabs.home.under_nyahook_2:label(v71.icon_text("square-share-nodes", "Socials")), 
    discord_server = v71.tabs.home.under_nyahook_2:button("\aC0BCFFFF\f<discord>\r", function()
        panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/hkXc5zdJpc");
    end, true), 
    youtube = v71.tabs.home.under_nyahook_2:button("\aFF6A6AFF\f<youtube>\r", function()
        panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@zordside");
    end, true), 
    warning = v71.tabs.home.under_nyahook_2:label(v71.icon_text("paw", "Be blessed with \vNyaHook\r!"))
};
v71.anti_aim_conditions = {
    [1] = "Shared", 
    [2] = "Standing", 
    [3] = "Moving", 
    [4] = "Air", 
    [5] = "Air Crouching", 
    [6] = "Crouching", 
    [7] = "Crouching Moving", 
    [8] = "Slow Walking", 
    [9] = "Freestanding", 
    [10] = "Manual Yaw"
};
v71.anti_aim = {
    branch = v71.tabs.anti_aim.right_builder_branch:list("##branch", {
        [1] = "State Builder", 
        [2] = "Defensive Builder"
    }), 
    manual_yaw = v71.tabs.anti_aim.left_builder:combo(v71.icon_text("arrows-repeat", "Manual Yaw"), {
        [1] = "Disabled", 
        [2] = "Left", 
        [3] = "Right", 
        [4] = "Forward"
    }, function(v72)
        return {
            manual_over_fs = v72:switch("Manual Over FS")
        };
    end), 
    freestanding = v71.tabs.anti_aim.left_builder:switch(v71.icon_text("arrows-turn-to-dots", "Freestanding"), false, function(v73)
        return {
            disable_yaw_modifiers = v73:switch("Disable Yaw Modifiers"), 
            body_freestanding = v73:switch("Body Freestanding")
        };
    end), 
    edge_yaw = v71.tabs.anti_aim.left_builder_2:switch(v71.icon_text("compass-drafting", "Edge Yaw"), false, function(v74)
        return {
            ignore_manuals = v74:switch("Ignore Manuals")
        };
    end), 
    avoid_backstab = v71.tabs.anti_aim.left_builder_2:switch(v71.icon_text("scalpel-line-dashed", "Avoid Backstab")), 
    safe_head = v71.tabs.anti_aim.left_builder_2:switch(v71.icon_text("compress", "Safe Head"), false, function(v75)
        return {
            triggers = v75:selectable("Triggers", {
                [1] = "Knife", 
                [2] = "Taser", 
                [3] = "Above Enemy"
            }), 
            height_difference = v75:slider("Height Difference", 30, 180, 80)
        };
    end), 
    disablers = v71.tabs.anti_aim.left_builder_2:selectable(v71.icon_text("circle-xmark", "Disablers"), {
        [1] = "On Warmup", 
        [2] = "On Round End"
    }), 
    force_defensive = v71.tabs.anti_aim.left_builder_3:selectable(v71.icon_text("shield", "Force Defensive"), {
        select(2, table.unpack(v71.anti_aim_conditions))
    }, function(v76)
        return {
            method = v76:list("\n", {
                [1] = "Default", 
                [2] = "Custom", 
                [3] = "Random"
            }), 
            always_on = v76:switch("Always On"), 
            custom_ticks = v76:slider("Ticks", 1, 30, 0, 1, "t"), 
            random_ticks_first = v76:slider("First Value", 1, 30, 0, 1, "t"), 
            random_ticks_second = v76:slider("Second Value", 1, 30, 0, 1, "t")
        };
    end), 
    flick_exploit = v71.tabs.anti_aim.left_builder_3:switch(v71.icon_text("shuffle", "Flick Exploit"), false, function(v77)
        return {
            inverter = v77:switch("Inverter")
        };
    end), 
    lag_exploit = v71.tabs.anti_aim.left_builder_3:switch(v71.icon_text("person-circle-exclamation", "Lag Exploit"), false, function(v78)
        return {
            ticks = v78:slider("Ticks", 1, 32, 16, 1, "t")
        };
    end), 
    current_state = v71.tabs.anti_aim.left_builder_state:combo(v71.icon_text("chart-pyramid", "Current State"), v71.anti_aim_conditions), 
    preset_manager = {}, 
    builder = {}
};
v71.anti_aim.tooltips = {
    v71.anti_aim.flick_exploit:tooltip("Works only on slow-walk! \n \n \226\128\162 This feature is flicking your head in the opposite direction by using defensive mechanics and allowing you to be impenetrable. \n \n \226\128\162 Make sure that the slow-walk in cheat is binded.")
};
for v79 = 1, #v71.anti_aim_conditions do
    v71.anti_aim.builder[v79] = {
        enable_state = v71.tabs.anti_aim.left_builder_state:switch("Override \v" .. v71.anti_aim_conditions[v79]), 
        yaw_amount = v71.tabs.anti_aim.right_builder_down:slider(v71.icon_text("arrows-left-right", "Yaw"), -180, 180, 0, 1, "\194\176", false, function(v80)
            -- upvalues: v71 (ref)
            return {
                add_left_yaw = v80:slider(v71.icon_text("left-long", "Add Left"), -180, 180, 0, 1, "\194\176"), 
                add_right_yaw = v80:slider(v71.icon_text("right-long", "Add Right"), -180, 180, 0, 1, "\194\176")
            };
        end), 
        yaw_randomize = v71.tabs.anti_aim.right_builder_down:slider(v71.icon_text("arrow-trend-down", "Randomize"), 0, 100, 0, 1, function(v81)
            return v81 == 0 and "Off" or string.format("%s%%", v81);
        end), 
        yaw_fluctation = v71.tabs.anti_aim.right_builder_down:slider(v71.icon_text("arrow-up-square-triangle", "Fluctation"), 0, 100, 0, 1, false, function(v82)
            return {
                fluctation_phase_time = v82:slider("Phase Time", 0, 100, 0, 1), 
                fluctation_delay_1 = v82:slider("Phase Delay [1]", 0, 100, 0, 1), 
                fluctation_delay_2 = v82:slider("Phase Delay [2]", 0, 100, 0, 1), 
                fluctation_delay_3 = v82:slider("Phase Delay [3]", 0, 100, 0, 1)
            };
        end), 
        yaw_jitter = v71.tabs.anti_aim.right_builder_down_2:combo(v71.icon_text("arrows-spin", "Yaw Modifier"), {
            [1] = "Disabled", 
            [2] = "Center", 
            [3] = "Offset", 
            [4] = "Random", 
            [5] = "Spin", 
            [6] = "3-Way", 
            [7] = "5-Way"
        }, function()
            -- upvalues: v71 (ref)
            return {
                amount = v71.tabs.anti_aim.right_builder_down_2:slider(v71.icon_text("arrow-up-wide-short", "Amount"), -180, 180, 0, 1, "\194\176"), 
                randomize = v71.tabs.anti_aim.right_builder_down_2:slider(v71.icon_text("arrow-trend-up", "Randomize"), 0, 100, 0, 1, function(v83)
                    return v83 == 0 and "Off" or string.format("%s%%", v83);
                end)
            };
        end), 
        fake_limit = v71.tabs.anti_aim.right_builder_down_3:slider(v71.icon_text("angle-90", "Fake Limit"), 0, 60, 60, 1, "\194\176"), 
        fake_limit_randomize = v71.tabs.anti_aim.right_builder_down_3:slider(v71.icon_text("arrow-trend-down", "Randomize"), 0, 100, 0, 1, function(v84)
            return v84 == 0 and "Off" or string.format("%s%%", v84);
        end), 
        body_jitter = v71.tabs.anti_aim.right_builder_down_3:switch(v71.icon_text("spinner", "Body Jitter"), false, function(v85)
            -- upvalues: v71 (ref)
            return {
                body_jitter_switch_method = v85:combo(v71.icon_text("stack-overflow", "Method"), {
                    [1] = "Default", 
                    [2] = "Progressive"
                }), 
                body_jitter_switch_ticks = v85:slider(v71.icon_text("arrow-down-short-wide", "Switch Ticks"), 2, 10, 1, 1, function(v86)
                    return v86 == 2 and "Off" or string.format("%st", v86);
                end), 
                body_jitter_switch_minimum = v85:slider(v71.icon_text("arrow-down-short-wide", "Min. Value"), 2, 10, 1, 1, "t"), 
                body_jitter_switch_maximum = v85:slider(v71.icon_text("arrow-up-wide-short", "Max. Value"), 2, 10, 1, 1, "t"), 
                body_jitter_randomize_switch = v85:slider(v71.icon_text("arrow-trend-up", "Randomize"), 2, 10, 1, 1, function(v87)
                    return v87 == 2 and "Off" or string.format("%st", v87);
                end)
            };
        end), 
        defensive_aa = v71.tabs.anti_aim.right_builder_down:switch(v71.icon_text("eye-slash", "Defensive")), 
        pitch = v71.tabs.anti_aim.right_builder_down_2:combo(v71.icon_text("arrow-up-from-square", "Pitch"), {
            [1] = "Disabled", 
            [2] = "Down", 
            [3] = "Up", 
            [4] = "Random", 
            [5] = "Custom"
        }), 
        pitch_random_first = v71.tabs.anti_aim.right_builder_down_2:slider(v71.icon_text("arrow-up-short-wide", "Random First"), -89, 89, 0), 
        pitch_random_second = v71.tabs.anti_aim.right_builder_down_2:slider(v71.icon_text("arrow-up-wide-short", "Random Second"), -89, 89, 0), 
        pitch_custom = v71.tabs.anti_aim.right_builder_down_2:slider(v71.icon_text("arrow-up-square-triangle", "Custom"), -89, 89, 0), 
        yaw = v71.tabs.anti_aim.right_builder_down_3:combo(v71.icon_text("arrow-up-right-and-arrow-down-left-from-center", "Yaw\n"), {
            [1] = "Hidden", 
            [2] = "L&R\n", 
            [3] = "Forward", 
            [4] = "Sideways", 
            [5] = "Random\n", 
            [6] = "Spin", 
            [7] = "Custom\n"
        }), 
        defensive_yaw_left_amount = v71.tabs.anti_aim.right_builder_down_3:slider(v71.icon_text("left-long", "Left Amount\n"), -180, 180, 0, 1, "\194\176"), 
        defensive_yaw_right_amount = v71.tabs.anti_aim.right_builder_down_3:slider(v71.icon_text("right-long", "Right Amount\n"), -180, 180, 0, 1, "\194\176"), 
        defensive_yaw_delay = v71.tabs.anti_aim.right_builder_down_3:slider(v71.icon_text("arrow-down-short-wide", "Delay\n"), 2, 10, 1, 1, function(v88)
            return v88 == 2 and "Off" or string.format("%st", v88);
        end), 
        yaw_random_first = v71.tabs.anti_aim.right_builder_down_3:slider(v71.icon_text("arrow-up-short-wide", "Random First\n"), -180, 180, 0), 
        yaw_random_second = v71.tabs.anti_aim.right_builder_down_3:slider(v71.icon_text("arrow-up-wide-short", "Random Second\n"), -180, 180, 0), 
        yaw_spin_speed = v71.tabs.anti_aim.right_builder_down_3:slider(v71.icon_text("arrows-retweet", "Spin Speed"), 1, 30, 1), 
        yaw_custom = v71.tabs.anti_aim.right_builder_down_3:slider(v71.icon_text("arrow-up-square-triangle", "Custom\n"), -180, 180, 0)
    };
end;
v71.visuals = {
    centered_indicators = v71.tabs.other.right_visuals_on_screen:switch(v71.icon_text("list-check", "Centered Indicators"), false, function(v89)
        return {
            offset = v89:slider("Offset", 0, 100, 15), 
            centered_indicators_color = v89:color_picker("Color", color(255, 180, 226, 255))
        };
    end), 
    gamesense_indicators = v71.tabs.other.right_visuals_on_screen:switch(v71.icon_text("list-dropdown", "Game\a00FF00FFSense\r Indicators"), false, function(v90)
        return {
            style = v90:combo("Style", {
                [1] = "Classic", 
                [2] = "Modern"
            }), 
            select = v90:selectable("Select", {
                [1] = "Double Tap", 
                [2] = "Hide Shots", 
                [3] = "Fake Latency", 
                [4] = "Min. Damage Override", 
                [5] = "Body Aim", 
                [6] = "Force Safe Point", 
                [7] = "Freestanding", 
                [8] = "Dormant Aimbot", 
                [9] = "Bomb Information", 
                [10] = "Hit/Miss Rate"
            }), 
            animated = v90:switch("Animated")
        };
    end), 
    manual_arrows = v71.tabs.other.right_visuals_on_screen:switch(v71.icon_text("code-simple", "Manual Arrows"), false, function(v91)
        return {
            offset = v91:slider("Offset", 0, 100, 30), 
            arrows_style = v91:combo("Style", {
                [1] = "Classic", 
                [2] = "Modern"
            }), 
            arrows_color = v91:color_picker("Color", color(255, 180, 226, 255))
        };
    end), 
    damage_indicator = v71.tabs.other.right_visuals_on_screen:switch(v71.icon_text("arrow-down-9-1", "Damage Indicator"), false, function(v92)
        return {
            font = v92:combo("Font", {
                [1] = "Default", 
                [2] = "Pixel", 
                [3] = "Bold"
            })
        };
    end), 
    custom_scope_overlay = v71.tabs.other.right_visuals_on_screen:switch(v71.icon_text("binoculars", "Custom Scope Overlay"), false, function(v93)
        return {
            size = v93:slider("Size", 0, 300, 100), 
            gap = v93:slider("Gap", 0, 300, 5), 
            inverted = v93:switch("Inverted"), 
            t_pose = v93:switch("T Pose"), 
            scope_color = v93:color_picker("Color", color(170, 170, 170, 255)), 
            viewmodel_in_scope = v93:switch("Viewmodel In Scope")
        };
    end), 
    watermark = v71.tabs.other.left_visuals_widgets:switch(v71.icon_text("table-pivot", "Watermark"), false, function(v94)
        return {
            style = v94:combo("Style", {
                [1] = "Classic", 
                [2] = "Modern", 
                [3] = "Minimalistic"
            }), 
            watermark_color = v94:color_picker("Color", color())
        };
    end), 
    keybinds = v71.tabs.other.left_visuals_widgets:switch(v71.icon_text("keyboard", "Keybinds"), false, function(v95)
        return {
            keybinds_color = v95:color_picker("Color", color())
        };
    end), 
    spectators = v71.tabs.other.left_visuals_widgets:switch(v71.icon_text("eye", "Spectators"), false, function(v96)
        return {
            spectators_color = v96:color_picker("Color", color())
        };
    end), 
    velocity_indicator = v71.tabs.other.left_visuals_widgets:switch(v71.icon_text("gauge-min", "Velocity"), false, function(v97)
        return {
            velocity_indicator_color = v97:color_picker("Color", color(255, 180, 226, 255))
        };
    end), 
    hitmarker = v71.tabs.other.left_visuals_widgets:switch(v71.icon_text("xmark-large", "Hitmarker"), false, function(v98)
        return {
            hitmarker_color = v98:color_picker("Color", color(255))
        };
    end), 
    animated_zoom = v71.tabs.other.right_visuals_modifications:switch(v71.icon_text("magnifying-glass-plus", "Animated Zoom")), 
    client_side_animations = v71.tabs.other.right_visuals_modifications:switch(v71.icon_text("layer-group", "Client-Side Animations"), false, function(v99)
        return {
            ground_legs = v99:combo("Ground Legs", {
                [1] = "Disabled", 
                [2] = "Reversed", 
                [3] = "Jitter", 
                [4] = "Moonwalk"
            }), 
            air_legs = v99:combo("Air Legs", {
                [1] = "Disabled", 
                [2] = "Static", 
                [3] = "Jitter", 
                [4] = "Moonwalk"
            }), 
            addons = v99:selectable("Addons", {
                [1] = "Move Lean", 
                [2] = "Earthquake", 
                [3] = "Pitch Zero On Land"
            }), 
            move_lean_amount = v99:slider("Move Lean Amount", 0, 100, 0, 1, "%")
        };
    end), 
    grenade_warning = v71.tabs.other.right_visuals_modifications:switch(v71.icon_text("triangle-exclamation", "Grenade Warning"))
};
v71.misc = {
    in_game = {
        trashtalk = v71.tabs.other.right_misc_in_game:switch(v71.icon_text("face-pouting", "Trashtalk")), 
        clantag = v71.tabs.other.right_misc_in_game:switch(v71.icon_text("tag", "Clantag")), 
        aspect_ratio = v71.tabs.other.right_misc_in_game:switch(v71.icon_text("screencast", "Aspect Ratio"), false, function(v100)
            -- upvalues: v71 (ref)
            return {
                ratio = v100:slider("Ratio", 0, 200, 0, 0.01), 
                button_16_10 = v100:button("16:10", function()
                    -- upvalues: v71 (ref)
                    v71.misc.in_game.aspect_ratio.ratio:set(160);
                end, true), 
                button_16_9 = v100:button("16:9", function()
                    -- upvalues: v71 (ref)
                    v71.misc.in_game.aspect_ratio.ratio:set(180);
                end, true), 
                button_5_4 = v100:button("5:4", function()
                    -- upvalues: v71 (ref)
                    v71.misc.in_game.aspect_ratio.ratio:set(125);
                end, true), 
                button_4_3 = v100:button("4:3", function()
                    -- upvalues: v71 (ref)
                    v71.misc.in_game.aspect_ratio.ratio:set(133);
                end, true), 
                button_3_2 = v100:button("3:2", function()
                    -- upvalues: v71 (ref)
                    v71.misc.in_game.aspect_ratio.ratio:set(150);
                end, true)
            };
        end), 
        viewmodel_changer = v71.tabs.other.right_misc_in_game:switch(v71.icon_text("hand", "Viewmodel Changer"), false, function(v101)
            -- upvalues: v71 (ref)
            return {
                viewmodel_fov = v101:slider("Fov", -10000, 10000, 6800, 0.01), 
                viewmodel_x = v101:slider("X", -1000, 1000, 250, 0.01), 
                viewmodel_y = v101:slider("Y", -2000, 2000, 0, 0.01), 
                viewmodel_z = v101:slider("Z", -1000, 1000, -150, 0.01), 
                viewmodel_reset = v101:button("Reset", function()
                    -- upvalues: v71 (ref)
                    v71.misc.in_game.viewmodel_changer.viewmodel_fov:set(6800);
                    v71.misc.in_game.viewmodel_changer.viewmodel_x:set(250);
                    v71.misc.in_game.viewmodel_changer.viewmodel_y:set(0);
                    v71.misc.in_game.viewmodel_changer.viewmodel_z:set(-150);
                end, true)
            };
        end), 
        keep_model_transparency = v71.tabs.other.right_misc_in_game:switch(v71.icon_text("face-dotted", "Keep Model Transparency"))
    }, 
    movement = {
        no_fall_damage = v71.tabs.other.left_misc_movement:switch(v71.icon_text("person-falling-burst", "No Fall Damage")), 
        fast_ladder = v71.tabs.other.left_misc_movement:switch(v71.icon_text("water-ladder", "Fast Ladder")), 
        edge_stop = v71.tabs.other.left_misc_movement:switch(v71.icon_text("arrow-down-up-lock", "Edge Stop")), 
        jump_scout = v71.tabs.other.left_misc_movement:switch(v71.icon_text("person-ski-jumping", "Jump Scout")), 
        super_toss = v71.tabs.other.left_misc_movement:switch(v71.icon_text("sensor-fire", "Super Toss"))
    }, 
    ragebot = {
        aimbot_logs = v71.tabs.other.right_misc_ragebot:switch(v71.icon_text("right-to-bracket", "Aimbot Logs"), false, function(v102)
            return {
                output = v102:selectable("Output", {
                    [1] = "Console", 
                    [2] = "Event", 
                    [3] = "Notify"
                }), 
                purchase_logs = v102:switch("Purchase Logs"), 
                hit_color = v102:color_picker("Hit Color", color(0, 255, 0, 255)), 
                miss_color = v102:color_picker("Miss Color", color(230, 150, 150, 255)), 
                push_notify_log = v102:button("Push Notify Log", function()

                end, true)
            };
        end), 
        fake_latency = v71.tabs.other.right_misc_ragebot:slider(v71.icon_text("signal-bars", "Fake Latency"), 0, 300, 0, 1, "ms"), 
        hitchance = v71.tabs.other.right_misc_ragebot:switch(v71.icon_text("person-rifle", "Hitchance"), false, function(v103)
            return {
                current_weapon = v103:list("\n", {
                    [1] = "Pistols", 
                    [2] = "Auto-Snipers", 
                    [3] = "Awp", 
                    [4] = "SSG-08", 
                    [5] = "R8 Revolver"
                }), 
                enable_pistols = v103:switch("Override \vPistols", false), 
                pistols_air_amount = v103:slider("In-Air", 0, 100, 0, 1, "%"), 
                enable_auto_snipers = v103:switch("Override \vAuto-Snipers", false), 
                auto_snipers_no_scope_amount = v103:slider("No-Scope", 0, 100, 0, 1, "%"), 
                auto_snipers_air_amount = v103:slider("In-Air", 0, 100, 0, 1, "%"), 
                enable_awp = v103:switch("Override \vAwp", false), 
                awp_no_scope_amount = v103:slider("No-Scope", 0, 100, 0, 1, "%"), 
                awp_air_amount = v103:slider("In-Air", 0, 100, 0, 1, "%"), 
                enable_ssg08 = v103:switch("Override \vSSG-08", false), 
                ssg08_no_scope_amount = v103:slider("No-Scope", 0, 100, 0, 1, "%"), 
                ssg08_air_amount = v103:slider("In-Air", 0, 100, 0, 1, "%"), 
                enable_revolver = v103:switch("Override \vR8 Revolver", false), 
                revolver_air_amount = v103:slider("In-Air", 0, 100, 0, 1, "%")
            };
        end), 
        grenade_throw_fix = v71.tabs.other.right_misc_ragebot:switch(v71.icon_text("bomb", "Grenade Throw Fix")), 
        decrease_hold_aim_ticks = v71.tabs.other.left_misc_other:switch(v71.icon_text("person-burst", "Decrease Hold Aim Ticks"))
    }
};
depend = {
    anti_aim_depend = {
        v71.anti_aim.force_defensive.method:depend(v71.anti_aim.force_defensive), 
        v71.anti_aim.force_defensive.always_on:depend(v71.anti_aim.force_defensive, {
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.force_defensive.method
        }), 
        v71.anti_aim.force_defensive.custom_ticks:depend(v71.anti_aim.force_defensive, {
            [1] = nil, 
            [2] = 2, 
            [1] = v71.anti_aim.force_defensive.method
        }), 
        v71.anti_aim.force_defensive.random_ticks_first:depend(v71.anti_aim.force_defensive, {
            [1] = nil, 
            [2] = 3, 
            [1] = v71.anti_aim.force_defensive.method
        }), 
        v71.anti_aim.force_defensive.random_ticks_second:depend(v71.anti_aim.force_defensive, {
            [1] = nil, 
            [2] = 3, 
            [1] = v71.anti_aim.force_defensive.method
        }), 
        v71.anti_aim.flick_exploit.inverter:depend(v71.anti_aim.flick_exploit), 
        v71.anti_aim.lag_exploit.ticks:depend(v71.anti_aim.lag_exploit), 
        v71.anti_aim.safe_head.triggers:depend(v71.anti_aim.safe_head), 
        v71.anti_aim.safe_head.height_difference:depend(v71.anti_aim.safe_head, {
            [1] = nil, 
            [2] = "Above Enemy", 
            [1] = v71.anti_aim.safe_head.triggers
        }), 
        v71.anti_aim.edge_yaw.ignore_manuals:depend(v71.anti_aim.edge_yaw)
    }, 
    visuals_depend = {
        v71.visuals.centered_indicators:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.home.select_tab
        }), 
        v71.visuals.centered_indicators.offset:depend(v71.visuals.centered_indicators), 
        v71.visuals.centered_indicators.centered_indicators_color:depend(v71.visuals.centered_indicators), 
        v71.visuals.gamesense_indicators:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.home.select_tab
        }), 
        v71.visuals.gamesense_indicators.style:depend(v71.visuals.gamesense_indicators), 
        v71.visuals.gamesense_indicators.select:depend(v71.visuals.gamesense_indicators), 
        v71.visuals.gamesense_indicators.animated:depend(v71.visuals.gamesense_indicators), 
        v71.visuals.manual_arrows:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.home.select_tab
        }), 
        v71.visuals.manual_arrows.arrows_style:depend(v71.visuals.manual_arrows), 
        v71.visuals.manual_arrows.arrows_color:depend(v71.visuals.manual_arrows), 
        v71.visuals.manual_arrows.offset:depend(v71.visuals.manual_arrows), 
        v71.visuals.damage_indicator:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.home.select_tab
        }), 
        v71.visuals.damage_indicator.font:depend(v71.visuals.damage_indicator), 
        v71.visuals.custom_scope_overlay:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.home.select_tab
        }), 
        v71.visuals.custom_scope_overlay.size:depend(v71.visuals.custom_scope_overlay), 
        v71.visuals.custom_scope_overlay.gap:depend(v71.visuals.custom_scope_overlay), 
        v71.visuals.custom_scope_overlay.inverted:depend(v71.visuals.custom_scope_overlay), 
        v71.visuals.custom_scope_overlay.t_pose:depend(v71.visuals.custom_scope_overlay), 
        v71.visuals.custom_scope_overlay.scope_color:depend(v71.visuals.custom_scope_overlay), 
        v71.visuals.custom_scope_overlay.viewmodel_in_scope:depend(v71.visuals.custom_scope_overlay), 
        v71.visuals.hitmarker:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.home.select_tab
        }), 
        v71.visuals.hitmarker.hitmarker_color:depend(v71.visuals.hitmarker), 
        v71.visuals.watermark:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.home.select_tab
        }), 
        v71.visuals.watermark.style:depend(v71.visuals.watermark), 
        v71.visuals.watermark.watermark_color:depend(v71.visuals.watermark), 
        v71.visuals.keybinds:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.home.select_tab
        }), 
        v71.visuals.keybinds.keybinds_color:depend(v71.visuals.keybinds), 
        v71.visuals.spectators:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.home.select_tab
        }), 
        v71.visuals.spectators.spectators_color:depend(v71.visuals.spectators), 
        v71.visuals.velocity_indicator:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.home.select_tab
        }), 
        v71.visuals.velocity_indicator.velocity_indicator_color:depend(v71.visuals.velocity_indicator), 
        v71.visuals.animated_zoom:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.home.select_tab
        }), 
        v71.visuals.client_side_animations:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.home.select_tab
        }), 
        v71.visuals.client_side_animations.ground_legs:depend(v71.visuals.client_side_animations), 
        v71.visuals.client_side_animations.air_legs:depend(v71.visuals.client_side_animations), 
        v71.visuals.client_side_animations.addons:depend(v71.visuals.client_side_animations), 
        v71.visuals.client_side_animations.move_lean_amount:depend(v71.visuals.client_side_animations, {
            [1] = nil, 
            [2] = "Move Lean", 
            [1] = v71.visuals.client_side_animations.addons
        }), 
        v71.visuals.grenade_warning:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.home.select_tab
        })
    }, 
    misc_depend = {
        v71.misc.in_game.trashtalk:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        }), 
        v71.misc.in_game.clantag:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        }), 
        v71.misc.in_game.aspect_ratio:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        }), 
        v71.misc.in_game.aspect_ratio.ratio:depend(v71.misc.in_game.aspect_ratio), 
        v71.misc.in_game.aspect_ratio.button_16_10:depend(v71.misc.in_game.aspect_ratio), 
        v71.misc.in_game.aspect_ratio.button_16_9:depend(v71.misc.in_game.aspect_ratio), 
        v71.misc.in_game.aspect_ratio.button_5_4:depend(v71.misc.in_game.aspect_ratio), 
        v71.misc.in_game.aspect_ratio.button_4_3:depend(v71.misc.in_game.aspect_ratio), 
        v71.misc.in_game.aspect_ratio.button_3_2:depend(v71.misc.in_game.aspect_ratio), 
        v71.misc.in_game.viewmodel_changer:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        }), 
        v71.misc.in_game.viewmodel_changer.viewmodel_fov:depend(v71.misc.in_game.viewmodel_changer), 
        v71.misc.in_game.viewmodel_changer.viewmodel_x:depend(v71.misc.in_game.viewmodel_changer), 
        v71.misc.in_game.viewmodel_changer.viewmodel_y:depend(v71.misc.in_game.viewmodel_changer), 
        v71.misc.in_game.viewmodel_changer.viewmodel_z:depend(v71.misc.in_game.viewmodel_changer), 
        v71.misc.in_game.viewmodel_changer.viewmodel_reset:depend(v71.misc.in_game.viewmodel_changer), 
        v71.misc.in_game.keep_model_transparency:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        }), 
        v71.misc.movement.no_fall_damage:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        }), 
        v71.misc.movement.fast_ladder:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        }), 
        v71.misc.movement.edge_stop:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        }), 
        v71.misc.movement.jump_scout:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        }), 
        v71.misc.movement.super_toss:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        }), 
        v71.misc.ragebot.aimbot_logs:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        }), 
        v71.misc.ragebot.aimbot_logs.output:depend(v71.misc.ragebot.aimbot_logs), 
        v71.misc.ragebot.aimbot_logs.hit_color:depend(v71.misc.ragebot.aimbot_logs), 
        v71.misc.ragebot.aimbot_logs.miss_color:depend(v71.misc.ragebot.aimbot_logs), 
        v71.misc.ragebot.aimbot_logs.purchase_logs:depend(v71.misc.ragebot.aimbot_logs), 
        v71.misc.ragebot.aimbot_logs.push_notify_log:depend(v71.misc.ragebot.aimbot_logs, {
            [1] = nil, 
            [2] = "Notify", 
            [1] = v71.misc.ragebot.aimbot_logs.output
        }), 
        v71.misc.ragebot.fake_latency:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        }), 
        v71.misc.ragebot.hitchance:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        }), 
        v71.misc.ragebot.hitchance.current_weapon:depend(v71.misc.ragebot.hitchance), 
        v71.misc.ragebot.hitchance.enable_pistols:depend(v71.misc.ragebot.hitchance, {
            [1] = nil, 
            [2] = 1, 
            [1] = v71.misc.ragebot.hitchance.current_weapon
        }), 
        v71.misc.ragebot.hitchance.enable_auto_snipers:depend(v71.misc.ragebot.hitchance, {
            [1] = nil, 
            [2] = 2, 
            [1] = v71.misc.ragebot.hitchance.current_weapon
        }), 
        v71.misc.ragebot.hitchance.enable_awp:depend(v71.misc.ragebot.hitchance, {
            [1] = nil, 
            [2] = 3, 
            [1] = v71.misc.ragebot.hitchance.current_weapon
        }), 
        v71.misc.ragebot.hitchance.enable_ssg08:depend(v71.misc.ragebot.hitchance, {
            [1] = nil, 
            [2] = 4, 
            [1] = v71.misc.ragebot.hitchance.current_weapon
        }), 
        v71.misc.ragebot.hitchance.enable_revolver:depend(v71.misc.ragebot.hitchance, {
            [1] = nil, 
            [2] = 5, 
            [1] = v71.misc.ragebot.hitchance.current_weapon
        }), 
        v71.misc.ragebot.hitchance.pistols_air_amount:depend(v71.misc.ragebot.hitchance, {
            [1] = nil, 
            [2] = 1, 
            [1] = v71.misc.ragebot.hitchance.current_weapon
        }, v71.misc.ragebot.hitchance.enable_pistols), 
        v71.misc.ragebot.hitchance.auto_snipers_air_amount:depend(v71.misc.ragebot.hitchance, {
            [1] = nil, 
            [2] = 2, 
            [1] = v71.misc.ragebot.hitchance.current_weapon
        }, v71.misc.ragebot.hitchance.enable_auto_snipers), 
        v71.misc.ragebot.hitchance.auto_snipers_no_scope_amount:depend(v71.misc.ragebot.hitchance, {
            [1] = nil, 
            [2] = 2, 
            [1] = v71.misc.ragebot.hitchance.current_weapon
        }, v71.misc.ragebot.hitchance.enable_auto_snipers), 
        v71.misc.ragebot.hitchance.awp_air_amount:depend(v71.misc.ragebot.hitchance, {
            [1] = nil, 
            [2] = 3, 
            [1] = v71.misc.ragebot.hitchance.current_weapon
        }, v71.misc.ragebot.hitchance.enable_awp), 
        v71.misc.ragebot.hitchance.awp_no_scope_amount:depend(v71.misc.ragebot.hitchance, {
            [1] = nil, 
            [2] = 3, 
            [1] = v71.misc.ragebot.hitchance.current_weapon
        }, v71.misc.ragebot.hitchance.enable_awp), 
        v71.misc.ragebot.hitchance.ssg08_air_amount:depend(v71.misc.ragebot.hitchance, {
            [1] = nil, 
            [2] = 4, 
            [1] = v71.misc.ragebot.hitchance.current_weapon
        }, v71.misc.ragebot.hitchance.enable_ssg08), 
        v71.misc.ragebot.hitchance.ssg08_no_scope_amount:depend(v71.misc.ragebot.hitchance, {
            [1] = nil, 
            [2] = 4, 
            [1] = v71.misc.ragebot.hitchance.current_weapon
        }, v71.misc.ragebot.hitchance.enable_ssg08), 
        v71.misc.ragebot.hitchance.revolver_air_amount:depend(v71.misc.ragebot.hitchance, {
            [1] = nil, 
            [2] = 5, 
            [1] = v71.misc.ragebot.hitchance.current_weapon
        }, v71.misc.ragebot.hitchance.enable_revolver), 
        v71.misc.ragebot.grenade_throw_fix:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        }), 
        v71.misc.ragebot.decrease_hold_aim_ticks:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.home.select_tab
        })
    }
};
for v104 = 1, #v71.anti_aim_conditions do
    do
        local l_v104_0 = v104;
        enaa = {
            [1] = v71.anti_aim.builder[l_v104_0].enable_state, 
            [2] = function()
                -- upvalues: l_v104_0 (ref), v71 (ref)
                if l_v104_0 == 1 then
                    return true;
                else
                    return v71.anti_aim.builder[l_v104_0].enable_state:get();
                end;
            end
        };
        v71.anti_aim.builder[l_v104_0].enable_state:depend({
            [1] = v71.anti_aim.branch, 
            [2] = function()
                -- upvalues: v71 (ref)
                return v71.anti_aim.branch.value ~= 3;
            end
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = function()
                -- upvalues: v71 (ref)
                return v71.anti_aim.current_state.value ~= "Shared";
            end
        });
        v71.anti_aim.builder[l_v104_0].yaw_amount:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_amount.add_left_yaw:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_amount.add_right_yaw:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_randomize:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_fluctation:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_fluctation.fluctation_phase_time:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, {
            [1] = v71.anti_aim.builder[l_v104_0].yaw_fluctation, 
            [2] = function()
                -- upvalues: v71 (ref), l_v104_0 (ref)
                return v71.anti_aim.builder[l_v104_0].yaw_fluctation.value > 0;
            end
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_fluctation.fluctation_delay_1:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, {
            [1] = v71.anti_aim.builder[l_v104_0].yaw_fluctation, 
            [2] = function()
                -- upvalues: v71 (ref), l_v104_0 (ref)
                return v71.anti_aim.builder[l_v104_0].yaw_fluctation.value > 0;
            end
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_fluctation.fluctation_delay_2:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, {
            [1] = v71.anti_aim.builder[l_v104_0].yaw_fluctation, 
            [2] = function()
                -- upvalues: v71 (ref), l_v104_0 (ref)
                return v71.anti_aim.builder[l_v104_0].yaw_fluctation.value > 0;
            end
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_fluctation.fluctation_delay_3:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, {
            [1] = v71.anti_aim.builder[l_v104_0].yaw_fluctation, 
            [2] = function()
                -- upvalues: v71 (ref), l_v104_0 (ref)
                return v71.anti_aim.builder[l_v104_0].yaw_fluctation.value > 0;
            end
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_jitter:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_jitter.amount:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, {
            [1] = v71.anti_aim.builder[l_v104_0].yaw_jitter, 
            [2] = function()
                -- upvalues: v71 (ref), l_v104_0 (ref)
                return v71.anti_aim.builder[l_v104_0].yaw_jitter.value ~= "Disabled";
            end
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_jitter.randomize:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, {
            [1] = v71.anti_aim.builder[l_v104_0].yaw_jitter, 
            [2] = function()
                -- upvalues: v71 (ref), l_v104_0 (ref)
                return v71.anti_aim.builder[l_v104_0].yaw_jitter.value ~= "Disabled";
            end
        }, enaa);
        v71.anti_aim.builder[l_v104_0].fake_limit:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, enaa);
        v71.anti_aim.builder[l_v104_0].fake_limit_randomize:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, enaa);
        v71.anti_aim.builder[l_v104_0].body_jitter:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, enaa);
        v71.anti_aim.builder[l_v104_0].body_jitter.body_jitter_switch_method:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].body_jitter, enaa);
        v71.anti_aim.builder[l_v104_0].body_jitter.body_jitter_switch_ticks:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].body_jitter, {
            [1] = nil, 
            [2] = "Default", 
            [1] = v71.anti_aim.builder[l_v104_0].body_jitter.body_jitter_switch_method
        }, enaa);
        v71.anti_aim.builder[l_v104_0].body_jitter.body_jitter_switch_minimum:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].body_jitter, {
            [1] = nil, 
            [2] = "Progressive", 
            [1] = v71.anti_aim.builder[l_v104_0].body_jitter.body_jitter_switch_method
        }, enaa);
        v71.anti_aim.builder[l_v104_0].body_jitter.body_jitter_switch_maximum:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].body_jitter, {
            [1] = nil, 
            [2] = "Progressive", 
            [1] = v71.anti_aim.builder[l_v104_0].body_jitter.body_jitter_switch_method
        }, enaa);
        v71.anti_aim.builder[l_v104_0].body_jitter.body_jitter_randomize_switch:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].body_jitter, {
            [1] = v71.anti_aim.builder[l_v104_0].body_jitter.body_jitter_switch_ticks, 
            [2] = function()
                -- upvalues: v71 (ref), l_v104_0 (ref)
                return v71.anti_aim.builder[l_v104_0].body_jitter.body_jitter_switch_ticks.value > 1;
            end
        }, enaa);
        v71.anti_aim.builder[l_v104_0].defensive_aa:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, enaa);
        v71.anti_aim.builder[l_v104_0].pitch:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].defensive_aa, enaa);
        v71.anti_aim.builder[l_v104_0].pitch_random_first:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].defensive_aa, {
            [1] = nil, 
            [2] = "Random", 
            [1] = v71.anti_aim.builder[l_v104_0].pitch
        }, enaa);
        v71.anti_aim.builder[l_v104_0].pitch_random_second:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].defensive_aa, {
            [1] = nil, 
            [2] = "Random", 
            [1] = v71.anti_aim.builder[l_v104_0].pitch
        }, enaa);
        v71.anti_aim.builder[l_v104_0].pitch_custom:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].defensive_aa, {
            [1] = nil, 
            [2] = "Custom", 
            [1] = v71.anti_aim.builder[l_v104_0].pitch
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].defensive_aa, enaa);
        v71.anti_aim.builder[l_v104_0].defensive_yaw_left_amount:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].defensive_aa, {
            [1] = nil, 
            [2] = "L&R\n", 
            [1] = v71.anti_aim.builder[l_v104_0].yaw
        }, enaa);
        v71.anti_aim.builder[l_v104_0].defensive_yaw_right_amount:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].defensive_aa, {
            [1] = nil, 
            [2] = "L&R\n", 
            [1] = v71.anti_aim.builder[l_v104_0].yaw
        }, enaa);
        v71.anti_aim.builder[l_v104_0].defensive_yaw_delay:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].defensive_aa, {
            [1] = nil, 
            [2] = "L&R\n", 
            [1] = v71.anti_aim.builder[l_v104_0].yaw
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_random_first:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].defensive_aa, {
            [1] = nil, 
            [2] = "Random\n", 
            [1] = v71.anti_aim.builder[l_v104_0].yaw
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_random_second:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].defensive_aa, {
            [1] = nil, 
            [2] = "Random\n", 
            [1] = v71.anti_aim.builder[l_v104_0].yaw
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_spin_speed:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].defensive_aa, {
            [1] = nil, 
            [2] = "Spin", 
            [1] = v71.anti_aim.builder[l_v104_0].yaw
        }, enaa);
        v71.anti_aim.builder[l_v104_0].yaw_custom:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v71.anti_aim.branch
        }, {
            [1] = v71.anti_aim.current_state, 
            [2] = v71.anti_aim_conditions[l_v104_0]
        }, v71.anti_aim.builder[l_v104_0].defensive_aa, {
            [1] = nil, 
            [2] = "Custom\n", 
            [1] = v71.anti_aim.builder[l_v104_0].yaw
        }, enaa);
    end;
end;
update_select_tab = function()
    -- upvalues: v71 (ref)
    local l_select_tab_0 = v71.home.select_tab;
    local l_branch_0 = v71.anti_aim.branch;
    local v108 = {
        [1] = {
            [1] = "\194\187  " .. "\a{Link Active}" .. ui.get_icon("person-circle-check") .. "  \aDEFAULTState Builder", 
            [2] = "\v" .. ui.get_icon("cubes") .. "  Defensive Builder"
        }, 
        [2] = {
            [1] = ui.get_icon("person-circle-check") .. "  State Builder", 
            [2] = "\194\187  " .. "\a{Link Active}" .. ui.get_icon("cubes") .. "  \aDEFAULTDefensive Builder"
        }, 
        [3] = {
            [1] = ui.get_icon("person-circle-check") .. "  State Builder", 
            [2] = ui.get_icon("cubes") .. "  \aDEFAULTDefensive Builder"
        }
    };
    local v109 = {
        [1] = {
            [1] = "\194\187  " .. "\a{Link Active}" .. ui.get_icon("paintbrush") .. "  \aDEFAULTVisuals", 
            [2] = "\v" .. ui.get_icon("gears") .. "  Misc"
        }, 
        [2] = {
            [1] = "\v" .. ui.get_icon("paintbrush") .. "  Visuals", 
            [2] = "\194\187  " .. "\a{Link Active}" .. ui.get_icon("gears") .. "  \aDEFAULTMisc"
        }
    };
    l_branch_0:update(v108[l_branch_0:get()]);
    l_select_tab_0:update(v109[l_select_tab_0:get()]);
end;
v71.home.select_tab:set_callback(update_select_tab);
v71.anti_aim.branch:set_callback(update_select_tab);
update_select_tab();
local v110 = {
    player_data = {}
};
v110.player_data.entindex = -1;
v110.player_data.alive = false;
v110.player_data.onground = true;
v110.player_data.velocity = 0;
v110.player_data.duckamount = 0;
v110.player_data.stamina = 80;
v110.player_data.onground_ticks = 0;
v110.player_data.stateid = 1;
v110.player_data.velocity_mod = function(v111)
    local l_m_vecVelocity_0 = v111.m_vecVelocity;
    return (math.sqrt(l_m_vecVelocity_0.x * l_m_vecVelocity_0.x + l_m_vecVelocity_0.y * l_m_vecVelocity_0.y));
end;
v110.player_data.is_onground = function(v113)
    -- upvalues: v110 (ref)
    if not bit.band(v113.m_fFlags, 1) == 0 then
        return false;
    else
        if bit.band(v113.m_fFlags, 1) == 1 then
            v110.player_data.onground_ticks = v110.player_data.onground_ticks + 1;
        else
            v110.player_data.onground_ticks = 0;
        end;
        return v110.player_data.onground_ticks > 4;
    end;
end;
v110.player_data.state_trigger = function(_)
    -- upvalues: v71 (ref), v110 (ref), v61 (ref)
    if v71.anti_aim.manual_yaw:get() ~= "Disabled" then
        return 10;
    elseif v71.anti_aim.freestanding:get() then
        return 9;
    elseif not v110.player_data.onground then
        if v110.player_data.duckamount > 0.5 then
            return 5;
        else
            return 4;
        end;
    else
        local v115 = v61.fake_duck:get();
        if v110.player_data.duckamount > 0.5 or v115 then
            if v110.player_data.velocity > 4 then
                return 7;
            else
                return 6;
            end;
        elseif v61.slow_walk:get() then
            return 8;
        elseif v110.player_data.velocity > 4 then
            return 3;
        else
            return 2;
        end;
    end;
end;
v110.player_data.write_player_data = function()
    -- upvalues: v110 (ref)
    local v116 = entity.get_local_player();
    if v116 == nil then
        return;
    else
        v110.player_data.entindex = v116;
        v110.player_data.alive = v110.player_data.entindex:is_alive();
        if v110.player_data.alive then
            v110.player_data.onground = v110.player_data.is_onground(v110.player_data.entindex);
            v110.player_data.velocity = v110.player_data.velocity_mod(v110.player_data.entindex);
            v110.player_data.duckamount = v110.player_data.entindex.m_flDuckAmount;
            v110.player_data.stamina = v110.player_data.entindex.m_flStamina;
            v110.player_data.stateid = v110.player_data.state_trigger();
        end;
        return;
    end;
end;
is_inverted = false;
is_inverted_defensive = false;
switch = false;
ticks = 1;
current_tickcount = 0;
yaw_offset = 0;
edge_angle = 0;
is_edging = false;
yaw_spin_add = 0;
safe_head_trigger = false;
edge_angle = 0;
is_edging = false;
round_end_trigger = false;
left_value = 0;
right_value = 0;
fluctation_amount = 0;
v110.get_desync_side = function()
    local v117 = entity.get_local_player();
    if v117 == nil then
        return;
    elseif globals.choked_commands ~= 0 then
        return;
    else
        return v117.m_flPoseParameter[11] * 120 - 60 > 0;
    end;
end;
v110.override_defensive = function()
    -- upvalues: v110 (ref), v71 (ref), v61 (ref)
    local v118 = entity.get_local_player();
    if v118 == nil or not v118:is_alive() then
        return;
    else
        local l_stateid_0 = v110.player_data.stateid;
        if v71.anti_aim.force_defensive:get(l_stateid_0 - 1) then
            v61.lag_options:override("Always On");
            v61.hide_shots_options:override("Break LC");
        else
            v61.lag_options:override("On Peek");
            v61.hide_shots_options:override("Favor Fire Rate");
        end;
        return;
    end;
end;
v110.builder = function(v120)
    -- upvalues: v110 (ref), v71 (ref), v61 (ref)
    local v121 = entity.get_local_player();
    if v121 == nil or not v121:is_alive() then
        return;
    else
        local v122 = v121:get_player_weapon();
        if not v122 or v122 == nil then
            return;
        else
            local v123 = v122:get_weapon_info();
            if not v123 or v123 == nil then
                return;
            else
                local v124 = v122:get_classname();
                if not v124 or v124 == nil then
                    return;
                else
                    local v125 = v124 == "CWeaponTaser";
                    local v126 = v124 == "CKnife";
                    local v127 = v123.weapon_type == 9;
                    local l_stateid_1 = v110.player_data.stateid;
                    if not v71.anti_aim.builder[l_stateid_1].enable_state:get() then
                        l_stateid_1 = 1;
                    end;
                    is_inverted = not rage.antiaim:inverter();
                    local v129 = v121:get_origin();
                    local v130 = entity.get_threat();
                    local v131 = v130 ~= nil and v130:get_origin() or v129;
                    if v71.anti_aim.safe_head.triggers:get(1) and v126 and l_stateid_1 == 5 then
                        safe_head_trigger = true;
                    elseif v71.anti_aim.safe_head.triggers:get(2) and v125 and l_stateid_1 == 5 then
                        safe_head_trigger = true;
                    elseif v71.anti_aim.safe_head.triggers:get(3) and v129.z - v131.z > v71.anti_aim.safe_head.height_difference:get() and (l_stateid_1 == 5 or l_stateid_1 == 6 or l_stateid_1 == 7 or l_stateid_1 == 2) then
                        safe_head_trigger = true;
                    else
                        safe_head_trigger = false;
                    end;
                    local v132 = v71.anti_aim.builder[l_stateid_1].body_jitter.body_jitter_switch_method:get() == "Default" and v71.anti_aim.builder[l_stateid_1].body_jitter.body_jitter_switch_ticks:get() > 2;
                    local v133 = v71.anti_aim.builder[l_stateid_1].body_jitter.body_jitter_switch_method:get() == "Progressive" and (not (v71.anti_aim.builder[l_stateid_1].body_jitter.body_jitter_switch_maximum:get() <= 2) or v71.anti_aim.builder[l_stateid_1].body_jitter.body_jitter_switch_minimum:get() > 2);
                    if v71.anti_aim.builder[l_stateid_1].body_jitter:get() and v71.anti_aim.builder[l_stateid_1].yaw_jitter:get() ~= "Offset" and v71.anti_aim.builder[l_stateid_1].yaw_jitter:get() ~= "Spin" and v71.anti_aim.builder[l_stateid_1].yaw_jitter:get() ~= "3-Way" and v71.anti_aim.builder[l_stateid_1].yaw_jitter:get() ~= "5-Way" then
                        if v71.anti_aim.builder[l_stateid_1].body_jitter.body_jitter_switch_method:get() == "Default" then
                            if v132 and globals.tickcount % (v71.anti_aim.builder[l_stateid_1].body_jitter.body_jitter_randomize_switch:get() > 2 and utils.random_int(v71.anti_aim.builder[l_stateid_1].body_jitter.body_jitter_switch_ticks:get(), v71.anti_aim.builder[l_stateid_1].body_jitter.body_jitter_randomize_switch:get()) or v71.anti_aim.builder[l_stateid_1].body_jitter.body_jitter_switch_ticks:get()) == 0 then
                                switch = not switch;
                            end;
                            is_inverted = switch;
                        else
                            if globals.tickcount % (v71.anti_aim.builder[l_stateid_1].body_jitter.body_jitter_randomize_switch:get() > 2 and utils.random_int(ticks, v71.anti_aim.builder[l_stateid_1].body_jitter.body_jitter_randomize_switch:get()) or ticks) == 0 then
                                switch = not switch;
                                if ticks < v71.anti_aim.builder[l_stateid_1].body_jitter.body_jitter_switch_maximum:get() then
                                    ticks = ticks + 1;
                                elseif ticks < v71.anti_aim.builder[l_stateid_1].body_jitter.body_jitter_switch_minimum:get() then
                                    ticks = ticks + 1;
                                else
                                    ticks = ticks - 1;
                                end;
                            end;
                            is_inverted = switch;
                        end;
                        if (v132 or v133) and v71.anti_aim.builder[l_stateid_1].yaw_jitter:get() ~= "Offset" and v71.anti_aim.builder[l_stateid_1].yaw_jitter:get() ~= "Spin" and v71.anti_aim.builder[l_stateid_1].yaw_jitter:get() ~= "3-Way" and v71.anti_aim.builder[l_stateid_1].yaw_jitter:get() ~= "5-Way" then
                            rage.antiaim:inverter(is_inverted);
                        end;
                        v61.body_yaw.options:override("Jitter");
                    else
                        v61.body_yaw.options:override("");
                    end;
                    v61.body_yaw:override(true);
                    v61.body_yaw.left_limit:override(v71.anti_aim.builder[l_stateid_1].fake_limit:get() - utils.random_int(0, v71.anti_aim.builder[l_stateid_1].fake_limit_randomize:get() / 2));
                    v61.body_yaw.right_limit:override(v71.anti_aim.builder[l_stateid_1].fake_limit:get() - utils.random_int(0, v71.anti_aim.builder[l_stateid_1].fake_limit_randomize:get() / 2));
                    v61.pitch:override("Down");
                    v61.yaw:override("Backward");
                    v61.yaw.base:override("At Target");
                    v61.yaw.avoid_backstab:override(v71.anti_aim.avoid_backstab:get());
                    if v71.anti_aim.builder[l_stateid_1].yaw_fluctation:get() > 0 then
                        if globals.tickcount % v71.anti_aim.builder[l_stateid_1].yaw_fluctation.fluctation_phase_time:get() == v71.anti_aim.builder[l_stateid_1].yaw_fluctation.fluctation_delay_1:get() then
                            left_value = v71.anti_aim.builder[l_stateid_1].yaw_amount.add_left_yaw:get() + utils.random_int(0, v71.anti_aim.builder[l_stateid_1].yaw_fluctation:get() / 2);
                            right_value = v71.anti_aim.builder[l_stateid_1].yaw_amount.add_right_yaw:get() + utils.random_int(0, v71.anti_aim.builder[l_stateid_1].yaw_fluctation:get() / 2);
                        elseif globals.tickcount % v71.anti_aim.builder[l_stateid_1].yaw_fluctation.fluctation_phase_time:get() == v71.anti_aim.builder[l_stateid_1].yaw_fluctation.fluctation_delay_2:get() then
                            left_value = v71.anti_aim.builder[l_stateid_1].yaw_amount.add_left_yaw:get() - utils.random_int(0, v71.anti_aim.builder[l_stateid_1].yaw_fluctation:get() / 2);
                            right_value = v71.anti_aim.builder[l_stateid_1].yaw_amount.add_right_yaw:get() - utils.random_int(0, v71.anti_aim.builder[l_stateid_1].yaw_fluctation:get() / 2);
                        elseif globals.tickcount % v71.anti_aim.builder[l_stateid_1].yaw_fluctation.fluctation_phase_time:get() == v71.anti_aim.builder[l_stateid_1].yaw_fluctation.fluctation_delay_3:get() then
                            left_value = v71.anti_aim.builder[l_stateid_1].yaw_amount.add_left_yaw:get() + (utils.random_int(0, v71.anti_aim.builder[l_stateid_1].yaw_fluctation:get() / 2) - utils.random_int(0, v71.anti_aim.builder[l_stateid_1].yaw_fluctation:get() / 2 + 15)) / 2;
                            right_value = v71.anti_aim.builder[l_stateid_1].yaw_amount.add_right_yaw:get() + (utils.random_int(0, v71.anti_aim.builder[l_stateid_1].yaw_fluctation:get() / 2) - utils.random_int(0, v71.anti_aim.builder[l_stateid_1].yaw_fluctation:get() / 2 + 15)) / 2;
                        end;
                    else
                        left_value = v71.anti_aim.builder[l_stateid_1].yaw_amount.add_left_yaw:get();
                        right_value = v71.anti_aim.builder[l_stateid_1].yaw_amount.add_right_yaw:get();
                    end;
                    if v132 or v133 then
                        yaw_offset = (rage.antiaim:inverter() and left_value or right_value) + utils.random_int(0, v71.anti_aim.builder[l_stateid_1].yaw_randomize:get() / 2) + v71.anti_aim.builder[l_stateid_1].yaw_amount:get();
                    elseif globals.choked_commands == 0 then
                        yaw_offset = (v110.get_desync_side() and left_value or right_value) + utils.random_int(0, v71.anti_aim.builder[l_stateid_1].yaw_randomize:get() / 2) + v71.anti_aim.builder[l_stateid_1].yaw_amount:get();
                    end;
                    if v132 or v133 then
                        if v71.anti_aim.builder[l_stateid_1].yaw_jitter:get() ~= "Disabled" then
                            v61.yaw_modifier:override("Disabled");
                            v61.yaw_modifier.offset:override(0);
                            if v71.anti_aim.builder[l_stateid_1].yaw_jitter:get() == "Center" then
                                yaw_offset = (rage.antiaim:inverter() and v71.anti_aim.builder[l_stateid_1].yaw_jitter.amount:get() / 2 or -v71.anti_aim.builder[l_stateid_1].yaw_jitter.amount:get() / 2) + yaw_offset + utils.random_int(0, v71.anti_aim.builder[l_stateid_1].yaw_jitter.randomize:get() / 2) + v71.anti_aim.builder[l_stateid_1].yaw_amount:get();
                            elseif v71.anti_aim.builder[l_stateid_1].yaw_jitter:get() == "Random" then
                                yaw_offset = (rage.antiaim:inverter() and utils.random_int(v71.anti_aim.builder[l_stateid_1].yaw_jitter.amount:get() / 2, v71.anti_aim.builder[l_stateid_1].yaw_jitter.amount:get() / 2 - 15) or utils.random_int(-v71.anti_aim.builder[l_stateid_1].yaw_jitter.amount:get() / 2, -v71.anti_aim.builder[l_stateid_1].yaw_jitter.amount:get() / 2 + 15)) + v71.anti_aim.builder[l_stateid_1].yaw_amount:get();
                            end;
                        else
                            v61.yaw_modifier:override("Disabled");
                            v61.yaw_modifier.offset:override(0);
                        end;
                    else
                        v61.yaw_modifier:override(v71.anti_aim.builder[l_stateid_1].yaw_jitter:get());
                        v61.yaw_modifier.offset:override(v71.anti_aim.builder[l_stateid_1].yaw_jitter.amount:get() + utils.random_float(0, v71.anti_aim.builder[l_stateid_1].yaw_jitter.randomize:get() / 2));
                    end;
                    v61.yaw.offset:override(yaw_offset);
                    if v71.anti_aim.builder[l_stateid_1].defensive_aa:get() and not safe_head_trigger and not v127 then
                        v61.yaw.hidden:override(true);
                        v61.lag_options:override("Always On");
                        v61.hide_shots_options:override("Break LC");
                        if v71.anti_aim.builder[l_stateid_1].pitch:get() == "Disabled" then
                            rage.antiaim:override_hidden_pitch(0);
                        elseif v71.anti_aim.builder[l_stateid_1].pitch:get() == "Down" then
                            rage.antiaim:override_hidden_pitch(89);
                        elseif v71.anti_aim.builder[l_stateid_1].pitch:get() == "Up" then
                            rage.antiaim:override_hidden_pitch(-89);
                        elseif v71.anti_aim.builder[l_stateid_1].pitch:get() == "Random" then
                            rage.antiaim:override_hidden_pitch(utils.random_float(v71.anti_aim.builder[l_stateid_1].pitch_random_first:get(), v71.anti_aim.builder[l_stateid_1].pitch_random_second:get()));
                        elseif v71.anti_aim.builder[l_stateid_1].pitch:get() == "Custom" then
                            rage.antiaim:override_hidden_pitch(v71.anti_aim.builder[l_stateid_1].pitch_custom:get());
                        end;
                        if v71.anti_aim.builder[l_stateid_1].yaw:get() == "L&R\n" then
                            if v71.anti_aim.builder[l_stateid_1].defensive_yaw_delay:get() > 2 then
                                if globals.tickcount % v71.anti_aim.builder[l_stateid_1].defensive_yaw_delay:get() == 0 then
                                    is_inverted_defensive = not is_inverted_defensive;
                                end;
                                rage.antiaim:override_hidden_yaw_offset(is_inverted_defensive and v71.anti_aim.builder[l_stateid_1].defensive_yaw_left_amount:get() or v71.anti_aim.builder[l_stateid_1].defensive_yaw_right_amount:get());
                            elseif globals.choked_commands == 0 then
                                rage.antiaim:override_hidden_yaw_offset(v110.get_desync_side() and v71.anti_aim.builder[l_stateid_1].defensive_yaw_left_amount:get() or v71.anti_aim.builder[l_stateid_1].defensive_yaw_right_amount:get());
                            end;
                        elseif v71.anti_aim.builder[l_stateid_1].yaw:get() == "Forward" then
                            rage.antiaim:override_hidden_yaw_offset(180);
                        elseif v71.anti_aim.builder[l_stateid_1].yaw:get() == "Sideways" then
                            rage.antiaim:override_hidden_yaw_offset(is_inverted and -120 or 120);
                        elseif v71.anti_aim.builder[l_stateid_1].yaw:get() == "Random\n" then
                            rage.antiaim:override_hidden_yaw_offset(utils.random_float(v71.anti_aim.builder[l_stateid_1].yaw_random_first:get(), v71.anti_aim.builder[l_stateid_1].yaw_random_second:get()));
                        elseif v71.anti_aim.builder[l_stateid_1].yaw:get() == "Spin" then
                            if yaw_spin_add >= 180 then
                                yaw_spin_add = -180;
                            else
                                yaw_spin_add = yaw_spin_add + v71.anti_aim.builder[l_stateid_1].yaw_spin_speed:get() + 15;
                            end;
                            rage.antiaim:override_hidden_yaw_offset(yaw_spin_add);
                        elseif v71.anti_aim.builder[l_stateid_1].yaw:get() == "Custom\n" then
                            rage.antiaim:override_hidden_yaw_offset(v71.anti_aim.builder[l_stateid_1].yaw_custom:get());
                        end;
                    else
                        v61.yaw.hidden:override(false);
                    end;
                    safe_head_values = function()
                        -- upvalues: v61 (ref)
                        v61.yaw.offset:override(0);
                        v61.yaw.hidden:override(false);
                        v61.yaw_modifier:override("Disabled");
                        v61.yaw_modifier.offset:override(0);
                        v61.body_yaw:override(true);
                        v61.body_yaw.left_limit:override(0);
                        v61.body_yaw.right_limit:override(0);
                        v61.body_yaw.options:override("");
                        rage.antiaim:inverter(false);
                    end;
                    if v71.anti_aim.safe_head:get() and safe_head_trigger then
                        safe_head_values();
                    end;
                    if v71.anti_aim.force_defensive:get(l_stateid_1 + 1) then
                        if v71.anti_aim.force_defensive.method:get() == 1 and v71.anti_aim.force_defensive.always_on:get() then
                            v120.force_defensive = true;
                        elseif v71.anti_aim.force_defensive.method:get() == 2 then
                            v120.force_defensive = v120.command_number % v71.anti_aim.force_defensive.custom_ticks:get() == 0;
                        elseif v71.anti_aim.force_defensive.method:get() == 3 then
                            v120.force_defensive = v120.command_number % utils.random_int(v71.anti_aim.force_defensive.random_ticks_first:get(), v71.anti_aim.force_defensive.random_ticks_second:get()) == 0;
                        end;
                    end;
                    if v71.anti_aim.flick_exploit:get() and v61.slow_walk:get() then
                        rage.antiaim:inverter(true);
                        v61.yaw.hidden:override(true);
                        v61.yaw_modifier:override("Disabled");
                        v61.yaw_modifier.offset:override(0);
                        v61.body_yaw.options:override("");
                        rage.antiaim:override_hidden_pitch(89);
                        rage.antiaim:override_hidden_yaw_offset(v71.anti_aim.flick_exploit.inverter:get() and 120 or -120);
                        v61.yaw.offset:override(v71.anti_aim.flick_exploit.inverter:get() and 20 or -20);
                        v120.force_defensive = v120.command_number % 8 == 0;
                        v61.lag_options:override("Always On");
                        v61.hide_shots_options:override("Break LC");
                    end;
                    if v71.anti_aim.lag_exploit:get() and (l_stateid_1 == 4 or l_stateid_1 == 5) then
                        if globals.tickcount % v71.anti_aim.lag_exploit.ticks:get() == 0 then
                            rage.exploit:force_teleport();
                        else
                            rage.exploit:force_charge();
                        end;
                    end;
                    edge_trigger = function()
                        -- upvalues: v120 (ref), v121 (ref)
                        is_edging = false;
                        if v120.send_packet then
                            vecTraceStart = v121:get_eye_position();
                        end;
                        local v134 = {};
                        local v135 = render.camera_angles();
                        local v136 = {};
                        for v137 = 18, 360, 18 do
                            v137 = math.normalize_yaw(v137);
                            local v138 = vecTraceStart + vector():angles(0, v137) * 198;
                            local v139 = utils.trace_line(vecTraceStart, v138, player, 1174421507);
                            table.insert(v136, vecTraceStart:dist(v139.end_pos));
                            local l_fraction_0 = v139.fraction;
                            local l_entity_0 = v139.entity;
                            if l_entity_0 and l_entity_0:get_classname() == "CWorld" and l_fraction_0 < 0.3 then
                                v134[#v134 + 1] = {
                                    vecTraceEnd = v138, 
                                    flYaw = v137
                                };
                            end;
                        end;
                        table.sort(v136);
                        if v136[1] > 30 then
                            return;
                        else
                            table.sort(v134, function(v142, v143)
                                return v142.flYaw < v143.flYaw;
                            end);
                            table.remove(v134, #v134);
                            local v144 = nil;
                            if #v134 >= 3 then
                                local v145 = v134[1].vecTraceEnd:lerp(v134[#v134].vecTraceEnd, 0.5);
                                v144 = (vecTraceStart - v145):angles();
                            end;
                            if v144 then
                                local l_y_0 = v135.y;
                                local l_y_1 = v144.y;
                                local v148 = math.normalize_yaw(l_y_1 - l_y_0);
                                if math.abs(v148) < 90 then
                                    v148 = 0;
                                    l_y_0 = math.normalize_yaw(l_y_1 + 180);
                                end;
                                local v149 = -l_y_0;
                                edge_angle = math.normalize_yaw(v149 + l_y_1 + v148 + 180);
                                is_edging = true;
                            end;
                            return;
                        end;
                    end;
                    edge_trigger();
                    disablers_values = function()
                        -- upvalues: v61 (ref)
                        v61.pitch:override("Disabled");
                        v61.yaw.offset:override(globals.tickcount % 360 * 15);
                        v61.yaw.hidden:override(false);
                        v61.yaw_modifier:override("Disabled");
                        v61.yaw_modifier.offset:override(0);
                        v61.body_yaw:override(false);
                        v61.body_yaw.left_limit:override(0);
                        v61.body_yaw.right_limit:override(0);
                        v61.body_yaw.options:override("");
                    end;
                    if v71.anti_aim.disablers:get(1) and entity.get_game_rules().m_bWarmupPeriod then
                        disablers_values();
                    elseif v71.anti_aim.disablers:get(2) and round_end_trigger then
                        disablers_values();
                    end;
                    return;
                end;
            end;
        end;
    end;
end;
v110.addons = function()
    -- upvalues: v71 (ref), v61 (ref)
    local v150 = entity.get_local_player();
    if v150 == nil or not v150:is_alive() then
        return;
    else
        if v71.anti_aim.manual_yaw:get() ~= "Disabled" then
            v61.yaw.base:override("Local View");
            if v71.anti_aim.manual_yaw:get() == "Left" then
                v61.yaw.offset:override(-90);
            elseif v71.anti_aim.manual_yaw:get() == "Right" then
                v61.yaw.offset:override(90);
            elseif v71.anti_aim.manual_yaw:get() == "Forward" then
                v61.yaw.offset:override(180);
            end;
        end;
        if v71.anti_aim.manual_yaw:get() ~= "Disabled" and v71.anti_aim.manual_yaw.manual_over_fs:get() then
            v61.freestanding:override(false);
            v61.freestanding.disable_yaw_modifiers:override(false);
            v61.freestanding.body_freestanding:override(false);
        else
            v61.freestanding:override(v71.anti_aim.freestanding:get());
            v61.freestanding.disable_yaw_modifiers:override(v71.anti_aim.freestanding.disable_yaw_modifiers:get());
            v61.freestanding.body_freestanding:override(v71.anti_aim.freestanding.body_freestanding:get());
        end;
        if v71.anti_aim.edge_yaw:get() and is_edging and (v71.anti_aim.manual_yaw:get() == "Disabled" or not v71.anti_aim.edge_yaw.ignore_manuals:get()) then
            v61.yaw.offset:override(edge_angle);
            v61.yaw_modifier:override("Disabled");
            v61.yaw_modifier.offset:override(0);
            v61.yaw.hidden:override(false);
        end;
        v61.yaw.avoid_backstab:override(v71.anti_aim.avoid_backstab:get());
        return;
    end;
end;
local l_x_1 = render.screen_size().x;
local l_y_2 = render.screen_size().y;
local v175 = {
    animated_text = function(v153, v154, v155, v156, v157)
        local v158 = v155 and color(v155.r, v155.g, v155.b, v157) or color(255, 200, 255, v157);
        local v159 = v156 and color(v156.r, v156.g, v156.b, v157) or color(100, 100, 100, v157);
        local v160 = "";
        for v161 = 1, #v153 + 1 do
            local v162 = v153:sub(v161, v161);
            local v163 = (v161 - 1) / (#v153 - 1);
            local v164 = globals.realtime * 2 % math.pi;
            local v165 = v154 or 1;
            local v166 = math.sin(v164 * v165 + (v163 or 0));
            v160 = ("%s\a%s%s"):format(v160, v158:lerp(v159, (math.abs(v166))):to_hex(), v162);
        end;
        return v160;
    end, 
    mouse_check = function(v167, v168)
        if ui.get_alpha() < 1 then
            return false;
        else
            local v169 = ui.get_mouse_position();
            return v169.x >= v167.x and v169.x <= v168.x and v169.y >= v167.y and v169.y <= v168.y;
        end;
    end, 
    get_bind = function(v170)
        local v171 = false;
        local v172 = 0;
        local v173 = ui.get_binds();
        for v174 = 1, #v173 do
            if v173[v174].name == v170 and v173[v174].active then
                v171 = true;
                v172 = v173[v174].value;
            end;
        end;
        return {
            [1] = v171, 
            [2] = v172
        };
    end, 
    fonts = {
        verdana = render.load_font("Verdana", 16, "ad"), 
        verdana_bold = render.load_font("Verdana", 21, "bad"), 
        calibri_bold = render.load_font("Calibri Bold", 24, "ad")
    }
};
local v176 = render.load_image("\137PNG\r\n\026\n\000\000\000\rIHDR\000\000\000d\000\000\000\\\b\003\000\000\000\175\021\224\166\000\000\000\001sRGB\001\217\201,\127\000\000\000\tpHYs\000\000\v\019\000\000\v\019\001\000\154\156\024\000\000\002\223PLTE\000\000\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255v\153it\000\000\000\245tRNS\000\001C\147X\006Z\251\255\253\150\004\213\249\002\014\227\024\022\234+\027\2396)sr\030\242?uk \235\2442!\246G/\231\2267^\183\015#\248Q\b\179\154}\247c\000pz\193%n-\224b\252\194(v\174\136\v\201]~\250\233'\\\223\0181\132\216\140\207\151:\138\003\172\218\028l.B\143{\161K\149\016\202\019U=\0263\nNi\130\187A\199\128\135\145\158\166\170\134\127_&\220\254I\232\023\195F\137\146\186,\192\184\163\159\168\175\177\181\188\212|\243\157$\r\142[\005\217\209\153\241\204\203\155O\020\206\197\205\0250\245\a\222\021\164\029\017\229\131*\160q\214\208\198\185\169mR5\221\f\228d\237\191\196\141w\133\139\144\238\230\165x\236\t`\031\129\171\156\1528aJ\1784L\219\167\210E9S\176\240\189\148M\180DT>\162\"Yj\225\215\173@H;\190et4r\001\212\000\000\anIDATx\156\237\154\249[\212F\024\199\179\"2+\139\138X\208B\229\016T(B\017p\017\017\016\149\"(V,\136\020\005\228\180\028\197 `E\188Q\001\161\136\136\162\162xq\021\021\v\136x\v\021T\020\207\nx\182\181\213Z\219\218\235\015hf&\187\155\132\221%\134\165\207\211>\190\191d\231\155\247}?9f\146w&K\016\002L4@k\160\182\144\1927\177A:@<\184\159\025\186\018\000\128\222\144\254\133\f\029FA\128~\255B\134\027@\200\136\254\133\188c\b!F\154K8r\212\187=\014\217\216\004B\222\227\168\162\145\163M\205\0041\244\205\001\176\024\195\017-\173 d,G\0297\030\000k\027!\144\247a:\219\tl\209\206\030\170\031\176E\135\137Pt\020\002\177\019\195P'\142\232\f\197I,M\234\162\003\197\201B \132+\f\021\179o\203\020=(\186\177\180\169\227\161\230n&\b\226\225\t\131\167905/\164MgJ\1863\160\004f\nb\016\222\031\162h\031\1666\002I\179\024\138\212\195\023J~\179\133A\1369(\163\255\\\134\244\017\146\2301\020\203\000$\205\023\252\168\249\024\197\a2\226\131\144\178@!\004/DJ\200'B\025D(\186\003\022\139\020\202b\1482L!\140E\002\b\023\204\144\221\149\b\133\178\004\t\145\242v\020\246\136\142\017\014!\198\196B\139S\bK\145\240\169\188\029\159\144\232\150\228\248Yr\031\024o\237\127cR\227P\219e\131D\178f\130\169\155\019I\146)\203#\177\005\166\166\165\243\180\136@\024\160\181\226s\151\149\025l\134\254tw\170W\219{\225\150\003i\0154a\171\024}|\200\148\249\1712\145\186\026\vnb\1410\168'\181\183\140a\182`\r\173\025\172\197\202:\r1\128\243z\156\208{\131\191L\178ZBc\253\213\005\190\145\133\162|\027\205\229B\214&\217\185\025\240\203\016\176yKv\142\194\"\178\211r\211\023n\205\155\152\191%\235\139\002\236\178\r\229\147Gx\146Q\242\155T\200\aa\161\246m\020\139\157R\152\016\207\237E\f\015^}\203z\a\015H1\003\226\183s\023\211\131W\231*\217\1654;\027\162%\135\024jq\ne>\f \017)\201\205\133\004\162\006\245\138\2032\210\229x\240\130\236V\199\144A\246\160\198\222\210\213\\\004O\200>>\144\253\168Qv@\137\a/\200A>\144\237\170=xA\014\241\129\164\246\017\018\r=c\226\014\031\017\137\202+f\014%*\195K\141\2275\r)\128\158\185\133:U\213\195\253\128\213rbR\166x\141bBACr\250\b\145H)\207/\0010\1699z\f\150u\199\169\159\181\\\200\137\190B\2248\177\252*+\214Adc\016\184\150\152\189\160\196g\130\166!uj\139\\\rA\002\130\255\005H\136\218E\014\026\130\v\217\241\195\170J\n\234\2475\184\158\156\145\222\184g\222\169\166\211KE\252 g\028x@\178U\028\180\161\027?\136\251Y\030\1444UWf\149J\1369\170y\246\226\198\185(\030\144tU\016\019U\144\204\243(D\130[\023\212.\164\244\006\137V\005\1858\129\t\017_\202kn\025\205\176\150\201\219f\145I_\167l\184\220\220\186\209\150\003\017[\180]q/\145H\014\187\230_m\189f\218\020\163\002\210nD\\/R@xY#\130\028\245V\210\221\149\a\180JE\2257\004A\148\154\204\197j\243\172\184\142\202\168Q\168QeF\148_\024\203\128\024\238'o\230\154P\221\172\153$\179\157\169n\1775)\233\150\0145J\195H\242\182/_H\189\017~\141\215\192\134\175\135\148\184\003\2382 \247\224>\018\1282\184\r\003zA\212F\186\005\180u\192\246I\236\147\219\027\164t(nI\191\129\173\251\193Dg;X\196\128\160\197\173.\000:\241\214\031\213\189\129\160\027=\t\"\177\207\131^ z\176\160\220q\249\161D\210N\181*:\b\221\019xiN\006\129gE<\002\000M>\031\211\213\203m\176\170\018n\181\248A\242\168\031\218\247\233\132\153\205T\030g6\228\017tm\002\224\t\220.\161\235\176[t\209\151\141}\210z\129\192K~O\214\005\252k\b\"\021\176!\167j)s\002 \220L\191\186\166\017T\148\r\175^Zt\b\152\aA\157\158\024\\\237\005r\154\186\027\r2\200dj\134\225*\145H\236\168\189y\018\019\021\029\182\167\225\a\228\001eo\005\180\127\0285;\170\163}\205\217\207\169\193\188!\248Q\223\176\220X\005\004\206_\002i\223\167\236\2537\145\168S%\t\248\150\218zvKJ,\160` \169k\1636\206%\146\238\n:\016\215]V\160\221\173Gy\142\246\195\005\178\140v\236\219\016K\027\236\213F\177\223!\1779FZi3\r\000\199\179\196\245\228n\000\190\175\021\233\006\237\005\190\231\227\137\029\207\218p ^\127\132\135\240\195]e\144h\216%\203\031Z\177N\031\222\248\131\244o8\248\136\213\000\160:(\020\248\161Zt\006\176F\195+\021\251\224\021\029<\169\n\235\232\t\017\255\b\127\206\029\240<6\150\005\145\202z\215c\184?\025\128\169p\251\002\004\160\154z?=N\232\219\134\215\166\134\225FHS0\023\002\206X\210M\017\251Ld\144\197p_\023=^d\1311\130\030\249?a\159\021(A\183,<\253\165\148\003\001u\003\241\027\214L9\164\v\238\243\001\224g\184}\005\174\160\213\194<p\f\245Dz\020\135\163\004\151\229\243\195\170\004.\004\000\251\137\197$\025\246\vPj\005\023)+\001\224\215\173\2179\233\212\173\v\137\200y\144o\b|/A\221\016\251\188\194\t-\159\202\186\027(\158\203\133\244\213<\159\208\025w%\148f\210Z>=\r\180\214\020d\141\151\252\234T'\214\209SQzy\239t\183\250X\222\214\200,e\143\\\195\a/\251@0\213\189O\185\197\021\021\021\133\006~U\191\217\177F\006a\214\178\207\1760W>k\030\017\219\023kJ~\253\250\197\166\145Jf\138\218\157q\241=\213\183\246_1o\023\146$\157|\024\139\253/Ih\191+\132?\160\v9]mU\174\222\018\209w$\2413\133\242\002\245\221\249\n\2259\238\205\166\194!\165(\193no\133b\131\148\020\133\160\189\f)\209jg1\234l\016\138\247e~\186,GR\018C\233D\175*O7n0O\187\142\015\210\145\185\022\213\243s\211\144\227H\170W\182x\195\195n\160;r\193\146\169y\161\167_\vS\138\169G\020\015a\144?Q\240$)S\203@e\188\v\203\2399\002\175\019\244W\128\181\232Dl\217k\005Eh\2212\145\165iG@\205\190K\bd%\f=W\203\022\241\183_\206\165\233@\175\140@!\1442\0249\135#v\160\242n'G\253\139\186`:\161B \186\145V\134N\220\133\149\0264\241\230|`&\028\254\014(\189\167\185\191g\028A%\227z\141\229Sj\213~\016\162\193\127\022(3\252G\f\203\222\029\251b\186p\150\225\171v\209[\003VLA\166\2453\131\136iM\191\147\209\187\155\220\254\001Q\1440+D^\186l\000\000\000\000IEND\174B`\130", vector(32, 27));
do
    local l_v176_0 = v176;
    v175.render_gradient_text = function(v178, v179, v180, v181, v182)
        -- upvalues: v71 (ref), l_y_2 (ref), l_v176_0 (ref)
        local l_x_2 = render.measure_text(v178, nil, v179).x;
        if v71.visuals.gamesense_indicators.style:get() == "Classic" then
            render.gradient(vector(30 + l_x_2 / 2, l_y_2 - 310 - v181), vector(45 + (v182 and l_v176_0.width or 0) + l_x_2, l_y_2 - 275 - v181), color(0, 0, 0, v180.a - 190), color(0, 0, 0, 0), color(0, 0, 0, v180.a - 190), color(0, 0, 0, 0));
            render.gradient(vector(30 + l_x_2 / 2, l_y_2 - 310 - v181), vector(15, l_y_2 - 275 - v181), color(0, 0, 0, v180.a - 190), color(0, 0, 0, 0), color(0, 0, 0, v180.a - 190), color(0, 0, 0, 0));
            render.text(v178, vector(30 + (v182 and l_v176_0.width + 5 or 0), l_y_2 - 303 - v181), v180, nil, v179);
        else
            render.gradient(vector(10, l_y_2 - 310 - v181), vector(45 + (v182 and l_v176_0.width or 0) + l_x_2, l_y_2 - 275 - v181), color(0, 0, 0, v180.a - 190), color(0, 0, 0, 0), color(0, 0, 0, v180.a - 190), color(0, 0, 0, 0));
            render.rect(vector(10, l_y_2 - 275 - v181), vector(15, l_y_2 - 310 - v181), v180, 0, true);
            render.text(v178, vector(30 + (v182 and l_v176_0.width + 5 or 0), l_y_2 - 303 - v181), v180, nil, v179);
        end;
        if v182 then
            render.texture(l_v176_0, vector(30, l_y_2 - 307 - v181), v180);
        end;
    end;
    v175.watermark = function()
        -- upvalues: v71 (ref), l_x_1 (ref), l_y_2 (ref)
        local v184 = entity.get_local_player();
        if v184 == nil then
            return;
        elseif common.get_username() == nil then
            return;
        else
            local v185 = utils.net_channel();
            if v185 == nil then
                return;
            else
                local v186 = v185.avg_latency[1] * 1000;
                local v187 = v184:get_steam_avatar();
                local v188 = v71.visuals.watermark.watermark_color:get();
                local v189 = common.get_username();
                local _ = render.measure_text(2, nil, v189:upper());
                if not v71.visuals.watermark:get() then
                    if not v71.visuals.centered_indicators:get() then
                        render.text(4, vector(l_x_1 / 2, l_y_2 - 15), color(255), "c", "*\224\169\136\226\156\169\226\128\167\226\130\138\203\154\224\188\186 nyahook \224\188\187*\224\169\136\226\156\169\226\128\167\226\130\138\203\154");
                    end;
                elseif v71.visuals.watermark.style:get() == "Modern" then
                    render.texture(v187, vector(10, l_y_2 / 2 + 25), vector(25, 25));
                    render.text(2, vector(38, l_y_2 / 2 + 26), color(255, 180, 226, 255), nil, "NYA");
                    render.text(2, vector(render.measure_text(2, nil, "nya").x + 38, l_y_2 / 2 + 26), color(255), nil, "HOOK [DEBUG]");
                    render.text(2, vector(38, l_y_2 / 2 + 36), color(255), nil, "USERNAME: " .. v189:upper());
                elseif v71.visuals.watermark.style:get() == "Classic" then
                    local v191 = common.get_system_time();
                    local v192 = string.format("%02d:%02d:%02d", v191.hours, v191.minutes, v191.seconds);
                    local v193 = "Nyahook | " .. common.get_username() .. " | delay: " .. math.floor(v186) .. "ms | " .. v192 .. "";
                    render.rect(vector(l_x_1 - 15 - render.measure_text(1, nil, v193).x, 8), vector(l_x_1 - 7, 10), color(v71.visuals.watermark.watermark_color:get().r, v71.visuals.watermark.watermark_color:get().g, v71.visuals.watermark.watermark_color:get().b, 150), 0);
                    render.rect(vector(l_x_1 - 15 - render.measure_text(1, nil, v193).x, 10), vector(l_x_1 - 7, 30), color(10, 10, 10, 105), 0);
                    render.text(1, vector(l_x_1 - render.measure_text(1, nil, v193).x - 10, 13), color(255, 255, 255, 255), nil, v193);
                elseif v71.visuals.watermark.style:get() == "Minimalistic" then
                    render.text(1, vector(l_x_1 - render.measure_text(1, nil, "nyahook ~ debug : username: " .. common.get_username()).x - 7, 5), v188, nil, "nya");
                    render.text(1, vector(l_x_1 - render.measure_text(1, nil, "hook ~ debug : username: " .. common.get_username()).x - 7, 5), color(255), nil, "hook ~ debug : username: " .. common.get_username());
                    render.text(1, vector(l_x_1 - render.measure_text(1, nil, "latency: " .. math.floor(v186) .. "ms").x - 7, 15), color(255), nil, "latency: " .. math.floor(v186) .. "ms");
                end;
                return;
            end;
        end;
    end;
    local _ = nil;
    local v195 = 0;
    do
        local l_v195_0 = v195;
        v36.new("keybinds", nil, vector(300, 400), nil)(function(v197)
            -- upvalues: v71 (ref), v10 (ref), l_v195_0 (ref)
            if not v71.visuals.keybinds:get() then
                return;
            else
                local v198 = ui.get_binds();
                local v199 = 0;
                local _ = 0;
                local v201 = 0;
                local v202 = "";
                local v203 = 0;
                local v204 = "";
                local v205 = false;
                local v206 = 150;
                for v207, v208 in pairs(v198) do
                    v205 = v208.active ~= nil;
                    if v208.name == "Double Tap" then
                        v204 = "Double Nya";
                        v202 = v208.mode == 1 and "holding" or "toggled";
                    elseif v208.name == "Hide Shots" then
                        v204 = "Hide Nya";
                        v202 = v208.mode == 1 and "holding" or "toggled";
                    elseif v208.name == "Min. Damage" then
                        v204 = "Min. Nya";
                        v202 = v208.value;
                    else
                        v204 = v208.name;
                        v202 = v208.mode == 1 and "holding" or "toggled";
                    end;
                    v201 = render.measure_text(1, nil, v204).y;
                    local v209 = v10.new("animated_add_y_" .. v204, v208.active and 255 or 0, 0.1);
                    v199 = v199 + (v207 ~= 1 and 14 or 10) * v209 / 255;
                    if v203 < render.measure_text(1, nil, "[" .. v202 .. "]").x + render.measure_text(1, nil, v204).x then
                        v203 = render.measure_text(1, nil, "[" .. v202 .. "]").x + render.measure_text(1, nil, v204).x;
                    end;
                    if v206 < v203 and v203 then
                        v206 = v203;
                    end;
                    render.text(1, vector(v197.position.x + 2, v197.position.y + v199 + 10), color(255, 255, 255, v209), nil, v204);
                    render.text(1, vector(v197.position.x + v206 - render.measure_text(1, nil, "[" .. v202 .. "]").x, v197.position.y + v199 + 10), color(255, 255, 255, v209), nil, "[" .. v202 .. "]");
                end;
                l_v195_0 = v206;
                local v210 = v10.new("animated_alpha_rect", ui.get_alpha() > 0 and 255 or v205 and 255 or 0, 0.1);
                render.rect(v197.position, v197.position - 2 + vector(l_v195_0, 0) + vector(2, 20), color(10, 10, 10, v210 - 150), 1);
                render.rect(v197.position, v197.position - 2 - vector(0, 20) + vector(l_v195_0 + 2, 0), color(v71.visuals.keybinds.keybinds_color:get().r, v71.visuals.keybinds.keybinds_color:get().g, v71.visuals.keybinds.keybinds_color:get().b, v210), 1);
                render.text(1, vector(v197.position.x + l_v195_0 / 2 - 20, v197.position.y + 3), color(255, 255, 255, v210), nil, "keybinds");
                v197.size = vector(l_v195_0, 20);
                return;
            end;
        end);
    end;
    v195 = nil;
    local v211 = 0;
    local v212 = 150;
    do
        local l_v211_0, l_v212_0 = v211, v212;
        v36.new("spectators", nil, vector(500, 400), nil)(function(v215)
            -- upvalues: v71 (ref), v10 (ref), l_v212_0 (ref), l_v211_0 (ref)
            get_spectators = function()
                local v216 = entity.get_local_player();
                if v216 == nil then
                    return;
                elseif v216:is_alive() then
                    return v216:get_spectators();
                else
                    local l_m_hObserverTarget_0 = v216.m_hObserverTarget;
                    if l_m_hObserverTarget_0 ~= nil then
                        return l_m_hObserverTarget_0:get_spectators();
                    else
                        return;
                    end;
                end;
            end;
            if not v71.visuals.spectators:get() then
                return;
            else
                local v218 = get_spectators();
                if v218 == nil then
                    return;
                else
                    local v219 = 0;
                    local v220 = 0;
                    local v221 = 0;
                    local v222 = 0;
                    for _, v224 in pairs(v218) do
                        local v225 = v224:get_name();
                        local v226 = v224:get_steam_avatar();
                        v220 = render.measure_text(1, nil, v225).y;
                        v222 = v10.new("animated_spectators_" .. v225, #v218 > 0 and 255 or 0, 0.1);
                        v219 = v219 + 18 * v222 / 255;
                        if v221 < render.measure_text(1, nil, v225).x + 16 then
                            v221 = render.measure_text(1, nil, v225).x + 16;
                        end;
                        local v227;
                        if l_v212_0 >= v221 or not v221 then
                            v227 = l_v212_0;
                        else
                            v227 = v221;
                        end;
                        l_v212_0 = v227;
                        render.text(1, vector(v215.position.x + 25, v215.position.y + v219 + 4), color(255, 255, 255, v222), nil, v225);
                        render.texture(v226, vector(v215.position.x + 2, v215.position.y + v219 + 2), vector(16, 16), color(255, 255, 255, v222), "", 4);
                    end;
                    l_v211_0 = l_v212_0;
                    local v228 = v10.new("animated_alpha_rect_spectators", ui.get_alpha() > 0 and 255 or #v218 > 0 and 255 or 0, 0.1);
                    render.rect(v215.position, v215.position - 2 + vector(l_v211_0, 20), color(10, 10, 10, v228 - 150), 1);
                    render.rect(v215.position, v215.position - 2 - vector(0, 20) + vector(l_v211_0, 0), color(v71.visuals.spectators.spectators_color:get().r, v71.visuals.spectators.spectators_color:get().g, v71.visuals.spectators.spectators_color:get().b, v228), 1);
                    render.text(1, vector(v215.position.x + l_v211_0 / 2 - 28 + 2, v215.position.y + 3), color(255, 255, 255, v228), nil, "spectators");
                    v215.size = vector(l_v211_0, 20);
                    return;
                end;
            end;
        end);
    end;
    v211 = nil;
    v36.new("velocity", 2, vector(l_x_1 / 2 - 100, 200), {
        [1] = {
            "x", 
            vector(l_x_1 * 0.5, 0), 
            vector(l_x_1 * 0.5, l_y_2)
        }
    })(function(v229)
        -- upvalues: v71 (ref), v10 (ref)
        local v230 = entity.get_local_player();
        if v230 == nil or not v230:is_alive() then
            return;
        elseif not v71.visuals.velocity_indicator:get() then
            return;
        else
            local v231 = v10.new("velocity_modifier2", ui.get_alpha() > 0 and v230.m_flVelocityModifier * 0.5 or v230.m_flVelocityModifier, 0.05);
            local v232 = v10.new("velocity_alpha", ui.get_alpha() > 0 and 255 or v230.m_flVelocityModifier < 1 and 255 or 0, 0.1);
            render.text(1, v229.position + vector(100, 10), color(255, 255, 255, v232), "c", string.format("Max velocity reduced by %s%%", math.floor(v231 * 100)));
            render.rect(vector(v229.position.x + 5, v229.position.y + 19), vector(v229.position.x - 5 + 200, v229.position.y + 22), color(0, 0, 0, v232), 0);
            render.rect(vector(v229.position.x + 5, v229.position.y + 19), vector(v229.position.x - 5 + math.floor(v231 * 200), v229.position.y + 22), color(v71.visuals.velocity_indicator.velocity_indicator_color:get().r, v71.visuals.velocity_indicator.velocity_indicator_color:get().g, v71.visuals.velocity_indicator.velocity_indicator_color:get().b, v232), 0);
            v229.size = vector(200, 30);
            return;
        end;
    end);
    v212 = "total_hits";
    local v233 = "total_registered_shots";
    local v234 = 0;
    v175[v233] = 0;
    v175[v212] = v234;
    v175.gamesense_indicators = function()
        -- upvalues: v71 (ref), v10 (ref), v175 (ref), v61 (ref), l_bomb_0 (ref), l_v176_0 (ref), l_y_2 (ref)
        local v235 = entity.get_local_player();
        if v235 == nil or not v235:is_alive() then
            return;
        elseif not v71.visuals.gamesense_indicators:get() then
            return;
        else
            local v236 = 0;
            local v237 = 0;
            local v238 = v71.visuals.gamesense_indicators.animated:get();
            local v239 = v238 and v10.new("charged_color", rage.exploit:get() == 1 and color(200) or color(255, 0, 0), 0.05) or rage.exploit:get() == 1 and color(200) or color(255, 0, 0);
            local v240 = #entity.get_players(true, false) ~= #entity.get_players(true, true);
            local v241 = v10.new("dormant_color", v240 and color(200) or color(255, 0, 0), 0.05);
            v175.percent = v175.total_hits > 0 and v175.total_registered_shots > 0 and v175.total_hits / v175.total_registered_shots * 100 or 0;
            local v242 = v71.visuals.gamesense_indicators.style:get() == "Modern";
            local v243 = {
                [1] = "\239\162\144", 
                [2] = nil, 
                [3] = "\238\146\191", 
                [4] = "\239\154\144", 
                [5] = "\238\140\190", 
                [6] = "\239\149\140", 
                [7] = "\238\137\138", 
                [8] = "\238\147\129", 
                [9] = "\239\129\176", 
                [2] = rage.exploit:get() == 1 and "\238\135\171" or "\238\135\169"
            };
            local v244 = {
                [1] = {
                    "Meow", 
                    color(200), 
                    v71.visuals.gamesense_indicators.select:get("Hit/Miss Rate")
                }, 
                [2] = {
                    [1] = "DT", 
                    [2] = color(v239.r, v239.g, v239.b, 255), 
                    [3] = v71.visuals.gamesense_indicators.select:get("Double Tap") and v61.doubletap:get()
                }, 
                [3] = {
                    [1] = "OS-AA", 
                    [2] = color(200), 
                    [3] = v71.visuals.gamesense_indicators.select:get("Hide Shots") and v61.hide_shots:get() and not v61.doubletap:get()
                }, 
                [4] = {
                    [1] = "PING", 
                    [2] = color(150, 190, 50, 255), 
                    [3] = v71.visuals.gamesense_indicators.select:get("Fake Latency") and v61.fake_latency:get() > 0
                }, 
                [5] = {
                    [1] = "MD", 
                    [2] = color(200), 
                    [3] = v71.visuals.gamesense_indicators.select:get("Min. Damage Override") and v175.get_bind("Min. Damage")[1]
                }, 
                [6] = {
                    [1] = "BODY", 
                    [2] = color(200), 
                    [3] = v71.visuals.gamesense_indicators.select:get("Body Aim") and v61.body_aim:get() == "Force"
                }, 
                [7] = {
                    [1] = "SAFE", 
                    [2] = color(200), 
                    [3] = v71.visuals.gamesense_indicators.select:get("Force Safe Point") and v61.safe_point:get() == "Force"
                }, 
                [8] = {
                    [1] = "FS", 
                    [2] = color(200), 
                    [3] = v71.visuals.gamesense_indicators.select:get("Freestanding") and v61.freestanding:get_override()
                }, 
                [9] = {
                    [1] = "DA", 
                    [2] = color(v241.r, v241.g, v241.b, 255), 
                    [3] = v71.visuals.gamesense_indicators.select:get("Dormant Aimbot") and v61.dormant_aimbot:get()
                }
            };
            local v245 = v238 and v10.new("bomb_alpha", v71.visuals.gamesense_indicators.select:get("Bomb Information") and l_bomb_0.state ~= nil and 255 or 0, 0.05) or l_bomb_0.state ~= nil and 255 or 0;
            local v246 = v238 and v10.new("bomb_alpha_damage", v71.visuals.gamesense_indicators.select:get("Bomb Information") and l_bomb_0.dmg == "-0 HP" and 0 or l_bomb_0.state == true and 255 or 0, 0.05) or l_bomb_0.dmg == "-0 HP" and 0 or l_bomb_0.state == true and 255 or 0;
            local v247 = v238 and v10.new("bomb_circle_alpha", v71.visuals.gamesense_indicators.select:get("Bomb Information") and l_bomb_0.state == false and 255 or 0, 0.05) or l_bomb_0.state == false and 255 or 0;
            v236 = v236 + 41 * v245 / 255 + 41 * v246 / 255;
            local v248 = string.format("%d/%d (%.1f)", v175.total_hits, v175.total_registered_shots, v175.percent);
            for v249, v250 in pairs(v244) do
                local v251 = v238 and v10.new("animated_alpha_gamesense_" .. v250[1], v250[3] and 255 or 0, 0.05) or v250[3] and 255 or 0;
                v236 = v236 + 41 * v251 / 255;
                if v251 > 0 then
                    v175.render_gradient_text(v175.fonts.calibri_bold, (v242 and v243[v249] .. "  " or "") .. (v250[1] == "Meow" and v248 or v250[1]), color(v250[2].r, v250[2].g, v250[2].b, v251), v236, false);
                end;
            end;
            if l_bomb_0.state ~= nil and l_bomb_0.site ~= nil then
                local v252;
                if l_bomb_0.state ~= nil then
                    v252 = l_bomb_0.site == "B" and "B" or "A";
                else
                    v252 = l_bomb_0.site;
                end;
                local v253 = l_bomb_0.state == true and v252 .. " - " .. string.format("%.1f", l_bomb_0.c4time) .. "s" or v252;
                v237 = v237 + 41 * v245 / 255;
                add_y_gamesense_bomb_damage = v237 + 41 * v246 / 255;
                local v254 = v238 and v10.new("bomb_color", v71.visuals.gamesense_indicators.select:get("Bomb Information") and l_bomb_0.state == false and color(255, 240, 140) or color(200) or 0, 0.05) or l_bomb_0.state == false and color(255, 240, 140) or color(200);
                local v255 = v238 and v10.new("bomb_damage_color", v71.visuals.gamesense_indicators.select:get("Bomb Information") and l_bomb_0.dmg == "FATAL" and color(255, 0, 0) or color(255, 240, 100) or 0, 0.05) or l_bomb_0.dmg == "FATAL" and color(255, 0, 0) or color(255, 240, 100);
                v175.render_gradient_text(v175.fonts.calibri_bold, l_bomb_0.dmg, color(v255.r, v255.g, v255.b, v246), add_y_gamesense_bomb_damage, false);
                v175.render_gradient_text(v175.fonts.calibri_bold, v253, color(v254.r, v254.g, v254.b, v245), v237, true);
                render.circle_outline(vector(50 + l_v176_0.width + render.measure_text(v175.fonts.calibri_bold, nil, v253).x, l_y_2 - 292 - v237), color(0, 0, 0, v247), 10, 0, 1, 3);
                render.circle_outline(vector(50 + l_v176_0.width + render.measure_text(v175.fonts.calibri_bold, nil, v253).x, l_y_2 - 292 - v237), color(200, 200, 200, v247), 10, 0, l_bomb_0.plant_percentage, 3);
            end;
            return;
        end;
    end;
    v175.centered_indicators = function()
        -- upvalues: v71 (ref), v10 (ref), v110 (ref), l_x_1 (ref), l_y_2 (ref), v175 (ref), v61 (ref)
        local v256 = entity.get_local_player();
        if v256 == nil or not v256:is_alive() then
            return;
        elseif not v71.visuals.centered_indicators:get() then
            return;
        else
            local v257 = 0;
            local l_m_bIsScoped_0 = v256.m_bIsScoped;
            local v259 = v10.new("scope_add", l_m_bIsScoped_0 and 105 or 0, 0.05);
            local v260 = math.min(v259, 100) / 100;
            local l_stateid_2 = v110.player_data.stateid;
            if l_stateid_2 == nil then
                return;
            else
                local l_x_3 = render.measure_text(2, "c", "N Y A H O O K").x;
                local l_x_4 = render.measure_text(2, nil, v71.anti_aim_conditions[l_stateid_2]:upper()).x;
                local v264 = v71.visuals.centered_indicators.centered_indicators_color:get();
                local v265 = v71.visuals.centered_indicators.offset:get();
                render.text(2, vector(l_x_1 / 2 + (l_x_3 + 5) / 2 * v260, l_y_2 / 2 + 20 + v265), color(255), "c", v175.animated_text("N Y A H O O K", -1, color(90, 90, 90, l_m_bIsScoped_0 and 150 or 255), v264, 255));
                local v266 = v10.new("measured_state", l_x_4, 0.2);
                v175.crosshair_indicators_tbl = {
                    [1] = {
                        "DT", 
                        v61.doubletap:get()
                    }, 
                    [2] = {
                        [1] = "OS-AA", 
                        [2] = not v61.doubletap:get() and v61.hide_shots:get()
                    }, 
                    [3] = {
                        [1] = "DMG", 
                        [2] = v175.get_bind("Min. Damage")[1]
                    }
                };
                for _, v268 in ipairs(v175.crosshair_indicators_tbl) do
                    local l_x_5 = render.measure_text(2, nil, v268[1]).x;
                    local v270 = v10.new("bind_" .. v268[1], v268[2] and 255 or 0, 0.05);
                    local v271 = math.min(v270, 100) / 100;
                    v257 = v257 + 10 * v271;
                    if v271 > 0.01 then
                        render.text(2, vector(l_x_1 / 2 + (l_x_5 + 5) / 2 * v260, l_y_2 / 2 + 20 + v257 + v265), color(255, 255, 255, (l_m_bIsScoped_0 and 150 or 255) * v271), "c", v268[1]);
                    end;
                end;
                render.text(2, vector(l_x_1 / 2 - v266 / 2 + (v266 / 2 + 2) * v260, l_y_2 / 2 + 24 + v257 + v265), color(255, 255, 255, l_m_bIsScoped_0 and 150 or 255), nil, v71.anti_aim_conditions[l_stateid_2]:upper());
                return;
            end;
        end;
    end;
    v175.manual_arrows = function()
        -- upvalues: v71 (ref), v10 (ref), v175 (ref), l_x_1 (ref), l_y_2 (ref)
        local v272 = entity.get_local_player();
        if v272 == nil or not v272:is_alive() then
            return;
        elseif not v71.visuals.manual_arrows:get() then
            return;
        else
            local v273 = v71.visuals.manual_arrows.arrows_color:get();
            local l_m_bIsScoped_1 = v272.m_bIsScoped;
            local v275 = {
                r1 = v10.new("r1", v71.anti_aim.manual_yaw:get() == "Right" and v273.r or 255, 0.1), 
                g1 = v10.new("g1", v71.anti_aim.manual_yaw:get() == "Right" and v273.g or 255, 0.1), 
                b1 = v10.new("b1", v71.anti_aim.manual_yaw:get() == "Right" and v273.b or 255, 0.1), 
                r2 = v10.new("r2", v71.anti_aim.manual_yaw:get() == "Left" and v273.r or 255, 0.1), 
                g2 = v10.new("g2", v71.anti_aim.manual_yaw:get() == "Left" and v273.g or 255, 0.1), 
                b2 = v10.new("b2", v71.anti_aim.manual_yaw:get() == "Left" and v273.b or 255, 0.1), 
                alpha = v10.new("a1", l_m_bIsScoped_1 and 0 or v71.anti_aim.manual_yaw:get() ~= "Disabled" and 255 or 0, 0.1)
            };
            if ui.get_alpha() > 0 then
                if v71.visuals.manual_arrows.arrows_style:get() == "Classic" then
                    render.text(v175.fonts.verdana_bold, vector(l_x_1 / 2 + v71.visuals.manual_arrows.offset:get(), l_y_2 / 2), color(v275.r1, v275.g1, v275.b1, ui.get_alpha() * 200), "c", ">");
                    render.text(v175.fonts.verdana_bold, vector(l_x_1 / 2 - v71.visuals.manual_arrows.offset:get() + 2, l_y_2 / 2), color(v275.r2, v275.g2, v275.b2, ui.get_alpha() * 200), "c", "<");
                else
                    render.text(v175.fonts.verdana, vector(l_x_1 / 2 + v71.visuals.manual_arrows.offset:get(), l_y_2 / 2), color(v275.r1, v275.g1, v275.b1, ui.get_alpha() * 200), "c", "\226\157\177");
                    render.text(v175.fonts.verdana, vector(l_x_1 / 2 - v71.visuals.manual_arrows.offset:get() + 2, l_y_2 / 2), color(v275.r2, v275.g2, v275.b2, ui.get_alpha() * 200), "c", "\226\157\176");
                end;
            elseif v71.visuals.manual_arrows.arrows_style:get() == "Classic" then
                render.text(v175.fonts.verdana_bold, vector(l_x_1 / 2 + v71.visuals.manual_arrows.offset:get(), l_y_2 / 2), color(v275.r1, v275.g1, v275.b1, v275.alpha), "c", ">");
                render.text(v175.fonts.verdana_bold, vector(l_x_1 / 2 - v71.visuals.manual_arrows.offset:get() + 2, l_y_2 / 2), color(v275.r2, v275.g2, v275.b2, v275.alpha), "c", "<");
            else
                render.text(v175.fonts.verdana, vector(l_x_1 / 2 + v71.visuals.manual_arrows.offset:get(), l_y_2 / 2), color(v275.r1, v275.g1, v275.b1, v275.alpha), "c", "\226\157\177");
                render.text(v175.fonts.verdana, vector(l_x_1 / 2 - v71.visuals.manual_arrows.offset:get() + 2, l_y_2 / 2), color(v275.r2, v275.g2, v275.b2, v275.alpha), "c", "\226\157\176");
            end;
            return;
        end;
    end;
    v212 = nil;
    v36.new("damage_indicator", 2, vector(l_x_1 / 2 + 3, l_y_2 / 2 - 20), nil, {
        [1] = v26 * 0.5 - vector(50, 50), 
        [2] = v26 * 0.5 + vector(50, 50)
    })(function(v276)
        -- upvalues: v71 (ref), v61 (ref)
        local v277 = entity.get_local_player();
        if v277 == nil or not v277:is_alive() then
            return;
        elseif not v71.visuals.damage_indicator:get() then
            return;
        else
            local v278 = v61.minimum_damage:get() > 0 and v61.minimum_damage:get() or "AUTO";
            local v279 = {
                Bold = 4, 
                Default = 1, 
                Pixel = 2
            };
            render.text(v279[v71.visuals.damage_indicator.font:get()], v276.position + vector(4, 3), color(255), nil, v278);
            v276.size = vector(render.measure_text(v279[v71.visuals.damage_indicator.font:get()], nil, v278).x + 8, 18);
            return;
        end;
    end);
    v175.custom_scope_overlay = function()
        -- upvalues: v71 (ref), v61 (ref), v10 (ref), l_x_1 (ref), l_y_2 (ref)
        local v280 = entity.get_local_player();
        if v280 == nil or not v280:is_alive() then
            return;
        elseif not v71.visuals.custom_scope_overlay:get() then
            v61.override_zoom.force_viewmodel:override(false);
            v61.override_zoom.scope_overlay:override("Remove Overlay");
            return;
        else
            if v71.visuals.custom_scope_overlay:get() then
                v61.override_zoom.scope_overlay:override("Remove All");
            else
                v61.override_zoom.scope_overlay:override("Remove Overlay");
            end;
            if v71.visuals.custom_scope_overlay.viewmodel_in_scope:get() then
                v61.override_zoom.force_viewmodel:override(true);
            else
                v61.override_zoom.force_viewmodel:override(false);
            end;
            size_scope_overlay = v10.new("size_scope_overlay", v280.m_bIsScoped and v71.visuals.custom_scope_overlay.size:get() or 0, 0.1);
            gap_scope_overlay = v10.new("gap_scope_overlay", v280.m_bIsScoped and v71.visuals.custom_scope_overlay.gap:get() or 0, 0.1);
            first_scope_color = color(v71.visuals.custom_scope_overlay.scope_color:get().r, v71.visuals.custom_scope_overlay.scope_color:get().g, v71.visuals.custom_scope_overlay.scope_color:get().b, v71.visuals.custom_scope_overlay.inverted:get() and 0 or v71.visuals.custom_scope_overlay.scope_color:get().a);
            second_scope_color = color(v71.visuals.custom_scope_overlay.scope_color:get().r, v71.visuals.custom_scope_overlay.scope_color:get().g, v71.visuals.custom_scope_overlay.scope_color:get().b, v71.visuals.custom_scope_overlay.inverted:get() and v71.visuals.custom_scope_overlay.scope_color:get().a or 0);
            render.gradient(vector(l_x_1 / 2 - gap_scope_overlay + 1, l_y_2 / 2), vector(l_x_1 / 2 - gap_scope_overlay - size_scope_overlay, l_y_2 / 2 + 1), first_scope_color, second_scope_color, first_scope_color, second_scope_color);
            render.gradient(vector(l_x_1 / 2 + gap_scope_overlay, l_y_2 / 2), vector(l_x_1 / 2 + gap_scope_overlay + size_scope_overlay, l_y_2 / 2 + 1), first_scope_color, second_scope_color, first_scope_color, second_scope_color);
            render.gradient(vector(l_x_1 / 2, l_y_2 / 2 + gap_scope_overlay + 1), vector(l_x_1 / 2 + 1, l_y_2 / 2 + gap_scope_overlay + size_scope_overlay), first_scope_color, first_scope_color, second_scope_color, second_scope_color);
            if not v71.visuals.custom_scope_overlay.t_pose:get() then
                render.gradient(vector(l_x_1 / 2, l_y_2 / 2 - gap_scope_overlay), vector(l_x_1 / 2 + 1, l_y_2 / 2 - gap_scope_overlay - size_scope_overlay), first_scope_color, first_scope_color, second_scope_color, second_scope_color);
            end;
            return;
        end;
    end;
    v175.hitmarker_refs = {
        hitmarker_alpha = 255, 
        hitmarker_ack = function(v281)
            -- upvalues: v175 (ref)
            local v282 = entity.get(v281.target);
            if not v282 or v282 == nil then
                return;
            else
                if v281.state == nil then
                    shot_hit = true;
                    v175.hitmarker_refs.hitmarker_alpha = 255;
                end;
                return;
            end;
        end
    };
    v175.hitmarker = function()
        -- upvalues: v71 (ref), v175 (ref), l_x_1 (ref), l_y_2 (ref)
        if not v71.visuals.hitmarker:get() then
            return;
        else
            if shot_hit then
                v175.hitmarker_refs.hitmarker_alpha = v175.hitmarker_refs.hitmarker_alpha - 1;
                if v175.hitmarker_refs.hitmarker_alpha < 25 then
                    shot_hit = false;
                end;
            end;
            if shot_hit then
                render.line(vector(l_x_1 / 2 - 8, l_y_2 / 2 - 8), vector(l_x_1 / 2 - 4, l_y_2 / 2 - 4), color(v71.visuals.hitmarker.hitmarker_color:get().r, v71.visuals.hitmarker.hitmarker_color:get().g, v71.visuals.hitmarker.hitmarker_color:get().b, v175.hitmarker_refs.hitmarker_alpha));
                render.line(vector(l_x_1 / 2 - 8, l_y_2 / 2 + 8), vector(l_x_1 / 2 - 4, l_y_2 / 2 + 4), color(v71.visuals.hitmarker.hitmarker_color:get().r, v71.visuals.hitmarker.hitmarker_color:get().g, v71.visuals.hitmarker.hitmarker_color:get().b, v175.hitmarker_refs.hitmarker_alpha));
                render.line(vector(l_x_1 / 2 + 8, l_y_2 / 2 + 8), vector(l_x_1 / 2 + 4, l_y_2 / 2 + 4), color(v71.visuals.hitmarker.hitmarker_color:get().r, v71.visuals.hitmarker.hitmarker_color:get().g, v71.visuals.hitmarker.hitmarker_color:get().b, v175.hitmarker_refs.hitmarker_alpha));
                render.line(vector(l_x_1 / 2 + 8, l_y_2 / 2 - 8), vector(l_x_1 / 2 + 4, l_y_2 / 2 - 4), color(v71.visuals.hitmarker.hitmarker_color:get().r, v71.visuals.hitmarker.hitmarker_color:get().g, v71.visuals.hitmarker.hitmarker_color:get().b, v175.hitmarker_refs.hitmarker_alpha));
            end;
            return;
        end;
    end;
    v175.animated_zoom = function(v283)
        -- upvalues: v71 (ref), v61 (ref), v10 (ref)
        local v284 = entity.get_local_player();
        if v284 == nil or not v284:is_alive() then
            return;
        else
            local v285 = v284:get_player_weapon();
            if v285 == nil then
                return;
            else
                local l_m_zoomLevel_0 = v285.m_zoomLevel;
                local l_m_bIsScoped_2 = v284.m_bIsScoped;
                local v288 = 0;
                if not v71.visuals.animated_zoom:get() then
                    return;
                else
                    if l_m_bIsScoped_2 then
                        if l_m_zoomLevel_0 == 1 then
                            v288 = v61.override_zoom:get();
                        elseif l_m_zoomLevel_0 == 2 then
                            v288 = v61.override_zoom:get() * 2;
                        end;
                    end;
                    v283.fov = v10.new("animated_fov", v61.field_of_view:get() - v288);
                    return;
                end;
            end;
        end;
    end;
    v175.client_side_animations = function()
        -- upvalues: v71 (ref), v6 (ref), v5 (ref), v61 (ref)
        local v289 = entity.get_local_player();
        if v289 == nil or not v289:is_alive() then
            return;
        elseif v289:get_index() == nil then
            return;
        elseif not v71.visuals.client_side_animations:get() then
            return;
        else
            v6 = v5(v289:get_index());
            local v290 = v289:get_anim_state();
            if v290 == nil then
                return;
            else
                move = math.sqrt(v289.m_vecVelocity.x ^ 2 + v289.m_vecVelocity.y ^ 2) > 5;
                jump = bit.band(v289.m_fFlags, 1) == 0;
                if v71.visuals.client_side_animations.ground_legs:get() == "Reversed" then
                    v289.m_flPoseParameter[0] = 1;
                    v61.legs_movement:override("Sliding");
                elseif v71.visuals.client_side_animations.ground_legs:get() == "Jitter" then
                    v289.m_flPoseParameter[0] = utils.random_float(0.1, 1);
                    v61.legs_movement:override("Sliding");
                elseif v71.visuals.client_side_animations.ground_legs:get() == "Moonwalk" and move and not jump then
                    v289.m_flPoseParameter[7] = 1;
                    v61.legs_movement:override("Walking");
                end;
                if v71.visuals.client_side_animations.air_legs:get() == "Static" then
                    v289.m_flPoseParameter[6] = 1;
                elseif v71.visuals.client_side_animations.air_legs:get() == "Jitter" then
                    v289.m_flPoseParameter[6] = globals.tickcount % 4 > 1 and math.random(math.random(0.1, 5), 5) / 10 or math.random(0.1, 1);
                elseif v71.visuals.client_side_animations.air_legs:get() == "Moonwalk" and jump and move then
                    ffi.cast("animstate_layer_t**", ffi.cast("uintptr_t", v6) + 10640)[0][6].m_flWeight = 1;
                else
                    v289.m_flPoseParameter[6] = 0;
                end;
                if v71.visuals.client_side_animations.addons:get("Pitch Zero On Land") and v290.landing then
                    v289.m_flPoseParameter[12] = 0.5;
                elseif v71.visuals.client_side_animations.addons:get("Move Lean") and move then
                    ffi.cast("animstate_layer_t**", ffi.cast("uintptr_t", v6) + 10640)[0][12].m_flWeight = v71.visuals.client_side_animations.move_lean_amount:get() / 100;
                elseif v71.visuals.client_side_animations.addons:get("Earthquake") then
                    ffi.cast("animstate_layer_t**", ffi.cast("uintptr_t", v6) + 10640)[0][12].m_flWeight = utils.random_float(0.1, 1);
                end;
                return;
            end;
        end;
    end;
    v175.grenade_warning = function(v291)
        -- upvalues: v71 (ref)
        local v292 = entity.get_local_player();
        if v292 == nil then
            return;
        elseif not v71.visuals.grenade_warning:get() then
            return;
        else
            local l_entity_1 = v291.entity;
            if l_entity_1 == nil then
                return;
            else
                local l_origin_0 = v291.origin;
                local v295 = l_origin_0:to_screen() or render.get_offscreen(l_origin_0, 1, true);
                local l_icon_0 = v291.icon;
                local l_type_0 = v291.type;
                local l_damage_0 = v291.damage;
                local v299 = v292:get_origin();
                local v300 = v299:dist(l_origin_0);
                local v301 = v299:dist(v291.closest_point);
                local v302 = v291.expire_time - globals.curtime;
                local v303 = {
                    Molly = l_entity_1:get_classname() == "CMolotovProjectile" and vector(5, 22) or vector(13, 20), 
                    Frag = vector(7, 20)
                };
                local v304 = {
                    Molly = tostring(math.floor(v301 * 0.08128)), 
                    Frag = l_damage_0
                };
                local v305 = {
                    Molly = l_entity_1:get_classname() == "CMolotovProjectile" and v302 * 0.6666666666666666 or v302 * 0.14035087719298245, 
                    Frag = v302 * 0.6666666666666666
                };
                local v306 = {
                    Molly = v300 < 220 and 60 or 0, 
                    Frag = v292.m_iHealth < l_damage_0 and 60 or 0
                };
                render.circle(v295, color(10, 10, 10, 220), 30, 0, 1);
                render.shadow(v295, v295 + 1, color(255, 0, 0, 255), v306[l_type_0], 1, 100);
                render.shadow(v295, v295 + 1, color(255, 0, 0, 255), v306[l_type_0], 1, 100);
                render.shadow(v295, v295 + 1, color(255, 0, 0, 255), v306[l_type_0], 1, 100);
                render.shadow(v295, v295 + 1, color(255, 0, 0, 255), v306[l_type_0], 1, 100);
                render.circle_outline(v295, color(255), 30, 0, v305[l_type_0], 2);
                render.texture(l_icon_0, v295 - v303[l_type_0], color(255));
                render.text(4, v295 + vector(0, 13), color(255, 255, 255, 255), "c", v304[l_type_0]);
                return false;
            end;
        end;
    end;
end;
v176 = {
    super_toss_references = {
        get_throw_toss = function(v307, v308, v309, v310)
            v307.x = v307.x - 10 + math.abs(v307.x) / 9;
            local v311 = vector():angles(v307);
            local v312 = v310 * 1.25;
            local v313 = math.clamp(v308 * 0.9, 15, 750);
            local v314 = math.clamp(v309, 0, 1);
            v313 = v313 * math.lerp(0.3, 1, v314);
            local l_v311_0 = v311;
            for _ = 1, 8 do
                l_v311_0 = (v311 * (l_v311_0 * v313 + v312):length() - v312) / v313;
                l_v311_0:normalize();
            end;
            local v317 = l_v311_0.angles(l_v311_0);
            if v317.x > -10 then
                v317.x = 0.9 * v317.x + 9;
            else
                v317.x = 1.125 * v317.x + 11.25;
            end;
            return v317;
        end
    }
};
v176.in_game = {
    trashtalk = {
        phrases = {
            [1] = "\209\130\208\176\208\186 \209\129\208\187\209\139\209\136\209\140 \209\143 \208\189\208\181 \208\191\208\190\208\189\208\184\208\188\208\176\209\142 \209\130\209\139 \209\133\209\131\208\185 \209\129\208\190\209\129\209\145\209\136\209\140 \208\182\208\181 \208\191\208\184\208\180\209\128", 
            [2] = "\208\177\209\128\208\190\209\131\208\186 \208\181\208\177\208\176\208\189\208\189\209\139\208\185", 
            [3] = "\209\130\209\139 \209\135\209\145 \208\180\208\181\208\178\208\186\208\176 \208\181\208\177\208\176\208\189\208\189\208\176\209\143 \209\133\209\131\209\143 \208\189\208\181 \209\129\208\190\209\129\208\176\208\187\208\176 \208\188\208\190\208\181\208\179\208\190 \208\180\208\176\208\178\208\189\208\190 \208\180\208\176", 
            [4] = "\208\180\208\181\208\185\209\129\209\130\208\178\208\184\209\130\208\181\208\187\209\140\208\189\208\190 \208\190\209\132\208\186 \208\189\208\181 \208\189\208\176\209\129\208\176\209\129\209\139\208\178\208\176\208\185 \209\135\208\188\208\190\209\136\208\189\208\184\208\186", 
            [5] = "\209\137\208\176 \209\143 \209\130\208\181\208\177\208\181 \209\135\208\184\209\129\209\130\208\190 \208\188\208\176\209\130\209\140 \209\130\209\131\209\130 \208\191\208\190\208\181\208\177\209\131 \209\129\209\139\208\189\208\184\209\137\208\186\208\176 \208\181\208\177\208\176\208\189\208\189\208\176\209\143", 
            [6] = "\208\191\209\128\208\190\209\129\209\130\208\190 \209\130\208\181\208\177\208\181 \209\130\209\131\209\130 \209\133\209\131\208\181\208\188 \208\191\208\190 \208\187\208\177\209\131 \209\129\209\130\209\131\209\135\208\176\209\130\209\140 \208\177\209\131\208\180\209\131", 
            [7] = "\208\180\208\176\208\178\208\176\208\185 \208\189\208\181 \208\179\208\190\209\128\208\184 \209\134\208\181\208\187\208\190\209\135\208\189\209\139\208\185 \209\133\209\131\208\181\209\129\208\190\209\129", 
            [8] = "\208\186\208\176\208\186\208\190\208\185 \208\182\208\181 \208\189\208\176\209\133\209\131\208\185 \208\191\208\190\208\183\208\190\209\128", 
            [9] = "\208\180\208\176\208\178\208\176\208\185 \208\177\209\139\209\129\209\130\209\128\208\181\208\181", 
            [10] = "\209\130\208\181 \209\130\209\131\209\130 \208\188\208\176\209\130\209\140 \208\181\208\177\208\176\208\187\208\184 \209\135\208\181\208\187", 
            [11] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129 \209\130\209\139 \208\182\208\181 \208\190\208\177\208\190\209\129\209\128\208\176\208\189\209\139\208\185 \209\129\208\184\208\180\208\184\209\136\209\140 \209\129 \209\130\209\128\209\131\209\129\208\176\208\188\208\184 \208\189\208\176 \208\179\208\190\208\187\208\190\208\178\208\181 \209\133\209\131\208\181\209\129\208\190\209\129 \208\181\208\177\208\176\208\189\208\189\209\139\208\185 \208\184\208\189\209\130\208\181\209\128\208\189\208\181\209\130\208\189\209\139\208\185", 
            [12] = "\209\130\209\139 \209\135\209\145 \209\130\209\131\209\130 \208\181\208\177\208\176\208\187\208\190 \208\190\209\130\208\186\209\128\209\139\208\178\208\181\209\136\209\140 \208\189\208\176\209\133\209\131\208\185 \208\180\208\176\209\131\208\189 \208\181\208\177\208\176\208\189\208\189\209\139\208\185", 
            [13] = "\209\129\208\187\209\139\209\136\209\140 \209\133\209\131\208\185 \208\187\208\190\208\178\208\184", 
            [14] = "\209\130\209\139 \208\180\208\190\208\187\208\177\208\176\208\181\208\177 \208\177\208\181\208\183 \208\189\208\184\208\182\208\189\208\181\208\179\208\190 \209\128\209\143\208\180\208\176 \208\183\209\131\208\177\208\190\208\178 \209\128\208\190\208\180\208\184\208\187\209\129\209\143", 
            [15] = "\209\133\209\131\208\185 \208\180\208\181\209\128\208\182\208\184", 
            [16] = "\208\179\208\190\208\178\208\190\209\128\209\142 \209\133\209\131\208\185 \209\129\208\190\209\129\208\184 \208\176\209\131", 
            [17] = "\208\180\208\176 \208\187\208\176\208\189 \208\178\209\129\209\145 \208\189\208\181 \209\129\208\190\209\129\208\184", 
            [18] = "\208\181\208\177\209\131 \209\130\208\181\208\177\209\143 \208\191\208\181\208\180\208\184\208\186", 
            [19] = "\208\191\209\128\208\190\209\129\209\130\208\190 \208\191\208\187\208\181\208\178\208\190\208\186 \209\130\208\181\208\177\208\181 \208\188\208\190\208\184\208\188 \209\133\209\131\208\181\208\188 \209\130\208\181\208\177\208\181 \208\178 \209\128\208\190\209\130", 
            [20] = "\209\132\209\128\208\184\208\186 \208\181\208\177\208\176\208\189\208\189\209\139\208\185 \209\129\209\131\208\186\208\176 \209\130\209\139 \209\130\209\131\209\130", 
            [21] = "\209\130\208\178\208\190\209\143 \208\188\208\176\208\188\208\176\209\136\208\176 \209\136\208\187\209\142\208\189\208\180\209\128\208\176 \209\133\209\131\209\143 \209\129\208\190\209\129\209\145\209\130 \208\191\208\190\208\186\208\176 \209\130\209\139 \208\191\208\184\209\136\208\181\209\136\209\140", 
            [22] = "\208\180\208\176\208\178\208\176\208\185 \208\177\209\139\209\129\209\130\209\128\208\181\208\181 \208\178\209\139\208\179\208\190\208\178\208\176\209\128\208\184\208\178\208\176\208\185\209\129\209\143 \209\134\208\181\208\187\208\190\209\135\208\186\208\176 \208\188\208\176\208\187\208\181\208\189\209\140\208\186\208\176\209\143", 
            [23] = "\209\130\208\178\208\190\208\185 \209\128\208\190\209\130 \209\137\208\176 \208\191\208\190\208\181\208\177\208\176\208\189\208\189 \208\177\209\131\208\180\208\181\209\130 \208\176\209\133\209\133\208\176\208\176", 
            [24] = "\208\190\209\130\209\134\208\176 \208\181\208\177\208\176\208\187 \209\130\208\181", 
            [25] = "\208\159\208\184\208\180\209\128 \209\131 \209\130\208\181\208\177\209\143 \208\191\209\128\208\190\208\177\208\184\209\128\208\186\208\176 \208\189\208\176 \208\181\208\177\208\187\208\181", 
            [26] = "\209\130\209\139 \208\182\208\181 \208\186\208\190\208\188\208\189\208\176\209\130\208\189\209\139\208\185 \208\180\209\128\208\190\209\135\208\184\208\187\208\176 \208\181\208\177\208\176\208\189\208\189\209\139\208\185", 
            [27] = "\208\183\208\176\208\177\208\184\209\130\209\139\208\185 \208\186\208\187\208\181\209\137 \208\177\209\139\209\129\209\130\209\128\208\181\208\181 \208\180\208\176\208\178\208\176\208\185", 
            [28] = "\209\129\208\190\209\129\208\184\209\128\209\131\208\185 \209\130\209\131\209\130", 
            [29] = "\209\141\209\130\208\190 \209\130\209\139 \208\188\208\176\208\189\208\181\209\128\208\189\208\190\209\129\209\130\209\140 \208\184\208\183 \209\129\208\181\208\177\209\143 \208\186\208\190\209\128\209\135\208\184\209\136\209\140 \208\180\208\190\208\187\208\177\208\176\208\181\208\177 10\208\187\208\181\209\130\208\189\208\184\208\185", 
            [30] = "\209\129\208\190\209\129\208\184\209\128\209\131\208\185 \209\130\208\176\208\188", 
            [31] = "\209\129\208\190\209\129\208\184\209\128\209\131\208\185 \209\130\208\176", 
            [32] = "\209\130\209\139 \208\182\208\181 \209\129\208\187\208\176\208\177\208\190\209\131\208\188\208\189\209\139\208\185 \208\178 \208\180\208\181\208\185\209\129\209\130\208\178\208\184\209\130\208\181\208\187\209\140\208\189\208\190\209\129\209\130\208\184", 
            [33] = "\209\129\208\190\208\191\208\187\208\184\208\178\209\139\208\185 \209\131\208\177\208\181\208\185 \209\129\208\181\208\177\209\143", 
            [34] = "\209\131 \209\130\208\181\208\177\209\143 \208\191\209\128\208\190\208\177\208\186\208\176 \208\184\208\183 \208\191\208\190\208\180 \208\178\208\184\208\189\208\176 \208\178 \208\182\208\190\208\191\208\181", 
            [35] = "\208\180\208\190 \209\141\209\130\208\190\208\179\208\190 \208\180\208\190\208\187\208\177\208\176\208\181\208\177\208\176 \209\130\208\176\208\186 \208\180\208\190\208\187\208\179\208\190 \208\178\209\129\208\181 \208\180\208\190\209\133\208\190\208\180\208\184\209\130 \208\191\208\184\208\183\208\180\208\181\209\134", 
            [36] = "\209\130\209\139 \208\182\208\181 \209\130\209\131\209\130 5 \208\188\208\184\208\189\209\131\209\130 \208\189\208\181 \208\178\209\139\208\180\208\181\209\128\208\182\208\176\208\187", 
            [37] = "\209\136\208\186\208\190\208\187\209\140\208\189\208\184\208\186 \209\130\209\139 \208\181\208\177\208\176\208\189\208\189\209\139\208\185 \209\128\208\190\209\130 \209\130\208\178\208\190\208\185 \208\191\208\190\208\181\208\177\208\176\208\187 \208\189\208\190\209\128\208\188\208\176\208\187\209\140\208\189\208\190 \208\180\208\176", 
            [38] = "\208\180\208\181\208\178\208\190\209\135\208\186\208\176 \208\188\208\176\208\187\208\181\208\189\209\140\208\186\208\176\209\143 \208\180\208\176\208\178\208\176\208\185 \208\177\209\139\209\129\209\130\209\128\208\181\208\181 \209\130\208\176\208\188 \209\133\209\131\208\185 \208\189\208\176\209\129\208\176\209\129\209\139\208\178\208\176\208\185", 
            [39] = "\209\132\209\128\208\184\208\186\208\176\208\189\209\131\209\130\208\176\209\143 \209\136\208\187\209\142\209\136\208\186\208\176 \208\188\208\190\209\143 \209\130\209\139 \209\130\209\131\209\130?", 
            [40] = "\209\131\209\128\208\190\208\180\208\187\208\184\208\178\209\139\208\185 \208\180\208\181\208\178\209\129\209\130\208\178\208\181\208\189\208\189\208\184\208\186 \208\177\209\139\209\129\209\130\209\128\208\181\208\181 \208\180\208\176\208\178\208\176\208\185 \209\130\208\176\208\188", 
            [41] = "\209\129\208\186\209\131\209\132\209\132\208\189\209\131\209\130\209\139\208\185 \208\179\208\181\208\185", 
            [42] = "\208\189\208\176\209\129\208\184\208\187\209\131\209\142 \209\130\208\181\208\177\209\143 \209\129\209\131\209\135\208\186\209\131", 
            [43] = "\209\129\208\190\208\191\208\187\208\184\208\178\208\176\209\143 \209\135\208\188\208\190\209\136\208\189\208\184\209\134\208\176", 
            [44] = "\208\189\208\184\209\135\209\130\208\190\208\182\208\189\209\139\208\185 \208\191\209\128\208\184\208\177\208\187\209\143\208\180\208\190\208\186", 
            [45] = "\208\180\208\181\209\128\208\181\208\178\208\181\208\189\209\129\208\186\208\184\208\185 \208\190\208\177\209\129\208\190\209\129", 
            [46] = "\208\182\208\181\209\129\209\130\209\140 \208\191\208\176\209\128\208\189\208\184 \208\186\208\176\208\186 \208\190\208\189 \209\129\208\190\209\129\209\145\209\130 \208\176\209\133\208\176\209\133\208\176\209\133", 
            [47] = "\209\129\208\187\208\176\208\177\208\176\209\133\208\176\209\128\208\176\208\186\209\130\208\181\209\128\208\189\209\139\208\185 \208\184\208\189\209\130\208\181\209\128\208\189\208\181\209\130\208\189\209\139\208\185 \208\189\208\190\209\131\208\187\208\176\208\185\209\132\208\181\209\128", 
            [48] = "\208\190\209\132\208\186 \208\189\208\176\209\129\208\176\209\129\209\139\208\178\208\176\208\185 \208\188\208\189\208\181 \208\177\208\187\209\143 \208\177\208\190\208\188\208\182", 
            [49] = "\208\189\209\131 \208\183\208\176\208\178\208\190\208\180\208\184\208\184\209\129\209\140 \209\130\208\190\208\186 \208\191\208\181\209\130\209\131\209\133 \208\181\208\177\208\176\208\189\208\189\209\139\208\185", 
            [50] = "\208\191\208\184\208\180\208\190\209\128\208\188\208\190\209\130 \208\181\208\177\208\176\208\189\209\139\208\185 \208\182\208\188\208\190\209\130\208\189\209\131\209\130\209\139\208\185", 
            [51] = "\208\190\208\178\208\190\209\137\209\140 \208\181\208\177\208\176\208\189\208\189\209\139\208\185 \208\183\208\176\209\130\209\131\208\191\208\189\209\131\209\130\209\139\208\185", 
            [52] = "\208\191\209\128\208\190\209\129\209\130\208\190 \208\191\208\184\208\183\208\180\208\184\209\130\209\140 \209\130\208\181\208\177\208\181 \208\188\208\176\209\130\209\140 \208\177\209\131\208\180\209\131", 
            [53] = "\208\190\209\130\209\129\209\130\208\176\208\187\209\139\208\185 \208\179\208\190\208\188\208\190\209\129\208\181\208\186 \209\129\209\131\208\186\208\176", 
            [54] = "\208\182\208\176\208\187\208\186\208\184\208\185 \208\191\208\176\209\129\209\139\208\189\208\190\208\186 \208\184\208\189\208\180\208\184\208\179\208\190", 
            [55] = "\208\191\208\190\209\135\208\181\208\188\209\131 \209\130\209\139 \208\178 \209\129\208\181\208\177\209\143 \208\191\208\181\209\128\208\181\209\129\209\130\208\176\208\187 \208\178\208\181\209\128\208\184\209\130\209\140 \208\178\209\139\208\177\208\187\209\143\208\180\208\190\208\186", 
            [56] = "\209\130\209\139 \208\182\208\181 \208\188\208\181\208\180\208\187\209\143\208\186 \208\181\208\177\208\176\208\189\208\189\209\139\208\185 \208\189\208\181 \208\191\209\139\209\130\208\176\208\185\209\129\209\143 \208\177\208\184\209\132\208\184\209\130\209\140\209\129\209\143 \209\129 \209\133\209\131\208\181\208\188 \208\188\208\190\208\184\208\188", 
            [57] = "\208\182\208\176\208\187\208\186\208\184\208\185 \208\178\209\139\209\128\208\190\208\180\208\190\208\186 \208\186\208\176\208\186\208\190\208\185 \209\130\209\139 \209\133\209\131\208\181\208\178\209\139\208\185 \209\143  \208\178\208\176\209\133\209\131\208\181 \209\129 \209\130\208\181\208\177\209\143", 
            [58] = "\208\180\208\181\209\128\208\181\208\178\208\181\208\189\209\129\208\186\208\184\208\185 \208\190\208\177\209\129\208\190\209\129", 
            [59] = "\208\187\208\176\208\189 \208\188\208\176\208\187\208\190\208\185 \209\129\208\187\209\139\209\136\209\140 \209\133\209\131\208\185 \209\129\208\190\209\129\208\184", 
            [60] = "\209\143 \208\182\208\181 \208\186\208\187\209\143\208\189\209\131\209\129\209\140 \209\130\209\139 \208\191\208\184\208\180\209\128 \208\181\208\177\208\176\208\189\208\189\209\139\208\185 \209\129\208\187\208\176\208\177\209\139\208\185", 
            [61] = "\208\180\208\181\209\128\209\140\208\188\208\190 \208\188\208\176\208\187\208\181\208\189\209\140\208\186\208\190\208\181 \208\189\208\181 \209\129\208\190\209\129\208\184", 
            [62] = "\209\143 \209\130\208\181\208\177\208\181 \208\191\209\128\208\190\209\129\209\130\208\190 \208\181\208\177\208\176\208\187\208\190 \209\129\208\187\208\190\208\188\208\176\209\142 \208\189\208\176\209\133\209\131\208\185", 
            [63] = "\208\186\208\176\208\187\208\181\208\186\208\176 \209\130\209\139 \208\181\208\177\208\176\208\189\208\189\208\176\209\143 \209\129\209\131\208\186\208\176", 
            [64] = "\209\129\209\131\209\137\208\181\209\129\209\130\208\178\208\190 \208\181\208\177\208\176\208\189\208\189\208\190\208\181", 
            [65] = "\208\189\208\181 \209\129\208\190\209\129\208\184 \209\130\209\139 \209\131\208\182\208\181 \209\135\208\188\208\190\209\136\208\189\208\184\208\186", 
            [66] = "\208\191\209\128\208\190\209\129\209\130\208\190 \208\181\208\177\209\131 \209\130\208\181\208\177\209\143 \209\129\208\190 \209\129\208\186\208\190\209\128\208\190\209\129\209\130\209\140\209\142 \209\129\208\178\208\181\209\130\208\176", 
            [67] = "\208\180\208\176\208\178\208\176\208\185 \208\180\208\176\208\178\208\176\208\185 \208\180\208\176\208\178\208\184 \209\129\208\178\208\190\208\184 100\208\178\208\191\208\188 \208\180\208\181\209\128\209\140\208\188\208\190", 
            [68] = "\208\180\208\176\208\178\208\176\208\185 \208\180\208\176\208\178\208\176\208\185", 
            [69] = "\208\191\208\190\208\186\208\176 \208\188\208\176\208\188\208\176\209\136\209\131 \209\130\208\181\208\177\208\181 \209\130\209\131\209\130 \208\181\208\177\209\145\208\188", 
            [70] = "\209\130\209\139 \208\182\208\181 \208\189\208\181 \208\191\208\190\208\189\208\184\208\188\208\176\208\181\209\136\209\140 \209\135\209\130\208\190 \209\130\209\139 \208\191\208\184\208\180\209\128 \208\181\208\177\208\176\208\189\208\189\209\139\208\185 \208\176\209\133\208\176\209\133\208\176\209\133\208\176", 
            [71] = "\209\135\208\184\208\187\209\140\208\189\208\184\209\129\209\140 \208\191\208\190\209\130\209\131\209\133\208\189\208\184 \209\131\208\182\208\181 \209\133\209\131\208\185\208\191\208\176\209\135\208\190\209\129 \208\181\208\177\208\176\208\189\208\189\209\139\208\185", 
            [72] = "\208\191\209\128\208\190\209\129\209\130\208\190 \208\191\208\184\208\180\208\190\209\128\208\176 \209\131\208\177\209\140\209\142 \209\130\208\181\208\177\209\143 \208\181\208\177\208\176\208\189\208\189\209\139\208\185 \209\133\209\131\208\181\209\129\208\190\209\129 \208\189\208\184\209\137\208\184\208\185", 
            [73] = "\208\189\208\190\209\128\208\188 \209\143 \209\130\209\143 \209\129 \208\189\209\143\209\133\209\131\208\186\208\190\208\188 \208\181\208\177\209\131 \209\129\208\187\209\139\209\136", 
            [74] = "\239\188\174\239\188\185\239\188\161\239\188\168\239\188\175\239\188\175\239\188\171 >>> \208\191\208\184\208\180\208\190\209\128\208\176\209\129\209\139 \209\128\208\176\208\183\208\187\208\181\209\130\208\181\208\187\208\184\209\129\209\140", 
            [75] = "\208\175 \208\184\208\179\209\128\208\176\209\142 \209\129 \208\191\209\128\208\184\208\178\208\176\209\130\208\189\208\190\208\185 \208\187\209\131\208\176 NyaHook (\226\151\163 _ \226\151\162)", 
            [76] = "\208\176... \209\130\209\139 \209\135\209\130\208\190 \208\189\208\181 \209\129 \208\189\209\143\209\133\209\131\208\186\208\190\208\188? >W<", 
            [77] = "\209\130\209\139 \208\179\208\180\208\181 \209\133\208\190\208\180\208\184\209\136\209\140?", 
            [78] = "\239\188\180\239\189\136\239\189\133 \239\188\162\239\189\133\239\189\147\239\189\148 \239\189\143\239\189\134 \239\188\173\239\189\143\239\189\154\239\189\129\239\189\146\239\189\148", 
            [79] = "sizo hvh x suprastin", 
            [80] = "destroyed by infect legend", 
            [81] = "by sovez1337 x santiz", 
            [82] = "{2v2} Mapsat vs Kamel (scoof) & Kentry (king)", 
            [83] = "\240\157\159\143 \240\157\144\157\240\157\144\154\240\157\144\178 \240\157\144\154\240\157\144\173 \240\157\144\174\240\157\144\167\240\157\144\166\240\157\144\154\240\157\144\173\240\157\144\156\240\157\144\161\240\157\144\158\240\157\144\157.\240\157\144\160\240\157\144\160 \240\157\144\133\240\157\144\158\240\157\144\154\240\157\144\173 \240\157\144\141\240\157\144\178\240\157\144\154\240\157\144\135\240\157\144\168\240\157\144\168\240\157\144\164", 
            [84] = "[2\225\180\1602] \202\159\225\180\135\225\180\160\225\180\128\225\180\139\201\170\201\180\225\180\133\225\180\135\202\128999 \225\180\160s \225\180\128\202\159\202\159 \225\180\133\225\180\143\201\162s *\202\128x\225\180\133x\202\143x\225\180\162, \225\180\160\202\159\225\180\128s\225\180\155\225\180\135\202\159\201\170\201\180, \225\180\141\225\180\128\225\180\156\225\180\155, \225\180\139\202\128\225\180\135\201\180\225\180\133\201\170x, \202\156\225\180\135\225\180\141s\225\180\143*", 
            [85] = "\225\155\138\225\142\182\225\154\164\225\154\179 \225\155\160\225\155\146\225\155\156\225\154\191\225\155\156 \225\155\150\225\154\164\225\155\160\226\176\147 \225\155\136\226\176\147\225\155\129\225\154\186 \225\155\158\225\154\179\225\154\191\225\155\156\225\154\183\225\155\139", 
            [86] = "footjob - @preferbaim", 
            [87] = "\208\178\209\139\209\128\209\131\208\177\208\184 \208\186\209\128\209\131\209\130\208\184\208\187\208\186\208\184 \209\135\208\188\208\190", 
            [88] = "\240\159\164\153 +W CONFIG BY \240\159\164\150YURI\240\159\164\150", 
            [89] = "FREE RAGE CFG BY SHELZY1337 \227\131\132", 
            [90] = "\226\152\162WARNING\226\152\162 REBELLION DETECTED!", 
            [91] = "\226\153\154 $ bluhgang $ JS vs trash users portugals bots st1vaha,vitma,kitty,fnay,rayzen \226\153\154", 
            [92] = "\208\148\208\182\208\190\208\189 \208\147\208\176\209\128\208\184\208\186 aka TRXSTR \226\128\148 \208\146\208\190\208\180\208\186\208\176 2", 
            [93] = "\226\150\132\239\184\187\204\183\204\191\226\148\187\204\191\226\149\144\226\148\129\228\184\128 \208\187\208\190\208\178\208\184 \208\178 \208\181\208\177\208\187\208\184\209\137\208\181", 
            [94] = "\226\156\191*\226\136\151\203\181\226\149\176\224\188\188\226\156\170\225\151\156\226\156\170\224\188\189\226\149\175\203\181\226\136\151*\226\156\191", 
            [95] = "\226\156\140(\227\131\132) FREE ONETAP V3 CRACK / BRILAHA", 
            [96] = "000.cfg", 
            [97] = "\208\146\208\189\208\184\208\188\208\176\208\189\208\184\208\181! \208\145\208\190\208\177\209\145\209\128 \208\191\209\139\209\130\208\176\208\187\209\129\209\143 \208\183\208\176\208\187\208\181\208\183\209\130\209\140 \208\191\208\190 \209\129\208\186\208\190\208\187\209\140\208\183\208\186\208\190\208\185 \208\186\209\128\209\139\209\136\208\181 \208\178 \208\190\208\186\208\189\208\190 \208\186 \208\180\208\181\208\178\209\131\209\136\208\186\208\181, \208\186\208\190\209\130\208\190\209\128\208\176\209\143 \208\181\208\179\208\190 \208\191\209\128\208\184\208\186\208\190\209\128\208\188\208\184\208\187\208\176, \208\189\208\190 \208\189\208\181 \209\129\208\188\208\190\208\179 \208\184 \209\128\208\176\208\183\208\178\209\145\208\187 \208\187\208\176\208\191\208\186\208\184 \208\178 \209\129\209\130\208\190\209\128\208\190\208\189\209\131.", 
            [98] = "LC \208\180\208\181\208\187\208\176\208\185 \208\177\209\128\208\176\209\130\208\184\208\186"
        }, 
        trashtalk = function(v318)
            -- upvalues: v71 (ref), v176 (ref)
            local v319 = entity.get_local_player();
            if v319 == nil then
                return;
            elseif not v71.misc.in_game.trashtalk:get() then
                return;
            else
                local v320 = v319:get_player_info();
                if v320 == nil then
                    return;
                else
                    local l_userid_0 = v320.userid;
                    local v322 = entity.get(v318.userid, true);
                    if v318.userid ~= l_userid_0 and l_userid_0 == v318.attacker then
                        utils.console_exec("say 1");
                        if v322:get_xuid() == "76561199581438938" then
                            utils.execute_after(2, function()
                                -- upvalues: v176 (ref)
                                utils.console_exec("say " .. tostring(v176.in_game.trashtalk.phrases[math.random(#v176.in_game.trashtalk.phrases)]));
                            end);
                        else
                            utils.execute_after(2, function()
                                -- upvalues: v176 (ref)
                                utils.console_exec("say " .. tostring(v176.in_game.trashtalk.phrases[math.random(#v176.in_game.trashtalk.phrases)]));
                            end);
                        end;
                    end;
                    return;
                end;
            end;
        end
    }, 
    clantag = function()
        -- upvalues: v71 (ref)
        if entity.get_local_player() == nil then
            return;
        elseif not globals.is_connected then
            return;
        else
            local v323 = "NyaHook";
            if v71.misc.in_game.clantag:get() then
                common.set_clan_tag(v323);
            else
                common.set_clan_tag("");
            end;
            return;
        end;
    end, 
    [1] = v71.misc.in_game.clantag:set_callback(function()
        -- upvalues: v176 (ref)
        v176.in_game.clantag();
    end), 
    aspect_ratio = function()
        -- upvalues: v71 (ref)
        if v71.misc.in_game.aspect_ratio:get() then
            cvar.r_aspectratio:float(v71.misc.in_game.aspect_ratio.ratio:get() / 100);
        else
            cvar.r_aspectratio:float(0);
        end;
    end, 
    viewmodel_changer = function()
        -- upvalues: v71 (ref)
        if v71.misc.in_game.viewmodel_changer:get() then
            cvar.viewmodel_fov:float(v71.misc.in_game.viewmodel_changer.viewmodel_fov:get() / 100, true);
            cvar.viewmodel_offset_x:float(v71.misc.in_game.viewmodel_changer.viewmodel_x:get() / 100, true);
            cvar.viewmodel_offset_y:float(v71.misc.in_game.viewmodel_changer.viewmodel_y:get() / 100, true);
            cvar.viewmodel_offset_z:float(v71.misc.in_game.viewmodel_changer.viewmodel_z:get() / 100, true);
        else
            cvar.viewmodel_fov:float(68);
            cvar.viewmodel_offset_x:float(2.5);
            cvar.viewmodel_offset_y:float(0);
            cvar.viewmodel_offset_z:float(-1.5);
        end;
    end, 
    keep_model_transparency = function()
        -- upvalues: v71 (ref)
        local v324 = entity.get_local_player();
        if v324 == nil or not v324:is_alive() then
            return;
        elseif not v71.misc.in_game.keep_model_transparency:get() then
            return;
        else
            return (not not v324.m_bIsScoped or v324.m_bResumeZoom) and 100 or 255;
        end;
    end
};
v176.movement = {
    no_fall_damage = function(v325)
        -- upvalues: v71 (ref)
        local v326 = entity.get_local_player();
        if v326 == nil then
            return;
        elseif not v71.misc.movement.no_fall_damage:get() then
            return;
        else
            local v327 = v326:get_origin();
            if v326.m_vecVelocity.z <= -500 then
                if utils.trace_line(vector(v327.x, v327.y, v327.z), vector(v327.x, v327.y, v327.z - 15)).fraction ~= 1 then
                    v325.in_duck = 0;
                elseif utils.trace_line(vector(v327.x, v327.y, v327.z), vector(v327.x, v327.y, v327.z - 55)).fraction ~= 1 then
                    v325.in_duck = 1;
                end;
            end;
            return;
        end;
    end, 
    fast_ladder = function(v328)
        -- upvalues: v71 (ref)
        local v329 = entity.get_local_player();
        if v329 == nil then
            return;
        elseif not v71.misc.movement.fast_ladder:get() then
            return;
        else
            if v329.m_MoveType == 9 then
                v328.view_angles.y = math.floor(v328.view_angles.y + 0.5);
                if v328.forwardmove > 0 then
                    if v328.view_angles.x < 45 then
                        v328.view_angles.x = 89;
                        v328.in_moveright = 1;
                        v328.in_moveleft = 0;
                        v328.in_forward = 0;
                        v328.in_back = 1;
                        if v328.sidemove == 0 then
                            v328.view_angles.y = v328.view_angles.y + 90;
                        end;
                        if v328.sidemove < 0 then
                            v328.view_angles.y = v328.view_angles.y + 150;
                        end;
                        if v328.sidemove > 0 then
                            v328.view_angles.y = v328.view_angles.y + 30;
                        end;
                    end;
                elseif v328.forwardmove < 0 then
                    v328.view_angles.x = 89;
                    v328.in_moveleft = 1;
                    v328.in_moveright = 0;
                    v328.in_forward = 1;
                    v328.in_back = 0;
                    if v328.sidemove == 0 then
                        v328.view_angles.y = v328.view_angles.y + 90;
                    end;
                    if v328.sidemove > 0 then
                        v328.view_angles.y = v328.view_angles.y + 150;
                    end;
                    if v328.sidemove < 0 then
                        v328.view_angles.y = v328.view_angles.y + 30;
                    end;
                end;
            end;
            return;
        end;
    end, 
    edge_stop = function(v330)
        -- upvalues: v71 (ref)
        local v331 = entity.get_local_player();
        if v331 == nil then
            return;
        elseif not v71.misc.movement.edge_stop:get() then
            return;
        else
            sim = v331:simulate_movement((v331:get_origin()));
            sim:think(5);
            if sim.velocity.z < 0 then
                v330.block_movement = 2;
            end;
            return;
        end;
    end, 
    jump_scout = function(_)
        -- upvalues: v71 (ref), v61 (ref)
        local v333 = entity.get_local_player();
        if v333 == nil then
            return;
        elseif not v71.misc.movement.jump_scout:get() then
            return;
        else
            if math.sqrt(v333.m_vecVelocity.x * v333.m_vecVelocity.x + v333.m_vecVelocity.y * v333.m_vecVelocity.y) < 2 then
                v61.air_strafe:override(false);
            else
                v61.air_strafe:override();
            end;
            return;
        end;
    end, 
    on_grenade_override_view = function(v334)
        -- upvalues: v71 (ref), v176 (ref)
        if not v71.misc.movement.super_toss:get() then
            return;
        else
            local v335 = entity.get_local_player();
            if v335 == nil then
                return;
            else
                local v336 = v335:get_player_weapon();
                if v336 == nil then
                    return;
                else
                    local v337 = v336:get_weapon_info();
                    if v337 == nil then
                        return;
                    else
                        v334.angles = v176.super_toss_references.get_throw_toss(v334.angles, v337.throw_velocity, v336.m_flThrowStrength, v334.velocity);
                        return;
                    end;
                end;
            end;
        end;
    end, 
    super_toss = function(v338)
        -- upvalues: v71 (ref), v176 (ref)
        if not v71.misc.movement.super_toss:get() then
            return;
        elseif v338.jitter_move ~= true then
            return;
        else
            local v339 = entity.get_local_player();
            if v339 == nil then
                return;
            else
                local v340 = v339:get_player_weapon();
                if v340 == nil then
                    return;
                else
                    local v341 = v340:get_weapon_info();
                    if v341 == nil or v341.weapon_type ~= 9 then
                        return;
                    elseif v340.m_fThrowTime < globals.curtime - to_time(globals.clock_offset) then
                        return;
                    else
                        v338.in_speed = true;
                        local v342 = v339:simulate_movement();
                        v342:think();
                        v338.view_angles = v176.super_toss_references.get_throw_toss(v338.view_angles, v341.throw_velocity, v340.m_flThrowStrength, v342.velocity);
                        return;
                    end;
                end;
            end;
        end;
    end
};
v176.logs = {
    notify_data = {}, 
    notifications = function()
        -- upvalues: v176 (ref), v10 (ref), l_x_1 (ref), l_y_2 (ref)
        for v343, v344 in ipairs(v176.logs.notify_data) do
            if v344.time + 1 > globals.realtime and v343 <= 5 then
                v344.alpha = v10.lerp(v344.alpha, 255, 0.05);
                v344.alpha_text = v10.lerp(v344.alpha_text, 255, 0.05);
                v344.add_x = v10.lerp(v344.add_x, 1, 0.05);
            end;
            local l_color_0 = v344.color;
            local v346 = "\a" .. l_color_0:to_hex() .. ui.get_icon("paw") .. " \aDEFAULT" .. tostring(v344.text);
            local v347 = render.measure_text(1, "", tostring(v346)).x / 2;
            if v344.alpha <= 0 then
                v344[v343] = nil;
            else
                v344.add_y = v10.lerp(v344.add_y, v343 * 40, 0.05);
                render.shadow(vector(l_x_1 / 2 - v347 - 12, l_y_2 - 80 - v344.add_y - 6), vector(l_x_1 / 2 + v347 + 12, l_y_2 - 80 - v344.add_y + 20), color(l_color_0.r, l_color_0.g, l_color_0.b, v344.alpha - 60), 50, 0, 5);
                render.rect(vector(l_x_1 / 2 - v347 - 12, l_y_2 - 80 - v344.add_y - 6), vector(l_x_1 / 2 + v347 + 12, l_y_2 - 80 - v344.add_y + 20), color(15, 15, 15, v344.alpha), 5);
                local _ = v347 + 40;
                render.text(1, vector(l_x_1 / 2 - v347, l_y_2 - 80 - v344.add_y), color(255, 255, 255, v344.alpha_text), nil, v346);
                if v344.time + 3 < globals.realtime or v343 > 5 then
                    v344.alpha = v10.lerp(v344.alpha, 0, 0.05);
                    v344.alpha_text = v10.lerp(v344.alpha_text, 0, 0.05);
                    v344.add_x = v10.lerp(v344.add_x, 0, 0.05);
                    v344.add_y = v10.lerp(v344.add_y, v343 * 60, 0.05);
                end;
            end;
            if v344.alpha < 1 then
                table.remove(v176.logs.notify_data, v343);
            end;
        end;
    end, 
    hitgroup_str = {
        [0] = "generic", 
        [1] = "head", 
        [2] = "chest", 
        [3] = "stomach", 
        [4] = "left arm", 
        [5] = "right arm", 
        [6] = "left leg", 
        [7] = "right leg", 
        [8] = "neck", 
        [9] = "generic", 
        [10] = "gear"
    }, 
    aimbot = function(v349)
        -- upvalues: v71 (ref), v176 (ref)
        if not v71.misc.ragebot.aimbot_logs:get() then
            return;
        else
            local l_state_0 = v349.state;
            local v351 = entity.get(v349.target);
            if v351 == nil then
                return;
            else
                local v352 = v351:get_name();
                local v353 = v176.logs.hitgroup_str[v349.hitgroup];
                local v354 = v176.logs.hitgroup_str[v349.wanted_hitgroup];
                local l_damage_1 = v349.damage;
                local l_wanted_damage_0 = v349.wanted_damage;
                local l_m_iHealth_0 = v351.m_iHealth;
                local l_backtrack_0 = v349.backtrack;
                local l_hitchance_0 = v349.hitchance;
                local v360 = v71.misc.ragebot.aimbot_logs.hit_color:get():to_hex();
                local v361 = v71.misc.ragebot.aimbot_logs.miss_color:get():to_hex();
                if l_state_0 == nil then
                    if v71.misc.ragebot.aimbot_logs.output:get("Notify") then
                        table.insert(v176.logs.notify_data, 1, {
                            add_x = 0, 
                            alpha_text = 0, 
                            alpha = 0, 
                            add_y = 0, 
                            text = string.format("\v Hit %s in the %s for %s damage", v352, v353, l_damage_1), 
                            time = globals.realtime, 
                            color = v71.misc.ragebot.aimbot_logs.hit_color:get()
                        });
                    else
                        v176.logs.notify_data = {};
                    end;
                    if v71.misc.ragebot.aimbot_logs.output:get("Console") then
                        print_raw(string.format("[\a" .. v360 .. "Nya\aDEFAULTHook] \a" .. v360 .. "Hit\aDEFAULT %s in the %s(%s) for \a" .. v360 .. "%s\aDEFAULT(\a" .. v360 .. "%s\aDEFAULT) damage [health remaining: \a" .. v360 .. "%s\aDEFAULT | bt: \a" .. v360 .. "%st\aDEFAULT | hc: \a" .. v360 .. "%s%%\aDEFAULT]", v352, v353, v354, l_damage_1, l_wanted_damage_0, l_m_iHealth_0, l_backtrack_0, l_hitchance_0));
                    end;
                    if v71.misc.ragebot.aimbot_logs.output:get("Event") then
                        print_dev(string.format("\a" .. v360 .. "Hit\aDEFAULT %s in the %s(%s) for \a" .. v360 .. "%s\aDEFAULT(\a" .. v360 .. "%s\aDEFAULT) damage [health remaining: \a" .. v360 .. "%s\aDEFAULT | bt: \a" .. v360 .. "%st\aDEFAULT | hc: \a" .. v360 .. "%s%%\aDEFAULT]", v352, v353, v354, l_damage_1, l_wanted_damage_0, l_m_iHealth_0, l_backtrack_0, l_hitchance_0));
                    end;
                else
                    if v71.misc.ragebot.aimbot_logs.output:get("Notify") then
                        table.insert(v176.logs.notify_data, 1, {
                            add_x = 0, 
                            alpha_text = 0, 
                            alpha = 0, 
                            add_y = 0, 
                            text = string.format("\v Missed shot at %s due to %s in the %s", v352, l_state_0, v354), 
                            time = globals.realtime, 
                            color = v71.misc.ragebot.aimbot_logs.miss_color:get()
                        });
                    else
                        v176.logs.notify_data = {};
                    end;
                    if v71.misc.ragebot.aimbot_logs.output:get("Console") then
                        print_raw(string.format("[\a" .. v361 .. "Nya\aDEFAULTHook] \a" .. v361 .. "Missed\aDEFAULT shot at %s due to \a" .. v361 .. "%s\aDEFAULT in the %s for \a" .. v361 .. "%s\aDEFAULT damage [bt: \a" .. v361 .. "%st\aDEFAULT | hc: \a" .. v361 .. "%s%%\aDEFAULT]", v352, l_state_0, v354, l_wanted_damage_0, l_backtrack_0, l_hitchance_0));
                    end;
                    if v71.misc.ragebot.aimbot_logs.output:get("Event") then
                        print_dev(string.format("\a" .. v361 .. "Missed\aDEFAULT shot at %s due to \a" .. v361 .. "%s\aDEFAULT in the %s for \a" .. v361 .. "%s\aDEFAULT damage [bt: \a" .. v361 .. "%st\aDEFAULT | hc: \a" .. v361 .. "%s%%\aDEFAULT]", v352, l_state_0, v354, l_wanted_damage_0, l_backtrack_0, l_hitchance_0));
                    end;
                end;
                return;
            end;
        end;
    end, 
    additional = function(v362)
        -- upvalues: v71 (ref)
        if not v71.misc.ragebot.aimbot_logs:get() then
            return;
        else
            local v363 = entity.get_local_player();
            if v363 == nil then
                return;
            else
                local v364 = entity.get(v362.attacker, true);
                if v364 == nil then
                    return;
                else
                    local v365 = entity.get(v362.userid, true);
                    if v365 == nil then
                        return;
                    else
                        local v366 = v365:get_name();
                        local l_weapon_0 = v362.weapon;
                        if l_weapon_0 == "hegrenade" then
                            type_hit = "Naded";
                        end;
                        if l_weapon_0 == "inferno" then
                            type_hit = "Burned";
                        end;
                        if l_weapon_0 == "knife" then
                            type_hit = "Knifed";
                        end;
                        local v368 = v71.misc.ragebot.aimbot_logs.hit_color:get():to_hex();
                        if (l_weapon_0 == "hegrenade" or l_weapon_0 == "inferno" or l_weapon_0 == "knife") and v363 == v364 then
                            if v71.misc.ragebot.aimbot_logs.output:get("Console") then
                                print_raw(string.format("[\a" .. v368 .. "Nya\aDEFAULTHook] \a" .. v368 .. "%s\aDEFAULT %s for \a" .. v368 .. "%s\aDEFAULT damage [health remaining: \a" .. v368 .. "%s\aDEFAULT]", type_hit, v366, v362.dmg_health, v362.health));
                            end;
                            if v71.misc.ragebot.aimbot_logs.output:get("Event") then
                                print_dev(string.format("\a" .. v368 .. "%s\aDEFAULT %s for \a" .. v368 .. "%s\aDEFAULT damage [health remaining: \a" .. v368 .. "%s\aDEFAULT]", type_hit, v366, v362.dmg_health, v362.health));
                            end;
                        end;
                        return;
                    end;
                end;
            end;
        end;
    end, 
    purchase = function(v369)
        -- upvalues: v71 (ref)
        if not v71.misc.ragebot.aimbot_logs:get() then
            return;
        else
            if v71.misc.ragebot.aimbot_logs.purchase_logs:get() then
                local v370 = entity.get(v369.userid, true);
                if v370 == nil or not v370:is_enemy() then
                    return;
                else
                    local v371 = v370:get_name();
                    local l_weapon_1 = v369.weapon;
                    if l_weapon_1 == "weapon_unknown" then
                        return;
                    else
                        if v71.misc.ragebot.aimbot_logs.output:get("Console") then
                            print_raw(string.format("[\aFFABDEFFNya\aDEFAULTHook] %s bought %s", v371, l_weapon_1));
                        end;
                        if v71.misc.ragebot.aimbot_logs.output:get("Event") then
                            print_dev(string.format("%s bought %s", v371, l_weapon_1));
                        end;
                    end;
                end;
            end;
            return;
        end;
    end
};
v176.ragebot = {
    fake_latency = function()
        -- upvalues: v61 (ref), v71 (ref)
        cvar.sv_maxunlag:float(0.4);
        v61.fake_latency:set(v71.misc.ragebot.fake_latency:get());
    end, 
    hitchance = function(_)
        -- upvalues: v71 (ref), v61 (ref)
        local v374 = entity.get_local_player();
        if v374 == nil or not v374:is_alive() then
            return;
        else
            local v375 = v374:get_player_weapon();
            if v375 == nil then
                return;
            else
                local v376 = v375:get_weapon_index();
                if v376 == nil then
                    return;
                else
                    if v71.misc.ragebot.hitchance:get() then
                        if stateid == 4 or stateid == 5 then
                            if v71.misc.ragebot.hitchance.enable_pistols:get() and (v376 == 1 or v376 == 2 or v376 == 3 or v376 == 4 or v376 == 32 or v376 == 36 or v376 == 61) then
                                v61.pistols_hitchance:override(v71.misc.ragebot.hitchance.pistols_air_amount:get());
                            end;
                            if v71.misc.ragebot.hitchance.enable_auto_snipers:get() and (v376 == 38 or v376 == 11) then
                                v61.auto_snipers_hitchance:override(v71.misc.ragebot.hitchance.auto_snipers_air_amount:get());
                            end;
                            if v71.misc.ragebot.hitchance.enable_awp:get() and v376 == 9 then
                                v61.awp_hitchance:override(v71.misc.ragebot.hitchance.awp_air_amount:get());
                            end;
                            if v71.misc.ragebot.hitchance.enable_ssg08:get() and v376 == 40 then
                                v61.ssg08_hitchance:override(v71.misc.ragebot.hitchance.ssg08_air_amount:get());
                            end;
                            if v71.misc.ragebot.hitchance.enable_revolver:get() and v376 == 64 then
                                v61.revolver_hitchance:override(v71.misc.ragebot.hitchance.revolver_air_amount:get());
                            end;
                        else
                            v61.pistols_hitchance:override();
                            v61.auto_snipers_hitchance:override();
                            v61.awp_hitchance:override();
                            v61.ssg08_hitchance:override();
                            v61.revolver_hitchance:override();
                        end;
                        if not v374.m_bIsScoped or stateid == 4 or stateid == 5 then
                            if stateid == 4 or stateid == 5 then
                                if v71.misc.ragebot.hitchance.enable_pistols:get() and (v376 == 1 or v376 == 2 or v376 == 3 or v376 == 4 or v376 == 32 or v376 == 36 or v376 == 61) then
                                    v61.pistols_hitchance:override(v71.misc.ragebot.hitchance.pistols_air_amount:get());
                                end;
                                if v71.misc.ragebot.hitchance.enable_auto_snipers:get() and (v376 == 38 or v376 == 11) then
                                    v61.auto_snipers_hitchance:override(v71.misc.ragebot.hitchance.auto_snipers_air_amount:get());
                                end;
                                if v71.misc.ragebot.hitchance.enable_awp:get() and v376 == 9 then
                                    v61.awp_hitchance:override(v71.misc.ragebot.hitchance.awp_air_amount:get());
                                end;
                                if v71.misc.ragebot.hitchance.enable_ssg08:get() and v376 == 40 then
                                    v61.ssg08_hitchance:override(v71.misc.ragebot.hitchance.ssg08_air_amount:get());
                                end;
                                if v71.misc.ragebot.hitchance.enable_revolver:get() and v376 == 64 then
                                    v61.revolver_hitchance:override(v71.misc.ragebot.hitchance.revolver_air_amount:get());
                                end;
                            else
                                if v71.misc.ragebot.hitchance.enable_auto_snipers:get() and (v376 == 38 or v376 == 11) then
                                    v61.auto_snipers_hitchance:override(v71.misc.ragebot.hitchance.auto_snipers_no_scope_amount:get());
                                end;
                                if v71.misc.ragebot.hitchance.enable_awp:get() and v376 == 9 then
                                    v61.awp_hitchance:override(v71.misc.ragebot.hitchance.awp_no_scope_amount:get());
                                end;
                                if v71.misc.ragebot.hitchance.enable_ssg08:get() and v376 == 40 then
                                    v61.ssg08_hitchance:override(v71.misc.ragebot.hitchance.ssg08_no_scope_amount:get());
                                end;
                            end;
                        else
                            v61.pistols_hitchance:override();
                            v61.auto_snipers_hitchance:override();
                            v61.awp_hitchance:override();
                            v61.ssg08_hitchance:override();
                            v61.revolver_hitchance:override();
                        end;
                    else
                        v61.pistols_hitchance:override();
                        v61.auto_snipers_hitchance:override();
                        v61.awp_hitchance:override();
                        v61.ssg08_hitchance:override();
                        v61.revolver_hitchance:override();
                    end;
                    return;
                end;
            end;
        end;
    end, 
    grenade_throw_fix = function()
        -- upvalues: v71 (ref), v61 (ref)
        if not v71.misc.ragebot.grenade_throw_fix:get() then
            return;
        else
            local v377 = entity.get_local_player();
            if v377 == nil or not v377:is_alive() then
                return;
            else
                local v378 = v377:get_player_weapon();
                if not v378 or v378 == nil then
                    return;
                else
                    local v379 = v378:get_weapon_info();
                    if not v379 or v379 == nil then
                        return;
                    else
                        if v379.weapon_type == 9 then
                            v61.weapon_actions:override("");
                        else
                            v61.weapon_actions:override();
                        end;
                        return;
                    end;
                end;
            end;
        end;
    end; 
    v71.misc.ragebot.decrease_hold_aim_ticks:set_callback(function(v380)
        cvar.sv_maxusrcmdprocessticks_holdaim:int(v380:get() and 0 or 1);
    end)
};
v71.misc.ragebot.aimbot_logs.push_notify_log:set_callback(function()
    -- upvalues: v176 (ref), v71 (ref)
    table.insert(v176.logs.notify_data, 1, {
        add_x = 0, 
        alpha_text = 0, 
        alpha = 0, 
        add_y = 0, 
        text = "\v Hit zordside in the head for 192 damage (0 health remaining)", 
        time = globals.realtime, 
        color = v71.misc.ragebot.aimbot_logs.hit_color:get()
    });
    table.insert(v176.logs.notify_data, 1, {
        add_x = 0, 
        alpha_text = 0, 
        alpha = 0, 
        add_y = 0, 
        text = "\v Missed shot at zordside due to resolver in the head for 192 damage", 
        time = globals.realtime, 
        color = v71.misc.ragebot.aimbot_logs.miss_color:get()
    });
end);
v71.anti_aim.preset_manager.main = {};
local v381 = l_pui_0.setup({
    [1] = v71.anti_aim.builder
}, true);
preset_manager_label = v71.tabs.anti_aim.left_builder_presets:label("\vPreset manager\r which will give you easy access to share your custom preset.");
do
    local l_v381_0 = v381;
    load_recommended_anti_aim_settings = v71.tabs.anti_aim.left_builder_presets:button("\v\f<stars>\r  Meta Preset", function()
        -- upvalues: l_v381_0 (ref), l_base64_0 (ref)
        l_v381_0:load(json.parse(l_base64_0.decode("W1t7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjpmYWxzZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJSYW5kb20iLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjowLjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjI3LjAsInlhdyI6IlJhbmRvbVxuIiwieWF3X2N1c3RvbSI6MC4wLCJ5YXdfaml0dGVyIjoiRGlzYWJsZWQiLCJ5YXdfbW9kZSI6IlN0YXRpYyIsInlhd19yYW5kb21fZmlyc3QiOjAuMCwieWF3X3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MC4wLCJsZWZ0X2Ftb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMCwicmlnaHRfYW1vdW50IjowLjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IkRpc2FibGVkIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6MC4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjowLjAsInlhdyI6IkhpZGRlbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19tb2RlIjoiU3RhdGljIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MS4wLCJ+eWF3X2ppdHRlciI6eyJhbW91bnQiOi02Mi4wLCJyYW5kb21pemUiOjE1LjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjoxMi4wLCJsZWZ0X2Ftb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMCwicmlnaHRfYW1vdW50IjowLjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IlJhbmRvbSIsInBpdGNoX2N1c3RvbSI6MC4wLCJwaXRjaF9yYW5kb21fZmlyc3QiOi04OS4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjo0NS4wLCJ5YXciOiJTcGluIiwieWF3X2N1c3RvbSI6MC4wLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X21vZGUiOiJMJlIiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxNS4wLCJ+eWF3X2ppdHRlciI6eyJhbW91bnQiOi0zNy4wLCJyYW5kb21pemUiOjEwLjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjoxMi4wLCJsZWZ0X2Ftb3VudCI6LTI0LjAsInJhbmRvbWl6ZSI6NS4wLCJyaWdodF9hbW91bnQiOjE1LjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IkN1c3RvbSIsInBpdGNoX2N1c3RvbSI6NDUuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjowLjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3IjoiU3BpbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkRpc2FibGVkIiwieWF3X21vZGUiOiJTdGF0aWMiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxNS4wLCJ+eWF3X2ppdHRlciI6eyJhbW91bnQiOi02Mi4wLCJyYW5kb21pemUiOjUuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjcuMCwibGVmdF9hbW91bnQiOjAuMCwicmFuZG9taXplIjowLjAsInJpZ2h0X2Ftb3VudCI6MC4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJSYW5kb20iLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjotODkuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6NDUuMCwieWF3IjoiU3BpbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkRpc2FibGVkIiwieWF3X21vZGUiOiJMJlIiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxNS4wLCJ+eWF3X2ppdHRlciI6eyJhbW91bnQiOi0xMC4wLCJyYW5kb21pemUiOjUuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjAuMCwibGVmdF9hbW91bnQiOi0yNC4wLCJyYW5kb21pemUiOjExLjAsInJpZ2h0X2Ftb3VudCI6NDIuMH19LHsiYm9keV9qaXR0ZXIiOnRydWUsImJvZHlfaml0dGVyX2RlbGF5IjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21heGltdW0iOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWV0aG9kIjoiRGVmYXVsdCIsImJvZHlfaml0dGVyX2RlbGF5X21pbmltdW0iOjIuMCwiYm9keV9qaXR0ZXJfcmFuZG9taXplX2RlbGF5IjoyLjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX3lhd19sZWZ0X2Ftb3VudCI6MC4wLCJkZWZlbnNpdmVfeWF3X3JpZ2h0X2Ftb3VudCI6MC4wLCJlbmFibGVfc3RhdGUiOnRydWUsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiVXAiLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjotODkuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXciOiJGb3J3YXJkIiwieWF3X2N1c3RvbSI6MC4wLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X21vZGUiOiJTdGF0aWMiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjozMC4wLCJ+eWF3X2ppdHRlciI6eyJhbW91bnQiOi02MC4wLCJyYW5kb21pemUiOjAuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjEyLjAsImxlZnRfYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wLCJyaWdodF9hbW91bnQiOjAuMH19LHsiYm9keV9qaXR0ZXIiOnRydWUsImJvZHlfaml0dGVyX2RlbGF5IjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21heGltdW0iOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWV0aG9kIjoiRGVmYXVsdCIsImJvZHlfaml0dGVyX2RlbGF5X21pbmltdW0iOjIuMCwiYm9keV9qaXR0ZXJfcmFuZG9taXplX2RlbGF5IjoyLjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX3lhd19sZWZ0X2Ftb3VudCI6MC4wLCJkZWZlbnNpdmVfeWF3X3JpZ2h0X2Ftb3VudCI6MC4wLCJlbmFibGVfc3RhdGUiOnRydWUsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiRGlzYWJsZWQiLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjowLjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3IjoiSGlkZGVuIiwieWF3X2N1c3RvbSI6MC4wLCJ5YXdfaml0dGVyIjoiRGlzYWJsZWQiLCJ5YXdfbW9kZSI6IkwmUiIsInlhd19yYW5kb21fZmlyc3QiOjAuMCwieWF3X3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MC4wLCJsZWZ0X2Ftb3VudCI6LTQwLjAsInJhbmRvbWl6ZSI6NS4wLCJyaWdodF9hbW91bnQiOjI3LjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IlJhbmRvbSIsInBpdGNoX2N1c3RvbSI6MC4wLCJwaXRjaF9yYW5kb21fZmlyc3QiOi00NS4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjo0NS4wLCJ5YXciOiJTcGluIiwieWF3X2N1c3RvbSI6MC4wLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X21vZGUiOiJMJlIiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoyMC4wLCJ+eWF3X2ppdHRlciI6eyJhbW91bnQiOjAuMCwicmFuZG9taXplIjowLjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjowLjAsImxlZnRfYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wLCJyaWdodF9hbW91bnQiOjAuMH19LHsiYm9keV9qaXR0ZXIiOmZhbHNlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjpmYWxzZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJEaXNhYmxlZCIsInBpdGNoX2N1c3RvbSI6MC4wLCJwaXRjaF9yYW5kb21fZmlyc3QiOjAuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXciOiJIaWRkZW4iLCJ5YXdfY3VzdG9tIjowLjAsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJ5YXdfbW9kZSI6IlN0YXRpYyIsInlhd19yYW5kb21fZmlyc3QiOjAuMCwieWF3X3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjozOC4wLCJyYW5kb21pemUiOjAuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjAuMCwibGVmdF9hbW91bnQiOjAuMCwicmFuZG9taXplIjowLjAsInJpZ2h0X2Ftb3VudCI6MC4wfX1dXQ==")));
        configs.cfg_selector:update(configdata.menu_list);
        common.add_notify("NyaHook", "The meta preset was successfully loaded!");
        cvar.play:call("ambient\\office\\button1");
    end, true);
    import_anti_aim_settings = v71.tabs.anti_aim.left_builder_presets:button("Import", function()
        -- upvalues: l_v381_0 (ref), l_base64_0 (ref), l_clipboard_0 (ref)
        l_v381_0:load(json.parse(l_base64_0.decode(l_clipboard_0.get())));
        cvar.play:call("ambient\\tones\\elev1");
    end, true);
    export_anti_aim_settings = v71.tabs.anti_aim.left_builder_presets:button("Export", function()
        -- upvalues: l_clipboard_0 (ref), l_base64_0 (ref), l_v381_0 (ref)
        l_clipboard_0.set(l_base64_0.encode(json.stringify(l_v381_0:save())));
        cvar.play:call("ambient\\tones\\elev1");
    end, true);
end;
v381 = {};
local v383 = l_pui_0.setup({
    [1] = v71
}, true);
configdata = db.nyahook_dbshka or {};
configdata.cfg_list = configdata.cfg_list or {
    [1] = {
        [1] = "Default", 
        [2] = "W3siYW50aV9haW0iOnsiYXZvaWRfYmFja3N0YWIiOnRydWUsImJyYW5jaCI6MS4wLCJidWlsZGVyIjpbeyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6ZmFsc2UsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiUmFuZG9tIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6MC4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjoyNy4wLCJ5YXciOiJSYW5kb21cbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkRpc2FibGVkIiwieWF3X21vZGUiOiJTdGF0aWMiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxLjAsIn55YXdfaml0dGVyIjp7ImFtb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjAuMCwibGVmdF9hbW91bnQiOjAuMCwicmFuZG9taXplIjowLjAsInJpZ2h0X2Ftb3VudCI6MC4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJEaXNhYmxlZCIsInBpdGNoX2N1c3RvbSI6MC4wLCJwaXRjaF9yYW5kb21fZmlyc3QiOjAuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXciOiJIaWRkZW4iLCJ5YXdfY3VzdG9tIjowLjAsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJ5YXdfbW9kZSI6IlN0YXRpYyIsInlhd19yYW5kb21fZmlyc3QiOjAuMCwieWF3X3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotNjIuMCwicmFuZG9taXplIjoxNS4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MTIuMCwibGVmdF9hbW91bnQiOjAuMCwicmFuZG9taXplIjowLjAsInJpZ2h0X2Ftb3VudCI6MC4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJSYW5kb20iLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjotODkuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6NDUuMCwieWF3IjoiU3BpbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19tb2RlIjoiTCZSIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MTUuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotMzcuMCwicmFuZG9taXplIjoxMC4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MTIuMCwibGVmdF9hbW91bnQiOi0yNC4wLCJyYW5kb21pemUiOjUuMCwicmlnaHRfYW1vdW50IjoxNS4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJDdXN0b20iLCJwaXRjaF9jdXN0b20iOjQ1LjAsInBpdGNoX3JhbmRvbV9maXJzdCI6MC4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjowLjAsInlhdyI6IlNwaW4iLCJ5YXdfY3VzdG9tIjowLjAsInlhd19qaXR0ZXIiOiJEaXNhYmxlZCIsInlhd19tb2RlIjoiU3RhdGljIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MTUuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotNjIuMCwicmFuZG9taXplIjo1LjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50Ijo3LjAsImxlZnRfYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wLCJyaWdodF9hbW91bnQiOjAuMH19LHsiYm9keV9qaXR0ZXIiOnRydWUsImJvZHlfaml0dGVyX2RlbGF5IjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21heGltdW0iOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWV0aG9kIjoiRGVmYXVsdCIsImJvZHlfaml0dGVyX2RlbGF5X21pbmltdW0iOjIuMCwiYm9keV9qaXR0ZXJfcmFuZG9taXplX2RlbGF5IjoyLjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX3lhd19sZWZ0X2Ftb3VudCI6MC4wLCJkZWZlbnNpdmVfeWF3X3JpZ2h0X2Ftb3VudCI6MC4wLCJlbmFibGVfc3RhdGUiOnRydWUsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiUmFuZG9tIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6LTg5LjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjQ1LjAsInlhdyI6IlNwaW4iLCJ5YXdfY3VzdG9tIjowLjAsInlhd19qaXR0ZXIiOiJEaXNhYmxlZCIsInlhd19tb2RlIjoiTCZSIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MTUuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotMTAuMCwicmFuZG9taXplIjo1LjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjowLjAsImxlZnRfYW1vdW50IjotMjQuMCwicmFuZG9taXplIjoxMS4wLCJyaWdodF9hbW91bnQiOjQyLjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IlVwIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6LTg5LjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3IjoiRm9yd2FyZCIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19tb2RlIjoiU3RhdGljIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MzAuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotNjAuMCwicmFuZG9taXplIjowLjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjoxMi4wLCJsZWZ0X2Ftb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMCwicmlnaHRfYW1vdW50IjowLjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IkRpc2FibGVkIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6MC4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjowLjAsInlhdyI6IkhpZGRlbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkRpc2FibGVkIiwieWF3X21vZGUiOiJMJlIiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxLjAsIn55YXdfaml0dGVyIjp7ImFtb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjAuMCwibGVmdF9hbW91bnQiOi00MC4wLCJyYW5kb21pemUiOjUuMCwicmlnaHRfYW1vdW50IjoyNy4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJSYW5kb20iLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjotNDUuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6NDUuMCwieWF3IjoiU3BpbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19tb2RlIjoiTCZSIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MjAuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MC4wLCJsZWZ0X2Ftb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMCwicmlnaHRfYW1vdW50IjowLjB9fSx7ImJvZHlfaml0dGVyIjpmYWxzZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6ZmFsc2UsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiRGlzYWJsZWQiLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjowLjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3IjoiSGlkZGVuIiwieWF3X2N1c3RvbSI6MC4wLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X21vZGUiOiJTdGF0aWMiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxLjAsIn55YXdfaml0dGVyIjp7ImFtb3VudCI6MzguMCwicmFuZG9taXplIjowLjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjowLjAsImxlZnRfYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wLCJyaWdodF9hbW91bnQiOjAuMH19XSwiY3VycmVudF9zdGF0ZSI6IkNyb3VjaGluZyIsImVkZ2VfeWF3IjpmYWxzZSwiZmxpY2tfZXhwbG9pdCI6ZmFsc2UsImZvcmNlX2RlZmVuc2l2ZSI6WyJBaXIiLCJBaXItY3JvdWNoaW5nIiwifiJdLCJmcmVlc3RhbmRpbmciOmZhbHNlLCJsYWdfZXhwbG9pdCI6ZmFsc2UsIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsInNhZmVfaGVhZCI6dHJ1ZSwifmVkZ2VfeWF3Ijp7Imlnbm9yZV9tYW51YWxzIjp0cnVlfSwifmZsaWNrX2V4cGxvaXQiOnsiaW52ZXJ0ZXIiOmZhbHNlfSwifmZvcmNlX2RlZmVuc2l2ZSI6eyJhbHdheXNfb24iOmZhbHNlLCJjdXN0b21fdGlja3MiOjEuMCwibWV0aG9kIjoxLjAsInJhbmRvbV90aWNrc19maXJzdCI6MTIuMCwicmFuZG9tX3RpY2tzX3NlY29uZCI6MjIuMH0sIn5mcmVlc3RhbmRpbmciOnsiYm9keV9mcmVlc3RhbmRpbmciOnRydWUsImRpc2FibGVfeWF3X21vZGlmaWVycyI6dHJ1ZX0sIn5sYWdfZXhwbG9pdCI6eyJ0aWNrcyI6MTYuMH0sIn5tYW51YWxfeWF3Ijp7Im1hbnVhbF9vdmVyX2ZzIjp0cnVlLCJzdGF0aWNfeWF3Ijp0cnVlfSwifnNhZmVfaGVhZCI6eyJ0cmlnZ2VycyI6WyJBaXItQ3JvdWNoIEtuaWZlIiwifiJdfX0sImhvbWUiOnsic2VsZWN0X3RhYiI6Mi4wfSwibWlzYyI6eyJpbl9nYW1lIjp7ImFzcGVjdF9yYXRpbyI6dHJ1ZSwiY2xhbnRhZyI6ZmFsc2UsImtlZXBfbW9kZWxfdHJhbnNwYXJlbmN5Ijp0cnVlLCJ0cmFzaHRhbGsiOnRydWUsInZpZXdtb2RlbF9jaGFuZ2VyIjp0cnVlLCJ+YXNwZWN0X3JhdGlvIjp7InJhdGlvIjoxMzMuMH0sIn52aWV3bW9kZWxfY2hhbmdlciI6eyJ2aWV3bW9kZWxfZm92Ijo2NzAwLjAsInZpZXdtb2RlbF94IjoxMDAuMCwidmlld21vZGVsX3kiOi00MDAuMCwidmlld21vZGVsX3oiOjUwLjB9fSwibW92ZW1lbnQiOnsiZWRnZV9zdG9wIjpmYWxzZSwiZmFzdF9sYWRkZXIiOnRydWUsImp1bXBfc2NvdXQiOnRydWUsIm5vX2ZhbGxfZGFtYWdlIjp0cnVlfSwicmFnZWJvdCI6eyJhaW1ib3RfbG9ncyI6dHJ1ZSwiYW50aV9haW1fY29ycmVjdGlvbiI6ZmFsc2UsImRlY3JlYXNlX2hvbGRfYWltX3RpY2tzIjpmYWxzZSwiZmFrZV9sYXRlbmN5IjowLjAsImdyZW5hZGVfdGhyb3dfZml4Ijp0cnVlLCJoaXRjaGFuY2UiOnRydWUsIn5haW1ib3RfbG9ncyI6eyJoaXRfY29sb3IiOiIjQkE5RkRERkYiLCJtaXNzX2NvbG9yIjoiI0U2OTY5NkZGIiwib3V0cHV0IjpbIkNvbnNvbGUiLCJFdmVudCIsIk5vdGlmeSIsIn4iXSwicHVyY2hhc2VfbG9ncyI6dHJ1ZX0sIn5oaXRjaGFuY2UiOnsiYXV0b19zbmlwZXJzX2Fpcl9hbW91bnQiOjMzLjAsImF1dG9fc25pcGVyc19ub19zY29wZV9hbW91bnQiOjUwLjAsImF3cF9haXJfYW1vdW50IjozMy4wLCJhd3Bfbm9fc2NvcGVfYW1vdW50Ijo1MC4wLCJjdXJyZW50X3dlYXBvbiI6NC4wLCJlbmFibGVfYXV0b19zbmlwZXJzIjp0cnVlLCJlbmFibGVfYXdwIjpmYWxzZSwiZW5hYmxlX3Bpc3RvbHMiOnRydWUsImVuYWJsZV9yZXZvbHZlciI6dHJ1ZSwiZW5hYmxlX3NzZzA4Ijp0cnVlLCJwaXN0b2xzX2Fpcl9hbW91bnQiOjMzLjAsInJldm9sdmVyX2Fpcl9hbW91bnQiOjMzLjAsInNzZzA4X2Fpcl9hbW91bnQiOjMzLjAsInNzZzA4X25vX3Njb3BlX2Ftb3VudCI6NTAuMH19fSwidmlzdWFscyI6eyJhbmltYXRlZF96b29tIjpmYWxzZSwiY2VudGVyZWRfaW5kaWNhdG9ycyI6ZmFsc2UsImNsaWVudF9zaWRlX2FuaW1hdGlvbnMiOnRydWUsImN1c3RvbV9zY29wZV9vdmVybGF5Ijp0cnVlLCJkYW1hZ2VfaW5kaWNhdG9yIjp0cnVlLCJnYW1lc2Vuc2VfaW5kaWNhdG9ycyI6ZmFsc2UsImdyZW5hZGVfd2FybmluZyI6ZmFsc2UsImhpdG1hcmtlciI6ZmFsc2UsImtleWJpbmRzIjpmYWxzZSwibWFudWFsX2Fycm93cyI6ZmFsc2UsInNwZWN0YXRvcnMiOmZhbHNlLCJ2ZWxvY2l0eV9pbmRpY2F0b3IiOnRydWUsIndhdGVybWFyayI6dHJ1ZSwifmNlbnRlcmVkX2luZGljYXRvcnMiOnsiY2VudGVyZWRfaW5kaWNhdG9yc19jb2xvciI6IiNFNzk1QzdGRiIsIm9mZnNldCI6NDAuMH0sIn5jbGllbnRfc2lkZV9hbmltYXRpb25zIjp7ImFkZG9ucyI6WyJNb3ZlIExlYW4iLCJ+Il0sImFpcl9sZWdzIjoiRGlzYWJsZWQiLCJncm91bmRfbGVncyI6IkRpc2FibGVkIiwibW92ZV9sZWFuX2Ftb3VudCI6MTAwLjB9LCJ+Y3VzdG9tX3Njb3BlX292ZXJsYXkiOnsiZ2FwIjo1LjAsImludmVydGVkIjpmYWxzZSwic2NvcGVfY29sb3IiOiIjQUFBQUFBRkYiLCJzaXplIjoxNTAuMCwidF9wb3NlIjpmYWxzZSwidmlld21vZGVsX2luX3Njb3BlIjpmYWxzZX0sIn5kYW1hZ2VfaW5kaWNhdG9yIjp7ImZvbnQiOiJEZWZhdWx0In0sIn5nYW1lc2Vuc2VfaW5kaWNhdG9ycyI6eyJhbmltYXRlZCI6ZmFsc2UsInNlbGVjdCI6WyJEb3VibGUgVGFwIiwiSGlkZSBTaG90cyIsIkZha2UgTGF0ZW5jeSIsIk1pbi4gRGFtYWdlIE92ZXJyaWRlIiwiQm9keSBBaW0iLCJGb3JjZSBTYWZlIFBvaW50IiwiRnJlZXN0YW5kaW5nIiwiRG9ybWFudCBBaW1ib3QiLCJCb21iIEluZm9ybWF0aW9uIiwiSGl0L01pc3MgUmF0ZSIsIn4iXSwic3R5bGUiOiJDbGFzc2ljIn0sIn5ncmVuYWRlX3dhcm5pbmciOnsiZ3JlbmFkZV93YXJuaW5nX2NvbG9yIjoiI0IxOUNENEZGIn0sIn5oaXRtYXJrZXIiOnsiaGl0bWFya2VyX2NvbG9yIjoiI0ZGRkZGRkZGIn0sIn5rZXliaW5kcyI6eyJrZXliaW5kc19jb2xvciI6IiNGRkZGRkZGRiJ9LCJ+bWFudWFsX2Fycm93cyI6eyJhcnJvd3NfY29sb3IiOiIjQjk5MUNCRkYiLCJhcnJvd3Nfc3R5bGUiOiJDbGFzc2ljIiwib2Zmc2V0Ijo1OC4wfSwifnNwZWN0YXRvcnMiOnsic3BlY3RhdG9yc19jb2xvciI6IiNGRkZGRkZGRiJ9LCJ+dmVsb2NpdHlfaW5kaWNhdG9yIjp7InZlbG9jaXR5X2luZGljYXRvcl9jb2xvciI6IiNGRkI0RTJGRiJ9LCJ+d2F0ZXJtYXJrIjp7InN0eWxlIjoiTW9kZXJuIiwid2F0ZXJtYXJrX2NvbG9yIjoiI0FDOTVDMkZGIn19fV0="
    }
};
configdata.menu_list = configdata.menu_list or {
    [1] = "Default"
};
configdata.cfg_list[1][2] = "W3siYW50aV9haW0iOnsiYXZvaWRfYmFja3N0YWIiOnRydWUsImJyYW5jaCI6MS4wLCJidWlsZGVyIjpbeyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6ZmFsc2UsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiUmFuZG9tIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6MC4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjoyNy4wLCJ5YXciOiJSYW5kb21cbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkRpc2FibGVkIiwieWF3X21vZGUiOiJTdGF0aWMiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxLjAsIn55YXdfaml0dGVyIjp7ImFtb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjAuMCwibGVmdF9hbW91bnQiOjAuMCwicmFuZG9taXplIjowLjAsInJpZ2h0X2Ftb3VudCI6MC4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJEaXNhYmxlZCIsInBpdGNoX2N1c3RvbSI6MC4wLCJwaXRjaF9yYW5kb21fZmlyc3QiOjAuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXciOiJIaWRkZW4iLCJ5YXdfY3VzdG9tIjowLjAsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJ5YXdfbW9kZSI6IlN0YXRpYyIsInlhd19yYW5kb21fZmlyc3QiOjAuMCwieWF3X3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotNjIuMCwicmFuZG9taXplIjoxNS4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MTIuMCwibGVmdF9hbW91bnQiOjAuMCwicmFuZG9taXplIjowLjAsInJpZ2h0X2Ftb3VudCI6MC4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJSYW5kb20iLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjotODkuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6NDUuMCwieWF3IjoiU3BpbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19tb2RlIjoiTCZSIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MTUuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotMzcuMCwicmFuZG9taXplIjoxMC4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MTIuMCwibGVmdF9hbW91bnQiOi0yNC4wLCJyYW5kb21pemUiOjUuMCwicmlnaHRfYW1vdW50IjoxNS4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJDdXN0b20iLCJwaXRjaF9jdXN0b20iOjQ1LjAsInBpdGNoX3JhbmRvbV9maXJzdCI6MC4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjowLjAsInlhdyI6IlNwaW4iLCJ5YXdfY3VzdG9tIjowLjAsInlhd19qaXR0ZXIiOiJEaXNhYmxlZCIsInlhd19tb2RlIjoiU3RhdGljIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MTUuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotNjIuMCwicmFuZG9taXplIjo1LjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50Ijo3LjAsImxlZnRfYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wLCJyaWdodF9hbW91bnQiOjAuMH19LHsiYm9keV9qaXR0ZXIiOnRydWUsImJvZHlfaml0dGVyX2RlbGF5IjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21heGltdW0iOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWV0aG9kIjoiRGVmYXVsdCIsImJvZHlfaml0dGVyX2RlbGF5X21pbmltdW0iOjIuMCwiYm9keV9qaXR0ZXJfcmFuZG9taXplX2RlbGF5IjoyLjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX3lhd19sZWZ0X2Ftb3VudCI6MC4wLCJkZWZlbnNpdmVfeWF3X3JpZ2h0X2Ftb3VudCI6MC4wLCJlbmFibGVfc3RhdGUiOnRydWUsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiUmFuZG9tIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6LTg5LjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjQ1LjAsInlhdyI6IlNwaW4iLCJ5YXdfY3VzdG9tIjowLjAsInlhd19qaXR0ZXIiOiJEaXNhYmxlZCIsInlhd19tb2RlIjoiTCZSIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MTUuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotMTAuMCwicmFuZG9taXplIjo1LjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjowLjAsImxlZnRfYW1vdW50IjotMjQuMCwicmFuZG9taXplIjoxMS4wLCJyaWdodF9hbW91bnQiOjQyLjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IlVwIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6LTg5LjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3IjoiRm9yd2FyZCIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19tb2RlIjoiU3RhdGljIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MzAuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotNjAuMCwicmFuZG9taXplIjowLjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjoxMi4wLCJsZWZ0X2Ftb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMCwicmlnaHRfYW1vdW50IjowLjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IkRpc2FibGVkIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6MC4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjowLjAsInlhdyI6IkhpZGRlbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkRpc2FibGVkIiwieWF3X21vZGUiOiJMJlIiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxLjAsIn55YXdfaml0dGVyIjp7ImFtb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjAuMCwibGVmdF9hbW91bnQiOi00MC4wLCJyYW5kb21pemUiOjUuMCwicmlnaHRfYW1vdW50IjoyNy4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJSYW5kb20iLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjotNDUuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6NDUuMCwieWF3IjoiU3BpbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19tb2RlIjoiTCZSIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MjAuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MC4wLCJsZWZ0X2Ftb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMCwicmlnaHRfYW1vdW50IjowLjB9fSx7ImJvZHlfaml0dGVyIjpmYWxzZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6ZmFsc2UsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiRGlzYWJsZWQiLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjowLjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3IjoiSGlkZGVuIiwieWF3X2N1c3RvbSI6MC4wLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X21vZGUiOiJTdGF0aWMiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxLjAsIn55YXdfaml0dGVyIjp7ImFtb3VudCI6MzguMCwicmFuZG9taXplIjowLjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjowLjAsImxlZnRfYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wLCJyaWdodF9hbW91bnQiOjAuMH19XSwiY3VycmVudF9zdGF0ZSI6IkNyb3VjaGluZyIsImVkZ2VfeWF3IjpmYWxzZSwiZmxpY2tfZXhwbG9pdCI6ZmFsc2UsImZvcmNlX2RlZmVuc2l2ZSI6WyJBaXIiLCJBaXItY3JvdWNoaW5nIiwifiJdLCJmcmVlc3RhbmRpbmciOmZhbHNlLCJsYWdfZXhwbG9pdCI6ZmFsc2UsIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsInNhZmVfaGVhZCI6dHJ1ZSwifmVkZ2VfeWF3Ijp7Imlnbm9yZV9tYW51YWxzIjp0cnVlfSwifmZsaWNrX2V4cGxvaXQiOnsiaW52ZXJ0ZXIiOmZhbHNlfSwifmZvcmNlX2RlZmVuc2l2ZSI6eyJhbHdheXNfb24iOmZhbHNlLCJjdXN0b21fdGlja3MiOjEuMCwibWV0aG9kIjoxLjAsInJhbmRvbV90aWNrc19maXJzdCI6MTIuMCwicmFuZG9tX3RpY2tzX3NlY29uZCI6MjIuMH0sIn5mcmVlc3RhbmRpbmciOnsiYm9keV9mcmVlc3RhbmRpbmciOnRydWUsImRpc2FibGVfeWF3X21vZGlmaWVycyI6dHJ1ZX0sIn5sYWdfZXhwbG9pdCI6eyJ0aWNrcyI6MTYuMH0sIn5tYW51YWxfeWF3Ijp7Im1hbnVhbF9vdmVyX2ZzIjp0cnVlLCJzdGF0aWNfeWF3Ijp0cnVlfSwifnNhZmVfaGVhZCI6eyJ0cmlnZ2VycyI6WyJBaXItQ3JvdWNoIEtuaWZlIiwifiJdfX0sImhvbWUiOnsic2VsZWN0X3RhYiI6Mi4wfSwibWlzYyI6eyJpbl9nYW1lIjp7ImFzcGVjdF9yYXRpbyI6dHJ1ZSwiY2xhbnRhZyI6ZmFsc2UsImtlZXBfbW9kZWxfdHJhbnNwYXJlbmN5Ijp0cnVlLCJ0cmFzaHRhbGsiOnRydWUsInZpZXdtb2RlbF9jaGFuZ2VyIjp0cnVlLCJ+YXNwZWN0X3JhdGlvIjp7InJhdGlvIjoxMzMuMH0sIn52aWV3bW9kZWxfY2hhbmdlciI6eyJ2aWV3bW9kZWxfZm92Ijo2NzAwLjAsInZpZXdtb2RlbF94IjoxMDAuMCwidmlld21vZGVsX3kiOi00MDAuMCwidmlld21vZGVsX3oiOjUwLjB9fSwibW92ZW1lbnQiOnsiZWRnZV9zdG9wIjpmYWxzZSwiZmFzdF9sYWRkZXIiOnRydWUsImp1bXBfc2NvdXQiOnRydWUsIm5vX2ZhbGxfZGFtYWdlIjp0cnVlfSwicmFnZWJvdCI6eyJhaW1ib3RfbG9ncyI6dHJ1ZSwiYW50aV9haW1fY29ycmVjdGlvbiI6ZmFsc2UsImRlY3JlYXNlX2hvbGRfYWltX3RpY2tzIjpmYWxzZSwiZmFrZV9sYXRlbmN5IjowLjAsImdyZW5hZGVfdGhyb3dfZml4Ijp0cnVlLCJoaXRjaGFuY2UiOnRydWUsIn5haW1ib3RfbG9ncyI6eyJoaXRfY29sb3IiOiIjQkE5RkRERkYiLCJtaXNzX2NvbG9yIjoiI0U2OTY5NkZGIiwib3V0cHV0IjpbIkNvbnNvbGUiLCJFdmVudCIsIk5vdGlmeSIsIn4iXSwicHVyY2hhc2VfbG9ncyI6dHJ1ZX0sIn5oaXRjaGFuY2UiOnsiYXV0b19zbmlwZXJzX2Fpcl9hbW91bnQiOjMzLjAsImF1dG9fc25pcGVyc19ub19zY29wZV9hbW91bnQiOjUwLjAsImF3cF9haXJfYW1vdW50IjozMy4wLCJhd3Bfbm9fc2NvcGVfYW1vdW50Ijo1MC4wLCJjdXJyZW50X3dlYXBvbiI6NC4wLCJlbmFibGVfYXV0b19zbmlwZXJzIjp0cnVlLCJlbmFibGVfYXdwIjpmYWxzZSwiZW5hYmxlX3Bpc3RvbHMiOnRydWUsImVuYWJsZV9yZXZvbHZlciI6dHJ1ZSwiZW5hYmxlX3NzZzA4Ijp0cnVlLCJwaXN0b2xzX2Fpcl9hbW91bnQiOjMzLjAsInJldm9sdmVyX2Fpcl9hbW91bnQiOjMzLjAsInNzZzA4X2Fpcl9hbW91bnQiOjMzLjAsInNzZzA4X25vX3Njb3BlX2Ftb3VudCI6NTAuMH19fSwidmlzdWFscyI6eyJhbmltYXRlZF96b29tIjpmYWxzZSwiY2VudGVyZWRfaW5kaWNhdG9ycyI6ZmFsc2UsImNsaWVudF9zaWRlX2FuaW1hdGlvbnMiOnRydWUsImN1c3RvbV9zY29wZV9vdmVybGF5Ijp0cnVlLCJkYW1hZ2VfaW5kaWNhdG9yIjp0cnVlLCJnYW1lc2Vuc2VfaW5kaWNhdG9ycyI6ZmFsc2UsImdyZW5hZGVfd2FybmluZyI6ZmFsc2UsImhpdG1hcmtlciI6ZmFsc2UsImtleWJpbmRzIjpmYWxzZSwibWFudWFsX2Fycm93cyI6ZmFsc2UsInNwZWN0YXRvcnMiOmZhbHNlLCJ2ZWxvY2l0eV9pbmRpY2F0b3IiOnRydWUsIndhdGVybWFyayI6dHJ1ZSwifmNlbnRlcmVkX2luZGljYXRvcnMiOnsiY2VudGVyZWRfaW5kaWNhdG9yc19jb2xvciI6IiNFNzk1QzdGRiIsIm9mZnNldCI6NDAuMH0sIn5jbGllbnRfc2lkZV9hbmltYXRpb25zIjp7ImFkZG9ucyI6WyJNb3ZlIExlYW4iLCJ+Il0sImFpcl9sZWdzIjoiRGlzYWJsZWQiLCJncm91bmRfbGVncyI6IkRpc2FibGVkIiwibW92ZV9sZWFuX2Ftb3VudCI6MTAwLjB9LCJ+Y3VzdG9tX3Njb3BlX292ZXJsYXkiOnsiZ2FwIjo1LjAsImludmVydGVkIjpmYWxzZSwic2NvcGVfY29sb3IiOiIjQUFBQUFBRkYiLCJzaXplIjoxNTAuMCwidF9wb3NlIjpmYWxzZSwidmlld21vZGVsX2luX3Njb3BlIjpmYWxzZX0sIn5kYW1hZ2VfaW5kaWNhdG9yIjp7ImZvbnQiOiJEZWZhdWx0In0sIn5nYW1lc2Vuc2VfaW5kaWNhdG9ycyI6eyJhbmltYXRlZCI6ZmFsc2UsInNlbGVjdCI6WyJEb3VibGUgVGFwIiwiSGlkZSBTaG90cyIsIkZha2UgTGF0ZW5jeSIsIk1pbi4gRGFtYWdlIE92ZXJyaWRlIiwiQm9keSBBaW0iLCJGb3JjZSBTYWZlIFBvaW50IiwiRnJlZXN0YW5kaW5nIiwiRG9ybWFudCBBaW1ib3QiLCJCb21iIEluZm9ybWF0aW9uIiwiSGl0L01pc3MgUmF0ZSIsIn4iXSwic3R5bGUiOiJDbGFzc2ljIn0sIn5ncmVuYWRlX3dhcm5pbmciOnsiZ3JlbmFkZV93YXJuaW5nX2NvbG9yIjoiI0IxOUNENEZGIn0sIn5oaXRtYXJrZXIiOnsiaGl0bWFya2VyX2NvbG9yIjoiI0ZGRkZGRkZGIn0sIn5rZXliaW5kcyI6eyJrZXliaW5kc19jb2xvciI6IiNGRkZGRkZGRiJ9LCJ+bWFudWFsX2Fycm93cyI6eyJhcnJvd3NfY29sb3IiOiIjQjk5MUNCRkYiLCJhcnJvd3Nfc3R5bGUiOiJDbGFzc2ljIiwib2Zmc2V0Ijo1OC4wfSwifnNwZWN0YXRvcnMiOnsic3BlY3RhdG9yc19jb2xvciI6IiNGRkZGRkZGRiJ9LCJ+dmVsb2NpdHlfaW5kaWNhdG9yIjp7InZlbG9jaXR5X2luZGljYXRvcl9jb2xvciI6IiNGRkI0RTJGRiJ9LCJ+d2F0ZXJtYXJrIjp7InN0eWxlIjoiTW9kZXJuIiwid2F0ZXJtYXJrX2NvbG9yIjoiI0FDOTVDMkZGIn19fV0=";
do
    local l_v383_0 = v383;
    v381.save_config = function(v385)
        -- upvalues: l_v383_0 (ref), l_base64_0 (ref)
        if v385 == 1 then
            return;
        else
            local v386 = l_v383_0:save();
            configdata.cfg_list[v385][2] = l_base64_0.encode(json.stringify(v386));
            cvar.play:call("ambient\\tones\\elev1");
            db.nyahook_dbshka = configdata;
            return;
        end;
    end;
    v381.update_values = function(v387)
        local v388 = configdata.cfg_list[v387][1] .. "\a{Link Active} ~ Loaded";
        for v389, v390 in ipairs(configdata.cfg_list) do
            configdata.menu_list[v389] = v390[1];
        end;
        configdata.menu_list[v387] = v388;
    end;
    v381.create_config = function(v391)
        if type(v391) ~= "string" then
            return;
        elseif v391 == nil or v391 == "" or v391 == " " then
            return;
        else
            for v392 = #configdata.menu_list, 1, -1 do
                if configdata.menu_list[v392] == v391 then
                    common.add_notify("\vNyaHook", "Config with this name has already been created.");
                    return;
                end;
            end;
            if #configdata.cfg_list > 10 then
                common.add_notify("\vNyaHook", "Too much configs");
                return;
            else
                local v393 = {
                    [1] = nil, 
                    [2] = "", 
                    [1] = v391
                };
                table.insert(configdata.cfg_list, v393);
                table.insert(configdata.menu_list, v391);
                db.nyahook_dbshka = configdata;
                return;
            end;
        end;
    end;
    v381.remove_config = function(v394)
        if v394 == 1 then
            return;
        else
            local v395 = configdata.cfg_list[v394][1];
            for v396 = #configdata.cfg_list, 1, -1 do
                if configdata.cfg_list[v396][1] == v395 then
                    table.remove(configdata.cfg_list, v396);
                    table.remove(configdata.menu_list, v396);
                end;
            end;
            db.nyahook_dbshka = configdata;
            return;
        end;
    end;
    v381.load_config = function(v397)
        -- upvalues: l_v383_0 (ref), l_base64_0 (ref)
        if configdata.cfg_list[v397][2] == nil or configdata.cfg_list[v397][2] == "" then
            print("Error[data_base[" .. v397 .. "]]");
            return;
        elseif #configdata.cfg_list < v397 then
            print("Error[data_base[" .. v397 .. "]]");
            return;
        else
            l_v383_0:load(json.parse(l_base64_0.decode(configdata.cfg_list[v397][2])));
            cvar.play:call("ambient\\tones\\elev1");
            return;
        end;
    end;
    configs = {
        cfg_selector = v71.tabs.home.image:list("", configdata.menu_list), 
        name = v71.tabs.home.image:input("\v\f<file-pen>\r" .. "  Config name"), 
        create = v71.tabs.home.image:button("                                 \v\f<paintbrush-fine>\r  Create                               ", function()
            -- upvalues: v381 (ref)
            v381.create_config(configs.name:get());
            configs.cfg_selector:update(configdata.menu_list);
        end, true), 
        load = v71.tabs.home.image:button("   \v\f<upload>\r  Load   ", function()
            -- upvalues: v381 (ref)
            v381.update_values(configs.cfg_selector:get());
            v381.load_config(configs.cfg_selector:get());
            configs.cfg_selector:update(configdata.menu_list);
        end, true), 
        save = v71.tabs.home.image:button("   \v\f<floppy-disk>\r  Save   ", function()
            -- upvalues: v381 (ref)
            v381.save_config(configs.cfg_selector:get());
        end, true), 
        remove = v71.tabs.home.image:button("    \v\f<trash-xmark>\r  Remove    ", function()
            -- upvalues: v381 (ref)
            v381.remove_config(configs.cfg_selector:get());
            configs.cfg_selector:update(configdata.menu_list);
        end, true), 
        import = v71.tabs.home.image:button("                 \v\f<file-import>\r                 ", function()
            -- upvalues: l_v383_0 (ref), l_base64_0 (ref), l_clipboard_0 (ref)
            l_v383_0:load(json.parse(l_base64_0.decode(l_clipboard_0.get())));
            cvar.play:call("ambient\\tones\\elev1");
        end, true), 
        export = v71.tabs.home.image:button("                 \v\f<file-export>\r                  ", function()
            -- upvalues: l_clipboard_0 (ref), l_base64_0 (ref), l_v383_0 (ref)
            l_clipboard_0.set(l_base64_0.encode(json.stringify(l_v383_0:save())));
            cvar.play:call("ambient\\tones\\elev1");
        end, true)
    };
    configs.import:tooltip("\226\128\162 Import config from clipboard.");
    configs.export:tooltip("\226\128\162 Export config to clipboard.");
end;
events.render:set(function()
    -- upvalues: v175 (ref), v176 (ref)
    v175.watermark();
    v175.gamesense_indicators();
    v175.centered_indicators();
    v175.manual_arrows();
    v175.custom_scope_overlay();
    v175.hitmarker();
    v176.in_game.aspect_ratio();
    v176.in_game.viewmodel_changer();
    v176.logs.notifications();
    v176.ragebot.fake_latency();
end);
events.createmove:set(function(v398)
    -- upvalues: v110 (ref), v176 (ref)
    v110.player_data.write_player_data();
    v110.override_defensive();
    v110.builder(v398);
    v110.addons();
    v176.movement.no_fall_damage(v398);
    v176.movement.fast_ladder(v398);
    v176.movement.edge_stop(v398);
    v176.movement.jump_scout(v398);
    v176.movement.super_toss(v398);
    v176.ragebot.hitchance(v398);
    v176.ragebot.grenade_throw_fix();
end);
events.grenade_override_view:set(v176.movement.on_grenade_override_view);
events.player_death:set(v176.in_game.trashtalk.trashtalk);
events.aim_ack:set(function(v399)
    -- upvalues: v176 (ref), v175 (ref)
    v176.logs.aimbot(v399);
    v175.hitmarker_refs.hitmarker_ack(v399);
    if v399.state == nil then
        v175.total_hits = v175.total_hits + 1;
    end;
    v175.total_registered_shots = v175.total_registered_shots + 1;
end);
events.player_hurt:set(v176.logs.additional);
events.item_purchase:set(v176.logs.purchase);
events.localplayer_transparency:set(v176.in_game.keep_model_transparency);
events.override_view:set(v175.animated_zoom);
events.post_update_clientside_animation:set(v175.client_side_animations);
events.grenade_warning:set(v175.grenade_warning);
events.round_end:set(function()
    round_end_trigger = true;
end);
events.round_start:set(function()
    -- upvalues: v176 (ref), v71 (ref), v110 (ref)
    round_end_trigger = false;
    table.insert(v176.logs.notify_data, 1, {
        add_x = 0, 
        alpha_text = 0, 
        alpha = 0, 
        add_y = 0, 
        text = string.format("\v Reset on new round!", target_name, state, wanted_hitgroup), 
        time = globals.realtime, 
        color = v71.misc.ragebot.aimbot_logs.hit_color:get()
    });
    v110.player_data.entindex = -1;
    v110.player_data.alive = false;
    v110.player_data.onground = true;
    v110.player_data.velocity = 0;
    v110.player_data.duckamount = 0;
    v110.player_data.stamina = 80;
    v110.player_data.onground_ticks = 0;
    v110.player_data.stateid = 1;
end);
events.shutdown:set(function()
    cvar.sv_maxunlag:float(0.2);
    cvar.r_aspectratio:float(0);
    cvar.viewmodel_fov:float(68);
    cvar.viewmodel_offset_x:float(2.5);
    cvar.viewmodel_offset_y:float(0);
    cvar.viewmodel_offset_z:float(-1.5);
    cvar.sv_maxusrcmdprocessticks_holdaim:int(1);
    db.nyahook_dbshka = configdata;
end);
events.mouse_input:set(function()
    if ui.get_alpha() > 0 then
        return false;
    else
        return;
    end;
end);