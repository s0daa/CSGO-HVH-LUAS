local items = menu.add_multi_selection("A", "Display logs", {"Item purchase", "Hit", "Hurt", "Miss"})
local color = items:add_color_picker("Color")
local add_y = menu.add_slider("A", "Custom Y", 0, 100)

local data, log = {}, {}

local hitboxes = {
    [0] = "generic",
    [1] = "head",
    [2] = "chest",
    [3] = "stomach",
    [4] = "left arm",
    [5] = "right arm",
    [6] = "left leg",
    [7] = "right leg",
    [10] = "gear",
}

local function Animation(name, value, speed)
    return name + (value - name) * global_vars.frame_time() * speed
end

function log.add( text )
	data[#data + 1] = { text, 0, global_vars.cur_time() }
end

local font = render.create_font("lucida console", 10, 400, e_font_flags.DROPSHADOW)


callbacks.add(e_callbacks.PAINT, function()
	local offset = 0

	if not engine.is_connected() then data = {} end

	for idx, log_data in ipairs(data) do
		if global_vars.cur_time() - log_data[3] < 3.5 and not (#data > 10 and idx < #data - 10) then
			log_data[2] = Animation(log_data[2], 255, 10)
		else
			log_data[2] = Animation(log_data[2], 0, 10)
		end

		offset = offset + 15 * (log_data[2] / 255)

		if log_data[2] > 0.1 and -11 + offset > 1 then
			render.text(font, log_data[1], vec2_t(4, -11 + math.abs(offset) + add_y:get()), color_t(color:get().r, color:get().g, color:get().b, math.floor(log_data[2])))
		end
	end
end)

callbacks.add(e_callbacks.EVENT, function(event)
	local local_player = entity_list.get_local_player()

    if items:get("Item purchase") and event.name == "item_purchase" then
    	local entity = entity_list.get_player_from_userid(event.userid)
    	local item = string.gsub(event.weapon, "weapon_", "")

    	if entity ~= local_player then
    		log.add(string.format("%s bought %s", entity:get_name(), item))
    	end
    end

    if event.name == "player_hurt" then
    	local entity = entity_list.get_player_from_userid(event.userid)
    	local attacker = entity_list.get_player_from_userid(event.attacker)
    	local dmg = event.dmg_health
    	local healt = entity:get_prop("m_iHealth") - dmg
    	if healt < 0 then healt = "0" end
    	local hitbox = hitboxes[event.hitgroup]
    	local weap = event.weapon
    	local is_knife = string.match(weap, "knife") or weap == "bayonet"
    	local is_nade = weap == "hegrenade"
    	local is_molotov = weap == "inferno"

    	if items:get("Hit") and attacker == local_player then
    		if is_knife then
    			log.add(string.format("Knifed %s for %s damage (%s health remaining)", entity:get_name(), dmg, healt))
    		elseif is_nade then
    			log.add(string.format("Naded %s for %s damage (%s health remaining)", entity:get_name(), dmg, healt))
    		elseif is_molotov then
    			log.add(string.format("Burn %s for %s damage (%s health remaining)", entity:get_name(), dmg, healt))
    		else
    			log.add(string.format("Hit %s in the %s for %s damage (%s health remaining)", entity:get_name(), hitbox, dmg, healt))
    		end
    	elseif items:get("Hurt") and entity == local_player then
    		log.add(string.format("Hurt by %s in the %s for %s damage (%s health remaining)", attacker:get_name(), hitbox, dmg, healt))
    	end
    end
end)

callbacks.add(e_callbacks.AIMBOT_MISS, function(miss)
	log.add(string.format("Missed %s due to %s", miss.player:get_name(), miss.reason_string))
end)