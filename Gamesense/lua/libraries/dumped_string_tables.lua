slot0 = require("ffi")
slot1 = -1
slot2 = vtable_bind("engine.dll", "VEngineClientStringTable001", 3, "void*(__thiscall*)(void*, const char*)")
slot3 = vtable_bind("engine.dll", "VEngineClientStringTable001", 4, "void*(__thiscall*)(void*, int)")
slot4 = vtable_bind("engine.dll", "VEngineClientStringTable001", 5, "int(__thiscall*)(void*)")
slot5 = vtable_bind("engine.dll", "VEngineClientStringTable001", 6, "void(__thiscall*)(void*, void*, bool)")
slot6 = vtable_thunk(1, "const char*(__thiscall*)(void*)")
slot7 = vtable_thunk(2, "int(__thiscall*)(void*)")
slot8 = vtable_thunk(3, "int(__thiscall*)(void*)")
slot9 = vtable_thunk(4, "int(__thiscall*)(void*)")
slot10 = vtable_thunk(8, "int(__thiscall*)(void*, bool, const char*, int, const void*)")
slot11 = vtable_thunk(9, "const char*(__thiscall*)(void*, int)")
slot12 = vtable_thunk(10, "const char*(__thiscall*)(void*, int, int, const void*)")
slot13 = vtable_thunk(11, "const void*(__thiscall*)(void*, int, int*)")
slot14 = vtable_thunk(12, "int(__thiscall*)(void*, const char*)")

function slot15(slot0, slot1)
	if slot0 ~= nil then
		if type(slot0) == "string" then
			slot0 = uv0.new("char[?]", slot0:len(), slot0)
		end
	else
		slot1 = -1
	end

	return slot0, slot1
end

slot16 = {
	name = function (slot0)
		if uv0(slot0) ~= nil then
			return uv1.string(slot1)
		end
	end,
	id = function (slot0)
		return uv0(slot0)
	end,
	size = function (slot0)
		return uv0(slot0)
	end,
	max_size = function (slot0)
		return uv0(slot0)
	end,
	add = function (slot0, slot1, slot2, slot3)
		slot4, slot5 = uv0(slot2, slot3)

		return uv1(slot0, false, slot1, slot5, slot4)
	end,
	get = function (slot0, slot1)
		if slot1 > #slot0 then
			return
		end

		if uv0(slot0, slot1) ~= nil then
			return uv1.string(slot2)
		end
	end,
	get_user_data = function (slot0, slot1)
		if slot0:get(slot1) == nil then
			return
		end

		if uv1(slot0, slot1, uv0.new("int[1]")) ~= nil then
			return slot3, slot2[0]
		end
	end,
	set_user_data = function (slot0, slot1, slot2, slot3)
		slot4, slot5 = uv0(slot2, slot3)

		return uv1(slot0, slot1, slot5, slot4)
	end,
	find = function (slot0, slot1)
		if uv0(slot0, slot1) ~= uv1 then
			return slot2
		end
	end
}

function slot17(slot0, slot1)
	if slot0[slot1 + 1] ~= nil then
		return slot1, slot2
	end
end

slot19 = slot0.typeof("$*", slot0.metatype("struct {}", {
	__index = function (slot0, slot1)
		if type(slot1) == "number" then
			return uv0.get(slot0, slot1)
		end

		return uv0[slot1]
	end,
	__tostring = function (slot0)
		return string.format("<string table \"%s\">", uv0.name(slot0))
	end,
	__len = function (slot0)
		return uv0.size(slot0)
	end,
	__pairs = function (slot0)
		return uv0, slot0, 0
	end,
	__ipairs = function (slot0)
		return uv0, slot0, 0
	end
}))

function slot20(slot0)
	if uv0(slot0) ~= nil then
		return uv1.cast(uv2, slot1)[0]
	end
end

return setmetatable({
	get_all = function ()
		slot0 = {}

		for slot4 = 0, uv0() - 1 do
			if uv1(slot4) ~= nil then
				table.insert(slot0, uv2.cast(uv3, slot5)[0])
			end
		end

		return slot0
	end
}, {
	__metatable = false,
	__index = function (slot0, slot1)
		if type(slot1) ~= "string" then
			return
		end

		return uv0(slot1)
	end
})
