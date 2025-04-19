slot1 = require("ffi")
slot2 = ui.get
slot3 = ui.set
slot4 = ui.set_visible
slot5 = ui.set_callback
slot7 = ui.new_color_picker
slot8 = ui.new_slider
slot10 = ui.reference
slot12 = client.screen_size
slot13 = client.set_event_callback
slot14 = client.unset_event_callback
slot15 = entity.get_local_player
slot16 = entity.get_player_weapon
slot17 = entity.get_prop
slot18 = entity.is_alive
slot19 = renderer.gradient
slot20 = globals.frametime
slot21 = math.min
slot22 = math.max
slot23 = math.pi
slot24 = slot1.cdef
slot25 = slot1.typeof
slot26 = slot1.cast
slot29 = slot26(slot25("void*(__thiscall*)(void*, int)"), (slot26(slot25("void***"), client.create_interface("client.dll", "VClientEntityList003") or error("VClientEntityList003 not found.", 2)) or error("raw_iEntityList is nil", 2))[0][3]) or error("native_getClientEntity is nil", 2)
slot30 = vtable_thunk(453, "float(__thiscall*)(void*)")
slot31 = vtable_thunk(483, "float(__thiscall*)(void*)")
slot32 = require("vector")()
slot33, slot34, slot35 = nil
slot36 = 0
slot37 = "visuals"
slot38 = "effects"
slot39 = {
	enabled = ui.new_checkbox(slot37, slot38, "Custom scope lines"),
	color = slot7(slot37, slot38, "\n scope_lines_color_picker", 0, 0, 0, 190),
	color2 = slot7(slot37, slot38, "\n scope_lines_color_picker2", 0, 0, 0, 0),
	options = ui.new_multiselect(slot37, slot38, "\n scope_options", {
		"Dynamic offset",
		"Remove top line",
		"Disable animation"
	}),
	size = slot8(slot37, slot38, "\n scope_lines_initial_pos", 0, 500, 190),
	offset = slot8(slot37, slot38, "\n scope_lines_offset", 0, 500, 10),
	thickness = slot8(slot37, slot38, "\n scope_lines_thickness", 1, 10, 1, true, "px"),
	fade = slot8(slot37, slot38, "Fade animation speed", 3, 20, 12, true, "fr", 1, {
		[3.0] = "Off"
	}),
	scope_ovr = slot10(slot37, slot38, "Remove scope overlay"),
	fov = slot10("misc", "miscellaneous", "override fov")
}

function slot40(slot0, slot1, slot2)
	return uv0(slot1, uv1(slot2, slot0))
end

function slot41(slot0, slot1)
	for slot5, slot6 in pairs(slot0) do
		if slot6 == slot1 then
			return true
		end
	end

	return false
end

slot42 = {
	paint_ui = function ()
		uv0(uv1.scope_ovr, true)
	end,
	paint = function ()
		uv0(uv1.scope_ovr, false)

		uv2.x, uv2.y = uv3()
		slot0 = uv4(uv1.offset) * uv2.y / 1080
		slot1 = uv4(uv1.size) * uv2.y / 1080
		slot2 = uv4(uv1.fade)
		slot3 = uv4(uv1.thickness)
		slot4 = {
			uv4(uv1.color)
		}
		slot5 = {
			uv4(uv1.color2)
		}

		if uv5() == nil then
			return
		end

		if uv6(slot6) == nil then
			return
		end

		if uv7 and uv8(uv9, slot7) ~= nil then
			slot11 = (uv11(slot8) + uv10(slot8)) * 360
			slot1 = slot1 + slot11
			slot0 = slot0 + slot11
		end

		slot8 = uv12(slot7, "m_zoomLevel")
		slot12 = uv13(slot6) and slot7 ~= nil and slot8 ~= nil and slot8 > 0 and uv12(slot6, "m_bIsScoped") == 1 and not (uv12(slot6, "m_bResumeZoom") == 1)
		slot13 = slot2 > 3 and uv14() * slot2 or 1
		slot14 = uv2.x * 0.5
		slot15 = uv2.y * 0.5
		slot16 = slot3 > 1 and slot3 * 0.5 or 0

		if not uv15 then
			slot0 = slot0 + slot1 * (1 - uv16)
			slot1 = slot1 * uv16
		end

		if uv16 > 0 then
			uv17(slot14 - slot1 + 2, slot15 - slot16, slot1 - slot0, slot3, slot5[1], slot5[2], slot5[3], slot5[4] * uv16, slot4[1], slot4[2], slot4[3], slot4[4] * uv16, true)
			uv17(slot14 + slot0, slot15 - slot16, slot1 - slot0, slot3, slot4[1], slot4[2], slot4[3], slot4[4] * uv16, slot5[1], slot5[2], slot5[3], slot5[4] * uv16, true)

			if not uv18 then
				uv17(slot14 - slot16, slot15 - slot1 + 2, slot3, slot1 - slot0, slot5[1], slot5[2], slot5[3], slot5[4] * uv16, slot4[1], slot4[2], slot4[3], slot4[4] * uv16, false)
			end

			uv17(slot14 - slot16, slot15 + slot0, slot3, slot1 - slot0, slot4[1], slot4[2], slot4[3], slot4[4] * uv16, slot5[1], slot5[2], slot5[3], slot5[4] * uv16, false)
		end

		uv16 = uv19(uv16 + (slot12 and slot13 or -slot13), 0, 1)
	end,
	shutdown = function ()
		uv0(uv1.scope_ovr, true)
		uv2(uv1.scope_ovr, true)
	end
}

function slot43()
	slot1 = uv0(uv1.enabled) and uv2 or uv3

	if not slot0 then
		uv4 = 0
	end

	slot2 = uv0(uv1.options)
	slot6 = slot2
	slot7 = "Disable animation"
	uv7 = uv8(slot6, slot7)
	uv6 = uv8(slot2, "Remove top line")
	uv5 = uv8(slot2, "Dynamic offset")

	uv9(uv1.scope_ovr, not slot0)
	uv9(uv1.color2, slot0)
	uv9(uv1.options, slot0)
	uv9(uv1.size, slot0)
	uv9(uv1.offset, slot0)
	uv9(uv1.thickness, slot0)
	uv9(uv1.fade, slot0)

	for slot6, slot7 in pairs(uv10) do
		slot1(slot6, slot7)
	end
end

slot5(slot39.enabled, slot43)
slot43()
slot5(slot39.options, slot43)
