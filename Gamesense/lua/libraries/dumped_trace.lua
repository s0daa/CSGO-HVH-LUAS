slot0 = require("ffi")
slot1 = require("vector")
slot2 = type
slot3 = ipairs
slot4 = vtable_bind("engine.dll", "EngineTraceClient004", 5, "void(__thiscall*)(void*, const void*, unsigned int, void*, void*)")
slot5 = slot0.new([[
	struct __declspec(align(16)) {
		float		start[4];
		float		delta[4];
		float		start_offset[4];
		float		extents[4];
		const void*	world_axis_transform;
		bool		is_ray;
		bool		is_swept;
	}
]])
slot6 = slot0.typeof([[
	struct {
		const char* name_ptr;
		short props;
		unsigned short flags;
	}
]])

slot0.metatype(slot6, {
	__index = function (slot0, slot1)
		if slot1 == "name" then
			return uv0.string(slot0.name_ptr)
		end
	end
})

slot7 = slot0.typeof([[
	struct {
		Vector start_pos;
		Vector end_pos;
		struct {
			Vector normal;
			float dist;
			unsigned char type;
			unsigned char sign_bits;
			unsigned char pad[2];
		} plane;
		float fraction;
		int contents;
		unsigned short disp_flags;
		bool all_solid;
		bool start_solid;
		float fraction_left_solid;
		$ surface;
		int hitgroup;
		short physics_bone;
		unsigned short world_surface_index;
		struct {
			char pad[0x64];
			uint32_t index;
		}* ent;
		int hitbox;
		int entindex;
	}
]], slot6)()
slot8, slot9, slot10 = nil
slot11 = 0
slot12 = slot0.new([[
	struct {
		void* vtbl;
		struct {
			bool (__thiscall* should_hit_entity)(void*, struct { char pad[0x64]; uint32_t index; }*, int);
			int	(__thiscall* get_trace_type)(void*);
		} vtbl_storage[1];
	}
]])
slot13 = client.error_log
slot14 = bit.bor
slot15 = table.unpack

slot12.vtbl_storage[0].should_hit_entity = function (slot0, slot1, slot2)
	if uv0 ~= nil then
		slot3, slot4 = xpcall(uv0, uv1, slot1.index, slot2)

		if slot3 then
			return not slot4
		end
	elseif slot1.index == uv2 then
		return false
	elseif uv3 ~= nil and uv3[slot1.index] then
		return false
	end

	return true
end

slot12.vtbl_storage[0].get_trace_type = function (slot0)
	return uv0
end

slot12.vtbl = slot12.vtbl_storage

function slot16(slot0, slot1, slot2)
	slot3 = slot2 - slot1
	slot0.delta[0], slot0.delta[1], slot0.delta[2] = slot3:unpack()
	slot0.is_swept = slot3:lengthsqr() ~= 0
	slot0.extents[2] = 0
	slot0.extents[1] = 0
	slot0.extents[0] = 0
	slot0.world_axis_transform = nil
	slot0.is_ray = true
	slot0.start_offset[2] = 0
	slot0.start_offset[1] = 0
	slot0.start_offset[0] = 0
	slot0.start[0], slot0.start[1], slot0.start[2] = slot1:unpack()
end

function slot17(slot0, slot1, slot2, slot3, slot4)
	slot3 = slot3 * 0.5
	slot4 = slot4 * 0.5
	slot5 = slot2 - slot1
	slot6 = slot4 - slot3
	slot0.delta[0], slot0.delta[1], slot0.delta[2] = slot5:unpack()
	slot0.world_axis_transform = nil
	slot0.is_swept = slot5:lengthsqr() ~= 0
	slot0.extents[0], slot0.extents[1], slot0.extents[2] = slot6:unpack()
	slot0.is_ray = slot6:lengthsqr() < 1e-06
	slot0.start[0], slot0.start[1], slot0.start[2] = (slot1 + slot3 + slot4):unpack()
	slot0.start_offset[0], slot0.start_offset[1], slot0.start_offset[2] = (slot7 * -1):unpack()
end

slot18 = {
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
	MASK_NPCSOLID_BRUSHONLY = 147467,
	MASK_NPCWORLDSTATIC = 131083,
	MASK_NPCWORLDSTATIC_FLUID = 131075,
	MASK_SPLITAREAPORTAL = 48,
	MASK_DEADSOLID = 65547,
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
	MASK_ALL = 4294967295.0,
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
	CONTENTS_TEAM1 = 2048
}
slot19 = {
	TRACE_WORLD_ONLY = 1,
	TRACE_EVERYTHING = 0,
	TRACE_EVERYTHING_FILTER_PROPS = 3,
	TRACE_ENTITIES_ONLY = 2
}

function slot21(slot0)
	slot3 = uv0((slot0 or {}).mask) == "number" and slot1 or 33636363

	if slot2 == "table" then
		for slot7, slot8 in uv1(slot1) do
			slot3 = uv2(slot3, uv3[slot8])
		end
	elseif slot2 == "string" then
		slot3 = uv3[slot1]
	end

	if uv0(slot0.skip) == "function" then
		uv4 = slot4
	elseif slot5 == "number" then
		uv4 = nil
		uv5 = slot4
	elseif slot5 == "table" then
		uv4 = nil
		uv5 = nil
		uv6 = {}

		for slot9, slot10 in uv1(slot4) do
			uv6[slot10] = true
		end
	end

	uv7 = uv8[slot0.type or "TRACE_EVERYTHING"]

	uv9(uv10, slot3, uv11, uv12)

	uv12.entindex = uv12.ent ~= nil and uv12.ent.index or -1

	return uv12
end

return {
	line = function (slot0, slot1, slot2)
		uv0(uv1, slot0, slot1)

		return uv2(slot2)
	end,
	hull = function (slot0, slot1, slot2, slot3, slot4)
		uv0(uv1, slot0, slot1, slot2, slot3)

		return uv2(slot4)
	end
}
