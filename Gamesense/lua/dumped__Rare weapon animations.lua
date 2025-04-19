slot0 = bit.band
slot1 = entity.get_local_player
slot2 = entity.get_prop
slot3 = entity.is_alive
slot4 = entity.set_prop
slot5 = pairs
slot6 = ui.get
slot10 = require("gamesense/csgo_weapons")
slot11 = require("table.clear")

function slot13(slot0)
	for slot5 = 1, #slot0 do
	end

	return {
		[slot0[slot5]] = slot5
	}
end

slot15 = {}
slot17 = ui.new_multiselect("SKINS", "Model options", "\nActive rare animations", function (slot0, slot1)
	for slot6, slot7 in uv0(slot0) do
		-- Nothing
	end

	return {
		[slot6] = slot1(slot7)
	}
end({
	{
		weapon = slot10.weapon_knife_butterfly,
		overrides = {
			0,
			[13.0] = 15,
			[14.0] = 15
		}
	},
	{
		weapon = slot10.weapon_knife_falchion,
		overrides = {
			[12.0] = 13
		}
	},
	{
		weapon = slot10.weapon_knife_ursus,
		overrides = {
			[0] = 1,
			[14.0] = 13
		}
	},
	{
		weapon = slot10.weapon_knife_stiletto,
		overrides = {
			[13.0] = 12
		}
	},
	{
		weapon = slot10.weapon_knife_widowmaker,
		overrides = {
			[14.0] = 15
		}
	},
	{
		weapon = slot10.weapon_knife_skeleton,
		overrides = {
			[0] = 1,
			[13.0] = 14
		}
	},
	{
		weapon = slot10.weapon_knife_canis,
		overrides = {
			[0] = 1,
			[14.0] = 13
		}
	},
	{
		weapon = slot10.weapon_knife_cord,
		overrides = {
			[0] = 1,
			[14.0] = 13
		}
	},
	{
		weapon = slot10.weapon_knife_outdoor,
		overrides = {
			[14.0] = 13
		},
		overrides_durations = {
			[1.0] = 4
		}
	},
	{
		weapon = slot10.weapon_deagle,
		overrides = {
			[7.0] = 8
		}
	},
	{
		weapon = slot10.weapon_revolver,
		overrides = {
			[3.0] = 4
		}
	}
}, function (slot0)
	return slot0.name or slot0.weapon.name
end))

ui.set_visible(slot17, false)
ui.set_callback(ui.new_checkbox("SKINS", "Model options", "Rare weapon animations"), function ()
	uv0(uv1, uv2(uv3))
end)
ui.set_callback(slot17, function ()
	uv0(uv1)

	for slot4 = 1, #uv5 do
		if uv2(uv3(uv4))[uv5[slot4].name or slot5.weapon.name] ~= nil then
			uv1[slot6] = uv1[slot5.weapon.idx] or {}

			for slot10, slot11 in uv6(slot5.overrides) do
				uv1[slot6][slot10] = slot11
			end
		end
	end
end)
client.set_event_callback("net_update_start", function ()
	if not uv0(uv1) then
		return
	end

	if uv2() == nil or not uv3(slot0) then
		return
	end

	if uv4(slot0, "m_hViewModel[0]") == nil then
		return
	end

	if uv4(slot1, "m_hWeapon") == nil then
		return
	end

	if uv6[uv5(uv4(slot2, "m_iItemDefinitionIndex") or 0, 65535)] ~= nil and slot4[uv4(slot1, "m_nSequence")] ~= nil then
		uv7(slot1, "m_nSequence", slot4[slot5])
	end
end)
