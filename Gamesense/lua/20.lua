local userid_to_entindex = client.userid_to_entindex
local get_player_name = entity.get_player_name
local get_local_player = entity.get_local_player
local is_enemy = entity.is_enemy
local console_cmd = client.exec
local ui_get = ui.get
local trashtalk = ui.new_checkbox("MISC", "Settings", "AA")

local baimtable = {
    '',


}
local hstable = baimtable

local deathtable = {
	'',


}


local function get_table_length(data)
	if type(data) ~= 'table' then
		return 0
	end
	local count = 0
	for _ in pairs(data) do
		count = count + 1
	end
	return count
end

local num_quotes_baim = get_table_length(baimtable)
local num_quotes_hs = get_table_length(hstable)
local num_quotes_death = get_table_length(deathtable)

local function on_player_death(e)
	if not ui_get(trashtalk) then
		return
	end
	local victim_userid, attacker_userid = e.userid, e.attacker
	if victim_userid == nil or attacker_userid == nil then
		return
	end

	-- kill
	local victim_entindex   = userid_to_entindex(victim_userid)
	local attacker_entindex = userid_to_entindex(attacker_userid)
	if attacker_entindex == get_local_player() and is_enemy(victim_entindex) then
		client.delay_call(2, function ()
			if e.headshot then
				local commandhs = 'say ' .. hstable[math.random(num_quotes_hs)]
				console_cmd(commandhs)
			else
				local commandbaim = 'say ' .. baimtable[math.random(num_quotes_baim)]
				console_cmd(commandbaim)
			end
		end)
	end

	-- death
	if victim_entindex == get_local_player() and attacker_entindex ~= get_local_player() then
		client.delay_call(2, function ()
			local commandbaim = 'say ' .. deathtable[math.random(num_quotes_death)]
			console_cmd(commandbaim)
		end)
	elseif victim_entindex == get_local_player() and attacker_entindex == get_local_player() then
		client.delay_call(2, function ()
			console_cmd("Enjoy")
		end)
	end
end

client.set_event_callback("player_death", on_player_death)
