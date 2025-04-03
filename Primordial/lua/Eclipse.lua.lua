-- imagine crashing hhhhhhhhhhhhhhhhhh
local beta = true

-- start of local variables
local antiaim_is_fakeducking, antiaim_get_max_desync_range, antiaim_get_real_angle, antiaim_get_body_lean,
    antiaim_is_inverting_body_lean, antiaim_is_inverting_desync, antiaim_get_desync_side, antiaim_get_manual_override,
    antiaim_get_fake_angle = antiaim.is_fakeducking, antiaim.get_max_desync_range, antiaim.get_real_angle,
    antiaim.get_body_lean, antiaim.is_inverting_body_lean, antiaim.is_inverting_desync, antiaim.get_desync_side,
    antiaim.get_manual_override, antiaim.get_fake_angle
local client_precache_model, client_get_hitgroup_name, client_get_unix_time, client_log_screen, client_log,
    client_get_hitbox_name, client_delay_call, client_random_float, client_get_fps, client_get_tickrate,
    client_set_clantag, client_can_fire, client_random_int, client_is_in_thirdperson, client_get_local_time,
    client_ticks_to_time, client_time_to_ticks = client.precache_model, client.get_hitgroup_name, client.get_unix_time,
    client.log_screen, client.log, client.get_hitbox_name, client.delay_call, client.random_float, client.get_fps,
    client.get_tickrate, client.set_clantag, client.can_fire, client.random_int, client.is_in_thirdperson,
    client.get_local_time, client.ticks_to_time, client.time_to_ticks
local debug_overlay_add_line, debug_overlay_add_capsule, debug_overlay_add_box, debug_overlay_add_sphere =
    debug_overlay.add_line, debug_overlay.add_capsule, debug_overlay.add_box, debug_overlay.add_sphere
local engine_set_view_angles, engine_get_latency, engine_get_last_outgoing_command, engine_is_in_game,
    engine_get_level_name, engine_get_bsp_entities, engine_get_bsp_entity, engine_get_player_index_from_user_id,
    engine_get_bomb_radius, engine_get_level_name_short, engine_play_sound, engine_execute_cmd,
    engine_get_choked_commands, engine_is_connected, engine_is_app_active, engine_get_view_angles,
    engine_get_local_player_index, engine_get_last_acknowledged_command = engine.set_view_angles, engine.get_latency,
    engine.get_last_outgoing_command, engine.is_in_game, engine.get_level_name, engine.get_bsp_entities,
    engine.get_bsp_entity, engine.get_player_index_from_user_id, engine.get_bomb_radius, engine.get_level_name_short,
    engine.play_sound, engine.execute_cmd, engine.get_choked_commands, engine.is_connected, engine.is_app_active,
    engine.get_view_angles, engine.get_local_player_index, engine.get_last_acknowledged_command
local entity_list_get_player_from_userid, entity_list_get_local_player, entity_list_get_local_player_or_spectating,
    entity_list_get_entities_by_classid, entity_list_get_highest_entity_index, entity_list_get_entities_by_name,
    entity_list_get_players, entity_list_get_entity = entity_list.get_player_from_userid, entity_list.get_local_player,
    entity_list.get_local_player_or_spectating, entity_list.get_entities_by_classid,
    entity_list.get_highest_entity_index, entity_list.get_entities_by_name, entity_list.get_players,
    entity_list.get_entity
local exploits_get_charge, exploits_force_uncharge, exploits_force_recharge, exploits_get_max_charge,
    exploits_block_recharge, exploits_allow_recharge = exploits.get_charge, exploits.force_uncharge,
    exploits.force_recharge, exploits.get_max_charge, exploits.block_recharge, exploits.allow_recharge
local game_rules_get_prop, game_rules_set_prop = game_rules.get_prop, game_rules.set_prop
local global_vars_frame_count, global_vars_cur_time, global_vars_simticks_this_frame, global_vars_real_time,
    global_vars_tick_count, global_vars_frame_time, global_vars_absolute_frame_time, global_vars_interval_per_tick,
    global_vars_max_clients, global_vars_interpolation_amount, global_vars_server_tick = global_vars.frame_count,
    global_vars.cur_time, global_vars.simticks_this_frame, global_vars.real_time, global_vars.tick_count,
    global_vars.frame_time, global_vars.absolute_frame_time, global_vars.interval_per_tick, global_vars.max_clients,
    global_vars.interpolation_amount, global_vars.server_tick
local input_is_key_released, input_find_key_bound_to_binding, input_get_mouse_pos, input_is_mouse_in_bounds,
    input_is_key_toggled, input_block, input_is_key_pressed, input_get_key_name, input_is_key_held, input_get_time_held,
    input_get_scroll_delta = input.is_key_released, input.find_key_bound_to_binding, input.get_mouse_pos,
    input.is_mouse_in_bounds, input.is_key_toggled, input.block, input.is_key_pressed, input.get_key_name,
    input.is_key_held, input.get_time_held, input.get_scroll_delta
local materials_for_each, materials_find, materials_create = materials.for_each, materials.find, materials.create
local memory_create_interface, memory_find_text, memory_find_pattern, memory_get_vfunc = memory.create_interface,
    memory.find_text, memory.find_pattern, memory.get_vfunc
local menu_get_size, menu_find, menu_list, menu_add_slider, menu_add_checkbox, menu_text_input, menu_text,
    menu_multi_keybind, menu_add_list, menu_multi_selection, menu_add_text, menu_set_group_visibility,
    menu_add_text_input, menu_add_separator, menu_separator, menu_is_open, menu_slider, menu_selection,
    menu_color_picker, menu_button, menu_keybind, menu_e_keybind_modes, menu_add_button, menu_get_pos, menu_checkbox,
    menu_add_multi_selection, menu_reload_scripts, menu_add_selection, menu_set_group_column, menu_get_alpha_modifier =
    menu.get_size, menu.find, menu.list, menu.add_slider, menu.add_checkbox, menu.text_input, menu.text,
    menu.multi_keybind, menu.add_list, menu.multi_selection, menu.add_text, menu.set_group_visibility,
    menu.add_text_input, menu.add_separator, menu.separator, menu.is_open, menu.slider, menu.selection,
    menu.color_picker, menu.button, menu.keybind, menu.e_keybind_modes, menu.add_button, menu.get_pos, menu.checkbox,
    menu.add_multi_selection, menu.reload_scripts, menu.add_selection, menu.set_group_column, menu.get_alpha_modifier
local player_resource_get_prop, player_resource_set_prop = player_resource.get_prop, player_resource.set_prop
local ragebot_get_active_cfg, ragebot_get_autopeek_pos = ragebot.get_active_cfg, ragebot.get_autopeek_pos
local render_get_text_size, render_push_clip, render_load_image, render_rect_filled, render_line, render_pop_clip,
    render_rect_fade, render_circle_filled, render_weapon_icon, render_rect, render_texture, render_get_screen_size,
    render_load_image_buffer, render_create_font, render_weapon_icon_size, render_pop_alpha_modifier, render_circle,
    render_text, render_get_default_font, render_polygon, render_polyline, render_triangle, render_push_alpha_modifier,
    render_triangle_filled, render_progress_circle, render_world_to_screen = render.get_text_size, render.push_clip,
    render.load_image, render.rect_filled, render.line, render.pop_clip, render.rect_fade, render.circle_filled,
    render.weapon_icon, render.rect, render.texture, render.get_screen_size, render.load_image_buffer,
    render.create_font, render.weapon_icon_size, render.pop_alpha_modifier, render.circle, render.text,
    render.get_default_font, render.polygon, render.polyline, render.triangle, render.push_alpha_modifier,
    render.triangle_filled, render.progress_circle, render.world_to_screen
local trace_line, trace_bullet, trace_hull = trace.line, trace.bullet, trace.hull
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error = ipairs,
    assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error
-- end of local variables

--walla this script needs a recode.
local dpi_scale = render_get_screen_size().y / 1440
if dpi_scale < 1 then
    dpi_scale = 1
end

render.line_3d = function(vec3_t_pos_start, vec3_t_pos_end, color)
    local screen_pos_start = render_world_to_screen(vec3_t_pos_start)
    local screen_pos_end = render_world_to_screen(vec3_t_pos_end)
    if not screen_pos_start or not screen_pos_end then
        return
    end

    render_line(screen_pos_start, screen_pos_end, color)
end

-- libs
local libs = {}

libs.json = {
    _version = "0.1.2"
}

-------------------------------------------------------------------------------
-- Encode
-------------------------------------------------------------------------------

libs.json.encode = nil

libs.json.escape_char_map = {
    ["\\"] = "\\",
    ["\""] = "\"",
    ["\b"] = "b",
    ["\f"] = "f",
    ["\n"] = "n",
    ["\r"] = "r",
    ["\t"] = "t"
}

libs.json.escape_char_map_inv = {
    ["/"] = "/"
}
for k, v in pairs(libs.json.escape_char_map) do
    libs.json.escape_char_map_inv[v] = k
end

libs.json.escape_char = function(c)
    return "\\" .. (libs.json.escape_char_map[c] or string.format("u%04x", c:byte()))
end

libs.json.encode_nil = function(val)
    return "null"
end

libs.json.encode_table = function(val, stack)
    local res = {}
    stack = stack or {}

    -- Circular reference?
    if stack[val] then
        error("circular reference")
    end

    stack[val] = true

    if rawget(val, 1) ~= nil or next(val) == nil then
        -- Treat as array -- check keys are valid and it is not sparse
        local n = 0
        for k in pairs(val) do
            if type(k) ~= "number" then
                error("invalid table: mixed or invalid key types")
            end
            n = n + 1
        end
        if n ~= #val then
            error("invalid table: sparse array")
        end
        -- Encode
        for i, v in ipairs(val) do
            table.insert(res, libs.json.encode(v, stack))
        end
        stack[val] = nil
        return "[" .. table.concat(res, ",") .. "]"

    else
        -- Treat as an object
        for k, v in pairs(val) do
            if type(k) ~= "string" then
                error("invalid table: mixed or invalid key types")
            end
            table.insert(res, libs.json.encode(k, stack) .. ":" .. libs.json.encode(v, stack))
        end
        stack[val] = nil
        return "{" .. table.concat(res, ",") .. "}"
    end
end

libs.json.encode_string = function(val)
    return '"' .. val:gsub('[%z\1-\31\\"]', libs.json.escape_char) .. '"'
end

libs.json.encode_number = function(val)
    -- Check for NaN, -inf and inf
    if val ~= val or val <= -math.huge or val >= math.huge then
        error("unexpected number value '" .. tostring(val) .. "'")
    end
    return string.format("%.14g", val)
end

local type_func_map = {
    ["nil"] = libs.json.encode_nil,
    ["table"] = libs.json.encode_table,
    ["string"] = libs.json.encode_string,
    ["number"] = libs.json.encode_number,
    ["boolean"] = tostring
}

libs.json.encode = function(val, stack)
    local t = type(val)
    local f = type_func_map[t]
    if f then
        return f(val, stack)
    end
    error("unexpected type '" .. t .. "'")
end

libs.json.json_encode = function(val)
    return (libs.json.encode(val))
end

-------------------------------------------------------------------------------
-- Decode
-------------------------------------------------------------------------------

libs.json.parse = nil

libs.json.create_set = function(...)
    local res = {}
    for i = 1, select("#", ...) do
        res[select(i, ...)] = true
    end
    return res
end

local space_chars = libs.json.create_set(" ", "\t", "\r", "\n")
local delim_chars = libs.json.create_set(" ", "\t", "\r", "\n", "]", "}", ",")
local escape_chars = libs.json.create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local literals = libs.json.create_set("true", "false", "null")

libs.json.literal_map = {
    ["true"] = true,
    ["false"] = false,
    ["null"] = nil
}

libs.json.next_char = function(str, idx, set, negate)
    for i = idx, #str do
        if set[str:sub(i, i)] ~= negate then
            return i
        end
    end
    return #str + 1
end

libs.json.decode_error = function(str, idx, msg)
    local line_count = 1
    local col_count = 1
    for i = 1, idx - 1 do
        col_count = col_count + 1
        if str:sub(i, i) == "\n" then
            line_count = line_count + 1
            col_count = 1
        end
    end
    error(string.format("%s at line %d col %d", msg, line_count, col_count))
end

libs.json.codepoint_to_utf8 = function(n)
    local f = math.floor
    if n <= 0x7f then
        return string.char(n)
    elseif n <= 0x7ff then
        return string.char(f(n / 64) + 192, n % 64 + 128)
    elseif n <= 0xffff then
        return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
    elseif n <= 0x10ffff then
        return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128, f(n % 4096 / 64) + 128, n % 64 + 128)
    end
    error(string.format("invalid unicode codepoint '%x'", n))
end

libs.json.parse_unicode_escape = function(s)
    local n1 = tonumber(s:sub(1, 4), 16)
    local n2 = tonumber(s:sub(7, 10), 16)
    -- Surrogate pair?
    if n2 then
        return libs.json.codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
    else
        return libs.json.codepoint_to_utf8(n1)
    end
end

libs.json.parse_string = function(str, i)
    local res = ""
    local j = i + 1
    local k = j

    while j <= #str do
        local x = str:byte(j)

        if x < 32 then
            libs.json.decode_error(str, j, "control character in string")

        elseif x == 92 then -- `\`: Escape
            res = res .. str:sub(k, j - 1)
            j = j + 1
            local c = str:sub(j, j)
            if c == "u" then
                local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1) or str:match("^%x%x%x%x", j + 1) or
                                libs.json.decode_error(str, j - 1, "invalid unicode escape in string")
                res = res .. libs.json.parse_unicode_escape(hex)
                j = j + #hex
            else
                if not escape_chars[c] then
                    libs.json.decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
                end
                res = res .. libs.json.escape_char_map_inv[c]
            end
            k = j + 1

        elseif x == 34 then -- `"`: End of string
            res = res .. str:sub(k, j - 1)
            return res, j + 1
        end

        j = j + 1
    end

    libs.json.decode_error(str, i, "expected closing quote for string")
end

libs.json.parse_number = function(str, i)
    local x = libs.json.next_char(str, i, delim_chars)
    local s = str:sub(i, x - 1)
    local n = tonumber(s)
    if not n then
        libs.json.decode_error(str, i, "invalid number '" .. s .. "'")
    end
    return n, x
end

libs.json.parse_literal = function(str, i)
    local x = libs.json.next_char(str, i, delim_chars)
    local word = str:sub(i, x - 1)
    if not literals[word] then
        libs.json.decode_error(str, i, "invalid literal '" .. word .. "'")
    end
    return libs.json.literal_map[word], x
end

libs.json.parse_array = function(str, i)
    local res = {}
    local n = 1
    i = i + 1
    while 1 do
        local x
        i = libs.json.next_char(str, i, space_chars, true)
        -- Empty / end of array?
        if str:sub(i, i) == "]" then
            i = i + 1
            break
        end
        -- Read token
        x, i = libs.json.parse(str, i)
        res[n] = x
        n = n + 1
        -- Next token
        i = libs.json.next_char(str, i, space_chars, true)
        local chr = str:sub(i, i)
        i = i + 1
        if chr == "]" then
            break
        end
        if chr ~= "," then
            libs.json.decode_error(str, i, "expected ']' or ','")
        end
    end
    return res, i
end

libs.json.parse_object = function(str, i)
    local res = {}
    i = i + 1
    while 1 do
        local key, val
        i = libs.json.next_char(str, i, space_chars, true)
        -- Empty / end of object?
        if str:sub(i, i) == "}" then
            i = i + 1
            break
        end
        -- Read key
        if str:sub(i, i) ~= '"' then
            libs.json.decode_error(str, i, "expected string for key")
        end
        key, i = libs.json.parse(str, i)
        -- Read ':' delimiter
        i = libs.json.next_char(str, i, space_chars, true)
        if str:sub(i, i) ~= ":" then
            libs.json.decode_error(str, i, "expected ':' after key")
        end
        i = libs.json.next_char(str, i + 1, space_chars, true)
        -- Read value
        val, i = libs.json.parse(str, i)
        -- Set
        res[key] = val
        -- Next token
        i = libs.json.next_char(str, i, space_chars, true)
        local chr = str:sub(i, i)
        i = i + 1
        if chr == "}" then
            break
        end
        if chr ~= "," then
            libs.json.decode_error(str, i, "expected '}' or ','")
        end
    end
    return res, i
end

libs.json.char_func_map = {
    ['"'] = libs.json.parse_string,
    ["0"] = libs.json.parse_number,
    ["1"] = libs.json.parse_number,
    ["2"] = libs.json.parse_number,
    ["3"] = libs.json.parse_number,
    ["4"] = libs.json.parse_number,
    ["5"] = libs.json.parse_number,
    ["6"] = libs.json.parse_number,
    ["7"] = libs.json.parse_number,
    ["8"] = libs.json.parse_number,
    ["9"] = libs.json.parse_number,
    ["-"] = libs.json.parse_number,
    ["t"] = libs.json.parse_literal,
    ["f"] = libs.json.parse_literal,
    ["n"] = libs.json.parse_literal,
    ["["] = libs.json.parse_array,
    ["{"] = libs.json.parse_object
}

libs.json.parse = function(str, idx)
    local chr = str:sub(idx, idx)
    local f = libs.json.char_func_map[chr]
    if f then
        return f(str, idx)
    end
    libs.json.decode_error(str, idx, "unexpected character '" .. chr .. "'")
end

libs.json.json_parse = function(str)
    if type(str) ~= "string" then
        error("expected argument of type string, got " .. type(str))
    end
    local res, idx = libs.json.parse(str, libs.json.next_char(str, 1, space_chars, true))
    idx = libs.json.next_char(str, idx, space_chars, true)
    if idx <= #str then
        libs.json.decode_error(str, idx, "trailing garbage")
    end
    return res
end

libs.autocallbacks = {}

libs.autocallbacks.setup_callbacks = function(table)
    for callback_name, fn in pairs(table) do
        if callback_name:sub(1, 3) == 'on_' then
            callback_name = callback_name:sub(4, #callback_name)
        end
        if not e_callbacks[callback_name:upper()] then
            client.log(color_t(255, 50, 50, 255), string.format('Callback "%s" not found.', callback_name))
            return
        end

        callbacks.add(e_callbacks[callback_name:upper()], fn)
    end
end

libs.notifications = {}

libs.notifications.font = render_get_default_font()
-- {type: hit/miss, time: time, player: player_t, damage_dealt: number, damage_predicted: number, hitbox: e_hitbox}
libs.notifications.logs = {}
libs.notifications.delay = 5
libs.notifications.accent_color = color_t(230, 170, 170, 255)
libs.notifications.neutral_color = color_t(230, 230, 230, 255)
libs.notifications.background_color = color_t(0, 0, 0, 200)
libs.notifications.width = 250
libs.notifications.padding = 5

libs.notifications.emoji_to_svg = {
    -- success
    ['success'] = render_load_image_buffer(
        "<svg id=\"emoji\" viewBox=\"0 0 72 72\" xmlns=\"http://www.w3.org/2000/svg\"><g id=\"color\"><path fill=\"#b1cc33\" d=\"m61.5 23.3-8.013-8.013-25.71 25.71-9.26-9.26-8.013 8.013 17.42 17.44z\"/></g><g id=\"line\"><path fill=\"none\" stroke=\"#000\" stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-miterlimit=\"10\" stroke-width=\"2\" d=\"m10.5 39.76 17.42 17.44 33.58-33.89-8.013-8.013-25.71 25.71-9.26-9.26z\"/></g></svg>"),

    -- warning
    ['warn'] = render_load_image_buffer(
        '<svg id=\"emoji\" viewBox=\"0 0 72 72\" xmlns=\"http://www.w3.org/2000/svg\"><g id=\"color\"><path fill=\"#fcea2b\" stroke=\"none\" stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-miterlimit=\"10\" stroke-width=\"2\" d=\"M32.5222,13.005c0.6977-1.2046,1.9862-2.0244,3.4778-2.0244c1.4916,0,2.7801,0.8198,3.4778,2.0244l20.9678,41.9351 C60.7889,55.5339,61,56.2136,61,56.9483c0,2.2272-1.8051,4.0323-4.0323,4.0323l-41.9354,0.0173 C12.8051,60.9979,11,59.192,11,56.9657c0-0.7356,0.211-1.4145,0.5544-2.0083L32.5222,13.005\"/><path fill=\"#FFFFFF\" stroke=\"none\" stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-miterlimit=\"10\" stroke-width=\"2\" d=\"M37.6129,47.2709c0,0.8907-0.7222,1.6129-1.6129,1.6129c-0.8907,0-1.6129-0.7222-1.6129-1.6129V23.8925 c0-0.8907,0.7222-1.6129,1.6129-1.6129c0.8907,0,1.6129,0.7222,1.6129,1.6129V47.2709z\"/><circle cx=\"36\" cy=\"54.529\" r=\"1.6129\" fill=\"#FFFFFF\" stroke=\"none\" stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-miterlimit=\"10\" stroke-width=\"2\"/></g><g id=\"hair\"/><g id=\"skin\"/><g id=\"skin-shadow\"/><g id=\"line\"><path fill=\"none\" stroke=\"#000000\" stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-miterlimit=\"10\" stroke-width=\"2\" d=\"M32.5222,13.005c0.6977-1.2046,1.9862-2.0244,3.4778-2.0244c1.4916,0,2.7801,0.8198,3.4778,2.0244l20.9678,41.9351 C60.7889,55.5339,61,56.2136,61,56.9483c0,2.2272-1.8051,4.0323-4.0323,4.0323l-41.9354,0.0173 C12.8051,60.9979,11,59.192,11,56.9657c0-0.7356,0.211-1.4145,0.5544-2.0083L32.5222,13.005\"/><path fill=\"none\" stroke=\"#000000\" stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-miterlimit=\"10\" stroke-width=\"2\" d=\"M37.6129,47.2709c0,0.8907-0.7222,1.6129-1.6129,1.6129c-0.8907,0-1.6129-0.7222-1.6129-1.6129V23.8925 c0-0.8907,0.7222-1.6129,1.6129-1.6129c0.8907,0,1.6129,0.7222,1.6129,1.6129V47.2709z\"/><circle cx=\"36\" cy=\"54.529\" r=\"1.6129\" fill=\"none\" stroke=\"#000000\" stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-miterlimit=\"10\" stroke-width=\"2\"/></g></svg>'),

    -- failure
    ['fail'] = render_load_image_buffer(
        "<svg id=\"emoji\" viewBox=\"0 0 72 72\" xmlns=\"http://www.w3.org/2000/svg\"><g id=\"color\"><path fill=\"#ea5a47\" d=\"m58.14 21.78-7.76-8.013-14.29 14.22-14.22-14.22-8.013 8.013 14.36 14.22-14.36 14.22 8.014 8.013 14.22-14.22 14.29 14.22 7.76-8.013-14.22-14.22z\"/></g><g id=\"hair\"/><g id=\"skin\"/><g id=\"skin-shadow\"/><g id=\"line\"><path fill=\"none\" stroke=\"#000\" stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-miterlimit=\"10\" stroke-width=\"2\" d=\"m58.14 21.78-7.76-8.013-14.29 14.22-14.22-14.22-8.013 8.013 14.35 14.22-14.35 14.22 8.014 8.013 14.22-14.22 14.29 14.22 7.76-8.013-14.22-14.22z\"/></g></svg>")
}

libs.notifications.types = {
    success = 'success',
    warning = 'warn',
    failure = 'fail'
}

math.clamp = function(value, min, max)
    return math.min(math.max(value, min), max)
end

libs.notifications.lerp = function(a, b, t)
    return a + (b - a) * t
end

libs.notifications.create = function(header, body, type)
    table.insert(libs.notifications.logs, {
        head = header,
        body = body,
        emoji = libs.notifications.emoji_to_svg[type],
        time = global_vars_real_time(),
        pos = vec2_t(0, 0),
        init = false,
        height = 0,
        strings = {}
    })
end

libs.notifications.render = function()
    local screen_size = render_get_screen_size()
    local global_text_height = 30

    for i, log in pairs(libs.notifications.logs) do
        if global_vars_real_time() - log.time <= 0.1 then
            log.pos.y = global_text_height
        end

        -- Initialise log to save fps
        if not log.init then
            log.init = true

            local top_height = 20
            local text_height = 4

            local cur_str = ''
            local word = {
                str = '',
                length = 0
            }
            for str_index = 1, #log.body do
                local letter = log.body:sub(str_index, str_index)

                word.length = word.length + 1
                word.str = word.str .. letter

                if letter == ' ' then
                    word.str = ''
                    word.length = 0
                end

                if not (cur_str == '' and letter == ' ') then
                    cur_str = cur_str .. letter
                end

                local text_width = render_get_text_size(libs.notifications.font, cur_str).x
                if text_width > libs.notifications.width - libs.notifications.padding * 2 then
                    if word.str == '' then
                        text_height = text_height + render_get_text_size(libs.notifications.font, cur_str).y
                        table.insert(log.strings, cur_str)
                        cur_str = ''
                    else
                        local cur_str_substring = cur_str:sub(1, #cur_str - word.length)
                        text_height = text_height + render.get_text_size(libs.notifications.font, cur_str_substring).y
                        table.insert(log.strings, cur_str_substring)
                        cur_str = word.str
                    end
                end

            end

            if log.strings[#log.strings] ~= cur_str then
                table.insert(log.strings, cur_str)
                text_height = text_height + render_get_text_size(libs.notifications.font, cur_str).y
            end

            log.height = text_height + top_height
        end

        -- calculate position
        if log.pos.x < 300 and log.time + libs.notifications.delay > global_vars_real_time() then
            log.pos.x = libs.notifications.lerp(log.pos.x, 270, 0.07)
        end

        log.pos.y = libs.notifications.lerp(log.pos.y, global_text_height, 0.05)

        -- margin between notifications
        local margin = (i - 1) * 10

        -- fade out
        local opacity = math.clamp((log.time + libs.notifications.delay - global_vars_real_time()) * 2.8, 0, 1)
        render_push_alpha_modifier(opacity)

        -- render border
        -- render.rect( vec2_t(screen_size.x - log.pos.x, log.pos.y + margin), vec2_t(notifications.width, log.height), notifications.accent_color, 5 )

        -- glow border
        local c = libs.notifications.accent_color
        for i_ = 3, 0, -1 do
            local color = color_t(c.r, c.g, c.b, i_ * 10)
            render_rect(vec2_t(screen_size.x - log.pos.x - (4 - i_), log.pos.y + margin - (4 - i_)),
                vec2_t(libs.notifications.width + (4 - i_) * 2, log.height + (4 - i_) * 2), color, 10)
        end

        -- render background
        render_rect_filled(vec2_t(screen_size.x - log.pos.x, log.pos.y + margin),
            vec2_t(libs.notifications.width, log.height), libs.notifications.background_color, 5)

        -- render head
        render_text(libs.notifications.font, log.head, vec2_t(
            screen_size.x - log.pos.x + libs.notifications.padding + 15,
            log.pos.y + margin + libs.notifications.padding - 1), libs.notifications.accent_color)

        -- render emoji on top right of the head
        render_texture(log.emoji.id, vec2_t(screen_size.x - log.pos.x + libs.notifications.padding - 5,
            log.pos.y + margin + libs.notifications.padding - 3), vec2_t(72 / 4, 72 / 4))

        -- render separator
        render_line(vec2_t(screen_size.x - log.pos.x + 2, log.pos.y + margin + 20),
            vec2_t(screen_size.x - log.pos.x + (libs.notifications.width - 4) *
                       ((math.clamp(global_vars_real_time() - log.time, 0, libs.notifications.delay - 0.5)) /
                           (libs.notifications.delay - 0.5)), log.pos.y + margin + 20), libs.notifications.accent_color)

        -- render body
        for index, str in pairs(log.strings) do
            render_text(libs.notifications.font, str, vec2_t(screen_size.x - log.pos.x + libs.notifications.padding,
                log.pos.y + margin + libs.notifications.padding + index * 12 + 5), libs.notifications.neutral_color)
        end

        render_pop_alpha_modifier()

        -- remove log if it's too old
        if opacity <= 0 then
            table.remove(libs.notifications.logs, i)
        end

        global_text_height = global_text_height + log.height
    end
end

libs.file_system = {}
libs.file_system.raw_fn = {}
libs.file_system.filesystem = memory_create_interface("filesystem_stdio.dll", "VBaseFileSystem011")
libs.file_system.filesystem_class = ffi.cast(ffi.typeof("void***"), libs.file_system.filesystem)
libs.file_system.filesystem_vftbl = libs.file_system.filesystem_class[0]

libs.file_system.raw_fn.read_file = ffi.cast("int (__thiscall*)(void*, void*, int, void*)",
    libs.file_system.filesystem_vftbl[0])
libs.file_system.raw_fn.write_file = ffi.cast("int (__thiscall*)(void*, void const*, int, void*)",
    libs.file_system.filesystem_vftbl[1])

libs.file_system.raw_fn.open_file = ffi.cast("void* (__thiscall*)(void*, const char*, const char*, const char*)",
    libs.file_system.filesystem_vftbl[2])
libs.file_system.raw_fn.close_file = ffi.cast("void (__thiscall*)(void*, void*)", libs.file_system.filesystem_vftbl[3])

libs.file_system.raw_fn.get_file_size = ffi.cast("unsigned int (__thiscall*)(void*, void*)",
    libs.file_system.filesystem_vftbl[7])
libs.file_system.raw_fn.file_exists = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)",
    libs.file_system.filesystem_vftbl[10])

libs.file_system.full_filesystem = memory_create_interface("filesystem_stdio.dll", "VFileSystem017")
libs.file_system.full_filesystem_class = ffi.cast(ffi.typeof("void***"), libs.file_system.full_filesystem)
libs.file_system.full_filesystem_vftbl = libs.file_system.full_filesystem_class[0]

libs.file_system.raw_fn.add_search_path = ffi.cast("void (__thiscall*)(void*, const char*, const char*, int)",
    libs.file_system.full_filesystem_vftbl[11])
libs.file_system.raw_fn.remove_search_path = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)",
    libs.file_system.full_filesystem_vftbl[12])

libs.file_system.raw_fn.remove_file = ffi.cast("void (__thiscall*)(void*, const char*, const char*)",
    libs.file_system.full_filesystem_vftbl[20])
libs.file_system.raw_fn.rename_file = ffi.cast("bool (__thiscall*)(void*, const char*, const char*, const char*)",
    libs.file_system.full_filesystem_vftbl[21])
libs.file_system.raw_fn.create_dir_hierarchy = ffi.cast("void (__thiscall*)(void*, const char*, const char*)",
    libs.file_system.full_filesystem_vftbl[22])
libs.file_system.raw_fn.is_directory = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)",
    libs.file_system.full_filesystem_vftbl[23])

libs.file_system.raw_fn.find_first = ffi.cast("const char* (__thiscall*)(void*, const char*, int*)",
    libs.file_system.full_filesystem_vftbl[32])
libs.file_system.raw_fn.find_next = ffi.cast("const char* (__thiscall*)(void*, int)",
    libs.file_system.full_filesystem_vftbl[33])
libs.file_system.raw_fn.find_is_directory = ffi.cast("bool (__thiscall*)(void*, int)",
    libs.file_system.full_filesystem_vftbl[34])
libs.file_system.raw_fn.find_close = ffi.cast("void (__thiscall*)(void*, int)",
    libs.file_system.full_filesystem_vftbl[35])

libs.file_system.MODES = {
    ["r"] = "r",
    ["w"] = "w",
    ["a"] = "a",
    ["r+"] = "r+",
    ["w+"] = "w+",
    ["a+"] = "a+",
    ["rb"] = "rb",
    ["wb"] = "wb",
    ["ab"] = "ab",
    ["rb+"] = "rb+",
    ["wb+"] = "wb+",
    ["ab+"] = "ab+"
}

libs.file_system.fn = {}
libs.file_system.fn.__index = libs.file_system.fn

function libs.file_system.fn.exists(file, path_id)
    return libs.file_system.raw_fn.file_exists(libs.file_system.filesystem_class, file, path_id)
end

function libs.file_system.fn.rename(old_path, new_path, path_id)
    libs.file_system.raw_fn.rename_file(libs.file_system.full_filesystem_class, old_path, new_path, path_id)
end

function libs.file_system.fn.remove(file, path_id)
    libs.file_system.raw_fn.remove_file(libs.file_system.full_filesystem_class, file, path_id)
end

function libs.file_system.fn.create_directory(path, path_id)
    libs.file_system.raw_fn.create_dir_hierarchy(libs.file_system.full_filesystem_class, path, path_id)
end

function libs.file_system.fn.is_directory(path, path_id)
    return libs.file_system.raw_fn.is_directory(libs.file_system.full_filesystem_class, path, path_id)
end

function libs.file_system.fn.find_first(path)
    local handle = ffi.new("int[1]")
    local file = libs.file_system.raw_fn.find_first(libs.file_system.full_filesystem_class, path, handle)
    if file == ffi.NULL then
        return nil
    end

    return handle, ffi.string(file)
end

function libs.file_system.fn.find_next(handle)
    local file = libs.file_system.raw_fn.find_next(libs.file_system.full_filesystem_class, handle)
    if file == ffi.NULL then
        return nil
    end

    return ffi.string(file)
end

function libs.file_system.fn.find_is_directory(handle)
    return libs.file_system.raw_fn.find_is_directory(libs.file_system.full_filesystem_class, handle)
end

function libs.file_system.fn.open(file, mode, path_id)
    if not libs.file_system.MODES[mode] then
        error("Invalid mode!")
    end
    local self = setmetatable({
        file = file,
        mode = mode,
        path_id = path_id,
        handle = libs.file_system.raw_fn.open_file(libs.file_system.filesystem_class, file, mode, path_id)
    }, libs.file_system.fn)

    return self
end

function libs.file_system.fn:get_size()
    return libs.file_system.raw_fn.get_file_size(libs.file_system.filesystem_class, self.handle)
end

function libs.file_system.fn:write(buffer)
    libs.file_system.raw_fn.write_file(libs.file_system.filesystem_class, buffer, #buffer, self.handle)
end

function libs.file_system.fn:read()
    local size = self:get_size()
    local output = ffi.new("char[?]", size + 1)
    libs.file_system.raw_fn.read_file(libs.file_system.filesystem_class, output, size, self.handle)

    return ffi.string(output)
end

function libs.file_system.fn:close()
    libs.file_system.raw_fn.close_file(libs.file_system.filesystem_class, self.handle)
end
-- filesystem lib end

-- https://primordial.dev/resources/reload-scripts-on-change.199/
-- modified
libs.search_file_system = {}
libs.search_file_system.call = ffi.cast("void***", libs.file_system.full_filesystem)
ffi.cdef([[
    typedef void (__thiscall* AddSearchPath)(void*, const char*, const char*);
    typedef void (__thiscall* RemoveSearchPaths)(void*, const char*);
    typedef const char* (__thiscall* FindNext)(void*, int);
    typedef bool (__thiscall* FindIsDirectory)(void*, int);
    typedef void (__thiscall* FindClose)(void*, int);
    typedef const char* (__thiscall* FindFirstEx)(void*, const char*, const char*, int*);
    typedef long (__thiscall* GetFileTime)(void*, const char*, const char*);
]])

libs.search_file_system.fn = {}
libs.search_file_system.fn.add_search_path = ffi.cast("AddSearchPath", libs.search_file_system.call[0][11])
libs.search_file_system.fn.remove_search_paths = ffi.cast("RemoveSearchPaths", libs.search_file_system.call[0][14])
libs.search_file_system.fn.find_next = ffi.cast("FindNext", libs.search_file_system.call[0][33])
libs.search_file_system.fn.find_is_directory = ffi.cast("FindIsDirectory", libs.search_file_system.call[0][34])
libs.search_file_system.fn.find_close = ffi.cast("FindClose", libs.search_file_system.call[0][35])
libs.search_file_system.fn.find_first_ex = ffi.cast("FindFirstEx", libs.search_file_system.call[0][36])

libs.search_file_system.fn.list_files = function(relative_path)
    local file_handle = ffi.new("int[1]")
    libs.search_file_system.fn.remove_search_paths(libs.search_file_system.call, "eclipse_temp")
    libs.search_file_system.fn.add_search_path(libs.search_file_system.call, relative_path, "eclipse_temp")

    local file_names = {}
    local file = libs.search_file_system.fn
                     .find_first_ex(libs.search_file_system.call, "*", "eclipse_temp", file_handle)
    while file ~= nil do
        local file_name = ffi.string(file)
        if libs.search_file_system.fn.find_is_directory(libs.search_file_system.call, file_handle[0]) == false and
            not file_name:find("banmdls[.]res") then
            table.insert(file_names, file_name)
        end

        file = libs.search_file_system.fn.find_next(libs.search_file_system.call, file_handle[0])
    end
    libs.search_file_system.fn.find_close(libs.search_file_system.call, file_handle[0])

    return file_names
end

-- text bobbing lib
libs.animated_text = {}

function libs.animated_text.hslToRgb(h, s, l)
    if s == 0 then
        return l, l, l
    end
    local function to(p, q, t)
        if t < 0 then
            t = t + 1
        end
        if t > 1 then
            t = t - 1
        end
        if t < .16667 then
            return p + (q - p) * 6 * t
        end
        if t < .5 then
            return q
        end
        if t < .66667 then
            return p + (q - p) * (.66667 - t) * 6
        end
        return p
    end
    local q = l < .5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    return to(p, q, h + .33334), to(p, q, h), to(p, q, h - .33334)
end

function libs.animated_text.rgbToHsl(r, g, b)
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local b = max + min
    local h = b / 2
    if max == min then
        return 0, 0, h
    end
    local s, l = h, h
    local d = max - min
    s = l > .5 and d / (2 - b) or d / b
    if max == r then
        h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
        h = (b - r) / d + 2
    elseif max == b then
        h = (r - g) / d + 4
    end
    return h * .16667, s, l
end

libs.animated_text.loop_delay = 2

libs.animated_text.animated_text_texts = {}

libs.animated_text.lerp = function(a, b, t)
    return a + (b - a) * t
end

libs.animated_text.render = function(animated_text_name, font, text, pos, color, max_height)
    if not type(animated_text_name) ~= 'string' then
        tostring(animated_text_name)
    end

    if not libs.animated_text[animated_text_name] then
        libs.animated_text[animated_text_name] = {}
        libs.animated_text[animated_text_name]['inverted_animations'] = math.abs(max_height) / max_height
        libs.animated_text[animated_text_name]['last_loop'] = 0
        libs.animated_text[animated_text_name]['iter'] = 1

        for i = 1, #text do
            libs.animated_text[animated_text_name][i] = {
                letter = text:sub(i, i),
                offset = 0,
                time = 0,
                time_delay = 0,
                inverted = false
            }
        end

    end

    if libs.animated_text[animated_text_name]['iter'] > #text then
        libs.animated_text[animated_text_name]['iter'] = 1
        libs.animated_text[animated_text_name]['last_loop'] = global_vars_cur_time()
    end

    if libs.animated_text[animated_text_name]['last_loop'] + libs.animated_text.loop_delay > global_vars_cur_time() then
        render_text(font, text, pos, color)
        return
    end

    local animated_text_texts = libs.animated_text[animated_text_name]

    local offset_left = 0
    for i = 1, #animated_text_texts do
        local curr = animated_text_texts[i]

        if libs.animated_text[animated_text_name]['iter'] == i then
            if curr.offset <= math.abs(max_height) and not curr.inverted then
                curr.offset = libs.animated_text.lerp(curr.offset, math.abs(max_height + max_height / 5), 0.1)
            else
                curr.inverted = true
            end

            if curr.offset >= 0 and curr.inverted then
                curr.offset = libs.animated_text.lerp(curr.offset, -1, 0.1)
                if curr.offset <= 0 then
                    curr.inverted = false;
                    libs.animated_text[animated_text_name]['iter'] = libs.animated_text[animated_text_name]['iter'] + 1;
                    curr.offset = 0
                end
            end
        end

        local hsl = {libs.animated_text.rgbToHsl(color.r, color.g, color.b)}

        hsl[1] = hsl[1] + (curr.offset / 200)

        local rgb = {libs.animated_text.hslToRgb(hsl[1], hsl[2], hsl[3])}

        local color =
            curr.offset > 0 and color_t(math.floor(rgb[1]), math.floor(rgb[2]), math.floor(rgb[3]), color.a) or color

        render_text(font, curr.letter, pos +
            vec2_t(offset_left, libs.animated_text[animated_text_name]['inverted_animations'] * curr.offset), color)

        offset_left = offset_left + render_get_text_size(font, curr.letter).x
    end
end
-- libs end

-- Color fade info panel dt charge
local function g_math(int, max, declspec)
    local int = (int > max and max or int)

    local tmp = max / int;
    local i = (declspec / tmp)
    i = (i >= 0 and math.floor(i + 0.5) or math.ceil(i - 0.5))

    return i
end

local function interpolate_color_tickbase(number, max)
    local colors = {{237, 27, 3}, {235, 63, 6}, {229, 104, 8}, {228, 126, 10}, {145, 255, 60}}

    i = g_math(number, max, #colors)
    return colors[i <= 1 and 1 or i][1], colors[i <= 1 and 1 or i][2], colors[i <= 1 and 1 or i][3]
end

local function lerp(a, b, t)
    return a * (1 - t) + b * t
end

local sv = {}

--[[sv.weapons = { --Define the weapon groups in a table to work with them below
    ["auto"] = 0,
    ["scout"] = 1,
    ["awp"] = 2,
    ["deagle"] = 3,
    ["revolver"] = 4,
    ["pistols"] = 5,
    ["other"] = 6
}}]]
sv.weapons = { -- Define the weapon groups in a table to work with them below
    ["auto"] = 0,
    ["scout"] = 1,
    ["awp"] = 2,
    ["deagle"] = 3,
    ["revolver"] = 4,
    ["pistols"] = 5,
    ["other"] = 6
}

sv.dmgvalue =
    function(weapon) -- Function so it applies to every weapon group. "weapon" is our current weapon. rb_ref.dmgoverride is just for scout.

        local mindmg_v = menu.find("aimbot", weapon, "target overrides", "min. damage")

        for i, v in ipairs(mindmg_v) do
            if (v[2] == true) then
                return v
            end
        end

        return mindmg_v[1] -- Get the min dmg. [1] == dmg, [2] == true/false
    end

sv.defaultdmgvalue =
    function(weapon) -- Function so it applies to every weapon group. "weapon" is our current weapon. rb_ref.dmgoverride is just for scout.

        local mindmg_v = menu.find("aimbot", weapon, "targeting", "min. damage")

        return mindmg_v -- Get the min dmg. [1] == dmg, [2] == true/false
    end

local kackepeter = { -- Define the weapon groups in a table to work with them below
"auto", "scout", "awp", "deagle", "revolver", "pistols", "other"}

sv.current_weapon_default = function() -- !default min dmg
    local dmgoutput, state = 0, 0
    local penis = ragebot.get_active_cfg() + 1
    if (penis > 7) then
        return 0
    end

    local weapon = kackepeter[penis] -- get_active_cfg returns the weapon group as a number (wtf is 2?)
    return menu.find("aimbot", weapon, "targeting", "min. damage"):get()
end

sv.current_weapon = function() -- ! override min dmg
    local dmgoutput, state = 0, 0
    local penis = ragebot.get_active_cfg() + 1

    if (penis > 7) then
        return 0
    end

    local weapon = kackepeter[penis] -- get_active_cfg returns the weapon group as a number (wtf is 2?)
    return menu.find("aimbot", weapon, "target overrides", "min. damage")[1]:get()
end

sv.wep_name_to_enum = {
    -- Weapons
    ['DEAGLE'] = e_items.WEAPON_DEAGLE,
    ['P2000'] = e_items.WEAPON_HKP2000,
    ['ELITE'] = e_items.WEAPON_ELITE,
    ['FIVESEVEN'] = e_items.WEAPON_FIVESEVEN,
    ['GLOCK'] = e_items.WEAPON_GLOCK,
    ['AK47'] = e_items.WEAPON_AK47,
    ['AUG'] = e_items.WEAPON_AUG,
    ['AWP'] = e_items.WEAPON_AWP,
    ['FAMAS'] = e_items.WEAPON_FAMAS,
    ['G3SG1'] = e_items.WEAPON_G3SG1,
    ['GALILAR'] = e_items.WEAPON_GALILAR,
    ['M249'] = e_items.WEAPON_M249,
    ['M4A1'] = e_items.WEAPON_M4A1,
    ['MAC10'] = e_items.WEAPON_MAC10,
    ['P90'] = e_items.WEAPON_P90,
    ['ZONE_REPULSOR'] = e_items.WEAPON_ZONE_REPULSOR,
    ['MP5SD'] = e_items.WEAPON_MP5SD,
    ['UMP45'] = e_items.WEAPON_UMP45,
    ['XM1014'] = e_items.WEAPON_XM1014,
    ['BIZON'] = e_items.WEAPON_BIZON,
    ['MAG7'] = e_items.WEAPON_MAG7,
    ['NEGEV'] = e_items.WEAPON_NEGEV,
    ['SAWEDOFF'] = e_items.WEAPON_SAWEDOFF,
    ['TEC9'] = e_items.WEAPON_TEC9,
    ['TASER'] = e_items.WEAPON_TASER,
    ['HKP2000'] = e_items.WEAPON_HKP2000,
    ['MP7'] = e_items.WEAPON_MP7,
    ['MP9'] = e_items.WEAPON_MP9,
    ['NOVA'] = e_items.WEAPON_NOVA,
    ['P250'] = e_items.WEAPON_P250,
    ['SCAR20'] = e_items.WEAPON_SCAR20,
    ['SG556'] = e_items.WEAPON_SG556,
    ['SSG08'] = e_items.WEAPON_SSG08,
    ['M4A1-S'] = e_items.WEAPON_M4A1_SILENCER,
    ['USP-S'] = e_items.WEAPON_USP_SILENCER,
    ['CZ75A'] = e_items.WEAPON_CZ75A,
    ['REVOLVER'] = e_items.WEAPON_REVOLVER,

    -- knives
    ['WEAPON_KNIFEGG'] = e_items.WEAPON_KNIFEGG,
    ['KNIFE'] = e_items.WEAPON_KNIFE,
    ['KNIFE_CSS'] = e_items.WEAPON_KNIFE_CSS,
    ['KNIFE_FLIP'] = e_items.WEAPON_KNIFE_FLIP,
    ['KNIFE_GUT'] = e_items.WEAPON_KNIFE_GUT,
    ['KNIFE_KARAMBIT'] = e_items.WEAPON_KNIFE_KARAMBIT,
    ['KNIFE_M9_BAYONET'] = e_items.WEAPON_KNIFE_M9_BAYONET,
    ['KNIFE_TACTICAL'] = e_items.WEAPON_KNIFE_TACTICAL,
    ['KNIFE_FALCHION'] = e_items.WEAPON_KNIFE_FALCHION,
    ['KNIFE_SURVIVAL_BOWIE'] = e_items.WEAPON_KNIFE_SURVIVAL_BOWIE,
    ['KNIFE_BUTTERFLY'] = e_items.WEAPON_KNIFE_BUTTERFLY,
    ['KNIFE_PUSH'] = e_items.WEAPON_KNIFE_PUSH,
    ['KNIFE_CORD'] = e_items.WEAPON_KNIFE_CORD,
    ['KNIFE_CANIS'] = e_items.WEAPON_KNIFE_CANIS,
    ['KNIFE_URSUS'] = e_items.WEAPON_KNIFE_URSUS,
    ['KNIFE_GYPSY_JACKKNIFE'] = e_items.WEAPON_KNIFE_GYPSY_JACKKNIFE,
    ['KNIFE_OUTDOOR'] = e_items.WEAPON_KNIFE_OUTDOOR,
    ['KNIFE_STILETTO'] = e_items.WEAPON_KNIFE_STILETTO,
    ['KNIFE_WIDOWMAKER'] = e_items.WEAPON_KNIFE_WIDOWMAKER,
    ['KNIFE_SKELETON'] = e_items.WEAPON_KNIFE_SKELETON,

    -- Utility
    ['FLASHBANG'] = e_items.WEAPON_FLASHBANG,
    ['HEGRENADE'] = e_items.WEAPON_HEGRENADE,
    ['SMOKEGRENADE'] = e_items.WEAPON_SMOKEGRENADE,
    ['MOLOTOV'] = e_items.WEAPON_MOLOTOV,
    ['DECOY'] = e_items.WEAPON_DECOY,
    ['INCGRENADE'] = e_items.WEAPON_INCGRENADE,
    ['C4'] = e_items.WEAPON_C4
}

sv.callbacks = {}

sv.screen_size = render_get_screen_size() -- screen size
sv.x, sv.y = sv.screen_size.x / 2, sv.screen_size.y / 2 + 30 -- x and y

sv.render_utility = {
    font = render_create_font("Impact", 40 * dpi_scale, 400),
    default_font = render_get_default_font(),
    fake_font = render_create_font("Verdana", math.ceil(27 * dpi_scale), 700, e_font_flags.ADDITIVE,
        e_font_flags.ANTIALIAS),
    font_antialias = render_create_font("Verdana", math.ceil(13 * dpi_scale), 26, e_font_flags.DROPSHADOW,
        e_font_flags.ANTIALIAS),
    main_font = render_create_font("Small Fonts", math.ceil(10 * dpi_scale), 400, e_font_flags.OUTLINE,
        e_font_flags.ANTIALIAS), -- font Keybinds
    eclipse_font = render_create_font("Small Fonts", math.ceil(12 * dpi_scale), 600, e_font_flags.DROPSHADOW,
        e_font_flags.OUTLINE), -- Eclipse Text font
    eclipse2_font = render_create_font("Small Fonts", math.ceil(12 * dpi_scale), 600, e_font_flags.DROPSHADOW), -- Eclipse2 Text font
    eclipsepixel_font = render_create_font("Small Fonts", math.ceil(12 * dpi_scale), 300, e_font_flags.OUTLINE,
        e_font_flags.ANTIALIAS), -- Eclipse Text font
    dt_ind_font = render_create_font('Verdana', math.ceil(12 * dpi_scale), 250, e_font_flags.DROPSHADOW,
        e_font_flags.ANTIALIAS), -- font Keybinds
    main_font2 = render_create_font("Small Fonts", math.ceil(10 * dpi_scale), 400), -- font Min dmg Override
    -- default_color = color_t(137, 207, 240,255)
    default_color2 = color_t(100, 100, 100, 150),
    accent_color = menu_find('misc', 'main', 'personalization', 'accent color')[2],
    world_miss_marker = {
        text_font = render_create_font('Small Fonts', math.ceil(12 * dpi_scale), 100, e_font_flags.DROPSHADOW,
            e_font_flags.ANTIALIAS),
        icon_font = render_create_font('Small Fonts', math.ceil(17 * dpi_scale), 550, e_font_flags.ANTIALIAS,
            e_font_flags.OUTLINE),
        text_font2 = render_create_font('Verdana', math.ceil(12 * dpi_scale), 100, e_font_flags.DROPSHADOW),
        icon_font2 = render_create_font('Small Fonts', math.ceil(25 * dpi_scale), 550, e_font_flags.ANTIALIAS,
            e_font_flags.OUTLINE)
    }
}

sv.rb_ref = {
    doubletap = menu_find("aimbot", "general", "exploits", "doubletap", "enable"), -- doubletap
    hideshots = menu_find("aimbot", "general", "exploits", "hideshots", "enable"), -- hideshots
    dmgoverride = menu_find("aimbot", "scout", "target overrides", "min. damage"), -- damage override
    dmg_scout_default = menu_find("aimbot", "scout", "targeting", "min. damage"), -- Default scout damage (broken since unpack doesnt work)
    --hitboxoverride = menu_find("aimbot", "scout", "target overrides", "hitbox"), -- froce baim
    quickpeek_ref = menu_find("aimbot", "general", "misc", "autopeek", "enable"), -- Quick peek
    roll_reso = menu_find("aimbot", "general", "aimbot", "body lean resolver", "enable"), -- Roll reso
    --autodir_key = menu_find("antiaim", "main", "auto direction", "enable"),
    pingspikeenable = menu_find("aimbot", "general", "fake ping", "enable"),
    hc = menu_find("aimbot", "deagle", "targeting", "hitchance"),
    sp = menu_find("aimbot", "deagle", "target overrides", "safepoint")
    -- sp_condition = menu_find("aimbot", "deagle", "accuracy", "force safepoint states"),
}

sv.aa_ref = {
    slowwalk_key = menu_find("misc", "main", "movement", "slow walk"),
    freestand_ref = menu_find("antiaim", "main", "auto direction", "enable"), -- Freestand
    desyncl = menu_find("antiaim", "main", "desync", "left amount"),
    desyncr = menu_find("antiaim", "main", "desync", "right amount"),
    desync_side = menu_find("antiaim", "main", "desync", "side"),
    leanmode = menu_find("antiaim", "main", "angles", "body lean"),
    leanvalue = menu_find("antiaim", "main", "angles", "body lean value"),
    movinglean = menu_find("antiaim", "main", "angles", "moving body lean"),
    pitch = menu_find("antiaim", "main", "angles", "pitch"),
    yawadd = menu_find("antiaim", "main", "angles", "yaw add"),
    yawbase = menu_find("antiaim", "main", "angles", "yaw base"),
    rotate = menu_find("antiaim", "main", "angles", "rotate"),
    rotaterange = menu_find("antiaim", "main", "angles", "rotate range"),
    rotatespeed = menu_find("antiaim", "main", "angles", "rotate speed"),
    jittermode = menu_find("antiaim", "main", "angles", "jitter mode"),
    jittertype = menu_find("antiaim", "main", "angles", "jitter type"),
    jitteramount = menu_find("antiaim", "main", "angles", "jitter add"),
    antibf = menu_find("antiaim", "main", "desync", "anti bruteforce"),
    defaultside = menu_find("antiaim", "main", "desync", "default side"),
    override_stand_move = menu_find("antiaim", "main", "desync", "override stand"),
    override_stand_slowwalk = menu_find("antiaim", "main", "desync", "override stand#slow walk"),
    invert = menu_find("antiaim", "main", "manual", "invert desync"),
    movingbl = menu_find("antiaim", "main", "angles", "moving body lean"),
    invertbl = menu_find("antiaim", "main", "manual", "invert body lean"),
    onshot = menu_find("antiaim", "main", "desync", "on shot")
}

-- Table of the menu items for the default conditional aa
-- Create a selection with all of the states using a for loop
-- A State table with the calculation below, this will make the conditional AA setup easier
sv.states_table = {{
    name = "standing / global",
    cond = standing and not ducking and air_ind
}, {
    name = "moving",
    cond = moving and not ducking and not sv.aa_ref.slowwalk_key[2]:get() and air_ind
}, {
    name = "air",
    cond = not air_ind and not sv.aa_ref.slowwalk_key[2]:get() and not standing
}, {
    name = "air duck",
    cond = not air_ind and not sv.aa_ref.slowwalk_key[2]:get() and not standing and ducking
}, {
    name = "ducking",
    cond = ducking and standing
}, {
    name = "slowwalking",
    cond = sv.aa_ref.slowwalk_key[2]:get() and not standing and not ducking
}}

-- Create a selection with all of the states using a for loop
sv.antiaim_states = {}
for i, v in ipairs(sv.states_table) do
    sv.antiaim_states[#sv.antiaim_states + 1] = v.name
end

-- draggable stuff
e_menu_types = {
    ['CHECKBOX'] = 0,
    ['DROPDOWN'] = 1
}

e_menu_open_types = {
    ['DOWN'] = 0,
    ['SIDE'] = 1
}

menu_t = function(args)
    local self = {}
    self.width = args['width'] or error('Please specify size to menu_t.')
    self.menu_elements = {}
    self.options = args['interaction_menu'] or error('No interaction menu specified for menu_t.')
    self.visible = args['visible'] or false
    self.animation = args['animation'] or {
        last_time = 0,
        time = 1
    }

    function self:add_checkbox(name, default)
        self.menu_elements[#self.menu_elements + 1] = option_checkbox_t(name, default)
        return self.menu_elements[#self.menu_elements]
    end

    function self:add_dropdown(name, items, default)
        self.menu_elements[#self.menu_elements + 1] = option_dropdown_t(name, items, default)
        return self.menu_elements[#self.menu_elements]
    end

    function self:show()
        self.visible = not self.visible
        self.animation.last_time = global_vars_real_time()
    end

    function self:render()
        local reversed = not self.visible

        if (reversed and (1 - ((global_vars_real_time() - self.animation.last_time) / self.animation.time)) < 0) then
            return
        end

        local extra_height = 17
        local height = extra_height + sv.render_utility.default_font.height

        for i = 1, #self.menu_elements do
            local option = self.menu_elements[i]

            if option.visible then
                if option.type == e_menu_types.CHECKBOX then
                    height = height + 16
                elseif option.type == e_menu_types.DROPDOWN then
                    height = height + 34
                end
            end
        end

        local width = self.options.width
        local pos = self.options.pos

        local alpha = ((global_vars_real_time() - self.animation.last_time) / self.animation.time)
        alpha = math.clamp(alpha, 0, 1)
        render_push_alpha_modifier(lerp(0, 1, reversed and (1 - alpha) or alpha))

        local mask_height = ((global_vars_real_time() - self.animation.last_time) / self.animation.time) * height
        mask_height = math.clamp(mask_height, 0, height)

        render_push_clip(pos, vec2_t(width, height))
        render_rect_filled(pos, vec2_t(width, height), color_t(0, 0, 0, 255), 8)
        render_rect_filled(pos + vec2_t(1, 1), vec2_t(width - 2, height - 2), color_t(36, 36, 36, 255), 8)

        -- render header and primordial line
        render_rect_filled(pos + vec2_t(1, 1), vec2_t(width - 2, extra_height), color_t(46, 46, 46, 255), 8)
        render_rect_filled(pos + vec2_t(1, 5), vec2_t(width - 2, extra_height - 4), color_t(46, 46, 46, 255), 0)

        local acc_c = sv.misc_ref.accent_color:get()
        render_line(pos + vec2_t(1, extra_height), pos + vec2_t(width - 1, extra_height), acc_c)

        -- title
        render_text(sv.render_utility.default_font, self.options.title,
            pos + vec2_t(width / 2, sv.render_utility.default_font.height / 2 + 3), color_t(255, 255, 255, 255), true)

        local elem_offset = 18
        local render_above = {}
        local selecting_in_dropdown = false
        for i = 1, #self.menu_elements do
            local option = self.menu_elements[i]

            if option.visible then
                if option.type ~= e_menu_types.DROPDOWN then
                    option:render(pos + vec2_t(0, elem_offset), vec2_t(5, 5), self.width, not selecting_in_dropdown,
                        acc_c)
                    elem_offset = elem_offset + 16
                else
                    selecting_in_dropdown = selecting_in_dropdown and true or option.open

                    table.insert(render_above, {
                        option = option,
                        offset = elem_offset
                    })

                    elem_offset = elem_offset + 32
                end
            end
        end

        render_pop_clip()

        local selected_dropdown_id = nil
        selecting_in_dropdown = false
        for i = 1, #render_above do
            local option = render_above[i].option
            selecting_in_dropdown = selecting_in_dropdown and true or option.open
            selected_dropdown_id = selected_dropdown_id and selected_dropdown_id or
                                       (selecting_in_dropdown and option.id or nil)

        end

        -- render after handleing menus
        for i = #render_above, 1, -1 do
            local option = render_above[i].option
            local offset = render_above[i].offset

            local is_clickable = (not selecting_in_dropdown) or (selected_dropdown_id == option.id) or false

            option:render(pos + vec2_t(0, offset), vec2_t(5, 5), self.width, is_clickable, acc_c)
        end

        if (not selecting_in_dropdown) and
            (not input_is_mouse_in_bounds(pos, vec2_t(width, height)) and input_is_key_pressed(e_keys.MOUSE_LEFT)) then
            self:show()
        end

        render_pop_alpha_modifier()
    end

    return self
end

option_checkbox_t = function(name, default)
    -- initialise the object table
    local self = {}

    self.size_y = 14

    local default_val = default
    if default_val then
        default_val = 1
    else
        default_val = 0
    end

    -- give it defined values
    self.name = type(name) == 'string' and name or
                    error(string.format('Invalid name for option_checkbox_t. Got "%s", expected "string".', type(name)))

    self.state = type(default) == 'boolean' and default_val or
                     error(
            string.format('Invalid default state for option_checkbox_t. Got "%s", expected "boolean".', type(default)))

    -- set type to checkbox
    self.type = e_menu_types.CHECKBOX

    -- default visibility is always true
    self.visible = true

    -- animation related variables
    self.animation = {
        last_time = 0,
        time = 0.05
    }

    -- scrolling offset
    self.scrolling_offset = 0

    function self:click()
        -- set checkbox value to the inverse of the current default
        self.state = not (self.state == 1)

        if #self.callbacks > 0 then
            for _, callback in pairs(self.callbacks) do
                callback()
            end
        end

        -- reset checkbox animation states
        self.animation.last_time = global_vars_real_time()
    end

    -- get the value of our checkbox
    function self:get()
        return (self.state == 1)
    end

    -- set the value of our checkbox
    function self:set(bool)
        if not type(bool) == 'boolean' then
            error(string.format('Invalid parameter for option_checkbox_t:set( boolean ). Got "%s", expected "boolean".',
                type(bool)))
        end

        self.state = bool and 1 or 0
        self.animation.last_time = global_vars_real_time()
    end

    function self:set_visible(bool)
        if not type(bool) == 'boolean' then
            error(string.format(
                'Invalid parameter for option_checkbox_t:set_visible( boolean ). Got "%s", expected "boolean".',
                type(bool)))
        end

        self.visible = bool
    end

    self.callbacks = {}
    function self:register_callback(fn)
        table.insert(self.callbacks, fn)
    end

    function self:render(pos, padding, width, selectable, acc_c)
        if self.visible then
            local reversed = not self:get()

            local animation_perc = ((global_vars_real_time() - self.animation.last_time) / self.animation.time)

            if reversed then
                animation_perc = 1 - animation_perc
            end

            animation_perc = math.clamp(animation_perc, 0, 1)

            local alpha_option = math.floor(animation_perc * 255)

            local checkbox_start = pos + padding
            local checkbox_size = vec2_t(12, 12)

            render_rect_filled(checkbox_start, checkbox_size, color_t(50, 50, 50, 255), 2)
            render_rect_filled(checkbox_start + vec2_t(1, 1), checkbox_size - vec2_t(2, 2), color_t(0, 0, 0, 255), 2)
            local c = color_t(acc_c.r, acc_c.g, acc_c.b, alpha_option)

            render_rect_filled(checkbox_start + vec2_t(2, 2), checkbox_size - vec2_t(4, 4), c, 3)

            local text_pos = pos + vec2_t(padding.x + 14, padding.y)

            render_text(sv.render_utility.default_font, self.name, text_pos - vec2_t(0, 1), color_t(255, 255, 255, 255))

            if (selectable) and
                (input_is_mouse_in_bounds(pos + vec2_t(0, padding.y - 1),
                    vec2_t(width, sv.render_utility.default_font.height)) and input_is_key_pressed(e_keys.MOUSE_LEFT)) then
                self:set(reversed)
            end
        end
    end

    return self
end

option_dropdown_t = function(name, values, default_selected)
    -- initialise the object table
    local self = {}

    -- give it defined values
    self.name = type(name) == 'string' and name or
                    error(
            string.format('Invalid name for option_dropdown_t. Got "%s", expected "string".', type(values)))

    self.values = type(values) == 'table' and values or
                      error(
            string.format('Invalid default state for option_dropdown_t. Got "%s", expected "table".', type(values)))

    self.items = {}
    for i, entry in pairs(self.values) do
        local is_selected = default_selected == i

        self.items[i] = {
            name = entry,
            selected = is_selected
        }
    end

    self.id = generate_random_id()

    -- set type to checkbox
    self.type = e_menu_types.DROPDOWN

    -- default visibility is always true
    self.visible = true

    -- default open state is always false
    self.open = false

    -- animation related variables
    self.animation = {
        last_time = 0,
        time = 0.05,

        name_offset = 0 -- this is for the menu element's name, if the width of our viewport is not big enough, it will scroll on hover
    }

    self.enabled_offset = 0

    local check_index = function(index)
        if type(index) ~= 'number' then
            error(string.format('Invalid parameter for option_dropdown_t:get( index ). Got "%s", expected "number".',
                type(index)))
        elseif index > #self.items then
            error(string.format('Invalid index for option_dropdown_t:get( index ). Got "%s", expected "1 .. %s".',
                index, #self.items))
        end
    end

    -- scrolling offset
    self.scrolling_offset = 0

    function self:click(index)
        self.open = not self.open

        -- reset checkbox animation states
        self.animation.last_time = global_vars_real_time()
    end

    -- get the value of our checkbox
    function self:get(index)
        check_index(index)

        return self.items[index]
    end

    -- set the value of our checkbox
    function self:set(index)
        check_index(index)

        -- clean all previous entries
        for _, entry in pairs(self.items) do
            entry.selected = false
        end

        self.items[index].selected = true
    end

    -- return all values
    function self:get_items()
        return self.items
    end

    function self:set_visible(bool)
        if not type(bool) == 'boolean' then
            error(string.format(
                'Invalid parameter for option_dropdown_t:set_visible( boolean ). Got "%s", expected "boolean".',
                type(bool)))
        end

        self.visible = bool
    end

    self.callbacks = {}
    function self:register_callback(fn)
        table.insert(self.callbacks, fn)
    end

    function self:render(pos, padding, width, selectable, acc_c)
        if self.visible then
            local animation_perc = ((globals.real_time() - self.animation.last_time) / self.animation.time)

            animation_perc = math.clamp(animation_perc, 0, 1)
            animation_perc = self.open and animation_perc or 1 - animation_perc

            local alpha_option = math.floor(animation_perc * 255)

            local text_x_offset = 0
            local text_start = pos + vec2_t(8, 4)
            local dropdown_start = text_start + vec2_t(-3, 14)

            if (input_is_mouse_in_bounds(text_start, vec2_t(width, text_size.x))) then
                local text_length = render_get_text_size(font, self.name).x
                if text_length - width > (self.animation.name_offset - 8) then
                    self.animation.name_offset = self.animation.name_offset + 1
                end
            else
                self.animation.name_offset = math.max(self.animation.name_offset - 1, 0)
            end

            text_start = text_start - vec2_t(self.animation.name_offset, 0)

            render_push_clip(pos + vec2_t(0, -3), vec2_t(width, 20))
            render_text(sv.render_utility.default_font, self.name, text_start, color_t(255, 255, 255, 255))
            render_pop_clip()

            local dropdown_size = vec2_t(width - 10, 18)

            render_rect_filled(dropdown_start, dropdown_size, color_t(50, 50, 50, 255), 2)
            render_rect_filled(dropdown_start + vec2_t(1, 1), dropdown_size - vec2_t(2, 2), color_t(0, 0, 0, 255), 2)

            local selected_options = ''
            local items = self:get_items()
            for i = 1, #items do
                local item = items[i]
                if item.selected then
                    selected_options = selected_options .. item.name .. ', '
                end
            end

            selected_options = selected_options == '' and '-' or selected_options:sub(1, -3)
            local options_length = render_get_text_size(sv.render_utility.default_font, selected_options).x

            if input.is_mouse_in_bounds(dropdown_start + vec2_t(5, 3), vec2_t(width, 20)) and
                (width - 20 - options_length) < 0 then
                self.enabled_offset = math.min(self.enabled_offset + 0.5, options_length - width + 20)
            else
                self.enabled_offset = math.max(self.enabled_offset - 1, 0)
            end

            render_push_clip(dropdown_start + vec2_t(1, 3), vec2_t(width - 13, 20))
            render_text(sv.render_utility.default_font, selected_options,
                dropdown_start + vec2_t(5 - self.enabled_offset, 3), color_t(180, 180, 180, 255))
            render_pop_clip()

            if selectable and input.is_key_pressed(e_keys.MOUSE_LEFT) and
                input_is_mouse_in_bounds(dropdown_start, dropdown_size) then
                self:click()
            end

            local height = math.clamp(15 * #self.items, 0, 100) * animation_perc
            render_push_clip(dropdown_start + vec2_t(0, 18), vec2_t(width - 10, height))
            render_rect_filled(dropdown_start + vec2_t(1, dropdown_size.y), vec2_t(dropdown_size.x - 2, height),
                color_t(0, 0, 0, alpha_option), 2)

            local in_bounds_open = input_is_mouse_in_bounds(dropdown_start, dropdown_size + vec2_t(0, height))
            if self.open and input_is_key_pressed(e_keys.MOUSE_LEFT) and not in_bounds_open then
                self:click()
            end

            -- calculate the hovered item mathematically
            self.scrolling_offset = math.clamp(self.scrolling_offset + input_get_scroll_delta() * 4,
                -15 * #self.items + 100, 0)

            local hovered_item = in_bounds_open and
                                     math.floor(
                    (input_get_mouse_pos().y - dropdown_start.y - dropdown_size.y - self.scrolling_offset) / 15) + 1 or
                                     nil
            if self.open and hovered_item ~= nil and hovered_item ~= 0 then
                local item = self.items[hovered_item]
                if item ~= nil then
                    local item_pos = dropdown_start +
                                         vec2_t(1, dropdown_size.y + 15 * (hovered_item - 1) + self.scrolling_offset)

                    if input_is_key_pressed(e_keys.MOUSE_LEFT) and
                        input_is_mouse_in_bounds(item_pos, vec2_t(dropdown_size.x, 15)) then
                        self:set(hovered_item, not item.selected)
                    end
                end
            end

            if self.open then
                for i = 1, #self.items do
                    local item = self.items[i]
                    local item_pos = dropdown_start + vec2_t(1, dropdown_size.y + 15 * (i - 1))
                    local c = item.selected and color_t(acc_c.r, acc_c.g, acc_c.b, alpha_option) or
                                  color_t(180, 180, 180, alpha_option)
                    render_text(sv.render_utility.default_font, item.name, item_pos + vec2_t(5, self.scrolling_offset),
                        c)
                end
            end
            render_pop_clip()
        end
    end

    return self
end

interaction_menu = function(args)
    local self = {}
    self.width = args['width'] or 100
    self.title = args['title'] or 'interaction menu'
    self.pos = vec2_t(0, 0)
    self.menu_t = menu_t({
        width = self.width,
        interaction_menu = self,
        visible = false,
        animation = {
            last_time = 0,
            time = 0.2
        }
    })

    function self:add_checkbox(name, default)
        return self.menu_t:add_checkbox(name, default)
    end

    function self:add_dropdown(name, items, default)
        return self.menu_t:add_dropdown(name, items, default)
    end

    return self
end

draggable = function(args)
    local self = {}

    self.pos = args['pos'] or vec2_t(100, 100)
    self.size = args['size'] or vec2_t(100, 100)
    self.interaction_menu = args['interaction_menu'] or interaction_menu({
        pos = self.pos
    })

    self.opens_to = args['opens_to'] or e_menu_open_types.DOWN

    self.interaction_menu.width = self.size.x
    self.custom_render_hook = nil

    if not self.interaction_menu.animation then
        self.interaction_menu.animation = {}
    end

    self.title_texts = args['texts'] or {'this', 'is', 'a', 'draggable'}

    self.difference = vec2_t(0, 0)
    self.dragging = false

    function self:set_render_fn(func)
        self.custom_render_hook = func
    end

    self.handlers = {}
    function self:handle_dragging()
        if not menu_is_open() then
            self.dragging = false
            return
        end

        if self.dragging or (input_is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(self.pos, self.size)) then
            self.pos = input_get_mouse_pos() - self.difference
            self.dragging = true
        else
            self.difference = input_get_mouse_pos() - self.pos
        end

        if not input_is_key_held(e_keys.MOUSE_LEFT) then
            self.dragging = false
        end
    end

    function self:set_render_hook(func)
        self.custom_render_hook = func
    end

    function self:get_items()
        return self.interaction_menu.entries
    end

    function self:get_option(name)
        local items = self:get_items()

        for i = 1, #items do
            if items[i].name == name then
                return items[i]
            end
        end

        return nil
    end

    function self:handle_interaction_menu()
        if self.dragging and self.interaction_menu.menu_t.visible then
            self.interaction_menu.menu_t:show()
            return
        end

        if not self.dragging and input_is_key_pressed(e_keys.MOUSE_RIGHT) and
            input_is_mouse_in_bounds(self.pos, self.size) then
            if not (self.interaction_menu.menu_t.visible) then
                if self.opens_to == e_menu_open_types.DOWN then
                    self.interaction_menu.pos = vec2_t(input_get_mouse_pos().x - self.interaction_menu.width / 2,
                        self.pos.y + self.size.y + 5)

                    local diff = self.interaction_menu.pos.x - self.pos.x
                    if diff < 0 then
                        self.interaction_menu.pos.x = self.interaction_menu.pos.x - diff
                    else
                        diff = (self.interaction_menu.pos.x + self.interaction_menu.width) - (self.pos.x + self.size.x)
                        if diff > 0 then
                            self.interaction_menu.pos.x = self.interaction_menu.pos.x - diff
                        end
                    end

                    local is_out_of_bounds = self.interaction_menu.pos.x + self.interaction_menu.width >
                                                 render_get_screen_size().x
                    if is_out_of_bounds then
                        self.interaction_menu.pos.x = render_get_screen_size().x - self.interaction_menu.width - 10
                    end
                elseif self.opens_to == e_menu_open_types.SIDE then
                    self.interaction_menu.pos = vec2_t(self.pos.x + self.interaction_menu.width + 5, self.pos.y)

                    local is_out_of_screen = self.interaction_menu.pos.x + self.interaction_menu.width + 5 >
                                                 render_get_screen_size().x
                    if is_out_of_screen then
                        self.interaction_menu.pos.x = self.pos.x - self.interaction_menu.menu_t.width - 5
                    end
                end
            end

            self.interaction_menu.menu_t:show()
        end
    end

    function self:handle_drawing()
        self:handle_interaction_menu()

        if self.custom_render_hook then
            self.custom_render_hook(self)
        end

        self.interaction_menu.menu_t:render()
    end

    return self
end

-- Refs for misc features
sv.misc_ref = {
    third_person = menu_find("visuals", "View", "thirdperson", "enable"),
    accent_color = menu_find('misc', 'main', 'personalization', 'accent color')[2]
}

sv.data = {
    stored_simtime = 0,
    active_until = 0,
    defensive_active = false,
    simtime_dif = 0,
    simtime_dif2 = 0,
}

-- * Function table
sv.fn = {
    normalize_yaw = function(yaw)
        local result = yaw

        while (result < -180) do
            result = result + 360
        end

        while (result > 180) do
            result = result - 360
        end

        return result
    end,

    angle_to_vector = function(angle)
        local p, y = math.rad(angle.x), math.rad(angle.y)
        local sp, cp, sy, cy = math.sin(p), math.cos(p), math.sin(y), math.cos(y)
        return vec3_t(cp * cy, cp * sy, -sp)
    end,

    multiply_vector = function(vec, mul)
        return vec3_t(vec.x * mul, vec.y * mul, vec.z * mul)
    end,

    angle_between_vectors = function(vec1, vec2)
        local delta = vec2 - vec1

        local hyp = math.sqrt(delta.x * delta.x + delta.y * delta.y)
        local pitch = math.deg(math.atan2(-delta.z, hyp))
        local yaw = math.deg(math.atan2(delta.y, delta.x))

        return angle_t(pitch, yaw, 0)
    end,

    extrapolate_vector_by_units = function(self, target, origin, angle, units)
        local vecForward_vector = self.angle_to_vector(angle)
        local vecExtrapolated = self.multiply_vector(vecForward_vector, units)
        local fFraction = trace_line(origin, vecExtrapolated, target, 0x200400B).fraction
        return origin + self.multiply_vector(vecExtrapolated, fFraction)
    end,

    extrapolate_player_position = function(self, player, origin, ticks)
        local vel = player:get_prop('m_vecVelocity')
        if not vel then
            return nil
        end
        local pred_tick = global_vars_interval_per_tick() * ticks
        return origin + self.multiply_vector(vel, pred_tick)
    end,

    interpolate_color_tickbase = function(number, max)
        local colors = {{237, 27, 3}, {235, 63, 6}, {229, 104, 8}, {228, 126, 10}, {115, 220, 13}}

        local i = g_math(number, max, #colors)
        return colors[i <= 1 and 1 or i][1], colors[i <= 1 and 1 or i][2], colors[i <= 1 and 1 or i][3]
    end,

    interpolate_color_fakelag = function(number, max)
        local colors = {{124, 195, 13}, {176, 205, 10}, {213, 201, 19}, {220, 169, 16}, {228, 126, 10}, {229, 104, 8},
                        {235, 63, 6}, {237, 27, 3}, {255, 0, 0}}

        local i = g_math(number, max, #colors)
        return colors[i <= 1 and 1 or i][1], colors[i <= 1 and 1 or i][2], colors[i <= 1 and 1 or i][3]
    end,

    detect_defensive = function()
        --if not exploits.get_charge() then return end
        
        local lp = entity_list_get_local_player()
        if not lp then return end
        local simtime = lp:get_prop("m_flSimulationTime")
        local simtime_dif = simtime - sv.data.stored_simtime

        local latency_outgoing = engine.get_latency(e_latency_flows.OUTGOING)
        
        if simtime_dif < 0 then
            local shifted_amount = client.time_to_ticks(simtime_dif)

            sv.data.simtime_dif = simtime_dif --We only wanna update the shifted amount when defensive actually triggers
            sv.data.simtime_dif2 = shifted_amount
            sv.data.active_until = globals.tick_count() + shifted_amount
            --sv.data.defensive_active = true
        end

        sv.data.stored_simtime = simtime
        --sv.data.simtime_dif = simtime_dif
    end,
}

-- * Script menu items
sv.items = {
    multiselect_enablesections = menu_add_multi_selection("Main", "Enable Script Section",
        {"Crosshair indicators", "Visuals", "Misc", "Anti-Aim"}),

    multiselect_keybinds = menu_add_multi_selection("Crosshair Indicators", "Keybind Indicators", {"Freestand",
                                                                                                   "Ping spike",
                                                                                                   "Quick peek assist",
                                                                                                   "Roll Resolver",
                                                                                                   "Hide Shots",
                                                                                                   "Double Tap",
                                                                                                   "Fake Duck"}),
    checkbox_enable_scope_in_animation = menu_add_checkbox("Crosshair Indicators", "Enable Scope in Animation"),
    checkbox_keybindsactiveonly = menu_add_checkbox("Crosshair Indicators", "Active keybinds only"),
    aastatecolor = menu_add_text("Crosshair Indicators", "Anti-Aim State Color"),
    eclipsecolor = menu_add_text("Crosshair Indicators", "Eclipse Color"),

    checkbox_hitlogs_enable_checkbox = menu_add_checkbox("Visuals", "Enable Hitlogs", false),
    slider_hitlogs_pos_y = menu_add_slider("Visuals", "Hitlogs offset", -100, 100, 1, 1, 'px'),
    checkbox_enable_infopanel = menu_add_checkbox("Visuals", "Enable information panel [DISABLED]", false),
    -- checkbox_enable_keybinds = menu_add_checkbox("Visuals", "Enable keybinds list", false),
    checkbox_2018_anims_enable = menu_add_checkbox("Visuals", "Enable client-sided animations", false),
    multiselect_2018_anims_options = menu_add_multi_selection("Visuals", "animations", {'0 pitch on land',
                                                                                        'static legs in air',
                                                                                        'lean in air', 'backwards slide'}),

    checkbox_clantag_enable = menu_add_checkbox("Misc", "Enable eclipse's tag", false),
    checkbox_deagle_nospread_stuff = menu_add_checkbox("Misc", "Deagle landing accuracy (funny but unsafe)", false),

    checkbox_force_sp_after_X_shots = menu_add_checkbox("Misc", "Force Safepoints after X misses"),
    -- multiselect_safepoint_hitboxes = menu_add_multi_selection("Misc", "Force Safepoint Hitboxes", {"Head", "Chest", "Arms", "Stomach", "Legs", "Feet"}),
    slider_enable_after_X_misses = menu_add_slider("Misc", "Force Safepoints after X misses", 0, 10),
    slider_reset_after_X_seconds = menu_add_slider("Misc", "Reset after X seconds", 0, 10),

    checkbox_aaenable = menu_add_checkbox("Anti-Aim", "Enable Anti-Aim"),
    checkbox_edge_yaw_enable = menu_add_checkbox("Anti-Aim", "Edge yaw", false),
    selection_antiaim_target_selection_mode = menu_add_selection("Anti-Aim", "Freestanding target selection",
        {'fov', 'distance'}),
    selection_AntiAim_modes = menu_add_selection("Anti-Aim", "Anti-Aim Modes", {"Dynamic AntiAim", "Conditional"}),
    checkbox_antibfenable = menu_add_checkbox("Anti-Aim", "Enable AntiBrute"),
    selection_antibfmode = menu_add_selection("Anti-Aim", "Anti Bruteforce mode", {"Automatic", "Customized"}),
    multiselect_antibfextras = menu_add_multi_selection("Anti-Aim", "Anti Bruteforce Extras", {"Invert on Hit",
                                                                                               "Invert on enemy miss",
                                                                                               "Randomize desync on Hit",
                                                                                               "Randomize desync on enemy Miss"}),
    multiselect_antibfresetstates = menu_add_multi_selection("Anti-Aim", "Reset Anti Bruteforce data",
        {"Reset on round end", "Reset on death"}),

    selection_selection_states = menu_add_selection("Conditional", "Active State", sv.antiaim_states),

    -- invis shit
    slider_infopanel_posx = menu_add_slider("Info panel", "Position X", 0, 100000),
    slider_infopanel_posy = menu_add_slider("Info panel", "Position Y", 0, 100000)
}

-- make it have default values and be hidden from user
sv.items.slider_infopanel_posx:set(400)
sv.items.slider_infopanel_posy:set(400)
sv.items.slider_infopanel_posx:set_visible(false)
sv.items.slider_infopanel_posy:set_visible(false)

sv.colors = {
    -- anti_aim_arrows = {
    -- real_direction = sv.items.multiselect_anti_aim_arrows:add_color_picker("Real direction"),
    -- fake_direction = sv.items.multiselect_anti_aim_arrows:add_color_picker("Fake direction"),
    -- circle_outline = sv.items.multiselect_anti_aim_arrows:add_color_picker("Circle outline"),
    -- },
    -- indicator = {
    -- flags_color = sv.items.multiselect_flags:add_color_picker("Flags", color_t(255, 65, 65, 255))
    -- },
    -- Indicator color colorpicker
    default = {
        eclipsecolorpicker = sv.items.eclipsecolor:add_color_picker("Indicator", color_t(89, 159, 253, 255)),
        -- barcolor1 = sv.items.barcolor1:add_color_picker("Indicators", color_t(100, 90, 255, 255)),
        -- barcolor2 = sv.items.barcolor2:add_color_picker("Indicators", color_t(207, 194, 255, 255)),
        antiaimstatecolorpicker = sv.items.aastatecolor:add_color_picker("Indicator", color_t(95, 160, 255, 255))
        -- world_miss_marker_textcolor = sv.items.checkbox_world_miss_marker:add_color_picker("Extra Visuals", color_t(245, 145, 145, 255)),
        -- inactive_color = sv.items.multiselect_keybinds:add_color_picker("Indicator", color_t(100, 100, 100, 150)),
        -- dt_ind_color = items.checkbox_dt_ind_checkbox:add_color_picker("Indicator", color_t(30, 30, 30, 150)),
        -- hitlog_color = sv.items.checkbox_hitlogs_enable_checkbox:add_color_picker("Hitlogs", color_t(230, 170, 170, 255))
    }
}

-- keybinds
sv.keybinds = {{
    name = "FS", -- FREESTAND
    state = sv.aa_ref.freestand_ref[2]:get(), -- and multiselect_keybinds:get("Freestand")+
    last_state = false,
    selected = sv.items.multiselect_keybinds:get("Freestand"),
    activeonly = sv.items.checkbox_keybindsactiveonly:get(),
    alpha = 0,

    disable_time = 0,
    alpha_horiz = 0,
    cached_x = 0,
    x = 0
}, {
    name = "PS", -- PING
    state = sv.rb_ref.pingspikeenable[2]:get(),
    last_state = false,
    selected = sv.items.multiselect_keybinds:get("Ping spike"),
    activeonly = sv.items.checkbox_keybindsactiveonly:get(),
    alpha = 0,

    disable_time = 0,
    alpha_horiz = 0,
    cached_x = 0,
    x = 0
}, {
    name = "QP", -- PEEK
    state = sv.rb_ref.quickpeek_ref[2]:get(),
    last_state = false,
    selected = sv.items.multiselect_keybinds:get("Quick peek assist"),
    activeonly = sv.items.checkbox_keybindsactiveonly:get(),
    alpha = 0,

    disable_time = 0,
    alpha_horiz = 0,
    cached_x = 0,
    x = 0
}, {
    name = "RR", -- ROLL
    state = sv.rb_ref.roll_reso[2]:get(),
    last_state = false,
    selected = sv.items.multiselect_keybinds:get("Roll Resolver"),
    activeonly = sv.items.checkbox_keybindsactiveonly:get(),
    alpha = 0,

    disable_time = 0,
    alpha_horiz = 0,
    cached_x = 0,
    x = 0
}, {
    name = "HS", -- HIDE
    state = sv.rb_ref.hideshots[2]:get() and sv.rb_ref.doubletap[2]:get(),
    last_state = false,
    selected = sv.items.multiselect_keybinds:get("Hide Shots"),
    activeonly = sv.items.checkbox_keybindsactiveonly:get(),
    alpha = 0,

    disable_time = 0,
    alpha_horiz = 0,
    cached_x = 0,
    x = 0
}, -- {
-- name = "DT",
-- state = sv.rb_ref.doubletap[2]:get(),
-- last_state = false,
-- selected = sv.items.multiselect_keybinds:get("Double Tap"),
-- activeonly = sv.items.checkbox_keybindsactiveonly:get(),
-- alpha = 0,
-- disable_time = 0,
-- alpha_horiz = 0,
-- cached_x = 0,
-- x = 0,
-- },
{
    name = "FD",
    state = antiaim_is_fakeducking(),
    last_state = false,
    selected = sv.items.multiselect_keybinds:get("Fake Duck"),
    activeonly = sv.items.checkbox_keybindsactiveonly:get(),
    alpha = 0,

    disable_time = 0,
    alpha_horiz = 0,
    cached_x = 0,
    x = 0
}}

sv.horiz_indicators = {
    last_update_time = 0,
    start1 = 0
}

sv.weapons = { -- Define the weapon groups in a table to work with them below
    ["auto"] = 0,
    ["scout"] = 1,
    ["awp"] = 2,
    ["deagle"] = 3,
    ["revolver"] = 4,
    ["pistols"] = 5,
    ["other"] = 6
}

-- * Conditions
-- * condition calculation
local condition_calculation = {}
condition_calculation.landtime_aa = global_vars_cur_time()

-- remove watermark
function sv.callbacks.on_draw_watermark(watermark_text)
    return ""
end

sv.conditional_settings = {
    ["standing / global"] = {
        -- seperator = menu.add_separator("Conditional"),
        -- checkbox_enable_state = menu_add_checkbox("Conditional", "Enable Standing"),
        multiselect_aasettings = menu_add_multi_selection("Conditional", "[Standing] AntiAim Settings",
            {"Pitch", "Yaw base", "Yaw add", "Rotate", "Body lean"}),
        selection_pitch = menu_add_selection("Conditional", "[Standing] Pitch", {"None", "Down", "Up", "Zero", "jitter"}),
        selection_yawbase = menu_add_selection("Conditional", "[Standing] Yaw base", {"None", "Viewangle",
                                                                                      "At target (crosshair)",
                                                                                      "At target (distance)", "Velocity"}),
        slider_yawadd = menu_add_slider("Conditional", "[Standing] Yaw add", -180, 180),
        checkbox_rotate = menu_add_checkbox("Conditional", "[Standing] Enable rotate", false),
        slider_rotaterange = menu_add_slider("Conditional", "[Standing] Rotate range", 0, 360, "°"),
        slider_rotatespeed = menu_add_slider("Conditional", "[Standing] Rotate speed", 0, 100, "%"),
        selection_jittermode = menu_add_selection("Conditional", "[Standing] Jitter mode", {"None", "Static", "Random"}),
        selection_jittertype = menu_add_selection("Conditional", "[Standing] Jitter type", {"Offset", "Center"}),
        slider_jitteramount = menu_add_slider("Conditional", "[Standing] Jitter amount", -180, 180),
        selection_bodylean = menu_add_selection("Conditional", "[Standing] Body lean",
            {"None", "Static", "Static jitter", "Random jitter", "sway"}),
        slider_bodyleanvalue = menu_add_slider("Conditional", "[Standing] Body lean value", -50, 50),
        selection_desyncside = menu_add_selection("Conditional", "[Standing] Desync side", {"None", "Left", "Right",
                                                                                            "Jitter", "Peek fake",
                                                                                            "Peek real", "Body sway"}),
        slider_desyncl = menu_add_slider("Conditional", "[Standing] Desync left", 0, 100, "%"),
        slider_desyncr = menu_add_slider("Conditional", "[Standing] Desync right", 0, 100, "%"),
        selection_onshot = menu_add_selection("Conditional", "[Standing] On shot",
            {"Off", "Opposite side", "Same side", "Random"})
    },
    ["moving"] = {
        -- seperator = menu.add_text("Conditional", '---------------------------------------------------------------------------'),
        checkbox_enable_state = menu_add_checkbox("Conditional", "Enable Moving"),
        multiselect_aasettings = menu_add_multi_selection("Conditional", "[Moving] AntiAim Settings",
            {"Pitch", "Yaw base", "Yaw add", "Rotate", "Body lean"}),
        selection_pitch = menu_add_selection("Conditional", "[Moving] Pitch", {"None", "Down", "Up", "Zero", "jitter"}),
        selection_yawbase = menu_add_selection("Conditional", "[Moving] Yaw base", {"None", "Viewangle",
                                                                                    "At target (crosshair)",
                                                                                    "At target (distance)", "Velocity"}),
        slider_yawadd = menu_add_slider("Conditional", "[Moving] Yaw add", -180, 180),
        checkbox_rotate = menu_add_checkbox("Conditional", "[Moving] Enable rotate", false),
        slider_rotaterange = menu_add_slider("Conditional", "[Moving] Rotate range", 0, 360, "°"),
        slider_rotatespeed = menu_add_slider("Conditional", "[Moving] Rotate speed", 0, 100, "%"),
        selection_jittermode = menu_add_selection("Conditional", "[Moving] Jitter mode", {"None", "Static", "Random"}),
        selection_jittertype = menu_add_selection("Conditional", "[Moving] Jitter type", {"Offset", "Center"}),
        slider_jitteramount = menu_add_slider("Conditional", "[Moving] Jitter amount", -180, 180),
        selection_bodylean = menu_add_selection("Conditional", "[Moving] Body lean",
            {"None", "Static", "Static jitter", "Random jitter", "sway"}),
        slider_bodyleanvalue = menu_add_slider("Conditional", "[Moving] Body lean value", -50, 50),
        selection_desyncside = menu_add_selection("Conditional", "[Moving] Desync side", {"None", "Left", "Right",
                                                                                          "Jitter", "Peek fake",
                                                                                          "Peek real", "Body sway"}),
        slider_desyncl = menu_add_slider("Conditional", "[Moving] Desync left", 0, 100, "%"),
        slider_desyncr = menu_add_slider("Conditional", "[Moving] Desync right", 0, 100, "%"),
        selection_onshot = menu_add_selection("Conditional", "[Moving] On shot",
            {"Off", "Opposite side", "Same side", "Random"})
    },
    ["air"] = {
        -- seperator = menu.add_text("Conditional", '---------------------------------------------------------------------------'),
        checkbox_enable_state = menu_add_checkbox("Conditional", "Enable Air"),
        multiselect_aasettings = menu_add_multi_selection("Conditional", "[Air] AntiAim Settings",
            {"Pitch", "Yaw base", "Yaw add", "Rotate", "Body lean"}),
        selection_pitch = menu_add_selection("Conditional", "[Air] Pitch", {"None", "Down", "Up", "Zero", "jitter"}),
        selection_yawbase = menu_add_selection("Conditional", "[Air] Yaw base", {"None", "Viewangle",
                                                                                 "At target (crosshair)",
                                                                                 "At target (distance)", "Velocity"}),
        slider_yawadd = menu_add_slider("Conditional", "[Air] Yaw add", -180, 180),
        checkbox_rotate = menu_add_checkbox("Conditional", "[Air] Enable rotate", false),
        slider_rotaterange = menu_add_slider("Conditional", "[Air] Rotate range", 0, 360, "°"),
        slider_rotatespeed = menu_add_slider("Conditional", "[Air] Rotate speed", 0, 100, "%"),
        selection_jittermode = menu_add_selection("Conditional", "[Air] Jitter mode", {"None", "Static", "Random"}),
        selection_jittertype = menu_add_selection("Conditional", "[Air] Jitter type", {"Offset", "Center"}),
        slider_jitteramount = menu_add_slider("Conditional", "[Air] Jitter amount", -180, 180),
        selection_bodylean = menu_add_selection("Conditional", "[Air] Body lean",
            {"None", "Static", "Static jitter", "Random jitter", "sway"}),
        slider_bodyleanvalue = menu_add_slider("Conditional", "[Air] Body lean value", -50, 50),
        selection_desyncside = menu_add_selection("Conditional", "[Air] Desync side", {"None", "Left", "Right",
                                                                                       "Jitter", "Peek fake",
                                                                                       "Peek real", "Body sway"}),
        slider_desyncl = menu_add_slider("Conditional", "[Air] Desync left", 0, 100, "%"),
        slider_desyncr = menu_add_slider("Conditional", "[Air] Desync right", 0, 100, "%"),
        selection_onshot = menu_add_selection("Conditional", "[Air] On shot",
            {"Off", "Opposite side", "Same side", "Random"})
    },
    ["air duck"] = {
        -- seperator = menu.add_text("Conditional", '---------------------------------------------------------------------------'),
        checkbox_enable_state = menu_add_checkbox("Conditional", "Enable Air duck"),
        multiselect_aasettings = menu_add_multi_selection("Conditional", "[Air duck] AntiAim Settings",
            {"Pitch", "Yaw base", "Yaw add", "Rotate", "Body lean"}),
        selection_pitch = menu_add_selection("Conditional", "[Air duck] Pitch", {"None", "Down", "Up", "Zero", "jitter"}),
        selection_yawbase = menu_add_selection("Conditional", "[Air duck] Yaw base", {"None", "Viewangle",
                                                                                      "At target (crosshair)",
                                                                                      "At target (distance)", "Velocity"}),
        slider_yawadd = menu_add_slider("Conditional", "[Air duck] Yaw add", -180, 180),
        checkbox_rotate = menu_add_checkbox("Conditional", "[Air duck] Enable rotate", false),
        slider_rotaterange = menu_add_slider("Conditional", "[Air duck] Rotate range", 0, 360, "°"),
        slider_rotatespeed = menu_add_slider("Conditional", "[Air duck] Rotate speed", 0, 100, "%"),
        selection_jittermode = menu_add_selection("Conditional", "[Air duck] Jitter mode", {"None", "Static", "Random"}),
        selection_jittertype = menu_add_selection("Conditional", "[Air duck] Jitter type", {"Offset", "Center"}),
        slider_jitteramount = menu_add_slider("Conditional", "[Air duck] Jitter amount", -180, 180),
        selection_bodylean = menu_add_selection("Conditional", "[Air duck] Body lean",
            {"None", "Static", "Static jitter", "Random jitter", "sway"}),
        slider_bodyleanvalue = menu_add_slider("Conditional", "[Air duck] Body lean value", -50, 50),
        selection_desyncside = menu_add_selection("Conditional", "[Air duck] Desync side", {"None", "Left", "Right",
                                                                                            "Jitter", "Peek fake",
                                                                                            "Peek real", "Body sway"}),
        slider_desyncl = menu_add_slider("Conditional", "[Air duck] Desync left", 0, 100, "%"),
        slider_desyncr = menu_add_slider("Conditional", "[Air duck] Desync right", 0, 100, "%"),
        selection_onshot = menu_add_selection("Conditional", "[Air duck] On shot",
            {"Off", "Opposite side", "Same side", "Random"})
    },
    ["slowwalking"] = {
        -- seperator = menu.add_text("Conditional", '---------------------------------------------------------------------------'),
        checkbox_enable_state = menu_add_checkbox("Conditional", "Enable Slowwalk"),
        multiselect_aasettings = menu_add_multi_selection("Conditional", "[Slowwalking] AntiAim Settings",
            {"Pitch", "Yaw base", "Yaw add", "Rotate", "Body lean"}),
        selection_pitch = menu_add_selection("Conditional", "[Slowwalking] Pitch",
            {"None", "Down", "Up", "Zero", "jitter"}),
        selection_yawbase = menu_add_selection("Conditional", "[Slowwalking] Yaw base", {"None", "Viewangle",
                                                                                         "At target (crosshair)",
                                                                                         "At target (distance)",
                                                                                         "Velocity"}),
        slider_yawadd = menu_add_slider("Conditional", "[Slowwalking] Yaw add", -180, 180),
        checkbox_rotate = menu_add_checkbox("Conditional", "[Slowwalking] Enable rotate", false),
        slider_rotaterange = menu_add_slider("Conditional", "[Slowwalking] Rotate range", 0, 360, "°"),
        slider_rotatespeed = menu_add_slider("Conditional", "[Slowwalking] Rotate speed", 0, 100, "%"),
        selection_jittermode = menu_add_selection("Conditional", "[Slowwalking] Jitter mode",
            {"None", "Static", "Random"}),
        selection_jittertype = menu_add_selection("Conditional", "[Slowwalking] Jitter type", {"Offset", "Center"}),
        slider_jitteramount = menu_add_slider("Conditional", "[Slowwalking] Jitter amount", -180, 180),
        selection_bodylean = menu_add_selection("Conditional", "[Slowwalking] Body lean",
            {"None", "Static", "Static jitter", "Random jitter", "sway"}),
        slider_bodyleanvalue = menu_add_slider("Conditional", "[Slowwalking] Body lean value", -50, 50),
        selection_desyncside = menu_add_selection("Conditional", "[Slowwalking] Desync side", {"None", "Left", "Right",
                                                                                               "Jitter", "Peek fake",
                                                                                               "Peek real", "Body sway"}),
        slider_desyncl = menu_add_slider("Conditional", "[Slowwalking] Desync left", 0, 100, "%"),
        slider_desyncr = menu_add_slider("Conditional", "[Slowwalking] Desync right", 0, 100, "%"),
        selection_onshot = menu_add_selection("Conditional", "[Slowwalking] On shot",
            {"Off", "Opposite side", "Same side", "Random"})
    },
    ["ducking"] = {
        -- seperator = menu.add_text("Conditional", '---------------------------------------------------------------------------'),
        checkbox_enable_state = menu_add_checkbox("Conditional", "Enable Duck"),
        multiselect_aasettings = menu_add_multi_selection("Conditional", "[Ducking] AntiAim Settings",
            {"Pitch", "Yaw base", "Yaw add", "Rotate", "Body lean"}),
        selection_pitch = menu_add_selection("Conditional", "[Ducking] Pitch", {"None", "Down", "Up", "Zero", "jitter"}),
        selection_yawbase = menu_add_selection("Conditional", "[Ducking] Yaw base", {"None", "Viewangle",
                                                                                     "At target (crosshair)",
                                                                                     "At target (distance)", "Velocity"}),
        slider_yawadd = menu_add_slider("Conditional", "[Ducking] Yaw add", -180, 180),
        checkbox_rotate = menu_add_checkbox("Conditional", "[Ducking] Enable rotate", false),
        slider_rotaterange = menu_add_slider("Conditional", "[Ducking] Rotate range", 0, 360, "°"),
        slider_rotatespeed = menu_add_slider("Conditional", "[Ducking] Rotate speed", 0, 100, "%"),
        selection_jittermode = menu_add_selection("Conditional", "[Ducking] Jitter mode", {"None", "Static", "Random"}),
        selection_jittertype = menu_add_selection("Conditional", "[Ducking] Jitter type", {"Offset", "Center"}),
        slider_jitteramount = menu_add_slider("Conditional", "[Ducking] Jitter amount", -180, 180),
        selection_bodylean = menu_add_selection("Conditional", "[Ducking] Body lean",
            {"None", "Static", "Static jitter", "Random jitter", "sway"}),
        slider_bodyleanvalue = menu_add_slider("Conditional", "[Ducking] Body lean value", -50, 50),
        selection_desyncside = menu_add_selection("Conditional", "[Ducking] Desync side", {"None", "Left", "Right",
                                                                                           "Jitter", "Peek fake",
                                                                                           "Peek real", "Body sway"}),
        slider_desyncl = menu_add_slider("Conditional", "[Ducking] Desync left", 0, 100, "%"),
        slider_desyncr = menu_add_slider("Conditional", "[Ducking] Desync right", 0, 100, "%"),
        selection_onshot = menu_add_selection("Conditional", "[Ducking] On shot",
            {"Off", "Opposite side", "Same side", "Random"})
    }
}

-- * Main script
local desync_value = 58

sv.fn.aa_logger = {}
sv.fn.aa_logger.fn = {}
sv.fn.aa_logger.player_list = {}
sv.fn.aa_logger.font = render_get_default_font()
sv.fn.aa_logger.vars = {}

sv.fn.aa_logger.fn.remove_player = function(user_id)
    local user_id_str = tostring(user_id)
    sv.fn.aa_logger.player_list[user_id_str] = nil
end

sv.fn.aa_logger.fn.add_player = function(user_id)
    local user_id_str = tostring(user_id)
    sv.fn.aa_logger.player_list[user_id_str] = {
        name = entity_list_get_entity(user_id):get_name(),

        last_shot = 0,

        shots = {
            hit = 0,
            miss = 0
        },

        confirmation_dmg = false,

        bruteforce_data = {
            invert_hit = false,
            invert_miss = false,
            randomize_miss = false,
            randomize_hit = false,
            randomized_miss_desync = 0,
            randomized_hit_desync = 0
        }
    }
end

sv.fn.aa_logger.fn.handle_playerlist = function(lp)
    if lp then
        for user_id_str, _ in pairs(sv.fn.aa_logger.player_list) do
            local user_id = tonumber(user_id_str)
            local entity = entity_list_get_entity(user_id)

            if entity == nil then
                client_log_screen('Removing player ', user_id_str)
                sv.fn.aa_logger.fn.remove_player(user_id)
            end
        end
    end
end

sv.fn.aa_logger.fn.reset_player_stats = function(user_id)
    local user_id_str = tostring(user_id)
    sv.fn.aa_logger.player_list[user_id_str].shots.hit = 0
    sv.fn.aa_logger.player_list[user_id_str].shots.miss = 0
end

sv.fn.aa_logger.fn.populate_playerlist = function()
    local players = entity_list_get_players()
    for i = 1, #players do
        local player = players[i]
        local user_id = player:get_index()
        local user_id_str = tostring(user_id)

        -- dont re-add player if he already exists
        if sv.fn.aa_logger.player_list[user_id_str] == nil then
            client_log_screen('Adding player ', user_id_str)
            sv.fn.aa_logger.fn.add_player(user_id)
        end
    end
end

sv.fn.aa_logger.fn.render_playerlist = function()
    -- if not sv.items.checkbox_antibfenable:get( ) then return end

    if not engine_is_connected() then
        sv.fn.aa_logger.player_list = {}
        return
    end

    local enemies = entity_list_get_players(true)

    if not enemies then
        return
    end

    for index, enemy in pairs(enemies) do
        local enemy_userid = enemy:get_index()
        local enemy_userid_str = tostring(enemy_userid)
        if not sv.fn.aa_logger.player_list[enemy_userid_str] then
            client_log_screen('Adding player ' .. enemy_userid_str .. ' to list')
            sv.fn.aa_logger.fn.add_player(enemy_userid)
        end

        local enemy_info = sv.fn.aa_logger.player_list[enemy_userid_str]

        local cur_target_shots = sv.fn.aa_logger.player_list[tostring(enemy:get_index())].shots.hit +
                                     sv.fn.aa_logger.player_list[tostring(enemy:get_index())].shots.miss
        local cur_target_hits = sv.fn.aa_logger.player_list[tostring(enemy:get_index())].shots.hit

        local iBruteforce_state = (cur_target_shots % cur_target_hits) + 1

        local text = string.format('%s\'s shots: %s/%s (%.0f%%)', enemy:get_name(), enemy_info.shots.hit,
            enemy_info.shots.hit + enemy_info.shots.miss,
            tostring(enemy_info.shots.hit / (enemy_info.shots.hit + enemy_info.shots.miss) * 100) == 'nan' and 0 or
                enemy_info.shots.hit / (enemy_info.shots.hit + enemy_info.shots.miss) * 100)
        render_text(sv.fn.aa_logger.font, text, vec2_t(300, 400 + (index - 1) * 12), color_t(255, 255, 255, 255))
    end
end

sv.fn.aa_logger.create_ray = function(s, e)
    local ray = {}

    ray.orig = s
    ray.dir = vec3_t.new(e.x - s.x, e.y - s.y, e.z - s.z)

    local length = ray.dir:length()

    ray.dir.x = ray.dir.x / length
    ray.dir.y = ray.dir.y / length
    ray.dir.z = ray.dir.z / length

    return ray
end

sv.fn.aa_logger.create_box = function(min, max)
    local box = {}
    box.min = min
    box.max = max

    return box
end

sv.fn.aa_logger.intersect = function(ray, box)
    local min = box.min
    local max = box.max

    local tmin = (min.x - ray.orig.x) / ray.dir.x;
    local tmax = (max.x - ray.orig.x) / ray.dir.x;

    if (tmin > tmax) then
        local temp = tmin
        tmin = tmax
        tmax = temp
    end

    local tymin = (min.y - ray.orig.y) / ray.dir.y;
    local tymax = (max.y - ray.orig.y) / ray.dir.y;

    if (tymin > tymax) then
        local temp = tymin
        tymin = tymax
        tymax = temp
    end

    if (tmin > tymax) or (tymin > tmax) then
        return false
    end

    if (tymin > tmin) then
        tmin = tymin
    end

    if (tymax < tmax) then
        tmax = tymax
    end

    local tzmin = (min.z - ray.orig.z) / ray.dir.z;
    local tzmax = (max.z - ray.orig.z) / ray.dir.z;

    if (tzmin > tzmax) then
        local temp = tzmin
        tzmin = tzmax
        tzmax = temp
    end

    if (tmin > tzmax) or (tzmin > tmax) then
        return false
    end

    if (tzmin > tmin) then
        tmin = tzmin
    end

    if (tzmax < tmax) then
        tmax = tzmax
    end

    return true
end

sv.fn.aa_logger.backtrack_poses = {}

-- populate backtrack poses by 28 ticks
for i = 1, 28 do
    sv.fn.aa_logger.backtrack_poses[i] = vec3_t.new(0, 0, 0)
end

sv.fn.aa_logger.update_stored_bt_pos = function()
    local lp = entity_list_get_local_player()

    if not lp or not lp:is_valid() or not lp:is_alive() then
        return
    end

    local lp_pos = lp:get_render_origin()
    sv.fn.aa_logger.backtrack_poses[1] = lp_pos

    for i = 28, 2, -1 do
        sv.fn.aa_logger.backtrack_poses[i] = sv.fn.aa_logger.backtrack_poses[i - 1]
    end

end

sv.fn.aa_logger.debug_backtrack = function()
    local lp = entity_list_get_local_player()

    if not lp or not lp:is_valid() or not lp:is_alive() then
        return
    end

    local box_min, box_max = lp:get_bounds()

    -- create all 8 bounding box points
    local points = {vec3_t.new(box_min.x, box_min.y, box_min.z), vec3_t.new(box_min.x, box_min.y, box_max.z),
                    vec3_t.new(box_min.x, box_max.y, box_min.z), vec3_t.new(box_min.x, box_max.y, box_max.z),
                    vec3_t.new(box_max.x, box_min.y, box_min.z), vec3_t.new(box_max.x, box_min.y, box_max.z),
                    vec3_t.new(box_max.x, box_max.y, box_min.z), vec3_t.new(box_max.x, box_max.y, box_max.z)}

    for _, lp_origin in pairs(sv.fn.aa_logger.backtrack_poses) do
        local screen_points = {}
        for i = 1, #points do
            local screen_point = render.world_to_screen(lp_origin + points[i])
            if screen_point ~= nil then
                table.insert(screen_points, screen_point)
            end
        end

        -- draw all 12 lines
        local lines = {{1, 2}, {1, 3}, {1, 5}, {2, 4}, {2, 6}, {3, 4}, {3, 7}, {4, 8}, {5, 6}, {5, 7}, {6, 8}, {7, 8}}

        for i = 1, #lines do
            local line = lines[i]
            local p1 = screen_points[line[1]]
            local p2 = screen_points[line[2]]
            if p1 and p2 then
                render_line(p1, p2, color_t.new(255, 255, 255, 255))
            end
        end
    end
end

sv.fn.aa_logger.on_event = function(event)
    if event.name == 'bullet_impact' then
        if not sv.items.checkbox_antibfenable:get() then
            return
        end

        local shooter_id = event.userid
        local shooter = entity_list_get_player_from_userid(shooter_id)
        if shooter == nil then
            return
        end

        if not shooter:is_player() or not shooter:is_enemy() then
            return
        end

        local shooter_idx = shooter:get_index()
        local shooter_idx_str = tostring(shooter_idx)

        local lp = entity_list_get_local_player()

        if not lp or not lp:is_valid() or not lp:is_alive() then
            return
        end

        for idx, lp_origin in pairs(sv.fn.aa_logger.backtrack_poses) do
            local box_min, box_max = lp:get_bounds()

            -- logic to check if the shot was inside player bounding box
            local impact = vec3_t.new(event.x, event.y, event.z)
            local ray = sv.fn.aa_logger.create_ray(shooter:get_eye_position(), impact)

            local length_players = ray.orig:dist(lp_origin)
            local length_forward_lp = (ray.orig + ray.dir):dist(lp_origin)

            if length_forward_lp > length_players then
                return
            end

            local length_impact = ray.orig:dist(impact) + 20
            if length_impact < length_players then
                return
            end

            local box = sv.fn.aa_logger.create_box(lp_origin + box_min, lp_origin + box_max)

            local intersect = sv.fn.aa_logger.intersect(ray, box)

            if intersect ~= false then
                local time = global_vars_tick_count()

                if not sv.fn.aa_logger.player_list[shooter_idx_str] then
                    sv.fn.aa_logger.fn.add_player(shooter_idx);
                    sv.fn.aa_logger.player_list[shooter_idx_str].last_shot = time
                end
                local t_enm_data = sv.fn.aa_logger.player_list[shooter_idx_str]

                if t_enm_data.last_shot == time then
                    return
                end

                -- if player hurt didnt fire
                -- t_enm_data.confirmation_dmg = impact:dist( lp_origin ) < ( lp_origin + box_min ):dist( lp_origin )

                -- client_log_screen( shooter_idx, 'intersect > ghetto hurt: ', impact:dist( lp_origin ) < ( lp_origin + box_min ):dist( lp_origin ) )

                client_delay_call(function()
                    local damaged_player = t_enm_data.confirmation_dmg

                    local bt_start = math.clamp(idx - 1, 0, 28)
                    local bt_end = math.clamp(idx + 1, 0, 28)

                    if t_enm_data.confirmation_dmg then -- if we got hit
                        t_enm_data.shots.hit = t_enm_data.shots.hit + 1

                        sv.fn.aa_logger.vars.last_hit = time

                        t_enm_data.bruteforce_data.invert_hit = not t_enm_data.bruteforce_data.invert_hit
                        t_enm_data.bruteforce_data.randomize_hit = not t_enm_data.bruteforce_data.randomize
                        t_enm_data.bruteforce_data.randomized_hit_desync = client_random_float(0, 1)

                        t_enm_data.bruteforce_data.invert_miss = false
                        t_enm_data.bruteforce_data.randomize_miss = false

                        client_log_screen('AntiAim System |',
                            ('Hit by %s | hits/total: %s/%s (%.2f%%) | bt: %i-%i'):format(t_enm_data.name,
                                t_enm_data.shots.hit, t_enm_data.shots.miss + t_enm_data.shots.hit,
                                t_enm_data.shots.hit / (t_enm_data.shots.hit + t_enm_data.shots.miss) * 100, bt_start,
                                bt_end))

                    else
                        t_enm_data.shots.miss = t_enm_data.shots.miss + 1

                        sv.fn.aa_logger.vars.last_miss = time

                        t_enm_data.bruteforce_data.invert_miss = not t_enm_data.bruteforce_data.invert_miss
                        t_enm_data.bruteforce_data.randomize_miss = not t_enm_data.bruteforce_data.randomize
                        t_enm_data.bruteforce_data.randomized_miss_desync = client_random_float(0, 1)

                        t_enm_data.bruteforce_data.invert_hit = false
                        t_enm_data.bruteforce_data.randomize_hit = false

                        client_log_screen('AntiAim System |',
                            ('Missed by %s | hits/total: %s/%s (%.2f%%) | bt: %i-%i'):format(t_enm_data.name,
                                t_enm_data.shots.hit, t_enm_data.shots.miss + t_enm_data.shots.hit,
                                t_enm_data.shots.hit / (t_enm_data.shots.hit + t_enm_data.shots.miss) * 100, bt_start,
                                bt_end))
                    end

                    -- client_log_screen( shooter_idx, 'shot' )

                    t_enm_data.confirmation_dmg = false
                end, 0.2)

                t_enm_data.last_shot = time

                break
            end
        end
    elseif event.name == 'player_hurt' then
        local shooter_id = event.attacker
        local shooter = entity_list_get_player_from_userid(shooter_id)

        if shooter == nil or not shooter:is_player() or not shooter:is_enemy() then
            return
        end

        local lp = entity_list_get_local_player()

        if not lp or not lp:is_valid() or not lp:is_player() then
            return
        end

        local hit_user_id = event.userid
        local hit_player = entity_list_get_player_from_userid(hit_user_id)

        if not hit_player or not hit_player:is_valid() or not hit_player:is_player() then
            return
        end
        if not hit_player:get_index() == lp:get_index() then
            return
        end

        local user_idx = shooter:get_index()
        local user_idx_str = tostring(user_idx)

        if not sv.fn.aa_logger.player_list[user_idx_str] then
            sv.fn.aa_logger.fn.add_player(user_idx)
        end
        local t_enm_data = sv.fn.aa_logger.player_list[user_idx_str]

        t_enm_data.confirmation_dmg = true

        client_delay_call(function()
            t_enm_data.confirmation_dmg = false
        end, 0.5)
    elseif event.name == 'round_start' then -- and sv.items.multiselect_anti_bruteforce_reset_states:get( 'on round end' )
        if sv.items.multiselect_antibfresetstates:get(1) then
            for enemy_idx_str, _ in pairs(sv.fn.aa_logger.player_list) do
                sv.fn.aa_logger.fn.reset_player_stats(enemy_idx_str)
            end
            client_log_screen('AntiAim System | ', 'Reset all player stats (' .. event.name .. ')')
        end
    elseif event.name == 'player_death' then
        local player_id_who_died = event.userid
        local lp = entity_list_get_local_player()

        if lp == nil then
            return
        end

        local died_plr = entity_list_get_player_from_userid(player_id_who_died)

        if died_plr == nil or not died_plr:is_enemy() or not died_plr:is_enemy() then
            return
        end

        local enm_idx = died_plr:get_index()

        if lp:get_index() == enm_idx then
            local time = global_vars_tick_count()

            if not sv.fn.aa_logger.player_list[tostring(enm_idx)] then
                sv.fn.aa_logger.fn.add_player(enm_idx)
            end

            local t_enm_data = sv.fn.aa_logger.player_list[tostring(enm_idx)]

            t_enm_data.shots.hit = t_enm_data.shots.hit + 1

            sv.fn.aa_logger.vars.last_hit = time

            t_enm_data.bruteforce_data.invert_hit = not t_enm_data.bruteforce_data.invert_hit
            t_enm_data.bruteforce_data.randomize_hit = not t_enm_data.bruteforce_data.randomize
            t_enm_data.bruteforce_data.randomized_hit_desync = client_random_float(0, 1)

            t_enm_data.bruteforce_data.invert_miss = false
            t_enm_data.bruteforce_data.randomize_miss = false

            client_log_screen('AntiAim System |',
                ('Killled by %s | hits/total: %s/%s (%.2f%%)'):format(t_enm_data.name, t_enm_data.shots.hit,
                    t_enm_data.shots.miss + t_enm_data.shots.hit, t_enm_data.shots.hit /
                        (t_enm_data.shots.hit + t_enm_data.shots.miss) * 100))

            if sv.items.multiselect_antibfresetstates:get(2) then
                for enemy_idx_str, _ in pairs(sv.fn.aa_logger.player_list) do
                    sv.fn.aa_logger.fn.reset_player_stats(enemy_idx_str)
                end
                client_log_screen('AntiAim System | ', 'Reset all player stats (' .. event.name .. ')')
            end
        end
    end
end

sv.fn.debug = {}
sv.fn.debug.lines = {}
sv.fn.debug.draw_line_3d = function(vec3_t_pos_start, vec3_t_pos_end, color)
    local screen_pos_start = render_world_to_screen(vec3_t_pos_start)
    local screen_pos_end = render_world_to_screen(vec3_t_pos_end)
    if not screen_pos_start or not screen_pos_end then
        return
    end

    table.insert(sv.fn.debug.lines, 1, {
        s = screen_pos_start,
        e = screen_pos_end,
        c = color,
        t = global_vars_cur_time()
    })
end

sv.fn.debug.handle_lines = function()
    for i = 1, #sv.fn.debug.lines do
        local line = sv.fn.debug.lines[i]

        if line then
            render_line(line.s, line.e, line.c)
        end
    end
    for i = 1, #sv.fn.debug.lines do
        local line = sv.fn.debug.lines[i]
        if line then
            if line.t + (1 / client_get_fps() * 10) < global_vars_cur_time() then
                sv.fn.debug.lines[i] = nil
            end
        end
    end
end

sv.vars = {}
sv.vars.menu_cache = {}

sv.fn.menu_hide_all = function()
    for _, elem in pairs(sv.items) do
        elem:set_visible(false)
    end

    for _, table in pairs(sv.conditional_settings) do
        for _, elem in pairs(table) do
            elem:set_visible(false)
        end
    end

    sv.items.multiselect_enablesections:set_visible(true)
end

sv.fn.handle_conditional_menu = function(bGlobally_enabled, current_tab)
    local current_items = sv.conditional_settings[current_tab]

    local bPitch = current_items.multiselect_aasettings:get('Pitch')
    local bYawbase = current_items.multiselect_aasettings:get('Yaw base')
    local bYawadd = current_items.multiselect_aasettings:get('Yaw add')
    local bRotate = current_items.multiselect_aasettings:get('Rotate')
    local bBodylean = current_items.multiselect_aasettings:get('Body lean')

    current_items.selection_pitch:set_visible(bGlobally_enabled and bPitch)
    current_items.selection_yawbase:set_visible(bGlobally_enabled and bYawbase)
    current_items.slider_yawadd:set_visible(bGlobally_enabled and bYawadd)
    current_items.checkbox_rotate:set_visible(bGlobally_enabled and bRotate)
    current_items.slider_rotaterange:set_visible(bGlobally_enabled and bRotate)
    current_items.slider_rotatespeed:set_visible(bGlobally_enabled and bRotate)
    current_items.selection_bodylean:set_visible(bGlobally_enabled and bBodylean)
    current_items.slider_bodyleanvalue:set_visible(bGlobally_enabled and bBodylean)
end

sv.vars.conditional_checks = {'Pitch', 'Yaw base', 'Yaw add', 'Rotate', 'Jitter', 'Body lean'}

sv.vars.menu_check_conditional_table = {}
for key, table in pairs(sv.conditional_settings) do
    sv.vars.menu_check_conditional_table[key] = {}
    local element = table.multiselect_aasettings

    for _, check in pairs(sv.vars.conditional_checks) do
        sv.vars.menu_check_conditional_table[key][check] = element:get(check)
    end
end

sv.fn.handle_menu = function()
    if not sv.vars.menu_cache['multiselect_enablesections'] then
        sv.vars.menu_cache['multiselect_enablesections'] = {}
    end
    if not sv.vars.menu_cache['2018_anims'] then
        sv.vars.menu_cache['2018_anims'] = {}
    end
    if not sv.vars.menu_cache['force_sp_after_X_misses'] then
        sv.vars.menu_cache['force_sp_after_X_misses'] = {}
    end
    if not sv.vars.menu_cache['info_panel'] then
        sv.vars.menu_cache['info_panel'] = {}
    end
    if not sv.vars.menu_cache['hitlogs'] then
        sv.vars.menu_cache['hitlogs'] = {}
    end
    if not sv.vars.menu_cache['anti_bf'] then
        sv.vars.menu_cache['anti_bf'] = {}
    end

    local bCrosshair_visual = sv.items.multiselect_enablesections:get('Crosshair indicators')
    if not sv.vars.menu_cache['multiselect_enablesections']['crosshair_indicators'] then
        sv.vars.menu_cache['multiselect_enablesections']['crosshair_indicators'] = not bCrosshair_visual
    end
    if sv.vars.menu_cache['multiselect_enablesections']['crosshair_indicators'] ~= bCrosshair_visual then

        sv.items.multiselect_keybinds:set_visible(bCrosshair_visual)
        sv.items.checkbox_enable_scope_in_animation:set_visible(bCrosshair_visual)
        sv.items.checkbox_keybindsactiveonly:set_visible(bCrosshair_visual)
        sv.items.aastatecolor:set_visible(bCrosshair_visual)
        sv.items.eclipsecolor:set_visible(bCrosshair_visual)

        sv.vars.menu_cache['multiselect_enablesections']['crosshair_indicators'] = bCrosshair_visual
    end

    local bVisual = sv.items.multiselect_enablesections:get('Visuals')
    local bHitlogs = sv.items.checkbox_hitlogs_enable_checkbox:get()
    local bInfoPanel = sv.items.checkbox_enable_infopanel:get()
    local b2018anims = sv.items.checkbox_2018_anims_enable:get()
    local force_sp_after_x_misses = sv.items.checkbox_force_sp_after_X_shots:get()
    if not sv.vars.menu_cache['multiselect_enablesections']['visuals'] then
        sv.vars.menu_cache['multiselect_enablesections']['visuals'] = not bVisual
    end
    if not sv.vars.menu_cache['2018_anims']['enabled'] then
        sv.vars.menu_cache['2018_anims']['enabled'] = not b2018anims
    end
    if not sv.vars.menu_cache['force_sp_after_X_misses']['enabled'] then
        sv.vars.menu_cache['force_sp_after_X_misses']['enabled'] = not force_sp_after_x_misses
    end
    if not sv.vars.menu_cache['info_panel']['enabled'] then
        sv.vars.menu_cache['info_panel']['enabled'] = not bInfoPanel
    end
    if not sv.vars.menu_cache['hitlogs']['enabled'] then
        sv.vars.menu_cache['hitlogs']['enabled'] = not bHitlogs
    end

    if sv.vars.menu_cache['multiselect_enablesections']['visuals'] ~= bVisual or
        sv.vars.menu_cache['hitlogs']['enabled'] ~= bHitlogs or sv.vars.menu_cache['2018_anims']['enabled'] ~=
        b2018anims or sv.vars.menu_cache['info_panel']['enabled'] ~= bInfoPanel then

        sv.items.checkbox_hitlogs_enable_checkbox:set_visible(bVisual)
        sv.items.slider_hitlogs_pos_y:set_visible(bVisual and bHitlogs)
        sv.items.checkbox_enable_infopanel:set_visible(bVisual)
        -- sv.items.checkbox_enable_keybinds:set_visible( bVisual )
        sv.items.checkbox_2018_anims_enable:set_visible(bVisual)
        sv.items.multiselect_2018_anims_options:set_visible(bVisual and b2018anims)

        sv.vars.menu_cache['multiselect_enablesections']['visuals'] = bVisual
        sv.vars.menu_cache['hitlogs']['enabled'] = bHitlogs
        sv.vars.menu_cache['2018_anims']['enabled'] = b2018anims
        sv.vars.menu_cache['info_panel']['enabled'] = bInfoPanel
    end

    local bMisc = sv.items.multiselect_enablesections:get('Misc')
    if not sv.vars.menu_cache['multiselect_enablesections']['misc'] then
        sv.vars.menu_cache['multiselect_enablesections']['misc'] = not bMisc
    end
    if sv.vars.menu_cache['multiselect_enablesections']['misc'] ~= bMisc or
        sv.vars.menu_cache['force_sp_after_X_misses']['misc'] ~= force_sp_after_x_misses then
        sv.items.checkbox_clantag_enable:set_visible(bMisc)
        sv.items.checkbox_deagle_nospread_stuff:set_visible(bMisc)
        sv.items.checkbox_force_sp_after_X_shots:set_visible(bMisc)
        -- sv.items.multiselect_safepoint_hitboxes:set_visible( bMisc )
        sv.items.slider_reset_after_X_seconds:set_visible(bMisc and force_sp_after_x_misses)
        sv.items.slider_enable_after_X_misses:set_visible(bMisc and force_sp_after_x_misses)

        sv.vars.menu_cache['multiselect_enablesections']['misc'] = bMisc
    end

    local bAntiaim = sv.items.multiselect_enablesections:get('Anti-Aim')
    if not sv.vars.menu_cache['multiselect_enablesections']['antiaim'] then
        sv.vars.menu_cache['multiselect_enablesections']['antiaim'] = not bAntiaim
    end

    local bAntiaim_master_switch = sv.items.checkbox_aaenable:get()
    if not sv.vars.menu_cache['multiselect_enablesections']['antiaim_master_switch'] then
        sv.vars.menu_cache['multiselect_enablesections']['antiaim_master_switch'] = not bAntiaim_master_switch
    end

    local bConditional_antiaim = sv.items.selection_AntiAim_modes:get() == 2
    if not sv.vars.menu_cache['multiselect_enablesections']['conditional_antiaim'] then
        sv.vars.menu_cache['multiselect_enablesections']['conditional_antiaim'] = not bConditional_antiaim
    end

    local sCurrent_condition = sv.items.selection_selection_states:get_item_name(
        sv.items.selection_selection_states:get())
    if not sv.vars.menu_cache['multiselect_enablesections']['current_condition'] then
        sv.vars.menu_cache['multiselect_enablesections']['current_condition'] = not sCurrent_condition
    end

    local bAntibf_enabled = sv.items.checkbox_antibfenable:get()
    if not sv.vars.menu_cache['anti_bf']['global_enable'] then
        sv.vars.menu_cache['anti_bf']['global_enable'] = not bAntibf_enabled
    end

    local bCustomized_antibf = sv.items.selection_antibfmode:get() == 2
    if not sv.vars.menu_cache['anti_bf']['customized'] then
        sv.vars.menu_cache['anti_bf']['customized'] = not bCustomized_antibf
    end

    if sv.vars.menu_cache['multiselect_enablesections']['antiaim'] ~= bAntiaim or
        sv.vars.menu_cache['multiselect_enablesections']['antiaim_master_switch'] ~= bAntiaim_master_switch or
        sv.vars.menu_cache['multiselect_enablesections']['conditional_antiaim'] ~= bConditional_antiaim or
        sv.vars.menu_cache['multiselect_enablesections']['current_condition'] ~= sCurrent_condition or
        sv.vars.menu_cache['anti_bf']['global_enable'] ~= bAntibf_enabled or sv.vars.menu_cache['anti_bf']['customized'] ~=
        bCustomized_antibf then
        sv.items.checkbox_aaenable:set_visible(bAntiaim)
        sv.items.checkbox_edge_yaw_enable:set_visible(bAntiaim and bAntiaim_master_switch)
        sv.items.selection_antiaim_target_selection_mode:set_visible(
            bAntiaim and bAntiaim_master_switch and not bConditional_antiaim)
        sv.items.selection_AntiAim_modes:set_visible(bAntiaim and bAntiaim_master_switch)
        sv.items.checkbox_antibfenable:set_visible(bAntiaim and bAntiaim_master_switch)

        sv.items.selection_selection_states:set_visible(bConditional_antiaim and bAntiaim_master_switch and bAntiaim)

        for _, table in pairs(sv.conditional_settings) do
            for _, elem in pairs(table) do
                elem:set_visible(bConditional_antiaim and bAntiaim_master_switch and bAntiaim)
            end
        end

        -- conditional menu element visibility
        for key, table in pairs(sv.conditional_settings) do
            for _, elem in pairs(table) do
                elem:set_visible(bConditional_antiaim and bAntiaim_master_switch and bAntiaim and key ==
                                     sCurrent_condition)
            end

            sv.fn.handle_conditional_menu(bConditional_antiaim and bAntiaim_master_switch and bAntiaim,
                sCurrent_condition)
        end

        sv.items.checkbox_antibfenable:set_visible(bAntiaim and bAntiaim_master_switch and bConditional_antiaim)
        sv.items.selection_antibfmode:set_visible(bAntiaim and bAntiaim_master_switch and bConditional_antiaim and
                                                      bAntibf_enabled)
        sv.items.multiselect_antibfresetstates:set_visible(
            bAntiaim and bAntiaim_master_switch and bConditional_antiaim and bAntibf_enabled and bCustomized_antibf)
        sv.items.multiselect_antibfextras:set_visible(bAntiaim and bAntiaim_master_switch and bConditional_antiaim and
                                                          bAntibf_enabled and bCustomized_antibf)

        sv.vars.menu_cache['multiselect_enablesections']['antiaim'] = bAntiaim
        sv.vars.menu_cache['multiselect_enablesections']['antiaim_master_switch'] = bAntiaim_master_switch
        sv.vars.menu_cache['multiselect_enablesections']['conditional_antiaim'] = bConditional_antiaim
        sv.vars.menu_cache['multiselect_enablesections']['current_condition'] = sCurrent_condition
        sv.vars.menu_cache['anti_bf']['global_enable'] = bAntibf_enabled
        sv.vars.menu_cache['anti_bf']['customized'] = bCustomized_antibf
    end

    -- conditional visibility
    for key, table in pairs(sv.conditional_settings) do
        local element = table.multiselect_aasettings
        for i, check in pairs(sv.vars.conditional_checks) do
            if sv.vars.menu_check_conditional_table[key][check] ~= element:get(check) then
                sv.fn.handle_conditional_menu(bConditional_antiaim and bAntiaim_master_switch and bAntiaim, key)

                sv.vars.menu_check_conditional_table[key][check] = element:get(check)
            end
        end
    end
end

sv.fn.menu_hide_all()

sv.current_condition = "STANDING"

sv.fn.on_paint = {}
sv.vars.on_paint = {}

sv.fn.on_aimbot_hit = {}
sv.fn.on_aimbot_miss = {}

-- *Hitlogs
sv.vars.hitlogs = {}
sv.vars.hitlogs.font = render_get_default_font()
-- {type: hit/miss, time: time, player: player_t, damage_dealt: number, damage_predicted: number, hitbox: e_hitbox}
sv.vars.hitlogs.logs = {}
sv.vars.hitlogs.accent_color = color_t(230, 170, 170, 255)
sv.vars.hitlogs.neutral_color = color_t(230, 230, 230, 255)
sv.vars.hitlogs.background_color = color_t(0, 0, 0, 100)

sv.fn.on_aimbot_hit.add_hitlog = function(ctx)
    sv.vars.hitlogs.logs[#sv.vars.hitlogs.logs + 1] = {
        type = "hit",
        pos = vec2_t(0, 0),
        cached_pos = vec2_t(0, 0),
        opacity = 0,
        time = global_vars_real_time(),
        player = ctx.player:get_name(),
        damage_dealt = ctx.damage,
        damage_predicted = ctx.aim_damage,
        hitbox = client_get_hitgroup_name(ctx.hitgroup)
    }
end

sv.fn.on_aimbot_miss.add_hitlog = function(ctx)
    sv.vars.hitlogs.logs[#sv.vars.hitlogs.logs + 1] = {
        type = "miss",
        pos = vec2_t(0, 0),
        cached_pos = vec2_t(0, 0),
        opacity = 0,
        time = global_vars_real_time(),
        reason = ctx.reason_string,
        player = ctx.player ~= nil and ctx.player:get_name() or "unnamed",
        safepoint = ctx.aim_safepoint,
        damage_predicted = ctx.aim_damage,
        hitbox = client_get_hitgroup_name(ctx.aim_hitgroup)
    }
end

sv.fn.on_paint.hitlogs = function()
    if not sv.items.multiselect_enablesections:get('Visuals') or not sv.items.checkbox_hitlogs_enable_checkbox:get() then
        return
    end

    for i, log in pairs(sv.vars.hitlogs.logs) do
        local string_

        if log.type == 'hit' then
            string_ = string.format('[eclipse] Hit %s in %s for %i (%i)', log.player, log.hitbox, log.damage_dealt,
                log.damage_predicted)
        else
            string_ = string.format('[eclipse] Missed (%s) %s in %s for %i (safe: %s)', log.reason, log.player,
                log.hitbox, log.damage_predicted, log.safepoint)
        end

        log.pos.y = (i - 1) * 22 + sv.items.slider_hitlogs_pos_y:get()
        local orig_offset = vec2_t(render_get_screen_size().x / 2, render_get_screen_size().y / 2 + 100)
        orig_offset = orig_offset - vec2_t(render_get_text_size(sv.vars.hitlogs.font, string_).x / 2, 0)

        if global_vars_real_time() - log.time <= 0.1 then
            log.pos.x = -render_get_text_size(sv.vars.hitlogs.font, string_).x
            log.cached_pos.y = log.pos.y
        elseif global_vars_real_time() - log.time <= 1 then
            log.pos.x = lerp(log.pos.x, 5, 0.1)
            log.opacity = lerp(log.opacity, 255, 0.1)
        elseif global_vars_real_time() - log.time >= 3 then
            log.pos.x = lerp(log.pos.x, -render_get_text_size(sv.vars.hitlogs.font, string_).x - 5, 0.1)
            log.opacity = lerp(log.opacity, 0, 0.1)
        end

        if log.cached_pos.y ~= log.pos.y then
            log.cached_pos.y = lerp(log.cached_pos.y, log.pos.y, 0.1)
        end

        log.cached_pos.x = log.pos.x

        -- render a background for the text
        -- render colored name, hitbox and damage
        local offset = 0
        local height = 0

        local accent_color = sv.render_utility.accent_color:get()
        local color_accent = color_t(accent_color.r, accent_color.g, accent_color.b, math.floor(log.opacity))
        local color_default = color_t(sv.vars.hitlogs.neutral_color.r, sv.vars.hitlogs.neutral_color.g,
            sv.vars.hitlogs.neutral_color.b, math.floor(log.opacity))
        local color_bg = color_t(sv.vars.hitlogs.background_color.r, sv.vars.hitlogs.background_color.g,
            sv.vars.hitlogs.background_color.b, math.floor(log.opacity))

        -- ROUNDING
        local bg_size = render_get_text_size(sv.vars.hitlogs.font, string_) + vec2_t(14, 6)
        render_push_clip(orig_offset + log.cached_pos + vec2_t(offset - 7, height + bg_size.y / 2),
            vec2_t(bg_size.x * (global_vars_real_time() - log.time) / 2.8, bg_size.y / 2))
        render_rect(orig_offset + log.cached_pos + vec2_t(offset - 7, height - 3), bg_size, color_accent, 7)
        render_pop_clip()
        -- ROUNDING END JUSTIN!

        render_text(sv.vars.hitlogs.font, '[', orig_offset + log.cached_pos + vec2_t(offset, height), color_default)
        offset = offset + render_get_text_size(sv.vars.hitlogs.font, '[').x
        render_text(sv.vars.hitlogs.font, 'eclipse', orig_offset + log.cached_pos + vec2_t(offset, height), color_accent)
        offset = offset + render_get_text_size(sv.vars.hitlogs.font, 'eclipse').x
        render_text(sv.vars.hitlogs.font, '] ', orig_offset + log.cached_pos + vec2_t(offset, height), color_default)
        offset = offset + render_get_text_size(sv.vars.hitlogs.font, '] ').x

        if log.type == 'hit' then
            -- render_rect_filled( orig_offset + log.cached_pos - vec2_t(5, 2), vec2_t(render.get_text_size(hitlogs.font, string).x + 1height, 16), color_bg, height)
            render_text(sv.vars.hitlogs.font, 'Hit ', orig_offset + log.cached_pos + vec2_t(offset, height),
                color_default)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, 'Hit ').x
            render_text(sv.vars.hitlogs.font, log.player, orig_offset + log.cached_pos + vec2_t(offset, height),
                color_accent)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, log.player).x
            render_text(sv.vars.hitlogs.font, ' in ', orig_offset + log.cached_pos + vec2_t(offset, height),
                color_default)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, ' in ').x
            render_text(sv.vars.hitlogs.font, log.hitbox, orig_offset + log.cached_pos + vec2_t(offset, height),
                color_accent)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, log.hitbox).x
            render_text(sv.vars.hitlogs.font, ' for ', orig_offset + log.cached_pos + vec2_t(offset, height),
                color_default)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, ' for ').x
            render_text(sv.vars.hitlogs.font, tostring(log.damage_dealt),
                orig_offset + log.cached_pos + vec2_t(offset, height), color_accent)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, tostring(log.damage_dealt)).x
            render_text(sv.vars.hitlogs.font, ' (', orig_offset + log.cached_pos + vec2_t(offset, height), color_default)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, ' (').x
            render_text(sv.vars.hitlogs.font, tostring(log.damage_predicted),
                orig_offset + log.cached_pos + vec2_t(offset, height), color_accent)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, tostring(log.damage_predicted)).x
            render_text(sv.vars.hitlogs.font, ')', orig_offset + log.cached_pos + vec2_t(offset, height), color_default)
        elseif log.type == 'miss' then
            render_text(sv.vars.hitlogs.font, 'Missed ', orig_offset + log.cached_pos + vec2_t(offset, height),
                color_default)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, 'Missed ').x
            render_text(sv.vars.hitlogs.font, '(', orig_offset + log.cached_pos + vec2_t(offset, height), color_default)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, '(').x
            render_text(sv.vars.hitlogs.font, log.reason, orig_offset + log.cached_pos + vec2_t(offset, height),
                color_accent)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, log.reason).x
            render_text(sv.vars.hitlogs.font, ')', orig_offset + log.cached_pos + vec2_t(offset, height), color_default)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, ') ').x
            render_text(sv.vars.hitlogs.font, log.player, orig_offset + log.cached_pos + vec2_t(offset, height),
                color_accent)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, log.player).x
            render_text(sv.vars.hitlogs.font, ' at ', orig_offset + log.cached_pos + vec2_t(offset, height),
                color_default)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, ' at ').x
            render_text(sv.vars.hitlogs.font, log.hitbox, orig_offset + log.cached_pos + vec2_t(offset, height),
                color_accent)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, log.hitbox).x
            render_text(sv.vars.hitlogs.font, ' for ', orig_offset + log.cached_pos + vec2_t(offset, height),
                color_default)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, ' for ').x
            render_text(sv.vars.hitlogs.font, tostring(log.damage_predicted),
                orig_offset + log.cached_pos + vec2_t(offset, height), color_accent)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, tostring(log.damage_predicted)).x
            render_text(sv.vars.hitlogs.font, ' (safe: ', orig_offset + log.cached_pos + vec2_t(offset, height),
                color_default)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, ' (safe: ').x
            render_text(sv.vars.hitlogs.font, tostring(log.safepoint),
                orig_offset + log.cached_pos + vec2_t(offset, height), color_accent)
            offset = offset + render_get_text_size(sv.vars.hitlogs.font, tostring(log.safepoint)).x
            render_text(sv.vars.hitlogs.font, ')', orig_offset + log.cached_pos + vec2_t(offset, height), color_default)
        end

        if log.time + 3 < global_vars_real_time() and log.pos.x <=
            -render_get_text_size(sv.vars.hitlogs.font, string_).x then
            table.remove(sv.vars.hitlogs.logs, i)
        end
    end
end

sv.fn.on_paint.calculate_desync = function()
    if not (engine_is_connected() or engine_is_in_game()) then
        return
    end

    desync_value = math.min(58.0, math.abs(sv.fn.normalize_yaw(antiaim_get_real_angle() - antiaim_get_fake_angle())))
end

sv.fn.on_paint.condition_calc = function()
    if engine_is_connected() and entity_list_get_local_player() then

        local curtime = global_vars_cur_time()
        local player = entity_list_get_local_player()
        local velocity = player:get_prop("m_vecVelocity"):length()

        local air = not player:has_player_flag(e_player_flags.ON_GROUND)
        local air_duck = not player:has_player_flag(e_player_flags.ON_GROUND) and
                             player:has_player_flag(e_player_flags.DUCKING)
        local moving = velocity > 5
        local ducking = player:has_player_flag(e_player_flags.DUCKING)

        if not player:has_player_flag(e_player_flags.ON_GROUND) then
            condition_calculation.landtime_aa = curtime + 0.1
        end

        sv.current_condition = "STANDING"

        if condition_calculation.landtime_aa > curtime and ((air and ducking) or ducking) then
            sv.current_condition = "JUMP+DUCK"
        elseif condition_calculation.landtime_aa > curtime or air then
            sv.current_condition = "JUMPING"
        elseif sv.aa_ref.slowwalk_key[2]:get() and condition_calculation.landtime_aa < curtime then
            sv.current_condition = "SLOWWALKING"
        elseif moving and not ducking and condition_calculation.landtime_aa < curtime then
            sv.current_condition = "MOVING"
        elseif ducking and condition_calculation.landtime_aa < curtime then
            sv.current_condition = "DUCKING"
        end
    end
end

-- * Crosshair indicators
-- Indicator Ease
local function inQuad(t, b, c, d)
    t = t / d
    return c * (t * t) + b
end
local indicator_vars = {}
indicator_vars.fade_in = 0
indicator_vars.fade_out = 10

sv.vars.on_paint.amazing_dt_indicator = {}

sv.vars.on_paint.amazing_dt_indicator.text = {
    hs = {'HIDES', 'HOTS'},
    dt = {'DOUB', 'LETAP'}
}

sv.vars.on_paint.amazing_dt_indicator.text_size = {
    hs = {render_get_text_size(sv.render_utility.main_font, sv.vars.on_paint.amazing_dt_indicator.text.hs[1]),
          render_get_text_size(sv.render_utility.main_font, sv.vars.on_paint.amazing_dt_indicator.text.hs[2])},
    dt = {render_get_text_size(sv.render_utility.main_font, sv.vars.on_paint.amazing_dt_indicator.text.dt[1]),
          render_get_text_size(sv.render_utility.main_font, sv.vars.on_paint.amazing_dt_indicator.text.dt[2])}
}

sv.vars.on_paint.amazing_dt_indicator.y_offset = sv.vars.on_paint.amazing_dt_indicator.text_size.hs[1].y
sv.vars.on_paint.amazing_dt_indicator.y_anim_offset = sv.vars.on_paint.amazing_dt_indicator.y_offset
sv.vars.on_paint.amazing_dt_indicator.enabled = false

sv.fn.on_paint.render_amazing_dt_indicator = function(lp)
    if not lp or not lp:is_player() or not lp:is_alive() and entity_list_get_local_player_or_spectating():get_index() ~=
        lp:get_index() then
        return
    end

    local tableVars = sv.vars.on_paint.amazing_dt_indicator
    local vecStart = vec2_t.new(sv.x, sv.y + 12)

    local bEnabled = sv.rb_ref.doubletap[2]:get() and 'dt' or sv.rb_ref.hideshots[2]:get() and
                         sv.rb_ref.hideshots[2]:get() and 'hs' or nil

    tableVars.enabled = bEnabled ~= nil
    if not bEnabled or not sv.items.multiselect_enablesections:get(1) then
        return
    end

    local fCharge_perc = exploits_get_charge() / 14
    local cTemp_color = color_t(math.floor((1 - fCharge_perc) * 255), math.floor((fCharge_perc) * 255), 0, 255)

    local iOffset = bEnabled == 'hs' and 2 or 0

    if bEnabled == 'dt' then
        tableVars.y_anim_offset = lerp(tableVars.y_anim_offset, tableVars.y_offset, 0.2)
    else
        tableVars.y_anim_offset = lerp(tableVars.y_anim_offset, 0, 0.1)
    end

    local vecText_start = vecStart - tableVars.text_size[bEnabled][1] +
                              vec2_t(iOffset, tableVars.y_anim_offset - tableVars.text_size[bEnabled][2].y)

    for key, text_table in pairs(tableVars.text) do
        for i = 1, #text_table do
            if i == 1 then
                render_push_clip(vecStart -
                                     vec2_t(tableVars.text_size[bEnabled][2].x * fCharge_perc,
                        tableVars.text_size[bEnabled][2].y), vec2_t(
                    (tableVars.text_size[bEnabled][2].x + 5) * fCharge_perc, tableVars.text_size[bEnabled][2].y),
                    cTemp_color)
            else
                render_push_clip(vecStart - vec2_t(0, tableVars.text_size[bEnabled][2].y), vec2_t(
                    (tableVars.text_size[bEnabled][2].x + 5) * fCharge_perc, tableVars.text_size[bEnabled][2].y),
                    cTemp_color)
            end

            render_text(sv.render_utility.main_font, tableVars.text[key][i], vecText_start, cTemp_color)
            vecText_start = vecText_start + vec2_t(tableVars.text_size[key][i].x, 0)

            render_pop_clip()
        end

        vecText_start = vecStart - tableVars.text_size[key][1] +
                            vec2_t(iOffset, tableVars.y_anim_offset - tableVars.text_size[bEnabled][2].y +
                tableVars.text_size[key][1].y)
    end
end

-- sv.fn.on_paint.render_crosshair_indicators = {}
-- sv.fn.on_paint.render_crosshair_indicators.horiz_indicators = {
-- last_update_time = 0,
-- start1 = 0,
-- }
-- sv.fn.on_paint.render_crosshair_indicators.keybind = {}
-- sv.fn.on_paint.render_crosshair_indicators.keybind.last_update_time = 0
-- sv.fn.on_paint.render_crosshair_indicators.keybind.start1 = 0

sv.vars.on_paint.crosshair_indicators = {}
sv.vars.on_paint.crosshair_indicators.y_offset = 0
sv.fn.on_paint.render_crosshair_indicators = function(local_player)
    local lp = local_player

    if not lp or not lp:is_player() or not lp:is_alive() or not engine_is_connected() or not engine_is_in_game() or
        not sv.items.multiselect_enablesections:get(1) then
        sv.keybinds[1].disable_time = 0
        sv.keybinds[2].disable_time = 0
        sv.keybinds[3].disable_time = 0
        sv.keybinds[4].disable_time = 0
        sv.keybinds[5].disable_time = 0
        -- sv.keybinds[6].disable_time = 0
        sv.keybinds[6].disable_time = 0
        return
    end

    if lp:get_prop("m_bIsScoped") == 1 and sv.items.checkbox_enable_scope_in_animation:get() then
        local final_pos = sv.screen_size.x / 2 + 35
        sv.x = inQuad(0.1, sv.x, final_pos - sv.x, 0.35)
    else
        local final_pos = sv.screen_size.x / 2
        sv.x = inQuad(0.1, sv.x, final_pos - sv.x, 0.35)
    end

    -- Locals
    local ind_dst = -10
    local ind_spr = 9

    -- Colors for the [beta] text
    local r_beta, g_beta, b_beta = sv.colors.default.eclipsecolorpicker:get().r,
        sv.colors.default.eclipsecolorpicker:get().g, sv.colors.default.eclipsecolorpicker:get().b
    local a_beta = math.abs(math.floor(math.sin(global_vars_cur_time()) * 255))

    -- Colors for dt
    local r_dt, g_dt, b_dt = interpolate_color_tickbase(exploits_get_charge(), 14)

    -- FREESTAND
    sv.keybinds[1].state = sv.aa_ref.freestand_ref[2]:get()
    sv.keybinds[1].selected = sv.items.multiselect_keybinds:get("Freestand")
    -- PING
    sv.keybinds[2].state = sv.rb_ref.pingspikeenable[2]:get()
    sv.keybinds[2].selected = sv.items.multiselect_keybinds:get("Ping spike")
    -- PEEK
    sv.keybinds[3].state = sv.rb_ref.quickpeek_ref[2]:get()
    sv.keybinds[3].selected = sv.items.multiselect_keybinds:get("Quick peek assist")
    -- ROLL
    sv.keybinds[4].state = sv.rb_ref.roll_reso[2]:get()
    sv.keybinds[4].selected = sv.items.multiselect_keybinds:get("Roll Resolver")
    -- HIDE
    sv.keybinds[5].state = sv.rb_ref.doubletap[2]:get() and sv.rb_ref.hideshots[2]:get()
    sv.keybinds[5].selected = sv.items.multiselect_keybinds:get("Hide Shots")
    -- DT
    -- sv.keybinds[6].state = sv.rb_ref.doubletap[2]:get()
    -- sv.keybinds[6].selected = sv.items.multiselect_keybinds:get("Double Tap")
    -- FD
    sv.keybinds[6].state = antiaim_is_fakeducking()
    sv.keybinds[6].selected = sv.items.multiselect_keybinds:get("Fake Duck")

    -- * +/- [condition]
    render_text(sv.render_utility.main_font, "" .. sv.current_condition, vec2_t(sv.x, sv.y - 2),
        sv.colors.default.antiaimstatecolorpicker:get(), true)
    ind_dst = ind_dst + ind_spr

    local default_text = 'eclipse'
    local extra_text = beta and ' [beta]' or ' [live]'

    local default_text_size = render_get_text_size(sv.render_utility.default_font, default_text)
    local extra_text_size = render_get_text_size(sv.render_utility.default_font, extra_text)

    -- * Min dmg override
    if sv.rb_ref.dmgoverride[2]:get() then
        render_text(sv.render_utility.main_font2, sv.current_weapon() .. "",
            vec2_t(render_get_screen_size().x / 2 + 5, sv.y - 45), color_t(255, 255, 255, 255))
    end

    -- * Eclipse text
    render_text(sv.render_utility.default_font, default_text,
        vec2_t(sv.x - (default_text_size.x + extra_text_size.x) / 2, sv.y - 13 - (default_text_size.y / 2)),
        color_t(215, 215, 215, 255))
    render_text(sv.render_utility.default_font, extra_text,
        vec2_t(sv.x - (default_text_size.x + extra_text_size.x) / 2 + default_text_size.x,
            sv.y - 13 - (default_text_size.y / 2)), color_t(r_beta, g_beta, b_beta, a_beta))

    -- next indicator distance
    -- up indicator distance if we have amazing dt indicator enabled
    ind_dst = ind_dst + (ind_spr * 2 + 5) + (sv.vars.on_paint.amazing_dt_indicator.enabled and ind_spr - 2 or 0)

    -- Keybind indicators
    local screen = render_get_screen_size()
    local active_keybinds = {}
    local length = -5
    local cur_time = global_vars_cur_time()
    for i, v in ipairs(sv.keybinds) do
        if v.state ~= v.last_state then
            v.last_state = v.state
            if not v.state then
                v.disable_time = cur_time + 0.1
                v.alpha = 0
            end
        end

        if v.disable_time < cur_time and not v.state then
            v.x = 0
            v.cached_x = 0
        end

        if v.selected and (v.state or v.disable_time > cur_time) then
            if v.state then
                v.alpha = math.floor(lerp(v.alpha, 255, 0.05))
            end
            table.insert(active_keybinds, tostring(i))
            v.x = length + 5
            length = length + render_get_text_size(sv.render_utility.main_font, v.name).x + 5
        end
    end

    local start = sv.x - length / 2

    if sv.horiz_indicators.start1 == 0 then
        sv.horiz_indicators.start1 = start
    end

    sv.vars.on_paint.crosshair_indicators.y_offset = lerp(sv.vars.on_paint.crosshair_indicators.y_offset,
        sv.vars.on_paint.amazing_dt_indicator.enabled and 5 or 11, 0.1)
    sv.horiz_indicators.start1 = lerp(sv.horiz_indicators.start1, start, 0.2)

    local start = sv.horiz_indicators.start1
    for i, v in ipairs(active_keybinds) do
        local keybind = sv.keybinds[tonumber(v)]

        keybind.cached_x = lerp(keybind.cached_x, keybind.x, 0.1)

        local opacity = keybind.alpha
        if keybind.disable_time > cur_time then
            opacity = math.floor(255 * (keybind.disable_time - cur_time))
        end
        render_push_alpha_modifier(opacity / 255)
        render_text(sv.render_utility.main_font, keybind.name, vec2_t(start + keybind.cached_x,
            sv.y + 6 + ind_dst / 2.8 - sv.vars.on_paint.crosshair_indicators.y_offset),
            sv.render_utility.accent_color:get())
        render_pop_alpha_modifier()
    end
end

sv.vars.custom_clantag = {}
sv.vars.custom_clantag.clantag = {
    disabled = false,
    last_clantag = '',
    tag = { -- 15 max
    'eclipse\' 		', -- '\n' clears everything
    'eclipse\' 		', -- '	' is the longest blank one
    'clipse\' 		', 'lipse\' 		', 'ipse\' 		', 'pse\' 		', 'se\' 		', 'e\' 		', '\' 		', '\' 		', 'e\' 		', 'se\' 		',
    'pse\' 		', 'ipse\' 		', 'lipse\' 		', 'clipse\' 		', 'eclipse\' 		', 'eclipse\' 		', 'eclipse\' 		',
    'eclipse\' 		', 'eclipse\' 		'},
    tag_beta = { -- 15 max
    'eclipse | beta|		', -- '\n' clears everything
    'eclipse | beta|		', -- '	' is the longest blank one
    'eclipse | beta|		', 'eclipse |a bet|		', 'eclipse |a bet|		', 'eclipse |ta be|		', 'eclipse |ta be|		',
    'eclipse |eta b|		', 'eclipse |eta b|		', 'eclipse |beta |		', 'eclipse |beta |		', 'eclipse |beta |		'}
}

sv.fn.on_paint.on_clantag = function(lp)
    if not sv.items.multiselect_enablesections:get('Misc') or not sv.items.checkbox_clantag_enable:get() or not lp then
        if lp and not sv.vars.custom_clantag.clantag.disabled then
            client_set_clantag('')
            sv.vars.custom_clantag.clantag.disabled = true
        end
        return
    end

    local tag = sv.vars.custom_clantag.clantag.tag
    if beta then
        tag = sv.vars.custom_clantag.clantag.tag_beta
    end

    local pred = global_vars_tick_count() + (engine_get_latency() / global_vars_interval_per_tick())
    local iter = math.floor(math.fmod(pred / 16, #tag) + 1)

    if tag[iter] == sv.vars.custom_clantag.clantag.last_clantag then
        return
    end
    sv.vars.custom_clantag.clantag.last_clantag = tag[iter]
    client_set_clantag(tag[iter])
    sv.vars.custom_clantag.clantag.disabled = false
end

sv.vars.info_panel = {}
sv.vars.info_panel.cached = {
    dmg_default = 0,
    dmg_override = 0,
    hc = 0
}

sv.vars.info_panel.draggable = draggable({
    pos = vec2_t(sv.items.slider_infopanel_posx:get(), sv.items.slider_infopanel_posy:get()),
    size = vec2_t(150, 20),
    opens_to = e_menu_open_types.SIDE,
    interaction_menu = interaction_menu({
        title = 'Information panel',
        width = 150
    })
})

sv.vars.info_panel.menu_elems = {}
sv.vars.info_panel.menu_elems.weapon = sv.vars.info_panel.draggable.interaction_menu:add_checkbox('Weapon', true)
sv.vars.info_panel.menu_elems.tickbase_fakelag = sv.vars.info_panel.draggable.interaction_menu:add_checkbox(
    'Tickbase & Fakelag', true)
sv.vars.info_panel.menu_elems.mindmg_hitchance = sv.vars.info_panel.draggable.interaction_menu:add_checkbox(
    'Min.damage & Hitchance', true)

sv.fn.on_paint.info_panel = function()
    local self = sv.vars.info_panel.draggable
    self.visible = false

    if not sv.items.multiselect_enablesections:get('Visuals') or not sv.items.checkbox_enable_infopanel:get() then
        return
    end
    self.visible = true

    local lp = entity_list_get_local_player()

    self.pos = vec2_t(sv.items.slider_infopanel_posx:get(), sv.items.slider_infopanel_posy:get())
    sv.vars.info_panel.draggable:handle_dragging()

    local info_pos = self.pos
    render_line(info_pos, info_pos + vec2_t(150, 0), sv.render_utility.accent_color:get())
    render_rect_filled(info_pos, vec2_t(150, 13), color_t(20, 20, 20, 130))
    render_text(sv.render_utility.default_font, "Information Panel", info_pos + vec2_t(35, 0),
        color_t(230, 230, 230, 255))

    sv.items.slider_infopanel_posx:set(self.pos.x)
    sv.items.slider_infopanel_posy:set(self.pos.y)

    -- Weapon info panel
    local info_panel_items = self.interaction_menu.menu_t.menu_elements
    local any_enabled = false

    for i = 1, #info_panel_items do
        local option = info_panel_items[i]
        if option:get() then
            any_enabled = true
            break
        end
    end

    if not any_enabled then
        return
    end

    if menu_is_open() then
        self:handle_dragging()
    end

    if not lp then
        return
    end

    local height = 0

    if sv.vars.info_panel.menu_elems.weapon:get() then
        height = height + 15
        -- * weapons
        -- Get active weapon
        local wep = lp:get_active_weapon()
        if not wep then
            return
        end
        local wep_enum = sv.wep_name_to_enum[lp:get_active_weapon():get_name():upper()]
        if not wep_enum then
            return
        end -- Maybe do some ::skip:: stuff here
        local active_weapon = lp:get_active_weapon():get_name()

        -- Down line + box
        render_line(info_pos + vec2_t(0, height), info_pos + vec2_t(0, 28), sv.render_utility.accent_color:get())
        render_rect_filled(info_pos + vec2_t(0, height), vec2_t(150, 14), color_t(20, 20, 20, 100))

        -- Render stuff inside the box
        render_weapon_icon(wep_enum, info_pos + vec2_t(50, height + 1), color_t(255, 255, 255, 255), false, 0.4)
        render_text(sv.render_utility.default_font, "Weapon:", info_pos + vec2_t(3, 14), color_t(230, 230, 230, 255))
        render_text(sv.render_utility.default_font, "[" .. active_weapon .. "]", info_pos +
            vec2_t(149 - render_get_text_size(sv.render_utility.default_font, "[" .. active_weapon .. "]").x, 14),
            color_t(230, 230, 230, 255))
    end

    if sv.vars.info_panel.menu_elems.tickbase_fakelag:get() then
        height = height + 16
        -- * Fakelag and Tickbase
        local charge = exploits_get_charge()
        local r_infopanel_dt, g_infopanel_dt, b_infopanel_dt = sv.fn.interpolate_color_tickbase(charge, 14)
        local r_infopanel_fl, g_infopanel_fl, b_infopanel_fl =
            sv.fn.interpolate_color_fakelag(engine_get_choked_commands(), 15)

        -- Count ticks to get a timer until the fakelag activates (when u shot with dt enabled it shouldnt switch back to )

        -- Line + box
        render_line(info_pos + vec2_t(0, height), info_pos + vec2_t(0, height + 13),
            sv.render_utility.accent_color:get())
        render_rect_filled(info_pos + vec2_t(1, height), vec2_t(150, 14), color_t(20, 20, 20, 100))

        -- Doubletap
        render_text(sv.render_utility.default_font, "Tickbase: ", info_pos + vec2_t(3, height),
            color_t(230, 230, 230, 255))
        if charge == 0 then
            render_text(sv.render_utility.default_font, "uncharged", info_pos + vec2_t(50, height),
                color_t(255, 60, 70, 255))
        elseif charge == 14 then
            render_text(sv.render_utility.default_font, "charged", info_pos + vec2_t(50, height),
                color_t(115, 220, 13, 255))
        elseif charge > 1 then
            render_text(sv.render_utility.default_font, "charging", info_pos + vec2_t(50, height),
                color_t(250, 130, 130, 255))
        end

        -- Intersection line
        render_line(info_pos + vec2_t(113, height), info_pos + vec2_t(113, height + 13), color_t(230, 230, 230, 55))

        -- Tickbase charge + fakelag circle
        if sv.rb_ref.doubletap[2]:get() or sv.rb_ref.hideshots[2]:get() then
            render_text(sv.render_utility.default_font, "TB: ", info_pos + vec2_t(117, height),
                color_t(230, 230, 230, 255))
            render_text(sv.render_utility.default_font, "" .. charge, info_pos +
                vec2_t(116 + render_get_text_size(sv.render_utility.default_font, "TB: ").x, height),
                color_t(r_infopanel_dt, g_infopanel_dt, b_infopanel_dt, 255))
        else
            render_text(sv.render_utility.default_font, "FL: ", info_pos + vec2_t(117, height),
                color_t(230, 230, 230, 255))
            render_progress_circle(info_pos +
                                       vec2_t(120 + render_get_text_size(sv.render_utility.default_font, "FL: ").x,
                    height + 6), 3, color_t(r_infopanel_fl, g_infopanel_fl, b_infopanel_fl, 255), 2,
                engine_get_choked_commands() / 15)
        end
    end

    if sv.vars.info_panel.menu_elems.mindmg_hitchance:get() then
        height = height + 16
        -- Min dmg and hitchance
        local dmg_override = sv.current_weapon()
        local dmg_default, pimmelberger = sv.current_weapon_default()

        if dmg_default == nil then
            return
        end

        sv.vars.info_panel.cached.dmg_default = lerp(sv.vars.info_panel.cached.dmg_default, dmg_default, 0.1)
        sv.vars.info_panel.cached.dmg_override = lerp(sv.vars.info_panel.cached.dmg_override, dmg_override, 0.1)

        if lp:get_active_weapon() then
            local inaccuracy = math.floor(lp:get_active_weapon():get_weapon_inaccuracy() * 1000) / 10 -- so we get value in %

            render_line(info_pos + vec2_t(0, height), info_pos + vec2_t(0, height + 13),
                sv.render_utility.accent_color:get())
            render_rect_filled(info_pos + vec2_t(1, height), vec2_t(150, 14), color_t(20, 20, 20, 100))

            render_text(sv.render_utility.default_font, "Min. Damage: ", info_pos + vec2_t(3, height),
                color_t(230, 230, 230, 255))
            if sv.rb_ref.dmgoverride[2]:get() then
                render_text(sv.render_utility.default_font,
                    string.format('%s', math.floor(sv.vars.info_panel.cached.dmg_default + 0.5)), info_pos +
                        vec2_t(3 + render_get_text_size(sv.render_utility.default_font, "Min. Damage: ").x, height),
                    color_t(250, 250, 250, 55))
                render_text(sv.render_utility.default_font,
                    string.format('%s', math.floor(sv.vars.info_panel.cached.dmg_override + 0.5)),
                    info_pos + vec2_t(8 + render_get_text_size(sv.render_utility.default_font, "Min. Damage: " ..
                                          math.floor(sv.vars.info_panel.cached.dmg_default + 0.5) .. "").x, height),
                    color_t(250, 250, 250, 255))
            else
                render_text(sv.render_utility.default_font,
                    string.format('%s', math.floor(sv.vars.info_panel.cached.dmg_default + 0.5)), info_pos +
                        vec2_t(3 + render_get_text_size(sv.render_utility.default_font, "Min. Damage: ").x, height),
                    color_t(250, 250, 250, 255))
                render_text(sv.render_utility.default_font,
                    string.format('%s', math.floor(sv.vars.info_panel.cached.dmg_override + 0.5)),
                    info_pos + vec2_t(8 + render_get_text_size(sv.render_utility.default_font, "Min. Damage: " ..
                                          math.floor(sv.vars.info_panel.cached.dmg_default + 0.5) .. "").x, height),
                    color_t(250, 250, 250, 55))
            end

            render_line(info_pos + vec2_t(6 + render_get_text_size(sv.render_utility.default_font, "Min. Damage: " ..
                                              math.floor(sv.vars.info_panel.cached.dmg_default + 0.5) .. "").x, height),
                info_pos + vec2_t(3 + render_get_text_size(sv.render_utility.default_font, "Min. Damage: " ..
                                      math.floor(sv.vars.info_panel.cached.dmg_default + 0.5) .. "").x, height + 12),
                color_t(230, 230, 230, 55))

            render_text(sv.render_utility.default_font, "acc:", info_pos + vec2_t(110, height),
                color_t(230, 230, 230, 255))

            sv.vars.info_panel.cached.hc = lerp(sv.vars.info_panel.cached.hc, inaccuracy, 0.1)

            render_text(sv.render_utility.default_font,
                string.format('%s', math.ceil(tostring(100 - sv.vars.info_panel.cached.hc))),
                info_pos + vec2_t(131, height), color_t(math.floor(255 * (inaccuracy / 100)),
                    math.floor(255 * (1 - inaccuracy / 100)), 0, 255))
        end
    end
end

-- sv.vars.info_panel.draggable:set_render_fn( sv.fn.on_paint.info_panel )

sv.fn.on_antiaim = {}
sv.vars.on_antiaim = {}
sv.fn.on_net_update = {}
sv.vars.on_net_update = {}

sv.vars.on_antiaim.anims_2018 = {}
sv.vars.on_antiaim.anims_2018.landtime = 0
sv.fn.on_antiaim.anims_2018 = function(ctx, cmd, lp)
    if not sv.items.checkbox_2018_anims_enable:get() then
        return
    end

    local ground = lp:has_player_flag(e_player_flags.ON_GROUND)
    local curtime = global_vars_cur_time()

    if not ground then
        sv.vars.on_antiaim.anims_2018.landtime = curtime + 0.65
    end

    if sv.items.multiselect_2018_anims_options:get('static legs in air') then -- zero pitch on land
        ctx:set_render_pose(e_poses.JUMP_FALL, 0.5, 0.5)
    end

    if sv.items.multiselect_2018_anims_options:get('0 pitch on land') then
        if ground and sv.vars.on_antiaim.anims_2018.landtime > curtime and sv.current_condition ~= 'JUMPING' and
            sv.current_condition ~= 'JUMP+DUCK' then
            ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
        end
    end

    if sv.items.multiselect_2018_anims_options:get("lean in air") then
        if not ground then
            ctx:set_render_animlayer(e_animlayers.LEAN, 0.75)
        end
    end

    if sv.items.multiselect_2018_anims_options:get("backwards slide") then
        if ground then
            ctx:set_render_pose(e_poses.STRAFE_DIR, -1)
        end
    end
end

sv.edge_yaw = {}

sv.vars.on_antiaim.global = {}
sv.vars.on_antiaim.global.yaw = 0
sv.vars.on_antiaim.global.freestanding_side = 0

sv.vars.on_antiaim.at_targets = {}
sv.vars.on_antiaim.at_targets.screen_center = vec2_t.new(sv.screen_size.x / 2, sv.screen_size.y / 2)
sv.vars.on_antiaim.at_targets.target = nil

sv.fn.on_antiaim.get_at_targets_yaw = function(cmd, sMethod, lp)
    local tableVars = sv.vars.on_antiaim.at_targets
    local iLowest_dist = math.huge
    tableVars.target = nil

    if sMethod == 'fov' then
        local vecCenter = tableVars.screen_center
        for _, pEnemy in pairs(entity_list_get_players(true)) do
            local vecEnemy_head_screen = render_world_to_screen(pEnemy:get_hitbox_pos(e_hitboxes.HEAD))

            if vecEnemy_head_screen and pEnemy and pEnemy:is_player() and pEnemy:is_alive() and not pEnemy:is_dormant() then
                local fDist = math.sqrt(math.pow(vecEnemy_head_screen.x - vecCenter.x, 2) +
                                            math.pow(vecEnemy_head_screen.y - vecCenter.y, 2))

                if fDist < iLowest_dist then
                    iLowest_dist = fDist
                    tableVars.target = pEnemy
                end
            end
        end

    elseif sMethod == 'distance' then
        local vecLp_origin = lp:get_prop('m_vecAbsOrigin')
        for _, pEnemy in pairs(entity_list_get_players(true)) do
            local vecEnemy_origin = pEnemy:get_prop('m_vecAbsOrigin')

            if vecEnemy_origin and pEnemy and pEnemy:is_player() and pEnemy:is_alive() and not pEnemy:is_dormant() then
                local fDist = vecLp_origin:dist(vecEnemy_origin)

                if fDist < iLowest_dist then
                    iLowest_dist = fDist
                    tableVars.target = pEnemy
                end
            end
        end
    else
        return cmd.viewangles.y
    end

    if tableVars.target == nil then
        return cmd.viewangles.y
    end

    local vecLocal_origin = lp:get_prop('m_vecAbsOrigin')
    local vecEnemy_origin = tableVars.target:get_prop('m_vecAbsOrigin')

    local vecLocalplayer_to_enemy = vecEnemy_origin - vecLocal_origin

    local angLocalplayer_to_enemy = vecLocalplayer_to_enemy:to_angle()

    sv.vars.on_antiaim.global.yaw = sv.fn.normalize_yaw(angLocalplayer_to_enemy.y - 180)
    sv.vars.on_antiaim.at_targets.target = tableVars.target
end

sv.vars.on_paint.watermark = {}
sv.vars.on_paint.watermark.draggable = draggable({
    pos = vec2_t(100, 100),
    size = vec2_t(100, 100),
    interaction_menu = interaction_menu({
        title = 'watermark'
    })
})

sv.vars.on_paint.watermark.menu_elems = {}
sv.vars.on_paint.watermark.menu_elems.enable_name = sv.vars.on_paint.watermark.draggable.interaction_menu:add_checkbox(
    'name', false)
sv.vars.on_paint.watermark.menu_elems.enable_uid = sv.vars.on_paint.watermark.draggable.interaction_menu:add_checkbox(
    'uid', false)
sv.vars.on_paint.watermark.menu_elems.enable_time = sv.vars.on_paint.watermark.draggable.interaction_menu:add_checkbox(
    'time', false)
sv.vars.on_paint.watermark.menu_elems.enable_timeout =
    sv.vars.on_paint.watermark.draggable.interaction_menu:add_checkbox('timeout', false)
sv.vars.on_paint.watermark.menu_elems.enable_beta_animation =
    sv.vars.on_paint.watermark.draggable.interaction_menu:add_checkbox('beta animation', false)

sv.vars.on_paint.watermark.render_circle = function(center, radius, start, end_, width, color)
    local points = {}

    if start > end_ then
        local temp = start
        start = end_
        end_ = temp
    end

    for i = start, end_ do
        local angle = math.rad(i)
        local x = center.x + math.cos(angle) * radius
        local y = center.y + math.sin(angle) * radius

        points[#points + 1] = vec2_t(x, y)
    end

    for i = end_, start, -1 do
        local angle = math.rad(i)
        local x = center.x + math.cos(angle) * (radius - width)
        local y = center.y + math.sin(angle) * (radius - width)

        points[#points + 1] = vec2_t(x, y)
    end

    render_polygon(points, color)
end

sv.vars.on_paint.watermark.watermark_render = function(watermark_draggable)
    local self = watermark_draggable

    local screen_size = render_get_screen_size()
    local start_pos = vec2_t(screen_size.x - 20, 20)
    local height = 20

    local texts = {'eclipse.lua [', beta and 'beta' or 'live', ']', ' '}

    local beta_anim_c = sv.vars.on_paint.watermark.menu_elems.enable_beta_animation

    if not beta and beta_anim_c.visible then
        beta_anim_c:set_visible(false)
    end

    local name_c = sv.vars.on_paint.watermark.menu_elems.enable_name
    local uid_c = sv.vars.on_paint.watermark.menu_elems.enable_uid
    local time_c = sv.vars.on_paint.watermark.menu_elems.enable_time
    local timeout_c = sv.vars.on_paint.watermark.menu_elems.enable_timeout

    if name_c:get() then
        table.insert(texts, ' / name: ');
        table.insert(texts, user.name .. ' ')
    end
    if uid_c:get() then
        table.insert(texts, ' / uid: ');
        table.insert(texts, tostring(user.uid) .. ' ')
    end
    if time_c:get() then
        table.insert(texts, ' / time: ');

        local h, m, s = client_get_local_time()
        if h < 10 then
            h = '0' .. h
        end
        if m < 10 then
            m = '0' .. m
        end
        if s < 10 then
            s = '0' .. s
        end

        table.insert(texts, string.format('%s:%s:%s ', h, m, s))
    end

    local acc_c = sv.misc_ref.accent_color:get()

    local text = table.concat(texts)

    local text_size = render_get_text_size(sv.render_utility.default_font, text)

    local logo_size = 30

    local in_game_and_no_internet = global_vars_real_time() - sv.vars.on_paint.watermark.net_upd_last_update > 0.5 and
                                        engine_is_connected() and timeout_c:get()
    if in_game_and_no_internet then
        logo_size = logo_size +
                        render_get_text_size(sv.render_utility.default_font,
                            string.format('timeout: %.1f',
                    global_vars_real_time() - sv.vars.on_paint.watermark.net_upd_last_update)).x + 10
    end

    self.size.x = math.floor(lerp(self.size.x, text_size.x + logo_size, 0.2))
    self.size.y = text_size.y + 10

    self.pos.x = start_pos.x - self.size.x
    self.pos.y = start_pos.y

    render_rect_filled(self.pos, self.size, color_t(0, 0, 0, 255), 7)
    render_rect_filled(self.pos + vec2_t(1, 1), self.size - vec2_t(2, 2), color_t(40, 40, 40, 255), 7)

    local offset = logo_size - 10
    if in_game_and_no_internet then
        local start_ = math.sin(global_vars_real_time() * 2) * 360
        local end_ = start_ + 90

        sv.vars.on_paint.watermark.render_circle(self.pos + vec2_t(12, 13), 7, start_, end_, 2,
            color_t(acc_c.r, acc_c.g, acc_c.b, 200))
        sv.vars.on_paint.watermark.render_circle(self.pos + vec2_t(12, 13), 7, start_ + 180, end_ + 180, 2,
            color_t(acc_c.r, acc_c.g, acc_c.b, 200))

        -- render timeout text
        local text = 'timeout: %.1f'
        text = string.format(text, global_vars_real_time() - sv.vars.on_paint.watermark.net_upd_last_update)

        render_text(sv.render_utility.default_font, text, self.pos + vec2_t(25, 5), color_t(255, 40, 40, 255))
        texts[1] = '| ' .. texts[1]
        offset = offset - 5
    else
        -- logo
        render_circle_filled(self.pos + vec2_t(13, 13), 6, color_t(255, 255, 255, 255))
        render_circle_filled(self.pos + vec2_t(9, 9), 5, color_t(acc_c.r, acc_c.g, acc_c.b, 200))
    end

    render_push_clip(self.pos, self.size)

    local product = beta and 'beta' or 'live'

    for i = 1, #texts do
        local text = tostring(texts[i])

        local c = i % 2 == 0 and acc_c or color_t(220, 220, 220, 255)

        local text_size = render_get_text_size(sv.render_utility.default_font, text).x

        local pos = vec2_t(self.pos.x + 5 + offset, self.pos.y + 5)

        if beta and text == product and beta_anim_c:get() then
            libs.animated_text.render('beta_watermark_text', sv.render_utility.default_font, text, pos, c, -4)
        else
            render_text(sv.render_utility.default_font, text, pos, c)
        end

        offset = offset + text_size
    end

    render_pop_clip()
end

sv.vars.on_paint.watermark.draggable:set_render_fn(sv.vars.on_paint.watermark.watermark_render)
sv.vars.on_paint.watermark.net_upd_last_update = 0

sv.fn.on_net_update.watermark_update_net = function()
    sv.vars.on_paint.watermark.net_upd_last_update = global_vars_real_time()
end

--[[
sv.vars.on_paint.keybinds_list = { }
sv.vars.on_paint.keybinds_list.draggable = draggable( {
    pos = vec2_t( 100, 100 ),
    size = vec2_t( 150, 15 ),
    texts = {''},
    opens_to = 'side',
    visible = false,
    interaction_menu = interaction_menu( {
        pos = vec2_t( 100, 100 ),
        title = 'keybinds',
        width = 200,
        entries = {
            option({
                name = 'keybinds',
                values = { },
                type = 'dropdown_m',
                items = { 'roll resolver', 'override resolver', 'doubletap', 'hideshots', 'pingspike', 'autopeek', 'force lethal', 'min. dmg override', 'force hitbox', 'force sp', 'force roll sp', 'force hc', 'fake duck', 'invert desync', 'auto direction' },
            }),
        },
    } ),
} )
sv.vars.on_paint.keybinds_list.binds = {
    sv.rb_ref.roll_reso,
    menu_find( 'aimbot', 'general', 'aimbot', 'override resolver' ),
    sv.rb_ref.doubletap,
    sv.rb_ref.hideshots,
    sv.rb_ref.pingspikeenable,
    sv.rb_ref.quickpeek_ref,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    -- 'fake duck', 'invert desync', 'auto direction'
    menu_find( 'antiaim', 'main', 'general', 'fake duck' ),
    sv.aa_ref.invert,
    sv.rb_ref.autodir_key,
}
sv.vars.on_paint.keybinds_list.keybinds_renderer = function( draggable )
    if not sv.items.checkbox_enable_keybinds:get( ) then return end
    local self = draggable
    self:handle_dragging( )
    local start_pos = self.pos
    local size = self.size + vec2_t( 0, self.size.y )
    local acc_c = sv.misc_ref.accent_color:get( )
    local center = start_pos + vec2_t( size.x / 2, size.y / 3 - 2 )
    render_push_clip( start_pos, vec2_t( size.x, size.y / 2 ) )
    render_rect_filled( start_pos - vec2_t( 0, size.y / 2 ), size, color_t( 43, 43, 43, 255 ), 7 )
    render_pop_clip( )
    render_line( start_pos, start_pos + vec2_t( size.x, 0 ), acc_c )
    render_text( sv.render_utility.default_font, 'keybinds', center, color_t( 255, 255, 255, 255 ), true )
end
sv.vars.on_paint.keybinds_list.draggable:set_render_hook( sv.vars.on_paint.keybinds_list.keybinds_renderer )
]]

sv.vars.on_antiaim.freestanding = {}
sv.vars.on_antiaim.freestanding.ran_last_tick = false
sv.vars.on_antiaim.freestanding.peeked = false
sv.vars.on_antiaim.freestanding.side = 0
sv.vars.on_antiaim.freestanding.history = {}

sv.fn.on_antiaim.setup_freestanding_side = function(lp, pEnemy)
    local tableVars = sv.vars.on_antiaim.freestanding
    local target = pEnemy

    if tableVars.ran_last_tick then
        tableVars.ran_last_tick = false
        return
    end

    if not lp or not lp:is_player() or not lp:is_alive() or not target or not target:is_player() or
        not target:is_alive() then
        tableVars.side = 0
        return
    end

    local vecOrigin = lp:get_prop('m_vecAbsOrigin')
    local vecEnemy_origin = target:get_hitbox_pos(e_hitboxes.BODY)

    if not vecOrigin or not vecEnemy_origin then
        tableVars.side = 0
        return
    end

    local vecLp_eye_position = lp:get_eye_position()

    local predict_lp_position = {}

    local damage = {
        left = 0,
        right = 0
    }

    local target_origin = vecEnemy_origin

    local floatAngle = sv.fn.angle_between_vectors(target_origin, vecOrigin).y

    -- local should_do_freestand_trace = trace_bullet( lp:get_hitbox_pos( e_hitboxes.HEAD ), target:get_eye_position( ), target, lp )
    -- local should_do_freestand_trace_right = trace_bullet( lp:get_hitbox_pos( e_hitboxes.HEAD ), target:get_eye_position( ), target, lp )

    -- local should_do_freestand = should_do_freestand_trace.damage > 10 and should_do_freestand_trace.valid
    -- render.line_3d( lp:get_hitbox_pos( e_hitboxes.HEAD ), target:get_eye_position( ), color_t( 255, 255, 255, 255 ) )

    -- if not should_do_freestand then
    -- tableVars.side = 0
    -- sv.vars.on_antiaim.global.freestanding_side = tableVars.side
    -- return
    -- end

    local leftChecks = {}
    local rightChecks = {}

    for trace_n = 1, 2 do
        local fLeft_angle = sv.fn.normalize_yaw(floatAngle - 90)
        local fRight_angle = sv.fn.normalize_yaw(floatAngle + 90)

        for up_down_iter = 1, 3 do
            local vecOrigin_modified = vecOrigin +
                                           vec3_t.new(0, 0, (vecLp_eye_position.z - vecOrigin.z) * (up_down_iter / 2))

            local vecLeft_forwarded = sv.fn.multiply_vector(sv.fn.angle_to_vector(angle_t(0, fLeft_angle, 0)),
                trace_n * 20)
            local vecRight_forwarded = sv.fn.multiply_vector(sv.fn.angle_to_vector(angle_t(0, fRight_angle, 0)),
                trace_n * 20)

            local vecLeft_start = vecOrigin_modified + vecLeft_forwarded
            local vecRight_start = vecOrigin_modified + vecRight_forwarded

            local iFraction_left = trace_line(vecOrigin_modified, vecLeft_start, lp, 0x200400B).fraction - 0.1
            local iFraction_right = trace_line(vecOrigin_modified, vecRight_start, lp, 0x200400B).fraction - 0.1

            vecLeft_start = vecOrigin_modified + sv.fn.multiply_vector(vecLeft_forwarded, iFraction_left)
            vecRight_start = vecOrigin_modified + sv.fn.multiply_vector(vecRight_forwarded, iFraction_right)

            local traceLeft = trace_bullet(vecLeft_start, vecEnemy_origin, lp, target)
            local traceRight = trace_bullet(vecRight_start, vecEnemy_origin, lp, target)

            table.insert(leftChecks, traceLeft.damage > 0 and traceLeft.valid)
            table.insert(rightChecks, traceRight.damage > 0 and traceRight.valid)

            -- render.line_3d( vecLeft_start, vecEnemy_origin, color_t( leftChecks[ up_down_iter ] and 0 or 255, leftChecks[ up_down_iter ] and 255 or 0, 0, 255 ) )
            -- render.line_3d( vecRight_start, vecEnemy_origin, color_t( rightChecks[ up_down_iter ] and 0 or 255, rightChecks[ up_down_iter ] and 255 or 0, 0, 255 ) )

            damage.left = damage.left + (traceLeft.valid and traceLeft.damage or 0)
            damage.right = damage.right + (traceRight.valid and traceRight.damage or 0)
        end
    end

    local bShould_be_zero = false

    for i = 1, #leftChecks do
        if leftChecks[i] and rightChecks[i] then
            bShould_be_zero = true
            break
        end
    end

    if not bShould_be_zero then
        local checks = 0
        for i = 1, #leftChecks do
            if leftChecks[i] == rightChecks[i] then
                checks = checks + 1
            end
        end

        bShould_be_zero = checks == #leftChecks
    end

    if bShould_be_zero or damage.left + damage.right <= 0 then
        tableVars.side = 0
        sv.vars.on_antiaim.global.freestanding_side = tableVars.side
        return
    end

    if damage.left ~= damage.right then
        tableVars.side = damage.left < damage.right and 1 or -1
    else
        tableVars.side = 0
    end

    sv.vars.on_antiaim.global.freestanding_side = tableVars.side

    tableVars.ran_last_tick = true
end

sv.vars.on_antiaim.default_antiaim = {}
sv.vars.on_antiaim.default_antiaim.side = 0
sv.vars.on_antiaim.default_antiaim.conditions = {
    ["STANDING"] = {{
        left = {
            yaw_add = 20, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 15, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 0, -- 0 - 100
            desync_right = 100 -- 0 - 100
        },
        right = {
            yaw_add = -10, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 15, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 0, -- 0 - 100
            desync_right = 100 -- 0 - 100
        },
        neutral = {
            yaw_add = 9, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 30, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 0, -- 0 - 100
            desync_right = 100 -- 0 - 100
        }
    }, {
        left = {
            yaw_add = 20, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 15, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 0 -- 0 - 100
        },
        right = {
            yaw_add = -10, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 15, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 0 -- 0 - 100
        },
        neutral = {
            yaw_add = 9, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 30, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 0 -- 0 - 100
        }
    }},
    ["JUMP+DUCK"] = {{
        left = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 30, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 100 -- 0 - 100
        },
        right = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 30, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 100 -- 0 - 100
        },
        neutral = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 30, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 100 -- 0 - 100
        }
    }},
    ["JUMPING"] = {{
        left = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 18, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 0 -- 0 - 100
        },
        right = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 18, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 0 -- 0 - 100
        },
        neutral = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 18, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 0 -- 0 - 100
        }
    }},
    ["SLOWWALKING"] = {{
        left = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 30, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 100 -- 0 - 100
        },
        right = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 30, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 100 -- 0 - 100
        },
        neutral = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 30, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 100 -- 0 - 100
        }
    }},
    ["MOVING"] = {{
        left = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 40, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 100 -- 0 - 100
        },
        right = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 40, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 100 -- 0 - 100
        },
        neutral = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 40, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 100 -- 0 - 100
        }
    }, {
        left = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 25, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 100 -- 0 - 100
        },
        right = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 25, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 100 -- 0 - 100
        },
        neutral = {
            yaw_add = 4, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 25, -- -180 - 180
            body_lean = 0, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 100 -- 0 - 100
        }
    }},
    ["DUCKING"] = {{
        left = {
            yaw_add = -8, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 23, -- -180 - 180
            body_lean = 1, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 70 -- 0 - 100
        },
        right = {
            yaw_add = -8, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 23, -- -180 - 180
            body_lean = 1, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 70 -- 0 - 100
        },
        neutral = {
            yaw_add = -8, -- -180 - 180
            jitter_mode = 2, -- 1 - 3
            jitter_type = 2, -- 1 - 2
            jitter_add = 23, -- -180 - 180
            body_lean = 1, -- 1 - 5
            body_lean_value = 0, -- -50 50
            moving_body_lean = false, -- true / false
            desync_side = 4, -- 1 - 6
            desync_left = 100, -- 0 - 100
            desync_right = 70 -- 0 - 100
        }
    }}
}

sv.fn.on_antiaim.set_menu_values_for_default_antiaim = function(target)
    if sv.items.selection_AntiAim_modes:get() ~= 1 then
        return
    end
    local side = sv.vars.on_antiaim.global.freestanding_side == -1 and 'left' or
                     sv.vars.on_antiaim.global.freestanding_side == 1 and 'right' or 'neutral'
    local tableCurrent_condition = sv.vars.on_antiaim.default_antiaim.conditions[sv.current_condition]
    local current_settings = tableCurrent_condition[1][side]

    if target then

        if not sv.fn.aa_logger.player_list[tostring(target:get_index())] then
            sv.fn.aa_logger.fn.add_player(target:get_index())
        end
        local current_target_hits = sv.fn.aa_logger.player_list[tostring(target:get_index())].shots.hit +
                                        sv.fn.aa_logger.player_list[tostring(target:get_index())].shots.miss
        local iBruteforce_states = #tableCurrent_condition

        local iBruteforce_state = (current_target_hits % iBruteforce_states) + 1 -- 1
        current_settings = tableCurrent_condition[iBruteforce_state][side]
    end

    sv.aa_ref.pitch:set(2)
    sv.aa_ref.yawbase:set(3)
    sv.aa_ref.yawadd:set(current_settings.yaw_add)
    sv.aa_ref.rotate:set(false)
    sv.aa_ref.rotaterange:set(0)
    sv.aa_ref.rotatespeed:set(0)
    sv.aa_ref.jittermode:set(current_settings.jitter_mode)
    sv.aa_ref.jittertype:set(current_settings.jitter_type)
    sv.aa_ref.jitteramount:set(current_settings.jitter_add)
    sv.aa_ref.leanmode:set(current_settings.body_lean)
    sv.aa_ref.leanvalue:set(current_settings.body_lean_value)
    sv.aa_ref.movinglean:set(current_settings.moving_body_lean)
    sv.aa_ref.movingbl:set(current_settings.moving_body_lean)
    sv.aa_ref.desync_side:set(current_settings.desync_side)
    sv.aa_ref.desyncl:set(current_settings.desync_left)
    sv.aa_ref.desyncr:set(current_settings.desync_right)
    sv.aa_ref.antibf:set(false)
    sv.aa_ref.onshot:set(2)
end

sv.fn.on_antiaim.conditional = function(pitch, yawbase, yawadd, rotate, rotater, rotates, jittermode, jittertype,
    jitteramount, bodylean, bodyleanvalue, desyncside, desyncl, desyncr, onshot)

    sv.aa_ref.pitch:set(pitch)
    sv.aa_ref.yawbase:set(yawbase)
    sv.aa_ref.yawadd:set(yawadd)
    sv.aa_ref.rotate:set(rotate)
    sv.aa_ref.rotaterange:set(rotater)
    sv.aa_ref.rotatespeed:set(rotates)
    sv.aa_ref.jittermode:set(jittermode)
    sv.aa_ref.jittertype:set(jittertype)
    sv.aa_ref.jitteramount:set(jitteramount)
    sv.aa_ref.leanmode:set(bodylean)
    sv.aa_ref.leanvalue:set(bodyleanvalue)
    sv.aa_ref.desync_side:set(desyncside)
    sv.aa_ref.desyncl:set(desyncl)
    sv.aa_ref.desyncr:set(desyncr)
    sv.aa_ref.onshot:set(onshot)

end

-- *Conditional AntiAim
sv.fn.on_antiaim.set_values_conditional_antiaim = function(ctx, target)
    if sv.items.selection_AntiAim_modes:get() ~= 2 then
        return
    end

    local lp = entity_list_get_local_player()
    if engine_is_connected() and engine_is_in_game() and lp and lp:is_player() and lp:is_alive() then

        local ground = lp:has_player_flag(e_player_flags.ON_GROUND)
        local curtime = global_vars_cur_time()
        if not ground then
            condition_calculation.landtime_aa = curtime + 0.1
        end

        local condition = (sv.current_condition == 'MOVING' and not sv.aa_ref.slowwalk_key[2]:get() and
                              sv.conditional_settings["moving"].checkbox_enable_state:get()) and 'moving' or
                              (sv.current_condition == 'DUCKING' and
                                  sv.conditional_settings["ducking"].checkbox_enable_state:get()) and 'ducking' or
                              (sv.current_condition == 'JUMPING' and
                                  sv.conditional_settings["air"].checkbox_enable_state:get()) and 'air' or
                              (sv.current_condition == 'JUMP+DUCK' and
                                  sv.conditional_settings["air duck"].checkbox_enable_state:get()) and 'air duck' or
                              (sv.current_condition == 'SLOWWALKING' and sv.aa_ref.slowwalk_key[2]:get() and
                                  sv.conditional_settings["slowwalking"].checkbox_enable_state:get()) and 'slowwalking' or
                              'standing / global'

        -- client_log_screen("Condition: " .. condition)
        -- * Here I am setting default values to make configing easier, once the setting in aasettings is enabled, it will use the configured value.
        if not sv.conditional_settings[condition].multiselect_aasettings:get("Pitch") then
            sv.pitch = 2
        elseif sv.conditional_settings[condition].multiselect_aasettings:get("Pitch") then
            sv.pitch = sv.conditional_settings[condition].selection_pitch:get()
        end

        if not sv.conditional_settings[condition].multiselect_aasettings:get("Yaw base") then
            sv.yawbase = 3
        elseif sv.conditional_settings[condition].multiselect_aasettings:get("Yaw base") then
            sv.yawbase = sv.conditional_settings[condition].selection_yawbase:get()
        end

        if not sv.conditional_settings[condition].multiselect_aasettings:get("Yaw add") then
            sv.yawadd = 0
        elseif sv.conditional_settings[condition].multiselect_aasettings:get("Yaw add") then
            sv.yawadd = sv.conditional_settings[condition].slider_yawadd:get()
        end

        if not sv.conditional_settings[condition].multiselect_aasettings:get("Rotate") then
            sv.rotate = false
        elseif sv.conditional_settings[condition].multiselect_aasettings:get("Rotate") then
            sv.rotate = sv.conditional_settings[condition].checkbox_rotate:get()
        end

        if not sv.conditional_settings[condition].multiselect_aasettings:get("Jitter") then
            sv.jittermode = 0
        elseif sv.conditional_settings[condition].multiselect_aasettings:get("Jitter") then
            sv.jittermode = sv.conditional_settings[condition].selection_jittermode:get()
        end

        if not sv.conditional_settings[condition].multiselect_aasettings:get("Body lean") then
            sv.bodylean = 0
        elseif sv.conditional_settings[condition].multiselect_aasettings:get("Body lean") then
            sv.bodylean = sv.conditional_settings[condition].selection_bodylean:get()
        end

        local rotaterange = sv.conditional_settings[condition].slider_rotaterange:get()
        local rotatespeed = sv.conditional_settings[condition].slider_rotatespeed:get()
        local jittermode = sv.conditional_settings[condition].selection_jittermode:get()
        local jittertype = sv.conditional_settings[condition].selection_jittertype:get()
        local jitteramount = sv.conditional_settings[condition].slider_jitteramount:get()
        -- local bodylean = conditional_settings[current_condition].selection_bodylean:get()
        local bodyleanvalue = sv.conditional_settings[condition].slider_bodyleanvalue:get()
        local desyncside = sv.conditional_settings[condition].selection_desyncside:get()
        local desyncl = sv.conditional_settings[condition].slider_desyncl:get()
        local desyncr = sv.conditional_settings[condition].slider_desyncr:get()
        local onshot = sv.conditional_settings[condition].selection_onshot:get()

        if target and sv.items.checkbox_antibfenable:get() then
            if not sv.fn.aa_logger.player_list[tostring(target:get_index())] then
                sv.fn.aa_logger.fn.add_player(target:get_index())
            end

            local t_target_data = sv.fn.aa_logger.player_list[tostring(target:get_index())]

            local invert_hit, invert_miss = t_target_data.bruteforce_data.invert_hit,
                t_target_data.bruteforce_data.invert_miss
            local randomize_hit, randomize_miss, hit_desync, miss_desync = t_target_data.bruteforce_data.randomize_hit,
                t_target_data.bruteforce_data.randomize_miss, t_target_data.bruteforce_data.randomized_hit_desync,
                t_target_data.bruteforce_data.randomized_miss_desync

            -- {"Invert on Hit", "Invert on enemy miss", "Randomize desync on Hit", "Randomize desync on enemy Miss"}
            if ((sv.items.selection_antibfmode:get() == 2 and sv.items.multiselect_antibfextras:get('Invert on Hit')) and
                invert_hit) or
                ((sv.items.selection_antibfmode:get() == 2 and
                    sv.items.multiselect_antibfextras:get('Invert on enemy miss')) and invert_miss) then
                ctx:set_invert_desync(invert_hit or invert_miss)
            end

            if ((sv.items.selection_antibfmode:get() == 2 and
                sv.items.multiselect_antibfextras:get('Randomize desync on Hit')) or
                (sv.items.selection_antibfmode:get() == 1)) and randomize_hit then
                desyncl = hit_desync * 100
                desyncr = hit_desync * 100
            elseif ((sv.items.selection_antibfmode:get() == 2 and
                sv.items.multiselect_antibfextras:get('Randomize desync on enemy Miss')) or
                (sv.items.selection_antibfmode:get() == 1)) and randomize_miss then
                desyncl = miss_desync * 100
                desyncr = miss_desync * 100
            end
        end

        sv.fn.on_antiaim.conditional(sv.pitch, sv.yawbase, sv.yawadd, sv.rotate, rotaterange, rotatespeed, jittermode,
            jittertype, jitteramount, sv.bodylean, bodyleanvalue, desyncside, desyncl, desyncr, onshot)
    end
end

-- * Deagle after jump accuracy
local was_on_ground = nil
local restore = {
    hc = nil,
    sp = sv.rb_ref.sp
    -- force_sp_state = sv.rb_ref.sp_condition:get(),
}

sv.fn.was_on_ground_setupcmd = function()
    local lp = entity_list_get_local_player()
    was_on_ground = lp:has_player_flag(e_player_flags.ON_GROUND)
end

sv.fn.deagle_after_jump_accuracy = function(cmd, unpredicted_data)
    local lp = entity_list_get_local_player()
    local wep = lp:get_active_weapon()
    if not wep or not lp then
        return
    end
    local accPenalty = wep:get_prop('m_fAccuracyPenalty')

    if sv.items.checkbox_deagle_nospread_stuff:get() and was_on_ground == false and
        lp:has_player_flag(e_player_flags.ON_GROUND) and wep:get_weapon_data().console_name == "weapon_deagle" then

        local inaccuracy = math.floor(lp:get_active_weapon():get_weapon_inaccuracy() * 1000) / 10

        sv.fn.do_the_hitchance_stuff = function(ctx)
            ctx:set_hitchance(0)
        end

        -- client.log_screen(accPenalty, inaccuracy)

    else

        sv.fn.do_the_hitchance_stuff = function(ctx)

        end
    end
end

-- * Force sp after X misses
local sp_tbl = {
    misses = 0,
    time = 0
}

sv.fn.hello_i_miss_shot = function(ctx)
    sp_tbl.misses = sp_tbl.misses + 1
    sp_tbl.time = global_vars_real_time() + sv.items.slider_reset_after_X_seconds:get()
end

sv.fn.execute_force_sp_after_X_misses = function()
    if not sv.items.checkbox_force_sp_after_X_shots:get() then
        return
    end

    local miss_slider = sv.items.slider_enable_after_X_misses:get()
    local reset_slider = sv.items.slider_reset_after_X_seconds:get()
    if reset_slider == 0 then
        return
    end

    if sv.items.checkbox_force_sp_after_X_shots:get() then

        if sp_tbl.misses >= miss_slider then
            -- client_log_screen("enabled")

            sv.fn.force_the_safepoints_pls = function(ctx)

                -- Force safepoints on all hitboxes if misses > slider
                ctx:set_safepoint_state(true)

            end
        end

        if global_vars_real_time() > (sp_tbl.time + reset_slider) then -- or event.name == "round_start"
            -- Reset the misses
            sp_tbl.misses = 0

            -- Reset the safepoint states
            sv.fn.force_the_safepoints_pls = function(ctx)
                ctx:set_safepoint_state(false)
            end

            return
        end
    end
end

-- * Edge yaw
sv.edge_yaw.vec_trace_start = vec3_t(0, 0, 0)
sv.edge_yaw.enabled = false

sv.edge_yaw.debug = {}
sv.edge_yaw.debug.edge_pos = vec3_t(0, 0, 0)
sv.edge_yaw.debug.edge_angle = angle_t(0, 0, 0)

sv.edge_yaw.fn = {}

render.circle_3d = function(vec3_t_pos, radius, color)
    local screen_pos = render_world_to_screen(vec3_t_pos)
    if not screen_pos then
        return
    end

    render_circle(screen_pos, radius, color)
end

sv.edge_yaw.fn.fix_yaw = function(yaw)
    while yaw > 180 do
        yaw = yaw - 360
    end
    while yaw < -180 do
        yaw = yaw + 360
    end
    return yaw
end

sv.edge_yaw.fn.multiply_vector = function(vec, mul)
    return vec3_t(vec.x * mul, vec.y * mul, vec.z * mul)
end

sv.edge_yaw.fn.lerp_vector = function(vecSource, vecDestination, flPercentage)
    return vecSource + sv.edge_yaw.fn.multiply_vector((vecDestination - vecSource), flPercentage)
end

sv.edge_yaw.fn.angle_to_vector = function(angle)
    return vec3_t(math.cos(angle.y) * math.cos(angle.x), math.sin(angle.y) * math.cos(angle.x), math.sin(angle.x))
end

sv.edge_yaw.fn.vector_to_angle = function(vec)
    return angle_t(math.atan2(vec.y, vec.x), math.asin(vec.z), 0)
end

-- edge_yaw.fn.menu_visibility = function( )
-- items.multiselect_edge_yaw_settings:set_visible( items.checkbox_edge_yaw_enable:get( ) )
-- end

sv.edge_yaw.fn.paint_edge_yaw = function()
    -- edge_yaw.fn.menu_visibility( )
    sv.edge_yaw.enabled = false

    if not sv.items.checkbox_edge_yaw_enable:get() then
        return
    end

    -- local draw_debug = items.multiselect_edge_yaw_settings:get( 2 )

    local lp = entity_list_get_local_player()
    if not engine_is_connected() or not lp then
        return
    end

    sv.edge_yaw.vec_trace_start = lp:get_eye_position()
    if engine_get_choked_commands() == 0 then
        sv.edge_yaw.vec_trace_start = lp:get_eye_position()
    end

    local trace_end = {}

    local viewangles = engine_get_view_angles()

    for yaw_iteration = 20, 360, 20 do
        yaw_iteration = sv.edge_yaw.fn.fix_yaw(yaw_iteration)

        local yaw_iteration_rad = math.rad(yaw_iteration)
        local edge_angle = angle_t(0, yaw_iteration_rad, 0)

        local forwarded_angle = sv.edge_yaw.fn.angle_to_vector(edge_angle)
        local vec_trace_end = sv.edge_yaw.vec_trace_start + sv.edge_yaw.fn.multiply_vector(forwarded_angle, 40)

        local trace_info = trace.line(sv.edge_yaw.vec_trace_start, vec_trace_end, lp, 0x200400B)

        local fraction = trace_info.fraction
        local hit_entity = trace_info.entity

        if hit_entity and hit_entity:get_class_name() == 'CWorld' and fraction < 0.9 then
            trace_end[#trace_end + 1] = {
                vec_trace_end = vec_trace_end,
                yaw_deg = yaw_iteration
            }
        end
    end

    table.sort(trace_end, function(a, b)
        return a.yaw_deg < b.yaw_deg
    end)

    local edge_angle

    -- find the middle of trace_end and set the viewangles to that
    if #trace_end > 2 then
        local middle_pos = sv.edge_yaw.fn.lerp_vector(trace_end[1].vec_trace_end, trace_end[#trace_end].vec_trace_end,
            0.5)
        edge_angle = sv.edge_yaw.fn.vector_to_angle(middle_pos - sv.edge_yaw.vec_trace_start)

        sv.edge_yaw.enabled = true
        sv.edge_yaw.debug.edge_pos = middle_pos
        sv.edge_yaw.debug.edge_angle = edge_angle
    end
end

local enemypos = 0
sv.edge_yaw.fn.antiaim_edge_yaw = function(ctx, cmd, unpredicted)
    if not sv.items.checkbox_edge_yaw_enable:get() then
        return
    end

    local lp = entity_list_get_local_player()

    -- check if enemy can hit our head
    local enemy_can_hit = false

    for _, enemy in pairs(entity_list_get_players(true)) do
        if not enemy or not enemy:is_player() then
            goto continue
        end
        enemypos = enemy:get_eye_position()

        local trace = trace_bullet(lp:get_hitbox_pos(e_hitboxes.HEAD), enemypos, enemy, lp)
        if trace.valid and trace.damage > 20 then
            enemy_can_hit = true
            break
        end

        ::continue::
    end

    if not lp or not sv.edge_yaw.enabled or enemy_can_hit then
        return
    end

    local normalised_edge_pos = sv.edge_yaw.debug.edge_pos - lp:get_eye_position()
    local angle = sv.edge_yaw.fn.vector_to_angle(normalised_edge_pos)
    local raw_edgeyaw_in_degrees = math.deg(angle.x)
    local new_yaw = raw_edgeyaw_in_degrees

    local viewangle_yaw = cmd.viewangles.y
    local angle_difference = sv.edge_yaw.fn.fix_yaw(raw_edgeyaw_in_degrees - viewangle_yaw)

    new_yaw = sv.edge_yaw.fn.fix_yaw(raw_edgeyaw_in_degrees + angle_difference)

    -- we dont want to show our head when looking away from wall
    local difference = math.abs(sv.fn.normalize_yaw(raw_edgeyaw_in_degrees - viewangle_yaw))

    if difference > 90 then
        new_yaw = sv.edge_yaw.fn.fix_yaw(raw_edgeyaw_in_degrees)
    else
        -- if we arent looking away from wall, do the skeet edge yaw thing
        local start_left = lp:get_render_origin() + vec3_t(0, 0, 20) +
                               sv.edge_yaw.fn.multiply_vector(
                sv.edge_yaw.fn.angle_to_vector(angle_t(0, math.rad(sv.fn.normalize_yaw(viewangle_yaw + 90)), 0)), 10)
        local end_left = start_left + sv.edge_yaw.fn.multiply_vector(
            sv.edge_yaw.fn.angle_to_vector(angle_t(0, math.rad(sv.fn.normalize_yaw(viewangle_yaw)), 0)), 40)

        local start_right = lp:get_render_origin() + vec3_t(0, 0, 20) +
                                sv.edge_yaw.fn.multiply_vector(
                sv.edge_yaw.fn.angle_to_vector(angle_t(0, math.rad(sv.fn.normalize_yaw(viewangle_yaw - 90)), 0)), 10)
        local end_right = start_right + sv.edge_yaw.fn.multiply_vector(
            sv.edge_yaw.fn.angle_to_vector(angle_t(0, math.rad(sv.fn.normalize_yaw(viewangle_yaw)), 0)), 40)

        local fraction_left = trace.line(start_left, end_left, lp, 0x200400B).fraction
        local fraction_right = trace.line(start_right, end_right, lp, 0x200400B).fraction

        if fraction_left < 0.9 and fraction_right >= 0.95 then
            new_yaw = sv.edge_yaw.fn.fix_yaw(new_yaw + 35)
        elseif fraction_right < 0.9 and fraction_left >= 0.95 then
            new_yaw = sv.edge_yaw.fn.fix_yaw(new_yaw - 35)
        end
    end

    ctx:set_yaw(new_yaw)
end

sv.callbacks.on_paint = function()
    local lp = entity_list_get_local_player()
    sv.fn.handle_menu()

    libs.notifications.render()

    sv.fn.on_paint.condition_calc()
    sv.fn.on_paint.calculate_desync()
    sv.fn.on_paint.render_amazing_dt_indicator(lp)
    sv.fn.on_paint.render_crosshair_indicators(lp)
    sv.fn.on_antiaim.setup_freestanding_side(lp, sv.vars.on_antiaim.at_targets.target)

    sv.fn.aa_logger.fn.handle_playerlist(lp)
    -- sv.fn.aa_logger.fn.render_playerlist( )

    sv.edge_yaw.fn.paint_edge_yaw()

    sv.fn.on_paint.hitlogs()
    sv.fn.on_paint.on_clantag(lp)

    sv.fn.debug.handle_lines()

    sv.vars.on_paint.watermark.draggable:handle_drawing()
    sv.vars.info_panel.draggable:handle_drawing()
    -- sv.vars.on_paint.keybinds_list.draggable:handle_drawing( )
end

sv.callbacks.on_antiaim = function(ctx, cmd, unpredicted)
    local lp = entity_list_get_local_player()
    sv.fn.on_antiaim.anims_2018(ctx, cmd, lp)

    if not sv.items.checkbox_aaenable:get() or not lp then
        return
    end

    local yaw_calc_mode = sv.items.selection_antiaim_target_selection_mode:get_item_name(sv.items
                                                                                             .selection_antiaim_target_selection_mode:get())

    sv.fn.on_antiaim.get_at_targets_yaw(cmd, yaw_calc_mode, lp)

    sv.fn.on_antiaim.setup_freestanding_side(lp, sv.vars.on_antiaim.at_targets.target)

    sv.fn.on_antiaim.set_menu_values_for_default_antiaim(sv.vars.on_antiaim.at_targets.target)
    sv.fn.on_antiaim.set_values_conditional_antiaim(ctx, sv.vars.on_antiaim.at_targets.target)

    sv.edge_yaw.fn.antiaim_edge_yaw(ctx, cmd, unpredicted)

end

sv.callbacks.on_setup_command = function()
    sv.fn.aa_logger.update_stored_bt_pos()

    sv.fn.was_on_ground_setupcmd()
end

sv.callbacks.on_run_command = function(unpredicted_data)
    sv.fn.deagle_after_jump_accuracy(unpredicted_data)
    sv.fn.execute_force_sp_after_X_misses()
end

sv.callbacks.on_hitscan = function(ctx)
    sv.fn.do_the_hitchance_stuff(ctx)

    if sv.fn.force_the_safepoints_pls ~= nil then
        sv.fn.force_the_safepoints_pls(ctx)
    end
end

sv.callbacks.on_aimbot_hit = function(ctx)
    sv.fn.on_aimbot_hit.add_hitlog(ctx)
end

sv.callbacks.on_aimbot_miss = function(ctx)
    sv.fn.on_aimbot_miss.add_hitlog(ctx)
    sv.fn.hello_i_miss_shot(ctx)
end

sv.callbacks.on_event = function(event)
    sv.fn.aa_logger.on_event(event)

    -- if event.name == "round_start" then
    -- sv.fn.execute_force_sp_after_X_misses( event )
    -- end
end

sv.callbacks.on_net_update = function()
    sv.fn.on_net_update.watermark_update_net()
end

libs.autocallbacks.setup_callbacks(sv.callbacks)

-- config shit
local config = {}

ffi.cdef [[
    typedef void*(__thiscall* shell_execute_t)(void*, const char*, const char*);
]]

config.ffi = {}
config.ffi.class_ptr = ffi.typeof('void***')
config.ffi.rawvguisystem = memory_create_interface('vgui2.dll', 'VGUI_System010') or
                               error('VGUI_System010 wasn\'t found', 2)
config.ffi.ivguisystem = ffi.cast(config.ffi.class_ptr, config.ffi.rawvguisystem) or error('rawvguisystem is nil', 2)
config.ffi.shell_execute = ffi.cast("shell_execute_t", config.ffi.ivguisystem[0][3]) or error('shell_execute is nil', 2)

config.ffi.__thiscall = function(func, this)
    return function(...)
        return func(this, ...)
    end
end

config.ffi.vmt_bind = function(module, interface, index, typedef)
    local addr = ffi.cast('void***', memory_create_interface(module, interface)) or error(interface .. ' is nil.')
    return config.ffi.__thiscall(ffi.cast(typedef, addr[0][index]), addr)
end

config.ffi.native_GetCurrentDirectory = config.ffi.vmt_bind('filesystem_stdio.dll', 'VFileSystem017', 40,
    'bool(__thiscall*)(void*, char*, int)')

config.ffi.char = ffi.new("char[256]")
config.ffi.native_GetCurrentDirectory(config.ffi.char, ffi.sizeof(config.ffi.char))

config.path = string.format('%s/csgo/eclipse/', ffi.string(config.ffi.char))

config.fn = {}
config.fn.load = function()
    config.fn.refresh()

    local config_name = config.selection:get_active_item_name()

    if config_name == '' or not config_name then
        libs.notifications.create('Config loading failed!', 'Config not selected!', libs.notifications.types.failure)
        client_log('Config loading failed! Config not selected!')
        return
    end

    local exists = libs.file_system.fn.exists('eclipse/' .. config_name, 'GAME')

    if not exists then
        libs.notifications.create('Config loading failed!', 'Config \'' .. config_name .. '\' not found!',
            libs.notifications.types.failure)
        client_log('Config loading failed! Config \'' .. config_name .. '\' not found!')
        return
    end

    local file = libs.file_system.fn.open('eclipse/' .. config_name, 'r', 'GAME')

    local config_data_json = file:read()
    file:close()

    local ok, error = pcall(function()
        libs.json.json_parse(config_data_json)
    end)

    if not ok then
        libs.notifications.create('Config loading failed!',
            'Config \'' .. config_name .. '\' is not a valid eclipse config!', libs.notifications.types.failure)
        client_log('Config loading failed! Config \'' .. config_name .. '\' is not a valid eclipse config!')
        return
    end

    local config_table = libs.json.json_parse(config_data_json)

    if config_table == nil then
        libs.notifications.create('Config loading failed!', 'Config \'' .. config_name .. '\' is invalid!',
            libs.notifications.types.failure)
        client_log('Config loading failed! Config \'' .. config_name .. '\' is invalid!')
        return
    end

    -- loading main config settings
    if config_table['main_config'] then
        for name, _ in pairs(config_table['main_config']) do
            if not name:find('seperator') and sv.items[name] then
                local menu_elem = sv.items[name]

                if name:find('multiselect_') and sv.items[name] then
                    local stuff_inside_multiselect = menu_elem:get_items()
                    local stuff_inside_multiselect_data = config_table['main_config'][name]
                    -- print( menu_elem )
                    for i, item in pairs(stuff_inside_multiselect) do
                        local data = stuff_inside_multiselect_data[i]
                        if data == nil then
                            data = false
                        end
                        menu_elem:set(i, data)
                    end
                elseif not name:find('color') and config_table['main_config'][name] then
                    local other_elements_data = config_table['main_config'][name]
                    menu_elem:set(other_elements_data)
                end
            end
        end
    elseif not config_table['main_config'] then
        libs.notifications.create('Config loading warning!', 'Did not find main config settings.',
            libs.notifications.types.warning)
        client_log('Config loading warning! Did not find main config settings.')
    end

    -- loading colors config settings
    for color_table_name, color_table in pairs(sv.colors) do
        for name, menu_elem in pairs(color_table) do
            if config_table['colors_config'][color_table_name][name] then
                local color = config_table['colors_config'][color_table_name][name]
                menu_elem:set(color_t(color[1], color[2], color[3], color[4]))
            end
        end
    end

    -- loading conditional_settings config settings
    if config_table['conditionalsettings_config'] then
        for condition_name, _ in pairs(config_table['conditionalsettings_config']) do
            if condition_name and sv.conditional_settings[condition_name] then
                local condition_table = config_table['conditionalsettings_config'][condition_name]
                for name, _ in pairs(condition_table) do
                    if sv.conditional_settings[condition_name][name] then
                        local menu_elem = sv.conditional_settings[condition_name][name]
                        if not name:find('seperator') then
                            if name:find('multiselect_') then
                                local stuff_inside_multiselect = menu_elem:get_items()
                                local stuff_inside_multiselect_data =
                                    config_table['conditionalsettings_config'][condition_name][name]
                                for i, item in pairs(stuff_inside_multiselect) do
                                    menu_elem:set(i, stuff_inside_multiselect_data[i])
                                end
                            else
                                local jitter_data = config_table['conditionalsettings_config'][condition_name][name]
                                menu_elem:set(jitter_data)
                            end
                        end
                    end
                end
            end
        end
    elseif not config_table['conditionalsettings_config'] then
        libs.notifications.create('Config loading warning!', 'Did not find conditionals config settings.',
            libs.notifications.types.warning)
        client_log('Config loading warning! Did not find conditionals config settings.')
    end

    if config_table['draggables_config'] then
        if config_table['draggables_config']['watermark'] then
            local draggable = sv.vars.on_paint.watermark.draggable
            local watermark_entries = draggable.interaction_menu.menu_t.menu_elements

            for i = 1, #watermark_entries do
                local option = watermark_entries[i]
                local new_val = config_table['draggables_config']['watermark'][i]
                option:set(new_val)
            end
        end

        if config_table['draggables_config']['information-panel'] then
            local draggable = sv.vars.info_panel.draggable
            local information_panel_entries = draggable.interaction_menu.menu_t.menu_elements

            for i = 1, #information_panel_entries do
                local option = information_panel_entries[i]
                local new_val = config_table['draggables_config']['information-panel'][i]
                option:set(new_val)
            end
        end
    elseif not config_table['draggables_config'] then
        libs.notifications.create('Config loading warning!', 'Did not find draggables config settings.',
            libs.notifications.types.warning)
        client_log('Config loading warning! Did not find draggables config settings.')
    end

    local config_specifications_text = 'all settings'

    libs.notifications.create('Config loaded!',
        'Loaded ' .. config_specifications_text .. ' from \'' .. config_name .. '\'.', libs.notifications.types.success)
    client_log('Config loaded! Loaded ' .. config_specifications_text .. ' from \'' .. config_name .. '\'.')
end

config.fn.save = function()
    config.fn.refresh()

    -- if config name is empty dont execute further, just notify the user
    local config_name = config.name:get()
    if config_name == '' then
        config_name = config.selection:get_active_item_name()
    else
        config_name = config_name .. '.eclipse'
    end

    if config_name == '' then
        libs.notifications.create('Config loading failed!', 'Config name can not be empty!',
            libs.notifications.types.failure)
        client_log('Config loading failed! Config name can not be empty!')
        return
    end

    -- check if config/dir already exists
    -- if not, create dir
    local exists = libs.file_system.fn.exists('eclipse/' .. config_name, 'GAME')

    if not exists then
        libs.file_system.fn.create_directory('eclipse', 'GAME')
    end

    -- create/load file
    local file = libs.file_system.fn.open('eclipse/' .. config_name, 'w', 'GAME')

    -- getting config data
    -- global data
    local global_config = {}

    -- saving main config settings
    local main_config = {}
    for name, menu_elem in pairs(sv.items) do
        if not name:find('seperator') then
            if name:find('multiselect_') then
                local stuff_inside_multiselect = menu_elem:get_items()
                local stuff_inside_multiselect_data = {}
                for i, item in pairs(stuff_inside_multiselect) do
                    stuff_inside_multiselect_data[i] = menu_elem:get(i)
                end
                main_config[name] = stuff_inside_multiselect_data
            elseif name:find('keybind_') then
                main_config[name] = menu_elem:get_key()
            elseif not name:find('color') then
                local other_elements_data = menu_elem:get()
                main_config[name] = other_elements_data
            end
        end
    end

    -- appending main config data to global config with key 'main_config'
    global_config['main_config'] = main_config

    -- saving colors config settings
    local colors_config = {}
    for color_table_name, color_table in pairs(sv.colors) do
        colors_config[color_table_name] = {}
        for name, menu_elem in pairs(color_table) do
            local color = menu_elem:get()
            colors_config[color_table_name][name] = {color.r, color.g, color.b, color.a}
        end
    end

    -- appending colors config data to global config with key 'colors_config'
    global_config['colors_config'] = colors_config

    -- saving conditional config settings
    local conditionalsettings_config = {}
    for condition_name, table in pairs(sv.conditional_settings) do
        conditionalsettings_config[condition_name] = {}
        for name, menu_elem in pairs(table) do
            if not name:find('seperator') then
                if name:find('multiselect_') then
                    local stuff_inside_multiselect = menu_elem:get_items()
                    local stuff_inside_multiselect_data = {}
                    for i, _ in pairs(stuff_inside_multiselect) do
                        stuff_inside_multiselect_data[i] = menu_elem:get(i)
                    end
                    conditionalsettings_config[condition_name][name] = stuff_inside_multiselect_data
                else
                    local jitter_data = menu_elem:get()
                    conditionalsettings_config[condition_name][name] = jitter_data
                end
            end
        end
    end

    -- appending conditional_settings config data to global config with key 'conditionalsettings_config'
    global_config['conditionalsettings_config'] = conditionalsettings_config

    local draggables_config = {}
    draggables_config['watermark'] = {}
    local watermark = sv.vars.on_paint.watermark.draggable
    local watermark_entries = watermark.interaction_menu.menu_t.menu_elements

    for i = 1, #watermark_entries do
        local option = watermark_entries[i]
        draggables_config['watermark'][i] = option:get()
    end

    draggables_config['information-panel'] = {}
    local info_panel = sv.vars.info_panel.draggable
    local infopanel_entries = info_panel.interaction_menu.menu_t.menu_elements

    for i = 1, #infopanel_entries do
        local option = infopanel_entries[i]
        draggables_config['information-panel'][i] = option:get()
    end

    global_config['draggables_config'] = draggables_config

    local json_data = libs.json.encode(global_config)

    -- saving config to file
    file:write(json_data)
    file:close()

    libs.notifications.create('Config saved!', 'Config \'' .. config_name .. '\' saved!',
        libs.notifications.types.success)
    client_log('Config saved! Config \'' .. config_name .. '\' saved!')
end

config.fn.refresh = function()
    config.configs = libs.search_file_system.fn.list_files('./csgo/eclipse/')
    config.selection:set_items(config.configs)
end

config.fn.delete = function()
    local config_name = config.selection:get_active_item_name()

    if config_name == '' or not config_name then
        libs.notifications.create('Config deleting failed!', 'Config not selected!', libs.notifications.types.failure)
        client_log('Config deleting failed! Config not selected!')
        return
    end

    libs.file_system.fn.remove('eclipse/' .. config_name, 'GAME')
    libs.notifications.create('Config deleted!', 'Config \'' .. config_name .. '\' deleted!',
        libs.notifications.types.success)
    client_log('Config deleted! Config \'' .. config_name .. '\' deleted!')
    config.fn.refresh()
end

config.fn.create = function()
    -- if config name is empty dont execute further, just notify the user
    local config_name = config.name:get()
    if config_name == '' then
        config_name = config.selection:get_active_item_name()
    else
        config_name = config_name .. '.eclipse'
    end

    if config_name == '' then
        libs.notifications.create('Config loading failed!', 'Config name can not be empty!',
            libs.notifications.types.failure)
        client_log('Config loading failed! Config name can not be empty!')
        return
    end

    -- check if config/dir already exists
    -- if not, create dir
    local exists = libs.file_system.fn.exists('eclipse/' .. config_name, 'GAME')

    if exists then
        libs.notifications.create('Config creating failed!', 'Config \'' .. config_name .. '\' already exists!',
            libs.notifications.types.failure)
        client_log('Config creating failed! Config \'' .. config_name .. '\' already exists!')
        return
    end

    -- create file
    libs.file_system.fn.open('eclipse/' .. config_name, 'w', 'GAME'):close()

    -- save current fig to config
    config.fn.save()

    -- refresh fig list
    config.fn.refresh()
end

config.fn.open_folder = function()
    config.ffi.shell_execute(config.ffi.ivguisystem, 'open', config.path)
end

config.configs = libs.search_file_system.fn.list_files(config.path)

config.selection = menu_add_list('Configs', 'Configs', config.configs)
config.open_folder_mn = menu_add_button('Configs', 'Open configs folder', config.fn.open_folder)
menu_add_separator('Configs')
config.refresh = menu_add_button('Configs', 'Refresh list', config.fn.refresh)
config.save = menu_add_button('Configs', 'Save selected', config.fn.save)
config.load = menu_add_button('Configs', 'Load selected', config.fn.load)
config.delete = menu_add_button('Configs', 'Delete selected', config.fn.delete)
menu_add_separator('Configs')
config.name = menu_add_text_input('Configs', 'Config name')
config.create = menu_add_button('Configs', 'Create config by name', config.fn.create)
menu_set_group_column("Configs", 1)

-- create directory on lua load
local exists = libs.file_system.fn.exists('eclipse/README.txt', 'GAME')
if not exists then
    libs.file_system.fn.create_directory('eclipse', 'GAME')
end

if not config.name:get() == '' then
    config.fn.load()
end

-- group sides
menu_set_group_column("Main", 1)
menu_set_group_column("Crosshair Indicators", 2)
menu_set_group_column("Visuals", 2)
menu_set_group_column("Anti-Aim", 3)
menu_set_group_column("Conditional", 3)
menu_set_group_column("Configs", 1)

if not beta then
    menu_add_button('Main', 'Join our Discord', function()
        config.ffi.shell_execute(config.ffi.ivguisystem, 'open', 'https://discord.gg/TcCUBpmpCp')
    end)
end