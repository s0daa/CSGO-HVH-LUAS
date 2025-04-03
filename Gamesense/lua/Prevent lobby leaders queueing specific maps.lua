local var_0_0 = panorama.open()
local var_0_1 = {
	Cbble = "mg_de_cbble",
	Nuke = "mg_de_nuke",
	Office = "mg_cs_office",
	Overpass = "mg_de_overpass",
	Agency = "mg_cs_agency",
	["Dust 2"] = "mg_de_dust2",
	["Mirage (Scrimmage)"] = "mg_de_mirage_scrimmagemap",
	Swamp = "mg_de_swamp",
	Mutiny = "mg_de_mutiny",
	Cache = "mg_de_cache",
	Anubis = "mg_de_anubis",
	Vertigo = "mg_de_vertigo",
	Train = "mg_de_train",
	Inferno = "mg_de_inferno",
	Mirage = "mg_de_mirage",
	Lake = "mg_de_lake",
	Rialto = "mg_gd_rialto",
	["Short Dust"] = "mg_de_shortdust",
	["Short Nuke"] = "mg_de_shortnuke"
}
local var_0_2 = {
	"Mirage",
	"Inferno",
	"Overpass",
	"Vertigo",
	"Nuke",
	"Train",
	"Dust 2",
	"Anubis",
	"Cache",
	"Mutiny",
	"Swamp",
	"Agency",
	"Office",
	"Cbble",
	"Short Nuke",
	"Short Dust",
	"Rialto",
	"Lake"
}
local var_0_3 = ui.new_multiselect("Config", "Presets", "Blacklisted maps", var_0_2)
local var_0_4 = ui.new_checkbox("Config", "Presets", "Auto-message when queue is cancelled")
local var_0_5 = 0

ui.new_button("Config", "Presets", "Stop matchmaking", function()
	if var_0_0.LobbyAPI.IsSessionActive() then
		var_0_0.LobbyAPI.StopMatchmaking()
	end
end)
client.set_event_callback("paint_ui", function()
	if var_0_0.LobbyAPI.BIsHost() then
		return
	end

	if var_0_0.LobbyAPI.IsSessionActive() == false then
		return
	end

	if var_0_0.LobbyAPI.GetMatchmakingStatusString() ~= "#SFUI_QMM_State_find_searching" then
		return
	end

	local var_2_0 = var_0_0.LobbyAPI.GetSessionSettings()

	if var_2_0.game.mapgroupname == nil then
		return
	end

	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(ui.get(var_0_3)) do
		if string.find(var_2_0.game.mapgroupname, var_0_1[iter_2_1]) then
			table.insert(var_2_1, iter_2_1)
		end
	end

	if #var_2_1 == 0 then
		return
	end

	var_0_0.LobbyAPI.StopMatchmaking()

	if ui.get(var_0_4) and client.unix_time() - var_0_5 > 2 then
		var_0_5 = client.unix_time()

		var_0_0.PartyListAPI.SessionCommand("Game::Chat", string.format("run all xuid %s chat %s", var_0_0.MyPersonaAPI.GetXuid(), string.format("[AUTO-MESSAGE] The queue was cancelled automatically due to a blacklisted map being selected."):gsub(" ", " ")))
		var_0_0.PartyListAPI.SessionCommand("Game::Chat", string.format("run all xuid %s chat %s", var_0_0.MyPersonaAPI.GetXuid(), string.format("[AUTO-MESSAGE] Please remove: %s.", table.concat(var_2_1, ", ")):gsub(" ", " ")))
	end
end)
