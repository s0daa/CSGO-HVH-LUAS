--downloaded from dsc.gg/southwestcfgs

main = {
    welcome = menu.add_text("Info", "Welcome Back, by southwest\n"),
    welcome2 = menu.add_text("Info", "Stay With US - Bluhgang resolver"),
    res = {
        resolver = menu.add_checkbox("Main", "Enable Bluhgang resolver"),
        type = menu.add_selection("Main", "Resolver Type", {
            "Default",
            "Jitter",
            "Alternative",
            "Random"
        }),
    }
}
refs = {
    res_aa = menu.find("Aimbot", "General", "Aimbot", "Resolve Antiaim"),
    notenemy = "None",
    angle = 0,
    empty4 = 0,
}
local empty = 0
ffi.cdef("    typedef uintptr_t (__thiscall* GetClientEntity_123123_t)(void*, int);\n    struct CAnimstate {\n        char pad[ 3 ];\n        char m_bForceWeaponUpdate; //0x4\n        char pad1[ 91 ];\n        void* m_pBaseEntity; //0x60\n        void* m_pActiveWeapon; //0x64\n        void* m_pLastActiveWeapon; //0x68\n        float m_flLastClientSideAnimationUpdateTime; //0x6C\n        int m_iLastClientSideAnimationUpdateFramecount; //0x70\n        float m_flAnimUpdateDelta; //0x74\n        float m_flEyeYaw; //0x78\n        float m_flPitch; //0x7C\n        float m_flGoalFeetYaw; //0x80\n        float m_flCurrentFeetYaw; //0x84\n        float m_flCurrentTorsoYaw; //0x88\n        float m_flUnknownVelocityLean; //0x8C\n        float m_flLeanAmount; //0x90\n        char pad2[ 4 ];\n        float m_flFeetCycle; //0x98\n        float m_flFeetYawRate; //0x9C\n        char pad3[ 4 ];\n        float m_fDuckAmount; //0xA4\n        float m_fLandingDuckAdditiveSomething; //0xA8\n        char pad4[ 4 ];\n        float m_vOriginX; //0xB0\n        float m_vOriginY; //0xB4\n        float m_vOriginZ; //0xB8\n        float m_vLastOriginX; //0xBC\n        float m_vLastOriginY; //0xC0\n        float m_vLastOriginZ; //0xC4\n        float m_vVelocityX; //0xC8\n        float m_vVelocityY; //0xCC\n        char pad5[ 4 ];\n        float m_flUnknownFloat1; //0xD4\n        char pad6[ 8 ];\n        float m_flUnknownFloat2; //0xE0\n        float m_flUnknownFloat3; //0xE4\n        float m_flUnknown; //0xE8\n        float m_flSpeed2D; //0xEC\n        float m_flUpVelocity; //0xF0\n        float m_flSpeedNormalized; //0xF4\n        float m_flFeetSpeedForwardsOrSideWays; //0xF8\n        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC\n        float m_flTimeSinceStartedMoving; //0x100\n        float m_flTimeSinceStoppedMoving; //0x104\n        bool m_bOnGround; //0x108\n        bool m_bInHitGroundAnimation; //0x109\n        float m_flTimeSinceInAir; //0x10A\n        float m_flLastOriginZ; //0x10E\n        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112\n        float m_flStopToFullRunningFraction; //0x116\n        char pad7[ 4 ]; //0x11A\n        float m_flMagicFraction; //0x11E\n        char pad8[ 60 ]; //0x122\n        float m_flWorldForce; //0x15E\n        char pad9[ 458 ]; //0x162\n        float m_flMinYaw; //0x330\n        float m_flMaxYaw; //0x334\n    };\n    typedef uintptr_t (__thiscall* GetClientEntity_123123_t)(void*, int);\n    typedef struct mask {\n        char m_pDriverName[512];\n        unsigned int m_VendorID;\n        unsigned int m_DeviceID;\n        unsigned int m_SubSysID;\n        unsigned int m_Revision;\n        int m_nDXSupportLevel;\n        int m_nMinDXSupportLevel;\n        int m_nMaxDXSupportLevel;\n        unsigned int m_nDriverVersionHigh;\n        unsigned int m_nDriverVersionLow;\n        int64_t pad_0;\n        union {\n            int xuid;\n            struct {\n                int xuidlow;\n                int xuidhigh;\n            };\n        };\n        char name[128];\n        int userid;\n        char guid[33];\n        unsigned int friendsid;\n        char friendsname[128];\n        bool fakeplayer;\n        bool ishltv;\n        unsigned int customfiles[4];\n        unsigned char filesdownloaded;\n    };\n    typedef int(__thiscall* get_current_adapter_fn)(void*);\n    typedef void(__thiscall* get_adapters_info_fn)(void*, int adapter, struct mask& info);\n    typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);\n    typedef long(__thiscall* get_file_time_t)(void* this, const char* pFileName, const char* pPathID);\n")
local idk = ffi.cast("void***", memory.create_interface("client.dll", "VClientEntityList003"))
local cliententity = ffi.cast("GetClientEntity_123123_t", idk[0][3])

local function huina(s)
    return cliententity(idk, s)
end

local function resolver()
    refs.res_aa:set(not main.res.resolver:get())

    if not main.res.resolver:get() then return end

    local lp = entity_list.get_local_player()

    if lp == nil then return end

    local players = entity_list.get_players(true)
    for k, v in pairs(players) do
        if k ~= lp then
            local animstate = ffi.cast("struct CAnimstate**", huina(v:get_index()) + 39264)[0]
            local ticks = globals.tick_count() % 2 == 0 and 1 or -1
            local ticks2 = globals.tick_count() % 3
            local ticks3 = globals.tick_count() % 10 > 4 and 1 or -1

            local empty = client.random_float(-58, 58) -- randomizer res

            if main.res.type:get() == 1 then
                empty4 = ticks3 * math.abs(empty) -- default
            elseif main.res.type:get() == 2 then
                empty4 = ticks * math.abs(empty) -- jitter
            elseif main.res.type:get() == 3 then
                empty4 = ticks2 * math.abs(empty) -- alternative
            elseif main.res.type:get() == 4 then
                empty4 = empty -- random
            end

            animstate.m_flGoalFeetYaw = animstate.m_flEyeYaw + empty4
            refs.notenemy = v:get_name()
            refs.angle = math.floor(v:get_prop("m_flPoseParameter", 11) * 120)
        end
    end
end
callbacks.add(e_callbacks.NET_UPDATE, resolver)

local screen_size = render.get_screen_size()
local font = render.create_font("Smallest Pixel-7", 10, 300, e_font_flags.OUTLINE)

local function log()
    local players = entity_list.get_local_player()

    if players == nil then return end

    if not players:is_alive() then return end

    render.rect(vec2_t(25, screen_size.y / 2 + 90), vec2_t(125, 40), color_t(255, 255, 255, 155), 5)
    render.rect_filled(vec2_t(25, screen_size.y / 2 + 90), vec2_t(125, 40), color_t(0, 0, 0, 55), 5)
    render.text(font, "> Bluhgang resolver [dev]", vec2_t(30, screen_size.y / 2 + 95), color_t(255, 255, 255, 255))
    render.text(font, "> User: " .. string.sub("southwest", 1, 15), vec2_t(30, screen_size.y / 2 + 105), color_t(255, 200, 255, 255))
    render.text(font, "> Enemy: " .. string.sub(refs.notenemy, 1, 15) .. " " .. refs.angle .. "°", vec2_t(30, screen_size.y / 2 + 115), color_t(200, 200, 255, 255))
end
callbacks.add(e_callbacks.PAINT, log)