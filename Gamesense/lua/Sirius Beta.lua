
local request = require 'gamesense/http'








local function lerp(x, v, t)
    if type(x) == 'table' then
        return lerp(x[1], v[1], t), lerp(x[2], v[2], t), lerp(x[3], v[3], t), lerp(x[4], v[4], t)
    end

    local delta = v - x

    if type(delta) == 'number' then
        if math.abs(delta) < 0.005 then
            return v
        end
    end

    return delta * t + x
end





local vector = require 'vector'

local rgba_to_hex = function(r, g, b, a)
    return bit.tohex(
        (math.floor(r + 0.5) * 16777216) +
        (math.floor(g + 0.5) * 65536) +
        (math.floor(b + 0.5) * 256) +
        (math.floor(a + 0.5))
    )
end

local function hexaToRgba(hexaColor)
    local hex = hexaColor:gsub("#", "")
    local r = tonumber(hex:sub(1, 2), 16) / 255
    local g = tonumber(hex:sub(3, 4), 16) / 255
    local b = tonumber(hex:sub(5, 6), 16) / 255
    local a = tonumber(hex:sub(7, 8), 16) / 255

    return r, g, b, a
end
local hitgroup_names = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck",
    "?", "gear" }
local refs = {
    double_tap = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
    duck_peek_assist = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    pitch = { ui.reference('AA', 'Anti-aimbot angles', 'Pitch') },
    yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') },
    yaw_jitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
    body_yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
    freestanding_body_yaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
    edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    freestanding = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
    roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
    on_shot_anti_aim = { ui.reference('AA', 'Other', 'On shot anti-aim') },
    slow_motion = { ui.reference('AA', 'Other', 'Slow motion') },
    dmg = { ui.reference('RAGE', 'Aimbot', 'Minimum damage override') },
    auto_peek = { ui.reference("Rage", "Other", "Quick peek assist") },
}


local lFeetYaw   = 0
local Angle2     = 0

local log        = {}
local logs       = {}

-- * table
table.shall_copy = function(t)
    local new_t = {}
    for i = 1, #t do
        table.insert(new_t, t[i])
    end
    return new_t
end
table.reverse    = function(t)
    local new_t = table.shall_copy(t)
    for i = 1, math.floor(#t / 2), 1 do
        new_t[i], new_t[#t - i + 1] = new_t[#t - i + 1], new_t[i]
    end
    return new_t
end
table.add_table  = function(t, add_t)
    local new_t = table.shall_copy(t)
    for _, v in pairs(add_t) do
        table.insert(new_t, v)
    end
    return new_t
end
table.key_rotate = function(t, i)
    i = -i
    for k = 1, math.abs(i) do
        if i < 0 then
            table.insert(t, 1, table.remove(t))
        else
            table.insert(t, table.remove(t, 1))
        end
    end
    return t
end
-- * math
math.flerp       = function(a, b, t)
    return a + t * (b - a)
end
math.round       = function(value, decimals)
    local multiplier = 10.0 ^ (decimals or 0.0)
    return math.floor(value * multiplier + 0.5) / multiplier
end
math.flerp_color = function(clr1, clr2, t)
    return render.color(
        math.round(math.flerp(clr1.r, clr2.r, t)),
        math.round(math.flerp(clr1.g, clr2.g, t)),
        math.round(math.flerp(clr1.b, clr2.b, t)),
        math.round(math.flerp(clr1.a, clr2.a, t))
    )
end
math.nway        = function(start, final, way)
    local val_t = {}; for i = 0, 1, 1 / (way - 1) do
        table.insert(val_t, math.flerp(start, final, i))
    end
    return val_t
end
math.is_float    = function(num)
    return num % 1 ~= 0
end

local side       = 0
string.split     = function(text)
    local t = {}
    for i = 1, text:len() do
        table.insert(t, text:sub(i, i))
    end
    return t
end
local Math       = {
    number_fix    = function(number, value)
        return string.format("%g", string.format("%." .. value .. "f", number))
    end,
    time_to_ticks = function(t)
        return math.floor(0.5 + (t / globals.tickinterval()))
    end,
    round         = function(value, decimals)
        local multiplier = 10.0 ^ (decimals or 0.0)
        return math.floor(value * multiplier + 0.5) / multiplier
    end,
    clamp         = function(x, min, max)
        if x < min then return min end
        if x > max then return max end
        if x == nil then return min end
        return x
    end,
    normalize_yaw = function(angle)
        if angle < -180 then
            angle = angle + 360
        end
        if angle > 180 then
            angle = angle - 360
        end
        return angle
    end,
    lerp          = function(start, _end, time, do_extraanim)
        if (not do_extraanim and math.floor(start) == _end) then
            return
                _end
        end
        time = global_vars.frametime * (time * 175)
        if time < 0 then
            time = 0.01
        elseif time > 1 then
            time = 1
        end
        return Math.round((_end - start) * time + start, 2)
    end,
    flerp         = function(a, b, t)
        return a + t * (b - a)
    end,
    elerp         = function(self, start, end_, speed, delta)
        if (math.abs(start - end_) < (delta or 0.01)) then
            return end_
        end
        speed = speed or 0.095
        local time = global_vars.frametime * (175 * speed)
        return ((end_ - start) * time + start)
    end,
}
math.lerp        = function(a, b, time)
    return Math.round(a + (b - a) * time, 4)
end
local function get_curtime(offset)
    return globals.curtime() - (offset * globals.tickinterval())
end


local animations = {
    data = {},

    process = function(self, name, bool, time)
        if not self.data[name] then
            self.data[name] = 0
        end

        local animation = globals.frametime() * (bool and 1 or -1) * (time or 4)
        self.data[name] = Math.clamp(self.data[name] + animation, 0, 1)
        return self.data[name]
    end,

    lerp = function(self, start, end_, speed, delta)
        if (math.abs(start - end_) < (delta or 0.01)) then
            return end_
        end
        speed = speed or 0.095
        local time = globals.frametime() * (175 * speed)
        return ((end_ - start) * time + start)
    end,
}
local simtime_old = 0;
local defensive_until = 0;
local simtime = 0;
local activity = 0;
local way = 0
local function contains(source, target)
    for id, name in pairs(ui.get(source)) do
        if name == target then
            return true
        end
    end

    return false
end


local all = {
    states = { "standing", "moving", "jumping", "jumping-crouch", "walking", "ducking", "freestand" },
    menu_states = { "~s ", "~m ", "~j ", "~j-c ", "~w ", "~d ", "~fs " }
}
local menu = {
    global = {
        menu = ui.new_combobox("LUA", "A", "sirius \a96C83CFFgamesense",
            { "global", "antihit system", "visuals", "misc" })
    },
    anti_aim = {
        states = ui.new_combobox("LUA", "B", "player\a96C83CFFstate", all.states),
        select = ui.new_combobox("LUA", "A", "buider mode", { "default", "\aB6B665FFdefensive" }),
        def_readt = ui.new_multiselect("LUA", "A", "defensive on", { "hideshots", "doubletap" }),
        defensive = {},
    },
    visuals = {
        indicators = ui.new_checkbox("LUA", "B", "indicators"),
        ind_color = ui.new_color_picker("LUA", "B", "indicators", 255, 255, 255, 255),
        logs = ui.new_checkbox("LUA", "B", "hitlogs"),
    },
    misc = {},

}

for i = 1, #all.states do
    menu.anti_aim[i] = {
        pitch = ui.new_combobox("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "pitch",
            { "off", "default", "up", "down", "minimal", "random", "custom" }),
        custom_pitch = ui.new_slider("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "custom pitch", -89, 89, 0, true,
            '°'),
        yawbase = ui.new_combobox("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "yaw base",
            { "local view", "at targets" }),
        yaw = ui.new_combobox("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "yaw",
            { "off", "180", "spin", "static", "180z", "crosshair" }),
        yawjitter = ui.new_combobox("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "yaw jitter",
            { "off", "offset", "center", "random", "skitter" }),
        jitterint = ui.new_slider("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "jitter", -180, 180, 0, true, '°'),
        yawadd = ui.new_combobox("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "yaw add type",
            { "static", "2-side", "slowed", "3-way", "5-way" }),

        yawstatic = ui.new_slider("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "static", -180, 180, 0, true, '°'),

        yawleft = ui.new_slider("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "left", -180, 180, 0, true, '°'),
        yawright = ui.new_slider("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "right", -180, 180, 0, true, '°'),
        ticks = ui.new_slider("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "slowed by", 2, 8, 0, true, 't'),

        way1 = ui.new_slider("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "way 1", -180, 180, 0, true, '°'),
        way2 = ui.new_slider("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "way 2", -180, 180, 0, true, '°'),
        way3 = ui.new_slider("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "way 3", -180, 180, 0, true, '°'),
        way4 = ui.new_slider("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "way 4", -180, 180, 0, true, '°'),
        way5 = ui.new_slider("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "way 5", -180, 180, 0, true, '°'),

        bodyyaw = ui.new_combobox("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "body yaw",
            { "off", "opposite", "jitter", "static" }),
        bodyint = ui.new_slider("LUA", "B", "\aFFFFFFC8" .. all.menu_states[i] .. "desync", -180, 180, 0, true, '°'),
        bodyfree = ui.new_checkbox("LUA", "B", all.menu_states[i] .. "freestanding body yaw"),
        defensive = {
            force = ui.new_checkbox("LUA", "B",
                "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "override defensive"),
            enable = ui.new_checkbox("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "enable"),
            pitch = ui.new_combobox("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "pitch",
                { "off", "default", "up", "down", "minimal", "random", "custom" }),
            custom_pitch = ui.new_slider("LUA", "B",
                "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "custom pitch", -89, 89, 0, true, '°'),
            yawbase = ui.new_combobox("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "yaw base",
                { "local view", "at targets" }),
            yaw = ui.new_combobox("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "yaw",
                { "off", "180", "spin", "static", "180z", "crosshair" }),

            yawjitter = ui.new_combobox("LUA", "B",
                "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "yaw jitter",
                { "off", "offset", "center", "random", "skitter" }),
            jitterint = ui.new_slider("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "jitter",
                -180, 180, 0, true, '°'),

            yawadd = ui.new_combobox("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "yaw add type",
                { "static", "2-side", "slowed", "3-way", "5-way" }),

            yawstatic = ui.new_slider("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "static",
                -180, 180, 0, true, '°'),

            yawleft = ui.new_slider("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "left", -180,
                180, 0, true, '°'),
            yawright = ui.new_slider("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "right", -180,
                180, 0, true, '°'),
            ticks = ui.new_slider("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "slowed by", 2, 8,
                0, true, 't'),

            way1 = ui.new_slider("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "way 1", -180, 180,
                0, true, '°'),
            way2 = ui.new_slider("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "way 2", -180, 180,
                0, true, '°'),
            way3 = ui.new_slider("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "way 3", -180, 180,
                0, true, '°'),
            way4 = ui.new_slider("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "way 4", -180, 180,
                0, true, '°'),
            way5 = ui.new_slider("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "way 5", -180, 180,
                0, true, '°'),
            bodyyaw = ui.new_combobox("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "body yaw",
                { "off", "opposite", "jitter", "static" }),
            bodyint = ui.new_slider("LUA", "B", "\aB6B665FFdef " .. "\aFFFFFFC8" .. all.menu_states[i] .. "desync", -180,
                180, 0, true, '°'),
            bodyfree = ui.new_checkbox("LUA", "B", "\aB6B665FFdef " .. all.menu_states[i] .. "freestanding body yaw"),
        }
    }
end
log.add                = function(text, r, g, b, a)
    client.color_log(r, g, b, "[sirius] " .. text)
    table.insert(logs, 1, { text = text, r1 = r, g1 = g, b1 = b, a1 = a, alpha = 0, time = globals.curtime() + 4 })
end
local helpers          = {
    last_sim_time = 0,
    defensive_until = 0,

    is_defensive = function(self)
        if not entity.get_local_player() then
            return false
        end
        local tickcount = globals.tickcount();
        local local_player = entity.get_local_player();
        local sim_time = Math.time_to_ticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"));
        if ((ui.get(refs.double_tap[2]) and contains(menu.anti_aim.def_readt, "doubletap")) or (ui.get(refs.on_shot_anti_aim[2]) and contains(menu.anti_aim.def_readt, "hideshots"))) then
            local sim_diff = sim_time - self.last_sim_time;

            if sim_diff < 0 then
                self.defensive_until = tickcount + math.abs(sim_diff) -
                    Math.time_to_ticks(client.latency());
            end

            self.last_sim_time = sim_time;

            return self.defensive_until > tickcount;
        end
    end,
    get_charge = function()
        local target = entity.get_local_player()
        if not target then
            return
        end

        local weapon = entity.get_player_weapon(target)

        if target == nil or weapon == nil then
            return false
        end

        if get_curtime(16) < entity.get_prop(target, 'm_flNextAttack') then
            return false
        end

        if get_curtime(0) < entity.get_prop(weapon, 'm_flNextPrimaryAttack') then
            return false
        end

        return true
    end

}

local playerstate      = 0
local air_tick         = 0
local in_air           = false
local tick_switch      = 0
local screenx, screeny = client.screen_size()
local callbacks        = {
    on_paint = {
        menu_elements = function()
            local tab = ui.get(menu.global.menu)

            ui.set_visible(menu.anti_aim.states, tab == "antihit system")
            ui.set_visible(menu.anti_aim.select, tab == "antihit system")
            ui.set_visible(menu.anti_aim.def_readt, tab == "antihit system")
            ui.set_visible(menu.visuals.indicators, tab == "visuals")
            ui.set_visible(menu.visuals.ind_color, tab == "visuals" and ui.get(menu.visuals.indicators))
            for i = 1, #all.states do
                ui.set_visible(menu.anti_aim[i].defensive.enable,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive")
                ui.set_visible(menu.anti_aim[i].defensive.force,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive")

                ui.set_visible(menu.anti_aim[i].pitch,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "default")
                ui.set_visible(menu.anti_aim[i].custom_pitch,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim[i].pitch) == "custom" and ui.get(menu.anti_aim.select) == "default")
                ui.set_visible(menu.anti_aim[i].yawbase,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "default")
                ui.set_visible(menu.anti_aim[i].yaw,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "default")
                ui.set_visible(menu.anti_aim[i].yawadd,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "default")

                ui.set_visible(menu.anti_aim[i].yawjitter,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "default")

                ui.set_visible(menu.anti_aim[i].jitterint,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "default" and
                    (ui.get(menu.anti_aim[i].yawjitter) == "offset" or ui.get(menu.anti_aim[i].yawjitter) == "center" or ui.get(menu.anti_aim[i].yawjitter) == "random" or ui.get(menu.anti_aim[i].yawjitter) == "skitter"))
                ui.set_visible(menu.anti_aim[i].yawstatic,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim[i].yawadd) == "static" and ui.get(menu.anti_aim.select) == "default")
                ui.set_visible(menu.anti_aim[i].yawleft,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].yawadd) == "2-side" or ui.get(menu.anti_aim[i].yawadd) == "slowed") and
                    ui.get(menu.anti_aim.select) == "default")
                ui.set_visible(menu.anti_aim[i].yawright,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].yawadd) == "2-side" or ui.get(menu.anti_aim[i].yawadd) == "slowed") and
                    ui.get(menu.anti_aim.select) == "default")
                ui.set_visible(menu.anti_aim[i].ticks,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].yawadd) == "slowed") and ui.get(menu.anti_aim.select) == "default")
                ui.set_visible(menu.anti_aim[i].way1,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].yawadd) == "3-way" or ui.get(menu.anti_aim[i].yawadd) == "5-way") and
                    ui.get(menu.anti_aim.select) == "default")
                ui.set_visible(menu.anti_aim[i].way2,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].yawadd) == "3-way" or ui.get(menu.anti_aim[i].yawadd) == "5-way") and
                    ui.get(menu.anti_aim.select) == "default")
                ui.set_visible(menu.anti_aim[i].way3,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].yawadd) == "3-way" or ui.get(menu.anti_aim[i].yawadd) == "5-way") and
                    ui.get(menu.anti_aim.select) == "default")
                ui.set_visible(menu.anti_aim[i].way4,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].yawadd) == "5-way") and ui.get(menu.anti_aim.select) == "default")
                ui.set_visible(menu.anti_aim[i].way5,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].yawadd) == "5-way") and ui.get(menu.anti_aim.select) == "default")

                ui.set_visible(menu.anti_aim[i].bodyyaw,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "default")
                ui.set_visible(menu.anti_aim[i].bodyint,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "default" and
                    (ui.get(menu.anti_aim[i].bodyyaw) == "jitter" or ui.get(menu.anti_aim[i].bodyyaw) == "static"))
                ui.set_visible(menu.anti_aim[i].bodyfree,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "default")


                ui.set_visible(menu.anti_aim[i].defensive.pitch,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)
                ui.set_visible(menu.anti_aim[i].defensive.custom_pitch,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim[i].defensive.pitch) == "custom" and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)
                ui.set_visible(menu.anti_aim[i].defensive.yawbase,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)
                ui.set_visible(menu.anti_aim[i].defensive.yaw,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)
                ui.set_visible(menu.anti_aim[i].defensive.yawadd,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)

                ui.set_visible(menu.anti_aim[i].defensive.yawstatic,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim[i].defensive.yawadd) == "static" and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)
                ui.set_visible(menu.anti_aim[i].defensive.yawleft,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].defensive.yawadd) == "2-side" or ui.get(menu.anti_aim[i].yawadd) == "slowed") and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)
                ui.set_visible(menu.anti_aim[i].defensive.yawright,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].defensive.yawadd) == "2-side" or ui.get(menu.anti_aim[i].yawadd) == "slowed") and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)
                ui.set_visible(menu.anti_aim[i].defensive.ticks,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].defensive.yawadd) == "slowed") and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)
                ui.set_visible(menu.anti_aim[i].defensive.way1,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].defensive.yawadd) == "3-way" or ui.get(menu.anti_aim[i].defensive.yawadd) == "5-way") and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)
                ui.set_visible(menu.anti_aim[i].defensive.way2,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].defensive.yawadd) == "3-way" or ui.get(menu.anti_aim[i].defensive.yawadd) == "5-way") and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)
                ui.set_visible(menu.anti_aim[i].defensive.way3,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].defensive.yawadd) == "3-way" or ui.get(menu.anti_aim[i].defensive.yawadd) == "5-way") and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)
                ui.set_visible(menu.anti_aim[i].defensive.way4,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].defensive.yawadd) == "5-way") and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)
                ui.set_visible(menu.anti_aim[i].defensive.way5,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    (ui.get(menu.anti_aim[i].defensive.yawadd) == "5-way") and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)


                ui.set_visible(menu.anti_aim[i].defensive.yawjitter,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim[i].defensive.enable) == true and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive")

                ui.set_visible(menu.anti_aim[i].defensive.jitterint,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true and
                    (ui.get(menu.anti_aim[i].defensive.yawjitter) == "offset" or ui.get(menu.anti_aim[i].defensive.yawjitter) == "center" or ui.get(menu.anti_aim[i].defensive.yawjitter) == "random" or ui.get(menu.anti_aim[i].defensive.yawjitter) == "skitter"))




                ui.set_visible(menu.anti_aim[i].defensive.bodyyaw,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true)
                ui.set_visible(menu.anti_aim[i].defensive.bodyint,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive" and
                    ui.get(menu.anti_aim[i].defensive.enable) == true and
                    (ui.get(menu.anti_aim[i].defensive.bodyyaw) == "jitter" or ui.get(menu.anti_aim[i].defensive.bodyyaw) == "static"))
                ui.set_visible(menu.anti_aim[i].defensive.bodyfree,
                    tab == "antihit system" and ui.get(menu.anti_aim.states) == all.states[i] and
                    ui.get(menu.anti_aim[i].defensive.enable) == true and
                    ui.get(menu.anti_aim.select) == "\aB6B665FFdefensive")
            end
        end,
        indicators = function()
            local local_player = entity.get_local_player()
            if not local_player or not entity.is_alive(local_player) then return end
            if not ui.get(menu.visuals.indicators) then return end
            local dt_anim = animations:process("Is charged", helpers.get_charge(), 8)
            local bind_color = { ui.get(menu.visuals.ind_color) }
            local dt_r, dt_g, dt_b = lerp({ 255, 25, 25, 255 }, { bind_color[1], bind_color[2], bind_color[3], 255 },
                dt_anim)
            local list = {
                {
                    name = "DT",
                    path = refs.double_tap[2],
                    r = dt_r,
                    g = dt_g,
                    b = dt_b,
                    get_bool = 0,
                    scope = 0
                },
                {
                    name = "OS",
                    path = refs.on_shot_anti_aim[2],
                    r = 255,
                    g = 255,
                    b = 255,
                    get_bool = 0,
                    scope = 0
                },
                {
                    name = "DMG",
                    path = refs.dmg[2],
                    r = 200,
                    g = 200,
                    b = 200,
                    get_bool = 0,
                    scope = 0
                },
                {
                    name = "PA",
                    path = refs.auto_peek[2],
                    r = bind_color[1],
                    g = bind_color[2],
                    b = bind_color[3],
                    get_bool = 0,
                    scope = 0
                },

            }
            local ay = 0
            local x, y = screenx / 2, screeny / 2
            local scoped = entity.get_prop(local_player, "m_bIsScoped")
            local anim = animations:process("Indicators", scoped == 1 and true or false, 8)
            local add_x = 24 * anim
            local build_text = renderer.measure_text("c-", "BETA")
            local sirius_text = renderer.measure_text("c-", "SIRIUS ")
            renderer.text(x - 2 + add_x - build_text / 2, y + 20, 255, 255, 255, 255, "c-", nil, "SIRIUS")
            renderer.text(x - 1 + add_x + sirius_text / 2, y + 20, 255, 255, 255, 255, "c-", 0,
                "\a" .. rgba_to_hex(ui.get(menu.visuals.ind_color)) .. "BETA")

            for k, v in pairs(list) do
                v.get_bool = animations:process(v.name .. " anim", ui.get(v.path) and true or false, 8)
                v.scope = (renderer.measure_text("c-", "SIRIUS") / 2 + renderer.measure_text("c-", v.name) / 2 - 10) *
                    anim
                renderer.text(x - 1 + v.scope, y + 28 + ay, v.r, v.g, v.b, 255 * v.get_bool, "c-", 0, v.name)
                ay = ay + 8 * v.get_bool
            end
        end,
        logs = function()
            local ss = {}
            ss.x, ss.y = screenx, screeny
            local offset = 0
            local local_player = entity.get_local_player()
            if not local_player then logs = {} end
            if not ui.get(menu.visuals.logs) then return end
            for i, v in pairs(logs) do
                if v.time > globals.curtime() and i <= 10 then
                    v.alpha = math.lerp(v.alpha, 255, 0.13)
                else
                    v.alpha = math.lerp(v.alpha, 0, 0.13)
                    if v.alpha < 0 then
                        table.remove(logs, i)
                    end
                end

                renderer.text(ss.x / 2 - 50 + (50 * (v.alpha / 255)), ss.y / 2 + 155 + offset, v.r1, v.g1, v.b1, v.alpha,
                    "c", 0, v.text)
                offset = offset + 15 * (v.alpha / 255)
            end
        end

    },
    on_create_move = {
        builder = function(cmd)
            local local_player = entity.get_local_player()

            if not local_player then return end



            local flag = entity.get_prop(local_player, "m_fFlags")

            local vel = vector(entity.get_prop(local_player, 'm_vecVelocity')):length2d()
            local ducked = entity.get_prop(local_player, 'm_bDucked') == 1
            if ui.get(refs.freestanding[2]) then
                playerstate = 7
            else
                if flag == 256 or flag == 262 then
                    in_air = true
                    air_tick = globals.tickcount() + 3
                else
                    in_air = (air_tick > globals.tickcount()) and true or false
                end
                if in_air and ducked then
                    playerstate = 4
                else
                    if in_air then
                        playerstate = 3
                    else
                        if ducked then
                            playerstate = 6
                        else
                            if ui.get(refs.slow_motion[2]) then
                                playerstate = 5
                            else
                                if vel < 5 then
                                    playerstate = 1
                                else
                                    playerstate = 2
                                end
                            end
                        end
                    end
                end
            end


            local body_yaw = entity.get_prop(local_player, 'm_flPoseParameter', 11)

            if globals.chokedcommands() == 0 or globals.chokedcommands() == 1 then
                Angle2 = Math.round(body_yaw * 120 - 60)
            end

            if ui.get(menu.anti_aim[playerstate].yawadd) == "slowed" or ui.get(menu.anti_aim[playerstate].defensive.yawadd) == "2-side" then
                if globals.chokedcommands() == 0 or globals.chokedcommands() == 1 then
                    tick_switch = tick_switch + 1
                end
                speed_tick = ui.get(menu.anti_aim[playerstate].ticks)
                if tick_switch == speed_tick then
                    side = 0
                end
                if tick_switch >= speed_tick * 2 then
                    side = 1
                    tick_switch = 0
                end
            end
            if globals.chokedcommands() == 0 or globals.chokedcommands() == 1 then
                if ui.get(menu.anti_aim[playerstate].yawadd) == "3-way" or ui.get(menu.anti_aim[playerstate].defensive.yawadd) == "3-way" then
                    way = way + 1
                    if way > 2 then
                        way = 0
                    end
                end
                if ui.get(menu.anti_aim[playerstate].yawadd) == "5-way" or ui.get(menu.anti_aim[playerstate].defensive.yawadd) == "5-way" then
                    way = way + 1
                    if way > 4 then
                        way = 0
                    end
                end
            end

            if ui.get(menu.anti_aim[playerstate].yawadd) == "2-side" or ui.get(menu.anti_aim[playerstate].defensive.yawadd) == "2-side" then
                if Angle2 >= 0 then
                    side = 1
                end
                if Angle2 <= 0 then
                    side = 0
                end
            end

            ui.set(refs.pitch[1], ui.get(menu.anti_aim[playerstate].pitch))
            ui.set(refs.pitch[2], ui.get(menu.anti_aim[playerstate].custom_pitch))
            ui.set(refs.yaw_base, ui.get(menu.anti_aim[playerstate].yawbase))

            ui.set(refs.yaw[1], ui.get(menu.anti_aim[playerstate].yaw))
            if ui.get(menu.anti_aim[playerstate].yawadd) == "static" then
                ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].yawstatic))
            end
            ui.set(refs.yaw_jitter[1], ui.get(menu.anti_aim[playerstate].yawjitter))
            ui.set(refs.yaw_jitter[2], ui.get(menu.anti_aim[playerstate].jitterint))
            if ui.get(menu.anti_aim[playerstate].yawadd) == "2-side" then
                if side == 0 then
                    ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].yawleft))
                end
                if side == 1 then
                    ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].yawright))
                end
            end

            if ui.get(menu.anti_aim[playerstate].yawadd) == "slowed" then
                if side == 0 then
                    ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].yawleft))
                end
                if side == 1 then
                    ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].yawright))
                end
            end

            if ui.get(menu.anti_aim[playerstate].yawadd) == "3-way" then
                if way == 0 then
                    ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].way1))
                end
                if way == 1 then
                    ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].way2))
                end
                if way == 2 then
                    ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].way3))
                end
            end


            if ui.get(menu.anti_aim[playerstate].yawadd) == "5-way" then
                if way == 0 then
                    ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].way1))
                end
                if way == 1 then
                    ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].way2))
                end
                if way == 2 then
                    ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].way3))
                end
                if way == 3 then
                    ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].way4))
                end
                if way == 4 then
                    ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].way5))
                end
            end
            ui.set(refs.body_yaw[1], ui.get(menu.anti_aim[playerstate].bodyyaw))
            local byaw
            if side == 0 then
                byaw = ui.get(menu.anti_aim[playerstate].bodyint) * 1
            end
            if side == 1 then
                byaw = ui.get(menu.anti_aim[playerstate].bodyint) * -1
            end
            if ui.get(menu.anti_aim[playerstate].yawadd) == "slowed" and ui.get(menu.anti_aim[playerstate].bodyyaw) == "jitter" then
                ui.set(refs.body_yaw[1], "static")

                ui.set(refs.body_yaw[2], byaw)
            else
                ui.set(refs.body_yaw[2], ui.get(menu.anti_aim[playerstate].bodyint))
            end

            ui.set(refs.freestanding_body_yaw, ui.get(menu.anti_aim[playerstate].bodyfree))

            cmd.force_defensive = ui.get(menu.anti_aim[playerstate].defensive.force)

            if helpers:is_defensive() then
                if ui.get(menu.anti_aim[playerstate].defensive.enable) then
                    ui.set(refs.yaw_jitter[1], ui.get(menu.anti_aim[playerstate].defensive.yawjitter))
                    ui.set(refs.yaw_jitter[2], ui.get(menu.anti_aim[playerstate].defensive.jitterint))
                    ui.set(refs.pitch[1], ui.get(menu.anti_aim[playerstate].defensive.pitch))
                    ui.set(refs.pitch[2], ui.get(menu.anti_aim[playerstate].defensive.custom_pitch))
                    ui.set(refs.yaw_base, ui.get(menu.anti_aim[playerstate].defensive.yawbase))

                    ui.set(refs.yaw[1], ui.get(menu.anti_aim[playerstate].defensive.yaw))
                    if ui.get(menu.anti_aim[playerstate].defensive.yawadd) == "static" then
                        ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].defensive.yawstatic))
                    end

                    if ui.get(menu.anti_aim[playerstate].defensive.yawadd) == "2-side" then
                        if side == 0 then
                            ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].defensive.yawleft))
                        end
                        if side == 1 then
                            ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].defensive.yawright))
                        end
                    end

                    if ui.get(menu.anti_aim[playerstate].defensive.yawadd) == "slowed" then
                        if side == 0 then
                            ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].defensive.yawleft))
                        end
                        if side == 1 then
                            ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].defensive.yawright))
                        end
                    end

                    if ui.get(menu.anti_aim[playerstate].defensive.yawadd) == "3-way" then
                        if way == 0 then
                            ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].defensive.way1))
                        end
                        if way == 1 then
                            ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].defensive.way2))
                        end
                        if way == 2 then
                            ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].defensive.way3))
                        end
                    end


                    if ui.get(menu.anti_aim[playerstate].defensive.yawadd) == "5-way" then
                        if way == 0 then
                            ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].defensive.way1))
                        end
                        if way == 1 then
                            ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].defensive.way2))
                        end
                        if way == 2 then
                            ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].defensive.way3))
                        end
                        if way == 3 then
                            ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].defensive.way4))
                        end
                        if way == 4 then
                            ui.set(refs.yaw[2], ui.get(menu.anti_aim[playerstate].defensive.way5))
                        end
                    end
                    ui.set(refs.body_yaw[1], ui.get(menu.anti_aim[playerstate].defensive.bodyyaw))
                    local byaw2
                    if side == 0 then
                        byaw2 = ui.get(menu.anti_aim[playerstate].defensive.bodyint) * 1
                    end
                    if side == 1 then
                        byaw2 = ui.get(menu.anti_aim[playerstate].defensive.bodyint) * -1
                    end
                    if ui.get(menu.anti_aim[playerstate].defensive.yawadd) == "slowed" and ui.get(menu.anti_aim[playerstate].defensive.bodyyaw) == "jitter" then
                        ui.set(refs.body_yaw[1], "static")

                        ui.set(refs.body_yaw[2], byaw2)
                    else
                        ui.set(refs.body_yaw[2], ui.get(menu.anti_aim[playerstate].defensive.bodyint))
                    end

                    ui.set(refs.freestanding_body_yaw, ui.get(menu.anti_aim[playerstate].defensive.bodyfree))
                end
            end
        end
    }
}

local function aim_miss(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"

    log.add(string.format(
        "Missed %s's %s due to %s",
        entity.get_player_name(e.target), group, e.reason
    ), 255, 125, 125, 255)
end

client.set_event_callback("aim_miss", aim_miss)
local function aim_hit(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"

    log.add(string.format(
        "Hit %s's in the %s for %d damage (%d health remaining)",
        entity.get_player_name(e.target), group, e.damage,
        entity.get_prop(e.target, "m_iHealth")
    ), 150, 200, 60, 255)
end

client.set_event_callback("aim_hit", aim_hit)
local function aim_fire(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    log.add(string.format(
        "Fired at %s's %s for %d dmg (hc=%d%%, bt=%2d)",
        entity.get_player_name(e.target), group, e.damage,
        math.floor(e.hit_chance + 0.5), Math.time_to_ticks(e.backtrack)
    ), 255, 255, 255, 255)
end

client.set_event_callback("aim_fire", aim_fire)
client.set_event_callback("setup_command", function(cmd)
    for k, v in pairs(callbacks.on_create_move) do
        v(cmd)
    end
end)

client.set_event_callback("paint", function()
    for k, v in pairs(callbacks.on_paint) do
        v()
    end
end)

