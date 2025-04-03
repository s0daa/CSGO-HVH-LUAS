local hitgroup_names = {
    "generic",
    "head",
    "chest",
    "stomach",
    "left arm",
    "right arm",
    "left leg",
    "right leg",
    "neck",
    "?",
    "gear"
}

local ent = require "gamesense/entity"
local bit = require "bit"
local antiaim_funcs = require("gamesense/antiaim_funcs")
local ffi = require("ffi") or error("error", 2)
local vector = require("vector") or error("error", 2)
local base64 = require("gamesense/base64")
local clipboard = require("gamesense/clipboard") or error("error")
local lua_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "enable dash")
local anim = {}
local fart = {}
local client_userid_to_entindex
fart.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

local ref = {
    enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
    roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
    yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
    safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
    forcebaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
    quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
    yawjitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    bodyyaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    freestand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    os = {ui.reference("AA", "Other", "On shot anti-aim")},
    slow = {ui.reference("AA", "Other", "Slow motion")},
    dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
    fakelag = {ui.reference("AA", "Fake lag", "Limit")},
    mindmg = {ui.reference("Rage", "Aimbot", "Minimum damage override")}
}

local function on_load()
    ui.set(ref.yawjitter[1], "off")
    ui.set(ref.yawjitter[2], 0)
    ui.set(ref.bodyyaw[1], "static")
    ui.set(ref.bodyyaw[2], -180)
    ui.set(ref.yaw[1], "180")
    ui.set(ref.yaw[2], -90)
end

on_load()
local aa_init = {}
local var = {
    p_states = {"standing", "moving", "slowwalk", "air", "ducking", "air-crouching", "fakelag"},
    s_to_int = {
        ["air-crouching"] = 6,
        ["fakelag"] = 7,
        ["standing"] = 1,
        ["moving"] = 2,
        ["slowwalk"] = 3,
        ["air"] = 4,
        ["ducking"] = 5
    },
    dababys = {"S", "M", "SW", "A", "C", "AC", "FL"},
    state_to_int = {["AC"] = 6, ["FL"] = 7, ["S"] = 1, ["M"] = 2, ["SW"] = 3, ["A"] = 4, ["C"] = 5},
    p_state = 1
}

local function contains(table, value)
    if table == nil then
        return false
    end
    table = ui.get(table)
    for i = 0, #table do
        if table[i] == value then
            return true
        end
    end
    return false
end

local function table_contains(tbl, val)
    for i = 1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end
aa_init[0] = {
    aa_dir = 0,
    last_press_t = 0,
    lua_select = ui.new_combobox(
        "AA",
        "Anti-aimbot angles",
        "------------",
        "anti-aim",
        "aa builder",
        "visuals",
        "miscellaneous"
    ),
    presets = ui.new_combobox("AA", "Anti-aimbot angles", "presets", "safe", "unsafe"),
    neverhit = ui.new_checkbox("AA", "Anti-aimbot angles", "anti-bruteforce"),
    idk_what_to_call_this = ui.new_checkbox("AA", "Anti-aimbot angles", "break prediction"),
    legitness_key = ui.new_checkbox("AA", "Anti-aimbot angles", "legit aa on use"),
    manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "manual left"),
    manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "manual right"),
    shit_feature = ui.new_hotkey("AA", "Anti-aimbot angles", "freestanding"),
    killsay = ui.new_checkbox("AA", "Anti-aimbot angles", "killsay"),
    mindmgind = ui.new_checkbox("AA", "Anti-aimbot angles", "Min DMG Display"),
    bobs_builder = ui.new_checkbox("AA", "Anti-aimbot angles", "enable aa builder"),
    aloginatizeltionucalitonor = ui.new_checkbox("AA", "Anti-aimbot angles", "ragebot logs"),
    dababy = ui.new_combobox(
        "AA",
        "Anti-aimbot angles",
        "antiaim-states",
        "standing",
        "moving",
        "slowwalk",
        "air",
        "ducking",
        "air-crouching",
        "fakelag"
    )
}

local crosshair_inds = ui.new_checkbox("AA", "Anti-aimbot angles", "crosshair info")
local main_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "main color", 255, 146, 189, 255)
local manaa_inds = ui.new_checkbox("AA", "Anti-aimbot angles", "toggle manual aa arrows")
local fast_ladder = ui.new_checkbox("AA", "Anti-aimbot angles", "fast ladder")
local ctag = ui.new_checkbox("AA", "Anti-aimbot angles", "clantag")
local anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", "anti backstab")
local knife_distance = ui.new_slider("AA", "Anti-aimbot angles", "range", 0, 300, 150, true, "u")
local legszz = ui.new_multiselect("AA", "Anti-aimbot angles", "anims", "static legs", "leg fucker", "air walk")
for i = 1, 7 do
    aa_init[i] = {
        enable_state = ui.new_checkbox("AA", "Anti-aimbot angles", "enable " .. " " .. var.p_states[i] .. ""),
        yawaddl = ui.new_slider("AA", "Anti-aimbot angles", " " .. var.p_states[i] .. "  yaw left\n", -180, 180, 0),
        yawaddr = ui.new_slider("AA", "Anti-aimbot angles", " " .. var.p_states[i] .. "  yaw right\n", -180, 180, 0),
        yawjitter = ui.new_combobox(
            "AA",
            "Anti-aimbot angles",
            " " .. var.p_states[i] .. "  yaw options\n" .. var.p_states[i],
            {"off", "offset", "center", "random" , "skitter"}
        ),
        yawjitteradd = ui.new_slider(
            "AA",
            "Anti-aimbot angles",
            " " .. var.p_states[i] .. "  yaw add\n" .. var.p_states[i],
            -180,
            180,
            0
        ),
        bodyyaw = ui.new_combobox(
            "AA",
            "Anti-aimbot angles",
            " " .. var.p_states[i] .. "  body options\n" .. var.p_states[i],
            {"off", "opposite", "jitter", "static"}
        ),
        aa_static = ui.new_slider("AA", "Anti-aimbot angles", " " .. var.p_states[i] .. "  body left\n", -180, 180, 0),
        aa_static_2 = ui.new_slider(
            "AA",
            "Anti-aimbot angles",
            " " .. var.p_states[i] .. "  body right\n",
            -180,
            180,
            0
        ),
        roll = ui.new_slider(
            "AA",
            "Anti-aimbot angles",
            " " .. var.p_states[i] .. "  roll \n" .. var.p_states[i],
            -50,
            50,
            0,
            true,
            "°"
        ),
        anti_bf = ui.new_checkbox("AA", "Anti-aimbot angles", " " .. var.p_states[i] .. "  anti-bruteforce"),
        slightlyworse_fs = ui.new_checkbox(
            "AA",
            "Anti-aimbot angles",
            " " .. var.p_states[i] .. "  smart evasion"
        ),
        avoid_overlap = ui.new_checkbox("AA", "Anti-aimbot angles", " " .. var.p_states[i] .. "  avoid overlap")
    }
end
local function oppositefix(c)
    local desync_amount = antiaim_funcs.get_desync(2)
    if math.abs(desync_amount) < 15 or c.chokedcommands ~= 0 then
        return
    end
end
local yaw_am, yaw_val = ui.reference("AA", "Anti-aimbot angles", "Yaw")
jyaw, jyaw_val = ui.reference("AA", "Anti-aimbot angles", "Yaw Jitter")
byaw, byaw_val = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
fs_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
local function set_og_menu(state)
    ui.set_visible(ref.pitch, state)
    ui.set_visible(ref.roll, state)
    ui.set_visible(ref.yawbase, state)
    ui.set_visible(ref.yaw[1], state)
    ui.set_visible(ref.yaw[2], state)
    ui.set_visible(ref.yawjitter[1], state)
    ui.set_visible(ref.yawjitter[2], state)
    ui.set_visible(ref.bodyyaw[1], state)
    ui.set_visible(ref.bodyyaw[2], state)
    ui.set_visible(ref.freestand[1], state)
    ui.set_visible(ref.freestand[2], state)
    ui.set_visible(ref.fsbodyyaw, state)
    ui.set_visible(ref.edgeyaw, state)
end

_G.dash_push =
    (function()
    _G.dash_notify_cache = {}
    local a = {callback_registered = false, maximum_count = 4}
    local b = ui.reference("Misc", "Settings", "Menu color")
    function a:register_callback()
        if self.callback_registered then
            return
        end
        client.set_event_callback(
            "paint_ui",
            function()
                local c = {client.screen_size()}
                local d = {0, 0, 0}
                local e = 1
                local f = _G.dash_notify_cache
                for g = #f, 1, -1 do
                    _G.dash_notify_cache[g].time = _G.dash_notify_cache[g].time - globals.frametime()
                    local h, i = 255, 0
                    local i2 = 0
                    local lerpy = 150
                    local lerp_circ = 0.5
                    local j = f[g]
                    if j.time < 0 then
                        table.remove(_G.dash_notify_cache, g)
                    else
                        local k = j.def_time - j.time
                        local k = k > 1 and 1 or k
                        if j.time < 1 or k < 1 then
                            i = (k < 1 and k or j.time) / 1
                            i2 = (k < 1 and k or j.time) / 1
                            h = i * 255
                            lerpy = i * 150
                            lerp_circ = i * 0.5
                            if i < 0.2 then
                                e = e + 8 * (1.0 - i / 0.2)
                            end
                        end

                        local l = {ui.get(b)}
                        local m = {math.floor(renderer.measure_text(nil, "![DASH]!  " .. j.draw) * 1.03)}
                        local n = {renderer.measure_text(nil, "![DASH]!  ")}
                        local o = {renderer.measure_text(nil, j.draw)}
                        local p = {c[1] / 2 - m[1] / 2 + 3, c[2] - c[2] / 100 * 13.4 + e}
                        local c1, c2, c3, c4 = ui.get(main_clr)
                        local x, y = client.screen_size()

                        renderer.rectangle(p[1] - 1, p[2] - 20, m[1] + 2, 22, 18, 7, 8, h > 255 and 255 or h)
                        renderer.circle(p[1] - 1, p[2] - 8, 18, 7, 8, h > 255 and 255 or h, 12, 180, 0.5)
                        renderer.circle(p[1] + m[1] + 1, p[2] - 8, 18, 7, 8, h > 255 and 255 or h, 12, 0, 0.5)
                        renderer.circle_outline(
                            p[1] - 1,
                            p[2] - 9,
                            c1,
                            c2,
                            c3,
                            h > 200 and 200 or h,
                            13,
                            90,
                            lerp_circ,
                            2
                        )
                        renderer.circle_outline(
                            p[1] + m[1] + 1,
                            p[2] - 9,
                            c1,
                            c2,
                            c3,
                            h > 200 and 200 or h,
                            13,
                            -90,
                            lerp_circ,
                            2
                        )
                        renderer.line(
                            p[1] + m[1] + 1,
                            p[2] + 3,
                            p[1] + 149 - lerpy,
                            p[2] + 3,
                            c1,
                            c2,
                            c3,
                            h > 255 and 255 or h
                        )
                        renderer.line(
                            p[1] + m[1] + 1,
                            p[2] + 3,
                            p[1] + 149 - lerpy,
                            p[2] + 3,
                            c1,
                            c2,
                            c3,
                            h > 255 and 255 or h
                        )
                        renderer.line(
                            p[1] - 1,
                            p[2] - 21,
                            p[1] - 149 + m[1] + lerpy,
                            p[2] - 21,
                            c1,
                            c2,
                            c3,
                            h > 255 and 255 or h
                        )
                        renderer.line(
                            p[1] - 1,
                            p[2] - 21,
                            p[1] - 149 + m[1] + lerpy,
                            p[2] - 21,
                            c1,
                            c2,
                            c3,
                            h > 255 and 255 or h
                        )
                        renderer.text(p[1] + m[1] / 2 - o[1] / 2, p[2] - 9, c1, c2, c3, h, "c", nil, "![DASH]!  ")
                        renderer.text(p[1] + m[1] / 2 + n[1] / 2, p[2] - 9, 255, 255, 255, h, "c", nil, j.draw)
                        e = e - 33
                    end
                end
                self.callback_registered = true
            end
        )
    end

    function a:paint(q, r)
        local s = tonumber(q) + 1
        for g = self.maximum_count, 2, -1 do
            _G.dash_notify_cache[g] = _G.dash_notify_cache[g - 1]
        end
        _G.dash_notify_cache[1] = {time = s, def_time = s, draw = r}
        self:register_callback()
    end
    return a
end)()
dash_push:paint(5, "-/+ MEGA BOUSE SYSTEMS LOADED !!!!")
dash_push:paint(4, "-/+ READY TO OWNAGE ?!!?")

function RGBtoHEX(redArg, greenArg, blueArg)
    return string.format("%.2x%.2x%.2xFF", redArg, greenArg, blueArg)
end

local function set_lua_menu()
    var.active_i = var.s_to_int[ui.get(aa_init[0].dababy)]
    local is_aa = ui.get(aa_init[0].lua_select) == "anti-aim"
    local is_vis = ui.get(aa_init[0].lua_select) == "visuals"
    local is_misc = ui.get(aa_init[0].lua_select) == "miscellaneous"
    local is_builder = ui.get(aa_init[0].lua_select) == "aa builder"
    local is_knife = ui.get(anti_knife)
    local is_enabled = ui.get(lua_enable)

    if is_enabled then
        ui.set_visible(aa_init[0].lua_select, true)
        set_og_menu(false)
    else
        ui.set_visible(aa_init[0].lua_select, false)
        set_og_menu(true)
    end

    if is_misc and is_enabled then
        ui.set_visible(legszz, true)
        ui.set_visible(aa_init[0].aloginatizeltionucalitonor, true)
        ui.set_visible(aa_init[0].killsay, true)
        ui.set_visible(aa_init[0].mindmgind, true)
        ui.set_visible(anti_knife, true)
        ui.set_visible(ctag, true)
        ui.set_visible(fast_ladder, true)
        if is_knife then
            ui.set_visible(knife_distance, true)
        else
            ui.set_visible(knife_distance, false)
        end
        
    else
        ui.set_visible(anti_knife, false)
        ui.set_visible(knife_distance, false)
        ui.set_visible(legszz, false)
        ui.set_visible(ctag, false)
        ui.set_visible(fast_ladder, false)
        ui.set_visible(aa_init[0].mindmgind, false)
        ui.set_visible(aa_init[0].killsay, false)
        ui.set_visible(aa_init[0].aloginatizeltionucalitonor, false)
    end

    if is_aa and is_enabled then
        ui.set_visible(aa_init[0].legitness_key, true)
        ui.set_visible(aa_init[0].manual_left, true)
        ui.set_visible(aa_init[0].idk_what_to_call_this, true)
        ui.set_visible(aa_init[0].manual_right, true)
        ui.set_visible(aa_init[0].shit_feature, true)
    else
        ui.set_visible(aa_init[0].legitness_key, false)
        ui.set_visible(aa_init[0].manual_left, false)
        ui.set_visible(aa_init[0].manual_right, false)
        ui.set_visible(aa_init[0].idk_what_to_call_this, false)
        ui.set_visible(aa_init[0].shit_feature, false)
    end

    if is_vis and is_enabled then
        ui.set_visible(main_clr, true)
        ui.set_visible(crosshair_inds, true)
        ui.set_visible(manaa_inds, true)
    else
        ui.set_visible(main_clr, false)
        ui.set_visible(crosshair_inds, false)
        ui.set_visible(manaa_inds, false)
    end

    if is_aa and is_enabled then
        ui.set_visible(aa_init[0].neverhit, true)
        ui.set_visible(aa_init[0].bobs_builder, true)
        ui.set_visible(aa_init[0].presets, true)
    else
        ui.set_visible(aa_init[0].neverhit, false)
        ui.set_visible(aa_init[0].presets, false)
        ui.set_visible(aa_init[0].bobs_builder, false)
    end

    if is_builder and is_enabled then
        ui.set_visible(aa_init[0].bobs_builder, true)
    else
        ui.set_visible(aa_init[0].bobs_builder, false)
    end

    if ui.get(aa_init[0].bobs_builder) and is_enabled then
        for i = 1, 7 do
            ui.set_visible(aa_init[i].enable_state, var.active_i == i and is_builder)
            ui.set_visible(aa_init[0].dababy, is_builder)
            if ui.get(aa_init[i].enable_state) then
                ui.set_visible(aa_init[i].yawaddl, var.active_i == i and is_builder)
                ui.set_visible(aa_init[i].yawaddr, var.active_i == i and is_builder)
                ui.set_visible(aa_init[i].yawjitter, var.active_i == i and is_builder)
                ui.set_visible(
                    aa_init[i].yawjitteradd,
                    var.active_i == i and ui.get(aa_init[var.active_i].yawjitter) ~= "off" and is_builder
                )
                ui.set_visible(aa_init[i].bodyyaw, var.active_i == i and is_builder)
                ui.set_visible(aa_init[i].anti_bf, var.active_i == i and is_builder)
                ui.set_visible(aa_init[i].slightlyworse_fs, var.active_i == i and is_builder)
                ui.set_visible(
                    aa_init[i].aa_static,
                    var.active_i == i and ui.get(aa_init[i].bodyyaw) ~= "off" and
                        ui.get(aa_init[i].bodyyaw) ~= "opposite" and
                        is_builder
                )
                ui.set_visible(
                    aa_init[i].aa_static_2,
                    var.active_i == i and ui.get(aa_init[i].bodyyaw) ~= "off" and
                        ui.get(aa_init[i].bodyyaw) ~= "opposite" and
                        is_builder
                )


                ui.set_visible(aa_init[i].roll, var.active_i == i and is_builder)
                ui.set_visible(aa_init[i].avoid_overlap, var.active_i == i and is_builder)
            else
                ui.set_visible(aa_init[i].yawaddl, false)
                ui.set_visible(aa_init[i].yawaddr, false)
                ui.set_visible(aa_init[i].yawjitter, false)
                ui.set_visible(aa_init[i].yawjitteradd, false)
                ui.set_visible(aa_init[i].anti_bf, false)
                ui.set_visible(aa_init[i].slightlyworse_fs, false)
                ui.set_visible(aa_init[i].bodyyaw, false)
                ui.set_visible(aa_init[i].aa_static, false)
                ui.set_visible(aa_init[i].aa_static_2, false)
                ui.set_visible(aa_init[i].roll, false)
                ui.set_visible(aa_init[i].avoid_overlap, false)
            end
        end
    else
        for i = 1, 7 do
            ui.set_visible(aa_init[i].enable_state, false)
            ui.set_visible(aa_init[0].dababy, false)
            ui.set_visible(aa_init[i].yawaddl, false)
            ui.set_visible(aa_init[i].yawaddr, false)
            ui.set_visible(aa_init[i].yawjitter, false)
            ui.set_visible(aa_init[i].yawjitteradd, false)
            ui.set_visible(aa_init[i].bodyyaw, false)
            ui.set_visible(aa_init[i].anti_bf, false)
            ui.set_visible(aa_init[i].slightlyworse_fs, false)
            ui.set_visible(aa_init[i].aa_static, false)
            ui.set_visible(aa_init[i].aa_static_2, false)
            ui.set_visible(aa_init[i].roll, false)
            ui.set_visible(aa_init[i].avoid_overlap, false)
        end
    end
end

misc = {}
misc.anti_knife_dist = function(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
end

misc.anti_knife = function()
    if ui.get(anti_knife) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
        local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
        for i = 1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = misc.anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(knife_distance) then
                ui.set(yaw_slider, 180)
                ui.set(pitch, "Off")
            end
        end
    end
end
client.set_event_callback("setup_command", misc.anti_knife)

local best_enemy = nil

local brute = {
    yaw_status = "default",
    fs_side = 0,
    last_miss = 0,
    best_angle = 0,
    misses = {},
    hp = 0,
    misses_ind = {},
    can_hit_head = 0,
    can_hit = 0,
    hit_reverse = {},
}

local ingore = false
local laa = 0
local raa = 0
local mantimer = 0
local function normalize_yaw(yaw)
    while yaw > 180 do
        yaw = yaw - 360
    end
    while yaw < -180 do
        yaw = yaw + 360
    end
    return yaw
end

local function calc_angle(local_x, local_y, enemy_x, enemy_y)
    local ydelta = local_y - enemy_y
    local xdelta = local_x - enemy_x
    local relativeyaw = math.atan(ydelta / xdelta)
    relativeyaw = normalize_yaw(relativeyaw * 180 / math.pi)
    if xdelta >= 0 then
        relativeyaw = normalize_yaw(relativeyaw + 180)
    end
    return relativeyaw
end

local function ang_on_screen(x, y)
    if x == 0 and y == 0 then
        return 0
    end
    return math.deg(math.atan2(y, x))
end

local function angle_vector(angle_x, angle_y)
    local sy = math.sin(math.rad(angle_y))
    local cy = math.cos(math.rad(angle_y))
    local sp = math.sin(math.rad(angle_x))
    local cp = math.cos(math.rad(angle_x))
    return cp * cy, cp * sy, -sp
end

local function get_damage(me, enemy, x, y, z)
    local ex = {}
    local ey = {}
    local ez = {}
    ex[0], ey[0], ez[0] = entity.hitbox_position(enemy, 1)
    ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
    ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
    ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
    ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
    ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
    ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
    local bestdamage = 0
    local bent = nil
    for i = 0, 6 do
        local ent, damage = client.trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
        if damage > bestdamage then
            bent = ent
            bestdamage = damage
        end
    end
    return bent == nil and client.scale_damage(me, 1, bestdamage) or bestdamage
end

local function get_best_enemy()
    best_enemy = nil
    local enemies = entity.get_players(true)
    local best_fov = 180
    local lx, ly, lz = client.eye_position()
    local view_x, view_y, roll = client.camera_angles()
    for i = 1, #enemies do
        local cur_x, cur_y, cur_z = entity.get_prop(enemies[i], "m_vecOrigin")
        local cur_fov = math.abs(normalize_yaw(ang_on_screen(lx - cur_x, ly - cur_y) - view_y + 180))
        if cur_fov < best_fov then
            best_fov = cur_fov
            best_enemy = enemies[i]
        end
    end
end

local function extrapolate_position(xpos, ypos, zpos, ticks, player)
    local x, y, z = entity.get_prop(player, "m_vecVelocity")
    for i = 0, ticks do
        xpos = xpos + (x * globals.tickinterval())
        ypos = ypos + (y * globals.tickinterval())
        zpos = zpos + (z * globals.tickinterval())
    end
    return xpos, ypos, zpos
end

local function get_velocity(player)
    local x, y, z = entity.get_prop(player, "m_vecVelocity")
    if x == nil then
        return
    end
    return math.sqrt(x * x + y * y + z * z)
end

local function get_body_yaw(player)
    local _, model_yaw = entity.get_prop(player, "m_angAbsRotation")
    local _, eye_yaw = entity.get_prop(player, "m_angEyeAngles")
    if model_yaw == nil or eye_yaw == nil then
        return 0
    end
    return normalize_yaw(model_yaw - eye_yaw)
end

local function get_best_angle()
    local me = entity.get_local_player()
    if best_enemy == nil then
        return
    end
    local origin_x, origin_y, origin_z = entity.get_prop(best_enemy, "m_vecOrigin")
    if origin_z == nil then
        return
    end
    origin_z = origin_z + 64
    local extrapolated_x, extrapolated_y, extrapolated_z =
        extrapolate_position(origin_x, origin_y, origin_z, 20, best_enemy)
    local lx, ly, lz = client.eye_position()
    local hx, hy, hz = entity.hitbox_position(entity.get_local_player(), 0)
    local _, head_dmg = client.trace_bullet(best_enemy, origin_x, origin_y, origin_z, hx, hy, hz, true)
    if head_dmg ~= nil and head_dmg > 1 then
        brute.can_hit_head = 1
    else
        brute.can_hit_head = 0
    end

    local view_x, view_y, roll = client.camera_angles()
    local e_x, e_y, e_z = entity.hitbox_position(best_enemy, 0)
    local yaw = calc_angle(lx, ly, e_x, e_y)
    local rdir_x, rdir_y, rdir_z = angle_vector(0, (yaw + 90))
    local rend_x = lx + rdir_x * 10
    local rend_y = ly + rdir_y * 10
    local ldir_x, ldir_y, ldir_z = angle_vector(0, (yaw - 90))
    local lend_x = lx + ldir_x * 10
    local lend_y = ly + ldir_y * 10
    local r2dir_x, r2dir_y, r2dir_z = angle_vector(0, (yaw + 90))
    local r2end_x = lx + r2dir_x * 100
    local r2end_y = ly + r2dir_y * 100
    local l2dir_x, l2dir_y, l2dir_z = angle_vector(0, (yaw - 90))
    local l2end_x = lx + l2dir_x * 100
    local l2end_y = ly + l2dir_y * 100
    local ldamage = get_damage(me, best_enemy, rend_x, rend_y, lz)
    local rdamage = get_damage(me, best_enemy, lend_x, lend_y, lz)
    local l2damage = get_damage(me, best_enemy, r2end_x, r2end_y, lz)
    local r2damage = get_damage(me, best_enemy, l2end_x, l2end_y, lz)
    if l2damage > r2damage or ldamage > rdamage or l2damage > ldamage then
        if ui.get(aa_init[var.p_state].slightlyworse_fs) then
            brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 1 or 2)
        else
            brute.best_angle = 1
        end
    elseif r2damage > l2damage or rdamage > ldamage or r2damage > rdamage then
        if ui.get(aa_init[var.p_state].slightlyworse_fs) then
            brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 2 or 1)
        else
            brute.best_angle = 2
        end
    end
end

local function in_air(player)
    local flags = entity.get_prop(player, "m_fFlags")
    if bit.band(flags, 1) == 0 then
        return true
    end
    return false
end
local ChokedCommands = 0
local aa = {ignore = false, manaa = 0, input = 0}
local lastdt = 0
local function on_setup_command(c)
     

    local plocal = entity.get_local_player()
    local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")
    local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 5
    local lp_vel = get_velocity(entity.get_local_player())
    local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1 and c.in_jump == 0
    local p_slow = ui.get(ref.slow[1]) and ui.get(ref.slow[2])
    local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
    local is_fd = ui.get(ref.fakeduck)
    local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
    local wpn = entity.get_player_weapon(plocal)
    local wpn_id = entity.get_prop(wpn, "m_iItemDefinitionIndex")
    local doubletapping = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
    local state = "ballstorethepiss"
    if not is_dt and not is_os and not p_still and ui.get(aa_init[7].enable_state) and ui.get(aa_init[0].bobs_builder) then
        var.p_state = 7
    elseif c.in_duck == 1 and on_ground then
        var.p_state = 5
    elseif c.in_duck == 1 and not on_ground then
        var.p_state = 6
    elseif not on_ground then
        var.p_state = 4
    elseif p_slow then
        var.p_state = 3
    elseif p_still then
        var.p_state = 1
    elseif not p_still then
        var.p_state = 2
    end
    if var.p_state == 6 then
        c.roll = ui.get(aa_init[6].roll)
    elseif var.p_state == 1 then
        c.roll = ui.get(aa_init[1].roll)
    elseif var.p_state == 1 then
        c.roll = ui.get(aa_init[7].roll)
    elseif var.p_state == 2 then
        c.roll = ui.get(aa_init[2].roll)
    elseif var.p_state == 3 then
        c.roll = ui.get(aa_init[3].roll)
    elseif var.p_state == 4 then
        c.roll = ui.get(aa_init[4].roll)
    elseif var.p_state == 5 then
        c.roll = ui.get(aa_init[5].roll)
    end
    local weaponn = entity.get_player_weapon()
    if ui.get(aa_init[0].legitness_key) then
        if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
            if c.in_attack == 1 then
                c.in_attack = 0
                c.in_use = 1
            end
        else
            if c.chokedcommands == 0 then
                c.in_use = 0
            end
        end
    end
end

local antiaim = {
    leg_movement = ui.reference("AA", "Other", "Leg movement")
}

client.set_event_callback(
    "pre_render",
    function()
        if not entity.is_alive(entity.get_local_player()) then
            return
        end
        if table_contains(ui.get(legszz), "static legs") then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
        end
        local legs_types = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
        if table_contains(ui.get(legszz), "leg fucker") then
            ui.set(antiaim.leg_movement, legs_types[math.random(1, 3)])
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
        end
        if table_contains(ui.get(legszz), "air walk") then
            local me = ent.get_local_player()
            local m_fFlags = me:get_prop("m_fFlags")
            local is_onground = bit.band(m_fFlags, 1) ~= 0
            if not is_onground then
                local animlayer = me:get_anim_overlay(6)
                animlayer.weight = 1
            end
        end
    end
)

client.set_event_callback(
    "setup_command",
    function(c)
        local me = entity.get_local_player()
        if not entity.is_alive(me) then
            return
        end
        local localp = entity.get_local_player()
        local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
        local is_fd = ui.get(ref.fakeduck)
        local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
        ui.set(aa_init[0].manual_left, "On hotkey")
        ui.set(aa_init[0].manual_right, "On hotkey")
        if ui.get(aa_init[0].shit_feature) then
            ui.set(ref.freestand[2], "Always on")
        else
            ui.set(ref.freestand[2], "On hotkey")
        end

        local l = 1

      

        if aa.input + 0.22 < globals.curtime() then
            if aa.manaa == 0 then
                if ui.get(aa_init[0].manual_left) then
                    aa.manaa = 1
                    aa.input = globals.curtime()
                elseif ui.get(aa_init[0].manual_right) then
                    aa.manaa = 2
                    aa.input = globals.curtime()
                else
                end
            elseif aa.manaa == 1 then
                if ui.get(aa_init[0].manual_right) then
                    aa.manaa = 2
                    aa.input = globals.curtime()
                elseif ui.get(aa_init[0].manual_left) then
                    aa.manaa = 0
                    aa.input = globals.curtime()
                end
            elseif aa.manaa == 2 then
                if ui.get(aa_init[0].manual_left) then
                    aa.manaa = 1
                    aa.input = globals.curtime()
                elseif ui.get(aa_init[0].manual_right) then
                    aa.manaa = 0
                    aa.input = globals.curtime()
                end
            elseif aa.manaa == 3 then
                if ui.get(aa_init[0].manual_left) then
                    aa.manaa = 1
                    aa.input = globals.curtime()
                elseif ui.get(aa_init[0].manual_right) then
                    aa.manaa = 2
                    aa.input = globals.curtime()
                end
            end
        end
        if aa.manaa == 1 or aa.manaa == 2 or aa.manaa == 3 then
            aa.ignore = true
            if aa.manaa == 1 then
                ui.set(ref.yawjitter[1], "off")
                ui.set(ref.yawjitter[2], 0)
                ui.set(ref.bodyyaw[1], "static")
                ui.set(ref.bodyyaw[2], -180)
                ui.set(ref.yawbase, "local view")
                ui.set(ref.yaw[1], "180")
                ui.set(ref.yaw[2], -90)
            elseif aa.manaa == 2 then
                ui.set(ref.yawjitter[1], "off")
                ui.set(ref.yawjitter[2], 0)
                ui.set(ref.bodyyaw[1], "static")
                ui.set(ref.bodyyaw[2], -180)
                ui.set(ref.yawbase, "local view")
                ui.set(ref.yaw[1], "180")
                ui.set(ref.yaw[2], 90)
            elseif aa.manaa == 3 then
                ui.set(ref.yawjitter[1], "off")
                ui.set(ref.yawjitter[2], 0)
                ui.set(ref.bodyyaw[1], "static")
                ui.set(ref.bodyyaw[2], -180)
                ui.set(ref.yawbase, "at targets")
                ui.set(ref.yaw[1], "180")
                ui.set(ref.yaw[2], 18)
            end
        else
            aa.ignore = false
            ui.set(ref.yawbase, "at targets")
        end

        local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        local side = bodyyaw > 0 and 1 or -1

        if aa.ignore == false then
            ui.set(ref.bodyyaw[2], ui.get(aa_init[var.p_state].aa_static))
            ui.set(byaw, ui.get(aa_init[var.p_state].bodyyaw))
            if ui.get(aa_init[var.p_state].enable_state) and ui.get(aa_init[0].bobs_builder) then
                if var.p_state == 6 then
                    ui.set(ref.pitch, "Default")
                else
                    ui.set(ref.pitch, "Minimal")
                end
                ui.set(jyaw, ui.get(aa_init[var.p_state].yawjitter))
                ui.set(jyaw_val, ui.get(aa_init[var.p_state].yawjitteradd))
                if c.chokedcommands ~= 0 then
                else
                    ui.set(
                        yaw_val,
                        (side == 1 and ui.get(aa_init[var.p_state].yawaddl) or ui.get(aa_init[var.p_state].yawaddr))
                    )
                end
                local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
            else
                ui.set(ref.pitch, "Minimal")
                if ui.get(aa_init[0].presets) == "safe" then
                    if var.p_state == 1 then
                        ui.set(ref.yawjitter[1], "Center")
                        ui.set(ref.yawjitter[2], 36)
                        ui.set(ref.bodyyaw[1], "jitter")
                        ui.set(ref.bodyyaw[2], 0)
                        ui.set(ref.yawbase, "At targets")
                        if c.chokedcommands ~= 0 then
                        else
                            ui.set(ref.yaw[2], (side == 1 and -12 or 17))
                        end
                    elseif var.p_state == 2 then
                        ui.set(ref.yawjitter[1], "Center")
                        ui.set(ref.yawjitter[2], 38)
                        ui.set(ref.bodyyaw[1], "Jitter")
                        ui.set(ref.bodyyaw[2], 0)
                        if c.chokedcommands ~= 0 then
                        else
                            ui.set(ref.yaw[2], (side == 1 and -23 or 20))
                        end
                    elseif var.p_state == 3 then
                        ui.set(ref.yawjitter[1], "Center")
                        ui.set(ref.yawjitter[2], 50)
                        ui.set(ref.bodyyaw[1], "Jitter")
                        ui.set(ref.bodyyaw[2], 0)
                        if c.chokedcommands ~= 0 then
                        else
                            ui.set(ref.yaw[2], (side == 1 and -13 or 9))
                        end
                    elseif var.p_state == 4 then
                        ui.set(ref.yawjitter[1], "Center")
                        ui.set(ref.yawjitter[2], 63)
                        ui.set(ref.bodyyaw[1], "Jitter")
                        ui.set(ref.bodyyaw[2], 0)
                        if c.chokedcommands ~= 0 then
                        else
                            ui.set(ref.yaw[2], (side == 1 and 5 or 12))
                        end
                    elseif var.p_state == 5 then
                        ui.set(ref.yawjitter[1], "Center")
                        ui.set(ref.yawjitter[2], 48)
                        ui.set(ref.bodyyaw[1], "Jitter")
                        ui.set(ref.bodyyaw[2], 0)
                        if c.chokedcommands ~= 0 then
                        else
                            ui.set(ref.yaw[2], (side == 1 and -10 or 15))
                        end
                    elseif var.p_state == 6 then
                        ui.set(ref.yawjitter[1], "Center")
                        ui.set(ref.yawjitter[2], 53)
                        ui.set(ref.bodyyaw[1], "Jitter")
                        ui.set(ref.bodyyaw[2], 0)
                        if c.chokedcommands ~= 0 then
                        else
                            ui.set(ref.yaw[2], (side == 1 and -12 or 17))
                        end
                    end
                elseif ui.get(aa_init[0].presets) == "unsafe" then
                    if var.p_state == 1 then
                        ui.set(ref.yawjitter[1], "Center")
                        ui.set(ref.yawjitter[2], 36)
                        ui.set(byaw, "Jitter")
                        ui.set(ref.bodyyaw[2], 0)
                        if c.chokedcommands ~= 0 then
                        else
                            ui.set(ref.yaw[2], (side == 1 and -12 or 17))
                        end
                    elseif var.p_state == 2 then
                        ui.set(ref.yawjitter[1], "Center")
                        ui.set(ref.yawjitter[2], 53)
                        ui.set(byaw, "Jitter")
                        ui.set(ref.bodyyaw[2], 0)
                        if c.chokedcommands ~= 0 then
                        else
                            ui.set(ref.yaw[2], (side == 1 and -10 or 11))
                        end
                    elseif var.p_state == 3 then
                        ui.set(ref.yawjitter[1], "Center")
                        ui.set(ref.yawjitter[2], 50)
                        ui.set(byaw, "Jitter")
                        ui.set(ref.bodyyaw[2], 0)
                        if c.chokedcommands ~= 0 then
                        else
                            ui.set(ref.yaw[2], (side == 1 and -13 or 9))
                        end
                    elseif var.p_state == 4 then
                        ui.set(ref.yawjitter[1], "Center")
                        ui.set(ref.yawjitter[2], 43)
                        ui.set(byaw, "Jitter")
                        ui.set(ref.bodyyaw[2], 0)
                        if c.chokedcommands ~= 0 then
                        else
                            ui.set(ref.yaw[2], (side == 1 and -7 or 7))
                        end
                    elseif var.p_state == 5 then
                        ui.set(ref.yawjitter[1], "Center")
                        ui.set(ref.yawjitter[2], 43)
                        ui.set(byaw, "Jitter")
                        ui.set(ref.bodyyaw[2], 0)
                        if c.chokedcommands ~= 0 then
                        else
                            ui.set(ref.yaw[2], (side == 1 and -12 or 17))
                        end
                    elseif var.p_state == 6 then
                        ui.set(ref.yawjitter[1], "Center")
                        ui.set(ref.yawjitter[2], 47)
                        ui.set(byaw, "Jitter")
                        ui.set(ref.bodyyaw[2], 0)
                        if c.chokedcommands ~= 0 then
                        else
                            ui.set(ref.yaw[2], (side == 1 and -5 or 14))
                        end
                    end
                end
            end
        end
    end
)

local function brute_impact(e)
    local me = entity.get_local_player()
    if not entity.is_alive(me) then
        return
    end
    local shooter_id = e.userid
    local shooter = client.userid_to_entindex(shooter_id)
    if not entity.is_enemy(shooter) or entity.is_dormant(shooter) then
        return
    end
    local lx, ly, lz = entity.hitbox_position(me, "head_0")
    local ox, oy, oz = entity.get_prop(me, "m_vecOrigin")
    local ex, ey, ez = entity.get_prop(shooter, "m_vecOrigin")
    local dist = ((e.y - ey) * lx - (e.x - ex) * ly + e.x * ey - e.y * ex) / math.sqrt((e.y - ey) ^ 2 + (e.x - ex) ^ 2)
    if math.abs(dist) <= 35 and globals.curtime() - brute.last_miss > 0.015 then
        if ui.get(aa_init[0].neverhit) or ui.get(aa_init[var.p_state].anti_bf) then
            dash_push:paint(5, "-/+ [ANTI-BRUTEFORCE] CHANGING YAW OFFSETS!")
        else
        end
        brute.last_miss = globals.curtime()
        if brute.misses[shooter] == nil then
            brute.misses[shooter] = 1
            brute.misses_ind[shooter] = 1
        elseif brute.misses[shooter] >= 2 then
            brute.misses[shooter] = nil
        else
            brute.misses_ind[shooter] = brute.misses_ind[shooter] + 1
            brute.misses[shooter] = brute.misses[shooter] + 1
        end
    end
end

brute.reset = function()
    brute.fs_side = 0
    brute.last_miss = 0
    brute.best_angle = 0
    brute.misses_ind = {}
    brute.misses = {}
end

local function brute_death(e)
    local victim_id = e.userid
    local victim = client.userid_to_entindex(victim_id)
    if victim ~= entity.get_local_player() then
        return
    end
    local attacker_id = e.attacker
    local attacker = client.userid_to_entindex(attacker_id)
    if not entity.is_enemy(attacker) then
        return
    end
    if not e.headshot then
        return
    end
    if brute.misses[attacker] == nil or (globals.curtime() - brute.last_miss < 0.06 and brute.misses[attacker] == 1) then
        if brute.hit_reverse[attacker] == nil then
            brute.hit_reverse[attacker] = true
        else
            brute.hit_reverse[attacker] = nil
        end
    end
end

local value = 0
local once1 = false
local once2 = false
local dt_a = 0
local dt_y = 45
local dt_x = 0
local dt_w = 0
local os_a = 0
local os_y = 45
local os_x = 0
local os_w = 0
local fs_a = 0
local fs_y = 45
local fs_x = 0
local fs_w = 0
local n_x = 0
local n2_x = 0
local n3_x = 0
local n4_x = 0
local round = function(value, multiplier)
    local multiplier = 10 ^ (multiplier or 0)
    return math.floor(value * multiplier + 0.5) / multiplier
end
local was_on_ground = false
local function renderer_shit(x, y, w, r, g, b, a, edge_h)
    if edge_h == nil then
        edge_h = 0
    end
    local local_player = entity.get_local_player()
    local velocity = string.format("%.2f", vector(entity.get_prop(local_player, "m_vecVelocity")):length2d())
    local pos_x, pos_y, pos_z = entity.get_origin(local_player)
    renderer.rectangle(x + 2, y - 2, w - 5, 2.5, 15, 15, 15, 120)
    renderer.rectangle(x - 2, y - 3, w + 3, 1.5, 10, 10, 10, 200)
    renderer.rectangle(x - 2, y - 2, 2, 20, 10, 10, 10, 200)
    renderer.rectangle(x, y - 2, 2.5, 20, 15, 15, 15, 120)
    renderer.rectangle(x + w - 3, y - 2, 2.5, 20, 15, 15, 15, 120)
    renderer.rectangle(x + w - 1, y - 2, 2, 20, 10, 10, 10, 200)
    renderer.rectangle(x + 2, y + 16, w - 5, 2.5, 15, 15, 15, 120)
    renderer.rectangle(x - 2, y + 18, w + 3, 1.5, 10, 10, 10, 200)
    renderer.rectangle(x + 2, y, w - 5, 16, 28, 28, 28, 255)
    local me = entity.get_local_player()
    local desync_type = antiaim_funcs.get_overlap(float)
    local r, g, b = ui.get(main_clr)
    local hex = RGBtoHEX(r, g, b)
    if not entity.is_alive(me) then
        return
    end
end

local renderer_text = renderer.text
renderer.text = function(x, y, r, g, b, a, flags, max_width, ...)
    local arguments = table.concat({...})
    if arguments:find("shoppy") or arguments:find("@") or arguments:find("sigma") then
        return
    end
    return renderer_text(x, y, r, g, b, a, flags, max_width, ...)
end

local function watermark()
        local mr, mg, mb, ma = ui.get(main_clr)
        text = "DASH -/+ .gg/scriptleaks"
        local h, w = 18, renderer.measure_text(nil, text) + 8
        local x, y = client.screen_size(), 10 + (-3)
        x = x - w - 10
            renderer_shit(x, y, w, 65, 65, 65, 180, 2)
            renderer.text(x+4, y+1, mr, mg, mb, 255, '', 0, text)
end

client.set_event_callback("paint", watermark)

fart.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

linear_interpolation = function(start, _end, time)
    return (_end - start) * time + start
end

clamp = function(value, minimum, maximum)
    if minimum > maximum then
        return math.min(math.max(value, maximum), minimum)
    else
        return math.min(math.max(value, minimum), maximum)
    end
end

local function clamp2(val, min_val, max_val)
    return math.max(min_val, math.min(max_val, val))
end

lerp2 = function(start, _end, time)
    time = time or 0.005
    time = clamp(globals.frametime() * time * 175.0, 0.01, 1.0)
    local a = linear_interpolation(start, _end, time)
    if _end == 0.0 and a < 0.01 and a > -0.01 then
        a = 0.0
    elseif _end == 1.0 and a < 1.01 and a > 0.99 then
        a = 1.0
    end
    return a
end

local testx = 0
local aaa = 0
local lele = 0

local function round(num, decimals)
    local mult = 10 ^ (decimals or 0)
    return math_floor(num * mult + 0.5) / mult
end

local function draw()
    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local side = bodyyaw > 0 and 1 or -1
    local mr, mg, mb, ma = ui.get(main_clr)
    local x, y = client.screen_size()
    local me = entity.get_local_player()
    if not entity.is_alive(me) then
        return
    end
    
    local is_charged = antiaim_funcs.get_double_tap()
    local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
    local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
    local is_shit_feature = ui.get(aa_init[0].shit_feature)
    local is_ba = ui.get(ref.forcebaim)
    local is_sp = ui.get(ref.safepoint)
    local is_qp = ui.get(ref.quickpeek[2])
    if is_charged then
        dr, dg, db, da = 167, 252, 121, 255
    elseif is_os then
        dr, dg, db, da = 255, 255, 255, 255
    else
        dr, dg, db, da = 255, 0, 0, 255
    end
    if is_qp then
        qr, qg, qb, qa = 255, 255, 255, 255
    else
        qr, qg, qb, qa = 255, 255, 255, 150
    end

    if is_shit_feature then
        fr, fg, fb, fa = 255, 255, 255, 255
    else
        fr, fg, fb, fa = 255, 255, 255, 150
    end
    if is_sp then
        sr, sg, sb, sa = 255, 255, 255, 255
    else
        sr, sg, sb, sa = 255, 255, 255, 150
    end
    value = value + globals.frametime() * 9
    local _, y2 = client.screen_size()
    local state = "MOVING"
    if ui.get(aa_init[0].idk_what_to_call_this) then
        if brute.can_hit == 0 then
            state = "/AUTO/"
        end
    else
        if brute.yaw_status == "brute L" and brute.misses[best_enemy] ~= nil then
            state = "BRUTE [" .. brute.misses[best_enemy] .. "] [L]"
        elseif brute.yaw_status == "brute R" and brute.misses[best_enemy] ~= nil then
            state = "BRUTE [" .. brute.misses[best_enemy] .. "] [R]"
        elseif var.p_state == 7 and ui.get(aa_init[0].bobs_builder) then
            state = "/PING/"
        elseif var.p_state == 5 then
            state = "/DUCK/"
        elseif var.p_state == 6 then
            state = "/AIR+/"
        elseif var.p_state == 4 then
            state = "/AIR/"
        elseif var.p_state == 3 then
            state = "/SLOW-MO/"
        elseif var.p_state == 1 then
            state = "/STATIC/"
        elseif var.p_state == 2 then
            state = "/RUN/"
        end
    end

    local realtime = globals.realtime() % 3
    local alpha = math.floor(math.sin(realtime * 4) * (180 / 2 - 1) + 180 / 2) or 180

    local exp_ind = ""

    if is_dt then
        exp_ind = "DT"
    elseif is_os then
        exp_ind = "HS"
    end

    local me = entity.get_local_player()
    local wpn = entity.get_player_weapon(me)

    local scope_level = entity.get_prop(wpn, "m_zoomLevel")
    local scoped = entity.get_prop(me, "m_bIsScoped") == 1
    local resume_zoom = entity.get_prop(me, "m_bResumeZoom") == 1

    local is_valid = entity.is_alive(me) and wpn ~= nil and scope_level ~= nil
    local act = is_valid and scope_level > 0 and scoped and not resume_zoom

    local flag = "c-"
    local ting = 0
    local testting = 0
    
    if is_dt or is_os then
        n4_x = fart.lerp(n4_x, 8, globals.frametime() * 8)
    else
        n4_x = fart.lerp(n4_x, -1, globals.frametime() * 8)
    end

    if act then
        flag = "-"
        ting = 23
        testting = 11

        testx = fart.lerp(testx, 15, globals.frametime() * 5)

        n2_x = fart.lerp(n2_x, 15, globals.frametime() * 5)

        n3_x = fart.lerp(n3_x, 11, globals.frametime() * 5)
    else
        testx = fart.lerp(testx, 0, globals.frametime() * 5)

        n2_x = fart.lerp(n2_x, 0, globals.frametime() * 5)

        n3_x = fart.lerp(n3_x, 0, globals.frametime() * 5)

        flag = "c-"
        ting = 28
    end

    if is_dt then
        if dt_a < 255 then
            dt_a = dt_a + 5
        end
        if dt_w < 10 then
            dt_w = dt_w + 0.28
        end
        if dt_y < 36 then
            dt_y = dt_y + 10
        end
        if fs_x < 11 then
            fs_x = fs_x + 0.25
        end
    elseif not is_dt then
        if dt_a > 0 then
            dt_a = dt_a - 5
        end
        if dt_w > 0 then
            dt_w = dt_w - 0.2
        end
        if dt_y > 25 then
            dt_y = dt_y - 1
        end
        if fs_x > 0 then
            fs_x = fs_x - 0.25
        end
    end
    if is_os and not is_dt then
        if os_a < 255 then
            os_a = os_a + 5
        end
        if os_w < 12 then
            os_w = os_w + 0.28
        end
        if os_y < 36 then
            os_y = os_y + 10
        end
        if fs_x < 12 then
            fs_x = fs_x + 0.5
        end
    elseif not is_os and not is_dt then
        if os_a > 0 then
            os_a = os_a - 5
        end
        if os_w > 0 then
            os_w = os_w - 0.2
        end
        if os_y > 25 then
            os_y = os_y - 1
        end
        if fs_x > 0 then
            fs_x = fs_x - 0.5
        end
    end
    if is_fs then
        if fs_w < 10 then
            fs_w = fs_w + 0.35
        end
        if fs_a < 255 then
            fs_a = fs_a + 5
        end
        if dt_x > -7 then
            dt_x = dt_x - 0.5
        end
        if os_x > -7 then
            os_x = os_x - 0.5
        end
        if fs_y < 36 then
            fs_y = fs_y + 10
        end
    elseif not is_fs then
        if fs_a > 0 then
            fs_a = fs_a - 5
        end
        if fs_w > 0 then
            fs_w = fs_w - 0.2
        end
        if dt_x < 0 then
            dt_x = dt_x + 0.5
        end
        if os_x < 0 then
            os_x = os_x + 0.5
        end
        if fs_y > 25 then
            fs_y = fs_y - 1
        end
    end

    if ui.get(crosshair_inds) then
        if is_dt then
            renderer.text(x / 2 - 0.5 + os_x, y2 / 2 + os_y + 10, dr, dg, db, os_a, "c-", os_w, " ")
        else
            renderer.text(x / 2 - 0.5 + n3_x, y2 / 2 + os_y - 13, dr, dg, db, os_a, "c-", os_w, "OS ")
        end
        renderer.text(x / 2 - 0.5 + n3_x, y2 / 2 + dt_y - 13 , dr, dg, db, dt_a, "c-", dt_w, "DT")

        renderer.text(x / 2 - 0.5 + fs_x + n3_x, y2 / 2 + fs_y + 13, 255, 255, 255, fs_a, "c-", fs_w, "FS")

        local wx, wy = client.screen_size()

        local desync_type = antiaim_funcs.get_overlap(float)
        local desync_type2 = antiaim_funcs.get_desync(2)

        renderer.text(x / 2 - 10 + testx, y / 2 + 10, mr, mg, mb, 255, "-", 0, "DASH")
        renderer.text(x / 2 + n2_x - testting, y / 2 + ting - 5 , 255, 255, 255, 255, flag, 0, state)
    end

    local localp = entity.get_local_player()
    local bodyyaw = entity.get_prop(localp, "m_flPoseParameter", 11) * 120 - 60

    if ui.get(manaa_inds) then
        renderer.text(x / 2 - 45, y / 2 - 2.5, 0, 0, 0, 100, "c+", 0, "⯇")
        renderer.text(x / 2 + 45, y / 2 - 2.5, 0, 0, 0, 100, "c+", 0, "⯈")
    end
    if ui.get(ref.yaw[2]) == 90 then
        renderer.text(x / 2 + 45, y / 2 - 2.5, mr, mg, mb, alpha, "c+", 0, "⯈")
    end
    if ui.get(ref.yaw[2]) == -90 then
        renderer.text(x / 2 - 45, y / 2 - 2.5, mr, mg, mb, alpha, "c+", 0, "⯇")
    end
end
local function export_config()
    local settings = {}
    for key, value in pairs(var.dababys) do
        settings[tostring(value)] = {}
        for k, v in pairs(aa_init[key]) do
            settings[value][k] = ui.get(v)
        end
    end

    clipboard.set(json.stringify(settings))
    dash_push:paint(5, "exported")
end

local export_btn = ui.new_button("AA", "Anti-aimbot angles", "export antiaim settings", export_config)

local function import_config()
    local settings = json.parse(clipboard.get())
    for key, value in pairs(var.dababys) do
        for k, v in pairs(aa_init[key]) do
            local current = settings[value][k]
            if (current ~= nil) then
                ui.set(v, current)
            end
        end
    end
    dash_push:paint(5, "imported")
end

local import_btn = ui.new_button("AA", "Anti-aimbot angles", "import antiaim settings", import_config)

local function config_menu()
    local is_enabled = ui.get(lua_enable)
    local is_builder = ui.get(aa_init[0].lua_select) == "aa builder"
    if ui.get(aa_init[0].bobs_builder) and is_builder and is_enabled then
        ui.set_visible(export_btn, true)
        ui.set_visible(import_btn, true)
    else
        ui.set_visible(export_btn, false)
        ui.set_visible(import_btn, false)
    end
end
client.set_event_callback("paint", draw)
client.set_event_callback("paint_ui", set_lua_menu)
client.set_event_callback("paint_ui", set_og_menu)
client.set_event_callback("paint_ui", config_menu)
ffi.cdef [[
struct cusercmd{struct cusercmd (*cusercmd)();int command_number;int tick_count;};
typedef struct cusercmd*(__thiscall* get_user_cmd_t)(void*, int, int);
]]
local signature_ginput = base64.decode("uczMzMyLQDj/0ITAD4U=")
local match = client.find_signature("client.dll", signature_ginput) or error("sig1 not found")
local g_input = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("match is nil")
local g_inputclass = ffi.cast("void***", g_input)
local g_inputvtbl = g_inputclass[0]
local rawgetusercmd = g_inputvtbl[8]
local get_user_cmd = ffi.cast("get_user_cmd_t", rawgetusercmd)
local lastlocal = 0
local function reduce(e)
    local cmd = get_user_cmd(g_inputclass, 0, e.command_number)
    if lastlocal + 0.9 > globals.curtime() then
        cmd.tick_count = cmd.tick_count + 8
    else
        cmd.tick_count = cmd.tick_count + 1
    end
end

client.set_event_callback("setup_command", function(e)
    local local_player = entity.get_local_player()
    local pitch, yaw = client.camera_angles()
    if entity.get_prop(local_player, "m_MoveType") == 9 then
        e.yaw = math.floor(e.yaw+0.5)
        e.roll = 0
        if ui.get(fast_ladder)then
            if e.forwardmove > 0 then
                if pitch < 45 then
                    e.pitch = 89
                    e.in_moveright = 1
                    e.in_moveleft = 0
                    e.in_forward = 0
                    e.in_back = 1
                    if e.sidemove == 0 then
                        e.yaw = e.yaw + 90
                    end
                    if e.sidemove < 0 then
                        e.yaw = e.yaw + 150
                    end
                    if e.sidemove > 0 then
                        e.yaw = e.yaw + 30
                    end
                end 
            end
        end
        if ui.get(fast_ladder) then
            if e.forwardmove < 0 then
                e.pitch = 89
                e.in_moveleft = 1
                e.in_moveright = 0
                e.in_forward = 1
                e.in_back = 0
                if e.sidemove == 0 then
                    e.yaw = e.yaw + 90
                end
                if e.sidemove > 0 then
                    e.yaw = e.yaw + 150
                end
                if e.sidemove < 0 then
                    e.yaw = e.yaw + 30
                end
            end
        end
    end
end)
local function player_death(e)
    local killsay = {
        "U think u good? luckily im here",
        "𝕐𝕆𝕌 (𝕎𝔼𝔸𝕂 𝔻𝕆𝔾) 𝔸ℝ𝔼 ℕ𝕆𝕋ℍ𝕀ℕ𝔾 ℂ𝕆𝕄ℙ𝔸ℝ𝔼𝔻 𝕋𝕆 𝕄𝔼",
        "youre value compared to me  is but a grain of sand",
        "all romanian(you) will die to me(boss)",
        "𝓪𝓵𝓵 𝓭𝓲𝓮 𝓽𝓸 𝓫𝓸𝓸𝓽𝔂 𝓬𝓪𝓷𝓬𝓮𝓻 𝓫𝓪𝓷𝓭𝓼",
        "this isnt phasmaphobia: global offensive please dont speak",
        "mega bouse",
        "I guarntee youre loss forever and always",
        "𝕡𝕣𝕠𝕓𝕝𝕖𝕞?",
        "твоя ценность по сравнению со мной всего лишь песчинка",
        "𝕚𝕞𝕡𝕠𝕤𝕤𝕚𝕓𝕝𝕖 𝕗𝕠𝕣 𝕪𝕠𝕦 𝕥𝕠 𝕨𝕚𝕟 𝕚𝕟 𝟙𝕩𝟙 𝟚𝕩𝟚 𝟝𝕩𝟝",
        "cope",
        "𝓫𝓪𝓲𝓽𝓮𝓭 𝓵𝓲𝓴𝓮 𝓪 𝓯𝓲𝓼𝓱 𝓫𝔂 𝓴𝓲𝓷𝓰𝓼𝓱𝓪𝓻𝓴",
        " 格拉格拉 < you? 无功无过 < me B)",
        "𝒟𝐸𝒜𝒟 𝒷𝓎𝑒 𝒷𝓎𝑒 :)",
        "in hvh war i will win",
        "below average performance",
        "𝕨𝕙𝕖𝕣𝕖 𝕚𝕢 𝕒𝕥 𝕕𝕠𝕘?",
        "SPEAK BULGARIAN? WILL TALK",
        "you are loss it is decided",
        "you do not perform this hvh",
        "𝕚𝕥 𝕚𝕤 𝕔𝕠𝕟𝕗𝕚𝕣𝕞𝕖𝕕 𝕪𝕠𝕦𝕣 𝕝𝕠𝕤𝕤 𝕒𝕤 𝕠𝕗 𝕥𝕠𝕕𝕒𝕪",
        "𝒾𝓉 𝒹𝑜𝑒𝓈 𝓃𝑜𝓉 𝓂𝒶𝓉𝓉𝑒𝓇 𝓎𝑜𝓊 𝓆𝓊𝑒𝓊𝑒 𝒶𝓈𝒾𝒶 𝒶𝓃𝒹 𝒾𝓈 𝓁𝑜𝓈𝓈",
        "qahahaha i am top of this region",
        "this weak snail is spoke of victory but is door unhinged to loss",
        "fatty fish dreaming of alive but is 𝒟𝐸𝒜𝒟 from babyrock",
        "you do not have the impression of owning the performance-enhancing software known as Gamesense.pub",
        "𝕨𝕚𝕥𝕟𝕖𝕤𝕤 𝕦𝕤𝕖𝕣 𝕚𝕕𝕖𝕟𝕥𝕚𝕗𝕚𝕔𝕒𝕥𝕚𝕠𝕟",
        "how you will feel knowing im skeethaving and u will skeetless",
        "your mexican familia never make it out from trailer",
        "𝐼 𝓈𝒸𝓇𝑒𝑒𝓃𝓈𝒽𝑜𝓉 𝑜𝒻 𝓎𝑜𝓊𝓇 𝓁𝑜𝓈𝓈 𝓉𝑜 𝓂𝑒",
        "grub. you are foods, this meal of mine? worthless",
        "cant understand u. any noname translator?",
        "you waste aka fecal matter/shit(you)",
        "sorry for u loss, me always better like life",
        "better luck next round, oh wait i alr won BAHAHHA",
        "kekalaff u sucks",
        "when you spawn tell me why u die to me",
        "how hit chance in deagle? i sit.",
        "do i need to get an xray to shoot magnets into ur skull to find out the plan?",
        "shitting on your chest speedrun any% WR run",
        "smelly lapdog dreams of success in 1x1 but is handed 9 casualities",
        "dude where are my diamonds?",
        "QUABALABABABAB"
    }
    if ui.get(aa_init[0].killsay) then
        local attacker_entindex = client.userid_to_entindex(e.attacker)
        local victim_entindex = client.userid_to_entindex(e.userid)
        if attacker_entindex ~= entity.get_local_player() then
            return
        end
        client.exec("say " .. killsay[math.random(1, #killsay)])
    end
end

reason_counter = {}
reason_counter.spread = 0
reason_counter.death = 0
reason_counter.prediction_error = 0
reason_counter.unknown = 0
local chance, bt, predicted_damage, predicted_hitgroup
function aim_fire(e)
    chance = math.floor(e.hit_chance)
    bt = globals.tickcount() - e.tick
    predicted_damage = e.damage
    predicted_hitgroup = e.hitgroup
end
function aim_hit(e)
    local hitgroup_names = {
        "generic",
        "head",
        "chest",
        "stomach",
        "left arm",
        "right arm",
        "left leg",
        "right leg",
        "neck",
        "?",
        "gear"
    }
    group = hitgroup_names[e.hitgroup + 1] or "?"
    name = entity.get_player_name(e.target)
    damage = e.damage
    hp_left = entity.get_prop(e.target, "m_iHealth")
    js = panorama.open()
    persona_api = js.MyPersonaAPI
    username = persona_api.GetName()
    targetname = name
    hitbox = group
    dmg = damage
    hc = chance
    backtrack = bt
    predicted_group = hitgroup_names[predicted_hitgroup + 1] or "?"
    if ui.get(aa_init[0].aloginatizeltionucalitonor) then
        print(
            string.format(
                "-/+ shot at %s's %s for %s  / bt=%s hc=%s /",
                name,
                string.lower(hitbox),
                damage,
                backtrack,
                hc
            )
        )
    end
end

function aim_miss(e)
    group = hitgroup_names[e.hitgroup + 1] or "?"
    name = entity.get_player_name(e.target)
    hp_left = entity.get_prop(e.target, "m_iHealth")
    js = panorama.open()
    persona_api = js.MyPersonaAPI
    username = persona_api.GetName()
    targetname = name
    hitbox = group
    hc = chance
    backtrack = bt
    reason = e.reason

    predicted_group = hitgroup_names[predicted_hitgroup + 1] or "?"

    if reason == "?" then
        reason = "resolver"
        reason_counter.unknown = reason_counter.unknown + 1
    elseif reason == "spread" then
        reason_counter.spread = reason_counter.spread + 1
    elseif reason == "death" then
        reason_counter.death = reason_counter.death + 1
    elseif reason == "prediction error" then
        reason_counter.prediction_error = reason_counter.prediction_error + 1
    end

    if ui.get(aa_init[0].aloginatizeltionucalitonor) then
        print(
            string.format(
                " -/+ missed %s's %s due to %s / hc=%s /",
                string.lower(entity.get_player_name(e.target)),
                string.lower(predicted_group),
                reason,
                hc
            )
        )
    end
end
client.set_event_callback("aim_fire", aim_fire)
client.set_event_callback("aim_hit", aim_hit)
client.set_event_callback("aim_miss", aim_miss)

local clantags = {
	"",
    "|",
    "|",
    "d|",
    "da|",
    "das|",
    "dash|",
    "dash|",
    "dash",
    "dash",
    "dash|",
    "dash|",
    "dash",
    "dash",
    "dash|",
    "dash|",
    "dash",
    "dash",
    "dash|",
    "das|",
    "da|",
    "d|",
    "|",
    "|",
    "",
    "",
    "|",
    "|",
    "",
    "",
    "|",
"" 
}
local clantag_prev
client.set_event_callback("net_update_end", function()
    if ui.get(ctag) then
 	    local cur = math.floor(globals.tickcount() / 25) % #clantags
  	    local clantag = clantags[cur+1]

  	    if clantag ~= clantag_prev then
    	    clantag_prev = clantag
    	    client.set_clan_tag(clantag)
  	    end
    end
end)

local function dmg_ind()
    local x, y = client.screen_size()
    local thingy1 = ui.get(ref.mindmg[2])
    local thingy2 = ui.get(ref.mindmg[3])
    if thingy1 and ui.get(aa_init[0].mindmgind) then
        renderer_text(x / 2 + 2, y / 2 - 15, 255, 255, 255, 255, "C-", 0, thingy2)
    end
end
client.set_event_callback("paint", dmg_ind)

client.set_event_callback("setup_command", reduce)
local function main()
    client.set_event_callback(
        "run_command",
        function()
            get_best_enemy()
            get_best_angle()
        end
    )
    client.set_event_callback(
        "bullet_impact",
        function(e)
            brute_impact(e)
        end
    )
    client.set_event_callback(
        "shutdown",
        function()
            set_og_menu(true)
        end
    )
    client.set_event_callback(
        "player_death",
        player_death,
        function(e)
            local attacker_entindex = client_userid_to_entindex(e.attacker)
            local victim_entindex = client_userid_to_entindex(e.userid)
            brute_death(e)
            if client.userid_to_entindex(e.userid) == entity.get_local_player() then
                dash_push:paint(5, "-/+ DATA RESET DUE TO PLAYER DEATH")
                brute.reset()
            end
        end
    )
    client.set_event_callback(
        "round_start",
        function()
            aa.input = 0
            aa.ignore = false
            lastlocal = 0
            lastdt = 0
            brute.reset()
            local me = entity.get_local_player()
            if not entity.is_alive(me) then
                return
            end
            dash_push:paint(5, "-/+ DATA RESET BECAUSE OF ROUND CHANGE")
        end
    )
    client.set_event_callback(
        "client_disconnect",
        function()
            aa.input = 0
            aa.ignore = false
            brute.reset()
        end
    )
    client.set_event_callback(
        "game_newmap",
        function()
            aa.input = 0
            aa.ignore = false
            dash_push:paint(5, "-/+ DATA RESET BECUASE OF MAP CHANGE")
            brute.reset()
        end
    )
    client.set_event_callback(
        "cs_game_disconnected",
        function()
            aa.input = 0
            aa.ignore = false
            brute.reset()
        end
    )
end
client.set_event_callback("setup_command", on_setup_command)
client.exec("playvol \"survival/buy_item_01.wav\" 1")
main()