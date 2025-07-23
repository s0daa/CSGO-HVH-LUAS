-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local v0 = render.screen_size();
local _ = "\aFFFFFF00";
local l_defensive_0 = require("neverlose/get_defensive");
local l_clipboard_0 = require("neverlose/clipboard");
local l_base64_0 = require("neverlose/base64");
local l_pui_0 = require("neverlose/pui");
local v6 = {
    name = "Eternal", 
    build = "Alpha", 
    user = common.get_username(), 
    steam_name = panorama.MyPersonaAPI.GetName()
};
l_pui_0.colors.accent = color();
local v7 = {
    active_text = ui.get_style("Active Text"), 
    link_active = ui.get_style("Link Active"), 
    shadow = ui.get_style("Shadows"), 
    window_title = ui.get_style("Window Title")
};
events.render(function()
    -- upvalues: v7 (ref)
    v7.active_text = ui.get_style("Active Text");
    v7.link_active = ui.get_style("Link Active");
    v7.shadow = ui.get_style("Shadows");
    v7.window_title = ui.get_style("Window Title");
end);
ffi.bind_argument = function(v8, v9)
    return function(...)
        -- upvalues: v8 (ref), v9 (ref)
        return v8(v9, ...);
    end;
end;
local v10 = {
    name = ("%s::data"):format(v6.name:lower())
};
local v11 = db[v10.name] or {};
v10.read = function(v12)
    -- upvalues: v11 (ref)
    return v11[v12];
end;
v10.write = function(v13, v14)
    -- upvalues: v11 (ref)
    v11[v13] = v14;
end;
v10.loaded = function()
    -- upvalues: v11 (ref), v10 (ref)
    return v11 == db[v10.name];
end;
ffi.cdef("    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);\n    bool DeleteUrlCacheEntryA(const char* lpszUrlName);\n");
files.download = (function()
    local v15 = ffi.load("UrlMon");
    local v16 = ffi.load("WinInet");
    return function(v17, v18)
        -- upvalues: v16 (ref), v15 (ref)
        v16.DeleteUrlCacheEntryA(v17);
        v15.URLDownloadToFileA(nil, v17, v18, 0, 0);
    end;
end)();
local v19 = {
    dormant = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
    quick_peek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"), 
    quick_peek_mode = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Retreat Mode"), 
    hit_chance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"), 
    min_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
    prefer_body = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
    prefer_safety = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"), 
    doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
    doubletap_config = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
    doubletap_fakelag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"), 
    hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
    hideshots_config = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
    delay_shot = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage", "Delay Shot"), 
    slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
    fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
    yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
    yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
    yaw_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"), 
    hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
    modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
    modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"), 
    body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
    left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
    right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
    body_yaw_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
    body_yaw_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"), 
    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
    disable_yaw_modif = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"), 
    body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"), 
    fakelag = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
    fakelag_limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"), 
    fakelag_variability = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability"), 
    legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"), 
    weapon_chams = ui.find("Visuals", "Players", "Self", "Chams", "Weapon"), 
    weapon_style = ui.find("Visuals", "Players", "Self", "Chams", "Weapon", "Style"), 
    scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"), 
    post_processing = ui.find("Visuals", "World", "Ambient", "Post Processing"), 
    windows = ui.find("Miscellaneous", "Main", "Other", "Windows"), 
    fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"), 
    weapon_actions = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions")
};
local v20 = {
    items = {}
};
for v21, v22 in pairs(v19) do
    v20.items[v21] = {
        tick = -1, 
        var = v22
    };
end;
v20.setup = function(v23, v24)
    -- upvalues: v20 (ref)
    local v25 = v20.items[v23];
    if v25 == nil then
        return;
    else
        v25.var:override(v24);
        v25.tick = globals.tickcount;
        return v25.var;
    end;
end;
v20.deoverride = function(v26)
    -- upvalues: v20 (ref)
    local l_tickcount_0 = globals.tickcount;
    for _, v29 in pairs(v20.items) do
        if v26 or math.abs(v29.tick - l_tickcount_0) > 5 then
            v29.var:override();
        end;
    end;
end;
events.render(v20.deoverride);
events.shutdown(function()
    -- upvalues: v20 (ref)
    v20.deoverride(true);
end);
local v30 = {
    scoped = false, 
    side = 0, 
    movetype = -1, 
    state = -1, 
    velocity = -1, 
    valid = false, 
    entity = entity.get_local_player(), 
    exploit = rage.exploit:get(), 
    weapon = {
        m_flNextPrimaryAttack = -1, 
        m_bPinPulled = false, 
        weapon_spread = -1, 
        weapon_inaccuracy = -1, 
        is_revolver = false, 
        weapon_type = -1, 
        weapon_index = -1, 
        weapon_classname = "_unk", 
        m_flNextSecondaryAttack = -1
    }, 
    origin = vector(), 
    states = {
        manual_yaw = 10, 
        air_crouch = 8, 
        air = 7, 
        sneaking = 6, 
        crouching = 5, 
        walking = 4, 
        standing = 2, 
        unknown = -1, 
        freestanding = 9, 
        running = 3, 
        planting = 11
    }
};
events.render(function()
    -- upvalues: v30 (ref)
    v30.entity = entity.get_local_player();
    v30.valid = v30.entity and v30.entity:is_alive();
end);
events.createmove_run(function(v31)
    -- upvalues: v30 (ref)
    v30.entity = entity.get_local_player();
    v30.exploit = rage.exploit:get();
    v30.valid = v30.entity and v30.entity:is_alive();
    if v30.valid then
        local v32 = v30.entity:get_player_weapon();
        if v32 then
            local v33 = v32:get_weapon_info();
            v30.weapon.weapon_info = v33;
            v30.weapon.weapon_classname = v32:get_classname();
            v30.weapon.weapon_index = v32:get_weapon_index();
            v30.weapon.weapon_type = v33.weapon_type;
            v30.weapon.is_revolver = v33.is_revolver;
            v30.weapon.weapon_inaccuracy = v32:get_inaccuracy();
            v30.weapon.weapon_spread = v32:get_spread();
            v30.weapon.m_bPinPulled = v32.m_bPinPulled;
            v30.weapon.m_flNextPrimaryAttack = v32.m_flNextPrimaryAttack;
            v30.weapon.m_flNextSecondaryAttack = v32.m_flNextSecondaryAttack;
        end;
        v30.velocity = v30.entity.m_vecVelocity:length();
        v30.origin = v30.entity:get_origin();
        v30.scoped = v30.entity.m_bIsScoped;
        v30.movetype = v30.entity.m_MoveType;
        if v30.side == 0 then
            v30.side = v31.sidemove > 0 and -1 or v31.sidemove < 0 and 1 or 0;
        end;
        if not v30.scoped then
            v30.side = 0;
        end;
    end;
end);
events.createmove(function(v34)
    -- upvalues: v30 (ref), v19 (ref)
    if not v30.valid then
        return;
    else
        local l_m_fFlags_0 = v30.entity.m_fFlags;
        local v36 = bit.band(l_m_fFlags_0, bit.lshift(1, 0)) == 1;
        local v37 = v30.velocity < 6;
        local v38 = v19.slow_walk:get();
        local v39 = v30.entity.m_flDuckAmount > 0.3 or v19.fake_duck:get();
        local v40 = not v36 or v34.in_jump;
        if v39 and v40 then
            v30.state = v30.states.air_crouch;
            return;
        elseif v40 then
            v30.state = v30.states.air;
            return;
        elseif v38 then
            v30.state = v30.states.walking;
            return;
        elseif not v39 and v37 then
            v30.state = v30.states.standing;
            return;
        elseif v39 and not v37 then
            v30.state = v30.states.sneaking;
            return;
        elseif v39 and v37 then
            v30.state = v30.states.crouching;
            return;
        elseif not v39 and not v37 and not v38 then
            v30.state = v30.states.running;
            return;
        else
            v30.state = v30.states.unknown;
            return;
        end;
    end;
end);
common.get_ping = function()
    local v41 = utils.net_channel();
    if v41 == nil then
        return 0;
    else
        return math.floor(v41.avg_latency[1] * 1000);
    end;
end;
local v48 = {
    get = function(v42)
        local v43 = {};
        local v44 = false;
        for _, v46 in pairs(ui.get_binds()) do
            table.insert(v43, v46);
            if v42 and v46.active and v46.reference:id() == v42:id() then
                v44 = true;
            end;
        end;
        local v47;
        if not v42 or not v44 then
            v47 = v42 == nil and v43;
        else
            v47 = v44;
        end;
        return v47;
    end
};
local v55 = {
    _list = {}, 
    lerp = function(v49, v50, v51)
        if not v51 then
            v51 = 0.095;
        end;
        if math.abs(v49 - v50) < 1 then
            return v50;
        else
            v51 = math.clamp(globals.frametime * v51 * 170, 0.01, 1);
            return v49 + (v50 - v49) * v51;
        end;
    end, 
    color_lerp = function(v52, v53, v54)
        if not v54 then
            v54 = 0.095;
        end;
        return v52:lerp(v53, (math.clamp(globals.frametime * v54 * 170, 0.01, 1)));
    end
};
v55.new = function(v56, v57, v58)
    -- upvalues: v55 (ref)
    if not v58 then
        v58 = 0.095;
    end;
    local v59 = type(v57) == "userdata";
    if v55._list[v56] == nil then
        v55._list[v56] = v57;
    end;
    local v60 = nil;
    if v59 then
        v60 = v55.color_lerp;
    else
        v60 = v55.lerp;
    end;
    v55._list[v56] = v60(v55._list[v56], v57, v58);
    return v55._list[v56];
end;
string.gradient = function(v61, v62, v63, v64)
    local v65 = {};
    local v66 = v63.r - v62.r;
    local v67 = v63.g - v62.g;
    local v68 = v63.b - v62.b;
    local v69 = v63.a - v62.a;
    local v70 = color();
    for v71 = 1, #v61 do
        local v72 = math.abs(math.cos((v71 - 1) / (#v61 - 1) + v64));
        v70.r = v62.r + v66 * v72;
        v70.g = v62.g + v67 * v72;
        v70.b = v62.b + v68 * v72;
        v70.a = v62.a + v69 * v72;
        local v73 = "\a" .. v70:to_hex();
        v65[#v65 + 1] = v73;
        v65[#v65 + 1] = v61:sub(v71, v71);
    end;
    return table.concat(v65);
end;
string.matrix = function(v74, v75, v76, _)
    v75 = v75:clone();
    v76 = v76:clone();
    local v78 = "abcdefghijklmnopqrstuvwxyz0123456789@#$&*+-/=?_";
    local _ = "";
    local v80 = {};
    local function v91(v81, v82, v83)
        local v84 = "";
        local v85 = #v81 - 1;
        local v86 = (v83.r - v82.r) / v85;
        local v87 = (v83.g - v82.g) / v85;
        local v88 = (v83.b - v82.b) / v85;
        local v89 = (v83.a - v82.a) / v85;
        for v90 = 1, v85 + 1 do
            v84 = v84 .. "\a" .. v82:to_hex() .. v81:sub(v90, v90);
            v82.r = v82.r + v86;
            v82.g = v82.g + v87;
            v82.b = v82.b + v88;
            v82.a = v82.a + v89;
        end;
        return v84;
    end;
    local function v93()
        -- upvalues: v78 (ref), v80 (ref)
        local v92 = nil;
        repeat
            v92 = math.random(1, #v78);
        until not v80[v92];
        v80[v92] = true;
        return v78:sub(v92, v92);
    end;
    local v94 = math.abs(globals.realtime * 0.4 % 2 - 1) * (#v74 + 1);
    v94 = math.max(0, math.min(v94, #v74));
    local v95 = "";
    for _ = 1, #v74 do
        v95 = v95 .. v93();
    end;
    return v74:sub(1, v94) .. v91(v95.sub(v95, v94 + 1), v75, v76);
end;
local _ = nil;
local function v100()
    -- upvalues: v7 (ref), l_pui_0 (ref)
    local v98 = v7.link_active:clone();
    local v99 = string.gradient("Eternal.Codes", v98:alpha_modulate(50), v98, globals.realtime);
    l_pui_0.sidebar(v99, "hourglass-half");
end;
events.render(v100);
v100 = {
    refs = {}, 
    depends = {}, 
    elements = {}
};
v100.global_update_callback = function()
    -- upvalues: v100 (ref)
    for v101, v102 in pairs(v100.refs) do
        for v103, v104 in pairs(v102) do
            if v100.depends[v101] and v100.depends[v101][v103] then
                v104:visibility(v100.depends[v101][v103]());
            end;
        end;
    end;
end;
v100.new = function(v105, v106, v107, v108)
    -- upvalues: v100 (ref)
    if v100.refs[v105] == nil then
        v100.refs[v105] = {};
        v100.elements[v105] = {};
    end;
    if v100.elements[v105][v106] ~= nil then
        error(("Element already exists: [%s][%s]"):format(v105, v106));
    end;
    v100.refs[v105][v106] = v107;
    local function v113()
        -- upvalues: v107 (ref), v100 (ref), v105 (ref), v106 (ref)
        if v107:type() == "selectable" or v107:type() == "listable" then
            local l_value_0 = v107.value;
            local v110 = {};
            for _, v112 in pairs(l_value_0) do
                v110[v112] = true;
            end;
            v100.elements[v105][v106] = v110;
        else
            v100.elements[v105][v106] = v107.value;
        end;
    end;
    v113();
    if v108 ~= nil then
        if type(v108) == "function" then
            if v100.depends[v105] == nil then
                v100.depends[v105] = {};
            end;
            v100.depends[v105][v106] = v108;
        else
            v107:depend(v108);
        end;
    end;
    v100.global_update_callback();
    v107:set_callback(v113);
    v107:set_callback(v100.global_update_callback);
    return v107;
end;
local v122 = {
    __index = function(_, v115, _)
        -- upvalues: v100 (ref)
        return function(...)
            -- upvalues: v115 (ref), v100 (ref)
            local v117 = ...;
            return function(...)
                -- upvalues: v117 (ref), v115 (ref), v100 (ref)
                local v118 = v117[v115](v117, ...);
                return function(v119, v120, ...)
                    -- upvalues: v100 (ref), v118 (ref)
                    v100.new(v119, v120, v118, ...);
                    return function(v121)
                        -- upvalues: v118 (ref)
                        if v121 ~= nil then
                            v121(v118:create(), v118);
                        end;
                        return v118;
                    end;
                end;
            end;
        end;
    end
};
v100 = setmetatable(v100, v122);
v122 = {
    home = l_pui_0.create("\f<house>", {
        [1] = {
            [1] = "information", 
            [2] = "##information", 
            [3] = 1
        }, 
        [2] = {
            [1] = "tab_selector", 
            [2] = "##tab_selector", 
            [3] = 1
        }, 
        [3] = {
            [1] = "dashboard", 
            [2] = "##dashboard", 
            [3] = 2
        }, 
        [4] = {
            [1] = "social_media", 
            [2] = "##social_media", 
            [3] = 2
        }, 
        [5] = {
            [1] = "configs_main", 
            [2] = "##configs_main", 
            [3] = 2
        }, 
        [6] = {
            [1] = "configs_create", 
            [2] = "##configs_create", 
            [3] = 2
        }
    }), 
    antiaim = l_pui_0.create("\f<shield>", {
        [1] = {
            [1] = "tab_selector", 
            [2] = "##tab_selector", 
            [3] = 1
        }, 
        [2] = {
            [1] = "settings", 
            [2] = "##settings", 
            [3] = 2
        }, 
        [3] = {
            [1] = "binds", 
            [2] = "##binds", 
            [3] = 1
        }, 
        [4] = {
            [1] = "states", 
            [2] = "##states", 
            [3] = 1
        }, 
        [5] = {
            [1] = "builder", 
            [2] = "##builder", 
            [3] = 2
        }, 
        [6] = {
            [1] = "defensive", 
            [2] = "##defensive", 
            [3] = 2
        }, 
        [7] = {
            [1] = "team", 
            [2] = "##team", 
            [3] = 2
        }
    }), 
    visuals = l_pui_0.create("\f<gears>", {
        [1] = {
            [1] = "drag", 
            [2] = "##drag", 
            [3] = 1
        }, 
        [2] = {
            [1] = "tab_selector", 
            [2] = "##tab_selector", 
            [3] = 1
        }, 
        [3] = {
            [1] = "ragebot", 
            [2] = "##ragebot", 
            [3] = 2
        }, 
        [4] = {
            [1] = "rage_other", 
            [2] = "##rage_other", 
            [3] = 1
        }, 
        [5] = {
            [1] = "aimbot", 
            [2] = "##aimbot", 
            [3] = 2
        }, 
        [6] = {
            [1] = "indicators", 
            [2] = "##indicators", 
            [3] = 2
        }, 
        [7] = {
            [1] = "visuals", 
            [2] = "##visuals", 
            [3] = 1
        }, 
        [8] = {
            [1] = "style", 
            [2] = "##style", 
            [3] = 2
        }, 
        [9] = {
            [1] = "widgets", 
            [2] = "##widgets", 
            [3] = 2
        }, 
        [10] = {
            [1] = "movement", 
            [2] = "##movement", 
            [3] = 2
        }, 
        [11] = {
            [1] = "misc", 
            [2] = "##misc", 
            [3] = 1
        }, 
        [12] = {
            [1] = "shared", 
            [2] = "##shared", 
            [3] = 2
        }
    })
};
v100.label(v122.home.information)("\226\128\138\v\f<circle-user>\r  User")("home", "user_label");
v100.button(v122.home.information)((" %s "):format(v6.user), nil, true)("home", "user_button");
v100.label(v122.home.information)(" \v\f<code-branch>\r  Build")("home", "version_label");
v100.button(v122.home.information)((" %s "):format(v6.build), nil, true)("home", "version_button");
v100.list(v122.home.tab_selector)("", {
    [1] = "\v\f<chart-line>\r      Dashboard", 
    [2] = "\v\f<link>\r    \226\128\138Links", 
    [3] = "\v\f<folders>\r    Configs"
})("home", "tab_selector");
local v123 = {
    hovered_something = false, 
    data = {}, 
    items = {}, 
    sliders = {}, 
    ui_alpha = 0
};
events.render(function()
    -- upvalues: v123 (ref)
    v123.ui_alpha = ui.get_alpha();
end);
v123.intersects = function(_, v125, v126, v127)
    return v125.x >= v126.x and v125.x <= v126.x + v127.x and v125.y >= v126.y and v125.y <= v126.y + v127.y;
end;
v123.background = function(v128)
    -- upvalues: v55 (ref), v0 (ref)
    local v129 = v55.new("drag::background", v128.hovered_something and 125 or 0);
    if v129 > 0 then
        render.rect(vector(0, 0), v0, color(0, v128.ui_alpha * v129), 0);
    end;
end;
events.render(function()
    -- upvalues: v123 (ref)
    v123:background();
end);
v123.create_sliders = function(v130, v131)
    -- upvalues: v100 (ref), v122 (ref), v0 (ref)
    v130.sliders[v131.id] = {
        x = v100.slider(v122.visuals.drag)("slider::x::" .. v131.id, 0, v0.x, v131.default.x)("visuals", "drag_x_" .. v131.id)(), 
        y = v100.slider(v122.visuals.drag)("slider::y::" .. v131.id, 0, v0.y, v131.default.y)("visuals", "drag_y_" .. v131.id)()
    };
    v130.sliders[v131.id].x:visibility(false);
    v130.sliders[v131.id].y:visibility(false);
end;
v123.process = function(v132, v133)
    -- upvalues: v0 (ref), v123 (ref), v55 (ref)
    local v134 = vector(v132.sliders[v133.id].x:get(), v132.sliders[v133.id].y:get());
    local v135 = ui.get_mouse_position();
    local v136 = common.is_button_down(1);
    if v132.items[v133.id] == nil then
        v132.items[v133.id] = {
            is_hovered = false, 
            enabled = false, 
            position = vector(0, 0)
        };
    end;
    if v132.data[v133.id].enabled then
        local v137 = v132:intersects(v135, v134, v132.data[v133.id].size);
        local v138 = v132:intersects(v135, vector(0, 0), v0);
        if v137 and v138 and not v132.hovered_something then
            v132.hovered_something = true;
            if v136 and not v132.items[v133.id].is_hovered then
                v132.items[v133.id].position = v134 - v135;
                v132.items[v133.id].is_hovered = true;
            end;
        end;
        if not v138 then
            v132.items[v133.id].is_hovered = false;
        end;
        if not v136 then
            v132.items[v133.id].is_hovered = false;
            v132.hovered_something = false;
        end;
    end;
    if v123.ui_alpha > 0 then
        local v139 = v135 + v132.items[v133.id].position;
        if v133.settings.border then
            v139.x = math.clamp(v139.x, v133.settings.border[1].x - v132.data[v133.id].size.x * 0.5, v133.settings.border[2].x - v132.data[v133.id].size.x * 0.5);
            v139.y = math.clamp(v139.y, v133.settings.border[1].y - v132.data[v133.id].size.y * 0.5, v133.settings.border[2].y - v132.data[v133.id].size.y * 0.5);
            local v140 = v55.new(("drag::border::%s"):format(v133.id), v132.data[v133.id].enabled and v132.items[v133.id].is_hovered and 50 or 0);
            if v140 > 0 then
                if v133.settings.border[1].x == v133.settings.border[2].x or v133.settings.border[1].y == v133.settings.border[2].y then
                    render.line(v133.settings.border[1], v133.settings.border[2], color(255, v140 * v123.ui_alpha), 1);
                else
                    render.rect_outline(v133.settings.border[1], v133.settings.border[2], color(255, v140 * v123.ui_alpha), 1, 4);
                end;
            end;
        end;
        if v133.settings.rulers then
            for v141, v142 in pairs(v133.settings.rulers) do
                local v143 = math.abs(v142[1] == "x" and v142[2] - v139.x - v132.data[v133.id].size.x * 0.5 or v142[2] - v139.y - v132.data[v133.id].size.y * 0.5) < 10;
                if v143 then
                    if v142[1] == "x" then
                        v139.x = v142[2] - v132.data[v133.id].size.x * 0.5;
                    else
                        v139.y = v142[2] - v132.data[v133.id].size.y * 0.5;
                    end;
                end;
                local l_new_0 = v55.new;
                local v145 = ("drag::rulers::%s::%s"):format(v133.id, v141);
                local v146;
                if v132.data[v133.id].enabled and v132.items[v133.id].is_hovered then
                    v146 = v143 and 125 or 50;
                else
                    v146 = 0;
                end;
                l_new_0 = l_new_0(v145, v146);
                if l_new_0 > 0 then
                    if v142[1] == "x" then
                        render.line(vector(v142[2], 0), vector(v142[2], v0.y), color(255, l_new_0 * v123.ui_alpha), 1);
                    end;
                    if v142[1] == "y" then
                        render.line(vector(0, v142[2]), vector(v0.x, v142[2]), color(255, l_new_0 * v123.ui_alpha), 1);
                    end;
                end;
            end;
        end;
        v139.x = math.clamp(v139.x, 0, v0.x - v132.data[v133.id].size.x);
        v139.y = math.clamp(v139.y, 0, v0.y - v132.data[v133.id].size.y);
        if v132.items[v133.id].is_hovered then
            v132.sliders[v133.id].x:set(v139.x);
            v132.sliders[v133.id].y:set(v139.y);
        end;
    end;
    local l_new_1 = v55.new;
    local v148 = ("drag::box::%s"):format(v133.id);
    local v149;
    if v132.data[v133.id].enabled then
        v149 = v132.items[v133.id].is_hovered and 50 or 25;
    else
        v149 = 0;
    end;
    l_new_1 = l_new_1(v148, v149);
    render.rect(v134, v134 + v132.data[v133.id].size, color(255, l_new_1 * v123.ui_alpha), 4);
    render.rect_outline(v134, v134 + v132.data[v133.id].size, color(255, l_new_1 * v123.ui_alpha), 1, 4);
end;
v123.new = function(v150, v151, v152, v153, v154)
    v150:create_sliders({
        id = v151, 
        default = v152
    });
    v150.data[v151] = {
        enabled = false, 
        id = v151, 
        position = vector(v150.sliders[v151].x:get(), v150.sliders[v151].y:get()), 
        default = v152, 
        size = v153, 
        settings = v154 or {}
    };
    return function(v155)
        -- upvalues: v150 (ref), v151 (ref)
        return function()
            -- upvalues: v150 (ref), v151 (ref), v155 (ref)
            v150.data[v151].position = vector(v150.sliders[v151].x:get(), v150.sliders[v151].y:get());
            v150:process(v150.data[v151]);
            v155(v150.data[v151]);
        end;
    end;
end;
events.mouse_input(function()
    if ui.get_alpha() > 0 then
        return false;
    else
        return;
    end;
end);
local v156 = v10.read("rpg") or {
    points = 1000, 
    level = 1
};
v100.label(v122.home.dashboard)(" \v\f<ranking-star>\r  Level")("home", "dashboard_level_label", {
    [1] = nil, 
    [2] = 1, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.dashboard)(string.format("  %i  ", v156.level), nil, true)("home", "dashboard_level_button", {
    [1] = nil, 
    [2] = 1, 
    [1] = v100.refs.home.tab_selector
});
v100.label(v122.home.dashboard)(" \v\f<bars-progress>\r  Points")("home", "dashboard_points_label", {
    [1] = nil, 
    [2] = 1, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.dashboard)("  " .. v156.points .. "  ", nil, true)("home", "dashboard_points_button", {
    [1] = nil, 
    [2] = 1, 
    [1] = v100.refs.home.tab_selector
});
v100.label(v122.home.dashboard)(" \v\f<stairs>\r  Required Points")("home", "dashboard_req_points_label", {
    [1] = nil, 
    [2] = 1, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.dashboard)("  " .. 1000 - (v156.points - math.floor(v156.level) * 1000) .. "  ", nil, true)("home", "dashboard_req_points_button", {
    [1] = nil, 
    [2] = 1, 
    [1] = v100.refs.home.tab_selector
});
v100.label(v122.home.social_media)("Website")("home", "website_label", {
    [1] = nil, 
    [2] = 2, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.social_media)("  \f<hourglass>  ", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://eternal.codes/");
end, true)("home", "website_button", {
    [1] = nil, 
    [2] = 2, 
    [1] = v100.refs.home.tab_selector
});
v100.label(v122.home.social_media)("Discord")("home", "discord_label", {
    [1] = nil, 
    [2] = 2, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.social_media)(" \f<discord>\226\128\175", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/eternalcodes");
end, true)("home", "discord_button", {
    [1] = nil, 
    [2] = 2, 
    [1] = v100.refs.home.tab_selector
})():tooltip("Please follow the instructions in the \v#verify\r channel to get roles that grant access to \vconfigs\r, \vupdates\r, and \vnews\r about the Lua.");
v100.label(v122.home.social_media)("YouTube")("home", "youtube_label", {
    [1] = nil, 
    [2] = 2, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.social_media)(" \f<youtube> ", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@canhvh");
end, true)("home", "youtube_button", {
    [1] = nil, 
    [2] = 2, 
    [1] = v100.refs.home.tab_selector
});
v100.label(v122.home.social_media)("NL Config")("home", "config_label", {
    [1] = nil, 
    [2] = 2, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.social_media)(" Live ", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://market.neverlose.cc/item?id=SopdZQ");
end, true)("home", "config_live_button", {
    [1] = nil, 
    [2] = 2, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.social_media)(" Beta ", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://market.neverlose.cc/item?id=cDsoXH");
end, true)("home", "config_beta_button", {
    [1] = nil, 
    [2] = 2, 
    [1] = v100.refs.home.tab_selector
});
v100.label(v122.home.social_media)("Other Builds")("home", "lua_label", {
    [1] = nil, 
    [2] = 2, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.social_media)(" Live ", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=0OcOn0");
end, true)("home", "live_button", {
    [1] = nil, 
    [2] = 2, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.social_media)(" Beta ", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=Fy3hnS");
end, true)("home", "beta_button", {
    [1] = nil, 
    [2] = 2, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.social_media)(" Alpha ", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=wTRYqG");
end, true)("home", "alpha_button", {
    [1] = nil, 
    [2] = 2, 
    [1] = v100.refs.home.tab_selector
});
local v157 = {
    maximum_count = 10, 
    db = v10.read("configs") or {}, 
    data = {}
};
v157.db[1] = {
    name = "NIL", 
    author = "ERROR", 
    data = {}
};
v157.db[2] = {
    name = "NIL", 
    author = "ERROR", 
    data = {}
};
local v158 = network.get("https://eternal.codes/download/nl_cloud_config.txt");
local v159 = network.get("https://eternal.codes/download/nl_cloud_config_defensive.txt");
do
    local l_v158_0, l_v159_0 = v158, v159;
    local _ = (function()
        -- upvalues: l_v158_0 (ref), l_base64_0 (ref), v157 (ref)
        local l_status_0, l_result_0 = pcall(function()
            -- upvalues: l_v158_0 (ref)
            return l_v158_0:gsub("eternal::", ""):gsub("_", "="):gsub("Z1337Z", "+");
        end);
        data = l_result_0;
        success = l_status_0;
        if not success then
            return;
        else
            l_status_0, l_result_0 = pcall(l_base64_0.decode, data);
            data = l_result_0;
            success = l_status_0;
            if not success then
                return;
            else
                l_status_0, l_result_0 = pcall(json.parse, data);
                data = l_result_0;
                success = l_status_0;
                if not success then
                    return;
                else
                    v157.db[1] = {
                        name = "Jitter", 
                        author = "c\195\162n", 
                        data = data.data
                    };
                    return;
                end;
            end;
        end;
    end)();
    local _ = (function()
        -- upvalues: l_v159_0 (ref), l_base64_0 (ref), v157 (ref)
        local l_status_1, l_result_1 = pcall(function()
            -- upvalues: l_v159_0 (ref)
            return l_v159_0:gsub("eternal::", ""):gsub("_", "="):gsub("Z1337Z", "+");
        end);
        data = l_result_1;
        success = l_status_1;
        if not success then
            return;
        else
            l_status_1, l_result_1 = pcall(l_base64_0.decode, data);
            data = l_result_1;
            success = l_status_1;
            if not success then
                return;
            else
                l_status_1, l_result_1 = pcall(json.parse, data);
                data = l_result_1;
                success = l_status_1;
                if not success then
                    return;
                else
                    v157.db[2] = {
                        name = "Defensive", 
                        author = "c\195\162n", 
                        data = data.data
                    };
                    return;
                end;
            end;
        end;
    end)();
end;
v157.compile = function(v168)
    -- upvalues: v6 (ref), l_base64_0 (ref)
    if v168 == nil then
        common.add_notify(v6.name, "An error occured with config!");
        cvar.play:call("resource\\warning.wav");
        return;
    else
        local l_status_2, l_result_2 = pcall(function()
            -- upvalues: l_base64_0 (ref), v168 (ref)
            return l_base64_0.encode(json.stringify(v168));
        end);
        v168 = l_result_2;
        success = l_status_2;
        if not success then
            common.add_notify(v6.name, "An error occured with config!");
            cvar.play:call("resource\\warning.wav");
            return;
        else
            return ("eternal::%s"):format(v168:gsub("=", "_"):gsub("+", "Z1337Z"));
        end;
    end;
end;
v157.decompile = function(v171)
    -- upvalues: v6 (ref), l_base64_0 (ref)
    if v171 == nil then
        common.add_notify(v6.name, "An error occured with config!");
        cvar.play:call("resource\\warning.wav");
        return;
    elseif not v171:find("eternal::") then
        common.add_notify(v6.name, "An error occured with config!");
        cvar.play:call("resource\\warning.wav");
        return;
    else
        v171 = v171:gsub("eternal::", ""):gsub("_", "="):gsub("Z1337Z", "+");
        local l_status_3, l_result_3 = pcall(function()
            -- upvalues: l_base64_0 (ref), v171 (ref)
            return json.parse(l_base64_0.decode(v171));
        end);
        v171 = l_result_3;
        success = l_status_3;
        if not success then
            common.add_notify(v6.name, "An error occured with config!");
            cvar.play:call("resource\\warning.wav");
            return;
        else
            return v171;
        end;
    end;
end;
v157.load = function(v174, v175)
    -- upvalues: v157 (ref), v6 (ref)
    if v157.db[v174].data == nil or v157.db[v174].data == "" then
        common.add_notify(v6.name, "An error occured with database!");
        cvar.play:call("resource\\warning.wav");
        return;
    elseif #v157.db < v174 then
        common.add_notify(v6.name, "An error occured with database!");
        cvar.play:call("resource\\warning.wav");
        return;
    else
        local l_name_0 = v157.db[v174].name;
        local l_data_0 = v157.db[v174].data;
        v157.data:load(l_data_0, v175);
        common.add_notify(v6.name, ("%s successfully loaded!"):format(l_name_0));
        cvar.play:call("ui\\beepclear");
        return;
    end;
end;
v157.save = function(v178)
    -- upvalues: v157 (ref), v6 (ref), v10 (ref)
    local v179 = v157.data:save();
    local l_name_1 = v157.db[v178].name;
    if v178 <= 2 then
        common.add_notify(v6.name, ("You can't save %s!"):format(l_name_1));
        cvar.play:call("resource\\warning.wav");
        return;
    else
        v157.db[v178].data = v179;
        v10.write("configs", v157.db);
        common.add_notify(v6.name, ("%s successfully saved!"):format(l_name_1));
        cvar.play:call("ui\\beepclear");
        return;
    end;
end;
v157.export = function(v181)
    -- upvalues: v157 (ref), v6 (ref), l_clipboard_0 (ref)
    local v182 = v157.db[v181];
    local l_name_2 = v182.name;
    local v184 = v157.compile(v182);
    if v181 <= 2 then
        common.add_notify(v6.name, ("You can't export %s!"):format(l_name_2));
        cvar.play:call("resource\\warning.wav");
        return;
    else
        l_clipboard_0.set(v184);
        common.add_notify(v6.name, ("%s successfully exported!"):format(l_name_2));
        cvar.play:call("ui\\beepclear");
        return;
    end;
end;
v157.remove = function(v185)
    -- upvalues: v157 (ref), v6 (ref), v10 (ref)
    local l_name_3 = v157.db[v185].name;
    if v185 <= 2 then
        common.add_notify(v6.name, ("You can't remove %s!"):format(l_name_3));
        cvar.play:call("resource\\warning.wav");
        return;
    else
        table.remove(v157.db, v185);
        v10.write("configs", v157.db);
        common.add_notify(v6.name, ("%s successfully removed!"):format(l_name_3));
        cvar.play:call("ui\\beepclear");
        return;
    end;
end;
v157.create = function(v187, v188, v189)
    -- upvalues: v6 (ref), v157 (ref), v10 (ref)
    if type(v187) ~= "string" then
        common.add_notify(v6.name, "An error occured with config!");
        cvar.play:call("resource\\warning.wav");
        return;
    elseif v187 == nil then
        common.add_notify(v6.name, "Name of config is invalid!");
        cvar.play:call("resource\\warning.wav");
        return;
    elseif #v187 == 0 or string.match(v187, "%s%s") then
        common.add_notify(v6.name, "Name of config is empty!");
        cvar.play:call("resource\\warning.wav");
        return;
    elseif #v187 > 24 then
        common.add_notify(v6.name, "Name of config is too long!");
        cvar.play:call("resource\\warning.wav");
        return;
    elseif not (function()
        -- upvalues: v157 (ref), v187 (ref)
        local v190 = true;
        for v191 = 1, #v157.db do
            if v190 then
                if v187 == v157.db[v191].name then
                    v190 = false;
                else
                    v190 = true;
                end;
            end;
        end;
        return v190;
    end)() then
        common.add_notify(v6.name, ("%s is already created!"):format(v187));
        cvar.play:call("resource\\warning.wav");
        return;
    elseif #v157.db > v157.maximum_count then
        common.add_notify(v6.name, "Too much configs!");
        cvar.play:call("resource\\warning.wav");
        return;
    else
        table.insert(v157.db, {
            name = v187, 
            author = v188, 
            data = v189
        });
        v10.write("configs", v157.db);
        common.add_notify(v6.name, ("%s successfully created!"):format(v187));
        cvar.play:call("ui\\beepclear");
        return;
    end;
end;
v157.import = function()
    -- upvalues: l_clipboard_0 (ref), v6 (ref), v157 (ref), v10 (ref)
    local v192 = l_clipboard_0.get();
    if v192 == nil then
        common.add_notify(v6.name, "An error occured with config!");
        cvar.play:call("resource\\warning.wav");
        return;
    else
        local v193 = v157.decompile(v192);
        if v193 == nil then
            common.add_notify(v6.name, "An error occured with config!");
            cvar.play:call("resource\\warning.wav");
            return;
        else
            local l_name_4 = v193.name;
            local l_author_0 = v193.author;
            local l_data_1 = v193.data;
            if #v157.db > v157.maximum_count then
                common.add_notify(v6.name, "Too much configs!");
                cvar.play:call("resource\\warning.wav");
                return;
            else
                table.insert(v157.db, {
                    name = l_name_4, 
                    author = l_author_0, 
                    data = l_data_1
                });
                v10.write("configs", v157.db);
                common.add_notify(v6.name, ("%s successfully imported!"):format(l_name_4));
                cvar.play:call("ui\\beepclear");
                return;
            end;
        end;
    end;
end;
v100.list(v122.home.configs_main)("", {
    [1] = "Empty"
})("configs", "configs_list", {
    [1] = nil, 
    [2] = 3, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.configs_main)("Load", function()
    -- upvalues: v100 (ref), v157 (ref)
    local l_configs_list_0 = v100.elements.configs.configs_list;
    v157.load(l_configs_list_0);
end, true, "Load Config")("configs", "config_load", {
    [1] = nil, 
    [2] = 3, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.configs_main)("Anti Aim", function()
    -- upvalues: v100 (ref), v157 (ref)
    local l_configs_list_1 = v100.elements.configs.configs_list;
    v157.load(l_configs_list_1, "antiaim");
end, true, "Load only Anti-Aim's from Config")("configs", "config_antiaim", {
    [1] = nil, 
    [2] = 3, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.configs_main)("Save", function()
    -- upvalues: v100 (ref), v157 (ref)
    local l_configs_list_2 = v100.elements.configs.configs_list;
    v157.save(l_configs_list_2);
end, true, "Save Config")("configs", "config_save", {
    [1] = nil, 
    [2] = 3, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.configs_main)("Export", function()
    -- upvalues: v100 (ref), v157 (ref)
    local l_configs_list_3 = v100.elements.configs.configs_list;
    v157.export(l_configs_list_3);
end, true, "Export Config")("configs", "config_export", {
    [1] = nil, 
    [2] = 3, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.configs_main)("Delete", function()
    -- upvalues: v100 (ref), v157 (ref)
    local l_configs_list_4 = v100.elements.configs.configs_list;
    v157.remove(l_configs_list_4);
end, true, "Delete Config")("configs", "config_delete", {
    [1] = nil, 
    [2] = 3, 
    [1] = v100.refs.home.tab_selector
});
v157.update_list = function()
    -- upvalues: v100 (ref), v157 (ref)
    local l_configs_list_5 = v100.refs.configs.configs_list;
    v100.refs.configs.config_save:disabled(l_configs_list_5:get() <= 2);
    v100.refs.configs.config_export:disabled(l_configs_list_5:get() <= 2);
    v100.refs.configs.config_delete:disabled(l_configs_list_5:get() <= 2);
    local v203 = ("\a%s60"):format(ui.get_style("Link Active"):to_hex():sub(0, 6));
    local v204 = {};
    for _, v206 in pairs(v157.db) do
        table.insert(v204, ("%s \226\128\162 %s%s"):format(v206.name, v203, v206.author));
    end;
    if v204 ~= l_configs_list_5:list() then
        l_configs_list_5:update(v204 or {
            [1] = "Error"
        });
    end;
end;
events.render(v157.update_list);
v100.input(v122.home.configs_create)(" Config Name", "New")("configs", "config_name", {
    [1] = nil, 
    [2] = 3, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.configs_create)("Create New", function()
    -- upvalues: v157 (ref), v100 (ref), v6 (ref)
    v157.create(v100.elements.configs.config_name, v6.user, v157.data:save());
end, true)("configs", "config_create", {
    [1] = nil, 
    [2] = 3, 
    [1] = v100.refs.home.tab_selector
});
v100.button(v122.home.configs_create)("Import", function()
    -- upvalues: v157 (ref)
    v157.import();
end, true)("configs", "config_import", {
    [1] = nil, 
    [2] = 3, 
    [1] = v100.refs.home.tab_selector
});
v158 = nil;
v158 = {
    handle = function()
        -- upvalues: v100 (ref), v6 (ref), l_pui_0 (ref), v0 (ref)
        if v100.elements.visuals.watermark or v100.elements.visuals.crosshair then
            return;
        else
            local v207 = string.matrix(v6.name:lower(), l_pui_0.colors.accent, color(75));
            local v208 = render.measure_text(4, nil, v6.name:lower());
            render.text(4, vector(v0.x * 0.5 - v208.x * 0.5, v0.y - 20), l_pui_0.colors.accent, nil, v207);
            return;
        end;
    end
};
events.render(v158.handle);
v159 = {
    slowdown = {}
};
local l_slowdown_0 = v159.slowdown;
l_slowdown_0.get_velocity_modifier = function()
    -- upvalues: v30 (ref)
    if not v30.valid then
        return 1;
    else
        local l_m_flStamina_0 = v30.entity.m_flStamina;
        local l_m_flVelocityModifier_0 = v30.entity.m_flVelocityModifier;
        if l_m_flStamina_0 > 0.01 and v30.state ~= v30.states.air and v30.state ~= v30.states.air_crouch then
            local v212 = math.clamp(1 - l_m_flStamina_0 * 0.01, 0, 1);
            l_m_flVelocityModifier_0 = l_m_flVelocityModifier_0 * (v212 * v212);
        end;
        return l_m_flVelocityModifier_0;
    end;
end;
do
    local l_l_slowdown_0_0 = l_slowdown_0;
    l_l_slowdown_0_0.handle = v123:new("slowdown", vector(v0.x * 0.5 - 80, 250), vector(160, 35), {
        rulers = {
            [1] = {
                [1] = "x", 
                [2] = v0.x * 0.5
            }
        }
    })(function(v214)
        -- upvalues: v100 (ref), l_l_slowdown_0_0 (ref), v55 (ref), l_pui_0 (ref)
        v214.enabled = v100.elements.visuals.slowdown;
        local v215 = l_l_slowdown_0_0.get_velocity_modifier();
        local v216 = v55.new("slowdown::enable", v214.enabled and (not (ui.get_alpha() <= 0.5) or v215 ~= 1) and 255 or 0);
        if v216 < 1 then
            return;
        else
            local v217 = string.format("Velocity: %s%%", tostring(math.floor(v215 * 100)));
            local v218 = render.measure_text(1, nil, v217);
            local v219 = v214.position + vector(4, 8);
            render.shadow(v219 + vector(0, 15), v219 + vector(152, 20), l_pui_0.colors.accent:alpha_modulate(v216), 25, 0, 4);
            render.rect(v219 + vector(0, 15), v219 + vector(152, 20), color(0, v216), 4);
            render.rect(v219 + vector(1, 16), v219 + vector(v215 * 146 + 5, 19), l_pui_0.colors.accent:alpha_modulate(v216), 4);
            render.text(1, v219 + vector(76 - v218.x * 0.5, 0), color(255, v216), nil, v217);
            return;
        end;
    end);
    v100.switch(v122.visuals.widgets)(" \v\f<snowflake>\r     Slowdown")("visuals", "slowdown", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 1;
    end);
end;
v159.dashboard = {};
l_slowdown_0 = v159.dashboard;
local v220 = v10.read("rpg");
if not v220 then
    v220 = {
        points = 1000, 
        level = 1
    };
    v10.write("rpg", v220);
end;
do
    local l_l_slowdown_0_1, l_v220_0 = l_slowdown_0, v220;
    local function v224(v223)
        -- upvalues: l_v220_0 (ref)
        l_v220_0.points = l_v220_0.points + v223;
    end;
    local function v226(v225)
        -- upvalues: l_v220_0 (ref)
        l_v220_0.points = l_v220_0.points - v225;
    end;
    local function v230(v227)
        -- upvalues: v30 (ref), v226 (ref)
        if not v30.valid then
            return;
        else
            local v228 = entity.get(v227.userid, true);
            if v228 == nil then
                return;
            else
                local v229 = entity.get(v227.attacker, true);
                if v229 == nil or v229:is_bot() then
                    return;
                else
                    if v229 == v30.entity and v228 == v30.entity then
                        v226(50);
                    elseif v229 ~= v30.entity and v228 == v30.entity then
                        if v227.headshot then
                            v226(20);
                        else
                            v226(10);
                        end;
                    end;
                    return;
                end;
            end;
        end;
    end;
    events.player_death(v230);
    local function v234(v231)
        -- upvalues: v224 (ref)
        local _ = v231.damage;
        local _ = v231.wanted_damage;
        if not v231.target:is_alive() then
            if v231.hitgroup == 0 then
                v224(40);
            else
                v224(20);
            end;
        else
            v224(10);
        end;
    end;
    local function v236(_)
        -- upvalues: l_v220_0 (ref)
        l_v220_0.points = l_v220_0.points - 2;
    end;
    local function v238(v237)
        -- upvalues: v234 (ref), v236 (ref)
        if v237.target:is_bot() then
            return;
        else
            if v237.state == nil then
                v234(v237);
            else
                v236(v237);
            end;
            return;
        end;
    end;
    events.aim_ack(v238);
    local function v242(v239)
        -- upvalues: v30 (ref), v226 (ref)
        local v240 = entity.get(v239.userid, true);
        if v240 == nil then
            return;
        else
            local v241 = entity.get(v239.attacker, true);
            if v241 == nil or v241:is_bot() then
                return;
            else
                if v241 ~= v30.entity and v240 == v30.entity then
                    v226(5);
                end;
                return;
            end;
        end;
    end;
    events.player_hurt(v242);
    l_l_slowdown_0_1.handle = v123:new("dashboard", vector(300, 300), vector(18, 30))(function(v243)
        -- upvalues: v100 (ref), v55 (ref), l_v220_0 (ref), v7 (ref)
        v243.enabled = v100.elements.visuals.dashboard;
        local v244 = v55.new("dashboard::enable", v243.enabled and 255 or 0);
        if v244 < 1 then
            return;
        else
            local v245 = v243.position + vector(4, 4);
            local v246 = v55.new("rpg::points", math.max(l_v220_0.points, 0));
            local v247 = ("%s %s  %s Level %i  %s %ixp"):format("\a{Link Active}" .. ui.get_icon("user") .. "\aDEFAULT", v100.elements.visuals.dashboard_username, "\a{Link Active}" .. ui.get_icon("dial") .. "\aDEFAULT", l_v220_0.level, "\a{Link Active}" .. ui.get_icon("chart-bar") .. "\aDEFAULT", v246);
            local v248 = render.measure_text(1, nil, v247) + vector(8, 0);
            render.shadow(v245, vector(v245.x + v248.x, v245.y + 22), v7.shadow:alpha_modulate(v244), 25, 0, 5);
            render.rect(v245, vector(v245.x + v248.x, v245.y + 22), v7.window_title:alpha_modulate(v244), 5);
            render.text(1, v245 + vector(4, 4), v7.active_text:alpha_modulate(v244), nil, v247);
            render.rect(vector(v245.x + 2, v245.y + 22), vector(v245.x + v248.x * (v246 % 1000 / 1000) - 2, v245.y + 24), v7.link_active:alpha_modulate(v244));
            v243.size = vector(v248.x + 8, 30);
            return;
        end;
    end);
    v100.switch(v122.visuals.widgets)("\226\128\138\v\f<chart-network>\r    Dashboard")("visuals", "dashboard", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 1;
    end)(function(v249, _)
        -- upvalues: v100 (ref), v6 (ref)
        v100.input(v249)("Username", v6.user)("visuals", "dashboard_username");
    end);
    events.render(function()
        -- upvalues: l_v220_0 (ref), l_l_slowdown_0_1 (ref)
        l_v220_0.points = math.max(l_v220_0.points, 0);
        l_v220_0.level = math.floor(math.max(l_v220_0.points / 1000, 1));
        l_l_slowdown_0_1.handle();
    end);
end;
v159.logger = {
    miss_colors = {
        spread = color(255, 255, 115), 
        correction = color(255, 98, 98), 
        misprediction = color(255, 98, 98), 
        ["prediction error"] = color(255, 98, 98), 
        ["backtrack failure"] = color(255, 98, 98), 
        ["damage rejection"] = color(100, 100, 255), 
        ["unregistered shot"] = color(100, 100, 255), 
        ["player death"] = color(100, 100, 255), 
        death = color(100, 100, 255)
    }, 
    hitboxes = {
        [1] = "generic", 
        [2] = "head", 
        [3] = "chest", 
        [4] = "stomach", 
        [5] = "left arm", 
        [6] = "right arm", 
        [7] = "left leg", 
        [8] = "right leg", 
        [9] = "neck", 
        [10] = "?", 
        [11] = "gear"
    }, 
    data = {}
};
l_slowdown_0 = v159.logger;
l_slowdown_0.colored = function(_, v252, v253)
    local v254 = v253:to_hex();
    return (v252:gsub("%${(.-)}", (string.format("\a%s%%1\aDEDEDEFF", v254))));
end;
do
    local l_l_slowdown_0_2 = l_slowdown_0;
    l_l_slowdown_0_2.push = function(_, v257, v258)
        -- upvalues: l_l_slowdown_0_2 (ref)
        local v259 = {
            msg = l_l_slowdown_0_2:colored(v257, v258), 
            clr = v258, 
            time = globals.realtime, 
            alpha = 0
        };
        table.insert(l_l_slowdown_0_2.data, 1, v259);
    end;
    l_l_slowdown_0_2.preview = {
        [1] = {
            alpha = 0, 
            msg = l_l_slowdown_0_2:colored("Hit ${c\195\162n} in ${stomach} for ${33} dmg", color(144, 167, 255)), 
            clr = color(144, 167, 255), 
            time = math.huge
        }, 
        [2] = {
            alpha = 0, 
            msg = l_l_slowdown_0_2:colored("Missed ${c\195\162n} in ${stomach} due to ${unregistered shot}", color(100, 100, 255)), 
            clr = color(100, 100, 255), 
            time = math.huge
        }, 
        [3] = {
            alpha = 0, 
            msg = l_l_slowdown_0_2:colored("Missed ${c\195\162n} in ${stomach} due to ${resolver}", color(255, 98, 98)), 
            clr = color(255, 98, 98), 
            time = math.huge
        }
    };
    l_l_slowdown_0_2.aim_hit = function(v260)
        -- upvalues: l_pui_0 (ref), l_l_slowdown_0_2 (ref), v100 (ref), v6 (ref)
        if v260.hitgroup == 0 then
            return;
        else
            local l_accent_0 = l_pui_0.colors.accent;
            local v262 = v260.target:get_name();
            local v263 = l_l_slowdown_0_2.hitboxes[v260.hitgroup + 1];
            local v264 = tostring(v260.damage);
            local l_wanted_damage_1 = v260.wanted_damage;
            local l_hitchance_0 = v260.hitchance;
            local l_backtrack_0 = v260.backtrack;
            if v100.elements.visuals.logger_settings[1] then
                local v268 = string.format("Hit ${%s} in ${%s} for ${%s} dmg", v262, v263, v264);
                l_l_slowdown_0_2:push(v268, l_accent_0);
            end;
            if v100.elements.visuals.logger_settings[2] then
                local v269 = string.format("${%s} \194\183 Hit ${%s} in ${%s} for ${%s} (${%s}) (hc: ${%s}%% \194\183 bt: ${%s})", v6.name, v262, v263, v264, l_wanted_damage_1, l_hitchance_0, l_backtrack_0);
                print_raw(l_l_slowdown_0_2:colored(v269, l_accent_0));
            end;
            if v100.elements.visuals.logger_settings[3] then
                local v270 = string.format("${%s} \194\183 Hit ${%s} in ${%s} for ${%s} (${%s}) (hc: ${%s}%% \194\183 bt: ${%s})", v6.name, v262, v263, v264, l_wanted_damage_1, l_hitchance_0, l_backtrack_0);
                print_dev(l_l_slowdown_0_2:colored(v270, l_accent_0));
            end;
            return;
        end;
    end;
    l_l_slowdown_0_2.aim_kill = function(v271)
        -- upvalues: l_pui_0 (ref), l_l_slowdown_0_2 (ref), v100 (ref), v6 (ref)
        if v271.hitgroup == 0 then
            return;
        else
            local l_accent_1 = l_pui_0.colors.accent;
            local v273 = v271.target:get_name();
            local v274 = l_l_slowdown_0_2.hitboxes[v271.hitgroup + 1];
            local _ = tostring(v271.damage);
            local _ = v271.wanted_damage;
            local l_hitchance_1 = v271.hitchance;
            local l_backtrack_1 = v271.backtrack;
            if v100.elements.visuals.logger_settings[1] then
                local v279 = string.format("Killed ${%s} in ${%s}", v273, v274);
                l_l_slowdown_0_2:push(v279, l_accent_1);
            end;
            if v100.elements.visuals.logger_settings[2] then
                local v280 = string.format("${%s} \194\183 Killed ${%s} in ${%s} (hc: ${%s}%% \194\183 bt: ${%s})", v6.name, v273, v274, l_hitchance_1, l_backtrack_1);
                print_raw(l_l_slowdown_0_2:colored(v280, l_accent_1));
            end;
            if v100.elements.visuals.logger_settings[3] then
                local v281 = string.format("${%s} \194\183 Killed ${%s} in ${%s} (hc: ${%s}%% \194\183 bt: ${%s})", v6.name, v273, v274, l_hitchance_1, l_backtrack_1);
                print_dev(l_l_slowdown_0_2:colored(v281, l_accent_1));
            end;
            return;
        end;
    end;
    l_l_slowdown_0_2.aim_miss = function(v282)
        -- upvalues: l_l_slowdown_0_2 (ref), v100 (ref), v6 (ref)
        if not v282.wanted_damage or v282.wanted_damage == 0 then
            return;
        else
            local v283 = l_l_slowdown_0_2.miss_colors[v282.state];
            local _ = "\a" .. v283:to_hex();
            local v285 = v282.target:get_name();
            local v286 = l_l_slowdown_0_2.hitboxes[v282.wanted_hitgroup + 1];
            local l_state_0 = v282.state;
            local l_hitchance_2 = v282.hitchance;
            local l_backtrack_2 = v282.backtrack;
            if v100.elements.visuals.logger_settings[1] then
                local v290 = string.format("Missed ${%s} in ${%s} due to ${%s}", v285, v286, l_state_0);
                l_l_slowdown_0_2:push(v290, v283);
            end;
            if v100.elements.visuals.logger_settings[2] then
                local v291 = string.format("${%s} \194\183 Missed ${%s} in ${%s} due to ${%s} (hc: ${%s}%% \194\183 bt: ${%s})", v6.name, v285, v286, l_state_0, l_hitchance_2, l_backtrack_2);
                print_raw(l_l_slowdown_0_2:colored(v291, v283));
            end;
            if v100.elements.visuals.logger_settings[3] then
                local v292 = string.format("${%s} \194\183 Missed ${%s} in ${%s} due to ${%s} (hc: ${%s}%% \194\183 bt: ${%s})", v6.name, v285, v286, l_state_0, l_hitchance_2, l_backtrack_2);
                print_dev(l_l_slowdown_0_2:colored(v292, v283));
            end;
            return;
        end;
    end;
    l_l_slowdown_0_2.events_apply = function(v293)
        -- upvalues: l_l_slowdown_0_2 (ref)
        if v293.state == nil then
            if v293.target:is_alive() then
                l_l_slowdown_0_2.aim_hit(v293);
            else
                l_l_slowdown_0_2.aim_kill(v293);
            end;
        else
            l_l_slowdown_0_2.aim_miss(v293);
        end;
    end;
    l_l_slowdown_0_2.create = function(_, v295, v296, v297)
        local v298 = render.measure_text(1, nil, v295) + vector(16, 8);
        v296.x = v296.x - v298.x * 0.5;
        render.rect(v296, v296 + vector(v298.x, 22), color(20, v297.a * 0.4), 4);
        render.text(1, v296 + vector(9, 4), color(222, v297.a), nil, v295);
    end;
    l_l_slowdown_0_2.handle = v123:new("logger", vector(v0.x * 0.5 - 125, 250), vector(250, 30), {
        rulers = {
            [1] = {
                [1] = "x", 
                [2] = v0.x * 0.5
            }
        }
    })(function(v299)
        -- upvalues: v100 (ref), l_l_slowdown_0_2 (ref), v55 (ref)
        v299.enabled = v100.elements.visuals.logger and v100.elements.visuals.logger_settings[1];
        local v300 = ui.get_alpha() > 0.5 and #l_l_slowdown_0_2.data == 0 and l_l_slowdown_0_2.preview or l_l_slowdown_0_2.data;
        if #v300 == 0 then
            return;
        else
            local v301 = nil;
            local v302 = 0;
            for v303, v304 in pairs(v300) do
                local v305 = globals.realtime - v304.time < 4 and v303 < 6;
                v304.alpha = v55.lerp(v304.alpha, v299.enabled and v305 and 255 or 0);
                if v304.alpha == 0 then
                    v301 = v303;
                end;
                if v304.alpha > 0 then
                    l_l_slowdown_0_2:create(v304.msg, v299.position + vector(125, v302 + 4), v304.clr:alpha_modulate(v304.alpha));
                    v302 = v302 + 28 * v304.alpha / 255;
                end;
            end;
            if v301 then
                table.remove(l_l_slowdown_0_2.data, v301);
            end;
            return;
        end;
    end);
    v100.switch(v122.visuals.widgets)(" \226\128\138\v\f<calendar-lines-pen>\r  \226\128\138 Log Events")("visuals", "logger", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 1;
    end)(function(v306, v307)
        -- upvalues: v100 (ref)
        v100.listable(v306)("", {
            [1] = "Notify", 
            [2] = "Console", 
            [3] = "Debug"
        })("visuals", "logger_settings", v307);
    end);
    v100.refs.visuals.logger:set_callback(function(v308)
        -- upvalues: l_l_slowdown_0_2 (ref)
        events.aim_ack(l_l_slowdown_0_2.events_apply, v308:get());
    end, true);
end;
v159.handle = function()
    -- upvalues: v30 (ref), v159 (ref), v55 (ref), v100 (ref)
    if not v30.valid then
        return;
    else
        for v309, v310 in pairs(v159) do
            local v311 = v55.new("widgets::alpha::" .. v309, (v309 == logger and v100.elements.visuals.logger and v100.elements.visuals.logger_settings[1] or v100.elements.visuals[v309]) and 255 or 0);
            if v100.elements.visuals[v309] or v311 > 0 then
                v310:handle(v311);
            end;
        end;
        return;
    end;
end;
events.render(v159.handle);
l_slowdown_0 = {
    state = -1, 
    menu_items = {}, 
    team_names = {
        [1] = "Terrorist", 
        [2] = "Counter-Terrorist"
    }, 
    states_names = {
        [1] = "Shared", 
        [2] = "Standing", 
        [3] = "Running", 
        [4] = "Walking", 
        [5] = "Crouching", 
        [6] = "Sneaking", 
        [7] = "Air", 
        [8] = "Air & Crouch", 
        [9] = "Freestanding", 
        [10] = "Manual Yaw"
    }
};
v100.list(v122.antiaim.tab_selector)("", {
    [1] = "\v\f<gear>\r   \226\128\138Settings", 
    [2] = "\v\f<bars>\r    Builder", 
    [3] = "\v\f<hourglass>\r   \226\128\138\226\128\138Defensive"
})("antiaim", "tab_selector");
v220 = {
    think = function()
        -- upvalues: v100 (ref), v30 (ref)
        if not v100.elements.antiaim.edge_bait then
            return false;
        else
            local l_edge_bait_0 = v100.elements.antiaim.edge_bait;
            local l_edge_bait_conditions_0 = v100.elements.antiaim.edge_bait_conditions;
            if not l_edge_bait_0 then
                return false;
            elseif not v30.valid then
                return false;
            else
                local l_manual_yaw_0 = v100.elements.antiaim.manual_yaw;
                if l_manual_yaw_0 ~= "Left" and l_manual_yaw_0 ~= "Right" then
                    return false;
                else
                    local v315 = l_edge_bait_conditions_0.Standing and v30.state == v30.states.standing;
                    local v316 = l_edge_bait_conditions_0.Crouching and v30.state == v30.states.crouching;
                    local v317 = l_edge_bait_conditions_0.Sneaking and v30.state == v30.states.sneaking;
                    if not v315 and not v316 and not v317 then
                        return false;
                    else
                        return true;
                    end;
                end;
            end;
        end;
    end, 
    handle = function(v318)
        -- upvalues: v20 (ref)
        v318.yaw_offset = manual_yaw == "Left" and -90 or manual_yaw == "Right" and 90 or 0;
        v318.yaw_modifier = "Disabled";
        v318.body_yaw_options = "";
        v318.left_limit = 60;
        v318.right_limit = 60;
        v318.freestanding = false;
        v318.hidden = true;
        v20.setup("doubletap_config", "Always On");
        v20.setup("hideshots_config", "Break LC");
        rage.antiaim:override_hidden_pitch(0);
        rage.antiaim:override_hidden_yaw_offset(180);
    end
};
v100.switch(v122.antiaim.settings)("\a{Link Active}\f<fishing-rod>   \rEdge Bait")("antiaim", "edge_bait", function()
    -- upvalues: v100 (ref)
    return v100.elements.antiaim.tab_selector == 1;
end)(function(v319, v320)
    -- upvalues: v100 (ref)
    v100.selectable(v319)("Conditions", {
        [1] = "Standing", 
        [2] = "Crouching", 
        [3] = "Sneaking"
    })("antiaim", "edge_bait_conditions", v320);
end);
local v325 = {
    handle = function(v321, v322)
        -- upvalues: v100 (ref), v30 (ref), v20 (ref)
        local l_fake_flick_0 = v100.elements.antiaim.fake_flick;
        local l_fake_flick_settings_0 = v100.elements.antiaim.fake_flick_settings;
        if not l_fake_flick_0 then
            return;
        elseif rage.exploit:get() < 1 then
            return;
        else
            if l_fake_flick_settings_0.Standing and v30.state == v30.states.standing then
                rage.antiaim:inverter(false);
                v322.yaw_offset = 5;
                v322.yaw_modifier = "Disabled";
                v322.body_yaw = true;
                v322.body_yaw_options = "";
                v322.left_limit = 42;
                v322.right_limit = 42;
                v322.freestanding = false;
                v322.hidden = true;
                rage.antiaim:override_hidden_pitch(89);
                rage.antiaim:override_hidden_yaw_offset(-70);
                v20.setup("doubletap_config", "Always On");
                v20.setup("hideshots_config", "Break LC");
                v321.force_defensive = v321.command_number % 7 == 0;
            elseif l_fake_flick_settings_0.Walking and v30.state == v30.states.walking then
                rage.antiaim:inverter(false);
                v322.yaw_offset = 5;
                v322.yaw_modifier = "Offset";
                v322.yaw_modifier_offset = 1;
                v322.body_yaw = true;
                v322.body_yaw_options = "";
                v322.left_limit = 48;
                v322.right_limit = 48;
                v322.freestanding = false;
                v322.hidden = true;
                rage.antiaim:override_hidden_pitch(89);
                rage.antiaim:override_hidden_yaw_offset(-70);
                v20.setup("doubletap_config", "Always On");
                v20.setup("hideshots_config", "Break LC");
                v321.force_defensive = v321.command_number % 7 == 0;
            elseif l_fake_flick_settings_0.Crouch and v30.state == v30.states.crouching then
                rage.antiaim:inverter(false);
                v322.yaw_offset = 5;
                v322.yaw_modifier = "Disabled";
                v322.body_yaw = true;
                v322.body_yaw_options = "";
                v322.left_limit = 42;
                v322.right_limit = 42;
                v322.freestanding = false;
                v322.hidden = true;
                rage.antiaim:override_hidden_pitch(89);
                rage.antiaim:override_hidden_yaw_offset(-70);
                v20.setup("doubletap_config", "Always On");
                v20.setup("hideshots_config", "Break LC");
                v321.force_defensive = v321.command_number % 7 == 0;
            end;
            return;
        end;
    end
};
v100.switch(v122.antiaim.settings)("\a{Link Active}\f<bug>   \rFake Flick")("antiaim", "fake_flick", function()
    -- upvalues: v100 (ref)
    return v100.elements.antiaim.tab_selector == 1;
end)(function(v326, v327)
    -- upvalues: v100 (ref)
    v100.selectable(v326)("Conditions", {
        [1] = "Standing", 
        [2] = "Walking", 
        [3] = "Crouch"
    })("antiaim", "fake_flick_settings", v327);
end);
local v329 = {
    handle = function(v328)
        -- upvalues: v100 (ref), v30 (ref)
        if not v100.elements.antiaim.safe_knife then
            return;
        elseif not v30.valid then
            return;
        elseif not (v30.weapon.weapon_classname == "CKnife") then
            return;
        elseif v30.state ~= v30.states.air_crouch then
            return;
        else
            rage.antiaim:inverter(true);
            v328.yaw_offset = 0;
            v328.yaw_modifier = "Disabled";
            v328.body_yaw_options = "";
            v328.left_limit = 25;
            v328.right_limit = 25;
            v328.freestanding = false;
            v328.hidden = false;
            return;
        end;
    end
};
v100.switch(v122.antiaim.settings)("\a{Link Active}\f<knife-kitchen>   \rSafe Knife")("antiaim", "safe_knife", function()
    -- upvalues: v100 (ref)
    return v100.elements.antiaim.tab_selector == 1;
end);
local v330 = {
    start_time = globals.realtime
};
do
    local l_v220_1, l_v325_0, l_v329_0, l_v330_0 = v220, v325, v329, v330;
    l_v330_0.handle = function(v335, v336)
        -- upvalues: v100 (ref), v30 (ref), l_v330_0 (ref)
        if not v100.elements.antiaim.antiaim_on_use then
            return;
        elseif not v30.valid then
            return;
        elseif not v335.in_use then
            l_v330_0.start_time = globals.realtime;
            return;
        else
            local v337 = v30.entity.m_iTeamNum == 3;
            local v338 = entity.get_entities("CPlantedC4");
            local l_m_bIsGrabbingHostage_0 = v30.entity.m_bIsGrabbingHostage;
            if v337 and #v338 > 0 then
                local v340 = v338[#v338]:get_origin();
                if v30.origin:dist(v340) < 65 then
                    return;
                end;
            end;
            if l_m_bIsGrabbingHostage_0 then
                return;
            elseif v335.in_use and globals.realtime - l_v330_0.start_time < 0.02 then
                return;
            else
                v335.in_use = false;
                v336.hidden = false;
                v336.pitch = "Disabled";
                v336.yaw_offset = 180;
                v336.freestanding = false;
                return;
            end;
        end;
    end;
    v100.switch(v122.antiaim.settings)("\a{Link Active}\f<leafy-green>   \rLegit AA")("antiaim", "antiaim_on_use", function()
        -- upvalues: v100 (ref)
        return v100.elements.antiaim.tab_selector == 1;
    end);
    local v345 = {
        handle = function(v341)
            -- upvalues: v100 (ref)
            if not v100.elements.antiaim.warmup_modify then
                return;
            else
                local v342 = entity.get_game_rules();
                if v342 == nil then
                    return;
                else
                    local v343 = false;
                    entity.get_players(true, true, function(v344)
                        -- upvalues: v343 (ref)
                        if v344:is_alive() then
                            v343 = true;
                        end;
                    end);
                    if not v342.m_bWarmupPeriod and v343 then
                        return;
                    else
                        v341.pitch = "Disabled";
                        v341.yaw = "Backward";
                        v341.yaw_offset = math.normalize_yaw(globals.tickcount * 22);
                        v341.body_yaw = false;
                        v341.yaw_modifier = "Disabled";
                        v341.freestanding = false;
                        v341.hidden = false;
                        v341.fakelag = false;
                        return;
                    end;
                end;
            end;
        end
    };
    v100.switch(v122.antiaim.settings)("\a{Link Active}\f<mug-hot>   \rWarmup/Enemy Modify")("antiaim", "warmup_modify", function()
        -- upvalues: v100 (ref)
        return v100.elements.antiaim.tab_selector == 1;
    end);
    local v346 = {
        handle = function()
            -- upvalues: v100 (ref), v20 (ref)
            if not v100.elements.antiaim.allow_defensive then
                return;
            else
                v20.setup("hideshots_config", "Break LC");
                return;
            end;
        end
    };
    v100.switch(v122.antiaim.settings)("\a{Link Active}\f<shield-halved>   \rDefensive on Hide Shots")("antiaim", "allow_defensive", function()
        -- upvalues: v100 (ref)
        return v100.elements.antiaim.tab_selector == 1;
    end);
    local v348 = {
        handle = function()
            -- upvalues: v100 (ref)
            if not v100.elements.antiaim.defensive_disablers then
                return false;
            else
                if v100.elements.antiaim.target_ping ~= 0 then
                    local v347 = entity.get_threat();
                    if v347 and v347:get_resource().m_iPing < v100.elements.antiaim.target_ping then
                        return true;
                    end;
                end;
                return false;
            end;
        end
    };
    v100.switch(v122.antiaim.settings)("\a{Link Active}\f<shield-xmark>   \rDefensive AA Disablers")("antiaim", "defensive_disablers", function()
        -- upvalues: v100 (ref)
        return v100.elements.antiaim.tab_selector == 1;
    end)(function(v349)
        -- upvalues: v100 (ref)
        v100.slider(v349)("Target Ping", 0, 100, 0, nil, function(v350)
            return v350 == 0 and "Off" or v350;
        end)("antiaim", "target_ping", function()
            -- upvalues: v100 (ref)
            return v100.elements.antiaim.tab_selector == 1 and v100.elements.antiaim.defensive_disablers;
        end);
    end);
    local v351 = {
        vecTraceStart = vector(0, 0, 0)
    };
    v351.handle = function(v352, v353)
        -- upvalues: v100 (ref), v30 (ref), v351 (ref)
        if not v100.elements.antiaim.edge_yaw then
            return;
        elseif v30.state == v30.states.air or v30.state == v30.states.air_crouch then
            return;
        elseif not v30.valid then
            return;
        else
            if v352.send_packet then
                v351.vecTraceStart = v30.entity:get_eye_position();
            end;
            local v354 = {};
            local v355 = render.camera_angles();
            local v356 = {};
            for v357 = 18, 360, 18 do
                v357 = math.normalize_yaw(v357);
                local v358 = v351.vecTraceStart + vector():angles(0, v357) * 198;
                local v359 = utils.trace_line(v351.vecTraceStart, v358, v30.entity, 1174421507);
                table.insert(v356, v351.vecTraceStart:dist(v359.end_pos));
                local l_fraction_0 = v359.fraction;
                local l_entity_0 = v359.entity;
                if l_entity_0 and l_entity_0:get_classname() == "CWorld" and l_fraction_0 < 0.3 then
                    v354[#v354 + 1] = {
                        vecTraceEnd = v358, 
                        flYaw = v357
                    };
                end;
            end;
            table.sort(v356);
            if v356[1] > 30 then
                return;
            else
                table.sort(v354, function(v362, v363)
                    return v362.flYaw < v363.flYaw;
                end);
                table.remove(v354, #v354);
                local v364 = nil;
                if #v354 >= 3 then
                    local v365 = v354[1].vecTraceEnd:lerp(v354[#v354].vecTraceEnd, 0.5);
                    v364 = (v351.vecTraceStart - v365):angles();
                end;
                if v364 then
                    local l_y_0 = v355.y;
                    local l_y_1 = v364.y;
                    local v368 = math.normalize_yaw(l_y_1 - l_y_0);
                    if math.abs(v368) < 90 then
                        v368 = 0;
                        l_y_0 = math.normalize_yaw(l_y_1 + 180);
                    end;
                    local v369 = -l_y_0;
                    v369 = math.normalize_yaw(v369 + l_y_1 + v368 + 180);
                    v353.yaw_base = "Local View";
                    v353.yaw_offset = v369;
                    v353.freestanding = false;
                end;
                return;
            end;
        end;
    end;
    v100.switch(v122.antiaim.binds)("Edge Yaw")("antiaim", "edge_yaw", function()
        -- upvalues: v100 (ref)
        return v100.elements.antiaim.tab_selector == 1;
    end);
    local v370 = {
        yaw_list = {
            Forward = 180, 
            Right = 90, 
            Left = -90, 
            Backward = 0
        }
    };
    v370.handle = function(v371)
        -- upvalues: v100 (ref), v370 (ref), l_slowdown_0 (ref), v30 (ref)
        local l_manual_yaw_1 = v100.elements.antiaim.manual_yaw;
        local l_manual_yaw_local_view_0 = v100.elements.antiaim.manual_yaw_local_view;
        local l_freestanding_0 = v100.elements.antiaim.freestanding;
        local l_freestanding_local_view_0 = v100.elements.antiaim.freestanding_local_view;
        local l_freestanding_disablers_0 = v100.elements.antiaim.freestanding_disablers;
        local v377 = l_manual_yaw_1 == "Left" or l_manual_yaw_1 == "Right";
        local v378 = v370.yaw_list[l_manual_yaw_1];
        v371.yaw_base = "At Target";
        if l_freestanding_disablers_0[l_slowdown_0.states_names[v30.state]] or l_freestanding_disablers_0["Manual Yaw"] and v377 then
            v371.freestanding = false;
        else
            v371.freestanding = l_freestanding_0;
            v371.yaw_base = l_freestanding_local_view_0 and "Local View" or "At Target";
        end;
        if v378 then
            v371.yaw_offset = v371.yaw_offset + v378;
            v371.yaw_base = l_manual_yaw_local_view_0 and v377 and "Local View" or "At Target";
        end;
    end;
    v100.switch(v122.antiaim.binds)("Freestanding")("antiaim", "freestanding", function()
        -- upvalues: v100 (ref)
        return v100.elements.antiaim.tab_selector == 1;
    end)(function(v379)
        -- upvalues: v100 (ref)
        v100.selectable(v379)("Disablers", {
            [1] = "Standing", 
            [2] = "Walking", 
            [3] = "Crouching", 
            [4] = "Air", 
            [5] = "Manual Yaw"
        })("antiaim", "freestanding_disablers");
        v100.switch(v379)("Local View")("antiaim", "freestanding_local_view");
    end);
    v100.combo(v122.antiaim.binds)("Manual Yaw", {
        [1] = "Forward", 
        [2] = "Backward", 
        [3] = "Left", 
        [4] = "Right", 
        [5] = "At Target"
    })("antiaim", "manual_yaw", function()
        -- upvalues: v100 (ref)
        return v100.elements.antiaim.tab_selector == 1;
    end)(function(v380)
        -- upvalues: v100 (ref)
        v100.switch(v380)("Local View")("antiaim", "manual_yaw_local_view");
    end);
    local v381 = nil;
    v381 = {};
    local v382 = 0;
    local v383 = 0;
    local v384 = 0;
    local v385 = 0;
    do
        local l_v382_0, l_v383_0, l_v384_0, l_v385_0 = v382, v383, v384, v385;
        local function v402(v390)
            -- upvalues: l_v384_0 (ref), l_v382_0 (ref), l_v383_0 (ref), l_pui_0 (ref), v100 (ref), v159 (ref), v6 (ref), l_v385_0 (ref)
            if l_v384_0 == globals.tickcount then
                return;
            else
                local v391 = entity.get_local_player();
                if v391 == nil or not v391:is_alive() then
                    return;
                else
                    local v392 = entity.get(v390.userid, true);
                    local v393 = vector(v390.x, v390.y, v390.z);
                    if v392 == nil or not v392:is_enemy() then
                        return;
                    else
                        local v394 = v391:get_eye_position();
                        if (v394 - v394:closest_ray_point(v392:get_eye_position(), v393)):length2dsqr() > 5000 then
                            return;
                        else
                            local v395 = v392:get_name();
                            local v396 = utils.random_int(1, 2) == 2;
                            local v397 = utils.random_int(5, 9);
                            l_v382_0 = v396 and -v397 or v397;
                            l_v383_0 = v396 and -9 or 9;
                            local l_accent_2 = l_pui_0.colors.accent;
                            if v100.elements.visuals.logger_settings[1] then
                                local v399 = string.format("Anti-Bruteforce triggered by ${%s}'s shot", v395);
                                v159.logger:push(v399, l_accent_2);
                            end;
                            if v100.elements.visuals.logger_settings[2] then
                                local v400 = string.format("${%s} \194\183 Anti-Bruteforce triggered by ${%s}'s shot", v6.name, v395);
                                print_raw(v159.logger:colored(v400, l_accent_2));
                            end;
                            if v100.elements.visuals.logger_settings[3] then
                                local v401 = string.format("${%s} \194\183 Anti-Bruteforce triggered by ${%s}'s shot", v6.name, v395);
                                print_dev(v159.logger:colored(v401, l_accent_2));
                            end;
                            l_v385_0 = globals.realtime;
                            l_v384_0 = globals.tickcount;
                            return;
                        end;
                    end;
                end;
            end;
        end;
        should_update = function(v403)
            -- upvalues: l_v385_0 (ref)
            return v403.anti_bruteforce and l_v385_0 + v403.bruteforce_time > globals.realtime;
        end;
        v381.update = function(v404)
            -- upvalues: l_v382_0 (ref), l_v383_0 (ref)
            if not should_update(v404) then
                return;
            else
                if v404.bruteforce_mode == "Random" then
                    v404.yaw_offset = l_v382_0;
                end;
                if v404.bruteforce_mode == "Switch" then
                    v404.yaw_offset = l_v383_0;
                end;
                return;
            end;
        end;
        events.bullet_impact(v402);
    end;
    v100.combo(v122.antiaim.states)("Team", l_slowdown_0.team_names)("antiaim", "team", {
        [1] = nil, 
        [2] = 2, 
        [3] = 3, 
        [1] = v100.refs.antiaim.tab_selector
    });
    v100.combo(v122.antiaim.states)("Condition", l_slowdown_0.states_names)("antiaim", "state", {
        [1] = nil, 
        [2] = 2, 
        [3] = 3, 
        [1] = v100.refs.antiaim.tab_selector
    });
    for _, v406 in pairs(l_slowdown_0.team_names) do
        l_slowdown_0.menu_items[v406] = {};
        do
            local l_v406_0 = v406;
            for _, v409 in pairs(l_slowdown_0.states_names) do
                local v410 = l_slowdown_0.menu_items[l_v406_0];
                local v411 = {};
                local v412 = "##_" .. v409 .. "_" .. l_v406_0;
                ds = "_" .. v409 .. "_" .. l_v406_0;
                sd = v412;
                v410[v409] = v411;
                v410 = l_slowdown_0.menu_items[l_v406_0][v409];
                do
                    local l_v409_0 = v409;
                    v411 = function()
                        -- upvalues: v100 (ref), l_v409_0 (ref), l_v406_0 (ref)
                        return v100.elements.antiaim.tab_selector == 2 and v100.elements.antiaim.state == l_v409_0 and v100.elements.antiaim.team == l_v406_0;
                    end;
                    if l_v409_0 ~= 1 then
                        v410.allow_legacy = v100.switch(v122.antiaim.states)(("Allow %s##%s"):format(l_v409_0, l_v406_0))("antiaim", "allow_legacy" .. ds, v411);
                    end;
                    v410.yaw_offset = v100.slider(v122.antiaim.builder)("Yaw Offset" .. sd, -180, 180, 0, nil, "\194\176")("antiaim", "yaw_offset" .. ds, v411);
                    v410.yaw_add = v100.switch(v122.antiaim.builder)("Yaw Add" .. sd)("antiaim", "yaw_add" .. ds, v411)();
                    do
                        local l_v410_0, l_v411_0, l_v412_0 = v410, v411, v412;
                        l_v410_0.left_offset = v100.slider(v122.antiaim.builder)("\a{Link Active} \f<angle-right>   \rLeft Offset" .. sd, -180, 180, 0, nil, "\194\176")("antiaim", "left_offset" .. ds, function()
                            -- upvalues: l_v411_0 (ref), l_v410_0 (ref)
                            return l_v411_0() and l_v410_0.yaw_add.value;
                        end);
                        l_v410_0.right_offset = v100.slider(v122.antiaim.builder)("\a{Link Active} \f<angle-right>   \rRight Offset" .. sd, -180, 180, 0, nil, "\194\176")("antiaim", "right_offset" .. ds, function()
                            -- upvalues: l_v411_0 (ref), l_v410_0 (ref)
                            return l_v411_0() and l_v410_0.yaw_add.value;
                        end);
                        l_v410_0.modifier = v100.combo(v122.antiaim.builder)("Yaw Modifier" .. sd, {
                            [1] = "Disabled", 
                            [2] = "Center", 
                            [3] = "Offset", 
                            [4] = "Random", 
                            [5] = "Spin", 
                            [6] = "3-Way", 
                            [7] = "5-Way"
                        })("antiaim", "modifier" .. ds, l_v411_0)();
                        l_v410_0.modifier_offset = v100.slider(v122.antiaim.builder)("\a{Link Active} \f<angle-right>   \rOffset" .. sd, -180, 180, 0, nil, "\194\176")("antiaim", "modifier_offset" .. ds, function()
                            -- upvalues: l_v411_0 (ref), l_v410_0 (ref)
                            return l_v411_0() and l_v410_0.modifier.value ~= "Disabled";
                        end);
                        l_v410_0.body_yaw = v100.combo(v122.antiaim.builder)("Body Yaw" .. sd, {
                            [1] = "Disabled", 
                            [2] = "Left", 
                            [3] = "Right", 
                            [4] = "Jitter", 
                            [5] = "Random"
                        })("antiaim", "body_yaw" .. ds, l_v411_0)();
                        l_v410_0.delay_ticks = v100.slider(v122.antiaim.builder)("\a{Link Active} \f<angle-right>   \rDelay" .. sd, 2, 10, 2, nil, function(v417)
                            return v417 == 2 and "Off" or v417 .. "t";
                        end)("antiaim", "delay_ticks" .. ds, function()
                            -- upvalues: l_v411_0 (ref), l_v410_0 (ref)
                            return l_v411_0() and l_v410_0.body_yaw.value == "Jitter";
                        end);
                        l_v410_0.min_delay = v100.slider(v122.antiaim.builder)("\a{Link Active} \f<angle-right>   \rMin. Delay" .. sd, 2, 10, 2, nil, "t")("antiaim", "min_delay" .. ds, function()
                            -- upvalues: l_v411_0 (ref), l_v410_0 (ref)
                            return l_v411_0() and l_v410_0.body_yaw.value == "Random";
                        end);
                        l_v410_0.max_delay = v100.slider(v122.antiaim.builder)("\a{Link Active} \f<angle-right>   \rMax. Delay" .. sd, 2, 10, 2, nil, "t")("antiaim", "max_delay" .. ds, function()
                            -- upvalues: l_v411_0 (ref), l_v410_0 (ref)
                            return l_v411_0() and l_v410_0.body_yaw.value == "Random";
                        end);
                        l_v410_0.randomize_fake = v100.slider(v122.antiaim.builder)("\a{Link Active} \f<angle-right>   \rFake Randomize" .. sd .. "fake", 0, 100, 0, nil, function(v418)
                            return v418 == 0 and "Off" or v418 .. "%";
                        end)("antiaim", "randomize_fake" .. ds, function()
                            -- upvalues: l_v411_0 (ref), l_v410_0 (ref)
                            return l_v411_0() and l_v410_0.body_yaw.value ~= "Disabled";
                        end);
                        v100.label(v122.antiaim.builder)("\a{Link Active} \f<angle-right>   \rFake Limit")("antiaim", "body_yaw_gear" .. ds, function()
                            -- upvalues: l_v411_0 (ref), l_v410_0 (ref)
                            return l_v411_0() and l_v410_0.body_yaw.value ~= "Disabled";
                        end)(function(v419, _)
                            -- upvalues: l_v410_0 (ref), v100 (ref)
                            l_v410_0.body_yaw_left = v100.slider(v419)("Left Limit" .. sd, 0, 60, 60, nil, "\194\176")("antiaim", "body_yaw_left" .. ds);
                            l_v410_0.body_yaw_right = v100.slider(v419)("Right Limit" .. sd, 0, 60, 60, nil, "\194\176")("antiaim", "body_yaw_right" .. ds);
                        end);
                        l_v410_0.anti_bruteforce = v100.switch(v122.antiaim.builder)("Anti-Bruteforce" .. sd)("antiaim", "anti_bruteforce" .. ds, l_v411_0)(function(v421, v422)
                            -- upvalues: l_v410_0 (ref), v100 (ref)
                            l_v410_0.bruteforce_mode = v100.combo(v421)("Mode", {
                                [1] = "Random", 
                                [2] = "Switch"
                            })("antiaim", "bruteforce_mode" .. ds, v422);
                            l_v410_0.bruteforce_time = v100.slider(v421)("Reset Time" .. sd, 1, 5, 3, nil, "s")("antiaim", "bruteforce_time" .. ds, v422);
                        end);
                        l_v410_0.allow_defensive = v100.switch(v122.antiaim.states)(("Allow Defensive on %s##%s"):format(l_v409_0, l_v406_0))("antiaim", "allow_defensive" .. ds, function()
                            -- upvalues: v100 (ref), l_v409_0 (ref), l_v406_0 (ref)
                            return v100.elements.antiaim.tab_selector == 3 and v100.elements.antiaim.state == l_v409_0 and v100.elements.antiaim.team == l_v406_0;
                        end)();
                        l_v412_0 = function()
                            -- upvalues: v100 (ref), l_v409_0 (ref), l_v406_0 (ref), l_v410_0 (ref)
                            return v100.elements.antiaim.tab_selector == 3 and v100.elements.antiaim.state == l_v409_0 and v100.elements.antiaim.team == l_v406_0 and l_v410_0.allow_defensive.value;
                        end;
                        l_v410_0.defensive_pitch = v100.combo(v122.antiaim.defensive)("Pitch" .. sd, {
                            [1] = "Up", 
                            [2] = "Down", 
                            [3] = "Zero", 
                            [4] = "Static", 
                            [5] = "Random", 
                            [6] = "Jitter", 
                            [7] = "Randomize Jitter", 
                            [8] = "Spin"
                        })("antiaim", "defensive_pitch" .. ds, l_v412_0)();
                        l_v410_0.defensive_pitch_slider = v100.slider(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rOffset" .. sd, -89, 89, 0, nil, "\194\176")("antiaim", "defensive_pitch_slider" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and l_v410_0.defensive_pitch.value == "Static";
                        end);
                        l_v410_0.defensive_pitch1 = v100.slider(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rMin. Offset" .. sd, -89, 89, 0, nil, "\194\176")("antiaim", "defensive_pitch1" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and (l_v410_0.defensive_pitch.value == "Jitter" or not (l_v410_0.defensive_pitch.value ~= "Random") or l_v410_0.defensive_pitch.value == "Randomize Jitter");
                        end);
                        l_v410_0.defensive_pitch2 = v100.slider(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rMax. Offset" .. sd, -89, 89, 0, nil, "\194\176")("antiaim", "defensive_pitch2" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and (l_v410_0.defensive_pitch.value == "Jitter" or not (l_v410_0.defensive_pitch.value ~= "Random") or l_v410_0.defensive_pitch.value == "Randomize Jitter");
                        end);
                        l_v410_0.defensive_pitch_delay_ticks = v100.slider(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rDelay Ticks" .. sd, 2, 10, 2, nil, function(v423)
                            return v423 == 2 and "Off" or v423 .. "t";
                        end)("antiaim", "defensive_pitch_delay_ticks" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and l_v410_0.defensive_pitch.value == "Jitter";
                        end);
                        l_v410_0.defensive_pitch_spin_offset = v100.slider(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rOffset" .. sd, 0, 180, 180, nil, "\194\176")("antiaim", "defensive_pitch_spin_offset" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and l_v410_0.defensive_pitch.value == "Spin";
                        end);
                        l_v410_0.defensive_pitch_spin = v100.slider(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rSpeed" .. sd, 1, 100, 10, nil, "%")("antiaim", "defensive_pitch_spin" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and l_v410_0.defensive_pitch.value == "Spin";
                        end);
                        l_v410_0.defensive_pitch_reverse = v100.switch(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rReverse" .. sd)("antiaim", "defensive_pitch_reverses" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and l_v410_0.defensive_pitch.value == "Spin";
                        end);
                        l_v410_0.defensive_yaw = v100.combo(v122.antiaim.defensive)("Yaw" .. sd, {
                            [1] = "Static", 
                            [2] = "Random", 
                            [3] = "Random Static", 
                            [4] = "Jitter", 
                            [5] = "Spin", 
                            [6] = "Sway", 
                            [7] = "Forward", 
                            [8] = "Sideways", 
                            [9] = "Neverlose"
                        })("antiaim", "defensive_yaw" .. ds, l_v412_0)();
                        l_v410_0.defensive_yaw_offset = v100.slider(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rOffset" .. sd, -180, 180, 0, nil, "\194\176")("antiaim", "defensive_yaw_offset" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and l_v410_0.defensive_yaw.value == "Static";
                        end);
                        l_v410_0.defensive_left_offset = v100.slider(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rMin. Offset" .. sd, -180, 180, 0, nil, "\194\176")("antiaim", "defensive_left_offset" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and (l_v410_0.defensive_yaw.value == "Jitter" or l_v410_0.defensive_yaw.value == "Random");
                        end);
                        l_v410_0.defensive_right_offset = v100.slider(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rMax. Offset" .. sd, -180, 180, 0, nil, "\194\176")("antiaim", "defensive_right_offset" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and (l_v410_0.defensive_yaw.value == "Jitter" or l_v410_0.defensive_yaw.value == "Random");
                        end);
                        l_v410_0.defensive_yaw_delay_ticks = v100.slider(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rDelay Ticks" .. sd, 2, 10, 2, nil, function(v424)
                            return v424 == 2 and "Off" or v424 .. "t";
                        end)("antiaim", "defensive_yaw_delay_ticks" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and l_v410_0.defensive_yaw.value == "Jitter";
                        end);
                        l_v410_0.defensive_spin_start_offset = v100.slider(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rStart Offset" .. sd, -180, 180, 0, nil, "\194\176")("antiaim", "defensive_spin_start_offset" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and (l_v410_0.defensive_yaw.value == "Spin" or l_v410_0.defensive_yaw.value == "Sway");
                        end);
                        l_v410_0.defensive_spin_offset = v100.slider(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rOffset" .. sd, 0, 360, 360, nil, "\194\176")("antiaim", "defensive_spin_offset" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and (l_v410_0.defensive_yaw.value == "Spin" or l_v410_0.defensive_yaw.value == "Sway");
                        end);
                        l_v410_0.defensive_spin = v100.slider(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rSpeed" .. sd, 1, 100, 10, nil, "%")("antiaim", "defensive_spin" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and (l_v410_0.defensive_yaw.value == "Spin" or l_v410_0.defensive_yaw.value == "Sway");
                        end);
                        l_v410_0.defensive_reverse = v100.switch(v122.antiaim.defensive)("\a{Link Active} \f<angle-right>   \rReverse" .. sd)("antiaim", "defensive_reverse" .. ds, function()
                            -- upvalues: l_v412_0 (ref), l_v410_0 (ref)
                            return l_v412_0() and l_v410_0.defensive_yaw.value == "Spin";
                        end);
                        l_v410_0.force_defensive = v100.switch(v122.antiaim.defensive)("Force Defensive" .. sd)("antiaim", "force_defensive" .. ds, function()
                            -- upvalues: v100 (ref), l_v409_0 (ref), l_v406_0 (ref)
                            return v100.elements.antiaim.tab_selector == 3 and v100.elements.antiaim.state == l_v409_0 and v100.elements.antiaim.team == l_v406_0;
                        end);
                        for v425, v426 in pairs(l_slowdown_0.menu_items[l_v406_0][l_v409_0]) do
                            if type(v426) == "function" then
                                l_slowdown_0.menu_items[l_v406_0][l_v409_0][v425] = l_slowdown_0.menu_items[l_v406_0][l_v409_0][v425]();
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    v382 = function(v427)
        local v428 = {};
        for v429, _ in pairs(v427) do
            local v431 = v427[v429];
            if v431 ~= nil then
                v428[v429] = v431:get();
            end;
        end;
        return v428;
    end;
    v383 = function()
        -- upvalues: l_slowdown_0 (ref), v100 (ref)
        local v432 = l_slowdown_0.menu_items[v100.elements.antiaim.team];
        if v432 == nil then
            return nil;
        else
            return v432[v100.elements.antiaim.state];
        end;
    end;
    v384 = function()
        -- upvalues: v100 (ref), l_slowdown_0 (ref)
        local v433 = v100.elements.antiaim.team == l_slowdown_0.team_names[1] and l_slowdown_0.team_names[2] or l_slowdown_0.team_names[1];
        local v434 = l_slowdown_0.menu_items[v433];
        if v434 == nil then
            return nil;
        else
            return v434[v100.elements.antiaim.state];
        end;
    end;
    v385 = function()
        -- upvalues: v383 (ref), v382 (ref)
        local v435 = v383();
        if v435 == nil then
            return nil;
        else
            return v382(v435);
        end;
    end;
    local function v442(v436, v437)
        if v436 == nil then
            return false;
        else
            for v438, _ in pairs(v436) do
                local v440 = v436[v438];
                local v441 = v437[v438];
                if v440 ~= nil and v441 ~= nil then
                    v440:set(v441);
                end;
            end;
            return true;
        end;
    end;
    local function v449()
        -- upvalues: v385 (ref), l_base64_0 (ref), v6 (ref)
        local l_status_4, l_result_4 = pcall(v385);
        if not l_status_4 or l_result_4 == nil then
            return false, "Can't get current data";
        else
            local l_status_5, l_result_5 = pcall(json.stringify, l_result_4);
            if not l_status_5 then
                return false, "Can't stringify json";
            else
                local l_status_6, l_result_6 = pcall(l_base64_0.encode, l_result_5);
                if not l_status_6 then
                    return false, "Can't encode base64";
                else
                    return true, v6.name:lower() .. "::state::" .. l_result_6;
                end;
            end;
        end;
    end;
    local function v457()
        -- upvalues: l_clipboard_0 (ref), v6 (ref), l_base64_0 (ref)
        local l_status_7, l_result_7 = pcall(l_clipboard_0.get);
        if not l_status_7 then
            return false, "Can't get clipboard data";
        elseif l_result_7 == nil then
            return false, "Can't match valid data";
        else
            local v452 = v6.name:lower() .. "::state::";
            if not l_result_7:find(v452) then
                return false, "Can't match valid data";
            else
                l_result_7 = l_result_7:gsub(v452, "");
                local l_status_8, l_result_8 = pcall(l_base64_0.decode, l_result_7);
                if not l_status_8 then
                    return false, "Can't decode thru base64";
                else
                    local l_status_9, l_result_9 = pcall(json.parse, l_result_8);
                    if not l_status_9 or l_result_9 == nil then
                        return false, "Can't parse thru json";
                    else
                        return true, l_result_9;
                    end;
                end;
            end;
        end;
    end;
    local function v462()
        -- upvalues: v449 (ref), l_clipboard_0 (ref)
        local v458, v459 = v449();
        if not v458 then
            return;
        else
            local l_status_10, _ = pcall(l_clipboard_0.set, v459);
            if not l_status_10 then
                return;
            else
                cvar.play:call("ui\\beepclear");
                return;
            end;
        end;
    end;
    local function v467()
        -- upvalues: v457 (ref), v442 (ref), v383 (ref)
        local v463, v464 = v457();
        if not v463 then
            logging.error(v464);
            return;
        else
            local l_status_11, _ = pcall(v442, v383(), v464);
            if not l_status_11 then
                return;
            else
                cvar.play:call("ui\\beepclear");
                return;
            end;
        end;
    end;
    local function v471()
        -- upvalues: v385 (ref), v442 (ref), v384 (ref)
        local v468 = v385();
        if v468 == nil then
            return;
        else
            local l_status_12, _ = pcall(v442, v384(), v468);
            if not l_status_12 then
                return;
            else
                cvar.play:call("ui\\beepclear");
                return;
            end;
        end;
    end;
    v100.button(v122.antiaim.team)("           \v\f<file-export>\r  Copy           ", v462, true)("antiaim", "copy", function()
        -- upvalues: v100 (ref)
        return v100.elements.antiaim.tab_selector == 2 or v100.elements.antiaim.tab_selector == 3;
    end);
    v100.button(v122.antiaim.team)("           \v\f<file-import>\r  Paste           ", v467, true)("antiaim", "paste", function()
        -- upvalues: v100 (ref)
        return v100.elements.antiaim.tab_selector == 2 or v100.elements.antiaim.tab_selector == 3;
    end);
    v100.button(v122.antiaim.team)("         \v\f<share>\r  Forward to the opposing team         ", v471, true)("antiaim", "send", function()
        -- upvalues: v100 (ref)
        return v100.elements.antiaim.tab_selector == 2 or v100.elements.antiaim.tab_selector == 3;
    end);
    l_slowdown_0.update_player_state = function(_)
        -- upvalues: v30 (ref), v100 (ref), l_slowdown_0 (ref)
        if not v30.valid then
            return;
        else
            local v473 = v100.elements.antiaim.manual_yaw == "Left" or v100.elements.antiaim.manual_yaw == "Right";
            local l_freestanding_disablers_1 = v100.elements.antiaim.freestanding_disablers;
            if v100.elements.antiaim["allow_legacy_Manual Yaw"] and v473 then
                l_slowdown_0.state = v30.states.manual_yaw;
                return;
            elseif not l_freestanding_disablers_1[l_slowdown_0.states_names[v30.state]] and (not l_freestanding_disablers_1["Manual Yaw"] or not v473) and v100.elements.antiaim.allow_legacy_Freestanding and v100.elements.antiaim.freestanding then
                l_slowdown_0.state = v30.states.freestanding;
                return;
            else
                l_slowdown_0.state = v30.state;
                return;
            end;
        end;
    end;
    l_slowdown_0.current_side = false;
    l_slowdown_0.update_side = function()
        -- upvalues: v30 (ref), l_slowdown_0 (ref)
        if not v30.valid then
            return;
        elseif globals.choked_commands ~= 0 then
            return;
        else
            l_slowdown_0.current_side = v30.entity.m_flPoseParameter[11] * 120 - 60 > 0;
            return;
        end;
    end;
    l_slowdown_0.lerp = function(v475, v476, v477)
        return v475 + (v476 - v475) * v477;
    end;
    l_slowdown_0.default_twisted = false;
    l_slowdown_0.current_tick = 1;
    l_slowdown_0.set_default_yaw_offset = function(_, v479)
        -- upvalues: l_slowdown_0 (ref)
        local v480 = 0;
        if not v479.yaw_add then
            v479.left_offset = 0;
            v479.right_offset = 0;
        end;
        local l_tickcount_1 = globals.tickcount;
        if v479.body_yaw == "Left" or v479.body_yaw == "Right" then
            rage.antiaim:inverter(v479.body_yaw == "Left" or not (v479.body_yaw == "Right") and false);
            v480 = rage.antiaim:inverter() and v479.left_offset or v479.right_offset;
        end;
        if v479.body_yaw == "Jitter" then
            if v479.delay_ticks == 2 then
                v479.body_yaw_options = "Jitter";
                v480 = l_slowdown_0.current_side and v479.left_offset or v479.right_offset;
            else
                if l_tickcount_1 % v479.delay_ticks == 0 then
                    l_slowdown_0.default_twisted = not l_slowdown_0.default_twisted;
                end;
                rage.antiaim:inverter(l_slowdown_0.default_twisted);
                v480 = rage.antiaim:inverter() and v479.left_offset or v479.right_offset;
            end;
        end;
        if v479.body_yaw == "Random" then
            if l_tickcount_1 % utils.random_int(v479.min_delay, v479.max_delay) == 0 then
                l_slowdown_0.default_twisted = not l_slowdown_0.default_twisted;
            end;
            rage.antiaim:inverter(l_slowdown_0.default_twisted);
            v480 = rage.antiaim:inverter() and v479.left_offset or v479.right_offset;
        end;
        v479.yaw_offset = v479.yaw_offset + v480;
    end;
    l_slowdown_0.set_body_yaw = function(v482)
        local v483 = v482.randomize_fake > 0;
        v482.body_yaw = v482.body_yaw ~= "Disabled";
        v482.left_limit = v483 and utils.random_int(v482.body_yaw_left - v482.randomize_fake * 0.01 * v482.body_yaw_left, v482.body_yaw_left) or v482.body_yaw_left;
        v482.right_limit = v483 and utils.random_int(v482.body_yaw_right - v482.randomize_fake * 0.01 * v482.body_yaw_right, v482.body_yaw_right) or v482.body_yaw_right;
    end;
    math.normalize_pitch = function(v484)
        return math.clamp(v484, -89, 89);
    end;
    l_slowdown_0.defensive_pitch_twisted = false;
    l_slowdown_0.set_defensive_pitch = function(v485)
        -- upvalues: l_slowdown_0 (ref)
        if globals.tickcount % v485.defensive_pitch_delay_ticks == 0 then
            l_slowdown_0.defensive_pitch_twisted = not l_slowdown_0.defensive_pitch_twisted;
        end;
        local v486 = {
            Zero = 0, 
            Down = 89, 
            Up = -89, 
            Static = v485.defensive_pitch_slider, 
            Random = utils.random_int(v485.defensive_pitch1, v485.defensive_pitch2), 
            Jitter = l_slowdown_0.defensive_pitch_twisted and v485.defensive_pitch1 or v485.defensive_pitch2, 
            ["Randomize Jitter"] = utils.random_int(0, 1) == 1 and v485.defensive_pitch1 or v485.defensive_pitch2, 
            Spin = -89 + l_slowdown_0.lerp(v485.defensive_pitch_spin_offset * (v485.defensive_pitch_reverse and -0.5 or 0.5), v485.defensive_pitch_spin_offset * (v485.defensive_pitch_reverse and 0.5 or -0.5), globals.curtime * (v485.defensive_pitch_spin * 0.1) % 1)
        };
        rage.antiaim:override_hidden_pitch(math.normalize_pitch(v486[v485.defensive_pitch]));
    end;
    l_slowdown_0.defensive_yaw_twisted = false;
    l_slowdown_0.defensive_yaw_cache = nil;
    l_slowdown_0.set_defensive_yaw_offset = function(v487)
        -- upvalues: l_slowdown_0 (ref)
        if v487.defensive_yaw ~= "Sideways" then
            if globals.tickcount % v487.defensive_yaw_delay_ticks == 0 then
                l_slowdown_0.defensive_yaw_twisted = not l_slowdown_0.defensive_yaw_twisted;
            end;
        elseif globals.tickcount % 2 == 0 then
            l_slowdown_0.defensive_yaw_twisted = not l_slowdown_0.defensive_yaw_twisted;
        end;
        local v488 = {
            Forward = 180, 
            Static = v487.defensive_yaw_offset, 
            Random = utils.random_int(v487.defensive_left_offset, v487.defensive_right_offset), 
            ["Random Static"] = function()
                -- upvalues: l_slowdown_0 (ref), v487 (ref)
                if not l_slowdown_0.defensive_yaw_cache then
                    l_slowdown_0.defensive_yaw_cache = utils.random_int(v487.defensive_left_offset, v487.defensive_right_offset);
                end;
                return l_slowdown_0.defensive_yaw_cache or 0;
            end, 
            Jitter = l_slowdown_0.defensive_yaw_twisted and v487.defensive_left_offset or v487.defensive_right_offset, 
            Spin = v487.defensive_spin_start_offset + l_slowdown_0.lerp(v487.defensive_spin_offset * (v487.defensive_reverse and -0.5 or 0.5), v487.defensive_spin_offset * (v487.defensive_reverse and 0.5 or -0.5), globals.curtime * (v487.defensive_spin * 0.1) % 1), 
            Sway = v487.defensive_spin_start_offset + v487.defensive_spin_offset * math.sin(globals.curtime * (v487.defensive_spin * 0.1)), 
            Sideways = l_slowdown_0.defensive_yaw_twisted and -90 or 90
        };
        rage.antiaim:inverter(true);
        v487.yaw_offset = 0;
        v487.modifier = "Disabled";
        local v489 = v488[v487.defensive_yaw];
        if v489 then
            rage.antiaim:override_hidden_yaw_offset(math.normalize_yaw(type(v489) == "function" and v489() or v489));
        end;
    end;
    l_slowdown_0.defensive_config = function(v490)
        -- upvalues: v20 (ref)
        if not v490.force_defensive then
            return;
        else
            v20.setup("doubletap_config", "Always On");
            return;
        end;
    end;
    l_slowdown_0.defensive_handle = function(_, v492)
        -- upvalues: v348 (ref), v346 (ref), l_slowdown_0 (ref), l_defensive_0 (ref)
        if v348.handle() then
            return;
        else
            v346.handle(v492);
            l_slowdown_0.defensive_config(v492);
            if v492.allow_defensive and l_defensive_0() then
                v492.hidden = true;
                l_slowdown_0.set_defensive_yaw_offset(v492);
                l_slowdown_0.set_defensive_pitch(v492);
            else
                l_slowdown_0.defensive_yaw_cache = nil;
            end;
            return;
        end;
    end;
    l_slowdown_0.get_team = function(v493)
        if v493 == 2 then
            return "Terrorist";
        elseif v493 == 3 then
            return "Counter-Terrorist";
        else
            return nil;
        end;
    end;
    l_slowdown_0.get_active = function(v494, v495)
        -- upvalues: l_slowdown_0 (ref)
        local v496 = l_slowdown_0.menu_items[v494][v495];
        if v496 ~= nil and v495 ~= 1 and v496.allow_legacy:get() then
            return v495;
        else
            return "Shared";
        end;
    end;
    l_slowdown_0.get_state_values = function(v497, v498)
        -- upvalues: l_slowdown_0 (ref)
        local v499 = l_slowdown_0.menu_items[v497][v498];
        if v499 == nil then
            return;
        else
            local v500 = {};
            for v501, v502 in pairs(v499) do
                v500[v501] = v502:get();
            end;
            return v500;
        end;
    end;
    l_slowdown_0.set_ui = function(v503)
        -- upvalues: v20 (ref)
        for v504, v505 in pairs(v503) do
            if v20.items[v504] ~= nil then
                v20.setup(v504, v505);
            end;
        end;
    end;
    l_slowdown_0.setup = function(v506)
        v506.yaw = "Backward";
        v506.body_yaw_options = "";
    end;
    l_slowdown_0.handle = function(v507)
        -- upvalues: v30 (ref), l_slowdown_0 (ref), v381 (ref), v370 (ref), l_v329_0 (ref), v351 (ref), l_v220_1 (ref), l_v325_0 (ref), l_v330_0 (ref), v345 (ref)
        if not v30.valid then
            return;
        else
            l_slowdown_0.update_player_state(v507);
            l_slowdown_0.update_side();
            local v508 = l_slowdown_0.get_team(v30.entity.m_iTeamNum);
            local v509 = l_slowdown_0.get_active(v508, l_slowdown_0.states_names[v30.state]);
            local v510 = l_slowdown_0.get_state_values(v508, v509);
            l_slowdown_0.setup(v510);
            l_slowdown_0.set_default_yaw_offset(v507, v510);
            l_slowdown_0.set_body_yaw(v510);
            l_slowdown_0.defensive_handle(v507, v510);
            v381.update(v510);
            v370.handle(v510);
            l_v329_0.handle(v510);
            v351.handle(v507, v510);
            if l_v220_1.think() then
                l_v220_1.handle(v510);
            else
                l_v325_0.handle(v507, v510);
            end;
            l_v330_0.handle(v507, v510);
            v345.handle(v510);
            l_slowdown_0.set_ui(v510);
            return;
        end;
    end;
    events.createmove(l_slowdown_0.handle);
end;
v100.list(v122.visuals.tab_selector)("", {
    [1] = "\v\f<layer-group>\r    Visuals", 
    [2] = "\v\f<screwdriver-wrench>\r    Misc", 
    [3] = "\v\f<crosshairs>\r    Ragebot"
})("visuals", "tab_selector");
v220 = {
    crosshair = {
        items = {}
    }
};
v325 = v220.crosshair;
do
    local l_v325_1 = v325;
    l_v325_1.handle = v123:new("crosshair", vector(v0.x * 0.5 - 28, v0.y * 0.5 + 28), vector(56, 18), {
        border = {
            vector(v0.x * 0.5, v0.y * 0.5 - 100), 
            vector(v0.x * 0.5, v0.y * 0.5 + 100)
        }
    })(function(v512)
        -- upvalues: v100 (ref), v30 (ref), l_v325_1 (ref), v0 (ref), v55 (ref)
        v512.enabled = v100.elements.visuals.crosshair;
        local v513 = v512.position + vector(28, -10);
        local v514 = v30.side * 0.5 + 0.5;
        for _, v516 in pairs(l_v325_1.items) do
            v513.y = v513.y + (v512.position.y < v0.y * 0.5 - 9 and -v516.offset or v516.offset);
            local l_size_0 = v516:paint(v513).size;
            v516.alpha = v55.lerp(v516.alpha, v512.enabled and v516:get() and 255 or 0);
            v516.size = v55.lerp(v516.size, v30.side ~= 0 and l_size_0.x * v514 + v30.side * 8 or l_size_0.x * 0.5);
            v516.offset = v55.lerp(v516.offset, v516:get() and 12 or 0);
        end;
    end);
    l_v325_1.create = function(v518, v519)
        table.insert(v518.items, {
            offset = 0, 
            alpha = 0, 
            size = 0, 
            get = v519.get, 
            paint = v519.paint
        });
    end;
    l_v325_1:create({
        get = function(_)
            return true;
        end, 
        paint = function(v521, v522)
            -- upvalues: v6 (ref), l_pui_0 (ref)
            local v523 = v6.name:lower();
            local v524 = render.measure_text(4, nil, v523);
            local v525 = string.matrix(v523, l_pui_0.colors.accent, color(75));
            if v521.alpha > 0 then
                render.text(4, v522 - vector(v521.size + 1, 0), l_pui_0.colors.accent:alpha_modulate(v521.alpha), nil, v525);
            end;
            return {
                size = v524
            };
        end
    });
    l_v325_1:create({
        get = function(_)
            -- upvalues: v19 (ref)
            return v19.doubletap:get();
        end, 
        paint = function(v527, v528)
            -- upvalues: v55 (ref), v30 (ref)
            local v529 = "dt";
            local v530 = render.measure_text(1, nil, v529);
            local v531 = v55.new("crosshair::dt", v30.exploit * 255);
            local v532 = color(255, v531, v531);
            if v527.alpha > 0 then
                render.text(1, v528 - vector(v527.size, 0), v532:alpha_modulate(v527.alpha), nil, v529);
            end;
            return {
                size = v530
            };
        end
    });
    l_v325_1:create({
        get = function(_)
            -- upvalues: v19 (ref)
            return v19.hideshots:get();
        end, 
        paint = function(v534, v535)
            local v536 = "hs";
            local v537 = render.measure_text(1, nil, v536);
            if v534.alpha > 0 then
                render.text(1, v535 - vector(v534.size, 0), color(255):alpha_modulate(v534.alpha), nil, v536);
            end;
            return {
                size = v537
            };
        end
    });
    l_v325_1:create({
        get = function(_)
            -- upvalues: v48 (ref), v19 (ref)
            return v48.get(v19.min_damage);
        end, 
        paint = function(v539, v540)
            local v541 = "dmg";
            local v542 = render.measure_text(1, nil, v541);
            if v539.alpha > 0 then
                render.text(1, v540 - vector(v539.size, 0), color(255):alpha_modulate(v539.alpha), nil, v541);
            end;
            return {
                size = v542
            };
        end
    });
    l_v325_1:create({
        get = function(_)
            -- upvalues: v48 (ref), v19 (ref)
            return v48.get(v19.hit_chance);
        end, 
        paint = function(v544, v545)
            local v546 = "hc";
            local v547 = render.measure_text(1, nil, v546);
            if v544.alpha > 0 then
                render.text(1, v545 - vector(v544.size, 0), color(255):alpha_modulate(v544.alpha), nil, v546);
            end;
            return {
                size = v547
            };
        end
    });
    l_v325_1:create({
        get = function(_)
            -- upvalues: v19 (ref)
            return v19.prefer_body:get() == "Force";
        end, 
        paint = function(v549, v550)
            local v551 = "ba";
            local v552 = render.measure_text(1, nil, v551);
            if v549.alpha > 0 then
                render.text(1, v550 - vector(v549.size, 0), color(255):alpha_modulate(v549.alpha), nil, v551);
            end;
            return {
                size = v552
            };
        end
    });
    l_v325_1:create({
        get = function(_)
            -- upvalues: v19 (ref)
            return v19.prefer_safety:get() == "Force";
        end, 
        paint = function(v554, v555)
            local v556 = "sp";
            local v557 = render.measure_text(1, nil, v556);
            if v554.alpha > 0 then
                render.text(1, v555 - vector(v554.size, 0), color(255):alpha_modulate(v554.alpha), nil, v556);
            end;
            return {
                size = v557
            };
        end
    });
    l_v325_1:create({
        get = function(_)
            -- upvalues: v19 (ref)
            return (v19.fake_latency:get_override() or v19.fake_latency:get()) > 0;
        end, 
        paint = function(v559, v560)
            local v561 = "ps";
            local v562 = render.measure_text(1, nil, v561);
            if v559.alpha > 0 then
                render.text(1, v560 - vector(v559.size, 0), color(255):alpha_modulate(v559.alpha), nil, v561);
            end;
            return {
                size = v562
            };
        end
    });
    v100.switch(v122.visuals.indicators)(" \v\f<crosshairs>\r    Crosshair")("visuals", "crosshair", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 1;
    end);
    v100.refs.visuals.crosshair:set_callback(function(v563)
        -- upvalues: v30 (ref), l_v325_1 (ref)
        events.render(function()
            -- upvalues: v30 (ref), l_v325_1 (ref)
            if not v30.valid then
                return;
            else
                l_v325_1.handle();
                return;
            end;
        end, v563:get());
    end, true);
end;
v220.arrows = {};
v325 = v220.arrows;
v329 = render.load_font("Verdana Bold", 16, "da");
v325.handle = v123:new("arrows", vector(v0.x * 0.5 - 32, v0.y * 0.5 - 9), vector(18, 18), {
    border = {
        vector(v0.x * 0.5 - 100, v0.y * 0.5), 
        vector(v0.x * 0.5 - 9, v0.y * 0.5)
    }
})(function(v564)
    -- upvalues: v100 (ref), v55 (ref), l_pui_0 (ref), v0 (ref)
    v564.enabled = v100.elements.visuals.arrows;
    local v565 = v564.position + vector(3, 9);
    local v566 = v55.new("arrows::left", v564.enabled and (not (v100.elements.antiaim.manual_yaw ~= "Left") or ui.get_alpha() > 0.5) and 255 or 0);
    render.poly(l_pui_0.colors.accent:alpha_modulate(v566), v565 + vector(10, 6), v565, v565 - vector(-10, 6));
    local v567 = v55.new("arrows::right", v564.enabled and (not (v100.elements.antiaim.manual_yaw ~= "Right") or ui.get_alpha() > 0.5) and 255 or 0);
    render.poly(l_pui_0.colors.accent:alpha_modulate(v567), vector(v0.x - v565.x - 10, v565.y - 6), vector(v0.x - v565.x, v565.y), vector(v0.x - v565.x - 10, v565.y + 6));
end);
v100.switch(v122.visuals.indicators)(" \v\f<location-arrow>\r     Arrows")("visuals", "arrows", function()
    -- upvalues: v100 (ref)
    return v100.elements.visuals.tab_selector == 1;
end);
do
    local l_v325_2 = v325;
    v100.refs.visuals.arrows:set_callback(function(v569)
        -- upvalues: v30 (ref), l_v325_2 (ref)
        events.render(function()
            -- upvalues: v30 (ref), l_v325_2 (ref)
            if not v30.valid then
                return;
            else
                l_v325_2.handle();
                return;
            end;
        end, v569:get());
    end, true);
end;
v220.damage = {};
v325 = v220.damage;
v325.handle = v123:new("damage", vector(v0.x * 0.5 - 5, v0.y * 0.5 + 15), vector(18, 18), {
    border = {
        vector(v0.x * 0.5 - 50, v0.y * 0.5 - 50), 
        vector(v0.x * 0.5 + 50, v0.y * 0.5 + 50)
    }
})(function(v570)
    -- upvalues: v100 (ref), v19 (ref)
    v570.enabled = v100.elements.visuals.damage;
    local v571 = v570.position + vector(5, 2);
    local v572 = tostring(v19.min_damage:get());
    local v573 = render.measure_text(1, nil, v572);
    render.text(1, v571, color(255), nil, v572);
    v570.size = vector(v573.x + 8, 18);
end);
v100.switch(v122.visuals.indicators)(" \v\f<input-numeric>\r  \226\128\138Damage")("visuals", "damage", function()
    -- upvalues: v100 (ref)
    return v100.elements.visuals.tab_selector == 1;
end);
do
    local l_v325_3 = v325;
    v100.refs.visuals.damage:set_callback(function(v575)
        -- upvalues: v30 (ref), l_v325_3 (ref)
        events.render(function()
            -- upvalues: v30 (ref), l_v325_3 (ref)
            if not v30.valid then
                return;
            else
                l_v325_3.handle();
                return;
            end;
        end, v575:get());
    end, true);
end;
v100.color_picker(v122.visuals.style)(" \v\f<palette>\r    Color", color(144, 167, 255))("visuals", "color", function()
    -- upvalues: v100 (ref)
    return v100.elements.visuals.tab_selector == 1;
end);
events.render(function()
    -- upvalues: l_pui_0 (ref), v100 (ref)
    l_pui_0.colors.accent = v100.elements.visuals.color;
end);
v325 = {
    aspect_ratio = {}
};
v329 = v325.aspect_ratio;
v329.cvar = cvar.r_aspectratio;
do
    local l_v329_1 = v329;
    l_v329_1.update = function()
        -- upvalues: v100 (ref), l_v329_1 (ref)
        local v577 = v100.elements.visuals.aspect_ratio and v100.elements.visuals.aspect_ratio_value / 100 or 0;
        l_v329_1.cvar:float(v577, true);
    end;
    l_v329_1.reset = function()
        -- upvalues: l_v329_1 (ref)
        l_v329_1.cvar:float(0);
    end;
    v100.switch(v122.visuals.visuals)(" \v\f<tv>\r    Aspect Ratio")("visuals", "aspect_ratio", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 1;
    end)(function(v578, v579)
        -- upvalues: v100 (ref)
        v100.slider(v578)("Ratio", 80, 240, 177, 0.01, function(v580)
            return ({
                [125] = "5:4", 
                [160] = "16:10", 
                [177] = "16:9", 
                [150] = "3:2", 
                [133] = "4:3"
            })[v580];
        end)("visuals", "aspect_ratio_value", v579);
        v100.label(v578)(" ")("visuals", "aspect_ratio_label", v579);
        v100.button(v578)(" 5:4 ", function()
            -- upvalues: v100 (ref)
            v100.refs.visuals.aspect_ratio_value:set(125);
        end, true)("visuals", "aspect_ratio_125", v579);
        v100.button(v578)(" 4:3 ", function()
            -- upvalues: v100 (ref)
            v100.refs.visuals.aspect_ratio_value:set(133);
        end, true)("visuals", "aspect_ratio_133", v579);
        v100.button(v578)(" 3:2 ", function()
            -- upvalues: v100 (ref)
            v100.refs.visuals.aspect_ratio_value:set(150);
        end, true)("visuals", "aspect_ratio_150", v579);
        v100.button(v578)(" 16:10 ", function()
            -- upvalues: v100 (ref)
            v100.refs.visuals.aspect_ratio_value:set(160);
        end, true)("visuals", "aspect_ratio_160", v579);
        v100.button(v578)(" 16:9 ", function()
            -- upvalues: v100 (ref)
            v100.refs.visuals.aspect_ratio_value:set(177);
        end, true)("visuals", "aspect_ratio_177", v579);
    end);
    v100.refs.visuals.aspect_ratio:set_callback(function(v581)
        -- upvalues: l_v329_1 (ref), v100 (ref)
        l_v329_1.update();
        v100.refs.visuals.aspect_ratio_value:set_callback(l_v329_1.update, v581:get());
        events.shutdown(l_v329_1.reset, v581:get());
    end, true);
end;
v325.viewmodel = {};
v329 = v325.viewmodel;
v329.fov = cvar.viewmodel_fov;
v329.offset_x = cvar.viewmodel_offset_x;
v329.offset_y = cvar.viewmodel_offset_y;
v329.offset_z = cvar.viewmodel_offset_z;
do
    local l_v329_2 = v329;
    l_v329_2.update = function()
        -- upvalues: v100 (ref), l_v329_2 (ref)
        local l_viewmodel_0 = v100.elements.visuals.viewmodel;
        local v584 = l_viewmodel_0 and v100.elements.visuals.viewmodel_fov or 68;
        local v585 = l_viewmodel_0 and v100.elements.visuals.viewmodel_x / 10 or 2.5;
        local v586 = l_viewmodel_0 and v100.elements.visuals.viewmodel_y / 10 or 0;
        local v587 = l_viewmodel_0 and v100.elements.visuals.viewmodel_z / 10 or -1.5;
        l_v329_2.fov:float(v584, true);
        l_v329_2.offset_x:float(v585, true);
        l_v329_2.offset_y:float(v586, true);
        l_v329_2.offset_z:float(v587, true);
    end;
    l_v329_2.reset = function()
        -- upvalues: l_v329_2 (ref)
        l_v329_2.fov:float(68);
        l_v329_2.offset_x:float(2.5);
        l_v329_2.offset_y:float(0);
        l_v329_2.offset_z:float(-1.5);
    end;
    v100.switch(v122.visuals.visuals)("\226\128\138\226\128\138\v\f<person-rifle>\r    Viewmodel")("visuals", "viewmodel", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 1;
    end)(function(v588, v589)
        -- upvalues: v100 (ref)
        v100.slider(v588)("FOV", 0, 100, 68)("visuals", "viewmodel_fov", v589);
        v100.slider(v588)("X", -100, 100, 25, 0.1)("visuals", "viewmodel_x", v589);
        v100.slider(v588)("Y", -100, 100, 0, 0.1)("visuals", "viewmodel_y", v589);
        v100.slider(v588)("Z", -100, 100, -15, 0.1)("visuals", "viewmodel_z", v589);
        v100.button(v588)(" Reset ", function()
            -- upvalues: v100 (ref)
            v100.refs.visuals.viewmodel_fov:set(68);
            v100.refs.visuals.viewmodel_x:set(25);
            v100.refs.visuals.viewmodel_y:set(0);
            v100.refs.visuals.viewmodel_z:set(-15);
        end, true)("visuals", "viewmodel_reset", v589);
    end);
    v100.refs.visuals.viewmodel:set_callback(function(v590)
        -- upvalues: l_v329_2 (ref), v100 (ref)
        l_v329_2.update();
        v100.refs.visuals.viewmodel_fov:set_callback(l_v329_2.update, v590:get());
        v100.refs.visuals.viewmodel_x:set_callback(l_v329_2.update, v590:get());
        v100.refs.visuals.viewmodel_y:set_callback(l_v329_2.update, v590:get());
        v100.refs.visuals.viewmodel_z:set_callback(l_v329_2.update, v590:get());
        events.shutdown(l_v329_2.reset, v590:get());
    end, true);
end;
v325.vgui = {};
v329 = v325.vgui;
v330 = utils.get_vfunc("engine.dll", "VEngineClient014", 11, "bool(__thiscall*)(void*)");
v329.material = {
    [1] = "vgui_white", 
    [2] = "vgui/hud/800corner1", 
    [3] = "vgui/hud/800corner2", 
    [4] = "vgui/hud/800corner3", 
    [5] = "vgui/hud/800corner4"
};
for v591, v592 in pairs(v329.material) do
    v329.material[v591] = materials.get_materials(v592)[1];
end;
v329.last = color(255);
do
    local l_v329_3, l_v330_1 = v329, v330;
    l_v329_3.change = function(v595)
        -- upvalues: l_v329_3 (ref)
        if l_v329_3.last ~= v595 then
            for _, v597 in pairs(l_v329_3.material) do
                v597:alpha_modulate(v595.a / 255);
                v597:color_modulate(color(v595.r, v595.g, v595.b));
            end;
            l_v329_3.last = v595;
        end;
    end;
    l_v329_3.handle = function()
        -- upvalues: v100 (ref), l_v330_1 (ref), l_v329_3 (ref)
        local v598 = v100.elements.visuals.vgui and l_v330_1() and v100.elements.visuals.vgui_color or color(255);
        l_v329_3.change(v598);
    end;
    l_v329_3.reset = function()
        -- upvalues: l_v329_3 (ref)
        for _, v600 in pairs(l_v329_3.material) do
            v600:reset();
        end;
    end;
    v100.switch(v122.visuals.visuals)("\226\128\138\226\128\138\v\f<rectangle-code>\r     VGUI Color")("visuals", "vgui", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 1;
    end)(function(_, v602)
        -- upvalues: v100 (ref)
        v100.color_picker(v602)(color(100, 255))("visuals", "vgui_color", v602);
    end);
    v100.refs.visuals.vgui:set_callback(function(v603)
        -- upvalues: l_v329_3 (ref)
        if not v603:get() then
            l_v329_3.change(color(255, 255, 255, 255));
        end;
        events.pre_render(l_v329_3.handle, v603:get());
        events.shutdown(l_v329_3.reset, v603:get());
    end, true);
end;
v325.scope = {};
v329 = v325.scope;
v329.handle = function()
    -- upvalues: v30 (ref), v100 (ref), v20 (ref), v55 (ref), v0 (ref)
    if not v30.valid then
        return;
    else
        local l_scope_0 = v100.elements.visuals.scope;
        local l_scope_size_0 = v100.elements.visuals.scope_size;
        local l_scope_gap_0 = v100.elements.visuals.scope_gap;
        local l_scope_accent_color_0 = v100.elements.visuals.scope_accent_color;
        local v608 = v100.elements.visuals.scope_settings[1];
        local v609 = v100.elements.visuals.scope_settings[2];
        local v610 = v100.elements.visuals.scope_settings[3];
        if l_scope_0 then
            v20.setup("scope_overlay", "Remove All");
        end;
        local v611 = v55.new("scope::alpha", l_scope_0 and v30.scoped and 255 or 0);
        local v612 = v55.new("scope::default", not (not (l_scope_0 and v30.scoped) or v608) and l_scope_accent_color_0.a or 0);
        local v613 = v55.new("scope::inverted", l_scope_0 and v30.scoped and v608 and l_scope_accent_color_0.a or 0);
        local v614 = v55.new("scope::rotated", v609 and 45 or 0);
        local v615 = v610 and v55.new("scope::spread_depend", (v30.weapon.weapon_inaccuracy + v30.weapon.weapon_spread) * 75) + l_scope_gap_0 or l_scope_gap_0;
        local v616 = {
            l_scope_accent_color_0:alpha_modulate(v612), 
            l_scope_accent_color_0:alpha_modulate(v613)
        };
        l_scope_size_0 = l_scope_size_0 * v611 / 255;
        local v617 = v0 * 0.5;
        if v614 ~= 0 then
            render.push_rotation(v614, v617);
        end;
        render.gradient(v617 - vector(-1, l_scope_size_0 + v615), v617 - vector(0, v615), v616[2], v616[2], v616[1], v616[1]);
        render.gradient(v617 + vector(1, l_scope_size_0 + v615), v617 + vector(0, v615), v616[2], v616[2], v616[1], v616[1]);
        render.gradient(v617 + vector(l_scope_size_0 + v615, 1), v617 + vector(v615, 0), v616[2], v616[1], v616[2], v616[1]);
        render.gradient(v617 - vector(l_scope_size_0 + v615, -1), v617 - vector(v615, 0), v616[2], v616[1], v616[2], v616[1]);
        if v614 ~= 0 then
            render.pop_rotation();
        end;
        return;
    end;
end;
v100.switch(v122.visuals.visuals)(" \226\128\138\v\f<crosshairs-simple>\r    \226\128\138Scope")("visuals", "scope", function()
    -- upvalues: v100 (ref)
    return v100.elements.visuals.tab_selector == 1;
end)(function(v618, v619)
    -- upvalues: v100 (ref)
    v100.slider(v618)("Size", 0, 300, 50, nil, "px")("visuals", "scope_size", v619);
    v100.slider(v618)("Gap", 0, 300, 5, nil, "px")("visuals", "scope_gap", v619);
    v100.color_picker(v618)("Color", color(255, 100))("visuals", "scope_accent_color", v619);
    v100.listable(v618)("", {
        [1] = "Inverted", 
        [2] = "Rotated", 
        [3] = "Spread Depend"
    })("visuals", "scope_settings", v619);
end);
do
    local l_v329_4 = v329;
    v100.refs.visuals.scope:set_callback(function(v621)
        -- upvalues: l_v329_4 (ref)
        events.render(l_v329_4.handle, v621:get());
    end, true);
end;
v325.nade_radius = {};
v329 = v325.nade_radius;
v329.handle = function()
    -- upvalues: v30 (ref), v100 (ref)
    if not v30.valid then
        return;
    else
        local l_tickcount_2 = globals.tickcount;
        local l_tickinterval_0 = globals.tickinterval;
        if v100.elements.visuals.nade_radius_smoke then
            entity.get_entities("CSmokeGrenadeProjectile", nil, function(v624)
                -- upvalues: l_tickinterval_0 (ref), l_tickcount_2 (ref), v100 (ref)
                if not v624.m_bDidSmokeEffect then
                    return;
                else
                    local v625 = (17.55 - l_tickinterval_0 * (l_tickcount_2 - v624.m_nSmokeEffectTickBegin)) / 17.55;
                    local v626 = v624:get_origin();
                    local v627 = v624:get_bbox().alpha * 255;
                    render.circle_3d(v626, v100.refs.visuals.nade_radius_smoke.color.value:alpha_modulate(v627), 125, 0, 1, false);
                    render.circle_3d_outline(v626, v100.refs.visuals.nade_radius_smoke.color.value:alpha_modulate(v627), 125, 0, v625, 1.5);
                    return;
                end;
            end);
        end;
        if v100.elements.visuals.nade_radius_molotov then
            entity.get_entities("CInferno", nil, function(v628)
                -- upvalues: l_tickinterval_0 (ref), l_tickcount_2 (ref), v100 (ref)
                local v629 = (7.125 - l_tickinterval_0 * (l_tickcount_2 - v628.m_nFireEffectTickBegin)) / 7.125;
                local v630 = v628:get_origin();
                local v631 = v628:get_bbox().alpha * 255;
                render.circle_3d(v630, v100.refs.visuals.nade_radius_molotov.color.value:alpha_modulate(v631), 125, 0, 1, false);
                render.circle_3d_outline(v630, v100.refs.visuals.nade_radius_molotov.color.value:alpha_modulate(v631), 125, 0, v629, 1.5);
            end);
        end;
        return;
    end;
end;
v100.switch(v122.visuals.visuals)(" \226\128\138\v\f<brake-warning>\r  \226\128\138\226\128\138Nade Radius")("visuals", "nade_radius", function()
    -- upvalues: v100 (ref)
    return v100.elements.visuals.tab_selector == 1;
end)(function(v632, v633)
    -- upvalues: v100 (ref)
    v100.switch(v632)("Molotov", false, color(255, 63, 63, 255))("visuals", "nade_radius_molotov", v633);
    v100.switch(v632)("Smoke", false, color(61, 147, 250, 255))("visuals", "nade_radius_smoke", v633);
end);
do
    local l_v329_5 = v329;
    v100.refs.visuals.nade_radius:set_callback(function(v635)
        -- upvalues: l_v329_5 (ref)
        events.render(l_v329_5.handle, v635:get());
    end, true);
end;
v329 = {
    avoid_collisions = {}
};
v330 = v329.avoid_collisions;
v330.change_yaw = function(v636, v637, v638)
    if math.abs(v638.plane.normal.z) > 0.1 or v638.plane.normal:length() < 0.1 then
        return;
    else
        local v639 = nil;
        if v638.plane.normal.y < v638.plane.normal.x then
            v639 = math.atan2(v638.plane.normal.y, v638.plane.normal.x) * (360 / (math.pi * 2)) + 180;
        else
            v639 = math.atan2(v638.plane.normal.y, v638.plane.normal.x) * (360 / (math.pi * 2)) - 180;
        end;
        local v640 = math.normalize_yaw(v637 - v639);
        if math.abs(v640) > 90 then
            return;
        else
            if v636.sidemove < -10 and v640 < 0 then
                v640 = 1;
            elseif v636.sidemove > 10 and v640 > 0 then
                v640 = -1;
            end;
            if v640 > 0 then
                v639 = v639 + 90;
            else
                v639 = v639 - 90;
            end;
            v639 = math.normalize_yaw(90 - v639);
            local l_end_pos_0 = v638.end_pos;
            l_end_pos_0.x = l_end_pos_0.x + math.sin(math.rad(v639)) * 45;
            l_end_pos_0.y = l_end_pos_0.y + math.cos(math.rad(v639)) * 45;
            v636.move_yaw = math.normalize_yaw(90 - v639);
            v636.in_speed = 0;
            local v642 = 0;
            v636.in_moveright = 0;
            v636.in_moveleft = v642;
            v636.forwardmove = 450;
            v636.sidemove = 0;
            return;
        end;
    end;
end;
ffi.cdef("            typedef struct\n            {\n                float x;\n                float y;\n                float z;\n            } Vector_t;\n        ");
v330.get_collideable = utils.get_vfunc(3, "uintptr_t*(__thiscall*)(void*)");
v330.get_obbMins = utils.get_vfunc(1, "Vector_t*(__thiscall*)(void*)");
v330.get_obbMaxs = utils.get_vfunc(2, "Vector_t*(__thiscall*)(void*)");
do
    local l_v330_2 = v330;
    l_v330_2.handle = function(v644)
        -- upvalues: v100 (ref), v30 (ref), l_v330_2 (ref)
        if not v100.elements.visuals.avoid_collisions then
            return;
        elseif v644.forwardmove < 0 then
            return;
        else
            local v645 = entity.get_local_player();
            if v645 == nil then
                return;
            elseif v645.m_MoveType ~= 2 or v30.state ~= v30.states.air and v30.state ~= v30.states.air_crouch then
                return;
            else
                local v646 = v645[0];
                local v647 = l_v330_2.get_collideable(v646);
                local v648 = l_v330_2.get_obbMins(v647);
                local v649 = l_v330_2.get_obbMaxs(v647);
                local v650 = vector(v648.x, v648.y, v648.z) * 0.85;
                local v651 = vector(v649.x, v649.y, v649.z) * 0.85;
                local v652 = render.camera_angles();
                v652.x = 0;
                local l_m_vecVelocity_0 = v645.m_vecVelocity;
                local v654 = l_m_vecVelocity_0:length();
                local _ = math.atan2(l_m_vecVelocity_0.y, l_m_vecVelocity_0.x);
                local v656 = v645:get_origin();
                local v657 = v656 + vector():angles(v652.x, v652.y) * (v654 * (globals.tickinterval * 5));
                local v658 = utils.trace_hull(v656, v657, v650, v651, entity.get_players(false, false), 33636363, 0);
                if v658.entity == nil then
                    return;
                elseif bit.band(v658.contents, 536870912) ~= 0 then
                    return;
                else
                    l_v330_2.change_yaw(v644, v652.y, v658);
                    return;
                end;
            end;
        end;
    end;
    v100.switch(v122.visuals.movement)(" \v\f<person-walking-arrow-loop-left>\r   \226\128\138Avoid Collisions")("visuals", "avoid_collisions", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 2;
    end);
    v100.refs.visuals.avoid_collisions:set_callback(function(v659)
        -- upvalues: l_v330_2 (ref)
        events.createmove(l_v330_2.handle, v659:get());
    end, true);
end;
v329.no_fall_damage = {};
v330 = v329.no_fall_damage;
v330.get = function(v660)
    -- upvalues: v30 (ref)
    local v661 = v30.entity:get_origin();
    local v662 = math.pi * 2;
    for v663 = 0, v662, v662 / 8 do
        local v664 = 10 * math.cos(v663) + v661.x;
        local v665 = 10 * math.sin(v663) + v661.y;
        if utils.trace_line(vector(v664, v665, v661.z), vector(v664, v665, v661.z - v660), v30.entity).fraction ~= 1 then
            return true;
        end;
    end;
    return false;
end;
do
    local l_v330_3 = v330;
    l_v330_3.handle = function(v667)
        -- upvalues: v30 (ref), l_v330_3 (ref)
        if not v30.valid then
            return;
        elseif v30.movetype == 8 or v30.movetype == 9 then
            return;
        else
            local l_m_vecVelocity_1 = v30.entity.m_vecVelocity;
            if l_m_vecVelocity_1.z < -500 then
                if l_m_vecVelocity_1.z >= -500 then
                    v667.in_duck = 0;
                elseif l_v330_3.get(15) then
                    v667.in_duck = 0;
                elseif l_v330_3.get(75) then
                    v667.in_duck = 1;
                end;
            end;
            return;
        end;
    end;
    v100.switch(v122.visuals.movement)("\226\128\138\226\128\138\v\f<person-falling>\r     No Fall Damage")("visuals", "no_fall_damage", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 2;
    end);
    v100.refs.visuals.no_fall_damage:set_callback(function(v669)
        -- upvalues: l_v330_3 (ref)
        events.createmove(l_v330_3.handle, v669:get());
    end, true);
end;
v329.super_toss = {};
v330 = v329.super_toss;
local v670 = 0.3;
local function v674(v671, v672, v673)
    return v671 + v673 * (v672 - v671);
end;
do
    local l_v330_4, l_v670_0, l_v674_0 = v330, v670, v674;
    local function v689(v678, v679, v680, v681)
        -- upvalues: l_v674_0 (ref), l_v670_0 (ref)
        v678.x = v678.x - 10 + math.abs(v678.x) / 9;
        local v682 = vector():angles(v678);
        local v683 = v681 * 1.25;
        local v684 = math.clamp(v679 * 0.9, 15, 750);
        local v685 = math.clamp(v680, 0, 1);
        v684 = v684 * l_v674_0(l_v670_0, 1, v685);
        local l_v682_0 = v682;
        for _ = 1, 8 do
            l_v682_0 = (v682 * (l_v682_0 * v684 + v683):length() - v683) / v684;
            l_v682_0:normalize();
        end;
        local v688 = l_v682_0.angles(l_v682_0);
        if v688.x > -10 then
            v688.x = 0.9 * v688.x + 9;
        else
            v688.x = 1.125 * v688.x + 11.25;
        end;
        return v688;
    end;
    l_v330_4.override_view = function(v690)
        -- upvalues: v689 (ref)
        local v691 = entity.get_local_player();
        if v691 == nil then
            return;
        else
            local v692 = v691:get_player_weapon();
            if v692 == nil then
                return;
            else
                local v693 = v692:get_weapon_info();
                if v693 == nil then
                    return;
                else
                    v690.angles = v689(v690.angles, v693.throw_velocity, v692.m_flThrowStrength, v690.velocity);
                    return;
                end;
            end;
        end;
    end;
    local _ = vector();
    local _ = vector();
    l_v330_4.handle = function(v696)
        -- upvalues: v689 (ref)
        if v696.jitter_move ~= true then
            return;
        else
            local v697 = entity.get_local_player();
            if v697 == nil then
                return;
            else
                local v698 = v697:get_player_weapon();
                if v698 == nil then
                    return;
                else
                    local v699 = v698:get_weapon_info();
                    if v699 == nil or v699.weapon_type ~= 9 then
                        return;
                    elseif v698.m_fThrowTime < globals.curtime - to_time(globals.clock_offset) then
                        return;
                    else
                        v696.in_speed = true;
                        local v700 = v697:simulate_movement();
                        v700:think();
                        v696.view_angles = v689(v696.view_angles, v699.throw_velocity, v698.m_flThrowStrength, v700.velocity);
                        return;
                    end;
                end;
            end;
        end;
    end;
    v100.switch(v122.visuals.movement)("\226\128\138\226\128\138\v\f<bomb>\r    Super Toss")("visuals", "super_toss", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 2;
    end);
    v100.refs.visuals.super_toss:set_callback(function(v701)
        -- upvalues: l_v330_4 (ref)
        events.createmove(l_v330_4.handle, v701:get());
        events.grenade_override_view(l_v330_4.override_view, v701:get());
    end, true);
end;
v329.edge_stop = {};
v330 = v329.edge_stop;
v330.handle = function(v702)
    -- upvalues: v30 (ref)
    if not v30.valid then
        return;
    else
        local v703 = v30.entity:simulate_movement();
        v703:think(5);
        if v703.velocity.z < 0 then
            v702.block_movement = 2;
        end;
        return;
    end;
end;
v100.switch(v122.visuals.movement)("\226\128\138\226\128\138\v\f<block-brick>\r     Edge Stop")("visuals", "edge_stop", function()
    -- upvalues: v100 (ref)
    return v100.elements.visuals.tab_selector == 2;
end);
do
    local l_v330_5 = v330;
    v100.refs.visuals.edge_stop:set_callback(function(v705)
        -- upvalues: l_v330_5 (ref)
        events.createmove(l_v330_5.handle, v705:get());
    end, true);
end;
v329.fast_ladder = {};
v330 = v329.fast_ladder;
v330.handle = function(v706)
    -- upvalues: v30 (ref)
    if not v30.valid then
        return;
    elseif v30.weapon.m_bPinPulled then
        return;
    elseif v30.movetype ~= 9 then
        return;
    elseif v706.forwardmove == 0 then
        return;
    else
        local v707 = v706.forwardmove < 0;
        v706.view_angles.x = 89;
        v706.view_angles.y = math.normalize_yaw(v706.move_yaw + 90);
        v706.in_moveleft = v707 and 1 or 0;
        v706.in_moveright = v707 and 0 or 1;
        v706.in_forward = v707 and 1 or 0;
        v706.in_back = v707 and 0 or 1;
        return;
    end;
end;
v100.switch(v122.visuals.movement)(" \v\f<water-ladder>\r    Fast Ladder")("visuals", "fast_ladder", function()
    -- upvalues: v100 (ref)
    return v100.elements.visuals.tab_selector == 2;
end);
do
    local l_v330_6 = v330;
    v100.refs.visuals.fast_ladder:set_callback(function(v709)
        -- upvalues: l_v330_6 (ref)
        events.createmove(l_v330_6.handle, v709:get());
    end, true);
end;
v329.fast_fall = {};
v330 = v329.fast_fall;
v330.handle = function(v710)
    -- upvalues: v30 (ref)
    if not v30.valid then
        return;
    else
        local v711 = utils.trace_line(v30.origin, v30.origin - vector(0, 0, 75), v30.entity);
        local l_m_vecVelocity_2 = v30.entity.m_vecVelocity;
        if l_m_vecVelocity_2.z > -500 and l_m_vecVelocity_2.z < -350 and not v710.in_jump and v711.fraction ~= 1 then
            rage.exploit:force_teleport();
        end;
        return;
    end;
end;
v100.switch(v122.visuals.movement)("\226\128\138\226\128\138\v\f<person-rays>\r   \226\128\138\226\128\138Fast Fall")("visuals", "fast_fall", function()
    -- upvalues: v100 (ref)
    return v100.elements.visuals.tab_selector == 2;
end);
do
    local l_v330_7 = v330;
    v100.refs.visuals.fast_fall:set_callback(function(v714)
        -- upvalues: l_v330_7 (ref)
        events.createmove(l_v330_7.handle, v714:get());
    end, true);
end;
v330 = {
    nickname = {}
};
v670 = v330.nickname;
v670.panorama_name = panorama.MyPersonaAPI.GetName();
v674 = function(v715, v716, v717)
    return ffi.cast(v717, ffi.cast("void***", v715)[0][v716]);
end;
do
    local l_v670_1, l_v674_1 = v670, v674;
    local function v724(v720, v721)
        -- upvalues: l_v674_1 (ref)
        local v722 = ffi.typeof(v721);
        return function(v723, ...)
            -- upvalues: l_v674_1 (ref), v720 (ref), v722 (ref)
            assert(v723 ~= nil);
            if v723 then
                return l_v674_1(v723, v720, v722)(v723, ...);
            else
                return;
            end;
        end;
    end;
    local v725 = ffi.cast("uintptr_t**", utils.opcode_scan("engine.dll", "A1 ? ? ? ? 0F 28 C1 F3 0F 5C 80 ? ? ? ? F3 0F 11 45 ? A1 ? ? ? ? 56 85 C0 75 04 33 F6 EB 26 80 78 14 00 74 F6 8B 4D 08 33 D2 E8 ? ? ? ? 8B F0 85 F6", 1));
    local v726 = ffi.typeof("            struct {\n                int64_t         unknown;\n                int64_t         steamID64;\n                char            szName[128];\n                int             userId;\n                char            szSteamID[20];\n                char            pad_0x00A8[0x10];\n                unsigned long   iSteamID;\n                char            szFriendsName[128];\n                bool            fakeplayer;\n                bool            ishltv;\n                unsigned int    customfiles[4];\n                unsigned char   filesdownloaded;\n            }\n        ");
    local v727 = v724(11, ffi.typeof("$*(__thiscall*)(void*, int, int*)", v726));
    l_v670_1.set = function(v728)
        -- upvalues: v30 (ref), v725 (ref), v727 (ref)
        if not v30.entity then
            return;
        else
            local v729 = v725[0][0];
            if not v729 then
                return;
            else
                local v730 = ffi.cast("void***", v729 + 21184)[0];
                if not v730 then
                    return;
                else
                    local v731 = v727(v730, v30.entity:get_index() - 1, nil);
                    if not v731 then
                        return;
                    else
                        v731[0].szName = ffi.new("char[128]", v728);
                        return;
                    end;
                end;
            end;
        end;
    end;
    l_v670_1.handle = function()
        -- upvalues: v100 (ref), l_v670_1 (ref)
        local v732 = v100.elements.visuals.nickname_input:sub(0, 32);
        if v732 == "" then
            v732 = " ";
        end;
        local l_set_0 = l_v670_1.set;
        local v734;
        if not v100.elements.visuals.nickname or not v732 then
            v734 = l_v670_1.panorama_name;
        else
            v734 = v732;
        end;
        l_set_0(v734);
    end;
    l_v670_1.reset = function()
        -- upvalues: l_v670_1 (ref)
        l_v670_1.set(l_v670_1.panorama_name);
    end;
    v100.switch(v122.visuals.misc)(" \v\f<user-secret>\r   \226\128\138\226\128\138Client-Side Nickname")("visuals", "nickname", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 2;
    end)(function(v735, v736)
        -- upvalues: v100 (ref), l_v670_1 (ref)
        v100.input(v735)("Nickname", l_v670_1.panorama_name)("visuals", "nickname_input", v736);
    end);
    l_v670_1.handle();
    v100.refs.visuals.nickname:set_callback(function(v737)
        -- upvalues: l_v670_1 (ref), v100 (ref)
        l_v670_1.handle();
        v100.refs.visuals.nickname_input:set_callback(l_v670_1.handle, v737:get());
        events.round_start(l_v670_1.handle, v737:get());
        events.shutdown(l_v670_1.reset, v737:get());
    end, true);
end;
v330.voice = {};
v670 = v330.voice;
v670.toggle_mute = panorama.FriendsListAPI.ToggleMute;
v670.is_muted = panorama.FriendsListAPI.IsSelectedPlayerMuted;
do
    local l_v670_2 = v670;
    l_v670_2.handle = function()
        -- upvalues: v100 (ref), l_v670_2 (ref)
        if not v100.elements.visuals.voice then
            return;
        else
            local _ = entity.get_players(v100.elements.visuals.voice_enemy, true, function(v739)
                -- upvalues: l_v670_2 (ref), v100 (ref)
                local l_steamid64_0 = v739:get_player_info().steamid64;
                local v741 = l_v670_2.is_muted(l_steamid64_0);
                if v100.elements.visuals.voice_settings == 1 and not v741 then
                    l_v670_2.toggle_mute(l_steamid64_0);
                elseif v100.elements.visuals.voice_settings == 2 and v741 then
                    l_v670_2.toggle_mute(l_steamid64_0);
                end;
            end);
            return;
        end;
    end;
    v100.switch(v122.visuals.misc)(" \v\f<headset>\r   \226\128\138Mute/Unmute Silenced")("visuals", "voice", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 2;
    end)(function(v743, v744)
        -- upvalues: v100 (ref)
        v100.list(v743)("", {
            [1] = "Mute", 
            [2] = "Unmute"
        })("visuals", "voice_settings", v744);
        v100.switch(v743)("Only Enemy")("visuals", "voice_enemy", v744);
    end);
    l_v670_2.handle();
    v100.refs.visuals.voice:set_callback(function(v745)
        -- upvalues: l_v670_2 (ref), v100 (ref)
        l_v670_2.handle();
        v100.refs.visuals.voice_settings:set_callback(l_v670_2.handle, v745:get());
        v100.refs.visuals.voice_enemy:set_callback(l_v670_2.handle, v745:get());
        events.round_start(l_v670_2.handle, v745:get());
    end, true);
end;
v330.game_focus = {};
v670 = v330.game_focus;
ffi.cdef("            void* GetForegroundWindow();\n            int FlashWindow(void*, int);\n        ");
v670.hwnd_ptr = ffi.cast("void**", ffi.cast("char*", ffi.cast("void***", utils.opcode_scan("engine.dll", "8B 0D ? ? ? ? 85 C9 74 16 8B 01 8B", 2) or error("invalid signature"))[0][0]) + 8);
do
    local l_v670_3 = v670;
    l_v670_3.flash_window = function()
        -- upvalues: l_v670_3 (ref)
        local v747 = l_v670_3.hwnd_ptr[0];
        if ffi.C.GetForegroundWindow() ~= v747 then
            ffi.C.FlashWindow(v747, 1);
        end;
    end;
    v100.switch(v122.visuals.misc)("\226\128\138\v\f<triangle-exclamation>\r   \226\128\138Notify on Round Start")("visuals", "game_focus", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 2;
    end);
    v100.refs.visuals.game_focus:set_callback(function(v748)
        -- upvalues: l_v670_3 (ref)
        events.round_start(l_v670_3.flash_window, v748:get());
    end, true);
end;
v330.animations = {};
v670 = v330.animations;
ffi.cdef("            typedef struct {\n                char  pad_0000[20];\n                int m_nOrder; //0x0014\n                int m_nSequence; //0x0018\n                float m_flPrevCycle; //0x001C\n                float m_flWeight; //0x0020\n                float m_flWeightDeltaRate; //0x0024\n                float m_flPlaybackRate; //0x0028\n                float m_flCycle; //0x002C\n                void *m_pOwner; //0x0030\n                char  pad_0038[4]; //0x0034\n            } CAnimationLayer;\n        ");
v670.get_anim_layer = function(v749, v750)
    return ffi.cast("CAnimationLayer**", ffi.cast("char*", ffi.cast(ffi.typeof("void***"), v749)) + 10640)[0][v750];
end;
v670.on_ground = {
    Static = function(v751)
        -- upvalues: v20 (ref)
        v751[0] = 1;
        v20.setup("legs", "Sliding");
    end, 
    Walking = function(v752)
        -- upvalues: v20 (ref)
        v752[7] = 0;
        v20.setup("legs", "Walking");
    end, 
    Jitter = function(v753)
        -- upvalues: v20 (ref)
        v753[0] = globals.tickcount % 4 > 1 and 1 or 0.5;
        v20.setup("legs", "Sliding");
    end, 
    Random = function(v754)
        -- upvalues: v20 (ref)
        v754[0] = utils.random_float(0, 1);
        v20.setup("legs", "Sliding");
    end
};
do
    local l_v670_4 = v670;
    l_v670_4.in_air = {
        Static = function(v756)
            v756[6] = 1;
        end, 
        Walking = function(_, v758)
            -- upvalues: v30 (ref), l_v670_4 (ref)
            if v30.state == v30.states.air or v30.state == v30.states.air_crouch then
                l_v670_4.get_anim_layer(v758, 6).m_flWeight = 1;
            end;
        end, 
        Jitter = function(v759)
            v759[6] = globals.tickcount % 4 > 1 and 0 or 1;
        end, 
        Random = function(v760)
            v760[6] = utils.random_float(0, 1);
        end
    };
    l_v670_4.handle = function()
        -- upvalues: v30 (ref), l_v670_4 (ref), v100 (ref)
        if not v30.valid then
            return;
        else
            local l_m_flPoseParameter_0 = v30.entity.m_flPoseParameter;
            local v762 = v30.entity:get_anim_state();
            local v763 = v30.entity[0];
            local v764 = l_v670_4.on_ground[v100.elements.visuals.animations_on_ground];
            local v765 = l_v670_4.in_air[v100.elements.visuals.animations_in_air];
            if v764 then
                v764(l_m_flPoseParameter_0);
            end;
            if v765 then
                v765(l_m_flPoseParameter_0, v763);
            end;
            if v100.elements.visuals.animations_pitch_on_land and v762.landing and not v30.jumping then
                l_m_flPoseParameter_0[12] = 0.5;
            end;
            if v100.elements.visuals.animations_sliding_slow_walk then
                l_m_flPoseParameter_0[9] = 0;
            end;
            if v100.elements.visuals.animations_sliding_crouch then
                l_m_flPoseParameter_0[8] = 0;
            end;
            if v100.elements.visuals.animations_earthquake then
                l_v670_4.get_anim_layer(v763, 12).m_flWeight = utils.random_float(0, 1);
            elseif v100.elements.visuals.animations_move_lean > 0 and v30.velocity > 2 then
                l_v670_4.get_anim_layer(v763, 12).m_flWeight = v100.elements.visuals.animations_move_lean * 0.01;
            end;
            return;
        end;
    end;
    v100.switch(v122.visuals.misc)(" \v\f<person-praying>\r   \226\128\138\226\128\138Anim. Breakers")("visuals", "animations", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 2;
    end)(function(v766, v767)
        -- upvalues: v100 (ref)
        v100.combo(v766)("On Ground", {
            [1] = "Disabled", 
            [2] = "Static", 
            [3] = "Walking", 
            [4] = "Jitter", 
            [5] = "Random"
        })("visuals", "animations_on_ground", v767);
        v100.combo(v766)("In Air", {
            [1] = "Disabled", 
            [2] = "Static", 
            [3] = "Walking", 
            [4] = "Jitter", 
            [5] = "Random"
        })("visuals", "animations_in_air", v767);
        v100.switch(v766)("Pitch 0 on Land")("visuals", "animations_pitch_on_land", v767);
        v100.switch(v766)("Sliding Slow Walk")("visuals", "animations_sliding_slow_walk", v767);
        v100.switch(v766)("Sliding Crouch")("visuals", "animations_sliding_crouch", v767);
        v100.switch(v766)("Earthquake")("visuals", "animations_earthquake", v767);
        v100.slider(v766)("Move Lean", 0, 100, 0, nil, "%")("visuals", "animations_move_lean", v767);
    end);
    v100.refs.visuals.animations:set_callback(function(v768)
        -- upvalues: l_v670_4 (ref)
        events.post_update_clientside_animation(l_v670_4.handle, v768:get());
    end, true);
end;
v670 = {
    icon = {
        link = "https://eternal.codes/download/logos/eternal_shared.png"
    }
};
v674 = v670.icon;
local l_GetPlayerXuidStringFromEntIndex_0 = panorama.GameStateAPI.GetPlayerXuidStringFromEntIndex;
do
    local l_v674_2, l_l_GetPlayerXuidStringFromEntIndex_0_0 = v674, l_GetPlayerXuidStringFromEntIndex_0;
    local function v775(v772)
        -- upvalues: l_l_GetPlayerXuidStringFromEntIndex_0_0 (ref)
        if not v772 then
            return;
        else
            local v773 = l_l_GetPlayerXuidStringFromEntIndex_0_0(v772:get_index());
            if not v773 then
                return;
            else
                local v774 = v773:sub(4, -1);
                if #v774 == 0 then
                    return;
                else
                    return 76500000000000000ULL + tonumber(v774);
                end;
            end;
        end;
    end;
    local v776 = {
        channel = 1200, 
        hash = ("%s::networking"):format(v6.name:lower())
    };
    ffi.cdef("                uint32_t GetModuleHandleA(const char* lpModuleName);\n                uint32_t GetProcAddress(uint32_t hModule, const char* lpProcName);\n            ");
    local v777 = ffi.typeof("                struct {\n                    int m_eType;\n                    int m_cbSize;\n                    union {\n                        uint64_t m_steamID64;\n                        char m_szGenericString[ 32 ];\n                        uint8_t m_genericBytes[ 32 ];\n                        char m_szUnknownRawString[ 128 ];\n                        void* m_ip;\n                        uint32_t m_reserved[ 32 ];\n                    };\n                }\n            ");
    local v778 = ffi.typeof("                struct {\n                    void* m_pData;\n                    int m_cbSize;\n                    unsigned int m_conn;\n                    $ m_identityPeer;\n                    int64_t m_nConnUserData;\n                    long long m_usecTimeReceived;\n                    int64_t m_nMessageNumber;\n                    void(__thiscall* m_pfnFreeData)(void*);\n                    void(__thiscall* m_pfnRelease)(void*);\n                    int m_nChannel;\n                    int m_nFlags;\n                    int64_t m_nUserData;\n                }\n            ", v777);
    local v779 = ffi.C.GetProcAddress(ffi.C.GetModuleHandleA("steamnetworkingsockets.dll"), "SteamNetworkingMessages_LibV2");
    assert(v779 ~= 0, "failed to get steam_networking_messages");
    local l_v777_0 = v777;
    local v781 = ffi.typeof("$* [?]", v778);
    local v782 = ffi.cast("void***", ffi.cast("void*(__thiscall*)()", v779)());
    local v783 = ffi.cast(ffi.typeof("int(__thiscall*)(void*, const $&, const void *, uint32_t, int, int)", v777), v782[0][0]);
    local v784 = ffi.cast(ffi.typeof("int(__thiscall*)(void*, int, $, int)", v781), v782[0][1]);
    local v785 = ffi.cast(ffi.typeof("bool(__thiscall*)(void*, const $&)", v777), v782[0][2]);
    local v786 = ffi.cast(ffi.typeof("bool(__thiscall*)(void*, const $&)", v777), v782[0][3]);
    do
        local l_l_v777_0_0, l_v781_0, l_v782_0, l_v783_0, l_v784_0, l_v785_0, l_v786_0 = l_v777_0, v781, v782, v783, v784, v785, v786;
        v776.send_message = function(v794, v795, v796)
            -- upvalues: l_l_v777_0_0 (ref), l_v783_0 (ref), l_v782_0 (ref), v776 (ref)
            local v797 = ffi.cast("uint64_t", v794);
            local v798 = ffi.cast("const char*", v795);
            local v799 = l_l_v777_0_0();
            v799.m_eType = 16;
            v799.m_cbSize = ffi.sizeof(v797);
            v799.m_steamID64 = v797;
            return l_v783_0(l_v782_0, v799, v798, v795:len(), 8, v796 or v776.channel);
        end;
        v776.receive_message = function(v800)
            -- upvalues: l_v781_0 (ref), l_v784_0 (ref), l_v782_0 (ref), v776 (ref)
            local v801 = l_v781_0(1337);
            return l_v784_0(l_v782_0, v800 or v776.channel, v801, 1337), v801;
        end;
        v776.close_connection = function(v802)
            -- upvalues: l_l_v777_0_0 (ref), l_v786_0 (ref), l_v782_0 (ref)
            local v803 = ffi.cast("uint64_t", v802);
            local v804 = l_l_v777_0_0();
            v804.m_eType = 16;
            v804.m_cbSize = ffi.sizeof(v803);
            v804.m_steamID64 = v803;
            return l_v786_0(l_v782_0, v804);
        end;
        v776.accept_session = function(v805)
            -- upvalues: l_l_v777_0_0 (ref), l_v785_0 (ref), l_v782_0 (ref)
            local v806 = ffi.cast("uint64_t", v805);
            local v807 = l_l_v777_0_0();
            v807.m_eType = 16;
            v807.m_cbSize = ffi.sizeof(v806);
            v807.m_steamID64 = v806;
            return l_v785_0(l_v782_0, v807);
        end;
    end;
    l_v674_2.flush = function()
        -- upvalues: v30 (ref)
        if not v30.entity then
            return;
        else
            v30.entity:set_icon();
            for _, v809 in pairs(entity.get_players()) do
                v809:set_icon();
            end;
            return;
        end;
    end;
    l_v674_2.parse = function(v810)
        -- upvalues: v776 (ref)
        if not v810 or not v810:find(v776.hash) then
            return;
        else
            local v811 = string.gmatch(v810, "([^[[]+)([]]]+)")();
            if not v811 or #v811 == 0 then
                return;
            else
                local l_status_13, l_result_13 = pcall(json.parse, v811);
                if not l_status_13 then
                    return;
                else
                    return l_result_13;
                end;
            end;
        end;
    end;
    l_v674_2.update_local = function()
        -- upvalues: v30 (ref), l_v674_2 (ref)
        if not v30.entity then
            return;
        else
            v30.entity:set_icon(l_v674_2.link);
            return;
        end;
    end;
    l_v674_2.send_message = function()
        -- upvalues: v30 (ref), v776 (ref), v775 (ref)
        if not v30.entity then
            return;
        else
            local v814 = {
                index = v30.entity:get_index(), 
                hash = v776.hash
            };
            local v815 = ("[[%s]]"):format(json.stringify(v814));
            for _, v817 in pairs(entity.get_players()) do
                if v817 ~= v30.entity then
                    local v818 = v775(v817);
                    if v818 then
                        v776.close_connection(v818);
                        v776.send_message(v818, v815);
                    end;
                end;
            end;
            return;
        end;
    end;
    l_v674_2.accept_session = function()
        -- upvalues: v30 (ref), v775 (ref), v776 (ref)
        if not v30.entity then
            return;
        else
            for _, v820 in pairs(entity.get_players()) do
                if v820 ~= v30.entity then
                    local v821 = v775(v820);
                    if v821 then
                        v776.accept_session(v821);
                    end;
                end;
            end;
            return;
        end;
    end;
    l_v674_2.receive_message = function()
        -- upvalues: v776 (ref), l_v674_2 (ref)
        local v822, v823 = v776.receive_message();
        for v824 = 1, v822 do
            local v825 = v823[v824 - 1][0];
            if v825 then
                local v826 = l_v674_2.parse(ffi.string(v825.m_pData));
                if v826 then
                    local v827 = entity.get(v826.index);
                    if v827 then
                        v827:set_icon(l_v674_2.link);
                    end;
                end;
            end;
        end;
    end;
    v100.switch(v122.visuals.shared)(" \v\f<share-nodes>\r    \226\128\138Shared Icon")("visuals", "icon", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 2;
    end);
    v100.refs.visuals.icon:set_callback(function(v828)
        -- upvalues: l_v674_2 (ref)
        if not v828:get() then
            l_v674_2.flush();
        end;
        events.round_end:set(function()
            -- upvalues: v828 (ref), l_v674_2 (ref)
            if v828:get() then
                l_v674_2.send_message();
                l_v674_2.flush();
            end;
        end);
        events.round_prestart:set(function()
            -- upvalues: v828 (ref), l_v674_2 (ref)
            if v828:get() then
                l_v674_2.update_local();
                l_v674_2.accept_session();
                l_v674_2.receive_message();
            end;
        end);
        events.shutdown:set(function()
            -- upvalues: v828 (ref), l_v674_2 (ref)
            if v828:get() then
                l_v674_2.flush();
            end;
        end);
    end, true);
end;
v670.clantag = {};
v674 = v670.clantag;
v674.clanid = cvar.cl_clanid;
v674.tag = {
    [1] = "", 
    [2] = "e", 
    [3] = "et", 
    [4] = "ete", 
    [5] = "eter", 
    [6] = "etern", 
    [7] = "eterna", 
    [8] = "eternal", 
    [9] = "eternal.", 
    [10] = "eternal.c", 
    [11] = "eternal.co", 
    [12] = "eternal.cod", 
    [13] = "eternal.code", 
    [14] = "eternal.codes", 
    [15] = "eternal.codes", 
    [16] = "eternal.codes", 
    [17] = "eternal.codes", 
    [18] = "eternal.codes", 
    [19] = "eternal.codes", 
    [20] = "ternal.codes", 
    [21] = "ernal.codes", 
    [22] = "rnal.codes", 
    [23] = "nal.codes", 
    [24] = "al.codes", 
    [25] = "l.codes", 
    [26] = ".codes", 
    [27] = "codes", 
    [28] = "odes", 
    [29] = "des", 
    [30] = "des", 
    [31] = "es", 
    [32] = "s", 
    [33] = ""
};
v674.cache = nil;
do
    local l_v674_3 = v674;
    l_v674_3.set = function(v830)
        -- upvalues: l_v674_3 (ref)
        if v830 ~= l_v674_3.cache then
            common.set_clan_tag(v830 or "");
            l_v674_3.cache = v830;
        end;
    end;
    l_v674_3.clear = function()
        -- upvalues: l_v674_3 (ref)
        l_v674_3.set("");
        l_v674_3.clanid:call(l_v674_3.clanid:string());
    end;
    l_v674_3.handle = function()
        -- upvalues: l_v674_3 (ref)
        if not globals.is_connected then
            return;
        elseif not globals.is_in_game then
            return;
        else
            local v831 = utils.net_channel();
            if v831 == nil then
                return;
            else
                local v832 = globals.tickcount + to_ticks(v831.latency[0]);
                local v833 = math.floor(math.fmod(v832 / 16, #l_v674_3.tag + 1) + 1);
                l_v674_3.set(l_v674_3.tag[v833]);
                return;
            end;
        end;
    end;
    v100.switch(v122.visuals.shared)(" \v\f<tags>\r    Clan Tag")("visuals", "clantag", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 2;
    end);
    l_v674_3.clear();
    v100.refs.visuals.clantag:set_callback(function(v834)
        -- upvalues: l_v674_3 (ref)
        l_v674_3.clear();
        events.net_update_end(l_v674_3.handle, v834:get());
        events.shutdown(l_v674_3.clear, v834:get());
    end, true);
end;
v670.trashtalk = {};
v674 = v670.trashtalk;
v674.phrases = v10.read("trashtalk") or {
    [1] = "@target buy eternal.codes to get better", 
    [2] = "@target, maybe if you used eternal.codes, you wouldn't be dying so often.", 
    [3] = "@target, eternal.codes could save you from being such an easy target.", 
    [4] = "@target, without eternal.codes, no wonder you're always the first to die.", 
    [5] = "@target, you might actually survive a match if you tried eternal.codes.", 
    [6] = "@target, eternal.codes might be the only thing that can save you from your noob status.", 
    [7] = "@target, eternal.codes could help you stop being the team's dead weight.", 
    [8] = "@target, maybe eternal.codes will teach you how to play properly.", 
    [9] = "@target, if you had eternal.codes, you wouldn't be dying like a beginner.", 
    [10] = "@target, eternal.codes could finally give you a fighting chance.", 
    [11] = "@target, eternal.codes might prevent you from embarrassing yourself in-game.", 
    [12] = "@target, try eternal.codes and stop being the team's liability.", 
    [13] = "@target, maybe eternal.codes will help you get a kill for once.", 
    [14] = "@target, eternal.codes could be the answer to your constant deaths.", 
    [15] = "@target, use eternal.codes and see if you can survive longer than two minutes.", 
    [16] = "@target, eternal.codes might turn you from cannon fodder to a real player.", 
    [17] = "@target, without eternal.codes, you're just an easy kill.", 
    [18] = "@target, eternal.codes could help you stop being the laughing stock of the game.", 
    [19] = "@target, maybe eternal.codes can teach you how not to die every round.", 
    [20] = "@target, if you had eternal.codes, you might actually contribute to the team.", 
    [21] = "@target, eternal.codes could make you less of a burden on your teammates."
};
do
    local l_v674_4 = v674;
    l_v674_4.handle = function(v836)
        -- upvalues: v30 (ref), l_v674_4 (ref)
        if not v30.valid then
            return;
        else
            local v837 = entity.get(v836.userid, true);
            if v837 == nil then
                return;
            else
                local v838 = entity.get(v836.attacker, true);
                if v838 == nil then
                    return;
                else
                    local v839 = l_v674_4.phrases[utils.random_int(1, #l_v674_4.phrases)];
                    if v839 == nil then
                        return;
                    else
                        if v838 == v30.entity and v837 ~= v30.entity then
                            utils.console_exec(("say %s"):format(v839:gsub("@target", v837:get_name())));
                        end;
                        return;
                    end;
                end;
            end;
        end;
    end;
    v100.switch(v122.visuals.shared)(" \v\f<trash>\r    \226\128\138Trashtalk")("visuals", "trashtalk", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 2;
    end)(function(v840, v841)
        -- upvalues: v100 (ref), l_v674_4 (ref), v10 (ref)
        v100.list(v840)("", #l_v674_4.phrases ~= 0 and l_v674_4.phrases or {
            [1] = "\aFFFFFF64Empty"
        })("visuals", "trashtalk_phrases", v841);
        v100.input(v840)("New Phrase")("visuals", "trashtalk_input", v841);
        v100.button(v840)("Add", function()
            -- upvalues: l_v674_4 (ref), v100 (ref), v10 (ref)
            table.insert(l_v674_4.phrases, v100.elements.visuals.trashtalk_input);
            v10.write("trashtalk", l_v674_4.phrases);
            v100.refs.visuals.trashtalk_phrases:update(#l_v674_4.phrases ~= 0 and l_v674_4.phrases or {
                [1] = "\aFFFFFF64Empty"
            });
            common.add_notify("Eternal", ("Succesfully added new phrase, %s."):format(phrase));
        end, true)("visuals", "trashtalk_add", v841);
        v100.button(v840)("Remove", function()
            -- upvalues: l_v674_4 (ref), v100 (ref), v10 (ref)
            local v842 = l_v674_4.phrases[v100.elements.visuals.trashtalk_phrases];
            table.remove(l_v674_4.phrases, v100.elements.visuals.trashtalk_phrases);
            v10.write("trashtalk", l_v674_4.phrases);
            v100.refs.visuals.trashtalk_phrases:update(#l_v674_4.phrases ~= 0 and l_v674_4.phrases or {
                [1] = "\aFFFFFF64Empty"
            });
            common.add_notify("Eternal", ("Successfully removed phrase, %s."):format(v842));
        end, true)("visuals", "trashtalk_remove", v841);
    end):tooltip("This feature allows you to add and remove trash talk phrases\n\nWhen you add new trash talk phrase, writing \v@target\r will be changed with the targets name you killed.");
    v100.refs.visuals.trashtalk:set_callback(function(v843)
        -- upvalues: l_v674_4 (ref)
        events.player_death(l_v674_4.handle, v843:get());
    end, true);
end;
v674 = {
    switch = {}
};
l_GetPlayerXuidStringFromEntIndex_0 = v674.switch;
l_GetPlayerXuidStringFromEntIndex_0.handle = function(v844)
    -- upvalues: v30 (ref), v19 (ref), v20 (ref)
    if not v30.valid then
        return;
    elseif entity.get(v844.userid, true) ~= v30.entity then
        return;
    else
        local v845 = v19.weapon_actions:get_override() or v19.weapon_actions:get();
        for v846 = 1, #v845 do
            if v845[v846] == "Quick Switch" then
                table.remove(v845, v846);
            end;
        end;
        v20.setup("weapon_actions", v845);
        utils.console_exec("slot3; slot2; slot1");
        return;
    end;
end;
events.grenade_thrown(l_GetPlayerXuidStringFromEntIndex_0.handle);
if v6.build == "Alpha" then
    v674.dormant_aimbot = {};
    l_GetPlayerXuidStringFromEntIndex_0 = v674.dormant_aimbot;
    l_GetPlayerXuidStringFromEntIndex_0.roundstarted = 0;
    l_GetPlayerXuidStringFromEntIndex_0.autoscope = function(v847)
        -- upvalues: v30 (ref)
        if not v30.scoped and v30.weapon.weapon_type == 5 then
            v847.in_attack2 = true;
        end;
    end;
    do
        local l_l_GetPlayerXuidStringFromEntIndex_0_1 = l_GetPlayerXuidStringFromEntIndex_0;
        l_l_GetPlayerXuidStringFromEntIndex_0_1.handle = function(v849)
            -- upvalues: v100 (ref), v30 (ref), l_l_GetPlayerXuidStringFromEntIndex_0_1 (ref)
            if not v100.elements.visuals.dormant_aimbot_bind then
                return;
            elseif not v30.valid then
                return;
            elseif globals.tickcount < l_l_GetPlayerXuidStringFromEntIndex_0_1.roundstarted then
                return;
            elseif v30.weapon.weapon_type == 9 or v30.weapon.weapon_type == 0 then
                return;
            else
                local l_m_flSimulationTime_0 = v30.entity.m_flSimulationTime;
                if (not v30.weapon.is_revolver or v30.weapon.m_flNextPrimaryAttack >= l_m_flSimulationTime_0) and math.max(v30.entity.m_flNextAttack, v30.weapon.m_flNextPrimaryAttack, v30.weapon.m_flNextSecondaryAttack) >= l_m_flSimulationTime_0 then
                    return;
                else
                    local v851 = v30.entity:get_eye_position();
                    local l_m_aimPunchAngle_0 = v30.entity.m_aimPunchAngle;
                    entity.get_players(true, true, function(v853)
                        -- upvalues: v100 (ref), v30 (ref), v851 (ref), v849 (ref), l_l_GetPlayerXuidStringFromEntIndex_0_1 (ref), l_m_aimPunchAngle_0 (ref)
                        if not v853:is_dormant() or not v853:is_enemy() or v853:get_network_state() == 5 or v853:get_network_state() == 0 then
                            return;
                        else
                            local l_alpha_0 = v853:get_bbox().alpha;
                            if not (math.floor(l_alpha_0 * 100) > v100.elements.visuals.dormant_aimbot_accuracy) then
                                return;
                            else
                                local v855 = v853:get_origin() + vector(0, 0, 40);
                                local v857, v858 = utils.trace_bullet(v30.entity, v851, v855, function(v856)
                                    -- upvalues: v853 (ref)
                                    return v856 == v853;
                                end);
                                if v858:did_hit_non_world() or not v858:did_hit_world() and v858.entity ~= v853 or v858:did_hit_world() and v858.entity:get_classname() ~= "CWorld" then
                                    return;
                                else
                                    if v100.elements.visuals.dormant_aimbot_dmg < v857 then
                                        v849.block_movement = 1;
                                        l_l_GetPlayerXuidStringFromEntIndex_0_1.autoscope(v849);
                                        if v30.weapon.weapon_inaccuracy < 0.02 then
                                            local v859 = v851:to(v855):angles();
                                            l_m_aimPunchAngle_0.x = l_m_aimPunchAngle_0.x * 2;
                                            l_m_aimPunchAngle_0.y = l_m_aimPunchAngle_0.y * 2;
                                            v849.view_angles = v859 - l_m_aimPunchAngle_0;
                                            v849.in_attack = true;
                                        end;
                                    end;
                                    return;
                                end;
                            end;
                        end;
                    end);
                    return;
                end;
            end;
        end;
        l_l_GetPlayerXuidStringFromEntIndex_0_1.reset = function()
            -- upvalues: l_l_GetPlayerXuidStringFromEntIndex_0_1 (ref)
            local v860 = (cvar.mp_freezetime:float() + 1) / globals.tickinterval;
            l_l_GetPlayerXuidStringFromEntIndex_0_1.roundstarted = globals.tickcount + v860;
        end;
        v100.switch(v122.visuals.ragebot)(" \v\f<ghost>\r     Dormant Aimbot")("visuals", "dormant_aimbot", function()
            -- upvalues: v100 (ref)
            return v100.elements.visuals.tab_selector == 3;
        end)(function(v861, v862)
            -- upvalues: v100 (ref)
            v100.slider(v861)("Min. Damage", 0, 100, 10)("visuals", "dormant_aimbot_dmg", v862);
            v100.slider(v861)("Accuracy", 0, 100, 90)("visuals", "dormant_aimbot_accuracy", v862);
            v100.switch(v861)("Bind")("visuals", "dormant_aimbot_bind", v862);
        end);
        v100.refs.visuals.dormant_aimbot:set_callback(function(v863)
            -- upvalues: l_l_GetPlayerXuidStringFromEntIndex_0_1 (ref)
            events.createmove(l_l_GetPlayerXuidStringFromEntIndex_0_1.handle, v863:get());
            events.round_prestart(l_l_GetPlayerXuidStringFromEntIndex_0_1.reset, v863:get());
        end, true);
    end;
end;
if v6.build == "Alpha" then
    v674.ai_peek = {};
    l_GetPlayerXuidStringFromEntIndex_0 = bit.lshift(1, 0);
    local v864 = 0;
    local v865 = 1;
    local v866 = 2;
    local v867 = 3;
    local v868 = 4;
    local v869 = 5;
    local v870 = 6;
    local v871 = 7;
    local _ = 10;
    local v873 = 0;
    local _ = 1;
    local _ = 2;
    local v876 = 3;
    local _ = 4;
    local v878 = 5;
    local _ = 6;
    local v880 = 7;
    local v881 = 8;
    local v882 = 9;
    local v883 = 10;
    local v884 = 11;
    local v885 = 12;
    local _ = 13;
    local _ = 14;
    local v888 = 15;
    local _ = 16;
    local v890 = 17;
    local _ = 18;
    local v892 = {
        [v873] = v865, 
        [v878] = v866, 
        [v876] = v867, 
        [v881] = v870, 
        [v880] = v871, 
        [v885] = v870, 
        [v884] = v871, 
        [v890] = v868, 
        [v888] = v869
    };
    local v893 = nil;
    local v894 = 0;
    local v895 = nil;
    do
        local l_l_GetPlayerXuidStringFromEntIndex_0_2, l_v864_0, l_v865_0, l_v867_0, l_v870_0, l_v871_0, l_v873_0, l_v876_0, l_v878_0, l_v880_0, l_v881_0, l_v882_0, l_v883_0, l_v888_0, l_v890_0, l_v892_0, l_v893_0, l_v894_0, l_v895_0 = l_GetPlayerXuidStringFromEntIndex_0, v864, v865, v867, v870, v871, v873, v876, v878, v880, v881, v882, v883, v888, v890, v892, v893, v894, v895;
        local function v915()
            -- upvalues: l_v893_0 (ref), l_v894_0 (ref)
            l_v893_0 = nil;
            l_v894_0 = 0;
        end;
        local function v916()
            -- upvalues: v19 (ref)
            v19.doubletap:override();
            v19.quick_peek_mode:override();
        end;
        local function v918()
            -- upvalues: v19 (ref)
            local _ = v19.hit_chance:get();
            v19.quick_peek_mode:override("On Shot");
        end;
        local function v920(v919)
            -- upvalues: l_v865_0 (ref), l_v867_0 (ref), l_v870_0 (ref), l_v871_0 (ref)
            if v919 == l_v865_0 then
                return 4;
            elseif v919 == l_v867_0 then
                return 1.25;
            elseif v919 == l_v870_0 then
                return 0.75;
            elseif v919 == l_v871_0 then
                return 0.75;
            else
                return 1;
            end;
        end;
        local function v925(v921, v922, v923, v924)
            -- upvalues: v920 (ref), l_v865_0 (ref)
            v922 = v922 * v920(v923);
            if v921.m_ArmorValue > 0 then
                if v923 == l_v865_0 then
                    if v921.m_bHasHelmet then
                        v922 = v922 * (v924 * 0.5);
                    end;
                else
                    v922 = v922 * (v924 * 0.5);
                end;
            end;
            return v922;
        end;
        local function v937(v926, v927, v928, v929, v930)
            -- upvalues: v925 (ref)
            local v931 = v927 - v926;
            local l_damage_1 = v930.damage;
            local l_armor_ratio_0 = v930.armor_ratio;
            local l_range_0 = v930.range;
            local l_range_modifier_0 = v930.range_modifier;
            local v936 = math.min(l_range_0, v931:length());
            l_damage_1 = l_damage_1 * math.pow(l_range_modifier_0, v936 * 0.002);
            return (v925(v928, l_damage_1, v929, l_armor_ratio_0));
        end;
        local function v938()
            -- upvalues: v100 (ref)
            return v100.elements.visuals.ai_peek_simulation * 0.01;
        end;
        local function v939()
            -- upvalues: v100 (ref)
            return v100.elements.visuals.ai_peek_rate_limit * 0.01;
        end;
        local function v940()
            -- upvalues: v19 (ref)
            return v19.min_damage:get();
        end;
        local function v943(v941)
            -- upvalues: l_l_GetPlayerXuidStringFromEntIndex_0_2 (ref)
            if v941 == nil then
                return;
            else
                local v942 = v941:get_origin();
                if bit.band(v941.m_fFlags, l_l_GetPlayerXuidStringFromEntIndex_0_2) == 0 then
                    return utils.trace_line(v942, v942 - vector(0, 0, 8192), v941, 33636363).end_pos;
                else
                    return v942;
                end;
            end;
        end;
        local function v945()
            -- upvalues: v100 (ref), l_v873_0 (ref), l_v878_0 (ref), l_v876_0 (ref), l_v890_0 (ref), l_v888_0 (ref), l_v881_0 (ref), l_v880_0 (ref), l_v883_0 (ref), l_v882_0 (ref)
            local v944 = {};
            if v100.elements.visuals.ai_peek_hitboxes.Head then
                table.insert(v944, l_v873_0);
            end;
            if v100.elements.visuals.ai_peek_hitboxes.Chest then
                table.insert(v944, l_v878_0);
            end;
            if v100.elements.visuals.ai_peek_hitboxes.Stomach then
                table.insert(v944, l_v876_0);
            end;
            if v100.elements.visuals.ai_peek_hitboxes.Arms then
                table.insert(v944, l_v890_0);
                table.insert(v944, l_v888_0);
            end;
            if v100.elements.visuals.ai_peek_hitboxes.Legs then
                table.insert(v944, l_v881_0);
                table.insert(v944, l_v880_0);
                table.insert(v944, l_v883_0);
                table.insert(v944, l_v882_0);
            end;
            return v944;
        end;
        local function v947(v946)
            -- upvalues: l_v892_0 (ref), l_v864_0 (ref)
            return l_v892_0[v946] or l_v864_0;
        end;
        local function v949(v948)
            return v948[0];
        end;
        local function v966(v950, v951, v952, v953, v954)
            -- upvalues: v947 (ref), v937 (ref)
            local v955 = {};
            local v956 = v951:get_eye_position();
            local v957 = v952:get_weapon_info();
            local l_m_iHealth_0 = v953.m_iHealth;
            for v959 = 1, #v950 do
                local v960 = v950[v959];
                local v961 = v947(v960);
                local v962 = v953:get_hitbox_position(v960);
                local v963 = v937(v956, v962, v953, v961, v957);
                local v964 = v963 < v954;
                local v965 = v963 < l_m_iHealth_0;
                if not v964 or not v965 then
                    table.insert(v955, {
                        index = v959, 
                        pos = v962
                    });
                end;
            end;
            return v955;
        end;
        local function v970(v967)
            -- upvalues: v949 (ref)
            if v967 == nil then
                return false;
            else
                local l_status_14, l_result_14 = pcall(v949, v967);
                if not l_status_14 or l_result_14 == nil then
                    return false;
                else
                    return true;
                end;
            end;
        end;
        local function v972(v971)
            -- upvalues: v970 (ref)
            return v970(v971.target);
        end;
        local function v974(v973)
            return not v973.in_forward and not v973.in_back and not v973.in_moveleft and not v973.in_moveright;
        end;
        local function v978(v975, v976, v977)
            if v975 == nil or v976 == nil then
                return false;
            elseif v977.max_clip1 == 0 or v976.m_iClip1 == 0 then
                return false;
            elseif globals.curtime < v975.m_flNextAttack then
                return false;
            elseif globals.curtime < v976.m_flNextPrimaryAttack then
                return false;
            else
                return true;
            end;
        end;
        local function v979()
            -- upvalues: v19 (ref)
            if not v19.doubletap:get() then
                return false;
            else
                return true;
            end;
        end;
        local function v982(v980, v981)
            return {
                ctx = v980, 
                target = v981, 
                simtime = 0, 
                retreat = -1
            };
        end;
        local function v984(v983)
            return v983:simulate_movement(nil, vector(), 1);
        end;
        local function v991(v985, v986, v987)
            local v989, v990 = utils.trace_bullet(v985, v986, v987, function(v988)
                -- upvalues: v985 (ref)
                return v988 ~= v985 and v988:is_enemy();
            end);
            return v989, v990;
        end;
        local function v1005(v992, v993, v994, v995, v996)
            -- upvalues: v991 (ref)
            local l_m_iHealth_1 = v994.m_iHealth;
            local v998 = v992.origin + vector(0, 0, v992.view_offset);
            for v999 = 1, #v995 do
                local v1000 = v995[v999];
                local v1001, _ = v991(v993, v998, v1000.pos);
                local v1003 = v996 <= v1001;
                local v1004 = l_m_iHealth_1 <= v1001;
                if v1003 or v1004 then
                    return v992, true;
                end;
            end;
            return v992, false;
        end;
        local function v1007(v1006)
            -- upvalues: v30 (ref), l_v895_0 (ref), v943 (ref)
            if not v1006 or v1006 == nil then
                v1006 = v30.entity;
            end;
            if l_v895_0 == nil then
                l_v895_0 = v943(v1006);
            end;
        end;
        local function v1017(v1008, v1009, v1010, v1011, v1012, v1013, v1014)
            -- upvalues: l_l_GetPlayerXuidStringFromEntIndex_0_2 (ref), v1005 (ref)
            v1008.view_angles.y = v1012;
            v1011:think(1);
            if bit.band(v1011.flags, l_l_GetPlayerXuidStringFromEntIndex_0_2) == 0 then
                return nil, false;
            else
                local _, v1016 = v1005(v1011, v1009, v1010, v1013, v1014);
                if v1016 then
                    v1011:think(1);
                end;
                return v1011, v1016;
            end;
        end;
        local function v1052(v1018, v1019, v1020)
            -- upvalues: v979 (ref), v939 (ref), v940 (ref), v945 (ref), l_v893_0 (ref), v972 (ref), v966 (ref), v1005 (ref), l_v894_0 (ref), v974 (ref), l_l_GetPlayerXuidStringFromEntIndex_0_2 (ref), v984 (ref), v1017 (ref), v982 (ref)
            if not v979() then
                return false;
            else
                local l_frametime_0 = globals.frametime;
                local v1022 = v939();
                local v1023 = v940();
                local v1024 = v945();
                if l_v893_0 ~= nil and v972(l_v893_0) then
                    local l_ctx_0 = l_v893_0.ctx;
                    local l_target_0 = l_v893_0.target;
                    local l_m_iHealth_2 = l_target_0.m_iHealth;
                    if v1023 >= 100 then
                        v1023 = v1023 + l_m_iHealth_2 - 100;
                    end;
                    local v1028 = v966(v1024, v1019, v1020, l_target_0, v1023);
                    local _, v1030 = v1005(l_ctx_0, v1019, l_target_0, v1028, v1023);
                    if v1030 then
                        l_v893_0.simtime = 0;
                    end;
                    l_v893_0.simtime = l_v893_0.simtime + l_frametime_0;
                    return true;
                else
                    if v1022 > 0 then
                        if l_v894_0 > 0 then
                            l_v894_0 = l_v894_0 - l_frametime_0;
                            return false;
                        else
                            l_v894_0 = v1022;
                        end;
                    end;
                    if not v974(v1018) then
                        return false;
                    else
                        local l_m_fFlags_1 = v1019.m_fFlags;
                        if bit.band(l_m_fFlags_1, l_l_GetPlayerXuidStringFromEntIndex_0_2) == 0 then
                            return false;
                        elseif v1019.m_vecVelocity:length2dsqr() > 6400 then
                            return false;
                        else
                            local v1032 = entity.get_threat();
                            if v1032 == nil or v1032:is_dormant() then
                                return false;
                            else
                                local l_m_iHealth_3 = v1032.m_iHealth;
                                if v1023 >= 100 then
                                    v1023 = v1023 + l_m_iHealth_3 - 100;
                                end;
                                local v1034 = v966(v1024, v1019, v1020, v1032, v1023);
                                local v1035 = nil;
                                local v1036 = nil;
                                local v1037 = v1019:get_origin();
                                local v1038 = (v1032:get_origin() - v1037):angles().y + 180;
                                v1035 = v1038 - 90;
                                v1036 = v1038 + 90;
                                v1037 = v1018.view_angles:clone();
                                local l_forwardmove_0 = v1018.forwardmove;
                                local l_sidemove_0 = v1018.sidemove;
                                local l_in_duck_0 = v1018.in_duck;
                                v1038 = v1018.in_jump;
                                local l_in_speed_0 = v1018.in_speed;
                                v1018.forwardmove = 450;
                                v1018.sidemove = 0;
                                v1018.in_duck = false;
                                v1018.in_jump = false;
                                v1018.in_speed = false;
                                local v1043 = v984(v1019);
                                local v1044 = v984(v1019);
                                local v1045 = 0;
                                local v1046 = 0;
                                for v1047 = 1, 20 do
                                    if v1045 ~= -1 then
                                        v1045 = v1047;
                                        local v1048, v1049 = v1017(v1018, v1019, v1032, v1043, v1035, v1034, v1023);
                                        if v1048 == nil then
                                            v1045 = -1;
                                        end;
                                        if v1049 then
                                            l_v893_0 = v982(v1048, v1032);
                                            break;
                                        end;
                                    end;
                                    if v1046 ~= -1 then
                                        v1046 = v1047;
                                        local v1050, v1051 = v1017(v1018, v1019, v1032, v1044, v1036, v1034, v1023);
                                        if v1050 == nil then
                                            v1046 = -1;
                                        end;
                                        if v1051 then
                                            l_v893_0 = v982(v1050, v1032);
                                            break;
                                        end;
                                    end;
                                end;
                                v1018.view_angles.y = v1037.y;
                                v1018.forwardmove = l_forwardmove_0;
                                v1018.sidemove = l_sidemove_0;
                                v1018.in_duck = l_in_duck_0;
                                v1018.in_jump = v1038;
                                v1018.in_speed = l_in_speed_0;
                                return l_v893_0 ~= nil;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        local function v1060(v1053, v1054, v1055)
            local v1056 = v1055 - v1054:get_origin();
            local v1057 = v1056:length2dsqr();
            if v1057 < 25 then
                local l_m_vecVelocity_3 = v1054.m_vecVelocity;
                local v1059 = l_m_vecVelocity_3:length();
                v1053.move_yaw = l_m_vecVelocity_3:angles().y;
                v1053.forwardmove = -v1059;
                v1053.sidemove = 0;
                return true, v1057;
            else
                v1053.move_yaw = v1056:angles().y;
                v1053.forwardmove = 450;
                v1053.sidemove = 0;
                return false, v1057;
            end;
        end;
        local function v1062(v1061)
            v1061.in_duck = false;
            v1061.in_jump = false;
            v1061.in_speed = false;
            v1061.in_forward = true;
            v1061.in_back = false;
            v1061.in_moveleft = false;
            v1061.in_moveright = false;
        end;
        local function v1074(v1063, v1064, v1065, v1066)
            -- upvalues: v1007 (ref), v978 (ref), v1052 (ref), l_v893_0 (ref), v938 (ref), v1060 (ref), v1062 (ref), v918 (ref), l_v895_0 (ref), v19 (ref), v915 (ref), v916 (ref)
            v1007(v1064);
            local v1067 = v978(v1064, v1065, v1066);
            local v1068 = v1052(v1063, v1064, v1065);
            if l_v893_0 == nil then
                return;
            else
                if v938() < l_v893_0.simtime then
                    v1068 = false;
                end;
                if v1066.weapon_type == 5 and not v1064.m_bIsScoped then
                    v1068 = false;
                end;
                if l_v893_0.retreat <= 0 and v1067 and v1068 then
                    local l_ctx_1 = l_v893_0.ctx;
                    local v1070, _ = v1060(v1063, v1064, l_ctx_1.origin);
                    v1062(v1063);
                    v918();
                    l_v893_0.retreat = 0;
                    if v1070 then
                        l_v893_0.retreat = 1;
                    end;
                    return;
                elseif l_v893_0.retreat == -1 then
                    return;
                else
                    local v1072, _ = v1060(v1063, v1064, l_v895_0);
                    v1062(v1063);
                    l_v893_0.retreat = l_v893_0.retreat + 1;
                    if l_v893_0.retreat >= 3 then
                        v19.doubletap:override(false);
                    end;
                    if v1067 and v1072 then
                        v915();
                        v916();
                    end;
                    return;
                end;
            end;
        end;
        local function v1078(v1075)
            -- upvalues: v30 (ref), v1074 (ref)
            if not v30.valid then
                return;
            else
                local v1076 = v30.entity:get_player_weapon();
                if v1076 == nil then
                    return;
                else
                    local v1077 = v1076:get_weapon_info();
                    if v1077 == nil then
                        return;
                    else
                        v1074(v1075, v30.entity, v1076, v1077);
                        return;
                    end;
                end;
            end;
        end;
        local function v1079()
            -- upvalues: l_v893_0 (ref)
            if l_v893_0 == nil then
                return nil;
            else
                l_v893_0.retreat = 1;
                return;
            end;
        end;
        v100.switch(v122.visuals.ragebot)(" \v\f<microchip-ai>\r   \226\128\138\226\128\138AI Peek")("visuals", "ai_peek", function()
            -- upvalues: v100 (ref)
            return v100.elements.visuals.tab_selector == 3;
        end)(function(v1080, v1081)
            -- upvalues: v100 (ref)
            v100.slider(v1080)("Simulation", 25, 35, 30, 0.01, "s")("visuals", "ai_peek_simulation", v1081);
            v100.slider(v1080)("Rate Limit", 0, 30, 3, 0.01, "s")("visuals", "ai_peek_rate_limit", v1081);
            v100.slider(v1080)("Hit Chance", 0, 100, 35, nil, function(v1082)
                if v1082 == 0 then
                    return "Default";
                else
                    return v1082 .. "%";
                end;
            end)("visuals", "ai_peek_hitchance", v1081);
            v100.selectable(v1080)("Hitboxes", {
                [1] = "Head", 
                [2] = "Chest", 
                [3] = "Stomach", 
                [4] = "Arms", 
                [5] = "Legs"
            })("visuals", "ai_peek_hitboxes", v1081);
        end);
        v100.refs.visuals.ai_peek:set_callback(function(v1083)
            -- upvalues: v915 (ref), v916 (ref), l_v895_0 (ref), v1007 (ref), v1079 (ref), v1078 (ref)
            local v1084 = v1083:get();
            if not v1084 then
                v915();
                v916();
                l_v895_0 = nil;
            end;
            if v1084 then
                l_v895_0 = v1007();
            end;
            events.aim_fire(v1079, v1084);
            events.createmove(v1078, v1084);
        end, true);
    end;
end;
v674.fake_latency = {};
l_GetPlayerXuidStringFromEntIndex_0 = v674.fake_latency;
l_GetPlayerXuidStringFromEntIndex_0.cvar = cvar.sv_maxunlag;
do
    local l_l_GetPlayerXuidStringFromEntIndex_0_3 = l_GetPlayerXuidStringFromEntIndex_0;
    l_l_GetPlayerXuidStringFromEntIndex_0_3.reset = function()
        -- upvalues: l_l_GetPlayerXuidStringFromEntIndex_0_3 (ref)
        l_l_GetPlayerXuidStringFromEntIndex_0_3.cvar:float(tonumber(l_l_GetPlayerXuidStringFromEntIndex_0_3.cvar:string()));
    end;
    l_l_GetPlayerXuidStringFromEntIndex_0_3.handle = function()
        -- upvalues: v100 (ref), l_l_GetPlayerXuidStringFromEntIndex_0_3 (ref), v20 (ref)
        local l_fake_latency_value_0 = v100.elements.visuals.fake_latency_value;
        l_l_GetPlayerXuidStringFromEntIndex_0_3.cvar:float(math.max(0.2, l_fake_latency_value_0 * 0.002), true);
        v20.setup("fake_latency", l_fake_latency_value_0);
    end;
    v100.switch(v122.visuals.rage_other)(" \v\f<satellite-dish>\r    Fake Latency")("visuals", "fake_latency", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 3;
    end)(function(v1087, v1088)
        -- upvalues: v100 (ref)
        v100.slider(v1087)("Fake Latency", 0, 200, 200)("visuals", "fake_latency_value", v1088);
    end);
    l_l_GetPlayerXuidStringFromEntIndex_0_3.reset();
    v100.refs.visuals.fake_latency:set_callback(function(v1089)
        -- upvalues: v19 (ref), l_l_GetPlayerXuidStringFromEntIndex_0_3 (ref)
        v19.fake_latency:disabled(v1089:get());
        l_l_GetPlayerXuidStringFromEntIndex_0_3.reset();
        events.render(l_l_GetPlayerXuidStringFromEntIndex_0_3.handle, v1089:get());
        events.shutdown(l_l_GetPlayerXuidStringFromEntIndex_0_3.reset, v1089:get());
    end, true);
end;
v674.no_delay_shot = {};
l_GetPlayerXuidStringFromEntIndex_0 = v674.no_delay_shot;
l_GetPlayerXuidStringFromEntIndex_0.handle = function()
    -- upvalues: v30 (ref), v20 (ref)
    if not v30.valid then
        return;
    else
        if v30.entity:get_anim_state().landing then
            v20.setup("delay_shot", false);
        end;
        return;
    end;
end;
v100.switch(v122.visuals.rage_other)(" \v\f<person-walking-dashed-line-arrow-right>\r  \226\128\138No Delay on Land")("visuals", "no_delay_shot", function()
    -- upvalues: v100 (ref)
    return v100.elements.visuals.tab_selector == 3;
end);
do
    local l_l_GetPlayerXuidStringFromEntIndex_0_4 = l_GetPlayerXuidStringFromEntIndex_0;
    v100.refs.visuals.no_delay_shot:set_callback(function(v1091)
        -- upvalues: l_l_GetPlayerXuidStringFromEntIndex_0_4 (ref)
        events.createmove(l_l_GetPlayerXuidStringFromEntIndex_0_4.handle, v1091:get());
    end, true);
end;
if v6.build == "Beta" or v6.build == "Alpha" then
    v674.roll_resolver = {
        enabled = false
    };
    l_GetPlayerXuidStringFromEntIndex_0 = v674.roll_resolver;
    l_GetPlayerXuidStringFromEntIndex_0.handle = function()
        -- upvalues: v30 (ref)
        if not v30.valid then
            return;
        elseif v30.target == nil then
            return;
        else
            local v1092 = v30.target.m_flPoseParameter[11] * 120 - 60 > 0 and -50 or 50;
            v30.target.m_angEyeAngles.z = v1092;
            return;
        end;
    end;
    esp.enemy:new_text("Roll resolver", "ROLL", function(v1093)
        -- upvalues: v100 (ref)
        if not v100.elements.visuals.roll_resolver then
            return;
        elseif v1093:is_bot() then
            return;
        elseif v1093.m_angEyeAngles.z ~= 0 then
            return "\aFFFFFFFFROLL";
        else
            return;
        end;
    end);
    v100.switch(v122.visuals.ragebot)(" \226\128\138\v\f<binary>\r   \226\128\138\226\128\138Roll Resolver")("visuals", "roll_resolver", function()
        -- upvalues: v100 (ref)
        return v100.elements.visuals.tab_selector == 3;
    end);
    do
        local l_l_GetPlayerXuidStringFromEntIndex_0_5 = l_GetPlayerXuidStringFromEntIndex_0;
        v100.refs.visuals.roll_resolver:set_callback(function(v1095)
            -- upvalues: l_l_GetPlayerXuidStringFromEntIndex_0_5 (ref)
            events.createmove(l_l_GetPlayerXuidStringFromEntIndex_0_5.handle, v1095:get());
        end, true);
    end;
end;
v674.grenade_release = {};
l_GetPlayerXuidStringFromEntIndex_0 = v674.grenade_release;
l_GetPlayerXuidStringFromEntIndex_0.handle = function(v1096)
    -- upvalues: v30 (ref), v100 (ref)
    if not v30.valid then
        return;
    elseif v30.weapon.weapon_index ~= 44 and v30.weapon.weapon_index ~= 46 then
        return;
    else
        if v1096.damage > v100.elements.visuals.grenade_release_dmg then
            utils.console_exec("+attack");
            utils.execute_after(0.1, function()
                utils.console_exec("-attack");
            end);
        end;
        return;
    end;
end;
v100.switch(v122.visuals.rage_other)(" \v\f<bomb>\r    Grenade Release")("visuals", "grenade_release", function()
    -- upvalues: v100 (ref)
    return v100.elements.visuals.tab_selector == 3;
end)(function(v1097, v1098)
    -- upvalues: v100 (ref)
    v100.slider(v1097)("Min. Damage", 0, 50, 50)("visuals", "grenade_release_dmg", v1098);
end);
do
    local l_l_GetPlayerXuidStringFromEntIndex_0_6 = l_GetPlayerXuidStringFromEntIndex_0;
    v100.refs.visuals.grenade_release:set_callback(function(v1100)
        -- upvalues: l_l_GetPlayerXuidStringFromEntIndex_0_6 (ref)
        events.grenade_prediction(l_l_GetPlayerXuidStringFromEntIndex_0_6.handle, v1100:get());
    end, true);
end;
if v6.build == "Beta" or v6.build == "Alpha" then
    v674.air_teleport = {};
    l_GetPlayerXuidStringFromEntIndex_0 = v674.air_teleport;
    l_GetPlayerXuidStringFromEntIndex_0.get_weapon = function(v1101)
        local v1102 = v1101:get_player_weapon();
        if v1102 == nil then
            return;
        else
            local v1103 = v1102:get_weapon_info();
            local v1104 = v1102:get_weapon_index();
            if v1104 == 1 then
                return "Deagle";
            elseif v1104 == 9 then
                return "AWP";
            elseif v1104 == 31 then
                return "Taser";
            elseif v1104 == 40 then
                return "SSG-08";
            elseif v1103.weapon_type == 1 then
                return "Pistols";
            elseif v1103.weapon_type == 4 then
                return "Shotguns";
            else
                return;
            end;
        end;
    end;
    do
        local l_l_GetPlayerXuidStringFromEntIndex_0_7 = l_GetPlayerXuidStringFromEntIndex_0;
        l_l_GetPlayerXuidStringFromEntIndex_0_7.handle = function()
            -- upvalues: v30 (ref), l_l_GetPlayerXuidStringFromEntIndex_0_7 (ref), v100 (ref)
            if not v30.valid then
                return;
            else
                local v1106 = l_l_GetPlayerXuidStringFromEntIndex_0_7.get_weapon(v30.entity);
                if v1106 == nil then
                    return;
                elseif not v100.elements.visuals.air_teleport_weapons[v1106] then
                    return;
                elseif v30.state ~= v30.states.air and v30.state ~= v30.states.air_crouch then
                    return;
                else
                    if v100.elements.visuals.air_teleport_type == "Lag Exploit" then
                        if globals.tickcount % v100.elements.visuals.air_teleport_ticks == 0 then
                            rage.exploit:force_teleport();
                        else
                            rage.exploit:force_charge();
                        end;
                    elseif entity.get_threat(true) then
                        rage.exploit:force_teleport();
                    end;
                    return;
                end;
            end;
        end;
        v100.switch(v122.visuals.ragebot)(" \v\f<person-from-portal>\r    Air Teleport")("visuals", "air_teleport", function()
            -- upvalues: v100 (ref)
            return v100.elements.visuals.tab_selector == 3;
        end)(function(v1107, v1108)
            -- upvalues: v100 (ref)
            v100.combo(v1107)("Type", {
                [1] = "Lag Exploit", 
                [2] = "Vulnerable"
            })("visuals", "air_teleport_type", v1108);
            v100.slider(v1107)("Ticks", 10, 30, 17)("visuals", "air_teleport_ticks", function()
                -- upvalues: v1108 (ref), v100 (ref)
                return v1108:get() and v100.elements.visuals.air_teleport_type == "Lag Exploit";
            end);
            v100.selectable(v1107)("Weapons", {
                [1] = "SSG-08", 
                [2] = "AWP", 
                [3] = "Deagle", 
                [4] = "Pistols", 
                [5] = "Shotguns", 
                [6] = "Taser"
            })("visuals", "air_teleport_weapons", function()
                -- upvalues: v1108 (ref), v100 (ref)
                return v1108:get() and v100.elements.visuals.air_teleport_type == "Vulnerable";
            end);
        end);
        v100.refs.visuals.air_teleport:set_callback(function(v1109)
            -- upvalues: l_l_GetPlayerXuidStringFromEntIndex_0_7 (ref)
            events.createmove(l_l_GetPlayerXuidStringFromEntIndex_0_7.handle, v1109:get());
        end, true);
    end;
end;
v674.jump_scout = {};
l_GetPlayerXuidStringFromEntIndex_0 = v674.jump_scout;
l_GetPlayerXuidStringFromEntIndex_0.handle = function(v1110)
    -- upvalues: v30 (ref)
    if not v30.valid then
        return;
    elseif v30.weapon.weapon_index ~= 40 then
        return;
    else
        if v30.velocity < 10 then
            v1110.in_speed = true;
        end;
        return;
    end;
end;
v100.switch(v122.visuals.aimbot)(" \v\f<dove>\r    \226\128\138\226\128\138Jump Scout")("visuals", "jump_scout", function()
    -- upvalues: v100 (ref)
    return v100.elements.visuals.tab_selector == 3;
end);
do
    local l_l_GetPlayerXuidStringFromEntIndex_0_8 = l_GetPlayerXuidStringFromEntIndex_0;
    v100.refs.visuals.jump_scout:set_callback(function(v1112)
        -- upvalues: l_l_GetPlayerXuidStringFromEntIndex_0_8 (ref)
        events.createmove(l_l_GetPlayerXuidStringFromEntIndex_0_8.handle, v1112:get());
    end, true);
end;
v674.hitchance = {};
l_GetPlayerXuidStringFromEntIndex_0 = v674.hitchance;
l_GetPlayerXuidStringFromEntIndex_0.no_scope = function()
    -- upvalues: v30 (ref), v20 (ref), v100 (ref)
    if v30.scoped then
        return;
    elseif v30.weapon.weapon_type ~= 5 then
        return;
    else
        v20.setup("hit_chance", v100.elements.visuals.no_scope_hitchance);
        return;
    end;
end;
l_GetPlayerXuidStringFromEntIndex_0.in_air = function()
    -- upvalues: v30 (ref), v20 (ref), v100 (ref)
    if v30.state ~= v30.states.air and v30.state ~= v30.states.air_crouch then
        return;
    else
        v20.setup("hit_chance", v100.elements.visuals.in_air_hitchance);
        return;
    end;
end;
v100.switch(v122.visuals.aimbot)(" \v\f<gun-slash>\r    No Scope")("visuals", "no_scope", function()
    -- upvalues: v100 (ref)
    return v100.elements.visuals.tab_selector == 3;
end)(function(v1113, v1114)
    -- upvalues: v100 (ref)
    v100.slider(v1113)("Hitchance", 0, 100, 50, nil, "%")("visuals", "no_scope_hitchance", v1114);
end);
v100.switch(v122.visuals.aimbot)("\226\128\138\226\128\138\v\f<wind>\r     In Air")("visuals", "in_air", function()
    -- upvalues: v100 (ref)
    return v100.elements.visuals.tab_selector == 3;
end)(function(v1115, v1116)
    -- upvalues: v100 (ref)
    v100.slider(v1115)("Hitchance", 0, 100, 50, nil, "%")("visuals", "in_air_hitchance", v1116);
end);
do
    local l_l_GetPlayerXuidStringFromEntIndex_0_9 = l_GetPlayerXuidStringFromEntIndex_0;
    v100.refs.visuals.in_air:set_callback(function(v1118)
        -- upvalues: l_l_GetPlayerXuidStringFromEntIndex_0_9 (ref)
        events.createmove(l_l_GetPlayerXuidStringFromEntIndex_0_9.in_air, v1118:get());
    end, true);
    v100.refs.visuals.no_scope:set_callback(function(v1119)
        -- upvalues: l_l_GetPlayerXuidStringFromEntIndex_0_9 (ref)
        events.createmove(l_l_GetPlayerXuidStringFromEntIndex_0_9.no_scope, v1119:get());
    end, true);
end;
v157.data = l_pui_0.setup({
    antiaim = v100.refs.antiaim, 
    visuals = v100.refs.visuals
}, true);
events.shutdown(function()
    -- upvalues: v10 (ref), v11 (ref)
    db[v10.name] = v11;
end);