local killsays = {
        "sleep dog ",
	"1 ",
	"you so fucking bad HAHAHAHA",
	"wyd dog",
	"nice aa fucking paster",
	"hs ",
	"botik die hurensohn ",
	"go fucking ff dog",
	"shitbot loserlife",
	"don't waste our time dog",
	"do you need some class huso",
	"kys  ",
	"hdf ",
	"don't pray for lucky ",
	"nice playstyle HAHAHHAHAHA",
	"gtfo your so fucking bad",
    -- add as many as you want
}

local function table_lengh(data) --grabbing how many killsay quotes are in our table
    if type(data) ~= 'table' then
        return 0													
    end
    local count = 0
    for _ in pairs(data) do
        count = count + 1
    end
    return count
end

local function on_event(event)
    local lp = entity_list.get_local_player() --grabbing out local player
    local kill_cmd = 'say ' .. killsays[math.random(table_lengh(killsays))] --randomly selecting a killsay
    if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() then return end --checking if the killer is us
    engine.execute_cmd(kill_cmd) --executing the killsay command
end

callbacks.add(e_callbacks.EVENT, on_event, "player_death") -- calling the function only when a player dies