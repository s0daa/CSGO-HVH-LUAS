-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local entity_f, anti_aim, vector = require("gamesense/entity"), require("gamesense/antiaim_funcs"), require("vector")

local tab, container = "lua", "b"
local menu = {
    t_1 = ui.new_label(tab, container, "\ad2bbff98[[-----------------------------------]]"),

    type = ui.new_textbox(tab, container, "enter name here"),

    x_1 = ui.new_label(tab, container, "primary accent"),
    pri = ui.new_color_picker(tab, container, "x1", 210, 187, 255, 255),

    x_2 = ui.new_label(tab, container, "secondary accent"),
    sec = ui.new_color_picker(tab, container, "x2"),

    style = ui.new_combobox(tab, container, "randomisation style", "static", "dynamic"),
    amount = ui.new_slider(tab, container, "randomisation scale", 0, 30, 25),

    cache = ui.new_slider(tab, container, "reset fakelag", 0, 15, 15),
    def = ui.new_checkbox(tab, container, "force defensive in-air"),

    gs = ui.new_label(tab, container, "utilities for \a9FCA2BFFgamesense"),

    sigma = ui.new_button(tab, container, "kill sigma from \a9FCA2BFFgamesense", function()
        local renderer_text = renderer.text
        renderer.text = function(x, y, r, g, b, a, flags, max_width, ...)
            local arguments = table.concat({...})

            if arguments:find("shoppy") or arguments:find("@") or arguments:find("sigma") then
                return
            end
    
            return renderer_text(x, y, r, g, b, a, flags, max_width, ...)
        end
    end),

    t_1 = ui.new_label(tab, container, "\ad2bbff98[[-----------------------------------]]")
}
ui.set(menu.type, "origin")

local storage = {
    refs = {
        pitch = ui.reference("aa", "anti-aimbot angles", "pitch"),
        yaw = { ui.reference("aa", "anti-aimbot angles", "yaw") },
        jitter = { ui.reference("aa", "anti-aimbot angles", "yaw jitter") },
        body_yaw = { ui.reference("aa", "anti-aimbot angles", "body yaw") },
        fake_limit = ui.reference("aa", "anti-aimbot angles", "fake yaw limit"),

        fl_limit = ui.reference("aa", "fake lag", "limit"),
        fd = ui.reference("RAGE", "Other", "Duck peek assist"),

        dt = { ui.reference("rage", "other", "double tap") },
        hs = { ui.reference("aa", "other", "on shot anti-aim") }
    },

    bruteforce = {
        last = globals.curtime(),
        duration = 0,
        counter = 0,
        side = { },
        yaw = { }
    },

    debug = { "", "", "", "" }
}

local util = { }
function util.normalise(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return yaw
end

function util.calc_angle(local_x, local_y, enemy_x, enemy_y)
    local ydelta = local_y - enemy_y
    local xdelta = local_x - enemy_x
    local relativeyaw = math.atan( ydelta / xdelta )
    relativeyaw = util.normalise( relativeyaw * 180 / math.pi )
    if xdelta >= 0 then
        relativeyaw = util.normalise(relativeyaw + 180)
    end
    return relativeyaw
end

function util.angle_vector(angle_x, angle_y)
	local sy = math.sin(math.rad(angle_y))
	local cy = math.cos(math.rad(angle_y))
	local sp = math.sin(math.rad(angle_x))
	local cp = math.cos(math.rad(angle_x))
	return cp * cy, cp * sy, -sp
end

function util.clamp(num, min, max)
    if num > max then
        return max
    elseif min > num then
        return min
    end
    return num
end

function util.ping(player_resource, ent) 
    return entity.get_prop(player_resource, string.format('%03d', ent)) 
end

function util.rgba(redArg, greenArg, blueArg, alphaArg)
    return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
end

function util.array(r, g, b)
    local colors = {}
    for i = 0, 18 do
        local color = {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + i * 5 / 30))}
        table.insert(colors, color)
    end
    return colors
end

function util.velocity(ent) 
    local speed = math.sqrt(math.pow(entity.get_prop(ent, "m_vecVelocity[0]"), 2) + math.pow(entity.get_prop(ent, "m_vecVelocity[1]"), 2)) 
    return speed 
end

function util.freestand()
    if client.current_threat() == nil then
        return 0
    end

    local me = entity.get_local_player()

    local local_pos, enemy_pos = vector(entity.hitbox_position(me, 0)), vector(entity.hitbox_position(client.current_threat(), 0))

    local yaw = util.calc_angle(local_pos.x, local_pos.y, enemy_pos.x, enemy_pos.y)
    local l_dir, r_dir = vector(util.angle_vector(0, (yaw + 90))), vector(util.angle_vector(0, (yaw - 90)))
    local l_pos, r_pos = vector(local_pos.x + l_dir.x * 110, local_pos.y + l_dir.y * 110, local_pos.z), vector(local_pos.x + r_dir.x * 110, local_pos.y + r_dir.y * 110, local_pos.z)

    local fraction, hit_ent = client.trace_line(client.current_threat(), enemy_pos.x, enemy_pos.y, enemy_pos.z, l_pos.x, l_pos.y, l_pos.z)
    local fraction_s, hit_ent_s = client.trace_line(client.current_threat(), enemy_pos.x, enemy_pos.y, enemy_pos.z, r_pos.x, r_pos.y, r_pos.z)

    if fraction > fraction_s then
        return 1
    elseif fraction_s > fraction then
        return 2
    elseif fraction == fraction_s then
        return 3
    end
end

local obex_data = obex_fetch and obex_fetch() or {username = "developer", build = "source", discord="redacted"}

for i = 1, 64 do
    storage.bruteforce.yaw[i] = { 38, 0, -29 }  
    storage.bruteforce.side[i] = 1
end

local reset = ui.new_button(tab, container, "reset anti-aim", function()
    for i = 1, 64 do
        storage.bruteforce.yaw[i] = { 25, 0, -25 }
        storage.bruteforce.side[i] = 1
    end
end)

local visuals = { }
function visuals.outline(x, y, w, h, r, g, b, a, radius, thickness)
    y = y + radius
    local data_circle = {
        {x + radius, y, 180},
        {x + w - radius, y, 270},
        {x + radius, y + h - radius * 2, 90},
        {x + w - radius, y + h - radius * 2, 0},
    }

    local data = {
        {x + radius, y + h - radius - thickness, w - radius * 2, thickness},
        {x, y, thickness, h - radius * 2},
        {x + w - thickness, y, thickness, h - radius * 2}
    }

    for _, data in next, data_circle do
        renderer.circle_outline(data[1], data[2], r, g, b, a, radius, data[3], 0.25, thickness)
    end

    for _, data in next, data do
        renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
    end
end

function visuals.rect(x, y, w, h, r, g, b, a, radius)
    y = y + radius
    local data_circle = {
        {x + radius, y, 180},
        {x + w - radius, y, 90},
        {x + radius, y + h - radius * 2, 270},
        {x + w - radius, y + h - radius * 2, 0},
    }

    local data = {
        {x + radius, y, w - radius * 2, h - radius * 2},
        {x + radius, y - radius, w - radius * 2, radius},
        {x + radius, y + h - radius * 2, w - radius * 2, radius},
        {x, y, radius, h - radius * 2},
        {x + w - radius, y, radius, h - radius * 2},
    }

    for _, data in next, data_circle do
        renderer.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
    end

    for _, data in next, data do
        renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
    end
end

function visuals.render()
    storage.debug[1], storage.debug[2], storage.debug[3], storage.debug[4] = client.current_threat() == nil and "none" or string.format("%s - %sms", string.lower(entity.get_player_name(client.current_threat())), util.ping(entity.get_all("CCSPlayerResource")[1], client.current_threat())), client.current_threat() == nil and "[0, 0, 0] - none" or string.format("[%s, %s, %s] - %s", storage.bruteforce.yaw[client.current_threat()][1], storage.bruteforce.yaw[client.current_threat()][2], storage.bruteforce.yaw[client.current_threat()][3], ui.get(storage.refs.yaw[2])), string.format("[%s, %s] - %s", util.freestand(), ui.get(storage.refs.body_yaw[2]), string.lower(ui.get(storage.refs.body_yaw[1]))), string.format("exploit - %s [%s, %s]", entity.is_alive(entity.get_local_player()) and anti_aim.get_double_tap() or "false", anti_aim.get_tickbase_shifting(), (ui.get(storage.refs.dt[2]) and ui.get(storage.refs.hs[2])) and "true" or "false")

    local x, y = client.screen_size()
    local primary, secondary = { ui.get(menu.pri) }, { ui.get(menu.sec) }
    local length = renderer.measure_text("b", ui.get(menu.type)) + renderer.measure_text("", string.lower(obex_data.username))

    visuals.rect(9, y / 2 + 39, length + 18, 19, 37, 37, 37, 255, 3)
    visuals.rect(10, y / 2 + 40, length + 16, 17, 17, 17, 23, 255, 3)
    visuals.outline(10, y / 2 + 40, length + 16, 17, primary[1], primary[2], primary[3], 255, 3, 1)

    renderer.text(15, y / 2 + 41, primary[1], primary[2], primary[3], 255, "b", nil, ui.get(menu.type))
    renderer.text(20 + renderer.measure_text("b", ui.get(menu.type)), y / 2 + 41, 105, 105, 105, 255, "", nil, string.lower(obex_data.username))

    for i = 1, #storage.debug do
        renderer.text(10, y / 2 + 43 + i * 17, 255, 255, 255, 255, "", nil, storage.debug[i])
    end
end

local main = { }
function main.micro_move(c)
    local local_player = entity.get_local_player()
    if c.chokedcommands == 0 or util.velocity(local_player) > 5 or c.in_attack == 1 then return end

    c.forwardmove = 0.1
    c.in_forward = 1
end

function main.run(c)
    if storage.debug[1] == "none" or not entity.is_alive(entity.get_local_player()) or globals.chokedcommands() > 2 then
        ui.set(storage.refs.yaw[1], "180")
        ui.set(storage.refs.yaw[2], "0")
        ui.set(storage.refs.jitter[1], "center")
        ui.set(storage.refs.jitter[2], "20")
        ui.set(storage.refs.body_yaw[1], globals.chokedcommands() > 2 and "opposite" or "static")
        ui.set(storage.refs.body_yaw[2], "0")
        ui.set(storage.refs.fake_limit, "60")
        return
    end

    local latency, amount = util.ping(entity.get_all("CCSPlayerResource")[1], client.current_threat()), ui.get(menu.amount)

    dynamic = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 0 and 0 or (ui.get(menu.style) == "dynamic" and math.random(-amount / 2, amount / 2) * (util.clamp(latency, 0, 25) / 25) or math.random(-amount / 2, amount / 2))

    c.force_defensive = (bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 0 and ui.get(menu.def) and globals.tickcount() % 16 ~= 1) and 1 or 0
    storage.bruteforce.yaw[client.current_threat()][2] = math.random(-5, 5)
    storage.bruteforce.duration = globals.tickcount() % 7   

    ui.set(storage.refs.yaw[1], "180")
    --ui.set(storage.refs.fake_limit, ui.get(storage.refs.body_yaw[1]) == "jitter" and 57 or 47)

    ui.set(storage.refs.jitter[1], "center")
    ui.set(storage.refs.jitter[2], "0")

    local manage_y = ((storage.bruteforce.duration == 3 or storage.bruteforce.duration == 2) and bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) ~= 0) and storage.bruteforce.yaw[client.current_threat()][2] or (storage.bruteforce.duration > 2 and storage.bruteforce.yaw[client.current_threat()][1] or storage.bruteforce.yaw[client.current_threat()][3])
    ui.set(storage.refs.yaw[2], manage_y + dynamic)

    ui.set(storage.refs.body_yaw[1], (math.abs(storage.bruteforce.yaw[client.current_threat()][1]) < -20 or storage.bruteforce.yaw[client.current_threat()][3] > 20) or storage.bruteforce.last >= globals.curtime() and "jitter" or "static")
    ui.set(storage.refs.body_yaw[2], storage.bruteforce.last >= globals.curtime() and (util.clamp(util.freestand() * 60 * storage.bruteforce.side[client.current_threat()], bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 0 and -60 or -180, bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 0 and 60 or 180)) or 0)

    ui.set(storage.refs.fl_limit, (ui.get(storage.refs.hs[2]) and not ui.get(storage.refs.fd)) and 1 or ui.get(menu.cache))
end

function main.dodge(c)
    local shooter_id, local_player = c.userid, entity.get_local_player()
    local shooter = client.userid_to_entindex(shooter_id)

    if not entity.is_enemy(shooter) or entity.is_dormant(shooter) or not entity.is_alive(local_player) then
        return
    end
    
    local enemy_pos = vector(entity.hitbox_position(shooter, 0))
    local local_pos = vector(entity.hitbox_position(local_player, 0))
    local dist = ((c.y - enemy_pos.y) * local_pos.x - (c.x - enemy_pos.x) * local_pos.y + c.x * enemy_pos.y - c.y * enemy_pos.x) / math.sqrt((c.y-enemy_pos.y) ^ 2 + (c.x - enemy_pos.x) ^ 2)

    if math.abs(dist) <= 60 and globals.curtime() - storage.bruteforce.last > 0.01 then
        local cur_side = anti_aim.get_desync(2) < 0 and 3 or 1

        storage.bruteforce.yaw[shooter][cur_side] = cur_side == 3 and util.clamp(-math.floor(math.abs(dist)), -65, -25) or util.clamp(math.floor(math.abs(dist)), 25, 65)
        storage.bruteforce.side[shooter] = storage.bruteforce.side[shooter] * -1
        storage.bruteforce.last = globals.curtime() + 2
    end
end

function main.reset()
    for i = 1, 64 do
        storage.bruteforce.yaw[i] = { 25, 0, -25 }
        storage.bruteforce.side[i] = 1
    end
end

local events = {
    func = {
        ["bullet_impact"] = { main.dodge },
        ["setup_command"] = { main.run },
        ["game_newmap"] = { main.reset },
        ["paint"] = { visuals.render }
    }
}

function events.init()
    for value in pairs(events.func) do
        for i = 1, #events.func[value] do
            client.set_event_callback(value, events.func[value][i])
        end
    end
end

do
    events.init()
end