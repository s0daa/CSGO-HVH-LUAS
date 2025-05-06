local csgo_weapons = require "gamesense/csgo_weapons"

-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_exec, client_set_event_callback, client_unset_event_callback, client_userid_to_entindex, entity_get_local_player, entity_get_prop, ui_get, ui_set, ui_set_visible =
      client.exec, client.set_event_callback, client.unset_event_callback, client.userid_to_entindex, entity.get_local_player, entity.get_prop, ui.get, ui.set, ui.set_visible

--autobuy v2
local primary_weapons = {
    "-", 
    "AWP", 
    "SCAR20/G3SG1", 
    "Scout", 
    "M4/AK47", 
    "Famas/Galil", 
    "Aug/SG553", 
    "M249",
    "Negev",
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
	["AWP"] = csgo_weapons["weapon_awp"].in_game_price,
	["SCAR20/G3SG1"] = csgo_weapons["weapon_scar20"].in_game_price,
	["Scout"] = csgo_weapons["weapon_ssg08"].in_game_price,
	["M4/AK47"] = csgo_weapons["weapon_m4a1"].in_game_price,
	["Famas/Galil"] = csgo_weapons["weapon_famas"].in_game_price,
	["Aug/SG553"] = csgo_weapons["weapon_aug"].in_game_price,
    ["M249"] = csgo_weapons["weapon_m249"].in_game_price,
    ["Negev"] = csgo_weapons["weapon_negev"].in_game_price,
	["Mag7/SawedOff"] = csgo_weapons["weapon_mag7"].in_game_price,
	["Nova"] = csgo_weapons["weapon_nova"].in_game_price,
	["XM1014"] = csgo_weapons["weapon_xm1014"].in_game_price,
	["MP9/Mac10"] = csgo_weapons["weapon_mp9"].in_game_price,
	["UMP45"] = csgo_weapons["weapon_ump45"].in_game_price,
	["PPBizon"] = csgo_weapons["weapon_bizon"].in_game_price,
	["MP7"] = csgo_weapons["weapon_mp7"].in_game_price,
	["CZ75/Tec9/FiveSeven"] = csgo_weapons["weapon_tec9"].in_game_price,
	["P250"] = csgo_weapons["weapon_p250"].in_game_price,
	["Deagle/Revolver"] = csgo_weapons["weapon_deagle"].in_game_price,
	["Dualies"] = csgo_weapons["weapon_elite"].in_game_price,
	["HE Grenade"] = csgo_weapons["weapon_hegrenade"].in_game_price,
	["Molotov"] = csgo_weapons["weapon_molotov"].in_game_price,
	["Smoke"] = csgo_weapons["weapon_smokegrenade"].in_game_price,
	["Flash"] = csgo_weapons["weapon_flashbang"].in_game_price,
	["Decoy"] = csgo_weapons["weapon_decoy"].in_game_price,
	["Armor"] = csgo_weapons["item_kevlar"].in_game_price,
	["Helmet"] = csgo_weapons["item_assaultsuit"].in_game_price,
	["Zeus"] = csgo_weapons["weapon_taser"].in_game_price,
    ["Defuser"] = csgo_weapons["item_cutters"].in_game_price,
    ["-"] = 0
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
    ["Defuser"] = "buy defuser",
    ["-"] = ""
}

--new menu
local menu = {
    enabled = ui.new_checkbox("MISC", "Miscellaneous", "Autobuy (v2)"),
    hide = ui.new_checkbox("MISC", "Miscellaneous", "Hide autobuy"),
    primary = ui.new_combobox("MISC", "Miscellaneous", "Primary", primary_weapons),
    secondary = ui.new_combobox("MISC", "Miscellaneous", "Secondary", secondary_weapons),
    grenades = ui.new_multiselect("MISC", "Miscellaneous", "Grenades", grenades),
    utilities = ui.new_multiselect("MISC", "Miscellaneous", "Utilities", utilities),
    cost_based = ui.new_checkbox("MISC", "Miscellaneous", "Cost based"),
    threshold = ui.new_slider("MISC", "Miscellaneous", "Balance override", 0, 16000, 0, true, "$", 1, {[0] = "Auto"}),
    primary_2 = ui.new_combobox("MISC", "Miscellaneous", "Backup primary", primary_weapons),
    secondary_2 = ui.new_combobox("MISC", "Miscellaneous", "Backup secondary", secondary_weapons),
    grenades_2 = ui.new_multiselect("MISC", "Miscellaneous", "Backup grenades", grenades),
    utilities_2 = ui.new_multiselect("MISC", "Miscellaneous", "Backup utilities", utilities),
}

--weapon prices
local weapon_cost = 0

local function calculate_weapon_prices()
    weapon_cost = 0
    --utilities
	local utility_purchase = ui_get(menu.utilities)
	for i = 1, #utility_purchase do
        local n = utility_purchase[i]

        weapon_cost = weapon_cost + prices[n]
    end

    --secondary
    weapon_cost = weapon_cost + prices[ui_get(menu.secondary)]

    --primary
    weapon_cost = weapon_cost + prices[ui_get(menu.primary)]
    
    --grenades
    local grenade_purchase = ui_get(menu.grenades)
    for i = 1, #grenade_purchase do
        local n = grenade_purchase[i]

        weapon_cost = weapon_cost + prices[n]
    end
end

-- split into two funcs because otherwise the storing gets fked up
local logged_grenades_full = {}
local logged_grenades_eco = {}

local function grenade_limit_callback_full()
	local total_nades = ui_get(menu.grenades)

	if #total_nades > 4 then
		ui_set(menu.grenades, logged_grenades)
		return
	end

    logged_grenades_full = total_nades
    prepare_cmd()
end

local function grenade_limit_callback_eco()
	local total_nades = ui_get(menu.grenades_2)

	if #total_nades > 4 then
		ui_set(menu.grenades_2, logged_grenades)
		return
	end

    logged_grenades_eco = total_nades
    prepare_cmd()
end

--cmd handler
local cmd_full = ""
local cmd_eco = ""

local function prepare_cmd()
    --reset vars
    cmd_full = ""
    cmd_eco = ""

    --full buy cmd
    --secondary
    cmd_full = cmd_full .. commands[ui_get(menu.secondary)] .. ";"
    --utilities
    local utility_purchase = ui_get(menu.utilities)
    for i = 1, #utility_purchase do
        cmd_full = cmd_full .. commands[utility_purchase[i]] .. ";"
    end
    --primary
    cmd_full = cmd_full .. commands[ui_get(menu.primary)] .. ";"
    --grenades
    local grenade_purchase = ui_get(menu.grenades)
    for i = 1, #grenade_purchase do
        cmd_full = cmd_full .. commands[grenade_purchase[i]] .. ";"
    end

    --eco buy cmd
    --secondary
    cmd_eco = cmd_eco .. commands[ui_get(menu.secondary_2)] .. ";"
    --utilities
    local utility_purchase = ui_get(menu.utilities_2)
    for i = 1, #utility_purchase do
        cmd_eco = cmd_eco .. commands[utility_purchase[i]] .. ";"
    end
    --primary
    local prim = commands[ui_get(menu.primary_2)]
    cmd_eco = cmd_eco .. commands[ui_get(menu.primary_2)] .. ";"
    --grenades
    local grenade_purchase = ui_get(menu.grenades_2)
    for i = 1, #grenade_purchase do
        cmd_eco = cmd_eco .. commands[grenade_purchase[i]] .. ";"
    end

    calculate_weapon_prices()
end

local round_started = false

--callbacks
local function on_net_update_end(e)
    if round_started then
        local money = entity_get_prop(entity_get_local_player(), "m_iAccount")

        local threshold = ui_get(menu.threshold)

        local price_threshold = 0

        if ui_get(menu.cost_based) and (threshold == 0) then
            price_threshold = weapon_cost
        elseif (threshold ~= 0) then
            price_threshold = ui_get(menu.threshold)
        end

        if money < price_threshold then
            client_exec(cmd_eco)
        else
            client_exec(cmd_full)
        end
        
        round_started = false
    end
end

local function on_round_prestart(e)
    round_started = true
end

local function on_player_spawn(e)
    if not round_started and not e.inrestart and client_userid_to_entindex(e.userid) == entity_get_local_player() then 
        round_started = true
    end
end

--visibility
local function handle_vis()
    local state = ui_get(menu.enabled)
    local state2 = (not ui_get(menu.hide))
    local state3 = ui_get(menu.cost_based)

    ui_set_visible(menu.hide, state)

    if state and state2 then
        ui_set_visible(menu.primary, state)
        ui_set_visible(menu.secondary, state)
        ui_set_visible(menu.grenades, state)
        ui_set_visible(menu.utilities, state)
        ui_set_visible(menu.cost_based, state)
        ui_set_visible(menu.threshold, state3)
        ui_set_visible(menu.primary_2, state3)
        ui_set_visible(menu.secondary_2, state3)
        ui_set_visible(menu.grenades_2, state3)
        ui_set_visible(menu.utilities_2, state3)
    elseif not state2 then
        ui_set_visible(menu.primary, state2)
        ui_set_visible(menu.secondary, state2)
        ui_set_visible(menu.grenades, state2)
        ui_set_visible(menu.utilities, state2)
        ui_set_visible(menu.cost_based, state2)
        ui_set_visible(menu.threshold, state2)
        ui_set_visible(menu.primary_2, state2)
        ui_set_visible(menu.secondary_2, state2)
        ui_set_visible(menu.grenades_2, state2)
        ui_set_visible(menu.utilities_2, state2)
    else
        ui_set_visible(menu.primary, state)
        ui_set_visible(menu.secondary, state)
        ui_set_visible(menu.grenades, state)
        ui_set_visible(menu.utilities, state)
        ui_set_visible(menu.cost_based, state)
        ui_set_visible(menu.threshold, state)
        ui_set_visible(menu.primary_2, state)
        ui_set_visible(menu.secondary_2, state)
        ui_set_visible(menu.grenades_2, state)
        ui_set_visible(menu.utilities_2, state)
    end

end

local function on_script_toggle()
    local state = ui.get(menu.enabled)
    local update_callback = state and client_set_event_callback or client_unset_event_callback
    update_callback("net_update_end", on_net_update_end)
    update_callback("round_prestart", on_round_prestart)
    update_callback("player_spawn", on_player_spawn)

    handle_vis()
end

--init
do 
    ui.set_callback(menu.enabled, on_script_toggle)
    on_script_toggle()
    ui.set_callback(menu.grenades, grenade_limit_callback_full)
    ui.set_callback(menu.grenades_2, grenade_limit_callback_eco)

    ui.set_callback(menu.primary, prepare_cmd)
    ui.set_callback(menu.secondary, prepare_cmd)
    ui.set_callback(menu.grenades, prepare_cmd)
    ui.set_callback(menu.utilities, prepare_cmd)

    ui.set_callback(menu.primary_2, prepare_cmd)
    ui.set_callback(menu.secondary_2, prepare_cmd)
    ui.set_callback(menu.grenades_2, prepare_cmd)
    ui.set_callback(menu.utilities_2, prepare_cmd)

    prepare_cmd()

    ui.set_callback(menu.hide, handle_vis)
    ui.set_callback(menu.cost_based, handle_vis)
    handle_vis()
end