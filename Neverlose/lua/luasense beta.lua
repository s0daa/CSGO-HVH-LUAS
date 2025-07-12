local l_clipboard_0 = require("neverlose/clipboard");
local l_pui_0 = require("neverlose/pui");
local l_inspect_0 = require("neverlose/inspect");
local l_gradient_0 = require("neverlose/gradient");
local _ = require("neverlose/base64");
local l_smoothy_0 = require("neverlose/smoothy");
local _ = require("neverlose/voice_listener");
local v7 = {};
local v8 = {};
local v9 = {};
local v10 = {};
local v11 = {};
local v12 = {};
local v13 = {};
local v14 = {};
local _ = {};
local v16 = {};
local _ = {};
local _ = {};
local v19 = {};
v19 = {
    common = {
        get_username = common.get_username, 
        get_time = common.get_time
    }, 
    entity = {
        get = entity.get, 
        get_local_player = entity.get_local_player
    }, 
    render = {
        measure_text = render.measure_text, 
        text = render.text, 
        rect = render.rect, 
        circle = render.circle, 
        shadow = render.shadow, 
        screen_size = render.screen_size(), 
        screen_center = render.screen_size() / 2
    }, 
    math = {
        floor = math.floor, 
        ceil = math.ceil, 
        min = math.min, 
        max = math.max, 
        abs = math.abs, 
        difference = math.difference, 
        normalize_yaw = math.normalize_yaw, 
        lerp = function(v20, v21, v22)
            return v20 + v22 * (v21 - v20);
        end
    }, 
    string = {
        format = string.format, 
        lower = string.lower, 
        find = string.find
    }, 
    utils = {
        random_int = utils.random_int, 
        random_float = utils.random_float
    }, 
    globals = {
        realtime = globals.realtime, 
        curtime = globals.curtime, 
        frametime = globals.frametime, 
        tickcount = globals.tickcount, 
        commandack = globals.commandack
    }, 
    ui = {
        getalpha = ui.get_alpha, 
        get_icon = ui.get_icon, 
        get_style = ui.get_style
    }, 
    colors = {
        black = color(0, 0, 0, 255), 
        white = color(255, 255, 255, 255), 
        transparent = color(0, 0, 0, 0)
    }, 
    entity_methods = {
        is_enemy = function(v23)
            return v23:is_enemy();
        end, 
        is_alive = function(v24)
            return v24:is_alive();
        end, 
        get_player_weapon = function(v25)
            return v25:get_player_weapon();
        end, 
        get_name = function(v26)
            return v26:get_name();
        end
    }, 
    string_ops = {
        to_hex = function(v27)
            return v27:to_hex();
        end, 
        alpha_modulate = function(v28, v29)
            return v28:alpha_modulate(v29);
        end
    }, 
    events = {
        register = v11.register, 
        set = function(v30, v31)
            events[v30]:set(v31);
        end
    }, 
    hitgroups = {
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
    weapon_actions = {
        inferno = "Burned", 
        knife = "Knifed", 
        hegrenade = "Naded"
    }, 
    print = {
        raw = print_raw, 
        dev = print_dev
    }, 
    panorama = {
        get_name = panorama.MyPersonaAPI.GetName, 
        get_xuid = panorama.MyPersonaAPI.GetXuid
    }
};
local v32 = "BETA";
local v54 = new_class():struct("core")({
    username = v19.common.get_username(), 
    steamid = v19.panorama.get_xuid(), 
    steam_name = v19.panorama.get_name(), 
    screen_size = v19.render.screen_size, 
    screen_center = v19.render.screen_center, 
    dpi_scale = v19.render.screen_size / vector(2560, 1440), 
    hitgroups = v19.hitgroups, 
    wpn2act = v19.weapon_actions, 
    branded_printing = function(_, v34)
        -- upvalues: v9 (ref), v19 (ref)
        local v35 = v9.visuals.accent:get();
        local v36 = v19.string.format("[%s] %s", "\a" .. v19.string_ops.to_hex(v35) .. "Lua\aDEFAULTSense", v34);
        v19.print.raw(v36);
        v19.print.dev(v36);
    end, 
    with_icon = function(_, v38, v39, v40)
        -- upvalues: v19 (ref)
        local v41 = v19.ui.get_icon(v38);
        if v40 ~= nil then
            v41 = "\a" .. (type(v40) == "string" and v40 or v19.string_ops.to_hex(v40)) .. v41 .. "\aDEFAULT";
        end;
        return v41 .. " " .. v39;
    end, 
    gradient = l_gradient_0.text_animate("S E N S E", -2, {
        color(255, 255, 255), 
        color(91, 91, 91)
    })
}):struct("shared")({
    data = {
        team = 0, 
        throw_time = 0, 
        pin_pulled = false, 
        movetype = -1, 
        able_to_render = false, 
        scoped = false
    }, 
    collect = function(v42)
        local v43 = entity.get_local_player();
        if v43 == nil then
            return;
        elseif not v43:is_alive() then
            return;
        else
            v42.data.localplayer = v43;
            local v44 = v43:get_player_weapon();
            if v44 == nil then
                return;
            else
                v42.data.scoped = v43.m_bIsScoped;
                v42.data.movetype = v43.m_MoveType;
                v42.data.pin_pulled = v44.m_bPinPulled;
                v42.data.throw_time = v44.m_fThrowTime;
                v42.data.team = v43.m_iTeamNum;
                v42.data.velocity = v43.m_vecVelocity;
                return;
            end;
        end;
    end, 
    collect_render_info = function(v45)
        local l_localplayer_0 = v45.data.localplayer;
        if l_localplayer_0 == nil then
            return;
        elseif not l_localplayer_0 then
            return;
        elseif not l_localplayer_0:is_alive() then
            v45.data.able_to_render = false;
            return;
        else
            v45.data.able_to_render = true;
            return;
        end;
    end
}):struct("safecall")({
    execute = function(_, v48, v49, v50)
        -- upvalues: l_inspect_0 (ref)
        return function(...)
            -- upvalues: v50 (ref), v48 (ref), v49 (ref), l_inspect_0 (ref)
            local l_status_0, l_result_0 = pcall(v50, ...);
            if not l_status_0 then
                local v53 = "safe call failed [" .. v48 .. "] -> " .. l_result_0;
                if v49 then
                    print_raw(v53, "\npayload->", l_inspect_0({
                        ...
                    }));
                end;
                return false, v53;
            else
                return l_result_0, l_status_0;
            end;
        end;
    end
}):struct("refs")({
    weapon_action = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"), 
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
    base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
    offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
    backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"), 
    jitter = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
    jitter_val = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"), 
    body_yaw = {
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")
    }, 
    freestand = {
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"), 
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")
    }, 
    def = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
    legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"), 
    slow = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
    fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"), 
    scope_type = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"), 
    hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
    inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
    fakelag = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"), 
    freestand_bind = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
    hideshot_config = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
    autopeek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"), 
    fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")
});
local v55 = ui.find("Miscellaneous", "Main", "Movement", "Quick Stop");
local l_core_0 = v54.core;
l_core_0.shared_data = v54.shared.data;
v11.register = function(v57, v58, v59)
    -- upvalues: v54 (ref)
    events[v57]:set(v54.safecall:execute(v58, v57 ~= "shutdown", v59));
end;
local v60 = {
    black = color(0, 255), 
    white = color(255)
};
getmetatable(color()).override = function(v61, v62, v63)
    local v64 = v61:clone();
    v64[v62] = v63;
    return v64;
end;
local v65 = nil;
v65 = {};
local v66 = 2.2222222222222223;
v65.difference = function(v67, v68)
    return math.abs(v67 - v68);
end;
do
    local l_v66_0 = v66;
    v65.color_lerp = function(v70, v71, v72)
        -- upvalues: l_v66_0 (ref)
        local v73 = globals.frametime * 100;
        return v70:lerp(v71, v72 * math.min(v73, l_v66_0));
    end;
    v65.lerp = function(v74, v75, v76)
        if v74 == v75 then
            return v75;
        else
            v76 = v76 * (globals.frametime * 170);
            local v77 = v74 + (v75 - v74) * v76;
            if math.abs(v77 - v75) < 0.01 then
                return v75;
            else
                return v77;
            end;
        end;
    end;
    math.normalize_yaw = math.normalize_yaw;
end;
local l_manager_0 = new_class():struct("manager")({
    base_speed = 0.07, 
    _list = {}, 
    new = function(v78, v79, v80, v81, v82)
        -- upvalues: v65 (ref)
        if not v81 then
            v81 = v78.base_speed;
        end;
        local v83 = type(v80) ~= "number";
        if v78._list[v79] == nil then
            v78._list[v79] = v82 and v82 or v83 and color(0, 0, 0, 0) or 0;
        end;
        local v84 = v83 and v80.lerp or v65.lerp;
        v78._list[v79] = v84(v78._list[v79], v80, v81);
        return v78._list[v79];
    end, 
    get = function(v85, v86)
        return v85._list[v86];
    end, 
    reset = function(v87, v88)
        v87._list[v88] = nil;
    end, 
    clear = function(v89)
        v89._list = {};
    end
}).manager;
local v91 = {
    conditions = {
        [1] = "Standing", 
        [2] = "Running", 
        [3] = "Slowmotion", 
        [4] = "Crouch", 
        [5] = "Crouch Moving", 
        [6] = "Air", 
        [7] = "Air Crouch", 
        [8] = "Manual"
    }, 
    cheats = {
        [1] = "NL", 
        [2] = "GS"
    }
};
local function v95(v92, v93, v94)
    -- upvalues: l_pui_0 (ref), l_core_0 (ref)
    return l_pui_0.create(l_core_0:with_icon(v92, "", "{Link Active}"), v93, v94);
end;
local v96 = v95("igloo", "", 1);
local _ = v95("igloo", "", 1);
local _ = v95("igloo", "\nchooser", 1);
local v99 = v95("igloo", "Links", 1);
local v100 = v95("igloo", "Discord", 1);
local v101 = v95("igloo", "\nconfigs2", 2);
local v102 = v95("igloo", "\nconfigs", 2);
local v103 = v95("atom", "\ncurrent state", 2);
local v104 = v95("atom", "\n233332", 2);
local v105 = v95("atom", "\n2332", 2);
local v106 = v95("atom", "\nTickbase", 2);
local v107 = v95("atom", "", 2);
local _ = v95("atom", "\n4", 1);
local v109 = v95("atom", "\nlister", 1);
local v110 = v95("atom", "\n", 1);
local v111 = v95("atom", "\nextra1", 1);
local v112 = v95("atom", "\nextra", 2);
local _ = v95("atom", "\n5", 1);
local v114 = v95("atom", "Defensive", 1);
local v115 = v95("rectangles-mixed", "\nvisuals2", 2);
local v116 = v95("rectangles-mixed", "\ntab selector", 1);
local v117 = v95("rectangles-mixed", "Visuals", 1);
local v118 = v95("rectangles-mixed", "Movement", 1);
local v119 = v95("rectangles-mixed", "Extra", 2);
local _ = v95("rectangles-mixed", "\nvisuals", 2);
local v121 = v95("rectangles-mixed", "Widgets\nwidgets", 2);
local v122 = v95("rectangles-mixed", "\nPing Spike");
local v123 = {
    [1] = nil, 
    [2] = nil, 
    [3] = nil, 
    [4] = nil, 
    [5] = nil, 
    [6] = "------------------------------------------", 
    [7] = "Create new config...", 
    [1] = l_core_0:with_icon("star-christmas", " Meta - \a55555586japan (new settings)", "{Link Active}"), 
    [2] = l_core_0:with_icon("sun", " Aggressive [fixed] - \a55555586brandon", "{Link Active}"), 
    [3] = l_core_0:with_icon("soap", " Snap [test] - \a55555586japan", "{Link Active}"), 
    [4] = l_core_0:with_icon("gitter", " Custom Jitter - \a55555586brandon", "{Link Active}"), 
    [5] = l_core_0:with_icon("cow", " Dynamic - \a55555586japan [cloud]", "{Link Active}")
};
local v124 = {
    github_token = "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", 
    github_api_url = "https://api.github.com/repos/zxjapan/ls_config/contents/codes.txt", 
    db_key = "userverified", 
    github_url = "https://raw.githubusercontent.com/zxjapan/ls_config/refs/heads/main/codes.txt"
};
local _ = "\226\128\138";
if ({
    xRazor = true, 
    Andreic2001 = true, 
    lostdiamonds = true, 
    benceorosz = true, 
    robertica = true, 
    Netflix234 = true, 
    ceenai = true, 
    david2020 = true
})[common.get_username()] then
    error("blacklisted");
    return;
else
    v9 = {
        main = {
            username = v96:label(l_core_0:with_icon("person-circle-question", "   User\n", "{Link Active}")), 
            user_button = v96:button(common.get_username(), nil, true), 
            version = v96:label(l_core_0:with_icon("code-commit", "  Version\n", "{Link Active}")), 
            version_button = v96:button("3.00.zb1", nil, true), 
            scripts = v99:label("Scripts\n"), 
            live_button = v99:button(l_core_0:with_icon("circle-1", " Live\n", "{Link Active}"), function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=luasense");
            end, true), 
            beta_button = v99:button(l_core_0:with_icon("circle-2", " Beta", "{Link Active}"), function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=byAMx1");
            end, true), 
            configs = v99:label("Brandon configs\n"), 
            live_button2 = v99:button(l_core_0:with_icon("square-1", " Live\n", "{Link Active}"), function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=RuE7C8");
            end, true), 
            beta_button2 = v99:button(l_core_0:with_icon("square-2", " Beta", "{Link Active}"), function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=MAxYSG");
            end, true), 
            youtube = v99:label("Socials\n"), 
            yt_button = v99:button(l_core_0:with_icon("youtube", " YT\n", "{Link Active}"), function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@vorbic");
            end, true), 
            dc_label = v100:label(l_core_0:with_icon("bug", " Encounter any Bugs?\n", "{Link Active}")), 
            dc_button = v100:button(l_core_0:with_icon("discord", " Join Us!\n", "{Link Active}"), function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/NgU7NzRxXr");
            end, true), 
            dc_label = v100:label(l_core_0:with_icon("check", " Want to verify?\n", "{Link Active}")), 
            verify_switch = v100:button("           Click me!           ", function()
                -- upvalues: v124 (ref)
                v124.check();
            end, false), 
            new_button = v102:button(l_core_0:with_icon("plus", " save \n"), function()
                -- upvalues: v7 (ref)
                v7.save_config();
            end, true), 
            import_button = v102:button(l_core_0:with_icon("up-from-line", " import \n", "{Link Active}"), function()
                -- upvalues: v7 (ref)
                v7.import_config();
            end, true), 
            export_button = v102:button(l_core_0:with_icon("down-from-line", " export \n", "{Link Active}"), function()
                -- upvalues: v7 (ref)
                v7.export_config();
            end, true), 
            load_button = v102:button(l_core_0:with_icon("plus", " load \n"), function()
                -- upvalues: v7 (ref)
                v7.load_config();
            end, true), 
            delete_button = v102:button("                                   \aFF0000FFdelete                                  \n", function()
                -- upvalues: v7 (ref)
                v7.delete_config();
            end, true), 
            input_name = v101:input("Config Name", "Type Here"), 
            preset_list = v101:list("", v8)
        }, 
        labels = {}, 
        rage = {
            state_label = v103:label("oh oh im not meant to be empty!"), 
            aa_lister = v109:list("\n", {
                l_core_0:with_icon("gears", "  Settings", "{Link Active}"), 
                l_core_0:with_icon("helmet-safety", "  Anti-Aim", "{Link Active}"), 
                l_core_0:with_icon("shield-plus", "  Defensive", "{Link Active}")
            }), 
            anims = {}, 
            team_list = v110:combo(l_core_0:with_icon("people-group", "  Choose Team", "{Link Active}"), {
                [1] = "T", 
                [2] = "CT"
            }), 
            state_list = v110:combo(l_core_0:with_icon("person-running", "   Anti-Aim State", "{Link Active}"), v91.conditions), 
            manual = v111:combo(l_core_0:with_icon("square-poll-horizontal", " Yaw Base", "{Link Active}"), "At Target", "Left", "Right", "Forward"), 
            freestanding_bind = v111:switch(l_core_0:with_icon("block-brick-fire", "  Freestanding", "{Link Active}"), false, function(v126)
                -- upvalues: v91 (ref)
                return {
                    prefer_manual = v126:switch("Prefer Manual AA"), 
                    keep_fs = v126:switch("Keep FS Enabled After Manual AA"), 
                    freestand_options = v126:selectable("Disablers", v91.conditions), 
                    freestand_enablers = v126:selectable("Enablers", v91.conditions), 
                    freestand_body = v126:list("Bodyyaw", {
                        [1] = "Static", 
                        [2] = "Jitter"
                    })
                }, false;
            end), 
            avoid_knife = v112:switch(l_core_0:with_icon("sword", "  Avoid Backstab", "{Link Active}"), false), 
            safe_head = v112:switch(l_core_0:with_icon("eye-slash", "  Hide Head", "{Link Active}"), false, function(v127)
                return {
                    safe_options = v127:listable("Conditions", {
                        [1] = "Standing", 
                        [2] = "Crouch", 
                        [3] = "Air Crouch Knife", 
                        [4] = "Distance", 
                        [5] = "Height Advantage", 
                        [6] = "Taser In Air"
                    })
                }, true;
            end), 
            hidden_builder = v114:switch("Hidden", false, function(v128)
                -- upvalues: v91 (ref)
                return {
                    state_list = v128:combo("Condition", v91.conditions), 
                    antiaim_label = v128:label(" "), 
                    antiaim_conditions = v128:selectable("Active On", v91.conditions), 
                    disablers = v128:selectable("Disablers", {
                        [1] = "Freestanding", 
                        [2] = "Manual aa", 
                        [3] = "Peek Assist"
                    }), 
                    on_exploit = v128:selectable("On Exploit", {
                        [1] = "Doubletap", 
                        [2] = "Hideshots"
                    }), 
                    antiaim_label = v128:label(" ")
                }, true;
            end), 
            anims = v112:switch(l_core_0:with_icon("flask-round-potion", "  Animations", "{Link Active}"), false, function(v129)
                return {
                    move_jitter_mode = v129:list("Jitter Mode", {
                        [1] = "Default", 
                        [2] = "Delta"
                    }), 
                    move_jitter = v129:slider("Jitter", 0, 10, 0, 1, function(v130)
                        if v130 == 0 then
                            return "Default";
                        else
                            return tostring(v130) .. "%";
                        end;
                    end), 
                    move_legs1 = v129:slider("Legs Delta 1", 0, 100, 0, 1, function(v131)
                        if v131 == 0 then
                            return "Default";
                        else
                            return tostring(v131) .. "%";
                        end;
                    end), 
                    move_legs2 = v129:slider("Legs Delta 2", 0, 100, 0, 1, function(v132)
                        if v132 == 0 then
                            return "Default";
                        else
                            return tostring(v132) .. "%";
                        end;
                    end), 
                    move_fall = v129:slider("Falling", 0, 10, 0, 1, function(v133)
                        if v133 == 0 then
                            return "Default";
                        else
                            return tostring(v133) .. "%";
                        end;
                    end), 
                    move_lean_val = v129:slider("Leaning", 0, 100, 0, 1, function(v134)
                        if v134 == 0 then
                            return "NL";
                        else
                            return tostring(v134);
                        end;
                    end)
                }, true;
            end), 
            additions = v112:selectable(l_core_0:with_icon("plus-large", "  Additions", "{Link Active}"), {
                [1] = "Warmup / Round End AA", 
                [2] = "No Fakelag on Exploits", 
                [3] = "Fluccate Fakelag on Body"
            })
        }, 
        defensive = {
            defensive_settings = v114:label(l_core_0:with_icon("helmet-safety", "  Defensive Settings", "{Link Active}"))
        }, 
        misc_chooser = v116:list("\n", {
            l_core_0:with_icon("palette", "  Visuals", "{Link Active}"), 
            l_core_0:with_icon("swatchbook", "  Misc", "{Link Active}")
        }), 
        visuals = {
            scope = {}, 
            accent = v115:color_picker(l_core_0:with_icon("image-landscape", "Accent", "{Link Active}"), color("96C83CFF")), 
            watermark_style = v115:list("", {
                [1] = "Legacy", 
                [2] = "Recode", 
                [3] = "Desync.Max"
            }), 
            watermark = v115:combo("Watermark Position", {
                [1] = "Left", 
                [2] = "Right", 
                [3] = "Bottom"
            }), 
            molotov_radius = v117:switch(l_core_0:with_icon("circle-xmark", "  Molotov Radius", "{Link Active}"), false), 
            smokes_radius = v117:switch(l_core_0:with_icon("circle", "  Smoke Radius", "{Link Active}"), false), 
            gs_inds = v117:switch(l_core_0:with_icon("badge-dollar", "  500$ Indicators", "{Link Active}"), false), 
            scope = v121:switch(l_core_0:with_icon("telescope", "  Scope Overlay", "{Link Active}"), false, function(v135)
                return {
                    scope_style = v135:list("Style", {
                        [1] = "Default", 
                        [2] = "T", 
                        [3] = "X"
                    }), 
                    scope_settings = v135:selectable("Settings", {
                        [1] = "Spread Based", 
                        [2] = "Glow", 
                        [3] = "Animated Zoom"
                    }), 
                    scope_size = v135:slider("Size", 0, 300, 100), 
                    scope_gap = v135:slider("Gap", 0, 300, 5), 
                    scope_color1 = v135:color_picker("Color", color(255, 255, 255, 255)), 
                    scope_color2 = v135:color_picker("Second Color", color(255, 255, 255, 0))
                }, true;
            end), 
            kibit_hitmark = v117:switch(l_core_0:with_icon("bullseye-arrow", "  Kibit Hitmarker", "{Link Active}"), false, function(v136)
                return {
                    kibit_hitmark_color = v136:color_picker("Color", color(88, 255, 209, 255))
                }, true;
            end), 
            notifs = v121:switch(l_core_0:with_icon("bell", "  Notifications", "{Link Active}"), false, function(v137)
                return {
                    notifs_prefix = v137:switch("Prefix infront of text"), 
                    notifs_prefix_font = v137:list("Font", {
                        [1] = "Default", 
                        [2] = "Small", 
                        [3] = "Console", 
                        [4] = "Bold"
                    }), 
                    notifs_prefix_clr = v137:color_picker("Prefix color", color(0, 255, 0, 255)), 
                    notifs_hit_clr = v137:color_picker("Hit color", color(0, 255, 0, 255)), 
                    notifs_miss_clr = v137:color_picker("Miss color", color(255, 0, 0, 255)), 
                    notifs_glow_amount = v137:slider("Glow amount", 0, 100, 41), 
                    notifs_round_amount = v137:slider("Rounded amount", 0, 15, 11)
                }, true;
            end), 
            slowed_down = v121:switch(l_core_0:with_icon("turtle", "  Slowed Down", "{Link Active}"), false)
        }, 
        misc = {
            aspect_ratio = v119:switch(l_core_0:with_icon("arrows-to-circle", "  Aspect Ratio Manager", "{Link Active}"), false), 
            no_fall = v118:switch(l_core_0:with_icon("person-falling", "  No Fall Damage", "{Link Active}"), false), 
            fast_ladder = v118:switch(l_core_0:with_icon("water-ladder", "  Fast Ladder", "{Link Active}"), false), 
            view_model_changer = v119:switch(l_core_0:with_icon("eye", "  View Model", "{Link Active}"), false), 
            clantag = v119:switch(l_core_0:with_icon("tag", "  Clantag [\vsynced\r]", "{Link Active}"), false), 
            log_event = v119:selectable(l_core_0:with_icon("calendar-star", "  Log Events", "{Link Active}"), {
                [1] = "Aimbot", 
                [2] = "Purchases"
            }), 
            client_nickname = v119:switch(l_core_0:with_icon("user", "  Client Sided Nickname", "{Link Active}"), false, function(v138)
                return {
                    client_nickname_text = v138:input("Nickname", "Type Here")
                }, true;
            end), 
            super_toss = v119:switch(l_core_0:with_icon("arrow-up-right-from-square", "  Super Toss", "{Link Active}"), false), 
            freeze_fakeduck = v118:switch(l_core_0:with_icon("duck", "  Freezetime Fakeduck", "{Link Active}"), false), 
            unlock_fakeduck = v118:switch(l_core_0:with_icon("unlock", "  Unlock Fakeduck Speed", "{Link Active}"), false), 
            fake_latency_toggle = v122:switch(l_core_0:with_icon("trash-clock", "  Fake Latency", "{Link Active}"), false, function(v139)
                -- upvalues: l_core_0 (ref)
                return {
                    fake_latency_slider = v139:slider(l_core_0:with_icon("trash-clock", " Fake Latency", "{Link Active}"), 0, 200, 0, 1, "ms")
                }, true;
            end)
        }
    };
    v9.rage.hidden_builder:visibility(false);
    v9.defensive.defensive_conditions = v9.defensive.defensive_settings:create():selectable("Conditions", v91.conditions);
    v9.defensive.game_events = v9.defensive.defensive_settings:create():selectable("Game Events", {
        [1] = "Weapon Switch", 
        [2] = "Weapon Reload"
    });
    v9.defensive.force_hideshot = v9.defensive.defensive_settings:create():switch("Force On Hideshots");
    v9.capitalize = function(v140)
        return (v140:gsub("^%l", string.upper));
    end;
    v9.menu_handler = function()
        -- upvalues: v106 (ref), l_core_0 (ref), v104 (ref), v105 (ref), v9 (ref), v107 (ref), v91 (ref)
        local v141 = {};
        local v142 = {};
        local function v160(v143)
            -- upvalues: v141 (ref), v106 (ref), l_core_0 (ref), v104 (ref), v105 (ref), v9 (ref), v107 (ref)
            v141[v143] = {};
            v141[v143].defensive_tickbase = v106:slider(l_core_0:with_icon("shield-check", "   \aFFF800FFTickbase", "\aFFF800FF"), 0, 1, 0, 1, function(v144)
                return v144 == 0 and "Neverlose" or "LuaSense";
            end);
            v141[v143].tick_random = v141[v143].defensive_tickbase:create():switch("Random choke\n" .. v143, false);
            v141[v143].tick_speed1 = v141[v143].defensive_tickbase:create():slider("Choke\n" .. v143, 1, 22, 1, 1, function(v145)
                return v145 == 16 and "Neverlose" or tostring(v145);
            end);
            v141[v143].tick_speed2 = v141[v143].defensive_tickbase:create():slider("Choke 2nd\n" .. v143, 1, 22, 1, 1, function(v146)
                return v146 == 16 and "Neverlose" or tostring(v146);
            end);
            v141[v143].tick_speed_info = v141[v143].defensive_tickbase:create():label("Default choke value for Neverlose is 16.");
            v141[v143].event_handler = v104:combo(l_core_0:with_icon("calendar-plus", "   Update Event" .. "\n" .. v143, "{Link Active}"), {
                [1] = "createmove", 
                [2] = "net_update"
            });
            local function v152(v147)
                -- upvalues: v141 (ref), v143 (ref), v105 (ref), l_core_0 (ref), v9 (ref)
                v141[v143]["yaw_mode" .. v147] = v105:combo(l_core_0:with_icon("ruler", "   Yaw" .. "\n" .. v147 .. v143, "{Link Active}"), {
                    [1] = "L - R", 
                    [2] = "Automatic"
                });
                v141[v143]["yaw_random_methods" .. v147] = v141[v143]["yaw_mode" .. v147]:create():combo(l_core_0:with_icon("rectangles-mixed", "  Random" .. "\n" .. v147 .. v143, "{Link Active}"), {
                    [1] = "Default", 
                    [2] = "Sinusoidal", 
                    [3] = "Chaotic"
                });
                for _, v149 in ipairs({
                    [1] = "center", 
                    [2] = "left", 
                    [3] = "right"
                }) do
                    v141[v143]["yaw_" .. v149 .. v147] = v141[v143]["yaw_mode" .. v147]:create():slider(l_core_0:with_icon("angle-right", "  " .. v9.capitalize(v149) .. "\n" .. v147 .. v143, "{Link Active}"), -180, 180, 0, 1, "\194\176");
                end;
                v141[v143]["yaw_randomize" .. v147] = v141[v143]["yaw_mode" .. v147]:create():slider("Randomize\n" .. v147 .. v143, 0, 180, 0, 1);
                v141[v143]["frequency" .. v147] = v141[v143]["yaw_mode" .. v147]:create():slider("Frequency\n" .. v147 .. v143, 0, 60, 0, 1);
                v141[v143]["amplitude" .. v147] = v141[v143]["yaw_mode" .. v147]:create():slider("Amplitude\n" .. v147 .. v143, 0, 30, 0, 1);
                v141[v143]["r_min" .. v147] = v141[v143]["yaw_mode" .. v147]:create():slider("Min\n" .. v147 .. v143, 0, 100, 0, 1);
                v141[v143]["r_max" .. v147] = v141[v143]["yaw_mode" .. v147]:create():slider("Max\n" .. v147 .. v143, 0, 100, 0, 1);
                v141[v143]["scale" .. v147] = v141[v143]["yaw_mode" .. v147]:create():slider("Scale\n" .. v147 .. v143, 0, 100, 0, 1);
                v141[v143]["antibrute" .. v147] = v141[v143]["yaw_mode" .. v147]:create():switch(l_core_0:with_icon("shirt-running", "  Anti-bruteforce" .. "\n" .. v147 .. v143, "{Link Active}"), false);
                v141[v143]["antibrute_method" .. v147] = v141[v143]["yaw_mode" .. v147]:create():list("Method", {
                    [1] = "Decrease", 
                    [2] = "Randomize", 
                    [3] = "Increase"
                });
                v141[v143]["anti_timeout" .. v147] = v141[v143]["yaw_mode" .. v147]:create():slider(l_core_0:with_icon("reply-clock", "  Timeout" .. "\n" .. v147 .. v143, "{Link Active}"), 0, 30, 0, 1, function(v150)
                    return v150 == 0 and "Infinite" or tostring(v150);
                end);
                v141[v143]["anti_timeout_info" .. v147] = v141[v143]["yaw_mode" .. v147]:create():label("If you put timeout at 0 it will be infinite till round ends");
                v141[v143]["Jitter" .. v147] = v105:combo(l_core_0:with_icon("angle-90", "   Modifier" .. "\n" .. v147 .. v143, "{Link Active}"), {
                    [1] = "Disabled", 
                    [2] = "Center", 
                    [3] = "Offset", 
                    [4] = "Random", 
                    [5] = "3-way", 
                    [6] = "5-way", 
                    [7] = "Spin", 
                    [8] = "Hold"
                });
                v141[v143]["center_options" .. v147] = v141[v143]["Jitter" .. v147]:create():combo(l_core_0:with_icon("rectangles-mixed", "  Random" .. "\n" .. v147 .. v143, "{Link Active}"), {
                    [1] = "Randomize", 
                    [2] = "Min - Max", 
                    [3] = "Custom"
                });
                v141[v143]["yaw_jitter_ovr" .. v147] = v141[v143]["Jitter" .. v147]:create():slider(l_core_0:with_icon("slider", "  Offset" .. "\n" .. v147 .. v143, "{Link Active}"), -180, 180, 0, 1, "\194\176");
                v141[v143]["jitter_randomize" .. v147] = v141[v143]["Jitter" .. v147]:create():slider(l_core_0:with_icon("angle-right", "  Randomize" .. "\n" .. v147 .. v143, "{Link Active}"), 0, 180, 0, 1);
                v141[v143]["center_min" .. v147] = v141[v143]["Jitter" .. v147]:create():slider(l_core_0:with_icon("angle-right", "  Min" .. "\n" .. v147 .. v143, "{Link Active}"), -180, 180, 0, 1);
                v141[v143]["center_max" .. v147] = v141[v143]["Jitter" .. v147]:create():slider(l_core_0:with_icon("angle-right", "  Max" .. "\n" .. v147 .. v143, "{Link Active}"), -180, 180, 0, 1);
                v141[v143]["custom_amount" .. v147] = v141[v143]["Jitter" .. v147]:create():slider(l_core_0:with_icon("sliders-simple", "  Slider Amount" .. "\n" .. v147 .. v143, "{Link Active}"), 1, 22);
                for v151 = 1, 22 do
                    v141[v143]["custom_slider_" .. v151 .. v147] = v141[v143]["Jitter" .. v147]:create():slider(l_core_0:with_icon("angle-right", "    " .. v151 .. "\n" .. v147 .. v143, "{Link Active}"), -180, 180, 0);
                end;
            end;
            local function v159(v153)
                -- upvalues: v141 (ref), v143 (ref), v105 (ref), l_core_0 (ref), v9 (ref)
                v141[v143]["body_yaw" .. v153] = v105:switch(l_core_0:with_icon("infinity", "  Body" .. "\n" .. v153 .. v143, "{Link Active}"), true);
                v141[v143]["fake_options" .. v153] = v105:combo(l_core_0:with_icon("option", "  Options" .. "\n" .. v153 .. v143, "{Link Active}"), {
                    [1] = "Jitter", 
                    [2] = "Static"
                });
                v141[v143]["speed_options" .. v153] = v141[v143]["fake_options" .. v153]:create():combo(l_core_0:with_icon("bars-progress", "  Method" .. "\n" .. v153 .. v143, "{Link Active}"), {
                    [1] = "Neverlose", 
                    [2] = "Inverter", 
                    [3] = "Amnesia"
                });
                v141[v143]["body_speed" .. v153] = v141[v143]["fake_options" .. v153]:create():slider(l_core_0:with_icon("gauge-simple-high", "  Speed" .. "\n" .. v153 .. v143, "{Link Active}"), 1, 20, 0, 1, function(v154)
                    return v154 == 1 and "Default" or tostring(v154);
                end);
                v141[v143]["amnesia_tick_speed" .. v153] = v141[v143]["fake_options" .. v153]:create():slider("Amnesia Tick\n" .. v153 .. v143, 1, 22, 16);
                v141[v143]["random_speed" .. v153] = v141[v143]["fake_options" .. v153]:create():switch(l_core_0:with_icon("shuffle", "  Random Speed" .. "\n" .. v153 .. v143, "{Link Active}"), false);
                v141[v143]["random_speed_method" .. v153] = v141[v143]["fake_options" .. v153]:create():combo(l_core_0:with_icon("rectangles-mixed", "  Random" .. "\n" .. v153 .. v143, "{Link Active}"), {
                    [1] = "Random", 
                    [2] = "Custom"
                });
                v141[v143]["custom_speed_amount" .. v153] = v141[v143]["fake_options" .. v153]:create():slider(l_core_0:with_icon("sliders-simple", "  Slider Amount" .. "\n" .. v153 .. v143, "{Link Active}"), 1, 22);
                for v155 = 1, 22 do
                    v141[v143]["custom_speed_slider_" .. v155 .. v153] = v141[v143]["fake_options" .. v153]:create():slider(l_core_0:with_icon("angle-right", "    " .. v155 .. "\n" .. v153 .. v143, "{Link Active}"), 1, 20, 0);
                end;
                v141[v143]["ran_speed_1" .. v153] = v141[v143]["fake_options" .. v153]:create():slider(l_core_0:with_icon("angle-right", "  Min Speed" .. "\n" .. v153 .. v143, "{Link Active}"), 1, 20, 1);
                v141[v143]["ran_speed_2" .. v153] = v141[v143]["fake_options" .. v153]:create():slider(l_core_0:with_icon("angle-right", "  Max Speed" .. "\n" .. v153 .. v143, "{Link Active}"), 1, 20, 1);
                for _, v157 in ipairs({
                    [1] = "left", 
                    [2] = "right"
                }) do
                    local v158 = "fake_" .. v157 .. v153;
                    v141[v143][v158] = v141[v143]["body_yaw" .. v153]:create():slider(l_core_0:with_icon("angle-right", "  " .. v9.capitalize(v157) .. "\n" .. v153 .. v143, "{Link Active}"), 0, 60, 60, 1, "\194\176");
                    v158 = "fake_" .. v157 .. "_random" .. v153;
                    v141[v143][v158] = v141[v143]["body_yaw" .. v153]:create():slider("Randomize\n" .. v153 .. v143, 0, 60, 0, 1);
                end;
            end;
            v152("");
            v152("_ct");
            v159("");
            v159("_ct");
            v141[v143].send_to = v107:button(l_core_0:with_icon("star", "      Send To CT      \n" .. v143, "{Link Active}"), function()
                send_to_opposite_team();
            end, true);
            v141[v143].reset = v107:button("      \aFF0000FFReset      \n" .. v143, function()
                reset_current_state();
            end, true);
            v141[v143].send_to_ct = v107:button(l_core_0:with_icon("star", "      Send To T      \n" .. v143, "{Link Active}"), function()
                send_to_opposite_team();
            end, true);
            v141[v143].reset_ct = v107:button("      \aFF0000FFReset      \n" .. v143, function()
                reset_current_state();
            end, true);
        end;
        local function v172(v161)
            -- upvalues: v142 (ref), v105 (ref), l_core_0 (ref), v9 (ref), v107 (ref)
            v142[v161] = {};
            v142[v161].def_toggle = v105:switch(l_core_0:with_icon("shield-check", "  Enable " .. v161 .. "\n" .. v161, "{Link Active}"), false);
            v142[v161].def_toggle_ct = v105:switch(l_core_0:with_icon("shield-check", "  Enable " .. v161 .. "\n" .. v161, "{Link Active}"), false);
            local function v165(v162)
                -- upvalues: v142 (ref), v161 (ref), v105 (ref), l_core_0 (ref), v9 (ref)
                v142[v161]["def_pitch" .. v162] = v105:combo("Pitch\n" .. v161 .. v162, {
                    [1] = "Down", 
                    [2] = "Random", 
                    [3] = "Auto", 
                    [4] = "Custom"
                });
                v142[v161]["pitch_offset" .. v162] = v142[v161]["def_pitch" .. v162]:create():slider("Pitch\n" .. v161, -89, 89, 0, 1, "\194\176");
                v142[v161]["yaw_mode" .. v162] = v105:combo(l_core_0:with_icon("ruler", "   Yaw" .. "\n" .. v162 .. v161, "{Link Active}"), {
                    [1] = "L - R", 
                    [2] = "Sideways", 
                    [3] = "Random", 
                    [4] = "Spin"
                });
                v142[v161]["yaw_random_methods" .. v162] = v142[v161]["yaw_mode" .. v162]:create():combo(l_core_0:with_icon("rectangles-mixed", "  Random" .. "\n" .. v162 .. v161, "{Link Active}"), {
                    [1] = "Default", 
                    [2] = "Sinusoidal", 
                    [3] = "Chaotic"
                });
                for _, v164 in ipairs({
                    [1] = "center", 
                    [2] = "left", 
                    [3] = "right"
                }) do
                    v142[v161]["yaw_" .. v164 .. v162] = v142[v161]["yaw_mode" .. v162]:create():slider(l_core_0:with_icon("angle-right", "  " .. v9.capitalize(v164) .. "\n" .. v162 .. v161, "{Link Active}"), -180, 180, 0, 1, "\194\176");
                end;
                v142[v161]["spin_speed" .. v162] = v142[v161]["yaw_mode" .. v162]:create():slider("Spin Speed\n" .. v162 .. v161, 1, 10);
                v142[v161]["yaw_randomize" .. v162] = v142[v161]["yaw_mode" .. v162]:create():slider("Randomize\n" .. v162 .. v161, 0, 180, 0, 1);
                v142[v161]["frequency" .. v162] = v142[v161]["yaw_mode" .. v162]:create():slider("Frequency\n" .. v162 .. v161, 0, 60, 0, 1);
                v142[v161]["amplitude" .. v162] = v142[v161]["yaw_mode" .. v162]:create():slider("Amplitude\n" .. v162 .. v161, 0, 30, 0, 1);
                v142[v161]["r_min" .. v162] = v142[v161]["yaw_mode" .. v162]:create():slider("Min\n" .. v162 .. v161, 0, 100, 0, 1);
                v142[v161]["r_max" .. v162] = v142[v161]["yaw_mode" .. v162]:create():slider("Max\n" .. v162 .. v161, 0, 100, 0, 1);
                v142[v161]["scale" .. v162] = v142[v161]["yaw_mode" .. v162]:create():slider("Scale\n" .. v162 .. v161, 0, 100, 0, 1);
                v142[v161]["Jitter" .. v162] = v105:combo(l_core_0:with_icon("angle-90", "   Modifier" .. "\n" .. v162 .. v161, "{Link Active}"), {
                    [1] = "Disabled", 
                    [2] = "Center", 
                    [3] = "Offset", 
                    [4] = "Random", 
                    [5] = "3-way", 
                    [6] = "5-way"
                });
                v142[v161]["center_options" .. v162] = v142[v161]["Jitter" .. v162]:create():combo(l_core_0:with_icon("rectangles-mixed", "  Random" .. "\n" .. v162 .. v161, "{Link Active}"), {
                    [1] = "Randomize", 
                    [2] = "Min - Max"
                });
                v142[v161]["yaw_jitter_ovr" .. v162] = v142[v161]["Jitter" .. v162]:create():slider(l_core_0:with_icon("slider", "  Offset" .. "\n" .. v162 .. v161, "{Link Active}"), -180, 180, 0, 1, "\194\176");
                v142[v161]["jitter_randomize" .. v162] = v142[v161]["Jitter" .. v162]:create():slider(l_core_0:with_icon("angle-right", "  Randomize" .. "\n" .. v162 .. v161, "{Link Active}"), 0, 180, 0, 1);
                v142[v161]["center_min" .. v162] = v142[v161]["Jitter" .. v162]:create():slider(l_core_0:with_icon("angle-right", "  Min" .. "\n" .. v162 .. v161, "{Link Active}"), -180, 180, 0, 1);
                v142[v161]["center_max" .. v162] = v142[v161]["Jitter" .. v162]:create():slider(l_core_0:with_icon("angle-right", "  Max" .. "\n" .. v162 .. v161, "{Link Active}"), -180, 180, 0, 1);
            end;
            local function v171(v166)
                -- upvalues: v142 (ref), v161 (ref), v105 (ref), l_core_0 (ref), v9 (ref), v107 (ref)
                v142[v161]["body_yaw" .. v166] = v105:switch(l_core_0:with_icon("infinity", "  Body" .. "\n" .. v166 .. v161, "{Link Active}"), true);
                v142[v161]["fake_options" .. v166] = v105:combo(l_core_0:with_icon("option", "  Options" .. "\n" .. v166 .. v161, "{Link Active}"), {
                    [1] = "Jitter", 
                    [2] = "Static"
                });
                v142[v161]["speed_options" .. v166] = v142[v161]["fake_options" .. v166]:create():combo(l_core_0:with_icon("bars-progress", "  Method" .. "\n" .. v166 .. v161, "{Link Active}"), {
                    [1] = "Neverlose", 
                    [2] = "Inverter", 
                    [3] = "Amnesia"
                });
                v142[v161]["body_speed" .. v166] = v142[v161]["fake_options" .. v166]:create():slider(l_core_0:with_icon("gauge-simple-high", "  Speed" .. "\n" .. v166 .. v161, "{Link Active}"), 1, 20, 0, 1, function(v167)
                    return v167 == 1 and "Default" or tostring(v167);
                end);
                v142[v161]["amnesia_tick_speed" .. v166] = v142[v161]["fake_options" .. v166]:create():slider("Amnesia Tick\n" .. v166 .. v161, 1, 22, 16);
                v142[v161]["random_speed" .. v166] = v142[v161]["fake_options" .. v166]:create():switch(l_core_0:with_icon("shuffle", "  Random Speed" .. "\n" .. v166 .. v161, "{Link Active}"), false);
                v142[v161]["random_speed_method" .. v166] = v142[v161]["fake_options" .. v166]:create():combo(l_core_0:with_icon("rectangles-mixed", "  Random" .. "\n" .. v166 .. v161, "{Link Active}"), {
                    [1] = "Random"
                });
                v142[v161]["ran_speed_1" .. v166] = v142[v161]["fake_options" .. v166]:create():slider(l_core_0:with_icon("angle-right", "  Min Speed" .. "\n" .. v166 .. v161, "{Link Active}"), 1, 20, 1);
                v142[v161]["ran_speed_2" .. v166] = v142[v161]["fake_options" .. v166]:create():slider(l_core_0:with_icon("angle-right", "  Max Speed" .. "\n" .. v166 .. v161, "{Link Active}"), 1, 20, 1);
                for _, v169 in ipairs({
                    [1] = "left", 
                    [2] = "right"
                }) do
                    local v170 = "fake_" .. v169 .. v166;
                    v142[v161][v170] = v142[v161]["body_yaw" .. v166]:create():slider(l_core_0:with_icon("angle-right", "  " .. v9.capitalize(v169) .. "\n" .. v166 .. v161, "{Link Active}"), 0, 60, 60, 1, "\194\176");
                    v170 = "fake_" .. v169 .. "_random" .. v166;
                    v142[v161][v170] = v142[v161]["body_yaw" .. v166]:create():slider("Randomize\n" .. v166 .. v161, 0, 60, 0, 1);
                end;
                v142[v161]["def_activation" .. v166] = v107:combo(l_core_0:with_icon("chart-network", "  Activation" .. "\n" .. v166 .. v161, "{Link Active}"), {
                    [1] = "Always", 
                    [2] = "Hittable"
                });
            end;
            v165("");
            v165("_ct");
            v171("");
            v171("_ct");
            v142[v161].send_to = v107:button(l_core_0:with_icon("star", "      Send To CT      \n" .. v161, "{Link Active}"), function()
                send_to_opposite_team();
            end, true);
            v142[v161].reset = v107:button("      \aFF0000FFReset      \n" .. v161, function()
                reset_current_state();
            end, true);
            v142[v161].send_to_ct = v107:button(l_core_0:with_icon("star", "      Send To T      \n" .. v161, "{Link Active}"), function()
                send_to_opposite_team();
            end, true);
            v142[v161].reset_ct = v107:button("      \aFF0000FFReset      \n" .. v161, function()
                reset_current_state();
            end, true);
        end;
        for _, v174 in pairs(v91.conditions) do
            v160(v174);
            v172(v174);
        end;
        v9.rage.builder_elements = v141;
        v9.rage.defensive_elements = v142;
    end;
    v9.menu_handler();
    v9.set_visibility = function(v175, v176, v177, v178)
        -- upvalues: v9 (ref)
        local v179 = v177 and "_ct" or "";
        local v180 = v9.rage.aa_lister and v9.rage.aa_lister:get() == v178;
        if v176 then
            v176 = v180;
        end;
        v9.visuals.notifs.notifs_prefix_font:visibility(v9.visuals.notifs.notifs_prefix:get());
        local v181 = {};
        local v182 = {};
        local function v186(v183, v184)
            -- upvalues: v175 (ref)
            local v185 = v175[v183];
            if v185 and v185.get then
                return v185:get();
            else
                return v184;
            end;
        end;
        local v187 = v175["Jitter" .. v179];
        local v188;
        if not v187 or v187:get() == "Hold" then
            v188 = false;
        else
            v188 = true;
        end;
        local v189;
        if not v187 or v187:get() == "Disabled" then
            v189 = false;
        else
            v189 = true;
        end;
        local v190 = v186("center_options" .. v179, "");
        local v191 = v190 == "Custom";
        local v192 = v190 == "Min - Max";
        local v193 = v190 == "Randomize";
        local v194 = v186("custom_amount" .. v179, 0);
        local v195 = v186("yaw_random_methods" .. v179, "");
        local v196 = v195 == "Chaotic";
        local v197 = v195 == "Sinusoidal";
        local v198 = v195 == "Default";
        local v199 = v186("random_speed" .. v179, false);
        local v200 = v186("random_speed_method" .. v179, "") == "Custom";
        local v201 = v186("custom_speed_amount" .. v179, 0);
        local v202 = v186("yaw_mode" .. v179, "") == "Spin";
        local v203 = v186("defensive_tickbase", 0) == 1;
        local v204 = v186("antibrute" .. v179, false);
        local v205 = v186("speed_options" .. v179, "") == "Amnesia";
        local v206 = v186("yaw_mode" .. v179, "") == "Sideways" or not (v186("yaw_mode" .. v179, "") ~= "Random") or v186("yaw_mode" .. v179, "") == "Spin";
        local function v210()
            -- upvalues: v175 (ref), v179 (ref), v194 (ref), v191 (ref), v188 (ref), v180 (ref), v201 (ref), v200 (ref), v199 (ref)
            for v207 = 1, 22 do
                local v208 = v175["custom_slider_" .. v207 .. v179];
                if v208 and v208.visibility then
                    v208:visibility(v207 <= v194 and v191 and v188 and v180);
                end;
                local v209 = v175["custom_speed_slider_" .. v207 .. v179];
                if v209 and v209.visibility then
                    v209:visibility(v207 <= v201 and v200 and v199 and v180);
                end;
            end;
        end;
        local v211 = v175["body_speed" .. v179];
        if v211 and v211.override then
            if v199 then
                v211:override(1);
            else
                v211:override();
            end;
        end;
        local v212 = v175["yaw_jitter_ovr" .. v179];
        if v212 and v212.disabled then
            v212:disabled(v192 or v191 or not v188);
        end;
        local v213 = {
            def_activation = false, 
            custom_amount = v191 and v188, 
            custom_speed_amount = v200 and v199, 
            amnesia_tick_speed = v205, 
            spin_speed = v202, 
            yaw_randomize = v198, 
            r_min = v196, 
            r_max = v196, 
            scale = v196, 
            frequency = v197, 
            amplitude = v197, 
            def_pitch = v176, 
            yaw_mode = v176
        };
        local v214;
        if v176 then
            v214 = show_yaw_center;
        else
            v214 = v176;
        end;
        v213.yaw_center = v214;
        if v176 then
            v214 = not v206;
        else
            v214 = v176;
        end;
        v213.yaw_left = v214;
        if v176 then
            v214 = not v206;
        else
            v214 = v176;
        end;
        v213.yaw_right = v214;
        v213.antibrute_method = v204;
        v213.anti_timeout = v204;
        v213.anti_timeout_info = v204;
        v213.ran_speed_1 = v199 and not v200;
        v213.ran_speed_2 = v199 and not v200;
        v213.random_speed_method = v199;
        v213.speed_options = v176;
        v213.Jitter = v176;
        if v176 then
            v214 = v188;
        else
            v214 = v176;
        end;
        v213.center_options = v214;
        v213.center_min = v192 and v188;
        v213.center_max = v192 and v188;
        v213.jitter_randomize = v193 and v188;
        if v176 then
            v214 = v189;
        else
            v214 = v176;
        end;
        v213.yaw_jitter_ovr = v214;
        v213.body_yaw = v176;
        v213.fake_left = v176;
        v213.fake_right = v176;
        v213.fake_options = v176;
        v213.send_to = v176;
        v213.reset = v176;
        v213.body_speed = v176;
        v181 = v213;
        v182 = {
            event_handler = v176, 
            defensive_tickbase = v176, 
            tick_random = v203 and v176, 
            tick_speed1 = v203 and v176, 
            tick_speed2 = v203 and v186("tick_random", false) and v176, 
            tick_speed_info = v203 and v176
        };
        v210();
        for v215, v216 in pairs(v181) do
            local v217 = v175[v215 .. v179];
            if v217 and v217.visibility then
                v217:visibility(v216);
            end;
        end;
        for v218, v219 in pairs(v182) do
            local v220 = v175[v218];
            if v220 and v220.visibility then
                v220:visibility(v219);
            end;
        end;
    end;
    v9.hide_side = function(v221, v222)
        local v223 = v222 and "_ct" or "";
        for _, v225 in ipairs({
            [1] = "def_toggle", 
            [2] = "def_pitch", 
            [3] = "yaw_mode", 
            [4] = "yaw_center", 
            [5] = "yaw_left", 
            [6] = "yaw_right", 
            [7] = "Jitter", 
            [8] = "center_options", 
            [9] = "center_min", 
            [10] = "center_max", 
            [11] = "jitter_randomize", 
            [12] = "fake_left", 
            [13] = "fake_right", 
            [14] = "yaw_jitter_ovr", 
            [15] = "body_yaw", 
            [16] = "fake_options", 
            [17] = "reset", 
            [18] = "send_to", 
            [19] = "body_speed", 
            [20] = "speed_options", 
            [21] = "def_activation", 
            [22] = "spin_speed"
        }) do
            local v226 = v221[v225 .. v223];
            if v226 and v226:visibility() then
                v226:visibility(false);
            end;
        end;
    end;
    v9.visibility_handler = function()
        -- upvalues: v9 (ref), l_core_0 (ref), l_pui_0 (ref), v91 (ref)
        local v227 = v9.misc_chooser:get() == 1;
        local v228 = v9.misc_chooser:get() == 2;
        local v229 = v9.rage.team_list:get() == "T";
        local v230 = v9.rage.team_list:get() == "CT";
        local v231 = v9.rage.aa_lister:get() == 1;
        local v232 = v9.rage.aa_lister:get() == 2;
        local v233 = v9.rage.aa_lister:get() == 3;
        local v234 = v232 or v233;
        v9.rage.state_label:name(l_core_0:with_icon("user-plus", "  Current State ", "{Link Active}") .. "\a" .. ui.get_style("Link Active"):to_hex() .. " \226\128\162 \r " .. v9.rage.state_list:get());
        v9.rage.state_label:visibility(v234);
        v9.rage.team_list:visibility(v234);
        v9.rage.state_list:visibility(v234);
        v9.rage.anims:visibility(v231);
        v9.rage.freestanding_bind:visibility(v231);
        v9.rage.manual:visibility(v231);
        v9.rage.safe_head:visibility(v231);
        v9.rage.avoid_knife:visibility(v231);
        v9.rage.additions:visibility(v231);
        l_pui_0.traverse(v9.visuals, function(v235)
            -- upvalues: v227 (ref)
            v235:visibility(v227);
        end);
        l_pui_0.traverse(v9.misc, function(v236)
            -- upvalues: v228 (ref)
            v236:visibility(v228);
        end);
        if v9.rage.anims.move_jitter_mode:get() == 1 then
            v9.rage.anims.move_legs1:visibility(false);
            v9.rage.anims.move_legs2:visibility(false);
            v9.rage.anims.move_jitter:visibility(true);
        else
            v9.rage.anims.move_legs1:visibility(true);
            v9.rage.anims.move_legs2:visibility(true);
            v9.rage.anims.move_jitter:visibility(false);
        end;
        for _, v238 in pairs(v91.conditions) do
            local v239 = v9.rage.state_list:get() == v238;
            local _ = v9.rage.hidden_builder.state_list:get() == v238;
            local v241 = v9.rage.builder_elements[v238];
            v9.hide_side(v241, false);
            v9.hide_side(v241, true);
            if v229 then
                local _ = v241.yaw_mode:get() == "Static" or not (v241.yaw_mode:get() ~= "3-way") or v241.yaw_mode:get() == "5-way";
                v9.set_visibility(v241, v239, false, 2);
            elseif v230 then
                local _ = v241.yaw_mode_ct:get() == "Static" or not (v241.yaw_mode_ct:get() ~= "3-way") or v241.yaw_mode_ct:get() == "5-way";
                v9.set_visibility(v241, v239, true, 2);
            end;
            v241.event_handler:disabled(true);
        end;
        for _, v245 in pairs(v91.conditions) do
            local v246 = v9.rage.state_list:get() == v245 and v233;
            local v247 = v9.rage.defensive_elements[v245];
            if v233 then
                for _, v249 in pairs(v247) do
                    if v249.visibility then
                        v249:visibility(false);
                    end;
                end;
                if v247.def_toggle then
                    v247.def_toggle:visibility(v246 and v229);
                end;
                if v247.def_toggle_ct then
                    v247.def_toggle_ct:visibility(v246 and v230);
                end;
                v247.def_activation:visibility(false);
                v247.def_activation_ct:visibility(false);
                if v229 then
                    v247.reset:visibility(v246);
                    v247.send_to:visibility(v246);
                else
                    v247.reset_ct:visibility(v246);
                    v247.send_to_ct:visibility(v246);
                end;
                if v229 then
                    v9.set_visibility(v247, v246, false, 3);
                    local v250 = v247.def_toggle and v247.def_toggle:get() or false;
                    for v251, v252 in pairs(v247) do
                        if v251:find("_ct") then
                            if v252.visibility then
                                v252:visibility(false);
                            end;
                        elseif v251 ~= "def_toggle" and v251 ~= "def_toggle_ct" and v252.visibility and v252:visibility() then
                            v252:visibility(v250);
                        end;
                    end;
                    if v247.pitch_offset then
                        v247.pitch_offset:visibility(v246 and v250 and v247.def_pitch:get() == "Custom");
                    end;
                end;
                if v230 then
                    v9.set_visibility(v247, v246, true, 3);
                    local v253 = v247.def_toggle_ct and v247.def_toggle_ct:get() or false;
                    for v254, v255 in pairs(v247) do
                        if not v254:find("_ct") then
                            if v255.visibility then
                                v255:visibility(false);
                            end;
                        elseif v254 ~= "def_toggle" and v254 ~= "def_toggle_ct" and v255.visibility and v255:visibility() then
                            v255:visibility(v253);
                        end;
                    end;
                    if v247.pitch_offset_ct then
                        v247.pitch_offset_ct:visibility(v246 and v253 and v247.def_pitch_ct:get() == "Custom");
                    end;
                end;
            else
                for _, v257 in pairs(v247) do
                    if v257.visibility then
                        v257:visibility(false);
                    end;
                end;
            end;
        end;
    end;
    if not db.configurations4 then
        local _ = {};
    end;
    local _ = nil;
    v7.is_config_in_list = function(v260)
        -- upvalues: v8 (ref)
        for _, v262 in ipairs(v8) do
            if v262:find(v260) then
                return true;
            end;
        end;
        return false;
    end;
    v9.main.preset_list:set_callback(function()
        -- upvalues: v9 (ref), v7 (ref)
        local v263 = v9.main.preset_list:get();
        local v264 = v7.get_config_name_from_index(v263);
        if v264 then
            v9.main.input_name:set(v264);
        end;
    end);
    v7.check_index = function()
        -- upvalues: v19 (ref), v9 (ref), v123 (ref)
        if v19.ui.getalpha() > 0 then
            local v265 = v9.main.preset_list:get();
            local _ = #v123;
            if v265 <= 6 then
                v9.main.new_button:disabled(true);
                v9.main.import_button:disabled(true);
                v9.main.export_button:disabled(true);
                v9.main.delete_button:disabled(true);
            else
                v9.main.new_button:disabled(false);
                v9.main.import_button:disabled(false);
                v9.main.export_button:disabled(false);
                v9.main.load_button:disabled(false);
                v9.main.delete_button:disabled(false);
            end;
            return;
        else
            return;
        end;
    end;
    v11.register("render", "ls_utils.check_index", v7.check_index);
    v7.export_config = function()
        -- upvalues: l_pui_0 (ref), l_clipboard_0 (ref), v12 (ref)
        local _ = l_pui_0.save();
        local v268 = json.stringify(l_pui_0.save());
        l_clipboard_0.set(v268);
        v12.push("config has been successfully exported!");
    end;
    v7.import_config = function()
        -- upvalues: l_clipboard_0 (ref), l_pui_0 (ref), v12 (ref)
        local v269 = l_clipboard_0.get();
        local v270 = json.parse(v269);
        l_pui_0.load(v270);
        v12.push("config has been successfully imported!");
    end;
    v7.save_config = function()
        -- upvalues: v9 (ref), v123 (ref), v12 (ref), v7 (ref), l_pui_0 (ref)
        local v271 = v9.main.preset_list:get();
        local v272 = #v123;
        local v273 = v9.main.input_name:get();
        if not v273 or v273 == "" then
            v12.push("please enter a valid config name");
            return;
        else
            local v274 = db.configurations4 or {};
            local v275 = v7.get_config_name_from_index(v271);
            if #v274 == 0 then
                table.remove(v123, 8);
            end;
            if v272 < v271 and v275 and v275 ~= v273 then
                print("creating new config:", v273);
                v12.push("creating new config:" .. v273);
            elseif v274[v273] then
                print("updating existing config:", v273);
                v12.push("updating existing config:" .. v273);
            end;
            v274[v273] = l_pui_0.save();
            db.configurations4 = v274;
            v7.update_config_list();
            v12.push("config saved : " .. v273);
            return;
        end;
    end;
    v7.update_config_list = function()
        -- upvalues: v8 (ref), l_core_0 (ref), v123 (ref), v9 (ref)
        v8 = {};
        local v276 = db.configurations4 or {};
        local v277 = {};
        for v278, _ in pairs(v276) do
            table.insert(v277, v278);
        end;
        table.sort(v277);
        for _, v281 in ipairs(v277) do
            table.insert(v8, l_core_0:with_icon("list-ul", v281, "{Link Active}"));
        end;
        local v282 = {};
        for v283 = 1, 6 do
            table.insert(v282, v123[v283]);
        end;
        if #v277 == 0 then
            table.insert(v282, v123[7]);
        end;
        for _, v285 in ipairs(v8) do
            table.insert(v282, v285);
        end;
        v9.main.preset_list:update(v282);
    end;
    v7.update_config_list();
    v7.get_config_name_from_index = function(v286)
        local v287 = db.configurations4 or {};
        local v288 = {};
        for v289, _ in pairs(v287) do
            table.insert(v288, v289);
        end;
        table.sort(v288);
        if v286 <= 6 then
            return nil;
        elseif #v288 == 0 and v286 == 7 then
            return nil;
        else
            local v291 = nil;
            if #v288 == 0 then
                v291 = v286 - 7;
            else
                v291 = v286 - 6;
            end;
            return v288[v291];
        end;
    end;
    local v292 = {
        crouch = "Crouch", 
        ["air crouch"] = "Air Crouch", 
        jitter = "Jitter", 
        jitter_ct = "Jitter_ct", 
        air = "Air", 
        running = "Running", 
        center = "Center", 
        manual = "Manual", 
        ["l - r"] = "L - R", 
        standing = "Standing", 
        slowmotion = "Slowmotion", 
        ["crouch moving"] = "Crouch Moving"
    };
    do
        local l_v292_0 = v292;
        renameKeys = function(v294)
            -- upvalues: l_v292_0 (ref)
            if type(v294) ~= "table" then
                return v294;
            else
                local v295 = {};
                for v296, v297 in pairs(v294) do
                    v295[l_v292_0[string.lower(v296)] or v296] = renameKeys(v297);
                end;
                return v295;
            end;
        end;
        v7.load_config = function()
            -- upvalues: v9 (ref), v12 (ref), v123 (ref), l_pui_0 (ref), v7 (ref)
            local v298 = v9.main.preset_list:get();
            if not v298 or v298 == 0 then
                v12.push("please select valid config to load");
                return;
            elseif v298 <= #v123 - 1 then
                if v298 == 1 then
                    local v299 = json.parse("{\"defensive\":{\"antiaim_conditions\":[\"~\"],\"defensive_conditions\":[\"Slowmotion\",\"Crouch\",\"Crouch Moving\",\"Air\",\"Air Crouch\",\"~\"],\"disablers\":[\"~\"],\"force_hideshot\":true,\"game_events\":[\"~\"],\"on_exploit\":[\"~\"],\"state_list\":\"Standing\"},\"main\":{\"input_name\":\"default\",\"preset_list\":1.0},\"misc\":{\"aim_logs\":true,\"aspect_ratio\":true,\"aspect_ratio_val\":134.0,\"clantag\":false,\"fast_ladder\":true,\"fps_boost\":true,\"kibit_hitmark\":false,\"kibit_hitmark_color\":\"#58FFD1FF\",\"no_fall\":true,\"view_model_changer\":true,\"viewmodel_changer_fov\":68.0,\"viewmodel_changer_x\":100.0,\"viewmodel_changer_y\":-100.0,\"viewmodel_changer_z\":200.0},\"rage\":{\"additions\":[\"Warmup / Round End AA\",\"Improve Fakelag on Defensive\",\"Avoid Backstab\",\"~\"],\"anims\":true,\"builder_elements\":{\"Air\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":2.0,\"fake_left_random_ct\":2.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":5.0,\"fake_right_random_ct\":5.0,\"flick_left\":-11.0,\"flick_left_body\":24.0,\"flick_left_body_ct\":24.0,\"flick_left_ct\":-11.0,\"flick_right\":11.0,\"flick_right_body\":26.0,\"flick_right_body_ct\":26.0,\"flick_right_ct\":11.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":5.0,\"flick_speed_random_ct\":6.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":true,\"limit_random_ct\":true,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-29.0,\"yaw_left_ct\":-29.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":35.0,\"yaw_right_ct\":35.0},\"Air Crouch\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Random\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":-7.0,\"flick_left_body\":24.0,\"flick_left_body_ct\":24.0,\"flick_left_ct\":-7.0,\"flick_right\":15.0,\"flick_right_body\":26.0,\"flick_right_body_ct\":26.0,\"flick_right_ct\":15.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":3.0,\"flick_speed_random_ct\":3.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":true,\"limit_random_ct\":true,\"pitch_offset\":-89.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-18.0,\"yaw_left_ct\":-18.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":44.0,\"yaw_right_ct\":44.0},\"Crouch\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":0.0,\"flick_left_body_ct\":0.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":0.0,\"flick_right_body_ct\":0.0,\"flick_right_ct\":0.0,\"flick_speed\":1.0,\"flick_speed_ct\":1.0,\"flick_speed_random\":1.0,\"flick_speed_random_ct\":1.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":true,\"limit_random_ct\":true,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-32.0,\"yaw_left_ct\":-32.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":46.0,\"yaw_right_ct\":46.0},\"Crouch Moving\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":-3.0,\"flick_left_body\":25.0,\"flick_left_body_ct\":8.0,\"flick_left_ct\":-7.0,\"flick_right\":6.0,\"flick_right_body\":29.0,\"flick_right_body_ct\":8.0,\"flick_right_ct\":12.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":3.0,\"flick_speed_random_ct\":5.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":true,\"limit_random_ct\":true,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-22.0,\"yaw_left_ct\":-22.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":44.0,\"yaw_right_ct\":44.0},\"Manual\":{\"Jitter\":\"Center\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":0.0,\"flick_left_body_ct\":0.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":0.0,\"flick_right_body_ct\":0.0,\"flick_right_ct\":0.0,\"flick_speed\":1.0,\"flick_speed_ct\":1.0,\"flick_speed_random\":1.0,\"flick_speed_random_ct\":1.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"Static\",\"yaw_mode_ct\":\"Static\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Running\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Random\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":-12.0,\"flick_left_body\":26.0,\"flick_left_body_ct\":26.0,\"flick_left_ct\":-12.0,\"flick_right\":8.0,\"flick_right_body\":20.0,\"flick_right_body_ct\":20.0,\"flick_right_ct\":8.0,\"flick_speed\":8.0,\"flick_speed_ct\":8.0,\"flick_speed_random\":5.0,\"flick_speed_random_ct\":5.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":true,\"limit_random_ct\":true,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":180.0,\"yaw_jitter_ovr_ct\":180.0,\"yaw_left\":-24.0,\"yaw_left_ct\":-24.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":37.0,\"yaw_right_ct\":37.0},\"Slowmotion\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":0.0,\"flick_left_body_ct\":0.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":0.0,\"flick_right_body_ct\":0.0,\"flick_right_ct\":0.0,\"flick_speed\":1.0,\"flick_speed_ct\":1.0,\"flick_speed_random\":1.0,\"flick_speed_random_ct\":1.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-23.0,\"yaw_left_ct\":-23.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":47.0,\"yaw_right_ct\":47.0},\"Standing\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":-5.0,\"center_max_ct\":0.0,\"center_min\":5.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":0.0,\"flick_left_body_ct\":0.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":0.0,\"flick_right_body_ct\":0.0,\"flick_right_ct\":0.0,\"flick_speed\":1.0,\"flick_speed_ct\":1.0,\"flick_speed_random\":1.0,\"flick_speed_random_ct\":1.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":92.0,\"yaw_jitter_ovr_ct\":92.0,\"yaw_left\":-24.0,\"yaw_left_ct\":-24.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":41.0,\"yaw_right_ct\":41.0}},\"freestand_body\":2.0,\"freestand_enablers\":[\"~\"],\"freestand_options\":[\"~\"],\"freestanding_bind\":false,\"hidden_builder\":false,\"keep_fs\":true,\"manual\":\"At Target\",\"prefer_manual\":true,\"safe_head\":false,\"safe_options\":[\"~\"],\"state_list\":\"Air Crouch\",\"team_list\":1.0,\"~anims\":{\"move_fall\":0.0,\"move_jitter\":0.0,\"move_jitter_mode\":2.0,\"move_lean_val\":100.0,\"move_legs1\":0.0,\"move_legs2\":100.0}},\"visuals\":{\"accent\":\"#DFC3FFFF\",\"crosshair_ind\":false,\"fake_latency_slider\":0.0,\"fake_latency_toggle\":false,\"gs_inds\":false,\"molotov_radius\":true,\"notifs\":false,\"scope\":true,\"slowed_down\":true,\"smokes_radius\":true,\"unlock_fakeduck\":true,\"watermark\":\"Left\",\"watermark_style\":1.0,\"~notifs\":{\"notifs_glow_amount\":41.0,\"notifs_hit_clr\":\"#00FF00FF\",\"notifs_miss_clr\":\"#FF0000FF\",\"notifs_prefix\":false,\"notifs_prefix_clr\":\"#00FF00FF\",\"notifs_prefix_font\":1.0,\"notifs_round_amount\":11.0},\"~scope\":{\"scope_color1\":\"#FFFFFFFF\",\"scope_color2\":\"#FFFFFF00\",\"scope_gap\":5.0,\"scope_settings\":[\"~\"],\"scope_size\":100.0,\"scope_style\":1.0}}}");
                    l_pui_0.load(v299);
                    v12.push("meta preset has been successfully imported!");
                elseif v298 == 2 then
                    local v300 = json.parse("{\"defensive\":{\"antiaim_conditions\":[\"~\"],\"defensive_conditions\":[\"Crouch\",\"Crouch Moving\",\"~\"],\"disablers\":[\"~\"],\"force_hideshot\":false,\"game_events\":[\"~\"],\"on_exploit\":[\"~\"],\"state_list\":\"Standing\"},\"main\":{\"input_name\":\"omg?\",\"preset_list\":2.0},\"misc\":{\"aim_logs\":true,\"aspect_ratio\":true,\"aspect_ratio_val\":139.0,\"clantag\":false,\"fast_ladder\":true,\"fps_boost\":true,\"kibit_hitmark\":true,\"kibit_hitmark_color\":\"#58FFD1FF\",\"no_fall\":true,\"view_model_changer\":true,\"viewmodel_changer_fov\":65.0,\"viewmodel_changer_x\":205.0,\"viewmodel_changer_y\":100.0,\"viewmodel_changer_z\":-100.0},\"rage\":{\"additions\":[\"Warmup / Round End AA\",\"Improve Fakelag on Defensive\",\"Avoid Backstab\",\"~\"],\"anims\":true,\"builder_elements\":{\"Air\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":39.0,\"yaw_left\":-19.0,\"yaw_left_ct\":-22.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":23.0,\"yaw_right_ct\":27.0},\"Air Crouch\":{\"Jitter\":\"Center\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":7.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":-10.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-10.0,\"yaw_left_ct\":-24.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":31.0,\"yaw_right_ct\":30.0},\"Crouch\":{\"Jitter\":\"Center\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":20.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":-31.0,\"yaw_jitter_ovr_ct\":-3.0,\"yaw_left\":5.0,\"yaw_left_ct\":-10.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":5.0,\"yaw_right_ct\":16.0},\"Crouch Moving\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":20.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":-30.0,\"yaw_left\":-10.0,\"yaw_left_ct\":-8.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":31.0,\"yaw_right_ct\":20.0},\"Manual\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"Static\",\"yaw_mode_ct\":\"Static\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Running\":{\"Jitter\":\"Center\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":14.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":-58.0,\"yaw_jitter_ovr_ct\":-62.0,\"yaw_left\":6.0,\"yaw_left_ct\":6.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":6.0,\"yaw_right_ct\":6.0},\"Slowmotion\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-23.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"Static\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":47.0,\"yaw_right_ct\":0.0},\"Standing\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"Static\",\"yaw_mode_ct\":\"Static\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0}},\"freestand_body\":1.0,\"freestand_enablers\":[\"~\"],\"freestand_options\":[\"~\"],\"freestanding_bind\":false,\"hidden_builder\":false,\"keep_fs\":true,\"manual\":\"At Target\",\"prefer_manual\":true,\"safe_head\":false,\"safe_options\":[\"~\"],\"state_list\":\"Standing\",\"team_list\":2.0,\"~anims\":{\"move_fall\":0.0,\"move_jitter\":0.0,\"move_jitter_mode\":2.0,\"move_lean_val\":100.0,\"move_legs1\":0.0,\"move_legs2\":100.0}},\"visuals\":{\"accent\":\"#96C83CFF\",\"crosshair_ind\":false,\"fake_latency_slider\":0.0,\"fake_latency_toggle\":false,\"gs_inds\":false,\"molotov_radius\":true,\"notifs\":true,\"scope\":true,\"slowed_down\":true,\"smokes_radius\":true,\"unlock_fakeduck\":true,\"watermark\":\"Bottom\",\"watermark_style\":1.0,\"~notifs\":{\"notifs_glow_amount\":41.0,\"notifs_hit_clr\":\"#00FF00FF\",\"notifs_miss_clr\":\"#FF0000FF\",\"notifs_prefix\":false,\"notifs_prefix_clr\":\"#00FF00FF\",\"notifs_prefix_font\":1.0,\"notifs_round_amount\":11.0},\"~scope\":{\"scope_color1\":\"#FFFFFFFF\",\"scope_color2\":\"#FFFFFF00\",\"scope_gap\":5.0,\"scope_settings\":[\"~\"],\"scope_size\":100.0,\"scope_style\":1.0}}}");
                    l_pui_0.load(v300);
                    v12.push("aggressive preset has been successfully imported!");
                elseif v298 == 3 then
                    local v301 = json.parse("{\"defensive\":{\"antiaim_conditions\":[\"~\"],\"defensive_conditions\":[\"Standing\",\"Slowmotion\",\"Crouch\",\"Crouch Moving\",\"Air\",\"Air Crouch\",\"~\"],\"disablers\":[\"~\"],\"force_hideshot\":false,\"game_events\":[\"~\"],\"on_exploit\":[\"~\"],\"state_list\":\"Standing\"},\"main\":{\"input_name\":\"type here\",\"preset_list\":4.0},\"misc\":{\"aim_logs\":true,\"aspect_ratio\":true,\"aspect_ratio_val\":133.0,\"clantag\":false,\"fast_ladder\":true,\"fps_boost\":true,\"kibit_hitmark\":true,\"kibit_hitmark_color\":\"#F6F6F6FF\",\"no_fall\":true,\"view_model_changer\":false,\"viewmodel_changer_fov\":68.0,\"viewmodel_changer_x\":205.0,\"viewmodel_changer_y\":100.0,\"viewmodel_changer_z\":-100.0},\"rage\":{\"additions\":[\"Warmup / Round End AA\",\"Improve Fakelag on Defensive\",\"Avoid Backstab\",\"~\"],\"anims\":true,\"builder_elements\":{\"Air\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":4.0,\"body_speed_ct\":4.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-18.0,\"yaw_left_ct\":-18.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":27.0,\"yaw_right_ct\":27.0},\"Air Crouch\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":4.0,\"anti_timeout_ct\":4.0,\"antibrute\":true,\"antibrute_ct\":true,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":4.0,\"body_speed_ct\":4.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":1.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":true,\"limit_random_ct\":true,\"pitch_offset\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":true,\"tick_speed1\":5.0,\"tick_speed2\":15.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-19.0,\"yaw_left_ct\":-19.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":47.0,\"yaw_right_ct\":47.0},\"Crouch\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":4.0,\"body_speed_ct\":4.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":-30.0,\"yaw_center_ct\":-30.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-30.0,\"yaw_left_ct\":-30.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":45.0,\"yaw_right_ct\":45.0},\"Crouch Moving\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":4.0,\"anti_timeout_ct\":4.0,\"antibrute\":true,\"antibrute_ct\":true,\"antibrute_method\":2.0,\"antibrute_method_ct\":2.0,\"body_speed\":4.0,\"body_speed_ct\":4.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":6.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":86.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":-180.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":1.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":3.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":6.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":true,\"tick_speed1\":7.0,\"tick_speed2\":15.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":-76.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-30.0,\"yaw_left_ct\":-30.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":33.0,\"yaw_right_ct\":33.0},\"Manual\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Static\",\"fake_options_ct\":\"Static\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Amnesia\",\"speed_options_ct\":\"Amnesia\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"Static\",\"yaw_mode_ct\":\"Static\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Running\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":12.0,\"ran_speed_2_ct\":12.0,\"random_speed\":true,\"random_speed_ct\":true,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Inverter\",\"speed_options_ct\":\"Inverter\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":-27.0,\"yaw_jitter_ovr_ct\":-27.0,\"yaw_left\":-25.0,\"yaw_left_ct\":-25.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":42.0,\"yaw_right_ct\":42.0},\"Slowmotion\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Custom\",\"center_options_ct\":\"Randomize\",\"custom_amount\":4.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":-22.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":-111.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Auto\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Spin\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":56.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":45.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":7.0,\"ran_speed_1_ct\":11.0,\"ran_speed_2\":10.0,\"ran_speed_2_ct\":17.0,\"random_speed\":true,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Amnesia\",\"speed_options_ct\":\"Amnesia\",\"spin_speed\":4.0,\"tick_random\":false,\"tick_speed1\":22.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-31.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"Static\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":45.0,\"yaw_right_ct\":0.0},\"Standing\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Custom\",\"center_options_ct\":\"Randomize\",\"custom_amount\":4.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":-22.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":-57.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":0.0,\"custom_speed_slider_10\":0.0,\"custom_speed_slider_10_ct\":0.0,\"custom_speed_slider_11\":0.0,\"custom_speed_slider_11_ct\":0.0,\"custom_speed_slider_12\":0.0,\"custom_speed_slider_12_ct\":0.0,\"custom_speed_slider_13\":0.0,\"custom_speed_slider_13_ct\":0.0,\"custom_speed_slider_14\":0.0,\"custom_speed_slider_14_ct\":0.0,\"custom_speed_slider_15\":0.0,\"custom_speed_slider_15_ct\":0.0,\"custom_speed_slider_16\":0.0,\"custom_speed_slider_16_ct\":0.0,\"custom_speed_slider_17\":0.0,\"custom_speed_slider_17_ct\":0.0,\"custom_speed_slider_18\":0.0,\"custom_speed_slider_18_ct\":0.0,\"custom_speed_slider_19\":0.0,\"custom_speed_slider_19_ct\":0.0,\"custom_speed_slider_1_ct\":0.0,\"custom_speed_slider_2\":0.0,\"custom_speed_slider_20\":0.0,\"custom_speed_slider_20_ct\":0.0,\"custom_speed_slider_21\":0.0,\"custom_speed_slider_21_ct\":0.0,\"custom_speed_slider_22\":0.0,\"custom_speed_slider_22_ct\":0.0,\"custom_speed_slider_2_ct\":0.0,\"custom_speed_slider_3\":0.0,\"custom_speed_slider_3_ct\":0.0,\"custom_speed_slider_4\":0.0,\"custom_speed_slider_4_ct\":0.0,\"custom_speed_slider_5\":0.0,\"custom_speed_slider_5_ct\":0.0,\"custom_speed_slider_6\":0.0,\"custom_speed_slider_6_ct\":0.0,\"custom_speed_slider_7\":0.0,\"custom_speed_slider_7_ct\":0.0,\"custom_speed_slider_8\":0.0,\"custom_speed_slider_8_ct\":0.0,\"custom_speed_slider_9\":0.0,\"custom_speed_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"None\",\"extend_option_ct\":\"None\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":16.0,\"flick_left_body_ct\":16.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":16.0,\"flick_right_body_ct\":16.0,\"flick_right_ct\":0.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":7.0,\"flick_speed_random_ct\":7.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":20.0,\"ran_speed_2_ct\":20.0,\"random_speed\":true,\"random_speed_ct\":true,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-33.0,\"yaw_left_ct\":-33.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":41.0,\"yaw_right_ct\":41.0}},\"freestand_body\":1.0,\"freestand_enablers\":[\"~\"],\"freestand_options\":[\"~\"],\"freestanding_bind\":false,\"hidden_builder\":false,\"keep_fs\":false,\"manual\":\"At Target\",\"prefer_manual\":true,\"safe_head\":false,\"safe_options\":[\"~\"],\"state_list\":\"Running\",\"team_list\":1.0,\"~anims\":{\"move_fall\":0.0,\"move_jitter\":0.0,\"move_jitter_mode\":1.0,\"move_lean_val\":0.0,\"move_legs1\":0.0,\"move_legs2\":0.0}},\"visuals\":{\"accent\":\"#96C83CFF\",\"crosshair_ind\":false,\"fake_latency_slider\":0.0,\"fake_latency_toggle\":false,\"gs_inds\":false,\"molotov_radius\":false,\"notifs\":false,\"scope\":true,\"slowed_down\":false,\"smokes_radius\":false,\"unlock_fakeduck\":true,\"watermark\":\"Left\",\"watermark_style\":1.0,\"~notifs\":{\"notifs_glow_amount\":41.0,\"notifs_hit_clr\":\"#00FF00FF\",\"notifs_miss_clr\":\"#FF0000FF\",\"notifs_prefix\":false,\"notifs_prefix_clr\":\"#00FF00FF\",\"notifs_prefix_font\":1.0,\"notifs_round_amount\":11.0},\"~scope\":{\"scope_color1\":\"#FFFFFFFF\",\"scope_color2\":\"#FFFFFF00\",\"scope_gap\":5.0,\"scope_settings\":[\"~\"],\"scope_size\":190.0,\"scope_style\":1.0}}}");
                    l_pui_0.load(v301);
                    v12.push("snap [test] preset has been successfully imported!");
                elseif v298 == 4 then
                    local v302 = json.parse("{\"defensive\":{\"defensive_conditions\":[\"Standing\",\"Slowmotion\",\"Crouch\",\"Crouch Moving\",\"Air\",\"Air Crouch\",\"~\"],\"force_hideshot\":true,\"game_events\":[\"~\"]},\"main\":{\"input_name\":\"hold test2222\",\"preset_list\":8.0},\"misc\":{\"aspect_ratio\":true,\"aspect_ratio_val\":133.0,\"clantag\":false,\"client_nickname\":true,\"fake_latency_toggle\":false,\"fast_ladder\":true,\"freeze_fakeduck\":false,\"log_event\":[\"Aimbot\",\"Purchases\",\"~\"],\"no_fall\":true,\"super_toss\":false,\"unlock_fakeduck\":true,\"view_model_changer\":false,\"viewmodel_changer_fov\":68.0,\"viewmodel_changer_x\":205.0,\"viewmodel_changer_y\":100.0,\"viewmodel_changer_z\":-100.0,\"~client_nickname\":{\"client_nickname_text\":\"brandon\"},\"~fake_latency_toggle\":{\"fake_latency_slider\":0.0}},\"misc_chooser\":2.0,\"rage\":{\"aa_lister\":2.0,\"additions\":[\"Warmup / Round End AA\",\"~\"],\"anims\":true,\"avoid_knife\":true,\"builder_elements\":{\"Air\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":2.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":2.0,\"custom_speed_slider_2\":2.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":2.0,\"custom_speed_slider_3\":2.0,\"custom_speed_slider_3_ct\":2.0,\"custom_speed_slider_4\":2.0,\"custom_speed_slider_4_ct\":2.0,\"custom_speed_slider_5\":2.0,\"custom_speed_slider_5_ct\":2.0,\"custom_speed_slider_6\":2.0,\"custom_speed_slider_6_ct\":2.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":0.0,\"event_handler\":\"createmove\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-18.0,\"yaw_left_ct\":-18.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":27.0,\"yaw_right_ct\":27.0},\"Air Crouch\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":4.0,\"anti_timeout_ct\":4.0,\"antibrute\":true,\"antibrute_ct\":true,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":5.0,\"body_speed_ct\":5.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":2.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":2.0,\"custom_speed_slider_2\":2.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":2.0,\"custom_speed_slider_3\":2.0,\"custom_speed_slider_3_ct\":2.0,\"custom_speed_slider_4\":2.0,\"custom_speed_slider_4_ct\":2.0,\"custom_speed_slider_5\":2.0,\"custom_speed_slider_5_ct\":2.0,\"custom_speed_slider_6\":2.0,\"custom_speed_slider_6_ct\":2.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":1.0,\"event_handler\":\"createmove\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":3.0,\"ran_speed_1_ct\":3.0,\"ran_speed_2\":4.0,\"ran_speed_2_ct\":4.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"tick_random\":false,\"tick_speed1\":16.0,\"tick_speed2\":16.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-19.0,\"yaw_left_ct\":-19.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":47.0,\"yaw_right_ct\":47.0},\"Crouch\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":2.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":2.0,\"custom_speed_slider_2\":2.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":2.0,\"custom_speed_slider_3\":2.0,\"custom_speed_slider_3_ct\":2.0,\"custom_speed_slider_4\":2.0,\"custom_speed_slider_4_ct\":2.0,\"custom_speed_slider_5\":2.0,\"custom_speed_slider_5_ct\":2.0,\"custom_speed_slider_6\":2.0,\"custom_speed_slider_6_ct\":2.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":0.0,\"event_handler\":\"createmove\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":-30.0,\"yaw_center_ct\":-30.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-30.0,\"yaw_left_ct\":-30.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":45.0,\"yaw_right_ct\":45.0},\"Crouch Moving\":{\"Jitter\":\"3-way\",\"Jitter_ct\":\"3-way\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":4.0,\"anti_timeout_ct\":4.0,\"antibrute\":true,\"antibrute_ct\":true,\"antibrute_method\":2.0,\"antibrute_method_ct\":2.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Custom\",\"center_options_ct\":\"Custom\",\"custom_amount\":6.0,\"custom_amount_ct\":6.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":86.0,\"custom_slider_12_ct\":86.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":15.0,\"custom_slider_4_ct\":15.0,\"custom_slider_5\":-10.0,\"custom_slider_5_ct\":-10.0,\"custom_slider_6\":15.0,\"custom_slider_6_ct\":15.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":2.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":2.0,\"custom_speed_slider_2\":2.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":2.0,\"custom_speed_slider_3\":2.0,\"custom_speed_slider_3_ct\":2.0,\"custom_speed_slider_4\":2.0,\"custom_speed_slider_4_ct\":2.0,\"custom_speed_slider_5\":2.0,\"custom_speed_slider_5_ct\":2.0,\"custom_speed_slider_6\":2.0,\"custom_speed_slider_6_ct\":2.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":1.0,\"event_handler\":\"createmove\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":3.0,\"ran_speed_1_ct\":3.0,\"ran_speed_2\":6.0,\"ran_speed_2_ct\":6.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"tick_random\":true,\"tick_speed1\":14.0,\"tick_speed2\":18.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":6.0,\"yaw_jitter_ovr_ct\":6.0,\"yaw_left\":-30.0,\"yaw_left_ct\":-30.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":33.0,\"yaw_right_ct\":33.0},\"Manual\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":2.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":2.0,\"custom_speed_slider_2\":2.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":2.0,\"custom_speed_slider_3\":2.0,\"custom_speed_slider_3_ct\":2.0,\"custom_speed_slider_4\":2.0,\"custom_speed_slider_4_ct\":2.0,\"custom_speed_slider_5\":2.0,\"custom_speed_slider_5_ct\":2.0,\"custom_speed_slider_6\":2.0,\"custom_speed_slider_6_ct\":2.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":0.0,\"event_handler\":\"createmove\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Static\",\"fake_options_ct\":\"Static\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Amnesia\",\"speed_options_ct\":\"Amnesia\",\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Running\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":2.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":2.0,\"custom_speed_slider_2\":2.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":2.0,\"custom_speed_slider_3\":2.0,\"custom_speed_slider_3_ct\":2.0,\"custom_speed_slider_4\":2.0,\"custom_speed_slider_4_ct\":2.0,\"custom_speed_slider_5\":2.0,\"custom_speed_slider_5_ct\":2.0,\"custom_speed_slider_6\":2.0,\"custom_speed_slider_6_ct\":2.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":0.0,\"event_handler\":\"createmove\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":3.0,\"fake_left_random_ct\":3.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":3.0,\"fake_right_random_ct\":3.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":12.0,\"ran_speed_2_ct\":12.0,\"random_speed\":true,\"random_speed_ct\":true,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Amnesia\",\"speed_options_ct\":\"Amnesia\",\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":-27.0,\"yaw_jitter_ovr_ct\":-27.0,\"yaw_left\":-30.0,\"yaw_left_ct\":-30.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":30.0,\"yaw_right_ct\":30.0},\"Slowmotion\":{\"Jitter\":\"Random\",\"Jitter_ct\":\"Random\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Custom\",\"center_options_ct\":\"Custom\",\"custom_amount\":4.0,\"custom_amount_ct\":4.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":-22.0,\"custom_slider_4_ct\":-22.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":-111.0,\"custom_slider_6_ct\":-111.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":2.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":2.0,\"custom_speed_slider_2\":2.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":2.0,\"custom_speed_slider_3\":2.0,\"custom_speed_slider_3_ct\":2.0,\"custom_speed_slider_4\":2.0,\"custom_speed_slider_4_ct\":2.0,\"custom_speed_slider_5\":2.0,\"custom_speed_slider_5_ct\":2.0,\"custom_speed_slider_6\":2.0,\"custom_speed_slider_6_ct\":2.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":0.0,\"event_handler\":\"createmove\",\"fake_left\":56.0,\"fake_left_ct\":56.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":45.0,\"fake_right_ct\":45.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":11.0,\"ran_speed_1_ct\":11.0,\"ran_speed_2\":18.0,\"ran_speed_2_ct\":18.0,\"random_speed\":true,\"random_speed_ct\":true,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"tick_random\":false,\"tick_speed1\":22.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-38.0,\"yaw_left_ct\":-38.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":44.0,\"yaw_right_ct\":44.0},\"Standing\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":4.0,\"custom_amount_ct\":4.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":-22.0,\"custom_slider_4_ct\":-22.0,\"custom_slider_5\":-57.0,\"custom_slider_5_ct\":-57.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":2.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":2.0,\"custom_speed_slider_2\":2.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":2.0,\"custom_speed_slider_3\":2.0,\"custom_speed_slider_3_ct\":2.0,\"custom_speed_slider_4\":2.0,\"custom_speed_slider_4_ct\":2.0,\"custom_speed_slider_5\":2.0,\"custom_speed_slider_5_ct\":2.0,\"custom_speed_slider_6\":2.0,\"custom_speed_slider_6_ct\":2.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":0.0,\"event_handler\":\"createmove\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":20.0,\"ran_speed_2_ct\":20.0,\"random_speed\":true,\"random_speed_ct\":true,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-33.0,\"yaw_left_ct\":-33.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":41.0,\"yaw_right_ct\":41.0}},\"defensive_elements\":{\"Air\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Air Crouch\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Crouch\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Crouch Moving\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Manual\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Running\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Slowmotion\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Standing\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0}},\"freestanding_bind\":false,\"hidden_builder\":false,\"manual\":\"At Target\",\"safe_head\":true,\"state_list\":\"Standing\",\"team_list\":\"T\",\"~anims\":{\"move_fall\":0.0,\"move_jitter\":0.0,\"move_jitter_mode\":2.0,\"move_lean_val\":100.0,\"move_legs1\":0.0,\"move_legs2\":100.0},\"~freestanding_bind\":{\"freestand_body\":1.0,\"freestand_enablers\":[\"~\"],\"freestand_options\":[\"~\"],\"keep_fs\":false,\"prefer_manual\":false},\"~hidden_builder\":{\"antiaim_conditions\":[\"~\"],\"disablers\":[\"~\"],\"on_exploit\":[\"~\"],\"state_list\":\"Standing\"},\"~safe_head\":{\"safe_options\":[3.0,\"~\"]}},\"visuals\":{\"accent\":\"#96C83CFF\",\"gs_inds\":false,\"kibit_hitmark\":false,\"molotov_radius\":false,\"notifs\":false,\"scope\":true,\"slowed_down\":true,\"smokes_radius\":false,\"watermark\":\"Left\",\"watermark_style\":1.0,\"~kibit_hitmark\":{\"kibit_hitmark_color\":\"#58FFD1FF\"},\"~notifs\":{\"notifs_glow_amount\":41.0,\"notifs_hit_clr\":\"#00FF00FF\",\"notifs_miss_clr\":\"#FF0000FF\",\"notifs_prefix\":false,\"notifs_prefix_clr\":\"#00FF00FF\",\"notifs_prefix_font\":1.0,\"notifs_round_amount\":11.0},\"~scope\":{\"scope_color1\":\"#FFFFFFFF\",\"scope_color2\":\"#8A8A8A00\",\"scope_gap\":5.0,\"scope_settings\":[\"~\"],\"scope_size\":201.0,\"scope_style\":1.0}}}");
                    l_pui_0.load(v302);
                    v12.push("custom jitter preset has been successfully imported!");
                elseif v298 == 5 then
                    local v303 = json.parse("{\"defensive\":{\"defensive_conditions\":[\"Standing\",\"Slowmotion\",\"Crouch\",\"Crouch Moving\",\"Air Crouch\",\"~\"],\"force_hideshot\":true,\"game_events\":[\"~\"]},\"main\":{\"input_name\":\"hold test\",\"preset_list\":7.0},\"misc\":{\"aspect_ratio\":true,\"aspect_ratio_val\":133.0,\"clantag\":false,\"client_nickname\":false,\"fake_latency_toggle\":true,\"fast_ladder\":true,\"freeze_fakeduck\":false,\"log_event\":[\"Aimbot\",\"Purchases\",\"~\"],\"no_fall\":true,\"super_toss\":true,\"unlock_fakeduck\":true,\"view_model_changer\":true,\"viewmodel_changer_fov\":72.0,\"viewmodel_changer_x\":0.0,\"viewmodel_changer_y\":-174.0,\"viewmodel_changer_z\":-314.0,\"~client_nickname\":{\"client_nickname_text\":\"Type Here\"},\"~fake_latency_toggle\":{\"fake_latency_slider\":30.0}},\"misc_chooser\":1.0,\"rage\":{\"aa_lister\":2.0,\"additions\":[\"~\"],\"anims\":true,\"avoid_knife\":true,\"builder_elements\":{\"Air\":{\"Jitter\":\"Center\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Custom\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":2.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":2.0,\"custom_speed_slider_2\":2.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":2.0,\"custom_speed_slider_3\":2.0,\"custom_speed_slider_3_ct\":2.0,\"custom_speed_slider_4\":2.0,\"custom_speed_slider_4_ct\":2.0,\"custom_speed_slider_5\":2.0,\"custom_speed_slider_5_ct\":2.0,\"custom_speed_slider_6\":2.0,\"custom_speed_slider_6_ct\":2.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":0.0,\"event_handler\":\"createmove\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Air Crouch\":{\"Jitter\":\"Hold\",\"Jitter_ct\":\"Random\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":7.0,\"amplitude_ct\":7.0,\"anti_timeout\":4.0,\"anti_timeout_ct\":4.0,\"antibrute\":true,\"antibrute_ct\":true,\"antibrute_method\":2.0,\"antibrute_method_ct\":2.0,\"body_speed\":1.0,\"body_speed_ct\":10.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Custom\",\"center_options_ct\":\"Custom\",\"custom_amount\":12.0,\"custom_amount_ct\":12.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":-24.0,\"custom_slider_12_ct\":-24.0,\"custom_slider_13\":6.0,\"custom_slider_13_ct\":6.0,\"custom_slider_14\":-6.0,\"custom_slider_14_ct\":-6.0,\"custom_slider_15\":-10.0,\"custom_slider_15_ct\":-10.0,\"custom_slider_16\":-23.0,\"custom_slider_16_ct\":-23.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":-19.0,\"custom_slider_6_ct\":-19.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":6.0,\"custom_speed_amount_ct\":6.0,\"custom_speed_slider_1\":1.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":1.0,\"custom_speed_slider_2\":1.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":1.0,\"custom_speed_slider_3\":1.0,\"custom_speed_slider_3_ct\":1.0,\"custom_speed_slider_4\":1.0,\"custom_speed_slider_4_ct\":1.0,\"custom_speed_slider_5\":1.0,\"custom_speed_slider_5_ct\":1.0,\"custom_speed_slider_6\":20.0,\"custom_speed_slider_6_ct\":20.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":1.0,\"event_handler\":\"createmove\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":8.0,\"fake_left_random_ct\":8.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":8.0,\"fake_right_random_ct\":8.0,\"frequency\":18.0,\"frequency_ct\":18.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":5.0,\"ran_speed_2\":5.0,\"ran_speed_2_ct\":10.0,\"random_speed\":false,\"random_speed_ct\":true,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Inverter\",\"tick_random\":true,\"tick_speed1\":12.0,\"tick_speed2\":16.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-23.0,\"yaw_left_ct\":-25.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":3.0,\"yaw_right\":45.0,\"yaw_right_ct\":45.0},\"Crouch\":{\"Jitter\":\"Random\",\"Jitter_ct\":\"Random\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":10.0,\"body_speed_ct\":10.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Custom\",\"center_options_ct\":\"Custom\",\"custom_amount\":6.0,\"custom_amount_ct\":6.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":-15.0,\"custom_slider_5_ct\":-15.0,\"custom_slider_6\":19.0,\"custom_slider_6_ct\":19.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":6.0,\"custom_speed_amount_ct\":6.0,\"custom_speed_slider_1\":2.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":2.0,\"custom_speed_slider_2\":3.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":3.0,\"custom_speed_slider_3\":4.0,\"custom_speed_slider_3_ct\":4.0,\"custom_speed_slider_4\":5.0,\"custom_speed_slider_4_ct\":5.0,\"custom_speed_slider_5\":3.0,\"custom_speed_slider_5_ct\":3.0,\"custom_speed_slider_6\":2.0,\"custom_speed_slider_6_ct\":2.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":1.0,\"event_handler\":\"createmove\",\"fake_left\":58.0,\"fake_left_ct\":58.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":58.0,\"fake_right_ct\":58.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"tick_random\":false,\"tick_speed1\":16.0,\"tick_speed2\":1.0,\"yaw_center\":-30.0,\"yaw_center_ct\":-30.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-32.0,\"yaw_left_ct\":-32.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":4.0,\"yaw_randomize_ct\":4.0,\"yaw_right\":52.0,\"yaw_right_ct\":52.0},\"Crouch Moving\":{\"Jitter\":\"Hold\",\"Jitter_ct\":\"Hold\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":4.0,\"anti_timeout_ct\":4.0,\"antibrute\":true,\"antibrute_ct\":true,\"antibrute_method\":2.0,\"antibrute_method_ct\":2.0,\"body_speed\":6.0,\"body_speed_ct\":6.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Custom\",\"center_options_ct\":\"Custom\",\"custom_amount\":6.0,\"custom_amount_ct\":6.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":-6.0,\"custom_slider_13_ct\":-6.0,\"custom_slider_14\":-19.0,\"custom_slider_14_ct\":-19.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":-15.0,\"custom_slider_5_ct\":-15.0,\"custom_slider_6\":19.0,\"custom_slider_6_ct\":19.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":5.0,\"custom_speed_amount_ct\":5.0,\"custom_speed_slider_1\":4.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":4.0,\"custom_speed_slider_2\":4.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":4.0,\"custom_speed_slider_3\":6.0,\"custom_speed_slider_3_ct\":6.0,\"custom_speed_slider_4\":4.0,\"custom_speed_slider_4_ct\":4.0,\"custom_speed_slider_5\":4.0,\"custom_speed_slider_5_ct\":4.0,\"custom_speed_slider_6\":2.0,\"custom_speed_slider_6_ct\":2.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":1.0,\"event_handler\":\"createmove\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":4.0,\"ran_speed_1_ct\":4.0,\"ran_speed_2\":14.0,\"ran_speed_2_ct\":14.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"tick_random\":true,\"tick_speed1\":14.0,\"tick_speed2\":18.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":6.0,\"yaw_jitter_ovr_ct\":6.0,\"yaw_left\":-30.0,\"yaw_left_ct\":-30.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":35.0,\"yaw_right_ct\":35.0},\"Manual\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":2.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":2.0,\"custom_speed_slider_2\":2.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":2.0,\"custom_speed_slider_3\":2.0,\"custom_speed_slider_3_ct\":2.0,\"custom_speed_slider_4\":2.0,\"custom_speed_slider_4_ct\":2.0,\"custom_speed_slider_5\":2.0,\"custom_speed_slider_5_ct\":2.0,\"custom_speed_slider_6\":2.0,\"custom_speed_slider_6_ct\":2.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":0.0,\"event_handler\":\"createmove\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Running\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":4.0,\"anti_timeout_ct\":4.0,\"antibrute\":true,\"antibrute_ct\":true,\"antibrute_method\":2.0,\"antibrute_method_ct\":2.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":3.0,\"custom_speed_amount_ct\":3.0,\"custom_speed_slider_1\":5.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":5.0,\"custom_speed_slider_2\":8.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":8.0,\"custom_speed_slider_3\":2.0,\"custom_speed_slider_3_ct\":2.0,\"custom_speed_slider_4\":9.0,\"custom_speed_slider_4_ct\":9.0,\"custom_speed_slider_5\":1.0,\"custom_speed_slider_5_ct\":1.0,\"custom_speed_slider_6\":1.0,\"custom_speed_slider_6_ct\":1.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":0.0,\"event_handler\":\"createmove\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":3.0,\"fake_left_random_ct\":3.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":3.0,\"fake_right_random_ct\":3.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":4.0,\"ran_speed_1_ct\":4.0,\"ran_speed_2\":6.0,\"ran_speed_2_ct\":6.0,\"random_speed\":true,\"random_speed_ct\":true,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":-27.0,\"yaw_jitter_ovr_ct\":-27.0,\"yaw_left\":-30.0,\"yaw_left_ct\":-30.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":30.0,\"yaw_right_ct\":30.0},\"Slowmotion\":{\"Jitter\":\"Random\",\"Jitter_ct\":\"Random\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":4.0,\"anti_timeout_ct\":4.0,\"antibrute\":true,\"antibrute_ct\":true,\"antibrute_method\":2.0,\"antibrute_method_ct\":2.0,\"body_speed\":10.0,\"body_speed_ct\":10.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Custom\",\"center_options_ct\":\"Custom\",\"custom_amount\":6.0,\"custom_amount_ct\":6.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":-19.0,\"custom_slider_5_ct\":-19.0,\"custom_slider_6\":15.0,\"custom_slider_6_ct\":15.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":6.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":6.0,\"custom_speed_slider_2\":2.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":2.0,\"custom_speed_slider_3\":2.0,\"custom_speed_slider_3_ct\":2.0,\"custom_speed_slider_4\":2.0,\"custom_speed_slider_4_ct\":2.0,\"custom_speed_slider_5\":2.0,\"custom_speed_slider_5_ct\":2.0,\"custom_speed_slider_6\":2.0,\"custom_speed_slider_6_ct\":2.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":1.0,\"event_handler\":\"createmove\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":3.0,\"fake_left_random_ct\":3.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":3.0,\"fake_right_random_ct\":3.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":14.0,\"ran_speed_2_ct\":14.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Custom\",\"random_speed_method_ct\":\"Custom\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Inverter\",\"speed_options_ct\":\"Inverter\",\"tick_random\":false,\"tick_speed1\":16.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-38.0,\"yaw_left_ct\":-38.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":3.0,\"yaw_randomize_ct\":3.0,\"yaw_right\":45.0,\"yaw_right_ct\":45.0},\"Standing\":{\"Jitter\":\"Hold\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":4.0,\"custom_amount_ct\":4.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":-22.0,\"custom_slider_4_ct\":-22.0,\"custom_slider_5\":-57.0,\"custom_slider_5_ct\":-57.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"custom_speed_amount\":1.0,\"custom_speed_amount_ct\":1.0,\"custom_speed_slider_1\":2.0,\"custom_speed_slider_10\":2.0,\"custom_speed_slider_10_ct\":2.0,\"custom_speed_slider_11\":2.0,\"custom_speed_slider_11_ct\":2.0,\"custom_speed_slider_12\":2.0,\"custom_speed_slider_12_ct\":2.0,\"custom_speed_slider_13\":2.0,\"custom_speed_slider_13_ct\":2.0,\"custom_speed_slider_14\":2.0,\"custom_speed_slider_14_ct\":2.0,\"custom_speed_slider_15\":2.0,\"custom_speed_slider_15_ct\":2.0,\"custom_speed_slider_16\":2.0,\"custom_speed_slider_16_ct\":2.0,\"custom_speed_slider_17\":2.0,\"custom_speed_slider_17_ct\":2.0,\"custom_speed_slider_18\":2.0,\"custom_speed_slider_18_ct\":2.0,\"custom_speed_slider_19\":2.0,\"custom_speed_slider_19_ct\":2.0,\"custom_speed_slider_1_ct\":2.0,\"custom_speed_slider_2\":2.0,\"custom_speed_slider_20\":2.0,\"custom_speed_slider_20_ct\":2.0,\"custom_speed_slider_21\":2.0,\"custom_speed_slider_21_ct\":2.0,\"custom_speed_slider_22\":2.0,\"custom_speed_slider_22_ct\":2.0,\"custom_speed_slider_2_ct\":2.0,\"custom_speed_slider_3\":2.0,\"custom_speed_slider_3_ct\":2.0,\"custom_speed_slider_4\":2.0,\"custom_speed_slider_4_ct\":2.0,\"custom_speed_slider_5\":2.0,\"custom_speed_slider_5_ct\":2.0,\"custom_speed_slider_6\":2.0,\"custom_speed_slider_6_ct\":2.0,\"custom_speed_slider_7\":2.0,\"custom_speed_slider_7_ct\":2.0,\"custom_speed_slider_8\":2.0,\"custom_speed_slider_8_ct\":2.0,\"custom_speed_slider_9\":2.0,\"custom_speed_slider_9_ct\":2.0,\"defensive_tickbase\":0.0,\"event_handler\":\"createmove\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":20.0,\"ran_speed_2_ct\":20.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-23.0,\"yaw_left_ct\":-23.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":45.0,\"yaw_right_ct\":37.0}},\"defensive_elements\":{\"Air\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Air Crouch\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Crouch\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Crouch Moving\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Manual\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Running\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Slowmotion\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Standing\":{\"Jitter\":\"Disabled\",\"Jitter_ct\":\"Disabled\",\"amnesia_tick_speed\":16.0,\"amnesia_tick_speed_ct\":16.0,\"amplitude\":0.0,\"amplitude_ct\":0.0,\"body_speed\":1.0,\"body_speed_ct\":1.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"def_activation\":\"Always\",\"def_activation_ct\":\"Always\",\"def_pitch\":\"Down\",\"def_pitch_ct\":\"Down\",\"def_toggle\":false,\"def_toggle_ct\":false,\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"frequency\":0.0,\"frequency_ct\":0.0,\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"pitch_offset\":0.0,\"pitch_offset_ct\":0.0,\"r_max\":0.0,\"r_max_ct\":0.0,\"r_min\":0.0,\"r_min_ct\":0.0,\"ran_speed_1\":1.0,\"ran_speed_1_ct\":1.0,\"ran_speed_2\":1.0,\"ran_speed_2_ct\":1.0,\"random_speed\":false,\"random_speed_ct\":false,\"random_speed_method\":\"Random\",\"random_speed_method_ct\":\"Random\",\"scale\":0.0,\"scale_ct\":0.0,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"spin_speed_ct\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_random_methods\":\"Default\",\"yaw_random_methods_ct\":\"Default\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0}},\"freestanding_bind\":false,\"hidden_builder\":false,\"manual\":\"At Target\",\"safe_head\":true,\"state_list\":\"Crouch Moving\",\"team_list\":\"T\",\"~anims\":{\"move_fall\":0.0,\"move_jitter\":0.0,\"move_jitter_mode\":2.0,\"move_lean_val\":100.0,\"move_legs1\":0.0,\"move_legs2\":100.0},\"~freestanding_bind\":{\"freestand_body\":2.0,\"freestand_enablers\":[\"~\"],\"freestand_options\":[\"~\"],\"keep_fs\":false,\"prefer_manual\":false},\"~hidden_builder\":{\"antiaim_conditions\":[\"~\"],\"disablers\":[\"~\"],\"on_exploit\":[\"~\"],\"state_list\":\"Standing\"},\"~safe_head\":{\"safe_options\":[\"~\"]}},\"visuals\":{\"accent\":\"#FBC3FAFF\",\"gs_inds\":true,\"kibit_hitmark\":true,\"molotov_radius\":false,\"notifs\":false,\"scope\":true,\"slowed_down\":true,\"smokes_radius\":false,\"watermark\":\"Bottom\",\"watermark_style\":1.0,\"~kibit_hitmark\":{\"kibit_hitmark_color\":\"#58FFD1FF\"},\"~notifs\":{\"notifs_glow_amount\":41.0,\"notifs_hit_clr\":\"#FBC3FAFF\",\"notifs_miss_clr\":\"#FF0000FF\",\"notifs_prefix\":true,\"notifs_prefix_clr\":\"#FBC3FAFF\",\"notifs_prefix_font\":4.0,\"notifs_round_amount\":11.0},\"~scope\":{\"scope_color1\":\"#C5C5C5FF\",\"scope_color2\":\"#FFFFFF00\",\"scope_gap\":5.0,\"scope_settings\":[\"~\"],\"scope_size\":197.0,\"scope_style\":1.0}}}");
                    l_pui_0.load(v303);
                    v12.push("dynamic preset has been successfully imported!");
                end;
                return;
            else
                local v304 = v7.get_config_name_from_index(v298);
                if not v304 then
                    v12.push("no config found with the selected index");
                    return;
                else
                    local v305 = (db.configurations4 or {})[v304];
                    if not v305 then
                        v12.push("no config found with name : " .. v304);
                        return;
                    else
                        local _ = "{\"defensive\":{\"antiaim_conditions\":[\"Standing\",\"Slowmotion\",\"Crouch\",\"Crouch Moving\",\"Air\",\"Air Crouch\",\"~\"],\"defensive_conditions\":[\"Standing\",\"Slowmotion\",\"Crouch\",\"Crouch Moving\",\"Air\",\"Air Crouch\",\"~\"],\"disablers\":[\"freestanding\",\"manual aa\",\"peek assist\",\"~\"],\"force_hideshot\":true,\"game_events\":[\"~\"],\"on_exploit\":[\"doubletap\",\"hideshots\",\"~\"],\"state_list\":\"Air Crouch\"},\"main\":{\"input_name\":\"default\",\"preset_list\":6.0},\"misc\":{\"aim_logs\":true,\"aspect_ratio\":true,\"aspect_ratio_val\":134.0,\"clantag\":false,\"fake_latency\":15.0,\"fast_ladder\":true,\"fps_boost\":true,\"kibit_hitmark\":false,\"kibit_hitmark_color\":\"#58FFD1FF\",\"no_fall\":false,\"view_model_changer\":true,\"viewmodel_changer_fov\":68.0,\"viewmodel_changer_x\":100.0,\"viewmodel_changer_y\":-100.0,\"viewmodel_changer_z\":200.0},\"rage\":{\"anim_options\":[1.0,2.0,\"~\"],\"anims\":true,\"anti_back\":false,\"builder_elements\":{\"Air\":{\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Auto\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Spin\",\"extend_option\":\"none\",\"extend_option_ct\":\"none\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":2.0,\"fake_left_random_ct\":2.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":5.0,\"fake_right_random_ct\":5.0,\"flick_left\":-11.0,\"flick_left_body\":24.0,\"flick_left_body_ct\":24.0,\"flick_left_ct\":-11.0,\"flick_right\":11.0,\"flick_right_body\":26.0,\"flick_right_body_ct\":26.0,\"flick_right_ct\":11.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":5.0,\"flick_speed_random_ct\":6.0,\"Jitter\":\"Disabled\",\"jitter_ct\":\"Disabled\",\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":true,\"limit_random_ct\":true,\"pitch_offset\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":3.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-29.0,\"yaw_left_ct\":-29.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":35.0,\"yaw_right_ct\":35.0},\"Air Crouch\":{\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Spin\",\"extend_option\":\"none\",\"extend_option_ct\":\"none\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":-7.0,\"flick_left_body\":24.0,\"flick_left_body_ct\":24.0,\"flick_left_ct\":-7.0,\"flick_right\":15.0,\"flick_right_body\":26.0,\"flick_right_body_ct\":26.0,\"flick_right_ct\":15.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":3.0,\"flick_speed_random_ct\":3.0,\"Jitter\":\"Disabled\",\"jitter_ct\":\"Disabled\",\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":true,\"limit_random_ct\":true,\"pitch_offset\":-89.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":2.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-18.0,\"yaw_left_ct\":-18.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":44.0,\"yaw_right_ct\":44.0},\"Crouch\":{\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Spin\",\"extend_option\":\"none\",\"extend_option_ct\":\"none\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":0.0,\"flick_left_body_ct\":0.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":0.0,\"flick_right_body_ct\":0.0,\"flick_right_ct\":0.0,\"flick_speed\":1.0,\"flick_speed_ct\":1.0,\"flick_speed_random\":1.0,\"flick_speed_random_ct\":1.0,\"Jitter\":\"Disabled\",\"jitter_ct\":\"Disabled\",\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":true,\"limit_random_ct\":true,\"pitch_offset\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-32.0,\"yaw_left_ct\":-32.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":46.0,\"yaw_right_ct\":46.0},\"Crouch Moving\":{\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Spin\",\"extend_option\":\"none\",\"extend_option_ct\":\"none\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":-3.0,\"flick_left_body\":25.0,\"flick_left_body_ct\":8.0,\"flick_left_ct\":-7.0,\"flick_right\":6.0,\"flick_right_body\":29.0,\"flick_right_body_ct\":8.0,\"flick_right_ct\":12.0,\"flick_speed\":7.0,\"flick_speed_ct\":7.0,\"flick_speed_random\":3.0,\"flick_speed_random_ct\":5.0,\"Jitter\":\"Disabled\",\"jitter_ct\":\"Disabled\",\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":true,\"limit_random_ct\":true,\"pitch_offset\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-22.0,\"yaw_left_ct\":-22.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":44.0,\"yaw_right_ct\":44.0},\"Manual\":{\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Static\",\"extend_option\":\"none\",\"extend_option_ct\":\"none\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":0.0,\"flick_left_body_ct\":0.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":0.0,\"flick_right_body_ct\":0.0,\"flick_right_ct\":0.0,\"flick_speed\":1.0,\"flick_speed_ct\":1.0,\"flick_speed_random\":1.0,\"flick_speed_random_ct\":1.0,\"Jitter\":\"Center\",\"jitter_ct\":\"Center\",\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":0.0,\"yaw_left_ct\":0.0,\"yaw_mode\":\"Static\",\"yaw_mode_ct\":\"Static\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":0.0,\"yaw_right_ct\":0.0},\"Running\":{\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Random\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Random\",\"extend_option\":\"none\",\"extend_option_ct\":\"none\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":-12.0,\"flick_left_body\":26.0,\"flick_left_body_ct\":26.0,\"flick_left_ct\":-12.0,\"flick_right\":8.0,\"flick_right_body\":20.0,\"flick_right_body_ct\":20.0,\"flick_right_ct\":8.0,\"flick_speed\":8.0,\"flick_speed_ct\":8.0,\"flick_speed_random\":5.0,\"flick_speed_random_ct\":5.0,\"Jitter\":\"Disabled\",\"jitter_ct\":\"Disabled\",\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":true,\"limit_random_ct\":true,\"pitch_offset\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":180.0,\"yaw_jitter_ovr_ct\":180.0,\"yaw_left\":-24.0,\"yaw_left_ct\":-24.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":37.0,\"yaw_right_ct\":37.0},\"Slowmotion\":{\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":0.0,\"center_max_ct\":0.0,\"center_min\":0.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Auto\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Spin\",\"extend_option\":\"none\",\"extend_option_ct\":\"none\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":0.0,\"flick_left_body_ct\":0.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":0.0,\"flick_right_body_ct\":0.0,\"flick_right_ct\":0.0,\"flick_speed\":1.0,\"flick_speed_ct\":1.0,\"flick_speed_random\":1.0,\"flick_speed_random_ct\":1.0,\"Jitter\":\"Disabled\",\"jitter_ct\":\"Disabled\",\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":0.0,\"yaw_jitter_ovr_ct\":0.0,\"yaw_left\":-23.0,\"yaw_left_ct\":-23.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":47.0,\"yaw_right_ct\":47.0},\"Standing\":{\"anti_timeout\":0.0,\"anti_timeout_ct\":0.0,\"antibrute\":false,\"antibrute_ct\":false,\"antibrute_method\":1.0,\"antibrute_method_ct\":1.0,\"body_speed\":2.0,\"body_speed_ct\":2.0,\"body_yaw\":true,\"body_yaw_ct\":true,\"center_max\":-5.0,\"center_max_ct\":0.0,\"center_min\":5.0,\"center_min_ct\":0.0,\"center_options\":\"Randomize\",\"center_options_ct\":\"Randomize\",\"custom_amount\":1.0,\"custom_amount_ct\":1.0,\"custom_slider_1\":0.0,\"custom_slider_10\":0.0,\"custom_slider_10_ct\":0.0,\"custom_slider_11\":0.0,\"custom_slider_11_ct\":0.0,\"custom_slider_12\":0.0,\"custom_slider_12_ct\":0.0,\"custom_slider_13\":0.0,\"custom_slider_13_ct\":0.0,\"custom_slider_14\":0.0,\"custom_slider_14_ct\":0.0,\"custom_slider_15\":0.0,\"custom_slider_15_ct\":0.0,\"custom_slider_16\":0.0,\"custom_slider_16_ct\":0.0,\"custom_slider_17\":0.0,\"custom_slider_17_ct\":0.0,\"custom_slider_18\":0.0,\"custom_slider_18_ct\":0.0,\"custom_slider_19\":0.0,\"custom_slider_19_ct\":0.0,\"custom_slider_1_ct\":0.0,\"custom_slider_2\":0.0,\"custom_slider_20\":0.0,\"custom_slider_20_ct\":0.0,\"custom_slider_21\":0.0,\"custom_slider_21_ct\":0.0,\"custom_slider_22\":0.0,\"custom_slider_22_ct\":0.0,\"custom_slider_2_ct\":0.0,\"custom_slider_3\":0.0,\"custom_slider_3_ct\":0.0,\"custom_slider_4\":0.0,\"custom_slider_4_ct\":0.0,\"custom_slider_5\":0.0,\"custom_slider_5_ct\":0.0,\"custom_slider_6\":0.0,\"custom_slider_6_ct\":0.0,\"custom_slider_7\":0.0,\"custom_slider_7_ct\":0.0,\"custom_slider_8\":0.0,\"custom_slider_8_ct\":0.0,\"custom_slider_9\":0.0,\"custom_slider_9_ct\":0.0,\"def_activation\":\"Always\",\"def_static_offset\":0.0,\"defensive_pitch\":\"Auto\",\"defensive_tickbase\":0.0,\"defensive_yaw\":\"Spin\",\"extend_option\":\"none\",\"extend_option_ct\":\"none\",\"fake_left\":60.0,\"fake_left_ct\":60.0,\"fake_left_random\":0.0,\"fake_left_random_ct\":0.0,\"fake_options\":\"Jitter\",\"fake_options_ct\":\"Jitter\",\"fake_right\":60.0,\"fake_right_ct\":60.0,\"fake_right_random\":0.0,\"fake_right_random_ct\":0.0,\"flick_left\":0.0,\"flick_left_body\":0.0,\"flick_left_body_ct\":0.0,\"flick_left_ct\":0.0,\"flick_right\":0.0,\"flick_right_body\":0.0,\"flick_right_body_ct\":0.0,\"flick_right_ct\":0.0,\"flick_speed\":1.0,\"flick_speed_ct\":1.0,\"flick_speed_random\":1.0,\"flick_speed_random_ct\":1.0,\"Jitter\":\"Disabled\",\"jitter_ct\":\"Disabled\",\"jitter_randomize\":0.0,\"jitter_randomize_ct\":0.0,\"limit_random\":false,\"limit_random_ct\":false,\"pitch_offset\":0.0,\"ran_speed_1\":2.0,\"ran_speed_1_ct\":2.0,\"ran_speed_2\":2.0,\"ran_speed_2_ct\":2.0,\"random_speed\":false,\"random_speed_ct\":false,\"speed_options\":\"Neverlose\",\"speed_options_ct\":\"Neverlose\",\"spin_speed\":1.0,\"tick_random\":false,\"tick_speed1\":1.0,\"tick_speed2\":1.0,\"yaw_center\":0.0,\"yaw_center_ct\":0.0,\"yaw_jitter_ovr\":92.0,\"yaw_jitter_ovr_ct\":92.0,\"yaw_left\":-24.0,\"yaw_left_ct\":-24.0,\"yaw_mode\":\"L - R\",\"yaw_mode_ct\":\"L - R\",\"yaw_randomize\":0.0,\"yaw_randomize_ct\":0.0,\"yaw_right\":41.0,\"yaw_right_ct\":41.0}},\"fluccate_fakelag\":true,\"freestand_body\":2.0,\"freestand_enablers\":[\"~\"],\"freestand_options\":[\"~\"],\"freestanding_bind\":false,\"keep_fs\":true,\"Manual\":\"At Target\",\"move_lean_val\":100.0,\"prefer_manual\":true,\"safe_head\":[\"~\"],\"state_list\":\"Air Crouch\",\"team_list\":1.0},\"visuals\":{\"accent\":\"#DFC3FFFF\",\"crosshair_ind\":false,\"gs_inds\":false,\"molotov_radius\":true,\"notifs\":false,\"notifs_hit_clr\":\"#00FF00FF\",\"notifs_miss_clr\":\"#FF0000FF\",\"scope\":true,\"slowed_down\":true,\"smokes_radius\":true,\"watermark\":\"Left\",\"watermark_style\":1.0}}";
                        local v307 = renameKeys(v305);
                        l_pui_0.load(v307);
                        v12.push("config loaded : " .. v304);
                        return;
                    end;
                end;
            end;
        end;
        v7.delete_config = function()
            -- upvalues: v9 (ref), v12 (ref), v7 (ref)
            local v308 = v9.main.preset_list:get();
            if v308 <= 7 then
                v12.push("cannot delete predefined config");
                return;
            else
                local v309 = v7.get_config_name_from_index(v308);
                if not v309 then
                    v12.push("no config found with the selected index");
                    return;
                else
                    local v310 = db.configurations4 or {};
                    v310[v309] = nil;
                    db.configurations4 = v310;
                    v7.update_config_list();
                    v12.push("config deleted : " .. v309);
                    return;
                end;
            end;
        end;
    end;
    v124.start = function()
        -- upvalues: v32 (ref), v12 (ref), l_clipboard_0 (ref), l_core_0 (ref)
        local v311 = v32 == "BETA";
        network.get("https://api.github.com/repos/zxjapan/ls_config/contents/codes.txt", {
            Accept = "application/vnd.github.v3.raw", 
            ["User-Agent"] = "LuaSense", 
            ["Cache-Control"] = "no-cache", 
            Authorization = "token " .. "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"
        }, function(v312, _, _)
            -- upvalues: v12 (ref), v311 (ref), l_clipboard_0 (ref), l_core_0 (ref)
            if not v312 then
                v12.push("Failed to fetch verification codes");
                return;
            else
                local v315 = {};
                for v316 in v312:gmatch("[^\r\n]+") do
                    table.insert(v315, v316);
                end;
                local v317 = v311 and ":beta" or ":live";
                local v318 = nil;
                for _, v320 in ipairs(v315) do
                    if v320:sub(-#v317) == v317 then
                        v318 = v320;
                        break;
                    end;
                end;
                if not v318 then
                    v12.push(string.format("No %s verification codes available", v311 and "beta" or "live"));
                    return;
                else
                    l_clipboard_0.set(v318);
                    v12.push(string.format("Your verification code: %s", v318));
                    v12.push("Code is in your Console!");
                    l_core_0:branded_printing(string.format("Your verification code: %s", v318));
                    l_core_0:branded_printing("Please enter this code in our Discord bot");
                    return;
                end;
            end;
        end);
    end;
    v124.check = function()
        -- upvalues: v124 (ref)
        v124.start();
    end;
    v292 = nil;
    local v321 = ffi.cast("uintptr_t**", utils.opcode_scan("engine.dll", "A1 ? ? ? ? 0F 28 C1 F3 0F 5C 80 ? ? ? ? F3 0F 11 45 ? A1 ? ? ? ? 56 85 C0 75 04 33 F6 EB 26 80 78 14 00 74 F6 8B 4D 08 33 D2 E8 ? ? ? ? 8B F0 85 F6", 1));
    local v322 = ffi.typeof("        struct {\n            int64_t         unknown;\n            int64_t         steamID64;\n            char            szName[128];\n            int             userId;\n            char            szSteamID[20];\n            char            pad_0x00A8[0x10];\n            unsigned long   iSteamID;\n            char            szFriendsName[128];\n            bool            fakeplayer;\n            bool            ishltv;\n            unsigned int    customfiles[4];\n            unsigned char   filesdownloaded;\n        }\n    ");
    local v323 = utils.get_vfunc(11, ffi.typeof("$*(__thiscall*)(void*, int, int*)", v322));
    local v324 = nil;
    do
        local l_v321_0, l_v323_0, l_v324_0 = v321, v323, v324;
        local function v334(v328)
            -- upvalues: l_v321_0 (ref), l_v323_0 (ref), l_v324_0 (ref)
            local v329 = entity.get_local_player();
            if not v329 then
                return;
            else
                local v330 = l_v321_0[0][0];
                if not v330 then
                    return;
                else
                    local v331 = ffi.cast("void***", v330 + 21184)[0];
                    if not v331 then
                        return;
                    else
                        local v332 = l_v323_0(v331, v329:get_index() - 1, nil);
                        if not v332 then
                            return;
                        else
                            local v333 = ffi.string(v332[0].szName);
                            if v328 ~= v333 and l_v324_0 == nil then
                                l_v324_0 = v333;
                            end;
                            ffi.copy(v332[0].szName, v328, #v328 + 1);
                            return;
                        end;
                    end;
                end;
            end;
        end;
        local v335 = false;
        local function v337()
            -- upvalues: v9 (ref), v335 (ref), v334 (ref), l_v324_0 (ref)
            local v336 = v9.misc.client_nickname.client_nickname_text:get():sub(0, 32);
            v9.misc.client_nickname.client_nickname_text:set(v336);
            if not v9.misc.client_nickname:get() or #v336 == 0 then
                if v335 then
                    v335 = false;
                    v334(l_v324_0 or panorama.MyPersonaAPI.GetName());
                    l_v324_0 = nil;
                end;
                return;
            else
                v335 = true;
                v334(v336);
                return;
            end;
        end;
        events.net_update_start(v337);
        events.net_update_end(v337);
        v337();
    end;
    l_core_0.super_toss = {
        damp = 0.3
    };
    l_core_0.resolve_grenade_throw = function(v338, v339, v340, v341)
        -- upvalues: v19 (ref), l_core_0 (ref)
        v338.x = v338.x - 10 + math.abs(v338.x) / 9;
        local v342 = vector():angles(v338);
        local v343 = v341 * 1.25;
        local v344 = math.clamp(v339 * 0.9, 15, 750);
        local v345 = math.clamp(v340, 0, 1);
        v344 = v344 * v19.math.lerp(l_core_0.super_toss.damp, 1, v345);
        local l_v342_0 = v342;
        for _ = 1, 8 do
            l_v342_0 = (v342 * (l_v342_0 * v344 + v343):length() - v343) / v344;
            l_v342_0:normalize();
        end;
        local v348 = l_v342_0.angles(l_v342_0);
        if v348.x > -10 then
            v348.x = 0.9 * v348.x + 9;
        else
            v348.x = 1.125 * v348.x + 11.25;
        end;
        return v348;
    end;
    l_core_0.on_grenade_override_view = function(v349)
        -- upvalues: v9 (ref), l_core_0 (ref)
        local v350 = entity.get_local_player();
        if v350 == nil or not v350:is_alive() then
            return;
        elseif not v9.misc.super_toss:get() then
            return;
        else
            local v351 = v350:get_player_weapon();
            if v351 == nil then
                return;
            else
                local v352 = v351:get_weapon_info();
                if v352 == nil then
                    return;
                elseif v352.weapon_type ~= 9 then
                    return;
                else
                    v349.angles = l_core_0.resolve_grenade_throw(v349.angles, v352.throw_velocity, v351.m_flThrowStrength, v349.velocity);
                    return;
                end;
            end;
        end;
    end;
    v321 = vector();
    v322 = vector();
    l_core_0.handle_supertoss = function(v353)
        -- upvalues: v9 (ref), l_core_0 (ref)
        if v353.jitter_move ~= true then
            return;
        elseif not v9.misc.super_toss:get() then
            return;
        else
            local v354 = entity.get_local_player();
            if v354 == nil then
                return;
            elseif v354:get_player_weapon() == nil then
                return;
            else
                local v355 = v354:get_player_weapon();
                local v356 = v355:get_weapon_info();
                local _ = v355:get_name();
                if v356 == nil or v356.weapon_type ~= 9 then
                    return;
                elseif v355.m_fThrowTime < globals.curtime - to_time(globals.clock_offset) then
                    return;
                else
                    v353.in_speed = true;
                    local v358 = v354:simulate_movement();
                    v358:think();
                    v353.view_angles = l_core_0.resolve_grenade_throw(v353.view_angles, v356.throw_velocity, v355.m_flThrowStrength, v358.velocity);
                    return;
                end;
            end;
        end;
    end;
    events.createmove(l_core_0.handle_supertoss);
    events.grenade_override_view(l_core_0.on_grenade_override_view);
    v323 = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck");
    v324 = l_smoothy_0.new(46);
    l_core_0.freezetime = false;
    l_core_0.fake_duck = function(v359)
        -- upvalues: v9 (ref), l_core_0 (ref), v323 (ref)
        local v360 = entity.get_local_player();
        if not v9.misc.freeze_fakeduck:get() then
            return;
        elseif not l_core_0.freezetime then
            return;
        elseif v360 == nil or not v360:is_alive() then
            return;
        elseif not v323:get() then
            return;
        else
            local _ = v360.m_flDuckAmount;
            v359.in_bullrush = true;
            if v359.choked_commands < 7 then
                v359.in_duck = false;
            else
                v359.in_duck = true;
            end;
            v359.send_packet = not v359.choked_commands == 14;
            return;
        end;
    end;
    l_core_0.on_override_view = function(v362)
        -- upvalues: v9 (ref), l_core_0 (ref), v323 (ref), v324 (ref)
        local v363 = entity.get_local_player();
        if not v9.misc.freeze_fakeduck:get() then
            return;
        elseif not l_core_0.freezetime then
            return;
        elseif v363 == nil or not v363:is_alive() then
            return;
        elseif not v323:get() then
            return;
        else
            local _ = v363.m_flDuckAmount;
            local v365 = v363.m_vecAbsOrigin.z + v363.m_vecViewOffset.z;
            local v366 = v324(0.1, v363.m_vecAbsOrigin.z + v363.m_vecViewOffset.z);
            if bit.band(v363.m_fFlags, 1) == 1 and math.abs(v366 - v365) < 20 then
                v362.camera.z = v366;
            end;
            return;
        end;
    end;
    events.createmove(l_core_0.fake_duck);
    events.override_view(l_core_0.on_override_view);
    l_core_0.clantag = {
        step = 1, 
        speed = 2, 
        ref = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag"), 
        list = {
            [1] = "", 
            [2] = "l", 
            [3] = "lu", 
            [4] = "lua", 
            [5] = "luas", 
            [6] = "luase", 
            [7] = "luasen", 
            [8] = "luasens", 
            [9] = "luasense", 
            [10] = "luasense", 
            [11] = "luasens", 
            [12] = "luasen", 
            [13] = "luase", 
            [14] = "luas", 
            [15] = "lua", 
            [16] = "lu", 
            [17] = "l", 
            [18] = ""
        }, 
        run = function(v367)
            -- upvalues: v9 (ref)
            local function v369()
                -- upvalues: v367 (ref)
                local v368 = math.floor(globals.curtime * v367.speed + 0.5) % #v367.list + 1;
                if v368 == v367.step then
                    return;
                else
                    v367.step = v368;
                    v367.ref:override(false);
                    common.set_clan_tag(v367.list[v368]);
                    return;
                end;
            end;
            v9.misc.clantag:set_callback(function(v370)
                -- upvalues: v369 (ref)
                if v370:get() then
                    events.net_update_end:set(v369);
                else
                    events.net_update_end:unset(v369);
                    common.set_clan_tag("");
                end;
            end, true);
            events.shutdown:set(function()
                -- upvalues: v367 (ref)
                common.set_clan_tag("");
                v367.ref:override();
            end);
        end
    };
    local v371 = false;
    no_fall_damage = false;
    local v372 = math.pi * 2;
    local v373 = v372 / 8;
    local function v384(v374, v375)
        -- upvalues: v372 (ref), v373 (ref)
        local v376 = v374:get_origin();
        for v377 = 0, v372, v373 do
            local v378 = math.sin(v377);
            local v379 = math.cos(v377);
            local v380 = v376.x + v379 * 10;
            local v381 = v376.y + v378 * 10;
            local v382 = vector(v380, v381, v376.z);
            local v383 = v382:clone();
            v383.z = v383.z - v375;
            if utils.trace_line(v382, v383, v374).fraction ~= 1 then
                return true;
            end;
        end;
        return false;
    end;
    events.createmove_run:set(function()
        -- upvalues: v9 (ref), v371 (ref), v384 (ref)
        self = entity.get_local_player();
        if self == nil then
            return;
        elseif not v9.misc.no_fall:get() then
            return;
        elseif self.m_vecVelocity.z >= -500 then
            v371 = false;
            return;
        else
            if v384(self, 15) then
                v371 = false;
            elseif v384(self, 75) then
                v371 = true;
            end;
            self.in_duck = v371;
            return;
        end;
    end);
    v11.register("createmove", "unlock_spike", function()
        -- upvalues: v9 (ref), l_core_0 (ref)
        local l_sv_maxunlag_0 = cvar.sv_maxunlag;
        if v9.misc.fake_latency_toggle:get() then
            l_core_0.refs.fake_latency:override(v9.misc.fake_latency_toggle.fake_latency_slider:get());
            l_sv_maxunlag_0:float(0.4, true);
        else
            l_core_0.refs.fake_latency:override();
            l_sv_maxunlag_0:float(tonumber(l_sv_maxunlag_0:string()), true);
        end;
    end);
    v16.rotation = 0;
    v16.shadow_anim = 0;
    v16.handle = function()
        -- upvalues: v9 (ref), l_core_0 (ref), l_manager_0 (ref), v16 (ref)
        local v386 = v9.visuals.scope:get();
        if not v386 then
            return;
        else
            local v387 = entity.get_local_player();
            if v387 == nil then
                return;
            else
                local v388 = v387:get_player_weapon();
                if not v388 then
                    return;
                elseif v388 == nil then
                    return;
                else
                    l_core_0.refs.scope_type:override("Remove All");
                    local v389 = v9.visuals.scope.scope_settings:get(3);
                    local l_m_bIsScoped_0 = v387.m_bIsScoped;
                    local v391 = v386 and l_m_bIsScoped_0 and 1 or 0;
                    local v392 = v389 and l_manager_0:new("scope_overlay", v391) or v391;
                    if v392 < 0.1 then
                        return;
                    else
                        local v393 = v9.visuals.scope.scope_style:get();
                        local v394 = v9.visuals.scope.scope_settings:get(1);
                        local v395 = v9.visuals.scope.scope_size:get();
                        local v396 = v9.visuals.scope.scope_gap:get();
                        local v397 = v9.visuals.scope.scope_color1:get();
                        local v398 = v9.visuals.scope.scope_color2:get();
                        local v399 = v9.visuals.scope.scope_settings:get(2);
                        local v400 = v394 and l_manager_0:new("spread_dependensy", v388:get_inaccuracy() * 75) + v396 or v396;
                        local v401 = {
                            v397:override("a", v397.a * v392), 
                            v398:override("a", v398.a * v392)
                        };
                        v395 = v395 * v392;
                        local v402 = l_core_0.screen_size / 2;
                        v16.rotation = l_manager_0:new("scop_ratator", v393 == 3 and 45 or 90);
                        v16.shadow_anim = l_manager_0:new("scope_shadow_anim", v399 and 15 or 1);
                        if v16.rotation ~= 90 then
                            render.push_rotation(v16.rotation, l_core_0.screen_size / 2);
                        end;
                        if v16.shadow_anim ~= 1 then
                            render.shadow(v402 - vector(v395 + v400, -1), v402 - vector(v400, 0), v401[1], v16.shadow_anim);
                            render.shadow(v402 + vector(v400, 1), v402 + vector(v395 + v400, 0), v401[1], v16.shadow_anim);
                            render.shadow(v402 + vector(0, v400), v402 + vector(-1, v395 + v400), v401[1], v16.shadow_anim);
                        end;
                        render.gradient(v402 - vector(v395 + v400, -1), v402 - vector(v400, 0), v401[2], v401[1], v401[2], v401[1]);
                        render.gradient(v402 + vector(v395 + v400, 1), v402 + vector(v400, 0), v401[2], v401[1], v401[2], v401[1]);
                        if v393 ~= 2 then
                            if v16.shadow_anim ~= 1 then
                                render.shadow(v402 - vector(-1, v395 + v400), v402 - vector(0, v400), v401[1], v16.shadow_anim);
                            end;
                            render.gradient(v402 - vector(-1, v395 + v400), v402 - vector(0, v400), v401[2], v401[2], v401[1], v401[1]);
                        end;
                        render.gradient(v402 + vector(1, v395 + v400), v402 + vector(0, v400), v401[2], v401[2], v401[1], v401[1]);
                        if v16.rotation ~= 90 then
                            render.pop_rotation();
                        end;
                        return;
                    end;
                end;
            end;
        end;
    end;
    v11.register("render", "scope_overlay", v16.handle);
    v9.misc.viewmodel_changer_fov = v9.misc.view_model_changer:create():slider("Field Of View", 0, 100, 68);
    v9.misc.viewmodel_changer_x = v9.misc.view_model_changer:create():slider("X Axis", -3000, 3000, 205, 0.01);
    v9.misc.viewmodel_changer_y = v9.misc.view_model_changer:create():slider("Y Axis", -3000, 3000, 100, 0.01);
    v9.misc.viewmodel_changer_z = v9.misc.view_model_changer:create():slider("Z Axis", -3000, 3000, -100, 0.01);
    v13.cvars = {
        viewmodel_fov = cvar.viewmodel_fov, 
        viewmodel_offset_x = cvar.viewmodel_offset_x, 
        viewmodel_offset_y = cvar.viewmodel_offset_y, 
        viewmodel_offset_z = cvar.viewmodel_offset_z
    };
    v13.handle = function()
        -- upvalues: v9 (ref), v13 (ref)
        if v9.misc.view_model_changer:get() then
            v13.cvars.viewmodel_fov:float(v9.misc.viewmodel_changer_fov:get(), true);
            v13.cvars.viewmodel_offset_x:float(v9.misc.viewmodel_changer_x:get() / 100, true);
            v13.cvars.viewmodel_offset_y:float(v9.misc.viewmodel_changer_y:get() / 100, true);
            v13.cvars.viewmodel_offset_z:float(v9.misc.viewmodel_changer_z:get() / 100, true);
        else
            v13.cvars.viewmodel_fov:float(68);
            v13.cvars.viewmodel_offset_x:float(2.5);
            v13.cvars.viewmodel_offset_y:float(0);
            v13.cvars.viewmodel_offset_z:float(-1.5);
        end;
    end;
    v13.destroy = function()
        -- upvalues: v13 (ref)
        v13.cvars.viewmodel_fov:float(68);
        v13.cvars.viewmodel_offset_x:float(2.5);
        v13.cvars.viewmodel_offset_y:float(0);
        v13.cvars.viewmodel_offset_z:float(-1.5);
    end;
    v11.register("render", "viewmodel", v13.handle);
    v11.register("shutdown", "viewmodel", v13.destroy);
    v9.misc.aspect_ratio_val = v9.misc.aspect_ratio:create():slider("Aspect Value", 50, 300, 0, 0.01);
    local v403 = {
        cvar = cvar.r_aspectratio
    };
    v403.cvar_float_raw = v403.cvar.float;
    l_core_0.handle_aspect = function(_)
        -- upvalues: l_manager_0 (ref), v9 (ref), v403 (ref)
        local v405 = l_manager_0:new("aspect_ratio", v9.misc.aspect_ratio_val:get() / 100, 0.1);
        if v9.misc.aspect_ratio_val:get() == 50 then
            v405 = 0;
        end;
        if not v9.misc.aspect_ratio:get() then
            v405 = 0;
        end;
        if v405 ~= v403.cvar_float_raw(v403.cvar) then
            v403.cvar_float_raw(v403.cvar, v405);
        end;
    end;
    aspect_ratio_destroy = function()
        -- upvalues: v403 (ref)
        aspect_ratio.cvar_float_raw(v403.cvar, 0);
    end;
    aspect_ratio_ratios = {
        [161] = "16:10", 
        [177] = "16:9", 
        [125] = "5:4", 
        [150] = "3:2", 
        [133] = "4:3"
    };
    local v406 = 0;
    for v407, v408 in pairs(aspect_ratio_ratios) do
        v406 = v406 + 1;
        do
            local l_v407_0 = v407;
            local _ = v9.misc.aspect_ratio:create():button(v408, function()
                -- upvalues: v9 (ref), l_v407_0 (ref)
                v9.misc.aspect_ratio_val:set(l_v407_0);
            end);
        end;
    end;
    v10.animlayer_offset = 10640;
    v10.animlayer_t = ffi.typeof("    struct {\n        char pad_0x0000[0x18];\n        uint32_t seq;\n        float prev_cycle;\n        float weight;\n        float weight_delta_rate;\n        float playback_rate;\n        float cycle;\n        void *entity;\n        char pad_0x0038[0x4];\n    }**\n");
    v10.get_anim_layer = function(v411)
        -- upvalues: v10 (ref)
        local v412 = ffi.cast("void***", v411[0]);
        if v412 == ffi.NULL then
            return nil;
        else
            return ffi.cast(v10.animlayer_t, ffi.cast("char*", v412) + v10.animlayer_offset)[0];
        end;
    end;
    v10.handle = function(v413)
        -- upvalues: v9 (ref), v10 (ref)
        if not v9.rage.anims:get() then
            return;
        else
            local v414 = entity.get_local_player();
            if not v414 or v413 ~= v414 then
                return;
            else
                local v415 = v9.rage.anims.move_lean_val:get() * 0.1;
                if v415 ~= -1 then
                    local v416 = v10.get_anim_layer(v414);
                    if v416 then
                        v416[12].weight = v415;
                    end;
                end;
                local v417 = v9.rage.anims.move_fall:get() * 0.1;
                if v417 ~= -1 then
                    v414.m_flPoseParameter[6] = v417;
                end;
                return;
            end;
        end;
    end;
    v10.handle_pre_render = function()
        -- upvalues: v9 (ref)
        if not v9.rage.anims:get() then
            return;
        else
            local v418 = entity.get_local_player();
            if not v418 then
                return;
            else
                local v419 = v9.rage.anims.move_jitter_mode:get();
                local v420 = v9.rage.anims.move_jitter:get();
                local _ = globals.tickcount;
                if v419 == 1 then
                    if v420 > 1 then
                        v418.m_flPoseParameter[0] = globals.tickcount % 4 >= 2 and 86 or 50 / (globals.tickcount % 8 >= 4 and 200 or 400);
                    end;
                else
                    local v422 = globals.tickcount % 8;
                    local v423 = globals.tickcount % 4;
                    local v424 = 1 / (v422 >= 4 and 200 or 400);
                    local v425 = v423 >= 2 and v9.rage.anims.move_legs1:get() or v9.rage.anims.move_legs2:get();
                    v418.m_flPoseParameter[0] = v425 * v424;
                end;
                return;
            end;
        end;
    end;
    v10.handle_legs = function(_)
        -- upvalues: v9 (ref), l_core_0 (ref)
        if not v9.rage.anims:get() then
            l_core_0.refs.legs:override();
            return;
        else
            local v427 = v9.rage.anims.move_jitter_mode:get();
            local v428 = v9.rage.anims.move_jitter:get();
            local l_commandack_0 = globals.commandack;
            if v428 > 5 and v427 == 1 then
                l_core_0.refs.legs:override(l_commandack_0 % 3 == 0 and "Default" or "Sliding");
            elseif v9.rage.anims.move_legs1:get() > 1 or v9.rage.anims.move_legs2:get() > 1 then
                l_core_0.refs.legs:override("Sliding");
            else
                l_core_0.refs.legs:override();
            end;
            return;
        end;
    end;
    v11.register("post_update_clientside_animation", "animbreaker.handle", v10.handle);
    v11.register("createmove", "animbreaker.handle_legs", v10.handle_legs);
    v11.register("post_update_clientside_animation", "animbreaker.handle_pre_render", v10.handle_pre_render);
    gs_settings = v9.visuals.gs_inds:create();
    local v430 = {};
    local v431 = {};
    local v432 = render.screen_size();
    local v433 = {
        planting = false, 
        planting_site = "", 
        fill = 0, 
        on_plant_time = 0
    };
    local v434 = {
        ping = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"), 
        da = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
        dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
        body = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
        safe = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"), 
        hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
        fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
        fs = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")
    };
    local v435 = gs_settings:listable("", {
        [1] = "Double Tap", 
        [2] = "Hide Shots", 
        [3] = "Damage", 
        [4] = "Hitchance", 
        [5] = "Fake Duck", 
        [6] = "Body Aim", 
        [7] = "Safe Points", 
        [8] = "Dormant Aimbot", 
        [9] = "Freestanding", 
        [10] = "PING", 
        [11] = "Bomb Info"
    });
    local v436 = gs_settings:switch("Enable Spectator List", false);
    v430.font = render.load_font("Calibri Bold", vector(25, 23.5, 0), "da");
    local v437 = render.load_image("\137PNG\r\n\026\n\000\000\000\rIHDR\000\000\000d\000\000\000\\\b\003\000\000\000\175\021\224\166\000\000\000\001sRGB\001\217\201,\127\000\000\000\tpHYs\000\000\v\019\000\000\v\019\001\000\154\156\024\000\000\002\223PLTE\000\000\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255v\153it\000\000\000\245tRNS\000\001C\147X\006Z\251\255\253\150\004\213\249\002\014\227\024\022\234+\027\2396)sr\030\242?uk \235\2442!\246G/\231\2267^\183\015#\248Q\b\179\154}\247c\000pz\193%n-\224b\252\194(v\174\136\v\201]~\250\233'\\\223\0181\132\216\140\207\151:\138\003\172\218\028l.B\143{\161K\149\016\202\019U=\0263\nNi\130\187A\199\128\135\145\158\166\170\134\127_&\220\254I\232\023\195F\137\146\186,\192\184\163\159\168\175\177\181\188\212|\243\157$\r\142[\005\217\209\153\241\204\203\155O\020\206\197\205\0250\245\a\222\021\164\029\017\229\131*\160q\214\208\198\185\169mR5\221\f\228d\237\191\196\141w\133\139\144\238\230\165x\236\t`\031\129\171\156\1528aJ\1784L\219\167\210E9S\176\240\189\148M\180DT>\162\"Yj\225\215\173@H;\190et4r\001\212\000\000\anIDATx\156\237\154\249[\212F\024\199\179\"2+\139\138X\208B\229\016T(B\017p\017\017\016\149\"(V,\136\020\005\228\180\028\197 `E\188Q\001\161\136\136\162\162xq\021\021\v\136x\v\021T\020\207\nx\182\181\213Z\219\218\235\015hf&\187\155\132\221%\134\165\207\211>\190\191d\231\155\247}?9f\146w&K\016\002L4@k\160\182\144\1927\177A:@<\184\159\025\186\018\000\128\222\144\254\133\f\029FA\128~\255B\134\027@\200\136\254\133\188c\b!F\154K8r\212\187=\014\217\216\004B\222\227\168\162\145\163M\205\0041\244\205\001\176\024\195\017-\173 d,G\0297\030\000k\027!\144\247a:\219\tl\209\206\030\170\031\176E\135\137Pt\020\002\177\019\195P'\142\232\f\197I,M\234\162\003\197\201B \132+\f\021\179o\203\020=(\186\177\180\169\227\161\230n&\b\226\225\t\131\167905/\164MgJ\1863\160\004f\nb\016\222\031\162h\031\1666\002I\179\024\138\212\195\023J~\179\133A\1369(\163\255\\\134\244\017\146\2301\020\203\000$\205\023\252\168\249\024\197\a2\226\131\144\178@!\004/DJ\200'B\025D(\186\003\022\139\020\202b\1482L!\140E\002\b\023\204\144\221\149\b\133\178\004\t\145\242v\020\246\136\142\017\014!\198\196B\139S\bK\145\240\169\188\029\159\144\232\150\228\248Yr\031\024o\237\127cR\227P\219e\131D\178f\130\169\155\019I\146)\203#\177\005\166\166\165\243\180\136@\024\160\181\226s\151\149\025l\134\254tw\170W\219{\225\150\003i\0154a\171\024}|\200\148\249\1712\145\186\026\vnb\1410\168'\181\183\140a\182`\r\173\025\172\197\202:\r1\128\243z\156\208{\131\191L\178ZBc\253\213\005\190\145\133\162|\027\205\229B\214&\217\185\025\240\203\016\176yKv\142\194\"\178\211r\211\023n\205\155\152\191%\235\139\002\236\178\r\229\147Gx\146Q\242\155T\200\aa\161\246m\020\139\157R\152\016\207\237E\f\015^}\203z\a\015H1\003\226\183s\023\211\131W\231*\217\1654;\027\162%\135\024jq\ne>\f \017)\201\205\133\004\162\006\245\138\2032\210\229x\240\130\236V\199\144A\246\160\198\222\210\213\\\004O\200>>\144\253\168Qv@\137\a/\200A>\144\237\170=xA\014\241\129\164\246\017\018\r=c\226\014\031\017\137\202+f\014%*\195K\141\2275\r)\128\158\185\133:U\213\195\253\128\213rbR\166x\141bBACr\250\b\145H)\207/\0010\1699z\f\150u\199\169\159\181\\\200\137\190B\2248\177\252*+\214Adc\016\184\150\152\189\160\196g\130\166!uj\139\\\rA\002\130\255\005H\136\218E\014\026\130\v\217\241\195\170J\n\234\2475\184\158\156\145\222\184g\222\169\166\211KE\252 g\028x@\178U\028\180\161\027?\136\251Y\030\1444UWf\149J\1369\170y\246\226\198\185(\030\144tU\016\019U\144\204\243(D\130[\023\212.\164\244\006\137V\005\1858\129\t\017_\202kn\025\205\176\150\201\219f\145I_\167l\184\220\220\186\209\150\003\017[\180]q/\145H\014\187\230_m\189f\218\020\163\002\210nD\\/R@xY#\130\028\245V\210\221\149\a\180JE\2257\004A\148\154\204\197j\243\172\184\142\202\168Q\168QeF\148_\024\203\128\024\238'o\230\154P\221\172\153$\179\157\169n\1775)\233\150\0145J\195H\242\182/_H\189\017~\141\215\192\134\175\135\148\184\003\2382 \247\224>\018\1282\184\r\003zA\212F\186\005\180u\192\246I\236\147\219\027\164t(nI\191\129\173\251\193Dg;X\196\128\160\197\173.\000:\241\214\031\213\189\129\160\027=\t\"\177\207\131^ z\176\160\220q\249\161D\210N\181*:\b\221\019xiN\006\129gE<\002\000M>\031\211\213\203m\176\170\018n\181\248A\242\168\031\218\247\233\132\153\205T\030g6\228\017tm\002\224\t\220.\161\235\176[t\209\151\141}\210z\129\192K~O\214\005\252k\b\"\021\176!\167j)s\002 \220L\191\186\166\017T\148\r\175^Zt\b\152\aA\157\158\024\\\237\005r\154\186\027\r2\200dj\134\225*\145H\236\168\189y\018\019\021\029\182\167\225\a\228\001eo\005\180\127\0285;\170\163}\205\217\207\169\193\188!\248Q\223\176\220X\005\004\206_\002i\223\167\236\2537\145\168S%\t\248\150\218zvKJ,\160` \169k\1636\206%\146\238\n:\016\215]V\160\221\173Gy\142\246\195\005\178\140v\236\219\016K\027\236\213F\177\223!\1779FZi3\r\000\199\179\196\245\228n\000\190\175\021\233\006\237\005\190\231\227\137\029\207\218p ^\127\132\135\240\195]e\144h\216%\203\031Z\177N\031\222\248\131\244o8\248\136\213\000\160:(\020\248\161Zt\006\176F\195+\021\251\224\021\029<\169\n\235\232\t\017\255\b\127\206\029\240<6\150\005\145\202z\215c\184?\025\128\169p\251\002\004\160\154z?=N\232\219\134\215\166\134\225FHS0\023\002\206X\210M\017\251Ld\144\197p_\023=^d\1311\130\030\249?a\159\021(A\183,<\253\165\148\003\001u\003\241\027\214L9\164\v\238\243\001\224g\184}\005\174\160\213\194<p\f\245Dz\020\135\163\004\151\229\243\195\170\004.\004\000\251\137\197$\025\246\vPj\005\023)+\001\224\215\173\2179\233\212\173\v\137\200y\144o\b|/A\221\016\251\188\194\t-\159\202\186\027(\158\203\133\244\213<\159\208\025w%\148f\210Z>=\r\180\214\020d\141\151\252\234T'\214\209SQzy\239t\183\250X\222\214\200,e\143\\\195\a/\251@0\213\189O\185\197\021\021\021\133\006~U\191\217\177F\006a\214\178\207\1760W>k\030\017\219\023kJ~\253\250\197\166\145Jf\138\218\157q\241=\213\183\246_1o\023\146$\157|\024\139\253/Ih\191+\132?\160\v9]mU\174\222\018\209w$\2413\133\242\002\245\221\249\n\2259\238\205\166\194!\165(\193no\133b\131\148\020\133\160\189\f)\209jg1\234l\016\138\247e~\186,GR\018C\233D\175*O7n0O\187\142\015\210\145\185\022\213\243s\211\144\227H\170W\182x\195\195n\160;r\193\146\169y\161\167_\vS\138\169G\020\015a\144?Q\240$)S\203@e\188\v\203\2399\002\175\019\244W\128\181\232Dl\217k\005Eh\2212\145\165iG@\205\190K\bd%\f=W\203\022\241\183_\206\165\233@\175\140@!\1442\0249\135#v\160\242n'G\253\139\186`:\161B \186\145V\134N\220\133\149\0264\241\230|`&\028\254\014(\189\167\185\191g\028A%\227z\141\229Sj\213~\016\162\193\127\022(3\252G\f\203\222\029\251b\186p\150\225\171v\209[\003VLA\166\2453\131\136iM\191\147\209\187\155\220\254\001Q\1440+D^\186l\000\000\000\000IEND\174B`\130", vector(30, 25));
    local function v445(v438, v439, v440, v441, v442, v443, v444)
        return (v441 - v438) * v444 + v438, (v442 - v439) * v444 + v439, (v443 - v440) * v444 + v440;
    end;
    local function v452(v446)
        local _ = 0;
        local _ = 0;
        local v449 = 0;
        local v450 = 0;
        local v451 = {
            [1] = utils.net_channel(), 
            [2] = utils.net_channel()
        };
        if v446 ~= nil and v446:is_alive() then
            v451[1] = utils.net_channel();
            v451[2] = v451[1];
            if v451[1] then
                v449 = v451[1].sequence_nr[0];
                v450 = (v451[2].sequence_nr[1] + v449) / math.min(math.max(0.1, 0.001), 0.2);
                return math.clamp(-1.7014636E38, math.min(math.max(v450, 0), 1), v450);
            end;
        end;
    end;
    v430.indicator = function(v453, v454, v455, v456, v457, v458)
        -- upvalues: v430 (ref)
        local v459 = render.screen_size().x / 100 + 2;
        local v460 = render.screen_size().y / 1.47;
        local v461 = render.measure_text(v430.font, bad, v453);
        v454 = v454 + 1;
        if v458 then
            render.gradient(vector(v459 - 17, v460 + v454), vector(v459 + (v461.x + v458.width + 8) / 2, v460 + v454 + v461.y + 8), color(0, 0, 0, 0), color(0, 0, 0, 55), color(0, 0, 0, 0), color(0, 0, 0, 55));
            render.gradient(vector(v459 + (v461.x + v458.width + 6) / 2, v460 + v454), vector(v459 + v461.x + v458.width + 17 + 8, v460 + v454 + v461.y + 8), color(0, 0, 0, 55), color(0, 0, 0, 0), color(0, 0, 0, 55), color(0, 0, 0, 0));
            render.texture(v458, vector(v459 + 1, v460 + v454 + 3), color(0, 0, 0, 200));
            render.texture(v458, vector(v459, v460 + v454 + 2), v455);
            render.text(v430.font, vector(v459 + v458.width + 8, v460 + 5 + v454), v455, "bad", v453);
        else
            render.gradient(vector(v459 - 17, v460 + v454), vector(v459 + v461.x / 2, v460 + v454 + v461.y + 8), color(0, 0, 0, 0), color(0, 0, 0, 55), color(0, 0, 0, 0), color(0, 0, 0, 55));
            render.gradient(vector(v459 + v461.x / 2, v460 + v454), vector(v459 + v461.x + 17, v460 + v454 + v461.y + 8), color(0, 0, 0, 55), color(0, 0, 0, 0), color(0, 0, 0, 55), color(0, 0, 0, 0));
            render.text(v430.font, vector(v459, v460 + 5 + v454), v455, "bad", v453);
        end;
        if v456 and v457 then
            if v458 then
                local v462 = v460 + v454 + v461.y * 0.6;
                render.circle_outline(vector(v459 + v461.x + v458.width + 18, v462), color(0, 0, 0, 255), 9.5, 90, 1, 4);
                render.circle_outline(vector(v459 + v461.x + v458.width + 18, v462), v456, 9, 90, v457, 3);
            else
                render.circle_outline(vector(v459 + v461.x + 18, v460 + v454 + v461.y / 2 + 2), color(0, 0, 0, 255), 10.5, 90, 1, 4);
                render.circle_outline(vector(v459 + v461.x + 18, v460 + v454 + v461.y / 2 + 2), v456, 10, 90, v457, 3);
            end;
        end;
    end;
    v430.get_bind_state = function(v463)
        local v464 = false;
        local v465 = 0;
        local v466 = ui.get_binds();
        for v467 = 1, #v466 do
            if v466[v467].name == v463 and v466[v467].active then
                v464 = true;
                v465 = v466[v467].value;
            end;
        end;
        return {
            [1] = v464, 
            [2] = v465
        };
    end;
    v430.spectators_get = function()
        local v468 = {};
        local v469 = entity.get_local_player();
        local v470 = nil;
        if v469 ~= nil then
            if v469.m_hObserverTarget then
                v470 = v469.m_hObserverTarget;
            else
                v470 = v469;
            end;
            local v471 = entity.get_players(false, false);
            if v471 ~= nil then
                for _, v473 in pairs(v471) do
                    local l_m_hObserverTarget_0 = v473.m_hObserverTarget;
                    if l_m_hObserverTarget_0 and l_m_hObserverTarget_0 == v470 then
                        table.insert(v468, v473);
                    end;
                end;
            end;
        end;
        return v468;
    end;
    v430.handle = function()
        -- upvalues: v9 (ref), v432 (ref), v433 (ref), v434 (ref), v445 (ref), v452 (ref), v435 (ref), v437 (ref), v430 (ref)
        if not v9.visuals.gs_inds:get() then
            return;
        else
            local v475 = entity.get_local_player();
            if v475 == nil or v475:is_alive() == false then
                return;
            else
                local v476 = entity.get_entities("CPlantedC4", true)[1];
                local v477 = "";
                local v478 = 0;
                local v479 = false;
                local v480 = 0;
                local v481 = 0;
                local v482 = false;
                if v476 ~= nil then
                    v478 = v476.m_flC4Blow - globals.curtime;
                    v479 = v476.m_bBombDefused;
                    if v478 > 0 and not v479 then
                        local v483 = v476.m_hBombDefuser ~= 4294967295;
                        local l_m_flDefuseLength_0 = v476.m_flDefuseLength;
                        local v485 = v483 and v476.m_flDefuseCountDown - globals.curtime or -1;
                        if v485 > 0 then
                            local v486 = v485 < v478 and color(58, 191, 54, 160) or color(252, 18, 19, 125);
                            local v487 = (v432.y - 50) / l_m_flDefuseLength_0 * v485;
                            render.rect(vector(0, 0), vector(16, v432.y), color(25, 25, 25, 160));
                            render.rect_outline(vector(0, 0), vector(16, v432.y), color(25, 25, 25, 160));
                            render.rect(vector(0, v432.y - v487), vector(16, v432.y), v486);
                        end;
                        v477 = v476.m_nBombSite == 0 and "A" or "B";
                        local l_m_iHealth_0 = v475.m_iHealth;
                        local l_m_ArmorValue_0 = v475.m_ArmorValue;
                        local v490 = v476.m_vecOrigin:dist(v475.m_vecOrigin);
                        local v491 = 450.7;
                        local v492 = (v490 - 75.68) / 789.2;
                        v480 = v491 * math.exp(-v492 * v492);
                        if l_m_ArmorValue_0 > 0 then
                            local v493 = v480 * 0.5;
                            local v494 = (v480 - v493) * 0.5;
                            if l_m_ArmorValue_0 < v494 then
                                l_m_ArmorValue_0 = l_m_ArmorValue_0 * 2;
                                v493 = v480 - v494;
                            end;
                            v480 = v493;
                        end;
                        v481 = math.ceil(v480);
                        v482 = l_m_iHealth_0 <= v481;
                    end;
                end;
                if v433.planting then
                    v433.fill = 3.125 - (3.125 + v433.on_plant_time - globals.curtime);
                    if v433.fill > 3.125 then
                        v433.fill = 3.125;
                    end;
                end;
                local v495 = 44;
                local v496 = 0;
                local l_m_iPing_0 = v475:get_resource().m_iPing;
                local v498 = v9.misc.fake_latency_toggle.fake_latency_slider:get();
                local v499 = v434.ping:get();
                local v500 = math.max(v499, v498) / 2;
                local _ = math.min(1, l_m_iPing_0 / v500);
                local _ = {
                    [1] = 255, 
                    [2] = 0, 
                    [3] = 0
                };
                local _ = {
                    [1] = 150, 
                    [2] = 189, 
                    [3] = 18
                };
                local v504, v505, v506 = color(255, 255, 255):to_hsv();
                local v507, v508, v509 = color(151, 175, 54):to_hsv();
                local v510 = color();
                local v511, v512, v513 = v445(v504, v505, v506, v507, v508, v509, v452(v475));
                v510:as_hsv(v511, v512, v513, 255);
                v511 = {
                    [1] = {
                        [1] = "PING", 
                        [2] = v435:get("PING") and (not (v434.ping:get() <= 0) or v498 > 0) and v475:is_alive(), 
                        [3] = v510
                    }, 
                    [2] = {
                        [1] = "DT", 
                        [2] = v435:get("Double Tap") and not v434.hs:get() and v434.dt:get(), 
                        [3] = rage.exploit:get() == 1 and color(255, 200) or color(255, 0, 53, 255)
                    }, 
                    [3] = {
                        "OSAA", 
                        v435:get("Hide Shots") and v434.hs:get(), 
                        color(200, 255)
                    }, 
                    [4] = {
                        "DA", 
                        v435:get("Dormant Aimbot") and v434.da:get(), 
                        color(255, 200)
                    }, 
                    [5] = {
                        "DUCK", 
                        v435:get("Fake Duck") and v434.fd:get(), 
                        color(255, 200)
                    }, 
                    [6] = {
                        "BODY", 
                        v435:get("Body Aim") and v434.body:get() == "Force", 
                        color(255, 200)
                    }, 
                    [7] = {
                        "SAFE", 
                        v435:get("Safe Points") and v434.safe:get() == "Force", 
                        color(255, 200)
                    }, 
                    [8] = {
                        [1] = v477 .. " - " .. string.format("%.1f", v478) .. "s", 
                        [2] = v435:get("Bomb Info") and v478 > 0 and not v479, 
                        [3] = color(255, 200), 
                        [6] = v437
                    }, 
                    [9] = {
                        [1] = "FATAL", 
                        [2] = v435:get("Bomb Info") and v475:is_alive() and v482, 
                        [3] = color(255, 0, 0, 255)
                    }, 
                    [10] = {
                        [1] = "-" .. v481 .. " HP", 
                        [2] = v435:get("Bomb Info") and v475:is_alive() and not v482 and v480 > 0.5, 
                        [3] = color(210, 216, 112, 255)
                    }, 
                    [11] = {
                        [1] = v433.planting_site .. " ", 
                        [2] = v435:get("Bomb Info") and v433.planting, 
                        [3] = color(210, 216, 112, 255), 
                        [4] = color(255, 255), 
                        [5] = v433.fill / 3.3, 
                        [6] = v437
                    }, 
                    [12] = {
                        "FS", 
                        v435:get("Freestanding") and (v434.fs:get() or v9.rage.freestanding_bind:get()), 
                        color(255, 200)
                    }, 
                    [13] = {
                        "H1TCHANCE", 
                        v435:get("Hitchance") and v430.get_bind_state("Hit Chance")[1], 
                        color(255, 255)
                    }, 
                    [14] = {
                        "MD", 
                        v435:get("Damage") and v430.get_bind_state("Min. Damage")[1], 
                        color(255, 200)
                    }
                };
                for _, v515 in pairs(v511) do
                    if v515[2] then
                        v430.indicator(v515[1], v496, v515[3], v515[4], v515[5], v515[6]);
                        v496 = v496 - v495;
                    end;
                end;
                return;
            end;
        end;
    end;
    v430.spectators = function()
        -- upvalues: v436 (ref), v9 (ref), v430 (ref), v432 (ref)
        if not v436:get() or not v9.visuals.gs_inds:get() then
            return;
        else
            local v516 = 5;
            local v517 = v430.spectators_get();
            for _, v519 in pairs(v517) do
                local v520 = v519:get_name();
                local l_x_0 = render.measure_text(1, nil, v520).x;
                render.text(1, vector(v432.x - l_x_0 - 2, 2 + v516), color(255), nil, v520);
                v516 = v516 + 17;
            end;
            return;
        end;
    end;
    v431.reset_bomb = function()
        -- upvalues: v433 (ref)
        v433.planting = false;
        v433.fill = 0;
        v433.on_plant_time = 0;
        v433.planting_site = "";
    end;
    v431.bomb_beginplant = function(v522)
        -- upvalues: v433 (ref)
        local v523 = entity.get_player_resource();
        if v523 == nil then
            return;
        else
            v433.on_plant_time = globals.curtime;
            v433.planting = true;
            local l_m_bombsiteCenterA_0 = v523.m_bombsiteCenterA;
            local l_m_bombsiteCenterB_0 = v523.m_bombsiteCenterB;
            local v526 = entity.get(v522.userid, true):get_origin();
            v433.planting_site = v526:dist(l_m_bombsiteCenterA_0) < v526:dist(l_m_bombsiteCenterB_0) and "A" or "B";
            return;
        end;
    end;
    v9.visuals.molotov_radius.molotov_color = v9.visuals.molotov_radius:create():color_picker("Circle Color", color(255, 183, 183));
    v9.visuals.smokes_radius.smoks_color = v9.visuals.smokes_radius:create():color_picker("Circle Color", color(197, 199, 255));
    local v527 = nil;
    v527 = {};
    local v528 = 17.55;
    local v529 = 125;
    v527.distance_2d = function(v530, v531)
        return math.sqrt((v531.x - v530.x) ^ 2 + (v531.y - v530.y) ^ 2);
    end;
    v527.lerp_position = function(v532, v533, v534)
        return vector((v533.x - v532.x) * v534 + v532.x, (v533.y - v532.y) * v534 + v532.y, (v533.z - v532.z) * v534 + v532.z);
    end;
    do
        local l_v528_0, l_v529_0 = v528, v529;
        v527.draw = function()
            -- upvalues: v9 (ref), v527 (ref), l_v528_0 (ref), l_v529_0 (ref)
            if not entity.get_local_player() then
                return;
            else
                if v9.visuals.molotov_radius:get() then
                    local v537 = entity.get_entities("CInferno");
                    for v538 = 1, #v537 do
                        local v539 = v537[v538];
                        local v540 = v539:get_origin();
                        local v541 = 40;
                        local v542 = {};
                        local v543 = 0;
                        local v544 = nil;
                        local v545 = nil;
                        for v546 = 1, 64 do
                            if v539.m_bFireIsBurning[v546] == true then
                                table.insert(v542, vector(v539.m_fireXDelta[v546], v539.m_fireYDelta[v546], v539.m_fireZDelta[v546]));
                            end;
                        end;
                        for v547 = 1, #v542 do
                            for v548 = 1, #v542 do
                                local v549 = v527.distance_2d(v542[v547], v542[v548]);
                                if v543 < v549 then
                                    v543 = v549;
                                    v544 = v542[v547];
                                    v545 = v542[v548];
                                end;
                            end;
                        end;
                        if v544 and v545 then
                            local v550 = v540 + v527.lerp_position(v544, v545, 0.5);
                            local v551 = v9.visuals.molotov_radius.molotov_color:get();
                            render.circle_3d_outline(v550, color(v551.r, v551.g, v551.b, 255), v543 / 2 + v541, 0, 1);
                        end;
                    end;
                end;
                if v9.visuals.smokes_radius:get() then
                    local l_tickcount_1 = globals.tickcount;
                    local l_tickinterval_0 = globals.tickinterval;
                    local v554 = entity.get_entities("CSmokeGrenadeProjectile");
                    for v555 = 1, #v554 do
                        local v556 = v554[v555];
                        if v556:get_classname() == "CSmokeGrenadeProjectile" and v556.m_bDidSmokeEffect == true then
                            local l_m_nSmokeEffectTickBegin_0 = v556.m_nSmokeEffectTickBegin;
                            if l_m_nSmokeEffectTickBegin_0 ~= nil then
                                local v558 = l_tickinterval_0 * (l_tickcount_1 - l_m_nSmokeEffectTickBegin_0);
                                if v558 > 0 and l_v528_0 - v558 > 0 then
                                    local v559 = 1;
                                    if grenade_timer then
                                        v559 = 1 - v558 / l_v528_0;
                                    end;
                                    local v560 = v9.visuals.smokes_radius.smoks_color:get();
                                    local l_r_0 = v560.r;
                                    local l_g_0 = v560.g;
                                    local l_b_0 = v560.b;
                                    local l_a_0 = v560.a;
                                    local l_l_v529_0_0 = l_v529_0;
                                    if v558 < 0.3 then
                                        l_l_v529_0_0 = l_l_v529_0_0 * 0.6 + l_l_v529_0_0 * (v558 / 0.3) * 0.4;
                                        l_a_0 = l_a_0 * (v558 / 0.3);
                                    end;
                                    if l_v528_0 - v558 < 1 then
                                        l_l_v529_0_0 = l_l_v529_0_0 * ((l_v528_0 - v558) / 1 * 0.3 + 0.7);
                                    end;
                                    render.circle_3d_outline(v556:get_origin(), color(l_r_0, l_g_0, l_b_0, l_a_0 * math.min(1, v559 * 1.3)), l_l_v529_0_0, 0, 1);
                                end;
                            end;
                        end;
                    end;
                end;
                return;
            end;
        end;
    end;
    v528 = {
        lag_timer = 0, 
        ground_timer = 0, 
        in_air = function(v566, v567)
            if not v567 then
                return false;
            else
                local l_m_fFlags_0 = v567.m_fFlags;
                if bit.band(l_m_fFlags_0, 1) ~= 0 then
                    if v566.ground_timer == 5 then
                        return false;
                    else
                        v566.ground_timer = v566.ground_timer + 1;
                    end;
                else
                    v566.ground_timer = 0;
                end;
                return true;
            end;
        end, 
        is_moving = function(_, v570)
            local l_m_vecVelocity_0 = v570.m_vecVelocity;
            return math.sqrt(l_m_vecVelocity_0.x * l_m_vecVelocity_0.x + l_m_vecVelocity_0.y * l_m_vecVelocity_0.y) > 2;
        end, 
        is_crouching = function(_, v573)
            return v573.m_bDucked;
        end, 
        team_num = function(_, v575)
            return v575.m_iTeamNum;
        end, 
        get_state = function(v576, v577)
            -- upvalues: v9 (ref), l_core_0 (ref)
            local v578 = v576:is_moving(v577);
            local v579 = v576:is_crouching(v577);
            local v580 = v576:in_air(v577);
            if v9.rage.manual:get() ~= "At Target" then
                return "Manual";
            elseif v580 then
                return v579 and "Air Crouch" or "Air";
            elseif l_core_0.refs.slow:get() then
                return "Slowmotion";
            elseif v579 then
                return v578 and "Crouch Moving" or "Crouch";
            else
                return v578 and "Running" or "Standing";
            end;
        end
    };
    v529 = {
        manual_last_pressed = globals.realtime
    };
    local _ = function(v581, v582, _, v584, v585, _)
        return math.sqrt((v581 - v584) * (v581 - v584) + (v582 - v585) * (v582 - v585));
    end;
    local function _(v588, v589, v590, v591, v592)
        local l_m_vecVelocity_1 = v588.m_vecVelocity;
        return v590 + globals.tickinterval * l_m_vecVelocity_1.x * v589, v591 + globals.tickinterval * l_m_vecVelocity_1.y * v589, v592 + globals.tickinterval * l_m_vecVelocity_1.z * v589;
    end;
    reset_current_state = function()
        -- upvalues: v9 (ref), v12 (ref)
        local v595 = v9.rage.team_list:get();
        local v596 = v595 == "T" and "" or "_ct";
        local v597 = v9.rage.aa_lister:get();
        local v598 = {
            [1] = "yaw_mode", 
            [2] = "yaw_left", 
            [3] = "yaw_right", 
            [4] = "Jitter", 
            [5] = "yaw_jitter_ovr", 
            [6] = "body_yaw", 
            [7] = "fake_left", 
            [8] = "fake_right", 
            [9] = "fake_options", 
            [10] = "body_speed"
        };
        local v599 = {
            body_yaw = true, 
            yaw_jitter_ovr = 0, 
            fake_options = "Jitter", 
            fake_right = 60, 
            fake_left = 60, 
            yaw_right = 0, 
            yaw_left = 0, 
            Jitter = "Disabled", 
            yaw_mode = "L - R", 
            body_speed = 2
        };
        local v600 = v9.rage.state_list:get();
        local v601 = nil;
        if v597 == 2 then
            v601 = v9.rage.builder_elements[v600];
        elseif v597 == 3 then
            v601 = v9.rage.defensive_elements[v600];
        else
            v12.push("Error: Please select Anti-Aim or Defensive tab");
            return;
        end;
        if not v601 then
            v12.push("Error: No settings found for the selected state");
            return;
        else
            for _, v603 in ipairs(v598) do
                local v604 = v601[v603 .. v596];
                if v604 and v604.set and v599[v603] then
                    v604:set(v599[v603]);
                end;
            end;
            local v605 = v597 == 2 and "Anti-Aim" or "Defensive";
            v12.push(v605 .. " settings reset to default values for " .. (v595 == "T" and "T-side" or "CT-side"));
            return;
        end;
    end;
    send_to_opposite_team = function()
        -- upvalues: v9 (ref), v12 (ref)
        local v606 = v9.rage.state_list:get();
        local v607 = v9.rage.team_list:get();
        local v608 = v9.rage.aa_lister:get();
        local v609 = v607 == "T";
        local v610 = v607 == "CT";
        if not v606 then
            v12.push("Error: No state selected.");
            return;
        else
            local v611 = nil;
            if v608 == 2 then
                v611 = v9.rage.builder_elements[v606];
            elseif v608 == 3 then
                v611 = v9.rage.defensive_elements[v606];
            else
                v12.push("Error: Please select Anti-Aim or Defensive tab");
                return;
            end;
            if not v611 then
                v12.push("Error: No settings found for the selected state: " .. v606);
                return;
            else
                local v612 = {
                    [1] = "yaw_mode", 
                    [2] = "yaw", 
                    [3] = "yaw_randomize", 
                    [4] = "yaw_center", 
                    [5] = "yaw_left", 
                    [6] = "yaw_right", 
                    [7] = "Jitter", 
                    [8] = "yaw_jitter_ovr", 
                    [9] = "jitter_randomize", 
                    [10] = "body_yaw", 
                    [11] = "body_speed", 
                    [12] = "random_speed", 
                    [13] = "fake_left", 
                    [14] = "fake_left_random", 
                    [15] = "fake_right", 
                    [16] = "fake_right_random", 
                    [17] = "fake_options", 
                    [18] = "antibrute", 
                    [19] = "anti_timeout", 
                    [20] = "antibrute_method", 
                    [21] = "ran_speed_1", 
                    [22] = "ran_speed_2", 
                    [23] = "speed_options", 
                    [24] = "center_options", 
                    [25] = "custom_speed_amount", 
                    [26] = "random_speed_method", 
                    [27] = "custom_amount", 
                    [28] = "amnesia_tick_speed", 
                    [29] = "yaw_random_methods", 
                    [30] = "r_min", 
                    [31] = "r_max", 
                    [32] = "scale", 
                    [33] = "frequency", 
                    [34] = "amplitude"
                };
                for v613 = 1, 22 do
                    table.insert(v612, "custom_slider_" .. v613);
                    table.insert(v612, "custom_speed_slider_" .. v613);
                end;
                local v614 = v610 and "_ct" or "";
                local v615 = v609 and "_ct" or "";
                if v614 == v615 then
                    v12.push("Error: Source and target teams are the same.");
                    return;
                else
                    local v616 = 0;
                    local v617 = 0;
                    for _, v619 in ipairs(v612) do
                        local v620 = v619 .. v614;
                        local v621 = v619 .. v615;
                        local v622 = v611[v620];
                        local v623 = v611[v621];
                        do
                            local l_v622_0, l_v623_0 = v622, v623;
                            if l_v622_0 and l_v623_0 and l_v622_0.get and l_v623_0.set then
                                v617 = v617 + 1;
                                if pcall(function()
                                    -- upvalues: l_v622_0 (ref), l_v623_0 (ref)
                                    local v626 = l_v622_0:get();
                                    l_v623_0:set(v626);
                                end) then
                                    v616 = v616 + 1;
                                end;
                            end;
                        end;
                    end;
                    local v627 = v610 and "CT-side" or "T-side";
                    local v628 = v609 and "CT-side" or "T-side";
                    local v629 = v608 == 2 and "Anti-Aim" or "Defensive";
                    v12.push("Transferred " .. v616 .. "/" .. v617 .. " " .. v629 .. " settings from " .. v627 .. " to " .. v628 .. " for state: " .. v606);
                    return;
                end;
            end;
        end;
    end;
    v14.handle = function(v630)
        -- upvalues: v9 (ref), l_core_0 (ref)
        if not v9.misc.fast_ladder:get() then
            return;
        elseif l_core_0.shared_data.movetype ~= 9 then
            return;
        elseif math.abs(v630.forwardmove) < 50 then
            return;
        else
            local _ = entity.get_local_player();
            if v630.sidemove == 0 then
                v630.view_angles.y = v630.view_angles.y + 45;
            end;
            if v630.in_forward and v630.sidemove < 0 then
                v630.view_angles.y = v630.view_angles.y + 90;
            end;
            if v630.in_back and v630.sidemove > 0 then
                v630.view_angles.y = v630.view_angles.y + 90;
            end;
            v630.in_moveleft = v630.in_back;
            v630.in_moveright = v630.in_forward;
            if v630.view_angles.x < 0 then
                v630.view_angles.x = -45;
            end;
            return;
        end;
    end;
    v11.register("createmove", "fast_ladder", v14.handle);
    local v632 = false;
    local v633 = false;
    local _ = 0;
    local _ = 0;
    local _ = 0;
    local _ = 0;
    local _ = 0;
    local _ = 0;
    local _ = 0;
    local _ = 0;
    local v642 = 0;
    local v643 = 0;
    local _ = 4;
    local _ = function(v645)
        -- upvalues: v91 (ref)
        for _, v647 in ipairs(v91.conditions) do
            if v645 == v647 then
                return true;
            end;
        end;
        return false;
    end;
    local v649 = 0;
    local v650 = false;
    local v651 = nil;
    check_weapon_swap = function()
        -- upvalues: v651 (ref)
        local v652 = entity.get_local_player();
        if v652 == nil or not v652:is_alive() then
            return;
        else
            local v653 = v652:get_player_weapon();
            if v653 then
                local v654 = v653:get_weapon_index();
                if v651 == nil then
                    v651 = v654;
                    return;
                elseif v654 ~= v651 then
                    v651 = v654;
                    return true;
                end;
            end;
            return;
        end;
    end;
    local v655 = false;
    check_reloading = function()
        -- upvalues: v655 (ref)
        local v656 = entity.get_local_player();
        if v656 == nil or not v656:is_alive() then
            return;
        else
            local v657 = v656:get_player_weapon();
            if v657 then
                local v658 = v657:get_weapon_reload();
                if v658 > 0 and v658 < 1 then
                    if not v655 then
                        v655 = true;
                        return true;
                    end;
                elseif v655 then
                    v655 = false;
                    return false;
                end;
                return;
            else
                return false;
            end;
        end;
    end;
    local v659 = 0;
    l_core_0.calculate_yaw_5way = function(v660, v661, v662)
        local v663 = nil;
        if v660 % 7 < 1.4 then
            v663 = utils.random_float(v661 / -2, v661 / -2 - v662);
        elseif v660 % 7 < 1.75 then
            v663 = utils.random_float(v661 / -2.5, v661 / -2.5 - v662);
        elseif v660 % 7 < 2.3333333333333335 then
            v663 = 0;
        elseif v660 % 7 < 3.5 then
            v663 = utils.random_float(v661 / 2.5, v661 / 2.5 - v662);
        elseif v660 % 7 < 7 then
            v663 = utils.random_float(v661 / 2, v661 / 2 - v662);
        end;
        return v663;
    end;
    l_core_0.calculate_yaw_3way = function(v664, v665, v666)
        local v667 = nil;
        if v664 % 7 < 2.3333333333333335 then
            v667 = utils.random_float(v665 / -2, v665 / -2 - v666);
        elseif v664 % 7 < 3.5 then
            v667 = 0;
        elseif v664 % 7 < 7 then
            v667 = utils.random_float(v665 / 2, v665 / 2 - v666);
        end;
        return v667;
    end;
    local v670 = {
        max_tickbase = 0, 
        is_defensive = function()
            -- upvalues: v659 (ref)
            local v668 = entity.get_local_player();
            if not v668 or not v668:is_alive() then
                return;
            else
                local l_m_nTickBase_0 = v668.m_nTickBase;
                if math.abs(l_m_nTickBase_0 - v659) > 64 then
                    v659 = 0;
                end;
                if v659 < l_m_nTickBase_0 then
                    v659 = l_m_nTickBase_0;
                elseif l_m_nTickBase_0 < v659 then
                    return math.min(14, math.max(0, v659 - l_m_nTickBase_0 - 1)) > 1;
                end;
                return false;
            end;
        end
    };
    local _ = 0;
    local v672 = 0;
    local _ = 0;
    local v674 = false;
    local _ = false;
    local v676 = 180;
    local _ = 0;
    local _ = 0;
    local function _(v679)
        -- upvalues: v672 (ref), v674 (ref), v676 (ref)
        local v680 = 2;
        local v681 = 2 * v679;
        v672 = v672 + 1;
        if v674 and v680 <= v672 or not v674 and v681 <= v672 then
            v674 = not v674;
            v672 = 0;
        end;
        return v674, v674 and (v672 == 1 and v676 or v676) or 0;
    end;
    l_core_0.random_choke = function(v683, v684, v685)
        return v683 % v684[v685 and math.random(1, #v684) or (v683 - 1) % #v684 + 1] == 0;
    end;
    l_core_0.choke_aa = function(v686, v687)
        local v688 = v686[v687 % #v686 + 1];
        v687 = v687 + 1;
        return v688;
    end;
    events.createmove:set(function(v689)
        jumping = v689.in_jump == true;
    end);
    events.createmove_run:set(function(v690)
        -- upvalues: l_core_0 (ref), v9 (ref)
        if l_core_0.refs.fd:get() and v9.misc.unlock_fakeduck:get() and not jumping and bit.band(entity.get_local_player().m_fFlags, 1) ~= 0 then
            v690.forwardmove = v690.forwardmove * 2;
            v690.sidemove = v690.sidemove * 2;
        end;
    end);
    l_core_0.closest_ray_point = function(v691, v692, v693)
        local v694 = v691 - v692;
        local v695 = v693 - v692;
        local v696 = v695:length();
        v695 = v695 / v696;
        local v697 = v695:dot(v694);
        if v697 < 0 then
            return v692;
        elseif v696 < v697 then
            return v693;
        else
            return v692 + v695 * v697;
        end;
    end;
    l_core_0.active_brute = false;
    l_core_0.active_timeout = false;
    l_core_0.dist = 0;
    l_core_0.brute_target = "none";
    l_core_0.get_camera_pos = function(v698)
        local l_m_vecOrigin_0 = v698.m_vecOrigin;
        if l_m_vecOrigin_0.x == nil then
            return;
        else
            local l_m_vecViewOffset_0 = v698.m_vecViewOffset;
            l_m_vecOrigin_0.z = l_m_vecOrigin_0.z + (l_m_vecViewOffset_0.z - v698.m_flDuckAmount * 16);
            return l_m_vecOrigin_0.x, l_m_vecOrigin_0.y, l_m_vecOrigin_0.z;
        end;
    end;
    l_core_0.fired_at = function(v701, v702, v703)
        -- upvalues: l_core_0 (ref)
        local v704 = {
            l_core_0.get_camera_pos(v702)
        };
        if v704[1] == nil then
            return;
        else
            local v705 = v701:get_hitbox_position(0);
            local v706 = {
                [1] = v705.x - v704[1], 
                [2] = v705.y - v704[2], 
                [3] = v705.z - v704[3]
            };
            local v707 = {
                [1] = v703[1] - v704[1], 
                [2] = v703[2] - v704[2], 
                [3] = v703[3] - v704[3]
            };
            local v708 = (v706[1] * v707[1] + v706[2] * v707[2] + v706[3] * v707[3]) / (math.pow(v707[1], 2) + math.pow(v707[2], 2) + math.pow(v707[3], 2));
            local v709 = {
                [1] = v704[1] + v707[1] * v708, 
                [2] = v704[2] + v707[2] * v708, 
                [3] = v704[3] + v707[3] * v708
            };
            local v710 = math.abs(math.sqrt(math.pow(v705.x - v709[1], 2) + math.pow(v705.y - v709[2], 2) + math.pow(v705.z - v709[3], 2)));
            local v711 = utils.trace_bullet(v702, vector(v703[1], v703[2], v703[3]), v705);
            local v712 = utils.trace_bullet(v701, vector(v709[1], v709[2], v709[3]), v705);
            return v710 < 129 and (not (v711 <= 0.99) or v712 > 0.99);
        end;
    end;
    local _ = 0;
    l_core_0.antibrute = {
        latest = 0, 
        damaged = 0, 
        players = entity.get_players(false, true), 
        trigger = function(v714)
            -- upvalues: v528 (ref), v9 (ref), l_core_0 (ref)
            local v715 = entity.get_local_player();
            if v715 == nil or not v715:is_alive() then
                return;
            else
                local v716 = v528:get_state(v715);
                v528.state = v716;
                if v716 == "none" then
                    return;
                else
                    local v717 = v9.rage.builder_elements[v716];
                    if not v717.antibrute:get() and l_core_0.shared_data.team == 2 or not v717.antibrute_ct:get() and l_core_0.shared_data.team == 3 then
                        return;
                    else
                        local v718 = entity.get(v714.userid, true);
                        if not v718 or not v718:is_enemy() or v718:is_dormant() then
                            return;
                        else
                            if l_core_0.fired_at(v715, v718, {
                                [1] = v714.x, 
                                [2] = v714.y, 
                                [3] = v714.z
                            }) and l_core_0.antibrute.latest ~= globals.tickcount then
                                l_core_0.antibrute.latest = globals.tickcount;
                                l_core_0.brute_target = v718:get_name();
                                l_core_0.active_brute = true;
                                l_core_0.active_timeout = false;
                                l_core_0.antibrute.latest = globals.tickcount;
                                if l_core_0.shared_data.team == 2 then
                                    if v717.anti_timeout:get() == 0 then
                                        l_core_0.active_brute = true;
                                    else
                                        utils.execute_after(v717.anti_timeout:get(), function()
                                            -- upvalues: l_core_0 (ref)
                                            l_core_0.active_brute = false;
                                            l_core_0.active_timeout = true;
                                        end);
                                    end;
                                elseif l_core_0.shared_data.team == 3 then
                                    if v717.anti_timeout_ct:get() == 0 then
                                        l_core_0.active_brute = true;
                                    else
                                        utils.execute_after(v717.anti_timeout_ct:get(), function()
                                            -- upvalues: l_core_0 (ref)
                                            l_core_0.active_brute = false;
                                            l_core_0.active_timeout = true;
                                        end);
                                    end;
                                end;
                            end;
                            return;
                        end;
                    end;
                end;
            end;
        end, 
        run = function(v719)
            events.bullet_impact:set(v719.trigger);
            events.player_hurt:set(function(v720)
                -- upvalues: v719 (ref)
                if entity.get(v720.userid, true) == lp then
                    v719.damaged = globals.tickcount;
                end;
            end);
        end
    };
    l_core_0.antibrute:run();
    l_core_0.choked_commands = 0;
    l_core_0.update_choked_commands = function(v721)
        -- upvalues: l_core_0 (ref)
        l_core_0.choked_commands = v721.choked_commands;
    end;
    events.createmove(l_core_0.update_choked_commands);
    l_core_0.choke_values = {
        [1] = 6, 
        [2] = 6, 
        [3] = 6
    };
    l_core_0.tick_choke = 0;
    l_core_0.allow_inverter = true;
    l_core_0.brute_modifier = 0;
    l_core_0.brute_modifier_ct = 0;
    local v722 = false;
    local v723 = false;
    l_core_0.auto = false;
    l_core_0.get_ref = function(v724, v725, _)
        -- upvalues: l_core_0 (ref)
        local v727 = v724 .. (l_core_0.shared_data.team == 2 and "" or "_ct");
        return v725[v727]:get() or v725[v727]:get_override();
    end;
    l_core_0.index = 0;
    l_core_0.yaw_ovr = 0;
    local v728 = 0;
    local _ = {};
    local v730 = 1;
    local v731 = 1;
    local v732 = 0;
    local v733 = false;
    l_core_0.ctx = {
        yaw = 0, 
        offset = 0, 
        pitch = "Down"
    };
    local v734 = false;
    local _ = 0.5;
    local function v738(v736, v737)
        return math.floor(math.random() * (v737 - v736 + 1) + v736);
    end;
    local v739 = 0;
    local _ = 0;
    l_core_0.update_counters = function()
        -- upvalues: l_core_0 (ref), v642 (ref), v643 (ref), v649 (ref), v650 (ref)
        l_core_0.tick_choke = l_core_0.tick_choke + 1;
        v642 = v642 + 1;
        v643 = v643 + 1;
        v649 = v649 + 1;
        if v649 > 1 then
            v650 = not v650;
            v649 = 0;
        end;
    end;
    events.createmove(l_core_0.update_counters);
    l_core_0.apply_yaw_settings = function(v741, v742, v743, _, _, v746, v747, _)
        -- upvalues: l_core_0 (ref), v739 (ref), v738 (ref), v730 (ref), v728 (ref), v734 (ref)
        if l_core_0.choked_commands > 0 then
            return;
        else
            local l_get_ref_0 = l_core_0.get_ref;
            local l_random_float_0 = utils.random_float;
            local l_random_int_0 = utils.random_int;
            local v752 = l_get_ref_0("Jitter", v742, v743);
            local v753 = l_get_ref_0("yaw_randomize", v742, v743);
            local v754 = l_get_ref_0("fake_options", v742, v743);
            local v755 = l_get_ref_0("center_options", v742, v743);
            local v756 = v755 == "Custom";
            local _ = entity.get_local_player();
            local _ = entity.get_local_player():get_player_weapon(false):get_classname();
            local function v767(v759, v760)
                -- upvalues: l_get_ref_0 (ref), v742 (ref), v743 (ref), l_random_float_0 (ref)
                local v761 = l_get_ref_0("yaw_random_methods", v742, v743);
                if v761 == "Default" then
                    return l_random_float_0(v759, v759 - v760);
                elseif v761 == "Sinusoidal" then
                    local v762 = l_get_ref_0("frequency", v742, v743);
                    local v763 = l_get_ref_0("amplitude", v742, v743);
                    return v759 + math.sin(globals.curtime * v762) * v763;
                elseif v761 == "Chaotic" then
                    local v764 = l_get_ref_0("r_min", v742, v743);
                    local v765 = l_get_ref_0("r_max", v742, v743);
                    local v766 = globals.curtime * l_get_ref_0("scale", v742, v743);
                    return v759 + l_random_float_0(v764, v765) * math.sin(v766) * math.cos(v766 * 2) * math.sin(v766 * 0.5);
                else
                    return v759;
                end;
            end;
            local function v774(v768, v769, _, _, v772)
                -- upvalues: v739 (ref), v767 (ref), v753 (ref), v738 (ref)
                local v773 = math.random(1, 100);
                if v772 then
                    if v773 <= 45 then
                        v739 = v767(v768, v753);
                    elseif v773 <= 75 then
                        v739 = -math.abs(v767(v768 * 0.8, v753));
                    else
                        v739 = v738(-5, 0);
                    end;
                elseif v773 <= 45 then
                    v739 = v767(v769, v753);
                elseif v773 <= 75 then
                    v739 = math.abs(v767(v769 * 0.8, v753));
                else
                    v739 = v738(0, 5);
                end;
                return v739;
            end;
            local v775 = nil;
            local l_body_yaw_0 = l_core_0.refs.body_yaw;
            if v754 == "Static" then
                v775 = v767(l_get_ref_0("yaw_left", v742, v743), v753);
                l_body_yaw_0[3]:override(l_random_int_0(l_get_ref_0("fake_left", v742, v743), l_get_ref_0("fake_left", v742, v743) - l_get_ref_0("fake_left_random", v742, v743)));
                l_body_yaw_0[4]:override(l_random_int_0(l_get_ref_0("fake_right", v742, v743), l_get_ref_0("fake_right", v742, v743) - l_get_ref_0("fake_right_random", v742, v743)));
                l_core_0.refs.inverter:override(true);
            else
                if v756 then
                    local v777 = {};
                    for v778 = 1, l_get_ref_0("custom_amount", v742, v743) do
                        local v779 = l_get_ref_0("custom_slider_" .. v778, v742, v743);
                        if v779 then
                            table.insert(v777, v779);
                        end;
                    end;
                    if #v777 > 0 then
                        v730 = v730 % #v777 + 1;
                        v728 = v777[v730];
                    end;
                end;
                if v752 ~= "Center" then
                    local v780 = v755 == "Min - Max" and math.random(l_get_ref_0("center_min", v742, v743), l_get_ref_0("center_max", v742, v743)) or v755 == "Randomize" and l_random_float_0(l_get_ref_0("yaw_jitter_ovr", v742, v743), l_get_ref_0("yaw_jitter_ovr", v742, v743) - l_get_ref_0("jitter_randomize", v742, v743)) or v756 and v728 or l_random_float_0(l_get_ref_0("yaw_jitter_ovr", v742, v743), l_get_ref_0("yaw_jitter_ovr", v742, v743));
                    l_core_0.refs.jitter:override(v752);
                    l_core_0.refs.jitter_val:override(v780);
                else
                    l_core_0.refs.jitter:override("Disabled");
                    l_core_0.refs.jitter_val:override(0);
                end;
                if v741 then
                    if v752 == "Center" then
                        v775 = v756 and v728 or v767(v746, v753);
                    elseif v752 == "3-way" or v752 == "5-way" or v752 == "Spin" then
                        v775 = v767(v746, v753);
                    elseif v752 == "Hold" then
                        v775 = v774(v746, v747, v742, v743, v741);
                    else
                        v775 = v767(l_get_ref_0("yaw_left", v742, v743), v753);
                    end;
                    if v734 then
                        l_body_yaw_0[3]:override(l_random_int_0(l_get_ref_0("fake_left", v742, v743), l_get_ref_0("fake_left", v742, v743) - l_get_ref_0("fake_left_random", v742, v743)));
                        l_body_yaw_0[4]:override(l_random_int_0(l_get_ref_0("fake_right", v742, v743), l_get_ref_0("fake_right", v742, v743) - l_get_ref_0("fake_right_random", v742, v743)));
                        l_core_0.refs.inverter:override(false);
                    else
                        l_body_yaw_0[3]:override(l_random_int_0(l_get_ref_0("fake_left", v742, v743), l_get_ref_0("fake_left", v742, v743) - l_get_ref_0("fake_left_random", v742, v743)));
                        l_body_yaw_0[4]:override(l_random_int_0(-l_get_ref_0("fake_right", v742, v743), -l_get_ref_0("fake_right", v742, v743) - l_get_ref_0("fake_right_random", v742, v743)));
                        l_core_0.refs.inverter:override(l_core_0.allow_inverter);
                    end;
                else
                    if v752 == "Center" then
                        v775 = v756 and v728 or v767(v747, v753);
                    elseif v752 == "3-way" or v752 == "5-way" or v752 == "Spin" then
                        v775 = v767(v747, v753);
                    elseif v752 == "Hold" then
                        v775 = v774(v746, v747, v742, v743, v741);
                    else
                        v775 = v767(l_get_ref_0("yaw_right", v742, v743), v753);
                    end;
                    if v734 then
                        l_body_yaw_0[3]:override(l_random_int_0(l_get_ref_0("fake_left", v742, v743), l_get_ref_0("fake_left", v742, v743) - l_get_ref_0("fake_left_random", v742, v743)));
                        l_body_yaw_0[4]:override(l_random_int_0(l_get_ref_0("fake_right", v742, v743), l_get_ref_0("fake_right", v742, v743) - l_get_ref_0("fake_right_random", v742, v743)));
                    else
                        l_body_yaw_0[3]:override(l_random_int_0(-l_get_ref_0("fake_left", v742, v743), -l_get_ref_0("fake_left", v742, v743) - l_get_ref_0("fake_left_random", v742, v743)));
                        l_body_yaw_0[4]:override(l_random_int_0(l_get_ref_0("fake_right", v742, v743), l_get_ref_0("fake_right", v742, v743) - l_get_ref_0("fake_right_random", v742, v743)));
                    end;
                    l_core_0.refs.inverter:override(false);
                end;
            end;
            return v775;
        end;
    end;
    local v781 = {
        Forward = 180, 
        Right = 90, 
        Left = -90
    };
    local v782 = {
        [1] = "Standing", 
        [2] = "Running", 
        [3] = "Slowmotion", 
        [4] = "Crouch", 
        [5] = "Crouch Moving", 
        [6] = "Air", 
        [7] = "Air Crouch"
    };
    l_core_0.should_disable_freestand = function(v783, v784)
        -- upvalues: v782 (ref)
        for v785, v786 in pairs(v782) do
            if v783:get(v785) and v784 == v786 then
                return true;
            end;
        end;
        return false;
    end;
    l_core_0.apply_manual = function(v787)
        -- upvalues: v529 (ref), l_core_0 (ref), v9 (ref)
        v529.manual_state = v787;
        l_core_0.refs.base:override("local view");
        if v9.rage.freestanding_bind.prefer_manual:get() then
            l_core_0.refs.freestand_bind:set(false);
            if not v9.rage.freestanding_bind.keep_fs:get() then
                v9.rage.freestanding_bind:set(false);
            end;
        end;
    end;
    l_core_0.handle_safe_head = function()
        -- upvalues: v528 (ref), v9 (ref)
        local v788 = entity.get_local_player();
        if v788 == nil then
            return;
        elseif not v788:is_alive() then
            return;
        else
            local v789 = v528:get_state(v788);
            local v790 = v788:get_player_weapon(false);
            if v790 == nil then
                return;
            else
                local v791 = v790:get_classname();
                local l_safe_options_0 = v9.rage.safe_head.safe_options;
                local v793 = entity.get_threat(false);
                local v794 = v791:find("Knife");
                local v795 = v791:find("Taser");
                local v796 = v788:get_origin();
                local _ = 0;
                local v798 = (v793 == nil and 0 or v793:get_origin()) - v796;
                local v799 = -v798.z;
                local v800 = v798:length2dsqr();
                local v801 = l_safe_options_0:get(1);
                local v802 = l_safe_options_0:get(2);
                local v803 = l_safe_options_0:get(3);
                local v804 = l_safe_options_0:get(4);
                local v805 = l_safe_options_0:get(5);
                local v806 = l_safe_options_0:get(6);
                if v801 and v789 == "Standing" then
                    return true;
                elseif v802 and v789 == "Crouch" then
                    return true;
                elseif v803 and v789 == "Air Crouch" and v794 then
                    return true;
                elseif v806 and v789 == "Air Crouch" and v795 then
                    return true;
                elseif v804 and v793 ~= nil and v800 > 1000000 then
                    return true;
                elseif v805 and v799 >= 24 then
                    return true;
                else
                    return false;
                end;
            end;
        end;
    end;
    l_core_0.distance = function(v807, v808, _, v810, v811, _)
        return math.sqrt((v807 - v810) * (v807 - v810) + (v808 - v811) * (v808 - v811));
    end;
    l_core_0.extrapolate = function(v813, v814, v815, v816, v817)
        local l_x_1 = v813.m_vecVelocity.x;
        local l_y_0 = v813.m_vecVelocity.y;
        local l_z_0 = v813.m_vecVelocity.z;
        return v815 + globals.tickinterval * l_x_1 * v814, v816 + globals.tickinterval * l_y_0 * v814, v817 + globals.tickinterval * l_z_0 * v814;
    end;
    l_core_0.round_end = false;
    l_core_0.last_values = {
        base_val = "At Target", 
        body6_val = "Off", 
        body_mode_val = "Disabled", 
        yaw4_val = 0, 
        yaw3_val = 0, 
        inverter_val = false, 
        body_enable_val = false, 
        jitter_val_val = 0, 
        jitter_mode_val = "Disabled", 
        pitch_val = "Disabled", 
        offset_val = 0
    };
    l_core_0.handle_neverlose_body = function(v821, v822, _, v824)
        -- upvalues: l_core_0 (ref), v529 (ref), v734 (ref)
        if l_core_0.choked_commands == 0 then
            local v825 = entity.get_local_player();
            if v825 == nil or not v825:is_alive() then
                return;
            elseif v825:get_player_weapon(false) == nil then
                return;
            else
                local _ = l_core_0.refs;
                local v827 = not l_core_0.should_disable_freestand(v821.rage.freestanding_bind.freestand_options, v822) and (v821.rage.freestanding_bind:get() or v821.rage.freestanding_bind:get_override());
                local l_manual_state_0 = v529.manual_state;
                local l_tickcount_2 = globals.tickcount;
                local function v833(v830)
                    -- upvalues: l_core_0 (ref)
                    for v831, v832 in pairs(v830) do
                        l_core_0.last_values[v831] = v832;
                    end;
                end;
                l_core_0.refs.backstab:override(v821.rage.avoid_knife:get());
                if v827 then
                    local v834 = v821.rage.freestanding_bind.freestand_body:get();
                    if v834 == 1 or v834 == 2 then
                        v833({
                            body_enable_val = true, 
                            base_val = "At Target", 
                            body6_val = "Off", 
                            pitch_val = "Down", 
                            offset_val = l_manual_state_0, 
                            body_mode_val = v834 == 1 and "Static" or "Jitter"
                        });
                    end;
                    v734 = v834 == 1;
                elseif v821.rage.manual:get() ~= "At Target" then
                    v833({
                        base_val = "local view", 
                        offset_val = l_manual_state_0 - v824
                    });
                    v734 = false;
                elseif v821.rage.safe_head:get() and l_core_0.handle_safe_head() then
                    v833({
                        body_enable_val = true, 
                        base_val = "At Target", 
                        body6_val = "Off", 
                        pitch_val = "Down", 
                        body_mode_val = "Static", 
                        offset_val = 30
                    });
                    v734 = true;
                elseif (entity.get_game_rules().m_bWarmupPeriod or l_core_0.round_end) and v821.rage.additions:get(1) then
                    v833({
                        body_enable_val = false, 
                        base_val = "local view", 
                        body6_val = "Off", 
                        pitch_val = "Disabled", 
                        body_mode_val = "Disabled", 
                        offset_val = l_tickcount_2 * 25 % 360
                    });
                    v734 = false;
                else
                    v833({
                        body_enable_val = true, 
                        base_val = "At Target", 
                        body6_val = "off", 
                        pitch_val = "down", 
                        offset_val = v824 - l_core_0.brute_modifier
                    });
                    v734 = false;
                end;
            end;
        end;
        local l_refs_1 = l_core_0.refs;
        l_refs_1.offset:override(l_core_0.last_values.offset_val);
        l_refs_1.pitch:set(l_core_0.last_values.pitch_val);
        l_refs_1.body_yaw[6]:override(l_core_0.last_values.body6_val);
        l_refs_1.base:override(l_core_0.last_values.base_val);
    end;
    local l_random_int_1 = v19.utils.random_int;
    local l_random_float_1 = v19.utils.random_float;
    local l_normalize_yaw_0 = v19.math.normalize_yaw;
    local l_get_ref_1 = l_core_0.get_ref;
    local l_commandack_1 = globals.commandack;
    local _ = globals.tickcount;
    local v842 = {};
    for v843, v844 in pairs(v782) do
        v842[v844] = v843;
    end;
    local function v879(v845, v846, v847, v848)
        -- upvalues: l_core_0 (ref), l_random_float_1 (ref), l_normalize_yaw_0 (ref), v670 (ref), v734 (ref), l_random_int_1 (ref)
        local v849 = l_core_0.get_ref("def_toggle", v845, v846);
        if not v847 or not v849 then
            return false;
        else
            local l_body_yaw_1 = l_core_0.refs.body_yaw;
            local l_get_ref_2 = l_core_0.get_ref;
            local v852 = l_get_ref_2("yaw_mode", v845, v846);
            local v853 = l_get_ref_2("def_pitch", v845, v846);
            local v854 = v853 == "Down" and 89 or v853 == "Random" and l_random_float_1(-89, 89) or v853 == "Auto" and (globals.tickcount % 178 > 89 and -(globals.tickcount % 89) or globals.tickcount % 89) or l_get_ref_2("pitch_offset", v845, v846);
            rage.antiaim:override_hidden_pitch(v854);
            local v855 = nil;
            local function v867(v856, v857, v858, v859)
                -- upvalues: l_core_0 (ref), l_random_float_1 (ref)
                local v860 = l_core_0.get_ref("yaw_random_methods", v858, v859);
                if v860 == "Default" then
                    return l_random_float_1(v856, v856 - v857);
                elseif v860 == "Sinusoidal" then
                    local v861 = l_core_0.get_ref("frequency", v858, v859);
                    local v862 = l_core_0.get_ref("amplitude", v858, v859);
                    return v856 + math.sin(globals.curtime * v861) * v862;
                elseif v860 == "Chaotic" then
                    local v863 = l_core_0.get_ref("r_min", v858, v859);
                    local v864 = l_core_0.get_ref("r_max", v858, v859);
                    local v865 = l_core_0.get_ref("scale", v858, v859);
                    local v866 = globals.curtime * v865;
                    return v856 + l_random_float_1(v863, v864) * math.sin(v866) * math.cos(v866 * 2) * math.sin(v866 * 0.5);
                else
                    return v856;
                end;
            end;
            if v852 == "Sideways" then
                local v868 = v848 and 90 or -90;
                rage.antiaim:override_hidden_yaw_offset(v868);
                v855 = 0;
            elseif v852 == "Random" then
                local v869 = l_normalize_yaw_0(math.random(-180, 180), -180, 180);
                rage.antiaim:override_hidden_yaw_offset(v869);
                v855 = 0;
            elseif v852 == "Spin" then
                local v870 = globals.tickcount * 2 ^ l_get_ref_2("spin_speed", v845, v846) % 360;
                rage.antiaim:override_hidden_yaw_offset(v870);
                v855 = 0;
            elseif v852 == "L - R" then
                local l_v848_0 = v848;
                local v872 = l_get_ref_2("Jitter", v845, v846);
                local v873 = l_get_ref_2("yaw_randomize", v845, v846);
                local v874 = l_get_ref_2("center_options", v845, v846);
                local _ = v874 == "Custom";
                local v876 = l_get_ref_2("yaw_left", v845, v846);
                local v877 = l_get_ref_2("yaw_right", v845, v846);
                if v872 ~= "Center" then
                    local v878 = v874 == "Min - Max" and math.random(l_get_ref_2("center_min", v845, v846), l_get_ref_2("center_max", v845, v846)) or v874 == "Randomize" and l_random_float_1(l_get_ref_2("yaw_jitter_ovr", v845, v846), l_get_ref_2("yaw_jitter_ovr", v845, v846) - l_get_ref_2("jitter_randomize", v845, v846));
                    if v670.is_defensive() then
                        l_core_0.refs.jitter:override(v872);
                        l_core_0.refs.jitter_val:override(v878);
                    end;
                elseif v670.is_defensive() then
                    l_core_0.refs.jitter:override("Disabled");
                    l_core_0.refs.jitter_val:override(0);
                end;
                if l_v848_0 then
                    if v872 == "Center" then
                        v855 = v867(v876, v873, v845, v846);
                    elseif v872 == "3-way" or v872 == "5-way" then
                        v855 = v867(v876, v873, v845, v846);
                    else
                        v855 = v867(l_get_ref_2("yaw_left", v845, v846), v873, v845, v846);
                    end;
                    if v734 then
                        l_body_yaw_1[3]:override(l_random_int_1(l_get_ref_2("fake_left", v845, v846), l_get_ref_2("fake_left", v845, v846) - l_get_ref_2("fake_left_random", v845, v846)));
                        l_body_yaw_1[4]:override(l_random_int_1(l_get_ref_2("fake_right", v845, v846), l_get_ref_2("fake_right", v845, v846) - l_get_ref_2("fake_right_random", v845, v846)));
                        l_core_0.refs.inverter:override(false);
                    else
                        l_body_yaw_1[3]:override(l_random_int_1(l_get_ref_2("fake_left", v845, v846), l_get_ref_2("fake_left", v845, v846) - l_get_ref_2("fake_left_random", v845, v846)));
                        l_body_yaw_1[4]:override(l_random_int_1(-l_get_ref_2("fake_right", v845, v846), -l_get_ref_2("fake_right", v845, v846) - l_get_ref_2("fake_right_random", v845, v846)));
                        l_core_0.refs.inverter:override(l_core_0.allow_inverter);
                    end;
                else
                    if v872 == "Center" then
                        v855 = v867(v877, v873, v845, v846);
                    elseif v872 == "3-way" or v872 == "5-way" then
                        v855 = v867(v877, v873, v845, v846);
                    else
                        v855 = v867(l_get_ref_2("yaw_right", v845, v846), v873, v845, v846);
                    end;
                    if v734 then
                        l_body_yaw_1[3]:override(l_random_int_1(l_get_ref_2("fake_left", v845, v846), l_get_ref_2("fake_left", v845, v846) - l_get_ref_2("fake_left_random", v845, v846)));
                        l_body_yaw_1[4]:override(l_random_int_1(l_get_ref_2("fake_right", v845, v846), l_get_ref_2("fake_right", v845, v846) - l_get_ref_2("fake_right_random", v845, v846)));
                    else
                        l_body_yaw_1[3]:override(l_random_int_1(-l_get_ref_2("fake_left", v845, v846), -l_get_ref_2("fake_left", v845, v846) - l_get_ref_2("fake_left_random", v845, v846)));
                        l_body_yaw_1[4]:override(l_random_int_1(l_get_ref_2("fake_right", v845, v846), l_get_ref_2("fake_right", v845, v846) - l_get_ref_2("fake_right_random", v845, v846)));
                    end;
                    l_core_0.refs.inverter:override(false);
                end;
                rage.antiaim:override_hidden_yaw_offset(0);
            end;
            return true, v855;
        end;
    end;
    l_core_0.handle_def = function(v880)
        -- upvalues: v528 (ref), v9 (ref), l_core_0 (ref), v782 (ref), v733 (ref), v55 (ref)
        local v881 = entity.get_local_player();
        if v881 == nil or not v881:is_alive() then
            return;
        else
            local v882 = v528:get_state(v881);
            if v882 == "none" then
                return;
            else
                local v883 = v9.rage.builder_elements[v882];
                local v884 = v881:get_player_weapon(false);
                if not v884 then
                    return;
                else
                    local v885 = v884:get_classname();
                    local v886 = false;
                    local v887 = false;
                    local v888 = {
                        [1] = 1, 
                        [2] = 1, 
                        [3] = 1
                    };
                    if v883.defensive_tickbase:get() == 1 then
                        if v883.tick_random:get() then
                            v888 = {
                                v883.tick_speed1:get(), 
                                v883.tick_speed2:get()
                            };
                        else
                            v888 = {
                                v883.tick_speed1:get()
                            };
                        end;
                        v887 = l_core_0.random_choke(l_core_0.tick_choke, v888, true);
                        l_core_0.refs.def:override("On peek");
                        v880.force_defensive = v887 and not v885:find("Grenade");
                    else
                        for v889, v890 in pairs(v782) do
                            if v9.defensive.defensive_conditions:get(v889) and v882 == v890 then
                                v886 = true;
                                break;
                            end;
                        end;
                    end;
                    local v891 = check_weapon_swap() and v9.defensive.game_events:get(1);
                    if v9.defensive.force_hideshot:get() then
                        l_core_0.refs.hideshot_config:override("Break LC");
                    else
                        l_core_0.refs.hideshot_config:override("Favor Fire Rate");
                    end;
                    if v891 or check_reloading() and v9.defensive.game_events:get(2) then
                        l_core_0.refs.def:override("Always on");
                    elseif v886 then
                        l_core_0.refs.def:override("Always on");
                    elseif v733 then
                        l_core_0.refs.def:override("Disabled");
                    else
                        l_core_0.refs.def:override("On peek");
                    end;
                    if not v885:find("Grenade") then
                        v55:override(true);
                    end;
                    return;
                end;
            end;
        end;
    end;
    events.createmove(l_core_0.handle_def);
    l_core_0.antiaim = function(v892)
        -- upvalues: v528 (ref), l_core_0 (ref), v9 (ref), v781 (ref), v529 (ref), v632 (ref), v782 (ref), v723 (ref), v12 (ref), v722 (ref), l_random_int_1 (ref), v434 (ref), v879 (ref), v670 (ref), v734 (ref), l_get_ref_1 (ref), v728 (ref), l_commandack_1 (ref), v731 (ref), v642 (ref), v732 (ref), v733 (ref), v643 (ref), v633 (ref)
        local v893 = entity.get_local_player();
        if v893 == nil or not v893:is_alive() then
            return;
        else
            local v894 = v528:get_state(v893);
            if v894 == "none" then
                return;
            else
                v528.state = v894;
                l_core_0.refs.yaw:override("Backward");
                local l_team_0 = l_core_0.shared_data.team;
                local v896 = v9.rage.builder_elements[v894];
                local v897 = v9.rage.defensive_elements[v894];
                local v898 = v893:get_player_weapon(false);
                if v898 == nil then
                    return;
                else
                    local v899 = v898:get_classname();
                    local v900 = v9.rage.manual:get();
                    local v901 = entity.get_game_rules();
                    local v902 = 0;
                    local _ = 0;
                    if v781[v900] then
                        l_core_0.apply_manual(v781[v900]);
                    else
                        l_core_0.refs.base:override("At Target");
                        v529.manual_state = 0;
                        if v9.rage.freestanding_bind:get() then
                            l_core_0.refs.freestand_bind:override(not l_core_0.should_disable_freestand(v9.rage.freestanding_bind.freestand_options, v894));
                        else
                            local v904 = l_core_0.should_disable_freestand(v9.rage.freestanding_bind.freestand_enablers, v894);
                            v9.rage.freestanding_bind:override(v904);
                            l_core_0.refs.freestand_bind:override(v904);
                        end;
                    end;
                    if v9.rage.additions:get(1) and v901.m_bWarmupPeriod then
                        l_core_0.refs.fakelag:override(1);
                    elseif v9.rage.additions:get(2) and rage.exploit:get() == 1 then
                        l_core_0.refs.fakelag:override(1);
                    elseif v9.rage.additions:get(3) and rage.exploit:get() == 1 and v632 then
                        l_core_0.refs.fakelag:override(1);
                    else
                        l_core_0.refs.fakelag:override();
                    end;
                    local v905 = false;
                    if v9.rage.hidden_builder:get() then
                        local v906 = v896.def_activation:get();
                        for v907, v908 in pairs(v782) do
                            if v9.rage.hidden_builder.antiaim_conditions:get(v907) and v894 == v908 and (v906 == "Always" or v906 == "Hittable" and entity.get_threat(true) ~= nil) then
                                v905 = true;
                                break;
                            end;
                        end;
                    end;
                    local _ = (not v9.rage.freestanding_bind:get() or not v9.rage.hidden_builder.disablers:get(1)) and (not (v9.rage.manual:get() ~= "At Target") or not v9.rage.hidden_builder.disablers:get(2)) and (not l_core_0.refs.autopeek:get() or not v9.rage.hidden_builder.disablers:get(3));
                    if l_core_0.active_timeout and not v723 then
                        v12.push("anti-brute timed out and was reset", clr);
                    end;
                    v723 = l_core_0.active_timeout;
                    if l_core_0.active_brute and not v722 then
                        local v910 = v896.antibrute_method:get();
                        v12.push(string.format("changed anti-aim due to %s bullet [method:%s]", l_core_0.brute_target, v910), clr);
                    end;
                    v722 = l_core_0.active_brute;
                    if l_core_0.active_brute then
                        local v911 = v896.antibrute_method:get();
                        if v911 == 1 then
                            l_core_0.brute_modifier = 10;
                        elseif v911 == 2 then
                            l_core_0.brute_modifier = l_random_int_1(5, 10);
                        else
                            l_core_0.brute_modifier = -10;
                        end;
                    else
                        l_core_0.brute_modifier = 0;
                    end;
                    local _ = rage.exploit:get() == 1 or v434.hs:get();
                    local v913, v914 = v879(v897, l_team_0, v670.is_defensive(), v632);
                    if v913 then
                        if v734 then
                            l_core_0.refs.body_yaw[5]:override("");
                        else
                            local v915 = l_get_ref_1("speed_options", v897, l_team_0);
                            l_core_0.allow_inverter = v915 ~= "Neverlose";
                            if l_get_ref_1("fake_options", v897, l_team_0) == "Static" then
                                l_core_0.refs.body_yaw[5]:override("");
                            else
                                l_core_0.refs.body_yaw[5]:override(v915 == "Neverlose" and "Jitter" or "off");
                            end;
                        end;
                    elseif v734 then
                        l_core_0.refs.body_yaw[5]:override("");
                    else
                        local v916 = l_get_ref_1("speed_options", v896, l_team_0);
                        l_core_0.allow_inverter = v916 ~= "Neverlose";
                        if l_get_ref_1("fake_options", v896, l_team_0) == "Static" then
                            l_core_0.refs.body_yaw[5]:override("");
                        else
                            l_core_0.refs.body_yaw[5]:override(v916 == "Neverlose" and "Jitter" or "off");
                        end;
                    end;
                    local v917 = l_get_ref_1("center_options", v896, l_team_0);
                    l_core_0.yaw_ovr = v917 == "Min - Max" and l_random_int_1(l_get_ref_1("center_min", v896, l_team_0), l_get_ref_1("center_max", v896, l_team_0)) or v917 == "Randomize" and l_random_int_1(l_get_ref_1("yaw_jitter_ovr", v896, l_team_0), l_get_ref_1("yaw_jitter_ovr", v896, l_team_0) - l_get_ref_1("jitter_randomize", v896, l_team_0)) or 0;
                    local v918 = l_get_ref_1("Jitter", v896, l_team_0) == "Center" and l_core_0.yaw_ovr / 2 or 0;
                    local v919 = l_get_ref_1("yaw_left", v896, l_team_0) + v918;
                    local v920 = l_get_ref_1("yaw_right", v896, l_team_0) - v918;
                    local v921 = l_get_ref_1("yaw_mode", v896, l_team_0);
                    local v922 = 0;
                    if v921 == "L - R" then
                        if not v913 then
                            l_core_0.refs.hidden:override(false);
                            v922 = l_core_0.apply_yaw_settings(v632, v896, l_team_0, v902, v728, v919, v920, v892);
                        else
                            l_core_0.refs.hidden:override(true);
                            v922 = v914;
                        end;
                    elseif v921 == "Automatic" then
                        local v923 = l_get_ref_1("random_speed", v896, l_team_0) and l_random_int_1(l_get_ref_1("ran_speed_1", v896, l_team_0), l_get_ref_1("ran_speed_2", v896, l_team_0)) or l_get_ref_1("body_speed", v896, l_team_0);
                        if l_commandack_1 % v923 == 1 then
                            l_core_0.auto = not l_core_0.auto;
                            v922 = l_core_0.apply_yaw_settings(not l_core_0.auto, v896, l_team_0, v902, v728, v919, v920, v892);
                        end;
                    end;
                    local v924 = l_get_ref_1("custom_speed_amount", v896, l_team_0);
                    local v925 = {};
                    local v926 = l_get_ref_1("random_speed_method", v896, l_team_0) == "Custom";
                    if v926 then
                        for v927 = 1, v924 do
                            local v928 = l_get_ref_1("custom_speed_slider_" .. v927, v896, l_team_0);
                            if v928 then
                                table.insert(v925, v928);
                            end;
                        end;
                        if not v731 or v731 > #v925 then
                            v731 = 1;
                        end;
                    end;
                    if v913 then
                        local v929 = 0;
                        if not l_get_ref_1("random_speed", v897, l_team_0) then
                            v929 = l_get_ref_1("body_speed", v897, l_team_0) or 0;
                        elseif l_get_ref_1("random_speed_method", v897, l_team_0) == "Random" then
                            v929 = l_random_int_1(l_get_ref_1("ran_speed_1", v897, l_team_0) or 0, l_get_ref_1("ran_speed_2", v897, l_team_0) or 0);
                        elseif v926 and #v925 > 0 then
                            v929 = v925[v731] or 0;
                        end;
                        if v929 < v642 then
                            v642 = 0;
                            v632 = not v632;
                            if v926 and #v925 > 0 then
                                v731 = v731 % #v925 + 1;
                            end;
                        end;
                    else
                        local v930 = 0;
                        if not l_get_ref_1("random_speed", v896, l_team_0) then
                            v930 = l_get_ref_1("body_speed", v896, l_team_0) or 0;
                        elseif l_get_ref_1("random_speed_method", v896, l_team_0) == "Random" then
                            v930 = l_random_int_1(l_get_ref_1("ran_speed_1", v896, l_team_0) or 0, l_get_ref_1("ran_speed_2", v896, l_team_0) or 0);
                        elseif v926 and #v925 > 0 then
                            v930 = v925[v731] or 0;
                        end;
                        if v930 < v642 then
                            v642 = 0;
                            v632 = not v632;
                            if v926 and #v925 > 0 then
                                v731 = v731 % #v925 + 1;
                            end;
                        end;
                    end;
                    if v899:find("Grenade") or v899:find("Flashbang") then
                        v732 = globals.tickcount;
                    elseif math.max(v898.m_flNextPrimaryAttack, v893.m_flNextAttack) - globals.tickinterval - globals.curtime < 0 then
                        v733 = true;
                    else
                        v733 = false;
                    end;
                    local l_m_fThrowTime_0 = v898.m_fThrowTime;
                    v733 = v732 + 15 == globals.tickcount or l_m_fThrowTime_0 and l_m_fThrowTime_0 ~= 0;
                    if v913 then
                        if v733 then
                            l_core_0.refs.body_yaw[1]:override(false);
                        elseif speed_option == "Amnesia" then
                            if v643 > l_get_ref_1("amnesia_tick_speed", v897, l_team_0) then
                                v643 = 0;
                                v633 = not v633;
                            end;
                            l_core_0.refs.body_yaw[1]:override(not v633);
                        else
                            l_core_0.refs.body_yaw[1]:override(l_get_ref_1("body_yaw", v897, l_team_0) and true or false);
                        end;
                    elseif v733 then
                        l_core_0.refs.body_yaw[1]:override(false);
                    elseif speed_option == "Amnesia" then
                        if v643 > l_get_ref_1("amnesia_tick_speed", v896, l_team_0) then
                            v643 = 0;
                            v633 = not v633;
                        end;
                        l_core_0.refs.body_yaw[1]:override(not v633);
                    else
                        l_core_0.refs.body_yaw[1]:override(l_get_ref_1("body_yaw", v896, l_team_0) and true or false);
                    end;
                    l_core_0.handle_neverlose_body(v9, v894, v899, v922);
                    return;
                end;
            end;
        end;
    end;
    v12 = {
        show_time = 3, 
        per_notify_offset = 35, 
        prefix_icon = "", 
        base_offset = 100 * l_core_0.dpi_scale.x, 
        anim_speed = l_manager_0.base_speed / 3, 
        list = {}
    };
    local function v947(v932, v933, v934, v935)
        -- upvalues: v12 (ref), v9 (ref), l_core_0 (ref), v60 (ref)
        v933 = math.floor(v933);
        local v936 = v934 * 255;
        v12.prefix_icon = v9.visuals.notifs.notifs_prefix:get() and "pipe" or "triangle-exclamation";
        local v937 = v9.visuals.notifs.notifs_prefix:get() and "luasense  " or "";
        local v938 = render.measure_text(4, nil, v937);
        local v939 = render.measure_text(1, nil, v932);
        local v940 = vector(27, 12);
        local v941 = vector(v938.x + v939.x, math.max(v938.y, v939.y)) + v940;
        local v942 = v9.visuals.notifs.notifs_round_amount:get();
        local v943 = color(23, 23, 23, v936);
        v935 = v935:override("a", v936);
        local v944 = vector(l_core_0.screen_size.x / 2 - v941.x / 2, l_core_0.screen_size.y - v933);
        if v9.visuals.notifs.notifs_glow_amount:get() ~= 0 then
            render.shadow(v944, v944 + v941, v935, v9.visuals.notifs.notifs_glow_amount:get(), 1, v942);
        end;
        render.rect(v944, v944 + v941, v943, v942);
        local v945 = v944 + vector(v940.x / 2, v941.y / 2 - v938.y / 2);
        local v946 = v937 ~= "" and v945 + vector(v938.x, 0) or v944 + vector(v940.x / 2, v941.y / 2 - v939.y / 2);
        if v937 ~= "" then
            render.text(v9.visuals.notifs.notifs_prefix_font:get(), v945, v9.visuals.notifs.notifs_prefix_clr:get():override("a", v936), "l", v9.visuals.notifs.notifs_prefix_font:get() == 2 and v937:upper() or v937);
        end;
        render.text(1, v946, v60.white:override("a", v936), "l", v932);
    end;
    v12.push = function(v948, v949)
        -- upvalues: v12 (ref), l_core_0 (ref), v9 (ref)
        table.insert(v12.list, 1, {
            offset = 50, 
            state = 0, 
            text = l_core_0:with_icon(v12.prefix_icon, v948, v949 or v9.visuals.accent:get()), 
            shows_until = globals.realtime + v12.show_time, 
            color = v949 or v9.visuals.accent:get()
        });
    end;
    do
        local l_v947_0 = v947;
        v12.handle = function()
            -- upvalues: v12 (ref), v65 (ref), l_v947_0 (ref)
            if #v12.list == 0 then
                return;
            else
                local l_base_offset_0 = v12.base_offset;
                local l_realtime_0 = globals.realtime;
                for v953, v954 in pairs(v12.list) do
                    l_base_offset_0 = l_base_offset_0 + v12.per_notify_offset;
                    local l_l_base_offset_0_0 = l_base_offset_0;
                    local v956 = v954.shows_until < l_realtime_0 or v953 > 3;
                    local v957 = v956 and 0 or 1;
                    v12.list[v953].state = v65.lerp(v954.state, v957, v12.anim_speed);
                    v12.list[v953].offset = v65.lerp(v954.offset, l_l_base_offset_0_0, v12.anim_speed);
                    l_v947_0(v954.text, v12.list[v953].offset, v12.list[v953].state, v954.color);
                    if v954.state < 0.01 and v956 then
                        table.remove(v12.list, v953);
                    end;
                end;
                return;
            end;
        end;
    end;
    v11.register("render", "notifications", v12.handle);
    v947 = nil;
    v947 = {
        database = db.luasense_draggable3 or {}, 
        menu = {}, 
        items = {
            [1] = "slowed_down"
        }, 
        drag = {}, 
        current_drugging_item = nil, 
        hovered_something = false
    };
    local v958 = render.measure_text(1, nil, "Max velocity reduced by 100%").x + 3;
    local v959 = l_core_0.screen_size / 2;
    for _, v961 in pairs(v947.items) do
        if v947.database[v961 .. "_pos_x"] == nil then
            v947.database[v961 .. "_pos_x"] = l_core_0.screen_size.x / 2 - v958 / 2;
        end;
        if v947.database[v961 .. "_pos_y"] == nil then
            v947.database[v961 .. "_pos_y"] = l_core_0.screen_size.y / 4;
        end;
        v947.menu[v961] = {
            pos_x = v947.database[v961 .. "_pos_x"], 
            pos_y = v947.database[v961 .. "_pos_y"]
        };
    end;
    v947.adjust = function()
        -- upvalues: l_core_0 (ref), v947 (ref)
        local v962 = vector(2560, 1440);
        local _ = l_core_0.screen_size / v962;
        for _, v965 in pairs(v947.items) do
            v947.database[v965 .. "_pos_x"] = v947.database[v965 .. "_pos_x"];
            v947.database[v965 .. "_pos_x"] = v947.database[v965 .. "_pos_x"];
        end;
    end;
    v947.in_bounds = function(v966, v967)
        local v968 = ui.get_mouse_position();
        return v968.x >= v966.x and v968.x <= v967.x and v968.y >= v966.y and v968.y <= v967.y;
    end;
    v947.drag_handle = function(v969, v970, v971, v972)
        -- upvalues: v947 (ref), l_core_0 (ref), v19 (ref)
        if not v972 then
            v972 = 0;
        end;
        if v947.drag[v971] == nil then
            v947.drag[v971] = {
                is_dragging = false, 
                drag_position = vector(0, 0)
            };
        end;
        local v973 = ui.get_mouse_position();
        local v974 = vector();
        if v947.in_bounds(v969, v969 + v970) then
            v947.hovered_something = true;
            if common.is_button_down(1) and not v947.drag[v971].is_dragging and (v947.current_drugging_item == nil or v947.current_drugging_item == v971) then
                v947.drag[v971].is_dragging = true;
                v947.current_drugging_item = v971;
                v947.drag[v971].drag_position = v969 - v973;
            end;
        end;
        if not v947.in_bounds(v974, l_core_0.screen_size) then
            v947.drag[v971].is_dragging = false;
        end;
        if not common.is_button_down(1) then
            v947.drag[v971].is_dragging = false;
            v947.current_drugging_item = nil;
        end;
        if v947.drag[v971].is_dragging and v19.ui.getalpha() > 0 then
            local v975 = l_core_0.screen_size - v970;
            v947.database[v971 .. "_pos_x"] = math.clamp(v973.x + v947.drag[v971].drag_position.x, 0, v975.x);
            v947.database[v971 .. "_pos_y"] = math.clamp(v973.y + v947.drag[v971].drag_position.y, 0, v975.y);
        end;
        render.rect_outline(v969 - 6, v969 + v970 + 6, color(255, 255, 255, v19.ui.getalpha() * 150 * v972), 1, 4);
    end;
    v947.adjust();
    events.mouse_input:set(function()
        -- upvalues: v947 (ref), v19 (ref)
        if (v947.hovered_something or v947.current_drugging_item) and v19.ui.getalpha() > 0 then
            return false;
        else
            return;
        end;
    end);
    local v976 = {
        gradient = l_gradient_0.text_animate("S E N S E", -2, {
            color(255, 255, 255), 
            color(91, 91, 91)
        }), 
        desync = l_gradient_0.text_animate(".max", -1, {
            color(255, 255, 255), 
            color(255, 255, 255)
        }), 
        starting_padding = 15
    };
    v958 = l_core_0.screen_size / 2;
    v976.build_text = function(_, v978)
        -- upvalues: v976 (ref), v9 (ref), v32 (ref)
        v976.gradient:animate();
        local v979 = "\a" .. (v978 and v978 or v9.visuals.accent:get():to_hex()) .. "L U A " .. v976.gradient:get_animated_text();
        if v32 == "BETA" then
            v979 = v979 .. " \aEB6161FF[BETA]";
        end;
        return v979, (render.measure_text(1, "s", v979));
    end;
    v976.build_desync_max = function(_, v981)
        -- upvalues: v976 (ref), v9 (ref)
        v976.gradient:animate();
        local v982 = "\a" .. (v981 and v981 or v9.visuals.accent:get():to_hex()) .. "luasync" .. v976.desync:get_animated_text();
        return v982, (render.measure_text(1, "s", v982));
    end;
    do
        local l_v958_0, l_v959_0 = v958, v959;
        l_v959_0 = function(v985, v986)
            -- upvalues: l_v958_0 (ref), l_core_0 (ref), v976 (ref)
            local v987 = vector(0, 0);
            if v986 == "Bottom" then
                v987 = vector(l_v958_0.x - v985.x / 2, l_core_0.screen_center.y * 2 - v976.starting_padding);
            elseif v986 == "Left" then
                v987 = vector(v976.starting_padding, l_core_0.screen_center.y);
            elseif v986 == "Right" then
                v987 = vector(l_core_0.screen_size.x - v985.x - v976.starting_padding, l_core_0.screen_center.y);
            elseif v986 == "perm" then
                v987 = vector(l_v958_0.x - 20, l_core_0.screen_center.y - l_core_0.screen_center.y + 15);
            else
                v987 = vector(l_v958_0.x - v985.x / 2, l_core_0.screen_center.y * 2 - v976.starting_padding);
            end;
            return v987 + v985;
        end;
        v976.render = v54.safecall:execute("watermark_render", true, function()
            -- upvalues: v9 (ref), v976 (ref), l_v958_0 (ref), l_v959_0 (ref), l_core_0 (ref)
            if not globals.is_in_game then
                return;
            else
                local l_status_1, l_result_1 = pcall(function()
                    -- upvalues: v9 (ref), v976 (ref), l_v958_0 (ref), l_v959_0 (ref), l_core_0 (ref)
                    local v988 = v9.visuals.watermark:get();
                    local v989 = v9.visuals.watermark_style:get();
                    local v990 = nil;
                    local v991 = nil;
                    if v989 == 1 then
                        local v992, v993 = v976.build_text();
                        v991 = v993;
                        v990 = v992;
                        if not v990 or not v991 then
                            return;
                        end;
                    elseif v989 == 2 then
                        v990 = "LUASENSE";
                        v991 = render.measure_text(1, "s", v990 .. "  ");
                    elseif v989 == 3 then
                        local v994, v995 = v976.build_desync_max();
                        v991 = v995;
                        v990 = v994;
                        if not v990 or not v991 then
                            return;
                        end;
                    end;
                    if not l_v958_0 then
                        return;
                    else
                        local v996 = l_v959_0(v991, v988);
                        local _ = l_v959_0(v991, "perm");
                        if v989 == 1 then
                            render.text(1, v996 - v991, color(255), "s", v990);
                        elseif v989 == 2 then
                            render.text(1, v996 - v991, color(255), "s", l_core_0:with_icon("star", v990, v9.visuals.accent:get():to_hex()));
                        elseif v989 == 3 then
                            render.text(1, v996 - v991, color(255), "s", v990);
                        end;
                        return;
                    end;
                end);
                if not l_status_1 then
                    print("Rendering error:", l_result_1);
                end;
                return;
            end;
        end);
    end;
    v11.register("render", "watermark.render", v976.render);
    events.createmove(function(...)
        -- upvalues: l_core_0 (ref)
        local v1000 = entity.get_local_player();
        if v1000 == nil or not v1000:is_alive() then
            return;
        else
            l_core_0.antiaim(...);
            return;
        end;
    end);
    v958 = render.world_to_screen;
    v959 = render.rect;
    local l_screen_size_0 = render.screen_size;
    local _ = ui.find;
    local v1003 = 0.5;
    local v1004 = 1;
    local v1005 = {};
    local function v1014()
        -- upvalues: v9 (ref), v1005 (ref), v1003 (ref), v958 (ref), l_screen_size_0 (ref), v959 (ref)
        if not v9.visuals.kibit_hitmark:get() then
            return;
        else
            for v1006, v1007 in pairs(v1005) do
                if v1007.FadeTime <= 0 then
                    v1005[v1006] = nil;
                else
                    v1007.WaitTime = v1007.WaitTime - globals.frametime;
                    if v1007.WaitTime <= 0 then
                        v1007.FadeTime = v1007.FadeTime - 1 / v1003 * globals.frametime;
                    end;
                    if v1007.Position.x ~= nil and v1007.Position.y ~= nil and v1007.Position.z ~= nil then
                        local v1008 = v958(vector(v1007.Position.x, v1007.Position.y, v1007.Position.z));
                        if v1008 ~= nil then
                            local l_x_2 = v1008.x;
                            local l_y_1 = v1008.y;
                            local v1011 = l_screen_size_0();
                            local v1012 = v9.visuals.kibit_hitmark.kibit_hitmark_color:get();
                            local v1013 = v1012:override("a", v1012.a * v1007.FadeTime);
                            v959(vector(l_x_2 - 1 / v1011.x * v1011.x, l_y_1 - 5 / v1011.y * v1011.y), vector(l_x_2 + 1 / v1011.x * v1011.x, l_y_1 + 5 / v1011.y * v1011.y), v1013, 0, true);
                            v959(vector(l_x_2 - 5 / v1011.x * v1011.x, l_y_1 - 1 / v1011.y * v1011.y), vector(l_x_2 + 5 / v1011.x * v1011.x, l_y_1 + 1 / v1011.y * v1011.y), v1013, 0, true);
                        end;
                    end;
                end;
            end;
            return;
        end;
    end;
    v11.register("render", "paint_kibit", v1014);
    local function v1016(v1015)
        -- upvalues: v1005 (ref), v1004 (ref)
        v1005[v1015.id] = {
            FadeTime = 1, 
            Position = v1015.aim, 
            WaitTime = v1004, 
            Reason = v1015.state
        };
    end;
    local v1017 = {
        reason_redirect = {
            ["prediction error"] = "pred. error"
        }, 
        last_tick_triggered = 0
    };
    v1017.aim_ack = function(v1018)
        -- upvalues: v1016 (ref), v9 (ref), v1017 (ref), l_core_0 (ref), v12 (ref)
        v1016(v1018);
        if not v9.misc.log_event:get(1) and not v9.visuals.notifs:get() then
            return;
        else
            local l_target_0 = v1018.target;
            if l_target_0 == nil then
                return;
            else
                local v1020 = v1017.reason_redirect[v1018.state] or v1018.state;
                local v1021 = l_target_0:get_name();
                local l_m_iHealth_1 = l_target_0.m_iHealth;
                local l_spread_0 = v1018.spread;
                local l_backtrack_0 = v1018.backtrack;
                local l_hitchance_0 = v1018.hitchance;
                local l_damage_0 = v1018.damage;
                local l_wanted_damage_0 = v1018.wanted_damage;
                local v1028 = l_core_0.hitgroups[v1018.hitgroup] or "?";
                local v1029 = l_core_0.hitgroups[v1018.wanted_hitgroup] or "?";
                local v1030 = v9.visuals.accent:get():to_hex();
                if v1020 == nil then
                    local v1031 = string.format("\a%sRegistered \aDEFAULTshot at %s's %s for \a%s%d(%d) \aDEFAULTdamage (hp: \a%s%d\aDEFAULT) (aimed: \a%s%s\aDEFAULT) (bt: \a%s%s\aDEFAULT) (spread: \a%s%.1f\194\176\aDEFAULT)", v1030, v1021, v1028, v1030, l_damage_0, l_wanted_damage_0, v1030, l_m_iHealth_1, v1030, v1029, v1030, l_backtrack_0, v1030, l_spread_0);
                    l_core_0:branded_printing(v1031);
                    return;
                else
                    local v1032 = string.format("\a%sMissed \aDEFAULTshot at %s's %s due to \a%s%s \aDEFAULT(hc: \a%s%d%%\aDEFAULT) (damage: \a%s%d\aDEFAULT) (bt: \a%s%s\aDEFAULT)", v1030, v1021, v1029, v1030, v1020, v1030, l_hitchance_0, v1030, l_wanted_damage_0, v1030, l_backtrack_0);
                    local v1033 = string.format("\a%sMissed \aDEFAULTshot at \a%s%s\aDEFAULT's %s due to \a%s%s\aDEFAULT(%d%%) [damage: \a%s%d \aDEFAULT bt: \a%s%s\aDEFAULT", v1030, v1021, v1030, v1029, v1030, v1020, l_hitchance_0, v1030, l_wanted_damage_0, v1030, l_backtrack_0);
                    if l_spread_0 ~= nil then
                        v1032 = string.format("%s (spread: \a%s%.1f\194\176\aDEFAULT)", v1032, v1030, l_spread_0);
                    end;
                    l_core_0:branded_printing(v1032);
                    if v9.visuals.notifs:get() then
                        v1032 = v9.visuals.notifs.notifs_miss_clr:get();
                        v1033 = "\a" .. v1032:to_hex();
                        v12.push(string.format("Missed %s%s\aDEFAULT's %s%s\aDEFAULT due to %s%s\aDEFAULT!", v1033, v1021, v1033, v1029, v1033, v1020), v1032);
                    end;
                    return;
                end;
            end;
        end;
    end;
    v12.hurt = function(v1034)
        -- upvalues: v19 (ref), v9 (ref), v12 (ref)
        local v1035 = entity.get_local_player();
        local v1036 = v19.entity.get(v1034.userid, true);
        local v1037 = v19.entity.get(v1034.attacker, true);
        if v1035 == nil or v1036 == nil or v1037 == nil then
            return;
        elseif v1036 == v1035 or v1037 ~= v1035 then
            return;
        else
            local v1038 = v19.weapon_actions[v1034.weapon] or "Hit";
            local v1039 = v19.hitgroups[v1034.hitgroup] or "?";
            local v1040 = v9.visuals.notifs.notifs_hit_clr:get();
            local v1041 = v19.string_ops.to_hex(v1040);
            v12.push(v19.string.format("%s \a%s%s\aDEFAULT's \a%s%s \aDEFAULTfor \a%s%s\aDEFAULT!", v1038, v1041, v19.entity_methods.get_name(v1036), v1041, v1039, v1041, v1034.dmg_health), v1040);
            return;
        end;
    end;
    v1017.handle_hurt = function(v1042)
        -- upvalues: v19 (ref), l_core_0 (ref), v9 (ref)
        local v1043 = entity.get_local_player();
        local v1044 = v19.entity.get(v1042.userid, true);
        local v1045 = v19.entity.get(v1042.attacker, true);
        if v1043 == nil or v1044 == nil or v1045 == nil then
            return;
        elseif v1044 == v1043 or v1045 ~= v1043 then
            return;
        else
            local v1046 = l_core_0.wpn2act[v1042.weapon];
            if v1046 == nil then
                return;
            else
                local v1047 = v9.visuals.accent:get():to_hex();
                local v1048 = v19.entity_methods.get_name(v1044);
                local v1049 = v19.string.format("%s \a%s%s \aDEFAULTfor \a%s%d \aDEFAULTdamage (%d health remaining)", v1046, v1047, v1048:lower(), v1047, v1042.dmg_health, v1042.health);
                l_core_0:branded_printing(v1049);
                return;
            end;
        end;
    end;
    v1017.handle_purchase = function(v1050)
        -- upvalues: v9 (ref), v19 (ref), l_core_0 (ref)
        if not v9.misc.log_event:get(2) then
            return;
        else
            local v1051 = v19.entity.get(v1050.userid, true);
            if v1051 == nil or not v19.entity_methods.is_enemy(v1051) then
                return;
            else
                local l_weapon_0 = v1050.weapon;
                if l_weapon_0 == "weapon_unknown" then
                    return;
                else
                    local v1053 = v19.entity_methods.get_name(v1051);
                    local v1054 = v9.visuals.accent:get():to_hex();
                    local v1055 = v19.string.format("\a%s%s \aDEFAULTbought \a%s%s", v1054, v19.string.lower(v1053), v1054, l_weapon_0);
                    l_core_0:branded_printing(v1055);
                    return;
                end;
            end;
        end;
    end;
    v1017.player_hurt = function(v1056)
        -- upvalues: v9 (ref), v1017 (ref), v12 (ref)
        if v9.misc.log_event:get(1) then
            v1017.handle_hurt(v1056);
        end;
        if v9.visuals.notifs:get() then
            v12.hurt(v1056);
        end;
    end;
    v11.register("item_purchase", "hitlogs.handle_purchase", v1017.handle_purchase);
    l_core_0.slowdown_handle = v54.safecall:execute("slowed_down", true, function()
        -- upvalues: l_core_0 (ref), v9 (ref), v19 (ref), l_manager_0 (ref), v947 (ref)
        if not l_core_0.shared_data.able_to_render or not v9.visuals.slowed_down:get() then
            return;
        else
            local v1057 = entity.get_local_player();
            if v1057 == nil or not v1057:is_alive() then
                return;
            else
                local v1058 = v19.ui.getalpha();
                local v1059 = v1058 == 1 and 0.5 or v1057.m_flVelocityModifier;
                local v1060 = l_manager_0:new("velocity_modifier", v947.current_drugging_item == "slowed_down" and 100 or v1059 == 1 and 0 or 255);
                if v1060 < 0.03 then
                    return;
                else
                    local v1061 = vector(v947.database.slowed_down_pos_x, v947.database.slowed_down_pos_y);
                    local l_v1061_0 = v1061;
                    local v1063 = v9.visuals.accent:get():alpha_modulate(v1060);
                    local v1064 = "Max velocity reduced by";
                    local v1065 = v19.render.measure_text(1, nil, v1064 .. " 100%");
                    local v1066 = vector(v1065.x + 3, 6);
                    v19.render.text(1, v1061, v19.colors.white:alpha_modulate(v1060), nil, v19.string.format(v1064 .. " %d%%", v1059 * 100));
                    v1061 = v1061 + vector(0, 15);
                    local v1067 = {
                        [1] = v1061 - 1, 
                        [2] = v1061 + v1066 + 1
                    };
                    v19.render.rect(v1067[1], v1067[2], v19.colors.black:alpha_modulate(v19.math.min(200, v1060)), 2);
                    v19.render.shadow(v1067[1], v1067[2], v1063, 25, 0, 3);
                    v19.render.rect(v1061 + 1, v1061 + v1066 * vector(v1059, 1) - 1, v1063, 2);
                    v947.drag_handle(l_v1061_0, v1066 + vector(1, 15), "slowed_down", v1058);
                    return;
                end;
            end;
        end;
    end);
    v11.register("render", "ls_utils.slowdown_handle", l_core_0.slowdown_handle);
    v11.register("aim_ack", "hitlogs.aim_ack", v1017.aim_ack);
    v11.register("player_hurt", "hitlogs.player_hurt", v1017.player_hurt);
    v11.register("shutdown", "draggables_shut", function()
        -- upvalues: v947 (ref)
        db.luasense_draggable2 = v947.database;
    end);
    events.createmove:set(v54.safecall:execute("ls_utils.collect_render_shared_info", true, function()
        -- upvalues: v54 (ref)
        v54.shared:collect_render_info();
    end));
    events.createmove:set(v54.safecall:execute("ls_utils.collect", true, function()
        -- upvalues: v54 (ref)
        v54.shared:collect();
    end));
    events.round_end:set(function()
        -- upvalues: l_core_0 (ref)
        l_core_0.brute_modifier = 0;
        l_core_0.brute_modifier_ct = 0;
        l_core_0.active_brute = false;
        l_core_0.round_end = true;
    end);
    events.round_start:set(function()
        -- upvalues: l_core_0 (ref)
        l_core_0.round_end = false;
        l_core_0.freezetime = true;
    end);
    events.round_freeze_end:set(function()
        -- upvalues: l_core_0 (ref)
        l_core_0.freezetime = false;
    end);
    events.render:set(function()
        -- upvalues: v430 (ref), v435 (ref), v9 (ref), v436 (ref), v527 (ref), v19 (ref), l_core_0 (ref)
        v430.handle();
        v430.spectators();
        v435:visibility(v9.visuals.gs_inds:get());
        v436:visibility(v9.visuals.gs_inds:get());
        v527.draw();
        if v19.ui.getalpha() > 0 then
            v9.visibility_handler();
        end;
        l_core_0.handle_aspect();
    end);
    events.render:set(function()
        -- upvalues: v19 (ref), l_gradient_0 (ref), l_pui_0 (ref)
        if v19.ui.getalpha() > 0 then
            local v1068 = v19.ui.get_style("Link Active");
            local v1069 = l_gradient_0.text_animate("LuaSense", -1, {
                [1] = v1068, 
                [2] = v19.colors.white
            });
            l_pui_0.sidebar(v1069:get_animated_text(), "hand-sparkles");
            v1069:animate();
        end;
    end);
    events.bomb_defused:set(function(_)
        -- upvalues: v431 (ref)
        v431.reset_bomb();
    end);
    events.bomb_planted:set(function(_)
        -- upvalues: v431 (ref)
        v431.reset_bomb();
    end);
    events.bomb_abortplant:set(function(_)
        -- upvalues: v431 (ref)
        v431.reset_bomb();
    end);
    events.round_prestart:set(function(_)
        -- upvalues: v431 (ref)
        v431.reset_bomb();
    end);
    events.bomb_beginplant:set(function(v1074)
        -- upvalues: v431 (ref)
        v431.bomb_beginplant(v1074);
    end);
    l_core_0.clantag:run();
    l_pui_0.setup(v9);
    return;
end;