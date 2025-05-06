
local dmg = ui.reference("RAGE", "Aimbot", "Minimum damage")
local dmgoverride = {ui.reference("RAGE", "Aimbot", "Minimum damage override")}


local dmg = function()
		
	
	local sw, sh = client.screen_size()
	local x, y = sw / 2, sh - 200
	if ui.get(dmgoverride[2])   then
		client.draw_text(ctx, sw / 2+14, sh / 2-15, 255,255,255, 255, "c", 0, ui.get(dmgoverride[3]))	
	end
	
end


client.set_event_callback('paint', dmg)
