--   Lolzy   --
--  /id/E63  --

local cl = {
	set_cvar = client.set_cvar,
	set_clan_tag = client.set_clan_tag,
	delay_call = client.delay_call,
}

local ui_get = ui.get
local ui_set = ui.set
local ui_set_visible = ui.set_visible
local ui_check = ui.new_checkbox
local ui_combo = ui.new_combobox
local ui_text = ui.new_textbox
local ui_call = ui.set_callback

local stoleName = false

local function setName(name)
cl.set_cvar("name", name)
end

local stealName = ui.reference("MISC", "Miscellaneous", "Steal player name")

local antiKick = ui_check("LUA", "A", "Anti Kick")
local customNames  = ui_combo ("LUA", "A", "Custom Names", "Scoreboard Name", "Vote Kick Name")
local scoreboardName = ui_text("LUA", "A", "Scoreboard Name")
local kickName = ui_text("LUA", "A", "Kick Name")

ui_set_visible(scoreboardName, true)
ui_set_visible(kickName, false)

local function updateMenu()
	scoreboardNameSet = ui_get(scoreboardName)
	kickNameSet = ui_get(kickName)
    if ui_get(customNames) == "Scoreboard Name" then

        ui_set_visible(scoreboardName, true)
		ui_set_visible(kickName, false)
    else

		ui_set_visible(kickName, true)
		ui_set_visible(scoreboardName, false)

    end
end

local function nokickCallback(val)
local indexCheck = entity.get_local_player()
local nameCheck = entity.get_player_name(indexCheck)
local scoreboardNameSet = ui_get(scoreboardName)
local kickNameSet = ui_get(kickName)

	if stoleName == false and nameCheck ~= "unknown" then
			print(nameCheck)
			ui_set(stealName, true) 
			stoleName = true
		else if stoleName == false and nameCheck == "unknown" then
			print("You are not in a match.")
		end
	end
		
		
--Change this stuff if you don't want to set custom names each time.  		
	if (scoreboardNameSet == "") then scoreboardNameSet = "Lolzy" end
	if (kickNameSet == "") then kickNameSet = "Ghost" end
		if (ui_get(val)) and nameCheck ~= "unknown" then
			cl.delay_call(0.1,setName,"\n\xAD\xAD\xAD")
			cl.set_clan_tag((scoreboardNameSet) .. "\n\n\n\n\n\n\n\n")
			cl.delay_call(0.4,setName,"\n" ..(kickNameSet) .. "\n")
			print("Anti Kick On")
		else if nameCheck ~= "unknown" then
			cl.set_clan_tag(" ")
			print("Anti Kick Off")
			end
		end
	end

ui_call(customNames, updateMenu)
ui_call(antiKick, nokickCallback)