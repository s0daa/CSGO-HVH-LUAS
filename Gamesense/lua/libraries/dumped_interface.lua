slot0 = require("ffi")
slot1 = client.find_signature("gameoverlayrenderer.dll", "\\xff\\xe1") or error("invalid signature #1", 2)
slot5 = slot0.cast("void***", slot0.cast("char*", client.find_signature("gameoverlayrenderer.dll", "\\xff\\xcc\\xcc\\xcc\\xccP\\x8bU") or error("invalid signature #2", 2)) + 2)[0][0]
slot6 = slot0.cast("void***", slot0.cast("char*", client.find_signature("gameoverlayrenderer.dll", "\\xff\\xcc\\xcc\\xcc̅\\xc0\\x84\\xcc\\xcc\\xcc\\xcc9") or error("invalid signature #3", 3)) + 2)[0][0]
slot7 = slot0.cast("void***", slot0.cast("char*", client.find_signature("gameoverlayrenderer.dll", "\\xff\\xcc\\xcc\\xcc̅\\xc0t=\\xcc\\xcc\\xcc\\xccr") or error("invalid signature #4", 4)) + 2)[0][0]
slot8 = slot0.cast("unsigned int(__fastcall*)(void*, void*)", slot1)
slot9 = slot0.cast("int(__fastcall*)(void*, void*, unsigned int, const char*, void*)", slot1)
slot10 = slot0.cast("unsigned int(__fastcall*)(void*, void*, void*, const char*, unsigned int)", slot1)

function slot11()
	return uv0(uv1, nil)
end

function slot12(slot0, slot1)
	if uv1(uv2, nil, slot0, slot1, uv0.new("unsigned int[1]")) == 0 then
		return error(string.format("error #1: 0x%.4x", uv3()))
	end

	return uv0.cast("void*", slot2[0])
end

function slot13(slot0)
	if uv1(uv2, nil, slot0, uv0.new("char[260]"), 260) == 0 then
		return error(string.format("error #2: 0x%.4x", uv3()))
	end

	return uv0.string(slot1)
end

slot14 = bit.bor(2, 4)

return function (slot0, slot1)
	slot2 = slot0

	if type(slot0) == "string" then
		slot2 = client.create_interface(slot0, slot1) or error("invalid interface", 2)
	end

	return uv2.cast(uv2.typeof("$ *", uv2.metatype("struct { void** vtbl; }", {
		__index = {},
		__newindex = function (slot0, slot1, slot2)
			slot3 = nil

			if type(slot2[1]) == "number" then
				slot3 = slot0.vtbl[slot4]
			elseif type(slot4) == "string" then
				slot3 = client.find_signature(string.match(uv3(uv0(uv1, uv2.cast("void*", slot0))), "%w+.dll"), slot4) or error("invalid signature for " .. slot1, 2)
			end

			if slot3 == nil then
				return error("invalid index or signature", 2)
			end

			slot5, slot6 = pcall(uv2.typeof, select(2, unpack(slot2)))

			if slot5 == false then
				return error(slot6, 2)
			end

			slot7 = uv2.cast(slot6, slot3) or error("invalid typecast", 2)

			uv4.__index[slot1] = function (...)
				return uv0(uv1, ...)
			end
		end
	})), slot2)
end
