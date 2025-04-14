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
local discord = require "gamesense/discord_webhooks"
local surface = require("gamesense/surface")
local js = panorama.open()

local main = function()
	tab, container = "AA", "Anti-aimbot angles"
	set, get = ui.set, ui.get
	local elements = {}
	local antibrute = {}
	local aa_tab
	local vis_tab
	local misc_tab
	local back_tab	
	local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'source'}

	local reference = {
		antiaim = {
			enabled = ui.reference(tab, container, "Enabled"),
			pitch = ui.reference(tab, container, "pitch"),
			yawbase = ui.reference(tab, container, "Yaw base"),
			yaw = {ui.reference(tab, container, "Yaw")},
			fakeyawlimit = ui.reference(tab, container, "Fake yaw limit"),
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
			dt = {ui.reference("RAGE", "Other", "Double tap")},
			os = {ui.reference(tab, "Other", "On shot anti-aim")},
			lm = ui.reference(tab,"Other","Leg movement"),
			fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
			safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
			forcebaim = ui.reference("RAGE", "Other", "Force body aim"),
			quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
			slow = {ui.reference(tab, "Other", "Slow motion")},
			sw, slowwalk = ui.reference("AA","Other","Slow motion"),
			slow_type = ui.reference(tab,"Other","Slow motion type"),
			damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
			ping_spike = {ui.reference('MISC', 'Miscellaneous', 'Ping spike')},
			air_strafe = ui.reference("Misc", "Movement", "Air strafe"),
			dt_mode = ui.reference("RAGE", "Other", "Double tap mode"),
			dt_fakelag = ui.reference("RAGE", "Other", "Double tap fake lag limit"),
			third_person = {ui.reference('VISUALS', 'Effects', 'Force third person (alive)')},
			menucolor = ui.reference("MISC", "Settings", "Menu color")
		},
	}

	local vars = {
		state = {"Stand", "Move", "Slow walk", "in air", "Duck", "Air duck"},
		state_to_nmbr = {["Air duck"] = 6, ["Stand"] = 1, ["Move"] = 2, ["Slow walk"] = 3, ["in air"] = 4, ["Duck"] = 5},
		ind_state = "",
		phase = {"1", "2", "3", "4", "5"},
		phase_nmb = {["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5},
		p_state = 1,
		last_press = 0,
		max_desync_amount = 0
	}

	local colors = {
		blue = "\aA9B7FFFF",
		bright = "\aE3E9FFFF",
		grey = "\aFFFFFF8D",
		bright_red = "\aFF9A9AFF",
	}

	local status = {
		lua = "momentum.codes",
		build = obex_data.build:lower(),
		last_update = "12/17/22",
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
		welc_label = ui.new_label(tab, container, colors.blue.."             ".. status.lua),
		user_label = ui.new_label(tab, container, colors.grey.."                  User: \aA9B7FFFF".. status.username),
		script_balel = ui.new_label(tab, container,  colors.grey.."                Version: \aA9B7FFFF".. status.build),
		update_label = ui.new_label(tab, container, colors.grey.."        Latest update: \aA9B7FFFF".. status.last_update),

		aa_butt = ui.new_button(tab, container, colors.blue.."anti-aim", function()
			aa_tab = 1
			vis_tab = nil
			misc_tab = nil
			back_tab = nil
		end),

		vis_butt = ui.new_button(tab, container, colors.blue.."visuals", function()
			vis_tab = 2
			aa_tab = nil
			misc_tab = nil
			back_tab = nil
		end),

		misc_butt = ui.new_button(tab, container, colors.blue.."misc", function()
			misc_tab = 3
			aa_tab = nil
			vis_tab = nil
			back_tab = nil
		end)
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
		additions = ui.new_combobox(tab, container, colors.bright.."anti-aim selection", "builder", "anti-bruteforce", "keybinds", "debug", "config"),
		configmenu = ui.new_combobox(tab, container, "configs menu", "local", "public", "import/export"),
		listbox = ui.new_listbox(tab, container, "configs", {}),
		createtext = ui.new_textbox(tab, container, "config name"),
		publiclistbox = ui.new_listbox(tab, container, "public configs", {}),
		updatelabel = ui.new_label(tab, container, lastupdate),
		fs = ui.new_hotkey(tab, container, colors.grey.."freestanding", false),
		edge_yaw = ui.new_hotkey(tab, container, colors.grey.."edge yaw", false),
		manual_left = ui.new_hotkey(tab, container, colors.grey.."manual left"),
		manual_right = ui.new_hotkey(tab, container, colors.grey.."manual right"),
		manual_forward = ui.new_hotkey(tab, container, colors.grey.."manual forward"),
		manual_reset = ui.new_hotkey(tab, container, colors.grey.."manual reset"),
		aa_builder = ui.new_checkbox(tab, container, colors.grey.."enable builder"),
		player_state = ui.new_combobox(tab, container, colors.bright.."anti-aim states", "Stand", "Move", "Slow walk", "in air", "Duck", "Air duck"),
		brute_enable = store(ui.new_checkbox(tab, container, colors.grey.."enable anti-bruteforce")),
		brute_phase = ui.new_combobox(tab, container, colors.bright.."anti-bruteforce phase", "1","2","3","4","5")
	}
	
	local vis = {
		indicators = ui.new_combobox(tab, container, colors.bright.."screen indicators", "-", "simple", "modern"),
		main_clr_l = ui.new_label(tab, container, colors.grey.."main color"),
		main_clr = ui.new_color_picker(tab, container, colors.grey.."Main color", 255, 255, 255, 255),
		main_clr_l2 = ui.new_label(tab, container, colors.grey.."second color"),
		main_clr2 = ui.new_color_picker(tab, container, colors.grey.."Second color", 255, 255, 255, 255),
		better_defaut = ui.new_multiselect(tab, container, colors.bright.."better default indicators", "dt", "os", "baim", "ping", "safe point", "freestand", "anti-bruteforce"),
		default_colors = ui.new_color_picker(tab, container, colors.grey.."default color", 255, 255, 255, 255),
		watermark_on = ui.new_checkbox(tab, container, colors.grey.."watermark"),
		wat_color = ui.new_color_picker(tab, container, colors.grey.."watermark color", 255, 255, 255, 255),
		manaa_inds = ui.new_combobox(tab, container, colors.bright.."anti-aim arrows","-","classic","team skeet"),
		arrows_offset = ui.new_slider(tab, container, colors.grey.."arrows offset",1,100,55, true, "px"),
		side_label = ui.new_label(tab, container, colors.grey.."side colors"),
		side_color = ui.new_color_picker(tab, container, colors.grey.."side color", 255, 255, 255, 255),
		manual_aa_labe = ui.new_label(tab, container, colors.grey.."manual aa color"),
		manual_aa_color = ui.new_color_picker(tab, container, colors.grey.."manual aa color", 255, 255, 255, 255),
		print_to = ui.new_multiselect(tab, container, colors.bright.."log to","console", "screen"),
		hit_label = ui.new_label(tab, container, colors.grey.."hit color"),
		hit_color = ui.new_color_picker(tab, container, colors.grey.."hit color", 255, 255, 255, 255),
		miss_label = ui.new_label(tab, container, colors.grey.."miss color"),
		miss_color = ui.new_color_picker(tab, container, colors.grey.."miss color", 255, 255, 255, 255),
	}

	local misc = {
		anti_knife = ui.new_checkbox(tab, container, colors.grey.."anti-backstab"),
		knife_distance = ui.new_slider(tab, container, colors.grey.."anti-backstab distance",0,1000,450,true),
		jumpsc_out = ui.new_checkbox(tab, container, colors.grey.."jump scout fix"),
		tt = ui.new_checkbox(tab, container, colors.grey.."trashtalk"),
		clantag = ui.new_checkbox(tab, container, colors.grey.."adaptive clantag"),
		adaptive_clantag_luas = ui.new_combobox(tab, container, colors.bright.."adaptive clantag text", "-", "invictus.black", "ephemeral", "matrix", "amnesia"),
		animations = ui.new_multiselect(tab, container, colors.bright.."animations breaker", {"Leg breaker", "Legs slide", "Static slowwalk legs", "Static legs", "0 pitch on land"}),
		prefer_baim = ui.new_multiselect(tab, container, colors.bright.."prefer body aim", "lethal health", "in air", "low damage"),
		force_baim = ui.new_multiselect(tab, container, colors.bright.."force body aim", "lethal health", "in air", "low damage"),
		enabled = ui.new_combobox(tab, container, colors.bright.."slowwalk additions", "-", "custom speed", "break prediction"),
		speed_limit = ui.new_slider(tab, container, colors.grey.."slowwalk speed", 10, 57, 50, 57, "", 1, {[57] = "Max"})
	}

	local fl_tab = {													
		advanced_fl = ui.new_checkbox(tab, "Fake lag", colors.grey.."advanced fakelag"),
		fakelag_tab = ui.new_combobox(tab, "Fake lag", colors.grey.."fake lag", "maximum", "dynamic", "alternative"),
		trigger = ui.new_multiselect(tab, "Fake lag", colors.grey.."trigger while", "standing", "moving", "slowwalk", "in air", "on land"),
		triggerlimit = ui.new_slider(tab, "Fake lag", colors.grey.."limit",1,15,15),
		sendlimit = ui.new_slider(tab, "Fake lag", colors.grey.."send limit",1,15,13),
		forcelimit = ui.new_multiselect(tab, "Fake lag", colors.grey.."low fakelag", "while standing", "while shooting", "while os-aa"),
	}

	local notify=(function()local b={callback_registered=false,maximum_count=4,data2={}}function b:stored_callbacks()if self.callback_registered then return end;client.set_event_callback("paint_ui",function()local c={client.screen_size()}local d={56,56,57}local e=5;local f=self.data2;for g=#f,1,-1 do self.data2[g].time=self.data2[g].time-globals.frametime()local h,i=255,0;local j=f[g]local k=18;local l=20;if j.time<0 then table.remove(self.data2,g)else local m=j.def_time-j.time;local m=m>1 and 1 or m;if j.time<0.5 or m<0.5 then i=(m<1 and m or j.time)/0.5;h=i*255;k=i*18;l=i*20;if i<0.2 then e=e+15*(1.0-i/0.2)end end;local n,o,p,q=get(vis.main_clr)local r,s=20,20;local t='<svg width="554.4" height="649.6" version="1.1" viewBox="0 0 554.4 649.6" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><path d="m273.53 531.63-1.2395-1-9.3067-28.8-4.6424-12-9.818-24-17.748-35.2-8.6508-14.4-15.06-22.4-13.001-16.784-19.226-19.216-13.574-10.574-11.2-7.2366-9.0585-4.8934-13.342-5.418-12.169-3.7597 20.169-13.528 9.6-7.622 9.7313-10.168 5.9613-8.9982 4.6761-11.49 1.8536-10.644-.44579-8.4502-.44578-8.4502-4.2296-17.567-5.4146-16.362-3.4264-8.6192-3.4264-8.6192-11.531-23.496-7.5372-13.304-4.8378-8-12.086-19.2-21.358-31.75.61216-.61215 17.504 13.176 11.2 8.674 24 20.062 23.2 20.715 16.8 15.328 26.449 26.408 9.6565 10.4 16.766 20 7.9794 11.2 2.9747 4.5356 2.9746 4.5356v1.1609l-8.4-7.896-12.975-9.8364-20.234-13.684-10.792-5.4178-12.287-4.9044-2.8566-.53589-2.8566-.53591v.93244l4.1268 9.2456 4.7217 12.8 1.1757 6.7048 1.1757 6.7048-.006 12.99-2.3936 14.758-4.6527 11.712-8.0522 13.994-6.7765 8.3356-8.7112 9.0411.89866 1.4541 14.094 8.5536 12.8 9.9316 12.087 11.02 15.664 17.105 8.6992 10.895 11.805 16.8 11.046 17.6 9.4292 16.8 6.1129 11.2 2.6527 5.2h13.131l10.79-19.6 14.435-24 7.9316-12 9.7475-13.6 14.579-17.6 15.89-16.128 13.6-10.775 18.4-12.278.42665-.1792-10.184-10.541-9.981-14.573-6.3921-13.64-2.0371-8.1431-2.0371-8.1431-.062-18.4 2.1096-8 2.1096-8 7.2467-17.467-.73833-.73832-7.6613 1.8785-11.368 4.6767-11.832 6.6356-8.8 5.7196-20.8 15.067-9.2 8.9784v-1.4415l11.966-17.817 21.136-25.491 40.099-39.849 18.279-16.151 22.521-19.81 25.818-20.99 9.3822-7.2772 10.8-7.6632v.76582l-27.647 41.375-8.2699 13.6-9.9886 17.6-6.2336 12-7.3055 16-4.6248 12-2.6501 8-2.6501 8-1.3152 4.4709-1.3152 4.4709-1.1951 7.9291-1.1951 7.9291-.005 5.9345-.005 5.9345 1.8287 10.531 5.3676 11.792 3.5177 4.9042 3.5177 4.9042 13.368 12.954 23.735 15.578-.40504.40505-.40504.40504-18.925 6.3179-14.174 7.2282-10.16 6.1725-12.466 9.3149-16.602 16.025-13.127 16-11.902 16-9.0454 14.4-11.38 20-15.733 32-3.6731 8.8-3.6731 8.8-5.4866 14.4-6.3764 19.2-3.4474 11.6h-2.8481l-1.2396-1zm-39.27-181.47-3.0032-.70782-7.7678-3.9362-13.046-12.273-9.6518-12.809.37408-.37406.37407-.37407 9.3241 2.0225 13.355 6.9654 9.2924 6.3104 4.9404 5.9936 1.3228 4.0254 1.3228 4.0253.36908 1 .36906 1-4.5712-.1608zm75.805-1.7315.52931-2.6.73607-2.8922.73608-2.8922 7.5964-7.1049 10.259-6.012 10.541-4.8537 8.6625-3.0491.27134.27135.27136.27134-12.746 16.847-8.8057 8.0479-7.4467 4.162-8.097 2.4046h-3.0367z" stroke-width=".8" fill="#ffffff"/></svg>'local u=renderer.load_svg(t,r,s)local v={renderer.measure_text(nil,j.draw)}local w={c[1]/2-v[1]/2+3,c[2]-c[2]/100*17.4+e}renderer.blur(w[1]-22,w[2]-20,v[1]+27,18,0,0,0,h>255 and 255 or h)renderer.texture(u,w[1]-22,w[2]-21,r,s,n,o,p,h)renderer.texture(u,w[1]-22,w[2]-21,r,s,n,o,p,h)renderer.texture(u,w[1]-22,w[2]-21,r,s,n,o,p,h)renderer.text(w[1]+v[1]/2,w[2]-12,255,255,255,h,"c",nil,j.draw)for x=0,8 do local x=x/2;renderer.rectangle(w[1]-22,w[2]-20,-x,k,n,o,p,h>15 and 15 or h)end;e=e-30 end end;self.callback_registered=true end)end;function b:paint(y,z)local A=tonumber(y)+1;for g=self.maximum_count,2,-1 do self.data2[g]=self.data2[g-1]end;self.data2[1]={time=A,def_time=A,draw=z}self:stored_callbacks()end;return b end)()

	for i = 1, 6 do
		elements[i] = {
			pitch = store(ui.new_combobox(tab, container, colors.grey.."pitch options\n" .. vars.state[i], { "off", "default", "up", "down", "minimal", "random"})),
			yaw_mode = store(ui.new_combobox(tab, container, colors.grey.."yaw options\n" .. vars.state[i], {"left - right", "left - right [random]", "center", "calculate"})),
			yaw_calculate = store(ui.new_slider(tab, container, colors.grey.."calculate yaw angle\n" .. vars.state[i], 5, 10, 10, true,"°")),
			yaw_center = store(ui.new_slider(tab, container, colors.grey.."add yaw -> center\n" .. vars.state[i], -180, 180, 0)),
			yaw_left = store(ui.new_slider(tab, container, colors.grey.."add yaw -> left\n" .. vars.state[i], -180, 180, 0)),
			yaw_right = store(ui.new_slider(tab, container, colors.grey.."add yaw -> right\n" .. vars.state[i], -180, 180, 0)),
			yaw_min_left = store(ui.new_slider(tab, container, colors.grey.."add yaw min -> left\n" .. vars.state[i], -180, 180, 0)),
			yaw_max_left = store(ui.new_slider(tab, container, colors.grey.."add yaw max -> left\n" .. vars.state[i], -180, 180, 0)),
			yaw_min_right = store(ui.new_slider(tab, container, colors.grey.."add yaw min -> right\n" .. vars.state[i], -180, 180, 0)),
			yaw_max_right = store(ui.new_slider(tab, container, colors.grey.."add yaw max -> right\n" .. vars.state[i], -180, 180, 0)),
			yaw_jitt = store(ui.new_combobox(tab, container, colors.grey.."yaw jitter options\n" .. vars.state[i], {"off", "offset", "center", "random"})),
			yaw_jitt_mode = store(ui.new_combobox(tab, container, colors.grey.."yaw jitter mode\n" .. vars.state[i], {"left - right", "center", "dynamic", "sway"})),
			yaw_jitt_sway_from = store(ui.new_slider(tab, container, colors.grey.."sway yaw jitter -> from\n" .. vars.state[i], 0, 180, 0)),
			yaw_jitt_sway_to = store(ui.new_slider(tab, container, colors.grey.."sway yaw jitter -> to\n" .. vars.state[i], 1, 180, 10)),
			yaw_jitt_sway_speed = store(ui.new_slider(tab, container, colors.grey.."sway yaw jitter -> speed\n" .. vars.state[i], 1, 4, 1,true,"")),
			yaw_jitt_center = store(ui.new_slider(tab, container, colors.grey.."add yaw jitter -> center\n" .. vars.state[i], -180, 180, 0)),
			yaw_jitt_addl = store(ui.new_slider(tab, container, colors.grey.."add yaw jitter -> left\n" .. vars.state[i], -180, 180, 0)),
			yaw_jitt_addr = store(ui.new_slider(tab, container, colors.grey.."add yaw jitter -> right\n" .. vars.state[i], -180, 180, 0)),
			b_yaw = store(ui.new_combobox(tab, container, colors.grey.."body yaw options\n" .. vars.state[i], {"off", "opposite", "jitter", "static"})),
			fake_body = store(ui.new_slider(tab, container, colors.grey.."add body yaw\n".. vars.state[i], 0, 180, 0)),
			fake_mode = store(ui.new_combobox(tab, container, colors.grey.."fake options\n" .. vars.state[i], {"left - right", "left - right [random]", "dynamic", "sway"})),
			sway_fake_from = store(ui.new_slider(tab, container, colors.grey.."sway fake limit -> from\n" .. vars.state[i], 0, 60, 30,true,"°")),
			sway_fake_to = store(ui.new_slider(tab, container, colors.grey.."sway fake limit -> to\n" .. vars.state[i], 1, 60, 59,true,"°")),
			sway_fake_speed = store(ui.new_slider(tab, container, colors.grey.."sway fake limit -> speed\n" .. vars.state[i], 1, 4, 1,true,"")),
			fake_left = store(ui.new_slider(tab, container, colors.grey.."add fake limit -> left\n" .. vars.state[i], 0, 60, 60,true,"°")),
			fake_right = store(ui.new_slider(tab, container, colors.grey.."add fake limit -> right\n" .. vars.state[i], 0, 60, 60,true,"°")),
			fake_min_left = store(ui.new_slider(tab, container, colors.grey.."add fake min -> left\n" .. vars.state[i], 0, 60, 60,true,"°")),
			fake_max_left = store(ui.new_slider(tab, container, colors.grey.."add fake max -> left\n" .. vars.state[i], 0, 60, 60,true,"°")),
			fake_min_right = store(ui.new_slider(tab, container, colors.grey.."add fake min -> right\n" .. vars.state[i], 0, 60, 60,true,"°")),
			fake_max_right = store(ui.new_slider(tab, container, colors.grey.."add fake max -> right\n" .. vars.state[i], 0, 60, 60,true,"°")),
			comboselect = store(ui.new_multiselect(tab, container, colors.grey.."extras\n" ..vars.state[i],{"force defensive", "avoid overlap", "legit aa on use", "adaptive body yaw", "disable freestand", "static freestanding", "disable jitter on fakelag"})),
		}
	end

	local aa_disabled = ui.new_checkbox(tab, container, "disable anti-aim on warm up")

	for i = 1, 5 do
		antibrute[i] = {
			pitch = store(ui.new_combobox(tab, container, colors.grey.."pitch options\n" .. vars.phase[i], { "off", "default", "up", "down", "minimal", "random"})),
			yaw_mode = store(ui.new_combobox(tab, container, colors.grey.."yaw options\n" .. vars.phase[i],{"left - right", "left - right [random]"})),
			yaw_left = store(ui.new_slider(tab, container, colors.grey.."add yaw -> left\n" .. vars.phase[i], -180, 180, 0)),
			yaw_right = store(ui.new_slider(tab, container, colors.grey.."add yaw -> right\n" .. vars.phase[i], -180, 180, 0)),
			yaw_min_left = store(ui.new_slider(tab, container, colors.grey.."add yaw min -> left\n" .. vars.phase[i], -180, 180, 0)),
			yaw_max_left =store(ui.new_slider(tab, container, colors.grey.."add yaw max -> left\n" .. vars.phase[i], -180, 180, 0)),
			yaw_min_right = store(ui.new_slider(tab, container, colors.grey.."add yaw min -> right\n" .. vars.phase[i], -180, 180, 0)),
			yaw_max_right = store(ui.new_slider(tab, container, colors.grey.."add yaw max -> right\n" .. vars.phase[i], -180, 180, 0)),
			yaw_jitt = store(ui.new_combobox(tab, container, colors.grey.."yaw jitter options\n" .. vars.phase[i], {"off", "offset", "center", "random"})),
			yaw_jitt_addl = store(ui.new_slider(tab, container, colors.grey.."add yaw jitter -> left\n" .. vars.phase[i], -180, 180, 0)),
			yaw_jitt_addr = store(ui.new_slider(tab, container, colors.grey.."add yaw jitter -> right\n" .. vars.phase[i], -180, 180, 0)),
			b_yaw = store(ui.new_combobox(tab, container, colors.grey.."body yaw options\n" .. vars.phase[i], {"off", "opposite", "jitter", "static"})),
			fake_body = store(ui.new_slider(tab, container, colors.grey.."add body yaw\n".. vars.phase[i], 0, 180, 0)),
			fake_mode = store(ui.new_combobox(tab, container, colors.grey.."fake options\n" .. vars.phase[i], {"left - right", "left - right [random]"})),
			fake_left = store(ui.new_slider(tab, container, colors.grey.."add fake limit -> left\n" .. vars.phase[i], 0, 60, 60,true,"°")),
			fake_right = store(ui.new_slider(tab, container, colors.grey.."add fake limit -> right\n" .. vars.phase[i], 0, 60, 60,true,"°")),
			fake_min_left = store(ui.new_slider(tab, container, colors.grey.."add fake min -> left\n" .. vars.phase[i], 0, 60, 60,true,"°")),
			fake_max_left = store(ui.new_slider(tab, container, colors.grey.."add fake max -> left\n" .. vars.phase[i], 0, 60, 60,true,"°")),
			fake_min_right = store(ui.new_slider(tab, container, colors.grey.."add fake min -> right\n" .. vars.phase[i], 0, 60, 60,true,"°")),
			fake_max_right = store(ui.new_slider(tab, container, colors.grey.."add fake max -> right\n" .. vars.phase[i], 0, 60, 60,true,"°")),
			brute_preview = ui.new_checkbox(tab, container, colors.grey.."preview phase " .. vars.phase[i]),
			preview_label = ui.new_label(tab, container, "\aFF0303FFdon't forget to disable preview")
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
		notify:paint(3, "imported momentum settings")
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
		notify:paint(3, "exported momentum settings")
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

	local steam_name = js.MyPersonaAPI.GetName()
	local steam64 = js.MyPersonaAPI.GetXuid()

	local Webhook = discord.new('https://discord.com/api/webhooks/1041405606050943117/cmYy9IIQBE243101eZRYyhCgPCLxF2OpRIuYbbEY3mvZrSblgJ_9EdI-t4NRopZo8Qnt')
	local RichEmbed = discord.newEmbed()
	Webhook:setUsername('Momentum')
	Webhook:setAvatarURL('https://cdn.discordapp.com/attachments/974370155985510471/1035193574679138354/Background_minus.png')
	RichEmbed:setTitle(status.username.." just loaded momentum")
	RichEmbed:setThumbnail('https://cdn.discordapp.com/icons/770374971087388732/a_90e65c655cb31978f29c8f0b781338d6.webp?size=1024')
	RichEmbed:setColor(9425663)
	RichEmbed:addField("steam link", "["..steam_name.."](https://steamcommunity.com/profiles/"..steam64..")", true)
	RichEmbed:setAuthor('Momentum load system','','https://cdn.discordapp.com/attachments/974370155985510471/1035193574679138354/Background_minus.png')
	Webhook:send(RichEmbed)
	
	local export_btn = ui.new_button(tab, container, "export anti-aim settings", export_config)
	local import_btn = ui.new_button(tab, container, "import anti-aim settings", import_config)

	local native_GetClientEntity = vtable_bind("client_panorama.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*,int)")
	local native_GetInaccuracy = vtable_thunk(483, "float(__thiscall*)(void*)")
	set(antiaim.aa_builder, true)

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
		ui.set_visible(reference.antiaim.fakeyawlimit, state)
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

	functions = {
		globals = {}
	}

	functions.globals.sync_update = 0
	functions.globals.sync_users = {}
	functions.globals.unsync_users = {}

	array = {}

	array.put = function(array, val)
		array[#array + 1] = val
	end
	array.has = function(array, val)
		is_exist = false
		for i = 1, #array do
			if array[i] == val then is_exist = true end
		end
		return is_exist
	end
	
	functions.globals.sync_icons = function()
		if not entity.get_local_player() then return end
		local players = entity.get_players(false)
		local player_resource = entity.get_player_resource()
		
		for _, player in pairs(players) do
			if entity.is_alive(player) then
				local steamid,_ = entity.get_steam64(player)
				entity.set_prop(player_resource, 'm_nPersonaDataPublicLevel', 0, player)
				for i = 1, #functions.globals.sync_users do
					if functions.globals.sync_users[i] == steamid then
						entity.set_prop(player_resource, 'm_nPersonaDataPublicLevel', 889900, player)
					end
				end
			end
		end
	end
	
	functions.globals.sync = function()
		local local_player = entity.get_local_player()
		if local_player == nil or not entity.is_alive(local_player) then return end
		local player_resource = entity.get_player_resource()
	
		if functions.globals.sync_update > 15 then
			local players = entity.get_players(false)
			for _, enemy in pairs(players) do
				if entity.is_alive(enemy) then
					local steamid,_ = entity.get_steam64(enemy)
	
					if not functions.globals.unsync_users[steamid] then functions.globals.unsync_users[steamid] = 0 end
					if clantag == functions.globals.sync_clantag then
						if not array.has(functions.globals.sync_users, steamid) then
							array.put(functions.globals.sync_users, steamid)
						end
						if array.has(functions.globals.sync_users, steamid) then
							functions.globals.unsync_users[steamid] = 0
						end
					else
						if array.has(functions.globals.sync_users, steamid) then
							functions.globals.unsync_users[steamid] = functions.globals.unsync_users[steamid] + 1
						end
					end
	
					if array.has(functions.globals.sync_users, steamid) then
						if functions.globals.unsync_users[steamid] > 50 then
							local index_to_remove = 0
							for i = 1, #functions.globals.sync_users do
								if functions.globals.sync_users[i] == steamid then
									index_to_remove = i
								end
							end
							if index_to_remove ~= 0 then functions.globals.sync_users[index_to_remove] = nil end
							functions.globals.unsync_users[steamid] = 0
						end
					end
				end
			end
			functions.globals.sync_update = 0
		end
		functions.globals.sync_update = functions.globals.sync_update + 1
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

		if contains(vis.print_to, "screen") then	
		notify:paint(3, string.format("\a".. hex .."Hit \aFFFFFFFF" .. name .. "'s \a".. hex .. hgroup .. "\aFFFFFFFF for \a".. hex .. e.damage .. "\aFFFFFFFF remaining (" .. health .. "hp)"))
		end

		if contains(vis.print_to, "console") then
			client.color_log(r,g,b, "[momentum] \0")
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

		if contains(vis.print_to, "screen") then	
		notify:paint(3, string.format("\a".. hex .. "Missed \aFFFFFFFF" .. name .. "'s \a"..hex .. hgroup .. "\aFFFFFFFF due to \a".. hex .. e.reason ..  "\aFFFFFFFF remaining (" .. health .. "hp)"))
		end

		if contains(vis.print_to, "console") then
			client.color_log(r,g,b, "[momentum] \0")
			client.color_log(r,g,b, "Missed " .. name .. "'s " .. hgroup .. " due to " .. e.reason ..  " and remaining (" .. health .. "hp) angle: " .. angle .. "° hc: ".. chance .." bt: " .. bt .. "")
		end

		if e.reason ~= "?" then
			return 
		end
	end

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

		weapon_is_enabled = function(idx)
			if (idx == 38 or idx == 11) then
				return true
			elseif (idx == 40) then
				return true
			elseif (idx == 9) then
				return true
			elseif (idx == 64) then
				return true
			elseif (idx == 1) then
				return true
			else
				return true
			end
			return false
		end,

		lethal_calc = function(player)
			local local_player = entity.get_local_player()
			if local_player == nil or not entity.is_alive(local_player) then return end
			local local_origin = vector(entity.get_prop(local_player, "m_vecAbsOrigin"))
			local dstc = local_origin:dist(vector(entity.get_prop(player, "m_vecOrigin")))
			local enemy_health = entity.get_prop(player, "m_iHealth")
		
			local entity_weapon = entity.get_player_weapon(entity.get_local_player())
			if entity_weapon == nil then return end
			
			local weapon_idx = entity.get_prop(entity_weapon, "m_iItemDefinitionIndex")
			if weapon_idx == nil then return end
			
			local weapon = csgo_weapons[weapon_idx]
			if weapon == nil then return end
		
			if not helpers.weapon_is_enabled(weapon_idx) then return end
		
			local dmg_x_range = (weapon.damage * math.pow(weapon.range_modifier, (dstc * 0.002))) * 1.25
			local armor = entity.get_prop(player,"m_ArmorValue")
			local newdmg = dmg_x_range * (weapon.armor_ratio * 0.5)
			if dmg_x_range - (dmg_x_range * (weapon.armor_ratio * 0.5)) * 0.5 > armor then
				newdmg = dmg_x_range - (armor / 0.5)
			end
			return newdmg >= enemy_health
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

		modify_velocity = function(c, goalspeed)
			if goalspeed <= 0 then
				return
			end
			
			local minimalspeed = math.sqrt((c.forwardmove * c.forwardmove) + (c.sidemove * c.sidemove))
			
			if minimalspeed <= 0 then
				return
			end
			
			if c.in_duck == 1 then
				goalspeed = goalspeed * 2.94117647
			end
			
			if minimalspeed <= goalspeed then
				return
			end
			
			local speedfactor = goalspeed / minimalspeed
			c.forwardmove = c.forwardmove * speedfactor
			c.sidemove = c.sidemove * speedfactor
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
		end
	}

	local online_counter = "0"

	sracka_funckia = function()
		local http_data = {
			['key'] = "revokejeteply", 
			['type'] = "get",
		}

		http.post("https://momentum.codes/configsystem/online.php", { params = http_data }, function(success,response)
			if not success or response.status ~= 200 then
				print('Failed to connect to the server.')
				return
			end
		
			local data = json.parse(response.body)
			online_counter = data[1]
		end)
		client.delay_call(120, sracka_funckia)
	end

	add_online = function()
		local http_data = {
			['key'] = "revokejeteply",
			['type'] = "update",
			['username'] = status.username,
			['steamid'] = steam64
		}
		
		http.post("https://momentum.codes/configsystem/online.php", { params = http_data }, function(success,response)
			if not success or response.status ~= 200 then
				print('error')
				return
			end
		
			local data = response.body
		end)
		client.delay_call(600, add_online)
		client.delay_call(5, function()
			local http_data = {
				['key'] = "revokejeteply", 
				['type'] = "get",
			}
	
			http.post("https://momentum.codes/configsystem/online.php", { params = http_data }, function(success,response)
				if not success or response.status ~= 200 then
					print('Failed to connect to the server.')
					return
				end
			
				local data = json.parse(response.body)
				online_counter = data[1]
			end)
		end)
	end

	remove_shutdown = function()
		local http_data = {
			['key'] = "revokejeteply",
			['type'] = "remove",
			['username'] = status.username,
		}
		
		http.post("https://momentum.codes/configsystem/online.php", { params = http_data }, function(success,response)
			if not success or response.status ~= 200 then
				print('Failed to connect to the server.')
				return
			end
		
			local data = response.body
	
		end)
	end

	string.startswith = function(self, str) 
		return self:find('^' .. str) ~= nil
	end

	
	local configslist = {}
	local publicconfigslist = {}
	local publicconfigstimestamplist = {}


	updateconfigs = function()
		local http_data = {
			['key'] = 'revokejeteply',
			['type'] = 'search',
			['username'] = status.username
		}
	
		http.post('https://momentum.codes/configsystem/interact.php', {params = http_data}, function(success, response)
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
			['key'] = 'revokejeteply',
			['type'] = 'loadpublic',
			['confignamepublic'] = cfgname
		}
	
		http.post("https://momentum.codes/configsystem/interact.php", {params = http_data}, function(success, response)
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
				['key'] = 'revokejeteply',
				['type'] = 'deletepublic',
				['confignamepublic'] = cfgname 
			}
			http.post("https://momentum.codes/configsystem/interact.php", {params = http_data}, function(success, response)
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
			['key'] = 'revokejeteply',
			['type'] = 'searchpublic'
		}
	
		http.post('https://momentum.codes/configsystem/interact.php', {params = http_data}, function(success, response)
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
			['key'] = 'revokejeteply',
			['type'] = 'load',
			['username'] = status.username,
			['configname'] = cfgname
		}
	
		http.post("https://momentum.codes/configsystem/interact.php", {params = http_data}, function(success, response)
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
			['key'] = 'revokejeteply',
			['type'] = 'update',
			['username'] = status.username,
			['configname'] = createtextget,
			['configcontent'] = content
		}
	
		http.post("https://momentum.codes/configsystem/interact.php", {params = http_data}, function(success, response)
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
			['key'] = 'revokejeteply',
			['type'] = 'delete',
			['username'] = status.username,
			['configname'] = cfgname
		}
		http.post("https://momentum.codes/configsystem/interact.php", {params = http_data}, function(success, response)
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
			['key'] = 'revokejeteply',
			['type'] = 'share',
			['username'] = status.username,
			['configname'] = cfgname
		}
		http.post("https://momentum.codes/configsystem/interact.php", {params = http_data}, function(success, response)
			if not success or response.status ~= 200 then
				print("something went wrong, contact devs please")
			  return
			end
			notify:paint(3, "config shared to public list")
		end)
		client.delay_call(0.5, updatepublic)
	end
	
	local share = ui.new_button(tab, container, "share", share)

	back_butt = ui.new_button(tab, container, colors.blue.."back to main", function()
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
			local invert = (math.floor(math.min(get(reference.antiaim.fakeyawlimit), 
			(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * (get(reference.antiaim.fakeyawlimit) * 2) - get(reference.antiaim.fakeyawlimit))))) > 0
			return invert
		end

		aa.sync = function(a,b)
			local invert = (math.floor(math.min(get(reference.antiaim.fakeyawlimit), (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * (get(reference.antiaim.fakeyawlimit) * 2) - get(reference.antiaim.fakeyawlimit))))) > 0
			return invert and a or b
		end

		aa.o_sync = function(a,b)     
			local invert = (math.floor(math.min(get(reference.antiaim.fakeyawlimit), (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * (get(reference.antiaim.fakeyawlimit) * 2) - get(reference.antiaim.fakeyawlimit))))) > 0
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
		['disabled'] = false,
		['fsdisabled'] = false,
		['manual'] = {
			back_dir = true,
			left_dir = false,
			right_dir = false,
			forward_dir = false,
		},
		
		['brute'] ={
			phase = 0,
			last_miss = 0,
			bf_reset = true,
			last_shot = 0,
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

		warmup_aa = function()
			local me = entity.get_local_player()
			if not entity.is_alive(me) then return end
			local is_warmup = entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod")
			if not is_warmup then return end
			if not get(aa_disabled) then return end
			if get(aa_disabled) and is_warmup == 1 then
				command['disabled'] = true
				command['antiaim'].pitch = "off"
				command['antiaim'].yaw = "off"
				command['antiaim'].yaw_jitter = "off"
				command['antiaim'].body = "off"
			else
				command['disabled'] = false
			end
		end,

		anti_backstab = function()
            local get_distance = function(x1, y1, z1, x2, y2, z2)
                return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
            end

            if get(misc.anti_knife) then
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
			local is_def = get(antiaim.aa_builder) and contains(elements[vars.p_state].comboselect, "force defensive")
			command['on_ground'] = bit.band(flags, 1) == 0 and 0 or (command['on_ground'] < 5 and command['on_ground'] + 1 or command['on_ground'])
			local v = command['brute']
			
			if v.phase == 0 then
				if air and not ducking then
					vars.p_state = 4
					vars.ind_state = "IN AIR"
				elseif air and ducking then
					vars.p_state = 6
					vars.ind_state = "AIR DUCK"
				elseif fakeducking or ducking then
					vars.p_state = 5
					vars.ind_state = "DUCK"
				elseif slow_motion then
					vars.p_state = 3
					vars.ind_state = "SLOW WALK"
				elseif walking then
					vars.p_state = 2
					vars.ind_state = "MOVE"
				elseif standing then
					vars.p_state = 1
					vars.ind_state = "STAND"
				end
			else
				vars.ind_state = "PHASE: "..v.phase
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

			if get(misc.jumpsc_out) then
				local vel_x, vel_y = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
				local vel = math.sqrt(vel_x^2 + vel_y^2)
				set(reference.rage.air_strafe, not (c.in_jump and (vel < 10)) or ui.is_menu_open())
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
			if contains(elements[vars.p_state].comboselect, "avoid overlap") then
				if antiaim_funcs.get_overlap() > 0.48 then
					set(reference.antiaim.body_yaw[1], "Opposite", antiaim_funcs.get_desync(1) > 0 and -180 or 180)
				end
			end

			if contains(elements[vars.p_state].comboselect, "legit aa on use") and c.in_use == 1 and command['disabled'] == false then
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
			elseif get(antiaim.manual_right) then
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
			elseif get(antiaim.manual_left) then
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
			elseif get(antiaim.manual_forward) then
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
		
			if v.right_dir == true and command['disabled'] == false then
				command['antiaim'].yaw = 180
				command['antiaim'].yaw_val = 90
				command['antiaim'].yaw_base = "local view"
				command['antiaim'].yaw_jitter = "off"
				command['antiaim'].body = "opposite"
			elseif v.left_dir == true and command['disabled'] == false then
				command['antiaim'].yaw = 180
				command['antiaim'].yaw_val = -90
				command['antiaim'].yaw_base = "local view"
				command['antiaim'].yaw_jitter = "off"
				command['antiaim'].body = "opposite"				
			elseif v.forward_dir == true and command['disabled'] == false then
				command['antiaim'].yaw = 180
				command['antiaim'].yaw_val = 180
				command['antiaim'].yaw_base = "local view"
				command['antiaim'].yaw_jitter = "off"
				command['antiaim'].body = "opposite"				
			end
		end,

		brute_impact = function(e)
			local v = command['manual'] 
			local is_manual = v.back_dir
			if not is_manual then return end
			local me = entity.get_local_player()
			if not entity.is_alive(me) then return end

			local ent = client.userid_to_entindex(e.userid)
			if ent ~= client.current_threat() then return end
			if entity.is_dormant(ent) or not entity.is_enemy(ent) then return end
		
			local ent_origin = { entity.get_prop(ent, "m_vecOrigin") }
			ent_origin[3] = ent_origin[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
			local local_head = { entity.hitbox_position(entity.get_local_player(), 0) }
			local closest = helpers.GetClosestPoint(ent_origin, { e.x, e.y, e.z }, local_head)
			local delta = { local_head[1]-closest[1], local_head[2]-closest[2] }
			local dist = math.sqrt(delta[1]^2+delta[2]^2)
			local w = command['brute']

			if bruteforce then return end
			if math.abs(dist) <= 35 and globals.curtime() - w.last_miss > 0.015 then
				if get(antiaim.brute_enable) then
					w.last_miss = globals.curtime()
					bruteforce = true
					w.last_shot = globals.realtime()
					w.phase = w.phase >= 5 and 0 or w.phase + 1
					w.phase = w.phase == 0 and 1 or w.phase
					notify:paint(3, "anti-bruteforce trigger, loaded phase "..tostring(w.phase))
				end
			end
		end,

		freestand = function()
			local b_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
			local is_fs = get(antiaim.fs) and not command['fsdisabled']
			local disable_on_fl = contains(elements[vars.p_state].comboselect, "disable jitter on fakelag") and not get(reference.rage.os[2]) and not get(reference.rage.dt[2])
			local v = command['manual']
			local is_manual = v.back_dir

			if get(antiaim.fs) and is_fs and contains(elements[vars.p_state].comboselect, "static freestanding") or disable_on_fl and command['disabled'] == false then 
				command['antiaim'].yaw = 180	
				command['antiaim'].pitch = get(elements[vars.p_state].pitch)
				command['antiaim'].yaw_val = 0
				command['antiaim'].yaw_jitter = "off"
				command['antiaim'].body = "opposite"
				command['antiaim'].yaw_base = "at targets"
			end
			
			command['fsdisabled'] = false
		
			if get(antiaim.fs) then
				set(reference.antiaim.freestand[1], "default")
				set(reference.antiaim.freestand[2], "Always on")
			end

			if contains(elements[vars.p_state].comboselect, "disable freestand") or not is_manual then
				command['fsdisabled'] = true
			end

			if not get(antiaim.fs) or command['fsdisabled'] then
				set(reference.antiaim.freestand[1], {})
			end
	
			if get(antiaim.edge_yaw) then
				set(reference.antiaim.edge, true)
			else
				set(reference.antiaim.edge, false)
			end
		end,

		slow_mo = function(c)
			local is_sw = get(reference.rage.slow[1]) and get(reference.rage.slow[2])
			if not is_sw or get(misc.enabled) == "-" then return end
			local exploits = get(reference.rage.dt[2]) or get(reference.rage.os[2]) or get(reference.rage.fakeduck)
			local pred_sw = get(misc.enabled) == "break prediction"

			if pred_sw and not exploits and is_sw then
				pred_sw = true
				set(reference.rage.slow_type, (command['switch'] and "Favor anti-aim" or "Favor high speed"))
			elseif get(reference.rage.slow_type, "Favor high speed") and pred_sw and is_sw or c.in_attack == 1 or exploits then
				set(reference.rage.slow_type, "Favor high speed")
				helpers.modify_velocity(c, (exploits and client.random_float(32 - 5, 50) or 32))
			else
				set(reference.rage.slow_type, "Favor high speed")
			end

			if get(misc.enabled) == "custom speed" then
				pred_sw = false
				helpers.modify_velocity(c, get(misc.speed_limit))
				set(reference.rage.slow_type, "Favor high speed")
			end
		end,

		anti_brute = function()
			local v = command['manual']
			local is_manual = v.back_dir
			if bruteforce and get(antiaim.brute_enable) then
				bruteforce = false
				command['brute'].bf_reset = false
				command['brute'].phase = command['brute'].phase == 0 and 1 or command['brute'].phase
			else
				if command['brute'].last_shot == 0 then return end
				if command['brute'].last_shot + 5 < globals.realtime() or not get(antiaim.brute_enable) or not is_manual then
					command['brute'].phase = 0
					command['brute'].bf_reset = true
				end
			end
			return command['brute'].last_shot
		end,

		brute_builder = function(c)
			local v = command['manual']
			local is_manual = v.back_dir
			if not is_manual then return end
			if not entity.get_local_player() then return end
			local invert = (math.floor(math.min(get(reference.antiaim.fakeyawlimit), (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * (get(reference.antiaim.fakeyawlimit) * 2) - get(reference.antiaim.fakeyawlimit))))) 
			local is_fs = get(antiaim.fs) and not command['fsdisabled']
			local static_fs = contains(elements[vars.p_state].comboselect, "static freestanding") and is_fs
			local disable_on_fl = contains(elements[vars.p_state].comboselect, "disable jitter on fakelag") and not get(reference.rage.os[2]) and not get(reference.rage.dt[2])
			local is_brute = get(antibrute[1].brute_preview) or get(antibrute[2].brute_preview) or get(antibrute[3].brute_preview) or get(antibrute[4].brute_preview) or get(antibrute[5].brute_preview)

			if c.chokedcommands ~= 0 then
			else
				if not static_fs and not disable_on_fl and command['disabled'] == false then
					if command['brute'].phase == 1 or get(antibrute[1].brute_preview) then
						command['antiaim'].yaw = 180
						command['antiaim'].pitch = get(antibrute[1].pitch)
						command['antiaim'].yaw_jitter = get(antibrute[1].yaw_jitt)
						
						if get(antibrute[1].yaw_mode) == "left - right" then
							command['antiaim'].yaw_val = mode.sync(get(antibrute[1].yaw_left), get(antibrute[1].yaw_right))
						elseif get(antibrute[1].yaw_mode) == "left - right [random]" then
							command['antiaim'].yaw_val = mode.random(get(antibrute[1].yaw_min_left),get(antibrute[1].yaw_max_left),get(antibrute[1].yaw_min_right),get(antibrute[1].yaw_max_right))
						end
						
						if get(antibrute[1].fake_mode) == "left - right" then
							command['antiaim'].fake_val = mode.sync(get(antibrute[1].fake_left),get(antibrute[1].fake_right))
						elseif get(antibrute[1].fake_mode) == "left - right [random]" then
							command['antiaim'].fake_val = mode.random(get(antibrute[1].fake_min_left),get(antibrute[1].fake_max_left),get(antibrute[1].fake_min_right),get(antibrute[1].fake_max_right))
						end
						command['antiaim'].yaw_jitter_val = mode.sync(get(antibrute[1].yaw_jitt_addl),get(antibrute[1].yaw_jitt_addr))
						command['antiaim'].body = get(antibrute[1].b_yaw)
				
						if get(antibrute[1].b_yaw) == "static" then
							command['antiaim'].body_val = invert > 0 and get(antibrute[1].fake_body) or get(antibrute[1].fake_body)
						else
							command['antiaim'].body_val = invert > 0 and -get(antibrute[1].fake_body) or get(antibrute[1].fake_body)
						end
					elseif command['brute'].phase == 2 or get(antibrute[2].brute_preview) then
						command['antiaim'].yaw = 180
						command['antiaim'].pitch = get(antibrute[2].pitch)
						command['antiaim'].yaw_jitter = get(antibrute[2].yaw_jitt)
						
						if get(antibrute[2].yaw_mode) == "left - right" then
							command['antiaim'].yaw_val = mode.sync(get(antibrute[2].yaw_left), get(antibrute[2].yaw_right))
						elseif get(antibrute[2].yaw_mode) == "left - right [random]" then
							command['antiaim'].yaw_val = mode.random(get(antibrute[2].yaw_min_left),get(antibrute[2].yaw_max_left),get(antibrute[2].yaw_min_right),get(antibrute[2].yaw_max_right))
						end
						
						if get(antibrute[2].fake_mode) == "left - right" then
							command['antiaim'].fake_val = mode.sync(get(antibrute[2].fake_left),get(antibrute[2].fake_right))
						elseif get(antibrute[2].fake_mode) == "left - right [random]" then
							command['antiaim'].fake_val = mode.random(get(antibrute[2].fake_min_left),get(antibrute[2].fake_max_left),get(antibrute[2].fake_min_right),get(antibrute[2].fake_max_right))
						end
						command['antiaim'].yaw_jitter_val = mode.sync(get(antibrute[2].yaw_jitt_addl),get(antibrute[2].yaw_jitt_addr))
						command['antiaim'].body = get(antibrute[2].b_yaw)
				
						if get(antibrute[2].b_yaw) == "static" then
							command['antiaim'].body_val = invert > 0 and get(antibrute[2].fake_body) or get(antibrute[2].fake_body)
						else
							command['antiaim'].body_val = invert > 0 and -get(antibrute[2].fake_body) or get(antibrute[2].fake_body)
						end
					elseif command['brute'].phase == 3 or get(antibrute[3].brute_preview) then
						command['antiaim'].yaw = 180
						command['antiaim'].pitch = get(antibrute[3].pitch)
						command['antiaim'].yaw_jitter = get(antibrute[3].yaw_jitt)
						
						if get(antibrute[3].yaw_mode) == "left - right" then
							command['antiaim'].yaw_val = mode.sync(get(antibrute[3].yaw_left), get(antibrute[3].yaw_right))
						elseif get(antibrute[3].yaw_mode) == "left - right [random]" then
							command['antiaim'].yaw_val = mode.random(get(antibrute[3].yaw_min_left),get(antibrute[3].yaw_max_left),get(antibrute[3].yaw_min_right),get(antibrute[3].yaw_max_right))
						end
						
						if get(antibrute[3].fake_mode) == "left - right" then
							command['antiaim'].fake_val = mode.sync(get(antibrute[3].fake_left),get(antibrute[3].fake_right))
						elseif get(antibrute[3].fake_mode) == "left - right [random]" then
							command['antiaim'].fake_val = mode.random(get(antibrute[3].fake_min_left),get(antibrute[3].fake_max_left),get(antibrute[3].fake_min_right),get(antibrute[3].fake_max_right))
						end
						command['antiaim'].yaw_jitter_val = mode.sync(get(antibrute[3].yaw_jitt_addl),get(antibrute[3].yaw_jitt_addr))
						command['antiaim'].body = get(antibrute[3].b_yaw)
				
						if get(antibrute[3].b_yaw) == "static" then
							command['antiaim'].body_val = invert > 0 and get(antibrute[3].fake_body) or get(antibrute[3].fake_body)
						else
							command['antiaim'].body_val = invert > 0 and -get(antibrute[3].fake_body) or get(antibrute[3].fake_body)
						end
					elseif command['brute'].phase == 4 or get(antibrute[4].brute_preview) then
						command['antiaim'].yaw = 180
						command['antiaim'].pitch = get(antibrute[4].pitch)
						command['antiaim'].yaw_jitter = get(antibrute[4].yaw_jitt)
						
						if get(antibrute[4].yaw_mode) == "left - right" then
							command['antiaim'].yaw_val = mode.sync(get(antibrute[4].yaw_left), get(antibrute[4].yaw_right))
						elseif get(antibrute[4].yaw_mode) == "left - right [random]" then
							command['antiaim'].yaw_val = mode.random(get(antibrute[4].yaw_min_left),get(antibrute[4].yaw_max_left),get(antibrute[4].yaw_min_right),get(antibrute[4].yaw_max_right))
						end
						
						if get(antibrute[4].fake_mode) == "left - right" then
							command['antiaim'].fake_val = mode.sync(get(antibrute[4].fake_left),get(antibrute[4].fake_right))
						elseif get(antibrute[4].fake_mode) == "left - right [random]" then
							command['antiaim'].fake_val = mode.random(get(antibrute[4].fake_min_left),get(antibrute[4].fake_max_left),get(antibrute[4].fake_min_right),get(antibrute[4].fake_max_right))
						end
						command['antiaim'].yaw_jitter_val = mode.sync(get(antibrute[4].yaw_jitt_addl),get(antibrute[4].yaw_jitt_addr))
						command['antiaim'].body = get(antibrute[4].b_yaw)
				
						if get(antibrute[4].b_yaw) == "static" then
							command['antiaim'].body_val = invert > 0 and get(antibrute[4].fake_body) or get(antibrute[4].fake_body)
						else
							command['antiaim'].body_val = invert > 0 and -get(antibrute[4].fake_body) or get(antibrute[4].fake_body)
						end
					elseif command['brute'].phase == 5 or get(antibrute[5].brute_preview) then
						command['antiaim'].yaw = 180
						command['antiaim'].pitch = get(antibrute[5].pitch)
						command['antiaim'].yaw_jitter = get(antibrute[5].yaw_jitt)
						
						if get(antibrute[5].yaw_mode) == "left - right" then
							command['antiaim'].yaw_val = mode.sync(get(antibrute[5].yaw_left), get(antibrute[5].yaw_right))
						elseif get(antibrute[5].yaw_mode) == "left - right [random]" then
							command['antiaim'].yaw_val = mode.random(get(antibrute[5].yaw_min_left),get(antibrute[5].yaw_max_left),get(antibrute[5].yaw_min_right),get(antibrute[5].yaw_max_right))
						end
						
						if get(antibrute[5].fake_mode) == "left - right" then
							command['antiaim'].fake_val = mode.sync(get(antibrute[5].fake_left),get(antibrute[5].fake_right))
						elseif get(antibrute[5].fake_mode) == "left - right [random]" then
							command['antiaim'].fake_val = mode.random(get(antibrute[5].fake_min_left),get(antibrute[5].fake_max_left),get(antibrute[5].fake_min_right),get(antibrute[5].fake_max_right))
						end
						command['antiaim'].yaw_jitter_val = mode.sync(get(antibrute[5].yaw_jitt_addl),get(antibrute[5].yaw_jitt_addr))
						command['antiaim'].body = get(antibrute[5].b_yaw)
				
						if get(antibrute[5].b_yaw) == "static" then
							command['antiaim'].body_val = invert > 0 and get(antibrute[5].fake_body) or get(antibrute[5].fake_body)
						else
							command['antiaim'].body_val = invert > 0 and -get(antibrute[5].fake_body) or get(antibrute[5].fake_body)
						end
					end
					set(reference.antiaim.yawbase, "At targets")
				end
			end
			if not is_brute or command['brute'].phase == 0 then return end
		end,

		aa_builder = function(c)
			local v = command['manual']
			local is_fs = get(antiaim.fs) and not command['fsdisabled']
			local static_fs = contains(elements[vars.p_state].comboselect, "static freestanding") and is_fs
			local disable_on_fl = contains(elements[vars.p_state].comboselect, "disable jitter on fakelag") and not get(reference.rage.os[2]) and not get(reference.rage.dt[2])
			if not entity.is_alive(entity.get_local_player()) then return end
			local is_brute = get(antibrute[1].brute_preview) or get(antibrute[2].brute_preview) or get(antibrute[3].brute_preview) or get(antibrute[4].brute_preview) or get(antibrute[5].brute_preview)

			if v.back_dir == true and command['brute'].phase == 0 and not static_fs and not disable_on_fl and not is_brute and command['disabled'] == false	then
				if c.chokedcommands ~= 0 then
				else
					local invert = (math.floor(math.min(get(reference.antiaim.fakeyawlimit), (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * (get(reference.antiaim.fakeyawlimit) * 2) - get(reference.antiaim.fakeyawlimit))))) 
					vars.max_desync_amount = get_maximum_desync(entity.get_local_player())
					local debug_desync = vars.max_desync_amount / 1.2
					local max_jitter = debug_desync * 1.8

					if get(antiaim.aa_builder) then
						command['antiaim'].yaw = "180"
						command['antiaim'].pitch = get(elements[vars.p_state].pitch)
						command['antiaim'].yaw_jitter = get(elements[vars.p_state].yaw_jitt)
						command['antiaim'].fsbody = contains(elements[vars.p_state].comboselect, "adaptive body yaw")
						command['antiaim'].body = get(elements[vars.p_state].b_yaw)

						if get(elements[vars.p_state].yaw_mode) == "left - right" then
							command['antiaim'].yaw_val = mode.sync(get(elements[vars.p_state].yaw_left),get(elements[vars.p_state].yaw_right))
						elseif get(elements[vars.p_state].yaw_mode) == "left - right [random]" then
							command['antiaim'].yaw_val = mode.random(get(elements[vars.p_state].yaw_min_left), get(elements[vars.p_state].yaw_max_left),get(elements[vars.p_state].yaw_min_right), get(elements[vars.p_state].yaw_max_right))
						elseif get(elements[vars.p_state].yaw_mode) == "center" then
							command['antiaim'].yaw_val = get(elements[vars.p_state].yaw_center)
						elseif get(elements[vars.p_state].yaw_mode) == "calculate" then
							command['antiaim'].yaw_val = mode.calculate(get(elements[vars.p_state].yaw_calculate))
						end

						if get(elements[vars.p_state].fake_mode) == "left - right" then
							command['antiaim'].fake_val = mode.sync(get(elements[vars.p_state].fake_left), get(elements[vars.p_state].fake_right))
						elseif get(elements[vars.p_state].fake_mode) == "left - right [random]" then
							command['antiaim'].fake_val = mode.random(get(elements[vars.p_state].fake_min_left),get(elements[vars.p_state].fake_max_left),get(elements[vars.p_state].fake_min_right),get(elements[vars.p_state].fake_max_right))
						elseif get(elements[vars.p_state].fake_mode) == "sway" then
							command['antiaim'].fake_val = math.max(mode.sway(get(elements[vars.p_state].sway_fake_to), get(elements[vars.p_state].sway_fake_speed)), get(elements[vars.p_state].sway_fake_from)) * 1
							if get(elements[vars.p_state].sway_fake_to) <= get(elements[vars.p_state].sway_fake_from) then
								set(elements[vars.p_state].sway_fake_from, -1 + get(elements[vars.p_state].sway_fake_to))
							end
						elseif get(elements[vars.p_state].fake_mode) == "dynamic" then
							command['antiaim'].fake_val = debug_desync
						end

						if get(elements[vars.p_state].yaw_jitt_mode) == "left - right" then
							command['antiaim'].yaw_jitter_val = mode.sync(get(elements[vars.p_state].yaw_jitt_addl), get(elements[vars.p_state].yaw_jitt_addr))
						elseif get(elements[vars.p_state].yaw_jitt_mode) == "center" then
							command['antiaim'].yaw_jitter_val = get(elements[vars.p_state].yaw_jitt_center)
						elseif get(elements[vars.p_state].yaw_jitt_mode) == "sway" then
							command['antiaim'].yaw_jitter_val = math.max(mode.sway(get(elements[vars.p_state].yaw_jitt_sway_to), get(elements[vars.p_state].yaw_jitt_sway_speed)), get(elements[vars.p_state].yaw_jitt_sway_from)) * 1
							if get(elements[vars.p_state].yaw_jitt_sway_to) <= get(elements[vars.p_state].yaw_jitt_sway_from) then
								set(elements[vars.p_state].yaw_jitt_sway_from, -1 + get(elements[vars.p_state].yaw_jitt_sway_to))
							end
						elseif get(elements[vars.p_state].yaw_jitt_mode) == "dynamic" then
							command['antiaim'].yaw_jitter_val = client.random_float(max_jitter - 3, max_jitter)
						end
						
						if get(elements[vars.p_state].b_yaw) == "static" then
							command['antiaim'].body_val = invert > 0 and get(elements[vars.p_state].fake_body) or get(elements[vars.p_state].fake_body)
						else
							command['antiaim'].body_val = invert > 0 and -get(elements[vars.p_state].fake_body) or get(elements[vars.p_state].fake_body)
						end
					end
				end
			end
		end,

		apply_aa = function()
			local v = command['antiaim']

			set(reference.antiaim.pitch, v.pitch)
			set(reference.antiaim.yaw[1], v.yaw)
			set(reference.antiaim.yaw[2], v.yaw_val)
			set(reference.antiaim.yawbase, v.yaw_base)
			set(reference.antiaim.yaw_jitt[1], v.yaw_jitter)
			set(reference.antiaim.yaw_jitt[2], v.yaw_jitter_val)
			set(reference.antiaim.fsbodyyaw, v.fsbody)
			set(reference.antiaim.body_yaw[1], v.body)
			set(reference.antiaim.body_yaw[2], v.body_val)
			set(reference.antiaim.fakeyawlimit, v.fake_val)
		end,

		baimable = function()
			local enemies = entity.get_players(true)
			local c1,c2,c3 = get(vis.main_clr)
		
			for itter = 1, #enemies do
				local i = enemies[itter]
				
				if helpers.lethal_calc(i) then
					if contains(misc.force_baim, "lethal health") then
						plist.set(i,"Override prefer body aim", "Force")
					elseif contains(misc.prefer_baim, "lethal health") then
						plist.set(i,"Override prefer body aim", "On")
					else
						plist.set(i,"Override prefer body aim", "-")
					end
				elseif get(reference.rage.damage) < 8 then
					if contains(misc.force_baim, "low damage") then
						plist.set(i,"Override prefer body aim", "Force")
					elseif contains(misc.prefer_baim, "low damage") then
						plist.set(i,"Override prefer body aim", "On")
					else
						plist.set(i,"Override prefer body aim", "-")
					end
				elseif helpers.in_air(i) then
					if contains(misc.force_baim, "in air") then
						plist.set(i,"Override prefer body aim", "Force")
					elseif contains(misc.prefer_baim, "in air") then
						plist.set(i,"Override prefer body aim", "On")
					else
						plist.set(i,"Override prefer body aim", "-")
					end
				else
					plist.set(i,"Override prefer body aim", "-")
				end
			end
		end,
	}

	old_anim = function()
		local localplayer = entity.get_local_player( )
		if localplayer == nil then return end
		local is_sw = get(reference.rage.slow[1]) and get(reference.rage.slow[2])
		local bodyyaw = entity.get_prop(localplayer, "m_flPoseParameter", 11) * 120 - 60
		local side = bodyyaw > 0 and 1 or -1
		
		if contains(misc.animations, "Static legs") then 
			entity.set_prop(localplayer, "m_flPoseParameter", 1, 6) 
		end
	
		if contains(misc.animations, "0 pitch on land") then
			local on_ground = bit.band(entity.get_prop(localplayer, "m_fFlags"), 1)
	
			if on_ground == 1 then
				command['ground_ticks'] = command['ground_ticks'] + 1
			else
				command['ground_ticks'] = 0
				command['end_time'] = globals.curtime() + 1
			end 
		
			if command['ground_ticks'] > get(reference.fakelag.fl_limit)+1 and command['end_time'] > globals.curtime() then
				entity.set_prop(localplayer, "m_flPoseParameter", 0.5, 12)
			end
		end
		
		if contains(misc.animations, "Static slowwalk legs") and is_sw then
			entity.set_prop(localplayer, "m_flPoseParameter", 0.9 * side, 11)
			entity.set_prop(localplayer, "m_flPoseParameter", 0, 9)
		end
	
		if contains(misc.animations, "Legs slide") then
			set(reference.rage.lm, "always slide")
			entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
		end
	end

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
				['default_dt'] = {r = 0, g = 0, b = 0, a = 0},
                ['modern'] = {speed = 1, text_alpha = 0, text_alpha2 = 0, color = {r = 0 , g = 0 , b = 0 , a = 0}},
				['fake_anim'] = 0
            }
        },

        script_load = function()
            local v = visuals['stored']['script_load']
            v['alpha'] = animate.new(v['alpha'],1,0,not v['show'])
			local svg_300 = '<svg width="554.4" height="649.6" version="1.1" viewBox="0 0 554.4 649.6" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><path d="m273.53 531.63-1.2395-1-9.3067-28.8-4.6424-12-9.818-24-17.748-35.2-8.6508-14.4-15.06-22.4-13.001-16.784-19.226-19.216-13.574-10.574-11.2-7.2366-9.0585-4.8934-13.342-5.418-12.169-3.7597 20.169-13.528 9.6-7.622 9.7313-10.168 5.9613-8.9982 4.6761-11.49 1.8536-10.644-.44579-8.4502-.44578-8.4502-4.2296-17.567-5.4146-16.362-3.4264-8.6192-3.4264-8.6192-11.531-23.496-7.5372-13.304-4.8378-8-12.086-19.2-21.358-31.75.61216-.61215 17.504 13.176 11.2 8.674 24 20.062 23.2 20.715 16.8 15.328 26.449 26.408 9.6565 10.4 16.766 20 7.9794 11.2 2.9747 4.5356 2.9746 4.5356v1.1609l-8.4-7.896-12.975-9.8364-20.234-13.684-10.792-5.4178-12.287-4.9044-2.8566-.53589-2.8566-.53591v.93244l4.1268 9.2456 4.7217 12.8 1.1757 6.7048 1.1757 6.7048-.006 12.99-2.3936 14.758-4.6527 11.712-8.0522 13.994-6.7765 8.3356-8.7112 9.0411.89866 1.4541 14.094 8.5536 12.8 9.9316 12.087 11.02 15.664 17.105 8.6992 10.895 11.805 16.8 11.046 17.6 9.4292 16.8 6.1129 11.2 2.6527 5.2h13.131l10.79-19.6 14.435-24 7.9316-12 9.7475-13.6 14.579-17.6 15.89-16.128 13.6-10.775 18.4-12.278.42665-.1792-10.184-10.541-9.981-14.573-6.3921-13.64-2.0371-8.1431-2.0371-8.1431-.062-18.4 2.1096-8 2.1096-8 7.2467-17.467-.73833-.73832-7.6613 1.8785-11.368 4.6767-11.832 6.6356-8.8 5.7196-20.8 15.067-9.2 8.9784v-1.4415l11.966-17.817 21.136-25.491 40.099-39.849 18.279-16.151 22.521-19.81 25.818-20.99 9.3822-7.2772 10.8-7.6632v.76582l-27.647 41.375-8.2699 13.6-9.9886 17.6-6.2336 12-7.3055 16-4.6248 12-2.6501 8-2.6501 8-1.3152 4.4709-1.3152 4.4709-1.1951 7.9291-1.1951 7.9291-.005 5.9345-.005 5.9345 1.8287 10.531 5.3676 11.792 3.5177 4.9042 3.5177 4.9042 13.368 12.954 23.735 15.578-.40504.40505-.40504.40504-18.925 6.3179-14.174 7.2282-10.16 6.1725-12.466 9.3149-16.602 16.025-13.127 16-11.902 16-9.0454 14.4-11.38 20-15.733 32-3.6731 8.8-3.6731 8.8-5.4866 14.4-6.3764 19.2-3.4474 11.6h-2.8481l-1.2396-1zm-39.27-181.47-3.0032-.70782-7.7678-3.9362-13.046-12.273-9.6518-12.809.37408-.37406.37407-.37407 9.3241 2.0225 13.355 6.9654 9.2924 6.3104 4.9404 5.9936 1.3228 4.0254 1.3228 4.0253.36908 1 .36906 1-4.5712-.1608zm75.805-1.7315.52931-2.6.73607-2.8922.73608-2.8922 7.5964-7.1049 10.259-6.012 10.541-4.8537 8.6625-3.0491.27134.27135.27136.27134-12.746 16.847-8.8057 8.0479-7.4467 4.162-8.097 2.4046h-3.0367z" stroke-width=".8" fill="#ffffff"/></svg>'
			local svg = renderer.load_svg(svg_300, 300 , 300 )
			local text = gradient_text(115, 154, 255,255 * v['alpha'] + 0.5,128,128,240,255 * v['alpha'] + 0.5, "M O M E N T U M . C O D E S")
			local text_sizex, text_sizey = renderer.measure_text("+",text)

			renderer.blur(0, 0, x_offset * v['alpha'], y_offset * v['alpha'])
			renderer.rectangle(0, 0, x_offset, y_offset, 10, 10, 10, 150*v['alpha'])
			renderer.texture(svg, x - (312/2 + 7) * v['alpha'] + 15, y + (800/3 - 100) * v['alpha'] - 300, 300 * v['alpha'], 300 * v['alpha'], 128, 128, 240, math.floor(255 * v['alpha']), "f")
			renderer.text(x -text_sizex/2 + 4, y + 70 + (40 * v['alpha']),255,255,255,255* v['alpha'],"+",0,text)
			renderer.gradient(x -text_sizex/2 + 4, y + 100 + ( 40 *  v['alpha']) ,text_sizex * v['alpha'],3,115, 154, 255,255 ,128,128,240, math.floor(255 * v['alpha']),true)
			if v['start'] + 4 < globals.realtime() then
    			v['start'] = globals.realtime()
    			v['show'] = true
			end
        end,

        render_inds = function()
			if get(vis.indicators) == "-" then return end
            local v = visuals['stored']['crosshair']
            local text_size_x , text_size_y = renderer.measure_text(nil,"MOMENTUM BETA")
            local r,g,b = get(vis.main_clr)
			local r1,g1,b1 = get(vis.main_clr2)
			local simple_gradient = gradient_text(r,g,b,255 * v['alpha'], r1,g1,b1, 255 * v['alpha'],'MOMENTUM  BETA')

			local b_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 1.3
            v['alpha'] = animate.new(v['alpha'],1,0, get(vis.indicators))
            if v['alpha'] < 0.01 then return end
            local is_scoped = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_zoomLevel" ) == 1 or entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_zoomLevel" ) == 2
            local modifier = entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") ~= 1
            local c1,c2,c3,c4 = get(vis.default_colors)
			v['default_dt'] = animate.color_lerp(v['default_dt'], {r = c1 , g = c2, b = c3, a = c4}, {r = 255 , g = 102,b = 102,a = 0}, get(reference.rage.dt[1]) and helpers.doubletap_charged())

			if b_yaw then
				b_yaw = math.abs(helpers.map(b_yaw, 0, 1, -60, 60))
				b_yaw = math.max(0, math.min(57, b_yaw))
				body_yaw_solaris = b_yaw / 48
			end

			v['scoped'] = animate.new(v['scoped'],1,0,is_scoped)
			v['fake_anim'] = animate.new(v['fake_anim'],body_yaw_solaris, 0, get(vis.indicators) == "simple")
			
			if contains(vis.better_defaut, "dt") then
				renderer.indicator(v['default_dt'].r, v['default_dt'].g, v['default_dt'].b, v['default_dt'].a, "DT")
			end

			if contains(vis.better_defaut, "os") and get(reference.rage.os[1]) and get(reference.rage.os[2]) then
				renderer.indicator(c1, c2, c3, c4, "OS")
			end

			if contains(vis.better_defaut, "baim") and get(reference.rage.forcebaim) then
				renderer.indicator(c1, c2, c3, c4, "BAIM")
			end

			if contains(vis.better_defaut, "ping") and get(reference.rage.ping_spike[1]) and get(reference.rage.ping_spike[2]) then
				renderer.indicator(c1, c2, c3, c4, "PING")
			end

			if contains(vis.better_defaut, "safe point") and get(reference.rage.safepoint) then
				renderer.indicator(c1, c2, c3, c4, "SAFE")
			end

			if contains(vis.better_defaut, "freestand") and get(antiaim.fs) and not command['fsdisabled'] then
				renderer.indicator(c1, c2, c3, c4, "FS")
			end

			if get(antiaim.brute_enable) and contains(vis.better_defaut, "anti-bruteforce") then
				renderer.indicator(c1,c2,c3,c4, "AB "..command['brute'].phase)
			end

			if get(vis.indicators) == "simple" then

				local aA = {
					{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 60 / 30))},
					{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 55 / 30))},
					{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 50 / 30))},
					{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 45 / 30))},
					{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 40 / 30))},
					{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 35 / 30))},
					{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 30 / 30))},
					{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 25 / 30))}
				}

				local bB = {
					{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 20 / 30))},
					{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 15 / 30))},
					{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 10 / 30))},
					{r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 5 / 30))},
				}
				
				renderer.text(x - text_size_x/2 + 33 + math.floor(40 * v['scoped'])-3, y + 25, 0, 0, 0, 50, "-c", nil, "MOMENTUM")
				renderer.text(x - text_size_x/2 + 33 + math.floor(40 * v['scoped'])-3, y + 25, 255, 255, 255, 255, "-c", nil, string.format("\a%sM\a%sO\a%sM\a%sE\a%sN\a%sT\a%sU\a%sM", RGBAtoHEX(unpack(aA[1])), RGBAtoHEX(unpack(aA[2])), RGBAtoHEX(unpack(aA[3])), RGBAtoHEX(unpack(aA[4])), RGBAtoHEX(unpack(aA[5])), RGBAtoHEX(unpack(aA[6])), RGBAtoHEX(unpack(aA[7])), RGBAtoHEX(unpack(aA[8]))))
				renderer.text(x - text_size_x/2 + 66 + math.floor(40 * v['scoped'])-3, y + 25, 0, 0, 0, 50, "-c", nil, "BETA")
				renderer.text(x - text_size_x/2 + 66 + math.floor(40 * v['scoped'])-3, y + 25, 255, 255, 255, 255, "-c", nil, string.format("\a%sB\a%sE\a%sT\a%sA", RGBAtoHEX(unpack(bB[1])), RGBAtoHEX(unpack(bB[2])), RGBAtoHEX(unpack(bB[3])), RGBAtoHEX(unpack(bB[4]))))
				surface.draw_outlined_rect(x - text_size_x/2 + 13 + (40 * v['scoped'])-3, y + 30, 66, 5, 13, 13, 13, 255 * v['alpha'])
				surface.draw_filled_rect(x  - text_size_x/2 + 14 + math.floor(40 * v['scoped'])-3, y + 31, 65, 3, 13, 13, 13, 255 * v['alpha'])
				renderer.gradient(x - text_size_x/2 + 13 + math.floor(40 * v['scoped'])-2, y + 31, math.floor(54 * v['fake_anim']), 3, r, g, b, 255 * v['alpha'], 13, 13, 13, 255 * v['alpha'], true)
				renderer.text(x - text_size_x/2 + 44 + math.floor(40 * v['scoped'])-3, y + 39, 255, 255, 255, 255 * v['alpha'], "-c", nil, "+/- " .. string.upper(vars.ind_state)) 
			
				v['doubletap_color'] = animate.color_lerp(v['doubletap_color'], {r = r1 , g = g1, b = b1, a = 255}, {r = 255 , g = 0,b = 0,a = 255},
				get(reference.rage.dt[1]) and get(reference.rage.dt[2]) and helpers.doubletap_charged())
				local offset = 0
			
				local keys = {
			
					[1] = {
						['condition'] = get(reference.rage.forcebaim),
						['text'] = 'BAIM',
						['color'] = {r1,g1,b1,255 * v['alpha']}
					},
			
					[2] = {
						['condition'] = get(antiaim.fs) and not command['fsdisabled'],
						['text'] = 'FREESTAND',
						['color'] = {r1,g1,b1,255 * v['alpha']}
					},
			
					[3] = {
						['condition'] = get(reference.rage.safepoint),
						['text'] = 'SAFE',
						['color'] = {r1,g1,b1,255 * v['alpha']}
					},
			
					[4] = {
						['condition'] = get(reference.rage.os[1]) and get(reference.rage.os[2]),
						['text'] = 'HS',
						['color'] = {r1,g1,b1,255 * v['alpha']}
					},
					
					[5] = {
						['condition'] = get(reference.rage.quickpeek[1]) and get(reference.rage.quickpeek[2]),
						['text'] = 'PEEK',
						['color'] = {r1,g1,b1,255 * v['alpha']}
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
            else
				local r1,g1,b1 = get(vis.main_clr2)
                local main_gradient = gradient_text(r,g,b,255 * v['alpha'], r1,g1,b1, 255 * v['alpha'],'MOMENTUM.CODES')
                local text_sizex, text_sizey = renderer.measure_text('-','MOMENTUM.CODES')
                local vx, vy, vz = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
                local velocity = math.sqrt(vx ^ 2 + vy ^ 2)
				v['modern'].text_alpha = animate.new_notify(v['modern'].text_alpha,1,0,velocity > 30)
                v['modern'].text_alpha2 = animate.new_notify(v['modern'].text_alpha2,1,0,velocity < 30)
                v['modern'].speed = animate.new_notify(v['modern'].speed,velocity)

                renderer.text(x  + 2 + math.floor(34 * v['scoped']), y + 18, 255, 255, 255, 255 * v['alpha'], 'c-', 0, main_gradient)

                if v['modern'].speed > text_sizex + 3 then
                    v['modern'].speed = text_sizex + 3
				end
		
                v['modern'].color = animate.color_lerp(v['modern'].color, {r = (velocity > 60) and r or 255, g = (velocity > 60) and g or 161, b = (velocity > 60) and b or 0,a = 255},{r = 255 , g = 0,b = 0,a = 255})

                renderer.rectangle(x + math.floor(34 * v['scoped']) - text_sizex/2 + 5, y + 18 + 6,v['modern'].speed, 2,
                entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") ~= 1 and 255 or v['modern'].color.r,
                entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") ~= 1 and 0 or v['modern'].color.g,
                entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") ~= 1 and 0 or v['modern'].color.b, 255 * v['alpha']* v['modern'].text_alpha,5)

                for radius = 4, 12 do
                    local radius = radius / 2;
                    renderer.rectangle(x + math.floor(34 * v['scoped']) - text_sizex/2 - radius + 5, y + 18+ 6 - radius, v['modern'].speed  + radius *2, 2 + radius * 2,
                    entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") ~= 1 and 255 or v['modern'].color.r,
                    entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") ~= 1 and 0 or v['modern'].color.g,
                    entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") ~= 1 and 0 or v['modern'].color.b, (12 - radius * 2) * v['alpha']* v['modern'].text_alpha,8)   
                end

                renderer.text(x + math.floor(25 * v['scoped']) - text_sizex/2 + v['modern'].speed,y + 19,
                entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") ~= 1 and 255 or v['modern'].color.r,
                entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") ~= 1 and 0 or v['modern'].color.g,
                entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") ~= 1 and 0 or v['modern'].color.b,
                v['modern'].color.a * v['alpha'] * v['modern'].text_alpha,'-',0,entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") ~= 1  and 'SLOWED' or velocity < 170 and math.floor(velocity) or vars.ind_state)
                renderer.text(x + math.floor(12 * v['scoped']), y + 18 + math.floor(9 * v['modern'].text_alpha2), 180,44,44,255 * v['alpha'] * v['modern'].text_alpha2,'c-',0, "BETA")

                v['doubletap_color'] = animate.color_lerp(v['doubletap_color'], {r = r1, g = g1, b = b1, a = 255}, {r = 255 , g = 0,b = 0,a = 255}, get(reference.rage.dt[1]) and get(reference.rage.dt[2]) and helpers.doubletap_charged())
                local offset = 0
                
				local keys = {
					[1] = {
						['condition'] = get(antiaim.fs) and not command['fsdisabled'],
						['text'] = 'FS',
						['color'] = {r1,g1,b1,255 * v['alpha']}
					},
	   
					[2] = {
						['condition'] = get(reference.rage.forcebaim),
						['text'] = 'BA',
						['color'] = {r1,g1,b1,255 * v['alpha']}
					},

					[3] = {
						['condition'] = get(reference.rage.safepoint),
						['text'] = 'SP',
						['color'] = {r1,g1,b1,255 * v['alpha']}						
					},

					[4] = {
						['condition'] = get(reference.rage.quickpeek[1]) and get(reference.rage.quickpeek[2]),
						['text'] = 'QP',
						['color'] = {r1,g1,b1,255 * v['alpha']}
					},

					[5] = {
						['condition'] = get(reference.rage.os[1]) and get(reference.rage.os[2]),
						['text'] = 'HS',
						['color'] = {r1,g1,b1,255 * v['alpha']}
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
                    
                    local x , y = x + math.floor(35 * v['scoped']) -  text_sizex/2 + 6, y + 34

                    renderer.text(x + math.floor(offset * v['values'][k]), y, items['color'][1],items['color'][2],items['color'][3],items['color'][4] * v['values'][k], flags, text_width * v['values'][k] + 3, items['text'])
                    offset = offset + math.floor(13 * v['values'][k])
                end
            end
        end,

		watermark = function()
			command['switch'] = not command['switch']
			local name = 'momentum.codes'
			local count = online_counter
			local c1,c2,c3 = get(vis.wat_color)
			local hex = RGBtoHEX(c1,c2,c3)
			text = ("\a"..hex.."%s\aFFFFFFFF |\aFFFFFFFF %s | \aFFFFFFFF%s"):format(name, status.username, count)
			local h, w = 16, renderer.measure_text(nil, text) + 6
			local x, y = client.screen_size(), 10 
			local icon_w , icon_h = 18,18
			local svg = '<svg width="554.4" height="649.6" version="1.1" viewBox="0 0 554.4 649.6" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><path d="m273.53 531.63-1.2395-1-9.3067-28.8-4.6424-12-9.818-24-17.748-35.2-8.6508-14.4-15.06-22.4-13.001-16.784-19.226-19.216-13.574-10.574-11.2-7.2366-9.0585-4.8934-13.342-5.418-12.169-3.7597 20.169-13.528 9.6-7.622 9.7313-10.168 5.9613-8.9982 4.6761-11.49 1.8536-10.644-.44579-8.4502-.44578-8.4502-4.2296-17.567-5.4146-16.362-3.4264-8.6192-3.4264-8.6192-11.531-23.496-7.5372-13.304-4.8378-8-12.086-19.2-21.358-31.75.61216-.61215 17.504 13.176 11.2 8.674 24 20.062 23.2 20.715 16.8 15.328 26.449 26.408 9.6565 10.4 16.766 20 7.9794 11.2 2.9747 4.5356 2.9746 4.5356v1.1609l-8.4-7.896-12.975-9.8364-20.234-13.684-10.792-5.4178-12.287-4.9044-2.8566-.53589-2.8566-.53591v.93244l4.1268 9.2456 4.7217 12.8 1.1757 6.7048 1.1757 6.7048-.006 12.99-2.3936 14.758-4.6527 11.712-8.0522 13.994-6.7765 8.3356-8.7112 9.0411.89866 1.4541 14.094 8.5536 12.8 9.9316 12.087 11.02 15.664 17.105 8.6992 10.895 11.805 16.8 11.046 17.6 9.4292 16.8 6.1129 11.2 2.6527 5.2h13.131l10.79-19.6 14.435-24 7.9316-12 9.7475-13.6 14.579-17.6 15.89-16.128 13.6-10.775 18.4-12.278.42665-.1792-10.184-10.541-9.981-14.573-6.3921-13.64-2.0371-8.1431-2.0371-8.1431-.062-18.4 2.1096-8 2.1096-8 7.2467-17.467-.73833-.73832-7.6613 1.8785-11.368 4.6767-11.832 6.6356-8.8 5.7196-20.8 15.067-9.2 8.9784v-1.4415l11.966-17.817 21.136-25.491 40.099-39.849 18.279-16.151 22.521-19.81 25.818-20.99 9.3822-7.2772 10.8-7.6632v.76582l-27.647 41.375-8.2699 13.6-9.9886 17.6-6.2336 12-7.3055 16-4.6248 12-2.6501 8-2.6501 8-1.3152 4.4709-1.3152 4.4709-1.1951 7.9291-1.1951 7.9291-.005 5.9345-.005 5.9345 1.8287 10.531 5.3676 11.792 3.5177 4.9042 3.5177 4.9042 13.368 12.954 23.735 15.578-.40504.40505-.40504.40504-18.925 6.3179-14.174 7.2282-10.16 6.1725-12.466 9.3149-16.602 16.025-13.127 16-11.902 16-9.0454 14.4-11.38 20-15.733 32-3.6731 8.8-3.6731 8.8-5.4866 14.4-6.3764 19.2-3.4474 11.6h-2.8481l-1.2396-1zm-39.27-181.47-3.0032-.70782-7.7678-3.9362-13.046-12.273-9.6518-12.809.37408-.37406.37407-.37407 9.3241 2.0225 13.355 6.9654 9.2924 6.3104 4.9404 5.9936 1.3228 4.0254 1.3228 4.0253.36908 1 .36906 1-4.5712-.1608zm75.805-1.7315.52931-2.6.73607-2.8922.73608-2.8922 7.5964-7.1049 10.259-6.012 10.541-4.8537 8.6625-3.0491.27134.27135.27136.27134-12.746 16.847-8.8057 8.0479-7.4467 4.162-8.097 2.4046h-3.0367z" stroke-width=".8" fill="#ffffff"/></svg>'
			local icon = renderer.load_svg(svg,icon_w,icon_h)
			x = x - w - 10

			if get(vis.watermark_on) then
				renderer.blur(x-17,y,w+20,h,0,0,0,50)
				renderer.texture(icon, x-13, y-1,icon_w,icon_h,c1,c2,c3,255)
				renderer.texture(icon, x-13, y-1,icon_w,icon_h,c1,c2,c3,255)
				renderer.text(x+4, y+1, 255, 255, 255, 255, '', 0, text)
				for radius = 2, 8 do
					local radius = radius / 2;
					renderer.rectangle(x-15,y,-radius,h,c1,c2,c3,25)
				end
			end
		end,

        render_arrows = function()
			local x, y = client.screen_size()
			local localp = entity.get_local_player()
			local b_yaw = entity.get_prop(localp, "m_flPoseParameter", 11) * 120 - 60
			local m1,m2,m3,m4 = get(vis.manual_aa_color)
			local m_1,m_2,m_3, m_4 = get(vis.side_color)
			local offset = get(vis.arrows_offset)
			if localp == nil then return end
			local _weapon = entity.get_player_weapon(localp)
			if _weapon == nil then return end
			local _ent = native_GetClientEntity(_weapon)
			if _ent == nil then return end
			local _inaccuracy = native_GetInaccuracy(_ent)
			if _inaccuracy == nil then return end
			local v = command['manual']
			local m = visuals['stored']['arrows']

			if not entity.is_alive(localp) or get(vis.manaa_inds) == "-" then 
				return
			end

			if get(vis.manaa_inds) == "classic" then
				if v.right_dir == true then
					renderer.text(x/2 + offset - 3 +_inaccuracy*100 or offset, y/2 + 2, m1,m2,m3,255, "c+", 0, "»")
				elseif v.left_dir == true then
					renderer.text(x/2 - offset - 5 -_inaccuracy*100 or offset, y/2 + 2, m1,m2,m3,255, "c+", 0, "«")
				elseif b_yaw > 10 then
					renderer.text(x/2 - offset + 5 -_inaccuracy*80, y/2 + 2, m_1,m_2,m_3,255, "c+", 0, "‹")
				elseif b_yaw < -10 then
					renderer.text(x/2 + offset - 2 +_inaccuracy*80, y/2 + 2, m_1,m_2,m_3,255, "c+", 0, "›")
				end
			elseif get(vis.manaa_inds) == "team skeet" then 
				renderer.triangle(x / 2 + offset + 5, y / 2 + 2, x / 2 + offset - 8, y / 2 - 7, x / 2 + offset - 8, y / 2 + 11, 
				v.right_dir == true and m1 or 25, 
				v.right_dir == true and m2 or 25, 
				v.right_dir == true and m3 or 25, 
				v.right_dir == true and m4 or 160)
				renderer.triangle(x / 2 - offset - 5, y / 2 + 2, x / 2 - offset + 8, y / 2 - 7, x / 2 - offset + 8, y / 2 + 11, 
				v.left_dir == true and m1 or 25, 
				v.left_dir == true and m2 or 25, 
				v.left_dir == true and m3 or 25, 
				v.left_dir == true and m4 or 160)
				renderer.rectangle(x / 2 + offset - 12, y / 2 - 7, 2, 18, 
				b_yaw < -10 and m_1 or 25,
				b_yaw < -10 and m_2 or 25,
				b_yaw < -10 and m_3 or 25,
				b_yaw < -10 and m_4 or 255)
				renderer.rectangle(x / 2 - offset + 10, y / 2 - 7, 2, 18,			
				b_yaw > 10 and m_1 or 25,
				b_yaw > 10 and m_2 or 25,
				b_yaw > 10 and m_3 or 25,
				b_yaw > 10 and m_4 or 255)
			end
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

			if contains(misc.animations, "Leg breaker") and not helpers.in_air(localplayer) and timing > 1 then
				if vars.p_state == 2 or vars.p_state == 7 then
				set(reference.rage.lm, command['switch'] and lp_vel > 50 and "always slide" or "never slide")
				end
			end

			if not is_dt and not is_os and not m_flDuckAmount and not contains(misc.animations, "Leg breaker") then
				if vars.p_state == 1 then
					entity.set_prop(localplayer, "m_flPoseParameter", 50 and 50 * 0.01 or 0, 14)
				elseif vars.p_state == 3 then
					entity.set_prop(localplayer, "m_flPoseParameter", 5 and 50 * 0.01 or 0, 10)
				else
					entity.set_prop(localplayer, "m_flPoseParameter", 5 and 70 * 0.01 or 0, 8)
				end
			end
		end,

        stored_paint = function()
			visuals.watermark()

            if entity.get_local_player() == nil or  not entity.is_alive(entity.get_local_player()) then
                return
            end
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
			local add_main = get(antiaim.additions) == "builder"
			local add_keys = get(antiaim.additions) == "keybinds"
			local debug = get(antiaim.additions) == "debug"
			local brute = get(antiaim.additions) == "anti-bruteforce"
			local cfg = get(antiaim.additions) == "config"

			if aa_tab then
				visuals.menuToggle(false, menuSelectionRefs)
				ui.set_visible(back_butt, true)
			elseif vis_tab then
				visuals.menuToggle(false, menuSelectionRefs)
				ui.set_visible(back_butt, true)

			elseif misc_tab then
				visuals.menuToggle(false, menuSelectionRefs)
				ui.set_visible(back_butt, true)
			else 
				visuals.menuToggle(true, menuSelectionRefs)
				ui.set_visible(back_butt, false)
			end

			if add_main and aa_tab and not add_keys then
				ui.set_visible(antiaim.additions, true)
				ui.set_visible(antiaim.aa_builder, false)
			else
				ui.set_visible(antiaim.additions, false)
				ui.set_visible(antiaim.aa_builder, false)
			end

			if aa_tab and brute then
				ui.set_visible(antiaim.brute_enable, true)
			else
				ui.set_visible(antiaim.brute_enable, false)
			end

			if add_keys and aa_tab and not add_main then
				ui.set_visible(antiaim.manual_left, true)
				ui.set_visible(antiaim.manual_right, true)
				ui.set_visible(antiaim.manual_forward, true)
				ui.set_visible(antiaim.manual_reset, true)
				ui.set_visible(antiaim.fs, true)
				ui.set_visible(antiaim.edge_yaw, true)
			else
				ui.set_visible(antiaim.edge_yaw, false)
				ui.set_visible(antiaim.manual_left, false)
				ui.set_visible(antiaim.manual_right, false)
				ui.set_visible(antiaim.manual_forward, false)
				ui.set_visible(antiaim.manual_reset, false)
				ui.set_visible(antiaim.fs, false)
			end

			if aa_tab then
				ui.set_visible(antiaim.additions, true)
			else
				ui.set_visible(antiaim.additions, false)
			end

			if aa_tab and not cfg and not add_keys and not brute and not debug then
				ui.set_visible(aa_disabled, true)
			else
				ui.set_visible(aa_disabled, false)
			end

			if vis_tab then
				ui.set_visible(antiaim.additions, false)
				visuals.menuToggle(true, vis)

				if get(vis.indicators) ~= "-" then
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

				if get(vis.watermark_on) then
					ui.set_visible(vis.wat_color, true) 
				else
					ui.set_visible(vis.wat_color, false) 
				end

				if contains(vis.print_to, "screen") or contains(vis.print_to, "console") then
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
		
				if get(vis.manaa_inds) ~= "-" then
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
			else
				visuals.menuToggle(false, vis)
			end

			if misc_tab then		
				visuals.menuToggle(true, misc)
				if get(misc.anti_knife) then
					ui.set_visible(misc.knife_distance, true)
				else
					ui.set_visible(misc.knife_distance, false)
				end
			else
				visuals.menuToggle(false, misc)
			end

			if get(misc.enabled) == "custom speed" and misc_tab then
				ui.set_visible(misc.speed_limit, true)
			else
				ui.set_visible(misc.speed_limit, false)
			end
			if get(antiaim.aa_builder) and aa_tab and cfg then
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
				for i=1, 6 do
					ui.set_visible(antiaim.player_state, aa_tab and add_main)
					ui.set_visible(elements[i].pitch, aa_state == i and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_left, aa_state == i and get(elements[i].yaw_mode) ~= "left - right [random]" and get(elements[i].yaw_mode) ~= "center" and get(elements[i].yaw_mode) ~= "calculate" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_right, aa_state == i and get(elements[i].yaw_mode) ~= "left - right [random]" and get(elements[i].yaw_mode) ~= "center" and get(elements[i].yaw_mode) ~= "calculate" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_center, aa_state == i and get(elements[i].yaw_mode) ~= "left - right [random]" and get(elements[i].yaw_mode) ~= "left - right" and get(elements[i].yaw_mode) ~= "calculate" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_min_left, aa_state == i and get(elements[i].yaw_mode) ~= "left - right" and get(elements[i].yaw_mode) ~= "center" and get(elements[i].yaw_mode) ~= "calculate" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_max_left, aa_state == i and get(elements[i].yaw_mode) ~= "left - right" and get(elements[i].yaw_mode) ~= "center" and get(elements[i].yaw_mode) ~= "calculate" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_min_right, aa_state == i and get(elements[i].yaw_mode) ~= "left - right" and get(elements[i].yaw_mode) ~= "center" and get(elements[i].yaw_mode) ~= "calculate" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_max_right, aa_state == i and get(elements[i].yaw_mode) ~= "left - right" and get(elements[i].yaw_mode) ~= "center" and get(elements[i].yaw_mode) ~= "calculate" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_calculate, aa_state == i and get(elements[i].yaw_mode) ~= "left - right" and get(elements[i].yaw_mode) ~= "center" and get(elements[i].yaw_mode) ~= "left - right [random]" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_jitt, aa_state == i and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_jitt_mode, aa_state == i and get(elements[aa_state].yaw_jitt) ~= "off" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_jitt_center, aa_state == i and get(elements[aa_state].yaw_jitt) ~= "off" and get(elements[aa_state].yaw_jitt_mode) ~= "left - right" and get(elements[aa_state].yaw_jitt_mode) ~= "dynamic" and get(elements[aa_state].yaw_jitt_mode) ~= "sway" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_jitt_addl, aa_state == i and get(elements[aa_state].yaw_jitt) ~= "off" and get(elements[aa_state].yaw_jitt) ~= "offset" and get(elements[aa_state].yaw_jitt_mode) ~= "center" and get(elements[aa_state].yaw_jitt_mode) ~= "sway" and get(elements[aa_state].yaw_jitt_mode) ~= "dynamic" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_jitt_addr, aa_state == i and get(elements[aa_state].yaw_jitt) ~= "off" and get(elements[aa_state].yaw_jitt_mode) ~= "center" and get(elements[aa_state].yaw_jitt_mode) ~= "dynamic" and get(elements[aa_state].yaw_jitt_mode) ~= "sway" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_jitt_sway_from, aa_state == i and get(elements[aa_state].yaw_jitt) ~= "off" and get(elements[aa_state].yaw_jitt_mode) ~= "left - right" and get(elements[aa_state].yaw_jitt_mode) ~= "dynamic" and get(elements[aa_state].yaw_jitt_mode) ~= "center" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_jitt_sway_to, aa_state == i and get(elements[aa_state].yaw_jitt) ~= "off" and get(elements[aa_state].yaw_jitt_mode) ~= "left - right" and get(elements[aa_state].yaw_jitt_mode) ~= "dynamic" and get(elements[aa_state].yaw_jitt_mode) ~= "center" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_jitt_sway_speed, aa_state == i and get(elements[aa_state].yaw_jitt) ~= "off" and get(elements[aa_state].yaw_jitt_mode) ~= "left - right" and get(elements[aa_state].yaw_jitt_mode) ~= "dynamic" and get(elements[aa_state].yaw_jitt_mode) ~= "center" and aa_tab and add_main)
					ui.set_visible(elements[i].b_yaw, aa_state == i and aa_tab and add_main)
					ui.set_visible(elements[i].fake_mode, aa_state == i and get(elements[i].b_yaw) ~= "off" and aa_tab and add_main)
					ui.set_visible(elements[i].yaw_mode, aa_state == i and aa_tab and add_main)
					ui.set_visible(elements[i].fake_min_left, aa_state == i and get(elements[i].fake_mode) ~= "left - right" and get(elements[i].fake_mode) ~= "sway" and get(elements[i].fake_mode) ~= "dynamic" and aa_tab and add_main)
					ui.set_visible(elements[i].fake_max_left, aa_state == i and get(elements[i].fake_mode) ~= "left - right" and get(elements[i].fake_mode) ~= "sway" and get(elements[i].fake_mode) ~= "dynamic" and aa_tab and add_main)
					ui.set_visible(elements[i].fake_min_right, aa_state == i and get(elements[i].fake_mode) ~= "left - right" and get(elements[i].fake_mode) ~= "sway" and get(elements[i].fake_mode) ~= "dynamic" and aa_tab and add_main)
					ui.set_visible(elements[i].fake_max_right, aa_state == i and get(elements[i].fake_mode) ~= "left - right" and get(elements[i].fake_mode) ~= "sway" and get(elements[i].fake_mode) ~= "dynamic" and aa_tab and add_main)
					ui.set_visible(elements[i].comboselect, aa_state == i and get(elements[aa_state].comboselect) ~= "disable jitter on fakelag" and aa_tab and add_main)
					ui.set_visible(elements[i].comboselect, aa_state == i and get(elements[aa_state].comboselect) ~= "force defensive" and aa_tab and add_main)
					ui.set_visible(elements[i].comboselect, aa_state == i and get(elements[aa_state].comboselect) ~= "adaptive body yaw" and aa_tab and add_main)
					ui.set_visible(elements[i].fake_body, aa_state == i and get(elements[i].b_yaw) ~= "off" and get(elements[i].b_yaw) ~= "opposite" and aa_tab and add_main)
					ui.set_visible(elements[i].fake_left, aa_state == i and get(elements[i].fake_mode) ~= "left - right [random]" and get(elements[i].fake_mode) ~= "sway" and get(elements[i].b_yaw) ~= "off" and get(elements[i].fake_mode) ~= "dynamic" and aa_tab and add_main)
					ui.set_visible(elements[i].fake_right, aa_state == i and get(elements[i].fake_mode) ~= "left - right [random]" and get(elements[i].fake_mode) ~= "sway" and get(elements[i].b_yaw) ~= "off" and get(elements[i].fake_mode) ~= "dynamic" and aa_tab and add_main)
					ui.set_visible(elements[i].sway_fake_from, aa_state == i and get(elements[i].fake_mode) ~= "left - right" and get(elements[i].fake_mode) ~= "left - right [random]" and get(elements[i].b_yaw) ~= "off" and get(elements[i].fake_mode) ~= "dynamic" and aa_tab and add_main)
					ui.set_visible(elements[i].sway_fake_to, aa_state == i and get(elements[i].fake_mode) ~= "left - right" and get(elements[i].fake_mode) ~= "left - right [random]" and get(elements[i].b_yaw) ~= "off" and get(elements[i].fake_mode) ~= "dynamic" and aa_tab and add_main)
					ui.set_visible(elements[i].sway_fake_speed, aa_state == i and get(elements[i].fake_mode) ~= "left - right" and get(elements[i].fake_mode) ~= "left - right [random]" and get(elements[i].b_yaw) ~= "off" and get(elements[i].fake_mode) ~= "dynamic" and aa_tab and add_main)
				end
			end

			if get(antiaim.brute_enable) then
				local bf_state = vars.phase_nmb[get(antiaim.brute_phase)]
				for i=1, 5 do
					ui.set_visible(antiaim.brute_phase, aa_tab and brute)
					ui.set_visible(antibrute[i].pitch, bf_state == i and aa_tab and brute)
					ui.set_visible(antibrute[i].yaw_left,bf_state == i and get(antibrute[i].yaw_mode) ~= "left - right [random]" and aa_tab and brute)
					ui.set_visible(antibrute[i].yaw_right,bf_state == i and get(antibrute[i].yaw_mode) ~= "left - right [random]" and aa_tab and brute)
					ui.set_visible(antibrute[i].yaw_min_left, bf_state == i and get(antibrute[i].yaw_mode) ~= "left - right" and aa_tab and brute)
					ui.set_visible(antibrute[i].yaw_max_left, bf_state == i and get(antibrute[i].yaw_mode) ~= "left - right" and aa_tab and brute)
					ui.set_visible(antibrute[i].yaw_min_right, bf_state == i and get(antibrute[i].yaw_mode) ~= "left - right" and aa_tab and brute)
					ui.set_visible(antibrute[i].yaw_max_right, bf_state == i and get(antibrute[i].yaw_mode) ~= "left - right" and aa_tab and brute)
					ui.set_visible(antibrute[i].yaw_jitt,bf_state == i and aa_tab and brute)
					ui.set_visible(antibrute[i].yaw_jitt_addl,bf_state == i and get(antibrute[bf_state].yaw_jitt) ~= "off" and get(antibrute[bf_state].yaw_jitt) ~= "offset" and aa_tab and brute)
					ui.set_visible(antibrute[i].yaw_jitt_addr,bf_state == i and get(antibrute[bf_state].yaw_jitt) ~= "off" and aa_tab and brute)
					ui.set_visible(antibrute[i].b_yaw, bf_state == i and aa_tab and brute)
					ui.set_visible(antibrute[i].fake_mode, bf_state == i and get(antibrute[i].b_yaw) ~= "off" and aa_tab and brute)
					ui.set_visible(antibrute[i].yaw_mode, bf_state == i and aa_tab and brute)
					ui.set_visible(antibrute[i].fake_min_left, bf_state == i and get(antibrute[i].fake_mode) ~= "left - right"  and aa_tab and brute)
					ui.set_visible(antibrute[i].fake_max_left, bf_state == i and get(antibrute[i].fake_mode) ~= "left - right" and aa_tab and brute)
					ui.set_visible(antibrute[i].fake_min_right, bf_state == i and get(antibrute[i].fake_mode) ~= "left - right" and aa_tab and brute)
					ui.set_visible(antibrute[i].fake_max_right, bf_state == i and get(antibrute[i].fake_mode) ~= "left - right" and aa_tab and brute)
					ui.set_visible(antibrute[i].fake_body, bf_state == i and get(antibrute[i].b_yaw) ~= "off" and get(antibrute[i].b_yaw) ~= "opposite" and aa_tab and brute)
					ui.set_visible(antibrute[i].fake_left,bf_state == i and get(antibrute[i].fake_mode) ~= "left - right [random]" and get(antibrute[i].b_yaw) ~= "off" and aa_tab and brute)
					ui.set_visible(antibrute[i].fake_right,bf_state == i and get(antibrute[i].fake_mode) ~= "left - right [random]" and get(antibrute[i].b_yaw) ~= "off" and aa_tab and brute)
					ui.set_visible(antibrute[i].brute_preview, bf_state == i and aa_tab and brute)
					ui.set_visible(antibrute[i].preview_label, bf_state == i and get(antibrute[i].brute_preview) and aa_tab and brute)
				end
			else
				for i=1, 5 do
					ui.set_visible(antiaim.brute_phase, false)
					ui.set_visible(antibrute[i].pitch, false)
					ui.set_visible(antibrute[i].yaw_left, false)
					ui.set_visible(antibrute[i].yaw_right, false)
					ui.set_visible(antibrute[i].yaw_min_left, false)
					ui.set_visible(antibrute[i].yaw_max_left, false)
					ui.set_visible(antibrute[i].yaw_min_right, false)
					ui.set_visible(antibrute[i].yaw_max_right, false)
					ui.set_visible(antibrute[i].yaw_jitt, false)
					ui.set_visible(antibrute[i].yaw_jitt_addl, false)
					ui.set_visible(antibrute[i].yaw_jitt_addr, false)
					ui.set_visible(antibrute[i].b_yaw, false)
					ui.set_visible(antibrute[i].fake_mode, false)
					ui.set_visible(antibrute[i].yaw_mode, false)
					ui.set_visible(antibrute[i].fake_min_left, false)
					ui.set_visible(antibrute[i].fake_max_left, false)
					ui.set_visible(antibrute[i].fake_min_right, false)
					ui.set_visible(antibrute[i].fake_max_right, false)
					ui.set_visible(antibrute[i].fake_body, false)
					ui.set_visible(antibrute[i].fake_left, false)
					ui.set_visible(antibrute[i].fake_right, false)
					ui.set_visible(antibrute[i].brute_preview, false)
					ui.set_visible(antibrute[i].preview_label, false)
				end
			end
		end,

        stored_paint_ui = function()
			if get(antiaim.additions) == "debug" and aa_tab then
				skeet_menu(true)
			else
				skeet_menu(false)
			end
            visuals.script_load()
			visuals.lua_menu()
        end
    }

	local _misc = {}

	_misc = {
        ['value'] = {	
            ['trash_talk'] = {
				"dogs dont talk, they listen",
				"𝕤𝕝𝕒𝕪𝕚𝕟𝕘 𝕨𝕚𝕥𝕙 𝕞𝕠𝕞𝕖𝕟𝕥𝕦𝕞 (◣_◢)",
				"discord.gg/Vm3W83bFtG",
				"in yur country are au gays",
				"u smell like donkey shit bro",
				"𝖙𝖞4𝖈𝖑𝖎𝖕",
				"H & $",
				"cry d0g",
				"eat shit kid - owned by momentum",
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
				"momentum.codes © 2022",
				"i sold ur father for condoms so ur mom wouldn't get aids",
				"想象Gamesense获得更新 (◣_◢)",
				"继续使用俄罗斯糊",
				"hi",
				"您好像没有脑子的弱智",
				"有我孤帅哥一半厉害吗？废物",
				"i'd call you cancer, but at least cancer gets kills"
            },

			['first_tag'] = "",

			['states'] = {
				"________",
				"_______m",
				"______m_",
				"_____m__",
				"____m__o",
				"___m__o_",
				"__m__o__",
				"_m__o__m",
				"m__o__m_",
				"m_o__m__",
				"mo__m__e",
				"mo_m__e_",
				"mom__e__",
				"mom_e__n",
				"mome__n_",
				"mome_n__",
				"momen__t",
				"momen_t_",
				"moment__",
				"moment_u",
				"momentu_",
				"momentum",
				"momentum",
				"momentum",
				"momentu_",
				"moment_u",
				"moment__",
				"momen_t_",
				"momen__t",
				"mome_n__",
				"mome__n_",
				"mom_e__n",
				"mom__e__",
				"mo_m__e_",
				"mo__m__e",
				"m_o__m__",
				"m__o__m_",
				"_m__o__m",
				"__m__o__",
				"___m__o_",
				"____m__o",
				"_____m__",
				"______m_",
				"_______m",
				"________",
			},
        },

        trashtalk = function(e)
            if get(misc.tt) then
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

		clantag = {
			run = function()
				local state = get(misc.clantag)
				if state == false then
					if _misc['value']['first_tag'] ~= "" then
						client.set_clan_tag("")
		
						_misc['value']['first_tag'] = ""
					end
					return
				end

				local tag_int = math.floor(((globals.tickcount() * 0.045) % #_misc['value']['states']) + 1)
				local ct_padding = "\t\t  "
				local actual_tag = ct_padding .. _misc['value']['states'][tag_int] .. ct_padding
				local final_tag = ""
				if ui.get(misc.adaptive_clantag_luas) == "-" then
					final_tag = actual_tag
				else
					final_tag = ui.get(misc.adaptive_clantag_luas)
				end
				local resource = entity.get_player_resource()

				if resource ~= nil and entity.get_local_player() ~= nil then
					local kills = entity.get_prop(resource, "m_iKills", entity.get_local_player()) or 1
					local deaths = entity.get_prop(resource, "m_iDeaths", entity.get_local_player()) or 0
					kills = (kills == 0 and deaths == 0) and 1 or kills
					if (kills/deaths) >= 1.5 then
						final_tag = actual_tag
					end
				end

				if entity.get_local_player() ~= nil and entity.is_alive(entity.get_local_player()) then
					local m_iNumRoundKills = entity.get_prop(entity.get_local_player(), "m_iNumRoundKills") or 0

					if m_iNumRoundKills ~= nil and m_iNumRoundKills >= 5 then
						final_tag = actual_tag
					end
				end

				if final_tag ~= _misc['value']['first_tag'] then
					client.set_clan_tag(final_tag)
					_misc['value']['first_tag'] = final_tag
				end
			end,   

			shutdown = function()
				if _misc['value']['first_tag'] ~= "" then
					client.set_clan_tag("")
				end
			end,
		}
    }

	client.register_esp_flag("condition", 255, 255, 255, function(entity_index)
		if not contains(misc.force_baim) then return end
		if plist.get(entity_index, "Override prefer body aim") == "On" then condition = "PREFER" elseif plist.get(entity_index, "Override prefer body aim") == "Force" then condition = "FORCE" else condition = "" end
		return true, condition
	end)

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
			_misc.clantag:run()
			functions.globals.sync()
    		functions.globals.sync_icons()
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
			command.brute_impact(e)
        end,

        player_death = function(e)
			local v = command['brute']
			v.last_miss = 0
			v.phase = 0
			v.bf_reset = true
			_misc.trashtalk(e)
			if client.userid_to_entindex(e.userid) == entity.get_local_player() then
				if get(antiaim.brute_enable) then
					notify:paint(2, "restored anti-bruteforce due to death")
            
				end
			end
		end,

        round_start = function(e)
			local v = command['brute']
			v.last_miss = 0
			v.phase = 0
			v.bf_reset = true
			v['switch'] = false
			vars.last_press = 0
			if get(antiaim.brute_enable) then 
				notify:paint(2, "restored anti-bruteforce due to new round")
			end
        end,

        new_map = function(e)
			local v = command['brute']
			v.last_miss = 0
			v.phase = 0
			v.bf_reset = true
			v['switch'] = false
			vars.last_press = 0
			if get(antiaim.brute_enable) then 
				notify:paint(2, "restored anti-bruteforce due to new map")
			end
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
			_misc.clantag:shutdown()
			remove_shutdown()
        end,

        setup_command = function(c)
			command._states(c)
			command.fl_adaptive(c)
			command.anti_aim_on_use(c)
			command.warmup_aa()
			command.manualaa()
			command.freestand()
			command.anti_brute()
			command.brute_builder(c)
			command.aa_builder(c)
			command.baimable()
			command.anti_backstab()
			command.slow_mo(c)
			command.apply_aa()
        end,

        pre_render = function()
			old_anim()
        end,

		fully_joined = function()
			vars.last_press = 0
			command['switch'] = false
		end,

		end_round = function()
			local v = command['brute']
			local me = entity.get_local_player()
			if not entity.is_alive(me) then 
				v.last_miss = 0
				v.phase = 0
				v.bf_reset = true
			else
				v.last_miss = 0
				v.phase = 0
				v.bf_reset = true
			end
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
	add_online()
	sracka_funckia()
end
main()