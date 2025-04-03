--[[
	primordial.dev | 2022
	Author: Classy
]]

local enable_detector = menu.add_checkbox("primordial detector","enable",false)
local function is_prim_user(ent) -- if use give credits -_-
	if not ent or not ent:is_player() then
		return false
	end
	
	local public_level = player_resource.get_prop("m_nPersonaDataPublicLevel", ent:get_index())
	return public_level == 2233
end

local function on_esp(ctx)
	if not enable_detector:get() then
		return
	end

	if not is_prim_user(ctx.player) then
		return
	end

	ctx:add_flag("Prim",color_t(226,181,199))
end

callbacks.add(e_callbacks.PLAYER_ESP, on_esp)