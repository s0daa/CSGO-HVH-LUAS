local function is_local_player(entindex)
    return entindex == entity.get_local_player()
end


local function is_local_player_userid(userid)
    return is_local_player(client.userid_to_entindex(userid))
end

local autobuy_checkbox = ui.new_checkbox("MISC", "Miscellaneous", "Autobuy")
local autobuy_dropbox = ui.new_combobox("MISC", "Miscellaneous", "Autobuy Snipers", "None", "AWP", "Autosniper", "Scout")
local autobuy_dropbox2 = ui.new_combobox("MISC", "Miscellaneous", "Autobuy Pistols", "None", "Deagle/R8", "Dualies", "p250", "CZ", "usp/glock")
local autobuy_dropbox3 = ui.new_combobox("MISC", "Miscellaneous", "Autobuy Rifles", "None", "ak47", "m4a1/m4a1-s", "galil/famas", "AUG/SG", "M249" )
local autobuy_dropbox4 = ui.new_combobox("MISC", "Miscellaneous", "Autobuy Shotguns", "None", "Nova", "Mag7/Sawedoff", "XM1014" )
local autobuy_dropbox5 = ui.new_combobox("MISC", "Miscellaneous", "Autobuy SMG", "None", "Mac10/MP5", "UMP45", "MP7", "Bizon", "P90" )

function autobuy(e)

	local autobuy_value = ui.get(autobuy_dropbox)

	local checkbox, userid = ui.get(autobuy_checkbox), e.userid

	if userid == nil then return end

	local local_player = entity.get_local_player()

	if not is_local_player_userid(userid) then return end

	local primary = ''

				--client.log('Debug: ',autobuy_value)

	if checkbox and autobuy_value ~= "None" then

			if autobuy_value == "Autosniper" then

				primary = 'buy scar20; buy g3sg1; '

			elseif autobuy_value == "Scout" then

				primary = 'buy ssg08; '

			elseif autobuy_value == "AWP" then

				primary = 'buy awp; '

			end
				client.exec(primary, 'buy taser; buy defuser; buy vesthelm; buy vest; buy molotov; buy incgrenade; buy hegrenade; buy smokegrenade')
				client.log('[autobuy] Bought ',autobuy_value,' setup!')

	elseif checkbox and autobuy_value == "None" then

			client.log('[autobuy] Autobuy value set to None.')
	end
end

function autobuy2(e)

	local autobuy_value2 = ui.get(autobuy_dropbox2)

	local checkbox, userid = ui.get(autobuy_checkbox), e.userid

	if userid == nil then return end

	local local_player = entity.get_local_player()

	if not is_local_player_userid(userid) then return end

	local secondary = ''

				--client.log('Debug: ',autobuy_value)

	if checkbox and autobuy_value2 ~= "None" then

			if autobuy_value2 == "Deagle/R8" then

				secondary = 'buy deagle; buy revolver; '

			elseif autobuy_value2 == "Dualies" then

				secondary = 'buy elite; '

			elseif autobuy_value2 == "p250" then

				secondary = 'buy p250; '
				
			elseif autobuy_value2 == "CZ" then

				secondary = 'buy tec9; '

			elseif autobuy_value2 == "usp/glock" then

				secondary = 'buy usp_silencer; buy glock; '

			end
				client.exec(secondary, 'buy taser; buy defuser; buy vesthelm; buy vest; buy molotov; buy incgrenade; buy hegrenade; buy smokegrenade')
				client.log('[autobuy] Bought ',autobuy_value2,' setup!')

	elseif checkbox and autobuy_value2 == "None" then

			client.log('[autobuy] Autobuy2 value set to None.')
	end
end

function autobuy3(e)

	local autobuy_value3 = ui.get(autobuy_dropbox3)

	local checkbox, userid = ui.get(autobuy_checkbox), e.userid

	if userid == nil then return end

	local local_player = entity.get_local_player()

	if not is_local_player_userid(userid) then return end

	local primaryrifle = ''

				--client.log('Debug: ',autobuy_value)

	if checkbox and autobuy_value3 ~= "None" then

			if autobuy_value3 == "ak47" then

				primaryrifle = 'buy ak47; '

			elseif autobuy_value3 == "m4a1/m4a1-s" then

				primaryrifle = 'buy m4a1; buy m4a1_silencer '

			elseif autobuy_value3 == "galil/famas" then

				primaryrifle = 'buy galilar; buy famas '

			elseif autobuy_value3 == "AUG/SG" then

				primaryrifle = 'buy aug; '

			elseif autobuy_value3 == "M249" then

				primaryrifle = 'buy M249; '


			end
				client.exec(primaryrifle, 'buy taser; buy defuser; buy vesthelm; buy vest; buy molotov; buy incgrenade; buy hegrenade; buy smokegrenade')
				client.log('[autobuy] Bought ',autobuy_value3,' setup!')

	elseif checkbox and autobuy_value3 == "None" then

			client.log('[autobuy] Autobuy3 value set to None.')
	end
end

function autobuy4(e)

	local autobuy_value4 = ui.get(autobuy_dropbox4)

	local checkbox, userid = ui.get(autobuy_checkbox), e.userid

	if userid == nil then return end

	local local_player = entity.get_local_player()

	if not is_local_player_userid(userid) then return end

	local primaryrifle = ''

				--client.log('Debug: ',autobuy_value)

	if checkbox and autobuy_value4 ~= "None" then

			if autobuy_value4 == "Nova" then

				primaryrifle = 'buy nova; '

			elseif autobuy_value4 == "Mag7/Sawedoff" then

				primaryrifle = 'buy sawedoff; buy mag7; '

			elseif autobuy_value4 == "XM1014" then

				primaryrifle = 'buy xm1014; '


			end
				client.exec(primaryrifle, 'buy taser; buy defuser; buy vesthelm; buy vest; buy molotov; buy incgrenade; buy hegrenade; buy smokegrenade')
				client.log('[autobuy] Bought ',autobuy_value3,' setup!')

	elseif checkbox and autobuy_value3 == "None" then

			client.log('[autobuy] Autobuy4 value set to None.')
	end
end

function autobuy5(e)

	local autobuy_value5 = ui.get(autobuy_dropbox3)

	local checkbox, userid = ui.get(autobuy_checkbox), e.userid

	if userid == nil then return end

	local local_player = entity.get_local_player()

	if not is_local_player_userid(userid) then return end

	local primaryrifle = ''

				--client.log('Debug: ',autobuy_value)

	if checkbox and autobuy_value5 ~= "None" then

			if autobuy_value5 == "Mac10/MP5" then

				primaryrifle = 'buy mac10; buy mp9; '

			elseif autobuy_value5 == "UMP45" then

				primaryrifle = 'buy ump45; '

			elseif autobuy_value5 == "MP7" then

				primaryrifle = 'buy mp7; '

			elseif autobuy_value5 == "Bizon" then

				primaryrifle = 'buy bizon; '

			elseif autobuy_value5 == "P90" then

				primaryrifle = 'buy p90; '


			end
				client.exec(primaryrifle, 'buy taser; buy defuser; buy vesthelm; buy vest; buy molotov; buy incgrenade; buy hegrenade; buy smokegrenade')
				client.log('[autobuy] Bought ',autobuy_value5,' setup!')

	elseif checkbox and autobuy_value5 == "None" then

			client.log('[autobuy] Autobuy5 value set to None.')
	end
end
local result = client.set_event_callback('player_spawn', autobuy2)
local result = client.set_event_callback('player_spawn', autobuy)
local result = client.set_event_callback('player_spawn', autobuy3)
local result = client.set_event_callback('player_spawn', autobuy4)
local result = client.set_event_callback('player_spawn', autobuy5)

if result then
	client.log('set_event_callback failed: ', result)
end