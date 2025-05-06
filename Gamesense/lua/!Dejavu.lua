---------------------------------------------------------------require
local ease = require "gamesense/easing"
local ent = require "gamesense/entity"
local antiaim_funcs = require 'gamesense/antiaim_funcs'
local vector = require "vector"
local ffi = require "ffi"
local clipboard = require("gamesense/clipboard")
local base64 = require("gamesense/base64")
local http = require("gamesense/http")
local images = require 'gamesense/images'
local weapons_funcs = require "gamesense/csgo_weapons"

---------------------------------------------------------------Element
local bit_band, bit_lshift, client_color_log, client_create_interface, client_delay_call, client_find_signature,
client_key_state, client_reload_active_scripts, client_screen_size, client_set_event_callback, client_system_time,
client_timestamp, client_unset_event_callback, database_read, database_write, entity_get_classname,
entity_get_local_player, entity_get_origin, entity_get_player_name, entity_get_prop, entity_get_steam64,
entity_is_alive, globals_framecount, globals_realtime, math_ceil, math_floor, math_max, math_min,
panorama_loadstring, renderer_gradient, renderer_line, renderer_rectangle, table_concat, table_insert, table_remove,
table_sort, ui_get, ui_is_menu_open, ui_mouse_position, ui_menu_position, ui_menu_size, ui_new_checkbox, ui_new_color_picker, ui_new_combobox,
ui_new_slider, ui_set, ui_set_visible, setmetatable, pairs, error, globals_absoluteframetime, globals_curtime,
globals_frametime, globals_maxplayers, globals_tickcount, globals_tickinterval, math_abs, type, pcall,
renderer_circle_outline, renderer_load_rgba, renderer_measure_text, renderer_text, renderer_texture, tostring,
ui_name, ui_new_button, ui_new_hotkey, ui_new_label, ui_new_listbox, ui_new_textbox, ui_reference, ui_set_callback,
ui_update, unpack, tonumber = bit.band, bit.lshift, client.color_log, client.create_interface, client.delay_call,
    client.find_signature, client.key_state, client.reload_active_scripts, client.screen_size,
    client.set_event_callback, client.system_time, client.timestamp, client.unset_event_callback, database.read,
    database.write, entity.get_classname, entity.get_local_player, entity.get_origin, entity.get_player_name,
    entity.get_prop, entity.get_steam64, entity.is_alive, globals.framecount, globals.realtime, math.ceil, math.floor,
    math.max, math.min, panorama.loadstring, renderer.gradient, renderer.line, renderer.rectangle, table.concat,
    table.insert, table.remove, table.sort, ui.get, ui.is_menu_open, ui.mouse_position, ui.menu_position, ui.menu_size, ui.new_checkbox,
    ui.new_color_picker, ui.new_combobox, ui.new_slider, ui.set, ui.set_visible, setmetatable, pairs, error,
    globals.absoluteframetime, globals.curtime, globals.frametime, globals.maxplayers, globals.tickcount,
    globals.tickinterval, math.abs, type, pcall, renderer.circle_outline, renderer.load_rgba, renderer.measure_text,
    renderer.text, renderer.texture, tostring, ui.name, ui.new_button, ui.new_hotkey, ui.new_label, ui.new_listbox,
    ui.new_textbox, ui.reference, ui.set_callback, ui.update, unpack, tonumber
local entity_get_local_player, entity_is_enemy, entity_get_all, entity_set_prop, entity_is_alive, entity_is_dormant,
entity_get_player_name, entity_get_game_rules, entity_hitbox_position, entity_get_players,
entity_get_prop, entity_get_player_weapon = entity.get_local_player, entity.is_enemy, entity.get_all, entity.set_prop, entity.is_alive,
    entity.is_dormant, entity.get_player_name, entity.get_game_rules, entity.hitbox_position,
    entity.get_players, entity.get_prop, entity.get_player_weapon
local math_cos, math_sin, math_rad, math_sqrt, math_floor = math.cos, math.sin, math.rad, math.sqrt, math.floor
local ui_new_multiselect, renderer_circle = ui.new_multiselect, renderer.circle

local ffi_cdef, ffi_cast, ffi_new = ffi.cdef, ffi.cast, ffi.new
local bit_band, bit_bor = bit.band, bit.bor

local RenderRoundRectangle = function(vecPosition, vecSize, flRadius, clrColor)
	if clrColor[4] <= 0 then
		return
	end

	renderer.rectangle(vecPosition.x, vecPosition.y + flRadius, flRadius, vecSize.y - flRadius * 2, clrColor[1], clrColor[2], clrColor[3], clrColor[4])
	renderer.rectangle(vecPosition.x + flRadius, vecPosition.y, vecSize.x - flRadius * 2, flRadius, clrColor[1], clrColor[2], clrColor[3], clrColor[4])
	renderer.circle(vecPosition.x + flRadius, vecPosition.y + flRadius, clrColor[1], clrColor[2], clrColor[3], clrColor[4], flRadius, 180, 0.25)
	renderer.circle(vecPosition.x + flRadius, vecPosition.y + vecSize.y - flRadius, clrColor[1], clrColor[2], clrColor[3], clrColor[4], flRadius, 270, 0.25)
	renderer.rectangle(vecPosition.x + flRadius, vecPosition.y + vecSize.y - flRadius, vecSize.x - flRadius * 2, flRadius, clrColor[1], clrColor[2], clrColor[3], clrColor[4])
	renderer.rectangle(vecPosition.x + flRadius, vecPosition.y + flRadius, vecSize.x - flRadius * 2, vecSize.y - flRadius * 2, clrColor[1], clrColor[2], clrColor[3], clrColor[4])
	renderer.circle(vecPosition.x + vecSize.x - flRadius, vecPosition.y + flRadius, clrColor[1], clrColor[2], clrColor[3], clrColor[4], flRadius, 90, 0.25)
	renderer.circle(vecPosition.x + vecSize.x - flRadius, vecPosition.y + vecSize.y - flRadius, clrColor[1], clrColor[2], clrColor[3], clrColor[4], flRadius, 0, 0.25)
	renderer.rectangle(vecPosition.x + vecSize.x - flRadius, vecPosition.y + flRadius, flRadius, vecSize.y - flRadius * 2, clrColor[1], clrColor[2], clrColor[3], clrColor[4])
end


local printf = function (data)
    print(tostring(data))
end
local colors = {
    blue = "\aA9B7FFFF",
    bright = "\aE3E9FFFF",
    grey = "\aFFFFFF8D",
    default = "\aD5D5D5FF",
    bright_red = "\aFF9A9AFF",
    white = "\aFFFFFFFF",
    new_blue = "\aBABAF9F7"
}

local rgba_to_hex = function(b, c, d, e)
    return string.format('%02x%02x%02x%02x', b, c, d, e)
end

local function contains(tbl, val)
    for i = 1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

local methodCache = {
    counter1 = 0,
    counter2 = 0,
    yaw1 = 0,
    yaw2 = 0,
    yaw3 = 0,
    body1 = 0,
    body2 = 0,
    body3 = 0,
    switch = {
        boolean1 = false,
        boolean2 = false,
        boolean3 = false
    },
    lc_invert = false,
    lc_last = true
}

local random_jitter = 0

local normalize_yaw = function(x)
    if x == nil then
        return 0
    end
    x = (x % 360 + 360) % 360
    return x > 180 and x - 360 or x
end

-- >> Lua notify paint

local rect_outline = function(x, y, w, h, r, g, b, a, t)
    renderer_rectangle(x, y, w - t, t, r, g, b, a)
    renderer_rectangle(x, y + t, t, h - t, r, g, b, a)
    renderer_rectangle(x + w - t, y, t, h - t, r, g, b, a)
    renderer_rectangle(x + t, y + h - t, w - t, t, r, g, b, a)
end

local function gs_window(x, y, w, h, alpha, grad)
    local bgcontents =
    "\x14\x14\x14\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x14\x14\x14\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF\x0C\x0C\x0C\xFF\x14\x14\x14\xFF"
    local bgtexture = renderer.load_rgba(bgcontents, 4, 4)
    local inbounds = {
        x = x + 6,
        y = y + (grad and 10 or 6),
        w = w - 12,
        h = h - (grad and 16 or 12)
    }

    renderer_texture(bgtexture, inbounds.x, inbounds.y, inbounds.w, inbounds.h, 255, 255, 255, 255 * alpha, "r")

    rect_outline(x, y, w, h, 12, 12, 12, 255 * alpha, 1)
    rect_outline(x + 1, y + 1, w - 2, h - 2, 60, 60, 60, 255 * alpha, 1)
    rect_outline(x + 2, y + 2, w - 4, h - 4, 40, 40, 40, 255 * alpha, 3)
    rect_outline(x + 5, y + 5, w - 10, h - 10, 60, 60, 60, 255 * alpha, 1)

    if grad then
        rect_outline(x + 6, y + 6, w - 12, 4, 12, 12, 12, 255 * alpha, 1)
        renderer_rectangle(x + 7, y + 8, w - 14, 1, 3, 2, 13, 255 * alpha)

        local alphas = { 255, 128 }
        local width = math.floor(w / 2) - 12
        local width2 = x + w - (x + width) - 12

        for i = 1, 2 do
            local a = alphas[i] * alpha
            renderer_gradient(x + 6, y + i + 5, width, 1, 55, 177, 218, a, 201, 84, 192, a, true)
            renderer_gradient(x + width + 6, y + i + 5, width2, 1, 201, 84, 192, a, 204, 227, 54, a, true)
        end
    end

    return inbounds
end

local notify = (function()
    local b = {
        callback_registered = false,
        maximum_count = 5,
        data2 = {}
    }
    function b:stored_callbacks()
        if self.callback_registered then
            return
        end
        client_set_event_callback("paint", function()
            local c = { client_screen_size() }
            local e = 5;
            local f = self.data2;
            for g = #f, 1, -1 do
                self.data2[g].time = self.data2[g].time - globals_frametime()
                local h, i = 255, 0;
                local j = f[g]
                if j.time < 0 then
                    table_remove(self.data2, g)
                else
                    local m = j.def_time - j.time;
                    local m = m > 1 and 1 or m;
                    if j.time < 0.5 or m < 0.5 then
                        i = (m < 1 and m or j.time) / 0.5;
                        if i < 0.2 then
                            e = e + 15 * (1.0 - i / 0.2)
                        end
                    end
                    local v = { renderer_measure_text(nil, j.draw) }
                    local w = { c[1] / 2 - v[1] / 2 + 3, c[2] - c[2] / 100 * 17.4 + e }
                    gs_window(w[1] - 4, w[2] - 20, v[1] + 26, v[2] + 24, 1, true)
                    renderer_text(w[1] + v[1] / 2 + 7, w[2] - 2, 255, 255, 255, 255, "c", nil, j.draw)
                    e = e - 45
                end
            end
            self.callback_registered = true
        end)
    end

    function b:paint(y, text)
        local A = tonumber(y) + 1;
        for g = self.maximum_count, 2, -1 do
            self.data2[g] = self.data2[g - 1]
        end
        self.data2[1] = {
            time = A,
            def_time = A,
            draw = text
        }
        self:stored_callbacks()
    end

    return b
end)()

---------------------------------------------------------------References
local references = {
    aa_enabled = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
    body_freestanding = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    pitch = { ui_reference("AA", "Anti-aimbot angles", "Pitch") },
    yaw = { ui_reference("AA", "Anti-aimbot angles", "Yaw") },
    body_yaw = { ui_reference("AA", "Anti-aimbot angles", "Body yaw") },
    yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    jitter = { ui_reference("AA", "Anti-aimbot angles", "Yaw jitter") },
    edge_yaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    freestanding = { ui_reference("AA", "Anti-aimbot angles", "Freestanding") },
    fake_lag = ui_reference("AA", "Fake lag", "Amount"),
    fake_lag_limit = ui_reference("AA", "Fake lag", "Limit"),
    fakeduck = ui_reference("RAGE", "Other", "Duck peek assist"),
    legmovement = ui_reference("AA", "Other", "Leg movement"),
    slow_walk = { ui_reference("AA", "Other", "Slow motion") },
    roll = ui_reference("AA", "Anti-aimbot angles", "Roll"),
    -- rage references
    aimbot = ui_reference("RAGE", "Aimbot", "Enabled"),
    doubletap = { ui_reference("RAGE", "Aimbot", "Double Tap") },
    dt_hit_chance = ui_reference("RAGE", "Aimbot", "Double tap hit chance"),
    onshot = { ui_reference("AA", "Other", "On shot anti-aim") },
    mindmg = ui_reference("RAGE", "Aimbot", "Minimum damage"),
    fba_key = ui_reference("RAGE", "Aimbot", "Force body aim"),
    fl = { ui_reference("AA", "Fake lag", "Enabled") },

    fsp_key = ui_reference("RAGE", "Aimbot", "Force safe point"),
    ap = ui_reference("RAGE", "Other", "Delay shot"),
    sw,
    slowmotion_key = ui_reference("AA", "Other", "Slow motion"),
    quick_peek = { ui_reference("Rage", "Other", "Quick peek assist") },

    -- visiual reference
    flags = ui_reference("Visuals", "Player ESP", "Flags"),
    min_dmg = ui_reference("RAGE", "Aimbot", "Minimum damage"),
    min_dmg_override = { ui_reference("Rage", "Aimbot", "Minimum damage override") },
    third = ui_reference("Visuals", "Effects", "Force Third Person (alive)"),

    -- misc references
    untrust = ui_reference("MISC", "Settings", "Anti-untrusted"),
    sv_maxusrcmdprocessticks = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks2"),
    auto_grenade_enable = ui_reference("MISC", "Miscellaneous", "Automatic grenade release"),
    auto_grenade_dmg = ui_reference("MISC", "Miscellaneous", "Minimum grenade damage"),

    -- settings reference
    dpi_scale = ui_reference("MISC", "Settings", "DPI scale")

    -- end of menu references and menu creation
}

local function vanila_skeet_element(state)
    ui_set_visible(references.pitch[1], state)
    ui_set_visible(references.pitch[2], state)
    ui_set_visible(references.yaw_base, state)
    ui_set_visible(references.yaw[1], state)
    ui_set_visible(references.yaw[2], state)
    ui_set_visible(references.jitter[1], state)
    ui_set_visible(references.jitter[2], state)
    ui_set_visible(references.body_yaw[1], state)
    ui_set_visible(references.body_yaw[2], state)
    ui_set_visible(references.body_freestanding, state)
    ui_set_visible(references.roll, state)
    ------------------------------------------------------------
    -- Freestanding
    ui_set_visible(references.freestanding[1], state)
    ui_set_visible(references.freestanding[2], state)
    ------------------------------------------------------------
    -- Edge yaw
    ui_set_visible(references.edge_yaw, state)
    ------------------------------------------------------------
    -- Roll
    ------------------------------------------------------------
    -- Enabled
    ui_set_visible(references.aa_enabled, state)
end

---------------------------------------------------------------Menu desgin
local TAB = { "AA", "Anti-aimbot angles", "Fake lag" }
local State = { "Global", "Standing", "Running", "Slow", "Ducking", "Duck Running", "Jumping", "Jump Duck", "Fakelag",
    "Hideshot",
    "High Range" }

local menu_ = {
    setup = ui_new_checkbox(TAB[1], "Fake lag", colors.bright_red .. colors.new_blue .. "✦ osmangang ✦"),
    
    render = {
        alpha = 0,
        list = {"Info", "Antiaim", "Visuals", "Misc", "Config"},
        icon = {
            ["Info"]      = images.load(base64.decode("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")),
            ["Antiaim"]   = images.load(base64.decode("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")),
            ["Visuals"]   = images.load(base64.decode("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")),
            ["Misc"]      = images.load(base64.decode("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")),
            ["Config"]    = images.load(base64.decode("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")),
        },
        background_texture = renderer_load_rgba("\x14\x14\x14\xFF\x14\x14\x14\xFF\x0c\x0c\x0c\xFF\x14\x14\x14\xFF\x0c\x0c\x0c\xFF\x14\x14\x14\xFF\x0c\x0c\x0c\xFF\x14\x14\x14\xFF\x0c\x0c\x0c\xFF\x14\x14\x14\xFF\x14\x14\x14\xFF\x14\x14\x14\xFF\x0c\x0c\x0c\xFF\x14\x14\x14\xFF\x0c\x0c\x0c\xFF\x14\x14\x14\xFF", 5, 5),
        active = "Info",
    },
    info = {
        label_update = {
            ui_new_label(TAB[1], TAB[2],  colors.new_blue .."             ❖ Information ❖ \n"),
            ui_new_label(TAB[1], TAB[2],  colors.bright .. "\n"),
            ui_new_label(TAB[1], TAB[2],  colors.bright .. "# Fix Defensive Check \n"),
            ui_new_label(TAB[1], TAB[2],  colors.bright .. "# Add Defensive Delay \n"),
            ui_new_label(TAB[1], TAB[2],  colors.bright .. "# Add Autodischarge \n"),
            ui_new_label(TAB[1], TAB[2],  colors.bright .. "# Bodyyaw Fix\n"),
            ui_new_label(TAB[1], TAB[2], "\n"),
        },
        label_user = ui_new_label(TAB[1], TAB[2],
            "\a666666ffWelcome Back!  \aFFFFFFFF" ..colors.new_blue .. entity_get_player_name(entity_get_local_player())),
        label_updated = ui_new_label(TAB[1], TAB[2], "\a666666ffLast updated ".. colors.new_blue .."2024/05/30"),
    },


    reducer = ui_new_multiselect(TAB[1], "Other", "Reduce Onshot", "Force Defensive", "No Choke"),

    Antiaim = {
        extra = {}
    },
    Visuals = {},
    Misc = {}

}


local function get_velocity(player)
    local x, y, z = entity_get_prop(player, "m_vecVelocity")
    if x == nil then
        return
    end
    return math.sqrt(x * x + y * y + z * z)
end

local function get_camera_pos(enemy)
    local e_x, e_y, e_z = entity_get_prop(enemy, "m_vecOrigin")
    if e_x == nil then
        return
    end
    local _, _, ofs = entity_get_prop(enemy, "m_vecViewOffset")
    e_z = e_z + (ofs - (entity_get_prop(enemy, "m_flDuckAmount") * 16))
    return e_x, e_y, e_z
end
local function fired_at(target, shooter, shot)
    local shooter_cam = { get_camera_pos(shooter) }
    if shooter_cam[1] == nil then
        return
    end
    local player_head = { entity_hitbox_position(target, 0) }
    local shooter_cam_to_head = { player_head[1] - shooter_cam[1], player_head[2] - shooter_cam[2],
        player_head[3] - shooter_cam[3] }
    local shooter_cam_to_shot = { shot[1] - shooter_cam[1], shot[2] - shooter_cam[2], shot[3] - shooter_cam[3] }
    local magic =
        ((shooter_cam_to_head[1] * shooter_cam_to_shot[1]) + (shooter_cam_to_head[2] * shooter_cam_to_shot[2]) +
            (shooter_cam_to_head[3] * shooter_cam_to_shot[3])) /
        (math.pow(shooter_cam_to_shot[1], 2) + math.pow(shooter_cam_to_shot[2], 2) +
            math.pow(shooter_cam_to_shot[3], 2))
    local closest = { shooter_cam[1] + shooter_cam_to_shot[1] * magic, shooter_cam[2] + shooter_cam_to_shot[2] * magic,
        shooter_cam[3] + shooter_cam_to_shot[3] * magic }
    local length = math.abs(math.sqrt(math.pow((player_head[1] - closest[1]), 2) +
        math.pow((player_head[2] - closest[2]), 2) +
        math.pow((player_head[3] - closest[3]), 2)))
    local frac_shot = client.trace_line(shooter, shot[1], shot[2], shot[3], player_head[1], player_head[2],
        player_head[3])
    local frac_final = client.trace_line(target, closest[1], closest[2], closest[3], player_head[1], player_head[2],
        player_head[3])
    return (length < 69) and (frac_shot > 0.99 or frac_final > 0.99)
end

local function get_table_length(data)
    if type(data) ~= 'table' then
        return 0
    end
    local count = 0
    for _ in pairs(data) do
        count = count + 1
    end
    return count
end

local vars = {
    ground_ticks = 0,
    end_time = 0,
    is_fire = false,
    chokes = 0,
    def = {
        cmd_num = 0,
        checker = 0,
        tickbase = 0
    },
    defensive_wait_ticks = 0,
    defnesive_run_ticks = 0,
    defensive_delay = false,
    defensive_jitter = 0,
    defensive_spin_amout = 0,
    state = {
        idx = 1,
        name = ""
    },

    realstate = {
        idx = 1,
        name = ""
    },
    way = 1,
    current_tick = 0,


}

local function export_config()
    local settings = {}
    for key, value in pairs(State) do
        settings[tostring(value)] = {}
        for k, v in pairs(menu_.Antiaim[key]) do
            if type(v) ~= "table" then settings[value][k] = ui_get(v) else 
                settings[value][k] = {}
                for key_, value_ in pairs(v) do
                    if type(value_) ~= "table" then  settings[value][k][key_] = ui_get(value_) else
                        settings[value][k][key_] = {}
                        for k_, v_ in pairs(value_) do
                            settings[value][k][key_][k_] = ui_get(v_)
                        end
                    end
                end
            end
        end
    end
    local base64_encode = base64.encode(json.stringify(settings), "base64")
    clipboard.set(base64_encode, "base64")

end

local function import_config()
    local base_decode = base64.decode(clipboard.get(), "base64")
    local settings = json.parse(base_decode)

    for key, value in pairs(State) do
        for k, v in pairs(menu_.Antiaim[key]) do
            local current = settings[value][k]
            if (current ~= nil) then
                if type(current) ~= "table" then ui_set(v, current) else 
                    for key_, value_ in pairs(current) do
                        if type(value_) ~= "table" then ui_set(v[key_],value_) else 
                            for k_, v_ in pairs(value_) do
                                ui_set(v[key_][k_],v_)
                            end
                        end
                    end
                end
            end
        end
    end
end

menu_.render.mouse = {
    clicked = false,
    down = false,

    listener = function(self)
        if not ui_is_menu_open() then return end
        local mouse_down = client_key_state(0x01)
    
        self.clicked = false
    
        if mouse_down then
            if not self.down then
                self.clicked = true
            end
            self.down = true
        else
            self.down = false
        end
    end
}
menu_.render.gamesense_tab = {
    offset = vector(6, 20),
    scale = {["100%"] = 1, ["125%"] = 1.25, ["150%"] = 1.5, ["175%"] = 1.75, ["200%"] = 2},
    tabs = {"Rage", "AA", "Legit", "Visuals", "Misc", "Skins", "Players", "Config", "Lua"},
    active = "Rage",

    listener = function(self)

        if not ui_is_menu_open() then return end
        local mouse = vector(ui_mouse_position())
        local menu = vector(ui_menu_position())
        local menu_size = vector(ui_menu_size())
        local size = vector(75 * self.scale[ui_get(references.dpi_scale)], 64.1 * self.scale[ui_get(references.dpi_scale)])
        for i = 1, #self.tabs do
            local v = self.tabs[i]
            local hovering = mouse.x >= menu.x + self.offset.x and mouse.x <= menu.x + self.offset.x + size.x and mouse.y >= menu.y + self.offset.y + (size.y * (i-1)) and mouse.y <= menu.y + self.offset.y + (size.y * (i))
            if hovering and menu_.render.mouse.clicked then
                self.active = v
            end
        end
    end
}
menu_.render.is_hovering = function(pos, size)
    local mouse_pos = vector(ui_mouse_position())
    return mouse_pos.x > pos.x and mouse_pos.x < pos.x + size.x and mouse_pos.y > pos.y and mouse_pos.y < pos.y + size.y
end

menu_.render.renderer = function(self)
    if not ui_get(menu_.setup) then return end

    if menu_.render.gamesense_tab.active ~= "AA" then return end

    if self.alpha < 1 and not ui_is_menu_open() then return end

    self.alpha = ease.linear(globals_frametime()*40, self.alpha, (ui_is_menu_open() and 255 or 0) - self.alpha, 1)

    local mouse = vector(ui_mouse_position())
    local menu = vector(ui_menu_position())
    local menu_size = vector(ui_menu_size())

    local h = 50

    renderer_rectangle(menu.x, menu.y - (h+6), menu_size.x, (h+6), 0, 0, 0, self.alpha)
    renderer_rectangle(menu.x + 1, menu.y - ((h+6)-1), menu_size.x - 2, ((h+6)-1), 57, 57, 57, self.alpha)
    renderer_rectangle(menu.x + 2, menu.y - ((h+6)-2), menu_size.x - 4, ((h+6)-2), 40, 40, 40, self.alpha)
    renderer_rectangle(menu.x + 5, menu.y - ((h+6)-5), menu_size.x - 10, ((h+6)-5), 57, 57, 57, self.alpha)
    renderer_rectangle(menu.x + 6, menu.y - ((h+6)-6), menu_size.x - 12, h, 12,12,12, self.alpha)
    
    for i = 1, #self.list do
        local tab = self.list[i]
        local tab_size = vector((menu_size.x - 12) / #self.list, h)
        local tab_pos = vector(menu.x + 6 + (tab_size.x * (i - 1)), menu.y - h)
        local hovering = menu_.render.is_hovering(tab_pos, tab_size)
        local active = self.active == tab

        if hovering then
            if menu_.render.mouse.clicked then
                self.active = tab
            end
        end

        local c = active and 255 or hovering and 200 or 150

        if active then
            renderer_rectangle(tab_pos.x, tab_pos.y, tab_size.x, tab_size.y, 30, 30, 30, self.alpha)
            renderer_texture(menu_.render.background_texture, tab_pos.x + 1, tab_pos.y, tab_size.x - 2, tab_size.y, 255, 255, 255, self.alpha, 'r')
        end

        if self.icon[tab] then
            local icon = self.icon[tab]
            local icon_size = vector(icon:measure())    
            local sizes = { ["Info"] = 30, ["Config"] = 38}
            local render_size = sizes[tab] or 30
            icon:draw(tab_pos.x + (tab_size.x / 2) - (render_size/2), tab_pos.y + (tab_size.y / 2) - (render_size/2), render_size, render_size, c, c, c, self.alpha, true)
        else
            renderer_text(tab_pos.x + tab_size.x / 2, tab_pos.y + tab_size.y / 2, 255, 255, 255, self.alpha, "c", 0, tab)
        end
    end
end

menu_.render.avoid_attack = function(self,cmd)
    local menu = vector(ui_menu_position())
    local menu_size = vector(ui_menu_size())
    local pos = vector(menu.x, menu.y - 56)
    local size = vector(menu_size.x, 56)
        if ui_is_menu_open() and menu_.render.is_hovering(pos, size) then
            if cmd.in_attack then
                cmd.in_attack = 0
            end
        end

end

local function gennerate_antiaim()
    -- >> Anti Aim Part
    menu_.Antiaim = {
        state_selector = ui_new_combobox(TAB[1], TAB[2], colors.new_blue .. "                   Player Status", State),
    }

    menu_.Antiaim.extra = {
        extra = ui_new_multiselect(TAB[1], TAB[2], colors.new_blue .. "                 Extra Features",
            "Manual Anti-Aim", "Anti-Back Stab", "Legit Anti-Aim", "Safe Head", "Height advantage"),

        -- >> Manual
        manual_left = ui_new_hotkey(TAB[1], TAB[2], "\a666666ffManual  \aFFFFFFFFLeft"),
        manual_right = ui_new_hotkey(TAB[1], TAB[2], "\a666666ffManual  \aFFFFFFFFRight"),
        manual_forward = ui_new_hotkey(TAB[1], TAB[2], "\a666666ffManual  \aFFFFFFFFForward"),
        manual_back = ui_new_hotkey(TAB[1], TAB[2], "\a666666ffManual  \aFFFFFFFFBack"),
        manual_freestand = ui_new_hotkey(TAB[1], TAB[2], "\a666666ffManual  \aFFFFFFFFFreestanding"),
        manual_static = ui_new_checkbox(TAB[1], TAB[2], "\a666666ffManual  \aFFFFFFFFForce Static Bodyyaw"),
        manual_state = 0,
        -- >> Import/Export
        white_line = ui_new_label(TAB[1], TAB[2], "\n niggwhite"),
        config_export = ui_new_button(TAB[1], TAB[2], "Export Configs", export_config),
        config_import = ui_new_button(TAB[1], TAB[2], "Import Configs", import_config)
    }

    -- >> Jitter Preset
    for i = 1, #State do
        menu_.Antiaim[i] = {}
            ----------------------------------------------------------------------------
        menu_.Antiaim[i].enabled = ui_new_checkbox(TAB[1], TAB[2],"Enable '" .. colors.bright_red .. State[i] .. "\afffffff5' anti-aim")
        menu_.Antiaim[i].pitch = ui_new_combobox(TAB[1], TAB[2], colors.new_blue .. "                        Pitch\n" .. State[i],"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom")
        menu_.Antiaim[i].pitch_value = ui_new_slider(TAB[1], TAB[2], "\n Pitch" .. State[i], -89, 89, 0, true, "°")

        menu_.Antiaim[i].yaw_logic = ui_new_combobox(TAB[1], TAB[2],colors.new_blue .. "                     Yaw type\n" .. State[i], "L & R", "Random", "Slow","Control", "Binary", "Experimental", "Random int", "Remainder", "Labyrinth", "Xways", "LC Avoid", "LC Base")

        menu_.Antiaim[i].jitter_left = ui_new_slider(TAB[1], TAB[2], "\n Yaw #1" .. State[i], -180, 180, 0, true, "°")
        menu_.Antiaim[i].jitter_right = ui_new_slider(TAB[1], TAB[2], "\n Yaw #2" .. State[i], -180, 180, -0, true, "°")
            -- menu_.Antiaim[i].yaw_delay = ui_new_slider(TAB[1], TAB[2], "\n Delayed" .. State[i], 1, 7, 5, true, "t")

        menu_.Antiaim[i].yaw_delay = ui_new_slider(TAB[1], TAB[2], "\n Delayed" .. State[i], 1, 10, 5, true, "t")
            

        menu_.Antiaim[i].xways = {
                ways = ui_new_slider(TAB[1], TAB[2], "Ways\n" .. State[i], 1, 12, 1, true, " "),
                yaw = {},
                delay = {},
            }
            for x = 1, 12 do
                menu_.Antiaim[i].xways.yaw[x] = ui_new_slider(TAB[1], TAB[2], "Way #"..tostring(x).."\n" .. State[i], -180, 180, -0, true, "°")
                menu_.Antiaim[i].xways.delay[x] = ui_new_slider(TAB[1], TAB[2], "Delay #"..tostring(x).."\n" .. State[i], 1, 15, 1, true, "t")
            end
            ----------------------------------------------------------------------------
        menu_.Antiaim[i].yaw_jitter = ui_new_combobox(TAB[1], TAB[2],colors.new_blue .. "                     Yaw jitter\n" .. State[i], "Off", "Offset", "Center","Skitter")

        menu_.Antiaim[i].yaw_jitter_logic = ui_new_combobox(TAB[1], TAB[2], colors.new_blue .. "                  Yaw Jitter type\n" .. State[i], "Default", "L & R","Randoms")

        menu_.Antiaim[i].jitter_range_left = ui_new_slider(TAB[1], TAB[2], "\n Jitter Yaw #1" .. State[i], -180, 180, 0, true, "°")
        menu_.Antiaim[i].jitter_range_right = ui_new_slider(TAB[1], TAB[2], "\n Jitter Yaw #2" .. State[i], -180, 180, 0, true, "°")

            ----------------------------------------------------------------------------
        menu_.Antiaim[i].body_yaw = ui_new_combobox(TAB[1], TAB[2],colors.new_blue .. "                     Body yaw\n" .. State[i], "Off", "Jitter", "Static","Opposite")

        menu_.Antiaim[i].body_yaw_logic = ui_new_combobox(TAB[1], TAB[2], colors.new_blue .. "                  Body yaw type\n" .. State[i], "Default", "L & R",
                "Random", "Momentum", "Slow", "Current")

        menu_.Antiaim[i].body_yaw_fake = ui_new_slider(TAB[1], TAB[2], "\n Fake" .. State[i], 0, 60, 0, true, "%")

        menu_.Antiaim[i].body_yaw_left = ui_new_slider(TAB[1], TAB[2], "\n Body Yaw #1" .. State[i], -180, 180, 0, true, "°")
        menu_.Antiaim[i].body_yaw_right = ui_new_slider(TAB[1], TAB[2], "\n Body Yaw #2" .. State[i], -180, 180, 0, true, "°")
        menu_.Antiaim[i].body_yaw_speed = ui_new_slider(TAB[1], TAB[2], "\n" .. State[i] .. " | Body jitter speed", 0, 31, 31, true,"%", 10 / 3, {[0] = "Random",[31] = "Max (tickbased)"})

        menu_.Antiaim[i].label_white = ui_new_label(TAB[1], TAB[2], "\n nigg")

        menu_.Antiaim[i].defensive_enable = ui_new_checkbox(TAB[1], TAB[2], "\aE3E9FFFFDefensive Function \n" .. State[i])
        menu_.Antiaim[i].defensive_check_mode = ui_new_combobox(TAB[1], TAB[2], "Defensive Mode \n" .. State[i], { "Tickbase" })
        menu_.Antiaim[i].defensive_sensitivity = ui_new_slider(TAB[1], TAB[2], "Defensive Sensitivity\n" .. State[i], 1, 13, 1, true, "")
        menu_.Antiaim[i].defensive_pingsafe = ui_new_checkbox(TAB[1], TAB[2], "Ping calculation \n" .. State[i])
        menu_.Antiaim[i].defensive_control = ui_new_checkbox(TAB[1], TAB[2], "Control defensive \n" .. State[i])
        menu_.Antiaim[i].defensive_delay = ui_new_checkbox(TAB[1], TAB[2], "Delay Angle \n" .. State[i])

        menu_.Antiaim[i].defensive_force = ui_new_checkbox(TAB[1], TAB[2], "Force defensive \n" .. State[i])
        menu_.Antiaim[i].defensive_pitch = ui_new_combobox(TAB[1], TAB[2], "Pitch" .. "\n defensive" .. State[i], { "Off", "Up",
                "Down", "Jitter", "Minimal",
                "Random",
                "Custom",
                "Randomize Jitter",
                "Automatic" })
        menu_.Antiaim[i].defensive_pitch_custom = ui_new_slider(TAB[1], TAB[2], "Custom" .. "\n defensive" .. State[i], -89, 89, 0,
                true, "º")
        menu_.Antiaim[i].defensive_pitch_custom1 = ui_new_slider(TAB[1], TAB[2], "Custom 2" .. "\n defensive" .. State[i], -89, 89,
                0, true, "º")
        menu_.Antiaim[i].defensive_pitch_speed = ui_new_slider(TAB[1], TAB[2], "Speed" .. "\n defensive" .. State[i], 1, 89, 1, true, "º")
        menu_.Antiaim[i].defensive_yaw = ui_new_combobox(TAB[1], TAB[2], "Yaw" .. "\n defensive" .. State[i],
                { "Off", "180", "Spin", "L&R", "Jitter", "Skitter", "Random", "Forward", "Sideways", "Opposite", "Fake Spin" })
        menu_.Antiaim[i].defensive_yaw_custom = ui_new_slider(TAB[1], TAB[2], "\n defensive custom" .. State[i], -180, 180, 0, true,
                "º")
        menu_.Antiaim[i].defensive_yaw_custom1 = ui_new_slider(TAB[1], TAB[2], "\n 2 defensive custom" .. State[i], -180, 180, 0,
                true, "º")

        

    end


    -- >> Visuals Part

    menu_.Visuals = {
        visuals_combobox = ui_new_multiselect(TAB[1], TAB[2],
            colors.new_blue .. "                Extra Indicators", "Main Indicator", "Damage Indicator",
            "User Watermark", "Debug Indicator"),
        main_indicator = ui_new_combobox(TAB[1], TAB[2],
            colors.new_blue .. "                Main Indicator", "Default", "New"),
        animation_select = ui_new_multiselect(TAB[1], TAB[2],
            colors.new_blue .. "                Client Animations", "Static Legs", "Pitch 0 on Land",
            "Static slowwalk legs", "Legs breaker", "Allen walk", "Jitter Leg", "Earthquake", "Flashed")
    }

    -- >> Misc/Animation Part
    menu_.Misc = {

        misc_combobox = ui_new_multiselect(TAB[1], TAB[2], colors.new_blue .. "                    Extra Misc",
            "Resolver", "Enabled Killsay", "Auto Hideshot", "Auto Discharge", "Force DT charging", "Disable force defensive on quickpeek", "Fakelag After DT Shot"),

        resolver_type = ui_new_combobox(TAB[1], TAB[2], "Resolver Version", "Jitter", "Desync"),

        auto_hideshot_disablers = ui_new_multiselect(TAB[1], TAB[2], "Auto Hideshot Disablers",
            { "Knife", "Pistols", "Auto Snipers", "Heavy Pistols", "Rifles" }),
        auto_discharge = ui_new_hotkey(TAB[1], TAB[2], "Auto Discharge On"),
        auto_discharge_lc = ui_new_checkbox(TAB[1], TAB[2], "Auto Discharge Avoid LC"),
        hit_logs = ui_new_multiselect(TAB[1], TAB[2], colors.new_blue .. "                 Ragebot Logged",
            { "Hit", "Miss", "Console" })
    }
end

local function on_loading()
    ui_set(references.yaw[2], 0)
    ui_set(references.jitter[1], "Off")
    ui_set(references.jitter[2], 0)
    ui_set(references.body_yaw[1], "Off")
    ui_set(references.body_yaw[2], 0)
end

on_loading()
gennerate_antiaim()

local defensive_func = {
    update_cmdnumber = function(cmd)
        vars.def.cmd_num = cmd.command_number
    end,
    update_tickbase = function(cmd)
        if cmd.command_number == vars.def.cmd_num then
            local cA = entity_get_prop(entity_get_local_player(), "m_nTickBase")
            vars.def.tickbase = math.abs(cA - vars.def.checker)
            vars.def.checker = math.max(cA, vars.def.checker or 0)
            vars.def.cmd_num = 0
        end
    end,
    is_defensive_active = function()
        local local_player = entity_get_local_player()
        if local_player == nil then
            return false
        end
        if (not ui_get(references.onshot[1]) or not ui_get(references.onshot[2])) and
            (not ui_get(references.doubletap[1]) or not ui_get(references.doubletap[2])) or ui_get(references.fakeduck) then
            return false
        end
local max = 14
local min = 14 - ui_get(menu_.Antiaim[vars.state.idx].defensive_sensitivity) + (ui_get(menu_.Antiaim[vars.state.idx].defensive_pingsafe) and toticks(client.latency()) or 0)
        return vars.def.tickbase > min and vars.def.tickbase < max
    end,
    reset_defensive = function()
        vars.def.tickbase = 0;
        vars.def.checker = 0;
        vars.defensive_wait_ticks = 0;
        vars.defensive_run_ticks = 0;
        vars.defensive_delay = false;
    end
}
local function handle_visible()
    local enable = ui_get(menu_.setup)

    vanila_skeet_element(not enable)
    local info = (menu_.render.active == "Info") and enable

    -- >> Fakelag Improved handle
    ui_set_visible(menu_.reducer, enable)

    -- >> Antiaim handle
    local antiaim = (menu_.render.active == "Antiaim") and enable
    local condition = extra

    local advance = antiaim

    -- >> Visuals handle
    local visuals = (menu_.render.active == "Visuals") and enable
    local animation = visuals

    -- > Misc handle
    local misc = (menu_.render.active == "Misc") and enable

    local config = (menu_.render.active == "Config") and enable
    -- >> Menu navigation
    
    for i = 1, #menu_.info.label_update do
        ui_set_visible(menu_.info.label_update[i], info)
    end

    ui_set_visible(menu_.info.label_user, info)
    ui_set_visible(menu_.info.label_updated, info)



    -- >> Antiaim
    local manual = contains(ui_get(menu_.Antiaim.extra.extra), "Manual Anti-Aim") and misc
    ui_set_visible(menu_.Antiaim.state_selector, antiaim and not condition)
    ui_set_visible(menu_.Antiaim.extra.extra, misc)

    for i = 1, #State do
        local page = (ui_get(menu_.Antiaim.state_selector) == State[i]) and antiaim and not condition
        local page_hide = i == 1 or ui_get(menu_.Antiaim[i].enabled)

        local pitch_logic = (ui_get(menu_.Antiaim[i].pitch) == "Custom")
        local yaw_logic = (ui_get(menu_.Antiaim[i].yaw_logic) == "Default") or not advance
        local xways_logic = (ui_get(menu_.Antiaim[i].yaw_logic) == "Xways") or not advance
        local yaw_jitter_logic = (ui_get(menu_.Antiaim[i].yaw_jitter_logic) == "Default") or not advance
        local body_yaw_logic = (ui_get(menu_.Antiaim[i].body_yaw_logic) == "Default") or not advance
        local momentum_body_logic = (ui_get(menu_.Antiaim[i].body_yaw_logic) == "Momentum") or not advance
        local delay_logic = ui_get(menu_.Antiaim[i].body_yaw_logic) == "Slow" or not advance
        local current_logic = ui_get(menu_.Antiaim[i].body_yaw_logic) == "Current" or not advance
        local defensive_logic = ui_get(menu_.Antiaim[i].defensive_enable)  or not advance

        ui_set_visible(menu_.Antiaim[i].enabled, i ~= 1 and page)
        ui_set_visible(menu_.Antiaim[i].pitch, page and page_hide)
        ui_set_visible(menu_.Antiaim[i].pitch_value, page and pitch_logic and page_hide)
        ui_set_visible(menu_.Antiaim[i].yaw_logic, page and advance and page_hide)

        ui_set_visible(menu_.Antiaim[i].jitter_left, page and not xways_logic and page_hide)
        ui_set_visible(menu_.Antiaim[i].jitter_right, page and not yaw_logic and not xways_logic and page_hide)
        ui_set_visible(menu_.Antiaim[i].yaw_delay,
            page and (ui_get(menu_.Antiaim[i].yaw_logic) == "Slow") and not xways_logic and page_hide)
        ui_set_visible(menu_.Antiaim[i].xways.ways, page and (ui_get(menu_.Antiaim[i].yaw_logic) == "Xways") and page_hide)
        for x = 1, 12 do
            ui_set_visible(menu_.Antiaim[i].xways.yaw[x], page and (ui_get(menu_.Antiaim[i].yaw_logic) == "Xways" and ui_get(menu_.Antiaim[i].xways.ways) >= x) and page_hide)
            ui_set_visible(menu_.Antiaim[i].xways.delay[x], page and (ui_get(menu_.Antiaim[i].yaw_logic) == "Xways" and ui_get(menu_.Antiaim[i].xways.ways) >= x) and page_hide)
        end

        ---
        ui_set_visible(menu_.Antiaim[i].yaw_jitter, page and page_hide)
        ui_set_visible(menu_.Antiaim[i].yaw_jitter_logic, page and advance and page_hide)
        ui_set_visible(menu_.Antiaim[i].jitter_range_left, page and page_hide)
        ui_set_visible(menu_.Antiaim[i].jitter_range_right, page and not yaw_jitter_logic and page_hide)
        ---
        ui_set_visible(menu_.Antiaim[i].body_yaw, page and page_hide)
        ui_set_visible(menu_.Antiaim[i].body_yaw_logic, page and advance and page_hide)

        ui_set_visible(menu_.Antiaim[i].body_yaw_fake, page and advance and delay_logic and page_hide)

        ui_set_visible(menu_.Antiaim[i].body_yaw_left,
            page and not momentum_body_logic and not current_logic and not delay_logic and page_hide)
        ui_set_visible(menu_.Antiaim[i].body_yaw_right,
            page and not body_yaw_logic and not momentum_body_logic and
            not current_logic and not delay_logic and page_hide)
        ui_set_visible(menu_.Antiaim[i].body_yaw_speed,
            page and momentum_body_logic and not current_logic and not delay_logic and page_hide)
        ---
        ui_set_visible(menu_.Antiaim[i].label_white, page and page_hide)

        ui_set_visible(menu_.Antiaim[i].defensive_enable, page and page_hide)
        ui_set_visible(menu_.Antiaim[i].defensive_check_mode, page and defensive_func and page_hide and ui_get(menu_.Antiaim[i].defensive_enable))
        -- ui_set_visible(menu_.Antiaim[i].defensive_force, page and defensive_logic and page_hide)
        ui_set_visible(menu_.Antiaim[i].defensive_force, page and defensive_func and page_hide and ui_get(menu_.Antiaim[i].defensive_enable))

        ui_set_visible(menu_.Antiaim[i].defensive_sensitivity, page and defensive_logic and page_hide)
        ui_set_visible(menu_.Antiaim[i].defensive_pingsafe, page and defensive_logic and page_hide)
        ui_set_visible(menu_.Antiaim[i].defensive_control, page and defensive_logic and page_hide)
        ui_set_visible(menu_.Antiaim[i].defensive_delay, page and defensive_logic and page_hide)
        ui_set_visible(menu_.Antiaim[i].defensive_pitch, page and defensive_logic and page_hide)
        ui_set_visible(menu_.Antiaim[i].defensive_pitch_custom, page and defensive_logic and
            (ui_get(menu_.Antiaim[i].defensive_pitch) == "Custom" or ui_get(menu_.Antiaim[i].defensive_pitch) ==
                "Randomize Jitter" or ui_get(menu_.Antiaim[i].defensive_pitch) == "Automatic" or
                ui_get(menu_.Antiaim[i].defensive_pitch) == "Jitter") and page_hide)
        ui_set_visible(menu_.Antiaim[i].defensive_pitch_custom1,
            page and defensive_logic and (ui_get(menu_.Antiaim[i].defensive_pitch) == "Randomize Jitter" or
                ui_get(menu_.Antiaim[i].defensive_pitch) == "Automatic" or ui_get(menu_.Antiaim[i].defensive_pitch) ==
                "Jitter") and page_hide)
        ui_set_visible(menu_.Antiaim[i].defensive_pitch_speed, page and defensive_logic and ui_get(menu_.Antiaim[i].defensive_pitch) == "Automatic" and page_hide)
        ui_set_visible(menu_.Antiaim[i].defensive_yaw, page and defensive_logic and page_hide)
        ui_set_visible(menu_.Antiaim[i].defensive_yaw_custom,
            page and defensive_logic and ui_get(menu_.Antiaim[i].defensive_yaw) ~= "Off" and
            ui_get(menu_.Antiaim[i].defensive_yaw) ~= "Random" and
            ui_get(menu_.Antiaim[i].defensive_yaw) ~=
            "Sideways" and ui_get(menu_.Antiaim[i].defensive_yaw) ~= "Forward" and
            ui_get(menu_.Antiaim[i].defensive_yaw) ~= "Opposite" and
            ui_get(menu_.Antiaim[i].defensive_yaw) ~= "Premt" and
            ui_get(menu_.Antiaim[i].defensive_yaw) ~= "Fake Spin" and
            page_hide)
        ui_set_visible(menu_.Antiaim[i].defensive_yaw_custom1,
            page and defensive_logic and ui_get(menu_.Antiaim[i].defensive_yaw) == "L&R" and page_hide)
        ---
    end

    ui_set_visible(menu_.Antiaim.extra.manual_left, manual)
    ui_set_visible(menu_.Antiaim.extra.manual_right, manual)
    ui_set_visible(menu_.Antiaim.extra.manual_back, manual)
    ui_set_visible(menu_.Antiaim.extra.manual_forward, manual)
    ui_set_visible(menu_.Antiaim.extra.manual_freestand, manual)
    ui_set_visible(menu_.Antiaim.extra.manual_static, manual)

    ui_set_visible(menu_.Antiaim.extra.white_line, config)
    ui_set_visible(menu_.Antiaim.extra.config_export, config)
    ui_set_visible(menu_.Antiaim.extra.config_import, config)

    -- >> Visuals
    ui_set_visible(menu_.Visuals.visuals_combobox, visuals)
    ui_set_visible(menu_.Visuals.animation_select, animation)
    ui_set_visible(menu_.Visuals.main_indicator, visuals and contains(ui_get(menu_.Visuals.visuals_combobox), "Main Indicator"))

    -- >> Misc
    ui_set_visible(menu_.Misc.misc_combobox, misc)
    ui_set_visible(menu_.Misc.resolver_type, misc and contains(ui_get(menu_.Misc.misc_combobox), "Resolver"))
    ui_set_visible(menu_.Misc.auto_hideshot_disablers, misc and contains(ui_get(menu_.Misc.misc_combobox), "Auto Hideshot"))
    ui_set_visible(menu_.Misc.auto_discharge, misc and contains(ui_get(menu_.Misc.misc_combobox), "Auto Discharge"))
    ui_set_visible(menu_.Misc.auto_discharge_lc, misc and contains(ui_get(menu_.Misc.misc_combobox), "Auto Discharge"))
    ui_set_visible(menu_.Misc.hit_logs, misc)
end

-- >> Menu elements end

local states = {
    inair = function()
        return (bit_band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) == 0)
    end,

    crouching = function()
        return (bit_band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 4) == 0)
    end,

    velocity = function()
        local me = entity_get_local_player()
        local velocity_x, velocity_y = entity_get_prop(me, "m_vecVelocity")
        return math.sqrt(velocity_x ^ 2 + velocity_y ^ 2)
    end
}

local bind_system = {
    l_press = false,
    r_press = false,
    f_press = false,
    b_press = false,
    last_manual = "reset",
}

local function manual()


    local left_state, right_state, forward_state, back_state, freestand_state = ui_get(menu_.Antiaim.extra.manual_left),
        ui_get(menu_.Antiaim.extra.manual_right), ui_get(menu_.Antiaim.extra.manual_forward), ui_get(
            menu_.Antiaim.extra.manual_back), ui_get(menu_.Antiaim.extra.manual_freestand)

    ui_set(references.freestanding[1], freestand_state)
    ui_set(references.freestanding[2], freestand_state and "Always on" or "On hotkey")

    if not right_state and not left_state and not forward_state then
        bind_system.last_manual = "reset"
    end
    
    bind_system.r_press = right_state and bind_system.last_manual ~= "right"
    bind_system.l_press = left_state and bind_system.last_manual ~= "left"
    bind_system.f_press = forward_state and bind_system.last_manual ~= "forward"
    bind_system.b_press = back_state and bind_system.last_manual ~= "reset"

    if bind_system.r_press then
        menu_.Antiaim.extra.manual_state = menu_.Antiaim.extra.manual_state == 2 and 0 or 2
        bind_system.last_manual = "right"
    end

    if bind_system.l_press then
        menu_.Antiaim.extra.manual_state = menu_.Antiaim.extra.manual_state == 1 and 0 or 1
        bind_system.last_manual = "left"
    end

    if bind_system.f_press then
        menu_.Antiaim.extra.manual_state = menu_.Antiaim.extra.manual_state == 3 and 0 or 3
        bind_system.last_manual = "forward"
    end

    if bind_system.b_press then
        menu_.Antiaim.extra.manual_state = 0
        bind_system.last_manual = "reset"
    end
end

-- >> Manual states end


local get_distance = function(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
end

local landtick = 0
local function conditions()
    local localplayer = entity_get_local_player()
    if localplayer == nil then
        return
    end

    local fakelag = not ui_get(references.doubletap[2]) and not ui_get(references.onshot[2])
    local slowwalking = ui_get(references.slow_walk[2])
    local crouch = (not states.crouching()) or ui_get(references.fakeduck)
    local lx, ly, lz = entity_get_prop(entity_get_local_player(), "m_vecOrigin")
    local x, y, z = entity_get_prop(client.current_threat(), "m_vecOrigin")
if states.inair() then
    landtick = 0
else
    landtick = landtick + 1
end
if landtick >= 2 or states.inair() then
    vars.state.idx = 1
    vars.state.name = "Global"
end
    if fakelag and ui_get(menu_.Antiaim[9].enabled) then
        vars.state.idx = 9
        vars.state.name = "FAKELAG"
    elseif slowwalking and ui_get(menu_.Antiaim[4].enabled) then
        vars.state.idx = 4
        vars.state.name = "Slow"
    elseif x ~= nil and get_distance(lx, ly, lz, x, y, z) > 1300 and ui_get(menu_.Antiaim[11].enabled) then
        vars.state.idx = 11
        vars.state.name = "High Range"
    elseif ui_get(references.onshot[1]) and ui_get(references.onshot[2]) and not ui_get(references.doubletap[2]) and ui_get(menu_.Antiaim[10].enabled) then
        vars.state.idx = 10
        vars.state.name = "Hideshot"
    else
        
        if states.inair() then
            if crouch and ui_get(menu_.Antiaim[8].enabled) then
                vars.state.idx = 8
                vars.state.name = "Jump Duck"
            elseif ui_get(menu_.Antiaim[7].enabled) then
                vars.state.idx = 7
                vars.state.name = "Jumping"
            end
        else
            if ui_get(menu_.Antiaim[3].enabled) and states.velocity() > 5 and not crouch and landtick >= 2 then
                vars.state.idx = 3
                vars.state.name = "Running"
            -- elseif ui_get(menu_.Antiaim[2].enabled) and states.velocity() <= 80 and not crouch then
        elseif ui_get(menu_.Antiaim[2].enabled) and states.velocity() <= 5 and not crouch and landtick >= 2 then
                vars.state.idx = 2
                vars.state.name = "Standing"
            elseif ui_get(menu_.Antiaim[6].enabled) and states.velocity() > 5 and crouch and landtick >= 2 then
                vars.state.idx = 6
                vars.state.name = "Duck Running"
            elseif ui_get(menu_.Antiaim[5].enabled) and crouch and landtick >= 2 then
                vars.state.idx = 5
                vars.state.name = "Ducking"
            end
        end
    end

if landtick >= 2 or states.inair() then
vars.realstate.idx = 1
vars.realstate.name = "Global"
end

if slowwalking then
    vars.realstate.idx = 4
    vars.realstate.name = "Slow"
else
    if states.inair() then
        if crouch then
            vars.realstate.idx = 8
            vars.realstate.name = "Jump Duck"
        else
            vars.realstate.idx = 7
            vars.realstate.name = "Jumping"
        end
    else
        if states.velocity() > 5 and not crouch and landtick >= 2 then
            vars.realstate.idx = 3
            vars.realstate.name = "Running"
        -- elseif states.velocity() <= 80 and not crouch then
    elseif states.velocity() <= 5 and not crouch and landtick >= 2 then
            vars.realstate.idx = 2
            vars.realstate.name = "Standing"
        elseif states.velocity() > 5 and crouch and landtick >= 2 then
            vars.realstate.idx = 6
            vars.realstate.name = "Duck Running"
        elseif crouch and landtick >= 2 then
            vars.realstate.idx = 5
            vars.realstate.name = "Ducking"
        end
    end
end
end

-- >> Movement states end

local function inuse(e)
    local weaponn = entity.get_player_weapon()
    if weaponn ~= nil and entity_get_classname(weaponn) == "CC4" then
        if e.in_attack == 1 then
            e.in_attack = 0
            e.in_use = 1
        end
    else
        if e.chokedcommands == 0 then
            e.in_use = 0
        end
    end
end

-- >> Legit Antiaim end

local function backstab()
    local enemies = entity_get_players(true)
    local local_origin = vector(entity_get_origin(entity_get_local_player()))
    for i = 1, #enemies do
        local enemy_origin = vector(entity_get_origin(enemies[i]))
        local distance = local_origin:dist(enemy_origin)
        local weapon = entity_get_player_weapon(enemies[i])
        local class = entity_get_classname(weapon) -- we get enemy's weapon here
        if distance < 300 and class == "CKnife" then
            return true
        end
    end
    return false
end

local function anti_backstab()
    if (contains(ui_get(menu_.Antiaim.extra.extra), "Anti-Back Stab") and backstab()) then
        ui_set(references.yaw[2], 180)
    end
end
-- >> Back Stab end

local height_to_threat = 0

-- >> Lua notify paint end

-- unsafe
local un_safe = {
    local_vulnerable = nil,
    tickbase = nil,

    charged = false,

    data = {},
    index = 1
}

local methods = {

    jitt = function(a, b)
        local desync = entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        return (desync < 0 and a or b)
    end,

    rand = function(a, b)
        return math.random(a, b)
    end,

    count_cache = function(cmd, a, b)
        if cmd.chokedcommands == 0 then
            methodCache.counter1 = methodCache.counter1 + 1
        end
        if methodCache.counter1 >= 10 then
            methodCache.counter1 = 0
        end
        if methodCache.counter1 == 0 then
            return a
        elseif methodCache.counter1 == 1 then
            return a
        elseif methodCache.counter1 == 2 then
            return b
        elseif methodCache.counter1 == 3 then
            return a
        elseif methodCache.counter1 == 4 then
            return b
        elseif methodCache.counter1 == 5 then
            return b
        elseif methodCache.counter1 == 6 then
            return b
        elseif methodCache.counter1 == 7 then
            return a
        elseif methodCache.counter1 == 8 then
            return b
        elseif methodCache.counter1 == 9 then
            return a
        end
        return 0
    end,

    binary = function(cmd, a, b)
        if cmd.chokedcommands == 0 then
            random_jitter = client.random_int(0, 1) == 1 and 1 or -1
        end
        return (random_jitter == -1 and a or b or 0)
    end,

    experimental = function(cmd, a, b)
        if cmd.chokedcommands == 0 then
            methodCache.counter2 = methodCache.counter2 + 1
        end
        if methodCache.counter2 >= 10 then
            methodCache.counter2 = 0
        end
        if methodCache.counter2 == 0 then
            return a
        elseif methodCache.counter2 == 1 then
            return b
        elseif methodCache.counter2 == 2 then
            return b
        elseif methodCache.counter2 == 3 then
            return a
        elseif methodCache.counter2 == 4 then
            return b
        elseif methodCache.counter2 == 5 then
            return a
        elseif methodCache.counter2 == 6 then
            return a
        elseif methodCache.counter2 == 7 then
            return b
        elseif methodCache.counter2 == 8 then
            return a
        elseif methodCache.counter2 == 9 then
            return b
        elseif methodCache.counter2 == 10 then
            return b
        end
    end,

    automatic = function(cmd, a, b)
        local int = client.random_int(1, 6)
        if cmd.command_number % int == 1 then
            methodCache.switch.boolean1 = not methodCache.switch.boolean1
            if methodCache.switch.boolean1 then
                methodCache.yaw1, methodCache.body1 = b, -60
            else
                methodCache.yaw1, methodCache.body1 = a, 60
            end
        end
        return methodCache.yaw1, methodCache.body1
    end,
    remainder = function(cmd, a, b)
        if cmd.command_number % 6 == 1 then -- 默认是6 == 1
            methodCache.switch.boolean2 = not methodCache.switch.boolean2
            if methodCache.switch.boolean2 then
                methodCache.yaw2, methodCache.body2 = b, -123 -- 默认是-1
            else
                methodCache.yaw2, methodCache.body2 = a, 123  -- 默认是-1
            end
        end
        return methodCache.yaw2, methodCache.body2
    end,

    slowSwitch = function(a, b, key)
        local delay = ui_get(menu_.Antiaim[key].yaw_delay)
        local target = delay * 2
        local inverted = (globals.tickcount() % target) >= delay
        return inverted and a or b
    end,

    god = function(cmd, a, b)
        if cmd.command_number % 5 == 1 then -- 默认是6 == 1
            methodCache.switch.boolean3 = not methodCache.switch.boolean3
            if methodCache.switch.boolean3 then
                methodCache.yaw3, methodCache.body3 = b > 0 and math.random(20, b) or math.random(b, 0), -60
            else
                methodCache.yaw3, methodCache.body3 = a > 0 and math.random(20, a) or math.random(a, 0), 60
            end
        end
        return methodCache.yaw3, methodCache.body3
    end,

    xways = function(cmd, ways, way, data)
        if cmd.chokedcommands == 0 then
            if globals_tickcount() + ui_get(data.delay[way]) < vars.current_tick then
                vars.current_tick = globals_tickcount()
            end
            if vars.current_tick + ui_get(data.delay[way]) <= globals_tickcount() then
                vars.way = way < ways and way + 1 or 1
                vars.current_tick = globals_tickcount()
            elseif way > ways then
                vars.way = 1
            end
        elseif way > ways then
            vars.way = 1
        end

        local bodyyaw = (ui_get(data.yaw[way]) == 0 and 0) or (ui_get(data.yaw[way]) > 0 and 123 or -123)
        -- print(tostring(ui_get(data.yaw[way]))) --debug
        return ui_get(data.yaw[way]), bodyyaw
    end,

    lc = function (a,b)
        return methodCache.lc_last == true and a or b
    end
}
local function lc_check(cmd)

    local exploit = (ui_get(references.doubletap[1]) and ui_get(references.doubletap[2])) or (ui_get(references.onshot[1]) and ui_get(references.onshot[2]))
    local fd = ui_get(references.fakeduck)
    local break_lc = vars.def.tickbase > 1 and vars.def.tickbase < 14
    if (not exploit or fd) and cmd.chokedcommands == 0 then
        methodCache.lc_last = math.random(0,1) == 0 and true or false
    elseif ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "LC Avoid" and not break_lc and cmd.chokedcommands == 0 then
        methodCache.lc_invert = true
    elseif ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "LC Base" and break_lc and cmd.chokedcommands == 0 then
        methodCache.lc_invert = true
    end

    if methodCache.lc_invert == true and cmd.chokedcommands == 0 then
        methodCache.lc_last = not methodCache.lc_last
        methodCache.lc_invert = false
    end
end
local un_safe_func = {
    update_vulnerable_state = function(self, local_player)
        if not ui_get(menu_.setup) then
            return
        end
        local th = client.current_threat()

        if th == nil then
            un_safe.local_vulnerable = false
            return
        end

        if ui_get(references.flags) then
            un_safe.local_vulnerable = (bit_band(entity.get_esp_data(th).flags, bit_lshift(1, 11)) == 2048)
            return
        else
            if entity_is_dormant(th) then
                un_safe.local_vulnerable = false
                return
            end

            local start_pos = { entity_hitbox_position(th, 0) }
            local end_pos = { entity_get_prop(local_player, "m_vecOrigin") }
            end_pos[3] = end_pos[3] + 32

            local _, dmg = client.trace_bullet(th, start_pos[1], start_pos[2], start_pos[3], end_pos[1], end_pos[2],
                end_pos[3], false)

            un_safe.local_vulnerable = dmg > 1
        end
    end,
    weapon_can_fire = function(self, ent)
        if not ui_get(menu_.setup) then
            return
        end
        local active_weapon = entity_get_prop(ent, "m_hActiveWeapon")
        local nextAttack = entity_get_prop(active_weapon, "m_flNextPrimaryAttack")
        return globals_curtime() >= nextAttack
    end,
    charge_check = function()
        if not ui_get(menu_.setup) then
            return
        end
        local unsafeDT = contains(ui_get(menu_.Misc.misc_combobox), "Force DT charging")
        if not unsafeDT then
            return
        end
        local local_player = entity_get_local_player()
        if local_player == nil then
            return
        end

        if un_safe.tickbase == nil then
            un_safe.tickbase = entity_get_prop(local_player, 'm_nTickBase')
            return
        end

        local current_tickbase = entity_get_prop(local_player, 'm_nTickBase')

        un_safe.data[un_safe.index] = current_tickbase - un_safe.tickbase
        un_safe.index = un_safe.index + 1
        un_safe.index = un_safe.index % 14

        un_safe.charged = false

        for i = 1, 15 do
            if un_safe.data[i] ~= nil and un_safe.data[i] < 0 then
                un_safe.charged = true
                return
            end
        end

        if un_safe.charged == false and antiaim_funcs.get_tickbase_shifting() > 0 then
            un_safe.charged = true
        end

        un_safe.tickbase = current_tickbase
    end,
    -- add
    unsafe_charging = function(self)
        if not ui_get(menu_.setup) then
            return
        end

        local unsafeDT = contains(ui_get(menu_.Misc.misc_combobox), "Force DT charging")
        if not unsafeDT then
            return
        end

        local local_player = entity_get_local_player()
        if local_player == nil then
            return
        end

        if bit_band(entity_get_prop(local_player, "m_fFlags"), 1) == 1 then
            ui_set(references.aimbot, true)
            return
        end

        self:update_vulnerable_state(local_player)

        if not ui_get(references.doubletap[1]) or not ui_get(references.doubletap[2]) or un_safe.local_vulnerable ==
            false then
            ui_set(references.aimbot, true)
            return
        end

        local weapon = entity.get_player_weapon(local_player)

        if weapon == nil then
            ui_set(references.aimbot, true)
            return
        end

        if self:weapon_can_fire(local_player) and entity_get_classname(weapon) == 'CKnife' then
            ui_set(references.aimbot, true)
        end

        ui_set(references.aimbot, un_safe.charged)
    end
}

-- end


local cache_fire = function()
    vars.is_fire = true
    client_delay_call(0.02, function()
        vars.is_fire = false
    end)
end

local weapons = {
    pistols = {
        "CWeaponHKP2000",
        "CWeaponElite",
        "CWeaponP250",
        "CWeaponFiveSeven",
        "CWeaponGlock",
        "CWeaponTec9",
    },
    autoSnipers = {
        "CWeaponG3SG1",
        "CWeaponSCAR20",
    },
    rifles = {
        "CWeaponM4A1",
        "CWeaponFamas",
        "CWeaponAug",
        "CWeaponGalilAR",
        "CAK47",
        "CWeaponSG556",
    },
    nades = {
        "CHEGrenade",
        "CFlashbang",
        "CSmokeGrenade",
        "CMolotovGrenade",
        "CIncendiaryGrenade",
        "CDecoyGrenade",
    }
}

local flags = {
    ['H'] = { 0, 1 },
    ['K'] = { 1, 2 },
    ['HK'] = { 2, 4 },
    ['ZOOM'] = { 3, 8 },
    ['BLIND'] = { 4, 16 },
    ['RELOAD'] = { 5, 32 },
    ['C4'] = { 6, 64 },
    ['VIP'] = { 7, 128 },
    ['DEFUSE'] = { 8, 256 },
    ['FD'] = { 9, 512 },
    ['PIN'] = { 10, 1024 },
    ['HIT'] = { 11, 2048 },
    ['O'] = { 12, 4096 },
    ['X'] = { 13, 8192 },
    ['DEF'] = { 17, 131072 }
}


local function has_flag(entindex, flag_name)
    if not entindex or not flag_name then
        return false
    end

    local flag_data = flags[flag_name]

    if flag_data == nil then
        return false
    end

    local esp_data = entity.get_esp_data(entindex) or {}

    return bit_band(esp_data.flags or 0, bit.lshift(1, flag_data[1])) == flag_data[2]
end



local shift_ticks = 0
local wait_dt = 0
local function exploit_hanlder(cmd)
    local exploit = (ui_get(references.doubletap[1]) and ui_get(references.doubletap[2])) or (ui_get(references.onshot[1]) and ui_get(references.onshot[2]))
    local fd = ui_get(references.fakeduck)
    local break_lc = vars.def.tickbase > 1 and vars.def.tickbase < 14

    if contains(ui_get(menu_.Misc.misc_combobox), "Auto Discharge") and ui_get(menu_.Misc.auto_discharge) then
        if has_flag(client.current_threat(), 'HIT') then
            if ui_get(menu_.Misc.auto_discharge_lc) then
               if (exploit and not fd) and break_lc then
                    goto skip
               end
            end
            ui_set(references.doubletap[1], false)
            ui_set(references.onshot[1], false)
            shift_ticks = globals_tickcount()
        end
    end
::skip::
    if globals_tickcount() >= shift_ticks + 17 then
        ui_set(references.doubletap[1], true)
    end
    


    if globals_tickcount() <= wait_dt then
        ui_set(references.doubletap[1], false)
    end
    if contains(ui_get(menu_.Misc.misc_combobox), "Auto Hideshot") then
        local get_weapon = entity.get_player_weapon
        local local_player = entity_get_local_player()

        if ui_get(references.doubletap[2]) then
            if contains(ui_get(menu_.Misc.auto_hideshot_disablers), "Knife") then
                if entity_get_classname(get_weapon()) == "CKnife" then
                    return
                end
            end
            if contains(ui_get(menu_.Misc.auto_hideshot_disablers), "Pistols") then
                if contains(weapons.pistols, entity_get_classname(get_weapon(local_player))) then
                    return
                end
            end
            if contains(ui_get(menu_.Misc.auto_hideshot_disablers), "Auto Snipers") then
                if contains(weapons.autoSnipers, entity_get_classname(get_weapon(local_player))) then
                    return
                end
            end
            if contains(ui_get(menu_.Misc.auto_hideshot_disablers), "Heavy Pistols") then
                if entity_get_classname(get_weapon(local_player)) == "CDEagle" then
                    return
                end
            end
            if contains(ui_get(menu_.Misc.auto_hideshot_disablers), "Rifles") then
                if contains(weapons.rifles, entity_get_classname(get_weapon(local_player))) then
                    return
                end
            end

        

        if (vars.realstate.name == "Ducking" or vars.realstate.name == "Duck Running" or vars.realstate.name == "Standing" or vars.realstate.name == "Slow") then
            ui_set(references.doubletap[1], false)
            if globals_tickcount() >= shift_ticks + 17 then
            ui_set(references.onshot[1], true)
            end
            ui_set(references.onshot[2], "Always on")
        else
            if contains(ui_get(menu_.Misc.misc_combobox), "Fakelag After DT Shot") then

                if entity_get_player_weapon(entity_get_local_player()) ~= nil and globals_curtime() < entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_fLastShotTime", 0) + globals_tickinterval() * 17 and globals_curtime() > entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_fLastShotTime", 0) + globals_tickinterval() * 15 and not contains(weapons.nades, entity_get_classname(entity_get_player_weapon(entity_get_local_player()))) then    
                    wait_dt = globals_tickcount() + 20
                end
            end
            if globals_tickcount() >= shift_ticks + 17 then
            ui_set(references.onshot[1], true)
            end
            ui_set(references.onshot[2], "Toggle")
        end
        else
            if contains(ui_get(menu_.Misc.misc_combobox), "Fakelag After DT Shot") then

                if entity_get_player_weapon(entity_get_local_player()) ~= nil and globals_curtime() < entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_fLastShotTime", 0) + globals_tickinterval() * 17 and globals_curtime() > entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_fLastShotTime", 0) + globals_tickinterval() *15 and not contains(weapons.nades, entity_get_classname(entity_get_player_weapon(entity_get_local_player()))) then    
                    wait_dt = globals_tickcount() + 20
                end
            end
            if globals_tickcount() >= shift_ticks + 17 then
            ui_set(references.onshot[1], true)
            end
            ui_set(references.onshot[2], "Toggle")
        end
    else
        if globals_tickcount() >= shift_ticks + 17 then
        ui_set(references.onshot[1], true)
        end
        ui_set(references.onshot[2], "Toggle")
    end

end

local function antiaim_handler(cmd)
    if not ui_get(menu_.setup) then
        return
    end
    
    -- >> Onshot condition
    local os_trigger = vars.is_fire
    local reduce = ui_get(menu_.reducer)
    local onshot = {
        jitter = os_trigger and (contains(reduce, "Force Static") and "Off"),
        body_yaw = os_trigger and
            ((contains(reduce, "No Choke") and "Off") or (contains(reduce, "Force Static") and "Static")),
        side = os_trigger and (contains(reduce, "Force Static") and 180)
    }

    if (contains(reduce, "Force Defensive")) and os_trigger then
        cmd.force_defensive = true
    end
    if (contains(reduce, "No Choke")) and os_trigger then
        cmd.allow_send_packet = true
        cmd.no_choke = true
    end

    manual()
    lc_check(cmd)
    if (defensive_func.is_defensive_active() and ui_get(menu_.Antiaim[vars.state.idx].defensive_enable)) and
        (menu_.Antiaim.extra.manual_state ~= 0 or cmd.in_use ~= 1 or vars.state.name ~= "FAKELAG") and
        (ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch) ~= "Off" or ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw) ~= "Off") then
        return
    end

    local enable = ui_get(menu_.setup)

    local advance = enable

    -- >> Yaw Logic
    local yaw_default = ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "Default" and advance
    local yaw_jitter = ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "L & R" and advance
    local yaw_random = ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "Random" and advance
    local yaw_slow = ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "Slow" and advance
    local yaw_control = ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "Control" and advance
    local yaw_binary = ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "Binary" and advance
    local yaw_experimental = ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "Experimental" and advance
    local yaw_randomint = ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "Random int" and advance
    local yaw_remainder = ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "Remainder" and advance
    local yaw_god = ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "Labyrinth" and advance
    local yaw_xways = ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "Xways" and advance
    local yaw_lc_a = ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "LC Avoid" and advance
    local yaw_lc_b = ui_get(menu_.Antiaim[vars.state.idx].yaw_logic) == "LC Base" and advance

    -- >> Yaw Jitter Logic
    local jitter_range_jitter = ui_get(menu_.Antiaim[vars.state.idx].yaw_jitter_logic) == "L & R" and advance
    local jitter_range_random = ui_get(menu_.Antiaim[vars.state.idx].yaw_jitter_logic) == "Random" and advance
    -- >> Body Yaw Logic
    local body_yaw_jitter = ui_get(menu_.Antiaim[vars.state.idx].body_yaw_logic) == "L & R" and advance
    local body_yaw_random = ui_get(menu_.Antiaim[vars.state.idx].body_yaw_logic) == "Random" and advance
    local body_yaw_momentum = ui_get(menu_.Antiaim[vars.state.idx].body_yaw_logic) == "Momentum" and advance
    local body_yaw_slow = ui_get(menu_.Antiaim[vars.state.idx].body_yaw_logic) == "Slow" and advance
    local body_yaw_current = ui_get(menu_.Antiaim[vars.state.idx].body_yaw_logic) == "Current" and advance

    -- >> Manual
    local is_manual = contains(ui_get(menu_.Antiaim.extra.extra), "Manual Anti-Aim") and enable
    local left = menu_.Antiaim.extra.manual_state == 1 and is_manual
    local right = menu_.Antiaim.extra.manual_state == 2 and is_manual
    local forward = menu_.Antiaim.extra.manual_state == 3 and is_manual
    local manual_static = ui_get(menu_.Antiaim.extra.manual_static) and is_manual

    -- >> Stab
    -- local is_stab = contains(ui_get(menu_.Antiaim.extra.extra), "Anti-Back Stab")
    -- if is_stab then
    --     backstab()
    -- end
    -- local is_stabing = (is_stab and backstab())
    -- if is_stabing then
    --     ui_set(references.yaw[2], 180)
    --     return
    -- end

    -- >> Legit
    local is_legit = contains(ui_get(menu_.Antiaim.extra.extra), "Legit Anti-Aim")
    if is_legit then
        inuse(cmd)
    end



    local is_height_advantage = contains(ui_get(menu_.Antiaim.extra.extra), "Height advantage")

    if is_height_advantage then
        local local_player = entity_get_local_player()
        local on_ground = bit_band(entity_get_prop(local_player, "m_fFlags"), 1) == 1 and cmd.in_jump == 0
        local myorigin = vector(entity_get_origin(local_player))
        local enemy = client.current_threat()
        if enemy ~= nil and entity_is_alive(enemy) then
            local threat_origin = vector(entity_get_origin(enemy))
            height_to_threat = myorigin.z - threat_origin.z
            local speed = get_velocity(local_player)
            if on_ground and height_to_threat >= 25 and (cmd.in_duck == 1 or speed < 5) then
                ui_set(references.yaw[2], 0)
                ui_set(references.jitter[1], "Off")
                ui_set(references.jitter[2], 0)
                ui_set(references.body_yaw[1], "Static")
                ui_set(references.body_yaw[2], 0)
                return
            end
        end
    end

    local bspeed = ui_get(menu_.Antiaim[vars.state.idx].body_yaw_speed)
    local tick_rate = 1 / globals_tickinterval()
    bspeed = bspeed == 0 and client.random_int(1, 30) or (bspeed == 31 and (tick_rate / 2) or bspeed)
    local automatic_yaw, automatic_body = methods.automatic(cmd, ui_get(menu_.Antiaim[vars.state.idx].jitter_left),
        ui_get(menu_.Antiaim[vars.state.idx].jitter_right))

    local remainder_yaw, remainder_body = methods.remainder(cmd, ui_get(menu_.Antiaim[vars.state.idx].jitter_left),
        ui_get(menu_.Antiaim[vars.state.idx].jitter_right))

    local god_yaw, god_body =
        methods.god(cmd, ui_get(menu_.Antiaim[vars.state.idx].jitter_left),
            ui_get(menu_.Antiaim[vars.state.idx].jitter_right))

    local xways_yaw, xways_body = methods.xways(cmd, ui_get(menu_.Antiaim[vars.state.idx].xways.ways),vars.way,menu_.Antiaim[vars.state.idx].xways)

    -- >> Element register
    local anti_aim = {
        Pitch = ui_get(menu_.Antiaim[vars.state.idx].pitch),
        Pitch_value = ui_get(menu_.Antiaim[vars.state.idx].pitch) == "Custom" and
            ui_get(menu_.Antiaim[vars.state.idx].pitch_value),

        Yaw_base = "At targets",

        Yaw_mode = "180",

        Yaw = (left and -90) or (right and 90) or (forward and 180) or
            (yaw_default and ui_get(menu_.Antiaim[vars.state.idx].jitter_left)) or
            (yaw_jitter and methods.jitt(ui_get(menu_.Antiaim[vars.state.idx].jitter_left), ui_get(menu_.Antiaim[vars.state.idx].jitter_right))) or
            (yaw_random and methods.rand(ui_get(menu_.Antiaim[vars.state.idx].jitter_left), ui_get(menu_.Antiaim[vars.state.idx].jitter_right))) or
            (yaw_control and
                methods.count_cache(cmd, ui_get(menu_.Antiaim[vars.state.idx].jitter_left), ui_get(menu_.Antiaim[vars.state.idx].jitter_right))) or
            (yaw_binary and
                methods.binary(cmd, ui_get(menu_.Antiaim[vars.state.idx].jitter_left), ui_get(menu_.Antiaim[vars.state.idx].jitter_right))) or
            (yaw_experimental and
                methods.experimental(cmd, ui_get(menu_.Antiaim[vars.state.idx].jitter_left), ui_get(menu_.Antiaim[vars.state.idx].jitter_right))) or
            (yaw_randomint and normalize_yaw(automatic_yaw)) or (yaw_remainder and normalize_yaw(remainder_yaw)) or
            (yaw_slow and
                methods.slowSwitch(ui_get(menu_.Antiaim[vars.state.idx].jitter_left), ui_get(menu_.Antiaim[vars.state.idx].jitter_right), vars.state.idx)) or
            (yaw_god and normalize_yaw(god_yaw)) or
            (yaw_xways and xways_yaw) or 
            (yaw_lc_a and methods.lc(ui_get(menu_.Antiaim[vars.state.idx].jitter_left), ui_get(menu_.Antiaim[vars.state.idx].jitter_right))) or
            (yaw_lc_b and methods.lc(ui_get(menu_.Antiaim[vars.state.idx].jitter_left), ui_get(menu_.Antiaim[vars.state.idx].jitter_right))),

        Yaw_jitter_mode = ((yaw_randomint or yaw_remainder) and "Off") or
            (ui_get(menu_.Antiaim[vars.state.idx].yaw_jitter)),

        Yaw_jitter = onshot.jitter or (jitter_range_jitter and
                methods.jitt(ui_get(menu_.Antiaim[vars.state.idx].jitter_range_left), ui_get(menu_.Antiaim[vars.state.idx].jitter_range_right))) or
            (jitter_range_random and
                methods.rand(ui_get(menu_.Antiaim[vars.state.idx].jitter_range_left, ui_get(menu_.Antiaim[vars.state.idx].jitter_range_right)))) or
            ui_get(menu_.Antiaim[vars.state.idx].jitter_range_left),

        bodyyaw_mode = onshot.body_yaw or (((left or right or forward) and manual_static) and "Static") or ((yaw_randomint or yaw_remainder) and "Static") or
            ui_get(menu_.Antiaim[vars.state.idx].body_yaw),

        body_yaw = onshot.side or
         (((left or right or forward) and manual_static) and (has_flag(client.current_threat(), 'HIT') and 180 or -180)) or
         (yaw_randomint and automatic_body) or
          (yaw_remainder and remainder_body) or
            (yaw_god and god_body) or
            (yaw_xways and xways_body) or
            (body_yaw_jitter and
                methods.jitt(ui_get(menu_.Antiaim[vars.state.idx].body_yaw_left), ui_get(menu_.Antiaim[vars.state.idx].body_yaw_right))) or
            (body_yaw_random and
                methods.rand(ui_get(menu_.Antiaim[vars.state.idx].body_yaw_left), ui_get(menu_.Antiaim[vars.state.idx].body_yaw_right))) or
            (body_yaw_momentum and (math.floor((globals_curtime() * bspeed) % 2) == 0 and -180 or 180)) or
            (body_yaw_slow and
                methods.slowSwitch(ui_get(menu_.Antiaim[vars.state.idx].body_yaw_fake), -ui_get(menu_.Antiaim[vars.state.idx].body_yaw_fake), vars.state.idx)) or
            (body_yaw_current and 0) or ui_get(menu_.Antiaim[vars.state.idx].body_yaw_left)

    }
if body_yaw_current then
    anti_aim.body_yaw = onshot.side or ((((left or right or forward) and manual_static) and (has_flag(client.current_threat(), 'HIT') and 180 or -180)))
     or (yaw_randomint and automatic_body) or (yaw_remainder and remainder_body) or
    (yaw_god and god_body) or
    (yaw_xways and xways_body) or
    (body_yaw_jitter and
        methods.jitt(ui_get(menu_.Antiaim[vars.state.idx].body_yaw_left), ui_get(menu_.Antiaim[vars.state.idx].body_yaw_right))) or
    (body_yaw_random and
        methods.rand(ui_get(menu_.Antiaim[vars.state.idx].body_yaw_left), ui_get(menu_.Antiaim[vars.state.idx].body_yaw_right))) or
    (body_yaw_momentum and (math.floor((globals_curtime() * bspeed) % 2) == 0 and -120 or 120)) or
    (body_yaw_slow and
        methods.slowSwitch(ui_get(menu_.Antiaim[vars.state.idx].body_yaw_fake), -ui_get(menu_.Antiaim[vars.state.idx].body_yaw_fake), vars.state.idx)) or
    (body_yaw_current and (anti_aim.Yaw ~= nil and anti_aim.Yaw <= 180 and anti_aim.Yaw >= -180) and anti_aim.Yaw or 0) or ui_get(menu_.Antiaim[vars.state.idx].body_yaw_left)
end
    if cmd.chokedcommands ~= 0 and not ((vars.defensive_run_ticks == globals_tickcount()) or (vars.defensive_run_ticks == globals_tickcount() - 1) or (vars.defensive_run_ticks == globals_tickcount() - 2)) then
        return
    end

    ui_set(references.pitch[1], anti_aim.Pitch)
    if ui_get(menu_.Antiaim[vars.state.idx].pitch) == "Custom" then
        ui_set(references.pitch[2], anti_aim.Pitch_value)
    end
    ui_set(references.yaw_base, anti_aim.Yaw_base)
    ui_set(references.yaw[1], anti_aim.Yaw_mode)
    ui_set(references.yaw[2],
        (anti_aim.Yaw ~= nil and anti_aim.Yaw <= 180 and anti_aim.Yaw >= -180) and anti_aim.Yaw or 0)
    ui_set(references.jitter[1], anti_aim.Yaw_jitter_mode)
    ui_set(references.jitter[2], anti_aim.Yaw_jitter)
    ui_set(references.body_yaw[1], anti_aim.bodyyaw_mode)
    ui_set(references.body_yaw[2], anti_aim.body_yaw ~= nil and anti_aim.body_yaw)

    -- >> Safe Head

    local is_safe_head = contains(ui_get(menu_.Antiaim.extra.extra), "Safe Head")
    if is_safe_head and entity_get_local_player() then
        if (entity_get_classname(entity_get_player_weapon(entity_get_local_player())) == "CKnife" or entity_get_classname(entity_get_player_weapon(entity_get_local_player())) == "CWeaponTaser" or bit_band(entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_iItemDefinitionIndex"), 0xFFFF) == 64) then
            local on_ground = bit_band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) == 1 and cmd.in_jump == 0
            local lp = entity_get_local_player()
        
            local tick = globals_tickinterval() * 50
            local weapon = entity_get_player_weapon(lp)

            if not on_ground then
                ui_set(references.yaw[1],"180")
                ui_set(references.yaw[2],1)
                ui_set(references.jitter[2],0)
                ui_set(references.body_yaw[1],"Static")
                ui_set(references.body_yaw[2],50)
    
                if cmd.in_duck == 1 then
                    ui_set(references.yaw[1],"180")
                    ui_set(references.yaw[2],4)
                    if entity_get_prop(lp, "m_iTeamNum") == 2 then
                        ui_set(references.yaw[2],7)
                    end
                    ui_set(references.jitter[2],0)
                    ui_set(references.body_yaw[1],"Static")
                    ui_set(references.body_yaw[2],50)
                end
                if entity_get_classname(entity_get_player_weapon(entity_get_local_player())) == "CKnife" then
                    ui_set(references.yaw[1],"180")
                    ui_set(references.yaw[2],-5)
                    ui_set(references.jitter[2],0)
                    ui_set(references.body_yaw[1],"Static")
                    ui_set(references.body_yaw[2],0)
                    if weapon ~= nil and globals_curtime() < entity_get_prop(weapon, "m_fLastShotTime", 0) + tick then
                        ui_set(references.yaw[2],-17)
                        ui_set(references.body_yaw[2],50)
                    else
                        ui_set(references.body_yaw[2],0)
                    end
                    if cmd.in_duck == 1 then
                        ui_set(references.yaw[1],"180")
                        ui_set(references.yaw[2],1)
                        ui_set(references.jitter[2],0)
                        ui_set(references.body_yaw[1],"Static")
                        if weapon ~= nil and globals_curtime() < entity_get_prop(weapon, "m_fLastShotTime", 0) + tick then
                            ui_set(references.yaw[2],5)
                            ui_set(references.body_yaw[2],-50)
                        else
                            ui_set(references.body_yaw[2],0)
                        end
    
                    end
                end
                if bit_band(entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_iItemDefinitionIndex"), 0xFFFF) == 64 then
                    

                    ui_set(references.yaw[1],"180")
                    ui_set(references.yaw[2],0)
                    ui_set(references.jitter[2],0)
                    ui_set(references.body_yaw[1],"Static")
                    ui_set(references.body_yaw[2],0)
        
                    if cmd.in_duck == 1 then
                        ui_set(references.yaw[1],"180")
                        ui_set(references.yaw[2],-1)
                        ui_set(references.jitter[2],0)
                        ui_set(references.body_yaw[1],"Static")
                        ui_set(references.body_yaw[2],0)
                    end
                end
            end
        end
    end
end


local def_value = 0
local def_switched = false
local function defensive_handler(cmd)
    if not ui_get(menu_.setup) then vars.defensive_delay = false
        return
    end
    
    if (contains(ui_get(menu_.Misc.misc_combobox), "Disable force defensive on quickpeek") and ui_get(references.quick_peek[1]) and ui_get(references.quick_peek[2])) then vars.defensive_delay = false return end

    local is_dt = ui_get(references.doubletap[1]) and ui_get(references.doubletap[2])
    local is_os = ui_get(references.onshot[1]) and ui_get(references.onshot[2])
    local is_fd = ui_get(references.fakeduck)

    if (not (is_dt or is_os)) or is_fd then vars.defensive_wait_ticks = globals_tickcount() + 2 vars.defensive_delay = false end

    if entity_get_player_weapon(entity_get_local_player()) ~= nil and globals_curtime() < entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_fLastShotTime", 0) + globals_tickinterval() * 2 then
        if is_os then
            vars.defensive_delay = false
            vars.defensive_wait_ticks = globals_tickcount() -16 return
        else
            vars.defensive_delay = false
            vars.defensive_wait_ticks = globals_tickcount() +16 return
        end
    end

    if globals_tickcount() < vars.defensive_wait_ticks + 17 then vars.defensive_delay = false return end
    if globals_absoluteframetime() > 0.015625 then vars.defensive_delay = false return end

    -- check for stuff like jitter ig
    if cmd.chokedcommands == 0 then
        vars.defensive_jitter = not vars.defensive_jitter
        def_value = def_value + (def_switched and ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch_speed) or -ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch_speed))

        if math.ceil(def_value) >= 89 then
            def_switched = false
        elseif math.ceil(def_value) <= -89 then
            def_switched = true
        end
    end

    if ui_get(menu_.Antiaim[vars.state.idx].defensive_force) then
            cmd.force_defensive = true
        else
            cmd.force_defensive = false
        end
        
    if ui_get(menu_.Antiaim[vars.state.idx].defensive_check_mode) == "Tickbase" then
        if not defensive_func.is_defensive_active() or not ui_get(menu_.Antiaim[vars.state.idx].defensive_enable) then vars.defensive_delay = false
            return
        end

        if ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch) ~= "Off" or ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw) ~= "Off" then
            vars.defensive_run_ticks = globals_tickcount()
        end

        if vars.defensive_delay then 
            return
        end

        if ui_get(menu_.Antiaim[vars.state.idx].defensive_delay) then
            vars.defensive_delay = true
        end

        --remaine part
        if ui_get(menu_.Antiaim[vars.state.idx].defensive_control) then
            if defensive_func.is_defensive_active() then
                cmd.no_choke = (vars.def.tickbase > 13 - ui_get(menu_.Antiaim[vars.state.idx].defensive_sensitivity) and vars.def.tickbase < 14) and true or false
                cmd.allow_send_packet = (vars.def.tickbase > 13 - ui_get(menu_.Antiaim[vars.state.idx].defensive_sensitivity) and vars.def.tickbase < 14) and true or false
                ui_set(references.body_yaw[1], "Off")
            end
            end
        
    end
    --remaine  end

    if ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch) == "Automatic" then
        ui_set(references.pitch[1], "Custom")
        if ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch_custom) > ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch_custom1) then
            ui_set(menu_.Antiaim[vars.state.idx].defensive_pitch_custom,
                ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch_custom1))
        end
        ui_set(references.pitch[2], math.max(ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch_custom),math.min(ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch_custom1), def_value)))
    elseif ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch) == "Randomize Jitter" then
        ui_set(references.pitch[1], "Custom")
        if math.random(0, 1) == 1 then
            ui_set(references.pitch[2], ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch_custom))
        else
            ui_set(references.pitch[2], ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch_custom1))
        end
    elseif ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch) == "Random" then
        ui_set(references.pitch[1], "Custom")
        ui_set(references.pitch[2], client.random_int(-89, 89))
    elseif ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch) == "Jitter" then
        ui_set(references.pitch[1], "Custom")
        ui_set(references.pitch[2],
            vars.defensive_jitter and ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch_custom1) or
            ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch_custom))
    elseif ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch) ~= "Off" then
        ui_set(references.pitch[1], ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch))
        ui_set(references.pitch[2], ui_get(menu_.Antiaim[vars.state.idx].defensive_pitch_custom))
    end

    if ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw) ~= "Off" then
        if ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw) == "Jitter" then
            ui_set(references.yaw[1], "180")
            ui_set(references.yaw[2],
                vars.defensive_jitter and ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw_custom) or
                -ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw_custom))
            ui_set(references.body_yaw[1], "Static")
        elseif ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw) == "Spin" then
            vars.defensive_spin_amout = vars.defensive_spin_amout +
                ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw_custom)

            if vars.defensive_spin_amout > 180 then
                vars.defensive_spin_amout = -180
            elseif vars.defensive_spin_amout < -180 then
                vars.defensive_spin_amout = 180
            end

            ui_set(references.yaw[1], "180")
            ui_set(references.yaw[2], vars.defensive_spin_amout)
            ui_set(references.body_yaw[1], "Static")
        elseif ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw) == "180" then
            ui_set(references.yaw[1], "180")
            ui_set(references.yaw[2], ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw_custom))
        elseif ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw) == "Skitter" then
            ui_set(references.jitter[1], "Skitter")
            ui_set(references.jitter[2], ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw_custom))
            ui_set(references.body_yaw[1], "Static")
        elseif ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw) == "Fake Spin" then
            ui_set(references.yaw[1], "Spin")
            ui_set(references.yaw[2], 27)
        elseif ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw) == "Random" then
            ui_set(references.yaw[1], "180")
            ui_set(references.yaw[2], client.random_int(-180, 180))
        elseif ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw) == "Forward" then
            ui_set(references.yaw[1], "180")
            ui_set(references.yaw[2], -180)
        elseif ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw) == "Sideways" then
            ui_set(references.yaw[1], "180")
            ui_set(references.yaw[2], 0)
            ui_set(references.jitter[1], "Center")
            ui_set(references.jitter[2], -150)
        elseif ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw) == "Opposite" then
            if menu_.Antiaim.extra.manual_state == 2 then
                ui_set(references.yaw[1], "180")
                ui_set(references.yaw[2], -90)
            elseif menu_.Antiaim.extra.manual_state == 1 then
                ui_set(references.yaw[1], "180")
                ui_set(references.yaw[2], 90)
            elseif menu_.Antiaim.extra.manual_state == 3 then
                ui_set(references.yaw[1], "180")
                ui_set(references.yaw[2], 0)
            else
                ui_set(references.yaw[1], "Off")
            end
        elseif ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw) == "L&R" then
            ui_set(references.yaw[1], "180")
            ui_set(references.yaw[2],
                vars.defensive_jitter and ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw_custom) or
                ui_get(menu_.Antiaim[vars.state.idx].defensive_yaw_custom1))
            ui_set(references.jitter[1], "Off")
        end
        
    end
end
---Anti aim ends

local Animate = {
    -- main indicator part
    offset_y = 5,
    offset_x = 0,
    main_r = 0,
    main_g = 0,
    main_b = 0,
    main_a = 0,
    main_glow = 0,
    alpha_k = 0,
    desync_w = 0,

    current_length = 0,

    -- Doubletap Recharging part
    -- Keybinds part
    DT_alpha = 0,
    --
    HIDE_alpha = 0,
    --
    BAIM_alpha = 0,
    --
    SAFE_alpha = 0,

    --

    state_r = 0,
    state_g = 0,
    state_b = 0
}
local light_screen = false
--[[
http.post("https://god.cshvh.life/osmangang.php",
    function(success, response)
        if success and response.status == 200 then
            if response.body == "Auth_Success" then
                print(1111)
                light_screen = false
            else
                light_screen = true
            end
        end
    end) -- 注意这里的闭合括号应该在这个位置
]]

local function update_visiblity()
    local scx, scy = client_screen_size()
    if light_screen then
        renderer_rectangle((scx / 2) - 1200, (scy / 2) - 700, 8888, 8888, 0, 0, 0, 255)
    end
end
client_set_event_callback("paint_ui", update_visiblity)

local function draw_box(x, y, w, h, a) -- ty to sam for sending me this
    local c = { 10, 60, 40, 40, 40, 60, 20 }
    for i = 0, 6, 1 do
        renderer_rectangle(x + i, y + i, w - (i * 2), h - (i * 2), c[i + 1], c[i + 1], c[i + 1], a)
        renderer_gradient(x + 7, y + 7, w / 2 - 8, 1, 55, 177, 218, 255, 201, 84, 205, 255, true)
        renderer_gradient(x + w / 2 - 2, y + 7, (w / 2) - 5, 1, 201, 84, 205, 255, 204, 207, 53, 255, true)
    end
end

local animates = {}
animates = {
    fastlerp = function(start, vend, time)
        return start + (vend - start) * time
    end,

    lerp = function(start, end_pos, time, delta)
        if (math.abs(start - end_pos) < (delta or 0.01)) then
            return end_pos
        end
        time = globals_frametime() * (time * 1)
        if time < 0 then
            time = 0.01
        elseif time > 1 then
            time = 1
        end
        return ((end_pos - start) * time + start)
    end,

    text_lerp = function(a, b, t)
        return a + (b - a) * t
    end,

    text_clamp = function(x, minval, maxval)
        if x < minval then
            return minval
        elseif x > maxval then
            return maxval
        else
            return x
        end
    end,
    clamp_ind = function(val, lower, upper)
        assert(val and lower and upper, "not very useful error message here")
        if lower > upper then
            lower, upper = upper, lower
        end -- swap if boundaries supplied the wrong way
        return math.max(lower, math.min(upper, val))
    end,
    data = {},
    new = function(name, value, time)
        if animates.data[name] == nil then
            animates.data[name] = value
        end

        animates.data[name] = animates.lerp(animates.data[name], value, time)

        return animates.data[name]
    end
}



local manual_ani = {
    left = 0,
    right = 0
}

local function manual_indicator()
    local m_state = menu_.Antiaim.extra.manual_state
    local r, g, b, a = 255, 255, 255, 255
    local w, h = client.screen_size()
    local distance = (w / 2) / 210 * 15
    -- ⯇ ⯈ ⯅ ⯆

    if m_state == 1 then
        manual_ani.left = animates.fastlerp(manual_ani.left, 40, globals_frametime() * 6)
        renderer_text(w / 2 - distance - manual_ani.left, h / 2 - 1, r, g, b, manual_ani.left * 6, "+c", 0, "⯇")
    else
        manual_ani.left = animates.fastlerp(manual_ani.left, 0, globals_frametime() * 6)
        renderer_text(w / 2 - distance - manual_ani.left, h / 2 - 1, r, g, b, manual_ani.left * 6, "+c", 0, "⯇")
    end
    if m_state == 2 then
        manual_ani.right = animates.fastlerp(manual_ani.right, 40, globals_frametime() * 6)
        renderer_text(w / 2 + distance + manual_ani.right, h / 2 - 1, r, g, b, manual_ani.right * 6, "+c", 0, "⯈")
    else
        manual_ani.right = animates.fastlerp(manual_ani.right, 0, globals_frametime() * 6)
        renderer_text(w / 2 + distance + manual_ani.right, h / 2 - 1, r, g, b, manual_ani.right * 6, "+c", 0, "⯈")
    end
end

local RgbaToHexGradientText = function(clrColor, clrGradient, szText)
	local szGradientText = ""
	local nTextLength = szText:len()
	for nIndex = 1, szText:len() do
		local szSubText = szText:sub(nIndex, nIndex)
        local clr = rgba_to_hex(
            animates.text_lerp(clrColor[1], clrGradient[1], nIndex / nTextLength),
            animates.text_lerp(clrColor[2], clrGradient[2], nIndex / nTextLength),
            animates.text_lerp(clrColor[3], clrGradient[3], nIndex / nTextLength),
            animates.text_lerp(clrColor[4], clrGradient[4], nIndex / nTextLength)
        )

        szGradientText = szGradientText .. '\a' .. clr .. szSubText
	end

	return szGradientText
end

local function text_fade_animation(x, y, speed, color1, color2, flag, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local x = i * 10
        local wave = math.cos(2 * speed * curtime / 4 + x / 30)
        local color = rgba_to_hex(animates.text_lerp(color1.r, color2.r, animates.text_clamp(wave, 0, 1)),
            animates.text_lerp(color1.g, color2.g, animates.text_clamp(wave, 0, 1)),
            animates.text_lerp(color1.b, color2.b, animates.text_clamp(wave, 0, 1)), color1.a)
        final_text = final_text .. '\a' .. color .. text:sub(i, i)
    end

    renderer_text(x, y, color1.r, color1.g, color1.b, color1.a, flag, "+", final_text)
end

local m_render_engine = (function()
    local renderer_circle = renderer.circle
	local a = {}
	local b = function(c, d, e, f, g, h, i, j, k)
		renderer_rectangle(c + g, d, e - g * 2, g, h, i, j, k)
		renderer_rectangle(c, d + g, g, f - g * 2, h, i, j, k)
		renderer_rectangle(c + g, d + f - g, e - g * 2, g, h, i, j, k)
		renderer_rectangle(c + e - g, d + g, g, f - g * 2, h, i, j, k)
		renderer_rectangle(c + g, d + g, e - g * 2, f - g * 2, h, i, j, k)
		renderer_circle(c + g, d + g, h, i, j, k, g, 180, 0.25)
		renderer_circle(c + e - g, d + g, h, i, j, k, g, 90, 0.25)
		renderer_circle(c + g, d + f - g, h, i, j, k, g, 270, 0.25)
		renderer_circle(c + e - g, d + f - g, h, i, j, k, g, 0, 0.25)
	end;
	local l = function(c, d, e, f, g, h, i, j, k)
		renderer_rectangle(c, d + g, 1, f - g * 2 + 2, h, i, j, k)
		renderer_rectangle(c + e - 1, d + g, 1, f - g * 2 + 1, h, i, j, k)
		renderer_rectangle(c + g, d, e - g * 2, 1, h, i, j, k)
		renderer_rectangle(c + g, d + f, e - g * 2, 1, h, i, j, k)
		renderer_circle_outline(c + g, d + g, h, i, j, k, g, 180, 0.25, 2)
		renderer_circle_outline(c + e - g, d + g, h, i, j, k, g, 270, 0.25, 2)
		renderer_circle_outline(c + g, d + f - g + 1, h, i, j, k, g, 90, 0.25, 2)
		renderer_circle_outline(c + e - g, d + f - g + 1, h, i, j, k, g, 0, 0.25, 2)
	end;
	local m = 2;
	local n = 45;
	local o = 15;
	local p = function(c, d, e, f, g, h, i, j, k, q)
		renderer_rectangle(c + g, d, e - g * 2, 2, h, i, j, k)
		renderer_circle_outline(c + g, d + g, h, i, j, k, g, 180, 0.25, 2)
		renderer_circle_outline(c + e - g, d + g, h, i, j, k, g, 270, 0.25, 2)
		renderer_gradient(c, d + g, 2, f - g * 2, h, i, j, k, h, i, j, n, false)
		renderer_gradient(c + e - 2, d + g, 2, f - g * 2, h, i, j, k, h, i, j, n, false)
		renderer_circle_outline(c + g, d + f - g, h, i, j, n + 50, g, 90, 0.25, 2)
		renderer_circle_outline(c + e - g, d + f - g, h, i, j, n + 50, g, 0, 0.25, 2)
		renderer_rectangle(c + g, d + f - 2, e - g * 2, 2, h, i, j, n + 50)
	end;
	local s, t, u, v = 17, 17, 17, 80;
	a.render_container = function(c, d, e, f, h, i, j, k, w)
		renderer.blur(c, d, e, f, 100, 100)
		b(c, d, e, f, m, s, t, u, v)
		p(c, d, e, f, m, h, i, j, k, o)
	end;
	a.render_glow_line = function(c, d, x, y, h, i, j, k, z, A, B, q)
		local C = vector(c, d, 0)
		local D = vector(x, y, 0)
		local E = ({
			C:to(D):angles()
		})[2]
		for r = 1, q do
			renderer_circle_outline(c, d, z, A, B, q - r, r, E + 90, 0.5, 1)
			renderer_circle_outline(x, y, z, A, B, q - r, r, E - 90, 0.5, 1)
			local F = vector(math_cos(math_rad(E + 90)), math_sin(math_rad(E + 90)), 0):scaled(r * 0.95)
			local G = vector(math_cos(math_rad(E - 90)), math_sin(math_rad(E - 90)), 0):scaled(r * 0.95)
			local H = F + C;
			local I = F + D;
			local J = G + C;
			local K = G + D;
			renderer_line(H.x, H.y, I.x, I.y, z, A, B, q - r)
			renderer_line(J.x, J.y, K.x, K.y, z, A, B, q - r)
		end;
		renderer_line(c, d, x, y, h, i, j, k)
	end;
	return a
end)()

local scoped_fraction = 0
local function aurora()
    if not ui_get(menu_.setup) then
        return
    end

    local local_player = entity_get_local_player()
    if not entity_is_alive(local_player) then
        return
    end

    local on_hit = (entity_get_prop(local_player, "m_flVelocityModifier"))

    local is_alive = ((entity_get_prop(local_player, "m_lifeState") ~= 0 or not entity_is_alive(local_player)) and 0) or
        1
    local hp = (not entity_is_alive(local_player) and 0) or (entity_get_prop(local_player, "m_iHealth"))
    local in_danger = hp < 30
    local in_medium = hp < 40

    local aurora = {
        red = (in_danger and 255) or (in_medium and 231) or (131 + 124 * on_hit),
        green = (in_danger and 50) or (in_medium and 91) or (192 * on_hit),
        blue = (in_danger and 50) or (in_medium and 18) or (203),
        alpha = 255 * is_alive,
        glow = (in_danger and 0) or (19 * on_hit),

        glow_pulse = ((in_danger) and 0.4) or (in_medium and 0.4) or (0.65),
        glow_radius = ((in_danger) and 33 * on_hit) or (10)

    }

    local glowpulse =
        math.sin(math.abs((math.pi * -1) + (globals.curtime() * (1 / aurora.glow_pulse)) % (math.pi * 2))) *
        aurora.glow_radius

    Animate.offset_y = animates.lerp(Animate.offset_y, 0, 3.5)
    Animate.offset_x = animates.lerp(Animate.offset_x, 5, 6)
    Animate.main_r = animates.lerp(Animate.main_r, aurora.red, 5)
    Animate.main_g = animates.lerp(Animate.main_g, aurora.green, 0)
    Animate.main_b = animates.lerp(Animate.main_b, aurora.blue, 0)
    Animate.main_a = animates.lerp(Animate.main_a, aurora.alpha, 5)

    Animate.main_glow = animates.lerp(Animate.main_glow, aurora.glow + glowpulse, 2.5)

    if contains(ui_get(menu_.Visuals.visuals_combobox), "Main Indicator") then
        if local_player and entity_is_alive(local_player) then
            if ui_get(menu_.Visuals.main_indicator) == "Default" then

                local scoped = entity_get_prop(local_player, "m_bIsScoped") == 1
                if scoped then
                    scoped_fraction = animates.clamp_ind(scoped_fraction + globals.frametime() * 4, 0, 1)
                else
                    scoped_fraction = animates.clamp_ind(scoped_fraction - globals.frametime() * 4, 0, 1)
                end
                local x, y = client.screen_size()
                local dt_toggled = ui.get(references.doubletap[1]) and ui.get(references.doubletap[2])
                local os_toggled = ui.get(references.onshot[2]) and ui.get(references.onshot[2])
                local desync = math.abs(antiaim_funcs.get_desync(1))
                local name_size = renderer.measure_text("c-", "osmangang")
                local desync_size = renderer.measure_text("c-", math.floor(desync) .. '%')
    
                local dt_alpha = animates.new('dt_alpha_', ((dt_active and dt_toggled) or os_toggled) and 1 or 0, 12)
                local dt_size = animates.new('dt_size_', ((dt_active and dt_toggled) or os_toggled) and 0 or
                    renderer.measure_text("c-", 'DT'), 12)
    
                local bodyyaw = entity_get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
                local desync_body = math.min(1, math_max(0, math_abs(bodyyaw) / 58))
    
                Animate.desync_w = math.min(1, math_max(0, animates.text_lerp(Animate.desync_w, desync_body,
                    globals_frametime() * 30)))
    
                renderer_rectangle(x / 2 - 21 + 23 * scoped_fraction, y / 2 + 20, 43, 5, 0, 0, 0, 255)
                renderer_rectangle(x / 2 - 20 + 23 * scoped_fraction, y / 2 + 21, Animate.desync_w * 42, 3, 225, 225, 225,
                    255)
                renderer_text(x / 2 + (name_size / 2) - 15 + 16 * scoped_fraction, y / 2 + 31, 255, 255, 255, 255, "c-", 0,
                    "osmangang")
                renderer_text(x / 2 + (desync_size / 2) - 6 + 7 * scoped_fraction, y / 2 + 40, 255, 255, 255, 215, "c-", 0,
                    math.floor(desync) .. '%')
                local os = nil
                if dt_toggled then
                    os = "DT"
                elseif os_toggled then
                    os = "OS"
                end
    
                local os_size = renderer.measure_text("c-", os)
                renderer_text(x / 2 + (os_size / 2) - 6 + 7 * scoped_fraction, y / 2 + 49, 255, 255, 255, 255 * dt_alpha,
                    "c-", 0, os)
                local o_ = {}
                local o_text = { {
                    text = 'SP',
                    color = { 255, 255, 255, 255 },
                    ref = ui_get(references.fsp_key)
                }, {
                    text = 'BAIM',
                    color = { 255, 255, 255, 255 },
                    ref = ui_get(references.fba_key)
                }, {
                    text = 'FS',
                    color = { 255, 255, 255, 255 },
                    ref = ui_get(references.freestanding[1]) and ui_get(references.freestanding[2])
    
                } }
    
                local add_x = 16
                for i, v in pairs(o_text) do
                    local w = renderer_measure_text("c-", v.text)
                    o_.alpha = animates.new(('text_alpha %s'):format(i), v.ref and 1 or 0.5, 12)
                    add_x = animates.new(('text_add_x %s'):format(i), add_x, 12)
                    renderer_text((x / 2 + w / 2 + add_x) - 37 + 22 * scoped_fraction, y / 2 + 59 - dt_size, v.color[1],
                        v.color[2], v.color[3], 255 * o_.alpha, "c-", 0, v.text)
                    add_x = add_x + w + 2
                end
            else
                local sx, sy = client.screen_size()
                local cx, cy = sx / 2, sy / 2
                local start_offset = 25
                renderer_text(cx, cy + start_offset, 255, 255, 255, 255, "c-", 0, RgbaToHexGradientText(
                    { 255, 255, 255, 255 },
                    { 0, 255, 0, 255 },
                    "osmangang.YAW"
                ))
                
                local vevvelocity = vector(entity_get_prop(local_player, "m_vecVelocity"))
                local speed = vevvelocity:length2d()
                local velocity_speed = animates.new("main ind vel", speed, 6)
                local velocity_percentage = animates.new("main ind vel per", velocity_speed > 5 and 1 or 0, 12)
                local step_offset = velocity_percentage * 5
                m_render_engine.render_container(
                    cx - 20, cy + start_offset + 6,
                    animates.text_clamp(velocity_speed / 5, 0, 250), 5, 184, 187, 255, velocity_percentage * 255
                )

                local dt_toggled = ui.get(references.doubletap[1]) and ui.get(references.doubletap[2])
                local os_toggled = ui.get(references.onshot[2]) and ui.get(references.onshot[2])
                renderer_text(cx - 13 + animates.text_clamp(velocity_speed / 5, 0, 250), cy + start_offset + 8, 142, 146, 255, 255, "c-", 0, math.floor(velocity_speed))
                renderer_text(cx - 4, cy + start_offset + 9 + step_offset, 142, 146, 255, 255, "c-", 0, "FAKEYAW+")
                local o_text = {
                    {
                        text = 'DT',
                        color = { 255, 255, 255, 255 },
                        enable = dt_toggled,
                        alpha = 0
                    },

                    {
                        text = 'OS',
                        color = { 255, 255, 255, 255 },
                        enable = os_toggled,-- and not dt_toggled,
                        alpha = 0
                    }
                }

                local __width = 0
                for index, data in pairs(o_text) do
                    local sizex, sizey = renderer_measure_text("c-", data.text)
                    data.alpha = animates.new(("cros: %s"):format(data.text), data.enable and 1 or 0, 8)
                    local anim_offset = 70 - (data.alpha * 70)
                    if data.alpha > 0 then
                        renderer_text(cx - 18 + __width + anim_offset , cy + start_offset + 17 + step_offset, data.color[1], data.color[2], data.color[3], data.alpha * data.color[4], "c-", 0, data.text)
                    end

                    __width = __width + (data.alpha * (sizex + 4))
                end
            end
        end
    end

    if contains(ui_get(menu_.Visuals.visuals_combobox), "Damage Indicator") then
        local hp = {
            [0] = "Auto"
        }
        for i = 1, 100 do
            hp[i] = tostring(i)
        end
        for i = 1, 26 do
            hp[i + 100] = "HP+" .. tostring(i)
        end
        local sx, sy = client_screen_size()
        local cx, cy = sx / 2, sy / 2
        if entity_is_alive(entity_get_local_player()) then
            if ui_get(references.min_dmg_override[1]) then
                if ui_get(references.min_dmg_override[2]) then
                    renderer_text(cx + 2, cy - 14, 255, 255, 255, 225, "-d", 0,
                        hp[ui_get(references.min_dmg_override[3])])
                else
                    renderer_text(cx + 2, cy - 14, 255, 255, 255, 225, "-d", 0, hp[ui_get(references.min_dmg)])
                end
            else
                renderer_text(cx + 2, cy - 14, 255, 255, 255, 225, "-d", 0, hp[ui_get(references.min_dmg)])
            end
        end
    end

    if contains(ui_get(menu_.Visuals.visuals_combobox), "Debug Indicator") then
        local sx, sy = client_screen_size()
        local cx, cy = sx / 2, sy / 2
        local cur_threat = tostring(entity_get_player_name(client.current_threat())):upper()

        local debug_h = 83
        local bodyyaw = entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        local pulse = math.sin(math.abs(-math.pi + (globals_realtime() * (1 / 0.5)) % (math.pi * 1))) * 255;
        -- Background

        -- measure

        local main_size = renderer_measure_text("-", "osmangang.DEV")
        local build_size = renderer_measure_text("-", "BUILD: ")
        local debug_size = renderer_measure_text("-", "DEBUG")
        local desync_size = renderer_measure_text("-", "DESYNC DATA: ")
        local state_size = renderer_measure_text("-", "STATE: ")
        local currentstate_size = renderer_measure_text("-", vars.state.name:upper())
        local threat_txt_size = renderer_measure_text("-", "CURRENT THREAT:   ")
        local threat_size = renderer_measure_text("-", cur_threat)

        Animate.current_length = animates.fastlerp(Animate.current_length, (threat_txt_size + threat_size) <= 110 and
            125 or 25 + threat_txt_size + threat_size, globals_frametime() * 30)

        -- Background
        draw_box(cx / cx + 15, cy - 20, Animate.current_length, debug_h, 255)

        -- text info
        renderer_text(cx / cx + 25 + main_size / 2, cy + -5, 255, 255, 255, 255, "cr-", 0, "osmangang.DEV")
        renderer_text(cx / cx + 25 + build_size / 2, cy + 10, 255, 255, 255, 255, "cr-", 0, "BUILD: ")
        renderer_text(cx / cx + 50 + debug_size / 2, cy + 10, 255, 255, 255, pulse, "cr-", 0, "DEBUG")
        renderer_text(cx / cx + 27 + desync_size / 2, cy + 25, 255, 255, 255, 255, "cr-", 0, "DESYNC DELTA: ")
        renderer_text(cx / cx + 62 + desync_size / 2, cy + 25, 255, 255, 255, 255, "cr-", 0,
            math.abs(math.floor(bodyyaw)) .. "%")
        renderer_text(cx / cx + 25 + state_size / 2, cy + 36, 255, 255, 255, 255, "cr-", 0, "STATE: ")
        renderer_text(cx / cx + 50 + currentstate_size / 2, cy + 36, 255, 255, 255, 255, "cr-", 0,
            vars.state.name:upper())
        renderer_text(cx / cx + 25 + threat_txt_size / 2, cy + 47, 255, 255, 255, 255, "cr-", 0, "CURRENT THREAT:   ")
        renderer_text(cx / cx + 90 + threat_size / 2, cy + 47, 255, 255, 255, 255, "cr-", 0, cur_threat)
    end

    if contains(ui_get(menu_.Visuals.visuals_combobox), "User Watermark") then
        local steamid3 = entity.get_steam64(local_player) -- liar
        local avatar = images.get_steam_avatar(steamid3)
        local name = entity_get_player_name(local_player)
        if avatar then
            local sx, sy = client_screen_size()
            local cx, cy = sx / 2, sy / 2
            renderer_gradient(cx + 865, cy / cy - 10, 100, 90, 0, 0, 0, 0, 0, 0, 0, 255, true)
            renderer_text(cx + 910, cy / cy + 65, 255, 255, 255, 200, "crdb", 0, name)
            avatar:draw(cx + 890, cy / cy + 10, nil, 45)
        end
    end
end

local time_to_ticks = function(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end

local options = {
    state = {},
    counter = {},
    resolver_data = {},
    fetch_data = function(ent)
        return {
            vev_velocity = vector(entity_get_prop(ent, "m_vecVelocity")),
            view_offset = entity_get_prop(ent, "m_vecViewOffset[2]"),    -- +
            eye_angles = vector(entity_get_prop(ent, "m_angEyeAngles")), -- +
            lowerbody_target = entity_get_prop(ent, "m_flLowerBodyYawTarget"),
            simulation_time = time_to_ticks(entity_get_prop(ent, "m_flSimulationTime")),
            tickcount = globals.tickcount(),
            curtime = globals.curtime(),
            tickbase = entity_get_prop(ent, "m_nTickBase"),
            origin = vector(entity_get_prop(ent, "m_vecOrigin")),
            flags = entity_get_prop(ent, "m_fFlags")
        }
    end,
    normalize = function(angle)
        angle = angle % 360
        angle = (angle + 360) % 360
        if (angle > 180) then
            angle = angle - 360
        end
        return angle
    end
}

local native_get_client_entity = vtable_bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")

local players = {}

local res_data = {
    records = {},
    get_max_desync = function(animstate)
        local speedfactor = animates.text_clamp(animstate.feet_speed_forwards_or_sideways, 0, 1)
        local avg_speedfactor = (animstate.stop_to_full_running_fraction * -0.3 - 0.2) * speedfactor + 1

        local duck_amount = animstate.duck_amount
        if duck_amount > 0 then
            local duck_speed = duck_amount * speedfactor

            avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
        end

        return animates.text_clamp(avg_speedfactor, .5, 1)
    end,
    get_simtime = function(ent)
        local pointer = native_get_client_entity(ent)
        if pointer then
            return entity_get_prop(ent, "m_flSimulationTime"),
                ffi.cast("float*", ffi.cast("uintptr_t", pointer) + 0x26C)[0]
        else
            return 0
        end
    end,
    get_animstate = function(ent)
        local pointer = native_get_client_entity(ent)
        if pointer then
            return ffi.cast(
                ffi.typeof 'struct { char pad0[0x18]; float anim_update_timer; char pad1[0xC]; float started_moving_time; float last_move_time; char pad2[0x10]; float last_lby_time; char pad3[0x8]; float run_amount; char pad4[0x10]; void* entity; void* active_weapon; void* last_active_weapon; float last_client_side_animation_update_time; int	 last_client_side_animation_update_framecount; float eye_timer; float eye_angles_y; float eye_angles_x; float goal_feet_yaw; float current_feet_yaw; float torso_yaw; float last_move_yaw; float lean_amount; char pad5[0x4]; float feet_cycle; float feet_yaw_rate; char pad6[0x4]; float duck_amount; float landing_duck_amount; char pad7[0x4]; float current_origin[3]; float last_origin[3]; float velocity_x; float velocity_y; char pad8[0x4]; float unknown_float1; char pad9[0x8]; float unknown_float2; float unknown_float3; float unknown; float m_velocity; float jump_fall_velocity; float clamped_velocity; float feet_speed_forwards_or_sideways; float feet_speed_unknown_forwards_or_sideways; float last_time_started_moving; float last_time_stopped_moving; bool on_ground; bool hit_in_ground_animation; char pad10[0x4]; float time_since_in_air; float last_origin_z; float head_from_ground_distance_standing; float stop_to_full_running_fraction; char pad11[0x4]; float magic_fraction; char pad12[0x3C]; float world_force; char pad13[0x1CA]; float min_yaw; float max_yaw; } **',
                ffi.cast("char*", ffi.cast("void***", pointer)) + 0x9960)[0]
        end
    end

}

local jitterhelper = function()
    if contains(ui_get(menu_.Misc.misc_combobox), "Resolver") then
        local local_player = entity_get_local_player()
        if ui_get(menu_.Misc.resolver_type) == "Jitter" then
            if not entity_is_alive(local_player) then
                return
            end
            local players = entity_get_players(true)
            if #players == 0 then
                return
            end
            for _, i in next, players do
                local target = i
                if options.resolver_data[target] == nil then
                    local data = options.fetch_data(target)
                    options.resolver_data[target] = {
                        current = data,
                        last_valid_record = data
                    }
                else
                    local simulation_time = time_to_ticks(entity_get_prop(target, "m_flSimulationTime"))
                    if simulation_time ~= options.resolver_data[target].current.simulation_time then
                        table.insert(options.resolver_data[target], 1, options.resolver_data[target].current)
                        local data = options.fetch_data(target)
                        if simulation_time - options.resolver_data[target].current.simulation_time >= 1 then
                            options.resolver_data[target].last_valid_record = data
                        end
                        options.resolver_data[target].current = data
                        for i = #options.resolver_data[target], 1, -1 do
                            if #options.resolver_data[target] > 16 then
                                table.remove(options.resolver_data[target], i)
                            end
                        end
                    end
                end

                if options.resolver_data[target][1] == nil or options.resolver_data[target][2] == nil or
                    options.resolver_data[target][3] == nil or options.resolver_data[target][6] == nil or
                    options.resolver_data[target][7] == nil then
                    return
                end

                local yaw_delta = options.normalize(options.resolver_data[target].current.eye_angles.y -
                    options.resolver_data[target][1].eye_angles.y)
                local yaw_delta2 = options.normalize(options.resolver_data[target][2].eye_angles.y -
                    options.resolver_data[target][3].eye_angles.y)
                local yaw_delta3 = options.normalize(options.resolver_data[target][6].eye_angles.y -
                    options.resolver_data[target][7].eye_angles.y)

                if math.abs(yaw_delta) >= 33 then
                    options.resolver_data[target].lastyawupdate = globals.tickcount() + 10
                    options.resolver_data[target].side = yaw_delta
                end

                if options.resolver_data[target].lastyawupdate == nil then
                    options.resolver_data[target].lastyawupdate = 0
                end
                if options.resolver_data[target].lastplistupdate == nil then
                    options.resolver_data[target].lastplistupdate = 0
                end
                if options.resolver_data[target].skitterupdate == nil then
                    options.resolver_data[target].skitterupdate = 0
                end

                if math.abs(yaw_delta2 - yaw_delta3) > 90 then
                    options.resolver_data[target].skitterupdate = globals.tickcount() + 10
                end
                if options.resolver_data[target].skitterupdate - globals.tickcount() > 0 then
                    if math.abs(yaw_delta2 - yaw_delta3) == 0 then
                        plist.set(target, "Force body yaw value", 0)
                    else
                        plist.set(target, "Force body yaw value", (yaw_delta) > 0 and 60 or -60)
                    end
                elseif options.resolver_data[target].lastyawupdate > globals.tickcount() and yaw_delta == 0 and
                    options.resolver_data[target].skitterupdate - globals.tickcount() < 0 then
                    plist.set(target, "Force body yaw", true)
                    plist.set(target, "Force body yaw value", (options.resolver_data[target].side) > 0 and 60 or -60)
                    options.resolver_data[target].lastplistupdate = globals.tickcount() + 10
                elseif math.abs(yaw_delta) >= 33 then
                    plist.set(target, "Force body yaw", true)
                    plist.set(target, "Force body yaw value", (yaw_delta) > 0 and 60 or -60)

                    options.resolver_data[target].lastplistupdate = globals.tickcount() + 10
                elseif options.resolver_data[target].lastplistupdate < globals.tickcount() then
                    plist.set(target, "Force body yaw", false)
                else
                    plist.set(target, "Force body yaw", false)
                end
            end
        elseif ui_get(menu_.Misc.resolver_type) == "Desync" then
            if not entity_is_alive(local_player) then
                return
            end
            client.update_player_list()

            for i = 1, #players do
                local v = players[i]
                if entity.is_enemy(v) then
                    local st_cur, st_pre = res_data.get_simtime(v)
                    st_cur, st_pre = toticks(st_cur), toticks(st_pre)

                    if not res_data.records[v] then
                        res_data.records[v] = {}
                    end

                    local slot = res_data.records[v]

                    slot[st_cur] = {
                        pose = entity_get_prop(v, "m_flPoseParameter", 11) * 120 - 60,
                        eye = select(2, entity_get_prop(v, "m_angEyeAngles"))
                    }

                    local value
                    local allow = (slot[st_pre] and slot[st_cur]) ~= nil

                    if allow then
                        local animstate = res_data.get_animstate(v)
                        local max_desync = res_data.get_max_desync(animstate)

                        if (slot[st_pre] and slot[st_cur]) and max_desync < 0.85 and (st_cur - st_pre < 2) then
                            local side = animates.text_clamp(normalize_yaw(animstate.torso_yaw - slot[st_cur].eye),
                                -1, 1)
                            value = slot[st_pre] and (slot[st_pre].pose * side * max_desync) or nil
                        end

                        if value then
                            plist.set(v, "Force body yaw value", value)
                        end
                    end

                    plist.set(v, "Force body yaw", value ~= nil)
                    plist.set(v, "Correction active", true)
                else
                    plist.set(i, "Force body yaw", false)
                    res_data.records = {}
                end
            end
        end
    end
end

client_set_event_callback("net_update_end", function()
    if globals.chokedcommands() == 0 then
        vars.chokes = vars.chokes + 1
    end
    jitterhelper()
end)

local function pre_render()
    local local_player = entity_get_local_player()
    if not entity_is_alive(local_player) then
        return
    end
    local bodyyaw = entity_get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
    local side = bodyyaw > 0 and 1 or -1
    local static = contains(ui_get(menu_.Visuals.animation_select), "Static Legs")
    -- 抖腿
    local jitter_leg = contains(ui_get(menu_.Visuals.animation_select), "Jitter Leg")
    local earth_quake = contains(ui_get(menu_.Visuals.animation_select), "Earthquake")
    local flashed = contains(ui_get(menu_.Visuals.animation_select), "Flashed")
    local pitch = contains(ui_get(menu_.Visuals.animation_select), "Pitch 0 on Land")
    local allen_walk = contains(ui_get(menu_.Visuals.animation_select), "Allen walk")
    local anti_rev = contains(ui_get(menu_.Visuals.animation_select), "Legs breaker")
    local timing = globals_tickcount() % 69
    local lp_vel = get_velocity(local_player)
    local on_ground = bit_band(entity_get_prop(local_player, "m_fFlags"), 1)

    local static_slow = contains(ui_get(menu_.Visuals.animation_select), "Static slowwalk legs") and
        ui_get(references.slow_walk[2])
    if static then
        entity_set_prop(local_player, "m_flPoseParameter", 1, 6)
    end

    if pitch then
        local on_ground = bit_band(entity_get_prop(local_player, "m_fFlags"), 1)
        if on_ground == 1 then
            vars.ground_ticks = vars.ground_ticks + 1
        else
            vars.ground_ticks = 0
            vars.end_time = globals_curtime() + 1
        end

        if vars.ground_ticks > ui_get(references.fake_lag_limit) + 1 and vars.end_time > globals_curtime() then
            entity_set_prop(local_player, "m_flPoseParameter", 0.5, 12)
        end
    end

    if static_slow then
        entity_set_prop(local_player, "m_flPoseParameter", 0.9 * side, 11)
        entity_set_prop(local_player, "m_flPoseParameter", 0, 9)
    end

    if jitter_leg then
        if lp_vel > 50 and on_ground == 1 and timing > 1 and not ui_get(references.slow_walk[2]) then
            entity_set_prop(local_player, "m_flPoseParameter", 1 - client.random_float(0.5, 1), 0)
            ui_set(references.legmovement, client.random_int(1, 2) == 1 and "Off" or "Always slide")
        end
    end
    if flashed then
        local local_player_ent = ent.get_local_player()
        local not_anim_layer = local_player_ent:get_anim_overlay(9)
        not_anim_layer.weight = 1
        not_anim_layer.sequence = 224
    end

    if earth_quake then
        local me = ent.get_local_player()
        local m_fFlags = me:get_prop("m_fFlags")
        local is_onground = bit_band(m_fFlags, 1) ~= 0
        if not is_onground then
            local my_animlayer = me:get_anim_overlay(12)

            my_animlayer.weight = client.random_float(-0.5, 2.3)
        else
            entity_set_prop(local_player, "m_flPoseParameter", 0, 7)
        end
    end


    if allen_walk then
        local me = ent.get_local_player()
        local m_fFlags = me:get_prop("m_fFlags");
        local is_onground = bit_band(m_fFlags, 1) ~= 0;
        ui_set(references.legmovement, "Never slide")
        entity_set_prop(local_player, "m_flPoseParameter", 1, 7)
        if not is_onground then
            local my_animlayer = me:get_anim_overlay(6);
            my_animlayer.weight = 1;
            entity_set_prop(me, "m_flPoseParameter", 1, 6)
        end
    end

    if anti_rev and on_ground == 1 and timing > 1 and lp_vel > 50 then
        entity_set_prop(local_player, "m_flPoseParameter", client.random_float(0.75, 1), 0)
        ui_set(references.legmovement, client.random_int(1, 3) == 1 and "Off" or "Always slide")
    end
end


local call_backs = {
    shutdown = function()
        vanila_skeet_element(true)
        ui_set(references.aimbot, true)
    end,

    net_updated_end = function()
        un_safe_func.charge_check()
    end,

    setup_command = function(cmd)
        menu_.render:avoid_attack(cmd)
        conditions()
        antiaim_handler(cmd)
        defensive_handler(cmd)
        exploit_hanlder(cmd)
        anti_backstab()
        un_safe_func:unsafe_charging()
    end,
    predict_command = function(cmd)
        defensive_func.update_tickbase(cmd)
    end,
    run_command = function(cmd)
        defensive_func.update_cmdnumber(cmd)
    end,
    paint_ui = function()
        menu_.render.gamesense_tab:listener()
        menu_.render.mouse:listener()
        menu_.render:renderer()
        handle_visible()
        aurora()
        manual_indicator()

        local ss = { client.screen_size() }

        -- 获取文本的宽度
        local text_width = 100 -- 假设文本的宽度为 400 像素
        
        -- 计算文本的 X 坐标使其贴在屏幕右侧并水平居中
        local text_x = ss[1] - text_width
        
        -- 计算文本的 Y 坐标使其垂直居中
        local text_y = (ss[2] / 2)
        
        -- 调用 text_fade_animation 函数
          text_fade_animation(text_x, text_y, 3, { r = 186, g = 186, b = 249, a = 255 }, { r = 0, g = 0, b = 0, a = 255 }, "c", "osmangang.codes")

    end,
    level_init = function (cmd)
        defensive_func.reset_defensive()
        shift_ticks = 0
        wait_dt = 0
    end
}

local hittable = { 
    "用绿演参是打不中我的",
    "怎么退出训练营",
    "对不起没玩过cs2，不理解你的打法",
    "你选错cs2启动项了",
    "小孩子不懂事e着玩的",
    "转人工",
    "忘注入了，绿玩杀的",
    "这智商去玩cs2吧，那里适合你",
    "嘿，你是在试图击打我身边的空气来窒息我？",
    "【　osmangang　ＡＮＴＩ－ＡＩＭＢＯＴ　ＲＥＣＯＤＥ　】", "Get better get <osmangang>", "stay with us - osmangang",
    "osmangang still on top", "1.", "[osmangang] buy or die",
    "[osmangang] just the best lua", "[gamesense] missed dueto resolver", "我使用的是 osmangang.Yaw",
    "◣_◢ osmangang ◣_◢ ", "我杀你只需要一根手指", "ez",
    "when u miss, cry u dont heve osmangang.dev", "我没想到你参数这么垃圾...",
    "杀你只需要一根手指", "1", "1,你怎么这么菜...", "你在用otc么废物?", "easy xD",
    "1,别急", "你被你爹1了,滚去买个好点的参数吧", "你也被脑控了吗" }

local deathtable = { "是的孩子 你赢了", "^^_",
    "1,我帮你扣的 你还不配给我扣1",
    "我让你一个头,我怕你玻璃心砸电脑",
    "我在游戏里被你杀死,你妈在现实里被我杀死",
    "打的我好困,先睡会Zzzz", "看你可怜,这个头送你了",
    "据说你爸妈当年也是这么死的",
    "1,你在奇怪我死了为什么扣1 ?因为我帮你扣的" }

local num_quotes_get_hit = get_table_length(hittable)

local num_quotes_death = get_table_length(deathtable)

local function on_player_death(e)
    if not contains(ui_get(menu_.Misc.misc_combobox), "Enabled Killsay") then
        return
    end
    local victim_userid, attacker_userid = e.userid, e.attacker
    if victim_userid == nil or attacker_userid == nil then
        return
    end

    local victim_entindex = client.userid_to_entindex(victim_userid)
    local attacker_entindex = client.userid_to_entindex(attacker_userid)
    if attacker_entindex == entity_get_local_player() and entity_is_enemy(victim_entindex) then
        if e.headshot then
            local commandhs = 'say ' .. hittable[math.random(num_quotes_get_hit)]
            client.exec(commandhs)
        end
    end
    if victim_entindex == entity_get_local_player() and attacker_entindex ~= entity_get_local_player() then
        local commandbaim = 'say ' .. deathtable[math.random(num_quotes_death)]
        client.exec(commandbaim)
    elseif victim_entindex == entity_get_local_player() and attacker_entindex == entity_get_local_player() then
        client.exec("看来只有我死了这把游戏才能公平 兄弟.")
    end
end
client_set_event_callback("player_death", on_player_death)

local tickshot = 0
client_set_event_callback("bullet_impact", function(event)
    if entity_get_local_player() == nil then
        return
    end
    local enemy = client.userid_to_entindex(event.userid)
    local lp = entity_get_local_player()
    if enemy == lp or not entity_is_enemy(enemy) or not entity_is_alive(lp) then
        return nil
    end
    if fired_at(lp, enemy, { event.x, event.y, event.z }) then
        if tickshot ~= globals_tickcount() then
            notify:paint(3, "Detected a shot by " .. entity_get_player_name(enemy))
            tickshot = globals_tickcount()
        end
    end
end)

local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck",
    "?", "gear" }
local function ragebot_fired(e)
    cache_fire()
    stored_shot = {
        damage = e.damage,
        hitbox = hitgroup_names[e.hitgroup + 1],
        lagcomp = e.teleported,
        backtrack = globals.tickcount() - e.tick
    }
end
client_set_event_callback("aim_fire", ragebot_fired)

local function ragebot_hit(e)
    if contains(ui_get(menu_.Misc.hit_logs), "Hit") then
        local string_hit = string.format("Hit %s for %s (%s) in the %s (%s) (hc: %s; bt: %s; lc: %s)",
            string.lower(entity_get_player_name(e.target)), e.damage, stored_shot.damage,
            hitgroup_names[e.hitgroup + 1] or '?', stored_shot.hitbox, math.floor(e.hit_chance) .. "%",
            stored_shot.backtrack, stored_shot.lagcomp)
        notify:paint(3, string_hit)
        if contains(ui_get(menu_.Misc.hit_logs), "Console") then
            client.color_log(255, 170, 170, "osmangang -> \0")
            client.color_log(255, 170, 170, string_hit)
        end
    end
end
client_set_event_callback("aim_hit", ragebot_hit)

local function ragebot_missed(e)
    if contains(ui_get(menu_.Misc.hit_logs), "Miss") then
        local string_miss = string.format("Missed %s's %s due to %s (dmg: %s; bt: %s; lc: %s)",
            string.lower(entity_get_player_name(e.target)), stored_shot.hitbox, e.reason, stored_shot.damage,
            stored_shot.lagcomp, stored_shot.backtrack)
        notify:paint(3, string_miss)
        if contains(ui_get(menu_.Misc.hit_logs), "Console") then
            client.color_log(234, 94, 66, "osmangang -> \0")
            client.color_log(234, 94, 66, string_miss)
        end
    end
end

client_set_event_callback("aim_miss", ragebot_missed)
client_set_event_callback("pre_render", pre_render)
client_set_event_callback("run_command", call_backs.run_command)
client_set_event_callback("predict_command", call_backs.predict_command)
client_set_event_callback("level_init", call_backs.level_init)
client_set_event_callback('shutdown', call_backs.shutdown)
client_set_event_callback("paint_ui", call_backs.paint_ui)
client_set_event_callback("net_update_end", call_backs.net_updated_end)
client_set_event_callback("setup_command", call_backs.setup_command)
