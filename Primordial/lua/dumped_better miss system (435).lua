local function on_aimbot_miss(miss)

    local color = menu.find( 'misc', 'main', 'config', 'accent color', 0 )


    local sp_miss = miss.aim_safepoint and miss.reason_string == "prediction error"
    local sp_str = sp_miss and "unknown(missed safe)" or miss.reason_string

    client.log(color_t(221, 221, 221), "aimbot missed", color:get(), miss.player:get_name(), color_t(221, 221, 221), "due to", color:get(), sp_str)
end

callbacks.add(e_callbacks.AIMBOT_MISS, on_aimbot_miss)