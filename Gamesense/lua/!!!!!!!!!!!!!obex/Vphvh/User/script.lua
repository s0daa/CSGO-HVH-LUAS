-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local bit = require "bit"
local antiaim_funcs = require "gamesense/antiaim_funcs"
local ffi = require "ffi"
local vector = require "vector"
local base64 = require "gamesense/base64"
local clipboard = require "gamesense/clipboard"
local csgo_weapons = require "gamesense/csgo_weapons"
local http = require "gamesense/http"
local surface = require("gamesense/surface")
local js = panorama.open()
local images = require "gamesense/images"
local ent = require "gamesense/entity"

local main = function()
	tab, container = "AA", "Anti-aimbot angles"
	set, get = ui.set, ui.get
	local elements = {}
	local antibrute = {}
	local aa_tab
	local vis_tab
	local misc_tab
	local back_tab	
	local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'nightly'}

	local reference = {
		antiaim = {
			enabled = ui.reference(tab, container, "Enabled"),
			pitch = ui.reference(tab, container, "pitch"),
			yawbase = ui.reference(tab, container, "Yaw base"),
			yaw = {ui.reference(tab, container, "Yaw")},
			fakeyawlimit = 60,
			fsbodyyaw = ui.reference(tab, container, "Freestanding body yaw"),
			edgeyaw = ui.reference(tab, container, "Edge yaw"),
			yaw_jitt = {ui.reference(tab, container, "Yaw jitter")},
			body_yaw = {ui.reference(tab, container, "Body yaw")},
			freestand = {ui.reference(tab, container, "Freestanding")},
			roll = ui.reference(tab, container, "Roll"),
			edge = ui.reference(tab, container, "Edge yaw"),
		},

		fakelag = {
			fl_limit = ui.reference(tab, "Fake lag", "Limit"),
			fl_amount = ui.reference(tab, "Fake lag", "Amount"),
			enablefl = ui.reference(tab,"Fake lag","Enabled"),
			fl_var = ui.reference(tab, "Fake lag", "Variance"),
			fakelag = {ui.reference(tab, "Fake lag", "Limit")},
		},
		
		rage = {
			dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
			os = {ui.reference(tab, "Other", "On shot anti-aim")},
			lm = ui.reference(tab,"Other","Leg movement"),
			fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
			safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
			forcebaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
			quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
			slow = {ui.reference(tab, "Other", "Slow motion")},
			sw, slowwalk = ui.reference("AA","Other","Slow motion"),
			damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
			damage_override = {ui.reference("RAGE", "Aimbot", "Minimum damage override")},
			ping_spike = {ui.reference('MISC', 'Miscellaneous', 'Ping spike')},
			air_strafe = ui.reference("Misc", "Movement", "Air strafe"),
			dt_fakelag = ui.reference("RAGE", "Aimbot", "Double tap fake lag limit"),
			third_person = {ui.reference('VISUALS', 'Effects', 'Force third person (alive)')},
			menucolor = ui.reference("MISC", "Settings", "Menu color")
		},
	}

	local vars = {
		state = {"Defensive", "Stand", "Move", "Slow walk", "in air", "Duck", "Air duck"},
		state_to_nmbr = {["Air duck"] = 7, ["Defensive"] = 1, ["Stand"] = 2, ["Move"] = 3, ["Slow walk"] = 4, ["in air"] = 5, ["Duck"] = 6},
		ind_state = "",
		p_state = 1,
		last_press = 0,
		max_desync_amount = 0
	}

	local colors = {
		blue = "\aA9B7FFFF",
		bright = "\aE3E9FFFF",
		grey = "\aFFFFFF8D",
		bright_red = "\aFF9A9AFF",
		white = "\aFFFFFFFF",
		new_blue = "\aBABAF9F7"
	}

	local status = {
		lua = "VICE-PRESIDENT ~ ANTI-AIM SYSTEM",
		build = obex_data.build:lower(),
		last_update = "3.0.1",
		username = obex_data.username:lower(),
	}

	function contains(table, value)
		if table == nil then
			return false
		end
		
		table = get(table)
		for i=0, #table do
			if table[i] == value then
				return true
			end
		end
		return false
	end

	local menuSelectionRefs = {
		welc_label = ui.new_label(tab, container, status.lua),
		empty = ui.new_label(tab, container, "\n"),

		aa_butt = ui.new_button(tab, container, "Anti-aim", function()
			aa_tab = 1
			vis_tab = nil
			misc_tab = nil
			back_tab = nil
		end),

		vis_butt = ui.new_button(tab, container, "Visuals", function()
			vis_tab = 2
			aa_tab = nil
			misc_tab = nil
			back_tab = nil
		end),

		misc_butt = ui.new_button(tab, container, "Misc", function()
			misc_tab = 3
			aa_tab = nil
			vis_tab = nil
			back_tab = nil
		end),

		empty3 = ui.new_label(tab, container, "\n"),


		update_label = ui.new_label(tab, container, "Version ~ ".. status.last_update),
		build_label = ui.new_label(tab, container, "Build ~ "..status.build)
	}

	local _sub = function(input, arg)
		local t = {}
		for m in string.gmatch(input, "([^"..arg.."]+)") do
			t[#t + 1] = string.gsub(m, "\n", "")
		end
		return t
	end

	local _string = function(arg)
		arg = get(arg)
		local m = ""
		for i=1, #arg do
			m = m .. arg[i] .. (i == #arg and "" or ",")
		end
	
		if m == "" then
			m = "-"
		end
	
		return m
	end

	local _boolean = function(m)
		if m == "true" or m == "false" then
			return (m == "true")
		else
			return m
		end
	end

	local _storing = {}

	_storing.export = {
		['number'] = {},
		['boolean'] = {},
		['table'] = {},
		['string'] = {}
	}

	_storing.pcall = {}

	local store = function(value)
		if type(value) ~= 'number' then
			log('unable to store value, value should be a number')
		end
	
		if type(value) == 'number' then
			table.insert(_storing.export[type(get(value))],value)
		end
	
		if type(value) == 'number' then
			table.insert(_storing.pcall,value)
		end
		return value
	end

	local lastupdate = "unknown"

	local antiaim = {
		tab_handle = ui.new_label(tab, container, "Current tab ~ Anti-aim"),
		additions = ui.new_combobox(tab, container, "\n", "Anti-aim", "Binds", "Settings"),
		configmenu = ui.new_combobox(tab, container, "configs menu", "local", "public", "import/export"),
		listbox = ui.new_listbox(tab, container, "configs", {}),
		createtext = ui.new_textbox(tab, container, "config name"),
		publiclistbox = ui.new_listbox(tab, container, "public configs", {}),
		updatelabel = ui.new_label(tab, container, lastupdate),
		fs = ui.new_hotkey(tab, container, "Freestanding", false),
		lc_break = ui.new_hotkey(tab, container, "Teleport if hit-able", false),
		toggle_manual = ui.new_checkbox(tab, container, "Manual anti-aim"),
		manual_left = ui.new_hotkey(tab, container, "Manual left"),
		manual_right = ui.new_hotkey(tab, container, "Manual right"),
		manual_forward = ui.new_hotkey(tab, container, "Manual forward"),
		manual_reset = ui.new_hotkey(tab, container, "Manual reset"),
		aa_builder = ui.new_checkbox(tab, container, "enable builder"),
		player_state = ui.new_combobox(tab, container, "Player states", vars.state)
	}

	set(antiaim.aa_builder, true)
	
	local vis = {
		vis_menu = ui.new_multiselect(tab, container, "Visual features", "Indicators", "Watermark", "Team skeet arrows", "Console logs", "Screen logs", "Min dmg indicator"),
		show_original_dmg = ui.new_checkbox(tab, container, "Show original damage"),
		arrows_offset = ui.new_slider(tab, container, "Arrows offset",25,200,60, true, "px"),
		notif_color_label = ui.new_label(tab, container, "Notification color"),
		notif_color = ui.new_color_picker(tab, container, "Notif c", 255, 255, 255, 255),
		main_clr_l = ui.new_label(tab, container, "Animation color"),
		main_clr = ui.new_color_picker(tab, container, "main c", 255, 255, 255, 255),
		main_clr_l2 = ui.new_label(tab, container, "Base color"),
		main_clr2 = ui.new_color_picker(tab, container, "main c2", 255, 255, 255, 255),
		watermark_on = ui.new_label(tab, container, "Watermark color"),
		wat_color = ui.new_color_picker(tab, container, "water c", 255, 255, 255, 255),
		side_label = ui.new_label(tab, container, "Fake side color"),
		side_color = ui.new_color_picker(tab, container, "side color", 255, 255, 255, 255),
		manual_aa_labe = ui.new_label(tab, container, "Manual color"),
		manual_aa_color = ui.new_color_picker(tab, container, "manual aa color", 255, 255, 255, 255),
		hit_label = ui.new_label(tab, container, "Hit color"),
		hit_color = ui.new_color_picker(tab, container, "hit c", 255, 255, 255, 255),
		miss_label = ui.new_label(tab, container, "Miss color"),
		miss_color = ui.new_color_picker(tab, container, "miss c", 255, 255, 255, 255),
	}

	local misc = {
		misc_menu = ui.new_multiselect(tab, container, "Misc features", "Anti-knife", "Anti-zeus", "Trashtalk", "Leg breaker", "Moonwalk"),
		knife_distance = ui.new_slider(tab, container, "Anti-knife radius", 0, 1000, 450,true),
		zeus_options = ui.new_combobox(tab, container, "Anti-zeus options", "Pull pistol", "Pull zeus"),
		zeus_distance = ui.new_slider(tab, container, "Anti-zeus radius", 0, 500, 250,true),
	}

	local fl_tab = {													
		advanced_fl = ui.new_checkbox(tab, "Fake lag", "advanced fakelag"),
		fakelag_tab = ui.new_combobox(tab, "Fake lag", "fake lag", "maximum", "dynamic", "alternative"),
		trigger = ui.new_multiselect(tab, "Fake lag", "trigger while", "standing", "moving", "slowwalk", "in air", "on land"),
		triggerlimit = ui.new_slider(tab, "Fake lag", "limit",1,15,15),
		sendlimit = ui.new_slider(tab, "Fake lag", "send limit",1,15,13),
		forcelimit = ui.new_multiselect(tab, "Fake lag", "low fakelag", "while standing", "while shooting", "while os-aa"),
	}

	local notify =
    (function()
    local b = {callback_registered = false, maximum_count = 4, data2 = {}}
    function b:stored_callbacks()
        if self.callback_registered then
            return
        end
        client.set_event_callback(
            "paint_ui",
            function()
                local c = {client.screen_size()}
                local d = {56, 56, 57}
                local e = 5
                local f = self.data2
                for g = #f, 1, -1 do
                    self.data2[g].time = self.data2[g].time - globals.frametime()
                    local h, i = 255, 0
                    local j = f[g]
                    local k = 18
                    local l = 20
                    if j.time < 0 then
                        table.remove(self.data2, g)
                    else
                        local m = j.def_time - j.time
                        local m = m > 1 and 1 or m
                        if j.time < 0.5 or m < 0.5 then
                            i = (m < 1 and m or j.time) / 0.5
                            h = i * 255
                            k = i * 18
                            l = i * 20
                            if i < 0.2 then
                                e = e + 15 * (1.0 - i / 0.2)
                            end
                        end
                        local n, o, p, q = get(vis.notif_color)
                        local r, s = 20, 20
                        local t = '<svg width="554.4" height="649.6" version="1.1" viewBox="0 0 554.4 649.6" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><path d="m273.53 531.63-1.2395-1-9.3067-28.8-4.6424-12-9.818-24-17.748-35.2-8.6508-14.4-15.06-22.4-13.001-16.784-19.226-19.216-13.574-10.574-11.2-7.2366-9.0585-4.8934-13.342-5.418-12.169-3.7597 20.169-13.528 9.6-7.622 9.7313-10.168 5.9613-8.9982 4.6761-11.49 1.8536-10.644-.44579-8.4502-.44578-8.4502-4.2296-17.567-5.4146-16.362-3.4264-8.6192-3.4264-8.6192-11.531-23.496-7.5372-13.304-4.8378-8-12.086-19.2-21.358-31.75.61216-.61215 17.504 13.176 11.2 8.674 24 20.062 23.2 20.715 16.8 15.328 26.449 26.408 9.6565 10.4 16.766 20 7.9794 11.2 2.9747 4.5356 2.9746 4.5356v1.1609l-8.4-7.896-12.975-9.8364-20.234-13.684-10.792-5.4178-12.287-4.9044-2.8566-.53589-2.8566-.53591v.93244l4.1268 9.2456 4.7217 12.8 1.1757 6.7048 1.1757 6.7048-.006 12.99-2.3936 14.758-4.6527 11.712-8.0522 13.994-6.7765 8.3356-8.7112 9.0411.89866 1.4541 14.094 8.5536 12.8 9.9316 12.087 11.02 15.664 17.105 8.6992 10.895 11.805 16.8 11.046 17.6 9.4292 16.8 6.1129 11.2 2.6527 5.2h13.131l10.79-19.6 14.435-24 7.9316-12 9.7475-13.6 14.579-17.6 15.89-16.128 13.6-10.775 18.4-12.278.42665-.1792-10.184-10.541-9.981-14.573-6.3921-13.64-2.0371-8.1431-2.0371-8.1431-.062-18.4 2.1096-8 2.1096-8 7.2467-17.467-.73833-.73832-7.6613 1.8785-11.368 4.6767-11.832 6.6356-8.8 5.7196-20.8 15.067-9.2 8.9784v-1.4415l11.966-17.817 21.136-25.491 40.099-39.849 18.279-16.151 22.521-19.81 25.818-20.99 9.3822-7.2772 10.8-7.6632v.76582l-27.647 41.375-8.2699 13.6-9.9886 17.6-6.2336 12-7.3055 16-4.6248 12-2.6501 8-2.6501 8-1.3152 4.4709-1.3152 4.4709-1.1951 7.9291-1.1951 7.9291-.005 5.9345-.005 5.9345 1.8287 10.531 5.3676 11.792 3.5177 4.9042 3.5177 4.9042 13.368 12.954 23.735 15.578-.40504.40505-.40504.40504-18.925 6.3179-14.174 7.2282-10.16 6.1725-12.466 9.3149-16.602 16.025-13.127 16-11.902 16-9.0454 14.4-11.38 20-15.733 32-3.6731 8.8-3.6731 8.8-5.4866 14.4-6.3764 19.2-3.4474 11.6h-2.8481l-1.2396-1zm-39.27-181.47-3.0032-.70782-7.7678-3.9362-13.046-12.273-9.6518-12.809.37408-.37406.37407-.37407 9.3241 2.0225 13.355 6.9654 9.2924 6.3104 4.9404 5.9936 1.3228 4.0254 1.3228 4.0253.36908 1 .36906 1-4.5712-.1608zm75.805-1.7315.52931-2.6.73607-2.8922.73608-2.8922 7.5964-7.1049 10.259-6.012 10.541-4.8537 8.6625-3.0491.27134.27135.27136.27134-12.746 16.847-8.8057 8.0479-7.4467 4.162-8.097 2.4046h-3.0367z" stroke-width=".8" fill="#ffffff"/></svg>'
                        local u = renderer.load_svg(t, r, s)
                        local v = {renderer.measure_text(nil, j.draw)}
                        local w = {c[1] / 2 - v[1] / 2 + 3, c[2] - c[2] / 100 * 17.4 + e}

                        renderer.blur(w[1] - 22, w[2] - 20, v[1] + 27, 18, 0, 0, 0, h > 255 and 255 or h)
                        renderer.texture(u, w[1] - 22, w[2] - 21, r, s, n, o, p, h)
                        renderer.texture(u, w[1] - 22, w[2] - 21, r, s, n, o, p, h)
                        renderer.texture(u, w[1] - 22, w[2] - 21, r, s, n, o, p, h)
                        renderer.text(w[1] + v[1] / 2, w[2] - 12, 255, 255, 255, h, "c", nil, j.draw)
                        
						for x = 0, 8 do
                            local x = x / 2
                            renderer.rectangle(w[1] - 22, w[2] - 20, -x, k, n, o, p, h > 15 and 15 or h)
                        end
                        
						e = e - 30
                    end
                end
                self.callback_registered = true
            end
        )
    end
   
	function b:paint(y, z)
        local A = tonumber(y) + 1
        for g = self.maximum_count, 2, -1 do
            self.data2[g] = self.data2[g - 1]
        end
        self.data2[1] = {time = A, def_time = A, draw = z}
        self:stored_callbacks()
    end
    	return b
	end)()

	for i = 1, #vars.state do
		elements[i] = {
			pitch = store(ui.new_combobox(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Pitch", { "Off", "Default", "Up", "Down", "Minimal", "Random"})),
			yaw_mode = store(ui.new_combobox(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Jitter system", {"Extrapolated", "Left & Right", "Random Left & Right", "3 way", "5 way", "7 way"})),
			spin_enabled = store(ui.new_checkbox(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Enable spin")),
			yaw_3_way_1 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 3 way"..colors.new_blue.." [1st angle]", -180, 180, 0)),
			yaw_3_way_2 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 3 way"..colors.new_blue.." [2nd angle]", -180, 180, 0)),
			yaw_3_way_3 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 3 way"..colors.new_blue.." [3rd angle]", -180, 180, 0)),
			yaw_7_way_1 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 7 way"..colors.new_blue.." [1st angle]", -180, 180, 0)),
			yaw_7_way_2 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 7 way"..colors.new_blue.." [2nd angle]", -180, 180, 0)),
			yaw_7_way_3 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 7 way"..colors.new_blue.." [3rd angle]", -180, 180, 0)),
			yaw_7_way_4 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 7 way"..colors.new_blue.." [4th angle]", -180, 180, 0)),
			yaw_7_way_5 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 7 way"..colors.new_blue.." [5th angle]", -180, 180, 0)),
			yaw_7_way_6 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 7 way"..colors.new_blue.." [6th angle]", -180, 180, 0)),
			yaw_7_way_7 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 7 way"..colors.new_blue.." [7th angle]", -180, 180, 0)),
			yaw_5_way_1 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 5 way"..colors.new_blue.." [1st angle]", -180, 180, 0)),
			yaw_5_way_2 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 5 way"..colors.new_blue.." [2nd angle]", -180, 180, 0)),
			yaw_5_way_3 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 5 way"..colors.new_blue.." [3rd angle]", -180, 180, 0)),
			yaw_5_way_4 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 5 way"..colors.new_blue.." [4th angle]", -180, 180, 0)),
			yaw_5_way_5 = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | 5 way"..colors.new_blue.." [5th angle]", -180, 180, 0)),
			yaw_left = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Jitter degree "..colors.new_blue.."[L]", -180, 180, 0)),
			yaw_right = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Jitter degree "..colors.new_blue.."[R]", -180, 180, 0)),
			yaw_min_left = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Jitter degree min "..colors.new_blue.."[L]", -180, 180, 0)),
			yaw_max_left = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Jitter degree max "..colors.new_blue.."[L]", -180, 180, 0)),
			yaw_min_right = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Jitter degree min "..colors.new_blue.."[R]", -180, 180, 0)),
			yaw_max_right = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Jitter degree max "..colors.new_blue.."[R]", -180, 180, 0)),
			b_yaw = store(ui.new_combobox(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Body system", {"off", "jitter", "static"})),
			fake_body = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Body amount "..colors.new_blue.."[L]", -180, 180, 0)),
			fake_body_r = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Body amount "..colors.new_blue.."[R]", -180, 180, 0)),
			fake_mode = store(ui.new_combobox(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Fake system", {"Left & Right", "Random Left & Right", "Dynamic"})),
			fake_left = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Fake amount "..colors.new_blue.."[L]", 0, 60, 60,true,"°")),
			fake_right = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Fake amount "..colors.new_blue.."[R]", 0, 60, 60,true,"°")),
			fake_min_left = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Fake min "..colors.new_blue.."[L]", 0, 60, 60,true,"°")),
			fake_max_left = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Fake max "..colors.new_blue.."[L]", 0, 60, 60,true,"°")),
			fake_min_right = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Fake min "..colors.new_blue.."[R]", 0, 60, 60,true,"°")),
			fake_max_right = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Fake max "..colors.new_blue.."[R]", 0, 60, 60,true,"°")),
			aa_disabled = store(ui.new_checkbox(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Disable freestanding")),
			defensive = store(ui.new_checkbox(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Force defensive")),
			ab_system = store(ui.new_combobox(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Brute system", {"Disabled", "Jitter brute", "Body brute", "Dynamic"})),
			ab_jitt_left = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Brute degree "..colors.new_blue.."[L]", -180, 180, 0)),
			ab_jitt_right = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Brute degree "..colors.new_blue.."[R]", -180, 180, 0)),
			ab_fake_body = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Brute body "..colors.new_blue.."[L]", -180, 180, 0)),
			ab_fake_body_r = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Brute body "..colors.new_blue.."[R]", -180, 180, 0)),
			ab_fake_left = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Brute fake "..colors.new_blue.."[L]", 0, 60, 60,true,"°")),
			ab_fake_right = store(ui.new_slider(tab, container, colors.new_blue..vars.state[i]..colors.white.." | Brute fake "..colors.new_blue.."[R]", 0, 60, 60,true,"°")),
		}
	end

	local import_config = function()
		local table = _sub(base64.decode(clipboard.get(), 'base64'), "|")
		local p = 1
		for i,o in pairs(_storing.export['number']) do
			set(o,tonumber(table[p]))
			p = p + 1
		end
		for i,o in pairs(_storing.export['string']) do
			set(o,table[p])
			p = p + 1
		end
		for i,o in pairs(_storing.export['boolean']) do
			set(o,_boolean(table[p]))
			p = p + 1
		end
		for i,o in pairs(_storing.export['table']) do
			set(o,_sub(table[p],','))
			p = p + 1
		end
		notify:paint(3, "imported VICE-PRESIDENT settings")
	end

	local load_config = function(config)
		local table = _sub(base64.decode(config, 'base64'), "|")
		local p = 1
		for i,o in pairs(_storing.export['number']) do
			set(o,tonumber(table[p]))
			p = p + 1
		end
		for i,o in pairs(_storing.export['string']) do
			set(o,table[p])
			p = p + 1
		end
		for i,o in pairs(_storing.export['boolean']) do
			set(o,_boolean(table[p]))
			p = p + 1
		end
		for i,o in pairs(_storing.export['table']) do
			set(o,_sub(table[p],','))
			p = p + 1
		end
		notify:paint(3, "config loaded")
	end

	local cfg_to_print = ""

	local export_config = function(should_notify)
		local m = ""
		for i,o in pairs(_storing.export['number']) do
			m = m .. tostring(get(o)) .. '|'
		end
		for i,o in pairs(_storing.export['string']) do
			m = m .. (get(o)) .. '|'
		end
		for i,o in pairs(_storing.export['boolean']) do
			m = m .. tostring(get(o)) .. '|'
		end
		for i,o in pairs(_storing.export['table']) do
			m = m .. _string(o) .. '|'
		end
		cfg_to_print = base64.encode(m, 'base64')
		clipboard.set(base64.encode(m, 'base64'))
		if should_notify then
		notify:paint(3, "exported VICE-PRESIDENT settings")
		end
	end

	local encode_config = function()
		local m = ""
		for i,o in pairs(_storing.export['number']) do
			m = m .. tostring(get(o)) .. '|'
		end
		for i,o in pairs(_storing.export['string']) do
			m = m .. (get(o)) .. '|'
		end
		for i,o in pairs(_storing.export['boolean']) do
			m = m .. tostring(get(o)) .. '|'
		end
		for i,o in pairs(_storing.export['table']) do
			m = m .. _string(o) .. '|'
		end
		return base64.encode(m, 'base64')
	end

	local tab_handler = function()
		cur = ui.get(antiaim.additions)
		ui.set(antiaim.tab_handle, 'Current tab ~ '..cur)
	end

	tab_handler()
	ui.set_callback(antiaim.additions, tab_handler)

	local steam_name = js.MyPersonaAPI.GetName()
	local steam64 = js.MyPersonaAPI.GetXuid()

	local export_btn = ui.new_button(tab, container, "Export settings", export_config)
	local import_btn = ui.new_button(tab, container, "Import settings", import_config)

	skeet_menu = function(state)
		ui.set_visible(reference.antiaim.pitch, state)
		ui.set_visible(reference.antiaim.yawbase, state)
		ui.set_visible(reference.antiaim.yaw[1], state)
		ui.set_visible(reference.antiaim.yaw[2], state)
		ui.set_visible(reference.antiaim.yaw_jitt[1], state)
		ui.set_visible(reference.antiaim.yaw_jitt[2], state)
		ui.set_visible(reference.antiaim.body_yaw[1], state)
		ui.set_visible(reference.antiaim.body_yaw[2], state)
		ui.set_visible(reference.antiaim.freestand[1], state)
		ui.set_visible(reference.antiaim.freestand[2], state)
		ui.set_visible(reference.antiaim.fsbodyyaw, state)
		ui.set_visible(reference.antiaim.edgeyaw, state)
		ui.set_visible(reference.antiaim.roll, state)
		ui.set_visible(reference.antiaim.enabled, state)
	end

	HEXtoRGB = function(hexArg)
		hexArg = hexArg:gsub('#','')
		if(string.len(hexArg) == 3) then
			return tonumber('0x'..hexArg:sub(1,1)) * 17, tonumber('0x'..hexArg:sub(2,2)) * 17, tonumber('0x'..hexArg:sub(3,3)) * 17
		elseif(string.len(hexArg) == 8) then
			return tonumber('0x'..hexArg:sub(1,2)), tonumber('0x'..hexArg:sub(3,4)), tonumber('0x'..hexArg:sub(5,6)), tonumber('0x'..hexArg:sub(7,8))
		else
			return 0 , 0 , 0
		end
	end

	RGBtoHEX = function(redArg, greenArg, blueArg)
		return string.format('%.2x%.2x%.2xFF', redArg, greenArg, blueArg)
	end

	RGBAtoHEX = function(redArg, greenArg, blueArg, alphaArg)
		return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
	end

	get_timestamp = function()
        return client.unix_time()
    end

	local realtime_offset = get_timestamp() - globals.realtime()
	
	get_unix_timestamp = function()
		return globals.realtime() + realtime_offset + 50
	end

	format_timestamp = function(timestamp)
	    local day_count, year, days, month = function(yr) return (yr % 4 == 0 and (yr % 100 ~= 0 or yr % 400 == 0)) and 366 or 365 end, 1970, math.ceil(timestamp/86400)

	    while days >= day_count(year) do
	        days = days - day_count(year) year = year + 1
	    end

	    local tab_overflow = function(seed, table) 
	    	for i = 1, #table do 
	    		if seed - table[i] <= 0 then 
	    			return i, seed 
	    		end 

	    		seed = seed - table[i] 
	    	end 
	    end

	    month, days = tab_overflow(days, {31, (day_count(year) == 366 and 29 or 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31})

	    local hours, minutes, seconds = math.floor(timestamp / 3600 % 24), math.floor(timestamp / 60 % 60), math.floor(timestamp % 60)
	    local period = hours > 12 and "pm" or "am"

	    return string.format("%d/%d/%04d %02d:%02d", days, month, year, hours, minutes)
	end

	local format_timestamp = setmetatable({}, {
		__index = function(tbl, ts)
			tbl[ts] = format_timestamp(ts)
			return tbl[ts]
		end
	})

	format_duration =  function(secs, ignore_seconds, max_parts)
		local units, dur, part = {"day", "hour", "minute"}, "", 1
		max_parts = max_parts or 4
	
		for i, v in ipairs({86400, 3600, 60}) do
			if part > max_parts then
				break
			end
	
			if secs >= v then
				dur = dur .. math.floor(secs / v) .. " " .. units[i] .. (math.floor(secs / v) > 1 and "s" or "") .. ", "
				secs = secs % v
				part = part + 1
			end
		end
	
		if secs == 0 or ignore_seconds or part > max_parts then
			return dur:sub(1, -3)
		else
			secs = math.floor(secs)
			return dur .. secs .. (secs > 1 and " seconds" or " second")
		end
	end

	format_unix_timestamp = function(timestamp, allow_future, ignore_seconds, max_parts)
		local secs = timestamp - get_unix_timestamp()
	
		if secs < 0 or allow_future then
			local duration = format_duration(math.abs(secs), ignore_seconds, max_parts)
			return secs > 0 and ("In " .. duration) or (duration .. " ago")
		else
			return format_timestamp[timestamp]
		end
	end

	hitgroup_names = {"generic","head","chest","stomach","left arm","right arm","left leg","right leg","neck","?","gear"}

	enemy_hurt = function(e)
		local enemies = entity.get_players(true)
		local hgroup = hitgroup_names[e.hitgroup + 1] or "?"
		local name = string.lower(entity.get_player_name(e.target))
		local health = entity.get_prop(e.target, "m_iHealth")
		local angle = math.floor(entity.get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60)
		local chance = math.floor(e.hit_chance)
		local bt = globals.tickcount() - e.tick
		local r,g,b = get(vis.hit_color)
		local hex = RGBtoHEX(r,g,b)

		if contains(vis.vis_menu, "Screen logs") then	
			notify:paint(3, string.format("\a".. hex .."Hit \aFFFFFFFF" .. name .. "'s \a".. hex .. hgroup .. "\aFFFFFFFF for \a".. hex .. e.damage .. "\aFFFFFFFF remaining (" .. health .. "hp)"))
		end

		if contains(vis.vis_menu, "Console logs") then
			client.color_log(r,g,b, "[VICE-PRESIDENT] \0")
			client.color_log(r,g,b, "Hit " .. name .. "'s " .. hgroup .. " for " .. e.damage .. " and remaining (" .. health .. "hp) angle: " .. angle .. "° hc: ".. chance .. " bt: "  .. bt .. "")
		end
	end

	missed_enemy = function(e)
		local enemies = entity.get_players(true)
		local hgroup = hitgroup_names[e.hitgroup + 1] or "?"
		local name = string.lower(entity.get_player_name(e.target))
		local health = entity.get_prop(e.target, "m_iHealth")
		local angle = math.floor(entity.get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60)
		local chance = math.floor(e.hit_chance)
		local bt = globals.tickcount() - e.tick
		local r,g,b = get(vis.miss_color)
		local hex = RGBtoHEX(r,g,b)
		local r1,g1,b1 = 255, 255, 255

		if contains(vis.vis_menu, "Screen logs") then	
		notify:paint(3, string.format("\a".. hex .. "Missed \aFFFFFFFF" .. name .. "'s \a"..hex .. hgroup .. "\aFFFFFFFF due to \a".. hex .. e.reason ..  "\aFFFFFFFF remaining (" .. health .. "hp)"))
		end

		if contains(vis.vis_menu, "Console logs") then
			client.color_log(r,g,b, "[VICE-PRESIDENT] \0")
			client.color_log(r,g,b, "Missed " .. name .. "'s " .. hgroup .. " due to " .. e.reason ..  " and remaining (" .. health .. "hp) angle: " .. angle .. "° hc: ".. chance .." bt: " .. bt .. "")
		end

		if e.reason ~= "?" then
			return 
		end
	end

	local anim = {}

	anim.helpers = {

		rgba_to_hex = function(self, r, g, b, a)
		  return bit.tohex(
		    (math.floor(r + 0.5) * 16777216) + 
		    (math.floor(g + 0.5) * 65536) + 
		    (math.floor(b + 0.5) * 256) + 
		    (math.floor(a + 0.5))
		  )
		end,

		animate_text = function(self, time, string, r, g, b, a)
			local m,n,o,p = get(vis.main_clr2)
			local t_out, t_out_iter = {}, 1
			local l = string:len() - 1
			local r_add = (m - r)
			local g_add = (n - g)
			local b_add = (o - b)
			local a_add = (p - a)
	
			for i = 1, #string do
				local iter = (i - 1)/(#string - 1) + time
				t_out[t_out_iter] = "\a" .. anim.helpers:rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )
				t_out[t_out_iter + 1] = string:sub(i,i)
				t_out_iter = t_out_iter + 2
			end
	
			return t_out
		end,
	}

	local helpers = {}

	helpers ={
		variance = function(ticks, fin_var, seed)
			fin_var = fin_var >= ticks and ticks-1 or fin_var
			local min_ticks = ticks-fin_var
			math.randomseed(seed or client.timestamp())
			return math.random(min_ticks, ticks)
		end,

		consistent = function(last_tick, max_ticks)
			return math.min(last_tick, max_ticks)
		end,

		get_velocity = function(player)
			local x,y,z = entity.get_prop(player, "m_vecVelocity")
			if x == nil then return end
			return math.sqrt(x*x + y*y + z*z)
		end,

		in_air = function(player)
			local flags = entity.get_prop(player, "m_fFlags")
			if bit.band(flags, 1) == 0 then
				return true
			end
			return false
		end,

		limit = function(num, min, max)
			if num < min then
				num = min
			elseif num > max then
				num = max
			end
			return num
		end,

		KaysFunction = function(A,B,C)
			local d = (A-B) / A:dist(B)
			local v = C - B
			local t = v:dot(d) 
			local P = B + d:scaled(t)
			
			return P:dist(C)
		end,

		doubletap_charged = function()
			if not get(reference.rage.dt[1]) or not get(reference.rage.dt[2])  then
				return false
			end

			if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then
				return
			end

			local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
			if weapon == nil then
				return false
			end

			local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
			local next_ready = entity.get_prop(weapon, "m_flNextPrimaryAttack")
			if next_ready == nil then
				return
			end

			local next_primary_attack = next_ready + 0.5
			if next_attack == nil or next_primary_attack == nil then
				return false
			end
			return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
		end,

		map = function(n, start, stop, new_start, new_stop)
			local value = (n - start) / (stop - start) * (new_stop - new_start) + new_start
			return new_start < new_stop and math.max(math.min(value, new_stop), new_start) or math.max(math.min(value, new_start), new_stop)
		end,

		GetClosestPoint = function(A, B, P)
			a_to_p = { P[1] - A[1], P[2] - A[2] }
			a_to_b = { B[1] - A[1], B[2] - A[2] }
		
			atb2 = a_to_b[1]^2 + a_to_b[2]^2
		
			atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
			t = atp_dot_atb / atb2
			
			return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
		end,

		last_sim_time = 0,
		defensive_until = 0,
		
		is_defensive_active = function(local_player)
			local local_player = entity.get_local_player()
			local tickcount = globals.tickcount()
			local sim_time = toticks(entity.get_prop(local_player, "m_flSimulationTime"))
			local sim_diff = sim_time - helpers.last_sim_time
		
			if sim_diff < 0 then
				helpers.defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
			end
			
			helpers.last_sim_time = sim_time
		
			return helpers.defensive_until > tickcount
		end
	}

	string.startswith = function(self, str) 
		return self:find('^' .. str) ~= nil
	end

	local configslist = {}
	local publicconfigslist = {}
	local publicconfigstimestamplist = {}

	updateconfigs = function()
		local http_data = {
			['key'] = '',
			['type'] = 'search',
			['username'] = status.username
		}
	
		http.post('https://hollywood.codes/api/index.phpindex.php', {params = http_data}, function(success, response)
			if not success or response.status ~= 200 then
				print('something went wrong, contact devs please')
				return
			end
	
			local configs = json.parse(response.body)
			configslist = {}
			ui.update(antiaim.listbox, configs)
			configslist = configs
			notify:paint(3, "configs refreshed")
		end)
	end

	loadpublic = function()
		if table.getn(publicconfigslist) == 0 then
			return
		end
		local cfgpos = ui.get(antiaim.publiclistbox) + 1
		local cfgname = publicconfigslist[cfgpos]
		local http_data = {
			['key'] = '',
			['type'] = 'loadpublic',
			['confignamepublic'] = cfgname
		}
	
		http.post("https://hollywood.codes/api/index.phpindex.php", {params = http_data}, function(success, response)
			if not success or response.status ~= 200 then
				print("something went wrong, contact devs please")
			  return
			end
		  
			load_config(response.body)
		end)
	end
	local loadpublicbutton = ui.new_button(tab, container, "load", loadpublic)

	deletepublic = function()
		if table.getn(publicconfigslist) == 0 then
			return
		end

		local cfgpos = ui.get(antiaim.publiclistbox) + 1
		local cfgname = publicconfigslist[cfgpos]
		if cfgname == nil then
			return
		end

		if not cfgname:startswith(status.username) then
			notify:paint(3, "you can't delete other people's configs")
			return
		else 
			local http_data = {
				['key'] = '',
				['type'] = 'deletepublic',
				['confignamepublic'] = cfgname 
			}
			http.post("https://hollywood.codes/api/index.phpindex.php", {params = http_data}, function(success, response)
				if not success or response.status ~= 200 then
					print("something went wrong, contact devs please")
				  return
				end
			end)
			notify:paint(3, "config deleted")
		end
		client.delay_call(0.5, updatepublic)
		client.delay_call(0.6, function()
			ui.set(antiaim.publiclistbox, 1)
		end)
	end
	local deletepublicbutton = ui.new_button(tab, container, "delete", deletepublic)

	updatepublic = function()
		local http_data = {
			['key'] = '',
			['type'] = 'searchpublic'
		}
	
		http.post('https://hollywood.codes/api/index.phpindex.php', {params = http_data}, function(success, response)
			if not success or response.status ~= 200 then
				print('something went wrong, contact devs please')
				return
			end
	
			local configs = json.parse(response.body)
			publicconfigstimestamplist = {}
			publicconfigslist = {}
			for i = 1, #configs do
				publicconfigslist[i] = configs[i][1]
			end
			for i = 1, #configs do
				publicconfigstimestamplist[i] = configs[i][2]
			end
			ui.update(antiaim.publiclistbox, publicconfigslist)
			notify:paint(3, "public configs refreshed")
		end)
	end
	local updatepublicbutton = ui.new_button(tab, container, "refresh", updatepublic)

	loadconfig = function()
		if table.getn(configslist) == 0 then
			return
		end
		local cfgpos = ui.get(antiaim.listbox) + 1
		local cfgname = configslist[cfgpos]
		local http_data = {
			['key'] = '',
			['type'] = 'load',
			['username'] = status.username,
			['configname'] = cfgname
		}
	
		http.post("https://hollywood.codes/api/index.phpindex.php", {params = http_data}, function(success, response)
			if not success or response.status ~= 200 then
				print("something went wrong, contact devs please")
			  return
			end
		  
			load_config(response.body)
		end)
	end

	
	local loadbutton = ui.new_button(tab, container, "load", loadconfig)

	saveconfig = function()
		local createtextget = ui.get(antiaim.createtext)
		local content = encode_config()
		if createtextget == "" then
			local cfgpos = ui.get(antiaim.listbox) + 1
			local cfgname = configslist[cfgpos]
			createtextget = cfgname
		end
		local http_data = {
			['key'] = '',
			['type'] = 'update',
			['username'] = status.username,
			['configname'] = createtextget,
			['configcontent'] = content
		}
	
		http.post("https://hollywood.codes/api/index.php", {params = http_data}, function(success, response)
			if not success or response.status ~= 200 then
				print("something went wrong, contact devs please")
			  return
			end
			notify:paint(3, "config saved")
		end)
		client.delay_call(0.5, updateconfigs)
	end
	
	client.delay_call(0.8, updateconfigs)
	client.delay_call(0.8, updatepublic)

	local updatebutton = ui.new_button(tab, container, "save", saveconfig)

	deleteconfig = function()
		if table.getn(configslist) == 0 then
			return
		end
		local cfgpos = ui.get(antiaim.listbox) + 1
		local cfgname = configslist[cfgpos]
	
		local http_data = {
			['key'] = 'HycM9FhUFjPvLGnnMHyV1V',
			['type'] = 'delete',
			['username'] = status.username,
			['configname'] = cfgname
		}
		http.post("https://hollywood.codes/api/index.php", {params = http_data}, function(success, response)
			if not success or response.status ~= 200 then
				print("something went wrong, contact devs please")
			  return
			end
			notify:paint(3, "config deleted")
		end)
	
		client.delay_call(0.5, updateconfigs)
		client.delay_call(0.6, function()
			ui.set(antiaim.listbox, 1)
		end)
	end
	
	local deletebutton = ui.new_button(tab, container, "delete", deleteconfig)
	
	local refreshbutton = ui.new_button(tab, container, "refresh", updateconfigs)

	share = function()
		if table.getn(configslist) == 0 then
			return
		end
		local cfgpos = ui.get(antiaim.listbox) + 1
		local cfgname = configslist[cfgpos]
		local http_data = {
			['key'] = 'HycM9FhUFjPvLGnnMHyV1V',
			['type'] = 'share',
			['username'] = status.username,
			['configname'] = cfgname
		}
		http.post("https://hollywood.codes/api/index.php", {params = http_data}, function(success, response)
			if not success or response.status ~= 200 then
				print("something went wrong, contact devs please")
			  return
			end
			notify:paint(3, "config shared to public list")
		end)
		client.delay_call(0.5, updatepublic)
	end
	
	local share = ui.new_button(tab, container, "share", share)

	back_butt = ui.new_button(tab, container, "Main tab", function()
		misc_tab = nil
		aa_tab = nil
		vis_tab = nil
		back_tab = 4
	end)

	local mode = (function()
		local aa = {}
		aa.terno = function(og_val, min, max, terno_v, terno_t)
			local terno_min = min
			local terno_max = max
			local terno_v = terno_v
			local terno_ticks = globals.tickcount() % 7

			if terno_ticks == 7 - 1 then
				if og_val < terno_max then
					og_val = og_val + terno_v
				elseif og_val >= terno_max then
					og_val = terno_min
				end
			end
			return helpers.limit(og_val, terno_min, terno_max)
		end

		aa.get_invert = function()
			local invert = (math.floor(math.min(reference.antiaim.fakeyawlimit, 
			(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * (reference.antiaim.fakeyawlimit * 2) - reference.antiaim.fakeyawlimit)))) > 0
			return invert
		end

		aa.sync = function(a,b)
			local invert = (math.floor(math.min(reference.antiaim.fakeyawlimit, (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * (reference.antiaim.fakeyawlimit * 2) - reference.antiaim.fakeyawlimit)))) > 0
			return invert and a or b
		end

		aa.o_sync = function(a,b)     
			local invert = (math.floor(math.min(reference.antiaim.fakeyawlimit, (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * (reference.antiaim.fakeyawlimit * 2) - reference.antiaim.fakeyawlimit)))) > 0
			return invert and b or a
		end

		aa.random = function(minl,minr,maxl,maxr)
			return aa.sync(math.random(minl,minr), math.random(maxl,maxr))
		end

		aa.sway = function(max, speed, min)
			return math.abs(math.floor(math.sin(globals.curtime() / speed * 1) * max))
		end

		aa.calculate = function(a)
			local rounded = function(num, decimals)
				local mult = 10^(decimals or 0)
				return math.floor(num * mult + 0.5) / mult
			end

			body_yaw = math.max(-60, math.min(60, rounded((entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) or 0)*120-60+0.5, 1)))
			if body_yaw == nil then body_yaw = 0 end
			local function dump(o)
				if type(o) == 'table' then
					local s = '{ '
					for k,v in pairs(o) do
					if type(k) ~= 'number' then k = '"'..k..'"' end
						s = s .. '['..k..'] = ' .. dump(v) .. ','
				end
					return s .. '} '
				else
					return tostring(o)
				end
			end

			last_by = tonumber(dump(get(reference.antiaim.body_yaw[2])))
			return math.ceil(math.ceil((last_by > 0) and math.abs(body_yaw)/math.pi or (-math.abs(body_yaw)/math.pi))/(a/5))
		end
		return aa
	end)()

	ffi.cdef [[
		typedef float  float_t;

    	typedef void*(__thiscall* get_client_entity_t)(void*, int);
    	typedef int(__thiscall* get_highest_entity_by_index_t)(void*);

    	typedef float(__thiscall* get_spread_t)(void*);
    	typedef float(__thiscall* get_innaccuracy_t)(void*);
    	typedef bool(__thiscall* is_weapon_t)(void*);

    	struct c_animstate2 {
        	char pad[ 3 ];
        	char m_bForceWeaponUpdate; //0x4
        	char pad1[ 91 ];
        	void* m_pBaseEntity; //0x60
        	void* m_pActiveWeapon; //0x64
        	void* m_pLastActiveWeapon; //0x68
        	float m_flLastClientSideAnimationUpdateTime; //0x6C
        	int m_iLastClientSideAnimationUpdateFramecount; //0x70
        	float m_flAnimUpdateDelta; //0x74
        	float m_flEyeYaw; //0x78
        	float m_flPitch; //0x7C
        	float m_flGoalFeetYaw; //0x80
        	float m_flCurrentFeetYaw; //0x84
        	float m_flCurrentTorsoYaw; //0x88
        	float m_flUnknownVelocityLean; //0x8C
        	float m_flLeanAmount; //0x90
        	char pad2[ 4 ];
        	float m_flFeetCycle; //0x98
        	float m_flFeetYawRate; //0x9C
        	char pad3[ 4 ];
        	float m_fDuckAmount; //0xA4
        	float m_fLandingDuckAdditiveSomething; //0xA8
        	char pad4[ 4 ];
        	float m_vOriginX; //0xB0
        	float m_vOriginY; //0xB4
        	float m_vOriginZ; //0xB8
        	float m_vLastOriginX; //0xBC
        	float m_vLastOriginY; //0xC0
        	float m_vLastOriginZ; //0xC4
        	float m_vVelocityX; //0xC8
        	float m_vVelocityY; //0xCC
        	char pad5[ 4 ];
        	float m_flUnknownFloat1; //0xD4
        	char pad6[ 8 ];
        	float m_flUnknownFloat2; //0xE0
        	float m_flUnknownFloat3; //0xE4
        	float m_flUnknown; //0xE8
        	float m_flSpeed2D; //0xEC
        	float m_flUpVelocity; //0xF0
       		float m_flSpeedNormalized; //0xF4
        	float m_flFeetSpeedForwardsOrSideWays; //0xF8
        	float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        	float m_flTimeSinceStartedMoving; //0x100
        	float m_flTimeSinceStoppedMoving; //0x104
        	bool m_bOnGround; //0x108
        	bool m_bInHitGroundAnimation; //0x109
        	float m_flTimeSinceInAir; //0x10A
        	float m_flLastOriginZ; //0x10E
        	float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        	float m_flStopToFullRunningFraction; //0x116
        	char pad7[ 4 ]; //0x11A
        	float m_flMagicFraction; //0x11E
        	char pad8[ 60 ]; //0x122
        	float m_flWorldForce; //0x15E
        	char pad9[ 462 ]; //0x162
       		float m_flMaxYaw; //0x334
    	};
	]]

	local classptr = ffi.typeof('void***')
	local rawientitylist = client.create_interface('client_panorama.dll', 'VClientEntityList003') or error('VClientEntityList003 wasnt found', 2)
	local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)
	local get_client_networkable = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][0]) or error('get_client_networkable_t is nil', 2)
	local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or error('get_client_entity is nil', 2)
	local rawivmodelinfo = client.create_interface('engine.dll', 'VModelInfoClient004')
	local ivmodelinfo = ffi.cast(classptr, rawivmodelinfo) or error('rawivmodelinfo is nil', 2)
	local get_studio_model = ffi.cast('void*(__thiscall*)(void*, const void*)', ivmodelinfo[0][32])

	function animation_state(_Entity)
		if not (_Entity) then
			return
		end
		local player_ptr = ffi.cast("void***", get_client_entity(ientitylist, _Entity))
		local animstate_ptr = ffi.cast("char*", player_ptr) + 0x9960
		local state = ffi.cast("struct c_animstate2**", animstate_ptr)[0]
		return state
	end
	
	function get_maximum_desync(_Entity)
		local S_animationState_t = animation_state(_Entity)
		local nDuckAmount = S_animationState_t.m_fDuckAmount
		local nFeetSpeedForwardsOrSideWays = math.max(0, math.min(1, S_animationState_t.m_flFeetSpeedForwardsOrSideWays))
		local nFeetSpeedUnknownForwardOrSideways = math.max(1, S_animationState_t.m_flFeetSpeedUnknownForwardOrSideways)
		local nValue = ((S_animationState_t.m_flStopToFullRunningFraction * -0.30000001) - 0.19999999) *
						   nFeetSpeedForwardsOrSideWays + 1
		if nDuckAmount > 0 then
			nValue = nValue + nDuckAmount * nFeetSpeedUnknownForwardOrSideways * (0.5 - nValue)
		end
		local nDeltaYaw = math.abs(S_animationState_t.m_flMaxYaw * nValue) 
		return nDeltaYaw < 60 and nDeltaYaw >= 0 and nDeltaYaw or 0
	end

	local command = {}

    command = {

		['switch'] = false,
		['ground_ticks'] = 1,
		['end_time'] = 0,
		['on_ground'] = 0,
		['fsdisabled'] = false,

		['abftimer'] = globals.tickcount(),
		['timer'] = globals.tickcount(),
		['last_abftick'] = 0,
		['reversed'] = false,

		['manual'] = {
			back_dir = true,
			left_dir = false,
			right_dir = false,
			forward_dir = false,
		},

		['antiaim'] = {
			pitch = "off",
			yaw = "180",
			yaw_val = 0,
			yaw_base = "at targets",
			yaw_jitter = "off",
			yaw_jitter_val = 0,
			body = "off",
			fsbody = false,
			body_val = 0,
			fake_val = 0,
		},

		reset_brute = function()
			pct = 1
			start = 720
			command['reversed'] = false
			notify:paint(3, "Restored og values")
		end,

		on_bullet_impact = function(e)
			local local_player = entity.get_local_player()
			local shooter = client.userid_to_entindex(e.userid)
			if not true then return end
			if not entity.is_enemy(shooter) or not entity.is_alive(local_player) or entity.is_dormant(shooter) then return end
		
			local shot_start_pos 	= vector(entity.get_prop(shooter, "m_vecOrigin"))
			shot_start_pos.z 		= shot_start_pos.z + entity.get_prop(shooter, "m_vecViewOffset[2]")
			local eye_pos			= vector(client.eye_position())
			local shot_end_pos 		= vector(e.x, e.y, e.z)
			local closest			= helpers.KaysFunction(shot_start_pos, shot_end_pos, eye_pos)
		
			if globals.tickcount() - command['abftimer'] < 0 then
				command['abftimer'] = globals.tickcount()
			end

			if globals.tickcount() - command['abftimer'] > 3 and closest < 70 then
				pct = 1
				start = 720
				command['abftimer'] = globals.tickcount()
				command['reversed'] = not command['reversed']
				command['last_abftick'] = globals.tickcount()
				notify:paint(3, "Changed values due to shot")
			end
		end,

		anti_backstab = function()
            local get_distance = function(x1, y1, z1, x2, y2, z2)
                return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
            end

			if contains(misc.misc_menu, "Anti-knife") then	
                local players = entity.get_players(true)
                local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
                for i=1, #players do
                    local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
                    local distance = get_distance(lx, ly, lz, x, y, z)
                    local weapon = entity.get_player_weapon(players[i])
					if entity.get_classname(weapon) == "CKnife" and distance <= get(misc.knife_distance) then
						command['antiaim'].pitch = "off"
						command['antiaim'].yaw_val = 180
						command['antiaim'].yaw_base = "At targets"
					end
                end
            end
        end,

		anti_zeus = function()
            local get_distance = function(x1, y1, z1, x2, y2, z2)
                return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
            end

			if contains(misc.misc_menu, "Anti-zeus") then
                local players = entity.get_players(true)
                local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
                for i=1, #players do
                    local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
                    local distance = get_distance(lx, ly, lz, x, y, z)
                    local weapon = entity.get_player_weapon(players[i])
					local selfweapon = entity.get_player_weapon(entity.get_local_player())

                    if entity.get_classname(weapon) == "CWeaponTaser" and distance <= get(misc.zeus_distance) then
						if get(misc.zeus_options) == "Pull pistol" then
							client.exec("slot2")				
						elseif get(misc.zeus_options) == "Pull zeus" and entity.get_classname(selfweapon) ~= "CWeaponTaser" then
							client.exec("slot3;")
						end
					end
                end
            end
        end,

		_states = function(c)
			local me    = entity.get_local_player()
			local flags = entity.get_prop(me, "m_fFlags")
			local vel1, vel2, vel3 = entity.get_prop(me, 'm_vecVelocity')
			local speed = math.floor(math.sqrt(vel1 * vel1 + vel2 * vel2))
			local ducking       = c.in_duck == 1
			local air           = command['on_ground'] < 5
			local walking       = speed >= 2
			local standing      = speed <= 1
			local slow_motion   = get(reference.rage.slow[1]) and get(reference.rage.slow[2])
			local fakeducking   = get(reference.rage.fakeduck)
			local wpn = entity.get_player_weapon(me)
			local wpn_id = entity.get_prop(wpn, "m_iItemDefinitionIndex")
			local is_def = get(antiaim.aa_builder) and get(elements[vars.p_state].defensive)
			command['on_ground'] = bit.band(flags, 1) == 0 and 0 or (command['on_ground'] < 5 and command['on_ground'] + 1 or command['on_ground'])

			local is_dt = get(reference.rage.dt[1]) and get(reference.rage.dt[2])

			if helpers.is_defensive_active(me) and is_dt then
				vars.p_state = 1
				vars.ind_state = "DEFEND"
			elseif air and not ducking and not is_def then
				vars.p_state = 5
				vars.ind_state = "IN AIR"
			elseif air and ducking and not is_def then
				vars.p_state = 7
				vars.ind_state = "AIR + D"
			elseif fakeducking or ducking and not is_def then
				vars.p_state = 6
				vars.ind_state = "DUCK"
			elseif slow_motion and not is_def then
				vars.p_state = 4
				vars.ind_state = "SLOW MO"
			elseif walking and not is_def then
				vars.p_state = 3
				vars.ind_state = "MOVE"
			elseif standing and not is_def then
				vars.p_state = 2
				vars.ind_state = "STAND"
			end

			if is_def and get(reference.rage.dt[2]) then
				c.force_defensive = true
				c.no_choke = true
				c.quick_stop = true
			else
				c.force_defensive = false
				c.no_choke = false
				c.quick_stop = false
			end
		end,

		fl_adaptive = function(c)
			local m_velocity = vector(entity.get_prop(entity.get_local_player(), 'm_vecVelocity'))
			local is_dt = get(reference.rage.dt[1]) and get(reference.rage.dt[2])
			local distance_per_tick = m_velocity:length2d() * globals.tickinterval()
			local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
		
			if on_ground == 1 then
				command['ground_ticks'] = command['ground_ticks'] + 1
			else
				command['ground_ticks'] = 0
				command['end_time'] = globals.curtime() + 1
			end 
			
			if not entity.is_alive(entity.get_local_player()) then 
				return
			end
		
			local lpweapon = entity.get_player_weapon(entity.get_local_player())
			local weapon_index = bit.band(65535,entity.get_prop(lpweapon, "m_iItemDefinitionIndex"))
		
			if weapon_index == nil or lpweapon == nil then
				return
			end

			local moving = distance_per_tick > 0.0158 and not helpers.in_air(entity.get_local_player()) and (contains(fl_tab.trigger, "moving"))
			local in_air = helpers.in_air(entity.get_local_player()) and (contains(fl_tab.trigger, "in air"))
			local stand = distance_per_tick < 0.0158 and (contains(fl_tab.trigger, "standing"))
			local landed = command['ground_ticks'] > c.chokedcommands+1 and command['end_time'] > globals.curtime() and (contains(fl_tab.trigger, "on land") )
			local slowwalking = get(reference.rage.slow[1]) and get(reference.rage.slow[2]) and (contains(fl_tab.trigger, "slowwalk") )
		
			if in_air or moving or landed or stand or get(reference.rage.fakeduck) or slowwalking then
				trigger = true 
			else
				trigger = false
			end 

			local lc = helpers.in_air(entity.get_local_player()) or distance_per_tick >= 3 or get(reference.rage.dt[1]) and get(reference.rage.dt[2]) and distance_per_tick > 0.0158
			if get(reference.rage.fakeduck) then
				fl = 14
			else
				if (c.in_attack == 1 and contains(fl_tab.forcelimit, "while shooting") and not (weapon_index == 44 or weapon_index == 46 or weapon_index == 43 or weapon_index == 47 or weapon_index == 45 or weapon_index == 48)) or (distance_per_tick < 0.0158 and not helpers.in_air(entity.get_local_player()) and contains(fl_tab.forcelimit, "while standing")) or (get(reference.rage.os[2]) and contains(fl_tab.forcelimit, "while os-aa")) then
					fl = 1
				elseif get(fl_tab.fakelag_tab) == "maximum" then
					fl = get(fl_tab.sendlimit)
				elseif get(fl_tab.fakelag_tab) == "dynamic" then
					fl = (trigger == true and get(fl_tab.triggerlimit) or get(fl_tab.sendlimit))
				else
					fl = (command['switch'] and get(fl_tab.triggerlimit) or get(fl_tab.sendlimit))
				end
			end

			local stable = lc and 14 or fl
			local send = helpers.consistent(14,15)
			local lagcomp = lc and send or 2
			local outgo = globals.lastoutgoingcommand()
			local amount = helpers.variance(lagcomp, 1, outgo) == 2 and stable or 0

			if get(fl_tab.advanced_fl) then
				set(reference.fakelag.enablefl, false)
				set(reference.fakelag.fl_limit, fl)
				set(reference.fakelag.fl_amount, "maximum")
				set(reference.fakelag.fl_var, 0)
		
				c.allow_send_packet = amount
			else
				set(reference.fakelag.enablefl, true)
			end
		end,

		anti_aim_on_use = function(c)
			if c.in_use == 1 then
				command['antiaim'].yaw_val = 0
				command['antiaim'].yaw_jitter_val = 0
				command['antiaim'].body = "static"
				command['antiaim'].fsbody = true
				if entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CC4" then return end
				if c.in_attack == 1 then
					c.in_use = 1
				end
				if c.chokedcommands == 0 then
					c.in_use = 0
				end
			else
				command['antiaim'].fsbody = false
			end
		end,

		manualaa = function()
			local v = command['manual']
			if get(antiaim.manual_reset) then
				v.back_dir = true
				v.right_dir = false
				v.left_dir = false
				v.forward_dir = false
				vars.last_press = globals.curtime()
			elseif get(antiaim.manual_right) and get(antiaim.toggle_manual) then
				if v.right_dir == true and vars.last_press + 0.02 < globals.curtime() then
				v.back_dir = true
				v.right_dir = false
				v.left_dir = false
				v.forward_dir = false
			elseif v.right_dir == false and vars.last_press + 0.02 < globals.curtime() then
				v.right_dir = true
				v.back_dir = false
				v.left_dir = false
				v.forward_dir = false
				end
				vars.last_press = globals.curtime()
			elseif get(antiaim.manual_left) and get(antiaim.toggle_manual) then
				if v.left_dir == true and vars.last_press + 0.02 < globals.curtime() then
				v.back_dir = true
				v.right_dir = false
				v.left_dir = false
				v.forward_dir = false
			elseif v.left_dir == false and vars.last_press + 0.02 < globals.curtime() then
				v.left_dir = true
				v.back_dir = false
				v.right_dir = false
				v.forward_dir = false
				end
				vars.last_press = globals.curtime()
			elseif get(antiaim.manual_forward) and get(antiaim.toggle_manual) then
				if v.forward_dir == true and vars.last_press + 0.02 < globals.curtime() then
				v.back_dir = true
				v.right_dir = false
				v.left_dir = false
				v.forward_dir = false
			elseif v.forward_dir == false and vars.last_press + 0.02 < globals.curtime() then
				v.left_dir = false
				v.back_dir = false
				v.right_dir = false
				v.forward_dir = true
				end
				vars.last_press = globals.curtime()
			end

			if v.right_dir == true then
				command['antiaim'].yaw = 180
				command['antiaim'].yaw_val = 90
				command['antiaim'].yaw_base = "local view"
				command['antiaim'].body = "opposite"
			elseif v.left_dir == true then
				command['antiaim'].yaw = 180
				command['antiaim'].yaw_val = -90
				command['antiaim'].yaw_base = "local view"
				command['antiaim'].body = "opposite"				
			elseif v.forward_dir == true then
				command['antiaim'].yaw = 180
				command['antiaim'].yaw_val = 180
				command['antiaim'].yaw_base = "local view"
				command['antiaim'].body = "opposite"				
			end
		end,

		freestand = function()
			local b_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
			local is_fs = get(antiaim.fs) and not command['fsdisabled']
			local v = command['manual']
			local is_manual = v.back_dir
			
			command['fsdisabled'] = false
		
			if get(antiaim.fs) then
				set(reference.antiaim.freestand[1], true)
				set(reference.antiaim.freestand[2], "Always on")
			end

			if get(elements[vars.p_state].aa_disabled) or not is_manual then
				command['fsdisabled'] = true
			end

			if not get(antiaim.fs) or command['fsdisabled'] then
				set(reference.antiaim.freestand[1], false)
			end
		end,

        brute = function()
            if globals.tickcount() - command['last_abftick'] > 600 and command['reversed'] then
                command.reset_brute()
            end
            
            if command['reversed'] then
                if get(elements[vars.p_state].ab_system) == "Jitter brute" then
                    command['antiaim'].yaw_val = mode.sync(get(elements[vars.p_state].ab_jitt_left), get(elements[vars.p_state].ab_jitt_right))
                elseif get(elements[vars.p_state].ab_system) == "Body brute" then
                    command['antiaim'].body_val = (command['switch'] and get(elements[vars.p_state].ab_fake_body) or get(elements[vars.p_state].fake_body_r))
                elseif get(elements[vars.p_state].ab_system) == "Dynamic" then
                    command['antiaim'].yaw_val = mode.sync(get(elements[vars.p_state].ab_jitt_left), get(elements[vars.p_state].ab_jitt_right))
                    command['antiaim'].body_val = (command['switch'] and get(elements[vars.p_state].ab_fake_body) or get(elements[vars.p_state].fake_body_r))
                    command['antiaim'].fake_val = mode.sync(get(elements[vars.p_state].ab_fake_left), get(elements[vars.p_state].ab_fake_right))
                else
                    command.reset_brute()
                end
            end
        end,

		aa_builder = function(c)
			local v = command['manual']
			local is_fs = get(antiaim.fs) and not command['fsdisabled']
			if not entity.is_alive(entity.get_local_player()) then return end
			local inverter = 1;

			if globals.chokedcommands() == 0 then
				random_jitter = client.random_int( 0, 1 ) == 1 and 1 or -1
			end
			
			if get(elements[vars.p_state].yaw_mode) == "Extrapolated" then
				inverter = random_jitter
			end
			
			if inverter == nil then return end

			if v.back_dir == true then
				if c.chokedcommands ~= 0 then
				else
					vars.max_desync_amount = get_maximum_desync(entity.get_local_player())
					local debug_desync = vars.max_desync_amount / 1.2
					local max_jitter = debug_desync * 1.8
					local current_stage_7way = get(elements[vars.p_state].yaw_mode) == "7 way" and ((globals.tickcount() % 7) + 1) or 0;
					local current_stage_5way = get(elements[vars.p_state].yaw_mode) == "5 way" and ((globals.tickcount() % 5) + 1) or 0;
					local current_stage_3way = get(elements[vars.p_state].yaw_mode) == "3 way" and ((globals.tickcount() % 3) + 1) or 0;
					local five_way = 0;
					local three_way = 0;
					local seven_way = 0;

					if current_stage_3way == 1 then
						three_way = get(elements[vars.p_state].yaw_3_way_1)
					elseif current_stage_3way == 2 then
						three_way = get(elements[vars.p_state].yaw_3_way_2)
					elseif current_stage_3way == 3 then
						three_way = get(elements[vars.p_state].yaw_3_way_3)
						current_stage_3way = 0
					end

					if current_stage_7way == 1 then
						seven_way = get(elements[vars.p_state].yaw_7_way_1)
					elseif current_stage_7way == 2 then
						seven_way = get(elements[vars.p_state].yaw_7_way_2)
					elseif current_stage_7way == 3 then
						seven_way = get(elements[vars.p_state].yaw_7_way_3)
					elseif current_stage_7way == 4 then
						seven_way = get(elements[vars.p_state].yaw_7_way_4)
					elseif current_stage_7way == 5 then
						seven_way = get(elements[vars.p_state].yaw_7_way_5)
					elseif current_stage_7way == 6 then
						seven_way = get(elements[vars.p_state].yaw_7_way_6)
					elseif current_stage_7way == 7 then
						seven_way = get(elements[vars.p_state].yaw_7_way_7)
						current_stage_7way = 0
					end

					if current_stage_5way == 1 then
						five_way = get(elements[vars.p_state].yaw_5_way_1)
					elseif current_stage_5way == 2 then
						five_way = get(elements[vars.p_state].yaw_5_way_2)
					elseif current_stage_5way == 3 then
						five_way = get(elements[vars.p_state].yaw_5_way_3)
					elseif current_stage_5way == 4 then
						five_way = get(elements[vars.p_state].yaw_5_way_4)
					elseif current_stage_5way == 5 then
						five_way = get(elements[vars.p_state].yaw_5_way_5)
						current_stage_5way = 0
					end

					if get(antiaim.aa_builder) then
						if command['reversed'] == false then 
							if not get(elements[vars.p_state].spin_enabled) then
								command['antiaim'].yaw = "180"
							else
								command['antiaim'].yaw = "Spin"
							end
							command['antiaim'].pitch = get(elements[vars.p_state].pitch)
							command['antiaim'].body = get(elements[vars.p_state].b_yaw)
	
							if get(elements[vars.p_state].yaw_mode) == "Extrapolated" then
								command['antiaim'].yaw_val = (inverter == -1 and get(elements[vars.p_state].yaw_left) or get(elements[vars.p_state].yaw_right)) or 0
							elseif get(elements[vars.p_state].yaw_mode) == "Left & Right" then
								command['antiaim'].yaw_val = mode.sync(get(elements[vars.p_state].yaw_left), get(elements[vars.p_state].yaw_right))
							elseif get(elements[vars.p_state].yaw_mode) == "Random Left & Right" then
								command['antiaim'].yaw_val = mode.random(get(elements[vars.p_state].yaw_min_left), get(elements[vars.p_state].yaw_max_left),get(elements[vars.p_state].yaw_min_right), get(elements[vars.p_state].yaw_max_right))
							elseif get(elements[vars.p_state].yaw_mode) == "3 way" then
								command['antiaim'].yaw_val = three_way
							elseif get(elements[vars.p_state].yaw_mode) == "5 way" then
								command['antiaim'].yaw_val = five_way
							elseif get(elements[vars.p_state].yaw_mode) == "7 way" then
								command['antiaim'].yaw_val = seven_way
							end
	
							if get(elements[vars.p_state].fake_mode) == "Left & Right" then
								command['antiaim'].fake_val = mode.sync(get(elements[vars.p_state].fake_left), get(elements[vars.p_state].fake_right))
							elseif get(elements[vars.p_state].fake_mode) == "Random Left & Right" then
								command['antiaim'].fake_val = mode.random(get(elements[vars.p_state].fake_min_left),get(elements[vars.p_state].fake_max_left),get(elements[vars.p_state].fake_min_right),get(elements[vars.p_state].fake_max_right))
							elseif get(elements[vars.p_state].fake_mode) == "Dynamic" then
								command['antiaim'].fake_val = debug_desync
							end
	
							command['antiaim'].body_val = (inverter == -1 and get(elements[vars.p_state].fake_body) or get(elements[vars.p_state].fake_body_r))
						end
					end
				end
			end
		end,

		apply_aa = function()
			local v = command['antiaim']
			if v.fake_val == 60 then
				v.fake_val = 59
			end

			set(reference.antiaim.pitch, v.pitch)
			set(reference.antiaim.yaw[1], v.yaw)
			set(reference.antiaim.yaw[2], v.yaw_val)
			set(reference.antiaim.yawbase, v.yaw_base)
			set(reference.antiaim.yaw_jitt[1], v.yaw_jitter)
			set(reference.antiaim.yaw_jitt[2], v.yaw_jitter_val)
			set(reference.antiaim.fsbodyyaw, v.fsbody)
			set(reference.antiaim.body_yaw[1], v.body)
			set(reference.antiaim.body_yaw[2], v.body_val)
			--set(reference.antiaim.fakeyawlimit, v.fake_val)
		end,

		teleport = function()
			local local_player = entity.get_local_player()
			if not ui.get(antiaim.lc_break) then
				ui.set(reference.rage.dt[1], true)
				return
			end
			if not entity.is_alive(local_player) then
				return
			end
			local enemies = entity.get_players(true)
			local vis = false
			for i=1, #enemies do
				local entindex = enemies[i]
				local body_x,body_y,body_z = entity.hitbox_position(entindex, 1)
				if client.visible(body_x, body_y, body_z + 20) then
					vis = true
				end
			end	
			if vis then
				ui.set(reference.rage.dt[1], false)
			else
				ui.set(reference.rage.dt[1], true)
			end
		end
	}

	old_anim = function()
		local localplayer = entity.get_local_player()
		if localplayer == nil then return end
		local is_sw = get(reference.rage.slow[1]) and get(reference.rage.slow[2])
		local bodyyaw = entity.get_prop(localplayer, "m_flPoseParameter", 11) * 120 - 60
		local side = bodyyaw > 0 and 1 or -1

		if not contains(misc.misc_menu, "Moonwalk") then return end

		local me = ent.get_local_player()
		local m_fFlags = me:get_prop("m_fFlags");
		local is_onground = bit.band(m_fFlags, 1) ~= 0;

		if contains(misc.misc_menu, "Moonwalk") then
			set(reference.rage.lm, "Never slide")
			entity.set_prop(localplayer, "m_flPoseParameter", 1, 7)
			if not is_onground then
				local my_animlayer = me:get_anim_overlay(6);
				my_animlayer.weight = 1;
				entity.set_prop(me, "m_flPoseParameter", 1, 6)
			end
		end
	end

	local solus_render = (function()
		local solus_m = {};
		local RoundedRect = function(x, y, w, h, radius, r, g, b, a)
			renderer.rectangle(x + radius, y, w - radius * 2, radius, r, g, b, a)
			renderer.rectangle(x, y + radius, radius, h - radius * 2, r, g, b, a)
			renderer.rectangle(x + radius, y + h - radius, w - radius * 2, radius, r, g, b, a)
			renderer.rectangle(x + w - radius, y + radius, radius, h - radius * 2, r, g, b, a)
			renderer.rectangle(x + radius, y + radius, w - radius * 2, h - radius * 2, r, g, b, a)
			renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
			renderer.circle(x + w - radius, y + radius, r, g, b, a, radius, 90, 0.25)
			renderer.circle(x + radius, y + h - radius, r, g, b, a, radius, 270, 0.25)
			renderer.circle(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25)
		end;
	
		local rounding = 6;
		local rad = rounding + 2;
		local n = 45;
		local o = 20;
		local OutlineGlow = function(x, y, w, h, radius, r, g, b, a)
			renderer.rectangle(x + 2, y + radius + rad, 1, h - rad * 2 - radius * 2, r, g, b, a)
			renderer.rectangle(x + w - 3, y + radius + rad, 1, h - rad * 2 - radius * 2, r, g, b, a)
			renderer.rectangle(x + radius + rad, y + 2, w - rad * 2 - radius * 2, 1, r, g, b, a)
			renderer.rectangle(x + radius + rad, y + h - 3, w - rad * 2 - radius * 2, 1, r, g, b, a)
			renderer.circle_outline(x + radius + rad, y + radius + rad, r, g, b, a, radius + rounding, 180, 0.25, 1)
			renderer.circle_outline(x + w - radius - rad, y + radius + rad, r, g, b, a, radius + rounding, 270, 0.25, 1)
			renderer.circle_outline(x + radius + rad, y + h - radius - rad, r, g, b, a, radius + rounding, 90, 0.25, 1)
			renderer.circle_outline(x + w - radius - rad, y + h - radius - rad, r, g, b, a, radius + rounding, 0, 0.25, 1)
		end;
		local FadedRoundedRect = function(x, y, w, h, radius, r, g, b, a, glow)
			local n = a / 255 * n;
			renderer.rectangle(x + radius, y, w - radius * 2, 1, r, g, b, a)
			renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, 1)
			renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, 270, 0.25, 1)
			renderer.gradient(x, y + radius, 1, h - radius * 2, r, g, b, a, r, g, b, n, false)
			renderer.gradient(x + w - 1, y + radius, 1, h - radius * 2, r, g, b, a, r, g, b, n, false)
			renderer.circle_outline(x + radius, y + h - radius, r, g, b, n, radius, 90, 0.25, 1)
			renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, n, radius, 0, 0.25, 1)
			renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, n)
				for radius = 4, glow do
					local radius = radius / 2;
					OutlineGlow(x - radius, y - radius, w + radius * 2, h + radius * 2, radius, r, g, b, glow - radius * 2)
				end
		end;
	
		solus_m.container = function(x, y, w, h, r, g, b, a, alpha, fn)
			RoundedRect(x, y, w, h, rounding, 17, 17, 17, a)
			FadedRoundedRect(x, y, w, h, rounding, r, g, b, alpha * 255, alpha * o)
			if not fn then return end
			fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
		end;
		return solus_m
	end)()

	local animate = (function()
		local anim = {}

		local lerp = function(start, vend)
			return start + (vend - start) * (globals.frametime() * 6)
		end

		local lerp_notify = function(start, vend)
			return start + (vend - start) * (globals.frametime() * 8)
		end

		anim.new_notify = function(value, startpos, endpos, condition)
			if condition ~= nil then
				if condition then
					return lerp_notify(value,startpos)
				else
					return lerp_notify(value,endpos)
				end
			else
				return lerp_notify(value,startpos)
			end
		end

		anim.new = function(value, startpos, endpos, condition)
			if condition ~= nil then
				if condition then
					return lerp(value,startpos)
				else
					return lerp(value,endpos)
				end
			else
				return lerp(value,startpos)
			end
		end

		anim.color_lerp = function(color, color2, end_value, condition)
			if condition ~= nil then
				if condition then
					color.r = lerp(color.r,color2.r)
					color.g = lerp(color.g,color2.g)
					color.b = lerp(color.b,color2.b)
					color.a = lerp(color.a,color2.a)
				else
					color.r = lerp(color.r,end_value.r)
					color.g = lerp(color.g,end_value.g)
					color.b = lerp(color.b,end_value.b)
					color.a = lerp(color.a,end_value.a)
				end
			else
				color.r = lerp(color.r,color2.r)
				color.g = lerp(color.g,color2.g)
				color.b = lerp(color.b,color2.b)
				color.a = lerp(color.a,color2.a)
			end
			return { r = color.r , g = color.g , b = color.b , a = color.a }
		end

		anim.adapting = function(cur, min, max, target, step, speed)
			local step = step or 1
			local speed = speed or 0.1
	
			if cur < min + step then
				target = max
			elseif cur > max - step then
				target = min
			end
			return cur + (target - cur) * speed * (globals.absoluteframetime() * 10)
		end
		return anim
	end)()

	gradient_text = function(r1, g1, b1, a1, r2, g2, b2, a2, m)
		local output = ''
		local len = #m
		local rinc = (r2 - r1) / len
		local ginc = (g2 - g1) / len
		local binc = (b2 - b1) / len
		local ainc = (a2 - a1) / len
	
		for i=1, len do
			output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, m:sub(i, i))
			r1 = r1 + rinc
			g1 = g1 + ginc
			b1 = b1 + binc
			a1 = a1 + ainc
		end
		return output
	end

    local screen = {client.screen_size()}
    local x_offset, y_offset = screen[1], screen[2]
    local x, y =  x_offset/2,y_offset/2 

    local visuals = {}

    visuals = {

        ['stored'] = {
            ['script_load'] = {
                ['start'] = globals.realtime(),
                ['show'] = false,
                ['alpha'] = 0
            },

            ['crosshair'] = {
                ['alpha'] = 0,
                ['scoped'] = 0,
                ['values'] = {0, 0, 0, 0, 0, 0},
                ['doubletap_color'] = {r = 0 , g = 0 , b = 0 , a = 0},
                ['modern'] = {speed = 1, text_alpha = 0, text_alpha2 = 0, color = {r = 0 , g = 0 , b = 0 , a = 0}},
				['fake_anim'] = 0
            },

			['arrows'] = {
				['off_set'] = 0,
			},
        },

		script_load = function()
			local v = visuals['stored']['script_load']
			v['alpha'] = animate.new(v['alpha'],1,0,not v['show'])
			local svg_300 = '<svg width="554.4" height="649.6" version="1.1" viewBox="0 0 554.4 649.6" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><path d="m273.53 531.63-1.2395-1-9.3067-28.8-4.6424-12-9.818-24-17.748-35.2-8.6508-14.4-15.06-22.4-13.001-16.784-19.226-19.216-13.574-10.574-11.2-7.2366-9.0585-4.8934-13.342-5.418-12.169-3.7597 20.169-13.528 9.6-7.622 9.7313-10.168 5.9613-8.9982 4.6761-11.49 1.8536-10.644-.44579-8.4502-.44578-8.4502-4.2296-17.567-5.4146-16.362-3.4264-8.6192-3.4264-8.6192-11.531-23.496-7.5372-13.304-4.8378-8-12.086-19.2-21.358-31.75.61216-.61215 17.504 13.176 11.2 8.674 24 20.062 23.2 20.715 16.8 15.328 26.449 26.408 9.6565 10.4 16.766 20 7.9794 11.2 2.9747 4.5356 2.9746 4.5356v1.1609l-8.4-7.896-12.975-9.8364-20.234-13.684-10.792-5.4178-12.287-4.9044-2.8566-.53589-2.8566-.53591v.93244l4.1268 9.2456 4.7217 12.8 1.1757 6.7048 1.1757 6.7048-.006 12.99-2.3936 14.758-4.6527 11.712-8.0522 13.994-6.7765 8.3356-8.7112 9.0411.89866 1.4541 14.094 8.5536 12.8 9.9316 12.087 11.02 15.664 17.105 8.6992 10.895 11.805 16.8 11.046 17.6 9.4292 16.8 6.1129 11.2 2.6527 5.2h13.131l10.79-19.6 14.435-24 7.9316-12 9.7475-13.6 14.579-17.6 15.89-16.128 13.6-10.775 18.4-12.278.42665-.1792-10.184-10.541-9.981-14.573-6.3921-13.64-2.0371-8.1431-2.0371-8.1431-.062-18.4 2.1096-8 2.1096-8 7.2467-17.467-.73833-.73832-7.6613 1.8785-11.368 4.6767-11.832 6.6356-8.8 5.7196-20.8 15.067-9.2 8.9784v-1.4415l11.966-17.817 21.136-25.491 40.099-39.849 18.279-16.151 22.521-19.81 25.818-20.99 9.3822-7.2772 10.8-7.6632v.76582l-27.647 41.375-8.2699 13.6-9.9886 17.6-6.2336 12-7.3055 16-4.6248 12-2.6501 8-2.6501 8-1.3152 4.4709-1.3152 4.4709-1.1951 7.9291-1.1951 7.9291-.005 5.9345-.005 5.9345 1.8287 10.531 5.3676 11.792 3.5177 4.9042 3.5177 4.9042 13.368 12.954 23.735 15.578-.40504.40505-.40504.40504-18.925 6.3179-14.174 7.2282-10.16 6.1725-12.466 9.3149-16.602 16.025-13.127 16-11.902 16-9.0454 14.4-11.38 20-15.733 32-3.6731 8.8-3.6731 8.8-5.4866 14.4-6.3764 19.2-3.4474 11.6h-2.8481l-1.2396-1zm-39.27-181.47-3.0032-.70782-7.7678-3.9362-13.046-12.273-9.6518-12.809.37408-.37406.37407-.37407 9.3241 2.0225 13.355 6.9654 9.2924 6.3104 4.9404 5.9936 1.3228 4.0254 1.3228 4.0253.36908 1 .36906 1-4.5712-.1608zm75.805-1.7315.52931-2.6.73607-2.8922.73608-2.8922 7.5964-7.1049 10.259-6.012 10.541-4.8537 8.6625-3.0491.27134.27135.27136.27134-12.746 16.847-8.8057 8.0479-7.4467 4.162-8.097 2.4046h-3.0367z" stroke-width=".8" fill="#ffffff"/></svg>'
			local svg = renderer.load_svg(svg_300, 300 , 300 )
			local text = gradient_text(115, 154, 255,255 * v['alpha'] + 0.5,128,128,240,255 * v['alpha'] + 0.5, "V I C E P R E S I D E N T")
			local text_sizex, text_sizey = renderer.measure_text("+",text)
			
			renderer.blur(0, 0, x_offset * v['alpha'], y_offset * v['alpha'])
			
			renderer.circle(x, y - 150/3,0,0,0, 255, 130* v['alpha'],360,360)
			
			renderer.rectangle(0, 0, x_offset, y_offset, 10, 10, 10, 150*v['alpha'])
			
			renderer.texture(svg, x - (312/2 + 7) * v['alpha'] + 15, y + (800/3 - 100) * v['alpha'] - 345, 300 * v['alpha'], 300 * v['alpha'], 128, 128, 240, math.floor(255 * v['alpha']), "f")
			
			renderer.text(x -text_sizex/2 + 4, y + 70 + (40 * v['alpha']),255,255,255,255* v['alpha'],"+",0,text)
			
			renderer.gradient(x -text_sizex/2 + 4, y + 100 + ( 40 *  v['alpha']) ,text_sizex * v['alpha'],3,115, 154, 255,255 ,128,128,240, math.floor(255 * v['alpha']),true)
			
			if v['start'] + 4 < globals.realtime() then
				v['start'] = globals.realtime()
				v['show'] = true
			end
		end,

        render_inds = function()
			if not contains(vis.vis_menu, "Indicators") then return end
            local v = visuals['stored']['crosshair']
            local text_size_x , text_size_y = renderer.measure_text(nil,"V I C E P R E S I D E N T")
            local r,g,b = get(vis.main_clr)
			local r1,g1,b1 = get(vis.main_clr2)

			local b_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 1.3
            v['alpha'] = animate.new(v['alpha'],1,0, contains(vis.vis_menu, "Indicators"))
            if v['alpha'] < 0.01 then return end
            local is_scoped = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_zoomLevel" ) == 1 or entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_zoomLevel" ) == 2
            local modifier = entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") ~= 1
			
			if b_yaw then
				b_yaw = math.abs(helpers.map(b_yaw, 0, 1, -60, 60))
				b_yaw = math.max(0, math.min(57, b_yaw))
				body_yaw_solaris = b_yaw / 49
			end

			v['scoped'] = animate.new(v['scoped'],1,0,is_scoped)
			v['fake_anim'] = animate.new(v['fake_anim'],body_yaw_solaris, 0, contains(vis.vis_menu, "Indicators"))

			local main_text = anim.helpers:animate_text(globals.curtime(), "V I C E P R E S I D E N T", r, g, b, 255)
			
			renderer.text(x - text_size_x/2 + 42 + math.floor(40 * v['scoped'])-3, y + 25, 255, 255, 255, 255, "-c", nil, unpack(main_text))
			
			surface.draw_outlined_rect(x - text_size_x/2 + 18 + (40 * v['scoped'])-3, y + 30, text_size_x/2, 5, 13, 13, 13, 255 * v['alpha'])
			
			surface.draw_filled_rect(x  - text_size_x/2 + 18 + math.floor(40 * v['scoped'])-3, y + 30, text_size_x/2 + 10, 5, 13, 13, 13, 255 * v['alpha'])
			
			renderer.gradient(x - text_size_x/2 + 18 + math.floor(40 * v['scoped'])-2, y + 31, math.floor(text_size_x/2 * v['fake_anim']) - 5, 3, r, g, b, 255 * v['alpha'], 0, 0, 0, 255 * v['alpha'], true)
			
			renderer.text(x - text_size_x/2 + 40 + math.floor(40 * v['scoped'])-3, y + 39, 255, 255, 255, 255 * v['alpha'], "-c", nil, string.upper(vars.ind_state)) 
		
			v['doubletap_color'] = animate.color_lerp(v['doubletap_color'], {r = 255 , g = 255, b = 255, a = 255}, {r = 255 , g = 0,b = 0,a = 255},
			get(reference.rage.dt[1]) and get(reference.rage.dt[2]) and helpers.doubletap_charged())
			local offset = 0
		
			local keys = {
		
				[1] = {
					['condition'] = get(reference.rage.forcebaim),
					['text'] = 'BAIM',
					['color'] = {255,255,255,255 * v['alpha']}
				},
		
				[2] = {
					['condition'] = get(antiaim.fs) and not command['fsdisabled'],
					['text'] = 'FREEST.',
					['color'] = {255,255,255,255 * v['alpha']}
				},
		
				[3] = {
					['condition'] = get(reference.rage.safepoint),
					['text'] = 'SAFE',
					['color'] = {255,255,255,255 * v['alpha']}
				},
		
				[4] = {
					['condition'] = get(reference.rage.os[1]) and get(reference.rage.os[2]),
					['text'] = 'HS',
					['color'] = {255,255,255,255 * v['alpha']}
				},
				
				[5] = {
					['condition'] = get(reference.rage.quickpeek[1]) and get(reference.rage.quickpeek[2]),
					['text'] = 'PEEK',
					['color'] = {255,255,255,255 * v['alpha']}
				},
		
				[6] = {
					['condition'] = get(reference.rage.dt[1]) and get(reference.rage.dt[2]),
					['text'] = 'DT',
					['color'] = {v['doubletap_color'].r, v['doubletap_color'].g, v['doubletap_color'].b, 255 * v['alpha']}              
				},
			}
		
			for k, items in pairs(keys) do
				local flags = 'c-'
				local text_width , text_height = renderer.measure_text(flags,items['text'])
				local key = items['condition'] and 1 or 0
		
				v['values'][k] = animate.new(v['values'][k],key)
				if k == 2 then
					offset = offset + 1 
				end
		
				local x , y = x - 1 + (40 * v['scoped']), y + 47
				renderer.text(x, y + offset * v['values'][k], items['color'][1],items['color'][2],items['color'][3],items['color'][4] * v['values'][k], flags, text_width * v['values'][k] + 3, items['text'])
				offset = offset + 9 * v['values'][k]
			end
        end,

		watermark = function()
			command['switch'] = not command['switch']
			if not contains(vis.vis_menu, "Watermark") then return end
			local datas = "VICE-PRESIDENT"
			local name123 = status.username
			local build = status.build
			local c1,c2,c3 = ui.get(vis.wat_color)
			local hex = RGBtoHEX(c1,c2,c3)
		
			text = ("\a"..hex.."%s \aFFFFFFAA|\aFFFFFFAA " ..build.. " \aFFFFFFAA|\a"..hex.." %s\aFFFFFFAA"):format(datas, name123)
			
			local h, w = 18, renderer.measure_text(nil, text)
			local x, y = client.screen_size()
			
			
			if contains(vis.vis_menu, "Watermark") then
				solus_render.container(x/2 - w/2 - 6, y - 30, w + 12, 16, c1,c2,c3, 200, 1)
				renderer.text(x/2 - w/2, y - 29, 255, 255, 255, 255, '', 0, text)
			end
		end,

		min_dmg_indicator = function()
			if not contains(vis.vis_menu, "Min dmg indicator") then return end
			local localp = entity.get_local_player()
			if localp == nil or not entity.is_alive(localp) then return end
			local screen_size = { client.screen_size() }

			local override = get(reference.rage.damage_override[3])
			local original_dmg = get(reference.rage.damage)
			if get(vis.show_original_dmg) then
				if get(reference.rage.damage_override[2]) then
					renderer.text(screen_size[1] / 2 + 2, screen_size[2] / 2 - 14, 255, 255, 255, 225, "d", 0, override .. "")
				else
					renderer.text(screen_size[1] / 2 + 2, screen_size[2] / 2 - 14, 255, 255, 255, 225, "d", 0, original_dmg .. "")
				end
			else
				if get(reference.rage.damage_override[2]) then
					renderer.text(screen_size[1] / 2 + 2, screen_size[2] / 2 - 14, 255, 255, 255, 225, "d", 0, override .. "")
				end
			end

		end,

        render_arrows = function()
			local x, y = client.screen_size()
			local localp = entity.get_local_player()
			if not entity.is_alive(localp) or not contains(vis.vis_menu, "Team skeet arrows") then return end
			local b_yaw = entity.get_prop(localp, "m_flPoseParameter", 11) * 120 - 60
			local m1,m2,m3,m4 = get(vis.manual_aa_color)
			local m_1,m_2,m_3, m_4 = get(vis.side_color)
			local offset = get(vis.arrows_offset)
			local v = command['manual']
			local m = visuals['stored']['arrows']
			
			m['off_set'] = animate.new(m['off_set'], offset, 0, contains(vis.vis_menu, "Team skeet arrows"))

			renderer.triangle(x / 2 + m['off_set'] + 5, y / 2 + 2, x / 2 + m['off_set'] - 8, y / 2 - 7, x / 2 + m['off_set'] - 8, y / 2 + 11, 
			v.right_dir == true and m1 or 25, 
			v.right_dir == true and m2 or 25, 
			v.right_dir == true and m3 or 25, 
			v.right_dir == true and m4 or 160)
			renderer.triangle(x / 2 - m['off_set'] - 5, y / 2 + 2, x / 2 - m['off_set'] + 8, y / 2 - 7, x / 2 - m['off_set'] + 8, y / 2 + 11, 
			v.left_dir == true and m1 or 25, 
			v.left_dir == true and m2 or 25, 
			v.left_dir == true and m3 or 25, 
			v.left_dir == true and m4 or 160)
			renderer.rectangle(x / 2 + m['off_set'] - 12, y / 2 - 7, 2, 18, 
			b_yaw < -10 and m_1 or 25,
			b_yaw < -10 and m_2 or 25,
			b_yaw < -10 and m_3 or 25,
			b_yaw < -10 and m_4 or 255)
			renderer.rectangle(x / 2 - m['off_set'] + 10, y / 2 - 7, 2, 18,			
			b_yaw > 10 and m_1 or 25,
			b_yaw > 10 and m_2 or 25,
			b_yaw > 10 and m_3 or 25,
			b_yaw > 10 and m_4 or 255)
		end,

		legfucker = function()
			local localplayer = entity.get_local_player()
			if not entity.is_alive(localplayer) then return end 
			local m_flDuckAmount = entity.get_prop(localplayer, "m_flDuckAmount") > 0.5
			local is_dt = get(reference.rage.dt[1]) and get(reference.rage.dt[2])
			local is_os = get(reference.rage.os[1]) and get(reference.rage.os[2])
			local timing = globals.tickcount() % 69
			local lp_vel = helpers.get_velocity(entity.get_local_player())
			local b_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
			local side = b_yaw > 0 and 1 or -1

			if contains(misc.misc_menu, "Leg breaker") and not helpers.in_air(localplayer) and timing > 1 and lp_vel > 50 then
				entity.set_prop( localplayer, "m_flPoseParameter", client.random_float(0.75, 1), 0)
				ui.set(reference.rage.lm, client.random_int(1, 3) == 1 and "Off" or "Always slide" )
			end

			if not is_dt and not is_os and not m_flDuckAmount and not contains(misc.misc_menu, "Leg breaker") then
				if vars.p_state == 1 then
					entity.set_prop(localplayer, "m_flPoseParameter", 50 and 0.5 or 0, 14)
				elseif vars.p_state == 3 then
					entity.set_prop(localplayer, "m_flPoseParameter", 5 and 50 * 0.01 or 0, 10)
				else
					entity.set_prop(localplayer, "m_flPoseParameter", 5 and 0.8 or 0, 8)
				end
			end
		end,

        stored_paint = function()
			visuals.watermark()

            if entity.get_local_player() == nil or  not entity.is_alive(entity.get_local_player()) then
                return
            end
			visuals.min_dmg_indicator()
            visuals.render_arrows()
            visuals.render_inds()
			visuals.legfucker()
        end,

		menuToggle = function(state, reference)
			for i,v in pairs(reference) do
				if type(v) == "table" then
					for i2,v2 in pairs(v) do
						ui.set_visible(v2, state) 
					end
				else
					ui.set_visible(v, state)
				end
			end
		end,

		lua_menu = function()
			local main = get(antiaim.additions)
			local add_main = get(antiaim.additions) == "Anti-aim"
			local add_keys = get(antiaim.additions) == "Binds"
			local cfg = get(antiaim.additions) == "Settings"

			if aa_tab then
				visuals.menuToggle(false, menuSelectionRefs)
				ui.set_visible(back_butt, true)
				ui.set_visible(antiaim.tab_handle, true)
			elseif vis_tab then
				visuals.menuToggle(false, menuSelectionRefs)
				ui.set_visible(back_butt, true)
				ui.set_visible(antiaim.tab_handle, false)
			elseif misc_tab then
				visuals.menuToggle(false, menuSelectionRefs)
				ui.set_visible(back_butt, true)
				ui.set_visible(antiaim.tab_handle, false)
			else 
				visuals.menuToggle(true, menuSelectionRefs)
				ui.set_visible(back_butt, false)
				ui.set_visible(antiaim.tab_handle, false)
			end

			if add_main and aa_tab and not add_keys then
				ui.set_visible(antiaim.additions, true)
				ui.set_visible(antiaim.aa_builder, false)
			else
				ui.set_visible(antiaim.additions, false)
				ui.set_visible(antiaim.aa_builder, false)
			end

			if add_keys and aa_tab and not add_main then
				ui.set_visible(antiaim.fs, true)
				ui.set_visible(antiaim.lc_break, true)
				ui.set_visible(antiaim.toggle_manual, true)
				if get(antiaim.toggle_manual) then 
					ui.set_visible(antiaim.manual_left, true)
					ui.set_visible(antiaim.manual_right, true)
					ui.set_visible(antiaim.manual_forward, true)
					ui.set_visible(antiaim.manual_reset, true)
				else
					ui.set_visible(antiaim.manual_left, false)
					ui.set_visible(antiaim.manual_right, false)
					ui.set_visible(antiaim.manual_forward, false)
					ui.set_visible(antiaim.manual_reset, false)
				end
			else
				ui.set_visible(antiaim.manual_left, false)
				ui.set_visible(antiaim.manual_right, false)
				ui.set_visible(antiaim.manual_forward, false)
				ui.set_visible(antiaim.manual_reset, false)
				ui.set_visible(antiaim.fs, false)
				ui.set_visible(antiaim.lc_break, false)
				ui.set_visible(antiaim.toggle_manual, false)
			end

			if aa_tab then
				ui.set_visible(antiaim.additions, true)
			else
				ui.set_visible(antiaim.additions, false)
			end
			
			if vis_tab then
				ui.set_visible(antiaim.additions, false)
				visuals.menuToggle(true, vis)

				if contains(vis.vis_menu, "Indicators") then
					ui.set_visible(vis.main_clr, true)
					ui.set_visible(vis.main_clr_l, true)
					ui.set_visible(vis.main_clr2, true)
					ui.set_visible(vis.main_clr_l2, true)
				else
					ui.set_visible(vis.main_clr, false)
					ui.set_visible(vis.main_clr_l, false)
					ui.set_visible(vis.main_clr2, false)
					ui.set_visible(vis.main_clr_l2, false)
				end

				if contains(vis.vis_menu, "Watermark") then
					ui.set_visible(vis.watermark_on, true)
					ui.set_visible(vis.wat_color, true)
				else
					ui.set_visible(vis.watermark_on, false)
					ui.set_visible(vis.wat_color, false) 
				end

				if contains(vis.vis_menu, "Screen logs") or contains(vis.vis_menu, "Console logs") then
					ui.set_visible(vis.hit_label, true)
					ui.set_visible(vis.hit_color,true)
					ui.set_visible(vis.miss_label, true)
					ui.set_visible(vis.miss_color, true)
				else
					ui.set_visible(vis.hit_label, false)
					ui.set_visible(vis.hit_color, false)
					ui.set_visible(vis.miss_label, false)
					ui.set_visible(vis.miss_color, false)
				end
		
				if contains(vis.vis_menu, "Team skeet arrows") then
					ui.set_visible(vis.arrows_offset, true)
					ui.set_visible(vis.side_label, true)
					ui.set_visible(vis.side_color, true)
					ui.set_visible(vis.manual_aa_labe, true)
					ui.set_visible(vis.manual_aa_color, true)
				else
					ui.set_visible(vis.arrows_offset, false)
					ui.set_visible(vis.side_label, false)
					ui.set_visible(vis.side_color, false)
					ui.set_visible(vis.manual_aa_labe, false)
					ui.set_visible(vis.manual_aa_color, false)
				end

				if contains(vis.vis_menu, "Min dmg indicator") then
					ui.set_visible(vis.show_original_dmg, true)
				else
					ui.set_visible(vis.show_original_dmg, false)
				end
			else
				visuals.menuToggle(false, vis)
			end

			if misc_tab then		
				visuals.menuToggle(true, misc)
				if contains(misc.misc_menu, "Anti-knife") then
					ui.set_visible(misc.knife_distance, true)
				else
					ui.set_visible(misc.knife_distance, false)
				end

				if contains(misc.misc_menu, "Anti-zeus") then
					ui.set_visible(misc.zeus_distance, true)
					ui.set_visible(misc.zeus_options, true)
				else
					ui.set_visible(misc.zeus_distance, false)
					ui.set_visible(misc.zeus_options, false)
				end
			else
				visuals.menuToggle(false, misc)
			end

			if aa_tab and cfg then
				ui.set_visible(antiaim.configmenu, true)
			else
				ui.set_visible(antiaim.configmenu, false)
			end

			if ui.get(antiaim.configmenu) == "local" and aa_tab and cfg then
				ui.set_visible(antiaim.createtext, true)
				ui.set_visible(antiaim.listbox, true)
				ui.set_visible(loadbutton, true)
				ui.set_visible(updatebutton, true)
				ui.set_visible(deletebutton, true)
				ui.set_visible(refreshbutton, true)
				ui.set_visible(share, true)
				ui.set_visible(antiaim.publiclistbox, false)
				ui.set_visible(loadpublicbutton, false)
				ui.set_visible(updatepublicbutton, false)
				ui.set_visible(import_btn, false)
				ui.set_visible(export_btn, false)
				ui.set_visible(antiaim.updatelabel, false)
				ui.set_visible(deletepublicbutton, false)
			elseif ui.get(antiaim.configmenu) == "public" and aa_tab and cfg then
				ui.set_visible(antiaim.createtext, false)
				ui.set_visible(antiaim.listbox, false)
				ui.set_visible(loadbutton, false)
				ui.set_visible(updatebutton, false)
				ui.set_visible(deletebutton, false)
				ui.set_visible(refreshbutton, false)
				ui.set_visible(share, false)
				ui.set_visible(antiaim.publiclistbox, true)
				ui.set_visible(loadpublicbutton, true)
				ui.set_visible(updatepublicbutton, true)
				ui.set_visible(import_btn, false)
				ui.set_visible(export_btn, false)
				ui.set_visible(antiaim.updatelabel, true)
				ui.set_visible(deletepublicbutton, true)
			elseif ui.get(antiaim.configmenu) == "import/export" and aa_tab and cfg then
				ui.set_visible(antiaim.createtext, false)
				ui.set_visible(antiaim.listbox, false)
				ui.set_visible(loadbutton, false)
				ui.set_visible(updatebutton, false)
				ui.set_visible(deletebutton, false)
				ui.set_visible(refreshbutton, false)
				ui.set_visible(share, false)
				ui.set_visible(antiaim.publiclistbox, false)
				ui.set_visible(loadpublicbutton, false)
				ui.set_visible(updatepublicbutton, false)
				ui.set_visible(import_btn, true)
				ui.set_visible(export_btn, true)
				ui.set_visible(antiaim.updatelabel, false)
				ui.set_visible(deletepublicbutton, false)
			else
				ui.set_visible(antiaim.createtext, false)
				ui.set_visible(antiaim.listbox, false)
				ui.set_visible(loadbutton, false)
				ui.set_visible(updatebutton, false)
				ui.set_visible(deletebutton, false)
				ui.set_visible(refreshbutton, false)
				ui.set_visible(share, false)
				ui.set_visible(antiaim.publiclistbox, false)
				ui.set_visible(loadpublicbutton, false)
				ui.set_visible(updatepublicbutton, false)
				ui.set_visible(import_btn, false)
				ui.set_visible(export_btn, false)
				ui.set_visible(antiaim.updatelabel, false)
				ui.set_visible(deletepublicbutton, false)
			end

			if get(fl_tab.advanced_fl) then 
				visuals.menuToggle(true, fl_tab)
				ui.set_visible(reference.fakelag.enablefl,false)
				ui.set_visible(reference.fakelag.fl_amount,false)
				ui.set_visible(reference.fakelag.fl_limit,false)
				ui.set_visible(reference.fakelag.fl_var,false)
				if get(fl_tab.fakelag_tab) == "dynamic" then
					ui.set_visible(fl_tab.trigger,true)
				else
					ui.set_visible(fl_tab.trigger,false)
				end
				if get(fl_tab.fakelag_tab) == "maximum" then
					ui.set_visible(fl_tab.triggerlimit,false)
				else
					ui.set_visible(fl_tab.triggerlimit,true)
				end
			else
				ui.set_visible(reference.fakelag.enablefl,true)
				ui.set_visible(reference.fakelag.fl_amount,true)
				ui.set_visible(reference.fakelag.fl_limit,true)
				ui.set_visible(reference.fakelag.fl_var,true)
				visuals.menuToggle(false, fl_tab)
				ui.set_visible(fl_tab.advanced_fl, true)
			end

			if get(antiaim.aa_builder) then
				local aa_state = vars.state_to_nmbr[get(antiaim.player_state)]
				for i=1, #vars.state do
					ui.set_visible(antiaim.player_state, aa_tab and add_main)
					ui.set_visible(elements[i].pitch, aa_state == i and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_left, aa_state == i and get(elements[i].yaw_mode) ~= "Random Left & Right" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "7 way" and get(elements[i].yaw_mode) ~= "5 way" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_right, aa_state == i and get(elements[i].yaw_mode) ~= "Random Left & Right" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "7 way" and get(elements[i].yaw_mode) ~= "5 way" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_min_left, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "7 way" and get(elements[i].yaw_mode) ~= "5 way" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_max_left, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "7 way" and get(elements[i].yaw_mode) ~= "5 way" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_min_right, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "7 way" and get(elements[i].yaw_mode) ~= "5 way" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_max_right, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "7 way" and get(elements[i].yaw_mode) ~= "5 way" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_3_way_1, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "7 way" and get(elements[i].yaw_mode) ~= "5 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_3_way_2, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "7 way" and get(elements[i].yaw_mode) ~= "5 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_3_way_3, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "7 way" and get(elements[i].yaw_mode) ~= "5 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_7_way_1, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated"and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "5 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_7_way_2, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "5 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_7_way_3, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "5 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_7_way_4, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "5 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_7_way_5, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "5 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_7_way_6, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "5 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_7_way_7, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "5 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_5_way_1, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "7 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_5_way_2, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "7 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_5_way_3, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "7 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_5_way_4, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "7 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_5_way_5, aa_state == i and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "3 way" and get(elements[i].yaw_mode) ~= "7 way" and get(elements[i].yaw_mode) ~= "Random Left & Right" and aa_tab and add_main)					
					ui.set_visible(elements[i].b_yaw, aa_state == i and aa_tab and add_main)
					ui.set_visible(elements[i].fake_mode, aa_state == i and get(elements[i].b_yaw) ~= "off" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_mode, aa_state == i and aa_tab and add_main)
					ui.set_visible(elements[i].fake_min_left, aa_state == i and get(elements[i].fake_mode) ~= "Left & Right" and get(elements[i].fake_mode) ~= "Dynamic" and aa_tab and add_main)
					ui.set_visible(elements[i].fake_max_left, aa_state == i and get(elements[i].fake_mode) ~= "Left & Right" and get(elements[i].fake_mode) ~= "Dynamic" and aa_tab and add_main)
					ui.set_visible(elements[i].fake_min_right, aa_state == i and get(elements[i].fake_mode) ~= "Left & Right" and get(elements[i].fake_mode) ~= "Dynamic" and aa_tab and add_main)
					ui.set_visible(elements[i].fake_max_right, aa_state == i and get(elements[i].fake_mode) ~= "Left & Right" and get(elements[i].fake_mode) ~= "Dynamic" and aa_tab and add_main)
					ui.set_visible(elements[i].ab_system, aa_state == i and aa_tab and add_main)
					ui.set_visible(elements[i].aa_disabled, aa_state == i and aa_tab and add_main)
					ui.set_visible(elements[i].defensive, aa_state == i and aa_tab and add_main)
					ui.set_visible(elements[i].spin_enabled, aa_state == i and aa_tab and add_main and get(elements[i].yaw_mode) ~= "Extrapolated" and get(elements[i].yaw_mode) ~= "Left & Right" and get(elements[i].yaw_mode) ~= "Random Left & Right")
					ui.set_visible(elements[i].ab_jitt_left, aa_state == i and get(elements[i].ab_system) ~= "Disabled" and get(elements[i].ab_system) ~= "Body brute" and aa_tab and add_main)
					ui.set_visible(elements[i].ab_jitt_right, aa_state == i and get(elements[i].ab_system) ~= "Disabled" and get(elements[i].ab_system) ~= "Body brute" and aa_tab and add_main)
					ui.set_visible(elements[i].ab_fake_body, aa_state == i and get(elements[i].ab_system) ~= "Disabled" and get(elements[i].ab_system) ~= "Jitter brute" and aa_tab and add_main)
					ui.set_visible(elements[i].ab_fake_body_r, aa_state == i and get(elements[i].ab_system) ~= "Disabled" and get(elements[i].ab_system) ~= "Jitter brute" and aa_tab and add_main)
					ui.set_visible(elements[i].ab_fake_left, aa_state == i and get(elements[i].ab_system) ~= "Disabled" and get(elements[i].ab_system) ~= "Body brute" and get(elements[i].ab_system) ~= "Jitter brute" and aa_tab and add_main)
					ui.set_visible(elements[i].ab_fake_right, aa_state == i and get(elements[i].ab_system) ~= "Disabled" and get(elements[i].ab_system) ~= "Body brute" and get(elements[i].ab_system) ~= "Jitter brute" and aa_tab and add_main)
					ui.set_visible(elements[i].fake_body, aa_state == i and get(elements[i].b_yaw) ~= "off" and aa_tab and add_main)
					ui.set_visible(elements[i].fake_body_r, aa_state == i and get(elements[i].b_yaw) ~= "off" and aa_tab and add_main)
					ui.set_visible(elements[i].fake_left, aa_state == i and get(elements[i].fake_mode) ~= "Random Left & Right" and get(elements[i].b_yaw) ~= "off" and get(elements[i].fake_mode) ~= "Dynamic" and aa_tab and add_main)
					ui.set_visible(elements[i].fake_right, aa_state == i and get(elements[i].fake_mode) ~= "Random Left & Right" and get(elements[i].b_yaw) ~= "off" and get(elements[i].fake_mode) ~= "Dynamic" and aa_tab and add_main)
				end
			end
		end,

        stored_paint_ui = function()
			skeet_menu(false)
            visuals.script_load()
			visuals.lua_menu()
        end
    }

	local _misc = {}

	_misc = {
        ['value'] = {	
            ['trash_talk'] = {
				"dogs dont talk, they listen",
				"𝕤𝕝𝕒𝕪𝕚𝕟𝕘 𝕨𝕚𝕥𝕙 VICE-PRESIDENT (◣_◢)",
				"in yur country are au gays",
				"u smell like donkey shit bro",
				"𝖙𝖞4𝖈𝖑𝖎𝖕",
				"H & $",
				"cry d0g",
				"eat shit kid - owned by VICE-PRESIDENT",
				"i never made the money counter beep once",
				"your father and your father TONIGHT TONIGHT!!",
				"𝕒 𝕕𝕖𝕒𝕕 𝕟𝕚𝕘𝕘𝕒 𝕥𝕣𝕪𝕚𝕟𝕘 𝕥𝕠 𝕥𝕒𝕝𝕜 𝕥𝕠 𝕞𝕖 𝕓𝕦𝕥 𝕚 𝕕𝕠𝕟𝕥 𝕥𝕒𝕝𝕜 𝕥𝕠 𝕘𝕙𝕠𝕤𝕥𝕤",
				"everything so ez with skeetcht",
				"buy some hvh lessons instead of cfg",
				"𝟙",
				"just got your angle from my 1337 database",
				"bozo down! L Kid + Ratio. your mom has a penis.",
				"faded than a ho faded than a ho faded than a ho",
				"𝕔𝕒𝕟'𝕥 𝕣𝕖𝕤𝕠𝕝𝕧𝕖 𝕞𝕪 𝕒𝕟𝕥𝕚-𝕒𝕚𝕞 𝕤𝕪𝕤𝕥𝕖𝕞(◣_◢)",
				"father = gg me say no more",
				"i shit on your dead father grave",
				"i pissed in your grandmothers urn kid",
				"ʎɹɔ",
				"the dookie flew outta my ass into the bucket like olajuwon you wouldnt know the feeling of lettin go of a fart u held for too long",
				"𝕚𝕣𝕣 𝕗𝕦𝕔𝕜𝕙𝕖𝕒𝕕 𝕓𝕝𝕒𝕥𝕒𝕟𝕥 𝕕𝕚𝕔𝕜𝕝𝕖𝕤𝕤 𝕜𝕚𝕕 𝕘𝕠𝕥 𝟙",
				"taking yo mamma on date",
				"𝕧𝕖𝕟𝕚 𝕧𝕚𝕕𝕚 𝕧𝕚𝕔𝕚",
				"mfs trying to kill me with dmg override, but i stomp their heads with 1o1",
				"１ and stfu furry",
				"VICE-PRESIDENT.codes © 2022",
				"i sold ur father for condoms so ur mom wouldn't get aids",
				"想象Gamesense获得更新 (◣_◢)",
				"继续使用俄罗斯糊",
				"sup",
				"您好像没有脑子的弱智",
				"有我孤帅哥一半厉害吗？废物",
				"i'd call you cancer, but at least cancer gets kills",
				"ho ho ho bust this nut",
				"getoff ma dick",
				"1, low gayish femboY",
				"gimme uwu discord kitten",
				"to the pRIZZon",
				"sᴘᴏɴsᴏʀ ᴏꜰ ʏᴏᴜʀ ᴅᴇᴀᴛʜ",
				"𝕊𝕃𝔸𝕍𝔸 ℝ𝕌𝕊𝕊𝕀𝔸",
				"ｌｅａｖｅ ｇａｍｅ， ｓｔｏｐ ｅｍｂａｒｒａｓｓｉｎｇ ｙｏｕｒｓｅｌｆ"
			},
		},

        trashtalk = function(e)
            if contains(misc.misc_menu, "Trashtalk") then
				local attacker_entindex = client.userid_to_entindex(e.attacker)
				local victim_entindex = client.userid_to_entindex(e.userid)
				if attacker_entindex ~= entity.get_local_player() then return end
				if victim_entindex == entity.get_local_player() then return end
				local sendconsole = client.exec
				local _first = _misc['value']['trash_talk'][math.random(1, #_misc['value']['trash_talk'])]
				if _first ~= nil  then
				local say = 'say ' .._first
					sendconsole(say)
				end
            end
        end,
    }

	local call = function(event_name,function_name,sta)
		if sta ~= nil then
			if sta then
				client.set_event_callback(event_name,function_name)
			else
				client.unset_event_callback(event_name,function_name)
			end
		else
			client.set_event_callback(event_name,function_name)
		end
	end	

	local callbacks = {}

    callbacks = {
        paint = function()
            visuals:stored_paint()
        end,

        paint_ui = function()
            visuals.stored_paint_ui()
        end,

        aim_hit = function(e)
			enemy_hurt(e)
        end,

        aim_miss = function(e)
			missed_enemy(e)
        end,

        bullet_impact = function(e)
			command.on_bullet_impact(e)
        end,

        player_death = function(e)
			_misc.trashtalk(e)
		end,

        round_start = function(e)
			vars.last_press = 0
			command.reset_brute()
        end,

        new_map = function(e)
			v['switch'] = false
			vars.last_press = 0
			command.reset_brute()
        end,

        shut_down = function()
			skeet_menu(true)
			set(reference.antiaim.yaw[1], "180")
			set(reference.antiaim.yaw[2], 0)
			set(reference.antiaim.yaw_jitt[1], "Off")
			set(reference.antiaim.yaw_jitt[2], 0)
			set(reference.antiaim.body_yaw[1], "Off")
			set(reference.antiaim.body_yaw[2], 0)
			set(reference.fakelag.enablefl,true)
			ui.set_visible(reference.fakelag.enablefl,true)
			ui.set_visible(reference.fakelag.fl_amount,true)
			ui.set_visible(reference.fakelag.fl_limit,true)
			ui.set_visible(reference.fakelag.fl_var,true)
        end,

        setup_command = function(c)
			command._states(c)
			command.anti_zeus()
			command.fl_adaptive(c)
			command.anti_aim_on_use(c)
			command.manualaa()
			command.freestand()
			command.aa_builder(c)
			command.anti_backstab()
			command.apply_aa()
			command.teleport()
			command.brute()
        end,

        pre_render = function()
			old_anim()
        end,

		fully_joined = function()
			vars.last_press = 0
			command['switch'] = false
			command.reset_brute()
		end,

		end_round = function()
			command.reset_brute()
		end,

        stored_callbacks = function()
            call("pre_render", callbacks.pre_render)
            call("shutdown", callbacks.shut_down)
            call("paint", callbacks.paint)
            call("paint_ui", callbacks.paint_ui)
            call("setup_command", callbacks.setup_command)
            call("aim_hit", callbacks.aim_hit)
            call("aim_miss", callbacks.aim_miss)
            call("bullet_impact", callbacks.bullet_impact)
            call("player_death", callbacks.player_death)
            call("round_start", callbacks.round_start)
            call("game_newmap", callbacks.new_map)
			call("player_connect_full", callbacks.fully_joined)
			call("round_end", callbacks.end_round)
        end,

		ui.set_callback(antiaim.listbox, function()
			if table.getn(configslist) == 0 then return end
			local cfgpos = get(antiaim.listbox)
			local configs = configslist
			local cfgname = configs[cfgpos + 1]
			if cfgname == nil then return end
			ui.set(antiaim.createtext, cfgname)
		end),

		ui.set_callback(antiaim.publiclistbox, function()
			if table.getn(publicconfigslist) == 0 then return end
			local cfgpos = get(antiaim.publiclistbox)
			local configs = publicconfigstimestamplist
			local update = configs[cfgpos + 1]
			if update == nil then return end
			ui.set(antiaim.updatelabel, "Last update: " .. format_unix_timestamp(update, true, false, 1))
		end)
    }
    callbacks.stored_callbacks()
end
main()