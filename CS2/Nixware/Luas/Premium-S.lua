-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local ffi = require("ffi")
if not pcall(ffi.sizeof, "struct CParticleInformation") then
    ffi.cdef([[
        typedef struct Vector {
            float x, y, z;
        } Vector;

        typedef struct CBindingData {
            void* pData;
            uint64_t nUnknown, nUnknown2;
            uint32_t* pRefCount;
        } CBindingData;

        typedef struct CStrongHandle {
            struct CBindingData* pBinding;
        } CStrongHandle;

        typedef struct ZV {
            float r, g, b;
        } ZV;

        typedef struct CParticleEffect {
            const char* szName;
            char pad_01[0x30];
        } CParticleEffect;

        typedef struct CParticleData {
            Vector* vecPositions;
            char n1zex[0x74];
            float* flTimes;
            char niz3x[0x28];
            float* flTimes2;
            char nizex[0x98];
        } CParticleData;

        typedef struct CParticleInformation {
            float flTime, flWidth, flUnknown;
        } CParticleInformation;

        typedef struct vec3_t {
            float x, y, z;
        } vec3_t;

        typedef struct bullet_data {
            vec3_t position;
            float time_stamp, expire_time;
        } bullet_data;

        unsigned short GetAsyncKeyState(int vKey);

        typedef struct Thread32Entry {
            uint32_t dwSize, cntUsage, th32ThreadID, th32OwnerProcessID;
            long tpBasePri, tpDeltaPri;
            uint32_t dwFlags;
        } Thread32Entry;

        int CloseHandle(void*);
        uint32_t ResumeThread(void*);
        uint32_t GetCurrentThreadId();
        uint32_t SuspendThread(void*);
        uint32_t GetCurrentProcessId();
        void* OpenThread(uint32_t, int, uint32_t);
        void* GetProcAddress(uintptr_t, const char*);
        int Thread32Next(void*, struct Thread32Entry*);
        int Thread32First(void*, struct Thread32Entry*);
        void* CreateToolhelp32Snapshot(uint32_t, uint32_t);
        int VirtualProtect(void*, uint64_t, uint32_t, uint32_t*);
    ]])
end

local colors = {
    accent = color_t(0.8, 1, 0.2588, 1),
    purple_neon = color_t(0.7, 0.2, 1, 1),
    glass_color = color_t(0.1, 0.1, 0.1, 0.7),
    border_color = color_t(1, 1, 1, 0.2),
    shadow_color = color_t(0, 0, 0, 0.5)
}

local STATES = {
    [0x5A] = 90, -- Z key
    [0x43] = -90, -- C key

    default = 180
}

local held_keys_cache = {}
local ENABLE_INDICATOR = true
local INDICATOR_COLOR = color_t(0.72, 0.76, 1, 1)
local INDICATOR_DISTANCE = 40
local function is_key_pressed(virtualKey)
    return bit.band(ffi.C.GetAsyncKeyState(virtualKey), 32768) == 32768
end

local Verdana = render.setup_font("C:/Windows/Fonts/verdanab.ttf", 12, 16)
local logs, watermark_length = {}, 0
local current_fps, frame_count_for_fps, last_time_for_fps = 0, 0, os.clock()
local full_text = "ImSynZx"

local scriptPath = debug.getinfo(1, "S").source:sub(2)
local scriptDir = scriptPath:match("(.*/)")
local NixImg = scriptDir .. "ImSynZx/Nixware-Logo.png"
local nixwareImage = render.setup_texture(NixImg)
local nOffset = 0

local netvars = {
    m_sSanitizedPlayerName = engine.get_netvar_offset("client.dll", "CCSPlayerController", "m_sSanitizedPlayerName") or
        0,
    m_hOriginalController = engine.get_netvar_offset("client.dll", "C_CSPlayerPawnBase", "m_hOriginalController") or 0,
    m_nTickBase = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_nTickBase") or 0
}

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function logMessage(str)
    print("[ImSynZx]", colors.accent, str)
end

local function GetHitgroupName(nHitgroup)
    return ({"head", "chest", "generic", "arms", "arms", "neck", "legs", "legs", "stomach"})[nHitgroup] or "unknown"
end

local is_error = false
local f = string.format

local function set_event_callback(event_name, callback)
    local handle = function(...)
        if is_error then
            return
        end
        local success, reason = pcall(callback)
        if not success then
            print("Error in callback: " .. tostring(reason))
            is_error = true
        end
    end
    register_callback(event_name, handle)
end

local lerp = function(a, b, t)
    return a + (b - a) * t
end

local framelerp = function(start_value, end_value, percentage)
    end_value = type(end_value) == 'boolean' and (end_value and 1 or 0) or end_value
    return lerp(start_value, end_value, render.frame_time() * percentage)
end

local mock_get_real_time = function()
    return os.clock()
end

local animation = {}
do
    local start_time = mock_get_real_time()
    local scale = 0
    local scale_duration = 3
    local full_size = 50
    local glass_alpha = 0.7

    local FONT = render.setup_font('c:/windows/fonts/tahomabd.ttf', full_size, 0)
    local SCREEN_SIZE = render.screen_size()

    function animation:on_paint()
        local curtime = mock_get_real_time()
        local elapsed_time = curtime - start_time
        if elapsed_time < scale_duration then
            scale = framelerp(scale, 1, 1)
        else
            scale = 1
            return
        end

        local TEXT = f('PREMIUM LUA BY IMSYNZX')
        local TEXT_SIZE = render.calc_text_size(TEXT, FONT, full_size * scale)
        local position = vec2_t((SCREEN_SIZE.x - TEXT_SIZE.x) / 2, (SCREEN_SIZE.y - TEXT_SIZE.y) / 2)
        local background_color = color_t(0, 0, 0, glass_alpha * 255)
        render.rect_filled(vec2_t(0, 0), SCREEN_SIZE, background_color)
        for glow_alpha = 100, 255, 40 do
            render.text(TEXT, FONT, vec2_t(position.x + 1, position.y + 1), full_size * scale,
                color_t(255, 255, 255, glow_alpha * 0.6)) -- Slight offset for 3D effect
        end

        render.text(TEXT, FONT, position, full_size * scale, color_t(255, 215, 0, 255))
    end

    set_event_callback('paint', function()
        animation:on_paint()
    end)
end

local function onDamageHitLogs(event)
    local pLocalPawn = event:get_pawn("attacker")
    if not pLocalPawn then
        print("Error: pLocalPawn is nil!")
        return
    end

    local pVictimPawn = event:get_pawn("userid")
    local isLocalPlayerInvolved = pLocalPawn == entitylist.get_local_player_pawn() or pVictimPawn ==
                                      entitylist.get_local_player_pawn()

    if not isLocalPlayerInvolved then
        return
    end

    local pLocalController = entitylist.get_local_player_controller()
    local pLocalTickBase = ffi.cast("int*", pLocalController[netvars.m_nTickBase])
    local nHealth = event:get_int("health") or 0
    local nDamage = event:get_int("dmg_health") or 0
    local szHitgroup = GetHitgroupName(event:get_int("hitgroup") or -1)
    local attackerName = ""
    local isAttacker = pLocalPawn == entitylist.get_local_player_pawn()
    local pControllerHandle = ffi.cast("int*", isAttacker and pVictimPawn[netvars.m_hOriginalController] or
                                  pLocalPawn[netvars.m_hOriginalController])[0]
    local attackerController = entitylist.get_entity_from_handle(pControllerHandle)
    attackerName = ffi.string(ffi.cast("char**", attackerController[netvars.m_sSanitizedPlayerName])[0] or "")
    local playerName = isAttacker and attackerName or "You"

    local logMessageText = isAttacker and
                               string.format("Hit %s in the %s for %d damage (%d health remaining)", attackerName,
            szHitgroup, nDamage, nHealth) or
                               string.format("Received %d damage from %s in the %s (%d health remaining)", nDamage,
            attackerName, szHitgroup, nHealth)

    table.insert(logs, {
        szText = logMessageText,
        nTickBase = pLocalTickBase[0] + (4 / 0.015625),
        flAlpha = 0
    })

    if #logs > 10 then
        table.remove(logs, 1)
    end
end

local function get_text_dimensions(font, text, size)
    return vec2_t(size * 0.6 * #text, size)
end

local function drawRoundedRectangle(from, to, color, rounding)
    render.rect(from, to, color, rounding)
end

local function drawGlassRectangle(from, to, color, rounding)
    render.rect_filled(from, to, color, rounding)
    render.rect(from, to, colors.border_color, rounding, 1)
end

local function updateWatermark()
    if os.clock() - last_time_for_fps < 0.1 then
        return
    end
    watermark_length = math.min(watermark_length + 1, #full_text)
end
local function drawWatermark()
    local screen_size = render.screen_size()
    local current_time = os.date("%H:%M")

    if not nixwareImage then
        logMessage("Failed to load Nixware image!")
        return
    end

    local watermark_text = string.format("%s | Time: %s | 0 ms | FPS: %d | %s | %s", get_user_name(), current_time,
        current_fps, engine.get_level_name(), get_script_name())
    local text_size = get_text_dimensions(Verdana, watermark_text, 12)
    local padding, logo_width, logo_height = 5, 15, 12
    local total_width = text_size.x + logo_width + padding * 3
    local x = screen_size.x - total_width + 60
    local y = 15
    drawGlassRectangle(vec2_t(x - 10, y - 10),
        vec2_t(x + total_width - 70, y + math.max(logo_height, text_size.y + padding * 2) + 10), colors.glass_color, 10)
    render.texture(nixwareImage, vec2_t(x + padding + 5, y + 5),
        vec2_t(x + padding + 5 + logo_width, y + 5 + logo_height), color_t(255, 255, 255, 255))
    local centered_x = x + logo_width + padding * 2 + 20
    render.text(watermark_text, Verdana, vec2_t(centered_x + 2, y + padding + 2), colors.shadow_color)
    render.text(watermark_text, Verdana, vec2_t(centered_x, y + padding), color_t(1, 1, 1, 1))
end

local function renderTextWithShadow(text, shadowColor, textColor, position, font)
    render.text(text, font, position + vec2_t(1, 1), shadowColor)
    render.text(text, font, position, textColor)
end

local function fnOnPaint()
    local current_time = os.clock()
    frame_count_for_fps = frame_count_for_fps + 1
    if current_time - last_time_for_fps >= 1 then
        current_fps = frame_count_for_fps
        frame_count_for_fps = 0
        last_time_for_fps = current_time
    end
    local pLocalController = entitylist.get_local_player_controller()
    if not pLocalController then
        logs = {}
        return
    end
    local pLocalTickBase = ffi.cast("int*", pLocalController[netvars.m_nTickBase])[0]
    if not pLocalTickBase then
        return
    end
    for i = #logs, 1, -1 do
        local v = logs[i]
        local vecRenderPos = vec2_t(35, 350 + nOffset)

        v.flAlpha = Lerp(v.flAlpha, pLocalTickBase > v.nTickBase and 0 or 1, 20 * render.frame_time())

        if nixwareImage then
            local topLeft = vec2_t(vecRenderPos.x - 20, vecRenderPos.y)
            local bottomRight = vec2_t(topLeft.x + 12, topLeft.y + 12)
            render.texture(nixwareImage, topLeft, bottomRight, color_t(255, 255, 255, v.flAlpha))
        end
        renderTextWithShadow(v.szText, color_t(0, 0, 0, v.flAlpha * 0.25), color_t(1, 1, 1, v.flAlpha), vecRenderPos,
            Verdana)
        nOffset = nOffset + 16 * v.flAlpha
        if v.flAlpha < 0.0001 then
            table.remove(logs, i)
        end
    end

    for k, v in pairs(STATES) do
        if k == "default" then
            goto continue
        end

        local is_key_held = is_key_pressed(k)

        if (not held_keys_cache[k]) and is_key_held then
            if menu.ragebot_anti_aim_base_yaw_offset == v then
                menu.ragebot_anti_aim_base_yaw_offset = STATES["default"]
            else
                menu.ragebot_anti_aim_base_yaw_offset = v
            end
        end

        held_keys_cache[k] = is_key_held
        ::continue::
    end

    if ENABLE_INDICATOR then
        if not entitylist.get_local_player_pawn() then
            return
        end

        local screen_center = vec2_t(render.screen_size().x / 2, render.screen_size().y / 2)
        local offset = menu.ragebot_anti_aim_base_yaw_offset
        local manual = (offset >= 45 and offset <= 145) and 2 or (offset <= -75 and offset >= -145) and 1 or 0
        render.filled_polygon({vec2_t(screen_center.x + (INDICATOR_DISTANCE + 15), screen_center.y),
                               vec2_t(screen_center.x + (INDICATOR_DISTANCE + 2), screen_center.y - 9),
                               vec2_t(screen_center.x + (INDICATOR_DISTANCE + 2), screen_center.y + 9)},
            manual == 1 and INDICATOR_COLOR or color_t(0, 0, 0, 0.4))
        render.filled_polygon({vec2_t(screen_center.x - (INDICATOR_DISTANCE + 15), screen_center.y),
                               vec2_t(screen_center.x - (INDICATOR_DISTANCE + 2), screen_center.y - 9),
                               vec2_t(screen_center.x - (INDICATOR_DISTANCE + 2), screen_center.y + 9)},
            manual == 2 and INDICATOR_COLOR or color_t(0, 0, 0, 0.4))
    end

    nOffset = 0
    updateWatermark()
    drawWatermark()
end

-- Bullet Tracers By SYR1337
local COLOR_RIGHT_HERE = color_t(140 / 255, 142 / 255, 255 / 255, 0.8)

xpcall(function()
    local print = function(...)
    end;
    local find_pattern_og = find_pattern
    find_pattern = function(a, b)
        local c = find_pattern_og(a, b)
        if not c then
            print(tostring(b) .. "  инвалид конкретный")
        end
        return c
    end

    local Abs = function(addr, pre, post)
        addr = ffi.cast("uintptr_t", addr);
        addr = addr + (pre or 1)
        addr = addr + ffi.sizeof("int") + ffi.cast("int64_t", ffi.cast("int*", addr)[0])
        addr = addr + (post or 0)
        return addr
    end;
    local anton_vfunc_CreateSnapshot = function(...)
    end
    local anton_vfunc_Draw = function(...)
    end
    local IParticleManager = setmetatable({
        pPatricleManager = nil,
        ppPatricleManager = (function()
            local ppParticleManager = assert(find_pattern("client.dll", "48 8B 05 ?? ?? ?? ?? 48 8B 08 48 8B 59 68"),
                "bullet tracer: not found patricle manager")
            ppParticleManager = ffi.cast("uintptr_t", ppParticleManager);
            return ffi.cast("void**", ppParticleManager + 7 + ffi.cast("int*", ppParticleManager + 3)[0])
        end)()
    }, {
        __index = {
            Get = function(this)
                return this.pPatricleManager
            end,

            Update = function(this)
                this.pPatricleManager = this.ppPatricleManager[0]
                anton_vfunc_CreateSnapshot = this:GetVFunc(42,
                    "void(__thiscall*)(void*, struct CStrongHandle*, int64_t*)")
                anton_vfunc_Draw = this:GetVFunc(43, "void(__thiscall*)(void*, struct CStrongHandle*, int, void*)")
            end,

            IsValid = function(this)
                return this.pPatricleManager and this.ppPatricleManager and this.pPatricleManager ~= ffi.NULL and
                           this.ppPatricleManager ~= ffi.NULL
            end,

            CallVFunc = function(this, nIndex, szType, ...)
                if not this:IsValid() then
                    return nil
                end

                local pVtable = ffi.cast("void***", this:Get())
                local func = ffi.cast(szType, pVtable[0][nIndex])

                if (not func or func == 0 or func == ffi.NULL) then
                    return nil;
                end

                return func(this:Get(), ...)
            end,

            GetVFunc = function(this, nIndex, szType)
                if not this:IsValid() then
                    return nil
                end

                local pVtable = ffi.cast("void***", this:Get())
                local func = ffi.cast(szType, pVtable[0][nIndex])

                if (not func or func == 0 or func == ffi.NULL) then
                    return nil;
                end

                return func
            end,

            CreateSnapshot = function(this, pSnapShotHandle)
                if not this:IsValid() then
                    return false
                end

                local pUtlStringData = ffi.new("int64_t[1]")
                this:CallVFunc(42, "void(__thiscall*)(void*, struct CStrongHandle*, int64_t*)", pSnapShotHandle,
                    pUtlStringData)
                return true
            end,

            Draw = function(this, pSnapShotHandle, nCount, pEffectData)
                if not this:IsValid() then
                    return false
                end

                this:CallVFunc(43, "void(__thiscall*)(void*, struct CStrongHandle*, int, void*)", pSnapShotHandle,
                    nCount, pEffectData)
                return true
            end
        }
    })

    local IGameParticleManager = setmetatable({
        pGameParticleManager = nil,
        fnSetEffectData = ffi.cast("void(__fastcall*)(void*, uint32_t, int, void*, int)",
            Abs(find_pattern("client.dll", "E8 ? ? ? ? 4C 39 A7 ? ? ? ?"), 1, 0)),
        fnCreateEffectIndex = ffi.cast("void(__fastcall*)(void*, uint32_t*, struct CParticleEffect*)",
            find_pattern("client.dll", "40 57 48 83 EC 20 49 8B ?? 48 8B")),
        fnCreateEffect2 = ffi.cast(
            "void(__fastcall*)(void*, uint32_t*, const char*, int, int64_t, int64_t, int64_t, int)",
            Abs(find_pattern("client.dll", "E8 ? ? ? ? 33 D2 8B 08 89 4E 44"), 0x1, 0x0)),
        fnInitEffect = ffi.cast("bool(__fastcall*)(void*, int, uint32_t, struct CStrongHandle*)", find_pattern(
            "client.dll", "48 89 74 24 10 57 48 83 EC 30 4C 8B D9 49 8B F9 33 C9 41 8B F0 83 FA FF 0F")),
        fnGetGameParticleManager = ffi.cast("void*(__fastcall*)()", find_pattern("client.dll",
            "48 8B ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? 48 89 5C 24 10 57 48 81 EC 70 06 ?? ?? 48 8B 1D"))
    }, {
        __index = {
            Get = function(this)
                return this.pGameParticleManager
            end,

            Update = function(this)
                this.pGameParticleManager = this.fnGetGameParticleManager()
            end,

            IsValid = function(this)
                return this.pGameParticleManager and this.pGameParticleManager ~= ffi.NULL
            end,

            CallVFunc = function(this, nIndex, szType, ...)
                if not this:IsValid() then
                    return -1337
                end

                local pVtable = ffi.cast("void***", this:Get())
                return ffi.cast(szType, pVtable[0][nIndex])(...)
            end,

            CreateEffectIndex = function(this, pEffectIndex, pEffectData)
                if not this:IsValid() then
                    return -1337
                end

                this.fnCreateEffectIndex(this:Get(), pEffectIndex, pEffectData)
            end,

            SetEffectData = function(this, nEffectIndex, nDataIndex, pData, nArg4)
                if not this:IsValid() then
                    return -1337
                end

                this.fnSetEffectData(this:Get(), nEffectIndex, nDataIndex, pData, nArg4)
            end,

            CreateEffect = function(this, pEffectIndex, szName)
                if not this:IsValid() then
                    return -1337
                end

                this.fnCreateEffect2(this:Get(), pEffectIndex, szName, 8, 0, 0, 0, 0)
            end,

            InitEffect = function(this, nEffectIndex, nUnknown, pSnapShotHandle)
                if not this:IsValid() then
                    return false
                end

                return this.fnInitEffect(this:Get(), nEffectIndex, nUnknown, pSnapShotHandle)
            end
        }
    })

    local szBeamMaterial = "particles/entity/spectator_utility_trail.vpcf"
    local function CreateBeamPoint(vecStart, vecEnd, clrColor)
        local pEffectIndex = ffi.new("uint32_t[1]")
        local pBeamColor = ffi.new("struct ZV[1]")
        for nIndex, szKey in pairs({"r", "g", "b"}) do
            pBeamColor[0][szKey] = clrColor[szKey] * 255 or clrColor[nIndex] * 255 or 255
        end

        IParticleManager:Update()
        if (not IParticleManager:IsValid()) then
            return;
        end
        IGameParticleManager:Update()
        if (not IGameParticleManager:IsValid()) then
            return;
        end
        local vecDirection = (vecEnd - vecStart)
        local pEffectData = ffi.new("struct CParticleData[1]")
        local vecLinePointToEnd = vecStart + (vecDirection * 0.5)
        local vecCenterLinePoint = vecStart + (vecDirection * 0.3)
        local pSnapShotHandle = ffi.new("struct CStrongHandle[1]")
        if IGameParticleManager:CreateEffect(pEffectIndex, szBeamMaterial) == -1337 then
            return
        end
        if IGameParticleManager:SetEffectData(pEffectIndex[0], 16, pBeamColor, 0) == -1337 then
            return
        end
        local pParticleInformation = ffi.new("struct CParticleInformation[1]")
        pParticleInformation[0].flUnknown = 1
        pParticleInformation[0].flWidth = 1
        pParticleInformation[0].flTime = 4
        if IGameParticleManager:SetEffectData(pEffectIndex[0], 3, pParticleInformation, 0) == -1337 then
            return
        end
        local vecStepPoints = {vecStart, vecCenterLinePoint, vecLinePointToEnd, vecEnd}
        for nIndex = 1, #vecStepPoints do
            pEffectData[0].flTimes = ffi.new(("float[%i]"):format(nIndex))
            pEffectData[0].vecPositions = ffi.new(("struct Vector[%i]"):format(nIndex))
            for nPointIndex = 1, nIndex do
                pEffectData[0].flTimes[nPointIndex - 1] = 0.015625 * nPointIndex
                for _, szKey in pairs({"x", "y", "z"}) do
                    pEffectData[0].vecPositions[nPointIndex - 1][szKey] = vecStepPoints[nPointIndex][szKey]
                end
            end
            local pUtlStringData = ffi.new("int64_t[1]")
            if anton_vfunc_CreateSnapshot == nil then
                IParticleManager:Update()
                return;
            end
            anton_vfunc_CreateSnapshot(IParticleManager:Get(), pSnapShotHandle, pUtlStringData)
            pEffectData[0].flTimes2 = pEffectData[0].flTimes
            if not IGameParticleManager:InitEffect(pEffectIndex[0], 0, pSnapShotHandle) then
                return;
            end
            if anton_vfunc_Draw == nil then
                IParticleManager:Update()
                return;
            end
            anton_vfunc_Draw(IParticleManager:Get(), pSnapShotHandle, nIndex, pEffectData)
        end
    end

    local m_pGameSceneNode = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_pGameSceneNode");
    local m_pBulletServices = engine.get_netvar_offset("client.dll", "C_CSPlayerPawn", "m_pBulletServices");
    local m_vecAbsOrigin = engine.get_netvar_offset("client.dll", "CGameSceneNode", "m_vecAbsOrigin");
    local m_vecViewOffset = engine.get_netvar_offset("client.dll", "C_BaseModelEntity", "m_vecViewOffset");
    local m_iHealth = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_iHealth");

    local CUtlMemory = (function()
        return function(T, I)
            I = ffi.typeof(I or "int")
            local MT = {}

            local INVALID_INDEX = -1
            function MT:invalid_index()
                return INVALID_INDEX
            end

            function MT:is_idx_valid(i)
                local x = ffi.cast("long", i)
                return x >= 0 and x < self.m_allocation_count
            end

            MT.iterator_t = ffi.metatype(ffi.typeof([[ 
					struct {
						$ index; 
					}
				]], I), {
                __eq = function(self, it)
                    if ffi.istype(self, it) then
                        return self.index == it.index
                    end
                end
            })

            function MT:invalid_iterator()
                return MT.iterator_t(self:invalid_index())
            end

            return ffi.metatype(ffi.typeof([[ 
					struct {
						$* m_memory; 
						int m_allocation_count; 
						int m_grow_size; 
					} 
				]], ffi.typeof(T)), {
                __index = function(self, key)
                    print(tostring("max: " .. tostring(#MT)))
                    print(tostring("access: " .. tostring(key)))
                    print(tostring("self.m_memory: " .. tostring(self.m_allocation_count)))
                    if MT[key] then
                        return MT[key]
                    end
                    if type(key) == "number" then
                        if self:is_idx_valid(key) then
                            return self.m_memory[key]
                        else
                            return nil
                        end
                    end
                    return nil
                end
            })
        end
    end)() -- god bless china
    local anton_1 = ffi.typeof("struct {int m_size; $ m_memory;}", CUtlMemory("bullet_data"));
    local CUtlVector = (function()
        local MT = {}

        function MT:count()
            return self.m_size
        end

        function MT:element(i)
            print(tostring("max: " .. tostring(self.m_size)))
            print(tostring("access: " .. tostring(i)))
            if i > -1 and i < self.m_size then
                return self.m_memory[i]
            else
                return nil
            end
        end

        return function(T, A)
            return ffi.metatype(anton_1, {
                __index = function(self, key)
                    if MT[key] then
                        return MT[key]
                    end
                    if type(key) == "number" then
                        return self:element(key)
                    end
                    return nil
                end,
                __ipairs = function(self)
                    return function(t, i)
                        i = i + 1
                        local v = t[i]
                        if v then
                            return i, v
                        end
                    end, self, -1
                end
            })
        end
    end)() -- qi-ux
    local pBulletData_type = ffi.typeof("$*", CUtlVector("bullet_data"))
    local GetEyePos = function(pLocalPawn)
        local GameSceneNode = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_pGameSceneNode)[0];
        if not GameSceneNode or GameSceneNode == 0 then
            return vec3_t(0, 0, 0)
        end
        local vecAbsOrigin = ffi.cast("struct vec3_t*", ffi.cast("uintptr_t", GameSceneNode) + m_vecAbsOrigin)[0];
        local vecViewOffset = ffi.cast("struct vec3_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_vecViewOffset)[0];

        return vec3_t(vecAbsOrigin.x + vecViewOffset.x, vecAbsOrigin.y + vecViewOffset.y,
            vecAbsOrigin.z + vecViewOffset.z);
    end;
    local last_count_bullet = 0;

    local fnOnPaint = function()
        local pLocalPawn = entitylist.get_local_player_pawn()
        if not pLocalPawn or pLocalPawn == 0 or ffi.cast("int*", pLocalPawn[m_iHealth])[0] <= 0 then
            return
        end

        local vecEyePosition = GetEyePos(pLocalPawn)
        local pBulletServices = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_pBulletServices)[0]
        if not pBulletServices or pBulletServices == 0 then
            return
        end

        -- local pBulletData_type = ffi.typeof("$*", CUtlVector("bullet_data"))
        if not pBulletData_type then
            return
        end
        local pBulletData = ffi.cast(pBulletData_type, ffi.cast("uintptr_t", pBulletServices) + 0x48)[0]
        if not pBulletData then
            return
        end

        local maxIterations = 100
        for i = math.min(pBulletData:count(), last_count_bullet + maxIterations), last_count_bullet + 1, -1 do
            local element = pBulletData:element(i - 1)
            if element and element.position then
                CreateBeamPoint(vecEyePosition, vec3_t(element.position.x, element.position.y, element.position.z),
                    COLOR_RIGHT_HERE)
            else
                print("😪 >> " .. tostring(i - 1))
            end
        end

        if pBulletData:count() ~= last_count_bullet then
            last_count_bullet = pBulletData:count()
        end
        goto zoov_
        last_count_bullet = 0;
        ::zoov_::
    end
    register_callback("paint", fnOnPaint)
    local arrHooks = {}
    local arrThreads = {}
    local NULLPTR = ffi.cast("void*", 0);
    local INVALID_HANDLE = ffi.cast("void*", -1);
    local fnRadarEntities = Abs(ffi.cast("uintptr_t", find_pattern("client.dll",
        "E8 ? ? ? ? 48 8B CE E8 ? ? ? ? 48 8B 9E ? ? ? ? 48 63 86 ? ? ? ?")), 0x1, 0x0);
    local function Thread(nTheardID)
        local hThread = ffi.C.OpenThread(0x0002, 0, nTheardID)
        if hThread == NULLPTR or hThread == INVALID_HANDLE then
            return false
        end

        return setmetatable({
            bValid = true,
            nId = nTheardID,
            hThread = hThread,
            bIsSuspended = false
        }, {
            __index = {
                Suspend = function(self)
                    if self.bIsSuspended or not self.bValid then
                        return false
                    end

                    if ffi.C.SuspendThread(self.hThread) ~= -1 then
                        self.bIsSuspended = true
                        return true
                    end

                    return false
                end,

                Resume = function(self)
                    if not self.bIsSuspended or not self.bValid then
                        return false
                    end

                    if ffi.C.ResumeThread(self.hThread) ~= -1 then
                        self.bIsSuspended = false
                        return true
                    end

                    return false
                end,

                Close = function(self)
                    if not self.bValid then
                        return
                    end

                    self:Resume()
                    self.bValid = false
                    ffi.C.CloseHandle(self.hThread)
                end
            }
        })
    end

    local function UpdateThreadList()
        arrThreads = {}
        local hSnapShot = ffi.C.CreateToolhelp32Snapshot(0x00000004, 0)
        if hSnapShot == INVALID_HANDLE then
            return false
        end

        local pThreadEntry = ffi.new("struct Thread32Entry[1]")
        pThreadEntry[0].dwSize = ffi.sizeof("struct Thread32Entry")
        if ffi.C.Thread32First(hSnapShot, pThreadEntry) == 0 then
            ffi.C.CloseHandle(hSnapShot)
            return false
        end

        local nCurrentThreadID = ffi.C.GetCurrentThreadId()
        local nCurrentProcessID = ffi.C.GetCurrentProcessId()
        while ffi.C.Thread32Next(hSnapShot, pThreadEntry) > 0 do
            if pThreadEntry[0].dwSize >= 20 and pThreadEntry[0].th32OwnerProcessID == nCurrentProcessID and
                pThreadEntry[0].th32ThreadID ~= nCurrentThreadID then
                local hThread = Thread(pThreadEntry[0].th32ThreadID)
                if not hThread then
                    for _, pThread in pairs(arrThreads) do
                        pThread:Close()
                    end

                    arrThreads = {}
                    ffi.C.CloseHandle(hSnapShot)
                    return false
                end

                table.insert(arrThreads, hThread)
            end
        end

        ffi.C.CloseHandle(hSnapShot)
        return true
    end

    local function SuspendThreads()
        if not UpdateThreadList() then
            return false
        end

        for _, hThread in pairs(arrThreads) do
            hThread:Suspend()
        end

        return true
    end

    local function ResumeThreads()
        for _, hThread in pairs(arrThreads) do
            hThread:Resume()
            hThread:Close()
        end
    end

    local function CreateHook(pTarget, pDetour, szType)
        assert(type(pDetour) == "function", "syr1337 hooking lib error: invalid detour function")
        assert(type(pTarget) == "cdata" or type(pTarget) == "number" or type(pTarget) == "function",
            "syr1337 hooking lib error: invalid target function")
        if not SuspendThreads() then
            ResumeThreads()
            print("syr1337 hooking lib error: failed suspend threads")
            return false
        end

        local arrBackUp = ffi.new("uint8_t[14]")
        local pTargetFn = ffi.cast(szType, pTarget)
        local arrShellCode = ffi.new("uint8_t[14]", {0xFF, 0x25, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                                     0x00, 0x00, 0x00})

        local __Object = {
            bValid = true,
            bAttached = false,
            pBackup = arrBackUp,
            pTarget = pTargetFn,
            pOldProtect = ffi.new("uint32_t[1]")
        }

        ffi.copy(arrBackUp, pTargetFn, ffi.sizeof(arrBackUp))
        ffi.cast("uintptr_t*", arrShellCode + 0x6)[0] = ffi.cast("uintptr_t", ffi.cast(szType, function(...)
            local bSuccessfully, pResult = pcall(pDetour, __Object, ...)
            if not bSuccessfully then
                __Object:Remove()
                print(("[syr1337 hooking lib]: unexception runtime error -> %s"):format(pResult))
                return pTargetFn(...)
            end

            return pResult
        end))

        __Object.__index = setmetatable(__Object, {
            __call = function(self, ...)
                if not self.bValid then
                    return nil
                end

                self:Detach()
                local bSuccessfully, pResult = pcall(self.pTarget, ...)
                if not bSuccessfully then
                    self.bValid = false
                    print(("[syr1337 hooking lib]: runtime error -> %s"):format(pResult))
                    return nil
                end

                self:Attach()
                return pResult
            end,

            __index = {
                Attach = function(self)
                    if self.bAttached or not self.bValid then
                        return false
                    end

                    self.bAttached = true
                    ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), 0x40, self.pOldProtect)
                    ffi.copy(self.pTarget, arrShellCode, ffi.sizeof(arrBackUp))
                    ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), self.pOldProtect[0], self.pOldProtect)
                    return true
                end,

                Detach = function(self)
                    if not self.bAttached or not self.bValid then
                        return false
                    end

                    self.bAttached = false
                    ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), 0x40, self.pOldProtect)
                    ffi.copy(self.pTarget, self.pBackup, ffi.sizeof(arrBackUp))
                    ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), self.pOldProtect[0], self.pOldProtect)
                    return true
                end,

                Remove = function(self)
                    if not self.bValid then
                        return false
                    end

                    SuspendThreads()
                    self:Detach()
                    ResumeThreads()
                    self.bValid = false
                end
            }
        })

        __Object:Attach()
        table.insert(arrHooks, __Object)
        ResumeThreads()
        return __Object
    end

    CreateHook(fnRadarEntities, function(pObject, pRcx)
        ffi.cast("uint8_t*", ffi.cast("uintptr_t", pRcx) + 0x12D08)[0] = 1;
        return pObject(pRcx)
    end, "void(__fastcall*)(void*)")

    register_callback("unload", function()
        for _, pObject in pairs(arrHooks) do
            pObject:Remove()
        end
    end)
end, function(...)
    print(("[syr1337 hooking lib]: initialize error -> %s"):format(...))

end, print)

register_callback("player_hurt", onDamageHitLogs)
register_callback("paint", fnOnPaint)