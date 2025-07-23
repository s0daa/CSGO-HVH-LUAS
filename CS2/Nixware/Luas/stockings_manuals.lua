-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

-- https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
local STATES = {
    [0x5A] = 90,  -- VK_LEFT
    [0x43] = -90, -- VK_RIGHT

    default = 180
}

local ENABLE_INDICATOR = true
local INDICATOR_COLOR = color_t(0.72, 0.76, 1, 1)
local INDICATOR_DISTANCE = 40

--

ffi.cdef [[
    unsigned short GetAsyncKeyState(int vKey);
]]

local function is_key_pressed(virtualKey)
    return bit.band(ffi.C.GetAsyncKeyState(virtualKey), 32768) == 32768
end

local held_keys_cache = {}

register_callback("paint", function()
    for k, v in pairs(STATES) do
        if k == "default" then
            goto continue
        end

        local is_key_held = is_key_pressed(k)

        if (not held_keys_cache[k]) and is_key_held then
            if menu.ragebot_anti_aim_base_yaw_offset == v then
                menu.ragebot_anti_aim_base_yaw_offset = STATES["default"]
            else
                menu.ragebot_anti_aim_base_yaw_offset = v
            end
        end

        held_keys_cache[k] = is_key_held

        ::continue::
    end

    if ENABLE_INDICATOR then
        if not entitylist.get_local_player_pawn() then return end

        local screen_center = vec2_t(
            render.screen_size().x / 2,
            render.screen_size().y / 2
        )

        local offset = menu.ragebot_anti_aim_base_yaw_offset

        local manual =
            (offset >= 45 and offset <= 145) and 2 or
            (offset <= -75 and offset >= -145) and 1 or
            0

        render.filled_polygon(
            {
                vec2_t(screen_center.x + (INDICATOR_DISTANCE + 15), screen_center.y),
                vec2_t(screen_center.x + (INDICATOR_DISTANCE + 2), screen_center.y - 9),
                vec2_t(screen_center.x + (INDICATOR_DISTANCE + 2), screen_center.y + 9)
            },
            manual == 1 and INDICATOR_COLOR or color_t(0, 0, 0, 0.4)
        )

        render.filled_polygon(
            {
                vec2_t(screen_center.x - (INDICATOR_DISTANCE + 15), screen_center.y),
                vec2_t(screen_center.x - (INDICATOR_DISTANCE + 2), screen_center.y - 9),
                vec2_t(screen_center.x - (INDICATOR_DISTANCE + 2), screen_center.y + 9)
            },
            manual == 2 and INDICATOR_COLOR or color_t(0, 0, 0, 0.4)
        )
    end
end)

register_callback("unload", function()
    menu.ragebot_anti_aim_base_yaw_offset = STATES["default"]
end)
