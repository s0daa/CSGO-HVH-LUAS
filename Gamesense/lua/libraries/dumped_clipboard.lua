slot0 = require("ffi")
slot1 = string.len
slot2 = tostring
slot3 = slot0.string
slot4 = {
	get = function ()
		if uv0() > 0 then
			slot1 = uv1(slot0)

			uv2(0, slot1, slot0)

			return uv3(slot1, slot0 - 1)
		end
	end
}
slot5 = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
slot6 = vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
slot7 = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")
slot8 = slot0.typeof("char[?]")
slot4.paste = slot4.get

function slot4.set(slot0)
	slot0 = uv0(slot0)

	uv1(slot0, uv2(slot0))
end

slot4.copy = slot4.set

return slot4
