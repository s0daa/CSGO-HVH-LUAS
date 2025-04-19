local checkbox = ui.new_checkbox("AA", "Other", "kangaroo")

client.set_event_callback("pre_render", function()
    if ui.get(checkbox) then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 6)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 10)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10)/10, 9)
    end
end) 
