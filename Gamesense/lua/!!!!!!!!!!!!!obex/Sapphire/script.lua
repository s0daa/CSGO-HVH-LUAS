-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local aa_tab = "AA"
local aa_angles = "Anti-aimbot angles"
local ent = require("gamesense/entity")
local surface = require("gamesense/surface")
local easing = require("gamesense/easing")
local anti_aim = require('gamesense/antiaim_funcs')
local clipboard = require("gamesense/clipboard")
local json =  require('json')
local vector = require("vector")
local base64 = require("gamesense/base64")

local function contains(b,c)for d,e in pairs(b)do if e==c then return true end end;return false end

--Cheat value
local aa_enable = ui.reference(aa_tab, aa_angles, "Enabled")
local pitch = {ui.reference(aa_tab, aa_angles, "Pitch")}
local yaw_base = ui.reference(aa_tab, aa_angles, 'Yaw base')
local yaw = {ui.reference(aa_tab, aa_angles, 'Yaw')}
local yaw_jitter = {ui.reference(aa_tab, aa_angles, 'Yaw jitter')}
local body_yaw = {ui.reference(aa_tab, aa_angles, "Body yaw")}
local fs_body_yaw =  ui.reference(aa_tab, aa_angles, "Freestanding body yaw")
local fake_lag_limit = ui.reference(aa_tab, 'Fake lag', 'Limit')
local slow_walk = {ui.reference('AA', 'Other', 'Slow motion')}
local quick_peek = {ui.reference('RAGE', 'Other', 'Quick peek assist')}
local onshot = {ui.reference('AA', 'Other', 'On shot anti-aim')}
local doubletap = {ui.reference("RAGE", "Aimbot", "Double tap")}
local freestand = ui.reference(aa_tab, aa_angles, "Freestanding")
local ping_spike = {ui.reference('MISC', 'Miscellaneous', 'Ping spike')}
local fake_duck = {ui.reference('RAGE', 'Other', 'Duck peek assist')}
local min_dmg = {ui.reference('RAGE', 'Aimbot', 'Minimum damage override')}
local min_hitchance = ui.reference('RAGE', 'Aimbot', 'Minimum hit chance')

--Switches
local sway_side = 0
local way_stage = 1
local way_delay = 0
local spin_delay = 1
local manual_left = false
local manual_right = false
local shot_made = false
local damage_taken = false

client.set_event_callback("aim_fire", function ()
	shot_made = true
end)

client.set_event_callback("player_hurt", function (e)
	if client.userid_to_entindex(e.userid) == entity.get_local_player() then
		damage_taken = true
	end
end)


function dump_tbl(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump_tbl(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local function ui_visible(ui_section, state) 
	for name, item in pairs(ui_section) do
		if type(item) == "table" then
			ui.set_visible(item[1], state)
		else
			ui.set_visible(item, state)
		end
	end
end

local function show_aa_settings(aa_item)
	for _, value in pairs(aa_item["settings"]) do
		for layermode, mode in pairs(value["modes"]) do
			if mode == ui.get(aa_item["mode"]) then
				ui.set_visible(value["item"], true)
				break
			else
				if layermode == ui.get(aa_item["mode"]) then
					local show_element = false
					for prefix, params in pairs(value["modes"][layermode]) do
						local item_value = ui.get(aa_item["settings"][prefix]["item"])
						for _, param in ipairs(params) do
							if type(item_value) == "table" and contains(item_value, param) then
								show_element = true
								break
							else
								if param == item_value then
									show_element = true
									break
								else
									show_element = false
								end
							end
						end
						if not show_element then break end
					end
					ui.set_visible(value["item"], show_element)
				else
					ui.set_visible(value["item"], false)
				end
			end
		end
	end
end

local function hide_aa_ui(aa_ui)
	for _, value in pairs(aa_ui) do
		ui.set_visible(value["prefix"], false)
		ui.set_visible(value["mode"], false)
		for _, item in pairs(value["settings"]) do
			ui.set_visible(item["item"], false)
		end
	end
end

local function show_aa_ui(aa_ui)
	for _, value in pairs(aa_ui) do
		ui.set_visible(value["prefix"], true)
		ui.set_visible(value["mode"], true)
		show_aa_settings(value)
	end
end

local function default_aa_ui(state)
	--Hiding values
	ui.set_visible(pitch[1], state)
	ui.set_visible(pitch[2], state)
	ui.set_visible(yaw_base, state)
	ui.set_visible(yaw[1], state)
	ui.set_visible(yaw[2], state)
	ui.set_visible(yaw_jitter[1], state)
	ui.set_visible(yaw_jitter[2], state)
	ui.set_visible(body_yaw[1], state)
	ui.set_visible(body_yaw[2], state)
	ui.set_visible(ui.reference(aa_tab, aa_angles, "Roll"), state)
	ui.set_visible(ui.reference(aa_tab, aa_angles, "Edge yaw"), state)
	ui.set_visible(freestand, state)
	ui.set_visible(ui.reference(aa_tab, aa_angles, "Freestanding body yaw"), state)
end

client.set_event_callback("paint_ui", function(e)
	default_aa_ui(false)
end)

client.set_event_callback("shutdown", function(cmd)
	default_aa_ui(true)
end)

local function generate_aa_ui(prefix)
	local aa_ui = {}

	--Pitch UI
	local pitch_name = "\a87CEFAFFPitch"
	local pitch_prefix = prefix .. " [" .. pitch_name .. "\aFFFFFFFF] "
	aa_ui["pitch"] = {
		["prefix"] = ui.new_label(aa_tab, aa_angles, "_________________________________"),
		["mode"] = ui.new_combobox(aa_tab, aa_angles, pitch_prefix .. "Mode", {"Off", "Up", "Down", "Random", "Custom"}),
		["settings"] = {
			["value"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, pitch_prefix .. "Value", -89, 89, 0, true, "°"),
				["modes"] = {"Custom"}
			}
		}
	}
	show_aa_settings(aa_ui["pitch"])
	ui.set_callback(aa_ui["pitch"]["mode"], function()
		show_aa_settings(aa_ui["pitch"])
	end)

	
	--Yaw Modifiers UI
	local ym_name = "\a87CEFAFFYaw Modifiers"
	local ym_prefix = prefix .. " [" .. ym_name .. "\aFFFFFFFF] "
	aa_ui["yaw_modifiers"] = {
		["prefix"] = ui.new_label(aa_tab, aa_angles, "_________________________________"),
		["mode"] = ui.new_combobox(aa_tab, aa_angles, ym_prefix .. "Mode", {"Off", "Static", "X-Way", "Sway", "Spin"}),
		["settings"] = {
			["way_mode"] = {
				["item"] = ui.new_combobox(aa_tab, aa_angles, ym_prefix .. "Way Mode", {"2-Way", "3-Way", "4-Way", "5-Way"}),
				["modes"] = {"X-Way"}
			},
			["way_settings"] = {
				["item"] = ui.new_multiselect(aa_tab, aa_angles, ym_prefix .. "Way settings", {"Delays", "Variance"}),
				["modes"] = {"X-Way"}
			},
			["first_stage"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Way / 1 - stage", -180, 180, 0, true, "°"),
				["modes"] = {["X-Way"] = {["way_mode"] = {"2-Way", "3-Way", "4-Way", "5-Way"}}}
			},
			["first_stage_delay"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Way / 1 - stage / Delay", 1, 15, 2, true, "t"),
				["modes"] = {["X-Way"] = {["way_mode"] = {"2-Way", "3-Way", "4-Way", "5-Way"}, ["way_settings"] = {"Delays"}}}
			},
			["second_stage"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Way / 2 - stage", -180, 180, 0, true, "°"),
				["modes"] = {["X-Way"] = {["way_mode"] = {"2-Way", "3-Way", "4-Way", "5-Way"}}}
			},
			["second_stage_delay"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Way / 2 - stage / Delay", 1, 15, 2, true, "t"),
				["modes"] = {["X-Way"] = {["way_mode"] = {"2-Way", "3-Way", "4-Way", "5-Way"}, ["way_settings"] = {"Delays"}}}
			},
			["third_stage"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Way / 3 - stage", -180, 180, 0, true, "°"),
				["modes"] = {["X-Way"] = {["way_mode"] = {"3-Way", "4-Way", "5-Way"}}}
			},
			["third_stage_delay"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Way / 3 - stage / Delay", 1, 15, 2, true, "t"),
				["modes"] = {["X-Way"] = {["way_mode"] = {"3-Way", "4-Way", "5-Way"}, ["way_settings"] = {"Delays"}}}
			},
			["fourth_stage"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Way / 4 - stage", -180, 180, 0, true, "°"),
				["modes"] = {["X-Way"] = {["way_mode"] = {"4-Way", "5-Way"}}}
			},
			["fourth_stage_delay"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Way / 4 - stage / Delay", 1, 15, 2, true, "t"),
				["modes"] = {["X-Way"] = {["way_mode"] = {"4-Way", "5-Way"}, ["way_settings"] = {"Delays"}}}
			},
			["fifth_stage"] = {	
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Way / 5 - stage", -180, 180, 0, true, "°"),
				["modes"] = {["X-Way"] = {["way_mode"] = {"5-Way"}}}
			},
			["fifth_stage_delay"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Way / 5 - stage / Delay", 1, 15, 2, true, "t"),
				["modes"] = {["X-Way"] = {["way_mode"] = {"5-Way"}, ["way_settings"] = {"Delays"}}}
			},
			["variance"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Way Variance", 0, 100, 0, true, "%"),
				["modes"] = {["X-Way"] = {["way_settings"] = {"Variance"}}}
			},
			["sway_mode"] = {
				["item"] = ui.new_combobox(aa_tab, aa_angles, ym_prefix .. "Sway Mode", {"One Sided", "Two Sided"}),
				["modes"] = {"Sway"}
			},
			["sway_range"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Sway Range", 0, 180, 0, true),
				["modes"] = {"Sway"}
			},
			["sway_speed"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Sway Speed", 0, 180, 0, true, "°"),
				["modes"] = {"Sway"}
			},
			["spin_speed"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Spin Speed", -180, 180, 0, true, "°"),
				["modes"] = {"Spin"}
			},
			["spin_delay"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Spin Delay", 1, 30, true, "t"),
				["modes"] = {"Spin"}
			},
			["value"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ym_prefix .. "Value", -180, 180, 0, true, "°"),
				["modes"] = {"Static"}
			},
			
		}
	}
	show_aa_settings(aa_ui["yaw_modifiers"])
	ui.set_callback(aa_ui["yaw_modifiers"]["mode"], function()
		show_aa_settings(aa_ui["yaw_modifiers"])
	end)
	ui.set_callback(aa_ui["yaw_modifiers"]["settings"]["way_mode"]["item"], function()
		show_aa_settings(aa_ui["yaw_modifiers"])
	end)
	ui.set_callback(aa_ui["yaw_modifiers"]["settings"]["way_settings"]["item"], function()
		show_aa_settings(aa_ui["yaw_modifiers"])
	end)
	--end

	-- Yaw Jitter UI
	local yj_name = "\a87CEFAFFYaw Jitter"
	local yj_prefix = prefix .. " [" .. yj_name .. "\aFFFFFFFF] "
	aa_ui["yaw_jitter"] = {
		["prefix"] = ui.new_label(aa_tab, aa_angles, "_________________________________"),
		["mode"] = ui.new_combobox(aa_tab, aa_angles, yj_prefix .. "Mode", {"Off", "Center", "Offset", "Random"}),
		["settings"] = {
			["value"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, yj_prefix .. "Value", -1800, 1800, 0, true, "°", 0.1),
				["modes"] = {"Center", "Offset", "Random"}
			}
		}
	}
	show_aa_settings(aa_ui["yaw_jitter"])
	ui.set_callback(aa_ui["yaw_jitter"]["mode"], function()
		show_aa_settings(aa_ui["yaw_jitter"])
	end)
	--end

	--Desync
	local ds_name = "\a87CEFAFFDesync"
	local ds_prefix = prefix .. " [" .. ds_name .. "\aFFFFFFFF] "
	aa_ui["desync"] = {
		["prefix"] = ui.new_label(aa_tab, aa_angles, "_________________________________"),
		["mode"] = ui.new_combobox(aa_tab, aa_angles, ds_prefix .. "Mode", {"Off", "Left", "Right", "Jitter"}),
		["settings"] = {
			["left_limit"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ds_prefix .. "L / Limit", 0, 100, 0, true, "%"),
				["modes"] = {"Left", "Jitter"}
			},
			["right_limit"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, ds_prefix .. "R / Limit", 0, 100, 0, true, "%"),
				["modes"] = {"Right", "Jitter"}
			}
		}
	}
	show_aa_settings(aa_ui["desync"])
	ui.set_callback(aa_ui["desync"]["mode"], function()
		show_aa_settings(aa_ui["desync"])
	end)
	--end

	--Defensive
	local def_name = "\a87CEFAFFDefensive"
	local def_prefix = prefix .. " [" .. def_name .. "\aFFFFFFFF] "
	aa_ui["defensive"] = {
		["prefix"] = ui.new_label(aa_tab, aa_angles, "_________________________________"),
		["mode"] = ui.new_combobox(aa_tab, aa_angles, def_prefix .. "Mode", {"Off", "Always"}),
		["settings"] = {
			["pitch"] = {
				["item"] = ui.new_combobox(aa_tab, aa_angles, def_prefix .. "Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
				["modes"] = {"Always"}
			}
		}
	}
	show_aa_settings(aa_ui["defensive"])
	ui.set_callback(aa_ui["defensive"]["mode"], function()
		show_aa_settings(aa_ui["defensive"])
	end)
	--end

	
	--Roll UI
	local rl_name = "\a87CEFAFFRoll"
	local rl_prefix = prefix .. " [" .. rl_name .. "\aFFFFFFFF] "
	aa_ui["roll"] = {
		["prefix"] = ui.new_label(aa_tab, aa_angles, "_________________________________"),
		["mode"] = ui.new_combobox(aa_tab, aa_angles, rl_prefix .. "Mode", {"Off", "Static"}),
		["settings"] = {
			["value"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, rl_prefix .. "Amount", -50, 50, 0, true, "°"),
				["modes"] = {"Static"}
			},
			["tickbase"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, rl_prefix .. "Tickbase", 1, 15, 0, true, "°"),
				["modes"] = {"Static"}
			}
		}
	}
	show_aa_settings(aa_ui["roll"])
	ui.set_callback(aa_ui["roll"]["mode"], function()
		show_aa_settings(aa_ui["roll"])
	end)
	--end

	hide_aa_ui(aa_ui)

	return aa_ui
end

local function center_text(text, text_clear)
	local result = ""
	local spaces = 56 - string.len(text_clear)
	for i = 0, spaces / 2 do
		result = result .. " "
	end
	result = result .. text
	for i = 0, spaces / 2 do
		result = result .. " "
	end
	return result
end

--UI
local menu_titles = {
	ui.new_label(aa_tab, aa_angles, center_text("\a87CEFAFFSapphire \aFFFFFFFFLUA", "Sapphire LUA")),
	ui.new_label(aa_tab, aa_angles, center_text("\a87CEFAFFBuild\aFFFFFFFF: \aB22222FFPrivate \aFFFFFFFF/ 3.10", "Build: Private / 3.10")),
	ui.new_label(aa_tab, aa_angles, center_text("Stay \a00FF00FFGame\a32CD32FFSense", "Stay GameSense")),
}

local buttons = {
	["ragebot"] = {
		["button"] = ui.new_button(aa_tab, aa_angles, "Ragebot", function () end),
		["elements"] = {
			["baim_on_lethal"] = {
				["item"] = ui.new_checkbox(aa_tab, aa_angles, "Force Baim On Lethal"),
			},
			["extended_backtrack"] = {
				["item"] = ui.new_checkbox(aa_tab, aa_angles, "Extended Backtrack"),
			}
		}
	},
	["anti_aim"] = {
		["button"] = ui.new_button(aa_tab, aa_angles, "Anti-Aim", function () end),
		["elements"] = {
			["condition"] = {
				["item"] = ui.new_combobox(aa_tab, aa_angles, "AA Condition", {"None", "Fakelag", "Stand", "Move", "Air", "Air Duck","Crouch", "Slow Walk"})
			}
		}
	},
	["visuals"] = {
		["button"] = ui.new_button(aa_tab, aa_angles, "Visuals", function () end),
		["elements"] = {
			["indicators"] = {
				["item"] = ui.new_checkbox(aa_tab, aa_angles, "Crosshair Indicators")
			},
			["indicators_color"] = {
				["item"] = ui.new_color_picker(aa_tab, aa_angles, "Color", 30, 144, 255, 255)
			},
			["arrows"] = {
				["item"] = ui.new_checkbox(aa_tab, aa_angles, "Desync Arrows")
			},
			["arrows_color"] = {
				["item"] = ui.new_color_picker(aa_tab, aa_angles, "Color", 30, 144, 255, 255)
			}
		}
	},
	["binds"] = {
		["button"] = ui.new_button(aa_tab, aa_angles, "Binds", function () end),
		["elements"] = {
			["freestand"] = {
				["item"] = ui.new_hotkey(aa_tab, aa_angles, ">>> Freestand")
			}
		}
	},
	["misc"] = {
		["button"] = ui.new_button(aa_tab, aa_angles, "Misc", function () end),
		["elements"] = {		
			["clantag"] = {
				["item"] = ui.new_checkbox(aa_tab, aa_angles, "Animated Clantag")
			},
			["disable_jitter"] = {
				["item"] = ui.new_checkbox(aa_tab, aa_angles, "Disable jitter on autopeek")
			},
			["on_use_aa"] = {
				["item"] = ui.new_combobox(aa_tab, aa_angles, "On Use AA", {"Static", "3-Way"})
			},
			["antibackstap"] = {
				["item"] = ui.new_checkbox(aa_tab, aa_angles, "Anti-Backstap"),
				["linked"] = true
			},
			["antibackstap_distance"] = {
				["item"] = ui.new_slider(aa_tab, aa_angles, "\nab_distance", 100, 500, 300, true, "u"),
				["link"] = {
					["antibackstap"] = true
				}
			},
			["leg_breaker"] = {
				["item"] = ui.new_combobox(aa_tab, aa_angles, "Leg Breaker", {"None", "Static", "Walking"})
			}
		}
	}
}

local fl_aa_ui = generate_aa_ui("|\a98FB98FFFL\aFFFFFFFF|")
local stand_aa_ui = generate_aa_ui("|\a98FB98FFS\aFFFFFFFF|")
local crouch_aa_ui = generate_aa_ui("|\a98FB98FFC\aFFFFFFFF|")
local move_aa_ui = generate_aa_ui("|\a98FB98FFM\aFFFFFFFF|")
local air_aa_ui = generate_aa_ui("|\a98FB98FFA\aFFFFFFFF|")
local air_duck_aa_ui = generate_aa_ui("|\a98FB98FFAD\aFFFFFFFF|")
local sw_aa_ui = generate_aa_ui("|\a98FB98FFSW\aFFFFFFFF|")

local function hide_all_aa_ui()
	hide_aa_ui(fl_aa_ui)
	hide_aa_ui(stand_aa_ui)
	hide_aa_ui(crouch_aa_ui)
	hide_aa_ui(move_aa_ui)
	hide_aa_ui(air_aa_ui)
	hide_aa_ui(air_duck_aa_ui)
	hide_aa_ui(sw_aa_ui)
end

local back_button = ui.new_button(aa_tab, aa_angles, "Back", function () end)
ui.set_visible(back_button, false)

local function buttons_visibility(buttons, state)
	for name, value in pairs(buttons) do
		ui.set_visible(value["button"], state)
	end
end

local function button_elements_visibility(button, state)
	for _, value in pairs(button["elements"]) do
		if value.link then
			for link, val in pairs(value["link"]) do
				if ui.get(button["elements"][link]["item"]) == val then
					ui.set_visible(value["item"], state)
				else
					ui.set_visible(value["item"], false)
				end
			end
		else
			ui.set_visible(value["item"], state)
		end
	end
end

local function main_menu_visibility(state)
	if state then
		buttons_visibility(buttons, true)
		ui.set_visible(back_button, false)
		for _, element in pairs(menu_titles) do
			ui.set_visible(element, true)
		end
	else
		buttons_visibility(buttons, false)
		ui.set_visible(back_button, true)
		for _, element in pairs(menu_titles) do
			ui.set_visible(element, false)
		end
	end
end

local function buttons_init(buttons)
	for _, button in pairs(buttons) do
		--Creating callbacks for linked elements
		for _, element in pairs(button["elements"]) do
			if element.linked then
				ui.set_callback(element["item"], function ()
					for _, element2 in pairs(button["elements"]) do
						if element2.link then
							for link, link_val in pairs(element2["link"]) do
								if ui.get(button["elements"][link]["item"]) == link_val then
									ui.set_visible(element2["item"], true)
								else
									ui.set_visible(element2["item"], false)
								end
							end
						end
					end
				end)
			end
		end
		--Setting callback for current button
		button_elements_visibility(button, false)
		ui.set_callback(button["button"], function ()
			main_menu_visibility(false)
			button_elements_visibility(button, true)
		end)
	end
	ui.set_callback(back_button, function ()
		for _, button in pairs(buttons) do
			button_elements_visibility(button, false)
		end
		hide_all_aa_ui()
		ui.set(buttons["anti_aim"]["elements"]["condition"]["item"], "None")
		main_menu_visibility(true)
	end)
end

local function form_items_list(button)
	local items = {}
	for element, item in pairs(button["elements"]) do
		items[element] = item["item"]
	end
	return items
end

buttons_init(buttons)

--Export Functions
local function export_buttons(buttons)
	local result = {}
	for button, data in pairs(buttons) do
		result[button] = {}
		for name, element in pairs(data["elements"]) do
			result[button][name] = ui.get(element["item"])
		end
	end
	return result
end
local function export_aa_ui(aa_ui)
	local result = {}
	for name, data in pairs(aa_ui) do
		result[name] = {}
		result[name]["mode"] = ui.get(data["mode"])
		result[name]["settings"] = {}
		for setting, value in pairs(data["settings"]) do
			result[name]["settings"][setting] = ui.get(value["item"])
		end
	end
	return result
end

--Import Functions
local function import_buttons(config, buttons)
	for button, data in pairs(config) do
		for element, value in pairs(data) do
			pcall(function()
				ui.set(buttons[button]["elements"][element]["item"], value)
			end)
		end
	end
end
local function import_aa_ui(config, aa_ui)
	for name, data in pairs(config) do
		pcall(function()
			ui.set(aa_ui[name]["mode"], data["mode"])
			for setting, value in pairs(data["settings"]) do
				pcall(function()
					ui.set(aa_ui[name]["settings"][setting]["item"], value)
				end)
			end
		end)
	end
end

--Export Functions
local import_config = ui.new_button(aa_tab, "Fake lag", "Import from clipboard", function () 
	local import_result = pcall(function()
		local cfg = json.parse(base64.decode(clipboard.get()))
		import_buttons(cfg["buttons"], buttons)
		import_aa_ui(cfg["fl_aa"], fl_aa_ui)
		import_aa_ui(cfg["stand_aa"], stand_aa_ui)
		import_aa_ui(cfg["crouch_aa"], crouch_aa_ui)
		import_aa_ui(cfg["move_aa"], move_aa_ui)
		import_aa_ui(cfg["air_aa"], air_aa_ui)
		import_aa_ui(cfg["air_duck_aa"], air_duck_aa_ui)
		import_aa_ui(cfg["sw_aa"], sw_aa_ui)
		hide_all_aa_ui()
		buttons_init(buttons)
		main_menu_visibility(true)
	end)
	if import_result then
		print("Config imported")
	else
		print("Failed to import config")
	end
	
end)
local export_config = ui.new_button(aa_tab, "Fake lag", "Export to clipboard", function ()
	local cfg = {}
	cfg["buttons"] = export_buttons(buttons)
	cfg["fl_aa"] = export_aa_ui(fl_aa_ui)
	cfg["stand_aa"] = export_aa_ui(stand_aa_ui)
	cfg["crouch_aa"] = export_aa_ui(crouch_aa_ui)
	cfg["move_aa"] = export_aa_ui(move_aa_ui)
	cfg["air_aa"] = export_aa_ui(air_aa_ui)
	cfg["air_duck_aa"] = export_aa_ui(air_duck_aa_ui)
	cfg["sw_aa"] = export_aa_ui(sw_aa_ui)
	clipboard.set(base64.encode(json.stringify(cfg)))
end)


--Defining button items
local ragebot_ui = form_items_list(buttons["ragebot"])
local visuals_ui = form_items_list(buttons["visuals"])
local binds_ui = form_items_list(buttons["binds"])
local misc_ui = form_items_list(buttons["misc"])

--Fixing elements suddenly show when loading config
client.set_event_callback("post_config_load", function()
	hide_all_aa_ui()
	buttons_init(buttons)
end)

--AntiAim callback
ui.set_callback(buttons["anti_aim"]["elements"]["condition"]["item"], function(e)
	hide_all_aa_ui()
	local condition = ui.get(e)
	if condition == "Fakelag" then
		show_aa_ui(fl_aa_ui)
	end
	if condition == "Stand" then
		show_aa_ui(stand_aa_ui)
	end
	if condition == "Move" then
		show_aa_ui(move_aa_ui)
	end
	if condition == "Air" then
		show_aa_ui(air_aa_ui)
	end
	if condition == "Air Duck" then
		show_aa_ui(air_duck_aa_ui)
	end
	if condition == "Crouch" then
		show_aa_ui(crouch_aa_ui)
	end
	if condition == "Slow Walk" then
		show_aa_ui(sw_aa_ui)
	end
end)

--Clantag FIX
ui.set_callback(misc_ui["clantag"], function(self)
	if ui.get(self) == false then
		client.set_clan_tag("")
	end
end)

--Leg Breaker
client.set_event_callback("pre_render", function()
	if not entity.is_alive(entity.get_local_player()) then
		return
	end	
	local lb = ui.get(misc_ui["leg_breaker"])
	if lb ~= "None" then
		local me = ent.get_local_player()
		local m_fFlags = me:get_prop("m_fFlags")
		local is_onground = bit.band(m_fFlags, 1) ~= 0
		if not is_onground then
			if lb == "Static" then
				me:get_anim_overlay(4).weight = 0
			end
			if lb == "Walking" then
				me:get_anim_overlay(6).weight = 1
			end
		end
	end
end)

--Indicators
local width, height = client.screen_size()
local hw = width / 2
local hh = height / 2
local indicators_color = {30, 144, 255, 255}
local arrows_color = {30, 144, 255, 255}

ui.set_callback(visuals_ui["indicators_color"], function (e)
	local r, g, b, a = ui.get(e)
	indicators_color = {r, g, b, a}
end)

ui.set_callback(visuals_ui["arrows_color"], function (e)
	local r, g, b, a = ui.get(e)
	arrows_color = {r, g, b, a}
end)

local function create_text(x, y, text_table, font, centered)	
	local x_offset = x
	if centered then
		local total_width = 0
		for _, value in ipairs(text_table) do
			local width = surface.get_text_size(font, value[1])
			total_width = total_width + width
		end
		x_offset = x - total_width / 2
	end
	for _, value in ipairs(text_table) do
		local text = value[1]
		local color = value[2]
		text:gsub(".", function(letter)
			surface.draw_text(x_offset, y, color[1], color[2], color[3], color[4], font, letter)
			local width = surface.get_text_size(font, letter)
			x_offset = x_offset + width
		end)
	end
end

local logo_font = surface.create_font("Verdana", 16, 400, {0x010, 0x080})
local indicator_font = surface.create_font("Smallest Pixel-7", 11, 400, {0x200})

local indicators = {
	["title"] = {
		["type"] = "text",
		["visible"] = true,
		["text"] = {
			{"s", {255, 255, 255, 255}},
			{"a", {255, 255, 255, 255}},
			{"p", {255, 255, 255, 255}},
			{"p", {255, 255, 255, 255}},
			{"h", {255, 255, 255, 255}},
			{"i", {255, 255, 255, 255}},
			{"r", {255, 255, 255, 255}},
			{"e", {255, 255, 255, 255}}
		},
		["text_animation"] = {
			["type"] = "single_letter",
			["current_letter"] = 1
		},
		["font"] = logo_font,
		["default"] = {
			["x"] = hw,
			["y"] = hh + 10
		},
		["offset"] = {
			["x"] = 0,
			["y"] = 0
		}
	},

	["desync_line"] = {
		["type"] = "value_line",
		["visible"] = true,
		["length"] = 56,
		["value"] = 0,
		["color"] = {255, 255, 255, 255},
		["default"] = {
			["x"] = hw,
			["y"] = hh + 28
		},
		["offset"] = {
			["x"] = 0,
			["y"] = 0
		}
	},
	
	["condition"] = {
		["type"] = "text",
		["visible"] = true,
		["text"] = {
			{"Stand", {255, 255, 255, 255}}
		},
		["font"] = indicator_font,
		["default"] = {
			["x"] = hw,
			["y"] = hh + 34
		},
		["offset"] = {
			["x"] = 0,
			["y"] = 0
		}
	},
	["additions"] = {
		["doubletap"] = {
			["type"] = "text",
			["visible"] = false,
			["timer"] = 0,
			["text"] = {
				{"DT", {255, 255, 255, 0}}
			},
			["circle"] = {
				["color"] = {0, 0, 0, 255},
				["radius"] = 4,
				["start_degrees"] = 270,
				["percentage"] = 0,
				["thickness"] = 2
			},
			["font"] = indicator_font,
			["default"] = {
				["x"] = hw - 5,
				["y"] = hh + 44
			},
			["offset"] = {
				["x"] = 0,
				["y"] = 0
			}
		},
		["hideshots"] = {
			["type"] = "text",
			["visible"] = false,
			["timer"] = 0,
			["text"] = {
				{"OS-AA", {255, 255, 255, 0}}
			},
			["font"] = indicator_font,
			["default"] = {
				["x"] = hw,
				["y"] = hh + 44
			},
			["offset"] = {
				["x"] = 0,
				["y"] = 0
			}
		},
		["freestand"] = {
			["type"] = "text",
			["visible"] = false,
			["timer"] = 0,
			["text"] = {
				{"Freestand", {255, 255, 255, 0}}
			},
			["font"] = indicator_font,
			["default"] = {
				["x"] = hw,
				["y"] = hh + 44
			},
			["offset"] = {
				["x"] = 0,
				["y"] = 0
			}
		},
		["ping"] = {
			["type"] = "text",
			["visible"] = false,
			["timer"] = 0,
			["text"] = {
				{"Ping", {255, 255, 255, 0}}
			},
			["font"] = indicator_font,
			["default"] = {
				["x"] = hw,
				["y"] = hh + 44
			},
			["offset"] = {
				["x"] = 0,
				["y"] = 0
			}
		},
		["fake_duck"] = {
			["type"] = "text",
			["visible"] = false,
			["timer"] = 0,
			["text"] = {
				{"FD", {255, 255, 255, 0}}
			},
			["font"] = indicator_font,
			["default"] = {
				["x"] = hw,
				["y"] = hh + 44
			},
			["offset"] = {
				["x"] = 0,
				["y"] = 0
			}
		},
		["min_dmg"] = {
			["type"] = "text",
			["visible"] = false,
			["timer"] = 0,
			["text"] = {
				{"Min. Damage", {255, 0, 0, 0}}
			},
			["font"] = indicator_font,
			["default"] = {
				["x"] = hw,
				["y"] = hh + 44
			},
			["offset"] = {
				["x"] = 0,
				["y"] = 0
			}
		},
		["manual_left"] = {
			["type"] = "text",
			["visible"] = false,
			["timer"] = 0,
			["text"] = {
				{"LEFT", {255, 255, 255, 255}}
			},
			["font"] = indicator_font,
			["default"] = {
				["x"] = hw,
				["y"] = hh + 44
			},
			["offset"] = {
				["x"] = 0,
				["y"] = 0
			}
		},
		["manual_right"] = {
			["type"] = "text",
			["visible"] = false,
			["timer"] = 0,
			["text"] = {
				{"RIGHT", {255, 255, 255, 255}}
			},
			["font"] = indicator_font,
			["default"] = {
				["x"] = hw,
				["y"] = hh + 44
			},
			["offset"] = {
				["x"] = 0,
				["y"] = 0
			}
		}
	}
	
}

local indicators_order = {}

local function remove_from_order(indicator)
	for index, item in pairs(indicators_order) do
		if item == indicator then
			table.remove(indicators_order, index)
			break
		end
	end
end

local function render_indicator(indicator)
	if indicator["visible"] then
		if indicator["type"] == "text" then
			local text = indicator["text"]
			local x = indicator["default"]["x"]
			local y = indicator["default"]["y"]
			local offset_x = indicator["offset"]["x"]
			local offset_y = indicator["offset"]["y"]
			local font = indicator["font"]
			if indicator["text_animation"] and indicator["text_animation"]["type"] == "single_letter" then
				if globals.framecount() % 30 == 0 then
					local current_letter = indicator["text_animation"]["current_letter"]
					if current_letter >= 2 and current_letter <= 8 then
						indicator["text"][current_letter - 1][2] = {255, 255, 255, 255}
						if current_letter == 8 then
							indicator["text_animation"]["current_letter"] = 1
						else
							indicator["text_animation"]["current_letter"] = current_letter + 1
						end
					else
						indicator["text"][8][2] = {255, 255, 255, 255}
						indicator["text_animation"]["current_letter"] = current_letter + 1
					end
					indicator["text"][current_letter][2] = indicators_color
				end
			end
			create_text(x + offset_x, y + offset_y, text, font, true)
			if indicator.circle then
				local c_color = indicator["circle"]["color"]
				local c_radius = indicator["circle"]["radius"]
				local c_start_degrees = indicator["circle"]["start_degrees"]
				local c_percentage = indicator["circle"]["percentage"]
				local c_thickness = indicator["circle"]["thickness"]
				local c_x = x + offset_x + c_radius + 6
				local c_y = y + offset_y + c_radius + 2
				renderer.circle_outline(c_x, c_y, 0, 0, 0, 200, 
				c_radius, c_start_degrees, 1, c_thickness)
				renderer.circle_outline(c_x, c_y, c_color[1], 
				c_color[2], c_color[3], c_color[4], c_radius, 
				c_start_degrees, c_percentage, c_thickness)
			end
		end
		if indicator["type"] == "value_line" then
			local x = indicator["default"]["x"]
			local y = indicator["default"]["y"]
			local offset_x = indicator["offset"]["x"]
			local offset_y = indicator["offset"]["y"]
			local value = indicator["value"]
			local length = indicator["length"]
			local color = indicator["color"]
			renderer.gradient(x - (length / 2) + offset_x, y + offset_y, (value * length) / 100, 2, color[1], color[2], color[3], color[4], 255, 255, 255, 0, true)
		end
	end
end

local function setup_indicator(name, indicator, condition)
	if indicator["visible"] == false and condition then
		indicator["visible"] = true
		table.insert(indicators_order, name)
	end
	if indicator["visible"] == true and not condition then
		indicator["visible"] = false
		indicator["timer"] = 0
		remove_from_order(name)
	end
end


--Clantag
local clantag = {
	"S",
	"Sa",
	"Sap",
	"Sapp",
	"Sa//",
	"Sapph",
	"Sapph1",
	"Sapphir",
	"Sapphir3",
	"Sapphire",
	"Sapphire.G",
	"Sapphire.GS",
	"Sa//h1r3.GS",
	"Sa//h1re.GS",
	"Sa//hire.GS",
	"Sapphire.GS",
	"Sapphire.G",
	"Sapphire",
	"Sapphir",
	"Sapphi",
	"Sapph",
	"Sapp",
	"Sap",
	"Sa"
}
local prev_frame = 0
local frames_amount = 0

for index, _ in ipairs(clantag) do
	frames_amount = index	
end

local aa_state = {
	["condition"] = 0,
	["pitch"] = 0,
	["yaw"] = 0,
	["yaw_absolute"] = 0,
	["yaw_add"] = 0,
	["desync"] = 0,
	["use_aa"] = -50,
	["force_update_lby"] = false
}

--Conditions
	-- 0 - Stand
	-- 1 - Move
	-- 2 - Slow Walk
	-- 3 - Duck
	-- 4 - Air
	-- 5 - Air Duck
	-- 6 - Fakelag

--AA procced
local function proceed_aa(cmd)
	--Clear default AA preset
	ui.set(aa_enable, true)
	ui.set(pitch[1], "Off")
	ui.set(yaw_base, "Local view")
	ui.set(yaw[1], "Off")
	ui.set(body_yaw[1], "Static")
	ui.set(body_yaw[2], 0)

	--Vars
	local lp = entity.get_local_player()
	local ct = client.current_threat()
	local ct_vct = nil
	local lp_vct = nil
	local vel_0 = math.abs(entity.get_prop(lp, "m_vecVelocity[0]"))
	local vel_1 = math.abs(entity.get_prop(lp, "m_vecVelocity[1]"))
	local vel_2 = math.abs(entity.get_prop(lp, "m_vecVelocity[2]"))
	local quick_peek_active, _ = ui.get(quick_peek[2])

	--Enemy Info
	local dist_to_threat = nil
	local enemy_weapon = nil
	if ct then
		ct_vct = vector(entity.get_origin(ct))
		lp_vct = vector(entity.get_origin(lp))
		dist_to_threat = ct_vct:dist(lp_vct)
		enemy_weapon = entity.get_classname(entity.get_player_weapon(ct))
	end

	--Anti-Backstap
	if ui.get(misc_ui["antibackstap"]) and ct then
		if dist_to_threat <= ui.get(misc_ui["antibackstap_distance"]) and enemy_weapon == "CKnife" then
			local _, yaw_to_threat, _ = lp_vct:to(ct_vct):angles()
			indicators["condition"]["text"][1][1] = "AB"
			aa_state["yaw_absolute"] = 0
			aa_state["yaw"] = yaw_to_threat
			aa_state["pitch"] = cmd.pitch
			return
		end
	end

	--On Use AA
	if cmd.in_use == 1 then
		indicators["condition"]["text"][1][1] = "Use"
		aa_state["yaw_absolute"] = 0
		aa_state["yaw_add"] = 0
		if ui.get(misc_ui["on_use_aa"]) == "Static" then
			aa_state["desync"] = 120
			aa_state["yaw"] = cmd.yaw
			aa_state["pitch"] = cmd.pitch
		end
		if ui.get(misc_ui["on_use_aa"]) == "3-Way" then
			aa_state["desync"] = 120
			aa_state["yaw"] = cmd.yaw + aa_state["use_aa"]
			aa_state["pitch"] = cmd.pitch
			if aa_state["use_aa"] < 50 then
				aa_state["use_aa"] = aa_state["use_aa"] + 50
			else
				aa_state["use_aa"] = -50
			end
		end
		return
	end
	
	indicators["condition"]["text"][1][1] = "Stand"
	aa_state["condition"] = 0
	local aa_ui = stand_aa_ui
	if vel_0 > 5 or vel_1 > 5 then
		indicators["condition"]["text"][1][1] = "Moving"
		aa_state["condition"] = 1
		aa_ui = move_aa_ui
	end
	if ui.get(slow_walk[2]) then
		indicators["condition"]["text"][1][1] = "SW"
		aa_state["condition"] = 2
		aa_ui = sw_aa_ui
	end
	if cmd.in_duck == 1 then
		indicators["condition"]["text"][1][1] = "Duck"
		aa_state["condition"] = 3
		aa_ui = crouch_aa_ui
	end
	if (vel_2 > 0 or cmd.in_jump == 1) and cmd.in_duck == 0 then
		indicators["condition"]["text"][1][1] = "Aero"
		aa_state["condition"] = 4
		aa_ui = air_aa_ui
	end
	if (vel_2 > 0 or cmd.in_jump == 1) and cmd.in_duck == 1 then
		indicators["condition"]["text"][1][1] = "Aero-Duck"
		aa_state["condition"] = 5
		aa_ui = air_duck_aa_ui
	end
	if ui.get(doubletap[2]) == false and ui.get(onshot[2]) == false then
		indicators["condition"]["text"][1][1] = "Fakelag"
		aa_state["condition"] = 6
		aa_ui = fl_aa_ui
	end


	--Pitch
	local pitch_mode = ui.get(aa_ui["pitch"]["mode"])
	local pitch_value = ui.get(aa_ui["pitch"]["settings"]["value"]["item"])
	if pitch_mode == "Up" then aa_state["pitch"] = -89 end
	if pitch_mode == "Down" then aa_state["pitch"] = 89 end
	if pitch_mode == "Random" then aa_state["pitch"] = math.random(-89, 89) end
	if pitch_mode == "Custom" then aa_state["pitch"] = pitch_value end
	
	--Yaw Modifiers
	local ym_mode = ui.get(aa_ui["yaw_modifiers"]["mode"])
	local ym_way_mode = ui.get(aa_ui["yaw_modifiers"]["settings"]["way_mode"]["item"])
	local ym_way_settings = ui.get(aa_ui["yaw_modifiers"]["settings"]["way_settings"]["item"])
	local ym_first_stage = ui.get(aa_ui["yaw_modifiers"]["settings"]["first_stage"]["item"])
	local ym_second_stage = ui.get(aa_ui["yaw_modifiers"]["settings"]["second_stage"]["item"])
	local ym_third_stage = ui.get(aa_ui["yaw_modifiers"]["settings"]["third_stage"]["item"])
	local ym_fourth_stage = ui.get(aa_ui["yaw_modifiers"]["settings"]["fourth_stage"]["item"])
	local ym_fifth_stage = ui.get(aa_ui["yaw_modifiers"]["settings"]["fifth_stage"]["item"])
	local ym_first_stage_delay = ui.get(aa_ui["yaw_modifiers"]["settings"]["first_stage_delay"]["item"])
	local ym_second_stage_delay = ui.get(aa_ui["yaw_modifiers"]["settings"]["second_stage_delay"]["item"])
	local ym_third_stage_delay = ui.get(aa_ui["yaw_modifiers"]["settings"]["third_stage_delay"]["item"])
	local ym_fourth_stage_delay = ui.get(aa_ui["yaw_modifiers"]["settings"]["fourth_stage_delay"]["item"])
	local ym_fifth_stage_delay = ui.get(aa_ui["yaw_modifiers"]["settings"]["fifth_stage_delay"]["item"])
	local ym_variance = ui.get(aa_ui["yaw_modifiers"]["settings"]["variance"]["item"])
	local ym_sway_speed = ui.get(aa_ui["yaw_modifiers"]["settings"]["sway_speed"]["item"])
	local ym_sway_mode = ui.get(aa_ui["yaw_modifiers"]["settings"]["sway_mode"]["item"])
	local ym_sway_range = ui.get(aa_ui["yaw_modifiers"]["settings"]["sway_range"]["item"])
	local ym_value = ui.get(aa_ui["yaw_modifiers"]["settings"]["value"]["item"])
	local ym_spin_speed = ui.get(aa_ui["yaw_modifiers"]["settings"]["spin_speed"]["item"])
	local ym_spin_delay = ui.get(aa_ui["yaw_modifiers"]["settings"]["spin_delay"]["item"])
	local current_yaw = aa_state["yaw"]

	if ym_mode == "Off" or (ui.get(misc_ui["disable_jitter"]) and quick_peek_active) then
		aa_state["yaw"] = 0
	else
		if ym_mode == "Static" then
			aa_state["yaw"] = ym_value
		end

		if ym_mode == "X-Way" then
			local way_amount = 0
			local current_way_delay = 0
			local yaw_to_set = 0
			if ym_way_mode == "2-Way" then way_amount = 2 end
			if ym_way_mode == "3-Way" then way_amount = 3 end
			if ym_way_mode == "4-Way" then way_amount = 4 end
			if ym_way_mode == "5-Way" then way_amount = 5 end


			if way_stage == 1 then yaw_to_set = ym_first_stage current_way_delay = ym_first_stage_delay end
			if way_stage == 2 then yaw_to_set = ym_second_stage current_way_delay = ym_second_stage_delay end
			if way_stage == 3 then yaw_to_set = ym_third_stage current_way_delay = ym_third_stage_delay end
			if way_stage == 4 then yaw_to_set = ym_fourth_stage current_way_delay = ym_fourth_stage_delay end
			if way_stage == 5 then yaw_to_set = ym_fifth_stage current_way_delay = ym_fifth_stage_delay end
			
			if (yaw_to_set < 0 or yaw_to_set > 0) and contains(ym_way_settings, "Variance") then
				local randomized_addition = math.random(1, math.abs(yaw_to_set) * (ym_variance / 100))
				if yaw_to_set < 0 then
					yaw_to_set = yaw_to_set + randomized_addition
				end
				if yaw_to_set > 0 then
					yaw_to_set = yaw_to_set - randomized_addition
				end
			end

			if not contains(ym_way_settings, "Delays") then
				current_way_delay = 2
			end
			
			aa_state["yaw"] = yaw_to_set

			way_delay = way_delay + 1

			if way_delay >= current_way_delay then
				way_delay = 0
				if way_stage < way_amount then way_stage = way_stage + 1 else way_stage = 1 end
			end
		end

		if ym_mode == "Spin" then
			if ((current_yaw < 360 and current_yaw >= 0 and ym_spin_speed > 0) or (current_yaw > -360 and current_yaw <= 0 and ym_spin_speed < 0)) and spin_delay >= ym_spin_delay then
				if current_yaw + ym_spin_speed > 360 or current_yaw + ym_spin_speed < - 360 then
					aa_state["yaw"] = 360
				else
					aa_state["yaw"] = current_yaw + ym_spin_speed
				end
				if aa_state["yaw"] == 360 or aa_state["yaw"] == -360 then
					aa_state["yaw"] = 0
					spin_delay = 1
				end
			else
				aa_state["yaw"] = 0
				spin_delay = spin_delay + 1
			end
		end

		if ym_mode == "Sway" then
			if current_yaw >= ym_sway_range * -1 and current_yaw <= ym_sway_range then
				if sway_side == 0 then
					if current_yaw + ym_sway_speed <= ym_sway_range then
						aa_state["yaw"] = current_yaw + ym_sway_speed
					else
						if ym_sway_mode == "One Sided" then
							aa_state["yaw"] = ym_sway_range * -1
						end
						if ym_sway_mode == "Two Sided" then
							aa_state["yaw"] = ym_sway_range
							sway_side = 1
						end
					end
				else
					if current_yaw - ym_sway_speed >= ym_sway_range * -1 then
						aa_state["yaw"] = current_yaw - ym_sway_speed
					else
						aa_state["yaw"] = ym_sway_range * -1
						sway_side = 0
					end
				end
			else
				aa_state["yaw"] = ym_sway_range * -1
			end	
		end
	end
	--end

	--Jitter
	local jitter_mode = ui.get(aa_ui["yaw_jitter"]["mode"])
	local jitter_value = ui.get(aa_ui["yaw_jitter"]["settings"]["value"]["item"]) / 10
	if jitter_mode == "Off" or (ui.get(misc_ui["disable_jitter"]) and quick_peek_active) then
		aa_state["yaw_add"] = 0
	else
		if globals.tickcount() % 2 == 0 then
			if jitter_mode == "Center" then
				jitter_value = math.abs(jitter_value)
				if aa_state["yaw_add"] >= 0 then
					aa_state["yaw_add"] = jitter_value * -1
				else
					aa_state["yaw_add"] = jitter_value
				end
			end
			if jitter_mode == "Offset" then
				if aa_state["yaw_add"] ~= 0 then
					aa_state["yaw_add"] = 0
				else
					aa_state["yaw_add"] = jitter_value
				end
			end
			if jitter_mode == "Random" then
				jitter_value = math.abs(jitter_value)
				if aa_state["yaw_add"] >= 0 then
					aa_state["yaw_add"] = math.random(jitter_value * -1, 0)
				else
					aa_state["yaw_add"] = math.random(0, jitter_value)
				end
			end
		end
	end
	
	local ds_mode = ui.get(aa_ui["desync"]["mode"])
	local ds_left_limit = ui.get(aa_ui["desync"]["settings"]["left_limit"]["item"])
	local ds_right_limit = ui.get(aa_ui["desync"]["settings"]["right_limit"]["item"])
	--Desync
	if ds_mode == "Off" then
		aa_state["desync"] = 0
	else
		if ds_mode == "Right" then
			aa_state["desync"] = -60 + (ds_right_limit / 100) * -60
		end
		if ds_mode == "Left" then
			aa_state["desync"] = 60 + (ds_left_limit / 100) * 60
		end
		if ds_mode == "Jitter" then
			if globals.tickcount() % 2 == 0 then		
				if aa_state["desync"] <= 0 then
					aa_state["desync"] = (ds_left_limit / 100) * 60 * 2
				else
					aa_state["desync"] = (ds_right_limit / 100) * -60 * 2
				end
			end
		end
	end
	--end

	--Defensive
	local def_mode = ui.get(aa_ui["defensive"]["mode"])
	local def_pitch = ui.get(aa_ui["defensive"]["settings"]["pitch"]["item"])
	if def_mode == "Always" then
		cmd.force_defensive = true
		if def_pitch ~= "Off" and globals.tickcount() % math.random(2, 10) == 0 then
			if def_pitch == "Up" then aa_state["pitch"] = -89 end
			if def_pitch == "Down" then aa_state["pitch"] = 89 end
			if def_pitch == "Random" then aa_state["pitch"] = math.random(-89, 89) end
		end
	end
	
	
	local rl_mode = ui.get(aa_ui["roll"]["mode"])
	local rl_value = ui.get(aa_ui["roll"]["settings"]["value"]["item"])
	local rl_tickbase = ui.get(aa_ui["roll"]["settings"]["tickbase"]["item"])
	--Roll
	if rl_mode == "Static" then
		if globals.tickcount() % rl_tickbase == 0 then
			cmd.roll = rl_value
		end
	end
	--end

	--At-Targets
	if ct then
		local _, yaw_to_threat, _ = lp_vct:to(ct_vct):angles()
		aa_state["yaw_absolute"] = yaw_to_threat + 180
	else
		aa_state["yaw_absolute"] = cmd.yaw + 180
	end

end



client.set_event_callback("paint", function()
	--Clantag
	if ui.get(misc_ui["clantag"]) then
		local current_frame = (math.ceil(globals.curtime()) % (frames_amount)) + 1
		if prev_frame ~= current_frame then
			client.set_clan_tag(clantag[current_frame])
			prev_frame = current_frame
		end
	end


	local pr = entity.get_player_resource()
	local lp = entity.get_local_player()

	ui.set(ui.reference('VISUALS', 'Other ESP', 'Feature indicators'), {})

	if entity.is_alive(lp) and ui.get(visuals_ui["indicators"]) then
		--Arrows
		if ui.get(visuals_ui["arrows"]) then
			local la_clr = {0, 0, 0, 100}
			local ra_clr = {0, 0, 0, 100}

			if anti_aim.get_desync(1) > 0 then
				ra_clr = arrows_color
			end
			if anti_aim.get_desync(1) < 0 then
				la_clr = arrows_color
			end

			
			--Left arrow
			renderer.triangle(hw - 40, hh - 10, hw - 40, hh + 10, hw - 58, hh, 0, 0, 0, 100)
			renderer.rectangle(hw - 39, hh - 10, 3, 20, la_clr[1], la_clr[2], la_clr[3], la_clr[4])
			--Right arrow
			renderer.triangle(hw + 40, hh - 10, hw + 40, hh + 10, hw + 58, hh, 0, 0, 0, 100)
			renderer.rectangle(hw + 36, hh - 10, 3, 20, ra_clr[1], ra_clr[2], ra_clr[3], ra_clr[4])
		end

		if globals.tickcount() % 5 == 0 then
			local desync_amount = math.ceil(math.ceil(math.abs(anti_aim.get_desync(1))) / 58 * 100)
			indicators["desync_line"]["value"] = desync_amount
		end

		render_indicator(indicators["title"])
		render_indicator(indicators["desync_line"])
		render_indicator(indicators["condition"])
		
		for name, indicator in pairs(indicators["additions"]) do
			if name == "doubletap" then
				local percentage = anti_aim.get_tickbase_shifting() / 12
				if percentage < 1 then
					indicator["circle"]["color"] = {255, 0, 0, 255}
				else
					indicator["circle"]["color"] = {124, 195, 13, 255}
				end
				indicator["circle"]["percentage"] = percentage
				setup_indicator(name, indicator, ui.get(doubletap[2]))
			end
			if name == "hideshots" then
				setup_indicator(name, indicator, ui.get(onshot[2]))
			end
			if name == "freestand" then
				setup_indicator(name, indicator, ui.get(binds_ui["freestand"]))
			end
			if name == "ping" then
				local ping = entity.get_prop(pr, 'm_iPing', lp)
				local ping_spike_limit = ui.get(ping_spike[3])
				if ping < ping_spike_limit / 2 then
					indicator["text"][1][2][1] = 255
					indicator["text"][1][2][2] = 0
					indicator["text"][1][2][3] = 0
				else
					indicator["text"][1][2][1] = 124
					indicator["text"][1][2][2] = 195
					indicator["text"][1][2][3] = 13
				end
				setup_indicator(name, indicator, ui.get(ping_spike[2]))
			end
			if name == "fake_duck" then
				setup_indicator(name, indicator, ui.get(fake_duck[1]))
			end
			if name == "min_dmg" then
				setup_indicator(name, indicator, ui.get(min_dmg[2]))
			end
			if name == "manual_right" then
				setup_indicator(name, indicator, manual_right)
			end
			if name == "manual_left" then
				setup_indicator(name, indicator, manual_left)
			end
		end

		for index, name in pairs(indicators_order) do
			local from = 0
			local to = 10 * (index - 1)
			if index > 1 then
				from = 10 * (index - 2)
			end
			
			local indicator = indicators["additions"][name]

			local offset = easing["cubic_out"](indicator["timer"], from, to - from, 1)
			local opacity = easing["cubic_out"](indicator["timer"], 0, 250, 1)
			
			if indicator["timer"] < 1 then
				indicator["timer"] = indicator["timer"] + globals.frametime() * 5
			end

			
			indicator["text"][1][2][4] = opacity
			indicator["offset"]["y"] = offset
			render_indicator(indicator)
		end
	end

end)

client.set_event_callback("setup_command", function(cmd)
	--Vars
	local lp = entity.get_local_player()
	local lp_weapon = entity.get_player_weapon(lp)
	local lp_weapon_classname = entity.get_classname(lp_weapon)
	local in_grenade = false
	local in_knife = false

	proceed_aa(cmd)

	--Current weapon
	if string.find(lp_weapon_classname, "Grenade") then in_grenade = true end
	if lp_weapon_classname == "CKnife" then in_knife = true end

	--Freestand
	local freestand_hk = ui.get(binds_ui["freestand"])
	if freestand_hk then
		ui.set(freestand, true)
		ui.set(pitch[1], "Down")
		ui.set(yaw[1], "180")
	else
		ui.set(freestand, false)
	end

	if ((cmd.in_attack == 1) and not in_grenade) or (cmd.in_attack2 == 1 and in_knife) or (in_grenade and entity.get_prop(lp_weapon, "m_fThrowTime") > 0) or entity.get_prop(lp, "m_MoveType") == 9 or freestand_hk then return
	else
		if cmd.chokedcommands == 0 then
			cmd.allow_send_packet = false
			cmd.pitch = aa_state["pitch"]
			cmd.yaw = aa_state["yaw_absolute"] + aa_state["yaw"] + aa_state["yaw_add"] + aa_state["desync"]
			if cmd.forwardmove == 0 and cmd.sidemove == 0 then cmd.forwardmove = -1.01 end
		else
			cmd.pitch = aa_state["pitch"]
			cmd.yaw = aa_state["yaw_absolute"] +  aa_state["yaw"] + aa_state["yaw_add"]
		end
	end

	if shot_made then shot_made = false end
	if damage_taken then damage_taken = false end
	
end)
