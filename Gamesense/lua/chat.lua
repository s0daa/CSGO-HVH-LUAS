local ffi = require "ffi"
local gsub, pairs = string.gsub, pairs

local replacements = {
	["{white}"] = "\x01",
	["{darkred}"] = "\x02",
	["{team}"] = "\x03",
	["{green}"] = "\x04",
	["{lightgreen}"] = "\x05",
	["{lime}"] = "\x06",
	["{red}"] = "\x07",
	["{grey}"] = "\x08",
	["{yellow}"] = "\x09",
	["{bluegrey}"] = "\x0A",
	["{blue}"] = "\x0B",
	["{darkblue}"] = "\x0C",
	["{purple}"] = "\x0D",
	["{violet}"] = "\x0E",
	["{lightred}"] = "\x0F",
	["{orange}"] = "\x10",
	["\u{202E}"] = "",
	["\u{2029}"] = "",
	["  +"] = function(c)
		return " " .. ("\x18 "):rep(c:len()-1)
	end
}

local function find_sig(mdlname, pattern, typename, offset, deref_count)
	local raw_match = client.find_signature(mdlname, pattern) or error("signature not found", 2)
	local match = ffi.cast("uintptr_t", raw_match)

	if offset ~= nil and offset ~= 0 then
		match = match + offset
	end

	if deref_count ~= nil then
		for i = 1, deref_count do
			match = ffi.cast("uintptr_t*", match)[0]
			if match == nil then
				return error("signature not found", 2)
			end
		end
	end

	return ffi.cast(typename, match)
end

local function table_concat_tostring(tbl, sep)
	local result = ""
	for i=1, #tbl do
		result = result .. tostring(tbl[i]) .. (i == #tbl and "" or sep)
	end
	return result
end

local hud = find_sig("client.dll", "\xB9\xCC\xCC\xCC\xCC\x88\x46\x09", "void*", 1, 1)

local native_FindHudElement = find_sig("client.dll", "\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x57\x8B\xF9\x33\xF6\x39\x77\x28", "void***(__thiscall*)(void*, const char*)")
local native_ChatPrintf = vtable_thunk(27, "void(__cdecl*)(void*, int, int, const char*, ...)")

-- thisptr for native_ChatPrintf
local hud_chat = native_FindHudElement(hud, "CHudChat")

local function print_player(entindex, ...)
	local text = table_concat_tostring(entindex == 0 and {" ", ...} or {...}, "")

	for res, rep in pairs(replacements) do
		text = gsub(text, res, rep)
	end

	native_ChatPrintf(hud_chat, entindex, 0, text)
end

return {
	print = function(...)
		return print_player(0, ...)
	end,
	print_player = print_player
}