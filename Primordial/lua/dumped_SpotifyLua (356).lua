local ffi = require("ffi")
local json = require("primordial/JSON Library.97")
local httpFactory = require("primordial/Lightweight HTTP Library.46")
local buttons = require("primordial/menu buttons.122")

--[[
    Filesystem Library
--]]

local filesystem = {} filesystem.__index = filesystem filesystem.char_buffer = ffi.typeof("char[?]")
filesystem.table = ffi.cast(ffi.typeof("void***"), memory.create_interface("filesystem_stdio.dll", "VBaseFileSystem011"))

filesystem.v_funcs = {
	file_read = ffi.cast(ffi.typeof("int(__thiscall*)(void*, void*, int, void*)"), filesystem.table[0][0]),
    file_open = ffi.cast(ffi.typeof("void*(__thiscall*)(void*, const char*, const char*, const char*)"), filesystem.table[0][2]),
    file_close = ffi.cast(ffi.typeof("void*(__thiscall*)(void*, void*)"), filesystem.table[0][3]),
    file_size = ffi.cast(ffi.typeof("unsigned int(__thiscall*)(void*, void*)"), filesystem.table[0][7]),
}

function filesystem.read_file(path)
	local handle = filesystem.v_funcs.file_open(filesystem.table, path, "r", "MOD")
	if (handle == nil) then return end

	local filesize = filesystem.v_funcs.file_size(filesystem.table, handle)
	if (filesize == nil or filesize < 0) then return end

	local buffer = filesystem.char_buffer(filesize + 1)
	if (buffer == nil) then return end

	if (not filesystem.v_funcs.file_read(filesystem.table, buffer, filesize, handle)) then return end

	filesystem.v_funcs.file_close(filesystem.table, handle)

	return ffi.string(buffer, filesize)
end

local file_text = filesystem.read_file("../primordial/scripts/token.txt") -- Engine Read File

local http = httpFactory.new({
    task_interval = 0.3, -- polling intervals
    enable_debug = false, -- print http requests to the console
    timeout = 10 -- request expiration time
})

local c_hud_chat =
    ffi.cast("unsigned long(__thiscall*)(void*, const char*)", memory.find_pattern("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28"))(
    ffi.cast("unsigned long**", ffi.cast("uintptr_t", memory.find_pattern("client.dll", "B9 ?? ?? ?? ?? E8 ?? ?? ?? ?? 8B 5D 08")) + 1)[0],
    "CHudChat"
)

local ffi_print_chat = ffi.cast("void(__cdecl*)(int, int, int, const char*, ...)", ffi.cast("void***", c_hud_chat)[0][27])

local function PrintChat(msg)
    ffi_print_chat(c_hud_chat, 0, 0, " \x06[spotify.lua] ♫ \x01" .. msg)
end

local refreshkey = nil
local apikey = nil
local SetClanTag = ffi.cast("int(__fastcall*)(const char*)", memory.find_pattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15"));
local isNowPlaying = nil
local deviceid = ""
local ShuffleState = false
local RealVolume = 0
local CacheVolume = 0
local artist = nil
local trackname = nil
local lasttrack = nil
local IsTag = false
local lastupdate = 0
local tagtoset = nil
local tagsize = nil
local ApiTokenRequest = 0

if (file_text) then
	refreshkey = file_text
end

--[[ menu ]]--
local clantagCheckbox = menu.add_checkbox("Spotify", "Clantag", false)
local volumeSlider = menu.add_slider("Spotify", "Volume", 0, 100, 1, 0, "%")
menu.add_button("Spotify", "Refresh", function()
	apikey = nil
    refreshkey = filesystem.read_file("../primordial/scripts/token.txt")
	ApiTokenRequest = 0
end)
menu.add_text("Spotify", "Volume slider + buttons requires spotify premium")

buttons:add_button("Shuffle", function()
    if ShuffleState == true then
		ShuffleState = false
	else
		ShuffleState = true
	end

	local options = {
		headers = {
			["Accept"] = "application/json",
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. apikey,
			["Content-length"] = 0
		}
	}

	http:request("put", "https://api.spotify.com/v1/me/player/shuffle?device_id=" .. deviceid .. "&state=" .. tostring(ShuffleState), options, function(s, r)
		PrintChat("Shuffle: " .. tostring(ShuffleState))
	end)
end)

buttons:add_button("Previous Track", function()
    local options = {
		headers = {
			["Accept"] = "application/json",
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. apikey,
			["Content-length"] = 0
		}
	}

	http:request("post", "https://api.spotify.com/v1/me/player/previous?device_id=" .. deviceid, options, function(s, r) end)
end)

buttons:add_button("Play/Pause", function()
    local options = {
		headers = {
			["Accept"] = "application/json",
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. apikey,
			["Content-length"] = 0
		}
	}

	if isNowPlaying then
        http:request("put", "https://api.spotify.com/v1/me/player/pause?device_id=" .. deviceid, options, function(data) 
			PrintChat("|| Paused")
		end)
	else
        http:request("put", "https://api.spotify.com/v1/me/player/play?device_id=" .. deviceid, options, function(data) 
			PrintChat("▷ Now playing: " .. artist .. " - " .. trackname)
		end)
	end
end)

buttons:add_button("Next Track", function()
    local options = {
		headers = {
			["Accept"] = "application/json",
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. apikey,
			["Content-length"] = 0
		}
	}

	http:request("post", "https://api.spotify.com/v1/me/player/next?device_id=" .. deviceid, options, function(s, r) end)
end)

buttons:add_button("Loop", function()
    if RepeatState == "off" then
		RepeatState = "context"
	elseif RepeatState == "context" then
		RepeatState = "track"
	elseif RepeatState == "track" then
		RepeatState = "off"
	end

	local options = {
		headers = {
			["Accept"] = "application/json",
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. apikey,
			["Content-length"] = 0
		}
	}

	http:request("put", "https://api.spotify.com/v1/me/player/repeat?device_id=" .. deviceid .. "&state=" .. RepeatState, options, function(s, r)
		PrintChat("Loop: " .. RepeatState)
	end)
end)

local function getAPItoken()
	if refreshkey == nil then return end

	if ApiTokenRequest == 0 then
		ApiTokenRequest = 1
		http:get("https://spotify.stbrouwers.cc/refresh_token?refresh_token=" .. refreshkey, function(data)
			if (data:success()) then
				local parsed = json.parse(data.body)
				apikey = parsed.access_token
				print("Logged in")
				PrintChat("Logged in")
			else
				print("WRONGKEY")
			end
		end)
	end
end

local function updateVariables()
    lastupdate = math.floor(global_vars.real_time())

	http:get("https://api.spotify.com/v1/me/player?access_token=" .. apikey, function(data)
		if (data:success()) then
			local currentpaska = json.parse(data.body)
			if currentpaska == nil then return end
			deviceid = currentpaska.device.id
			isNowPlaying = currentpaska.is_playing
			ShuffleState = currentpaska.shuffle_state
			RepeatState = currentpaska.repeat_state
			RealVolume = currentpaska.device.volume_percent

			if CacheVolume ~= RealVolume then
				CacheVolume = RealVolume
				volumeSlider:set(RealVolume)
			elseif volumeSlider:get() ~= RealVolume then
				local options = {
					headers = {
						["Accept"] = "application/json",
						["Content-Type"] = "application/json",
						["Authorization"] = "Bearer " .. apikey,
						["Content-length"] = 0
					}
				}
	
				http:request("put", "https://api.spotify.com/v1/me/player/volume?volume_percent=" .. volumeSlider:get() .. "&device_id=" .. deviceid, options, function(s, r)
					print(apikey)
					print(deviceid)
					print(options)
				end)
				CacheVolume = volumeSlider:get()
				RealVolume = volumeSlider:get()
			end
	
			if isNowPlaying then
				artist = currentpaska.item.artists[1].name;
				trackname = currentpaska.item.name;
				tagtoset = " " .. artist .. " - " .. trackname;
				tagsize = string.len(tagtoset.." | ");
			end
		else
			print("Failed getting new values")
        end
	end)
end

local function spotifyTag()
    if apikey == nil then
		getAPItoken();
    return end
    --if testi1 == false then
    --    updateVariables();
    --return end
	if (math.floor(global_vars.real_time()) % 1 == 0 and not(math.floor(global_vars.real_time()) == lastupdate)) then
		updateVariables();
	end

	local connected = not(entity_list.get_local_player() == nil);
	if not connected then return end

	if lasttrack ~= trackname then
		PrintChat("Changed song to " .. trackname .. " by " .. artist)
		lasttrack = trackname
	end

	if not clantagCheckbox:get() then
		if IsTag == true then
			SetClanTag("")
			IsTag = false
		end
	end

	if connected and clantagCheckbox:get() then
		if global_vars.tick_count() % 32 == 0 then
			if isNowPlaying then
				local curClantag = "";
				for i=0,tagsize
				do
					local curLetter = i + (global_vars.tick_count() / 32);
					curClantag = curClantag .. string.sub(tagtoset.." | ",(curLetter % tagsize),(curLetter % tagsize));
				end
				SetClanTag("▷ " .. curClantag);
			else
				SetClanTag(" || Paused ");
			end
			IsTag = true
		end
	end
end

callbacks.add(e_callbacks.PAINT, spotifyTag)

callbacks.add(e_callbacks.SHUTDOWN, function()
	SetClanTag("")
end)