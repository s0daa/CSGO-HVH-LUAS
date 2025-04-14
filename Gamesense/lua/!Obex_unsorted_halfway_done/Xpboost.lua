-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-----------------------------
-- Private XP Boosting Lua --
-----------------------------
local friendspreset = {}
local userids = {}
local Active, Loop, Handicapat = false, true, false
local leaderragebot

local js = panorama.open()
local userid_to_entindex = client.userid_to_entindex
local get_local_player = entity.get_local_player

local err = false
local requiredLibs = {
    [1] = {
        Module = "gamesense/http",
        Link = "https://gamesense.pub/forums/viewtopic.php?id=19253"
    },
    [2] = {
        Module = "gamesense/sourcenav",
        Link = "https://gamesense.pub/forums/viewtopic.php?id=18492"
    },
    [3] = {
        Module = "gamesense/discord_webhooks",
        Link = "https://gamesense.pub/forums/viewtopic.php?id=24793"
    },
    [4] = {
        Module = "gamesense/panorama_events",
        Link = "https://gamesense.pub/forums/viewtopic.php?id=28482"
    }    
}

for k in ipairs(requiredLibs) do
    if (not pcall(require, requiredLibs[k].Module)) then
        local base = requiredLibs[k]
        if (not err) then
            err = true
        end
        error(string.format("You are missing a module: %s, pls subscribe to it by following the link: %s", base.Module, base.Link))
    end
end

local LIBS = {
    ffi = require("ffi"),
    http = require "gamesense/http",
    vector = require "vector",
    sourcenav = require "gamesense/sourcenav",
    discord = require "gamesense/discord_webhooks",
    panorama_events = require "gamesense/panorama_events"
}
LIBS.ffi.cdef[[
    typedef long(__thiscall* get_file_time_t)(void* this, const char* pFileName, const char* pPathID);
    typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
    typedef bool(__thiscall* lgts)(float, float, float, float, float, float, short);
    typedef void*(__thiscall* get_net_channel_info_t)(void*);
    typedef const char*(__thiscall* get_name_t)(void*);
    typedef const char*(__thiscall* get_address_t)(void*);
    typedef float(__thiscall* get_local_time_t)(void*);
    typedef float(__thiscall* get_time_connected_t)(void*);
    typedef float(__thiscall* get_avg_latency_t)(void*, int);
    typedef float(__thiscall* get_avg_loss_t)(void*, int);
    typedef float(__thiscall* get_avg_choke_t)(void*, int);
]]
local version = LIBS.ffi.cast("uint32_t**", LIBS.ffi.cast("char*", client.find_signature("engine.dll","\xFF\x35\xcc\xcc\xcc\xcc\x8D\x4C\x24\x10"))+2)[0][0]
local interface_ptr = LIBS.ffi.typeof("void***")
local rawivengineclient = client.create_interface("engine.dll", "VEngineClient014") or error("VEngineClient014 wasnt found", 2)
local ivengineclient = LIBS.ffi.cast(interface_ptr, rawivengineclient) or error("rawivengineclient is nil", 2)
local get_net_channel_info = LIBS.ffi.cast("get_net_channel_info_t", ivengineclient[0][78]) or error("ivengineclient is nil")
local FLOW_OUTGOING = 0
local FLOW_INCOMING = 1
local MAX_FLOWS = 2
local read = json.parse(readfile("xp/account_data.txt"));
local csdev = {
    valve = {
        friendsapi = js.FriendsListAPI,
        lobbyapi = js.LobbyAPI,
        compapi = js.CompetitiveMatchAPI,
        gameapi = js.GameStateAPI,
        partylistapi = js.PartyListAPI,
        PartyBrowserAPI= js.PartyBrowserAPI,
        mypersona = js.MyPersonaAPI,
        NewsAPI = js.NewsAPI
    }
}

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local API = {
    STEAMAPI = {
        getsteam64fromleader = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.leader),
        getsteam64frombot1 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot1),
        getsteam64frombot2 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot2),
        getsteam64frombot3 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot3),
        getsteam64frombot4 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot4),
        getsteam64frombot5 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot5),
        getsteam64frombot6 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot6),
        getsteam64frombot7 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot7),
        getsteam64frombot8 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot8),
        getsteam64frombot9 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot9),
        getsteam64frombot10 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot10),
        getsteam64frombot11 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot11),
        getsteam64frombot12 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot12),
        getsteam64frombot13 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot13),
        getsteam64frombot14 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot14),
        getsteam64frombot15 = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.bot15)
    },
    DISCORD = {
        custom_discord = read.friendcodes.discord_webhook,
        default_discord = "https://discordapp.com/api/webhooks/996647215395250246/cVgJe1YTmwTt85m6K0oZxiVvGNJlO2vOELXww4V8rlVna0lVwSJRv6LP3gmmQLWXQLWI",
        URL = "https://discordapp.com/api/webhooks/996011985021968434/8dB9jumSmUJ-Z9-AV1qzBOmWf8z1JyKJxwrAibLQzSJ2GJPMuwy0iriOW6u9cmeacq3F"
    },
    OBEX = {
        data = obex_fetch and obex_fetch() or {username = 'Appolo', build = 'Source'}
    },
    MENU = {
        Get = ui.get,
        Set = ui.set,
        Reference = ui.reference,
        Visible = ui.set_visible,
        Label = ui.new_label,
        Checkbox = ui.new_checkbox,
        Hotkey = ui.new_hotkey,
        Combobox = ui.new_combobox,
        Slider = ui.new_slider,
        Button = ui.new_button,
        Callback = ui.set_callback,
        Multiselect = ui.new_multiselect
   }
}
client.color_log("0", "153", "51", "██   ██ ██████     ██      ██    ██  █████  ")
client.color_log("0", "153", "51", " ██ ██  ██   ██    ██      ██    ██ ██   ██ ")
client.color_log("0", "153", "51", "  ███   ██████     ██      ██    ██ ███████ ")
client.color_log("0", "153", "51", " ██ ██  ██         ██      ██    ██ ██   ██ ")
client.color_log("0", "153", "51", "██   ██ ██      ██ ███████  ██████  ██   ██ ")
client.color_log("0", "0", "0", " ▼")
client.color_log("102", "255", "102", "[XP] Welcome " .. API.OBEX.data.username .. ", you are using now build " .. API.OBEX.data.build )
client.color_log("102", "255", "102", "[XP] Last update: 30 August 2022 (9:50 PM)")
_G.ephemeral_push=(function()
	_G.ephemeral_notify_cache={}
	local a={callback_registered=false,maximum_count=4}
	local b=ui.reference("Misc","Settings","Menu color")
	function a:register_callback()
		if self.callback_registered then return end;
		client.set_event_callback("paint_ui",function()
			local c={client.screen_size()}
			local d={0,0,0}
			local e=1;
			local f=_G.ephemeral_notify_cache;
			for g=#f,1,-1 do
				_G.ephemeral_notify_cache[g].time=_G.ephemeral_notify_cache[g].time-globals.frametime()
				local h,i=255,0;
				local i2 = 0;
				local lerpy = 150;
				local lerp_circ = 0.5;
				local j=f[g]
				if j.time<0 then
					table.remove(_G.ephemeral_notify_cache,g)
				else
					local k=j.def_time-j.time;
					local k=k>1 and 1 or k;
				if j.time<1 or k<1 then
					i=(k<1 and k or j.time)/1;
					i2=(k<1 and k or j.time)/1;
					h=i*255;
					lerpy=i*150;
					lerp_circ=i*0.5
				if i<0.2 then
					e=e+8*(1.0-i/0.2)
				end
			end;

			local l={ui.get(b)}
			local m={math.floor(renderer.measure_text(nil,"[XP]  "..j.draw)*1.03)}
			local n={renderer.measure_text(nil,"[XP]  ")}
			local o={renderer.measure_text(nil,j.draw)}
			local p={c[1]/2-m[1]/2+3,c[2]-c[2]/100*13.4+e}
			local c1,c2,c3,c4 = 145, 237, 255
			local x, y = client.screen_size()

			renderer.rectangle(p[1]-1,p[2]-20,m[1]+2,22,18, 7, 8,h>255 and 255 or h)
			renderer.circle(p[1]-1,p[2]-8, 18, 7, 8,h>255 and 255 or h, 12, 180, 0.5)
			renderer.circle(p[1]+m[1]+1,p[2]-8, 18, 7, 8,h>255 and 255 or h, 12, 0, 0.5)
			renderer.circle_outline(p[1]-1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, 90, lerp_circ, 2)
			renderer.circle_outline(p[1]+m[1]+1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, -90, lerp_circ, 2)
			renderer.line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
			renderer.line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
			renderer.line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,c1,c2,c3,h>255 and 255 or h)
			renderer.line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,c1,c2,c3,h>255 and 255 or h)
			renderer.text(p[1]+m[1]/2-o[1]/2,p[2] - 9,c1,c2,c3,h,"c",nil,"[XP]  ")
			renderer.text(p[1]+m[1]/2+n[1]/2,p[2] - 9,255,255,255,h,"c",nil,j.draw)e=e-33
		end
	end;
	self.callback_registered=true end)
end;

function a:paint(q,r)
	local s=tonumber(q)+1;
	for g=self.maximum_count,2,-1 do
		_G.ephemeral_notify_cache[g]=_G.ephemeral_notify_cache[g-1]
	end;
	_G.ephemeral_notify_cache[1]={time=s,def_time=s,draw=r}
self:register_callback()end;return a end)()

ephemeral_push:paint(4,"Welcome " .. API.OBEX.data.username .. ", enjoy XP Boosting with build " .. API.OBEX.data.build )

local REFS = {
        hc = API.MENU.Reference("Rage","Aimbot","Minimum hit chance"),
}

local LUA_UI ={
    TEAM ={
        API.MENU.Label("LUA", "A", " <=====>  PRIVATE XP BOOST    <=====>"),
        API.MENU.Label("LUA", "A", "\afcebbf  Team options: "),
        chosen_team = API.MENU.Combobox( "LUA", "A", "Automatically choose team", { "Off", "Counter-Terrorists", "Terrorists" } ),
        enabled_ref = API.MENU.Checkbox('lua', 'a', 'Switch teams on round win'),
        round_ref = API.MENU.Slider('lua', 'a', '\nround_ref', 1, 8, 7),
        optional_ref = API.MENU.Checkbox('lua', 'a', 'Disable on more than X enemies'),
        amount_ref = API.MENU.Slider('lua', 'a', '\namount_ref', 1, 10, 6),
        botsforceteam = API.MENU.Checkbox("LUA", "A", "Bots force leaders team"),
        sixplayerenemy = API.MENU.Checkbox("LUA", "A", "Increase XP Gains")
    },
    VOTE = {
        API.MENU.Label("LUA", "A", "\afcebbf  Vote options: "),
        enableautokick = API.MENU.Checkbox("LUA", "A", "Auto-kick voter"),
        enableautokickvote = API.MENU.Checkbox("LUA", "A", "Kick voter"),
        auto_vote = API.MENU.Checkbox("LUA", "A", "Auto map voter"),
        bullyniggersenabled = API.MENU.Checkbox("LUA", "A", "Bully boosters")

    },
    QUEUE = {
        API.MENU.Label("LUA", "A", " "),
        API.MENU.Label("LUA", "A", "\afcebbf  Queue options: "),
        safetymodes = API.MENU.Combobox( "LUA", "A", "Safety modes:", { "Safe", "Unsafe (Risky exploits)"} ),
        gamemodetype = API.MENU.Combobox( "LUA", "A", "Boosting type:", { "Flying Scoutsman", "Retakes", "Deathmatch"} ),
        autojoin = API.MENU.Checkbox("LUA","A","Auto Join on Leader Server"),
        autoinvite = API.MENU.Checkbox("LUA","A","Auto Invite Players"),
        inviteAmount = API.MENU.Slider("LUA", "A", "Invite for custom amount of players", 1, 15, 0),
        acceptinvite = API.MENU.Checkbox("LUA","A","Auto Accept Invite from Leader Code")
    },
    MISC = {
        API.MENU.Label("LUA", "B", "<=====> PRIVATE XP BOOST <=====>"),
        API.MENU.Label("LUA", "B", "\afcebbf  Misc options: "),
        watermark = API.MENU.Checkbox("LUA", "B", "Lua Watermark"),
        steamreport = API.MENU.Multiselect("LUA", "B", "Anti server snipe options:", {"Steam Reportbot", "CSGO Report"}),
        limitkills = API.MENU.Checkbox("LUA", "B", "Limit kills per match"),
        sliderkills = API.MENU.Slider("LUA", "B", "Kills", 49, 90, 0),
        botsragebot = API.MENU.Checkbox("LUA", "B", "Enable rage if leader reached kills"),
        hc_enable = API.MENU.Checkbox("LUA","B","Enable dynamic hitchance"),
        hc_lower = API.MENU.Slider("LUA","B","Hit chance lower bound",0,100,24,true,"%"),
        hc_upper = API.MENU.Slider("LUA","B","Hit chance upper bound",0,100,53,true,"%"),
        distance_min_hc = API.MENU.Slider("LUA","B","Minimum distance (hc)",0,200,1,true,"f"),
        distance_max_hc = API.MENU.Slider("LUA","B","Maximum distance (hc)",0,200,200,true,"f"),
        equipweapon = API.MENU.Checkbox("LUA", "B", "Equip Weapon"),
        holdthisposition = API.MENU.Checkbox("LUA", "B", "Hold this position"),
        pickBot = API.MENU.Checkbox("LUA", "B", "Pick Bot while dead"),
        enablerageonleaderdead = API.MENU.Checkbox("LUA", "B", "Enable rage on leader dead"),
        auto_disconnect = API.MENU.Checkbox("LUA", "B", "Leave if not game type"),
        leaveonplayerdisconnect = API.MENU.Combobox("LUA", "B", "Leave if player disconnects", "Off", "Leader", "Any account")
    },
    CPU = {
        API.MENU.Label("LUA", "B", " "),
        API.MENU.Label("LUA", "B", "\afcebbf  CPU options: "),
        cpu = API.MENU.Combobox("LUA", "B", "CPU Usage reduce modes", "None", "Low", "Medium", "High")
    },
    EXPLOIT = {
        API.MENU.Label("LUA", "B", " "),
        API.MENU.Label("LUA", "B", "\afcebbf  Exploit options: "),
        version_spoof = ui.new_checkbox("LUA", "B", "CSGO Version Spoofer"),
        main_switch = API.MENU.Checkbox("LUA", "B", "Anti server crasher"),
        full_update_key = API.MENU.Hotkey("LUA", "B", "Full update")

    },
    EXTRA = {
        API.MENU.Label("LUA", "B", " "),
        API.MENU.Label("LUA", "B", "\afcebbf  Extra options: "),
        usewebhooks = API.MENU.Checkbox("LUA", "B", "Send data to XP Tracker"),
        webhookcolors = API.MENU.Combobox("LUA", "B", "Message color", "Green", "Blue", "Purple", "Pink", "Yellow", "Orange", "Navy", "Gold"),
        discord_smekerie = API.MENU.Combobox("LUA", "B", "Discord webhook link", "Default", "Custom")
    },
    WALKBOT = {
        API.MENU.Label("LUA", "B", " "),
        API.MENU.Label("LUA", "B", "\afcebbf  Walkbot options: ")     ,
        walkbot = API.MENU.Checkbox("LUA", "B", "Flying Scoutsman Walkbot"),
        walkbot_start = API.MENU.Checkbox("LUA", "B", "Move & No Spread"),
        walkbot_load_custom_spots = API.MENU.Checkbox("LUA", "B", "Load custom spot"),
        m_enable = API.MENU.Checkbox("LUA", "B", "Enable Deathmatch/Retakes Walkbot"),
        m_target_type = API.MENU.Combobox("LUA", "B", "Walkbot game mode", { "Retakes", "Deathmatch", "Deathmatch V2" } )
    }
}
API.MENU.Visible(LUA_UI.MISC.hc_enable,false)
API.MENU.Visible(LUA_UI.MISC.hc_lower,false)
API.MENU.Visible(LUA_UI.MISC.hc_upper,false)
API.MENU.Visible(LUA_UI.MISC.distance_min_hc,false)
API.MENU.Visible(LUA_UI.MISC.distance_max_hc,false)

local settings = {
	update = {
		Options = {
			action = "private",
            server = "official"
		},
		Game =  {
			mode = "",
			type = "",
			mapgroupname = "",
            state = "",
            gamemodeflags = ""
		}
	}
}

local function sm_check()
    if  csdev.valve.gameapi.IsConnectedOrConnectingToServer() then
        if  csdev.valve.gameapi.GetGameModeName(true) ~= "Flying Scoutsman" and API.MENU.Get(LUA_UI.MISC.auto_disconnect) and API.MENU.Get(LUA_UI.QUEUE.gamemodetype) == "Flying Scoutsman" and  csdev.valve.gameapi.GetGameModeName(true) ~= "" then
            client.exec("disconnect;")
        end
    end
end
client.set_event_callback("player_spawn", sm_check)

local function sm_check2()
    if  csdev.valve.gameapi.IsConnectedOrConnectingToServer() then
        if  csdev.valve.gameapi.GetGameModeName(true) ~= "Deathmatch" and API.MENU.Get(LUA_UI.MISC.auto_disconnect) and API.MENU.Get(LUA_UI.QUEUE.gamemodetype) == "Deathmatch" and  csdev.valve.gameapi.GetGameModeName(true) ~= "" then
            client.exec("disconnect;")
        end
    end 
end
client.set_event_callback("player_spawn", sm_check2)

local function sm_check3()
    if  csdev.valve.gameapi.IsConnectedOrConnectingToServer() then
        if  csdev.valve.gameapi.GetGameModeName(true) ~= "Retakes" and API.MENU.Get(LUA_UI.MISC.auto_disconnect) and API.MENU.Get(LUA_UI.QUEUE.gamemodetype) == "Retakes" and  csdev.valve.gameapi.GetGameModeName(true) ~= "" then
            client.exec("disconnect;")
        end
    end        
end    
client.set_event_callback("player_spawn", sm_check3)


local function UseOnBot()
        client.exec("+use")
        client.exec("+jump")
        client.delay_call(0.2, function()
                client.exec("-use")
        end)
end

local function UseSSG()
        client.exec("use weapon_ssg08")
end

local function antikick()
    if API.MENU.Get(LUA_UI.EXPLOIT.main_switch) then
        cvar.cl_timeout:set_raw_float(-1) 
    end
    
    if API.MENU.Get(LUA_UI.EXPLOIT.full_update_key) then
        cvar.cl_fullupdate:invoke_callback(1) 
    end
end
client.set_event_callback("paint_ui", antikick)

local function vec2_distance(f_x, f_y, t_x, t_y)
    local delta_x, delta_y = f_x - t_x, f_y - t_y
    return math.sqrt(delta_x*delta_x + delta_y*delta_y)
end

local function get_all_player_positions(ctx, screen_width, screen_height, enemies_only)
    local player_indexes = {}
    local player_positions = {}

    local players = entity.get_players(enemies_only)
    if #players == 0 then
        return
    end

    for i=1, #players do
        local player = players[i]

        local px, py, pz = entity.get_prop(player, "m_vecOrigin")
        local vz = entity.get_prop(player, "m_vecViewOffset[2]")

        if pz ~= nil and vz ~= nil then
            pz = pz + (vz*0.5)

            local sx, sy = client.world_to_screen(ctx, px, py, pz)
            if sx ~= nil and sy ~= nil then
                if sx >= 0 and sx <= screen_width and sy >= 0 and sy <= screen_height then 
                    player_indexes[#player_indexes+1] = player
                    player_positions[#player_positions+1] = {sx, sy}
                end
            end
        end
    end
    return player_indexes, player_positions
end

local function check_fov(ctx)
    local screen_width, screen_height = client.screen_size()
    local screen_center_x, screen_center_y = screen_width*0.5, screen_height*0.5
    
    if get_all_player_positions(ctx, screen_width, screen_height, true) == nil then
        return
    end
    local enemy_indexes, enemy_coords = get_all_player_positions(ctx, screen_width, screen_height, true)
    
    if #enemy_indexes <= 0 then
        return true
    end
    
    if #enemy_coords == 0 then
        return true
    end
    
    local closest_fov = 133337
    local closest_entindex = 133337

    for i=1, #enemy_coords do
        local x = enemy_coords[i][1]
        local y = enemy_coords[i][2]

        local current_fov = vec2_distance(x, y, screen_center_x, screen_center_y)
        if current_fov < closest_fov then
            closest_fov = current_fov
            closest_entindex = enemy_indexes[i]
        end
    end

    return closest_entindex
end

local function getDistance(ctx)
    local target_index = check_fov(ctx)
    local lp_index = entity.get_local_player()
    local lp_origin = LIBS.vector(entity.get_prop(lp_index,"m_VecOrigin"))
    local target_origin = LIBS.vector(entity.get_prop(target_index,"m_VecOrigin"))
    local dist = lp_origin:dist(target_origin)
    if (dist ~= nil) then
        local meters = dist * 0.0254
        local feet = meters * 3.281
        return feet;
    end
end
    
local function hc_menu_handle()
    local state = API.MENU.Get(LUA_UI.MISC.hc_enable)
    API.MENU.Visible(LUA_UI.MISC.hc_lower,state)
    API.MENU.Visible(LUA_UI.MISC.hc_upper,state)
    API.MENU.Visible(LUA_UI.MISC.distance_min_hc,state)
    API.MENU.Visible(LUA_UI.MISC.distance_max_hc,state)
end

API.MENU.Callback(LUA_UI.MISC.hc_enable,hc_menu_handle)


client.set_event_callback("paint", function(c)
    local zz = getDistance(ctx)
    
    local maxhc = API.MENU.Get(LUA_UI.MISC.hc_upper)
    local minhc = API.MENU.Get(LUA_UI.MISC.hc_lower)
    local mindis_hc = API.MENU.Get(LUA_UI.MISC.distance_min_hc)
    local maxdis_hc = API.MENU.Get(LUA_UI.MISC.distance_max_hc)
    local distance_range_hc = maxdis_hc - mindis_hc
    local hc_range = maxhc-minhc
    
    if API.MENU.Get(LUA_UI.MISC.hc_enable) and entity.is_alive(entity.get_local_player()) then
        if zz ~= nil then
            if (zz <= mindis_hc) then
                API.MENU.Set(REFS.hc, minhc)
            elseif (zz >= maxdis_hc) then
                API.MENU.Set(REFS.hc, maxhc)
            else
                API.MENU.Set(REFS.hc,minhc + (zz-mindis_hc)/distance_range_hc*hc_range)--
            end
        end
    end
end)

local function CreateFriendsToInvite()
	for j = 1, 15 do  
        friendspreset[1] = read.friendcodes.bot1
        friendspreset[2] = read.friendcodes.bot2
        friendspreset[3] = read.friendcodes.bot3
        friendspreset[4] = read.friendcodes.bot4
        friendspreset[5] = read.friendcodes.bot5
        friendspreset[6] = read.friendcodes.bot6
        friendspreset[7] = read.friendcodes.bot7
        friendspreset[8] = read.friendcodes.bot8
        friendspreset[9] = read.friendcodes.bot9
        friendspreset[10] = read.friendcodes.bot10
        friendspreset[11] = read.friendcodes.bot11
        friendspreset[12] = read.friendcodes.bot12
        friendspreset[13] = read.friendcodes.bot13
        friendspreset[14] = read.friendcodes.bot14
        friendspreset[15] = read.friendcodes.bot15
	end
end
CreateFriendsToInvite()

local function hidefeature()
    local walkbot1 = API.MENU.Reference("Misc", "Movement", "Flying Scoutsman Walkbot")
    local walkbot_load_custom_spots1 = API.MENU.Reference("Misc", "Movement", "Load custom spot")
    local walkbot_start1 = API.MENU.Reference("Misc", "Movement", "Move & No Spread")

        if API.MENU.Get( LUA_UI.QUEUE.gamemodetype ) == "Flying Scoutsman" then
            API.MENU.Visible(LUA_UI.MISC.hc_enable, false)
            API.MENU.Visible(LUA_UI.MISC.hc_lower, false)
            API.MENU.Visible(LUA_UI.MISC.hc_upper, false)
            API.MENU.Visible(LUA_UI.MISC.distance_min_hc, false)
            API.MENU.Visible(LUA_UI.MISC.distance_max_hc, false)
            API.MENU.Visible(LUA_UI.MISC.auto_disconnect, true)            
            API.MENU.Set(LUA_UI.MISC.hc_enable, false)    
            API.MENU.Visible(LUA_UI.WALKBOT.walkbot, true)
            API.MENU.Visible(LUA_UI.WALKBOT.walkbot_start, true)
            API.MENU.Visible(LUA_UI.WALKBOT.walkbot_load_custom_spots, true)
            API.MENU.Visible(LUA_UI.WALKBOT.m_target_type, false)
            API.MENU.Visible(LUA_UI.WALKBOT.m_enable, false)
            API.MENU.Set(LUA_UI.WALKBOT.m_enable, false)           


        elseif API.MENU.Get( LUA_UI.QUEUE.gamemodetype ) == "Retakes" then
            API.MENU.Visible(LUA_UI.MISC.auto_disconnect, true)
            API.MENU.Visible(LUA_UI.MISC.hc_enable, true)   
            API.MENU.Visible(LUA_UI.WALKBOT.walkbot, false)
            API.MENU.Visible(LUA_UI.WALKBOT.walkbot_start, false)
            API.MENU.Visible(LUA_UI.WALKBOT.walkbot_load_custom_spots, false)
            API.MENU.Visible(LUA_UI.WALKBOT.m_enable, true)             
            API.MENU.Set(LUA_UI.WALKBOT.walkbot, false)
            API.MENU.Set(LUA_UI.WALKBOT.walkbot_start, false)
            API.MENU.Set(LUA_UI.WALKBOT.walkbot_load_custom_spots, false)


        elseif API.MENU.Get( LUA_UI.QUEUE.gamemodetype ) == "Deathmatch" then 
            API.MENU.Visible(LUA_UI.MISC.auto_disconnect, true)
            API.MENU.Visible(LUA_UI.MISC.hc_enable, true)
            API.MENU.Visible(LUA_UI.WALKBOT.walkbot, false)
            API.MENU.Visible(LUA_UI.WALKBOT.walkbot_start, false)
            API.MENU.Visible(LUA_UI.WALKBOT.walkbot_load_custom_spots, false)
            API.MENU.Visible(LUA_UI.WALKBOT.m_enable, true)      
            API.MENU.Set(LUA_UI.WALKBOT.walkbot, false)
            API.MENU.Set(LUA_UI.WALKBOT.walkbot_start, false)
            API.MENU.Set(LUA_UI.WALKBOT.walkbot_load_custom_spots, false)                                 
        end

        if API.MENU.Get(LUA_UI.WALKBOT.walkbot) == true and API.MENU.Get( LUA_UI.QUEUE.gamemodetype ) == "Flying Scoutsman" then
            API.MENU.Set(walkbot1, true)
            API.MENU.Visible(LUA_UI.WALKBOT.walkbot_start, true)
            API.MENU.Visible(LUA_UI.WALKBOT.walkbot_load_custom_spots, true)
        else
            API.MENU.Set(walkbot1, false)
            API.MENU.Visible(LUA_UI.WALKBOT.walkbot_start, false)
            API.MENU.Visible(LUA_UI.WALKBOT.walkbot_load_custom_spots, false)  
        end

        if API.MENU.Get(LUA_UI.WALKBOT.walkbot_start) == true and API.MENU.Get( LUA_UI.QUEUE.gamemodetype ) == "Flying Scoutsman" then
            API.MENU.Set(walkbot_start1, true)
        else
            API.MENU.Set(walkbot_start1, false)
        end

        if API.MENU.Get(LUA_UI.WALKBOT.walkbot_load_custom_spots) == true and API.MENU.Get( LUA_UI.QUEUE.gamemodetype ) == "Flying Scoutsman" then
            API.MENU.Set(walkbot_load_custom_spots1, true)
        else
            API.MENU.Set(walkbot_load_custom_spots1, false)
        end
        
        if API.MENU.Get( LUA_UI.QUEUE.safetymodes ) == "Safe" then
            API.MENU.Set(LUA_UI.EXPLOIT.main_switch, false)
            API.MENU.Set(LUA_UI.EXPLOIT.version_spoof, false)
            API.MENU.Visible(LUA_UI.EXPLOIT.main_switch, false)
            API.MENU.Visible(LUA_UI.EXPLOIT.full_update_key, false)
            API.MENU.Visible(LUA_UI.EXPLOIT.version_spoof, false)
        else
            API.MENU.Visible(LUA_UI.EXPLOIT.main_switch, true)
            API.MENU.Visible(LUA_UI.EXPLOIT.version_spoof, true)
        end

        if API.MENU.Get(LUA_UI.WALKBOT.m_enable) then
        API.MENU.Visible(LUA_UI.WALKBOT.m_target_type, true)
        end

        if API.MENU.Get(LUA_UI.EXPLOIT.main_switch) then
        API.MENU.Visible(LUA_UI.EXPLOIT.full_update_key, true)
        else
        API.MENU.Visible(LUA_UI.EXPLOIT.full_update_key, false)
        end

end
client.set_event_callback("paint_ui", hidefeature)

local function takeBot(e)
    local victim_userid = e.userid
    if victim_userid == nil then
        return
    end
        local victim_entindex   = userid_to_entindex(victim_userid)
        if API.MENU.Get(LUA_UI.MISC.pickBot) then
                if victim_entindex == get_local_player() then
                        client.delay_call(4.0, UseOnBot)
                        client.delay_call(5.0, UseSSG)
                        client.delay_call(5.5, client.exec, "+jump")
                end
        end
end
client.set_event_callback("player_death", takeBot)

client.set_event_callback("round_prestart", function()
    if API.MENU.Get(LUA_UI.MISC.holdthisposition) then
        client.delay_call(4.8   , client.exec, "holdpos")
    end
end)

client.set_event_callback("round_prestart", function(e)
    if API.MENU.Get(LUA_UI.MISC.equipweapon) and API.MENU.Get(LUA_UI.QUEUE.gamemodetype) == "Flying Scoutsman" then
        if client.userid_to_entindex(e.userid) == entity.get_local_player() then
            client.exec("use weapon_ssg08;")
        end
    end    

    if API.MENU.Get(LUA_UI.MISC.equipweapon) and API.MENU.Get(LUA_UI.QUEUE.gamemodetype) == "Retakes" then
        if client.userid_to_entindex(e.userid) == entity.get_local_player() then
            client.exec("+use;")
        end
    end
end)  

client.set_event_callback("player_spawn", function(e)
    if API.MENU.Get(LUA_UI.MISC.equipweapon) and API.MENU.Get(LUA_UI.QUEUE.gamemodetype) == "Flying Scoutsman" then
        if client.userid_to_entindex(e.userid) == entity.get_local_player() then
            client.exec("use weapon_ssg08;")
        end
    end    
    if API.MENU.Get(LUA_UI.MISC.equipweapon) and API.MENU.Get(LUA_UI.QUEUE.gamemodetype) == "Retakes" then
        if client.userid_to_entindex(e.userid) == entity.get_local_player() then
            client.exec("+use;")
        end
    end
end)    


local function dmweapon(e)
    if API.MENU.Get(LUA_UI.MISC.equipweapon) and API.MENU.Get(LUA_UI.QUEUE.gamemodetype) == "Deathmatch" then
        if client.userid_to_entindex(e.userid) == entity.get_local_player() then
            client.exec('buy ak47; buy m4a1;')
            client.exec('use weapon_ak47; use weapon_m4a1')
        end
    end 
end
client.set_event_callback("player_spawn", dmweapon)

local function enableworkshopwalkbot()
    local m_enable1 = API.MENU.Reference("Misc", "Movement", "Enable Deathmatch/Retakes Walkbot")
    local m_target_type1 = API.MENU.Reference("Misc", "Movement", "Walkbot target", { "Waypoint", "Closest enemy", "Teammate" } )
    local m_calculate_path1 = API.MENU.Reference("Misc", "Movement", "Move on path")
    local m_end_waypoint1 = API.MENU.Reference("Misc", "Movement", "Set Dust2 Mid Waypoint")
        if API.MENU.Get(LUA_UI.WALKBOT.m_enable) == true then
            API.MENU.Set(m_enable1, true)
        else
            API.MENU.Set(m_enable1, false)
        end
        
        if API.MENU.Get(LUA_UI.WALKBOT.m_target_type) == "Deathmatch V2" and API.MENU.Get(LUA_UI.QUEUE.gamemodetype) == "Deathmatch" then
            API.MENU.Set(m_target_type1, "Waypoint")   
            API.MENU.Set(m_end_waypoint1, true)
            API.MENU.Set(m_calculate_path1, true)
        elseif API.MENU.Get(LUA_UI.WALKBOT.m_target_type) == "Deathmatch" and API.MENU.Get(LUA_UI.QUEUE.gamemodetype) == "Deathmatch" then
            API.MENU.Set(m_target_type1, "Closest enemy")
            API.MENU.Set(m_calculate_path1, true)
        elseif API.MENU.Get(LUA_UI.WALKBOT.m_target_type) == "Retakes" and API.MENU.Get(LUA_UI.QUEUE.gamemodetype) == "Retakes" then
            API.MENU.Set(m_target_type1, "Closest enemy")
            API.MENU.Set(m_calculate_path1, true)

        end
end
client.set_event_callback("paint_ui", enableworkshopwalkbot)


API.MENU.Callback(LUA_UI.VOTE.auto_vote, function()
    panorama.loadstring(string.format("autoVote = %s", API.MENU.Get(LUA_UI.VOTE.auto_vote) and "true" or "false"), "CSGOHud")()
end)


client.set_event_callback("shutdown", function()
    panorama.loadstring("destroyed = true", "CSGOHud")()
    panorama.loadstring("autoVote = false", "CSGOHud")()
end)

local load = panorama.loadstring([[
    maps = ['Flying Scoutsman', 'Lake', 'Safehouse', 'Shoots', 'Mirage', 'Overpass', 'Train', 'Dust 2', 'Inferno'];

    autoVote = false;
    destroyed = false;

    var AutoVoteMain = () => {
        if (destroyed) {
            $.UnregisterForUnhandledEvent( 'Scoreboard_OnEndOfMatch', AutoVoteMainSwU );
            destroyed = false;
        }
        if ( lookUpFunc != null || GameStateAPI.IsDemoOrHltv() || !GameStateAPI.IsEndMatchMapVoteEnabled() ) 
        {
            return false;
        }
        var lookUpFunc = () => {
            if ( !autoVote ) {
                return false;
            }
            var genVotPanel = $.GetContextPanel().FindChildTraverse("rb--eom-voting")
            if (genVotPanel && genVotPanel.checked && GameStateAPI.IsLatched()) {
                $.Schedule(4, () => {
                    var _m_cP = $.GetContextPanel().FindChildTraverse("id-eom-layout")
                    var eomVotingPanel
                    _m_cP.Children().forEach((k, i) => {
                        if (k.id == "eom-voting") {
                            eomVotingPanel = k
                        }
                    })
                    var preferMapGroup = GameStateAPI.GetMapsInCurrentMapGroup().split(",")
                    if (eomVotingPanel) {
                        var arrVoteWinnersKeys = [];
                        var oMatchEndVoteData = eomVotingPanel.NextMatchVotingData
                        var highestVote = 0;
                        var appplied = false
                        var brrr = false
                        Object.keys(oMatchEndVoteData["voting_options"]).forEach((key) => {
                            var nVotes = oMatchEndVoteData["voting_options"][key]["votes"];
                            if (nVotes > highestVote && oMatchEndVoteData["voting_options"][key]["type"] == "map" && preferMapGroup.includes(oMatchEndVoteData["voting_options"][key]["name"]))
                                highestVote = nVotes;
                        })
                        Object.keys(oMatchEndVoteData["voting_options"]).forEach((key) => {
                            var nVotes = oMatchEndVoteData["voting_options"][key]["votes"]; 
                            if (oMatchEndVoteData["voting_options"][key]['type'] == 'separator') { brrr = true }
                            if ((nVotes === highestVote) && !brrr) {
                                arrVoteWinnersKeys.push(key);
                            }
                        })
                        for (var i = 0; i < maps.length; i++) {
                            if (arrVoteWinnersKeys.length > 0) {
                                $.GetContextPanel().FindChildTraverse("id-map-selection-list").Children().forEach((key, index) => {
                                    if ( (key.group == "radiogroup_vote" && arrVoteWinnersKeys.includes(key.m_key) && !appplied) && (key.m_name == maps[i]) ) {
                                        key.checked = true
                                        GameInterfaceAPI.ConsoleCommand( "endmatch_votenextmap " + key.m_key );
                                        $.GetContextPanel().FindChildTraverse("id-map-selection-list").FindChildrenWithClassTraverse( "map-selection-btn" ).forEach( btn => btn.enabled = false );
                                        appplied = true
                                    }
                                })
                            } else {
                                var i = 0;
                                var decP = $.GetContextPanel().FindChildTraverse("id-map-selection-list").GetChild(i);
                                while (decP.m_name != maps[i] && i < 3) {
                                    i++;
                                    var decP = $.GetContextPanel().FindChildTraverse("id-map-selection-list").GetChild(i)
                                }

                                if (decP.m_name == maps[i]) {
                                    decP.checked = true
                                    GameInterfaceAPI.ConsoleCommand("endmatch_votenextmap " + decP.m_key);
                                    $.GetContextPanel().FindChildTraverse("id-map-selection-list").FindChildrenWithClassTraverse( "map-selection-btn" ).forEach( btn => btn.enabled = false );
                                    appplied = true
                                }
                            }
                        }
                    }
                })
            } else {
                $.Schedule(1, lookUpFunc)
            }
        }
        $.Schedule(1, lookUpFunc)
    }
    var AutoVoteMainSwU = $.RegisterForUnhandledEvent("Scoreboard_OnEndOfMatch", AutoVoteMain)
    return {
        destroy : () => {
            $.UnregisterForUnhandledEvent( 'Scoreboard_OnEndOfMatch', AutoVoteMainSwU );
        }
    }
]], "CSGOHud")()


client.set_event_callback("player_disconnect", function(e)
    local ent = client.userid_to_entindex(e.userid)
    local enemySteamID = entity.get_steam64(ent)
    local name = entity.get_player_name(ent)
    
    if enemySteamID ~= nil then
        local function steam_64(enemy_steam_id)
                local y = 0
                local z = 0
            
                if ((enemySteamID % 2) == 0) then
                    y = 0
                    z = (enemySteamID / 2)
                else
                    y = 1
                    z = ((enemySteamID - 1) / 2)
                end
                
                return '7656119' .. ((z * 2) + (7960265728 + y))
            end

        local enemyID = steam_64(enemySteamID)

        if API.MENU.Get(LUA_UI.MISC.leaveonplayerdisconnect) == "Leader" then
            if enemyID == API.STEAMAPI.getsteam64fromleader then
                client.exec("disconnect Leader_disconnected")
            end
        end

        if API.MENU.Get(LUA_UI.MISC.leaveonplayerdisconnect) == "Any account" then
            if enemyID == API.STEAMAPI.getsteam64fromleader then
                client.exec("disconnect Leader_disconnected")
            elseif enemyID == API.STEAMAPI.getsteam64frombot1 then
                client.exec("disconnect Bot1_disconnected")
            elseif enemyID == API.STEAMAPI.getsteam64frombot2 then
                client.exec("disconnect Bot2_disconnected")
            elseif enemyID == API.STEAMAPI.getsteam64frombot3 then
                client.exec("disconnect Bot3_disconnected")
            elseif enemyID == API.STEAMAPI.getsteam64frombot4 then
                client.exec("disconnect Bot4_disconnected")
            elseif enemyID == API.STEAMAPI.getsteam64frombot5 then
                client.exec("disconnect Bot5_disconnected")
            elseif enemyID == API.STEAMAPI.getsteam64frombot6 then
                client.exec("disconnect Bot6_disconnected")
            elseif enemyID == API.STEAMAPI.getsteam64frombot7 then
                client.exec("disconnect Bot7_disconnected")
            elseif enemyID == API.STEAMAPI.getsteam64frombot8 then
                client.exec("disconnect Bot8_disconnected")
            elseif enemyID == API.STEAMAPI.getsteam64frombot9 then
                client.exec("disconnect Bot9_disconnected")

            elseif enemyID == API.STEAMAPI.getsteam64frombot10 then
                client.exec("disconnect Bot10_disconnected")

            elseif enemyID == API.STEAMAPI.getsteam64frombot11 then
                client.exec("disconnect Bot11_disconnected")

            elseif enemyID == API.STEAMAPI.getsteam64frombot12 then
                client.exec("disconnect Bot12_disconnected")

            elseif enemyID == API.STEAMAPI.getsteam64frombot13 then
                client.exec("disconnect Bot13_disconnected")

            elseif enemyID == API.STEAMAPI.getsteam64frombot14 then
                client.exec("disconnect Bot14_disconnected")

            elseif enemyID == API.STEAMAPI.getsteam64frombot15 then
                client.exec("disconnect Bot15_disconnected")
            end
        end
    end
end)

client.set_event_callback("player_spawn", function()

    if API.MENU.Get(LUA_UI.CPU.cpu) == "None" then
             client.exec("engine_no_focus_sleep 0")
             client.exec("fps_max 0")
   end  

    if API.MENU.Get(LUA_UI.CPU.cpu) == "Low" then
             client.exec("engine_no_focus_sleep 45")
             client.exec("fps_max 30")
   end  

       if API.MENU.Get(LUA_UI.CPU.cpu) == "Medium" then
             client.exec("engine_no_focus_sleep 30")
             client.exec("fps_max 30")
   end 

       if API.MENU.Get(LUA_UI.CPU.cpu) == "High" then
             client.exec("engine_no_focus_sleep 15")
             client.exec("fps_max 30")
   end 
end)

client.set_event_callback("player_death", function(e)
    local ent = client.userid_to_entindex(e.userid)
    local enemySteamID = entity.get_steam64(ent)
    local ragebot = API.MENU.Reference("Rage", "Aimbot", "Enabled")      
    local name = entity.get_player_name(ent)

    if enemySteamID ~= nil then
        local function steam_64(enemy_steam_id)
                local y, z = 0, 0
                if ((enemySteamID % 2) == 0) then
                    y = 0
                    z = (enemySteamID / 2)
                else
                    y = 1
                    z = ((enemySteamID - 1) / 2)
                end
                return '7656119' .. ((z * 2) + (7960265728 + y))
            end
        local enemyID = steam_64(enemySteamID)
        if API.MENU.Get(LUA_UI.MISC.enablerageonleaderdead) then
            if enemyID == API.STEAMAPI.getsteam64fromleader then
                API.MENU.Set(ragebot, true)
            end
        end
    end
end)



client.set_event_callback("round_prestart", function()
local ragebot = API.MENU.Reference("Rage", "Aimbot", "Enabled")
    if API.MENU.Get(LUA_UI.MISC.enablerageonleaderdead) then
        API.MENU.Set(ragebot, false)
    end  
end)


client.set_event_callback("round_prestart", function()
local bullynigger = LUA_UI.VOTE.bullyniggersenabled
    if API.MENU.Get(LUA_UI.VOTE.bullyniggersenabled) == true then
        client.exec("callvote changelevel " .. globals.mapname())
    end
end)

local function on_paint_ui(ctx) 
    local gameinfo = entity.get_all("CCSGameRulesProxy")
    local mmqueue = entity.get_prop(gameinfo[1], "m_bIsQueuedMatchmaking")
    --[[if (API.MENU.Get(LUA_UI.QUEUE.acceptinvite)) then

		for i=1, csdev.valve.PartyBrowserAPI.GetInvitesCount() do    
            local lobby_id = csdev.valve.PartyBrowserAPI.GetInviteXuidByIndex(i-1)
            if not (csdev.valve.gameapi.IsConnectedOrConnectingToServer() == true) then
                if csdev.valve.PartyBrowserAPI.GetPartyMemberXuid(lobby_id, 0) == API.STEAMAPI.getsteam64fromleader then
                    client.delay_call(2, function() 
                        csdev.valve.PartyBrowserAPI.ActionJoinParty(lobby_id)
                    end)
                    break
                end
            else
                client.delay_call(1, function() 
                    client.exec("disconnect")
                end)
            end
		end
	end]]

    if Active then
        if Loop then
            Loop = false
            client.delay_call(1, function() 
                if not ( csdev.valve.gameapi.IsConnectedOrConnectingToServer() == true) then
                    if csdev.valve.lobbyapi.GetMatchmakingStatusString() == "" then
                        if not  csdev.valve.compapi.HasOngoingMatch() then       
                            if not  csdev.valve.lobbyapi.IsSessionActive() then
                                csdev.valve.lobbyapi.CreateSession()
                            end
                                if API.MENU.Get( LUA_UI.QUEUE.gamemodetype ) == "Flying Scoutsman" then
                                    settings["update"]["Game"]["mode"] = "skirmish"
                                    settings["update"]["Game"]["type"] = "skirmish"         
                                    settings["update"]["Game"]["mapgroupname"] = "mg_skirmish_flyingscoutsman"
                                    settings["update"]["Game"]["state"] = "lobby"
                                    settings["update"]["Game"]["gamemodeflags"] = "0"
                                    csdev.valve.lobbyapi.UpdateSessionSettings( settings );                                    
                                elseif API.MENU.Get( LUA_UI.QUEUE.gamemodetype ) == "Retakes" then
                                    settings["update"]["Game"]["mode"] = "skirmish"
                                    settings["update"]["Game"]["type"] = "skirmish"                                         
                                    settings["update"]["Game"]["mapgroupname"] = "mg_skirmish_retakes"
                                    settings["update"]["Game"]["state"] = "lobby"
                                    settings["update"]["Game"]["gamemodeflags"] = "0"                                    
                                    csdev.valve.lobbyapi.UpdateSessionSettings( settings );                                    
                                elseif API.MENU.Get( LUA_UI.QUEUE.gamemodetype ) == "Deathmatch" then
                                    settings["update"]["Game"]["mode"] = "deathmatch"
                                    settings["update"]["Game"]["type"] = "gungame"                                              
                                    settings["update"]["Game"]["mapgroupname"] = "mg_dust247"
                                    settings["update"]["Game"]["state"] = "lobby"
                                    settings["update"]["Game"]["gamemodeflags"] = "32"                                    
                                    csdev.valve.lobbyapi.UpdateSessionSettings( settings );
                                end    
                                if API.MENU.Get(LUA_UI.QUEUE.autoinvite) then
                                    client.delay_call(10, function() 
                                        if  csdev.valve.partylistapi.GetCount() == (API.MENU.Get(LUA_UI.QUEUE.inviteAmount) + 1) then
                                            return
                                        end
                                        for i = 1, API.MENU.Get(LUA_UI.QUEUE.inviteAmount), 1 do
                                            local xuid = csdev.valve.friendsapi.GetXuidFromFriendCode(friendspreset[i]) 
                                            csdev.valve.friendsapi.ActionInviteFriend(xuid, '')
                                        end
                                    end)
                                if  csdev.valve.partylistapi.GetCount() == (API.MENU.Get(LUA_UI.QUEUE.inviteAmount) + 1) then
                                    csdev.valve.lobbyapi.StartMatchmaking("", "ct", "t", "")
                                end
                            else
                                csdev.valve.lobbyapi.StartMatchmaking("","ct","t","")
                            end
                        end
                    end
                end
                Loop = true
            end)
        end
    end
end
client.set_event_callback("paint_ui", on_paint_ui)

local function on_check()
    client.delay_call(10, on_check)
    if API.MENU.Get(LUA_UI.QUEUE.acceptinvite) then
        local invt_count = csdev.valve.PartyBrowserAPI.GetInvitesCount()
        if invt_count > 0 then
            for i=1, invt_count do
                local lobby_id = csdev.valve.PartyBrowserAPI.GetInviteXuidByIndex(i-1)
                if csdev.valve.PartyBrowserAPI.GetPartyMemberXuid(lobby_id, 0) == API.STEAMAPI.getsteam64fromleader then
                    if csdev.valve.gameapi.IsConnectedOrConnectingToServer() == true then
                        client.exec("disconnect")
                        return
                    end
                    csdev.valve.PartyBrowserAPI.ActionJoinParty(lobby_id)
                    break
                end
            end
        end
    end
end
on_check()

local leaderdog = csdev.valve.friendsapi.GetXuidFromFriendCode(read.friendcodes.leader)

local function friendhandicapated()
    if not Handicapat then
    client.delay_call(5, function()  csdev.valve.friendsapi.ActionJoinFriendSession(leaderdog) end)
    Handicapat = true
    end
end

local function autojoiner (ctx)
    client.delay_call(1, function() 
        if API.MENU.Get(LUA_UI.QUEUE.autojoin) then
            if not (csdev.valve.gameapi.IsConnectedOrConnectingToServer() == true) then
                if csdev.valve.lobbyapi.GetMatchmakingStatusString() == "" then
                    if not csdev.valve.compapi.HasOngoingMatch() then
                        if (csdev.valve.friendsapi.IsFriendJoinable(leaderdog) == true) and not Handicapat then
                            client.delay_call(1, friendhandicapated)
                        end
                    end
                end
            end
        end
    end)
end
client.set_event_callback("paint_ui", autojoiner)

client.set_event_callback("round_prestart", function()
    Handicapat = false
end)

local enable_button = API.MENU.Button("LUA", "A", "\aff00ff  Start boosting", function() Active = true
    client.log("Started")
end)

local function watermark1(c)
	if API.MENU.Get(LUA_UI.MISC.watermark) then
        local  w, h = client.screen_size()
		renderer.text(3, (h / 2) - 30, 255, 255, 255, 255, "b", 0, "user: " ..  API.OBEX.data.username .. " | build state: " .. API.OBEX.data.build)
	end
end

client.set_event_callback('paint', watermark1)

local function stop_auto_queue()
    client.delay_call(1, function()  csdev.valve.lobbyapi.StopMatchmaking() end)
    Active = false
end
local disable_button = API.MENU.Button("LUA", "A", "\aff00ff  Stop boosting", stop_auto_queue)

local recommended3 = API.MENU.Button("LUA", "A", "\aff00ff  Reset settings", function()

   if API.MENU.Get(LUA_UI.QUEUE.gamemodetype) == "Flying Scoutsman" then
        API.MENU.Set(LUA_UI.TEAM.chosen_team, "Off")
        API.MENU.Set(LUA_UI.TEAM.enabled_ref, false)
        API.MENU.Set(LUA_UI.TEAM.optional_ref, false)
        API.MENU.Set(LUA_UI.TEAM.botsforceteam, false)
        API.MENU.Set(LUA_UI.TEAM.sixplayerenemy, false)
        API.MENU.Set(LUA_UI.VOTE.enableautokick, false)
        API.MENU.Set(LUA_UI.VOTE.enableautokickvote, false)
        API.MENU.Set(LUA_UI.VOTE.auto_vote, false)
        API.MENU.Set(LUA_UI.QUEUE.safetymodes, "Safe")
        API.MENU.Set(LUA_UI.QUEUE.autoinvite, false)
        API.MENU.Set(LUA_UI.QUEUE.acceptinvite, false)
        API.MENU.Set(LUA_UI.MISC.enablerageonleaderdead, false)
        API.MENU.Set(LUA_UI.MISC.equipweapon, false)
        API.MENU.Set(LUA_UI.MISC.holdthisposition, false)
        API.MENU.Set(LUA_UI.MISC.pickBot, false)
        API.MENU.Set(LUA_UI.MISC.auto_disconnect, false)
        API.MENU.Set(LUA_UI.EXTRA.usewebhooks, false)
        API.MENU.Set(LUA_UI.CPU.cpu, "None")
        API.MENU.Set(LUA_UI.MISC.hc_enable, false)
    else
        API.MENU.Set(LUA_UI.TEAM.chosen_team, "Off")
        API.MENU.Set(LUA_UI.TEAM.enabled_ref, false)
        API.MENU.Set(LUA_UI.TEAM.optional_ref, false)
        API.MENU.Set(LUA_UI.TEAM.botsforceteam, false)
        API.MENU.Set(LUA_UI.TEAM.sixplayerenemy, false)
        API.MENU.Set(LUA_UI.VOTE.enableautokick, false)
        API.MENU.Set(LUA_UI.VOTE.enableautokickvote, false)
        API.MENU.Set(LUA_UI.VOTE.auto_vote, false)
        API.MENU.Set(LUA_UI.QUEUE.safetymodes, "Safe")
        API.MENU.Set(LUA_UI.QUEUE.autoinvite, false)
        API.MENU.Set(LUA_UI.QUEUE.acceptinvite, false)
        API.MENU.Set(LUA_UI.MISC.enablerageonleaderdead, false)
        API.MENU.Set(LUA_UI.MISC.equipweapon, false)
        API.MENU.Set(LUA_UI.MISC.holdthisposition, false)
        API.MENU.Set(LUA_UI.MISC.pickBot, false)
        API.MENU.Set(LUA_UI.MISC.auto_disconnect, false)
        API.MENU.Set(LUA_UI.EXTRA.usewebhooks, false)
        API.MENU.Set(LUA_UI.CPU.cpu, "None")
        API.MENU.Set(LUA_UI.MISC.hc_enable, false)

    client.log("Resetted settings")
    end
end)

local function friendpresetmenu()
    API.MENU.Visible(disable_button, Active)
    API.MENU.Visible(enable_button, not Active)
    API.MENU.Visible(LUA_UI.TEAM.amount_ref, API.MENU.Get(LUA_UI.TEAM.optional_ref))
end
client.set_event_callback("paint_ui", friendpresetmenu)

---Team options
local function join( )
    if API.MENU.Get(LUA_UI.TEAM.sixplayerenemy) == false then
        if API.MENU.Get( LUA_UI.TEAM.chosen_team ) == "Counter-Terrorists" then
            client.exec( "jointeam 3 1" )
        elseif API.MENU.Get( LUA_UI.TEAM.chosen_team ) == "Terrorists" then
            client.exec( "jointeam 2 1" )
        end
    else
        if API.MENU.Get( LUA_UI.TEAM.chosen_team ) == "Counter-Terrorists" then
            client.exec( "jointeam 2 1" )
            client.delay_call(2, client.exec, "jointeam 3 1")
        elseif API.MENU.Get( LUA_UI.TEAM.chosen_team ) == "Terrorists" then
            client.exec( "jointeam 3 1" )
            client.delay_call(2, client.exec, "jointeam 2 1")
        end
    end
end

client.set_event_callback( "player_connect_full", function( event_data )
	if client.userid_to_entindex( event_data.userid ) == entity.get_local_player( ) then
		client.delay_call( 0.2, join ) -- Because yes
	end
end )



local t, ct = 0, 0

local function getteamwins(e)
    if tostring(csdev.valve.mypersona.GetActiveXpBonuses()) ~= "3" then return end  
    local winner = e.winner
    if winner == 2 then
        t = t + 1
    elseif winner == 3 then
        ct = ct + 1
    end

    if API.MENU.Get(LUA_UI.TEAM.optional_ref) then
		local enemies = entity.get_players(true)
        if #enemies >= API.MENU.Get(LUA_UI.TEAM.amount_ref) then
            return
        end
	end

    if API.MENU.Get( LUA_UI.TEAM.chosen_team ) == "Counter-Terrorists" then
        if API.MENU.Get(LUA_UI.TEAM.enabled_ref) and API.MENU.Get(LUA_UI.TEAM.round_ref) == ct then
            client.exec( "jointeam 2 1" )
        end
    elseif API.MENU.Get( LUA_UI.TEAM.chosen_team ) == "Terrorists" then
        if API.MENU.Get(LUA_UI.TEAM.enabled_ref) and API.MENU.Get(LUA_UI.TEAM.round_ref) == t then
            client.exec( "jointeam 3 1" )
        end
    end

end
client.set_event_callback("round_end", getteamwins)

local function getleaderkills(e)

local leader = API.STEAMAPI.getsteam64fromleader
local leaderkills = csdev.valve.gameapi.GetPlayerKills(leader)
local ragebot = API.MENU.Reference("Rage", "Aimbot", "Enabled")
local customkills = API.MENU.Get(LUA_UI.MISC.sliderkills)

local ent = entity.get_local_player()
local enemySteamID = entity.get_steam64(ent)

if enemySteamID == nil then return end

local function steam_64(enemy_steam_id)
    local y, z = 0, 0

    if ((enemySteamID % 2) == 0) then
        y = 0
        z = (enemySteamID / 2)
    else
        y = 1
        z = ((enemySteamID - 1) / 2)
    end
    
    return '7656119' .. ((z * 2) + (7960265728 + y))
end

local enemyID = steam_64(enemySteamID) 
        client.delay_call(1, function()

        if API.MENU.Get(LUA_UI.MISC.limitkills) and leaderkills >= customkills then
            API.MENU.Set(ragebot, false)
        end

        if API.MENU.Get(LUA_UI.MISC.limitkills) and customkills > leaderkills and customkills ~= leaderkills  then
            API.MENU.Set(ragebot, true)
        end

        if API.MENU.Get(LUA_UI.MISC.botsragebot) and leaderkills >= customkills then
            API.MENU.Set(ragebot, true)
        end
        end)
end
client.set_event_callback("round_prestart", getleaderkills)


local function resetscore(e) 
    ct = 0
    t = 0
end
client.set_event_callback("cs_win_panel_match", resetscore)

local function followleader(e)
    local ent = client.userid_to_entindex(e.userid)
    local enemySteamID = entity.get_steam64(ent)

    if enemySteamID == nil then
        return
    end 
    local function steam_64(enemy_steam_id)
        local y = 0
        local z = 0
        if ((enemySteamID % 2) == 0) then
            y = 0
            z = (enemySteamID / 2)
        else
            y = 1
            z = ((enemySteamID - 1) / 2)
        end
        return '7656119' .. ((z * 2) + (7960265728 + y))
    end

    local enemyID = steam_64(enemySteamID)
    if API.MENU.Get(LUA_UI.TEAM.botsforceteam) == true then
        if enemyID == API.STEAMAPI.getsteam64fromleader then
            if e.team == 2 then
                client.exec( "jointeam 2 1" )
            elseif e.team == 3 then
                client.exec( "jointeam 3 1" )
            end
        end
    end
end
client.set_event_callback("player_team", followleader)

---Kick options
local function getallids(e)
    for i=1, 1000 do
        local entindex = client.userid_to_entindex(i)
        if entindex ~= nil then
            userids[entindex] = i
        end
    end
end
client.set_event_callback("run_command", getallids)

local function autokick()

    client.delay_call(1, function() 
        for ent, id in pairs(userids) do
            if id ~= 1000 then
                local lplayer = entity.get_local_player()
                local enemySteamID = entity.get_steam64(ent)
                local name = entity.get_player_name(ent)
            
                if enemySteamID == nil then
                    break
                end
                local function steam_64(enemy_steam_id)
                    local y, z = 0, 0
                
                    if ((enemySteamID % 2) == 0) then
                        y = 0
                        z = (enemySteamID / 2)
                    else
                        y = 1
                        z = ((enemySteamID - 1) / 2)
                    end
                    
                    return '7656119' .. ((z * 2) + (7960265728 + y))
                end

                local enemyID = steam_64(enemySteamID)

                if enemySteamID ~= 0 then
                
                    if not entity.is_enemy(ent) then
                        if API.MENU.Get(LUA_UI.VOTE.enableautokick) == true then
                            if enemyID ~= API.STEAMAPI.getsteam64fromleader then
                                if enemyID ~= API.STEAMAPI.getsteam64frombot1 then
                                    if enemyID ~= API.STEAMAPI.getsteam64frombot2 then
                                        if enemyID ~= API.STEAMAPI.getsteam64frombot3 then
                                            if enemyID ~= API.STEAMAPI.getsteam64frombot4 then
                                                if enemyID ~= API.STEAMAPI.getsteam64frombot5 then
                                                    if enemyID ~= API.STEAMAPI.getsteam64frombot6 then
                                                        if enemyID ~= API.STEAMAPI.getsteam64frombot7 then
                                                            if enemyID ~= API.STEAMAPI.getsteam64frombot8 then
                                                                if enemyID ~= API.STEAMAPI.getsteam64frombot9 then
                                                                    if enemyID ~= API.STEAMAPI.getsteam64frombot10 then
                                                                        if enemyID ~= API.STEAMAPI.getsteam64frombot11 then
                                                                            if enemyID ~= API.STEAMAPI.getsteam64frombot12 then
                                                                                if enemyID ~= API.STEAMAPI.getsteam64frombot13 then
                                                                                    if enemyID ~= API.STEAMAPI.getsteam64frombot14 then
                                                                                        if enemyID ~= API.STEAMAPI.getsteam64frombot15 then
                                                client.exec("callvote kick ".. id)
                                                print("Trying to kick " .. name .. " (" .. enemyID .. ")!")
                                                                             end
                                                                          end
                                                                       end
                                                                    end
                                                                 end
                                                              end
                                                           end
                                                        end
                                                      end
                                                   end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end
client.set_event_callback("round_prestart", autokick)

local function autokickteamswitch(e)

    client.delay_call(1, function() 
            local lplayer = entity.get_local_player()
            local ent = client.userid_to_entindex(e.userid)
            local enemySteamID = entity.get_steam64(ent)
            local name = entity.get_player_name(ent)
        
            if enemySteamID ~= nil then
                local function steam_64(enemy_steam_id)
                    local y, z = 0, 0
                
                    if ((enemySteamID % 2) == 0) then
                        y = 0
                        z = (enemySteamID / 2)
                    else
                        y = 1
                        z = ((enemySteamID - 1) / 2)
                    end
                    
                    return '7656119' .. ((z * 2) + (7960265728 + y))
                end

                local enemyID = steam_64(enemySteamID)

                if enemySteamID ~= 0 then
                    if not entity.is_enemy(ent) then
                        if API.MENU.Get(LUA_UI.VOTE.enableautokick) == true then
                            if enemyID ~= API.STEAMAPI.getsteam64fromleader then
                                if enemyID ~= API.STEAMAPI.getsteam64frombot1 then
                                    if enemyID ~= API.STEAMAPI.getsteam64frombot2 then
                                        if enemyID ~= API.STEAMAPI.getsteam64frombot3 then
                                            if enemyID ~= API.STEAMAPI.getsteam64frombot4 then
                                                if enemyID ~= API.STEAMAPI.getsteam64frombot5 then
                                                    if enemyID ~= API.STEAMAPI.getsteam64frombot6 then
                                                        if enemyID ~= API.STEAMAPI.getsteam64frombot7 then
                                                            if enemyID ~= API.STEAMAPI.getsteam64frombot8 then
                                                                if enemyID ~= API.STEAMAPI.getsteam64frombot9 then
                                                                    if enemyID ~= API.STEAMAPI.getsteam64frombot10 then
                                                                        if enemyID ~= API.STEAMAPI.getsteam64frombot11 then
                                                                            if enemyID ~= API.STEAMAPI.getsteam64frombot12 then
                                                                                if enemyID ~= API.STEAMAPI.getsteam64frombot13 then
                                                                                    if enemyID ~= API.STEAMAPI.getsteam64frombot14 then
                                                                                        if enemyID ~= API.STEAMAPI.getsteam64frombot15 then
                                                client.exec("callvote kick ".. e.userid)
                                                print("Trying to kick " .. name .. " (" .. enemyID .. ")!")
                                                                             end
                                                                          end
                                                                       end
                                                                    end
                                                                 end
                                                              end
                                                           end
                                                        end
                                                     end
                                                  end
                                               end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end    
    end)
end
client.set_event_callback("player_team", autokickteamswitch)


local function autoreportez(e)

    client.delay_call(1, function() 
            local lplayer = entity.get_local_player()
            local ent = client.userid_to_entindex(e.userid)
            local enemySteamID = entity.get_steam64(ent)
            local name = entity.get_player_name(ent)
        


            if enemySteamID ~= nil then
                local function steam_64(enemy_steam_id)
                    local y, z = 0, 0
                
                    if ((enemySteamID % 2) == 0) then
                        y = 0
                        z = (enemySteamID / 2)
                    else
                        y = 1
                        z = ((enemySteamID - 1) / 2)
                    end
                    
                    return '7656119' .. ((z * 2) + (7960265728 + y))
                end

                local ReportTypes = {
                    {'textabuse'},
                    {'voiceabuse'},
                    {'grief'},
                    {'aimbot'},
                    {'wallhack'},
                    {'speedhack'}
                }

                local enemyID = steam_64(enemySteamID)

                if enemySteamID ~= 0 then
                    if not entity.is_enemy(ent) then
                        if has_value(API.MENU.Get(LUA_UI.MISC.steamreport), "Steam Reportbot") then
                            if enemyID ~= API.STEAMAPI.getsteam64fromleader then
                                if enemyID ~= API.STEAMAPI.getsteam64frombot1 then
                                    if enemyID ~= API.STEAMAPI.getsteam64frombot2 then
                                        if enemyID ~= API.STEAMAPI.getsteam64frombot3 then
                                            if enemyID ~= API.STEAMAPI.getsteam64frombot4 then
                                                if enemyID ~= API.STEAMAPI.getsteam64frombot5 then
                                                    if enemyID ~= API.STEAMAPI.getsteam64frombot6 then
                                                        if enemyID ~= API.STEAMAPI.getsteam64frombot7 then
                                                            if enemyID ~= API.STEAMAPI.getsteam64frombot8 then
                                                                if enemyID ~= API.STEAMAPI.getsteam64frombot9 then
                                                                    if enemyID ~= API.STEAMAPI.getsteam64frombot10 then
                                                                        if enemyID ~= API.STEAMAPI.getsteam64frombot11 then
                                                                            if enemyID ~= API.STEAMAPI.getsteam64frombot12 then
                                                                                if enemyID ~= API.STEAMAPI.getsteam64frombot13 then
                                                                                    if enemyID ~= API.STEAMAPI.getsteam64frombot14 then
                                                                                        if enemyID ~= API.STEAMAPI.getsteam64frombot15 then
                                                                                local body = {
                                                                                    content = "!r " .. enemyID,
                                                                                    username = "XP LUA"
                                                                                }
                                                                                LIBS.http.post(API.DISCORD.URL, {body = json.stringify(body), headers = { ['Content-Length'] = #json.stringify(body), ['Content-Type'] = 'application/json' }}, function(success, resp) 
                                                                                    if success then
                                                                                        client.color_log(0, 255, 0, "[xp.lua] Successfully Steam Reportbotted " .. name)
                                                                                    else
                                                                                        client.color_log(255, 0, 0, "[xp.lua] Failed to reportbot " .. name)
                                                                                    end
                                                                                end)     
                                                                             end
                                                                          end
                                                                       end
                                                                    end
                                                                 end
                                                              end
                                                           end
                                                        end
                                                     end
                                                  end
                                               end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if has_value(API.MENU.Get(LUA_UI.MISC.steamreport), "CSGO Report") then
                            if enemyID ~= API.STEAMAPI.getsteam64fromleader then
                                if enemyID ~= API.STEAMAPI.getsteam64frombot1 then
                                    if enemyID ~= API.STEAMAPI.getsteam64frombot2 then
                                        if enemyID ~= API.STEAMAPI.getsteam64frombot3 then
                                            if enemyID ~= API.STEAMAPI.getsteam64frombot4 then
                                                if enemyID ~= API.STEAMAPI.getsteam64frombot5 then
                                                    if enemyID ~= API.STEAMAPI.getsteam64frombot6 then
                                                        if enemyID ~= API.STEAMAPI.getsteam64frombot7 then
                                                            if enemyID ~= API.STEAMAPI.getsteam64frombot8 then
                                                                if enemyID ~= API.STEAMAPI.getsteam64frombot9 then
                                                                    if enemyID ~= API.STEAMAPI.getsteam64frombot10 then
                                                                        if enemyID ~= API.STEAMAPI.getsteam64frombot11 then
                                                                            if enemyID ~= API.STEAMAPI.getsteam64frombot12 then
                                                                                if enemyID ~= API.STEAMAPI.getsteam64frombot13 then
                                                                                    if enemyID ~= API.STEAMAPI.getsteam64frombot14 then
                                                                                        if enemyID ~= API.STEAMAPI.getsteam64frombot15 then
                                                                                print("Succesfully CSGO reported " .. name .. " (" .. enemyID .. ")!")
                                                                                csdev.valve.gameapi.SubmitPlayerReport(enemyID, ReportTypes)     
                                                                             end
                                                                          end
                                                                       end
                                                                    end
                                                                 end
                                                              end
                                                           end
                                                        end
                                                     end
                                                  end
                                               end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end    
    end)
end
client.set_event_callback("player_team", autoreportez)

local function autovote(e)
  local eid = e.entityid
  local voted = e.vote_option
  local name = entity.get_player_name(eid)
  local enemySteamID = entity.get_steam64(eid)  

  if enemySteamID == nil then
    return
  end 
  local function steam_64(enemy_steam_id)
    local y, z = 0, 0
    if ((enemySteamID % 2) == 0) then
        y = 0
        z = (enemySteamID / 2)
    else
        y = 1
        z = ((enemySteamID - 1) / 2)
    end
    return '7656119' .. ((z * 2) + (7960265728 + y))
  end

  local enemyID = steam_64(enemySteamID)

  if API.MENU.Get(LUA_UI.VOTE.enableautokickvote) == true then
            if enemyID == API.STEAMAPI.getsteam64fromleader then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end

            if enemyID == API.STEAMAPI.getsteam64frombot1 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end

            if enemyID == API.STEAMAPI.getsteam64frombot2 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end

            if enemyID == API.STEAMAPI.getsteam64frombot3 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end

            if enemyID == API.STEAMAPI.getsteam64frombot4 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end

            if enemyID == API.STEAMAPI.getsteam64frombot5 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end

            if enemyID == API.STEAMAPI.getsteam64frombot6 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end

            if enemyID == API.STEAMAPI.getsteam64frombot7 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end

            if enemyID == API.STEAMAPI.getsteam64frombot8 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end
            if enemyID == API.STEAMAPI.getsteam64frombot9 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end
            if enemyID == API.STEAMAPI.getsteam64frombot10 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end
            if enemyID == API.STEAMAPI.getsteam64frombot11 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end
            if enemyID == API.STEAMAPI.getsteam64frombot12 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end
            if enemyID == API.STEAMAPI.getsteam64frombot13 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end
            if enemyID == API.STEAMAPI.getsteam64frombot14 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end
            if enemyID == API.STEAMAPI.getsteam64frombot15 then
                if voted == 0 then
                    client.exec("vote option1")
                else
                    client.exec("vote option2")
                end
            end            

    end
end
client.set_event_callback("vote_cast", autovote)

---Webhook options
API.MENU.Label("LUA", "B", " ")
local hours, minutes, seconds, milliseconds = client.system_time()
API.MENU.Label("LUA", "B", " ")
API.MENU.Label("LUA", "B", "\afcebbf  The time since the LUA is loaded:   " .. hours .. ":" .. minutes)

local pregameXP = csdev.valve.mypersona.GetCurrentXp()
local currentTotalXP = csdev.valve.mypersona.GetCurrentXp()
local gainedXP = 0
local matches = 0
local averageXP = 0
local remainingXP = 0
local totalGamesRemainingCalc = 0
local totalGainedXP = 0


client.set_event_callback( "cs_win_panel_match", function()
    local prelevel = csdev.valve.mypersona.GetCurrentLevel()
    pregameXP = prelevel*5000 + csdev.valve.mypersona.GetCurrentXp()
end)

client.set_event_callback( "cs_win_panel_match", function()
    client.delay_call(5, function() 
        local level = csdev.valve.mypersona.GetCurrentLevel()
        currentTotalXP = level*5000 + csdev.valve.mypersona.GetCurrentXp()
    end)
end)

local hstart, mstart, sstart, millstart = 0, 0, 0, 0

client.set_event_callback( "cs_win_panel_match", function( event_data )
    client.delay_call(15, function() 
        hstart, mstart, sstart, millstart = client.system_time()
    end)
end )


local function webhook()
    if API.MENU.Get(LUA_UI.EXTRA.usewebhooks) == true then
        local name = csdev.valve.mypersona.GetName()
        if API.MENU.Get(LUA_UI.EXTRA.discord_smekerie) == "Custom" then
            Webhook = LIBS.discord.new(API.DISCORD.custom_discord)
        else
            Webhook = LIBS.discord.new(API.DISCORD.default_discord)
        end
        local RichEmbed = LIBS.discord.newEmbed()
        local steamID = csdev.valve.mypersona.GetXuid()
        local playerresource = entity.get_all("CCSPlayerResource")[1]
        local killcount = entity.get_prop(playerresource, "m_iKills", entity.get_local_player())
        local xpgainedthismatch = killcount * 1.4
        local h, m, s, mill = client.system_time()

        if API.MENU.Get(LUA_UI.EXTRA.webhookcolors) == "Green" then
            RichEmbed:setColor(3066993)
        elseif API.MENU.Get(LUA_UI.EXTRA.webhookcolors) == "Blue" then
            RichEmbed:setColor(3447003)
        elseif API.MENU.Get(LUA_UI.EXTRA.webhookcolors) == "Purple" then
            RichEmbed:setColor(10181046)    
        elseif API.MENU.Get(LUA_UI.EXTRA.webhookcolors) == "Pink" then
            RichEmbed:setColor(15277667)
        elseif API.MENU.Get(LUA_UI.EXTRA.webhookcolors) == "Yellow" then
            RichEmbed:setColor(16776960)
        elseif API.MENU.Get(LUA_UI.EXTRA.webhookcolors) == "Orange" then
            RichEmbed:setColor(15105570)
        elseif API.MENU.Get(LUA_UI.EXTRA.webhookcolors) == "Navy" then
            RichEmbed:setColor(3426654)
        elseif API.MENU.Get(LUA_UI.EXTRA.webhookcolors) == "Gold" then
            RichEmbed:setColor(15844367)   
        end

        client.delay_call(6, function() 
        Webhook:setUsername('XP-Tracker')
        Webhook:setAvatarURL('')

        LIBS.http.get("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=CB2030391B374A587707F8E1133E6393&steamids=".. steamID .. "", function(success, response)
            if success or response.status ~= 200 then
            local json = json.parse(response.body)
            RichEmbed:setThumbnail(json.response.players[1].avatarfull)
            end
        end)
        
        RichEmbed:setTitle(name .. " just finished a match on ".. globals.mapname() .. "!")
        matches = matches + 1
        gainedXP = currentTotalXP - pregameXP
        totalGainedXP = totalGainedXP + gainedXP
        averageXP = totalGainedXP / matches
        remainingXP = 200000 - currentTotalXP
        totalGamesRemainingCalc = remainingXP/averageXP
    
        client.delay_call(1, function() 
            RichEmbed:setDescription(":star2: You will get a service medal in " .. string.format("%.0f", totalGamesRemainingCalc*9) .. " min or " .. string.format("%.2f", (totalGamesRemainingCalc*9)/1440) .. " days! :star2:")

            RichEmbed:addField(":star: XP Gained this match", gainedXP, true)
            RichEmbed:addField(":star: Current Rank ","Rank ".. csdev.valve.mypersona.GetCurrentLevel(), true)
            RichEmbed:addField(":star: Current XP ", csdev.valve.mypersona.GetCurrentXp() .. "xp", true)

            RichEmbed:addField(':chart_with_upwards_trend: Games played:', matches, true)
            RichEmbed:addField(":chart_with_downwards_trend: Games Remaining",string.format("%.0f", totalGamesRemainingCalc), true)
            RichEmbed:addField(":bar_chart: Average XP:", string.format("%.0f", averageXP), true)

            RichEmbed:addField(':sparkles: Total gained XP:', totalGainedXP, true)
            RichEmbed:addField(':clock230: Match Started:', string.format("%02d:%02d:%02d", hstart, mstart, sstart) .. "", true)
            RichEmbed:addField(':clock430: Match finished:', string.format("%02d:%02d:%02d", h, m, s) .. "", true)
            RichEmbed:setFooter("discord.gg/xpboost - ©2021-2022", 'https://i.imgur.com/99FJbw6.gif', true);
        
            Webhook:send(RichEmbed)
            end)
        end)
    end
end
client.set_event_callback("cs_win_panel_match", webhook)

local function handlewebhooksmenu()
    if API.MENU.Get(LUA_UI.EXTRA.usewebhooks) == true then
        API.MENU.Visible(LUA_UI.EXTRA.webhookcolors, true)
        API.MENU.Visible(LUA_UI.EXTRA.discord_smekerie, true)
    else
        API.MENU.Visible(LUA_UI.EXTRA.webhookcolors, false)
        API.MENU.Visible(LUA_UI.EXTRA.discord_smekerie, false)
    end
end

client.set_event_callback("paint_ui", handlewebhooksmenu)

local function update()
    if not ui.get(LUA_UI.EXPLOIT.version_spoof) then return end
    LIBS.http.get("https://api.steampowered.com/ISteamApps/UpToDateCheck/v1/?appid=730&version=" .. version, function(success, response)
        if not success or response.status ~= 200 then
            return
        end

        local data = json.parse(response.body)
        if data.response.required_version ~= nil then
            LIBS.ffi.cast("uint32_t**",LIBS.ffi.cast("char*",client.find_signature("engine.dll","\xFF\x35\xcc\xcc\xcc\xcc\x8D\x4C\x24\x10"))+2)[0][0]=data.response.required_version
        end
    end)
end

ui.set_callback(LUA_UI.EXPLOIT.version_spoof, update)
client.set_event_callback("console_input", function(i) if i == "disconnect" then update() end end)
client.set_event_callback('cs_win_panel_match', update)
LIBS.panorama_events.register_event('CSGOShowMainMenu',  update)