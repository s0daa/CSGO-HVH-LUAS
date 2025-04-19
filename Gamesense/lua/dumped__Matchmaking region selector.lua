slot0 = require("ffi")
slot1 = require("gamesense/steamworks")
slot2 = require("gamesense/http")

if type(database.read("server_picker")) ~= "table" then
	slot3 = {}
end

if slot3.active_datacenter ~= nil then
	slot3.active_datacenters = slot3.active_datacenters or {
		slot3.active_datacenter
	}
	slot3.active_datacenter = nil
end

if type(slot3.active_datacenters) ~= "table" then
	slot3.active_datacenters = {}
end

slot4 = slot1.ISteamNetworkingUtils

function slot5(slot0)
	slot1 = uv0.cast("const char*", uv0.new("unsigned int[1]", slot0))

	return string.char(slot1[2]) .. string.char(slot1[1]) .. string.char(slot1[0]) .. (slot1[3] == 0 and "" or string.char(slot1[3]))
end

function slot6(slot0)
	slot2 = uv0.cast("char*", uv0.cast("unsigned int*", uv0.new("unsigned int[1]", 0)))
	slot2[2] = string.byte(slot0, 1)
	slot2[1] = string.byte(slot0, 2)
	slot2[0] = string.byte(slot0, 3)
	slot2[3] = string.byte(slot0, 4) or 0

	return slot1[0]
end

function slot7()
	slot0 = uv0.GetPOPCount()
	slot1 = uv1.new("unsigned int[?]", slot0)

	uv0.GetPOPList(slot1, slot0)

	return slot0, slot1
end

slot8 = client.error_log
slot9 = slot0.new([[
	struct {
		void* vtbl;
		void* vtbl_storage[22];
	}
]])
slot9.vtbl = slot9.vtbl_storage
slot10 = slot0.cast("void***", slot0.cast("char*", client.find_signature("client.dll", "\\xa1\\xcc\\xcc\\xcc̅\\xc0uj\\x8bT$ 3\\xf63")) + 1)[0]
slot11 = nil

function slot12()
	if uv0 ~= nil then
		if uv0[0] == uv1 then
			uv0[0] = uv2.thisptr
		end

		uv0 = nil
	end
end

function slot13()
	uv1()

	if uv0[0] ~= nil and uv2.cast("void**", slot0) + 26 ~= nil and slot1[0] ~= nil then
		if slot1[0] ~= uv3 and slot2 ~= uv4.thisptr and slot2 ~= nil then
			uv5(string.format("Invalid match listener instance: %02X", tonumber(uv2.cast("uintptr_t", slot2))))

			return false
		end

		slot1[0] = uv3
		uv6 = slot1

		return true
	end

	return false
end

slot14 = cvar.mm_dedicated_search_maxping
slot15, slot16, slot17 = nil
slot9.vtbl_storage[1] = slot0.cast("int(__thiscall*)(void*, SteamRelayNetworkStatus_t *)", function (slot0, slot1)
	slot2, slot3 = uv0.GetRelayNetworkStatus()
	slot1.m_eAvail = slot3.m_eAvail
	slot1.m_bPingMeasurementInProgress = slot3.m_bPingMeasurementInProgress
	slot1.m_eAvailNetworkConfig = slot3.m_eAvailNetworkConfig
	slot1.m_eAvailAnyRelay = slot3.m_eAvailAnyRelay
	slot1.m_debugMsg = slot3.m_debugMsg

	if slot3.m_bPingMeasurementInProgress and uv1 ~= nil and uv1 < globals.realtime() then
		slot1.m_bPingMeasurementInProgress = false
	end

	return slot2
end)
slot9.vtbl_storage[7] = slot0.cast("bool(__thiscall*)(void*, float)", function (slot0, slot1)
	slot2 = uv0.CheckPingDataUpToDate(slot1)

	xpcall(uv1, uv2)

	return false
end)
slot9.vtbl_storage[8] = slot0.cast("int(__thiscall*)(void*, unsigned int, unsigned int *)", function (slot0, slot1, slot2)
	slot3 = uv0(slot1)

	if uv1 ~= nil and uv1[slot3] ~= nil and uv1[slot3].relay ~= nil and uv1[slot3].indirect ~= nil then
		slot2[0] = uv2(uv1[slot3].relay)

		return uv1[slot3].indirect
	end

	slot4, slot2[0] = uv3.GetPingToDataCenter(slot1)

	return slot4
end)
slot9.vtbl_storage[9] = slot0.cast("int(__thiscall*)(void*, unsigned int)", function (slot0, slot1)
	slot2 = uv0(slot1)

	if uv1 ~= nil and uv1[slot2] ~= nil and uv1[slot2].direct ~= nil then
		return uv1[slot2].direct
	end

	return uv2.GetDirectPingToPOP(slot1)
end)
slot9.vtbl_storage[10] = slot0.cast("int(__thiscall*)(void*)", function (slot0)
	xpcall(uv0, uv1)

	return uv2.GetPOPCount()
end)
slot9.vtbl_storage[11] = slot0.cast("int(__thiscall*)(void*, unsigned int *, int)", function (slot0, slot1, slot2)
	return uv0.GetPOPList(slot1, slot2)
end)
slot18 = panorama.loadstring([[
	var panel, panel_dropdown, panel_top_bar
	var update_visibility_callback
	var datacenters = {}
	var datacenters_arr = []
	var datacenters_active = []
	var ping_measurement = false
	var popup_open = false

	var dropdown_layout

	var _SetDatacenters = function(_datacenters, _ping_measurement, _datacenters_arr) {
		if(_datacenters != null) {
			datacenters = _datacenters

			if(panel_dropdown != null)
				_UpdateDropdownItems()
		}

		if(_datacenters_arr != null)
			datacenters_arr = _datacenters_arr

		if(_ping_measurement != null) {
			var update = ping_measurement != _ping_measurement
			ping_measurement = _ping_measurement

			if(update && panel_dropdown != null)
				_UpdateDropdownHeader()
		}

		if(popup_open)
			_UpdatePopup()
	}

	var _SetLayouts = function(_dropdown_layout) {
		dropdown_layout = _dropdown_layout
	}

	var _HandleScrollBar = function() {
		if(panel_top_bar == null || panel == null || !panel.IsValid())
			return

		if(panel.desiredlayoutwidth > panel.actuallayoutwidth)
			panel_top_bar.style.overflow = "scroll squish"
	}

	var _HandleDatacenterClick = function(id) {
		if(datacenters_active.includes(id)) {
			_SetActiveDatacenters(datacenters_active.filter((el) => el != id))
		} else {
			_SetActiveDatacenters(datacenters_active.concat([id]))
		}
	}

	var _GetRegionImage = function(country_code) {
		if(country_code == "HK" || country_code == "CN" || country_code == "BR" || country_code == "ZA" || country_code == "US" || country_code == "AU" || country_code == "SG")
			return `https://raw.githubusercontent.com/hampusborgos/country-flags/master/png100px/${country_code.toLowerCase()}.png`

		return `file://{images}/regions/${country_code}.png`
	}

	var _Create = function(){
		if(panel != null){
			return false
		}

		var panel_bot_difficulty = $.GetContextPanel().FindChildTraverse("BotDifficultyDropdown")
		if(panel_bot_difficulty != null){
			var panel_parent = panel_bot_difficulty.GetParent()

			if(panel_parent != null){
				panel_top_bar = panel_parent.GetParent()
				panel = $.CreatePanel("Panel", panel_parent, "")

				// debug
				// $.Msg(panel_top_bar.style.width = true ? "100%" : "600px")

				_HandleScrollBar()

				$.Schedule(0.05, _HandleScrollBar)
				$.Schedule(0.1, _HandleScrollBar)
				$.Schedule(0.2, _HandleScrollBar)

				panel_top_bar.SetPanelEvent("onmouseover", _HandleScrollBar)
				panel_top_bar.SetPanelEvent("onmouseout", _HandleScrollBar)

				if (panel != null) {
					panel.SetParent(panel_parent)

					if (panel.BLoadLayoutFromString(dropdown_layout, false, false)) {
						panel_dropdown = panel.FindChildTraverse("ServerPickerDropdown")

						if(panel_dropdown != null){
							update_visibility_callback = $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", _UpdateVisibility)
							_UpdateVisibility()
							_UpdateDropdownHeader()

							datacenters_arr.forEach((id) => {
								var datacenter = datacenters[id]

								var panel_datacenter = $.CreatePanel("Label", panel_dropdown, datacenter.id, {
									text: "",
									style: "padding: 0px 0px 0px 0px; margin: 0px 0px 0px 0px; flow-children: right;"
								})
								panel_datacenter.SetPanelEvent("onactivate", _HandleDatacenterClick.bind(null, datacenter.id))

								let panel_checkbox = $.CreatePanel("Panel", panel_datacenter, "checkbox", {
									class: "fix-scale",
									style: "vertical-align: center; width: 20px; height: 20px; background-size: 20px 20px; border-radius: 2px; border: 1.8px solid white; opacity: 0.8; margin-right: 2px; background-image: url('file://{images}/icons/ui/checkbox.svg'); transition: background-img-opacity 0.1s ease-in-out 0.0s;",
								})

								var panel_img
								if(datacenter.country_code) {
									panel_img = $.CreatePanel("Image", panel_datacenter, "", {
										class: "fix-scale",
										style: "background-color: rgba(0, 0, 0, 0.0); margin: 0px 10px 0px 10px; width: 32px; height: 21px; background-color: black; wash-color: #49494925; saturation: 1.1; border-radius: 3px; border: 1px solid #151515; opacity: 0.8; opacity-mask: url('file://{images}/masks/fade-both-top-bottom.png'); box-shadow: fill #00000080 1px 1px 8px 0px; "
									})

									panel_img.SetImage(_GetRegionImage(datacenter.country_code))
								}

								var panel_name = $.CreatePanel("Label", panel_datacenter, "name", {
									text: datacenter.name,
									style: "letter-spacing: 1px; background-color: rgba(0, 0, 0, 0.0); padding: 10px 5px 10px 0px; margin: 0;"
								})

								panel_datacenter.GetChild(0).style.marginLeft = "25px;"

								var panel_pings = $.CreatePanel("Panel", panel_datacenter, "pings", {
									class: "fix-scale",
									style: "flow-children: down; vertical-align: center; horizontal-align: right; padding: 0; margin: 0;"
								})

								// lines for extra info
								$.CreatePanel("Label", panel_pings, "line-1", {
									text: "500ms",
									style: "text-align: right; horizontal-align: right; margin: 0; padding: 0; font-size: 11; font-family: Stratum2 Regular; letter-spacing: 1px; background-color: rgba(0, 0, 0, 0.0); color: rgba(200, 200, 200, 0.5); margin-right: 18px;"
								})

								$.CreatePanel("Label", panel_pings, "line-2", {
									text: "500ms",
									style: "text-align: right; horizontal-align: right; margin: 0; padding: 0; font-size: 11; font-family: Stratum2 Regular; letter-spacing: 1px; background-color: rgba(0, 0, 0, 0.0); color: rgba(200, 200, 200, 0.6) padding-top: 1px; margin-right: 18px;"
								})

								panel_dropdown.AddOption(panel_datacenter)
							})

							_UpdateDropdownItems()

							panel_dropdown.SetPanelEvent("onmouseover", function(){
								popup_open = true
								_UpdatePopup()

								_UpdateDropdownItems()
							})

							panel_dropdown.SetPanelEvent("onmouseout", function(){
								popup_open = false
								UiToolkitAPI.HideTextTooltip()

								_UpdateDropdownItems()
							})
						}
					}
				}
			}
		} else {
			return false
		}

		return true
	}

	var _UpdateDropdownHeader = function(){
		var el = panel_dropdown.GetChild(0)
		if(el) {
			el.text = ""

			el.Children().forEach((child) => {
				child.visible = false
				child.DeleteAsync(0.0)
			})

			var container = $.CreatePanel("Panel", el, "", {
				class: "left-right-flow",
				style: "height: 100%;"
			})

			if(ping_measurement) {
				var spinner = $.CreatePanel("Panel", container, "", {
					class: "Spinner",
					style: "margin-right: 5px; max-height: 25px; opacity: 0.8;"
				})
			}

			var header = $.CreatePanel("Panel", container, "", {
				class: "left-right-flow",
				style: "padding-top: 3px; padding: 0 0 0 0; margin: 0 0 0 0;"
			})

			var panel_images = $.CreatePanel("Panel", header, "", {
				style: "margin: 0 0 0 0; flow-children: none; vertical-align: top; horizontal-align: center; overflow: noclip;"
			})

			var panel_label = $.CreatePanel("Label", header, "", {
				style: "margin: 0 0 0 0; padding: 0 0 0 0; text-transform: none; font-family: stratum2Font; letter-spacing: 0px; max-width: 280px; text-overflow: ellipsis;",
			})

			if(datacenters_active.length == 0) {
				panel_label.text = "Select matchmaking region"
				panel_dropdown.style.opacity = 0.44
			} else {
				panel_label.text = datacenters_arr.filter(id => datacenters_active.includes(id)).map(id => datacenters[id].name).join(", ")
				panel_dropdown.style.opacity = 1.0

				var seen = {}
				var count = 0
				datacenters_arr.filter(id => datacenters_active.includes(id)).forEach(id => {
					var datacenter = datacenters[id]
					if(datacenter.country_code in seen)
						return

					if(count >= 3)
						return

					seen[datacenter.country_code] = true
					var panel_img = $.CreatePanel("Image", panel_images, "", {
						class: "left-right-flow",
						style: "margin-right: 8px; width: 40px; height: 25px; box-shadow: fill #00000080 1px 1px 8px 0px; border-radius: 2px; brightness: 0.9;"
					})
					panel_img.style.marginLeft = count*6 + "px"
					panel_img.style.marginTop = count*6 + "px"

					panel_img.SetImage(_GetRegionImage(datacenter.country_code))
					count++
				})
				panel_images.style.marginTop = -count*3 + "px"
			}
		}
	}

	var _UpdateVisibility = function(){
		if(panel_dropdown != null){
			var settings = LobbyAPI.GetSessionSettings()
			panel_dropdown.visible = (settings && settings.options && settings.options.server == "official") == true
		}
	}

	var _UpdateDropdownItems = function(){
		var dropdown_menu = panel_dropdown.AccessDropDownMenu()

		if(!dropdown_menu)
			return

		var uiscale_def = `${(dropdown_menu.actualuiscale_x*100).toFixed(3)}%`
		var uiscale_inv = `${((1/dropdown_menu.actualuiscale_x)*100).toFixed(3)}%`

		dropdown_menu.Children().forEach((child) => {
			child.style.uiScaleX = uiscale_inv

			child.FindChildrenWithClassTraverse("fix-scale").forEach((child2) => {
				child2.style.uiScaleX = uiscale_def
			})

			if(datacenters[child.id]) {
				var dc = datacenters[child.id]

				var line1 = child.FindChildTraverse("line-1")
				var line2 = child.FindChildTraverse("line-2")

				/*
				if(dc.direct != null) {
					line1.visible = true
					line1.text = `${dc.direct}ms`
				} else {
					line1.visible = false
				}

				if(dc.relay != null && dc.relay != dc.id) {
					line2.text = `${dc.relay}: ${dc.indirect}ms`
					line2.visible = true
					line1.style.verticalAlign = "top"
				} else {
					line2.visible = false
					line1.style.verticalAlign = "center"
				}
				*/

				line1.text = `${Math.min(dc.direct || dc.indirect, dc.indirect || 99999)}ms`
				line1.style.verticalAlign = "center"
				line1.visible = true

				if(dc.time_offset != null) {
					var now = new Date()
					var offset_to_local = dc.time_offset + now.getTimezoneOffset() * 60
					var time = new Date(now.getTime() + offset_to_local * 1000)
					line2.text = `${time.getHours().toString().padStart(2, "0")}:${time.getMinutes().toString().padStart(2, "0")}`
				} else {
					line2.text = ""
				}
				line2.visible = true

				var panel_checkbox = child.FindChildTraverse("checkbox")
				if(panel_checkbox) {
					panel_checkbox.style.backgroundImgOpacity = datacenters_active.includes(child.id) ? "1" : "0"
					// panel_checkbox.style.backgroundImage = datacenters_active.includes(child.id) ? `url("file://{images}/icons/ui/checkbox.svg");` : null
				}
			}
		})
	}

	var _UpdatePopup = function() {
		var text = []
		var active = _GetActiveDatacenters()

		if(active.length > 0) {
			text.push(active.length > 1 ? `Current matchmaking regions:` : `Current matchmaking region:`)
			active.forEach((id) => {
				var datacenter = datacenters[id]
				text.push(`${datacenter.name} (${datacenter.id}, ${datacenter.direct || datacenter.indirect}ms)`)
			})
		} else {
			text.push("Select matchmaking region")
		}

		if(ping_measurement)
			text.push("\nPing measurement in progress...")

		UiToolkitAPI.ShowTextTooltip("ServerPickerDropdown", text.join("\n"))
	}

	var _GetActiveDatacenters = function(){
		return datacenters_active
	}

	var _SetActiveDatacenters = function(datacenters_active_){
		datacenters_active = datacenters_active_
		if(panel_dropdown != null){
			panel_dropdown.SetSelected(datacenters_active[0] || datacenters_arr[0])

			_UpdateDropdownItems()
			_UpdateDropdownHeader()
		}
	}

	var _Destroy = function(){
		if(panel_top_bar != null) {
			panel_top_bar.ClearPanelEvent("onmouseover")
			panel_top_bar.ClearPanelEvent("onmouseout")

			panel_top_bar.style.overflow = "squish squish"
		}
		if(panel != null) {
			// panel.GetParent().GetParent().style.overflow = "squish squish"

			panel.RemoveAndDeleteChildren()
			panel.DeleteAsync(0.0)
			panel = null
		}
		if(update_visibility_callback != null) {
			$.UnregisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", update_visibility_callback)
			update_visibility_callback = null
		}
	}

	var _GetLauncherType = function(){
		return MyPersonaAPI.GetLauncherType()
	}

	var _SetVisible = function(visible){
		if(panel != null) {
			panel.visible = visible
		}
	}

	var _StopSearch = function(reason) {
		var is_searching = PartyListAPI.GetPartySessionSetting("game/mmqueue") == "searching"

		if(is_searching)
			LobbyAPI.StopMatchmaking()

		if(reason != null) {
			UiToolkitAPI.ShowGenericPopupOk(
				"MM Region Selector Error",
				`Failed to force region!\n\n${reason}\n\n${is_searching ? "The search has been stopped.\n" : ""}If this error persists, please disable the lua script.`,
				"",
				() => {
					UiToolkitAPI.CloseAllVisiblePopups()
				}
			)
		}
	}

	return {
		create: _Create,
		destroy: _Destroy,
		get_active_datacenters: _GetActiveDatacenters,
		set_active_datacenters: _SetActiveDatacenters,
		get_launcher_type: _GetLauncherType,
		set_datacenters: _SetDatacenters,
		set_layouts: _SetLayouts,
		set_visible: _SetVisible,
		stop_search: _StopSearch,
	}
]], "CSGOMainMenu")()
slot19 = [[
	<root>
		<styles>
			<include src="file://{resources}/styles/csgostyles.css" />
		</styles>
		<Panel>
			<DropDown class="PopupButton White hidden" id="ServerPickerDropdown" menuclass="DropDownMenu" style="margin-right: -2px; text-align: right;">
				<Label text="No forced region" id="" style="visibility: collapse;"/>
			</DropDown>
		</Panel>
	</root>
]]

function slot8(slot0)
	client.error_log(slot0)
	uv0.stop_search(slot0)
end

slot20 = {}
slot21 = {}

function slot22()
	slot0, slot1 = uv0()

	for slot5 = 1, slot0 do
		if uv2[uv1(slot1[slot5 - 1])] ~= nil then
			if uv3.GetDirectPingToPOP(slot6) > 0 and slot9 < 800 then
				uv2[slot7].direct = slot9
			end

			slot10, slot11 = uv3.GetPingToDataCenter(slot6)

			if slot10 > 0 and slot11 ~= nil then
				if slot10 < 800 then
					slot8.relay = uv1(slot11)
					slot8.indirect = slot10
				end
			end
		end
	end
end

function slot23(slot0, slot1)
	if uv0[slot0] == nil or uv0[slot0].geo == nil or uv0[slot1] == nil or uv0[slot1].geo == nil then
		return 999
	end

	slot2, slot3 = unpack(uv0[slot0].geo)
	slot4, slot5 = unpack(uv0[slot1].geo)
	slot8 = math.sin(math.rad(slot4 - slot2) / 2)
	slot9 = math.sin(math.rad(slot5 - slot3) / 2)
	slot10 = slot8 * slot8 + math.cos(math.rad(slot2)) * math.cos(math.rad(slot4)) * slot9 * slot9

	return 125 * 2 * math.atan2(math.sqrt(slot10), math.sqrt(1 - slot10))
end

function slot17()
	uv0 = {}
	slot0, slot1 = uv1()
	slot2 = inf
	slot4 = {
		[uv3(slot9)] = {
			direct = slot10,
			indirect = slot11,
			relay = uv3(slot12)
		}
	}

	for slot8 = 1, slot0 do
		slot9 = slot1[slot8 - 1]
		slot10 = uv2.GetDirectPingToPOP(slot9)
		slot11, slot12 = uv2.GetPingToDataCenter(slot9)

		if slot10 > 0 then
			if 0 < slot10 then
				slot3 = slot10
			elseif slot10 < slot2 then
				slot2 = slot10
			end
		end
	end

	slot9 = 7
	slot2 = math.min(9, slot2 + client.random_int(-2, slot9))
	slot3 = slot3 + client.random_int(90, 150)
	slot5 = {
		[slot10] = true
	}

	for slot9, slot10 in ipairs(uv4.active_datacenters) do
		-- Nothing
	end

	slot6 = {}

	for slot10, slot11 in ipairs(uv4.active_datacenters) do
		if slot4[slot11].direct > 0 then
			table.insert(slot6, slot11)
		end
	end

	slot7 = nil

	if #slot6 > 0 then
		slot7 = slot6[client.random_int(1, #slot6)]
	else
		for slot13, slot14 in pairs(slot4) do
			if uv5(slot13, uv4.active_datacenters[client.random_int(1, #uv4.active_datacenters)]) < inf then
				slot9 = slot15
				slot7 = slot13
			end
		end
	end

	uv0[slot7] = {
		direct = slot2,
		indirect = slot2,
		relay = slot7
	}

	for slot11, slot12 in pairs(slot4) do
		if uv0[slot11] == nil and slot5[slot11] then
			uv0[slot11] = {}

			if slot12.direct > 0 then
				uv0[slot11].direct = slot2 + uv5(slot11, slot7) * 0.2
			else
				slot13.direct = slot4[slot11].direct
			end

			slot13.indirect = uv0[slot7].direct
			slot13.relay = slot7
		end
	end

	for slot11, slot12 in pairs(slot4) do
		slot13 = nil

		for slot17, slot18 in pairs(uv0) do
			if slot17 ~= slot11 and uv5(slot11, slot17) < 2 and slot4[slot17].direct > 0 and slot12.direct > 0 then
				slot13 = slot17

				break
			end
		end

		if slot13 ~= nil then
			slot14 = client.random_int(-2, 4)
			uv0[slot11] = {
				direct = uv0[slot13].direct + slot14,
				indirect = uv0[slot13].indirect + slot14 + client.random_int(-1, 1),
				relay = uv0[slot13].relay
			}
		end
	end

	for slot12, slot13 in pairs(uv0) do
		if 0 < math.min(slot13.direct, slot13.indirect) then
			slot8 = slot14
		end
	end

	for slot13, slot14 in pairs(slot4) do
		if uv0[slot13] == nil and not slot5[slot13] then
			slot16 = math.min(900, math.floor(slot8 + client.random_int(25, 45) + uv5(slot13, slot7))) + client.random_int(30, 55)
			uv0[slot13] = {
				direct = slot16 + client.random_int(-4, 12),
				indirect = slot16,
				relay = slot7
			}
		end
	end

	for slot13, slot14 in pairs(uv0) do
		slot14.direct = slot14.indirect
		slot14.relay = slot13
	end

	slot10 = slot8 + 20

	uv6:set_raw_float(slot10)
	uv6:set_raw_int(slot10)
end

function slot24()
	uv0.set_active_datacenters(uv1.active_datacenters or {})

	slot0 = false
	slot1 = 0
	slot2 = false

	client.set_event_callback("paint_ui", function ()
		slot0 = false

		uv0()

		if globals.mapname() == nil then
			uv1.active_datacenters = json.parse(tostring(uv2.get_active_datacenters()))
			slot1, slot2 = uv3.GetRelayNetworkStatus()

			if globals.realtime() - uv4 > 0.2 then
				uv5()
				uv2.set_datacenters(uv6, slot2.m_bPingMeasurementInProgress == 1)

				uv4 = slot3
			end

			if not uv7 then
				uv8 = globals.realtime() + client.random_float(0.9, 1.7)
			end

			uv7 = slot2.m_bPingMeasurementInProgress == 1

			if #uv1.active_datacenters > 0 then
				uv9()
			end
		end

		if uv10 and not slot0 then
			uv11:set_string(uv11:get_string())
		end

		uv10 = slot0
	end)
	client.set_event_callback("shutdown", function ()
		uv0.destroy()

		if uv1 then
			uv2:set_string(uv2:get_string())
		end

		uv3()
		database.write("server_picker", uv4)
	end)

	function slot4()
		uv0.set_visible(not ui.get(uv1))
	end

	ui.set_callback(ui.reference("MISC", "Settings", "Hide from OBS"), slot4)
	slot4()
end

function slot25()
	for slot3, slot4 in pairs(uv0.active_datacenters) do
		if uv1[slot4] == nil then
			uv0.active_datacenters = {}

			break
		end
	end

	slot0 = {}

	for slot4, slot5 in pairs(uv1) do
		table.insert(slot0, {
			slot5.name,
			slot4
		})
	end

	table.sort(slot0, function (slot0, slot1)
		return slot0[1] < slot1[1]
	end)

	for slot4, slot5 in ipairs(slot0) do
		slot0[slot4] = slot5[2]
	end

	uv2.set_datacenters(uv1, nil, slot0)
	uv2.set_layouts(uv3)
	function ()
		if uv0.create() then
			uv1()
		else
			client.delay_call(0.2, uv2)
		end
	end()
end

function slot26(slot0, slot1)
	if not slot0 or slot1.status ~= 200 then
		return
	end

	if json.parse(slot1.body).success ~= 1 then
		return
	end

	table.clear(uv0)

	slot3, slot4 = uv1()

	for slot8 = 1, slot3 do
		slot10 = uv2(slot4[slot8 - 1])
		slot11 = {
			i = slot8,
			id = slot10,
			name = slot2.pops[slot10].server_region or slot12.desc
		}

		if slot2.pops[slot10] ~= nil then
			if slot11.name:find("_") then
				slot11.name = slot12.desc
			end

			if slot12.country ~= nil then
				slot11.country_code = slot12.country.short_name
			end

			slot11.server_region = slot12.server_region
			slot11.geo = slot12.geo
			slot11.time_offset = slot12.time_offset
		else
			slot11.name = slot10:upper()
		end

		uv0[slot10] = slot11
	end

	for slot9, slot10 in pairs(uv0) do
		if slot2.pops[slot9] ~= nil and slot11.server_region ~= nil then
			slot12 = slot11.groups or {
				"valve"
			}

			if uv3.get_launcher_type() == "perfectworld" then
				if #slot12 == 1 and slot12[1] == "perfectworld" then
					uv4[slot9] = slot10
				end
			elseif slot5 == "steam" then
				for slot16, slot17 in ipairs(slot12) do
					if slot17 == "valve" then
						uv4[slot9] = slot10

						break
					end
				end
			end
		end
	end

	uv5()
	uv6()
end

client.set_event_callback("paint_ui", function ()
	if globals.mapname() == nil then
		xpcall(uv0.get, client.error_log, "https://sapphyr.us/sdr-data/v1/config", uv1)
		client.unset_event_callback("paint_ui", uv2)
	end
end)

if package.loaded["gamesense/sdr"] == nil then
	package.loaded["gamesense/sdr"] = {
		get_active_datacenters = function ()
			return {
				unpack(uv0.active_datacenters)
			}
		end,
		set_active_datacenters = function (slot0)
			for slot4, slot5 in pairs(slot0) do
				if uv0[slot5] == nil then
					error("unknown datacenter: " .. tostring(slot5), 2)

					return
				end
			end

			uv1.active_datacenters = slot0

			uv2.set_active_datacenters(uv1.active_datacenters)
		end,
		get_all_datacenters = function ()
			slot0 = {}

			for slot4, slot5 in pairs(uv0) do
				table.insert(slot0, slot4)
			end

			return slot0
		end,
		get_datacenter_info = function (slot0)
			if uv0[slot0] == nil then
				error("unknown datacenter: " .. tostring(slot0), 2)
			end

			return {
				name = uv0[slot0].name,
				country_code = uv0[slot0].country_code,
				ping = {
					direct = uv0[slot0].direct,
					indirect = uv0[slot0].indirect,
					relay = uv0[slot0].relay
				}
			}
		end
	}
end
