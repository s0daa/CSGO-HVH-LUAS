-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

-- make: SYR1337
xpcall(function()
    assert(ffi, "ffi is unavailable")
    if not pcall(ffi.sizeof, "struct CGameTrace") then
        ffi.cdef([[
            typedef struct Vector {
                float x, y, z;
            } Vector;
        
            typedef struct CTraceRay {
                struct Vector vecStart;
                struct Vector vecEnd;
                struct Vector vecMins;
                struct Vector vecMaxs;
                char pad_01[0x5];
            } CTraceRay;

            typedef struct CTraceFilter {
                char pad_01[0x8];
                int64_t nTraceMask;
                int64_t arrUnknown[2];
                int32_t arrSkipHandles[4];
                int16_t arrCollisions[2];
                int16_t nUnknown2;
                uint8_t nUnknown3;
                uint8_t nUnknown4;
                uint8_t nUnknown5;
            } CTraceFilter;
        
            typedef struct Thread32Entry {
                uint32_t dwSize;
                uint32_t cntUsage;
                uint32_t th32ThreadID;
                uint32_t th32OwnerProcessID;
                long tpBasePri;
                long tpDeltaPri;
                uint32_t dwFlags;
            } Thread32Entry;
            
            typedef struct CViewSetup {
                char pad_01[0x494];
                float flOrthoLeft;
                float flOrthoTop;
                float flOrthoRight;
                float flOrthoBottom;
                char pad_02[0x34];
                float flFov;
                float flFovViewmodel;
                struct Vector origin;
                char pad_03[0xC];
                struct Vector angles;
                char pad_04[0x14];
                float flAspectRatio;
                char pad_05[0x71];
                uint8_t nFlags;
            } CViewSetup;

            typedef struct CViewRender {
                char pad_01[0x10];
                struct CViewSetup View;
            } CViewRender;

            typedef struct CGameTrace {
                void* pSurface;
                void* pHitEntity;
                void* pHitboxData;
                char pad_01[0x38];
                uint32_t nContents;
                char pad_02[0x24];
                struct Vector vecStart;
                struct Vector vecEnd;
                struct Vector vecNormal;
                struct Vector vecPosition;
                char pad_03[0x4];
                float flFraction;
                char pad_04[0x6];
                bool bStartSolid;
                char pad_05[0x4D];
            } CGameTrace;

            int CloseHandle(void*);
            void* GetCurrentProcess();
            uint32_t ResumeThread(void*);
            uint32_t GetCurrentThreadId();
            uint32_t SuspendThread(void*);
            uint32_t GetCurrentProcessId();
            void* GetModuleHandleA(const char*);
            void* GetProcAddress(void*, const char*);
            void* OpenThread(uint32_t, int, uint32_t);
            int Thread32Next(void*, struct Thread32Entry*);
            int Thread32First(void*, struct Thread32Entry*);
            int FlushInstructionCache(void*, void*, uint64_t);
            void* CreateToolhelp32Snapshot(uint32_t, uint32_t);
            int VirtualProtect(void*, uint64_t, uint32_t, uint32_t*);
        ]])
    end

    local arrHooks = {}
    local bSetup = false
    local arrThreads = {}
    local flBackupAspectRatio = 0
    local bStoredAspectRatio = false
    local bStoredViewModelScale = false
    local NULLPTR = ffi.cast("void*", 0)
    local vecCameraPosition = vec3_t(0, 0, 0)
    local INVALID_HANDLE = ffi.cast("void*", - 1)

    ------------------------------ settings ------------------------------
    -- ↓ Smooth Camera
    local bSmoothCamera = false -- enable: change to "true"
    local nCameraSlack = 40 -- you camera move speed -- (1 - 100)
    local nCameraVertical = 30 -- you camera vertical offset -- (- 50 - 50)
    local nCameraDistance = 90 -- you camera backward distance -- (32 - 200)
    local nCameraHorizontal = 0 -- you camera horizontal offset -- (- 30 - 30)

    -- ↓ Remove Viewmodel Shake
    local bRemoveViewModelShake = false -- enable: change to "true", this will be remove your hans shake animate

    -- ↓ Custom Viewmodel Offset | Model Scale
    local bCustomViewModel = false -- enable: change to "true", this allow your custom viewmodel x, y, z offset
    local nViewModelX = 10 -- your want custom viewmodel x offset -- (- 400 - 400)
    local nViewModelY = 10 -- your want custom viewmodel y offset -- (- 400 - 400)
    local nViewModelZ = - 10 -- your want custom viewmodel z offset -- (- 400 - 400)
    local flViewModelScale = 1 -- your want custom viewmodel model scale -- (0 - 1)

    ------------------------------ settings ------------------------------

    local arrSchema = {
        nHeatlh = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_iHealth"),
        flScale = engine.get_netvar_offset("client.dll", "CGameSceneNode", "m_flScale"),
        nLifeState = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_lifeState"),
        vecAbsOrigin = engine.get_netvar_offset("client.dll", "CGameSceneNode", "m_vecAbsOrigin"),
        pGameSceneNode = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_pGameSceneNode"),
        vecViewOffset = engine.get_netvar_offset("client.dll", "C_BaseModelEntity", "m_vecViewOffset"),
        hViewModel = engine.get_netvar_offset("client.dll", "CCSPlayer_ViewModelServices", "m_hViewModel"),
        pViewModelServices = engine.get_netvar_offset("client.dll", "C_CSPlayerPawnBase", "m_pViewModelServices")
    }

    local function FindSignature(szModule, szPattern)
        local pBase = find_pattern(szModule, szPattern)
        if ffi.cast("void*", pBase) == NULLPTR then
            return nil
        end

        return ffi.cast("uintptr_t", pBase)
    end

    local fnCalcViewModelShake = assert(FindSignature("client.dll", "40 55 53 41 55 41 56 41 57 48 8D 6C 24 C9"), "custom viewmodel error: outdated signature")
    local fnOverrideView = assert(FindSignature("client.dll", "48 89 5C 24 ?? 48 89 6C 24 ?? 48 89 74 24 ?? 57 41 56 41 57 48 83 EC ?? 48 8B FA E8"), "custom viewmodel error: outdated signature")
    -- local fnGetViewModel = assert(FindSignature("client.dll", "48 89 5C 24 10 48 89 74 24 18 55 57 41 54 41 56 41 57 48 8B EC 48 83 EC 20 4D 8B E0 48 8B FA"), "custom viewmodel error: outdated signature") -- this is original signature
    local fnGetViewModel = assert(FindSignature("client.dll", "E9 ?? ?? ?? ?? 48 89 74 24 18 55 57 41 54 41 56 41 57 48 8B"), "custom viewmodel error: outdated signature") -- this is nixware hook signature
    -- fnGetViewModel: Hook By Nixware, Relative Jmp 0xE9
    local fnGetViewAngles = ffi.cast("struct Vector*(__fastcall*)(void*, int)", assert(FindSignature("client.dll", "4C 8B C1 85 D2 74 08 48 8D 05 ?? ?? ?? ?? C3"), "custom viewmodel error: outdated signature"))
    local fnGetClientEntity = ffi.cast("void*(__fastcall*)(void*, int)", assert(FindSignature("client.dll", "81 FA ?? ?? ?? ?? 77 36 8B C2 C1 F8 09 83 F8 3F 77 2C 48 98"), "custom viewmodel error: outdated signature"))
    local fnCreateFilter = ffi.cast("void(__fastcall*)(struct CTraceFilter&, void*, uint64_t, uint8_t, uint16_t)", assert(FindSignature("client.dll", "48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 20 0F B6 41 37 33"), "custom viewmodel error: outdated signature"))
    local fnTraceShape = ffi.cast("bool(__fastcall*)(void*, struct CTraceRay*, struct Vector*, struct Vector*, struct CTraceFilter*, struct CGameTrace*)", assert(FindSignature("client.dll", "48 89 5C 24 20 48 89 4C 24 08 55 56 41 55 41 56"), "custom viewmodel error: invalidate signature"))
    local pUnknownInstance = (function()
        -- #xref "tracer_player.vpcf"
        local pInstance = assert(FindSignature("client.dll", "48 8B 0D ?? ?? ?? ?? 8B D3 E8 ?? ?? ?? ?? 44 8B 86 48 12"), "custom viewmodel error: outdated signature")
        return ffi.cast("void**", pInstance + 7 + ffi.cast("int*", pInstance + 3)[0])[0]
    end)()

    local IViewRender = (function()
        -- #xref "CSGOFrameUpdate" "CancelConnectToServer"
        local pViewRender = assert(FindSignature("client.dll", "48 8D 0D ?? ?? ?? ?? E8 ?? ?? ?? ?? 48 8D 0D ?? ?? ?? 01 48 83 C4 28 E9 ?? ?? ?? ?? 48 8D 0D ?? ?? ?? ?? E9 E8"), "custom viewmodel error: outdated signature")
        return ffi.cast("struct CViewRender*", pViewRender + 7 + ffi.cast("int*", pViewRender + 3)[0])
    end)()

    local IEngineTrace = (function()
        -- #xref "const CTraceFilter::`vftable'"
        local pEngineTrace = assert(FindSignature("client.dll", "48 8B 0D ?? ?? ?? ?? 4C 8B C3 66 89 44 24"), "custom viewmodel error: outdated signature")
        return ffi.cast("void**", pEngineTrace + 7 + ffi.cast("int*", pEngineTrace + 3)[0])[0]
    end)()

    local IGameEntitySystem = (function()
        local IGameResourceServiceClient = ffi.cast("void*(*)(const char*, void*)",
            ffi.C.GetProcAddress(ffi.C.GetModuleHandleA("engine2.dll"), "CreateInterface")
        )("GameResourceServiceClientV001", nil)
        assert(IGameResourceServiceClient ~= ffi.NULL, "custom viewmodel error: outdated signature")
        return ffi.cast("void**", ffi.cast("uintptr_t", IGameResourceServiceClient) + 0x58)[0]
    end)()

    local function DegToRad(flDegree)
        return flDegree * math.pi / 180
    end

    local function Forward(vecAngles)
        local vecSin = vec3_t(math.sin(DegToRad(vecAngles.x)), math.sin(DegToRad(vecAngles.y)), 0)
        local vecCos = vec3_t(math.cos(DegToRad(vecAngles.x)), math.cos(DegToRad(vecAngles.y)), 0)
        return vec3_t(vecCos.x * vecCos.y, vecCos.x * vecSin.y, - vecSin.x)
    end

    local function Right(vecAngles)
        local vecSin = vec3_t(math.sin(DegToRad(vecAngles.x)), math.sin(DegToRad(vecAngles.y)), math.sin(DegToRad(vecAngles.z)))
        local vecCos = vec3_t(math.cos(DegToRad(vecAngles.x)), math.cos(DegToRad(vecAngles.y)), math.cos(DegToRad(vecAngles.z)))
        return vec3_t(vecSin.z * vecSin.x * vecCos.y * - 1 + vecCos.z * vecSin.y, vecSin.z * vecSin.x * vecSin.y * - 1 + - 1 * vecCos.z * vecCos.y, - 1 * vecSin.z * vecCos.x)
    end

    local function Up(vecAngles)
        local vecSin = vec3_t(math.sin(DegToRad(vecAngles.x)), math.sin(DegToRad(vecAngles.y)), math.sin(DegToRad(vecAngles.z)))
        local vecCos = vec3_t(math.cos(DegToRad(vecAngles.x)), math.cos(DegToRad(vecAngles.y)), math.cos(DegToRad(vecAngles.z)))
        return vec3_t(vecCos.z * vecSin.x * vecCos.y + vecSin.z * vecSin.y, vecCos.z * vecSin.x * vecSin.y + vecSin.z * vecCos.y * - 1, vecCos.z * vecCos.x)
    end

    local function GetViewAngles()
        local vecViewAngles = fnGetViewAngles(pUnknownInstance, 0)
        return vec3_t(vecViewAngles.x, vecViewAngles.y, vecViewAngles.z)
    end

    local function GetField(pEntity, szName, szType)
        if not pEntity or pEntity == NULLPTR then
            return false
        end

        if not arrSchema[szName] then
            return false
        end

        return ffi.cast(("%s*"):format(szType), ffi.cast("uintptr_t", pEntity) + arrSchema[szName])[0]
    end

    local function SetField(pEntity, szName, szType, pValue)
        if not pEntity or pEntity == NULLPTR then
            return false
        end

        if not arrSchema[szName] then
            return false
        end

        ffi.cast(("%s*"):format(szType), ffi.cast("uintptr_t", pEntity) + arrSchema[szName])[0] = pValue
    end

    local function IsAlive(pEntity)
        if not pEntity or pEntity == NULLPTR then
            return false
        end

        local nHealth = GetField(pEntity, "nHeatlh", "int")
        local nLifeState = GetField(pEntity, "nLifeState", "uint8_t")
        return nLifeState == 0 and nHealth > 0
    end

    local function GetEyePosition(pEntity)
        if not pEntity or pEntity == NULLPTR then
            return false
        end

        local pGameSceneNode = GetField(pEntity, "pGameSceneNode", "uintptr_t")
        if pGameSceneNode == 0 then
            return false
        end

        local vecViewOffset = GetField(pEntity, "vecViewOffset", "struct Vector")
        local vecAbsOrigin = GetField(pGameSceneNode, "vecAbsOrigin", "struct Vector")
        if not vecAbsOrigin or not vecViewOffset then
            return false
        end

        return vec3_t(vecAbsOrigin.x + vecViewOffset.x, vecAbsOrigin.y + vecViewOffset.y, vecAbsOrigin.z + vecViewOffset.z)
    end

    local function TraceShape(vecStart, vecEnd, pSkip)
        local vecFrom = ffi.new("struct Vector[1]")
        local vecFinal = ffi.new("struct Vector[1]")
        local pTraceRay = ffi.new("struct CTraceRay[1]")
        local pFilter = ffi.new("struct CTraceFilter[1]")
        local pGameTrace = ffi.cast("struct CGameTrace*", ffi.new("struct CGameTrace[1]"))
        fnCreateFilter(pFilter[0], pSkip, 0x1C3003, 4, 7)
        for _, szKey in pairs({ "x", "y", "z" }) do
            vecFinal[0][szKey] = vecEnd[szKey]
            vecFrom[0][szKey] = vecStart[szKey]
        end

        fnTraceShape(IEngineTrace, pTraceRay, vecFrom, vecFinal, pFilter, pGameTrace)
        return pGameTrace
    end

    local function GetBaseHandle(pEntity)
        if pEntity == NULLPTR then
            return nil
        end

        local pIdentity = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", pEntity) + 0x10)[0]
        if pIdentity < 0x1000 or pIdentity > 0x7FFFFFFEFFFF then
            return nil
        end

        local nIndex = ffi.cast("uint32_t*", pIdentity + 0x10)[0]
        local nFlags = ffi.cast("uint32_t*", pIdentity + 0x30)[0]
        return bit.bor(bit.band(nIndex, 0x7FFF), bit.lshift(bit.rshift(nIndex, 15) - bit.band(nFlags, 1), 15))
    end

    local function TraceLine(vecSource, vecDestination, pSkip, szSkipClasses)
        local pTrace = TraceShape(vecSource, vecDestination, pSkip)
        while pTrace.flFraction < 1 and pTrace.pHitEntity ~= NULLPTR and szSkipClasses do
            local hEntity = GetBaseHandle(pTrace.pHitEntity)
            if not hEntity then
                break
            end

            local pEntity = entitylist.get_entity_from_handle(hEntity)
            if not pEntity then
                break
            end

            if pEntity:get_class_name() ~= szSkipClasses then
                break
            end

            pTrace = TraceShape(pTrace.vecEnd, vecDestination, pEntity[0])
        end

        local vecEnd = vec3_t(pTrace.vecEnd.x, pTrace.vecEnd.y, pTrace.vecEnd.z)
        return (vecEnd - vecSource):length() / (vecDestination - vecSource):length()
    end

    local function SetViewModelScale(flScale)
        local pLocalPlayer = entitylist.get_local_player_pawn()
        if not pLocalPlayer or not IsAlive(pLocalPlayer[0]) then
            return
        end

        local nEntIndex = bit.band(GetBaseHandle(pLocalPlayer[0]), 0x7FFF)
        local pLocalEntity = fnGetClientEntity(IGameEntitySystem, nEntIndex)
        if pLocalEntity == NULLPTR then
            return
        end

        local pViewModelServices = GetField(pLocalPlayer[0], "pViewModelServices", "uintptr_t")
        if pViewModelServices == 0 then
            return
        end

        local hViewModel = GetField(pViewModelServices, "hViewModel", "uint32_t")
        if hViewModel == 0xFFFFFFFF then
            return
        end

        local pViewModel = fnGetClientEntity(IGameEntitySystem, bit.band(hViewModel, 0x7FFF))
        if pViewModel == NULLPTR then
            return
        end

        local pGameSceneNode = GetField(pViewModel, "pGameSceneNode", "uintptr_t")
        if pGameSceneNode == 0 then
            return
        end

        SetField(pGameSceneNode, "flScale", "float", flScale)
    end

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

                    if ffi.C.SuspendThread(self.hThread) ~= - 1 then
                        self.bIsSuspended = true
                        return true
                    end

                    return false
                end,

                Resume = function(self)
                    if not self.bIsSuspended or not self.bValid then
                        return false
                    end

                    if ffi.C.ResumeThread(self.hThread) ~= - 1 then
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
            if pThreadEntry[0].dwSize >= 20 and pThreadEntry[0].th32OwnerProcessID == nCurrentProcessID and pThreadEntry[0].th32ThreadID ~= nCurrentThreadID then
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
        assert(type(pDetour) == "function", "custom viewmodel error: invalid detour function")
        assert(type(pTarget) == "cdata" or type(pTarget) == "userdata" or type(pTarget) == "number" or type(pTarget) == "function", "custom viewmodel error: invalid target function")
        if not SuspendThreads() then
            ResumeThreads()
            print("custom viewmodel error: failed suspend threads")
            return false
        end

        local arrBackUp = ffi.new("uint8_t[14]")
        local pTargetFn = ffi.cast(szType, pTarget)
        local arrShellCode = ffi.new("uint8_t[14]", {
            0xFF, 0x25, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        })

        local __Object = {
            bValid = true,
            bAttached = false,
            pBackup = arrBackUp,
            pTarget = pTargetFn,
            pOldProtect = ffi.new("uint32_t[1]"),
            hCurrentProcess = ffi.C.GetCurrentProcess()
        }

        ffi.copy(arrBackUp, pTargetFn, ffi.sizeof(arrBackUp))
        ffi.cast("uintptr_t*", arrShellCode + 0x6)[0] = ffi.cast("uintptr_t", ffi.cast(szType, function(...)
            local bSuccessfully, pResult = pcall(pDetour, __Object, ...)
            if not bSuccessfully then
                __Object:Remove()
                print(("[Custom Viewmodel]: unexception runtime error -> %s"):format(pResult))
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
                    print(("[Custom Viewmodel]: runtime error -> %s"):format(pResult))
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
                    -- ffi.C.FlushInstructionCache(self.hCurrentProcess, self.pTarget, ffi.sizeof(arrBackUp))
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
                    -- ffi.C.FlushInstructionCache(self.hCurrentProcess, self.pTarget, ffi.sizeof(arrBackUp))
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

    CreateHook(fnCalcViewModelShake, function(pObject, pRcx, pArg2, pArg3, pArg4)
        if bRemoveViewModelShake then
            return
        end

        return pObject(pRcx, pArg2, pArg3, pArg4)
    end, "void(__fastcall*)(void*, void*, void*, void*)")

    CreateHook(fnOverrideView, function(pObject, pClientMode, pViewSetup)
        local pResult = pObject(pClientMode, pViewSetup)
        if bSmoothCamera then
            pViewSetup.origin.x = vecCameraPosition.x
            pViewSetup.origin.y = vecCameraPosition.y
            pViewSetup.origin.z = vecCameraPosition.z
        end

        return pResult
    end, "void*(__fastcall*)(void*, struct CViewSetup*)")

    CreateHook(fnGetViewModel, function(pObject, pRcx, vecOffset, pFov)
        pObject(pRcx, vecOffset, pFov)
        if bCustomViewModel then
            bStoredViewModelScale = true
            vecOffset[0] = nViewModelX / 10
            vecOffset[1] = nViewModelY / 10
            vecOffset[2] = nViewModelZ / 10
            SetViewModelScale(flViewModelScale)
        elseif bStoredViewModelScale then
            SetViewModelScale(1)
            bStoredViewModelScale = false
        end

    end, "void(__fastcall*)(void*, float*, float*)")

    register_callback("paint", function()
        local pLocalPlayer = entitylist.get_local_player_pawn()
        if not pLocalPlayer or not IsAlive(pLocalPlayer[0]) or not bSmoothCamera then
            bSetup = false
            return
        end

        local flSlack = nCameraSlack
        local flDistance = nCameraDistance
        local flVerticalOffset = nCameraVertical
        local flHorizontalOffset = nCameraHorizontal

        local vecCameraAnlges = GetViewAngles()
        local vecEyePosition = GetEyePosition(pLocalPlayer[0])
        if not vecEyePosition then
            return
        end

        local vecForward, vecRight, vecUp = Forward(vecCameraAnlges), Right(vecCameraAnlges), Up(vecCameraAnlges)
        local vecDelta = ((vec3_t(- vecForward.x, - vecForward.y, - vecForward.z)) * flDistance) + (vecRight * flHorizontalOffset) + (vecUp * flVerticalOffset)
        if not bSetup then
            bSetup = true
            vecCameraPosition = vecEyePosition
        end

        local flFraction = TraceLine(vecEyePosition, vecEyePosition + vecDelta, pLocalPlayer[0], "C_CSPlayerPawn")
        vecCameraPosition = vecCameraPosition + ((vecEyePosition + vecDelta * (flFraction * 0.8)) - vecCameraPosition) * (flSlack * 0.001)
    end)

    register_callback("unload", function()
        SetViewModelScale(1)
        for _, pObject in pairs(arrHooks) do
            pObject:Remove()
        end

        if bStoredAspectRatio then
            IViewRender.View.flAspectRatio = flBackupAspectRatio
            IViewRender.View.nFlags = bit.bor(IViewRender.View.nFlags, 2)
        end
    end)

end, function(...)
    print(("[Custom Viewmodel]: initialize error -> %s"):format(...))
end)