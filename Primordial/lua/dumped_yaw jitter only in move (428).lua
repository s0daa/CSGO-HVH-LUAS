local gnoyniy_jitter = menu.find("antiaim", "main", "angles", "jitter mode")
local slowwalk = menu.find("misc", "main", "movement", "slow walk")[2]

local function main(cmd)

	local local_player          = entity_list.get_local_player()
	local velocity              = local_player:get_prop("m_vecVelocity"):length()  
	local in_air = local_player:get_prop("m_vecVelocity[2]") ~= 0
    local in_duck = local_player:get_prop("m_flDuckAmount") >= 0.5
	local sv = slowwalk:get()
	if velocity > 5 and not sv and not in_air and not in_duck then 
	
		gnoyniy_jitter:set(2) 
		else 
		gnoyniy_jitter:set(1) 
    end
end
	
callbacks.add(e_callbacks.SETUP_COMMAND, main)