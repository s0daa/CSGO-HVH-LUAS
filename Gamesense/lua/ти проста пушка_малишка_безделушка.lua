local var_0_0 = require("gamesense/easing")
local var_0_1 = require("ffi")
local var_0_2 = require("gamesense/pui")
local var_0_3 = require("gamesense/base64")
local var_0_4 = require("vector")
local var_0_5 = require("gamesense/entity")
local var_0_6 = require("bit")
local var_0_7 = var_0_6.band
local var_0_8 = {
	client.screen_size()
}
local var_0_9 = var_0_5.get_local_player
local var_0_10, var_0_11 = client.screen_size()

function lerp(arg_1_0, arg_1_1, arg_1_2)
	return arg_1_0 + (arg_1_1 - arg_1_0) * arg_1_2
end

function RGBAtoHEX(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	return string.format("%.2x%.2x%.2x%.2x", arg_2_0, arg_2_1, arg_2_2, arg_2_3)
end

local function var_0_12(arg_3_0, arg_3_1)
	for iter_3_0, iter_3_1 in pairs(arg_3_0) do
		if iter_3_1 == arg_3_1 then
			return true
		end
	end

	return false
end

local function var_0_13(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10, arg_4_11, arg_4_12, arg_4_13, arg_4_14)
	local var_4_0 = renderer.measure_text(arg_4_9, arg_4_10)

	renderer.rectangle(arg_4_0 - var_4_0 / 2, arg_4_1, var_4_0, 1, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.rectangle(arg_4_0 - var_4_0 / 2, arg_4_1 + 22, var_4_0, 1, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.rectangle(arg_4_0 - var_4_0 / 2, arg_4_1 + 1, var_4_0, 21, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 1, arg_4_1 + 2, 1, 19, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 2, arg_4_1 + 3, 1, 17, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0, arg_4_1 + 2, 1, 19, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0 + 1, arg_4_1 + 3, 1, 17, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.rectangle(arg_4_0 - var_4_0 / 2, arg_4_1 - 1, var_4_0, 1, arg_4_2, arg_4_3, arg_4_4, 255)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 1, arg_4_1, 1, 1, arg_4_2, arg_4_3, arg_4_4, 255)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0, arg_4_1, 1, 1, arg_4_2, arg_4_3, arg_4_4, 255)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 2, arg_4_1 + 1, 1, 1, arg_4_2, arg_4_3, arg_4_4, 255)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0 + 1, arg_4_1 + 1, 1, 1, arg_4_2, arg_4_3, arg_4_4, 255)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0 + 2, arg_4_1 + 2, 1, 5, arg_4_2, arg_4_3, arg_4_4, 255)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 3, arg_4_1 + 2, 1, 5, arg_4_2, arg_4_3, arg_4_4, 255)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0 + 2, arg_4_1 + 7, 1, 3, arg_4_2, arg_4_3, arg_4_4, 225)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 3, arg_4_1 + 7, 1, 3, arg_4_2, arg_4_3, arg_4_4, 225)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0 + 2, arg_4_1 + 10, 1, 3, arg_4_2, arg_4_3, arg_4_4, 175)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 3, arg_4_1 + 10, 1, 3, arg_4_2, arg_4_3, arg_4_4, 175)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0 + 2, arg_4_1 + 13, 1, 3, arg_4_2, arg_4_3, arg_4_4, 125)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 3, arg_4_1 + 13, 1, 3, arg_4_2, arg_4_3, arg_4_4, 125)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0 + 2, arg_4_1 + 16, 1, 5, arg_4_2, arg_4_3, arg_4_4, 75)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 3, arg_4_1 + 16, 1, 5, arg_4_2, arg_4_3, arg_4_4, 75)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 1, arg_4_1 + 22, 1, 1, arg_4_2, arg_4_3, arg_4_4, 65)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0, arg_4_1 + 22, 1, 1, arg_4_2, arg_4_3, arg_4_4, 65)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 2, arg_4_1 + 21, 1, 1, arg_4_2, arg_4_3, arg_4_4, 65)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0 + 1, arg_4_1 + 21, 1, 1, arg_4_2, arg_4_3, arg_4_4, 65)
	renderer.rectangle(arg_4_0 - var_4_0 / 2, arg_4_1 + 23, var_4_0, 1, arg_4_2, arg_4_3, arg_4_4, 65)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 2, arg_4_1 + 2, 1, 1, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 1, arg_4_1 + 1, 1, 1, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0, arg_4_1 + 1, 1, 1, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0 + 1, arg_4_1 + 2, 1, 1, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 1, arg_4_1 + 21, 1, 1, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 - 2, arg_4_1 + 20, 1, 1, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0, arg_4_1 + 21, 1, 1, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.rectangle(arg_4_0 - var_4_0 / 2 + var_4_0 + 1, arg_4_1 + 20, 1, 1, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	renderer.text(arg_4_0 - var_4_0 / 2, arg_4_1 + 5, arg_4_11, arg_4_12, arg_4_13, arg_4_14, arg_4_9, 0, arg_4_10)
end

local var_0_14 = {
	welcomertime = 0,
	welcomervector = 0,
	welcomer = false,
	welcomerlist = {}
}
local var_0_15 = entity.get_local_player()
local var_0_16 = entity.get_player_name(var_0_15)

table.insert(var_0_14.welcomerlist, " Have a good game " .. var_0_16)

local function var_0_17()
	if var_0_14.welcomertime >= 0 and var_0_14.welcomertime < 740 then
		var_0_14.welcomertime = var_0_14.welcomertime + 1
	end

	if var_0_14.welcomertime == 10 then
		var_0_14.welcomer = true
	elseif var_0_14.welcomertime == 700 then
		var_0_14.welcomer = false
	elseif var_0_14.welcomertime == 740 then
		table.remove(var_0_14.welcomerlist, 1)
	end

	if var_0_14.welcomer then
		var_0_14.welcomervector = lerp(var_0_14.welcomervector, 0, globals.frametime() * 15)
	else
		var_0_14.welcomervector = lerp(var_0_14.welcomervector, 200, globals.frametime() * 15)
	end

	local var_5_0 = globals.realtime() * 0.5 % (2 * math.pi)
	local var_5_1 = math.floor((math.sin(var_5_0) + 1) * 127.5)
	local var_5_2 = math.floor((math.sin(var_5_0 + 2 * math.pi / 3) + 1) * 127.5)
	local var_5_3 = math.floor((math.sin(var_5_0 + 4 * math.pi / 3) + 1) * 127.5)

	if #var_0_14.welcomerlist == 1 then
		var_0_13(var_0_10 / 2, var_0_11 / 1.2 + var_0_14.welcomervector, 142, 165, 229, 25, 25, 25, 100, "nil", var_0_14.welcomerlist[1], var_5_1, var_5_2, var_5_3, 255)
	end
end

local var_0_18 = {
	aa_enable = ui.reference("AA", "anti-aimbot angles", "enabled"),
	pitch = ui.reference("AA", "anti-aimbot angles", "pitch"),
	pitch_value = select(2, ui.reference("AA", "anti-aimbot angles", "pitch")),
	yaw_base = ui.reference("AA", "anti-aimbot angles", "yaw base"),
	yaw = ui.reference("AA", "anti-aimbot angles", "yaw"),
	yaw_value = select(2, ui.reference("AA", "anti-aimbot angles", "yaw")),
	yaw_jitter = ui.reference("AA", "Anti-aimbot angles", "Yaw Jitter"),
	yaw_jitter_value = select(2, ui.reference("AA", "Anti-aimbot angles", "Yaw Jitter")),
	body_yaw = ui.reference("AA", "Anti-aimbot angles", "Body yaw"),
	body_yaw_value = select(2, ui.reference("AA", "Anti-aimbot angles", "Body yaw")),
	freestand_body_yaw = ui.reference("AA", "Anti-aimbot angles", "freestanding body yaw"),
	edgeyaw = ui.reference("AA", "anti-aimbot angles", "edge yaw"),
	freestand = {
		ui.reference("AA", "anti-aimbot angles", "freestanding")
	},
	roll = ui.reference("AA", "anti-aimbot angles", "roll"),
	slide = {
		ui.reference("AA", "other", "slow motion")
	},
	fakeduck = ui.reference("rage", "other", "duck peek assist"),
	quick_peek = {
		ui.reference("rage", "other", "quick peek assist")
	},
	doubletap = {
		ui.reference("rage", "aimbot", "double tap")
	}
}
local var_0_19 = ui.reference("Rage", "Aimbot", "Double tap")
local var_0_20 = ui.reference("AA", "Other", "On shot anti-aim")
local var_0_21 = ui.reference("AA", "Fake lag", "Limit")

function get_velocity()
	if not entity.get_local_player() then
		return
	end

	local var_6_0, var_6_1 = entity.get_prop(entity.get_local_player(), "m_vecVelocity")

	return (math.floor(math.sqrt(var_6_0 * var_6_0 + var_6_1 * var_6_1)))
end

local var_0_22 = 1

function get_state(arg_7_0)
	if not entity.is_alive(entity.get_local_player()) then
		return
	end

	local var_7_0 = entity.get_prop(entity.get_local_player(), "m_fFlags")

	if var_0_6.band(var_7_0, var_0_6.lshift(1, 0)) ~= 0 == true then
		var_0_22 = var_0_22 + 1
	else
		var_0_22 = 0
	end

	if var_0_6.band(var_7_0, 1) == 1 then
		if var_0_22 < 10 then
			if var_0_6.band(var_7_0, 4) == 4 then
				return 5
			else
				return 4
			end
		end

		if var_0_6.band(var_7_0, 4) == 4 or ui.get(var_0_18.fakeduck) then
			return 6
		elseif arg_7_0 <= 3 then
			return 2
		elseif ui.get(var_0_18.slide[2]) then
			return 7
		else
			return 3
		end
	elseif var_0_6.band(var_7_0, 1) == 0 then
		if var_0_6.band(var_7_0, 4) == 4 then
			return 5
		else
			return 4
		end
	end
end

var_0_1.cdef("\ttypedef int(__thiscall* get_clipboard_text_count)(void*);\n\ttypedef void(__thiscall* set_clipboard_text)(void*, const char*, int);\n\ttypedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);\n")

local var_0_23 = var_0_1.cast(var_0_1.typeof("void***"), client.create_interface("vgui2.dll", "VGUI_System010") or error("Error finding VGUI_System010"))
local var_0_24 = var_0_1.cast("get_clipboard_text_count", var_0_23[0][7]) or error("get_clipboard_text_count Invalid")
local var_0_25 = var_0_1.cast("set_clipboard_text", var_0_23[0][9]) or error("set_clipboard_text Invalid")
local var_0_26 = var_0_1.cast("get_clipboard_text", var_0_23[0][11]) or error("get_clipboard_text Invalid")

function clipboard_import()
	local var_8_0 = var_0_24(var_0_23)

	if var_8_0 > 0 then
		local var_8_1 = var_0_1.new("char[?]", var_8_0)
		local var_8_2 = var_8_0 * var_0_1.sizeof("char[?]", var_8_0)

		var_0_26(var_0_23, 0, var_8_1, var_8_2)

		return var_0_1.string(var_8_1, var_8_0 - 1)
	end

	return ""
end

local function var_0_27(arg_9_0)
	if arg_9_0 then
		var_0_25(var_0_23, arg_9_0, arg_9_0:len())
	end
end

local var_0_28 = {
	"G",
	"S",
	"M",
	"A",
	"A-C",
	"C",
	"SW"
}
local var_0_29 = {
	"\aFF0110FFGlobal",
	"\aFF0110FFStand",
	"\aFF0110FFMove",
	"\aFF0110FFAir",
	"\aFF0110FFAir-crouch",
	"\aFF0110FFCrouch",
	"\aFF0110FFSlow-walk"
}
local var_0_30 = 0
local var_0_31 = 0

local function var_0_32()
	local var_10_0 = globals.tickcount()
	local var_10_1 = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
	local var_10_2 = var_10_1 - var_0_30

	if var_10_2 < 0 then
		var_0_31 = var_10_0 + math.abs(var_10_2) - toticks(client.latency())
	end

	var_0_30 = var_10_1

	return var_10_0 < var_0_31
end

local function var_0_33()
	for iter_11_0, iter_11_1 in ipairs(entity.get_players(true)) do
		local var_11_0 = entity.get_esp_data(iter_11_1).flags

		if var_0_6.band(var_11_0, var_0_6.lshift(1, 11)) ~= 0 then
			return true
		end
	end

	return false
end

local function var_0_34(arg_12_0, arg_12_1, arg_12_2)
	return {
		x = arg_12_0 or 0,
		y = arg_12_1 or 0,
		z = arg_12_2 or 0
	}
end

function contains(arg_13_0, arg_13_1)
	for iter_13_0, iter_13_1 in next, arg_13_0 do
		if iter_13_1 == arg_13_1 then
			return true
		end
	end

	return false
end

var_0_2.accent = "C3C6FFFF"

local var_0_35 = var_0_2.group("aa", "anti-aimbot angles")
local var_0_36 = {
	lua = {
		enable = var_0_35:checkbox("\aFF0110FF☭\v OMICRON.LUA"),
		tab = var_0_35:combobox("\n ", "\aFF0110FFHome", "\aFF0110FFRagebot", "\aFF0110FFVisuals", "\aFF0110FFAnti-aim", "\aFF0110FFMiscellaneous")
	},
	home = {
		infolabel1 = var_0_35:label("\aFF0110FF➜\v WELCOME TO\aFF0110FF OMICRON.LUA"),
		infolabel2 = var_0_35:label("\aFF0110FF➜\v BUILD:\aFF0110FF N1"),
		infolabel3 = var_0_35:label("\aFF0110FF➜\v LUA OWNER:\aFF0110FF dolboeb"),
		infolabel4 = var_0_35:label("\aFF0110FF➜\v LAST UPDATE:\aFF0110FF хуй знает"),
		infolabel5 = var_0_35:label("\aFF0110FF➜\v LUA USER:\aFF0110FF " .. var_0_16),
		discord = var_0_35:button("\aFF0110FFDiscord Lua", function()
			panorama.loadstring(panorama.open("CSGOHud").SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/WYzZg8pq8S"))
		end)
	},
	ragebot = {
		label33 = var_0_35:label("\aFF0110FFGET OUT")
	},
	visuals = {
		label = var_0_35:label("\aFF0110FFGO IN VISUALS > EFFECTS")
	},
	antiaim = {
		enable = var_0_35:checkbox("\aFF0110FFEnable"),
		tab = var_0_35:combobox("\vAnti-aim tab", "\aFF0110FFBuilder", "\aFF0110FFSettings"),
		condition = var_0_35:combobox("\vConditions", var_0_29),
		freestanding = var_0_35:hotkey("\aFF0110FF◯\v Freestanding"),
		edge_yaw = var_0_35:hotkey("\aFF0110FF⭮\v  Edge Yaw"),
		cfg_export = var_0_35:button("\vExport anti-aim settings", function()
			config.export()
		end),
		cfg_import = var_0_35:button("\vImport anti-aim settings", function()
			config.import()
		end),
		cfg_reset = var_0_35:button("\aFF0110FFReset anti-aim settings", function()
			config.import("W3siZW5hYmxlIjp0cnVlLCJ0YWIiOiJTZXR0aW5ncyIsImZyZWVzdGFuZGluZyI6WzEsMCwifiJdLCJjb25kaXRpb24iOiJHbG9iYWwiLCJlZGdlX3lhdyI6WzEsMCwifiJdLCJ0d2Vha3MiOlsifiJdfSxbeyJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwiZnJlZXN0YW5kX2JvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJ5YXdfdmFsdWUiOjAsIm92ZXJyaWRlIjp0cnVlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd192YWx1ZSI6MCwib3ZlcnJpZGUiOmZhbHNlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfV0sW3siZGVmZW5zaXZlX21vZGlmaWVycyI6ZmFsc2UsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6ZmFsc2UsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOmZhbHNlLCJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImRlZmVuc2l2ZV9hYV9lbmFibGUiOmZhbHNlLCJib2R5X3lhdyI6Ik9mZiIsInlhdyI6Ik9mZiIsInlhd192YWx1ZSI6MCwieWF3X2ppdHRlcl92YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsImJvZHlfeWF3X3ZhbHVlIjowLCJwaXRjaF92YWx1ZSI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZX0seyJkZWZlbnNpdmVfbW9kaWZpZXJzIjpmYWxzZSwieWF3X2Jhc2UiOiJMb2NhbCB2aWV3IiwicGl0Y2giOiJPZmYiLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjpmYWxzZSwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJ5YXdfdmFsdWUiOjAsInlhd19qaXR0ZXJfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6ZmFsc2UsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6ZmFsc2UsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOmZhbHNlLCJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImRlZmVuc2l2ZV9hYV9lbmFibGUiOmZhbHNlLCJib2R5X3lhdyI6Ik9mZiIsInlhdyI6Ik9mZiIsInlhd192YWx1ZSI6MCwieWF3X2ppdHRlcl92YWx1ZSI6MCwieWF3X2ppdHRlciI6Ik9mZiIsImJvZHlfeWF3X3ZhbHVlIjowLCJwaXRjaF92YWx1ZSI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZX0seyJkZWZlbnNpdmVfbW9kaWZpZXJzIjpmYWxzZSwieWF3X2Jhc2UiOiJMb2NhbCB2aWV3IiwicGl0Y2giOiJPZmYiLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjpmYWxzZSwiYm9keV95YXciOiJPZmYiLCJ5YXciOiJPZmYiLCJ5YXdfdmFsdWUiOjAsInlhd19qaXR0ZXJfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJib2R5X3lhd192YWx1ZSI6MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6ZmFsc2UsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6ZmFsc2UsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlfV1d")
		end),
		cfg_default = var_0_35:button("\vLoad default settings", function()
			config.import("W3siZW5hYmxlIjp0cnVlLCJ0YWIiOiJcdTAwMDdGRjAxMTBGRlNldHRpbmdzIiwiZnJlZXN0YW5kaW5nIjpbMiw3MiwifiJdLCJlZGdlX3lhdyI6WzEsNzcsIn4iXSwiY29uZGl0aW9uIjoiXHUwMDA3RkYwMTEwRkZDcm91Y2gifSxbeyJ5YXdfYmFzZSI6IkxvY2FsIHZpZXciLCJwaXRjaCI6Ik9mZiIsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwiZnJlZXN0YW5kX2JvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfdmFsdWUiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJ5YXdfdmFsdWUiOjAsIm92ZXJyaWRlIjp0cnVlLCJ5YXdfaml0dGVyX3ZhbHVlIjowfSx7Inlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiRG93biIsImJvZHlfeWF3IjoiT3Bwb3NpdGUiLCJ5YXciOiIxODAiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MTgwLCJ5YXdfaml0dGVyIjoiUmFuZG9tIiwieWF3X3ZhbHVlIjoxOSwib3ZlcnJpZGUiOnRydWUsInlhd19qaXR0ZXJfdmFsdWUiOjI5fSx7Inlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiRG93biIsImJvZHlfeWF3IjoiT3Bwb3NpdGUiLCJ5YXciOiIxODAiLCJmcmVlc3RhbmRfYm9keV95YXciOmZhbHNlLCJib2R5X3lhd192YWx1ZSI6MTgwLCJ5YXdfaml0dGVyIjoiUmFuZG9tIiwieWF3X3ZhbHVlIjotMjIsIm92ZXJyaWRlIjp0cnVlLCJ5YXdfaml0dGVyX3ZhbHVlIjo0MH0seyJ5YXdfYmFzZSI6IkF0IHRhcmdldHMiLCJwaXRjaCI6IkRvd24iLCJib2R5X3lhdyI6Ik9wcG9zaXRlIiwieWF3IjoiMTgwIiwiZnJlZXN0YW5kX2JvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfdmFsdWUiOjE4MCwieWF3X2ppdHRlciI6IlJhbmRvbSIsInlhd192YWx1ZSI6MjIsIm92ZXJyaWRlIjp0cnVlLCJ5YXdfaml0dGVyX3ZhbHVlIjotMzF9LHsieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJPcHBvc2l0ZSIsInlhdyI6IjE4MCIsImZyZWVzdGFuZF9ib2R5X3lhdyI6ZmFsc2UsImJvZHlfeWF3X3ZhbHVlIjoxODAsInlhd19qaXR0ZXIiOiJSYW5kb20iLCJ5YXdfdmFsdWUiOjIyLCJvdmVycmlkZSI6dHJ1ZSwieWF3X2ppdHRlcl92YWx1ZSI6MjR9LHsieWF3X2Jhc2UiOiJMb2NhbCB2aWV3IiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJPcHBvc2l0ZSIsInlhdyI6IjE4MCIsImZyZWVzdGFuZF9ib2R5X3lhdyI6ZmFsc2UsImJvZHlfeWF3X3ZhbHVlIjoxODAsInlhd19qaXR0ZXIiOiJSYW5kb20iLCJ5YXdfdmFsdWUiOjE5LCJvdmVycmlkZSI6dHJ1ZSwieWF3X2ppdHRlcl92YWx1ZSI6Mjh9LHsieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiYm9keV95YXciOiJPcHBvc2l0ZSIsInlhdyI6IjE4MCIsImZyZWVzdGFuZF9ib2R5X3lhdyI6ZmFsc2UsImJvZHlfeWF3X3ZhbHVlIjoxODAsInlhd19qaXR0ZXIiOiJSYW5kb20iLCJ5YXdfdmFsdWUiOi0xNywib3ZlcnJpZGUiOnRydWUsInlhd19qaXR0ZXJfdmFsdWUiOjIyfV0sW3siZGVmZW5zaXZlX21vZGlmaWVycyI6ZmFsc2UsInlhd19iYXNlIjoiTG9jYWwgdmlldyIsInBpdGNoIjoiT2ZmIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6ZmFsc2UsImJvZHlfeWF3IjoiT2ZmIiwieWF3IjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJ5YXdfaml0dGVyX3ZhbHVlIjowLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYm9keV95YXdfdmFsdWUiOjAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOnRydWUsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiRG93biIsImRlZmVuc2l2ZV9hYV9lbmFibGUiOnRydWUsImJvZHlfeWF3IjoiT3Bwb3NpdGUiLCJ5YXciOiIxODAiLCJ5YXdfdmFsdWUiOi0yMiwieWF3X2ppdHRlcl92YWx1ZSI6NTQsInlhd19qaXR0ZXIiOiJSYW5kb20iLCJib2R5X3lhd192YWx1ZSI6MTgwLCJwaXRjaF92YWx1ZSI6MCwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlfSx7ImRlZmVuc2l2ZV9tb2RpZmllcnMiOnRydWUsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInBpdGNoIjoiRG93biIsImRlZmVuc2l2ZV9hYV9lbmFibGUiOnRydWUsImJvZHlfeWF3IjoiT3Bwb3NpdGUiLCJ5YXciOiIxODAiLCJ5YXdfdmFsdWUiOjIyLCJ5YXdfaml0dGVyX3ZhbHVlIjoyNCwieWF3X2ppdHRlciI6IlJhbmRvbSIsImJvZHlfeWF3X3ZhbHVlIjoxODAsInBpdGNoX3ZhbHVlIjowLCJmb3JjZV9kZWZlbnNpdmUiOnRydWV9LHsiZGVmZW5zaXZlX21vZGlmaWVycyI6dHJ1ZSwieWF3X2Jhc2UiOiJBdCB0YXJnZXRzIiwicGl0Y2giOiJEb3duIiwiZGVmZW5zaXZlX2FhX2VuYWJsZSI6dHJ1ZSwiYm9keV95YXciOiJPZmYiLCJ5YXciOiIxODAiLCJ5YXdfdmFsdWUiOi0yNCwieWF3X2ppdHRlcl92YWx1ZSI6LTUyLCJ5YXdfaml0dGVyIjoiUmFuZG9tIiwiYm9keV95YXdfdmFsdWUiOjE4MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZX0seyJkZWZlbnNpdmVfbW9kaWZpZXJzIjp0cnVlLCJ5YXdfYmFzZSI6IkF0IHRhcmdldHMiLCJwaXRjaCI6IkRvd24iLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjp0cnVlLCJib2R5X3lhdyI6Ik9wcG9zaXRlIiwieWF3IjoiMTgwIiwieWF3X3ZhbHVlIjotMjIsInlhd19qaXR0ZXJfdmFsdWUiOjQ5LCJ5YXdfaml0dGVyIjoiUmFuZG9tIiwiYm9keV95YXdfdmFsdWUiOjE4MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZX0seyJkZWZlbnNpdmVfbW9kaWZpZXJzIjp0cnVlLCJ5YXdfYmFzZSI6IkF0IHRhcmdldHMiLCJwaXRjaCI6IkRvd24iLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjp0cnVlLCJib2R5X3lhdyI6Ik9wcG9zaXRlIiwieWF3IjoiMTgwIiwieWF3X3ZhbHVlIjotMTgsInlhd19qaXR0ZXJfdmFsdWUiOjUyLCJ5YXdfaml0dGVyIjoiUmFuZG9tIiwiYm9keV95YXdfdmFsdWUiOjE4MCwicGl0Y2hfdmFsdWUiOjAsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZX0seyJkZWZlbnNpdmVfbW9kaWZpZXJzIjp0cnVlLCJ5YXdfYmFzZSI6IkF0IHRhcmdldHMiLCJwaXRjaCI6IkRvd24iLCJkZWZlbnNpdmVfYWFfZW5hYmxlIjp0cnVlLCJib2R5X3lhdyI6Ik9wcG9zaXRlIiwieWF3IjoiMTgwIiwieWF3X3ZhbHVlIjoyNiwieWF3X2ppdHRlcl92YWx1ZSI6NDcsInlhd19qaXR0ZXIiOiJSYW5kb20iLCJib2R5X3lhd192YWx1ZSI6MTgwLCJwaXRjaF92YWx1ZSI6MCwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlfV1d")
		end)
	},
	misc = {
		console_filter = var_0_35:checkbox("\aFF0110FF•\v  Console Filter"),
		discharge = var_0_35:checkbox("\aFF0110FF⚠ \vExperimental Auto Recharge Double Tap Exploit"),
		d_mode = var_0_35:combobox("\vMode", "\aFF0110FFInstant", "\aFF0110FFIdeal")
	}
}

var_0_36.home.infolabel1:depend({
	var_0_36.lua.enable,
	true
}, {
	var_0_36.lua.tab,
	"\aFF0110FFHome"
})
var_0_36.home.infolabel2:depend({
	var_0_36.lua.enable,
	true
}, {
	var_0_36.lua.tab,
	"\aFF0110FFHome"
})
var_0_36.home.infolabel3:depend({
	var_0_36.lua.enable,
	true
}, {
	var_0_36.lua.tab,
	"\aFF0110FFHome"
})
var_0_36.home.infolabel4:depend({
	var_0_36.lua.enable,
	true
}, {
	var_0_36.lua.tab,
	"\aFF0110FFHome"
})
var_0_36.ragebot.label33:depend({
	var_0_36.lua.enable,
	true
}, {
	var_0_36.lua.tab,
	"\aFF0110FFRagebot"
})
var_0_36.visuals.label:depend({
	var_0_36.lua.enable,
	true
}, {
	var_0_36.lua.tab,
	"\aFF0110FFVisuals"
})
var_0_36.home.infolabel5:depend({
	var_0_36.lua.enable,
	true
}, {
	var_0_36.lua.tab,
	"\aFF0110FFHome"
})
var_0_36.home.discord:depend({
	var_0_36.lua.enable,
	true
}, {
	var_0_36.lua.tab,
	"\aFF0110FFHome"
})

aa_builder = {}
aa_builder_defensive = {}

for iter_0_0 = 1, 7 do
	aa_builder[iter_0_0] = {}
	aa_builder[iter_0_0].override = var_0_35:checkbox("\v➤  Override  " .. var_0_29[iter_0_0] .. "  \v➤  Player State")
	aa_builder[iter_0_0].pitch = var_0_35:combobox(var_0_29[iter_0_0] .. "  \v⮞  Pitch", "Off", "Default", "Down", "Up", "Minimal", "Random")
	aa_builder[iter_0_0].yaw_base = var_0_35:combobox(var_0_29[iter_0_0] .. "  \v⮞  Yaw Base", "Local view", "At targets")
	aa_builder[iter_0_0].yaw = var_0_35:combobox(var_0_29[iter_0_0] .. "  \v⮞  Yaw", "Off", "180", "Spin", "Static", "180 Z", "Crosshair")
	aa_builder[iter_0_0].yaw_value = var_0_35:slider(var_0_29[iter_0_0] .. "  \v⮞  Yaw Offset", -180, 180, 0)
	aa_builder[iter_0_0].yaw_jitter = var_0_35:combobox(var_0_29[iter_0_0] .. "  \v⮞  Yaw Jitter", "Off", "Offset", "Center", "Random", "Skitter")
	aa_builder[iter_0_0].yaw_jitter_value = var_0_35:slider(var_0_29[iter_0_0] .. "  \v⮞  Yaw Jitter Value", -180, 180, 0)
	aa_builder[iter_0_0].body_yaw = var_0_35:combobox(var_0_29[iter_0_0] .. "  \v⮞  Body Yaw", "Off", "Opposite", "Jitter", "Static")
	aa_builder[iter_0_0].body_yaw_value = var_0_35:slider(var_0_29[iter_0_0] .. "  \v⮞  Body Yaw Value", -180, 180, 0)
	aa_builder[iter_0_0].freestand_body_yaw = var_0_35:checkbox(var_0_29[iter_0_0] .. "  \v⮞  Freestanding Body Yaw")
	aa_builder_defensive[iter_0_0] = {}
	aa_builder_defensive[iter_0_0].defensive_modifiers = var_0_35:checkbox(var_0_29[iter_0_0] .. "  \v⮞ Defensive Modifiers")
	aa_builder_defensive[iter_0_0].force_defensive = var_0_35:checkbox(var_0_29[iter_0_0] .. "  \v⮞ Force Defensive")
	aa_builder_defensive[iter_0_0].defensive_aa_enable = var_0_35:checkbox(var_0_29[iter_0_0] .. "  \v⮞ Defensive Anti-Aim")
	aa_builder_defensive[iter_0_0].pitch = var_0_35:combobox(var_0_29[iter_0_0] .. "  \v⮞ Defensive Pitch", "Off", "Default", "Down", "Up", "Minimal", "Random", "Custom")
	aa_builder_defensive[iter_0_0].pitch_value = var_0_35:slider(var_0_29[iter_0_0] .. "  \v⮞ Defensive Pitch Value", -89, 89, 0)
	aa_builder_defensive[iter_0_0].yaw_base = var_0_35:combobox(var_0_29[iter_0_0] .. "  \v⮞ Defensive Yaw Base", "Local view", "At targets")
	aa_builder_defensive[iter_0_0].yaw = var_0_35:combobox(var_0_29[iter_0_0] .. "  \v⮞ Defensive Yaw", "Off", "180", "Spin", "Static", "180 Z", "Crosshair")
	aa_builder_defensive[iter_0_0].yaw_value = var_0_35:slider(var_0_29[iter_0_0] .. "  \v⮞ Defensive Yaw Offset", -180, 180, 0)
	aa_builder_defensive[iter_0_0].yaw_jitter = var_0_35:combobox(var_0_29[iter_0_0] .. "  \v⮞ Defensive Yaw Jitter", "Off", "Offset", "Center", "Random", "Skitter")
	aa_builder_defensive[iter_0_0].yaw_jitter_value = var_0_35:slider(var_0_29[iter_0_0] .. "  \v⮞ Defensive Yaw Jitter Value", -180, 180, 0)
	aa_builder_defensive[iter_0_0].body_yaw = var_0_35:combobox(var_0_29[iter_0_0] .. "  \v⮞ Defensive Body Yaw", "Off", "Opposite", "Jitter", "Static")
	aa_builder_defensive[iter_0_0].body_yaw_value = var_0_35:slider(var_0_29[iter_0_0] .. "  \v⮞ Defensive Body Yaw Value", -180, 180, 0)
end

var_0_36.lua.tab:depend({
	var_0_36.lua.enable,
	true
})
var_0_36.antiaim.enable:depend({
	var_0_36.lua.enable,
	true
}, {
	var_0_36.lua.tab,
	"\aFF0110FFAnti-aim"
})
var_0_36.antiaim.tab:depend({
	var_0_36.lua.enable,
	true
}, {
	var_0_36.lua.tab,
	"\aFF0110FFAnti-aim"
}, {
	var_0_36.antiaim.enable,
	true
})
var_0_36.antiaim.condition:depend({
	var_0_36.lua.enable,
	true
}, {
	var_0_36.lua.tab,
	"\aFF0110FFAnti-aim"
}, {
	var_0_36.antiaim.enable,
	true
}, {
	var_0_36.antiaim.tab,
	"\aFF0110FFBuilder"
})

for iter_0_1 = 1, 7 do
	aa_builder[iter_0_1].override:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	})
	aa_builder[iter_0_1].pitch:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder[iter_0_1].override,
		true
	})
	aa_builder[iter_0_1].yaw_base:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder[iter_0_1].override,
		true
	})
	aa_builder[iter_0_1].yaw:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder[iter_0_1].override,
		true
	})
	aa_builder[iter_0_1].yaw_value:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder[iter_0_1].override,
		true
	}, {
		aa_builder[iter_0_1].yaw,
		"180",
		"Spin",
		"Static",
		"180 Z"
	})
	aa_builder[iter_0_1].yaw_jitter:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder[iter_0_1].override,
		true
	})
	aa_builder[iter_0_1].yaw_jitter_value:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder[iter_0_1].override,
		true
	}, {
		aa_builder[iter_0_1].yaw_jitter,
		"Offset",
		"Center",
		"Random",
		"Skitter"
	})
	aa_builder[iter_0_1].body_yaw:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder[iter_0_1].override,
		true
	})
	aa_builder[iter_0_1].body_yaw_value:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder[iter_0_1].override,
		true
	}, {
		aa_builder[iter_0_1].body_yaw,
		"Jitter",
		"Static"
	})
	aa_builder[iter_0_1].freestand_body_yaw:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder[iter_0_1].override,
		true
	}, {
		aa_builder[iter_0_1].body_yaw,
		"Opposite",
		"Jitter",
		"Static"
	})
	aa_builder_defensive[iter_0_1].defensive_modifiers:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder[iter_0_1].override,
		true
	})
	aa_builder_defensive[iter_0_1].force_defensive:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder_defensive[iter_0_1].defensive_modifiers,
		true
	}, {
		aa_builder[iter_0_1].override,
		true
	})
	aa_builder_defensive[iter_0_1].defensive_aa_enable:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder_defensive[iter_0_1].defensive_modifiers,
		true
	}, {
		aa_builder[iter_0_1].override,
		true
	})
	aa_builder_defensive[iter_0_1].pitch:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder_defensive[iter_0_1].defensive_modifiers,
		true
	}, {
		aa_builder[iter_0_1].override,
		true
	}, {
		aa_builder_defensive[iter_0_1].defensive_aa_enable,
		true
	})
	aa_builder_defensive[iter_0_1].pitch_value:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder_defensive[iter_0_1].pitch,
		"Custom"
	}, {
		aa_builder_defensive[iter_0_1].defensive_modifiers,
		true
	}, {
		aa_builder[iter_0_1].override,
		true
	}, {
		aa_builder_defensive[iter_0_1].defensive_aa_enable,
		true
	})
	aa_builder_defensive[iter_0_1].yaw_base:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder_defensive[iter_0_1].defensive_modifiers,
		true
	}, {
		aa_builder[iter_0_1].override,
		true
	}, {
		aa_builder_defensive[iter_0_1].defensive_aa_enable,
		true
	})
	aa_builder_defensive[iter_0_1].yaw:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder_defensive[iter_0_1].defensive_modifiers,
		true
	}, {
		aa_builder[iter_0_1].override,
		true
	}, {
		aa_builder_defensive[iter_0_1].defensive_aa_enable,
		true
	})
	aa_builder_defensive[iter_0_1].yaw_value:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder_defensive[iter_0_1].defensive_modifiers,
		true
	}, {
		aa_builder_defensive[iter_0_1].yaw,
		"180",
		"Spin",
		"Static",
		"180 Z"
	}, {
		aa_builder[iter_0_1].override,
		true
	}, {
		aa_builder_defensive[iter_0_1].defensive_aa_enable,
		true
	})
	aa_builder_defensive[iter_0_1].yaw_jitter:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder_defensive[iter_0_1].defensive_modifiers,
		true
	}, {
		aa_builder[iter_0_1].override,
		true
	}, {
		aa_builder_defensive[iter_0_1].defensive_aa_enable,
		true
	})
	aa_builder_defensive[iter_0_1].yaw_jitter_value:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder_defensive[iter_0_1].defensive_modifiers,
		true
	}, {
		aa_builder_defensive[iter_0_1].yaw_jitter,
		"Offset",
		"Center",
		"Random",
		"Skitter"
	}, {
		aa_builder[iter_0_1].override,
		true
	}, {
		aa_builder_defensive[iter_0_1].defensive_aa_enable,
		true
	})
	aa_builder_defensive[iter_0_1].body_yaw:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder_defensive[iter_0_1].defensive_modifiers,
		true
	}, {
		aa_builder[iter_0_1].override,
		true
	}, {
		aa_builder_defensive[iter_0_1].defensive_aa_enable,
		true
	})
	aa_builder_defensive[iter_0_1].body_yaw_value:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFBuilder"
	}, {
		var_0_36.antiaim.condition,
		var_0_29[iter_0_1]
	}, {
		aa_builder_defensive[iter_0_1].defensive_modifiers,
		true
	}, {
		aa_builder_defensive[iter_0_1].body_yaw,
		"Jitter",
		"Static"
	}, {
		aa_builder[iter_0_1].override,
		true
	}, {
		aa_builder_defensive[iter_0_1].defensive_aa_enable,
		true
	})
end

for iter_0_2, iter_0_3 in pairs({
	var_0_36.antiaim.tweaks,
	var_0_36.antiaim.freestanding,
	var_0_36.antiaim.anti_backstab_checkbox,
	var_0_36.antiaim.edge_yaw,
	var_0_36.antiaim.cfg_export,
	var_0_36.antiaim.cfg_import,
	var_0_36.antiaim.cfg_reset,
	var_0_36.antiaim.cfg_default
}) do
	iter_0_3:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFAnti-aim"
	}, {
		var_0_36.antiaim.enable,
		true
	}, {
		var_0_36.antiaim.tab,
		"\aFF0110FFSettings"
	})
end

for iter_0_4, iter_0_5 in pairs({
	var_0_36.misc.console_filter,
	var_0_36.misc.discharge
}) do
	iter_0_5:depend({
		var_0_36.lua.enable,
		true
	}, {
		var_0_36.lua.tab,
		"\aFF0110FFMiscellaneous"
	})
end

var_0_36.misc.d_mode:depend({
	var_0_36.lua.enable,
	true
}, {
	var_0_36.lua.tab,
	"\aFF0110FFMiscellaneous"
}, {
	var_0_36.misc.discharge,
	true
})

local function var_0_37(arg_19_0)
	arg_19_0 = not arg_19_0

	ui.set_visible(var_0_18.aa_enable, arg_19_0)
	ui.set_visible(var_0_18.pitch, arg_19_0)
	ui.set_visible(var_0_18.pitch_value, arg_19_0)
	ui.set_visible(var_0_18.yaw_base, arg_19_0)
	ui.set_visible(var_0_18.yaw, arg_19_0)
	ui.set_visible(var_0_18.yaw_value, arg_19_0)
	ui.set_visible(var_0_18.yaw_jitter, arg_19_0)
	ui.set_visible(var_0_18.yaw_jitter_value, arg_19_0)
	ui.set_visible(var_0_18.body_yaw, arg_19_0)
	ui.set_visible(var_0_18.body_yaw_value, arg_19_0)
	ui.set_visible(var_0_18.edgeyaw, arg_19_0)
	ui.set_visible(var_0_18.freestand[1], arg_19_0)
	ui.set_visible(var_0_18.freestand[2], arg_19_0)
	ui.set_visible(var_0_18.roll, arg_19_0)
	ui.set_visible(var_0_18.freestand_body_yaw, arg_19_0)
end

local var_0_38 = {
	var_0_36.antiaim,
	aa_builder,
	aa_builder_defensive
}
local var_0_39 = var_0_2.setup(var_0_38)
local var_0_40 = ""
local var_0_41 = ""
local var_0_42 = ""

config = {}

function config.export()
	var_0_40 = var_0_39:save()
	var_0_41 = var_0_3.encode(json.stringify(var_0_40))

	var_0_27(var_0_41)
end

function config.import(arg_21_0)
	var_0_42 = json.parse(var_0_3.decode(arg_21_0 ~= nil and arg_21_0 or clipboard_import()))

	var_0_39:load(var_0_42)
end

local function var_0_43(arg_22_0)
	local var_22_0 = false

	return not (arg_22_0.allow_send_packet ~= false and not (arg_22_0.chokedcommands > 1)) and true or false
end

local function var_0_44(arg_23_0)
	if not var_0_36.antiaim.enable.value or not var_0_36.lua.enable.value or not entity.get_local_player() then
		return
	end

	local var_23_0 = get_state(get_velocity())
	local var_23_1 = entity.get_players(false)
	local var_23_2 = aa_builder[var_23_0].override.value and var_23_0 or 1

	arg_23_0.force_defensive = aa_builder_defensive[var_23_2].force_defensive.value and true

	ui.set(var_0_18.freestand[1], ui.get(var_0_36.antiaim.freestanding.ref) and true or false)
	ui.set(var_0_18.edgeyaw, ui.get(var_0_36.antiaim.edge_yaw.ref) and true or false)
	ui.set(var_0_18.roll, 0)
	ui.set(var_0_18.freestand[2], "always on")

	for iter_23_0, iter_23_1 in pairs(var_0_18) do
		local var_23_3 = var_0_32() and not var_0_43(arg_23_0) and aa_builder_defensive[var_23_2].defensive_modifiers.value and aa_builder_defensive[var_23_2].defensive_aa_enable.value and aa_builder_defensive[var_23_2][iter_23_0] or aa_builder[var_23_2][iter_23_0]

		if var_23_3 then
			ui.set(iter_23_1, var_23_3.value)
		end
	end
end

local var_0_45 = client.latency
local var_0_46 = client.screen_size
local var_0_47 = client.set_event_callback
local var_0_48 = client.system_time
local var_0_49 = entity.get_local_player
local var_0_50 = entity.get_player_resource
local var_0_51 = entity.get_prop
local var_0_52 = globals.absoluteframetime
local var_0_53 = globals.tickinterval
local var_0_54 = math.ceil
local var_0_55 = math.floor
local var_0_56 = math.min
local var_0_57 = math.sqrt
local var_0_58 = renderer.measure_text
local var_0_59 = ui.reference
local var_0_60 = pcall
local var_0_61 = renderer.gradient
local var_0_62 = renderer.rectangle
local var_0_63 = renderer.text
local var_0_64 = string.format
local var_0_65 = table.insert
local var_0_66 = ui.get
local var_0_67 = ui.new_checkbox
local var_0_68 = ui.new_color_picker
local var_0_69 = ui.new_multiselect
local var_0_70 = ui.new_textbox
local var_0_71 = ui.set
local var_0_72 = ui.set_callback
local var_0_73 = ui.set_visible
local var_0_74 = "d"
local var_0_75 = var_0_63
local var_0_76 = var_0_58

local function var_0_77(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7, ...)
	return var_0_75(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6 == nil and var_0_74 or var_0_74 .. arg_24_6, arg_24_7, ...)
end

local function var_0_78(arg_25_0, ...)
	return var_0_76(arg_25_0 == nil and var_0_74 or var_0_74 .. arg_25_0, ...)
end

local var_0_79 = var_0_60(client.create_interface)
local var_0_80 = 0
local var_0_81 = 1
local var_0_82
local var_0_83
local var_0_84
local var_0_85
local var_0_86
local var_0_87
local var_0_88

if var_0_79 then
	local var_0_89 = require("ffi")

	local function var_0_90(arg_26_0, arg_26_1, arg_26_2)
		return var_0_89.cast(arg_26_2, var_0_89.cast("void***", arg_26_0)[0][arg_26_1])
	end

	local function var_0_91(arg_27_0, arg_27_1)
		local var_27_0 = var_0_89.typeof(arg_27_1)

		return function(arg_28_0, ...)
			assert(arg_28_0 ~= nil)

			if arg_28_0 then
				return var_0_90(arg_28_0, arg_27_0, var_27_0)(arg_28_0, ...)
			end
		end
	end

	var_0_82 = (function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
		if not client.create_interface(arg_29_0, arg_29_1) then
			local var_29_0 = error("invalid interface")
		end

		local var_29_1 = client.create_interface(arg_29_0, arg_29_1) or error("invalid interface")
		local var_29_2 = var_0_90(var_29_1, arg_29_2, var_0_89.typeof(arg_29_3)) or error("invalid vtable")

		return function(...)
			return var_29_2(var_29_1, ...)
		end
	end)("engine.dll", "VEngineClient014", 78, "void*(__thiscall*)(void*)")

	local var_0_92 = var_0_91(0, "const char*(__thiscall*)(void*)")
	local var_0_93 = var_0_91(1, "const char*(__thiscall*)(void*)")

	var_0_87 = var_0_91(6, "bool(__thiscall*)(void*)")

	local var_0_94 = var_0_91(7, "bool(__thiscall*)(void*)")

	var_0_86 = var_0_91(11, "float(__thiscall*)(void*, int)")
	var_0_85 = var_0_91(12, "float(__thiscall*)(void*, int)")
	var_0_84 = var_0_91(22, "float(__thiscall*)(void*)")

	local var_0_95 = var_0_91(25, "void(__thiscall*)(void*, float*, float*, float*)")
	local var_0_96 = var_0_91(26, "float(__thiscall*)(void*)")
	local var_0_97 = var_0_89.new("float[1]")
	local var_0_98 = var_0_89.new("float[1]")
	local var_0_99 = var_0_89.new("float[1]")

	function var_0_83(arg_31_0)
		var_0_95(arg_31_0, var_0_97, var_0_98, var_0_99)

		if var_0_97 ~= nil and var_0_98 ~= nil and var_0_99 ~= nil then
			return var_0_97[0], var_0_98[0], var_0_99[0]
		end
	end

	function var_0_88(arg_32_0)
		local var_32_0 = var_0_93(arg_32_0)

		if var_32_0 ~= nil then
			return var_0_89.string(var_32_0)
		end
	end

	local function var_0_100(arg_33_0)
		local var_33_0 = var_0_92(arg_33_0)

		if var_33_0 ~= nil then
			return var_0_89.string(var_33_0)
		end
	end
end

local var_0_101 = cvar.game_mode
local var_0_102 = cvar.game_type
local var_0_103 = cvar.fps_max
local var_0_104 = cvar.fps_max_menu
local var_0_105 = require("table.clear")
local var_0_106 = (function()
	local var_34_0 = {}
	local var_34_1 = renderer.rectangle
	local var_34_2 = renderer.gradient
	local var_34_3 = renderer.texture
	local var_34_4 = math.floor
	local var_34_5 = math.ceil

	local function var_34_6(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7, arg_35_8)
		arg_35_8 = arg_35_8 or 1

		var_34_1(arg_35_0, arg_35_1, arg_35_2, arg_35_8, arg_35_4, arg_35_5, arg_35_6, arg_35_7)
		var_34_1(arg_35_0, arg_35_1 + arg_35_3 - arg_35_8, arg_35_2, arg_35_8, arg_35_4, arg_35_5, arg_35_6, arg_35_7)
		var_34_1(arg_35_0, arg_35_1 + arg_35_8, arg_35_8, arg_35_3 - arg_35_8 * 2, arg_35_4, arg_35_5, arg_35_6, arg_35_7)
		var_34_1(arg_35_0 + arg_35_2 - arg_35_8, arg_35_1 + arg_35_8, arg_35_8, arg_35_3 - arg_35_8 * 2, arg_35_4, arg_35_5, arg_35_6, arg_35_7)
	end

	local function var_34_7(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8, arg_36_9, arg_36_10, arg_36_11, arg_36_12, arg_36_13)
		arg_36_13 = arg_36_13 or 1

		if arg_36_12 then
			var_34_1(arg_36_0, arg_36_1, arg_36_13, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7)
			var_34_1(arg_36_0 + arg_36_2 - arg_36_13, arg_36_1, arg_36_13, arg_36_3, arg_36_8, arg_36_9, arg_36_10, arg_36_11)
			var_34_2(arg_36_0 + arg_36_13, arg_36_1, arg_36_2 - arg_36_13 * 2, arg_36_13, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8, arg_36_9, arg_36_10, arg_36_7, true)
			var_34_2(arg_36_0 + arg_36_13, arg_36_1 + arg_36_3 - arg_36_13, arg_36_2 - arg_36_13 * 2, arg_36_13, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8, arg_36_9, arg_36_10, arg_36_7, true)
		else
			var_34_1(arg_36_0, arg_36_1, arg_36_2, arg_36_13, arg_36_4, arg_36_5, arg_36_6, arg_36_7)
			var_34_1(arg_36_0, arg_36_1 + arg_36_3 - arg_36_13, arg_36_2, arg_36_13, arg_36_8, arg_36_9, arg_36_10, arg_36_11)
			var_34_2(arg_36_0, arg_36_1 + arg_36_13, arg_36_13, arg_36_3 - arg_36_13 * 2, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8, arg_36_9, arg_36_10, arg_36_11, false)
			var_34_2(arg_36_0 + arg_36_2 - arg_36_13, arg_36_1 + arg_36_13, arg_36_13, arg_36_3 - arg_36_13 * 2, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8, arg_36_9, arg_36_10, arg_36_11, false)
		end
	end

	local var_34_8
	local var_34_9 = "\x14\x14\x14\xFF"
	local var_34_10 = "\f\f\f\xFF"
	local var_34_11 = renderer.load_rgba(table.concat({
		var_34_9,
		var_34_9,
		var_34_9,
		var_34_10,
		var_34_9,
		var_34_10,
		var_34_9,
		var_34_10,
		var_34_9,
		var_34_10,
		var_34_9,
		var_34_9,
		var_34_9,
		var_34_10,
		var_34_9,
		var_34_10
	}), 4, 4)

	local function var_34_12(arg_37_0, arg_37_1)
		if arg_37_1 ~= nil and type(arg_37_0) == "string" and arg_37_0:sub(-1, -1) == "%" then
			arg_37_0 = math.floor(tonumber(arg_37_0:sub(1, -2)) / 100 * arg_37_1)
		end

		return arg_37_0
	end

	local function var_34_13(arg_38_0)
		if arg_38_0.position == "fixed" then
			local var_38_0, var_38_1 = client.screen_size()

			if arg_38_0.left ~= nil then
				arg_38_0.x = var_34_12(arg_38_0.left, var_38_0)
			elseif arg_38_0.right ~= nil then
				arg_38_0.x = var_38_0 - (arg_38_0.w or 0) - var_34_12(arg_38_0.right, var_38_0)
			end

			if arg_38_0.top ~= nil then
				arg_38_0.y = var_34_12(arg_38_0.top, var_38_1)
			elseif arg_38_0.bottom ~= nil then
				arg_38_0.y = var_38_1 - (arg_38_0.h or 0) - var_34_12(arg_38_0.bottom, var_38_1)
			end
		end

		local var_38_2 = arg_38_0.x
		local var_38_3 = arg_38_0.y
		local var_38_4 = arg_38_0.w
		local var_38_5 = arg_38_0.h
		local var_38_6 = arg_38_0.a or 255
		local var_38_7 = 1

		if var_38_2 == nil or var_38_3 == nil or var_38_4 == nil or var_38_6 == nil then
			return
		end

		arg_38_0.i_x, arg_38_0.i_y, arg_38_0.i_w, arg_38_0.i_h = arg_38_0.x, arg_38_0.y, arg_38_0.w, arg_38_0.h

		if arg_38_0.title_bar then
			var_38_7 = (arg_38_0.title ~= nil and select(2, renderer.measure_text(arg_38_0.title_text_size, arg_38_0.title)) or 13) + 2
			arg_38_0.t_x, arg_38_0.t_y, arg_38_0.t_w, arg_38_0.t_h = arg_38_0.x, arg_38_0.y, arg_38_0.w, var_38_7
		end

		if arg_38_0.border then
			var_34_6(var_38_2, var_38_3, var_38_4, var_38_5, 18, 18, 18, var_38_6)
			var_34_6(var_38_2 + 1, var_38_3 + 1, var_38_4 - 2, var_38_5 - 2, 62, 62, 62, var_38_6)
			var_34_6(var_38_2 + 2, var_38_3 + var_38_7 + 1, var_38_4 - 4, var_38_5 - var_38_7 - 3, 44, 44, 44, var_38_6, arg_38_0.border_width)
			var_34_6(var_38_2 + arg_38_0.border_width + 2, var_38_3 + var_38_7 + arg_38_0.border_width + 1, var_38_4 - arg_38_0.border_width * 2 - 4, var_38_5 - var_38_7 - arg_38_0.border_width * 2 - 3, 62, 62, 62, var_38_6)

			arg_38_0.i_x = arg_38_0.i_x + arg_38_0.border_width + 3
			arg_38_0.i_y = arg_38_0.i_y + arg_38_0.border_width + 3
			arg_38_0.i_w = arg_38_0.i_w - (arg_38_0.border_width + 3) * 2
			arg_38_0.i_h = arg_38_0.i_h - (arg_38_0.border_width + 3) * 2
			arg_38_0.t_x, arg_38_0.t_y, arg_38_0.t_w = arg_38_0.x + 2, arg_38_0.y + 2, arg_38_0.w - 4
			var_38_7 = var_38_7 - 1
		end

		if var_38_7 > 1 then
			var_34_2(arg_38_0.t_x, arg_38_0.t_y, arg_38_0.t_w, var_38_7, 56, 56, 56, var_38_6, 44, 44, 44, var_38_6, false)

			if arg_38_0.title ~= nil then
				local var_38_8, var_38_9, var_38_10, var_38_11 = unpack(arg_38_0.title_text_color)
				local var_38_12 = var_38_11 * arg_38_0.a / 255

				renderer.text(arg_38_0.t_x + 3, arg_38_0.t_y + 2, var_38_8 or 255, var_38_9 or 255, var_38_10 or 255, var_38_12 or 255, (arg_38_0.title_text_size or "") .. (arg_38_0.title_text_flags or ""), 0, tostring(arg_38_0.title))
			end

			arg_38_0.i_y = arg_38_0.i_y + var_38_7
			arg_38_0.i_h = arg_38_0.i_h - var_38_7
		end

		if arg_38_0.gradient_bar then
			local var_38_13 = 0

			if arg_38_0.background then
				var_38_13 = 1

				local var_38_14 = 16
				local var_38_15 = 25

				var_34_1(arg_38_0.i_x + 1, arg_38_0.i_y, arg_38_0.i_w - 2, 1, var_38_14, var_38_14, var_38_14, var_38_6)
				var_34_1(arg_38_0.i_x + 1, arg_38_0.i_y + 3, arg_38_0.i_w - 2, 1, var_38_15, var_38_15, var_38_15, var_38_6)

				for iter_38_0 = 0, 1 do
					var_34_2(arg_38_0.i_x + (arg_38_0.i_w - 1) * iter_38_0, arg_38_0.i_y, 1, 4, var_38_14, var_38_14, var_38_14, var_38_6, var_38_15, var_38_15, var_38_15, var_38_6, false)
				end
			end

			local var_38_16 = arg_38_0.i_x + var_38_13
			local var_38_17 = arg_38_0.i_y + var_38_13
			local var_38_18 = 1
			local var_38_19 = var_34_4((arg_38_0.i_w - var_38_13 * 2) / 2)
			local var_38_20 = var_34_5((arg_38_0.i_w - var_38_13 * 2) / 2)

			for iter_38_1 = 1, 2 do
				var_34_2(var_38_16, var_38_17, var_38_19, 1, 59 * var_38_18, 175 * var_38_18, 222 * var_38_18, var_38_6, 202 * var_38_18, 70 * var_38_18, 205 * var_38_18, var_38_6, true)
				var_34_2(var_38_16 + var_38_19, var_38_17, var_38_20, 1, 202 * var_38_18, 70 * var_38_18, 205 * var_38_18, var_38_6, 201 * var_38_18, 227 * var_38_18, 58 * var_38_18, var_38_6, true)

				var_38_17, var_38_18 = var_38_17 + 1, var_38_18 * 0.5
			end

			arg_38_0.i_y = arg_38_0.i_y + 2 + var_38_13 * 2
			arg_38_0.i_h = arg_38_0.i_h - 2 - var_38_13 * 2
		end

		if arg_38_0.background then
			var_34_3(var_34_11, arg_38_0.i_x, arg_38_0.i_y, arg_38_0.i_w, arg_38_0.i_h, 255, 255, 255, 255, "t")
		end

		if arg_38_0.draggable then
			local var_38_21 = 7

			renderer.triangle(var_38_2 + var_38_4 - 1, var_38_3 + var_38_5 - var_38_21, var_38_2 + var_38_4 - 1, var_38_3 + var_38_5 - 1, var_38_2 + var_38_4 - var_38_21, var_38_3 + var_38_5 - 1, 62, 62, 62, var_38_6)
		end

		arg_38_0.i_x = arg_38_0.i_x + arg_38_0.margin_left
		arg_38_0.i_w = arg_38_0.i_w - arg_38_0.margin_left - arg_38_0.margin_right
		arg_38_0.i_y = arg_38_0.i_y + arg_38_0.margin_top
		arg_38_0.i_h = arg_38_0.i_h - arg_38_0.margin_top - arg_38_0.margin_bottom
	end

	local var_34_14 = {}
	local var_34_15 = {}
	local var_34_16 = {}
	local var_34_17 = {
		__index = var_34_16
	}

	function var_34_16.set_active(arg_39_0, arg_39_1)
		if arg_39_1 then
			var_34_14[arg_39_0.id] = arg_39_0

			table.insert(var_34_15, 1, arg_39_0.id)
		else
			var_34_14[arg_39_0.id] = nil
		end
	end

	function var_34_16.set_z_index(arg_40_0, arg_40_1)
		arg_40_0.z_index = arg_40_1
		arg_40_0.z_index_reset = true
	end

	function var_34_16.is_in_window(arg_41_0, arg_41_1, arg_41_2)
		return arg_41_1 >= arg_41_0.x and arg_41_1 <= arg_41_0.x + arg_41_0.w and arg_41_2 >= arg_41_0.y and arg_41_2 <= arg_41_0.y + arg_41_0.h
	end

	function var_34_16.set_inner_width(arg_42_0, arg_42_1)
		if arg_42_0.border then
			arg_42_1 = arg_42_1 + (arg_42_0.border_width + 3) * 2
		end

		arg_42_1 = arg_42_1 + arg_42_0.margin_left + arg_42_0.margin_right
		arg_42_0.w = arg_42_1
	end

	function var_34_16.set_inner_height(arg_43_0, arg_43_1)
		local var_43_0 = 1

		if arg_43_0.title_bar then
			var_43_0 = (arg_43_0.title ~= nil and select(2, renderer.measure_text(arg_43_0.title_text_size, arg_43_0.title)) or 13) + 2
		end

		if arg_43_0.border then
			arg_43_1 = arg_43_1 + (arg_43_0.border_width + 3) * 2
			var_43_0 = var_43_0 - 1
		end

		if var_43_0 > 1 then
			arg_43_1 = arg_43_1 + var_43_0
		end

		if arg_43_0.gradient_bar then
			local var_43_1 = 0

			if arg_43_0.background then
				var_43_1 = 1
			end

			arg_43_1 = arg_43_1 + 2 + var_43_1 * 2
		end

		arg_43_1 = arg_43_1 + arg_43_0.margin_top + arg_43_0.margin_bottom
		arg_43_0.h = arg_43_1
	end

	function var_34_0.new(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4, arg_44_5)
		local var_44_0 = setmetatable({
			gradient_bar = true,
			a = 255,
			border_width = 3,
			title_bar_in_menu = false,
			margin_top = 0,
			title_bar = true,
			draggable = false,
			visible = true,
			margin_left = 0,
			position = "fixed",
			margin_right = 0,
			margin_bottom = 0,
			draggable_save = false,
			border = true,
			first = true,
			background = true,
			in_menu = false,
			id = arg_44_0,
			top = arg_44_1,
			left = arg_44_2,
			w = arg_44_3,
			h = arg_44_4,
			paint_callback = arg_44_5,
			title_text_color = {
				255,
				255,
				255,
				255
			}
		}, var_34_17)

		var_44_0:set_active(true)

		return var_44_0
	end

	local var_34_18
	local var_34_19
	local var_34_20

	local function var_34_21(arg_45_0)
		local var_45_0 = {
			"bottom",
			"unset",
			"top"
		}
		local var_45_1 = {}

		for iter_45_0 = #var_34_15, 1, -1 do
			local var_45_2 = var_34_14[var_34_15[iter_45_0]]

			if var_45_2 ~= nil then
				local var_45_3 = var_45_2.z_index or "unset"

				if var_45_2.z_index_reset then
					var_45_2.z_index = nil
					var_45_2.z_index_reset = nil
				end

				var_45_1[var_45_3] = var_45_1[var_45_3] or {}

				if var_45_2.first then
					table.insert(var_45_1[var_45_3], 1, var_45_2.id)

					var_45_2.first = nil
				else
					table.insert(var_45_1[var_45_3], var_45_2.id)
				end
			end
		end

		var_34_15 = {}

		for iter_45_1 = 1, #var_45_0 do
			local var_45_4 = var_45_1[var_45_0[iter_45_1]]

			if var_45_4 ~= nil then
				for iter_45_2 = #var_45_4, 1, -1 do
					table.insert(var_34_15, var_45_4[iter_45_2])
				end
			end
		end

		local var_45_5 = ui.is_menu_open()
		local var_45_6 = {}

		for iter_45_3 = 1, #var_34_15 do
			local var_45_7 = var_34_14[var_34_15[iter_45_3]]

			if var_45_7 ~= nil and var_45_7.in_menu == arg_45_0 then
				if var_45_7.title_bar_in_menu then
					var_45_7.title_bar = var_45_5
				end

				if var_45_7.pre_paint_callback ~= nil then
					var_45_7:pre_paint_callback()
				end

				if var_34_14[var_45_7.id] ~= nil then
					table.insert(var_45_6, var_34_14[var_45_7.id])
				end
			end
		end

		if var_45_5 then
			local var_45_8, var_45_9 = ui.mouse_position()
			local var_45_10 = client.key_state(1)

			if var_45_10 then
				for iter_45_4 = #var_45_6, 1, -1 do
					local var_45_11 = var_45_6[iter_45_4]

					if var_45_11.visible and var_45_11:is_in_window(var_34_18, var_34_19) then
						var_45_11.first = true

						if var_34_20 then
							local var_45_12 = var_45_8 - var_34_18
							local var_45_13 = var_45_9 - var_34_19

							if var_45_11.position == "fixed" then
								local var_45_14 = var_45_11.left == nil and "right" or "left"
								local var_45_15 = var_45_11.top == nil and "bottom" or "top"
								local var_45_16 = {
									{
										var_45_14,
										(var_45_14 == "right" and -1 or 1) * var_45_12
									},
									{
										var_45_15,
										(var_45_15 == "bottom" and -1 or 1) * var_45_13
									}
								}

								for iter_45_5 = 1, #var_45_16 do
									local var_45_17, var_45_18 = unpack(var_45_16[iter_45_5])
									local var_45_19 = type(var_45_11[var_45_17])

									if var_45_19 == "string" and var_45_11[var_45_17]:sub(-1, -1) == "%" then
										-- block empty
									elseif var_45_19 == "number" then
										var_45_11[var_45_17] = var_45_11[var_45_17] + var_45_18
									end
								end

								break
							end

							var_45_11.x = var_45_11.x + var_45_12
							var_45_11.y = var_45_11.y + var_45_13
						end

						break
					end
				end
			end

			var_34_18, var_34_19 = var_45_8, var_45_9
			var_34_20 = var_45_10
		end

		for iter_45_6 = 1, #var_45_6 do
			local var_45_20 = var_45_6[iter_45_6]

			if var_45_20.visible and var_45_20.in_menu == arg_45_0 then
				var_34_13(var_45_20)

				if var_45_20.paint_callback ~= nil then
					var_45_20:paint_callback()
				end
			end
		end
	end

	local var_34_22
	local var_34_23
	local var_34_24

	client.delay_call(0, client.set_event_callback, "paint", function()
		var_34_21(false)
	end)
	client.delay_call(0, client.set_event_callback, "paint_ui", function()
		var_34_21(true)
	end)

	return var_34_0
end)().new("watermark")

var_0_106.title = "Watermark"
var_0_106.title_bar = false
var_0_106.margin_bottom = 2
var_0_106.margin_left = 3
var_0_106.margin_right = 3
var_0_106.border_width = 2
var_0_106.top = 15
var_0_106.right = 15
var_0_106.in_menu = true

local var_0_107 = database.read("sapphyrus_watermark") or {}
local var_0_108 = var_0_59("MISC", "Settings", "Anti-untrusted")
local var_0_109 = var_0_60(var_0_59, "MISC", "Settings", "Crash logs")
local var_0_110 = {
	"Logo",
	"Name lua",
	"FPS",
	"Server framerate",
	"Server IP",
	"Network lag",
	"Tickrate",
	"Time",
	"Time + seconds"
}
local var_0_111 = var_0_69("VISUALS", "Effects", "Watermark ", var_0_110)
local var_0_112 = var_0_68("VISUALS", "Effects", "Watermark", 149, 184, 6, 255)
local var_0_113 = var_0_67("VISUALS", "Effects", "Watermark rainbow line")
local var_0_114 = 0
local var_0_115 = {}
local var_0_116 = 0
local var_0_117 = -15
local var_0_118 = 15

local function var_0_119(arg_48_0, arg_48_1, arg_48_2)
	return var_0_56(math.max(arg_48_0, arg_48_1), arg_48_2)
end

local function var_0_120(arg_49_0, arg_49_1, arg_49_2)
	return arg_49_0 + (arg_49_1 - arg_49_0) * arg_49_2
end

local function var_0_121(arg_50_0, arg_50_1)
	for iter_50_0 = 1, #arg_50_0 do
		if arg_50_0[iter_50_0] == arg_50_1 then
			return true
		end
	end

	return false
end

local function var_0_122(arg_51_0, arg_51_1)
	local var_51_0 = {}

	for iter_51_0 = 1, #arg_51_0 do
		if arg_51_0[iter_51_0] ~= arg_51_1 then
			var_0_65(var_51_0, arg_51_0[iter_51_0])
		end
	end

	return var_51_0
end

local function var_0_123(arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = {}

	for iter_52_0 = 1, #arg_52_0 do
		var_52_0[iter_52_0] = var_0_120(arg_52_0[iter_52_0], arg_52_1[iter_52_0], arg_52_2)
	end

	return var_52_0
end

local function var_0_124()
	local var_53_0 = var_0_66(var_0_111)

	if #var_53_0 > 0 and var_0_121(var_53_0, "Time") and var_0_121(var_53_0, "Time + seconds") then
		local var_53_1 = var_53_0

		if not var_0_121(var_0_115, "Time") then
			var_53_1 = var_0_122(var_53_1, "Time + seconds")
		elseif not var_0_121(var_0_115, "Time + seconds") then
			var_53_1 = var_0_122(var_53_1, "Time")
		end

		if var_0_121(var_53_1, "Time") and var_0_121(var_53_1, "Time + seconds") then
			var_53_1 = var_0_122(var_53_1, "Time")
		end

		var_0_71(var_0_111, var_53_1)
		var_0_124()

		return
	end

	var_0_73(var_0_113, #var_53_0 > 0)

	var_0_115 = var_53_0
end

var_0_72(var_0_111, var_0_124)
var_0_124()

local function var_0_125(arg_54_0, arg_54_1)
	local var_54_0 = 10^(arg_54_1 or 0)

	return var_0_55(arg_54_0 * var_54_0 + 0.5) / var_54_0
end

local var_0_126 = 0

local function var_0_127()
	var_0_126 = var_0_126 * 0.9 + var_0_52() * 0.1

	return var_0_125(1 / var_0_126)
end

local function var_0_128(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6)
	arg_56_4 = arg_56_4 or {
		255,
		255,
		255
	}
	arg_56_5 = arg_56_5 or {
		230,
		210,
		40
	}
	arg_56_6 = arg_56_6 or {
		255,
		32,
		32
	}

	if arg_56_2 < arg_56_0 then
		return unpack(var_0_123(arg_56_5, arg_56_6, var_0_119((arg_56_0 - arg_56_2) / (arg_56_3 - arg_56_2), 0, 1)))
	else
		return unpack(var_0_123(arg_56_4, arg_56_5, var_0_119((arg_56_0 - arg_56_1) / (arg_56_2 - arg_56_1), 0, 1)))
	end
end

local var_0_129 = {
	{
		name = "Logo",
		get_width = function(arg_57_0, arg_57_1)
			arg_57_0.game_width = var_0_78(nil, "SHIT")
			arg_57_0.sense_width = var_0_78(nil, "SENSE")
			arg_57_0.beta_width = var_0_109 and var_0_78(nil, " [beta]") or 0

			return arg_57_0.game_width + arg_57_0.sense_width + arg_57_0.beta_width
		end,
		draw = function(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5, arg_58_6, arg_58_7, arg_58_8)
			local var_58_0, var_58_1, var_58_2 = var_0_66(var_0_112)

			var_0_77(arg_58_1, arg_58_2, 255, 32, 32, arg_58_8, nil, 0, "SHIT")
			var_0_77(arg_58_1 + arg_58_0.game_width, arg_58_2, var_58_0, var_58_1, var_58_2, arg_58_8, nil, 0, "SENSE")

			if var_0_109 then
				var_0_77(arg_58_1 + arg_58_0.game_width + arg_58_0.sense_width, arg_58_2, 255, 255, 255, arg_58_8 * 0.9, nil, 0, " [beta]")
			end
		end
	},
	{
		text = "Omicron.lua",
		name = "Name lua",
		get_width = function(arg_59_0, arg_59_1)
			if arg_59_0.text ~= nil and arg_59_0.text:gsub(" ", "") ~= "" then
				return var_0_78(nil, arg_59_0.text)
			else
				return 0
			end
		end,
		draw = function(arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4, arg_60_5, arg_60_6, arg_60_7, arg_60_8)
			var_0_77(arg_60_1, arg_60_2, arg_60_5, arg_60_6, arg_60_7, arg_60_8, nil, 0, arg_60_0.text)
		end
	},
	{
		name = "FPS",
		get_width = function(arg_61_0, arg_61_1)
			arg_61_0.fps = var_0_127()
			arg_61_0.text = tostring(arg_61_0.fps or 0) .. "fps"

			local var_61_0 = var_0_103:get_float()
			local var_61_1 = var_0_104:get_float()
			local var_61_2 = globals.mapname() == nil and math.min(var_61_0 == 0 and 999 or var_61_0, var_61_1 == 0 and 999 or var_61_0) or var_61_0 == 0 and 999 or var_61_0

			arg_61_0.width = math.max(var_0_78(nil, arg_61_0.text), var_0_78(nil, var_61_2 .. "fps"))

			return arg_61_0.width
		end,
		draw = function(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5, arg_62_6, arg_62_7, arg_62_8)
			local var_62_0 = arg_62_5
			local var_62_1 = arg_62_6
			local var_62_2 = arg_62_7

			if arg_62_0.fps < 1 / var_0_53() then
				-- block empty
			end

			var_0_77(arg_62_1 + arg_62_0.width, arg_62_2, var_62_0, var_62_1, var_62_2, arg_62_8, "r", 0, arg_62_0.text)
		end
	},
	{
		name = "Server framerate",
		get_width = function(arg_63_0, arg_63_1)
			if not var_0_79 then
				return
			end

			arg_63_1.local_player = arg_63_1.local_player or entity.get_local_player()

			if arg_63_1.local_player == nil then
				return
			end

			arg_63_1.net_channel_info = arg_63_1.net_channel_info or var_0_82()

			if arg_63_1.net_channel_info == nil then
				return
			end

			local var_63_0, var_63_1, var_63_2 = var_0_83(arg_63_1.net_channel_info)

			if var_63_0 ~= nil then
				arg_63_0.framerate = var_63_0 * 1000
				arg_63_0.var = var_63_1 * 1000
				arg_63_0.text1 = "sv:"
				arg_63_0.text2 = string.format("%.1f", arg_63_0.framerate)
				arg_63_0.text3 = " +-"
				arg_63_0.text4 = string.format("%.1f", arg_63_0.var)
				arg_63_0.width1 = var_0_78(nil, arg_63_0.text1)
				arg_63_0.width2 = math.max(var_0_78(nil, arg_63_0.text2), var_0_78(nil, "99.9"))
				arg_63_0.width3 = var_0_78(nil, arg_63_0.text3)
				arg_63_0.width4 = math.max(var_0_78(nil, arg_63_0.text4), var_0_78(nil, "9.9"))

				return arg_63_0.width1 + arg_63_0.width2 + arg_63_0.width3 + arg_63_0.width4
			end
		end,
		draw = function(arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6, arg_64_7, arg_64_8)
			local var_64_0, var_64_1, var_64_2 = var_0_128(arg_64_0.framerate, 8, 14, 20, {
				arg_64_5,
				arg_64_6,
				arg_64_7
			})
			local var_64_3, var_64_4, var_64_5 = var_0_128(arg_64_0.var, 5, 10, 18, {
				arg_64_5,
				arg_64_6,
				arg_64_7
			})

			var_0_77(arg_64_1, arg_64_2, arg_64_5, arg_64_6, arg_64_7, arg_64_8, nil, 0, arg_64_0.text1)
			var_0_77(arg_64_1 + arg_64_0.width1 + arg_64_0.width2, arg_64_2, var_64_0, var_64_1, var_64_2, arg_64_8, "r", 0, arg_64_0.text2)
			var_0_77(arg_64_1 + arg_64_0.width1 + arg_64_0.width2, arg_64_2, arg_64_5, arg_64_6, arg_64_7, arg_64_8, nil, 0, arg_64_0.text3)
			var_0_77(arg_64_1 + arg_64_0.width1 + arg_64_0.width2 + arg_64_0.width3, arg_64_2, var_64_3, var_64_4, var_64_5, arg_64_8, nil, 0, arg_64_0.text4)
		end
	},
	{
		name = "Network lag",
		get_width = function(arg_65_0, arg_65_1)
			if not var_0_79 then
				return
			end

			arg_65_1.local_player = arg_65_1.local_player or entity.get_local_player()

			if arg_65_1.local_player == nil then
				return
			end

			arg_65_1.net_channel_info = arg_65_1.net_channel_info or var_0_82()

			if arg_65_1.net_channel_info == nil then
				return
			end

			local var_65_0 = {}
			local var_65_1 = var_0_84(arg_65_1.net_channel_info)

			if var_65_1 ~= nil and var_65_1 > 0.1 then
				var_0_65(var_65_0, var_0_64("%.1fs timeout", var_65_1))
			end

			local var_65_2 = var_0_86(arg_65_1.net_channel_info, var_0_81)

			if var_65_2 ~= nil and var_65_2 > 0 then
				var_0_65(var_65_0, var_0_64("%d%% loss", math.ceil(var_65_2 * 100)))
			end

			local var_65_3 = var_0_85(arg_65_1.net_channel_info, var_0_81)

			if var_65_3 > 0 then
				var_0_65(var_65_0, var_0_64("%d%% choke", math.ceil(var_65_3 * 100)))
			end

			if #var_65_0 > 0 then
				arg_65_0.text = table.concat(var_65_0, ", ")

				return var_0_78(nil, arg_65_0.text)
			end
		end,
		draw = function(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5, arg_66_6, arg_66_7, arg_66_8)
			var_0_77(arg_66_1, arg_66_2, 255, 32, 32, arg_66_8, nil, 0, arg_66_0.text)
		end
	},
	{
		name = "Server IP",
		get_width = function(arg_67_0, arg_67_1)
			if not var_0_79 then
				return
			end

			arg_67_1.net_channel_info = arg_67_1.net_channel_info or var_0_82()

			if arg_67_1.net_channel_info == nil then
				return
			end

			arg_67_1.is_loopback = arg_67_1.is_loopback == nil and var_0_87(arg_67_1.net_channel_info) or arg_67_1.is_loopback

			if arg_67_1.is_loopback then
				return
			end

			arg_67_1.is_valve_ds = arg_67_1.is_valve_ds == nil and entity.get_prop(entity.get_game_rules(), "m_bIsValveDS") == 1 or arg_67_1.is_valve_ds

			if arg_67_1.is_valve_ds then
				return
			end

			arg_67_1.server_address = arg_67_1.server_address or var_0_88(arg_67_1.net_channel_info)

			if arg_67_1.server_address ~= nil and arg_67_1.server_address ~= "" then
				arg_67_0.text = arg_67_1.server_address

				return var_0_78(nil, arg_67_0.text)
			end
		end,
		draw = function(arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4, arg_68_5, arg_68_6, arg_68_7, arg_68_8)
			var_0_77(arg_68_1, arg_68_2, 255, 255, 255, arg_68_8, nil, 0, arg_68_0.text)
		end
	},
	{
		name = "Tickrate",
		get_width = function(arg_69_0, arg_69_1)
			if globals.mapname() == nil then
				return
			end

			if var_0_53() ~= nil then
				local var_69_0 = 1 / var_0_53() .. " tick"

				arg_69_0.text = var_69_0

				return var_0_78(nil, var_69_0)
			end
		end,
		draw = function(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5, arg_70_6, arg_70_7, arg_70_8)
			var_0_77(arg_70_1, arg_70_2, 255, 255, 255, arg_70_8, nil, 0, arg_70_0.text)
		end
	},
	{
		name = "Time",
		seconds = false,
		get_width = function(arg_71_0, arg_71_1)
			arg_71_0.time_width = var_0_78(nil, "00")
			arg_71_0.sep_width = var_0_78(nil, ":")

			return arg_71_0.time_width + arg_71_0.sep_width + arg_71_0.time_width + (arg_71_0.seconds and arg_71_0.sep_width + arg_71_0.time_width or 0)
		end,
		draw = function(arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4, arg_72_5, arg_72_6, arg_72_7, arg_72_8)
			local var_72_0, var_72_1, var_72_2, var_72_3 = var_0_48()
			local var_72_4, var_72_5 = var_0_64("%02d", var_72_0), var_0_64("%02d", var_72_1)

			var_0_77(arg_72_1, arg_72_2, 255, 255, 255, arg_72_8, "", 0, var_72_4)
			var_0_77(arg_72_1 + arg_72_0.time_width, arg_72_2, 255, 255, 255, arg_72_8, "", 0, ":")
			var_0_77(arg_72_1 + arg_72_0.time_width + arg_72_0.sep_width, arg_72_2, 255, 255, 255, arg_72_8, "", 0, var_72_5)

			if arg_72_0.seconds then
				local var_72_6 = var_0_64("%02d", var_72_2)

				var_0_77(arg_72_1 + arg_72_0.time_width * 2 + arg_72_0.sep_width, arg_72_2, 255, 255, 255, arg_72_8, "", 0, ":")
				var_0_77(arg_72_1 + arg_72_0.time_width * 2 + arg_72_0.sep_width * 2, arg_72_2, 255, 255, 255, arg_72_8, "", 0, var_72_6)
			end
		end
	}
}
local var_0_130 = {}

function var_0_106.pre_paint_callback()
	var_0_105(var_0_130)

	local var_73_0 = var_0_66(var_0_111)

	if var_0_121(var_73_0, "Name lua") then
		var_73_0 = var_0_122(var_73_0, "Name lua")

		if var_0_121(var_73_0, "Logo") then
			var_0_65(var_73_0, 2, "Name lua")
		else
			var_0_65(var_73_0, 1, "Name lua")
		end
	end

	local var_73_1, var_73_2 = var_0_46()

	if not (var_0_117 >= 0) or not var_0_117 then
		local var_73_3 = var_73_1 + var_0_117
	end

	if not (var_0_118 >= 0) or not var_0_118 then
		local var_73_4 = var_73_2 + var_0_118
	end

	for iter_73_0 = 1, #var_0_129 do
		local var_73_5 = var_0_129[iter_73_0]

		if var_73_5.name == "Time" then
			var_73_5.seconds = var_0_121(var_73_0, "Time + seconds")

			if var_73_5.seconds then
				var_0_65(var_73_0, "Time")
			end
		end
	end

	local var_73_6 = 9
	local var_73_7 = 0
	local var_73_8 = {}

	for iter_73_1 = 1, #var_0_129 do
		local var_73_9 = var_0_129[iter_73_1]

		if var_0_121(var_73_0, var_73_9.name) then
			local var_73_10 = var_73_9:get_width(var_73_8)

			if var_73_10 ~= nil and var_73_10 > 0 then
				table.insert(var_0_130, {
					item = var_73_9,
					item_width = var_73_10,
					x = var_73_7
				})

				var_73_7 = var_73_7 + var_73_10 + var_73_6
			end
		end
	end

	local var_73_11, var_73_12 = var_0_78(nil, "A")

	var_0_106.gradient_bar = var_0_66(var_0_113)

	var_0_106:set_inner_width(var_73_7 - var_73_6)
	var_0_106:set_inner_height(var_73_12)

	var_0_106.visible = #var_0_130 > 0
end

function var_0_106.paint_callback()
	local var_74_0 = 255
	local var_74_1 = 255
	local var_74_2 = 255
	local var_74_3 = 230

	for iter_74_0 = 1, #var_0_130 do
		local var_74_4 = var_0_130[iter_74_0]

		var_74_4.item:draw(var_0_106.i_x + var_74_4.x, var_0_106.i_y, var_74_4.item_width, 30, var_74_0, var_74_1, var_74_2, var_74_3)

		if iter_74_0 < #var_0_130 then
			renderer.rectangle(var_0_106.i_x + var_74_4.x + var_74_4.item_width + 4, var_0_106.i_y + 1, 1, var_0_106.i_h - 1, 210, 210, 210, 255)
		end
	end
end

client.set_event_callback("shutdown", function()
	database.write("watermark", var_0_107)
end)
ui.set_callback(var_0_36.misc.console_filter.ref, function()
	cvar.con_filter_text:set_string("cool text")
	cvar.con_filter_enable:set_int(1)
end)
client.set_event_callback("paint", function()
	local var_77_0 = ui.is_menu_open()
	local var_77_1, var_77_2 = ui.menu_position()
	local var_77_3, var_77_4 = ui.menu_size()
	local var_77_5 = globals.tickcount()
	local var_77_6 = math.abs(math.sin(var_77_5 * 0.01)) * 0.5 + 0.5
	local var_77_7 = math.floor((127 + 127 * math.sin(var_77_5 * 0.01)) * var_77_6)
	local var_77_8 = math.floor((127 + 127 * math.sin(var_77_5 * 0.01 + 2)) * var_77_6)
	local var_77_9 = math.floor((127 + 127 * math.sin(var_77_5 * 0.01 + 4)) * var_77_6)

	if not var_77_0 then
		return
	end

	for iter_77_0 = 0, 0 do
		local var_77_10 = math.floor((127 + 127 * math.sin(var_77_5 * 0.01 + iter_77_0 * 0.5)) * var_77_6)
		local var_77_11 = math.floor((127 + 127 * math.sin(var_77_5 * 0.01 + 2 + iter_77_0 * 0.5)) * var_77_6)
		local var_77_12 = math.floor((127 + 127 * math.sin(var_77_5 * 0.01 + 4 + iter_77_0 * 0.5)) * var_77_6)

		renderer.rectangle(var_77_1 - 10 - iter_77_0, var_77_2 - 30, var_77_3 + 20 + iter_77_0, 1, var_77_10, var_77_11, var_77_12, 255)
		renderer.rectangle(var_77_1 - 10 - iter_77_0, var_77_2 + var_77_4 + 7, var_77_3 + 20 + iter_77_0, 1, var_77_10, var_77_11, var_77_12, 255)
		renderer.rectangle(var_77_1 - 10 - iter_77_0, var_77_2 - 30, 1, var_77_4 + 37, var_77_10, var_77_11, var_77_12, 255)
		renderer.rectangle(var_77_1 + var_77_3 + 10, var_77_2 - 30, 1, var_77_4 + 37, var_77_10, var_77_11, var_77_12, 255)
	end

	renderer.rectangle(var_77_1 - 10, var_77_2 - 30, var_77_3 + 20, var_77_4 + 37, 70, 70, 70, 100)
	renderer.rectangle(var_77_1, var_77_2 - 20, var_77_3, var_77_4, 15, 15, 15, 120)

	local var_77_13 = entity.get_local_player()
	local var_77_14 = entity.get_player_name(var_77_13)
	local var_77_15 = "O M I C R O N "
	local var_77_16 = var_77_1 + var_77_3 / 2 - renderer.measure_text(nil, var_77_15) / 2
	local var_77_17 = var_77_2 - 18

	renderer.text(var_77_16, var_77_17, var_77_7, var_77_8, var_77_9, 255, "b", 0, var_77_15)
end)

local function var_0_131(arg_78_0)
	local var_78_0 = false

	return not (arg_78_0.allow_send_packet ~= false and not (globals.chokedcommands() > 1)) and true or false
end

local var_0_132 = {}

var_0_132.defensive = 0
var_0_132.checker = 0

client.set_event_callback("paint_ui", function()
	if not ui.get(var_0_18.doubletap[2]) then
		var_0_132.defensive = 1
	end

	local var_79_0 = entity.get_local_player()

	if not entity.is_alive(entity.get_local_player()) then
		return
	end

	local var_79_1 = entity.get_prop(entity.get_local_player(), "m_nTickBase")

	var_0_132.checker = math.max(var_79_1, var_0_132.checker or 0)
	var_0_132.defensive = math.abs(var_79_1 - var_0_132.checker)
end)

local function var_0_133(arg_80_0)
	if not var_0_36.misc.discharge.value or not var_0_36.lua.enable.value or ui.get(var_0_18.quick_peek[2]) or not ui.get(var_0_18.doubletap[2]) then
		return
	end

	local var_80_0 = entity.get_player_weapon(entity.get_local_player())

	if not var_80_0 or entity.get_classname(var_80_0) == "" then
		return
	end

	local var_80_1 = math.floor(entity.get_prop(entity.get_local_player(), "m_vecVelocity[2]"))

	if var_0_33() then
		if var_0_36.misc.d_mode.value == "Ideal" and var_80_1 > 20 then
			return
		end

		arg_80_0.in_jump = false
		arg_80_0.discharge_pending = true
	end
end

client.set_event_callback("paint_ui", function()
	var_0_17()

	if ui.is_menu_open() then
		var_0_37(var_0_36.lua.enable.value)
		ui.set_visible(aa_builder[1].override.ref, false)
		ui.set(aa_builder[1].override.ref, true)
		client.set_event_callback("paint_ui", function()
			return
		end)
	end
end)
client.set_event_callback("setup_command", function(arg_83_0)
	var_0_44(arg_83_0)
	var_0_133(arg_83_0)
end)

local var_0_134 = require("gamesense/antiaim_funcs")
local var_0_135 = require("vector")
local var_0_136 = ui.new_checkbox("Visuals", "Effects", "Enable Keybinds List")
local var_0_137 = ui.new_checkbox("Visuals", "Effects", "Enable Information List")
local var_0_138 = ui.new_label("Visuals", "Effects", "Indicator Accent")
local var_0_139 = ui.new_color_picker("Visuals", "Effects", "Accent Color", 70, 130, 180)
local var_0_140 = ui.new_slider("Visuals", "Effects", "Animation Speed", 1, 20, 6)
local var_0_141 = {
	doubletap = {
		ui.reference("rage", "aimbot", "double tap")
	},
	hideshots = {
		ui.reference("aa", "other", "on shot anti-aim")
	},
	damage_override = {
		ui.reference("rage", "aimbot", "minimum damage override")
	},
	safe_point = {
		ui.reference("rage", "aimbot", "force safe point")
	},
	body_aim = {
		ui.reference("rage", "aimbot", "force body aim")
	},
	auto_peek = {
		ui.reference("rage", "other", "quick peek assist")
	},
	duck_peek = {
		ui.reference("rage", "other", "duck peek assist")
	},
	freestand = {
		ui.reference("aa", "anti-aimbot angles", "freestanding")
	},
	slow_walk = {
		ui.reference("aa", "other", "slow motion")
	}
}
local var_0_142 = {
	timer,
	fortcalc,
	timer_max,
	c4_time_frozen,
	information = {
		prev_sim_time = 0,
		defensive_shift = 0,
		defensive_dur = 0
	}
}
local var_0_143 = {}

for iter_0_6 = 1, #var_0_141 do
	var_0_143[iter_0_6] = 0
end

local var_0_144 = {}

for iter_0_7 = 1, #var_0_141 do
	var_0_144[iter_0_7] = 0
end

local var_0_145 = {
	dragging = false,
	keybinds = {
		w = 170,
		h = 50,
		x = database.read("keybinds_x") or 10,
		y = database.read("keybinds_y") or 600
	},
	round = {
		w = 170,
		h = 50,
		x = database.read("round_x") or 10,
		y = database.read("round_y") or 900
	}
}
local var_0_146 = {
	outline = function(arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4, arg_84_5, arg_84_6, arg_84_7, arg_84_8, arg_84_9)
		arg_84_1 = arg_84_1 + arg_84_8

		local var_84_0 = {
			{
				arg_84_0 + arg_84_8,
				arg_84_1,
				180
			},
			{
				arg_84_0 + arg_84_2 - arg_84_8,
				arg_84_1,
				270
			},
			{
				arg_84_0 + arg_84_8,
				arg_84_1 + arg_84_3 - arg_84_8 * 2,
				90
			},
			{
				arg_84_0 + arg_84_2 - arg_84_8,
				arg_84_1 + arg_84_3 - arg_84_8 * 2,
				0
			}
		}
		local var_84_1 = {
			{
				arg_84_0 + arg_84_8,
				arg_84_1 - arg_84_8,
				arg_84_2 - arg_84_8 * 2,
				arg_84_9
			},
			{
				arg_84_0 + arg_84_8,
				arg_84_1 + arg_84_3 - arg_84_8 - arg_84_9,
				arg_84_2 - arg_84_8 * 2,
				arg_84_9
			},
			{
				arg_84_0,
				arg_84_1,
				arg_84_9,
				arg_84_3 - arg_84_8 * 2
			},
			{
				arg_84_0 + arg_84_2 - arg_84_9,
				arg_84_1,
				arg_84_9,
				arg_84_3 - arg_84_8 * 2
			}
		}

		for iter_84_0, iter_84_1 in next, var_84_0 do
			renderer.circle_outline(iter_84_1[1], iter_84_1[2], arg_84_4, arg_84_5, arg_84_6, arg_84_7, arg_84_8, iter_84_1[3], 0.25, arg_84_9)
		end

		for iter_84_2, iter_84_3 in next, var_84_1 do
			renderer.rectangle(iter_84_3[1], iter_84_3[2], iter_84_3[3], iter_84_3[4], arg_84_4, arg_84_5, arg_84_6, arg_84_7)
		end
	end,
	rounded_rectangle = function(arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4, arg_85_5, arg_85_6, arg_85_7, arg_85_8)
		arg_85_1 = arg_85_1 + arg_85_8

		local var_85_0 = {
			{
				arg_85_0 + arg_85_8,
				arg_85_1,
				180
			},
			{
				arg_85_0 + arg_85_2 - arg_85_8,
				arg_85_1,
				90
			},
			{
				arg_85_0 + arg_85_8,
				arg_85_1 + arg_85_3 - arg_85_8 * 2,
				270
			},
			{
				arg_85_0 + arg_85_2 - arg_85_8,
				arg_85_1 + arg_85_3 - arg_85_8 * 2,
				0
			}
		}
		local var_85_1 = {
			{
				arg_85_0 + arg_85_8,
				arg_85_1,
				arg_85_2 - arg_85_8 * 2,
				arg_85_3 - arg_85_8 * 2
			},
			{
				arg_85_0 + arg_85_8,
				arg_85_1 - arg_85_8,
				arg_85_2 - arg_85_8 * 2,
				arg_85_8
			},
			{
				arg_85_0 + arg_85_8,
				arg_85_1 + arg_85_3 - arg_85_8 * 2,
				arg_85_2 - arg_85_8 * 2,
				arg_85_8
			},
			{
				arg_85_0,
				arg_85_1,
				arg_85_8,
				arg_85_3 - arg_85_8 * 2
			},
			{
				arg_85_0 + arg_85_2 - arg_85_8,
				arg_85_1,
				arg_85_8,
				arg_85_3 - arg_85_8 * 2
			}
		}

		for iter_85_0, iter_85_1 in next, var_85_0 do
			renderer.circle(iter_85_1[1], iter_85_1[2], arg_85_4, arg_85_5, arg_85_6, arg_85_7, arg_85_8, iter_85_1[3], 0.25)
		end

		for iter_85_2, iter_85_3 in next, var_85_1 do
			renderer.rectangle(iter_85_3[1], iter_85_3[2], iter_85_3[3], iter_85_3[4], arg_85_4, arg_85_5, arg_85_6, arg_85_7)
		end
	end,
	outlined_string = function(arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4, arg_86_5, arg_86_6, arg_86_7, ...)
		local var_86_0 = {
			{
				-1,
				1,
				-1,
				1
			},
			{
				1,
				1,
				-1,
				-1
			}
		}

		for iter_86_0 = 1, 4 do
			renderer.text(arg_86_0 + var_86_0[1][iter_86_0], arg_86_1 + var_86_0[2][iter_86_0], 0, 0, 0, 255, arg_86_6, arg_86_7, ...)
		end

		renderer.text(arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4, 255, arg_86_6, arg_86_7, ...)
	end,
	lerp = function(arg_87_0, arg_87_1, arg_87_2)
		return arg_87_0 + (arg_87_1 - arg_87_0) * arg_87_2
	end,
	clamp = function(arg_88_0, arg_88_1, arg_88_2)
		if arg_88_2 < arg_88_1 then
			return math.min(math.max(arg_88_0, arg_88_2), arg_88_1)
		else
			return math.min(math.max(arg_88_0, arg_88_1), arg_88_2)
		end
	end,
	insert_information_board = function(arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4, arg_89_5, arg_89_6, arg_89_7, arg_89_8, arg_89_9, arg_89_10, arg_89_11)
		local var_89_0 = {
			ui.get(var_0_139)
		}

		renderer.gradient(arg_89_0 + 1, arg_89_1, 149, 17, arg_89_4, arg_89_5, arg_89_6, 10 * arg_89_8, arg_89_4, arg_89_5, arg_89_6, 0, true)
		renderer.rectangle(arg_89_0 + 1, arg_89_1, 1, 17, arg_89_4, arg_89_5, arg_89_6, 255 * arg_89_8)
		renderer.text(arg_89_0 + 5, arg_89_1 + 2, 175, 175, 175, 255 * arg_89_8, "", nil, arg_89_9)
		renderer.text(arg_89_0 + 140 + arg_89_11, arg_89_1 + 2, var_89_0[1], var_89_0[2], var_89_0[3], 255 * arg_89_8, "r", nil, arg_89_10)
	end,
	intersect = function(arg_90_0, arg_90_1, arg_90_2, arg_90_3)
		local var_90_0, var_90_1 = ui.mouse_position()

		return arg_90_0 <= var_90_0 and var_90_0 <= arg_90_0 + arg_90_2 and arg_90_1 <= var_90_1 and var_90_1 <= arg_90_1 + arg_90_3
	end
}

function var_0_146.keybinds()
	if not ui.get(var_0_136) then
		return
	end

	local var_91_0 = var_0_145.keybinds.x
	local var_91_1 = var_0_145.keybinds.y
	local var_91_2, var_91_3, var_91_4, var_91_5 = ui.get(var_0_139)
	local var_91_6 = {}
	local var_91_7 = 0

	if ui.get(var_0_141.doubletap[1]) and ui.get(var_0_141.doubletap[2]) then
		var_91_7 = var_91_7 + 1
		var_91_6[1] = {
			true,
			"doubletap",
			var_0_134.get_double_tap() and "charged" or "recharge",
			1
		}
	else
		var_91_6[1] = {
			false,
			"doubletap",
			"on",
			1
		}
	end

	if ui.get(var_0_141.hideshots[1]) and ui.get(var_0_141.hideshots[2]) then
		var_91_7 = var_91_7 + 1
		var_91_6[2] = {
			true,
			"hideshots",
			var_91_6[1][1] and "conflict" or "on",
			2
		}
	else
		var_91_6[2] = {
			false,
			"hideshots",
			"on",
			2
		}
	end

	if ui.get(var_0_141.damage_override[1]) and ui.get(var_0_141.damage_override[2]) then
		var_91_7 = var_91_7 + 1
		var_91_6[3] = {
			true,
			"damage override",
			ui.get(var_0_141.damage_override[3]),
			3
		}
	else
		var_91_6[3] = {
			false,
			"damage override",
			ui.get(var_0_141.damage_override[3]),
			3
		}
	end

	if ui.get(var_0_141.safe_point[1]) then
		var_91_7 = var_91_7 + 1
		var_91_6[4] = {
			true,
			"force safe point",
			"on",
			4
		}
	else
		var_91_6[4] = {
			false,
			"force safe point",
			"on",
			4
		}
	end

	if ui.get(var_0_141.body_aim[1]) then
		var_91_7 = var_91_7 + 1
		var_91_6[5] = {
			true,
			"force body aim",
			"on",
			5
		}
	else
		var_91_6[5] = {
			false,
			"force body aim",
			"on",
			5
		}
	end

	if ui.get(var_0_141.auto_peek[1]) and ui.get(var_0_141.auto_peek[2]) then
		var_91_7 = var_91_7 + 1
		var_91_6[6] = {
			true,
			"auto peek",
			"on",
			6
		}
	else
		var_91_6[6] = {
			false,
			"auto peek",
			"on",
			6
		}
	end

	if ui.get(var_0_141.duck_peek[1]) then
		var_91_7 = var_91_7 + 1
		var_91_6[7] = {
			true,
			"fake duck",
			"on",
			7
		}
	else
		var_91_6[7] = {
			false,
			"fake duck",
			"on",
			7
		}
	end

	if ui.get(var_0_141.freestand[1]) and ui.get(var_0_141.freestand[2]) then
		var_91_7 = var_91_7 + 1
		var_91_6[8] = {
			true,
			"freestand",
			"on",
			8
		}
	else
		var_91_6[8] = {
			false,
			"freestand",
			"on",
			8
		}
	end

	if ui.get(var_0_141.slow_walk[1]) and ui.get(var_0_141.slow_walk[2]) then
		var_91_7 = var_91_7 + 1
		var_91_6[9] = {
			true,
			"slow walk",
			"on",
			9
		}
	else
		var_91_6[9] = {
			false,
			"slow walk",
			"on",
			9
		}
	end

	if m_h == nil then
		m_h = var_91_7
	end

	m_h = var_0_146.lerp(m_h, var_91_7, globals.frametime() * ui.get(var_0_140))

	local var_91_8 = var_0_146.clamp(m_h, 0, m_h - 1e-13)

	var_0_146.rounded_rectangle(var_91_0 + 10, var_91_1 + 30, 150, 12 + var_91_8 * 18, 13, 13, 13, 255, 5)

	for iter_91_0 = 1, #var_91_6 do
		local var_91_9 = var_91_8 - 17.9
		local var_91_10 = var_91_6[iter_91_0][4]
		local var_91_11 = 0

		if var_91_9 >= var_91_8 * 18.1 then
			var_0_143[var_91_10] = 0

			break
		end

		if var_0_143[var_91_10] == nil or not var_91_6[iter_91_0][1] then
			var_0_143[var_91_10] = 0
		elseif var_0_143[var_91_10] <= 0.95 then
			var_0_143[var_91_10] = var_0_143[var_91_10] + 0.01
		else
			var_0_143[var_91_10] = 1
		end

		for iter_91_1 = 1, iter_91_0 do
			if var_91_6[iter_91_1][1] then
				var_91_11 = var_91_11 + 1
			end
		end

		var_0_146.insert_information_board(var_91_0 + 13, var_91_1 + 36 + 18 * (var_91_11 - 1), 150, 17, var_91_2, var_91_3, var_91_4, 10, var_0_143[iter_91_0], var_91_6[iter_91_0][2], var_91_6[iter_91_0][3], 0)
	end

	var_0_146.outline(var_91_0, var_91_1, 170, 26, 19, 19, 19, 255, 5, 17)
	var_0_146.outline(var_91_0, var_91_1 + 20, 170, 32 + var_91_8 * 18, 19, 19, 19, 255, 5, 12)
	var_0_146.outline(var_91_0 + 1, var_91_1 + 1, 168, 50 + var_91_8 * 18, 53, 53, 53, 255, 5, 1)
	var_0_146.outlined_string(var_91_0 + 10, var_91_1 + 11, 255, 255, 255, 255, "", nil, "keybinds")
	var_0_146.outline(var_91_0 + 10, var_91_1 + 30, 150, 12 + var_91_8 * 18, 53, 53, 53, 255, 5, 1)
	var_0_146.outline(var_91_0 + 11, var_91_1 + 31, 148, 10 + var_91_8 * 18, 0, 0, 0, 255, 5, 1)

	if ui.is_menu_open() then
		local var_91_12, var_91_13 = ui.mouse_position()

		if var_0_145.keybinds.dragging and not client.key_state(1) then
			alpha = 0
			var_0_145.keybinds.dragging = false
		end

		if var_0_145.keybinds.dragging and client.key_state(1) then
			var_0_145.keybinds.x = var_91_12 - drag_x
			var_0_145.keybinds.y = var_91_13 - drag_y
		end

		if var_0_146.intersect(var_0_145.keybinds.x, var_0_145.keybinds.y, 150, 50 + var_91_8 * 18) and client.key_state(1) then
			var_0_145.keybinds.dragging = true
			drag_x = var_91_12 - var_0_145.keybinds.x
			drag_y = var_91_13 - var_0_145.keybinds.y

			renderer.rectangle(var_0_145.keybinds.x - 2, var_0_145.keybinds.y - 2, 174, 50 + var_91_8 * 18 + 6, 255, 0, 0, 55)
		end
	end
end

function bomb_damage(arg_92_0)
	local var_92_0 = var_0_135(entity.get_origin(entity.get_local_player()))
	local var_92_1 = var_0_135(entity.get_origin(arg_92_0))
	local var_92_2 = var_92_0:dist(var_92_1)
	local var_92_3 = entity.get_prop(entity.get_local_player(), "m_ArmorValue")
	local var_92_4 = 450.7 * math.exp(-((var_92_2 - 75.68) / 789.2)^2)

	if var_92_3 > 0 then
		local var_92_5 = var_92_4 * 0.5

		if var_92_3 < (var_92_4 - var_92_5) * 0.5 then
			local var_92_6 = var_92_3 * 2

			var_92_5 = var_92_4 - var_92_3
		end

		var_92_4 = var_92_5
	end

	return var_92_4
end

function bomb_time(arg_93_0)
	return math.max(entity.get_prop(arg_93_0, "m_flC4Blow") - globals.curtime(), 0)
end

function defuseable(arg_94_0)
	local var_94_0 = bomb_time(arg_94_0)

	if entity.get_prop(arg_94_0, "m_hBombDefuser") then
		return var_0_142.c4_time_froze < entity.get_prop(arg_94_0, "m_flDefureCountDown") - globals.curtime()
	else
		return var_94_0 > 6
	end
end

function invulnerable()
	local var_95_0 = entity.get_local_player()
	local var_95_1 = math.floor(0.5 + entity.get_prop(var_95_0, "m_flSimulationTime") / globals.tickinterval())
	local var_95_2 = var_0_142.information.prev_sim_time

	if var_95_2 == 0 then
		var_0_142.information.prev_sim_time = var_95_1

		return
	end

	local var_95_3 = var_95_1 - var_95_2

	if var_95_3 < 0 then
		local var_95_4 = math.abs(var_95_3)

		var_0_142.information.defensive_dur = globals.tickcount() + var_95_4
		var_0_142.information.defensive_shift = var_95_4
	end

	var_0_142.information.prev_sim_time = var_95_1
end

function var_0_146.round_info()
	if not ui.get(var_0_137) then
		return
	end

	local var_96_0 = var_0_145.round.x
	local var_96_1 = var_0_145.round.y
	local var_96_2, var_96_3, var_96_4, var_96_5 = ui.get(var_0_139)
	local var_96_6 = var_0_146.clamp(renderer.measure_text("", entity.get_player_name(client.current_threat())) - 40, 0, renderer.measure_text("", entity.get_player_name(client.current_threat())))
	local var_96_7 = {}
	local var_96_8 = 0
	local var_96_9 = not (client.current_threat() ~= nil and entity.is_alive(entity.get_local_player())) and 0 or var_96_6
	local var_96_10 = entity.get_all("CPlantedC4")[1]

	if var_96_10 == nil then
		-- block empty
	else
		defuse_timer = entity.get_prop(var_96_10, "m_flDefuseCountDown") - globals.curtime()
		var_0_142.timer, var_0_142.fortcalc, var_0_142.timer_max = math.ceil(bomb_time(var_96_10) * 10 - 0.5) / 10 - 0.5, bomb_time(var_96_10), client.get_cvar("mp_c4timer")

		if entity.get_prop(var_96_10, "m_hBombDefuser") then
			var_0_142.timer = math.ceil(defuse_timer * 10 - 0.5) / 10 - 0.5
			var_0_142.fortcalc = defuse_timer
			var_0_142.timer_max = 10
		end

		var_0_142.timer = var_0_142.timer > 0 and var_0_142.timer or 0
		timer_calc = math.max(0, math.min(var_0_142.timer_max, var_0_142.fortcalc)) / var_0_142.timer_max
		damage = math.floor(bomb_damage(var_96_10))
		site = entity.get_prop(var_96_10, "m_nBombSite")
		site = site == 1 and "b" or "a"
	end

	invulnerable()

	local var_96_11 = entity.get_prop(entity.get_local_player(), "m_flVelocityModifier")
	local var_96_12 = var_0_134.get_overlap(true)

	if var_96_10 == nil or entity.get_prop(var_96_10, "m_bBombDefused") == 1 or var_0_142.timer == 0 then
		var_96_7[1] = {
			false,
			"x",
			"recharge",
			1
		}
	else
		var_96_8 = var_96_8 + 1
		var_96_7[1] = {
			true,
			"bomb planted " .. site,
			var_0_142.timer .. "s",
			1
		}
	end

	if var_96_10 == nil or damage == nil or damage < 1 or var_0_142.timer == 0 or not entity.is_alive(entity.get_local_player()) or entity.get_prop(var_96_10, "m_bBombDefused") == 1 then
		var_96_7[2] = {
			false,
			"x",
			"recharge",
			2
		}
	else
		var_96_8 = var_96_8 + 1
		var_96_7[2] = {
			true,
			"bomb lethality",
			damage >= entity.get_prop(entity.get_local_player(), "m_iHealth") and "fatal" or damage,
			2
		}
	end

	if client.current_threat() == nil or not entity.is_alive(entity.get_local_player()) then
		var_96_7[3] = {
			false,
			"x",
			"recharge",
			3
		}
	else
		var_96_8 = var_96_8 + 1
		var_96_7[3] = {
			true,
			"anti-aim target",
			entity.get_player_name(client.current_threat()),
			3
		}
	end

	if var_0_142.information.defensive_dur + 20 < globals.tickcount() or not entity.is_alive(entity.get_local_player()) then
		var_96_7[4] = {
			false,
			"x",
			"recharge",
			4
		}
	else
		var_96_8 = var_96_8 + 1
		var_96_7[4] = {
			true,
			"defensive",
			var_0_142.information.defensive_dur < globals.tickcount() and "switched" or "active",
			4
		}
	end

	if var_96_11 == 1 or not entity.is_alive(entity.get_local_player()) then
		var_96_7[5] = {
			false,
			"x",
			"recharge",
			5
		}
	else
		var_96_8 = var_96_8 + 1
		var_96_7[5] = {
			true,
			"Velocity",
			math.floor(255 * var_96_11 / 255 * 100) .. "%",
			5
		}
	end

	if not entity.is_alive(entity.get_local_player()) then
		var_96_7[6] = {
			false,
			"x",
			"recharge",
			6
		}
	else
		var_96_8 = var_96_8 + 1
		var_96_7[6] = {
			true,
			"anti-aim overlap",
			math.floor(var_96_12 * 100) .. "%",
			6
		}
	end

	if m_j == nil then
		m_j = var_96_8
	end

	m_j = var_0_146.lerp(m_j, var_96_8, globals.frametime() * ui.get(var_0_140))

	local var_96_13 = var_0_146.clamp(m_j, 0, m_j - 1e-13)

	if l_j == nil then
		l_j = var_96_9
	end

	l_j = var_0_146.lerp(l_j, var_96_9, globals.frametime() * ui.get(var_0_140))

	local var_96_14 = var_0_146.clamp(l_j, 0, l_j - 1e-13)

	var_0_146.rounded_rectangle(var_96_0 + 10, var_96_1 + 30, 150 + var_96_14, 12 + var_96_13 * 18, 13, 13, 13, 255, 5)

	for iter_96_0 = 1, #var_96_7 do
		local var_96_15 = var_96_13 - 17.9
		local var_96_16 = var_96_7[iter_96_0][4]
		local var_96_17 = 0

		if var_96_15 >= var_96_13 * 18.1 then
			var_0_144[var_96_16] = 0

			break
		end

		if var_0_144[var_96_16] == nil or not var_96_7[iter_96_0][1] then
			var_0_144[var_96_16] = 0
		elseif var_0_144[var_96_16] <= 0.95 then
			var_0_144[var_96_16] = var_0_144[var_96_16] + 0.01
		else
			var_0_144[var_96_16] = 1
		end

		for iter_96_1 = 1, iter_96_0 do
			if var_96_7[iter_96_1][1] then
				var_96_17 = var_96_17 + 1
			end
		end

		var_0_146.insert_information_board(var_96_0 + 13, var_96_1 + 36 + 18 * (var_96_17 - 1), 150 + var_96_14, 17, var_96_2, var_96_3, var_96_4, 10, var_0_144[iter_96_0], var_96_7[iter_96_0][2], var_96_7[iter_96_0][3], var_96_14)
	end

	var_0_146.outline(var_96_0, var_96_1, 170 + var_96_14, 26, 19, 19, 19, 255, 5, 17)
	var_0_146.outline(var_96_0, var_96_1 + 20, 170 + var_96_14, 32 + var_96_13 * 18, 19, 19, 19, 255, 5, 12)
	var_0_146.outline(var_96_0 + 1, var_96_1 + 1, 168 + var_96_14, 50 + var_96_13 * 18, 53, 53, 53, 255, 5, 1)
	var_0_146.outlined_string(var_96_0 + 10, var_96_1 + 11, 255, 255, 255, 255, "", nil, "additional information")
	var_0_146.outline(var_96_0 + 10, var_96_1 + 30, 150 + var_96_14, 12 + var_96_13 * 18, 53, 53, 53, 255, 5, 1)
	var_0_146.outline(var_96_0 + 11, var_96_1 + 31, 148 + var_96_14, 10 + var_96_13 * 18, 0, 0, 0, 255, 5, 1)

	if ui.is_menu_open() then
		local var_96_18, var_96_19 = ui.mouse_position()

		if var_0_145.round.dragging and not client.key_state(1) then
			alpha = 0
			var_0_145.round.dragging = false
		end

		if var_0_145.round.dragging and client.key_state(1) then
			var_0_145.round.x = var_96_18 - drag_x
			var_0_145.round.y = var_96_19 - drag_y
		end

		if var_0_146.intersect(var_0_145.round.x, var_0_145.round.y, 150, 50 + var_96_13 * 18) and client.key_state(1) then
			var_0_145.round.dragging = true
			drag_x = var_96_18 - var_0_145.round.x
			drag_y = var_96_19 - var_0_145.round.y

			renderer.rectangle(var_0_145.round.x - 2, var_0_145.round.y - 2, 174, 50 + var_96_13 * 18 + 6, 255, 0, 0, 55)
		end
	end
end

local function var_0_147()
	database.write("keybinds_x", var_0_145.keybinds.x)
	database.write("keybinds_y", var_0_145.keybinds.y)
	database.write("round_x", var_0_145.round.x)
	database.write("round_y", var_0_145.round.y)
end

local function var_0_148()
	var_0_146.keybinds()
	var_0_146.round_info()
end

client.set_event_callback("bomb_begindefuse", function()
	var_0_142.c4_time_frozen = math.ceil(bomb_time(entity.get_all("CPlantedC4")[1]) * 10 - 0.5) / 10 - 0.5
end)
client.set_event_callback("paint", var_0_148)
client.set_event_callback("shutdown", var_0_147)

local var_0_149 = ui.get
local var_0_150 = ui.set
local var_0_151 = client.exec
local var_0_152 = ui.new_checkbox
local var_0_153 = ui.new_slider
local var_0_154 = ui.set_callback
local var_0_155 = var_0_153("VISUALS", "EFFECTS", "Thirdperson Distance", 30, 200, 150)

local function var_0_156()
	var_0_151("cam_idealdist ", var_0_149(var_0_155))
end

var_0_154(var_0_155, var_0_156)

local var_0_157 = {
	aimbot = ui.reference("RAGE", "Aimbot", "Enabled"),
	doubletap = {
		main = {
			ui.reference("RAGE", "Aimbot", "Double tap")
		},
		fakelag_limit = ui.reference("RAGE", "Aimbot", "Double tap fake lag limit")
	}
}
local var_0_158
local var_0_159 = false
local var_0_160 = false

local function var_0_161()
	local var_101_0 = entity.get_prop(var_0_158, "m_nTickBase")
	local var_101_1 = client.latency()

	var_0_160 = math.floor(var_101_0 - globals.tickcount() - 3 - toticks(var_101_1) * 0.5 + 0.5 * (var_101_1 * 10)) <= -14 + (ui.get(var_0_157.doubletap.fakelag_limit) - 1) + 3
end

client.set_event_callback("setup_command", function()
	if not ui.get(var_0_157.doubletap.main[2]) or not ui.get(var_0_157.doubletap.main[1]) then
		ui.set(var_0_157.aimbot, true)

		if var_0_159 then
			client.unset_event_callback("run_command", var_0_161)

			var_0_159 = false
		end

		return
	end

	var_0_158 = entity.get_local_player()

	if not var_0_159 then
		client.set_event_callback("run_command", var_0_161)

		var_0_159 = true
	end

	local var_102_0 = client.current_threat()

	if not var_0_160 and var_102_0 and var_0_6.band(entity.get_prop(var_0_158, "m_fFlags"), 1) == 0 and var_0_6.band(entity.get_esp_data(var_102_0).flags, var_0_6.lshift(1, 11)) == 2048 then
		ui.set(var_0_157.aimbot, false)
	else
		ui.set(var_0_157.aimbot, true)
	end
end)
client.set_event_callback("shutdown", function()
	ui.set(var_0_157.aimbot, true)
end)

local var_0_162 = ui.new_checkbox("VISUALS", "Effects", "Show hit/miss ratio indicator")
local var_0_163 = {
	total_shots = 0,
	hits = 0
}

client.set_event_callback("paint", function()
	local var_104_0 = entity.get_local_player()

	if not ui.get(var_0_162) then
		return
	end

	if not var_104_0 then
		return
	end

	renderer.indicator(200, 200, 200, 255, string.format("%s / %s (%s)", var_0_163.hits, var_0_163.total_shots, string.format("%.1f", var_0_163.total_shots ~= 0 and var_0_163.hits / var_0_163.total_shots * 100 or 0)))
end)
client.set_event_callback("aim_hit", function()
	var_0_163.total_shots = var_0_163.total_shots + 1
	var_0_163.hits = var_0_163.hits + 1
end)
client.set_event_callback("aim_miss", function(arg_106_0)
	if arg_106_0.reason ~= "death" and arg_106_0.reason ~= "unregistered shot" then
		var_0_163.total_shots = var_0_163.total_shots + 1
	end
end)
client.set_event_callback("player_connect_full", function(arg_107_0)
	if client.userid_to_entindex(arg_107_0.userid) == entity.get_local_player() then
		var_0_163 = {
			total_shots = 0,
			hits = 0
		}
	end
end)

local var_0_164 = ui.new_checkbox("VISUALS", "Effects", "Omicron tag screen")
local var_0_165 = 2
local var_0_166 = 128
local var_0_167 = 220

client.set_event_callback("paint", function()
	local var_108_0 = entity.get_local_player()

	if not ui.get(var_0_164) then
		return
	end

	if not var_108_0 then
		return
	end

	local var_108_1 = globals.realtime()
	local var_108_2 = var_0_167 + var_0_166 * math.sin(var_108_1 * var_0_165)
	local var_108_3 = math.max(0, math.min(255, var_108_2))

	renderer.indicator(255, 32, 32, var_108_3, "OMICRON")
end)

local var_0_168 = var_0_6.bor
local var_0_169 = client.eye_position
local var_0_170 = client.find_signature
local var_0_171 = client.set_event_callback
local var_0_172 = client.userid_to_entindex
local var_0_173 = entity.get_local_player
local var_0_174 = entity.get_player_weapon
local var_0_175 = entity.get_prop
local var_0_176 = entity.hitbox_position
local var_0_177 = entity.is_enemy
local var_0_178 = globals.tickcount
local var_0_179 = math.sqrt
local var_0_180 = ui.get
local var_0_181 = ui.new_checkbox
local var_0_182 = ui.new_color_picker
local var_0_183 = ui.new_combobox
local var_0_184 = ui.new_label
local var_0_185 = ui.new_slider
local var_0_186 = ui.set
local var_0_187 = error
local var_0_188 = pairs
local var_0_189 = renderer.load_png
local var_0_190 = renderer.texture
local var_0_191 = renderer.text
local var_0_192 = renderer.world_to_screen
local var_0_193 = globals.realtime
local var_0_194 = ui.new_checkbox("VISUALS", "Effects", "hitmarker")
local var_0_195 = var_0_189(readfile("runescape_hitsplats/blue.png"), 24, 22)
local var_0_196 = var_0_189(readfile("runescape_hitsplats/red.png"), 24, 22)
local var_0_197 = {}

local function var_0_198(arg_109_0, arg_109_1, arg_109_2, arg_109_3, arg_109_4)
	if arg_109_0 == 0 then
		var_0_190(var_0_195, arg_109_1 - 12, arg_109_2 - 11, 24, 22, 255, 255, 255, arg_109_3, "f")
		var_0_191(arg_109_1, arg_109_2 - arg_109_4 * 30, 255, 255, 255, arg_109_3, "c", 0, "0")
	else
		var_0_190(var_0_196, arg_109_1 - 12, arg_109_2 - 11, 24, 22, 255, 255, 255, arg_109_3, "f")
		var_0_191(arg_109_1, arg_109_2 - arg_109_4 * 30, 255, 255, 255, arg_109_3, "c", 0, arg_109_0)
	end
end

local function var_0_199()
	if not var_0_180(var_0_194) then
		return
	end

	local var_110_0 = var_0_193()

	for iter_110_0 = #var_0_197, 1, -1 do
		local var_110_1 = var_0_197[iter_110_0]

		if var_110_0 < var_110_1[1] + 3 then
			local var_110_2, var_110_3 = var_0_192(var_110_1[2], var_110_1[3], var_110_1[4])

			if var_110_2 ~= nil and var_110_3 ~= nil then
				local var_110_4 = 255 * (1 - (var_110_0 - var_110_1[1]) / 2)
				local var_110_5 = var_110_0 - var_110_1[1]

				var_0_198(var_110_1[6], var_110_2, var_110_3, math.max(0, var_110_4), var_110_5)
			end
		else
			table.remove(var_0_197, iter_110_0)
		end
	end
end

client.set_event_callback("paint_ui", function()
	var_0_199()
end)

local var_0_200 = {
	{
		0,
		1
	},
	{
		4,
		5,
		6
	},
	{
		2,
		3
	},
	{
		13,
		15,
		16
	},
	{
		14,
		17,
		18
	},
	{
		7,
		9,
		11
	},
	{
		8,
		10,
		12
	}
}

client.set_event_callback("aim_hit", function(arg_112_0)
	local var_112_0 = arg_112_0.target
	local var_112_1 = var_0_193()
	local var_112_2, var_112_3, var_112_4 = var_0_176(var_112_0, var_0_200[arg_112_0.hitgroup][1])

	table.insert(var_0_197, {
		var_112_1,
		var_112_2,
		var_112_3,
		var_112_4,
		var_112_0,
		arg_112_0.damage
	})
end)
client.set_event_callback("aim_miss", function(arg_113_0)
	local var_113_0, var_113_1 = var_0_192(arg_113_0.x, arg_113_0.y, arg_113_0.z)

	if var_113_0 ~= nil and var_113_1 ~= nil then
		var_0_191(var_113_0, var_113_1, 255, 0, 0, 255, "c", 0, "miss")
	end
end)
client.set_event_callback("round_start", function(arg_114_0)
	var_0_197 = {}
end)
client.set_event_callback("player_death", function(arg_115_0)
	local var_115_0 = var_0_173()

	if var_0_172(arg_115_0.userid) == var_115_0 then
		var_0_197 = {}
	end
end)

local var_0_201 = ui.new_checkbox("VISUALS", "Effects", "Bullet tracers")
local var_0_202 = ui.new_color_picker("VISUALS", "Effects", "Color", 255, 255, 255, 255)

queue = {}

client.set_event_callback("bullet_impact", function(arg_116_0)
	if not ui.get(var_0_201) then
		return
	end

	if client.userid_to_entindex(arg_116_0.userid) ~= entity.get_local_player() then
		return
	end

	local var_116_0, var_116_1, var_116_2 = client.eye_position()

	queue[globals.tickcount()] = {
		var_116_0,
		var_116_1,
		var_116_2,
		arg_116_0.x,
		arg_116_0.y,
		arg_116_0.z,
		globals.curtime() + 2
	}
end)
client.set_event_callback("paint", function()
	if not ui.get(var_0_201) then
		return
	end

	for iter_117_0, iter_117_1 in var_0_188(queue) do
		if globals.curtime() <= iter_117_1[7] then
			local var_117_0, var_117_1 = renderer.world_to_screen(iter_117_1[1], iter_117_1[2], iter_117_1[3])
			local var_117_2, var_117_3 = renderer.world_to_screen(iter_117_1[4], iter_117_1[5], iter_117_1[6])

			if var_117_0 ~= nil and var_117_2 ~= nil and var_117_1 ~= nil and var_117_3 ~= nil then
				renderer.line(var_117_0, var_117_1, var_117_2, var_117_3, ui.get(var_0_202))
			end
		else
			queue[iter_117_0] = nil
		end
	end
end)
client.set_event_callback("round_prestart", function()
	if not ui.get(var_0_201) then
		return
	end

	queue = {}
end)

local var_0_203 = client.set_clan_tag
local var_0_204 = "Omicron.lua"
local var_0_205 = ui.new_checkbox("VISUALS", "EFFECTS", "Clantag omicron")
local var_0_206 = 0.3
local var_0_207 = 0
local var_0_208 = 0
local var_0_209 = false

local function var_0_210()
	local var_119_0 = globals.realtime()

	if var_119_0 - var_0_207 >= var_0_206 then
		var_0_207 = var_119_0
		var_0_208 = var_0_209 and var_0_208 - 1 or var_0_208 + 1

		if var_0_208 >= #var_0_204 then
			var_0_209 = true
		elseif var_0_208 <= 0 then
			var_0_209 = false
		end

		var_0_203(var_0_204:sub(1, var_0_208))
	end
end

local function var_0_211()
	if ui.get(var_0_205) then
		var_0_208 = 0
		var_0_209 = false
	else
		var_0_203("")
	end
end

client.set_event_callback("paint", function()
	if ui.get(var_0_205) then
		var_0_210()
	end
end)
ui.set_callback(var_0_205, var_0_211)
var_0_203("")

reason_counter = {}
reason_counter.spread = 0
reason_counter.death = 0
reason_counter.prediction_error = 0
reason_counter.unknown = 0
chance, bt, predicted_damage, predicted_hitgroup = nil
hitgroup_names = {
	"Body",
	"Head",
	"Chest",
	"Stomach",
	"Left Arm",
	"Right Arm",
	"Left Leg",
	"Right Leg",
	"Neck",
	"?",
	"Gear"
}
pi, max = math.pi, math.max
dynamic = {}
dynamic.__index = dynamic

function dynamic.new(arg_122_0, arg_122_1, arg_122_2, arg_122_3)
	arg_122_0 = max(arg_122_0, 0.001)
	arg_122_1 = max(arg_122_1, 0)
	pif = pi * arg_122_0
	twopif = 2 * pif
	a = arg_122_1 / pif
	b = 1 / (twopif * twopif)
	c = arg_122_2 * arg_122_1 / twopif

	return setmetatable({
		dy = 0,
		a = a,
		b = b,
		c = c,
		px = arg_122_3,
		y = arg_122_3
	}, dynamic)
end

function dynamic.update(arg_123_0, arg_123_1, arg_123_2, arg_123_3)
	if arg_123_3 == nil then
		arg_123_3 = (arg_123_2 - arg_123_0.px) / arg_123_1
		arg_123_0.px = arg_123_2
	end

	arg_123_0.y = arg_123_0.y + arg_123_1 * arg_123_0.dy
	arg_123_0.dy = arg_123_0.dy + arg_123_1 * (arg_123_2 + arg_123_0.c * arg_123_3 - arg_123_0.y - arg_123_0.a * arg_123_0.dy) / arg_123_0.b

	return arg_123_0
end

function dynamic.get(arg_124_0)
	return arg_124_0.y
end

logs = {}
aimbot_logs_enabled = ui.new_checkbox("VISUALS", "Effects", "Aimbot Logs")
aimbotlogs = ui.new_multiselect("VISUALS", "Effects", "Aimbot logs type", "Console")

local function var_0_212()
	local var_125_0 = ui.get(aimbot_logs_enabled)

	ui.set_visible(aimbotlogs, var_125_0)
end

ui.set_callback(aimbot_logs_enabled, var_0_212)
var_0_212()

function aim_fire(arg_126_0)
	chance = math.floor(arg_126_0.hit_chance)
	bt = globals.tickcount() - arg_126_0.tick
	predicted_damage = arg_126_0.damage
	predicted_hitgroup = arg_126_0.hitgroup
end

function aim_hit(arg_127_0)
	var_0_35 = hitgroup_names[arg_127_0.hitgroup + 1] or "?"
	name = entity.get_player_name(arg_127_0.target)
	damage = arg_127_0.damage
	hp_left = entity.get_prop(arg_127_0.target, "m_iHealth")
	js = panorama.open()
	persona_api = js.MyPersonaAPI
	username = persona_api.GetName()
	targetname = name
	hitbox = var_0_35
	dmg = damage
	hc = chance
	backtrack = bt
	predicted_group = hitgroup_names[predicted_hitgroup + 1] or "?"

	if var_0_121(ui.get(aimbotlogs), "Console") then
		print(string.format("[Omicron] Registered shot at %s's in the %s for %s damage (bt: %s) (hc: %s)", name, string.lower(hitbox), damage, backtrack, hc))
	end
end

function aim_miss(arg_128_0)
	var_0_35 = hitgroup_names[arg_128_0.hitgroup + 1] or "?"
	name = entity.get_player_name(arg_128_0.target)
	hp_left = entity.get_prop(arg_128_0.target, "m_iHealth")
	js = panorama.open()
	persona_api = js.MyPersonaAPI
	username = persona_api.GetName()
	targetname = name
	hitbox = var_0_35
	hc = chance
	backtrack = bt
	reason = arg_128_0.reason
	predicted_group = hitgroup_names[predicted_hitgroup + 1] or "?"

	if reason == "?" then
		reason = "resolver"
		reason_counter.unknown = reason_counter.unknown + 1
	elseif reason == "spread" then
		reason_counter.spread = reason_counter.spread + 1
	elseif reason == "death" then
		reason_counter.death = reason_counter.death + 1
	elseif reason == "prediction error" then
		reason_counter.prediction_error = reason_counter.prediction_error + 1
	end

	if var_0_121(ui.get(aimbotlogs), "Console") then
		print(string.format("[Omicron] Missed to %s's %s due to %s (hc: %s)", string.lower(entity.get_player_name(arg_128_0.target)), string.lower(predicted_group), reason, hc))
	end
end

function logging()
	screen = {
		client.screen_size()
	}

	for iter_129_0 = 1, #logs do
		if not logs[iter_129_0] then
			return
		end

		if not logs[iter_129_0].init then
			logs[iter_129_0].y = dynamic.new(2, 1, 1, -30)
			logs[iter_129_0].time = globals.tickcount() + 180
			logs[iter_129_0].init = true
		end

		string_size = renderer.measure_text("c", logs[iter_129_0].text)
		hitcolor2 = {
			ui.get(menu.aimbotlogscolor)
		}
		miscolor2 = {
			ui.get(menu.aimbotlogscolor2)
		}
		renderstring = " " .. logs[iter_129_0].text .. " "

		if ui.get(aimbot_logs_enabled) then
			if string.sub(logs[iter_129_0].text, 1, 1) == "H" then
				var_0_13(screen[1] / 2 + 5, screen[2] / 2 + 400 - logs[iter_129_0].y:get() + 39, hitcolor2[1], hitcolor2[2], hitcolor2[3], 25, 25, 25, hitcolor2[4], "nil", renderstring, 255, 255, 255, 255)
			elseif string.sub(logs[iter_129_0].text, 1, 1) == "M" then
				var_0_13(screen[1] / 2 + 5, screen[2] / 2 + 400 - logs[iter_129_0].y:get() + 39, miscolor2[1], miscolor2[2], miscolor2[3], 25, 25, 25, miscolor2[4], "nil", renderstring, 255, 255, 255, 255)
			end
		end

		get_max = (logs[iter_129_0].time - globals.tickcount()) * string_size / 252

		if #logs > 5 then
			table.remove(logs, 1)
		end

		if tonumber(logs[iter_129_0].time) < globals.tickcount() then
			if logs[iter_129_0].y:get() < -10 then
				table.remove(logs, iter_129_0)
			else
				logs[iter_129_0].y:update(globals.frametime(), -50, nil)
			end
		else
			logs[iter_129_0].y:update(globals.frametime(), 5 + iter_129_0 * 30, nil)
		end
	end
end

client.set_event_callback("aim_fire", aim_fire)
client.set_event_callback("aim_hit", aim_hit)
client.set_event_callback("aim_miss", aim_miss)
client.set_event_callback("shutdown", function()
	var_0_37(false)
end)
