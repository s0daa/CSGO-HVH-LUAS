local ffi = require "ffi"
local zeroWidthChar = '\u{200C}​'

local function vmt_entry(instance, index, type)
	return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end

local function vmt_thunk(index, typestring)
	local t = ffi.typeof(typestring)
	return function(instance, ...)
		assert(instance ~= nil)
		if instance then
			return vmt_entry(instance, index, t)(instance, ...)
		end
	end
end

local function vmt_bind(module, interface, index, typestring)
	local instance = client.create_interface(module, interface) or error("invalid interface")
	local fnptr = vmt_entry(instance, index, ffi.typeof(typestring)) or error("invalid vtable")
	return function(...)
		return fnptr(instance, ...)
	end
end

local new_charbuf = ffi.typeof("char[?]")

local native_GetISteamUtils = vmt_bind("steamclient.dll", "SteamClient017", 9, "uintptr_t*(__thiscall*)(void*, int, const char*)")
local native_ISteamUtils_FilterText = vmt_thunk(32, "int(__thiscall*)(void*, char*, uint32_t, const char*, bool)")

local ISteamUtils = native_GetISteamUtils(1, "SteamUtils009")

if ISteamUtils == nil then
	return error("failed to get ISteamUtils")
end

local function filter_text(text, legal_only)
	local size = text:len() + 1
	local pchOutFilteredText = new_charbuf(size)
	local nCharsFiltered = native_ISteamUtils_FilterText(ISteamUtils, pchOutFilteredText, size, text, legal_only)

	return ffi.string(pchOutFilteredText, size-1), nCharsFiltered
end

local bypassFilter = ui.new_checkbox('LUA', 'B', 'Bypass Chat Filter')

local alphabet = {
	['a'] = 'ȧ',
	['A'] = 'Ȧ',
	['b'] = 'ḃ',
	['B'] = 'Ḃ',
	['c'] = 'ċ',
	['C'] = 'Ċ',
	['d'] = 'ḍ',
	['D'] = 'Ḍ',
	['e'] = 'ẹ',
	['E'] = 'Ẹ',
	['f'] = 'ḟ',
	['F'] = 'Ḟ',
	['g'] = 'ġ',
	['G'] = 'Ġ',
	['h'] = 'ḥ',
	['H'] = 'Ḥ',
	['i'] = 'į',
	['I'] = 'Į',
	['j'] = 'ĵ',
	['J'] = 'Ĵ',
	['k'] = 'ḳ',
	['K'] = 'Ḳ',
	['l'] = 'ḷ',
	['L'] = 'Ḷ',
	['m'] = 'ṃ',
	['M'] = 'Ṃ',
	['n'] = 'ṇ',
	['N'] = 'Ṇ',
	['o'] = 'ȯ',
	['O'] = 'Ȯ',
	['p'] = 'ṗ',
	['P'] = 'Ṗ',
	['q'] = 'ɋ',
	['Q'] = 'Ɋ',
	['r'] = 'ṛ',
	['R'] = 'Ṛ',
	['s'] = 'ṣ',
	['S'] = 'Ṣ',
	['t'] = 'ṭ',
	['T'] = 'Ṭ',
	['u'] = 'ụ',
	['U'] = 'Ụ',
	['v'] = 'ṿ',
	['V'] = 'Ṿ',
	['w'] = 'ẉ',
	['W'] = 'Ẉ',
	['x'] = 'ẋ',
	['X'] = 'Ẋ',
	['y'] = 'ỵ',
	['Y'] = 'Ỵ',
	['z'] = 'ẓ',
	['Z'] = 'Ẓ',
}

local cache = {
	open = panorama.open,
	format = string.format
}

local Panorama = {
	MyPersonaAPI = cache.open().MyPersonaAPI,
	PartyListAPI = cache.open().PartyListAPI
}

local NoBreakSpace = '\u{00A0}'

local StringExplode = function(separator, str)
	local ret = {}
	local currentPos = 1

	for i = 1, #str do
		local startPos, endPos = string.find(str, separator, currentPos)
		if ( not startPos ) then break end
		ret[ i ] = string.sub( str, currentPos, startPos - 1 )
		currentPos = endPos + 1
	end

	ret[#ret + 1] = string.sub( str, currentPos )

	return ret
end

local PartyChatSay = function(text)
	local newMessage = {}

	for word in text:gmatch('[^%s]+') do
		local text_filtered, characters_filtered = filter_text(word, false)

		if (characters_filtered > 0 and word:len() > 1) then
			local letter = word:sub(3, 3)
			letter = alphabet[letter] or letter

			word = word:sub(1, 2) .. letter .. word:sub(4, -1)
		end

		table.insert(newMessage, word)
	end

	Panorama.PartyListAPI.SessionCommand('Game::Chat', cache.format('run all xuid %s chat %s', Panorama.MyPersonaAPI.GetXuid(), table.concat(newMessage, NoBreakSpace)))
end

client.set_event_callback('console_input', function(text)
	if (text:sub(1, #'party_say') == 'party_say') then
		text = text:sub(#'party_say' + 2, -1)

		PartyChatSay(text)
		return true
	end
end)

client.set_event_callback('string_cmd', function(e)
	local text = e.text
	local command, message = text:match('^(.-) (.*)$')

	if ((command == 'say' or command == 'say_team') and message ~= nil and message ~= '') then
		local newMessage = {}

		if (message:find('"', 1) and message:find('"', -1)) then
			message = message:sub(2, -2)
		end

		for word in message:gmatch('[^%s]+') do
			local text_filtered, characters_filtered = filter_text(word, false)

			if (ui.get(bypassFilter) and characters_filtered > 0 and word:len() > 1) then
				local letterCount = word:len() > 2 and 3 or 2
				local letter = word:sub(letterCount, letterCount)
				letter = alphabet[letter] or letter

				word = word:sub(1, letterCount - 1) .. letter .. word:sub(letterCount + 1, -1)
			end

			table.insert(newMessage, word)
		end

        e.text = command .. ' ' .. table.concat(newMessage, " ")
	end
end)