--autobuy v2
local primary_weapons = {
    "-", 
    "AWP", 
    "SCAR20/G3SG1", 
    "Scout", 
    "M4/AK47", 
    "Famas/Galil", 
    "Aug/SG553", 
    "M249/Negev", 
    "Mag7/SawedOff", 
    "Nova", 
    "XM1014", 
    "MP9/Mac10", 
    "UMP45", 
    "PPBizon", 
    "MP7"
}

local secondary_weapons = {
    "-", 
    "CZ75/Tec9/FiveSeven", 
    "P250", 
    "Deagle/Revolver", 
    "Dualies"
}

local grenades = {
    "HE Grenade", 
    "Molotov", 
    "Smoke", 
    "Flash", 
    "Flash", 
    "Decoy", 
    "Decoy"
}

local utilities = {
    "Armor", 
    "Helmet", 
    "Zeus", 
    "Defuser"
}

local prices = {
	["AWP"] = 4750,
	["SCAR20/G3SG1"] = 5000,
	["Scout"] = 1700,
	["M4/AK47"] = 3100,
	["Famas/Galil"] = 2250,
	["Aug/SG553"] = 3100,
    ["M249"] = 5200,
    ["Negev"] = 1700,
	["Mag7/SawedOff"] = 1300,
	["Nova"] = 1050,
	["XM1014"] = 2000,
	["MP9/Mac10"] = 1250,
	["UMP45"] = 1200,
	["PPBizon"] = 1400,
	["MP7"] = 1500,
	["CZ75/Tec9/FiveSeven"] = 500,
	["P250"] = 300,
	["Deagle/Revolver"] = 700,
	["Dualies"] = 400,
	["HE Grenade"] = 300,
	["Molotov"] = 600,
	["Smoke"] = 300,
	["Flash"] = 200,
	["Decoy"] = 50,
	["Armor"] = 650,
	["Helmet"] = 1000,
	["Zeus"] = 200,
	["Defuser"] = 400
}

local commands = {
	["AWP"] = "buy awp",
	["SCAR20/G3SG1"] = "buy scar20",
	["Scout"] = "buy ssg08",
	["M4/AK47"] = "buy m4a1",
	["Famas/Galil"] = "buy famas",
	["Aug/SG553"] = "buy aug",
    ["M249"] = "buy m249",
    ["Negev"] = "buy negev",
	["Mag7/SawedOff"] = "buy mag7",
	["Nova"] = "buy nova",
	["XM1014"] = "buy xm1014",
	["MP9/Mac10"] = "buy mp9",
	["UMP45"] = "buy ump45",
	["PPBizon"] = "buy bizon",
	["MP7"] = "buy mp7",
	["CZ75/Tec9/FiveSeven"] = "buy tec9",
	["P250"] = "buy p250",
	["Deagle/Revolver"] = "buy deagle",
	["Dualies"] = "buy elite",
	["HE Grenade"] = "buy hegrenade",
	["Molotov"] = "buy molotov",
	["Smoke"] = "buy smokegrenade",
	["Flash"] = "buy flashbang",
	["Decoy"] = "buy decoy",
	["Armor"] = "buy vest",
	["Helmet"] = "buy vesthelm",
	["Zeus"] = "buy taser 34",
	["Defuser"] = "buy defuser"
}

--new menu
local ui_enabled = ui.new_checkbox("MISC", "Miscellaneous", "Autobuy")
local ui_hide = ui.new_checkbox("MISC", "Miscellaneous", "Hide autobuy")
local ui_primary = ui.new_combobox("MISC", "Miscellaneous", "Primary", primary_weapons)
local ui_secondary = ui.new_combobox("MISC", "Miscellaneous", "Secondary", secondary_weapons)
local ui_grenades = ui.new_multiselect("MISC", "Miscellaneous", "Grenades", grenades)
local ui_utilities = ui.new_multiselect("MISC", "Miscellaneous", "Utilities", utilities)
local ui_cost_based = ui.new_checkbox("MISC", "Miscellaneous", "Cost based")
local ui_threshold = ui.new_slider("MISC", "Miscellaneous", "Balance override", 0, 16000, 0, true, "$", 1, {[0] = "Off"})
local ui_primary_2 = ui.new_combobox("MISC", "Miscellaneous", "Backup primary", primary_weapons)
local ui_secondary_2 = ui.new_combobox("MISC", "Miscellaneous", "Backup secondary", secondary_weapons)
local ui_grenades_2 = ui.new_multiselect("MISC", "Miscellaneous", "Backup grenades", grenades)
local ui_utilities_2 = ui.new_multiselect("MISC", "Miscellaneous", "Backup utilities", utilities)

--visibility
local function handle_vis()
    local state = ui.get(ui_enabled)
    local state2 = (not ui.get(ui_hide))
    local state3 = ui.get(ui_cost_based)

    ui.set_visible(ui_hide, state)

    if state and state2 then
        ui.set_visible(ui_primary, state)
        ui.set_visible(ui_secondary, state)
        ui.set_visible(ui_grenades, state)
        ui.set_visible(ui_utilities, state)
        ui.set_visible(ui_cost_based, state)
        ui.set_visible(ui_threshold, state3)
        ui.set_visible(ui_primary_2, state3)
        ui.set_visible(ui_secondary_2, state3)
        ui.set_visible(ui_grenades_2, state3)
        ui.set_visible(ui_utilities_2, state3)
    elseif not state2 then
        ui.set_visible(ui_primary, state2)
        ui.set_visible(ui_secondary, state2)
        ui.set_visible(ui_grenades, state2)
        ui.set_visible(ui_utilities, state2)
        ui.set_visible(ui_cost_based, state2)
        ui.set_visible(ui_threshold, state2)
        ui.set_visible(ui_primary_2, state2)
        ui.set_visible(ui_secondary_2, state2)
        ui.set_visible(ui_grenades_2, state2)
        ui.set_visible(ui_utilities_2, state2)
    else
        ui.set_visible(ui_primary, state)
        ui.set_visible(ui_secondary, state)
        ui.set_visible(ui_grenades, state)
        ui.set_visible(ui_utilities, state)
        ui.set_visible(ui_cost_based, state)
        ui.set_visible(ui_threshold, state)
        ui.set_visible(ui_primary_2, state)
        ui.set_visible(ui_secondary_2, state)
        ui.set_visible(ui_grenades_2, state)
        ui.set_visible(ui_utilities_2, state)
    end
end
ui.set_callback(ui_enabled, handle_vis)
ui.set_callback(ui_hide, handle_vis)
ui.set_callback(ui_cost_based, handle_vis)
handle_vis()

local function get_weapon_prices()
    local total_price = 0
    --utilities
	local utility_purchase = ui.get(ui_utilities)
	for i = 1, #utility_purchase do
        local n = utility_purchase[i]
        
	    for k, v in pairs(prices) do
		    if k == n then
			    total_price = total_price + v
		    end
	    end
    end

    --secondary
    for k, v in pairs(prices) do
        if k == ui.get(ui_secondary) then
            total_price = total_price + v
        end
    end

    --primary
    for k, v in pairs(prices) do
        if k == ui.get(ui_primary) then
            total_price = total_price + v
        end
    end
    
    --grenades
    local grenade_purchase = ui.get(ui_grenades)
    for i = 1, #grenade_purchase do
        local n = grenade_purchase[i]
        
	    for k, v in pairs(prices) do
		    if k == n then
			    total_price = total_price + v
		    end
	    end
    end
    return total_price
end

-- split into two funcs because otherwise the storing gets fked up
local logged_grenades = {}
local logged_grenades_2 = {}

local function grenade_limit_callback()
	local total_nades = ui.get(ui_grenades)

	if #total_nades > 4 then
		ui.set(ui_grenades, logged_grenades)
		return
	end

	logged_grenades = total_nades
end

local function grenade_limit_callback_2()
	local total_nades = ui.get(ui_grenades_2)

	if #total_nades > 4 then
		ui.set(ui_grenades_2, logged_grenades)
		return
	end

	logged_grenades_2 = total_nades
end

ui.set_callback(ui_grenades, grenade_limit_callback)
ui.set_callback(ui_grenades_2, grenade_limit_callback_2)

client.set_event_callback("round_prestart", function(e)
    local ui_threshold_value = ui.get(ui_threshold)

    local price_threshold = 0

    if ui.get(ui_cost_based) and (ui_threshold_value == 0) then
        price_threshold = get_weapon_prices()
    elseif (ui_threshold_value ~= 0) then
        price_threshold = ui.get(ui_threshold)
    end

    local money = entity.get_prop(entity.get_local_player(), "m_iAccount")

    --if money is less than threshold
    if money <= price_threshold then
        --secondary
        for k, v in pairs(commands) do
            if k == ui.get(ui_secondary_2) then
                client.exec(v)
            end
        end

        --utilities
		local utility_purchase = ui.get(ui_utilities_2)

		for i = 1, #utility_purchase do
            local n = utility_purchase[i]
            
		    for k, v in pairs(commands) do
			    if k == n then
				    client.exec(v)
			    end
		    end
        end

        --primary
        for k, v in pairs(commands) do
            if k == ui.get(ui_primary_2) then
                client.exec(v)
            end
        end

        --grenades
        local grenade_purchase = ui.get(ui_grenades_2)

        for i = 1, #grenade_purchase do
            local n = grenade_purchase[i]
            
		    for k, v in pairs(commands) do
			    if k == n then
				    client.exec(v)
			    end
		    end
        end

    --money is greater than threshold
    else 
        --utilities
		local utility_purchase = ui.get(ui_utilities)

		for i = 1, #utility_purchase do
            local n = utility_purchase[i]
            
		    for k, v in pairs(commands) do
			    if k == n then
				    client.exec(v)
			    end
		    end
        end

        --secondary
        for k, v in pairs(commands) do
            if k == ui.get(ui_secondary) then
                client.exec(v)
            end
        end

        --primary
        for k, v in pairs(commands) do
            if k == ui.get(ui_primary) then
                client.exec(v)
            end
        end

        --grenades
        local grenade_purchase = ui.get(ui_grenades)

        for i = 1, #grenade_purchase do
            local n = grenade_purchase[i]
            
		    for k, v in pairs(commands) do
			    if k == n then
				    client.exec(v)
			    end
		    end
        end
    end
end)