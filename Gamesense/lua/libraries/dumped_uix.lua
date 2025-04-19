slot0 = setmetatable
slot1 = error
slot2 = client.set_event_callback
slot3 = client.unset_event_callback
slot4 = ui.get
slot5 = ui.new_checkbox
slot6 = pairs
slot7 = ui.set
slot8 = ui.set_callback
slot9 = ui.set_visible
slot10 = 0
slot11 = 1
slot12 = 2
slot13 = {}
slot14 = {}
slot15, slot16 = nil

function slot17(slot0)
	return uv0[slot0] or uv1("invalid object", 3)
end

function slot18(slot0)
	return uv0[slot0] or uv1("invalid reference", 2)
end

function slot19(slot0)
	slot1 = {
		[uv2] = slot0,
		[uv3] = {}
	}
	slot2 = uv0({}, uv1)
	uv4[slot2] = slot1
	uv5[slot0] = slot1

	return slot2
end

function slot21(slot0)
	if uv1(slot0)[uv2] then
		slot3(slot0, uv0(slot0))
	end

	if slot2[uv3] then
		for slot9, slot10 in uv6(slot4) do
			slot1 and uv4 or uv5(slot9, slot10)
		end
	end
end

function slot22(slot0, slot1, slot2)
	if slot1 == "change" then
		uv0(slot0)[uv1] = slot2
	else
		slot3[uv2][slot1] = slot2
	end

	uv3(slot3[uv4])
	uv5(slot3[uv4], uv3)
end

function slot23(slot0)
	uv1(uv0(slot0)[uv2], false)
end

function slot24(slot0)
	uv1(uv0(slot0)[uv2], true)
end

function slot25(slot0)
	return uv1(uv0(slot0)[uv2])
end

function slot26(slot0, slot1)
	uv1(uv0(slot0)[uv2], slot1)
end

function ()
	uv0 = {
		on = uv1,
		hide = uv2,
		show = uv3,
		get = uv4,
		set = uv5
	}
	uv6 = {
		__index = uv0
	}
end()

return {
	new_checkbox = function (...)
		if uv0(...) then
			return uv2(uv1(slot0), uv3)
		end
	end
}
