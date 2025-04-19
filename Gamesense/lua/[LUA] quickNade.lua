local globals_tickcount = globals.tickcount
local globals_tickinterval = globals.tickinterval
local entity_get_prop = entity.get_prop
local client_exec = client.exec
local client_userid_to_entindex = client.userid_to_entindex
local entity_get_local_player = entity.get_local_player
local ui_get = ui.get

local switch_to_flash_at = nil
local next_command_at = nil
local grenade_enable_reference = ui.new_checkbox("MISC", "Miscellaneous", "Fast Grenade")

local function on_paint(ctx)
	local tickcount = globals_tickcount()
	if switch_to_flash_at ~= nil then
		if tickcount > next_command_at then
			next_command_at = tickcount+1
			client_exec("use weapon_flashbang")
			if switch_to_flash_at < tickcount then
				switch_to_flash_at = nil
			end
		end
	end
end

local function on_item_equip(e)
	local userid, item = e.userid, e.item
	if userid == nil then
		return
	end
	local entindex = client_userid_to_entindex(userid)
	if entindex == entity_get_local_player() then
		if item == "flashbang" then
			switch_to_flash_at = nil
			next_command_at = nil
		end
	end
end

local function on_grenade_thrown(e)
	if not ui_get(grenade_enable_reference) then
		return
	end

	userid, grenade = e.userid, e.weapon
	if client_userid_to_entindex(userid) == entity_get_local_player() then
		if grenade == "flashbang" then
			client_exec("slot3;")
			switch_to_flash_at = globals_tickcount() + 15
			next_command_at = globals_tickcount()
		else
			client_exec("slot3; slot2; slot1")
		end
	end
end

client.set_event_callback("paint", on_paint)
client.set_event_callback("grenade_thrown", on_grenade_thrown)
client.set_event_callback("item_equip", on_item_equip)