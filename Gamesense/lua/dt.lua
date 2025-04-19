client.set_event_callback("setup_command", function(cmd)
  cmd.force_defensive = true
end)