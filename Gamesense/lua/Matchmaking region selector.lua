local var_0_0 = require("ffi")
local var_0_1 = require("gamesense/steamworks")
local var_0_2 = require("gamesense/http")
local var_0_3 = database.read("server_picker")

if type(var_0_3) ~= "table" then
	var_0_3 = {}
end

if var_0_3.active_datacenter ~= nil then
	var_0_3.active_datacenters = var_0_3.active_datacenters or {
		var_0_3.active_datacenter
	}
	var_0_3.active_datacenter = nil
end

if type(var_0_3.active_datacenters) ~= "table" then
	var_0_3.active_datacenters = {}
end

local var_0_4 = var_0_1.ISteamNetworkingUtils

local function var_0_5(arg_1_0)
	local var_1_0 = var_0_0.cast("const char*", var_0_0.new("unsigned int[1]", arg_1_0))

	return string.char(var_1_0[2]) .. string.char(var_1_0[1]) .. string.char(var_1_0[0]) .. (var_1_0[3] == 0 and "" or string.char(var_1_0[3]))
end

local function var_0_6(arg_2_0)
	local var_2_0 = var_0_0.new("unsigned int[1]", 0)
	local var_2_1 = var_0_0.cast("char*", var_0_0.cast("unsigned int*", var_2_0))

	var_2_1[2] = string.byte(arg_2_0, 1)
	var_2_1[1] = string.byte(arg_2_0, 2)
	var_2_1[0] = string.byte(arg_2_0, 3)
	var_2_1[3] = string.byte(arg_2_0, 4) or 0

	return var_2_0[0]
end

local function var_0_7()
	local var_3_0 = var_0_4.GetPOPCount()
	local var_3_1 = var_0_0.new("unsigned int[?]", var_3_0)

	var_0_4.GetPOPList(var_3_1, var_3_0)

	return var_3_0, var_3_1
end

local var_0_8 = client.error_log
local var_0_9 = var_0_0.new("\tstruct {\n\t\tvoid* vtbl;\n\t\tvoid* vtbl_storage[22];\n\t}\n")

var_0_9.vtbl = var_0_9.vtbl_storage

local var_0_10 = var_0_0.cast("void***", var_0_0.cast("char*", client.find_signature("client.dll", "\xA1\xCC\xCC\xCC̅\xC0uj\x8BT$ 3\xF63")) + 1)[0]
local var_0_11

local function var_0_12()
	if var_0_11 ~= nil then
		if var_0_11[0] == var_0_9 then
			var_0_11[0] = var_0_4.thisptr
		end

		var_0_11 = nil
	end
end

local function var_0_13()
	local var_5_0 = var_0_10[0]

	var_0_12()

	if var_5_0 ~= nil then
		local var_5_1 = var_0_0.cast("void**", var_5_0) + 26

		if var_5_1 ~= nil and var_5_1[0] ~= nil then
			local var_5_2 = var_5_1[0]

			if var_5_2 ~= var_0_9 and var_5_2 ~= var_0_4.thisptr and var_5_2 ~= nil then
				var_0_8(string.format("Invalid match listener instance: %02X", tonumber(var_0_0.cast("uintptr_t", var_5_2))))

				return false
			end

			var_5_1[0] = var_0_9
			var_0_11 = var_5_1

			return true
		end
	end

	return false
end

local var_0_14 = cvar.mm_dedicated_search_maxping
local var_0_15
local var_0_16
local var_0_17

var_0_9.vtbl_storage[1] = var_0_0.cast("int(__thiscall*)(void*, SteamRelayNetworkStatus_t *)", function(arg_6_0, arg_6_1)
	local var_6_0, var_6_1 = var_0_4.GetRelayNetworkStatus()

	arg_6_1.m_eAvail = var_6_1.m_eAvail
	arg_6_1.m_bPingMeasurementInProgress = var_6_1.m_bPingMeasurementInProgress
	arg_6_1.m_eAvailNetworkConfig = var_6_1.m_eAvailNetworkConfig
	arg_6_1.m_eAvailAnyRelay = var_6_1.m_eAvailAnyRelay
	arg_6_1.m_debugMsg = var_6_1.m_debugMsg

	if var_6_1.m_bPingMeasurementInProgress and var_0_16 ~= nil and globals.realtime() > var_0_16 then
		arg_6_1.m_bPingMeasurementInProgress = false
	end

	return var_6_0
end)
var_0_9.vtbl_storage[7] = var_0_0.cast("bool(__thiscall*)(void*, float)", function(arg_7_0, arg_7_1)
	local var_7_0 = var_0_4.CheckPingDataUpToDate(arg_7_1)

	xpcall(var_0_17, var_0_8)

	return false
end)
var_0_9.vtbl_storage[8] = var_0_0.cast("int(__thiscall*)(void*, unsigned int, unsigned int *)", function(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = var_0_5(arg_8_1)

	if var_0_15 ~= nil and var_0_15[var_8_0] ~= nil and var_0_15[var_8_0].relay ~= nil and var_0_15[var_8_0].indirect ~= nil then
		arg_8_2[0] = var_0_6(var_0_15[var_8_0].relay)

		return var_0_15[var_8_0].indirect
	end

	local var_8_1, var_8_2 = var_0_4.GetPingToDataCenter(arg_8_1)

	arg_8_2[0] = var_8_2

	return var_8_1
end)
var_0_9.vtbl_storage[9] = var_0_0.cast("int(__thiscall*)(void*, unsigned int)", function(arg_9_0, arg_9_1)
	local var_9_0 = var_0_5(arg_9_1)

	if var_0_15 ~= nil and var_0_15[var_9_0] ~= nil and var_0_15[var_9_0].direct ~= nil then
		return var_0_15[var_9_0].direct
	end

	return var_0_4.GetDirectPingToPOP(arg_9_1)
end)
var_0_9.vtbl_storage[10] = var_0_0.cast("int(__thiscall*)(void*)", function(arg_10_0)
	xpcall(var_0_17, var_0_8)

	return var_0_4.GetPOPCount()
end)
var_0_9.vtbl_storage[11] = var_0_0.cast("int(__thiscall*)(void*, unsigned int *, int)", function(arg_11_0, arg_11_1, arg_11_2)
	return var_0_4.GetPOPList(arg_11_1, arg_11_2)
end)

local var_0_18 = panorama.loadstring("\tvar panel, panel_dropdown, panel_top_bar\n\tvar update_visibility_callback\n\tvar datacenters = {}\n\tvar datacenters_arr = []\n\tvar datacenters_active = []\n\tvar ping_measurement = false\n\tvar popup_open = false\n\n\tvar dropdown_layout\n\n\tvar _SetDatacenters = function(_datacenters, _ping_measurement, _datacenters_arr) {\n\t\tif(_datacenters != null) {\n\t\t\tdatacenters = _datacenters\n\n\t\t\tif(panel_dropdown != null)\n\t\t\t\t_UpdateDropdownItems()\n\t\t}\n\n\t\tif(_datacenters_arr != null)\n\t\t\tdatacenters_arr = _datacenters_arr\n\n\t\tif(_ping_measurement != null) {\n\t\t\tvar update = ping_measurement != _ping_measurement\n\t\t\tping_measurement = _ping_measurement\n\n\t\t\tif(update && panel_dropdown != null)\n\t\t\t\t_UpdateDropdownHeader()\n\t\t}\n\n\t\tif(popup_open)\n\t\t\t_UpdatePopup()\n\t}\n\n\tvar _SetLayouts = function(_dropdown_layout) {\n\t\tdropdown_layout = _dropdown_layout\n\t}\n\n\tvar _HandleScrollBar = function() {\n\t\tif(panel_top_bar == null || panel == null || !panel.IsValid())\n\t\t\treturn\n\n\t\tif(panel.desiredlayoutwidth > panel.actuallayoutwidth)\n\t\t\tpanel_top_bar.style.overflow = \"scroll squish\"\n\t}\n\n\tvar _HandleDatacenterClick = function(id) {\n\t\tif(datacenters_active.includes(id)) {\n\t\t\t_SetActiveDatacenters(datacenters_active.filter((el) => el != id))\n\t\t} else {\n\t\t\t_SetActiveDatacenters(datacenters_active.concat([id]))\n\t\t}\n\t}\n\n\tvar _GetRegionImage = function(country_code) {\n\t\tif(country_code == \"HK\" || country_code == \"CN\" || country_code == \"BR\" || country_code == \"ZA\" || country_code == \"US\" || country_code == \"AU\" || country_code == \"SG\")\n\t\t\treturn `https://raw.githubusercontent.com/hampusborgos/country-flags/master/png100px/${country_code.toLowerCase()}.png`\n\n\t\treturn `file://{images}/regions/${country_code}.png`\n\t}\n\n\tvar _Create = function(){\n\t\tif(panel != null){\n\t\t\treturn false\n\t\t}\n\n\t\tvar panel_bot_difficulty = $.GetContextPanel().FindChildTraverse(\"BotDifficultyDropdown\")\n\t\tif(panel_bot_difficulty != null){\n\t\t\tvar panel_parent = panel_bot_difficulty.GetParent()\n\n\t\t\tif(panel_parent != null){\n\t\t\t\tpanel_top_bar = panel_parent.GetParent()\n\t\t\t\tpanel = $.CreatePanel(\"Panel\", panel_parent, \"\")\n\n\t\t\t\t// debug\n\t\t\t\t// $.Msg(panel_top_bar.style.width = true ? \"100%\" : \"600px\")\n\n\t\t\t\t_HandleScrollBar()\n\n\t\t\t\t$.Schedule(0.05, _HandleScrollBar)\n\t\t\t\t$.Schedule(0.1, _HandleScrollBar)\n\t\t\t\t$.Schedule(0.2, _HandleScrollBar)\n\n\t\t\t\tpanel_top_bar.SetPanelEvent(\"onmouseover\", _HandleScrollBar)\n\t\t\t\tpanel_top_bar.SetPanelEvent(\"onmouseout\", _HandleScrollBar)\n\n\t\t\t\tif (panel != null) {\n\t\t\t\t\tpanel.SetParent(panel_parent)\n\n\t\t\t\t\tif (panel.BLoadLayoutFromString(dropdown_layout, false, false)) {\n\t\t\t\t\t\tpanel_dropdown = panel.FindChildTraverse(\"ServerPickerDropdown\")\n\n\t\t\t\t\t\tif(panel_dropdown != null){\n\t\t\t\t\t\t\tupdate_visibility_callback = $.RegisterForUnhandledEvent(\"PanoramaComponent_Lobby_MatchmakingSessionUpdate\", _UpdateVisibility)\n\t\t\t\t\t\t\t_UpdateVisibility()\n\t\t\t\t\t\t\t_UpdateDropdownHeader()\n\n\t\t\t\t\t\t\tdatacenters_arr.forEach((id) => {\n\t\t\t\t\t\t\t\tvar datacenter = datacenters[id]\n\n\t\t\t\t\t\t\t\tvar panel_datacenter = $.CreatePanel(\"Label\", panel_dropdown, datacenter.id, {\n\t\t\t\t\t\t\t\t\ttext: \"\",\n\t\t\t\t\t\t\t\t\tstyle: \"padding: 0px 0px 0px 0px; margin: 0px 0px 0px 0px; flow-children: right;\"\n\t\t\t\t\t\t\t\t})\n\t\t\t\t\t\t\t\tpanel_datacenter.SetPanelEvent(\"onactivate\", _HandleDatacenterClick.bind(null, datacenter.id))\n\n\t\t\t\t\t\t\t\tlet panel_checkbox = $.CreatePanel(\"Panel\", panel_datacenter, \"checkbox\", {\n\t\t\t\t\t\t\t\t\tclass: \"fix-scale\",\n\t\t\t\t\t\t\t\t\tstyle: \"vertical-align: center; width: 20px; height: 20px; background-size: 20px 20px; border-radius: 2px; border: 1.8px solid white; opacity: 0.8; margin-right: 2px; background-image: url('file://{images}/icons/ui/checkbox.svg'); transition: background-img-opacity 0.1s ease-in-out 0.0s;\",\n\t\t\t\t\t\t\t\t})\n\n\t\t\t\t\t\t\t\tvar panel_img\n\t\t\t\t\t\t\t\tif(datacenter.country_code) {\n\t\t\t\t\t\t\t\t\tpanel_img = $.CreatePanel(\"Image\", panel_datacenter, \"\", {\n\t\t\t\t\t\t\t\t\t\tclass: \"fix-scale\",\n\t\t\t\t\t\t\t\t\t\tstyle: \"background-color: rgba(0, 0, 0, 0.0); margin: 0px 10px 0px 10px; width: 32px; height: 21px; background-color: black; wash-color: #49494925; saturation: 1.1; border-radius: 3px; border: 1px solid #151515; opacity: 0.8; opacity-mask: url('file://{images}/masks/fade-both-top-bottom.png'); box-shadow: fill #00000080 1px 1px 8px 0px; \"\n\t\t\t\t\t\t\t\t\t})\n\n\t\t\t\t\t\t\t\t\tpanel_img.SetImage(_GetRegionImage(datacenter.country_code))\n\t\t\t\t\t\t\t\t}\n\n\t\t\t\t\t\t\t\tvar panel_name = $.CreatePanel(\"Label\", panel_datacenter, \"name\", {\n\t\t\t\t\t\t\t\t\ttext: datacenter.name,\n\t\t\t\t\t\t\t\t\tstyle: \"letter-spacing: 1px; background-color: rgba(0, 0, 0, 0.0); padding: 10px 5px 10px 0px; margin: 0;\"\n\t\t\t\t\t\t\t\t})\n\n\t\t\t\t\t\t\t\tpanel_datacenter.GetChild(0).style.marginLeft = \"25px;\"\n\n\t\t\t\t\t\t\t\tvar panel_pings = $.CreatePanel(\"Panel\", panel_datacenter, \"pings\", {\n\t\t\t\t\t\t\t\t\tclass: \"fix-scale\",\n\t\t\t\t\t\t\t\t\tstyle: \"flow-children: down; vertical-align: center; horizontal-align: right; padding: 0; margin: 0;\"\n\t\t\t\t\t\t\t\t})\n\n\t\t\t\t\t\t\t\t// lines for extra info\n\t\t\t\t\t\t\t\t$.CreatePanel(\"Label\", panel_pings, \"line-1\", {\n\t\t\t\t\t\t\t\t\ttext: \"500ms\",\n\t\t\t\t\t\t\t\t\tstyle: \"text-align: right; horizontal-align: right; margin: 0; padding: 0; font-size: 11; font-family: Stratum2 Regular; letter-spacing: 1px; background-color: rgba(0, 0, 0, 0.0); color: rgba(200, 200, 200, 0.5); margin-right: 18px;\"\n\t\t\t\t\t\t\t\t})\n\n\t\t\t\t\t\t\t\t$.CreatePanel(\"Label\", panel_pings, \"line-2\", {\n\t\t\t\t\t\t\t\t\ttext: \"500ms\",\n\t\t\t\t\t\t\t\t\tstyle: \"text-align: right; horizontal-align: right; margin: 0; padding: 0; font-size: 11; font-family: Stratum2 Regular; letter-spacing: 1px; background-color: rgba(0, 0, 0, 0.0); color: rgba(200, 200, 200, 0.6) padding-top: 1px; margin-right: 18px;\"\n\t\t\t\t\t\t\t\t})\n\n\t\t\t\t\t\t\t\tpanel_dropdown.AddOption(panel_datacenter)\n\t\t\t\t\t\t\t})\n\n\t\t\t\t\t\t\t_UpdateDropdownItems()\n\n\t\t\t\t\t\t\tpanel_dropdown.SetPanelEvent(\"onmouseover\", function(){\n\t\t\t\t\t\t\t\tpopup_open = true\n\t\t\t\t\t\t\t\t_UpdatePopup()\n\n\t\t\t\t\t\t\t\t_UpdateDropdownItems()\n\t\t\t\t\t\t\t})\n\n\t\t\t\t\t\t\tpanel_dropdown.SetPanelEvent(\"onmouseout\", function(){\n\t\t\t\t\t\t\t\tpopup_open = false\n\t\t\t\t\t\t\t\tUiToolkitAPI.HideTextTooltip()\n\n\t\t\t\t\t\t\t\t_UpdateDropdownItems()\n\t\t\t\t\t\t\t})\n\t\t\t\t\t\t}\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t} else {\n\t\t\treturn false\n\t\t}\n\n\t\treturn true\n\t}\n\n\tvar _UpdateDropdownHeader = function(){\n\t\tvar el = panel_dropdown.GetChild(0)\n\t\tif(el) {\n\t\t\tel.text = \"\"\n\n\t\t\tel.Children().forEach((child) => {\n\t\t\t\tchild.visible = false\n\t\t\t\tchild.DeleteAsync(0.0)\n\t\t\t})\n\n\t\t\tvar container = $.CreatePanel(\"Panel\", el, \"\", {\n\t\t\t\tclass: \"left-right-flow\",\n\t\t\t\tstyle: \"height: 100%;\"\n\t\t\t})\n\n\t\t\tif(ping_measurement) {\n\t\t\t\tvar spinner = $.CreatePanel(\"Panel\", container, \"\", {\n\t\t\t\t\tclass: \"Spinner\",\n\t\t\t\t\tstyle: \"margin-right: 5px; max-height: 25px; opacity: 0.8;\"\n\t\t\t\t})\n\t\t\t}\n\n\t\t\tvar header = $.CreatePanel(\"Panel\", container, \"\", {\n\t\t\t\tclass: \"left-right-flow\",\n\t\t\t\tstyle: \"padding-top: 3px; padding: 0 0 0 0; margin: 0 0 0 0;\"\n\t\t\t})\n\n\t\t\tvar panel_images = $.CreatePanel(\"Panel\", header, \"\", {\n\t\t\t\tstyle: \"margin: 0 0 0 0; flow-children: none; vertical-align: top; horizontal-align: center; overflow: noclip;\"\n\t\t\t})\n\n\t\t\tvar panel_label = $.CreatePanel(\"Label\", header, \"\", {\n\t\t\t\tstyle: \"margin: 0 0 0 0; padding: 0 0 0 0; text-transform: none; font-family: stratum2Font; letter-spacing: 0px; max-width: 280px; text-overflow: ellipsis;\",\n\t\t\t})\n\n\t\t\tif(datacenters_active.length == 0) {\n\t\t\t\tpanel_label.text = \"Select matchmaking region\"\n\t\t\t\tpanel_dropdown.style.opacity = 0.44\n\t\t\t} else {\n\t\t\t\tpanel_label.text = datacenters_arr.filter(id => datacenters_active.includes(id)).map(id => datacenters[id].name).join(\", \")\n\t\t\t\tpanel_dropdown.style.opacity = 1.0\n\n\t\t\t\tvar seen = {}\n\t\t\t\tvar count = 0\n\t\t\t\tdatacenters_arr.filter(id => datacenters_active.includes(id)).forEach(id => {\n\t\t\t\t\tvar datacenter = datacenters[id]\n\t\t\t\t\tif(datacenter.country_code in seen)\n\t\t\t\t\t\treturn\n\n\t\t\t\t\tif(count >= 3)\n\t\t\t\t\t\treturn\n\n\t\t\t\t\tseen[datacenter.country_code] = true\n\t\t\t\t\tvar panel_img = $.CreatePanel(\"Image\", panel_images, \"\", {\n\t\t\t\t\t\tclass: \"left-right-flow\",\n\t\t\t\t\t\tstyle: \"margin-right: 8px; width: 40px; height: 25px; box-shadow: fill #00000080 1px 1px 8px 0px; border-radius: 2px; brightness: 0.9;\"\n\t\t\t\t\t})\n\t\t\t\t\tpanel_img.style.marginLeft = count*6 + \"px\"\n\t\t\t\t\tpanel_img.style.marginTop = count*6 + \"px\"\n\n\t\t\t\t\tpanel_img.SetImage(_GetRegionImage(datacenter.country_code))\n\t\t\t\t\tcount++\n\t\t\t\t})\n\t\t\t\tpanel_images.style.marginTop = -count*3 + \"px\"\n\t\t\t}\n\t\t}\n\t}\n\n\tvar _UpdateVisibility = function(){\n\t\tif(panel_dropdown != null){\n\t\t\tvar settings = LobbyAPI.GetSessionSettings()\n\t\t\tpanel_dropdown.visible = (settings && settings.options && settings.options.server == \"official\") == true\n\t\t}\n\t}\n\n\tvar _UpdateDropdownItems = function(){\n\t\tvar dropdown_menu = panel_dropdown.AccessDropDownMenu()\n\n\t\tif(!dropdown_menu)\n\t\t\treturn\n\n\t\tvar uiscale_def = `${(dropdown_menu.actualuiscale_x*100).toFixed(3)}%`\n\t\tvar uiscale_inv = `${((1/dropdown_menu.actualuiscale_x)*100).toFixed(3)}%`\n\n\t\tdropdown_menu.Children().forEach((child) => {\n\t\t\tchild.style.uiScaleX = uiscale_inv\n\n\t\t\tchild.FindChildrenWithClassTraverse(\"fix-scale\").forEach((child2) => {\n\t\t\t\tchild2.style.uiScaleX = uiscale_def\n\t\t\t})\n\n\t\t\tif(datacenters[child.id]) {\n\t\t\t\tvar dc = datacenters[child.id]\n\n\t\t\t\tvar line1 = child.FindChildTraverse(\"line-1\")\n\t\t\t\tvar line2 = child.FindChildTraverse(\"line-2\")\n\n\t\t\t\t/*\n\t\t\t\tif(dc.direct != null) {\n\t\t\t\t\tline1.visible = true\n\t\t\t\t\tline1.text = `${dc.direct}ms`\n\t\t\t\t} else {\n\t\t\t\t\tline1.visible = false\n\t\t\t\t}\n\n\t\t\t\tif(dc.relay != null && dc.relay != dc.id) {\n\t\t\t\t\tline2.text = `${dc.relay}: ${dc.indirect}ms`\n\t\t\t\t\tline2.visible = true\n\t\t\t\t\tline1.style.verticalAlign = \"top\"\n\t\t\t\t} else {\n\t\t\t\t\tline2.visible = false\n\t\t\t\t\tline1.style.verticalAlign = \"center\"\n\t\t\t\t}\n\t\t\t\t*/\n\n\t\t\t\tline1.text = `${Math.min(dc.direct || dc.indirect, dc.indirect || 99999)}ms`\n\t\t\t\tline1.style.verticalAlign = \"center\"\n\t\t\t\tline1.visible = true\n\n\t\t\t\tif(dc.time_offset != null) {\n\t\t\t\t\tvar now = new Date()\n\t\t\t\t\tvar offset_to_local = dc.time_offset + now.getTimezoneOffset() * 60\n\t\t\t\t\tvar time = new Date(now.getTime() + offset_to_local * 1000)\n\t\t\t\t\tline2.text = `${time.getHours().toString().padStart(2, \"0\")}:${time.getMinutes().toString().padStart(2, \"0\")}`\n\t\t\t\t} else {\n\t\t\t\t\tline2.text = \"\"\n\t\t\t\t}\n\t\t\t\tline2.visible = true\n\n\t\t\t\tvar panel_checkbox = child.FindChildTraverse(\"checkbox\")\n\t\t\t\tif(panel_checkbox) {\n\t\t\t\t\tpanel_checkbox.style.backgroundImgOpacity = datacenters_active.includes(child.id) ? \"1\" : \"0\"\n\t\t\t\t\t// panel_checkbox.style.backgroundImage = datacenters_active.includes(child.id) ? `url(\"file://{images}/icons/ui/checkbox.svg\");` : null\n\t\t\t\t}\n\t\t\t}\n\t\t})\n\t}\n\n\tvar _UpdatePopup = function() {\n\t\tvar text = []\n\t\tvar active = _GetActiveDatacenters()\n\n\t\tif(active.length > 0) {\n\t\t\ttext.push(active.length > 1 ? `Current matchmaking regions:` : `Current matchmaking region:`)\n\t\t\tactive.forEach((id) => {\n\t\t\t\tvar datacenter = datacenters[id]\n\t\t\t\ttext.push(`${datacenter.name} (${datacenter.id}, ${datacenter.direct || datacenter.indirect}ms)`)\n\t\t\t})\n\t\t} else {\n\t\t\ttext.push(\"Select matchmaking region\")\n\t\t}\n\n\t\tif(ping_measurement)\n\t\t\ttext.push(\"\\nPing measurement in progress...\")\n\n\t\tUiToolkitAPI.ShowTextTooltip(\"ServerPickerDropdown\", text.join(\"\\n\"))\n\t}\n\n\tvar _GetActiveDatacenters = function(){\n\t\treturn datacenters_active\n\t}\n\n\tvar _SetActiveDatacenters = function(datacenters_active_){\n\t\tdatacenters_active = datacenters_active_\n\t\tif(panel_dropdown != null){\n\t\t\tpanel_dropdown.SetSelected(datacenters_active[0] || datacenters_arr[0])\n\n\t\t\t_UpdateDropdownItems()\n\t\t\t_UpdateDropdownHeader()\n\t\t}\n\t}\n\n\tvar _Destroy = function(){\n\t\tif(panel_top_bar != null) {\n\t\t\tpanel_top_bar.ClearPanelEvent(\"onmouseover\")\n\t\t\tpanel_top_bar.ClearPanelEvent(\"onmouseout\")\n\n\t\t\tpanel_top_bar.style.overflow = \"squish squish\"\n\t\t}\n\t\tif(panel != null) {\n\t\t\t// panel.GetParent().GetParent().style.overflow = \"squish squish\"\n\n\t\t\tpanel.RemoveAndDeleteChildren()\n\t\t\tpanel.DeleteAsync(0.0)\n\t\t\tpanel = null\n\t\t}\n\t\tif(update_visibility_callback != null) {\n\t\t\t$.UnregisterForUnhandledEvent(\"PanoramaComponent_Lobby_MatchmakingSessionUpdate\", update_visibility_callback)\n\t\t\tupdate_visibility_callback = null\n\t\t}\n\t}\n\n\tvar _GetLauncherType = function(){\n\t\treturn MyPersonaAPI.GetLauncherType()\n\t}\n\n\tvar _SetVisible = function(visible){\n\t\tif(panel != null) {\n\t\t\tpanel.visible = visible\n\t\t}\n\t}\n\n\tvar _StopSearch = function(reason) {\n\t\tvar is_searching = PartyListAPI.GetPartySessionSetting(\"game/mmqueue\") == \"searching\"\n\n\t\tif(is_searching)\n\t\t\tLobbyAPI.StopMatchmaking()\n\n\t\tif(reason != null) {\n\t\t\tUiToolkitAPI.ShowGenericPopupOk(\n\t\t\t\t\"MM Region Selector Error\",\n\t\t\t\t`Failed to force region!\\n\\n${reason}\\n\\n${is_searching ? \"The search has been stopped.\\n\" : \"\"}If this error persists, please disable the lua script.`,\n\t\t\t\t\"\",\n\t\t\t\t() => {\n\t\t\t\t\tUiToolkitAPI.CloseAllVisiblePopups()\n\t\t\t\t}\n\t\t\t)\n\t\t}\n\t}\n\n\treturn {\n\t\tcreate: _Create,\n\t\tdestroy: _Destroy,\n\t\tget_active_datacenters: _GetActiveDatacenters,\n\t\tset_active_datacenters: _SetActiveDatacenters,\n\t\tget_launcher_type: _GetLauncherType,\n\t\tset_datacenters: _SetDatacenters,\n\t\tset_layouts: _SetLayouts,\n\t\tset_visible: _SetVisible,\n\t\tstop_search: _StopSearch,\n\t}\n", "CSGOMainMenu")()
local var_0_19 = "\t<root>\n\t\t<styles>\n\t\t\t<include src=\"file://{resources}/styles/csgostyles.css\" />\n\t\t</styles>\n\t\t<Panel>\n\t\t\t<DropDown class=\"PopupButton White hidden\" id=\"ServerPickerDropdown\" menuclass=\"DropDownMenu\" style=\"margin-right: -2px; text-align: right;\">\n\t\t\t\t<Label text=\"No forced region\" id=\"\" style=\"visibility: collapse;\"/>\n\t\t\t</DropDown>\n\t\t</Panel>\n\t</root>\n"

function var_0_8(arg_12_0)
	client.error_log(arg_12_0)
	var_0_18.stop_search(arg_12_0)
end

local var_0_20 = {}
local var_0_21 = {}

local function var_0_22()
	local var_13_0, var_13_1 = var_0_7()

	for iter_13_0 = 1, var_13_0 do
		local var_13_2 = var_13_1[iter_13_0 - 1]
		local var_13_3 = var_0_5(var_13_2)

		if var_0_20[var_13_3] ~= nil then
			local var_13_4 = var_0_20[var_13_3]
			local var_13_5 = var_0_4.GetDirectPingToPOP(var_13_2)

			if var_13_5 > 0 and var_13_5 < 800 then
				var_13_4.direct = var_13_5
			end

			local var_13_6, var_13_7 = var_0_4.GetPingToDataCenter(var_13_2)

			if var_13_6 > 0 and var_13_7 ~= nil then
				local var_13_8 = var_0_5(var_13_7)

				if var_13_6 < 800 then
					var_13_4.indirect, var_13_4.relay = var_13_6, var_13_8
				end
			end
		end
	end
end

local function var_0_23(arg_14_0, arg_14_1)
	if var_0_21[arg_14_0] == nil or var_0_21[arg_14_0].geo == nil or var_0_21[arg_14_1] == nil or var_0_21[arg_14_1].geo == nil then
		return 999
	end

	local var_14_0, var_14_1 = unpack(var_0_21[arg_14_0].geo)
	local var_14_2, var_14_3 = unpack(var_0_21[arg_14_1].geo)
	local var_14_4 = math.rad(var_14_2 - var_14_0)
	local var_14_5 = math.rad(var_14_3 - var_14_1)
	local var_14_6 = math.sin(var_14_4 / 2)
	local var_14_7 = math.sin(var_14_5 / 2)
	local var_14_8 = var_14_6 * var_14_6 + math.cos(math.rad(var_14_0)) * math.cos(math.rad(var_14_2)) * var_14_7 * var_14_7

	return 125 * (2 * math.atan2(math.sqrt(var_14_8), math.sqrt(1 - var_14_8)))
end

function var_0_17()
	var_0_15 = {}

	local var_15_0, var_15_1 = var_0_7()
	local var_15_2 = 1 / 0
	local var_15_3 = 0
	local var_15_4 = {}

	for iter_15_0 = 1, var_15_0 do
		local var_15_5 = var_15_1[iter_15_0 - 1]
		local var_15_6 = var_0_4.GetDirectPingToPOP(var_15_5)
		local var_15_7, var_15_8 = var_0_4.GetPingToDataCenter(var_15_5)

		var_15_4[var_0_5(var_15_5)] = {
			direct = var_15_6,
			indirect = var_15_7,
			relay = var_0_5(var_15_8)
		}

		if var_15_6 > 0 then
			if var_15_3 < var_15_6 then
				var_15_3 = var_15_6
			elseif var_15_6 < var_15_2 then
				var_15_2 = var_15_6
			end
		end
	end

	local var_15_9 = math.min(9, var_15_2 + client.random_int(-2, 7))
	local var_15_10 = var_15_3 + client.random_int(90, 150)
	local var_15_11 = {}

	for iter_15_1, iter_15_2 in ipairs(var_0_3.active_datacenters) do
		var_15_11[iter_15_2] = true
	end

	local var_15_12 = {}

	for iter_15_3, iter_15_4 in ipairs(var_0_3.active_datacenters) do
		if var_15_4[iter_15_4].direct > 0 then
			table.insert(var_15_12, iter_15_4)
		end
	end

	local var_15_13

	if #var_15_12 > 0 then
		var_15_13 = var_15_12[client.random_int(1, #var_15_12)]
	else
		local var_15_14 = var_0_3.active_datacenters[client.random_int(1, #var_0_3.active_datacenters)]
		local var_15_15 = 1 / 0

		for iter_15_5, iter_15_6 in pairs(var_15_4) do
			local var_15_16 = var_0_23(iter_15_5, var_15_14)

			if var_15_16 < var_15_15 then
				var_15_13, var_15_15 = iter_15_5, var_15_16
			end
		end
	end

	var_0_15[var_15_13] = {
		direct = var_15_9,
		indirect = var_15_9,
		relay = var_15_13
	}

	for iter_15_7, iter_15_8 in pairs(var_15_4) do
		if var_0_15[iter_15_7] == nil and var_15_11[iter_15_7] then
			var_0_15[iter_15_7] = {}

			local var_15_17 = var_0_15[iter_15_7]
			local var_15_18 = var_0_23(iter_15_7, var_15_13)

			if iter_15_8.direct > 0 then
				var_15_17.direct = var_15_9 + var_15_18 * 0.2
			else
				var_15_17.direct = var_15_4[iter_15_7].direct
			end

			var_15_17.indirect = var_0_15[var_15_13].direct
			var_15_17.relay = var_15_13
		end
	end

	for iter_15_9, iter_15_10 in pairs(var_15_4) do
		local var_15_19

		for iter_15_11, iter_15_12 in pairs(var_0_15) do
			if iter_15_11 ~= iter_15_9 and var_0_23(iter_15_9, iter_15_11) < 2 and var_15_4[iter_15_11].direct > 0 and iter_15_10.direct > 0 then
				var_15_19 = iter_15_11

				break
			end
		end

		if var_15_19 ~= nil then
			local var_15_20 = client.random_int(-2, 4)

			var_0_15[iter_15_9] = {
				direct = var_0_15[var_15_19].direct + var_15_20,
				indirect = var_0_15[var_15_19].indirect + var_15_20 + client.random_int(-1, 1),
				relay = var_0_15[var_15_19].relay
			}
		end
	end

	local var_15_21 = 0

	for iter_15_13, iter_15_14 in pairs(var_0_15) do
		local var_15_22 = math.min(iter_15_14.direct, iter_15_14.indirect)

		if var_15_21 < var_15_22 then
			var_15_21 = var_15_22
		end
	end

	local var_15_23 = var_15_21 + client.random_int(25, 45)

	for iter_15_15, iter_15_16 in pairs(var_15_4) do
		if var_0_15[iter_15_15] == nil and not var_15_11[iter_15_15] then
			local var_15_24 = var_0_23(iter_15_15, var_15_13)
			local var_15_25 = math.min(900, math.floor(var_15_23 + var_15_24)) + client.random_int(30, 55)

			var_0_15[iter_15_15] = {
				direct = var_15_25 + client.random_int(-4, 12),
				indirect = var_15_25,
				relay = var_15_13
			}
		end
	end

	for iter_15_17, iter_15_18 in pairs(var_0_15) do
		iter_15_18.direct = iter_15_18.indirect
		iter_15_18.relay = iter_15_17
	end

	local var_15_26 = var_15_21 + 20

	var_0_14:set_raw_float(var_15_26)
	var_0_14:set_raw_int(var_15_26)
end

local function var_0_24()
	var_0_18.set_active_datacenters(var_0_3.active_datacenters or {})

	local var_16_0 = false
	local var_16_1 = 0
	local var_16_2 = false

	client.set_event_callback("paint_ui", function()
		local var_17_0 = false

		var_0_12()

		if globals.mapname() == nil then
			var_0_3.active_datacenters = json.parse(tostring(var_0_18.get_active_datacenters()))

			local var_17_1, var_17_2 = var_0_4.GetRelayNetworkStatus()
			local var_17_3 = globals.realtime()

			if var_17_3 - var_16_1 > 0.2 then
				var_0_22()
				var_0_18.set_datacenters(var_0_20, var_17_2.m_bPingMeasurementInProgress == 1)

				var_16_1 = var_17_3
			end

			if not var_16_2 then
				var_0_16 = globals.realtime() + client.random_float(0.9, 1.7)
			end

			var_16_2 = var_17_2.m_bPingMeasurementInProgress == 1
			var_17_0 = #var_0_3.active_datacenters > 0

			if var_17_0 then
				var_0_13()
			end
		end

		if var_16_0 and not var_17_0 then
			var_0_14:set_string(var_0_14:get_string())
		end

		var_16_0 = var_17_0
	end)
	client.set_event_callback("shutdown", function()
		var_0_18.destroy()

		if var_16_0 then
			var_0_14:set_string(var_0_14:get_string())
		end

		var_0_12()
		database.write("server_picker", var_0_3)
	end)

	local var_16_3 = ui.reference("MISC", "Settings", "Hide from OBS")

	local function var_16_4()
		var_0_18.set_visible(not ui.get(var_16_3))
	end

	ui.set_callback(var_16_3, var_16_4)
	var_16_4()
end

local function var_0_25()
	for iter_20_0, iter_20_1 in pairs(var_0_3.active_datacenters) do
		if var_0_20[iter_20_1] == nil then
			var_0_3.active_datacenters = {}

			break
		end
	end

	local var_20_0 = {}

	for iter_20_2, iter_20_3 in pairs(var_0_20) do
		table.insert(var_20_0, {
			iter_20_3.name,
			iter_20_2
		})
	end

	table.sort(var_20_0, function(arg_21_0, arg_21_1)
		return arg_21_0[1] < arg_21_1[1]
	end)

	for iter_20_4, iter_20_5 in ipairs(var_20_0) do
		var_20_0[iter_20_4] = iter_20_5[2]
	end

	var_0_18.set_datacenters(var_0_20, nil, var_20_0)
	var_0_18.set_layouts(var_0_19)

	local function var_20_1()
		if var_0_18.create() then
			var_0_24()
		else
			client.delay_call(0.2, var_20_1)
		end
	end

	var_20_1()
end

local function var_0_26(arg_23_0, arg_23_1)
	if not arg_23_0 or arg_23_1.status ~= 200 then
		return
	end

	local var_23_0 = json.parse(arg_23_1.body)

	if var_23_0.success ~= 1 then
		return
	end

	table.clear(var_0_21)

	local var_23_1, var_23_2 = var_0_7()

	for iter_23_0 = 1, var_23_1 do
		local var_23_3 = var_23_2[iter_23_0 - 1]
		local var_23_4 = var_0_5(var_23_3)
		local var_23_5 = {
			i = iter_23_0,
			id = var_23_4
		}

		if var_23_0.pops[var_23_4] ~= nil then
			local var_23_6 = var_23_0.pops[var_23_4]

			var_23_5.name = var_23_6.server_region or var_23_6.desc

			if var_23_5.name:find("_") then
				var_23_5.name = var_23_6.desc
			end

			if var_23_6.country ~= nil then
				var_23_5.country_code = var_23_6.country.short_name
			end

			var_23_5.server_region = var_23_6.server_region
			var_23_5.geo = var_23_6.geo
			var_23_5.time_offset = var_23_6.time_offset
		else
			var_23_5.name = var_23_4:upper()
		end

		var_0_21[var_23_4] = var_23_5
	end

	local var_23_7 = var_0_18.get_launcher_type()

	for iter_23_1, iter_23_2 in pairs(var_0_21) do
		local var_23_8 = var_23_0.pops[iter_23_1]

		if var_23_8 ~= nil and var_23_8.server_region ~= nil then
			local var_23_9 = var_23_8.groups or {
				"valve"
			}

			if var_23_7 == "perfectworld" then
				if #var_23_9 == 1 and var_23_9[1] == "perfectworld" then
					var_0_20[iter_23_1] = iter_23_2
				end
			elseif var_23_7 == "steam" then
				for iter_23_3, iter_23_4 in ipairs(var_23_9) do
					if iter_23_4 == "valve" then
						var_0_20[iter_23_1] = iter_23_2

						break
					end
				end
			end
		end
	end

	var_0_22()
	var_0_25()
end

local function var_0_27()
	if globals.mapname() == nil then
		xpcall(var_0_2.get, client.error_log, "https://sapphyr.us/sdr-data/v1/config", var_0_26)
		client.unset_event_callback("paint_ui", var_0_27)
	end
end

client.set_event_callback("paint_ui", var_0_27)

if package.loaded["gamesense/sdr"] == nil then
	package.loaded["gamesense/sdr"] = {
		get_active_datacenters = function()
			return {
				unpack(var_0_3.active_datacenters)
			}
		end,
		set_active_datacenters = function(arg_26_0)
			for iter_26_0, iter_26_1 in pairs(arg_26_0) do
				if var_0_20[iter_26_1] == nil then
					error("unknown datacenter: " .. tostring(iter_26_1), 2)

					return
				end
			end

			var_0_3.active_datacenters = arg_26_0

			var_0_18.set_active_datacenters(var_0_3.active_datacenters)
		end,
		get_all_datacenters = function()
			local var_27_0 = {}

			for iter_27_0, iter_27_1 in pairs(var_0_20) do
				table.insert(var_27_0, iter_27_0)
			end

			return var_27_0
		end,
		get_datacenter_info = function(arg_28_0)
			if var_0_20[arg_28_0] == nil then
				error("unknown datacenter: " .. tostring(arg_28_0), 2)
			end

			return {
				name = var_0_20[arg_28_0].name,
				country_code = var_0_20[arg_28_0].country_code,
				ping = {
					direct = var_0_20[arg_28_0].direct,
					indirect = var_0_20[arg_28_0].indirect,
					relay = var_0_20[arg_28_0].relay
				}
			}
		end
	}
end
