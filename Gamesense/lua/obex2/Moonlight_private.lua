-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local function pre_require(module, url_link)
	local success, result = pcall(require, module)
	if success then
        return result
    else
        client.error_log("Missing module. Module name: "..module, "  Url: "..url_link)
    end
end


-- Normal Require
local bit = require('bit')
local ffi = require('ffi')
local vector = require("vector")

-- Library Require
local pui = pre_require('gamesense/pui', 'https://gamesense.pub/forums/viewtopic.php?id=41761')
local trace = pre_require('gamesense/trace', 'https://gamesense.pub/forums/viewtopic.php?id=32949')
local base64 = pre_require('gamesense/base64', 'https://gamesense.pub/forums/viewtopic.php?id=21619')
local surface = pre_require('gamesense/surface', 'https://gamesense.pub/forums/viewtopic.php?id=18793')
local csgo_weapons = pre_require("gamesense/csgo_weapons", 'https://gamesense.pub/forums/viewtopic.php?id=18807')
-- local engineclient = pre_require('gamesense/engineclient', 'https://gamesense.pub/forums/viewtopic.php?id=42362')

-- FFI Settings
ffi.cdef[[
    typedef struct
    {
        float x;
        float y;
        float z;
    } Vector_t;

    typedef struct
    {
        float pitch;
        float yaw;
        float roll;
    } QAngle_t;

    typedef struct
    {
        int				m_nType;
        void*			m_pStartEnt;
        int				m_nStartAttachment;
        void*			m_pEndEnt;
        int				m_nEndAttachment;
        Vector_t			m_vecStart;
        Vector_t			m_vecEnd;
        int				m_nModelIndex;
        const char*		m_pszModelName;
        int				m_nHaloIndex;
        const char*		m_pszHaloName;
        float			m_flHaloScale;
        float			m_flLife;
        float			m_flWidth;
        float			m_flEndWidth;
        float			m_flFadeLength;
        float			m_flAmplitude;
        float			m_flBrightness;
        float			m_flSpeed;
        int				m_nStartFrame;
        float			m_flFrameRate;
        float			m_flRed;
        float			m_flGreen;
        float			m_flBlue;
        bool			m_bRenderable;
        int				m_nSegments;
        int				m_nFlags;
        Vector_t			m_vecCenter;
        float			m_flStartRadius;
        float			m_flEndRadius;
    } beams_t;

    typedef struct {
        float    friction;
        float    elasticity;	// collision elasticity - used to compute coefficient of restitution
        float    density;		// physical density (in kg / m^3)
        float    thickness;		// material thickness if not solid (sheet materials) in inches
        float    dampening;
    } surfacephysicsparams_t;

    typedef struct {
        float    reflectivity;				// like elasticity, but how much sound should be reflected by this surface
        float    hardnessFactor;			// like elasticity, but only affects impact sound choices
        float    roughnessFactor;			// like friction, but only affects scrape sound choices   
        float    roughThreshold;			// surface roughness > this causes "rough" scrapes, < this causes "smooth" scrapes
        float    hardThreshold;				// surface hardness > this causes "hard" impacts, < this causes "soft" impacts
        float    hardVelocityThreshold;		// collision velocity > this causes "hard" impacts, < this causes "soft" impacts 
        float    highPitchOcclusion;        // a value betweeen 0 and 100 where 0 is not occluded at all and 100 is silent (except for any additional reflected sound)
        float    midPitchOcclusion;
        float    lowPitchOcclusion;
    } surfaceaudioparams_t;

    typedef struct {
        short walkLeft;
        short walkRight;
        short runLeft;
        short runRight;
        short impactsoft;
        short impacthard;
        short scrapesmooth;
        short scraperough;
        short bulletimpact;
        short rolling;
        short breakSound; // named "break" in vphysics.dll but since break is also a type rename it to breakSound
        short strain;
    } surfacesoundnames_t;

    typedef struct {
        float maxspeedfactor;
        float jumpfactor;
        float penetrationmodifier;
        float damagemodifier;
        uint16_t material;
        uint8_t climbable;
    } surfacegameprops_t;

    typedef struct {
        surfacephysicsparams_t physics;
        surfaceaudioparams_t audio;
        surfacesoundnames_t sounds;
        surfacegameprops_t game;
        char pad[48];
    } surfacedata_t;

    typedef struct {
		char pad[3];
		char m_bForceWeaponUpdate; //0x4
		char pad1[91];
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
		char pad2[4];
		float m_flFeetCycle; //0x98
		float m_flFeetYawRate; //0x9C
		char pad3[4];
		float m_fDuckAmount; //0xA4
		float m_fLandingDuckAdditiveSomething; //0xA8
		char pad4[4];
		float m_vOriginX; //0xB0
		float m_vOriginY; //0xB4
		float m_vOriginZ; //0xB8
		float m_vLastOriginX; //0xBC
		float m_vLastOriginY; //0xC0
		float m_vLastOriginZ; //0xC4
		float m_vVelocityX; //0xC8
		float m_vVelocityY; //0xCC
		char pad5[4];
		float m_flUnknownFloat1; //0xD4
		char pad6[8];
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
		char pad7[4]; //0x11A
		float m_flMagicFraction; //0x11E
		char pad8[60]; //0x122
		float m_flWorldForce; //0x15E
		char pad9[462]; //0x162
		float m_flMaxYaw; //0x334
	} csgo_anim_state_t;

    typedef struct {
        char  pad_0000[20];
        int m_nOrder; //0x0014
        int m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030
        char  pad_0038[4]; //0x0034
    } csgo_anim_overlay_t;

    int VirtualFree(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType);
    void* VirtualAlloc(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect);
    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);
]]

local render_beams = ffi.cast('void**',ffi.cast('char*', client.find_signature('client.dll', '\xB9\xCC\xCC\xCC\xCC\xA1\xCC\xCC\xCC\xCC\xFF\x10\xA1\xCC\xCC\xCC\xCC\xB9')) + 1)[0]
local g_pViewRenderBeams = ffi.cast('void***', render_beams)
local draw_beams = ffi.cast('void(__thiscall*)(void*, void*)', g_pViewRenderBeams[0][6])
local create_beam_points = ffi.cast('void*(__thiscall*)(void*, beams_t&)', g_pViewRenderBeams[0][12])

local native_GetClipboardTextCount = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
local native_SetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
local native_GetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")

local native_GetSurfaceData = vtable_bind("vphysics.dll", "VPhysicsSurfaceProps001", 5, "surfacedata_t*(__thiscall*)(void*, int)")

local native_GetClientEntity = vtable_bind("client.dll", "VClientEntityList003", 3, 'void*(__thiscall*)(void*, int)')

-- Surface
local native_CreateFont = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 71, "int(__thiscall*)(void*)")
local native_SetFontGlyphSet = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 72, "void(__thiscall*)(void*, int, const char*, int, int, int, int, int)")

-- Init Surface Data
local fonts_flags = {
    FONTFLAG_NONE           = 0x000,
    FONTFLAG_ITALIC         = 0x001,
    FONTFLAG_UNDERLINE      = 0x002,
    FONTFLAG_STRIKEOUT      = 0x004,
    FONTFLAG_SYMBOL         = 0x008,
    FONTFLAG_ANTIALIAS      = 0x010,
    FONTFLAG_GAUSSIANBLUR   = 0x020,
    FONTFLAG_ROTARY         = 0x040,
    FONTFLAG_DROPSHADOW     = 0x080,
    FONTFLAG_ADDITIVE       = 0x100,
    FONTFLAG_OUTLINE        = 0x200,
    FONTFLAG_CUSTOM         = 0x400,
    FONTFLAG_BITMAP         = 0x800,
}

-- Helpers and Functions
local new_char_arr = ffi.typeof("char[?]")
local ffi_helpers = {
    get_clipboard_text = function ()
        local len = native_GetClipboardTextCount()

        if len > 0 then
            local char_arr = new_char_arr(len)
            native_GetClipboardText(0, char_arr, len)
            return ffi.string(char_arr, len-1)
        end
    end,

    set_clipboard_text = function (text)
        text = tostring(text)
	    native_SetClipboardText(text, string.len(text))
    end,

    get_anim_state = function (player)
        if player == nil or not entity.is_alive(player) then return end

        local player_ptr = native_GetClientEntity(player)
        local animstate_ptr = ffi.cast("uintptr_t" , player_ptr) + 0x3900
        local anime_state = ffi.cast("csgo_anim_state_t**", animstate_ptr)[0]

        return anime_state
    end,

    get_anim_overlay = function (player, index)
        if player == nil or not entity.is_alive(player) then return end
        if index < 0 or index > 12 then return end

        local player_ptr = native_GetClientEntity(player)
        local animoverlay_ptr = ffi.cast("uintptr_t" , player_ptr) + 0x2990
        local anime_overlay = ffi.cast("csgo_anim_overlay_t**", animoverlay_ptr)[0][index]

        return anime_overlay
    end
}

local panorama_helpers = {
    open_link = function (link)
        local format_callbacks = ([[
            return SteamOverlayAPI.OpenExternalBrowserURL("^link^")
        ]])

        panorama.loadstring(format_callbacks:gsub('%^link^', link))()
    end
}

local math_fn = {
    round = function (value)
        return math.floor(value + 0.5)
    end,

    get_2d_distance = function (x1, y1, x2, y2)
        return math.sqrt((x2-x1)^2 + (y2-y1)^2)
    end,

    get_distance = function(x1, y1, z1, x2, y2, z2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    end,

    angle_to_vector = function (x, y)
        local degree_to_radian = function (degree)
            return (math.pi / 180) * degree
        end
    
        local pitch = degree_to_radian(x)
        local yaw = degree_to_radian(y)
        return {math.cos(pitch) * math.cos(yaw), math.cos(pitch) * math.sin(yaw), -math.sin(pitch)}
    end,

    time_to_ticks = function (ticks)
        return math.floor(0.5 + (ticks / globals.tickinterval()))
    end,

    extrapolate = function (player, origin, ticks)
        local vel = {entity.get_prop(player, 'm_vecVelocity')}
    
        if vel == nil then return nil end
    
        local predication_tick = globals.tickinterval() * ticks
        return {origin[1] + (vel[1] * predication_tick), origin[2] + (vel[2] * predication_tick), origin[3] + (vel[3] * predication_tick)}
    end,

    lerp_position = function (x1, y1, z1, x2, y2, z2, percentage)
        -- 如果到相差到0，就会停止STEP加
        local x = (x2 - x1) * percentage + x1
        local y = (y2 - y1) * percentage + y1
        local z = (z2 - z1) * percentage + z1
        return x, y, z
    end
}

local color_fn = {
    hsvToRgb = function(h, s, v, a)
        local r, g, b
      
        local i = math.floor(h * 6);
        local f = h * 6 - i;
        local p = v * (1 - s);
        local q = v * (1 - f * s);
        local t = v * (1 - (1 - f) * s);
      
        i = i % 6
      
        if i == 0 then r, g, b = v, t, p
        elseif i == 1 then r, g, b = q, v, p
        elseif i == 2 then r, g, b = p, v, t
        elseif i == 3 then r, g, b = p, q, v
        elseif i == 4 then r, g, b = t, p, v
        elseif i == 5 then r, g, b = v, p, q
        end
      
        return r * 255, g * 255, b * 255, a * 255
    end,

    gradient_static_text = function (r1, g1, b1, a1, r2, g2, b2, a2, text)
        local output = ''
        local len = #text-1
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len
        for i=1, len+1 do
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
            r1 = r1 + rinc
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc
        end

        return output
    end,

    gradient_static_surface_text = function (x, y, r1, g1, b1, a1, r2, g2, b2, a2, text, current_fonts)
        local len = #text-1
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len

        local start_x = 0
        for i=1, len+1 do
            surface.draw_text(x+start_x, y, r1, g1, b1, a1, current_fonts, text:sub(i, i))
            
            r1 = r1 + rinc
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc

            local current_text_x, nah_y = surface.get_text_size(current_fonts, text:sub(i, i))
            start_x = start_x + current_text_x
        end
    end,

    gradient_anim_text = function(text_to_draw, speed, color1, color2)
        local highlight_fraction =  (globals.realtime() / 2 % 1.2 * speed) - 1.2
        local output = ""

        local r, g, b, a = unpack(color1)
        local r2, g2, b2, a2 = unpack(color2)
        for idx = 1, #text_to_draw do
            local character_fraction = idx / #text_to_draw
    
            local highlight_delta = (character_fraction - highlight_fraction)
            if highlight_delta >= 0 and highlight_delta <= 1.4 then
                if highlight_delta > 0.7 then
                    highlight_delta = 1.4 - highlight_delta
                end
                local r_fraction, g_fraction, b_fraction = r2 - r, g2 - g, b2 - b
                r = r + r_fraction * highlight_delta / 0.8
                g = g + g_fraction * highlight_delta / 0.8
                b = b + b_fraction * highlight_delta / 0.8
            end
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, a, text_to_draw:sub(idx, idx))
        end
        return output
    end,
}

local table_fn = {
    contains = function(table, element)
        for _, value in pairs(table) do
            if value == element then
                return true
            end
        end
        return false
    end,
    
    remove_by_value = function(tables, element)
        local results = tables
        for _, value in pairs(results) do
            if value == element then
                table.remove(results, _)
            end
        end
        return results
    end,
}

local render_fn = {
    circle_3d = function (ctx, x, y, z, radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage)
        accuracy = accuracy ~= nil and accuracy or 3
        width = width ~= nil and width or 1
        outline = outline ~= nil and outline or false
        start_degrees = start_degrees ~= nil and start_degrees or 0
        percentage = percentage ~= nil and percentage or 1

        local screen_x_line_old, screen_y_line_old
        for rot=start_degrees, percentage*360, accuracy do
            local rot_temp = math.rad(rot)
            local lineX, lineY, lineZ = radius * math.cos(rot_temp) + x, radius * math.sin(rot_temp) + y, z
            local screen_x_line, screen_y_line = client.world_to_screen(ctx, lineX, lineY, lineZ)
            if screen_x_line ~=nil and screen_x_line_old ~= nil then
                for i=1, width do
                    local i=i-1
                    client.draw_line(ctx, screen_x_line, screen_y_line-i, screen_x_line_old, screen_y_line_old-i, r, g, b, a)
                end
                if outline then
                    local outline_a = a/255*160
                    client.draw_line(ctx, screen_x_line, screen_y_line-width, screen_x_line_old, screen_y_line_old-width, 16, 16, 16, outline_a)
                    client.draw_line(ctx, screen_x_line, screen_y_line+1, screen_x_line_old, screen_y_line_old+1, 16, 16, 16, outline_a)
                end
            end
            screen_x_line_old, screen_y_line_old = screen_x_line, screen_y_line
        end
    end,

    shadow = function (x, y, w, h, r, g, b, a, length)
        for i = 1, 15 do
            surface.draw_outlined_rect(x - i, y - i, w + i, h + i, r, g, b, (60 - (60 / length) * i) * (a / 255))
        end
    end
}

local surface_render = {
    create_fonts = function(fonts_name, size, flags)
        flags = (flags == nil) and "" or flags

        local flags_value = 0
        local weight = 400

        if string.find(flags, "o") ~= nil then
            flags_value = flags_value + fonts_flags.FONTFLAG_OUTLINE
        end

        if string.find(flags, "d") ~= nil then
            flags_value = flags_value + fonts_flags.FONTFLAG_DROPSHADOW
        end

        if string.find(flags, "a") ~= nil then
            flags_value = flags_value + fonts_flags.FONTFLAG_ANTIALIAS
        end

        if string.find(flags, "i") ~= nil then
            flags_value = flags_value + fonts_flags.FONTFLAG_ITALIC
        end

        if string.find(flags, "u") ~= nil then
            flags_value = flags_value + fonts_flags.FONTFLAG_SYMBOL + fonts_flags.FONTFLAG_CUSTOM
        end

        if string.find(flags, "b") ~= nil then
            weight = 700
        end

        if flags_value ~= 0 then
            flags_value = bit.bor(flags_value)
        end

        local create_fonts = native_CreateFont()
        native_SetFontGlyphSet(create_fonts, fonts_name, size, weight, 0, 0, flags_value)

        return create_fonts
    end,
}

local vmt_hook = {list={}}
vmt_hook.copy = function(void, source, length)
    return ffi.copy(ffi.cast("void*", void), ffi.cast("const void*", source), length)
end

vmt_hook.virtual_protect = function(point, size, new_protect, old_protect)
    return ffi.C.VirtualProtect(ffi.cast("void*", point), size, new_protect, old_protect)
end

vmt_hook.virtual_alloc = function(point, size, allocation_type, protect)
    local alloc = ffi.C.VirtualAlloc(point, size, allocation_type, protect)
    return ffi.cast("intptr_t", alloc)
end

vmt_hook.new = function(address)
    local cache = {
        data = {},
        org_func = {},

        old_protection = ffi.new("unsigned long[1]"),
        virtual_table = ffi.cast("intptr_t**", address)[0]
    }

    cache.data.hook = function(cast, __function, method)
        cache.org_func[method] = cache.virtual_table[method]
        vmt_hook.virtual_protect(cache.virtual_table + method, 4, 0x4, cache.old_protection)

        cache.virtual_table[method] = ffi.cast("intptr_t", ffi.cast(cast, __function))
        vmt_hook.virtual_protect(cache.virtual_table + method, 4, cache.old_protection[0], cache.old_protection)

        return ffi.cast(cast, cache.org_func[method])
    end

    cache.data.unhook = function(method)
        vmt_hook.virtual_protect(cache.virtual_table + method, 4, 0x4, cache.old_protection)

        local alloc_addr = vmt_hook.virtual_alloc(nil, 5, 0x1000, 0x40)
        local trampoline_bytes = ffi.new("uint8_t[?]", 5, 0x90)

        trampoline_bytes[0] = 0xE9
        ffi.cast("int32_t*", trampoline_bytes + 1)[0] = cache.org_func[method] - tonumber(alloc_addr) - 5

        vmt_hook.copy(alloc_addr, trampoline_bytes, 5)
        cache.virtual_table[method] = ffi.cast("intptr_t", alloc_addr)

        vmt_hook.virtual_protect(cache.virtual_table + method, 4, cache.old_protection[0], cache.old_protection)
        cache.org_func[method] = nil
    end

    cache.data.unhook_all = function()
        for method, _ in pairs(cache.org_func) do
            cache.data.unhook(method)
        end
    end

    table.insert(vmt_hook.list, cache.data.unhook_all)
    return cache.data
end


-- Materials
local scope_materials = {
    "dev/scope_bluroverlay",
    "overlays/scope_lens",
    "sprites/scope_line_blur",
    "sprites/scope_arc",
	"models/weapons/shared/scope/scope_dot_green",
	"models/weapons/shared/scope/scope_dot_red"
}


-- Reference
local gamesense = {
    enabled = pui.reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = {pui.reference("AA", "Anti-aimbot angles", "Pitch")},
    yaw_base = pui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {pui.reference("AA", "Anti-aimbot angles", "Yaw")},
    yaw_jitter = {pui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    body_yaw = {pui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    edge_yaw = pui.reference("AA", "Anti-aimbot angles", "Edge Yaw"),
    freestanding = pui.reference("AA", "Anti-aimbot angles", "Freestanding"),
    freestanding_by = pui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    roll = {pui.reference("AA", "Anti-aimbot angles", "Roll")},
}

local other_menu = {
    double_tap = {pui.reference("RAGE", "Aimbot", "Double tap")},
    double_tap_hitchance = pui.reference("RAGE", "Aimbot", "Double tap hit chance"),
    double_tap_fakelag = pui.reference("RAGE", "Aimbot", "Double tap fake lag limit"),

    slow_motion = pui.reference("AA", "Other", "Slow motion"),
    legs_movement = pui.reference("AA", "Other", "Leg Movement"),
    fake_peek = pui.reference("AA", "Other", "Fake Peek"),
    on_shot_aa = pui.reference("AA", "Other", "On shot anti-aim"),

    target_selection = pui.reference("RAGE", "Aimbot", "Target selection"),
    hitboxes = pui.reference("RAGE", "Aimbot", "Target hitbox"),
    mutlipoint = pui.reference("RAGE", "Aimbot", "Multi-point"),
    mutlipoint_scale = pui.reference("RAGE", "Aimbot", "Multi-point scale"),
    hitchance = pui.reference("RAGE", "Aimbot", "Minimum hit chance"),
    min_dmg = pui.reference("RAGE", "Aimbot", "Minimum damage"),
    o_min_dmg = {pui.reference("RAGE", "Aimbot", "Minimum damage override")},
    avoid_unsafe_hitboxes = pui.reference("RAGE", "Aimbot", "Avoid unsafe hitboxes"),
    prefer_sp = pui.reference("RAGE", "Aimbot", "Prefer safe point"),
    prefer_ba = pui.reference("RAGE", "Aimbot", "Prefer body aim"),
    prefer_ba_disablers = pui.reference("RAGE", "Aimbot", "Prefer body aim disablers"),
    force_sp = pui.reference("RAGE", "Aimbot", "Force safe point"),
    force_ba = pui.reference("RAGE", "Aimbot", "Force body aim"),
    force_ba_on_peek = pui.reference("RAGE", "Aimbot", "Force body aim on peek"),

    quick_stop = {pui.reference("RAGE", "Aimbot", "Quick stop")},
    automatic_scope = pui.reference("RAGE", "Aimbot", "Automatic scope"),

    accuracy_boost = pui.reference("RAGE", "Other", "Accuracy boost"),
    delay_shot = pui.reference("RAGE", "Other", "Delay shot"),
    peek_assist = pui.reference("RAGE", "Other", "Quick peek assist"),
    peek_assist_mode = pui.reference("RAGE", "Other", "Quick peek assist mode"),
    duck_peek_assist = pui.reference("RAGE", "Other", "Duck peek assist"),
    low_fps = pui.reference("RAGE", "Other", "Low FPS mitigations"),

    thirdperson = pui.reference("VISUALS", "Effects", "Force third person (alive)")
}


pui.accent = '80C0FFFF'


-- Init data
local pitch_status = {'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random', 'Custom'}
local player_status = {"Globals", "Standing", "Running", "Slow-motion", "Duck", "Air", "Air-duck"}
local hitgroup_names = {'Generic', 'Head', 'Chest', 'Stomach', 'Left arm', 'Right arm', 'Left leg', 'Right leg', 'Neck', 'Unknown', 'Gear'}
local hitboxes = {
	['chest'] = {2, 3, 4},
	['stomach'] = {5, 6},
	['arms'] = {13, 14, 15, 16, 17, 18},
	['legs'] = {7, 8, 9, 10},
	['feet'] = {11, 12},
    ['head'] = {0},
}

local weapon_list = {'Globals', 'Pistols', 'R8 Revolver', 'Deagle', 'Scout', 'AWP', 'AutoSniper', 'Rifles', 'SMG', 'Shotguns', 'Taser'}
local weapon_idx_to_weapon = {
    ["Pistols"] = {30, 32, 36, 61, 63, 2, 3, 4},
    ["R8 Revolver"] = {64},
    ["Deagle"] = {1},
    ["Scout"] = {40},
    ["AWP"] = {9},
    ["AutoSniper"] = {11, 38},
    ["Rifles"] = {7, 8, 10, 13, 14, 16, 28, 39, 60},
    ["SMG"] = {17, 19, 23, 24, 26, 33, 34},
    ["Shotguns"] = {25, 27, 29, 35},
    ["Taser"] = {31},
}

local hitchance_tooltips = {[0]='Off'}
local multipoint_tooltips = {[24]='Auto'}
local damage_tooltips  = {[-1]='Close', [0] = "Auto", [101] = "HP+1", [102] = "HP+2", [103] = "HP+3", [104] = "HP+4", [105] = "HP+5", [106] = "HP+6", [107] = "HP+7", [108] = "HP+8", [109] = "HP+9", [110] = "HP+10", [111] = "HP+11", [112] = "HP+12", [113] = "HP+13", [114] = "HP+14", [115] = "HP+15", [116] = "HP+16", [117] = "HP+17", [118] = "HP+18", [119] = "HP+19", [120] = "HP+20", [121] = "HP+21", [122] = "HP+22", [123] = "HP+23", [124] = "HP+24", [125] = "HP+25", [126] = "HP+26"}

local accuracy_boost = {"Low", "Medium", "High", "Maximum"}
local target_hitboxes = {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}
local target_selection = {"Highest damage", "Cycle", "Cycle (2x)", "Near crosshair", "Best hit chance"}
local normal_quick_stop = {"Early", "Slow motion", "Duck", "Fake duck", "Move between shots", "Ignore molotov", "Taser", "Jump scout"}
local dt_quick_stop = {"Slow motion", "Duck", "Move between shots"}
local prefer_body_aim_disablers = {"Low inaccuracy", "Target shot fired", "Target resolved", "Safe point headshot"}
local low_fps = {'Force low accuracy boost', 'Disable multipoint: feet', 'Disable multipoint: arms', 'Disable multipoint: legs', 'Disable hitbox: feet', 'Lower hit chance precision', 'Limit targets per tick'}


-- Fonts
local current_fonts = surface_render.create_fonts("Comic Sans MS", 12, "biad")

-- Anti-aimbot ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local menu_group = pui.group("AA", "Anti-aimbot angles")

local aa_builder = function ()
    local result_builder = {}
    for i=1, #player_status, 1 do
        local cache_builder = {}
        local current_status = player_status[i]

        if current_status ~= "Globals" then
            cache_builder.main_switch = menu_group:checkbox(string.format("\v[%s]\r - Override \v%s\r", current_status, current_status))
        end
        
        cache_builder.yaw_modes = menu_group:combobox(string.format("\v[%s]\r - Yaw modes", current_status), {"Static", "Desync", "Heavy", "Random"})
        cache_builder.yaw_slider1 = menu_group:slider(string.format("\n\v[%s]\r - yaw_slider1", current_status), -180, 180, 0)
        cache_builder.yaw_slider2 = menu_group:slider(string.format("\n\v[%s]\r - yaw_slider2", current_status), -180, 180, 0)

        cache_builder.yaw_jitter = menu_group:combobox(string.format("\v[%s]\r - Yaw jitter", current_status), {"Off", "Offset", "Center", "Random", "Skitter"})
        cache_builder.yaw_jitter_slider = menu_group:slider(string.format("\n\v[%s]\r - yaw_jitter_slider", current_status), -180, 180, 0)

        cache_builder.body_yaw = menu_group:combobox(string.format("\v[%s]\r - Body yaw", current_status), {"Off", "Opposite", "Static", "Static-desync", "Jitter", "Jitter dynamic"})
        cache_builder.body_yaw_slider1 = menu_group:slider(string.format("\n\v[%s]\r - body_yaw_slider1", current_status), -180, 180, 0)
        cache_builder.body_yaw_slider2 = menu_group:slider(string.format("\n\v[%s]\r - body_yaw_slider2", current_status), -180, 180, 0)

        cache_builder.label_1 = menu_group:label(" ", nil, false)
        cache_builder.label_2 = menu_group:label("\v~ Anti-aimbot defensive settings", nil, false)
        cache_builder.defensive = menu_group:checkbox(string.format("\v[%s]\r - Enable defensive", current_status), false)
        cache_builder.defensive_enable = menu_group:combobox(string.format("\v[%s]\r - Enable defensive mode", current_status), {"Always", "Hotkey"})

        cache_builder.defensive_ticks = menu_group:slider(string.format("\v[%s]\r - Defensive ticks", current_status), 1, 18, 10)
        cache_builder.defensive_mode = menu_group:combobox(string.format("\v[%s]\r - Defensive modes", current_status), {"Yaw only", "Normal", "Spin", "Jitter", "Randomiser", "Fake Spin"})
        
        cache_builder.label_3 = menu_group:label(" ", nil, false)

        cache_builder.defensive_yaw = menu_group:slider(string.format("\v[%s]\r - Defensive yaw", current_status), -180, 180, 0)
        cache_builder.defensive_max_spin = menu_group:slider(string.format("\v[%s]\r - Defensive max spin", current_status), 0, 180, 0)

        cache_builder.label_4 = menu_group:label(" ", nil, false)

        cache_builder.defensive_pitch_mode = menu_group:combobox(string.format("\v[%s]\r - Defensive pitch modes", current_status), {"Static", "Minimal", "Randomiser"})
        cache_builder.defensive_pitch = menu_group:slider(string.format("\v[%s]\r - Defensive pitch", current_status), -89, 89, 0)

        result_builder[current_status] = cache_builder
    end
    
    return result_builder
end

local menu_scripts = {
    ms = menu_group:checkbox("\vMoonLight ReMaster\r Switch"),

    next_line = menu_group:label(" ", nil, false),
    label = menu_group:label("\v~ Main settings", nil, false),
    tabs = menu_group:combobox("Control tabs", {"Main", "Anti-aimbot", "Hotkey", "Misc"}),

    main = {
        label_1 = menu_group:label(" ", nil, false),
        label_2 = menu_group:label("\v~ Information", nil, false),
        release = menu_group:label("\vRelease Date:\r 26.06.2023", nil, false),
        last_update = menu_group:label("\vLast Updated:\r 07.07.2023", nil, false),
        current_version = menu_group:label("\vCurrent Version:\r Beta ReMaster (Soon Stable)", nil, false),

        label_3 = menu_group:label(" ", nil, false),
        label_4 = menu_group:label("\v~ Configs Systems", nil, false),
        export = menu_group:button("Export Configs", function() end, nil, false),
        import = menu_group:button("Import Configs", function() end, nil, false),

        label_5 = menu_group:label(" ", nil, false),
        label_6 = menu_group:label("\v~ Sosials", nil, false),
        discord = menu_group:button("Discord", function() panorama_helpers.open_link("https://discord.gg/kxGhq2kt99") end, nil, false)
    },

    antiaim = {
        label_1 = menu_group:label(" ", nil, false),
        label_2 = menu_group:label("\v~ Anti-aimbot init settings", nil, false),
        pitch = menu_group:combobox('Anti-aimbot pitch', pitch_status),
        custom_pitch = menu_group:slider("\ncustom pitch", -89, 89, 0),
        base = menu_group:combobox('Anti-aimbot yaw base', {'Local view', 'At targets'}),
    
        status = menu_group:combobox("Player Status", player_status),
    
        label_3 = menu_group:label(" ", nil, false),
        label_4 = menu_group:label("\v~ Anti-aimbot builder settings", nil, false),
        builder = aa_builder(),
    },

    hotkey = {
        label_1 = menu_group:label(" ", nil, false),
        label_2 = menu_group:label("\v~ Anti-aimbot manual hotkey", nil, false),
        manual_left = menu_group:hotkey("Manual Left"),
        manual_right = menu_group:hotkey("Manual Right"),
        manual_close = menu_group:hotkey("Close manual"),

        label_3 = menu_group:label(" ", nil, false),
        label_4 = menu_group:label("\v~ Anti-aimbot other hotkey", nil, false),
        freestanding = menu_group:hotkey("Freestanding"),
        legit_aa = menu_group:hotkey("Legit AA"),

        label_5 = menu_group:label(" ", nil, false),
        label_6 = menu_group:label("\v~ Tips", nil, false),
        label_7 = menu_group:label("\v~ If freestanding enabled, manual mode will invalid.", nil, false),
        label_8 = menu_group:label("\v~ If freestanding disabled, ", nil, false),
        label_9 = menu_group:label("\v   will use manual mode if manual mode enabled.", nil, false),

        label_10 = menu_group:label(" ", nil, false),
        label_11 = menu_group:label("\v~ Enable hotkey", nil, false),
        defensive = menu_group:hotkey("Defensive key"),
    },

    misc = {
        label_1 = menu_group:label(" ", nil, false),
        label_2 = menu_group:label("\v~ Anti-aimbot misc settings", nil, false),
        anti_knife = menu_group:checkbox("Anti knife", false),
        fast_ladder = menu_group:checkbox("Fast ladder", false),
        manual_close = menu_group:checkbox("Disable defensive while manual", false),
        manual_close_2 = menu_group:checkbox("Disable body yaw while manual", false),
        legit_close = menu_group:checkbox("Disable body yaw while legit aa", false),
        slow_motion_ms = menu_group:checkbox("Custom slow motion speed", false),
        slow_motion_speed = menu_group:slider("\nSlow motion speed", 10, 65, 50),

        label_3 = menu_group:label(" ", nil, false),
        label_4 = menu_group:label("\v~ Animation breaker settings", nil, false),
        static_legs = menu_group:checkbox("Static legs in air", false),
        legs_fucker = menu_group:checkbox("Legs fucker", false),
        pitch_zero = menu_group:checkbox("Pitch 0 on landing", false),
        duck_legs = menu_group:checkbox("Ducking legs breaker", false),
        slow_motion_legs = menu_group:checkbox("Slow motion legs breaker", false),

        label_5 = menu_group:label(" ", nil, false),
        label_6 = menu_group:label("\v~ Indicator", nil, false),
        crosshair = menu_group:checkbox("Crosshair indicator", false),
        min_dmg = menu_group:checkbox("Min dmg indicator", false),
        min_dmg_side = menu_group:combobox("Min dmg indicator side", {"Left", "Right"}),
        def_indicator = menu_group:checkbox("Defensive enable indicator", false),
        molotov_indicator = menu_group:checkbox("Molotov radius", {255, 255, 255, 255}),

        label_9 = menu_group:label(" ", nil, false),
        label_10 = menu_group:label("\v~ Visuals", nil, false),
        aspect_ratio = menu_group:checkbox("Aspect ratio", false),
        aspect_ratio_value = menu_group:slider("\nAspect ratio", 0, 20, 10, true, "", 0.1),
        viewmodel = menu_group:checkbox("Viewmodel", false),
        viewmodel_settings = {
            fov = menu_group:slider("\nViewmode FOV", -100, 100, 68, true, "°"),
            x = menu_group:slider("\nViewmode X", -100, 100, 25, true, "x", 0.1),
            y = menu_group:slider("\nViewmode Y", -100, 100, 0, true, "y", 0.1),
            z = menu_group:slider("\nViewmode Z", -100, 100, -15, true, "z", 0.1)
        },

        ms_firstperson_fov = menu_group:checkbox("Firstperson POV", false),
        firstperson_fov = menu_group:slider("\nFirstperson FOV", 90, 150, 116),
        ms_thirdperson_fov = menu_group:checkbox("ThirdPerson POV", false),
        thirdperson_fov = menu_group:slider("\nThirdperson FOV", 90, 150, 116),

        label_7 = menu_group:label(" ", nil, false),
        label_8 = menu_group:label("\v~ Hitlogs", nil, false),
        console_hitlogs = menu_group:checkbox("Console hitlogs", false),
    }
}

local menu_visi = function ()
    local main_switch = menu_scripts.ms
    local current_status = menu_scripts.antiaim.status
    local current_tabs = menu_scripts.tabs
    
    for _, menu_items in pairs(menu_scripts) do
        if menu_items == main_switch then goto next end
        if menu_items.type == nil and type(menu_items) == "table" then
            for _, menu_items_children in pairs(menu_items) do
                if menu_items_children.type == nil then goto children_next end
                menu_items_children:depend({main_switch, true})
                ::children_next::
            end
        else
            menu_items:depend({main_switch, true})
        end

        ::next::
    end

    for _, main_menu in pairs(menu_scripts.main) do
        main_menu:depend({current_tabs, "Main"})
    end

    for _, aa_menu in pairs(menu_scripts.antiaim) do
        if aa_menu.type == nil and type(aa_menu) == "table" then goto next end

        aa_menu:depend({current_tabs, "Anti-aimbot"})
        ::next::
    end

    menu_scripts.antiaim.custom_pitch:depend({menu_scripts.antiaim.pitch, "Custom"})

    for builder_status_key, builder_status_menu in pairs(menu_scripts.antiaim.builder) do
        local builder_ms = builder_status_menu.main_switch
        for _, builder_thing in pairs(builder_status_menu) do
            if builder_status_key == "Globals" or builder_thing == builder_ms then
                builder_thing:depend({main_switch, true}, {current_tabs, "Anti-aimbot"}, {current_status, builder_status_key})
            else
                builder_thing:depend({main_switch, true}, {current_tabs, "Anti-aimbot"}, {current_status, builder_status_key}, {builder_ms, true})
            end
        end

        builder_status_menu.yaw_slider2:depend({builder_status_menu.yaw_modes, "Static", true})
        builder_status_menu.yaw_jitter_slider:depend({builder_status_menu.yaw_jitter, "Off", true})
        builder_status_menu.body_yaw_slider1:depend({builder_status_menu.body_yaw, "Static", "Jitter", "Static-desync", true})
        builder_status_menu.body_yaw_slider2:depend({builder_status_menu.body_yaw, "Static-desync"})

        builder_status_menu.defensive_enable:depend({builder_status_menu.defensive, true})
        builder_status_menu.defensive_ticks:depend({builder_status_menu.defensive, true})
        -- builder_status_menu.defensive_ticks:depend({builder_status_menu.defensive, true}, {builder_status_menu.defensive_random_ticks, false})
        builder_status_menu.defensive_mode:depend({builder_status_menu.defensive, true})
        builder_status_menu.defensive_yaw:depend({builder_status_menu.defensive, true}, {builder_status_menu.defensive_mode, "Yaw only", "Normal", "Jitter"})
        builder_status_menu.defensive_max_spin:depend({builder_status_menu.defensive, true}, {builder_status_menu.defensive_mode, "Spin"})
        builder_status_menu.defensive_pitch_mode:depend({builder_status_menu.defensive, true}, {builder_status_menu.defensive_mode, "Normal", "Spin", "Jitter", "Fake Spin"})
        builder_status_menu.defensive_pitch:depend({builder_status_menu.defensive, true}, {builder_status_menu.defensive_mode, "Normal", "Spin", "Jitter", "Fake Spin"}, {builder_status_menu.defensive_pitch_mode, "Static"})
        -- builder_status_menu.defensive_random_ticks:depend({builder_status_menu.defensive, true})
        -- builder_status_menu.defensive_random_min_ticks:depend({builder_status_menu.defensive, true}, {builder_status_menu.defensive_random_ticks, true})
        -- builder_status_menu.defensive_random_max_ticks:depend({builder_status_menu.defensive, true}, {builder_status_menu.defensive_random_ticks, true})
    end

    for _, hotkey_menu in pairs(menu_scripts.hotkey) do
        hotkey_menu:depend({current_tabs, "Hotkey"})
    end

    for _, misc_menu in pairs(menu_scripts.misc) do
        if misc_menu.type == nil and type(misc_menu) == "table" then goto next end

        misc_menu:depend({current_tabs, "Misc"})

        ::next::
    end

    menu_scripts.misc.slow_motion_speed:depend({menu_scripts.misc.slow_motion_ms, true})
    menu_scripts.misc.min_dmg_side:depend({menu_scripts.misc.min_dmg, true})
    menu_scripts.misc.aspect_ratio_value:depend{menu_scripts.misc.aspect_ratio, true}
    menu_scripts.misc.firstperson_fov:depend({menu_scripts.misc.ms_firstperson_fov, true})
    menu_scripts.misc.thirdperson_fov:depend({menu_scripts.misc.ms_thirdperson_fov, true})

    for _, viewmodel_setting in pairs(menu_scripts.misc.viewmodel_settings) do
        viewmodel_setting:depend({menu_scripts.misc.viewmodel, true})
    end
end

menu_visi()

local menu_setup = pui.setup(menu_scripts)
menu_scripts.main.export:set_callback(function ()
    local config = menu_setup:save()
    local encrypted = base64.encode(json.stringify(config))

    ffi_helpers.set_clipboard_text(encrypted)
end)

menu_scripts.main.import:set_callback(function ()
    local configs = ffi_helpers.get_clipboard_text()
    local ds_configs = json.parse(base64.decode(configs))

    menu_setup:load(ds_configs)
end)


local moonlight = {
    lp_in_air = false,
    on_ground_ticks = 0,
    lp_current_status = "Globals",
    dynamic_random = {0, -180, 180},

    defensive = {
        current = 0,
        checker = 0,
        is_enabled = false,
    },

    manual_cache = "Close",
    manual_update = globals.tickcount(),

    respawn = false,

    aa_data = {
        yaw_base = "Local view",
        yaw = 0,
        yaw_mode = "180",
        yaw_jitter = 0,
        yaw_jitter_mode = "Off",
        pitch = "Off",
        custom_pitch = 0,
        body_yaw = "Off",
        body_yaw_value = 0,
    },

    last_shot_list = {},
    last_more_info_shot_list = {},
}

moonlight.check_on_ground_ticks = function ()
    local localplayer = entity.get_local_player()
    if (localplayer == nil) or (not entity.is_alive(localplayer)) then return end

    local lp_flags = entity.get_prop(localplayer, 'm_fFlags')
    local is_on_ground = (bit.band(lp_flags, 1) == 1)
    if is_on_ground then
        moonlight.on_ground_ticks = moonlight.on_ground_ticks + 1
    else
        moonlight.on_ground_ticks = 0
    end
end

moonlight.check_lp_air = function (cmd)
    local localplayer = entity.get_local_player()
    if (localplayer == nil) or (not entity.is_alive(localplayer)) then return end

    local lp_flags = entity.get_prop(localplayer, 'm_fFlags')
    local is_air = (bit.band(lp_flags, 1) == 0) or (cmd.in_jump == 1)

    moonlight.lp_in_air = (is_air) and (moonlight.on_ground_ticks < 3)
end

moonlight.current_status = function (cmd)
    local localplayer = entity.get_local_player()
    if (localplayer == nil) or (not entity.is_alive(localplayer)) then return end

    local check_duck = entity.get_prop(localplayer, 'm_flDuckAmount') > 0.8
    local check_air = moonlight.lp_in_air
    local check_slow_motion = other_menu.slow_motion.value and other_menu.slow_motion:get_hotkey()

    local vx, vy, vz = entity.get_prop(localplayer, "m_vecVelocity")
    local velocity = math.sqrt(vx ^ 2 + vy ^ 2)
    local check_move_key = (cmd.in_moveleft == 1) or (cmd.in_moveright == 1) or (cmd.in_forward == 1) or (cmd.in_back == 1)

    local current_status = "Globals"
    if (check_duck) and (check_air) then
        current_status = "Air-duck"
    elseif check_air then
        current_status = "Air"
    elseif check_duck then
        current_status = "Duck"
    elseif check_slow_motion then
        current_status = "Slow-motion"
    elseif (velocity > 2 and moonlight.on_ground_ticks > 3)  then
        current_status = "Running"
    elseif (velocity < 2) and (not check_move_key) and (moonlight.on_ground_ticks > 3) then
        current_status = "Standing"
    end

    moonlight.lp_current_status = current_status
end

moonlight.current_packet = function (cmd)
    local limit = 14
    if other_menu.duck_peek_assist:get() then
        limit = 14
    elseif (other_menu.double_tap[1].value and other_menu.double_tap[1]:get_hotkey()) or (other_menu.on_shot_aa.value and other_menu.on_shot_aa:get_hotkey()) then
        limit = 1
    end

    local send_packet = true
    if cmd.chokedcommands < limit then
        send_packet = false
    end

    local command_dif = cmd.command_number - cmd.chokedcommands - globals.lastoutgoingcommand()
    send_packet = send_packet or cmd.no_choke or not cmd.allow_send_packet or command_dif ~= 1
    cmd.allow_send_packet = send_packet
    return send_packet
end

moonlight.antiaim = function (cmd)
    local localplayer = entity.get_local_player()
    if localplayer == nil or not entity.is_alive(localplayer) then return end

    local aa_pitch = menu_scripts.antiaim.pitch.value
    local aa_cpitch = menu_scripts.antiaim.custom_pitch.value
    local aa_yaw_base = menu_scripts.antiaim.base.value
  
    moonlight.aa_data.pitch = aa_pitch
    if aa_pitch == "Custom" then
        moonlight.aa_data.custom_pitch = aa_cpitch
    end

    local check_current_status = moonlight.lp_current_status
    if (moonlight.lp_current_status ~= "Globals") and (not menu_scripts.antiaim.builder[moonlight.lp_current_status].main_switch.value) then
        check_current_status = "Globals"
    end

    local current_status = menu_scripts.antiaim.builder[check_current_status]
    local check_dt = other_menu.double_tap[1].value and other_menu.double_tap[1]:get_hotkey()

    moonlight.aa_data.yaw_mode = "180"

    if moonlight.manual_cache == "Close" then
        moonlight.aa_data.yaw_base = aa_yaw_base

        local yaw_modes = current_status.yaw_modes.value
        local yaw_slider_1 = current_status.yaw_slider1.value
        local yaw_slider_2 = current_status.yaw_slider2.value
        if yaw_modes == "Static" then
            moonlight.aa_data.yaw = yaw_slider_1
        else
            if cmd.chokedcommands < 1 and yaw_modes ~= "Packets" then
                if yaw_modes == "Desync" then
                    moonlight.aa_data.yaw = cmd.command_number % 4 >= 2 and yaw_slider_1 or yaw_slider_2
                elseif yaw_modes == "Heavy" then
                    moonlight.aa_data.yaw = cmd.command_number % 6 >= 3 and yaw_slider_1 or yaw_slider_2
                elseif yaw_modes == "Random" then
                    moonlight.aa_data.yaw = client.random_int(0, 5) >= 2 and yaw_slider_1 or yaw_slider_2
                end
            else
                if cmd.chokedcommands > 1 and check_dt then
                    moonlight.aa_data.yaw = client.random_int(10, 14)
                end
            end
        end

        local yaw_jitter = current_status.yaw_jitter.value
        local yaw_jitter_slider = current_status.yaw_jitter_slider.value

        moonlight.aa_data.yaw_jitter = yaw_jitter_slider
        moonlight.aa_data.yaw_jitter_mode = yaw_jitter

        local body_yaw = current_status.body_yaw.value
        local body_yaw_slider1 = current_status.body_yaw_slider1.value
        local body_yaw_slider2 = current_status.body_yaw_slider2.value
        if body_yaw == "Static-desync" then
            moonlight.aa_data.body_yaw = "Static"
            moonlight.aa_data.body_yaw_value = cmd.command_number % 4 >= 2 and body_yaw_slider2 or body_yaw_slider1
        elseif body_yaw == "Jitter dynamic" then
            moonlight.aa_data.body_yaw = "Jitter"
            moonlight.aa_data.body_yaw_value = moonlight.dynamic_random[client.random_int(1, 3)]
        else
            moonlight.aa_data.body_yaw = body_yaw
            if body_yaw ~= "Off" and body_yaw ~= "Opposite" then
                moonlight.aa_data.body_yaw_value = body_yaw_slider1
            end
        end
    else
        moonlight.aa_data.yaw_base = "Local view"
        moonlight.aa_data.yaw_jitter = 0

        if menu_scripts.misc.manual_close_2.value then
            moonlight.aa_data.body_yaw = "Off"
        end
    
        if moonlight.manual_cache == "Right" then
            moonlight.aa_data.yaw = 90
        end
    
        if moonlight.manual_cache == "Left" then
            moonlight.aa_data.yaw = -90
        end
    end

    -- Defensive
    moonlight.defensive.is_enabled = false

    local defensive = current_status.defensive.value
    local check_manual = (menu_scripts.misc.manual_close.value and moonlight.manual_cache ~= "Close")

    other_menu.fake_peek:override()
    other_menu.fake_peek.hotkey:override()
    if defensive and (not check_manual) then
        if current_status.defensive_enable.value == "Hotkey" and not menu_scripts.hotkey.defensive:get() then
            goto end_defensive
        end

        moonlight.defensive.is_enabled = true

        local current_ticks = current_status.defensive_ticks.value
        -- local random_ticks = current_status.defensive_random_ticks.value
        -- local random_min_ticks = current_status.defensive_random_min_ticks.value
        -- local random_max_ticks = current_status.defensive_random_max_ticks.value
        -- if random_ticks then
        --     math.randomseed(entity.get_prop(localplayer, "m_nTickBase"))
        --     current_ticks = math.floor(math.random(random_min_ticks, random_max_ticks))
        -- else
        --     current_ticks = current_status.defensive_ticks.value
        -- end

        local defensive_mode = current_status.defensive_mode.value
        local defensive_yaw = current_status.defensive_yaw.value
        local defensive_pitch_mode = current_status.defensive_pitch_mode.value
        local defensive_pitch = current_status.defensive_pitch.value
        local defensive_max_spin = current_status.defensive_max_spin.value

        local current_packet = moonlight.current_packet(cmd)
        if current_packet then
            cmd.force_defensive = true
            cmd.allow_shift_tickbase = not (globals.tickcount() % math.random(6, 7.5) == 0)
        end

        if moonlight.defensive.current >= current_ticks then
            if defensive_mode == "Normal" or defensive_mode == "Spin" or defensive_mode == "Jitter" or defensive_mode == "Fake Spin" then
                if defensive_pitch_mode == "Static" then
                    moonlight.aa_data.pitch = "Custom"
                    moonlight.aa_data.custom_pitch = defensive_pitch
                elseif defensive_pitch_mode == "Minimal" then
                    moonlight.aa_data.pitch = "Minimal"
                else
                    math.randomseed(math.floor(cmd.command_number / ((cmd.chokedcommands == 0) and 1 or cmd.chokedcommands)))
                    local random_choice_pitch = pitch_status[math.floor(math.random(1, #pitch_status))]
                    moonlight.aa_data.pitch = random_choice_pitch
    
                    if random_choice_pitch == "Custom" then
                        moonlight.aa_data.custom_pitch = math.floor(math.random(-89, 89))
                    end
                end
            end
            
            if (defensive_mode == "Yaw only" or defensive_mode == "Normal") then
                moonlight.aa_data.yaw = defensive_yaw

            elseif defensive_mode == "Spin" then
                moonlight.aa_data.yaw_mode = "Spin"
                moonlight.aa_data.yaw = (math.random(0, 1) > 0.4) and -defensive_max_spin or defensive_max_spin

                moonlight.aa_data.yaw_jitter_mode = "Random"
                moonlight.aa_data.yaw_jitter = 180

            elseif defensive_mode == "Jitter" then
                local body_yaw_stauts = entity.get_prop(localplayer, "m_flPoseParameter", 11) * 120 - 60
                moonlight.aa_data.yaw = body_yaw_stauts and -defensive_yaw or defensive_yaw

            elseif defensive_mode == "Randomiser" then
                math.randomseed(cmd.command_number)
                moonlight.aa_data.yaw = math.floor(math.random(-180, 180))

                local jitter_mode = {"Off", "Offset", "Center", "Random", "Skitter"}
                local random_choice_jitter = jitter_mode[math.floor(math.random(1, #jitter_mode))]

                moonlight.aa_data.yaw_jitter_mode = random_choice_jitter
                if random_choice_jitter ~= "Off" then
                    moonlight.aa_data.yaw_jitter = math.floor(math.random(-180, 180))
                end

            elseif defensive_mode == "Fake Spin" then
                other_menu.fake_peek:override(true)
                other_menu.fake_peek.hotkey:set("Always on")
            end
        end

        ::end_defensive::
    else
        moonlight.defensive.current = 0
        moonlight.defensive.checker = 0
    end
end

moonlight.manual = function ()
    local left = menu_scripts.hotkey.manual_left
    local right = menu_scripts.hotkey.manual_right
    local close = menu_scripts.hotkey.manual_close

    -- Init
    ui.set(left.ref, "On hotkey"); ui.set(right.ref, "On hotkey"); ui.set(close.ref, "On hotkey");

    if moonlight.manual_update > globals.tickcount() then return end

    if left:get() and moonlight.manual_cache ~= "Left" then
        moonlight.manual_cache = "Left"
        moonlight.manual_update = globals.tickcount() + 16
        return

    elseif left:get() and moonlight.manual_cache == "Left" then
        moonlight.manual_cache = "Close"
        moonlight.manual_update = globals.tickcount() + 16
        return
    end

    if right:get() and moonlight.manual_cache ~= "Right" then
        moonlight.manual_cache = "Right"
        moonlight.manual_update = globals.tickcount() + 16
        return

    elseif right:get() and moonlight.manual_cache == "Right" then
        moonlight.manual_cache = "Close"
        moonlight.manual_update = globals.tickcount() + 16
        return
    end

    if close:get() then
        moonlight.manual_cache = "Close"
        moonlight.manual_update = globals.tickcount() + 16
        return
    end
end

moonlight.other_hotkey = function ()
    local freestanding = menu_scripts.hotkey.freestanding
    if freestanding:get() then
        gamesense.freestanding:override(true)
        gamesense.freestanding_by:override(true)
        ui.set(gamesense.freestanding.hotkey.ref, "Always on")
    else
        gamesense.freestanding:override(false)
        gamesense.freestanding_by:override(false)
        ui.set(gamesense.freestanding.hotkey.ref, "Off hotkey")
    end
end

moonlight.anti_knife = function ()
    if not menu_scripts.misc.anti_knife.value then return end

    local players = entity.get_players(true)
    local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")

    for i=1, #players do
        local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
        local distance = math_fn.get_distance(lx, ly, lz, x, y, z)
        local weapon = entity.get_player_weapon(players[i])

        if (entity.get_classname(weapon) == "CKnife") and (distance <= 168) then
            moonlight.aa_data.yaw = 180
        end
    end
end

moonlight.legit_aa = function ()
    if not menu_scripts.hotkey.legit_aa:get() then return end

    moonlight.aa_data.pitch = "Off"
    moonlight.aa_data.custom_pitch = 0
    moonlight.aa_data.yaw_base = "Local view"
    moonlight.aa_data.yaw_mode = "Off"
    moonlight.aa_data.yaw = 0
    moonlight.aa_data.yaw_jitter_mode = "Off"
    moonlight.aa_data.yaw_jitter = 0

    if menu_scripts.misc.legit_close.value then
        moonlight.aa_data.body_yaw = "Off"
    end
end

moonlight.fast_ladder = function (cmd)
    if not menu_scripts.misc.fast_ladder.value then return end

    local local_player = entity.get_local_player()
    local pitch, yaw = client.camera_angles()

    if (entity.get_prop(local_player, 'm_MoveType') == 9) then
        cmd.yaw = math.floor(cmd.yaw+0.5)

        -- 往上爬
        if cmd.forwardmove > 0 then
            if pitch < 45 then
                cmd.pitch = 89
                cmd.in_moveright = 1
                cmd.in_moveleft = 0
                cmd.in_forward = 0
                cmd.in_back = 1
                if cmd.sidemove == 0 then
                    cmd.yaw = cmd.yaw + 90
                end
                if cmd.sidemove < 0 then
                    cmd.yaw = cmd.yaw + 150
                end
                if cmd.sidemove > 0 then
                    cmd.yaw = cmd.yaw + 30
                end
            end 
        end

        -- 往下爬
        if cmd.forwardmove < 0 then
            cmd.pitch = 89
            cmd.in_moveleft = 1
            cmd.in_moveright = 0
            cmd.in_forward = 1
            cmd.in_back = 0
            if cmd.sidemove == 0 then
                cmd.yaw = cmd.yaw + 90
            end
            if cmd.sidemove > 0 then
                cmd.yaw = cmd.yaw + 150
            end
            if cmd.sidemove < 0 then
                cmd.yaw = cmd.yaw + 30
            end
        end
    end
end

moonlight.slow_motion = function (cmd)
    if not menu_scripts.misc.slow_motion_ms.value then return end

    if other_menu.slow_motion.value and other_menu.slow_motion:get_hotkey() then
        local speed = menu_scripts.misc.slow_motion_speed.value
        if (cmd.in_forward == 1) then
            cmd.forwardmove = speed
        end

        if (cmd.in_back == 1) then
            cmd.forwardmove = -speed
        end

        if (cmd.in_moveleft == 1) then
            cmd.sidemove = -speed
        end

        if (cmd.in_moveright == 1) then
            cmd.sidemove = speed
        end
    end
end

moonlight.anim_breaker = function ()
    local localplayer = entity.get_local_player()
    if localplayer == nil or not entity.is_alive(localplayer) then return end

    if menu_scripts.misc.static_legs.value then
        entity.set_prop(localplayer, "m_flPoseParameter", 1, 6)
    end

    if menu_scripts.misc.legs_fucker.value then
        entity.set_prop(localplayer, "m_flPoseParameter", 1, 0)
        other_menu.legs_movement:override('Always slide')
    end

    if (menu_scripts.misc.pitch_zero.value) and (moonlight.on_ground_ticks > 3 and moonlight.on_ground_ticks < 34) and (not moonlight.respawn) then
        entity.set_prop(localplayer, "m_flPoseParameter", 0.5, 12)
    end

    if menu_scripts.misc.duck_legs.value then
        entity.set_prop(localplayer, "m_flPoseParameter", 0, 8)
    end

    if menu_scripts.misc.slow_motion_legs.value then
        entity.set_prop(localplayer, "m_flPoseParameter", 0, 9)
    end
end

moonlight.override = function ()
    gamesense.pitch[1]:override(moonlight.aa_data.pitch)
    gamesense.pitch[2]:override(moonlight.aa_data.custom_pitch)

    gamesense.yaw_base:override(moonlight.aa_data.yaw_base)

    gamesense.yaw[1]:override(moonlight.aa_data.yaw_mode)
    gamesense.yaw[2]:override(moonlight.aa_data.yaw)

    gamesense.yaw_jitter[1]:override(moonlight.aa_data.yaw_jitter_mode)
    gamesense.yaw_jitter[2]:override(moonlight.aa_data.yaw_jitter)

    gamesense.body_yaw[1]:override(moonlight.aa_data.body_yaw)
    gamesense.body_yaw[2]:override(moonlight.aa_data.body_yaw_value)
end

moonlight.crosshair = function ()
    if not menu_scripts.misc.crosshair.value then return end

    local localplayer = entity.get_local_player()
    if localplayer == nil then return end

    local screen_x, screen_y = client.screen_size()
    local text_x, text_y = surface.get_text_size(current_fonts, "MoonLight")

    color_fn.gradient_static_surface_text(screen_x/2-text_x/2, screen_y/2+9, 166, 222, 255, 255, 0, 100, 140, 255, "MoonLight", current_fonts)
    -- surface.draw_text(screen_x/2-text_x/2, screen_y/2+9, 255, 255, 255, 255, small_pixel_fonts, "MoonLight")


    local current_status = moonlight.lp_current_status
    local text_cs_x, text_cs_y = renderer.measure_text("b-", current_status)
    renderer.text(screen_x/2-text_cs_x/2, screen_y/2+9+text_y, 255,255,255,255, 'b-', 0, current_status)
end

moonlight.min_dmg = function ()
    local localplayer = entity.get_local_player()
    if not localplayer or not entity.is_alive(localplayer) or not menu_scripts.misc.min_dmg.value then return end

    local screen_x, screen_y = client.screen_size()

    local debug_x
    local side = menu_scripts.misc.min_dmg_side.value
    if side == "Left" then
        debug_x = -35
    else
        debug_x = 35
    end

    local current_min
    if other_menu.o_min_dmg[1].value and other_menu.o_min_dmg[1]:get_hotkey() then
        current_min = other_menu.o_min_dmg[2]:get()
    else
        current_min = other_menu.min_dmg:get()
    end

    renderer.text(screen_x/2+debug_x, screen_y/2-15, 255,255,255,255, "", 0, tostring(current_min))
end

moonlight.def_indicator = function ()
    if not menu_scripts.misc.def_indicator.value then
        return
    end

    if moonlight.defensive.is_enabled then
        renderer.indicator(0, 255, 0, 255, "ML DEF")
    else
        renderer.indicator(255, 0, 0, 255, "ML DEF")
    end
end

moonlight.molotov_indicator = function (ctx)
    if not menu_scripts.misc.molotov_indicator:get() then return end

    local all_molotov_ent = entity.get_all("CInferno")
    local indicator_clr = {menu_scripts.misc.molotov_indicator:get_color()}
    for i=1, #all_molotov_ent do
        local current_ent = all_molotov_ent[i]
        if entity.get_prop(current_ent, "m_fireCount") > 0 and entity.get_prop(current_ent, "m_bFireIsBurning", i) == 1  then
            local fire_cache = {}
            for fire_index=1, 64 do
                local x_delta = entity.get_prop(current_ent, "m_fireXDelta", fire_index)
                local y_delta = entity.get_prop(current_ent, "m_fireYDelta", fire_index)
                local z_delta = entity.get_prop(current_ent, "m_fireZDelta", fire_index)

                table.insert(fire_cache, {x_delta, y_delta, z_delta})
			end

            local maximum_distance = 0
            local max_1, max_2 = {}, {}
            for fire_cache_index=1, #fire_cache do
				local fire_cache_vec = fire_cache[fire_cache_index]

				for i2=1, #fire_cache do
					local fire_cache_vec2 = fire_cache[i2]
					local distance = math_fn.get_2d_distance(fire_cache_vec[1], fire_cache_vec[2], fire_cache_vec2[1], fire_cache_vec2[2])
					if distance > maximum_distance then
						maximum_distance = distance
						max_1 = fire_cache_vec
						max_2 = fire_cache_vec2
					end
				end
			end

            local fire_origin = {entity.get_prop(current_ent, "m_vecOrigin")}
            local center_x_delta, center_y_delta, center_z_delta = math_fn.lerp_position(max_1[1], max_1[2], max_1[3], max_2[1], max_2[2], max_2[3], 0.8)
			local center_x, center_y, center_z = fire_origin[1]+center_x_delta, fire_origin[2]+center_y_delta, fire_origin[3]+center_z_delta

            render_fn.circle_3d(ctx, center_x, center_y, center_z, maximum_distance/1.25, indicator_clr[1], indicator_clr[2], indicator_clr[3], indicator_clr[4], 10, 1, true)
        end
    end
end

moonlight.aspect_ratio = function ()
    if menu_scripts.misc.aspect_ratio:get() then
        local scale_value = menu_scripts.misc.aspect_ratio_value:get() / 10
        cvar.r_aspectratio:set_float(scale_value)
    else
        cvar.r_aspectratio:set_float(0)
    end
end

moonlight.viewmodel = function ()
    local settings = menu_scripts.misc.viewmodel_settings
    if menu_scripts.misc.viewmodel:get() then
        cvar.viewmodel_fov:set_raw_float(settings.fov.value)
        cvar.viewmodel_offset_x:set_raw_float(settings.x.value/10)
        cvar.viewmodel_offset_y:set_raw_float(settings.y.value/10)
        cvar.viewmodel_offset_z:set_raw_float(settings.z.value/10)
    else
        cvar.viewmodel_fov:set_raw_float(68)
        cvar.viewmodel_offset_x:set_raw_float(2.5)
        cvar.viewmodel_offset_y:set_raw_float(0)
        cvar.viewmodel_offset_z:set_raw_float(-1.5)
    end
end

moonlight.scope_overlay = function ()
    -- scope_materials
    for _, scope_material in pairs(scope_materials) do
        local current_mat = materialsystem.find_material(scope_material)
        current_mat:set_material_var_flag(2, true)
    end
end

moonlight.console_hitlogs = function ()
    if not menu_scripts.misc.console_hitlogs.value then
        moonlight.last_shot_list = {}
        moonlight.last_more_info_shot_list = {}
        return
    end

    if #moonlight.last_shot_list == 0 then return end
    
    for i=1, #moonlight.last_shot_list do
        local current_shot_list = moonlight.last_shot_list[i]
        local current_more_shot_list = moonlight.last_more_info_shot_list[tostring(current_shot_list.id)]

        if current_shot_list.shot_type == "hitted" then
            client.color_log(166, 222, 255, "[MoonLight] Target: [", entity.get_player_name(current_shot_list.target), "]  Damage: [", current_shot_list.damage, "]  HitChance: [", current_shot_list.hit_chance,"%]  Hitgroup: [", current_shot_list.hitgroup, "]  Teleported: [", tostring(current_more_shot_list.teleported):gsub("^%l", string.upper), "]  Angle: [", current_shot_list.angle, "°]")
            
        elseif current_shot_list.shot_type == "missed" then
            client.color_log(252, 86, 3, "[MoonLight] Target: [", entity.get_player_name(current_shot_list.target), "]  Reason: [", current_shot_list.reason:gsub("^%l", string.upper), "]  HitChance: [", current_shot_list.hit_chance,"%]  Hitgroup: [", current_shot_list.hitgroup, "]  Teleported: [", tostring(current_more_shot_list.teleported):gsub("^%l", string.upper), "]  Angle: [", current_shot_list.angle, "°]")
        end

        table.remove(moonlight.last_shot_list, i)
        moonlight.last_more_info_shot_list[tostring(current_shot_list.id)] = nil
    end
end


-- Aipeek ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local ap_menu_group = pui.group("LUA", "B")
local menu = {
    main_switch = ap_menu_group:checkbox("Enable \vMoonLight Ai Peek", 0x01),
    last_update = ap_menu_group:label("\vLast Updated:\r 07.07.2023", nil, false),
    version = ap_menu_group:label("\vCurrent Version: \aFFFFFFFFStable", nil, false),

    label = ap_menu_group:label(" ", nil, false),
    indicator = ap_menu_group:checkbox("Indicator", {255, 255, 255}),
    indicator_style = ap_menu_group:combobox("Indicator Style", {"Static", "Rainbow"}),
    indicator_size = ap_menu_group:slider("Indicator Size", 5, 15, 12),
    target_line = ap_menu_group:checkbox("Target Line", {255, 255, 255}),
    
    label_1 = ap_menu_group:label(" ", nil, false),
    label_2 = ap_menu_group:label("\v~ Init AI Peek", nil, false),

    distance = ap_menu_group:slider("Distance", 30, 80, 50),
    update_speed = ap_menu_group:slider("Distance Update Speed", 1, 20, 7),
    view_mode = ap_menu_group:combobox("View Modes", {"Local View", "At Target"}),
    sync_position = ap_menu_group:checkbox("Sync Position"),

    label_3 = ap_menu_group:label(" ", nil, false),
    label_4 = ap_menu_group:label("\v~ Detection Settings", nil, false),
    
    hitboxes = ap_menu_group:multiselect("Hitboxes", {'Head', 'Chest', 'Stomach', 'Arms', 'Legs', 'Feet'}),
    prefer_detect = ap_menu_group:combobox("Prefer Detect", {"The Highest DMG", "The Lowest DMG"}),
    -- max_detect_backtrack = ap_menu_group:slider("Max Backtrack Ticks (Kill FPS Warning)", 0, 32, 16),
    delay_confirm = ap_menu_group:slider("Confirm Ticks To Run", 0, 64, 3),
    -- disable_da_bt = ap_menu_group:checkbox("Disable Detect Dormant Backtrack"),
    reset_peek = ap_menu_group:combobox("Reset Peek Hotkey After Close", {"On hotkey", "Toggle"}),

    label_5 = ap_menu_group:label(" ", nil, false),
    label_6 = ap_menu_group:label("\v~ Exploits Settings", nil, false),

    teleport = ap_menu_group:checkbox("Auto Teleport"),
    tp_modes = ap_menu_group:combobox("Teleport Modes", {"Time", "Distance", "Enemy Lethal"}),
    delay_time = ap_menu_group:slider("Delay Time", 0, 50, 10, true, "s", 0.01),
    distance_debug = ap_menu_group:slider("Distance Debug", 0, 100, 50, true, "", 0.01),
    delay_charge = ap_menu_group:slider("Delay Charge Ticks", 0, 32, 18),

    label_7 = ap_menu_group:label(" ", nil, false),
    label_8 = ap_menu_group:label("\v~ Debugs Settings", nil, false),

    debug_damage = ap_menu_group:slider("Dormant Target Debug Damage", 0, 5, 3, true, "%"),

    label_9 = ap_menu_group:label(" ", nil, false),
    label_10 = ap_menu_group:label("\v~ Configs Settings", nil, false),
    export = ap_menu_group:button("Export Configs", function() end, nil, false),
    import = ap_menu_group:button("Import Configs", function() end, nil, false),
    default = ap_menu_group:button("Default Configs", function() end, nil, false)
}

local menu_setup_2 = pui.setup(menu)
menu.export:set_callback(function ()
    local config = menu_setup_2:save()
    local encrypted = base64.encode(json.stringify(config))

    ffi_helpers.set_clipboard_text(encrypted)
end)

menu.import:set_callback(function ()
    local configs = ffi_helpers.get_clipboard_text()
    local ds_configs = json.parse(base64.decode(configs))

    menu_setup_2:load(ds_configs)
end)

menu.default:set_callback(function ()
    local configs = "eyJkZWxheV9jaGFyZ2UiOjI1LCJpbmRpY2F0b3IiOnRydWUsInN5bmNfcG9zaXRpb24iOmZhbHNlLCJkaXN0YW5jZV9kZWJ1ZyI6MjMsInRwX21vZGVzIjoiRW5lbXkgTGV0aGFsIiwidmlld19tb2RlIjoiTG9jYWwgVmlldyIsInJlc2V0X3BlZWsiOiJPbiBob3RrZXkiLCJ0YXJnZXRfbGluZV9jIjoiI0ZGRkZGRkZGIiwidXBkYXRlX3NwZWVkIjo3LCJkaXN0YW5jZSI6NzQsInRlbGVwb3J0Ijp0cnVlLCJkZWxheV9jb25maXJtIjozLCJwcmVmZXJfZGV0ZWN0IjoiVGhlIEhpZ2hlc3QgRE1HIiwiaW5kaWNhdG9yX3N0eWxlIjoiUmFpbmJvdyIsIm1haW5fc3dpdGNoX2giOlsxLDUsIn4iXSwiZGVidWdfZGFtYWdlIjo0LCJtYXhfZGV0ZWN0X2JhY2t0cmFjayI6NCwiaW5kaWNhdG9yX2MiOiIjRkZGRkZGRkYiLCJoaXRib3hlcyI6WyJIZWFkIiwifiJdLCJtYWluX3N3aXRjaCI6dHJ1ZSwidGFyZ2V0X2xpbmUiOnRydWUsImRlbGF5X3RpbWUiOjI2LCJpbmRpY2F0b3Jfc2l6ZSI6MTJ9"
    local ds_configs = json.parse(base64.decode(configs))

    menu_setup_2:load(ds_configs)
end)

local ap_menu_visi = function ()
    local main_switch = {menu.main_switch, true}
    for key, value in pairs(menu) do
        if not (value:get_name() == menu.main_switch:get_name()) then
            value:depend(main_switch)
        end
    end

    menu.indicator_size:depend({menu.indicator, true})
    menu.indicator_style:depend({menu.indicator, true})
    menu.indicator.color:depend({menu.indicator, true}, {menu.indicator_style, "Static"})

    local tp_ms = {menu.teleport, true}
    menu.tp_modes:depend(tp_ms)
    menu.delay_time:depend(tp_ms, {menu.tp_modes, "Time"})
    menu.distance_debug:depend(tp_ms, {menu.tp_modes, "Distance", "Enemy Lethal"})
    menu.delay_charge:depend(tp_ms)
end
ap_menu_visi()

local aipeek = {
    start_pos = {},
    previews_start = {},

    is_detected = false,
    detect_pos = {},
    point_list = {},
    current_point = {},
    current_distance = 1,

    cache_ent = nil,
    hitbox_index = nil,

    last_tp = globals.tickcount(),
    old_time = globals.curtime(),
    teleported = false,

    can_shoot = false,
    confirm_ticks = globals.tickcount(),
}

aipeek.start_point = function ()
    if not menu.main_switch:get_hotkey() then return end

    local localplayer = entity.get_local_player()
    if localplayer == nil or not entity.is_alive(localplayer) then return end
    
    if menu.sync_position.value and (not aipeek.is_detected) then
        aipeek.start_pos = {entity.get_origin(localplayer)}
    else
        aipeek.start_pos = aipeek.previews_start
    end
end

aipeek.skip_trace = function (entindex, contents_mask)
    if entity.get_classname(entindex) == "CCSPlayer" and (entindex == entity.get_local_player()) then
        return true
    elseif entity.get_classname(entindex) == "CCSPlayer" and (not entity.is_enemy(entindex)) then
        return true
    else
        return false
    end
end

aipeek.scale_dmg = function (target, damage, armor_ratio, hitbox)
    local has_armor = false
    local found_hitbox = false

    local cache_damage = damage
    local armor_value = entity.get_prop(target, 'm_ArmorValue')

    if armor_value ~= nil and armor_value > 0 then
        has_armor = true
    elseif (hitbox == 0) and (entity.get_prop(target, 'm_bHasHelmet') == 1) then
        has_armor = true
    end

    for hitbox_name, hitbox_list in pairs(hitboxes) do
        for _, hitbox_index in pairs(hitbox_list) do
            if hitbox == hitbox_index then
                found_hitbox = true
                break
            end
        end

        if found_hitbox then
            if (hitbox_name == "head") then
                cache_damage = cache_damage * 4
                break
            elseif (hitbox_name == "stomach") then
                cache_damage = cache_damage * 1.25
                break
            elseif (hitbox_name == "legs") then
                cache_damage = cache_damage * 0.75
                break
            else
                cache_damage = cache_damage
                break
            end
        end
    end

    if has_armor then
        local armorscaled = (armor_ratio * 0.5) * cache_damage
        if ((cache_damage - armorscaled) * 0.5 > armor_value) then
            armorscaled = cache_damage - (armor_value * 2.0)
        end

        cache_damage = armorscaled
    end

    return math.floor(cache_damage)
end

aipeek.new_trace = function (start_x, start_y, start_z, hitbox)
    local localplayer = entity.get_local_player()
    if (localplayer == nil) or (not entity.is_alive(localplayer)) then return end

    local lp_weapon = entity.get_player_weapon(localplayer)
    if (lp_weapon == nil) then return end

    local weapon_info = csgo_weapons(lp_weapon)
    if (weapon_info == nil) then return end

    local target = client.current_threat()
    if (target == nil) or (not entity.is_alive(target)) then return end

    local hitbox_pos = {entity.hitbox_position(target, hitbox)}
    local start_pos = vector(start_x, start_y, start_z)

    local after_hitbox_pos = math_fn.extrapolate(target, hitbox_pos, 3)
    if after_hitbox_pos == nil then
        after_hitbox_pos = hitbox_pos
    end

    if aipeek.is_detected then
        target = aipeek.cache_ent
    end

    local new_tracer = trace.line(start_pos, vector(after_hitbox_pos[1], after_hitbox_pos[2], after_hitbox_pos[3]), {skip=aipeek.skip_trace, mask=0x4600400B, type="TRACE_EVERYTHING"})

    local damage = weapon_info.damage
    local distance_to_target = start_pos:dist(new_tracer.end_pos)
    local after_damage = (damage * math.pow(weapon_info.range_modifier, (distance_to_target * 0.002)))

    local surface_props_data = native_GetSurfaceData(new_tracer.surface.props)
    local surface_flpenetration_modifier = surface_props_data.game.penetrationmodifier
    local surface_damagemodifier = surface_props_data.game.damagemodifier

    if (surface_flpenetration_modifier < 0.1) or (surface_damagemodifier < 0.1) then return target, 0 end

    if (new_tracer.entindex ~= nil) and (entity.is_enemy(new_tracer.entindex)) and (new_tracer.hitgroup ~= 0) then
        local player_damage = aipeek.scale_dmg(target, after_damage, weapon_info.armor_ratio, hitbox)
        return new_tracer.entindex, player_damage
    end

    local ent, bullet_dmg = client.trace_bullet(localplayer, start_x, start_y, start_z, after_hitbox_pos[1], after_hitbox_pos[2], after_hitbox_pos[3], true)
    return ent, bullet_dmg
end

aipeek.get_current_clr = function ()
    if menu.indicator_style.value == "Rainbow" then
        local r, g, b, a = 255,255,255,255

        local rgb_split_ratio = 1
        local h = globals.realtime() * (0.3)

        r, g, b = color_fn.hsvToRgb(h, 1, 1, 1)
        r, g, b = r * rgb_split_ratio, g * rgb_split_ratio, b * rgb_split_ratio

        return {r, g, b, a}
    else
        return {menu.indicator:get_color()}
    end
end

aipeek.beams_setup = function (start_pos, end_pos, clr)
    local beamInfo = ffi.new("beams_t")
    beamInfo.m_vecStart = {start_pos.x, start_pos.y, start_pos.z}
    beamInfo.m_vecEnd = {end_pos.x, end_pos.y, end_pos.z}
    beamInfo.m_nSegments = 2
    beamInfo.m_nType = 0x00
    beamInfo.m_bRenderable = true
    beamInfo.m_nFlags = bit.bor(0x00000100 + 0x00000008 + 0x00000200 + 0x00008000)
    beamInfo.m_pszModelName = "sprites/purplelaser1.vmt"
    beamInfo.m_nModelIndex = -1
    beamInfo.m_flHaloScale = 0
    beamInfo.m_nStartAttachment = 0
    beamInfo.m_nEndAttachment = 0
    beamInfo.m_flLife = 0.025
    beamInfo.m_flWidth = 1
    beamInfo.m_flEndWidth = 4
    beamInfo.m_flFadeLength = 2
    beamInfo.m_flAmplitude = 0
    beamInfo.m_flSpeed = 0
    beamInfo.m_flFrameRate = 0
    beamInfo.m_nHaloIndex = 0
    beamInfo.m_nStartFrame = 0
    beamInfo.m_flRed = clr[1]
    beamInfo.m_flGreen = clr[2]
    beamInfo.m_flBlue = clr[3]
    beamInfo.m_flBrightness = clr[4]
    local beam = create_beam_points(g_pViewRenderBeams, beamInfo)
    if beam ~= nil then
        draw_beams(render_beams, beam)
    end
end

aipeek.render_indicator = function(torigin, w, h, clr)
    local origin = vector(torigin[1], torigin[2], torigin[3])

    local top_left = vector(origin.x - w / 2, origin.y - h / 2, origin.z)
    local top_right = vector(origin.x + w / 2, origin.y - h / 2, origin.z)
    local bottom_left = vector(origin.x - w / 2, origin.y + h / 2, origin.z)
    local bottom_right = vector(origin.x + w / 2, origin.y + h / 2, origin.z)

    local top = vector(origin.x, origin.y-h*2, origin.z)
    local left = vector(origin.x-w*2, origin.y, origin.z)
    local right = vector(origin.x+w*2, origin.y, origin.z)
    local bottom = vector(origin.x, origin.y+h*2, origin.z)

    aipeek.beams_setup(top_left, top_right, clr)
    aipeek.beams_setup(top_right, bottom_right, clr)
    aipeek.beams_setup(bottom_right, bottom_left, clr)
    aipeek.beams_setup(bottom_left, top_left, clr)
    aipeek.beams_setup(top, left, clr)
    aipeek.beams_setup(left, bottom, clr)
    aipeek.beams_setup(bottom, right, clr)
    aipeek.beams_setup(right, top, clr)
end

aipeek.predict_point = function ()
    if not menu.main_switch:get_hotkey() then return end

    local localplayer = entity.get_local_player()
    if localplayer == nil or not entity.is_alive(localplayer) then return end

    local eye_x, eye_y, eye_z = client.eye_position()
    local origin_x, origin_y, origin_z = entity.get_origin(localplayer)
    local player_height = eye_z-origin_z

    local current_start = aipeek.start_pos
    local vec_current_start = vector(current_start[1], current_start[2], current_start[3])
    local view_pitch, view_yaw = client.camera_angles()

    local result_yaw
    local views_modes = menu.view_mode.value
    if views_modes == "Local View" then
        result_yaw = view_yaw
    else
        local target
        if aipeek.cache_ent ~= nil then
            target = aipeek.cache_ent
        else
            target = client.current_threat()
        end

        if target == nil then
            result_yaw = view_yaw
        else
            local target_origin = {entity.get_origin(target)}
            local target_vec = vector(target_origin[1], target_origin[2], target_origin[3])
            local cal_pitch, cal_yaw = vec_current_start:to(target_vec):angles()
            result_yaw = cal_yaw
        end
    end

    local end_pos = {}
    for angles_yaw=0, 180, 180 do
        local lp_neck = {entity.hitbox_position(localplayer, 1)}
        vec_current_start.z = lp_neck[3]

        local max_height = vec_current_start.z - origin_z
        local distance_end = vec_current_start + vector(0,0,0):init_from_angles(0, (90 + result_yaw + angles_yaw)) * menu.distance.value
        local trace_end = trace.line(vec_current_start, distance_end, {skip=aipeek.skip_trace, mask=0x201400B})
        if trace_end.fraction ~= 1 then
            distance_end = vec_current_start + vector(0,0,0):init_from_angles(0, (90 + result_yaw + angles_yaw)) * (menu.distance.value * (trace_end.fraction * 0.9))
            trace_end = trace.line(vec_current_start, distance_end, {skip=aipeek.skip_trace, mask=0x201400B})
        end

        local trace_end_vec = trace_end.end_pos
        local trace_end_2 = trace.line(trace_end_vec, vector(trace_end_vec.x, trace_end_vec.y, -10000), {skip=aipeek.skip_trace, mask=0x4004003})
        local trace_end_vec_2 = trace_end_2.end_pos

        if math.abs(origin_z - trace_end_vec_2.z) > max_height then
            local result_vec
            for i=1, menu.distance.value do
                local debug_radius = vec_current_start + vector(0,0,0):init_from_angles(0, (90 + result_yaw + angles_yaw)) * i
                local debug_trace = trace.line(vec_current_start, debug_radius, {skip=aipeek.skip_trace, mask=0x201400B})
                
                local d_trace_end = debug_trace.end_pos
                local debug_trace_2 = trace.line(d_trace_end, vector(d_trace_end.x, d_trace_end.y, -10000), {skip=aipeek.skip_trace, mask=0x4004003})

                if math.abs(origin_z - debug_trace_2.end_pos.z) > max_height then
                    break
                else
                    result_vec = {debug_trace_2.end_pos.x, debug_trace_2.end_pos.y, debug_trace_2.end_pos.z + 5}
                end
            end

            if result_vec then
                trace_end_vec_2 = result_vec
            else
                local current_result = vec_current_start + vector(0,0,0):init_from_angles(0, (90 + view_yaw + angles_yaw)) * 1
                trace_end_vec_2 = {current_result.x, current_result.y, origin_z + 5}
            end
        end

        if type(trace_end_vec_2) == "table" then
            end_pos[tostring(angles_yaw)] = {end_pos=trace_end_vec_2, detected=false}
        else
            end_pos[tostring(angles_yaw)] = {end_pos={trace_end_vec_2.x, trace_end_vec_2.y, trace_end_vec_2.z}, detected=false}
        end
    end

    aipeek.point_list = end_pos
    
    if menu.indicator.value then
        local size = menu.indicator_size.value
        local current_clr = aipeek.get_current_clr()
        local left_end = aipeek.point_list["0"].end_pos
        local right_end = aipeek.point_list["180"].end_pos

        if aipeek.is_detected then
            local detect_pos = aipeek.detect_pos
            local debug_pos = vector(detect_pos[1], detect_pos[2], detect_pos[3])
            debug_pos.z = debug_pos.z - player_height + 10

            local left_dist = debug_pos:dist(vector(left_end[1], left_end[2], left_end[3]))
            local right_dist = debug_pos:dist(vector(right_end[1], right_end[2], right_end[3]))

            if right_dist > left_dist then
                aipeek.render_indicator(left_end, size, size, {0,255,0,255})
            end

            if left_dist > right_dist then
                aipeek.render_indicator(right_end, size, size, {0,255,0,255})
            end
        else
            aipeek.render_indicator(left_end, size, size, current_clr)
            aipeek.render_indicator(right_end, size, size, current_clr)
        end
    end
end

aipeek.get_hitbox = function ()
    local selected_hitbox = {}
    for key, value in pairs(menu.hitboxes.value) do
        for _, hitbox in pairs(hitboxes[value:lower()]) do
            table.insert(selected_hitbox, hitbox)
        end
    end

    return selected_hitbox
end

aipeek.dynamic_predict = function ()
    if aipeek.point_list["0"] == nil or aipeek.point_list["180"] == nil then return end

    local start_pos = aipeek.start_pos
    local vec_start_pos = vector(start_pos[1], start_pos[2], start_pos[3])

    local localplayer = entity.get_local_player()
    local eye_x, eye_y, eye_z = client.eye_position()
    local origin_x, origin_y, origin_z = entity.get_origin(localplayer)
    local player_height = eye_z-origin_z

    local left_end_tb = aipeek.point_list["0"].end_pos
    local right_end_tb = aipeek.point_list["180"].end_pos
    
    local left_end = vector(left_end_tb[1], left_end_tb[2], left_end_tb[3])
    local right_end = vector(right_end_tb[1], right_end_tb[2], right_end_tb[3])

    local left_pitch, left_yaw = vec_start_pos:to(left_end):angles()
    local right_pitch, right_yaw = vec_start_pos:to(right_end):angles()
    local angles_vec_l = math_fn.angle_to_vector(0, left_yaw)
    local angles_vec_r = math_fn.angle_to_vector(0, right_yaw)
    local current_distance = aipeek.current_distance

    local result_left = vector(vec_start_pos.x+angles_vec_l[1]*current_distance, vec_start_pos.y+angles_vec_l[2]*current_distance, vec_start_pos.z+player_height)
    local result_right = vector(vec_start_pos.x+angles_vec_r[1]*current_distance, vec_start_pos.y+angles_vec_r[2]*current_distance, vec_start_pos.z+player_height)

    local max_distance = {left=vec_start_pos:dist(left_end), right=vec_start_pos:dist(right_end)}
    local max_result_distance = {left=vec_start_pos:dist(result_left), right=vec_start_pos:dist(result_right)}

    aipeek.current_point["left"] = {result_left.x, result_left.y, result_left.z}
    aipeek.current_point["right"] = {result_right.x, result_right.y, result_right.z}

    if max_result_distance.left >= max_distance.left then
        aipeek.current_point["left"] = {left_end.x, left_end.y, left_end.z+player_height}
    end

    if max_result_distance.right >= max_distance.right then
        aipeek.current_point["right"] = {right_end.x, right_end.y, right_end.z+player_height}
    end
end

aipeek.main_function = function ()
    if not menu.main_switch:get_hotkey() then return end

    local localplayer = entity.get_local_player()
    if localplayer == nil or not entity.is_alive(localplayer) then return end

    local weapon_ent = entity.get_player_weapon(localplayer)
	if weapon_ent == nil then return end

	local weapon = csgo_weapons(weapon_ent)
	if weapon == nil then return end

    local target = client.current_threat()
    if aipeek.is_detected then
        if (aipeek.cache_ent == nil) or (not entity.is_alive(aipeek.cache_ent)) then
            aipeek.reset_normal_data()
            return
        end
    end

    if target == nil or not entity.is_alive(target) then
        aipeek.reset_normal_data()
        return
    end

    local damage_check = {}
    local hitbox_table = aipeek.get_hitbox()
 
    local min_dmg = (other_menu.o_min_dmg[1]:get() and other_menu.o_min_dmg[1]:get_hotkey()) and other_menu.o_min_dmg[2]:get() or other_menu.min_dmg:get()

    if not aipeek.is_detected then
        aipeek.dynamic_predict()
    end

    for _, hitbox_index in pairs(hitbox_table) do
        -- local target_x, target_y, target_z = entity.hitbox_position(target, hitbox_index)

        if entity.is_dormant(target) then
            for _, current_point in pairs(aipeek.current_point) do
                -- local ent, scale_dmg = client.trace_bullet(localplayer, current_point[1], current_point[2], current_point[3], target_x, target_y, target_z)
                local ent, damage = aipeek.new_trace(current_point[1], current_point[2], current_point[3], hitbox_index)

                if damage <= 0 then goto skip end

                local target_health = entity.get_prop(target, "m_iHealth")

                local debug_dmg = (weapon.damage * (menu.debug_damage.value / 100)) * (hitbox_index~=0 and weapon.armor_ratio or weapon.headshot_multiplier)
                if (damage+debug_dmg >= math.min(min_dmg, target_health)) then
                    table.insert(damage_check, {target=ent, damage=damage, hitbox_index=hitbox_index, detected_pos=current_point, angles=_})
                end

                ::skip::
            end
        else
            for _, current_point in pairs(aipeek.current_point) do
                -- local ent, damage = client.trace_bullet(localplayer, current_point[1], current_point[2], current_point[3], extra_target[1], extra_target[2], extra_target[3])

                local ent, damage = aipeek.new_trace(current_point[1], current_point[2], current_point[3], hitbox_index)
                if damage <= 0 then goto skip end

                local target_health = entity.get_prop(target, "m_iHealth")

                local debug_dmg = 0
                if entity.is_dormant(target) then
                    debug_dmg = (weapon.damage * (menu.debug_damage.value / 100)) * (hitbox_index~=0 and weapon.armor_ratio or weapon.headshot_multiplier)
                end

                if (damage+debug_dmg >= math.min(min_dmg, target_health)) then
                    table.insert(damage_check, {target=ent, damage=damage, hitbox_index=hitbox_index, detected_pos=current_point, angles=_})
                end

                ::skip::
            end
        end
    end

    table.sort(damage_check, function(a, b)
        if menu.prefer_detect.value == 'The Highest DMG' then
            return a.damage > b.damage
        else
            return a.damage < b.damage
        end
    end)

    if (damage_check[1] ~= nil) and (damage_check[1].damage ~= 0) and (aipeek.can_shoot) then
        if aipeek.is_detected then
            if aipeek.cache_ent == nil or (not entity.is_alive(aipeek.cache_ent)) then
                aipeek.run_data()
                goto skip
            end

            if (damage_check[1] == nil) or (damage_check[1].damage == 0) then
                aipeek.run_data()
            end

            ::skip::
        else
            if target ~= nil or entity.get_prop(target, "m_iHealth") > 0 then
                aipeek.is_detected = true
                aipeek.detect_dmg = damage_check[1].damage
                aipeek.detect_pos = damage_check[1].detected_pos
                aipeek.cache_ent = damage_check[1].target
                aipeek.hitbox_index = damage_check[1].hitbox_index
                aipeek.confirm_ticks = globals.tickcount() + menu.delay_confirm.value
            else
                aipeek.run_data()
            end
        end
    else
        aipeek.run_data()
    end

    if aipeek.current_distance > menu.distance.value then
        aipeek.current_distance = 1
    else
        aipeek.current_distance = aipeek.current_distance + menu.update_speed.value
    end
end

aipeek.peek_function = function (cmd)
    if not menu.main_switch:get_hotkey() then return end
    if not aipeek.is_detected then return end

    local target = client.current_threat()
    if aipeek.is_detected then
        if (aipeek.cache_ent == nil) or (not entity.is_alive(aipeek.cache_ent)) then
            aipeek.reset_normal_data()
            return
        end
    end

    if target == nil or not entity.is_alive(target) then
        aipeek.reset_normal_data()
        return
    end

    local localplayer = entity.get_local_player()
    if localplayer == nil or not entity.is_alive(localplayer) then return end

    local weapon_ent = entity.get_player_weapon(localplayer)
	if weapon_ent == nil then return end

	local weapon = csgo_weapons(weapon_ent)
	if weapon == nil then return end

    if not (globals.tickcount() > aipeek.confirm_ticks) then
        return
    end

    local origin_x, origin_y, origin_z = entity.get_origin(localplayer)
    local current_pos = vector(origin_x, origin_y, origin_z)

    cmd.in_forward = 1
    cmd.in_back = 0
    cmd.in_moveleft = 0
    cmd.in_moveright = 0
    cmd.in_speed = 0
    cmd.forwardmove = 450
    cmd.sidemove = 0

    local start_pos = aipeek.start_pos
    local vec_start_pos = vector(start_pos[1], start_pos[2], start_pos[3])

    local detected_pos = aipeek.detect_pos
    local detect_pos = vector(detected_pos[1], detected_pos[2], detected_pos[3])

    local move_target_pitch, move_target_yaw = vec_start_pos:to(detect_pos):angles()
    local check_distance = current_pos:dist(vec_start_pos)
    local check_debug_distance = vec_start_pos:dist(detect_pos)

    if check_distance > check_debug_distance+8 then
        cmd.in_forward = 0
        cmd.forwardmove = 0
    else
        cmd.move_yaw = move_target_yaw

        if menu.teleport.value and (other_menu.double_tap[1]:get_original()) and (globals.tickcount() > aipeek.last_tp) then

            local tp_modes = menu.tp_modes.value
            local target_health = entity.get_prop(target, "m_iHealth")
            if target_health == nil then
                aipeek.reset_normal_data()
                return
            end

            if tp_modes == 'Time' and (globals.curtime() >= aipeek.old_time) then
                other_menu.double_tap[1]:override(false)
                aipeek.last_tp = globals.tickcount() + menu.delay_charge.value
                aipeek.teleported = true
                
            elseif tp_modes == 'Distance' and (current_pos:dist(vec_start_pos) > check_debug_distance*(menu.distance_debug.value/100)) and (check_debug_distance > 15) then
                other_menu.double_tap[1]:override(false)
                aipeek.last_tp = globals.tickcount() + menu.delay_charge.value
                aipeek.teleported = true

            elseif tp_modes == 'Enemy Lethal' and (aipeek.detect_dmg >= target_health and weapon.damage >= target_health) and (current_pos:dist(vec_start_pos) > check_debug_distance*(menu.distance_debug.value/100)) then
                other_menu.double_tap[1]:override(false)
                aipeek.last_tp = globals.tickcount() + menu.delay_charge.value
                aipeek.teleported = true
            end
        end
    end
end

aipeek.run_data = function ()
    aipeek.is_detected = false
    aipeek.detect_dmg = nil
    aipeek.detect_pos = nil
    aipeek.cache_ent = nil
    aipeek.is_lether = false
    aipeek.hitboxes = nil
    aipeek.confirm_ticks = globals.tickcount()
end

aipeek.reset_normal_data = function ()
    aipeek.is_detected = false
    aipeek.detect_dmg = nil
    aipeek.detect_pos = nil
    aipeek.current_point = {}
    aipeek.cache_ent = nil
    aipeek.is_lether = false
    aipeek.hitboxes = nil
    aipeek.confirm_ticks = globals.tickcount()
end

aipeek.reset_data = function ()
    aipeek.is_detected = false
    aipeek.detect_dmg = nil
    aipeek.detect_pos = nil
    aipeek.start_pos = aipeek.previews_start
    aipeek.old_time = globals.curtime() + menu.delay_time.value/100
    aipeek.cache_ent = nil
    aipeek.is_lether = false
    aipeek.current_point = {}
    aipeek.hitboxes = nil
    aipeek.confirm_ticks = globals.tickcount()
    aipeek.last_tp = globals.tickcount()
end

aipeek.check_fire = function ()
    local localplayer = entity.get_local_player()
    if localplayer == nil or not entity.is_alive(localplayer) then return end

    local weapon_status = entity.get_player_weapon(localplayer)
    if weapon_status == nil then return end

    local timer = globals.curtime()
    local can_Fire = (entity.get_prop(localplayer, "m_flNextAttack") <= timer and entity.get_prop(weapon_status, "m_flNextPrimaryAttack") <= timer)

    aipeek.can_shoot = can_Fire
end

aipeek.check_peek = function ()
    if not menu.main_switch:get_hotkey() then
        other_menu.peek_assist:override()
        other_menu.peek_assist.hotkey:set(menu.reset_peek.value)
        return
    end

    other_menu.peek_assist:override(true)
    other_menu.peek_assist.hotkey:set("Always on")

    if aipeek.is_detected then
        other_menu.peek_assist_mode:override({"Retreat on shot"})
    else
        other_menu.peek_assist_mode:override({"Retreat on shot", "Retreat on key release"})
    end
end

aipeek.target_line = function ()
    if not menu.target_line.value then return end
    if not menu.main_switch:get_hotkey() then return end

    local localplayer = entity.get_local_player()
    if localplayer == nil or not entity.is_alive(localplayer) then return end

    local target = client.current_threat()
    if target == nil or not entity.is_alive(target) then return end

    local target_position = {entity.get_origin(target)}
    local current_position = {entity.get_origin(localplayer)}
    local screen_size = {client.screen_size()}

    local line_color = {menu.target_line:get_color()}

    if target_position[1] == nil then return end

    local tpts_x, tpts_y = renderer.world_to_screen(target_position[1], target_position[2], target_position[3])
    local cpts_x, cpts_y = renderer.world_to_screen(current_position[1], current_position[2], current_position[3])
    if tpts_x == nil or tpts_y == nil then return end
    if cpts_x == nil or cpts_y == nil then
        renderer.line(screen_size[1]/2, screen_size[2], tpts_x, tpts_y, line_color[1], line_color[2], line_color[3], line_color[4])
    else
        renderer.line(cpts_x, cpts_y, tpts_x, tpts_y, line_color[1], line_color[2], line_color[3], line_color[4])
    end
end



-- Ragebot Improvement ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local wp_menu_group = pui.group("LUA", "A")
local wp_builder_extend = function ()
    local result_builder = {}
    for i=1, #weapon_list do
        local cache_menu = {}
        local current_weapons = weapon_list[i]

        if current_weapons ~= "Globals" then
            cache_menu.main_switch = wp_menu_group:checkbox(string.format("Enable \v%s\r settings", current_weapons))
            cache_menu.main_switch_label = wp_menu_group:label(" ")
        end
        
        cache_menu.label_2 = wp_menu_group:label("\v~ Init selection settings", nil, false)
        cache_menu.target = wp_menu_group:combobox(string.format("\v[%s]\r Target selection", current_weapons), target_selection)
        cache_menu.hitbox = wp_menu_group:multiselect(string.format("\v[%s]\r Hitboxes", current_weapons), target_hitboxes)
        cache_menu.unsafe_hitbox = wp_menu_group:multiselect(string.format("\v[%s]\r Avoid unsage hitboxes", current_weapons), target_hitboxes)
        cache_menu.mp_hitbox = wp_menu_group:multiselect(string.format("\v[%s]\r Multi-point hitboxes", current_weapons), target_hitboxes)
        cache_menu.dtms_mp_hitbox = wp_menu_group:checkbox(string.format("\v[%s]\r Double tap multi-point hitboxes", current_weapons))
        cache_menu.dt_mp_hitbox = wp_menu_group:multiselect(string.format("\n\v[%s]\r Double tap multi-point hitboxes", current_weapons), target_hitboxes)

        cache_menu.label_next1 = wp_menu_group:label(" ", nil, false)
        cache_menu.label_value = wp_menu_group:label("\v~ Init value settings", nil, false)
        cache_menu.mutli_point = wp_menu_group:slider(string.format("\v[%s]\r Multi-point scale", current_weapons), 24, 100, 50, true, "%", 1, multipoint_tooltips)
        cache_menu.dtms_mutli_point = wp_menu_group:checkbox(string.format("\v[%s]\r Double tap Multi-point scale", current_weapons))
        cache_menu.dt_mutli_point = wp_menu_group:slider(string.format("\n\v[%s]\r Multi-point scale", current_weapons), 24, 100, 50, true, "%", 1, multipoint_tooltips)
        cache_menu.hitchance = wp_menu_group:slider(string.format("\v[%s]\r Hitchance", current_weapons), 0, 100, 50, true, "%", 1, hitchance_tooltips)
        cache_menu.dt_hitchance = wp_menu_group:slider(string.format("\v[%s]\r Double tap Hitchance", current_weapons), 0, 100, 50, true, "%", 1, hitchance_tooltips)
        cache_menu.min_damage = wp_menu_group:slider(string.format("\v[%s]\r Min damage", current_weapons), 0, 126, 50, true, "", 1, damage_tooltips)

        -- Do not use ms_hitchance, idk why LOL
        if current_weapons == "Scout" then
            cache_menu.label_7 = wp_menu_group:label(" ", nil, false)
            cache_menu.label_8 = wp_menu_group:label("\v~ Scout hitchance settings", nil, false)
            cache_menu.ms_hitchane = wp_menu_group:checkbox(string.format("\v[%s]\r Enable scout custom hitchance", current_weapons), false)
            cache_menu.in_air_hc = wp_menu_group:slider(string.format("\v[%s]\r In air hitchance", current_weapons), 0, 100, 50, true, "%", 1, hitchance_tooltips)
            cache_menu.no_scope_hc = wp_menu_group:slider(string.format("\v[%s]\r No scope hitchance", current_weapons), 0, 100, 50, true, "%", 1, hitchance_tooltips)
        end

        if current_weapons == "AutoSniper" then
            cache_menu.label_7 = wp_menu_group:label(" ", nil, false)
            cache_menu.label_8 = wp_menu_group:label("\v~ Autosniper hitchance settings", nil, false)
            cache_menu.ms_hitchane = wp_menu_group:checkbox(string.format("\v[%s]\r Enable autosniper custom hitchance", current_weapons), false)
            cache_menu.no_scope_hc = wp_menu_group:slider(string.format("\v[%s]\r No scope hitchance", current_weapons), 0, 100, 50, true, "%", 1, hitchance_tooltips)
        end

        cache_menu.label_3 = wp_menu_group:label(" ", nil, false)
        cache_menu.label_4 = wp_menu_group:label("\v~ Quick stop settings", nil, false)
        cache_menu.quick_stop = wp_menu_group:multiselect(string.format("\v[%s]\r Quick stop", current_weapons), normal_quick_stop)
        cache_menu.ms_dt_quick_stop = wp_menu_group:checkbox(string.format("\v[%s]\r Double tap normal quick stop", current_weapons))
        cache_menu.dt_quick_stop = wp_menu_group:multiselect(string.format("\n\v[%s]\r Double tap normal quick stop", current_weapons), normal_quick_stop)
        if current_weapons == "Scout" or current_weapons == "AutoSniper" or current_weapons == "AWP" then
            cache_menu.ms_no_scope_quick_stop = wp_menu_group:checkbox(string.format("\v[%s]\r No scope quick stop", current_weapons))
            cache_menu.no_scope_quick_stop = wp_menu_group:multiselect(string.format("\n\v[%s]\r No scope quick stop", current_weapons), normal_quick_stop)
        end

        cache_menu.dt2_quick_stop = wp_menu_group:multiselect(string.format("\v[%s]\r Double tap quick stop", current_weapons), dt_quick_stop)

        cache_menu.label_9 = wp_menu_group:label(" ", nil, false)
        cache_menu.label_10 = wp_menu_group:label("\v~ Safety settings", nil, false)
        cache_menu.prefer_sp = wp_menu_group:checkbox(string.format("\v[%s]\r Prefer safe point", current_weapons), false)
        cache_menu.prefer_ba = wp_menu_group:checkbox(string.format("\v[%s]\r Prefer body aim", current_weapons), false)
        cache_menu.prefer_ba_dis = wp_menu_group:multiselect(string.format("\n\v[%s]\r Prefer body aim", current_weapons), prefer_body_aim_disablers)
        cache_menu.force_baim_peek = wp_menu_group:checkbox(string.format("\v[%s]\r Force body aim on peek", current_weapons), false)

        cache_menu.label_5 = wp_menu_group:label(" ", nil, false)
        cache_menu.label_6 = wp_menu_group:label("\v~ Other settings", nil, false)
        cache_menu.delay_shot = wp_menu_group:checkbox(string.format("\v[%s]\r Delay shot", current_weapons), false)
        cache_menu.auto_scope = wp_menu_group:checkbox(string.format("\v[%s]\r Automatic scope", current_weapons), false)
        cache_menu.accuracy_boost = wp_menu_group:combobox(string.format("\v[%s]\r Accuracy boost", current_weapons), accuracy_boost)
        cache_menu.low_fps = wp_menu_group:multiselect(string.format("\v[%s]\r Low FPS mitigations", current_weapons), low_fps)

        result_builder[current_weapons] = cache_menu
    end

    return result_builder
end

local override_builder_extend = function ()
    local result_builder = {}
    for i=1, #weapon_list do
        local cache_menu = {}
        local current_weapons = weapon_list[i]

        cache_menu.label_next1 = wp_menu_group:label(" ", nil, false)
        cache_menu.label_value = wp_menu_group:label("\v~ Override init settings", nil, false)

        cache_menu.ms_o_hitbox = wp_menu_group:checkbox(string.format("\v[%s]\r Override hitboxes", current_weapons))
        cache_menu.o_hitbox = wp_menu_group:multiselect(string.format("\n\v[%s]\r Override hitboxes", current_weapons), target_hitboxes)

        cache_menu.ms_o_mp_hitbox = wp_menu_group:checkbox(string.format("\v[%s]\r Override multi-point hitboxes", current_weapons))
        cache_menu.o_mp_hitbox = wp_menu_group:multiselect(string.format("\n\v[%s]\r Override multi-point hitboxes", current_weapons), target_hitboxes)

        cache_menu.ms_o_mutli_point = wp_menu_group:checkbox(string.format("\v[%s]\r Override Multi-point scale", current_weapons))
        cache_menu.o_mutli_point = wp_menu_group:slider(string.format("\n\v[%s]\r Override multi-point scale", current_weapons), 24, 100, 50, true, "%", 1, multipoint_tooltips)

        cache_menu.ms_o_hitchance = wp_menu_group:checkbox(string.format("\v[%s]\r Override hitchance", current_weapons), false)
        cache_menu.o_hitchance = wp_menu_group:slider(string.format("\n\v[%s]\r Override hitchance", current_weapons), 0, 100, 50, true, "%", 1, hitchance_tooltips)

        cache_menu.ms_o_damage = wp_menu_group:checkbox(string.format("\v[%s]\r Override min damage", current_weapons), false)
        cache_menu.o_damage = wp_menu_group:slider(string.format("\n\v[%s]\r Override min damage", current_weapons), 0, 126, 50, true, "", 1, damage_tooltips)

        cache_menu.ms_o_sec_damage = wp_menu_group:checkbox(string.format("\v[%s]\r Override second min damage", current_weapons), false)
        cache_menu.o_sec_damage = wp_menu_group:slider(string.format("\n\v[%s]\r Override second min damage", current_weapons), 0, 126, 50, true, "", 1, damage_tooltips)

        result_builder[current_weapons] = cache_menu
    end

    return result_builder
end

local wp_menu_scripts = {
    main_switch = wp_menu_group:checkbox("Enable \vMoonLight Adaptive Weapons"),
    last_update = wp_menu_group:label("\vLast Updated:\r 07.07.2023", nil, false),
    current_version = wp_menu_group:label("\vCurrent Version:\r Stable", nil, false),

    label_1 = wp_menu_group:label(" ", nil, false),
    label_2 = wp_menu_group:label("\v~ Weapons control tabs", nil, false),
    weapons_control = wp_menu_group:combobox("Weapons tabs", {"Adaptive", "Hotkey", "Indicator"}),

    adaptive = {
        label_1a = wp_menu_group:label(" ", nil, false),
        label_2a = wp_menu_group:label("\v~ Double tap setting", nil, false),
        double_tap = wp_menu_group:checkbox("Double tap", 1),
        dt_modes = wp_menu_group:combobox("\nDouble tap modes", {"Offensive", "Defensive"}),
        dt_fakelag = wp_menu_group:slider("Double tap fake lag limit", 1, 10, 1),
        dtms_fakelag_on_peek = wp_menu_group:checkbox("Double tap fake lag limit on peek"),
        dt_fakelag_on_peek = wp_menu_group:slider("\nDouble tap fake lag limit on peek", 1, 10, 1),

        label_1aa = wp_menu_group:label(" ", nil, false),
        label_12aa = wp_menu_group:label("\v~ Weapons selections", nil, false),
        weapon_tabs = wp_menu_group:combobox("Weapons type", weapon_list),
        weapons_tabs_2 = wp_menu_group:combobox("Weapons settings tabs", {"Init", "Override"}),

        label_1 = wp_menu_group:label(" ", nil, false),
        label_2 = wp_menu_group:label("\v~ Weapons adaptive setting", nil, false),
        builder_extend = wp_builder_extend(),
        override_builder = override_builder_extend(),
    },

    hotkey = {
        label_1 = wp_menu_group:label(" ", nil, false),
        label_2 = wp_menu_group:label("\v~ Override hotkey setting", nil, false),
        hitbox = wp_menu_group:hotkey("Override hitboxes"),
        mp_hitbox = wp_menu_group:hotkey("Override multi-point hitboxes"),
        multipoint = wp_menu_group:hotkey("Override multi-point scale"),
        hitchance = wp_menu_group:hotkey("Override hitchance"),
        min_dmg = wp_menu_group:hotkey("Override min dmg"),
        sec_min_dmg = wp_menu_group:hotkey("Override second min dmg"),

        label_3 = wp_menu_group:label(" ", nil, false),
        label_4 = wp_menu_group:label("\v~ Other hotkey setting", nil, false),
        force_baim = wp_menu_group:hotkey("Force body aim"),
        force_sp = wp_menu_group:hotkey("Force safe point"),
    },

    indicator = {
        label_1 = wp_menu_group:label(" ", nil, false),
        label_2 = wp_menu_group:label("\v~ Left indicator", nil, false),
        override = wp_menu_group:checkbox("Override indicator", false),
        damage = wp_menu_group:checkbox("Left DMG indicator", false),
        hitchance = wp_menu_group:checkbox("Left HC indicator", false),
    },

    label_last = wp_menu_group:label(" ", nil, false),
    export = wp_menu_group:button("Export Weapons Configs", function() end, nil, false),
    import = wp_menu_group:button("Import Weapons Configs", function() end, nil, false),
}

local wp_menu_visi = function ()
    local main_switch = wp_menu_scripts.main_switch
    local control_tabs = wp_menu_scripts.weapons_control

    for _, wp_menu in pairs(wp_menu_scripts) do
        if wp_menu == wp_menu_scripts.main_switch then goto next end
        if wp_menu.type == nil and type(wp_menu) == "table" then
            for _, wp_child_menu in pairs(wp_menu) do
                if wp_child_menu.type == nil and type(wp_child_menu) == "table" then goto next_child end

                wp_child_menu:depend({main_switch, true})
                ::next_child::
            end
        else
            wp_menu:depend({main_switch, true})
        end

        ::next::
    end

    for _, adpative_menu in pairs(wp_menu_scripts.adaptive) do
        if adpative_menu.type == nil and type(adpative_menu) == "table" then
            for _, ad_child_menu in pairs(adpative_menu) do
                if ad_child_menu.type == nil and type(ad_child_menu) == "table" then goto next_child end
                ad_child_menu:depend({control_tabs, "Adaptive"})
                ::next_child::
            end
        else
            adpative_menu:depend({control_tabs, "Adaptive"})
        end
    end

    local wp_builder_control = wp_menu_scripts.adaptive.weapon_tabs
    local wp_setting_control = wp_menu_scripts.adaptive.weapons_tabs_2
    for wp_key, wp_builder in pairs(wp_menu_scripts.adaptive.builder_extend) do
        local wp_builder_ms = wp_builder.main_switch

        for _, builder_menu in pairs(wp_builder) do
            if builder_menu == wp_builder_ms then
                builder_menu:depend({main_switch, true}, {control_tabs, "Adaptive"}, {wp_builder_control, wp_key})
            elseif wp_key == "Globals" or builder_menu == wp_builder.main_switch_label then
                builder_menu:depend({main_switch, true}, {control_tabs, "Adaptive"}, {wp_setting_control, "Init"}, {wp_builder_control, wp_key})
            else
                builder_menu:depend({main_switch, true}, {control_tabs, "Adaptive"}, {wp_setting_control, "Init"}, {wp_builder_control, wp_key}, {wp_builder_ms, true})
            end
        end

        wp_builder.dt_mp_hitbox:depend({wp_builder.dtms_mp_hitbox, true})
        wp_builder.dt_mutli_point:depend({wp_builder.dtms_mutli_point, true})
        wp_builder.dt_quick_stop:depend({wp_builder.ms_dt_quick_stop, true})
        wp_builder.prefer_ba_dis:depend({wp_builder.prefer_ba, true})

        if wp_key == "Scout" or wp_key == "AutoSniper" or wp_key == "AWP" then
            wp_builder.no_scope_quick_stop:depend({wp_builder.ms_no_scope_quick_stop, true})
        end
    end

    for wp_key, wp_builder in pairs(wp_menu_scripts.adaptive.override_builder) do
        local wp_builder_ms = wp_menu_scripts.adaptive.builder_extend[wp_key]

        for _, builder_menu in pairs(wp_builder) do
            if wp_key == "Globals" then
                builder_menu:depend({main_switch, true}, {control_tabs, "Adaptive"}, {wp_setting_control, "Override"}, {wp_builder_control, wp_key})
            else
                builder_menu:depend({main_switch, true}, {control_tabs, "Adaptive"}, {wp_setting_control, "Override"}, {wp_builder_control, wp_key}, {wp_builder_ms.main_switch, true})
            end
        end

        wp_builder.o_hitbox:depend({wp_builder.ms_o_hitbox, true})
        wp_builder.o_mp_hitbox:depend({wp_builder.ms_o_mp_hitbox, true})
        wp_builder.o_mutli_point:depend({wp_builder.ms_o_mutli_point, true})
        wp_builder.o_hitchance:depend({wp_builder.ms_o_hitchance, true})
        wp_builder.o_sec_damage:depend({wp_builder.ms_o_sec_damage, true})
        wp_builder.o_damage:depend({wp_builder.ms_o_damage, true})
    end

    wp_menu_scripts.adaptive.label_2:depend({wp_builder_control, "Globals", true})

    wp_menu_scripts.adaptive.dt_modes:depend({wp_menu_scripts.adaptive.double_tap, true})
    wp_menu_scripts.adaptive.dt_fakelag:depend({wp_menu_scripts.adaptive.double_tap, true})
    wp_menu_scripts.adaptive.dt_fakelag_on_peek:depend({wp_menu_scripts.adaptive.double_tap, true}, {wp_menu_scripts.adaptive.dtms_fakelag_on_peek, true})

    local scout_menu = wp_menu_scripts.adaptive.builder_extend["Scout"]
    scout_menu.in_air_hc:depend({scout_menu.ms_hitchane, true})
    scout_menu.no_scope_hc:depend({scout_menu.ms_hitchane, true})

    local autosniper_menu = wp_menu_scripts.adaptive.builder_extend["AutoSniper"]
    autosniper_menu.no_scope_hc:depend({autosniper_menu.ms_hitchane, true})

    for _, hotkey_menu in pairs(wp_menu_scripts.hotkey) do
        hotkey_menu:depend({control_tabs, "Hotkey"})
    end

    for _, adpative_menu in pairs(wp_menu_scripts.indicator) do
        if adpative_menu.type == nil and type(adpative_menu) == "table" then
            for _, ad_child_menu in pairs(adpative_menu) do
                if ad_child_menu.type == nil and type(ad_child_menu) == "table" then goto next_child end
                ad_child_menu:depend({control_tabs, "Indicator"})
                ::next_child::
            end
        else
            adpative_menu:depend({control_tabs, "Indicator"})
        end
    end
end

wp_menu_visi()

local menu_setup_3 = pui.setup(wp_menu_scripts)
wp_menu_scripts.export:set_callback(function ()
    local config = menu_setup_3:save()
    local encrypted = base64.encode(json.stringify(config))

    ffi_helpers.set_clipboard_text(encrypted)
end)

wp_menu_scripts.import:set_callback(function ()
    local configs = ffi_helpers.get_clipboard_text()
    local ds_configs = json.parse(base64.decode(configs))

    menu_setup_3:load(ds_configs)
end)


local ml_weapons = {
    enabled = false,
}

ml_weapons.get_current_weapons = function ()
    local localplayer = entity.get_local_player()
    local lp_weapon = entity.get_prop(entity.get_player_weapon(localplayer), "m_iItemDefinitionIndex")
    if lp_weapon == nil then return "Globals" end

    local weapon_id = bit.band(lp_weapon, 0xFFFF)

    for weapon_types, weapon_id_list in pairs(weapon_idx_to_weapon) do
        if table_fn.contains(weapon_id_list, weapon_id) then
            if wp_menu_scripts.adaptive.builder_extend[weapon_types].main_switch.value then
                return weapon_types
            else
                return "Globals"
            end
        end
    end

    return "Globals"
end

ml_weapons.globals_settings = function ()
    local localplayer = entity.get_local_player()
    if localplayer == nil or not entity.is_alive(localplayer) then return end

    local adaptive_menu = wp_menu_scripts.adaptive

    other_menu.o_min_dmg[1]:override(false)

    if not aipeek.is_detected and not aipeek.teleported then
        other_menu.double_tap[1]:override(adaptive_menu.double_tap:get_hotkey())
    end

    other_menu.double_tap[1].hotkey:set("Always on")
    other_menu.double_tap[2]:override(adaptive_menu.dt_modes.value)
    
    if other_menu.peek_assist:get() and other_menu.peek_assist:get_hotkey() and adaptive_menu.dtms_fakelag_on_peek.value then
        other_menu.double_tap_fakelag:override(adaptive_menu.dt_fakelag_on_peek.value)
    else
        other_menu.double_tap_fakelag:override(adaptive_menu.dt_fakelag.value)
    end
end

ml_weapons.hitboxes_init = function (hitboxes_table)
    return (#hitboxes_table > 0) and hitboxes_table or {"Head"}
end

ml_weapons.settings_run = function ()
    local localplayer = entity.get_local_player()
    if localplayer == nil or not entity.is_alive(localplayer) then return end

    local current_weapons = ml_weapons.get_current_weapons()
    local current = wp_menu_scripts.adaptive.builder_extend[current_weapons]
    local check_dt = other_menu.double_tap[1].value and other_menu.double_tap[1]:get_hotkey()
    local check_is_scope = entity.get_prop(localplayer, "m_bIsScoped") == 1
    local check_has_scope_wp = (current_weapons == "Scout") or (current_weapons == "AWP") or (current_weapons == "AutoSniper")

    local hotkey_setup = wp_menu_scripts.hotkey
    local current_override = wp_menu_scripts.adaptive.override_builder[current_weapons]

    if current.main_switch == nil or not current.main_switch.value then
        current = wp_menu_scripts.adaptive.builder_extend["Globals"]
    end

    other_menu.target_selection:override(current.target:get())
    other_menu.avoid_unsafe_hitboxes:override(current.unsafe_hitbox:get())
    other_menu.double_tap_hitchance:override(current.dt_hitchance:get())
    other_menu.prefer_sp:override(current.prefer_sp:get())
    other_menu.prefer_ba:override(current.prefer_ba:get())
    other_menu.prefer_ba_disablers:override(current.prefer_ba_dis:get())
    other_menu.force_ba_on_peek:override(current.force_baim_peek:get())
    other_menu.delay_shot:override(current.delay_shot.value)
    other_menu.automatic_scope:override(current.auto_scope.value)
    other_menu.accuracy_boost:override(current.accuracy_boost.value)
    other_menu.low_fps:override(current.low_fps.value)

    if hotkey_setup.hitbox:get() and current_override.ms_o_hitbox:get() then
        other_menu.hitboxes:override(ml_weapons.hitboxes_init(current_override.o_hitbox:get()))
    else
        other_menu.hitboxes:override(ml_weapons.hitboxes_init(current.hitbox:get()))
    end

    if hotkey_setup.mp_hitbox:get() and current_override.ms_o_mp_hitbox:get() then
        other_menu.mutlipoint:override(current_override.o_mp_hitbox:get())
    elseif current.dtms_mp_hitbox:get() and check_dt then
        other_menu.mutlipoint:override(current.dt_mp_hitbox:get())
    else
        other_menu.mutlipoint:override(current.mp_hitbox:get())
    end

    if hotkey_setup.multipoint:get() and current_override.ms_o_mutli_point:get() then
        other_menu.mutlipoint_scale:override(current_override.o_mutli_point:get())
    elseif current.dtms_mutli_point:get() and check_dt then
        other_menu.mutlipoint_scale:override(current.dt_mutli_point:get())
    else
        other_menu.mutlipoint_scale:override(current.mutli_point:get())
    end

    if hotkey_setup.hitchance:get() and current_override.ms_o_hitchance:get() then
        other_menu.hitchance:override(current_override.o_hitchance:get())
    elseif current_weapons == "Scout" and current.ms_hitchane.value and (moonlight.lp_current_status == "Air" or moonlight.lp_current_status == "Air-duck") then
        other_menu.hitchance:override(current.in_air_hc:get())
    elseif current_weapons == "Scout" and current.ms_hitchane.value and (not check_is_scope) then
        other_menu.hitchance:override(current.no_scope_hc:get())
    elseif current_weapons == "AutoSniper" and current.ms_hitchane.value and (not check_is_scope) then
        other_menu.hitchance:override(current.no_scope_hc:get())
    else
        other_menu.hitchance:override(current.hitchance:get())
    end

    if hotkey_setup.sec_min_dmg:get() and current_override.ms_o_sec_damage:get() then
        other_menu.min_dmg:override(current_override.o_sec_damage:get())
    elseif hotkey_setup.min_dmg:get() and current_override.ms_o_damage:get() then
        other_menu.min_dmg:override(current_override.o_damage:get())
    else
        other_menu.min_dmg:override(current.min_damage:get())
    end

    if check_has_scope_wp and current.ms_no_scope_quick_stop.value and not check_is_scope then
        other_menu.quick_stop[2]:override(current.no_scope_quick_stop.value)
    elseif current.ms_dt_quick_stop.value and check_dt then
        other_menu.quick_stop[2]:override(current.dt_quick_stop.value)
    else
        other_menu.quick_stop[2]:override(current.quick_stop.value)
    end

    if hotkey_setup.force_sp:get() then
        other_menu.force_sp:set("Always on")
    else
        other_menu.force_sp:set("On hotkey")
    end

    if hotkey_setup.force_baim:get() then
        other_menu.force_ba:set("Always on")
    else
        other_menu.force_ba:set("On hotkey")
    end
end

ml_weapons.reset_override = function ()
    other_menu.o_min_dmg[1]:override()
    other_menu.target_selection:override()
    other_menu.avoid_unsafe_hitboxes:override()
    other_menu.double_tap_hitchance:override()
    other_menu.prefer_sp:override()
    other_menu.prefer_ba:override()
    other_menu.prefer_ba_disablers:override()
    other_menu.force_ba_on_peek:override()
    other_menu.delay_shot:override()
    other_menu.automatic_scope:override()
    other_menu.accuracy_boost:override()
    other_menu.low_fps:override()
    other_menu.hitboxes:override()
    other_menu.mutlipoint:override()
    other_menu.mutlipoint_scale:override()
    other_menu.hitchance:override()
    other_menu.min_dmg:override()
    other_menu.quick_stop[2]:override()
    other_menu.force_sp:set("On hotkey")
    other_menu.force_ba:set("On hotkey")
end

ml_weapons.indicator = function ()
    local hotkey_setup = wp_menu_scripts.hotkey
    local indicator_setup = wp_menu_scripts.indicator

    if indicator_setup.override:get() then
        if hotkey_setup.hitbox:get() then
            renderer.indicator(255, 255, 255, 255, color_fn.gradient_static_text(50,245,215,255, 220,0,255,255, "O Hitboxes"))
        end

        if hotkey_setup.mp_hitbox:get() then
            renderer.indicator(255, 255, 255, 255, color_fn.gradient_static_text(50,245,215,255, 220,0,255,255, "O M_Hitboxes"))
        end

        if hotkey_setup.multipoint:get() then
            renderer.indicator(255, 255, 255, 255, color_fn.gradient_static_text(50,245,215,255, 220,0,255,255, "O Mutlipoint"))
        end

        if hotkey_setup.hitchance:get() then
            renderer.indicator(255, 255, 255, 255, color_fn.gradient_static_text(50,245,215,255, 220,0,255,255, "O Hitchance"))
        end

        if hotkey_setup.min_dmg:get() then
            renderer.indicator(255, 255, 255, 255, color_fn.gradient_static_text(50,245,215,255, 220,0,255,255, "Min DMG"))
        end

        if hotkey_setup.sec_min_dmg:get() then
            renderer.indicator(255, 255, 255, 255, color_fn.gradient_static_text(50,245,215,255, 220,0,255,255, "Sec Min DMG"))
        end
    end

    if indicator_setup.damage:get() then
        local current_dmg = (other_menu.o_min_dmg[1]:get() and other_menu.o_min_dmg[1]:get_hotkey()) and other_menu.o_min_dmg[2]:get() or other_menu.min_dmg:get()
        local current_y = renderer.indicator(124, 195, 13, 255, "DMG: "..current_dmg)

        renderer.circle_outline(160, current_y+21, 0, 0, 0, 255, 9, 0, 1, 4)
        renderer.circle_outline(160, current_y+21, 124, 195, 13, 255, 9, 0, (current_dmg/126), 4)
    end

    if indicator_setup.hitchance:get() then
        local current_hc = other_menu.hitchance:get()
        local current_y = renderer.indicator(255, 255, 255, 255, "HC: "..current_hc)

        renderer.circle_outline(135, current_y+21, 0, 0, 0, 255, 9, 0, 1, 4)
        renderer.circle_outline(135, current_y+21, 255, 255, 255, 255, 9, 0, (current_hc/100), 4)
    end
end


-- Globals Callbacks
client.set_event_callback("pre_config_save", function ()
    for _, ref_menu in pairs(other_menu) do
        if ref_menu.type == nil and type(ref_menu) == "table" then
            for _, ref_child_menu in pairs(ref_menu) do
                ref_child_menu:override()
            end
        else
            ref_menu:override()
        end
    end
end)

client.set_event_callback("pre_render", function ()
    if not menu_scripts.ms.value then return end

    moonlight.anim_breaker()
end)

client.set_event_callback("paint_ui", function ()
    -- Menu
    for _, ref_menu in pairs(gamesense) do
        if ref_menu.type == nil and type(ref_menu) == "table" then
            for _, ref_child_menu in pairs(ref_menu) do
                ui.set_visible(ref_child_menu.ref, not menu_scripts.ms.value)
            end
        else
            ui.set_visible(ref_menu.ref, not menu_scripts.ms.value)
        end
    end
    
    ui.set_visible(gamesense.freestanding.hotkey.ref, not menu_scripts.ms.value)


    if not menu_scripts.ms.value then return end

    -- Defensive
    local localplayer = entity.get_local_player()
    if localplayer == nil or not entity.is_alive(localplayer) then
        moonlight.defensive.current = 0
        moonlight.defensive.checker = 0
    else
        local lp_tickbase = entity.get_prop(localplayer, "m_nTickBase")
        moonlight.defensive.current = math.abs(lp_tickbase - moonlight.defensive.checker)
        moonlight.defensive.checker = math.max(lp_tickbase, moonlight.defensive.checker or 0)
    end
end)

client.set_event_callback('round_start', function ()
    aipeek.reset_data()
    moonlight.manual_update = globals.tickcount()
end)

client.set_event_callback("player_spawned", function (event)
    local ent = client.userid_to_entindex(event.userid)
    if ent == entity.get_local_player() then
        moonlight.respawn = true
        moonlight.manual_update = globals.tickcount()
        aipeek.reset_data()
    end
end)

client.set_event_callback("paint", function(ctx)
    if menu_scripts.ms.value then
        moonlight.crosshair()
        moonlight.min_dmg()
        moonlight.console_hitlogs()
        moonlight.def_indicator()
        moonlight.molotov_indicator(ctx)
        moonlight.aspect_ratio()
        moonlight.viewmodel()
        moonlight.scope_overlay()
    end

    if menu.main_switch.value then
        if not menu.main_switch:get_hotkey() then
            aipeek.previews_start = {entity.get_origin(entity.get_local_player())}
        end
    
        if aipeek.teleported then
            if globals.tickcount() > aipeek.last_tp then
                other_menu.double_tap[1]:override()
                aipeek.teleported = false
            end
        end
    
        aipeek.check_fire()
        aipeek.check_peek()
    
        aipeek.start_point()
        aipeek.predict_point()
        aipeek.main_function()
    
        aipeek.target_line()
    end

    if wp_menu_scripts.main_switch.value then
        ml_weapons.indicator()
    end
end)

client.set_event_callback("setup_command", function(cmd)
    moonlight.current_status(cmd)

    if menu.main_switch.value then
        aipeek.peek_function(cmd)
    end

    if menu_scripts.ms.value then
        if moonlight.respawn and moonlight.on_ground_ticks > 34 then
            moonlight.respawn = false
        end
    
        moonlight.check_on_ground_ticks()
        moonlight.check_lp_air(cmd)
        moonlight.antiaim(cmd)
        moonlight.manual()
        moonlight.other_hotkey()
        moonlight.anti_knife()
        moonlight.legit_aa()
        moonlight.fast_ladder(cmd)
        moonlight.slow_motion(cmd)
    
        moonlight.override()
    end

    if wp_menu_scripts.main_switch.value then
        ml_weapons.globals_settings()
        ml_weapons.settings_run()
        ml_weapons.enabled = true
    elseif not wp_menu_scripts.main_switch.value and ml_weapons.enabled then
        ml_weapons.reset_override()
        ml_weapons.enabled = false
    end
end)


client.set_event_callback("run_command", function (cmd)
end)

client.set_event_callback("aim_hit", function (event)
    local current_hitgroup = hitgroup_names[event.hitgroup + 1] or 'Unknown'
    local current_angle = math.floor(entity.get_prop(event.target, "m_flPoseParameter", 11) * 120 - 60)
    table.insert(moonlight.last_shot_list, {id=event.id, shot_type="hitted", hitgroup=current_hitgroup, damage=event.damage, target=event.target, angle=current_angle, hit_chance=math_fn.round(event.hit_chance)})
end)

client.set_event_callback("aim_miss", function (event)
    local current_hitgroup = hitgroup_names[event.hitgroup + 1] or 'Unknown'
    local current_reason = (event.reason == "?") and "Resolver" or event.reason
    local current_angle = math.floor(entity.get_prop(event.target, "m_flPoseParameter", 11) * 120 - 60)
    table.insert(moonlight.last_shot_list, {id=event.id, shot_type="missed", hitgroup=current_hitgroup, reason=current_reason, target=event.target, angle=current_angle, hit_chance=math_fn.round(event.hit_chance)})
end)

client.set_event_callback("aim_fire", function (event)
    moonlight.last_more_info_shot_list[tostring(event.id)] = {backtrack=math_fn.time_to_ticks(event.backtrack), teleported=event.teleported}
end)

client.set_event_callback("override_view", function (event)
    local override = false
    local thirdperson = (other_menu.thirdperson:get() and other_menu.thirdperson:get_hotkey())

    if not thirdperson and menu_scripts.misc.ms_firstperson_fov:get() then
        event.fov = menu_scripts.misc.firstperson_fov:get()
        override = true
    end

    if thirdperson and menu_scripts.misc.ms_thirdperson_fov:get() then
        event.fov = menu_scripts.misc.thirdperson_fov:get()
        override = true
    end

    if not override then
        event.fov = 116
    end
end)

client.set_event_callback("shutdown", function()
    other_menu.peek_assist.hotkey:set(menu.reset_peek.value)

    for _, ref_menu in pairs(gamesense) do
        if ref_menu.type == nil and type(ref_menu) == "table" then
            for _, ref_child_menu in pairs(ref_menu) do
                ui.set_visible(ref_child_menu.ref, true)
            end
        else
            ui.set_visible(ref_menu.ref, true)
        end
    end
    
    ui.set_visible(gamesense.freestanding.hotkey.ref, true)
    ml_weapons.reset_override()

    cvar.r_aspectratio:set_float(0)
    cvar.viewmodel_fov:set_raw_float(68)
    cvar.viewmodel_offset_x:set_raw_float(2.5)
    cvar.viewmodel_offset_y:set_raw_float(0)
    cvar.viewmodel_offset_z:set_raw_float(-1.5)

    for _, reset_function in ipairs(vmt_hook.list) do
        reset_function()
    end
end)