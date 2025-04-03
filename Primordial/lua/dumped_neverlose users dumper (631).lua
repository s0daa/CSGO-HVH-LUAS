local function is_prim_user(ent)
	if not ent or not ent:is_player() then
		return false
	end
	
	local public_level = player_resource.get_prop("m_nPersonaDataPublicLevel", ent:get_index())
	return public_level == 1224 or public_level == 1232 or public_level == 5000 or public_level == 1220 or public_level == 1209 or public_level == 1376
end

local function gayyy()
    local enemies = entity_list.get_players()
    if not enemies then return end
    for i,v in pairs(enemies) do
        print("player : " .. tostring(v:get_name()) .. " , is probably nl : " .. tostring(is_prim_user(v)) .. "\n")
    end
end

local function callback_fn()
    print(gayyy())
end

local button = menu.add_button("dump (console)", "nl users (may not be accurate)", callback_fn)
local function aa()   
    -- need this so i can render button lmao pls fix <3
end

callbacks.add(e_callbacks.PAINT, aa)