local ffi = require 'ffi'

ffi.cdef[[
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
    typedef uintptr_t (__thiscall* GetClientEntityByHandle_4242425_t)(void*, uint32_t);

    struct WeaponInfo_t
    {
        char* consoleName;				// 0x0004
	    char		pad_0008 [ 8 ];				// 0x0008
	    void* m_pWeaponDef;  //0x0010
	    int			iMaxClip1;					// 0x0014
	    int			iMaxClip2;					// 0x0018
	    int			iDefaultClip1;				// 0x001C
	    int			iDefaultClip2;				// 0x0020
	    char		pad_0024 [ 8 ];				// 0x0024
	    char* szWorldModel;				// 0x002C
	    char* szViewModel;				// 0x0030
	    char* szDroppedModel;				// 0x0034
	    char		pad_0038 [ 4 ];				// 0x0038
	    char* N0000023E;					// 0x003C
	    char		pad_0040 [ 56 ];				// 0x0040
	    char* szEmptySound;				// 0x0078
	    char		pad_007C [ 4 ];				// 0x007C
	    char* szBulletType;				// 0x0080
	    char		pad_0084 [ 4 ];				// 0x0084
	    char* szHudName;					// 0x0088
	    char* szWeaponName;				// 0x008C
	    char		pad_0090 [ 60 ];				// 0x0090
	    int 		WeaponType;					// 0x00C8
	    int			iWeaponPrice;				// 0x00CC
	    int			iKillAward;					// 0x00D0
	    char* szAnimationPrefix;			// 0x00D4
	    float		flCycleTime;				// 0x00D8
	    float		flCycleTimeAlt;				// 0x00DC
	    float		flTimeToIdle;				// 0x00E0
	    float		flIdleInterval;				// 0x00E4
	    bool		bFullAuto;					// 0x00E8
	    char		pad_0x00E5 [ 3 ];			// 0x00E9
	    int			iDamage;					// 0x00EC
	    float		flArmorRatio;				// 0x00F0
	    int			iBullets;					// 0x00F4
	    float		flPenetration;				// 0x00F8
	    float		flFlinchVelocityModifierLarge;	// 0x00FC
	    float		flFlinchVelocityModifierSmall;	// 0x0100
	    float		flRange;					// 0x0104
	    float		flRangeModifier;			// 0x0108
	    float		flThrowVelocity;			// 0x010C
	    char		pad_0x010C [ 16 ];			// 0x0110
	    bool		bHasSilencer;				// 0x011C
	    char		pad_0x0119 [ 3 ];			// 0x011D
	    char*       pSilencerModel;				// 0x0120
	    int			iCrosshairMinDistance;		// 0x0124
	    float		flMaxPlayerSpeed;	        // 0x0128
	    float		flMaxPlayerSpeedAlt;		// 0x012C
	    char		pad_0x0130 [ 4 ];		    // 0x0130
	    float		flSpread;					// 0x0134
	    float		flSpreadAlt;				// 0x0138
	    float		flInaccuracyCrouch;			// 0x013C
	    float		flInaccuracyCrouchAlt;		// 0x0140
	    float		flInaccuracyStand;			// 0x0144
	    float		flInaccuracyStandAlt;		// 0x0148
	    float		flInaccuracyJumpInitial;	// 0x014C
	    float		flInaccuracyJump;			// 0x0150
	    float		flInaccuracyJumpAlt;		// 0x0154
	    float		flInaccuracyLand;			// 0x0158
	    float		flInaccuracyLandAlt;		// 0x015C
	    float		flInaccuracyLadder;			// 0x0160
	    float		flInaccuracyLadderAlt;		// 0x0164
	    float		flInaccuracyFire;			// 0x0168
	    float		flInaccuracyFireAlt;		// 0x016C
	    float		flInaccuracyMove;			// 0x0170
	    float		flInaccuracyMoveAlt;		// 0x0174
	    float		flInaccuracyReload;			// 0x0178
	    int			iRecoilSeed;				// 0x017C
	    float		flRecoilAngle;				// 0x0180
	    float		flRecoilAngleAlt;			// 0x0184
	    float		flRecoilAngleVariance;		// 0x0188
	    float		flRecoilAngleVarianceAlt;	// 0x018C
	    float		flRecoilMagnitude;			// 0x0190
	    float		flRecoilMagnitudeAlt;		// 0x0194
	    float		flRecoilMagnitudeVariance;	// 0x0198
	    float		flRecoilMagnitudeVarianceAlt;	// 0x019C
	    float		flRecoveryTimeCrouch;		// 0x01A0
	    float		flRecoveryTimeStand;		// 0x01A4
	    float		flRecoveryTimeCrouchFinal;	// 0x01A8
	    float		flRecoveryTimeStandFinal;	// 0x01AC
	    int			iRecoveryTransitionStartBullet;	// 0x01B0 
	    int			iRecoveryTransitionEndBullet;	// 0x01B4
	    bool		bUnzoomAfterShot;			// 0x01B8
	    bool		bHideViewModelZoomed;		// 0x01B9
	    char		pad_0x01B5 [ 2 ];			// 0x01BA
	    char		iZoomLevels [ 3 ];			// 0x01BC
	    int			iZoomFOV [ 2 ];				// 0x01C0
	    float		fZoomTime [ 3 ];				// 0x01C4
	    char* szWeaponClass;				// 0x01D4
	    float		flAddonScale;				// 0x01D8
	    char		pad_0x01DC [ 4 ];			// 0x01DC
	    char* szEjectBrassEffect;			// 0x01E0
	    char* szTracerEffect;				// 0x01E4
	    int			iTracerFrequency;			// 0x01E8
	    int			iTracerFrequencyAlt;		// 0x01EC
	    char* szMuzzleFlashEffect_1stPerson;	// 0x01F0
	    char		pad_0x01F4 [ 4 ];				// 0x01F4
	    char* szMuzzleFlashEffect_3rdPerson;	// 0x01F8
	    char		pad_0x01FC [ 4 ];			// 0x01FC
	    char* szMuzzleSmokeEffect;		// 0x0200
	    float		flHeatPerShot;				// 0x0204
	    char* szZoomInSound;				// 0x0208
	    char* szZoomOutSound;				// 0x020C
	    float		flInaccuracyPitchShift;		// 0x0210
	    float		flInaccuracySoundThreshold;	// 0x0214
	    float		flBotAudibleRange;			// 0x0218
	    char		pad_0x0218 [ 8 ];			// 0x0220
	    char* pWrongTeamMsg;				// 0x0224
	    bool		bHasBurstMode;				// 0x0228
	    char		pad_0x0225 [ 3 ];			// 0x0229
	    bool		bIsRevolver;				// 0x022C
	    bool		bCannotShootUnderwater;		// 0x0230
    };
]]

local ENTITY_LIST_POINTER = ffi.cast("void***", memory.create_interface("client.dll", "VClientEntityList003")) or error("Failed to find VClientEntityList003!")
local GET_CLIENT_ENTITY_FN = ffi.cast("GetClientEntity_4242425_t", ENTITY_LIST_POINTER[0][3])
local GET_CLIENT_ENTITY_BY_HANDLE_FN = ffi.cast("GetClientEntityByHandle_4242425_t", ENTITY_LIST_POINTER[0][4])

local ffi_helpers = {
    get_entity_address_by_handle = function(handle)
        local addr = GET_CLIENT_ENTITY_BY_HANDLE_FN(ENTITY_LIST_POINTER, handle)
        return addr
    end
}

local weapon_data_call = ffi.cast("int*(__thiscall*)(void*)", memory.find_pattern("client.dll", "55 8B EC 81 EC ? ? ? ? 53 8B D9 56 57 8D 8B ? ? ? ? 85 C9 75 04"))
local length = menu.add_slider("Custom Scope", "Scope Length", 1, 100)
local gap = menu.add_slider("Custom Scope", "Scope Gap", 1, 100)
local thickness = menu.add_slider("Custom Scope", "Scope Thickness", 1, 5)
local anim_speed = menu.add_slider("Custom Scope", "Scope Animation Speed", 1, 500)
local inaccuracy = menu.add_checkbox("Custom Scope", "Change size by inaccuracy")
local first_cbox_color = menu.add_checkbox("Custom Scope", "Color 1")
local color_1 = first_cbox_color:add_color_picker("Color 1")
local second_cbox_color = menu.add_checkbox("Custom Scope", "Color 2")
local color_2 = second_cbox_color:add_color_picker("Color 2")

local screen = render.get_screen_size()

local visual_items = {}

visual_items.scope_data = {
    length = 0,
    gap = 0,
    thickness = 0
}

function clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

local FL_ONGROUND = bit.lshift(1, 0)
local FL_DUCKING = bit.lshift(1, 1)

local current_movement_state = function()
    local lp = entity_list.get_local_player()
    if not lp then return end

    local flags = lp:get_prop("m_fFlags")

    local is_not_on_ground = bit.band(flags, FL_ONGROUND) == 0
    local is_crouching = bit.band(flags, FL_DUCKING) ~= 0

    local lp_velocity = lp:get_prop("m_vecVelocity")

    if is_not_on_ground then
        return 4
    else
        if is_crouching then
            return 3
        elseif lp_velocity.x > 5 or lp_velocity.x < -5 then
            return 2
        end
    end
    return 1
end

local weapon_inaccuracy = 0
local wanted_weapon_inaccuracy = 0

visual_items.custom_scope_draw = function()
    local lp = entity_list.get_local_player()
    if not lp then return end
    local lp_hp = lp:get_prop("m_iHealth")
    if lp_hp < 1 then
        visual_items.scope_data = {
            length = 0,
            gap = 0,
            thickness = 0
        }
        return
    end
    local animation_time = (global_vars.absolute_frame_time() * (1.0 / 0.9)) * anim_speed:get()
    local animation_time_2 = (global_vars.absolute_frame_time() * (1.0 / 0.9)) * 100

    local is_scoped = lp:get_prop("m_bIsScoped")
    if is_scoped == 1 then
        if visual_items.scope_data.length < length:get() then
            visual_items.scope_data.length = visual_items.scope_data.length + animation_time
        elseif visual_items.scope_data.length > length:get() then
            visual_items.scope_data.length = visual_items.scope_data.length - animation_time
        end
    else
        if visual_items.scope_data.length > 0 then
            visual_items.scope_data.length = visual_items.scope_data.length - animation_time
        end
    end

    local gradient_color_1 = color_1:get()
    local gradient_color_2 = color_2:get()

    visual_items.scope_data.length = clamp(visual_items.scope_data.length, 0, length:get())
    visual_items.scope_data.gap = gap:get()
    visual_items.scope_data.thickness = thickness:get()

    local weapon_data = ffi.cast("struct WeaponInfo_t*", weapon_data_call(ffi.cast("void*", ffi_helpers.get_entity_address_by_handle(lp:get_prop("m_hActiveWeapon")))));

    if weapon_data and inaccuracy:get() then
        local state = current_movement_state()
        if state == 4 then
            weapon_inaccuracy = weapon_data.flInaccuracyJump
        elseif state == 2 then
            weapon_inaccuracy = (weapon_data.flInaccuracyMove) * 2
        elseif state == 3 then
            weapon_inaccuracy = (weapon_data.flInaccuracyCrouch) * 0.2
        else
            weapon_inaccuracy = weapon_data.flInaccuracyStand
        end
    else
        weapon_inaccuracy = 0
        wanted_weapon_inaccuracy = 0
    end
    if weapon_inaccuracy ~= 0 then
        weapon_inaccuracy = math.floor(weapon_inaccuracy * 100)
        if wanted_weapon_inaccuracy ~= weapon_inaccuracy then
            if wanted_weapon_inaccuracy < weapon_inaccuracy then
                wanted_weapon_inaccuracy = clamp(wanted_weapon_inaccuracy + animation_time_2, 0, weapon_inaccuracy)
            else
                wanted_weapon_inaccuracy = clamp(wanted_weapon_inaccuracy - animation_time_2, weapon_inaccuracy, 2147483647)
            end
        end
    end

    if visual_items.scope_data.length > 0 then
        local draw_pos = {
            x = screen.x/2,
            y = screen.y/2,
            w = visual_items.scope_data.length,
            h = visual_items.scope_data.thickness
        }

        render.rect_fade(vec2_t(draw_pos.x - visual_items.scope_data.gap - draw_pos.w - wanted_weapon_inaccuracy, draw_pos.y - math.floor(visual_items.scope_data.thickness/2)), vec2_t(draw_pos.w, draw_pos.h), gradient_color_2, gradient_color_1, true)
        render.rect_fade(vec2_t(draw_pos.x - math.floor(visual_items.scope_data.thickness/2), draw_pos.y - visual_items.scope_data.gap - draw_pos.w - wanted_weapon_inaccuracy), vec2_t(draw_pos.h, draw_pos.w), gradient_color_2, gradient_color_1, false)

        render.rect_fade(vec2_t(draw_pos.x + visual_items.scope_data.gap + wanted_weapon_inaccuracy, draw_pos.y - math.floor(visual_items.scope_data.thickness/2)), vec2_t(draw_pos.w, draw_pos.h), gradient_color_1, gradient_color_2, true)
        render.rect_fade(vec2_t(draw_pos.x - math.floor(visual_items.scope_data.thickness/2), draw_pos.y + visual_items.scope_data.gap + wanted_weapon_inaccuracy), vec2_t(draw_pos.h, draw_pos.w), gradient_color_1, gradient_color_2, false)
    end
end

callbacks.add(e_callbacks.PAINT, function()
    visual_items.custom_scope_draw()
end)