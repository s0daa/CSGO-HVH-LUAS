-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local var_0_0 = require("ffi")
local var_0_1 = entity
local var_0_2 = ui
local var_0_3 = globals
local var_0_4 = bit
local var_0_5 = 14
local var_0_6 = 100
local var_0_7 = {
	"models/props/de_mirage/towertop_d/towertop_d",
	"models/props/de_dust/palace_bigdome",
	"models/props_lighting/",
	"decals/",
	"particle/",
	"de_nuke/nuke_beam_"
}
local var_0_8 = {
	"models/props/de_dust/hr_dust/dust_skybox/",
	"models/props/de_inferno/hr_i/inferno_skybox",
	"models/props/de_nuke/hr_nuke/nuke_skydome_001",
	"models/props/cs_office/clouds",
	"skybox/"
}
local var_0_9 = var_0_2.reference("VISUALS", "Effects", "Remove fog")
local var_0_10 = var_0_2.reference("VISUALS", "Colored models", "Props")
local var_0_11 = var_0_2.new_checkbox("VISUALS", "Effects", "Override fog")
local var_0_12 = var_0_2.new_color_picker("VISUALS", "Effects", "Override fog color", 235, 225, 225, 105)
local var_0_13 = var_0_2.new_slider("VISUALS", "Effects", "\nFog start color", -5000 / var_0_6, 15000 / var_0_6, 0 / var_0_6, true, "", var_0_6)
local var_0_14 = var_0_2.new_slider("VISUALS", "Effects", "\nFog end color", -5000 / var_0_6, 15000 / var_0_6, 7500 / var_0_6, true, "", var_0_6)
local var_0_15 = var_0_2.new_checkbox("VISUALS", "Effects", "Skybox fog")

var_0_2.set_visible(var_0_13, false)
var_0_2.set_visible(var_0_14, false)
var_0_2.set_visible(var_0_15, false)
var_0_2.set(var_0_15, true)

local var_0_16 = vtable_bind("client.dll", "VClientEntityList003", 3, "uintptr_t(__thiscall*)(void*, int)")

cvar.r_disable_distance_fade_on_big_props:set_raw_int(1)
cvar.r_disable_distance_fade_on_big_props_thresh:set_raw_float(500)

local var_0_17 = var_0_0.cast("intptr_t**", var_0_0.cast("char*", client.find_signature("engine.dll", "\xBE\xCC\xCC\xCC̋\x0E\x85\xC9t\v\x8B\x01\xFFP4")) + 1)[0]
local var_0_18
local var_0_19 = 1
local var_0_20 = var_0_0.new("uint8_t[4]")
local var_0_21 = var_0_0.cast("uint32_t*", var_0_20)

local function var_0_22(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	var_0_20[0] = arg_1_0
	var_0_20[1] = arg_1_1
	var_0_20[2] = arg_1_2
	var_0_20[3] = arg_1_3

	return var_0_21[0]
end

local function var_0_23(arg_2_0, arg_2_1, arg_2_2)
	return var_0_4.bor(arg_2_0, var_0_4.lshift(arg_2_1, 8), var_0_4.lshift(arg_2_2, 16))
end

local var_0_24 = {}

local function var_0_25(arg_3_0, arg_3_1, ...)
	var_0_24[arg_3_0][arg_3_1] = {
		var_0_1.get_prop(arg_3_0, arg_3_1)
	}

	var_0_1.set_prop(arg_3_0, arg_3_1, ...)
end

local function var_0_26()
	for iter_4_0, iter_4_1 in pairs(var_0_24) do
		for iter_4_2, iter_4_3 in pairs(iter_4_1) do
			var_0_1.set_prop(iter_4_0, iter_4_2, unpack(iter_4_3))
		end
	end

	table.clear(var_0_24)
end

local function var_0_27(arg_5_0)
	local var_5_0 = not arg_5_0 and var_0_2.get(var_0_11)

	for iter_5_0, iter_5_1 in ipairs(var_0_7) do
		for iter_5_2, iter_5_3 in ipairs(materialsystem.find_materials(iter_5_1) or {}) do
			iter_5_3:set_material_var_flag(var_0_5, not var_5_0)

			local var_5_1 = iter_5_3:get_shader_param("$fogfadeend")

			if var_5_1 ~= nil and (var_5_1 == 0 or var_5_1 > 0.3) then
				iter_5_3:set_shader_param("$fogfadeend", 0.33)
			end

			if iter_5_3:get_shader_param("$fogscale") ~= nil then
				iter_5_3:set_shader_param("$fogscale", 1)
			end

			if iter_5_3:get_shader_param("$vertexfogamount") ~= nil then
				iter_5_3:set_shader_param("$vertexfogamount", 2)
			end
		end
	end

	local var_5_2 = var_5_0 and var_0_2.get(var_0_15)

	for iter_5_4, iter_5_5 in ipairs(var_0_8) do
		for iter_5_6, iter_5_7 in ipairs(materialsystem.find_materials(iter_5_5) or {}) do
			iter_5_7:set_material_var_flag(var_0_5, not var_5_2)
		end
	end

	local var_5_3 = var_0_3.mapname() or ""

	if var_5_3:find("office") then
		var_0_19 = 1.75
	elseif var_5_3:find("italy") then
		var_0_19 = 1.3
	else
		var_0_19 = 1
	end
end

local function var_0_28()
	local var_6_0 = var_0_1.get_local_player()

	if var_6_0 == nil then
		return
	end

	local var_6_1 = 1
	local var_6_2, var_6_3, var_6_4, var_6_5 = var_0_2.get(var_0_12)
	local var_6_6 = var_0_23(var_6_2, var_6_3, var_6_4)
	local var_6_7 = var_0_2.get(var_0_13) * var_0_6 * var_0_19
	local var_6_8 = var_0_2.get(var_0_14) * var_0_6 * var_0_19
	local var_6_9 = var_6_5 / 255
	local var_6_10 = var_0_4.band(math.max(0, var_0_1.get_prop(var_6_0, "m_PlayerFog.m_hCtrl") or 0), 65535)

	if var_6_10 > 0 and var_6_10 < 65535 then
		var_0_24[var_6_10] = {}

		var_0_25(var_6_10, "m_fog.enable", var_6_1)
		var_0_25(var_6_10, "m_fog.dirPrimary", 0, 0, 0)
		var_0_25(var_6_10, "m_fog.colorPrimary", var_6_6)
		var_0_25(var_6_10, "m_fog.colorSecondary", var_6_6)
		var_0_25(var_6_10, "m_fog.start", var_6_7)
		var_0_25(var_6_10, "m_fog.end", var_6_8)
		var_0_25(var_6_10, "m_fog.maxdensity", var_6_9)
		var_0_25(var_6_10, "m_fog.ZoomFogScale", 0)
		var_0_25(var_6_10, "m_fog.HDRColorScale", 1)
		var_0_25(var_6_10, "m_fog.blend", 0)
		var_0_25(var_6_10, "m_fog.duration", 0)
	end

	var_0_24[var_6_0] = {}

	var_0_25(var_6_0, "m_skybox3d.fog.enable", var_6_1)
	var_0_25(var_6_0, "m_skybox3d.fog.dirPrimary", 0, 0, 0)
	var_0_25(var_6_0, "m_skybox3d.fog.colorPrimary", var_6_6)
	var_0_25(var_6_0, "m_skybox3d.fog.colorSecondary", var_6_6)
	var_0_25(var_6_0, "m_skybox3d.fog.start", var_6_7)
	var_0_25(var_6_0, "m_skybox3d.fog.end", var_6_8)
	var_0_25(var_6_0, "m_skybox3d.fog.maxdensity", var_6_9)
	var_0_25(var_6_0, "m_skybox3d.fog.HDRColorScale", 1)
	var_0_25(var_6_0, "m_skybox3d.fog.blend", 0)

	local var_6_11 = tonumber(var_0_17[0])

	if var_6_11 ~= var_0_18 then
		var_0_27()

		var_0_18 = var_6_11
	end
end

local function var_0_29()
	var_0_26()

	if not var_0_2.get(var_0_11) then
		client.unset_event_callback("pre_render", var_0_28)
		client.unset_event_callback("post_render", var_0_29)
	end
end

local function var_0_30()
	var_0_27()
	client.delay_call(0, var_0_27)
end

local function var_0_31()
	var_0_27(true)
end

var_0_2.set_callback(var_0_11, function()
	local var_10_0 = var_0_2.get(var_0_11)

	if var_10_0 then
		client.set_event_callback("pre_render", var_0_28)
		client.set_event_callback("post_render", var_0_29)
		client.set_event_callback("level_init", var_0_30)
		client.set_event_callback("shutdown", var_0_31)
		var_0_2.set(var_0_9, false)
	else
		client.unset_event_callback("level_init", var_0_30)
		client.unset_event_callback("shutdown", var_0_31)
	end

	var_0_2.set_visible(var_0_13, var_10_0)
	var_0_2.set_visible(var_0_14, var_10_0)
	var_0_2.set_visible(var_0_15, var_10_0)
	var_0_27()
end)
var_0_2.set_callback(var_0_15, function()
	var_0_27()
end)
var_0_2.set_callback(var_0_10, function()
	var_0_27()
end)
var_0_2.set_callback(var_0_9, function()
	if var_0_2.get(var_0_9) then
		var_0_2.set(var_0_11, false)
	end
end)
