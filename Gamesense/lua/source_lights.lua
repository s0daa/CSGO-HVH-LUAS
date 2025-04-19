slot0 = require("ffi")
slot1 = slot0.cast
slot2 = slot0.new
slot3 = require("vector")
slot6 = {
	DLIGHT_NO_WORLD_ILLUMINATION = 1,
	DLIGHT_DISPLACEMENT_MASK = 12,
	DLIGHT_SUBTRACT_DISPLACEMENT_ALPHA = 8,
	DLIGHT_ADD_DISPLACEMENT_ALPHA = 4,
	DLIGHT_NO_MODEL_ILLUMINATION = 2
}
slot7 = vtable_bind("engine.dll", "VEngineEffects001", 4, "void*(__thiscall*)(void*,int)")
slot8 = vtable_bind("engine.dll", "VEngineEffects001", 5, "void*(__thiscall*)(void*,int)")
slot9 = vtable_bind("engine.dll", "VEngineEffects001", 8, "void*(__thiscall*)(void*,int)")
slot11 = {}
slot12 = slot0.typeof("$ *", slot0.metatype(slot0.typeof([[
	struct {
		int	 flags;
		Vector  origin;
		float   radius;
		$   color;	  // Light color with exponent
		float   die;				// stop lighting after this time
		float   decay;			  // drop this each second
		float   minlight;		   // don't add when contributing less
		int	 key;
		int	 style;			  // lightstyle
		// For spotlights. Use m_OuterAngle == 0 for point lights
		Vector  m_Direction;		// center of the light cone
		float   m_InnerAngle;
		float   m_OuterAngle;
	}
]], slot0.typeof([[
	struct {
		unsigned char r,g,b;
		signed char exponent;
	}
]])), {
	__index = slot11
}))

function slot11.set_color(slot0, slot1, slot2, slot3, slot4)
	slot0.color.r = slot1
	slot0.color.g = slot2
	slot0.color.b = slot3
	slot0.color.exponent = slot4
end

function slot11.set_flags(slot0, ...)
	for slot5, slot6 in pairs({
		...
	}) do
		slot1 = bit.bor(0, uv0[slot6] or slot6)
	end

	slot0.flags = slot1
end

return {
	create_dlight = function (slot0)
		return uv1(uv2, uv0(slot0))
	end,
	create_elight = function (slot0)
		return uv1(uv2, uv0(slot0))
	end,
	get_elight_by_key = function (slot0)
		return uv1(uv2, uv0(slot0))
	end
}
