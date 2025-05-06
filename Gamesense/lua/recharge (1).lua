local ref = {
    aimbot = ui.reference('RAGE', 'Aimbot', 'Enabled'),
    doubletap = {
        main = {ui.reference('RAGE', 'Aimbot', 'Double tap')},
        fakelag_limit = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit')
    },
    onshot_antiaim = {ui.reference('AA', 'Other', 'On shot anti-aim')}
}

client.set_event_callback('setup_command', function()
    if not ((ui.get(ref.doubletap.main[1]) and ui.get(ref.doubletap.main[2])) or (ui.get(ref.onshot_antiaim[1]) and ui.get(ref.onshot_antiaim[2]))) then
        ui.set(ref.aimbot, true)
        return
    end

    local m_nTickBase = entity.get_prop(entity.get_local_player(), 'm_nTickBase')
    local shift = math.floor(m_nTickBase - globals.tickcount() - 3 - toticks(client.latency()) * .4)
    local ticks_charged = shift <= -15 + (ui.get(ref.doubletap.fakelag_limit) - 1) + 5

    local threat = client.current_threat()

    if ticks_charged
    or not threat
    or bit.band(entity.get_esp_data(threat).flags, bit.lshift(1, 11)) ~= 2048 then
        ui.set(ref.aimbot, true)
        return
    end

    ui.set(ref.aimbot, false)
end)

client.set_event_callback('shutdown', function()
    ui.set(ref.aimbot, true)
end)