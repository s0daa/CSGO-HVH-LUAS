local ffi = require "ffi"

ffi.cdef[[
	typedef struct {float x, y, z;}vec3_t;

    typedef struct {
		int         m_nType;
		void*       m_pStartEnt;
		int         m_nStartAttachment;
		void*       m_pEndEnt;
		int         m_nEndAttachment;
		vec3_t      m_vecStart;
		vec3_t      m_vecEnd;
		int         m_nModelIndex;
		const       char* m_pszModelName;
		int         m_nHaloIndex;
		const       char* m_pszHaloName;
		float       m_flHaloScale;
		float       m_flLife;
		float       m_flWidth;
		float       m_flEndWidth;
		float       m_flFadeLength;
		float       m_flAmplitude;
		float       m_flBrightness;
		float       m_flSpeed;
		int         m_nStartFrame;
		float       m_flFrameRate;
		float       m_flRed;
		float       m_flGreen;
		float       m_flBlue;
		bool        m_bRenderable;
		int         m_nSegments;
		int         m_nFlags;
		vec3_t      m_vecCenter;
		float       m_flStartRadius;
		float       m_flEndRadius;
	} beam_info_t;
]]

local iVmodelInfo = ffi.cast("void***", memory.create_interface("engine.dll", "VModelInfoClient004"))
local findOrLoadModel = ffi.cast("void*(__thiscall*)(void*, const char*)", iVmodelInfo[0][39])

local networktbl = ffi.cast("void***", memory.create_interface("engine.dll", "VEngineClientStringTable001"))
local find_tbl = ffi.cast("void*(__thiscall*)(void*, const char*)", networktbl[0][3])

local renderBeams = ffi.cast("void**", ffi.cast("char*", memory.find_pattern("client.dll", "B9 ? ? ? ? A1 ? ? ? ? FF 10 A1 ? ? ? ? B9")) + 1)[0]
local renderBeams_vtbl = ffi.cast("void***", renderBeams)
local drawBeams = ffi.cast("void(__thiscall*)(void*, void*)", renderBeams_vtbl[0][6])

local beams_vtbl = {
    Points = 12,
    Ring = 13,
    RingPoint = 14,
    CirclePoints = 15
}
local beams = setmetatable({cached = {}}, {__index = beams_vtbl})

function beams.new()
    return ffi.new("beam_info_t")
end

function beams._preCacheModel(modelName)
	if beams.cached[modelName] then return end

	local precachetbl = ffi.cast("void***", find_tbl(networktbl, "modelprecache"))

	if precachetbl ~= ffi.new("void***") then
		local addString = ffi.cast("int(__thiscall*)(void*, bool, const char*, int, const void*)", precachetbl[0][8])
		findOrLoadModel(iVmodelInfo, modelName)
		addString(precachetbl, false, modelName, -1, nil)
		beams.cached[modelName] = true
	end
end

for key, value in pairs(beams_vtbl) do
    beams[string.format("fncreate%s", key)] = ffi.cast("void*(__thiscall*)(void*, beam_info_t&)", renderBeams_vtbl[0][value])
    beams[string.format("createBeam%s", key)] = function(beam_info_t)
		local beam = beams[string.format("fncreate%s", key)](renderBeams_vtbl, beam_info_t)
		beams._preCacheModel(ffi.string(beam_info_t.m_pszModelName))
		drawBeams(renderBeams, beam)
    end
end

return beams