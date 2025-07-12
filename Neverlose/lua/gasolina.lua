local _ = "gazolina.lc";
local l_pui_0 = require("neverlose/pui");
local l_base64_0 = require("neverlose/base64");
local l_clipboard_0 = require("neverlose/clipboard");
local _ = require("neverlose/inspect");
local l_memory_0 = require("neverlose/memory");
local v6 = "gazolina.lc";
local v7 = 1750586607;
local v8 = common.get_username();
local v9 = {};
local v10 = {};
local v11 = {};
local v12 = {};
local v13 = {};
local v14 = {};
local v15 = {};
local v16 = {};
local v17 = {};
local v18 = {};
local v19 = {};
local v20 = {};
local v21 = {};
local v22 = {};
local v23 = {};
local v24 = {};
local v25 = {};
local _ = {};
local v27 = {};
local v28 = {};
local v29 = {};
local v30 = {};
local v31 = {};
local v32 = {};
local v33 = {};
local v34 = {};
local v35 = {};
local v36 = {};
local v37 = {};
local v38 = {};
local v39 = {};
local v40 = {};
local v41 = {};
local v42 = {};
local v43 = {};
local v44 = {};
local v45 = {};
local v46 = {};
local v47 = {};
local function v49(v48)
    return string.gsub(v48, "[\128-\191]", "");
end;
local function v51(v50)
    return tonumber(v50:string());
end;
local function v55(v52, v53)
    local v54 = v53 and "FF3E3EFF" or "{Link Active}";
    print_raw(string.format("[\a%sgazolina\aDEFAULT] \a%s%s", "{Link Active}", v54, v52));
end;
local v56 = render.screen_size();
local v57 = {
    [1] = "Standing", 
    [2] = "Running", 
    [3] = "Slowing", 
    [4] = "Crouching", 
    [5] = "Sneaking", 
    [6] = "Air", 
    [7] = "Air Crouching", 
    [8] = "Legit AA", 
    [9] = "Freestanding"
};
local v58 = {
    [1] = "T", 
    [2] = "CT"
};
local v59 = {
    FL_ONGROUND = bit.lshift(1, 0)
};
v9.rage = {
    main = {
        dormant_aimbot = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
        hide_shots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
        hide_shots_options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
        double_tap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
        double_tap_lag_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
        peek_assist = {
            ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"), 
            ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Style"), 
            ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Auto Stop"), 
            ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Retreat Mode")
        }
    }, 
    selection = {
        hit_chance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"), 
        minimum_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
        safe_points = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"), 
        body_aim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim")
    }
};
v9.antiaim = {
    angles = {
        enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
        pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
        yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
        yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
        yaw_add = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
        avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"), 
        hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
        yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
        modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"), 
        body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
        inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
        left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
        right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
        options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
        freestanding_body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"), 
        freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
        freestand_peek = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"), 
        disable_yaw_modifiers = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"), 
        body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"), 
        extended_angles = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"), 
        extended_pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"), 
        extended_roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll")
    }, 
    fake_lag = {
        enabled = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
        limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit")
    }, 
    misc = {
        fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
        slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
        leg_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
    }
};
v9.misc = {
    movement = {}, 
    in_game = {}, 
    other = {
        fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency")
    }
};
v11.new = function(v60, v61)
    -- upvalues: v56 (ref)
    local v62 = v61 or vector();
    local v63 = ui.create("DRAGGING$$$)$)$)$");
    local v64 = {};
    local v66 = {
        dragging = false, 
        mouse_pos = vector(0, 0), 
        mouse_pos_diff = vector(0, 0), 
        size = vector(0, 0), 
        position = vector(0, 0), 
        reference = (function()
            -- upvalues: v63 (ref), v60 (ref), v62 (ref)
            local v65 = {
                v63:slider(("%s:dragging_x"):format(v60), -16384, 16384, v62.x), 
                v63:slider(("%s:dragging_y"):format(v60), -16384, 16384, v62.y)
            };
            v65[1]:visibility(false);
            v65[2]:visibility(false);
            return v65;
        end)()
    };
    v64.intersects = function(_, v68, v69, v70)
        return v68.x >= v69.x and v68.x <= v69.x + v70.x and v68.y >= v69.y and v68.y <= v69.y + v70.y;
    end;
    v64.set_position = function(v71, v72)
        v71.reference[1]:set(v72.x);
        v71.reference[2]:set(v72.y);
    end;
    v64.is_dragging = function(v73)
        return v73.dragging;
    end;
    v64.update = function(v74, v75)
        -- upvalues: v56 (ref)
        local v76 = ui.get_mouse_position();
        local v77 = ui.get_position();
        local v78 = ui.get_size();
        local v79 = ui.get_alpha() > 0 and common.is_button_down(1);
        local v80 = v74:intersects(v76, v74.position, v75) and not v74:intersects(v76, v77, v78);
        v74.mouse_pos_diff = -(v74.mouse_pos - v76);
        if v79 and v74.intersected == nil then
            v74.intersected = v80;
        end;
        if v79 and v74.intersected then
            v74.dragging = true;
        elseif not v79 then
            v74.dragging = false;
            v74.intersected = nil;
        end;
        if v74.dragging then
            local v81 = v75 * 0.5;
            local v82 = vector(v74.reference[1]:get() + v74.mouse_pos_diff.x, v74.reference[2]:get() + v74.mouse_pos_diff.y);
            v74.reference[1]:set(math.max(-v81.x, math.min(v56.x - v81.x, v82.x)));
            v74.reference[2]:set(math.max(-v81.y, math.min(v56.y - v81.y, v82.y)));
        end;
        local v83 = vector(v74.reference[1]:get(), v74.reference[2]:get());
        v74.mouse_pos = v76;
        v74.size = v75;
        v74.position = v83;
    end;
    return setmetatable(v64, {
        __index = v66
    });
end;
local v84 = "\226\128\138";
v12.wave = function(v85, v86, v87, v88, v89, v90, v91, v92, v93, v94)
    -- upvalues: v49 (ref)
    local v95 = {};
    local v96 = 1 / (string.len(v49(v85)) - 1);
    local v97 = v91 - v87;
    local v98 = v92 - v88;
    local v99 = v93 - v89;
    local v100 = v94 - v90;
    for v101 in string.gmatch(v85, ".[\128-\191]*") do
        local v102 = v86 % 2;
        if v102 > 1 then
            v102 = 2 - v102;
        end;
        local v103 = v87 + v97 * v102;
        local v104 = v88 + v98 * v102;
        local v105 = v89 + v99 * v102;
        local v106 = v90 + v100 * v102;
        v95[#v95 + 1] = "\a";
        v95[#v95 + 1] = color(v103, v104, v105, v106):to_hex();
        v95[#v95 + 1] = v101;
        v86 = v86 + v96;
    end;
    return table.concat(v95);
end;
do
    local l_v84_0 = v84;
    v12.text = function(v108, v109, v110, v111, v112, v113)
        -- upvalues: l_v84_0 (ref)
        if not v110 then
            v110 = 0;
        end;
        if not v111 then
            v111 = 0;
        end;
        if not v112 then
            v112 = 0;
        end;
        local v114 = ui.get_icon(v108);
        if string.gsub(v114, " ", "") == "" then
            v114 = v108;
        end;
        if v113 then
            local v115 = {};
            v115[#v115 + 1] = "\a";
            v115[#v115 + 1] = v113;
            v115[#v115 + 1] = v114;
            v115[#v115 + 1] = "\r";
            v114 = table.concat(v115);
        else
            local v116 = {};
            v116[#v116 + 1] = "\v";
            v116[#v116 + 1] = v114;
            v116[#v116 + 1] = "\r";
            v114 = table.concat(v116);
        end;
        local v117 = {};
        v117[#v117 + 1] = string.rep(l_v84_0, v110);
        v117[#v117 + 1] = v114;
        v117[#v117 + 1] = string.rep(l_v84_0, v111);
        v117[#v117 + 1] = v109;
        v117[#v117 + 1] = string.rep(l_v84_0, v112);
        return table.concat(v117);
    end;
    v12.text_colored = function(...)
        local v118 = {};
        for _, v120 in pairs({
            ...
        }) do
            local v121 = v120[2];
            local v122 = v120[1];
            v118[#v118 + 1] = "\a";
            v118[#v118 + 1] = v121:to_hex();
            v118[#v118 + 1] = v122;
        end;
        return table.concat(v118);
    end;
end;
v84 = utils.get_vfunc("engine.dll", "VEngineClient014", 91, "float(__thiscall*)(void*)");
local function v127(v123, v124, v125, v126)
    return v125 * v123 / v126 + v124;
end;
local function v134(v128, v129, v130, v131, v132)
    if type(v130) == "boolean" then
        v130 = v130 and 1 or 0;
    end;
    if type(v129) == "boolean" then
        v129 = v129 and 1 or 0;
    end;
    local v133 = v128(v131, v129, v130 - v129, v132);
    if type(v130) == "number" then
        if math.abs(v130 - v133) <= 0.001 then
            v133 = v130;
        end;
        if v133 % 1 < 1.0E-4 then
            v133 = math.floor(v133);
        elseif v133 % 1 > 0.9999 then
            v133 = math.ceil(v133);
        end;
    end;
    return v133;
end;
do
    local l_v84_1, l_v127_0, l_v134_0 = v84, v127, v134;
    v13.interp = function(v138, v139, v140, v141)
        -- upvalues: l_v127_0 (ref), l_v84_1 (ref), l_v134_0 (ref)
        if not v141 then
            v141 = l_v127_0;
        end;
        if type(v139) == "boolean" then
            v139 = v139 and 1 or 0;
        end;
        local v142 = globals.frametime / l_v84_1();
        return l_v134_0(v141, v138, v139, v142, v140);
    end;
end;
v84 = "\226\128\162";
v127 = "turn-down-right";
v134 = {};
local v143 = {
    l_pui_0.create(v12.text("house", "", 0, 0, 0), " ", 1), 
    l_pui_0.create(v12.text("house", "", 0, 0, 0), "", 1), 
    l_pui_0.create(v12.text("house", "", 0, 0, 0), "  ", 1)
};
v143[1]:list("", {
    v12.text("user", "About", 1, 8)
});
v143[2]:label(v12.text("triangle-exclamation", "The script is a work in progress and\nsome features may not work as intended.", 1, 3, 0, "aeae61ff"));
v143[2]:label(v12.text("bug", "Report Bugs", 1, 3, 0, "DEFAULT"));
v143[2]:button(v12.text("discord", "Discord Server", 1, 2), function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/QwJx52dPSe");
end, true);
v143[2]:button(v12.text("", "\240\159\166\171 Sata Config", 0, 2), function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://ru.neverlose.cc/market/item?id=ojYbuQ");
end, true);
v143[2]:button(v12.text("youtube", "Sata's YouTube", 0, 2), function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/channel/UCN5jetnEx5fkG7Cdr0iYh4g");
end, true);
v143[3]:label(v12.text("user-secret", "Welcome back, \v" .. v8, 2, 10));
v143[3]:label(v12.text("timeline-arrow", "Last update: " .. "\v" .. common.get_date("%m/%d %H:%M", v7) .. "\r", 0, 8));
local v144 = l_pui_0.create(v12.text("house", "", 0, 0, 0), "Settings", 1);
local v145 = {
    label = v144:label(v12.text("sidebar", "Sidebar", 2, 7, 2))
};
local v146 = v145.label:create();
v145.text = v146:input("Text", v6);
v145.color = v146:color_picker(v12.text(v127, "Color", 5, 5, 5), {
    Inner = {
        color(175, 255, 55, 255)
    }, 
    Outter = {
        color(35, 128, 255, 255)
    }
});
v145.speed = v146:slider(v12.text(v127, "Speed", 5, 5, 5), -200, 200, 1, 0.01);
v134.sidebar = v145;
v146 = {
    label = v144:label(v12.text("image", "Watermark", 2, 7, 2))
};
local v147 = v146.label:create();
v146.mode = v147:listable("Options", {
    [1] = "Customizable Text", 
    [2] = "Customizable Color", 
    [3] = "Customizable Font"
});
v146.text = v147:input("Text", v6):depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v146.mode
});
v146.gradient = v147:switch("Gradient"):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v146.mode
});
v146.color = v147:color_picker(v12.text(v127, "Color", 7, 5, 5), {
    Inner = {
        color(175, 255, 55, 255)
    }, 
    Outter = {
        color(35, 128, 255, 255)
    }
}):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v146.mode
}, {
    [1] = nil, 
    [2] = true, 
    [1] = v146.gradient
});
v146.speed = v147:slider(v12.text(v127, "Speed", 7, 5, 5), -200, 200, 100, 0.01):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v146.mode
}, {
    [1] = nil, 
    [2] = true, 
    [1] = v146.gradient
});
v146.color_n = v147:color_picker("Color"):depend({
    [1] = nil, 
    [2] = 2, 
    [1] = v146.mode
}, {
    [1] = nil, 
    [2] = false, 
    [1] = v146.gradient
});
v146.font = v147:combo("Font", {
    [1] = "Default", 
    [2] = "Small", 
    [3] = "Console", 
    [4] = "Bold", 
    [5] = "Unique"
}):depend({
    [1] = nil, 
    [2] = 3, 
    [1] = v146.mode
});
v134.watermark = v146;
v147 = {
    label = v144:label(v12.text("triangle-exclamation", "Notifications", 2, 7, 2))
};
local v148 = v147.label:create();
v147.style = v148:combo("Mode", {
    [1] = "Cat"
});
v147.spam = v148:switch(v12.text(v127, "Test Notification", 15, 15, 15));
v134.notify = v147;
v148 = {};
local v149 = l_pui_0.create(v12.text("house", "", 0, 0, 0), "Presets", 2);
v148.list = v149:list(v12.text("list", "List of available configs", 1, 2, 1), {});
v148.name = v149:input(v12.text("pen", "Name", 1, 2, 1), "");
v148.create = v149:button(v12.text("paste", "", 0, 0, 0, "00BCD4ff"), nil, true, "Create preset.");
v148.load = v149:button(v12.text("upload", "", 0, 0, 0, "3F51B5ff"), nil, true, "Load selected preset.");
v148.save = v149:button(v12.text("floppy-disk", "", 0, 0, 0, "388E3Cff"), nil, true, "Save selected preset.");
v148.import = v149:button(v12.text("file-import", "", 0, 0, 0, "4CAF50ff"), nil, true, "Import new preset.");
v148.export = v149:button(v12.text("file-export", "", 0, 0, 0, "2196F3ff"), nil, true, "Export selected preset.");
local v150 = v149:switch(" ", false);
v150:visibility(false);
do
    local l_v150_0 = v150;
    v148.delete = v149:button(v12.text("trash", "", 0, 0, 0, "ff0000ff"), function()
        -- upvalues: l_v150_0 (ref)
        l_v150_0:set(true);
    end):depend({
        [1] = nil, 
        [2] = false, 
        [1] = l_v150_0
    });
    v148.delete_confirm = v149:button(v12.text("trash-check", "", 0, 0, 0, "45ec4aff"), function()
        -- upvalues: l_v150_0 (ref)
        l_v150_0:set(false);
    end):depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_v150_0
    });
    v148.delete_cancel = v149:button(v12.text("trash-xmark", "", 0, 0, 0, "ff0000ff"), function()
        -- upvalues: l_v150_0 (ref)
        l_v150_0:set(false);
    end):depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_v150_0
    });
    v148.information = {
        creator = l_pui_0.create(v12.text("house", "", 0, 0, 0), "Presets", 2):label("")
    };
    v134.presets = v148;
end;
v14.info = v134;
v143 = {};
v144 = {};
v145 = {};
v146 = l_pui_0.create(v12.text("list-tree", "", 0, 0, 0), "Selection", 1);
v145.team = v146:list(v12.text("", "", 0, 0, 0), {
    [1] = "\aFF0000FF" .. v84 .. "\r  T", 
    [2] = "\a8698FDFF" .. v84 .. "\r  CT"
});
v145.state = v146:list(v12.text("users", "Select the state you want to change.", 2, 2, 2), v57);
v144.configure = v145;
v146 = {};
v147 = l_pui_0.create(v12.text("list-tree", "", 0, 0, 0), "Tweaks", 1);
v148 = {
    enabled = v147:switch(v12.text(v84, "Legit AA", 2, 7, 2))
};
v148.mode = v148.enabled:create():combo("Yaw Base", {
    [1] = "Local View", 
    [2] = "At Target"
}):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v148.enabled
});
v146.legit_aa = v148;
v149 = {
    select = v147:combo(v12.text(v84, "Manual Yaw", 2, 7, 2), {
        [1] = "Disabled", 
        [2] = "Left", 
        [3] = "Right", 
        [4] = "Forward"
    })
};
v150 = v149.select:create();
v149.static = v150:switch("Static");
v149.inverter = v150:switch(v12.text(v127, "Inverter", 7, 2, 2)):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v149.static
});
v146.manual_yaw = v149;
v146.backstab = {
    switch = v147:switch(v12.text(v84, "Avoid Backstab", 2, 7, 2))
};
local v152 = {
    select = v147:combo(v12.text(v84, "State", 2, 7, 2), {
        [1] = "Disabled", 
        [2] = "Warmup", 
        [3] = "No Enemies", 
        [4] = "Force"
    })
};
local v153 = v152.select:create();
v152.pitch = v153:combo("Pitch", "Disabled", "Down"):depend({
    [1] = nil, 
    [2] = "Disabled", 
    [3] = true, 
    [1] = v152.select
});
v152.yaw = v153:combo("Yaw", "Spin", "Distortion", "L&R"):depend({
    [1] = nil, 
    [2] = "Disabled", 
    [3] = true, 
    [1] = v152.select
});
v152.range = v153:slider(v12.text(v127, "Range", 7, 2, 2), 1, 360, 360):depend({
    [1] = nil, 
    [2] = "L&R", 
    [3] = true, 
    [1] = v152.yaw
}, {
    [1] = nil, 
    [2] = "Disabled", 
    [3] = true, 
    [1] = v152.select
});
v152.speed = v153:slider(v12.text(v127, "Speed", 7, 2, 2), 1, 128, 32, 1, "t"):depend({
    [1] = nil, 
    [2] = "L&R", 
    [3] = true, 
    [1] = v152.yaw
}, {
    [1] = nil, 
    [2] = "Disabled", 
    [3] = true, 
    [1] = v152.select
});
v152.left_yaw = v153:slider(v12.text(v127, "Left Offset", 7, 2, 2), -180, 180, 0):depend({
    [1] = nil, 
    [2] = "L&R", 
    [1] = v152.yaw
}, {
    [1] = nil, 
    [2] = "Disabled", 
    [3] = true, 
    [1] = v152.select
});
v152.right_yaw = v153:slider(v12.text(v127, "Right Offset", 7, 2, 2), -180, 180, 0):depend({
    [1] = nil, 
    [2] = "L&R", 
    [1] = v152.yaw
}, {
    [1] = nil, 
    [2] = "Disabled", 
    [3] = true, 
    [1] = v152.select
});
v146.warmup_aa = v152;
v153 = {
    switch = v147:switch(v12.text(v84, "Safe Head", 2, 7, 2))
};
local v154 = v153.switch:create();
v153.states = v154:selectable(v12.text("list-check", "Conditions", 2, 2, 2), {
    [1] = "Air Crouch", 
    [2] = "Zeus", 
    [3] = "Knife", 
    [4] = "Height Advantage"
}):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v153.switch
});
v153.height = v154:slider(v12.text("ruler-vertical", "Height", 2, 2, 2), 0, 200, 25, 1, "u.", "If value equals zero then safe head works only on the same height as your enemy."):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v153.switch
}, {
    [1] = nil, 
    [2] = "Height Advantage", 
    [1] = v153.states
});
v146.safe_head = v153;
v144.additional = v146;
v143.main = v144;
v145 = {};
v146 = l_pui_0.create(v12.text("list-tree", "", 0, 0, 0), "Builder", 2);
v147 = {
    group = l_pui_0.create(v12.text("list-tree", "", 0, 0, 0), "Snap builder")
};
v147.select = v147.group:selectable(v12.text(v84, "Break LC", 2, 5, 2, "9ca7e1ff"), v57);
v148 = v147.select:create();
v147.disable_on_grenade = v148:switch(v12.text("", "Disable on Grenade", 0, 0, 0));
v147.hide_shots = v148:combo(v12.text("", "Hide Shots", 0, 0, 0), {
    [1] = "Favor Fire Rate", 
    [2] = "Favor Fake Lag", 
    [3] = "Break LC"
});
v145.break_lc = v147;
v148 = {};
do
    local l_v147_0, l_v148_0 = v147, v148;
    for v157, v158 in pairs(v57) do
        l_v148_0[v158] = {};
        do
            local l_v157_0 = v157;
            for v160, v161 in pairs(v58) do
                l_v148_0[v158][v161] = {};
                local v162 = l_v148_0[v158][v161];
                local l_team_0 = v144.configure.team;
                local l_state_0 = v144.configure.state;
                if v158 == "Freestanding" or v158 == "Legit AA" then
                    v162.allow_state = v146:switch(("Allow \v%s\r state"):format(v158), true):depend({
                        [1] = l_team_0, 
                        [2] = v160
                    }, {
                        [1] = l_state_0, 
                        [2] = l_v157_0
                    });
                end;
                v162.yaw = v146:combo(v12.text(v84, "Yaw", 2, 2, 2), {
                    [1] = "Disabled", 
                    [2] = "Backward"
                }, "Backward"):depend({
                    [1] = l_team_0, 
                    [2] = v160
                }, {
                    [1] = l_state_0, 
                    [2] = l_v157_0
                });
                local v165 = v162.yaw:create();
                v162.yaw_mode = v165:combo(v12.text("", "Mode", 0, 0, 0), {
                    [1] = "Solo", 
                    [2] = "L/R"
                }):depend({
                    [1] = nil, 
                    [2] = "Backward", 
                    [1] = v162.yaw
                });
                v162.offset = v165:slider(v12.text(v127, "Offset", 10, 2, 2), -180, 180, 0):depend({
                    [1] = nil, 
                    [2] = "Backward", 
                    [1] = v162.yaw
                }, {
                    [1] = nil, 
                    [2] = "Solo", 
                    [1] = v162.yaw_mode
                });
                v162.yaw_left = v165:slider(v12.text(v127, "Left", 10, 2, 2), -180, 180, 0):depend({
                    [1] = nil, 
                    [2] = "Backward", 
                    [1] = v162.yaw
                }, {
                    [1] = nil, 
                    [2] = "L/R", 
                    [1] = v162.yaw_mode
                });
                v162.yaw_right = v165:slider(v12.text(v127, "Right", 10, 2, 2), -180, 180, 0):depend({
                    [1] = nil, 
                    [2] = "Backward", 
                    [1] = v162.yaw
                }, {
                    [1] = nil, 
                    [2] = "L/R", 
                    [1] = v162.yaw_mode
                });
                v162.delay = v165:switch(v12.text(v84, "Delay", 2, 2, 2, "FFA500FF")):depend({
                    [1] = nil, 
                    [2] = "Backward", 
                    [1] = v162.yaw
                }, {
                    [1] = nil, 
                    [2] = "L/R", 
                    [1] = v162.yaw_mode
                });
                v162.delay_method = v165:combo(v12.text("", "Method", 10, 2, 2), {
                    [1] = "Default", 
                    [2] = "Random", 
                    [3] = "Custom"
                }):depend({
                    [1] = nil, 
                    [2] = "Backward", 
                    [1] = v162.yaw
                }, {
                    [1] = nil, 
                    [2] = "L/R", 
                    [1] = v162.yaw_mode
                }, {
                    [1] = nil, 
                    [2] = true, 
                    [1] = v162.delay
                });
                v162.delay_default = v165:slider(v12.text(v127, "\aFFA500FFTiming\r", 15, 2, 2), 2, 22, 0):depend({
                    [1] = nil, 
                    [2] = "Backward", 
                    [1] = v162.yaw
                }, {
                    [1] = nil, 
                    [2] = "L/R", 
                    [1] = v162.yaw_mode
                }, {
                    [1] = nil, 
                    [2] = "Default", 
                    [1] = v162.delay_method
                }, {
                    [1] = nil, 
                    [2] = true, 
                    [1] = v162.delay
                });
                v162.delay_random_min = v165:slider(v12.text(v127, "\aFFA500FFMin. Timing\r", 18, 2, 2), 2, 22, 0):depend({
                    [1] = nil, 
                    [2] = "Backward", 
                    [1] = v162.yaw
                }, {
                    [1] = nil, 
                    [2] = "L/R", 
                    [1] = v162.yaw_mode
                }, {
                    [1] = nil, 
                    [2] = "Random", 
                    [1] = v162.delay_method
                }, {
                    [1] = nil, 
                    [2] = true, 
                    [1] = v162.delay
                });
                v162.delay_random_max = v165:slider(v12.text(v127, "\aFFA500FFMax. Timing\r", 18, 2, 2), 2, 22, 0):depend({
                    [1] = nil, 
                    [2] = "Backward", 
                    [1] = v162.yaw
                }, {
                    [1] = nil, 
                    [2] = "L/R", 
                    [1] = v162.yaw_mode
                }, {
                    [1] = nil, 
                    [2] = "Random", 
                    [1] = v162.delay_method
                }, {
                    [1] = nil, 
                    [2] = true, 
                    [1] = v162.delay
                });
                v162.delay_custom_sliders = v165:slider(v12.text(v84, "Sliders", 17, 2, 2), 2, 6, 2):depend({
                    [1] = nil, 
                    [2] = "Backward", 
                    [1] = v162.yaw
                }, {
                    [1] = nil, 
                    [2] = "L/R", 
                    [1] = v162.yaw_mode
                }, {
                    [1] = nil, 
                    [2] = "Custom", 
                    [1] = v162.delay_method
                }, {
                    [1] = nil, 
                    [2] = true, 
                    [1] = v162.delay
                });
                do
                    local l_v161_0 = v161;
                    do
                        local l_v162_0, l_l_state_0_0 = v162, l_state_0;
                        for v169 = 1, 6 do
                            do
                                local l_v169_0 = v169;
                                l_v162_0["delay_" .. l_v169_0] = v165:slider(v12.text(v127, ("%s"):format(l_v169_0), 14 + 5 * l_v169_0, 2, 2), 2, 22, 0):depend({
                                    [1] = nil, 
                                    [2] = "Backward", 
                                    [1] = l_v162_0.yaw
                                }, {
                                    [1] = nil, 
                                    [2] = "L/R", 
                                    [1] = l_v162_0.yaw_mode
                                }, {
                                    [1] = nil, 
                                    [2] = "Custom", 
                                    [1] = l_v162_0.delay_method
                                }, {
                                    [1] = nil, 
                                    [2] = true, 
                                    [1] = l_v162_0.delay
                                }, {
                                    [1] = l_v162_0.delay_custom_sliders, 
                                    [2] = function()
                                        -- upvalues: l_v169_0 (ref), l_v162_0 (ref)
                                        if l_v169_0 <= 2 then
                                            return true;
                                        else
                                            return l_v162_0.delay_custom_sliders.value >= l_v169_0;
                                        end;
                                    end
                                });
                            end;
                        end;
                        l_v162_0.modifier = v146:combo(v12.text(v127, "Modifier", 10, 2, 2), {
                            [1] = "Disabled", 
                            [2] = "Center", 
                            [3] = "Offset", 
                            [4] = "Random", 
                            [5] = "Spin", 
                            [6] = "3-Way", 
                            [7] = "Bobro", 
                            [8] = "5-Way"
                        }):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = "Backward", 
                            [1] = l_v162_0.yaw
                        });
                        v165 = l_v162_0.modifier:create();
                        l_v162_0.randomize = v165:switch(v12.text("", "Randomize", 0, 0, 0)):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = "Backward", 
                            [1] = l_v162_0.yaw
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = l_v162_0.modifier
                        });
                        l_v162_0.modifier_mode = v165:combo(v12.text("", "Mode", 0, 0, 0), "Default", "Custom"):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = "Backward", 
                            [1] = l_v162_0.yaw
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = l_v162_0.modifier
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.randomize
                        });
                        l_v162_0.min = v165:slider(v12.text(v127, "Minimum", 10, 2, 2), -180, 180, 0):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = "Backward", 
                            [1] = l_v162_0.yaw
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = l_v162_0.modifier
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.randomize
                        }, {
                            [1] = nil, 
                            [2] = "Default", 
                            [1] = l_v162_0.modifier_mode
                        });
                        l_v162_0.max = v165:slider(v12.text(v127, "Maximum", 10, 2, 2), -180, 180, 0):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = "Backward", 
                            [1] = l_v162_0.yaw
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = l_v162_0.modifier
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.randomize
                        }, {
                            [1] = nil, 
                            [2] = "Default", 
                            [1] = l_v162_0.modifier_mode
                        });
                        l_v162_0.modifier_custom_sliders = v165:slider(v12.text(v84, "Sliders", 7, 5, 2), 2, 6, 2):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = "Backward", 
                            [1] = l_v162_0.yaw
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = l_v162_0.modifier
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.randomize
                        }, {
                            [1] = nil, 
                            [2] = "Custom", 
                            [1] = l_v162_0.modifier_mode
                        });
                        for v171 = 1, 6 do
                            do
                                local l_v171_0 = v171;
                                l_v162_0["modifier_sliders_" .. l_v171_0] = v165:slider(v12.text(v127, ("%s"):format(l_v171_0), 10 + 5 * l_v171_0, 2, 2), -180, 180, 0):depend({
                                    [1] = l_team_0, 
                                    [2] = v160
                                }, {
                                    [1] = l_l_state_0_0, 
                                    [2] = l_v157_0
                                }, {
                                    [1] = nil, 
                                    [2] = "Backward", 
                                    [1] = l_v162_0.yaw
                                }, {
                                    [1] = nil, 
                                    [2] = "Disabled", 
                                    [3] = true, 
                                    [1] = l_v162_0.modifier
                                }, {
                                    [1] = nil, 
                                    [2] = true, 
                                    [1] = l_v162_0.randomize
                                }, {
                                    [1] = nil, 
                                    [2] = "Custom", 
                                    [1] = l_v162_0.modifier_mode
                                }, {
                                    [1] = l_v162_0.modifier_custom_sliders, 
                                    [2] = function()
                                        -- upvalues: l_v171_0 (ref), l_v162_0 (ref)
                                        if l_v171_0 <= 2 then
                                            return true;
                                        else
                                            return l_v162_0.modifier_custom_sliders.value >= l_v171_0;
                                        end;
                                    end
                                });
                            end;
                        end;
                        l_v162_0.modifier_offset = v165:slider(v12.text(v84, "Offset", 2, 2, 2), -180, 180, 0):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = "Backward", 
                            [1] = l_v162_0.yaw
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = l_v162_0.modifier
                        }, {
                            [1] = nil, 
                            [2] = false, 
                            [1] = l_v162_0.randomize
                        });
                        l_v162_0.body_yaw = v146:switch(v12.text(v84, "Body Yaw", 2, 2, 2)):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        });
                        v165 = l_v162_0.body_yaw:create();
                        l_v162_0.body_freestanding = v165:combo("Freestanding", {
                            [1] = "Off", 
                            [2] = "Peek Fake", 
                            [3] = "Peek Real"
                        }):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.body_yaw
                        });
                        l_v162_0.mode = v165:combo(v12.text("", "Mode", 0, 0, 0), {
                            [1] = "Static", 
                            [2] = "Ticks", 
                            [3] = "Random"
                        }):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.body_yaw
                        });
                        l_v162_0.mode_ticks = v165:slider(v12.text(v127, "Ticks", 10, 2, 2), 4, 16, 4, 1, "t"):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.body_yaw
                        }, {
                            [1] = nil, 
                            [2] = "Ticks", 
                            [1] = l_v162_0.mode
                        });
                        l_v162_0.mode_random = v165:slider(v12.text(v127, "Random Ticks", 10, 2, 2), 4, 16, 4, 1, "x"):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.body_yaw
                        }, {
                            [1] = nil, 
                            [2] = "Random", 
                            [1] = l_v162_0.mode
                        });
                        l_v162_0.limit_mode = v165:combo(v12.text("", "Limit Mode", 0, 0, 0), {
                            [1] = "Static", 
                            [2] = "Random", 
                            [3] = "From/To", 
                            [4] = "Speed-based Switch"
                        }):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.body_yaw
                        });
                        l_v162_0.left_limit = v165:slider(v12.text(v127, "Left Limit", 10, 2, 2), 0, 60, 60):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.body_yaw
                        }, {
                            [1] = nil, 
                            [2] = "Static", 
                            [1] = l_v162_0.limit_mode
                        });
                        l_v162_0.right_limit = v165:slider(v12.text(v127, "Right Limit", 10, 2, 2), 0, 60, 60):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.body_yaw
                        }, {
                            [1] = nil, 
                            [2] = "Static", 
                            [1] = l_v162_0.limit_mode
                        });
                        l_v162_0.minimum_limit = v165:slider(v12.text(v127, "Minimum", 10, 2, 2), 0, 60, 60):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.body_yaw
                        }, {
                            [1] = nil, 
                            [2] = "Random", 
                            [1] = l_v162_0.limit_mode
                        });
                        l_v162_0.maximum_limit = v165:slider(v12.text(v127, "Maximum", 10, 2, 2), 0, 60, 60):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.body_yaw
                        }, {
                            [1] = nil, 
                            [2] = "Random", 
                            [1] = l_v162_0.limit_mode
                        });
                        l_v162_0.from_limit = v165:slider(v12.text(v127, "From", 10, 2, 2), 0, 60, 60):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.body_yaw
                        }, {
                            [1] = l_v162_0.limit_mode, 
                            [2] = function()
                                -- upvalues: l_v162_0 (ref)
                                return l_v162_0.limit_mode:get() == "From/To" or l_v162_0.limit_mode:get() == "Speed-based Switch";
                            end
                        });
                        l_v162_0.to_limit = v165:slider(v12.text(v127, "To", 10, 2, 2), 0, 60, 60):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.body_yaw
                        }, {
                            [1] = l_v162_0.limit_mode, 
                            [2] = function()
                                -- upvalues: l_v162_0 (ref)
                                return l_v162_0.limit_mode:get() == "From/To" or l_v162_0.limit_mode:get() == "Speed-based Switch";
                            end
                        });
                        l_v162_0.sb_speed = v165:slider(v12.text(v127, "\aFFA500FFTiming\r", 15, 2, 2), 1, 22, 0):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.body_yaw
                        }, {
                            [1] = nil, 
                            [2] = "Speed-based Switch", 
                            [1] = l_v162_0.limit_mode
                        });
                        l_v162_0.body_yaw_options = v146:selectable(v12.text(v127, "Options", 10, 2, 2), {
                            [1] = "Avoid Overlap", 
                            [2] = "Jitter", 
                            [3] = "Randomize Jitter", 
                            [4] = "Anti Bruteforce"
                        }):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.body_yaw
                        });
                        l_v162_0.send_to_opposite = v146:button(v12.text("share-from-square", "Send to the opposite side", 17, 2, 20), function()
                            -- upvalues: l_v161_0 (ref), l_l_state_0_0 (ref), l_v148_0 (ref), l_v162_0 (ref)
                            local v173 = l_v161_0 == "T" and "CT" or "T";
                            local v174 = l_v148_0[l_l_state_0_0:list()[l_l_state_0_0:get()]][v173];
                            for v175, v176 in pairs(l_v162_0) do
                                for v177, v178 in pairs(v174) do
                                    if v175 == v177 and v175 ~= "send_to_opposite" then
                                        v178:set(v176:get());
                                    end;
                                end;
                            end;
                        end, true):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        });
                        l_v162_0.choke = l_v147_0.group:combo(v12.text(v84, "Tickbase", 2, 5, 2, "ff0000ff"), {
                            [1] = "Default", 
                            [2] = "Custom"
                        }):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = l_v147_0.select, 
                            [2] = function()
                                -- upvalues: l_v147_0 (ref), l_v157_0 (ref)
                                return l_v147_0.select:get(l_v157_0);
                            end
                        });
                        v165 = l_v162_0.choke:create();
                        l_v162_0.random_choke = v165:switch(v12.text("", "Random Choke", 0, 0, 0)):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = "Custom", 
                            [1] = l_v162_0.choke
                        });
                        l_v162_0.choke_slider = v165:slider(v12.text(v127, "Choke", 10, 2, 2), 2, 22, 16, 1, "t"):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = "Custom", 
                            [1] = l_v162_0.choke
                        }, {
                            [1] = nil, 
                            [2] = false, 
                            [1] = l_v162_0.random_choke
                        });
                        l_v162_0.choke_method = v165:combo(v12.text(v84, "Method", 2, 2, 2), {
                            [1] = "Default", 
                            [2] = "Custom"
                        }):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = "Custom", 
                            [1] = l_v162_0.choke
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.random_choke
                        });
                        l_v162_0.choke_from = v165:slider(v12.text(v127, "Choke from", 10, 2, 2), 1, 22, 16):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = "Custom", 
                            [1] = l_v162_0.choke
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.random_choke
                        }, {
                            [1] = nil, 
                            [2] = "Default", 
                            [1] = l_v162_0.choke_method
                        });
                        l_v162_0.choke_to = v165:slider(v12.text(v127, "Choke to", 10, 2, 2), 1, 22, 16):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = "Custom", 
                            [1] = l_v162_0.choke
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.random_choke
                        }, {
                            [1] = nil, 
                            [2] = "Default", 
                            [1] = l_v162_0.choke_method
                        });
                        l_v162_0.choke_sliders = v165:slider(v12.text("", "Sliders", 15, 0, 0), 2, 6, 2):depend({
                            [1] = l_team_0, 
                            [2] = v160
                        }, {
                            [1] = l_l_state_0_0, 
                            [2] = l_v157_0
                        }, {
                            [1] = nil, 
                            [2] = "Custom", 
                            [1] = l_v162_0.choke
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = l_v162_0.random_choke
                        }, {
                            [1] = nil, 
                            [2] = "Custom", 
                            [1] = l_v162_0.choke_method
                        });
                        for v179 = 1, 6 do
                            do
                                local l_v179_0 = v179;
                                l_v162_0["choke1_" .. l_v179_0] = v165:slider(v12.text(v127, ("%s"):format(l_v179_0), 14 + 5 * l_v179_0, 2, 2), 2, 22, 0, 1, "t"):depend({
                                    [1] = l_team_0, 
                                    [2] = v160
                                }, {
                                    [1] = l_l_state_0_0, 
                                    [2] = l_v157_0
                                }, {
                                    [1] = nil, 
                                    [2] = "Custom", 
                                    [1] = l_v162_0.choke
                                }, {
                                    [1] = nil, 
                                    [2] = true, 
                                    [1] = l_v162_0.random_choke
                                }, {
                                    [1] = nil, 
                                    [2] = "Custom", 
                                    [1] = l_v162_0.choke_method
                                }, {
                                    [1] = l_v162_0.choke_sliders, 
                                    [2] = function()
                                        -- upvalues: l_v179_0 (ref), l_v162_0 (ref)
                                        if l_v179_0 <= 2 then
                                            return true;
                                        else
                                            return l_v162_0.choke_sliders.value >= l_v179_0;
                                        end;
                                    end
                                });
                            end;
                        end;
                        l_v148_0[v158][l_v161_0] = l_v162_0;
                        v145.builder = l_v148_0;
                    end;
                end;
            end;
        end;
    end;
    v149 = {
        switch = v146:switch(v12.text(v84, "Freestanding", 2, 7, 2))
    };
    v150 = v149.switch:create();
    v149.prefer_manual = v150:switch("\v\194\187\r Prefer Manual");
    v152 = v57;
    table.remove(v152, 9);
    v149.disablers = v150:selectable("Disablers", v152);
    v149.body_fs = v150:switch("Body Freestanding");
    v149.yaw_mod = v150:switch("Disable Yaw Modifiers");
    v145.freestanding = v149;
    v150 = {
        switch = v146:switch(v12.text(v84, "Anti-Bruteforce", 2, 7, 2), false, "Anti-bruteforce with automatic preset to avoid headshot.")
    };
    v152 = v150.switch:create();
    v150.states = v152:selectable("States", v57):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v150.switch
    });
    v150.timeout = v152:slider(v12.text(v127, "Timeout", 7, 2, 2), 1, 10, 3, 1, "s"):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v150.switch
    }, {
        [1] = nil, 
        [2] = true, 
        [1] = v150.states
    });
    v150.mode = v152:combo(v12.text(v127, "Mode", 7, 2, 2), {
        [1] = "Increasing", 
        [2] = "Decreasing", 
        [3] = "Meta"
    }):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v150.switch
    }, {
        [1] = nil, 
        [2] = true, 
        [1] = v150.states
    });
    v150.notify = v152:switch("Notify"):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v150.switch
    }, {
        [1] = nil, 
        [2] = true, 
        [1] = v150.states
    });
    v145.anti_bruteforce = v150;
    v143.angles = v145;
end;
v14.antiaim = v143;
v144 = {
    features = {
        force_interpolation = l_pui_0.create(v12.text("bottle-droplet", "", 0, 0, 0), " ", 1):switch(v12.text("code-pull-request-draft", "\aa8bfccffForce Interpolation", 2, 7, 2, "a6a75eff"), false, "Makes the game feel smoother by disabling specific engine mechanics that make the game reset the interpolation.")
    }
};
v146 = {};
v147 = l_pui_0.create(v12.text("bottle-droplet", "", 0, 0, 0), "Animations", 1);
v148 = {
    switch = v147:switch(v12.text("ghost", "Jitter Legs", 2, 12, 2))
};
v149 = v148.switch:create();
v148.from = v149:slider("From", 0, 100, 0, 0.01, "x"):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v148.switch
});
v148.to = v149:slider("To", 0, 100, 0, 0.01, "x"):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v148.switch
});
v146.jitter_legs = v148;
v146.leaning = {
    value = v147:slider(v12.text("person-walking-arrow-right", "Leaning", 2, 7, 2), -1, 200, 50, 1, function(v181)
        if v181 == -1 then
            return "Off";
        else
            return v181 .. "%";
        end;
    end)
};
v146.falling = {
    value = v147:slider(v12.text("person-falling", "Falling", 2, 11, 2), -1, 100, 50, 1, function(v182)
        if v182 == -1 then
            return "Off";
        else
            return v182 .. "%";
        end;
    end)
};
v144.player_animations = v146;
v147 = {};
v148 = l_pui_0.create(v12.text("bottle-droplet", "", 0, 0, 0), "Aimbot", 1);
v149 = {
    switch = v148:switch(v12.text("chart-line", "Unlock Fake Latency", 2, 7, 2), false, "Allows you to use maximum Fake Latency (200-300)")
};
v150 = cvar.sv_maxunlag;
do
    local l_v149_0 = v149;
    do
        local l_v150_1, l_v152_0 = v150, v152;
        l_v152_0 = function()
            -- upvalues: l_v150_1 (ref), v51 (ref)
            l_v150_1:float(v51(l_v150_1));
        end;
        v153 = function()
            -- upvalues: l_v149_0 (ref), l_v152_0 (ref), l_v150_1 (ref)
            if not l_v149_0.switch:get() then
                return l_v152_0();
            else
                l_v150_1:float(2);
                return;
            end;
        end;
        l_v149_0.switch:set_callback(v153, true);
        v147.latency = l_v149_0;
    end;
    v147.fakeduck = {
        unlock = v148:switch(v12.text("person-running", "Unlock FD Speed", 2, 7, 2), false, "Allows you to move a bit faster on Fake duck"), 
        freeze_period = v148:switch(v12.text("server", "Fakeduck on Freezetime", 2, 7, 2), false, "Allows you to Fake duck on freezetime period.\n\n Helps on de_bank a lot.")
    };
    v152 = {
        switch = v148:switch(v12.text("blanket", "Log Events", 2, 7, 2))
    };
    v153 = v152.switch:create();
    v154 = {
        select = v153:selectable("Events", {
            [1] = "Aimbot", 
            [2] = "Connection problems", 
            [3] = "Low FPS"
        }):depend({
            [1] = nil, 
            [2] = true, 
            [1] = v152.switch
        })
    };
    v154.is_notification = v153:switch(v12.text(v127, "Notification", 10, 2, 2)):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v152.switch
    }, {
        [1] = nil, 
        [2] = "Aimbot", 
        [1] = v154.select
    });
    v152.mode = v154;
    v152.customization = {
        prefix = v153:input("Prefix", "gazolina.lc"):depend({
            [1] = nil, 
            [2] = true, 
            [1] = v152.switch
        }, {
            [1] = nil, 
            [2] = "Aimbot", 
            [1] = v154.select
        })
    };
    v152.colors = {
        prefix = v153:color_picker(v12.text(v127, "Prefix Color", 10, 2, 2)):depend({
            [1] = nil, 
            [2] = true, 
            [1] = v152.switch
        }, {
            [1] = nil, 
            [2] = "Aimbot", 
            [1] = v154.select
        }), 
        main = v153:color_picker(v12.text(v127, "Main Color", 10, 2, 2)):depend({
            [1] = nil, 
            [2] = true, 
            [1] = v152.switch
        }, {
            [1] = nil, 
            [2] = "Aimbot", 
            [1] = v154.select
        })
    };
    v147.logging = v152;
    v153 = {
        switch = v148:switch(v12.text("bomb", "Grenade Release", 2, 7, 2), false, "May work a bit unstable. \n Some FPS drops may happen")
    };
    v154 = v153.switch:create();
    v153.molly_distance = v154:slider("Molly Distance", 330, 500, 100, 0.01):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v153.switch
    });
    v153.damage = v154:slider("Explosive Damage", 0, 50, 0, 1, function(v186)
        if v186 == 0 then
            return "Fatal";
        else
            return;
        end;
    end):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v153.switch
    });
    v153.collision_info = v154:switch(v12.text(v127, "Collision Info", 10, 2, 2)):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v153.switch
    });
    v147.grenade_release = v153;
    v144.aimbot = v147;
end;
v148 = {};
v149 = l_pui_0.create(v12.text("bottle-droplet", "", 0, 0, 0), "Movement", 1);
v148.fall_damage = v149:switch(v12.text("person-falling-burst", "Avoid Fall Damage", 2, 7, 2), false, "Attempts to perform a jumpbug\nwhen possible.\n\nThis is a 1:1 replica from \a7a9809ffgamesense\r");
v148.fast_ladder = v149:switch(v12.text("water-ladder", "Fast Ladder", 2, 7, 2), false, "- Abuses the ladder movement\nmechanic and makes you move a\nlittle faster");
v148.air_duck_collision = v149:switch(v12.text("person-walking-dashed-line-arrow-right", "Collision Air Duck", 2, 5, 2), false, "Automatically ducks if there's a possibility of avoiding collision by making the player fully-ducked. \n\nDoesn't work on ground.");
v148.edge_quick_stop = v149:switch(v12.text("person-circle-exclamation", "Edge Quick Stop", 2, 7, 2), false, "Prevents you from walking or jumping off edges, similar to the Minecraft sneaking mechanic. \n\nWorks best with Peek Assist.");
v148.skeet_retreat = v149:switch(v12.text("bomb", "Quick Peek Assist Retreat", 2, 7, 2), false, "Ported skeet function");
v144.movement = v148;
v14.misc = v144;
v145 = {};
v146 = l_pui_0.create(v12.text("bottle-droplet", "", 0, 0, 0), "Visuals", 2);
v147 = {
    switch = v146:switch(v12.text("star", "Better Scope Overlay", 2, 7, 2))
};
v148 = v147.switch:create();
v147.options = v148:selectable("Options", {
    [1] = "Rotation", 
    [2] = "Inverted"
}):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v147.switch
});
v147.animation = v148:switch(v12.text(v127, "Animated", 10, 2, 2)):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v147.switch
}):depend({
    [1] = nil, 
    [2] = "Rotation", 
    [1] = v147.options
});
v147.length = v148:slider("Length", 10, 300, 185):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v147.switch
});
v147.gap = v148:slider("Gap", 1, 300, 5):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v147.switch
});
v147.colors = {
    main = v148:color_picker("Main Accent", color(255)):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v147.switch
    }), 
    edge = v148:color_picker("Edge Accent", color(0)):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v147.switch
    })
};
v145.scope_overlay = v147;
v148 = {
    switch = v146:switch(v12.text("up-down-left-right", "Manual Arrows", 2, 7, 2))
};
v149 = v148.switch:create();
v148.font = v149:combo("Font", {
    [1] = "Default", 
    [2] = "Small", 
    [3] = "Console", 
    [4] = "Bold"
}):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v148.switch
});
v148.color = v149:color_picker("Color", color()):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v148.switch
});
v148.offset = v149:slider("Offset", 0, 200, 35):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v148.switch
});
v148.symbols = {
    left = v149:input("Left Symbol", "\229\138\155\233\135\143"):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v148.switch
    }), 
    right = v149:input("Right Symbol", "\229\138\155\233\135\143"):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v148.switch
    }), 
    forward = v149:input("Forward Symbol", "\229\138\155\233\135\143"):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v148.switch
    })
};
v145.manual_arrows = v148;
v149 = {
    switch = v146:switch(v12.text("calculator", "Aspect Ratio", 2, 7, 2))
};
v149.value = v149.switch:create():slider("Value", 1, 200, 133, 0.01):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v149.switch
});
v152 = cvar.r_aspectratio;
do
    local l_v149_1, l_v150_2 = v149, v150;
    do
        local l_v152_1, l_v153_0 = v152, v153;
        l_v153_0 = function()
            -- upvalues: l_v152_1 (ref), v51 (ref)
            l_v152_1:float(v51(l_v152_1));
        end;
        v154 = function()
            -- upvalues: l_v149_1 (ref), l_v153_0 (ref), l_v152_1 (ref)
            if not l_v149_1.switch:get() then
                return l_v153_0();
            else
                local v191 = l_v149_1.value:get() * 0.01;
                l_v152_1:float(v191, true);
                return;
            end;
        end;
        l_v149_1.switch:set_callback(v154, true);
        l_v149_1.value:set_callback(v154);
        events.shutdown(l_v153_0);
        v145.aspect_ratio = l_v149_1;
    end;
    l_v150_2 = {
        switch = v146:switch(v12.text("person-military-pointing", "Viewmodel Changer", 2, 7, 2))
    };
    v152 = l_v150_2.switch:create();
    l_v150_2.fov = v152:slider("Field of View", 0, 1000, 680, 0.1):depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_v150_2.switch
    });
    l_v150_2.x = v152:slider("Offset X", -100, 100, 0, 0.1):depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_v150_2.switch
    });
    l_v150_2.y = v152:slider("Offset Y", -100, 100, 0, 0.1):depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_v150_2.switch
    });
    l_v150_2.z = v152:slider("Offset Z", -100, 100, 0, 0.1):depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_v150_2.switch
    });
    v153 = cvar.viewmodel_fov;
    v154 = cvar.viewmodel_offset_x;
    local l_viewmodel_offset_y_0 = cvar.viewmodel_offset_y;
    local l_viewmodel_offset_z_0 = cvar.viewmodel_offset_z;
    do
        local l_v153_1, l_v154_0, l_l_viewmodel_offset_y_0_0, l_l_viewmodel_offset_z_0_0 = v153, v154, l_viewmodel_offset_y_0, l_viewmodel_offset_z_0;
        local function v198()
            -- upvalues: l_v153_1 (ref), v51 (ref), l_v154_0 (ref), l_l_viewmodel_offset_y_0_0 (ref), l_l_viewmodel_offset_z_0_0 (ref)
            l_v153_1:float(v51(l_v153_1), false);
            l_v154_0:float(v51(l_v154_0), false);
            l_l_viewmodel_offset_y_0_0:float(v51(l_l_viewmodel_offset_y_0_0), false);
            l_l_viewmodel_offset_z_0_0:float(v51(l_l_viewmodel_offset_z_0_0), false);
        end;
        local function v203()
            -- upvalues: l_v150_2 (ref), v198 (ref), l_v153_1 (ref), l_v154_0 (ref), l_l_viewmodel_offset_y_0_0 (ref), l_l_viewmodel_offset_z_0_0 (ref)
            if not l_v150_2.switch:get() then
                return v198();
            else
                local v199 = l_v150_2.x:get();
                local v200 = l_v150_2.y:get();
                local v201 = l_v150_2.z:get();
                local v202 = l_v150_2.fov:get();
                l_v153_1:float(v202 * 0.1, true);
                l_v154_0:float(v199 * 0.1, true);
                l_l_viewmodel_offset_y_0_0:float(v200 * 0.1, true);
                l_l_viewmodel_offset_z_0_0:float(v201 * 0.1, true);
                return;
            end;
        end;
        l_v150_2.switch:set_callback(v203, true);
        l_v150_2.x:set_callback(v203);
        l_v150_2.y:set_callback(v203);
        l_v150_2.z:set_callback(v203);
        l_v150_2.fov:set_callback(v203);
        events.shutdown(v198);
        v145.viewmodel_changer = l_v150_2;
    end;
    v152 = {
        switch = v146:switch(v12.text("paintbrush", "Game\a95b806ffSense\r Indicators", 2, 7, 2))
    };
    v153 = v152.switch:create();
    v152.bomb = v153:switch("Bomb"):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v152.switch
    });
    v152.features = v153:selectable("Feature indicators", {
        [1] = "Force safe point", 
        [2] = "Force body aim", 
        [3] = "Ping spike", 
        [4] = "Double tap", 
        [5] = "Duck peek assist", 
        [6] = "Freestanding", 
        [7] = "On shot anti-aim", 
        [8] = "Minimum damage override", 
        [9] = "Hitchance override", 
        [10] = "Dormant aimbot"
    }):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v152.switch
    });
    v145.skeet_indicators = v152;
    v153 = {
        switch = v146:switch(v12.text("person-running", "Velocity Warning", 2, 7, 2))
    };
    v153.color = v153.switch:create():color_picker("Color"):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v153.switch
    });
    v145.velocity_warning = v153;
    v154 = {
        select = v146:selectable(v12.text("marker", "Hit Marker", 2, 7, 2), {
            [1] = "2D", 
            [2] = "3D"
        })
    };
    l_viewmodel_offset_y_0 = v154.select:create();
    v154.color = l_viewmodel_offset_y_0:color_picker("Color", {
        ["2D"] = {
            color(255)
        }, 
        ["3D"] = {
            color(255)
        }
    }):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v154.select
    });
    v154.time = l_viewmodel_offset_y_0:slider("Duration", 0, 100, 1, 0.1, "s"):depend({
        [1] = nil, 
        [2] = true, 
        [1] = v154.select
    });
    v145.hitmarker = v154;
    v145.player_transparency = {
        switch = v146:switch(v12.text("person-through-window", "Keep Model Transparency", 2, 7, 2), false, "Keeps the local player model transparent after shooting with bolt-action sniper rifles and adds extra fade-in/out animation \n\nThis is a 1:1 replica from \a95b806ffgamesense")
    };
    v145.damage_indicator = {
        switch = v146:switch(v12.text("person-circle-exclamation", "Damage Indicator", 2, 7, 2))
    };
    v145.remove_sleeves = {
        switch = v146:switch(v12.text("shirt-long-sleeve", "Remove Sleeves", 2, 7, 2))
    };
    local v204 = {
        switch = v146:switch(v12.text("clock", "Clock Correction", 2, 7, 2))
    };
    v204.ticks = v204.switch:create():slider("Client-issued ticks", 1, 22, 17, 1, function(v205)
        if v205 == 16 then
            return "NL";
        elseif v205 == 17 then
            return "GS";
        else
            return;
        end;
    end):depend(v204.switch);
    local l_sv_maxusrcmdprocessticks_0 = cvar.sv_maxusrcmdprocessticks;
    do
        local l_l_sv_maxusrcmdprocessticks_0_0 = l_sv_maxusrcmdprocessticks_0;
        local function v208()
            -- upvalues: l_l_sv_maxusrcmdprocessticks_0_0 (ref), v51 (ref)
            l_l_sv_maxusrcmdprocessticks_0_0:int(v51(l_l_sv_maxusrcmdprocessticks_0_0), false);
        end;
        local function v210()
            -- upvalues: v204 (ref), v208 (ref), l_l_sv_maxusrcmdprocessticks_0_0 (ref)
            if not v204.switch:get() then
                return v208();
            else
                local v209 = v204.ticks:get();
                l_l_sv_maxusrcmdprocessticks_0_0:int(v209, true);
                return;
            end;
        end;
        v204.switch:set_callback(v210, true);
        v204.ticks:set_callback(v210);
        events.shutdown(v208);
        v145.clock_correction = v204;
    end;
    v14.visuals = v145;
end;
v84 = {};
do
    local l_v84_2, l_v127_1, l_v134_1, l_v143_0 = v84, v127, v134, v143;
    v15.new = function(v215, v216, v217)
        -- upvalues: l_v84_2 (ref)
        table.insert(l_v84_2, {
            alpha = 0, 
            text = v215, 
            duration = globals.realtime + 3, 
            color = v216 or ui.get_style()["Link Active"], 
            icon = v217 or "bolt"
        });
    end;
    l_v127_1 = function(v218, v219, v220, v221, v222, _)
        if not v221 then
            v221 = color(255);
        end;
        local v224 = render.measure_text(1, "d", v219) + vector(33, 10);
        v220 = v220 - vector(v224.x / 2, 0);
        render.rect_outline(v220, v220 + v224, color(0):alpha_modulate(v222), 1, 5);
        render.rect(v220, v220 + v224, color(0, 0, 0, 120 * (v222 / 255)), 5);
        render.rect(v220 + vector(25, 4), v220 + vector(25, v224.y - 4), color(160, 160, 160, 160 * (v222 / 255)), 0);
        render.text(1, v220 + vector(8, 4), v221.alpha_modulate(v221, v222), "d", ui.get_icon(v218));
        render.text(1, v220 + vector(30, 4), color():alpha_modulate(v222), "d", v219);
    end;
    l_v134_1 = function(v225, v226, v227)
        -- upvalues: v13 (ref), l_v127_1 (ref), v12 (ref), l_v84_2 (ref)
        local l_text_0 = v225.text;
        local v229 = v225.color or color(255);
        v225.alpha = v13.interp(v225.alpha, globals.realtime < v225.duration and 255 or 0, 0.05);
        local l_alpha_0 = v225.alpha;
        l_v127_1(v225.icon, v12.text_colored((function()
            -- upvalues: l_text_0 (ref), v229 (ref), l_alpha_0 (ref)
            local v231 = {};
            for v232, v233 in pairs(l_text_0) do
                if not v233 then
                    v233 = "";
                end;
                table.insert(v231, {
                    v233, 
                    (v232 % 2 == 0 and v229 or color(255)):alpha_modulate(l_alpha_0)
                });
            end;
            return unpack(v231);
        end)()), v226 + vector(0, v227), v229, l_alpha_0, v227);
        return l_alpha_0 < 0.01 and not (v225.duration + 3 >= globals.realtime) or #l_v84_2 > 10, l_alpha_0;
    end;
    v15.draw = function()
        -- upvalues: v56 (ref), l_v84_2 (ref), v14 (ref), l_v134_1 (ref)
        local v234 = v56 / vector(2, 1.4);
        local v235 = 0;
        for v236 = #l_v84_2, 1, -1 do
            local v237 = l_v84_2[v236];
            if v14.info.notify.style:get() == "Cat" then
                local v238, v239 = l_v134_1(v237, v234, v235);
                if v238 then
                    table.remove(l_v84_2, v236);
                end;
                v235 = v235 + 27 * (v239 / 255);
            end;
        end;
    end;
    l_v143_0 = function()
        -- upvalues: v14 (ref), v15 (ref), l_v143_0 (ref)
        if not v14.info.notify.spam:get() then
            return;
        else
            v15.new({
                [1] = "Hello", 
                [2] = " world! ", 
                [3] = "boys and ", 
                [4] = "ladies", 
                [5] = "", 
                [6] = "", 
                [7] = "", 
                [8] = "", 
                [9] = ""
            }, color(255, 0, 0, 255));
            utils.execute_after(3.1, l_v143_0);
            return;
        end;
    end;
    v14.info.notify.spam:set_callback(l_v143_0, true);
end;
v84 = "suckmyballsufuckingretardsniggers";
v127 = db[v84] or {};
v134 = {
    [1] = {
        data = "eyJhdXRob3IiOiJub3BvaW50IiwiY29uZmlnIjoiZXlKaGJuUnBZV2x0SWpwN0ltRnVaMnhsY3lJNmV5SmhiblJwWDJKeWRYUmxabTl5WTJVaU9uc2liVzlrWlNJNklrMWxkR0VpTENKdWIzUnBabmtpT21aaGJITmxMQ0p6ZEdGMFpYTWlPbHNpVTNSaGJtUnBibWNpTENKU2RXNXVhVzVuSWl3aVUyeHZkMmx1WnlJc0lrTnliM1ZqYUdsdVp5SXNJbE51WldGcmFXNW5JaXdpUVdseUlpd2lRV2x5SUVOeWIzVmphR2x1WnlJc0lreGxaMmwwSUVGQklpd2lmaUpkTENKemQybDBZMmdpT25SeWRXVjlMQ0ppY21WaGExOXNZeUk2ZXlKa2FYTmhZbXhsWDI5dVgyZHlaVzVoWkdVaU9uUnlkV1VzSW1ocFpHVmZjMmh2ZEhNaU9pSkNjbVZoYXlCTVF5SXNJbk5sYkdWamRDSTZXeUpUZEdGdVpHbHVaeUlzSWxKMWJtNXBibWNpTENKVGJHOTNhVzVuSWl3aVEzSnZkV05vYVc1bklpd2lVMjVsWVd0cGJtY2lMQ0pCYVhJaUxDSkJhWElnUTNKdmRXTm9hVzVuSWl3aVRHVm5hWFFnUVVFaUxDSkdjbVZsYzNSaGJtUnBibWNpTENKK0lsMTlMQ0ppZFdsc1pHVnlJanA3SWtGcGNpSTZleUpEVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUkdWbVlYVnNkQ0lzSW1Ob2IydGxNVjh4SWpveUxqQXNJbU5vYjJ0bE1WOHlJam95TGpBc0ltTm9iMnRsTVY4eklqb3lMakFzSW1Ob2IydGxNVjgwSWpveUxqQXNJbU5vYjJ0bE1WODFJam95TGpBc0ltTm9iMnRsTVY4Mklqb3lMakFzSW1Ob2IydGxYMlp5YjIwaU9qRTJMakFzSW1Ob2IydGxYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpWOXpiR2xrWlhJaU9qRTJMakFzSW1Ob2IydGxYM05zYVdSbGNuTWlPakl1TUN3aVkyaHZhMlZmZEc4aU9qRTJMakFzSW1SbGJHRjVJanAwY25WbExDSmtaV3hoZVY4eElqb3lMakFzSW1SbGJHRjVYeklpT2pJdU1Dd2laR1ZzWVhsZk15STZNaTR3TENKa1pXeGhlVjgwSWpveUxqQXNJbVJsYkdGNVh6VWlPakl1TUN3aVpHVnNZWGxmTmlJNk1pNHdMQ0prWld4aGVWOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0prWld4aGVWOWtaV1poZFd4MElqbzNMakFzSW1SbGJHRjVYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0prWld4aGVWOXlZVzVrYjIxZmJXRjRJam95TGpBc0ltUmxiR0Y1WDNKaGJtUnZiVjl0YVc0aU9qSXVNQ3dpWm5KdmJWOXNhVzFwZENJNk5qQXVNQ3dpYkdWbWRGOXNhVzFwZENJNk5qQXVNQ3dpYkdsdGFYUmZiVzlrWlNJNklsTjBZWFJwWXlJc0ltMWhlQ0k2TUM0d0xDSnRZWGhwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YVc0aU9qQXVNQ3dpYldsdWFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXOWtaU0k2SWxOMFlYUnBZeUlzSW0xdlpHVmZjbUZ1Wkc5dElqbzBMakFzSW0xdlpHVmZkR2xqYTNNaU9qUXVNQ3dpYlc5a2FXWnBaWElpT2lKRWFYTmhZbXhsWkNJc0ltMXZaR2xtYVdWeVgyTjFjM1J2YlY5emJHbGtaWEp6SWpveUxqQXNJbTF2WkdsbWFXVnlYMjF2WkdVaU9pSkVaV1poZFd4MElpd2liVzlrYVdacFpYSmZiMlptYzJWMElqb3RNVE11TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpZaU9qQXVNQ3dpYjJabWMyVjBJam93TGpBc0luSmhibVJ2YlY5amFHOXJaU0k2Wm1Gc2MyVXNJbkpoYm1SdmJXbDZaU0k2Wm1Gc2MyVXNJbkpwWjJoMFgyeHBiV2wwSWpvMk1DNHdMQ0p6WWw5emNHVmxaQ0k2TVM0d0xDSjBiMTlzYVcxcGRDSTZOakF1TUN3aWVXRjNJam9pUW1GamEzZGhjbVFpTENKNVlYZGZiR1ZtZENJNkxUSXlMakFzSW5saGQxOXRiMlJsSWpvaVRDOVNJaXdpZVdGM1gzSnBaMmgwSWpvME1TNHdmU3dpVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUkdWbVlYVnNkQ0lzSW1Ob2IydGxNVjh4SWpveUxqQXNJbU5vYjJ0bE1WOHlJam95TGpBc0ltTm9iMnRsTVY4eklqb3lMakFzSW1Ob2IydGxNVjgwSWpveUxqQXNJbU5vYjJ0bE1WODFJam95TGpBc0ltTm9iMnRsTVY4Mklqb3lMakFzSW1Ob2IydGxYMlp5YjIwaU9qRTJMakFzSW1Ob2IydGxYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpWOXpiR2xrWlhJaU9qRTJMakFzSW1Ob2IydGxYM05zYVdSbGNuTWlPakl1TUN3aVkyaHZhMlZmZEc4aU9qRTJMakFzSW1SbGJHRjVJanAwY25WbExDSmtaV3hoZVY4eElqb3lMakFzSW1SbGJHRjVYeklpT2pJdU1Dd2laR1ZzWVhsZk15STZNaTR3TENKa1pXeGhlVjgwSWpveUxqQXNJbVJsYkdGNVh6VWlPakl1TUN3aVpHVnNZWGxmTmlJNk1pNHdMQ0prWld4aGVWOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0prWld4aGVWOWtaV1poZFd4MElqbzNMakFzSW1SbGJHRjVYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0prWld4aGVWOXlZVzVrYjIxZmJXRjRJam95TGpBc0ltUmxiR0Y1WDNKaGJtUnZiVjl0YVc0aU9qSXVNQ3dpWm5KdmJWOXNhVzFwZENJNk5qQXVNQ3dpYkdWbWRGOXNhVzFwZENJNk5qQXVNQ3dpYkdsdGFYUmZiVzlrWlNJNklsTjBZWFJwWXlJc0ltMWhlQ0k2TUM0d0xDSnRZWGhwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YVc0aU9qQXVNQ3dpYldsdWFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXOWtaU0k2SWxOMFlYUnBZeUlzSW0xdlpHVmZjbUZ1Wkc5dElqbzBMakFzSW0xdlpHVmZkR2xqYTNNaU9qUXVNQ3dpYlc5a2FXWnBaWElpT2lKRWFYTmhZbXhsWkNJc0ltMXZaR2xtYVdWeVgyTjFjM1J2YlY5emJHbGtaWEp6SWpveUxqQXNJbTF2WkdsbWFXVnlYMjF2WkdVaU9pSkVaV1poZFd4MElpd2liVzlrYVdacFpYSmZiMlptYzJWMElqb3RNVE11TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpZaU9qQXVNQ3dpYjJabWMyVjBJam93TGpBc0luSmhibVJ2YlY5amFHOXJaU0k2Wm1Gc2MyVXNJbkpoYm1SdmJXbDZaU0k2Wm1Gc2MyVXNJbkpwWjJoMFgyeHBiV2wwSWpvMk1DNHdMQ0p6WWw5emNHVmxaQ0k2TVM0d0xDSjBiMTlzYVcxcGRDSTZOakF1TUN3aWVXRjNJam9pUW1GamEzZGhjbVFpTENKNVlYZGZiR1ZtZENJNkxUSXlMakFzSW5saGQxOXRiMlJsSWpvaVRDOVNJaXdpZVdGM1gzSnBaMmgwSWpvME1TNHdmWDBzSWtGcGNpQkRjbTkxWTJocGJtY2lPbnNpUTFRaU9uc2lZV3hzYjNkZmMzUmhkR1VpT25SeWRXVXNJbUp2WkhsZlpuSmxaWE4wWVc1a2FXNW5Jam9pVDJabUlpd2lZbTlrZVY5NVlYY2lPblJ5ZFdVc0ltSnZaSGxmZVdGM1gyOXdkR2x2Ym5NaU9sc2lTbWwwZEdWeUlpd2lmaUpkTENKamFHOXJaU0k2SWtOMWMzUnZiU0lzSW1Ob2IydGxNVjh4SWpveE1DNHdMQ0pqYUc5clpURmZNaUk2TVRBdU1Dd2lZMmh2YTJVeFh6TWlPakU0TGpBc0ltTm9iMnRsTVY4MElqbzNMakFzSW1Ob2IydGxNVjgxSWpveE1DNHdMQ0pqYUc5clpURmZOaUk2TWpJdU1Dd2lZMmh2YTJWZlpuSnZiU0k2TVRZdU1Dd2lZMmh2YTJWZmJXVjBhRzlrSWpvaVEzVnpkRzl0SWl3aVkyaHZhMlZmYzJ4cFpHVnlJam94Tmk0d0xDSmphRzlyWlY5emJHbGtaWEp6SWpveUxqQXNJbU5vYjJ0bFgzUnZJam94TWk0d0xDSmtaV3hoZVNJNmRISjFaU3dpWkdWc1lYbGZNU0k2TWk0d0xDSmtaV3hoZVY4eUlqb3lMakFzSW1SbGJHRjVYek1pT2pJdU1Dd2laR1ZzWVhsZk5DSTZNaTR3TENKa1pXeGhlVjgxSWpveUxqQXNJbVJsYkdGNVh6WWlPakl1TUN3aVpHVnNZWGxmWTNWemRHOXRYM05zYVdSbGNuTWlPakl1TUN3aVpHVnNZWGxmWkdWbVlYVnNkQ0k2Tnk0d0xDSmtaV3hoZVY5dFpYUm9iMlFpT2lKU1lXNWtiMjBpTENKa1pXeGhlVjl5WVc1a2IyMWZiV0Y0SWpvNExqQXNJbVJsYkdGNVgzSmhibVJ2YlY5dGFXNGlPamN1TUN3aVpuSnZiVjlzYVcxcGRDSTZOakF1TUN3aWJHVm1kRjlzYVcxcGRDSTZOakF1TUN3aWJHbHRhWFJmYlc5a1pTSTZJa1p5YjIwdlZHOGlMQ0p0WVhnaU9pMHhNUzR3TENKdFlYaHBiWFZ0WDJ4cGJXbDBJam8yTUM0d0xDSnRhVzRpT2pBdU1Dd2liV2x1YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYlc5a1pTSTZJbFJwWTJ0eklpd2liVzlrWlY5eVlXNWtiMjBpT2pRdU1Dd2liVzlrWlY5MGFXTnJjeUk2TVRFdU1Dd2liVzlrYVdacFpYSWlPaUpUY0dsdUlpd2liVzlrYVdacFpYSmZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpYlc5a2FXWnBaWEpmYlc5a1pTSTZJa1JsWm1GMWJIUWlMQ0p0YjJScFptbGxjbDl2Wm1aelpYUWlPaTB4TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6RWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eUlqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTXlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelFpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODFJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5pSTZNQzR3TENKdlptWnpaWFFpT2pBdU1Dd2ljbUZ1Wkc5dFgyTm9iMnRsSWpwMGNuVmxMQ0p5WVc1a2IyMXBlbVVpT25SeWRXVXNJbkpwWjJoMFgyeHBiV2wwSWpvMk1DNHdMQ0p6WWw5emNHVmxaQ0k2TVM0d0xDSjBiMTlzYVcxcGRDSTZORGd1TUN3aWVXRjNJam9pUW1GamEzZGhjbVFpTENKNVlYZGZiR1ZtZENJNkxUSXlMakFzSW5saGQxOXRiMlJsSWpvaVRDOVNJaXdpZVdGM1gzSnBaMmgwSWpvME9TNHdmU3dpVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUTNWemRHOXRJaXdpWTJodmEyVXhYekVpT2pFd0xqQXNJbU5vYjJ0bE1WOHlJam94TUM0d0xDSmphRzlyWlRGZk15STZNVGd1TUN3aVkyaHZhMlV4WHpRaU9qY3VNQ3dpWTJodmEyVXhYelVpT2pFd0xqQXNJbU5vYjJ0bE1WODJJam95TWk0d0xDSmphRzlyWlY5bWNtOXRJam94Tmk0d0xDSmphRzlyWlY5dFpYUm9iMlFpT2lKRGRYTjBiMjBpTENKamFHOXJaVjl6Ykdsa1pYSWlPakUyTGpBc0ltTm9iMnRsWDNOc2FXUmxjbk1pT2pJdU1Dd2lZMmh2YTJWZmRHOGlPakV5TGpBc0ltUmxiR0Y1SWpwMGNuVmxMQ0prWld4aGVWOHhJam95TGpBc0ltUmxiR0Y1WHpJaU9qSXVNQ3dpWkdWc1lYbGZNeUk2TWk0d0xDSmtaV3hoZVY4MElqb3lMakFzSW1SbGJHRjVYelVpT2pJdU1Dd2laR1ZzWVhsZk5pSTZNaTR3TENKa1pXeGhlVjlqZFhOMGIyMWZjMnhwWkdWeWN5STZNaTR3TENKa1pXeGhlVjlrWldaaGRXeDBJam8zTGpBc0ltUmxiR0Y1WDIxbGRHaHZaQ0k2SWxKaGJtUnZiU0lzSW1SbGJHRjVYM0poYm1SdmJWOXRZWGdpT2pndU1Dd2laR1ZzWVhsZmNtRnVaRzl0WDIxcGJpSTZOeTR3TENKbWNtOXRYMnhwYldsMElqbzJNQzR3TENKc1pXWjBYMnhwYldsMElqbzJNQzR3TENKc2FXMXBkRjl0YjJSbElqb2lSbkp2YlM5VWJ5SXNJbTFoZUNJNkxURXhMakFzSW0xaGVHbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXBiaUk2TUM0d0xDSnRhVzVwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YjJSbElqb2lWR2xqYTNNaUxDSnRiMlJsWDNKaGJtUnZiU0k2TkM0d0xDSnRiMlJsWDNScFkydHpJam94TVM0d0xDSnRiMlJwWm1sbGNpSTZJbE53YVc0aUxDSnRiMlJwWm1sbGNsOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0p0YjJScFptbGxjbDl0YjJSbElqb2lSR1ZtWVhWc2RDSXNJbTF2WkdsbWFXVnlYMjltWm5ObGRDSTZMVEV3TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk1TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpJaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh6SWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOQ0k2TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6VWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4Mklqb3dMakFzSW05bVpuTmxkQ0k2TUM0d0xDSnlZVzVrYjIxZlkyaHZhMlVpT25SeWRXVXNJbkpoYm1SdmJXbDZaU0k2ZEhKMVpTd2ljbWxuYUhSZmJHbHRhWFFpT2pZd0xqQXNJbk5pWDNOd1pXVmtJam94TGpBc0luUnZYMnhwYldsMElqbzBPQzR3TENKNVlYY2lPaUpDWVdOcmQyRnlaQ0lzSW5saGQxOXNaV1owSWpvdE1qSXVNQ3dpZVdGM1gyMXZaR1VpT2lKTUwxSWlMQ0o1WVhkZmNtbG5hSFFpT2pRNUxqQjlmU3dpUTNKdmRXTm9hVzVuSWpwN0lrTlVJanA3SW1Gc2JHOTNYM04wWVhSbElqcDBjblZsTENKaWIyUjVYMlp5WldWemRHRnVaR2x1WnlJNklrOW1aaUlzSW1KdlpIbGZlV0YzSWpwMGNuVmxMQ0ppYjJSNVgzbGhkMTl2Y0hScGIyNXpJanBiSWtwcGRIUmxjaUlzSW40aVhTd2lZMmh2YTJVaU9pSkRkWE4wYjIwaUxDSmphRzlyWlRGZk1TSTZOaTR3TENKamFHOXJaVEZmTWlJNk1qSXVNQ3dpWTJodmEyVXhYek1pT2pRdU1Dd2lZMmh2YTJVeFh6UWlPakUwTGpBc0ltTm9iMnRsTVY4MUlqbzVMakFzSW1Ob2IydGxNVjgySWpvMExqQXNJbU5vYjJ0bFgyWnliMjBpT2pndU1Dd2lZMmh2YTJWZmJXVjBhRzlrSWpvaVEzVnpkRzl0SWl3aVkyaHZhMlZmYzJ4cFpHVnlJam94Tmk0d0xDSmphRzlyWlY5emJHbGtaWEp6SWpvMkxqQXNJbU5vYjJ0bFgzUnZJam95TWk0d0xDSmtaV3hoZVNJNmRISjFaU3dpWkdWc1lYbGZNU0k2TWk0d0xDSmtaV3hoZVY4eUlqb3lMakFzSW1SbGJHRjVYek1pT2pJdU1Dd2laR1ZzWVhsZk5DSTZNaTR3TENKa1pXeGhlVjgxSWpveUxqQXNJbVJsYkdGNVh6WWlPakl1TUN3aVpHVnNZWGxmWTNWemRHOXRYM05zYVdSbGNuTWlPakl1TUN3aVpHVnNZWGxmWkdWbVlYVnNkQ0k2T1M0d0xDSmtaV3hoZVY5dFpYUm9iMlFpT2lKRVpXWmhkV3gwSWl3aVpHVnNZWGxmY21GdVpHOXRYMjFoZUNJNk1UQXVNQ3dpWkdWc1lYbGZjbUZ1Wkc5dFgyMXBiaUk2TlM0d0xDSm1jbTl0WDJ4cGJXbDBJam8yTUM0d0xDSnNaV1owWDJ4cGJXbDBJam8yTUM0d0xDSnNhVzFwZEY5dGIyUmxJam9pVTNSaGRHbGpJaXdpYldGNElqb3dMakFzSW0xaGVHbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXBiaUk2TUM0d0xDSnRhVzVwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YjJSbElqb2lVM1JoZEdsaklpd2liVzlrWlY5eVlXNWtiMjBpT2pRdU1Dd2liVzlrWlY5MGFXTnJjeUk2TkM0d0xDSnRiMlJwWm1sbGNpSTZJbE53YVc0aUxDSnRiMlJwWm1sbGNsOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk15NHdMQ0p0YjJScFptbGxjbDl0YjJSbElqb2lRM1Z6ZEc5dElpd2liVzlrYVdacFpYSmZiMlptYzJWMElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTVNJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYeklpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHpJam90TVRVdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpZaU9qQXVNQ3dpYjJabWMyVjBJam93TGpBc0luSmhibVJ2YlY5amFHOXJaU0k2ZEhKMVpTd2ljbUZ1Wkc5dGFYcGxJanAwY25WbExDSnlhV2RvZEY5c2FXMXBkQ0k2TmpBdU1Dd2ljMkpmYzNCbFpXUWlPakV1TUN3aWRHOWZiR2x0YVhRaU9qWXdMakFzSW5saGR5STZJa0poWTJ0M1lYSmtJaXdpZVdGM1gyeGxablFpT2kweU55NHdMQ0o1WVhkZmJXOWtaU0k2SWt3dlVpSXNJbmxoZDE5eWFXZG9kQ0k2TkRBdU1IMHNJbFFpT25zaVlXeHNiM2RmYzNSaGRHVWlPblJ5ZFdVc0ltSnZaSGxmWm5KbFpYTjBZVzVrYVc1bklqb2lUMlptSWl3aVltOWtlVjk1WVhjaU9uUnlkV1VzSW1KdlpIbGZlV0YzWDI5d2RHbHZibk1pT2xzaVNtbDBkR1Z5SWl3aWZpSmRMQ0pqYUc5clpTSTZJa04xYzNSdmJTSXNJbU5vYjJ0bE1WOHhJam8yTGpBc0ltTm9iMnRsTVY4eUlqb3lNaTR3TENKamFHOXJaVEZmTXlJNk5DNHdMQ0pqYUc5clpURmZOQ0k2TVRRdU1Dd2lZMmh2YTJVeFh6VWlPamt1TUN3aVkyaHZhMlV4WHpZaU9qUXVNQ3dpWTJodmEyVmZabkp2YlNJNk9DNHdMQ0pqYUc5clpWOXRaWFJvYjJRaU9pSkRkWE4wYjIwaUxDSmphRzlyWlY5emJHbGtaWElpT2pFMkxqQXNJbU5vYjJ0bFgzTnNhV1JsY25NaU9qWXVNQ3dpWTJodmEyVmZkRzhpT2pJeUxqQXNJbVJsYkdGNUlqcDBjblZsTENKa1pXeGhlVjh4SWpveUxqQXNJbVJsYkdGNVh6SWlPakl1TUN3aVpHVnNZWGxmTXlJNk1pNHdMQ0prWld4aGVWODBJam95TGpBc0ltUmxiR0Y1WHpVaU9qSXVNQ3dpWkdWc1lYbGZOaUk2TWk0d0xDSmtaV3hoZVY5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSmtaV3hoZVY5a1pXWmhkV3gwSWpvNUxqQXNJbVJsYkdGNVgyMWxkR2h2WkNJNklrUmxabUYxYkhRaUxDSmtaV3hoZVY5eVlXNWtiMjFmYldGNElqb3hNQzR3TENKa1pXeGhlVjl5WVc1a2IyMWZiV2x1SWpvMUxqQXNJbVp5YjIxZmJHbHRhWFFpT2pZd0xqQXNJbXhsWm5SZmJHbHRhWFFpT2pZd0xqQXNJbXhwYldsMFgyMXZaR1VpT2lKVGRHRjBhV01pTENKdFlYZ2lPakF1TUN3aWJXRjRhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liV2x1SWpvd0xqQXNJbTFwYm1sdGRXMWZiR2x0YVhRaU9qWXdMakFzSW0xdlpHVWlPaUpUZEdGMGFXTWlMQ0p0YjJSbFgzSmhibVJ2YlNJNk5DNHdMQ0p0YjJSbFgzUnBZMnR6SWpvMExqQXNJbTF2WkdsbWFXVnlJam9pVTNCcGJpSXNJbTF2WkdsbWFXVnlYMk4xYzNSdmJWOXpiR2xrWlhKeklqb3pMakFzSW0xdlpHbG1hV1Z5WDIxdlpHVWlPaUpEZFhOMGIyMGlMQ0p0YjJScFptbGxjbDl2Wm1aelpYUWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2kweE5TNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelFpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODFJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5pSTZNQzR3TENKdlptWnpaWFFpT2pBdU1Dd2ljbUZ1Wkc5dFgyTm9iMnRsSWpwMGNuVmxMQ0p5WVc1a2IyMXBlbVVpT25SeWRXVXNJbkpwWjJoMFgyeHBiV2wwSWpvMk1DNHdMQ0p6WWw5emNHVmxaQ0k2TVM0d0xDSjBiMTlzYVcxcGRDSTZOakF1TUN3aWVXRjNJam9pUW1GamEzZGhjbVFpTENKNVlYZGZiR1ZtZENJNkxUSTNMakFzSW5saGQxOXRiMlJsSWpvaVRDOVNJaXdpZVdGM1gzSnBaMmgwSWpvME1DNHdmWDBzSWtaeVpXVnpkR0Z1WkdsdVp5STZleUpEVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUkdWbVlYVnNkQ0lzSW1Ob2IydGxNVjh4SWpveUxqQXNJbU5vYjJ0bE1WOHlJam95TGpBc0ltTm9iMnRsTVY4eklqb3lMakFzSW1Ob2IydGxNVjgwSWpveUxqQXNJbU5vYjJ0bE1WODFJam95TGpBc0ltTm9iMnRsTVY4Mklqb3lMakFzSW1Ob2IydGxYMlp5YjIwaU9qRTJMakFzSW1Ob2IydGxYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpWOXpiR2xrWlhJaU9qRTJMakFzSW1Ob2IydGxYM05zYVdSbGNuTWlPakl1TUN3aVkyaHZhMlZmZEc4aU9qRTJMakFzSW1SbGJHRjVJanBtWVd4elpTd2laR1ZzWVhsZk1TSTZNaTR3TENKa1pXeGhlVjh5SWpveUxqQXNJbVJsYkdGNVh6TWlPakl1TUN3aVpHVnNZWGxmTkNJNk1pNHdMQ0prWld4aGVWODFJam95TGpBc0ltUmxiR0Y1WHpZaU9qSXVNQ3dpWkdWc1lYbGZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpWkdWc1lYbGZaR1ZtWVhWc2RDSTZNaTR3TENKa1pXeGhlVjl0WlhSb2IyUWlPaUpFWldaaGRXeDBJaXdpWkdWc1lYbGZjbUZ1Wkc5dFgyMWhlQ0k2TWk0d0xDSmtaV3hoZVY5eVlXNWtiMjFmYldsdUlqb3lMakFzSW1aeWIyMWZiR2x0YVhRaU9qWXdMakFzSW14bFpuUmZiR2x0YVhRaU9qWXdMakFzSW14cGJXbDBYMjF2WkdVaU9pSlRkR0YwYVdNaUxDSnRZWGdpT2pBdU1Dd2liV0Y0YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYldsdUlqb3dMakFzSW0xcGJtbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXZaR1VpT2lKVGRHRjBhV01pTENKdGIyUmxYM0poYm1SdmJTSTZOQzR3TENKdGIyUmxYM1JwWTJ0eklqbzBMakFzSW0xdlpHbG1hV1Z5SWpvaVJHbHpZV0pzWldRaUxDSnRiMlJwWm1sbGNsOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0p0YjJScFptbGxjbDl0YjJSbElqb2lSR1ZtWVhWc2RDSXNJbTF2WkdsbWFXVnlYMjltWm5ObGRDSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpFaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh5SWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZNeUk2TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6UWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4MUlqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTmlJNk1DNHdMQ0p2Wm1aelpYUWlPakF1TUN3aWNtRnVaRzl0WDJOb2IydGxJanBtWVd4elpTd2ljbUZ1Wkc5dGFYcGxJanBtWVd4elpTd2ljbWxuYUhSZmJHbHRhWFFpT2pZd0xqQXNJbk5pWDNOd1pXVmtJam94TGpBc0luUnZYMnhwYldsMElqbzJNQzR3TENKNVlYY2lPaUpDWVdOcmQyRnlaQ0lzSW5saGQxOXNaV1owSWpvd0xqQXNJbmxoZDE5dGIyUmxJam9pVTI5c2J5SXNJbmxoZDE5eWFXZG9kQ0k2TUM0d2ZTd2lWQ0k2ZXlKaGJHeHZkMTl6ZEdGMFpTSTZkSEoxWlN3aVltOWtlVjltY21WbGMzUmhibVJwYm1jaU9pSlBabVlpTENKaWIyUjVYM2xoZHlJNmRISjFaU3dpWW05a2VWOTVZWGRmYjNCMGFXOXVjeUk2V3lKS2FYUjBaWElpTENKK0lsMHNJbU5vYjJ0bElqb2lSR1ZtWVhWc2RDSXNJbU5vYjJ0bE1WOHhJam95TGpBc0ltTm9iMnRsTVY4eUlqb3lMakFzSW1Ob2IydGxNVjh6SWpveUxqQXNJbU5vYjJ0bE1WODBJam95TGpBc0ltTm9iMnRsTVY4MUlqb3lMakFzSW1Ob2IydGxNVjgySWpveUxqQXNJbU5vYjJ0bFgyWnliMjBpT2pFMkxqQXNJbU5vYjJ0bFgyMWxkR2h2WkNJNklrUmxabUYxYkhRaUxDSmphRzlyWlY5emJHbGtaWElpT2pFMkxqQXNJbU5vYjJ0bFgzTnNhV1JsY25NaU9qSXVNQ3dpWTJodmEyVmZkRzhpT2pFMkxqQXNJbVJsYkdGNUlqcG1ZV3h6WlN3aVpHVnNZWGxmTVNJNk1pNHdMQ0prWld4aGVWOHlJam95TGpBc0ltUmxiR0Y1WHpNaU9qSXVNQ3dpWkdWc1lYbGZOQ0k2TWk0d0xDSmtaV3hoZVY4MUlqb3lMakFzSW1SbGJHRjVYellpT2pJdU1Dd2laR1ZzWVhsZlkzVnpkRzl0WDNOc2FXUmxjbk1pT2pJdU1Dd2laR1ZzWVhsZlpHVm1ZWFZzZENJNk1pNHdMQ0prWld4aGVWOXRaWFJvYjJRaU9pSkVaV1poZFd4MElpd2laR1ZzWVhsZmNtRnVaRzl0WDIxaGVDSTZNaTR3TENKa1pXeGhlVjl5WVc1a2IyMWZiV2x1SWpveUxqQXNJbVp5YjIxZmJHbHRhWFFpT2pZd0xqQXNJbXhsWm5SZmJHbHRhWFFpT2pZd0xqQXNJbXhwYldsMFgyMXZaR1VpT2lKVGRHRjBhV01pTENKdFlYZ2lPakF1TUN3aWJXRjRhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liV2x1SWpvd0xqQXNJbTFwYm1sdGRXMWZiR2x0YVhRaU9qWXdMakFzSW0xdlpHVWlPaUpUZEdGMGFXTWlMQ0p0YjJSbFgzSmhibVJ2YlNJNk5DNHdMQ0p0YjJSbFgzUnBZMnR6SWpvMExqQXNJbTF2WkdsbWFXVnlJam9pUkdsellXSnNaV1FpTENKdGIyUnBabWxsY2w5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSnRiMlJwWm1sbGNsOXRiMlJsSWpvaVJHVm1ZWFZzZENJc0ltMXZaR2xtYVdWeVgyOW1abk5sZENJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qQXVNQ3dpY21GdVpHOXRYMk5vYjJ0bElqcG1ZV3h6WlN3aWNtRnVaRzl0YVhwbElqcG1ZV3h6WlN3aWNtbG5hSFJmYkdsdGFYUWlPall3TGpBc0luTmlYM053WldWa0lqb3hMakFzSW5SdlgyeHBiV2wwSWpvMk1DNHdMQ0o1WVhjaU9pSkNZV05yZDJGeVpDSXNJbmxoZDE5c1pXWjBJam93TGpBc0lubGhkMTl0YjJSbElqb2lVMjlzYnlJc0lubGhkMTl5YVdkb2RDSTZNQzR3Zlgwc0lreGxaMmwwSUVGQklqcDdJa05VSWpwN0ltRnNiRzkzWDNOMFlYUmxJanAwY25WbExDSmliMlI1WDJaeVpXVnpkR0Z1WkdsdVp5STZJbEJsWldzZ1VtVmhiQ0lzSW1KdlpIbGZlV0YzSWpwMGNuVmxMQ0ppYjJSNVgzbGhkMTl2Y0hScGIyNXpJanBiSWtwcGRIUmxjaUlzSWxKaGJtUnZiV2w2WlNCS2FYUjBaWElpTENKQmJuUnBJRUp5ZFhSbFptOXlZMlVpTENKK0lsMHNJbU5vYjJ0bElqb2lSR1ZtWVhWc2RDSXNJbU5vYjJ0bE1WOHhJam95TGpBc0ltTm9iMnRsTVY4eUlqb3lMakFzSW1Ob2IydGxNVjh6SWpveUxqQXNJbU5vYjJ0bE1WODBJam95TGpBc0ltTm9iMnRsTVY4MUlqb3lMakFzSW1Ob2IydGxNVjgySWpveUxqQXNJbU5vYjJ0bFgyWnliMjBpT2pFMkxqQXNJbU5vYjJ0bFgyMWxkR2h2WkNJNklrUmxabUYxYkhRaUxDSmphRzlyWlY5emJHbGtaWElpT2pFMkxqQXNJbU5vYjJ0bFgzTnNhV1JsY25NaU9qSXVNQ3dpWTJodmEyVmZkRzhpT2pFMkxqQXNJbVJsYkdGNUlqcDBjblZsTENKa1pXeGhlVjh4SWpveUxqQXNJbVJsYkdGNVh6SWlPakl1TUN3aVpHVnNZWGxmTXlJNk1pNHdMQ0prWld4aGVWODBJam95TGpBc0ltUmxiR0Y1WHpVaU9qSXVNQ3dpWkdWc1lYbGZOaUk2TWk0d0xDSmtaV3hoZVY5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSmtaV3hoZVY5a1pXWmhkV3gwSWpveUxqQXNJbVJsYkdGNVgyMWxkR2h2WkNJNklsSmhibVJ2YlNJc0ltUmxiR0Y1WDNKaGJtUnZiVjl0WVhnaU9qSXVNQ3dpWkdWc1lYbGZjbUZ1Wkc5dFgyMXBiaUk2TWk0d0xDSm1jbTl0WDJ4cGJXbDBJam8yTUM0d0xDSnNaV1owWDJ4cGJXbDBJam8yTUM0d0xDSnNhVzFwZEY5dGIyUmxJam9pUm5KdmJTOVVieUlzSW0xaGVDSTZNQzR3TENKdFlYaHBiWFZ0WDJ4cGJXbDBJam8yTUM0d0xDSnRhVzRpT2pBdU1Dd2liV2x1YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYlc5a1pTSTZJbE4wWVhScFl5SXNJbTF2WkdWZmNtRnVaRzl0SWpvMExqQXNJbTF2WkdWZmRHbGphM01pT2pRdU1Dd2liVzlrYVdacFpYSWlPaUpDYjJKeWJ5SXNJbTF2WkdsbWFXVnlYMk4xYzNSdmJWOXpiR2xrWlhKeklqb3lMakFzSW0xdlpHbG1hV1Z5WDIxdlpHVWlPaUpFWldaaGRXeDBJaXdpYlc5a2FXWnBaWEpmYjJabWMyVjBJam90TlM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6RWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eUlqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTXlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelFpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODFJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5pSTZNQzR3TENKdlptWnpaWFFpT2pFNE1DNHdMQ0p5WVc1a2IyMWZZMmh2YTJVaU9tWmhiSE5sTENKeVlXNWtiMjFwZW1VaU9tWmhiSE5sTENKeWFXZG9kRjlzYVcxcGRDSTZOakF1TUN3aWMySmZjM0JsWldRaU9qRXVNQ3dpZEc5ZmJHbHRhWFFpT2pZd0xqQXNJbmxoZHlJNklrSmhZMnQzWVhKa0lpd2llV0YzWDJ4bFpuUWlPakF1TUN3aWVXRjNYMjF2WkdVaU9pSlRiMnh2SWl3aWVXRjNYM0pwWjJoMElqb3dMakI5TENKVUlqcDdJbUZzYkc5M1gzTjBZWFJsSWpwMGNuVmxMQ0ppYjJSNVgyWnlaV1Z6ZEdGdVpHbHVaeUk2SWxCbFpXc2dVbVZoYkNJc0ltSnZaSGxmZVdGM0lqcDBjblZsTENKaWIyUjVYM2xoZDE5dmNIUnBiMjV6SWpwYklrcHBkSFJsY2lJc0lsSmhibVJ2YldsNlpTQkthWFIwWlhJaUxDSkJiblJwSUVKeWRYUmxabTl5WTJVaUxDSitJbDBzSW1Ob2IydGxJam9pUkdWbVlYVnNkQ0lzSW1Ob2IydGxNVjh4SWpveUxqQXNJbU5vYjJ0bE1WOHlJam95TGpBc0ltTm9iMnRsTVY4eklqb3lMakFzSW1Ob2IydGxNVjgwSWpveUxqQXNJbU5vYjJ0bE1WODFJam95TGpBc0ltTm9iMnRsTVY4Mklqb3lMakFzSW1Ob2IydGxYMlp5YjIwaU9qRTJMakFzSW1Ob2IydGxYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpWOXpiR2xrWlhJaU9qRTJMakFzSW1Ob2IydGxYM05zYVdSbGNuTWlPakl1TUN3aVkyaHZhMlZmZEc4aU9qRTJMakFzSW1SbGJHRjVJanAwY25WbExDSmtaV3hoZVY4eElqb3lMakFzSW1SbGJHRjVYeklpT2pJdU1Dd2laR1ZzWVhsZk15STZNaTR3TENKa1pXeGhlVjgwSWpveUxqQXNJbVJsYkdGNVh6VWlPakl1TUN3aVpHVnNZWGxmTmlJNk1pNHdMQ0prWld4aGVWOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0prWld4aGVWOWtaV1poZFd4MElqb3lMakFzSW1SbGJHRjVYMjFsZEdodlpDSTZJbEpoYm1SdmJTSXNJbVJsYkdGNVgzSmhibVJ2YlY5dFlYZ2lPakl1TUN3aVpHVnNZWGxmY21GdVpHOXRYMjFwYmlJNk1pNHdMQ0ptY205dFgyeHBiV2wwSWpvMk1DNHdMQ0pzWldaMFgyeHBiV2wwSWpvMk1DNHdMQ0pzYVcxcGRGOXRiMlJsSWpvaVJuSnZiUzlVYnlJc0ltMWhlQ0k2TUM0d0xDSnRZWGhwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YVc0aU9qQXVNQ3dpYldsdWFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXOWtaU0k2SWxOMFlYUnBZeUlzSW0xdlpHVmZjbUZ1Wkc5dElqbzBMakFzSW0xdlpHVmZkR2xqYTNNaU9qUXVNQ3dpYlc5a2FXWnBaWElpT2lKQ2IySnlieUlzSW0xdlpHbG1hV1Z5WDJOMWMzUnZiVjl6Ykdsa1pYSnpJam95TGpBc0ltMXZaR2xtYVdWeVgyMXZaR1VpT2lKRVpXWmhkV3gwSWl3aWJXOWthV1pwWlhKZmIyWm1jMlYwSWpvdE5TNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qRTRNQzR3TENKeVlXNWtiMjFmWTJodmEyVWlPbVpoYkhObExDSnlZVzVrYjIxcGVtVWlPbVpoYkhObExDSnlhV2RvZEY5c2FXMXBkQ0k2TmpBdU1Dd2ljMkpmYzNCbFpXUWlPakV1TUN3aWRHOWZiR2x0YVhRaU9qWXdMakFzSW5saGR5STZJa0poWTJ0M1lYSmtJaXdpZVdGM1gyeGxablFpT2pBdU1Dd2llV0YzWDIxdlpHVWlPaUpUYjJ4dklpd2llV0YzWDNKcFoyaDBJam93TGpCOWZTd2lVblZ1Ym1sdVp5STZleUpEVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUTNWemRHOXRJaXdpWTJodmEyVXhYekVpT2pndU1Dd2lZMmh2YTJVeFh6SWlPakl5TGpBc0ltTm9iMnRsTVY4eklqb3hNQzR3TENKamFHOXJaVEZmTkNJNk1pNHdMQ0pqYUc5clpURmZOU0k2TlM0d0xDSmphRzlyWlRGZk5pSTZNVFV1TUN3aVkyaHZhMlZmWm5KdmJTSTZNVFl1TUN3aVkyaHZhMlZmYldWMGFHOWtJam9pUTNWemRHOXRJaXdpWTJodmEyVmZjMnhwWkdWeUlqb3hOaTR3TENKamFHOXJaVjl6Ykdsa1pYSnpJam8yTGpBc0ltTm9iMnRsWDNSdklqb3hOaTR3TENKa1pXeGhlU0k2ZEhKMVpTd2laR1ZzWVhsZk1TSTZNaTR3TENKa1pXeGhlVjh5SWpveUxqQXNJbVJsYkdGNVh6TWlPakl1TUN3aVpHVnNZWGxmTkNJNk1pNHdMQ0prWld4aGVWODFJam95TGpBc0ltUmxiR0Y1WHpZaU9qSXVNQ3dpWkdWc1lYbGZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpWkdWc1lYbGZaR1ZtWVhWc2RDSTZPQzR3TENKa1pXeGhlVjl0WlhSb2IyUWlPaUpFWldaaGRXeDBJaXdpWkdWc1lYbGZjbUZ1Wkc5dFgyMWhlQ0k2TWk0d0xDSmtaV3hoZVY5eVlXNWtiMjFmYldsdUlqb3lMakFzSW1aeWIyMWZiR2x0YVhRaU9qWXdMakFzSW14bFpuUmZiR2x0YVhRaU9qWXdMakFzSW14cGJXbDBYMjF2WkdVaU9pSlRkR0YwYVdNaUxDSnRZWGdpT2pBdU1Dd2liV0Y0YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYldsdUlqb3dMakFzSW0xcGJtbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXZaR1VpT2lKVGRHRjBhV01pTENKdGIyUmxYM0poYm1SdmJTSTZOQzR3TENKdGIyUmxYM1JwWTJ0eklqbzBMakFzSW0xdlpHbG1hV1Z5SWpvaVFtOWljbThpTENKdGIyUnBabWxsY2w5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSnRiMlJwWm1sbGNsOXRiMlJsSWpvaVJHVm1ZWFZzZENJc0ltMXZaR2xtYVdWeVgyOW1abk5sZENJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qQXVNQ3dpY21GdVpHOXRYMk5vYjJ0bElqcDBjblZsTENKeVlXNWtiMjFwZW1VaU9tWmhiSE5sTENKeWFXZG9kRjlzYVcxcGRDSTZOakF1TUN3aWMySmZjM0JsWldRaU9qRXVNQ3dpZEc5ZmJHbHRhWFFpT2pZd0xqQXNJbmxoZHlJNklrSmhZMnQzWVhKa0lpd2llV0YzWDJ4bFpuUWlPaTB5Tmk0d0xDSjVZWGRmYlc5a1pTSTZJa3d2VWlJc0lubGhkMTl5YVdkb2RDSTZOREV1TUgwc0lsUWlPbnNpWVd4c2IzZGZjM1JoZEdVaU9uUnlkV1VzSW1KdlpIbGZabkpsWlhOMFlXNWthVzVuSWpvaVQyWm1JaXdpWW05a2VWOTVZWGNpT25SeWRXVXNJbUp2WkhsZmVXRjNYMjl3ZEdsdmJuTWlPbHNpU21sMGRHVnlJaXdpZmlKZExDSmphRzlyWlNJNklrTjFjM1J2YlNJc0ltTm9iMnRsTVY4eElqbzRMakFzSW1Ob2IydGxNVjh5SWpveU1pNHdMQ0pqYUc5clpURmZNeUk2TVRBdU1Dd2lZMmh2YTJVeFh6UWlPakl1TUN3aVkyaHZhMlV4WHpVaU9qVXVNQ3dpWTJodmEyVXhYellpT2pFMUxqQXNJbU5vYjJ0bFgyWnliMjBpT2pFMkxqQXNJbU5vYjJ0bFgyMWxkR2h2WkNJNklrTjFjM1J2YlNJc0ltTm9iMnRsWDNOc2FXUmxjaUk2TVRZdU1Dd2lZMmh2YTJWZmMyeHBaR1Z5Y3lJNk5pNHdMQ0pqYUc5clpWOTBieUk2TVRZdU1Dd2laR1ZzWVhraU9uUnlkV1VzSW1SbGJHRjVYekVpT2pJdU1Dd2laR1ZzWVhsZk1pSTZNaTR3TENKa1pXeGhlVjh6SWpveUxqQXNJbVJsYkdGNVh6UWlPakl1TUN3aVpHVnNZWGxmTlNJNk1pNHdMQ0prWld4aGVWODJJam95TGpBc0ltUmxiR0Y1WDJOMWMzUnZiVjl6Ykdsa1pYSnpJam95TGpBc0ltUmxiR0Y1WDJSbFptRjFiSFFpT2pndU1Dd2laR1ZzWVhsZmJXVjBhRzlrSWpvaVJHVm1ZWFZzZENJc0ltUmxiR0Y1WDNKaGJtUnZiVjl0WVhnaU9qSXVNQ3dpWkdWc1lYbGZjbUZ1Wkc5dFgyMXBiaUk2TWk0d0xDSm1jbTl0WDJ4cGJXbDBJam8yTUM0d0xDSnNaV1owWDJ4cGJXbDBJam8yTUM0d0xDSnNhVzFwZEY5dGIyUmxJam9pVTNSaGRHbGpJaXdpYldGNElqb3dMakFzSW0xaGVHbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXBiaUk2TUM0d0xDSnRhVzVwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YjJSbElqb2lVM1JoZEdsaklpd2liVzlrWlY5eVlXNWtiMjBpT2pRdU1Dd2liVzlrWlY5MGFXTnJjeUk2TkM0d0xDSnRiMlJwWm1sbGNpSTZJa0p2WW5Kdklpd2liVzlrYVdacFpYSmZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpYlc5a2FXWnBaWEpmYlc5a1pTSTZJa1JsWm1GMWJIUWlMQ0p0YjJScFptbGxjbDl2Wm1aelpYUWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpZaU9qQXVNQ3dpYjJabWMyVjBJam93TGpBc0luSmhibVJ2YlY5amFHOXJaU0k2ZEhKMVpTd2ljbUZ1Wkc5dGFYcGxJanBtWVd4elpTd2ljbWxuYUhSZmJHbHRhWFFpT2pZd0xqQXNJbk5pWDNOd1pXVmtJam94TGpBc0luUnZYMnhwYldsMElqbzJNQzR3TENKNVlYY2lPaUpDWVdOcmQyRnlaQ0lzSW5saGQxOXNaV1owSWpvdE1qWXVNQ3dpZVdGM1gyMXZaR1VpT2lKTUwxSWlMQ0o1WVhkZmNtbG5hSFFpT2pReExqQjlmU3dpVTJ4dmQybHVaeUk2ZXlKRFZDSTZleUpoYkd4dmQxOXpkR0YwWlNJNmRISjFaU3dpWW05a2VWOW1jbVZsYzNSaGJtUnBibWNpT2lKUFptWWlMQ0ppYjJSNVgzbGhkeUk2ZEhKMVpTd2lZbTlrZVY5NVlYZGZiM0IwYVc5dWN5STZXeUpLYVhSMFpYSWlMQ0orSWwwc0ltTm9iMnRsSWpvaVJHVm1ZWFZzZENJc0ltTm9iMnRsTVY4eElqb3lMakFzSW1Ob2IydGxNVjh5SWpveUxqQXNJbU5vYjJ0bE1WOHpJam95TGpBc0ltTm9iMnRsTVY4MElqb3lMakFzSW1Ob2IydGxNVjgxSWpveUxqQXNJbU5vYjJ0bE1WODJJam95TGpBc0ltTm9iMnRsWDJaeWIyMGlPakUyTGpBc0ltTm9iMnRsWDIxbGRHaHZaQ0k2SWtSbFptRjFiSFFpTENKamFHOXJaVjl6Ykdsa1pYSWlPakUyTGpBc0ltTm9iMnRsWDNOc2FXUmxjbk1pT2pJdU1Dd2lZMmh2YTJWZmRHOGlPakUyTGpBc0ltUmxiR0Y1SWpwMGNuVmxMQ0prWld4aGVWOHhJam96TGpBc0ltUmxiR0Y1WHpJaU9qY3VNQ3dpWkdWc1lYbGZNeUk2TWk0d0xDSmtaV3hoZVY4MElqb3hNUzR3TENKa1pXeGhlVjgxSWpvMkxqQXNJbVJsYkdGNVh6WWlPamd1TUN3aVpHVnNZWGxmWTNWemRHOXRYM05zYVdSbGNuTWlPall1TUN3aVpHVnNZWGxmWkdWbVlYVnNkQ0k2TWk0d0xDSmtaV3hoZVY5dFpYUm9iMlFpT2lKRGRYTjBiMjBpTENKa1pXeGhlVjl5WVc1a2IyMWZiV0Y0SWpveUxqQXNJbVJsYkdGNVgzSmhibVJ2YlY5dGFXNGlPakl1TUN3aVpuSnZiVjlzYVcxcGRDSTZOakF1TUN3aWJHVm1kRjlzYVcxcGRDSTZOakF1TUN3aWJHbHRhWFJmYlc5a1pTSTZJbE4wWVhScFl5SXNJbTFoZUNJNk1DNHdMQ0p0WVhocGJYVnRYMnhwYldsMElqbzJNQzR3TENKdGFXNGlPakF1TUN3aWJXbHVhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liVzlrWlNJNklsTjBZWFJwWXlJc0ltMXZaR1ZmY21GdVpHOXRJam8wTGpBc0ltMXZaR1ZmZEdsamEzTWlPalF1TUN3aWJXOWthV1pwWlhJaU9pSkNiMkp5YnlJc0ltMXZaR2xtYVdWeVgyTjFjM1J2YlY5emJHbGtaWEp6SWpvMUxqQXNJbTF2WkdsbWFXVnlYMjF2WkdVaU9pSkRkWE4wYjIwaUxDSnRiMlJwWm1sbGNsOXZabVp6WlhRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh4SWpvdE1USXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh5SWpveE55NHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2kwek9TNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelFpT2kwMU1TNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelVpT2pRd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qQXVNQ3dpY21GdVpHOXRYMk5vYjJ0bElqcG1ZV3h6WlN3aWNtRnVaRzl0YVhwbElqcDBjblZsTENKeWFXZG9kRjlzYVcxcGRDSTZOakF1TUN3aWMySmZjM0JsWldRaU9qRXVNQ3dpZEc5ZmJHbHRhWFFpT2pZd0xqQXNJbmxoZHlJNklrSmhZMnQzWVhKa0lpd2llV0YzWDJ4bFpuUWlPaTB5Tnk0d0xDSjVZWGRmYlc5a1pTSTZJa3d2VWlJc0lubGhkMTl5YVdkb2RDSTZNemd1TUgwc0lsUWlPbnNpWVd4c2IzZGZjM1JoZEdVaU9uUnlkV1VzSW1KdlpIbGZabkpsWlhOMFlXNWthVzVuSWpvaVQyWm1JaXdpWW05a2VWOTVZWGNpT25SeWRXVXNJbUp2WkhsZmVXRjNYMjl3ZEdsdmJuTWlPbHNpU21sMGRHVnlJaXdpZmlKZExDSmphRzlyWlNJNklrUmxabUYxYkhRaUxDSmphRzlyWlRGZk1TSTZNaTR3TENKamFHOXJaVEZmTWlJNk1pNHdMQ0pqYUc5clpURmZNeUk2TWk0d0xDSmphRzlyWlRGZk5DSTZNaTR3TENKamFHOXJaVEZmTlNJNk1pNHdMQ0pqYUc5clpURmZOaUk2TWk0d0xDSmphRzlyWlY5bWNtOXRJam94Tmk0d0xDSmphRzlyWlY5dFpYUm9iMlFpT2lKRVpXWmhkV3gwSWl3aVkyaHZhMlZmYzJ4cFpHVnlJam94Tmk0d0xDSmphRzlyWlY5emJHbGtaWEp6SWpveUxqQXNJbU5vYjJ0bFgzUnZJam94Tmk0d0xDSmtaV3hoZVNJNmRISjFaU3dpWkdWc1lYbGZNU0k2TXk0d0xDSmtaV3hoZVY4eUlqbzNMakFzSW1SbGJHRjVYek1pT2pJdU1Dd2laR1ZzWVhsZk5DSTZNVEV1TUN3aVpHVnNZWGxmTlNJNk5pNHdMQ0prWld4aGVWODJJam80TGpBc0ltUmxiR0Y1WDJOMWMzUnZiVjl6Ykdsa1pYSnpJam8yTGpBc0ltUmxiR0Y1WDJSbFptRjFiSFFpT2pJdU1Dd2laR1ZzWVhsZmJXVjBhRzlrSWpvaVEzVnpkRzl0SWl3aVpHVnNZWGxmY21GdVpHOXRYMjFoZUNJNk1pNHdMQ0prWld4aGVWOXlZVzVrYjIxZmJXbHVJam95TGpBc0ltWnliMjFmYkdsdGFYUWlPall3TGpBc0lteGxablJmYkdsdGFYUWlPall3TGpBc0lteHBiV2wwWDIxdlpHVWlPaUpUZEdGMGFXTWlMQ0p0WVhnaU9qQXVNQ3dpYldGNGFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXbHVJam93TGpBc0ltMXBibWx0ZFcxZmJHbHRhWFFpT2pZd0xqQXNJbTF2WkdVaU9pSlRkR0YwYVdNaUxDSnRiMlJsWDNKaGJtUnZiU0k2TkM0d0xDSnRiMlJsWDNScFkydHpJam8wTGpBc0ltMXZaR2xtYVdWeUlqb2lRbTlpY204aUxDSnRiMlJwWm1sbGNsOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk5TNHdMQ0p0YjJScFptbGxjbDl0YjJSbElqb2lRM1Z6ZEc5dElpd2liVzlrYVdacFpYSmZiMlptYzJWMElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTVNJNkxURXlMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1UY3VNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh6SWpvdE16a3VNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgwSWpvdE5URXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvME1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYellpT2pBdU1Dd2liMlptYzJWMElqb3dMakFzSW5KaGJtUnZiVjlqYUc5clpTSTZabUZzYzJVc0luSmhibVJ2YldsNlpTSTZkSEoxWlN3aWNtbG5hSFJmYkdsdGFYUWlPall3TGpBc0luTmlYM053WldWa0lqb3hMakFzSW5SdlgyeHBiV2wwSWpvMk1DNHdMQ0o1WVhjaU9pSkNZV05yZDJGeVpDSXNJbmxoZDE5c1pXWjBJam90TWpjdU1Dd2llV0YzWDIxdlpHVWlPaUpNTDFJaUxDSjVZWGRmY21sbmFIUWlPak00TGpCOWZTd2lVMjVsWVd0cGJtY2lPbnNpUTFRaU9uc2lZV3hzYjNkZmMzUmhkR1VpT25SeWRXVXNJbUp2WkhsZlpuSmxaWE4wWVc1a2FXNW5Jam9pVDJabUlpd2lZbTlrZVY5NVlYY2lPblJ5ZFdVc0ltSnZaSGxmZVdGM1gyOXdkR2x2Ym5NaU9sc2lTbWwwZEdWeUlpd2lmaUpkTENKamFHOXJaU0k2SWtOMWMzUnZiU0lzSW1Ob2IydGxNVjh4SWpvNExqQXNJbU5vYjJ0bE1WOHlJam94T0M0d0xDSmphRzlyWlRGZk15STZOeTR3TENKamFHOXJaVEZmTkNJNk1UY3VNQ3dpWTJodmEyVXhYelVpT2pndU1Dd2lZMmh2YTJVeFh6WWlPalV1TUN3aVkyaHZhMlZmWm5KdmJTSTZNVFl1TUN3aVkyaHZhMlZmYldWMGFHOWtJam9pUTNWemRHOXRJaXdpWTJodmEyVmZjMnhwWkdWeUlqb3hOaTR3TENKamFHOXJaVjl6Ykdsa1pYSnpJam8yTGpBc0ltTm9iMnRsWDNSdklqb3hOaTR3TENKa1pXeGhlU0k2ZEhKMVpTd2laR1ZzWVhsZk1TSTZNaTR3TENKa1pXeGhlVjh5SWpveUxqQXNJbVJsYkdGNVh6TWlPakl1TUN3aVpHVnNZWGxmTkNJNk1pNHdMQ0prWld4aGVWODFJam95TGpBc0ltUmxiR0Y1WHpZaU9qSXVNQ3dpWkdWc1lYbGZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpWkdWc1lYbGZaR1ZtWVhWc2RDSTZOeTR3TENKa1pXeGhlVjl0WlhSb2IyUWlPaUpEZFhOMGIyMGlMQ0prWld4aGVWOXlZVzVrYjIxZmJXRjRJam8yTGpBc0ltUmxiR0Y1WDNKaGJtUnZiVjl0YVc0aU9qVXVNQ3dpWm5KdmJWOXNhVzFwZENJNk5qQXVNQ3dpYkdWbWRGOXNhVzFwZENJNk5qQXVNQ3dpYkdsdGFYUmZiVzlrWlNJNklrWnliMjB2Vkc4aUxDSnRZWGdpT2pBdU1Dd2liV0Y0YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYldsdUlqb3RNVEF1TUN3aWJXbHVhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liVzlrWlNJNklsUnBZMnR6SWl3aWJXOWtaVjl5WVc1a2IyMGlPalF1TUN3aWJXOWtaVjkwYVdOcmN5STZNVEl1TUN3aWJXOWthV1pwWlhJaU9pSlRjR2x1SWl3aWJXOWthV1pwWlhKZlkzVnpkRzl0WDNOc2FXUmxjbk1pT2pZdU1Dd2liVzlrYVdacFpYSmZiVzlrWlNJNklrTjFjM1J2YlNJc0ltMXZaR2xtYVdWeVgyOW1abk5sZENJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TFRFMkxqQXNJbTltWm5ObGRDSTZNQzR3TENKeVlXNWtiMjFmWTJodmEyVWlPblJ5ZFdVc0luSmhibVJ2YldsNlpTSTZkSEoxWlN3aWNtbG5hSFJmYkdsdGFYUWlPall3TGpBc0luTmlYM053WldWa0lqb3hNUzR3TENKMGIxOXNhVzFwZENJNk5EZ3VNQ3dpZVdGM0lqb2lRbUZqYTNkaGNtUWlMQ0o1WVhkZmJHVm1kQ0k2TFRJeUxqQXNJbmxoZDE5dGIyUmxJam9pVEM5U0lpd2llV0YzWDNKcFoyaDBJam8wTkM0d2ZTd2lWQ0k2ZXlKaGJHeHZkMTl6ZEdGMFpTSTZkSEoxWlN3aVltOWtlVjltY21WbGMzUmhibVJwYm1jaU9pSlBabVlpTENKaWIyUjVYM2xoZHlJNmRISjFaU3dpWW05a2VWOTVZWGRmYjNCMGFXOXVjeUk2V3lKS2FYUjBaWElpTENKK0lsMHNJbU5vYjJ0bElqb2lRM1Z6ZEc5dElpd2lZMmh2YTJVeFh6RWlPamd1TUN3aVkyaHZhMlV4WHpJaU9qRTRMakFzSW1Ob2IydGxNVjh6SWpvM0xqQXNJbU5vYjJ0bE1WODBJam94Tnk0d0xDSmphRzlyWlRGZk5TSTZPQzR3TENKamFHOXJaVEZmTmlJNk5TNHdMQ0pqYUc5clpWOW1jbTl0SWpveE5pNHdMQ0pqYUc5clpWOXRaWFJvYjJRaU9pSkRkWE4wYjIwaUxDSmphRzlyWlY5emJHbGtaWElpT2pFMkxqQXNJbU5vYjJ0bFgzTnNhV1JsY25NaU9qWXVNQ3dpWTJodmEyVmZkRzhpT2pFMkxqQXNJbVJsYkdGNUlqcDBjblZsTENKa1pXeGhlVjh4SWpveUxqQXNJbVJsYkdGNVh6SWlPakl1TUN3aVpHVnNZWGxmTXlJNk1pNHdMQ0prWld4aGVWODBJam95TGpBc0ltUmxiR0Y1WHpVaU9qSXVNQ3dpWkdWc1lYbGZOaUk2TWk0d0xDSmtaV3hoZVY5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSmtaV3hoZVY5a1pXWmhkV3gwSWpvM0xqQXNJbVJsYkdGNVgyMWxkR2h2WkNJNklrTjFjM1J2YlNJc0ltUmxiR0Y1WDNKaGJtUnZiVjl0WVhnaU9qWXVNQ3dpWkdWc1lYbGZjbUZ1Wkc5dFgyMXBiaUk2TlM0d0xDSm1jbTl0WDJ4cGJXbDBJam8yTUM0d0xDSnNaV1owWDJ4cGJXbDBJam8yTUM0d0xDSnNhVzFwZEY5dGIyUmxJam9pUm5KdmJTOVVieUlzSW0xaGVDSTZNQzR3TENKdFlYaHBiWFZ0WDJ4cGJXbDBJam8yTUM0d0xDSnRhVzRpT2kweE1DNHdMQ0p0YVc1cGJYVnRYMnhwYldsMElqbzJNQzR3TENKdGIyUmxJam9pVkdsamEzTWlMQ0p0YjJSbFgzSmhibVJ2YlNJNk5DNHdMQ0p0YjJSbFgzUnBZMnR6SWpveE1pNHdMQ0p0YjJScFptbGxjaUk2SWxOd2FXNGlMQ0p0YjJScFptbGxjbDlqZFhOMGIyMWZjMnhwWkdWeWN5STZOaTR3TENKdGIyUnBabWxsY2w5dGIyUmxJam9pUTNWemRHOXRJaXdpYlc5a2FXWnBaWEpmYjJabWMyVjBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk1TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpJaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh6SWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOQ0k2TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6VWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4Mklqb3RNVFl1TUN3aWIyWm1jMlYwSWpvd0xqQXNJbkpoYm1SdmJWOWphRzlyWlNJNmRISjFaU3dpY21GdVpHOXRhWHBsSWpwMGNuVmxMQ0p5YVdkb2RGOXNhVzFwZENJNk5qQXVNQ3dpYzJKZmMzQmxaV1FpT2pFeExqQXNJblJ2WDJ4cGJXbDBJam8wT0M0d0xDSjVZWGNpT2lKQ1lXTnJkMkZ5WkNJc0lubGhkMTlzWldaMElqb3RNakl1TUN3aWVXRjNYMjF2WkdVaU9pSk1MMUlpTENKNVlYZGZjbWxuYUhRaU9qUTBMakI5ZlN3aVUzUmhibVJwYm1jaU9uc2lRMVFpT25zaVlXeHNiM2RmYzNSaGRHVWlPblJ5ZFdVc0ltSnZaSGxmWm5KbFpYTjBZVzVrYVc1bklqb2lUMlptSWl3aVltOWtlVjk1WVhjaU9uUnlkV1VzSW1KdlpIbGZlV0YzWDI5d2RHbHZibk1pT2xzaVNtbDBkR1Z5SWl3aWZpSmRMQ0pqYUc5clpTSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpURmZNU0k2TWk0d0xDSmphRzlyWlRGZk1pSTZNaTR3TENKamFHOXJaVEZmTXlJNk1pNHdMQ0pqYUc5clpURmZOQ0k2TWk0d0xDSmphRzlyWlRGZk5TSTZNaTR3TENKamFHOXJaVEZmTmlJNk1pNHdMQ0pqYUc5clpWOW1jbTl0SWpveE5pNHdMQ0pqYUc5clpWOXRaWFJvYjJRaU9pSkVaV1poZFd4MElpd2lZMmh2YTJWZmMyeHBaR1Z5SWpveE5pNHdMQ0pqYUc5clpWOXpiR2xrWlhKeklqb3lMakFzSW1Ob2IydGxYM1J2SWpveE5pNHdMQ0prWld4aGVTSTZabUZzYzJVc0ltUmxiR0Y1WHpFaU9qVXVNQ3dpWkdWc1lYbGZNaUk2TWk0d0xDSmtaV3hoZVY4eklqb3hNeTR3TENKa1pXeGhlVjgwSWpvNExqQXNJbVJsYkdGNVh6VWlPak11TUN3aVpHVnNZWGxmTmlJNk1pNHdMQ0prWld4aGVWOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk5TNHdMQ0prWld4aGVWOWtaV1poZFd4MElqb3lMakFzSW1SbGJHRjVYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0prWld4aGVWOXlZVzVrYjIxZmJXRjRJam95TGpBc0ltUmxiR0Y1WDNKaGJtUnZiVjl0YVc0aU9qSXVNQ3dpWm5KdmJWOXNhVzFwZENJNk5qQXVNQ3dpYkdWbWRGOXNhVzFwZENJNk5qQXVNQ3dpYkdsdGFYUmZiVzlrWlNJNklsTjBZWFJwWXlJc0ltMWhlQ0k2TUM0d0xDSnRZWGhwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YVc0aU9qQXVNQ3dpYldsdWFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXOWtaU0k2SWxOMFlYUnBZeUlzSW0xdlpHVmZjbUZ1Wkc5dElqbzBMakFzSW0xdlpHVmZkR2xqYTNNaU9qUXVNQ3dpYlc5a2FXWnBaWElpT2lJMUxWZGhlU0lzSW0xdlpHbG1hV1Z5WDJOMWMzUnZiVjl6Ykdsa1pYSnpJam95TGpBc0ltMXZaR2xtYVdWeVgyMXZaR1VpT2lKRVpXWmhkV3gwSWl3aWJXOWthV1pwWlhKZmIyWm1jMlYwSWpvMU1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qQXVNQ3dpY21GdVpHOXRYMk5vYjJ0bElqcG1ZV3h6WlN3aWNtRnVaRzl0YVhwbElqcG1ZV3h6WlN3aWNtbG5hSFJmYkdsdGFYUWlPall3TGpBc0luTmlYM053WldWa0lqb3hMakFzSW5SdlgyeHBiV2wwSWpvMk1DNHdMQ0o1WVhjaU9pSkNZV05yZDJGeVpDSXNJbmxoZDE5c1pXWjBJam90TWpJdU1Dd2llV0YzWDIxdlpHVWlPaUpNTDFJaUxDSjVZWGRmY21sbmFIUWlPalEyTGpCOUxDSlVJanA3SW1Gc2JHOTNYM04wWVhSbElqcDBjblZsTENKaWIyUjVYMlp5WldWemRHRnVaR2x1WnlJNklrOW1aaUlzSW1KdlpIbGZlV0YzSWpwMGNuVmxMQ0ppYjJSNVgzbGhkMTl2Y0hScGIyNXpJanBiSWtwcGRIUmxjaUlzSW40aVhTd2lZMmh2YTJVaU9pSkVaV1poZFd4MElpd2lZMmh2YTJVeFh6RWlPakl1TUN3aVkyaHZhMlV4WHpJaU9qSXVNQ3dpWTJodmEyVXhYek1pT2pJdU1Dd2lZMmh2YTJVeFh6UWlPakl1TUN3aVkyaHZhMlV4WHpVaU9qSXVNQ3dpWTJodmEyVXhYellpT2pJdU1Dd2lZMmh2YTJWZlpuSnZiU0k2TVRZdU1Dd2lZMmh2YTJWZmJXVjBhRzlrSWpvaVJHVm1ZWFZzZENJc0ltTm9iMnRsWDNOc2FXUmxjaUk2TVRZdU1Dd2lZMmh2YTJWZmMyeHBaR1Z5Y3lJNk1pNHdMQ0pqYUc5clpWOTBieUk2TVRZdU1Dd2laR1ZzWVhraU9tWmhiSE5sTENKa1pXeGhlVjh4SWpvMUxqQXNJbVJsYkdGNVh6SWlPakl1TUN3aVpHVnNZWGxmTXlJNk1UTXVNQ3dpWkdWc1lYbGZOQ0k2T0M0d0xDSmtaV3hoZVY4MUlqb3pMakFzSW1SbGJHRjVYellpT2pJdU1Dd2laR1ZzWVhsZlkzVnpkRzl0WDNOc2FXUmxjbk1pT2pVdU1Dd2laR1ZzWVhsZlpHVm1ZWFZzZENJNk1pNHdMQ0prWld4aGVWOXRaWFJvYjJRaU9pSkVaV1poZFd4MElpd2laR1ZzWVhsZmNtRnVaRzl0WDIxaGVDSTZNaTR3TENKa1pXeGhlVjl5WVc1a2IyMWZiV2x1SWpveUxqQXNJbVp5YjIxZmJHbHRhWFFpT2pZd0xqQXNJbXhsWm5SZmJHbHRhWFFpT2pZd0xqQXNJbXhwYldsMFgyMXZaR1VpT2lKVGRHRjBhV01pTENKdFlYZ2lPakF1TUN3aWJXRjRhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liV2x1SWpvd0xqQXNJbTFwYm1sdGRXMWZiR2x0YVhRaU9qWXdMakFzSW0xdlpHVWlPaUpUZEdGMGFXTWlMQ0p0YjJSbFgzSmhibVJ2YlNJNk5DNHdMQ0p0YjJSbFgzUnBZMnR6SWpvMExqQXNJbTF2WkdsbWFXVnlJam9pTlMxWFlYa2lMQ0p0YjJScFptbGxjbDlqZFhOMGIyMWZjMnhwWkdWeWN5STZNaTR3TENKdGIyUnBabWxsY2w5dGIyUmxJam9pUkdWbVlYVnNkQ0lzSW0xdlpHbG1hV1Z5WDI5bVpuTmxkQ0k2TlRBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHhJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk1pSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpNaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgwSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOU0k2TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6WWlPakF1TUN3aWIyWm1jMlYwSWpvd0xqQXNJbkpoYm1SdmJWOWphRzlyWlNJNlptRnNjMlVzSW5KaGJtUnZiV2w2WlNJNlptRnNjMlVzSW5KcFoyaDBYMnhwYldsMElqbzJNQzR3TENKellsOXpjR1ZsWkNJNk1TNHdMQ0owYjE5c2FXMXBkQ0k2TmpBdU1Dd2llV0YzSWpvaVFtRmphM2RoY21RaUxDSjVZWGRmYkdWbWRDSTZMVEl5TGpBc0lubGhkMTl0YjJSbElqb2lUQzlTSWl3aWVXRjNYM0pwWjJoMElqbzBOaTR3ZlgxOUxDSm1jbVZsYzNSaGJtUnBibWNpT25zaVltOWtlVjltY3lJNmRISjFaU3dpWkdsellXSnNaWEp6SWpwYkluNGlYU3dpY0hKbFptVnlYMjFoYm5WaGJDSTZkSEoxWlN3aWMzZHBkR05vSWpwbVlXeHpaU3dpZVdGM1gyMXZaQ0k2ZEhKMVpYMTlMQ0p0WVdsdUlqcDdJbUZrWkdsMGFXOXVZV3dpT25zaVltRmphM04wWVdJaU9uc2ljM2RwZEdOb0lqcDBjblZsZlN3aWJHVm5hWFJmWVdFaU9uc2laVzVoWW14bFpDSTZabUZzYzJVc0ltMXZaR1VpT2lKTWIyTmhiQ0JXYVdWM0luMHNJbTFoYm5WaGJGOTVZWGNpT25zaWFXNTJaWEowWlhJaU9uUnlkV1VzSW5ObGJHVmpkQ0k2SWtScGMyRmliR1ZrSWl3aWMzUmhkR2xqSWpwbVlXeHpaWDBzSW5OaFptVmZhR1ZoWkNJNmV5Sm9aV2xuYUhRaU9qVXdMakFzSW5OMFlYUmxjeUk2V3lKYVpYVnpJaXdpUzI1cFptVWlMQ0orSWwwc0luTjNhWFJqYUNJNmRISjFaWDBzSW5kaGNtMTFjRjloWVNJNmV5SnNaV1owWDNsaGR5STZMVE0xTGpBc0luQnBkR05vSWpvaVJHbHpZV0pzWldRaUxDSnlZVzVuWlNJNk16WXdMakFzSW5KcFoyaDBYM2xoZHlJNk5qY3VNQ3dpYzJWc1pXTjBJam9pUkdsellXSnNaV1FpTENKemNHVmxaQ0k2TVRJNExqQXNJbmxoZHlJNklsTndhVzRpZlgwc0ltTnZibVpwWjNWeVpTSTZleUp6ZEdGMFpTSTZPQzR3TENKMFpXRnRJam94TGpCOWZYMHNJbWx1Wm04aU9uc2libTkwYVdaNUlqcDdJbk53WVcwaU9tWmhiSE5sTENKemRIbHNaU0k2SWtOaGRDSjlMQ0p3Y21WelpYUnpJanA3SW14cGMzUWlPalV1TUN3aWJtRnRaU0k2SW1KdlluSnZiMnhrSW4wc0luTm9ZWEpsWkY5bVpXRjBkWEpsY3lJNmV5SnpkMmwwWTJnaU9tWmhiSE5sZlN3aWMybGtaV0poY2lJNmV5SmpiMnh2Y2lJNld5SlBkWFIwWlhJaUxDSWpNREF3TURBd01EQWlMQ0orSWwwc0luTndaV1ZrSWpvMUxqQXNJblJsZUhRaU9pTFFzOUN3MExmUXZ0QzcwTGpRdmRDd0lOR0IwTGpRdTlDd0luMHNJbmRoZEdWeWJXRnlheUk2ZXlKamIyeHZjaUk2V3lKSmJtNWxjaUlzSWlNd01EQXdNREF3TUNJc0luNGlYU3dpWm05dWRDSTZJbE50WVd4c0lpd2laM0poWkdsbGJuUWlPblJ5ZFdVc0ltMXZaR1VpT2xzeExqQXNNaTR3TERNdU1Dd2lmaUpkTENKdWIyNWZaM0poWkdsbGJuUWlPaUlqUmtaR1JrWkdSa1lpTENKemNHVmxaQ0k2TkM0d0xDSjBaWGgwSWpvaVRGVkJVMFZPVTBVZ1UwOGdRa0ZFSW4xOUxDSnRhWE5qSWpwN0ltRnBiV0p2ZENJNmV5Sm1ZV3RsWkhWamF5STZleUptY21WbGVtVmZjR1Z5YVc5a0lqcDBjblZsTENKMWJteHZZMnNpT25SeWRXVjlMQ0pzWVhSbGJtTjVJanA3SW5OM2FYUmphQ0k2ZEhKMVpYMHNJbXh2WjJkcGJtY2lPbnNpWTI5c2IzSnpJanA3SW0xaGFXNGlPaUlqUmtWQ1FVSkJSa1lpTENKd2NtVm1hWGdpT2lJalJrUkNRVUpCUmtZaWZTd2liVzlrWlNJNmV5SnBjMTl1YjNScFptbGpZWFJwYjI0aU9uUnlkV1VzSW5ObGJHVmpkQ0k2V3lKQmFXMWliM1FpTENKK0lsMTlMQ0p6ZDJsMFkyZ2lPblJ5ZFdWOWZTd2liVzkyWlcxbGJuUWlPbnNpWVdseVgyUjFZMnRmWTI5c2JHbHphVzl1SWpwbVlXeHpaU3dpWldSblpWOXhkV2xqYTE5emRHOXdJanBtWVd4elpTd2labUZzYkY5a1lXMWhaMlVpT25SeWRXVXNJbVpoYzNSZmJHRmtaR1Z5SWpwMGNuVmxmU3dpY0d4aGVXVnlYMkZ1YVcxaGRHbHZibk1pT25zaVptRnNiR2x1WnlJNmV5SjJZV3gxWlNJNk1DNHdmU3dpYW1sMGRHVnlYMnhsWjNNaU9uc2labkp2YlNJNk1DNHdMQ0p6ZDJsMFkyZ2lPblJ5ZFdVc0luUnZJam8xTUM0d2ZTd2liR1ZoYm1sdVp5STZleUoyWVd4MVpTSTZNVEF3TGpCOWZYMHNJblpwYzNWaGJITWlPbnNpWVhOd1pXTjBYM0poZEdsdklqcDdJbk4zYVhSamFDSTZkSEoxWlN3aWRtRnNkV1VpT2pFek15NHdmU3dpWkdGdFlXZGxYMmx1WkdsallYUnZjaUk2ZXlKemQybDBZMmdpT21aaGJITmxmU3dpWm5CelgySnZiM04wSWpwN0luTjNhWFJqYUNJNlptRnNjMlY5TENKb2FYUnRZWEpyWlhJaU9uc2lZMjlzYjNJaU9sc2lNa1FpTENJalJrWkdSa1pHUmtZaUxDSitJbDBzSW5ObGJHVmpkQ0k2V3lKK0lsMHNJblJwYldVaU9qRXdMakI5TENKcGJtTnlaV0Z6WldSZlptd2lPbnNpYzNkcGRHTm9JanBtWVd4elpTd2lkR2xqYTNNaU9qRTFMakI5TENKdFlXNTFZV3hmWVhKeWIzZHpJanA3SW1OdmJHOXlJam9pSTBaR1JrWkdSa1pHSWl3aVptOXVkQ0k2SWtSbFptRjFiSFFpTENKdlptWnpaWFFpT2pNMUxqQXNJbk4zYVhSamFDSTZabUZzYzJVc0luTjViV0p2YkhNaU9uc2labTl5ZDJGeVpDSTZJbDRpTENKc1pXWjBJam9pUENJc0luSnBaMmgwSWpvaVBpSjlmU3dpY0d4aGVXVnlYM1J5WVc1emNHRnlaVzVqZVNJNmV5SnpkMmwwWTJnaU9uUnlkV1Y5TENKeVpXMXZkbVZmYzJ4bFpYWmxjeUk2ZXlKemQybDBZMmdpT25SeWRXVjlMQ0p6WTI5d1pWOXZkbVZ5YkdGNUlqcDdJbUZ1YVcxaGRHbHZiaUk2ZEhKMVpTd2lZMjlzYjNKeklqcDdJbVZrWjJVaU9pSWpNREF3TURBd01EQWlMQ0p0WVdsdUlqb2lJemhHT0VZNFJrWkdJbjBzSW1kaGNDSTZNVEF1TUN3aWJHVnVaM1JvSWpveE9EVXVNQ3dpYjNCMGFXOXVjeUk2V3lKK0lsMHNJbk4zYVhSamFDSTZkSEoxWlgwc0luTnJaV1YwWDJsdVpHbGpZWFJ2Y25NaU9uc2lZbTl0WWlJNmRISjFaU3dpWm1WaGRIVnlaWE1pT2xzaVJtOXlZMlVnYzJGbVpTQndiMmx1ZENJc0lrWnZjbU5sSUdKdlpIa2dZV2x0SWl3aVVHbHVaeUJ6Y0dsclpTSXNJa1J2ZFdKc1pTQjBZWEFpTENKRWRXTnJJSEJsWldzZ1lYTnphWE4wSWl3aVJuSmxaWE4wWVc1a2FXNW5JaXdpVDI0Z2MyaHZkQ0JoYm5ScExXRnBiU0lzSWsxcGJtbHRkVzBnWkdGdFlXZGxJRzkyWlhKeWFXUmxJaXdpZmlKZExDSnpkMmwwWTJnaU9tWmhiSE5sZlN3aWRtVnNiMk5wZEhsZmQyRnlibWx1WnlJNmV5SmpiMnh2Y2lJNklpTkdSa1pHUmtaR1JpSXNJbk4zYVhSamFDSTZabUZzYzJWOUxDSjJhV1YzYlc5a1pXeGZZMmhoYm1kbGNpSTZleUptYjNZaU9qWTRNQzR3TENKemQybDBZMmdpT25SeWRXVXNJbmdpT2kwMkxqQXNJbmtpT2kwNUxqQXNJbm9pT2pFd0xqQjlmWDA9IiwidGltZSI6MTc0NzU5MjgzOC4wfQ==", 
        name = "Old Bobro"
    }, 
    [2] = {
        data = "eyJhdXRob3IiOiJub3BvaW50IiwiY29uZmlnIjoiZXlKaGJuUnBZV2x0SWpwN0ltRnVaMnhsY3lJNmV5SmhiblJwWDJKeWRYUmxabTl5WTJVaU9uc2liVzlrWlNJNklrMWxkR0VpTENKdWIzUnBabmtpT21aaGJITmxMQ0p6ZEdGMFpYTWlPbHNpVTNSaGJtUnBibWNpTENKU2RXNXVhVzVuSWl3aVUyeHZkMmx1WnlJc0lrTnliM1ZqYUdsdVp5SXNJbE51WldGcmFXNW5JaXdpUVdseUlpd2lRV2x5SUVOeWIzVmphR2x1WnlJc0lreGxaMmwwSUVGQklpd2lmaUpkTENKemQybDBZMmdpT25SeWRXVjlMQ0ppY21WaGExOXNZeUk2ZXlKa2FYTmhZbXhsWDI5dVgyZHlaVzVoWkdVaU9uUnlkV1VzSW1ocFpHVmZjMmh2ZEhNaU9pSkNjbVZoYXlCTVF5SXNJbk5sYkdWamRDSTZXeUpUZEdGdVpHbHVaeUlzSWxKMWJtNXBibWNpTENKVGJHOTNhVzVuSWl3aVEzSnZkV05vYVc1bklpd2lVMjVsWVd0cGJtY2lMQ0pCYVhJaUxDSkJhWElnUTNKdmRXTm9hVzVuSWl3aVRHVm5hWFFnUVVFaUxDSkdjbVZsYzNSaGJtUnBibWNpTENKK0lsMTlMQ0ppZFdsc1pHVnlJanA3SWtGcGNpSTZleUpEVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUkdWbVlYVnNkQ0lzSW1Ob2IydGxNVjh4SWpveUxqQXNJbU5vYjJ0bE1WOHlJam95TGpBc0ltTm9iMnRsTVY4eklqb3lMakFzSW1Ob2IydGxNVjgwSWpveUxqQXNJbU5vYjJ0bE1WODFJam95TGpBc0ltTm9iMnRsTVY4Mklqb3lMakFzSW1Ob2IydGxYMlp5YjIwaU9qRTJMakFzSW1Ob2IydGxYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpWOXpiR2xrWlhJaU9qRTJMakFzSW1Ob2IydGxYM05zYVdSbGNuTWlPakl1TUN3aVkyaHZhMlZmZEc4aU9qRTJMakFzSW1SbGJHRjVJanAwY25WbExDSmtaV3hoZVY4eElqb3lMakFzSW1SbGJHRjVYeklpT2pJdU1Dd2laR1ZzWVhsZk15STZNaTR3TENKa1pXeGhlVjgwSWpveUxqQXNJbVJsYkdGNVh6VWlPakl1TUN3aVpHVnNZWGxmTmlJNk1pNHdMQ0prWld4aGVWOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0prWld4aGVWOWtaV1poZFd4MElqbzNMakFzSW1SbGJHRjVYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0prWld4aGVWOXlZVzVrYjIxZmJXRjRJam95TGpBc0ltUmxiR0Y1WDNKaGJtUnZiVjl0YVc0aU9qSXVNQ3dpWm5KdmJWOXNhVzFwZENJNk5qQXVNQ3dpYkdWbWRGOXNhVzFwZENJNk5qQXVNQ3dpYkdsdGFYUmZiVzlrWlNJNklsTjBZWFJwWXlJc0ltMWhlQ0k2TUM0d0xDSnRZWGhwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YVc0aU9qQXVNQ3dpYldsdWFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXOWtaU0k2SWxOMFlYUnBZeUlzSW0xdlpHVmZjbUZ1Wkc5dElqbzBMakFzSW0xdlpHVmZkR2xqYTNNaU9qUXVNQ3dpYlc5a2FXWnBaWElpT2lKRWFYTmhZbXhsWkNJc0ltMXZaR2xtYVdWeVgyTjFjM1J2YlY5emJHbGtaWEp6SWpveUxqQXNJbTF2WkdsbWFXVnlYMjF2WkdVaU9pSkVaV1poZFd4MElpd2liVzlrYVdacFpYSmZiMlptYzJWMElqb3RNVE11TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpZaU9qQXVNQ3dpYjJabWMyVjBJam93TGpBc0luSmhibVJ2YlY5amFHOXJaU0k2Wm1Gc2MyVXNJbkpoYm1SdmJXbDZaU0k2Wm1Gc2MyVXNJbkpwWjJoMFgyeHBiV2wwSWpvMk1DNHdMQ0p6WWw5emNHVmxaQ0k2TVM0d0xDSjBiMTlzYVcxcGRDSTZOakF1TUN3aWVXRjNJam9pUW1GamEzZGhjbVFpTENKNVlYZGZiR1ZtZENJNkxUSXlMakFzSW5saGQxOXRiMlJsSWpvaVRDOVNJaXdpZVdGM1gzSnBaMmgwSWpvME1TNHdmU3dpVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUkdWbVlYVnNkQ0lzSW1Ob2IydGxNVjh4SWpveUxqQXNJbU5vYjJ0bE1WOHlJam95TGpBc0ltTm9iMnRsTVY4eklqb3lMakFzSW1Ob2IydGxNVjgwSWpveUxqQXNJbU5vYjJ0bE1WODFJam95TGpBc0ltTm9iMnRsTVY4Mklqb3lMakFzSW1Ob2IydGxYMlp5YjIwaU9qRTJMakFzSW1Ob2IydGxYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpWOXpiR2xrWlhJaU9qRTJMakFzSW1Ob2IydGxYM05zYVdSbGNuTWlPakl1TUN3aVkyaHZhMlZmZEc4aU9qRTJMakFzSW1SbGJHRjVJanAwY25WbExDSmtaV3hoZVY4eElqb3lMakFzSW1SbGJHRjVYeklpT2pJdU1Dd2laR1ZzWVhsZk15STZNaTR3TENKa1pXeGhlVjgwSWpveUxqQXNJbVJsYkdGNVh6VWlPakl1TUN3aVpHVnNZWGxmTmlJNk1pNHdMQ0prWld4aGVWOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0prWld4aGVWOWtaV1poZFd4MElqbzNMakFzSW1SbGJHRjVYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0prWld4aGVWOXlZVzVrYjIxZmJXRjRJam95TGpBc0ltUmxiR0Y1WDNKaGJtUnZiVjl0YVc0aU9qSXVNQ3dpWm5KdmJWOXNhVzFwZENJNk5qQXVNQ3dpYkdWbWRGOXNhVzFwZENJNk5qQXVNQ3dpYkdsdGFYUmZiVzlrWlNJNklsTjBZWFJwWXlJc0ltMWhlQ0k2TUM0d0xDSnRZWGhwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YVc0aU9qQXVNQ3dpYldsdWFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXOWtaU0k2SWxOMFlYUnBZeUlzSW0xdlpHVmZjbUZ1Wkc5dElqbzBMakFzSW0xdlpHVmZkR2xqYTNNaU9qUXVNQ3dpYlc5a2FXWnBaWElpT2lKRWFYTmhZbXhsWkNJc0ltMXZaR2xtYVdWeVgyTjFjM1J2YlY5emJHbGtaWEp6SWpveUxqQXNJbTF2WkdsbWFXVnlYMjF2WkdVaU9pSkVaV1poZFd4MElpd2liVzlrYVdacFpYSmZiMlptYzJWMElqb3RNVE11TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpZaU9qQXVNQ3dpYjJabWMyVjBJam93TGpBc0luSmhibVJ2YlY5amFHOXJaU0k2Wm1Gc2MyVXNJbkpoYm1SdmJXbDZaU0k2Wm1Gc2MyVXNJbkpwWjJoMFgyeHBiV2wwSWpvMk1DNHdMQ0p6WWw5emNHVmxaQ0k2TVM0d0xDSjBiMTlzYVcxcGRDSTZOakF1TUN3aWVXRjNJam9pUW1GamEzZGhjbVFpTENKNVlYZGZiR1ZtZENJNkxUSXlMakFzSW5saGQxOXRiMlJsSWpvaVRDOVNJaXdpZVdGM1gzSnBaMmgwSWpvME1TNHdmWDBzSWtGcGNpQkRjbTkxWTJocGJtY2lPbnNpUTFRaU9uc2lZV3hzYjNkZmMzUmhkR1VpT25SeWRXVXNJbUp2WkhsZlpuSmxaWE4wWVc1a2FXNW5Jam9pVDJabUlpd2lZbTlrZVY5NVlYY2lPblJ5ZFdVc0ltSnZaSGxmZVdGM1gyOXdkR2x2Ym5NaU9sc2lTbWwwZEdWeUlpd2lmaUpkTENKamFHOXJaU0k2SWtOMWMzUnZiU0lzSW1Ob2IydGxNVjh4SWpveE1DNHdMQ0pqYUc5clpURmZNaUk2TVRBdU1Dd2lZMmh2YTJVeFh6TWlPakU0TGpBc0ltTm9iMnRsTVY4MElqbzNMakFzSW1Ob2IydGxNVjgxSWpveE1DNHdMQ0pqYUc5clpURmZOaUk2TWpJdU1Dd2lZMmh2YTJWZlpuSnZiU0k2TVRZdU1Dd2lZMmh2YTJWZmJXVjBhRzlrSWpvaVEzVnpkRzl0SWl3aVkyaHZhMlZmYzJ4cFpHVnlJam94Tmk0d0xDSmphRzlyWlY5emJHbGtaWEp6SWpveUxqQXNJbU5vYjJ0bFgzUnZJam94TWk0d0xDSmtaV3hoZVNJNmRISjFaU3dpWkdWc1lYbGZNU0k2TWk0d0xDSmtaV3hoZVY4eUlqb3lMakFzSW1SbGJHRjVYek1pT2pJdU1Dd2laR1ZzWVhsZk5DSTZNaTR3TENKa1pXeGhlVjgxSWpveUxqQXNJbVJsYkdGNVh6WWlPakl1TUN3aVpHVnNZWGxmWTNWemRHOXRYM05zYVdSbGNuTWlPakl1TUN3aVpHVnNZWGxmWkdWbVlYVnNkQ0k2Tnk0d0xDSmtaV3hoZVY5dFpYUm9iMlFpT2lKU1lXNWtiMjBpTENKa1pXeGhlVjl5WVc1a2IyMWZiV0Y0SWpvNExqQXNJbVJsYkdGNVgzSmhibVJ2YlY5dGFXNGlPamN1TUN3aVpuSnZiVjlzYVcxcGRDSTZOakF1TUN3aWJHVm1kRjlzYVcxcGRDSTZOakF1TUN3aWJHbHRhWFJmYlc5a1pTSTZJa1p5YjIwdlZHOGlMQ0p0WVhnaU9pMHhNUzR3TENKdFlYaHBiWFZ0WDJ4cGJXbDBJam8yTUM0d0xDSnRhVzRpT2pBdU1Dd2liV2x1YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYlc5a1pTSTZJbFJwWTJ0eklpd2liVzlrWlY5eVlXNWtiMjBpT2pRdU1Dd2liVzlrWlY5MGFXTnJjeUk2TVRFdU1Dd2liVzlrYVdacFpYSWlPaUpUY0dsdUlpd2liVzlrYVdacFpYSmZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpYlc5a2FXWnBaWEpmYlc5a1pTSTZJa1JsWm1GMWJIUWlMQ0p0YjJScFptbGxjbDl2Wm1aelpYUWlPaTB4TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6RWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eUlqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTXlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelFpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODFJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5pSTZNQzR3TENKdlptWnpaWFFpT2pBdU1Dd2ljbUZ1Wkc5dFgyTm9iMnRsSWpwMGNuVmxMQ0p5WVc1a2IyMXBlbVVpT25SeWRXVXNJbkpwWjJoMFgyeHBiV2wwSWpvMk1DNHdMQ0p6WWw5emNHVmxaQ0k2TVM0d0xDSjBiMTlzYVcxcGRDSTZORGd1TUN3aWVXRjNJam9pUW1GamEzZGhjbVFpTENKNVlYZGZiR1ZtZENJNkxUSXlMakFzSW5saGQxOXRiMlJsSWpvaVRDOVNJaXdpZVdGM1gzSnBaMmgwSWpvME9TNHdmU3dpVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUTNWemRHOXRJaXdpWTJodmEyVXhYekVpT2pFd0xqQXNJbU5vYjJ0bE1WOHlJam94TUM0d0xDSmphRzlyWlRGZk15STZNVGd1TUN3aVkyaHZhMlV4WHpRaU9qY3VNQ3dpWTJodmEyVXhYelVpT2pFd0xqQXNJbU5vYjJ0bE1WODJJam95TWk0d0xDSmphRzlyWlY5bWNtOXRJam94Tmk0d0xDSmphRzlyWlY5dFpYUm9iMlFpT2lKRGRYTjBiMjBpTENKamFHOXJaVjl6Ykdsa1pYSWlPakUyTGpBc0ltTm9iMnRsWDNOc2FXUmxjbk1pT2pJdU1Dd2lZMmh2YTJWZmRHOGlPakV5TGpBc0ltUmxiR0Y1SWpwMGNuVmxMQ0prWld4aGVWOHhJam95TGpBc0ltUmxiR0Y1WHpJaU9qSXVNQ3dpWkdWc1lYbGZNeUk2TWk0d0xDSmtaV3hoZVY4MElqb3lMakFzSW1SbGJHRjVYelVpT2pJdU1Dd2laR1ZzWVhsZk5pSTZNaTR3TENKa1pXeGhlVjlqZFhOMGIyMWZjMnhwWkdWeWN5STZNaTR3TENKa1pXeGhlVjlrWldaaGRXeDBJam8zTGpBc0ltUmxiR0Y1WDIxbGRHaHZaQ0k2SWxKaGJtUnZiU0lzSW1SbGJHRjVYM0poYm1SdmJWOXRZWGdpT2pndU1Dd2laR1ZzWVhsZmNtRnVaRzl0WDIxcGJpSTZOeTR3TENKbWNtOXRYMnhwYldsMElqbzJNQzR3TENKc1pXWjBYMnhwYldsMElqbzJNQzR3TENKc2FXMXBkRjl0YjJSbElqb2lSbkp2YlM5VWJ5SXNJbTFoZUNJNkxURXhMakFzSW0xaGVHbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXBiaUk2TUM0d0xDSnRhVzVwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YjJSbElqb2lWR2xqYTNNaUxDSnRiMlJsWDNKaGJtUnZiU0k2TkM0d0xDSnRiMlJsWDNScFkydHpJam94TVM0d0xDSnRiMlJwWm1sbGNpSTZJbE53YVc0aUxDSnRiMlJwWm1sbGNsOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0p0YjJScFptbGxjbDl0YjJSbElqb2lSR1ZtWVhWc2RDSXNJbTF2WkdsbWFXVnlYMjltWm5ObGRDSTZMVEV3TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk1TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpJaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh6SWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOQ0k2TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6VWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4Mklqb3dMakFzSW05bVpuTmxkQ0k2TUM0d0xDSnlZVzVrYjIxZlkyaHZhMlVpT25SeWRXVXNJbkpoYm1SdmJXbDZaU0k2ZEhKMVpTd2ljbWxuYUhSZmJHbHRhWFFpT2pZd0xqQXNJbk5pWDNOd1pXVmtJam94TGpBc0luUnZYMnhwYldsMElqbzBPQzR3TENKNVlYY2lPaUpDWVdOcmQyRnlaQ0lzSW5saGQxOXNaV1owSWpvdE1qSXVNQ3dpZVdGM1gyMXZaR1VpT2lKTUwxSWlMQ0o1WVhkZmNtbG5hSFFpT2pRNUxqQjlmU3dpUTNKdmRXTm9hVzVuSWpwN0lrTlVJanA3SW1Gc2JHOTNYM04wWVhSbElqcDBjblZsTENKaWIyUjVYMlp5WldWemRHRnVaR2x1WnlJNklrOW1aaUlzSW1KdlpIbGZlV0YzSWpwMGNuVmxMQ0ppYjJSNVgzbGhkMTl2Y0hScGIyNXpJanBiSWtwcGRIUmxjaUlzSW40aVhTd2lZMmh2YTJVaU9pSkRkWE4wYjIwaUxDSmphRzlyWlRGZk1TSTZOaTR3TENKamFHOXJaVEZmTWlJNk1qSXVNQ3dpWTJodmEyVXhYek1pT2pRdU1Dd2lZMmh2YTJVeFh6UWlPakUwTGpBc0ltTm9iMnRsTVY4MUlqbzVMakFzSW1Ob2IydGxNVjgySWpvMExqQXNJbU5vYjJ0bFgyWnliMjBpT2pndU1Dd2lZMmh2YTJWZmJXVjBhRzlrSWpvaVEzVnpkRzl0SWl3aVkyaHZhMlZmYzJ4cFpHVnlJam94Tmk0d0xDSmphRzlyWlY5emJHbGtaWEp6SWpvMkxqQXNJbU5vYjJ0bFgzUnZJam95TWk0d0xDSmtaV3hoZVNJNmRISjFaU3dpWkdWc1lYbGZNU0k2TWk0d0xDSmtaV3hoZVY4eUlqb3lMakFzSW1SbGJHRjVYek1pT2pJdU1Dd2laR1ZzWVhsZk5DSTZNaTR3TENKa1pXeGhlVjgxSWpveUxqQXNJbVJsYkdGNVh6WWlPakl1TUN3aVpHVnNZWGxmWTNWemRHOXRYM05zYVdSbGNuTWlPakl1TUN3aVpHVnNZWGxmWkdWbVlYVnNkQ0k2T1M0d0xDSmtaV3hoZVY5dFpYUm9iMlFpT2lKRVpXWmhkV3gwSWl3aVpHVnNZWGxmY21GdVpHOXRYMjFoZUNJNk1UQXVNQ3dpWkdWc1lYbGZjbUZ1Wkc5dFgyMXBiaUk2TlM0d0xDSm1jbTl0WDJ4cGJXbDBJam8yTUM0d0xDSnNaV1owWDJ4cGJXbDBJam8yTUM0d0xDSnNhVzFwZEY5dGIyUmxJam9pVTNSaGRHbGpJaXdpYldGNElqb3dMakFzSW0xaGVHbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXBiaUk2TUM0d0xDSnRhVzVwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YjJSbElqb2lVM1JoZEdsaklpd2liVzlrWlY5eVlXNWtiMjBpT2pRdU1Dd2liVzlrWlY5MGFXTnJjeUk2TkM0d0xDSnRiMlJwWm1sbGNpSTZJbE53YVc0aUxDSnRiMlJwWm1sbGNsOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk15NHdMQ0p0YjJScFptbGxjbDl0YjJSbElqb2lRM1Z6ZEc5dElpd2liVzlrYVdacFpYSmZiMlptYzJWMElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTVNJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYeklpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHpJam90TVRVdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpZaU9qQXVNQ3dpYjJabWMyVjBJam93TGpBc0luSmhibVJ2YlY5amFHOXJaU0k2ZEhKMVpTd2ljbUZ1Wkc5dGFYcGxJanAwY25WbExDSnlhV2RvZEY5c2FXMXBkQ0k2TmpBdU1Dd2ljMkpmYzNCbFpXUWlPakV1TUN3aWRHOWZiR2x0YVhRaU9qWXdMakFzSW5saGR5STZJa0poWTJ0M1lYSmtJaXdpZVdGM1gyeGxablFpT2kweU55NHdMQ0o1WVhkZmJXOWtaU0k2SWt3dlVpSXNJbmxoZDE5eWFXZG9kQ0k2TkRBdU1IMHNJbFFpT25zaVlXeHNiM2RmYzNSaGRHVWlPblJ5ZFdVc0ltSnZaSGxmWm5KbFpYTjBZVzVrYVc1bklqb2lUMlptSWl3aVltOWtlVjk1WVhjaU9uUnlkV1VzSW1KdlpIbGZlV0YzWDI5d2RHbHZibk1pT2xzaVNtbDBkR1Z5SWl3aWZpSmRMQ0pqYUc5clpTSTZJa04xYzNSdmJTSXNJbU5vYjJ0bE1WOHhJam8yTGpBc0ltTm9iMnRsTVY4eUlqb3lNaTR3TENKamFHOXJaVEZmTXlJNk5DNHdMQ0pqYUc5clpURmZOQ0k2TVRRdU1Dd2lZMmh2YTJVeFh6VWlPamt1TUN3aVkyaHZhMlV4WHpZaU9qUXVNQ3dpWTJodmEyVmZabkp2YlNJNk9DNHdMQ0pqYUc5clpWOXRaWFJvYjJRaU9pSkRkWE4wYjIwaUxDSmphRzlyWlY5emJHbGtaWElpT2pFMkxqQXNJbU5vYjJ0bFgzTnNhV1JsY25NaU9qWXVNQ3dpWTJodmEyVmZkRzhpT2pJeUxqQXNJbVJsYkdGNUlqcDBjblZsTENKa1pXeGhlVjh4SWpveUxqQXNJbVJsYkdGNVh6SWlPakl1TUN3aVpHVnNZWGxmTXlJNk1pNHdMQ0prWld4aGVWODBJam95TGpBc0ltUmxiR0Y1WHpVaU9qSXVNQ3dpWkdWc1lYbGZOaUk2TWk0d0xDSmtaV3hoZVY5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSmtaV3hoZVY5a1pXWmhkV3gwSWpvNUxqQXNJbVJsYkdGNVgyMWxkR2h2WkNJNklrUmxabUYxYkhRaUxDSmtaV3hoZVY5eVlXNWtiMjFmYldGNElqb3hNQzR3TENKa1pXeGhlVjl5WVc1a2IyMWZiV2x1SWpvMUxqQXNJbVp5YjIxZmJHbHRhWFFpT2pZd0xqQXNJbXhsWm5SZmJHbHRhWFFpT2pZd0xqQXNJbXhwYldsMFgyMXZaR1VpT2lKVGRHRjBhV01pTENKdFlYZ2lPakF1TUN3aWJXRjRhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liV2x1SWpvd0xqQXNJbTFwYm1sdGRXMWZiR2x0YVhRaU9qWXdMakFzSW0xdlpHVWlPaUpUZEdGMGFXTWlMQ0p0YjJSbFgzSmhibVJ2YlNJNk5DNHdMQ0p0YjJSbFgzUnBZMnR6SWpvMExqQXNJbTF2WkdsbWFXVnlJam9pVTNCcGJpSXNJbTF2WkdsbWFXVnlYMk4xYzNSdmJWOXpiR2xrWlhKeklqb3pMakFzSW0xdlpHbG1hV1Z5WDIxdlpHVWlPaUpEZFhOMGIyMGlMQ0p0YjJScFptbGxjbDl2Wm1aelpYUWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2kweE5TNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelFpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODFJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5pSTZNQzR3TENKdlptWnpaWFFpT2pBdU1Dd2ljbUZ1Wkc5dFgyTm9iMnRsSWpwMGNuVmxMQ0p5WVc1a2IyMXBlbVVpT25SeWRXVXNJbkpwWjJoMFgyeHBiV2wwSWpvMk1DNHdMQ0p6WWw5emNHVmxaQ0k2TVM0d0xDSjBiMTlzYVcxcGRDSTZOakF1TUN3aWVXRjNJam9pUW1GamEzZGhjbVFpTENKNVlYZGZiR1ZtZENJNkxUSTNMakFzSW5saGQxOXRiMlJsSWpvaVRDOVNJaXdpZVdGM1gzSnBaMmgwSWpvME1DNHdmWDBzSWtaeVpXVnpkR0Z1WkdsdVp5STZleUpEVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUkdWbVlYVnNkQ0lzSW1Ob2IydGxNVjh4SWpveUxqQXNJbU5vYjJ0bE1WOHlJam95TGpBc0ltTm9iMnRsTVY4eklqb3lMakFzSW1Ob2IydGxNVjgwSWpveUxqQXNJbU5vYjJ0bE1WODFJam95TGpBc0ltTm9iMnRsTVY4Mklqb3lMakFzSW1Ob2IydGxYMlp5YjIwaU9qRTJMakFzSW1Ob2IydGxYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpWOXpiR2xrWlhJaU9qRTJMakFzSW1Ob2IydGxYM05zYVdSbGNuTWlPakl1TUN3aVkyaHZhMlZmZEc4aU9qRTJMakFzSW1SbGJHRjVJanBtWVd4elpTd2laR1ZzWVhsZk1TSTZNaTR3TENKa1pXeGhlVjh5SWpveUxqQXNJbVJsYkdGNVh6TWlPakl1TUN3aVpHVnNZWGxmTkNJNk1pNHdMQ0prWld4aGVWODFJam95TGpBc0ltUmxiR0Y1WHpZaU9qSXVNQ3dpWkdWc1lYbGZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpWkdWc1lYbGZaR1ZtWVhWc2RDSTZNaTR3TENKa1pXeGhlVjl0WlhSb2IyUWlPaUpFWldaaGRXeDBJaXdpWkdWc1lYbGZjbUZ1Wkc5dFgyMWhlQ0k2TWk0d0xDSmtaV3hoZVY5eVlXNWtiMjFmYldsdUlqb3lMakFzSW1aeWIyMWZiR2x0YVhRaU9qWXdMakFzSW14bFpuUmZiR2x0YVhRaU9qWXdMakFzSW14cGJXbDBYMjF2WkdVaU9pSlRkR0YwYVdNaUxDSnRZWGdpT2pBdU1Dd2liV0Y0YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYldsdUlqb3dMakFzSW0xcGJtbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXZaR1VpT2lKVGRHRjBhV01pTENKdGIyUmxYM0poYm1SdmJTSTZOQzR3TENKdGIyUmxYM1JwWTJ0eklqbzBMakFzSW0xdlpHbG1hV1Z5SWpvaVJHbHpZV0pzWldRaUxDSnRiMlJwWm1sbGNsOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0p0YjJScFptbGxjbDl0YjJSbElqb2lSR1ZtWVhWc2RDSXNJbTF2WkdsbWFXVnlYMjltWm5ObGRDSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpFaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh5SWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZNeUk2TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6UWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4MUlqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTmlJNk1DNHdMQ0p2Wm1aelpYUWlPakF1TUN3aWNtRnVaRzl0WDJOb2IydGxJanBtWVd4elpTd2ljbUZ1Wkc5dGFYcGxJanBtWVd4elpTd2ljbWxuYUhSZmJHbHRhWFFpT2pZd0xqQXNJbk5pWDNOd1pXVmtJam94TGpBc0luUnZYMnhwYldsMElqbzJNQzR3TENKNVlYY2lPaUpDWVdOcmQyRnlaQ0lzSW5saGQxOXNaV1owSWpvd0xqQXNJbmxoZDE5dGIyUmxJam9pVTI5c2J5SXNJbmxoZDE5eWFXZG9kQ0k2TUM0d2ZTd2lWQ0k2ZXlKaGJHeHZkMTl6ZEdGMFpTSTZkSEoxWlN3aVltOWtlVjltY21WbGMzUmhibVJwYm1jaU9pSlBabVlpTENKaWIyUjVYM2xoZHlJNmRISjFaU3dpWW05a2VWOTVZWGRmYjNCMGFXOXVjeUk2V3lKS2FYUjBaWElpTENKK0lsMHNJbU5vYjJ0bElqb2lSR1ZtWVhWc2RDSXNJbU5vYjJ0bE1WOHhJam95TGpBc0ltTm9iMnRsTVY4eUlqb3lMakFzSW1Ob2IydGxNVjh6SWpveUxqQXNJbU5vYjJ0bE1WODBJam95TGpBc0ltTm9iMnRsTVY4MUlqb3lMakFzSW1Ob2IydGxNVjgySWpveUxqQXNJbU5vYjJ0bFgyWnliMjBpT2pFMkxqQXNJbU5vYjJ0bFgyMWxkR2h2WkNJNklrUmxabUYxYkhRaUxDSmphRzlyWlY5emJHbGtaWElpT2pFMkxqQXNJbU5vYjJ0bFgzTnNhV1JsY25NaU9qSXVNQ3dpWTJodmEyVmZkRzhpT2pFMkxqQXNJbVJsYkdGNUlqcG1ZV3h6WlN3aVpHVnNZWGxmTVNJNk1pNHdMQ0prWld4aGVWOHlJam95TGpBc0ltUmxiR0Y1WHpNaU9qSXVNQ3dpWkdWc1lYbGZOQ0k2TWk0d0xDSmtaV3hoZVY4MUlqb3lMakFzSW1SbGJHRjVYellpT2pJdU1Dd2laR1ZzWVhsZlkzVnpkRzl0WDNOc2FXUmxjbk1pT2pJdU1Dd2laR1ZzWVhsZlpHVm1ZWFZzZENJNk1pNHdMQ0prWld4aGVWOXRaWFJvYjJRaU9pSkVaV1poZFd4MElpd2laR1ZzWVhsZmNtRnVaRzl0WDIxaGVDSTZNaTR3TENKa1pXeGhlVjl5WVc1a2IyMWZiV2x1SWpveUxqQXNJbVp5YjIxZmJHbHRhWFFpT2pZd0xqQXNJbXhsWm5SZmJHbHRhWFFpT2pZd0xqQXNJbXhwYldsMFgyMXZaR1VpT2lKVGRHRjBhV01pTENKdFlYZ2lPakF1TUN3aWJXRjRhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liV2x1SWpvd0xqQXNJbTFwYm1sdGRXMWZiR2x0YVhRaU9qWXdMakFzSW0xdlpHVWlPaUpUZEdGMGFXTWlMQ0p0YjJSbFgzSmhibVJ2YlNJNk5DNHdMQ0p0YjJSbFgzUnBZMnR6SWpvMExqQXNJbTF2WkdsbWFXVnlJam9pUkdsellXSnNaV1FpTENKdGIyUnBabWxsY2w5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSnRiMlJwWm1sbGNsOXRiMlJsSWpvaVJHVm1ZWFZzZENJc0ltMXZaR2xtYVdWeVgyOW1abk5sZENJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qQXVNQ3dpY21GdVpHOXRYMk5vYjJ0bElqcG1ZV3h6WlN3aWNtRnVaRzl0YVhwbElqcG1ZV3h6WlN3aWNtbG5hSFJmYkdsdGFYUWlPall3TGpBc0luTmlYM053WldWa0lqb3hMakFzSW5SdlgyeHBiV2wwSWpvMk1DNHdMQ0o1WVhjaU9pSkNZV05yZDJGeVpDSXNJbmxoZDE5c1pXWjBJam93TGpBc0lubGhkMTl0YjJSbElqb2lVMjlzYnlJc0lubGhkMTl5YVdkb2RDSTZNQzR3Zlgwc0lreGxaMmwwSUVGQklqcDdJa05VSWpwN0ltRnNiRzkzWDNOMFlYUmxJanAwY25WbExDSmliMlI1WDJaeVpXVnpkR0Z1WkdsdVp5STZJbEJsWldzZ1VtVmhiQ0lzSW1KdlpIbGZlV0YzSWpwMGNuVmxMQ0ppYjJSNVgzbGhkMTl2Y0hScGIyNXpJanBiSWtwcGRIUmxjaUlzSWxKaGJtUnZiV2w2WlNCS2FYUjBaWElpTENKQmJuUnBJRUp5ZFhSbFptOXlZMlVpTENKK0lsMHNJbU5vYjJ0bElqb2lSR1ZtWVhWc2RDSXNJbU5vYjJ0bE1WOHhJam95TGpBc0ltTm9iMnRsTVY4eUlqb3lMakFzSW1Ob2IydGxNVjh6SWpveUxqQXNJbU5vYjJ0bE1WODBJam95TGpBc0ltTm9iMnRsTVY4MUlqb3lMakFzSW1Ob2IydGxNVjgySWpveUxqQXNJbU5vYjJ0bFgyWnliMjBpT2pFMkxqQXNJbU5vYjJ0bFgyMWxkR2h2WkNJNklrUmxabUYxYkhRaUxDSmphRzlyWlY5emJHbGtaWElpT2pFMkxqQXNJbU5vYjJ0bFgzTnNhV1JsY25NaU9qSXVNQ3dpWTJodmEyVmZkRzhpT2pFMkxqQXNJbVJsYkdGNUlqcDBjblZsTENKa1pXeGhlVjh4SWpveUxqQXNJbVJsYkdGNVh6SWlPakl1TUN3aVpHVnNZWGxmTXlJNk1pNHdMQ0prWld4aGVWODBJam95TGpBc0ltUmxiR0Y1WHpVaU9qSXVNQ3dpWkdWc1lYbGZOaUk2TWk0d0xDSmtaV3hoZVY5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSmtaV3hoZVY5a1pXWmhkV3gwSWpveUxqQXNJbVJsYkdGNVgyMWxkR2h2WkNJNklsSmhibVJ2YlNJc0ltUmxiR0Y1WDNKaGJtUnZiVjl0WVhnaU9qSXVNQ3dpWkdWc1lYbGZjbUZ1Wkc5dFgyMXBiaUk2TWk0d0xDSm1jbTl0WDJ4cGJXbDBJam8yTUM0d0xDSnNaV1owWDJ4cGJXbDBJam8yTUM0d0xDSnNhVzFwZEY5dGIyUmxJam9pUm5KdmJTOVVieUlzSW0xaGVDSTZNQzR3TENKdFlYaHBiWFZ0WDJ4cGJXbDBJam8yTUM0d0xDSnRhVzRpT2pBdU1Dd2liV2x1YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYlc5a1pTSTZJbE4wWVhScFl5SXNJbTF2WkdWZmNtRnVaRzl0SWpvMExqQXNJbTF2WkdWZmRHbGphM01pT2pRdU1Dd2liVzlrYVdacFpYSWlPaUpDYjJKeWJ5SXNJbTF2WkdsbWFXVnlYMk4xYzNSdmJWOXpiR2xrWlhKeklqb3lMakFzSW0xdlpHbG1hV1Z5WDIxdlpHVWlPaUpFWldaaGRXeDBJaXdpYlc5a2FXWnBaWEpmYjJabWMyVjBJam90TlM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6RWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eUlqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTXlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelFpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODFJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5pSTZNQzR3TENKdlptWnpaWFFpT2pFNE1DNHdMQ0p5WVc1a2IyMWZZMmh2YTJVaU9tWmhiSE5sTENKeVlXNWtiMjFwZW1VaU9tWmhiSE5sTENKeWFXZG9kRjlzYVcxcGRDSTZOakF1TUN3aWMySmZjM0JsWldRaU9qRXVNQ3dpZEc5ZmJHbHRhWFFpT2pZd0xqQXNJbmxoZHlJNklrSmhZMnQzWVhKa0lpd2llV0YzWDJ4bFpuUWlPakF1TUN3aWVXRjNYMjF2WkdVaU9pSlRiMnh2SWl3aWVXRjNYM0pwWjJoMElqb3dMakI5TENKVUlqcDdJbUZzYkc5M1gzTjBZWFJsSWpwMGNuVmxMQ0ppYjJSNVgyWnlaV1Z6ZEdGdVpHbHVaeUk2SWxCbFpXc2dVbVZoYkNJc0ltSnZaSGxmZVdGM0lqcDBjblZsTENKaWIyUjVYM2xoZDE5dmNIUnBiMjV6SWpwYklrcHBkSFJsY2lJc0lsSmhibVJ2YldsNlpTQkthWFIwWlhJaUxDSkJiblJwSUVKeWRYUmxabTl5WTJVaUxDSitJbDBzSW1Ob2IydGxJam9pUkdWbVlYVnNkQ0lzSW1Ob2IydGxNVjh4SWpveUxqQXNJbU5vYjJ0bE1WOHlJam95TGpBc0ltTm9iMnRsTVY4eklqb3lMakFzSW1Ob2IydGxNVjgwSWpveUxqQXNJbU5vYjJ0bE1WODFJam95TGpBc0ltTm9iMnRsTVY4Mklqb3lMakFzSW1Ob2IydGxYMlp5YjIwaU9qRTJMakFzSW1Ob2IydGxYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpWOXpiR2xrWlhJaU9qRTJMakFzSW1Ob2IydGxYM05zYVdSbGNuTWlPakl1TUN3aVkyaHZhMlZmZEc4aU9qRTJMakFzSW1SbGJHRjVJanAwY25WbExDSmtaV3hoZVY4eElqb3lMakFzSW1SbGJHRjVYeklpT2pJdU1Dd2laR1ZzWVhsZk15STZNaTR3TENKa1pXeGhlVjgwSWpveUxqQXNJbVJsYkdGNVh6VWlPakl1TUN3aVpHVnNZWGxmTmlJNk1pNHdMQ0prWld4aGVWOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0prWld4aGVWOWtaV1poZFd4MElqb3lMakFzSW1SbGJHRjVYMjFsZEdodlpDSTZJbEpoYm1SdmJTSXNJbVJsYkdGNVgzSmhibVJ2YlY5dFlYZ2lPakl1TUN3aVpHVnNZWGxmY21GdVpHOXRYMjFwYmlJNk1pNHdMQ0ptY205dFgyeHBiV2wwSWpvMk1DNHdMQ0pzWldaMFgyeHBiV2wwSWpvMk1DNHdMQ0pzYVcxcGRGOXRiMlJsSWpvaVJuSnZiUzlVYnlJc0ltMWhlQ0k2TUM0d0xDSnRZWGhwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YVc0aU9qQXVNQ3dpYldsdWFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXOWtaU0k2SWxOMFlYUnBZeUlzSW0xdlpHVmZjbUZ1Wkc5dElqbzBMakFzSW0xdlpHVmZkR2xqYTNNaU9qUXVNQ3dpYlc5a2FXWnBaWElpT2lKQ2IySnlieUlzSW0xdlpHbG1hV1Z5WDJOMWMzUnZiVjl6Ykdsa1pYSnpJam95TGpBc0ltMXZaR2xtYVdWeVgyMXZaR1VpT2lKRVpXWmhkV3gwSWl3aWJXOWthV1pwWlhKZmIyWm1jMlYwSWpvdE5TNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qRTRNQzR3TENKeVlXNWtiMjFmWTJodmEyVWlPbVpoYkhObExDSnlZVzVrYjIxcGVtVWlPbVpoYkhObExDSnlhV2RvZEY5c2FXMXBkQ0k2TmpBdU1Dd2ljMkpmYzNCbFpXUWlPakV1TUN3aWRHOWZiR2x0YVhRaU9qWXdMakFzSW5saGR5STZJa0poWTJ0M1lYSmtJaXdpZVdGM1gyeGxablFpT2pBdU1Dd2llV0YzWDIxdlpHVWlPaUpUYjJ4dklpd2llV0YzWDNKcFoyaDBJam93TGpCOWZTd2lVblZ1Ym1sdVp5STZleUpEVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUTNWemRHOXRJaXdpWTJodmEyVXhYekVpT2pndU1Dd2lZMmh2YTJVeFh6SWlPakl5TGpBc0ltTm9iMnRsTVY4eklqb3hNQzR3TENKamFHOXJaVEZmTkNJNk1pNHdMQ0pqYUc5clpURmZOU0k2TlM0d0xDSmphRzlyWlRGZk5pSTZNVFV1TUN3aVkyaHZhMlZmWm5KdmJTSTZNVFl1TUN3aVkyaHZhMlZmYldWMGFHOWtJam9pUTNWemRHOXRJaXdpWTJodmEyVmZjMnhwWkdWeUlqb3hOaTR3TENKamFHOXJaVjl6Ykdsa1pYSnpJam8yTGpBc0ltTm9iMnRsWDNSdklqb3hOaTR3TENKa1pXeGhlU0k2ZEhKMVpTd2laR1ZzWVhsZk1TSTZNaTR3TENKa1pXeGhlVjh5SWpveUxqQXNJbVJsYkdGNVh6TWlPakl1TUN3aVpHVnNZWGxmTkNJNk1pNHdMQ0prWld4aGVWODFJam95TGpBc0ltUmxiR0Y1WHpZaU9qSXVNQ3dpWkdWc1lYbGZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpWkdWc1lYbGZaR1ZtWVhWc2RDSTZPQzR3TENKa1pXeGhlVjl0WlhSb2IyUWlPaUpFWldaaGRXeDBJaXdpWkdWc1lYbGZjbUZ1Wkc5dFgyMWhlQ0k2TWk0d0xDSmtaV3hoZVY5eVlXNWtiMjFmYldsdUlqb3lMakFzSW1aeWIyMWZiR2x0YVhRaU9qWXdMakFzSW14bFpuUmZiR2x0YVhRaU9qWXdMakFzSW14cGJXbDBYMjF2WkdVaU9pSlRkR0YwYVdNaUxDSnRZWGdpT2pBdU1Dd2liV0Y0YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYldsdUlqb3dMakFzSW0xcGJtbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXZaR1VpT2lKVGRHRjBhV01pTENKdGIyUmxYM0poYm1SdmJTSTZOQzR3TENKdGIyUmxYM1JwWTJ0eklqbzBMakFzSW0xdlpHbG1hV1Z5SWpvaVFtOWljbThpTENKdGIyUnBabWxsY2w5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSnRiMlJwWm1sbGNsOXRiMlJsSWpvaVJHVm1ZWFZzZENJc0ltMXZaR2xtYVdWeVgyOW1abk5sZENJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qQXVNQ3dpY21GdVpHOXRYMk5vYjJ0bElqcDBjblZsTENKeVlXNWtiMjFwZW1VaU9tWmhiSE5sTENKeWFXZG9kRjlzYVcxcGRDSTZOakF1TUN3aWMySmZjM0JsWldRaU9qRXVNQ3dpZEc5ZmJHbHRhWFFpT2pZd0xqQXNJbmxoZHlJNklrSmhZMnQzWVhKa0lpd2llV0YzWDJ4bFpuUWlPaTB5Tmk0d0xDSjVZWGRmYlc5a1pTSTZJa3d2VWlJc0lubGhkMTl5YVdkb2RDSTZOREV1TUgwc0lsUWlPbnNpWVd4c2IzZGZjM1JoZEdVaU9uUnlkV1VzSW1KdlpIbGZabkpsWlhOMFlXNWthVzVuSWpvaVQyWm1JaXdpWW05a2VWOTVZWGNpT25SeWRXVXNJbUp2WkhsZmVXRjNYMjl3ZEdsdmJuTWlPbHNpU21sMGRHVnlJaXdpZmlKZExDSmphRzlyWlNJNklrTjFjM1J2YlNJc0ltTm9iMnRsTVY4eElqbzRMakFzSW1Ob2IydGxNVjh5SWpveU1pNHdMQ0pqYUc5clpURmZNeUk2TVRBdU1Dd2lZMmh2YTJVeFh6UWlPakl1TUN3aVkyaHZhMlV4WHpVaU9qVXVNQ3dpWTJodmEyVXhYellpT2pFMUxqQXNJbU5vYjJ0bFgyWnliMjBpT2pFMkxqQXNJbU5vYjJ0bFgyMWxkR2h2WkNJNklrTjFjM1J2YlNJc0ltTm9iMnRsWDNOc2FXUmxjaUk2TVRZdU1Dd2lZMmh2YTJWZmMyeHBaR1Z5Y3lJNk5pNHdMQ0pqYUc5clpWOTBieUk2TVRZdU1Dd2laR1ZzWVhraU9uUnlkV1VzSW1SbGJHRjVYekVpT2pJdU1Dd2laR1ZzWVhsZk1pSTZNaTR3TENKa1pXeGhlVjh6SWpveUxqQXNJbVJsYkdGNVh6UWlPakl1TUN3aVpHVnNZWGxmTlNJNk1pNHdMQ0prWld4aGVWODJJam95TGpBc0ltUmxiR0Y1WDJOMWMzUnZiVjl6Ykdsa1pYSnpJam95TGpBc0ltUmxiR0Y1WDJSbFptRjFiSFFpT2pndU1Dd2laR1ZzWVhsZmJXVjBhRzlrSWpvaVJHVm1ZWFZzZENJc0ltUmxiR0Y1WDNKaGJtUnZiVjl0WVhnaU9qSXVNQ3dpWkdWc1lYbGZjbUZ1Wkc5dFgyMXBiaUk2TWk0d0xDSm1jbTl0WDJ4cGJXbDBJam8yTUM0d0xDSnNaV1owWDJ4cGJXbDBJam8yTUM0d0xDSnNhVzFwZEY5dGIyUmxJam9pVTNSaGRHbGpJaXdpYldGNElqb3dMakFzSW0xaGVHbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXBiaUk2TUM0d0xDSnRhVzVwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YjJSbElqb2lVM1JoZEdsaklpd2liVzlrWlY5eVlXNWtiMjBpT2pRdU1Dd2liVzlrWlY5MGFXTnJjeUk2TkM0d0xDSnRiMlJwWm1sbGNpSTZJa0p2WW5Kdklpd2liVzlrYVdacFpYSmZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpYlc5a2FXWnBaWEpmYlc5a1pTSTZJa1JsWm1GMWJIUWlMQ0p0YjJScFptbGxjbDl2Wm1aelpYUWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpZaU9qQXVNQ3dpYjJabWMyVjBJam93TGpBc0luSmhibVJ2YlY5amFHOXJaU0k2ZEhKMVpTd2ljbUZ1Wkc5dGFYcGxJanBtWVd4elpTd2ljbWxuYUhSZmJHbHRhWFFpT2pZd0xqQXNJbk5pWDNOd1pXVmtJam94TGpBc0luUnZYMnhwYldsMElqbzJNQzR3TENKNVlYY2lPaUpDWVdOcmQyRnlaQ0lzSW5saGQxOXNaV1owSWpvdE1qWXVNQ3dpZVdGM1gyMXZaR1VpT2lKTUwxSWlMQ0o1WVhkZmNtbG5hSFFpT2pReExqQjlmU3dpVTJ4dmQybHVaeUk2ZXlKRFZDSTZleUpoYkd4dmQxOXpkR0YwWlNJNmRISjFaU3dpWW05a2VWOW1jbVZsYzNSaGJtUnBibWNpT2lKUFptWWlMQ0ppYjJSNVgzbGhkeUk2ZEhKMVpTd2lZbTlrZVY5NVlYZGZiM0IwYVc5dWN5STZXeUpLYVhSMFpYSWlMQ0orSWwwc0ltTm9iMnRsSWpvaVJHVm1ZWFZzZENJc0ltTm9iMnRsTVY4eElqb3lMakFzSW1Ob2IydGxNVjh5SWpveUxqQXNJbU5vYjJ0bE1WOHpJam95TGpBc0ltTm9iMnRsTVY4MElqb3lMakFzSW1Ob2IydGxNVjgxSWpveUxqQXNJbU5vYjJ0bE1WODJJam95TGpBc0ltTm9iMnRsWDJaeWIyMGlPakUyTGpBc0ltTm9iMnRsWDIxbGRHaHZaQ0k2SWtSbFptRjFiSFFpTENKamFHOXJaVjl6Ykdsa1pYSWlPakUyTGpBc0ltTm9iMnRsWDNOc2FXUmxjbk1pT2pJdU1Dd2lZMmh2YTJWZmRHOGlPakUyTGpBc0ltUmxiR0Y1SWpwMGNuVmxMQ0prWld4aGVWOHhJam96TGpBc0ltUmxiR0Y1WHpJaU9qY3VNQ3dpWkdWc1lYbGZNeUk2TWk0d0xDSmtaV3hoZVY4MElqb3hNUzR3TENKa1pXeGhlVjgxSWpvMkxqQXNJbVJsYkdGNVh6WWlPamd1TUN3aVpHVnNZWGxmWTNWemRHOXRYM05zYVdSbGNuTWlPall1TUN3aVpHVnNZWGxmWkdWbVlYVnNkQ0k2TWk0d0xDSmtaV3hoZVY5dFpYUm9iMlFpT2lKRGRYTjBiMjBpTENKa1pXeGhlVjl5WVc1a2IyMWZiV0Y0SWpveUxqQXNJbVJsYkdGNVgzSmhibVJ2YlY5dGFXNGlPakl1TUN3aVpuSnZiVjlzYVcxcGRDSTZOakF1TUN3aWJHVm1kRjlzYVcxcGRDSTZOakF1TUN3aWJHbHRhWFJmYlc5a1pTSTZJbE4wWVhScFl5SXNJbTFoZUNJNk1DNHdMQ0p0WVhocGJYVnRYMnhwYldsMElqbzJNQzR3TENKdGFXNGlPakF1TUN3aWJXbHVhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liVzlrWlNJNklsTjBZWFJwWXlJc0ltMXZaR1ZmY21GdVpHOXRJam8wTGpBc0ltMXZaR1ZmZEdsamEzTWlPalF1TUN3aWJXOWthV1pwWlhJaU9pSkNiMkp5YnlJc0ltMXZaR2xtYVdWeVgyTjFjM1J2YlY5emJHbGtaWEp6SWpvMUxqQXNJbTF2WkdsbWFXVnlYMjF2WkdVaU9pSkRkWE4wYjIwaUxDSnRiMlJwWm1sbGNsOXZabVp6WlhRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh4SWpvdE1USXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh5SWpveE55NHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2kwek9TNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelFpT2kwMU1TNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelVpT2pRd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qQXVNQ3dpY21GdVpHOXRYMk5vYjJ0bElqcG1ZV3h6WlN3aWNtRnVaRzl0YVhwbElqcDBjblZsTENKeWFXZG9kRjlzYVcxcGRDSTZOakF1TUN3aWMySmZjM0JsWldRaU9qRXVNQ3dpZEc5ZmJHbHRhWFFpT2pZd0xqQXNJbmxoZHlJNklrSmhZMnQzWVhKa0lpd2llV0YzWDJ4bFpuUWlPaTB5Tnk0d0xDSjVZWGRmYlc5a1pTSTZJa3d2VWlJc0lubGhkMTl5YVdkb2RDSTZNemd1TUgwc0lsUWlPbnNpWVd4c2IzZGZjM1JoZEdVaU9uUnlkV1VzSW1KdlpIbGZabkpsWlhOMFlXNWthVzVuSWpvaVQyWm1JaXdpWW05a2VWOTVZWGNpT25SeWRXVXNJbUp2WkhsZmVXRjNYMjl3ZEdsdmJuTWlPbHNpU21sMGRHVnlJaXdpZmlKZExDSmphRzlyWlNJNklrUmxabUYxYkhRaUxDSmphRzlyWlRGZk1TSTZNaTR3TENKamFHOXJaVEZmTWlJNk1pNHdMQ0pqYUc5clpURmZNeUk2TWk0d0xDSmphRzlyWlRGZk5DSTZNaTR3TENKamFHOXJaVEZmTlNJNk1pNHdMQ0pqYUc5clpURmZOaUk2TWk0d0xDSmphRzlyWlY5bWNtOXRJam94Tmk0d0xDSmphRzlyWlY5dFpYUm9iMlFpT2lKRVpXWmhkV3gwSWl3aVkyaHZhMlZmYzJ4cFpHVnlJam94Tmk0d0xDSmphRzlyWlY5emJHbGtaWEp6SWpveUxqQXNJbU5vYjJ0bFgzUnZJam94Tmk0d0xDSmtaV3hoZVNJNmRISjFaU3dpWkdWc1lYbGZNU0k2TXk0d0xDSmtaV3hoZVY4eUlqbzNMakFzSW1SbGJHRjVYek1pT2pJdU1Dd2laR1ZzWVhsZk5DSTZNVEV1TUN3aVpHVnNZWGxmTlNJNk5pNHdMQ0prWld4aGVWODJJam80TGpBc0ltUmxiR0Y1WDJOMWMzUnZiVjl6Ykdsa1pYSnpJam8yTGpBc0ltUmxiR0Y1WDJSbFptRjFiSFFpT2pJdU1Dd2laR1ZzWVhsZmJXVjBhRzlrSWpvaVEzVnpkRzl0SWl3aVpHVnNZWGxmY21GdVpHOXRYMjFoZUNJNk1pNHdMQ0prWld4aGVWOXlZVzVrYjIxZmJXbHVJam95TGpBc0ltWnliMjFmYkdsdGFYUWlPall3TGpBc0lteGxablJmYkdsdGFYUWlPall3TGpBc0lteHBiV2wwWDIxdlpHVWlPaUpUZEdGMGFXTWlMQ0p0WVhnaU9qQXVNQ3dpYldGNGFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXbHVJam93TGpBc0ltMXBibWx0ZFcxZmJHbHRhWFFpT2pZd0xqQXNJbTF2WkdVaU9pSlRkR0YwYVdNaUxDSnRiMlJsWDNKaGJtUnZiU0k2TkM0d0xDSnRiMlJsWDNScFkydHpJam8wTGpBc0ltMXZaR2xtYVdWeUlqb2lRbTlpY204aUxDSnRiMlJwWm1sbGNsOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk5TNHdMQ0p0YjJScFptbGxjbDl0YjJSbElqb2lRM1Z6ZEc5dElpd2liVzlrYVdacFpYSmZiMlptYzJWMElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTVNJNkxURXlMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1UY3VNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh6SWpvdE16a3VNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgwSWpvdE5URXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvME1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYellpT2pBdU1Dd2liMlptYzJWMElqb3dMakFzSW5KaGJtUnZiVjlqYUc5clpTSTZabUZzYzJVc0luSmhibVJ2YldsNlpTSTZkSEoxWlN3aWNtbG5hSFJmYkdsdGFYUWlPall3TGpBc0luTmlYM053WldWa0lqb3hMakFzSW5SdlgyeHBiV2wwSWpvMk1DNHdMQ0o1WVhjaU9pSkNZV05yZDJGeVpDSXNJbmxoZDE5c1pXWjBJam90TWpjdU1Dd2llV0YzWDIxdlpHVWlPaUpNTDFJaUxDSjVZWGRmY21sbmFIUWlPak00TGpCOWZTd2lVMjVsWVd0cGJtY2lPbnNpUTFRaU9uc2lZV3hzYjNkZmMzUmhkR1VpT25SeWRXVXNJbUp2WkhsZlpuSmxaWE4wWVc1a2FXNW5Jam9pVDJabUlpd2lZbTlrZVY5NVlYY2lPblJ5ZFdVc0ltSnZaSGxmZVdGM1gyOXdkR2x2Ym5NaU9sc2lTbWwwZEdWeUlpd2lmaUpkTENKamFHOXJaU0k2SWtOMWMzUnZiU0lzSW1Ob2IydGxNVjh4SWpvNExqQXNJbU5vYjJ0bE1WOHlJam94T0M0d0xDSmphRzlyWlRGZk15STZOeTR3TENKamFHOXJaVEZmTkNJNk1UY3VNQ3dpWTJodmEyVXhYelVpT2pndU1Dd2lZMmh2YTJVeFh6WWlPalV1TUN3aVkyaHZhMlZmWm5KdmJTSTZNVFl1TUN3aVkyaHZhMlZmYldWMGFHOWtJam9pUTNWemRHOXRJaXdpWTJodmEyVmZjMnhwWkdWeUlqb3hOaTR3TENKamFHOXJaVjl6Ykdsa1pYSnpJam8yTGpBc0ltTm9iMnRsWDNSdklqb3hOaTR3TENKa1pXeGhlU0k2ZEhKMVpTd2laR1ZzWVhsZk1TSTZNaTR3TENKa1pXeGhlVjh5SWpveUxqQXNJbVJsYkdGNVh6TWlPakl1TUN3aVpHVnNZWGxmTkNJNk1pNHdMQ0prWld4aGVWODFJam95TGpBc0ltUmxiR0Y1WHpZaU9qSXVNQ3dpWkdWc1lYbGZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpWkdWc1lYbGZaR1ZtWVhWc2RDSTZOeTR3TENKa1pXeGhlVjl0WlhSb2IyUWlPaUpEZFhOMGIyMGlMQ0prWld4aGVWOXlZVzVrYjIxZmJXRjRJam8yTGpBc0ltUmxiR0Y1WDNKaGJtUnZiVjl0YVc0aU9qVXVNQ3dpWm5KdmJWOXNhVzFwZENJNk5qQXVNQ3dpYkdWbWRGOXNhVzFwZENJNk5qQXVNQ3dpYkdsdGFYUmZiVzlrWlNJNklrWnliMjB2Vkc4aUxDSnRZWGdpT2pBdU1Dd2liV0Y0YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYldsdUlqb3RNVEF1TUN3aWJXbHVhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liVzlrWlNJNklsUnBZMnR6SWl3aWJXOWtaVjl5WVc1a2IyMGlPalF1TUN3aWJXOWtaVjkwYVdOcmN5STZNVEl1TUN3aWJXOWthV1pwWlhJaU9pSlRjR2x1SWl3aWJXOWthV1pwWlhKZlkzVnpkRzl0WDNOc2FXUmxjbk1pT2pZdU1Dd2liVzlrYVdacFpYSmZiVzlrWlNJNklrTjFjM1J2YlNJc0ltMXZaR2xtYVdWeVgyOW1abk5sZENJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TFRFMkxqQXNJbTltWm5ObGRDSTZNQzR3TENKeVlXNWtiMjFmWTJodmEyVWlPblJ5ZFdVc0luSmhibVJ2YldsNlpTSTZkSEoxWlN3aWNtbG5hSFJmYkdsdGFYUWlPall3TGpBc0luTmlYM053WldWa0lqb3hNUzR3TENKMGIxOXNhVzFwZENJNk5EZ3VNQ3dpZVdGM0lqb2lRbUZqYTNkaGNtUWlMQ0o1WVhkZmJHVm1kQ0k2TFRJeUxqQXNJbmxoZDE5dGIyUmxJam9pVEM5U0lpd2llV0YzWDNKcFoyaDBJam8wTkM0d2ZTd2lWQ0k2ZXlKaGJHeHZkMTl6ZEdGMFpTSTZkSEoxWlN3aVltOWtlVjltY21WbGMzUmhibVJwYm1jaU9pSlBabVlpTENKaWIyUjVYM2xoZHlJNmRISjFaU3dpWW05a2VWOTVZWGRmYjNCMGFXOXVjeUk2V3lKS2FYUjBaWElpTENKK0lsMHNJbU5vYjJ0bElqb2lRM1Z6ZEc5dElpd2lZMmh2YTJVeFh6RWlPamd1TUN3aVkyaHZhMlV4WHpJaU9qRTRMakFzSW1Ob2IydGxNVjh6SWpvM0xqQXNJbU5vYjJ0bE1WODBJam94Tnk0d0xDSmphRzlyWlRGZk5TSTZPQzR3TENKamFHOXJaVEZmTmlJNk5TNHdMQ0pqYUc5clpWOW1jbTl0SWpveE5pNHdMQ0pqYUc5clpWOXRaWFJvYjJRaU9pSkRkWE4wYjIwaUxDSmphRzlyWlY5emJHbGtaWElpT2pFMkxqQXNJbU5vYjJ0bFgzTnNhV1JsY25NaU9qWXVNQ3dpWTJodmEyVmZkRzhpT2pFMkxqQXNJbVJsYkdGNUlqcDBjblZsTENKa1pXeGhlVjh4SWpveUxqQXNJbVJsYkdGNVh6SWlPakl1TUN3aVpHVnNZWGxmTXlJNk1pNHdMQ0prWld4aGVWODBJam95TGpBc0ltUmxiR0Y1WHpVaU9qSXVNQ3dpWkdWc1lYbGZOaUk2TWk0d0xDSmtaV3hoZVY5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSmtaV3hoZVY5a1pXWmhkV3gwSWpvM0xqQXNJbVJsYkdGNVgyMWxkR2h2WkNJNklrTjFjM1J2YlNJc0ltUmxiR0Y1WDNKaGJtUnZiVjl0WVhnaU9qWXVNQ3dpWkdWc1lYbGZjbUZ1Wkc5dFgyMXBiaUk2TlM0d0xDSm1jbTl0WDJ4cGJXbDBJam8yTUM0d0xDSnNaV1owWDJ4cGJXbDBJam8yTUM0d0xDSnNhVzFwZEY5dGIyUmxJam9pUm5KdmJTOVVieUlzSW0xaGVDSTZNQzR3TENKdFlYaHBiWFZ0WDJ4cGJXbDBJam8yTUM0d0xDSnRhVzRpT2kweE1DNHdMQ0p0YVc1cGJYVnRYMnhwYldsMElqbzJNQzR3TENKdGIyUmxJam9pVkdsamEzTWlMQ0p0YjJSbFgzSmhibVJ2YlNJNk5DNHdMQ0p0YjJSbFgzUnBZMnR6SWpveE1pNHdMQ0p0YjJScFptbGxjaUk2SWxOd2FXNGlMQ0p0YjJScFptbGxjbDlqZFhOMGIyMWZjMnhwWkdWeWN5STZOaTR3TENKdGIyUnBabWxsY2w5dGIyUmxJam9pUTNWemRHOXRJaXdpYlc5a2FXWnBaWEpmYjJabWMyVjBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk1TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpJaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh6SWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOQ0k2TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6VWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4Mklqb3RNVFl1TUN3aWIyWm1jMlYwSWpvd0xqQXNJbkpoYm1SdmJWOWphRzlyWlNJNmRISjFaU3dpY21GdVpHOXRhWHBsSWpwMGNuVmxMQ0p5YVdkb2RGOXNhVzFwZENJNk5qQXVNQ3dpYzJKZmMzQmxaV1FpT2pFeExqQXNJblJ2WDJ4cGJXbDBJam8wT0M0d0xDSjVZWGNpT2lKQ1lXTnJkMkZ5WkNJc0lubGhkMTlzWldaMElqb3RNakl1TUN3aWVXRjNYMjF2WkdVaU9pSk1MMUlpTENKNVlYZGZjbWxuYUhRaU9qUTBMakI5ZlN3aVUzUmhibVJwYm1jaU9uc2lRMVFpT25zaVlXeHNiM2RmYzNSaGRHVWlPblJ5ZFdVc0ltSnZaSGxmWm5KbFpYTjBZVzVrYVc1bklqb2lUMlptSWl3aVltOWtlVjk1WVhjaU9uUnlkV1VzSW1KdlpIbGZlV0YzWDI5d2RHbHZibk1pT2xzaVNtbDBkR1Z5SWl3aWZpSmRMQ0pqYUc5clpTSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpURmZNU0k2TWk0d0xDSmphRzlyWlRGZk1pSTZNaTR3TENKamFHOXJaVEZmTXlJNk1pNHdMQ0pqYUc5clpURmZOQ0k2TWk0d0xDSmphRzlyWlRGZk5TSTZNaTR3TENKamFHOXJaVEZmTmlJNk1pNHdMQ0pqYUc5clpWOW1jbTl0SWpveE5pNHdMQ0pqYUc5clpWOXRaWFJvYjJRaU9pSkVaV1poZFd4MElpd2lZMmh2YTJWZmMyeHBaR1Z5SWpveE5pNHdMQ0pqYUc5clpWOXpiR2xrWlhKeklqb3lMakFzSW1Ob2IydGxYM1J2SWpveE5pNHdMQ0prWld4aGVTSTZabUZzYzJVc0ltUmxiR0Y1WHpFaU9qVXVNQ3dpWkdWc1lYbGZNaUk2TWk0d0xDSmtaV3hoZVY4eklqb3hNeTR3TENKa1pXeGhlVjgwSWpvNExqQXNJbVJsYkdGNVh6VWlPak11TUN3aVpHVnNZWGxmTmlJNk1pNHdMQ0prWld4aGVWOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk5TNHdMQ0prWld4aGVWOWtaV1poZFd4MElqb3lMakFzSW1SbGJHRjVYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0prWld4aGVWOXlZVzVrYjIxZmJXRjRJam95TGpBc0ltUmxiR0Y1WDNKaGJtUnZiVjl0YVc0aU9qSXVNQ3dpWm5KdmJWOXNhVzFwZENJNk5qQXVNQ3dpYkdWbWRGOXNhVzFwZENJNk5qQXVNQ3dpYkdsdGFYUmZiVzlrWlNJNklsTjBZWFJwWXlJc0ltMWhlQ0k2TUM0d0xDSnRZWGhwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YVc0aU9qQXVNQ3dpYldsdWFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXOWtaU0k2SWxOMFlYUnBZeUlzSW0xdlpHVmZjbUZ1Wkc5dElqbzBMakFzSW0xdlpHVmZkR2xqYTNNaU9qUXVNQ3dpYlc5a2FXWnBaWElpT2lJMUxWZGhlU0lzSW0xdlpHbG1hV1Z5WDJOMWMzUnZiVjl6Ykdsa1pYSnpJam95TGpBc0ltMXZaR2xtYVdWeVgyMXZaR1VpT2lKRVpXWmhkV3gwSWl3aWJXOWthV1pwWlhKZmIyWm1jMlYwSWpvMU1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qQXVNQ3dpY21GdVpHOXRYMk5vYjJ0bElqcG1ZV3h6WlN3aWNtRnVaRzl0YVhwbElqcG1ZV3h6WlN3aWNtbG5hSFJmYkdsdGFYUWlPall3TGpBc0luTmlYM053WldWa0lqb3hMakFzSW5SdlgyeHBiV2wwSWpvMk1DNHdMQ0o1WVhjaU9pSkNZV05yZDJGeVpDSXNJbmxoZDE5c1pXWjBJam90TWpJdU1Dd2llV0YzWDIxdlpHVWlPaUpNTDFJaUxDSjVZWGRmY21sbmFIUWlPalEyTGpCOUxDSlVJanA3SW1Gc2JHOTNYM04wWVhSbElqcDBjblZsTENKaWIyUjVYMlp5WldWemRHRnVaR2x1WnlJNklrOW1aaUlzSW1KdlpIbGZlV0YzSWpwMGNuVmxMQ0ppYjJSNVgzbGhkMTl2Y0hScGIyNXpJanBiSWtwcGRIUmxjaUlzSW40aVhTd2lZMmh2YTJVaU9pSkVaV1poZFd4MElpd2lZMmh2YTJVeFh6RWlPakl1TUN3aVkyaHZhMlV4WHpJaU9qSXVNQ3dpWTJodmEyVXhYek1pT2pJdU1Dd2lZMmh2YTJVeFh6UWlPakl1TUN3aVkyaHZhMlV4WHpVaU9qSXVNQ3dpWTJodmEyVXhYellpT2pJdU1Dd2lZMmh2YTJWZlpuSnZiU0k2TVRZdU1Dd2lZMmh2YTJWZmJXVjBhRzlrSWpvaVJHVm1ZWFZzZENJc0ltTm9iMnRsWDNOc2FXUmxjaUk2TVRZdU1Dd2lZMmh2YTJWZmMyeHBaR1Z5Y3lJNk1pNHdMQ0pqYUc5clpWOTBieUk2TVRZdU1Dd2laR1ZzWVhraU9tWmhiSE5sTENKa1pXeGhlVjh4SWpvMUxqQXNJbVJsYkdGNVh6SWlPakl1TUN3aVpHVnNZWGxmTXlJNk1UTXVNQ3dpWkdWc1lYbGZOQ0k2T0M0d0xDSmtaV3hoZVY4MUlqb3pMakFzSW1SbGJHRjVYellpT2pJdU1Dd2laR1ZzWVhsZlkzVnpkRzl0WDNOc2FXUmxjbk1pT2pVdU1Dd2laR1ZzWVhsZlpHVm1ZWFZzZENJNk1pNHdMQ0prWld4aGVWOXRaWFJvYjJRaU9pSkVaV1poZFd4MElpd2laR1ZzWVhsZmNtRnVaRzl0WDIxaGVDSTZNaTR3TENKa1pXeGhlVjl5WVc1a2IyMWZiV2x1SWpveUxqQXNJbVp5YjIxZmJHbHRhWFFpT2pZd0xqQXNJbXhsWm5SZmJHbHRhWFFpT2pZd0xqQXNJbXhwYldsMFgyMXZaR1VpT2lKVGRHRjBhV01pTENKdFlYZ2lPakF1TUN3aWJXRjRhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liV2x1SWpvd0xqQXNJbTFwYm1sdGRXMWZiR2x0YVhRaU9qWXdMakFzSW0xdlpHVWlPaUpUZEdGMGFXTWlMQ0p0YjJSbFgzSmhibVJ2YlNJNk5DNHdMQ0p0YjJSbFgzUnBZMnR6SWpvMExqQXNJbTF2WkdsbWFXVnlJam9pTlMxWFlYa2lMQ0p0YjJScFptbGxjbDlqZFhOMGIyMWZjMnhwWkdWeWN5STZNaTR3TENKdGIyUnBabWxsY2w5dGIyUmxJam9pUkdWbVlYVnNkQ0lzSW0xdlpHbG1hV1Z5WDI5bVpuTmxkQ0k2TlRBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHhJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk1pSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpNaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgwSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOU0k2TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6WWlPakF1TUN3aWIyWm1jMlYwSWpvd0xqQXNJbkpoYm1SdmJWOWphRzlyWlNJNlptRnNjMlVzSW5KaGJtUnZiV2w2WlNJNlptRnNjMlVzSW5KcFoyaDBYMnhwYldsMElqbzJNQzR3TENKellsOXpjR1ZsWkNJNk1TNHdMQ0owYjE5c2FXMXBkQ0k2TmpBdU1Dd2llV0YzSWpvaVFtRmphM2RoY21RaUxDSjVZWGRmYkdWbWRDSTZMVEl5TGpBc0lubGhkMTl0YjJSbElqb2lUQzlTSWl3aWVXRjNYM0pwWjJoMElqbzBOaTR3ZlgxOUxDSm1jbVZsYzNSaGJtUnBibWNpT25zaVltOWtlVjltY3lJNmRISjFaU3dpWkdsellXSnNaWEp6SWpwYkluNGlYU3dpY0hKbFptVnlYMjFoYm5WaGJDSTZkSEoxWlN3aWMzZHBkR05vSWpwbVlXeHpaU3dpZVdGM1gyMXZaQ0k2ZEhKMVpYMTlMQ0p0WVdsdUlqcDdJbUZrWkdsMGFXOXVZV3dpT25zaVltRmphM04wWVdJaU9uc2ljM2RwZEdOb0lqcDBjblZsZlN3aWJHVm5hWFJmWVdFaU9uc2laVzVoWW14bFpDSTZabUZzYzJVc0ltMXZaR1VpT2lKTWIyTmhiQ0JXYVdWM0luMHNJbTFoYm5WaGJGOTVZWGNpT25zaWFXNTJaWEowWlhJaU9uUnlkV1VzSW5ObGJHVmpkQ0k2SWtScGMyRmliR1ZrSWl3aWMzUmhkR2xqSWpwbVlXeHpaWDBzSW5OaFptVmZhR1ZoWkNJNmV5Sm9aV2xuYUhRaU9qVXdMakFzSW5OMFlYUmxjeUk2V3lKYVpYVnpJaXdpUzI1cFptVWlMQ0orSWwwc0luTjNhWFJqYUNJNmRISjFaWDBzSW5kaGNtMTFjRjloWVNJNmV5SnNaV1owWDNsaGR5STZMVE0xTGpBc0luQnBkR05vSWpvaVJHbHpZV0pzWldRaUxDSnlZVzVuWlNJNk16WXdMakFzSW5KcFoyaDBYM2xoZHlJNk5qY3VNQ3dpYzJWc1pXTjBJam9pUkdsellXSnNaV1FpTENKemNHVmxaQ0k2TVRJNExqQXNJbmxoZHlJNklsTndhVzRpZlgwc0ltTnZibVpwWjNWeVpTSTZleUp6ZEdGMFpTSTZPQzR3TENKMFpXRnRJam94TGpCOWZYMHNJbWx1Wm04aU9uc2libTkwYVdaNUlqcDdJbk53WVcwaU9tWmhiSE5sTENKemRIbHNaU0k2SWtOaGRDSjlMQ0p3Y21WelpYUnpJanA3SW14cGMzUWlPalV1TUN3aWJtRnRaU0k2SW01dloyRWlmU3dpYzJoaGNtVmtYMlpsWVhSMWNtVnpJanA3SW5OM2FYUmphQ0k2Wm1Gc2MyVjlMQ0p6YVdSbFltRnlJanA3SW1OdmJHOXlJanBiSWs5MWRIUmxjaUlzSWlNd01EQXdNREF3TUNJc0luNGlYU3dpYzNCbFpXUWlPalV1TUN3aWRHVjRkQ0k2SXRDejBMRFF0OUMrMEx2UXVOQzkwTEFnMFlIUXVOQzcwTEFpZlN3aWQyRjBaWEp0WVhKcklqcDdJbU52Ykc5eUlqcGJJa2x1Ym1WeUlpd2lJekF3TURBd01EQXdJaXdpZmlKZExDSm1iMjUwSWpvaVUyMWhiR3dpTENKbmNtRmthV1Z1ZENJNmRISjFaU3dpYlc5a1pTSTZXekV1TUN3eUxqQXNNeTR3TENKK0lsMHNJbTV2Ymw5bmNtRmthV1Z1ZENJNklpTkdSa1pHUmtaR1JpSXNJbk53WldWa0lqbzBMakFzSW5SbGVIUWlPaUpNVlVGVFJVNVRSU0JUVHlCQ1FVUWlmWDBzSW0xcGMyTWlPbnNpWVdsdFltOTBJanA3SW1aaGEyVmtkV05ySWpwN0ltWnlaV1Y2WlY5d1pYSnBiMlFpT25SeWRXVXNJblZ1Ykc5amF5STZkSEoxWlgwc0lteGhkR1Z1WTNraU9uc2ljM2RwZEdOb0lqcDBjblZsZlN3aWJHOW5aMmx1WnlJNmV5SmpiMnh2Y25NaU9uc2liV0ZwYmlJNklpTkdSVUpCUWtGR1JpSXNJbkJ5WldacGVDSTZJaU5HUkVKQlFrRkdSaUo5TENKdGIyUmxJanA3SW1selgyNXZkR2xtYVdOaGRHbHZiaUk2ZEhKMVpTd2ljMlZzWldOMElqcGJJa0ZwYldKdmRDSXNJbjRpWFgwc0luTjNhWFJqYUNJNmRISjFaWDE5TENKdGIzWmxiV1Z1ZENJNmV5SmhhWEpmWkhWamExOWpiMnhzYVhOcGIyNGlPbVpoYkhObExDSmxaR2RsWDNGMWFXTnJYM04wYjNBaU9tWmhiSE5sTENKbVlXeHNYMlJoYldGblpTSTZkSEoxWlN3aVptRnpkRjlzWVdSa1pYSWlPblJ5ZFdWOUxDSndiR0Y1WlhKZllXNXBiV0YwYVc5dWN5STZleUptWVd4c2FXNW5JanA3SW5aaGJIVmxJam93TGpCOUxDSnFhWFIwWlhKZmJHVm5jeUk2ZXlKbWNtOXRJam93TGpBc0luTjNhWFJqYUNJNmRISjFaU3dpZEc4aU9qVXdMakI5TENKc1pXRnVhVzVuSWpwN0luWmhiSFZsSWpveE1EQXVNSDE5ZlN3aWRtbHpkV0ZzY3lJNmV5SmhjM0JsWTNSZmNtRjBhVzhpT25zaWMzZHBkR05vSWpwMGNuVmxMQ0oyWVd4MVpTSTZNVE16TGpCOUxDSmtZVzFoWjJWZmFXNWthV05oZEc5eUlqcDdJbk4zYVhSamFDSTZabUZzYzJWOUxDSm1jSE5mWW05dmMzUWlPbnNpYzNkcGRHTm9JanBtWVd4elpYMHNJbWhwZEcxaGNtdGxjaUk2ZXlKamIyeHZjaUk2V3lJeVJDSXNJaU5HUmtaR1JrWkdSaUlzSW40aVhTd2ljMlZzWldOMElqcGJJbjRpWFN3aWRHbHRaU0k2TVRBdU1IMHNJbWx1WTNKbFlYTmxaRjltYkNJNmV5SnpkMmwwWTJnaU9tWmhiSE5sTENKMGFXTnJjeUk2TVRVdU1IMHNJbTFoYm5WaGJGOWhjbkp2ZDNNaU9uc2lZMjlzYjNJaU9pSWpSa1pHUmtaR1JrWWlMQ0ptYjI1MElqb2lSR1ZtWVhWc2RDSXNJbTltWm5ObGRDSTZNelV1TUN3aWMzZHBkR05vSWpwbVlXeHpaU3dpYzNsdFltOXNjeUk2ZXlKbWIzSjNZWEprSWpvaVhpSXNJbXhsWm5RaU9pSThJaXdpY21sbmFIUWlPaUkrSW4xOUxDSndiR0Y1WlhKZmRISmhibk53WVhKbGJtTjVJanA3SW5OM2FYUmphQ0k2ZEhKMVpYMHNJbkpsYlc5MlpWOXpiR1ZsZG1WeklqcDdJbk4zYVhSamFDSTZkSEoxWlgwc0luTmpiM0JsWDI5MlpYSnNZWGtpT25zaVlXNXBiV0YwYVc5dUlqcDBjblZsTENKamIyeHZjbk1pT25zaVpXUm5aU0k2SWlNd01EQXdNREF3TUNJc0ltMWhhVzRpT2lJak9FWTRSamhHUmtZaWZTd2laMkZ3SWpveE1DNHdMQ0pzWlc1bmRHZ2lPakU0TlM0d0xDSnZjSFJwYjI1eklqcGJJbjRpWFN3aWMzZHBkR05vSWpwMGNuVmxmU3dpYzJ0bFpYUmZhVzVrYVdOaGRHOXljeUk2ZXlKaWIyMWlJanAwY25WbExDSm1aV0YwZFhKbGN5STZXeUpHYjNKalpTQnpZV1psSUhCdmFXNTBJaXdpUm05eVkyVWdZbTlrZVNCaGFXMGlMQ0pRYVc1bklITndhV3RsSWl3aVJHOTFZbXhsSUhSaGNDSXNJa1IxWTJzZ2NHVmxheUJoYzNOcGMzUWlMQ0pHY21WbGMzUmhibVJwYm1jaUxDSlBiaUJ6YUc5MElHRnVkR2t0WVdsdElpd2lUV2x1YVcxMWJTQmtZVzFoWjJVZ2IzWmxjbkpwWkdVaUxDSitJbDBzSW5OM2FYUmphQ0k2Wm1Gc2MyVjlMQ0oyWld4dlkybDBlVjkzWVhKdWFXNW5JanA3SW1OdmJHOXlJam9pSTBaR1JrWkdSa1pHSWl3aWMzZHBkR05vSWpwbVlXeHpaWDBzSW5acFpYZHRiMlJsYkY5amFHRnVaMlZ5SWpwN0ltWnZkaUk2Tmpnd0xqQXNJbk4zYVhSamFDSTZkSEoxWlN3aWVDSTZMVFl1TUN3aWVTSTZMVGt1TUN3aWVpSTZNVEF1TUgxOWZRPT0iLCJ0aW1lIjoxNzQ3NTkyODQ4LjB9", 
        name = "BobrinayaNOGA \226\153\161"
    }, 
    [3] = {
        data = "eyJhdXRob3IiOiJub3BvaW50IiwiY29uZmlnIjoiZXlKaGJuUnBZV2x0SWpwN0ltRnVaMnhsY3lJNmV5SmhiblJwWDJKeWRYUmxabTl5WTJVaU9uc2liVzlrWlNJNklrMWxkR0VpTENKdWIzUnBabmtpT21aaGJITmxMQ0p6ZEdGMFpYTWlPbHNpVTNSaGJtUnBibWNpTENKU2RXNXVhVzVuSWl3aVUyeHZkMmx1WnlJc0lrTnliM1ZqYUdsdVp5SXNJbE51WldGcmFXNW5JaXdpUVdseUlpd2lRV2x5SUVOeWIzVmphR2x1WnlJc0lreGxaMmwwSUVGQklpd2lmaUpkTENKemQybDBZMmdpT25SeWRXVjlMQ0ppY21WaGExOXNZeUk2ZXlKa2FYTmhZbXhsWDI5dVgyZHlaVzVoWkdVaU9uUnlkV1VzSW1ocFpHVmZjMmh2ZEhNaU9pSkNjbVZoYXlCTVF5SXNJbk5sYkdWamRDSTZXeUpUZEdGdVpHbHVaeUlzSWxKMWJtNXBibWNpTENKVGJHOTNhVzVuSWl3aVEzSnZkV05vYVc1bklpd2lVMjVsWVd0cGJtY2lMQ0pCYVhJaUxDSkJhWElnUTNKdmRXTm9hVzVuSWl3aVRHVm5hWFFnUVVFaUxDSkdjbVZsYzNSaGJtUnBibWNpTENKK0lsMTlMQ0ppZFdsc1pHVnlJanA3SWtGcGNpSTZleUpEVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUkdWbVlYVnNkQ0lzSW1Ob2IydGxNVjh4SWpveUxqQXNJbU5vYjJ0bE1WOHlJam95TGpBc0ltTm9iMnRsTVY4eklqb3lMakFzSW1Ob2IydGxNVjgwSWpveUxqQXNJbU5vYjJ0bE1WODFJam95TGpBc0ltTm9iMnRsTVY4Mklqb3lMakFzSW1Ob2IydGxYMlp5YjIwaU9qRTJMakFzSW1Ob2IydGxYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpWOXpiR2xrWlhJaU9qRTJMakFzSW1Ob2IydGxYM05zYVdSbGNuTWlPakl1TUN3aVkyaHZhMlZmZEc4aU9qRTJMakFzSW1SbGJHRjVJanAwY25WbExDSmtaV3hoZVY4eElqb3lMakFzSW1SbGJHRjVYeklpT2pJdU1Dd2laR1ZzWVhsZk15STZNaTR3TENKa1pXeGhlVjgwSWpveUxqQXNJbVJsYkdGNVh6VWlPakl1TUN3aVpHVnNZWGxmTmlJNk1pNHdMQ0prWld4aGVWOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0prWld4aGVWOWtaV1poZFd4MElqbzNMakFzSW1SbGJHRjVYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0prWld4aGVWOXlZVzVrYjIxZmJXRjRJam95TGpBc0ltUmxiR0Y1WDNKaGJtUnZiVjl0YVc0aU9qSXVNQ3dpWm5KdmJWOXNhVzFwZENJNk5qQXVNQ3dpYkdWbWRGOXNhVzFwZENJNk5qQXVNQ3dpYkdsdGFYUmZiVzlrWlNJNklsTjBZWFJwWXlJc0ltMWhlQ0k2TUM0d0xDSnRZWGhwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YVc0aU9qQXVNQ3dpYldsdWFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXOWtaU0k2SWxOMFlYUnBZeUlzSW0xdlpHVmZjbUZ1Wkc5dElqbzBMakFzSW0xdlpHVmZkR2xqYTNNaU9qUXVNQ3dpYlc5a2FXWnBaWElpT2lKRWFYTmhZbXhsWkNJc0ltMXZaR2xtYVdWeVgyTjFjM1J2YlY5emJHbGtaWEp6SWpveUxqQXNJbTF2WkdsbWFXVnlYMjF2WkdVaU9pSkVaV1poZFd4MElpd2liVzlrYVdacFpYSmZiMlptYzJWMElqb3RNVE11TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpZaU9qQXVNQ3dpYjJabWMyVjBJam93TGpBc0luSmhibVJ2YlY5amFHOXJaU0k2Wm1Gc2MyVXNJbkpoYm1SdmJXbDZaU0k2Wm1Gc2MyVXNJbkpwWjJoMFgyeHBiV2wwSWpvMk1DNHdMQ0p6WWw5emNHVmxaQ0k2TVM0d0xDSjBiMTlzYVcxcGRDSTZOakF1TUN3aWVXRjNJam9pUW1GamEzZGhjbVFpTENKNVlYZGZiR1ZtZENJNkxUSXlMakFzSW5saGQxOXRiMlJsSWpvaVRDOVNJaXdpZVdGM1gzSnBaMmgwSWpvME1TNHdmU3dpVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUkdWbVlYVnNkQ0lzSW1Ob2IydGxNVjh4SWpveUxqQXNJbU5vYjJ0bE1WOHlJam95TGpBc0ltTm9iMnRsTVY4eklqb3lMakFzSW1Ob2IydGxNVjgwSWpveUxqQXNJbU5vYjJ0bE1WODFJam95TGpBc0ltTm9iMnRsTVY4Mklqb3lMakFzSW1Ob2IydGxYMlp5YjIwaU9qRTJMakFzSW1Ob2IydGxYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpWOXpiR2xrWlhJaU9qRTJMakFzSW1Ob2IydGxYM05zYVdSbGNuTWlPakl1TUN3aVkyaHZhMlZmZEc4aU9qRTJMakFzSW1SbGJHRjVJanAwY25WbExDSmtaV3hoZVY4eElqb3lMakFzSW1SbGJHRjVYeklpT2pJdU1Dd2laR1ZzWVhsZk15STZNaTR3TENKa1pXeGhlVjgwSWpveUxqQXNJbVJsYkdGNVh6VWlPakl1TUN3aVpHVnNZWGxmTmlJNk1pNHdMQ0prWld4aGVWOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0prWld4aGVWOWtaV1poZFd4MElqbzNMakFzSW1SbGJHRjVYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0prWld4aGVWOXlZVzVrYjIxZmJXRjRJam95TGpBc0ltUmxiR0Y1WDNKaGJtUnZiVjl0YVc0aU9qSXVNQ3dpWm5KdmJWOXNhVzFwZENJNk5qQXVNQ3dpYkdWbWRGOXNhVzFwZENJNk5qQXVNQ3dpYkdsdGFYUmZiVzlrWlNJNklsTjBZWFJwWXlJc0ltMWhlQ0k2TUM0d0xDSnRZWGhwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YVc0aU9qQXVNQ3dpYldsdWFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXOWtaU0k2SWxOMFlYUnBZeUlzSW0xdlpHVmZjbUZ1Wkc5dElqbzBMakFzSW0xdlpHVmZkR2xqYTNNaU9qUXVNQ3dpYlc5a2FXWnBaWElpT2lKRWFYTmhZbXhsWkNJc0ltMXZaR2xtYVdWeVgyTjFjM1J2YlY5emJHbGtaWEp6SWpveUxqQXNJbTF2WkdsbWFXVnlYMjF2WkdVaU9pSkVaV1poZFd4MElpd2liVzlrYVdacFpYSmZiMlptYzJWMElqb3RNVE11TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpZaU9qQXVNQ3dpYjJabWMyVjBJam93TGpBc0luSmhibVJ2YlY5amFHOXJaU0k2Wm1Gc2MyVXNJbkpoYm1SdmJXbDZaU0k2Wm1Gc2MyVXNJbkpwWjJoMFgyeHBiV2wwSWpvMk1DNHdMQ0p6WWw5emNHVmxaQ0k2TVM0d0xDSjBiMTlzYVcxcGRDSTZOakF1TUN3aWVXRjNJam9pUW1GamEzZGhjbVFpTENKNVlYZGZiR1ZtZENJNkxUSXlMakFzSW5saGQxOXRiMlJsSWpvaVRDOVNJaXdpZVdGM1gzSnBaMmgwSWpvME1TNHdmWDBzSWtGcGNpQkRjbTkxWTJocGJtY2lPbnNpUTFRaU9uc2lZV3hzYjNkZmMzUmhkR1VpT25SeWRXVXNJbUp2WkhsZlpuSmxaWE4wWVc1a2FXNW5Jam9pVDJabUlpd2lZbTlrZVY5NVlYY2lPblJ5ZFdVc0ltSnZaSGxmZVdGM1gyOXdkR2x2Ym5NaU9sc2lTbWwwZEdWeUlpd2lmaUpkTENKamFHOXJaU0k2SWtOMWMzUnZiU0lzSW1Ob2IydGxNVjh4SWpveE1DNHdMQ0pqYUc5clpURmZNaUk2TVRBdU1Dd2lZMmh2YTJVeFh6TWlPakU0TGpBc0ltTm9iMnRsTVY4MElqbzNMakFzSW1Ob2IydGxNVjgxSWpveE1DNHdMQ0pqYUc5clpURmZOaUk2TWpJdU1Dd2lZMmh2YTJWZlpuSnZiU0k2TVRZdU1Dd2lZMmh2YTJWZmJXVjBhRzlrSWpvaVEzVnpkRzl0SWl3aVkyaHZhMlZmYzJ4cFpHVnlJam94Tmk0d0xDSmphRzlyWlY5emJHbGtaWEp6SWpveUxqQXNJbU5vYjJ0bFgzUnZJam94TWk0d0xDSmtaV3hoZVNJNmRISjFaU3dpWkdWc1lYbGZNU0k2TWk0d0xDSmtaV3hoZVY4eUlqb3lMakFzSW1SbGJHRjVYek1pT2pJdU1Dd2laR1ZzWVhsZk5DSTZNaTR3TENKa1pXeGhlVjgxSWpveUxqQXNJbVJsYkdGNVh6WWlPakl1TUN3aVpHVnNZWGxmWTNWemRHOXRYM05zYVdSbGNuTWlPakl1TUN3aVpHVnNZWGxmWkdWbVlYVnNkQ0k2Tnk0d0xDSmtaV3hoZVY5dFpYUm9iMlFpT2lKU1lXNWtiMjBpTENKa1pXeGhlVjl5WVc1a2IyMWZiV0Y0SWpvNExqQXNJbVJsYkdGNVgzSmhibVJ2YlY5dGFXNGlPamN1TUN3aVpuSnZiVjlzYVcxcGRDSTZOakF1TUN3aWJHVm1kRjlzYVcxcGRDSTZOakF1TUN3aWJHbHRhWFJmYlc5a1pTSTZJa1p5YjIwdlZHOGlMQ0p0WVhnaU9pMHhNUzR3TENKdFlYaHBiWFZ0WDJ4cGJXbDBJam8yTUM0d0xDSnRhVzRpT2pBdU1Dd2liV2x1YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYlc5a1pTSTZJbFJwWTJ0eklpd2liVzlrWlY5eVlXNWtiMjBpT2pRdU1Dd2liVzlrWlY5MGFXTnJjeUk2TVRFdU1Dd2liVzlrYVdacFpYSWlPaUpUY0dsdUlpd2liVzlrYVdacFpYSmZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpYlc5a2FXWnBaWEpmYlc5a1pTSTZJa1JsWm1GMWJIUWlMQ0p0YjJScFptbGxjbDl2Wm1aelpYUWlPaTB4TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6RWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eUlqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTXlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelFpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODFJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5pSTZNQzR3TENKdlptWnpaWFFpT2pBdU1Dd2ljbUZ1Wkc5dFgyTm9iMnRsSWpwMGNuVmxMQ0p5WVc1a2IyMXBlbVVpT25SeWRXVXNJbkpwWjJoMFgyeHBiV2wwSWpvMk1DNHdMQ0p6WWw5emNHVmxaQ0k2TVM0d0xDSjBiMTlzYVcxcGRDSTZORGd1TUN3aWVXRjNJam9pUW1GamEzZGhjbVFpTENKNVlYZGZiR1ZtZENJNkxUSXlMakFzSW5saGQxOXRiMlJsSWpvaVRDOVNJaXdpZVdGM1gzSnBaMmgwSWpvME9TNHdmU3dpVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUTNWemRHOXRJaXdpWTJodmEyVXhYekVpT2pFd0xqQXNJbU5vYjJ0bE1WOHlJam94TUM0d0xDSmphRzlyWlRGZk15STZNVGd1TUN3aVkyaHZhMlV4WHpRaU9qY3VNQ3dpWTJodmEyVXhYelVpT2pFd0xqQXNJbU5vYjJ0bE1WODJJam95TWk0d0xDSmphRzlyWlY5bWNtOXRJam94Tmk0d0xDSmphRzlyWlY5dFpYUm9iMlFpT2lKRGRYTjBiMjBpTENKamFHOXJaVjl6Ykdsa1pYSWlPakUyTGpBc0ltTm9iMnRsWDNOc2FXUmxjbk1pT2pJdU1Dd2lZMmh2YTJWZmRHOGlPakV5TGpBc0ltUmxiR0Y1SWpwMGNuVmxMQ0prWld4aGVWOHhJam95TGpBc0ltUmxiR0Y1WHpJaU9qSXVNQ3dpWkdWc1lYbGZNeUk2TWk0d0xDSmtaV3hoZVY4MElqb3lMakFzSW1SbGJHRjVYelVpT2pJdU1Dd2laR1ZzWVhsZk5pSTZNaTR3TENKa1pXeGhlVjlqZFhOMGIyMWZjMnhwWkdWeWN5STZNaTR3TENKa1pXeGhlVjlrWldaaGRXeDBJam8zTGpBc0ltUmxiR0Y1WDIxbGRHaHZaQ0k2SWxKaGJtUnZiU0lzSW1SbGJHRjVYM0poYm1SdmJWOXRZWGdpT2pndU1Dd2laR1ZzWVhsZmNtRnVaRzl0WDIxcGJpSTZOeTR3TENKbWNtOXRYMnhwYldsMElqbzJNQzR3TENKc1pXWjBYMnhwYldsMElqbzJNQzR3TENKc2FXMXBkRjl0YjJSbElqb2lSbkp2YlM5VWJ5SXNJbTFoZUNJNkxURXhMakFzSW0xaGVHbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXBiaUk2TUM0d0xDSnRhVzVwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YjJSbElqb2lWR2xqYTNNaUxDSnRiMlJsWDNKaGJtUnZiU0k2TkM0d0xDSnRiMlJsWDNScFkydHpJam94TVM0d0xDSnRiMlJwWm1sbGNpSTZJbE53YVc0aUxDSnRiMlJwWm1sbGNsOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0p0YjJScFptbGxjbDl0YjJSbElqb2lSR1ZtWVhWc2RDSXNJbTF2WkdsbWFXVnlYMjltWm5ObGRDSTZMVEV3TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk1TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpJaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh6SWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOQ0k2TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6VWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4Mklqb3dMakFzSW05bVpuTmxkQ0k2TUM0d0xDSnlZVzVrYjIxZlkyaHZhMlVpT25SeWRXVXNJbkpoYm1SdmJXbDZaU0k2ZEhKMVpTd2ljbWxuYUhSZmJHbHRhWFFpT2pZd0xqQXNJbk5pWDNOd1pXVmtJam94TGpBc0luUnZYMnhwYldsMElqbzBPQzR3TENKNVlYY2lPaUpDWVdOcmQyRnlaQ0lzSW5saGQxOXNaV1owSWpvdE1qSXVNQ3dpZVdGM1gyMXZaR1VpT2lKTUwxSWlMQ0o1WVhkZmNtbG5hSFFpT2pRNUxqQjlmU3dpUTNKdmRXTm9hVzVuSWpwN0lrTlVJanA3SW1Gc2JHOTNYM04wWVhSbElqcDBjblZsTENKaWIyUjVYMlp5WldWemRHRnVaR2x1WnlJNklrOW1aaUlzSW1KdlpIbGZlV0YzSWpwMGNuVmxMQ0ppYjJSNVgzbGhkMTl2Y0hScGIyNXpJanBiSWtwcGRIUmxjaUlzSW40aVhTd2lZMmh2YTJVaU9pSkRkWE4wYjIwaUxDSmphRzlyWlRGZk1TSTZOaTR3TENKamFHOXJaVEZmTWlJNk1qSXVNQ3dpWTJodmEyVXhYek1pT2pRdU1Dd2lZMmh2YTJVeFh6UWlPakUwTGpBc0ltTm9iMnRsTVY4MUlqbzVMakFzSW1Ob2IydGxNVjgySWpvMExqQXNJbU5vYjJ0bFgyWnliMjBpT2pndU1Dd2lZMmh2YTJWZmJXVjBhRzlrSWpvaVEzVnpkRzl0SWl3aVkyaHZhMlZmYzJ4cFpHVnlJam94Tmk0d0xDSmphRzlyWlY5emJHbGtaWEp6SWpvMkxqQXNJbU5vYjJ0bFgzUnZJam95TWk0d0xDSmtaV3hoZVNJNmRISjFaU3dpWkdWc1lYbGZNU0k2TWk0d0xDSmtaV3hoZVY4eUlqb3lMakFzSW1SbGJHRjVYek1pT2pJdU1Dd2laR1ZzWVhsZk5DSTZNaTR3TENKa1pXeGhlVjgxSWpveUxqQXNJbVJsYkdGNVh6WWlPakl1TUN3aVpHVnNZWGxmWTNWemRHOXRYM05zYVdSbGNuTWlPakl1TUN3aVpHVnNZWGxmWkdWbVlYVnNkQ0k2T1M0d0xDSmtaV3hoZVY5dFpYUm9iMlFpT2lKRVpXWmhkV3gwSWl3aVpHVnNZWGxmY21GdVpHOXRYMjFoZUNJNk1UQXVNQ3dpWkdWc1lYbGZjbUZ1Wkc5dFgyMXBiaUk2TlM0d0xDSm1jbTl0WDJ4cGJXbDBJam8yTUM0d0xDSnNaV1owWDJ4cGJXbDBJam8yTUM0d0xDSnNhVzFwZEY5dGIyUmxJam9pVTNSaGRHbGpJaXdpYldGNElqb3dMakFzSW0xaGVHbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXBiaUk2TUM0d0xDSnRhVzVwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YjJSbElqb2lVM1JoZEdsaklpd2liVzlrWlY5eVlXNWtiMjBpT2pRdU1Dd2liVzlrWlY5MGFXTnJjeUk2TkM0d0xDSnRiMlJwWm1sbGNpSTZJbE53YVc0aUxDSnRiMlJwWm1sbGNsOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk15NHdMQ0p0YjJScFptbGxjbDl0YjJSbElqb2lRM1Z6ZEc5dElpd2liVzlrYVdacFpYSmZiMlptYzJWMElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTVNJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYeklpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHpJam90TVRVdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpZaU9qQXVNQ3dpYjJabWMyVjBJam93TGpBc0luSmhibVJ2YlY5amFHOXJaU0k2ZEhKMVpTd2ljbUZ1Wkc5dGFYcGxJanAwY25WbExDSnlhV2RvZEY5c2FXMXBkQ0k2TmpBdU1Dd2ljMkpmYzNCbFpXUWlPakV1TUN3aWRHOWZiR2x0YVhRaU9qWXdMakFzSW5saGR5STZJa0poWTJ0M1lYSmtJaXdpZVdGM1gyeGxablFpT2kweU55NHdMQ0o1WVhkZmJXOWtaU0k2SWt3dlVpSXNJbmxoZDE5eWFXZG9kQ0k2TkRBdU1IMHNJbFFpT25zaVlXeHNiM2RmYzNSaGRHVWlPblJ5ZFdVc0ltSnZaSGxmWm5KbFpYTjBZVzVrYVc1bklqb2lUMlptSWl3aVltOWtlVjk1WVhjaU9uUnlkV1VzSW1KdlpIbGZlV0YzWDI5d2RHbHZibk1pT2xzaVNtbDBkR1Z5SWl3aWZpSmRMQ0pqYUc5clpTSTZJa04xYzNSdmJTSXNJbU5vYjJ0bE1WOHhJam8yTGpBc0ltTm9iMnRsTVY4eUlqb3lNaTR3TENKamFHOXJaVEZmTXlJNk5DNHdMQ0pqYUc5clpURmZOQ0k2TVRRdU1Dd2lZMmh2YTJVeFh6VWlPamt1TUN3aVkyaHZhMlV4WHpZaU9qUXVNQ3dpWTJodmEyVmZabkp2YlNJNk9DNHdMQ0pqYUc5clpWOXRaWFJvYjJRaU9pSkRkWE4wYjIwaUxDSmphRzlyWlY5emJHbGtaWElpT2pFMkxqQXNJbU5vYjJ0bFgzTnNhV1JsY25NaU9qWXVNQ3dpWTJodmEyVmZkRzhpT2pJeUxqQXNJbVJsYkdGNUlqcDBjblZsTENKa1pXeGhlVjh4SWpveUxqQXNJbVJsYkdGNVh6SWlPakl1TUN3aVpHVnNZWGxmTXlJNk1pNHdMQ0prWld4aGVWODBJam95TGpBc0ltUmxiR0Y1WHpVaU9qSXVNQ3dpWkdWc1lYbGZOaUk2TWk0d0xDSmtaV3hoZVY5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSmtaV3hoZVY5a1pXWmhkV3gwSWpvNUxqQXNJbVJsYkdGNVgyMWxkR2h2WkNJNklrUmxabUYxYkhRaUxDSmtaV3hoZVY5eVlXNWtiMjFmYldGNElqb3hNQzR3TENKa1pXeGhlVjl5WVc1a2IyMWZiV2x1SWpvMUxqQXNJbVp5YjIxZmJHbHRhWFFpT2pZd0xqQXNJbXhsWm5SZmJHbHRhWFFpT2pZd0xqQXNJbXhwYldsMFgyMXZaR1VpT2lKVGRHRjBhV01pTENKdFlYZ2lPakF1TUN3aWJXRjRhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liV2x1SWpvd0xqQXNJbTFwYm1sdGRXMWZiR2x0YVhRaU9qWXdMakFzSW0xdlpHVWlPaUpUZEdGMGFXTWlMQ0p0YjJSbFgzSmhibVJ2YlNJNk5DNHdMQ0p0YjJSbFgzUnBZMnR6SWpvMExqQXNJbTF2WkdsbWFXVnlJam9pVTNCcGJpSXNJbTF2WkdsbWFXVnlYMk4xYzNSdmJWOXpiR2xrWlhKeklqb3pMakFzSW0xdlpHbG1hV1Z5WDIxdlpHVWlPaUpEZFhOMGIyMGlMQ0p0YjJScFptbGxjbDl2Wm1aelpYUWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2kweE5TNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelFpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODFJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5pSTZNQzR3TENKdlptWnpaWFFpT2pBdU1Dd2ljbUZ1Wkc5dFgyTm9iMnRsSWpwMGNuVmxMQ0p5WVc1a2IyMXBlbVVpT25SeWRXVXNJbkpwWjJoMFgyeHBiV2wwSWpvMk1DNHdMQ0p6WWw5emNHVmxaQ0k2TVM0d0xDSjBiMTlzYVcxcGRDSTZOakF1TUN3aWVXRjNJam9pUW1GamEzZGhjbVFpTENKNVlYZGZiR1ZtZENJNkxUSTNMakFzSW5saGQxOXRiMlJsSWpvaVRDOVNJaXdpZVdGM1gzSnBaMmgwSWpvME1DNHdmWDBzSWtaeVpXVnpkR0Z1WkdsdVp5STZleUpEVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUkdWbVlYVnNkQ0lzSW1Ob2IydGxNVjh4SWpveUxqQXNJbU5vYjJ0bE1WOHlJam95TGpBc0ltTm9iMnRsTVY4eklqb3lMakFzSW1Ob2IydGxNVjgwSWpveUxqQXNJbU5vYjJ0bE1WODFJam95TGpBc0ltTm9iMnRsTVY4Mklqb3lMakFzSW1Ob2IydGxYMlp5YjIwaU9qRTJMakFzSW1Ob2IydGxYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpWOXpiR2xrWlhJaU9qRTJMakFzSW1Ob2IydGxYM05zYVdSbGNuTWlPakl1TUN3aVkyaHZhMlZmZEc4aU9qRTJMakFzSW1SbGJHRjVJanBtWVd4elpTd2laR1ZzWVhsZk1TSTZNaTR3TENKa1pXeGhlVjh5SWpveUxqQXNJbVJsYkdGNVh6TWlPakl1TUN3aVpHVnNZWGxmTkNJNk1pNHdMQ0prWld4aGVWODFJam95TGpBc0ltUmxiR0Y1WHpZaU9qSXVNQ3dpWkdWc1lYbGZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpWkdWc1lYbGZaR1ZtWVhWc2RDSTZNaTR3TENKa1pXeGhlVjl0WlhSb2IyUWlPaUpFWldaaGRXeDBJaXdpWkdWc1lYbGZjbUZ1Wkc5dFgyMWhlQ0k2TWk0d0xDSmtaV3hoZVY5eVlXNWtiMjFmYldsdUlqb3lMakFzSW1aeWIyMWZiR2x0YVhRaU9qWXdMakFzSW14bFpuUmZiR2x0YVhRaU9qWXdMakFzSW14cGJXbDBYMjF2WkdVaU9pSlRkR0YwYVdNaUxDSnRZWGdpT2pBdU1Dd2liV0Y0YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYldsdUlqb3dMakFzSW0xcGJtbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXZaR1VpT2lKVGRHRjBhV01pTENKdGIyUmxYM0poYm1SdmJTSTZOQzR3TENKdGIyUmxYM1JwWTJ0eklqbzBMakFzSW0xdlpHbG1hV1Z5SWpvaVJHbHpZV0pzWldRaUxDSnRiMlJwWm1sbGNsOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0p0YjJScFptbGxjbDl0YjJSbElqb2lSR1ZtWVhWc2RDSXNJbTF2WkdsbWFXVnlYMjltWm5ObGRDSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpFaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh5SWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZNeUk2TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6UWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4MUlqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTmlJNk1DNHdMQ0p2Wm1aelpYUWlPakF1TUN3aWNtRnVaRzl0WDJOb2IydGxJanBtWVd4elpTd2ljbUZ1Wkc5dGFYcGxJanBtWVd4elpTd2ljbWxuYUhSZmJHbHRhWFFpT2pZd0xqQXNJbk5pWDNOd1pXVmtJam94TGpBc0luUnZYMnhwYldsMElqbzJNQzR3TENKNVlYY2lPaUpDWVdOcmQyRnlaQ0lzSW5saGQxOXNaV1owSWpvd0xqQXNJbmxoZDE5dGIyUmxJam9pVTI5c2J5SXNJbmxoZDE5eWFXZG9kQ0k2TUM0d2ZTd2lWQ0k2ZXlKaGJHeHZkMTl6ZEdGMFpTSTZkSEoxWlN3aVltOWtlVjltY21WbGMzUmhibVJwYm1jaU9pSlBabVlpTENKaWIyUjVYM2xoZHlJNmRISjFaU3dpWW05a2VWOTVZWGRmYjNCMGFXOXVjeUk2V3lKS2FYUjBaWElpTENKK0lsMHNJbU5vYjJ0bElqb2lSR1ZtWVhWc2RDSXNJbU5vYjJ0bE1WOHhJam95TGpBc0ltTm9iMnRsTVY4eUlqb3lMakFzSW1Ob2IydGxNVjh6SWpveUxqQXNJbU5vYjJ0bE1WODBJam95TGpBc0ltTm9iMnRsTVY4MUlqb3lMakFzSW1Ob2IydGxNVjgySWpveUxqQXNJbU5vYjJ0bFgyWnliMjBpT2pFMkxqQXNJbU5vYjJ0bFgyMWxkR2h2WkNJNklrUmxabUYxYkhRaUxDSmphRzlyWlY5emJHbGtaWElpT2pFMkxqQXNJbU5vYjJ0bFgzTnNhV1JsY25NaU9qSXVNQ3dpWTJodmEyVmZkRzhpT2pFMkxqQXNJbVJsYkdGNUlqcG1ZV3h6WlN3aVpHVnNZWGxmTVNJNk1pNHdMQ0prWld4aGVWOHlJam95TGpBc0ltUmxiR0Y1WHpNaU9qSXVNQ3dpWkdWc1lYbGZOQ0k2TWk0d0xDSmtaV3hoZVY4MUlqb3lMakFzSW1SbGJHRjVYellpT2pJdU1Dd2laR1ZzWVhsZlkzVnpkRzl0WDNOc2FXUmxjbk1pT2pJdU1Dd2laR1ZzWVhsZlpHVm1ZWFZzZENJNk1pNHdMQ0prWld4aGVWOXRaWFJvYjJRaU9pSkVaV1poZFd4MElpd2laR1ZzWVhsZmNtRnVaRzl0WDIxaGVDSTZNaTR3TENKa1pXeGhlVjl5WVc1a2IyMWZiV2x1SWpveUxqQXNJbVp5YjIxZmJHbHRhWFFpT2pZd0xqQXNJbXhsWm5SZmJHbHRhWFFpT2pZd0xqQXNJbXhwYldsMFgyMXZaR1VpT2lKVGRHRjBhV01pTENKdFlYZ2lPakF1TUN3aWJXRjRhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liV2x1SWpvd0xqQXNJbTFwYm1sdGRXMWZiR2x0YVhRaU9qWXdMakFzSW0xdlpHVWlPaUpUZEdGMGFXTWlMQ0p0YjJSbFgzSmhibVJ2YlNJNk5DNHdMQ0p0YjJSbFgzUnBZMnR6SWpvMExqQXNJbTF2WkdsbWFXVnlJam9pUkdsellXSnNaV1FpTENKdGIyUnBabWxsY2w5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSnRiMlJwWm1sbGNsOXRiMlJsSWpvaVJHVm1ZWFZzZENJc0ltMXZaR2xtYVdWeVgyOW1abk5sZENJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qQXVNQ3dpY21GdVpHOXRYMk5vYjJ0bElqcG1ZV3h6WlN3aWNtRnVaRzl0YVhwbElqcG1ZV3h6WlN3aWNtbG5hSFJmYkdsdGFYUWlPall3TGpBc0luTmlYM053WldWa0lqb3hMakFzSW5SdlgyeHBiV2wwSWpvMk1DNHdMQ0o1WVhjaU9pSkNZV05yZDJGeVpDSXNJbmxoZDE5c1pXWjBJam93TGpBc0lubGhkMTl0YjJSbElqb2lVMjlzYnlJc0lubGhkMTl5YVdkb2RDSTZNQzR3Zlgwc0lreGxaMmwwSUVGQklqcDdJa05VSWpwN0ltRnNiRzkzWDNOMFlYUmxJanAwY25WbExDSmliMlI1WDJaeVpXVnpkR0Z1WkdsdVp5STZJbEJsWldzZ1VtVmhiQ0lzSW1KdlpIbGZlV0YzSWpwMGNuVmxMQ0ppYjJSNVgzbGhkMTl2Y0hScGIyNXpJanBiSWtwcGRIUmxjaUlzSWxKaGJtUnZiV2w2WlNCS2FYUjBaWElpTENKQmJuUnBJRUp5ZFhSbFptOXlZMlVpTENKK0lsMHNJbU5vYjJ0bElqb2lSR1ZtWVhWc2RDSXNJbU5vYjJ0bE1WOHhJam95TGpBc0ltTm9iMnRsTVY4eUlqb3lMakFzSW1Ob2IydGxNVjh6SWpveUxqQXNJbU5vYjJ0bE1WODBJam95TGpBc0ltTm9iMnRsTVY4MUlqb3lMakFzSW1Ob2IydGxNVjgySWpveUxqQXNJbU5vYjJ0bFgyWnliMjBpT2pFMkxqQXNJbU5vYjJ0bFgyMWxkR2h2WkNJNklrUmxabUYxYkhRaUxDSmphRzlyWlY5emJHbGtaWElpT2pFMkxqQXNJbU5vYjJ0bFgzTnNhV1JsY25NaU9qSXVNQ3dpWTJodmEyVmZkRzhpT2pFMkxqQXNJbVJsYkdGNUlqcDBjblZsTENKa1pXeGhlVjh4SWpveUxqQXNJbVJsYkdGNVh6SWlPakl1TUN3aVpHVnNZWGxmTXlJNk1pNHdMQ0prWld4aGVWODBJam95TGpBc0ltUmxiR0Y1WHpVaU9qSXVNQ3dpWkdWc1lYbGZOaUk2TWk0d0xDSmtaV3hoZVY5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSmtaV3hoZVY5a1pXWmhkV3gwSWpveUxqQXNJbVJsYkdGNVgyMWxkR2h2WkNJNklsSmhibVJ2YlNJc0ltUmxiR0Y1WDNKaGJtUnZiVjl0WVhnaU9qSXVNQ3dpWkdWc1lYbGZjbUZ1Wkc5dFgyMXBiaUk2TWk0d0xDSm1jbTl0WDJ4cGJXbDBJam8yTUM0d0xDSnNaV1owWDJ4cGJXbDBJam8yTUM0d0xDSnNhVzFwZEY5dGIyUmxJam9pUm5KdmJTOVVieUlzSW0xaGVDSTZNQzR3TENKdFlYaHBiWFZ0WDJ4cGJXbDBJam8yTUM0d0xDSnRhVzRpT2pBdU1Dd2liV2x1YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYlc5a1pTSTZJbE4wWVhScFl5SXNJbTF2WkdWZmNtRnVaRzl0SWpvMExqQXNJbTF2WkdWZmRHbGphM01pT2pRdU1Dd2liVzlrYVdacFpYSWlPaUpDYjJKeWJ5SXNJbTF2WkdsbWFXVnlYMk4xYzNSdmJWOXpiR2xrWlhKeklqb3lMakFzSW0xdlpHbG1hV1Z5WDIxdlpHVWlPaUpFWldaaGRXeDBJaXdpYlc5a2FXWnBaWEpmYjJabWMyVjBJam90TlM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6RWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eUlqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTXlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelFpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODFJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5pSTZNQzR3TENKdlptWnpaWFFpT2pFNE1DNHdMQ0p5WVc1a2IyMWZZMmh2YTJVaU9tWmhiSE5sTENKeVlXNWtiMjFwZW1VaU9tWmhiSE5sTENKeWFXZG9kRjlzYVcxcGRDSTZOakF1TUN3aWMySmZjM0JsWldRaU9qRXVNQ3dpZEc5ZmJHbHRhWFFpT2pZd0xqQXNJbmxoZHlJNklrSmhZMnQzWVhKa0lpd2llV0YzWDJ4bFpuUWlPakF1TUN3aWVXRjNYMjF2WkdVaU9pSlRiMnh2SWl3aWVXRjNYM0pwWjJoMElqb3dMakI5TENKVUlqcDdJbUZzYkc5M1gzTjBZWFJsSWpwMGNuVmxMQ0ppYjJSNVgyWnlaV1Z6ZEdGdVpHbHVaeUk2SWxCbFpXc2dVbVZoYkNJc0ltSnZaSGxmZVdGM0lqcDBjblZsTENKaWIyUjVYM2xoZDE5dmNIUnBiMjV6SWpwYklrcHBkSFJsY2lJc0lsSmhibVJ2YldsNlpTQkthWFIwWlhJaUxDSkJiblJwSUVKeWRYUmxabTl5WTJVaUxDSitJbDBzSW1Ob2IydGxJam9pUkdWbVlYVnNkQ0lzSW1Ob2IydGxNVjh4SWpveUxqQXNJbU5vYjJ0bE1WOHlJam95TGpBc0ltTm9iMnRsTVY4eklqb3lMakFzSW1Ob2IydGxNVjgwSWpveUxqQXNJbU5vYjJ0bE1WODFJam95TGpBc0ltTm9iMnRsTVY4Mklqb3lMakFzSW1Ob2IydGxYMlp5YjIwaU9qRTJMakFzSW1Ob2IydGxYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpWOXpiR2xrWlhJaU9qRTJMakFzSW1Ob2IydGxYM05zYVdSbGNuTWlPakl1TUN3aVkyaHZhMlZmZEc4aU9qRTJMakFzSW1SbGJHRjVJanAwY25WbExDSmtaV3hoZVY4eElqb3lMakFzSW1SbGJHRjVYeklpT2pJdU1Dd2laR1ZzWVhsZk15STZNaTR3TENKa1pXeGhlVjgwSWpveUxqQXNJbVJsYkdGNVh6VWlPakl1TUN3aVpHVnNZWGxmTmlJNk1pNHdMQ0prWld4aGVWOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk1pNHdMQ0prWld4aGVWOWtaV1poZFd4MElqb3lMakFzSW1SbGJHRjVYMjFsZEdodlpDSTZJbEpoYm1SdmJTSXNJbVJsYkdGNVgzSmhibVJ2YlY5dFlYZ2lPakl1TUN3aVpHVnNZWGxmY21GdVpHOXRYMjFwYmlJNk1pNHdMQ0ptY205dFgyeHBiV2wwSWpvMk1DNHdMQ0pzWldaMFgyeHBiV2wwSWpvMk1DNHdMQ0pzYVcxcGRGOXRiMlJsSWpvaVJuSnZiUzlVYnlJc0ltMWhlQ0k2TUM0d0xDSnRZWGhwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YVc0aU9qQXVNQ3dpYldsdWFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXOWtaU0k2SWxOMFlYUnBZeUlzSW0xdlpHVmZjbUZ1Wkc5dElqbzBMakFzSW0xdlpHVmZkR2xqYTNNaU9qUXVNQ3dpYlc5a2FXWnBaWElpT2lKQ2IySnlieUlzSW0xdlpHbG1hV1Z5WDJOMWMzUnZiVjl6Ykdsa1pYSnpJam95TGpBc0ltMXZaR2xtYVdWeVgyMXZaR1VpT2lKRVpXWmhkV3gwSWl3aWJXOWthV1pwWlhKZmIyWm1jMlYwSWpvdE5TNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qRTRNQzR3TENKeVlXNWtiMjFmWTJodmEyVWlPbVpoYkhObExDSnlZVzVrYjIxcGVtVWlPbVpoYkhObExDSnlhV2RvZEY5c2FXMXBkQ0k2TmpBdU1Dd2ljMkpmYzNCbFpXUWlPakV1TUN3aWRHOWZiR2x0YVhRaU9qWXdMakFzSW5saGR5STZJa0poWTJ0M1lYSmtJaXdpZVdGM1gyeGxablFpT2pBdU1Dd2llV0YzWDIxdlpHVWlPaUpUYjJ4dklpd2llV0YzWDNKcFoyaDBJam93TGpCOWZTd2lVblZ1Ym1sdVp5STZleUpEVkNJNmV5SmhiR3h2ZDE5emRHRjBaU0k2ZEhKMVpTd2lZbTlrZVY5bWNtVmxjM1JoYm1ScGJtY2lPaUpQWm1ZaUxDSmliMlI1WDNsaGR5STZkSEoxWlN3aVltOWtlVjk1WVhkZmIzQjBhVzl1Y3lJNld5SkthWFIwWlhJaUxDSitJbDBzSW1Ob2IydGxJam9pUTNWemRHOXRJaXdpWTJodmEyVXhYekVpT2pndU1Dd2lZMmh2YTJVeFh6SWlPakl5TGpBc0ltTm9iMnRsTVY4eklqb3hNQzR3TENKamFHOXJaVEZmTkNJNk1pNHdMQ0pqYUc5clpURmZOU0k2TlM0d0xDSmphRzlyWlRGZk5pSTZNVFV1TUN3aVkyaHZhMlZmWm5KdmJTSTZNVFl1TUN3aVkyaHZhMlZmYldWMGFHOWtJam9pUTNWemRHOXRJaXdpWTJodmEyVmZjMnhwWkdWeUlqb3hOaTR3TENKamFHOXJaVjl6Ykdsa1pYSnpJam8yTGpBc0ltTm9iMnRsWDNSdklqb3hOaTR3TENKa1pXeGhlU0k2ZEhKMVpTd2laR1ZzWVhsZk1TSTZNaTR3TENKa1pXeGhlVjh5SWpveUxqQXNJbVJsYkdGNVh6TWlPakl1TUN3aVpHVnNZWGxmTkNJNk1pNHdMQ0prWld4aGVWODFJam95TGpBc0ltUmxiR0Y1WHpZaU9qSXVNQ3dpWkdWc1lYbGZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpWkdWc1lYbGZaR1ZtWVhWc2RDSTZPQzR3TENKa1pXeGhlVjl0WlhSb2IyUWlPaUpFWldaaGRXeDBJaXdpWkdWc1lYbGZjbUZ1Wkc5dFgyMWhlQ0k2TWk0d0xDSmtaV3hoZVY5eVlXNWtiMjFmYldsdUlqb3lMakFzSW1aeWIyMWZiR2x0YVhRaU9qWXdMakFzSW14bFpuUmZiR2x0YVhRaU9qWXdMakFzSW14cGJXbDBYMjF2WkdVaU9pSlRkR0YwYVdNaUxDSnRZWGdpT2pBdU1Dd2liV0Y0YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYldsdUlqb3dMakFzSW0xcGJtbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXZaR1VpT2lKVGRHRjBhV01pTENKdGIyUmxYM0poYm1SdmJTSTZOQzR3TENKdGIyUmxYM1JwWTJ0eklqbzBMakFzSW0xdlpHbG1hV1Z5SWpvaVFtOWljbThpTENKdGIyUnBabWxsY2w5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSnRiMlJwWm1sbGNsOXRiMlJsSWpvaVJHVm1ZWFZzZENJc0ltMXZaR2xtYVdWeVgyOW1abk5sZENJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qQXVNQ3dpY21GdVpHOXRYMk5vYjJ0bElqcDBjblZsTENKeVlXNWtiMjFwZW1VaU9tWmhiSE5sTENKeWFXZG9kRjlzYVcxcGRDSTZOakF1TUN3aWMySmZjM0JsWldRaU9qRXVNQ3dpZEc5ZmJHbHRhWFFpT2pZd0xqQXNJbmxoZHlJNklrSmhZMnQzWVhKa0lpd2llV0YzWDJ4bFpuUWlPaTB5Tmk0d0xDSjVZWGRmYlc5a1pTSTZJa3d2VWlJc0lubGhkMTl5YVdkb2RDSTZOREV1TUgwc0lsUWlPbnNpWVd4c2IzZGZjM1JoZEdVaU9uUnlkV1VzSW1KdlpIbGZabkpsWlhOMFlXNWthVzVuSWpvaVQyWm1JaXdpWW05a2VWOTVZWGNpT25SeWRXVXNJbUp2WkhsZmVXRjNYMjl3ZEdsdmJuTWlPbHNpU21sMGRHVnlJaXdpZmlKZExDSmphRzlyWlNJNklrTjFjM1J2YlNJc0ltTm9iMnRsTVY4eElqbzRMakFzSW1Ob2IydGxNVjh5SWpveU1pNHdMQ0pqYUc5clpURmZNeUk2TVRBdU1Dd2lZMmh2YTJVeFh6UWlPakl1TUN3aVkyaHZhMlV4WHpVaU9qVXVNQ3dpWTJodmEyVXhYellpT2pFMUxqQXNJbU5vYjJ0bFgyWnliMjBpT2pFMkxqQXNJbU5vYjJ0bFgyMWxkR2h2WkNJNklrTjFjM1J2YlNJc0ltTm9iMnRsWDNOc2FXUmxjaUk2TVRZdU1Dd2lZMmh2YTJWZmMyeHBaR1Z5Y3lJNk5pNHdMQ0pqYUc5clpWOTBieUk2TVRZdU1Dd2laR1ZzWVhraU9uUnlkV1VzSW1SbGJHRjVYekVpT2pJdU1Dd2laR1ZzWVhsZk1pSTZNaTR3TENKa1pXeGhlVjh6SWpveUxqQXNJbVJsYkdGNVh6UWlPakl1TUN3aVpHVnNZWGxmTlNJNk1pNHdMQ0prWld4aGVWODJJam95TGpBc0ltUmxiR0Y1WDJOMWMzUnZiVjl6Ykdsa1pYSnpJam95TGpBc0ltUmxiR0Y1WDJSbFptRjFiSFFpT2pndU1Dd2laR1ZzWVhsZmJXVjBhRzlrSWpvaVJHVm1ZWFZzZENJc0ltUmxiR0Y1WDNKaGJtUnZiVjl0WVhnaU9qSXVNQ3dpWkdWc1lYbGZjbUZ1Wkc5dFgyMXBiaUk2TWk0d0xDSm1jbTl0WDJ4cGJXbDBJam8yTUM0d0xDSnNaV1owWDJ4cGJXbDBJam8yTUM0d0xDSnNhVzFwZEY5dGIyUmxJam9pVTNSaGRHbGpJaXdpYldGNElqb3dMakFzSW0xaGVHbHRkVzFmYkdsdGFYUWlPall3TGpBc0ltMXBiaUk2TUM0d0xDSnRhVzVwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YjJSbElqb2lVM1JoZEdsaklpd2liVzlrWlY5eVlXNWtiMjBpT2pRdU1Dd2liVzlrWlY5MGFXTnJjeUk2TkM0d0xDSnRiMlJwWm1sbGNpSTZJa0p2WW5Kdklpd2liVzlrYVdacFpYSmZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpYlc5a2FXWnBaWEpmYlc5a1pTSTZJa1JsWm1GMWJIUWlMQ0p0YjJScFptbGxjbDl2Wm1aelpYUWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4eElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxODBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk5TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpZaU9qQXVNQ3dpYjJabWMyVjBJam93TGpBc0luSmhibVJ2YlY5amFHOXJaU0k2ZEhKMVpTd2ljbUZ1Wkc5dGFYcGxJanBtWVd4elpTd2ljbWxuYUhSZmJHbHRhWFFpT2pZd0xqQXNJbk5pWDNOd1pXVmtJam94TGpBc0luUnZYMnhwYldsMElqbzJNQzR3TENKNVlYY2lPaUpDWVdOcmQyRnlaQ0lzSW5saGQxOXNaV1owSWpvdE1qWXVNQ3dpZVdGM1gyMXZaR1VpT2lKTUwxSWlMQ0o1WVhkZmNtbG5hSFFpT2pReExqQjlmU3dpVTJ4dmQybHVaeUk2ZXlKRFZDSTZleUpoYkd4dmQxOXpkR0YwWlNJNmRISjFaU3dpWW05a2VWOW1jbVZsYzNSaGJtUnBibWNpT2lKUFptWWlMQ0ppYjJSNVgzbGhkeUk2ZEhKMVpTd2lZbTlrZVY5NVlYZGZiM0IwYVc5dWN5STZXeUpLYVhSMFpYSWlMQ0orSWwwc0ltTm9iMnRsSWpvaVJHVm1ZWFZzZENJc0ltTm9iMnRsTVY4eElqb3lMakFzSW1Ob2IydGxNVjh5SWpveUxqQXNJbU5vYjJ0bE1WOHpJam95TGpBc0ltTm9iMnRsTVY4MElqb3lMakFzSW1Ob2IydGxNVjgxSWpveUxqQXNJbU5vYjJ0bE1WODJJam95TGpBc0ltTm9iMnRsWDJaeWIyMGlPakUyTGpBc0ltTm9iMnRsWDIxbGRHaHZaQ0k2SWtSbFptRjFiSFFpTENKamFHOXJaVjl6Ykdsa1pYSWlPakUyTGpBc0ltTm9iMnRsWDNOc2FXUmxjbk1pT2pJdU1Dd2lZMmh2YTJWZmRHOGlPakUyTGpBc0ltUmxiR0Y1SWpwMGNuVmxMQ0prWld4aGVWOHhJam96TGpBc0ltUmxiR0Y1WHpJaU9qY3VNQ3dpWkdWc1lYbGZNeUk2TWk0d0xDSmtaV3hoZVY4MElqb3hNUzR3TENKa1pXeGhlVjgxSWpvMkxqQXNJbVJsYkdGNVh6WWlPamd1TUN3aVpHVnNZWGxmWTNWemRHOXRYM05zYVdSbGNuTWlPall1TUN3aVpHVnNZWGxmWkdWbVlYVnNkQ0k2TWk0d0xDSmtaV3hoZVY5dFpYUm9iMlFpT2lKRGRYTjBiMjBpTENKa1pXeGhlVjl5WVc1a2IyMWZiV0Y0SWpveUxqQXNJbVJsYkdGNVgzSmhibVJ2YlY5dGFXNGlPakl1TUN3aVpuSnZiVjlzYVcxcGRDSTZOakF1TUN3aWJHVm1kRjlzYVcxcGRDSTZOakF1TUN3aWJHbHRhWFJmYlc5a1pTSTZJbE4wWVhScFl5SXNJbTFoZUNJNk1DNHdMQ0p0WVhocGJYVnRYMnhwYldsMElqbzJNQzR3TENKdGFXNGlPakF1TUN3aWJXbHVhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liVzlrWlNJNklsTjBZWFJwWXlJc0ltMXZaR1ZmY21GdVpHOXRJam8wTGpBc0ltMXZaR1ZmZEdsamEzTWlPalF1TUN3aWJXOWthV1pwWlhJaU9pSkNiMkp5YnlJc0ltMXZaR2xtYVdWeVgyTjFjM1J2YlY5emJHbGtaWEp6SWpvMUxqQXNJbTF2WkdsbWFXVnlYMjF2WkdVaU9pSkRkWE4wYjIwaUxDSnRiMlJwWm1sbGNsOXZabVp6WlhRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh4SWpvdE1USXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh5SWpveE55NHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYek1pT2kwek9TNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelFpT2kwMU1TNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYelVpT2pRd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qQXVNQ3dpY21GdVpHOXRYMk5vYjJ0bElqcG1ZV3h6WlN3aWNtRnVaRzl0YVhwbElqcDBjblZsTENKeWFXZG9kRjlzYVcxcGRDSTZOakF1TUN3aWMySmZjM0JsWldRaU9qRXVNQ3dpZEc5ZmJHbHRhWFFpT2pZd0xqQXNJbmxoZHlJNklrSmhZMnQzWVhKa0lpd2llV0YzWDJ4bFpuUWlPaTB5Tnk0d0xDSjVZWGRmYlc5a1pTSTZJa3d2VWlJc0lubGhkMTl5YVdkb2RDSTZNemd1TUgwc0lsUWlPbnNpWVd4c2IzZGZjM1JoZEdVaU9uUnlkV1VzSW1KdlpIbGZabkpsWlhOMFlXNWthVzVuSWpvaVQyWm1JaXdpWW05a2VWOTVZWGNpT25SeWRXVXNJbUp2WkhsZmVXRjNYMjl3ZEdsdmJuTWlPbHNpU21sMGRHVnlJaXdpZmlKZExDSmphRzlyWlNJNklrUmxabUYxYkhRaUxDSmphRzlyWlRGZk1TSTZNaTR3TENKamFHOXJaVEZmTWlJNk1pNHdMQ0pqYUc5clpURmZNeUk2TWk0d0xDSmphRzlyWlRGZk5DSTZNaTR3TENKamFHOXJaVEZmTlNJNk1pNHdMQ0pqYUc5clpURmZOaUk2TWk0d0xDSmphRzlyWlY5bWNtOXRJam94Tmk0d0xDSmphRzlyWlY5dFpYUm9iMlFpT2lKRVpXWmhkV3gwSWl3aVkyaHZhMlZmYzJ4cFpHVnlJam94Tmk0d0xDSmphRzlyWlY5emJHbGtaWEp6SWpveUxqQXNJbU5vYjJ0bFgzUnZJam94Tmk0d0xDSmtaV3hoZVNJNmRISjFaU3dpWkdWc1lYbGZNU0k2TXk0d0xDSmtaV3hoZVY4eUlqbzNMakFzSW1SbGJHRjVYek1pT2pJdU1Dd2laR1ZzWVhsZk5DSTZNVEV1TUN3aVpHVnNZWGxmTlNJNk5pNHdMQ0prWld4aGVWODJJam80TGpBc0ltUmxiR0Y1WDJOMWMzUnZiVjl6Ykdsa1pYSnpJam8yTGpBc0ltUmxiR0Y1WDJSbFptRjFiSFFpT2pJdU1Dd2laR1ZzWVhsZmJXVjBhRzlrSWpvaVEzVnpkRzl0SWl3aVpHVnNZWGxmY21GdVpHOXRYMjFoZUNJNk1pNHdMQ0prWld4aGVWOXlZVzVrYjIxZmJXbHVJam95TGpBc0ltWnliMjFmYkdsdGFYUWlPall3TGpBc0lteGxablJmYkdsdGFYUWlPall3TGpBc0lteHBiV2wwWDIxdlpHVWlPaUpUZEdGMGFXTWlMQ0p0WVhnaU9qQXVNQ3dpYldGNGFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXbHVJam93TGpBc0ltMXBibWx0ZFcxZmJHbHRhWFFpT2pZd0xqQXNJbTF2WkdVaU9pSlRkR0YwYVdNaUxDSnRiMlJsWDNKaGJtUnZiU0k2TkM0d0xDSnRiMlJsWDNScFkydHpJam8wTGpBc0ltMXZaR2xtYVdWeUlqb2lRbTlpY204aUxDSnRiMlJwWm1sbGNsOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk5TNHdMQ0p0YjJScFptbGxjbDl0YjJSbElqb2lRM1Z6ZEc5dElpd2liVzlrYVdacFpYSmZiMlptYzJWMElqb3dMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTVNJNkxURXlMakFzSW0xdlpHbG1hV1Z5WDNOc2FXUmxjbk5mTWlJNk1UY3VNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh6SWpvdE16a3VNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgwSWpvdE5URXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvME1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYellpT2pBdU1Dd2liMlptYzJWMElqb3dMakFzSW5KaGJtUnZiVjlqYUc5clpTSTZabUZzYzJVc0luSmhibVJ2YldsNlpTSTZkSEoxWlN3aWNtbG5hSFJmYkdsdGFYUWlPall3TGpBc0luTmlYM053WldWa0lqb3hMakFzSW5SdlgyeHBiV2wwSWpvMk1DNHdMQ0o1WVhjaU9pSkNZV05yZDJGeVpDSXNJbmxoZDE5c1pXWjBJam90TWpjdU1Dd2llV0YzWDIxdlpHVWlPaUpNTDFJaUxDSjVZWGRmY21sbmFIUWlPak00TGpCOWZTd2lVMjVsWVd0cGJtY2lPbnNpUTFRaU9uc2lZV3hzYjNkZmMzUmhkR1VpT25SeWRXVXNJbUp2WkhsZlpuSmxaWE4wWVc1a2FXNW5Jam9pVDJabUlpd2lZbTlrZVY5NVlYY2lPblJ5ZFdVc0ltSnZaSGxmZVdGM1gyOXdkR2x2Ym5NaU9sc2lTbWwwZEdWeUlpd2lmaUpkTENKamFHOXJaU0k2SWtOMWMzUnZiU0lzSW1Ob2IydGxNVjh4SWpvNExqQXNJbU5vYjJ0bE1WOHlJam94T0M0d0xDSmphRzlyWlRGZk15STZOeTR3TENKamFHOXJaVEZmTkNJNk1UY3VNQ3dpWTJodmEyVXhYelVpT2pndU1Dd2lZMmh2YTJVeFh6WWlPalV1TUN3aVkyaHZhMlZmWm5KdmJTSTZNVFl1TUN3aVkyaHZhMlZmYldWMGFHOWtJam9pUTNWemRHOXRJaXdpWTJodmEyVmZjMnhwWkdWeUlqb3hOaTR3TENKamFHOXJaVjl6Ykdsa1pYSnpJam8yTGpBc0ltTm9iMnRsWDNSdklqb3hOaTR3TENKa1pXeGhlU0k2ZEhKMVpTd2laR1ZzWVhsZk1TSTZNaTR3TENKa1pXeGhlVjh5SWpveUxqQXNJbVJsYkdGNVh6TWlPakl1TUN3aVpHVnNZWGxmTkNJNk1pNHdMQ0prWld4aGVWODFJam95TGpBc0ltUmxiR0Y1WHpZaU9qSXVNQ3dpWkdWc1lYbGZZM1Z6ZEc5dFgzTnNhV1JsY25NaU9qSXVNQ3dpWkdWc1lYbGZaR1ZtWVhWc2RDSTZOeTR3TENKa1pXeGhlVjl0WlhSb2IyUWlPaUpEZFhOMGIyMGlMQ0prWld4aGVWOXlZVzVrYjIxZmJXRjRJam8yTGpBc0ltUmxiR0Y1WDNKaGJtUnZiVjl0YVc0aU9qVXVNQ3dpWm5KdmJWOXNhVzFwZENJNk5qQXVNQ3dpYkdWbWRGOXNhVzFwZENJNk5qQXVNQ3dpYkdsdGFYUmZiVzlrWlNJNklrWnliMjB2Vkc4aUxDSnRZWGdpT2pBdU1Dd2liV0Y0YVcxMWJWOXNhVzFwZENJNk5qQXVNQ3dpYldsdUlqb3RNVEF1TUN3aWJXbHVhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liVzlrWlNJNklsUnBZMnR6SWl3aWJXOWtaVjl5WVc1a2IyMGlPalF1TUN3aWJXOWtaVjkwYVdOcmN5STZNVEl1TUN3aWJXOWthV1pwWlhJaU9pSlRjR2x1SWl3aWJXOWthV1pwWlhKZlkzVnpkRzl0WDNOc2FXUmxjbk1pT2pZdU1Dd2liVzlrYVdacFpYSmZiVzlrWlNJNklrTjFjM1J2YlNJc0ltMXZaR2xtYVdWeVgyOW1abk5sZENJNk1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TFRFMkxqQXNJbTltWm5ObGRDSTZNQzR3TENKeVlXNWtiMjFmWTJodmEyVWlPblJ5ZFdVc0luSmhibVJ2YldsNlpTSTZkSEoxWlN3aWNtbG5hSFJmYkdsdGFYUWlPall3TGpBc0luTmlYM053WldWa0lqb3hNUzR3TENKMGIxOXNhVzFwZENJNk5EZ3VNQ3dpZVdGM0lqb2lRbUZqYTNkaGNtUWlMQ0o1WVhkZmJHVm1kQ0k2TFRJeUxqQXNJbmxoZDE5dGIyUmxJam9pVEM5U0lpd2llV0YzWDNKcFoyaDBJam8wTkM0d2ZTd2lWQ0k2ZXlKaGJHeHZkMTl6ZEdGMFpTSTZkSEoxWlN3aVltOWtlVjltY21WbGMzUmhibVJwYm1jaU9pSlBabVlpTENKaWIyUjVYM2xoZHlJNmRISjFaU3dpWW05a2VWOTVZWGRmYjNCMGFXOXVjeUk2V3lKS2FYUjBaWElpTENKK0lsMHNJbU5vYjJ0bElqb2lRM1Z6ZEc5dElpd2lZMmh2YTJVeFh6RWlPamd1TUN3aVkyaHZhMlV4WHpJaU9qRTRMakFzSW1Ob2IydGxNVjh6SWpvM0xqQXNJbU5vYjJ0bE1WODBJam94Tnk0d0xDSmphRzlyWlRGZk5TSTZPQzR3TENKamFHOXJaVEZmTmlJNk5TNHdMQ0pqYUc5clpWOW1jbTl0SWpveE5pNHdMQ0pqYUc5clpWOXRaWFJvYjJRaU9pSkRkWE4wYjIwaUxDSmphRzlyWlY5emJHbGtaWElpT2pFMkxqQXNJbU5vYjJ0bFgzTnNhV1JsY25NaU9qWXVNQ3dpWTJodmEyVmZkRzhpT2pFMkxqQXNJbVJsYkdGNUlqcDBjblZsTENKa1pXeGhlVjh4SWpveUxqQXNJbVJsYkdGNVh6SWlPakl1TUN3aVpHVnNZWGxmTXlJNk1pNHdMQ0prWld4aGVWODBJam95TGpBc0ltUmxiR0Y1WHpVaU9qSXVNQ3dpWkdWc1lYbGZOaUk2TWk0d0xDSmtaV3hoZVY5amRYTjBiMjFmYzJ4cFpHVnljeUk2TWk0d0xDSmtaV3hoZVY5a1pXWmhkV3gwSWpvM0xqQXNJbVJsYkdGNVgyMWxkR2h2WkNJNklrTjFjM1J2YlNJc0ltUmxiR0Y1WDNKaGJtUnZiVjl0WVhnaU9qWXVNQ3dpWkdWc1lYbGZjbUZ1Wkc5dFgyMXBiaUk2TlM0d0xDSm1jbTl0WDJ4cGJXbDBJam8yTUM0d0xDSnNaV1owWDJ4cGJXbDBJam8yTUM0d0xDSnNhVzFwZEY5dGIyUmxJam9pUm5KdmJTOVVieUlzSW0xaGVDSTZNQzR3TENKdFlYaHBiWFZ0WDJ4cGJXbDBJam8yTUM0d0xDSnRhVzRpT2kweE1DNHdMQ0p0YVc1cGJYVnRYMnhwYldsMElqbzJNQzR3TENKdGIyUmxJam9pVkdsamEzTWlMQ0p0YjJSbFgzSmhibVJ2YlNJNk5DNHdMQ0p0YjJSbFgzUnBZMnR6SWpveE1pNHdMQ0p0YjJScFptbGxjaUk2SWxOd2FXNGlMQ0p0YjJScFptbGxjbDlqZFhOMGIyMWZjMnhwWkdWeWN5STZOaTR3TENKdGIyUnBabWxsY2w5dGIyUmxJam9pUTNWemRHOXRJaXdpYlc5a2FXWnBaWEpmYjJabWMyVjBJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk1TSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpJaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTh6SWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOQ0k2TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6VWlPakF1TUN3aWJXOWthV1pwWlhKZmMyeHBaR1Z5YzE4Mklqb3RNVFl1TUN3aWIyWm1jMlYwSWpvd0xqQXNJbkpoYm1SdmJWOWphRzlyWlNJNmRISjFaU3dpY21GdVpHOXRhWHBsSWpwMGNuVmxMQ0p5YVdkb2RGOXNhVzFwZENJNk5qQXVNQ3dpYzJKZmMzQmxaV1FpT2pFeExqQXNJblJ2WDJ4cGJXbDBJam8wT0M0d0xDSjVZWGNpT2lKQ1lXTnJkMkZ5WkNJc0lubGhkMTlzWldaMElqb3RNakl1TUN3aWVXRjNYMjF2WkdVaU9pSk1MMUlpTENKNVlYZGZjbWxuYUhRaU9qUTBMakI5ZlN3aVUzUmhibVJwYm1jaU9uc2lRMVFpT25zaVlXeHNiM2RmYzNSaGRHVWlPblJ5ZFdVc0ltSnZaSGxmWm5KbFpYTjBZVzVrYVc1bklqb2lUMlptSWl3aVltOWtlVjk1WVhjaU9uUnlkV1VzSW1KdlpIbGZlV0YzWDI5d2RHbHZibk1pT2xzaVNtbDBkR1Z5SWl3aWZpSmRMQ0pqYUc5clpTSTZJa1JsWm1GMWJIUWlMQ0pqYUc5clpURmZNU0k2TWk0d0xDSmphRzlyWlRGZk1pSTZNaTR3TENKamFHOXJaVEZmTXlJNk1pNHdMQ0pqYUc5clpURmZOQ0k2TWk0d0xDSmphRzlyWlRGZk5TSTZNaTR3TENKamFHOXJaVEZmTmlJNk1pNHdMQ0pqYUc5clpWOW1jbTl0SWpveE5pNHdMQ0pqYUc5clpWOXRaWFJvYjJRaU9pSkVaV1poZFd4MElpd2lZMmh2YTJWZmMyeHBaR1Z5SWpveE5pNHdMQ0pqYUc5clpWOXpiR2xrWlhKeklqb3lMakFzSW1Ob2IydGxYM1J2SWpveE5pNHdMQ0prWld4aGVTSTZabUZzYzJVc0ltUmxiR0Y1WHpFaU9qVXVNQ3dpWkdWc1lYbGZNaUk2TWk0d0xDSmtaV3hoZVY4eklqb3hNeTR3TENKa1pXeGhlVjgwSWpvNExqQXNJbVJsYkdGNVh6VWlPak11TUN3aVpHVnNZWGxmTmlJNk1pNHdMQ0prWld4aGVWOWpkWE4wYjIxZmMyeHBaR1Z5Y3lJNk5TNHdMQ0prWld4aGVWOWtaV1poZFd4MElqb3lMakFzSW1SbGJHRjVYMjFsZEdodlpDSTZJa1JsWm1GMWJIUWlMQ0prWld4aGVWOXlZVzVrYjIxZmJXRjRJam95TGpBc0ltUmxiR0Y1WDNKaGJtUnZiVjl0YVc0aU9qSXVNQ3dpWm5KdmJWOXNhVzFwZENJNk5qQXVNQ3dpYkdWbWRGOXNhVzFwZENJNk5qQXVNQ3dpYkdsdGFYUmZiVzlrWlNJNklsTjBZWFJwWXlJc0ltMWhlQ0k2TUM0d0xDSnRZWGhwYlhWdFgyeHBiV2wwSWpvMk1DNHdMQ0p0YVc0aU9qQXVNQ3dpYldsdWFXMTFiVjlzYVcxcGRDSTZOakF1TUN3aWJXOWtaU0k2SWxOMFlYUnBZeUlzSW0xdlpHVmZjbUZ1Wkc5dElqbzBMakFzSW0xdlpHVmZkR2xqYTNNaU9qUXVNQ3dpYlc5a2FXWnBaWElpT2lJMUxWZGhlU0lzSW0xdlpHbG1hV1Z5WDJOMWMzUnZiVjl6Ykdsa1pYSnpJam95TGpBc0ltMXZaR2xtYVdWeVgyMXZaR1VpT2lKRVpXWmhkV3gwSWl3aWJXOWthV1pwWlhKZmIyWm1jMlYwSWpvMU1DNHdMQ0p0YjJScFptbGxjbDl6Ykdsa1pYSnpYekVpT2pBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHlJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk15STZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpRaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgxSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOaUk2TUM0d0xDSnZabVp6WlhRaU9qQXVNQ3dpY21GdVpHOXRYMk5vYjJ0bElqcG1ZV3h6WlN3aWNtRnVaRzl0YVhwbElqcG1ZV3h6WlN3aWNtbG5hSFJmYkdsdGFYUWlPall3TGpBc0luTmlYM053WldWa0lqb3hMakFzSW5SdlgyeHBiV2wwSWpvMk1DNHdMQ0o1WVhjaU9pSkNZV05yZDJGeVpDSXNJbmxoZDE5c1pXWjBJam90TWpJdU1Dd2llV0YzWDIxdlpHVWlPaUpNTDFJaUxDSjVZWGRmY21sbmFIUWlPalEyTGpCOUxDSlVJanA3SW1Gc2JHOTNYM04wWVhSbElqcDBjblZsTENKaWIyUjVYMlp5WldWemRHRnVaR2x1WnlJNklrOW1aaUlzSW1KdlpIbGZlV0YzSWpwMGNuVmxMQ0ppYjJSNVgzbGhkMTl2Y0hScGIyNXpJanBiSWtwcGRIUmxjaUlzSW40aVhTd2lZMmh2YTJVaU9pSkVaV1poZFd4MElpd2lZMmh2YTJVeFh6RWlPakl1TUN3aVkyaHZhMlV4WHpJaU9qSXVNQ3dpWTJodmEyVXhYek1pT2pJdU1Dd2lZMmh2YTJVeFh6UWlPakl1TUN3aVkyaHZhMlV4WHpVaU9qSXVNQ3dpWTJodmEyVXhYellpT2pJdU1Dd2lZMmh2YTJWZlpuSnZiU0k2TVRZdU1Dd2lZMmh2YTJWZmJXVjBhRzlrSWpvaVJHVm1ZWFZzZENJc0ltTm9iMnRsWDNOc2FXUmxjaUk2TVRZdU1Dd2lZMmh2YTJWZmMyeHBaR1Z5Y3lJNk1pNHdMQ0pqYUc5clpWOTBieUk2TVRZdU1Dd2laR1ZzWVhraU9tWmhiSE5sTENKa1pXeGhlVjh4SWpvMUxqQXNJbVJsYkdGNVh6SWlPakl1TUN3aVpHVnNZWGxmTXlJNk1UTXVNQ3dpWkdWc1lYbGZOQ0k2T0M0d0xDSmtaV3hoZVY4MUlqb3pMakFzSW1SbGJHRjVYellpT2pJdU1Dd2laR1ZzWVhsZlkzVnpkRzl0WDNOc2FXUmxjbk1pT2pVdU1Dd2laR1ZzWVhsZlpHVm1ZWFZzZENJNk1pNHdMQ0prWld4aGVWOXRaWFJvYjJRaU9pSkVaV1poZFd4MElpd2laR1ZzWVhsZmNtRnVaRzl0WDIxaGVDSTZNaTR3TENKa1pXeGhlVjl5WVc1a2IyMWZiV2x1SWpveUxqQXNJbVp5YjIxZmJHbHRhWFFpT2pZd0xqQXNJbXhsWm5SZmJHbHRhWFFpT2pZd0xqQXNJbXhwYldsMFgyMXZaR1VpT2lKVGRHRjBhV01pTENKdFlYZ2lPakF1TUN3aWJXRjRhVzExYlY5c2FXMXBkQ0k2TmpBdU1Dd2liV2x1SWpvd0xqQXNJbTFwYm1sdGRXMWZiR2x0YVhRaU9qWXdMakFzSW0xdlpHVWlPaUpUZEdGMGFXTWlMQ0p0YjJSbFgzSmhibVJ2YlNJNk5DNHdMQ0p0YjJSbFgzUnBZMnR6SWpvMExqQXNJbTF2WkdsbWFXVnlJam9pTlMxWFlYa2lMQ0p0YjJScFptbGxjbDlqZFhOMGIyMWZjMnhwWkdWeWN5STZNaTR3TENKdGIyUnBabWxsY2w5dGIyUmxJam9pUkdWbVlYVnNkQ0lzSW0xdlpHbG1hV1Z5WDI5bVpuTmxkQ0k2TlRBdU1Dd2liVzlrYVdacFpYSmZjMnhwWkdWeWMxOHhJam93TGpBc0ltMXZaR2xtYVdWeVgzTnNhV1JsY25OZk1pSTZNQzR3TENKdGIyUnBabWxsY2w5emJHbGtaWEp6WHpNaU9qQXVNQ3dpYlc5a2FXWnBaWEpmYzJ4cFpHVnljMTgwSWpvd0xqQXNJbTF2WkdsbWFXVnlYM05zYVdSbGNuTmZOU0k2TUM0d0xDSnRiMlJwWm1sbGNsOXpiR2xrWlhKelh6WWlPakF1TUN3aWIyWm1jMlYwSWpvd0xqQXNJbkpoYm1SdmJWOWphRzlyWlNJNlptRnNjMlVzSW5KaGJtUnZiV2w2WlNJNlptRnNjMlVzSW5KcFoyaDBYMnhwYldsMElqbzJNQzR3TENKellsOXpjR1ZsWkNJNk1TNHdMQ0owYjE5c2FXMXBkQ0k2TmpBdU1Dd2llV0YzSWpvaVFtRmphM2RoY21RaUxDSjVZWGRmYkdWbWRDSTZMVEl5TGpBc0lubGhkMTl0YjJSbElqb2lUQzlTSWl3aWVXRjNYM0pwWjJoMElqbzBOaTR3ZlgxOUxDSm1jbVZsYzNSaGJtUnBibWNpT25zaVltOWtlVjltY3lJNmRISjFaU3dpWkdsellXSnNaWEp6SWpwYkluNGlYU3dpY0hKbFptVnlYMjFoYm5WaGJDSTZkSEoxWlN3aWMzZHBkR05vSWpwbVlXeHpaU3dpZVdGM1gyMXZaQ0k2ZEhKMVpYMTlMQ0p0WVdsdUlqcDdJbUZrWkdsMGFXOXVZV3dpT25zaVltRmphM04wWVdJaU9uc2ljM2RwZEdOb0lqcDBjblZsZlN3aWJHVm5hWFJmWVdFaU9uc2laVzVoWW14bFpDSTZabUZzYzJVc0ltMXZaR1VpT2lKTWIyTmhiQ0JXYVdWM0luMHNJbTFoYm5WaGJGOTVZWGNpT25zaWFXNTJaWEowWlhJaU9uUnlkV1VzSW5ObGJHVmpkQ0k2SWtScGMyRmliR1ZrSWl3aWMzUmhkR2xqSWpwbVlXeHpaWDBzSW5OaFptVmZhR1ZoWkNJNmV5Sm9aV2xuYUhRaU9qVXdMakFzSW5OMFlYUmxjeUk2V3lKYVpYVnpJaXdpUzI1cFptVWlMQ0orSWwwc0luTjNhWFJqYUNJNmRISjFaWDBzSW5kaGNtMTFjRjloWVNJNmV5SnNaV1owWDNsaGR5STZMVE0xTGpBc0luQnBkR05vSWpvaVJHbHpZV0pzWldRaUxDSnlZVzVuWlNJNk16WXdMakFzSW5KcFoyaDBYM2xoZHlJNk5qY3VNQ3dpYzJWc1pXTjBJam9pUkdsellXSnNaV1FpTENKemNHVmxaQ0k2TVRJNExqQXNJbmxoZHlJNklsTndhVzRpZlgwc0ltTnZibVpwWjNWeVpTSTZleUp6ZEdGMFpTSTZPQzR3TENKMFpXRnRJam94TGpCOWZYMHNJbWx1Wm04aU9uc2libTkwYVdaNUlqcDdJbk53WVcwaU9tWmhiSE5sTENKemRIbHNaU0k2SWtOaGRDSjlMQ0p3Y21WelpYUnpJanA3SW14cGMzUWlPalV1TUN3aWJtRnRaU0k2SW01dloyRWlmU3dpYzJoaGNtVmtYMlpsWVhSMWNtVnpJanA3SW5OM2FYUmphQ0k2Wm1Gc2MyVjlMQ0p6YVdSbFltRnlJanA3SW1OdmJHOXlJanBiSWs5MWRIUmxjaUlzSWlNd01EQXdNREF3TUNJc0luNGlYU3dpYzNCbFpXUWlPalV1TUN3aWRHVjRkQ0k2SXRDejBMRFF0OUMrMEx2UXVOQzkwTEFnMFlIUXVOQzcwTEFpZlN3aWQyRjBaWEp0WVhKcklqcDdJbU52Ykc5eUlqcGJJa2x1Ym1WeUlpd2lJekF3TURBd01EQXdJaXdpZmlKZExDSm1iMjUwSWpvaVUyMWhiR3dpTENKbmNtRmthV1Z1ZENJNmRISjFaU3dpYlc5a1pTSTZXekV1TUN3eUxqQXNNeTR3TENKK0lsMHNJbTV2Ymw5bmNtRmthV1Z1ZENJNklpTkdSa1pHUmtaR1JpSXNJbk53WldWa0lqbzBMakFzSW5SbGVIUWlPaUpNVlVGVFJVNVRSU0JUVHlCQ1FVUWlmWDBzSW0xcGMyTWlPbnNpWVdsdFltOTBJanA3SW1aaGEyVmtkV05ySWpwN0ltWnlaV1Y2WlY5d1pYSnBiMlFpT25SeWRXVXNJblZ1Ykc5amF5STZkSEoxWlgwc0lteGhkR1Z1WTNraU9uc2ljM2RwZEdOb0lqcDBjblZsZlN3aWJHOW5aMmx1WnlJNmV5SmpiMnh2Y25NaU9uc2liV0ZwYmlJNklpTkdSVUpCUWtGR1JpSXNJbkJ5WldacGVDSTZJaU5HUkVKQlFrRkdSaUo5TENKdGIyUmxJanA3SW1selgyNXZkR2xtYVdOaGRHbHZiaUk2ZEhKMVpTd2ljMlZzWldOMElqcGJJa0ZwYldKdmRDSXNJbjRpWFgwc0luTjNhWFJqYUNJNmRISjFaWDE5TENKdGIzWmxiV1Z1ZENJNmV5SmhhWEpmWkhWamExOWpiMnhzYVhOcGIyNGlPbVpoYkhObExDSmxaR2RsWDNGMWFXTnJYM04wYjNBaU9tWmhiSE5sTENKbVlXeHNYMlJoYldGblpTSTZkSEoxWlN3aVptRnpkRjlzWVdSa1pYSWlPblJ5ZFdWOUxDSndiR0Y1WlhKZllXNXBiV0YwYVc5dWN5STZleUptWVd4c2FXNW5JanA3SW5aaGJIVmxJam93TGpCOUxDSnFhWFIwWlhKZmJHVm5jeUk2ZXlKbWNtOXRJam93TGpBc0luTjNhWFJqYUNJNmRISjFaU3dpZEc4aU9qVXdMakI5TENKc1pXRnVhVzVuSWpwN0luWmhiSFZsSWpveE1EQXVNSDE5ZlN3aWRtbHpkV0ZzY3lJNmV5SmhjM0JsWTNSZmNtRjBhVzhpT25zaWMzZHBkR05vSWpwMGNuVmxMQ0oyWVd4MVpTSTZNVE16TGpCOUxDSmtZVzFoWjJWZmFXNWthV05oZEc5eUlqcDdJbk4zYVhSamFDSTZabUZzYzJWOUxDSm1jSE5mWW05dmMzUWlPbnNpYzNkcGRHTm9JanBtWVd4elpYMHNJbWhwZEcxaGNtdGxjaUk2ZXlKamIyeHZjaUk2V3lJeVJDSXNJaU5HUmtaR1JrWkdSaUlzSW40aVhTd2ljMlZzWldOMElqcGJJbjRpWFN3aWRHbHRaU0k2TVRBdU1IMHNJbWx1WTNKbFlYTmxaRjltYkNJNmV5SnpkMmwwWTJnaU9tWmhiSE5sTENKMGFXTnJjeUk2TVRVdU1IMHNJbTFoYm5WaGJGOWhjbkp2ZDNNaU9uc2lZMjlzYjNJaU9pSWpSa1pHUmtaR1JrWWlMQ0ptYjI1MElqb2lSR1ZtWVhWc2RDSXNJbTltWm5ObGRDSTZNelV1TUN3aWMzZHBkR05vSWpwbVlXeHpaU3dpYzNsdFltOXNjeUk2ZXlKbWIzSjNZWEprSWpvaVhpSXNJbXhsWm5RaU9pSThJaXdpY21sbmFIUWlPaUkrSW4xOUxDSndiR0Y1WlhKZmRISmhibk53WVhKbGJtTjVJanA3SW5OM2FYUmphQ0k2ZEhKMVpYMHNJbkpsYlc5MlpWOXpiR1ZsZG1WeklqcDdJbk4zYVhSamFDSTZkSEoxWlgwc0luTmpiM0JsWDI5MlpYSnNZWGtpT25zaVlXNXBiV0YwYVc5dUlqcDBjblZsTENKamIyeHZjbk1pT25zaVpXUm5aU0k2SWlNd01EQXdNREF3TUNJc0ltMWhhVzRpT2lJak9FWTRSamhHUmtZaWZTd2laMkZ3SWpveE1DNHdMQ0pzWlc1bmRHZ2lPakU0TlM0d0xDSnZjSFJwYjI1eklqcGJJbjRpWFN3aWMzZHBkR05vSWpwMGNuVmxmU3dpYzJ0bFpYUmZhVzVrYVdOaGRHOXljeUk2ZXlKaWIyMWlJanAwY25WbExDSm1aV0YwZFhKbGN5STZXeUpHYjNKalpTQnpZV1psSUhCdmFXNTBJaXdpUm05eVkyVWdZbTlrZVNCaGFXMGlMQ0pRYVc1bklITndhV3RsSWl3aVJHOTFZbXhsSUhSaGNDSXNJa1IxWTJzZ2NHVmxheUJoYzNOcGMzUWlMQ0pHY21WbGMzUmhibVJwYm1jaUxDSlBiaUJ6YUc5MElHRnVkR2t0WVdsdElpd2lUV2x1YVcxMWJTQmtZVzFoWjJVZ2IzWmxjbkpwWkdVaUxDSitJbDBzSW5OM2FYUmphQ0k2Wm1Gc2MyVjlMQ0oyWld4dlkybDBlVjkzWVhKdWFXNW5JanA3SW1OdmJHOXlJam9pSTBaR1JrWkdSa1pHSWl3aWMzZHBkR05vSWpwbVlXeHpaWDBzSW5acFpYZHRiMlJsYkY5amFHRnVaMlZ5SWpwN0ltWnZkaUk2Tmpnd0xqQXNJbk4zYVhSamFDSTZkSEoxWlN3aWVDSTZMVFl1TUN3aWVTSTZMVGt1TUN3aWVpSTZNVEF1TUgxOWZRPT0iLCJ0aW1lIjoxNzQ3NTkyODQ4LjB9", 
        name = "MetaHOI"
    }
};
v143 = "\a{Link Active}\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129";
do
    local l_v84_3, l_v127_2, l_v134_2, l_v143_1, l_v144_0, l_v145_0, l_v146_0, l_v147_1, l_v148_1, l_v149_2, l_v150_3 = v84, v127, v134, v143, v144, v145, v146, v147, v148, v149, v150;
    v16.save_database = function()
        -- upvalues: l_v84_3 (ref), l_v127_2 (ref)
        db[l_v84_3] = l_v127_2;
    end;
    for _, v252 in pairs(l_v134_2) do
        if not l_v127_2[v252.name] then
            l_v127_2[v252.name] = v252.data;
        end;
    end;
    l_v144_0 = function(v253)
        -- upvalues: l_base64_0 (ref)
        return l_base64_0.encode(json.stringify(v253));
    end;
    l_v145_0 = function(v254)
        -- upvalues: l_base64_0 (ref)
        return json.parse(l_base64_0.decode(v254));
    end;
    l_v146_0 = function(v255, v256)
        -- upvalues: l_v143_1 (ref)
        if v255 == l_v143_1 then
            error(("u cant %s separator"):format(v256), 2);
        end;
    end;
    l_v147_1 = function(v257, v258)
        if v257:gsub(" ", "") == "" then
            error(("u cant %s config with empty name"):format(v258), 2);
        end;
    end;
    l_v148_1 = function()
        -- upvalues: v14 (ref), v55 (ref), l_v127_2 (ref), l_v145_0 (ref)
        local v259 = v14.info.presets.name:get();
        if v259 == nil then
            v55("Unable to find preset", true);
            return;
        else
            local v260 = l_v127_2[v259];
            if v260 == nil then
                return;
            else
                local v261 = l_v145_0(v260);
                local v262 = common.get_date("%m/%d %H:%M", v261.time);
                v14.info.presets.information.creator:name(string.format("Author: \v%s\r \194\183 Last update: \v%s\r", v261.author, v262));
                return;
            end;
        end;
    end;
    l_v149_2 = function()
        -- upvalues: l_v134_2 (ref), l_v143_1 (ref), l_v127_2 (ref), v14 (ref), l_v148_1 (ref)
        local v263 = {};
        for _, v265 in pairs(l_v134_2) do
            v263[#v263 + 1] = v265.name;
        end;
        v263[#l_v134_2 + 1] = l_v143_1;
        for v266, _ in pairs(l_v127_2) do
            local v268 = false;
            for _, v270 in ipairs(v263) do
                if v270 == v266 then
                    v268 = true;
                    break;
                end;
            end;
            if not v268 then
                v263[#v263 + 1] = v266;
            end;
        end;
        v14.info.presets.list:update(v263);
        local l_list_0 = v14.info.presets.list;
        local v272 = l_list_0:list()[l_list_0:get()];
        if v272 == nil then
            return;
        else
            v14.info.presets.name:set(v272);
            l_v148_1();
            local v273 = false;
            for _, v275 in ipairs(l_v134_2) do
                if v275.name == v272 or v272 == l_v143_1 then
                    v273 = true;
                    break;
                end;
            end;
            v14.info.presets.load:disabled(v272 == l_v143_1);
            v14.info.presets.save:disabled(v273);
            v14.info.presets.export:disabled(v273);
            v14.info.presets.delete:disabled(v273);
            v14.info.presets.delete_confirm:disabled(v273);
            v14.info.presets.delete_cancel:disabled(v273);
            return;
        end;
    end;
    l_v150_3 = function(v276, v277)
        -- upvalues: l_v127_2 (ref), v16 (ref), l_v149_2 (ref)
        l_v127_2[v276] = v277;
        v16.save_database();
        l_v149_2();
    end;
    v152 = function()
        -- upvalues: v14 (ref), l_v147_1 (ref), l_v146_0 (ref), l_v127_2 (ref), v55 (ref), v15 (ref), l_v144_0 (ref), l_pui_0 (ref), v8 (ref), l_v150_3 (ref)
        local v278 = v14.info.presets.name:get();
        l_v147_1(v278, "create");
        l_v146_0(v278, "create");
        if l_v127_2[v278] ~= nil then
            v55("Preset already exists", true);
            v15.new({
                [1] = "Preset already exists"
            });
            return;
        else
            local v279 = {
                name = v278, 
                config = l_v144_0(l_pui_0.save()), 
                author = v8, 
                time = common.get_unixtime()
            };
            v15.new({
                [1] = "Created preset with name - ", 
                [2] = v278
            });
            l_v150_3(v278, l_v144_0(v279));
            return;
        end;
    end;
    v153 = function()
        -- upvalues: v14 (ref), l_v147_1 (ref), l_v146_0 (ref), l_v127_2 (ref), v55 (ref), v15 (ref), l_v145_0 (ref), l_pui_0 (ref)
        local v280 = v14.info.presets.name:get();
        l_v147_1(v280, "load");
        l_v146_0(v280, "load");
        local v281 = l_v127_2[v280];
        if v281 == nil then
            v55("Unable to find preset", true);
            v15.new({
                [1] = "Unable to find preset"
            });
            return;
        else
            local v282 = l_v145_0(v281);
            local v283 = l_v145_0(v282.config);
            l_pui_0.load(v283);
            v55(string.format("Loaded %s's config (%s)", v282.author, v280));
            v15.new({
                [1] = "Loaded ", 
                [2] = nil, 
                [3] = "'s config - ", 
                [2] = v282.author, 
                [4] = v280
            });
            return;
        end;
    end;
    v154 = function()
        -- upvalues: v14 (ref), l_v147_1 (ref), l_v146_0 (ref), l_v127_2 (ref), v55 (ref), v15 (ref), l_v145_0 (ref), l_v144_0 (ref), l_pui_0 (ref), l_v150_3 (ref)
        local v284 = v14.info.presets.name:get();
        l_v147_1(v284, "save");
        l_v146_0(v284, "save");
        local v285 = l_v127_2[v284];
        if v285 == nil then
            v55("Unable to find preset", true);
            v15.new({
                [1] = "Unable to find preset"
            });
            return;
        else
            local v286 = l_v145_0(v285);
            v286.config = l_v144_0(l_pui_0.save());
            v286.name = v286.name or "undefined";
            l_v150_3(v284, l_v144_0(v286));
            v55(string.format("Overwrited %s's config (%s)", v286.author, v284));
            v15.new({
                [1] = "Overwrited ", 
                [2] = nil, 
                [3] = "'s config - ", 
                [2] = v286.author, 
                [4] = v284
            });
            return;
        end;
    end;
    local function v289()
        -- upvalues: l_clipboard_0 (ref), v55 (ref), v15 (ref), l_v145_0 (ref), l_v150_3 (ref)
        local v287 = l_clipboard_0.get();
        if v287 == nil or v287:gsub(" ", "") == "" then
            v55("Unable to find clipboard data", true);
            v15.new({
                [1] = "Unable to find clipboard data"
            });
            return;
        else
            local v288 = l_v145_0(v287);
            l_v150_3(v288.name, v287);
            v55(string.format("Imported %s's config (%s)", v288.author, v288.name));
            v15.new({
                [1] = "Imported ", 
                [2] = nil, 
                [3] = "'s config - ", 
                [2] = v288.author, 
                [4] = v288.name
            });
            return;
        end;
    end;
    local function v293()
        -- upvalues: v14 (ref), l_v147_1 (ref), l_v146_0 (ref), l_v127_2 (ref), v55 (ref), v15 (ref), l_v145_0 (ref), l_clipboard_0 (ref)
        local v290 = v14.info.presets.name:get();
        l_v147_1(v290, "export");
        l_v146_0(v290, "export");
        local v291 = l_v127_2[v290];
        if v291 == nil then
            v55("Unable to find preset.", true);
            v15.new({
                [1] = "Unable to find preset."
            });
            return;
        else
            local v292 = l_v145_0(v291);
            l_clipboard_0.set(v291);
            v55(string.format("Copied %s's config (%s)", v292.author, v290));
            v15.new({
                [1] = "Copied ", 
                [2] = nil, 
                [3] = "'s config - ", 
                [2] = v292.author, 
                [4] = v290
            });
            return;
        end;
    end;
    local function v295()
        -- upvalues: v14 (ref), l_v147_1 (ref), l_v146_0 (ref), l_v127_2 (ref), l_v150_3 (ref)
        local v294 = v14.info.presets.name:get();
        l_v147_1(v294, "delete");
        l_v146_0(v294, "delete");
        if not l_v127_2[v294] then
            return;
        else
            l_v150_3(v294, nil);
            return;
        end;
    end;
    v14.info.presets.create:set_callback(v152);
    v14.info.presets.load:set_callback(v153);
    v14.info.presets.save:set_callback(v154);
    v14.info.presets.import:set_callback(v289);
    v14.info.presets.export:set_callback(v293);
    v14.info.presets.delete_confirm:set_callback(v295);
    v14.info.presets.list:set_callback(l_v149_2, true);
    v16.save_database();
end;
v10.is_moving = false;
v10.is_airborne = false;
v10.is_crouched = false;
v10.duck_amount = 0;
v10.team = 0;
v10.net_update_end = function()
    -- upvalues: v10 (ref)
    local v296 = entity.get_local_player();
    if v296 == nil or not v296:is_alive() then
        return;
    else
        local v297 = v296:get_anim_state();
        if v297 == nil then
            return;
        else
            local v298 = v296:get_player_weapon();
            if v298 == nil then
                return;
            else
                local _ = v298:get_weapon_info();
                local l_m_flDuckAmount_0 = v296.m_flDuckAmount;
                local _ = v296.m_fFlags;
                v10.velocity = v296.m_vecVelocity:length2d();
                if globals.choked_commands == 0 then
                    v10.duck_amount = l_m_flDuckAmount_0;
                end;
                v10.team = v296.m_iTeamNum;
                v10.is_moving = v10.velocity > 4;
                v10.is_crouched = v10.duck_amount > 0.45;
                v10.is_airborne = not v297.on_ground or not not v297.landed_on_ground_this_frame;
                return;
            end;
        end;
    end;
end;
v17.get = function(v302, v303, v304)
    -- upvalues: v14 (ref), v9 (ref)
    if not v303 then
        v303 = false;
    end;
    if not v304 then
        v304 = false;
    end;
    local v305 = entity.get_local_player();
    if v305 == nil or not v305:is_alive() then
        return;
    else
        local v306 = v305:get_anim_state();
        if v306 == nil then
            return;
        else
            local l_m_flDuckAmount_1 = v305.m_flDuckAmount;
            local v308 = v305.m_vecVelocity:length2d();
            local v309 = v306.on_ground and not v306.landed_on_ground_this_frame;
            local v310 = v305.m_iTeamNum == 2 and "T" or "CT";
            local v311 = v14.antiaim.angles.builder["Legit AA"][v310];
            local _ = v14.antiaim.angles.builder.Freestanding[v310];
            if v302 and (v304 or v311.allow_state:get()) then
                return "Legit AA";
            elseif v14.antiaim.angles.freestanding.switch:get() and not v303 then
                return "Freestanding";
            elseif v309 then
                if v9.antiaim.misc.slow_walk:get() then
                    return "Slowing";
                elseif v308 < 5 then
                    if l_m_flDuckAmount_1 > 0 then
                        return "Crouching";
                    else
                        return "Standing";
                    end;
                elseif l_m_flDuckAmount_1 > 0 then
                    return "Sneaking";
                else
                    return "Running";
                end;
            else
                return l_m_flDuckAmount_1 > 0 and "Air Crouching" or "Air";
            end;
        end;
    end;
end;
v84 = {
    Forward = 180, 
    Right = 90, 
    Left = -90
};
do
    local l_v84_4 = v84;
    v18.think = function()
        -- upvalues: v14 (ref), l_v84_4 (ref)
        local v314 = v14.antiaim.main.additional.manual_yaw.select:get();
        if v314 == "Disabled" then
            return false, 0;
        else
            local v315 = l_v84_4[v314];
            if not v315 then
                return false, 0;
            else
                return true, v315;
            end;
        end;
    end;
    v18.update = function(_, v317, _)
        -- upvalues: v18 (ref), v14 (ref)
        local v319, v320 = v18.think();
        local v321 = v14.antiaim.main.additional.manual_yaw.static:get();
        local v322 = v14.antiaim.main.additional.manual_yaw.inverter:get();
        if v319 then
            v317.yaw_offset = v320;
            v317.yaw_base = "Local View";
            if v321 then
                v317.yaw_modifier = "Disabled";
                rage.antiaim:inverter(v322);
            end;
        end;
    end;
end;
v19.think = function(_)
    -- upvalues: v14 (ref), v17 (ref)
    local v324 = entity.get_local_player();
    if v324 == nil or not v324:is_alive() then
        return;
    else
        local v325 = v324:get_player_weapon();
        if v325 == nil then
            return;
        elseif not v14.antiaim.main.additional.safe_head.switch:get() then
            return;
        else
            local v326 = entity.get_threat();
            if v326 == nil or not v326:is_alive() then
                return;
            else
                local v327 = v325:get_classname();
                local v328 = v327 == "CKnife";
                local v329 = v327 == "CWeaponTaser";
                local v330 = v324:get_origin() - v326:get_origin();
                local v331 = v14.antiaim.main.additional.safe_head.height:get();
                return {
                    ["Air Crouch"] = v17.get() == "Air Crouching", 
                    Zeus = v329, 
                    Knife = v328, 
                    ["Height Advantage"] = v331 <= v330.z
                };
            end;
        end;
    end;
end;
v19.update = function(v332, v333, _)
    -- upvalues: v19 (ref), v14 (ref)
    local v335 = v19.think(v332);
    if v335 == nil then
        return;
    else
        for v336, v337 in pairs(v335) do
            if v14.antiaim.main.additional.safe_head.states:get(v336) and v337 then
                v333.body_yaw = true;
                v333.yaw_offset = 0;
                v333.left_limit = 1;
                v333.right_limit = 1;
                v333.body_yaw_options = {};
                v333.yaw_modifier = "Disabled";
            end;
        end;
        return;
    end;
end;
v84 = 0;
v20.think = function()
    -- upvalues: v14 (ref)
    local v338 = entity.get_local_player();
    if v338 == nil or not v338:is_alive() then
        return;
    else
        local v339 = entity.get_game_rules();
        if v339 == nil then
            return;
        elseif v14.antiaim.main.additional.warmup_aa.select:get() == "Disabled" then
            return;
        else
            local v340 = true;
            for v341 = 1, globals.max_players do
                local v342 = entity.get(v341);
                if v342 ~= nil then
                    local v343 = v342:get_resource();
                    if v343.m_bConnected and v343.m_bConnected == true and v342:is_enemy() and v342:is_alive() then
                        v340 = false;
                        break;
                    end;
                end;
            end;
            local v344 = v339.m_bWarmupPeriod or v340 or v339.m_bWarmupPeriod;
            return {
                Warmup = v339.m_bWarmupPeriod, 
                ["No Enemies"] = v340, 
                Force = v344
            };
        end;
    end;
end;
do
    local l_v84_5 = v84;
    v20.update = function(_, v347, _)
        -- upvalues: v20 (ref), v14 (ref), l_v84_5 (ref)
        local v349 = v20.think();
        if v349 == nil then
            return;
        else
            local v350 = v14.antiaim.main.additional.warmup_aa.select:get();
            if v350 == "Disabled" then
                return;
            else
                local v351 = v14.antiaim.main.additional.warmup_aa.yaw:get();
                local v352 = v14.antiaim.main.additional.warmup_aa.range:get();
                local v353 = v14.antiaim.main.additional.warmup_aa.speed:get();
                local v354 = v14.antiaim.main.additional.warmup_aa.left_yaw:get();
                local v355 = v14.antiaim.main.additional.warmup_aa.right_yaw:get();
                if v349[v350] and v350 ~= "Disabled" then
                    v347.pitch = v14.antiaim.main.additional.warmup_aa.pitch:get();
                    v347.yaw = "Backward";
                    v347.yaw_modifier = "Disabled";
                    if v351 == "L&R" then
                        v347.body_yaw = true;
                        v347.body_yaw_options = {
                            [1] = "Jitter"
                        };
                        v347.yaw_offset = rage.antiaim:inverter() and v354 or v355;
                    else
                        if v351 == "Distortion" then
                            if globals.tickcount % v353 == 0 then
                                l_v84_5 = utils.random_int(-v352, v352);
                            end;
                            v347.yaw_offset = l_v84_5;
                        end;
                        if v351 == "Spin" then
                            v347.yaw_offset = globals.framecount * (v353 * 0.1) % v352;
                        end;
                        v347.body_yaw = false;
                    end;
                end;
                return;
            end;
        end;
    end;
end;
v21.is_working = false;
v84 = function(v356, v357)
    local v358 = v357:get_eye_position();
    local l_entity_0 = utils.trace_line(v358, v358 + vector():angles(v356.view_angles) * 128, v357, 1174421515).entity;
    if l_entity_0 == nil then
        return false;
    else
        local v360 = l_entity_0:get_classname();
        local v361 = {
            [1] = "CDEagle", 
            [2] = "Weapon", 
            [3] = "Door", 
            [4] = "Hostage"
        };
        local v362 = false;
        for _, v364 in pairs(v361) do
            if v360:find(v364) then
                v362 = true;
                break;
            end;
        end;
        return v362;
    end;
end;
v127 = function(v365)
    if v365.m_iTeamNum ~= 3 then
        return false;
    else
        local v366 = v365:get_origin();
        local v367 = entity.get_entities("CPlantedC4");
        for v368 = 1, #v367 do
            local v369 = v367[v368];
            if v369 == nil then
                return false;
            else
                local v370 = v369:get_origin();
                if v369.m_bBombTicking and v370:dist(v366) < 87.5 then
                    return true;
                end;
            end;
        end;
        return false;
    end;
end;
do
    local l_v84_6, l_v127_3, l_v134_3 = v84, v127, v134;
    l_v134_3 = function(v374, v375, v376)
        -- upvalues: l_v84_6 (ref), l_v127_3 (ref)
        if v376 and v376:get_classname() == "CC4" then
            return true;
        elseif l_v84_6(v374, v375) then
            return true;
        elseif l_v127_3(v375) then
            return true;
        else
            return false;
        end;
    end;
    v21.think = function(v377)
        -- upvalues: v14 (ref), l_v134_3 (ref)
        if not v14.antiaim.main.additional.legit_aa.enabled:get() then
            return false;
        else
            local v378 = entity.get_local_player();
            if v378 == nil or not v378:is_alive() then
                return false;
            else
                local v379 = v378:get_player_weapon();
                if v379 == nil then
                    return false;
                elseif not v377.in_use then
                    return false;
                elseif l_v134_3(v377, v378, v379) then
                    return false;
                else
                    return true;
                end;
            end;
        end;
    end;
    v21.update = function(v380, v381, _)
        -- upvalues: v21 (ref), v14 (ref)
        local v383 = v21.think(v380);
        v21.is_working = v383;
        if not v383 then
            return;
        else
            v380.in_use = false;
            v381.pitch = "Disabled";
            v381.yaw_base = v14.antiaim.main.additional.legit_aa.mode:get();
            return;
        end;
    end;
end;
v84 = 1;
v127 = 0;
v22.think = function(v384)
    -- upvalues: v21 (ref), v17 (ref), v14 (ref)
    local _ = v21.think(v384);
    local v386 = v17.get(v21.is_working, false, false);
    if not v14.antiaim.angles.break_lc.select:get(v386) then
        return false;
    else
        local v387 = entity.get_local_player();
        if v387 == nil or not v387:is_alive() then
            return false;
        else
            local v388 = v387:get_player_weapon();
            if v388 == nil then
                return false;
            elseif v14.antiaim.angles.break_lc.disable_on_grenade:get() and v388:get_weapon_info().weapon_type == 9 then
                return false;
            else
                return true;
            end;
        end;
    end;
end;
do
    local l_v84_7, l_v127_4 = v84, v127;
    v22.update = function(v391, v392, v393)
        -- upvalues: v22 (ref), l_v127_4 (ref), l_v84_7 (ref), v14 (ref)
        if not v22.think(v391) then
            v392.lag_options = nil;
            v392.hs_options = nil;
            return;
        else
            local v394 = v393.choke:get();
            local v395 = v393.random_choke:get();
            local v396 = v393.choke_slider:get();
            local v397 = v393.choke_method:get();
            local v398 = v393.choke_from:get();
            local v399 = v393.choke_to:get();
            local v400 = v393.choke_sliders:get();
            if v391.choked_commands == 0 then
                l_v127_4 = l_v127_4 + 1;
                local v401 = v393["choke1_" .. l_v84_7]:get() or 1;
                if math.max(v401, 1) <= v400 then
                    l_v127_4 = 0;
                    l_v84_7 = l_v84_7 + 1;
                    if v400 < l_v84_7 then
                        l_v84_7 = 1;
                    end;
                end;
            end;
            if v394 == "Custom" then
                if not v395 then
                    if globals.tickcount % v396 == 0 then
                        v392.lag_options = "Always On";
                    end;
                elseif v397 == "Default" then
                    if globals.tickcount % math.random(v398, v399) == 0 then
                        v392.lag_options = "Always On";
                    end;
                else
                    local v402 = v393["choke1_" .. l_v84_7]:get() or 1;
                    if globals.tickcount % v402 == 0 then
                        v392.lag_options = "Always On";
                    end;
                end;
            else
                v392.lag_options = "Always On";
            end;
            v392.hs_options = v14.antiaim.angles.break_lc.hide_shots:get();
            return;
        end;
    end;
end;
v23.think = function(_)
    -- upvalues: v17 (ref), v21 (ref), v14 (ref)
    local v404 = v17.get(v21.is_working, true);
    if v14.antiaim.angles.freestanding.disablers:get(v404) then
        return false;
    elseif not v14.antiaim.angles.freestanding.switch:get() then
        return false;
    else
        return true;
    end;
end;
v23.update = function(v405, v406, _)
    -- upvalues: v23 (ref), v14 (ref)
    v406.freestanding = v23.think(v405);
    v406.body_freestanding = v14.antiaim.angles.freestanding.body_fs:get();
    v406.disable_yaw_modifiers = v14.antiaim.angles.freestanding.yaw_mod:get();
end;
v84 = {
    stage = 0, 
    tick = 0, 
    offset = 0, 
    time = -1
};
do
    local l_v84_8, l_v127_5, l_v134_4 = v84, v127, v134;
    l_v127_5 = function()
        -- upvalues: l_v84_8 (ref)
        l_v84_8.time = -1;
        l_v84_8.offset = 0;
        l_v84_8.stage = 0;
    end;
    l_v134_4 = function(v411)
        -- upvalues: v14 (ref), l_v84_8 (ref), v15 (ref)
        if not v14.antiaim.angles.anti_bruteforce.switch:get() then
            return;
        else
            local v412 = entity.get(v411.userid, true);
            if v412 == nil then
                return;
            elseif l_v84_8.time == -1 then
                return;
            elseif v412 == l_v84_8.target then
                if v14.antiaim.angles.anti_bruteforce.notify:get() then
                    v15.new({
                        [1] = "Reset antibrute due to", 
                        [2] = " target death"
                    }, color(255, 0, 0), "sparkles");
                end;
                return;
            else
                return;
            end;
        end;
    end;
    v24.bullet_impact = function(v413)
        -- upvalues: v14 (ref), l_v84_8 (ref), v15 (ref)
        if not v14.antiaim.angles.anti_bruteforce.switch:get() then
            return;
        else
            local v414 = entity.get_local_player();
            if v414 == nil or not v414:is_alive() then
                return;
            else
                local v415 = entity.get(v413.userid, true);
                if v415 == nil or not v415:is_alive() or not v415:is_enemy() then
                    return;
                else
                    l_v84_8 = l_v84_8 or {
                        stage = 0, 
                        offset = 0, 
                        tick = 0, 
                        time = -1
                    };
                    local l_tickcount_0 = globals.tickcount;
                    if l_tickcount_0 == l_v84_8.tick then
                        return;
                    else
                        local v417 = v414:simulate_movement();
                        local v418 = v415:get_eye_position();
                        if v417.origin:closest_ray_point(v418, (vector(v413.x, v413.y, v413.z))):dist(v417.origin) > 45 then
                            return;
                        else
                            l_v84_8.tick = l_tickcount_0;
                            l_v84_8.target = v415;
                            l_v84_8.time = globals.realtime + v14.antiaim.angles.anti_bruteforce.timeout:get();
                            l_v84_8.stage = l_v84_8.stage + 1;
                            if l_v84_8.stage >= 15 then
                                l_v84_8.stage = 0;
                            end;
                            local v419 = v14.antiaim.angles.anti_bruteforce.mode:get();
                            if v419 == "Increasing" then
                                l_v84_8.offset = math.random(5, 15);
                            elseif v419 == "Decreasing" then
                                l_v84_8.offset = math.random(-15, 5);
                            else
                                l_v84_8.offset = l_v84_8.stage * 2 * (rage.antiaim:inverter() and 1 or -1);
                            end;
                            if v14.antiaim.angles.anti_bruteforce.notify:get() then
                                v15.new({
                                    [1] = "Antibrute updated by ", 
                                    [2] = nil, 
                                    [3] = " (stage: ", 
                                    [4] = nil, 
                                    [5] = " | offset: ", 
                                    [6] = nil, 
                                    [7] = ")", 
                                    [2] = v415:get_name(), 
                                    [4] = l_v84_8.stage, 
                                    [6] = l_v84_8.offset
                                }, nil, "sparkles");
                            end;
                            return;
                        end;
                    end;
                end;
            end;
        end;
    end;
    v24.player_death = function(v420)
        -- upvalues: l_v134_4 (ref), l_v127_5 (ref)
        l_v134_4(v420);
        l_v127_5();
    end;
    v24.update = function(_, v422)
        -- upvalues: v14 (ref), l_v84_8 (ref)
        if not v14.antiaim.angles.anti_bruteforce.switch:get() then
            return;
        elseif l_v84_8.time - globals.realtime <= 0 then
            return;
        else
            v422.yaw_offset = v422.yaw_offset + l_v84_8.offset;
            return;
        end;
    end;
end;
v84 = {};
v127 = {
    unoverride = function(_)
        -- upvalues: v9 (ref)
        for _, v425 in pairs(v9.antiaim.angles) do
            v425:override();
        end;
    end, 
    reset = function(v426)
        v426.pitch = nil;
        v426.yaw = nil;
        v426.yaw_offset = nil;
        v426.yaw_base = nil;
        v426.yaw_modifier = nil;
        v426.modifier_offset = nil;
        v426.left_limit = nil;
        v426.right_limit = nil;
        v426.body_yaw = nil;
        v426.body_yaw_options = nil;
        v426.disable_yaw_modifiers = nil;
        v426.body_freestanding = nil;
        v426.freestanding = nil;
        v426.freestand_peek = nil;
        v426.lag_options = nil;
        v426.hs_options = nil;
        v426.avoid_backstab = nil;
        v426.ignore_inverter = false;
    end, 
    run = function(v427)
        -- upvalues: v9 (ref)
        local v428 = v427.pitch or "Disabled";
        v9.antiaim.angles.pitch:override(v428);
        local v429 = v427.yaw or "Disabled";
        v9.antiaim.angles.yaw:override(v429);
        local v430 = v427.yaw_offset or 0;
        v9.antiaim.angles.yaw_add:override(v430);
        local v431 = v427.yaw_base or "Local View";
        v9.antiaim.angles.yaw_base:override(v431);
        local v432 = v427.yaw_modifier or "Disabled";
        v9.antiaim.angles.yaw_modifier:override(v432);
        local v433 = v427.modifier_offset or 0;
        v9.antiaim.angles.modifier_offset:override(v433);
        local v434 = v427.left_limit or 0;
        local v435 = v427.right_limit or 0;
        v9.antiaim.angles.left_limit:override(v434);
        v9.antiaim.angles.right_limit:override(v435);
        local v436 = v427.body_yaw or false;
        v9.antiaim.angles.body_yaw:override(v436);
        local v437 = v427.body_yaw_options or {};
        v9.antiaim.angles.options:override(v437);
        local v438 = v427.disable_yaw_modifiers or false;
        v9.antiaim.angles.disable_yaw_modifiers:override(v438);
        local v439 = v427.body_freestanding or false;
        v9.antiaim.angles.body_freestanding:override(v439);
        local v440 = v427.freestanding or false;
        v9.antiaim.angles.freestanding:override(v440);
        local v441 = v427.freestand_peek or "Off";
        v9.antiaim.angles.freestand_peek:override(v441);
        local v442 = v427.lag_options or "On Peek";
        v9.rage.main.double_tap_lag_options:override(v442);
        local v443 = v427.hs_options or "Favor Fire Rate";
        v9.rage.main.hide_shots_options:override(v443);
        local v444 = v427.avoid_backstab or false;
        v9.antiaim.angles.avoid_backstab:override(v444);
    end
};
v127:unoverride();
do
    local l_v127_6 = v127;
    v84.create_antiaim = function()
        -- upvalues: l_v127_6 (ref)
        return setmetatable({}, {
            __index = l_v127_6
        });
    end;
end;
v127 = v84.create_antiaim();
v134 = 1;
v143 = 1;
v144 = 0;
v145 = 0;
v146 = false;
v147 = false;
v148 = 0;
v149 = 1;
v150 = 0;
v152 = false;
v25.get_exploit_values = function(v446, v447)
    return ({
        [1] = -v446, 
        [2] = -v446 / 2, 
        [3] = -v446 / 3, 
        [4] = v446 / 3, 
        [5] = v446 / 2, 
        [6] = v446
    })[v447];
end;
v153 = function(v448, v449)
    -- upvalues: v14 (ref)
    local v450 = v14.antiaim.angles.builder[v448];
    if v450 == nil then
        return nil;
    else
        return v450[v449];
    end;
end;
do
    local l_v127_7, l_v134_5, l_v143_2, l_v144_1, l_v145_1, l_v146_1, l_v147_2, l_v148_2, l_v149_3, l_v150_4, l_v152_2, l_v153_2, l_v154_1 = v127, v134, v143, v144, v145, v146, v147, v148, v149, v150, v152, v153, v154;
    l_v154_1 = function()
        -- upvalues: l_v144_1 (ref), l_v146_1 (ref)
        l_v144_1 = 0;
        l_v146_1 = not l_v146_1;
    end;
    local function v479(v464, v465, v466, v467)
        -- upvalues: l_v134_5 (ref), l_v144_1 (ref), l_v154_1 (ref), l_v146_1 (ref)
        v465.pitch = "Down";
        v465.yaw = v466.yaw:get();
        v465.yaw_base = "At Target";
        local v468 = v466.yaw_mode:get();
        local v469 = v466.delay:get();
        local v470 = v466.yaw_left:get();
        local v471 = v466.yaw_right:get();
        local v472 = v466.delay_method:get();
        local v473 = v466.delay_default:get();
        local v474 = v466.delay_random_min:get();
        local v475 = v466.delay_random_max:get();
        local v476 = v466.delay_custom_sliders:get();
        local v477 = v466["delay_" .. l_v134_5]:get() or 1;
        v477 = math.max(v477, 1);
        local v478 = 1.95;
        if v468 == "Solo" then
            v465.yaw_offset = v466.offset:get();
            return;
        elseif v468 == "L/R" then
            if v469 then
                if v464.choked_commands == 0 then
                    l_v144_1 = l_v144_1 + 1;
                    if v472 == "Default" then
                        if l_v144_1 >= v473 / v478 then
                            l_v154_1();
                        end;
                    elseif v472 == "Random" then
                        if l_v144_1 >= math.random(v474, v475) / v478 then
                            l_v154_1();
                        end;
                    elseif l_v144_1 >= v477 / v478 then
                        l_v154_1();
                        l_v134_5 = l_v134_5 + 1;
                        if v476 < l_v134_5 then
                            l_v134_5 = 1;
                        end;
                    end;
                end;
                rage.antiaim:inverter(l_v146_1);
                v465.yaw_offset = l_v146_1 and v470 or v471;
            else
                v465.yaw_offset = v467.m_flPoseParameter[11] * 120 - 60 > 0 and v470 or v471;
            end;
            return;
        else
            return;
        end;
    end;
    local function v497(v480, v481, v482)
        -- upvalues: v9 (ref), l_v147_2 (ref), l_v148_2 (ref), l_v150_4 (ref), l_v152_2 (ref)
        local v483 = v482.body_yaw:get();
        local v484 = v482.body_yaw_options:get();
        local v485 = v482.mode:get();
        local v486 = v482.mode_ticks:get();
        local v487 = v482.mode_random:get();
        if v485 == "Static" then
            v481.body_yaw = v483;
        elseif v485 == "Ticks" and not v9.antiaim.misc.fake_duck:get() then
            if globals.tickcount % v486 == 0 then
                l_v147_2 = not l_v147_2;
                l_v148_2 = 0;
            end;
            if not l_v147_2 then
                l_v148_2 = l_v148_2 + 1;
            end;
            if l_v148_2 >= utils.random_int(2, 6) then
                l_v147_2 = true;
                l_v148_2 = 0;
            end;
            local v488 = utils.random_int(3, 6);
            v488 = (not (v488 ~= 1) or v488 == 2) and 9 or v488 + 1;
            v481.body_yaw = l_v147_2;
        elseif v485 == "Random" and not v9.antiaim.misc.fake_duck:get() then
            v481.body_yaw = globals.tickcount % math.random(v487) == 1;
        end;
        local v489 = v482.limit_mode:get();
        local v490 = v482.minimum_limit:get();
        local v491 = v482.maximum_limit:get();
        local v492 = v482.from_limit:get();
        local v493 = v482.to_limit:get();
        local v494 = rage.antiaim:inverter();
        if v489 == "Speed-based Switch" then
            if v480.choked_commands == 0 then
                l_v150_4 = l_v150_4 + 1;
            end;
            if l_v150_4 >= v482.sb_speed:get() then
                l_v150_4 = 0;
                l_v152_2 = not l_v152_2;
            end;
            v494 = l_v152_2;
        end;
        local v495 = 0;
        local v496 = 0;
        if v489 == "Static" then
            v495 = v482.left_limit:get();
            v496 = v482.right_limit:get();
        elseif v489 == "Random" then
            v495 = math.random(v490, v491);
            v496 = math.random(v490, v491);
        else
            v495 = v494 and v492 or v493;
            v496 = v494 and v492 or v493;
        end;
        v481.left_limit = v495;
        v481.right_limit = v496;
        v481.freestand_peek = v482.body_freestanding:get();
        v481.body_yaw_options = v484;
    end;
    local function v513(v498, v499, v500)
        -- upvalues: l_v143_2 (ref), l_v149_3 (ref), v25 (ref), l_v145_1 (ref)
        local v501 = v500.modifier:get();
        local v502 = v500.modifier_mode:get();
        local v503 = v500.randomize:get();
        local v504 = v500.min:get();
        local v505 = v500.max:get();
        local v506 = v500.modifier_custom_sliders:get();
        local v507 = v500.modifier_offset:get();
        local v508 = v500["modifier_sliders_" .. l_v143_2]:get() or 1;
        v508 = math.max(v508, 1);
        if v498.choked_commands == 0 then
            l_v149_3 = l_v149_3 + 1;
            if l_v149_3 >= 7 then
                l_v149_3 = 1;
            end;
        end;
        v499.yaw_modifier = v501 == "Bobro" and "3-Way" or v501;
        if v503 then
            if v502 == "Default" then
                local v509 = math.random(v504, v505);
                v499.modifier_offset = v501 == "Bobro" and v25.get_exploit_values(v509, l_v149_3) or v509;
                return;
            elseif v502 == "Custom" then
                if v498.choked_commands == 0 then
                    l_v145_1 = l_v145_1 + 1;
                    if v508 <= l_v145_1 then
                        l_v145_1 = 0;
                        l_v143_2 = l_v143_2 + 1;
                        if v506 < l_v143_2 then
                            l_v143_2 = 1;
                        end;
                    end;
                end;
                local v510 = v500["modifier_sliders_" .. l_v143_2]:get();
                local v511 = v25.get_exploit_values(v510, l_v149_3);
                v499.modifier_offset = v501 == "Bobro" and v511 or v510;
                return;
            else
                return;
            end;
        else
            local v512 = v25.get_exploit_values(v507, l_v149_3);
            v499.modifier_offset = v501 == "Bobro" and v512 or v507;
            return;
        end;
    end;
    local function v521(v514, v515, v516)
        -- upvalues: l_v127_7 (ref), l_v153_2 (ref), v14 (ref), v479 (ref), v497 (ref), v513 (ref), v24 (ref), v20 (ref), v21 (ref), v19 (ref), v22 (ref), v18 (ref), v23 (ref)
        l_v127_7:reset();
        local v517 = v516.m_iTeamNum == 2 and "T" or "CT";
        local v518 = l_v153_2(v515, v517);
        if v518 == nil then
            return;
        else
            l_v127_7.avoid_backstab = v14.antiaim.main.additional.backstab.switch:get();
            v479(v514, l_v127_7, v518, v516);
            v497(v514, l_v127_7, v518);
            v513(v514, l_v127_7, v518);
            v24.update(v514, l_v127_7);
            v20.update(v514, l_v127_7, v518);
            if not v21.think(v514) then
                v19.update(v514, l_v127_7, v518);
            end;
            v21.update(v514, l_v127_7, v518);
            v22.update(v514, l_v127_7, v518);
            local v519 = v18.think();
            local v520 = v23.think();
            if v14.antiaim.angles.freestanding.prefer_manual:get() and v519 then
                v18.update(v514, l_v127_7, v518);
            elseif v520 then
                v23.update(v514, l_v127_7, v518);
            else
                v18.update(v514, l_v127_7, v518);
            end;
            l_v127_7:run();
            return;
        end;
    end;
    v25.update = function(v522)
        -- upvalues: v21 (ref), v17 (ref), v521 (ref)
        local v523 = entity.get_local_player();
        local v524 = v21.think(v522);
        local v525 = v17.get(v524);
        v521(v522, v525, v523);
    end;
end;
v143 = ffi.cast("bool(__fastcall*)(void*, void*)", utils.opcode_scan("client.dll", "56 8B F1 E8 ? ? ? ? 3B F0"));
l_memory_0.hook_func(v143, function(v526, v527, v528)
    -- upvalues: v14 (ref)
    local v529 = v526:get_original(v527, v528);
    if not v14.misc.features.force_interpolation:get() then
        return v529;
    else
        return true;
    end;
end);
v127 = ffi.typeof("        struct {\n            float  m_flLayerAnimtime;\n            float  m_flLayerFadeOuttime;\n            void  *m_pDispatchedStudioHdr;\n            int    m_nDispatchedSrc;\n            int    m_nDispatchedDst;\n            int    m_nOrder;\n            int    m_nSequence;\n            float  m_flPrevCycle;\n            float  m_flWeight;\n            float  m_flWeightDeltaRate;\n            float  m_flPlaybackRate;\n            float  m_flCycle;\n            int    m_pOwner;\n            int    m_nInvalidatePhysicsBits;\n        } **\n    ");
v134 = false;
do
    local l_v127_8, l_v134_6, l_v143_3 = v127, v134, v143;
    l_v143_3 = function(v533)
        -- upvalues: l_v127_8 (ref)
        return ffi.cast(l_v127_8, ffi.cast("uintptr_t", v533[0]) + 10640)[0];
    end;
    v27.createmove = function(v534)
        -- upvalues: l_v134_6 (ref), v14 (ref), v9 (ref)
        l_v134_6 = v534.in_use;
        if not v14.misc.player_animations.jitter_legs.switch:get() then
            v9.antiaim.misc.leg_movement:override();
            return;
        else
            v9.antiaim.misc.leg_movement:override(v534.command_number % 3 == 0 and "Walking" or "Sliding");
            return;
        end;
    end;
    v27.post_update_clientside_animation = function(v535)
        -- upvalues: l_v143_3 (ref), v14 (ref), l_v134_6 (ref)
        local v536 = entity.get_local_player();
        if v536 == nil or not v536:is_alive() then
            return;
        elseif v535 == nil or not v535:is_alive() then
            return;
        elseif v535 ~= v536 then
            return;
        else
            local v537 = v535:get_player_weapon();
            if v537 == nil then
                return;
            else
                local v538 = l_v143_3(v535);
                if v538 == nil then
                    return;
                else
                    local l_m_vecVelocity_0 = v536.m_vecVelocity;
                    local v540 = 0.01;
                    local v541 = v14.misc.player_animations.leaning.value:get();
                    local v542 = v14.misc.player_animations.falling.value:get();
                    local v543 = v14.misc.player_animations.jitter_legs.switch:get();
                    local v544 = v14.misc.player_animations.jitter_legs.from:get();
                    local v545 = v14.misc.player_animations.jitter_legs.to:get();
                    if v541 ~= -1 and l_m_vecVelocity_0:length2d() > 4 then
                        v538[12].m_flWeight = v541 * v540;
                    end;
                    if v543 and l_m_vecVelocity_0:length2d() > 2 then
                        v535.m_flPoseParameter[0] = (globals.tickcount % 3 == 0 and v544 or v545) * v540;
                    end;
                    if v542 ~= -1 then
                        v535.m_flPoseParameter[6] = v542 * v540;
                    end;
                    if v537:get_classname() == "CC4" and l_v134_6 then
                        v538[10].m_flWeight = 1;
                        v538[10].m_nSequence = 200;
                        v538[10].m_flCycle = 0.1;
                    end;
                    return;
                end;
            end;
        end;
    end;
end;
v28.createmove = function(v546)
    -- upvalues: v14 (ref), v9 (ref)
    if not v14.misc.aimbot.fakeduck.unlock:get() then
        return;
    elseif not v9.antiaim.misc.fake_duck:get() then
        return;
    else
        local l_forwardmove_0 = v546.forwardmove;
        local l_sidemove_0 = v546.sidemove;
        if math.abs(l_forwardmove_0) > 1 or math.abs(l_sidemove_0) > 1 then
            local v549 = 450 / vector(l_forwardmove_0, l_sidemove_0):length2d();
            v546.forwardmove = l_forwardmove_0 * v549;
            v546.sidemove = l_sidemove_0 * v549;
        end;
        return;
    end;
end;
v29.createmove = function(v550)
    -- upvalues: v14 (ref), v9 (ref)
    if not v14.misc.aimbot.fakeduck.freeze_period:get() then
        return;
    elseif not v9.antiaim.misc.fake_duck:get() then
        return;
    else
        local v551 = entity.get_game_rules();
        if v551 == nil then
            return;
        elseif not v551.m_bFreezePeriod then
            return;
        else
            v550.in_duck = v550.choked_commands >= 7;
            v550.send_packet = not v550.choked_commands == 14;
            return;
        end;
    end;
end;
v29.override_view = function(v552)
    -- upvalues: v14 (ref), v9 (ref)
    if not v14.misc.aimbot.fakeduck.freeze_period:get() then
        return;
    elseif not v9.antiaim.misc.fake_duck:get() then
        return;
    else
        local v553 = entity.get_local_player();
        if v553 == nil or not v553:is_alive() then
            return;
        else
            local v554 = entity.get_game_rules();
            if not v554 then
                return;
            elseif not v554.m_bFreezePeriod then
                return;
            else
                v552.camera = v552.camera - v553.m_vecViewOffset + vector(0, 0, 64);
                return;
            end;
        end;
    end;
end;
v127 = 0.5;
do
    local l_v127_9, l_v134_7 = v127, v134;
    l_v134_7 = function()
        -- upvalues: l_v127_9 (ref)
        local v557 = utils.net_channel();
        if v557 == nil then
            return 0;
        elseif v557.is_loopback then
            return 0;
        elseif not v557.is_timing_out then
            return 0;
        else
            local v558 = v557.time - v557.time_since_last_received;
            if v558 < l_v127_9 then
                return 0;
            else
                return v558;
            end;
        end;
    end;
    v30.draw = function()
        -- upvalues: v14 (ref), l_v134_7 (ref), v56 (ref), v12 (ref)
        if not v14.misc.aimbot.logging.mode.select:get(2) then
            return;
        else
            local v559 = l_v134_7();
            if v559 == 0 then
                return;
            else
                local v560 = globals.realtime * 1.25;
                local v561 = v56 * vector(0.5, 0.175);
                local v562 = 71;
                local v563 = 71;
                local v564 = 71;
                local v565 = 255;
                local v566, v567, v568, v569 = ui.get_style()["Link Active"]:unpack();
                v569 = math.max(v569, 55);
                v565 = v569;
                local v570 = string.format("Time without connection: %.1fs", v559);
                v570 = string.upper(v570);
                local v571 = "d";
                local v572 = render.measure_text(2, v571, v570);
                v561.x = v561.x - v572.x * 0.5;
                v570 = v12.wave(v570, v560, v566, v567, v568, v569, v562, v563, v564, v565);
                render.text(2, v561, color(v566, v567, v568, v569), v571, v570);
                return;
            end;
        end;
    end;
end;
v127 = {
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
v134 = {
    knife = "Knifed", 
    inferno = "Burned", 
    hegrenade = "Naded", 
    taser = "Zeused"
};
v143 = {
    knife = "sword", 
    inferno = "fire", 
    hegrenade = "bomb", 
    taser = "bolt-lightning "
};
v144 = function(v573, v574)
    local v575 = {};
    v575[#v575 + 1] = "\a";
    v575[#v575 + 1] = v574;
    v575[#v575 + 1] = v573;
    v575[#v575 + 1] = "\aDEFAULT";
    return table.concat(v575);
end;
v145 = function(v576)
    -- upvalues: v14 (ref)
    if v576 then
        return v14.misc.aimbot.logging.colors.prefix:get();
    else
        return v14.misc.aimbot.logging.colors.main:get();
    end;
end;
v146 = function()
    -- upvalues: v14 (ref)
    local v577 = v14.misc.aimbot.logging.customization.prefix:get();
    if v577:gsub(" ", "") == "" then
        v577 = "gazolina.lc";
    end;
    return v577;
end;
v147 = function()
    -- upvalues: v14 (ref)
    return v14.misc.aimbot.logging.mode.is_notification:get();
end;
do
    local l_v127_10, l_v134_8, l_v143_4, l_v144_2, l_v145_2, l_v146_2, l_v147_3, l_v148_3, l_v149_4 = v127, v134, v143, v144, v145, v146, v147, v148, v149;
    l_v148_3 = function(v587)
        -- upvalues: l_v146_2 (ref), l_v145_2 (ref), l_v127_10 (ref), l_v144_2 (ref), l_v147_3 (ref), v15 (ref)
        local l_target_0 = v587.target;
        if l_target_0 == nil then
            return;
        else
            local v589 = l_v146_2();
            local v590 = l_v145_2(false):to_hex();
            local v591 = l_v145_2(true):to_hex();
            local v592 = l_v127_10[v587.hitgroup] or "?";
            local v593 = l_v127_10[v587.wanted_hitgroup] or "?";
            if v592 == "generic" then
                v592 = v593;
            end;
            local v594 = v587.damage ~= v587.wanted_damage;
            local v595 = v587.hitgroup ~= v587.wanted_hitgroup;
            local v596 = "";
            if v594 or v595 then
                v596 = (" | mismatch: [%s]"):format((function()
                    -- upvalues: v594 (ref), l_v144_2 (ref), v587 (ref), v590 (ref), v595 (ref), v593 (ref)
                    local v597 = "";
                    if v594 then
                        v597 = l_v144_2(v587.wanted_damage, v590) .. (v595 and ":" or "");
                    end;
                    if v595 then
                        v597 = v597 .. (v595 and l_v144_2(v593, v590) or "");
                    end;
                    return v597;
                end)());
            end;
            print_raw(("[%s] Dealt %s damage in %s's %s (bt: %st | hitchance: %s%%%s)"):format(l_v144_2(v589, v591), l_v144_2(v587.damage, v590), l_v144_2(l_target_0:get_name(), v590), l_v144_2(v592, v590), l_v144_2(v587.backtrack, v590), l_v144_2(v587.hitchance, v590), v596));
            print_dev(("Dealt %s damage in %s's %s (bt: %st | hitchance: %s%%%s)"):format(l_v144_2(v587.damage, v590), l_v144_2(l_target_0:get_name(), v590), l_v144_2(v592, v590), l_v144_2(v587.backtrack, v590), l_v144_2(v587.hitchance, v590), v596));
            if l_v147_3() then
                v15.new({
                    [1] = "Hit ", 
                    [2] = nil, 
                    [3] = "'s ", 
                    [4] = nil, 
                    [5] = " for ", 
                    [6] = nil, 
                    [7] = " damage", 
                    [2] = l_target_0:get_name(), 
                    [4] = l_v127_10[v587.hitgroup], 
                    [6] = v587.damage
                }, ui.get_style()["Link Active"], "poo-storm");
            end;
            return;
        end;
    end;
    l_v149_4 = function(v598)
        -- upvalues: l_v146_2 (ref), l_v145_2 (ref), l_v127_10 (ref), l_v144_2 (ref), l_v147_3 (ref), v15 (ref)
        if v598.target == nil then
            return;
        else
            local l_target_1 = v598.target;
            if l_target_1 == nil then
                return;
            else
                local v600 = l_v146_2();
                local v601 = l_v145_2(false):to_hex();
                local v602 = l_v145_2(true):to_hex();
                local v603 = l_v127_10[v598.wanted_hitgroup] or "?";
                print_raw(("[%s] Missed %s's %s due to %s (damage: %s | bt: %st | hitchance: %s%%)"):format(l_v144_2(v600, v602), l_v144_2(l_target_1:get_name(), v601), l_v144_2(v603, v601), l_v144_2(v598.state, v601), l_v144_2(v598.wanted_damage, v601), l_v144_2(v598.backtrack, v601), l_v144_2(v598.hitchance, v601)));
                print_dev(("Missed %s's %s due to %s (damage: %s | bt: %st | hitchance: %s%%)"):format(l_v144_2(l_target_1:get_name(), v601), l_v144_2(v603, v601), l_v144_2(v598.state, v601), l_v144_2(v598.wanted_damage, v601), l_v144_2(v598.backtrack, v601), l_v144_2(v598.hitchance, v601)));
                if l_v147_3() then
                    v15.new({
                        [1] = "Missed ", 
                        [2] = nil, 
                        [3] = "'s ", 
                        [4] = nil, 
                        [5] = " due to ", 
                        [2] = l_target_1:get_name(), 
                        [4] = l_v127_10[v598.wanted_hitgroup], 
                        [6] = v598.state
                    }, color(255, 0, 0, 255), "poo");
                end;
                return;
            end;
        end;
    end;
    v31.player_hurt = function(v604)
        -- upvalues: v14 (ref), l_v127_10 (ref), l_v146_2 (ref), l_v145_2 (ref), l_v134_8 (ref), l_v144_2 (ref), l_v147_3 (ref), v15 (ref), l_v143_4 (ref)
        if not v14.misc.aimbot.logging.switch:get() then
            return;
        elseif not v14.misc.aimbot.logging.mode.select:get(1) then
            return;
        else
            local v605 = entity.get_local_player();
            if v605 == nil then
                return;
            else
                local v606 = entity.get(v604.attacker, true);
                if v606 == nil then
                    return;
                elseif v605 ~= v606 then
                    return;
                else
                    local v607 = entity.get(v604.userid, true);
                    if v607 == nil then
                        return;
                    elseif (l_v127_10[v604.hitgroup] or "?") ~= "generic" then
                        return;
                    else
                        local v608 = l_v146_2();
                        local v609 = l_v145_2(false):to_hex();
                        local v610 = l_v145_2(true):to_hex();
                        if not l_v134_8[v604.weapon] then
                            local _ = error(("unknown weapon %s"):format(v604.weapon), 2);
                        end;
                        print_raw(("[%s] %s %s for %s damage (%s remaining)"):format(l_v144_2(v608, v610), l_v134_8[v604.weapon], l_v144_2(v607:get_name(), v609), l_v144_2(v604.dmg_health, v609), l_v144_2(v604.health, v609)));
                        print_dev(("%s %s for %s damage (%s remaining)"):format(l_v134_8[v604.weapon], l_v144_2(v607:get_name(), v609), l_v144_2(v604.dmg_health, v609), l_v144_2(v604.health, v609)));
                        if l_v147_3() then
                            v15.new({
                                [1] = nil, 
                                [2] = nil, 
                                [3] = " for ", 
                                [4] = nil, 
                                [5] = " (", 
                                [6] = nil, 
                                [7] = " remaining)", 
                                [1] = l_v134_8[v604.weapon], 
                                [2] = " " .. v607:get_name(), 
                                [4] = v604.dmg_health, 
                                [6] = v604.health
                            }, nil, l_v143_4[v604.weapon]);
                        end;
                        return;
                    end;
                end;
            end;
        end;
    end;
    v31.update = function(v612)
        -- upvalues: v14 (ref), l_v149_4 (ref), l_v148_3 (ref)
        if not v14.misc.aimbot.logging.switch:get() then
            return;
        elseif not v14.misc.aimbot.logging.mode.select:get(1) then
            return;
        elseif v612.state ~= nil then
            l_v149_4(v612);
            return;
        else
            l_v148_3(v612);
            return;
        end;
    end;
end;
v32.window = v11.new("watermark", vector(v56.x / 2, v56.y * 0.8));
v127 = render.load_font("Arial bold", 13, "ad");
v134 = 0;
do
    local l_v127_11, l_v134_9 = v127, v134;
    v32.frame = function()
        -- upvalues: v32 (ref), v14 (ref), l_v127_11 (ref), v6 (ref), v12 (ref), l_v134_9 (ref), v13 (ref)
        local l_window_0 = v32.window;
        local l_watermark_0 = v14.info.watermark;
        local v617 = {
            Bold = 4, 
            Console = 3, 
            Small = 2, 
            Default = 1, 
            Unique = l_v127_11
        };
        local v618 = v14.info.watermark.speed:get() * 0.01;
        local v619 = globals.realtime * v618;
        local v620, v621, v622, v623 = v14.info.watermark.color:get("Outter")[1]:unpack();
        local v624, v625, v626, v627 = v14.info.watermark.color:get("Inner")[1]:unpack();
        local v628 = v14.info.watermark.mode:get(1) and v14.info.watermark.text:get():gsub(" ", "") ~= "" and v14.info.watermark.text:get() or v6;
        local v629 = v12.wave(v628, v619, v620, v621, v622, v623, v624, v625, v626, v627);
        if not v14.info.watermark.mode:get(2) or not v14.info.watermark.gradient:get() then
            local v630 = {};
            v630[#v630 + 1] = "\a";
            v630[#v630 + 1] = v14.info.watermark.color_n:get():to_hex();
            v630[#v630 + 1] = v628;
            v629 = table.concat(v630);
        end;
        local v631 = 1;
        if l_watermark_0.mode:get(3) then
            v631 = v617[l_watermark_0.font:get()];
        end;
        local v632 = l_window_0:is_dragging();
        l_v134_9 = v13.interp(l_v134_9, v632 and 0.6 or 1, 0.05);
        local l_position_0 = l_window_0.position;
        local v634 = render.measure_text(1, nil, v629);
        render.text(v631, l_position_0, color(255, 255 * l_v134_9), nil, v629);
        l_window_0:update(v634);
    end;
end;
v33.draw = function()
    -- upvalues: v14 (ref), v6 (ref), v12 (ref)
    if ui.get_alpha() <= 0 then
        return;
    else
        local v635 = v14.info.sidebar.text:get();
        local v636 = v635:len();
        local v637 = v635:gsub(" ", "");
        if v636 == 0 or v637 == "" then
            v635 = v6;
        end;
        local v638 = v14.info.sidebar.speed:get() * 0.01;
        local v639 = globals.realtime * v638;
        local v640, v641, v642, v643 = v14.info.sidebar.color:get("Outter")[1]:unpack();
        local v644, v645, v646, v647 = v14.info.sidebar.color:get("Inner")[1]:unpack();
        local v648 = v12.wave(v635, v639, v640, v641, v642, v643, v644, v645, v646, v647);
        ui.sidebar(v648, "\240\159\145\145");
        return;
    end;
end;
v127 = 0;
v134 = 0;
v143 = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay");
do
    local l_v127_12, l_v134_10, l_v143_5 = v127, v134, v143;
    v34.draw = function()
        -- upvalues: v14 (ref), l_v127_12 (ref), v13 (ref), l_v134_10 (ref), l_v143_5 (ref), v56 (ref)
        local v652 = entity.get_local_player();
        if v652 == nil or not v652:is_alive() then
            return;
        elseif v652:get_player_weapon() == nil then
            return;
        else
            local v653 = v14.visuals.scope_overlay.switch:get();
            local l_m_bIsScoped_0 = v652.m_bIsScoped;
            l_v127_12 = v13.interp(l_v127_12, v653, 0.05);
            l_v134_10 = v13.interp(l_v134_10, v653 and l_m_bIsScoped_0, 0.05);
            if l_v127_12 <= 0 then
                l_v143_5:override();
                return;
            else
                l_v143_5:override("Remove All");
                local v655 = l_v127_12 * l_v134_10;
                local v656 = v56 * 0.5;
                local v657 = v14.visuals.scope_overlay.gap:get() * v56.y * (1 / v56.y);
                local v658 = v14.visuals.scope_overlay.length:get() * v56.y * (1 / v56.y);
                v657 = math.floor(v657);
                v658 = math.floor(v658);
                local v659 = v658 - v657;
                local v660 = v14.visuals.scope_overlay.colors.main:get();
                local v661 = v14.visuals.scope_overlay.colors.edge:get();
                if v14.visuals.scope_overlay.options:get(2) then
                    local v662 = v660:clone();
                    v660 = v661;
                    v661 = v662;
                end;
                v660.a = v660.a * v655;
                v661.a = v661.a * v655;
                local v663 = 45;
                local v664 = v14.visuals.scope_overlay.options:get(1);
                if v664 and v14.visuals.scope_overlay.animation:get() and v652.m_vecVelocity:length2d() >= 5 then
                    v663 = globals.framecount % 360;
                end;
                if v664 then
                    render.push_rotation(v663);
                end;
                render.gradient(vector(v656.x, v656.y - v657 + 1), vector(v656.x + 1, v656.y - v658 * v655), v660, v660, v661, v661);
                render.gradient(vector(v656.x, v656.y + v657), vector(v656.x + 1, v656.y + v658 * v655), v660, v660, v661, v661);
                render.gradient(vector(v656.x - v657 + 1, v656.y), vector(v656.x - v657 + 1 - v659 * v655, v656.y + 1), v660, v661, v660, v661);
                render.gradient(vector(v656.x + v657, v656.y), vector(v656.x + v657 + v659 * v655 + 1, v656.y + 1), v660, v661, v660, v661);
                if v664 then
                    render.pop_rotation();
                end;
                return;
            end;
        end;
    end;
end;
v127 = 0;
v134 = 0;
v143 = 0;
v144 = 0;
do
    local l_v127_13, l_v134_11, l_v143_6, l_v144_3 = v127, v134, v143, v144;
    v35.draw = function()
        -- upvalues: v56 (ref), v14 (ref), l_v127_13 (ref), v13 (ref), l_v134_11 (ref), l_v143_6 (ref), l_v144_3 (ref)
        local v669 = entity.get_local_player();
        if v669 == nil or not v669:is_alive() then
            return;
        else
            local v670 = v56 / 2;
            local v671 = v14.visuals.manual_arrows.switch:get();
            local v672 = v14.antiaim.main.additional.manual_yaw.select:get();
            local v673 = ({
                Default = 1, 
                Bold = 4, 
                Console = 3, 
                Small = 2
            })[v14.visuals.manual_arrows.font:get()];
            local v674 = v14.visuals.manual_arrows.offset:get();
            l_v127_13 = v13.interp(l_v127_13, v671, 0.05);
            if l_v127_13 <= 0 then
                return;
            else
                local v675 = v14.visuals.manual_arrows.color:get();
                l_v134_11 = v13.interp(l_v134_11, v672 == "Left", 0.05);
                l_v143_6 = v13.interp(l_v143_6, v672 == "Right", 0.05);
                l_v144_3 = v13.interp(l_v144_3, v672 == "Forward", 0.05);
                if l_v134_11 > 0 then
                    render.text(v673, v670 + vector(-10, 0) - vector(v674, 0), v675:alpha_modulate(l_v134_11 * v675.a * l_v127_13), "c", v14.visuals.manual_arrows.symbols.left:get());
                end;
                if l_v143_6 > 0 then
                    render.text(v673, v670 + vector(12, 0) + vector(v674, 0), v675:alpha_modulate(l_v143_6 * v675.a * l_v127_13), "c", v14.visuals.manual_arrows.symbols.right:get());
                end;
                if l_v144_3 > 0 then
                    render.text(v673, v670 + vector(0, -10) - vector(0, v674), v675:alpha_modulate(l_v144_3 * v675.a * l_v127_13), "c", v14.visuals.manual_arrows.symbols.forward:get());
                end;
                return;
            end;
        end;
    end;
end;
v127 = {};
v134 = 19;
v143 = 353;
v144 = render.load_font("Calibri Bold", vector(25, 23.5, 0), "da");
v145 = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(30, 30));
v146 = function(v676)
    local v677 = ui.get_binds();
    for v678 = 1, #v677 do
        local v679 = v677[v678];
        if v679 then
            local l_name_0 = v679.name;
            if v676 == "Dormant aimbot" then
                l_name_0 = l_name_0:sub(#"\a{Link Active}" + 5 + #"\aDEFAULT", #l_name_0);
            end;
            if string.lower(l_name_0) == string.lower(v676) and v679.active then
                return true;
            end;
        end;
    end;
    return false;
end;
do
    local l_v127_14, l_v134_12, l_v143_7, l_v144_4, l_v145_3, l_v146_3, l_v147_4, l_v148_4, l_v149_5, l_v150_5, l_v152_3, l_v153_3, l_v154_2 = v127, v134, v143, v144, v145, v146, v147, v148, v149, v150, v152, v153, v154;
    l_v147_4 = function(v694, v695, v696, v697)
        -- upvalues: l_v127_14 (ref)
        l_v127_14[#l_v127_14 + 1] = {
            text = v695, 
            color = v694, 
            progress = v696 or nil, 
            icon = v697 or nil
        };
    end;
    l_v148_4 = function(v698)
        return v698:get() or v698:get_override();
    end;
    l_v149_5 = function()
        -- upvalues: l_v148_4 (ref), v9 (ref)
        local v699 = utils.net_channel();
        if v699 == nil then
            return;
        else
            local v700 = (v699.sequence_nr[0] + v699.sequence_nr[1]) / math.min(math.max(l_v148_4(v9.misc.other.fake_latency) * 0.001 + 0, 0.001), 0.2);
            return math.clamp(-1.7014636E38, math.min(math.max(v700, 0), 1), v700);
        end;
    end;
    l_v150_5 = function(v701, v702)
        local v703 = 0.5;
        local v704 = 0.5;
        if v702 > 0 then
            local v705 = v701 * v703;
            if v702 < (v701 - v705) * v704 then
                v705 = v701 - v702 * (1 / v704);
            end;
            v701 = v705;
        end;
        return v701;
    end;
    l_v152_3 = function(v706, v707)
        -- upvalues: l_v150_5 (ref)
        local v708 = 500;
        local v709 = v708 * 3.5;
        local v710 = (v707:get_origin() - v706:get_eye_position()):length();
        local v711 = v709 / 3;
        local v712 = v708 * math.exp(-v710 * v710 / (2 * v711 ^ 2));
        return l_v150_5(v712, v706.m_ArmorValue);
    end;
    l_v153_3 = function(v713, v714)
        -- upvalues: l_v147_4 (ref), l_v145_3 (ref)
        local v715 = v714:get_player_weapon();
        if v715 == nil then
            return;
        elseif not v715.m_bStartedArming then
            return;
        else
            local l_m_fArmedTime_0 = v715.m_fArmedTime;
            if l_m_fArmedTime_0 == nil then
                return;
            else
                local v717 = v714:get_origin();
                local l_m_bombsiteCenterA_0 = v713.m_bombsiteCenterA;
                local l_m_bombsiteCenterB_0 = v713.m_bombsiteCenterB;
                local v720 = v717:distsqr(l_m_bombsiteCenterA_0) < v717:distsqr(l_m_bombsiteCenterB_0) and "B" or "A";
                local v721 = (l_m_fArmedTime_0 - globals.curtime) / 3.125;
                l_v147_4(color(252, 243, 105, 255), v720, 1 - v721, l_v145_3);
                return;
            end;
        end;
    end;
    l_v154_2 = function(v722, v723)
        -- upvalues: v56 (ref), l_v147_4 (ref), l_v145_3 (ref), l_v152_3 (ref)
        local l_m_bBombDefused_0 = v723.m_bBombDefused;
        if not v723.m_bBombTicking or l_m_bBombDefused_0 then
            return;
        else
            local l_curtime_0 = globals.curtime;
            local l_m_flC4Blow_0 = v723.m_flC4Blow;
            local v727 = l_m_flC4Blow_0 - l_curtime_0;
            if v727 > 0 then
                if v723.m_hBombDefuser ~= nil then
                    local l_m_flDefuseCountDown_0 = v723.m_flDefuseCountDown;
                    local v729 = (l_m_flDefuseCountDown_0 - l_curtime_0) / 10;
                    local v730 = l_m_flC4Blow_0 < l_m_flDefuseCountDown_0 and color(235, 50, 75, 125) or color(50, 235, 75, 125);
                    local v731 = (v56.y - 2) * (1 - v729);
                    render.rect(vector(0, 0), vector(20, v56.y), color(0, 0, 0, 115));
                    render.rect(vector(1, 1 + v731), vector(19, v56.y - 1), v730);
                end;
                local v732 = string.format("%s - %.1fs", v723.m_nBombSite == 1 and "B" or "A", v727);
                l_v147_4(color(255, 255, 255, 200), v732, nil, l_v145_3);
            end;
            local l_m_iHealth_0 = v722.m_iHealth;
            local v734 = l_v152_3(v722, v723);
            v734 = math.floor(v734);
            if l_m_iHealth_0 <= v734 then
                l_v147_4(color(255, 0, 50, 255), "FATAL", nil, nil);
            elseif v734 > 0 then
                l_v147_4(color(245, 236, 102, 255), string.format("-%d HP", v734), nil, nil);
            end;
            return;
        end;
    end;
    local function v742(v735)
        -- upvalues: l_v153_3 (ref), l_v154_2 (ref)
        local v736 = entity.get_game_rules();
        if v736 == nil then
            return;
        else
            local v737 = entity.get_player_resource();
            if v737 == nil then
                return;
            else
                local l_m_bBombPlanted_0 = v736.m_bBombPlanted;
                local l_m_iPlayerC4_0 = v737.m_iPlayerC4;
                if l_m_iPlayerC4_0 ~= nil and l_m_iPlayerC4_0 ~= 0 then
                    local v740 = entity.get(l_m_iPlayerC4_0);
                    if v740 ~= nil then
                        l_v153_3(v737, v740);
                    end;
                end;
                if l_m_bBombPlanted_0 then
                    local v741 = entity.get_entities("CPlantedC4")[1];
                    if v741 ~= nil then
                        l_v154_2(v735, v741);
                    end;
                end;
                return;
            end;
        end;
    end;
    local function v748(v743)
        -- upvalues: v14 (ref), l_v148_4 (ref), v9 (ref), l_v149_5 (ref), l_v147_4 (ref), l_v146_3 (ref), v742 (ref)
        local l_features_0 = v14.visuals.skeet_indicators.features;
        if #l_features_0:get() == 0 then
            return;
        else
            if v743:is_alive() then
                if l_features_0:get("Ping spike") and l_v148_4(v9.misc.other.fake_latency) > 0 then
                    local v745 = l_v149_5();
                    local v746 = color(255, 200):lerp(color(143, 194, 21, 255), v745);
                    l_v147_4(v746, "PING");
                end;
                if l_features_0:get("Duck peek assist") and l_v148_4(v9.antiaim.misc.fake_duck) then
                    l_v147_4(color(255, 200), "DUCK");
                end;
                if l_features_0:get("On shot anti-aim") and l_v148_4(v9.rage.main.hide_shots) and not l_v148_4(v9.rage.main.double_tap) then
                    l_v147_4(color(255, 200), "OSAA");
                end;
                if l_features_0:get("Double tap") and l_v148_4(v9.rage.main.double_tap) then
                    local v747 = rage.exploit:get() == 1 and color(255, 200) or color(255, 0, 50, 200);
                    l_v147_4(v747, "DT");
                end;
                if l_features_0:get("Dormant aimbot") and l_v146_3("Dormant aimbot") then
                    l_v147_4(color(255, 200), "DA");
                end;
                if l_features_0:get("Force safe point") and l_v148_4(v9.rage.selection.safe_points) == "Force" then
                    l_v147_4(color(255, 200), "SAFE");
                end;
                if l_features_0:get("Force body aim") and l_v148_4(v9.rage.selection.body_aim) == "Force" then
                    l_v147_4(color(255, 200), "BODY");
                end;
                if l_features_0:get("Minimum damage override") and l_v146_3("Min. Damage") then
                    l_v147_4(color(255, 200), "MD");
                end;
                if l_features_0:get("Hitchance override") and l_v146_3("Hit Chance") then
                    l_v147_4(color(255, 200), "H1TCHANCE");
                end;
                if l_features_0:get("Freestanding") and v14.antiaim.angles.freestanding.switch:get() then
                    l_v147_4(color(255, 200), "FS");
                end;
            end;
            if v14.visuals.skeet_indicators.bomb:get() then
                v742(v743);
            end;
            return;
        end;
    end;
    local function v753(v749, v750, v751, v752)
        render.circle_outline(v749, color(0, 255), v751, 0, 1, 5);
        render.circle_outline(v749, v750, v751 - 1, 0, v752, 3);
    end;
    local function v770()
        -- upvalues: l_v134_12 (ref), v56 (ref), l_v143_7 (ref), l_v127_14 (ref), l_v144_4 (ref), v753 (ref)
        local v754 = vector(l_v134_12, v56.y - l_v143_7);
        local v755 = vector();
        for v756 = 1, #l_v127_14 do
            local v757 = l_v127_14[v756];
            if v757.color ~= nil then
                local l_color_0 = v757.color;
                local l_text_1 = v757.text;
                local l_progress_0 = v757.progress;
                local l_icon_0 = v757.icon;
                local v762 = render.measure_text(l_v144_4, "da", l_text_1) + vector(40, 0);
                v762.y = v762.y * 1.19;
                if l_icon_0 ~= nil then
                    v762.x = v762.x + 35;
                end;
                if l_progress_0 ~= nil then
                    v762.x = v762.x - 16;
                end;
                local v763 = v754 + v755 - vector(l_v134_12, 4);
                local v764 = v754 + v762 + v755 + vector(0, 1);
                local v765 = color(0, 0);
                local v766 = color(0, 70);
                local v767 = (v763 + v764) / 2;
                render.gradient(v763, vector(v767.x, v764.y), v765, v766, v765, v766);
                render.gradient(v764, vector(v767.x, v763.y), v765, v766, v765, v766);
                if l_icon_0 ~= nil then
                    render.texture(l_icon_0, v754 + vector(11, -2) + v755, l_color_0, "f");
                end;
                render.text(l_v144_4, v754 + vector(10 + (l_icon_0 and 37 or 0), 3) + v755, l_color_0, "d", l_text_1);
                if l_progress_0 ~= nil then
                    local v768 = 10;
                    local v769 = v754 + vector(v762.x) + v755;
                    v753(v769 + vector(v768 / 2, v762.y / 2) - vector(0, 1), color(255, 200), v768, l_progress_0);
                end;
                v755 = v755 - vector(0, v762.y + 12.5);
            end;
        end;
    end;
    v36.draw = function()
        -- upvalues: v14 (ref), v748 (ref), v770 (ref), l_v127_14 (ref)
        if not v14.visuals.skeet_indicators.switch:get() then
            return;
        elseif not globals.is_in_game then
            return;
        else
            local v771 = entity.get_local_player();
            if not v771 then
                return;
            else
                v748(v771);
                v770();
                l_v127_14 = {};
                return;
            end;
        end;
    end;
end;
v37.window = v11.new("velocity_warning", vector(v56.x / 2, v56.y * 0.2));
v127 = 0;
v134 = 0;
do
    local l_v127_15, l_v134_13 = v127, v134;
    v37.frame = function()
        -- upvalues: v37 (ref), v14 (ref), l_v127_15 (ref), v13 (ref), l_v134_13 (ref)
        local v774 = entity.get_local_player();
        if v774 == nil then
            return;
        else
            local l_window_1 = v37.window;
            local l_m_flVelocityModifier_0 = v774.m_flVelocityModifier;
            local v777 = ui.get_alpha() > 0;
            local v778 = v774:is_alive();
            local v779 = l_m_flVelocityModifier_0 < 1;
            local v780 = l_window_1:is_dragging();
            local v781 = v14.visuals.velocity_warning.switch:get() and (v778 and v779 or v777);
            local v782 = 0.05;
            l_v127_15 = v13.interp(l_v127_15, v781, v782);
            l_v134_13 = v13.interp(l_v134_13, v781 and v780 and 0.6 or 1, v782);
            if l_v127_15 <= 0 then
                return;
            else
                if v777 and (not v779 or not v778) then
                    l_m_flVelocityModifier_0 = math.min(1, globals.tickcount % 200 / 150);
                end;
                local v783 = l_v127_15 * l_v134_13;
                local v784 = v14.visuals.velocity_warning.color:get();
                local l_position_1 = l_window_1.position;
                local v786 = l_window_1.size + vector(0, 2);
                local v787 = ("Max velocity was reduced by %d%%"):format(l_m_flVelocityModifier_0 * 100);
                local v788 = render.measure_text(1, "", v787);
                local v789 = l_position_1 + vector(9, 24);
                local v790 = vector(v786.x, 4);
                render.text(1, l_position_1 + vector(19, 7), color(255, 255, 255, v784.a * v783), nil, v787);
                render.rect(v789 - vector(1, 1), v789 + v790 + vector(1, 1), color(0, v783 * v784.a), 2);
                render.rect(v789, v789 + vector(v790.x * v783 * l_m_flVelocityModifier_0, v790.y), v784:alpha_modulate(v784.a * v783), 2);
                l_window_1:update(vector(math.max(v788.x + 15, v790.x), v788.y + v790.y + 25), vector(10, -2));
                return;
            end;
        end;
    end;
end;
v127 = 0;
v134 = vector();
v143 = 0;
do
    local l_v127_16, l_v134_14, l_v143_8 = v127, v134, v143;
    v38.update = function(v794)
        -- upvalues: v14 (ref), l_v127_16 (ref), l_v134_14 (ref)
        if v794.state ~= nil then
            return;
        else
            local v795 = v14.visuals.hitmarker.time:get() / 10;
            local l_aim_0 = v794.aim;
            l_v127_16 = globals.realtime + v795;
            l_v134_14 = l_aim_0;
            return;
        end;
    end;
    v38.draw = function()
        -- upvalues: v14 (ref), v56 (ref), l_v143_8 (ref), v13 (ref), l_v127_16 (ref), l_v134_14 (ref)
        local v797 = entity.get_local_player();
        if v797 == nil or not v797:is_alive() then
            return;
        else
            local l_select_0 = v14.visuals.hitmarker.select;
            local v799 = v56 / 2;
            local v800 = {
                [1] = v14.visuals.hitmarker.color:get("2D")[1], 
                [2] = v14.visuals.hitmarker.color:get("3D")[1]
            };
            l_v143_8 = v13.interp(l_v143_8, globals.realtime <= l_v127_16, 0.025);
            if l_v143_8 <= 0 then
                return;
            else
                if l_select_0:get(1) then
                    local v801 = v800[1]:alpha_modulate(v800[1].a * l_v143_8);
                    local v802 = 5;
                    local v803 = 10;
                    render.line(v799 + vector(v802, v802), v799 + vector(v803 / v56.x * v56.x, v803 / v56.y * v56.y), v801);
                    render.line(v799 - vector(v802, -v802), v799 - vector(v803 / v56.x * v56.x, -(v803 / v56.y) * v56.y), v801);
                    render.line(v799 - vector(v802, v802), v799 - vector(v803 / v56.x * v56.x, v803 / v56.y * v56.y), v801);
                    render.line(v799 + vector(v802, -v802), v799 + vector(v803 / v56.x * v56.x, -(v803 / v56.y) * v56.y), v801);
                end;
                if l_select_0:get(2) then
                    local v804 = v800[2]:alpha_modulate(v800[2].a * l_v143_8);
                    if l_v134_14 == nil then
                        return;
                    else
                        local v805 = 5;
                        local v806 = l_v134_14:to_screen();
                        if v806 and v806.x ~= nil then
                            render.rect(v806 - vector(v805, 0), v806 + vector(v805, 0), v804);
                            render.rect(v806 - vector(0, v805), v806 + vector(0, v805), v804);
                        end;
                    end;
                end;
                return;
            end;
        end;
    end;
end;
v127 = 0;
do
    local l_v127_17 = v127;
    v39.update = function(_)
        -- upvalues: v14 (ref), l_v127_17 (ref), v13 (ref)
        local v809 = entity.get_local_player();
        if v809 == nil or not v809:is_alive() then
            return;
        else
            local v810 = v809:get_player_weapon();
            if v810 == nil then
                return;
            else
                local v811 = v810:get_weapon_info();
                if not v14.visuals.player_transparency.switch:get() then
                    return;
                else
                    if v809.m_bIsScoped or v809.m_bResumeZoom or v811.weapon_type == 9 then
                        l_v127_17 = v13.interp(l_v127_17, 59, 0.025);
                    else
                        l_v127_17 = v13.interp(l_v127_17, 255, 0.0125);
                    end;
                    return l_v127_17;
                end;
            end;
        end;
    end;
end;
v40.window = v11.new("damage_indicator", vector(v56.x * 0.5, v56.y * 0.49));
v127 = 0;
v134 = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage");
do
    local l_v127_18, l_v134_15 = v127, v134;
    v40.frame = function()
        -- upvalues: v40 (ref), l_v134_15 (ref), v14 (ref), l_v127_18 (ref), v13 (ref)
        local v814 = entity.get_local_player();
        if v814 == nil or not v814:is_alive() then
            return;
        else
            local l_window_2 = v40.window;
            local v816 = false;
            local v817 = l_v134_15:get();
            local v818 = ui.get_binds();
            for v819 = 1, #v818 do
                local v820 = v818[v819];
                if v820.name == "Min. Damage" then
                    v816 = v820.active;
                    v817 = v820.value;
                end;
            end;
            v818 = (not not v816 or ui.get_alpha() > 0) and v14.visuals.damage_indicator.switch:get();
            l_v127_18 = v13.interp(l_v127_18, v818 and l_window_2:is_dragging() and 0.6 or 1, 0.05);
            if not v818 then
                return;
            else
                render.text(1, l_window_2.position, color(255, 255 * l_v127_18), nil, v817);
                local v821 = render.measure_text(1, nil, v817) / 2;
                l_window_2:update(vector(math.max(v821.x, 10), v821.y + 10));
                return;
            end;
        end;
    end;
end;
v127 = ui.find("Visuals", "World", "Main", "Force Thirdperson");
do
    local l_v127_19 = v127;
    v41.draw_model = function(v823)
        -- upvalues: v14 (ref), l_v127_19 (ref)
        local v824 = entity.get_local_player();
        if v824 == nil or not v824:is_alive() then
            return;
        elseif not v14.visuals.remove_sleeves.switch:get() then
            return;
        elseif l_v127_19:get() or l_v127_19:get_override() then
            return;
        elseif v823.name:find("sleeve") then
            return false;
        else
            return true;
        end;
    end;
end;
v127 = function(v825, v826)
    -- upvalues: v14 (ref)
    if not v14.misc.movement.fall_damage:get() then
        return false;
    else
        local v827 = v825:get_origin();
        local v828 = 2 * math.pi;
        for v829 = 0, v828, v828 / 8 do
            local v830 = math.sin(v829);
            local v831 = math.cos(v829);
            local v832 = v827 + vector(10 * v831, 10 * v830, 0);
            local v833 = v832 - vector(0, 0, v826);
            if utils.trace_line(v832, v833, v825).fraction ~= 1 then
                return true;
            end;
        end;
        return false;
    end;
end;
do
    local l_v127_20 = v127;
    v42.createmove = function(v835)
        -- upvalues: v14 (ref), l_v127_20 (ref)
        if not v14.misc.movement.fall_damage:get() then
            return false;
        else
            local v836 = entity.get_local_player();
            if v836 == nil or not v836:is_alive() then
                return;
            elseif v836.m_MoveType == 9 or v836.m_MoveType == 8 then
                return;
            else
                if v836.m_vecVelocity.z < -500 then
                    v835.in_duck = not l_v127_20(v836, 15) and l_v127_20(v836, 75);
                end;
                return;
            end;
        end;
    end;
end;
v127 = function(v837)
    if v837.m_MoveType ~= 9 then
        return false;
    elseif bit.band(v837.m_fFlags, 1) == 1 then
        return false;
    else
        return true;
    end;
end;
v134 = function(v838)
    if v838:get_weapon_info().weapon_type ~= 9 then
        return false;
    else
        local l_m_fThrowTime_0 = v838.m_fThrowTime;
        if l_m_fThrowTime_0 == nil or l_m_fThrowTime_0 == 0 then
            return false;
        else
            return true;
        end;
    end;
end;
do
    local l_v127_21, l_v134_16 = v127, v134;
    v43.createmove = function(v842)
        -- upvalues: v14 (ref), l_v127_21 (ref), l_v134_16 (ref)
        if not v14.misc.movement.fast_ladder:get() then
            return;
        else
            local v843 = entity.get_local_player();
            if v843 == nil or not v843:is_alive() or not l_v127_21(v843) then
                return;
            else
                local v844 = v843:get_player_weapon();
                if v844 == nil or l_v134_16(v844) then
                    return;
                else
                    local l_m_vecLadderNormal_0 = v843.m_vecLadderNormal;
                    if l_m_vecLadderNormal_0:lengthsqr() == 0 then
                        return;
                    else
                        local _ = render.camera_angles();
                        local _ = l_m_vecLadderNormal_0:angles();
                        local l_sidemove_1 = v842.sidemove;
                        local l_forwardmove_1 = v842.forwardmove;
                        if l_sidemove_1 == 0 then
                            v842.view_angles.y = v842.view_angles.y + 45;
                        end;
                        if l_forwardmove_1 > 0 then
                            if l_sidemove_1 > 0 then
                                v842.view_angles.y = v842.view_angles.y - 1;
                            end;
                            if l_sidemove_1 < 0 then
                                v842.view_angles.y = v842.view_angles.y + 90;
                            end;
                        end;
                        if l_forwardmove_1 < 0 then
                            if l_sidemove_1 < 0 then
                                v842.view_angles.y = v842.view_angles.y - 1;
                            end;
                            if l_sidemove_1 > 0 then
                                v842.view_angles.y = v842.view_angles.y + 90;
                            end;
                        end;
                        v842.in_moveleft = l_forwardmove_1 < 0 and 1 or 0;
                        v842.in_moveright = l_forwardmove_1 > 0 and 1 or 0;
                        v842.view_angles.x = -30;
                        return;
                    end;
                end;
            end;
        end;
    end;
end;
v127 = function(v850, v851, v852)
    v851.in_duck = v852;
    v850:think(1);
end;
v134 = function(v853, v854)
    -- upvalues: v59 (ref), v14 (ref)
    if v854.m_MoveType == 9 or v854.m_MoveType == 8 then
        return false;
    elseif v853.in_duck then
        return false;
    elseif bit.band(v854.m_fFlags, v59.FL_ONGROUND) ~= 0 then
        return false;
    elseif v14.misc.movement.fall_damage:get() and v854.m_vecVelocity.z <= -500 then
        return false;
    else
        return true;
    end;
end;
do
    local l_v127_22, l_v134_17 = v127, v134;
    v44.createmove = function(v857)
        -- upvalues: v14 (ref), l_v134_17 (ref), l_v127_22 (ref), v59 (ref)
        if not v14.misc.movement.air_duck_collision:get() then
            return;
        else
            local v858 = entity.get_local_player();
            if v858 == nil or not v858:is_alive() then
                return;
            elseif not l_v134_17(v857, v858) then
                return;
            else
                local v859 = v858:simulate_movement();
                l_v127_22(v859, v857, true);
                local v860 = bit.band(v859.flags, v59.FL_ONGROUND) == 0 and v859.did_hit_collision;
                l_v127_22(v859, v857, false);
                local v861 = bit.band(v859.flags, v59.FL_ONGROUND) == 0 and v859.did_hit_collision;
                if not v860 and v861 then
                    v857.in_duck = true;
                end;
                return;
            end;
        end;
    end;
end;
v127 = function(v862)
    if v862.m_MoveType == 9 or v862.m_MoveType == 8 then
        return false;
    else
        return true;
    end;
end;
do
    local l_v127_23 = v127;
    v45.createmove = function(v864)
        -- upvalues: v14 (ref), l_v127_23 (ref)
        if not v14.misc.movement.edge_quick_stop:get() then
            return;
        else
            local v865 = entity.get_local_player();
            if v865 == nil or not v865:is_alive() then
                return;
            elseif not l_v127_23(v865) then
                return;
            else
                local v866 = v865:simulate_movement();
                v866:think(4);
                if v866.velocity.z < 0 then
                    v864.block_movement = 2;
                end;
                return;
            end;
        end;
    end;
end;
v127 = false;
v134 = nil;
v143 = function()
    -- upvalues: v59 (ref)
    local v867 = entity.get_local_player();
    if v867 == nil or not v867:is_alive() then
        return;
    else
        local v868 = v867:get_origin();
        if bit.band(v867.m_fFlags, v59.FL_ONGROUND) == 0 then
            return utils.trace_line(v868, v868 - vector(0, 0, 8192), v867, 33636363).end_pos;
        else
            return v868;
        end;
    end;
end;
v144 = function(_, v870)
    -- upvalues: v10 (ref)
    local v871 = v870:get_player_weapon();
    if v871 == nil then
        return false;
    else
        local v872 = v871:get_weapon_info();
        if not v10.is_airborne then
            return false;
        elseif v872.weapon_type == 9 and v871.m_fThrowTime ~= nil and v871.m_fThrowTime ~= 0 then
            return true;
        else
            return false;
        end;
    end;
end;
v145 = function(v873, v874, v875)
    local v876 = v875 - v874:get_origin();
    if v876:length2dsqr() < 25 then
        local l_m_vecVelocity_1 = v874.m_vecVelocity;
        local v878 = l_m_vecVelocity_1:length();
        v873.move_yaw = l_m_vecVelocity_1:angles().y;
        v873.forwardmove = -v878;
        v873.sidemove = 0;
        return;
    else
        v873.move_yaw = v876:angles().y;
        v873.forwardmove = 450;
        v873.sidemove = 0;
        return;
    end;
end;
do
    local l_v127_24, l_v134_18, l_v143_9, l_v144_5, l_v145_4 = v127, v134, v143, v144, v145;
    v46.createmove = function(v884)
        -- upvalues: v14 (ref), l_v127_24 (ref), l_v134_18 (ref), v10 (ref), l_v144_5 (ref), l_v145_4 (ref)
        if not v14.misc.movement.skeet_retreat:get() then
            l_v127_24 = false;
            return;
        else
            local v885 = entity.get_local_player();
            if v885 == nil or not v885:is_alive() then
                l_v127_24 = false;
                return;
            elseif l_v134_18 == nil then
                l_v127_24 = false;
                return;
            else
                local v886 = (v885:get_origin() - l_v134_18):lengthsqr();
                if v886 < 50 and not v10.is_airborne then
                    l_v127_24 = false;
                end;
                if l_v144_5(v884, v885, v886) then
                    l_v127_24 = true;
                end;
                if l_v127_24 then
                    l_v145_4(v884, v885, l_v134_18);
                end;
                return;
            end;
        end;
    end;
    v9.rage.main.peek_assist[1]:set_callback(function(v887)
        -- upvalues: l_v134_18 (ref), l_v143_9 (ref)
        l_v134_18 = v887:get() and l_v143_9() or nil;
    end);
end;
v127 = false;
v134 = nil;
v143 = nil;
v144 = nil;
do
    local l_v127_25, l_v134_19, l_v143_10, l_v144_6 = v127, v134, v143, v144;
    v145 = function()
        -- upvalues: l_v143_10 (ref), l_v144_6 (ref)
        l_v143_10 = nil;
        l_v144_6 = nil;
    end;
    v47.prediction = function(v892)
        -- upvalues: v14 (ref), l_v144_6 (ref), l_v143_10 (ref), l_v127_25 (ref), l_v134_19 (ref)
        if not v14.misc.aimbot.grenade_release.switch:get() then
            return;
        elseif v892.type == nil then
            return;
        else
            l_v144_6 = v892.type;
            local v893 = v14.misc.aimbot.grenade_release.damage:get();
            local v894 = v14.misc.aimbot.grenade_release.molly_distance:get() * 0.01;
            local v895 = v893 ~= 0 and v893 < v892.damage or v892.fatal;
            if v892.type == "Molly" and v892.target ~= nil then
                local v896 = false;
                local v897 = v892.path[#v892.path];
                if v897 ~= nil and v897:dist(v892.target:get_origin()) / 100 < v894 then
                    v896 = true;
                end;
                v895 = v896;
            end;
            if v895 then
                local v898 = 1;
                if #v892.collisions >= 5 then
                    v898 = 2;
                end;
                l_v143_10 = v892.collisions[#v892.collisions - v898];
                l_v127_25 = true;
                l_v134_19 = render.camera_angles();
            end;
            return;
        end;
    end;
    v47.render = function()
        -- upvalues: v14 (ref), l_v144_6 (ref), l_v143_10 (ref)
        if not v14.misc.aimbot.grenade_release.switch:get() then
            return;
        elseif not v14.misc.aimbot.grenade_release.collision_info:get() then
            return;
        else
            local v899 = entity.get_local_player();
            if v899 == nil or not v899:is_alive() then
                return;
            elseif l_v144_6 == nil then
                return;
            else
                local l_l_v143_10_0 = l_v143_10;
                if l_l_v143_10_0 == nil then
                    return;
                else
                    local v901 = v14.misc.aimbot.grenade_release.damage:get();
                    local v902 = string.format("FOUND COLLISION WITH %s DAMAGE", v901 == 0 and "FATAL" or v901);
                    if l_v144_6 == "Molly" then
                        v902 = string.format("FOUND COLLISION WITH %.2f DIST", v14.misc.aimbot.grenade_release.molly_distance:get() * 0.01);
                    end;
                    local v903 = render.measure_text(2, nil, v902);
                    if l_l_v143_10_0:to_screen() ~= nil then
                        render.text(2, l_l_v143_10_0:to_screen() - vector(v903.x / 2, -5), color(255, 20, 20, 255), nil, v902);
                    end;
                    return;
                end;
            end;
        end;
    end;
    v47.grenade_override_view = function(v904)
        -- upvalues: v14 (ref)
        if not v14.misc.aimbot.grenade_release.switch:get() then
            return;
        else
            local v905 = entity.get_local_player();
            if v905 == nil or not v905:is_alive() then
                return;
            else
                local v906 = v905:simulate_movement();
                v906:think(2);
                v904.velocity = v906.velocity;
                return;
            end;
        end;
    end;
    v47.createmove = function(v907)
        -- upvalues: v14 (ref), l_v127_25 (ref), l_v134_19 (ref)
        if not v14.misc.aimbot.grenade_release.switch:get() then
            return;
        else
            local v908 = entity.get_local_player();
            if v908 == nil or not v908:is_alive() then
                return;
            else
                local v909 = v908:get_player_weapon();
                if v909 == nil then
                    return;
                else
                    if l_v127_25 and v909.m_bPinPulled and l_v134_19 ~= nil then
                        render.camera_angles(l_v134_19);
                        v907.in_attack = false;
                    end;
                    l_v134_19 = nil;
                    l_v127_25 = false;
                    return;
                end;
            end;
        end;
    end;
end;
events.aim_ack(v38.update);
events.aim_ack(v31.update);
events.player_hurt(v31.player_hurt);
events.player_death(v24.player_death);
events.bullet_impact(v24.bullet_impact);
events.render(v47.render);
events.render(v38.draw);
events.render(v37.frame);
events.render(v40.frame);
events.render(v36.draw);
events.render(v35.draw);
events.render(v34.draw);
events.render(v33.draw);
events.render(v32.frame);
events.render(v30.draw);
events.render(v15.draw);
events.localplayer_transparency(v39.update);
events.draw_model(v41.draw_model);
events.grenade_override_view(v47.grenade_override_view);
events.grenade_prediction(v47.prediction);
events.createmove(v47.createmove);
events.createmove(v42.createmove);
events.createmove(v43.createmove);
events.createmove(v44.createmove);
events.createmove(v45.createmove);
events.createmove(v29.createmove);
events.createmove(v46.createmove);
events.createmove_run(v28.createmove);
events.createmove(v27.createmove);
events.createmove(v25.update);
events.post_update_clientside_animation(v27.post_update_clientside_animation);
events.override_view(v29.override_view);
events.net_update_end(v10.net_update_end);
events.shutdown(v16.save_database);
l_pui_0.setup(v14);