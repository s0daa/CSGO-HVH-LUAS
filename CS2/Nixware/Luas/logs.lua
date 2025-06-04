local config = {
    hit_logs = true,
    harm_logs = true,
    hit_color = color_t(0.3, 1, 0.3, 1),
    harm_color = color_t(1, 0.3, 0.3, 1),
    y_offset = 100
}

local log = {}
local logs = {}

math.calculate_count = function(text, search)
    local count = 0
    for i = 1, #text do
        if text:sub(i, i) == search then
            count = count + 1
        end
    end
    return count
end

render.shadow_text = function(text, font, pos, color, size)
    pos.y = pos.y + 0.5
    render.text(text, font, pos + 1, color_t(0, 0, 0, color.a), size)
    render.text(text, font, pos, color, size)
end

local string_to_color = {
    ["white"] = color_t(1, 1, 1, 1),
    ["black"] = color_t(0, 0, 0, 1),
    ["hit"] = config.hit_color,
    ["harm"] = config.harm_color,
}

local m_sSanitizedPlayerName = engine.get_netvar_offset("client.dll", "CCSPlayerController", "m_sSanitizedPlayerName");
local m_nTickBase = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_nTickBase");

log.print = function(text, prefix_color)
    print("[nixware] \0", string_to_color[prefix_color])
    local string = text
    local full_text = ""
    local colored_text = {}
    for i = 1, math.calculate_count(string, "{") do
        local start_prefix = string:find("{")
        local end_prefix = string:find("}")
        local color = string:sub(start_prefix + 1, end_prefix - 1)
        local next_string = string:sub(end_prefix + 1)
        local next_prefix_start = next_string:find("{")
        local new_string = next_prefix_start and next_string:sub(1, next_prefix_start - 1) or next_string
        string = next_string
        print(new_string .. "\0", string_to_color[color])
        full_text = full_text .. new_string
        table.insert(colored_text, { text = new_string, color = string_to_color[color] })
    end
    print("")
    table.insert(logs, 1, { alpha = 0, tick_base = ffi.cast("int*", entitylist.get_local_player_controller()[m_nTickBase])[0] + (3 / 0.015625), full_text = full_text, colored_text = colored_text })
end

math.lerp = function(a, b, time)
    return a + (b - a) * time
end

local font = {render.setup_font("C:/windows/fonts/verdana.ttf", 11, 400), 11}

log.render = function()
    local offset = 0
    for i, v in pairs(logs) do
        local tick_base = ffi.cast("int*", entitylist.get_local_player_controller()[m_nTickBase])[0]
        if tick_base < v.tick_base and i <= 10 then
            v.alpha = math.lerp(v.alpha, 1, 0.13)
        else
            v.alpha = math.lerp(v.alpha, 0, 0.13)
            if v.alpha < 0.1 then
                table.remove(logs, i)
            end
        end
        local text_size = 0
        local screen_size = render.screen_size()
        local pos = vec2_t(screen_size.x / 2 - render.calc_text_size(v.full_text, font[1], font[2]).x / 2, screen_size.y / 2 + config.y_offset)
        for k, f in pairs(v.colored_text) do
            f.color.a = v.alpha
            render.shadow_text(f.text, font[1], vec2_t(pos.x + text_size, pos.y + offset), f.color, font[2])
            text_size = text_size + render.calc_text_size(f.text, font[1], font[2]).x
        end
        offset = offset + 16 * v.alpha
    end
end

local hitgroups = {
    [0] = "generic",
    [1] = "head",
    [2] = "chest",
    [3] = "stomach",
    [4] = "left arm",
    [5] = "right arm",
    [6] = "left leg",
    [7] = "right leg",
    [8] = "neck"
}

log.player_hurt = function(event)
    local local_player = entitylist.get_local_player_controller()
    if not local_player then return end
    local attacker = event:get_controller("attacker")
    local attacker_name = "World"
    if attacker then
        attacker_name = ffi.string(ffi.cast("char**", attacker[m_sSanitizedPlayerName])[0])
    end
    local target = event:get_controller("userid")
    if not target then return end
    local target_name = ffi.string(ffi.cast("char**", target[m_sSanitizedPlayerName])[0])
    local remaining = event:get_int("health")
    local damage = event:get_int("dmg_health")
    local hitgroup = hitgroups[event:get_int("hitgroup")]
    local self_harm = false
    if attacker == local_player and target == local_player then
        self_harm = true
        attacker_name = "yourself"
    end
    local is_fatal = remaining == 0
    if target == local_player and config.harm_logs then
        local harm_result = (is_fatal and "Killed" or "Harmed") .. (self_harm and "" or " by")
        hitgroup = hitgroup == "generic" and "" or (" in {harm}%s{white}"):format(hitgroup)
        damage = is_fatal and "" or (" for {harm}%s"):format(damage)
        log.print(("{white}%s {harm}%s{white}%s%s"):format(harm_result, attacker_name, hitgroup, damage), "harm")
    elseif attacker == local_player and config.hit_logs then
        local hit_result = is_fatal and "Killed" or "Hit"
        hitgroup = (hitgroup == "generic" or hitgroup == "gear") and "" or (is_fatal and " in" or "'s") .. (" {hit}%s{white}"):format(hitgroup)
        damage = is_fatal and "" or (" for {hit}%s"):format(damage)
        target_name = hitgroup == "{white}" and target_name or ("%s{white}"):format(target_name)
        log.print(("{white}%s {hit}%s%s%s"):format(hit_result, target_name, hitgroup, damage), "hit")
    end
end

register_callback("paint", log.render)
register_callback("player_hurt", log.player_hurt)