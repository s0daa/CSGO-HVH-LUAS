-- @requirments
-- @credit me bro
local ent = require "gamesense/entity";
local checkbox = ui.new_checkbox("LUA", "B", "Air")

client.set_event_callback("pre_render", function()

    if not entity.is_alive(entity.get_local_player()) then return end

    if ui.get(checkbox) then
		
		local me = ent.get_local_player()


		local m_fFlags = me:get_prop("m_fFlags");
    
		local is_onground = bit.band(m_fFlags, 1) ~= 0;

		if not is_onground then
		    local my_animlayer = me:get_anim_overlay(6); -- MOVEMENT_MOVE
			my_animlayer.weight = 1;
			entity.set_prop(me, "m_flPoseParameter", 1, 6) 
		end
	end

end)