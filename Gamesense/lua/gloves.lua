local get, set, userid_to_entindex, get_local_player, set_visible, get_prop, pairs = ui.get, ui.set, client.userid_to_entindex, entity.get_local_player, ui.set_visible, entity.get_prop, pairs

local glove_skins = {
	['Bloodhound'] = {
		{10008, 'Bronzed'}, {10006, 'Charred'},  {10039, 'Guerrilla'}, {10007, 'Snakebite'},  
	},
	['Wraps'] = {
		{10056, 'Arboreal'}, {10036, 'Badlands'}, {10053, 'Cobalt Skulls'}, {10055, 'Duct Tape'},  
		{10009, 'Leather'}, {10054, 'Overprint'}, {10021, 'Slaughter'}, {10010, 'Spruce DDPAT'},  
	},
	['Driver'] = {
		{10015, 'Convoy'}, {10016, 'Crimson Weave'}, {10040, 'Diamondback'}, {10042, 'Imperial Plaid'},  
		{10041, 'King Snake'}, {10013, 'Lunar Weave'}, {10043, 'Overtake'}, {10044, 'Racing Green'},  
	},
	['Sport'] = {
		{10045, 'Amphibious'}, {10019, 'Arid'}, {10046, 'Bronze Morph'}, {10038, 'Hedge Maze'},  
		{10047, 'Omega'}, {10037, "Pandora's Box"}, {10018, 'Superconductor'}, {10048, 'Vice'}, {10073, 'Slingshot'} 
	},
	['Specialist'] = {
		{10062, 'Buckshot'}, {10033, 'Crimson Kimono'}, {10061, 'Crimson Web'}, {10034, 'Emerald Web'},  
		{10063, 'Fade'}, {10030, 'Forest DDPAT'}, {10035, 'Foundation'}, {10064, 'Mogul'},  
	},
	['Motorcycle'] = {
		{10027, 'Boom!'}, {10028, 'Cool Mint'}, {10024, 'Eclipse'}, {10049, 'POW!'},  
		{10052, 'Polygon'}, {10026, 'Spearmint'}, {10051, 'Transport'}, {10050, 'Turtle'}, 
	},
	['Hydra'] = {
		{10060, 'Case Hardened'}, {10057, 'Emerald'}, {10058, 'Mangrove'}, {10059, 'Rattler'}, 
	},
}

local gloves, n = {}, 0
for i, v in pairs(glove_skins) do
	n = n + 1
	gloves[n] = i
end

local side = ui.new_combobox('skins', 'glove options', 'Team', '-', 'T Side', 'CT Side')
local T_Glove = ui.new_combobox('skins', 'glove options', 'Override T Gloves', gloves)
local CT_Glove = ui.new_combobox('skins', 'glove options', 'Override CT Gloves', gloves)
local enable, combo, list = ui.reference('skins', 'glove options', 'Override gloves')
set_visible(combo, false)
set_visible(list, false)

local skins_boxT, skins_boxCT = {}, {}
for glove, skins in pairs(glove_skins) do
	local skin = {}
	for i=1, #skins do
		skin[i] = skins[i][2]
	end

	skins_boxT[glove] = ui.new_listbox('skins', 'glove options', 'Override glove T '.. glove, skin)
	skins_boxCT[glove] = ui.new_listbox('skins', 'glove options', 'Override glove CT '.. glove, skin)

	set_visible(skins_boxT[glove], false)
	set_visible(skins_boxCT[glove], false)

	ui.set_callback(skins_boxT[glove], function()
		local glove = get(T_Glove)
		local index = get(skins_boxT[glove]) + 1
		if get_prop(get_local_player(), 'm_iTeamNum') == 2 then
			set(list, glove_skins[glove][index][1])
		end
	end)

	ui.set_callback(skins_boxCT[glove], function()
		local glove = get(CT_Glove)
		local index = get(skins_boxCT[glove]) + 1
		if get_prop(get_local_player(), 'm_iTeamNum') == 3 then
			set(list, glove_skins[glove][index][1])
		end
	end)
end

ui.set_callback(T_Glove, function()
	for k, v in pairs(skins_boxCT) do
		set_visible(v, false)
		set_visible(skins_boxT[k], false)
	end

	set_visible(skins_boxT[ get(T_Glove) ], true)

	if get_prop(get_local_player(), 'm_iTeamNum') == 2 then
		set(combo, get(T_Glove))
	end
end)

ui.set_callback(CT_Glove, function()
	for k, v in pairs(skins_boxT) do
		set_visible(v, false)
		set_visible(skins_boxCT[k], false)
	end

	set_visible(skins_boxCT[ get(CT_Glove) ], true)

	if get_prop(get_local_player(), 'm_iTeamNum') == 3 then
		set(combo, get(CT_Glove))
	end
end)

local function hide_show()
	local e = get(side)
	set_visible(T_Glove, e == 'T Side')
	set_visible(CT_Glove, e == 'CT Side')

	set_visible(skins_boxCT[ get(CT_Glove) ], e == 'CT Side')
	set_visible(skins_boxT[ get(T_Glove) ], e == 'T Side')
end

hide_show()
ui.set_callback(side, hide_show)

client.set_event_callback('player_team', function(e)
	if get(enable) and userid_to_entindex( e.userid ) == get_local_player() then
		local team = e.team

		if team == 2 then
			local glove = get(T_Glove)
			local s_ind = get(skins_boxT[glove]) + 1
			local skin = glove_skins[glove][s_ind][1]
			set(combo, glove)
			set(list, skin)
		elseif team == 3 then
			local glove = get(CT_Glove)
			local s_ind = get(skins_boxCT[glove]) + 1
			local skin = glove_skins[glove][s_ind][1]
			set(combo, glove)
			set(list, skin)
		end
	end
end)

client.set_event_callback('shutdown', function()
	set_visible(combo, true)
	set_visible(list, true)
end)