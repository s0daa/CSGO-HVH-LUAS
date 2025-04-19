slot0 = require("gamesense/http")
slot1 = require("table.clear")

function slot2(slot0)
	slot1 = {}
	slot2 = nil

	for slot6 in slot0:gmatch("[^\r\n]+") do
		if slot6:match("^%[([^%[%]]+)%]$") then
			slot2 = tonumber(slot7) and tonumber(slot7) or slot7
			slot1[slot2] = slot1[slot2] or {}
		end

		slot8, slot9 = slot6:match("^([%w|_]+)%s-=%s-(.+)$")

		if slot8 and slot9 ~= nil then
			if tonumber(slot9) then
				slot9 = tonumber(slot9)
			elseif slot9 == "true" then
				slot9 = true
			elseif slot9 == "false" then
				slot9 = false
			end

			if tonumber(slot8) then
				slot8 = tonumber(slot8)
			end

			slot1[slot2][slot8] = slot9
		end
	end

	return slot1
end

panorama.loadstring([[
	var panel_custom, html
	var playing = false;
	var volume = 1;
	var schedule_handles = []

	var _Create = function(layout){
		var panel_parent = $.GetContextPanel().FindChildTraverse("NewsPanelLister")

		panel_custom = $.CreatePanel('Panel', panel_parent, 'RadioPanel')
		if (panel_custom != null) {
			if (panel_custom.BLoadLayoutFromString(layout, false, false)) {
				panel_custom.visible = false

				html = panel_custom.FindChildTraverse("RadioHTML")
			}
		}
	}

	var _Destroy = function(){
		if (panel_custom != null){
			panel_custom.RemoveAndDeleteChildren()
			panel_custom.DeleteAsync(0.0)
			panel_custom = null
		}

		schedule_handles.forEach(function(handle){
			try{
				$.CancelScheduled(handle)
			} catch(e){

			}
		})
	}

	var _SetURL = function(url){
		// $.Msg("playing " + url)
		html.SetURL(url)

		var apply = function(){
			html.RunJavascript(`document.addEventListener("DOMContentLoaded", function(){ document.body.children[0].volume = ${volume}; document.body.children[0].autoplay = ${playing == true}; });`)
			_SetPlaying()
			_SetVolume()
		}

		apply()
		for(i=1; i<12; i++){
			schedule_handles.push($.Schedule(i*0.5, apply))
		}
	}

	var _SetPlaying = function(_playing){
		if(_playing != null)
			playing = _playing

		html.RunJavascript(`document.body.children[0].${playing ? "play" : "pause"}()`)
	}

	var _SetVolume = function(_volume){
		if(_volume != null)
			volume = _volume

		html.RunJavascript(`document.body.children[0].volume = ${volume}`)
	}

	return {
		create: _Create,
		destroy: _Destroy,
		set_url: _SetURL,
		set_playing: _SetPlaying,
		set_volume: _SetVolume
	}
]], "CSGOMainMenu")().create([[
<root>
	<styles>
		<include src="file://{resources}/styles/csgostyles.css" />
	</styles>
	<Panel>
		<HTML id="RadioHTML" acceptsinput="true" acceptsfocus="true" focusonhover="true" mousetracking="true" url="about:blank" style="width: 300px; height: 100px; border: 1px solid red;" />
	</Panel>
</root>
]])
client.set_event_callback("shutdown", function ()
	uv0.destroy()
end)

slot5, slot6 = nil
slot7 = {}
slot8 = {}
slot9 = {}
slot10, slot11, slot12, slot13 = nil

function slot14(slot0, slot1)
	return string.format(slot1 or "Failed to fetch url: %s", slot0.status == 0 and "Request failed" or slot0.status .. " " .. (slot0.status_message or ""))
end

function slot15(slot0)
	uv0.get("https://feed.tunein.com/profiles/" .. slot0 .. "/nowPlaying", function (slot0, slot1)
		if slot0 and slot1.status == 200 and (json.parse(slot1.body).status == nil or slot2.status == 200) and slot2.Header and slot2.Header.Subtitle and uv0 == uv1 then
			uv2 = tostring(slot2.Header.Subtitle)

			if slot2.Header ~= nil and slot2.Header.Title ~= nil then
				uv3[uv1] = tostring(slot2.Header.Title)
			end

			uv4[uv1] = {
				title = slot2.Header and tostring(slot2.Header.Title) or nil,
				subtitle = slot2.Header and tostring(slot2.Header.Subtitle) or nil,
				image = slot2.Secondary and tostring(slot2.Secondary.Image) or nil,
				station_title = slot2.Primary and tostring(slot2.Primary.Title) or nil,
				station_subtitle = slot2.Primary and tostring(slot2.Primary.Subtitle) or nil,
				station_image = slot2.Primary and tostring(slot2.Primary.Image) or nil,
				station_url = slot2.Link and tostring(slot2.Link.WebUrl) or nil
			}

			uv5()

			if slot2.Ttl then
				client.delay_call(slot2.Ttl, function ()
					if uv0 == uv1 then
						uv2(uv1)
					end
				end)
			end
		end
	end)
end

function slot12(slot0, slot1)
	if slot1 == uv0 then
		if slot0 == false then
			uv1 = nil
		elseif slot0 ~= nil then
			uv1 = slot0
		end
	end

	if uv2[uv0] == nil or uv3 == nil then
		uv2[uv0] = false

		if uv4[uv0] ~= nil then
			uv3 = uv4[uv0]
		end

		uv5(uv0)
	end

	if uv2[uv0] == false then
		ui.set(uv6, "Loading title for " .. uv0 .. "...")
	else
		ui.set(uv6, uv2[uv0] or "Unknown")
	end

	if uv1 ~= nil then
		ui.set(uv7, uv1)
	elseif uv3 ~= nil then
		ui.set(uv7, uv3)
	else
		ui.set(uv7, " ")
	end
end

function slot16(slot0, slot1, slot2)
	if slot1 and slot2.status == 200 and slot2.headers["Content-Type"]:find("audio/x%-mpegurl") and uv0 == slot0 then
		uv1.head(slot2.body:match("[^\r\n]+"), {
			absolute_timeout = 60,
			network_timeout = 30
		}, function (slot0, slot1)
			slot2 = slot1.headers["Content-Type"] or ""
			slot3 = slot2:find("audio/x%-scpls")

			if slot1.status == 200 and (slot3 or slot2:find("audio/x%-mpegurl")) and uv0 == uv1 then
				uv2("Resolving " .. slot3 and "playlist file" or "nested m3u" .. "...", uv1)
				uv3.get(uv4, function (slot0, slot1)
					if slot0 and slot1.status == 200 and uv0 == uv1 then
						if uv2 then
							if uv3(slot1.body).playlist and slot2.playlist.File1 then
								uv4.set_url(slot2.playlist.File1)
								uv5(false, uv1)
							end
						elseif uv6 then
							uv7(uv1, slot0, slot1)
						end
					end
				end)
			elseif slot1.status == 200 or slot1.status == 405 or slot1.status == 400 or slot1.status == 403 then
				uv6.set_url(uv4)
				uv2(false, uv1)
			else
				uv2(string.format("[%s] %s", uv0, uv8(slot1, "Failed to fetch url: %s")), uv1)
			end
		end)

		return
	end

	uv2(string.format("[%s] %s", uv0, uv6(slot2, "Failed to fetch m3u: %s")), slot0)
end

function slot17(slot0)
	uv0 = nil
	uv1 = slot0

	uv2("Loading m3u...", slot0)
	uv3.set_url("about:blank")
	uv4.get("https://opml.radiotime.com/Tune.ashx", {
		params = {
			id = uv1
		}
	}, function (...)
		return uv0(uv1, ...)
	end)
end

function slot18(slot0, slot1)
	slot2 = "https://opml.radiotime.com/Browse.ashx"
	slot3 = {
		params = {
			render = "json",
			c = "local"
		}
	}
	slot4 = true

	if slot0:gsub(" ", ""):len() > 0 then
		slot4 = false
		slot3 = {
			params = {
				render = "json",
				query = slot0
			}
		}
		slot2 = "https://opml.radiotime.com/Search.ashx"
	end

	uv0.get(slot2, slot3, function (slot0, slot1)
		if slot0 and slot1.status == 200 then
			if type(json.parse(slot1.body)) == "table" and type(slot2.head) == "table" and slot2.head.status == "200" and slot2.body then
				slot3 = {}

				if type(uv0 and slot2.body[1].children or slot2.body) == "table" then
					for slot8 = 1, #slot4 do
						if slot4[slot8].item == "station" then
							table.insert(slot3, slot9)
						end
					end
				end

				uv1(uv0 and "Browse: " .. slot2.head.title or slot2.head.title, slot3)
			end
		else
			uv1(uv2(slot1, "Search failed: %s"), nil)
		end
	end)
end

slot19, slot20 = nil
slot21 = false
slot22, slot23 = nil
slot25 = ui.new_string("Radio: station", "")
slot26 = ui.new_string("Radio: search text", "")
slot10 = ui.new_label("LUA", "A", " --                  Radio disabled                 -- ")
slot11 = ui.new_label("LUA", "A", " --            Select a station below           --")
slot28 = ui.new_button("LUA", "A", "▶️  Play   ", function ()
	if uv0 ~= nil then
		uv1 = true

		uv2.set_playing(uv1)
		uv3()
	end
end)
slot29 = ui.new_button("LUA", "A", "||  Pause", function ()
	if uv0 ~= nil then
		uv1 = false

		uv2.set_playing(uv1)
		uv3()
	end
end)
slot30 = ui.new_button("LUA", "A", "Show station selector", function ()
	if uv0 == nil then
		uv1("", uv2)
	end

	uv0 = true

	uv3()
end)
slot31, slot32 = nil
slot33 = ui.new_label("LUA", "A", "Search for a station")
slot34 = ui.new_textbox("LUA", "A", "Station name")
slot35 = ui.new_button("LUA", "A", "Search", function ()
	uv0 = nil

	ui.update(uv2, {})
	ui.set(uv2, 0)
	ui.set(uv3, "Loading...")
	uv4(ui.get(uv1), uv5)
end)
slot32 = ui.new_label("LUA", "A", "Search results")
slot31 = ui.new_listbox("LUA", "A", "Search results", {})
slot36 = ui.new_button("LUA", "A", "Switch", function ()
	if uv0 ~= nil and ui.get(uv1) ~= nil and uv0[slot0 + 1] ~= nil then
		uv2(slot1)

		uv3 = false

		uv4()
	end
end)
slot37 = ui.new_button("LUA", "A", "Back", function ()
	uv0 = false

	uv1()
end)

function slot23(slot0, slot1)
	if uv0 == nil then
		uv0 = {}
	else
		uv1(uv0)
	end

	slot2 = {}

	if slot1 ~= nil then
		for slot6 = 1, #slot1 do
			slot7 = slot1[slot6]
			uv2[slot7.preset_id] = slot7.text
			uv3[slot7.preset_id] = slot7.subtext

			table.insert(slot2, slot7.text)

			uv0[slot6] = slot7.preset_id
		end
	end

	ui.set(uv4, slot0)
	ui.update(uv5, slot2)
end

function slot22()
	if not ui.get(uv0) then
		uv1 = nil

		if uv2 == true then
			uv2 = false
		end

		uv3.set_url("about:blank")
	end

	if uv1 == nil then
		if ui.get(uv4) ~= nil and slot1 ~= "" then
			uv5(slot1)
		end

		slot2 = ui.get(uv6)

		if ui.get(uv7) == "" and slot2 ~= "" then
			ui.set(uv7, slot2)
		end
	end

	if uv1 ~= nil then
		ui.set(uv4, uv1)
	end

	ui.set(uv6, ui.get(uv7))
	ui.set_visible(uv8, slot0 and not uv2)
	ui.set_visible(uv9, slot0 and not uv2)
	ui.set_visible(uv10, slot0 and not uv2)
	ui.set_visible(uv11, slot0 and not uv2 and not uv12)
	ui.set_visible(uv13, slot0 and not uv2 and uv12)
	ui.set_visible(uv14, slot0 and not uv2)
	ui.set_visible(uv15, slot0 and uv2)
	ui.set_visible(uv7, slot0 and uv2)
	ui.set_visible(uv16, slot0 and uv2)
	ui.set_visible(uv17, slot0 and uv2)
	ui.set_visible(uv18, slot0 and uv2)
	ui.set_visible(uv19, slot0 and uv2)
	ui.set_visible(uv20, slot0 and uv2)
end

function slot38()
	uv1.set_volume(ui.get(uv0) / 100)
end

slot38()
slot22()
client.delay_call(0, slot22)
ui.set_callback(ui.new_checkbox("LUA", "A", "Internet Radio"), slot22)
ui.set_callback(ui.new_slider("LUA", "A", "Volume", 0, 100, 15, true, "%"), slot38)

if package.loaded["gamesense/radio"] == nil then
	package.loaded["gamesense/radio"] = {
		get_status = function ()
			slot0 = {
				volume = ui.get(uv0) / 100,
				playing = uv1,
				id = uv2
			}

			if uv2 ~= nil and uv3[uv2] ~= nil then
				for slot4, slot5 in pairs(uv3[uv2]) do
					slot0[slot4] = slot5
				end
			end

			return slot0
		end
	}
end
