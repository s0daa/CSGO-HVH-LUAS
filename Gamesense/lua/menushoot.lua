-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

client.set_event_callback('setup_command', function (cmd)
    if not ui.is_menu_open() then return end
    cmd.in_attack = false
    cmd.in_attack2 = false
end)