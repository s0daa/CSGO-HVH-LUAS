local ffi = require('ffi');
local fsdll = "filesystem_stdio.dll"
local fs = "VFileSystem017"

local int_ptr = ffi.typeof("int[1]")
local char_buffer = ffi.typeof("char[?]")

local function sig_bind(module, interface, signature, typestring)
	local iface = client.create_interface(module, interface) or error("invalid interface", 2)
	local instance = client.find_signature(module, signature) or error("invalid signature", 2)
	local success, typeof = pcall(ffi.typeof, typestring)
	if not success then
		error(typeof, 2)
	end
	local fnptr = ffi.cast(typeof, instance) or error("invalid typecast", 2)
	return function(...)
		return fnptr(iface, ...)
	end
end

local add_to_searchpath = vtable_bind("filesystem_stdio.dll", "VFileSystem017", 11, "void(__thiscall*)(void*, const char*, const char*, int)");

--[[local remove_search_path = sig_bind(fsdll, fs, "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x8B\xD9",
	"void(__thiscall*)(void*, const char*, const char*)")

local remove_file = sig_bind(fsdll, fs,
	"\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8D\x85\xCC\xCC\xCC\xCC\x56\x50\x8D\x45\x0C",
	"void(__thiscall*)(void*, const char*, const char*)")]]

local find_next = sig_bind(fsdll, fs,
		"\x55\x8B\xEC\x83\xEC\x0C\x53\x8B\xD9\x8B\x0D\xCC\xCC\xCC\xCC",
		"const char*(__thiscall*)(void*, int)")

local find_is_directory = sig_bind(fsdll, fs,
		"\x55\x8B\xEC\x0F\xB7\x45\x08",
		"bool(__thiscall*)(void*, int)")

local find_close = sig_bind(fsdll, fs,
		"\x55\x8B\xEC\x53\x8B\x5D\x08\x85",
		"void(__thiscall*)(void*, int)")

local find_first = sig_bind(fsdll, fs,
		"\x55\x8B\xEC\x6A\x00\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08\xE8\xCC\xCC\xCC\xCC\x5D",
		"const char*(__thiscall*)(void*, const char*, const char*, int*)")

local get_current_directory = sig_bind(fsdll, fs,
		"\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF\x75\x0C",
		"bool(__thiscall*)(void*, char*, int)")


-- Add Kill says to search path
local key = "SAM_KILL_SAY";
local path = char_buffer(128)
get_current_directory(path, ffi.sizeof(path))
path = ffi.string(path) .. '\\killsays'
add_to_searchpath(path, key, 0)



-- Find all killsays
local function getKillSays()
	local found_files = { "Off" }
	local fileHandle = int_ptr()
	local fileName = find_first("*", key, fileHandle)
	while fileName ~= nil do
		local conv = ffi.string(fileName)
		if not find_is_directory(fileHandle[0]) and conv:find('.wav') then
			table.insert(found_files, conv)
		end
		fileName = find_next(fileHandle[0])
	end
	find_close(fileHandle[0])
	return found_files
end

local isPlaying = false;

local oldLength = #getKillSays();
local killsay = ui.new_combobox('LUA', 'B', 'Microphone killsay', unpack(getKillSays()));
local kill_say_mode = ui.new_combobox('LUA', 'B', 'Killsay mode', { 'Selected', 'Increasement', 'Random' });
local loopback = ui.new_checkbox('LUA', 'B', 'Sound loop back');
--local no_overlap = ui.new_checkbox('LUA', 'B', 'Do not overlap');

local function recreateElement(old, type, ...)
	ui.set_visible(old, false);
	local old_val = ui.get(old);
	local temp = ui[type](...);
	-- Prevents Combobox Item not found error
	pcall(function()
		ui.set(temp, old_val);
	end)
	return temp;
end

local function updateKilLSays()
	if (oldLength ~= #getKillSays()) then
		killsay = recreateElement(killsay, 'new_combobox', 'LUA', 'B', 'Microphone Kill Say', unpack(getKillSays()));
		kill_say_mode = recreateElement(kill_say_mode, 'new_combobox', 'LUA', 'B', 'Killsay mode', { 'Selected', 'Increasement', 'Random' });
		loopback = recreateElement(loopback, 'new_checkbox', 'LUA', 'B', 'Sound loop back');

		oldLength = #getKillSays();
	end
end

local function binToNumber(string)
	return string.byte(string, 1) + string.byte(string, 2) * 256 + string.byte(string, 3) * 65536 + string.byte(string, 4) * 16777216
end

local increasement = 2;
local function getWavFile()
	local killsays = getKillSays();
	local file = ui.get(killsay);
	local mode = ui.get(kill_say_mode);
	if (mode == 'Increasement') then
		file = killsays[increasement];
		increasement = increasement + 1;
		if (increasement > #killsays) then
			increasement = 2;
		end
	elseif (mode == 'Random') then
		file = killsays[math.random(2, #killsays)];
	end
	return readfile('killsays\\' .. file);
end

local function getWavFileDuration(bytes)
	local size = binToNumber(string.sub(bytes, 4, 8));
	local byterate = binToNumber(string.sub(bytes, 28, 32));
	return (size - 42) / byterate
end

local function toggleMic(on)
	isPlaying = on;
	local loopback = ui.get(loopback) and 1 or 0;
	cvar.voice_loopback:set_int(on and loopback or 0);
	cvar.voice_inputfromfile:set_int(on and 1 or 0);
	client.exec((on and '+' or '-') .. 'voicerecord');
end

client.set_event_callback("player_death", function(event)
	local userid, attacker = event.userid, event.attacker

	if (userid and attacker) then
		local userid_idx, attacker_idx, lp_idx = client.userid_to_entindex(userid), client.userid_to_entindex(attacker), entity.get_local_player();

		if (userid_idx and attacker_idx and attacker_idx == lp_idx and userid_idx ~= lp_idx and ui.get(killsay) ~= 'Off') then
			if (not isPlaying) then
				local bytes = getWavFile();
				writefile('voice_input.wav', bytes);
				local duration = getWavFileDuration(bytes);
				client.delay_call(duration, function()
					toggleMic(false);
				end)
				toggleMic(true);
			end
		end
	end
end);

client.set_event_callback('shutdown', function()
	toggleMic(false)
end)

client.set_event_callback('paint_ui', function()
	updateKilLSays();
end)