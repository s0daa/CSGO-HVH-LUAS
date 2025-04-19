slot0 = require("gamesense/surface") or error("gamesense/surface library is required")
slot1 = require("gamesense/http") or error("gamesense/http library is required")
slot2 = require("gamesense/images") or error("gamesense/images library is required")
slot3 = require("gamesense/inspect")
slot4 = require("ffi")
slot6 = database.write
slot7 = package.searchpath
slot8 = ui.set_callback
slot9 = ui.set_visible
slot10 = ui.get
slot11 = ui.set
slot12 = ui.new_label
slot13 = ui.new_button
slot14 = ui.new_checkbox
slot15 = ui.new_combobox
slot16 = ui.new_slider
slot17 = ui.new_color_picker
slot18 = ui.new_hotkey
slot19 = ui.new_multiselect
slot20 = ui.menu_position
slot21 = entity.get_local_player
slot22 = entity.get_prop
slot23 = client.unix_time()
slot24 = client.unix_time()
slot25 = client.unix_time()
slot26 = globals.tickcount()
slot27 = globals.tickcount()
slot28 = globals.tickcount()
slot29 = client.unix_time()
slot30 = globals.tickcount()
slot31, slot32 = client.screen_size()
MenuScaleX = 4.8
MenuScaleY = 10.8
ScaleTitle = 41.54
ScaleArtist = 63.53
ScaleDuration = 57
slot33 = slot0.create_font("GothamBookItalic", slot32 / ScaleTitle, 900, 16)
slot34 = slot0.create_font("GothamBookItalic", slot32 / ScaleArtist, 600, 16)
slot35 = slot0.create_font("GothamBookItalic", 25, 900, 16)
slot36 = slot0.create_font("GothamBookItalic", 20, 600, 16)
slot37 = slot0.create_font("GothamBookItalic", slot32 / ScaleDuration, 600, 16)
slot38 = slot0.create_font("GothamBookItalic", 12, 900, 16)
slot39 = slot0.create_font("GothamBookItalic", 18, 600, 16)
slot40 = slot0.create_font("GothamBookItalic", 18, 500, 16)
slot41 = slot0.create_font("GothamBookItalic", 30, 500, 16)
slot42 = slot0.create_font("GothamBookItalic", 23, 500, 16)
slot43 = slot0.create_font("GothamBookItalic", 17, 500, 16)
slot44 = slot0.create_font("GothamBookItalic", 19, 800, 16)
slot45 = slot0.create_font("GothamBookItalic", 12, 500, 16)
slot46 = slot0.create_font("GothamBookItalic", 24, 500, 16)
slot47 = slot0.create_font("GothamBookItalic", slot32 / ScaleTitle, 900, 16)
slot48 = ui.new_checkbox("MISC", "Miscellaneous", "Spotify")
slot49 = ui.reference("MISC", "Settings", "Menu key")
slot52 = slot5("previous_size") or 30
slot53 = slot5("StoredKey") or nil
slot54 = slot5("StoredKey2") or nil

slot4.cdef([[
	typedef bool (__thiscall *IsButtonDown_t)(void*, int);
	typedef int (__thiscall *GetAnalogValue_t)(void*, int);
	typedef int (__thiscall *GetAnalogDelta_t)(void*, int);
	typedef void***(__thiscall* FindHudElement_t)(void*, const char*);
	typedef void(__cdecl* ChatPrintf_t)(void*, int, int, const char*, ...);
]])

slot55 = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
slot56 = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")
slot57 = slot4.typeof("char[?]")
slot61 = slot4.cast(slot4.typeof("void***"), client.create_interface("inputsystem.dll", "InputSystemVersion001"))[0]
slot65 = slot4.cast("IsButtonDown_t", slot61[15])
slot66 = slot4.cast("GetAnalogValue_t", slot61[18])
slot67 = slot4.cast("GetAnalogDelta_t", slot61[19])
slot75 = slot4.cast("ChatPrintf_t", ((slot4.cast("FindHudElement_t", client.find_signature("client_panorama.dll", "U\\x8b\\xecS\\x8b]VW\\x8b\\xf93\\xf69w(") or error("FindHudElement not found"))(slot4.cast("void**", slot4.cast("char*", client.find_signature("client_panorama.dll", "\\xb9\\xcc\\xcc\\xcc̈F\t") or error("sig1 not found")) + 1)[0] or error("hud is nil"), "CHudChat") or error("CHudChat not found"))[0] or error("CHudChat instance vtable is nil"))[27])

function slot76(slot0)
	uv0(uv1, 0, 0, slot0)
end

slot77 = {
	new = function ()
		return setmetatable({
			laststate = 0,
			tape = 0,
			initd = false,
			events = {}
		}, {
			__index = uv0
		})
	end
}
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
SpotifyScaleX = slot31 / 4.8
SpotifyScaleY = slot32 / 10.8
SpotifyIndicX2 = 1
adaptivesize = 400
ArtScaleY = SpotifyScaleY
ArtScaleX = SpotifyScaleY
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

function slot83()
	if uv0() > 0 then
		slot1 = uv1(slot0)

		uv2(0, slot1, slot0)

		return uv3.string(slot1, slot0 - 1)
	end
end

function slot84(slot0, slot1)
	slot2 = {}

	for slot6 = 1, #slot0, slot1 do
		slot2[#slot2 + 1] = slot0:sub(slot6, slot6 + slot1 - 1)
	end

	return slot2
end

slot85 = slot77.new()

function slot77.init(slot0)
	if not slot0.init then
		slot0.tape = 0
		slot0.laststate = uv0(uv1, 3)
		slot0.initd = true
	end

	if uv0(uv1, 3) == 0 and slot0.tape ~= 0 then
		slot0.tape = 0

		return
	end

	if slot0.tape < uv2(uv1, 3) then
		for slot5, slot6 in ipairs(slot0.events) do
			slot6({
				state = "Up",
				pos = slot1
			})
		end

		slot0.tape = slot1
	elseif slot1 < slot0.tape then
		for slot5, slot6 in ipairs(slot0.events) do
			slot6({
				state = "Down",
				pos = slot1
			})
		end

		slot0.tape = slot1
	end

	if uv2(uv1, 3) >= last_analogvalue + 1 and not scrollmin then
		scrollvalue = scrollvalue + 1
	elseif uv2(uv1, 3) <= last_analogvalue - 1 and not scrollmax then
		scrollvalue = scrollvalue - 1
	end

	last_analogvalue = uv2(uv1, 3)
end

slot1.get("https://i.imgur.com/wREhluX.png", function (slot0, slot1)
	if not slot0 or slot1.status ~= 200 then
		return
	end

	Loop = uv0.load_png(slot1.body)
end)
slot1.get("https://i.imgur.com/rEEvjzM.png", function (slot0, slot1)
	if not slot0 or slot1.status ~= 200 then
		return
	end

	LoopA = uv0.load_png(slot1.body)
end)
slot1.get("https://i.imgur.com/8hjJTCO.png", function (slot0, slot1)
	if not slot0 or slot1.status ~= 200 then
		return
	end

	Shuffle = uv0.load_png(slot1.body)
end)
slot1.get("https://i.imgur.com/HNVpf4j.png", function (slot0, slot1)
	if not slot0 or slot1.status ~= 200 then
		return
	end

	ShuffleA = uv0.load_png(slot1.body)
end)
slot1.get("https://i.imgur.com/rj2IJfJ.png", function (slot0, slot1)
	if not slot0 or slot1.status ~= 200 then
		return
	end

	VolumeSpeaker = uv0.load_png(slot1.body)
end)

currplaylist = {}

if slot5("previous_posX") == nil then
	slot6("previous_posX", database.read("previous_posX") or 0)
	slot6("previous_posY", slot5("previous_posY") or 1020)
elseif slot5("previous_posX") >= slot31 + 3 then
	slot50 = 0
	slot51 = 1020
end

Playlistcache = slot5("playlistcache")

if slot5("savedplaylists") == nil then
	Playlists = {}
	Playlistcache = ""
else
	Playlists = slot5("savedplaylists")

	for slot89, slot90 in ipairs(Playlists) do
		PlayListCount = PlayListCount + 1
	end
end

function switch(slot0)
	return function (slot0)
		if type(slot0[uv0]) == "function" then
			return slot0[uv0]()
		elseif type(slot0.default == "function") then
			return slot0.default()
		end
	end
end

function slot86(slot0)
	slot1 = math.floor(slot0 / 1000)
	slot2 = math.floor(slot1 / 3600)
	slot3 = slot1 - slot2 * 3600
	slot5 = "00" .. slot3 - math.floor(slot3 / 60) * 60

	if slot2 > 0 then
		slot7 = "" .. slot4

		return slot2 .. ":" .. ("00" .. slot7):sub(#slot7 + 1) .. ":" .. slot5:sub(#slot5 - 1)
	else
		return slot4 .. ":" .. slot6
	end
end

function round(slot0)
	return slot0 % 1 >= 0.5 and math.ceil(slot0) or math.floor(slot0)
end

function slot87()
	if AuthClicked == false then
		return
	end

	panorama.loadstring([[
		return {
		  open_url: function(url){
			SteamOverlayAPI.OpenURL(url)
		  }
		}
		]])().open_url(AuthURL)
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

		uv0.get("https://spotify.stbrouwers.cc/refresh_token?refresh_token=" .. uv1, function (slot0, slot1)
			if slot1.status ~= 200 then
				AuthStatus = "WRONGKEY"
				PendingRequest = false

				uv0()

				NewApiKeyRequest = NewApiKeyRequest + 1

				return
			else
				PendingRequest = false
				NewApiKeyRequest = 0
				parsed = json.parse(slot1.body)
				uv1 = parsed.access_token

				Auth()
			end
		end)
	else
		return
	end
end

function Auth()
	if AuthClicked == true then
		uv0 = uv1()
	end

	if uv0 == nil then
		uv2()

		return
	end

	if uv0 ~= nil and uv3 == nil then
		GetApiToken()

		return
	end

	if uv0 ~= nil and uv3 ~= nil then
		uv4.get("https://api.spotify.com/v1/me?&access_token=" .. uv3, function (slot0, slot1)
			ConnectionStatus = slot1.status

			if not slot0 or slot1.status ~= 200 then
				ConnectionStatus = slot1.status
				Authed = false
				AuthStatus = "FAILED"

				GetApiToken()
				ShowMenuElements()
				UpdateElements()

				return
			end

			UpdateCount = UpdateCount + 1
			spotidata = json.parse(slot1.body)
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
		uv0.get("https://api.spotify.com/v1/me/player?access_token=" .. uv1, function (slot0, slot1)
			if not slot0 or slot1.status ~= 200 then
				AuthStatus = "TOKEN"
				ErrorSpree = ErrorSpree + 1
				TotalErrors = TotalErrors + 1
				UpdateWaitCheck = true

				return
			end

			CurrentDataSpotify = json.parse(slot1.body)

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
			TotalDuration = uv0(CurrentDataSpotify.item.duration_ms)
			ProgressDuration = uv0(CurrentDataSpotify.progress_ms)
			LeftDuration = uv0(CurrentDataSpotify.item.duration_ms - CurrentDataSpotify.progress_ms)

			if not CurrentDataSpotify.item.is_local then
				ThumbnailUrl = CurrentDataSpotify.item.album.images[1].url

				uv1.get(ThumbnailUrl, function (slot0, slot1)
					if not slot0 or slot1.status ~= 200 then
						return
					end

					Thumbnail = uv0.load_jpg(slot1.body)
				end)
			end

			if SongNameBack ~= SongName and SongNameBack ~= nil then
				SpotifyIndicX2 = uv3 + adaptivesize
				SongChanged = true
			end
		end)
	end

	UpdateWaitCheck = false
end

function PlayPause()
	if CurrentDataSpotify.is_playing then
		PlayState = "Paused"

		uv1.put("https://api.spotify.com/v1/me/player/pause?device_id=" .. deviceid, {
			headers = {
				["Content-Type"] = "application/json",
				["Content-length"] = 0,
				Accept = "application/json",
				Authorization = "Bearer " .. uv0
			}
		}, function (slot0, slot1)
			UpdateCount = UpdateCount + 1
		end)
	else
		PlayState = "Playing"

		uv1.put("https://api.spotify.com/v1/me/player/play?device_id=" .. deviceid, slot0, function (slot0, slot1)
			UpdateCount = UpdateCount + 1
			UpdateWaitCheck = true
		end)
	end
end

function NextTrack()
	uv1.post("https://api.spotify.com/v1/me/player/next?device_id=" .. deviceid, {
		headers = {
			["Content-Type"] = "application/json",
			["Content-length"] = 0,
			Accept = "application/json",
			Authorization = "Bearer " .. uv0
		}
	}, function (slot0, slot1)
		UpdateCount = UpdateCount + 1
	end)
end

function PreviousTrack()
	uv1.post("https://api.spotify.com/v1/me/player/previous?device_id=" .. deviceid, {
		headers = {
			["Content-Type"] = "application/json",
			["Content-length"] = 0,
			Accept = "application/json",
			Authorization = "Bearer " .. uv0
		}
	}, function (slot0, slot1)
		UpdateCount = UpdateCount + 1
	end)
end

function ShuffleToggle()
	if ShuffleState == true then
		ShuffleState = false
	else
		ShuffleState = true
	end

	uv1.put("https://api.spotify.com/v1/me/player/shuffle?device_id=" .. deviceid .. "&state=" .. tostring(ShuffleState), {
		headers = {
			["Content-Type"] = "application/json",
			["Content-length"] = 0,
			Accept = "application/json",
			Authorization = "Bearer " .. uv0
		}
	}, function (slot0, slot1)
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

	uv1.put("https://api.spotify.com/v1/me/player/repeat?device_id=" .. deviceid .. "&state=" .. RepeatState, {
		headers = {
			["Content-Type"] = "application/json",
			["Content-length"] = 0,
			Accept = "application/json",
			Authorization = "Bearer " .. uv0
		}
	}, function (slot0, slot1)
		UpdateCount = UpdateCount + 1
		UpdateWaitCheck = true
	end)
end

slot88 = {
	Connected = slot12("MISC", "Miscellaneous", AuthStatus),
	AuthButton = slot13("MISC", "Miscellaneous", "Authorize", function ()
		AuthClicked = true

		Auth()
	end),
	IndicType = slot15("MISC", "Miscellaneous", "Type", "Spotify", "Minimal"),
	Additions = slot19("MISC", "Miscellaneous", "Additions", "Cover art", "Duration", "Vitals", "Fixed width"),
	CustomLayoutType = slot15("MISC", "Miscellaneous", "Art location", "Left", "Right"),
	MenuSize = slot16("MISC", "Miscellaneous", "Scale", 50, 150, 100, true, "%"),
	WidthLock = slot12("MISC", "Miscellaneous", "⭥\t\t\t\t\t\t[LINKED]\t\t\t\t\t\t ⭥"),
	MinimumWidth = slot16("MISC", "Miscellaneous", "Minimum box width", 199, 600, 400, true, "px", 1, {
		[199.0] = "Auto"
	}),
	FixedWidth = slot16("MISC", "Miscellaneous", "Box width", 200, 600, 400, true, "px", 1),
	DebugInfo = slot14("MISC", "Miscellaneous", "Debug info"),
	NowPlaying = slot12("MISC", "Miscellaneous", "Now playing:" .. SongName),
	Artist = slot12("MISC", "Miscellaneous", "By:" .. ArtistName),
	SongDuration = slot12("MISC", "Miscellaneous", SongProgression .. SongLength),
	VolumeLabel = slot12("MISC", "Miscellaneous", "NewVolume: " .. NewVolume),
	UpdateRate = slot16("MISC", "Miscellaneous", "Update rate", 0.5, 5, 1, true, "s"),
	RateLimitWarning = slot12("MISC", "Miscellaneous", "WARNING: using <1s updaterate might get you ratelimited"),
	SessionUpdates = slot12("MISC", "Miscellaneous", "Total updates this session: " .. UpdateCount),
	TotalErrors = slot12("MISC", "Miscellaneous", "Errors this session: " .. TotalErrors),
	SpreeErrors = slot12("MISC", "Miscellaneous", "Errors this spree: " .. ErrorSpree),
	RecentError = slot12("MISC", "Miscellaneous", "Most recent error: " .. "-"),
	MaxErrors = slot16("MISC", "Miscellaneous", "Max errors", 1, 20, 5, true, "x"),
	ErrorRate = slot16("MISC", "Miscellaneous", "within", 5, 300, 30, true, "s"),
	FirstPressAmount = slot16("MISC", "Miscellaneous", "First press amount", 1, 20, 5, true, "%"),
	VolumeTickSpeed = slot16("MISC", "Miscellaneous", "Volume tick speed", 1, 64, 2, true, "tc"),
	VolumeTickAmount = slot16("MISC", "Miscellaneous", "Volume tick amount", 1, 10, 1, true, "%"),
	SpotifyPosition = slot12("MISC", "Miscellaneous", "Position(x - x2(width), y): " .. slot50 .. " - " .. SpotifyIndicX2 .. "(" .. adaptivesize .. "), " .. slot51 .. "y"),
	AddError = slot13("MISC", "Miscellaneous", "Add an error", function ()
		AuthStatus = "TOKEN"
		ErrorSpree = ErrorSpree + 1
		TotalErrors = TotalErrors + 1
	end),
	ForceReflowButton = slot13("MISC", "Miscellaneous", "Force element reflow", function ()
		ForceReflow()
	end),
	MenuBarEnable = slot14("MISC", "Miscellaneous", "Menu bar"),
	HideOriginIndic = slot14("MISC", "Miscellaneous", "Hide indicator while in menu"),
	CustomColors = slot14("MISC", "Miscellaneous", "Custom colors"),
	ProgressGradientSwitch = slot14("MISC", "Miscellaneous", "Gradient progress bar"),
	BackgroundGradientSwitch = slot14("MISC", "Miscellaneous", "Gradient background"),
	LabelProgressGradient1 = slot12("MISC", "Miscellaneous", "  - Progress gradient L"),
	ProgressGradient1 = slot17("MISC", "Miscellaneous", "progressbar gradient 1", 0, 255, 0, 255),
	LabelProgressGradient2 = slot12("MISC", "Miscellaneous", "  - Progress gradient R"),
	ProgressGradient2 = slot17("MISC", "Miscellaneous", "progressbar gradient 2", 0, 255, 0, 255),
	LabelGradientColour = slot12("MISC", "Miscellaneous", "  - Progress bar color"),
	GradientColour = ui.new_color_picker("MISC", "Miscellaneous", "progress bar Colourpicker", 0, 255, 0, 255),
	LabelBackgroundColor = slot12("MISC", "Miscellaneous", "  - Background color"),
	BackgroundColour = slot17("MISC", "Miscellaneous", "Background colourrpicker", 25, 25, 25, 255),
	LabelBackgroundColorGradient1 = slot12("MISC", "Miscellaneous", "  - Background gradient L"),
	BackgroundColorGradient1 = slot17("MISC", "Miscellaneous", "Background Gradient colourpicker1", 25, 25, 25, 50),
	LabelBackgroundColorGradient2 = slot12("MISC", "Miscellaneous", "  - Background gradient R"),
	BackgroundColorGradient2 = slot17("MISC", "Miscellaneous", "Background Gradient colourpicker2", 25, 25, 25, 255),
	LabelTextColorPrimary = slot12("MISC", "Miscellaneous", "  - Primary text color"),
	TextColorPrimary = slot17("MISC", "Miscellaneous", "Primary text clr", 255, 255, 255, 255),
	LabelTextColorSecondary = slot12("MISC", "Miscellaneous", "  - Secondary text color"),
	TextColorSecondary = slot17("MISC", "Miscellaneous", "Secondary text clr", 159, 159, 159, 255),
	ControlSwitch = slot14("MISC", "Miscellaneous", "Controls"),
	SmartControlSwitch = slot14("MISC", "Miscellaneous", "Smart controls"),
	SmartVolumeSwitch = slot14("MISC", "Miscellaneous", "Smart volume"),
	SmartControls = slot18("MISC", "Miscellaneous", "  - Smart Controls", true),
	PlayPause = slot18("MISC", "Miscellaneous", "  - Play/Pause", false),
	SkipSong = slot18("MISC", "Miscellaneous", "  - Skip song", false),
	PreviousSong = slot18("MISC", "Miscellaneous", "  - Previous song", false),
	IncreaseVolume = slot18("MISC", "Miscellaneous", "  - Volume up", false),
	DecreaseVolume = slot18("MISC", "Miscellaneous", "  - Volume down", false),
	AdaptiveVolume = slot16("MISC", "Miscellaneous", "Decrease volume by % on voicechat", 0, 100, "off", true, "%", 1, {
		[0] = "off",
		[100.0] = "mute"
	}),
	ExtrasBox = slot19("MISC", "Miscellaneous", "Extras", "Print song changes in chat", "Now playing clantag", "Higher update rate (experimental)"),
	ResetAuth = slot13("MISC", "Miscellaneous", "Reset authorization", function ()
		ResetAPI()
	end),
	KankerOp = slot13("MISC", "Miscellaneous", "Reset playlists", function ()
		uv0("savedplaylists", nil)

		Playlists = {}
		PlayListCount = 0
		PlaylistLimitReached = false
		currplaylist = {}
		currplaylisturi = ""
		currplaylistname = ""
		TrackCount = 0
		Playlistcache = ""

		uv0("playlistcache", Playlistcache)

		PlaylistSelected = false
	end)
}

function ChangeVolume(slot0)
	if kanker then
		kanker = false

		uv1.put("https://api.spotify.com/v1/me/player/volume?volume_percent=" .. round(slot0) .. "&device_id=" .. deviceid, {
			headers = {
				["Content-Type"] = "application/json",
				["Content-length"] = 0,
				Accept = "application/json",
				Authorization = "Bearer " .. uv0
			}
		}, function (slot0, slot1)
			UpdateCount = UpdateCount + 1
		end)

		VolumeBarCache = ScrolledVolume
	else
		if stopRequest then
			return
		end

		uv1.put("https://api.spotify.com/v1/me/player/volume?volume_percent=" .. NewVolume .. "&device_id=" .. deviceid, {
			headers = {
				["Content-Type"] = "application/json",
				["Content-length"] = 0,
				Accept = "application/json",
				Authorization = "Bearer " .. uv0
			}
		}, function (slot0, slot1)
			UpdateCount = UpdateCount + 1
		end)

		stopRequest = true
		StopSpamming = false
		SetCheck = true

		UpdateInf()
	end
end

function Seek(slot0)
	uv1.put("https://api.spotify.com/v1/me/player/seek?position_ms=" .. round(slot0) .. "&device_id=" .. deviceid, {
		headers = {
			["Content-Type"] = "application/json",
			["Content-length"] = 0,
			Accept = "application/json",
			Authorization = "Bearer " .. uv0
		}
	}, function (slot0, slot1)
		UpdateCount = UpdateCount + 1
	end)

	ProgressBarCache = CurrentDataSpotify.item.duration_ms / 404 * MouseHudPosXprgs
	ProgressDuration = uv2(SeekedTime)
	LeftDuration = uv2(CurrentDataSpotify.item.duration_ms - SeekedTime)
end

function PlaySong(slot0, slot1, slot2, slot3)
	uv1.put("https://api.spotify.com/v1/me/player/play", {
		headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json",
			Authorization = "Bearer " .. uv0
		},
		body = json.stringify({
			position_ms = 0,
			context_uri = "spotify:playlist:" .. currplaylisturi,
			offset = {
				position = slot0 - 1
			}
		})
	}, function (slot0, slot1)
		UpdateCount = UpdateCount + 1

		if not success or response.status ~= 200 then
			return
		end

		SongNameHUD = uv0
		ArtistNameHUD = uv1
		ThumbnailUrl = slot0

		uv2.get(ThumbnailUrl, function (slot0, slot1)
			if not slot0 or slot1.status ~= 200 then
				return
			end

			Thumbnail = uv0.load_jpg(slot1.body)
		end)
	end)
end

function QueueSong(slot0)
	uv1.post("https://api.spotify.com/v1/me/player/queue?uri=" .. slot0 .. "&device_id=" .. deviceid, {
		headers = {
			["Content-Type"] = "application/json",
			["Content-length"] = 0,
			Accept = "application/json",
			Authorization = "Bearer " .. uv0
		}
	}, function (slot0, slot1)
		UpdateCount = UpdateCount + 1
	end)
end

function InitPlaylist(slot0)
	if slot0 == nil then
		client.color_log(255, 0, 0, "Failed to add playlist. Make sure that you have your Playlist link in your clipboard, and that the formatting is correct. (https://open.spotify.com/playlist/6piHLVTmzq8nTix2wIlM8x?si=10c8288bd6fc4f94)")

		return
	end

	if string.find(Playlistcache, slot0) ~= nil then
		client.color_log(255, 0, 0, "You have already added this playlist!")

		return
	end

	UpdateWaitCheck = true

	uv0.get("https://api.spotify.com/v1/playlists/" .. slot0 .. "?access_token=" .. uv1 .. "&fields=name", function (slot0, slot1)
		if not slot0 or slot1.status ~= 200 then
			client.color_log(255, 0, 0, "Failed to add playlist. Make sure that you have your Playlist link in your clipboard, and that the formatting is correct. (https://open.spotify.com/playlist/6piHLVTmzq8nTix2wIlM8x?si=10c8288bd6fc4f94)")

			return
		end

		PlayListCount = PlayListCount + 1

		table.insert(Playlists, {
			id = PlayListCount,
			PlaylistName = json.parse(slot1.body).name .. "," .. uv0
		})

		Playlistcache = Playlistcache .. uv0
		UpdateCount = UpdateCount + 1
	end)
end

function LoadPlaylist(slot0)
	slot1, slot2 = string.match(slot0, "(.*),(.*)")
	TrackCount = 0
	UpdateWaitCheck = true

	uv0.get("https://api.spotify.com/v1/playlists/" .. slot2 .. "/tracks?market=US&limit=100&offset=0" .. "&access_token=" .. uv1, function (slot0, slot1)
		if not slot0 or slot1.status ~= 200 then
			return
		end

		currplaylist = {}
		currplaylistname = uv0
		currplaylisturi = uv1

		for slot6, slot7 in ipairs(json.parse(slot1.body).items) do
			TrackCount = TrackCount + 1

			table.insert(currplaylist, {
				id = TrackCount,
				SongDetails = slot2.items[slot6].track.name .. "^" .. slot2.items[slot6].track.artists[1].name .. "^" .. slot2.items[slot6].track.duration_ms .. "^" .. slot2.items[slot6].track.uri .. "^" .. slot2.items[slot6].track.album.images[3].url
			})

			PlaylistSelected = true
			UpdateCount = UpdateCount + 1
		end
	end)
end

function AddPlaylist(slot0)
	UpdateWaitCheck = true

	uv0.get("https://api.spotify.com/v1/playlists/" .. slot0 .. "/tracks?market=US&limit=100&offset=" .. TrackCount .. "&access_token=" .. uv1, function (slot0, slot1)
		if not slot0 or slot1.status ~= 200 then
			return
		end

		for slot6, slot7 in ipairs(json.parse(slot1.body).items) do
			TrackCount = TrackCount + 1

			table.insert(currplaylist, {
				id = TrackCount,
				SongDetails = slot2.items[slot6].track.name .. "^" .. slot2.items[slot6].track.artists[1].name .. "^" .. slot2.items[slot6].track.duration_ms .. "^" .. slot2.items[slot6].track.uri .. "^" .. slot2.items[slot6].track.album.images[3].url
			})

			UpdateCount = UpdateCount + 1
		end
	end)
end

function setConnected(slot0)
	uv0(uv1.Connected, slot0)
end

slot89 = {
	DRegiony = 0,
	DRegionx = 0
}
slot90 = {
	DRegionx = SpotifyScaleX,
	DRegiony = SpotifyScaleY
}

function slot91(slot0, slot1, slot2, slot3, slot4)
	slot5 = {
		ui.mouse_position()
	}
	rawmouseposX = slot5[1]
	rawmouseposY = slot5[2]

	if slot4 or false then
		uv0.draw_filled_rect(slot0, slot1, slot2, slot3, 255, 0, 0, 50)
	end

	return slot0 <= rawmouseposX and rawmouseposX <= slot0 + slot2 and slot1 <= rawmouseposY and rawmouseposY <= slot1 + slot3
end

function slot92(slot0, slot1)
	if slot0 == nil then
		return false
	end

	for slot5 = 0, #uv0(slot0) do
		if slot0[slot5] == slot1 then
			return true
		end
	end

	return false
end

function ShowMenuElements()
	if uv0(uv1) and Authed then
		uv2(uv3.Connected, true)
		uv2(uv3.AuthButton, false)
		uv2(uv3.NowPlaying, true)
		uv2(uv3.Artist, true)
		uv2(uv3.SongDuration, true)
		uv2(uv3.IndicType, true)
		uv2(uv3.GradientColour, true)
		uv2(uv3.LabelGradientColour, true)
		uv2(uv3.CustomColors, true)
		uv2(uv3.ControlSwitch, true)
		uv2(uv3.MenuSize, true)
		uv2(uv3.ResetAuth, true)
		uv2(uv3.MenuBarEnable, true)
		uv2(uv3.ExtrasBox, true)

		if uv0(uv3.IndicType) == "Spotify" then
			uv2(uv3.WidthLock, ShiftClick)
			uv2(uv3.MinimumWidth, not uv4(uv3.Additions, "Fixed width"))
			uv2(uv3.CustomLayoutType, uv4(uv3.Additions, "Cover art"))
			uv2(uv3.FixedWidth, uv4(uv3.Additions, "Fixed width"))
			uv2(uv3.Additions, true)

			if uv0(uv3.CustomColors) then
				uv2(uv3.ProgressGradientSwitch, true)
				uv2(uv3.BackgroundGradientSwitch, true)
				uv2(uv3.LabelTextColorPrimary, true)
				uv2(uv3.TextColorPrimary, true)
				uv2(uv3.LabelTextColorSecondary, true)
				uv2(uv3.TextColorSecondary, true)
				uv2(uv3.BackgroundColour, true)
				uv2(uv3.LabelBackgroundColor, true)

				if uv0(uv3.ProgressGradientSwitch) then
					uv2(uv3.LabelProgressGradient1, true)
					uv2(uv3.ProgressGradient1, true)
					uv2(uv3.LabelProgressGradient2, true)
					uv2(uv3.ProgressGradient2, true)
					uv2(uv3.GradientColour, false)
					uv2(uv3.LabelGradientColour, false)
				else
					uv2(uv3.GradientColour, true)
					uv2(uv3.LabelGradientColour, true)
					uv2(uv3.LabelProgressGradient1, false)
					uv2(uv3.ProgressGradient1, false)
					uv2(uv3.LabelProgressGradient2, false)
					uv2(uv3.ProgressGradient2, false)
				end

				if uv0(uv3.BackgroundGradientSwitch) then
					uv2(uv3.BackgroundColorGradient1, true)
					uv2(uv3.LabelBackgroundColorGradient1, true)
					uv2(uv3.BackgroundColorGradient2, true)
					uv2(uv3.LabelBackgroundColorGradient2, true)
				else
					uv2(uv3.BackgroundColorGradient1, false)
					uv2(uv3.LabelBackgroundColorGradient1, false)
					uv2(uv3.BackgroundColorGradient2, false)
					uv2(uv3.LabelBackgroundColorGradient2, false)
				end
			else
				uv2(uv3.ProgressGradientSwitch, false)
				uv2(uv3.BackgroundGradientSwitch, false)
				uv2(uv3.BackgroundColour, false)
				uv2(uv3.LabelBackgroundColor, false)
				uv2(uv3.LabelTextColorPrimary, false)
				uv2(uv3.TextColorPrimary, false)
				uv2(uv3.LabelTextColorSecondary, false)
				uv2(uv3.TextColorSecondary, false)
				uv2(uv3.BackgroundColorGradient1, false)
				uv2(uv3.LabelBackgroundColorGradient1, false)
				uv2(uv3.BackgroundColorGradient2, false)
				uv2(uv3.LabelBackgroundColorGradient2, false)
				uv2(uv3.LabelProgressGradient1, false)
				uv2(uv3.ProgressGradient1, false)
				uv2(uv3.LabelProgressGradient2, false)
				uv2(uv3.ProgressGradient2, false)
				uv2(uv3.GradientColour, false)
				uv2(uv3.LabelGradientColour, false)
			end
		elseif uv0(uv3.IndicType) == "Minimal" then
			uv2(uv3.MinimumWidth, false)
			uv2(uv3.ProgressGradientSwitch, false)
			uv2(uv3.BackgroundGradientSwitch, false)
			uv2(uv3.BackgroundColour, false)
			uv2(uv3.LabelBackgroundColor, false)
			uv2(uv3.LabelTextColorPrimary, false)
			uv2(uv3.TextColorPrimary, false)
			uv2(uv3.LabelTextColorSecondary, false)
			uv2(uv3.TextColorSecondary, false)
			uv2(uv3.BackgroundColorGradient1, false)
			uv2(uv3.LabelBackgroundColorGradient1, false)
			uv2(uv3.BackgroundColorGradient2, false)
			uv2(uv3.LabelBackgroundColorGradient2, false)
			uv2(uv3.LabelProgressGradient1, false)
			uv2(uv3.ProgressGradient1, false)
			uv2(uv3.LabelProgressGradient2, false)
			uv2(uv3.ProgressGradient2, false)
			uv2(uv3.GradientColour, false)
			uv2(uv3.LabelGradientColour, false)
			uv2(uv3.MenuSize, false)
			uv2(uv3.CustomLayoutType, false)
			uv2(uv3.Additions, false)
			uv2(uv3.FixedWidth, false)

			if uv0(uv3.CustomColors) then
				uv2(uv3.GradientColour, true)
				uv2(uv3.LabelGradientColour, true)
			else
				uv2(uv3.GradientColour, false)
				uv2(uv3.LabelGradientColour, false)
			end
		else
			uv2(uv3.MinimumWidth, false)
			uv2(uv3.CustomLayoutType, false)
			uv2(uv3.ProgressGradientSwitch, false)
			uv2(uv3.BackgroundColour, false)
			uv2(uv3.LabelBackgroundColor, false)
			uv2(uv3.LabelTextColorPrimary, false)
			uv2(uv3.TextColorPrimary, false)
			uv2(uv3.LabelTextColorSecondary, false)
			uv2(uv3.TextColorSecondary, false)
			uv2(uv3.BackgroundColorGradient1, false)
			uv2(uv3.LabelBackgroundColorGradient1, false)
			uv2(uv3.BackgroundColorGradient2, false)
			uv2(uv3.LabelBackgroundColorGradient2, false)
			uv2(uv3.LabelProgressGradient1, false)
			uv2(uv3.ProgressGradient1, false)
			uv2(uv3.LabelProgressGradient2, false)
			uv2(uv3.ProgressGradient2, false)
			uv2(uv3.GradientColour, false)
			uv2(uv3.LabelGradientColour, false)
		end

		if uv0(uv3.MenuBarEnable) then
			uv2(uv3.HideOriginIndic, true)
			uv2(uv3.KankerOp, true)
		else
			uv2(uv3.HideOriginIndic, false)
			uv2(uv3.KankerOp, false)
		end

		if uv0(uv3.ControlSwitch) then
			uv2(uv3.SmartControlSwitch, true)
			uv2(uv3.SmartVolumeSwitch, false)
			uv2(uv3.IncreaseVolume, true)
			uv2(uv3.DecreaseVolume, true)

			if uv0(uv3.SmartControlSwitch) then
				uv2(uv3.SmartControls, true)
				uv2(uv3.SkipSong, false)
				uv2(uv3.PreviousSong, false)
				uv2(uv3.PlayPause, false)
			else
				uv2(uv3.SmartControls, false)
				uv2(uv3.SkipSong, true)
				uv2(uv3.PreviousSong, true)
				uv2(uv3.PlayPause, true)
			end

			if uv0(uv3.SmartVolumeSwitch) then
				uv2(uv3.AdaptiveVolume, false)
			else
				uv2(uv3.AdaptiveVolume, false)
			end
		else
			uv2(uv3.SmartControlSwitch, false)
			uv2(uv3.SmartVolumeSwitch, false)
			uv2(uv3.SmartControls, false)
			uv2(uv3.SkipSong, false)
			uv2(uv3.PreviousSong, false)
			uv2(uv3.PlayPause, false)
			uv2(uv3.IncreaseVolume, false)
			uv2(uv3.DecreaseVolume, false)
			uv2(uv3.AdaptiveVolume, false)
		end

		uv2(uv3.DebugInfo, Authed and UserName == "stbrouwers" or Authed and UserName == "slxyx" or Authed and UserName == "Encoded" or Authed and UserName == "22fzreq5auy5njejk6fzp7nhy")

		if uv0(uv3.DebugInfo) then
			uv2(uv3.NowPlaying, true)
			uv2(uv3.Artist, true)
			uv2(uv3.SongDuration, true)
			uv2(uv3.UpdateRate, true)
			uv2(uv3.RateLimitWarning, uv0(uv3.UpdateRate) <= 0.9)
			uv2(uv3.SessionUpdates, true)
			uv2(uv3.TotalErrors, true)
			uv2(uv3.SpreeErrors, true)
			uv2(uv3.RecentError, true)
			uv2(uv3.ErrorRate, true)
			uv2(uv3.MaxErrors, true)
			uv2(uv3.AddError, true)
			uv2(uv3.SpotifyPosition, true)
			uv2(uv3.ForceReflowButton, true)
			uv2(uv3.VolumeTickSpeed, true)
			uv2(uv3.VolumeTickAmount, true)
			uv2(uv3.FirstPressAmount, true)
			uv2(uv3.VolumeLabel, true)
		else
			uv2(uv3.NowPlaying, false)
			uv2(uv3.Artist, false)
			uv2(uv3.SongDuration, false)
			uv2(uv3.UpdateRate, false)
			uv2(uv3.RateLimitWarning, false)
			uv2(uv3.SessionUpdates, false)
			uv2(uv3.TotalErrors, false)
			uv2(uv3.SpreeErrors, false)
			uv2(uv3.RecentError, false)
			uv2(uv3.ErrorRate, false)
			uv2(uv3.MaxErrors, false)
			uv2(uv3.AddError, false)
			uv2(uv3.SpotifyPosition, false)
			uv2(uv3.ForceReflowButton, false)
			uv2(uv3.VolumeTickSpeed, false)
			uv2(uv3.VolumeTickAmount, false)
			uv2(uv3.FirstPressAmount, false)
			uv2(uv3.VolumeLabel, false)
		end
	elseif uv0(uv1) and not Authed then
		uv2(uv3.Connected, true)
		uv2(uv3.AuthButton, true)
		uv2(uv3.ResetAuth, true)
	elseif not uv0(uv1) then
		for slot3, slot4 in pairs(uv3) do
			for slot8, slot9 in pairs(uv3) do
				if slot3 ~= slot8 and slot9 == slot4 then
					uv3[slot8] = nil
					uv3[slot3] = nil
				end
			end
		end

		for slot3, slot4 in pairs(uv3) do
			ui.set_visible(slot4, false)
		end
	end
end

function ForceReflow()
	for slot3, slot4 in pairs(uv0) do
		for slot8, slot9 in pairs(uv0) do
			if slot3 ~= slot8 and slot9 == slot4 then
				uv0[slot8] = nil
				uv0[slot3] = nil
			end
		end
	end

	for slot3, slot4 in pairs(uv0) do
		ui.set_visible(slot4, false)
	end

	ShowMenuElements()
end

function ResetAPI()
	Authed = false
	ConnectionStatus = "NoConnection"
	uv0 = nil
	uv1 = nil

	uv2("StoredKey", nil)
	uv2("StoredKey2", nil)
	ForceReflow()
	client.reload_active_scripts()
end

function MusicControls()
	if ControlCheck == false then
		if not uv0(uv1.SmartControlSwitch) then
			if uv0(uv1.PlayPause) then
				PlayPause()
			elseif uv0(uv1.SkipSong) then
				NextTrack()
			elseif uv0(uv1.PreviousSong) then
				PreviousTrack()
			end
		elseif uv0(uv1.SmartControls) then
			ClickSpree = ClickSpree + 1
			ClickSpreeTime = ClickSpreeTime + 0.45
			ControlCheck = true
		end
	end

	if client.unix_time() > uv2 + ClickSpreeTime and uv0(uv1.SmartControlSwitch) then
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

		uv2 = client.unix_time()
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

	if uv0(uv1.IncreaseVolume) or uv0(uv1.DecreaseVolume) then
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
	if uv0(uv1.IncreaseVolume) or uv0(uv1.DecreaseVolume) then
		if FirstPress and VolumeCheck == false then
			if uv0(uv1.IncreaseVolume) and not uv0(uv1.DecreaseVolume) then
				NewVolume = NewVolume + uv0(uv1.FirstPressAmount)
			elseif not uv0(uv1.IncreaseVolume) and uv0(uv1.DecreaseVolume) then
				NewVolume = NewVolume - uv0(uv1.FirstPressAmount)
			end
		end

		if NewVolume >= 100 then
			NewVolume = 100
		elseif NewVolume <= 0 then
			NewVolume = 0
		end
	end

	if globals.tickcount() % 64 == analBuggery and not uv0(uv1.IncreaseVolume) and not uv0(uv1.DecreaseVolume) and molestingInfants then
		molestingInfants = false
		stopRequest = false
		NiggerSex = false
		groomingNiglets = true

		ChangeVolume()
	end
end

function UpdateElements()
	switch(AuthStatus)({
		SUCCESS = function ()
			uv0(uv1.Connected, "> " .. "Connected to " .. UserName)
		end,
		FAILED = function ()
			uv0(uv1.Connected, "> Please put your API key into your clipboard (Invalid token)")
		end,
		TOKEN = function ()
			if uv0(uv1.Connected) == "> Please put your API key into your clipboard (Invalid token)" then
				return
			end

			uv2(uv1.RecentError, "Most recent error: " .. "000, REJECTED")
		end,
		FORBIDDEN = function ()
			uv0(uv1.Connected, "> The server has dropped your request. Reason unknown")
			uv0(uv1.RecentError, "Most recent error: " .. "403, FORBIDDEN")
		end,
		RATE = function ()
			uv0(uv1.Connected, "> You've reached the hourly limit of requests. Contact the lua dev")
			uv0(uv1.RecentError, "Most recent error: " .. "429, RATELIMIT")
		end,
		APIFAIL = function ()
			uv0(uv1.Connected, "> An issue on Spotify's end has occurred. Check their status page")
			uv0(uv1.RecentError, "Most recent error: " .. "503, APIFAIL")
		end,
		TRYING = function ()
			uv0(uv1.Connected, "> Trying the refresh key")
		end,
		WRONGKEY = function ()
			uv0(uv1.Connected, "> The supplied refresh key was invalid, please try again.")
			uv0(uv1.RecentError, "Most recent error: " .. "XXX, WRONGKEY")
		end
	})
	uv0(uv1.NowPlaying, "Now playing: " .. SongName)
	uv0(uv1.Artist, "By: " .. ArtistName)
	uv0(uv1.SongDuration, SongProgression .. "/" .. SongLength)
	ShowMenuElements()
end

function slot93()
	slot0 = {
		ui.mouse_position()
	}
	rawmouseposX = slot0[1]
	rawmouseposY = slot0[2]

	if dragging and not LClick then
		dragging = false
	end

	if dragging and LClick then
		if uv0 <= -0.1 and not uv1(uv2.Additions, "Cover art") then
			uv0 = 0
		elseif uv0 + adaptivesize >= uv3 + 0.1 and not uv1(uv2.Additions, "Cover art") then
			uv0 = uv3 - adaptivesize
		elseif uv0 - ArtScaleX <= -0.1 and uv1(uv2.Additions, "Cover art") and uv4(uv2.CustomLayoutType) == "Left" and not uv4(uv2.IndicType) == "Minimal" then
			uv0 = ArtScaleX
		elseif uv0 + adaptivesize >= uv3 + 0.1 and uv1(uv2.Additions, "Cover art") and uv4(uv2.CustomLayoutType) == "Left" and not uv4(uv2.IndicType) == "Minimal" then
			uv0 = uv3 - adaptivesize
		elseif uv0 + adaptivesize + ArtScaleX >= uv3 + 0.1 and uv1(uv2.Additions, "Cover art") and uv4(uv2.CustomLayoutType) == "Right" and not uv4(uv2.IndicType) == "Minimal" then
			uv0 = uv3 - adaptivesize - ArtScaleX
		elseif uv0 <= -0.1 and uv1(uv2.Additions, "Cover art") and uv4(uv2.CustomLayoutType) == "Right" and not uv4(uv2.IndicType) == "Minimal" then
			uv0 = 0
		else
			uv0 = rawmouseposX - xdrag
		end

		if uv5 <= -0.1 then
			uv5 = 0
		elseif uv5 + SpotifyScaleY >= uv6 + 0.1 then
			uv5 = uv6 - SpotifyScaleY
		else
			uv5 = rawmouseposY - ydrag
		end
	end

	if uv7(uv0 - uv8.DRegionx, uv5 - uv8.DRegiony, adaptivesize, SpotifyScaleY, false) and LClick then
		dragging = true
		xdrag = rawmouseposX - uv0
		ydrag = rawmouseposY - uv5
	end
end

function slot94()
	if not Authed then
		return
	end

	titley = nil
	titlex = uv0.get_text_size(uv1, SongName) + 50
	artisty = nil
	artistx = uv0.get_text_size(uv2, ArtistName) + 50

	if uv3(uv4.Additions, "Fixed width") then
		adaptivesize = uv5(uv4.FixedWidth)

		if uv5(uv4.MenuSize) >= 100 then
			uv6(uv4.MenuSize, 100)
		end

		if adaptivesize < titlex then
			if uv5(uv4.MenuSize) > 75 then
				videogaming2021 = uv7(SongName, round(adaptivesize / 11))
			else
				videogaming2021 = uv7(SongName, round(adaptivesize / 8))
			end

			FixedSongName = tostring(videogaming2021[1])
			SongTooLong = true
		else
			SongTooLong = false
		end
	else
		SongTooLong = false

		if artistx < titlex then
			adaptivesize = titlex
		else
			adaptivesize = artistx
		end

		if uv5(uv4.MinimumWidth) > 199 and adaptivesize < uv5(uv4.MinimumWidth) then
			adaptivesize = uv5(uv4.MinimumWidth)
		end

		if SongChanged and uv5(uv4.CustomLayoutType) == "Right" and uv5(uv4.IndicType) == "Spotify" then
			uv8 = SpotifyIndicX2 - adaptivesize
			SongChanged = false
		end
	end

	if uv5(uv4.IndicType) == "Minimal" then
		if uv8 <= -0.1 then
			uv8 = 0
		elseif uv8 >= uv9 + 0.1 then
			uv8 = uv9 - adaptivesize
		end
	end

	if uv5(uv4.IndicType) == "Spotify" then
		if uv8 <= -0.1 and not uv3(uv4.Additions, "Cover art") then
			uv8 = 0
		elseif uv8 + adaptivesize >= uv9 + 0.1 and not uv3(uv4.Additions, "Cover art") then
			uv8 = uv9 - adaptivesize
		elseif uv8 - ArtScaleX <= -0.1 and uv3(uv4.Additions, "Cover art") and uv5(uv4.CustomLayoutType) == "Left" then
			uv8 = ArtScaleX
		elseif uv8 + adaptivesize >= uv9 + 0.1 and uv3(uv4.Additions, "Cover art") and uv5(uv4.CustomLayoutType) == "Left" then
			uv8 = uv9 - adaptivesize
		elseif uv8 + adaptivesize + ArtScaleX >= uv9 + 0.1 and uv3(uv4.Additions, "Cover art") and uv5(uv4.CustomLayoutType) == "Right" then
			uv8 = uv9 - adaptivesize - ArtScaleX
		elseif uv8 <= -0.1 and uv3(uv4.Additions, "Cover art") and uv5(uv4.CustomLayoutType) == "Right" then
			uv8 = 0
		end
	end

	if uv10 <= -0.01 then
		uv10 = 0
	elseif uv10 + SpotifyScaleY >= uv11 + 0.1 then
		uv10 = uv11 - SpotifyScaleY
	end

	SpotifyIndicX2 = uv8 + adaptivesize
end

slot95 = {
	130,
	130,
	130
}
slot96 = 255
slot97 = 0
slot98 = {
	30,
	150
}

function slot99()
	if uv0(uv1.MenuBarEnable) and uv0(uv1.HideOriginIndic) and ui.is_menu_open() then
		return
	end

	ArtScaleY = SpotifyScaleY
	ArtScaleX = SpotifyScaleY

	if uv0(uv1.CustomColors) then
		tr1, tg1, tb1, ta1 = uv0(uv1.TextColorPrimary)
		tr2, tg2, tb2, ta2 = uv0(uv1.TextColorSecondary)
	else
		ta1 = 255
		tb1 = 255
		tg1 = 255
		tr1 = 255
		ta2 = 255
		tb2 = 159
		tg2 = 159
		tr2 = 159
	end

	if uv2(uv1.Additions, "Cover art") then
		switch(uv0(uv1.CustomLayoutType))({
			Left = function ()
				if uv0(uv1.Additions, "Cover art") and Thumbnail ~= nil and not CurrentDataSpotify.item.is_local then
					status, retval = pcall(function ()
						Thumbnail:draw(uv0 - ArtScaleX, uv1, ArtScaleX, ArtScaleY)
					end)

					if status == false or CurrentDataSpotify.item.is_local then
						retardedJpg = true
					end
				end

				if SongTooLong then
					uv4.draw_text(uv2 + 10, uv3 + SpotifyScaleY / 100 * 22, tr1, tg1, tb1, ta1, uv5, FixedSongName)
				else
					uv4.draw_text(uv2 + 10, uv3 + SpotifyScaleY / 100 * 22, tr1, tg1, tb1, ta1, uv5, SongName)
				end

				uv4.draw_text(uv2 + 10, uv3 + SpotifyScaleY / 100 * 52, tr2, tg2, tb2, ta2, uv6, ArtistName)

				if uv0(uv1.Additions, "Duration") then
					uv4.draw_text(uv2 + adaptivesize - SpotifyScaleY / 100 * 85, uv3 + SpotifyScaleY / 100 * 67, tr2, tg2, tb2, ta2, uv7, ProgressDuration .. "/" .. TotalDuration)
				end
			end,
			Right = function ()
				if uv0(uv1.Additions, "Cover art") and Thumbnail ~= nil then
					status, retval = pcall(function ()
						Thumbnail:draw(uv0 + adaptivesize, uv1, ArtScaleX, ArtScaleY)
					end)

					if status == false then
						retardedJpg = true
					end
				end

				if SongTooLong then
					uv4.draw_text(uv2 + adaptivesize - titlex + 40, uv3 + SpotifyScaleY / 100 * 22, tr1, tg1, tb1, ta1, uv5, FixedSongName)
				else
					uv4.draw_text(uv2 + adaptivesize - titlex + 40, uv3 + SpotifyScaleY / 100 * 22, tr1, tg1, tb1, ta1, uv5, SongName)
				end

				uv4.draw_text(uv2 + adaptivesize - artistx + 40, uv3 + SpotifyScaleY / 100 * 52, tr2, tg2, tb2, ta2, uv6, ArtistName)

				if uv0(uv1.Additions, "Duration") then
					uv4.draw_text(uv2 + 8, uv3 + SpotifyScaleY / 100 * 67, tr2, tg2, tb2, ta2, uv7, ProgressDuration .. "/" .. TotalDuration)
				end
			end
		})
	else
		if SongTooLong then
			uv5.draw_text(uv3 + 10, uv4 + SpotifyScaleY / 100 * 22, tr1, tg1, tb1, ta1, uv6, FixedSongName)
		else
			uv5.draw_text(uv3 + 10, uv4 + SpotifyScaleY / 100 * 22, tr1, tg1, tb1, ta1, uv6, SongName)
		end

		uv5.draw_text(uv3 + 10, uv4 + SpotifyScaleY / 100 * 52, tr2, tg2, tb2, ta2, uv7, ArtistName)

		if uv2(uv1.Additions, "Duration") then
			uv5.draw_text(uv3 + adaptivesize - SpotifyScaleY / 100 * 85, uv4 + SpotifyScaleY / 100 * 67, tr2, tg2, tb2, ta2, uv8, ProgressDuration .. "/" .. TotalDuration)
		end
	end
end

slot100 = function ()
	return {
		maximum_count = 7,
		callback_registered = false,
		data = {},
		register_callback = function (slot0)
			if slot0.callback_registered then
				return
			end

			client.set_event_callback("paint_ui", function ()
				slot0 = {
					30,
					150
				}
				slot1 = {
					13,
					13,
					13
				}
				slot2 = 5

				for slot7 = #uv0.data, 1, -1 do
					uv0.data[slot7].time = uv0.data[slot7].time - globals.frametime()
					slot8 = 255
					slot9 = 0

					if slot3[slot7].time < 0 then
						table.remove(uv0.data, slot7)
					else
						slot12 = slot10.def_time - slot10.time > 1 and 1 or slot11

						if slot10.time < 0.5 or slot12 < 0.5 then
							slot9 = (slot12 < 1 and slot12 or slot10.time) / 0.5
							slot8 = slot9 * 255

							if slot9 < 0.2 then
								slot2 = slot2 + 15 * (1 - slot9 / 0.2)
							end
						end

						slot13 = {
							renderer.measure_text(nil, slot10.draw)
						}
						slot14 = {
							slot0[1],
							slot0[2]
						}

						renderer.circle(slot14[1], slot14[2], slot1[1], slot1[2], slot1[3], slot8, 20, 90, 0.5)
						renderer.circle(slot14[1], slot14[2] + 100, slot1[1], slot1[2], slot1[3], slot8, 19, 270, 0.5)
						renderer.rectangle(slot14[1] - 19.3, slot14[2], 39, 100, slot1[1], slot1[2], slot1[3], slot8)
						renderer.circle(slot14[1], slot14[2], 130, 130, 130, slot8, 19, 270, 0.5)
						renderer.rectangle(slot14[1] - 19.3, slot14[2], 39, NewVolume, 130, 130, 130, slot8)

						slot2 = slot2 - 50
					end
				end

				uv0.callback_registered = true
			end)
		end,
		paint = function (slot0, slot1, slot2)
			slot3 = tonumber(slot1) + 1

			for slot7 = slot0.maximum_count, 2, -1 do
				slot0.data[slot7] = slot0.data[slot7 - 1]
			end

			slot0.data[1] = {
				time = slot3,
				def_time = slot3,
				draw = slot2
			}

			slot0:register_callback()
		end
	}
end()

function slot101()
	if uv0(uv1.CustomColors) then
		r, uv2, b, a = uv0(uv1.GradientColour)
		br, bg, bb, ba = uv0(uv1.BackgroundColour)
		gr1, gg1, gb1, ga1 = uv0(uv1.ProgressGradient1)
		gr2, gg2, gb2, ga2 = uv0(uv1.ProgressGradient2)
		br1, bg1, bb1, ba1 = uv0(uv1.BackgroundColorGradient1)
		br2, bg2, bb2, ba2 = uv0(uv1.BackgroundColorGradient2)
	else
		a = 255
		b = 0
		uv2 = 255
		r = 0
		ba = 255
		bb = 25
		bg = 25
		br = 25
		ga1 = 255
		gb1 = 0
		gg1 = 255
		gr1 = 0
		ga2 = 255
		gb2 = 0
		gg2 = 255
		gr2 = 0
		ba1 = 100
		bb1 = 25
		bg1 = 25
		br1 = 25
		ba2 = 255
		bb2 = 25
		bg2 = 25
		br2 = 25
	end

	if CurrentDataSpotify == nil then
		return
	end

	if NiggerSex then
		renderer.rectangle(uv3[1] - 10, uv3[2], 5, 100, 64, 64, 64, 255)
		renderer.rectangle(uv3[1] - 10, uv3[2] + 100, 5, -NewVolume, 29, 185, 84, 255)
		renderer.circle(uv3[1] - 7, uv3[2] + 100 - NewVolume, 255, 255, 255, 255, 6, 0, 1)
	end

	switch(uv0(uv1.IndicType))({
		Spotify = function ()
			if uv0(uv1.MenuBarEnable) and uv0(uv1.HideOriginIndic) and ui.is_menu_open() then
				return
			end

			SpotifyScaleX = uv2 / MenuScaleX
			SpotifyScaleY = uv3 / MenuScaleY

			if uv0(uv1.CustomLayoutType) == "Left" and uv4(uv1.Additions, "Cover art") then
				uv5.draw_filled_rect(uv6, uv7, adaptivesize, SpotifyScaleY, br, bg, bb, ba)
				uv5.draw_filled_rect(uv6 - ArtScaleX, uv7, SpotifyScaleY, SpotifyScaleY, 18, 18, 18, 255)
				renderer.circle_outline(uv6 - ArtScaleX / 2, uv7 + SpotifyScaleY / 2, 64, 64, 64, 255, SpotifyScaleY / 10, 0, 1, 3)
				renderer.circle_outline(uv6 - ArtScaleX / 2, uv7 + SpotifyScaleY / 2, 64, 64, 64, 255, SpotifyScaleY / 100 * 35, 0, 1, 3)
			elseif uv0(uv1.CustomLayoutType) == "Right" and uv4(uv1.Additions, "Cover art") then
				uv5.draw_filled_rect(uv6, uv7, adaptivesize, SpotifyScaleY, br, bg, bb, ba)
				uv5.draw_filled_rect(uv6 + adaptivesize, uv7, ArtScaleX, ArtScaleX, 18, 18, 18, 255)
				renderer.circle_outline(uv6 + adaptivesize + ArtScaleX / 2, uv7 + SpotifyScaleY / 2, 64, 64, 64, 255, SpotifyScaleY / 10, 0, 1, 3)
				renderer.circle_outline(uv6 + adaptivesize + ArtScaleX / 2, uv7 + SpotifyScaleY / 2, 64, 64, 64, 255, SpotifyScaleY / 100 * 35, 0, 1, 3)
			else
				uv5.draw_filled_rect(uv6, uv7, adaptivesize, SpotifyScaleY, br, bg, bb, ba)
			end

			if uv0(uv1.BackgroundGradientSwitch) then
				uv5.draw_filled_gradient_rect(uv6, uv7, adaptivesize, SpotifyScaleY / 20 * 19, br1, bg1, bb1, ba1, br2, bg2, bb2, ba2, true)
			end

			if not uv0(uv1.ProgressGradientSwitch) then
				uv5.draw_filled_rect(uv6, uv7 + SpotifyScaleY / 20 * 19, CurrentDataSpotify.progress_ms / CurrentDataSpotify.item.duration_ms * adaptivesize, SpotifyScaleY / 20 * 1, r, uv8, b, a)
			else
				uv5.draw_filled_gradient_rect(uv6, uv7 + SpotifyScaleY / 20 * 19, CurrentDataSpotify.progress_ms / CurrentDataSpotify.item.duration_ms * adaptivesize, SpotifyScaleY / 20 * 1, gr1, gg1, gb1, ga1, gr2, gg2, gb2, ga2, true)
			end
		end,
		Minimal = function ()
			cbtanalcock = nil
			songartist = renderer.measure_text("b", "Now Playing: " .. CurrentDataSpotify.item.name .. " by " .. CurrentDataSpotify.item.artists[1].name) + 10

			if uv0(ui.reference("MISC", "Settings", "DPI Scale")) == "100%" then
				SpotifyScaleX = 150
				SpotifyScaleY = 15
			elseif slot0 == "125%" then
				SpotifyScaleX = 150
				SpotifyScaleY = 17
			elseif slot0 == "150%" then
				SpotifyScaleX = 150
				SpotifyScaleY = 20
			elseif slot0 == "175%" then
				SpotifyScaleX = 150
				SpotifyScaleY = 22
			elseif slot0 == "200%" then
				SpotifyScaleX = 150
				SpotifyScaleY = 25
			end

			textmeasurement = renderer.measure_text("b", "Now Playing: " .. CurrentDataSpotify.item.name .. " by " .. CurrentDataSpotify.item.artists[1].name) + 10

			renderer.gradient(uv1, uv2, textmeasurement, SpotifyScaleY + 2, 22, 22, 22, 255, 22, 22, 22, 10, true)
			renderer.rectangle(uv1, uv2, 2, SpotifyScaleY + 2, r, uv3, b, a)
			renderer.gradient(uv1, uv2, CurrentDataSpotify.progress_ms / CurrentDataSpotify.item.duration_ms * textmeasurement, 2, r, uv3, b, a, r, uv3, b, 0, true)
			renderer.gradient(uv1, uv2 + SpotifyScaleY, CurrentDataSpotify.progress_ms / CurrentDataSpotify.item.duration_ms * textmeasurement, 2, r, uv3, b, a, r, uv3, b, 0, true)

			if CurrentDataSpotify.is_playing then
				renderer.text(uv1 + 5, uv2 + 2, 255, 255, 255, 255, "bd", 0, "Now Playing: " .. CurrentDataSpotify.item.name .. " by " .. CurrentDataSpotify.item.artists[1].name)
			else
				renderer.text(uv1 + 5, uv2 + 2, 255, 255, 255, 255, "bd", 0, "Paused")
			end
		end
	})
end

function DrawIngame()
	if uv0(uv1.IndicType) ~= "Spotify" or not Authed then
		return
	end

	if uv0(uv1.MenuBarEnable) and uv0(uv1.HideOriginIndic) and ui.is_menu_open() then
		return
	end

	if uv2() == nil then
		return
	end

	if uv3(uv1.Additions, "Vitals") then
		slot2 = 255
		slot2 = math.min(100, uv4(slot0, "m_iHealth")) > 20 and 255 or 20

		if uv3(uv1.Additions, "Cover art") then
			switch(uv0(uv1.CustomLayoutType))({
				Left = function ()
					uv0.draw_filled_rect(uv1 + adaptivesize, uv2 + SpotifyScaleY - SpotifyScaleY / 100 * uv3, 5, SpotifyScaleY / 100 * uv3, 255, uv4, uv4, 255)
					uv0.draw_text(uv1 + adaptivesize + 10, uv2 + SpotifyScaleY - SpotifyScaleY / 100 * uv3 - SpotifyScaleY / 6, 255, uv4, uv4, 255, uv5, "+" .. tostring(uv3))
				end,
				Right = function ()
					uv0.draw_filled_rect(uv1 - 5, uv2 + SpotifyScaleY - SpotifyScaleY / 100 * uv3, 5, SpotifyScaleY / 100 * uv3, 255, uv4, uv4, 255)
				end
			})
		else
			uv5.draw_filled_rect(uv6 + adaptivesize, uv7 + SpotifyScaleY - SpotifyScaleY / 100 * slot1, 5, SpotifyScaleY / 100 * slot1, 255, slot2, slot2, 255)
			uv5.draw_text(uv6 + adaptivesize + 10, uv7 + SpotifyScaleY - SpotifyScaleY / 100 * slot1 - SpotifyScaleY / 6, 255, slot2, slot2, 255, uv8, "+" .. tostring(slot1))
		end
	end
end

function ChangeMenuSize()
	MenuScaleChange = 2 - uv0(uv1.MenuSize) / 100
	MenuScaleX = 4.8 * MenuScaleChange
	MenuScaleY = 10.8 * MenuScaleChange
	ScaleTitle = 41.54 * MenuScaleChange
	ScaleArtist = 63.53 * MenuScaleChange
	ScaleDuration = 54 * MenuScaleChange
	uv2 = uv3.create_font("GothamBookItalic", uv4 / ScaleTitle, 900, 16)
	uv5 = uv3.create_font("GothamBookItalic", uv4 / ScaleArtist, 600, 16)
	uv6 = uv3.create_font("GothamBookItalic", uv4 / ScaleDuration, 600, 16)

	if ShiftClick and not uv7(uv1.Additions, "Fixed width") then
		uv8(uv1.MinimumWidth, uv0(uv1.MenuSize) / 100 * 400)
	elseif ShiftClick then
		uv8(uv1.FixedWidth, uv0(uv1.MenuSize) / 100 * 400)
	end
end

function HoveringOverElement()
	if LClick == true and ClickCheck == true then
		return
	end

	if LClick == true then
		ClickCheck = true

		switch(HoveringOver)({
			shuffle = function ()
				ShuffleToggle()
			end,
			previous = function ()
				PreviousTrack()
			end,
			playpause = function ()
				PlayPause()
			end,
			skip = function ()
				NextTrack()
			end,
			loop = function ()
				LoopToggle()
			end,
			none = function ()
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

		uv0.draw_filled_rect(menuX + menuW / 2 - 200, menuY + menuH + 72, MouseHudPosXprgs, 6, 30, 215, 96, 255)
		renderer.circle(menuX + menuW / 2 - 200, menuY + menuH + 75, 30, 215, 96, 255, 3, 0, 1)
		renderer.circle(MouseHudPosXprgs + menuX + menuW / 2 - 200, menuY + menuH + 75, 255, 255, 255, 255, 7, 0, 1)
		renderer.circle(MouseHudPosXprgs + menuX + menuW / 2 - 200, menuY + menuH + 75, 20, 20, 20, 100, 4, 0, 1)

		SeekedTime = CurrentDataSpotify.item.duration_ms / 404 * MouseHudPosXprgs

		uv0.draw_text(menuX + menuW / 2 - 243, menuY + menuH + 69, 159, 159, 159, 255, uv1, uv2(SeekedTime))
		uv0.draw_text(menuX + menuW / 2 + 218, menuY + menuH + 69, 159, 159, 159, 255, uv1, "-" .. uv2(CurrentDataSpotify.item.duration_ms - SeekedTime))
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
		uv0.draw_filled_rect(menuX + menuW - 106, menuY + menuH + 45, Iwanttodie, 6, 30, 215, 96, 255)
		renderer.circle(Iwanttodie + menuX + menuW - 105, menuY + menuH + 48, 20, 20, 20, 100, 3, 0, 1)
		VolumeSpeaker:draw(menuX + menuW - 140, menuY + menuH + 38, 20, 20, 255, 255, 255, 150)

		ScrolledVolume = 1.2195121951219512 * Iwanttodie
	end
end

function drawHUD()
	if not uv0(uv1.MenuBarEnable) then
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
	slot0 = {
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
		PlpsX = -18,
		PrvY = 28,
		PrvX = -75
	}
	slot1 = {
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
		PlpsX = 18,
		PrvY = 47,
		PrvX = -55
	}

	if menuW <= 1500 and menuW >= 1150 then
		uv2 = uv3.create_font("GothamBookItalic", menuW / 50, 900, 16)
		uv4 = uv3.create_font("GothamBookItalic", menuW / 75, 600, 16)
	elseif menuW <= 1150 and menuW >= 810 then
		uv2 = uv3.create_font("GothamBookItalic", menuW / 40, 900, 16)
		uv4 = uv3.create_font("GothamBookItalic", menuW / 55, 600, 16)
	elseif menuW <= 810 then
		uv2 = uv3.create_font("GothamBookItalic", menuW / 35, 900, 16)
		uv4 = uv3.create_font("GothamBookItalic", menuW / 45, 600, 16)
	end

	uv3.draw_filled_rect(menuX, menuY + menuH - 3, menuW, 100, 25, 25, 25, 255)

	if not MenuBarExtended then
		uv3.draw_text(menuX + 100, menuY + menuH + 20, 255, 255, 255, 255, uv2, SongNameHUD)
		uv3.draw_text(menuX + 100, menuY + menuH + 50, 159, 159, 159, 255, uv4, ArtistNameHUD)
	end

	uv3.draw_filled_rect(menuX + menuW / 2 - 150, menuY + menuH - 3, menuW / 2 + 140, 100, 25, 25, 25, 255)
	renderer.circle_outline(menuX + menuW / 2, menuY + menuH + 40, 255, 255, 255, 150, 16, 0, 1, 1)

	if PlayState == "Playing" then
		uv3.draw_filled_rect(menuX + menuW / 2 - 5, menuY + menuH + 34, 3, 12, 255, 255, 255, 150)
		uv3.draw_filled_rect(menuX + menuW / 2 + 2, menuY + menuH + 34, 3, 12, 255, 255, 255, 150)
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
		uv3.draw_text(menuX + menuW / 2 - 243, menuY + menuH + 69, 159, 159, 159, 255, uv5, ProgressDuration)
		uv3.draw_text(menuX + menuW / 2 + 218, menuY + menuH + 69, 159, 159, 159, 255, uv5, "-" .. LeftDuration)
	end

	renderer.circle(menuX + menuW / 2 - 200, menuY + menuH + 75, 50, 50, 50, 255, 3, 0, 1)
	renderer.circle(menuX + menuW / 2 + 201, menuY + menuH + 75, 50, 50, 50, 255, 3, 0, 1)
	uv3.draw_filled_rect(menuX + menuW / 2 - 200, menuY + menuH + 72, 400, 6, 53, 53, 53, 255)
	renderer.circle(menuX + menuW - 105, menuY + menuH + 48, 50, 50, 50, 255, 3, 0, 1)
	renderer.circle(menuX + menuW - 26, menuY + menuH + 48, 50, 50, 50, 255, 3, 0, 1)
	uv3.draw_filled_rect(menuX + menuW - 106, menuY + menuH + 45, 80, 6, 53, 53, 53, 255)

	if not LClick then
		if slot0.ShflX <= MouseHudPosX and MouseHudPosX <= slot1.ShflX and slot0.ShflY <= MouseHudPosY and MouseHudPosY <= slot1.ShflY then
			if ShuffleState == false then
				Shuffle:draw(menuX + menuW / 2 - 140, menuY + menuH + 24, 30, 30, 255, 255, 255, 255)
			else
				ShuffleA:draw(menuX + menuW / 2 - 140, menuY + menuH + 24, 30, 30, 255, 255, 255, 255)
			end

			HoveringOver = "shuffle"
		elseif slot0.PrvX <= MouseHudPosX and MouseHudPosX <= slot1.PrvX and slot0.PrvY <= MouseHudPosY and MouseHudPosY <= slot1.PrvY then
			renderer.triangle(menuX + menuW / 2 - 68, menuY + menuH + 39, menuX + menuW / 2 - 55, menuY + menuH + 31, menuX + menuW / 2 - 55, menuY + menuH + 47, 255, 255, 255, 255)
			renderer.rectangle(menuX + menuW / 2 - 71, menuY + menuH + 31, 3, 16, 255, 255, 255, 255)

			HoveringOver = "previous"
		elseif slot0.PlpsX <= MouseHudPosX and MouseHudPosX <= slot1.PlpsX and slot0.PlpsY <= MouseHudPosY and MouseHudPosY <= slot1.PlpsY then
			renderer.circle_outline(menuX + menuW / 2, menuY + menuH + 40, 255, 255, 255, 255, 16, 0, 1, 1)

			if PlayState == "Playing" then
				uv3.draw_filled_rect(menuX + menuW / 2 - 5, menuY + menuH + 34, 3, 12, 255, 255, 255, 255)
				uv3.draw_filled_rect(menuX + menuW / 2 + 2, menuY + menuH + 34, 3, 12, 255, 255, 255, 255)
			elseif PlayState == "Paused" then
				renderer.triangle(menuX + menuW / 2 - 4, menuY + menuH + 34, menuX + menuW / 2 - 4, menuY + menuH + 46, menuX + menuW / 2 + 7, menuY + menuH + 40, 255, 255, 255, 255)
			end

			HoveringOver = "playpause"
		elseif slot0.SkpX <= MouseHudPosX and MouseHudPosX <= slot1.SkpX and slot0.SkpY <= MouseHudPosY and MouseHudPosY <= slot1.SkpY then
			renderer.triangle(menuX + menuW / 2 + 68, menuY + menuH + 39, menuX + menuW / 2 + 55, menuY + menuH + 31, menuX + menuW / 2 + 55, menuY + menuH + 47, 255, 255, 255, 255)
			renderer.rectangle(menuX + menuW / 2 + 68, menuY + menuH + 31, 3, 16, 255, 255, 255, 255)

			HoveringOver = "skip"
		elseif slot0.RptX <= MouseHudPosX and MouseHudPosX <= slot1.RptX and slot0.RptY <= MouseHudPosY and MouseHudPosY <= slot1.RptY then
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

	if slot0.prgsbrX <= MouseHudPosX and MouseHudPosX <= slot1.prgsbrX and slot0.prgsbrY <= MouseHudPosY and MouseHudPosY <= slot1.prgsbrY or UnlockReg then
		if LClick then
			UnlockReg = true

			seekHandler()
		else
			if ProgressBarCache >= 0 then
				renderer.circle(menuX + menuW / 2 - 200, menuY + menuH + 75, 30, 215, 96, 255, 3, 0, 1)
			end

			renderer.circle(ProgressBarCache / CurrentDataSpotify.item.duration_ms * 402 + menuX + menuW / 2 - 200, menuY + menuH + 75, 255, 255, 255, 255, 7, 0, 1)
			uv3.draw_filled_rect(menuX + menuW / 2 - 200, menuY + menuH + 72, ProgressBarCache / CurrentDataSpotify.item.duration_ms * 402, 6, 30, 215, 96, 255)
		end
	else
		if ProgressBarCache >= 0 then
			renderer.circle(menuX + menuW / 2 - 200, menuY + menuH + 75, 150, 150, 150, 255, 3, 0, 1)
		end

		renderer.circle(ProgressBarCache / CurrentDataSpotify.item.duration_ms * 402 + menuX + menuW / 2 - 200, menuY + menuH + 75, 150, 150, 150, 255, 3, 0, 1)
		uv3.draw_filled_rect(menuX + menuW / 2 - 200, menuY + menuH + 72, ProgressBarCache / CurrentDataSpotify.item.duration_ms * 402, 6, 150, 150, 150, 255)
	end

	if slot0.vlmvbrhX <= MouseHudrightPosX and MouseHudrightPosX <= slot1.vlmvbrhX and slot0.vlmvbrhY <= MouseHudPosY and MouseHudPosY <= slot1.vlmvbrhY or UnlockReg2 then
		if LClick then
			UnlockReg2 = true

			volumeHandler()
		else
			if VolumeBarCache >= 1 then
				renderer.circle(menuX + menuW - 105, menuY + menuH + 48, 30, 215, 96, 255, 3, 0, 1)
			end

			renderer.circle(menuX + menuW - 105, menuY + menuH + 48, 30, 215, 96, 255, 3, 0, 1)
			renderer.circle(VolumeBarCache / 100 * 80 + menuX + menuW - 105, menuY + menuH + 48, 255, 255, 255, 255, 6, 0, 1)
			uv3.draw_filled_rect(menuX + menuW - 106, menuY + menuH + 45, 0.8 * VolumeBarCache, 6, 30, 215, 96, 255)
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

		uv3.draw_filled_rect(menuX + menuW - 106, menuY + menuH + 45, 0.8 * VolumeBarCache, 6, 150, 150, 150, 255)
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
		slot3 = {
			cvrtX = 85,
			xtbtnY = 58,
			xtbtnX = 36,
			cvrtY = 85
		}

		if ({
			cvrtX = 10,
			xtbtnY = 35,
			xtbtnX = 15,
			cvrtY = 10
		}).xtbtnX <= MouseHudPosLeftX and MouseHudPosLeftX <= slot3.xtbtnX and slot2.xtbtnY <= MouseHudPosY and MouseHudPosY <= slot3.xtbtnY then
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
		elseif slot2.cvrtX <= MouseHudPosLeftX and MouseHudPosLeftX <= slot3.cvrtX and slot2.cvrtY <= MouseHudPosY and MouseHudPosY <= slot3.cvrtY then
			renderer.circle(menuX + 26, menuY + menuH + 48, 0, 0, 0, 170, 12, 0, 1)
			renderer.line(menuX + 28, menuY + menuH + 41, menuX + 20, menuY + menuH + 48, 255, 255, 255, 150)
			renderer.line(menuX + 28, menuY + menuH + 56, menuX + 20, menuY + menuH + 48, 255, 255, 255, 150)
		end
	else
		ExtendedMousePosX = rawmouseposX - menuX + 225
		ExtendedMousePosY = rawmouseposY - menuY
		slot3 = {
			nwplylstX = 145,
			srchbrY = 40,
			srchbrX = 200,
			xtbtnY = -195,
			xtbtnX = 215,
			cvrtY = 0,
			cvrtX = 225,
			plylstfstY = 80,
			plylstfstX = 196,
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

		uv3.draw_filled_rect(menuX - 225, menuY + menuH - 3, 225, 100, 25, 25, 25, 255)
		uv3.draw_text(menuX - 210, menuY + menuH + 23, 255, 255, 255, 255, uv2, SongNameHUD)
		uv3.draw_text(menuX - 210, menuY + menuH + 53, 159, 159, 159, 255, uv4, ArtistNameHUD)

		if ({
			nwplylstX = 21,
			srchbrY = 12,
			srchbrX = 20,
			xtbtnY = -217,
			xtbtnX = 192,
			cvrtY = -225,
			cvrtX = 0,
			plylstfstY = 69,
			plylstfstX = 15,
			nwplylstY = 60 + PlayListCount * 30
		}).xtbtnX <= ExtendedMousePosX and ExtendedMousePosX <= slot3.xtbtnX and slot2.xtbtnY <= MouseHudPosY and MouseHudPosY <= slot3.xtbtnY then
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
		elseif slot2.cvrtX <= ExtendedMousePosX and ExtendedMousePosX <= slot3.cvrtX and slot2.cvrtY <= MouseHudPosY and MouseHudPosY <= slot3.cvrtY then
			renderer.circle(menuX - 20, menuY + menuH - 205, 0, 0, 0, 170, 12, 0, 1)
			renderer.line(menuX - 20, menuY + menuH - 200, menuX - 12, menuY + menuH - 209, 255, 255, 255, 150)
			renderer.line(menuX - 20, menuY + menuH - 200, menuX - 28, menuY + menuH - 209, 255, 255, 255, 150)
		end

		uv3.draw_filled_rect(menuX - 225, menuY, 225, menuH - 225, 19, 19, 19, 255)
		uv3.draw_line(menuX - 210, menuY + 50, menuX - 25, menuY + 50, 50, 50, 50, 255)

		if SearchSelected then
			if slot2.srchbrX <= ExtendedMousePosX and ExtendedMousePosX <= slot3.srchbrX and slot2.srchbrY <= ExtendedMousePosY and ExtendedMousePosY <= slot3.srchbrY then
				if LClick then
					julliekankermoeders = true
				elseif julliekankermoeders == true then
					julliekankermoeders = false
					SearchSelected = false
				end
			end

			uv3.draw_filled_rect(menuX - 210, menuY + 11, 185, 30, 50, 50, 50, 255)
			uv3.draw_text(menuX - 180, menuY + 17, 255, 255, 255, 255, uv6, "Search")
			renderer.circle_outline(menuX - 197, menuY + 24, 255, 255, 255, 255, 7, 0, 1, 2)
			renderer.line(menuX - 194, menuY + 28, menuX - 188, menuY + 35, 255, 255, 255, 255)
			DrawSubtab("search")
		elseif slot2.srchbrX <= ExtendedMousePosX and ExtendedMousePosX <= slot3.srchbrX and slot2.srchbrY <= ExtendedMousePosY and ExtendedMousePosY <= slot3.srchbrY then
			uv3.draw_text(menuX - 180, menuY + 17, 255, 255, 255, 255, uv6, "Search")
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
			uv3.draw_text(menuX - 180, menuY + 17, 150, 150, 150, 255, uv6, "Search")
			renderer.circle_outline(menuX - 197, menuY + 24, 150, 150, 150, 255, 7, 0, 1, 2)
			renderer.line(menuX - 194, menuY + 28, menuX - 188, menuY + 35, 150, 150, 150, 255)
		end

		if PlaylistSelected then
			DrawSubtab("playlist")
			uv3.draw_text(menuX - 180, menuY + 17, 150, 150, 150, 255, uv6, "Search")
			renderer.circle_outline(menuX - 197, menuY + 24, 150, 150, 150, 255, 7, 0, 1, 2)
			renderer.line(menuX - 194, menuY + 28, menuX - 188, menuY + 35, 150, 150, 150, 255)
		end

		if PlaylistLimitReached == false then
			if slot2.nwplylstX <= ExtendedMousePosX and ExtendedMousePosX <= slot3.nwplylstX and slot2.nwplylstY <= ExtendedMousePosY and ExtendedMousePosY <= slot3.nwplylstY then
				if LClick then
					julliekankermoeders = true

					uv3.draw_text(menuX - 200, menuY + 65 + 30 * PlayListCount, 150, 150, 150, 150, uv6, "+  Add Playlist")
				elseif julliekankermoeders == true then
					julliekankermoeders = false
					slot6, slot7 = string.match(string.gsub(uv7(), "https://open.spotify.com/playlist/", ""), "(.*)?(.*)")

					InitPlaylist(slot6)
				else
					uv3.draw_text(menuX - 200, menuY + 65 + 30 * PlayListCount, 255, 255, 255, 255, uv6, "+  Add Playlist")
				end
			else
				uv3.draw_text(menuX - 200, menuY + 65 + 30 * PlayListCount, 150, 150, 150, 255, uv6, "+  Add Playlist")
			end
		end

		slot4 = 0

		for slot8, slot9 in ipairs(Playlists) do
			slot10, slot11 = string.match(Playlists[slot8].PlaylistName, "(.*),(.*)")

			if slot2.plylstfstX <= ExtendedMousePosX and ExtendedMousePosX <= slot3.plylstfstX and ExtendedMousePosY >= slot2.plylstfstY + 30 * (slot8 - 1) and ExtendedMousePosY <= slot3.plylstfstY + 30 * (slot8 - 1) then
				if LClick then
					julliekankermoeders = true

					uv3.draw_text(menuX - 210, menuY + 65 + 30 * (slot8 - 1), 150, 150, 150, 255, uv8, "> " .. slot10)
				elseif julliekankermoeders == true then
					julliekankermoeders = false
					SearchSelected = false
					scrollvalue = 0

					LoadPlaylist(Playlists[slot8].PlaylistName)
				else
					uv3.draw_text(menuX - 210, menuY + 65 + 30 * (slot8 - 1), 255, 255, 255, 255, uv8, "> " .. slot10)
				end
			else
				uv3.draw_text(menuX - 210, menuY + 65 + 30 * (slot8 - 1), 150, 150, 150, 255, uv8, "> " .. slot10)
			end

			slot12 = slot4 + 1
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

	slot0 = AnimSizePerc - 175
	slot1 = AnimSizePerc - 100

	if AnimSizePerc <= 140 then
		if Thumbnail ~= nil and not CurrentDataSpotify.item.is_local then
			Thumbnail:draw(menuX + 10 - 2.125 * slot1, menuY + menuH + 10, 75, 75)
		end

		renderer.rectangle(menuX - 5.625 * slot1, menuY + menuH - 3, 5.65 * slot1, 100, 18, 18, 18, 255)
	elseif AnimSizePerc == 150 then
		if Thumbnail ~= nil and not CurrentDataSpotify.item.is_local then
			Thumbnail:draw(menuX - 225, menuY + menuH + 10, 225, 5)
		end

		renderer.rectangle(menuX - 225, menuY + menuH - 3, 226, 100, 18, 18, 18, 255)
	elseif AnimSizePerc >= 175 then
		if Thumbnail ~= nil and not CurrentDataSpotify.item.is_local then
			Thumbnail:draw(menuX - 225, menuY + menuH + 0 - 9 * slot0, 225, 9 * slot0)
		end

		renderer.rectangle(menuX - 225, menuY + menuH - 3, 226, 100, 18, 18, 18, 255)
	else
		renderer.rectangle(menuX - 225, menuY + menuH - 3, 226, 100, 18, 18, 18, 255)
	end

	uv0.draw_filled_rect(menuX - 225, menuY, 225, menuH - 225, 19, 19, 19, 1.275 * AnimSizePerc)
end

function DrawSubtab(slot0)
	slot2 = {
		sngbtnX = 350,
		xtbtnX = 350,
		scrlX = 340,
		xtbtnY = 30,
		lmbtnX = 235,
		sngbtnY = 120,
		scrlY = menuH,
		lmbtnY = menuH + 23
	}

	uv0.draw_filled_rect(menuX + menuW, menuY, 350, menuH + 97, 25, 25, 25, 255)

	if ({
		sngbtnX = 0,
		scrlY = 121,
		xtbtnX = 320,
		scrlX = 10,
		xtbtnY = 0,
		lmbtnX = 118,
		sngbtnY = 120,
		lmbtnY = menuH
	}).xtbtnX <= MouseHudrightPosX and MouseHudrightPosX <= slot2.xtbtnX and slot1.xtbtnY <= ExtendedMousePosY and ExtendedMousePosY <= slot2.xtbtnY then
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

	switch(slot0)({
		search = function ()
			uv0.draw_text(menuX + menuW + 15, menuY + 35, 210, 210, 210, 255, uv1, "Search")
			uv0.draw_filled_gradient_rect(menuX + menuW, menuY + 15, 350, 60, 25, 25, 25, 0, 25, 25, 25, 210, false)
			uv0.draw_text(menuX + menuW + 15, menuY + 100, 210, 210, 210, 255, uv2, "This feature is still in development :)")
		end,
		playlist = function ()
			slot0 = round((menuH - 120) / 45 - 1)

			if uv0.scrlX <= MouseHudrightPosX and MouseHudrightPosX <= uv1.scrlX and uv0.scrlY <= ExtendedMousePosY and ExtendedMousePosY <= uv1.scrlY then
				if scrollvalue >= 0 then
					scrollmin = true
				else
					scrollmin = false
				end

				if scrollvalue <= TrackCount * -1 + slot0 then
					scrollmax = true
				else
					scrollmax = false
				end

				uv2:init()
			end

			uv4.draw_text(menuX + menuW + 15, menuY + 35, 210, 210, 210, 255, uv5, uv3(currplaylistname, 25)[1])
			uv4.draw_filled_gradient_rect(menuX + menuW, menuY + 15, 350, 60, 25, 25, 25, 0, 25, 25, 25, 210, false)
			uv4.draw_filled_gradient_rect(menuX + menuW + 250, menuY + 20, 70, 60, 25, 25, 25, 0, 25, 25, 25, 255, true)
			uv4.draw_filled_rect(menuX + menuW + 320, menuY + 20, 30, 60, 25, 25, 25, 255)
			renderer.line(menuX + menuW + 10, menuY + 120, menuX + menuW + 340, menuY + 120, 45, 45, 45, 255)
			uv4.draw_text(menuX + menuW + 20, menuY + 95, 100, 100, 100, 255, uv6, "#")
			uv4.draw_text(menuX + menuW + 48, menuY + 98, 100, 100, 100, 255, uv7, "TITLE")
			renderer.circle_outline(menuX + menuW + 320, menuY + 106, 97, 97, 97, 255, 7, 0, 100, 1)
			renderer.line(menuX + menuW + 320, menuY + 107, menuX + menuW + 320, menuY + 102, 97, 97, 97, 255)

			slot6 = menuY + 106

			renderer.line(menuX + menuW + 321, menuY + 106, menuX + menuW + 323, slot6, 97, 97, 97, 255)

			slot2 = 1

			for slot6 = slot0, 1, -1 do
				if scrollvalue * -1 + slot2 <= TrackCount then
					slot7, slot8, slot9, slot10, slot11 = string.match(currplaylist[scrollvalue * -1 + slot2].SongDetails, "(.*)^(.*)^(.*)^(.*)^(.*)")
					slot12 = uv3(slot7, 29)

					if scrollvalue * -1 + slot2 >= 100 then
						uv4.draw_text(menuX + menuW + 12, menuY + 95 + 45 * slot2, 180, 180, 180, 255, uv7, tostring(scrollvalue * -1 + slot2))
					elseif scrollvalue * -1 + slot2 >= 10 then
						uv4.draw_text(menuX + menuW + 16, menuY + 95 + 45 * slot2, 180, 180, 180, 255, uv7, tostring(scrollvalue * -1 + slot2))
					else
						uv4.draw_text(menuX + menuW + 20, menuY + 95 + 45 * slot2, 180, 180, 180, 255, uv7, tostring(scrollvalue * -1 + slot2))
					end

					if Currenturi == slot10 then
						uv4.draw_text(menuX + menuW + 48, menuY + 95 + 45 * slot2 - 8, 30, 215, 96, 255, uv8, slot12[1])
						uv4.draw_filled_rect(menuX + menuW, menuY + 95 + 45 * slot2 - 8, 43, 45, 25, 25, 25, 255)
						uv4.draw_text(menuX + menuW + 16, menuY + 91 + 45 * slot2, 30, 215, 96, 255, uv9, "►")
					else
						uv4.draw_text(menuX + menuW + 48, menuY + 95 + 45 * slot2 - 8, 255, 255, 255, 255, uv8, slot12[1])
					end

					uv4.draw_text(menuX + menuW + 48, menuY + 95 + 45 * slot2 + 12, 150, 150, 150, 255, uv10, slot8)
					uv4.draw_filled_gradient_rect(menuX + menuW + 270, menuY + 120, 40, menuH, 25, 25, 25, 0, 25, 25, 25, 255, true)

					if uv0.sngbtnX <= MouseHudrightPosX and MouseHudrightPosX <= uv1.sngbtnX and ExtendedMousePosY >= uv0.sngbtnY + 45 * (slot2 - 1) and ExtendedMousePosY <= uv1.sngbtnY + 45 * slot2 then
						if MouseHudrightPosX >= uv0.sngbtnX + 300 and MouseHudrightPosX <= uv1.sngbtnX and ExtendedMousePosY >= uv0.sngbtnY + 45 * (slot2 - 1) and ExtendedMousePosY <= uv1.sngbtnY + 45 * slot2 then
							queuecheck = true

							if LClick then
								julliekankermoeders = true

								uv4.draw_text(menuX + menuW + 314, menuY + 89 + 45 * slot2, 90, 90, 90, 255, uv5, "+")
							elseif julliekankermoeders == true then
								julliekankermoeders = false
								queueselected = true

								QueueSong(slot10)
							else
								uv4.draw_text(menuX + menuW + 314, menuY + 89 + 45 * slot2, 255, 255, 255, 255, uv5, "+")
							end
						else
							uv4.draw_text(menuX + menuW + 314, menuY + 89 + 45 * slot2, 180, 180, 180, 255, uv5, "+")

							queuecheck = false
						end

						if LClick and not queuecheck then
							julliekankermoeders = true

							renderer.rectangle(menuX + menuW, menuY + 125 + 45 * (slot2 - 1), 350, 45, 150, 150, 150, 20)
						elseif julliekankermoeders == true and not queuecheck then
							julliekankermoeders = false

							PlaySong(scrollvalue * -1 + slot2, slot7, slot8, slot11)
						else
							renderer.rectangle(menuX + menuW, menuY + 125 + 45 * (slot2 - 1), 350, 45, 150, 150, 150, 50)
						end
					else
						uv4.draw_text(menuX + menuW + 310, menuY + 96 + 45 * slot2, 150, 150, 150, 255, uv10, uv11(slot9))
					end

					slot2 = slot2 + 1
				end
			end

			if scrollmax and TrackCount >= 100 then
				if uv0.lmbtnX <= MouseHudrightPosX and MouseHudrightPosX <= uv1.lmbtnX and uv0.lmbtnY <= ExtendedMousePosY and ExtendedMousePosY <= uv1.lmbtnY then
					if LClick and not queuecheck then
						julliekankermoeders = true

						uv4.draw_text(menuX + menuW + 118, menuY + menuH, 150, 150, 150, 255, uv9, "LOAD MORE")
					elseif julliekankermoeders == true and not queuecheck then
						julliekankermoeders = false

						AddPlaylist(currplaylisturi)
					else
						uv4.draw_text(menuX + menuW + 118, menuY + menuH, 255, 255, 255, 255, uv9, "LOAD MORE")
					end
				else
					uv4.draw_text(menuX + menuW + 118, menuY + menuH, 150, 150, 150, 255, uv9, "LOAD MORE")
				end
			end

			if slot0 < TrackCount then
				renderer.rectangle(menuX + menuW + 342, menuY + 120 + slot0 * 44 / (TrackCount - slot0) * scrollvalue * -1, 3, 10, 90, 90, 90, 255)
			end
		end
	})
end

function SpotifyClantag()
	if uv0(uv1.ExtrasBox, "Print song changes in chat") and CurrentSong ~= SongName then
		uv2(" [spotify.lua] ♫ Changed song to " .. SongName .. " by " .. ArtistName)

		CurrentSong = SongName
	end

	if not uv0(uv1.ExtrasBox, "Now playing clantag") then
		return
	end

	slot0 = uv3(SongName, 15)
	slot1 = uv3(ArtistName, 15)

	if SongName:len() > 15 and ArtistName:len() < 15 then
		clantagGlizzySweat = {
			"Listening to",
			slot0[1],
			slot0[2],
			"by",
			ArtistName,
			ArtistName
		}
	elseif SongName:len() > 15 and ArtistName:len() > 15 then
		clantagGlizzySweat = {
			"Listening to",
			slot0[1],
			slot0[2],
			"by",
			slot1[1],
			slot1[2]
		}
	elseif SongName:len() < 15 and ArtistName:len() > 15 then
		clantagGlizzySweat = {
			"Listening to",
			SongName,
			SongName,
			"by",
			slot1[1],
			slot1[2]
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

	if clantagGlizzySweat[math.floor(globals.tickcount() / 70) % #clantagGlizzySweat + 1] ~= clantag_prev then
		clantag_prev = slot3

		client.set_clan_tag(slot3)
	end
end

function OnFrame()
	if not uv0 then
		return
	end

	if client.unix_time() > uv1 + uv2(uv3.UpdateRate) then
		loadanim = loadanim .. "."

		UpdateInf()

		UpdateCount = UpdateCount + 1
		uv1 = client.unix_time()

		uv4(uv3.SessionUpdates, "Total updates this session: " .. UpdateCount)
		uv4(uv3.TotalErrors, "Errors this session: " .. TotalErrors)
		uv4(uv3.SpreeErrors, "Errors this spree: " .. ErrorSpree)

		if ErrorSpree == uv2(uv3.MaxErrors) or uv2(uv3.MaxErrors) <= ErrorSpree then
			Authed = false
			ErrorSpree = 0

			ShowMenuElements()
			GetApiToken()

			if AuthStatus == "TOKEN" then
				uv4(uv3.Connected, "Connecting" .. loadanim)
			end
		end
	end

	if client.unix_time() > uv5 + uv2(uv3.ErrorRate) then
		ErrorSpree = 0

		uv4(uv3.SpreeErrors, "Errors this spree: " .. ErrorSpree)

		uv5 = client.unix_time()
	end

	ShiftClick = client.key_state(16)

	if uv2(uv6) and Authed then
		LClick = client.key_state(1)
		slot0 = {
			ui.mouse_position()
		}
		rawmouseposX = slot0[1]
		rawmouseposY = slot0[2]

		uv7()
		uv8()
		ShowMenuElements()

		if uv2(uv3.DebugInfo) then
			uv4(uv3.VolumeLabel, "NewVolume: " .. NewVolume)
			uv4(uv3.SpotifyPosition, "Position(x - x2(width), y): " .. uv9 .. " - " .. SpotifyIndicX2 .. "(" .. adaptivesize .. "), " .. uv10 .. "y")
		end

		if uv2(uv3.IndicType) == "Spotify" then
			uv11()
		end

		SpotifyClantag()

		mouseposX = slot0[1] - uv9
		mouseposY = slot0[2] - uv10

		if ui.is_menu_open() then
			uv12()
			UpdateElements()

			if uv2(uv3.MenuBarEnable) then
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

		if uv2(uv3.ControlSwitch) then
			if NewVolume >= 100 then
				NewVolume = 100
			elseif NewVolume <= 0 then
				NewVolume = 0
			end

			MusicControls()
			gaySexgamer()
			VolumeHandler()

			if uv2(uv3.PlayPause) or uv2(uv3.SkipSong) or uv2(uv3.PreviousSong) or uv2(uv3.SmartControls) then
				ControlCheck = true
			else
				ControlCheck = false
			end

			if uv2(uv3.IncreaseVolume) or uv2(uv3.DecreaseVolume) then
				NiggerSex = true
				VolumeCheck = true
				SetCheck = false

				if globals.tickcount() > uv13 + 64 then
					FirstPress = false
				end
			else
				uv13 = globals.tickcount()
				FirstPress = true
				VolumeCheck = false
				StopSpamming = true
			end

			if StopSpamming == false then
				uv14 = globals.tickcount()
			end

			if FirstPress == false and globals.tickcount() > uv15 + uv2(uv3.VolumeTickSpeed) then
				if uv2(uv3.IncreaseVolume) then
					NewVolume = NewVolume + uv2(uv3.VolumeTickAmount)
				elseif uv2(uv3.DecreaseVolume) then
					NewVolume = NewVolume - uv2(uv3.VolumeTickAmount)
				end

				uv15 = globals.tickcount()
			end
		end
	end
end

ShowMenuElements()
slot8(slot48, ShowMenuElements)
slot8(slot88.DebugInfo, ShowMenuElements)
slot8(slot88.CustomColors, ShowMenuElements)
slot8(slot88.MenuSize, ChangeMenuSize)
slot8(slot88.ExtrasBox, function ()
	if uv0(uv1.ExtrasBox, "Higher update rate (experimental)") then
		uv2(uv1.UpdateRate, 0)
	else
		uv2(uv1.UpdateRate, 1)
	end
end)
slot77.new():init()
client.set_event_callback("paint_ui", OnFrame)
client.set_event_callback("paint", DrawIngame)
client.set_event_callback("shutdown", function ()
	uv0("previous_posX", uv1)
	uv0("previous_posY", uv2)
	uv0("previous_size", SelectedSize)
	uv0("StoredKey", uv3)
	uv0("StoredKey2", uv4)
	uv0("savedplaylists", Playlists)
	uv0("playlistcache", Playlistcache)
end)
