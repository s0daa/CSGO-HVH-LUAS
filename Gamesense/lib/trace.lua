-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("ffi")
local var_0_1 = require("vector")
local var_0_2 = type
local var_0_3 = ipairs
local var_0_4 = vtable_bind("engine.dll", "EngineTraceClient004", 5, "void(__thiscall*)(void*, const void*, unsigned int, void*, void*)")
local var_0_5 = var_0_0.new("\tstruct __declspec(align(16)) {\n\t\tfloat\t\tstart[4];\n\t\tfloat\t\tdelta[4];\n\t\tfloat\t\tstart_offset[4];\n\t\tfloat\t\textents[4];\n\t\tconst void*\tworld_axis_transform;\n\t\tbool\t\tis_ray;\n\t\tbool\t\tis_swept;\n\t}\n")
local var_0_6 = var_0_0.typeof("\tstruct {\n\t\tconst char* name_ptr;\n\t\tshort props;\n\t\tunsigned short flags;\n\t}\n")

var_0_0.metatype(var_0_6, {
	__index = function(arg_1_0, arg_1_1)
		if arg_1_1 == "name" then
			return var_0_0.string(arg_1_0.name_ptr)
		end
	end
})

local var_0_7 = var_0_0.typeof("\tstruct {\n\t\tVector start_pos;\n\t\tVector end_pos;\n\t\tstruct {\n\t\t\tVector normal;\n\t\t\tfloat dist;\n\t\t\tunsigned char type;\n\t\t\tunsigned char sign_bits;\n\t\t\tunsigned char pad[2];\n\t\t} plane;\n\t\tfloat fraction;\n\t\tint contents;\n\t\tunsigned short disp_flags;\n\t\tbool all_solid;\n\t\tbool start_solid;\n\t\tfloat fraction_left_solid;\n\t\t$ surface;\n\t\tint hitgroup;\n\t\tshort physics_bone;\n\t\tunsigned short world_surface_index;\n\t\tstruct {\n\t\t\tchar pad[0x64];\n\t\t\tuint32_t index;\n\t\t}* ent;\n\t\tint hitbox;\n\t\tint entindex;\n\t}\n", var_0_6)()
local var_0_8
local var_0_9
local var_0_10
local var_0_11 = 0
local var_0_12 = var_0_0.new("\tstruct {\n\t\tvoid* vtbl;\n\t\tstruct {\n\t\t\tbool (__thiscall* should_hit_entity)(void*, struct { char pad[0x64]; uint32_t index; }*, int);\n\t\t\tint\t(__thiscall* get_trace_type)(void*);\n\t\t} vtbl_storage[1];\n\t}\n")
local var_0_13 = client.error_log
local var_0_14 = bit.bor
local var_0_15 = table.unpack

var_0_12.vtbl_storage[0].should_hit_entity = function(arg_2_0, arg_2_1, arg_2_2)
	if var_0_8 ~= nil then
		local var_2_0, var_2_1 = xpcall(var_0_8, var_0_13, arg_2_1.index, arg_2_2)

		if var_2_0 then
			return not var_2_1
		end
	elseif arg_2_1.index == var_0_9 then
		return false
	elseif var_0_10 ~= nil and var_0_10[arg_2_1.index] then
		return false
	end

	return true
end
var_0_12.vtbl_storage[0].get_trace_type = function(arg_3_0)
	return var_0_11
end
var_0_12.vtbl = var_0_12.vtbl_storage

local function var_0_16(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_2 - arg_4_1

	arg_4_0.delta[0], arg_4_0.delta[1], arg_4_0.delta[2] = var_4_0:unpack()
	arg_4_0.is_swept = var_4_0:lengthsqr() ~= 0
	arg_4_0.extents[0], arg_4_0.extents[1], arg_4_0.extents[2] = 0, 0, 0
	arg_4_0.world_axis_transform = nil
	arg_4_0.is_ray = true
	arg_4_0.start_offset[0], arg_4_0.start_offset[1], arg_4_0.start_offset[2] = 0, 0, 0
	arg_4_0.start[0], arg_4_0.start[1], arg_4_0.start[2] = arg_4_1:unpack()
end

local function var_0_17(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	arg_5_3 = arg_5_3 * 0.5
	arg_5_4 = arg_5_4 * 0.5

	local var_5_0 = arg_5_2 - arg_5_1
	local var_5_1 = arg_5_4 - arg_5_3
	local var_5_2 = arg_5_3 + arg_5_4
	local var_5_3 = arg_5_1 + var_5_2

	arg_5_0.delta[0], arg_5_0.delta[1], arg_5_0.delta[2] = var_5_0:unpack()
	arg_5_0.world_axis_transform = nil
	arg_5_0.is_swept = var_5_0:lengthsqr() ~= 0
	arg_5_0.extents[0], arg_5_0.extents[1], arg_5_0.extents[2] = var_5_1:unpack()
	arg_5_0.is_ray = var_5_1:lengthsqr() < 1e-06
	arg_5_0.start[0], arg_5_0.start[1], arg_5_0.start[2] = var_5_3:unpack()

	local var_5_4 = var_5_2 * -1

	arg_5_0.start_offset[0], arg_5_0.start_offset[1], arg_5_0.start_offset[2] = var_5_4:unpack()
end

local var_0_18 = {
	MASK_PLAYERSOLID_BRUSHONLY = 81931,
	MASK_SOLID_BRUSHONLY = 16395,
	MASK_SHOT_PORTAL = 33570819,
	MASK_SHOT_HULL = 100679691,
	MASK_SHOT_BRUSHONLY = 67125251,
	MASK_WEAPONCLIPPING = 100679683,
	MASK_FLOORTRACE = 67125251,
	MASK_SHOT = 1174421507,
	MASK_VISIBLE_AND_NPCS = 33579137,
	MASK_VISIBLE = 24705,
	MASK_BLOCKLOS_AND_NPCS = 33570881,
	MASK_BLOCKLOS = 16449,
	MASK_OPAQUE_AND_NPCS = 33570945,
	MASK_OPAQUE = 16513,
	MASK_WATER = 16432,
	MASK_NPCFLUID = 33701891,
	MASK_NPCSOLID = 33701899,
	MASK_PLAYERSOLID = 33636363,
	MASK_SOLID = 33570827,
	MASK_ALL = 4294967295,
	CONTENTS_HITBOX = 1073741824,
	CONTENTS_LADDER = 536870912,
	CONTENTS_TRANSLUCENT = 268435456,
	CONTENTS_DETAIL = 134217728,
	CONTENTS_DEBRIS = 67108864,
	CONTENTS_MONSTER = 33554432,
	CONTENTS_ORIGIN = 16777216,
	CONTENTS_UNUSED5 = 8388608,
	CONTENTS_UNUSED4 = 4194304,
	CONTENTS_UNUSED3 = 2097152,
	CONTENTS_UNUSED2 = 1048576,
	CONTENTS_GRENADECLIP = 524288,
	CONTENTS_BRUSH_PAINT = 262144,
	CONTENTS_MONSTERCLIP = 131072,
	CONTENTS_PLAYERCLIP = 65536,
	CONTENTS_AREAPORTAL = 32768,
	CONTENTS_MOVEABLE = 16384,
	CONTENTS_IGNORE_NODRAW_OPAQUE = 8192,
	CONTENTS_TEAM2 = 4096,
	CONTENTS_TEAM1 = 2048,
	CONTENTS_BLOCKLIGHT = 1024,
	CONTENTS_UNUSED = 512,
	CONTENTS_TESTFOGVOLUME = 256,
	ALL_VISIBLE_CONTENTS = 255,
	LAST_VISIBLE_CONTENTS = 128,
	CONTENTS_OPAQUE = 128,
	CONTENTS_BLOCKLOS = 64,
	CONTENTS_WATER = 32,
	CONTENTS_SLIME = 16,
	CONTENTS_GRATE = 8,
	CONTENTS_AUX = 4,
	CONTENTS_WINDOW = 2,
	CONTENTS_SOLID = 1,
	CONTENTS_EMPTY = 0,
	MASK_DEADSOLID = 65547,
	MASK_SPLITAREAPORTAL = 48,
	MASK_NPCWORLDSTATIC_FLUID = 131075,
	MASK_NPCWORLDSTATIC = 131083,
	MASK_NPCSOLID_BRUSHONLY = 147467
}
local var_0_19 = {
	TRACE_WORLD_ONLY = 1,
	TRACE_EVERYTHING = 0,
	TRACE_EVERYTHING_FILTER_PROPS = 3,
	TRACE_ENTITIES_ONLY = 2
}
local var_0_20 = {}

local function var_0_21(arg_6_0)
	arg_6_0 = arg_6_0 or {}

	local var_6_0 = arg_6_0.mask
	local var_6_1 = var_0_2(var_6_0)
	local var_6_2 = var_6_1 == "number" and var_6_0 or 33636363

	if var_6_1 == "table" then
		for iter_6_0, iter_6_1 in var_0_3(var_6_0) do
			var_6_2 = var_0_14(var_6_2, var_0_18[iter_6_1])
		end
	elseif var_6_1 == "string" then
		var_6_2 = var_0_18[var_6_0]
	end

	local var_6_3 = arg_6_0.skip
	local var_6_4 = var_0_2(var_6_3)

	if var_6_4 == "function" then
		var_0_8 = var_6_3
	elseif var_6_4 == "number" then
		var_0_8 = nil
		var_0_9 = var_6_3
	elseif var_6_4 == "table" then
		var_0_8 = nil
		var_0_9 = nil
		var_0_10 = {}

		for iter_6_2, iter_6_3 in var_0_3(var_6_3) do
			var_0_10[iter_6_3] = true
		end
	end

	var_0_11 = var_0_19[arg_6_0.type or "TRACE_EVERYTHING"]

	var_0_4(var_0_5, var_6_2, var_0_12, var_0_7)

	var_0_7.entindex = var_0_7.ent ~= nil and var_0_7.ent.index or -1

	return var_0_7
end

function var_0_20.line(arg_7_0, arg_7_1, arg_7_2)
	var_0_16(var_0_5, arg_7_0, arg_7_1)

	return var_0_21(arg_7_2)
end

function var_0_20.hull(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	var_0_17(var_0_5, arg_8_0, arg_8_1, arg_8_2, arg_8_3)

	return var_0_21(arg_8_4)
end

return var_0_20
