local lua_name = "name"

function split_string_in_half(input_string)
    local length = string.len(input_string)
    local midpoint = math.floor(length / 2)
  
    local first_half = string.sub(input_string, 1, midpoint)
    local second_half = string.sub(input_string, midpoint + 1)
  
    return first_half, second_half
end

function add_spaces(input_string)
    return string.gsub(input_string, "(.)", "%1 ")
end

local lua_name_short_1, lua_name_short_2 = split_string_in_half(lua_name)
local lua_name_with_spaces = add_spaces(lua_name)

local pui = require("neverlose/pui");
local anti_aim = require("neverlose/anti_aim");
local Clipboard = require("neverlose/clipboard");
local renderer = require("neverlose/b_renderer");
local base64 = require("neverlose/sec-base64");
local smoothy = require("neverlose/smoothy");
local x, y = (render.screen_size()).x, (render.screen_size()).y;
local player_state = 1;
local hitboxes = {
	[0] = "generic",
	"head",
	"chest",
	"stomach",
	"left arm",
	"right arm",
	"left leg",
	"right leg",
	"neck",
	"generic",
	"gear"
};
local anti_aim_states = {
	"standing",
	"running",
	"slowwalk",
	"ducking",
	"air",
	"air+duck",
	"safe",
	"on grenade"
};
local anti_aim_states_t = {
	"standing",
	"running",
	"slowwalk",
	"ducking",
	"air",
	"air+duck",
	"safe",
	"on grenade"
};
local helpers = {};
local functions = {};
local custom_aa = {};
local custom_aa_t = {};
local database = {
	misses = 0,
	enemies = 0,
	date = {
		"-"
	},
	name = {
		"* default"
	},
	config = {
		""
	},
	config_t = {
		""
	}
};
local create_file = files.create_folder("nl/" .. lua_name .. "");
if files.read("nl/" .. lua_name .. "/data.txt") == nil then
	files.write("nl/" .. lua_name .. "/data.txt", json.stringify(database));
end;
local database = json.parse(files.read("nl/" .. lua_name .. "/data.txt"));
local home6 = pui.create("\a{Link Active}", "ㅤㅤㅤㅤㅤㅤㅤ");
local home7 = pui.create("\a{Link Active}", "ㅤㅤㅤㅤㅤㅤㅤㅤㅤ");
local home4 = pui.create("\a{Link Active}", "ㅤㅤㅤㅤ");
local home2 = pui.create("\a{Link Active}", "ㅤㅤ");
local home = pui.create("\a{Link Active}", "ㅤ");
local home3 = pui.create("\a{Link Active}", "ㅤㅤㅤ");
local home5 = pui.create("\a{Link Active}", "ㅤㅤㅤㅤㅤ");
local home8 = pui.create("\a{Link Active}", "ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ");
local references = {
	hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
	dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
	qp = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
	hs = ui.find("Aimbot", "Ragebot", "Main", "hide shots"),
	dtopt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
	safe = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
	fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
	bodyaim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
	dormantaim = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
	pingspike = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
	fs = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
	dmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
	legmovement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
	pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
	yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
	fsopt1 = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
	fsopt = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
	inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
	yawbase = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
	fake_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
	yawadd = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
	bodyyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
	yawmodifieroffset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
	yawmodifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
	slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
	left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
	right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit")
};
local menu = {
	["anti-aim"] = {
		label1 = home:label("\a{Link Active}" .. "-------------     " .. "\ac8c8c8ff" .. "ibia " .. "\a{Link Active}" .. "------------"),
		preset = home:combo("", "anti-aim", "settings", "config"),
		label2 = home:label("\a{Link Active}" .. "‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
		label3 = home:label("\a{Link Active}" .. ui.get_icon("user") .. "\a{Text}" .. "   user: " .. "\a{Link Active}" .. string.lower(common.get_username())),
		label4 = home:label("\a{Link Active}" .. ui.get_icon("code-branch") .. "\a{Text}" .. "   revision: " .. "\a{Link Active}" .. "preview"),
		label5 = home:label("\a{Link Active}" .. "‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
		label17 = home6:label("\a{Link Active}" .. "•" .. "\a{Text}" .. "  customize"),
		label16 = home6:label("\a{Link Active}" .. "‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
		label22 = home6:label("\a{Link Active}" .. "•" .. "\a{Text}" .. "  features"),
		label23 = home6:label("\a{Link Active}" .. "‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
		features = home:combo("", "preset", "builder", "features"),
		label35 = home6:label("\a{Link Active}" .. "•" .. "\a{Text}" .. "  default"),
		label36 = home6:label("\a{Link Active}" .. "‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
		label37 = home6:label("\a{Link Active}• \a{Text}you are using preset."),
		label38 = home6:label("\a{Link Active}• \a{Text}everything is already set up."),
		label39 = home6:label("\a{Link Active}• \a{Text}enjoy, \a{Link Active}" .. string.lower(common.get_username())),
		label18 = home3:label("\a{Link Active}" .. "------------- " .. lua_name_short_1 .. "\ac8c8c8ff" .. lua_name_short_2 .. "\a{Link Active}" .. " ------------"),
		features_select = home6:selectable("", "manual aa", "nade throw fix"),
		manual_left = home6:hotkey("manual left"),
		manual_right = home6:hotkey("manual right")
	},
	configs = {
		label12 = home7:label("\a{Link Active}" .. "•" .. "\a{Text}" .. "  your configs"),
		label13 = home7:label("\a{Link Active}" .. "‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
		List = home7:list("", database.name),
		label24 = home8:label("\a{Link Active}" .. "•" .. "\a{Text}" .. "  new config"),
		label25 = home8:label("\a{Link Active}" .. "‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
		Name = home8:input("", ""),
		Export = home7:button("\a{Link Active}" .. ui.get_icon("file-export") .. "\a{Text} export", function()
			functions.config_system:Export();
		end, true),
		Import = home8:button("\a{Link Active}" .. ui.get_icon("file-import") .. "\a{Text}   import", function()
			functions.config_system:Import();
		end, true),
		Deleting = home7:button("\aFF55329B" .. ui.get_icon("trash-xmark") .. "\a{Text}" .. " delete", function()
			functions.config_system:Delete();
		end, true),
		Create = home8:button("\a{Link Active}" .. ui.get_icon("plus") .. "\a{Text}" .. " create", function()
			functions.config_system:Create();
		end, true),
		Save = home7:button("\a{Link Active}" .. ui.get_icon("floppy-disk") .. "\a{Text}" .. " save", function()
			functions.config_system:Save();
		end, true),
		Load = home7:button("\a{Link Active}" .. ui.get_icon("upload") .. "\a{Text}" .. " load", function()
			functions.config_system:Load();
		end, true),
		user = home7:label("\a{Link Active}" .. ui.get_icon("user") .. "\a{Text}" .. "  " .. string.lower(common.get_username())),
		date = home7:label("\a{Link Active}" .. ui.get_icon("clock") .. "\a{Text}" .. "  " .. common.get_date("20%y-%m-%d %H:%M:%S"))
	},
	stats = {
		label6 = home5:label("\a{Link Active}" .. "•" .. "\a{Text}" .. "  statistics"),
		label7 = home5:label("\a{Link Active}" .. ui.get_icon("skull") .. "\a{Text}" .. "   enemies killed: " .. "\a{Link Active}" .. database.enemies),
		label8 = home5:label("\a{Link Active}" .. ui.get_icon("phone-missed") .. "\a{Text}" .. "   misses: " .. "\a{Link Active}" .. database.misses),
		label9 = home5:label("\a{Link Active}" .. ui.get_icon("hourglass-clock") .. "\a{Text}" .. "   session: ")
	},
	builder = {
		condition = home6:combo("", anti_aim_states),
		condition_t = home6:combo("", anti_aim_states_t),
		label14 = home6:label("\a{Link Active}" .. " ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
		team = home6:combo("", "ct", "t"),
		label15 = home6:label("\a{Link Active}" .. " ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾")
	},
	settings = {
		label10 = home4:label("\a{Link Active}" .. "•" .. "\a{Text}" .. "  visuals"),
		indicators = home4:switch("\a{Link Active}" .. ui.get_icon("gallery-thumbnails") .. "\a{Text}" .. "  screen indicators", false, function(gear)
			return {
				widgets = gear:selectable("widgets", "crosshair indicator", "damage indicator", "anti-aim arrows"),
				color_arrows = gear:color_picker("arrows color", color(195, 198, 255, 255)),
				color = gear:color_picker("indicator color", color(255, 183, 183, 170))
			};
		end),
		logs = home4:switch("\a{Link Active}" .. ui.get_icon("crosshairs") .. "\a{Text}" .. "  aimbot logs", false, function(gear)
			return {
				full_color_logs = gear:switch("full color logs"),
				hit_color = gear:color_picker("hit color", color(150, 200, 59, 255)),
				miss_color = gear:color_picker("miss color", color(158, 69, 69, 255))
			};
		end),
		watermark = home4:switch("\a{Link Active}" .. ui.get_icon("bookmark") .. "\a{Text}" .. "  watermark", false, function(gear)
			return {
				position = gear:combo("position", "left", "right"),
				color = gear:color_picker("first color", color(155, 155, 200, 255)),
				color2 = gear:color_picker("second color", color(0, 0, 0, 255))
			};
		end),
		scope = home4:switch("\a{Link Active}" .. ui.get_icon("telescope") .. "\a{Text}" .. "  better scope overlay", false, function(gear)
			return {
				styles = gear:combo("mode", "default", "t-sharp"),
				gap = gear:slider("gap", 1, 160, 15),
				length = gear:slider("length", 9, 300, 190),
				speed = gear:slider("animation speed", 10, 25),
				color = gear:color_picker("color", color(255, 255, 255, 255))
			};
		end),
		shared_icon = home4:switch("\a{Link Active}" .. ui.get_icon("share-nodes") .. "\a{Text}" .. "  shared icon", false),
		label11 = home4:label("\a{Link Active}" .. "•" .. "\a{Text}" .. "  misc"),
		aspectratio = home4:switch("\a{Link Active}" .. ui.get_icon("expand") .. "\a{Text}" .. "  aspect ratio", false, function(gear)
			return {
				offset = gear:slider("value", 0, 200, 0, 0.01, function(value)
					if value > 0 then
						return value;
					else
						return "off";
					end;
				end),
				first = gear:button("16:9", function()
					helpers.functions:ratio(16, 9);
				end, true),
				second = gear:button("16:10", function()
					helpers.functions:ratio(16, 10);
				end, true),
				third = gear:button("4:3", function()
					helpers.functions:ratio(4, 3);
				end, true),
				reset1 = gear:button("reset", function()
					helpers.functions:reset_asp();
				end, true)
			};
		end),
		viewmodel = home4:switch("\a{Link Active}" .. ui.get_icon("glasses") .. "\a{Text}" .. "  viewmodel", false, function(gear)
			return {
				fov = gear:slider("fov", 0, 100, 68),
				x = gear:slider("x", -100, 100, 25, 0.1),
				y = gear:slider("y", -100, 100, 0, 0.1),
				z = gear:slider("z", -100, 100, -15, 0.1),
				reset1 = gear:button("reset", function()
					helpers.functions:reset_view();
				end, true)
			};
		end),
		warmup_helper = home4:switch("\a{Link Active}" .. ui.get_icon("hand-holding-hand") .. "\a{Text}" .. "  warmup helper", false),
		nofalldamage = home4:switch("\a{Link Active}" .. ui.get_icon("person-falling-burst") .. "\a{Text}" .. "  no fall damage", false)
	}
};
for i = 1, #anti_aim_states do
	custom_aa[i] = {
		enable = home6:switch("enable \a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " state"),
		pitch = home6:combo("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ pitch", {
			"disabled",
			"down",
			"fake down",
			"fake up"
		}),
		yaw_type = home6:combo("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ yaw", {
			"default",
			"l&r"
		}, function(gear)
			return {
				yawaddl = gear:slider("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ yaw left", -180, 180, 0, true, "°", 1),
				yawaddr = gear:slider("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ yaw right", -180, 180, 0, true, "°", 1),
				yaw_value = gear:slider("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ yaw value", -180, 180, 0, true, "°", 1)
			};
		end),
		yawjitter = home6:combo("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ jitter type", {
			"off",
			"offset",
			"center",
			"random"
		}, function(gear)
			return {
				yawjitteradd = gear:slider("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ yaw jitter add", -180, 180, 0, true, "°", 1)
			};
		end),
		bodyyaw = home6:switch("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ body yaw", false, function(gear)
			return {
				options = gear:combo("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ body yaw", {
					"off",
					"jitter"
				}),
				bodyyawadd = gear:slider("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ body yaw add left", 0, 60, 0, true, "°", 1),
				bodyyawaddr = gear:slider("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ body yaw add right", 0, 60, 0, true, "°", 1)
			};
		end),
		defensive = home6:switch("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ force defensive", false, function(gear)
			return {
				defensive_pitch = gear:combo("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ defensive pitch", {
					"disabled",
					"down",
					"fake down",
					"up-switch",
					"fake up",
					"random",
					"custom"
				}),
				pitch_amount = gear:slider("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ offset", -89, 89, -49, true, "°", 1),
				pitch_amount_2 = gear:slider("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ offset 2", -89, 89, -49, true, "°", 1),
				defensive_yaw = gear:combo("\a{Link Active}" .. anti_aim_states[i] .. "\a{Text}" .. " ~ defensive yaw", {
					"off",
					"hidden",
					"random",
					"spin"
				})
			};
		end)
	};
end;
for i = 1, #anti_aim_states_t do
	custom_aa_t[i] = {
		enable = home6:switch("enable \a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " state"),
		pitch = home6:combo("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ pitch", {
			"disabled",
			"down",
			"fake down",
			"fake up"
		}),
		yaw_type = home6:combo("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ yaw", {
			"default",
			"l&r"
		}, function(gear)
			return {
				yawaddl = gear:slider("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ yaw left", -180, 180, 0, true, "°", 1),
				yawaddr = gear:slider("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ yaw right", -180, 180, 0, true, "°", 1),
				yaw_value = gear:slider("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ yaw value", -180, 180, 0, true, "°", 1)
			};
		end),
		yawjitter = home6:combo("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ jitter type", {
			"off",
			"offset",
			"center",
			"random"
		}, function(gear)
			return {
				yawjitteradd = gear:slider("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ yaw jitter add", -180, 180, 0, true, "°", 1)
			};
		end),
		bodyyaw = home6:switch("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ body yaw", false, function(gear)
			return {
				options = gear:combo("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ body yaw", {
					"off",
					"jitter"
				}),
				bodyyawadd = gear:slider("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ body yaw add left", 0, 60, 0, true, "°", 1),
				bodyyawaddr = gear:slider("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ body yaw add right", 0, 60, 0, true, "°", 1)
			};
		end),
		defensive = home6:switch("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ force defensive", false, function(gear)
			return {
				defensive_pitch = gear:combo("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ defensive pitch", {
					"disabled",
					"down",
					"fake down",
					"fake up",
					"up-switch",
					"random",
					"custom"
				}),
				pitch_amount = gear:slider("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ offset", -89, 89, -49, true, "°", 1),
				pitch_amount_2 = gear:slider("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ offset 2", -89, 89, -49, true, "°", 1),
				defensive_yaw = gear:combo("\a{Link Active}" .. anti_aim_states_t[i] .. "\a{Text}" .. " ~ defensive yaw", {
					"off",
					"hidden",
					"random",
					"spin"
				})
			};
		end)
	};
end;
local Children = function()
	ui.sidebar("\a{Link Active}" .. lua_name_with_spaces, "atlassian");
	menu.builder.condition:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu.builder.team,
		"ct"
	}, {
		menu["anti-aim"].features,
		"builder"
	});
	menu.builder.condition_t:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu.builder.team,
		"t"
	}, {
		menu["anti-aim"].features,
		"builder"
	});
	menu.settings.indicators:depend({
		menu["anti-aim"].preset,
		"settings"
	});
	menu.settings.indicators.widgets:depend(menu.settings.indicators);
	menu.settings.indicators.color:depend(menu.settings.indicators, {
		menu.settings.indicators.widgets,
		"crosshair indicator"
	});
	menu.settings.indicators.color_arrows:depend(menu.settings.indicators, {
		menu.settings.indicators.widgets,
		"anti-aim arrows"
	});
	menu.settings.scope:depend({
		menu["anti-aim"].preset,
		"settings"
	});
	menu.settings.scope.color:depend(menu.settings.scope);
	menu.settings.scope.styles:depend(menu.settings.scope);
	menu.settings.scope.gap:depend(menu.settings.scope);
	menu.settings.scope.length:depend(menu.settings.scope);
	menu.settings.scope.speed:depend(menu.settings.scope);
	menu.settings.logs:depend({
		menu["anti-aim"].preset,
		"settings"
	});
	menu.settings.logs.full_color_logs:depend(menu.settings.logs);
	menu.settings.logs.hit_color:depend(menu.settings.logs);
	menu.settings.logs.miss_color:depend(menu.settings.logs);
	menu.settings.watermark:depend({
		menu["anti-aim"].preset,
		"settings"
	});
	menu.settings.watermark.color:depend(menu.settings.watermark);
	menu.settings.watermark.color2:depend(menu.settings.watermark);
	menu.settings.watermark.position:depend(menu.settings.watermark);
	menu.settings.aspectratio:depend({
		menu["anti-aim"].preset,
		"settings"
	});
	menu.settings.viewmodel:depend({
		menu["anti-aim"].preset,
		"settings"
	});
	menu.stats.label6:depend({
		menu["anti-aim"].preset,
		"settings",
		"anti-aim"
	});
	menu.stats.label7:depend({
		menu["anti-aim"].preset,
		"settings",
		"anti-aim"
	});
	menu.stats.label8:depend({
		menu["anti-aim"].preset,
		"settings",
		"anti-aim"
	});
	menu.stats.label9:depend({
		menu["anti-aim"].preset,
		"settings",
		"anti-aim"
	});
	menu.settings.label10:depend({
		menu["anti-aim"].preset,
		"settings"
	});
	menu.settings.label11:depend({
		menu["anti-aim"].preset,
		"settings"
	});
	menu.builder.label15:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"builder"
	});
	menu.builder.label14:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"builder"
	});
	menu["anti-aim"].label16:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"builder"
	});
	menu["anti-aim"].label17:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"builder"
	});
	menu["anti-aim"].label22:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"features"
	});
	menu["anti-aim"].label23:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"features"
	});
	menu["anti-aim"].features_select:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"features"
	});
	menu["anti-aim"].manual_left:depend({
		menu["anti-aim"].features_select,
		"manual aa"
	}, {
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"features"
	});
	menu["anti-aim"].manual_right:depend({
		menu["anti-aim"].features_select,
		"manual aa"
	}, {
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"features"
	});
	menu["anti-aim"].label18:depend({
		menu["anti-aim"].preset,
		"anti-aim",
		"settings",
		"config"
	});
	menu.builder.team:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"builder"
	});
	menu["anti-aim"].label37:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"preset"
	});
	menu["anti-aim"].label38:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"preset"
	});
	menu["anti-aim"].label39:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"preset"
	});
	menu["anti-aim"].label35:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"preset"
	});
	menu["anti-aim"].label36:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	}, {
		menu["anti-aim"].features,
		"preset"
	});
	menu["anti-aim"].features:depend({
		menu["anti-aim"].preset,
		"anti-aim"
	});
	menu.settings.viewmodel.fov:depend(menu.settings.viewmodel);
	menu.settings.viewmodel.x:depend(menu.settings.viewmodel);
	menu.settings.viewmodel.y:depend(menu.settings.viewmodel);
	menu.settings.viewmodel.z:depend(menu.settings.viewmodel);
	menu.settings.viewmodel.reset1:depend(menu.settings.viewmodel);
	menu.settings.aspectratio.offset:depend(menu.settings.aspectratio);
	menu.settings.aspectratio.first:depend(menu.settings.aspectratio);
	menu.settings.aspectratio.second:depend(menu.settings.aspectratio);
	menu.settings.aspectratio.third:depend(menu.settings.aspectratio);
	menu.settings.aspectratio.reset1:depend(menu.settings.aspectratio);
	menu.settings.warmup_helper:depend({
		menu["anti-aim"].preset,
		"settings"
	});
	menu.settings.nofalldamage:depend({
		menu["anti-aim"].preset,
		"settings"
	});
	menu.settings.shared_icon:depend({
		menu["anti-aim"].preset,
		"settings"
	});
	menu.configs.Load:depend({
		menu["anti-aim"].preset,
		"config"
	});
	menu.configs.Save:depend({
		menu["anti-aim"].preset,
		"config"
	});
	menu.configs.Deleting:depend({
		menu["anti-aim"].preset,
		"config"
	});
	menu.configs.Export:depend({
		menu["anti-aim"].preset,
		"config"
	});
	menu.configs.Import:depend({
		menu["anti-aim"].preset,
		"config"
	});
	menu.configs.date:depend({
		menu["anti-aim"].preset,
		"config"
	});
	menu.configs.user:depend({
		menu["anti-aim"].preset,
		"config"
	});
	menu.configs.Create:depend({
		menu["anti-aim"].preset,
		"config"
	});
	menu.configs.List:depend({
		menu["anti-aim"].preset,
		"config"
	});
	menu.configs.Name:depend({
		menu["anti-aim"].preset,
		"config"
	});
	menu.configs.label12:depend({
		menu["anti-aim"].preset,
		"config"
	});
	menu.configs.label13:depend({
		menu["anti-aim"].preset,
		"config"
	});
	menu.configs.label24:depend({
		menu["anti-aim"].preset,
		"config"
	});
	menu.configs.label25:depend({
		menu["anti-aim"].preset,
		"config"
	});
	for i = 1, #anti_aim_states do
		custom_aa[i].enable:depend({
			menu["anti-aim"].preset,
			"anti-aim"
		}, {
			menu.builder.team,
			"ct"
		}, {
			menu.builder.condition,
			anti_aim_states[i]
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].pitch:depend({
			menu["anti-aim"].preset,
			"anti-aim"
		}, {
			menu.builder.team,
			"ct"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].yaw_type:depend({
			menu.builder.team,
			"ct"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].yaw_type.yawaddl:depend({
			menu["anti-aim"].preset,
			"anti-aim"
		}, {
			menu.builder.team,
			"ct"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, {
			custom_aa[i].yaw_type,
			"l&r"
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].yaw_type.yawaddr:depend({
			menu["anti-aim"].preset,
			"anti-aim"
		}, {
			menu.builder.team,
			"ct"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, {
			custom_aa[i].yaw_type,
			"l&r"
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].yaw_type.yaw_value:depend({
			menu.builder.team,
			"ct"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, {
			custom_aa[i].yaw_type,
			"default"
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].yawjitter:depend({
			menu["anti-aim"].preset,
			"anti-aim"
		}, {
			menu.builder.team,
			"ct"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].yawjitter.yawjitteradd:depend({
			custom_aa[i].yawjitter,
			"center",
			"offset",
			"random"
		}, {
			menu.builder.team,
			"ct"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, {
			custom_aa[i].yawjitter,
			function()
				if custom_aa[i].yawjitter:get() ~= "Off" then
					return true;
				else
					return false;
				end;
			end
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].bodyyaw:depend({
			menu["anti-aim"].preset,
			"anti-aim"
		}, {
			menu.builder.team,
			"ct"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].bodyyaw.options:depend({
			menu.builder.team,
			"ct"
		}, custom_aa[i].bodyyaw, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, custom_aa[i].bodyyaw, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].bodyyaw.bodyyawadd:depend({
			menu.builder.team,
			"ct"
		}, custom_aa[i].bodyyaw, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, custom_aa[i].bodyyaw, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].bodyyaw.bodyyawaddr:depend({
			menu.builder.team,
			"ct"
		}, custom_aa[i].bodyyaw, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, custom_aa[i].bodyyaw, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].defensive:depend({
			menu["anti-aim"].preset,
			"anti-aim"
		}, {
			menu.builder.team,
			"ct"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].defensive.defensive_yaw:depend({
			menu["anti-aim"].preset,
			"anti-aim"
		}, {
			menu.builder.team,
			"ct"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, custom_aa[i].defensive, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].defensive.defensive_pitch:depend({
			menu["anti-aim"].preset,
			"anti-aim"
		}, {
			menu.builder.team,
			"ct"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, custom_aa[i].defensive, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].defensive.pitch_amount_2:depend({
			custom_aa[i].defensive.defensive_pitch,
			"random"
		}, {
			menu.builder.team,
			"ct"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, custom_aa[i].defensive, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa[i].defensive.pitch_amount:depend({
			custom_aa[i].defensive.defensive_pitch,
			"custom",
			"random"
		}, {
			menu.builder.team,
			"ct"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa[i].enable, {
			menu.builder.condition,
			anti_aim_states[i]
		}, custom_aa[i].defensive, {
			menu["anti-aim"].features,
			"builder"
		});
	end;
	for i = 1, #anti_aim_states_t do
		custom_aa_t[i].enable:depend({
			menu["anti-aim"].preset,
			"anti-aim"
		}, {
			menu.builder.team,
			"t"
		}, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].pitch:depend({
			menu["anti-aim"].preset,
			"anti-aim"
		}, {
			menu.builder.team,
			"t"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].yaw_type:depend({
			menu.builder.team,
			"t"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].yaw_type.yawaddl:depend({
			menu.builder.team,
			"t"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, {
			custom_aa_t[i].yaw_type,
			"l&r"
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].yaw_type.yawaddr:depend({
			menu.builder.team,
			"t"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, {
			custom_aa_t[i].yaw_type,
			"l&r"
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].yaw_type.yaw_value:depend({
			menu.builder.team,
			"t"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, {
			custom_aa_t[i].yaw_type,
			"default"
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].yawjitter:depend({
			menu.builder.team,
			"t"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].yawjitter.yawjitteradd:depend({
			menu.builder.team,
			"t"
		}, {
			custom_aa_t[i].yawjitter,
			"center",
			"offset",
			"random"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, {
			custom_aa_t[i].yawjitter,
			function()
				if custom_aa_t[i].yawjitter:get() ~= "Off" then
					return true;
				else
					return false;
				end;
			end
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].bodyyaw:depend({
			menu.builder.team,
			"t"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].bodyyaw.options:depend({
			menu.builder.team,
			"t"
		}, custom_aa_t[i].bodyyaw, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, custom_aa_t[i].bodyyaw, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].bodyyaw.bodyyawadd:depend({
			menu.builder.team,
			"t"
		}, custom_aa_t[i].bodyyaw, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, custom_aa_t[i].bodyyaw, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].bodyyaw.bodyyawaddr:depend({
			menu.builder.team,
			"t"
		}, custom_aa_t[i].bodyyaw, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, custom_aa_t[i].bodyyaw, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].defensive:depend({
			menu.builder.team,
			"t"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].defensive.defensive_yaw:depend({
			menu.builder.team,
			"t"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, custom_aa_t[i].defensive, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].defensive.defensive_pitch:depend({
			menu.builder.team,
			"t"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, custom_aa_t[i].defensive, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].defensive.pitch_amount_2:depend({
			menu.builder.team,
			"t"
		}, {
			custom_aa_t[i].defensive.defensive_pitch,
			"random"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, custom_aa_t[i].defensive, {
			menu["anti-aim"].features,
			"builder"
		});
		custom_aa_t[i].defensive.pitch_amount:depend({
			menu.builder.team,
			"t"
		}, {
			custom_aa_t[i].defensive.defensive_pitch,
			"custom",
			"random"
		}, {
			menu["anti-aim"].preset,
			"anti-aim"
		}, custom_aa_t[i].enable, {
			menu.builder.condition_t,
			anti_aim_states_t[i]
		}, custom_aa_t[i].defensive, {
			menu["anti-aim"].features,
			"builder"
		});
	end;
end;
helpers.functions = {
	bold_font = render.load_font("Verdana Bold", 11, "ad"),
	large_bold_verdana = render.load_font("verdana", 20, "abd"),
	defensive_ticks = 0,
	skeet_logs = {},
	time = globals.realtime,
	width = smoothy.new(0),
	side = 0,
	prev_side = 0,
	canbepressed = true,
	damage_anim = 0,
	is_backstab = false,
	aspectratio_value = 0,
	contains = function(self, inputString)
		if type(inputString) == "string" then
			if string.find(inputString, "%s") ~= nil and string.find(inputString, "%S") ~= nil then
				local hasSpace = string.find(inputString, "%s") ~= nil;
				local hasCharacters = string.find(inputString, "%S") ~= nil;
				return hasSpace and hasCharacters;
			elseif string.find(inputString, "%s") == nil and string.find(inputString, "%S") ~= nil then
				local hasSpace = string.find(inputString, "%s") == nil;
				local hasCharacters = string.find(inputString, "%S") ~= nil;
				return hasSpace and hasCharacters;
			else
				return false;
			end;
		else
			return false;
		end;
	end,
	lerp2 = function(self, x, v, t)
		if type(x) == "table" then
			return self:lerp2(x[1], v[1], t), self:lerp2(x[2], v[2], t), self:lerp2(x[3], v[3], t), self:lerp2(x[4], v[4], t);
		end;
		local delta = v - x;
		if type(delta) == "number" then
			if math.abs(delta) < 0.005 then
				return v;
			end;
		end;
		return delta * t + x;
	end,
	animations = (function()
		local a = {
			data = {}
		};
		function a:clamp(b, c, d)
			return math.min(d, math.max(c, b));
		end;
		function a:animate(e, f, g)
			if not self.data[e] then
				self.data[e] = 0;
			end;
			g = g or 4;
			local b = globals.frametime * g * (f and (-1) or 1);
			self.data[e] = self:clamp(self.data[e] + b, 0, 1);
			return self.data[e];
		end;
		return a;
	end)(),
	lerp = function(self, name, value, speed)
		return name + (value - name) * globals.frametime * speed;
	end,
	log = function(self, string)
		if not string.match(string, "" .. lua_name .. " ~") and (not string.match(string, "" .. lua_name .. " ~")) and (not string.match(string, "Knifed for damage")) and (not string.match(string, "Burned for damage")) and (not string.match(string, "Naded for damage")) then
		end;
		table.insert(self.skeet_logs, {
			message = string,
			alpha = 0,
			creation_time = globals.realtime
		});
	end,
	isLeapYear = function(self, year)
		return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0);
	end,
	reset_asp = function(self)
		menu.settings.aspectratio.offset:set(0);
		cvar.r_aspectratio:float(0);
	end,
	reset_view = function(self)
		menu.settings.viewmodel.fov:set(68);
		menu.settings.viewmodel.x:set(25);
		menu.settings.viewmodel.y:set(0);
		menu.settings.viewmodel.z:set(-15);
	end,
	ratio = function(self, val1, val2)
		menu.settings.aspectratio.offset:set(math.floor(val1 / val2 * 100));
	end,
	prop_get = function(self, ent, prop_name, idx)
		if type(ent) == "number" then
			ent = entity.get(ent);
		end;
		if not ent or ent == nil then
			return;
		end;
		if idx ~= nil then
			if type(ent[prop_name][idx]) == "userdata" then
				if ent[prop_name][idx].x ~= nil and ent[prop_name][idx].y ~= nil then
					return ent[prop_name][idx]:unpack();
				end;
			end;
			local l = ent[prop_name][idx];
			return type(l) == "boolean" and (l and 1 or 0) or l;
		else
			if type(ent[prop_name]) == "userdata" then
				if ent[prop_name].x ~= nil and ent[prop_name].y ~= nil then
					return ent[prop_name]:unpack();
				end;
			end;
			return prop_name == "m_iItemDefinitionIndex" and bit.band(ent.m_iItemDefinitionIndex, 65535) or type(ent[prop_name]) == "boolean" and (ent[prop_name] and 1 or 0) or ent[prop_name];
		end;
	end,
	manualaa = function(self)
		self.canbepressed = self.time + 0.2 < globals.realtime;
		if menu["anti-aim"].features_select:get("manual aa") and menu["anti-aim"].manual_left:get() and self.canbepressed then
			references.dtopt:override("On Peek");
			references.hidden:override(false);
			self.side = 1;
			if self.prev_side == self.side then
				self.side = 0;
			end;
			self.time = globals.realtime;
		end;
		if menu["anti-aim"].features_select:get("manual aa") and menu["anti-aim"].manual_right:get() and self.canbepressed then
			references.dtopt:override("On Peek");
			references.hidden:override(false);
			self.side = 2;
			if self.prev_side == self.side then
				self.side = 0;
			end;
			self.time = globals.realtime;
		end;
		self.prev_side = self.side;
		if self.side == 1 then
			return 1;
		end;
		if self.side == 2 then
			return 2;
		end;
		if self.side == 0 then
			return 0;
		end;
	end,
	is_defensive = function(self, index)
		self.defensive_ticks = math.max(self:prop_get(index, "m_nTickBase"), self.defensive_ticks or 0);
		return math.abs(self:prop_get(index, "m_nTickBase") - self.defensive_ticks) > 2 and math.abs(self:prop_get(index, "m_nTickBase") - self.defensive_ticks) < 14;
	end,
	upper_log = function(self)
		if not menu.settings.logs:get() then
			return;
		end;
		local timeNow = globals.realtime;
		local distance_to_add = 0;
		local last_render_position = 0;
		for i = 1, #self.skeet_logs do
			if not (self.skeet_logs[i] == nil) then
				if self.skeet_logs[i].creation_time > timeNow or self.skeet_logs[i].alpha <= 0 and timeNow - self.skeet_logs[i].creation_time > 2 then
					table.remove(self.skeet_logs, i);
				else
					if i >= 55 then
						self.skeet_logs[i].creation_time = timeNow;
					end;
					if self.skeet_logs[i].alpha < 255 and timeNow - self.skeet_logs[i].creation_time < 5 and i < 55 then
						self.skeet_logs[i].alpha = self.skeet_logs[i].alpha + 5;
					end;
					if timeNow - self.skeet_logs[i].creation_time > 5 and self.skeet_logs[i].alpha > 0 then
						self.skeet_logs[i].alpha = self.skeet_logs[i].alpha - 5;
					end;
					if self.skeet_logs[i].alpha > 0 then
						local distance_modifier = self.skeet_logs[i].alpha / 255;
						render.text(self.bold_font, vector(5, last_render_position + distance_to_add), color(255, 255, 255, self.skeet_logs[i].alpha), "s", self.skeet_logs[i].message);
						last_render_position = last_render_position + distance_to_add;
						distance_to_add = 15 * distance_modifier;
					end;
				end;
			end;
		end;
	end,
	getsecondsInMonth = function(self, year, month)
		local daysInMonth = {
			31,
			28,
			31,
			30,
			31,
			30,
			31,
			31,
			30,
			31,
			30,
			31
		};
		if month == 2 and self:isLeapYear(year) then
			return 29 * 24 * 60 * 60;
		else
			return daysInMonth[month] * 24 * 60 * 60;
		end;
	end,
	convertToUnixTime = function(self, dateString)
		local year, month, day, hour, minute, seplayer_state = dateString:match("(%d+)-(%d+)-(%d+)%s(%d+):(%d+):(%d+)");
		local seconds = 0;
		for y = 1970, year - 1 do
			seconds = seconds + 365 * 24 * 60 * 60;
			if self:isLeapYear(y) then
				seconds = seconds + 24 * 60 * 60;
			end;
		end;
		for m = 1, month - 1 do
			seconds = seconds + self:getsecondsInMonth(year, m);
		end;
		seconds = seconds + (day - 1.13) * 24 * 60 * 60;
		seconds = seconds + (hour + 0.13) * 60 * 60 + minute * 60 + seplayer_state - 36;
		return seconds;
	end,
	rgba_to_hex = function(self, b, c, d, e)
		return string.format("%02x%02x%02x%02x", b, c, d, e);
	end,
	animate_text = function(self, time, string, r, g, b, a)
		local t_out, t_out_iter = {}, 1;
		local l = string:len() - 1;
		local r_add = (menu.settings.watermark.color2:get()).r - r;
		local g_add = (menu.settings.watermark.color2:get()).g - g;
		local b_add = (menu.settings.watermark.color2:get()).b - b;
		for i = 1, #string do
			local iter = (i - 1) / ((#string) - 1) + time;
			t_out[t_out_iter] = "\a" .. self:rgba_to_hex(r + r_add * math.abs(math.cos(iter)), g + g_add * math.abs(math.cos(iter)), b + b_add * math.abs(math.cos(iter)), a);
			t_out[t_out_iter + 1] = string:sub(i, i);
			t_out_iter = t_out_iter + 2;
		end;
		return t_out;
	end
};
functions.config_system = {
	Delete = function(self)
		if menu.configs.List:get() ~= 1 then
			table.remove(database.name, menu.configs.List:get());
			table.remove(database.config, menu.configs.List:get());
			table.remove(database.config_t, menu.configs.List:get());
			table.remove(database.date, menu.configs.List:get());
			files.write("nl/" .. lua_name .. "/data.txt", json.stringify(database));
			menu.configs.List:update(database.name);
			helpers.functions:log("\ac3c6ffff" .. lua_name .. " ~ \ac8c8c8ffpreset deleted.");
			print_raw("\ac3c6ffff" .. lua_name .. " ~ \ac8c8c8ff\apreset deleted.");
		else
			helpers.functions:log("\affafafff" .. lua_name .. " ~ \ac8c8c8ffdefault config cant be deleted.");
			print_raw("\affafafff" .. lua_name .. " ~ \ac8c8c8ff\adefault config cant be deleted.");
		end;
	end,
	Load = function(self)
		if menu.configs.List:get() == 1 then
			(pui.setup({
				custom_aa
			}, true)):load(json.parse(base64.decode("W1t7ImJvZHl5YXciOnRydWUsImRlZmVuc2l2ZSI6ZmFsc2UsImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJkb3duIiwieWF3X3R5cGUiOiJsJnIiLCJ5YXdqaXR0ZXIiOiJvZmYiLCJ+Ym9keXlhdyI6eyJib2R5eWF3YWRkIjo2MC4wLCJib2R5eWF3YWRkciI6NjAuMCwib3B0aW9ucyI6ImppdHRlciJ9LCJ+ZGVmZW5zaXZlIjp7ImRlZmVuc2l2ZV9waXRjaCI6ImRpc2FibGVkIiwiZGVmZW5zaXZlX3lhdyI6Im9mZiIsInBpdGNoX2Ftb3VudCI6LTQ5LjAsInBpdGNoX2Ftb3VudF8yIjotNDkuMH0sIn55YXdfdHlwZSI6eyJ5YXdfdmFsdWUiOjAuMCwieWF3YWRkbCI6LTMzLjAsInlhd2FkZHIiOjM4LjB9LCJ+eWF3aml0dGVyIjp7Inlhd2ppdHRlcmFkZCI6MC4wfX0seyJib2R5eWF3Ijp0cnVlLCJkZWZlbnNpdmUiOmZhbHNlLCJlbmFibGUiOnRydWUsInBpdGNoIjoiZG93biIsInlhd190eXBlIjoibCZyIiwieWF3aml0dGVyIjoib2ZmIiwifmJvZHl5YXciOnsiYm9keXlhd2FkZCI6NjAuMCwiYm9keXlhd2FkZHIiOjYwLjAsIm9wdGlvbnMiOiJqaXR0ZXIifSwifmRlZmVuc2l2ZSI6eyJkZWZlbnNpdmVfcGl0Y2giOiJkaXNhYmxlZCIsImRlZmVuc2l2ZV95YXciOiJvZmYiLCJwaXRjaF9hbW91bnQiOi00OS4wLCJwaXRjaF9hbW91bnRfMiI6LTQ5LjB9LCJ+eWF3X3R5cGUiOnsieWF3X3ZhbHVlIjowLjAsInlhd2FkZGwiOi0zMy4wLCJ5YXdhZGRyIjozOC4wfSwifnlhd2ppdHRlciI6eyJ5YXdqaXR0ZXJhZGQiOjAuMH19LHsiYm9keXlhdyI6dHJ1ZSwiZGVmZW5zaXZlIjpmYWxzZSwiZW5hYmxlIjp0cnVlLCJwaXRjaCI6ImRvd24iLCJ5YXdfdHlwZSI6ImwmciIsInlhd2ppdHRlciI6ImNlbnRlciIsIn5ib2R5eWF3Ijp7ImJvZHl5YXdhZGQiOjYwLjAsImJvZHl5YXdhZGRyIjo2MC4wLCJvcHRpb25zIjoiaml0dGVyIn0sIn5kZWZlbnNpdmUiOnsiZGVmZW5zaXZlX3BpdGNoIjoiZGlzYWJsZWQiLCJkZWZlbnNpdmVfeWF3Ijoib2ZmIiwicGl0Y2hfYW1vdW50IjotNDkuMCwicGl0Y2hfYW1vdW50XzIiOi00OS4wfSwifnlhd190eXBlIjp7Inlhd192YWx1ZSI6MC4wLCJ5YXdhZGRsIjotMzMuMCwieWF3YWRkciI6MjIuMH0sIn55YXdqaXR0ZXIiOnsieWF3aml0dGVyYWRkIjotMjcuMH19LHsiYm9keXlhdyI6dHJ1ZSwiZGVmZW5zaXZlIjp0cnVlLCJlbmFibGUiOnRydWUsInBpdGNoIjoiZG93biIsInlhd190eXBlIjoibCZyIiwieWF3aml0dGVyIjoib2ZmIiwifmJvZHl5YXciOnsiYm9keXlhd2FkZCI6NjAuMCwiYm9keXlhd2FkZHIiOjYwLjAsIm9wdGlvbnMiOiJqaXR0ZXIifSwifmRlZmVuc2l2ZSI6eyJkZWZlbnNpdmVfcGl0Y2giOiJkb3duIiwiZGVmZW5zaXZlX3lhdyI6Im9mZiIsInBpdGNoX2Ftb3VudCI6LTg5LjAsInBpdGNoX2Ftb3VudF8yIjo4OS4wfSwifnlhd190eXBlIjp7Inlhd192YWx1ZSI6MC4wLCJ5YXdhZGRsIjotNDQuMCwieWF3YWRkciI6MzMuMH0sIn55YXdqaXR0ZXIiOnsieWF3aml0dGVyYWRkIjowLjB9fSx7ImJvZHl5YXciOnRydWUsImRlZmVuc2l2ZSI6dHJ1ZSwiZW5hYmxlIjp0cnVlLCJwaXRjaCI6ImRvd24iLCJ5YXdfdHlwZSI6ImwmciIsInlhd2ppdHRlciI6ImNlbnRlciIsIn5ib2R5eWF3Ijp7ImJvZHl5YXdhZGQiOjYwLjAsImJvZHl5YXdhZGRyIjo2MC4wLCJvcHRpb25zIjoiaml0dGVyIn0sIn5kZWZlbnNpdmUiOnsiZGVmZW5zaXZlX3BpdGNoIjoiZG93biIsImRlZmVuc2l2ZV95YXciOiJvZmYiLCJwaXRjaF9hbW91bnQiOi00OS4wLCJwaXRjaF9hbW91bnRfMiI6ODkuMH0sIn55YXdfdHlwZSI6eyJ5YXdfdmFsdWUiOjAuMCwieWF3YWRkbCI6LTM4LjAsInlhd2FkZHIiOjM4LjB9LCJ+eWF3aml0dGVyIjp7Inlhd2ppdHRlcmFkZCI6MTQuMH19LHsiYm9keXlhdyI6dHJ1ZSwiZGVmZW5zaXZlIjp0cnVlLCJlbmFibGUiOnRydWUsInBpdGNoIjoiZG93biIsInlhd190eXBlIjoibCZyIiwieWF3aml0dGVyIjoiY2VudGVyIiwifmJvZHl5YXciOnsiYm9keXlhd2FkZCI6NjAuMCwiYm9keXlhd2FkZHIiOjYwLjAsIm9wdGlvbnMiOiJqaXR0ZXIifSwifmRlZmVuc2l2ZSI6eyJkZWZlbnNpdmVfcGl0Y2giOiJkb3duIiwiZGVmZW5zaXZlX3lhdyI6Im9mZiIsInBpdGNoX2Ftb3VudCI6LTQ5LjAsInBpdGNoX2Ftb3VudF8yIjo4OS4wfSwifnlhd190eXBlIjp7Inlhd192YWx1ZSI6MC4wLCJ5YXdhZGRsIjotMzguMCwieWF3YWRkciI6MzguMH0sIn55YXdqaXR0ZXIiOnsieWF3aml0dGVyYWRkIjowLjB9fSx7ImJvZHl5YXciOnRydWUsImRlZmVuc2l2ZSI6dHJ1ZSwiZW5hYmxlIjp0cnVlLCJwaXRjaCI6ImRvd24iLCJ5YXdfdHlwZSI6ImRlZmF1bHQiLCJ5YXdqaXR0ZXIiOiJvZmYiLCJ+Ym9keXlhdyI6eyJib2R5eWF3YWRkIjo2MC4wLCJib2R5eWF3YWRkciI6NjAuMCwib3B0aW9ucyI6Im9mZiJ9LCJ+ZGVmZW5zaXZlIjp7ImRlZmVuc2l2ZV9waXRjaCI6ImRvd24iLCJkZWZlbnNpdmVfeWF3Ijoib2ZmIiwicGl0Y2hfYW1vdW50IjotNDkuMCwicGl0Y2hfYW1vdW50XzIiOi00OS4wfSwifnlhd190eXBlIjp7Inlhd192YWx1ZSI6MC4wLCJ5YXdhZGRsIjowLjAsInlhd2FkZHIiOjAuMH0sIn55YXdqaXR0ZXIiOnsieWF3aml0dGVyYWRkIjowLjB9fSx7ImJvZHl5YXciOnRydWUsImRlZmVuc2l2ZSI6ZmFsc2UsImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJkb3duIiwieWF3X3R5cGUiOiJsJnIiLCJ5YXdqaXR0ZXIiOiJvZmYiLCJ+Ym9keXlhdyI6eyJib2R5eWF3YWRkIjo2MC4wLCJib2R5eWF3YWRkciI6NjAuMCwib3B0aW9ucyI6ImppdHRlciJ9LCJ+ZGVmZW5zaXZlIjp7ImRlZmVuc2l2ZV9waXRjaCI6ImRpc2FibGVkIiwiZGVmZW5zaXZlX3lhdyI6Im9mZiIsInBpdGNoX2Ftb3VudCI6LTQ5LjAsInBpdGNoX2Ftb3VudF8yIjotNDkuMH0sIn55YXdfdHlwZSI6eyJ5YXdfdmFsdWUiOjAuMCwieWF3YWRkbCI6LTM4LjAsInlhd2FkZHIiOjM4LjB9LCJ+eWF3aml0dGVyIjp7Inlhd2ppdHRlcmFkZCI6MC4wfX1dXQ==")));
			(pui.setup({
				custom_aa_t
			}, true)):load(json.parse(base64.decode("W1t7ImJvZHl5YXciOnRydWUsImRlZmVuc2l2ZSI6ZmFsc2UsImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJkb3duIiwieWF3X3R5cGUiOiJkZWZhdWx0IiwieWF3aml0dGVyIjoiY2VudGVyIiwifmJvZHl5YXciOnsiYm9keXlhd2FkZCI6NjAuMCwiYm9keXlhd2FkZHIiOjYwLjAsIm9wdGlvbnMiOiJqaXR0ZXIifSwifmRlZmVuc2l2ZSI6eyJkZWZlbnNpdmVfcGl0Y2giOiJkaXNhYmxlZCIsImRlZmVuc2l2ZV95YXciOiJvZmYiLCJwaXRjaF9hbW91bnQiOi00OS4wLCJwaXRjaF9hbW91bnRfMiI6LTQ5LjB9LCJ+eWF3X3R5cGUiOnsieWF3X3ZhbHVlIjowLjAsInlhd2FkZGwiOjAuMCwieWF3YWRkciI6MC4wfSwifnlhd2ppdHRlciI6eyJ5YXdqaXR0ZXJhZGQiOi03MS4wfX0seyJib2R5eWF3Ijp0cnVlLCJkZWZlbnNpdmUiOmZhbHNlLCJlbmFibGUiOnRydWUsInBpdGNoIjoiZG93biIsInlhd190eXBlIjoibCZyIiwieWF3aml0dGVyIjoib2ZmIiwifmJvZHl5YXciOnsiYm9keXlhd2FkZCI6NjAuMCwiYm9keXlhd2FkZHIiOjYwLjAsIm9wdGlvbnMiOiJqaXR0ZXIifSwifmRlZmVuc2l2ZSI6eyJkZWZlbnNpdmVfcGl0Y2giOiJkaXNhYmxlZCIsImRlZmVuc2l2ZV95YXciOiJvZmYiLCJwaXRjaF9hbW91bnQiOi00OS4wLCJwaXRjaF9hbW91bnRfMiI6LTQ5LjB9LCJ+eWF3X3R5cGUiOnsieWF3X3ZhbHVlIjowLjAsInlhd2FkZGwiOi0zOC4wLCJ5YXdhZGRyIjozOC4wfSwifnlhd2ppdHRlciI6eyJ5YXdqaXR0ZXJhZGQiOjAuMH19LHsiYm9keXlhdyI6dHJ1ZSwiZGVmZW5zaXZlIjpmYWxzZSwiZW5hYmxlIjp0cnVlLCJwaXRjaCI6ImRvd24iLCJ5YXdfdHlwZSI6ImwmciIsInlhd2ppdHRlciI6ImNlbnRlciIsIn5ib2R5eWF3Ijp7ImJvZHl5YXdhZGQiOjYwLjAsImJvZHl5YXdhZGRyIjo2MC4wLCJvcHRpb25zIjoiaml0dGVyIn0sIn5kZWZlbnNpdmUiOnsiZGVmZW5zaXZlX3BpdGNoIjoiZGlzYWJsZWQiLCJkZWZlbnNpdmVfeWF3Ijoib2ZmIiwicGl0Y2hfYW1vdW50IjotNDkuMCwicGl0Y2hfYW1vdW50XzIiOi00OS4wfSwifnlhd190eXBlIjp7Inlhd192YWx1ZSI6MC4wLCJ5YXdhZGRsIjotMzguMCwieWF3YWRkciI6NDkuMH0sIn55YXdqaXR0ZXIiOnsieWF3aml0dGVyYWRkIjoxMS4wfX0seyJib2R5eWF3Ijp0cnVlLCJkZWZlbnNpdmUiOnRydWUsImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJkb3duIiwieWF3X3R5cGUiOiJsJnIiLCJ5YXdqaXR0ZXIiOiJjZW50ZXIiLCJ+Ym9keXlhdyI6eyJib2R5eWF3YWRkIjo2MC4wLCJib2R5eWF3YWRkciI6NjAuMCwib3B0aW9ucyI6ImppdHRlciJ9LCJ+ZGVmZW5zaXZlIjp7ImRlZmVuc2l2ZV9waXRjaCI6ImRvd24iLCJkZWZlbnNpdmVfeWF3Ijoib2ZmIiwicGl0Y2hfYW1vdW50IjotODkuMCwicGl0Y2hfYW1vdW50XzIiOjg5LjB9LCJ+eWF3X3R5cGUiOnsieWF3X3ZhbHVlIjowLjAsInlhd2FkZGwiOi00NC4wLCJ5YXdhZGRyIjozMy4wfSwifnlhd2ppdHRlciI6eyJ5YXdqaXR0ZXJhZGQiOjguMH19LHsiYm9keXlhdyI6dHJ1ZSwiZGVmZW5zaXZlIjp0cnVlLCJlbmFibGUiOnRydWUsInBpdGNoIjoiZG93biIsInlhd190eXBlIjoiZGVmYXVsdCIsInlhd2ppdHRlciI6Im9mZnNldCIsIn5ib2R5eWF3Ijp7ImJvZHl5YXdhZGQiOjYwLjAsImJvZHl5YXdhZGRyIjo2MC4wLCJvcHRpb25zIjoiaml0dGVyIn0sIn5kZWZlbnNpdmUiOnsiZGVmZW5zaXZlX3BpdGNoIjoiZG93biIsImRlZmVuc2l2ZV95YXciOiJvZmYiLCJwaXRjaF9hbW91bnQiOi00OS4wLCJwaXRjaF9hbW91bnRfMiI6ODkuMH0sIn55YXdfdHlwZSI6eyJ5YXdfdmFsdWUiOjAuMCwieWF3YWRkbCI6MC4wLCJ5YXdhZGRyIjowLjB9LCJ+eWF3aml0dGVyIjp7Inlhd2ppdHRlcmFkZCI6MC4wfX0seyJib2R5eWF3Ijp0cnVlLCJkZWZlbnNpdmUiOnRydWUsImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJkb3duIiwieWF3X3R5cGUiOiJsJnIiLCJ5YXdqaXR0ZXIiOiJjZW50ZXIiLCJ+Ym9keXlhdyI6eyJib2R5eWF3YWRkIjo2MC4wLCJib2R5eWF3YWRkciI6NjAuMCwib3B0aW9ucyI6ImppdHRlciJ9LCJ+ZGVmZW5zaXZlIjp7ImRlZmVuc2l2ZV9waXRjaCI6ImRvd24iLCJkZWZlbnNpdmVfeWF3Ijoib2ZmIiwicGl0Y2hfYW1vdW50IjotNDkuMCwicGl0Y2hfYW1vdW50XzIiOjg5LjB9LCJ+eWF3X3R5cGUiOnsieWF3X3ZhbHVlIjowLjAsInlhd2FkZGwiOi0zOC4wLCJ5YXdhZGRyIjozOC4wfSwifnlhd2ppdHRlciI6eyJ5YXdqaXR0ZXJhZGQiOjMzLjB9fSx7ImJvZHl5YXciOnRydWUsImRlZmVuc2l2ZSI6dHJ1ZSwiZW5hYmxlIjp0cnVlLCJwaXRjaCI6ImRvd24iLCJ5YXdfdHlwZSI6ImRlZmF1bHQiLCJ5YXdqaXR0ZXIiOiJvZmYiLCJ+Ym9keXlhdyI6eyJib2R5eWF3YWRkIjo2MC4wLCJib2R5eWF3YWRkciI6NjAuMCwib3B0aW9ucyI6Im9mZiJ9LCJ+ZGVmZW5zaXZlIjp7ImRlZmVuc2l2ZV9waXRjaCI6ImRvd24iLCJkZWZlbnNpdmVfeWF3Ijoib2ZmIiwicGl0Y2hfYW1vdW50IjotNDkuMCwicGl0Y2hfYW1vdW50XzIiOi00OS4wfSwifnlhd190eXBlIjp7Inlhd192YWx1ZSI6MC4wLCJ5YXdhZGRsIjowLjAsInlhd2FkZHIiOjAuMH0sIn55YXdqaXR0ZXIiOnsieWF3aml0dGVyYWRkIjowLjB9fSx7ImJvZHl5YXciOnRydWUsImRlZmVuc2l2ZSI6ZmFsc2UsImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJkb3duIiwieWF3X3R5cGUiOiJsJnIiLCJ5YXdqaXR0ZXIiOiJjZW50ZXIiLCJ+Ym9keXlhdyI6eyJib2R5eWF3YWRkIjo2MC4wLCJib2R5eWF3YWRkciI6NjAuMCwib3B0aW9ucyI6ImppdHRlciJ9LCJ+ZGVmZW5zaXZlIjp7ImRlZmVuc2l2ZV9waXRjaCI6ImRpc2FibGVkIiwiZGVmZW5zaXZlX3lhdyI6Im9mZiIsInBpdGNoX2Ftb3VudCI6LTQ5LjAsInBpdGNoX2Ftb3VudF8yIjotNDkuMH0sIn55YXdfdHlwZSI6eyJ5YXdfdmFsdWUiOjAuMCwieWF3YWRkbCI6LTM4LjAsInlhd2FkZHIiOjM4LjB9LCJ+eWF3aml0dGVyIjp7Inlhd2ppdHRlcmFkZCI6MzguMH19XV0=")));
		else
			(pui.setup({
				custom_aa
			}, true)):load(json.parse(base64.decode(database.config[menu.configs.List:get()])));
			(pui.setup({
				custom_aa_t
			}, true)):load(json.parse(base64.decode(database.config_t[menu.configs.List:get()])));
		end;
		helpers.functions:log("\ac3c6ffff" .. lua_name .. " ~ \ac8c8c8ffsucessfully loaded the preset.");
		print_raw("\ac3c6ffff" .. lua_name .. " ~ \ac8c8c8ff\asucessfully loaded the preset.");
	end,
	Save = function(self)
		if menu.configs.List:get() ~= 1 then
			database.config[menu.configs.List:get()] = base64.encode(json.stringify((pui.setup({
				custom_aa
			}, true)):save()));
			database.config_t[menu.configs.List:get()] = base64.encode(json.stringify((pui.setup({
				custom_aa_t
			}, true)):save()));
			database.date[menu.configs.List:get()] = common.get_date("20%y-%m-%d %H:%M:%S");
			files.write("nl/" .. lua_name .. "/data.txt", json.stringify(database));
			helpers.functions:log("\ac3c6ffff" .. lua_name .. " ~ \ac8c8c8ffpreset saved.");
			print_raw("\ac3c6ffff" .. lua_name .. " ~ \ac8c8c8ff\apreset saved.");
		else
			helpers.functions:log("\affafafff" .. lua_name .. " ~ \ac8c8c8ffdefault config cant be saved.");
			print_raw("\affafafff" .. lua_name .. " ~ \ac8c8c8ff\adefault config cant be saved.");
		end;
	end,
	Create = function(self)
		local cfg = base64.encode(json.stringify((pui.setup({
			custom_aa
		}, true)):save()));
		local cfg_t = base64.encode(json.stringify((pui.setup({
			custom_aa_t
		}, true)):save()));
		local name = menu.configs.Name:get();
		if helpers.functions:contains(name) and database.name ~= name then
			table.insert(database.name, name);
			table.insert(database.config, cfg);
			table.insert(database.config_t, cfg_t);
			table.insert(database.date, common.get_date("20%y-%m-%d %H:%M:%S"));
			files.write("nl/" .. lua_name .. "/data.txt", json.stringify(database));
			helpers.functions:log("\ac3c6ffff" .. lua_name .. " ~ \ac8c8c8ffpreset created.");
			print_raw("\ac3c6ffff" .. lua_name .. " ~ \ac8c8c8ff\apreset created.");
		else
			helpers.functions:log("\affafafff" .. lua_name .. " ~ \ac8c8c8ffconfig name is nil.");
			print_raw("\affafafff" .. lua_name .. " ~ \ac8c8c8ff\aconfig name is nil.");
		end;
		menu.configs.List:update(database.name);
	end,
	Export = function(self)
		if menu.configs.List:get() ~= 1 then
			local config = base64.encode(json.stringify((pui.setup({
				custom_aa
			}, true)):save()));
			local config2 = base64.encode(json.stringify((pui.setup({
				custom_aa_t
			}, true)):save()));
			Clipboard.set(json.stringify({
				n = database.name[menu.configs.List:get()],
				cfg = config,
				cfg2 = config2,
				date = common.get_date("20%y-%m-%d %H:%M:%S")
			}));
			helpers.functions:log("\ac3c6ffff" .. lua_name .. " ~ \ac8c8c8ffexported settings to clipboard.");
			print_raw("\ac3c6ffff" .. lua_name .. " ~ \ac8c8c8ff\aexported settings to clipboard.");
		else
			helpers.functions:log("\ac3c6ffff" .. lua_name .. " ~ \ac8c8c8ffdefault config cant be exported.");
			print_raw("\affafafff" .. lua_name .. " ~ \ac8c8c8ff\adefault config cant be exported.");
		end;
	end,
	Import = function(self)
		local imported_cfg = json.parse(Clipboard.get());
		table.insert(database.name, imported_cfg.n);
		table.insert(database.config, imported_cfg.cfg);
		table.insert(database.config_t, imported_cfg.cfg2);
		table.insert(database.date, imported_cfg.date);
		menu.configs.List:update(database.name);
		files.write("nl/" .. lua_name .. "/data.txt", json.stringify(database));
		helpers.functions:log("\ac3c6ffff" .. lua_name .. " ~ \ac8c8c8ffsucessfully imported the preset.");
		print_raw("\ac3c6ffff" .. lua_name .. " ~ \ac8c8c8ff\asucessfully imported the preset.");
	end
};
functions.setup = {
	nofall = function(self, c)
		if not menu.settings.nofalldamage:get() then
			return;
		end;
		local is_on_ground = bit.band(helpers.functions:prop_get(entity.get_local_player(), "m_fFlags"), 1) == 1 and c.in_jump == false;
		local lp = entity.get_local_player();
		local vec = lp.m_vecVelocity;
		local origin = lp.m_vecOrigin;
		local tracer = utils.trace_line(origin, vector(origin.x, origin.y, origin.z - 500), nil, nil, 1);
		if origin.z - tracer.end_pos.z <= 70 and origin.z - tracer.end_pos.z >= 12 and (not is_on_ground) and vec.z < (-450) then
			c.in_duck = true;
		end;
	end,
	condition_get = function(self, c)
		local vx, vy, vz = helpers.functions:prop_get(entity.get_local_player(), "m_vecVelocity");
		local lp_vel = math.sqrt(vx * vx + vy * vy + vz * vz);
		local on_ground = bit.band(helpers.functions:prop_get(entity.get_local_player(), "m_fFlags"), 1) == 1 and c.in_jump == false;
		local is_crouching = bit.band(helpers.functions:prop_get(entity.get_local_player(), "m_fFlags"), 4) == 4;
		local p_slow = references.slowwalk:get();
		local is_knife = ((entity.get_local_player()):get_player_weapon()):get_classname() == "CKnife" and (not on_ground) and is_crouching or ((entity.get_local_player()):get_player_weapon()):get_classname() == "CKnife" and on_ground and is_crouching;
		local weapon_index = ((entity.get_local_player()):get_player_weapon()):get_weapon_index();
		local teams = (entity.get_local_player()).m_iTeamNum;
		local is_grenade = weapon_index == 43 or weapon_index == 44 or weapon_index == 45 or weapon_index == 46 or weapon_index == 47 or weapon_index == 48;
		if is_grenade then
			player_state = 8;
		elseif is_knife then
			player_state = 7;
		elseif on_ground and is_crouching or references.fakeduck:get() then
			player_state = 4;
		elseif c.in_duck == true and (not on_ground) then
			player_state = 6;
		elseif not on_ground and c.in_duck == false then
			player_state = 5;
		elseif p_slow then
			player_state = 3;
		elseif lp_vel > 5 then
			player_state = 2;
		elseif lp_vel < 5 then
			player_state = 1;
		end;
	end,
	defensive_cmd = function(self, c)
		if helpers.functions:manualaa() ~= 0 then
			return;
		end;
		if not references.dt:get() then
			return;
		end;
		local teams = helpers.functions:prop_get(entity.get_local_player(), "m_iTeamNum");
		if teams == 2 and references.fs:get() == false and custom_aa_t[player_state].defensive:get() and custom_aa_t[player_state].enable:get() and menu["anti-aim"].features:get() == "builder" then
			references.dtopt:override("Always On");
			references.hidden:override(true);
		elseif teams == 3 and references.fs:get() == false and custom_aa[player_state].defensive:get() and custom_aa[player_state].enable:get() and menu["anti-aim"].features:get() == "builder" then
			references.dtopt:override("Always On");
			references.hidden:override(true);
		else
			references.dtopt:override("On Peek");
			references.hidden:override(false);
			if menu["anti-aim"].features:get() == "preset" then
				references.dtopt:override("Always On");
				references.hidden:override(false);
			end;
		end;
		if teams == 3 and references.fs:get() == false and custom_aa[player_state].defensive:get() and custom_aa[player_state].enable:get() then
			if custom_aa[player_state].defensive.defensive_pitch:get() == "disabled" then
				rage.antiaim:override_hidden_pitch(0);
			elseif custom_aa[player_state].defensive.defensive_pitch:get() == "custom" then
				rage.antiaim:override_hidden_pitch(custom_aa[player_state].defensive.pitch_amount:get());
			elseif custom_aa[player_state].defensive.defensive_pitch:get() == "random" then
				rage.antiaim:override_hidden_pitch(math.random(custom_aa[player_state].defensive.pitch_amount:get(), custom_aa[player_state].defensive.pitch_amount_2:get()));
			elseif custom_aa[player_state].defensive.defensive_pitch:get() == "up-switch" then
				rage.antiaim:override_hidden_pitch(utils.random_float(45, 65) * (-1));
			end;
			if custom_aa[player_state].defensive.defensive_yaw:get() == "off" then
				rage.antiaim:override_hidden_yaw_offset(0);
			elseif custom_aa[player_state].defensive.defensive_yaw:get() == "spin" then
				rage.antiaim:override_hidden_yaw_offset(math.normalize_yaw((-180) + globals.tickcount % 9 * 40 + utils.random_float((-30), 30)));
			elseif custom_aa[player_state].defensive.defensive_yaw:get() == "random" then
				rage.antiaim:override_hidden_yaw_offset(utils.random_int(180, -180));
			elseif custom_aa[player_state].defensive.defensive_yaw:get() == "hidden" then
				references.hidden:override(true);
			end;
		end;
		if teams == 2 and references.fs:get() == false and custom_aa_t[player_state].defensive:get() and custom_aa_t[player_state].enable:get() then
			if custom_aa_t[player_state].defensive.defensive_pitch:get() == "disabled" then
				rage.antiaim:override_hidden_pitch(0);
			elseif custom_aa_t[player_state].defensive.defensive_pitch:get() == "custom" then
				rage.antiaim:override_hidden_pitch(custom_aa_t[player_state].defensive.pitch_amount:get());
			elseif custom_aa_t[player_state].defensive.defensive_pitch:get() == "random" then
				rage.antiaim:override_hidden_pitch(math.random(custom_aa_t[player_state].defensive.pitch_amount:get(), custom_aa_t[player_state].defensive.pitch_amount_2:get()));
			elseif custom_aa_t[player_state].defensive.defensive_pitch:get() == "up-switch" then
				rage.antiaim:override_hidden_pitch(utils.random_float(45, 65) * (-1));
			end;
			if custom_aa_t[player_state].defensive.defensive_yaw:get() == "off" then
				rage.antiaim:override_hidden_yaw_offset(0);
			elseif custom_aa_t[player_state].defensive.defensive_yaw:get() == "spin" then
				rage.antiaim:override_hidden_yaw_offset(math.normalize_yaw((-180) + globals.tickcount % 9 * 40 + utils.random_float((-30), 30)));
			elseif custom_aa_t[player_state].defensive.defensive_yaw:get() == "random" then
				rage.antiaim:override_hidden_yaw_offset(utils.random_int(180, -180));
			elseif custom_aa_t[player_state].defensive.defensive_yaw:get() == "hidden" then
				references.hidden:override(true);
			end;
		end;
	end,
	antiaims = function(self, c)
		local bodyyaw = helpers.functions:prop_get(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60;
		local side = bodyyaw > 0 and 1 or (-1);
		if menu["anti-aim"].features_select:get("manual aa") then
			if helpers.functions:manualaa() == 1 then
				references.pitch:override("down");
				references.left_limit:override(0);
				references.right_limit:override(0);
				references.yawmodifier:override("Disabled");
				references.yawbase:override("Local View");
				references.yawadd:override(-90);
			elseif helpers.functions:manualaa() == 2 then
				references.pitch:override("down");
				references.left_limit:override(0);
				references.right_limit:override(0);
				references.yawmodifier:override("Disabled");
				references.yawbase:override("Local View");
				references.yawadd:override(90);
			end;
		else
			references.yawbase:override("At Target");
		end;
		local team = (entity.get_local_player()).m_iTeamNum;
		if team == 3 and custom_aa[player_state].enable:get() and helpers.functions:manualaa() == 0 then
			if custom_aa[player_state].yaw_type:get() == "l&r" then
				references.pitch:override(custom_aa[player_state].pitch:get());
				if c.send_packet == true and c.choked_commands < 1 then
					references.yawadd:override(side == 1 and custom_aa[player_state].yaw_type.yawaddl:get() or custom_aa[player_state].yaw_type.yawaddr:get());
				end;
				references.yaw:override("Backward");
				references.yawbase:override("At Target");
				references.yawmodifier:override(custom_aa[player_state].yawjitter:get());
				references.bodyyaw:override(custom_aa[player_state].bodyyaw:get());
				references.fake_options:override(custom_aa[player_state].bodyyaw.options:get());
				references.yawmodifieroffset:override(custom_aa[player_state].yawjitter.yawjitteradd:get());
				references.left_limit:override(custom_aa[player_state].bodyyaw.bodyyawadd:get() or custom_aa[player_state].bodyyaw.bodyyawaddr:get());
				references.right_limit:override(custom_aa[player_state].bodyyaw.bodyyawaddr:get() or custom_aa[player_state].bodyyaw.bodyyawadd:get());
			else
				references.pitch:override(custom_aa[player_state].pitch:get());
				references.yawadd:override(custom_aa[player_state].yaw_type.yaw_value:get());
				references.yaw:override("Backward");
				references.yawbase:override("At Target");
				references.yawmodifier:override(custom_aa[player_state].yawjitter:get());
				references.bodyyaw:override(custom_aa[player_state].bodyyaw:get());
				references.fake_options:override(custom_aa[player_state].bodyyaw.options:get());
				references.yawmodifieroffset:override(custom_aa[player_state].yawjitter.yawjitteradd:get());
				references.left_limit:override(custom_aa[player_state].bodyyaw.bodyyawadd:get() or custom_aa[player_state].bodyyaw.bodyyawaddr:get());
				references.right_limit:override(custom_aa[player_state].bodyyaw.bodyyawaddr:get() or custom_aa[player_state].bodyyaw.bodyyawadd:get());
			end;
		elseif team == 2 and custom_aa_t[player_state].enable:get() and helpers.functions:manualaa() == 0 then
			if custom_aa_t[player_state].yaw_type:get() == "l&r" then
				references.pitch:override(custom_aa_t[player_state].pitch:get());
				references.yawadd:override(side == 1 and custom_aa_t[player_state].yaw_type.yawaddl:get() or custom_aa_t[player_state].yaw_type.yawaddr:get());
				references.yaw:override("Backward");
				references.yawbase:override("At Target");
				references.yawmodifier:override(custom_aa_t[player_state].yawjitter:get());
				references.bodyyaw:override(custom_aa_t[player_state].bodyyaw:get());
				references.fake_options:override(custom_aa_t[player_state].bodyyaw.options:get());
				references.yawmodifieroffset:override(custom_aa_t[player_state].yawjitter.yawjitteradd:get());
				references.left_limit:override(custom_aa_t[player_state].bodyyaw.bodyyawadd:get() or custom_aa_t[player_state].bodyyaw.bodyyawaddr:get());
				references.right_limit:override(custom_aa_t[player_state].bodyyaw.bodyyawaddr:get() or custom_aa_t[player_state].bodyyaw.bodyyawadd:get());
			else
				references.pitch:override(custom_aa_t[player_state].pitch:get());
				references.yawadd:override(custom_aa_t[player_state].yaw_type.yaw_value:get());
				references.yaw:override("Backward");
				references.yawbase:override("At Target");
				references.yawmodifier:override(custom_aa_t[player_state].yawjitter:get());
				references.bodyyaw:override(custom_aa_t[player_state].bodyyaw:get());
				references.fake_options:override(custom_aa_t[player_state].bodyyaw.options:get());
				references.yawmodifieroffset:override(custom_aa_t[player_state].yawjitter.yawjitteradd:get());
				references.left_limit:override(custom_aa_t[player_state].bodyyaw.bodyyawadd:get() or custom_aa_t[player_state].bodyyaw.bodyyawaddr:get());
				references.right_limit:override(custom_aa_t[player_state].bodyyaw.bodyyawaddr:get() or custom_aa_t[player_state].bodyyaw.bodyyawadd:get());
			end;
		elseif not custom_aa[player_state].enable:get() or not custom_aa_t[player_state].enable:get() and helpers.functions:manualaa() == 0 then
			references.pitch:set("disabled");
			references.bodyyaw:set(false);
			references.yawmodifier:set("disabled");
			references.yawbase:set("Local View");
			references.yawadd:set(0);
			references.yaw:set("disabled");
		end;
		state12 = "STANDING";
		if player_state == 5 then
			state12 = "AIR";
		elseif player_state == 7 then
			state12 = "SAFE";
		elseif player_state == 8 then
			state12 = "GRENADE";
		elseif player_state == 3 then
			state12 = "SLOWWALK";
		elseif player_state == 4 then
			state12 = "CROUCHING";
		elseif player_state == 6 then
			state12 = "AIR-CROUCH";
		elseif player_state == 2 then
			state12 = "MOVING";
		elseif player_state == 1 then
			state12 = "STANDING";
		end;
		if menu["anti-aim"].features:get() == "preset" and helpers.functions:manualaa() == 0 then
			if player_state == 8 then
				references.pitch:override("Down");
				references.yawadd:override(side == 1 and (-12) or 12);
				references.yaw:override("Backward");
				references.yawbase:override("At Target");
				references.yawmodifier:override("Center");
				references.bodyyaw:override(true);
				references.fake_options:override("Jitter");
				references.yawmodifieroffset:override(-38);
				references.left_limit:override(60);
				references.right_limit:override(60);
			elseif player_state == 7 then
				references.pitch:override("Down");
				references.yawadd:override(side == 1 and (-12) or 12);
				references.yaw:override("Backward");
				references.yawbase:override("At Target");
				references.yawmodifier:override("Center");
				references.bodyyaw:override(true);
				references.fake_options:override("Jitter");
				references.yawmodifieroffset:override(-38);
				references.left_limit:override(60);
				references.right_limit:override(60);
			elseif player_state == 6 then
				references.pitch:override("Down");
				references.yawadd:override(side == 1 and (-12) or 12);
				references.yaw:override("Backward");
				references.yawbase:override("At Target");
				references.yawmodifier:override("Center");
				references.bodyyaw:override(true);
				references.fake_options:override("Jitter");
				references.yawmodifieroffset:override(-38);
				references.left_limit:override(60);
				references.right_limit:override(60);
			elseif player_state == 5 then
				references.pitch:override("Down");
				references.yawadd:override(side == 1 and (-13) or 13);
				references.yaw:override("Backward");
				references.yawbase:override("At Target");
				references.yawmodifier:override("Center");
				references.bodyyaw:override(true);
				references.fake_options:override("Jitter");
				references.yawmodifieroffset:override(-37);
				references.left_limit:override(60);
				references.right_limit:override(60);
			elseif player_state == 4 then
				references.pitch:override("Down");
				references.yawadd:override(side == 1 and (-6) or 10);
				references.yaw:override("Backward");
				references.yawbase:override("At Target");
				references.yawmodifier:override("Center");
				references.bodyyaw:override(true);
				references.fake_options:override("Jitter");
				references.yawmodifieroffset:override(-41);
				references.left_limit:override(60);
				references.right_limit:override(60);
			elseif player_state == 3 then
				references.pitch:override("Down");
				references.yawadd:override(side == 1 and (-14) or 14);
				references.yaw:override("Backward");
				references.yawbase:override("At Target");
				references.yawmodifier:override("Center");
				references.bodyyaw:override(true);
				references.fake_options:override("Jitter");
				references.yawmodifieroffset:override(-43);
				references.left_limit:override(60);
				references.right_limit:override(60);
			elseif player_state == 2 then
				references.pitch:override("Down");
				references.yawadd:override(side == 1 and (-12) or 6);
				references.yaw:override("Backward");
				references.yawbase:override("At Target");
				references.yawmodifier:override("Center");
				references.bodyyaw:override(true);
				references.fake_options:override("Jitter");
				references.yawmodifieroffset:override(-45);
				references.left_limit:override(60);
				references.right_limit:override(60);
			elseif player_state == 1 then
				references.pitch:override("Down");
				references.yawadd:override(side == 1 and (-12) or 12);
				references.yaw:override("Backward");
				references.yawbase:override("At Target");
				references.yawmodifier:override("Center");
				references.bodyyaw:override(true);
				references.fake_options:override("Jitter");
				references.yawmodifieroffset:override(-28);
				references.left_limit:override(60);
				references.right_limit:override(60);
			end;
		end;
		self:defensive_cmd(c);
	end
};
functions.on_draw = {
	screen_render = function()
		if not entity.get_local_player() or (not (entity.get_local_player()):is_alive()) then
			return;
		end;
		state12 = "STANDING";
		if player_state == 5 then
			state12 = "AIR";
		elseif player_state == 7 then
			state12 = "SAFE";
		elseif player_state == 8 then
			state12 = "GRENADE";
		elseif player_state == 3 then
			state12 = "SLOWWALK";
		elseif player_state == 4 then
			state12 = "CROUCHING";
		elseif player_state == 6 then
			state12 = "AIR-CROUCH";
		elseif player_state == 2 then
			state12 = "MOVING";
		elseif player_state == 1 then
			state12 = "STANDING";
		end;
		local r, g, b, a = (menu.settings.indicators.color:get()).r, (menu.settings.indicators.color:get()).g, (menu.settings.indicators.color:get()).b, (menu.settings.indicators.color:get()).a;
		local alpha51 = math.sin(math.abs(((-3.14) + globals.curtime * (0.7 / 0.55) % (3.14 * 2)))) * 170;
		local active = helpers.functions.animations:animate("on_default15", not (anti_aim.get_exploit_charge() == 1 and references.dt:get() and (not is_defensive_active)), 5);
		local inactive = helpers.functions.animations:animate("on_default15435", not (anti_aim.get_exploit_charge() < 1 and (not is_defensive_active) and references.dt:get()), 5);
		local is_defensive_work = helpers.functions.animations:animate("on_default15435gggg", not (is_defensive_active and references.dt:get()), 5);
		local active_fs = helpers.functions.animations:animate("is_fs", not references.fs:get(), 6);
		local active_hs = helpers.functions.animations:animate("hide", not (references.hs:get() and (not references.dt:get())), 6);
		local global_alpha = helpers.functions.animations:animate("alpha", not (menu.settings.indicators:get() and menu.settings.indicators.widgets:get("crosshair indicator")), 6);
		local fraction = helpers.functions.animations:animate("on_default1543ggdasda5", not (math.max(active, inactive, active_hs, is_defensive_work) > 0), 5);
		local width = render.measure_text(2, "c", "-" .. state12 .. "-");
		local max_width = helpers.functions.width(0.09, width.x);
		local scoped = helpers.functions.animations:animate("is_scoped", not (helpers.functions:prop_get(entity.get_local_player(), "m_bIsScoped") == 1), 8);
		render.text(2, vector(x / 2 - 1 + scoped * 32, y / 2 + 15), color(255, 255, 255, 170 * global_alpha), "c", "" .. lua_name .. " \a" .. helpers.functions:rgba_to_hex(r, g, b, alpha51 * global_alpha) .. "YAW");
		render.push_clip_rect(vector(x / 2 - 3 + scoped * max_width / 1.6 - max_width / 1.6, y / 2), vector(x / 2 + scoped * max_width / 1.6 + max_width / 2.1, y / 2 + 35));
		render.text(2, vector(x / 2 - 1 + (width.x / 2 + 5) * scoped, y / 2 + 25), color(255, 255, 255, 170 * global_alpha), "c", "-" .. state12 .. "-");
		render.pop_clip_rect();
		local freesh = render.measure_text(2, "", "FREESTAND");
		render.push_clip_rect(vector(x / 2 - active_fs * 21, y / 2), vector(x / 2 - 25 + active_fs * 46 + scoped * 24, y / 2 + 45 + fraction * 10));
		render.text(2, vector(x / 2 + 20 - active_fs * 20 + 1 + (freesh.x / 2 + active_fs * 20 - 17) * scoped, y / 2 + 35 + fraction * 10), color(255, 255, 255, 170 * active_fs * global_alpha), "c", "FREESTAND");
		render.pop_clip_rect();
		local dtsh = render.measure_text(2, "", "DT \a" .. helpers.functions:rgba_to_hex(155, 255, 155, 255 * active * global_alpha) .. "READY");
		render.push_clip_rect(vector(x / 2 - active * 18 + scoped, y / 2), vector(x / 2 - 25 + active * 41 + scoped * 22, y / 2 + 47));
		render.text(2, vector(x / 2 + 20 - active * 20 + (dtsh.x / 2 + active * 20 - 16) * scoped, y / 2 + 35), color(255, 255, 255, 170 * active * global_alpha), "c", "DT \a" .. helpers.functions:rgba_to_hex(155, 255, 155, 170 * active * global_alpha) .. "READY");
		render.pop_clip_rect();
		local dtsh2 = render.measure_text(2, "", "DT \a" .. helpers.functions:rgba_to_hex(255, 0, 0, 155 * inactive * global_alpha) .. "CHARGING");
		render.push_clip_rect(vector(x / 2 - inactive * 25 + scoped, y / 2), vector(x / 2 - 28 + inactive * 52 + scoped * 28, y / 2 + 47));
		render.text(2, vector(x / 2 + 20 - inactive * 20 + (dtsh2.x / 2 + inactive * 20 - 15.5) * scoped, y / 2 + 35), color(255, 255, 255, 105 * inactive * global_alpha), "c", "DT \a" .. helpers.functions:rgba_to_hex(255, 0, 0, 105 * inactive * global_alpha) .. "CHARGING");
		render.pop_clip_rect();
		local dtsh3 = render.measure_text(2, "", "DT \a" .. helpers.functions:rgba_to_hex(155, 155, 200, 255 * is_defensive_work * global_alpha) .. "ACTIVE");
		render.push_clip_rect(vector(x / 2 - 1 - is_defensive_work * 18 + scoped, y / 2), vector(x / 2 - 25 + is_defensive_work * 49 + scoped * 17, y / 2 + 47));
		render.text(2, vector(x / 2 + 20 - is_defensive_work * 20 - 1 + (dtsh2.x / 2 + is_defensive_work * 20 - 21.5) * scoped, y / 2 + 35), color(255, 255, 255, 170 * is_defensive_work * global_alpha), "c", "DT \a" .. helpers.functions:rgba_to_hex(155, 155, 200, 170 * is_defensive_work * global_alpha) .. "ACTIVE");
		render.pop_clip_rect();
		local hshs = render.measure_text(2, "", "HIDE \a" .. helpers.functions:rgba_to_hex(155, 155, 200, 255 * active_hs * global_alpha) .. "ACTIVE");
		render.push_clip_rect(vector(x / 2 - 1 - active_hs * 24 + scoped, y / 2), vector(x / 2 - 28 + active_hs * 51 + scoped * 23, y / 2 + 47));
		render.text(2, vector(x / 2 + 20 - active_hs * 20 + (dtsh2.x / 2 + active_hs * 20 - 19) * scoped, y / 2 + 35), color(255, 255, 255, 170 * active_hs * global_alpha), "c", "HIDE \a" .. helpers.functions:rgba_to_hex(155, 155, 200, 170 * active_hs * global_alpha) .. "ACTIVE");
		render.pop_clip_rect();
	end,
	scope_render = function(self)
		if not entity.get_local_player() or (not (entity.get_local_player()):is_alive()) then
			return;
		end;
		local scoped_fraction2 = helpers.functions.animations:animate("on_default5gadgda", not ((entity.get_local_player()).m_bIsScoped and menu.settings.scope:get()), menu.settings.scope.speed:get());
		local offset = menu.settings.scope.gap:get() * y / 1080;
		local initial_position = menu.settings.scope.length:get() * y / 1080;
		local r_1, g_1, b_1, a_1 = (menu.settings.scope.color:get()).r, (menu.settings.scope.color:get()).g, (menu.settings.scope.color:get()).b, (menu.settings.scope.color:get()).a;
		if menu.settings.scope.styles:get() == "default" then
			renderer.gradient(x / 2 - initial_position * scoped_fraction2 + 1, y / 2, initial_position * scoped_fraction2 - offset * scoped_fraction2, 1, r_1, g_1, b_1, 0, r_1, g_1, b_1, a_1 * scoped_fraction2, true);
			renderer.gradient(x / 2 + offset * scoped_fraction2, y / 2, initial_position * scoped_fraction2 - offset * scoped_fraction2, 1, r_1, g_1, b_1, a_1 * scoped_fraction2, r_1, g_1, b_1, 0, true);
			renderer.gradient(x / 2, y / 2 - 2 - initial_position * scoped_fraction2 + 3, 1, initial_position * scoped_fraction2 - offset * scoped_fraction2, r_1, g_1, b_1, 0, r_1, g_1, b_1, a_1 * scoped_fraction2, false);
			renderer.gradient(x / 2, y / 2 + offset * scoped_fraction2, 1, initial_position * scoped_fraction2 - offset * scoped_fraction2, r_1, g_1, b_1, a_1 * scoped_fraction2, r_1, g_1, b_1, 0, false);
		elseif menu.settings.scope.styles:get() == "t-sharp" then
			renderer.gradient(x / 2 - initial_position * scoped_fraction2 + 1, y / 2, initial_position * scoped_fraction2 - offset * scoped_fraction2, 1, r_1, g_1, b_1, 0, r_1, g_1, b_1, a_1 * scoped_fraction2, true);
			renderer.gradient(x / 2 + offset * scoped_fraction2, y / 2, initial_position * scoped_fraction2 - offset * scoped_fraction2, 1, r_1, g_1, b_1, a_1 * scoped_fraction2, r_1, g_1, b_1, 0, true);
			renderer.gradient(x / 2, y / 2 + offset * scoped_fraction2, 1, initial_position * scoped_fraction2 - offset * scoped_fraction2, r_1, g_1, b_1, a_1 * scoped_fraction2, r_1, g_1, b_1, 0, false);
		end;
		if menu.settings.scope:get() then
			(ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")):set("Remove All");
		else
			(ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")):set("Remove Overlay");
		end;
	end,
	damage_render = function()
		if not entity.get_local_player() or (not (entity.get_local_player()):is_alive()) then
			return;
		end;
		local global_alpha = helpers.functions.animations:animate("damage_ind", not (menu.settings.indicators:get() and menu.settings.indicators.widgets:get("damage indicator")), 12);
		helpers.functions.damage_anim = helpers.functions:lerp2(helpers.functions.damage_anim, references.dmg:get(), 0.04);
		local dmg_string = damage == 0 and "AUTO" or tostring(math.floor(helpers.functions.damage_anim + 0.5));
		render.text(1, vector(x / 2 + 5, y / 2 - 15), color(200, 200, 200, 220 * global_alpha), nil, dmg_string);
	end,
	aspectratio_render = function(self)
		helpers.functions.aspectratio_value = helpers.functions:lerp(helpers.functions.aspectratio_value, menu.settings.aspectratio.offset:get() / 100, 10);
		if menu.settings.aspectratio:get() then
			if menu.settings.aspectratio.offset:get() == 0 then
				cvar.r_aspectratio:float(0);
			else
				cvar.r_aspectratio:float(helpers.functions.aspectratio_value);
			end;
		else
			cvar.r_aspectratio:float(0);
		end;
	end,
	viewmodel_render = function(self)
		if not entity.get_local_player() or (not (entity.get_local_player()):is_alive()) then
			return;
		end;
		if menu.settings.viewmodel:get() then
			cvar.viewmodel_fov:int(menu.settings.viewmodel.fov:get(), true);
			cvar.viewmodel_offset_x:float(menu.settings.viewmodel.x:get() / 10, true);
			cvar.viewmodel_offset_y:float(menu.settings.viewmodel.y:get() / 10, true);
			cvar.viewmodel_offset_z:float(menu.settings.viewmodel.z:get() / 10, true);
		end;
	end,
	watermark_render = function()
		if not globals.is_connected or (not globals.is_in_game) then
			return;
		end;
		local r1, g1, b1, a1 = (menu.settings.watermark.color:get()).r, (menu.settings.watermark.color:get()).g, (menu.settings.watermark.color:get()).b, (menu.settings.watermark.color:get()).a;
		local global_alpha = helpers.functions.animations:animate("alpha5", not menu.settings.watermark:get(), 6);
		local left_alpha = helpers.functions.animations:animate("alpha15", not (menu.settings.watermark.position:get() == "left"), 6);
		local right_alpha = helpers.functions.animations:animate("alpha65", not (menu.settings.watermark.position:get() == "right"), 6);
		local left_water = helpers.functions:animate_text(globals.curtime * 0.9, "" .. lua_name .. "", r1, g1, b1, a1 * global_alpha * left_alpha);
		local right_water = helpers.functions:animate_text((-globals.curtime) * 0.9, "" .. lua_name .. "", r1, g1, b1, a1 * global_alpha * right_alpha);
		render.text(1, vector(x / 21 - 75, y / 2), color(255, 255, 255, 255 * global_alpha * left_alpha), r, unpack(left_water));
		render.text(1, vector(x - 120, y / 2), color(255, 255, 255, 255 * global_alpha * right_alpha), r, unpack(right_water));
	end,
	arrows_render = function()
		if not entity.get_local_player() or (not (entity.get_local_player()):is_alive()) then
			return;
		end;
		local color1, color2, color3, color4 = (menu.settings.indicators.color_arrows:get()).r, (menu.settings.indicators.color_arrows:get()).g, (menu.settings.indicators.color_arrows:get()).b, (menu.settings.indicators.color_arrows:get()).a;
		local global_alpha = helpers.functions.animations:animate("alpha2", not (menu.settings.indicators:get() and menu.settings.indicators.widgets:get("anti-aim arrows")), 6);
		local left_alpha = helpers.functions.animations:animate("alpha_arrows_left", not (helpers.functions:manualaa() == 1), 6);
		local right_alpha = helpers.functions.animations:animate("alpha_arrows_right", not (helpers.functions:manualaa() == 2), 6);
		render.text(helpers.functions.large_bold_verdana, vector(x / 2 - 55, y / 2 - 2), color(color1, color2, color3, color4 * global_alpha * left_alpha), nil, "‹");
		render.text(helpers.functions.large_bold_verdana, vector(x / 2 + 55, y / 2 - 2), color(color1, color2, color3, color4 * global_alpha * right_alpha), nil, "›");
	end,
	events_logger = function(self, e)
		local hex_noti2 = (color((menu.settings.logs.hit_color:get()).r, (menu.settings.logs.hit_color:get()).g, (menu.settings.logs.hit_color:get()).b, (menu.settings.logs.hit_color:get()).a)):to_hex();
		local hex_noti = (color((menu.settings.logs.miss_color:get()).r, (menu.settings.logs.miss_color:get()).g, (menu.settings.logs.miss_color:get()).b, (menu.settings.logs.miss_color:get()).a)):to_hex();
		local me = entity.get_local_player();
		local target = entity.get(e.target);
		local damage = e.damage;
		local wanted_damage = e.wanted_damage;
		local hitchance = e.hitchance;
		local state = e.state;
		local bt = e.backtrack;
		local history = e.backtrack;
		local health = target.m_iHealth;
		local text3 = "";
		local text = "";
		local text2 = "";
		local hg_diff = hitboxes[e.hitgroup] ~= hitboxes[e.wanted_hitgroup];
		local dmg_diff = damage ~= wanted_damage;
		if not menu.settings.logs.full_color_logs:get() then
			if dmg_diff and (not hg_diff) then
				text2 = ", mismatch: {dmg: \a" .. hex_noti2 .. wanted_damage .. "\ac8c8c8ff}";
			elseif not dmg_diff and hg_diff then
				text2 = ", mismatch: {hitgroup: \a" .. hex_noti2 .. hitboxes[e.wanted_hitgroup] .. "\ac8c8c8ff}";
			elseif dmg_diff and hg_diff then
				text2 = ", mismatch: {dmg: \a" .. hex_noti2 .. wanted_damage .. "\ac8c8c8ff hitgroup: \a" .. hex_noti2 .. hitboxes[e.wanted_hitgroup] .. "\ac8c8c8ff}";
			end;
			if health <= 0 then
				text = "dead";
				text3 = "Killed";
			else
				text = health .. " \ac8c8c8ffhp";
				text3 = "Hit";
			end;
			if e.state == nil and menu.settings.logs:get() then
				helpers.functions:log("\a" .. hex_noti2 .. "" .. lua_name .. " ~ \ac8c8c8ff" .. text3 .. "\a" .. hex_noti2 .. " " .. target:get_name() .. "\ac8c8c8ff's \a" .. hex_noti2 .. hitboxes[e.hitgroup] .. " \ac8c8c8fffor \a" .. hex_noti2 .. e.damage .. "\ac8c8c8ff" .. " [remaining: \a" .. hex_noti2 .. text .. "\ac8c8c8ff, HC:\a" .. hex_noti2 .. hitchance .. "\ac8c8c8ff%, history: \a" .. hex_noti2 .. history .. "\ac8c8c8ff" .. text2 .. "]");
				print_raw("\a" .. hex_noti2 .. "" .. lua_name .. " ~ \ac8c8c8ff" .. text3 .. "\a" .. hex_noti2 .. " " .. target:get_name() .. "\ac8c8c8ff's \a" .. hex_noti2 .. hitboxes[e.hitgroup] .. " \ac8c8c8fffor \a" .. hex_noti2 .. e.damage .. "\ac8c8c8ff" .. " [remaining: \a" .. hex_noti2 .. text .. "\ac8c8c8ff, HC:\a" .. hex_noti2 .. hitchance .. "\ac8c8c8ff%, history: \a" .. hex_noti2 .. history .. "\ac8c8c8ff" .. text2 .. "]");
			elseif e.state ~= nil and menu.settings.logs:get() then
				helpers.functions:log("\a" .. hex_noti .. "" .. lua_name .. " ~ \ac8c8c8ff\ac8c8c8ffMissed \a" .. hex_noti .. target:get_name() .. "\ac8c8c8ff's \a" .. hex_noti .. hitboxes[e.wanted_hitgroup] .. "\ac8c8c8ff due to \a" .. hex_noti .. e.state .. "\ac8c8c8ff [dmg: \a" .. hex_noti .. wanted_damage .. " \ac8c8c8ffhp, HC: \a" .. hex_noti .. hitchance .. "\ac8c8c8ff%, history: \a" .. hex_noti .. history .. "\ac8c8c8ff]");
				print_raw("\a" .. hex_noti .. "" .. lua_name .. " ~ \ac8c8c8ff\ac8c8c8ffMissed \a" .. hex_noti .. target:get_name() .. "\ac8c8c8ff's \a" .. hex_noti .. hitboxes[e.wanted_hitgroup] .. "\ac8c8c8ff due to \a" .. hex_noti .. e.state .. "\ac8c8c8ff [dmg: \a" .. hex_noti .. wanted_damage .. " \ac8c8c8ffhp, HC: \a" .. hex_noti .. hitchance .. "\ac8c8c8ff%, history: \a" .. hex_noti .. history .. "\ac8c8c8ff]");
			end;
		else
			if dmg_diff and (not hg_diff) then
				text2 = "\a" .. hex_noti2 .. ", mismatch: {dmg: " .. wanted_damage .. "}";
			elseif not dmg_diff and hg_diff then
				text2 = "\a" .. hex_noti2 .. ", mismatch: {hitgroup: " .. hitboxes[e.wanted_hitgroup] .. "}";
			elseif dmg_diff and hg_diff then
				text2 = "\a" .. hex_noti2 .. ", mismatch: {dmg: " .. wanted_damage .. ", hitgroup: " .. hitboxes[e.wanted_hitgroup] .. "}";
			end;
			if health <= 0 then
				text = "dead";
				text3 = "Killed";
			else
				text = health .. " hp";
				text3 = "Hit";
			end;
			if e.state == nil and menu.settings.logs:get() then
				helpers.functions:log("\a" .. hex_noti2 .. "" .. lua_name .. " ~ " .. text3 .. " " .. target:get_name() .. "'s " .. hitboxes[e.hitgroup] .. " for " .. e.damage .. " [remaining: " .. text .. ", HC: " .. hitchance .. "%, history: " .. history .. text2 .. "]");
				print_raw("\a" .. hex_noti2 .. "" .. lua_name .. " ~ " .. text3 .. " " .. target:get_name() .. "'s " .. hitboxes[e.hitgroup] .. " for " .. e.damage .. " [remaining: " .. text .. ", HC: " .. hitchance .. "%, history: " .. history .. text2 .. "]");
			elseif e.state ~= nil and menu.settings.logs:get() then
				helpers.functions:log("\a" .. hex_noti .. "" .. lua_name .. " ~ Missed " .. target:get_name() .. "'s " .. hitboxes[e.wanted_hitgroup] .. " due to " .. e.state .. " [dmg: " .. health .. " hp, HC: " .. hitchance .. "%, history: " .. history .. "]");
				print_raw("\a" .. hex_noti .. "" .. lua_name .. " ~ Missed " .. target:get_name() .. "'s " .. hitboxes[e.wanted_hitgroup] .. " due to " .. e.state .. " [dmg: " .. health .. " hp, HC: " .. hitchance .. "%, history: " .. history .. "]");
			end;
		end;
		if e.state ~= nil then
			database.misses = database.misses + 1;
			menu.stats.label8:name("\a{Link Active}" .. ui.get_icon("phone-missed") .. "\a{Text}" .. "   misses: " .. "\a{Link Active}" .. database.misses);
			files.write("nl/" .. lua_name .. "/data.txt", json.stringify(database));
		end;
	end
};
events.render:set(function()
	if entity.get_local_player() == nil then
		helpers.functions.defensive_ticks = 0;
	end;
	functions.on_draw:watermark_render();
	functions.on_draw:aspectratio_render();
	functions.on_draw:damage_render();
	functions.on_draw:arrows_render();
	functions.on_draw:screen_render();
	functions.on_draw:scope_render();
	if menu.settings.logs:get() then
		helpers.functions:upper_log();
	end;
	if menu.settings.viewmodel:get() then
		functions.on_draw:viewmodel_render();
	else
		cvar.viewmodel_fov:int(68);
		cvar.viewmodel_offset_x:float(2.5);
		cvar.viewmodel_offset_y:float(0);
		cvar.viewmodel_offset_z:float(-1.5);
	end;
	local seconds_ses = math.floor(globals.realtime);
	local hours_ses = math.floor(globals.realtime / 3600);
	local minutes_ses = math.floor(globals.realtime / 60);
	if seconds_ses == 1 and hours_ses < 1 and minutes_ses < 1 then
		text = seconds_ses .. " second";
	elseif seconds_ses >= 2 and hours_ses < 1 and minutes_ses < 1 then
		text = seconds_ses .. " seconds";
	elseif minutes_ses >= 2 and hours_ses < 1 then
		text = minutes_ses .. " minutes";
	elseif minutes_ses == 1 and hours_ses < 1 then
		text = minutes_ses .. " minute";
	elseif hours_ses < 2 then
		text = hours_ses .. " hour";
	elseif hours_ses >= 2 then
		text = hours_ses .. " hours";
	end;
	menu.stats.label9:name("\a{Link Active}" .. ui.get_icon("hourglass-clock") .. "\a{Text}" .. "   session: " .. "\a{Link Active}" .. text);
	if menu.configs.List:get() ~= 1 then
		if database.date[menu.configs.List:get()] ~= nil then
			local timeDifference = common.get_unixtime() - helpers.functions:convertToUnixTime(database.date[menu.configs.List:get()]);
			local weeks = math.floor(timeDifference / 604800);
			local days = math.floor(timeDifference / 86400);
			local hours = math.floor(timeDifference / 3600);
			local minutes = math.floor(timeDifference / 60);
			local seconds = math.floor(timeDifference);
			if weeks == 1 then
				text = math.floor(timeDifference / 604800) .. " week ago";
			elseif weeks >= 2 then
				text = math.floor(timeDifference / 604800) .. " weeks ago";
			elseif days >= 2 then
				text = math.floor(timeDifference / 86400) .. " days ago";
			elseif days == 1 then
				text = math.floor(timeDifference / 86400) .. " day ago";
			elseif hours >= 2 then
				text = math.floor(timeDifference / 3600) .. " hours ago";
			elseif hours == 1 then
				text = math.floor(timeDifference / 3600) .. " hour ago";
			elseif minutes >= 2 then
				text = math.floor(timeDifference / 60) .. " minutes ago";
			elseif minutes == 1 then
				text = math.floor(timeDifference / 60) .. " minute ago";
			elseif seconds >= 2 then
				text = math.floor(timeDifference) .. " seconds ago";
			elseif seconds == 1 then
				text = math.floor(timeDifference) .. " second ago";
			elseif seconds < 1 then
				text = "just now";
			end;
		end;
		menu.configs.date:name("\a{Link Active}" .. ui.get_icon("clock") .. "\a{Text}" .. "  " .. text);
		menu.configs.user:name("\a{Link Active}" .. ui.get_icon("user") .. "\a{Text}" .. "  " .. string.lower(common.get_username()));
	else
		menu.configs.date:name("\a{Link Active}" .. ui.get_icon("clock") .. "\a{Text}" .. "  - ");
		menu.configs.user:name("\a{Link Active}" .. ui.get_icon("user") .. "\a{Text}" .. "  recrent ");
	end;
end);
events.createmove:set(function(c)
	if menu["anti-aim"].features_select:get("nade throw fix") then
		if entity.get_local_player() == nil then
			return;
		end;
		if (entity.get_local_player()):get_player_weapon() == nil then
			return;
		end;
		local weapon_index = ((entity.get_local_player()):get_player_weapon()):get_weapon_index();
		local is_grenade = weapon_index == 43 or weapon_index == 44 or weapon_index == 45 or weapon_index == 46 or weapon_index == 47 or weapon_index == 48;
		if is_grenade then
			rage.exploit:allow_defensive(false);
		else
			rage.exploit:allow_defensive(true);
		end;
	end;
	functions.setup:condition_get(c);
	functions.setup:antiaims(c);
	functions.setup:nofall(c);
end);
events.player_death:set(function(e)
	local target = entity.get(e.userid, true);
	local attacker = entity.get(e.attacker, true);
	if target == entity.get_local_player() then
		return;
	end;
	if target ~= entity.get_local_player() and attacker == entity.get_local_player() then
		database.enemies = database.enemies + 1;
		menu.stats.label7:name("\a{Link Active}" .. ui.get_icon("skull") .. "\a{Text}" .. "   enemies killed: " .. "\a{Link Active}" .. database.enemies);
		files.write("nl/" .. lua_name .. "/data.txt", json.stringify(database));
	end;
end);
menu.settings.warmup_helper:set_callback(function(self)
	if not self:get() then
		return;
	end;
	utils.console_exec("sv_cheats 1; sv_regeneration_force_on 1; mp_limitteams 0; mp_autoteambalance 0; mp_roundtime 60; mp_roundtime_defuse 60; mp_maxmoney 60000; mp_startmoney 60000; mp_freezetime 0; mp_buytime 9999; mp_buy_anywhere 1; sv_infinite_ammo 1; ammo_grenade_limit_total 5; bot_kick; bot_stop 1; mp_warmup_end; mp_restartgame 1; mp_respawn_on_death_ct 1; mp_respawn_on_death_t 1; sv_airaccelerate 100;");
end);
local md5_code = "250ab07ed7a5812e861ad78e3af37a29gsafghsez3334563236";
local shared_image = "https://cdn.discordapp.com/attachments/949916752068870205/1208711985311518730/Remove-bg.ai_1708249791218.png?ex=65e447c2&is=65d1d2c2&hm=1ed63de8770b50fdd7ea59c1a04453fb25b5b8a92f7ee516931965bf81e09586&";
local relayData = function()
	events.voice_message:call(function(buffer)
		buffer:write_bits(38418, 128);
		buffer:crypt(md5_code);
	end);
end;
local ShutdownRelay = function()
	local me = entity.get_local_player();
	if me == nil then
		return;
	end;
	me:set_icon();
	events.voice_message:call(function(buffer)
		buffer:write_bits(38419, 128);
		buffer:crypt(md5_code);
	end);
	entity.get_players(false, true, function(ptr)
		ptr:set_icon();
	end);
end;
local requestActive = function()
	local me = entity.get_local_player();
	if me == nil then
		return;
	end;
	utils.execute_after(0.5, function()
		me:set_icon(shared_image);
	end);
	events.voice_message:call(function(buffer)
		buffer:write_bits(38420, 128);
		buffer:crypt(md5_code);
	end);
end;
events.voice_message(function(cvb)
	if menu.settings.shared_icon:get() then
		local buffer = cvb.buffer;
		local me = entity.get_local_player();
		if me == nil then
			return;
		end;
		if cvb.entity == me then
			return;
		end;
		buffer:crypt(md5_code);
		local netmsg = buffer:read_bits(128);
		if cvb.entity == nil then
			return;
		end;
		if cvb.entity:is_bot() then
			return;
		end;
		if netmsg == 38418 then
			cvb.entity:set_icon(shared_image);
		elseif netmsg == 38419 then
			cvb.entity:set_icon();
		elseif netmsg == 38420 then
			utils.execute_after(0.3, relayData);
			cvb.entity:set_icon(shared_image);
		end;
	end;
end);
menu.settings.shared_icon:set_callback(function(self)
	if self:get() then
		utils.execute_after(0.1, relayData);
		utils.execute_after(0.5, requestActive);
	end;
	if not self:get() then
		ShutdownRelay();
	end;
end, true);
events.round_start:set(function()
	if not menu.settings.shared_icon:get() then
		local me = entity.get_local_player();
		if me == nil then
			return;
		end;
		me:set_icon();
	end;
end);
events.level_init:set(requestActive);
events.shutdown:set(function()
	ShutdownRelay();
	cvar.r_aspectratio:float(0);
	cvar.viewmodel_fov:int(68);
	cvar.viewmodel_offset_x:float(2.5);
	cvar.viewmodel_offset_y:float(0);
	cvar.viewmodel_offset_z:float(-1.5);
	(ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")):set("Remove Overlay");
end);
events.net_update_end:set(function()
	if entity.get_local_player() ~= nil then
		is_defensive_active = helpers.functions:is_defensive(entity.get_local_player());
	end;
end);
events.item_purchase:set(function(e)
	local playerz = entity.get(e.userid, true);
	local weaponz = e.weapon;
	if playerz == nil then
		return;
	end;
	if not playerz:is_enemy() then
		return;
	end;
	if weaponz == "weapon_unknown" then
		return;
	end;
	if not menu.settings.logs:get() then
		return;
	end;
	helpers.functions:log("\ac3c6ffff" .. lua_name .. " ~\ac8c8c8ff " .. playerz:get_name() .. " bought " .. weaponz);
	print_raw("\ac3c6ffff" .. lua_name .. " ~\ac8c8c8ff " .. playerz:get_name() .. " bought " .. weaponz);
end);
events.aim_ack:set(function(self, e)
	functions.on_draw:events_logger(self, e);
end);
local INITIALIZATION;
do
	Children();
end;
