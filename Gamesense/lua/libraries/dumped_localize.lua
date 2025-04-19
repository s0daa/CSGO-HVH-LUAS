slot0 = require("ffi")
slot1 = slot0.cast
slot2 = slot0.string
slot3 = json.stringify
slot5 = slot0.typeof("char[?]")
slot6 = slot0.typeof("uint16_t*")
slot7 = vtable_bind("localize.dll", "Localize_001", 16, "int(__thiscall*)(void*, const unsigned char*, char*, int)")
slot8 = vtable_bind("localize.dll", "Localize_001", 11, "unsigned char*(__thiscall*)(void*, const char*)")

function slot9(slot0)
	slot1 = 0

	while uv0("wchar_t*", slot0)[slot1] ~= 0 do
		slot1 = slot1 + 1
	end

	return slot1 + 1
end

function slot10(slot0)
	if uv0(slot0) == nil then
		return slot0
	end

	slot2 = uv1(slot1)

	if uv3(slot1, uv2(slot2), slot2) < 2 then
		return ""
	end

	return slot3 and uv4(slot3, slot4 - 1) or nil
end

slot12 = {}

function slot14(slot0, slot1)
	if slot0 == nil then
		return ""
	end

	if uv0[slot0] == nil then
		uv0[slot0] = {}
	end

	if slot2[slot1 ~= nil and uv1(slot1) or true] == nil then
		slot2[slot4] = slot3 and uv2.localize(slot0, slot1) or uv3(slot0)
	end

	return slot2[slot4]
end

if panorama.loadstring([[
	return {
		localize: (str, params) => {
			if(params == null)
				return $.Localize(str)

			var panel = $.CreatePanel("Panel", $.GetContextPanel(), "")

			for(key in params) {
				panel.SetDialogVariable(key, params[key])
			}

			var result = $.Localize(str, panel)

			panel.DeleteAsync(0.0)

			return result
		},
		language: () => {
			return $.Language()
		}
	}
]])().language() ~= "english" then
	function slot14(slot0, ...)
		return uv0("#[english]" .. slot0:sub(2, -1))
	end
end

return setmetatable({
	localize = slot13,
	localize_english = slot14,
	language = function ()
		return uv0
	end
}, {
	__call = function (slot0, ...)
		return uv0(...)
	end
})
