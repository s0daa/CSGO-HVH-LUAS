slot0 = {
	checkbox = ui.new_checkbox,
	slider = ui.new_slider,
	multiselect = ui.new_multiselect,
	combobox = ui.new_combobox,
	label = ui.new_label,
	textbox = ui.new_textbox,
	color_picker = ui.new_color_picker,
	hotkey = ui.new_hotkey,
	set = ui.set,
	get = ui.get,
	ref = ui.reference,
	callback = ui.set_callback,
	visible = ui.set_visible
}
slot1 = {
	_debug = false,
	menu = {
		"config",
		"Presets"
	},
	groups = {
		awp = {
			9
		},
		auto = {
			11,
			38
		},
		scout = {
			40
		},
		revolver = {
			64
		},
		deagle = {
			1
		},
		pistol = {
			2,
			3,
			4,
			30,
			32,
			36,
			61,
			63
		},
		rifle = {
			7,
			8,
			10,
			13,
			16,
			39,
			60
		},
		smg = {
			17,
			19,
			24,
			26,
			33,
			34
		},
		heavy = {
			14,
			28
		},
		shotgun = {
			25,
			27,
			29,
			35
		}
	},
	call = function (slot0, slot1, slot2, ...)
		if slot1 == nil then
			return
		end

		slot3 = slot2[2] or ""

		if slot2[1] ~= nil then
			if slot3 ~= "" then
				slot3 = slot3 .. " " or slot3
			end

			slot3 = slot3 .. "\n " .. slot2[1]
		end

		return slot1(slot0.menu[1], slot0.menu[2], slot3, ...)
	end
}
slot2, slot3, slot4, slot5 = nil

function slot6(slot0, slot1)
	for slot5 = 1, #slot0 do
		if slot0[slot5] == slot1 then
			return true
		end
	end

	return false
end

function slot7(slot0, slot1)
	if slot0 == nil then
		return false
	end

	for slot5, slot6 in pairs(slot1) do
		slot0(slot5, slot6)
	end
end

function slot8(slot0)
	return slot0:gsub("^%l", string.upper)
end

function slot10(slot0)
	for slot4, slot5 in pairs(uv0.groups) do
		if uv1(slot5, slot0) then
			return uv2(slot4)
		end
	end

	return false
end

function slot11(slot0)
	return bit.band(65535, entity.get_prop(entity.get_player_weapon(slot0), "m_iItemDefinitionIndex"))
end

function slot12(slot0)
	if slot0 > 40 and slot0 < 50 or slot0 > 499 and slot0 < 524 or slot0 == 31 then
		return true
	end
end

slot13 = slot0.label(slot1.menu[1], slot1.menu[2], "-------------------------------------------------")
slot15 = slot1:call(slot0.label, {
	"rcl_active_lbl",
	"Active preset:"
})
slot16 = slot1:call(slot0.label, {
	"rcl_prefix_lbl",
	"Preset name prefix"
})
slot17 = slot1:call(slot0.textbox, {
	"rcl_prefix",
	"preset_name_prefix"
})
slot18 = slot1:call(slot0.multiselect, {
	"rcl_selected",
	"Selected weapon groups"
}, function (slot0)
	slot1 = {
		[slot2] = uv0(slot6)
	}
	slot2 = 1

	for slot6, slot7 in pairs(slot0) do
		slot2 = slot2 + 1
	end

	table.sort(slot1)

	return slot1
end(slot1.groups))
slot20 = slot1:call(slot0.color_picker, {
	"rcl_indicator_color",
	"indicator_color"
}, 123, 193, 21, 255)

function slot21(slot0)
	slot1 = string.format("%s%s", uv0.get(uv1), slot0)

	config.load(slot1)

	uv5 = slot1

	uv0.set(uv6, string.format("Active preset: %s", slot1))
	uv7(uv0.set, {
		[uv2] = uv0.get(uv2),
		[uv1] = uv0.get(uv1),
		[uv3] = uv0.get(uv3),
		[uv4] = uv0.get(uv4)
	})
end

function slot22(slot0)
	if uv0(slot0) then
		return
	end

	if not uv4(uv2.get(uv3), uv5(uv1(slot0))) then
		slot1 = "global"
	end

	if uv4(slot2, uv5(slot1)) and slot1 ~= "global" then
		uv6 = string.lower(slot1)
	else
		uv6 = "global"
	end

	uv7(uv6)
end

function slot23(slot0)
	if not entity.is_alive(entity.get_local_player()) then
		return
	end

	if uv0(slot1) == uv1 then
		return
	end

	uv1 = uv0(slot1)

	uv2(uv1)
end

function slot24()
	if not uv0.get(uv1) then
		return
	end

	if not uv2 then
		return
	end

	slot0, slot1, slot2, slot3 = uv0.get(uv3)

	renderer.indicator(slot0, slot1, slot2, slot3, string.upper(uv2))
end

function slot26()
	uv2()

	slot1 = not uv0.get(uv1) and client.set_event_callback or client.unset_event_callback

	slot1("net_update_end", uv3)
	slot1("paint", uv4)
end

slot26()
slot0.callback(slot1:call(slot0.checkbox, {
	"rcl_disabled",
	"Disable weapon based preset loading"
}), slot26)
slot0.callback(slot1:call(slot0.checkbox, {
	"rcl_indicator",
	"Indicate current preset name"
}), function ()
	slot0 = not uv0.get(uv1)

	uv2(uv0.visible, {
		[uv3] = slot0,
		[uv4] = slot0,
		[uv5] = slot0,
		[uv6] = slot0,
		[uv7] = slot0,
		[uv8] = slot0
	})
end)
