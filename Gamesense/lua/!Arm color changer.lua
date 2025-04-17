-- Player Arms Skin Color Changer, Made By Exodouding for skeet.cc/gamesense.pub

local skin_colors =
{
    "White",
    "Black",
    "Brown",
    "Asian",
    "Mexican",
    "Tattoo"
}

local no_sleeve_t = ui.new_checkbox("Skins", "Model Options", "T No Sleeve")
local skins_t = ui.new_combobox("Skins", "Model Options", "T Skin", skin_colors)
local no_sleeve_ct = ui.new_checkbox("Skins", "Model Options", "CT No Sleeve ")
local skins_ct = ui.new_combobox("Skins", "Model Options", "CT Skin", skin_colors)
--local no_sleeve_oppacity = ui.new_slider("Skins", "Model Options", "No Sleeve Oppcatiy", 0, 100, 100, true, "%", 1)

local function NoSleeve()

	local local_player = entity.get_local_player()

	local team = entity.get_prop(local_player, "m_iTeamNum")
	
	local no_sleeve = ((team == 2) and no_sleeve_t) or ((team == 3) and no_sleeve_ct)
    
    ui.set_visible(no_sleeve_t, team == 2)
    ui.set_visible(no_sleeve_ct, team == 3)
	
	if team == 2 or team == 3 then -- Player is in the terrorist or counter-terrorist team

		local materials = materialsystem.find_materials("sleeve")
		
		if materials == nil then
			return
		end
		
		for _, material in pairs(materials) do
			if material ~= nil then
				material:set_material_var_flag(2, ui.get(no_sleeve))
			end
		end
		
		--[[
			if ui.get(no_sleeve) then
				print((team == 2) and no_sleeve_t and "[T] No Sleeve is on" or "[CT] No Sleeve is on")
			else
				print((team == 3) and no_sleeve_ct and "[CT] No Sleeve is off" or "[T] No Sleeve is off")
			end
		]]--

	else -- Player is in main menu or is spectating or didn't choose a team
	
		ui.set_visible(no_sleeve_t, true)
		ui.set_visible(no_sleeve_ct, true)
	end
end

local function Skins()

	for i, v in pairs(skin_colors) do

		local local_player = entity.get_local_player()
	
		local team = entity.get_prop(local_player, "m_iTeamNum")
		
		local skin = ((team == 2) and skins_t) or ((team == 3) and skins_ct)
		
		ui.set_visible(skins_t, team == 2)
		ui.set_visible(skins_ct, team == 3)
		
		if team == 2 or team == 3 then -- Player is in the terrorist or counter-terrorist team

			local SelectedSkin = ui.get(skin, skin_colors)

			if SelectedSkin == skin_colors[i] and i - 1 ~= selected_skin then
			
				client.set_cvar("r_skin", i - 1)
				
				--[[
					if (team == 2 and skins_t) then
						print("[T] Name : " .. v .. " | Skin ID : " .. i - 1 .. " | Table ID : " .. i)
					elseif (team == 3 and skins_ct) then
						print("[CT] Name : " .. v .. " | Skin ID : " .. i - 1 .. " | Table ID : " .. i)
					end
				]]--
				
				selected_skin = i - 1
			end
			
		else -- Player is in main menu or is spectating or didn't chose a team
		
			ui.set_visible(skins_t, true)
			ui.set_visible(skins_ct, true)
		end
	end
end

client.set_event_callback("paint_ui", NoSleeve)
client.set_event_callback("paint_ui", Skins)
