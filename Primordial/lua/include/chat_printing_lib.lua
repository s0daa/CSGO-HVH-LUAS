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
	["{orange}"] = "\x10"
}

local function FindSig(mod, pat, type, offset, deref_count)
	local raw_match = memory.find_pattern(mod, pat) or error("signature not found", 2)
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

	return ffi.cast(type, match)
end

local function tbl_concat_string(tbl, sep)
	local result = ""
	for i=1, #tbl do
		result = result .. tostring(tbl[i]) .. (i == #tbl and "" or sep)
	end
	return result
end

local FindHudElement = FindSig("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28", "void***(__thiscall*)(void*, const char*)")
local hud = FindSig("client.dll", "B9 ?? ?? ?? ?? 88 46 09", "void*", 1, 1)
local hud_chat = FindHudElement(hud, "CHudChat")
local class_ptr = ffi.cast("void***",hud_chat)
local ChatPrintf = ffi.cast("void(__cdecl*)(void*, int, int, const char*, ...)", memory.get_vfunc(tonumber(ffi.cast("unsigned long", class_ptr)), 27))

local function print_player(entindex, ...)
	local text = tbl_concat_string(entindex == 0 and {" ", ...} or {...}, "")

	for res, rep in pairs(replacements) do
		text = string.gsub(text, res, rep)
	end

	ChatPrintf(class_ptr, entindex, 0, text)
end

return {
	print = function(...)
		return print_player(0, ...)
	end,
	print_player = print_player
}