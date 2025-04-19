slot0 = panorama.open()
slot1 = {
	["Mirage (Scrimmage)"] = "mg_de_mirage_scrimmagemap",
	Swamp = "mg_de_swamp",
	Mutiny = "mg_de_mutiny",
	Cache = "mg_de_cache",
	Anubis = "mg_de_anubis",
	["Dust 2"] = "mg_de_dust2",
	Train = "mg_de_train",
	Nuke = "mg_de_nuke",
	Vertigo = "mg_de_vertigo",
	Lake = "mg_de_lake",
	Overpass = "mg_de_overpass",
	Rialto = "mg_gd_rialto",
	Inferno = "mg_de_inferno",
	["Short Dust"] = "mg_de_shortdust",
	Mirage = "mg_de_mirage",
	["Short Nuke"] = "mg_de_shortnuke",
	Cbble = "mg_de_cbble",
	Office = "mg_cs_office",
	Agency = "mg_cs_agency"
}
slot3 = ui.new_multiselect("Config", "Presets", "Blacklisted maps", {
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
})
slot4 = ui.new_checkbox("Config", "Presets", "Auto-message when queue is cancelled")
slot5 = 0

ui.new_button("Config", "Presets", "Stop matchmaking", function ()
	if uv0.LobbyAPI.IsSessionActive() then
		uv0.LobbyAPI.StopMatchmaking()
	end
end)
client.set_event_callback("paint_ui", function ()
	if uv0.LobbyAPI.BIsHost() then
		return
	end

	if uv0.LobbyAPI.IsSessionActive() == false then
		return
	end

	if uv0.LobbyAPI.GetMatchmakingStatusString() ~= "#SFUI_QMM_State_find_searching" then
		return
	end

	if uv0.LobbyAPI.GetSessionSettings().game.mapgroupname == nil then
		return
	end

	slot1 = {}

	for slot5, slot6 in pairs(ui.get(uv1)) do
		if string.find(slot0.game.mapgroupname, uv2[slot6]) then
			table.insert(slot1, slot6)
		end
	end

	if #slot1 == 0 then
		return
	end

	uv0.LobbyAPI.StopMatchmaking()

	if ui.get(uv3) and client.unix_time() - uv4 > 2 then
		uv4 = client.unix_time()

		uv0.PartyListAPI.SessionCommand("Game::Chat", string.format("run all xuid %s chat %s", uv0.MyPersonaAPI.GetXuid(), string.format("[AUTO-MESSAGE] The queue was cancelled automatically due to a blacklisted map being selected."):gsub(" ", " ")))
		uv0.PartyListAPI.SessionCommand("Game::Chat", string.format("run all xuid %s chat %s", uv0.MyPersonaAPI.GetXuid(), string.format("[AUTO-MESSAGE] Please remove: %s.", table.concat(slot1, ", ")):gsub(" ", " ")))
	end
end)
