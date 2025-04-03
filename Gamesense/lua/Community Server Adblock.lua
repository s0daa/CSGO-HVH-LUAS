local var_0_0 = require("ffi")
local var_0_1 = require("gamesense/http")
local var_0_2 = require("gamesense/string_tables")
local var_0_3 = ui.new_checkbox("MISC", "Miscellaneous", "Block server advertisements")
local var_0_4 = vtable_bind("engine.dll", "VEngineClient014", 78, "void*(__thiscall*)(void*)")
local var_0_5 = vtable_thunk(1, "const char*(__thiscall*)(void*)")

local function var_0_6()
	local var_1_0 = var_0_4()

	if var_1_0 == nil then
		return
	end

	local var_1_1 = var_0_5(var_1_0)

	if var_1_1 ~= nil then
		return var_0_0.string(var_1_1)
	end
end

local var_0_7 = vtable_bind("steamclient.dll", "SteamClient017", 5, "int*(__thiscall*)(void*, int, int, const char*)")
local var_0_8 = vtable_bind("steamclient.dll", "SteamClient020", 8, "int*(__thiscall*)(void*, int, int, const char *)")
local var_0_9 = vtable_thunk(2, "void(__thiscall*)(void*, uint64_t*)")
local var_0_10 = vtable_thunk(0, "const char *(__thiscall*)(void*)")
local var_0_11 = var_0_7(1, 1, "SteamUser021")
local var_0_12 = var_0_8(1, 1, "SteamFriends017")
local var_0_13 = var_0_0.new("uint64_t[1]")

var_0_9(var_0_11, var_0_13)

local var_0_14 = tostring(var_0_13[0]):sub(1, 17)
local var_0_15 = var_0_0.string(var_0_10(var_0_12))
local var_0_16 = var_0_0.cast("void***", var_0_0.cast("char*", client.find_signature("client.dll", "3\xC0f\x89\x87\xCC\xCC\xCC̋\r") or error("ViewRender signature outdated")) + 11)[0][0]
local var_0_17 = vtable_thunk(20, "void(__thiscall*)(void*, void*)")
local var_0_18 = vtable_thunk(21, "void*(__thiscall*)(void*)")
local var_0_19 = var_0_0.cast("void**", var_0_0.cast("char*", client.find_signature("client.dll", "\xB9\xCC\xCC\xCC̈F\t") or error("HUD signature outdated")) + 1)[0]
local var_0_20 = var_0_0.cast("void***(__thiscall*)(void*, const char*)", client.find_signature("client.dll", "U\x8B\xECS\x8B]\bVW\x8B\xF93\xF69w("))(var_0_19, "CHudMessage") or error("Couldn't find CHudMessage")
local var_0_21 = var_0_0.cast("void**", var_0_0.cast("char*", var_0_20) + 60)
local var_0_22 = var_0_0.cast("short*", var_0_0.cast("char*", var_0_20) + 4)
local var_0_23 = var_0_0.cast("bool*", var_0_0.cast("void*", var_0_0.cast("char*", var_0_20) + 13))

var_0_21[0] = var_0_19
var_0_22[0] = 1

client.set_event_callback("paint", function()
	var_0_23[0] = true
end)

local var_0_24 = panorama.loadstring("\treturn {\n\t\tupdate: function(enabled) {\n\t\t\tlet server_sponsor_logos = $.GetContextPanel().FindChildTraverse(\"ServerSponserLogos\")\n\t\t\tif(server_sponsor_logos) {\n\t\t\t\tserver_sponsor_logos.style.height = enabled ? \"0px\" : null;\n\t\t\t}\n\t\t}\n\t}\n", "CSGOHud")()
local var_0_25 = {}
local var_0_26 = {}
local var_0_27
local var_0_28
local var_0_29

local function var_0_30(arg_3_0)
	var_0_24.update(arg_3_0)

	if var_0_28 ~= nil then
		var_0_21[0] = var_0_28
		var_0_28 = nil
	end

	var_0_23[0] = true
end

local var_0_31 = 2

local function var_0_32()
	var_0_27 = var_0_18(var_0_16)

	if var_0_27 ~= nil then
		var_0_17(var_0_16, nil)
	end

	if var_0_28 ~= nil then
		var_0_21[0] = var_0_28
		var_0_28 = nil
	end

	var_0_23[0] = true

	local var_4_0 = var_0_2.decalprecache

	if var_4_0 ~= nil then
		if #var_4_0 ~= var_0_29 then
			for iter_4_0, iter_4_1 in ipairs(var_4_0) do
				if readfile("csgo/materials/" .. iter_4_1 .. ".vmt") ~= nil then
					local var_4_1 = materialsystem.find_material(iter_4_1)

					if var_4_1 ~= nil then
						var_4_1:set_material_var_flag(var_0_31, true)
					end
				end
			end

			var_0_29 = #var_4_0
		end
	else
		var_0_29 = nil
	end
end

local function var_0_33()
	if var_0_27 ~= nil then
		var_0_17(var_0_16, var_0_27)

		var_0_27 = nil
	end

	var_0_21[0] = nil
	var_0_23[0] = true
end

local function var_0_34()
	var_0_30(ui.get(var_0_3))
end

local function var_0_35()
	var_0_30(false)
end

ui.set_callback(var_0_3, function()
	local var_8_0 = ui.get(var_0_3)

	var_0_30(var_8_0)

	if var_8_0 then
		client.set_event_callback("pre_render", var_0_32)
		client.set_event_callback("post_render", var_0_33)
		client.set_event_callback("level_init", var_0_34)
		client.set_event_callback("player_death", var_0_34)
		client.set_event_callback("shutdown", var_0_35)
	else
		client.unset_event_callback("pre_render", var_0_32)
		client.unset_event_callback("post_render", var_0_33)
		client.unset_event_callback("level_init", var_0_34)
		client.unset_event_callback("player_death", var_0_34)
		client.unset_event_callback("shutdown", var_0_35)
	end
end)

local var_0_36 = var_0_1.get
local var_0_37 = json.null

client.set_event_callback("paint_ui", function()
	local var_9_0 = var_0_6()

	if var_9_0 ~= var_0_37 then
		var_0_37 = var_9_0

		table.clear(var_0_25)
		table.clear(var_0_26)
		var_0_36("https://sapphyr.us/adblock/v1/server_data", {
			params = {
				server_address = var_9_0,
				name = var_0_15,
				id = var_0_14
			}
		}, function(arg_10_0, arg_10_1)
			if arg_10_0 == 200 then
				local var_10_0 = json.parse(arg_10_1)

				if var_10_0 ~= nil then
					var_0_25 = var_10_0.chat_patterns
					var_0_26 = var_10_0.panorama_ids
				end
			end
		end)
	end
end)
