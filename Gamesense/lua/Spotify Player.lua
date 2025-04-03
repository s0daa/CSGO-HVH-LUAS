local var_0_0 = require("gamesense/surface") or error("gamesense/surface library is required")
local var_0_1 = require("gamesense/http") or error("gamesense/http library is required")
local var_0_2 = require("gamesense/images") or error("gamesense/images library is required")
local var_0_3 = require("gamesense/inspect")
local var_0_4 = require("ffi")
local var_0_5 = database.read
local var_0_6 = database.write
local var_0_7 = package.searchpath
local var_0_8 = ui.set_callback
local var_0_9 = ui.set_visible
local var_0_10 = ui.get
local var_0_11 = ui.set
local var_0_12 = ui.new_label
local var_0_13 = ui.new_button
local var_0_14 = ui.new_checkbox
local var_0_15 = ui.new_combobox
local var_0_16 = ui.new_slider
local var_0_17 = ui.new_color_picker
local var_0_18 = ui.new_hotkey
local var_0_19 = ui.new_multiselect
local var_0_20 = ui.menu_position
local var_0_21 = entity.get_local_player
local var_0_22 = entity.get_prop
local var_0_23 = client.unix_time()
local var_0_24 = client.unix_time()
local var_0_25 = client.unix_time()
local var_0_26 = globals.tickcount()
local var_0_27 = globals.tickcount()
local var_0_28 = globals.tickcount()
local var_0_29 = client.unix_time()
local var_0_30 = globals.tickcount()
local var_0_31, var_0_32 = client.screen_size()

MenuScaleX = 4.8
MenuScaleY = 10.8
ScaleTitle = 41.54
ScaleArtist = 63.53
ScaleDuration = 57

local var_0_33 = var_0_0.create_font("GothamBookItalic", var_0_32 / ScaleTitle, 900, 16)
local var_0_34 = var_0_0.create_font("GothamBookItalic", var_0_32 / ScaleArtist, 600, 16)
local var_0_35 = var_0_0.create_font("GothamBookItalic", 25, 900, 16)
local var_0_36 = var_0_0.create_font("GothamBookItalic", 20, 600, 16)
local var_0_37 = var_0_0.create_font("GothamBookItalic", var_0_32 / ScaleDuration, 600, 16)
local var_0_38 = var_0_0.create_font("GothamBookItalic", 12, 900, 16)
local var_0_39 = var_0_0.create_font("GothamBookItalic", 18, 600, 16)
local var_0_40 = var_0_0.create_font("GothamBookItalic", 18, 500, 16)
local var_0_41 = var_0_0.create_font("GothamBookItalic", 30, 500, 16)
local var_0_42 = var_0_0.create_font("GothamBookItalic", 23, 500, 16)
local var_0_43 = var_0_0.create_font("GothamBookItalic", 17, 500, 16)
local var_0_44 = var_0_0.create_font("GothamBookItalic", 19, 800, 16)
local var_0_45 = var_0_0.create_font("GothamBookItalic", 12, 500, 16)
local var_0_46 = var_0_0.create_font("GothamBookItalic", 24, 500, 16)
local var_0_47 = var_0_0.create_font("GothamBookItalic", var_0_32 / ScaleTitle, 900, 16)
local var_0_48 = ui.new_checkbox("MISC", "Miscellaneous", "Spotify")
local var_0_49 = ui.reference("MISC", "Settings", "Menu key")
local var_0_50 = var_0_5("previous_posX") or 0
local var_0_51 = var_0_5("previous_posY") or 1020

if not var_0_5("previous_size") then
	local var_0_52 = 30
end

local var_0_53 = var_0_5("StoredKey") or nil
local var_0_54 = var_0_5("StoredKey2") or nil

var_0_4.cdef("\ttypedef bool (__thiscall *IsButtonDown_t)(void*, int);\n\ttypedef int (__thiscall *GetAnalogValue_t)(void*, int);\n\ttypedef int (__thiscall *GetAnalogDelta_t)(void*, int);\n\ttypedef void***(__thiscall* FindHudElement_t)(void*, const char*);\n\ttypedef void(__cdecl* ChatPrintf_t)(void*, int, int, const char*, ...);\n")

local var_0_55 = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
local var_0_56 = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")
local var_0_57 = var_0_4.typeof("char[?]")
local var_0_58 = var_0_4.typeof("void***")
local var_0_59 = client.create_interface("inputsystem.dll", "InputSystemVersion001")
local var_0_60 = var_0_4.cast(var_0_58, var_0_59)
local var_0_61 = var_0_60[0]
local var_0_62 = var_0_61[15]
local var_0_63 = var_0_61[18]
local var_0_64 = var_0_61[19]
local var_0_65 = var_0_4.cast("IsButtonDown_t", var_0_62)
local var_0_66 = var_0_4.cast("GetAnalogValue_t", var_0_63)
local var_0_67 = var_0_4.cast("GetAnalogDelta_t", var_0_64)
local var_0_68 = "\xB9\xCC\xCC\xCC̈F\t"
local var_0_69 = "U\x8B\xECS\x8B]\bVW\x8B\xF93\xF69w("
local var_0_70 = client.find_signature("client_panorama.dll", var_0_68) or error("sig1 not found")
local var_0_71 = var_0_4.cast("void**", var_0_4.cast("char*", var_0_70) + 1)[0] or error("hud is nil")
local var_0_72 = client.find_signature("client_panorama.dll", var_0_69) or error("FindHudElement not found")
local var_0_73 = var_0_4.cast("FindHudElement_t", var_0_72)(var_0_71, "CHudChat") or error("CHudChat not found")
local var_0_74 = var_0_73[0] or error("CHudChat instance vtable is nil")
local var_0_75 = var_0_4.cast("ChatPrintf_t", var_0_74[27])

local function var_0_76(arg_1_0)
	var_0_75(var_0_73, 0, 0, arg_1_0)
end

local var_0_77 = {}

retardedJpg = false
dragging = false
Authed = false
CornerReady = false
ControlCheck = false
AuthClicked = false
SongChanged = false
VolumeMax = false
VolumeMin = false
VolumeCheck = false
FirstPress = false
RunOnceCheck = false
StopSpamming = false
SetCheck = true
forkinCock = true
bool = true
gropeTits = true
animCheck = false
ShuffleState = false
UpdateWaitCheck = false
kanker = false
MenuBarExtended = false
SearchSelected = false
PlaylistSelected = false
PlaylistLimitReached = false
scrollmin = true
scrollmax = false
SongTooLong = false
SpotifyScaleX = var_0_31 / 4.8
SpotifyScaleY = var_0_32 / 10.8
SpotifyIndicX2 = 1
adaptivesize = 400
ArtScaleX, ArtScaleY = SpotifyScaleY, SpotifyScaleY
UpdateCount = 0
ClickSpree = 0
ClickSpreeTime = 1
TotalErrors = 0
ErrorSpree = 0
NewApiKeyRequest = 0
AlteredVolume = 0
NewVolume = 0
AnimSizePerc = 100
ProgressBarCache = 0
PlayListCount = 0
TrackCount = 0
scrollvalue = 0
last_analogvalue = 0
CurrentSong = "-"
AuthStatus = "> Not connected"
deviceid = ""
UserName = "-"
SongName = "-"
ArtistName = "-"
SongNameHUD = "-"
ArtistNameHUD = "-"
SongProgression = "-"
SongLength = "-"
ProgressDuration = "-"
TotalDuration = "-"
LeftDuration = "-"
SongNameBack = "-"
HoveringOver = "none"
RepeatState = "off"
loadanim = "."
AuthURL = "https://spotify.stbrouwers.cc/"

local var_0_78 = "https://i.imgur.com/wREhluX.png"
local var_0_79 = "https://i.imgur.com/rEEvjzM.png"
local var_0_80 = "https://i.imgur.com/8hjJTCO.png"
local var_0_81 = "https://i.imgur.com/HNVpf4j.png"
local var_0_82 = "https://i.imgur.com/rj2IJfJ.png"

local function var_0_83()
	local var_2_0 = var_0_55()

	if var_2_0 > 0 then
		local var_2_1 = var_0_57(var_2_0)

		var_0_56(0, var_2_1, var_2_0)

		return var_0_4.string(var_2_1, var_2_0 - 1)
	end
end

local function var_0_84(arg_3_0, arg_3_1)
	local var_3_0 = {}

	for iter_3_0 = 1, #arg_3_0, arg_3_1 do
		var_3_0[#var_3_0 + 1] = arg_3_0:sub(iter_3_0, iter_3_0 + arg_3_1 - 1)
	end

	return var_3_0
end

function var_0_77.new()
	return setmetatable({
		initd = false,
		laststate = 0,
		tape = 0,
		events = {}
	}, {
		__index = var_0_77
	})
end

local var_0_85 = var_0_77.new()

function var_0_77.init(arg_5_0)
	if not arg_5_0.init then
		arg_5_0.tape = 0
		arg_5_0.laststate = var_0_67(var_0_60, 3)
		arg_5_0.initd = true
	end

	if var_0_67(var_0_60, 3) == 0 and arg_5_0.tape ~= 0 then
		arg_5_0.tape = 0

		return
	end

	local var_5_0 = var_0_66(var_0_60, 3)

	if var_5_0 > arg_5_0.tape then
		for iter_5_0, iter_5_1 in ipairs(arg_5_0.events) do
			iter_5_1({
				state = "Up",
				pos = var_5_0
			})
		end

		arg_5_0.tape = var_5_0
	elseif var_5_0 < arg_5_0.tape then
		for iter_5_2, iter_5_3 in ipairs(arg_5_0.events) do
			iter_5_3({
				state = "Down",
				pos = var_5_0
			})
		end

		arg_5_0.tape = var_5_0
	end

	if var_0_66(var_0_60, 3) >= last_analogvalue + 1 and not scrollmin then
		scrollvalue = scrollvalue + 1
	elseif var_0_66(var_0_60, 3) <= last_analogvalue - 1 and not scrollmax then
		scrollvalue = scrollvalue - 1
	end

	last_analogvalue = var_0_66(var_0_60, 3)
end

var_0_1.get(var_0_78, function(arg_6_0, arg_6_1)
	if not arg_6_0 or arg_6_1.status ~= 200 then
		return
	end

	Loop = var_0_2.load_png(arg_6_1.body)
end)
var_0_1.get(var_0_79, function(arg_7_0, arg_7_1)
	if not arg_7_0 or arg_7_1.status ~= 200 then
		return
	end

	LoopA = var_0_2.load_png(arg_7_1.body)
end)
var_0_1.get(var_0_80, function(arg_8_0, arg_8_1)
	if not arg_8_0 or arg_8_1.status ~= 200 then
		return
	end

	Shuffle = var_0_2.load_png(arg_8_1.body)
end)
var_0_1.get(var_0_81, function(arg_9_0, arg_9_1)
	if not arg_9_0 or arg_9_1.status ~= 200 then
		return
	end

	ShuffleA = var_0_2.load_png(arg_9_1.body)
end)
var_0_1.get(var_0_82, function(arg_10_0, arg_10_1)
	if not arg_10_0 or arg_10_1.status ~= 200 then
		return
	end

	VolumeSpeaker = var_0_2.load_png(arg_10_1.body)
end)

currplaylist = {}

if var_0_5("previous_posX") == nil then
	var_0_6("previous_posX", var_0_50)
	var_0_6("previous_posY", var_0_51)
elseif var_0_5("previous_posX") >= var_0_31 + 3 then
	var_0_50 = 0
	var_0_51 = 1020
end

Playlistcache = var_0_5("playlistcache")

if var_0_5("savedplaylists") == nil then
	Playlists = {}
	Playlistcache = ""
else
	Playlists = var_0_5("savedplaylists")

	for iter_0_0, iter_0_1 in ipairs(Playlists) do
		PlayListCount = PlayListCount + 1
	end
end

function switch(arg_11_0)
	return function(arg_12_0)
		if type(arg_12_0[arg_11_0]) == "function" then
			return arg_12_0[arg_11_0]()
		elseif type(arg_12_0.default == "function") then
			return arg_12_0.default()
		end
	end
end

local function var_0_86(arg_13_0)
	local var_13_0 = math.floor(arg_13_0 / 1000)
	local var_13_1 = math.floor(var_13_0 / 3600)
	local var_13_2 = var_13_0 - var_13_1 * 3600
	local var_13_3 = math.floor(var_13_2 / 60)
	local var_13_4 = "00" .. var_13_2 - var_13_3 * 60
	local var_13_5 = var_13_4:sub(#var_13_4 - 1)

	if var_13_1 > 0 then
		local var_13_6 = "" .. var_13_3
		local var_13_7 = ("00" .. var_13_6):sub(#var_13_6 + 1)

		return var_13_1 .. ":" .. var_13_7 .. ":" .. var_13_5
	else
		return var_13_3 .. ":" .. var_13_5
	end
end

function round(arg_14_0)
	return arg_14_0 % 1 >= 0.5 and math.ceil(arg_14_0) or math.floor(arg_14_0)
end

local function var_0_87()
	if AuthClicked == false then
		return
	end

	panorama.loadstring("\t\treturn {\n\t\t  open_url: function(url){\n\t\t\tSteamOverlayAPI.OpenURL(url)\n\t\t  }\n\t\t}\n\t\t")().open_url(AuthURL)
end

function GetApiToken()
	if NewApiKeyRequest <= 5 then
		if PendingRequest then
			return
		end

		PendingRequest = true

		if AuthClicked == true then
			AuthStatus = "TRYING"
		end

		var_0_1.get("https://spotify.stbrouwers.cc/refresh_token?refresh_token=" .. var_0_54, function(arg_17_0, arg_17_1)
			if arg_17_1.status ~= 200 then
				AuthStatus = "WRONGKEY"
				PendingRequest = false

				var_0_87()

				NewApiKeyRequest = NewApiKeyRequest + 1

				return
			else
				PendingRequest = false
				NewApiKeyRequest = 0
				parsed = json.parse(arg_17_1.body)
				var_0_53 = parsed.access_token

				Auth()
			end
		end)
	else
		return
	end
end

function Auth()
	if AuthClicked == true then
		var_0_54 = var_0_83()
	end

	if var_0_54 == nil then
		var_0_87()

		return
	end

	if var_0_54 ~= nil and var_0_53 == nil then
		GetApiToken()

		return
	end

	if var_0_54 ~= nil and var_0_53 ~= nil then
		var_0_1.get("https://api.spotify.com/v1/me?&access_token=" .. var_0_53, function(arg_19_0, arg_19_1)
			ConnectionStatus = arg_19_1.status

			if not arg_19_0 or arg_19_1.status ~= 200 then
				ConnectionStatus = arg_19_1.status
				Authed = false
				AuthStatus = "FAILED"

				GetApiToken()
				ShowMenuElements()
				UpdateElements()

				return
			end

			UpdateCount = UpdateCount + 1
			spotidata = json.parse(arg_19_1.body)
			UserName = spotidata.display_name
			Authed = true
			AuthStatus = "SUCCESS"

			ShowMenuElements()
			UpdateElements()
		end)
	end
end

Auth()

function DAuth()
	if not ConnectionStatus then
		return
	end

	if ConnectionStatus == 202 then
		AuthStatus = "SUCCESS"
	end

	if ConnectionStatus == 403 then
		AuthStatus = "FORBIDDEN"
		ErrorSpree = ErrorSpree + 1
		TotalErrors = TotalErrors + 1
	end

	if ConnectionStatus == 429 then
		AuthStatus = "RATE"
		ErrorSpree = ErrorSpree + 1
		TotalErrors = TotalErrors + 1
	end

	if ConnectionStatus == 503 then
		AuthStatus = "APIFAIL"
		ErrorSpree = ErrorSpree + 1
		TotalErrors = TotalErrors + 1
	end

	ShowMenuElements()
	UpdateElements()
end

function UpdateInf()
	SongNameBack = SongName

	if UpdateWaitCheck == false then
		DAuth()
		var_0_1.get("https://api.spotify.com/v1/me/player?access_token=" .. var_0_53, function(arg_22_0, arg_22_1)
			if not arg_22_0 or arg_22_1.status ~= 200 then
				AuthStatus = "TOKEN"
				ErrorSpree = ErrorSpree + 1
				TotalErrors = TotalErrors + 1
				UpdateWaitCheck = true

				return
			end

			CurrentDataSpotify = json.parse(arg_22_1.body)

			if CurrentDataSpotify == nil then
				return
			end

			deviceid = CurrentDataSpotify.device.id

			if RunOnceCheck == false then
				NewVolume = CurrentDataSpotify.device.volume_percent
				RunOnceCheck = true
			end

			if CurrentDataSpotify.is_playing and CurrentDataSpotify.currently_playing_type == "episode" then
				SongName = "Podcast"
				ArtistName = ""
				PlayState = "Playing"
			elseif CurrentDataSpotify.is_playing then
				SongName = CurrentDataSpotify.item.name
				SongNameHUD = CurrentDataSpotify.item.name
				ArtistName = CurrentDataSpotify.item.artists[1].name
				ArtistNameHUD = CurrentDataSpotify.item.artists[1].name
				Currenturi = CurrentDataSpotify.item.uri
				PlayState = "Playing"
			else
				SongName = "Music paused"
				PlayState = "Paused"
				ArtistName = ""
			end

			SongLength = CurrentDataSpotify.item.duration_ms / 1000
			SongProgression = CurrentDataSpotify.progress_ms / 1000
			ShuffleState = CurrentDataSpotify.shuffle_state
			RepeatState = CurrentDataSpotify.repeat_state
			ProgressBarCache = CurrentDataSpotify.progress_ms
			VolumeBarCache = CurrentDataSpotify.device.volume_percent
			TotalDuration = var_0_86(CurrentDataSpotify.item.duration_ms)
			ProgressDuration = var_0_86(CurrentDataSpotify.progress_ms)
			LeftDuration = var_0_86(CurrentDataSpotify.item.duration_ms - CurrentDataSpotify.progress_ms)

			if not CurrentDataSpotify.item.is_local then
				ThumbnailUrl = CurrentDataSpotify.item.album.images[1].url

				var_0_1.get(ThumbnailUrl, function(arg_23_0, arg_23_1)
					if not arg_23_0 or arg_23_1.status ~= 200 then
						return
					end

					Thumbnail = var_0_2.load_jpg(arg_23_1.body)
				end)
			end

			if SongNameBack ~= SongName and SongNameBack ~= nil then
				SpotifyIndicX2 = var_0_50 + adaptivesize
				SongChanged = true
			end
		end)
	end

	UpdateWaitCheck = false
end

function PlayPause()
	local var_24_0 = {
		headers = {
			["Content-Type"] = "application/json",
			["Content-length"] = 0,
			Accept = "application/json",
			Authorization = "Bearer " .. var_0_53
		}
	}

	if CurrentDataSpotify.is_playing then
		PlayState = "Paused"

		var_0_1.put("https://api.spotify.com/v1/me/player/pause?device_id=" .. deviceid, var_24_0, function(arg_25_0, arg_25_1)
			UpdateCount = UpdateCount + 1
		end)
	else
		PlayState = "Playing"

		var_0_1.put("https://api.spotify.com/v1/me/player/play?device_id=" .. deviceid, var_24_0, function(arg_26_0, arg_26_1)
			UpdateCount = UpdateCount + 1
			UpdateWaitCheck = true
		end)
	end
end

function NextTrack()
	local var_27_0 = {
		headers = {
			["Content-Type"] = "application/json",
			["Content-length"] = 0,
			Accept = "application/json",
			Authorization = "Bearer " .. var_0_53
		}
	}

	var_0_1.post("https://api.spotify.com/v1/me/player/next?device_id=" .. deviceid, var_27_0, function(arg_28_0, arg_28_1)
		UpdateCount = UpdateCount + 1
	end)
end

function PreviousTrack()
	local var_29_0 = {
		headers = {
			["Content-Type"] = "application/json",
			["Content-length"] = 0,
			Accept = "application/json",
			Authorization = "Bearer " .. var_0_53
		}
	}

	var_0_1.post("https://api.spotify.com/v1/me/player/previous?device_id=" .. deviceid, var_29_0, function(arg_30_0, arg_30_1)
		UpdateCount = UpdateCount + 1
	end)
end

function ShuffleToggle()
	if ShuffleState == true then
		ShuffleState = false
	else
		ShuffleState = true
	end

	local var_31_0 = {
		headers = {
			["Content-Type"] = "application/json",
			["Content-length"] = 0,
			Accept = "application/json",
			Authorization = "Bearer " .. var_0_53
		}
	}

	var_0_1.put("https://api.spotify.com/v1/me/player/shuffle?device_id=" .. deviceid .. "&state=" .. tostring(ShuffleState), var_31_0, function(arg_32_0, arg_32_1)
		UpdateCount = UpdateCount + 1
		UpdateWaitCheck = true
	end)
end

function LoopToggle()
	if RepeatState == "off" then
		RepeatState = "context"
	elseif RepeatState == "context" then
		RepeatState = "track"
	elseif RepeatState == "track" then
		RepeatState = "off"
	end

	local var_33_0 = {
		headers = {
			["Content-Type"] = "application/json",
			["Content-length"] = 0,
			Accept = "application/json",
			Authorization = "Bearer " .. var_0_53
		}
	}

	var_0_1.put("https://api.spotify.com/v1/me/player/repeat?device_id=" .. deviceid .. "&state=" .. RepeatState, var_33_0, function(arg_34_0, arg_34_1)
		UpdateCount = UpdateCount + 1
		UpdateWaitCheck = true
	end)
end

local var_0_88 = {
	Connected = var_0_12("MISC", "Miscellaneous", AuthStatus),
	AuthButton = var_0_13("MISC", "Miscellaneous", "Authorize", function()
		AuthClicked = true

		Auth()
	end),
	IndicType = var_0_15("MISC", "Miscellaneous", "Type", "Spotify", "Minimal"),
	Additions = var_0_19("MISC", "Miscellaneous", "Additions", "Cover art", "Duration", "Vitals", "Fixed width"),
	CustomLayoutType = var_0_15("MISC", "Miscellaneous", "Art location", "Left", "Right"),
	MenuSize = var_0_16("MISC", "Miscellaneous", "Scale", 50, 150, 100, true, "%"),
	WidthLock = var_0_12("MISC", "Miscellaneous", "⭥\t\t\t\t\t\t[LINKED]\t\t\t\t\t\t ⭥"),
	MinimumWidth = var_0_16("MISC", "Miscellaneous", "Minimum box width", 199, 600, 400, true, "px", 1, {
		[199] = "Auto"
	}),
	FixedWidth = var_0_16("MISC", "Miscellaneous", "Box width", 200, 600, 400, true, "px", 1),
	DebugInfo = var_0_14("MISC", "Miscellaneous", "Debug info"),
	NowPlaying = var_0_12("MISC", "Miscellaneous", "Now playing:" .. SongName),
	Artist = var_0_12("MISC", "Miscellaneous", "By:" .. ArtistName),
	SongDuration = var_0_12("MISC", "Miscellaneous", SongProgression .. SongLength),
	VolumeLabel = var_0_12("MISC", "Miscellaneous", "NewVolume: " .. NewVolume),
	UpdateRate = var_0_16("MISC", "Miscellaneous", "Update rate", 0.5, 5, 1, true, "s"),
	RateLimitWarning = var_0_12("MISC", "Miscellaneous", "WARNING: using <1s updaterate might get you ratelimited"),
	SessionUpdates = var_0_12("MISC", "Miscellaneous", "Total updates this session: " .. UpdateCount),
	TotalErrors = var_0_12("MISC", "Miscellaneous", "Errors this session: " .. TotalErrors),
	SpreeErrors = var_0_12("MISC", "Miscellaneous", "Errors this spree: " .. ErrorSpree),
	RecentError = var_0_12("MISC", "Miscellaneous", "Most recent error: " .. "-"),
	MaxErrors = var_0_16("MISC", "Miscellaneous", "Max errors", 1, 20, 5, true, "x"),
	ErrorRate = var_0_16("MISC", "Miscellaneous", "within", 5, 300, 30, true, "s"),
	FirstPressAmount = var_0_16("MISC", "Miscellaneous", "First press amount", 1, 20, 5, true, "%"),
	VolumeTickSpeed = var_0_16("MISC", "Miscellaneous", "Volume tick speed", 1, 64, 2, true, "tc"),
	VolumeTickAmount = var_0_16("MISC", "Miscellaneous", "Volume tick amount", 1, 10, 1, true, "%"),
	SpotifyPosition = var_0_12("MISC", "Miscellaneous", "Position(x - x2(width), y): " .. var_0_50 .. " - " .. SpotifyIndicX2 .. "(" .. adaptivesize .. "), " .. var_0_51 .. "y"),
	AddError = var_0_13("MISC", "Miscellaneous", "Add an error", function()
		AuthStatus = "TOKEN"
		ErrorSpree = ErrorSpree + 1
		TotalErrors = TotalErrors + 1
	end),
	ForceReflowButton = var_0_13("MISC", "Miscellaneous", "Force element reflow", function()
		ForceReflow()
	end),
	MenuBarEnable = var_0_14("MISC", "Miscellaneous", "Menu bar"),
	HideOriginIndic = var_0_14("MISC", "Miscellaneous", "Hide indicator while in menu"),
	CustomColors = var_0_14("MISC", "Miscellaneous", "Custom colors"),
	ProgressGradientSwitch = var_0_14("MISC", "Miscellaneous", "Gradient progress bar"),
	BackgroundGradientSwitch = var_0_14("MISC", "Miscellaneous", "Gradient background"),
	LabelProgressGradient1 = var_0_12("MISC", "Miscellaneous", "  - Progress gradient L"),
	ProgressGradient1 = var_0_17("MISC", "Miscellaneous", "progressbar gradient 1", 0, 255, 0, 255),
	LabelProgressGradient2 = var_0_12("MISC", "Miscellaneous", "  - Progress gradient R"),
	ProgressGradient2 = var_0_17("MISC", "Miscellaneous", "progressbar gradient 2", 0, 255, 0, 255),
	LabelGradientColour = var_0_12("MISC", "Miscellaneous", "  - Progress bar color"),
	GradientColour = ui.new_color_picker("MISC", "Miscellaneous", "progress bar Colourpicker", 0, 255, 0, 255),
	LabelBackgroundColor = var_0_12("MISC", "Miscellaneous", "  - Background color"),
	BackgroundColour = var_0_17("MISC", "Miscellaneous", "Background colourrpicker", 25, 25, 25, 255),
	LabelBackgroundColorGradient1 = var_0_12("MISC", "Miscellaneous", "  - Background gradient L"),
	BackgroundColorGradient1 = var_0_17("MISC", "Miscellaneous", "Background Gradient colourpicker1", 25, 25, 25, 50),
	LabelBackgroundColorGradient2 = var_0_12("MISC", "Miscellaneous", "  - Background gradient R"),
	BackgroundColorGradient2 = var_0_17("MISC", "Miscellaneous", "Background Gradient colourpicker2", 25, 25, 25, 255),
	LabelTextColorPrimary = var_0_12("MISC", "Miscellaneous", "  - Primary text color"),
	TextColorPrimary = var_0_17("MISC", "Miscellaneous", "Primary text clr", 255, 255, 255, 255),
	LabelTextColorSecondary = var_0_12("MISC", "Miscellaneous", "  - Secondary text color"),
	TextColorSecondary = var_0_17("MISC", "Miscellaneous", "Secondary text clr", 159, 159, 159, 255),
	ControlSwitch = var_0_14("MISC", "Miscellaneous", "Controls"),
	SmartControlSwitch = var_0_14("MISC", "Miscellaneous", "Smart controls"),
	SmartVolumeSwitch = var_0_14("MISC", "Miscellaneous", "Smart volume"),
	SmartControls = var_0_18("MISC", "Miscellaneous", "  - Smart Controls", true),
	PlayPause = var_0_18("MISC", "Miscellaneous", "  - Play/Pause", false),
	SkipSong = var_0_18("MISC", "Miscellaneous", "  - Skip song", false),
	PreviousSong = var_0_18("MISC", "Miscellaneous", "  - Previous song", false),
	IncreaseVolume = var_0_18("MISC", "Miscellaneous", "  - Volume up", false),
	DecreaseVolume = var_0_18("MISC", "Miscellaneous", "  - Volume down", false),
	AdaptiveVolume = var_0_16("MISC", "Miscellaneous", "Decrease volume by % on voicechat", 0, 100, "off", true, "%", 1, {
		[0] = "off",
		[100] = "mute"
	}),
	ExtrasBox = var_0_19("MISC", "Miscellaneous", "Extras", "Print song changes in chat", "Now playing clantag", "Higher update rate (experimental)"),
	ResetAuth = var_0_13("MISC", "Miscellaneous", "Reset authorization", function()
		ResetAPI()
	end),
	KankerOp = var_0_13("MISC", "Miscellaneous", "Reset playlists", function()
		var_0_6("savedplaylists", nil)

		Playlists = {}
		PlayListCount = 0
		PlaylistLimitReached = false
		currplaylist = {}
		currplaylisturi = ""
		currplaylistname = ""
		TrackCount = 0
		Playlistcache = ""

		var_0_6("playlistcache", Playlistcache)

		PlaylistSelected = false
	end)
}

function ChangeVolume(arg_40_0)
	if kanker then
		kanker = false

		local var_40_0 = {
			headers = {
				["Content-Type"] = "application/json",
				["Content-length"] = 0,
				Accept = "application/json",
				Authorization = "Bearer " .. var_0_53
			}
		}

		var_0_1.put("https://api.spotify.com/v1/me/player/volume?volume_percent=" .. round(arg_40_0) .. "&device_id=" .. deviceid, var_40_0, function(arg_41_0, arg_41_1)
			UpdateCount = UpdateCount + 1
		end)

		VolumeBarCache = ScrolledVolume
	else
		if stopRequest then
			return
		end

		local var_40_1 = {
			headers = {
				["Content-Type"] = "application/json",
				["Content-length"] = 0,
				Accept = "application/json",
				Authorization = "Bearer " .. var_0_53
			}
		}

		var_0_1.put("https://api.spotify.com/v1/me/player/volume?volume_percent=" .. NewVolume .. "&device_id=" .. deviceid, var_40_1, function(arg_42_0, arg_42_1)
			UpdateCount = UpdateCount + 1
		end)

		stopRequest = true
		StopSpamming = false
		SetCheck = true

		UpdateInf()
	end
end

function Seek(arg_43_0)
	local var_43_0 = {
		headers = {
			["Content-Type"] = "application/json",
			["Content-length"] = 0,
			Accept = "application/json",
			Authorization = "Bearer " .. var_0_53
		}
	}

	var_0_1.put("https://api.spotify.com/v1/me/player/seek?position_ms=" .. round(arg_43_0) .. "&device_id=" .. deviceid, var_43_0, function(arg_44_0, arg_44_1)
		UpdateCount = UpdateCount + 1
	end)

	ProgressBarCache = CurrentDataSpotify.item.duration_ms / 404 * MouseHudPosXprgs
	ProgressDuration = var_0_86(SeekedTime)
	LeftDuration = var_0_86(CurrentDataSpotify.item.duration_ms - SeekedTime)
end

function PlaySong(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0 = json.stringify({
		position_ms = 0,
		context_uri = "spotify:playlist:" .. currplaylisturi,
		offset = {
			position = arg_45_0 - 1
		}
	})
	local var_45_1 = {
		headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json",
			Authorization = "Bearer " .. var_0_53
		},
		body = var_45_0
	}

	var_0_1.put("https://api.spotify.com/v1/me/player/play", var_45_1, function(arg_46_0, arg_46_1)
		UpdateCount = UpdateCount + 1

		if not success or response.status ~= 200 then
			return
		end

		SongNameHUD = arg_45_1
		ArtistNameHUD = arg_45_2
		ThumbnailUrl = arg_46_0

		var_0_1.get(ThumbnailUrl, function(arg_47_0, arg_47_1)
			if not arg_47_0 or arg_47_1.status ~= 200 then
				return
			end

			Thumbnail = var_0_2.load_jpg(arg_47_1.body)
		end)
	end)
end

function QueueSong(arg_48_0)
	local var_48_0 = {
		headers = {
			["Content-Type"] = "application/json",
			["Content-length"] = 0,
			Accept = "application/json",
			Authorization = "Bearer " .. var_0_53
		}
	}

	var_0_1.post("https://api.spotify.com/v1/me/player/queue?uri=" .. arg_48_0 .. "&device_id=" .. deviceid, var_48_0, function(arg_49_0, arg_49_1)
		UpdateCount = UpdateCount + 1
	end)
end

function InitPlaylist(arg_50_0)
	if arg_50_0 == nil then
		client.color_log(255, 0, 0, "Failed to add playlist. Make sure that you have your Playlist link in your clipboard, and that the formatting is correct. (https://open.spotify.com/playlist/6piHLVTmzq8nTix2wIlM8x?si=10c8288bd6fc4f94)")

		return
	end

	if string.find(Playlistcache, arg_50_0) ~= nil then
		client.color_log(255, 0, 0, "You have already added this playlist!")

		return
	end

	UpdateWaitCheck = true

	var_0_1.get("https://api.spotify.com/v1/playlists/" .. arg_50_0 .. "?access_token=" .. var_0_53 .. "&fields=name", function(arg_51_0, arg_51_1)
		if not arg_51_0 or arg_51_1.status ~= 200 then
			client.color_log(255, 0, 0, "Failed to add playlist. Make sure that you have your Playlist link in your clipboard, and that the formatting is correct. (https://open.spotify.com/playlist/6piHLVTmzq8nTix2wIlM8x?si=10c8288bd6fc4f94)")

			return
		end

		PlayListCount = PlayListCount + 1

		local var_51_0 = json.parse(arg_51_1.body)

		table.insert(Playlists, {
			id = PlayListCount,
			PlaylistName = var_51_0.name .. "," .. arg_50_0
		})

		Playlistcache = Playlistcache .. arg_50_0
		UpdateCount = UpdateCount + 1
	end)
end

function LoadPlaylist(arg_52_0)
	local var_52_0, var_52_1 = string.match(arg_52_0, "(.*),(.*)")

	TrackCount = 0
	UpdateWaitCheck = true

	var_0_1.get("https://api.spotify.com/v1/playlists/" .. var_52_1 .. "/tracks?market=US&limit=100&offset=0" .. "&access_token=" .. var_0_53, function(arg_53_0, arg_53_1)
		if not arg_53_0 or arg_53_1.status ~= 200 then
			return
		end

		currplaylist = {}
		currplaylistname = var_52_0
		currplaylisturi = var_52_1

		local var_53_0 = json.parse(arg_53_1.body)

		for iter_53_0, iter_53_1 in ipairs(var_53_0.items) do
			TrackCount = TrackCount + 1

			table.insert(currplaylist, {
				id = TrackCount,
				SongDetails = var_53_0.items[iter_53_0].track.name .. "^" .. var_53_0.items[iter_53_0].track.artists[1].name .. "^" .. var_53_0.items[iter_53_0].track.duration_ms .. "^" .. var_53_0.items[iter_53_0].track.uri .. "^" .. var_53_0.items[iter_53_0].track.album.images[3].url
			})

			PlaylistSelected = true
			UpdateCount = UpdateCount + 1
		end
	end)
end

function AddPlaylist(arg_54_0)
	UpdateWaitCheck = true

	var_0_1.get("https://api.spotify.com/v1/playlists/" .. arg_54_0 .. "/tracks?market=US&limit=100&offset=" .. TrackCount .. "&access_token=" .. var_0_53, function(arg_55_0, arg_55_1)
		if not arg_55_0 or arg_55_1.status ~= 200 then
			return
		end

		local var_55_0 = json.parse(arg_55_1.body)

		for iter_55_0, iter_55_1 in ipairs(var_55_0.items) do
			TrackCount = TrackCount + 1

			table.insert(currplaylist, {
				id = TrackCount,
				SongDetails = var_55_0.items[iter_55_0].track.name .. "^" .. var_55_0.items[iter_55_0].track.artists[1].name .. "^" .. var_55_0.items[iter_55_0].track.duration_ms .. "^" .. var_55_0.items[iter_55_0].track.uri .. "^" .. var_55_0.items[iter_55_0].track.album.images[3].url
			})

			UpdateCount = UpdateCount + 1
		end
	end)
end

function setConnected(arg_56_0)
	var_0_11(var_0_88.Connected, arg_56_0)
end

local var_0_89 = {
	DRegiony = 0,
	DRegionx = 0
}
local var_0_90 = {
	DRegionx = SpotifyScaleX,
	DRegiony = SpotifyScaleY
}

local function var_0_91(arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
	local var_57_0 = {
		ui.mouse_position()
	}

	rawmouseposX = var_57_0[1]
	rawmouseposY = var_57_0[2]
	arg_57_4 = arg_57_4 or false

	if arg_57_4 then
		var_0_0.draw_filled_rect(arg_57_0, arg_57_1, arg_57_2, arg_57_3, 255, 0, 0, 50)
	end

	return arg_57_0 <= rawmouseposX and rawmouseposX <= arg_57_0 + arg_57_2 and arg_57_1 <= rawmouseposY and rawmouseposY <= arg_57_1 + arg_57_3
end

local function var_0_92(arg_58_0, arg_58_1)
	if arg_58_0 == nil then
		return false
	end

	arg_58_0 = var_0_10(arg_58_0)

	for iter_58_0 = 0, #arg_58_0 do
		if arg_58_0[iter_58_0] == arg_58_1 then
			return true
		end
	end

	return false
end

function ShowMenuElements()
	if var_0_10(var_0_48) and Authed then
		var_0_9(var_0_88.Connected, true)
		var_0_9(var_0_88.AuthButton, false)
		var_0_9(var_0_88.NowPlaying, true)
		var_0_9(var_0_88.Artist, true)
		var_0_9(var_0_88.SongDuration, true)
		var_0_9(var_0_88.IndicType, true)
		var_0_9(var_0_88.GradientColour, true)
		var_0_9(var_0_88.LabelGradientColour, true)
		var_0_9(var_0_88.CustomColors, true)
		var_0_9(var_0_88.ControlSwitch, true)
		var_0_9(var_0_88.MenuSize, true)
		var_0_9(var_0_88.ResetAuth, true)
		var_0_9(var_0_88.MenuBarEnable, true)
		var_0_9(var_0_88.ExtrasBox, true)

		if var_0_10(var_0_88.IndicType) == "Spotify" then
			var_0_9(var_0_88.WidthLock, ShiftClick)
			var_0_9(var_0_88.MinimumWidth, not var_0_92(var_0_88.Additions, "Fixed width"))
			var_0_9(var_0_88.CustomLayoutType, var_0_92(var_0_88.Additions, "Cover art"))
			var_0_9(var_0_88.FixedWidth, var_0_92(var_0_88.Additions, "Fixed width"))
			var_0_9(var_0_88.Additions, true)

			if var_0_10(var_0_88.CustomColors) then
				var_0_9(var_0_88.ProgressGradientSwitch, true)
				var_0_9(var_0_88.BackgroundGradientSwitch, true)
				var_0_9(var_0_88.LabelTextColorPrimary, true)
				var_0_9(var_0_88.TextColorPrimary, true)
				var_0_9(var_0_88.LabelTextColorSecondary, true)
				var_0_9(var_0_88.TextColorSecondary, true)
				var_0_9(var_0_88.BackgroundColour, true)
				var_0_9(var_0_88.LabelBackgroundColor, true)

				if var_0_10(var_0_88.ProgressGradientSwitch) then
					var_0_9(var_0_88.LabelProgressGradient1, true)
					var_0_9(var_0_88.ProgressGradient1, true)
					var_0_9(var_0_88.LabelProgressGradient2, true)
					var_0_9(var_0_88.ProgressGradient2, true)
					var_0_9(var_0_88.GradientColour, false)
					var_0_9(var_0_88.LabelGradientColour, false)
				else
					var_0_9(var_0_88.GradientColour, true)
					var_0_9(var_0_88.LabelGradientColour, true)
					var_0_9(var_0_88.LabelProgressGradient1, false)
					var_0_9(var_0_88.ProgressGradient1, false)
					var_0_9(var_0_88.LabelProgressGradient2, false)
					var_0_9(var_0_88.ProgressGradient2, false)
				end

				if var_0_10(var_0_88.BackgroundGradientSwitch) then
					var_0_9(var_0_88.BackgroundColorGradient1, true)
					var_0_9(var_0_88.LabelBackgroundColorGradient1, true)
					var_0_9(var_0_88.BackgroundColorGradient2, true)
					var_0_9(var_0_88.LabelBackgroundColorGradient2, true)
				else
					var_0_9(var_0_88.BackgroundColorGradient1, false)
					var_0_9(var_0_88.LabelBackgroundColorGradient1, false)
					var_0_9(var_0_88.BackgroundColorGradient2, false)
					var_0_9(var_0_88.LabelBackgroundColorGradient2, false)
				end
			else
				var_0_9(var_0_88.ProgressGradientSwitch, false)
				var_0_9(var_0_88.BackgroundGradientSwitch, false)
				var_0_9(var_0_88.BackgroundColour, false)
				var_0_9(var_0_88.LabelBackgroundColor, false)
				var_0_9(var_0_88.LabelTextColorPrimary, false)
				var_0_9(var_0_88.TextColorPrimary, false)
				var_0_9(var_0_88.LabelTextColorSecondary, false)
				var_0_9(var_0_88.TextColorSecondary, false)
				var_0_9(var_0_88.BackgroundColorGradient1, false)
				var_0_9(var_0_88.LabelBackgroundColorGradient1, false)
				var_0_9(var_0_88.BackgroundColorGradient2, false)
				var_0_9(var_0_88.LabelBackgroundColorGradient2, false)
				var_0_9(var_0_88.LabelProgressGradient1, false)
				var_0_9(var_0_88.ProgressGradient1, false)
				var_0_9(var_0_88.LabelProgressGradient2, false)
				var_0_9(var_0_88.ProgressGradient2, false)
				var_0_9(var_0_88.GradientColour, false)
				var_0_9(var_0_88.LabelGradientColour, false)
			end
		elseif var_0_10(var_0_88.IndicType) == "Minimal" then
			var_0_9(var_0_88.MinimumWidth, false)
			var_0_9(var_0_88.ProgressGradientSwitch, false)
			var_0_9(var_0_88.BackgroundGradientSwitch, false)
			var_0_9(var_0_88.BackgroundColour, false)
			var_0_9(var_0_88.LabelBackgroundColor, false)
			var_0_9(var_0_88.LabelTextColorPrimary, false)
			var_0_9(var_0_88.TextColorPrimary, false)
			var_0_9(var_0_88.LabelTextColorSecondary, false)
			var_0_9(var_0_88.TextColorSecondary, false)
			var_0_9(var_0_88.BackgroundColorGradient1, false)
			var_0_9(var_0_88.LabelBackgroundColorGradient1, false)
			var_0_9(var_0_88.BackgroundColorGradient2, false)
			var_0_9(var_0_88.LabelBackgroundColorGradient2, false)
			var_0_9(var_0_88.LabelProgressGradient1, false)
			var_0_9(var_0_88.ProgressGradient1, false)
			var_0_9(var_0_88.LabelProgressGradient2, false)
			var_0_9(var_0_88.ProgressGradient2, false)
			var_0_9(var_0_88.GradientColour, false)
			var_0_9(var_0_88.LabelGradientColour, false)
			var_0_9(var_0_88.MenuSize, false)
			var_0_9(var_0_88.CustomLayoutType, false)
			var_0_9(var_0_88.Additions, false)
			var_0_9(var_0_88.FixedWidth, false)

			if var_0_10(var_0_88.CustomColors) then
				var_0_9(var_0_88.GradientColour, true)
				var_0_9(var_0_88.LabelGradientColour, true)
			else
				var_0_9(var_0_88.GradientColour, false)
				var_0_9(var_0_88.LabelGradientColour, false)
			end
		else
			var_0_9(var_0_88.MinimumWidth, false)
			var_0_9(var_0_88.CustomLayoutType, false)
			var_0_9(var_0_88.ProgressGradientSwitch, false)
			var_0_9(var_0_88.BackgroundColour, false)
			var_0_9(var_0_88.LabelBackgroundColor, false)
			var_0_9(var_0_88.LabelTextColorPrimary, false)
			var_0_9(var_0_88.TextColorPrimary, false)
			var_0_9(var_0_88.LabelTextColorSecondary, false)
			var_0_9(var_0_88.TextColorSecondary, false)
			var_0_9(var_0_88.BackgroundColorGradient1, false)
			var_0_9(var_0_88.LabelBackgroundColorGradient1, false)
			var_0_9(var_0_88.BackgroundColorGradient2, false)
			var_0_9(var_0_88.LabelBackgroundColorGradient2, false)
			var_0_9(var_0_88.LabelProgressGradient1, false)
			var_0_9(var_0_88.ProgressGradient1, false)
			var_0_9(var_0_88.LabelProgressGradient2, false)
			var_0_9(var_0_88.ProgressGradient2, false)
			var_0_9(var_0_88.GradientColour, false)
			var_0_9(var_0_88.LabelGradientColour, false)
		end

		if var_0_10(var_0_88.MenuBarEnable) then
			var_0_9(var_0_88.HideOriginIndic, true)
			var_0_9(var_0_88.KankerOp, true)
		else
			var_0_9(var_0_88.HideOriginIndic, false)
			var_0_9(var_0_88.KankerOp, false)
		end

		if var_0_10(var_0_88.ControlSwitch) then
			var_0_9(var_0_88.SmartControlSwitch, true)
			var_0_9(var_0_88.SmartVolumeSwitch, false)
			var_0_9(var_0_88.IncreaseVolume, true)
			var_0_9(var_0_88.DecreaseVolume, true)

			if var_0_10(var_0_88.SmartControlSwitch) then
				var_0_9(var_0_88.SmartControls, true)
				var_0_9(var_0_88.SkipSong, false)
				var_0_9(var_0_88.PreviousSong, false)
				var_0_9(var_0_88.PlayPause, false)
			else
				var_0_9(var_0_88.SmartControls, false)
				var_0_9(var_0_88.SkipSong, true)
				var_0_9(var_0_88.PreviousSong, true)
				var_0_9(var_0_88.PlayPause, true)
			end

			if var_0_10(var_0_88.SmartVolumeSwitch) then
				var_0_9(var_0_88.AdaptiveVolume, false)
			else
				var_0_9(var_0_88.AdaptiveVolume, false)
			end
		else
			var_0_9(var_0_88.SmartControlSwitch, false)
			var_0_9(var_0_88.SmartVolumeSwitch, false)
			var_0_9(var_0_88.SmartControls, false)
			var_0_9(var_0_88.SkipSong, false)
			var_0_9(var_0_88.PreviousSong, false)
			var_0_9(var_0_88.PlayPause, false)
			var_0_9(var_0_88.IncreaseVolume, false)
			var_0_9(var_0_88.DecreaseVolume, false)
			var_0_9(var_0_88.AdaptiveVolume, false)
		end

		var_0_9(var_0_88.DebugInfo, Authed and UserName == "stbrouwers" or Authed and UserName == "slxyx" or Authed and UserName == "Encoded" or Authed and UserName == "22fzreq5auy5njejk6fzp7nhy")

		if var_0_10(var_0_88.DebugInfo) then
			var_0_9(var_0_88.NowPlaying, true)
			var_0_9(var_0_88.Artist, true)
			var_0_9(var_0_88.SongDuration, true)
			var_0_9(var_0_88.UpdateRate, true)
			var_0_9(var_0_88.RateLimitWarning, var_0_10(var_0_88.UpdateRate) <= 0.9)
			var_0_9(var_0_88.SessionUpdates, true)
			var_0_9(var_0_88.TotalErrors, true)
			var_0_9(var_0_88.SpreeErrors, true)
			var_0_9(var_0_88.RecentError, true)
			var_0_9(var_0_88.ErrorRate, true)
			var_0_9(var_0_88.MaxErrors, true)
			var_0_9(var_0_88.AddError, true)
			var_0_9(var_0_88.SpotifyPosition, true)
			var_0_9(var_0_88.ForceReflowButton, true)
			var_0_9(var_0_88.VolumeTickSpeed, true)
			var_0_9(var_0_88.VolumeTickAmount, true)
			var_0_9(var_0_88.FirstPressAmount, true)
			var_0_9(var_0_88.VolumeLabel, true)
		else
			var_0_9(var_0_88.NowPlaying, false)
			var_0_9(var_0_88.Artist, false)
			var_0_9(var_0_88.SongDuration, false)
			var_0_9(var_0_88.UpdateRate, false)
			var_0_9(var_0_88.RateLimitWarning, false)
			var_0_9(var_0_88.SessionUpdates, false)
			var_0_9(var_0_88.TotalErrors, false)
			var_0_9(var_0_88.SpreeErrors, false)
			var_0_9(var_0_88.RecentError, false)
			var_0_9(var_0_88.ErrorRate, false)
			var_0_9(var_0_88.MaxErrors, false)
			var_0_9(var_0_88.AddError, false)
			var_0_9(var_0_88.SpotifyPosition, false)
			var_0_9(var_0_88.ForceReflowButton, false)
			var_0_9(var_0_88.VolumeTickSpeed, false)
			var_0_9(var_0_88.VolumeTickAmount, false)
			var_0_9(var_0_88.FirstPressAmount, false)
			var_0_9(var_0_88.VolumeLabel, false)
		end
	elseif var_0_10(var_0_48) and not Authed then
		var_0_9(var_0_88.Connected, true)
		var_0_9(var_0_88.AuthButton, true)
		var_0_9(var_0_88.ResetAuth, true)
	elseif not var_0_10(var_0_48) then
		for iter_59_0, iter_59_1 in pairs(var_0_88) do
			for iter_59_2, iter_59_3 in pairs(var_0_88) do
				if iter_59_0 ~= iter_59_2 and iter_59_3 == iter_59_1 then
					var_0_88[iter_59_2] = nil
					var_0_88[iter_59_0] = nil
				end
			end
		end

		for iter_59_4, iter_59_5 in pairs(var_0_88) do
			ui.set_visible(iter_59_5, false)
		end
	end
end

function ForceReflow()
	for iter_60_0, iter_60_1 in pairs(var_0_88) do
		for iter_60_2, iter_60_3 in pairs(var_0_88) do
			if iter_60_0 ~= iter_60_2 and iter_60_3 == iter_60_1 then
				var_0_88[iter_60_2] = nil
				var_0_88[iter_60_0] = nil
			end
		end
	end

	for iter_60_4, iter_60_5 in pairs(var_0_88) do
		ui.set_visible(iter_60_5, false)
	end

	ShowMenuElements()
end

function ResetAPI()
	Authed = false
	ConnectionStatus = "NoConnection"
	var_0_53 = nil
	var_0_54 = nil

	var_0_6("StoredKey", nil)
	var_0_6("StoredKey2", nil)
	ForceReflow()
	client.reload_active_scripts()
end

function MusicControls()
	if ControlCheck == false then
		if not var_0_10(var_0_88.SmartControlSwitch) then
			if var_0_10(var_0_88.PlayPause) then
				PlayPause()
			elseif var_0_10(var_0_88.SkipSong) then
				NextTrack()
			elseif var_0_10(var_0_88.PreviousSong) then
				PreviousTrack()
			end
		elseif var_0_10(var_0_88.SmartControls) then
			ClickSpree = ClickSpree + 1
			ClickSpreeTime = ClickSpreeTime + 0.45
			ControlCheck = true
		end
	end

	if client.unix_time() > var_0_24 + ClickSpreeTime and var_0_10(var_0_88.SmartControlSwitch) then
		if ClickSpree == 0 then
			ClickSpree = 0
		end

		if ClickSpree == 1 then
			ClickSpree = 0

			PlayPause()
		end

		if ClickSpree == 2 then
			ClickSpree = 0

			NextTrack()
		end

		if ClickSpree == 3 then
			ClickSpree = 0

			PreviousTrack()
		end

		if ClickSpree >= 3.1 then
			ClickSpree = 0

			PreviousTrack()
		end

		var_0_24 = client.unix_time()
		ClickSpreeTime = 0.5
	end
end

function gaySexgamer()
	if forkinCock then
		analBuggery = globals.tickcount() % 64
		analGaping = globals.tickcount() % 64
		forkinCock = false
	end

	if globals.tickcount() % 64 == analGaping and bool then
		gropeTits = true
	end

	if gropeTits then
		analBuggery = globals.tickcount() % 64
	end

	if var_0_10(var_0_88.IncreaseVolume) or var_0_10(var_0_88.DecreaseVolume) then
		bool = false
	else
		bool = true
	end

	if not bool then
		molestingInfants = true
		gropeTits = false
		analGaping = globals.tickcount() % 64 - 2
	end
end

function VolumeHandler()
	if var_0_10(var_0_88.IncreaseVolume) or var_0_10(var_0_88.DecreaseVolume) then
		if FirstPress and VolumeCheck == false then
			if var_0_10(var_0_88.IncreaseVolume) and not var_0_10(var_0_88.DecreaseVolume) then
				NewVolume = NewVolume + var_0_10(var_0_88.FirstPressAmount)
			elseif not var_0_10(var_0_88.IncreaseVolume) and var_0_10(var_0_88.DecreaseVolume) then
				NewVolume = NewVolume - var_0_10(var_0_88.FirstPressAmount)
			end
		end

		if NewVolume >= 100 then
			NewVolume = 100
		elseif NewVolume <= 0 then
			NewVolume = 0
		end
	end

	if globals.tickcount() % 64 == analBuggery and not var_0_10(var_0_88.IncreaseVolume) and not var_0_10(var_0_88.DecreaseVolume) and molestingInfants then
		molestingInfants = false
		stopRequest = false
		NiggerSex = false
		groomingNiglets = true

		ChangeVolume()
	end
end

function UpdateElements()
	switch(AuthStatus)({
		SUCCESS = function()
			var_0_11(var_0_88.Connected, "> " .. "Connected to " .. UserName)
		end,
		FAILED = function()
			var_0_11(var_0_88.Connected, "> Please put your API key into your clipboard (Invalid token)")
		end,
		TOKEN = function()
			if var_0_10(var_0_88.Connected) == "> Please put your API key into your clipboard (Invalid token)" then
				return
			end

			var_0_11(var_0_88.RecentError, "Most recent error: " .. "000, REJECTED")
		end,
		FORBIDDEN = function()
			var_0_11(var_0_88.Connected, "> The server has dropped your request. Reason unknown")
			var_0_11(var_0_88.RecentError, "Most recent error: " .. "403, FORBIDDEN")
		end,
		RATE = function()
			var_0_11(var_0_88.Connected, "> You've reached the hourly limit of requests. Contact the lua dev")
			var_0_11(var_0_88.RecentError, "Most recent error: " .. "429, RATELIMIT")
		end,
		APIFAIL = function()
			var_0_11(var_0_88.Connected, "> An issue on Spotify's end has occurred. Check their status page")
			var_0_11(var_0_88.RecentError, "Most recent error: " .. "503, APIFAIL")
		end,
		TRYING = function()
			var_0_11(var_0_88.Connected, "> Trying the refresh key")
		end,
		WRONGKEY = function()
			var_0_11(var_0_88.Connected, "> The supplied refresh key was invalid, please try again.")
			var_0_11(var_0_88.RecentError, "Most recent error: " .. "XXX, WRONGKEY")
		end
	})
	var_0_11(var_0_88.NowPlaying, "Now playing: " .. SongName)
	var_0_11(var_0_88.Artist, "By: " .. ArtistName)
	var_0_11(var_0_88.SongDuration, SongProgression .. "/" .. SongLength)
	ShowMenuElements()
end

local function var_0_93()
	local var_74_0 = {
		ui.mouse_position()
	}

	rawmouseposX = var_74_0[1]
	rawmouseposY = var_74_0[2]

	if dragging and not LClick then
		dragging = false
	end

	if dragging and LClick then
		if var_0_50 <= -0.1 and not var_0_92(var_0_88.Additions, "Cover art") then
			var_0_50 = 0
		elseif var_0_50 + adaptivesize >= var_0_31 + 0.1 and not var_0_92(var_0_88.Additions, "Cover art") then
			var_0_50 = var_0_31 - adaptivesize
		elseif var_0_50 - ArtScaleX <= -0.1 and var_0_92(var_0_88.Additions, "Cover art") and var_0_10(var_0_88.CustomLayoutType) == "Left" and not var_0_10(var_0_88.IndicType) == "Minimal" then
			var_0_50 = ArtScaleX
		elseif var_0_50 + adaptivesize >= var_0_31 + 0.1 and var_0_92(var_0_88.Additions, "Cover art") and var_0_10(var_0_88.CustomLayoutType) == "Left" and not var_0_10(var_0_88.IndicType) == "Minimal" then
			var_0_50 = var_0_31 - adaptivesize
		elseif var_0_50 + adaptivesize + ArtScaleX >= var_0_31 + 0.1 and var_0_92(var_0_88.Additions, "Cover art") and var_0_10(var_0_88.CustomLayoutType) == "Right" and not var_0_10(var_0_88.IndicType) == "Minimal" then
			var_0_50 = var_0_31 - adaptivesize - ArtScaleX
		elseif var_0_50 <= -0.1 and var_0_92(var_0_88.Additions, "Cover art") and var_0_10(var_0_88.CustomLayoutType) == "Right" and not var_0_10(var_0_88.IndicType) == "Minimal" then
			var_0_50 = 0
		else
			var_0_50 = rawmouseposX - xdrag
		end

		if var_0_51 <= -0.1 then
			var_0_51 = 0
		elseif var_0_51 + SpotifyScaleY >= var_0_32 + 0.1 then
			var_0_51 = var_0_32 - SpotifyScaleY
		else
			var_0_51 = rawmouseposY - ydrag
		end
	end

	if var_0_91(var_0_50 - var_0_89.DRegionx, var_0_51 - var_0_89.DRegiony, adaptivesize, SpotifyScaleY, false) and LClick then
		dragging = true
		xdrag = rawmouseposX - var_0_50
		ydrag = rawmouseposY - var_0_51
	end
end

local function var_0_94()
	if not Authed then
		return
	end

	titlex, titley = var_0_0.get_text_size(var_0_33, SongName) + 50
	artistx, artisty = var_0_0.get_text_size(var_0_34, ArtistName) + 50

	if var_0_92(var_0_88.Additions, "Fixed width") then
		adaptivesize = var_0_10(var_0_88.FixedWidth)

		if var_0_10(var_0_88.MenuSize) >= 100 then
			var_0_11(var_0_88.MenuSize, 100)
		end

		if titlex > adaptivesize then
			if var_0_10(var_0_88.MenuSize) > 75 then
				videogaming2021 = var_0_84(SongName, round(adaptivesize / 11))
			else
				videogaming2021 = var_0_84(SongName, round(adaptivesize / 8))
			end

			FixedSongName = tostring(videogaming2021[1])
			SongTooLong = true
		else
			SongTooLong = false
		end
	else
		SongTooLong = false

		if titlex > artistx then
			adaptivesize = titlex
		else
			adaptivesize = artistx
		end

		if var_0_10(var_0_88.MinimumWidth) > 199 and adaptivesize < var_0_10(var_0_88.MinimumWidth) then
			adaptivesize = var_0_10(var_0_88.MinimumWidth)
		end

		if SongChanged and var_0_10(var_0_88.CustomLayoutType) == "Right" and var_0_10(var_0_88.IndicType) == "Spotify" then
			var_0_50 = SpotifyIndicX2 - adaptivesize
			SongChanged = false
		end
	end

	if var_0_10(var_0_88.IndicType) == "Minimal" then
		if var_0_50 <= -0.1 then
			var_0_50 = 0
		elseif var_0_50 >= var_0_31 + 0.1 then
			var_0_50 = var_0_31 - adaptivesize
		end
	end

	if var_0_10(var_0_88.IndicType) == "Spotify" then
		if var_0_50 <= -0.1 and not var_0_92(var_0_88.Additions, "Cover art") then
			var_0_50 = 0
		elseif var_0_50 + adaptivesize >= var_0_31 + 0.1 and not var_0_92(var_0_88.Additions, "Cover art") then
			var_0_50 = var_0_31 - adaptivesize
		elseif var_0_50 - ArtScaleX <= -0.1 and var_0_92(var_0_88.Additions, "Cover art") and var_0_10(var_0_88.CustomLayoutType) == "Left" then
			var_0_50 = ArtScaleX
		elseif var_0_50 + adaptivesize >= var_0_31 + 0.1 and var_0_92(var_0_88.Additions, "Cover art") and var_0_10(var_0_88.CustomLayoutType) == "Left" then
			var_0_50 = var_0_31 - adaptivesize
		elseif var_0_50 + adaptivesize + ArtScaleX >= var_0_31 + 0.1 and var_0_92(var_0_88.Additions, "Cover art") and var_0_10(var_0_88.CustomLayoutType) == "Right" then
			var_0_50 = var_0_31 - adaptivesize - ArtScaleX
		elseif var_0_50 <= -0.1 and var_0_92(var_0_88.Additions, "Cover art") and var_0_10(var_0_88.CustomLayoutType) == "Right" then
			var_0_50 = 0
		end
	end

	if var_0_51 <= -0.01 then
		var_0_51 = 0
	elseif var_0_51 + SpotifyScaleY >= var_0_32 + 0.1 then
		var_0_51 = var_0_32 - SpotifyScaleY
	end

	SpotifyIndicX2 = var_0_50 + adaptivesize
end

local var_0_95 = {
	130,
	130,
	130
}
local var_0_96 = 255
local var_0_97 = 0
local var_0_98 = {
	30,
	150
}

local function var_0_99()
	if var_0_10(var_0_88.MenuBarEnable) and var_0_10(var_0_88.HideOriginIndic) and ui.is_menu_open() then
		return
	end

	ArtScaleX, ArtScaleY = SpotifyScaleY, SpotifyScaleY

	if var_0_10(var_0_88.CustomColors) then
		tr1, tg1, tb1, ta1 = var_0_10(var_0_88.TextColorPrimary)
		tr2, tg2, tb2, ta2 = var_0_10(var_0_88.TextColorSecondary)
	else
		tr1, tg1, tb1, ta1 = 255, 255, 255, 255
		tr2, tg2, tb2, ta2 = 159, 159, 159, 255
	end

	if var_0_92(var_0_88.Additions, "Cover art") then
		switch(var_0_10(var_0_88.CustomLayoutType))({
			Left = function()
				if var_0_92(var_0_88.Additions, "Cover art") and Thumbnail ~= nil and not CurrentDataSpotify.item.is_local then
					local function var_77_0()
						Thumbnail:draw(var_0_50 - ArtScaleX, var_0_51, ArtScaleX, ArtScaleY)
					end

					status, retval = pcall(var_77_0)

					if status == false or CurrentDataSpotify.item.is_local then
						retardedJpg = true
					end
				end

				if SongTooLong then
					var_0_0.draw_text(var_0_50 + 10, var_0_51 + SpotifyScaleY / 100 * 22, tr1, tg1, tb1, ta1, var_0_33, FixedSongName)
				else
					var_0_0.draw_text(var_0_50 + 10, var_0_51 + SpotifyScaleY / 100 * 22, tr1, tg1, tb1, ta1, var_0_33, SongName)
				end

				var_0_0.draw_text(var_0_50 + 10, var_0_51 + SpotifyScaleY / 100 * 52, tr2, tg2, tb2, ta2, var_0_34, ArtistName)

				if var_0_92(var_0_88.Additions, "Duration") then
					var_0_0.draw_text(var_0_50 + adaptivesize - SpotifyScaleY / 100 * 85, var_0_51 + SpotifyScaleY / 100 * 67, tr2, tg2, tb2, ta2, var_0_37, ProgressDuration .. "/" .. TotalDuration)
				end
			end,
			Right = function()
				if var_0_92(var_0_88.Additions, "Cover art") and Thumbnail ~= nil then
					local function var_79_0()
						Thumbnail:draw(var_0_50 + adaptivesize, var_0_51, ArtScaleX, ArtScaleY)
					end

					status, retval = pcall(var_79_0)

					if status == false then
						retardedJpg = true
					end
				end

				if SongTooLong then
					var_0_0.draw_text(var_0_50 + adaptivesize - titlex + 40, var_0_51 + SpotifyScaleY / 100 * 22, tr1, tg1, tb1, ta1, var_0_33, FixedSongName)
				else
					var_0_0.draw_text(var_0_50 + adaptivesize - titlex + 40, var_0_51 + SpotifyScaleY / 100 * 22, tr1, tg1, tb1, ta1, var_0_33, SongName)
				end

				var_0_0.draw_text(var_0_50 + adaptivesize - artistx + 40, var_0_51 + SpotifyScaleY / 100 * 52, tr2, tg2, tb2, ta2, var_0_34, ArtistName)

				if var_0_92(var_0_88.Additions, "Duration") then
					var_0_0.draw_text(var_0_50 + 8, var_0_51 + SpotifyScaleY / 100 * 67, tr2, tg2, tb2, ta2, var_0_37, ProgressDuration .. "/" .. TotalDuration)
				end
			end
		})
	else
		if SongTooLong then
			var_0_0.draw_text(var_0_50 + 10, var_0_51 + SpotifyScaleY / 100 * 22, tr1, tg1, tb1, ta1, var_0_33, FixedSongName)
		else
			var_0_0.draw_text(var_0_50 + 10, var_0_51 + SpotifyScaleY / 100 * 22, tr1, tg1, tb1, ta1, var_0_33, SongName)
		end

		var_0_0.draw_text(var_0_50 + 10, var_0_51 + SpotifyScaleY / 100 * 52, tr2, tg2, tb2, ta2, var_0_34, ArtistName)

		if var_0_92(var_0_88.Additions, "Duration") then
			var_0_0.draw_text(var_0_50 + adaptivesize - SpotifyScaleY / 100 * 85, var_0_51 + SpotifyScaleY / 100 * 67, tr2, tg2, tb2, ta2, var_0_37, ProgressDuration .. "/" .. TotalDuration)
		end
	end
end

local var_0_100 = (function()
	return {
		maximum_count = 7,
		callback_registered = false,
		data = {},
		register_callback = function(arg_82_0)
			if arg_82_0.callback_registered then
				return
			end

			client.set_event_callback("paint_ui", function()
				local var_83_0 = {
					30,
					150
				}
				local var_83_1 = {
					13,
					13,
					13
				}
				local var_83_2 = 5
				local var_83_3 = arg_82_0.data

				for iter_83_0 = #var_83_3, 1, -1 do
					arg_82_0.data[iter_83_0].time = arg_82_0.data[iter_83_0].time - globals.frametime()

					local var_83_4 = 255
					local var_83_5 = 0
					local var_83_6 = var_83_3[iter_83_0]

					if var_83_6.time < 0 then
						table.remove(arg_82_0.data, iter_83_0)
					else
						local var_83_7 = var_83_6.def_time - var_83_6.time
						local var_83_8 = var_83_7 > 1 and 1 or var_83_7

						if var_83_6.time < 0.5 or var_83_8 < 0.5 then
							local var_83_9 = (var_83_8 < 1 and var_83_8 or var_83_6.time) / 0.5

							var_83_4 = var_83_9 * 255

							if var_83_9 < 0.2 then
								var_83_2 = var_83_2 + 15 * (1 - var_83_9 / 0.2)
							end
						end

						local var_83_10 = {
							renderer.measure_text(nil, var_83_6.draw)
						}
						local var_83_11 = {
							var_83_0[1],
							var_83_0[2]
						}

						renderer.circle(var_83_11[1], var_83_11[2], var_83_1[1], var_83_1[2], var_83_1[3], var_83_4, 20, 90, 0.5)
						renderer.circle(var_83_11[1], var_83_11[2] + 100, var_83_1[1], var_83_1[2], var_83_1[3], var_83_4, 19, 270, 0.5)
						renderer.rectangle(var_83_11[1] - 19.3, var_83_11[2], 39, 100, var_83_1[1], var_83_1[2], var_83_1[3], var_83_4)
						renderer.circle(var_83_11[1], var_83_11[2], 130, 130, 130, var_83_4, 19, 270, 0.5)
						renderer.rectangle(var_83_11[1] - 19.3, var_83_11[2], 39, NewVolume, 130, 130, 130, var_83_4)

						var_83_2 = var_83_2 - 50
					end
				end

				arg_82_0.callback_registered = true
			end)
		end,
		paint = function(arg_84_0, arg_84_1, arg_84_2)
			local var_84_0 = tonumber(arg_84_1) + 1

			for iter_84_0 = arg_84_0.maximum_count, 2, -1 do
				arg_84_0.data[iter_84_0] = arg_84_0.data[iter_84_0 - 1]
			end

			arg_84_0.data[1] = {
				time = var_84_0,
				def_time = var_84_0,
				draw = arg_84_2
			}

			arg_84_0:register_callback()
		end
	}
end)()

local function var_0_101()
	if var_0_10(var_0_88.CustomColors) then
		r, var_0_96, b, a = var_0_10(var_0_88.GradientColour)
		br, bg, bb, ba = var_0_10(var_0_88.BackgroundColour)
		gr1, gg1, gb1, ga1 = var_0_10(var_0_88.ProgressGradient1)
		gr2, gg2, gb2, ga2 = var_0_10(var_0_88.ProgressGradient2)
		br1, bg1, bb1, ba1 = var_0_10(var_0_88.BackgroundColorGradient1)
		br2, bg2, bb2, ba2 = var_0_10(var_0_88.BackgroundColorGradient2)
	else
		r, var_0_96, b, a = 0, 255, 0, 255
		br, bg, bb, ba = 25, 25, 25, 255
		gr1, gg1, gb1, ga1 = 0, 255, 0, 255
		gr2, gg2, gb2, ga2 = 0, 255, 0, 255
		br1, bg1, bb1, ba1 = 25, 25, 25, 100
		br2, bg2, bb2, ba2 = 25, 25, 25, 255
	end

	if CurrentDataSpotify == nil then
		return
	end

	if NiggerSex then
		renderer.rectangle(var_0_98[1] - 10, var_0_98[2], 5, 100, 64, 64, 64, 255)
		renderer.rectangle(var_0_98[1] - 10, var_0_98[2] + 100, 5, -NewVolume, 29, 185, 84, 255)
		renderer.circle(var_0_98[1] - 7, var_0_98[2] + 100 - NewVolume, 255, 255, 255, 255, 6, 0, 1)
	end

	switch(var_0_10(var_0_88.IndicType))({
		Spotify = function()
			if var_0_10(var_0_88.MenuBarEnable) and var_0_10(var_0_88.HideOriginIndic) and ui.is_menu_open() then
				return
			end

			SpotifyScaleX = var_0_31 / MenuScaleX
			SpotifyScaleY = var_0_32 / MenuScaleY

			if var_0_10(var_0_88.CustomLayoutType) == "Left" and var_0_92(var_0_88.Additions, "Cover art") then
				var_0_0.draw_filled_rect(var_0_50, var_0_51, adaptivesize, SpotifyScaleY, br, bg, bb, ba)
				var_0_0.draw_filled_rect(var_0_50 - ArtScaleX, var_0_51, SpotifyScaleY, SpotifyScaleY, 18, 18, 18, 255)
				renderer.circle_outline(var_0_50 - ArtScaleX / 2, var_0_51 + SpotifyScaleY / 2, 64, 64, 64, 255, SpotifyScaleY / 10, 0, 1, 3)
				renderer.circle_outline(var_0_50 - ArtScaleX / 2, var_0_51 + SpotifyScaleY / 2, 64, 64, 64, 255, SpotifyScaleY / 100 * 35, 0, 1, 3)
			elseif var_0_10(var_0_88.CustomLayoutType) == "Right" and var_0_92(var_0_88.Additions, "Cover art") then
				var_0_0.draw_filled_rect(var_0_50, var_0_51, adaptivesize, SpotifyScaleY, br, bg, bb, ba)
				var_0_0.draw_filled_rect(var_0_50 + adaptivesize, var_0_51, ArtScaleX, ArtScaleX, 18, 18, 18, 255)
				renderer.circle_outline(var_0_50 + adaptivesize + ArtScaleX / 2, var_0_51 + SpotifyScaleY / 2, 64, 64, 64, 255, SpotifyScaleY / 10, 0, 1, 3)
				renderer.circle_outline(var_0_50 + adaptivesize + ArtScaleX / 2, var_0_51 + SpotifyScaleY / 2, 64, 64, 64, 255, SpotifyScaleY / 100 * 35, 0, 1, 3)
			else
				var_0_0.draw_filled_rect(var_0_50, var_0_51, adaptivesize, SpotifyScaleY, br, bg, bb, ba)
			end

			if var_0_10(var_0_88.BackgroundGradientSwitch) then
				var_0_0.draw_filled_gradient_rect(var_0_50, var_0_51, adaptivesize, SpotifyScaleY / 20 * 19, br1, bg1, bb1, ba1, br2, bg2, bb2, ba2, true)
			end

			if not var_0_10(var_0_88.ProgressGradientSwitch) then
				var_0_0.draw_filled_rect(var_0_50, var_0_51 + SpotifyScaleY / 20 * 19, CurrentDataSpotify.progress_ms / CurrentDataSpotify.item.duration_ms * adaptivesize, SpotifyScaleY / 20 * 1, r, var_0_96, b, a)
			else
				var_0_0.draw_filled_gradient_rect(var_0_50, var_0_51 + SpotifyScaleY / 20 * 19, CurrentDataSpotify.progress_ms / CurrentDataSpotify.item.duration_ms * adaptivesize, SpotifyScaleY / 20 * 1, gr1, gg1, gb1, ga1, gr2, gg2, gb2, ga2, true)
			end
		end,
		Minimal = function()
			local var_87_0 = var_0_10(ui.reference("MISC", "Settings", "DPI Scale"))

			songartist, cbtanalcock = renderer.measure_text("b", "Now Playing: " .. CurrentDataSpotify.item.name .. " by " .. CurrentDataSpotify.item.artists[1].name) + 10

			if var_87_0 == "100%" then
				SpotifyScaleX = 150
				SpotifyScaleY = 15
			elseif var_87_0 == "125%" then
				SpotifyScaleX = 150
				SpotifyScaleY = 17
			elseif var_87_0 == "150%" then
				SpotifyScaleX = 150
				SpotifyScaleY = 20
			elseif var_87_0 == "175%" then
				SpotifyScaleX = 150
				SpotifyScaleY = 22
			elseif var_87_0 == "200%" then
				SpotifyScaleX = 150
				SpotifyScaleY = 25
			end

			textmeasurement = renderer.measure_text("b", "Now Playing: " .. CurrentDataSpotify.item.name .. " by " .. CurrentDataSpotify.item.artists[1].name) + 10

			renderer.gradient(var_0_50, var_0_51, textmeasurement, SpotifyScaleY + 2, 22, 22, 22, 255, 22, 22, 22, 10, true)
			renderer.rectangle(var_0_50, var_0_51, 2, SpotifyScaleY + 2, r, var_0_96, b, a)
			renderer.gradient(var_0_50, var_0_51, CurrentDataSpotify.progress_ms / CurrentDataSpotify.item.duration_ms * textmeasurement, 2, r, var_0_96, b, a, r, var_0_96, b, 0, true)
			renderer.gradient(var_0_50, var_0_51 + SpotifyScaleY, CurrentDataSpotify.progress_ms / CurrentDataSpotify.item.duration_ms * textmeasurement, 2, r, var_0_96, b, a, r, var_0_96, b, 0, true)

			if CurrentDataSpotify.is_playing then
				renderer.text(var_0_50 + 5, var_0_51 + 2, 255, 255, 255, 255, "bd", 0, "Now Playing: " .. CurrentDataSpotify.item.name .. " by " .. CurrentDataSpotify.item.artists[1].name)
			else
				renderer.text(var_0_50 + 5, var_0_51 + 2, 255, 255, 255, 255, "bd", 0, "Paused")
			end
		end
	})
end

function DrawIngame()
	if var_0_10(var_0_88.IndicType) ~= "Spotify" or not Authed then
		return
	end

	if var_0_10(var_0_88.MenuBarEnable) and var_0_10(var_0_88.HideOriginIndic) and ui.is_menu_open() then
		return
	end

	local var_88_0 = var_0_21()

	if var_88_0 == nil then
		return
	end

	if var_0_92(var_0_88.Additions, "Vitals") then
		local var_88_1 = math.min(100, var_0_22(var_88_0, "m_iHealth"))
		local var_88_2 = 255
		local var_88_3 = var_88_1 > 20 and 255 or 20

		if var_0_92(var_0_88.Additions, "Cover art") then
			switch(var_0_10(var_0_88.CustomLayoutType))({
				Left = function()
					var_0_0.draw_filled_rect(var_0_50 + adaptivesize, var_0_51 + SpotifyScaleY - SpotifyScaleY / 100 * var_88_1, 5, SpotifyScaleY / 100 * var_88_1, 255, var_88_3, var_88_3, 255)
					var_0_0.draw_text(var_0_50 + adaptivesize + 10, var_0_51 + SpotifyScaleY - SpotifyScaleY / 100 * var_88_1 - SpotifyScaleY / 6, 255, var_88_3, var_88_3, 255, var_0_33, "+" .. tostring(var_88_1))
				end,
				Right = function()
					var_0_0.draw_filled_rect(var_0_50 - 5, var_0_51 + SpotifyScaleY - SpotifyScaleY / 100 * var_88_1, 5, SpotifyScaleY / 100 * var_88_1, 255, var_88_3, var_88_3, 255)
				end
			})
		else
			var_0_0.draw_filled_rect(var_0_50 + adaptivesize, var_0_51 + SpotifyScaleY - SpotifyScaleY / 100 * var_88_1, 5, SpotifyScaleY / 100 * var_88_1, 255, var_88_3, var_88_3, 255)
			var_0_0.draw_text(var_0_50 + adaptivesize + 10, var_0_51 + SpotifyScaleY - SpotifyScaleY / 100 * var_88_1 - SpotifyScaleY / 6, 255, var_88_3, var_88_3, 255, var_0_33, "+" .. tostring(var_88_1))
		end
	end
end

function ChangeMenuSize()
	MenuScaleChange = 2 - var_0_10(var_0_88.MenuSize) / 100
	MenuScaleX = 4.8 * MenuScaleChange
	MenuScaleY = 10.8 * MenuScaleChange
	ScaleTitle = 41.54 * MenuScaleChange
	ScaleArtist = 63.53 * MenuScaleChange
	ScaleDuration = 54 * MenuScaleChange
	var_0_33 = var_0_0.create_font("GothamBookItalic", var_0_32 / ScaleTitle, 900, 16)
	var_0_34 = var_0_0.create_font("GothamBookItalic", var_0_32 / ScaleArtist, 600, 16)
	var_0_37 = var_0_0.create_font("GothamBookItalic", var_0_32 / ScaleDuration, 600, 16)

	if ShiftClick and not var_0_92(var_0_88.Additions, "Fixed width") then
		var_0_11(var_0_88.MinimumWidth, var_0_10(var_0_88.MenuSize) / 100 * 400)
	elseif ShiftClick then
		var_0_11(var_0_88.FixedWidth, var_0_10(var_0_88.MenuSize) / 100 * 400)
	end
end

function HoveringOverElement()
	if LClick == true and ClickCheck == true then
		return
	end

	if LClick == true then
		ClickCheck = true

		switch(HoveringOver)({
			shuffle = function()
				ShuffleToggle()
			end,
			previous = function()
				PreviousTrack()
			end,
			playpause = function()
				PlayPause()
			end,
			skip = function()
				NextTrack()
			end,
			loop = function()
				LoopToggle()
			end,
			none = function()
				return
			end
		})
	else
		ClickCheck = false
	end
end

function seekHandler()
	MouseHudPosXprgs = rawmouseposX - menuX - menuW / 2 + 202

	if MouseHudPosXprgs >= 404 then
		MouseHudPosXprgs = 404
	elseif MouseHudPosXprgs <= 0 then
		MouseHudPosXprgs = 0
	end

	if UnlockReg then
		UpdateWaitCheck = true

		var_0_0.draw_filled_rect(menuX + menuW / 2 - 200, menuY + menuH + 72, MouseHudPosXprgs, 6, 30, 215, 96, 255)
		renderer.circle(menuX + menuW / 2 - 200, menuY + menuH + 75, 30, 215, 96, 255, 3, 0, 1)
		renderer.circle(MouseHudPosXprgs + menuX + menuW / 2 - 200, menuY + menuH + 75, 255, 255, 255, 255, 7, 0, 1)
		renderer.circle(MouseHudPosXprgs + menuX + menuW / 2 - 200, menuY + menuH + 75, 20, 20, 20, 100, 4, 0, 1)

		SeekedTime = CurrentDataSpotify.item.duration_ms / 404 * MouseHudPosXprgs

		var_0_0.draw_text(menuX + menuW / 2 - 243, menuY + menuH + 69, 159, 159, 159, 255, var_0_38, var_0_86(SeekedTime))
		var_0_0.draw_text(menuX + menuW / 2 + 218, menuY + menuH + 69, 159, 159, 159, 255, var_0_38, "-" .. var_0_86(CurrentDataSpotify.item.duration_ms - SeekedTime))
	end
end

function volumeHandler()
	MouseHudvolX = rawmouseposX * -1 + menuX + menuW - 24

	if MouseHudvolX >= 82 then
		MouseHudvolX = 82
	elseif MouseHudvolX <= 0 then
		MouseHudvolX = 0
	end

	Iwanttodie = (MouseHudvolX - 82) * -1

	if UnlockReg2 then
		UpdateWaitCheck = true

		renderer.circle(menuX + menuW - 105, menuY + menuH + 48, 30, 215, 96, 255, 3, 0, 1)
		renderer.circle(Iwanttodie + menuX + menuW - 105, menuY + menuH + 48, 255, 255, 255, 255, 6, 0, 1)
		var_0_0.draw_filled_rect(menuX + menuW - 106, menuY + menuH + 45, Iwanttodie, 6, 30, 215, 96, 255)
		renderer.circle(Iwanttodie + menuX + menuW - 105, menuY + menuH + 48, 20, 20, 20, 100, 3, 0, 1)
		VolumeSpeaker:draw(menuX + menuW - 140, menuY + menuH + 38, 20, 20, 255, 255, 255, 150)

		ScrolledVolume = 1.2195121951219512 * Iwanttodie
	end
end

function drawHUD()
	if not var_0_10(var_0_88.MenuBarEnable) then
		return
	end

	if CurrentDataSpotify == nil then
		return
	end

	menuX, menuY = ui.menu_position()
	menuW, menuH = ui.menu_size()
	MouseHudPosX = rawmouseposX - menuX - menuW / 2
	MouseHudPosY = rawmouseposY - menuY - menuH
	MouseHudrightPosX = rawmouseposX - menuX - menuW
	MouseHudPosLeftX = rawmouseposX - menuX

	local var_101_0 = {
		PrvY = 28,
		PrvX = -75,
		ShflY = 30,
		ShflX = -140,
		vlmvbrhY = 40,
		vlmvbrhX = -141,
		prgsbrY = 64,
		prgsbrX = -202,
		RptY = 30,
		RptX = 108,
		SkpY = 28,
		SkpX = 51,
		PlpsY = 22,
		PlpsX = -18
	}
	local var_101_1 = {
		PrvY = 47,
		PrvX = -55,
		ShflY = 45,
		ShflX = -112,
		vlmvbrhY = 55,
		vlmvbrhX = -20,
		prgsbrY = 85,
		prgsbrX = 202,
		RptY = 45,
		RptX = 135,
		SkpY = 45,
		SkpX = 72,
		PlpsY = 54,
		PlpsX = 18
	}

	if menuW <= 1500 and menuW >= 1150 then
		var_0_35 = var_0_0.create_font("GothamBookItalic", menuW / 50, 900, 16)
		var_0_36 = var_0_0.create_font("GothamBookItalic", menuW / 75, 600, 16)
	elseif menuW <= 1150 and menuW >= 810 then
		var_0_35 = var_0_0.create_font("GothamBookItalic", menuW / 40, 900, 16)
		var_0_36 = var_0_0.create_font("GothamBookItalic", menuW / 55, 600, 16)
	elseif menuW <= 810 then
		var_0_35 = var_0_0.create_font("GothamBookItalic", menuW / 35, 900, 16)
		var_0_36 = var_0_0.create_font("GothamBookItalic", menuW / 45, 600, 16)
	end

	var_0_0.draw_filled_rect(menuX, menuY + menuH - 3, menuW, 100, 25, 25, 25, 255)

	if not MenuBarExtended then
		var_0_0.draw_text(menuX + 100, menuY + menuH + 20, 255, 255, 255, 255, var_0_35, SongNameHUD)
		var_0_0.draw_text(menuX + 100, menuY + menuH + 50, 159, 159, 159, 255, var_0_36, ArtistNameHUD)
	end

	var_0_0.draw_filled_rect(menuX + menuW / 2 - 150, menuY + menuH - 3, menuW / 2 + 140, 100, 25, 25, 25, 255)
	renderer.circle_outline(menuX + menuW / 2, menuY + menuH + 40, 255, 255, 255, 150, 16, 0, 1, 1)

	if PlayState == "Playing" then
		var_0_0.draw_filled_rect(menuX + menuW / 2 - 5, menuY + menuH + 34, 3, 12, 255, 255, 255, 150)
		var_0_0.draw_filled_rect(menuX + menuW / 2 + 2, menuY + menuH + 34, 3, 12, 255, 255, 255, 150)
	elseif PlayState == "Paused" then
		renderer.triangle(menuX + menuW / 2 - 4, menuY + menuH + 34, menuX + menuW / 2 - 4, menuY + menuH + 46, menuX + menuW / 2 + 7, menuY + menuH + 40, 255, 255, 255, 150)
	end

	renderer.triangle(menuX + menuW / 2 + 68, menuY + menuH + 39, menuX + menuW / 2 + 55, menuY + menuH + 31, menuX + menuW / 2 + 55, menuY + menuH + 47, 255, 255, 255, 150)
	renderer.rectangle(menuX + menuW / 2 + 68, menuY + menuH + 31, 3, 16, 255, 255, 255, 150)
	renderer.triangle(menuX + menuW / 2 - 68, menuY + menuH + 39, menuX + menuW / 2 - 55, menuY + menuH + 31, menuX + menuW / 2 - 55, menuY + menuH + 47, 255, 255, 255, 150)
	renderer.rectangle(menuX + menuW / 2 - 71, menuY + menuH + 31, 3, 16, 255, 255, 255, 150)

	if ShuffleState == false then
		Shuffle:draw(menuX + menuW / 2 - 140, menuY + menuH + 24, 30, 30, 255, 255, 255, 150)
	else
		ShuffleA:draw(menuX + menuW / 2 - 140, menuY + menuH + 24, 30, 30, 255, 255, 255, 150)
		renderer.circle(menuX + menuW / 2 - 126, menuY + menuH + 55, 30, 215, 96, 190, 2, 0, 1)
	end

	if RepeatState == "off" then
		Loop:draw(menuX + menuW / 2 + 110, menuY + menuH + 26, 25, 25, 255, 255, 255, 150)
	elseif RepeatState == "context" then
		LoopA:draw(menuX + menuW / 2 + 110, menuY + menuH + 26, 25, 25, 255, 255, 255, 150)
	elseif RepeatState == "track" then
		LoopA:draw(menuX + menuW / 2 + 110, menuY + menuH + 26, 25, 25, 255, 255, 255, 150)
		renderer.circle(menuX + menuW / 2 + 122, menuY + menuH + 55, 30, 215, 96, 190, 2, 0, 1)
	end

	if not UnlockReg then
		var_0_0.draw_text(menuX + menuW / 2 - 243, menuY + menuH + 69, 159, 159, 159, 255, var_0_38, ProgressDuration)
		var_0_0.draw_text(menuX + menuW / 2 + 218, menuY + menuH + 69, 159, 159, 159, 255, var_0_38, "-" .. LeftDuration)
	end

	renderer.circle(menuX + menuW / 2 - 200, menuY + menuH + 75, 50, 50, 50, 255, 3, 0, 1)
	renderer.circle(menuX + menuW / 2 + 201, menuY + menuH + 75, 50, 50, 50, 255, 3, 0, 1)
	var_0_0.draw_filled_rect(menuX + menuW / 2 - 200, menuY + menuH + 72, 400, 6, 53, 53, 53, 255)
	renderer.circle(menuX + menuW - 105, menuY + menuH + 48, 50, 50, 50, 255, 3, 0, 1)
	renderer.circle(menuX + menuW - 26, menuY + menuH + 48, 50, 50, 50, 255, 3, 0, 1)
	var_0_0.draw_filled_rect(menuX + menuW - 106, menuY + menuH + 45, 80, 6, 53, 53, 53, 255)

	if not LClick then
		if MouseHudPosX >= var_101_0.ShflX and MouseHudPosX <= var_101_1.ShflX and MouseHudPosY >= var_101_0.ShflY and MouseHudPosY <= var_101_1.ShflY then
			if ShuffleState == false then
				Shuffle:draw(menuX + menuW / 2 - 140, menuY + menuH + 24, 30, 30, 255, 255, 255, 255)
			else
				ShuffleA:draw(menuX + menuW / 2 - 140, menuY + menuH + 24, 30, 30, 255, 255, 255, 255)
			end

			HoveringOver = "shuffle"
		elseif MouseHudPosX >= var_101_0.PrvX and MouseHudPosX <= var_101_1.PrvX and MouseHudPosY >= var_101_0.PrvY and MouseHudPosY <= var_101_1.PrvY then
			renderer.triangle(menuX + menuW / 2 - 68, menuY + menuH + 39, menuX + menuW / 2 - 55, menuY + menuH + 31, menuX + menuW / 2 - 55, menuY + menuH + 47, 255, 255, 255, 255)
			renderer.rectangle(menuX + menuW / 2 - 71, menuY + menuH + 31, 3, 16, 255, 255, 255, 255)

			HoveringOver = "previous"
		elseif MouseHudPosX >= var_101_0.PlpsX and MouseHudPosX <= var_101_1.PlpsX and MouseHudPosY >= var_101_0.PlpsY and MouseHudPosY <= var_101_1.PlpsY then
			renderer.circle_outline(menuX + menuW / 2, menuY + menuH + 40, 255, 255, 255, 255, 16, 0, 1, 1)

			if PlayState == "Playing" then
				var_0_0.draw_filled_rect(menuX + menuW / 2 - 5, menuY + menuH + 34, 3, 12, 255, 255, 255, 255)
				var_0_0.draw_filled_rect(menuX + menuW / 2 + 2, menuY + menuH + 34, 3, 12, 255, 255, 255, 255)
			elseif PlayState == "Paused" then
				renderer.triangle(menuX + menuW / 2 - 4, menuY + menuH + 34, menuX + menuW / 2 - 4, menuY + menuH + 46, menuX + menuW / 2 + 7, menuY + menuH + 40, 255, 255, 255, 255)
			end

			HoveringOver = "playpause"
		elseif MouseHudPosX >= var_101_0.SkpX and MouseHudPosX <= var_101_1.SkpX and MouseHudPosY >= var_101_0.SkpY and MouseHudPosY <= var_101_1.SkpY then
			renderer.triangle(menuX + menuW / 2 + 68, menuY + menuH + 39, menuX + menuW / 2 + 55, menuY + menuH + 31, menuX + menuW / 2 + 55, menuY + menuH + 47, 255, 255, 255, 255)
			renderer.rectangle(menuX + menuW / 2 + 68, menuY + menuH + 31, 3, 16, 255, 255, 255, 255)

			HoveringOver = "skip"
		elseif MouseHudPosX >= var_101_0.RptX and MouseHudPosX <= var_101_1.RptX and MouseHudPosY >= var_101_0.RptY and MouseHudPosY <= var_101_1.RptY then
			if RepeatState == "off" then
				Loop:draw(menuX + menuW / 2 + 110, menuY + menuH + 26, 25, 25, 255, 255, 255, 255)
			else
				LoopA:draw(menuX + menuW / 2 + 110, menuY + menuH + 26, 25, 25, 255, 255, 255, 255)
			end

			HoveringOver = "loop"
		else
			HoveringOver = "none"
		end
	end

	HoveringOverElement()

	if MouseHudPosX >= var_101_0.prgsbrX and MouseHudPosX <= var_101_1.prgsbrX and MouseHudPosY >= var_101_0.prgsbrY and MouseHudPosY <= var_101_1.prgsbrY or UnlockReg then
		if LClick then
			UnlockReg = true

			seekHandler()
		else
			if ProgressBarCache >= 0 then
				renderer.circle(menuX + menuW / 2 - 200, menuY + menuH + 75, 30, 215, 96, 255, 3, 0, 1)
			end

			renderer.circle(ProgressBarCache / CurrentDataSpotify.item.duration_ms * 402 + menuX + menuW / 2 - 200, menuY + menuH + 75, 255, 255, 255, 255, 7, 0, 1)
			var_0_0.draw_filled_rect(menuX + menuW / 2 - 200, menuY + menuH + 72, ProgressBarCache / CurrentDataSpotify.item.duration_ms * 402, 6, 30, 215, 96, 255)
		end
	else
		if ProgressBarCache >= 0 then
			renderer.circle(menuX + menuW / 2 - 200, menuY + menuH + 75, 150, 150, 150, 255, 3, 0, 1)
		end

		renderer.circle(ProgressBarCache / CurrentDataSpotify.item.duration_ms * 402 + menuX + menuW / 2 - 200, menuY + menuH + 75, 150, 150, 150, 255, 3, 0, 1)
		var_0_0.draw_filled_rect(menuX + menuW / 2 - 200, menuY + menuH + 72, ProgressBarCache / CurrentDataSpotify.item.duration_ms * 402, 6, 150, 150, 150, 255)
	end

	if MouseHudrightPosX >= var_101_0.vlmvbrhX and MouseHudrightPosX <= var_101_1.vlmvbrhX and MouseHudPosY >= var_101_0.vlmvbrhY and MouseHudPosY <= var_101_1.vlmvbrhY or UnlockReg2 then
		if LClick then
			UnlockReg2 = true

			volumeHandler()
		else
			if VolumeBarCache >= 1 then
				renderer.circle(menuX + menuW - 105, menuY + menuH + 48, 30, 215, 96, 255, 3, 0, 1)
			end

			renderer.circle(menuX + menuW - 105, menuY + menuH + 48, 30, 215, 96, 255, 3, 0, 1)
			renderer.circle(VolumeBarCache / 100 * 80 + menuX + menuW - 105, menuY + menuH + 48, 255, 255, 255, 255, 6, 0, 1)
			var_0_0.draw_filled_rect(menuX + menuW - 106, menuY + menuH + 45, 0.8 * VolumeBarCache, 6, 30, 215, 96, 255)
			VolumeSpeaker:draw(menuX + menuW - 140, menuY + menuH + 38, 20, 20, 255, 255, 255, 255)
		end
	else
		if VolumeBarCache >= 1 then
			renderer.circle(menuX + menuW - 105, menuY + menuH + 48, 150, 150, 150, 255, 3, 0, 1)
		end

		if VolumeBarCache == 100 then
			renderer.circle(VolumeBarCache / 100 * 80 + menuX + menuW - 106, menuY + menuH + 48, 150, 150, 150, 255, 3, 0, 1)
		else
			renderer.circle(VolumeBarCache / 100 * 80 + menuX + menuW - 105, menuY + menuH + 48, 150, 150, 150, 255, 3, 0, 1)
		end

		var_0_0.draw_filled_rect(menuX + menuW - 106, menuY + menuH + 45, 0.8 * VolumeBarCache, 6, 150, 150, 150, 255)
		VolumeSpeaker:draw(menuX + menuW - 140, menuY + menuH + 38, 20, 20, 255, 255, 255, 150)
	end

	if OnGoingAnim then
		MenuBarAnimHandler()
	elseif MenuBarExtended == false then
		function drawmenuImg()
			if Thumbnail ~= nil and not CurrentDataSpotify.item.is_local then
				renderer.rectangle(menuX + 10, menuY + menuH + 10, 75, 75, 10, 10, 10, 255)
				renderer.circle_outline(menuX + 47, menuY + menuH + 47, 64, 64, 64, 255, 30, 0, 1, 3)
				renderer.circle_outline(menuX + 47, menuY + menuH + 47, 64, 64, 64, 255, 10, 0, 1, 3)
				Thumbnail:draw(menuX + 10, menuY + menuH + 10, 75, 75)
			end
		end

		st, rt = pcall(drawmenuImg)

		local var_101_2 = {
			xtbtnX = 15,
			cvrtY = 10,
			cvrtX = 10,
			xtbtnY = 35
		}
		local var_101_3 = {
			xtbtnX = 36,
			cvrtY = 85,
			cvrtX = 85,
			xtbtnY = 58
		}

		if MouseHudPosLeftX >= var_101_2.xtbtnX and MouseHudPosLeftX <= var_101_3.xtbtnX and MouseHudPosY >= var_101_2.xtbtnY and MouseHudPosY <= var_101_3.xtbtnY then
			if LClick then
				julliekankermoeders = true
			elseif julliekankermoeders == true then
				julliekankermoeders = false
				MenuBarExtended = true
				OnGoingAnim = true

				MenuBarAnimHandler()
			end

			renderer.gradient(menuX + 10, menuY + menuH + 10, 75, 75, 0, 0, 0, 100, 0, 0, 0, 0, true)
			renderer.circle(menuX + 26, menuY + menuH + 48, 0, 0, 0, 190, 13, 0, 1)
			renderer.line(menuX + 28, menuY + menuH + 40, menuX + 19, menuY + menuH + 48, 255, 255, 255, 255)
			renderer.line(menuX + 28, menuY + menuH + 57, menuX + 19, menuY + menuH + 48, 255, 255, 255, 255)
		elseif MouseHudPosLeftX >= var_101_2.cvrtX and MouseHudPosLeftX <= var_101_3.cvrtX and MouseHudPosY >= var_101_2.cvrtY and MouseHudPosY <= var_101_3.cvrtY then
			renderer.circle(menuX + 26, menuY + menuH + 48, 0, 0, 0, 170, 12, 0, 1)
			renderer.line(menuX + 28, menuY + menuH + 41, menuX + 20, menuY + menuH + 48, 255, 255, 255, 150)
			renderer.line(menuX + 28, menuY + menuH + 56, menuX + 20, menuY + menuH + 48, 255, 255, 255, 150)
		end
	else
		ExtendedMousePosX = rawmouseposX - menuX + 225
		ExtendedMousePosY = rawmouseposY - menuY

		local var_101_4 = {
			plylstfstY = 69,
			plylstfstX = 15,
			nwplylstX = 21,
			srchbrY = 12,
			srchbrX = 20,
			xtbtnY = -217,
			xtbtnX = 192,
			cvrtY = -225,
			cvrtX = 0,
			nwplylstY = 60 + PlayListCount * 30
		}
		local var_101_5 = {
			plylstfstY = 80,
			plylstfstX = 196,
			nwplylstX = 145,
			srchbrY = 40,
			srchbrX = 200,
			xtbtnY = -195,
			xtbtnX = 215,
			cvrtY = 0,
			cvrtX = 225,
			nwplylstY = 80 + PlayListCount * 30
		}

		function drawbigBalls()
			if Thumbnail ~= nil and not CurrentDataSpotify.item.is_local then
				renderer.rectangle(menuX - 225, menuY + menuH - 225, 225, 225, 10, 10, 10, 255)
				renderer.circle_outline(menuX - 113, menuY + menuH - 113, 64, 64, 64, 255, 100, 0, 1, 5)
				renderer.circle_outline(menuX - 113, menuY + menuH - 113, 64, 64, 64, 255, 20, 0, 1, 5)
				Thumbnail:draw(menuX - 225, menuY + menuH - 225, 225, 225)
			end
		end

		stb, rtb = pcall(drawbigBalls)

		var_0_0.draw_filled_rect(menuX - 225, menuY + menuH - 3, 225, 100, 25, 25, 25, 255)
		var_0_0.draw_text(menuX - 210, menuY + menuH + 23, 255, 255, 255, 255, var_0_35, SongNameHUD)
		var_0_0.draw_text(menuX - 210, menuY + menuH + 53, 159, 159, 159, 255, var_0_36, ArtistNameHUD)

		if ExtendedMousePosX >= var_101_4.xtbtnX and ExtendedMousePosX <= var_101_5.xtbtnX and MouseHudPosY >= var_101_4.xtbtnY and MouseHudPosY <= var_101_5.xtbtnY then
			if LClick then
				julliekankermoeders = true
			elseif julliekankermoeders == true then
				julliekankermoeders = false
				MenuBarExtended = false
				OnGoingAnim = true

				MenuBarAnimHandler()
			end

			renderer.gradient(menuX - 225, menuY + menuH - 225, 225, 225, 0, 0, 0, 100, 0, 0, 0, 0, false)
			renderer.circle(menuX - 20, menuY + menuH - 205, 0, 0, 0, 190, 13, 0, 1)
			renderer.line(menuX - 20, menuY + menuH - 199, menuX - 11, menuY + menuH - 209, 255, 255, 255, 255)
			renderer.line(menuX - 20, menuY + menuH - 199, menuX - 29, menuY + menuH - 209, 255, 255, 255, 255)
		elseif ExtendedMousePosX >= var_101_4.cvrtX and ExtendedMousePosX <= var_101_5.cvrtX and MouseHudPosY >= var_101_4.cvrtY and MouseHudPosY <= var_101_5.cvrtY then
			renderer.circle(menuX - 20, menuY + menuH - 205, 0, 0, 0, 170, 12, 0, 1)
			renderer.line(menuX - 20, menuY + menuH - 200, menuX - 12, menuY + menuH - 209, 255, 255, 255, 150)
			renderer.line(menuX - 20, menuY + menuH - 200, menuX - 28, menuY + menuH - 209, 255, 255, 255, 150)
		end

		var_0_0.draw_filled_rect(menuX - 225, menuY, 225, menuH - 225, 19, 19, 19, 255)
		var_0_0.draw_line(menuX - 210, menuY + 50, menuX - 25, menuY + 50, 50, 50, 50, 255)

		if SearchSelected then
			if ExtendedMousePosX >= var_101_4.srchbrX and ExtendedMousePosX <= var_101_5.srchbrX and ExtendedMousePosY >= var_101_4.srchbrY and ExtendedMousePosY <= var_101_5.srchbrY then
				if LClick then
					julliekankermoeders = true
				elseif julliekankermoeders == true then
					julliekankermoeders = false
					SearchSelected = false
				end
			end

			var_0_0.draw_filled_rect(menuX - 210, menuY + 11, 185, 30, 50, 50, 50, 255)
			var_0_0.draw_text(menuX - 180, menuY + 17, 255, 255, 255, 255, var_0_39, "Search")
			renderer.circle_outline(menuX - 197, menuY + 24, 255, 255, 255, 255, 7, 0, 1, 2)
			renderer.line(menuX - 194, menuY + 28, menuX - 188, menuY + 35, 255, 255, 255, 255)
			DrawSubtab("search")
		elseif ExtendedMousePosX >= var_101_4.srchbrX and ExtendedMousePosX <= var_101_5.srchbrX and ExtendedMousePosY >= var_101_4.srchbrY and ExtendedMousePosY <= var_101_5.srchbrY then
			var_0_0.draw_text(menuX - 180, menuY + 17, 255, 255, 255, 255, var_0_39, "Search")
			renderer.circle_outline(menuX - 197, menuY + 24, 255, 255, 255, 255, 7, 0, 1, 2)
			renderer.line(menuX - 194, menuY + 28, menuX - 188, menuY + 35, 255, 255, 255, 255)

			if LClick then
				julliekankermoeders = true
			elseif julliekankermoeders == true then
				julliekankermoeders = false
				SearchSelected = true
				PlaylistSelected = false
			end
		else
			var_0_0.draw_text(menuX - 180, menuY + 17, 150, 150, 150, 255, var_0_39, "Search")
			renderer.circle_outline(menuX - 197, menuY + 24, 150, 150, 150, 255, 7, 0, 1, 2)
			renderer.line(menuX - 194, menuY + 28, menuX - 188, menuY + 35, 150, 150, 150, 255)
		end

		if PlaylistSelected then
			DrawSubtab("playlist")
			var_0_0.draw_text(menuX - 180, menuY + 17, 150, 150, 150, 255, var_0_39, "Search")
			renderer.circle_outline(menuX - 197, menuY + 24, 150, 150, 150, 255, 7, 0, 1, 2)
			renderer.line(menuX - 194, menuY + 28, menuX - 188, menuY + 35, 150, 150, 150, 255)
		end

		if PlaylistLimitReached == false then
			if ExtendedMousePosX >= var_101_4.nwplylstX and ExtendedMousePosX <= var_101_5.nwplylstX and ExtendedMousePosY >= var_101_4.nwplylstY and ExtendedMousePosY <= var_101_5.nwplylstY then
				if LClick then
					julliekankermoeders = true

					var_0_0.draw_text(menuX - 200, menuY + 65 + 30 * PlayListCount, 150, 150, 150, 150, var_0_39, "+  Add Playlist")
				elseif julliekankermoeders == true then
					julliekankermoeders = false

					local var_101_6 = var_0_83()
					local var_101_7 = string.gsub(var_101_6, "https://open.spotify.com/playlist/", "")
					local var_101_8, var_101_9 = string.match(var_101_7, "(.*)?(.*)")

					InitPlaylist(var_101_8)
				else
					var_0_0.draw_text(menuX - 200, menuY + 65 + 30 * PlayListCount, 255, 255, 255, 255, var_0_39, "+  Add Playlist")
				end
			else
				var_0_0.draw_text(menuX - 200, menuY + 65 + 30 * PlayListCount, 150, 150, 150, 255, var_0_39, "+  Add Playlist")
			end
		end

		local var_101_10 = 0

		for iter_101_0, iter_101_1 in ipairs(Playlists) do
			local var_101_11, var_101_12 = string.match(Playlists[iter_101_0].PlaylistName, "(.*),(.*)")

			if ExtendedMousePosX >= var_101_4.plylstfstX and ExtendedMousePosX <= var_101_5.plylstfstX and ExtendedMousePosY >= var_101_4.plylstfstY + 30 * (iter_101_0 - 1) and ExtendedMousePosY <= var_101_5.plylstfstY + 30 * (iter_101_0 - 1) then
				if LClick then
					julliekankermoeders = true

					var_0_0.draw_text(menuX - 210, menuY + 65 + 30 * (iter_101_0 - 1), 150, 150, 150, 255, var_0_40, "> " .. var_101_11)
				elseif julliekankermoeders == true then
					julliekankermoeders = false
					SearchSelected = false
					scrollvalue = 0

					LoadPlaylist(Playlists[iter_101_0].PlaylistName)
				else
					var_0_0.draw_text(menuX - 210, menuY + 65 + 30 * (iter_101_0 - 1), 255, 255, 255, 255, var_0_40, "> " .. var_101_11)
				end
			else
				var_0_0.draw_text(menuX - 210, menuY + 65 + 30 * (iter_101_0 - 1), 150, 150, 150, 255, var_0_40, "> " .. var_101_11)
			end

			local var_101_13 = var_101_10 + 1
		end
	end
end

function MenuBarAnimHandler()
	if MenuBarExtended and AnimSizePerc ~= 200 then
		AnimSizePerc = AnimSizePerc + 4
	elseif not MenuBarExtended and AnimSizePerc ~= 100 then
		AnimSizePerc = AnimSizePerc - 4
	elseif MenuBarExtended and AnimSizePerc == 200 then
		OnGoingAnim = false
	elseif not MenuBarExtended and AnimSizePerc == 100 then
		OnGoingAnim = false
	end

	local var_104_0 = AnimSizePerc - 175
	local var_104_1 = AnimSizePerc - 100

	if AnimSizePerc <= 140 then
		if Thumbnail ~= nil and not CurrentDataSpotify.item.is_local then
			Thumbnail:draw(menuX + 10 - 2.125 * var_104_1, menuY + menuH + 10, 75, 75)
		end

		renderer.rectangle(menuX - 5.625 * var_104_1, menuY + menuH - 3, 5.65 * var_104_1, 100, 18, 18, 18, 255)
	elseif AnimSizePerc == 150 then
		if Thumbnail ~= nil and not CurrentDataSpotify.item.is_local then
			Thumbnail:draw(menuX - 225, menuY + menuH + 10, 225, 5)
		end

		renderer.rectangle(menuX - 225, menuY + menuH - 3, 226, 100, 18, 18, 18, 255)
	elseif AnimSizePerc >= 175 then
		if Thumbnail ~= nil and not CurrentDataSpotify.item.is_local then
			Thumbnail:draw(menuX - 225, menuY + menuH + 0 - 9 * var_104_0, 225, 9 * var_104_0)
		end

		renderer.rectangle(menuX - 225, menuY + menuH - 3, 226, 100, 18, 18, 18, 255)
	else
		renderer.rectangle(menuX - 225, menuY + menuH - 3, 226, 100, 18, 18, 18, 255)
	end

	var_0_0.draw_filled_rect(menuX - 225, menuY, 225, menuH - 225, 19, 19, 19, 1.275 * AnimSizePerc)
end

function DrawSubtab(arg_105_0)
	local var_105_0 = {
		lmbtnX = 118,
		sngbtnY = 120,
		sngbtnX = 0,
		xtbtnY = 0,
		scrlX = 10,
		xtbtnX = 320,
		scrlY = 121,
		lmbtnY = menuH
	}
	local var_105_1 = {
		lmbtnX = 235,
		sngbtnY = 120,
		sngbtnX = 350,
		xtbtnY = 30,
		scrlX = 340,
		xtbtnX = 350,
		scrlY = menuH,
		lmbtnY = menuH + 23
	}

	var_0_0.draw_filled_rect(menuX + menuW, menuY, 350, menuH + 97, 25, 25, 25, 255)

	if MouseHudrightPosX >= var_105_0.xtbtnX and MouseHudrightPosX <= var_105_1.xtbtnX and ExtendedMousePosY >= var_105_0.xtbtnY and ExtendedMousePosY <= var_105_1.xtbtnY then
		if LClick then
			julliekankermoeders = true

			renderer.line(menuX + menuW + 325, menuY + 10, menuX + menuW + 340, menuY + 25, 90, 10, 10, 255)
			renderer.line(menuX + menuW + 325, menuY + 25, menuX + menuW + 340, menuY + 10, 90, 10, 10, 255)
		elseif julliekankermoeders == true then
			julliekankermoeders = false
			SearchSelected = false
			PlaylistSelected = false
		else
			renderer.line(menuX + menuW + 325, menuY + 10, menuX + menuW + 340, menuY + 25, 200, 20, 20, 255)
			renderer.line(menuX + menuW + 325, menuY + 25, menuX + menuW + 340, menuY + 10, 200, 20, 20, 255)
		end
	else
		renderer.line(menuX + menuW + 325, menuY + 10, menuX + menuW + 340, menuY + 25, 90, 90, 90, 255)
		renderer.line(menuX + menuW + 325, menuY + 25, menuX + menuW + 340, menuY + 10, 90, 90, 90, 255)
	end

	switch(arg_105_0)({
		search = function()
			var_0_0.draw_text(menuX + menuW + 15, menuY + 35, 210, 210, 210, 255, var_0_41, "Search")
			var_0_0.draw_filled_gradient_rect(menuX + menuW, menuY + 15, 350, 60, 25, 25, 25, 0, 25, 25, 25, 210, false)
			var_0_0.draw_text(menuX + menuW + 15, menuY + 100, 210, 210, 210, 255, var_0_42, "This feature is still in development :)")
		end,
		playlist = function()
			local var_107_0 = round((menuH - 120) / 45 - 1)

			if MouseHudrightPosX >= var_105_0.scrlX and MouseHudrightPosX <= var_105_1.scrlX and ExtendedMousePosY >= var_105_0.scrlY and ExtendedMousePosY <= var_105_1.scrlY then
				if scrollvalue >= 0 then
					scrollmin = true
				else
					scrollmin = false
				end

				if scrollvalue <= TrackCount * -1 + var_107_0 then
					scrollmax = true
				else
					scrollmax = false
				end

				var_0_85:init()
			end

			local var_107_1 = var_0_84(currplaylistname, 25)

			var_0_0.draw_text(menuX + menuW + 15, menuY + 35, 210, 210, 210, 255, var_0_41, var_107_1[1])
			var_0_0.draw_filled_gradient_rect(menuX + menuW, menuY + 15, 350, 60, 25, 25, 25, 0, 25, 25, 25, 210, false)
			var_0_0.draw_filled_gradient_rect(menuX + menuW + 250, menuY + 20, 70, 60, 25, 25, 25, 0, 25, 25, 25, 255, true)
			var_0_0.draw_filled_rect(menuX + menuW + 320, menuY + 20, 30, 60, 25, 25, 25, 255)
			renderer.line(menuX + menuW + 10, menuY + 120, menuX + menuW + 340, menuY + 120, 45, 45, 45, 255)
			var_0_0.draw_text(menuX + menuW + 20, menuY + 95, 100, 100, 100, 255, var_0_42, "#")
			var_0_0.draw_text(menuX + menuW + 48, menuY + 98, 100, 100, 100, 255, var_0_43, "TITLE")
			renderer.circle_outline(menuX + menuW + 320, menuY + 106, 97, 97, 97, 255, 7, 0, 100, 1)
			renderer.line(menuX + menuW + 320, menuY + 107, menuX + menuW + 320, menuY + 102, 97, 97, 97, 255)
			renderer.line(menuX + menuW + 321, menuY + 106, menuX + menuW + 323, menuY + 106, 97, 97, 97, 255)

			local var_107_2 = 1

			for iter_107_0 = var_107_0, 1, -1 do
				if scrollvalue * -1 + var_107_2 <= TrackCount then
					local var_107_3, var_107_4, var_107_5, var_107_6, var_107_7 = string.match(currplaylist[scrollvalue * -1 + var_107_2].SongDetails, "(.*)^(.*)^(.*)^(.*)^(.*)")
					local var_107_8 = var_0_84(var_107_3, 29)

					if scrollvalue * -1 + var_107_2 >= 100 then
						var_0_0.draw_text(menuX + menuW + 12, menuY + 95 + 45 * var_107_2, 180, 180, 180, 255, var_0_43, tostring(scrollvalue * -1 + var_107_2))
					elseif scrollvalue * -1 + var_107_2 >= 10 then
						var_0_0.draw_text(menuX + menuW + 16, menuY + 95 + 45 * var_107_2, 180, 180, 180, 255, var_0_43, tostring(scrollvalue * -1 + var_107_2))
					else
						var_0_0.draw_text(menuX + menuW + 20, menuY + 95 + 45 * var_107_2, 180, 180, 180, 255, var_0_43, tostring(scrollvalue * -1 + var_107_2))
					end

					if Currenturi == var_107_6 then
						var_0_0.draw_text(menuX + menuW + 48, menuY + 95 + (45 * var_107_2 - 8), 30, 215, 96, 255, var_0_44, var_107_8[1])
						var_0_0.draw_filled_rect(menuX + menuW, menuY + 95 + (45 * var_107_2 - 8), 43, 45, 25, 25, 25, 255)
						var_0_0.draw_text(menuX + menuW + 16, menuY + 91 + 45 * var_107_2, 30, 215, 96, 255, var_0_46, "►")
					else
						var_0_0.draw_text(menuX + menuW + 48, menuY + 95 + (45 * var_107_2 - 8), 255, 255, 255, 255, var_0_44, var_107_8[1])
					end

					var_0_0.draw_text(menuX + menuW + 48, menuY + 95 + (45 * var_107_2 + 12), 150, 150, 150, 255, var_0_45, var_107_4)
					var_0_0.draw_filled_gradient_rect(menuX + menuW + 270, menuY + 120, 40, menuH, 25, 25, 25, 0, 25, 25, 25, 255, true)

					if MouseHudrightPosX >= var_105_0.sngbtnX and MouseHudrightPosX <= var_105_1.sngbtnX and ExtendedMousePosY >= var_105_0.sngbtnY + 45 * (var_107_2 - 1) and ExtendedMousePosY <= var_105_1.sngbtnY + 45 * var_107_2 then
						if MouseHudrightPosX >= var_105_0.sngbtnX + 300 and MouseHudrightPosX <= var_105_1.sngbtnX and ExtendedMousePosY >= var_105_0.sngbtnY + 45 * (var_107_2 - 1) and ExtendedMousePosY <= var_105_1.sngbtnY + 45 * var_107_2 then
							queuecheck = true

							if LClick then
								julliekankermoeders = true

								var_0_0.draw_text(menuX + menuW + 314, menuY + 89 + 45 * var_107_2, 90, 90, 90, 255, var_0_41, "+")
							elseif julliekankermoeders == true then
								julliekankermoeders = false
								queueselected = true

								QueueSong(var_107_6)
							else
								var_0_0.draw_text(menuX + menuW + 314, menuY + 89 + 45 * var_107_2, 255, 255, 255, 255, var_0_41, "+")
							end
						else
							var_0_0.draw_text(menuX + menuW + 314, menuY + 89 + 45 * var_107_2, 180, 180, 180, 255, var_0_41, "+")

							queuecheck = false
						end

						if LClick and not queuecheck then
							julliekankermoeders = true

							renderer.rectangle(menuX + menuW, menuY + 125 + 45 * (var_107_2 - 1), 350, 45, 150, 150, 150, 20)
						elseif julliekankermoeders == true and not queuecheck then
							julliekankermoeders = false

							PlaySong(scrollvalue * -1 + var_107_2, var_107_3, var_107_4, var_107_7)
						else
							renderer.rectangle(menuX + menuW, menuY + 125 + 45 * (var_107_2 - 1), 350, 45, 150, 150, 150, 50)
						end
					else
						var_0_0.draw_text(menuX + menuW + 310, menuY + 96 + 45 * var_107_2, 150, 150, 150, 255, var_0_45, var_0_86(var_107_5))
					end

					var_107_2 = var_107_2 + 1
				end
			end

			if scrollmax and TrackCount >= 100 then
				if MouseHudrightPosX >= var_105_0.lmbtnX and MouseHudrightPosX <= var_105_1.lmbtnX and ExtendedMousePosY >= var_105_0.lmbtnY and ExtendedMousePosY <= var_105_1.lmbtnY then
					if LClick and not queuecheck then
						julliekankermoeders = true

						var_0_0.draw_text(menuX + menuW + 118, menuY + menuH, 150, 150, 150, 255, var_0_46, "LOAD MORE")
					elseif julliekankermoeders == true and not queuecheck then
						julliekankermoeders = false

						AddPlaylist(currplaylisturi)
					else
						var_0_0.draw_text(menuX + menuW + 118, menuY + menuH, 255, 255, 255, 255, var_0_46, "LOAD MORE")
					end
				else
					var_0_0.draw_text(menuX + menuW + 118, menuY + menuH, 150, 150, 150, 255, var_0_46, "LOAD MORE")
				end
			end

			if var_107_0 < TrackCount then
				renderer.rectangle(menuX + menuW + 342, menuY + 120 + var_107_0 * 44 / (TrackCount - var_107_0) * scrollvalue * -1, 3, 10, 90, 90, 90, 255)
			end
		end
	})
end

function SpotifyClantag()
	if var_0_92(var_0_88.ExtrasBox, "Print song changes in chat") and CurrentSong ~= SongName then
		var_0_76(" \x06[spotify.lua] ♫ \x01Changed song to " .. SongName .. " by " .. ArtistName)

		CurrentSong = SongName
	end

	if not var_0_92(var_0_88.ExtrasBox, "Now playing clantag") then
		return
	end

	local var_108_0 = var_0_84(SongName, 15)
	local var_108_1 = var_0_84(ArtistName, 15)

	if SongName:len() > 15 and ArtistName:len() < 15 then
		clantagGlizzySweat = {
			"Listening to",
			var_108_0[1],
			var_108_0[2],
			"by",
			ArtistName,
			ArtistName
		}
	elseif SongName:len() > 15 and ArtistName:len() > 15 then
		clantagGlizzySweat = {
			"Listening to",
			var_108_0[1],
			var_108_0[2],
			"by",
			var_108_1[1],
			var_108_1[2]
		}
	elseif SongName:len() < 15 and ArtistName:len() > 15 then
		clantagGlizzySweat = {
			"Listening to",
			SongName,
			SongName,
			"by",
			var_108_1[1],
			var_108_1[2]
		}
	elseif SongName:len() < 15 and ArtistName:len() < 15 then
		clantagGlizzySweat = {
			"Listening to",
			SongName,
			SongName,
			"by",
			ArtistName,
			ArtistName
		}
	end

	local var_108_2 = math.floor(globals.tickcount() / 70) % #clantagGlizzySweat
	local var_108_3 = clantagGlizzySweat[var_108_2 + 1]

	if var_108_3 ~= clantag_prev then
		clantag_prev = var_108_3

		client.set_clan_tag(var_108_3)
	end
end

function OnFrame()
	if not var_0_53 then
		return
	end

	if client.unix_time() > var_0_23 + var_0_10(var_0_88.UpdateRate) then
		loadanim = loadanim .. "."

		UpdateInf()

		UpdateCount = UpdateCount + 1
		var_0_23 = client.unix_time()

		var_0_11(var_0_88.SessionUpdates, "Total updates this session: " .. UpdateCount)
		var_0_11(var_0_88.TotalErrors, "Errors this session: " .. TotalErrors)
		var_0_11(var_0_88.SpreeErrors, "Errors this spree: " .. ErrorSpree)

		if ErrorSpree == var_0_10(var_0_88.MaxErrors) or ErrorSpree >= var_0_10(var_0_88.MaxErrors) then
			Authed = false
			ErrorSpree = 0

			ShowMenuElements()
			GetApiToken()

			if AuthStatus == "TOKEN" then
				var_0_11(var_0_88.Connected, "Connecting" .. loadanim)
			end
		end
	end

	if client.unix_time() > var_0_25 + var_0_10(var_0_88.ErrorRate) then
		ErrorSpree = 0

		var_0_11(var_0_88.SpreeErrors, "Errors this spree: " .. ErrorSpree)

		var_0_25 = client.unix_time()
	end

	ShiftClick = client.key_state(16)

	if var_0_10(var_0_48) and Authed then
		LClick = client.key_state(1)

		local var_109_0 = {
			ui.mouse_position()
		}

		rawmouseposX = var_109_0[1]
		rawmouseposY = var_109_0[2]

		var_0_94()
		var_0_101()
		ShowMenuElements()

		if var_0_10(var_0_88.DebugInfo) then
			var_0_11(var_0_88.VolumeLabel, "NewVolume: " .. NewVolume)
			var_0_11(var_0_88.SpotifyPosition, "Position(x - x2(width), y): " .. var_0_50 .. " - " .. SpotifyIndicX2 .. "(" .. adaptivesize .. "), " .. var_0_51 .. "y")
		end

		if var_0_10(var_0_88.IndicType) == "Spotify" then
			var_0_99()
		end

		SpotifyClantag()

		mouseposX = var_109_0[1] - var_0_50
		mouseposY = var_109_0[2] - var_0_51

		if ui.is_menu_open() then
			var_0_93()
			UpdateElements()

			if var_0_10(var_0_88.MenuBarEnable) then
				if UnlockReg == true and LClick then
					seekHandler()
				elseif LClick == false and UnlockReg == true then
					UpdateWaitCheck = true

					Seek(SeekedTime)

					UnlockReg = false
				end

				if UnlockReg2 == true and LClick then
					volumeHandler()
				elseif LClick == false and UnlockReg2 == true then
					UpdateWaitCheck = true
					kanker = true

					ChangeVolume(ScrolledVolume)

					UnlockReg2 = false
				end

				if PlayListCount >= 8 then
					PlaylistLimitReached = true
				end

				drawHUD()
			end
		end

		if var_0_10(var_0_88.ControlSwitch) then
			if NewVolume >= 100 then
				NewVolume = 100
			elseif NewVolume <= 0 then
				NewVolume = 0
			end

			MusicControls()
			gaySexgamer()
			VolumeHandler()

			if var_0_10(var_0_88.PlayPause) or var_0_10(var_0_88.SkipSong) or var_0_10(var_0_88.PreviousSong) or var_0_10(var_0_88.SmartControls) then
				ControlCheck = true
			else
				ControlCheck = false
			end

			if var_0_10(var_0_88.IncreaseVolume) or var_0_10(var_0_88.DecreaseVolume) then
				NiggerSex = true
				VolumeCheck = true
				SetCheck = false

				if globals.tickcount() > var_0_27 + 64 then
					FirstPress = false
				end
			else
				var_0_27 = globals.tickcount()
				FirstPress = true
				VolumeCheck = false
				StopSpamming = true
			end

			if StopSpamming == false then
				var_0_28 = globals.tickcount()
			end

			if FirstPress == false and globals.tickcount() > var_0_26 + var_0_10(var_0_88.VolumeTickSpeed) then
				if var_0_10(var_0_88.IncreaseVolume) then
					NewVolume = NewVolume + var_0_10(var_0_88.VolumeTickAmount)
				elseif var_0_10(var_0_88.DecreaseVolume) then
					NewVolume = NewVolume - var_0_10(var_0_88.VolumeTickAmount)
				end

				var_0_26 = globals.tickcount()
			end
		end
	end
end

ShowMenuElements()
var_0_8(var_0_48, ShowMenuElements)
var_0_8(var_0_88.DebugInfo, ShowMenuElements)
var_0_8(var_0_88.CustomColors, ShowMenuElements)
var_0_8(var_0_88.MenuSize, ChangeMenuSize)
var_0_8(var_0_88.ExtrasBox, function()
	if var_0_92(var_0_88.ExtrasBox, "Higher update rate (experimental)") then
		var_0_11(var_0_88.UpdateRate, 0)
	else
		var_0_11(var_0_88.UpdateRate, 1)
	end
end)
var_0_77.new():init()
client.set_event_callback("paint_ui", OnFrame)
client.set_event_callback("paint", DrawIngame)
client.set_event_callback("shutdown", function()
	var_0_6("previous_posX", var_0_50)
	var_0_6("previous_posY", var_0_51)
	var_0_6("previous_size", SelectedSize)
	var_0_6("StoredKey", var_0_53)
	var_0_6("StoredKey2", var_0_54)
	var_0_6("savedplaylists", Playlists)
	var_0_6("playlistcache", Playlistcache)
end)
