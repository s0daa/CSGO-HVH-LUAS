require 'bit'
local enable = ui.new_checkbox("LUA", "A", "Old anim fix")
local enable2 = ui.new_checkbox("LUA", "A", "pitch 0 on land")
local fakelag = ui.reference("AA", "Fake lag", "Limit")
local ground_ticks, end_time = 1, 0


client.set_event_callback("pre_render", function()

    if ui.get(enable) then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
    end
	
	if entity.is_alive(entity.get_local_player()) then
	
    if ui.get(enable2) then
        local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)

        if on_ground == 1 then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = globals.curtime() + 1
        end 
    
        if ground_ticks > ui.get(fakelag)+1 and end_time > globals.curtime() then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
        end
    end
end end)