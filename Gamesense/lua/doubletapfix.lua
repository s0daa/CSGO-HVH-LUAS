local gdgdfdfgdfddg,ref_doubletap = ui.reference("RAGE", "Other", "Double Tap")
local ref_peekassist = ui.reference("RAGE", "Other", "Duck peek assist")
local ref_enabled = ui.new_checkbox("RAGE", "Other", "Double tap fix")
local function on_paint(c)
	local entindex = entity.get_local_player()
	if entindex == nil then
		return
	end
	if not entity.is_alive(entindex) then
		return
	end
	if ui.get(ref_enabled) == true then
		local active_weapon = entity.get_prop(entindex, "m_hActiveWeapon")
		
		if active_weapon == nil then
			return
		end
		
		local item = bit.band((entity.get_prop(active_weapon, "m_iItemDefinitionIndex")), 0xFFFF)
		
		if item == 64 or (item > 42 and item < 49) then
			ui.set(ref_doubletap, "On hotkey")
		else
			ui.set(ref_doubletap, "toggle")
		end
		
		if ui.get(ref_peekassist) then
			ui.set(ref_doubletap, "On hotkey")
		end
	end
end

client.set_event_callback("paint", on_paint)
