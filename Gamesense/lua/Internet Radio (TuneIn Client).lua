local var_0_0 = require("gamesense/http")
local var_0_1 = require("table.clear")

local function var_0_2(arg_1_0)
	local var_1_0 = {}
	local var_1_1

	for iter_1_0 in arg_1_0:gmatch("[^\r\n]+") do
		local var_1_2 = iter_1_0:match("^%[([^%[%]]+)%]$")

		if var_1_2 then
			var_1_1 = tonumber(var_1_2) and tonumber(var_1_2) or var_1_2
			var_1_0[var_1_1] = var_1_0[var_1_1] or {}
		end

		local var_1_3, var_1_4 = iter_1_0:match("^([%w|_]+)%s-=%s-(.+)$")

		if var_1_3 and var_1_4 ~= nil then
			if tonumber(var_1_4) then
				var_1_4 = tonumber(var_1_4)
			elseif var_1_4 == "true" then
				var_1_4 = true
			elseif var_1_4 == "false" then
				var_1_4 = false
			end

			if tonumber(var_1_3) then
				var_1_3 = tonumber(var_1_3)
			end

			var_1_0[var_1_1][var_1_3] = var_1_4
		end
	end

	return var_1_0
end

local var_0_3 = panorama.loadstring("\tvar panel_custom, html\n\tvar playing = false;\n\tvar volume = 1;\n\tvar schedule_handles = []\n\n\tvar _Create = function(layout){\n\t\tvar panel_parent = $.GetContextPanel().FindChildTraverse(\"NewsPanelLister\")\n\n\t\tpanel_custom = $.CreatePanel('Panel', panel_parent, 'RadioPanel')\n\t\tif (panel_custom != null) {\n\t\t\tif (panel_custom.BLoadLayoutFromString(layout, false, false)) {\n\t\t\t\tpanel_custom.visible = false\n\n\t\t\t\thtml = panel_custom.FindChildTraverse(\"RadioHTML\")\n\t\t\t}\n\t\t}\n\t}\n\n\tvar _Destroy = function(){\n\t\tif (panel_custom != null){\n\t\t\tpanel_custom.RemoveAndDeleteChildren()\n\t\t\tpanel_custom.DeleteAsync(0.0)\n\t\t\tpanel_custom = null\n\t\t}\n\n\t\tschedule_handles.forEach(function(handle){\n\t\t\ttry{\n\t\t\t\t$.CancelScheduled(handle)\n\t\t\t} catch(e){\n\n\t\t\t}\n\t\t})\n\t}\n\n\tvar _SetURL = function(url){\n\t\t// $.Msg(\"playing \" + url)\n\t\thtml.SetURL(url)\n\n\t\tvar apply = function(){\n\t\t\thtml.RunJavascript(`document.addEventListener(\"DOMContentLoaded\", function(){ document.body.children[0].volume = ${volume}; document.body.children[0].autoplay = ${playing == true}; });`)\n\t\t\t_SetPlaying()\n\t\t\t_SetVolume()\n\t\t}\n\n\t\tapply()\n\t\tfor(i=1; i<12; i++){\n\t\t\tschedule_handles.push($.Schedule(i*0.5, apply))\n\t\t}\n\t}\n\n\tvar _SetPlaying = function(_playing){\n\t\tif(_playing != null)\n\t\t\tplaying = _playing\n\n\t\thtml.RunJavascript(`document.body.children[0].${playing ? \"play\" : \"pause\"}()`)\n\t}\n\n\tvar _SetVolume = function(_volume){\n\t\tif(_volume != null)\n\t\t\tvolume = _volume\n\n\t\thtml.RunJavascript(`document.body.children[0].volume = ${volume}`)\n\t}\n\n\treturn {\n\t\tcreate: _Create,\n\t\tdestroy: _Destroy,\n\t\tset_url: _SetURL,\n\t\tset_playing: _SetPlaying,\n\t\tset_volume: _SetVolume\n\t}\n", "CSGOMainMenu")()
local var_0_4 = "<root>\n\t<styles>\n\t\t<include src=\"file://{resources}/styles/csgostyles.css\" />\n\t</styles>\n\t<Panel>\n\t\t<HTML id=\"RadioHTML\" acceptsinput=\"true\" acceptsfocus=\"true\" focusonhover=\"true\" mousetracking=\"true\" url=\"about:blank\" style=\"width: 300px; height: 100px; border: 1px solid red;\" />\n\t</Panel>\n</root>\n"

var_0_3.create(var_0_4)
client.set_event_callback("shutdown", function()
	var_0_3.destroy()
end)

local var_0_5
local var_0_6
local var_0_7 = {}
local var_0_8 = {}
local var_0_9 = {}
local var_0_10
local var_0_11
local var_0_12
local var_0_13

local function var_0_14(arg_3_0, arg_3_1)
	return string.format(arg_3_1 or "Failed to fetch url: %s", arg_3_0.status == 0 and "Request failed" or arg_3_0.status .. " " .. (arg_3_0.status_message or ""))
end

local function var_0_15(arg_4_0)
	var_0_0.get("https://feed.tunein.com/profiles/" .. arg_4_0 .. "/nowPlaying", function(arg_5_0, arg_5_1)
		if arg_5_0 and arg_5_1.status == 200 then
			local var_5_0 = json.parse(arg_5_1.body)

			if (var_5_0.status == nil or var_5_0.status == 200) and var_5_0.Header and var_5_0.Header.Subtitle and arg_4_0 == var_0_5 then
				var_0_6 = tostring(var_5_0.Header.Subtitle)

				if var_5_0.Header ~= nil and var_5_0.Header.Title ~= nil then
					var_0_7[var_0_5] = tostring(var_5_0.Header.Title)
				end

				var_0_9[var_0_5] = {
					title = var_5_0.Header and tostring(var_5_0.Header.Title) or nil,
					subtitle = var_5_0.Header and tostring(var_5_0.Header.Subtitle) or nil,
					image = var_5_0.Secondary and tostring(var_5_0.Secondary.Image) or nil,
					station_title = var_5_0.Primary and tostring(var_5_0.Primary.Title) or nil,
					station_subtitle = var_5_0.Primary and tostring(var_5_0.Primary.Subtitle) or nil,
					station_image = var_5_0.Primary and tostring(var_5_0.Primary.Image) or nil,
					station_url = var_5_0.Link and tostring(var_5_0.Link.WebUrl) or nil
				}

				var_0_12()

				if var_5_0.Ttl then
					client.delay_call(var_5_0.Ttl, function()
						if arg_4_0 == var_0_5 then
							var_0_15(var_0_5)
						end
					end)
				end
			end
		end
	end)
end

function var_0_12(arg_7_0, arg_7_1)
	if arg_7_1 == var_0_5 then
		if arg_7_0 == false then
			var_0_13 = nil
		elseif arg_7_0 ~= nil then
			var_0_13 = arg_7_0
		end
	end

	if var_0_7[var_0_5] == nil or var_0_6 == nil then
		var_0_7[var_0_5] = false

		if var_0_8[var_0_5] ~= nil then
			var_0_6 = var_0_8[var_0_5]
		end

		var_0_15(var_0_5)
	end

	if var_0_7[var_0_5] == false then
		ui.set(var_0_10, "Loading title for " .. var_0_5 .. "...")
	else
		ui.set(var_0_10, var_0_7[var_0_5] or "Unknown")
	end

	if var_0_13 ~= nil then
		ui.set(var_0_11, var_0_13)
	elseif var_0_6 ~= nil then
		ui.set(var_0_11, var_0_6)
	else
		ui.set(var_0_11, " ")
	end
end

local function var_0_16(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1 and arg_8_2.status == 200 and arg_8_2.headers["Content-Type"]:find("audio/x%-mpegurl") and var_0_5 == arg_8_0 then
		local var_8_0 = arg_8_2.body:match("[^\r\n]+")

		var_0_0.head(var_8_0, {
			network_timeout = 30,
			absolute_timeout = 60
		}, function(arg_9_0, arg_9_1)
			local var_9_0 = arg_9_1.headers["Content-Type"] or ""
			local var_9_1 = var_9_0:find("audio/x%-scpls")
			local var_9_2 = var_9_0:find("audio/x%-mpegurl")

			if arg_9_1.status == 200 and (var_9_1 or var_9_2) and var_0_5 == arg_8_0 then
				var_0_12("Resolving " .. var_9_1 and "playlist file" or "nested m3u" .. "...", arg_8_0)
				var_0_0.get(var_8_0, function(arg_10_0, arg_10_1)
					if arg_10_0 and arg_10_1.status == 200 and var_0_5 == arg_8_0 then
						if var_9_1 then
							local var_10_0 = var_0_2(arg_10_1.body)

							if var_10_0.playlist and var_10_0.playlist.File1 then
								var_0_3.set_url(var_10_0.playlist.File1)
								var_0_12(false, arg_8_0)
							end
						elseif var_9_2 then
							var_0_16(arg_8_0, arg_10_0, arg_10_1)
						end
					end
				end)
			elseif arg_9_1.status == 200 or arg_9_1.status == 405 or arg_9_1.status == 400 or arg_9_1.status == 403 then
				var_0_3.set_url(var_8_0)
				var_0_12(false, arg_8_0)
			else
				var_0_12(string.format("[%s] %s", var_0_5, var_0_14(arg_9_1, "Failed to fetch url: %s")), arg_8_0)
			end
		end)
	else
		var_0_12(string.format("[%s] %s", var_0_5, var_0_14(arg_8_2, "Failed to fetch m3u: %s")), arg_8_0)
	end
end

local function var_0_17(arg_11_0)
	var_0_6 = nil
	var_0_5 = arg_11_0

	var_0_12("Loading m3u...", arg_11_0)
	var_0_3.set_url("about:blank")
	var_0_0.get("https://opml.radiotime.com/Tune.ashx", {
		params = {
			id = var_0_5
		}
	}, function(...)
		return var_0_16(arg_11_0, ...)
	end)
end

local function var_0_18(arg_13_0, arg_13_1)
	local var_13_0 = "https://opml.radiotime.com/Browse.ashx"
	local var_13_1 = {
		params = {
			c = "local",
			render = "json"
		}
	}
	local var_13_2 = true

	if arg_13_0:gsub(" ", ""):len() > 0 then
		var_13_0, var_13_1, var_13_2 = "https://opml.radiotime.com/Search.ashx", {
			params = {
				render = "json",
				query = arg_13_0
			}
		}, false
	end

	var_0_0.get(var_13_0, var_13_1, function(arg_14_0, arg_14_1)
		if arg_14_0 and arg_14_1.status == 200 then
			local var_14_0 = json.parse(arg_14_1.body)

			if type(var_14_0) == "table" and type(var_14_0.head) == "table" and var_14_0.head.status == "200" and var_14_0.body then
				local var_14_1 = {}
				local var_14_2 = var_13_2 and var_14_0.body[1].children or var_14_0.body

				if type(var_14_2) == "table" then
					for iter_14_0 = 1, #var_14_2 do
						local var_14_3 = var_14_2[iter_14_0]

						if var_14_3.item == "station" then
							table.insert(var_14_1, var_14_3)
						end
					end
				end

				arg_13_1(var_13_2 and "Browse: " .. var_14_0.head.title or var_14_0.head.title, var_14_1)
			end
		else
			arg_13_1(var_0_14(arg_14_1, "Search failed: %s"), nil)
		end
	end)
end

local var_0_19
local var_0_20
local var_0_21 = false
local var_0_22
local var_0_23
local var_0_24 = ui.new_checkbox("LUA", "A", "Internet Radio")
local var_0_25 = ui.new_string("Radio: station", "")
local var_0_26 = ui.new_string("Radio: search text", "")

var_0_10 = ui.new_label("LUA", "A", " --                  Radio disabled                 -- ")
var_0_11 = ui.new_label("LUA", "A", " --            Select a station below           --")

local var_0_27 = ui.new_slider("LUA", "A", "Volume", 0, 100, 15, true, "%")
local var_0_28 = ui.new_button("LUA", "A", "▶️  Play   ", function()
	if var_0_5 ~= nil then
		var_0_21 = true

		var_0_3.set_playing(var_0_21)
		var_0_22()
	end
end)
local var_0_29 = ui.new_button("LUA", "A", "||  Pause", function()
	if var_0_5 ~= nil then
		var_0_21 = false

		var_0_3.set_playing(var_0_21)
		var_0_22()
	end
end)
local var_0_30 = ui.new_button("LUA", "A", "Show station selector", function()
	if var_0_20 == nil then
		var_0_18("", var_0_23)
	end

	var_0_20 = true

	var_0_22()
end)
local var_0_31
local var_0_32
local var_0_33 = ui.new_label("LUA", "A", "Search for a station")
local var_0_34 = ui.new_textbox("LUA", "A", "Station name")
local var_0_35 = ui.new_button("LUA", "A", "Search", function()
	var_0_19 = nil

	local var_18_0 = ui.get(var_0_34)

	ui.update(var_0_31, {})
	ui.set(var_0_31, 0)
	ui.set(var_0_32, "Loading...")
	var_0_18(var_18_0, var_0_23)
end)

var_0_32 = ui.new_label("LUA", "A", "Search results")
var_0_31 = ui.new_listbox("LUA", "A", "Search results", {})

local var_0_36 = ui.new_button("LUA", "A", "Switch", function()
	if var_0_19 ~= nil then
		local var_19_0 = ui.get(var_0_31)

		if var_19_0 ~= nil then
			local var_19_1 = var_0_19[var_19_0 + 1]

			if var_19_1 ~= nil then
				var_0_17(var_19_1)

				var_0_20 = false

				var_0_22()
			end
		end
	end
end)
local var_0_37 = ui.new_button("LUA", "A", "Back", function()
	var_0_20 = false

	var_0_22()
end)

function var_0_23(arg_21_0, arg_21_1)
	if var_0_19 == nil then
		var_0_19 = {}
	else
		var_0_1(var_0_19)
	end

	local var_21_0 = {}

	if arg_21_1 ~= nil then
		for iter_21_0 = 1, #arg_21_1 do
			local var_21_1 = arg_21_1[iter_21_0]

			var_0_7[var_21_1.preset_id] = var_21_1.text
			var_0_8[var_21_1.preset_id] = var_21_1.subtext

			table.insert(var_21_0, var_21_1.text)

			var_0_19[iter_21_0] = var_21_1.preset_id
		end
	end

	ui.set(var_0_32, arg_21_0)
	ui.update(var_0_31, var_21_0)
end

function var_0_22()
	local var_22_0 = ui.get(var_0_24)

	if not var_22_0 then
		var_0_5 = nil

		if var_0_20 == true then
			var_0_20 = false
		end

		var_0_3.set_url("about:blank")
	end

	if var_0_5 == nil then
		local var_22_1 = ui.get(var_0_25)

		if var_22_1 ~= nil and var_22_1 ~= "" then
			var_0_17(var_22_1)
		end

		local var_22_2 = ui.get(var_0_26)

		if ui.get(var_0_34) == "" and var_22_2 ~= "" then
			ui.set(var_0_34, var_22_2)
		end
	end

	if var_0_5 ~= nil then
		ui.set(var_0_25, var_0_5)
	end

	ui.set(var_0_26, ui.get(var_0_34))
	ui.set_visible(var_0_10, var_22_0 and not var_0_20)
	ui.set_visible(var_0_11, var_22_0 and not var_0_20)
	ui.set_visible(var_0_27, var_22_0 and not var_0_20)
	ui.set_visible(var_0_28, var_22_0 and not var_0_20 and not var_0_21)
	ui.set_visible(var_0_29, var_22_0 and not var_0_20 and var_0_21)
	ui.set_visible(var_0_30, var_22_0 and not var_0_20)
	ui.set_visible(var_0_33, var_22_0 and var_0_20)
	ui.set_visible(var_0_34, var_22_0 and var_0_20)
	ui.set_visible(var_0_35, var_22_0 and var_0_20)
	ui.set_visible(var_0_32, var_22_0 and var_0_20)
	ui.set_visible(var_0_31, var_22_0 and var_0_20)
	ui.set_visible(var_0_36, var_22_0 and var_0_20)
	ui.set_visible(var_0_37, var_22_0 and var_0_20)
end

local function var_0_38()
	local var_23_0 = ui.get(var_0_27) / 100

	var_0_3.set_volume(var_23_0)
end

var_0_38()
var_0_22()
client.delay_call(0, var_0_22)
ui.set_callback(var_0_24, var_0_22)
ui.set_callback(var_0_27, var_0_38)

if package.loaded["gamesense/radio"] == nil then
	package.loaded["gamesense/radio"] = {
		get_status = function()
			local var_24_0 = {
				volume = ui.get(var_0_27) / 100,
				playing = var_0_21,
				id = var_0_5
			}

			if var_0_5 ~= nil and var_0_9[var_0_5] ~= nil then
				for iter_24_0, iter_24_1 in pairs(var_0_9[var_0_5]) do
					var_24_0[iter_24_0] = iter_24_1
				end
			end

			return var_24_0
		end
	}
end
