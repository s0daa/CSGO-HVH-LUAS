local js = panorama.open()
local GameStateAPI = js.GameStateAPI

local players = {}
local names = {}

local SpoofServerName = panorama.loadstring([[
    var GetServerName = GameStateAPI.GetServerName;

    return {
        enable: function(ServerName){
            GameStateAPI.GetServerName = function(){ return ServerName };
        },
        disable: function(){
            GameStateAPI.GetServerName = GetServerName;
        }
    }
]])()

local GetStats = panorama.loadstring([[
    var PlayerName = GameStateAPI.GetPlayerName;
    var PlayerPing = GameStateAPI.GetPlayerPing;
    var PlayerMoney = GameStateAPI.GetPlayerMoney;
    var PlayerKills = GameStateAPI.GetPlayerKills;
    var PlayerAssists = GameStateAPI.GetPlayerAssists;
    var PlayerDeaths = GameStateAPI.GetPlayerDeaths;
    var PlayerMVPs = GameStateAPI.GetPlayerMVPs;
    var PlayerScore = GameStateAPI.GetPlayerScore;
    var PlayerClanTag = GameStateAPI.GetPlayerClanTag;

    return {
        js: function() {
			return {
                GetPlayerName: x => PlayerName.call(GameStateAPI, x),
				GetPlayerPing: x => PlayerPing.call(GameStateAPI, x),
				GetPlayerMoney: x => PlayerMoney.call(GameStateAPI, x),
				GetPlayerKills: x => PlayerKills.call(GameStateAPI, x),
				GetPlayerAssists: x => PlayerAssists.call(GameStateAPI, x),
				GetPlayerDeaths: x => PlayerDeaths.call(GameStateAPI, x),
				GetPlayerMVPs: x => PlayerMVPs.call(GameStateAPI, x),
                GetPlayerScore: x => PlayerScore.call(GameStateAPI, x),
                GetPlayerClanTag: x => PlayerClanTag.call(GameStateAPI, x),
                GetXuid: ent => GameStateAPI.GetPlayerXuidStringFromEntIndex(ent),
			}
		},
    }
]])()

local SpoofStats = panorama.loadstring([[
    var fake_data = {}

    var PlayerPing = GameStateAPI.GetPlayerPing;
    var PlayerMoney = GameStateAPI.GetPlayerMoney;
    var PlayerKills = GameStateAPI.GetPlayerKills;
    var PlayerAssists = GameStateAPI.GetPlayerAssists;
    var PlayerDeaths = GameStateAPI.GetPlayerDeaths;
    var PlayerMVPs = GameStateAPI.GetPlayerMVPs;
    var PlayerScore = GameStateAPI.GetPlayerScore;

    var items = {
        ping: xuid => PlayerPing.call(GameStateAPI, xuid),
		money: xuid => PlayerMoney.call(GameStateAPI, xuid),
		kills: xuid => PlayerKills.call(GameStateAPI, xuid),
		assists: xuid => PlayerAssists.call(GameStateAPI, xuid),
		deaths: xuid => PlayerDeaths.call(GameStateAPI, xuid),
		mvps: xuid => PlayerMVPs.call(GameStateAPI, xuid),
        score: xuid => PlayerScore.call(GameStateAPI, xuid),
    }
    
    return {
        enable: function(){
            GameStateAPI.GetPlayerPing = function(xuid){ return fake_data[xuid] ? fake_data[xuid].ping : PlayerPing.call(GameStateAPI, xuid) };
            GameStateAPI.GetPlayerMoney = function(xuid){ return fake_data[xuid] ? fake_data[xuid].money : PlayerMoney.call(GameStateAPI, xuid) };
            GameStateAPI.GetPlayerKills = function(xuid){ return fake_data[xuid] ? fake_data[xuid].kills : PlayerKills.call(GameStateAPI, xuid) };
            GameStateAPI.GetPlayerAssists = function(xuid){ return fake_data[xuid] ? fake_data[xuid].assists : PlayerAssists.call(GameStateAPI, xuid) };
            GameStateAPI.GetPlayerDeaths = function(xuid){ return fake_data[xuid] ? fake_data[xuid].deaths : PlayerDeaths.call(GameStateAPI, xuid) };
            GameStateAPI.GetPlayerMVPs = function(xuid){ return fake_data[xuid] ? fake_data[xuid].mvps : PlayerMVPs.call(GameStateAPI, xuid) };
            GameStateAPI.GetPlayerScore = function(xuid){ return fake_data[xuid] ? fake_data[xuid].score : PlayerScore.call(GameStateAPI, xuid) };
        },

        set_fake_data: function(entindex, data){
            var xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)
			if (!fake_data[xuid]) {
				fake_data[xuid] = {}
			}

			Object.keys(items).forEach(k => {
				fake_data[xuid][k] = data[k] || items[k](xuid)
			})
        },

        disable: function(){
            GameStateAPI.GetPlayerPing = PlayerPing;
            GameStateAPI.GetPlayerMoney = PlayerMoney;
            GameStateAPI.GetPlayerKills = PlayerKills;
            GameStateAPI.GetPlayerAssists = PlayerAssists;
            GameStateAPI.GetPlayerDeaths = PlayerDeaths;
            GameStateAPI.GetPlayerMVPs = PlayerMVPs;
            GameStateAPI.GetPlayerScore = PlayerScore;
        }
    }
]])()

local SpoofClantag = panorama.loadstring([[
    var fake_data = {}

    var PlayerClanTag = GameStateAPI.GetPlayerClanTag;
    
    return {
        enable: function(){
            GameStateAPI.GetPlayerClanTag = function(xuid){ return fake_data[xuid] ? fake_data[xuid].clan_tag : PlayerClanTag.call(GameStateAPI, xuid) };
        },

        set_fake_data: function(entindex, data){
            var xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)
            fake_data[xuid] = data
        },

        disable: function(){
            GameStateAPI.GetPlayerClanTag = PlayerClanTag;
        }
    }
]])()

local SpoofName = panorama.loadstring([[
    var fake_data = {}

    var PlayerName = GameStateAPI.GetPlayerName;

    var items = {
        name: xuid => PlayerName.call(GameStateAPI, xuid),
    }
    
    return {
        enable: function(){
            GameStateAPI.GetPlayerName = function(xuid){ return fake_data[xuid] ? fake_data[xuid].name : PlayerName.call(GameStateAPI, xuid) };
        },

        set_fake_data: function(entindex, data){
            var xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)
			if (!fake_data[xuid]) {
				fake_data[xuid] = {}
			}

			Object.keys(items).forEach(k => {
				fake_data[xuid][k] = data[k] || items[k](xuid)
			})
        },

        disable: function(){
            GameStateAPI.GetPlayerName = PlayerName;
        }
    }
]])()

local elements = {
    fake_media = ui.new_checkbox("LUA", "A", "Ultimate fake media"),
    lists = {
        label = ui.new_label("LUA", "A", "Players lists"),
        listbox = ui.new_listbox("LUA", "A", "\nplayers_lists", players),
        only_enemies = ui.new_checkbox("LUA", "A", "Only enemies"),
        refresh = ui.new_button("LUA", "A", "Refresh", function()
            
        end),
        reset = ui.new_button("LUA", "A", "Reset", function()
            
        end),
    },
    player = {
        multiselect = ui.new_multiselect("LUA", "B", "Spoof options", "Ping", "Money", "Kills", "Assists", "Deaths", "MVPs", "Score"),
        ping = ui.new_slider("LUA", "B", "Ping", 0, 1000, 20, true, "ms"),
        money = ui.new_slider("LUA", "B", "Money", 0, 16000, 20, true, "$"),
        kills = ui.new_slider("LUA", "B", "Kills", 0, 100, 20),
        assists = ui.new_slider("LUA", "B", "Assists", 0, 100, 5),
        deaths = ui.new_slider("LUA", "B", "Deaths", 0, 100, 0),
        mvps = ui.new_slider("LUA", "B", "MVPs", 0, 100, 3),
        score = ui.new_slider("LUA", "B", "Score", 0, 100, 40),
        start_spoof_stats = ui.new_button("LUA", "B", "Spoof stats", function()
            
        end),
        stop_spoof_stats = ui.new_button("LUA", "B", "Stop spoof stats", function()
            
        end),
        label_clantag = ui.new_label("LUA", "B", "Clan tag name"),
        clantag = ui.new_textbox("LUA", "B", "\nclantag_name"),
        start_spoof_clantag = ui.new_button("LUA", "B", "Spoof clan tag", function()
            
        end),
        stop_spoof_clantag = ui.new_button("LUA", "B", "Stop spoof clan tag", function()
            
        end),
        label_name = ui.new_label("LUA", "B", "Player name"),
        name = ui.new_textbox("LUA", "B", "\nplayer_name"),
        start_spoof_name = ui.new_button("LUA", "B", "Spoof player name", function()
            
        end),
        stop_spoof_name = ui.new_button("LUA", "B", "Stop spoof player name", function()
            
        end),
    },
    server = {
        label = ui.new_label("LUA", "A", "Server name"),
        servername = ui.new_textbox("LUA", "A", "\nserver_name"),
        server_before = ui.new_checkbox("LUA", "A", "Add Server: before"),
        start_spoof = ui.new_button("LUA", "A", "Spoof server name", function()
            
        end),
        stop_spoof = ui.new_button("LUA", "A", "Stop spoof server name", function()
            
        end),
    }
}

local function isBlank(x)
    return not not tostring(x):find("^%s*$")
end

local function table_contains(tbl, val)
    for i = 1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

local js = GetStats.js()
local function get_stats(xuid, ent)
	return {
        ent = ent,
        name = js.GetPlayerName(xuid),
        ping = js.GetPlayerPing(xuid),
        money = js.GetPlayerMoney(xuid),
		kills = js.GetPlayerKills(xuid),
		assists = js.GetPlayerAssists(xuid),
		deaths = js.GetPlayerDeaths(xuid),
		mvps = js.GetPlayerMVPs(xuid),
        score = js.GetPlayerScore(xuid),
        clan_tag = js.GetPlayerClanTag(xuid)
	}
end

local function off_SpoofServerName()
    if SpoofServerName then
        SpoofServerName.disable()
    end

    ui.set_visible(elements.server.stop_spoof, false)
end

local function on_SpoofServerName()
    local ServerBefore = ui.get(elements.server.server_before)
    local ServerName = ui.get(elements.server.servername)

    if ServerBefore then
        ServerName = "Server: " .. ServerName
    end

    SpoofServerName.enable(ServerName)

    ui.set_visible(elements.server.stop_spoof, true)
end

local function off_SpoofName()
    local selected = ui.get(elements.lists.listbox) + 1
    local player = players[selected]

    if SpoofName then
        SpoofName.set_fake_data(player.ent, {
            name = player.name
        })
    end
end

local function on_SpoofName()
    local selected = ui.get(elements.lists.listbox) + 1
    local player = players[selected]

    local name = ui.get(elements.player.name)

    SpoofName.enable()
    SpoofName.set_fake_data(player.ent, {
        name = name
    })
end

local function off_SpoofClantag()
    local selected = ui.get(elements.lists.listbox) + 1
    local player = players[selected]

    if SpoofClantag then
        SpoofClantag.set_fake_data(player.ent, {
            clan_tag = player.clan_tag
        })
    end
end

local function on_SpoofClantag()
    local selected = ui.get(elements.lists.listbox) + 1
    local player = players[selected]

    local clantag = ui.get(elements.player.clantag)

    SpoofClantag.enable()
    SpoofClantag.set_fake_data(player.ent, {
        clan_tag = clantag
    })
end

local function off_SpoofStats()
    local selected = ui.get(elements.lists.listbox) + 1
    local player = players[selected]

    if SpoofStats then
        SpoofStats.set_fake_data(player.ent, {
            ping = player.ping,
            money = player.money,
            kills = player.kills,
            assists = player.assists,
            deaths = player.deaths,
            mvps = player.mvps,
            score = player.score
        })
    end
end

local function on_SpoofStats()
    local stats = {}

    local selected = ui.get(elements.lists.listbox) + 1
    local player = players[selected]

    local table = ui.get(elements.player.multiselect)
    
    local tbl_ping = table_contains(table, "Ping")
    local tbl_money = table_contains(table, "Money")
    local tbl_kills = table_contains(table, "Kills")
    local tbl_assists = table_contains(table, "Assists")
    local tbl_deaths = table_contains(table, "Deaths")
    local tbl_mvps = table_contains(table, "MVPs")
    local tbl_score = table_contains(table, "Score")
    
    if tbl_ping then
        local ping = ui.get(elements.player.ping)
        stats.ping = ping or nil
    end

    if tbl_money then
        local money = ui.get(elements.player.money)
        stats.money = money or nil
    end

    if tbl_kills then
        local kills = ui.get(elements.player.kills)
        stats.kills = kills or nil
    end

    if tbl_assists then
        local assists = ui.get(elements.player.assists)
        stats.assists = assists or nil
    end

    if tbl_deaths then
        local deaths = ui.get(elements.player.deaths)
        stats.deaths = deaths or nil
    end

    if tbl_mvps then
        local mvps = ui.get(elements.player.mvps)
        stats.mvps = mvps or nil
    end

    if tbl_score then
        local score = ui.get(elements.player.score)
        stats.score = score or nil
    end
    
    SpoofStats.enable()
    SpoofStats.set_fake_data(player.ent, stats)
end

local function on_SpoofOptions(self)
    local value = ui.get(self)

    local ping = table_contains(value, "Ping")
    local money = table_contains(value, "Money")
    local kills = table_contains(value, "Kills")
    local assists = table_contains(value, "Assists")
    local deaths = table_contains(value, "Deaths")
    local mvps = table_contains(value, "MVPs")
    local score = table_contains(value, "Score")

    ui.set_visible(elements.player.ping, ping)
    ui.set_visible(elements.player.money, money)
    ui.set_visible(elements.player.kills, kills)
    ui.set_visible(elements.player.assists, assists)
    ui.set_visible(elements.player.deaths, deaths)
    ui.set_visible(elements.player.mvps, mvps)
    ui.set_visible(elements.player.score, score)
end

local function on_Refresh()
    local mapname = globals.mapname()

    if mapname == nil then
        return
    end

    players = {}
    names = {}

    local only_enemies = ui.get(elements.lists.only_enemies)

    local get_players = {}

    if only_enemies then
        get_players = entity.get_players(true)
    else
        get_players = entity.get_players()
    end

    for i = 1, #get_players do
        local ent = get_players[i]

        local xuid = js.GetXuid(ent)
        local stats = get_stats(xuid, ent)

        if stats.money < 0 then
            stats.money = 0
        elseif stats.money > 16000 then
            stats.money = 16000
        end

        players[i] = stats
    end

    for i = 1, #players do
        local player = players[i]

        names[i] = player.name
    end

    ui.update(elements.lists.listbox, names)
end

local function on_PlayerSelect(self)
    local mapname = globals.mapname()

    if mapname == nil then
        return
    end

    local selected = ui.get(self) + 1

    local player = players[selected]
    local ent = player.ent

    local xuid = js.GetXuid(ent)
    local stats = get_stats(xuid, ent)

    if stats.money < 0 then
        stats.money = 0
    elseif stats.money > 16000 then
        stats.money = 16000
    end

    ui.set(elements.player.ping, stats.ping)
    ui.set(elements.player.money, stats.money)
    ui.set(elements.player.kills, stats.kills)
    ui.set(elements.player.assists, stats.assists)
    ui.set(elements.player.deaths, stats.deaths)
    ui.set(elements.player.mvps, stats.mvps)
    ui.set(elements.player.score, stats.score)
end

local function on_player_death(e)
    local killer = client.userid_to_entindex(e.attacker)
	local dead = client.userid_to_entindex(e.userid)
    local assister = client.userid_to_entindex(e.assister)

	if not players[killer] then
		local xuid = js.GetXuid(killer)
		players[killer] = get_stats(xuid, killer)
	end

	if not players[dead] then
		local xuid = js.GetXuid(dead)
		players[dead] = get_stats(xuid, dead)
	end

	if assister and not players[assister] then
		local xuid = js.GetXuid(assister)
		players[assister] = get_stats(xuid, assister)
	end

    players[killer].kills = players[killer].kills + 1
    
	players[dead].deaths = players[dead].deaths + 1

	if assister then
        players[assister].assists = players[assister].assists + 1
    end
end

local function on_player_connect_full(e)
    names = {}

    local ent = client.userid_to_entindex(e.userid)
    local xuid = js.GetXuid(ent)

    local stats = get_stats(xuid, ent)

    if stats.money < 0 then
        stats.money = 0
    elseif stats.money > 16000 then
        stats.money = 16000
    end

    players[ent] = stats

    for i = 1, #players do
        local player = players[i]
        names[i] = player.name
    end

    ui.update(elements.lists.listbox, names)
end

local function on_shutdown()
    if SpoofServerName then
        SpoofServerName.disable()
    end
    
    if SpoofStats then
        SpoofStats.disable()
    end

    if SpoofClantag then
        SpoofClantag.disable()
    end

    if SpoofName then
        SpoofName.disable()
    end

    ui.set_visible(elements.server.stop_spoof, false)
end

local function on_FakeMedia(self)
    local value = ui.get(self)
    local callback = value and client.set_event_callback or client.unset_event_callback

    if value then
        on_Refresh()
        on_PlayerSelect(elements.lists.listbox)
    end

    callback("player_connect_full", on_player_connect_full)
    callback("player_death", on_player_death)

    ui.set_visible(elements.lists.label, value)
    ui.set_visible(elements.lists.listbox, value)
    ui.set_visible(elements.lists.only_enemies, value)
    ui.set_visible(elements.lists.refresh, value)
    ui.set_visible(elements.lists.reset, value)

    ui.set_visible(elements.player.multiselect, value)
    ui.set_visible(elements.player.start_spoof_stats, value)
    ui.set_visible(elements.player.stop_spoof_stats, value)
    ui.set_visible(elements.player.label_clantag, value)
    ui.set_visible(elements.player.clantag, value)
    ui.set_visible(elements.player.start_spoof_clantag, value)
    ui.set_visible(elements.player.stop_spoof_clantag, value)
    ui.set_visible(elements.player.label_name, value)
    ui.set_visible(elements.player.name, value)
    ui.set_visible(elements.player.start_spoof_name, value)
    ui.set_visible(elements.player.stop_spoof_name, value)

    ui.set_visible(elements.server.server_before, value)
    ui.set_visible(elements.server.label, value)
    ui.set_visible(elements.server.servername, value)
    ui.set_visible(elements.server.start_spoof, value)
    ui.set_visible(elements.server.stop_spoof, false)
end

local function callbacks()
    ui.set_callback(elements.fake_media, on_FakeMedia)
    on_FakeMedia(elements.fake_media)

    ui.set_callback(elements.lists.listbox, on_PlayerSelect)
    ui.set_callback(elements.lists.only_enemies, on_Refresh)
    ui.set_callback(elements.lists.refresh, on_Refresh)
    ui.set_callback(elements.lists.reset, on_shutdown)

    ui.set_callback(elements.player.multiselect, on_SpoofOptions)
    on_SpoofOptions(elements.player.multiselect)

    ui.set_callback(elements.player.start_spoof_stats, on_SpoofStats)
    ui.set_callback(elements.player.stop_spoof_stats, off_SpoofStats)

    ui.set_callback(elements.player.start_spoof_clantag, on_SpoofClantag)
    ui.set_callback(elements.player.stop_spoof_clantag, off_SpoofClantag)

    ui.set_callback(elements.player.start_spoof_name, on_SpoofName)
    ui.set_callback(elements.player.stop_spoof_name, off_SpoofName)

    ui.set_callback(elements.server.start_spoof, on_SpoofServerName)
    ui.set_callback(elements.server.stop_spoof, off_SpoofServerName)

    client.set_event_callback("shutdown", on_shutdown)
end
callbacks()