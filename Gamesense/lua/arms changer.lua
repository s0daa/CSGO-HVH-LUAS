-- Made By Exodouding for skeet.cc/gamesense.pub

local skin_colors = {
    "White",
    "Black",
    "Brown",
    "Asian",
    "Mexican",
    "Tattoo"
}

local LastSelectedIndex = -1

local no_sleeve = ui.new_checkbox("Skins", "Model Options", "No Sleeve")

local PlayerSkinColor = ui.new_checkbox("Skins", "Model Options", "Player Skin Color")
local Skins = ui.new_combobox("Skins", "Model Options", "\n", skin_colors)
ui.set_visible(Skins, false)

ui.set_callback(PlayerSkinColor, function()

	local Result = ui.get(PlayerSkinColor)
	
	ui.set_visible(Skins, Result)
	
	if not Result then 
		client.set_cvar("r_skin", 0)
		LastSelectedIndex = -1
	end
	
end)

local function NoSleeve()

    local sleeve = materialsystem.find_materials("sleeve")
	
    for i=#sleeve, 1, -1 do
	
        if ui.get(no_sleeve) then
            sleeve[i]:set_material_var_flag(2, true)
        else
            sleeve[i]:set_material_var_flag(2, false)
        end
    end
end

local function SkinColor()

	if not ui.get(PlayerSkinColor) then 
		return
	end
	
	for i, v in pairs(skin_colors) do
		
		local SelectedSkin = ui.get(Skins, skin_colors)
		
		if SelectedSkin == skin_colors[i] and i ~= LastSelectedIndex then
			client.set_cvar("r_skin", i-1)
			-- print("Name : " .. v .. " | Skin ID : " .. i)
			LastSelectedIndex = i
		end
	end
end

local function Main()
	NoSleeve()
	SkinColor()
end

client.set_event_callback("paint", Main)