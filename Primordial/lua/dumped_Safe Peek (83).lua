--[[
	primordial.dev | 2022
	Author: Classy
]]

local ref_quickpeek = menu.find("aimbot","general","misc","autopeek")
local ref_safe_charge = menu.add_checkbox("safe peek","enable safe peek",false)

local function on_setup_command(cmd)
	if not cmd or not ref_safe_charge:get() then
		return
	end

	if ref_quickpeek[2]:get() and not client.can_fire() and not (exploits.get_charge() >= 14) then
		cmd.move = vec3_t()
	end 

end

callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)