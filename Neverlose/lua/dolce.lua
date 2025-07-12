local l_pui_0 = require("neverlose/pui");
local _ = require("neverlose/smoothy");
local l_bomb_0 = require("neverlose/bomb");
local l_clipboard_0 = require("neverlose/clipboard");
local l_base64_0 = require("neverlose/base64");
local l_bit_0 = require("bit");
local l_json_0 = require("json");
local _ = 64;
local v8 = 180;
local v9 = -180;
local v10 = 60;
local v11 = 4;
local v12 = 0.5;
local v13 = 4;
local v14 = 5;
local v15 = 5;
local v16 = 150;
local v17 = 0.5;
local _ = 0.1;
events.render:set(function(_)
    local v20 = ("\a%02X%02X%02X%02X"):format(186, 144, 192, 255) .. "Dolce Solutions";
    ui.sidebar(v20, "\240\159\144\190");
end);
local v21 = {
    accent = "\v", 
    reset = "\r", 
    icon = "\v\f"
};
local v22 = {
    house = v21.icon .. "<house>" .. v21.reset, 
    star = v21.icon .. "<star-christmas>" .. v21.reset, 
    user = v21.icon .. "<user>" .. v21.reset, 
    branch = v21.icon .. "<code-fork>" .. v21.reset, 
    link = v21.icon .. "<link>" .. v21.reset, 
    youtube = v21.icon .. "<youtube>" .. v21.reset, 
    discord = v21.icon .. "<discord>" .. v21.reset, 
    arrows_turn = v21.icon .. "<arrows-turn-to-dots>" .. v21.reset, 
    arrows_dotted = v21.icon .. "<arrows-to-dotted-line>" .. v21.reset, 
    gear = v21.icon .. "<gear>" .. v21.reset, 
    folders = v21.icon .. "<folders>" .. v21.reset, 
    star_shooting = v21.icon .. "<star-shooting>" .. v21.reset, 
    pen_to_square = v21.icon .. "<pen-to-square>" .. v21.reset, 
    wand_magic_sparkles = v21.icon .. "<wand-magic-sparkles>" .. v21.reset, 
    shieldhalved = v21.icon .. "<shield-halved>" .. v21.reset, 
    layergroup = v21.icon .. "<layer-group>" .. v21.reset
};
local v23 = {
    pitch = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
    yaw = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Yaw", {
        hidden = "Hidden", 
        base = "Base", 
        avoid_backstab = "Avoid Backstab", 
        offset = "Offset"
    }), 
    yaw_modifier = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", {
        offset = "Offset"
    }), 
    body_yaw = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", {
        left_limit = "Left Limit", 
        freestanding = "Freestanding", 
        inverter = "Inverter", 
        options = "Options", 
        right_limit = "Right Limit"
    }), 
    freestanding = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Freestanding", {
        disable_yaw_modifiers = "Disable Yaw Modifiers", 
        body_freestanding = "Body Freestanding"
    }), 
    slow_walk = l_pui_0.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
    fake_duck = l_pui_0.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
    legs_movement = l_pui_0.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"), 
    lag_options = l_pui_0.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
    hide_shots_options = l_pui_0.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
    doubletap = l_pui_0.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
    hide_shots = l_pui_0.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
    minimum_damage = l_pui_0.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
    body_aim = l_pui_0.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
    safe_point = l_pui_0.find("Aimbot", "Ragebot", "Safety", "Safe Points"), 
    dormant_aimbot = l_pui_0.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
    field_of_view = l_pui_0.find("Visuals", "World", "Main", "Field of View"), 
    override_zoom = l_pui_0.find("Visuals", "World", "Main", "Override Zoom", {
        scope_overlay = "Scope Overlay", 
        force_viewmodel = "Force Viewmodel"
    }), 
    fake_latency = l_pui_0.find("Miscellaneous", "Main", "Other", "Fake Latency"), 
    air_strafe = l_pui_0.find("Miscellaneous", "Main", "Movement", "Air Strafe"), 
    weapon_actions = l_pui_0.find("Miscellaneous", "Main", "Other", "Weapon Actions")
};
local v24 = {
    home = l_pui_0.create(v22.house, {
        [1] = {
            [1] = "main", 
            [2] = "Dolce ~ \vuser", 
            [3] = 1
        }, 
        [2] = {
            [1] = "configs", 
            [2] = "Dolce ~ \vconfigs", 
            [3] = 2
        }
    }), 
    anti_aim = l_pui_0.create(v22.shieldhalved, {
        [1] = {
            [1] = "main", 
            [2] = "Dolce ~ \vmain", 
            [3] = 1
        }, 
        [2] = {
            [1] = "direction", 
            [2] = "Dolce ~ \vadditional", 
            [3] = 1
        }, 
        [3] = {
            [1] = "exploits", 
            [2] = "Dolce ~ \vexploits manager", 
            [3] = 1
        }, 
        [4] = {
            [1] = "bruteforce", 
            [2] = "Dolce ~ \vbruteforce", 
            [3] = 1
        }, 
        [5] = {
            [1] = "builder", 
            [2] = "Dolce ~ \vbuilder", 
            [3] = 2
        }
    }), 
    other = l_pui_0.create(v22.star, {
        [1] = {
            [1] = "visuals", 
            [2] = "Dolce ~ \vvisuals", 
            [3] = 1
        }, 
        [2] = {
            [1] = "movement", 
            [2] = "Dolce ~ \vmovement", 
            [3] = 2
        }, 
        [3] = {
            [1] = "in_game", 
            [2] = "Dolce ~ \vin game", 
            [3] = 2
        }, 
        [4] = {
            [1] = "view", 
            [2] = "Dolce ~ \vview", 
            [3] = 2
        }
    })
};
local function v27(v25, v26)
    if not v25 then
        return;
    else
        print_raw("\a" .. v26:to_hex() .. "Dolce \aDEFAULT| " .. v25);
        return;
    end;
end;
local function _(v28)
    return v28 == 0 and "off" or v28 .. "%";
end;
local function _(v30)
    return v30 == 0 and "disabled" or v30 .. "t";
end;
local function v33(v32)
    return v32 < 2 and "default" or v32 .. "t";
end;
local function v36(v34, v35)
    return v34 < 1 and "disabled" or v34 .. v35;
end;
local v37 = {
    smoothy = {}
};
v37.smoothy.native_GetTimescale = utils.get_vfunc("engine.dll", "VEngineClient014", 91, "float(__thiscall*)(void*)");
v37.smoothy.to_pairs = {
    vector = {
        [1] = "x", 
        [2] = "y", 
        [3] = "z"
    }, 
    imcolor = {
        [1] = "r", 
        [2] = "g", 
        [3] = "b", 
        [4] = "a"
    }
};
local function v42(v38, v39, v40, v41)
    return v40 * v38 / v41 + v39;
end;
v37.smoothy.get_type = function(v43)
    local v44 = type(v43);
    if v44 == "userdata" and v43.__type then
        return string.lower(v43.__type.name);
    else
        if v44 == "boolean" then
            v43 = v43 and 1 or 0;
        end;
        return v44;
    end;
end;
v37.smoothy.copy_tables = function(v45, v46, v47)
    -- upvalues: v37 (ref)
    if not v47 then
        v47 = v46;
    end;
    local v48 = getmetatable(v46);
    if v48 and getmetatable(v45) == nil then
        setmetatable(v45, v48);
    end;
    for v49, v50 in pairs(v46) do
        if type(v50) == "table" then
            v45[v49] = v37.smoothy.copy_tables({}, v50, v47[v49]);
        else
            local v51 = v47[v49];
            if type(v51) == "boolean" then
                v51 = v51 and 1 or 0;
            end;
            v45[v49] = v51;
        end;
    end;
    return v45;
end;
v37.smoothy.resolve = function(v52, v53, v54, v55, v56)
    if type(v54) == "boolean" then
        v54 = v54 and 1 or 0;
    end;
    if type(v53) == "boolean" then
        v53 = v53 and 1 or 0;
    end;
    if type(v54) == "string" then
        v54 = tonumber(v54) or 0;
    end;
    if type(v53) == "string" then
        v53 = tonumber(v53) or 0;
    end;
    local v57 = v52(v55, v53, v54 - v53, v56);
    if type(v54) == "number" then
        if math.abs(v54 - v57) <= 0.001 then
            v57 = v54;
        end;
        if v57 % 1 < 1.0E-4 then
            v57 = math.floor(v57);
        elseif v57 % 1 > 0.9999 then
            v57 = math.ceil(v57);
        end;
    end;
    return v57;
end;
v37.smoothy.perform_easing = function(v58, v59, v60, v61, v62, v63)
    -- upvalues: v37 (ref)
    if v37.smoothy.to_pairs[v58] then
        for _, v65 in ipairs(v37.smoothy.to_pairs[v58]) do
            v60[v65] = v37.smoothy.perform_easing(type(v61[v65]), v59, v60[v65], v61[v65], v62, v63);
        end;
        return v60;
    elseif v58 == "table" then
        for v66, v67 in pairs(v61) do
            v60[v66] = v60[v66] or v67;
            v60[v66] = v37.smoothy.perform_easing(type(v67), v59, v60[v66], v67, v62, v63);
        end;
        return v60;
    else
        return v37.smoothy.resolve(v59, v60, v61, v62, v63);
    end;
end;
v37.smoothy.adjusted_speed = nil;
v37.smoothy.base_speed = 0.15;
v37.smoothy._list = {};
do
    local l_v42_0 = v42;
    v37.smoothy.new = function(v69, v70, v71, v72)
        -- upvalues: v37 (ref), l_v42_0 (ref)
        if v69 == nil then
            return v70;
        else
            if v37.smoothy._list[v69] == nil then
                local v73 = nil;
                if type(v70) == "userdata" then
                    if v70.__type and string.lower(v70.__type.name) == "imcolor" then
                        v73 = color(v70.r, v70.g, v70.b, v70.a);
                    else
                        v73 = v70:clone();
                    end;
                elseif type(v70) == "boolean" then
                    v73 = v70 and 1 or 0;
                else
                    v73 = v70;
                end;
                v37.smoothy._list[v69] = v72 or v73;
            end;
            local v74 = v37.smoothy._list[v69];
            if v74 == v70 then
                return v70;
            else
                local v75 = v71 or v37.smoothy.base_speed;
                local v76 = globals.frametime / v37.smoothy.native_GetTimescale();
                local _ = v37.smoothy.get_type(v70);
                local v78 = v37.smoothy.get_type(v74);
                if v37.smoothy.adjusted_speed then
                    v75 = v75 * v37.smoothy.adjusted_speed;
                end;
                if v76 <= 0 or v75 <= v76 then
                    if v78 == "imcolor" or v78 == "vector" then
                        v37.smoothy._list[v69] = v70:clone();
                    elseif v78 == "table" then
                        v37.smoothy.copy_tables(v74, v70);
                    else
                        v37.smoothy._list[v69] = v70;
                    end;
                else
                    v37.smoothy._list[v69] = v37.smoothy.perform_easing(v78, l_v42_0, v74, v70, v76, v75);
                end;
                return v37.smoothy._list[v69];
            end;
        end;
    end;
    v37.smoothy.color_lerp = function(v79, v80, v81)
        -- upvalues: v37 (ref)
        if type(v79) ~= "userdata" or type(v80) ~= "userdata" then
            return v80;
        else
            local v82 = globals.frametime / v37.smoothy.native_GetTimescale();
            local l_v81_0 = v81;
            local function v88(v84, v85, v86, v87)
                return v86 * v84 / v87 + v85;
            end;
            return (color(v37.smoothy.resolve(v88, v79.r, v80.r, v82, l_v81_0), v37.smoothy.resolve(v88, v79.g, v80.g, v82, l_v81_0), v37.smoothy.resolve(v88, v79.b, v80.b, v82, l_v81_0), v37.smoothy.resolve(v88, v79.a, v80.a, v82, l_v81_0)));
        end;
    end;
    v37.smoothy.reset = function(v89)
        -- upvalues: v37 (ref)
        if v89 then
            v37.smoothy._list[v89] = nil;
        else
            v37.smoothy._list = {};
        end;
    end;
end;
v37.menu = {
    other = {
        visuals = {}, 
        misc = {}
    }
};
v37.menu.neverlose_username = common.get_username():lower();
v37.menu.home = {};
v37.menu.home.avatar = v24.home.main:texture(render.load_image(network.get("https://neverlose.cc/static/avatars/" .. common.get_username() .. ".png"), vector(500, 500)), vector(40, 40));
v37.menu.home.welcome_back = v24.home.main:label(" " .. v22.user .. "    Welcome, " .. v21.accent .. v37.menu.neverlose_username .. "!");
v37.menu.home.version = v24.home.main:label(" " .. v22.branch .. "    Version: " .. v21.accent .. "Premium");
v37.menu.home.links = v24.home.main:label(v22.link .. "   Links: ");
v37.menu.home.youtube = v24.home.main:button(v22.youtube, function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@wishenz2");
end, true);
v37.menu.home.discord = v24.home.main:button(v22.discord, function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/uRUUgAhScY");
end, true);
v37.menu.home.nl_config = v24.home.main:button(v21.accent .. "NL" .. v21.reset .. " Config", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=kmsDv8");
end, true);
v37.menu.anti_aim = {};
v37.menu.anti_aim.section = v24.anti_aim.main:list("\n", {
    [1] = v22.gear .. "   Main", 
    [2] = v22.layergroup .. "   Extra"
});
v37.menu.anti_aim.states_list = {
    [1] = "Shared", 
    [2] = "Stand", 
    [3] = "Move", 
    [4] = "Air", 
    [5] = "Air Crouch", 
    [6] = "Crouch", 
    [7] = "Crouch Move", 
    [8] = "Slow-Motion", 
    [9] = "Freestanding", 
    [10] = "Manual Yaw"
};
v37.menu.anti_aim.fs_states_list = {
    [1] = "Stand", 
    [2] = "Move", 
    [3] = "Air", 
    [4] = "Air Crouch", 
    [5] = "Crouch", 
    [6] = "Crouch Move", 
    [7] = "Slow-Motion"
};
v37.menu.anti_aim.current_state = v24.anti_aim.builder:combo("\v\f<shield>\r   Current " .. v21.accent .. "State", v37.menu.anti_aim.states_list);
v37.menu.anti_aim.manual_yaw = v24.anti_aim.direction:combo(v22.arrows_turn .. "   Manual Yaw", {
    [1] = "Disabled", 
    [2] = "Left", 
    [3] = "Right", 
    [4] = "Forward"
});
v37.menu.anti_aim.freestanding = v24.anti_aim.direction:switch(v22.arrows_dotted .. "   Freestanding", false, function(v90)
    -- upvalues: v37 (ref)
    return {
        disablers = v90:selectable("\v\194\187\aDEFAULT Disablers", v37.menu.anti_aim.fs_states_list), 
        disable_yaw_modifiers = v90:switch("\v\194\187\aDEFAULT Disable Yaw Modifiers", false), 
        body_freestanding = v90:switch("\v\194\187\aDEFAULT Body Freestanding", false)
    };
end);
v37.menu.anti_aim.avoid_backstab = v24.anti_aim.direction:switch("\v\f<knife>\r   Avoid Backstab");
v37.menu.anti_aim.tweaks = v24.anti_aim.direction:selectable("\v\f<solar-system>\r   Tweaks", {
    [1] = "Warmup AA", 
    [2] = "Safe-Head"
});
v37.menu.anti_aim.safe_head_triggers = v24.anti_aim.direction:selectable("\v[s-h]\r Triggers", {
    [1] = "Knife", 
    [2] = "Taser", 
    [3] = "Above Enemy"
});
v37.menu.anti_aim.height_difference = v24.anti_aim.direction:slider("\v[s-h]\r Height Difference", 1, 200, 64, 1, "u");
v37.menu.anti_aim.anti_bruteforce = v24.anti_aim.bruteforce:switch("\v\f<sensor-fire>\r   Anti-Bruteforce", false, function(v91)
    return {
        detection_range = v91:slider("\v\194\187\aDEFAULT Detection Range", 50, 300, 150, 1, "u"), 
        detection_cooldown = v91:slider("\v\194\187\aDEFAULT Detection Cooldown", 0.1, 2, 0.5, 0.1, "s"), 
        custom_offsets = v91:switch("\v\194\187\aDEFAULT Custom Phase Offsets", false)
    };
end);
v37.menu.anti_aim.builder = {};
v37.menu.anti_aim.custom_phase_offsets = {};
v37.menu.anti_aim.custom_phase_offsets.phase_1 = v24.anti_aim.bruteforce:slider("\v\f<angle>\r   Phase 1 Offset", -180, 180, 25, 1, "\194\176");
v37.menu.anti_aim.custom_phase_offsets.phase_2 = v24.anti_aim.bruteforce:slider("\v\f<angle>\r   Phase 2 Offset", -180, 180, -15, 1, "\194\176");
v37.menu.anti_aim.custom_phase_offsets.phase_3 = v24.anti_aim.bruteforce:slider("\v\f<angle>\r   Phase 3 Offset", -180, 180, 40, 1, "\194\176");
v37.menu.anti_aim.custom_phase_offsets.phase_4 = v24.anti_aim.bruteforce:slider("\v\f<angle>\r   Phase 4 Offset", -180, 180, -35, 1, "\194\176");
v37.menu.anti_aim.custom_phase_offsets.phase_5 = v24.anti_aim.bruteforce:slider("\v\f<angle>\r   Phase 5 Offset", -180, 180, 0, 1, "\194\176");
v37.menu.other.visuals.watermark = v24.other.visuals:label(v22.pen_to_square .. "   Watermark", function(v92)
    return {
        style = v92:combo("\v\194\187\aDEFAULT Style", {
            [1] = "Classic", 
            [2] = "Gradient"
        }), 
        rainbow = v92:switch("\v\194\187\aDEFAULT Rainbow Mode", true), 
        rainbow_speed = v92:slider("\v\194\187\aDEFAULT Rainbow Speed", 1, 100, 40, 1, "%"), 
        rainbow_saturation = v92:slider("\v\194\187\aDEFAULT Rainbow Saturation", 0, 100, 100, 1, "%"), 
        rainbow_brightness = v92:slider("\v\194\187\aDEFAULT Rainbow Brightness", 0, 100, 100, 1, "%"), 
        background_color = v92:color_picker("\v\194\187\aDEFAULT Background", color(17, 17, 17, 170)), 
        accent_color = v92:color_picker("\v\194\187\aDEFAULT Accent", color(124, 193, 21, 255))
    };
end);
v37.menu.other.visuals.centered_indicators = v24.other.visuals:switch(v22.wand_magic_sparkles .. "   Centered Indicators", false, function(v93)
    return {
        centered_indicators_color = v93:color_picker("\v\194\187\aDEFAULT Accent Color", color(255, 100, 255, 255)), 
        offset = v93:slider("\v\194\187\aDEFAULT Vertical Offset", -50, 50, 0, 1, "px")
    };
end);
v37.menu.other.visuals.damage_indicator = v24.other.visuals:switch("\v\f<arrow-up-9-1>\r   Damage Indicator", false, function(v94)
    return {
        only_when_overrided = v94:switch("\v\194\187\aDEFAULT Only When Overrided", false), 
        select_font = v94:combo("\v\194\187\aDEFAULT Damage Font", {
            [1] = "Verdana", 
            [2] = "Pixel", 
            [3] = "Console", 
            [4] = "Bold"
        })
    };
end);
v37.menu.other.visuals.feature_indicators = v24.other.visuals:switch("\v\f<moon>\r   Feature Indicators", false, function(v95)
    return {
        enabled_indicators = v95:selectable("\v\194\187\aDEFAULT Select", {
            [1] = "DT", 
            [2] = "HS", 
            [3] = "DUCK", 
            [4] = "SP", 
            [5] = "BODY", 
            [6] = "MD", 
            [7] = "HC", 
            [8] = "FS", 
            [9] = "BOMB"
        })
    };
end);
v37.menu.other.visuals.aimbot_logs = v24.other.visuals:switch(v22.wand_magic_sparkles .. "   Aimbot Logs", true, function(v96)
    return {
        output = v96:selectable("\v\194\187\aDEFAULT Output", {
            [1] = "Console", 
            [2] = "Event", 
            [3] = "Notify"
        }), 
        event_style = v96:combo("\v\194\187\aDEFAULT Event Style", {
            [1] = "Default", 
            [2] = "Render"
        }), 
        max_logs = v96:slider("\v\194\187\aDEFAULT Max Logs", 1, 15, 8, 1, ""), 
        time = v96:slider("\v\194\187\aDEFAULT Time", 1, 10, 5, 1, "s"), 
        hit_color = v96:color_picker("\v\194\187\aDEFAULT Hit Color", color(124, 195, 13, 255)), 
        miss_color = v96:color_picker("\v\194\187\aDEFAULT Miss Color", color(255, 50, 50, 255))
    };
end);
v37.menu.other.visuals.custom_scope = v24.other.visuals:switch("\v\f<telescope> \r Custom Scope", true, function(v97)
    return {
        color = v97:color_picker("\v\194\187\aDEFAULT Color", color(205, 205, 205, 134)), 
        gap = v97:slider("\v\194\187\aDEFAULT Gap", 0, 500, 12), 
        size = v97:slider("\v\194\187\aDEFAULT Size", 0, 500, 135)
    };
end);
v37.menu.other.visuals.quick_knife_switch = v24.other.visuals:switch("\v\f<gun>\r   Quick Knife Switch", false);
v37.menu.other.visuals.no_sleeves = v24.other.visuals:switch("\v\f<eye-slash>\r   No Sleeves", false);
v37.menu.other.visuals.hitmarker = v24.other.visuals:switch("\v\f<bullseye-arrow>\r   Hit Marker", false, function(v98)
    return {
        color = v98:color_picker("\v\194\187\aDEFAULT Color", color(255, 255, 255, 255))
    };
end);
v37.menu.other.visuals.molotov_radius = v24.other.visuals:switch("\v\f<fire-burner>\r   Molotov Radius", true, function(v99)
    return {
        color = v99:color_picker("\v\194\187\aDEFAULT Color", color(255, 0, 0, 100)):depend(list), 
        style = v99:combo("Style", {
            [1] = "Default", 
            [2] = "Gradient", 
            [3] = "Pulse Outline"
        }), 
        visibilito = v99:switch("Visible through walls")
    };
end);
v37.menu.other.visuals.smoke_radius = v24.other.visuals:switch("\v\f<fire-extinguisher>\r    Smoke Radius", true, function(v100)
    return {
        color = v100:color_picker("\v\194\187\aDEFAULT Color", color(200, 200, 200, 100)):depend(list), 
        style = v100:combo("\v\194\187\aDEFAULT Style", {
            [1] = "Default", 
            [2] = "Gradient", 
            [3] = "Pulse Outline"
        }), 
        visibilito = v100:switch("\v\194\187\aDEFAULT Visible through walls")
    };
end);
v37.menu.other.misc.movement = {};
v37.menu.other.misc.movement.fast_ladder = v24.other.movement:switch("\v\f<water-ladder>\r   Fast Ladder", false);
v37.menu.other.misc.movement.no_fall_damage = v24.other.movement:switch("\v\f<person-falling>\r   No Fall Damage", false);
v37.menu.other.misc.movement.super_toss = v24.other.movement:switch("\v\f<bomb>\r   Super Toss", false);
v37.menu.other.misc.in_game = {};
v37.menu.other.misc.in_game.freezetime_fakeduck = v24.other.in_game:switch("\v\f<duck>\r   Freezetime Fakeduck", false);
v37.menu.other.misc.in_game.trashtalk = v24.other.in_game:switch("\v\f<face-angry>\r   Trashtalk", false);
v37.menu.other.misc.in_game.clantag = v24.other.in_game:switch("\v\f<tag>\r   Clantag", false);
v37.menu.other.misc.in_game.ping_unlocker = v24.other.in_game:switch("\v\f<wifi>\r   Ping Unlocker", false, function(v101)
    return {
        ping_amount = v101:slider("\v\194\187\aDEFAULT Amount", 1, 200, 1, 1, "ms")
    };
end);
v37.menu.other.misc.in_game.drop_nades = v24.other.in_game:switch("\v\f<bomb>\r  Drop Nades", false, function(v102)
    return {
        selection = v102:selectable("\v\194\187\aDEFAULT Selection", {
            [1] = "HE", 
            [2] = "Smoke", 
            [3] = "Molotov"
        }), 
        hotkey = v102:hotkey("\v\194\187\aDEFAULT Hotkey", 0)
    };
end);
v37.menu.other.misc.view = {};
v37.menu.other.misc.view.cvar_boost = {
    [1] = {
        cvar = {
            [1] = cvar.r_shadows, 
            [2] = cvar.cl_csm_static_prop_shadows, 
            [3] = cvar.cl_csm_shadows, 
            [4] = cvar.cl_csm_world_shadows, 
            [5] = cvar.cl_foot_contact_shadows, 
            [6] = cvar.cl_csm_viewmodel_shadows, 
            [7] = cvar.cl_csm_rope_shadows, 
            [8] = cvar.cl_csm_sprite_shadows, 
            [9] = cvar.cl_foot_contact_shadows
        }
    }, 
    [2] = {
        cvar = {
            [1] = cvar.r_drawparticles, 
            [2] = cvar.cl_detail_multiplier
        }
    }, 
    [3] = {
        cvar = {
            [1] = cvar.r_eyesize, 
            [2] = cvar.r_eyeshift_z, 
            [3] = cvar.r_eyeshift_y, 
            [4] = cvar.r_eyeshift_x, 
            [5] = cvar.r_eyemove, 
            [6] = cvar.r_eyegloss
        }
    }, 
    [4] = {
        cvar = {
            [1] = cvar.r_drawtracers_firstperson, 
            [2] = cvar.r_drawtracers
        }
    }, 
    [5] = {
        cvar = {
            [1] = cvar.mat_postprocess_enable
        }
    }, 
    [6] = {
        cvar = {
            [1] = cvar.fog_enable_water_fog
        }
    }, 
    [7] = {
        cvar = {
            [1] = cvar.m_rawinput, 
            [2] = cvar.cl_bob_lower_amt
        }
    }, 
    [8] = {
        cvar = {
            [1] = cvar.cl_disablefreezecam, 
            [2] = cvar.cl_freezecampanel_position_dynamic, 
            [3] = cvar.cl_freezecameffects_showholiday
        }
    }, 
    [9] = {
        cvar = {
            [1] = cvar.r_drawropes, 
            [2] = cvar.r_drawsprites, 
            [3] = cvar.func_break_max_pieces, 
            [4] = cvar.mat_drawwater
        }
    }, 
    [10] = {
        cvar = {
            [1] = cvar.cl_disablehtmlmotd, 
            [2] = cvar.r_dynamic, 
            [3] = cvar.cl_autohelp, 
            [4] = cvar.r_drawdecals, 
            [5] = cvar.muzzleflash_light
        }
    }
};
v37.menu.other.misc.view.cvar_optimalisation = v24.other.view:switch("\v\f<hundred-points>\r   Cvars Optimization", false, function(v103)
    return {
        text22 = v103:label("High optimization might remove molotov particles!"), 
        options = v103:list("", {
            [1] = "Low", 
            [2] = "Medium", 
            [3] = "High"
        })
    };
end);
v37.menu.other.misc.view.aspect_ratio = v24.other.view:switch("\v\f<desktop>\r   Aspect Ratio", false, function(v104)
    -- upvalues: v37 (ref)
    return {
        ratio_amount = v104:slider("\v\194\187\aDEFAULT Ratio", 1, 200, 133, 0.01), 
        ratio_3_2 = v104:button("3:2", function()
            -- upvalues: v37 (ref)
            v37.menu.other.misc.view.aspect_ratio.ratio_amount:set(150);
        end, true), 
        ratio_5_4 = v104:button("5:4", function()
            -- upvalues: v37 (ref)
            v37.menu.other.misc.view.aspect_ratio.ratio_amount:set(125);
        end, true), 
        ratio_4_3 = v104:button("4:3", function()
            -- upvalues: v37 (ref)
            v37.menu.other.misc.view.aspect_ratio.ratio_amount:set(133);
        end, true), 
        ratio_16_9 = v104:button("16:9", function()
            -- upvalues: v37 (ref)
            v37.menu.other.misc.view.aspect_ratio.ratio_amount:set(180);
        end, true), 
        ratio_16_10 = v104:button("16:10", function()
            -- upvalues: v37 (ref)
            v37.menu.other.misc.view.aspect_ratio.ratio_amount:set(160);
        end, true)
    };
end);
v37.menu.other.misc.view.viewmodel = v24.other.view:switch("\v\f<hand>\r   Viewmodel", false, function(v105)
    -- upvalues: v37 (ref)
    return {
        viewmodel_fov = v105:slider("\v\194\187\aDEFAULT Fov", -10000, 10000, 6800, 0.01), 
        viewmodel_x = v105:slider("\v\194\187\aDEFAULT X", -1000, 1000, 250, 0.01), 
        viewmodel_y = v105:slider("\v\194\187\aDEFAULT Y", -2000, 2000, 0, 0.01), 
        viewmodel_z = v105:slider("\v\194\187\aDEFAULT Z", -1000, 1000, -150, 0.01), 
        viewmodel_reset = v105:button("Reset", function()
            -- upvalues: v37 (ref)
            v37.menu.other.misc.view.viewmodel.viewmodel_fov:set(6800);
            v37.menu.other.misc.view.viewmodel.viewmodel_x:set(250);
            v37.menu.other.misc.view.viewmodel.viewmodel_y:set(0);
            v37.menu.other.misc.view.viewmodel.viewmodel_z:set(-150);
        end, true)
    };
end);
v37.menu.create_state_controls = function(v106, _)
    -- upvalues: v24 (ref), v21 (ref), v9 (ref), v8 (ref), v33 (ref), v36 (ref)
    return {
        override = v24.anti_aim.builder:switch("\v\f<toggle-on>\r   Override " .. v21.accent .. v106), 
        yaw = v24.anti_aim.builder:slider("\v\f<arrows-left-right>\r   Yaw " .. v21.accent .. "Offset" .. v21.reset, v9, v8, 0, 1, "\194\176"), 
        jitter_mode = v24.anti_aim.builder:combo("\v\f<fire>\r   Jitter Mode ", {
            [1] = "Default", 
            [2] = "Dolce"
        }), 
        yaw_seperation = v24.anti_aim.builder:slider("\v!\r  Offset ~ " .. v21.accent .. "Separation" .. v21.reset, v9, v8, 0, 1, "\194\176"), 
        yaw_warp = v24.anti_aim.builder:slider("\v!\r  Offset ~ " .. v21.accent .. "Warp" .. v21.reset, v9, v8, 0, 1, "\194\176"), 
        yaw_spin = v24.anti_aim.builder:switch("\v\f<arrows-spin>\r   Yaw " .. v21.accent .. "Spin", false, function(v108)
            return {
                speed = v108:slider("\v\194\187\aDEFAULT Speed", 1, 100, 20, 1, "\194\176/t"), 
                smooth = v108:switch("\v\194\187\aDEFAULT Smooth", false)
            };
        end), 
        randomization = v24.anti_aim.builder:switch("Yaw ~ " .. v21.accent .. "Randomization" .. v21.reset, false, function(v109)
            return {
                randomization_value = v109:slider("\v\194\187\aDEFAULT Value", 0, 100, 0, 1, function(v110)
                    return v110 < 1 and "Disabled" or v110 .. "%";
                end)
            };
        end), 
        minimum_yaw = v24.anti_aim.builder:slider("\v\f<minus>\r  Yaw ~ " .. v21.accent .. "Minimum" .. v21.reset, v9, v8, 0, 1, "\194\176"), 
        maximum_yaw = v24.anti_aim.builder:slider("\v\f<plus>\r  Yaw ~ " .. v21.accent .. "Maximum" .. v21.reset, v9, v8, 0, 1, "\194\176"), 
        step_size = v24.anti_aim.builder:slider("\v\f<spinner>\r  Yaw ~ " .. v21.accent .. "Step" .. v21.reset, 1, 50, 15, 1, "step"), 
        variance_yaw = v24.anti_aim.builder:switch("\v\f<bug>\r  Yaw ~ " .. v21.accent .. "Randomization" .. v21.reset), 
        body_yaw = v24.anti_aim.builder:combo("\v\f<arrows-to-eye>\r   Body Yaw", {
            [1] = "Off", 
            [2] = "Static", 
            [3] = "Jitter", 
            [4] = "Breaker"
        }, function(v111)
            -- upvalues: v33 (ref), v36 (ref)
            return {
                delay_type = v111:combo("\v\194\187\aDEFAULT Jitter Type", {
                    [1] = "Default", 
                    [2] = "Progressive", 
                    [3] = "Adaptive", 
                    [4] = "Dynamic", 
                    [5] = "Oscillating"
                }), 
                jitter_speed = v111:slider("\v\194\187\aDEFAULT Jitter Speed", 1, 20, 1, 1, v33), 
                min_speed = v111:slider("\v\194\187\aDEFAULT Min Speed", 1, 20, 1, 1, v33), 
                max_speed = v111:slider("\v\194\187\aDEFAULT Max Speed", 2, 20, 8, 1, v33), 
                hold_ticks = v111:slider("\v\194\187\aDEFAULT Hold Ticks", 0, 50, 0, 1, function(v112)
                    -- upvalues: v36 (ref)
                    return v36(v112, "t");
                end), 
                randomization = v111:slider("\v\194\187\aDEFAULT Randomization", 0, 10, 0, 1, function(v113)
                    -- upvalues: v36 (ref)
                    return v36(v113, "t");
                end)
            };
        end), 
        force_defensive = v24.anti_aim.builder:switch("\v\f<eye-slash>\r   Force Defensive"), 
        hidden_pitch = v24.anti_aim.builder:switch("\v\f<arrow-up-right-and-arrow-down-left-from-center>\r   Hidden " .. v21.accent .. "Pitch", false, function(v114)
            return {
                select_type = v114:combo("\v\194\187\aDEFAULT Type", {
                    [1] = "Off", 
                    [2] = "Up", 
                    [3] = "Down", 
                    [4] = "Random", 
                    [5] = "Custom", 
                    [6] = "Sway"
                }), 
                custom = v114:slider("\v\194\187\aDEFAULT Custom", -89, 89, 0, 1, "\194\176"), 
                min_amount = v114:slider("\v\194\187\aDEFAULT Min Amount", -89, 89, -35, 1, "\194\176"), 
                max_amount = v114:slider("\v\194\187\aDEFAULT Max Amount", -89, 89, 35, 1, "\194\176"), 
                sway_speed = v114:slider("\v\194\187\aDEFAULT Sway Speed", 1, 10, 3, 1, ""), 
                sway_min = v114:slider("\v\194\187\aDEFAULT Sway Min", -89, 89, -60, 1, "\194\176"), 
                sway_max = v114:slider("\v\194\187\aDEFAULT Sway Max", -89, 89, 60, 1, "\194\176")
            };
        end), 
        hidden_yaw = v24.anti_aim.builder:switch("\v\f<arrows-retweet>\r   Hidden " .. v21.accent .. "Yaw", false, function(v115)
            -- upvalues: v9 (ref), v8 (ref), v33 (ref)
            return {
                select_type = v115:combo("\v\194\187\aDEFAULT Type", {
                    [1] = "Static", 
                    [2] = "Jitter", 
                    [3] = "Spin", 
                    [4] = "Random", 
                    [5] = "Opposite", 
                    [6] = "Distortion"
                }), 
                amount = v115:slider("\v\194\187\aDEFAULT Amount", v9, v8, 0, 1, "\194\176"), 
                min_amount = v115:slider("\v\194\187\aDEFAULT Min Amount", v9, v8, -35, 1, "\194\176"), 
                max_amount = v115:slider("\v\194\187\aDEFAULT Max Amount", v9, v8, 35, 1, "\194\176"), 
                speed = v115:slider("\v\194\187\aDEFAULT Speed", 1, 100, 10, 1, "\194\176"), 
                left_value = v115:slider("\v\194\187\aDEFAULT Left Value", v9, v8, -120, 1, "\194\176"), 
                right_value = v115:slider("\v\194\187\aDEFAULT Right Value", v9, v8, 120, 1, "\194\176"), 
                delay = v115:slider("\v\194\187\aDEFAULT Delay", 1, 20, 1, 1, v33), 
                distortion_range = v115:slider("\v\194\187\aDEFAULT Range", 10, 180, 90, 1, "\194\176"), 
                distortion_frequency = v115:slider("\v\194\187\aDEFAULT Frequency", 1, 100, 25, 1, "%"), 
                distortion_step = v115:slider("\v\194\187\aDEFAULT Step", 1, 30, 5, 1, "\194\176")
            };
        end)
    };
end;
for v116 = 1, #v37.menu.anti_aim.states_list do
    local v117 = v37.menu.anti_aim.states_list[v116];
    v37.menu.anti_aim.builder[v116] = v37.menu.create_state_controls(v117, v116);
end;
v37.menu.setup_dependencies = function()
    -- upvalues: v37 (ref)
    for v118 = 1, #v37.menu.anti_aim.states_list do
        local v119 = v37.menu.anti_aim.builder[v118];
        do
            local l_v118_0 = v118;
            do
                local l_v119_0 = v119;
                local v122 = {
                    [1] = l_v119_0.override, 
                    [2] = function()
                        -- upvalues: l_v118_0 (ref), l_v119_0 (ref)
                        return l_v118_0 == 1 or l_v119_0.override:get();
                    end
                };
                local v123 = {
                    [1] = nil, 
                    [2] = 1, 
                    [1] = v37.menu.anti_aim.section
                };
                local v124 = {
                    [1] = nil, 
                    [2] = 2, 
                    [1] = v37.menu.anti_aim.section
                };
                local v125 = {
                    [1] = v37.menu.anti_aim.current_state, 
                    [2] = v37.menu.anti_aim.states_list[l_v118_0]
                };
                local v126 = {
                    [1] = nil, 
                    [2] = "Default", 
                    [1] = l_v119_0.jitter_mode
                };
                local v127 = {
                    [1] = nil, 
                    [2] = "Dolce", 
                    [1] = l_v119_0.jitter_mode
                };
                local v128 = {
                    [1] = nil, 
                    [2] = true, 
                    [1] = l_v119_0.randomization
                };
                local v129 = {
                    [1] = nil, 
                    [2] = true, 
                    [1] = l_v119_0.yaw_spin
                };
                local v130 = {
                    [1] = nil, 
                    [2] = true, 
                    [1] = l_v119_0.hidden_yaw
                };
                local v131 = {
                    [1] = nil, 
                    [2] = true, 
                    [1] = l_v119_0.hidden_pitch
                };
                local v132 = {
                    [1] = l_v119_0.hidden_pitch.select_type, 
                    [2] = function()
                        -- upvalues: l_v119_0 (ref)
                        return l_v119_0.hidden_pitch.select_type:get() == "Custom";
                    end
                };
                local v133 = {
                    [1] = nil, 
                    [2] = "Jitter", 
                    [1] = l_v119_0.body_yaw
                };
                local v134 = {
                    [1] = l_v119_0.body_yaw.delay_type, 
                    [2] = function()
                        -- upvalues: l_v119_0 (ref)
                        return l_v119_0.body_yaw.delay_type:get() ~= "Default";
                    end
                };
                v37.menu.apply_dependencies(l_v119_0, v123, v124, v125, v126, v127, v122, v128, v129, v130, v131, v132, v133, v134, l_v118_0, is_default_jitter, is_advanced_jitter);
            end;
        end;
    end;
    v37.menu.setup_bruteforce_dependencies();
    v37.menu.setup_visual_dependencies();
    v37.menu.setup_misc_dependencies();
end;
v37.menu.setup_visual_dependencies = function()
    -- upvalues: v37 (ref)
    local v135 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.visuals.centered_indicators
    };
    v37.menu.other.visuals.centered_indicators.offset:depend(v135);
    v37.menu.other.visuals.centered_indicators.centered_indicators_color:depend(v135);
    local v136 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.visuals.damage_indicator
    };
    v37.menu.other.visuals.damage_indicator.only_when_overrided:depend(v136);
    v37.menu.other.visuals.damage_indicator.select_font:depend(v136);
    local v137 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.visuals.feature_indicators
    };
    v37.menu.other.visuals.feature_indicators.enabled_indicators:depend(v137);
    local v138 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.visuals.aimbot_logs
    };
    local v139 = {
        [1] = nil, 
        [2] = "Event", 
        [1] = v37.menu.other.visuals.aimbot_logs.output
    };
    v37.menu.other.visuals.aimbot_logs.output:depend(v138);
    v37.menu.other.visuals.aimbot_logs.event_style:depend(v138, v139);
    v37.menu.other.visuals.aimbot_logs.max_logs:depend(v138);
    v37.menu.other.visuals.aimbot_logs.time:depend(v138);
    v37.menu.other.visuals.aimbot_logs.hit_color:depend(v138);
    v37.menu.other.visuals.aimbot_logs.miss_color:depend(v138);
    local v140 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.visuals.custom_scope
    };
    v37.menu.other.visuals.custom_scope.color:depend(v140);
    v37.menu.other.visuals.custom_scope.gap:depend(v140);
    v37.menu.other.visuals.custom_scope.size:depend(v140);
    local v141 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.visuals.hitmarker
    };
    v37.menu.other.visuals.hitmarker.color:depend(v141);
    local v142 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.visuals.molotov_radius
    };
    local v143 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.visuals.smoke_radius
    };
    v37.menu.other.visuals.molotov_radius.color:depend(v142);
    v37.menu.other.visuals.molotov_radius.style:depend(v142);
    v37.menu.other.visuals.molotov_radius.visibilito:depend(v142);
    v37.menu.other.visuals.smoke_radius.color:depend(v143);
    v37.menu.other.visuals.smoke_radius.style:depend(v143);
    v37.menu.other.visuals.smoke_radius.visibilito:depend(v142);
    local v144 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.visuals.watermark.rainbow
    };
    v37.menu.other.visuals.watermark.rainbow_speed:depend(v144);
    v37.menu.other.visuals.watermark.rainbow_saturation:depend(v144);
    v37.menu.other.visuals.watermark.rainbow_brightness:depend(v144);
end;
v37.menu.setup_misc_dependencies = function()
    -- upvalues: v37 (ref)
    local _ = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.misc.movement.fast_ladder
    };
    local _ = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.misc.movement.no_fall_damage
    };
    local _ = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.misc.movement.super_toss
    };
    local _ = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.misc.in_game.trashtalk
    };
    local _ = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.misc.in_game.clantag
    };
    local v150 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.misc.in_game.ping_unlocker
    };
    local v151 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.misc.in_game.drop_nades
    };
    v37.menu.other.misc.in_game.ping_unlocker.ping_amount:depend(v150);
    v37.menu.other.misc.in_game.drop_nades.hotkey:depend(v151);
    v37.menu.other.misc.in_game.drop_nades.selection:depend(v151);
    local v152 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.misc.view.aspect_ratio
    };
    local v153 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.misc.view.viewmodel
    };
    local v154 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.other.misc.view.cvar_optimalisation
    };
    v37.menu.other.misc.view.cvar_optimalisation.options:depend(v154);
    v37.menu.other.misc.view.cvar_optimalisation.text22:depend(v154);
    v37.menu.other.misc.view.aspect_ratio.ratio_amount:depend(v152);
    v37.menu.other.misc.view.aspect_ratio.ratio_3_2:depend(v152);
    v37.menu.other.misc.view.aspect_ratio.ratio_5_4:depend(v152);
    v37.menu.other.misc.view.aspect_ratio.ratio_4_3:depend(v152);
    v37.menu.other.misc.view.aspect_ratio.ratio_16_9:depend(v152);
    v37.menu.other.misc.view.aspect_ratio.ratio_16_10:depend(v152);
    v37.menu.other.misc.view.viewmodel.viewmodel_fov:depend(v153);
    v37.menu.other.misc.view.viewmodel.viewmodel_x:depend(v153);
    v37.menu.other.misc.view.viewmodel.viewmodel_y:depend(v153);
    v37.menu.other.misc.view.viewmodel.viewmodel_z:depend(v153);
    v37.menu.other.misc.view.viewmodel.viewmodel_reset:depend(v153);
end;
v37.menu.setup_bruteforce_dependencies = function()
    -- upvalues: v37 (ref)
    local v155 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.anti_aim.anti_bruteforce
    };
    local v156 = {
        [1] = nil, 
        [2] = true, 
        [1] = v37.menu.anti_aim.anti_bruteforce.custom_offsets
    };
    local v157 = {
        [1] = nil, 
        [2] = 2, 
        [1] = v37.menu.anti_aim.section
    };
    v37.menu.anti_aim.anti_bruteforce:depend(v157);
    v37.menu.anti_aim.anti_bruteforce.detection_range:depend(v155);
    v37.menu.anti_aim.anti_bruteforce.detection_cooldown:depend(v155);
    v37.menu.anti_aim.anti_bruteforce.custom_offsets:depend(v155);
    v37.menu.anti_aim.custom_phase_offsets.phase_1:depend(v155, v156, v157);
    v37.menu.anti_aim.custom_phase_offsets.phase_2:depend(v155, v156, v157);
    v37.menu.anti_aim.custom_phase_offsets.phase_3:depend(v155, v156, v157);
    v37.menu.anti_aim.custom_phase_offsets.phase_4:depend(v155, v156, v157);
    v37.menu.anti_aim.custom_phase_offsets.phase_5:depend(v155, v156, v157);
end;
v37.menu.apply_dependencies = function(v158, v159, v160, v161, v162, v163, v164, v165, v166, v167, v168, v169, v170, v171, v172, _, _)
    -- upvalues: v37 (ref)
    local v175 = {
        [1] = {
            [1] = v158.override, 
            [2] = {
                [1] = v161, 
                [2] = {
                    [1] = v158.override, 
                    [2] = function()
                        -- upvalues: v172 (ref)
                        return v172 ~= 1;
                    end
                }
            }
        }, 
        [2] = {
            [1] = v158.yaw, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159
            }
        }, 
        [3] = {
            [1] = v158.jitter_mode, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159
            }
        }, 
        [4] = {
            [1] = v158.yaw_seperation, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v162
            }
        }, 
        [5] = {
            [1] = v158.yaw_warp, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v162
            }
        }, 
        [6] = {
            [1] = v158.yaw_spin, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v162
            }
        }, 
        [7] = {
            [1] = v158.yaw_spin.speed, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v166, 
                [5] = v162
            }
        }, 
        [8] = {
            [1] = v158.yaw_spin.smooth, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v166, 
                [5] = v162
            }
        }, 
        [9] = {
            [1] = v158.randomization, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v162
            }
        }, 
        [10] = {
            [1] = v158.randomization.randomization_value, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v165, 
                [5] = v162
            }
        }, 
        [11] = {
            [1] = v158.minimum_yaw, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v163
            }
        }, 
        [12] = {
            [1] = v158.maximum_yaw, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v163
            }
        }, 
        [13] = {
            [1] = v158.step_size, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v163
            }
        }, 
        [14] = {
            [1] = v158.variance_yaw, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v163
            }
        }, 
        [15] = {
            [1] = v158.hidden_yaw, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160
            }
        }, 
        [16] = {
            [1] = v158.hidden_yaw.select_type, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v167
            }
        }, 
        [17] = {
            [1] = v158.hidden_yaw.amount, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v167, 
                [5] = {
                    [1] = v158.hidden_yaw.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_yaw.select_type:get() == "Static";
                    end
                }
            }
        }, 
        [18] = {
            [1] = v158.hidden_yaw.min_amount, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v167, 
                [5] = {
                    [1] = v158.hidden_yaw.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_yaw.select_type:get() == "Random";
                    end
                }
            }
        }, 
        [19] = {
            [1] = v158.hidden_yaw.max_amount, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v167, 
                [5] = {
                    [1] = v158.hidden_yaw.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_yaw.select_type:get() == "Random";
                    end
                }
            }
        }, 
        [20] = {
            [1] = v158.hidden_yaw.speed, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v167, 
                [5] = {
                    [1] = v158.hidden_yaw.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_yaw.select_type:get() == "Spin";
                    end
                }
            }
        }, 
        [21] = {
            [1] = v158.hidden_yaw.left_value, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v167, 
                [5] = {
                    [1] = v158.hidden_yaw.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_yaw.select_type:get() == "Jitter";
                    end
                }
            }
        }, 
        [22] = {
            [1] = v158.hidden_yaw.right_value, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v167, 
                [5] = {
                    [1] = v158.hidden_yaw.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_yaw.select_type:get() == "Jitter";
                    end
                }
            }
        }, 
        [23] = {
            [1] = v158.hidden_yaw.delay, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v167, 
                [5] = {
                    [1] = v158.hidden_yaw.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_yaw.select_type:get() == "Jitter";
                    end
                }
            }
        }, 
        [24] = {
            [1] = v158.hidden_yaw.distortion_range, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v167, 
                [5] = {
                    [1] = v158.hidden_yaw.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_yaw.select_type:get() == "Distortion";
                    end
                }
            }
        }, 
        [25] = {
            [1] = v158.hidden_yaw.distortion_frequency, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v167, 
                [5] = {
                    [1] = v158.hidden_yaw.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_yaw.select_type:get() == "Distortion";
                    end
                }
            }
        }, 
        [26] = {
            [1] = v158.hidden_yaw.distortion_step, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v167, 
                [5] = {
                    [1] = v158.hidden_yaw.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_yaw.select_type:get() == "Distortion";
                    end
                }
            }
        }, 
        [27] = {
            [1] = v158.hidden_pitch, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160
            }
        }, 
        [28] = {
            [1] = v158.hidden_pitch.select_type, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v168
            }
        }, 
        [29] = {
            [1] = v158.hidden_pitch.custom, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v168, 
                [5] = v169
            }
        }, 
        [30] = {
            [1] = v158.hidden_pitch.min_amount, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v168, 
                [5] = {
                    [1] = v158.hidden_pitch.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_pitch.select_type:get() == "Random";
                    end
                }
            }
        }, 
        [31] = {
            [1] = v158.hidden_pitch.max_amount, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v168, 
                [5] = {
                    [1] = v158.hidden_pitch.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_pitch.select_type:get() == "Random";
                    end
                }
            }
        }, 
        [32] = {
            [1] = v158.hidden_pitch.sway_speed, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v168, 
                [5] = {
                    [1] = v158.hidden_pitch.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_pitch.select_type:get() == "Sway";
                    end
                }
            }
        }, 
        [33] = {
            [1] = v158.hidden_pitch.sway_min, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v168, 
                [5] = {
                    [1] = v158.hidden_pitch.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_pitch.select_type:get() == "Sway";
                    end
                }
            }
        }, 
        [34] = {
            [1] = v158.hidden_pitch.sway_max, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160, 
                [4] = v168, 
                [5] = {
                    [1] = v158.hidden_pitch.select_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.hidden_pitch.select_type:get() == "Sway";
                    end
                }
            }
        }, 
        [35] = {
            [1] = v158.body_yaw, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159
            }
        }, 
        [36] = {
            [1] = v158.body_yaw.delay_type, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v170
            }
        }, 
        [37] = {
            [1] = v158.body_yaw.jitter_speed, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v170, 
                [5] = {
                    [1] = v158.body_yaw.delay_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.body_yaw.delay_type:get() ~= "Progressive" and v158.body_yaw.delay_type:get() ~= "Oscillating";
                    end
                }
            }
        }, 
        [38] = {
            [1] = v158.body_yaw.min_speed, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v170, 
                [5] = {
                    [1] = v158.body_yaw.delay_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.body_yaw.delay_type:get() == "Progressive" or v158.body_yaw.delay_type:get() == "Oscillating";
                    end
                }
            }
        }, 
        [39] = {
            [1] = v158.body_yaw.max_speed, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v170, 
                [5] = {
                    [1] = v158.body_yaw.delay_type, 
                    [2] = function()
                        -- upvalues: v158 (ref)
                        return v158.body_yaw.delay_type:get() == "Progressive" or v158.body_yaw.delay_type:get() == "Oscillating";
                    end
                }
            }
        }, 
        [40] = {
            [1] = v158.body_yaw.hold_ticks, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v170, 
                [5] = v171
            }
        }, 
        [41] = {
            [1] = v158.body_yaw.randomization, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v170, 
                [5] = v171
            }
        }, 
        [42] = {
            [1] = v158.force_defensive, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159
            }
        }, 
        [43] = {
            [1] = v158.randomization, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159
            }
        }, 
        [44] = {
            [1] = v158.randomization.randomization_value, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v159, 
                [4] = v165
            }
        }, 
        [45] = {
            [1] = v158.hidden_yaw, 
            [2] = {
                [1] = v161, 
                [2] = v164, 
                [3] = v160
            }
        }
    };
    for _, v177 in ipairs(v175) do
        local v178 = v177[1];
        local v179 = v177[2];
        v178:depend(unpack(v179));
    end;
    local v180 = {
        [1] = nil, 
        [2] = "Safe-Head", 
        [1] = v37.menu.anti_aim.tweaks
    };
    local v181 = {
        [1] = nil, 
        [2] = "Above Enemy", 
        [1] = v37.menu.anti_aim.safe_head_triggers
    };
    v37.menu.anti_aim.manual_yaw:depend(v159);
    v37.menu.anti_aim.freestanding:depend(v159);
    v37.menu.anti_aim.avoid_backstab:depend(v159);
    v37.menu.anti_aim.tweaks:depend(v159);
    v37.menu.anti_aim.safe_head_triggers:depend(v180, v159);
    v37.menu.anti_aim.height_difference:depend(v180, v181, v159);
end;
v37.menu.setup_dependencies();
v42 = {
    data = {}
};
v42.data.player_data = {
    stateid = 1, 
    onground_ticks = 0, 
    stamina = 80, 
    duckamount = 0, 
    velocity = 0, 
    onground = true, 
    alive = false, 
    entindex = -1, 
    velocity_mod = function(v182)
        local l_x_0 = v182.m_vecVelocity.x;
        local l_y_0 = v182.m_vecVelocity.y;
        return math.sqrt(l_x_0 * l_x_0 + l_y_0 * l_y_0);
    end, 
    is_onground = function(v185, v186)
        -- upvalues: l_bit_0 (ref), v13 (ref)
        if not (l_bit_0.band(v186.m_fFlags, 1) ~= 0) then
            v185.onground_ticks = 0;
            return false;
        else
            v185.onground_ticks = v185.onground_ticks + 1;
            return v185.onground_ticks > v13;
        end;
    end, 
    state_trigger = function(v187)
        -- upvalues: v37 (ref), v23 (ref), v12 (ref), v11 (ref)
        local v188 = v37.menu.anti_aim.manual_yaw:get();
        local v189 = v37.menu.anti_aim.freestanding:get();
        local v190 = v23.fake_duck:get();
        local v191 = v23.slow_walk:get();
        if v188 ~= "Disabled" then
            return 10;
        elseif v189 then
            return 9;
        elseif not v187.onground then
            return v187.duckamount > v12 and 5 or 4;
        elseif v187.duckamount > v12 or v190 then
            return v187.velocity > v11 and 7 or 6;
        elseif v191 then
            return 8;
        else
            return v187.velocity > v11 and 3 or 2;
        end;
    end, 
    get_fs_state = function(v192)
        -- upvalues: v23 (ref), v12 (ref), v11 (ref)
        local v193 = v23.slow_walk:get();
        local v194 = v23.fake_duck:get();
        if not v192.onground then
            return v192.duckamount > v12 and "Air Crouch" or "Air";
        elseif v192.duckamount > v12 or v194 then
            return v192.velocity > v11 and "Crouch Move" or "Crouch";
        elseif v193 then
            return "Slow-Motion";
        elseif v192.velocity > v11 then
            return "Move";
        else
            return "Stand";
        end;
    end, 
    update = function(v195)
        local v196 = entity.get_local_player();
        if not v196 then
            v195.alive = false;
            return;
        else
            v195.entindex = v196;
            v195.alive = v196:is_alive();
            if not v195.alive then
                return;
            else
                v195.onground = v195:is_onground(v196);
                v195.velocity = v195.velocity_mod(v196);
                v195.duckamount = v196.m_flDuckAmount;
                v195.stamina = v196.m_flStamina;
                v195.stateid = v195:state_trigger();
                return;
            end;
        end;
    end
};
v42.data.anti_aim_data = {
    switch = false, 
    hold_ticks = 0, 
    switch_ticks = 0, 
    inverted = false, 
    last_calculated_delay = {}, 
    bruteforce = {
        phase = -1, 
        active = false, 
        max_history_size = 10, 
        last_hurt_time = 0, 
        history = {}, 
        default_offsets = {
            [1] = 0, 
            [2] = 25, 
            [3] = -15, 
            [4] = 40, 
            [5] = -35
        }, 
        reset_time = v15
    }, 
    miss_detection = {
        count = 0, 
        last_time = 0, 
        max_history_size = 10, 
        history = {}, 
        range = v16, 
        cooldown = v17
    }, 
    safe_head = {
        reason = "", 
        active = false
    }, 
    overrides = {
        freestanding_body_freestanding = false, 
        freestanding_disable_yaw_modifiers = false, 
        body_yaw_options = "", 
        body_yaw_right_limit = 60, 
        body_yaw = true, 
        yaw_modifier_offset = 0, 
        yaw_modifier = "Disabled", 
        yaw_offset = 0, 
        hide_shots_options = "Favor fire rate", 
        yaw_base = "At Target", 
        avoid_backstab = true, 
        body_yaw_left_limit = 60, 
        pitch_custom = 0, 
        lag_options = "Always enabled", 
        yaw_hidden = false, 
        pitch = "Down", 
        freestanding = false
    }, 
    reset_values = function()
        -- upvalues: v42 (ref), v27 (ref)
        v42.data.anti_aim_data.bruteforce.phase = -1;
        v42.data.anti_aim_data.bruteforce.active = false;
        v42.data.anti_aim_data.bruteforce.last_hurt_time = 0;
        v42.data.anti_aim_data.bruteforce.history = {};
        v42.data.anti_aim_data.miss_detection.last_time = 0;
        v42.data.anti_aim_data.miss_detection.history = {};
        v42.data.anti_aim_data.miss_detection.count = 0;
        v42.data.anti_aim_data.safe_head.active = false;
        v42.data.anti_aim_data.safe_head.reason = "";
        v42.data.anti_aim_data.overrides.pitch = "Down";
        v42.data.anti_aim_data.overrides.pitch_custom = 0;
        v42.data.anti_aim_data.overrides.yaw_base = "At Target";
        v42.data.anti_aim_data.overrides.yaw_offset = 0;
        v42.data.anti_aim_data.overrides.yaw_hidden = false;
        v42.data.anti_aim_data.overrides.yaw_modifier = "Disabled";
        v42.data.anti_aim_data.overrides.yaw_modifier_offset = 0;
        v42.data.anti_aim_data.overrides.body_yaw = true;
        v42.data.anti_aim_data.overrides.body_yaw_left_limit = 60;
        v42.data.anti_aim_data.overrides.body_yaw_right_limit = 60;
        v42.data.anti_aim_data.overrides.body_yaw_options = "";
        v42.data.anti_aim_data.overrides.freestanding = false;
        v42.data.anti_aim_data.overrides.freestanding_disable_yaw_modifiers = false;
        v42.data.anti_aim_data.overrides.freestanding_body_freestanding = false;
        v42.data.anti_aim_data.overrides.avoid_backstab = true;
        v42.data.anti_aim_data.overrides.lag_options = "Always enabled";
        v42.data.anti_aim_data.overrides.hide_shots_options = "Favor fire rate";
        v42.data.anti_aim_data.switch_ticks = 0;
        v42.data.anti_aim_data.hold_ticks = 0;
        v42.data.anti_aim_data.switch = false;
        v42.data.anti_aim_data.last_calculated_delay = {};
        v27("Anti-aim values reset at round start", color(255, 255, 255, 255));
        show_notification("Anti-aim values reset at round start", {
            [1] = 255, 
            [2] = 255, 
            [3] = 255, 
            [4] = 255
        });
    end, 
    update_values = function()
        -- upvalues: v42 (ref), v23 (ref)
        local l_overrides_0 = v42.data.anti_aim_data.overrides;
        local l_bruteforce_0 = v42.data.anti_aim_data.bruteforce;
        local l_miss_detection_0 = v42.data.anti_aim_data.miss_detection;
        local v200 = {
            [1] = {
                [1] = v23.pitch, 
                [2] = l_overrides_0.pitch
            }, 
            [2] = {
                [1] = v23.yaw.base, 
                [2] = l_overrides_0.yaw_base
            }, 
            [3] = {
                [1] = v23.yaw.offset, 
                [2] = l_overrides_0.yaw_offset
            }, 
            [4] = {
                [1] = v23.yaw.hidden, 
                [2] = l_overrides_0.yaw_hidden
            }, 
            [5] = {
                [1] = v23.yaw_modifier, 
                [2] = l_overrides_0.yaw_modifier
            }, 
            [6] = {
                [1] = v23.yaw_modifier.offset, 
                [2] = l_overrides_0.yaw_modifier_offset
            }, 
            [7] = {
                [1] = v23.body_yaw, 
                [2] = l_overrides_0.body_yaw
            }, 
            [8] = {
                [1] = v23.body_yaw.left_limit, 
                [2] = l_overrides_0.body_yaw_left_limit
            }, 
            [9] = {
                [1] = v23.body_yaw.right_limit, 
                [2] = l_overrides_0.body_yaw_right_limit
            }, 
            [10] = {
                [1] = v23.body_yaw.options, 
                [2] = l_overrides_0.body_yaw_options
            }, 
            [11] = {
                [1] = v23.freestanding, 
                [2] = l_overrides_0.freestanding
            }, 
            [12] = {
                [1] = v23.freestanding.disable_yaw_modifiers, 
                [2] = l_overrides_0.freestanding_disable_yaw_modifiers
            }, 
            [13] = {
                [1] = v23.freestanding.body_freestanding, 
                [2] = l_overrides_0.freestanding_body_freestanding
            }, 
            [14] = {
                [1] = v23.yaw.avoid_backstab, 
                [2] = l_overrides_0.avoid_backstab
            }, 
            [15] = {
                [1] = v23.lag_options, 
                [2] = l_overrides_0.lag_options
            }, 
            [16] = {
                [1] = v23.hide_shots_options, 
                [2] = l_overrides_0.hide_shots_options
            }
        };
        for v201 = 1, #v200 do
            local v202 = v200[v201][1];
            local v203 = v200[v201][2];
            if v203 ~= nil then
                v202:override(v203);
            end;
        end;
        if l_bruteforce_0.active and globals.realtime - math.max(l_bruteforce_0.last_hurt_time, l_miss_detection_0.last_time) > l_bruteforce_0.reset_time then
            l_bruteforce_0.phase = 0;
        end;
    end, 
    activate_bruteforce = function(v204)
        -- upvalues: v27 (ref)
        if not v204.bruteforce.active then
            v204.bruteforce.active = true;
            v204.bruteforce.phase = 0;
            v27("Anti-bruteforce activated!", color(255, 255, 255, 255));
            show_notification("Anti-bruteforce activated!", {
                [1] = 255, 
                [2] = 255, 
                [3] = 255, 
                [4] = 255
            });
        end;
    end, 
    check_safe_head_conditions = function(v205, v206)
        -- upvalues: v37 (ref)
        local v207 = entity.get_local_player();
        if not v207 or not v207:is_alive() or not v37.menu.anti_aim.tweaks:get("Safe-Head") then
            v205.safe_head.active = false;
            return false;
        else
            local v208 = v37.menu.anti_aim.safe_head_triggers:get("Knife");
            local v209 = v37.menu.anti_aim.safe_head_triggers:get("Taser");
            local v210 = v37.menu.anti_aim.safe_head_triggers:get("Above Enemy");
            if v206 == 5 and (v208 or v209) then
                local l_m_hActiveWeapon_0 = v207.m_hActiveWeapon;
                if l_m_hActiveWeapon_0 then
                    local v212 = entity.get(l_m_hActiveWeapon_0);
                    if v212 then
                        local v213 = v212:get_classname() or "";
                        if v208 and (v213:find("knife", 1, true) or v213:find("Knife", 1, true)) then
                            v205.safe_head.active = true;
                            v205.safe_head.reason = "knife";
                            return true;
                        elseif v209 and v213:find("Taser", 1, true) then
                            v205.safe_head.active = true;
                            v205.safe_head.reason = "taser";
                            return true;
                        end;
                    end;
                end;
            end;
            if v206 == 5 and v210 then
                local v214 = v207:get_origin();
                if v214 then
                    local v215 = v37.menu.anti_aim.height_difference:get();
                    local v216 = entity.get_players(true);
                    if v216 then
                        for _, v218 in ipairs(v216) do
                            if v218 and v218:is_alive() and not v218:is_dormant() then
                                local v219 = v218:get_origin();
                                if v219 and v214.z > v219.z + v215 then
                                    v205.safe_head.active = true;
                                    v205.safe_head.reason = "height";
                                    return true;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            v205.safe_head.active = false;
            return false;
        end;
    end, 
    apply_safe_head = function(v220)
        if not v220.safe_head.active then
            return;
        else
            v220.overrides.pitch = "Down";
            v220.overrides.yaw_offset = 0;
            v220.overrides.yaw_hidden = false;
            v220.overrides.body_yaw_left_limit = 0;
            v220.overrides.body_yaw_right_limit = 0;
            v220.overrides.body_yaw_options = "";
            return;
        end;
    end, 
    on_player_hurt = function(v221, v222)
        -- upvalues: v14 (ref), v27 (ref)
        local v223 = entity.get_local_player();
        if not v223 or not v223:is_alive() then
            return;
        else
            if v222.userid == v223:get_player_info().user_id then
                v221:activate_bruteforce();
                v221.bruteforce.last_hurt_time = globals.realtime;
                v221.bruteforce.phase = (v221.bruteforce.phase + 1) % v14;
                table.insert(v221.bruteforce.history, {
                    time = globals.realtime, 
                    attacker = v222.attacker, 
                    hitgroup = v222.hitgroup, 
                    phase = v221.bruteforce.phase
                });
                if #v221.bruteforce.history > v221.bruteforce.max_history_size then
                    table.remove(v221.bruteforce.history, 1);
                end;
                v27("Hit detected! Switched to phase " .. v221.bruteforce.phase, color(255, 255, 255, 255));
                show_notification("Hit detected! Switched to phase " .. v221.bruteforce.phase, {
                    [1] = 255, 
                    [2] = 255, 
                    [3] = 255, 
                    [4] = 255
                });
            end;
            return;
        end;
    end, 
    on_bullet_impact = function(v224, v225)
        -- upvalues: v37 (ref), v14 (ref), v27 (ref)
        local v226 = entity.get_local_player();
        if not v226 or not v226:is_alive() then
            return;
        elseif not v37.menu.anti_aim.anti_bruteforce:get() then
            return;
        elseif globals.realtime - v224.miss_detection.last_time < v37.menu.anti_aim.anti_bruteforce.detection_cooldown:get() then
            return;
        else
            local v227 = v37.menu.anti_aim.anti_bruteforce.detection_range:get();
            local v228 = vector(v225.x, v225.y, v225.z);
            local v229 = v226:get_hitbox_position(0);
            local v230 = entity.get(v225.userid, true);
            if not v230 then
                return;
            elseif not v230:is_enemy() then
                return;
            else
                local v231 = v230:get_eye_position();
                if not v231 then
                    return;
                else
                    local v232 = (v228 - v231):normalized();
                    local v233 = (v229 - v231):dot(v232);
                    if v233 <= 0 then
                        return;
                    else
                        local v234 = v229:dist(v231 + v232 * v233);
                        if v227 <= v234 then
                            return;
                        else
                            v224:activate_bruteforce();
                            v224.miss_detection.last_time = globals.realtime;
                            v224.miss_detection.count = v224.miss_detection.count + 1;
                            v224.bruteforce.phase = (v224.bruteforce.phase + 1) % v14;
                            if #v224.miss_detection.history >= v224.miss_detection.max_history_size then
                                table.remove(v224.miss_detection.history, 1);
                            end;
                            table.insert(v224.miss_detection.history, {
                                time = globals.realtime, 
                                distance = v234, 
                                phase = v224.bruteforce.phase
                            });
                            v27("Miss detected near head! Distance: " .. math.floor(v234) .. " units. Switched to phase " .. v224.bruteforce.phase, color(255, 255, 255, 255));
                            show_notification("Miss detected near head! Distance: " .. math.floor(v234) .. " units. Switched to phase " .. v224.bruteforce.phase, {
                                [1] = 255, 
                                [2] = 255, 
                                [3] = 255, 
                                [4] = 255
                            });
                            return;
                        end;
                    end;
                end;
            end;
        end;
    end
};
v42.create_move = {};
v42.create_move.get_desync_side = function()
    local v235 = entity.get_local_player();
    if v235 == nil then
        return false;
    elseif globals.choked_commands == 0 then
        return v235.m_flPoseParameter[11] * 120 - 60 > 0;
    else
        return;
    end;
end;
v42.create_move.run = function(v236)
    -- upvalues: v42 (ref), v37 (ref)
    local v237 = entity.get_local_player();
    if not v237 or not v237:is_alive() then
        return;
    else
        local l_stateid_0 = v42.data.player_data.stateid;
        v42.data.anti_aim_data:check_safe_head_conditions(v42.data.player_data.stateid);
        if not v37.menu.anti_aim.builder[l_stateid_0].override:get() then
            l_stateid_0 = 1;
        end;
        local v239 = v37.menu.anti_aim.builder[l_stateid_0];
        v42.data.anti_aim_data.inverted = not rage.antiaim:inverter();
        v42.create_move.handle_body_yaw(v239, v236);
        v42.create_move.handle_hidden_yaw_pitch(v239);
        v42.create_move.calculate_yaw_offset(v239, v236);
        if v42.data.anti_aim_data.safe_head.active then
            v42.data.anti_aim_data:apply_safe_head();
        end;
        v42.create_move.handle_force_defensive(v239, l_stateid_0);
        v42.data.anti_aim_data:update_values();
        return;
    end;
end;
v42.create_move.handle_body_yaw = function(v240, v241)
    -- upvalues: v42 (ref), v10 (ref), v23 (ref)
    if v240.body_yaw:get() ~= "Off" then
        v42.data.anti_aim_data.overrides.body_yaw = true;
        v42.data.anti_aim_data.overrides.body_yaw_left_limit = v10;
        v42.data.anti_aim_data.overrides.body_yaw_right_limit = v10;
        if v240.body_yaw:get() == "Jitter" then
            v42.create_move.handle_jitter_body_yaw(v240, v241);
            v42.data.anti_aim_data.overrides.body_yaw_options = "Jitter";
        elseif v240.body_yaw:get() == "Breaker" then
            local v242 = v241.command_number % 100;
            local v243 = math.sin(v242) * 30;
            local v244 = math.random(-10, 10);
            local v245 = v243 + v244;
            local v246 = -v243 + v244;
            if v42.data.anti_aim_data.overrides.body_yaw_left_limit and math.abs(v245 - v42.data.anti_aim_data.overrides.body_yaw_left_limit) < 5 then
                v245 = v245 + math.random(-5, 5);
            end;
            if v42.data.anti_aim_data.overrides.body_yaw_right_limit and math.abs(v246 - v42.data.anti_aim_data.overrides.body_yaw_right_limit) < 5 then
                v246 = v246 + math.random(-5, 5);
            end;
            v42.data.anti_aim_data.overrides.body_yaw = true;
            v42.data.anti_aim_data.overrides.body_yaw_left_limit = v245;
            v42.data.anti_aim_data.overrides.body_yaw_right_limit = v246;
            v42.data.anti_aim_data.inverted = math.random(0, 1) == 0;
            v42.data.anti_aim_data.overrides.body_yaw_options = "";
        else
            v42.data.anti_aim_data.inverted = v23.body_yaw.inverter:get();
            v42.data.anti_aim_data.overrides.body_yaw_options = "";
        end;
    else
        v42.data.anti_aim_data.overrides.body_yaw = false;
        v42.data.anti_aim_data.overrides.body_yaw_left_limit = 0;
        v42.data.anti_aim_data.overrides.body_yaw_right_limit = 0;
        rage.antiaim:inverter();
    end;
end;
v42.create_move.handle_jitter_body_yaw = function(v247, v248)
    -- upvalues: v42 (ref), v37 (ref)
    local l_anti_aim_data_0 = v42.data.anti_aim_data;
    if v248.choked_commands == 0 then
        local v250 = v247.body_yaw.delay_type:get();
        local v251 = v247.body_yaw.jitter_speed:get();
        local v252 = v247.body_yaw.hold_ticks:get();
        local v253 = v247.body_yaw.randomization:get();
        l_anti_aim_data_0.switch_ticks = l_anti_aim_data_0.switch_ticks + 1;
        l_anti_aim_data_0.hold_ticks = l_anti_aim_data_0.hold_ticks + 1;
        l_anti_aim_data_0.last_calculated_delay = l_anti_aim_data_0.last_calculated_delay or {};
        local l_v251_0 = v251;
        local l_stateid_1 = v42.data.player_data.stateid;
        if not v37.menu.anti_aim.builder[l_stateid_1].override:get() then
            l_stateid_1 = 1;
        end;
        if v250 == "Progressive" then
            l_anti_aim_data_0.prog_dir = l_anti_aim_data_0.prog_dir or 1;
            l_anti_aim_data_0.prog_val = l_anti_aim_data_0.prog_val or v37.menu.anti_aim.builder[l_stateid_1].body_yaw.min_speed:get();
            local v256 = v37.menu.anti_aim.builder[l_stateid_1].body_yaw.min_speed:get();
            local v257 = v37.menu.anti_aim.builder[l_stateid_1].body_yaw.max_speed:get();
            l_anti_aim_data_0.prog_val = l_anti_aim_data_0.prog_val + l_anti_aim_data_0.prog_dir;
            if v257 <= l_anti_aim_data_0.prog_val then
                local l_v257_0 = v257;
                l_anti_aim_data_0.prog_dir = -1;
                l_anti_aim_data_0.prog_val = l_v257_0;
            elseif l_anti_aim_data_0.prog_val <= v256 then
                local l_v256_0 = v256;
                l_anti_aim_data_0.prog_dir = 1;
                l_anti_aim_data_0.prog_val = l_v256_0;
            end;
            l_v251_0 = l_anti_aim_data_0.prog_val;
        elseif v250 == "Adaptive" then
            l_v251_0 = v42.data.player_data.onground and math.max(2, v251 - math.floor(v42.data.player_data.velocity / 50)) or v251 + 2;
        elseif v250 == "Dynamic" then
            l_v251_0 = ({
                [1] = v251, 
                [2] = math.max(2, v251 - 2), 
                [3] = v251 + 1
            })[math.floor(globals.tickcount / 10 % 3) + 1] or v251;
        elseif v250 == "Oscillating" then
            local v260 = v37.menu.anti_aim.builder[l_stateid_1].body_yaw.min_speed:get();
            local v261 = (v37.menu.anti_aim.builder[l_stateid_1].body_yaw.max_speed:get() - v260) / 2;
            l_v251_0 = math.floor(v260 + v261 + v261 * math.sin(globals.tickcount * 0.1) + 0.5);
        end;
        if v250 ~= "Default" then
            if v252 > 1 and v252 < l_anti_aim_data_0.hold_ticks % 50 then
                l_v251_0 = 1;
            end;
            if v253 > 0 then
                l_v251_0 = l_v251_0 + math.random(-v253, v253);
            end;
        end;
        l_anti_aim_data_0.last_calculated_delay[v250] = l_v251_0;
        if (l_anti_aim_data_0.last_calculated_delay[v250] or v251) <= l_anti_aim_data_0.switch_ticks then
            l_anti_aim_data_0.switch_ticks = 0;
            l_anti_aim_data_0.switch = not l_anti_aim_data_0.switch;
        end;
    end;
    l_anti_aim_data_0.inverted = l_anti_aim_data_0.switch;
    rage.antiaim:inverter(l_anti_aim_data_0.inverted);
end;
v42.create_move.calculate_yaw_offset = function(v262, v263)
    -- upvalues: v42 (ref), v37 (ref)
    if v263.choked_commands ~= 0 then
        return;
    else
        v42.data.anti_aim_data.overrides.yaw_offset = v262.yaw:get();
        if v262.yaw_spin:get() then
            local v264 = v262.yaw_spin.speed:get();
            local v265 = v262.yaw_spin.smooth:get();
            local v266 = nil;
            local v267 = 60;
            if v265 then
                local v268 = globals.tickcount * (v264 / 100);
                v266 = math.sin(v268) * v267;
            else
                local v269 = globals.tickcount * v264 % (v267 * 4);
                if v269 <= v267 * 2 then
                    v266 = v269 / 2;
                else
                    v266 = v267 - (v269 - v267 * 2) / 2;
                end;
                if math.floor(globals.tickcount / 50) % 2 == 1 then
                    v266 = -v266;
                end;
            end;
            v42.data.anti_aim_data.overrides.yaw_offset = v42.data.anti_aim_data.overrides.yaw_offset + v266;
        end;
        if v37.menu.anti_aim.anti_bruteforce:get() and v42.data.anti_aim_data.bruteforce.active then
            local l_phase_0 = v42.data.anti_aim_data.bruteforce.phase;
            if v37.menu.anti_aim.anti_bruteforce.custom_offsets:get() then
                local v271 = ({
                    v37.menu.anti_aim.custom_phase_offsets.phase_1:get(), 
                    v37.menu.anti_aim.custom_phase_offsets.phase_2:get(), 
                    v37.menu.anti_aim.custom_phase_offsets.phase_3:get(), 
                    v37.menu.anti_aim.custom_phase_offsets.phase_4:get(), 
                    v37.menu.anti_aim.custom_phase_offsets.phase_5:get()
                })[l_phase_0 + 1] or 0;
                v42.data.anti_aim_data.overrides.yaw_offset = v42.data.anti_aim_data.overrides.yaw_offset + v271;
            else
                local v272 = v42.data.anti_aim_data.bruteforce.default_offsets[l_phase_0 + 1] or 0;
                v42.data.anti_aim_data.overrides.yaw_offset = v42.data.anti_aim_data.overrides.yaw_offset + v272;
            end;
        end;
        v42.create_move.apply_jitter_yaw_modifiers(v262, v263);
        if v262.randomization:get() then
            local v273 = v262.randomization.randomization_value:get();
            local v274 = (math.random(0, v273 * 2) - v273) * 0.3;
            v42.data.anti_aim_data.overrides.yaw_offset = v42.data.anti_aim_data.overrides.yaw_offset + v274;
        end;
        v42.create_move.handle_direction_mods(v262);
        return;
    end;
end;
v42.create_move.apply_jitter_yaw_modifiers = function(v275, v276)
    -- upvalues: v42 (ref)
    local v277 = nil;
    local v278 = v275.body_yaw.delay_type:get();
    local v279 = v275.body_yaw.jitter_speed:get();
    local _ = v275.body_yaw.hold_ticks:get();
    local _ = v275.body_yaw.randomization:get();
    local l_anti_aim_data_1 = v42.data.anti_aim_data;
    local v283 = l_anti_aim_data_1.last_calculated_delay[v278] or v279;
    if v283 > 1 then
        v277 = l_anti_aim_data_1.inverted;
    else
        v277 = v42.create_move.get_desync_side();
    end;
    if v275.jitter_mode:get() == "Dolce" then
        local v284 = {
            saved_yaw = 0, 
            previous_yaw = nil
        };
        local v285 = v275.yaw:get();
        local v286 = v275.minimum_yaw:get();
        local v287 = v275.maximum_yaw:get();
        local v288 = v275.step_size:get();
        local v289 = v275.variance_yaw:get();
        l_anti_aim_data_1.overrides.yaw_offset = v285;
        l_anti_aim_data_1.overrides.yaw_offset = l_anti_aim_data_1.overrides.yaw_offset + (v277 and v286 or v287);
        local v290 = v276.command_number % 15 == 0;
        local v291 = v290 and v286 or v287;
        local v292 = v291 - math.random(-v291, v291) / 2;
        v292 = math.floor(v292 / v288 + 0.5) * v288;
        if v284.previous_yaw and math.abs(v292 - v284.previous_yaw) < v288 then
            v292 = v292 + v288 * (math.random(0, 1) == 1 and 1 or -1);
        end;
        v284.previous_yaw = v284.saved_yaw;
        v284.saved_yaw = v292;
        local v293 = v291 - v284.saved_yaw - (v289 and math.random(-v291, v291) / 2 or v290 and v286 / 2 or v287 / 2);
        local v294 = v293 - v284.saved_yaw;
        if v294 < v284.saved_yaw - v293 then
            l_anti_aim_data_1.overrides.yaw_offset = l_anti_aim_data_1.overrides.yaw_offset + v293 - v294 / 2;
        else
            l_anti_aim_data_1.overrides.yaw_offset = l_anti_aim_data_1.overrides.yaw_offset + v293 - (math.random(5, 15) + v288 * (math.random(0, 1) == 1 and 1 or -1));
        end;
    else
        l_anti_aim_data_1.overrides.yaw_offset = l_anti_aim_data_1.overrides.yaw_offset + (v277 and -v275.yaw_seperation:get() or v275.yaw_seperation:get());
        if v277 then
            l_anti_aim_data_1.overrides.yaw_offset = l_anti_aim_data_1.overrides.yaw_offset - v275.yaw_warp:get();
        else
            local v295 = v283 > 1 and 0.5 or 0.7;
            l_anti_aim_data_1.overrides.yaw_offset = l_anti_aim_data_1.overrides.yaw_offset + v275.yaw_warp:get() * v295;
        end;
    end;
    if v275.randomization:get() then
        local v296 = v275.randomization.randomization_value:get();
        local v297 = (math.random(0, v296 * 2) - v296) * 0.3;
        l_anti_aim_data_1.overrides.yaw_offset = l_anti_aim_data_1.overrides.yaw_offset + v297;
    end;
end;
v42.create_move.apply_normal_yaw_modifiers = function(v298)
    -- upvalues: v42 (ref)
    v42.create_move.apply_jitter_yaw_modifiers(v298);
end;
v42.create_move.quick_knife_switch = function()
    -- upvalues: v37 (ref)
    local v299 = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist");
    events.aim_fire:set(function(_)
        -- upvalues: v299 (ref), v37 (ref)
        if v299:get() and v37.menu.other.visuals.quick_knife_switch:get() then
            local v301 = entity.get_local_player();
            if v301 then
                local v302 = v301:get_player_weapon();
                if v302 and v302:get_classname() == "CWeaponSSG08" then
                    utils.console_exec("slot3");
                    utils.execute_after(0.05, function()
                        utils.console_exec("slot1");
                    end);
                end;
            end;
        end;
    end);
end;
v42.create_move.recharge_doubletap = function()
    -- upvalues: v23 (ref)
    local v303 = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist");
    events.aim_fire:set(function(_)
        -- upvalues: v23 (ref), v303 (ref)
        if v23.doubletap:get() and v303:get() then
            v23.doubletap:set(false);
            utils.execute_after(0.05, function()
                -- upvalues: v23 (ref)
                v23.doubletap:set(true);
            end);
        end;
    end);
end;
v42.create_move.handle_direction_mods = function(_)
    -- upvalues: v37 (ref), v42 (ref)
    if globals.choked_commands == 0 then
        local _ = v37.menu.anti_aim.fs_states_list;
        local v307 = v37.menu.anti_aim.manual_yaw:get();
        local v308 = v37.menu.anti_aim.freestanding:get();
        local v309 = v37.menu.anti_aim.freestanding.disable_yaw_modifiers:get();
        local v310 = v37.menu.anti_aim.freestanding.body_freestanding:get();
        local v311 = v37.menu.anti_aim.avoid_backstab:get();
        local v312 = v37.menu.anti_aim.tweaks:get("warmup aa");
        local l_m_bWarmupPeriod_0 = entity.get_game_rules().m_bWarmupPeriod;
        v42.data.anti_aim_data.overrides.pitch = "Down";
        v42.data.anti_aim_data.overrides.yaw_base = "At Target";
        if v307 ~= "Disabled" then
            v42.data.anti_aim_data.overrides.yaw_base = "Local View";
            local v314 = {
                Right = 90, 
                Left = -90, 
                Forward = 180
            };
            local v315 = v42.data.anti_aim_data.overrides.yaw_offset or 0;
            local v316 = v314[v307] or 0;
            v42.data.anti_aim_data.overrides.yaw_offset = v316 + v315;
        end;
        local v317 = v37.menu.anti_aim.freestanding.disablers:get();
        local v318 = v42.data.player_data:get_fs_state();
        local v319 = false;
        for _, v321 in ipairs(v317) do
            if v321 == v318 then
                v319 = true;
                break;
            end;
        end;
        if v307 ~= "Disabled" or v319 then
            v42.data.anti_aim_data.overrides.freestanding = false;
            v42.data.anti_aim_data.overrides.freestanding_disable_yaw_modifiers = false;
            v42.data.anti_aim_data.overrides.freestanding_body_freestanding = false;
        else
            v42.data.anti_aim_data.overrides.freestanding = v308;
            v42.data.anti_aim_data.overrides.freestanding_disable_yaw_modifiers = v309;
            v42.data.anti_aim_data.overrides.freestanding_body_freestanding = v310;
        end;
        v42.data.anti_aim_data.overrides.avoid_backstab = v311;
        if v312 and l_m_bWarmupPeriod_0 then
            v42.data.anti_aim_data.overrides.pitch = "Disabled";
            v42.data.anti_aim_data.overrides.yaw_offset = globals.tickcount % 360 * 15;
            v42.data.anti_aim_data.overrides.yaw_hidden = false;
            v42.data.anti_aim_data.overrides.yaw_modifier = "Disabled";
            v42.data.anti_aim_data.overrides.yaw_modifier_offset = 0;
            v42.data.anti_aim_data.overrides.body_yaw = false;
            v42.data.anti_aim_data.overrides.body_yaw_left_limit = 0;
            v42.data.anti_aim_data.overrides.body_yaw_right_limit = 0;
            v42.data.anti_aim_data.overrides.body_yaw_options = "";
        end;
    end;
end;
v42.create_move.handle_force_defensive = function(v322, _)
    -- upvalues: v42 (ref)
    local v324 = v322.force_defensive:get();
    v42.data.anti_aim_data.overrides.lag_options = v324 and "Always On" or "On Peek";
    v42.data.anti_aim_data.overrides.hide_shots_options = v324 and "Break LC" or "Favor Fire Rate";
end;
v42.create_move.handle_hidden_yaw_pitch = function(v325)
    -- upvalues: v42 (ref)
    local v326 = false;
    local v327 = 0;
    v42.create_move.left_right_tick_count = v42.create_move.left_right_tick_count or 0;
    v42.create_move.left_right_side = v42.create_move.left_right_side or false;
    v42.create_move.distortion_value = v42.create_move.distortion_value or 0;
    v42.create_move.distortion_direction = v42.create_move.distortion_direction or 1;
    if v325.hidden_yaw:get() then
        local v328 = v325.hidden_yaw.select_type:get();
        v326 = true;
        if v328 == "Static" then
            rage.antiaim:override_hidden_yaw_offset(v325.hidden_yaw.amount:get());
        elseif v328 == "Jitter" then
            if globals.choked_commands == 0 then
                v42.create_move.left_right_tick_count = v42.create_move.left_right_tick_count + 1;
                if v42.create_move.left_right_tick_count >= v325.hidden_yaw.delay:get() then
                    v42.create_move.left_right_side = not v42.create_move.left_right_side;
                    v42.create_move.left_right_tick_count = 0;
                end;
                local v329 = v42.create_move.left_right_side and v325.hidden_yaw.left_value:get() or v325.hidden_yaw.right_value:get();
                rage.antiaim:override_hidden_yaw_offset(v329);
            end;
        elseif v328 == "Spin" then
            local v330 = globals.tickcount * v325.hidden_yaw.speed:get() / 5 % 360 - 180;
            rage.antiaim:override_hidden_yaw_offset(v330);
        elseif v328 == "Random" then
            local v331 = v325.hidden_yaw.min_amount:get();
            local v332 = v325.hidden_yaw.max_amount:get();
            v327 = math.random(v331, v332);
            rage.antiaim:override_hidden_yaw_offset(v327 or 0);
        elseif v328 == "Opposite" then
            rage.antiaim:override_hidden_yaw_offset(-180);
        elseif v328 == "Distortion" and globals.choked_commands == 0 then
            local v333 = v325.hidden_yaw.distortion_range:get();
            local v334 = v325.hidden_yaw.distortion_step:get();
            if v325.hidden_yaw.distortion_frequency:get() / 100 > math.random() then
                v42.create_move.distortion_direction = math.random() > 0.5 and 1 or -1;
            end;
            local v335 = math.random(v334 / 2, v334 * 2);
            v42.create_move.distortion_value = v42.create_move.distortion_value + v335 * v42.create_move.distortion_direction;
            if v333 < math.abs(v42.create_move.distortion_value) then
                v42.create_move.distortion_value = v333 * (v42.create_move.distortion_value < 0 and -1 or 1);
                v42.create_move.distortion_direction = -v42.create_move.distortion_direction;
            end;
            if math.random() < 0.1 then
                v42.create_move.distortion_value = math.random(-v333, v333);
            end;
            rage.antiaim:override_hidden_yaw_offset(v42.create_move.distortion_value);
        end;
    end;
    if v325.hidden_pitch:get() then
        local v336 = v325.hidden_pitch.select_type:get();
        v326 = true;
        if v336 == "Off" then
            rage.antiaim:override_hidden_pitch(0);
        elseif v336 == "Up" then
            rage.antiaim:override_hidden_pitch(-89);
        elseif v336 == "Down" then
            rage.antiaim:override_hidden_pitch(89);
        elseif v336 == "Random" then
            local v337 = v325.hidden_pitch.min_amount:get();
            local v338 = v325.hidden_pitch.max_amount:get();
            v327 = math.random(v337, v338);
            rage.antiaim:override_hidden_pitch(v327 or 0);
        elseif v336 == "Custom" then
            rage.antiaim:override_hidden_pitch(v325.hidden_pitch.custom:get());
        elseif v336 == "Sway" then
            v42.create_move.sway_time = v42.create_move.sway_time or 0;
            local v339 = v325.hidden_pitch.sway_min:get();
            local v340 = v325.hidden_pitch.sway_max:get();
            local v341 = v325.hidden_pitch.sway_speed:get();
            if globals.choked_commands == 0 then
                v42.create_move.sway_time = v42.create_move.sway_time + globals.frametime * v341;
            end;
            local v342 = (v340 - v339) / 2;
            local v343 = v339 + v342 + math.sin(v42.create_move.sway_time) * v342;
            rage.antiaim:override_hidden_pitch(v343);
        end;
    end;
    v42.data.anti_aim_data.overrides.yaw_hidden = v326;
end;
local v344 = {
    watermark = {}
};
v344.watermark.text = "Dolce";
v344.watermark.letter_offsets = {};
v344.watermark.letter_colors = {};
v344.watermark.gs_font = render.load_font("Verdana", 10, "adi");
v344.watermark.fps_value = 0;
v344.watermark.last_update_time = 0;
v344.watermark.initialize = function()
    -- upvalues: v344 (ref)
    for v345 = 1, #v344.watermark.text do
        v344.watermark.letter_offsets[v345] = 0;
        v344.watermark.letter_colors[v345] = color(255, 255, 255, 255);
    end;
end;
v344.watermark.update = function()
    -- upvalues: v37 (ref), v344 (ref)
    if not v37.menu.other.visuals.watermark:get() then
        return;
    else
        v344.watermark.text = "dolce";
        local l_realtime_0 = globals.realtime;
        local v347 = v37.menu.other.visuals.watermark.rainbow:get();
        local v348 = v37.menu.other.visuals.watermark.accent_color:get();
        if l_realtime_0 - v344.watermark.last_update_time >= 0.5 then
            v344.watermark.fps_value = math.floor(1 / globals.frametime);
            v344.watermark.last_update_time = l_realtime_0;
        end;
        if #v344.watermark.letter_offsets ~= #v344.watermark.text then
            v344.watermark.letter_offsets = {};
            v344.watermark.letter_colors = {};
            for v349 = 1, #v344.watermark.text do
                v344.watermark.letter_offsets[v349] = 0;
                v344.watermark.letter_colors[v349] = color(255, 255, 255, 255);
            end;
        end;
        for v350 = 1, #v344.watermark.text do
            v344.watermark.letter_offsets[v350] = math.sin(l_realtime_0 * 5 + v350 * 0.3) * 1.2;
            v344.watermark.letter_colors[v350] = v347 and v344.watermark.get_rainbow_color((v350 - 1) * 15) or v348;
        end;
        return;
    end;
end;
v344.watermark.render = function()
    -- upvalues: v37 (ref), v344 (ref)
    if not v37.menu.other.visuals.watermark:get() then
        return;
    else
        if v37.menu.other.visuals.watermark.style:get() == "Classic" then
            v344.watermark.render_wave_watermark();
        else
            v344.watermark.render_gamesense_watermark();
        end;
        return;
    end;
end;
v344.watermark.render_wave_watermark = function()
    -- upvalues: v344 (ref)
    local v351 = render.screen_size();
    local v352 = 10;
    local v353 = (v351.x - #v344.watermark.text * v352) / 2;
    local v354 = v351.y - 15;
    for v355 = 1, #v344.watermark.text do
        render.text(1, vector(v353 + (v355 - 1) * v352, v354 + v344.watermark.letter_offsets[v355]), v344.watermark.letter_colors[v355], nil, v344.watermark.text:sub(v355, v355));
    end;
end;
v344.watermark.render_gamesense_watermark = function()
    -- upvalues: v344 (ref), v37 (ref)
    local v356 = render.screen_size();
    local v357 = 8;
    local v358 = "Dol";
    local v359 = "ce";
    local v360 = v344.watermark.get_time_str();
    local v361 = tostring(v344.watermark.fps_value);
    local v362 = tostring(v344.watermark.get_ping());
    local v363 = "FPS";
    local v364 = "PING";
    local v365 = render.measure_text(1, nil, v358);
    local v366 = render.measure_text(1, nil, v359);
    local v367 = render.measure_text(2, nil, v363);
    local v368 = render.measure_text(2, nil, v364);
    local v369 = render.measure_text(1, nil, v361);
    local v370 = render.measure_text(1, nil, v362);
    local v371 = render.measure_text(1, nil, v360);
    local v372 = v365.x + v366.x + v369.x + v367.x + v370.x + v368.x + v371.x + 12 + v357 * 2;
    local v373 = math.max(v365.y, v366.y, v367.y, v368.y, v371.y) + v357 * 2 - 5;
    local v374 = v356.x - v372 - 15;
    local v375 = 5;
    local v376 = v37.menu.other.visuals.watermark.rainbow:get() and v344.watermark.get_rainbow_color() or v37.menu.other.visuals.watermark.accent_color:get();
    local v377 = v37.menu.other.visuals.watermark.background_color:get();
    local v378 = color(v377.r, v377.g, v377.b, 0);
    local v379 = color(255, 255, 255, 255);
    local v380 = v374 + v372 / 2;
    render.gradient(vector(v374, v375 + 3), vector(v380, v375 + v373), v378, v377, v378, v377, true);
    render.gradient(vector(v380, v375 + 3), vector(v374 + v372, v375 + v373), v377, v378, v377, v378, true);
    local v381 = v374 + v357;
    local v382 = v375 + v357 - 2;
    render.text(1, vector(v381, v382), v379, nil, v358);
    v381 = v381 + v365.x;
    render.text(1, vector(v381, v382), v376, nil, v359);
    v381 = v381 + v366.x + 7;
    render.text(1, vector(v381, v382), v376, nil, v361);
    v381 = v381 + v369.x;
    render.text(2, vector(v381, v382 + 1), v379, nil, v363);
    v381 = v381 + v367.x + 7;
    render.text(1, vector(v381, v382), v376, nil, v362);
    v381 = v381 + v370.x;
    render.text(2, vector(v381, v382 + 1), v379, nil, v364);
    v381 = v381 + v368.x + 7;
    render.text(1, vector(v381, v382), v379, nil, v360);
end;
v344.watermark.get_time_str = function()
    local v383 = common.get_system_time();
    return string.format("%02d:%02d:%02d", v383.hours, v383.minutes, v383.seconds);
end;
v344.watermark.get_ping = function()
    local v384 = utils.net_channel();
    return v384 and math.floor(v384.avg_latency[1] * 1000) or 0;
end;
v344.watermark.get_rainbow_color = function(v385)
    -- upvalues: v37 (ref)
    if not v385 then
        v385 = 0;
    end;
    local v386 = v37.menu.other.visuals.watermark.rainbow_speed:get() / 50;
    local v387 = v37.menu.other.visuals.watermark.rainbow_saturation:get();
    local v388 = v37.menu.other.visuals.watermark.rainbow_brightness:get();
    local v389 = (globals.realtime * 100 * v386 + v385) % 360 % 360;
    v387 = v387 / 100;
    v388 = v388 / 100;
    local v390 = v388 * v387;
    local v391 = v390 * (1 - math.abs(v389 / 60 % 2 - 1));
    local v392 = v388 - v390;
    local v393 = 0;
    local v394 = 0;
    local v395 = 0;
    if v389 < 60 then
        local l_v390_0 = v390;
        local l_v391_0 = v391;
        v395 = 0;
        v394 = l_v391_0;
        v393 = l_v390_0;
    elseif v389 < 120 then
        local l_v391_1 = v391;
        local l_v390_1 = v390;
        v395 = 0;
        v394 = l_v390_1;
        v393 = l_v391_1;
    elseif v389 < 180 then
        local v400 = 0;
        local l_v390_2 = v390;
        v395 = v391;
        v394 = l_v390_2;
        v393 = v400;
    elseif v389 < 240 then
        local v402 = 0;
        local l_v391_2 = v391;
        v395 = v390;
        v394 = l_v391_2;
        v393 = v402;
    elseif v389 < 300 then
        local l_v391_3 = v391;
        local v405 = 0;
        v395 = v390;
        v394 = v405;
        v393 = l_v391_3;
    else
        local l_v390_3 = v390;
        local v407 = 0;
        v395 = v391;
        v394 = v407;
        v393 = l_v390_3;
    end;
    return color(math.floor((v393 + v392) * 255), math.floor((v394 + v392) * 255), math.floor((v395 + v392) * 255), 255);
end;
v344.feature_indicators = {};
v344.feature_indicators.fonts = {
    main = render.load_font("Calibri", 24, "adb"), 
    icon = render.load_font("Segoe UI Symbol", 24, "adb")
};
v344.feature_indicators.alphas = {};
v344.feature_indicators.positions = {};
v344.feature_indicators.colors = {
    active = color(220, 220, 220, 255), 
    inactive = color(220, 220, 220, 180), 
    dt_ready = color(220, 220, 220, 255), 
    dt_recharging = color(255, 50, 50, 255), 
    bomb_active = color(255, 0, 0, 255), 
    bomb_inactive = color(255, 240, 140, 255), 
    bomb_fatal = color(255, 0, 0, 255), 
    bomb_non_fatal = color(255, 240, 100, 255)
};
v344.feature_indicators.render = function()
    -- upvalues: v37 (ref), v23 (ref), l_bomb_0 (ref), v344 (ref)
    if not v37.menu.other.visuals.feature_indicators:get() then
        return;
    else
        local v408 = entity.get_local_player();
        if not v408 or not v408:is_alive() then
            return;
        else
            local v409 = v23.doubletap:get();
            local v410 = rage.exploit:get() == 1;
            local v411 = not v409 and v23.hide_shots:get();
            local v412 = v23.fake_duck:get();
            local v413 = v37.menu.anti_aim.freestanding:get();
            local v414 = ui.get_binds() or {};
            local v415 = false;
            local v416 = false;
            local v417 = false;
            local v418 = false;
            for _, v420 in ipairs(v414) do
                if v420.name:find("Body Aim") then
                    v415 = v420.active;
                end;
                if v420.name:find("Safe Points") then
                    v416 = v420.active;
                end;
                if v420.name:find("Min. Damage") then
                    v417 = v420.active;
                end;
                if v420.name:find("Hit Chance") then
                    v418 = v420.active;
                end;
            end;
            local v421 = l_bomb_0.state == true;
            local v422 = l_bomb_0.state == false;
            local v423 = l_bomb_0.site or "\238\135\158";
            local v424 = l_bomb_0.dmg or "SAFE";
            local v425 = l_bomb_0.c4time or 0;
            local v426 = l_bomb_0.plant_percentage or 0;
            local v427 = {
                [1] = {
                    text = "DT", 
                    id = "dt", 
                    active = v409, 
                    color = v410 and v344.feature_indicators.colors.dt_ready or v344.feature_indicators.colors.dt_recharging
                }, 
                [2] = {
                    text = "HS", 
                    id = "hs", 
                    active = v411, 
                    color = v344.feature_indicators.colors.active
                }, 
                [3] = {
                    text = "DUCK", 
                    id = "fd", 
                    active = v412, 
                    color = v344.feature_indicators.colors.active
                }, 
                [4] = {
                    text = "SP", 
                    id = "sp", 
                    active = v416, 
                    color = v344.feature_indicators.colors.active
                }, 
                [5] = {
                    text = "BODY", 
                    id = "body", 
                    active = v415, 
                    color = v344.feature_indicators.colors.active
                }, 
                [6] = {
                    text = "HC", 
                    id = "hc", 
                    active = v418, 
                    color = v344.feature_indicators.colors.active
                }, 
                [7] = {
                    text = "MD", 
                    id = "md", 
                    active = v417, 
                    color = v344.feature_indicators.colors.active
                }, 
                [8] = {
                    text = "FS", 
                    id = "fs", 
                    active = v413, 
                    color = v344.feature_indicators.colors.active
                }
            };
            if l_bomb_0.state ~= nil and (v421 or v422) then
                table.insert(v427, {
                    icon = "\238\135\158", 
                    id = "bomb_site", 
                    text = v423, 
                    active = v422, 
                    color = v422 and v344.feature_indicators.colors.bomb_inactive or v344.feature_indicators.colors.bomb_active
                });
                if v421 then
                    table.insert(v427, {
                        active = true, 
                        icon = "\238\138\173", 
                        id = "bomb", 
                        text = string.format("%.1fs", v425), 
                        color = v344.feature_indicators.colors.bomb_inactive
                    });
                    if v424 ~= "-0 HP" then
                        table.insert(v427, {
                            active = true, 
                            id = "bomb_damage", 
                            text = v424, 
                            icon = v424 == "FATAL" and "\238\132\138" or "\238\131\167", 
                            color = v424 == "FATAL" and v344.feature_indicators.colors.bomb_fatal or v344.feature_indicators.colors.bomb_non_fatal
                        });
                    end;
                end;
            end;
            local v428 = v37.menu.other.visuals.feature_indicators.enabled_indicators:get();
            local v429 = {};
            for _, v431 in ipairs(v427) do
                local v432 = string.upper(v431.id);
                local v433 = false;
                if v432:find("BOMB") then
                    for _, v435 in ipairs(v428) do
                        if v435 == "BOMB" then
                            v433 = true;
                            break;
                        end;
                    end;
                else
                    for _, v437 in ipairs(v428) do
                        if v437 == v431.text then
                            v433 = true;
                            break;
                        end;
                    end;
                end;
                if v433 then
                    table.insert(v429, v431);
                end;
            end;
            local v438 = 0;
            for _, v440 in ipairs(v429) do
                if v344.feature_indicators.alphas[v440.id] == nil then
                    v344.feature_indicators.alphas[v440.id] = v440.active and 255 or 0;
                end;
                local v441 = v440.active and 255 or 0;
                v344.feature_indicators.alphas[v440.id] = v37.smoothy.new("ind_" .. v440.id, v441, 0.1);
                if v344.feature_indicators.alphas[v440.id] > 5 then
                    v438 = v438 + 1;
                end;
            end;
            if v438 == 0 then
                return;
            else
                local v442 = render.screen_size();
                local v443 = 35;
                local v444 = v438 * v443;
                local v445 = v442.y * 0.7 - v444 / 2;
                for _, v447 in ipairs(v429) do
                    if v344.feature_indicators.alphas[v447.id] >= 5 then
                        if not v344.feature_indicators.positions[v447.id] then
                            v344.feature_indicators.positions[v447.id] = v445;
                        end;
                        v344.feature_indicators.positions[v447.id] = v37.smoothy.new("ind_pos_" .. v447.id, v445, 0.12);
                        v445 = v445 + v443;
                        local v448 = v344.feature_indicators.positions[v447.id];
                        local v449 = v344.feature_indicators.alphas[v447.id];
                        local l_color_0 = v447.color;
                        l_color_0.a = v449;
                        local v451 = 25;
                        local l_x_1 = render.measure_text(v344.feature_indicators.fonts.main, nil, v447.text).x;
                        local v453 = 25 + l_x_1;
                        local v454 = v453 / 2;
                        local v455 = math.floor(v449 * 0.35);
                        local v456 = color(0, 0, 0, 0);
                        local v457 = color(0, 0, 0, v455);
                        render.gradient(vector(v451 - 5, v448 - 15), vector(v454, v448 + 15), v456, v457, v456, v457);
                        render.gradient(vector(v454, v448 - 15), vector(v453 + 5, v448 + 15), v457, v456, v457, v456);
                        render.text(v344.feature_indicators.fonts.main, vector(v451, v448 - 10), l_color_0, nil, v447.text);
                        if v447.id == "bomb_site" and v422 then
                            local v458 = v451 + l_x_1 + 15;
                            render.circle_outline(vector(v458, v448), color(0, 0, 0, v449), 10, 0, 1, 3);
                            render.circle_outline(vector(v458, v448), color(200, 200, 200, v449), 10, 0, v426, 3);
                        end;
                    end;
                end;
                return;
            end;
        end;
    end;
end;
v344.centered_indicators = {};
v344.centered_indicators.FONT_SIZE = 2;
v344.centered_indicators.Y_BASE_OFFSET = 20;
v344.centered_indicators.SCOPE_MAX_OFFSET = 105;
v344.centered_indicators.INDICATOR_SPACING = 9;
v344.centered_indicators.TEXT_LABEL = "D O L C E";
local v459 = {
    ANIMATION = -1, 
    DMG = 0.15, 
    DT_COLOR = 0.1, 
    DIM = 0.1, 
    MEASURE = 0.1, 
    BIND = 0.05, 
    SCOPE = 0.05
};
v344.centered_indicators.ANIMATION_SPEED = v459.ANIMATION;
v344.centered_indicators.SCOPE_ANIMATION_SPEED = v459.SCOPE;
v344.centered_indicators.BIND_ANIMATION_SPEED = v459.BIND;
v344.centered_indicators.MEASURE_ANIMATION_SPEED = v459.MEASURE;
v344.centered_indicators.DIM_TRANSITION_SPEED = v459.DIM;
v344.centered_indicators.DT_COLOR_TRANSITION_SPEED = v459.DT_COLOR;
v344.centered_indicators.DMG_ANIMATION_SPEED = v459.DMG;
v344.centered_indicators.animated_text_cache = {};
v344.centered_indicators.animated_text = function(v460, v461, v462, v463, v464)
    -- upvalues: v344 (ref)
    local v465 = globals.realtime * (v461 or 1.5);
    local v466 = v460 .. tostring(v465) .. tostring(v462) .. tostring(v463) .. tostring(v464);
    if v344.centered_indicators.animated_text_cache[v466] then
        return v344.centered_indicators.animated_text_cache[v466];
    else
        local v467 = {};
        if v462 and v463 then
            for v468 = 1, #v460 do
                local v469 = v460:sub(v468, v468);
                local v470 = math.abs(math.sin(v465 + v468 * 0.5));
                v467[v468] = ("\a%02x%02x%02x%02x%s\a7F7F7F00"):format(v462.r + (v463.r - v462.r) * v470, v462.g + (v463.g - v462.g) * v470, v462.b + (v463.b - v462.b) * v470, v464 or 255, v469);
            end;
        else
            for v471 = 1, #v460 do
                v467[v471] = v460:sub(v471, v471);
            end;
        end;
        local v472 = table.concat(v467);
        v344.centered_indicators.animated_text_cache[v466] = v472;
        local v473 = 0;
        for _ in pairs(v344.centered_indicators.animated_text_cache) do
            v473 = v473 + 1;
        end;
        if v473 > 100 then
            v344.centered_indicators.animated_text_cache = {};
        end;
        return v472;
    end;
end;
local v475 = {};
local v476 = 0;
do
    local l_v459_0, l_v475_0, l_v476_0 = v459, v475, v476;
    v344.centered_indicators.get_bind = function(v480)
        -- upvalues: l_v476_0 (ref), l_v475_0 (ref)
        local l_realtime_1 = globals.realtime;
        if l_realtime_1 - l_v476_0 > 0.1 then
            l_v475_0 = {};
            l_v476_0 = l_realtime_1;
            local l_ipairs_0 = ipairs;
            local v483 = ui.get_binds() or {};
            for _, v485 in l_ipairs_0(v483) do
                l_v475_0[v485.name] = {
                    [1] = v485.active, 
                    [2] = v485.name:match(".*%[(.*)%]") or ""
                };
            end;
        end;
        for v486, v487 in pairs(l_v475_0) do
            if v486:find(v480) then
                return v487;
            end;
        end;
        return {
            [1] = false, 
            [2] = ""
        };
    end;
    local v488 = {
        CHEGrenade = true, 
        CIncendiaryGrenade = true, 
        CDecoyGrenade = true, 
        CMolotovGrenade = true, 
        CSmokeGrenade = true, 
        CFlashbang = true
    };
    v344.centered_indicators.is_holding_grenade = function()
        -- upvalues: v488 (ref)
        local v489 = entity.get_local_player();
        if not v489 or not v489:is_alive() then
            return false;
        else
            local v490 = entity.get(v489.m_hActiveWeapon);
            return v490 and v488[v490:get_classname() or ""] ~= nil;
        end;
    end;
    local v491 = {
        [1] = "SHARED", 
        [2] = "STAND", 
        [3] = "MOVE", 
        [4] = "AIR", 
        [5] = "AIR+DUCK", 
        [6] = "DUCK", 
        [7] = "DUCK+MOVE", 
        [8] = "SLOW", 
        [9] = "FREESTAND", 
        [10] = "MANUAL"
    };
    v344.centered_indicators.get_state_name = function()
        -- upvalues: v491 (ref), v42 (ref)
        return v491[v42.data.player_data.stateid or 2] or "STAND";
    end;
    v344.centered_indicators.render = function()
        -- upvalues: v37 (ref), v344 (ref), l_v459_0 (ref), v23 (ref)
        local v492 = entity.get_local_player();
        if not v492 or not v492:is_alive() or not v37.menu.other.visuals.centered_indicators:get() then
            return;
        else
            local v493 = render.screen_size();
            local v494 = vector(v493.x / 2, v493.y / 2);
            local v495 = v37.menu.other.visuals.centered_indicators.offset:get();
            local v496 = v37.menu.other.visuals.centered_indicators.centered_indicators_color:get();
            local l_m_bIsScoped_0 = v492.m_bIsScoped;
            local v498 = v344.centered_indicators.is_holding_grenade();
            local v499 = v37.smoothy.new("scope_add", l_m_bIsScoped_0 and v344.centered_indicators.SCOPE_MAX_OFFSET or 0, l_v459_0.SCOPE);
            local v500 = math.min(tonumber(v499) or 0, 100) / 100;
            local v501 = v37.smoothy.new("dim_factor", (not not l_m_bIsScoped_0 or v498) and 0.5 or 1, l_v459_0.DIM);
            local v502 = {
                offset = v499, 
                value = v500, 
                dim = v501
            };
            local l_x_2 = render.measure_text(v344.centered_indicators.FONT_SIZE, nil, v344.centered_indicators.TEXT_LABEL).x;
            local v504 = v494.x + (l_x_2 + 5) / 2 * v502.value;
            local v505 = v494.y + v344.centered_indicators.Y_BASE_OFFSET + v495;
            local v506 = v502.value > 0.1 and 150 or 255;
            local v507 = color(90 * v501, 90 * v501, 90 * v501, v506 * v501);
            local l_v507_0 = v507;
            local v509 = color(v496.r * v501, v496.g * v501, v496.b * v501, v496.a * v501);
            local v510 = "D O L C E";
            local v511 = l_v459_0.ANIMATION or 4;
            local v512 = v344.centered_indicators.animated_text(v510, v511, l_v507_0, v509, 255 * v501);
            render.text(v344.centered_indicators.FONT_SIZE, vector(v504, v505), v507, "c", v512);
            local v513 = 0;
            local v514 = {
                [1] = {
                    "DT", 
                    v23.doubletap:get()
                }, 
                [2] = {
                    [1] = "OS-AA", 
                    [2] = not v23.doubletap:get() and v23.hide_shots:get()
                }, 
                [3] = {
                    [1] = "DMG", 
                    [2] = v344.centered_indicators.get_bind("Min. Damage")[1]
                }
            };
            local l_realtime_2 = globals.realtime;
            for _, v517 in ipairs(v514) do
                local v518 = v37.smoothy.new("bind_" .. v517[1], v517[2] and 255 or 0, l_v459_0.BIND);
                local v519 = math.min(v518, 100) / 100;
                if v519 > 0.01 then
                    v513 = v513 + v344.centered_indicators.INDICATOR_SPACING * v519;
                    local l_x_3 = render.measure_text(v344.centered_indicators.FONT_SIZE, nil, v517[1]).x;
                    local v521 = v494.x + (l_x_3 + 5) / 2 * v502.value;
                    local v522 = v494.y + v344.centered_indicators.Y_BASE_OFFSET + v495 + v513;
                    local v523 = color(255 * v501, 255 * v501, 255 * v501, v506 * v519 * v501);
                    if v517[1] == "DT" then
                        local v524 = rage.exploit:get() == 1;
                        local _ = v37.smoothy.new("dt_charge", v524 and 1 or 0, l_v459_0.DT_COLOR);
                        local v526 = v524 and "READY" or "CHARGING";
                        if not v344.centered_indicators.last_dt_status then
                            v344.centered_indicators.last_dt_status = v526;
                            v344.centered_indicators.dt_animation_start = 0;
                        end;
                        if v344.centered_indicators.last_dt_status ~= v526 then
                            v344.centered_indicators.dt_animation_start = l_realtime_2;
                            v344.centered_indicators.last_dt_status = v526;
                        end;
                        local v527 = math.min(1, (l_realtime_2 - v344.centered_indicators.dt_animation_start) / 0.15);
                        local v528 = "";
                        local v529 = #v526;
                        for v530 = 1, math.floor(v529 * v527) do
                            v528 = v528 .. v526:sub(v530, v530);
                        end;
                        local v531 = math.min(255, v506 * v519 * v501 * v527);
                        local v532 = math.min(255, v506 * v519 * v501 * (1 - v527));
                        local v533 = v344.centered_indicators.last_dt_status == v526 and v531 or v527 < 0.5 and v532 or v531;
                        local v534 = v524 and color(100 * v501, 255 * v501, 100 * v501, v533) or color(255 * v501, 50 * v501, 50 * v501, v533);
                        local l_x_4 = render.measure_text(v344.centered_indicators.FONT_SIZE, nil, v517[1]).x;
                        local l_x_5 = render.measure_text(v344.centered_indicators.FONT_SIZE, nil, v528).x;
                        local v537 = v521 - (l_x_4 + l_x_5) / 2 + l_x_4 / 2 + ((l_x_4 + l_x_5) / 2 - 6) * v502.value;
                        local v538 = v537 + l_x_4 / 2 + l_x_5 / 2;
                        render.text(v344.centered_indicators.FONT_SIZE, vector(v537, v522), v523, "c", v517[1]);
                        render.text(v344.centered_indicators.FONT_SIZE, vector(v538, v522), v534, "c", v528);
                    else
                        render.text(v344.centered_indicators.FONT_SIZE, vector(v521, v522), v523, "c", v517[1]);
                    end;
                end;
            end;
            local v539 = v344.centered_indicators.get_state_name();
            local v540 = v37.smoothy.new("measured_state", render.measure_text(v344.centered_indicators.FONT_SIZE, nil, v539).x, l_v459_0.MEASURE);
            if not v344.centered_indicators.last_state_name then
                v344.centered_indicators.last_state_name = v539;
                v344.centered_indicators.animated_state_text = v539;
                v344.centered_indicators.state_animation_start = 0;
            end;
            if v344.centered_indicators.last_state_name ~= v539 then
                v344.centered_indicators.state_animation_start = l_realtime_2;
                v344.centered_indicators.last_state_name = v539;
            end;
            local v541 = math.min(1, (l_realtime_2 - v344.centered_indicators.state_animation_start) / 0.2);
            if v541 < 1 then
                local v542 = #v539;
                local v543 = v539:sub(1, (math.floor(v542 * v541)));
                v344.centered_indicators.animated_state_text = v543;
            else
                v344.centered_indicators.animated_state_text = v539;
            end;
            local v544 = color(255 * v501, 255 * v501, 255 * v501, v506 * v501);
            local v545 = v494.x - v540 / 2 + (v540 / 2 + 2) * v502.value;
            local v546 = v494.y + v344.centered_indicators.Y_BASE_OFFSET + 3 + v513 + v495;
            render.text(v344.centered_indicators.FONT_SIZE, vector(v545, v546), v544, nil, v344.centered_indicators.animated_state_text);
            return;
        end;
    end;
end;
v344.nades_radius = {};
v344.nades_radius.anim_state = {};
v344.nades_radius.FADE_TIME = 0.5;
v344.nades_radius.MOLOTOV_RADIUS = 150;
v344.nades_radius.SMOKE_RADIUS = 144;
v344.nades_radius.render = function()
    -- upvalues: v37 (ref), v344 (ref)
    local v547 = v37.menu.other.visuals.molotov_radius:get();
    local v548 = v37.menu.other.visuals.smoke_radius:get();
    if not v547 and not v548 then
        return;
    else
        if v547 then
            local v549 = v37.menu.other.visuals.molotov_radius.color:get();
            local v550 = v37.menu.other.visuals.molotov_radius.style:get();
            local v551 = v37.menu.other.visuals.molotov_radius.visibilito:get();
            local v552 = entity.get_entities("CInferno") or {};
            for v553 = 1, #v552 do
                local v554 = v552[v553];
                local v555 = v554 and v554.m_vecOrigin;
                if v555 then
                    local v556 = tostring(v555.x) .. ":" .. tostring(v555.y) .. ":" .. tostring(v555.z);
                    v344.nades_radius.draw_radius(v556, v555, v549, v344.nades_radius.MOLOTOV_RADIUS, v550, v551);
                end;
            end;
        end;
        if v548 then
            local v557 = v37.menu.other.visuals.smoke_radius.color:get();
            local v558 = v37.menu.other.visuals.smoke_radius.style:get();
            local v559 = v37.menu.other.visuals.smoke_radius.visibilito:get();
            local v560 = entity.get_entities("CSmokeGrenadeProjectile") or {};
            for v561 = 1, #v560 do
                local v562 = v560[v561];
                if v562 and v562.m_bDidSmokeEffect then
                    local l_m_vecOrigin_0 = v562.m_vecOrigin;
                    if l_m_vecOrigin_0 then
                        local v564 = tostring(l_m_vecOrigin_0.x) .. ":" .. tostring(l_m_vecOrigin_0.y) .. ":" .. tostring(l_m_vecOrigin_0.z);
                        v344.nades_radius.draw_radius(v564, l_m_vecOrigin_0, v557, v344.nades_radius.SMOKE_RADIUS, v558, v559);
                    end;
                end;
            end;
        end;
        return;
    end;
end;
v344.nades_radius.is_position_visible = function(v565)
    local v566 = entity.get_local_player();
    if not v566 then
        return false;
    else
        local v567 = v566:get_eye_position();
        return utils.trace_line(v567, v565, v566:get_index()).fraction > 0.95;
    end;
end;
v344.nades_radius.draw_radius = function(v568, v569, v570, v571, v572, v573)
    -- upvalues: v344 (ref)
    if not entity.get_local_player() then
        return;
    elseif not v573 and not v344.nades_radius.is_position_visible(v569) then
        return;
    else
        v344.nades_radius.anim_state[v568] = v344.nades_radius.anim_state[v568] or {
            alpha = 0, 
            fading_out = false, 
            last_seen = globals.realtime
        };
        local v574 = v344.nades_radius.anim_state[v568];
        if not v574.fading_out then
            v574.last_seen = globals.realtime;
        end;
        v574.visible = true;
        local l_realtime_3 = globals.realtime;
        local _ = l_realtime_3 - v574.last_seen;
        if v574.visible then
            if v574.alpha < 1 then
                v574.alpha = math.min(1, v574.alpha + globals.frametime / v344.nades_radius.FADE_TIME);
            end;
        else
            v574.fading_out = true;
            v574.alpha = math.max(0, v574.alpha - globals.frametime / v344.nades_radius.FADE_TIME);
            if v574.alpha <= 0 then
                v344.nades_radius.anim_state[v568] = nil;
                return;
            end;
        end;
        local v577 = color(v570.r, v570.g, v570.b, math.floor(v570.a * v574.alpha));
        if v572 == "Default" then
            render.circle_3d(v569, v577, v571, 0, 1);
            local v578 = color(v570.r, v570.g, v570.b, math.floor(35 * v574.alpha));
            render.circle_3d(v569, v578, v571 - 1, 0, 8);
        elseif v572 == "Gradient" then
            local v579 = color(v570.r, v570.g, v570.b, 0);
            render.circle_3d_gradient(v569, v579, v577, v571, 0, 1);
        elseif v572 == "Pulse Outline" then
            local v580 = 2 + math.sin(l_realtime_3 * 5) * 1.5;
            render.circle_3d_outline(v569, v577, v571, 0, 1, v580);
        end;
        return;
    end;
end;
v344.damage_indicator = {};
v344.damage_indicator.FONT_MAPPING = {
    Console = 3, 
    Pixel = 2, 
    Verdana = 1, 
    Bold = 4
};
v344.damage_indicator.DMG_ANIMATION_SPEED = 0.1;
v344.damage_indicator.Y_BASE_OFFSET = 20;
v344.damage_indicator.DIM_TRANSITION_SPEED = 0.1;
v344.damage_indicator.cached_dmg_text = "";
v344.damage_indicator.cached_measure = 0;
v344.damage_indicator.get_bind = function(v581)
    local l_ipairs_1 = ipairs;
    local v583 = ui.get_binds() or {};
    for _, v585 in l_ipairs_1(v583) do
        if v585.name:find(v581) then
            return {
                [1] = v585.active, 
                [2] = v585.name:match(".*%[(.*)%]") or ""
            };
        end;
    end;
    return {
        [1] = false, 
        [2] = ""
    };
end;
v344.damage_indicator.is_holding_grenade = function()
    local v586 = entity.get_local_player();
    if not v586 or not v586:is_alive() then
        return false;
    else
        local v587 = entity.get(v586.m_hActiveWeapon);
        return v587 and (v587:get_classname() or ""):find("Grenade") ~= nil;
    end;
end;
v344.damage_indicator.is_damage_overrided = function()
    -- upvalues: v344 (ref)
    return v344.damage_indicator.get_bind("Min. Damage")[1];
end;
v344.damage_indicator.render = function(v588, _)
    -- upvalues: v37 (ref), v344 (ref), v23 (ref)
    local v590 = entity.get_local_player();
    if not v590 or not v590:is_alive() or not v37.menu.other.visuals.damage_indicator:get() then
        return;
    else
        local v591 = v37.menu.other.visuals.damage_indicator.only_when_overrided:get();
        local v592 = v344.damage_indicator.is_damage_overrided();
        if v591 and not v592 then
            return;
        else
            local v593 = v23.minimum_damage:get();
            if v593 < 0 then
                return;
            else
                local v594 = render.screen_size();
                local v595 = vector(v594.x / 2, v594.y / 2);
                local l_m_bIsScoped_1 = v590.m_bIsScoped;
                local v597 = v344.damage_indicator.is_holding_grenade();
                local v598 = v37.smoothy.new("dim_factor", (not not l_m_bIsScoped_1 or v597) and 0.5 or 1, v344.damage_indicator.DIM_TRANSITION_SPEED);
                local v599 = v588 and v588.value or 0;
                local v600 = nil;
                if v591 then
                    v600 = v593;
                else
                    v600 = v37.smoothy.new("animated_mindmg", v593, v344.damage_indicator.DMG_ANIMATION_SPEED);
                end;
                local v601 = v600 < 1 and "AUTO" or tostring(math.floor(v600 + 0.5));
                if v344.damage_indicator.cached_dmg_text ~= v601 then
                    v344.damage_indicator.cached_dmg_text = v601;
                    local v602 = v344.damage_indicator.FONT_MAPPING[v37.menu.other.visuals.damage_indicator.select_font:get()] or 1;
                    v344.damage_indicator.cached_measure = render.measure_text(v602, nil, v601).x;
                end;
                local v603 = v595.x + 3;
                local v604 = v595.y - 14;
                if v599 and v599 > 0 then
                    v603 = v603 + 10 * v599;
                end;
                local v605 = v599 and v599 > 0.1 and 150 or 255;
                local v606 = color(255 * v598, 255 * v598, 255 * v598, v605 * v598);
                local v607 = v344.damage_indicator.FONT_MAPPING[v37.menu.other.visuals.damage_indicator.select_font:get()] or 1;
                render.text(v607, vector(v603, v604), v606, nil, v601);
                return;
            end;
        end;
    end;
end;
v344.notifications = {};
v344.notifications.m_notify_text = {};
v344.notifications.cached_text_sizes = {};
v344.notifications.add = function(v608, v609, v610, v611, _)
    -- upvalues: v344 (ref)
    if not v609 then
        v609 = {
            [1] = 255, 
            [2] = 255, 
            [3] = 255, 
            [4] = 255
        };
    end;
    if not v610 then
        v610 = 8;
    end;
    local v613 = #v344.notifications.m_notify_text + 1;
    if v613 > 6 then
        table.remove(v344.notifications.m_notify_text, 1);
        v613 = 6;
    end;
    v344.notifications.m_notify_text[v613] = {
        m_text = v608, 
        m_color = v609, 
        m_time = v610, 
        fade_start_time = globals.realtime, 
        id = tostring(globals.realtime)
    };
    if not v344.notifications.cached_text_sizes[v608] then
        v344.notifications.cached_text_sizes[v608] = {
            normal = render.measure_text(1, "c", v608), 
            small = render.measure_text(1, "c", string.upper(v608))
        };
    end;
    if v611 then
        local v614 = string.format("%02X%02X%02X", v609[1], v609[2], v609[3]);
        print_raw(string.format("\a%s[Dolce]\aFFFFFF %s", v614, v608));
    end;
end;
v344.notifications.think = function(v615, v616)
    -- upvalues: v344 (ref), v37 (ref)
    if not v615 then
        return;
    else
        local v617 = #v344.notifications.m_notify_text;
        if v617 == 0 then
            return;
        else
            local v618 = v615.x * 0.5;
            local v619 = v615.y * 0.1 + 50;
            local l_realtime_4 = globals.realtime;
            local l_frametime_0 = globals.frametime;
            local v622 = v616 == "small";
            for v623 = v617, 1, -1 do
                local v624 = v344.notifications.m_notify_text[v623];
                v624.m_time = v624.m_time - l_frametime_0;
                if v624.m_time <= 0 then
                    v37.smoothy.reset("notify_alpha_" .. v624.id);
                    v37.smoothy.reset("notify_y_" .. v624.id);
                    table.remove(v344.notifications.m_notify_text, v623);
                end;
            end;
            v617 = #v344.notifications.m_notify_text;
            if v617 == 0 then
                return;
            else
                for v625 = 1, v617 do
                    local v626 = v344.notifications.m_notify_text[v625];
                    local v627 = v622 and string.upper(v626.m_text) or v626.m_text;
                    local v628 = v622 and v344.notifications.cached_text_sizes[v626.m_text].small or v344.notifications.cached_text_sizes[v626.m_text].normal;
                    local v629 = math.ceil(v628.x * 0.5);
                    local v630 = math.min(1, (l_realtime_4 - v626.fade_start_time) * 5);
                    local v631 = math.min(1, v626.m_time * 5);
                    local v632 = math.floor(255 * v630 * v631);
                    local v633 = v37.smoothy.new("notify_alpha_" .. v626.id, v632, 0.1);
                    if v633 >= 1 then
                        local v634 = v619 + (v625 - 1) * 40;
                        local v635 = v37.smoothy.new("notify_y_" .. v626.id, v634, 0.1);
                        local v636 = v615.y - v635;
                        local _ = v626.m_color;
                        render.rect(vector(v618 - v629 - 4, v636 - 47), vector(v618 + v629 + 5, v636 + v628.y - 38), color(12, 12, 12, v633), 0);
                        render.rect(vector(v618 - v629 - 8, v636 - 51), vector(v618 + v629 + 9, v636 - 48), color(40, 40, 40, v633), 0);
                        render.rect(vector(v618 - v629 - 5, v636 - 48), vector(v618 + v629 + 5, v636 - 47), color(60, 60, 60, v633), 0);
                        render.rect(vector(v618 - v629 - 10, v636 - 53), vector(v618 - v629 - 9, v636 + v628.y - 34), color(12, 12, 12, v633), 0);
                        render.rect(vector(v618 - v629 - 9, v636 - 51), vector(v618 - v629 - 8, v636 + v628.y - 33), color(60, 60, 60, v633), 0);
                        render.rect(vector(v618 - v629 - 8, v636 - 48), vector(v618 - v629 - 5, v636 + v628.y - 38), color(40, 40, 40, v633), 0);
                        render.rect(vector(v618 - v629 - 5, v636 - 48), vector(v618 - v629 - 4, v636 + v628.y - 39), color(60, 60, 60, v633), 0);
                        render.rect(vector(v618 + v629 + 10, v636 - 53), vector(v618 + v629 + 11, v636 + v628.y - 33), color(12, 12, 12, v633), 0);
                        render.rect(vector(v618 + v629 + 9, v636 - 52), vector(v618 + v629 + 10, v636 + v628.y - 34), color(60, 60, 60, v633), 0);
                        render.rect(vector(v618 + v629 + 6, v636 - 48), vector(v618 + v629 + 9, v636 + v628.y - 38), color(40, 40, 40, v633), 0);
                        render.rect(vector(v618 + v629 + 5, v636 - 48), vector(v618 + v629 + 6, v636 + v628.y - 38), color(60, 60, 60, v633), 0);
                        render.rect(vector(v618 - v629 - 10, v636 + v628.y - 34), vector(v618 + v629 + 10, v636 + v628.y - 33), color(12, 12, 12, v633), 0);
                        render.rect(vector(v618 - v629 - 5, v636 + v628.y - 39), vector(v618 + v629 + 5, v636 + v628.y - 38), color(60, 60, 60, v633), 0);
                        render.rect(vector(v618 - v629 - 8, v636 + v628.y - 38), vector(v618 + v629 + 9, v636 + v628.y - 35), color(40, 40, 40, v633), 0);
                        render.rect(vector(v618 - v629 - 8, v636 + v628.y - 35), vector(v618 + v629 + 9, v636 + v628.y - 34), color(60, 60, 60, v633), 0);
                        local v638 = v636 - 46;
                        render.gradient(vector(v618 - math.ceil(v628.x / 2 + 3), v638), vector(v618 - 4, v638 + 1), color(59, 175, 222, v633), color(202, 70, 205, v633), color(59, 175, 222, math.max(0, math.min(255, v633)) - 100), color(202, 70, 205, v633), true);
                        render.gradient(vector(v618 - 4, v638), vector(v618 + math.ceil(v628.x / 2 + 4), v638 + 1), color(202, 70, 205, v633), color(204, 227, 53, v633), color(202, 70, 205, v633), color(204, 227, 53, math.max(0, math.min(255, v633)) - 100), true);
                        render.text(1, vector(v618, v638 + v628.y - 2), color(209, 209, 209, v633), "c", v627);
                    end;
                end;
                return;
            end;
        end;
    end;
end;
v344.notifications.initialize = function()
    -- upvalues: v344 (ref)
    g_notify = v344.notifications;
    v344.notifications.cached_text_sizes = {};
end;
v344.custom_scope = {};
v344.custom_scope.anim_num = v344.custom_scope.anim_num or 0;
v344.custom_scope.render = function()
    -- upvalues: v37 (ref), v344 (ref)
    if not globals.is_in_game then
        return;
    else
        local v639 = entity.get_local_player();
        if not v639 or not v639:is_alive() then
            return;
        elseif not v37.menu.other.visuals.custom_scope:get() then
            return;
        else
            ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):set("Remove All");
            if common.is_button_down(9) then
                return;
            else
                local v640 = color(255, 255, 255, 0);
                local v641 = v37.menu.other.visuals.custom_scope.color:get();
                local v642 = v37.menu.other.visuals.custom_scope.gap:get();
                local v643 = v37.menu.other.visuals.custom_scope.size:get();
                local v644 = render.screen_size();
                local _ = vector(v644.x / 2, v644.y / 2);
                local v646 = v639.m_bIsScoped and 1 or 0;
                v344.custom_scope.anim_num = v37.smoothy.new("custom_scope_anim", v646, 0.15);
                if not v639.m_bIsScoped and v344.custom_scope.anim_num < 0.01 then
                    return;
                else
                    render.gradient(vector(v644.x / 2 - v642 * v344.custom_scope.anim_num, v644.y / 2), vector(v644.x / 2 - v642 * v344.custom_scope.anim_num - v643 * v344.custom_scope.anim_num, v644.y / 2 + 1), v641, v640, v641, v640);
                    render.gradient(vector(v644.x / 2 + v642 * v344.custom_scope.anim_num + 1, v644.y / 2), vector(v644.x / 2 + v642 * v344.custom_scope.anim_num + v643 * v344.custom_scope.anim_num, v644.y / 2 + 1), v641, v640, v641, v640);
                    render.gradient(vector(v644.x / 2, v644.y / 2 + v642 * v344.custom_scope.anim_num), vector(v644.x / 2 + 1, v644.y / 2 + v642 * v344.custom_scope.anim_num + v643 * v344.custom_scope.anim_num), v641, v641, v640, v640);
                    render.gradient(vector(v644.x / 2, v644.y / 2 - v642 * v344.custom_scope.anim_num), vector(v644.x / 2 + 1, v644.y / 2 - v642 * v344.custom_scope.anim_num - v643 * v344.custom_scope.anim_num), v641, v641, v640, v640);
                    return;
                end;
            end;
        end;
    end;
end;
v344.aimbot_logs = {};
v344.aimbot_logs.logs = {};
v344.aimbot_logs.hitbox_names = {
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
};
v344.aimbot_logs.weapon_actions = {
    knife = "Knifed", 
    inferno = "Burned", 
    hegrenade = "Naded"
};
v344.aimbot_logs.add = function(v647, v648)
    -- upvalues: v37 (ref), v344 (ref), v27 (ref)
    local v649 = v37.menu.other.visuals.aimbot_logs.max_logs:get() or 8;
    local l_realtime_5 = globals.realtime;
    for v651 = 1, math.min(#v344.aimbot_logs.logs, v649 - 1) do
        local v652 = v344.aimbot_logs.logs[v651];
        v652.target_y = v652.target_y + 20;
        v652.is_shifting = true;
    end;
    table.insert(v344.aimbot_logs.logs, 1, {
        x_pos = -200, 
        alpha = 0, 
        y_pos = 10, 
        target_y = 10, 
        is_shifting = false, 
        text = v647, 
        color = v648 or v648(255, 255, 255, 255), 
        time = l_realtime_5
    });
    if v649 < #v344.aimbot_logs.logs then
        table.remove(v344.aimbot_logs.logs);
    end;
    if v37.menu.other.visuals.aimbot_logs.output:get("Console") then
        v27(v647, v648);
    end;
end;
v344.aimbot_logs.update = function()
    -- upvalues: v37 (ref), v344 (ref)
    if not v37.menu.other.visuals.aimbot_logs:get() then
        v344.aimbot_logs.logs = {};
        return;
    else
        local l_realtime_6 = globals.realtime;
        local v654 = v37.menu.other.visuals.aimbot_logs.time:get() or 5;
        for v655 = #v344.aimbot_logs.logs, 1, -1 do
            local v656 = v344.aimbot_logs.logs[v655];
            local v657 = l_realtime_6 - v656.time;
            if v657 < 0.3 then
                v656.alpha = v657 / 0.3 * 255;
                v656.x_pos = math.min(10, v656.x_pos + (10 - v656.x_pos) * 0.1);
            elseif v654 - 0.7 < v657 then
                v656.alpha = 255 * (1 - (v657 - (v654 - 0.7)) / 0.7);
            else
                v656.alpha = 255;
                v656.x_pos = 10;
            end;
            if v656.is_shifting then
                v656.y_pos = v656.y_pos + (v656.target_y - v656.y_pos) * 0.1;
                if math.abs(v656.y_pos - v656.target_y) < 0.5 then
                    v656.y_pos = v656.target_y;
                    v656.is_shifting = false;
                end;
            end;
            if v654 < v657 then
                table.remove(v344.aimbot_logs.logs, v655);
            end;
        end;
        return;
    end;
end;
v344.aimbot_logs.render = function()
    -- upvalues: v37 (ref), v344 (ref)
    if not v37.menu.other.visuals.aimbot_logs:get() then
        return;
    elseif not v37.menu.other.visuals.aimbot_logs.output:get("Event") then
        return;
    elseif v37.menu.other.visuals.aimbot_logs.event_style:get() == "Default" then
        return;
    else
        local v658 = v37.menu.other.visuals.watermark.background_color:get();
        for _, v660 in ipairs(v344.aimbot_logs.logs) do
            local v661 = math.clamp(v660.alpha, 0, 255);
            if v661 > 0 then
                local v662 = render.measure_text(1, nil, v660.text).x + 16;
                local v663 = 18;
                local l_x_pos_0 = v660.x_pos;
                local v665 = l_x_pos_0 + v662 / 2;
                local v666 = v661 * 0.8;
                local v667 = color(v658.r, v658.g, v658.b, v666);
                local v668 = color(v658.r, v658.g, v658.b, 0);
                render.gradient(vector(l_x_pos_0, v660.y_pos), vector(v665, v660.y_pos + v663), v668, v667, v668, v667, true);
                render.gradient(vector(v665, v660.y_pos), vector(l_x_pos_0 + v662, v660.y_pos + v663), v667, v668, v667, v668, true);
                render.text(1, vector(l_x_pos_0 + 8, v660.y_pos + 3), color(255, 255, 255, v661), nil, v660.text);
            end;
        end;
        return;
    end;
end;
v344.aimbot_logs.initialize = function()
    -- upvalues: v344 (ref), v37 (ref)
    v344.aimbot_logs.logs = {};
    events.aim_ack:set(function(v669)
        -- upvalues: v37 (ref), v344 (ref)
        if not v37.menu.other.visuals.aimbot_logs:get() then
            return;
        else
            local v670 = entity.get(v669.target);
            if not v670 then
                return;
            else
                local v671 = v344.aimbot_logs.hitbox_names[v669.hitgroup];
                local v672 = v344.aimbot_logs.hitbox_names[v669.wanted_hitgroup];
                if v669.state == nil then
                    local v673 = v37.menu.other.visuals.aimbot_logs.hit_color:get();
                    local v674 = string.format("\aFFFFFFFFHit \a%s%s\aFFFFFFFF's \a%s%s\aFFFFFFFF for \a%s%d\aFFFFFFFF damage [wanted: \a%s%s\aFFFFFFFF | dmg: \a%s%d\aFFFFFFFF | hc: \a%s%d%%\aFFFFFFFF | bt: \a%s%dt\aFFFFFFFF]", v673:to_hex(), v670:get_name(), v673:to_hex(), v671, v673:to_hex(), v669.damage, v673:to_hex(), v672, v673:to_hex(), v669.wanted_damage or 0, v673:to_hex(), v669.hitchance or 0, v673:to_hex(), v669.backtrack or 0);
                    if v37.menu.other.visuals.aimbot_logs.output:get("Event") then
                        if v37.menu.other.visuals.aimbot_logs.event_style:get() == "Default" then
                            print_dev(v674);
                        else
                            v344.aimbot_logs.add(v674, v673);
                        end;
                    end;
                    if v37.menu.other.visuals.aimbot_logs.output:get("Notify") then
                        show_notification(string.format("\aFFFFFFFFHit \a%s%s\aFFFFFFFF's \a%s%s\aFFFFFFFF for \a%s%d\aFFFFFFFF damage", v673:to_hex(), v670:get_name(), v673:to_hex(), v671, v673:to_hex(), v669.damage), {
                            [1] = nil, 
                            [2] = nil, 
                            [3] = nil, 
                            [4] = 255, 
                            [1] = v673.r, 
                            [2] = v673.g, 
                            [3] = v673.b
                        });
                    end;
                else
                    local v675 = v37.menu.other.visuals.aimbot_logs.miss_color:get();
                    local v676 = string.format("\aFFFFFFFFMissed \a%s%s\aFFFFFFFF's \a%s%s\aFFFFFFFF due to \a%s%s\aFFFFFFFF [hc: \a%s%d%%\aFFFFFFFF | dmg: \a%s%d\aFFFFFFFF | bt: \a%s%d\aFFFFFFFF]", v675:to_hex(), v670:get_name(), v675:to_hex(), v672, v675:to_hex(), v669.state, v675:to_hex(), v669.hitchance or 0, v675:to_hex(), v669.wanted_damage or 0, v675:to_hex(), v669.backtrack or 0);
                    if v37.menu.other.visuals.aimbot_logs.output:get("Event") then
                        if v37.menu.other.visuals.aimbot_logs.event_style:get() == "Default" then
                            print_dev(v676);
                        else
                            v344.aimbot_logs.add(v676, v675);
                        end;
                    end;
                    if v37.menu.other.visuals.aimbot_logs.output:get("Notify") then
                        show_notification(string.format("\aFFFFFFFFMissed \a%s%s\aFFFFFFFF's \a%s%s\aFFFFFFFF due to \a%s%s\aFFFFFFFF", v675:to_hex(), v670:get_name(), v675:to_hex(), v672, v675:to_hex(), v669.state), {
                            [1] = 60, 
                            [2] = 180, 
                            [3] = 225, 
                            [4] = 255
                        });
                    end;
                end;
                return;
            end;
        end;
    end);
    events.player_hurt:set(function(v677)
        -- upvalues: v37 (ref), v344 (ref)
        if not v37.menu.other.visuals.aimbot_logs:get() then
            return;
        else
            local v678 = entity.get_local_player();
            if entity.get(v677.attacker, true) ~= v678 then
                return;
            else
                local v679 = entity.get(v677.userid, true);
                if v679 == v678 then
                    return;
                else
                    local v680 = v344.aimbot_logs.weapon_actions[v677.weapon];
                    if not v680 then
                        return;
                    else
                        local v681 = v37.menu.other.visuals.aimbot_logs.hit_color:get();
                        local v682 = string.format("\aFFFFFFFF%s \a%s%s\aFFFFFFFF for \a%s%d\aFFFFFFFF damage [\a%s%d\aFFFFFFFF health remaining]", v680, v681:to_hex(), v679:get_name(), v681:to_hex(), v677.dmg_health, v681:to_hex(), v677.health);
                        if v37.menu.other.visuals.aimbot_logs.event_style:get() == "Default" then
                            print_dev(v682);
                        else
                            v344.aimbot_logs.add(v682, v681);
                        end;
                        return;
                    end;
                end;
            end;
        end;
    end);
end;
v459 = {
    aspect_ratio = {}
};
v459.aspect_ratio.original_aspect_ratio = cvar.r_aspectratio:float();
v37.menu.other.misc.view.aspect_ratio:set_callback(function(v683)
    -- upvalues: v37 (ref), v459 (ref)
    if v683:get() then
        local v684 = v37.menu.other.misc.view.aspect_ratio.ratio_amount:get() / 100;
        cvar.r_aspectratio:float(v684);
    else
        cvar.r_aspectratio:float(v459.aspect_ratio.original_aspect_ratio);
    end;
end, true);
v37.menu.other.misc.view.aspect_ratio.ratio_amount:set_callback(function()
    -- upvalues: v37 (ref)
    if v37.menu.other.misc.view.aspect_ratio:get() then
        local v685 = v37.menu.other.misc.view.aspect_ratio.ratio_amount:get() / 100;
        cvar.r_aspectratio:float(v685);
    end;
end, true);
v459.arms = {};
v459.arms.original_skin = cvar.r_skin and cvar.r_skin:int() or 0;
v475 = function()
    -- upvalues: v37 (ref)
    local v686 = v37.menu.other.visuals.no_sleeves:get();
    materials.get_materials("sleeve", true, function(v687)
        -- upvalues: v686 (ref)
        if v687 and v687:is_valid() then
            v687:var_flag(2, v686);
        end;
    end);
end;
v476 = function()
    if cvar.r_skin and cvar.r_skin:int() ~= 0 then
        cvar.r_skin:int(0);
    end;
end;
do
    local l_v475_1, l_v476_1 = v475, v476;
    events.render(function()
        -- upvalues: l_v475_1 (ref), l_v476_1 (ref)
        l_v475_1();
        l_v476_1();
    end);
end;
v344.hitmarker = {};
v344.hitmarker.hurt_timer = 0;
v344.hitmarker.render = function()
    -- upvalues: v344 (ref), v37 (ref)
    if not globals.is_in_game then
        return;
    elseif v344.hitmarker.hurt_timer <= 0 then
        return;
    elseif not v37.menu.other.visuals.hitmarker:get() then
        return;
    else
        local v690 = 1;
        if v344.hitmarker.hurt_timer < 0.25 then
            v690 = v344.hitmarker.hurt_timer / 0.25;
        end;
        local v691 = v37.menu.other.visuals.hitmarker.color:get();
        local v692 = render.screen_size();
        local v693 = vector(v692.x / 2, v692.y / 2);
        v691.a = v691.a * v690;
        render.line(v693 - vector(10, 10), v693 - vector(5, 5), v691);
        render.line(v693 + vector(10, -10), v693 + vector(5, -5), v691);
        render.line(v693 + vector(10, 10), v693 + vector(5, 5), v691);
        render.line(v693 + vector(-10, 10), v693 + vector(-5, 5), v691);
        v344.hitmarker.hurt_timer = math.max(v344.hitmarker.hurt_timer - globals.frametime, 0);
        return;
    end;
end;
v344.hitmarker.on_player_hurt = function(v694)
    -- upvalues: v344 (ref)
    local v695 = entity.get_local_player();
    local v696 = entity.get(v694.userid, true);
    if entity.get(v694.attacker, true) == v695 and v696 ~= v695 then
        v344.hitmarker.hurt_timer = 0.5;
    end;
end;
v37.menu.other.visuals.hitmarker:set_callback(function(v697)
    -- upvalues: v344 (ref)
    local v698 = v697:get();
    if not v698 then
        v344.hitmarker.hurt_timer = 0;
    end;
    events.render:set(v344.hitmarker.render, v698);
    events.player_hurt:set(v344.hitmarker.on_player_hurt, v698);
end);
v459.freeze_period = {};
v459.freeze_period.original = false;
v459.freeze_period.modified = false;
v459.freeze_period.fakeducking = false;
v475 = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck");
do
    local l_v475_2 = v475;
    v459.freeze_period.pre = function(_)
        -- upvalues: l_v475_2 (ref), v459 (ref)
        local v701 = entity.get_game_rules();
        if not v701 then
            return;
        elseif v701.m_bWarmupPeriod then
            return;
        elseif not l_v475_2:get() then
            return;
        else
            v459.freeze_period.original = v701.m_bFreezePeriod;
            if v459.freeze_period.original then
                v701.m_bFreezePeriod = false;
                v459.freeze_period.modified = true;
                local v702 = entity.get_local_player();
                if v702 then
                    v702.m_flDuckAmount = 1;
                    v702.m_bDucking = true;
                    v702.m_bDucked = true;
                    v459.freeze_period.fakeducking = true;
                end;
            end;
            return;
        end;
    end;
    v459.freeze_period.post = function(_)
        -- upvalues: v459 (ref), l_v475_2 (ref)
        if not v459.freeze_period.modified then
            return;
        else
            if not l_v475_2:get() then
                local v704 = entity.get_game_rules();
                if v704 then
                    v704.m_bFreezePeriod = v459.freeze_period.original;
                end;
                v459.freeze_period.modified = false;
                if v459.freeze_period.fakeducking then
                    local v705 = entity.get_local_player();
                    if v705 then
                        v705.m_flDuckAmount = 0;
                        v705.m_bDucking = false;
                        v705.m_bDucked = false;
                    end;
                    v459.freeze_period.fakeducking = false;
                end;
            end;
            return;
        end;
    end;
    v459.freeze_period.reset_fakeduck = function()
        -- upvalues: v459 (ref)
        if v459.freeze_period.fakeducking then
            local v706 = entity.get_local_player();
            if v706 then
                v706.m_flDuckAmount = 0;
                v706.m_bDucking = false;
                v706.m_bDucked = false;
            end;
            v459.freeze_period.fakeducking = false;
        end;
    end;
    events.shutdown:set(function()
        -- upvalues: v459 (ref)
        if v459.freeze_period.modified then
            local v707 = entity.get_game_rules();
            if v707 then
                v707.m_bFreezePeriod = v459.freeze_period.original;
            end;
        end;
        v459.freeze_period.reset_fakeduck();
    end);
    v37.menu.other.misc.in_game.freezetime_fakeduck:set_callback(function(v708)
        -- upvalues: v459 (ref)
        if not v708:get() then
            v459.freeze_period.reset_fakeduck();
        end;
    end);
    events.createmove:set(v459.freeze_period.pre, true);
    events.createmove_run:set(v459.freeze_period.post);
end;
v459.cvars_optimalisation = {};
v459.cvars_optimalisation.update = function()
    -- upvalues: v37 (ref)
    if not v37.menu.other.misc.view.cvar_optimalisation:get() then
        for _, v710 in ipairs(v37.menu.other.misc.view.cvar_boost) do
            for _, v712 in ipairs(v710.cvar) do
                v712:int(1);
            end;
        end;
        return;
    elseif not entity.get_local_player() then
        return;
    else
        if v37.menu.other.misc.view.cvar_optimalisation.options:get() == 1 then
            cvar.r_shadows:int(0);
            cvar.cl_csm_static_prop_shadows:int(0);
            cvar.cl_csm_shadows:int(0);
            cvar.cl_csm_world_shadows:int(0);
            cvar.cl_foot_contact_shadows:int(0);
            cvar.cl_csm_viewmodel_shadows:int(0);
            cvar.cl_csm_rope_shadows:int(0);
            cvar.cl_csm_sprite_shadows:int(0);
            cvar.cl_foot_contact_shadows:int(0);
        else
            cvar.r_shadows:int(1);
            cvar.cl_csm_static_prop_shadows:int(1);
            cvar.cl_csm_shadows:int(1);
            cvar.cl_csm_world_shadows:int(1);
            cvar.cl_foot_contact_shadows:int(1);
            cvar.cl_csm_viewmodel_shadows:int(1);
            cvar.cl_csm_rope_shadows:int(1);
            cvar.cl_csm_sprite_shadows:int(1);
            cvar.cl_foot_contact_shadows:int(1);
        end;
        if v37.menu.other.misc.view.cvar_optimalisation.options:get() == 2 then
            cvar.r_drawparticles:int(0);
            cvar.cl_detail_multiplier:int(0);
            cvar.r_eyesize:int(0);
            cvar.r_eyeshift_z:int(0);
            cvar.r_eyeshift_y:int(0);
            cvar.r_eyeshift_x:int(0);
            cvar.r_eyemove:int(0);
            cvar.r_eyegloss:int(0);
            cvar.r_drawtracers_firstperson:int(0);
            cvar.r_drawtracers:int(0);
        elseif v37.menu.other.misc.view.cvar_optimalisation.options:get() == 3 then
            for _, v714 in ipairs(v37.menu.other.misc.view.cvar_boost) do
                for _, v716 in ipairs(v714.cvar) do
                    v716:int(0);
                end;
            end;
        else
            for _, v718 in ipairs(v37.menu.other.misc.view.cvar_boost) do
                for _, v720 in ipairs(v718.cvar) do
                    v720:int(1);
                end;
            end;
        end;
        return;
    end;
end;
v459.viewmodel = {};
v459.viewmodel.original_values = {
    fov = cvar.viewmodel_fov:float(), 
    x = cvar.viewmodel_offset_x:float(), 
    y = cvar.viewmodel_offset_y:float(), 
    z = cvar.viewmodel_offset_z:float()
};
v459.viewmodel.update = function()
    -- upvalues: v37 (ref), v459 (ref)
    if v37.menu.other.misc.view.viewmodel:get() then
        cvar.viewmodel_fov:float(v37.menu.other.misc.view.viewmodel.viewmodel_fov:get() / 100, true);
        cvar.viewmodel_offset_x:float(v37.menu.other.misc.view.viewmodel.viewmodel_x:get() / 100, true);
        cvar.viewmodel_offset_y:float(v37.menu.other.misc.view.viewmodel.viewmodel_y:get() / 100, true);
        cvar.viewmodel_offset_z:float(v37.menu.other.misc.view.viewmodel.viewmodel_z:get() / 100, true);
    else
        cvar.viewmodel_fov:float(v459.viewmodel.original_values.fov);
        cvar.viewmodel_offset_x:float(v459.viewmodel.original_values.x);
        cvar.viewmodel_offset_y:float(v459.viewmodel.original_values.y);
        cvar.viewmodel_offset_z:float(v459.viewmodel.original_values.z);
    end;
end;
v459.nade_dropper = {};
v475 = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled");
v476 = v37.menu.other.misc.in_game.drop_nades;
local v721 = {
    active = false, 
    pending = {}
};
do
    local l_v475_3, l_v476_2, l_v721_0 = v475, v476, v721;
    local function v727(v725)
        -- upvalues: l_v476_2 (ref)
        local l_selection_0 = l_v476_2.selection;
        return v725 == "weapon_hegrenade" and l_selection_0:get("HE") or v725 == "weapon_smokegrenade" and l_selection_0:get("Smoke") or (not (v725 ~= "weapon_molotov") or v725 == "weapon_incgrenade") and (l_selection_0:get("Molotov") or false);
    end;
    local function v730(v728)
        -- upvalues: v727 (ref)
        local v729 = v728:get_weapon_info();
        return v729 and v729.weapon_type == 9 and v727(v729.console_name);
    end;
    local function v732()
        -- upvalues: l_v721_0 (ref)
        for v731 = 1, #l_v721_0.pending do
            l_v721_0.pending[v731] = nil;
        end;
    end;
    local function v736(v733)
        -- upvalues: v730 (ref), l_v721_0 (ref)
        for _, v735 in ipairs(v733:get_player_weapon(true)) do
            if v730(v735) then
                table.insert(l_v721_0.pending, v735);
            end;
        end;
    end;
    local function v747(v737)
        -- upvalues: l_v476_2 (ref), l_v721_0 (ref), v732 (ref), v736 (ref), l_v475_3 (ref)
        local v738 = entity.get_local_player();
        local v739 = utils.net_channel();
        if not v738 or not v739 then
            return;
        else
            local v740 = l_v476_2.hotkey:get();
            if l_v721_0.prev_hotkey ~= v740 then
                l_v721_0.prev_hotkey = v740;
                if v740 and not l_v721_0.active then
                    v732();
                    v736(v738);
                    l_v721_0.active = #l_v721_0.pending > 0;
                end;
            end;
            if not l_v721_0.active then
                return;
            else
                local v741 = v739.latency[1] + to_time(4);
                for v742, v743 in ipairs(l_v721_0.pending) do
                    local v744 = v743:get_weapon_info();
                    do
                        local l_v744_0 = v744;
                        if l_v744_0 then
                            local v746 = v742 == #l_v721_0.pending;
                            utils.execute_after(v741 * v742, function()
                                -- upvalues: l_v744_0 (ref), v746 (ref), l_v721_0 (ref)
                                utils.console_exec(("use %s; drop"):format(l_v744_0.console_name));
                                if v746 then
                                    utils.execute_after(0.1, function()
                                        -- upvalues: l_v721_0 (ref)
                                        l_v721_0.active = false;
                                    end);
                                end;
                            end);
                        end;
                    end;
                end;
                v732();
                v737.no_choke = true;
                v737.send_packet = true;
                l_v475_3:override(false);
                return;
            end;
        end;
    end;
    v459.nade_dropper.initialize = function()
        -- upvalues: l_v475_3 (ref), v747 (ref), l_v476_2 (ref)
        local function v749(v748)
            -- upvalues: l_v475_3 (ref), v747 (ref)
            l_v475_3:override();
            v747(v748);
        end;
        l_v476_2:set_callback(function(v750)
            -- upvalues: v749 (ref)
            local v751 = v750:get();
            events.createmove(v749, v751);
        end, true);
    end;
end;
v459.ping_unlocker = {};
v459.ping_unlocker.update = function()
    -- upvalues: v37 (ref), v23 (ref)
    if v37.menu.other.misc.in_game.ping_unlocker:get() then
        cvar.sv_maxunlag:float(0.4);
        v23.fake_latency:override(v37.menu.other.misc.in_game.ping_unlocker.ping_amount:get());
    else
        v23.fake_latency:override(0);
    end;
end;
v459.trashtalk = {};
v459.trashtalk.phrases = {
    [1] = "RAZ RECODE DOLCE AND NOW IM GABBANA", 
    [2] = ">\226\169\138<", 
    [3] = "\226\139\134.\203\154\226\156\174Dolce\226\156\174\203\154.\226\139\134", 
    [4] = "\226\156\169\226\153\172 \226\130\138\203\154.\240\159\142\167\226\139\134\226\152\190\226\139\134\226\129\186\226\130\138\226\156\167", 
    [5] = "weak", 
    [6] = "FRIDAY 13TH for you .i.", 
    [7] = "1", 
    [8] = "lel", 
    [9] = "wyd", 
    [10] = "xD"
};
v459.trashtalk.last_phrase = "";
v459.trashtalk.initialize = function()
    -- upvalues: v37 (ref), v459 (ref)
    events.player_death:set(function(v752)
        -- upvalues: v37 (ref), v459 (ref)
        if not v37.menu.other.misc.in_game.trashtalk:get() then
            return;
        else
            local v753 = entity.get_local_player();
            if not v753 then
                return;
            else
                local v754 = entity.get(v752.attacker, true);
                if not v754 or v754 ~= v753 then
                    return;
                else
                    local v755 = entity.get(v752.userid, true);
                    if not v755 or v755 == v753 then
                        return;
                    else
                        local v756 = #v459.trashtalk.phrases;
                        if v756 == 0 then
                            return;
                        else
                            local v757 = math.random(1, v756);
                            local v758 = v459.trashtalk.phrases[v757];
                            if v758 == v459.trashtalk.last_phrase and v756 > 1 then
                                repeat
                                    v757 = math.random(1, v756);
                                    v758 = v459.trashtalk.phrases[v757];
                                until v758 ~= v459.trashtalk.last_phrase;
                            end;
                            v459.trashtalk.last_phrase = v758;
                            local v759 = utils.random_float(1, 3);
                            utils.execute_after(v759, function()
                                -- upvalues: v758 (ref)
                                utils.console_exec("say " .. v758);
                            end);
                            return;
                        end;
                    end;
                end;
            end;
        end;
    end);
end;
v459.clantag = {};
v459.clantag.text = "Dolce";
v459.clantag.last_time = 0;
v459.clantag.last_tag = "";
v459.clantag.animate = function(v760, _)
    local v762 = {};
    local v763 = #v760;
    for v764 = 0, v763 do
        table.insert(v762, v760:sub(1, v764));
    end;
    for v765 = v763 - 1, 1, -1 do
        table.insert(v762, v760:sub(1, v765));
    end;
    table.insert(v762, "");
    return v762;
end;
v459.clantag.initialize = function()
    -- upvalues: v459 (ref), v37 (ref)
    v459.clantag.tags = v459.clantag.animate(v459.clantag.text, 0.5);
    events.net_update_end:set(function()
        -- upvalues: v37 (ref), v459 (ref)
        if not v37.menu.other.misc.in_game.clantag:get() then
            if v459.clantag.last_tag ~= "" then
                common.set_clan_tag("");
                v459.clantag.last_tag = "";
            end;
            return;
        else
            local l_curtime_0 = globals.curtime;
            if l_curtime_0 - v459.clantag.last_time < 0.5 then
                return;
            else
                v459.clantag.last_time = l_curtime_0;
                local v767 = math.floor(globals.curtime * 2) % #v459.clantag.tags + 1;
                local v768 = v459.clantag.tags[v767];
                if v768 ~= v459.clantag.last_tag then
                    common.set_clan_tag(v768);
                    v459.clantag.last_tag = v768;
                end;
                return;
            end;
        end;
    end);
end;
v459.fast_ladder = {};
v459.fast_ladder.initialize = function()
    -- upvalues: v37 (ref)
    local v769 = 9;
    local function v772(v770)
        local l_x_6 = render.camera_angles().x;
        if v770.forwardmove > 0 and l_x_6 < 45 then
            v770.view_angles.x = 89;
            v770.in_moveright = 1;
            v770.in_moveleft = 0;
            v770.in_forward = 0;
            v770.in_back = 1;
            if v770.sidemove == 0 then
                v770.view_angles.y = v770.view_angles.y + 90;
            end;
            if v770.sidemove < 0 then
                v770.view_angles.y = v770.view_angles.y + 150;
            end;
            if v770.sidemove > 0 then
                v770.view_angles.y = v770.view_angles.y + 30;
            end;
        end;
        if v770.forwardmove < 0 then
            v770.view_angles.x = 89;
            v770.in_moveleft = 1;
            v770.in_moveright = 0;
            v770.in_forward = 1;
            v770.in_back = 0;
            if v770.sidemove == 0 then
                v770.view_angles.y = v770.view_angles.y + 90;
            end;
            if v770.sidemove > 0 then
                v770.view_angles.y = v770.view_angles.y + 150;
            end;
            if v770.sidemove < 0 then
                v770.view_angles.y = v770.view_angles.y + 30;
            end;
        end;
    end;
    events.createmove:set(function(v773)
        -- upvalues: v37 (ref), v769 (ref), v772 (ref)
        if not v37.menu.other.misc.movement.fast_ladder:get() then
            return;
        else
            local v774 = entity.get_local_player();
            if v774 == nil then
                return;
            elseif v774.m_MoveType ~= v769 then
                return;
            else
                v772(v773);
                return;
            end;
        end;
    end);
end;
v459.no_fall_damage = {};
v459.no_fall_damage.initialize = function()
    -- upvalues: v37 (ref)
    local v775 = false;
    local v776 = math.pi * 2;
    local v777 = v776 / 8;
    local function v788(v778, v779)
        -- upvalues: v776 (ref), v777 (ref)
        local v780 = v778:get_origin();
        for v781 = 0, v776, v777 do
            local v782 = math.sin(v781);
            local v783 = math.cos(v781);
            local v784 = v780.x + v783 * 10;
            local v785 = v780.y + v782 * 10;
            local v786 = vector(v784, v785, v780.z);
            local v787 = v786:clone();
            v787.z = v787.z - v779;
            if utils.trace_line(v786, v787, v778).fraction ~= 1 then
                return true;
            end;
        end;
        return false;
    end;
    events.createmove:set(function(v789)
        -- upvalues: v37 (ref), v775 (ref), v788 (ref)
        if not v37.menu.other.misc.movement.no_fall_damage:get() then
            return;
        else
            local v790 = entity.get_local_player();
            if not v790 or not v790:is_alive() then
                return;
            elseif v790.m_vecVelocity.z >= -500 then
                v775 = false;
                return;
            else
                if v788(v790, 15) then
                    v775 = false;
                elseif v788(v790, 75) then
                    v775 = true;
                end;
                v789.in_duck = v775;
                return;
            end;
        end;
    end);
end;
v459.super_toss = {};
v459.super_toss.initialize = function()
    -- upvalues: l_bit_0 (ref), v37 (ref)
    local v791 = false;
    local v792 = {
        air_strafe = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe"), 
        strafe_assist = ui.find("Miscellaneous", "Main", "Movement", "Strafe Assist")
    };
    local v793 = 0;
    local function _()
        local v794 = entity.get_local_player();
        if not v794 or not v794:is_alive() then
            return false;
        else
            local v795 = v794:get_player_weapon();
            if not v795 then
                return false;
            else
                local v796 = v795:get_weapon_info();
                if not v796 then
                    return false;
                else
                    return v796.weapon_type == 9;
                end;
            end;
        end;
    end;
    local function v808(v798, v799, v800, v801)
        local v802 = vector():angles(v798.x - 10 + math.abs(v798.x) / 9, v798.y);
        local v803 = v801 * 1.25;
        local v804 = math.clamp(v799 * 0.9, 15, 750) * (math.clamp(v800, 0, 1) * 0.7 + 0.3) * 1;
        local l_v802_0 = v802;
        for _ = 1, 8 do
            l_v802_0 = (v802 * (l_v802_0 * v804 + v803):length() - v803) / v804;
            l_v802_0:normalize();
        end;
        local v807 = l_v802_0.angles(l_v802_0);
        if v807.x > -10 then
            v807.x = 0.9 * v807.x + 9;
        else
            v807.x = 1.125 * v807.x + 11.25;
        end;
        return v807;
    end;
    local function v810(v809)
        -- upvalues: l_bit_0 (ref)
        if not v809 then
            return false;
        else
            return l_bit_0.band(v809.m_fFlags, 1) == 1;
        end;
    end;
    events.grenade_override_view:set(function(v811)
        -- upvalues: v37 (ref), v808 (ref), v793 (ref)
        if not v37.menu.other.misc.movement.super_toss:get() then
            return;
        else
            local v812 = entity.get_local_player();
            if not v812 then
                return;
            else
                local v813 = v812:get_player_weapon();
                if not v813 then
                    return;
                else
                    local v814 = v813:get_weapon_info();
                    if not v814 then
                        return;
                    else
                        v811.angles = v808(v811.angles, v814.throw_velocity, v813.m_flThrowStrength, v811.velocity);
                        v793 = globals.curtime;
                        return;
                    end;
                end;
            end;
        end;
    end);
    events.createmove:set(function(v815)
        -- upvalues: v791 (ref), v792 (ref), v37 (ref), v810 (ref), v808 (ref)
        if v791 then
            if v792.air_strafe then
                v792.air_strafe:override();
            end;
            if v792.strafe_assist then
                v792.strafe_assist:override();
            end;
            v791 = false;
        end;
        if not v37.menu.other.misc.movement.super_toss:get() then
            return;
        elseif v815.jitter_move ~= true then
            return;
        else
            local v816 = entity.get_local_player();
            if not v816 or not v816:is_alive() then
                return;
            else
                local v817 = v816:get_player_weapon();
                if not v817 then
                    return;
                else
                    local v818 = v817:get_weapon_info();
                    if not v818 or v818.weapon_type ~= 9 then
                        return;
                    else
                        local v819 = rage.exploit and rage.exploit:get() or 0;
                        if v817.m_fThrowTime <= 0 or v817.m_fThrowTime - 0.1 * v819 > globals.curtime then
                            return;
                        else
                            if not v810(player) then
                                if v792.air_strafe then
                                    v792.air_strafe:override(false);
                                end;
                                if v792.strafe_assist then
                                    v792.strafe_assist:override(false);
                                end;
                                v791 = true;
                            end;
                            local v820 = v816:simulate_movement();
                            if v820 then
                                v820:think();
                                v815.view_angles = v808(v815.view_angles, v818.throw_velocity, v817.m_flThrowStrength, v820.velocity);
                            end;
                            return;
                        end;
                    end;
                end;
            end;
        end;
    end);
    events.shutdown:set(function()
        -- upvalues: v791 (ref), v792 (ref)
        if v791 then
            if v792.air_strafe then
                v792.air_strafe:override();
            end;
            if v792.strafe_assist then
                v792.strafe_assist:override();
            end;
            v791 = false;
        end;
    end);
end;
show_notification = function(v821, v822)
    -- upvalues: v344 (ref)
    v344.notifications.add(v821, v822 or {
        [1] = 200, 
        [2] = 200, 
        [3] = 255, 
        [4] = 255
    }, 5);
end;
v475 = {};
v476 = l_pui_0.setup({
    [1] = v37.menu
}, true);
configdata = db.gangsta_code_here or {};
configdata.cfg_list = configdata.cfg_list or {
    [1] = {
        [1] = "Default", 
        [2] = "W3siYW50aV9haW0iOnsiYW50aV9icnV0ZWZvcmNlIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOnRydWUsImJ1aWxkZXIiOlt7ImFub21hbHlfeWF3IjpmYWxzZSwiYm9keV95YXciOiJPZmYiLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlLCJoaWRkZW5fcGl0Y2giOmZhbHNlLCJoaWRkZW5feWF3IjpmYWxzZSwiaml0dGVyX21vZGUiOiJEZWZhdWx0IiwibWF4aW11bV95YXciOjAuMCwibWluaW11bV95YXciOjAuMCwib3ZlcnJpZGUiOmZhbHNlLCJyYW5kb21pemF0aW9uIjpmYWxzZSwic3RlcF9zaXplIjoxNS4wLCJ5YXciOjAuMCwieWF3X3NlcGVyYXRpb24iOjAuMCwieWF3X3NwaW4iOmZhbHNlLCJ5YXdfd2FycCI6MC4wLCJ+Ym9keV95YXciOnsiZGVsYXlfdHlwZSI6IkRlZmF1bHQiLCJob2xkX3RpY2tzIjowLjAsImppdHRlcl9zcGVlZCI6MS4wLCJtYXhfc3BlZWQiOjguMCwibWluX3NwZWVkIjoxLjAsInJhbmRvbWl6YXRpb24iOjAuMH0sIn5oaWRkZW5fcGl0Y2giOnsiY3VzdG9tIjowLjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJzZWxlY3RfdHlwZSI6Ik9mZiIsInN3YXlfbWF4Ijo2MC4wLCJzd2F5X21pbiI6LTYwLjAsInN3YXlfc3BlZWQiOjMuMH0sIn5oaWRkZW5feWF3Ijp7ImFtb3VudCI6MC4wLCJkZWxheSI6MS4wLCJkaXN0b3J0aW9uX2ZyZXF1ZW5jeSI6MjUuMCwiZGlzdG9ydGlvbl9yYW5nZSI6OTAuMCwiZGlzdG9ydGlvbl9zdGVwIjo1LjAsImxlZnRfdmFsdWUiOi0xMjAuMCwibWF4X2Ftb3VudCI6MzUuMCwibWluX2Ftb3VudCI6LTM1LjAsInJpZ2h0X3ZhbHVlIjoxMjAuMCwic2VsZWN0X3R5cGUiOiJTdGF0aWMiLCJzcGVlZCI6MTAuMH0sIn5yYW5kb21pemF0aW9uIjp7InJhbmRvbWl6YXRpb25fdmFsdWUiOjAuMH0sIn55YXdfc3BpbiI6eyJzbW9vdGgiOmZhbHNlLCJzcGVlZCI6MjAuMH19LHsiYW5vbWFseV95YXciOmZhbHNlLCJib2R5X3lhdyI6IkppdHRlciIsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsImhpZGRlbl9waXRjaCI6ZmFsc2UsImhpZGRlbl95YXciOmZhbHNlLCJqaXR0ZXJfbW9kZSI6IkRlZmF1bHQiLCJtYXhpbXVtX3lhdyI6MC4wLCJtaW5pbXVtX3lhdyI6MC4wLCJvdmVycmlkZSI6dHJ1ZSwicmFuZG9taXphdGlvbiI6ZmFsc2UsInN0ZXBfc2l6ZSI6MTUuMCwieWF3IjotNS4wLCJ5YXdfc2VwZXJhdGlvbiI6NDQuMCwieWF3X3NwaW4iOmZhbHNlLCJ5YXdfd2FycCI6LTE3LjAsIn5ib2R5X3lhdyI6eyJkZWxheV90eXBlIjoiRGVmYXVsdCIsImhvbGRfdGlja3MiOjAuMCwiaml0dGVyX3NwZWVkIjoxLjAsIm1heF9zcGVlZCI6OC4wLCJtaW5fc3BlZWQiOjEuMCwicmFuZG9taXphdGlvbiI6MC4wfSwifmhpZGRlbl9waXRjaCI6eyJjdXN0b20iOjAuMCwibWF4X2Ftb3VudCI6MzUuMCwibWluX2Ftb3VudCI6LTM1LjAsInNlbGVjdF90eXBlIjoiT2ZmIiwic3dheV9tYXgiOjYwLjAsInN3YXlfbWluIjotNjAuMCwic3dheV9zcGVlZCI6My4wfSwifmhpZGRlbl95YXciOnsiYW1vdW50IjowLjAsImRlbGF5IjoxLjAsImRpc3RvcnRpb25fZnJlcXVlbmN5IjoyNS4wLCJkaXN0b3J0aW9uX3JhbmdlIjo5MC4wLCJkaXN0b3J0aW9uX3N0ZXAiOjUuMCwibGVmdF92YWx1ZSI6LTEyMC4wLCJtYXhfYW1vdW50IjozNS4wLCJtaW5fYW1vdW50IjotMzUuMCwicmlnaHRfdmFsdWUiOjEyMC4wLCJzZWxlY3RfdHlwZSI6IlN0YXRpYyIsInNwZWVkIjoxMC4wfSwifnJhbmRvbWl6YXRpb24iOnsicmFuZG9taXphdGlvbl92YWx1ZSI6MC4wfSwifnlhd19zcGluIjp7InNtb290aCI6ZmFsc2UsInNwZWVkIjoyMC4wfX0seyJhbm9tYWx5X3lhdyI6ZmFsc2UsImJvZHlfeWF3IjoiSml0dGVyIiwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwiaGlkZGVuX3BpdGNoIjpmYWxzZSwiaGlkZGVuX3lhdyI6ZmFsc2UsImppdHRlcl9tb2RlIjoiRGVmYXVsdCIsIm1heGltdW1feWF3IjowLjAsIm1pbmltdW1feWF3IjowLjAsIm92ZXJyaWRlIjp0cnVlLCJyYW5kb21pemF0aW9uIjpmYWxzZSwic3RlcF9zaXplIjoxNS4wLCJ5YXciOjUuMCwieWF3X3NlcGVyYXRpb24iOjM0LjAsInlhd19zcGluIjpmYWxzZSwieWF3X3dhcnAiOi0xMC4wLCJ+Ym9keV95YXciOnsiZGVsYXlfdHlwZSI6IkRlZmF1bHQiLCJob2xkX3RpY2tzIjowLjAsImppdHRlcl9zcGVlZCI6Mi4wLCJtYXhfc3BlZWQiOjguMCwibWluX3NwZWVkIjoxLjAsInJhbmRvbWl6YXRpb24iOjAuMH0sIn5oaWRkZW5fcGl0Y2giOnsiY3VzdG9tIjowLjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJzZWxlY3RfdHlwZSI6Ik9mZiIsInN3YXlfbWF4Ijo2MC4wLCJzd2F5X21pbiI6LTYwLjAsInN3YXlfc3BlZWQiOjMuMH0sIn5oaWRkZW5feWF3Ijp7ImFtb3VudCI6MC4wLCJkZWxheSI6MS4wLCJkaXN0b3J0aW9uX2ZyZXF1ZW5jeSI6MjUuMCwiZGlzdG9ydGlvbl9yYW5nZSI6OTAuMCwiZGlzdG9ydGlvbl9zdGVwIjo1LjAsImxlZnRfdmFsdWUiOi0xMjAuMCwibWF4X2Ftb3VudCI6MzUuMCwibWluX2Ftb3VudCI6LTM1LjAsInJpZ2h0X3ZhbHVlIjoxMjAuMCwic2VsZWN0X3R5cGUiOiJTdGF0aWMiLCJzcGVlZCI6MTAuMH0sIn5yYW5kb21pemF0aW9uIjp7InJhbmRvbWl6YXRpb25fdmFsdWUiOjEuMH0sIn55YXdfc3BpbiI6eyJzbW9vdGgiOmZhbHNlLCJzcGVlZCI6MjAuMH19LHsiYW5vbWFseV95YXciOmZhbHNlLCJib2R5X3lhdyI6IkppdHRlciIsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwiaGlkZGVuX3BpdGNoIjpmYWxzZSwiaGlkZGVuX3lhdyI6ZmFsc2UsImppdHRlcl9tb2RlIjoiRGVmYXVsdCIsIm1heGltdW1feWF3IjowLjAsIm1pbmltdW1feWF3IjowLjAsIm92ZXJyaWRlIjp0cnVlLCJyYW5kb21pemF0aW9uIjpmYWxzZSwic3RlcF9zaXplIjoxNS4wLCJ5YXciOjUuMCwieWF3X3NlcGVyYXRpb24iOjQyLjAsInlhd19zcGluIjpmYWxzZSwieWF3X3dhcnAiOi0yNC4wLCJ+Ym9keV95YXciOnsiZGVsYXlfdHlwZSI6IkRlZmF1bHQiLCJob2xkX3RpY2tzIjoyLjAsImppdHRlcl9zcGVlZCI6NC4wLCJtYXhfc3BlZWQiOjguMCwibWluX3NwZWVkIjoxLjAsInJhbmRvbWl6YXRpb24iOjEuMH0sIn5oaWRkZW5fcGl0Y2giOnsiY3VzdG9tIjowLjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJzZWxlY3RfdHlwZSI6Ik9mZiIsInN3YXlfbWF4Ijo2MC4wLCJzd2F5X21pbiI6LTYwLjAsInN3YXlfc3BlZWQiOjMuMH0sIn5oaWRkZW5feWF3Ijp7ImFtb3VudCI6MC4wLCJkZWxheSI6MS4wLCJkaXN0b3J0aW9uX2ZyZXF1ZW5jeSI6NjAuMCwiZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsImRpc3RvcnRpb25fc3RlcCI6MTAuMCwibGVmdF92YWx1ZSI6LTEyMC4wLCJtYXhfYW1vdW50IjozNS4wLCJtaW5fYW1vdW50IjotMzUuMCwicmlnaHRfdmFsdWUiOjEyMC4wLCJzZWxlY3RfdHlwZSI6IiIsInNwZWVkIjoxMC4wfSwifnJhbmRvbWl6YXRpb24iOnsicmFuZG9taXphdGlvbl92YWx1ZSI6MC4wfSwifnlhd19zcGluIjp7InNtb290aCI6ZmFsc2UsInNwZWVkIjoyMC4wfX0seyJhbm9tYWx5X3lhdyI6ZmFsc2UsImJvZHlfeWF3IjoiSml0dGVyIiwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJoaWRkZW5fcGl0Y2giOmZhbHNlLCJoaWRkZW5feWF3IjpmYWxzZSwiaml0dGVyX21vZGUiOiJEZWZhdWx0IiwibWF4aW11bV95YXciOjM1LjAsIm1pbmltdW1feWF3IjotMjAuMCwib3ZlcnJpZGUiOnRydWUsInJhbmRvbWl6YXRpb24iOmZhbHNlLCJzdGVwX3NpemUiOjIwLjAsInlhdyI6NS4wLCJ5YXdfc2VwZXJhdGlvbiI6MzguMCwieWF3X3NwaW4iOmZhbHNlLCJ5YXdfd2FycCI6LTYuMCwifmJvZHlfeWF3Ijp7ImRlbGF5X3R5cGUiOiJEZWZhdWx0IiwiaG9sZF90aWNrcyI6NTAuMCwiaml0dGVyX3NwZWVkIjoyLjAsIm1heF9zcGVlZCI6MTEuMCwibWluX3NwZWVkIjo0LjAsInJhbmRvbWl6YXRpb24iOjAuMH0sIn5oaWRkZW5fcGl0Y2giOnsiY3VzdG9tIjowLjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJzZWxlY3RfdHlwZSI6IlN3YXkiLCJzd2F5X21heCI6ODkuMCwic3dheV9taW4iOi0xLjAsInN3YXlfc3BlZWQiOjEuMH0sIn5oaWRkZW5feWF3Ijp7ImFtb3VudCI6MC4wLCJkZWxheSI6MTQuMCwiZGlzdG9ydGlvbl9mcmVxdWVuY3kiOjI1LjAsImRpc3RvcnRpb25fcmFuZ2UiOjkwLjAsImRpc3RvcnRpb25fc3RlcCI6NS4wLCJsZWZ0X3ZhbHVlIjotMTE1LjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJyaWdodF92YWx1ZSI6ODAuMCwic2VsZWN0X3R5cGUiOiJKaXR0ZXIiLCJzcGVlZCI6MTAuMH0sIn5yYW5kb21pemF0aW9uIjp7InJhbmRvbWl6YXRpb25fdmFsdWUiOjEuMH0sIn55YXdfc3BpbiI6eyJzbW9vdGgiOnRydWUsInNwZWVkIjo4LjB9fSx7ImFub21hbHlfeWF3IjpmYWxzZSwiYm9keV95YXciOiJKaXR0ZXIiLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlLCJoaWRkZW5fcGl0Y2giOmZhbHNlLCJoaWRkZW5feWF3IjpmYWxzZSwiaml0dGVyX21vZGUiOiJEZWZhdWx0IiwibWF4aW11bV95YXciOjAuMCwibWluaW11bV95YXciOjAuMCwib3ZlcnJpZGUiOnRydWUsInJhbmRvbWl6YXRpb24iOmZhbHNlLCJzdGVwX3NpemUiOjE1LjAsInlhdyI6MC4wLCJ5YXdfc2VwZXJhdGlvbiI6MjIuMCwieWF3X3NwaW4iOmZhbHNlLCJ5YXdfd2FycCI6MC4wLCJ+Ym9keV95YXciOnsiZGVsYXlfdHlwZSI6IkRlZmF1bHQiLCJob2xkX3RpY2tzIjowLjAsImppdHRlcl9zcGVlZCI6NC4wLCJtYXhfc3BlZWQiOjguMCwibWluX3NwZWVkIjoxLjAsInJhbmRvbWl6YXRpb24iOjAuMH0sIn5oaWRkZW5fcGl0Y2giOnsiY3VzdG9tIjowLjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJzZWxlY3RfdHlwZSI6Ik9mZiIsInN3YXlfbWF4Ijo2MC4wLCJzd2F5X21pbiI6LTYwLjAsInN3YXlfc3BlZWQiOjMuMH0sIn5oaWRkZW5feWF3Ijp7ImFtb3VudCI6MC4wLCJkZWxheSI6MS4wLCJkaXN0b3J0aW9uX2ZyZXF1ZW5jeSI6MjUuMCwiZGlzdG9ydGlvbl9yYW5nZSI6OTAuMCwiZGlzdG9ydGlvbl9zdGVwIjo1LjAsImxlZnRfdmFsdWUiOi0xMjAuMCwibWF4X2Ftb3VudCI6MzUuMCwibWluX2Ftb3VudCI6LTM1LjAsInJpZ2h0X3ZhbHVlIjoxMjAuMCwic2VsZWN0X3R5cGUiOiJTdGF0aWMiLCJzcGVlZCI6MTAuMH0sIn5yYW5kb21pemF0aW9uIjp7InJhbmRvbWl6YXRpb25fdmFsdWUiOjAuMH0sIn55YXdfc3BpbiI6eyJzbW9vdGgiOmZhbHNlLCJzcGVlZCI6MjAuMH19LHsiYW5vbWFseV95YXciOmZhbHNlLCJib2R5X3lhdyI6IkppdHRlciIsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsImhpZGRlbl9waXRjaCI6ZmFsc2UsImhpZGRlbl95YXciOmZhbHNlLCJqaXR0ZXJfbW9kZSI6IkRlZmF1bHQiLCJtYXhpbXVtX3lhdyI6MC4wLCJtaW5pbXVtX3lhdyI6MC4wLCJvdmVycmlkZSI6dHJ1ZSwicmFuZG9taXphdGlvbiI6ZmFsc2UsInN0ZXBfc2l6ZSI6MTUuMCwieWF3IjowLjAsInlhd19zZXBlcmF0aW9uIjoxOC4wLCJ5YXdfc3BpbiI6ZmFsc2UsInlhd193YXJwIjowLjAsIn5ib2R5X3lhdyI6eyJkZWxheV90eXBlIjoiRGVmYXVsdCIsImhvbGRfdGlja3MiOjAuMCwiaml0dGVyX3NwZWVkIjo5LjAsIm1heF9zcGVlZCI6OC4wLCJtaW5fc3BlZWQiOjEuMCwicmFuZG9taXphdGlvbiI6MC4wfSwifmhpZGRlbl9waXRjaCI6eyJjdXN0b20iOjAuMCwibWF4X2Ftb3VudCI6MzUuMCwibWluX2Ftb3VudCI6LTM1LjAsInNlbGVjdF90eXBlIjoiT2ZmIiwic3dheV9tYXgiOjYwLjAsInN3YXlfbWluIjotNjAuMCwic3dheV9zcGVlZCI6My4wfSwifmhpZGRlbl95YXciOnsiYW1vdW50IjowLjAsImRlbGF5IjoxLjAsImRpc3RvcnRpb25fZnJlcXVlbmN5IjoyNS4wLCJkaXN0b3J0aW9uX3JhbmdlIjo5MC4wLCJkaXN0b3J0aW9uX3N0ZXAiOjUuMCwibGVmdF92YWx1ZSI6LTEyMC4wLCJtYXhfYW1vdW50IjozNS4wLCJtaW5fYW1vdW50IjotMzUuMCwicmlnaHRfdmFsdWUiOjEyMC4wLCJzZWxlY3RfdHlwZSI6IlN0YXRpYyIsInNwZWVkIjoxMC4wfSwifnJhbmRvbWl6YXRpb24iOnsicmFuZG9taXphdGlvbl92YWx1ZSI6MC4wfSwifnlhd19zcGluIjp7InNtb290aCI6ZmFsc2UsInNwZWVkIjoyMC4wfX0seyJhbm9tYWx5X3lhdyI6ZmFsc2UsImJvZHlfeWF3IjoiSml0dGVyIiwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJoaWRkZW5fcGl0Y2giOmZhbHNlLCJoaWRkZW5feWF3IjpmYWxzZSwiaml0dGVyX21vZGUiOiJEZWZhdWx0IiwibWF4aW11bV95YXciOjAuMCwibWluaW11bV95YXciOjAuMCwib3ZlcnJpZGUiOnRydWUsInJhbmRvbWl6YXRpb24iOmZhbHNlLCJzdGVwX3NpemUiOjE1LjAsInlhdyI6My4wLCJ5YXdfc2VwZXJhdGlvbiI6LTI5LjAsInlhd19zcGluIjpmYWxzZSwieWF3X3dhcnAiOi02LjAsIn5ib2R5X3lhdyI6eyJkZWxheV90eXBlIjoiRGVmYXVsdCIsImhvbGRfdGlja3MiOjAuMCwiaml0dGVyX3NwZWVkIjo1LjAsIm1heF9zcGVlZCI6OC4wLCJtaW5fc3BlZWQiOjEuMCwicmFuZG9taXphdGlvbiI6MC4wfSwifmhpZGRlbl9waXRjaCI6eyJjdXN0b20iOi04OS4wLCJtYXhfYW1vdW50IjozNS4wLCJtaW5fYW1vdW50IjotMzUuMCwic2VsZWN0X3R5cGUiOiJPZmYiLCJzd2F5X21heCI6NjAuMCwic3dheV9taW4iOi02MC4wLCJzd2F5X3NwZWVkIjozLjB9LCJ+aGlkZGVuX3lhdyI6eyJhbW91bnQiOjAuMCwiZGVsYXkiOjEzLjAsImRpc3RvcnRpb25fZnJlcXVlbmN5IjoyNS4wLCJkaXN0b3J0aW9uX3JhbmdlIjo5MC4wLCJkaXN0b3J0aW9uX3N0ZXAiOjUuMCwibGVmdF92YWx1ZSI6LTEzNS4wLCJtYXhfYW1vdW50IjozNS4wLCJtaW5fYW1vdW50IjotMzUuMCwicmlnaHRfdmFsdWUiOjcxLjAsInNlbGVjdF90eXBlIjoiSml0dGVyIiwic3BlZWQiOjEwLjB9LCJ+cmFuZG9taXphdGlvbiI6eyJyYW5kb21pemF0aW9uX3ZhbHVlIjowLjB9LCJ+eWF3X3NwaW4iOnsic21vb3RoIjpmYWxzZSwic3BlZWQiOjIwLjB9fSx7ImFub21hbHlfeWF3IjpmYWxzZSwiYm9keV95YXciOiJKaXR0ZXIiLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlLCJoaWRkZW5fcGl0Y2giOmZhbHNlLCJoaWRkZW5feWF3IjpmYWxzZSwiaml0dGVyX21vZGUiOiJEZWZhdWx0IiwibWF4aW11bV95YXciOjAuMCwibWluaW11bV95YXciOjAuMCwib3ZlcnJpZGUiOnRydWUsInJhbmRvbWl6YXRpb24iOmZhbHNlLCJzdGVwX3NpemUiOjE1LjAsInlhdyI6MC4wLCJ5YXdfc2VwZXJhdGlvbiI6MC4wLCJ5YXdfc3BpbiI6ZmFsc2UsInlhd193YXJwIjowLjAsIn5ib2R5X3lhdyI6eyJkZWxheV90eXBlIjoiRGVmYXVsdCIsImhvbGRfdGlja3MiOjUwLjAsImppdHRlcl9zcGVlZCI6Ny4wLCJtYXhfc3BlZWQiOjIwLjAsIm1pbl9zcGVlZCI6MjAuMCwicmFuZG9taXphdGlvbiI6MTAuMH0sIn5oaWRkZW5fcGl0Y2giOnsiY3VzdG9tIjowLjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJzZWxlY3RfdHlwZSI6Ik9mZiIsInN3YXlfbWF4Ijo2MC4wLCJzd2F5X21pbiI6LTYwLjAsInN3YXlfc3BlZWQiOjMuMH0sIn5oaWRkZW5feWF3Ijp7ImFtb3VudCI6MC4wLCJkZWxheSI6MS4wLCJkaXN0b3J0aW9uX2ZyZXF1ZW5jeSI6MjUuMCwiZGlzdG9ydGlvbl9yYW5nZSI6OTAuMCwiZGlzdG9ydGlvbl9zdGVwIjo1LjAsImxlZnRfdmFsdWUiOi0xMjAuMCwibWF4X2Ftb3VudCI6MzUuMCwibWluX2Ftb3VudCI6LTM1LjAsInJpZ2h0X3ZhbHVlIjoxMjAuMCwic2VsZWN0X3R5cGUiOiJTdGF0aWMiLCJzcGVlZCI6MTAuMH0sIn5yYW5kb21pemF0aW9uIjp7InJhbmRvbWl6YXRpb25fdmFsdWUiOjAuMH0sIn55YXdfc3BpbiI6eyJzbW9vdGgiOnRydWUsInNwZWVkIjozOS4wfX0seyJhbm9tYWx5X3lhdyI6ZmFsc2UsImJvZHlfeWF3IjoiU3RhdGljIiwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwiaGlkZGVuX3BpdGNoIjpmYWxzZSwiaGlkZGVuX3lhdyI6ZmFsc2UsImppdHRlcl9tb2RlIjoiRGVmYXVsdCIsIm1heGltdW1feWF3IjowLjAsIm1pbmltdW1feWF3IjowLjAsIm92ZXJyaWRlIjp0cnVlLCJyYW5kb21pemF0aW9uIjpmYWxzZSwic3RlcF9zaXplIjoxNS4wLCJ5YXciOi0xLjAsInlhd19zZXBlcmF0aW9uIjoxLjAsInlhd19zcGluIjpmYWxzZSwieWF3X3dhcnAiOi0xLjAsIn5ib2R5X3lhdyI6eyJkZWxheV90eXBlIjoiRGVmYXVsdCIsImhvbGRfdGlja3MiOjAuMCwiaml0dGVyX3NwZWVkIjoxLjAsIm1heF9zcGVlZCI6OC4wLCJtaW5fc3BlZWQiOjEuMCwicmFuZG9taXphdGlvbiI6MC4wfSwifmhpZGRlbl9waXRjaCI6eyJjdXN0b20iOjYwLjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJzZWxlY3RfdHlwZSI6IkRvd24iLCJzd2F5X21heCI6NTAuMCwic3dheV9taW4iOjg5LjAsInN3YXlfc3BlZWQiOjEuMH0sIn5oaWRkZW5feWF3Ijp7ImFtb3VudCI6MC4wLCJkZWxheSI6MjAuMCwiZGlzdG9ydGlvbl9mcmVxdWVuY3kiOjEwMC4wLCJkaXN0b3J0aW9uX3JhbmdlIjoyNS4wLCJkaXN0b3J0aW9uX3N0ZXAiOjMwLjAsImxlZnRfdmFsdWUiOi04MC4wLCJtYXhfYW1vdW50IjozNS4wLCJtaW5fYW1vdW50IjotMzUuMCwicmlnaHRfdmFsdWUiOjgyLjAsInNlbGVjdF90eXBlIjoiSml0dGVyIiwic3BlZWQiOjEwLjB9LCJ+cmFuZG9taXphdGlvbiI6eyJyYW5kb21pemF0aW9uX3ZhbHVlIjoxLjB9LCJ+eWF3X3NwaW4iOnsic21vb3RoIjp0cnVlLCJzcGVlZCI6MS4wfX1dLCJjdXJyZW50X3N0YXRlIjoiQWlyIENyb3VjaCIsImN1c3RvbV9waGFzZV9vZmZzZXRzIjp7InBoYXNlXzEiOjI1LjAsInBoYXNlXzIiOi0xNS4wLCJwaGFzZV8zIjo0MC4wLCJwaGFzZV80IjotMzUuMCwicGhhc2VfNSI6MC4wfSwiZnJlZXN0YW5kaW5nIjpmYWxzZSwiaGVpZ2h0X2RpZmZlcmVuY2UiOjEyMC4wLCJtYW51YWxfeWF3IjoiRGlzYWJsZWQiLCJzYWZlX2hlYWRfdHJpZ2dlcnMiOlsiS25pZmUiLCJUYXNlciIsIn4iXSwic2VjdGlvbiI6MS4wLCJ0d2Vha3MiOlsiV2FybXVwIEFBIiwiU2FmZS1IZWFkIiwifiJdLCJ+YW50aV9icnV0ZWZvcmNlIjp7ImN1c3RvbV9vZmZzZXRzIjp0cnVlLCJkZXRlY3Rpb25fY29vbGRvd24iOjEuMCwiZGV0ZWN0aW9uX3JhbmdlIjoxNTAuMH0sIn5mcmVlc3RhbmRpbmciOnsiYm9keV9mcmVlc3RhbmRpbmciOmZhbHNlLCJkaXNhYmxlX3lhd19tb2RpZmllcnMiOmZhbHNlfX0sIm90aGVyIjp7Im1pc2MiOnsiaW5fZ2FtZSI6eyJjbGFudGFnIjp0cnVlLCJwaW5nX3VubG9ja2VyIjpmYWxzZSwidHJhc2h0YWxrIjp0cnVlLCJ+cGluZ191bmxvY2tlciI6eyJwaW5nX2Ftb3VudCI6MTcwLjB9fSwibW92ZW1lbnQiOnsiZmFzdF9sYWRkZXIiOnRydWUsIm5vX2ZhbGxfZGFtYWdlIjp0cnVlLCJzdXBlcl90b3NzIjp0cnVlfSwic2VjdGlvbiI6Mi4wLCJ2aWV3Ijp7ImFzcGVjdF9yYXRpbyI6dHJ1ZSwidmlld21vZGVsIjp0cnVlLCJ+YXNwZWN0X3JhdGlvIjp7InJhdGlvX2Ftb3VudCI6MTYwLjB9LCJ+dmlld21vZGVsIjp7InZpZXdtb2RlbF9mb3YiOjY4MDAuMCwidmlld21vZGVsX3giOjI1MC4wLCJ2aWV3bW9kZWxfeSI6MC4wLCJ2aWV3bW9kZWxfeiI6LTE1MC4wfX19LCJ2aXN1YWxzIjp7ImFpbWJvdF9sb2dzIjp0cnVlLCJjZW50ZXJlZF9pbmRpY2F0b3JzIjpmYWxzZSwiZGFtYWdlX2luZGljYXRvciI6dHJ1ZSwiZmVhdHVyZV9pbmRpY2F0b3JzIjp0cnVlLCJxdWlja19rbmlmZV9zd2l0Y2giOmZhbHNlLCJ3YXRlcm1hcmsiOnsiYWNjZW50X2NvbG9yIjoiIzdDQzExNUZGIiwiYmFja2dyb3VuZF9jb2xvciI6IiMxMTExMTFBQSIsInJhaW5ib3ciOmZhbHNlLCJyYWluYm93X2JyaWdodG5lc3MiOjEwMC4wLCJyYWluYm93X3NhdHVyYXRpb24iOjEwMC4wLCJyYWluYm93X3NwZWVkIjo0MC4wLCJzdHlsZSI6IkdyYWRpZW50In0sIn5haW1ib3RfbG9ncyI6eyJldmVudF9zdHlsZSI6IlJlbmRlciIsImhpdF9jb2xvciI6IiM3Q0MzMERGRiIsIm1heF9sb2dzIjo1LjAsIm1pc3NfY29sb3IiOiIjRkYzMjMyRkYiLCJvdXRwdXQiOlsiQ29uc29sZSIsIkV2ZW50IiwifiJdLCJ0aW1lIjozLjB9LCJ+Y2VudGVyZWRfaW5kaWNhdG9ycyI6eyJjZW50ZXJlZF9pbmRpY2F0b3JzX2NvbG9yIjoiI0ZGNjRGRkZGIiwib2Zmc2V0IjowLjB9LCJ+ZGFtYWdlX2luZGljYXRvciI6eyJvbmx5X3doZW5fb3ZlcnJpZGVkIjp0cnVlLCJzZWxlY3RfZm9udCI6IlZlcmRhbmEifSwifmZlYXR1cmVfaW5kaWNhdG9ycyI6eyJlbmFibGVkX2luZGljYXRvcnMiOlsiRFQiLCJIUyIsIkRVQ0siLCJTUCIsIkJPRFkiLCJNRCIsIkZTIiwiQk9NQiIsIn4iXX19fX1d"
    }
};
configdata.menu_list = configdata.menu_list or {
    [1] = "Default"
};
configdata.cfg_list[1][2] = "W3siYW50aV9haW0iOnsiYW50aV9icnV0ZWZvcmNlIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOnRydWUsImJ1aWxkZXIiOlt7ImFub21hbHlfeWF3IjpmYWxzZSwiYm9keV95YXciOiJPZmYiLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlLCJoaWRkZW5fcGl0Y2giOmZhbHNlLCJoaWRkZW5feWF3IjpmYWxzZSwiaml0dGVyX21vZGUiOiJEZWZhdWx0IiwibWF4aW11bV95YXciOjAuMCwibWluaW11bV95YXciOjAuMCwib3ZlcnJpZGUiOmZhbHNlLCJyYW5kb21pemF0aW9uIjpmYWxzZSwic3RlcF9zaXplIjoxNS4wLCJ5YXciOjAuMCwieWF3X3NlcGVyYXRpb24iOjAuMCwieWF3X3NwaW4iOmZhbHNlLCJ5YXdfd2FycCI6MC4wLCJ+Ym9keV95YXciOnsiZGVsYXlfdHlwZSI6IkRlZmF1bHQiLCJob2xkX3RpY2tzIjowLjAsImppdHRlcl9zcGVlZCI6MS4wLCJtYXhfc3BlZWQiOjguMCwibWluX3NwZWVkIjoxLjAsInJhbmRvbWl6YXRpb24iOjAuMH0sIn5oaWRkZW5fcGl0Y2giOnsiY3VzdG9tIjowLjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJzZWxlY3RfdHlwZSI6Ik9mZiIsInN3YXlfbWF4Ijo2MC4wLCJzd2F5X21pbiI6LTYwLjAsInN3YXlfc3BlZWQiOjMuMH0sIn5oaWRkZW5feWF3Ijp7ImFtb3VudCI6MC4wLCJkZWxheSI6MS4wLCJkaXN0b3J0aW9uX2ZyZXF1ZW5jeSI6MjUuMCwiZGlzdG9ydGlvbl9yYW5nZSI6OTAuMCwiZGlzdG9ydGlvbl9zdGVwIjo1LjAsImxlZnRfdmFsdWUiOi0xMjAuMCwibWF4X2Ftb3VudCI6MzUuMCwibWluX2Ftb3VudCI6LTM1LjAsInJpZ2h0X3ZhbHVlIjoxMjAuMCwic2VsZWN0X3R5cGUiOiJTdGF0aWMiLCJzcGVlZCI6MTAuMH0sIn5yYW5kb21pemF0aW9uIjp7InJhbmRvbWl6YXRpb25fdmFsdWUiOjAuMH0sIn55YXdfc3BpbiI6eyJzbW9vdGgiOmZhbHNlLCJzcGVlZCI6MjAuMH19LHsiYW5vbWFseV95YXciOmZhbHNlLCJib2R5X3lhdyI6IkppdHRlciIsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsImhpZGRlbl9waXRjaCI6ZmFsc2UsImhpZGRlbl95YXciOmZhbHNlLCJqaXR0ZXJfbW9kZSI6IkRlZmF1bHQiLCJtYXhpbXVtX3lhdyI6MC4wLCJtaW5pbXVtX3lhdyI6MC4wLCJvdmVycmlkZSI6dHJ1ZSwicmFuZG9taXphdGlvbiI6ZmFsc2UsInN0ZXBfc2l6ZSI6MTUuMCwieWF3IjotNS4wLCJ5YXdfc2VwZXJhdGlvbiI6NDQuMCwieWF3X3NwaW4iOmZhbHNlLCJ5YXdfd2FycCI6LTE3LjAsIn5ib2R5X3lhdyI6eyJkZWxheV90eXBlIjoiRGVmYXVsdCIsImhvbGRfdGlja3MiOjAuMCwiaml0dGVyX3NwZWVkIjoxLjAsIm1heF9zcGVlZCI6OC4wLCJtaW5fc3BlZWQiOjEuMCwicmFuZG9taXphdGlvbiI6MC4wfSwifmhpZGRlbl9waXRjaCI6eyJjdXN0b20iOjAuMCwibWF4X2Ftb3VudCI6MzUuMCwibWluX2Ftb3VudCI6LTM1LjAsInNlbGVjdF90eXBlIjoiT2ZmIiwic3dheV9tYXgiOjYwLjAsInN3YXlfbWluIjotNjAuMCwic3dheV9zcGVlZCI6My4wfSwifmhpZGRlbl95YXciOnsiYW1vdW50IjowLjAsImRlbGF5IjoxLjAsImRpc3RvcnRpb25fZnJlcXVlbmN5IjoyNS4wLCJkaXN0b3J0aW9uX3JhbmdlIjo5MC4wLCJkaXN0b3J0aW9uX3N0ZXAiOjUuMCwibGVmdF92YWx1ZSI6LTEyMC4wLCJtYXhfYW1vdW50IjozNS4wLCJtaW5fYW1vdW50IjotMzUuMCwicmlnaHRfdmFsdWUiOjEyMC4wLCJzZWxlY3RfdHlwZSI6IlN0YXRpYyIsInNwZWVkIjoxMC4wfSwifnJhbmRvbWl6YXRpb24iOnsicmFuZG9taXphdGlvbl92YWx1ZSI6MC4wfSwifnlhd19zcGluIjp7InNtb290aCI6ZmFsc2UsInNwZWVkIjoyMC4wfX0seyJhbm9tYWx5X3lhdyI6ZmFsc2UsImJvZHlfeWF3IjoiSml0dGVyIiwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwiaGlkZGVuX3BpdGNoIjpmYWxzZSwiaGlkZGVuX3lhdyI6ZmFsc2UsImppdHRlcl9tb2RlIjoiRGVmYXVsdCIsIm1heGltdW1feWF3IjowLjAsIm1pbmltdW1feWF3IjowLjAsIm92ZXJyaWRlIjp0cnVlLCJyYW5kb21pemF0aW9uIjpmYWxzZSwic3RlcF9zaXplIjoxNS4wLCJ5YXciOjUuMCwieWF3X3NlcGVyYXRpb24iOjM0LjAsInlhd19zcGluIjpmYWxzZSwieWF3X3dhcnAiOi0xMC4wLCJ+Ym9keV95YXciOnsiZGVsYXlfdHlwZSI6IkRlZmF1bHQiLCJob2xkX3RpY2tzIjowLjAsImppdHRlcl9zcGVlZCI6Mi4wLCJtYXhfc3BlZWQiOjguMCwibWluX3NwZWVkIjoxLjAsInJhbmRvbWl6YXRpb24iOjAuMH0sIn5oaWRkZW5fcGl0Y2giOnsiY3VzdG9tIjowLjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJzZWxlY3RfdHlwZSI6Ik9mZiIsInN3YXlfbWF4Ijo2MC4wLCJzd2F5X21pbiI6LTYwLjAsInN3YXlfc3BlZWQiOjMuMH0sIn5oaWRkZW5feWF3Ijp7ImFtb3VudCI6MC4wLCJkZWxheSI6MS4wLCJkaXN0b3J0aW9uX2ZyZXF1ZW5jeSI6MjUuMCwiZGlzdG9ydGlvbl9yYW5nZSI6OTAuMCwiZGlzdG9ydGlvbl9zdGVwIjo1LjAsImxlZnRfdmFsdWUiOi0xMjAuMCwibWF4X2Ftb3VudCI6MzUuMCwibWluX2Ftb3VudCI6LTM1LjAsInJpZ2h0X3ZhbHVlIjoxMjAuMCwic2VsZWN0X3R5cGUiOiJTdGF0aWMiLCJzcGVlZCI6MTAuMH0sIn5yYW5kb21pemF0aW9uIjp7InJhbmRvbWl6YXRpb25fdmFsdWUiOjEuMH0sIn55YXdfc3BpbiI6eyJzbW9vdGgiOmZhbHNlLCJzcGVlZCI6MjAuMH19LHsiYW5vbWFseV95YXciOmZhbHNlLCJib2R5X3lhdyI6IkppdHRlciIsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwiaGlkZGVuX3BpdGNoIjpmYWxzZSwiaGlkZGVuX3lhdyI6ZmFsc2UsImppdHRlcl9tb2RlIjoiRGVmYXVsdCIsIm1heGltdW1feWF3IjowLjAsIm1pbmltdW1feWF3IjowLjAsIm92ZXJyaWRlIjp0cnVlLCJyYW5kb21pemF0aW9uIjpmYWxzZSwic3RlcF9zaXplIjoxNS4wLCJ5YXciOjUuMCwieWF3X3NlcGVyYXRpb24iOjQyLjAsInlhd19zcGluIjpmYWxzZSwieWF3X3dhcnAiOi0yNC4wLCJ+Ym9keV95YXciOnsiZGVsYXlfdHlwZSI6IkRlZmF1bHQiLCJob2xkX3RpY2tzIjoyLjAsImppdHRlcl9zcGVlZCI6NC4wLCJtYXhfc3BlZWQiOjguMCwibWluX3NwZWVkIjoxLjAsInJhbmRvbWl6YXRpb24iOjEuMH0sIn5oaWRkZW5fcGl0Y2giOnsiY3VzdG9tIjowLjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJzZWxlY3RfdHlwZSI6Ik9mZiIsInN3YXlfbWF4Ijo2MC4wLCJzd2F5X21pbiI6LTYwLjAsInN3YXlfc3BlZWQiOjMuMH0sIn5oaWRkZW5feWF3Ijp7ImFtb3VudCI6MC4wLCJkZWxheSI6MS4wLCJkaXN0b3J0aW9uX2ZyZXF1ZW5jeSI6NjAuMCwiZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsImRpc3RvcnRpb25fc3RlcCI6MTAuMCwibGVmdF92YWx1ZSI6LTEyMC4wLCJtYXhfYW1vdW50IjozNS4wLCJtaW5fYW1vdW50IjotMzUuMCwicmlnaHRfdmFsdWUiOjEyMC4wLCJzZWxlY3RfdHlwZSI6IiIsInNwZWVkIjoxMC4wfSwifnJhbmRvbWl6YXRpb24iOnsicmFuZG9taXphdGlvbl92YWx1ZSI6MC4wfSwifnlhd19zcGluIjp7InNtb290aCI6ZmFsc2UsInNwZWVkIjoyMC4wfX0seyJhbm9tYWx5X3lhdyI6ZmFsc2UsImJvZHlfeWF3IjoiSml0dGVyIiwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJoaWRkZW5fcGl0Y2giOmZhbHNlLCJoaWRkZW5feWF3IjpmYWxzZSwiaml0dGVyX21vZGUiOiJEZWZhdWx0IiwibWF4aW11bV95YXciOjM1LjAsIm1pbmltdW1feWF3IjotMjAuMCwib3ZlcnJpZGUiOnRydWUsInJhbmRvbWl6YXRpb24iOmZhbHNlLCJzdGVwX3NpemUiOjIwLjAsInlhdyI6NS4wLCJ5YXdfc2VwZXJhdGlvbiI6MzguMCwieWF3X3NwaW4iOmZhbHNlLCJ5YXdfd2FycCI6LTYuMCwifmJvZHlfeWF3Ijp7ImRlbGF5X3R5cGUiOiJEZWZhdWx0IiwiaG9sZF90aWNrcyI6NTAuMCwiaml0dGVyX3NwZWVkIjoyLjAsIm1heF9zcGVlZCI6MTEuMCwibWluX3NwZWVkIjo0LjAsInJhbmRvbWl6YXRpb24iOjAuMH0sIn5oaWRkZW5fcGl0Y2giOnsiY3VzdG9tIjowLjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJzZWxlY3RfdHlwZSI6IlN3YXkiLCJzd2F5X21heCI6ODkuMCwic3dheV9taW4iOi0xLjAsInN3YXlfc3BlZWQiOjEuMH0sIn5oaWRkZW5feWF3Ijp7ImFtb3VudCI6MC4wLCJkZWxheSI6MTQuMCwiZGlzdG9ydGlvbl9mcmVxdWVuY3kiOjI1LjAsImRpc3RvcnRpb25fcmFuZ2UiOjkwLjAsImRpc3RvcnRpb25fc3RlcCI6NS4wLCJsZWZ0X3ZhbHVlIjotMTE1LjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJyaWdodF92YWx1ZSI6ODAuMCwic2VsZWN0X3R5cGUiOiJKaXR0ZXIiLCJzcGVlZCI6MTAuMH0sIn5yYW5kb21pemF0aW9uIjp7InJhbmRvbWl6YXRpb25fdmFsdWUiOjEuMH0sIn55YXdfc3BpbiI6eyJzbW9vdGgiOnRydWUsInNwZWVkIjo4LjB9fSx7ImFub21hbHlfeWF3IjpmYWxzZSwiYm9keV95YXciOiJKaXR0ZXIiLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlLCJoaWRkZW5fcGl0Y2giOmZhbHNlLCJoaWRkZW5feWF3IjpmYWxzZSwiaml0dGVyX21vZGUiOiJEZWZhdWx0IiwibWF4aW11bV95YXciOjAuMCwibWluaW11bV95YXciOjAuMCwib3ZlcnJpZGUiOnRydWUsInJhbmRvbWl6YXRpb24iOmZhbHNlLCJzdGVwX3NpemUiOjE1LjAsInlhdyI6MC4wLCJ5YXdfc2VwZXJhdGlvbiI6MjIuMCwieWF3X3NwaW4iOmZhbHNlLCJ5YXdfd2FycCI6MC4wLCJ+Ym9keV95YXciOnsiZGVsYXlfdHlwZSI6IkRlZmF1bHQiLCJob2xkX3RpY2tzIjowLjAsImppdHRlcl9zcGVlZCI6NC4wLCJtYXhfc3BlZWQiOjguMCwibWluX3NwZWVkIjoxLjAsInJhbmRvbWl6YXRpb24iOjAuMH0sIn5oaWRkZW5fcGl0Y2giOnsiY3VzdG9tIjowLjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJzZWxlY3RfdHlwZSI6Ik9mZiIsInN3YXlfbWF4Ijo2MC4wLCJzd2F5X21pbiI6LTYwLjAsInN3YXlfc3BlZWQiOjMuMH0sIn5oaWRkZW5feWF3Ijp7ImFtb3VudCI6MC4wLCJkZWxheSI6MS4wLCJkaXN0b3J0aW9uX2ZyZXF1ZW5jeSI6MjUuMCwiZGlzdG9ydGlvbl9yYW5nZSI6OTAuMCwiZGlzdG9ydGlvbl9zdGVwIjo1LjAsImxlZnRfdmFsdWUiOi0xMjAuMCwibWF4X2Ftb3VudCI6MzUuMCwibWluX2Ftb3VudCI6LTM1LjAsInJpZ2h0X3ZhbHVlIjoxMjAuMCwic2VsZWN0X3R5cGUiOiJTdGF0aWMiLCJzcGVlZCI6MTAuMH0sIn5yYW5kb21pemF0aW9uIjp7InJhbmRvbWl6YXRpb25fdmFsdWUiOjAuMH0sIn55YXdfc3BpbiI6eyJzbW9vdGgiOmZhbHNlLCJzcGVlZCI6MjAuMH19LHsiYW5vbWFseV95YXciOmZhbHNlLCJib2R5X3lhdyI6IkppdHRlciIsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsImhpZGRlbl9waXRjaCI6ZmFsc2UsImhpZGRlbl95YXciOmZhbHNlLCJqaXR0ZXJfbW9kZSI6IkRlZmF1bHQiLCJtYXhpbXVtX3lhdyI6MC4wLCJtaW5pbXVtX3lhdyI6MC4wLCJvdmVycmlkZSI6dHJ1ZSwicmFuZG9taXphdGlvbiI6ZmFsc2UsInN0ZXBfc2l6ZSI6MTUuMCwieWF3IjowLjAsInlhd19zZXBlcmF0aW9uIjoxOC4wLCJ5YXdfc3BpbiI6ZmFsc2UsInlhd193YXJwIjowLjAsIn5ib2R5X3lhdyI6eyJkZWxheV90eXBlIjoiRGVmYXVsdCIsImhvbGRfdGlja3MiOjAuMCwiaml0dGVyX3NwZWVkIjo5LjAsIm1heF9zcGVlZCI6OC4wLCJtaW5fc3BlZWQiOjEuMCwicmFuZG9taXphdGlvbiI6MC4wfSwifmhpZGRlbl9waXRjaCI6eyJjdXN0b20iOjAuMCwibWF4X2Ftb3VudCI6MzUuMCwibWluX2Ftb3VudCI6LTM1LjAsInNlbGVjdF90eXBlIjoiT2ZmIiwic3dheV9tYXgiOjYwLjAsInN3YXlfbWluIjotNjAuMCwic3dheV9zcGVlZCI6My4wfSwifmhpZGRlbl95YXciOnsiYW1vdW50IjowLjAsImRlbGF5IjoxLjAsImRpc3RvcnRpb25fZnJlcXVlbmN5IjoyNS4wLCJkaXN0b3J0aW9uX3JhbmdlIjo5MC4wLCJkaXN0b3J0aW9uX3N0ZXAiOjUuMCwibGVmdF92YWx1ZSI6LTEyMC4wLCJtYXhfYW1vdW50IjozNS4wLCJtaW5fYW1vdW50IjotMzUuMCwicmlnaHRfdmFsdWUiOjEyMC4wLCJzZWxlY3RfdHlwZSI6IlN0YXRpYyIsInNwZWVkIjoxMC4wfSwifnJhbmRvbWl6YXRpb24iOnsicmFuZG9taXphdGlvbl92YWx1ZSI6MC4wfSwifnlhd19zcGluIjp7InNtb290aCI6ZmFsc2UsInNwZWVkIjoyMC4wfX0seyJhbm9tYWx5X3lhdyI6ZmFsc2UsImJvZHlfeWF3IjoiSml0dGVyIiwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJoaWRkZW5fcGl0Y2giOmZhbHNlLCJoaWRkZW5feWF3IjpmYWxzZSwiaml0dGVyX21vZGUiOiJEZWZhdWx0IiwibWF4aW11bV95YXciOjAuMCwibWluaW11bV95YXciOjAuMCwib3ZlcnJpZGUiOnRydWUsInJhbmRvbWl6YXRpb24iOmZhbHNlLCJzdGVwX3NpemUiOjE1LjAsInlhdyI6My4wLCJ5YXdfc2VwZXJhdGlvbiI6LTI5LjAsInlhd19zcGluIjpmYWxzZSwieWF3X3dhcnAiOi02LjAsIn5ib2R5X3lhdyI6eyJkZWxheV90eXBlIjoiRGVmYXVsdCIsImhvbGRfdGlja3MiOjAuMCwiaml0dGVyX3NwZWVkIjo1LjAsIm1heF9zcGVlZCI6OC4wLCJtaW5fc3BlZWQiOjEuMCwicmFuZG9taXphdGlvbiI6MC4wfSwifmhpZGRlbl9waXRjaCI6eyJjdXN0b20iOi04OS4wLCJtYXhfYW1vdW50IjozNS4wLCJtaW5fYW1vdW50IjotMzUuMCwic2VsZWN0X3R5cGUiOiJPZmYiLCJzd2F5X21heCI6NjAuMCwic3dheV9taW4iOi02MC4wLCJzd2F5X3NwZWVkIjozLjB9LCJ+aGlkZGVuX3lhdyI6eyJhbW91bnQiOjAuMCwiZGVsYXkiOjEzLjAsImRpc3RvcnRpb25fZnJlcXVlbmN5IjoyNS4wLCJkaXN0b3J0aW9uX3JhbmdlIjo5MC4wLCJkaXN0b3J0aW9uX3N0ZXAiOjUuMCwibGVmdF92YWx1ZSI6LTEzNS4wLCJtYXhfYW1vdW50IjozNS4wLCJtaW5fYW1vdW50IjotMzUuMCwicmlnaHRfdmFsdWUiOjcxLjAsInNlbGVjdF90eXBlIjoiSml0dGVyIiwic3BlZWQiOjEwLjB9LCJ+cmFuZG9taXphdGlvbiI6eyJyYW5kb21pemF0aW9uX3ZhbHVlIjowLjB9LCJ+eWF3X3NwaW4iOnsic21vb3RoIjpmYWxzZSwic3BlZWQiOjIwLjB9fSx7ImFub21hbHlfeWF3IjpmYWxzZSwiYm9keV95YXciOiJKaXR0ZXIiLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlLCJoaWRkZW5fcGl0Y2giOmZhbHNlLCJoaWRkZW5feWF3IjpmYWxzZSwiaml0dGVyX21vZGUiOiJEZWZhdWx0IiwibWF4aW11bV95YXciOjAuMCwibWluaW11bV95YXciOjAuMCwib3ZlcnJpZGUiOnRydWUsInJhbmRvbWl6YXRpb24iOmZhbHNlLCJzdGVwX3NpemUiOjE1LjAsInlhdyI6MC4wLCJ5YXdfc2VwZXJhdGlvbiI6MC4wLCJ5YXdfc3BpbiI6ZmFsc2UsInlhd193YXJwIjowLjAsIn5ib2R5X3lhdyI6eyJkZWxheV90eXBlIjoiRGVmYXVsdCIsImhvbGRfdGlja3MiOjUwLjAsImppdHRlcl9zcGVlZCI6Ny4wLCJtYXhfc3BlZWQiOjIwLjAsIm1pbl9zcGVlZCI6MjAuMCwicmFuZG9taXphdGlvbiI6MTAuMH0sIn5oaWRkZW5fcGl0Y2giOnsiY3VzdG9tIjowLjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJzZWxlY3RfdHlwZSI6Ik9mZiIsInN3YXlfbWF4Ijo2MC4wLCJzd2F5X21pbiI6LTYwLjAsInN3YXlfc3BlZWQiOjMuMH0sIn5oaWRkZW5feWF3Ijp7ImFtb3VudCI6MC4wLCJkZWxheSI6MS4wLCJkaXN0b3J0aW9uX2ZyZXF1ZW5jeSI6MjUuMCwiZGlzdG9ydGlvbl9yYW5nZSI6OTAuMCwiZGlzdG9ydGlvbl9zdGVwIjo1LjAsImxlZnRfdmFsdWUiOi0xMjAuMCwibWF4X2Ftb3VudCI6MzUuMCwibWluX2Ftb3VudCI6LTM1LjAsInJpZ2h0X3ZhbHVlIjoxMjAuMCwic2VsZWN0X3R5cGUiOiJTdGF0aWMiLCJzcGVlZCI6MTAuMH0sIn5yYW5kb21pemF0aW9uIjp7InJhbmRvbWl6YXRpb25fdmFsdWUiOjAuMH0sIn55YXdfc3BpbiI6eyJzbW9vdGgiOnRydWUsInNwZWVkIjozOS4wfX0seyJhbm9tYWx5X3lhdyI6ZmFsc2UsImJvZHlfeWF3IjoiU3RhdGljIiwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwiaGlkZGVuX3BpdGNoIjpmYWxzZSwiaGlkZGVuX3lhdyI6ZmFsc2UsImppdHRlcl9tb2RlIjoiRGVmYXVsdCIsIm1heGltdW1feWF3IjowLjAsIm1pbmltdW1feWF3IjowLjAsIm92ZXJyaWRlIjp0cnVlLCJyYW5kb21pemF0aW9uIjpmYWxzZSwic3RlcF9zaXplIjoxNS4wLCJ5YXciOi0xLjAsInlhd19zZXBlcmF0aW9uIjoxLjAsInlhd19zcGluIjpmYWxzZSwieWF3X3dhcnAiOi0xLjAsIn5ib2R5X3lhdyI6eyJkZWxheV90eXBlIjoiRGVmYXVsdCIsImhvbGRfdGlja3MiOjAuMCwiaml0dGVyX3NwZWVkIjoxLjAsIm1heF9zcGVlZCI6OC4wLCJtaW5fc3BlZWQiOjEuMCwicmFuZG9taXphdGlvbiI6MC4wfSwifmhpZGRlbl9waXRjaCI6eyJjdXN0b20iOjYwLjAsIm1heF9hbW91bnQiOjM1LjAsIm1pbl9hbW91bnQiOi0zNS4wLCJzZWxlY3RfdHlwZSI6IkRvd24iLCJzd2F5X21heCI6NTAuMCwic3dheV9taW4iOjg5LjAsInN3YXlfc3BlZWQiOjEuMH0sIn5oaWRkZW5feWF3Ijp7ImFtb3VudCI6MC4wLCJkZWxheSI6MjAuMCwiZGlzdG9ydGlvbl9mcmVxdWVuY3kiOjEwMC4wLCJkaXN0b3J0aW9uX3JhbmdlIjoyNS4wLCJkaXN0b3J0aW9uX3N0ZXAiOjMwLjAsImxlZnRfdmFsdWUiOi04MC4wLCJtYXhfYW1vdW50IjozNS4wLCJtaW5fYW1vdW50IjotMzUuMCwicmlnaHRfdmFsdWUiOjgyLjAsInNlbGVjdF90eXBlIjoiSml0dGVyIiwic3BlZWQiOjEwLjB9LCJ+cmFuZG9taXphdGlvbiI6eyJyYW5kb21pemF0aW9uX3ZhbHVlIjoxLjB9LCJ+eWF3X3NwaW4iOnsic21vb3RoIjp0cnVlLCJzcGVlZCI6MS4wfX1dLCJjdXJyZW50X3N0YXRlIjoiQWlyIENyb3VjaCIsImN1c3RvbV9waGFzZV9vZmZzZXRzIjp7InBoYXNlXzEiOjI1LjAsInBoYXNlXzIiOi0xNS4wLCJwaGFzZV8zIjo0MC4wLCJwaGFzZV80IjotMzUuMCwicGhhc2VfNSI6MC4wfSwiZnJlZXN0YW5kaW5nIjpmYWxzZSwiaGVpZ2h0X2RpZmZlcmVuY2UiOjEyMC4wLCJtYW51YWxfeWF3IjoiRGlzYWJsZWQiLCJzYWZlX2hlYWRfdHJpZ2dlcnMiOlsiS25pZmUiLCJUYXNlciIsIn4iXSwic2VjdGlvbiI6MS4wLCJ0d2Vha3MiOlsiV2FybXVwIEFBIiwiU2FmZS1IZWFkIiwifiJdLCJ+YW50aV9icnV0ZWZvcmNlIjp7ImN1c3RvbV9vZmZzZXRzIjp0cnVlLCJkZXRlY3Rpb25fY29vbGRvd24iOjEuMCwiZGV0ZWN0aW9uX3JhbmdlIjoxNTAuMH0sIn5mcmVlc3RhbmRpbmciOnsiYm9keV9mcmVlc3RhbmRpbmciOmZhbHNlLCJkaXNhYmxlX3lhd19tb2RpZmllcnMiOmZhbHNlfX0sIm90aGVyIjp7Im1pc2MiOnsiaW5fZ2FtZSI6eyJjbGFudGFnIjp0cnVlLCJwaW5nX3VubG9ja2VyIjpmYWxzZSwidHJhc2h0YWxrIjp0cnVlLCJ+cGluZ191bmxvY2tlciI6eyJwaW5nX2Ftb3VudCI6MTcwLjB9fSwibW92ZW1lbnQiOnsiZmFzdF9sYWRkZXIiOnRydWUsIm5vX2ZhbGxfZGFtYWdlIjp0cnVlLCJzdXBlcl90b3NzIjp0cnVlfSwic2VjdGlvbiI6Mi4wLCJ2aWV3Ijp7ImFzcGVjdF9yYXRpbyI6dHJ1ZSwidmlld21vZGVsIjp0cnVlLCJ+YXNwZWN0X3JhdGlvIjp7InJhdGlvX2Ftb3VudCI6MTYwLjB9LCJ+dmlld21vZGVsIjp7InZpZXdtb2RlbF9mb3YiOjY4MDAuMCwidmlld21vZGVsX3giOjI1MC4wLCJ2aWV3bW9kZWxfeSI6MC4wLCJ2aWV3bW9kZWxfeiI6LTE1MC4wfX19LCJ2aXN1YWxzIjp7ImFpbWJvdF9sb2dzIjp0cnVlLCJjZW50ZXJlZF9pbmRpY2F0b3JzIjpmYWxzZSwiZGFtYWdlX2luZGljYXRvciI6dHJ1ZSwiZmVhdHVyZV9pbmRpY2F0b3JzIjp0cnVlLCJxdWlja19rbmlmZV9zd2l0Y2giOmZhbHNlLCJ3YXRlcm1hcmsiOnsiYWNjZW50X2NvbG9yIjoiIzdDQzExNUZGIiwiYmFja2dyb3VuZF9jb2xvciI6IiMxMTExMTFBQSIsInJhaW5ib3ciOmZhbHNlLCJyYWluYm93X2JyaWdodG5lc3MiOjEwMC4wLCJyYWluYm93X3NhdHVyYXRpb24iOjEwMC4wLCJyYWluYm93X3NwZWVkIjo0MC4wLCJzdHlsZSI6IkdyYWRpZW50In0sIn5haW1ib3RfbG9ncyI6eyJldmVudF9zdHlsZSI6IlJlbmRlciIsImhpdF9jb2xvciI6IiM3Q0MzMERGRiIsIm1heF9sb2dzIjo1LjAsIm1pc3NfY29sb3IiOiIjRkYzMjMyRkYiLCJvdXRwdXQiOlsiQ29uc29sZSIsIkV2ZW50IiwifiJdLCJ0aW1lIjozLjB9LCJ+Y2VudGVyZWRfaW5kaWNhdG9ycyI6eyJjZW50ZXJlZF9pbmRpY2F0b3JzX2NvbG9yIjoiI0ZGNjRGRkZGIiwib2Zmc2V0IjowLjB9LCJ+ZGFtYWdlX2luZGljYXRvciI6eyJvbmx5X3doZW5fb3ZlcnJpZGVkIjp0cnVlLCJzZWxlY3RfZm9udCI6IlZlcmRhbmEifSwifmZlYXR1cmVfaW5kaWNhdG9ycyI6eyJlbmFibGVkX2luZGljYXRvcnMiOlsiRFQiLCJIUyIsIkRVQ0siLCJTUCIsIkJPRFkiLCJNRCIsIkZTIiwiQk9NQiIsIn4iXX19fX1d";
v721 = l_base64_0.encode;
local l_decode_0 = l_base64_0.decode;
local l_stringify_0 = l_json_0.stringify;
local l_parse_0 = l_json_0.parse;
local l_insert_0 = table.insert;
local l_remove_0 = table.remove;
local function v828()
    cvar.play:call("ambient\\tones\\elev1");
end;
do
    local l_v476_3, l_v721_1, l_l_decode_0_0, l_l_stringify_0_0, l_l_parse_0_0, l_l_insert_0_0, l_l_remove_0_0, l_v828_0 = v476, v721, l_decode_0, l_stringify_0, l_parse_0, l_insert_0, l_remove_0, v828;
    v475.create_config = function(v837)
        -- upvalues: l_l_insert_0_0 (ref)
        for v838, v839 in ipairs(configdata.cfg_list) do
            if v839[1] == v837 then
                return v838;
            end;
        end;
        local v840 = #configdata.cfg_list + 1;
        l_l_insert_0_0(configdata.cfg_list, {
            [1] = nil, 
            [2] = "", 
            [1] = v837
        });
        l_l_insert_0_0(configdata.menu_list, v837);
        db.gangsta_code_here = configdata;
        return v840;
    end;
    v475.save_config = function(v841)
        -- upvalues: l_v476_3 (ref), l_v721_1 (ref), l_l_stringify_0_0 (ref), l_v828_0 (ref)
        if v841 == 1 then
            return;
        else
            local v842 = l_v476_3:save();
            configdata.cfg_list[v841][2] = l_v721_1(l_l_stringify_0_0(v842));
            l_v828_0();
            db.gangsta_code_here = configdata;
            return;
        end;
    end;
    v475.update_values = function(v843)
        local v844 = configdata.cfg_list[v843][1];
        for v845, v846 in ipairs(configdata.cfg_list) do
            configdata.menu_list[v845] = v846[1];
        end;
        configdata.menu_list[v843] = v844 .. "\a{Link Active}  [Loaded]";
    end;
    v475.remove_config = function(v847)
        -- upvalues: l_l_remove_0_0 (ref)
        if v847 == 1 then
            return;
        else
            l_l_remove_0_0(configdata.cfg_list, v847);
            l_l_remove_0_0(configdata.menu_list, v847);
            db.gangsta_code_here = configdata;
            return;
        end;
    end;
    v475.load_config = function(v848)
        -- upvalues: l_v476_3 (ref), l_l_parse_0_0 (ref), l_l_decode_0_0 (ref), l_v828_0 (ref)
        local v849 = configdata.cfg_list[v848][2];
        if not v849 or v849 == "" or #configdata.cfg_list < v848 then
            print("Error[data_base[" .. v848 .. "]]");
            return;
        else
            l_v476_3:load(l_l_parse_0_0(l_l_decode_0_0(v849)));
            l_v828_0();
            return;
        end;
    end;
    configs = {
        cfg_selector = v24.home.configs:list("", configdata.menu_list), 
        name = v24.home.configs:input("\v\f<file-pen>\r" .. "  Config name"), 
        load = v24.home.configs:button("\v\f<upload>\r  Load", function()
            -- upvalues: v475 (ref)
            local v850 = configs.cfg_selector:get();
            v475.update_values(v850);
            v475.load_config(v850);
            configs.cfg_selector:update(configdata.menu_list);
        end, true), 
        save = v24.home.configs:button("\v\f<floppy-disk>\r  Save", function()
            -- upvalues: v475 (ref)
            local v851 = configs.cfg_selector:get();
            local v852 = configs.name:get();
            if v851 == 1 and v852 and v852 ~= "" and v852 ~= " " then
                v851 = v475.create_config(v852);
                configs.cfg_selector:set(v851);
                configs.cfg_selector:update(configdata.menu_list);
            elseif v852 and v852 ~= "" and v852 ~= " " then
                local v853 = false;
                for v854, v855 in ipairs(configdata.cfg_list) do
                    if v855[1] == v852 then
                        v853 = true;
                        v851 = v854;
                        configs.cfg_selector:set(v851);
                        break;
                    end;
                end;
                if not v853 then
                    v851 = v475.create_config(v852);
                    configs.cfg_selector:set(v851);
                    configs.cfg_selector:update(configdata.menu_list);
                end;
            end;
            v475.save_config(v851);
        end, true), 
        import = v24.home.configs:button("\v\f<file-import>\aDEFAULT  Import", function()
            -- upvalues: l_v476_3 (ref), l_l_parse_0_0 (ref), l_l_decode_0_0 (ref), l_clipboard_0 (ref), l_v828_0 (ref)
            l_v476_3:load(l_l_parse_0_0(l_l_decode_0_0(l_clipboard_0.get())));
            l_v828_0();
        end, true), 
        export = v24.home.configs:button("\v\f<file-export>\aDEFAULT  Export", function()
            -- upvalues: l_clipboard_0 (ref), l_v721_1 (ref), l_l_stringify_0_0 (ref), l_v476_3 (ref), l_v828_0 (ref)
            l_clipboard_0.set(l_v721_1(l_l_stringify_0_0(l_v476_3:save())));
            l_v828_0();
        end, true), 
        remove = v24.home.configs:button("\aFF0000FF\f<trash-xmark>\aDEFAULT  Remove", function()
            -- upvalues: v475 (ref)
            v475.remove_config(configs.cfg_selector:get());
            configs.cfg_selector:update(configdata.menu_list);
        end, true)
    };
    configs.import:tooltip("\226\128\162 Import config from clipboard.");
    configs.export:tooltip("\226\128\162 Export config to clipboard.");
end;
v344.notifications.initialize();
v344.aimbot_logs.initialize();
v459.trashtalk.initialize();
v459.clantag.initialize();
v459.fast_ladder.initialize();
v459.no_fall_damage.initialize();
v459.super_toss.initialize();
v459.nade_dropper.initialize();
events.render:set(function()
    -- upvalues: v42 (ref), v344 (ref), v459 (ref)
    local l_player_data_0 = v42.data.player_data;
    v42.data.player_data.update(l_player_data_0);
    v42.data.anti_aim_data.update_values();
    v344.watermark.update();
    v344.aimbot_logs.update();
    v344.aimbot_logs.render();
    v459.viewmodel.update();
    v459.ping_unlocker.update();
    v459.cvars_optimalisation.update();
    v344.centered_indicators.render();
    v344.damage_indicator.render();
    v344.nades_radius.render();
    v344.feature_indicators.render();
    v344.custom_scope.render();
    v344.notifications.think(render.screen_size(), "thin");
    v344.watermark.render();
end);
events.createmove:set(function(v857)
    -- upvalues: v42 (ref)
    v42.create_move.run(v857);
end);
v42.create_move.quick_knife_switch();
events.round_start:set(function()
    -- upvalues: v42 (ref)
    v42.data.anti_aim_data.reset_values();
end);
events.shutdown:set(function()
    -- upvalues: v459 (ref), v23 (ref)
    cvar.r_aspectratio:float(v459.aspect_ratio.original_aspect_ratio);
    cvar.viewmodel_fov:float(v459.viewmodel.original_values.fov);
    cvar.viewmodel_offset_x:float(v459.viewmodel.original_values.x);
    cvar.viewmodel_offset_y:float(v459.viewmodel.original_values.y);
    cvar.viewmodel_offset_z:float(v459.viewmodel.original_values.z);
    v23.fake_latency:set(0);
    common.set_clan_tag("");
end);