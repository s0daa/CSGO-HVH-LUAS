-- OOP UI Library by SamzSakerz
local a = _G['ui']
local ui = {}
ui.__index = ui;
function ui.new(b)
	return setmetatable({ obj = b }, ui)
end;
function ui:get()
	return a.get(self.obj or self)
end;
function ui:set(c)
	a.set(self.obj or self, c)
	return self
end;
function ui:update(c)
	a.update(self.obj or self, c)
	return self
end;
function ui:ref()
	return self.obj
end;
function ui:set_callback(d)
	a.set_callback(self.obj or self, d)
	return self
end;
function ui:set_visible(e)
	a.set_visible(self.obj or self, e)
	return self
end;
function ui:name()
	return a.name(self.obj or self)
end;
local f = { 'new_button', 'new_checkbox', 'new_color_picker', 'new_combobox', 'new_hotkey', 'new_label', 'new_listbox', 'new_multiselect', 'new_slider', 'new_string', 'new_textbox', 'reference' }
for g = 1, #f do
	local h = f[g]
	ui[h] = function(...)
		return ui.new(a[h](...))
	end
end ;
local i = { 'is_menu_open', 'menu_position', 'menu_size', 'mouse_position' }
for g = 1, #i do
	local j = i[g]
	ui[j] = function(...)
		return a[j](...)
	end
end ;
setmetatable(ui, { __call = function(k, ...)
	return ui.new(...)
end })

-- FileSystem Library by SamzSakerz
local filesystem = {}
local a = { { 'remove_search_path', '\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x8B\xD9', 'void(__thiscall*)(void*, const char*, const char*)' }, { 'remove_file', '\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8D\x85\xCC\xCC\xCC\xCC\x56\x50\x8D\x45\x0C', 'void(__thiscall*)(void*, const char*, const char*)' }, { 'find_next', '\x55\x8B\xEC\x83\xEC\x0C\x53\x8B\xD9\x8B\x0D\xCC\xCC\xCC\xCC', 'const char*(__thiscall*)(void*, int)' }, { 'find_is_directory', '\x55\x8B\xEC\x0F\xB7\x45\x08', 'bool(__thiscall*)(void*, int)' }, { 'find_close', '\x55\x8B\xEC\x53\x8B\x5D\x08\x85', 'void(__thiscall*)(void*, int)' }, { 'find_first', '\x55\x8B\xEC\x6A\x00\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08\xE8\xCC\xCC\xCC\xCC\x5D', 'const char*(__thiscall*)(void*, const char*, const char*, int*)' }, { 'get_current_directory', '\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF\x75\x0C', 'bool(__thiscall*)(void*, char*, int)' } }
local b = require('ffi')
local function c(d, e, f, g)
	local h = client.create_interface(d, e) or error("invalid interface", 2)
	local i = client.find_signature(d, f) or error("invalid signature", 2)
	local j, k = pcall(b.typeof, g)
	if not j then
		error(k, 2)
	end ;
	local l = b.cast(k, i) or error("invalid typecast", 2)
	return function(...)
		return l(h, ...)
	end
end;
for m = 1, #a do
	local n = a[m]
	filesystem[n[1]] = c('filesystem_stdio.dll', 'VFileSystem017', n[2], n[3])
end

local add_to_searchpath = vtable_bind("filesystem_stdio.dll", "VFileSystem017", 11, "void(__thiscall*)(void*, const char*, const char*, int)");

-- Init Shit
local searchpath_key = "SAM_SOUND_BOARD";
local ffi = require('ffi');
local gamePath = ffi.typeof("char[128]")();
filesystem.get_current_directory(gamePath, ffi.sizeof(gamePath))
local soundPath = string.format('%s\\soundboards', ffi.string(gamePath))
add_to_searchpath(soundPath, searchpath_key, 0);

local function getSounds()
	local found_files, fileHandle = {}, ffi.typeof("int[1]")()
	local fileNamePtr = filesystem.find_first("*", searchpath_key, fileHandle);

	while (fileNamePtr ~= nil) do
		local fileName = ffi.string(fileNamePtr)
		if (not filesystem.find_is_directory(fileHandle[0]) and
				fileName:find('.wav')) then
			found_files[#found_files + 1] = fileName;
		end
		fileNamePtr = filesystem.find_next(fileHandle[0]);
	end

	filesystem.find_close(fileHandle[0]);
	return found_files
end

ui.new_label("LUA", "A", "--------------[Start Soundboard]-------------");
local sounds = ui.new_listbox("LUA", "A", "Soundboard", 'There is no sounds...')
local loopback = ui.new_checkbox('LUA', 'A', 'Sound loop back');
local repeatSound = ui.new_checkbox('LUA', 'A', 'Repeat Sound');

local function binToNumber(string)
	return string.byte(string, 1) + string.byte(string, 2) * 256 + string.byte(string, 3) * 65536 + string.byte(string, 4) * 16777216
end

local function getWavFile()
	return readfile('soundboards\\' .. getSounds()[sounds:get() + 1]);
end

local function getWavFileDuration(bytes)
	local size = binToNumber(string.sub(bytes, 4, 8));
	local byterate = binToNumber(string.sub(bytes, 28, 32));
	return (size - 42) / byterate
end

local oldLength = -1;
local started = 0;
local duration = 0;

local isPlaying = false;
local function toggleMic(on)
	isPlaying = on;
	if (on) then
		started = globals.realtime() + duration;
	end
	local loopback = loopback:get() and 1 or 0;
	cvar.voice_loopback:set_int(on and loopback or 0);
	cvar.voice_inputfromfile:set_int(on and 1 or 0);
	client.exec((on and '+' or '-') .. 'voicerecord');
end

ui.new_button("LUA", "A", "Play", function()
	if (oldLength > 0) then
		local bytes = getWavFile();
		writefile('voice_input.wav', bytes);
		duration = getWavFileDuration(bytes);
		toggleMic(true);
	end
end);
ui.new_button("LUA", "A", "Stop", function()
	toggleMic(false);
end);
ui.new_label("LUA", "A", "--------------[End Soundboard]-------------");

client.set_event_callback('paint_ui', function()
	if (isPlaying and started < globals.realtime()) then
		toggleMic(repeatSound:get());
	end

	local newSounds = getSounds();
	if (oldLength ~= #newSounds and ui.is_menu_open()) then
		sounds:update((function()
			local new = {};
			for i = 1, #newSounds do
				new[i] = newSounds[i]:gsub('.wav', '');
			end
			return new;
		end)());
		oldLength = #newSounds;
	end
end);

client.set_event_callback('shutdown', function()
	toggleMic(false)
end)