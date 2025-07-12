local v0 = nil;
v0 = {
    enableaanl = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
    disable = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
    base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
    yawoffset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
    backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"), 
    hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
    modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
    modoffset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"), 
    bodyyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
    inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
    leftlimit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
    rightlimit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
    options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
    bodyyawfs = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"), 
    extended = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"), 
    extendedpitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"), 
    extendedroll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll"), 
    fs = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
    fss = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"), 
    fsb = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"), 
    fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
    sw = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
    leg = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"), 
    pa = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"), 
    dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
    hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
    hslag = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
    dtlag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
    scope = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"), 
    fov = ui.find("Visuals", "World", "Main", "Field of View"), 
    weaponact = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"), 
    spike = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"), 
    bodyaim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
    safe_points = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"), 
    dormant = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
    min_damage_ui = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
    dmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
    clantag = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag"), 
    ragebot_find = ui.find("Aimbot", "Ragebot", "Main"), 
    hc_find = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"), 
    fl_limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"), 
    fl_random = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability")
};
local l_ffi_0 = require("ffi");
l_ffi_0.cdef("    typedef struct {\n        char pad[0x8];\n        bool in_duck;\n    } CCSPlayer_MovementServices;\n    typedef struct {\n        char pad[0x28];\n        float m_flDuckAmount;\n        float m_flDuckSpeed;\n    } CCSGOPlayerAnimState;\n    \n    typedef void*(__thiscall* get_client_entity_t)(void*, int);\n    typedef struct {\n        char  pad_0000[20];\n        int m_nOrder;\n        int m_nSequence;\n        float m_flPrevCycle;\n        float m_flWeight;\n        float m_flWeightDeltaRate;\n        float m_flPlaybackRate;\n        float m_flCycle;\n        void *m_pOwner;\n        char  pad_0038[4];\n    } animstate_layer_t;\n");
local _ = l_ffi_0.typeof("uintptr_t**");
local v3 = utils.get_vfunc("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)");
local v4 = nil;
local l_pui_0 = require("neverlose/pui");
local _ = require("neverlose/base64");
local l_clipboard_0 = require("neverlose/clipboard");
local _ = require("neverlose/smoothy");
local _ = require("neverlose/inspect");
local _ = require("neverlose/base64");
local l_system_0 = require("neverlose/drag_system");
local l_gradient_0 = require("neverlose/gradient");
local v13 = {
    vscript = "Debug", 
    ZWS = "\226\128\138", 
    screen_size = render.screen_size(), 
    username = common.get_username(), 
    localplayer = entity.get_local_player(), 
    threat = entity.get_threat()
};
local function _()
    -- upvalues: l_ffi_0 (ref)
    if not globals.is_in_game then
        return;
    else
        local v14 = entity.get_local_player();
        if not v14 then
            return nil;
        else
            return {
                player = v14, 
                animstate = l_ffi_0.cast("CCSGOPlayerAnimState**", v14 + 14592)[0], 
                movementServices = l_ffi_0.cast("CCSPlayer_MovementServices*", v14 + 8480)
            };
        end;
    end;
end;
local v16 = {
    global = {}, 
    antiaim = {}, 
    renders = {}, 
    global = l_pui_0.create("\f<block-quote>", {
        [1] = {
            [1] = "main1", 
            [2] = "Main", 
            [3] = 1
        }, 
        [2] = {
            [1] = "main2", 
            [2] = "Venture", 
            [3] = 2
        }, 
        [3] = {
            [1] = "main3", 
            [2] = "\n\n\n\n", 
            [3] = 1
        }, 
        [4] = {
            [1] = "main4", 
            [2] = "\n\n\n", 
            [3] = 2
        }, 
        [5] = {
            [1] = "cfgdb", 
            [2] = "Configuration Handlers", 
            [3] = 2
        }, 
        [6] = {
            [1] = "main5", 
            [2] = "\n\n", 
            [3] = 1
        }, 
        [7] = {
            [1] = "main6", 
            [2] = "\n", 
            [3] = 2
        }
    }), 
    antiaim = l_pui_0.create("\f<hands-asl-interpreting>", {
        [1] = {
            [1] = "main1", 
            [2] = "Main", 
            [3] = 1
        }, 
        [2] = {
            [1] = "main2", 
            [2] = "Builder", 
            [3] = 2
        }, 
        [3] = {
            [1] = "main3", 
            [2] = "\n\n\n\n", 
            [3] = 1
        }, 
        [4] = {
            [1] = "main4", 
            [2] = "\n\n\n", 
            [3] = 2
        }, 
        [5] = {
            [1] = "main5", 
            [2] = "\n\n", 
            [3] = 1
        }, 
        [6] = {
            [1] = "main6", 
            [2] = "\n", 
            [3] = 2
        }
    })
};
local v17 = {
    [1] = "Standing", 
    [2] = "Running", 
    [3] = "Slowmotion", 
    [4] = "Crouch", 
    [5] = "Sneaking", 
    [6] = "Jumping", 
    [7] = "Air Crouch"
};
local v18 = {
    [1] = "\aFFF700FF\226\128\162    \aDEFAULTTerrorist", 
    [2] = "\aFF0000FF\226\128\162    \aDEFAULTCounter-Terrorist"
};
local v19 = {
    global = {}, 
    vis = {}, 
    mods = {}, 
    aa = {}
};
v19.global.active = v16.global.main2:list("", "\aF7FF03FF\226\128\162\aDEFAULT     Presets", "\a6AFF03FF\226\128\162\aDEFAULT     Renders", "\aFF4429FF\226\128\162\aDEFAULT     Other");
v19.vis.watermark = v16.global.main1:label("\v\226\128\162\r" .. string.rep(v13.ZWS, 4) .. "Watermark", function(v20)
    -- upvalues: v13 (ref)
    items = {};
    items.style = v20:list("", "Sense", "\f<stars>  Venture");
    items.custom_name = v20:input("", "\f<stars>  Venture", "- Secret Feature");
    items.acc_col = v20:color_picker("\f<palette>   Accent", color(104, 132, 255, 255));
    items.second_col = v20:color_picker("Tag", color(235, 97, 97, 255));
    items.anim_col = v20:color_picker("Anim", color());
    items.drag_pos_x = v20:slider("X Position", 0, v13.screen_size.x, 1800);
    items.drag_pos_y = v20:slider("Y Position", 0, v13.screen_size.y, 500);
    items.toggle = v20:switch("Remove from Screen", false, "- Secret Feature");
    return items;
end):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v19.global.active
});
v19.vis.watermark.custom_name:disabled(true);
v19.vis.watermark.toggle:disabled(true);
v19.vis.watermark.second_col:depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v19.vis.watermark.style
});
v19.vis.notificaiton_style = v16.global.main1:combo("\v\226\128\162\r" .. string.rep(v13.ZWS, 4) .. "Notifications", {
    [1] = "Disabled", 
    [2] = "Modern", 
    [3] = "Sense"
}, function(v21)
    -- upvalues: v13 (ref)
    items = {};
    items.font = v21:list("", "Segoe Ui", "Pixel", "Default");
    items.spacing = v21:slider("\v\f<minus>" .. string.rep(v13.ZWS, 5) .. "\rSize", 8, 25, 10, 1, "px");
    items.rounding = v21:slider("\v\f<minus>" .. string.rep(v13.ZWS, 5) .. "\rRounding", 5, 15, 7, 1);
    items.y_padding = v21:slider("\v\f<plus-minus>" .. string.rep(v13.ZWS, 6) .. "\rPadding", -200, 200, 0, 1);
    items.shadow_thick = v21:slider("\v\f<projector>" .. string.rep(v13.ZWS, 3) .. "\rGlow", 0, 100, 35, 1);
    items.max_notifies = v21:slider("\v\f<window-maximize>" .. string.rep(v13.ZWS, 5) .. "\rScreen Max", 1, 10, 3, 1);
    items.spam_test = v21:switch("\v\f<sparkles>" .. string.rep(v13.ZWS, 5) .. "\rTest Spam", false);
    items.gap = v21:label("\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128");
    items.warning = v21:color_picker("Warning", color(255, 140, 0, 255));
    items.success = v21:color_picker("Success", color(0, 200, 0, 255));
    items.error = v21:color_picker("Error", color(255, 50, 50, 255));
    return items;
end):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v19.global.active
});
v19.vis.notificaiton_style.font:depend({
    [1] = nil, 
    [2] = "Modern", 
    [3] = "Sense", 
    [1] = v19.vis.notificaiton_style
});
v19.vis.notificaiton_style.spacing:depend({
    [1] = nil, 
    [2] = "Modern", 
    [3] = "Sense", 
    [1] = v19.vis.notificaiton_style
});
v19.vis.notificaiton_style.rounding:depend({
    [1] = nil, 
    [2] = "Modern", 
    [3] = "Sense", 
    [1] = v19.vis.notificaiton_style
});
v19.vis.notificaiton_style.y_padding:depend({
    [1] = nil, 
    [2] = "Modern", 
    [3] = "Sense", 
    [1] = v19.vis.notificaiton_style
});
v19.vis.notificaiton_style.shadow_thick:depend({
    [1] = nil, 
    [2] = "Modern", 
    [3] = "Sense", 
    [1] = v19.vis.notificaiton_style
});
v19.vis.notificaiton_style.max_notifies:depend({
    [1] = nil, 
    [2] = "Modern", 
    [3] = "Sense", 
    [1] = v19.vis.notificaiton_style
});
v19.vis.notificaiton_style.spam_test:depend({
    [1] = nil, 
    [2] = "Modern", 
    [3] = "Sense", 
    [1] = v19.vis.notificaiton_style
});
v19.vis.notificaiton_style.gap:depend({
    [1] = nil, 
    [2] = "Modern", 
    [3] = "Sense", 
    [1] = v19.vis.notificaiton_style
});
v19.vis.notificaiton_style.warning:depend({
    [1] = nil, 
    [2] = "Modern", 
    [3] = "Sense", 
    [1] = v19.vis.notificaiton_style
});
v19.vis.notificaiton_style.success:depend({
    [1] = nil, 
    [2] = "Modern", 
    [3] = "Sense", 
    [1] = v19.vis.notificaiton_style
});
v19.vis.notificaiton_style.error:depend({
    [1] = nil, 
    [2] = "Modern", 
    [3] = "Sense", 
    [1] = v19.vis.notificaiton_style
});
v19.vis.crosshair_ind = v16.global.main1:switch("\v\226\128\162\r" .. string.rep(v13.ZWS, 4) .. "Center Indicators", false, function(v22)
    -- upvalues: v13 (ref)
    items = {};
    items.ind_select = v22:list("", "Standard", "Alternative");
    items.text_select = v22:combo("\v\f<sidebar>" .. string.rep(v13.ZWS, 5) .. "\rStyle", "Venture", "Standard");
    items.gap_add = v22:slider("\v\f<plus-minus>" .. string.rep(v13.ZWS, 5) .. "\rSpace", 1, 5, 1);
    items.bind_add = v22:selectable("\v\f<keyboard-down>" .. string.rep(v13.ZWS, 5) .. "\rKeybinds", "DT", "DMG");
    items.gap = v22:label("\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128");
    items.accent_col = v22:color_picker("Accent", color(182, 192, 228, 255));
    items.bind_col = v22:color_picker("Bind", color(214, 189, 222, 255));
    return items, true;
end):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v19.global.active
});
v19.vis.aspect = v16.global.main3:switch("\v\226\128\162\r" .. string.rep(v13.ZWS, 4) .. "Aspect Ratio", false, function(v23)
    items = {
        slider = v23:slider("Proportion", 0, 200, 0, 0.01), 
        aspect_ratio_169 = v23:button(" 16:9  "), 
        aspect_ratio_1610 = v23:button("16:10 "), 
        aspect_ratio_32 = v23:button("   3:2  "), 
        aspect_ratio_43 = v23:button("  4:3   "), 
        aspect_ratio_54 = v23:button("  5:4   ")
    };
    return items, true;
end):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v19.global.active
});
v19.vis.viewmodel = v16.global.main3:switch("\v\226\128\162\r" .. string.rep(v13.ZWS, 4) .. "Viewmodel", false, function(v24)
    items = {};
    items.hand = v24:slider("Hand", 0, 1, 1, 1, function(v25)
        if v25 == 0 then
            return "Left";
        else
            return "Right";
        end;
    end);
    items.fov = v24:slider("Fov", 0, 1000, 680, 0.1);
    items.xoff = v24:slider("X", -100, 100, 25, 0.1);
    items.yoff = v24:slider("Y", -100, 100, 0, 0.1);
    items.zoff = v24:slider("Z", -100, 100, -15, 0.1);
    return items, true;
end):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v19.global.active
});
v19.vis.scope_overlay = v16.global.main3:switch("\v\226\128\162\r" .. string.rep(v13.ZWS, 4) .. "Scope Overlay", false, function(v26)
    items = {};
    items.inverted = v26:switch("Inverted", false);
    items.gap = v26:slider("Gap", 0, 500, 5);
    items.size = v26:slider("Size", 0, 500, 75);
    items.color = v26:color_picker("Color", color(255, 255, 255, 118));
    return items, true;
end):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v19.global.active
});
v19.vis.aimbot_logs = v16.global.main3:switch("\v\226\128\162\r" .. string.rep(v13.ZWS, 4) .. "Events Aimbot", false, function(v27)
    items = {};
    items.console = v27:switch("Console");
    items.notify = v27:switch("Notify");
    return items, true;
end):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v19.global.active
});
v19.vis.skeet_indicators = v16.global.main4:switch("\v\226\128\162\r" .. string.rep(v13.ZWS, 4) .. "500$ Indicators", false, function(v28)
    items = {};
    items.indicators_sel = v28:selectable("500$ Indicators:", {
        [1] = "Double Tap", 
        [2] = "Hideshots", 
        [3] = "Minimum Damage", 
        [4] = "Body Aim", 
        [5] = "Hitchance", 
        [6] = "Dormant Aimbot", 
        [7] = "Safepoint", 
        [8] = "Freestanding", 
        [9] = "Fake Duck", 
        [10] = "Ping"
    }, 0);
    items.padding = v28:slider("Padding", -200, 200, 0);
    return items, true;
end):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v19.global.active
});
v19.vis.damage_indicator = v16.global.main4:switch("\v\226\128\162\r" .. string.rep(v13.ZWS, 4) .. "Show DMG Override", false, function(v29)
    items = {};
    items.color = v29:color_picker("Color", color());
    items.font = v29:list("Select the font you wish to use", "Defualt", "Small", "Console", "Bold");
    return items, true;
end):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v19.global.active
});
v19.vis.optimize_cvars = v16.global.main4:switch("\v\226\128\162\r" .. string.rep(v13.ZWS, 4) .. "Optimize Cvars", false):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v19.global.active
});
v19.vis.enemy_lagcomp = v16.global.main4:switch("\v\226\128\162\r" .. string.rep(v13.ZWS, 4) .. "Visualize Exploits", false, function(v30)
    items = {};
    items.box_color = v30:switch("Box", false, color(47, 117, 221, 255));
    items.text_color = v30:switch("Text", false, color(255, 45, 45, 255));
    return items, true;
end):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v19.global.active
});
v19.mods.animation_allow = v16.global.main4:switch("\v\226\128\162\r" .. string.rep(v13.ZWS, 4) .. "Client-Side Animations", false):depend({
    [1] = nil, 
    [2] = 3, 
    [1] = v19.global.active
});
v19.mods.animation_select = v16.global.main4:combo(string.rep(v13.ZWS, 3) .. "\v\226\128\162\r" .. string.rep(v13.ZWS, 5) .. "\rAnimations", "States", "Mods"):depend({
    [1] = nil, 
    [2] = 3, 
    [1] = v19.global.active
}):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v19.mods.animation_allow
});
v19.mods.animation_run = v16.global.main4:slider(string.rep(v13.ZWS, 8) .. "\v\f<layer-group>\r" .. string.rep(v13.ZWS, 5) .. "Moving", 0, 2, 0, 1, function(v31)
    if v31 == 0 then
        return "Disabled";
    elseif v31 == 1 then
        return "Jitter";
    elseif v31 == 2 then
        return "Static";
    else
        return;
    end;
end, function(v32)
    -- upvalues: v13 (ref)
    items = {};
    items.custom = v32:slider(string.rep(v13.ZWS, 0) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 4) .. "Custom", 0, 100, 100, 1, function(v33)
        if v33 == 0 then
            return "Disabled";
        elseif v33 == 100 then
            return "Maximum";
        else
            return v33 .. "x";
        end;
    end);
    return items;
end):depend({
    [1] = nil, 
    [2] = 3, 
    [1] = v19.global.active
}):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v19.mods.animation_allow
}):depend({
    [1] = nil, 
    [2] = "States", 
    [1] = v19.mods.animation_select
});
v19.mods.animation_run.custom:depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v19.mods.animation_run
});
v19.mods.animation_air = v16.global.main4:slider(string.rep(v13.ZWS, 8) .. "\v\f<layer-group>\r" .. string.rep(v13.ZWS, 5) .. "Falling", 0, 2, 0, 1, function(v34)
    if v34 == 0 then
        return "Disabled";
    elseif v34 == 1 then
        return "Jitter";
    elseif v34 == 2 then
        return "Static";
    else
        return;
    end;
end, function(v35)
    -- upvalues: v13 (ref)
    items = {};
    items.custom = v35:slider(string.rep(v13.ZWS, 0) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 4) .. "Custom", 0, 100, 100, 1, function(v36)
        if v36 == 0 then
            return "Disabled";
        elseif v36 == 100 then
            return "Maximum";
        else
            return v36 .. "x";
        end;
    end);
    return items;
end):depend({
    [1] = nil, 
    [2] = 3, 
    [1] = v19.global.active
}):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v19.mods.animation_allow
}):depend({
    [1] = nil, 
    [2] = "States", 
    [1] = v19.mods.animation_select
});
v19.mods.animation_air.custom:depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v19.mods.animation_air
});
v19.mods.animation_lean = v16.global.main4:slider(string.rep(v13.ZWS, 8) .. "\v\f<layer-group>\r" .. string.rep(v13.ZWS, 5) .. "Leaning", 0, 100, 0, 1, function(v37)
    if v37 == 0 then
        return "Disabled";
    elseif v37 == 100 then
        return "Maximum";
    else
        return v37 .. "x";
    end;
end):depend({
    [1] = nil, 
    [2] = 3, 
    [1] = v19.global.active
}):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v19.mods.animation_allow
}):depend({
    [1] = nil, 
    [2] = "Mods", 
    [1] = v19.mods.animation_select
});
v19.mods.zero_pitch = v16.global.main4:slider(string.rep(v13.ZWS, 8) .. "\v\f<layer-group>\r" .. string.rep(v13.ZWS, 5) .. "Pitch Land", -1, 10, -1, 0.1, function(v38)
    if v38 == -1 then
        return "Off";
    else
        return v38 .. "x";
    end;
end):depend({
    [1] = nil, 
    [2] = 3, 
    [1] = v19.global.active
}):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v19.mods.animation_allow
}):depend({
    [1] = nil, 
    [2] = "Mods", 
    [1] = v19.mods.animation_select
});
v19.mods.animation_shake = v16.global.main4:slider(string.rep(v13.ZWS, 8) .. "\v\f<layer-group>\r" .. string.rep(v13.ZWS, 5) .. "Shake", 0, 2, 0, 1, function(v39)
    if v39 == 0 then
        return "Disabled";
    elseif v39 == 1 then
        return "Default";
    elseif v39 == 2 then
        return "Venture";
    else
        return;
    end;
end, function(v40)
    -- upvalues: v13 (ref)
    items = {};
    items.custom = v40:slider(string.rep(v13.ZWS, 0) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 4) .. "Custom", 0, 100, 0, 1, function(v41)
        if v41 == 0 then
            return "Disabled";
        elseif v41 == 100 then
            return "Maximum";
        else
            return v41 .. "x";
        end;
    end);
    items.min = v40:slider(string.rep(v13.ZWS, 0) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 4) .. "1", 0, 100, 20, 1, function(v42)
        if v42 == 0 then
            return "Disabled";
        elseif v42 == 100 then
            return "Maximum";
        else
            return v42 .. "x";
        end;
    end);
    items.max = v40:slider(string.rep(v13.ZWS, 0) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 4) .. "2", 1, 100, 100, 1, function(v43)
        if v43 == 0 then
            return "Disabled";
        elseif v43 == 100 then
            return "Maximum";
        else
            return v43 .. "x";
        end;
    end);
    return items;
end):depend({
    [1] = nil, 
    [2] = 3, 
    [1] = v19.global.active
}):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v19.mods.animation_allow
}):depend({
    [1] = nil, 
    [2] = "Mods", 
    [1] = v19.mods.animation_select
});
v19.mods.animation_shake.custom:depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v19.mods.animation_shake
});
v19.mods.animation_shake.min:depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v19.mods.animation_shake
});
v19.mods.animation_shake.max:depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v19.mods.animation_shake
});
v19.mods.fake_latency = v16.global.main1:switch("\v\f<signal-slash>\r" .. string.rep(v13.ZWS, 4) .. "Extended Fake Ping", false, function(v44)
    items = {};
    items.amount = v44:slider("Amount", 0, 200, 200);
    return items, true;
end):depend({
    [1] = nil, 
    [2] = 3, 
    [1] = v19.global.active
});
v19.mods.fake_latency.amount:depend({
    [1] = nil, 
    [2] = true, 
    [1] = v19.mods.fake_latency
});
v19.mods.fakeduck_speed = v16.global.main1:switch("\v\f<rabbit-running>\r" .. string.rep(v13.ZWS, 4) .. "Fakeduck Speed", false):depend({
    [1] = nil, 
    [2] = 3, 
    [1] = v19.global.active
});
v19.mods.fast_ladder = v16.global.main1:switch("\v\f<water-ladder>\r" .. string.rep(v13.ZWS, 5) .. "Fast Climbing", false):depend({
    [1] = nil, 
    [2] = 3, 
    [1] = v19.global.active
});
v19.mods.super_toss = v16.global.main1:switch("\v\f<hand>\r" .. string.rep(v13.ZWS, 5) .. "Nade Supertoss", false):depend({
    [1] = nil, 
    [2] = 3, 
    [1] = v19.global.active
});
v19.mods.auto_teleport = v16.global.main3:switch("\v\f<robot>\r" .. string.rep(v13.ZWS, 5) .. "Smart Exploit Charge", false):depend({
    [1] = nil, 
    [2] = 3, 
    [1] = v19.global.active
});
v19.mods.forcebaim = v16.global.main3:switch("\v\f<eye>\r" .. string.rep(v13.ZWS, 6) .. "Force Lethal Conditions", false, function(v45)
    items = {};
    items.select = v45:selectable("Weapons", "AWP", "SSG-08", "Auto");
    items.hp = v45:slider("Enemy", 0, 92, 75, 1, "hp");
    return items, true;
end):depend({
    [1] = nil, 
    [2] = 3, 
    [1] = v19.global.active
});
v19.aa.team = v16.antiaim.main1:list("", v18[1], v18[2]);
v19.aa.state = v16.antiaim.main1:combo("\v\f<minus>\r" .. string.rep(v13.ZWS, 5) .. "Anti-Aim State", v17);
v19.aa.state_info = v16.antiaim.main2:label("\v\226\128\162\r   " .. v19.aa.state:get());
v19.aa.team_info = v16.antiaim.main2:button("", nil, true);
v19.aa.force_defensive = v16.antiaim.main5:selectable("\v\226\128\162\r" .. string.rep(v13.ZWS, 4) .. "Force Break LC", v17);
v19.aa.hs_defensive = v16.antiaim.main5:combo("    \v\226\164\183\r" .. string.rep(v13.ZWS, 4) .. "Hide Shots  \v\f<bolt>", "Favor Fire Rate", "Favor Fake Lag", "Break LC");
v19.aa.safe_head = v16.antiaim.main3:switch("\v\f<face-head-bandage>  \rHead Behind Chest", false);
v19.aa.freestanding = v16.antiaim.main3:switch("\v\f<street-view>   \rFreestanding", false, function(v46)
    items = {
        block = v46:switch("Block Jitter")
    };
    return items;
end);
v19.aa.manuals = v16.antiaim.main3:combo("\v\f<person-rays>   \rManual Yaw", {
    [1] = "Disabled", 
    [2] = "Left", 
    [3] = "Right"
}, function(v47)
    items = {
        block = v47:switch("Block Jitter")
    };
    return items;
end);
v19.aa.addons = v16.antiaim.main3:selectable("\v\f<plus-large>   \rAddons", {
    [1] = "bWarmupPeriod Antiaim"
});
local function v48()
    -- upvalues: v19 (ref)
    if v19.aa.team:get() == 1 then
        v19.aa.state_info:name("\v\226\128\162\r   " .. v19.aa.state:get());
        v19.aa.team_info:name("   \aFFF700FFT   ");
    else
        v19.aa.team_info:name("  \aFF0000FFCT  ");
        v19.aa.state_info:name("\v\226\128\162\r   " .. v19.aa.state:get());
    end;
end;
v19.aa.team:set_callback(v48);
v19.aa.state:set_callback(v48);
v48();
v19.aa.builder = {};
local _ = function(v49)
    local v50 = {};
    for v51, _ in pairs(v49) do
        table.insert(v50, v51);
    end;
    return v50;
end;
local function v70(v54, v55)
    -- upvalues: v19 (ref), v18 (ref)
    local v56 = v54 == 1 and 2 or 1;
    local v57 = v19.aa.builder[v54][v55];
    local v58 = v19.aa.builder[v56][v55];
    if not v57 or not v58 then
        print("Error: Source or target state not found");
        return;
    else
        local v59 = 0;
        local function v60(v61, v62)
            -- upvalues: v59 (ref), v60 (ref)
            for v63, v64 in pairs(v61) do
                if v63 ~= "send_team" and v63 ~= "reset_state" then
                    local v65 = v62[v63];
                    if v65 and type(v64) == "table" and type(v65) == "table" then
                        if v64.get and v64.set and v65.set then
                            local l_status_0, l_result_0 = pcall(v64.get, v64);
                            if l_status_0 and pcall(v65.set, v65, l_result_0) then
                                v59 = v59 + 1;
                                print("Copied:", v63, "=", l_result_0);
                            end;
                        else
                            v60(v64, v65);
                        end;
                    end;
                end;
            end;
        end;
        v60(v57, v58);
        local v68 = v18[v54]:match("([^\226\128\162]+)$"):gsub("^%s+", "");
        local v69 = v18[v56]:match("([^\226\128\162]+)$"):gsub("^%s+", "");
        print(string.format("Copied %d settings from %s to %s for state: %s", v59, v68, v69, v55));
        return;
    end;
end;
local function v85(v71, v72)
    -- upvalues: v19 (ref)
    print("Debug: Resetting team", v71, "state:", v72);
    local v73 = v19.aa.builder[v71][v72];
    local v74 = 0;
    local _ = {
        slider = function(_)
            return 1;
        end, 
        combo = function(_)
            return 1;
        end, 
        selectable = function(_)
            return "";
        end, 
        switch = function(_)
            return false;
        end
    };
    for v80, v81 in pairs(v73) do
        if v80 ~= "send_team" and v80 ~= "reset_state" and v81.set then
            local _ = false;
            local v83 = nil;
            if v81.get then
                local v84 = v81:get();
                v83 = type(v84) == "number" and 0 or type(v84) ~= "boolean" and (type(v84) == "string" and "" or 1);
                if pcall(v81.set, v81, v83) then
                    v74 = v74 + 1;
                else
                    print("Failed to reset", v80);
                end;
            end;
        end;
    end;
end;
for v86 = 1, #v18 do
    v19.aa.builder[v86] = {};
    do
        local l_v86_0 = v86;
        for _, v89 in ipairs(v17) do
            v19.aa.builder[l_v86_0][v89] = {};
            local v90 = v19.aa.builder[l_v86_0][v89];
            v90.yaw = v16.antiaim.main4:slider("\v\226\128\162\r" .. string.rep(v13.ZWS, 5) .. "Yaw Mode" .. string.rep(v13.ZWS, 3) .. "\v\f<layer-group>", 1, 2, 1, 1, function(v91)
                if v91 == 1 then
                    return "Static";
                else
                    return "2-Way";
                end;
            end);
            local v92 = v90.yaw:create();
            v90.yaw_brute_enable = v92:switch("\v\226\128\162\r" .. string.rep(v13.ZWS, 5) .. "Anti Bruteforce", false):depend({
                [1] = nil, 
                [2] = 2, 
                [1] = v90.yaw
            });
            v90.yaw_brute_time = v92:slider(string.rep(v13.ZWS, 5) .. "\v\226\128\162\r" .. string.rep(v13.ZWS, 5) .. "Swap Time", 0.1, 500, 12, 0.1, "s"):depend({
                [1] = nil, 
                [2] = 2, 
                [1] = v90.yaw
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v90.yaw_brute_enable
            });
            v90.yaw_add = v16.antiaim.main4:slider(string.rep(v13.ZWS, 5) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 5) .. "Offset", -180, 180, 0, 1, "\194\176"):depend({
                [1] = nil, 
                [2] = 1, 
                [1] = v90.yaw
            });
            v90.yaw_add_l = v16.antiaim.main4:slider(string.rep(v13.ZWS, 5) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 5) .. "Left", -180, 180, 0, 1, "\194\176"):depend({
                [1] = nil, 
                [2] = 2, 
                [1] = v90.yaw
            }):depend({
                [1] = nil, 
                [2] = false, 
                [1] = v90.yaw_brute_enable
            });
            v90.yaw_add_r = v16.antiaim.main4:slider(string.rep(v13.ZWS, 5) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 5) .. "Right", -180, 180, 0, 1, "\194\176"):depend({
                [1] = nil, 
                [2] = 2, 
                [1] = v90.yaw
            }):depend({
                [1] = nil, 
                [2] = false, 
                [1] = v90.yaw_brute_enable
            });
            v90.yaw_brute_sliders = v92:slider(string.rep(v13.ZWS, 10) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 3) .. "Sliders", 1, 9, 0, 1, "p"):depend({
                [1] = nil, 
                [2] = 2, 
                [1] = v90.yaw
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v90.yaw_brute_enable
            });
            for v93 = 1, 9 do
                v90["yaw_brute_slider_left" .. v93] = v92:slider(string.rep(v13.ZWS, 15) .. "\v[" .. v93 .. "]\r   Left", -180, 180, 0, 1):depend({
                    [1] = nil, 
                    [2] = 2, 
                    [1] = v90.yaw
                }):depend({
                    [1] = nil, 
                    [2] = true, 
                    [1] = v90.yaw_brute_enable
                }):depend({
                    [1] = nil, 
                    [2] = nil, 
                    [3] = 9, 
                    [1] = v90.yaw_brute_sliders, 
                    [2] = v93
                });
                v90["yaw_brute_slider_right" .. v93] = v92:slider(string.rep(v13.ZWS, 15) .. "\v[" .. v93 .. "]\r   Right", -180, 180, 0, 1):depend({
                    [1] = nil, 
                    [2] = 2, 
                    [1] = v90.yaw
                }):depend({
                    [1] = nil, 
                    [2] = true, 
                    [1] = v90.yaw_brute_enable
                }):depend({
                    [1] = nil, 
                    [2] = nil, 
                    [3] = 9, 
                    [1] = v90.yaw_brute_sliders, 
                    [2] = v93
                });
            end;
            v92:label(string.rep(v13.ZWS, 5) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 3) .. "- Changed over time. Not per miss"):depend({
                [1] = nil, 
                [2] = 2, 
                [1] = v90.yaw
            });
            v90.yaw_jitter = v16.antiaim.main4:slider("\v\226\128\162\r" .. string.rep(v13.ZWS, 5) .. "Modifier" .. string.rep(v13.ZWS, 3) .. "\v\f<layer-group>", 1, 7, 0, 1, function(v94)
                if v94 == 1 then
                    return "Disabled";
                elseif v94 == 2 then
                    return "Center";
                elseif v94 == 3 then
                    return "Offset";
                elseif v94 == 4 then
                    return "Random";
                elseif v94 == 5 then
                    return "3-Way";
                elseif v94 == 6 then
                    return "5-Way";
                elseif v94 == 7 then
                    return "Steps";
                else
                    return;
                end;
            end);
            local v95 = v90.yaw_jitter:create();
            v90.jitter_random_enable = v95:switch("\v\226\128\162\r" .. string.rep(v13.ZWS, 3) .. "Randomization"):depend({
                [1] = nil, 
                [2] = 2, 
                [3] = 7, 
                [1] = v90.yaw_jitter
            });
            v90.yaw_jitter_add = v16.antiaim.main4:slider(string.rep(v13.ZWS, 5) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 5) .. "Offset\n", -180, 180, 0, 1, "\194\176"):depend({
                [1] = nil, 
                [2] = 2, 
                [3] = 7, 
                [1] = v90.yaw_jitter
            }):depend({
                [1] = nil, 
                [2] = false, 
                [1] = v90.jitter_random_enable
            });
            v90.yaw_jitter_steps = v16.antiaim.main4:slider(string.rep(v13.ZWS, 5) .. "\v\f<layer-plus>\r" .. string.rep(v13.ZWS, 4) .. "Steps\n", 3, 10, 3, 1, "-way"):depend({
                [1] = nil, 
                [2] = 7, 
                [1] = v90.yaw_jitter
            });
            v90.jitter_random_method = v95:slider(string.rep(v13.ZWS, 5) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 5) .. "Method  \v\f<rotate-right>", 1, 2, 0, 1, function(v96)
                if v96 == 1 then
                    return "Default";
                elseif v96 == 2 then
                    return "Custom";
                else
                    return;
                end;
            end):depend({
                [1] = nil, 
                [2] = 2, 
                [3] = 7, 
                [1] = v90.yaw_jitter
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v90.jitter_random_enable
            });
            v90.jitter_random_min = v95:slider(string.rep(v13.ZWS, 15) .. "\v\f<gauge-min>\r" .. string.rep(v13.ZWS, 3) .. "Min", -180, 180, 0, 1, "\194\176"):depend({
                [1] = nil, 
                [2] = 2, 
                [3] = 7, 
                [1] = v90.yaw_jitter
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v90.jitter_random_enable
            }):depend({
                [1] = nil, 
                [2] = 1, 
                [1] = v90.jitter_random_method
            });
            v90.jitter_random_max = v95:slider(string.rep(v13.ZWS, 15) .. "\v\f<gauge-min>\r" .. string.rep(v13.ZWS, 3) .. "Max", -180, 180, 0, 1, "\194\176"):depend({
                [1] = nil, 
                [2] = 2, 
                [3] = 7, 
                [1] = v90.yaw_jitter
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v90.jitter_random_enable
            }):depend({
                [1] = nil, 
                [2] = 1, 
                [1] = v90.jitter_random_method
            });
            v90.jitter_random_sliders = v95:slider(string.rep(v13.ZWS, 15) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 5) .. "Sliders  \v\f<list-timeline>", 1, 9, 0, 1, "p"):depend({
                [1] = nil, 
                [2] = 2, 
                [3] = 7, 
                [1] = v90.yaw_jitter
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v90.jitter_random_enable
            }):depend({
                [1] = nil, 
                [2] = 2, 
                [1] = v90.jitter_random_method
            });
            for v97 = 1, 9 do
                v90["jitter_random_slider_values" .. v97] = v95:slider(string.rep(v13.ZWS, 25) .. "\v\226\164\183\r   [" .. v97 .. "]", -180, 180, 0, 1):depend({
                    [1] = nil, 
                    [2] = 2, 
                    [3] = 7, 
                    [1] = v90.yaw_jitter
                }):depend({
                    [1] = nil, 
                    [2] = true, 
                    [1] = v90.jitter_random_enable
                }):depend({
                    [1] = nil, 
                    [2] = nil, 
                    [3] = 9, 
                    [1] = v90.jitter_random_sliders, 
                    [2] = v97
                }):depend({
                    [1] = nil, 
                    [2] = 2, 
                    [1] = v90.jitter_random_method
                });
            end;
            v90.body = v16.antiaim.main4:combo("\v\226\128\162\r" .. string.rep(v13.ZWS, 5) .. "Options" .. string.rep(v13.ZWS, 3) .. "\v\f<layer-group>", "Jitter", "Static");
            local v98 = v90.body:create();
            v90.body_mode = v98:slider("\v\226\128\162\r" .. string.rep(v13.ZWS, 5) .. "Mode", 1, 2, 0, 1, function(v99)
                if v99 == 1 then
                    return "Static";
                elseif v99 == 2 then
                    return "Ticks";
                else
                    return;
                end;
            end);
            v90.body_switcher = v98:slider("", 3, 22, 3, 1, "t"):depend({
                [1] = nil, 
                [2] = 2, 
                [1] = v90.body_mode
            });
            v90.body_add_mode = v98:slider(string.rep(v13.ZWS, 2) .. "\v\226\128\162\r" .. string.rep(v13.ZWS, 5) .. "Limits", 1, 2, 0, 1, function(v100)
                if v100 == 1 then
                    return "Static";
                else
                    return "Random";
                end;
            end);
            v90.body_add_l = v98:slider(string.rep(v13.ZWS, 10) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 5) .. "Left", 0, 60, 0, 1, "\194\176"):depend({
                [1] = nil, 
                [2] = 1, 
                [1] = v90.body_add_mode
            });
            v90.body_add_r = v98:slider(string.rep(v13.ZWS, 10) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 5) .. "Right", 0, 60, 0, 1, "\194\176"):depend({
                [1] = nil, 
                [2] = 1, 
                [1] = v90.body_add_mode
            });
            v90.body_random_min = v98:slider(string.rep(v13.ZWS, 10) .. "\v\f<gauge-min>\r" .. string.rep(v13.ZWS, 3) .. "Min", 0, 60, 0, 1, "\194\176"):depend({
                [1] = nil, 
                [2] = 2, 
                [1] = v90.body_add_mode
            });
            v90.body_random_max = v98:slider(string.rep(v13.ZWS, 10) .. "\v\f<gauge-max>\r" .. string.rep(v13.ZWS, 3) .. "Max", 0, 60, 0, 1, "\194\176"):depend({
                [1] = nil, 
                [2] = 2, 
                [1] = v90.body_add_mode
            });
            v90.body_delay = v98:slider("\v\226\128\162\r" .. string.rep(v13.ZWS, 5) .. "Delay   \v\f<clock>", 1, 3, 1, 1, function(v101)
                if v101 == 1 then
                    return "Disabled";
                elseif v101 == 2 then
                    return "Neverlose";
                elseif v101 == 3 then
                    return "Inverter";
                else
                    return;
                end;
            end);
            v90.delay_random_enable = v98:switch(string.rep(v13.ZWS, 4) .. "\v\226\128\162\r" .. string.rep(v13.ZWS, 5) .. "Randomization"):depend({
                [1] = nil, 
                [2] = 2, 
                [3] = 3, 
                [1] = v90.body_delay
            });
            v90.delay_add = v98:slider(string.rep(v13.ZWS, 10) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 5) .. "Delay", 1, 22, 1, 1, function(v102)
                if v102 == 1 then
                    return "Default";
                else
                    return v102 .. "t";
                end;
            end):depend({
                [1] = nil, 
                [2] = 2, 
                [3] = 3, 
                [1] = v90.body_delay
            }):depend({
                [1] = nil, 
                [2] = false, 
                [1] = v90.delay_random_enable
            });
            v90.delay_random_method = v98:slider(string.rep(v13.ZWS, 10) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 5) .. "Method   \v\f<rotate-right>", 1, 2, 0, 1, function(v103)
                if v103 == 1 then
                    return "Default";
                elseif v103 == 2 then
                    return "Custom";
                else
                    return;
                end;
            end):depend({
                [1] = nil, 
                [2] = 2, 
                [3] = 3, 
                [1] = v90.body_delay
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v90.delay_random_enable
            });
            v90.delay_random_min = v98:slider(string.rep(v13.ZWS, 15) .. "\v\f<gauge-min>\r" .. string.rep(v13.ZWS, 4) .. "Min", 1, 22, 1, 1, function(v104)
                if v104 == 1 then
                    return "Default";
                else
                    return v104 .. "t";
                end;
            end):depend({
                [1] = nil, 
                [2] = 2, 
                [3] = 3, 
                [1] = v90.body_delay
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v90.delay_random_enable
            }):depend({
                [1] = nil, 
                [2] = 1, 
                [1] = v90.delay_random_method
            });
            v90.delay_random_max = v98:slider(string.rep(v13.ZWS, 15) .. "\v\f<gauge-min>\r" .. string.rep(v13.ZWS, 4) .. "Max\n", 2, 22, 2, 1, function(v105)
                if v105 == 1 then
                    return "Default";
                else
                    return v105 .. "t";
                end;
            end):depend({
                [1] = nil, 
                [2] = 2, 
                [3] = 3, 
                [1] = v90.body_delay
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v90.delay_random_enable
            }):depend({
                [1] = nil, 
                [2] = 1, 
                [1] = v90.delay_random_method
            });
            v90.delay_random_sliders = v98:slider(string.rep(v13.ZWS, 15) .. "\v\f<list-timeline>\r" .. string.rep(v13.ZWS, 3) .. "Sliders", 1, 9, 0, 1):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v90.delay_random_enable
            }):depend({
                [1] = nil, 
                [2] = 2, 
                [1] = v90.delay_random_method
            });
            for v106 = 1, 9 do
                v90["delay_random_slider_values" .. v106] = v98:slider(string.rep(v13.ZWS, 25) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 3) .. "[" .. v106 .. "]", 1, 22, 0, 1, function(v107)
                    if v107 == 1 then
                        return "Default";
                    else
                        return v107 .. "t";
                    end;
                end):depend({
                    [1] = nil, 
                    [2] = true, 
                    [1] = v90.delay_random_enable
                }):depend({
                    [1] = nil, 
                    [2] = nil, 
                    [3] = 9, 
                    [1] = v90.delay_random_sliders, 
                    [2] = v106
                }):depend({
                    [1] = nil, 
                    [2] = 2, 
                    [1] = v90.delay_random_method
                });
            end;
            v90.tickbase = v16.antiaim.main6:combo("\v\226\128\162\r" .. string.rep(v13.ZWS, 4) .. "Tickbase" .. string.rep(v13.ZWS, 3) .. "\v\f<layer-group>", "Neverlose", "Venture");
            local v108 = v90.tickbase:create();
            v90.tickbase_method = v108:slider(string.rep(v13.ZWS, 5) .. "\v\226\128\162\r" .. string.rep(v13.ZWS, 6) .. "Method", 1, 2, 1, 1, function(v109)
                if v109 == 1 then
                    return "Default";
                else
                    return "Custom";
                end;
            end):depend({
                [1] = nil, 
                [2] = "Venture", 
                [1] = v90.tickbase
            });
            v90.tickbase_random_min = v108:slider(string.rep(v13.ZWS, 15) .. "\v\f<gauge-min>\r" .. string.rep(v13.ZWS, 4) .. "Min", 1, 22, 1, 1, function(v110)
                if v110 == 16 then
                    return "Default";
                else
                    return v110 .. "t";
                end;
            end):depend({
                [1] = nil, 
                [2] = "Venture", 
                [1] = v90.tickbase
            }):depend({
                [1] = nil, 
                [2] = 1, 
                [1] = v90.tickbase_method
            });
            v90.tickbase_random_max = v108:slider(string.rep(v13.ZWS, 15) .. "\v\f<gauge-min>\r" .. string.rep(v13.ZWS, 4) .. "Max", 2, 22, 2, 1, function(v111)
                if v111 == 16 then
                    return "Default";
                else
                    return v111 .. "t";
                end;
            end):depend({
                [1] = nil, 
                [2] = "Venture", 
                [1] = v90.tickbase
            }):depend({
                [1] = nil, 
                [2] = 1, 
                [1] = v90.tickbase_method
            });
            v90.tickbase_random_sliders = v108:slider(string.rep(v13.ZWS, 15) .. "\v\f<gauge-min>\r" .. string.rep(v13.ZWS, 4) .. "Sliders", 1, 9, 0, 1):depend({
                [1] = nil, 
                [2] = "Venture", 
                [1] = v90.tickbase
            }):depend({
                [1] = nil, 
                [2] = 2, 
                [1] = v90.tickbase_method
            });
            for v112 = 1, 9 do
                v90["tickbase_random_slider_values" .. v112] = v108:slider(string.rep(v13.ZWS, 25) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 4) .. "[" .. v112 .. "]", 1, 22, 0, 1, function(v113)
                    if v113 == 16 then
                        return "Default";
                    else
                        return v113 .. "t";
                    end;
                end):depend({
                    [1] = nil, 
                    [2] = "Venture", 
                    [1] = v90.tickbase
                }):depend({
                    [1] = nil, 
                    [2] = nil, 
                    [3] = 9, 
                    [1] = v90.tickbase_random_sliders, 
                    [2] = v112
                }):depend({
                    [1] = nil, 
                    [2] = 2, 
                    [1] = v90.tickbase_method
                });
            end;
            v90.hidden = v16.antiaim.main6:switch(string.rep(v13.ZWS, 0) .. "\v\f<shield-slash>\r" .. string.rep(v13.ZWS, 4) .. "Hidden Angles" .. string.rep(v13.ZWS, 3) .. "\v\f<layer-group>", false);
            v90.hidden_pitch = v16.antiaim.main6:combo(string.rep(v13.ZWS, 5) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 4) .. "Pitch" .. string.rep(v13.ZWS, 3) .. "\v\f<layer-group>", "Down", "Up", "Static", "2-Way"):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v90.hidden
            });
            v90.hidden_pitch_custom = v16.antiaim.main6:slider(string.rep(v13.ZWS, 10) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 4) .. "Offset", -89, 89, 0, 1, "\194\176"):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v90.hidden
            }):depend({
                [1] = nil, 
                [2] = "Static", 
                [1] = v90.hidden_pitch
            });
            v90.hidden_pitch_add = v16.antiaim.main6:slider(string.rep(v13.ZWS, 10) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 4) .. "[1]", -89, 89, 0, 1, "\194\176"):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v90.hidden
            }):depend({
                [1] = nil, 
                [2] = "2-Way", 
                [1] = v90.hidden_pitch
            });
            v90.hidden_pitch_add2 = v16.antiaim.main6:slider(string.rep(v13.ZWS, 10) .. "\v\226\164\183\r" .. string.rep(v13.ZWS, 4) .. "[2]", -89, 89, 0, 1, "\194\176"):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v90.hidden
            }):depend({
                [1] = nil, 
                [2] = "2-Way", 
                [1] = v90.hidden_pitch
            });
            do
                local l_v89_0 = v89;
                v90.send_team = v16.antiaim.main4:button("    Send to opposite team  \v\f<share-from-square>   ", function()
                    -- upvalues: v70 (ref), l_v86_0 (ref), l_v89_0 (ref)
                    v70(l_v86_0, l_v89_0);
                    common.add_notify("Success", "Sent settings!");
                end, true);
                v90.reset_state = v16.antiaim.main4:button("  \aF55656FFReset  ", function()
                    -- upvalues: v85 (ref), l_v86_0 (ref), l_v89_0 (ref)
                    v85(l_v86_0, l_v89_0);
                end, true);
                for _, v116 in pairs(v90) do
                    local v117 = {
                        [1] = {
                            [1] = v19.aa.state, 
                            [2] = l_v89_0
                        }, 
                        [2] = {
                            [1] = v19.aa.team, 
                            [2] = l_v86_0
                        }
                    };
                    v116:depend(table.unpack(v117));
                end;
            end;
        end;
    end;
end;
local v122 = {
    font_file = render.load_font("Verdana", vector(10.5, 11.5, 5), "ad"), 
    lerpik = function(_, v119, v120, v121)
        return v119 + (v120 - v119) * v121;
    end
};
local v123 = 0;
local v124 = 0;
local v125 = 0;
local v126 = 0;
v122.positions = {
    venture = {
        target = 0, 
        current = 0
    }, 
    dt = {
        target = 0, 
        current = 0
    }, 
    dmg = {
        target = 0, 
        current = 0
    }, 
    aa_state = {
        target = 0, 
        current = 0
    }
};
v122.hitgroup_str = {
    [0] = "generic", 
    [1] = "head", 
    [2] = "chest", 
    [3] = "stomach", 
    [4] = "left arm", 
    [5] = "right arm", 
    [6] = "left leg", 
    [7] = "right leg", 
    [8] = "head", 
    [9] = "generic", 
    [10] = "gear"
};
local v127 = render.load_font("Calibri", vector(23, 23.5), "adb");
local _ = {
    hits = 0, 
    total_shots = 0
};
local v129 = 0;
v122.process_teleport = function(_)
    -- upvalues: v19 (ref), v129 (ref)
    local v131 = entity.get_local_player();
    if not v131 then
        return;
    elseif not v131:is_alive() then
        return;
    elseif not v19.mods.auto_teleport:get() then
        return;
    else
        current_time = globals.realtime;
        teleport_delay = 1;
        if current_time - v129 < teleport_delay then
            return;
        else
            teleported = false;
            entity.get_players(true, false, function(v132)
                -- upvalues: v129 (ref)
                if v132:is_visible() and v132:is_alive() and not teleported then
                    rage.exploit:force_teleport();
                    teleported = true;
                    v129 = current_time;
                end;
            end);
            return;
        end;
    end;
end;
v122.process_forcebaim = function(_)
    -- upvalues: v19 (ref), v0 (ref), v13 (ref)
    if not globals.is_in_game then
        return;
    else
        local v134 = entity.get_local_player();
        if not v134 then
            return;
        elseif not v134:is_alive() then
            return;
        elseif not v19.mods.forcebaim:get() then
            v0.bodyaim:override(nil);
            return;
        else
            weapon = v134:get_player_weapon();
            if not weapon then
                v0.bodyaim:override(nil);
                return;
            else
                name = weapon:get_classname();
                weapon_settings = {
                    AWP = string.match(name, "AWP"), 
                    ["SSG-08"] = string.match(name, "SSG08"), 
                    Auto = string.match(name, "SCAR20") or string.match(name, "G3SG1")
                };
                weapon_selected = false;
                for v135, v136 in pairs(weapon_settings) do
                    if v19.mods.forcebaim.select:get(v135) and v136 then
                        weapon_selected = true;
                        break;
                    end;
                end;
                if not weapon_selected then
                    v0.bodyaim:override(nil);
                    return;
                else
                    threat = v13.threat;
                    if not threat then
                        v0.bodyaim:override(nil);
                        return;
                    else
                        hp = threat.m_iHealth;
                        if hp and hp <= v19.mods.forcebaim.hp:get() and hp > 0 then
                            v0.bodyaim:override("Force");
                        else
                            v0.bodyaim:override(nil);
                        end;
                        return;
                    end;
                end;
            end;
        end;
    end;
end;
v122.super_toss = {
    GRENADE_SECONDARY_DAMPENING = 0.3
};
v122.super_toss.lerp = function(_, v138, v139, v140)
    return v138 + v140 * (v139 - v138);
end;
v122.super_toss.ray_circle_intersection = function(_, v142, v143, v144)
    if math.abs(v142.x) > math.abs(v142.y) then
        local v145 = v142.y / v142.x;
        local v146 = 1 + v145 * v145;
        local v147 = -2 * v143.x - 2 * v145 * v143.y;
        local v148 = v143:length2dsqr() - v144 * v144;
        local v149 = v147 * v147 - 4 * v146 * v148;
        if v149 < 0 then
            return v143 + (v142 * v143:dot(v142) - v143):normalized() * v144;
        elseif v149 < 0.001 then
            local v150 = -v147 / (2 * v146);
            local v151 = v145 * v150;
            return vector(v150, v151);
        else
            local v152 = math.sqrt(v149);
            local v153 = (-v147 + v152) / (2 * v146);
            local v154 = v145 * v153;
            local v155 = vector(v153, v154);
            v153 = (-v147 - v152) / (2 * v146);
            v154 = v145 * v153;
            local v156 = vector(v153, v154);
            if v142:dot(v155) > v142:dot(v156) then
                return v155;
            else
                return v156;
            end;
        end;
    else
        local v157 = v142.x / v142.y;
        local v158 = 1 + v157 * v157;
        local v159 = -2 * v143.y - 2 * v157 * v143.x;
        local v160 = v143:length2dsqr() - v144 * v144;
        local v161 = v159 * v159 - 4 * v158 * v160;
        if v161 < 0 then
            return v143 + (v142 * v143:dot(v142) - v143):normalized() * v144;
        elseif v161 < 0.001 then
            local v162 = -v159 / (2 * v158);
            local v163 = v157 * v162;
            return vector(v163, v162);
        else
            local v164 = math.sqrt(v161);
            local v165 = (-v159 + v164) / (2 * v158);
            local v166 = v157 * v165;
            local v167 = vector(v166, v165);
            v165 = (-v159 - v164) / (2 * v158);
            v166 = v157 * v165;
            local v168 = vector(v166, v165);
            if v142:dot(v167) > v142:dot(v168) then
                return v167;
            else
                return v168;
            end;
        end;
    end;
end;
v122.super_toss.correct_angle = function(v169, v170, v171, v172, v173)
    local v174 = vector():angles(v170);
    local v175 = vector():angles(v170.x - (90 - math.abs(v170.x)) * 10 / 90, v170.y);
    local v176 = v175:dot(v174) / v174:length();
    local v177 = math.clamp(v172 * 0.9, 15, 750);
    local v178 = math.clamp(v173, 0, 1);
    v177 = v177 * v169:lerp(v169.GRENADE_SECONDARY_DAMPENING, 1, v178);
    v170.y = (v169:ray_circle_intersection(v175, v171 * 1.25, v177 * v176) - v171 * 1.25):angles().y;
    v170.x = math.clamp(v170.x + math.clamp(v171.z * 0.1, -20, 20), -89, 89);
end;
v122.super_toss.rotate_movement = function(_, v180, v181)
    local v182 = math.rad(v181);
    local v183 = math.cos(v182);
    local v184 = math.sin(v182);
    local v185 = v183 * v180.forwardmove + v184 * v180.sidemove;
    local v186 = v184 * v180.forwardmove + v183 * v180.sidemove;
    v180.forwardmove = v185;
    v180.sidemove = v186;
end;
v122.super_toss.createmove = function(v187, v188)
    -- upvalues: v19 (ref)
    if not globals.is_in_game then
        return;
    elseif not v19.mods.super_toss:get() then
        return;
    else
        local v189 = entity.get_local_player();
        if v189 == nil then
            return;
        else
            local v190 = v189:get_player_weapon();
            if v190 == nil then
                return;
            else
                local v191 = v190:get_weapon_info();
                if v191 == nil or v191.weapon_type ~= 9 then
                    return;
                elseif v190.m_fThrowTime == 0 then
                    return;
                elseif v189.m_nTickBase * globals.tickinterval < v190.m_fThrowTime and rage.exploit:get() ~= 1 then
                    return;
                else
                    local l_view_angles_0 = v188.view_angles;
                    local l_y_0 = l_view_angles_0.y;
                    local v194 = render.camera_angles();
                    if v194.x ~= l_view_angles_0.x or v194.y ~= l_view_angles_0.y then
                        return;
                    else
                        v187:correct_angle(l_view_angles_0, v189.m_vecVelocity, v191.throw_velocity, v190.m_flThrowStrength);
                        v187:rotate_movement(v188, math.normalize_yaw(l_y_0 - l_view_angles_0.y));
                        return;
                    end;
                end;
            end;
        end;
    end;
end;
v122.super_toss.grenade_override_view = function(v195, v196)
    -- upvalues: v19 (ref)
    if not globals.is_in_game then
        return;
    elseif not v19.mods.super_toss:get() then
        return;
    else
        local v197 = entity.get_local_player();
        if v197 == nil then
            return;
        else
            local v198 = v197:get_player_weapon();
            if v198 == nil then
                return;
            else
                local v199 = v198:get_weapon_info();
                if v199 ~= nil and v199.weapon_type == 9 then
                    v195:correct_angle(v196.angles, v196.velocity, v199.throw_velocity, v198.m_flThrowStrength);
                end;
                return;
            end;
        end;
    end;
end;
v122.fast_ladder = function(_, v201)
    -- upvalues: v19 (ref)
    if not globals.is_in_game then
        return;
    else
        local v202 = entity.get_local_player();
        if not v202 then
            return;
        elseif not v202:is_alive() then
            return;
        elseif not v19.mods.fast_ladder:get() then
            return;
        else
            if entity.get_local_player().m_MoveType == 9 then
                if v201.forwardmove > 0 and render.camera_angles().x < 45 then
                    v201.view_angles.x = 89;
                    v201.in_moveright = 1;
                    v201.in_moveleft = 0;
                    v201.in_forward = 0;
                    v201.in_back = 1;
                    if v201.sidemove == 0 then
                        v201.view_angles.y = v201.view_angles.y + 90;
                    end;
                    if v201.sidemove < 0 then
                        v201.view_angles.y = v201.view_angles.y + 150;
                    end;
                    if v201.sidemove > 0 then
                        v201.view_angles.y = v201.view_angles.y + 30;
                    end;
                end;
                if v201.forwardmove < 0 then
                    v201.view_angles.x = 89;
                    v201.in_moveleft = 1;
                    v201.in_moveright = 0;
                    v201.in_forward = 1;
                    v201.in_back = 0;
                    if v201.sidemove == 0 then
                        v201.view_angles.y = v201.view_angles.y + 90;
                    end;
                    if v201.sidemove > 0 then
                        v201.view_angles.y = v201.view_angles.y + 150;
                    end;
                    if v201.sidemove < 0 then
                        v201.view_angles.y = v201.view_angles.y + 30;
                    end;
                end;
            end;
            return;
        end;
    end;
end;
v122.unlock_fakeduck_speed = function(_, v204)
    -- upvalues: v19 (ref), v0 (ref)
    if not globals.is_in_game then
        return;
    elseif not v19.mods.fakeduck_speed:get() then
        return;
    elseif not v0.fakeduck:get() then
        return;
    else
        local v205 = vector(v204.forwardmove, v204.sidemove);
        v205:normalize();
        local v206 = entity.get_local_player();
        if v206 == nil then
            return;
        else
            if math.abs(v206.m_vecVelocity.y) > 10 then
                v204.forwardmove = v205.x * 150;
                v204.sidemove = v205.y * 150;
            end;
            return;
        end;
    end;
end;
v122.fake_latency = function(_)
    -- upvalues: v19 (ref), v0 (ref)
    if v19.mods.fake_latency:get() then
        v0.spike:override(v19.mods.fake_latency.amount:get());
    else
        v0.spike:override(nil);
    end;
end;
v122.anim_breakers = function(_)
    -- upvalues: v19 (ref), v4 (ref), v3 (ref), v0 (ref), l_ffi_0 (ref)
    if not globals.is_in_game then
        return;
    elseif not v19.mods.animation_allow:get() then
        return;
    else
        local v209 = entity.get_local_player();
        if not v209 or v209 == nil then
            return;
        elseif not v209:is_alive() then
            return;
        elseif v209:get_index() == nil then
            return;
        else
            v4 = v3(v209:get_index());
            local v210 = v209:get_anim_state();
            if not v210 or v210 == nil then
                return;
            else
                move = math.sqrt(v209.m_vecVelocity.x ^ 2 + v209.m_vecVelocity.y ^ 2) > 5;
                jump = bit.band(v209.m_fFlags, 1) == 0;
                if v19.mods.animation_air:get() == 2 then
                    v209.m_flPoseParameter[6] = 1;
                elseif v19.mods.animation_air:get() == 1 then
                    v209.m_flPoseParameter[6] = globals.tickcount % 4 > 1 and math.random(math.random(0.1, v19.mods.animation_air.custom:get() / 20), 5) / 10 or math.random(0.1, v19.mods.animation_air.custom:get() / 100);
                else
                    v209.m_flPoseParameter[6] = 0;
                end;
                if v19.mods.animation_run:get() == 1 then
                    v209.m_flPoseParameter[0] = globals.tickcount % 4 > 1 and math.random(utils.random_float(0.1, v19.mods.animation_run.custom:get() / 100), 1) or math.random(0.1, v19.mods.animation_run.custom:get() / 100);
                elseif v19.mods.animation_run:get() == 2 then
                    v209.m_flPoseParameter[0] = 1;
                    v0.leg:set("Sliding");
                else
                    v0.leg:set(v0.leg:get());
                end;
                if v19.mods.zero_pitch:get() > -1 and v210.landing then
                    v209.m_flPoseParameter[12] = (10 - v19.mods.zero_pitch:get()) / 10;
                end;
                if v19.mods.animation_lean:get() ~= 0 and move then
                    l_ffi_0.cast("animstate_layer_t**", l_ffi_0.cast("uintptr_t", v4) + 10640)[0][12].m_flWeight = v19.mods.animation_lean:get() / 100;
                end;
                if v19.mods.animation_shake:get() ~= 0 then
                    if v19.mods.animation_shake:get() == 1 then
                        l_ffi_0.cast("animstate_layer_t**", l_ffi_0.cast("uintptr_t", v4) + 10640)[0][12].m_flWeight = math.random(0, v19.mods.animation_shake.custom:get() / 100);
                    elseif v19.mods.animation_shake:get() == 2 then
                        l_ffi_0.cast("animstate_layer_t**", l_ffi_0.cast("uintptr_t", v4) + 10640)[0][12].m_flWeight = math.random(v19.mods.animation_shake.min:get() / 100, v19.mods.animation_shake.max:get() / 100);
                    end;
                end;
                return;
            end;
        end;
    end;
end;
events.post_update_clientside_animation:set(v122.anim_breakers);
v122.lagcomp_debug = {
    sv_gravity = cvar.sv_gravity, 
    sv_jump_impulse = cvar.sv_jump_impulse, 
    sim_ticks = {}, 
    net_data = {}, 
    esp_data = {}
};
v122.lagcomp_debug.extrapolate = function(v211, v212, v213, v214)
    local l_tickinterval_0 = globals.tickinterval;
    local v216 = v211.sv_gravity:float() * l_tickinterval_0;
    local v217 = v211.sv_jump_impulse:float() * l_tickinterval_0;
    local l_v213_0 = v213;
    local l_v213_1 = v213;
    local l_m_vecVelocity_0 = v212.m_vecVelocity;
    local v221 = l_m_vecVelocity_0.z > 0 and -v216 or v217;
    for _ = 1, v214 do
        l_v213_1 = l_v213_0;
        l_v213_0 = vector(l_v213_0.x + l_m_vecVelocity_0.x * l_tickinterval_0, l_v213_0.y + l_m_vecVelocity_0.y * l_tickinterval_0, l_v213_0.z + (l_m_vecVelocity_0.z + v221) * l_tickinterval_0);
        if utils.trace_line(l_v213_1, l_v213_0).fraction <= 0.99 then
            return l_v213_1;
        end;
    end;
    return l_v213_0;
end;
v122.lagcomp_debug.get_active_players = function(_, v224)
    local l_m_iObserverMode_0 = v224.m_iObserverMode;
    if l_m_iObserverMode_0 == 0 or l_m_iObserverMode_0 == 1 or l_m_iObserverMode_0 == 2 or l_m_iObserverMode_0 == 6 then
        return entity.get_players(true, true);
    else
        local v226 = {};
        if l_m_iObserverMode_0 == 4 or l_m_iObserverMode_0 == 5 then
            local v227 = entity.get_players(false, true);
            local l_m_hObserverTarget_0 = v224.m_hObserverTarget;
            if l_m_hObserverTarget_0 == nil then
                return {};
            else
                local l_m_iTeamNum_0 = l_m_hObserverTarget_0.m_iTeamNum;
                for v230 = 1, #v227 do
                    local v231 = v227[v230];
                    if v231 ~= v224 and v231.m_iTeamNum ~= l_m_iTeamNum_0 then
                        table.insert(v226, v231);
                    end;
                end;
            end;
        end;
        return v226;
    end;
end;
v122.lagcomp_debug.render = function(v232)
    -- upvalues: v19 (ref)
    if not globals.is_in_game then
        return;
    elseif not v19.vis.enemy_lagcomp:get() then
        return;
    else
        local v233 = entity.get_local_player();
        if v233 == nil or not v233:is_alive() then
            return;
        else
            local v234 = v19.vis.enemy_lagcomp.box_color:get();
            local _ = v19.vis.enemy_lagcomp.text_color:get();
            local v236 = v19.vis.enemy_lagcomp.box_color:get_color();
            local v237 = v19.vis.enemy_lagcomp.text_color:get_color();
            if #v232:get_active_players(v233) == 0 then
                return;
            else
                for v238, v239 in pairs(v232.net_data) do
                    local v240 = entity.get(v238);
                    if v240 ~= nil and v240:is_alive() and v240:is_enemy() then
                        if v239.lagcomp and v234 then
                            local l_predicted_origin_0 = v239.predicted_origin;
                            local v242 = l_predicted_origin_0 + v240.m_vecMins;
                            local v243 = l_predicted_origin_0 + v240.m_vecMaxs;
                            local v244 = {
                                vector(v242.x, v242.y, v242.z), 
                                vector(v242.x, v243.y, v242.z), 
                                vector(v243.x, v243.y, v242.z), 
                                vector(v243.x, v242.y, v242.z), 
                                vector(v242.x, v242.y, v243.z), 
                                vector(v242.x, v243.y, v243.z), 
                                vector(v243.x, v243.y, v243.z), 
                                vector(v243.x, v242.y, v243.z)
                            };
                            local v245 = {
                                [1] = {
                                    [1] = 1, 
                                    [2] = 2
                                }, 
                                [2] = {
                                    [1] = 2, 
                                    [2] = 3
                                }, 
                                [3] = {
                                    [1] = 3, 
                                    [2] = 4
                                }, 
                                [4] = {
                                    [1] = 4, 
                                    [2] = 1
                                }, 
                                [5] = {
                                    [1] = 6, 
                                    [2] = 7
                                }, 
                                [6] = {
                                    [1] = 7, 
                                    [2] = 8
                                }, 
                                [7] = {
                                    [1] = 2, 
                                    [2] = 5
                                }, 
                                [8] = {
                                    [1] = 5, 
                                    [2] = 8
                                }, 
                                [9] = {
                                    [1] = 1, 
                                    [2] = 5
                                }, 
                                [10] = {
                                    [1] = 2, 
                                    [2] = 6
                                }, 
                                [11] = {
                                    [1] = 3, 
                                    [2] = 7
                                }, 
                                [12] = {
                                    [1] = 4, 
                                    [2] = 8
                                }, 
                                [13] = {
                                    [1] = 6, 
                                    [2] = 8
                                }, 
                                [14] = {
                                    [1] = 8, 
                                    [2] = 8
                                }, 
                                [15] = {
                                    [1] = 4, 
                                    [2] = 5
                                }
                            };
                            for v246 = 1, #v245 do
                                if v246 == 1 then
                                    local v247 = v240:get_origin();
                                    local v248 = render.world_to_screen(v242);
                                    local v249 = render.world_to_screen(v247);
                                    if v248 ~= nil and v249 ~= nil then
                                        render.line(v248, v249, v236);
                                    end;
                                end;
                                local v250 = v244[v245[v246][1]];
                                local v251 = v244[v245[v246][2]];
                                if v250 ~= nil and v251 ~= nil then
                                    local v252 = render.world_to_screen(v250);
                                    local v253 = render.world_to_screen(v251);
                                    if v252 ~= nil and v253 ~= nil then
                                        render.line(v252, v253, v236);
                                    end;
                                end;
                            end;
                        end;
                        local v254 = v240:get_bbox();
                        if v254 ~= nil and v254.pos1 ~= nil and v254.pos2 ~= nil and v254.alpha ~= nil then
                            local v255 = 0;
                            if v232.esp_data[v238] and v232.esp_data[v238] > 0 then
                                v232.esp_data[v238] = v232.esp_data[v238] - globals.frametime * 2;
                                v232.esp_data[v238] = v232.esp_data[v238] < 0 and 0 or v232.esp_data[v238];
                                v255 = v232.esp_data[v238];
                            end;
                            local v256 = v239.tickbase or v232.esp_data[v238] and v232.esp_data[v238] > 0;
                            local l_lagcomp_0 = v239.lagcomp;
                            if not v256 or v239.lagcomp then
                                v255 = v254.alpha;
                            end;
                            local v258 = {
                                [0] = "", 
                                [1] = "LAG COMP BREAKER", 
                                [2] = "SHIFTING TICKBASE"
                            };
                            if v254.alpha > 0 then
                                local v259 = v240:get_name() == "" and -8 or 0;
                                local v260 = v254.pos2.x - v254.pos1.x;
                                local v261 = vector(v254.pos1.x + v260 / 2, v254.pos1.y - 18 + v259);
                                local v262 = v237:clone();
                                v262.a = v262.a * v255;
                                local v263 = v258[v256 and 2 or l_lagcomp_0 and 1 or 0];
                                if v263 ~= "" and v255 > 0 then
                                    render.text(1, v261, v262, "c", v263);
                                end;
                            end;
                        end;
                    end;
                end;
                return;
            end;
        end;
    end;
end;
v122.lagcomp_debug.net_update_end = function(v264)
    -- upvalues: v19 (ref)
    if not globals.is_in_game then
        return;
    elseif not v19.vis.enemy_lagcomp:get() then
        return;
    elseif entity.get_local_player() == nil then
        return;
    else
        local v265 = entity.get_players(true, true);
        for v266 = 1, #v265 do
            local v267 = v265[v266];
            local v268 = v267:get_index();
            local v269 = v264.sim_ticks[v268];
            if v267:is_dormant() or not v267:is_alive() then
                v264.sim_ticks[v268] = nil;
                v264.net_data[v268] = nil;
                v264.esp_data[v268] = nil;
            else
                local l_m_vecOrigin_0 = v267.m_vecOrigin;
                local v271 = to_ticks(v267.m_flSimulationTime);
                if v269 ~= nil then
                    local v272 = v271 - v269.tick;
                    if v272 < 0 or v272 > 0 and v272 <= 64 then
                        local v273 = (l_m_vecOrigin_0 - v269.origin):length2dsqr();
                        local v274 = v264:extrapolate(v267, l_m_vecOrigin_0, v272 - 1);
                        if v272 < 0 then
                            v264.esp_data[v268] = 1;
                        end;
                        v264.net_data[v268] = {
                            tick = v272 - 1, 
                            origin = l_m_vecOrigin_0, 
                            predicted_origin = v274, 
                            tickbase = v272 < 0, 
                            lagcomp = v273 > 4096
                        };
                    end;
                end;
                if v264.esp_data[v268] == nil then
                    v264.esp_data[v268] = 0;
                end;
                v264.sim_ticks[v268] = {
                    tick = v271, 
                    origin = l_m_vecOrigin_0
                };
            end;
        end;
        return;
    end;
end;
v122.performance_boost = function(_)
    -- upvalues: v19 (ref)
    if v19.vis.optimize_cvars:get() then
        fps_boost_enabled = true;
        cvar.cl_disable_ragdolls:int(1, true);
        cvar.dsp_slow_cpu:int(1, true);
        cvar.mat_disable_bloom:int(1, true);
        cvar.r_drawparticles:int(1, true);
        cvar.func_break_max_pieces:int(0, true);
        cvar.mat_queue_mode:int(2, true);
        cvar.muzzleflash_light:int(0, true);
        cvar.mat_hdr_enabled:int(0, true);
        cvar.r_eyemove:int(0, true);
        cvar.r_eyegloss:int(0, true);
        cvar.r_cheapwaterstart:int(1, true);
        cvar.r_waterforceexpensive:int(0, true);
        cvar.r_decals:int(0, true);
        cvar.r_drawflecks:int(0, true);
        cvar.r_shadowmaxrendered:int(0, true);
        cvar.r_shadows:int(0, true);
        cvar.r_drawmodeldecals:int(0, true);
        cvar.r_worldlights:int(0, true);
        cvar.r_PhysPropStaticLighting:int(0, true);
    else
        fps_boost_enabled = false;
        cvar.cl_disable_ragdolls:int(0, true);
        cvar.dsp_slow_cpu:int(0, true);
        cvar.mat_disable_bloom:int(0, true);
        cvar.r_drawparticles:int(1, true);
        cvar.func_break_max_pieces:int(15, true);
        cvar.mat_queue_mode:int(-1, true);
        cvar.muzzleflash_light:int(1, true);
        cvar.mat_hdr_enabled:int(1, true);
        cvar.r_eyemove:int(1, true);
        cvar.r_eyegloss:int(1, true);
        cvar.fps_max:int(300, true);
        cvar.r_cheapwaterstart:int(0, true);
        cvar.r_waterforceexpensive:int(1, true);
        cvar.r_decals:int(2048, true);
        cvar.r_drawflecks:int(1, true);
        cvar.r_shadowmaxrendered:int(32, true);
        cvar.r_shadows:int(1, true);
        cvar.r_drawmodeldecals:int(1, true);
        cvar.r_worldlights:int(4, true);
        cvar.r_PhysPropStaticLighting:int(1, true);
    end;
end;
v122.show_dmg = function(_)
    -- upvalues: v19 (ref), v13 (ref)
    if not v19.vis.damage_indicator:get() then
        return;
    else
        local l_screen_size_0 = v13.screen_size;
        local v278 = ui.get_binds();
        for _, v280 in pairs(v278) do
            if v280.name == "Min. Damage" then
                render.text(v19.vis.damage_indicator.font:get(), vector(l_screen_size_0.x / 2 + 14, l_screen_size_0.y / 2 - 12), v19.vis.damage_indicator.color:get(), "C", v280.value);
            end;
        end;
        return;
    end;
end;
local v281 = 40;
local v282 = 100;
local v283 = {
    [1] = 60, 
    [2] = 5, 
    [3] = 50, 
    [4] = 5
};
local v284 = {
    dt_inactive = color(225, 57, 57, 0), 
    dt_charging = color(220, 21, 21), 
    dt_ready = color(225, 255, 255), 
    active = color(136, 207, 52), 
    white = color(255, 255, 255), 
    black = color(0, 0, 0)
};
local function v289(_, v286, v287)
    -- upvalues: v284 (ref), v283 (ref)
    local l_black_0 = v284.black;
    render.gradient(vector(48 - v287, v286 - 2), vector(27 - v287 + 10, v286 + v287 + 2), color(l_black_0.r, l_black_0.g, l_black_0.b, v283[1]), color(l_black_0.r, l_black_0.g, l_black_0.b, v283[2]), color(l_black_0.r, l_black_0.g, l_black_0.b, v283[3]), color(l_black_0.r, l_black_0.g, l_black_0.b, v283[4]));
    render.gradient(vector(48 - v287, v286 - 2), vector(27 - v287 + 50, v286 + v287 + 2), color(l_black_0.r, l_black_0.g, l_black_0.b, v283[1]), color(l_black_0.r, l_black_0.g, l_black_0.b, v283[2]), color(l_black_0.r, l_black_0.g, l_black_0.b, v283[3]), color(l_black_0.r, l_black_0.g, l_black_0.b, v283[4]));
end;
local function v295(v290, v291, v292, v293, v294)
    -- upvalues: v289 (ref), v127 (ref)
    v289(v290, v291, v294);
    render.text(v127, vector(17, v291), v292, "\209\129", v293);
end;
local function v299(v296, v297)
    for v298 = 1, #v296 do
        if v296[v298].name == v297 and v296[v298].active then
            return v296[v298].value;
        end;
    end;
    return nil;
end;
local function v304(v300, v301, v302)
    -- upvalues: v299 (ref)
    local v303 = v299(v300, v301);
    return v303 ~= nil and v303 ~= v302;
end;
v122.skeet_indicator = function(_)
    -- upvalues: v19 (ref), v127 (ref), v304 (ref), v0 (ref), v284 (ref), v282 (ref), v295 (ref), v281 (ref)
    if not v19.vis.skeet_indicators:get() then
        return;
    else
        local v306 = ui.get_binds();
        local v307 = render.screen_size();
        local v308 = v19.vis.skeet_indicators.padding:get() + v307.y / 1.75;
        local v309 = 0;
        local v310 = render.measure_text(v127, "c", "DT");
        local v311 = v304(v306, "Min. Damage", v0.dmg:get());
        local v312 = v304(v306, "Hit Chance", v0.hc_find:get());
        local v313 = {
            [1] = {
                y_offset = 0, 
                name = "Double Tap", 
                text = "DT", 
                condition = function()
                    -- upvalues: v19 (ref), v0 (ref)
                    return v19.vis.skeet_indicators.indicators_sel:get("Double Tap") and v0.dt:get();
                end, 
                color = function()
                    -- upvalues: v19 (ref), v284 (ref)
                    if not v19.vis.skeet_indicators.indicators_sel:get("Double Tap") then
                        return v284.dt_inactive;
                    elseif rage.exploit:get() < 1 then
                        return v284.dt_charging;
                    else
                        return v284.dt_ready;
                    end;
                end
            }, 
            [2] = {
                y_offset = -5, 
                name = "Hideshots", 
                text = "ONSHOT", 
                condition = function()
                    -- upvalues: v19 (ref), v0 (ref)
                    return v19.vis.skeet_indicators.indicators_sel:get("Hideshots") and v0.hs:get();
                end, 
                color = function()
                    -- upvalues: v284 (ref)
                    return v284.active;
                end
            }, 
            [3] = {
                y_offset = -5, 
                name = "Dormant Aimbot", 
                text = "DA", 
                condition = function()
                    -- upvalues: v19 (ref), v0 (ref)
                    return v19.vis.skeet_indicators.indicators_sel:get("Dormant Aimbot") and v0.dormant:get();
                end, 
                color = function()
                    -- upvalues: v284 (ref)
                    return v284.active;
                end
            }, 
            [4] = {
                y_offset = -5, 
                name = "Safepoint", 
                text = "SAFE", 
                condition = function()
                    -- upvalues: v19 (ref), v0 (ref)
                    return v19.vis.skeet_indicators.indicators_sel:get("Safepoint") and v0.safe_points:get() == "Force";
                end, 
                color = function()
                    -- upvalues: v284 (ref)
                    return v284.active;
                end
            }, 
            [5] = {
                y_offset = -5, 
                name = "Body Aim", 
                text = "BAIM", 
                condition = function()
                    -- upvalues: v19 (ref), v0 (ref)
                    return v19.vis.skeet_indicators.indicators_sel:get("Body Aim") and v0.bodyaim:get() == "Force";
                end, 
                color = function()
                    -- upvalues: v284 (ref)
                    return v284.active;
                end
            }, 
            [6] = {
                y_offset = -5, 
                name = "Freestanding", 
                text = "Freestanding", 
                condition = function()
                    -- upvalues: v19 (ref), v0 (ref)
                    return v19.vis.skeet_indicators.indicators_sel:get("Freestanding") and v0.fs:get();
                end, 
                color = function()
                    -- upvalues: v284 (ref)
                    return v284.active;
                end
            }, 
            [7] = {
                y_offset = -5, 
                name = "Fake Duck", 
                text = "FD", 
                condition = function()
                    -- upvalues: v19 (ref), v0 (ref)
                    return v19.vis.skeet_indicators.indicators_sel:get("Fake Duck") and v0.fakeduck:get();
                end, 
                color = function()
                    -- upvalues: v284 (ref)
                    return v284.active;
                end
            }, 
            [8] = {
                y_offset = -5, 
                name = "Minimum Damage", 
                condition = function()
                    -- upvalues: v19 (ref), v311 (ref)
                    return v19.vis.skeet_indicators.indicators_sel:get("Minimum Damage") and v311;
                end, 
                color = function()
                    -- upvalues: v284 (ref)
                    return v284.white;
                end, 
                text = function()
                    -- upvalues: v0 (ref)
                    return "DMG: " .. v0.dmg:get();
                end
            }, 
            [9] = {
                y_offset = -10, 
                name = "Hitchance", 
                condition = function()
                    -- upvalues: v19 (ref), v312 (ref)
                    return v19.vis.skeet_indicators.indicators_sel:get("Hitchance") and v312;
                end, 
                color = function()
                    -- upvalues: v284 (ref)
                    return v284.white;
                end, 
                text = function()
                    -- upvalues: v0 (ref)
                    return "HC: " .. v0.hc_find:get();
                end
            }, 
            [10] = {
                y_offset = 2, 
                name = "Ping", 
                text = "PING", 
                condition = function()
                    -- upvalues: v19 (ref), v0 (ref)
                    return v19.vis.skeet_indicators.indicators_sel:get("Ping") and v0.spike:get() ~= 0;
                end, 
                color = function()
                    -- upvalues: v0 (ref)
                    return color(math.max(0, 300 - v0.spike:get()), 207, 52);
                end
            }
        };
        for _, v315 in ipairs(v313) do
            if v315.condition() then
                local v316 = v308 + v309 + v282 + v315.y_offset;
                local v317 = type(v315.text) == "function" and v315.text() or v315.text;
                local v318 = type(v315.color) == "function" and v315.color() or v315.color;
                v295(17, v316, v318, v317, v310.x);
                v309 = v309 + v281;
            end;
        end;
        return;
    end;
end;
v122.scope_overlay = function(_)
    -- upvalues: v19 (ref), v0 (ref)
    local l_r_0 = v19.vis.scope_overlay.color:get().r;
    local l_b_0 = v19.vis.scope_overlay.color:get().b;
    local l_g_0 = v19.vis.scope_overlay.color:get().g;
    a = v19.vis.scope_overlay.color:get().a;
    b = l_g_0;
    g = l_b_0;
    r = l_r_0;
    inverted = v19.vis.scope_overlay.inverted:get();
    screen_size_x = render.screen_size().x;
    screen_size_y = render.screen_size().y;
    lp = entity.get_local_player();
    if not lp then
        return;
    elseif not globals.is_in_game then
        return;
    elseif not v19.vis.scope_overlay:get() then
        return v0.scope:override(nil);
    else
        v0.scope:override("Remove All");
        if entity.get_local_player().m_bIsScoped then
            render.gradient(vector(screen_size_x / 2 + v19.vis.scope_overlay.gap:get() + 1, screen_size_y / 2), vector(screen_size_x / 2 + v19.vis.scope_overlay.gap:get() + v19.vis.scope_overlay.size:get() + 1, screen_size_y / 2 + 1), color(r, g, b, not inverted and a or 0), color(r, g, b, inverted and a or 0), color(r, g, b, not inverted and a or 0), color(r, g, b, inverted and a or 0));
            render.gradient(vector(screen_size_x / 2 - v19.vis.scope_overlay.gap:get(), screen_size_y / 2), vector(screen_size_x / 2 - v19.vis.scope_overlay.gap:get() - v19.vis.scope_overlay.size:get(), screen_size_y / 2 + 1), color(r, g, b, not inverted and a or 0), color(r, g, b, inverted and a or 0), color(r, g, b, not inverted and a or 0), color(r, g, b, inverted and a or 0));
            render.gradient(vector(screen_size_x / 2, screen_size_y / 2 - v19.vis.scope_overlay.gap:get()), vector(screen_size_x / 2 + 1, screen_size_y / 2 - v19.vis.scope_overlay.gap:get() - v19.vis.scope_overlay.size:get()), color(r, g, b, not inverted and a or 0), color(r, g, b, not inverted and a or 0), color(r, g, b, inverted and a or 0), color(r, g, b, inverted and a or 0));
            render.gradient(vector(screen_size_x / 2, screen_size_y / 2 + v19.vis.scope_overlay.gap:get() + 1), vector(screen_size_x / 2 + 1, screen_size_y / 2 + v19.vis.scope_overlay.gap:get() + v19.vis.scope_overlay.size:get() + 1), color(r, g, b, not inverted and a or 0), color(r, g, b, not inverted and a or 0), color(r, g, b, inverted and a or 0), color(r, g, b, inverted and a or 0));
        end;
        return;
    end;
end;
v122.unset_viewmodel = function(_)
    cvar.cl_righthand:float(1);
    cvar.viewmodel_fov:float(tonumber(cvar.viewmodel_fov:string()));
    cvar.viewmodel_offset_x:float(tonumber(cvar.viewmodel_offset_x:string()));
    cvar.viewmodel_offset_y:float(tonumber(cvar.viewmodel_offset_y:string()));
    cvar.viewmodel_offset_z:float(tonumber(cvar.viewmodel_offset_z:string()));
end;
v122.set_viewmodel = function(_)
    -- upvalues: v19 (ref), v122 (ref)
    if not v19.vis.viewmodel:get() then
        return v122:unset_viewmodel();
    else
        cvar.cl_righthand:float(v19.vis.viewmodel.hand:get(), true);
        cvar.viewmodel_fov:float(v19.vis.viewmodel.fov:get() / 10, true);
        cvar.viewmodel_offset_x:float(v19.vis.viewmodel.xoff:get() / 10, true);
        cvar.viewmodel_offset_y:float(v19.vis.viewmodel.yoff:get() / 10, true);
        cvar.viewmodel_offset_z:float(v19.vis.viewmodel.zoff:get() / 10, true);
        return;
    end;
end;
v122.aspect_ratio_handler = function(_)
    -- upvalues: v19 (ref)
    if not v19.vis.aspect:get() then
        return;
    else
        current_aspect_ratio = v19.vis.aspect.slider:get();
        if current_aspect_ratio ~= previous_aspect_ratio then
            previous_aspect_ratio = current_aspect_ratio;
            cvar.r_aspectratio:float(current_aspect_ratio / 100);
        end;
        return;
    end;
end;
v122.scope_animation = function(_, v327, v328, v329, v330)
    if v327 then
        return math.max(v328 + (v329 - v328) * globals.frametime * v330, 0);
    else
        return math.max(v328 - (v329 + v328) * globals.frametime * v330 / 2, 0);
    end;
end;
v122.center_indicator = function(_)
    -- upvalues: v19 (ref), l_gradient_0 (ref), v123 (ref), v122 (ref), v124 (ref), v125 (ref), v126 (ref), v0 (ref)
    if not globals.is_in_game then
        return;
    else
        lp = entity.get_local_player();
        if not lp then
            return;
        elseif not lp:is_alive() then
            return;
        elseif not globals.is_in_game then
            return;
        else
            chrg = rage.exploit:get();
            scoped = lp.m_bIsScoped;
            pulse_alpha = math.sin(globals.realtime * 3) * 127 + 127.5;
            screen_size = render.screen_size() / 2;
            local l_x_0 = screen_size.x;
            y = screen_size.y;
            x = l_x_0;
            if not v19.vis.crosshair_ind:get() then
                return;
            else
                l_x_0 = l_gradient_0.text_animate("VENTURE", -0.9, {
                    color(75, 75, 75, 255), 
                    color(v19.vis.crosshair_ind.accent_col:get().r, v19.vis.crosshair_ind.accent_col:get().g, v19.vis.crosshair_ind.accent_col:get().b, v19.vis.crosshair_ind.accent_col:get().a)
                });
                if v19.vis.crosshair_ind.ind_select:get() == 1 then
                    v123 = v122:scope_animation(scoped, v123, 23, 10) or 0;
                    v124 = v122:scope_animation(scoped, v124, 15, 10) or 0;
                    v125 = v122:scope_animation(scoped, v125, 12, 10) or 0;
                    v126 = v122:scope_animation(scoped, v126, 16, 10) or 0;
                    next_position = 8 + v19.vis.crosshair_ind.gap_add:get();
                    local v333 = false;
                    local v334 = ui.get_binds();
                    for _, v336 in pairs(v334) do
                        if v336.name == "Min. Damage" then
                            v333 = true;
                            break;
                        end;
                    end;
                    if v19.vis.crosshair_ind.bind_add:get("DMG") then
                        if v333 then
                            v122.positions.dmg.target = next_position;
                            v122.positions.dmg.current = v122:lerpik(v122.positions.dmg.current, v122.positions.dmg.target, 0.1);
                            next_position = next_position + 8 + v19.vis.crosshair_ind.gap_add:get();
                        else
                            v122.positions.dmg.current = v122:lerpik(v122.positions.dmg.current, -8, 0.1);
                        end;
                    end;
                    if v19.vis.crosshair_ind.bind_add:get("DT") then
                        if v0.dt:get() then
                            v122.positions.dt.target = next_position;
                            v122.positions.dt.current = v122:lerpik(v122.positions.dt.current, v122.positions.dt.target, 0.1);
                            next_position = next_position + 8 + v19.vis.crosshair_ind.gap_add:get();
                        else
                            v122.positions.dt.current = v122:lerpik(v122.positions.dt.current, -8, 0.1);
                        end;
                    end;
                    v122.positions.aa_state.target = next_position;
                    v122.positions.aa_state.current = v122:lerpik(v122.positions.aa_state.current, v122.positions.aa_state.target, 0.1);
                    local v337 = y + 18;
                    local v338 = v337 + 0;
                    if v19.vis.crosshair_ind.bind_add:get("DT") and v0.dt:get() then
                        local v339 = chrg == 1 and v19.vis.crosshair_ind.bind_col:get() or color(220, 91, 91, 255);
                        local v340 = math.max(v338 + v122.positions.dt.current, v338);
                        render.text(2, vector(x + v123, v340), v339, "c", "DT");
                    end;
                    if v19.vis.crosshair_ind.bind_add:get("DMG") and v333 then
                        local v341 = math.max(v338 + v122.positions.dmg.current, v338);
                        render.text(2, vector(x + v123, v341), v19.vis.crosshair_ind.bind_col:get(), "c", "DMG");
                    end;
                    local v342 = v19.vis.crosshair_ind.text_select:get() == "Venture" and l_x_0:get_animated_text() or "VENTURE";
                    render.text(2, vector(x + v123, v337), v19.vis.crosshair_ind.accent_col:get(), "c", v342);
                elseif v19.vis.crosshair_ind.ind_select:get() == 2 then
                    v123 = v122:scope_animation(scoped, v123, 23, 10) or 0;
                    v124 = v122:scope_animation(scoped, v124, 24, 10) or 0;
                    v125 = v122:scope_animation(scoped, v125, 24, 10) or 0;
                    v126 = v122:scope_animation(scoped, v126, 24, 10) or 0;
                    next_position = 8 + v19.vis.crosshair_ind.gap_add:get();
                    dmg_active = false;
                    active_binds = ui.get_binds();
                    for _, v344 in pairs(active_binds) do
                        if v344.name == "Min. Damage" then
                            dmg_active = true;
                            break;
                        end;
                    end;
                    if v19.vis.crosshair_ind.bind_add:get("DMG") then
                        if dmg_active then
                            v122.positions.dmg.target = next_position;
                            v122.positions.dmg.current = v122:lerpik(v122.positions.dmg.current, v122.positions.dmg.target, 0.1);
                            next_position = next_position + 8 + v19.vis.crosshair_ind.gap_add:get();
                        else
                            v122.positions.dmg.current = v122:lerpik(v122.positions.dmg.current, -8, 0.1);
                        end;
                    end;
                    if v19.vis.crosshair_ind.bind_add:get("DT") then
                        if v0.dt:get() then
                            v122.positions.dt.target = next_position;
                            v122.positions.dt.current = v122:lerpik(v122.positions.dt.current, v122.positions.dt.target, 0.1);
                            next_position = next_position + 8 + v19.vis.crosshair_ind.gap_add:get();
                        else
                            v122.positions.dt.current = v122:lerpik(v122.positions.dt.current, -8, 0.1);
                        end;
                    end;
                    v122.positions.aa_state.target = next_position;
                    v122.positions.aa_state.current = v122:lerpik(v122.positions.aa_state.current, v122.positions.aa_state.target, 0.1);
                    local v345 = y + 18;
                    local v346 = v345 + 0;
                    if v19.vis.crosshair_ind.bind_add:get("DT") and v0.dt:get() then
                        local v347 = chrg == 1 and v19.vis.crosshair_ind.bind_col:get() or color(220, 91, 91, 251);
                        local v348 = math.max(v346 + v122.positions.dt.current, v346);
                        render.text(2, vector(x - 13 + v125, v348), v347, "c", "DT");
                    end;
                    if v19.vis.crosshair_ind.bind_add:get("DMG") and dmg_active then
                        local v349 = math.max(v346 + v122.positions.dmg.current, v346);
                        render.text(2, vector(x - 10 + v124, v349), v19.vis.crosshair_ind.bind_col:get(), "c", "DMG");
                    end;
                    local v350 = v19.vis.crosshair_ind.text_select:get() == "Venture" and l_x_0:get_animated_text() or "VENTURE";
                    render.text(2, vector(x - 3 + v123, v345), v19.vis.crosshair_ind.accent_col:get(), "c", v350);
                end;
                l_x_0:animate();
                return;
            end;
        end;
    end;
end;
local v351 = {};
local v352 = v19.vis.notificaiton_style.max_notifies:get() or 7;
local v353 = 0;
local v354 = 0;
local v355 = render.screen_size();
local v356 = {};
local function v361(v357, v358)
    -- upvalues: v356 (ref)
    local v359 = math.floor(v357 * v358);
    local v360 = "segoe_ui_" .. v359;
    if not v356[v360] then
        v356[v360] = render.load_font("segoe ui", v359, "abd");
    end;
    return v356[v360];
end;
v122.process_notification = function(_, v363, v364)
    -- upvalues: v19 (ref), v351 (ref), v352 (ref)
    local v365 = nil;
    if v364 == nil then
        v365 = "warning";
    elseif type(v364) == "string" then
        v365 = v364;
    elseif type(v364) == "boolean" then
        v365 = v364 and "success" or "warning";
    elseif type(v364) == "table" and v364.r then
        v365 = v364;
    else
        v365 = "warning";
    end;
    local v366 = v19.vis.notificaiton_style.font:get();
    local v367 = v19.vis.notificaiton_style.spacing:get();
    local v368 = 30 * (v366 == 1 and v367 / 10 or 1.5);
    local v369 = v19.vis.notificaiton_style.y_padding:get();
    local v370 = 890 + v369;
    local v371 = {
        message = v363, 
        notification = {
            current_x = 0, 
            alpha = 500, 
            current_y = 920 + v369, 
            target_y = v370 - #v351 * v368, 
            type = v365, 
            creation_time = globals.realtime
        }
    };
    v352 = v19.vis.notificaiton_style.max_notifies:get();
    if #v351 < v352 then
        table.insert(v351, v371);
    else
        v351[nextIndex] = v371;
        nextIndex = nextIndex % v352 + 1;
    end;
    return #v351;
end;
v122.handle_spam_test = function(_)
    -- upvalues: v19 (ref), v353 (ref), v354 (ref), v122 (ref)
    if v19.vis.notificaiton_style.spam_test:get() then
        local l_realtime_0 = globals.realtime;
        if l_realtime_0 - v353 > 2.5 then
            v353 = l_realtime_0;
            local v374 = {
                [1] = "warning", 
                [2] = "success", 
                [3] = "error"
            };
            v354 = v354 % #v374 + 1;
            local v375 = v374[v354];
            local v376 = "Test notification: " .. v375;
            v122:process_notification(v376, v375);
        end;
    end;
end;
v122.render_notifications = function(_)
    -- upvalues: v19 (ref), v351 (ref), v122 (ref), v361 (ref), v355 (ref)
    if v19.vis.notificaiton_style:get() == "Disabled" then
        v351 = {};
        return;
    else
        v122:handle_spam_test();
        if #v351 == 0 then
            return;
        else
            local v378 = v19.vis.notificaiton_style:get();
            local v379 = v19.vis.notificaiton_style.font:get();
            local v380 = v19.vis.notificaiton_style.spacing:get();
            local v381 = v379 == 1 and v380 / 10 or 1.5;
            local v382 = v19.vis.notificaiton_style.y_padding:get();
            local v383 = v361(10, v381);
            v19.vis.notificaiton_style.spacing:disabled(v379 ~= 1);
            font_mapping = {
                [2] = 2, 
                [3] = 1, 
                [1] = v383
            };
            local v384 = 890 + v382;
            for v385 = 1, #v351 do
                local v386 = v379 == 1 and 30 * v381 or 30;
                v351[v385].notification.target_y = v384 - (v385 - 1) * v386;
            end;
            local v387 = 0.05;
            local v388 = v379 == 1 and v387 * v381 or v387;
            for v389 = #v351, 1, -1 do
                local v390 = v351[v389];
                if v390 then
                    local l_notification_0 = v390.notification;
                    l_notification_0.current_y = v122:lerpik(l_notification_0.current_y, l_notification_0.target_y, v388);
                    if globals.realtime - l_notification_0.creation_time > 3 then
                        l_notification_0.alpha = l_notification_0.alpha - 2;
                    end;
                    if l_notification_0.alpha <= 0 then
                        table.remove(v351, v389);
                        for v392 = 1, #v351 do
                            local v393 = v379 == 1 and 30 * v381 or 45;
                            v351[v392].notification.target_y = v384 - (v392 - 1) * v393;
                        end;
                    else
                        local v394 = math.floor(l_notification_0.alpha / 200 * 255);
                        v394 = math.min(v394, 255);
                        local v395 = "";
                        local v396 = color(255, 255, 255, v394);
                        local v397 = nil;
                        local v398 = nil;
                        local l_message_0 = v390.message;
                        if string.find(l_message_0, "\a") then
                            l_message_0 = "\aFFFFFFFF" .. l_message_0;
                        end;
                        if l_notification_0.type == "warning" then
                            v395 = ui.get_icon("triangle-exclamation");
                            v398 = v19.vis.notificaiton_style.warning:get();
                        elseif l_notification_0.type == "success" then
                            v395 = ui.get_icon("circle-check");
                            v398 = v19.vis.notificaiton_style.success:get();
                        elseif l_notification_0.type == "error" then
                            v395 = ui.get_icon("circle-xmark");
                            v398 = v19.vis.notificaiton_style.error:get();
                        elseif type(l_notification_0.type) == "table" and l_notification_0.type.r then
                            v395 = ui.get_icon("triangle-exclamation");
                            v398 = l_notification_0.type;
                        else
                            v395 = ui.get_icon("triangle-exclamation");
                            v398 = v19.vis.notificaiton_style.warning:get();
                        end;
                        if v379 == 2 then
                            v395 = v395 .. "   ";
                            l_message_0 = string.upper(l_message_0);
                        end;
                        v397 = color(v398.r, v398.g, v398.b, v394);
                        if v378 ~= "Disabled" then
                            if v378 == "Sense" then
                                local v400 = font_mapping[v379];
                                local v401 = v395 .. "  " .. l_message_0;
                                local v402 = render.measure_text(v400, "", v401);
                                local v403 = v379 == 1 and 25 or 25;
                                local v404 = v379 == 1 and v403 * v381 or v403;
                                local v405 = v379 == 1 and 30 * v381 or 35;
                                local v406 = v402.x + v405;
                                local v407 = vector(v355.x / 2 + 9 - v406 / 2, l_notification_0.current_y);
                                local v408 = vector(v355.x / 2 - 9 + v406 / 2, l_notification_0.current_y + v404);
                                local v409 = v379 == 1 and v19.vis.notificaiton_style.rounding:get() * v381 or v19.vis.notificaiton_style.rounding:get();
                                v409 = math.min(v409, v404 / 2);
                                render.rect(v407, v408, color(20, 20, 20, v394), v409);
                                local v410 = v379 == 1 and v19.vis.notificaiton_style.shadow_thick:get() * v381 or v19.vis.notificaiton_style.shadow_thick:get();
                                render.shadow(v407, v408, v397, v410, 0, v409);
                                local v411 = vector(v355.x / 2 - v402.x / 2, l_notification_0.current_y + (v404 / 2 - v402.y / 2));
                                render.text(v400, v411, v396, "", "\a" .. v397:to_hex() .. v395 .. " \aFFFFFFFF" .. l_message_0);
                            elseif v378 == "Modern" then
                                local v412 = font_mapping[v379];
                                local v413 = render.measure_text(v412, "", l_message_0);
                                local v414 = render.measure_text(v412, "", v395);
                                local v415 = v379 == 1 and 20 * v381 or 20;
                                local v416 = v413.x + v414.x + v415;
                                local v417 = v355.x / 2 - v416 / 2;
                                local l_current_y_0 = l_notification_0.current_y;
                                local v419 = 22;
                                local v420 = v379 == 1 and v419 * v381 or v419;
                                local v421 = v379 == 1 and v19.vis.notificaiton_style.rounding:get() * v381 or v19.vis.notificaiton_style.rounding:get();
                                local v422 = vector(v417 - (v379 == 1 and 5 * v381 or 5), l_current_y_0);
                                local v423 = vector(v417 + v416 + (v379 == 1 and 5 * v381 or 5), l_current_y_0 + v420);
                                render.rect(v422, v423, color(0, 0, 0, math.floor(v394 * 0.5)), v421);
                                local v424 = (v420 - v414.y) / 2;
                                local v425 = v417 + (v379 == 1 and 5 * v381 or 5);
                                render.text(v412, vector(v425, l_current_y_0 + v424), v397, "", v395);
                                local v426 = v425 + v414.x + (v379 == 1 and 5 * v381 or 5);
                                render.text(v412, vector(v426, l_current_y_0 + v424), v396, "", "\aFFFFFFFF" .. l_message_0);
                            end;
                        end;
                    end;
                end;
            end;
            return;
        end;
    end;
end;
v19.vis.aspect.aspect_ratio_169:set_callback(function()
    -- upvalues: v19 (ref), v122 (ref)
    v19.vis.aspect.slider:set(177);
    v122:process_notification("Aspect ratio changed to 16:9");
end);
v19.vis.aspect.aspect_ratio_1610:set_callback(function()
    -- upvalues: v19 (ref), v122 (ref)
    v19.vis.aspect.slider:set(160);
    v122:process_notification("Aspect ratio changed to 16:10");
end);
v19.vis.aspect.aspect_ratio_32:set_callback(function()
    -- upvalues: v19 (ref), v122 (ref)
    v19.vis.aspect.slider:set(150);
    v122:process_notification("Aspect ratio changed to 3:2");
end);
v19.vis.aspect.aspect_ratio_43:set_callback(function()
    -- upvalues: v19 (ref), v122 (ref)
    v19.vis.aspect.slider:set(133);
    v122:process_notification("Aspect ratio changed to 4:3");
end);
v19.vis.aspect.aspect_ratio_54:set_callback(function()
    -- upvalues: v19 (ref), v122 (ref)
    v19.vis.aspect.slider:set(125);
    v122:process_notification("Aspect ratio changed to 5:4");
end);
v122.aimbot_logs = function(_, v428)
    -- upvalues: v122 (ref), v19 (ref)
    if not entity.get_local_player() then
        return;
    else
        hitbox = v122.hitgroup_str[v428.hitgroup];
        damage = v428.damage or 0;
        hitchance = v428.hitchance;
        backtrack = v428.backtrack;
        wanted_damage = v428.wanted_damage;
        wanted_hitbox = v122.hitgroup_str[v428.wanted_hitgroup];
        reason = v428.state;
        target = entity.get(v428.target);
        name = target:get_name();
        local v429 = target:get_index();
        local v430 = false;
        local v431 = false;
        local v432 = {};
        local l_pairs_0 = pairs;
        local v434 = v122.lagcomp_debug.net_data or {};
        for v435, _ in l_pairs_0(v434) do
            table.insert(v432, tostring(v435));
        end;
        mismatch_damage = " (+0)";
        if wanted_damage < damage then
            mismatch_damage = " (+" .. damage - wanted_damage .. ")";
        end;
        if damage < wanted_damage then
            mismatch_damage = " (-" .. wanted_damage - damage .. ")";
        end;
        if hitbox ~= wanted_hitbox then
            mismatch_hitbox = "(-" .. wanted_hitbox .. ")";
        else
            mismatch_hitbox = "";
        end;
        hit = false;
        unregistered = false;
        missed = false;
        if reason == nil then
            if damage > -1 then
                hit = true;
            elseif damage < 0 then
                unregistered = true;
            end;
        end;
        if reason ~= nil then
            missed = true;
        end;
        l_pairs_0 = "";
        if v430 and v431 then
            l_pairs_0 = "\aFFFFFFFF| Lagcomp & Tickbase";
        elseif v430 then
            l_pairs_0 = "\aFFFFFFFF| Lagcomp Detected";
        elseif v431 then
            l_pairs_0 = "\aFFFFFFFF| Tickbase Shifted";
        end;
        if v19.vis.aimbot_logs:get() then
            if v19.vis.aimbot_logs.console:get() then
                v434 = render.screen_size() / 2;
                local l_x_1 = v434.x;
                local l_y_1 = v434.y;
                local v439 = 240;
                local v440 = 10;
                local v441 = l_x_1 - v439 / 2;
                local v442 = l_y_1 - 125;
                render.rect(vector(v441, v442), vector(v441 + v439, v442 + v440), color(255, 255, 255, 255), 2);
                if hit == true then
                    print_raw(("\a" .. v19.vis.notificaiton_style.success:get():to_hex() .. "Venture\aDEFAULT | Hit %s's %s%s for %s%s damage (%s%s) | (%s ticks)%s"):format(name, hitbox, mismatch_hitbox, damage, mismatch_damage, hitchance, "hc", backtrack, l_pairs_0));
                end;
                if missed == true then
                    print_raw(("\a" .. v19.vis.notificaiton_style.error:get():to_hex() .. "Venture\aDEFAULT | Missed %s's %s for %s damage (%s%s) due to %s | (%s ticks)%s"):format(name, wanted_hitbox, wanted_damage, hitchance, "hc", reason, backtrack, l_pairs_0));
                    if v122.lagcomp_debug.net_data[v429] then
                        local v443 = v122.lagcomp_debug.net_data[v429];
                        v430 = v443.lagcomp or false;
                        v431 = v443.tickbase or false;
                        print_raw("\a" .. v19.vis.notificaiton_style.error:get():to_hex() .. "Venture\aDEFAULT | " .. name .. "[" .. v429 .. "] Missed due to \a" .. v19.vis.notificaiton_style.error:get():to_hex() .. "Lagcomp: \aDEFAULT[\a" .. v19.vis.notificaiton_style.error:get():to_hex() .. tostring(v430) .. "\aDEFAULT]");
                        print_raw("\a" .. v19.vis.notificaiton_style.error:get():to_hex() .. "Venture\aDEFAULT | " .. name .. "[" .. v429 .. "] Missed due to  \a" .. v19.vis.notificaiton_style.error:get():to_hex() .. "Tickbase Shift: \aDEFAULT[\a" .. v19.vis.notificaiton_style.error:get():to_hex() .. tostring(v431) .. "\aDEFAULT]");
                    else
                        print_raw("\a" .. v19.vis.notificaiton_style.error:get():to_hex() .. "Venture\aDEFAULT | Lagcomp: No data for this target");
                    end;
                end;
                if unregistered == true then
                    print_raw(("\a" .. v19.vis.notificaiton_style.error:get():to_hex() .. "Venture\a\aDEFAULT | Missed %s's %s for %s damage (%s%s) due to unregistered shot | (%s ticks)%s"):format(name, wanted_hitbox, wanted_damage, hitchance, "hc", backtrack, l_pairs_0));
                end;
            end;
            if v19.vis.aimbot_logs.notify:get() then
                if hit == true then
                    v122:process_notification(("Hit \a" .. v19.vis.notificaiton_style.success:get():to_hex() .. "%s\aFFFFFFFF's %s%s for \a" .. v19.vis.notificaiton_style.success:get():to_hex() .. "%s damage %s"):format(name, hitbox, mismatch_hitbox, damage, l_pairs_0), true);
                end;
                if missed == true then
                    v122:process_notification(("Missed \a" .. v19.vis.notificaiton_style.error:get():to_hex() .. "%s\aFFFFFFFF due to %s in %s%s"):format(name, reason, wanted_hitbox, l_pairs_0), "error");
                end;
            end;
        end;
        return;
    end;
end;
v122.watermark_drag_object = l_system_0.register({
    [1] = v19.vis.watermark.drag_pos_x, 
    [2] = v19.vis.watermark.drag_pos_y
}, vector(120, 20), "Watermark", function(v444)
    -- upvalues: v19 (ref), l_gradient_0 (ref), v122 (ref)
    local v445 = "venture";
    local v446 = v19.vis.watermark.style:get();
    local v447 = v19.vis.watermark.acc_col:get();
    local v448 = v19.vis.watermark.anim_col:get();
    local v449 = color(v447.r, v447.g, v447.b, v447.a):to_hex();
    local v450 = vector(v444.position.x, v444.position.y);
    local v451 = l_gradient_0.text_animate(v445, -0.7, {
        color(v448.r, v448.g, v448.b, 255), 
        color(v447.r, v447.g, v447.b, v447.a)
    });
    v451:animate();
    local v452 = v451:get_animated_text();
    if v446 == 1 then
        local v453 = true;
        local v454 = "[LIVE]";
        local v455 = v19.vis.watermark.second_col:get():to_hex();
        local v456 = render.measure_text(v122.font_file, nil, string.upper(v445));
        local v457 = render.measure_text(1, nil, v454);
        local v458 = v456.x + (v453 and v457.x + 5 or 0);
        v444.size = vector(v458, v456.y);
        render.text(v122.font_file, v450, color(), nil, string.upper(v452));
        if v453 then
            local v459 = vector(v450.x + v456.x, v450.y);
            render.text(1, v459, color(), nil, "\a" .. v455 .. v454);
        end;
    elseif v446 == 2 then
        local v460 = render.measure_text(1, nil, v445);
        v444.size = vector(v460.x, v460.y);
        render.text(1, v450, color(), nil, "\a" .. v449 .. v452);
    end;
end);
v19.vis.watermark.drag_pos_x:visibility(false);
v19.vis.watermark.drag_pos_y:visibility(false);
if not antiaim then
    antiaim = {
        left_addition = 0, 
        extra_offset_add = 0, 
        yaw_offset_add = 0, 
        right_addition = 0, 
        teams_tbl = {
            [1] = 1, 
            [2] = 2
        }, 
        helpers = {}
    };
end;
antiaim.helpers.get_team = function()
    local v461 = entity.get_local_player();
    if not v461 then
        return antiaim.teams_tbl[1];
    elseif not v461:is_alive() then
        return antiaim.teams_tbl[1];
    elseif v461.m_iTeamNum == 2 then
        return antiaim.teams_tbl[1];
    elseif v461.m_iTeamNum == 3 then
        return antiaim.teams_tbl[2];
    else
        return antiaim.teams_tbl[1];
    end;
end;
antiaim.helpers.get_state = function()
    local v462 = entity.get_local_player();
    if not v462 then
        return "Standing";
    elseif not v462:is_alive() then
        return "Standing";
    else
        local l_m_vecVelocity_1 = v462.m_vecVelocity;
        local v464 = math.sqrt(l_m_vecVelocity_1.x ^ 2 + l_m_vecVelocity_1.y ^ 2);
        local l_m_fFlags_0 = v462.m_fFlags;
        local v466 = bit.band(l_m_fFlags_0, 2) ~= 0;
        if not (bit.band(l_m_fFlags_0, 1) ~= 0) then
            return v466 and "Air Crouch" or "Jumping";
        elseif v466 then
            return v464 > 5 and "Sneaking" or "Crouch";
        elseif v464 >= 81 then
            return "Running";
        elseif v464 >= 3 then
            return "Slowmotion";
        else
            return "Standing";
        end;
    end;
end;
antiaim.get_builder = function(v467)
    -- upvalues: v19 (ref)
    local v468 = v467.helpers.get_team();
    local v469 = v467.helpers.get_state();
    if not v19.aa.builder[v468] then
        print("Error: Team not found in builder:", v468);
        return nil;
    elseif not v19.aa.builder[v468][v469] then
        print("Error: State not found in builder:", v469, "for team:", v468);
        return nil;
    else
        return v19.aa.builder[v468][v469];
    end;
end;
antiaim.initialize_defaults = function(v470)
    if not v470.initialized then
        v470.hidden_pitch = 0;
        v470.extra_offset_add = 0;
        v470.yaw_offset_add = 0;
        v470.yaw_mod_add = "Disabled";
        v470.yaw_mod_offset_add = 0;
        v470.bodyyaw_add = true;
        v470.left_fake_add = 0;
        v470.right_fake_add = 0;
        v470.options_add = "";
        v470.left_addition = 0;
        v470.right_addition = 0;
        v470.hidden_add = false;
        v470.initialized = true;
    end;
end;
antiaim:initialize_defaults();
antiaim.clamp = function(_, v472, v473, v474)
    return math.min(math.max(v472, v473), v474);
end;
antiaim.limit_final_value = function(_, v476, v477)
    if v476 + v477 < -60 then
        v477 = -60 - v476;
        if v477 > 0 then
            v477 = 0;
        end;
    end;
    return v477;
end;
antiaim.setup = function(v478)
    -- upvalues: v0 (ref), v19 (ref)
    v0.base:override("At Target");
    v0.yaw:override("Backward");
    v0.pitch:override("Down");
    local v479 = v478:get_builder();
    local v480 = entity.get_local_player();
    if not v480 then
        return;
    elseif not v480:is_alive() then
        return;
    else
        local v481 = v480.m_flPoseParameter[11] * 120 - 60 > 0;
        if v479.yaw:get() == 1 then
            antiaim.yaw_offset_add = v479.yaw_add:get();
        elseif v479.yaw_brute_enable:get() then
            local v482 = v479.yaw_brute_time:get();
            local v483 = v479.yaw_brute_sliders:get();
            if not antiaim.current_brute_index then
                antiaim.current_brute_index = 1;
                antiaim.last_brute_time = globals.curtime;
            end;
            if v482 <= globals.curtime - antiaim.last_brute_time then
                antiaim.current_brute_index = math.random(1, v483);
                antiaim.last_brute_time = globals.curtime;
            end;
            local v484 = v479["yaw_brute_slider_left" .. antiaim.current_brute_index]:get();
            local v485 = v479["yaw_brute_slider_right" .. antiaim.current_brute_index]:get();
            antiaim.yaw_offset_add = v481 and v484 or v485;
        else
            antiaim.yaw_offset_add = v481 and v479.yaw_add_l:get() or v479.yaw_add_r:get();
        end;
        local v486 = v479.yaw_jitter_add:get();
        local v487 = 0;
        if v479.jitter_random_enable:get() then
            if v479.jitter_random_method:get() == 1 then
                v487 = math.random(v479.jitter_random_min:get(), v479.jitter_random_max:get());
            elseif v479.jitter_random_method:get() == 2 then
                local v488 = v479.jitter_random_sliders:get();
                v487 = v479["jitter_random_slider_values" .. math.random(1, v488)]:get();
            end;
            v486 = v487;
        end;
        if v479.yaw_jitter:get() == 1 then
            if v481 then
                antiaim.extra_offset_add = antiaim.yaw_offset_add;
            else
                antiaim.extra_offset_add = antiaim.yaw_offset_add;
            end;
        elseif v479.yaw_jitter:get() == 2 then
            extra_mod_value = math.abs(v486) / 2;
            if v486 < 0 then
                if v481 then
                    antiaim.extra_offset_add = antiaim.yaw_offset_add - extra_mod_value;
                else
                    antiaim.extra_offset_add = antiaim.yaw_offset_add + extra_mod_value;
                end;
            elseif v481 then
                antiaim.extra_offset_add = antiaim.yaw_offset_add + extra_mod_value;
            else
                antiaim.extra_offset_add = antiaim.yaw_offset_add - extra_mod_value;
            end;
        elseif v479.yaw_jitter:get() == 3 then
            extra_mod_value = v486;
            if v481 then
                antiaim.extra_offset_add = antiaim.yaw_offset_add + extra_mod_value;
            else
                antiaim.extra_offset_add = antiaim.yaw_offset_add + extra_mod_value;
            end;
        elseif v479.yaw_jitter:get() == 4 then
            extra_mod_value = utils.random_int(-v486, v486);
            antiaim.extra_offset_add = antiaim.yaw_offset_add + extra_mod_value;
        elseif v479.yaw_jitter:get() == 5 then
            local v489 = {
                [1] = -1, 
                [2] = 0, 
                [3] = 1
            };
            extra_mod_value = v489[math.floor(globals.commandack / 2) % #v489 + 1] * v486;
            antiaim.extra_offset_add = antiaim.yaw_offset_add + extra_mod_value;
        elseif v479.yaw_jitter:get() == 6 then
            local v490 = {
                [1] = -1, 
                [2] = -0.5, 
                [3] = 0, 
                [4] = 0.5, 
                [5] = 1
            };
            extra_mod_value = v490[math.floor(globals.commandack * 2) % #v490 + 1] * v486;
            antiaim.extra_offset_add = antiaim.yaw_offset_add + extra_mod_value;
        elseif v479.yaw_jitter:get() == 7 then
            local v491 = v479.yaw_jitter_steps:get();
            local v492 = {};
            for v493 = 1, v491 do
                local v494 = -1 + 2 * (v493 - 1) / (v491 - 1);
                table.insert(v492, v494);
            end;
            extra_mod_value = v492[math.floor(globals.commandack / 2) % #v492 + 1] * v486;
            antiaim.extra_offset_add = antiaim.yaw_offset_add + extra_mod_value;
        end;
        antiaim.yaw_offset_add = antiaim.extra_offset_add;
        if v479.hidden:get() then
            if v479.hidden_pitch:get() == "Down" then
                antiaim.hidden_pitch = 89;
            elseif v479.hidden_pitch:get() == "Up" then
                antiaim.hidden_pitch = -89;
            elseif v479.hidden_pitch:get() == "Custom" then
                antiaim.hidden_pitch = v479.hidden_pitch_custom:get();
            elseif v479.hidden_pitch:get() == "2-Way" then
                if v481 then
                    antiaim.hidden_pitch = v479.hidden_pitch_add:get();
                else
                    antiaim.hidden_pitch = v479.hidden_pitch_add2:get();
                end;
            end;
            antiaim.hidden_add = true;
        else
            antiaim.hidden_add = false;
        end;
        if v19.aa.addons:get("bWarmupPeriod Antiaim") then
            players = entity.get_players(true);
            local_player = entity.get_local_player();
            alive_players_count = 0;
            game_rules = entity.get_game_rules();
            is_warmup = game_rules and game_rules.m_bWarmupPeriod;
            round_active = game_rules and game_rules.m_bHasMatchStarted and not game_rules.m_bMatchWaitingForResume and not game_rules.m_bGameRestart;
            for v495 = 1, #players do
                local v496 = players[v495];
                if v496 and v496:is_alive() then
                    alive_players_count = alive_players_count + 1;
                end;
            end;
            local v497 = globals.curtime * 2;
            local v498 = globals.tickcount * 20 % 360 + math.sin(v497 * 5) * 25;
            local _ = globals.tickcount * 20 % 360 - 360;
            if alive_players_count == 0 and local_player:is_alive() or is_warmup or not round_active then
                antiaim.yaw_offset_add = v498;
                antiaim.hidden_pitch = -20;
                antiaim.hidden_add = true;
                rage.exploit:allow_defensive(true);
            end;
        end;
        local v500 = v19.aa.manuals:get();
        local v501 = v19.aa.manuals.block:get();
        local v502 = v19.aa.freestanding:get();
        local v503 = v19.aa.freestanding.block:get();
        local v504 = v479.body:get();
        antiaim.options_add = "";
        v0.fs:override(nil);
        v479.body:override(nil);
        if v502 then
            v0.fs:override(true);
            if not v503 and v504 == "Jitter" then
                antiaim.options_add = "Jitter";
            end;
        end;
        if v500 == "Left" then
            antiaim.yaw_offset_add = -90;
            if not v501 and v504 == "Jitter" then
                antiaim.options_add = "Jitter";
            else
                antiaim.options_add = "";
            end;
        elseif v500 == "Right" then
            antiaim.yaw_offset_add = 90;
            if v501 then
                v479.body:override("Static");
            else
                v479.body:override(nil);
                if v504 == "Jitter" then
                    antiaim.options_add = "Jitter";
                else
                    antiaim.options_add = "";
                end;
            end;
        elseif v500 == "Disabled" and not v502 and v504 == "Jitter" then
            antiaim.options_add = "Jitter";
        end;
        if not entity.get_local_player():get_player_weapon() then
            return;
        else
            local v505 = entity.get_local_player():get_player_weapon():get_classname();
            local v506 = false;
            if v19.aa.safe_head:get() and v478.helpers.get_state() == "Air Crouch" and string.match(v505, "Knife") then
                v506 = true;
                antiaim.yaw_mod_add = "Disabled";
                antiaim.options_add = "";
                antiaim.yaw_offset_add = 0;
                v0.inverter:override(true);
                antiaim.hidden_add = false;
            end;
            if v479.body_mode:get() == 2 then
                if globals.commandack % v479.body_switcher:get() < v479.body_switcher:get() / 2 then
                    v0.bodyyaw:override(true);
                else
                    v0.bodyyaw:override(false);
                end;
            else
                v0.bodyyaw:override(true);
            end;
            if v479.body_add_mode:get() == 1 then
                antiaim.left_addition = v479.body_add_l:get();
                antiaim.right_addition = v479.body_add_r:get();
            else
                local v507 = antiaim:clamp(v479.body_random_min:get(), 0, 60);
                local v508 = antiaim:clamp(v479.body_random_max:get(), 0, 60);
                if v508 < v507 then
                    v507 = v508;
                end;
                antiaim.left_addition = math.random(v507, v508);
                antiaim.right_addition = math.random(v507, v508);
            end;
            local v509 = v479.delay_add:get() or 1;
            if v479.delay_random_enable:get() == true then
                local v510 = math.floor(globals.commandack / 10);
                if not delay_cache then
                    delay_cache = {
                        last_cycle = -1
                    };
                end;
                if v479.delay_random_method:get() == 1 then
                    if v510 ~= delay_cache.last_cycle then
                        delay_cache.random_value = math.random(v479.delay_random_min:get(), v479.delay_random_max:get());
                        delay_cache.last_cycle = v510;
                    end;
                    v509 = delay_cache.random_value;
                elseif v479.delay_random_method:get() == 2 then
                    if v510 ~= delay_cache.last_cycle then
                        local v511 = v479.delay_random_sliders:get();
                        local v512 = v479["delay_random_slider_values" .. math.random(1, v511)]:get();
                        delay_cache.random_value = v512 or 1;
                        delay_cache.last_cycle = v510;
                    end;
                    v509 = delay_cache.random_value;
                end;
            end;
            if v479.body_delay:get() == 1 then
                antiaim.left_fake_add = antiaim.left_addition;
                antiaim.right_fake_add = antiaim.right_addition;
            end;
            if v479.body_delay:get() == 2 then
                if v509 == 1 or v506 == true then
                    antiaim.left_fake_add = antiaim.left_addition;
                    antiaim.right_fake_add = antiaim.right_addition;
                elseif globals.commandack % (v509 * 2) < v509 then
                    antiaim.left_fake_add = -antiaim.left_addition;
                    antiaim.right_fake_add = antiaim.right_addition;
                else
                    antiaim.left_fake_add = antiaim.left_addition;
                    antiaim.right_fake_add = -antiaim.right_addition;
                end;
            elseif v479.body_delay:get() == 3 then
                if v509 == 1 or v506 == true then
                    antiaim.left_fake_add = antiaim.left_addition;
                    antiaim.right_fake_add = antiaim.right_addition;
                    rage.antiaim:inverter(true);
                elseif globals.commandack % (v509 * 2) < v509 then
                    rage.antiaim:inverter(true);
                else
                    rage.antiaim:inverter(false);
                end;
            end;
            if v479.tickbase:get() ~= "Neverlose" then
                if v479.tickbase_method:get() == 1 then
                    rage.exploit:allow_defensive(globals.tickcount % math.random(v479.tickbase_random_min:get(), v479.tickbase_random_max:get()) == 0);
                elseif v479.tickbase_method:get() == 2 then
                    local v513 = v479.tickbase_random_sliders:get();
                    local v514 = v479["jitter_random_slider_values" .. math.random(1, v513)]:get();
                    rage.exploit:allow_defensive(globals.tickcount % v514 == 0);
                end;
                is_defensive = v19.aa.force_defensive:get(v478.helpers:get_state());
                hideshot_type = v19.aa.hs_defensive:get();
                if is_defensive then
                    v0.dtlag:override("Always On");
                    v0.hslag:override(hideshot_type);
                    return true;
                else
                    v0.hslag:override(nil);
                    v0.dtlag:override(nil);
                    return false;
                end;
            else
                return;
            end;
        end;
    end;
end;
local function v515()
    -- upvalues: v0 (ref)
    v0.yawoffset:override(antiaim.yaw_offset_add);
    v0.leftlimit:override(antiaim.left_fake_add);
    v0.rightlimit:override(antiaim.right_fake_add);
    v0.options:override(antiaim.options_add);
    rage.antiaim:override_hidden_pitch(antiaim.hidden_pitch);
    rage.antiaim:override_hidden_yaw_offset(0);
    v0.hidden:override(antiaim.hidden_add);
    v0.modifier:override(antiaim.yaw_mod_add);
    v0.modoffset:override(antiaim.yaw_mod_offset_add);
end;
configs = {
    aa_cfg = l_pui_0.setup(v19.aa.builder, true), 
    cfg_database = db.venture_cfgs_live_1 or {}, 
    default_configs = {
        [1] = {
            name = "\aFF2727FF\226\128\162    \aDEFAULTDefault", 
            settings = "{\"angles\":{\"builder\":[{\"Air Crouch\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":58.0,\"body_random_min\":60.0,\"body_switcher\":3.0,\"delay_add\":2.0,\"delay_random_enable\":true,\"delay_random_max\":4.0,\"delay_random_method\":2.0,\"delay_random_min\":2.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":4.0,\"delay_random_slider_values3\":7.0,\"delay_random_slider_values4\":3.0,\"delay_random_slider_values5\":3.0,\"delay_random_slider_values6\":2.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":4.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":11.0,\"jitter_random_method\":2.0,\"jitter_random_min\":-4.0,\"jitter_random_slider_values1\":13.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":-7.0,\"jitter_random_slider_values4\":-11.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Venture\",\"tickbase_method\":1.0,\"tickbase_random_max\":22.0,\"tickbase_random_min\":2.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-11.0,\"yaw_add_r\":39.0,\"yaw_brute_enable\":true,\"yaw_brute_slider_left1\":-20.0,\"yaw_brute_slider_left2\":-11.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":36.0,\"yaw_brute_slider_right2\":41.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":2.0,\"yaw_brute_time\":10.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":-11.0,\"yaw_jitter_steps\":3.0},\"Crouch\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":2.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":60.0,\"body_random_min\":52.0,\"body_switcher\":16.0,\"delay_add\":1.0,\"delay_random_enable\":true,\"delay_random_max\":6.0,\"delay_random_method\":1.0,\"delay_random_min\":5.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":10.0,\"jitter_random_method\":2.0,\"jitter_random_min\":5.0,\"jitter_random_slider_values1\":-11.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-24.0,\"yaw_add_r\":42.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":5.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Jumping\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":1.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":1.0,\"delay_random_enable\":true,\"delay_random_max\":4.0,\"delay_random_method\":1.0,\"delay_random_min\":7.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":3.0,\"delay_random_slider_values3\":4.0,\"delay_random_slider_values4\":3.0,\"delay_random_slider_values5\":4.0,\"delay_random_slider_values6\":2.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":3.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":0.0,\"jitter_random_method\":2.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":-6.0,\"jitter_random_slider_values2\":4.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":0.0,\"yaw_add_r\":0.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Running\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":16.0,\"delay_add\":2.0,\"delay_random_enable\":true,\"delay_random_max\":7.0,\"delay_random_method\":2.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":6.0,\"delay_random_slider_values2\":4.0,\"delay_random_slider_values3\":2.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":3.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":0.0,\"jitter_random_method\":2.0,\"jitter_random_min\":-3.0,\"jitter_random_slider_values1\":12.0,\"jitter_random_slider_values2\":15.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":14.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-27.0,\"yaw_add_r\":41.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":-3.0,\"yaw_jitter_steps\":3.0},\"Slowmotion\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":2.0,\"delay_random_enable\":false,\"delay_random_max\":2.0,\"delay_random_method\":1.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":0.0,\"jitter_random_method\":2.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":4.0,\"jitter_random_slider_values2\":11.0,\"jitter_random_slider_values3\":2.0,\"jitter_random_slider_values4\":13.0,\"jitter_random_slider_values5\":7.0,\"jitter_random_slider_values6\":1.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-25.0,\"yaw_add_r\":42.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":5.0,\"yaw_jitter_add\":-29.0,\"yaw_jitter_steps\":3.0},\"Sneaking\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":53.0,\"body_switcher\":3.0,\"delay_add\":5.0,\"delay_random_enable\":true,\"delay_random_max\":7.0,\"delay_random_method\":1.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":2.0,\"delay_random_slider_values3\":10.0,\"delay_random_slider_values4\":5.0,\"delay_random_slider_values5\":3.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":5.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":8.0,\"jitter_random_method\":1.0,\"jitter_random_min\":-8.0,\"jitter_random_slider_values1\":0.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":1.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":5.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-19.0,\"yaw_add_r\":38.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":2.0,\"yaw_jitter_add\":-8.0,\"yaw_jitter_steps\":3.0},\"Standing\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":1.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":4.0,\"delay_random_enable\":false,\"delay_random_max\":14.0,\"delay_random_method\":1.0,\"delay_random_min\":2.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":false,\"jitter_random_max\":0.0,\"jitter_random_method\":1.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":0.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":1.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-20.0,\"yaw_add_r\":36.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0}},{\"Air Crouch\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":58.0,\"body_random_min\":60.0,\"body_switcher\":3.0,\"delay_add\":2.0,\"delay_random_enable\":true,\"delay_random_max\":4.0,\"delay_random_method\":2.0,\"delay_random_min\":2.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":4.0,\"delay_random_slider_values3\":7.0,\"delay_random_slider_values4\":3.0,\"delay_random_slider_values5\":3.0,\"delay_random_slider_values6\":2.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":4.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":11.0,\"jitter_random_method\":2.0,\"jitter_random_min\":-4.0,\"jitter_random_slider_values1\":13.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":-7.0,\"jitter_random_slider_values4\":-11.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Venture\",\"tickbase_method\":1.0,\"tickbase_random_max\":22.0,\"tickbase_random_min\":2.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-11.0,\"yaw_add_r\":39.0,\"yaw_brute_enable\":true,\"yaw_brute_slider_left1\":-20.0,\"yaw_brute_slider_left2\":-11.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":36.0,\"yaw_brute_slider_right2\":41.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":2.0,\"yaw_brute_time\":10.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":-11.0,\"yaw_jitter_steps\":3.0},\"Crouch\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":2.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":60.0,\"body_random_min\":52.0,\"body_switcher\":16.0,\"delay_add\":1.0,\"delay_random_enable\":true,\"delay_random_max\":6.0,\"delay_random_method\":1.0,\"delay_random_min\":5.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":10.0,\"jitter_random_method\":2.0,\"jitter_random_min\":5.0,\"jitter_random_slider_values1\":-11.0,\"jitter_random_slider_values2\":11.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-24.0,\"yaw_add_r\":42.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":5.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Jumping\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":1.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":1.0,\"delay_random_enable\":true,\"delay_random_max\":4.0,\"delay_random_method\":1.0,\"delay_random_min\":7.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":3.0,\"delay_random_slider_values3\":4.0,\"delay_random_slider_values4\":3.0,\"delay_random_slider_values5\":4.0,\"delay_random_slider_values6\":2.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":3.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":0.0,\"jitter_random_method\":2.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":-6.0,\"jitter_random_slider_values2\":4.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":0.0,\"yaw_add_r\":0.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Running\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":16.0,\"delay_add\":2.0,\"delay_random_enable\":true,\"delay_random_max\":7.0,\"delay_random_method\":2.0,\"delay_random_min\":7.0,\"delay_random_slider_values1\":6.0,\"delay_random_slider_values2\":4.0,\"delay_random_slider_values3\":2.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":3.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":1.0,\"jitter_random_method\":2.0,\"jitter_random_min\":-3.0,\"jitter_random_slider_values1\":12.0,\"jitter_random_slider_values2\":15.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":14.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-27.0,\"yaw_add_r\":41.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":2.0,\"yaw_jitter_add\":-3.0,\"yaw_jitter_steps\":3.0},\"Slowmotion\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":2.0,\"delay_random_enable\":false,\"delay_random_max\":2.0,\"delay_random_method\":1.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":0.0,\"jitter_random_method\":2.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":4.0,\"jitter_random_slider_values2\":11.0,\"jitter_random_slider_values3\":2.0,\"jitter_random_slider_values4\":13.0,\"jitter_random_slider_values5\":7.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-25.0,\"yaw_add_r\":42.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":5.0,\"yaw_jitter_add\":-29.0,\"yaw_jitter_steps\":3.0},\"Sneaking\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":53.0,\"body_switcher\":3.0,\"delay_add\":5.0,\"delay_random_enable\":true,\"delay_random_max\":7.0,\"delay_random_method\":2.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":2.0,\"delay_random_slider_values3\":10.0,\"delay_random_slider_values4\":5.0,\"delay_random_slider_values5\":3.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":5.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":8.0,\"jitter_random_method\":1.0,\"jitter_random_min\":-8.0,\"jitter_random_slider_values1\":0.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":1.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":5.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-19.0,\"yaw_add_r\":38.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":2.0,\"yaw_jitter_add\":-8.0,\"yaw_jitter_steps\":3.0},\"Standing\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":1.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":4.0,\"delay_random_enable\":false,\"delay_random_max\":14.0,\"delay_random_method\":1.0,\"delay_random_min\":2.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":false,\"jitter_random_max\":0.0,\"jitter_random_method\":1.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":0.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":1.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-20.0,\"yaw_add_r\":36.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0}}],\"settings\":{\"force_defensive\":[\"Standing\",\"Slowmotion\",\"Crouch\",\"Sneaking\",\"Jumping\",\"Air Crouch\",\"~\"],\"hs_defensive\":\"Break LC\",\"safe_head\":true}},\"enabled_sections\":[\"angles\",\"visuals\",\"mods\"],\"mods\":{\"animation_air\":2.0,\"animation_allow\":true,\"animation_lean\":100.0,\"animation_run\":1.0,\"animation_select\":\"Mods\",\"animation_shake\":0.0,\"auto_teleport\":false,\"fake_latency\":false,\"fakeduck_speed\":false,\"fast_ladder\":false,\"forcebaim\":false,\"super_toss\":false,\"zero_pitch\":-1.0,\"~animation_air\":{\"custom\":100.0},\"~animation_run\":{\"custom\":100.0},\"~animation_shake\":{\"custom\":0.0,\"max\":100.0,\"min\":20.0},\"~fake_latency\":{\"amount\":116.0},\"~forcebaim\":{\"hp\":75.0,\"select\":[\"~\"]}},\"visuals\":{\"aimbot_logs\":true,\"aspect\":true,\"crosshair_ind\":false,\"damage_indicator\":false,\"enemy_lagcomp\":false,\"notificaiton_style\":\"Modern\",\"optimize_cvars\":false,\"scope_overlay\":true,\"skeet_indicators\":false,\"viewmodel\":true,\"watermark\":{\"acc_col\":\"#6884FFFF\",\"anim_col\":\"#FFFFFFFF\",\"custom_name\":\"\195\175\194\157\194\162  Venture\",\"drag_pos_x\":1804.0,\"drag_pos_y\":510.0,\"second_col\":\"#EB6161FF\",\"style\":1.0,\"toggle\":false},\"~aimbot_logs\":{\"console\":true,\"notify\":true},\"~aspect\":{\"slider\":133.0},\"~crosshair_ind\":{\"accent_col\":\"#B6C0E4FF\",\"bind_add\":[\"~\"],\"bind_col\":\"#D6BDDEFF\",\"gap_add\":1.0,\"ind_select\":1.0,\"text_select\":\"Venture\"},\"~damage_indicator\":{\"color\":\"#FFFFFFFF\",\"font\":1.0},\"~enemy_lagcomp\":{\"*box_color\":\"#2F75DDFF\",\"*text_color\":\"#FF2D2DFF\",\"box_color\":false,\"text_color\":false},\"~notificaiton_style\":{\"error\":\"#FF3232FF\",\"font\":1.0,\"max_notifies\":3.0,\"rounding\":5.0,\"shadow_thick\":35.0,\"spacing\":13.0,\"spam_test\":false,\"success\":\"#00C800FF\",\"warning\":\"#FF8C00FF\",\"y_padding\":0.0},\"~scope_overlay\":{\"color\":\"#FFFFFFFF\",\"gap\":5.0,\"inverted\":false,\"size\":67.0},\"~skeet_indicators\":{\"indicators_sel\":[\"~\"],\"padding\":0.0},\"~viewmodel\":{\"fov\":746.0,\"hand\":0.0,\"xoff\":-10.0,\"yoff\":-7.0,\"zoff\":7.0}}}"
        }, 
        [2] = {
            name = "\a34FF27FF\226\128\162    \aDEFAULTSlowed", 
            settings = "{\"angles\":{\"builder\":[{\"Air Crouch\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":58.0,\"body_random_min\":53.0,\"body_switcher\":3.0,\"delay_add\":2.0,\"delay_random_enable\":true,\"delay_random_max\":4.0,\"delay_random_method\":1.0,\"delay_random_min\":7.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":4.0,\"delay_random_slider_values3\":4.0,\"delay_random_slider_values4\":4.0,\"delay_random_slider_values5\":2.0,\"delay_random_slider_values6\":2.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":11.0,\"jitter_random_method\":1.0,\"jitter_random_min\":-4.0,\"jitter_random_slider_values1\":7.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":-11.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":5.0,\"tickbase\":\"Venture\",\"tickbase_method\":1.0,\"tickbase_random_max\":22.0,\"tickbase_random_min\":2.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-15.0,\"yaw_add_r\":38.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":-11.0,\"yaw_jitter_steps\":3.0},\"Crouch\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":2.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":60.0,\"body_random_min\":52.0,\"body_switcher\":16.0,\"delay_add\":1.0,\"delay_random_enable\":true,\"delay_random_max\":6.0,\"delay_random_method\":1.0,\"delay_random_min\":5.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":10.0,\"jitter_random_method\":2.0,\"jitter_random_min\":5.0,\"jitter_random_slider_values1\":-11.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-24.0,\"yaw_add_r\":42.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":5.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Jumping\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":1.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":3.0,\"delay_random_enable\":false,\"delay_random_max\":4.0,\"delay_random_method\":1.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":3.0,\"delay_random_slider_values3\":4.0,\"delay_random_slider_values4\":3.0,\"delay_random_slider_values5\":4.0,\"delay_random_slider_values6\":2.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":3.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":0.0,\"jitter_random_method\":2.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":-6.0,\"jitter_random_slider_values2\":4.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-14.0,\"yaw_add_r\":25.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":5.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Running\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":16.0,\"delay_add\":2.0,\"delay_random_enable\":true,\"delay_random_max\":7.0,\"delay_random_method\":2.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":6.0,\"delay_random_slider_values2\":4.0,\"delay_random_slider_values3\":2.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":3.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":0.0,\"jitter_random_method\":2.0,\"jitter_random_min\":-3.0,\"jitter_random_slider_values1\":12.0,\"jitter_random_slider_values2\":15.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":14.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-27.0,\"yaw_add_r\":41.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":-3.0,\"yaw_jitter_steps\":3.0},\"Slowmotion\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":2.0,\"delay_random_enable\":false,\"delay_random_max\":2.0,\"delay_random_method\":1.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":0.0,\"jitter_random_method\":2.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":4.0,\"jitter_random_slider_values2\":11.0,\"jitter_random_slider_values3\":2.0,\"jitter_random_slider_values4\":13.0,\"jitter_random_slider_values5\":7.0,\"jitter_random_slider_values6\":1.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-25.0,\"yaw_add_r\":42.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":5.0,\"yaw_jitter_add\":-29.0,\"yaw_jitter_steps\":3.0},\"Sneaking\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":53.0,\"body_switcher\":3.0,\"delay_add\":5.0,\"delay_random_enable\":true,\"delay_random_max\":7.0,\"delay_random_method\":1.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":2.0,\"delay_random_slider_values3\":10.0,\"delay_random_slider_values4\":5.0,\"delay_random_slider_values5\":3.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":5.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":8.0,\"jitter_random_method\":1.0,\"jitter_random_min\":-8.0,\"jitter_random_slider_values1\":0.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":1.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":5.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-19.0,\"yaw_add_r\":38.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":2.0,\"yaw_jitter_add\":-8.0,\"yaw_jitter_steps\":3.0},\"Standing\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":1.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":4.0,\"delay_random_enable\":false,\"delay_random_max\":14.0,\"delay_random_method\":1.0,\"delay_random_min\":2.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":false,\"jitter_random_max\":0.0,\"jitter_random_method\":1.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":0.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":1.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-20.0,\"yaw_add_r\":36.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0}},{\"Air Crouch\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":58.0,\"body_random_min\":53.0,\"body_switcher\":3.0,\"delay_add\":2.0,\"delay_random_enable\":true,\"delay_random_max\":4.0,\"delay_random_method\":1.0,\"delay_random_min\":7.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":4.0,\"delay_random_slider_values3\":4.0,\"delay_random_slider_values4\":4.0,\"delay_random_slider_values5\":2.0,\"delay_random_slider_values6\":2.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":11.0,\"jitter_random_method\":1.0,\"jitter_random_min\":-4.0,\"jitter_random_slider_values1\":7.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":-11.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":5.0,\"tickbase\":\"Venture\",\"tickbase_method\":1.0,\"tickbase_random_max\":22.0,\"tickbase_random_min\":2.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-15.0,\"yaw_add_r\":38.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":-11.0,\"yaw_jitter_steps\":3.0},\"Crouch\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":2.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":60.0,\"body_random_min\":52.0,\"body_switcher\":16.0,\"delay_add\":1.0,\"delay_random_enable\":true,\"delay_random_max\":6.0,\"delay_random_method\":1.0,\"delay_random_min\":5.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":10.0,\"jitter_random_method\":2.0,\"jitter_random_min\":5.0,\"jitter_random_slider_values1\":-11.0,\"jitter_random_slider_values2\":11.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-24.0,\"yaw_add_r\":42.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":5.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Jumping\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":1.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":3.0,\"delay_random_enable\":false,\"delay_random_max\":4.0,\"delay_random_method\":1.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":3.0,\"delay_random_slider_values3\":4.0,\"delay_random_slider_values4\":3.0,\"delay_random_slider_values5\":4.0,\"delay_random_slider_values6\":2.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":3.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":0.0,\"jitter_random_method\":2.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":-6.0,\"jitter_random_slider_values2\":4.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-14.0,\"yaw_add_r\":25.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":5.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Running\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":16.0,\"delay_add\":2.0,\"delay_random_enable\":true,\"delay_random_max\":7.0,\"delay_random_method\":2.0,\"delay_random_min\":7.0,\"delay_random_slider_values1\":6.0,\"delay_random_slider_values2\":4.0,\"delay_random_slider_values3\":2.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":3.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":1.0,\"jitter_random_method\":2.0,\"jitter_random_min\":-3.0,\"jitter_random_slider_values1\":12.0,\"jitter_random_slider_values2\":15.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":14.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-27.0,\"yaw_add_r\":41.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":2.0,\"yaw_jitter_add\":-3.0,\"yaw_jitter_steps\":3.0},\"Slowmotion\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":2.0,\"delay_random_enable\":false,\"delay_random_max\":2.0,\"delay_random_method\":1.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":0.0,\"jitter_random_method\":2.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":4.0,\"jitter_random_slider_values2\":11.0,\"jitter_random_slider_values3\":2.0,\"jitter_random_slider_values4\":13.0,\"jitter_random_slider_values5\":7.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-25.0,\"yaw_add_r\":42.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":5.0,\"yaw_jitter_add\":-29.0,\"yaw_jitter_steps\":3.0},\"Sneaking\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":53.0,\"body_switcher\":3.0,\"delay_add\":5.0,\"delay_random_enable\":true,\"delay_random_max\":7.0,\"delay_random_method\":2.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":2.0,\"delay_random_slider_values3\":10.0,\"delay_random_slider_values4\":5.0,\"delay_random_slider_values5\":3.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":5.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":8.0,\"jitter_random_method\":1.0,\"jitter_random_min\":-8.0,\"jitter_random_slider_values1\":0.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":1.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":5.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-19.0,\"yaw_add_r\":38.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":2.0,\"yaw_jitter_add\":-8.0,\"yaw_jitter_steps\":3.0},\"Standing\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":1.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":4.0,\"delay_random_enable\":false,\"delay_random_max\":14.0,\"delay_random_method\":1.0,\"delay_random_min\":2.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":false,\"jitter_random_max\":0.0,\"jitter_random_method\":1.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":0.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":1.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-20.0,\"yaw_add_r\":36.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0}}],\"settings\":{\"force_defensive\":[\"Standing\",\"Slowmotion\",\"Crouch\",\"Sneaking\",\"Jumping\",\"Air Crouch\",\"~\"],\"hs_defensive\":\"Break LC\",\"safe_head\":true}},\"enabled_sections\":[\"angles\",\"visuals\",\"mods\"],\"mods\":{\"animation_air\":2.0,\"animation_allow\":true,\"animation_lean\":100.0,\"animation_run\":1.0,\"animation_select\":\"States\",\"animation_shake\":0.0,\"auto_teleport\":false,\"fake_latency\":false,\"fakeduck_speed\":false,\"fast_ladder\":false,\"forcebaim\":false,\"super_toss\":false,\"zero_pitch\":-1.0,\"~animation_air\":{\"custom\":100.0},\"~animation_run\":{\"custom\":100.0},\"~animation_shake\":{\"custom\":0.0,\"max\":100.0,\"min\":20.0},\"~fake_latency\":{\"amount\":116.0},\"~forcebaim\":{\"hp\":75.0,\"select\":[\"~\"]}},\"visuals\":{\"aimbot_logs\":true,\"aspect\":true,\"crosshair_ind\":false,\"damage_indicator\":false,\"enemy_lagcomp\":false,\"notificaiton_style\":\"Modern\",\"optimize_cvars\":false,\"scope_overlay\":true,\"skeet_indicators\":false,\"viewmodel\":true,\"watermark\":{\"acc_col\":\"#6884FFFF\",\"anim_col\":\"#FFFFFFFF\",\"custom_name\":\"\195\175\194\157\194\162  Venture\",\"drag_pos_x\":1804.0,\"drag_pos_y\":510.0,\"second_col\":\"#EB6161FF\",\"style\":1.0,\"toggle\":false},\"~aimbot_logs\":{\"console\":true,\"notify\":true},\"~aspect\":{\"slider\":133.0},\"~crosshair_ind\":{\"accent_col\":\"#B6C0E4FF\",\"bind_add\":[\"~\"],\"bind_col\":\"#D6BDDEFF\",\"gap_add\":1.0,\"ind_select\":1.0,\"text_select\":\"Venture\"},\"~damage_indicator\":{\"color\":\"#FFFFFFFF\",\"font\":1.0},\"~enemy_lagcomp\":{\"*box_color\":\"#2F75DDFF\",\"*text_color\":\"#FF2D2DFF\",\"box_color\":false,\"text_color\":false},\"~notificaiton_style\":{\"error\":\"#FF3232FF\",\"font\":1.0,\"max_notifies\":3.0,\"rounding\":5.0,\"shadow_thick\":35.0,\"spacing\":13.0,\"spam_test\":false,\"success\":\"#00C800FF\",\"warning\":\"#FF8C00FF\",\"y_padding\":0.0},\"~scope_overlay\":{\"color\":\"#FFFFFFFF\",\"gap\":5.0,\"inverted\":false,\"size\":67.0},\"~skeet_indicators\":{\"indicators_sel\":[\"~\"],\"padding\":0.0},\"~viewmodel\":{\"fov\":746.0,\"hand\":0.0,\"xoff\":-10.0,\"yoff\":-7.0,\"zoff\":7.0}}}"
        }, 
        [3] = {
            name = "\aE7FF42FF\226\128\162    \aDEFAULTAggressive - \a{Link Active}meta", 
            settings = "{\"angles\":{\"builder\":[{\"Air Crouch\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":58.0,\"body_random_min\":53.0,\"body_switcher\":3.0,\"delay_add\":7.0,\"delay_random_enable\":true,\"delay_random_max\":4.0,\"delay_random_method\":1.0,\"delay_random_min\":2.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":14.0,\"delay_random_slider_values3\":10.0,\"delay_random_slider_values4\":5.0,\"delay_random_slider_values5\":3.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":6.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":11.0,\"jitter_random_method\":2.0,\"jitter_random_min\":-11.0,\"jitter_random_slider_values1\":11.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":-11.0,\"jitter_random_slider_values4\":-7.0,\"jitter_random_slider_values5\":7.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":5.0,\"tickbase\":\"Venture\",\"tickbase_method\":1.0,\"tickbase_random_max\":22.0,\"tickbase_random_min\":2.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-20.0,\"yaw_add_r\":45.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":2.0,\"yaw_jitter_add\":-11.0,\"yaw_jitter_steps\":3.0},\"Crouch\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":2.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":60.0,\"body_random_min\":52.0,\"body_switcher\":16.0,\"delay_add\":1.0,\"delay_random_enable\":true,\"delay_random_max\":9.0,\"delay_random_method\":1.0,\"delay_random_min\":3.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":10.0,\"jitter_random_method\":2.0,\"jitter_random_min\":5.0,\"jitter_random_slider_values1\":-8.0,\"jitter_random_slider_values2\":11.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-19.0,\"yaw_add_r\":32.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":5.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Jumping\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":1.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":1.0,\"delay_random_enable\":true,\"delay_random_max\":4.0,\"delay_random_method\":1.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":3.0,\"delay_random_slider_values3\":4.0,\"delay_random_slider_values4\":3.0,\"delay_random_slider_values5\":4.0,\"delay_random_slider_values6\":2.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":3.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":0.0,\"jitter_random_method\":2.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":-3.0,\"jitter_random_slider_values2\":-7.0,\"jitter_random_slider_values3\":-6.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":6.0,\"yaw_add_r\":6.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Running\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":2.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":16.0,\"delay_add\":2.0,\"delay_random_enable\":true,\"delay_random_max\":3.0,\"delay_random_method\":2.0,\"delay_random_min\":7.0,\"delay_random_slider_values1\":6.0,\"delay_random_slider_values2\":4.0,\"delay_random_slider_values3\":2.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":3.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":false,\"jitter_random_max\":0.0,\"jitter_random_method\":2.0,\"jitter_random_min\":-3.0,\"jitter_random_slider_values1\":5.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":14.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-22.0,\"yaw_add_r\":42.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":2.0,\"yaw_jitter_add\":-3.0,\"yaw_jitter_steps\":3.0},\"Slowmotion\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":1.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":1.0,\"delay_random_enable\":false,\"delay_random_max\":2.0,\"delay_random_method\":1.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":0.0,\"jitter_random_method\":2.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":-20.0,\"jitter_random_slider_values2\":-13.0,\"jitter_random_slider_values3\":-7.0,\"jitter_random_slider_values4\":13.0,\"jitter_random_slider_values5\":7.0,\"jitter_random_slider_values6\":1.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":6.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-15.0,\"yaw_add_r\":39.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":4.0,\"yaw_jitter_add\":-29.0,\"yaw_jitter_steps\":3.0},\"Sneaking\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":53.0,\"body_switcher\":3.0,\"delay_add\":5.0,\"delay_random_enable\":true,\"delay_random_max\":2.0,\"delay_random_method\":2.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":2.0,\"delay_random_slider_values3\":10.0,\"delay_random_slider_values4\":5.0,\"delay_random_slider_values5\":3.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":5.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":8.0,\"jitter_random_method\":1.0,\"jitter_random_min\":-14.0,\"jitter_random_slider_values1\":0.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":1.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":5.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-23.0,\"yaw_add_r\":41.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":4.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Standing\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":1.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":4.0,\"delay_random_enable\":false,\"delay_random_max\":14.0,\"delay_random_method\":1.0,\"delay_random_min\":2.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":false,\"jitter_random_max\":0.0,\"jitter_random_method\":1.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":0.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":1.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-20.0,\"yaw_add_r\":36.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0}},{\"Air Crouch\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":58.0,\"body_random_min\":53.0,\"body_switcher\":3.0,\"delay_add\":7.0,\"delay_random_enable\":true,\"delay_random_max\":4.0,\"delay_random_method\":1.0,\"delay_random_min\":2.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":14.0,\"delay_random_slider_values3\":10.0,\"delay_random_slider_values4\":5.0,\"delay_random_slider_values5\":3.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":6.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":11.0,\"jitter_random_method\":2.0,\"jitter_random_min\":-11.0,\"jitter_random_slider_values1\":11.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":-11.0,\"jitter_random_slider_values4\":-7.0,\"jitter_random_slider_values5\":7.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":5.0,\"tickbase\":\"Venture\",\"tickbase_method\":1.0,\"tickbase_random_max\":22.0,\"tickbase_random_min\":2.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-20.0,\"yaw_add_r\":45.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":2.0,\"yaw_jitter_add\":-11.0,\"yaw_jitter_steps\":3.0},\"Crouch\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":2.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":60.0,\"body_random_min\":52.0,\"body_switcher\":16.0,\"delay_add\":1.0,\"delay_random_enable\":true,\"delay_random_max\":9.0,\"delay_random_method\":1.0,\"delay_random_min\":3.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":10.0,\"jitter_random_method\":2.0,\"jitter_random_min\":5.0,\"jitter_random_slider_values1\":-8.0,\"jitter_random_slider_values2\":11.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-19.0,\"yaw_add_r\":32.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":5.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Jumping\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":1.0,\"body_add_r\":60.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":1.0,\"delay_random_enable\":true,\"delay_random_max\":4.0,\"delay_random_method\":1.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":3.0,\"delay_random_slider_values3\":4.0,\"delay_random_slider_values4\":3.0,\"delay_random_slider_values5\":4.0,\"delay_random_slider_values6\":2.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":3.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":0.0,\"jitter_random_method\":2.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":-3.0,\"jitter_random_slider_values2\":-7.0,\"jitter_random_slider_values3\":-6.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":6.0,\"yaw_add_r\":6.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Running\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":16.0,\"delay_add\":2.0,\"delay_random_enable\":true,\"delay_random_max\":3.0,\"delay_random_method\":1.0,\"delay_random_min\":7.0,\"delay_random_slider_values1\":6.0,\"delay_random_slider_values2\":4.0,\"delay_random_slider_values3\":2.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":3.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":false,\"jitter_random_max\":1.0,\"jitter_random_method\":1.0,\"jitter_random_min\":-3.0,\"jitter_random_slider_values1\":5.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":3.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-22.0,\"yaw_add_r\":42.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":2.0,\"yaw_jitter_add\":-3.0,\"yaw_jitter_steps\":3.0},\"Slowmotion\":{\"body\":\"Jitter\",\"body_add_l\":0.0,\"body_add_mode\":1.0,\"body_add_r\":0.0,\"body_delay\":1.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":1.0,\"delay_random_enable\":false,\"delay_random_max\":2.0,\"delay_random_method\":1.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":false,\"jitter_random_max\":0.0,\"jitter_random_method\":1.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":0.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":1.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":1.0,\"yaw_add\":0.0,\"yaw_add_l\":0.0,\"yaw_add_r\":0.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Sneaking\":{\"body\":\"Jitter\",\"body_add_l\":58.0,\"body_add_mode\":1.0,\"body_add_r\":58.0,\"body_delay\":2.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":53.0,\"body_switcher\":3.0,\"delay_add\":5.0,\"delay_random_enable\":false,\"delay_random_max\":2.0,\"delay_random_method\":2.0,\"delay_random_min\":1.0,\"delay_random_slider_values1\":2.0,\"delay_random_slider_values2\":2.0,\"delay_random_slider_values3\":10.0,\"delay_random_slider_values4\":5.0,\"delay_random_slider_values5\":3.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":5.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":true,\"jitter_random_max\":8.0,\"jitter_random_method\":1.0,\"jitter_random_min\":-14.0,\"jitter_random_slider_values1\":0.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":1.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-23.0,\"yaw_add_r\":41.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":4.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0},\"Standing\":{\"body\":\"Jitter\",\"body_add_l\":60.0,\"body_add_mode\":1.0,\"body_add_r\":60.0,\"body_delay\":3.0,\"body_mode\":1.0,\"body_random_max\":0.0,\"body_random_min\":0.0,\"body_switcher\":3.0,\"delay_add\":1.0,\"delay_random_enable\":true,\"delay_random_max\":10.0,\"delay_random_method\":1.0,\"delay_random_min\":2.0,\"delay_random_slider_values1\":1.0,\"delay_random_slider_values2\":1.0,\"delay_random_slider_values3\":1.0,\"delay_random_slider_values4\":1.0,\"delay_random_slider_values5\":1.0,\"delay_random_slider_values6\":1.0,\"delay_random_slider_values7\":1.0,\"delay_random_slider_values8\":1.0,\"delay_random_slider_values9\":1.0,\"delay_random_sliders\":1.0,\"hidden\":false,\"hidden_pitch\":\"Down\",\"hidden_pitch_add\":0.0,\"hidden_pitch_add2\":0.0,\"hidden_pitch_custom\":0.0,\"jitter_random_enable\":false,\"jitter_random_max\":0.0,\"jitter_random_method\":1.0,\"jitter_random_min\":0.0,\"jitter_random_slider_values1\":0.0,\"jitter_random_slider_values2\":0.0,\"jitter_random_slider_values3\":0.0,\"jitter_random_slider_values4\":0.0,\"jitter_random_slider_values5\":0.0,\"jitter_random_slider_values6\":0.0,\"jitter_random_slider_values7\":0.0,\"jitter_random_slider_values8\":0.0,\"jitter_random_slider_values9\":0.0,\"jitter_random_sliders\":1.0,\"tickbase\":\"Neverlose\",\"tickbase_method\":1.0,\"tickbase_random_max\":2.0,\"tickbase_random_min\":1.0,\"tickbase_random_slider_values1\":1.0,\"tickbase_random_slider_values2\":1.0,\"tickbase_random_slider_values3\":1.0,\"tickbase_random_slider_values4\":1.0,\"tickbase_random_slider_values5\":1.0,\"tickbase_random_slider_values6\":1.0,\"tickbase_random_slider_values7\":1.0,\"tickbase_random_slider_values8\":1.0,\"tickbase_random_slider_values9\":1.0,\"tickbase_random_sliders\":1.0,\"yaw\":2.0,\"yaw_add\":0.0,\"yaw_add_l\":-20.0,\"yaw_add_r\":36.0,\"yaw_brute_enable\":false,\"yaw_brute_slider_left1\":0.0,\"yaw_brute_slider_left2\":0.0,\"yaw_brute_slider_left3\":0.0,\"yaw_brute_slider_left4\":0.0,\"yaw_brute_slider_left5\":0.0,\"yaw_brute_slider_left6\":0.0,\"yaw_brute_slider_left7\":0.0,\"yaw_brute_slider_left8\":0.0,\"yaw_brute_slider_left9\":0.0,\"yaw_brute_slider_right1\":0.0,\"yaw_brute_slider_right2\":0.0,\"yaw_brute_slider_right3\":0.0,\"yaw_brute_slider_right4\":0.0,\"yaw_brute_slider_right5\":0.0,\"yaw_brute_slider_right6\":0.0,\"yaw_brute_slider_right7\":0.0,\"yaw_brute_slider_right8\":0.0,\"yaw_brute_slider_right9\":0.0,\"yaw_brute_sliders\":1.0,\"yaw_brute_time\":12.0,\"yaw_jitter\":1.0,\"yaw_jitter_add\":0.0,\"yaw_jitter_steps\":3.0}}],\"settings\":{\"force_defensive\":[\"Standing\",\"Slowmotion\",\"Crouch\",\"Sneaking\",\"Jumping\",\"Air Crouch\",\"~\"],\"hs_defensive\":\"Break LC\",\"safe_head\":true}},\"enabled_sections\":[\"angles\",\"visuals\",\"mods\"],\"mods\":{\"animation_air\":2.0,\"animation_allow\":true,\"animation_lean\":100.0,\"animation_run\":1.0,\"animation_select\":\"States\",\"animation_shake\":0.0,\"auto_teleport\":false,\"fake_latency\":false,\"fakeduck_speed\":false,\"fast_ladder\":false,\"forcebaim\":false,\"super_toss\":false,\"zero_pitch\":-1.0,\"~animation_air\":{\"custom\":100.0},\"~animation_run\":{\"custom\":100.0},\"~animation_shake\":{\"custom\":0.0,\"max\":100.0,\"min\":20.0},\"~fake_latency\":{\"amount\":116.0},\"~forcebaim\":{\"hp\":75.0,\"select\":[\"~\"]}},\"visuals\":{\"aimbot_logs\":true,\"aspect\":true,\"crosshair_ind\":false,\"damage_indicator\":false,\"enemy_lagcomp\":false,\"notificaiton_style\":\"Modern\",\"optimize_cvars\":false,\"scope_overlay\":true,\"skeet_indicators\":false,\"viewmodel\":true,\"watermark\":{\"acc_col\":\"#6884FFFF\",\"anim_col\":\"#FFFFFFFF\",\"custom_name\":\"\195\175\194\157\194\162  Venture\",\"drag_pos_x\":1804.0,\"drag_pos_y\":510.0,\"second_col\":\"#EB6161FF\",\"style\":1.0,\"toggle\":false},\"~aimbot_logs\":{\"console\":true,\"notify\":true},\"~aspect\":{\"slider\":133.0},\"~crosshair_ind\":{\"accent_col\":\"#B6C0E4FF\",\"bind_add\":[\"~\"],\"bind_col\":\"#D6BDDEFF\",\"gap_add\":1.0,\"ind_select\":1.0,\"text_select\":\"Venture\"},\"~damage_indicator\":{\"color\":\"#FFFFFFFF\",\"font\":1.0},\"~enemy_lagcomp\":{\"*box_color\":\"#2F75DDFF\",\"*text_color\":\"#FF2D2DFF\",\"box_color\":false,\"text_color\":false},\"~notificaiton_style\":{\"error\":\"#FF3232FF\",\"font\":1.0,\"max_notifies\":3.0,\"rounding\":5.0,\"shadow_thick\":35.0,\"spacing\":13.0,\"spam_test\":false,\"success\":\"#00C800FF\",\"warning\":\"#FF8C00FF\",\"y_padding\":0.0},\"~scope_overlay\":{\"color\":\"#FFFFFFFF\",\"gap\":5.0,\"inverted\":false,\"size\":67.0},\"~skeet_indicators\":{\"indicators_sel\":[\"~\"],\"padding\":0.0},\"~viewmodel\":{\"fov\":746.0,\"hand\":0.0,\"xoff\":-10.0,\"yoff\":-7.0,\"zoff\":7.0}}}"
        }
    }
};
configs.cfg_database.cfg_list = configs.cfg_database.cfg_list or {};
configs.cfg_database.menu_list = configs.cfg_database.menu_list or {};
v19.config = v19.config or {};
v19.config.db_list = v16.global.main1:list("", configs.cfg_database.menu_list):depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v19.global.active
});
v19.config.name = v16.global.main1:input("\v\f<file-signature>" .. string.rep(v13.ZWS, 5) .. "\rName:", "Main"):depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v19.global.active
});
v19.config.enable_visuals = v16.global.cfgdb:switch(string.rep(v13.ZWS, 5) .. "\v\226\164\183" .. string.rep(v13.ZWS, 5) .. "\rVisuals   \v\f<layer-group>"):depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v19.global.active
});
v19.config.enable_mods = v16.global.cfgdb:switch(string.rep(v13.ZWS, 5) .. "\v\226\164\183" .. string.rep(v13.ZWS, 5) .. "\rMods   \v\f<layer-group>"):depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v19.global.active
});
v19.config.enable_angles = v16.global.cfgdb:switch(string.rep(v13.ZWS, 5) .. "\v\226\164\183" .. string.rep(v13.ZWS, 5) .. "\rAngles   \v\f<layer-group>"):depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v19.global.active
});
configs.aa_settings_tbl = {
    force_defensive = v19.aa.force_defensive, 
    hs_defensive = v19.aa.hs_defensive, 
    safe_head = v19.aa.safe_head
};
local v516 = {
    builder = v19.aa.builder, 
    settings = configs.aa_settings_tbl
};
configs.get_current_data = function(_)
    -- upvalues: v19 (ref), l_pui_0 (ref), v516 (ref)
    local v518 = {};
    local v519 = {};
    if v19.config.enable_angles:get() then
        v518.angles = l_pui_0.setup(v516, true):save();
        table.insert(v519, "angles");
    end;
    if v19.config.enable_visuals:get() then
        v518.visuals = l_pui_0.setup(v19.vis, true):save();
        table.insert(v519, "visuals");
    end;
    if v19.config.enable_mods:get() then
        v518.mods = l_pui_0.setup(v19.mods, true):save();
        table.insert(v519, "mods");
    end;
    v518.enabled_sections = v519;
    return v518;
end;
configs.load_data_safely = function(_, v521)
    -- upvalues: v19 (ref), l_pui_0 (ref), v516 (ref)
    if not v521 or not v521.enabled_sections then
        if v19.config.enable_angles:get() and v521 then
            l_pui_0.setup(v516, true):load(v521);
        end;
        return;
    else
        if v19.config.enable_angles:get() and v521.angles then
            l_pui_0.setup(v516, true):load(v521.angles);
        end;
        if v19.config.enable_visuals:get() and v521.visuals then
            l_pui_0.setup(v19.vis, true):load(v521.visuals);
        end;
        if v19.config.enable_mods:get() and v521.mods then
            l_pui_0.setup(v19.mods, true):load(v521.mods);
        end;
        return;
    end;
end;
configs.save_config = function(v522, v523)
    cvar.play:call("ambient\\tones\\elev1");
    local v524 = v522:get_current_data();
    if #v524.enabled_sections == 0 then
        common.add_notify("Venture", "Please enable at least one data type");
        return;
    else
        configs.cfg_database.cfg_list[v523][2] = json.stringify(v524);
        db.venture_cfgs_live_1 = configs.cfg_database;
        return;
    end;
end;
configs.update_values = function(_, v526)
    local v527 = configs.cfg_database.cfg_list[v526][1] .. "\v - Active";
    for v528, v529 in ipairs(configs.cfg_database.cfg_list) do
        configs.cfg_database.menu_list[v528] = v529[1];
    end;
    configs.cfg_database.menu_list[v526] = v527;
end;
configs.create_config = function(v530, v531)
    if type(v531) ~= "string" then
        return;
    elseif v531 == nil or v531 == "" or v531 == " " then
        return;
    else
        for v532 = #configs.cfg_database.menu_list, 1, -1 do
            if configs.cfg_database.menu_list[v532] == v531 then
                return;
            end;
        end;
        if #configs.cfg_database.cfg_list > 15 then
            return;
        else
            local v533 = v530:get_current_data();
            if #v533.enabled_sections == 0 then
                common.add_notify("Venture", "Please enable at least one data type");
                return;
            else
                local v534 = {
                    v531, 
                    json.stringify(v533)
                };
                table.insert(configs.cfg_database.cfg_list, v534);
                table.insert(configs.cfg_database.menu_list, v531);
                db.venture_cfgs_live_1 = configs.cfg_database;
                cvar.play:call("physics\\wood\\wood_solid_impact_bullet4");
                return;
            end;
        end;
    end;
end;
configs.remove_config = function(_, v536)
    local v537 = false;
    for _, v539 in ipairs(configs.default_configs) do
        if configs.cfg_database.cfg_list[v536][1] == v539.name then
            v537 = true;
            break;
        end;
    end;
    if v537 then
        return;
    else
        local v540 = configs.cfg_database.cfg_list[v536][1];
        for v541 = #configs.cfg_database.cfg_list, 1, -1 do
            if configs.cfg_database.cfg_list[v541][1] == v540 then
                table.remove(configs.cfg_database.cfg_list, v541);
                table.remove(configs.cfg_database.menu_list, v541);
            end;
        end;
        db.venture_cfgs_live_1 = configs.cfg_database;
        return;
    end;
end;
configs.load_config = function(v542, v543, _)
    local l_cfg_list_0 = configs.cfg_database.cfg_list;
    if l_cfg_list_0[v543][2] == nil or l_cfg_list_0[v543][2] == "" then
        common.add_notify("Venture", "Please save the config");
        print(string.format("Error[data_base[%s]]", v543));
        return;
    else
        v542:load_data_safely((json.parse(l_cfg_list_0[v543][2])));
        cvar.play:call("physics\\wood\\wood_solid_impact_bullet4");
        return;
    end;
end;
configs.get_config_info = function(_, v547)
    local l_cfg_list_1 = configs.cfg_database.cfg_list;
    if not l_cfg_list_1[v547] or not l_cfg_list_1[v547][2] or l_cfg_list_1[v547][2] == "" then
        return "No data";
    else
        local v549 = json.parse(l_cfg_list_1[v547][2]);
        if v549 and v549.enabled_sections then
            return "Contains: " .. table.concat(v549.enabled_sections, ", ");
        else
            return "Legacy config (angles only)";
        end;
    end;
end;
configs.setup_default_configs = function(_)
    if configs.cfg_database == nil then
        configs.cfg_database = {
            cfg_list = {}, 
            menu_list = {}
        };
    end;
    if #configs.cfg_database.cfg_list == 0 then
        for _, v552 in ipairs(configs.default_configs) do
            table.insert(configs.cfg_database.cfg_list, {
                [1] = v552.name, 
                [2] = v552.settings
            });
            table.insert(configs.cfg_database.menu_list, v552.name);
        end;
    end;
    db.venture_cfgs_live_1 = configs.cfg_database;
end;
configs.buttons = {
    create = v16.global.main1:button(string.rep(v13.ZWS, 15) .. "\v\f<paste>\r  Create" .. string.rep(v13.ZWS, 15), function()
        -- upvalues: v19 (ref), v122 (ref)
        configs:create_config(v19.config.name:get());
        v19.config.db_list:update(configs.cfg_database.menu_list);
        v122:process_notification("Created preset ", "success");
    end, true):depend({
        [1] = nil, 
        [2] = 1, 
        [1] = v19.global.active
    }), 
    load = v16.global.main1:button(string.rep(v13.ZWS, 15) .. "\v\f<download>\r  Load" .. string.rep(v13.ZWS, 15), function()
        -- upvalues: v19 (ref), v122 (ref)
        configs:load_config(v19.config.db_list:get(), false);
        v19.config.db_list:update(configs.cfg_database.menu_list);
        v122:process_notification("Loaded Preset ", "success");
    end, true):depend({
        [1] = nil, 
        [2] = 1, 
        [1] = v19.global.active
    }), 
    save = v16.global.main1:button(string.rep(v13.ZWS, 8) .. "\a6FE143FF\f<floppy-disk>\r" .. string.rep(v13.ZWS, 8), function()
        -- upvalues: v19 (ref), v122 (ref)
        configs:save_config(v19.config.db_list:get());
        v122:process_notification("Saved preset " .. tostring(v19.config.db_list:get()), "success");
    end, true):depend({
        [1] = nil, 
        [2] = 1, 
        [1] = v19.global.active
    }), 
    import = v16.global.main1:button("\f<file-import>  Import", function()
        -- upvalues: l_clipboard_0 (ref), v122 (ref)
        local v553 = l_clipboard_0.get();
        local l_status_1, l_result_1 = pcall(json.parse, v553);
        if not l_status_1 then
            common.add_notify("Venture", "Invalid JSON data in clipboard");
            return;
        else
            configs:load_data_safely(l_result_1);
            cvar.play:call("ambient\\energy\\zap1");
            v122:process_notification("Imported settings ", "success");
            return;
        end;
    end, true):depend({
        [1] = nil, 
        [2] = 1, 
        [1] = v19.global.active
    }), 
    export = v16.global.main1:button("\f<file-export>  Export", function()
        -- upvalues: l_clipboard_0 (ref), v122 (ref)
        local v556 = configs:get_current_data();
        if #v556.enabled_sections == 0 then
            common.add_notify("Venture", "Please enable at least one data type");
            return;
        else
            l_clipboard_0.set(json.stringify(v556));
            cvar.play:call("physics\\wood\\wood_solid_impact_bullet4");
            v122:process_notification("Exported settings", "warning");
            return;
        end;
    end, true):depend({
        [1] = nil, 
        [2] = 1, 
        [1] = v19.global.active
    }), 
    remove = v16.global.main1:button(string.rep(v13.ZWS, 7) .. "\aF14C4CFF\f<trash-can>\r" .. string.rep(v13.ZWS, 7), function()
        -- upvalues: v19 (ref), v122 (ref)
        configs:remove_config(v19.config.db_list:get());
        v19.config.db_list:update(configs.cfg_database.menu_list);
        v122:process_notification("Removed preset " .. tostring(v19.config.db_list:get() + 1), "error");
    end, true):depend({
        [1] = nil, 
        [2] = 1, 
        [1] = v19.global.active
    })
};
configs.setup_default_configs();
events.aim_ack(function(v557)
    -- upvalues: v122 (ref)
    v122:aimbot_logs(v557);
end);
local v558 = l_gradient_0.text_animate("venture.live", 0.9, {
    ui.get_style("Link Active"), 
    color(255, 255, 255, 255)
});
v19.vis.skeet_indicators:disabled(true);
v19.vis.enemy_lagcomp:disabled(true);
v19.mods.fakeduck_speed:disabled(true);
v19.mods.forcebaim:disabled(true);
v19.vis.damage_indicator:disabled(true);
v19.vis.optimize_cvars:tooltip("Locked in active game ");
v19.mods.fast_ladder:disabled(true);
v19.mods.super_toss:disabled(true);
local function v559()
    -- upvalues: v19 (ref)
    v19.vis.optimize_cvars:disabled(globals.is_in_game);
    v19.vis.watermark.toggle:set(false);
    v19.vis.skeet_indicators:set(false);
    v19.vis.damage_indicator:set(false);
    v19.vis.enemy_lagcomp:set(false);
    v19.mods.fakeduck_speed:set(false);
    v19.mods.forcebaim:set(false);
    v19.mods.fast_ladder:set(false);
    v19.mods.super_toss:set(false);
end;
events.render(function()
    -- upvalues: v559 (ref), v558 (ref), v122 (ref)
    v559();
    ui.sidebar(v558:get_animated_text(), "stars");
    v558:animate();
    v122.watermark_drag_object:update();
    v122:render_notifications();
    v122:center_indicator();
    v122:aspect_ratio_handler();
    v122:set_viewmodel();
    v122:scope_overlay();
    v122:skeet_indicator();
    v122:show_dmg();
    v122:performance_boost();
    v122:fake_latency();
    v122.lagcomp_debug:render();
end);
events.net_update_end(function()
    -- upvalues: v122 (ref)
    v122.lagcomp_debug:net_update_end();
end);
events.createmove_run(function(v560)
    -- upvalues: v122 (ref)
    v122:unlock_fakeduck_speed(v560);
end);
events.createmove(function(v561)
    -- upvalues: v515 (ref), v122 (ref)
    antiaim:setup();
    v515();
    v122:fast_ladder(v561);
    v122.super_toss:createmove(v561);
    v122:process_teleport();
end);
events.grenade_override_view(function(v562)
    -- upvalues: v122 (ref)
    v122.super_toss:grenade_override_view(v562);
end);