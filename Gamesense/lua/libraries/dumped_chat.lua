slot0 = require("ffi")
slot1 = string.gsub
slot2 = pairs
slot3 = {
	["{darkred}"] = "",
	[" "] = "",
	["{white}"] = "",
	["‮"] = "",
	["{orange}"] = "",
	["%%"] = "%%%%",
	["{lightred}"] = "",
	["{violet}"] = "",
	["{purple}"] = "\r",
	["{darkblue}"] = "",
	["{blue}"] = "",
	["{bluegrey}"] = "\n",
	["{yellow}"] = "\t",
	["{grey}"] = "",
	["{red}"] = "",
	["{lime}"] = "",
	["{lightgreen}"] = "",
	["{green}"] = "",
	["{team}"] = "",
	["  +"] = function (slot0)
		return " " .. (" "):rep(slot0:len() - 1)
	end
}

function slot4(slot0, slot1, slot2, slot3, slot4)
	if slot3 ~= nil and slot3 ~= 0 then
		slot6 = uv0.cast("uintptr_t", client.find_signature(slot0, slot1) or error("signature not found", 2)) + slot3
	end

	if slot4 ~= nil then
		for slot10 = 1, slot4 do
			if uv0.cast("uintptr_t*", slot6)[0] == nil then
				return error("signature not found", 2)
			end
		end
	end

	return uv0.cast(slot2, slot6)
end

function slot5(slot0, slot1)
	for slot6 = 1, #slot0 do
		slot2 = "" .. tostring(slot0[slot6]) .. (slot6 == #slot0 and "" or slot1)
	end

	return slot2
end

slot8 = vtable_thunk(27, "void(__cdecl*)(void*, int, int, const char*, ...)")

if slot4("client.dll", "U\\x8b\\xecS\\x8b]VW\\x8b\\xf93\\xf69w(", "void***(__thiscall*)(void*, const char*)")(slot4("client.dll", "\\xb9\\xcc\\xcc\\xcc̈F\t", "void*", 1, 1), "CHudChat") == nil then
	error("CHudChat not found")
end

if slot7(slot6, "CCSGO_HudChat") == nil then
	error("CCSGO_HudChat not found")
end

slot11 = slot0.cast("bool*", slot10) + 88

return {
	print = function (...)
		return uv0(0, ...)
	end,
	print_player = function (slot0, ...)
		for slot5, slot6 in uv1(uv2) do
			slot1 = uv3(uv0(slot0 == 0 and {
				" ",
				...
			} or {
				...
			}, ""), slot5, slot6)
		end

		uv4(uv5, slot0, 0, slot1)
	end,
	is_open = function ()
		return uv0[0]
	end
}
