-- i think this might be the first aa-lua in the community, make: SYR1337
-- build: 2024.10.30
-- update: 2024.10.31
-- add: edge yaw
-- add: freestanding yaw
-- fix: manual indicator crash
-- add: gamesense style manual antiaim

-- update: 2024.11.2
-- fix aimbot backtrack

assert(ffi, "ffi is unavailable")
ffi.cdef([[
    typedef struct Thread32Entry {
        uint32_t dwSize;
        uint32_t cntUsage;
        uint32_t th32ThreadID;
        uint32_t th32OwnerProcessID;
        long tpBasePri;
        long tpDeltaPri;
        uint32_t dwFlags;
    } Thread32Entry;

    typedef struct Color {
        uint8_t r, g, b, a;
    } Color;

    typedef struct Vector2D {
        float x, y;
    } Vector2D;

    typedef struct Vector {
        float x, y, z;
    } Vector;

    typedef struct Vector4D {
        float x, y, z, w;
    } Vector4D;

    typedef struct RepeatedPtrField {
        void* pArena;
        int nCurrentSize;
        int nTotalSize;
	    void* pRep;
    } RepeatedPtrField;

    typedef struct CMsgVector {
        char pad_0x0[0x8];
        uint32_t nHasBits;
        uint64_t nCachedBits;
        Vector vecValue;
    } CMsgVector;

    typedef struct CInButtonStatePB {
        char pad_0x0[0x8];
        uint32_t nHasBits;
        uint64_t nCachedBits;
        uint64_t nValue;
        uint64_t nValueChanged;
        uint64_t nValueScroll;
    } CInButtonStatePB;

    typedef struct CInButtonState {
        char pad_0x0[0x8];
        uint64_t nValue;
        uint64_t nValueChanged;
        uint64_t nValueScroll;
    } CInButtonState;

    typedef struct CBaseUserCmdPB {
        char pad_0x0[0x8];
        uint32_t nHasBits;
        uint64_t nCachedBits;
        RepeatedPtrField subtickMovesField;
        const char* strMoveCrc;
        CInButtonStatePB* pInButtonState;
        CMsgVector* pViewAngles;
        int32_t nLegacyCommandNumber;
        int32_t nClientTick;
        float flForwardMove;
        float flSideMove;
        float flUpMove;
        int32_t nImpulse;
        int32_t nWeaponSelect;
        int32_t nRandomSeed;
        int32_t nMousedX;
        int32_t nMousedY;
        uint32_t nConsumedServerAngleChanges;
        int32_t nCmdFlags;
        uint32_t nPawnEntityHandle;
    } CBaseUserCmdPB;

    typedef struct CUserCmd {
        char pad_0x0[0x18];
        uint32_t nHasBits;
        uint64_t nCachedBits;
        RepeatedPtrField inputHistoryField;
        CBaseUserCmdPB* pBaseCmd;
        bool bLeftHandDesired;
        bool bIsPredictingBodyShotFX;
        bool bIsPredictingHeadShotFX;
        bool bIsPredictingKillRagdolls;
        int32_t nAttack3StartHistoryIndex;
        int32_t nAttack1StartHistoryIndex;
        int32_t nAttack2StartHistoryIndex;
        CInButtonState nButtons;
        char pad_0x58[0x20];
    } CUserCmd;

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
            
    typedef struct CConVar {
        const char* szName;
        struct CConVar* pNext;
        char pad_01[0x10];
        const char* szDescription;
        uint32_t nType;
        uint32_t nRegistered;
        uint32_t nFlags;
        uint32_t m_unk3;
        uint32_t m_nCallbacks;
        uint32_t m_unk4;
        union {
            bool Bool;
            short Int16;
            uint16_t Uint16;
            int Int;
            uint32_t Uint32;
            int64_t Int64;
            uint64_t Uint64;
            float Float;
            double Double;
            const char* String;
            struct Color Color;
            struct Vector2D Vector2D;
            struct Vector Vector3D;
            struct Vector4D Vector4D;
            struct Vector Angles;
        } Value;

        union {
            bool Bool;
            short Int16;
            uint16_t Uint16;
            int Int;
            uint32_t Uint32;
            int64_t Int64;
            uint64_t Uint64;
            float Float;
            double Double;
            const char* String;
            struct Color Color;
            struct Vector2D Vector2D;
            struct Vector Vector3D;
            struct Vector4D Vector4D;
            struct Vector Angles;
        } OldValue;
    } CConVar;
        
    typedef struct CUtlLinkedListElement {
        struct CConVar* element;
        uint16_t iPrevious;
        uint16_t iNext;
    } CUtlLinkedListElement;

    typedef struct CUtlMemory {
        struct CUtlLinkedListElement* pMemory;
        int nAllocationCount;
        int nGrowSize;
    } CUtlMemory;
        
    typedef struct CUtlLinkedList {
        struct CUtlMemory memory;
        uint16_t iHead;
        uint16_t iTail;
        uint16_t iFirstFree;
        uint16_t nElementCount;
        uint16_t nAllocated;
        struct CUtlLinkedListElement* pElements;
    } CUtlLinkedList;

    typedef struct IEngineCvar {
        char pad_01[0x40];
        struct CUtlLinkedList listCvars;
    } IEngineCvar;

    int CloseHandle(void*);
    void* GetActiveWindow();
    void* GetCurrentProcess();
    uint32_t ResumeThread(void*);
    uint32_t GetCurrentThreadId();
    uint32_t SuspendThread(void*);
    uint32_t GetCurrentProcessId();
    void* GetModuleHandleA(const char*);
    void* GetProcAddress(void*, const char*);
    void* OpenThread(uint32_t, int, uint32_t);
    void* SetWindowLongPtrW(void*, int, void*);
    int Thread32Next(void*, struct Thread32Entry*);
    int Thread32First(void*, struct Thread32Entry*);
    int FlushInstructionCache(void*, void*, uint64_t);
    void* CreateToolhelp32Snapshot(uint32_t, uint32_t);
    uint32_t GetModuleFileNameA(void*, char*, uint32_t);
    typedef void*(*fnCreateInterface)(const char*, void*);
    int VirtualProtect(void*, uint64_t, uint32_t, uint32_t*);
    int64_t CallWindowProcW(void*, void*, uint32_t, uint64_t, int64_t);
]])

local arrHooks = {}
local arrThreads = {}
local arrConvars = {}
local nManualSide = 0
local pRenderFont = nil
local bYawJitter = false
local arrVirtualKeys = {}
local flYawJitterTick = 0
local bJitterPitch = false
local nPitchJitterTick = 0
local flYawJitterOffset = 0
local bControlManual = false
local flControlManualYaw = 0
local arrVirtualKeyPress = {}
local arrVirtualKeyRelease = {}
local flControlManualYawUpdate = 0
local arrVirtualKeyResetPress = {}
local arrVirtualKeyResetRelease = {}
local NULLPTR = ffi.cast("void*", 0)
local vecPrevCameraAngles = vec3_t(0, 0, 0)
local INVALID_HANDLE = ffi.cast("void*", - 1)
local pOriginalWndProc = ffi.cast("void*", 0)
local arrManualStatus = {
    bLeft = false,
    bRight = false,
    bBackWard = false
}

-- ps: this All Lua AntiAim Settings, your can used with nixware AntiAim
local arrSettings = {
    -- KeyBind Settings
    -- your can find virtual keys in: "https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes"
    nLeftKey = 0x5A, -- Microsoft Virtual Key: Z
    nRightKey = 0x43, -- Microsoft Virtual Key: C
    nBackwardKey = 0x58, -- Microsoft Virtual Key: X
    nMouseControlKey = 0x05, -- Microsoft Virtual Key: M2, your mouse control manual yaw direct key

    -- AntiAim Settings
    nPitchMode = 0, -- 0 = Off, 1 = Up, 2 = Down, 3 = Random, 4 = Jitter
    bEnabled = true, -- Lua Anti-Aim Global Switch
    nManualStyle = 1, -- 0 = Default (Z, X, C), 1 = Gamesense Style (Mouse Control)
    bEdgeYaw = false, -- if true, will enable edge yaw
    flEdgeYawStep = 10, -- edge yaw scan yaw step
    nYawJitterMode = 0, -- 0 = Off, 1 = Offset, 2 = Center, 3 = Random, 4 = Spin
    nYawJitterOffset = 5, -- if "nYawJitterMode" not 0, this variable is yaw jitter offset
    bDisableInAir = false, -- if true, Lua AntiAim will enable in air, and your need disable nixware auto strafe
    bForceAirStrafe = true, -- need disable nixware -> Rage -> Auto Strafe, if true, will use lua AutoStrafe in air
    bFreestandingYaw = true, -- if true, will calculate and adjust freestanding, and disable edge yaw
    nYawJitterDeltaTick = 4, -- if "nYawJitterMode" not 0, this variable is yaw jitter speed
    nPitchJitterDeltaTick = 4, -- if "nPitchMode" = 4, this variable is your pitch jitter speed / tick
    bZeroPitchOnManual = true, -- if true, will 0 pitch on manual aa
    flPitchRandomMaximized = 89, -- if "nPitchMode" = 2, this variable is your pitch max angle, or "nPitchMode" = 4, this variable is your pitch second angle
    flPitchRandomMinimized = - 89, -- if "nPitchMode" = 2, this variable is your pitch min angle, or "nPitchMode" = 4, this variable is your pitch first angle
    flEdgeYawMaximizedRadius = 30, -- maximized edge yaw scan radius
    flFreestandingYawMaximizedRadius = 15, -- maximized freestanding yaw scan radius

    -- Manual Indicator Settings
    bEnableIndicator = true, -- if true, will draw manual indicator
    flCenterOffset = 150, -- manual indicator between crosshair offset
    clrIndicatorColor = color_t(0, 255, 255, 255), -- manual indicator color

    -- Other Settings
    arrManualOffsets = { - 90, 90, 0 } -- manual yaw offset [Left, Right, Backward]
}

local arrSchema = {
    nFlags = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_fFlags"),
    nHeatlh = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_iHealth"),
    iTeamNum = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_iTeamNum"),
    nMoveType = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_MoveType"),
    pEntity = engine.get_netvar_offset("client.dll", "CEntityInstance", "m_pEntity"),
    nLifeState = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_lifeState"),
    vecOrigin = engine.get_netvar_offset("client.dll", "CGameSceneNode", "m_vecOrigin"),
    vecVelocity = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_vecVelocity"),
    flWaterLevel = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_flWaterLevel"),
    vecAbsOrigin = engine.get_netvar_offset("client.dll", "CGameSceneNode", "m_vecAbsOrigin"),
    pGameSceneNode = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_pGameSceneNode"),
    vecViewOffset = engine.get_netvar_offset("client.dll", "C_BaseModelEntity", "m_vecViewOffset")
}

local function FindSignature(szModule, szPattern)
    local pBase = find_pattern(szModule, szPattern)
    if ffi.cast("void*", pBase) == NULLPTR then
        return nil
    end

    return ffi.cast("uintptr_t", pBase)
end

local fnCreateMove = assert(FindSignature("client.dll", "E9 ?? ?? ?? ?? 0F ?? ?? 48 8B C4 44 88 40"), "antiaim error: outdated signature")
-- CreateMove: Hook By Nixware, Relative Jmp 0xE9, Nixware Use Inline Hook, So i cant use vmt hook with CreateMove
local fnSetViewAngles = ffi.cast("void(__fastcall*)(void*, int, struct Vector*)", assert(FindSignature("client.dll", "85 D2 75 3F 48 63"), "antiaim error: outdated signature"))
local fnGetUserCmd = ffi.cast("CUserCmd*(__fastcall*)(void*, int)", assert(FindSignature("client.dll", "40 53 48 83 EC 20 8B DA 85 D2 78 3C E8 7F"), "antiaim error: outdated signature"))
local fnGetUserCmdArray = ffi.cast("void*(__fastcall*)(void*, int)", assert(FindSignature("client.dll", "48 89 4C 24 08 41 54 41 57 48 83 EC 48 4C 63 E2"), "antiaim error: outdated signature"))
local fnGetCommandIndex = ffi.cast("void*(__fastcall*)(void*, int*)", assert(FindSignature("client.dll", "40 53 48 83 EC 20 4C 8B 41 10 48 8B DA 48 8B 0D"), "antiaim error: outdated signature"))
local fnGetViewAngles = ffi.cast("struct Vector*(__fastcall*)(void*, int)", assert(FindSignature("client.dll", "4C 8B C1 85 D2 74 08 48 8D 05 ?? ?? ?? ?? C3"), "antiaim error: outdated signature"))
local fnCreateFilter = ffi.cast("void(__fastcall*)(struct CTraceFilter&, void*, uint64_t, uint8_t, uint16_t)", assert(FindSignature("client.dll", "48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 20 0F B6 41 37 33"), "antiaim error: outdated signature"))
local fnTraceShape = ffi.cast("bool(__fastcall*)(void*, struct CTraceRay*, struct Vector*, struct Vector*, struct CTraceFilter*, struct CGameTrace*)", assert(FindSignature("client.dll", "48 89 5C 24 20 48 89 4C 24 08 55 56 41 55 41 56"), "antiaim error: invalidate signature"))
ffi.metatype("struct CConVar", {
    __index = {
        int = function(this, nValue)
            if nValue then
                local nPrevValue = this.Value.Int
                this.Value.Int = nValue
                return nPrevValue
            end

            return this.Value.Int
        end,

        bool = function(this, bValue)
            if bValue ~= nil then
                local bPrevValue = this.Value.Bool
                this.Value.Bool = bValue
                return bPrevValue
            end

            return this.Value.Bool
        end,

        float = function(this, flValue)
            if flValue then
                local flPrevValue = this.Value.Float
                this.Value.Float = flValue
                return flPrevValue
            end

            return this.Value.Float
        end,

        string = function(this, szValue)
            if szValue then
                local szPrevValue = this.Value.String
                this.Value.String = szValue
                return ffi.string(szPrevValue)
            end

            return ffi.string(this.Value.String)
        end
    }
})

ffi.metatype("struct IEngineCvar", {
    __index = function(self, szName)
        if arrConvars[szName] then
            return arrConvars[szName]
        end

        local listCvar = self.listCvars
        for nIndex = 0, listCvar.memory.nAllocationCount - 1 do
            local pConVar = listCvar.memory.pMemory[nIndex].element
            if not pConVar then
                goto continue
            end

            if szName == ffi.string(pConVar.szName) then
                arrConvars[szName] = pConVar
                return pConVar
            end

            ::continue::
        end

        return false
    end
})

local IEngineCvar = ffi.cast("struct IEngineCvar*", ffi.cast("fnCreateInterface",
    ffi.C.GetProcAddress(ffi.C.GetModuleHandleA("tier0.dll"), "CreateInterface")
)("VEngineCvar007", nil))

local pInstance = (function()
    local pBase = assert(FindSignature("client.dll", "48 8B 0D ?? ?? ?? ?? E8 ?? ?? ?? ?? 48 8B CF 4C 8B E8"), "anti-aim: outdated signature")
    return ffi.cast("void**", pBase + 7 + ffi.cast("int*", pBase + 3)[0])[0]
end)()

local pUnknownInstance = (function()
    -- #xref "tracer_player.vpcf"
    local pBase = assert(FindSignature("client.dll", "48 8B 0D ?? ?? ?? ?? 8B D3 E8 ?? ?? ?? ?? 44 8B 86 48 12"), "anti-aim: outdated signature")
    return ffi.cast("void**", pBase + 7 + ffi.cast("int*", pBase + 3)[0])[0]
end)()

local IEngineTrace = (function()
    -- #xref "const CTraceFilter::`vftable'"
    local pEngineTrace = assert(FindSignature("client.dll", "48 8B 0D ?? ?? ?? ?? 4C 8B C3 66 89 44 24"), "antiaim error: outdated signature")
    return ffi.cast("void**", pEngineTrace + 7 + ffi.cast("int*", pEngineTrace + 3)[0])[0]
end)()

local function DegToRad(flDegree)
    return flDegree * math.pi / 180
end

local function Clamp(flValue, flMin, flMax)
    return math.max(flMin, math.min(flValue, flMax))
end

local function GetXButtonWParam(wParam)
    return bit.band(ffi.cast("uint16_t", bit.rshift(ffi.cast("uint64_t", wParam), 16)), 0xFFFF)
end

local function IsKeyDown(nVirtualKey) -- dont use some shit method like: "GetKeyAsyncState"
    if arrVirtualKeys[nVirtualKey] == nil then
        arrVirtualKeys[nVirtualKey] = false
    end

    return arrVirtualKeys[nVirtualKey]
end

local function IsKeyPress(nVirtualKey) -- dont use some shit method like: "GetKeyAsyncState"
    if arrVirtualKeyPress[nVirtualKey] == nil then
        arrVirtualKeyPress[nVirtualKey] = false
    end

    if not arrVirtualKeys[nVirtualKey] and not arrVirtualKeyResetPress[nVirtualKey] then
        arrVirtualKeyResetPress[nVirtualKey] = true
    end

    if arrVirtualKeyPress[nVirtualKey] ~= arrVirtualKeys[nVirtualKey] and arrVirtualKeys[nVirtualKey] and arrVirtualKeyResetPress[nVirtualKey] then
        arrVirtualKeyPress[nVirtualKey] = true
        arrVirtualKeyResetPress[nVirtualKey] = false
    elseif arrVirtualKeyPress[nVirtualKey] == arrVirtualKeys[nVirtualKey] then
        arrVirtualKeyPress[nVirtualKey] = false
    end

    return arrVirtualKeyPress[nVirtualKey]
end

local function IsKeyRelease(nVirtualKey) -- dont use some shit method like: "GetKeyAsyncState"
    if arrVirtualKeyRelease[nVirtualKey] == nil then
        arrVirtualKeyRelease[nVirtualKey] = false
    end

    if arrVirtualKeys[nVirtualKey] and not arrVirtualKeyResetRelease[nVirtualKey] then
        arrVirtualKeyRelease[nVirtualKey] = false
        arrVirtualKeyResetRelease[nVirtualKey] = true
    end

    if not arrVirtualKeys[nVirtualKey] and not arrVirtualKeyRelease[nVirtualKey] and arrVirtualKeyResetRelease[nVirtualKey] then
        arrVirtualKeyRelease[nVirtualKey] = true
        arrVirtualKeyResetRelease[nVirtualKey] = false
    elseif arrVirtualKeyRelease[nVirtualKey] then
        arrVirtualKeyRelease[nVirtualKey] = false
    end

    return arrVirtualKeyRelease[nVirtualKey]
end

local function GetViewAngles()
    local vecViewAngles = fnGetViewAngles(pUnknownInstance, 0)
    return vec3_t(vecViewAngles.x, vecViewAngles.y, vecViewAngles.z)
end

local function SetViewAngles(vecAngles)
    local pAngles = ffi.new("struct Vector[1]")
    pAngles[0].x = vecAngles.x
    pAngles[0].y = vecAngles.y
    pAngles[0].z = vecAngles.z
    fnSetViewAngles(pUnknownInstance, 0, pAngles)
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

local function GetField(pEntity, szName, szType)
    if not pEntity or pEntity == NULLPTR then
        return false
    end

    if not arrSchema[szName] then
        return false
    end

    return ffi.cast(("%s*"):format(szType), ffi.cast("uintptr_t", pEntity) + arrSchema[szName])[0]
end

local function IsAlive(pEntity)
    if not pEntity or pEntity == NULLPTR then
        return false
    end

    local nHealth = GetField(pEntity, "nHeatlh", "int")
    local nLifeState = GetField(pEntity, "nLifeState", "uint8_t")
    return nLifeState == 0 and nHealth > 0
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
    assert(type(pDetour) == "function", "antiaim error: invalid detour function")
    assert(type(pTarget) == "cdata" or type(pTarget) == "userdata" or type(pTarget) == "number" or type(pTarget) == "function", "antiaim error: invalid target function")
    if not SuspendThreads() then
        ResumeThreads()
        print("antiaim error: failed suspend threads")
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
            print(("[antiaim]: unexception runtime error -> %s"):format(pResult))
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
                print(("[antiaim]: runtime error -> %s"):format(pResult))
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

local function NormalizePitch(flPitch)
	while flPitch > 89 do
		flPitch = flPitch - 180
	end

	while flPitch < - 89 do
		flPitch = flPitch + 180
	end

	return flPitch
end

local function NormalizeYaw(flYaw)
	while flYaw > 180 do
		flYaw = flYaw - 360
	end

	while flYaw < - 180 do
		flYaw = flYaw + 360
	end

	return flYaw
end

local function NormalizeAngles(vecAngles)
    vecAngles.x = NormalizePitch(vecAngles.x)
    vecAngles.y = NormalizeYaw(vecAngles.y)
    vecAngles.z = 0
    return vecAngles
end

local function CalculateDelta(flSpeed)
    local flMaxSpeed = 300
    local flAirAccelerate = IEngineCvar["sv_airaccelerate"]:float()
    local flAccelerate = 50 / flAirAccelerate / flMaxSpeed * 100 / flSpeed
    if flAccelerate < 1 and flAccelerate > - 1 then
        return math.acos(flAccelerate)
    end

    return 0
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

local function CalculateAngleDelta(flAngles, flTarget)
    local flDelta = flAngles - flTarget
    local flRadius = math.fmod(flDelta, math.pi * 2)
    if flAngles > flTarget then
        if flRadius >= math.pi then
            flRadius = flRadius - math.pi * 2
        end
    else
        if flRadius <= - math.pi then
            flRadius = flRadius + math.pi * 2
        end
    end

    return flRadius
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

local function ProcessManualStatus()
	local nPrevManualStatus = nManualSide
	local bPressLeft, bPressRight, bPressBack = IsKeyDown(arrSettings.nLeftKey), IsKeyDown(arrSettings.nRightKey), IsKeyDown(arrSettings.nBackwardKey)
	if bPressLeft == arrManualStatus.bLeft and bPressRight == arrManualStatus.bRight and bPressBack == arrManualStatus.bBackWard then
		return
	end

	arrManualStatus.bLeft, arrManualStatus.bRight, arrManualStatus.bBackWard = bPressLeft, bPressRight, bPressBack
	if (bPressLeft and nPrevManualStatus == 1) or (bPressRight and nPrevManualStatus == 2) or (bPressBack and nPrevManualStatus == 3) then
		nManualSide = 0
		return
	end

	if bPressLeft and nPrevManualStatus ~= 1 then
		nManualSide = 1
	end

	if bPressRight and nPrevManualStatus ~= 2 then
		nManualSide = 2
	end

	if bPressBack and nPrevManualStatus ~= 3 then
		nManualSide = 3
	end
end

local function GetUserCmd()
    local pLocalPlayer = entitylist.get_local_player_controller()
    if not pLocalPlayer then
        return false
    end

    local pCommandIndex = ffi.new("int[1]")
    fnGetCommandIndex(pLocalPlayer[0], pCommandIndex)
    if pCommandIndex[0] == 0 then
        return false
    end

    local nCurrentCommand = pCommandIndex[0] - 1
    local pUserCmdBase = fnGetUserCmdArray(pInstance, nCurrentCommand)
    if pUserCmdBase == NULLPTR then
        return false
    end

    local nSequenceNumber = ffi.cast("int*", ffi.cast("uintptr_t", pUserCmdBase) + 0x5C00)[0]
    if nSequenceNumber <= 0 then
        return false
    end

    local pUserCmd = fnGetUserCmd(pLocalPlayer[0], nSequenceNumber)
    if pUserCmd == NULLPTR then
        return false
    end

    return pUserCmd
end

local function MovementButtonCorrection(pUserCmd)
    local pBaseCmd = pUserCmd.pBaseCmd
    pUserCmd.nButtons.nValue = bit.bxor(pUserCmd.nButtons.nValue, bit.lshift(1, 3))
	pUserCmd.nButtons.nValue = bit.bxor(pUserCmd.nButtons.nValue, bit.lshift(1, 4))
	pUserCmd.nButtons.nValue = bit.bxor(pUserCmd.nButtons.nValue, bit.lshift(1, 9))
	pUserCmd.nButtons.nValue = bit.bxor(pUserCmd.nButtons.nValue, bit.lshift(1, 10))
    if pBaseCmd.flForwardMove > 0 then
        pUserCmd.nButtons.nValue = bit.bor(pUserCmd.nButtons.nValue, bit.lshift(1, 3))
    elseif pBaseCmd.flForwardMove < 0 then
        pUserCmd.nButtons.nValue = bit.bor(pUserCmd.nButtons.nValue, bit.lshift(1, 4))
    end

    if pBaseCmd.flSideMove > 0 then
        pUserCmd.nButtons.nValue = bit.bor(pUserCmd.nButtons.nValue, bit.lshift(1, 9))
    elseif pBaseCmd.flSideMove < 0 then
        pUserCmd.nButtons.nValue = bit.bor(pUserCmd.nButtons.nValue, bit.lshift(1, 10))
    end
end

local function MovementCorrection(pUserCmd, vecAngles)
    local pBaseCmd = pUserCmd.pBaseCmd
    if pBaseCmd == NULLPTR or pBaseCmd.pViewAngles == NULLPTR then
        return
    end

    local vecTarget = vec3_t(0, vecAngles.y, 0)
    local vecCorrection = vec3_t(0, pBaseCmd.pViewAngles.vecValue.y, 0)

    local vecOldUp = Up(vecTarget)
    local vecOldRight = Right(vecTarget)
    local vecOldForward = Forward(vecTarget)

    local vecUp = Up(vecCorrection)
    local vecRight = Right(vecCorrection)
    local vecForward = Forward(vecCorrection)

    vecUp.x = 0
    vecUp.y = 0
    vecRight.z = 0
    vecOldUp.x = 0
    vecOldUp.y = 0
    vecForward.z = 0
    vecOldRight.z = 0
    vecOldForward.z = 0

    local flRollUp = vecUp.z * pBaseCmd.flUpMove
    local flYawSide = vecRight.y * pBaseCmd.flSideMove
    local flPitchSide = vecRight.x * pBaseCmd.flSideMove
    local flYawForward = vecForward.y * pBaseCmd.flForwardMove
    local flPitchForward = vecForward.x * pBaseCmd.flForwardMove

    pBaseCmd.flUpMove = Clamp(vecOldUp.x * flYawSide + vecOldUp.y * flPitchSide + vecOldUp.x * flYawForward + vecOldUp.y * flPitchForward + vecOldUp.z * flRollUp, - 1, 1)
    pBaseCmd.flSideMove = Clamp(vecOldRight.x * flPitchSide + vecOldRight.y * flYawSide + vecOldRight.x * flPitchForward + vecOldRight.y * flYawForward + vecOldRight.z * flRollUp, - 1, 1)
    pBaseCmd.flForwardMove = Clamp(vecOldForward.x * flPitchSide + vecOldForward.y * flYawSide + vecOldForward.x * flPitchForward + vecOldForward.y * flYawForward + vecOldForward.z * flRollUp, - 1, 1)

    MovementButtonCorrection(pUserCmd)
end

local function AutoStrafe(pBaseCmd, flMoveYaw, vecVelocity)
    local flSpeed = vecVelocity:length_2d()
    local flDeltaAir = CalculateDelta(flSpeed)
    if flDeltaAir == 0 then
        return
    end

    local flBestAngle = math.atan2(pBaseCmd.flSideMove, pBaseCmd.flForwardMove)
    local flVelocityAngle = math.atan2(vecVelocity.y, vecVelocity.x) - math.rad(flMoveYaw)

    local flDeltaAngle = CalculateAngleDelta(flVelocityAngle, flBestAngle)
    local flFinalMove = flDeltaAngle < 0 and flVelocityAngle + flDeltaAir or flVelocityAngle - flDeltaAir

    pBaseCmd.flSideMove = math.sin(flFinalMove)
    pBaseCmd.flForwardMove = math.cos(flFinalMove)
end

local function ProcessKey(nMsg, wParam)
    if nMsg == 0x100 then
        arrVirtualKeys[tonumber(wParam)] = true
    elseif nMsg == 0x101 then
        arrVirtualKeys[tonumber(wParam)] = false
    elseif nMsg == 0x201 then
        arrVirtualKeys[0x1] = true
    elseif nMsg == 0x202 then
        arrVirtualKeys[0x1] = false
    elseif nMsg == 0x204 then
        arrVirtualKeys[0x2] = true
    elseif nMsg == 0x205 then
        arrVirtualKeys[0x2] = false
    elseif nMsg == 0x207 then
        arrVirtualKeys[0x4] = true
    elseif nMsg == 0x208 then
        arrVirtualKeys[0x4] = false
    elseif nMsg == 0x20B then
        local nParam = GetXButtonWParam(wParam)
        if nParam == 0x1 then
            arrVirtualKeys[0x5] = true
        elseif nParam == 0x2 then
            arrVirtualKeys[0x6] = true
        end

    elseif nMsg == 0x20C then
        local nParam = GetXButtonWParam(wParam)
        if nParam == 0x1 then
            arrVirtualKeys[0x5] = false
        elseif nParam == 0x2 then
            arrVirtualKeys[0x6] = false
        end
    end
end

local function IsCanHitable(vecPoint)
    local pLocalPawn = entitylist.get_local_player_pawn()
    if not pLocalPawn or not IsAlive(pLocalPawn[0]) then
        return false
    end

    local arrPlayers = entitylist.get_entities("C_CSPlayerPawn")
    local nTeamNum = GetField(pLocalPawn[0], "iTeamNum", "int8_t")
    local bTeammateAreEnemies = IEngineCvar["mp_teammates_are_enemies"]:bool()
    for nIndex = 1, #arrPlayers do
        local pPlayerPawn = arrPlayers[nIndex]
        if not pPlayerPawn or not IsAlive(pPlayerPawn[0]) then
            goto continue
        end

        local nPlayerTeamNum = GetField(pPlayerPawn[0], "iTeamNum", "int8_t")
        if bTeammateAreEnemies and nPlayerTeamNum == nTeamNum then
            goto continue
        end

        local vecPlayerEyePosition = GetEyePosition(pPlayerPawn[0])
        local pTrace = TraceShape(vecPlayerEyePosition, vecPoint, pPlayerPawn[0])
        if pTrace.flFraction > 0.94 then
            return true
        end

        ::continue::
    end

    return false
end

local function CalculateEdgeYaw(pBaseCmd)
    local pLocalPawn = entitylist.get_local_player_pawn()
    if not pLocalPawn or not IsAlive(pLocalPawn[0]) then
        return false
    end

    local nFlags = GetField(pLocalPawn[0], "nFlags", "uint32_t")
    if bit.band(nFlags, bit.lshift(1, 0)) == 0 then
        return false
    end

    local vecViewAngles = pBaseCmd.pViewAngles.vecValue
    local vecEyePosition = GetEyePosition(pLocalPawn[0])
    local arrData = {
        flYaw = 0,
        flFraction = 1
    }

	for flYaw = - 180, 180, arrSettings.flEdgeYawStep do
        local vecForward = Forward(vec3_t(0, vecViewAngles.y + flYaw, 0))
        local pTrace = TraceShape(vecEyePosition, vecEyePosition + (vecForward * 8192), pLocalPawn[0])
        if pTrace.flFraction < arrData.flFraction then
            arrData.flYaw = flYaw
            arrData.flFraction = pTrace.flFraction
        end
    end

    if arrData.flYaw ~= 0 then
        local vecForward = Forward(vec3_t(0, vecViewAngles.y + arrData.flYaw, 0))
        local pTrace = TraceShape(vecEyePosition, vecEyePosition + (vecForward * 8192), pLocalPawn[0])

        local vecEnd = vec3_t(pTrace.vecEnd.x, pTrace.vecEnd.y, pTrace.vecEnd.z)
        if (vecEnd - vecEyePosition):length() > arrSettings.flEdgeYawMaximizedRadius then
            return false
        end
    end

    return arrData.flYaw
end

local function CalculateFreestandingYaw(pBaseCmd)
    local pLocalPawn = entitylist.get_local_player_pawn()
    if not pLocalPawn or not IsAlive(pLocalPawn[0]) then
        return false
    end

    local arrFraction = { Left = 0, Right = 0 }
    local vecViewAngles = pBaseCmd.pViewAngles.vecValue
    local vecEyePosition = GetEyePosition(pLocalPawn[0])
    local nFlags = GetField(pLocalPawn[0], "nFlags", "uint32_t")
    if bit.band(nFlags, bit.lshift(1, 0)) == 0 then
        return false
    end

    local arrSite = {
        { "Right", vec3_t(0, 45, 0) },
        { "Right", vec3_t(0, 90, 0) },
        { "Left", vec3_t(0, - 45, 0) },
        { "Left", vec3_t(0, - 90, 0) }
    }

    local vecForward = Forward(vec3_t(0, vecViewAngles.y, 0))
    local flDistance = arrSettings.flFreestandingYawMaximizedRadius
    for _, arrData in pairs(arrSite) do
        local vecSite = Forward(vec3_t(0, vecViewAngles.y + arrData[2].y, 0))
        local pTraceDirection = TraceShape(vecEyePosition, vecEyePosition + (vecSite * 8192), pLocalPawn[0])
        local vecRotationPosition = vec3_t(pTraceDirection.vecEnd.x, pTraceDirection.vecEnd.y, pTraceDirection.vecEnd.z)
        if (vecRotationPosition - vecEyePosition):length() > flDistance then
            goto continue
        end

        local pTrace = TraceShape(vecRotationPosition, vecRotationPosition + (vecForward * 8192), pLocalPawn[0])
        arrFraction[arrData[1]] = arrFraction[arrData[1]] + pTrace.flFraction
        ::continue::
    end

    if arrFraction.Left == arrFraction.Right then
        local flRotationDistance = 20
        local arrRotationFraction = { Left = 0, Right = 0 }
        for _, arrData in pairs(arrSite) do
            local vecSite = Forward(vec3_t(0, vecViewAngles.y + arrData[2].y, 0))
            local pTraceDirection = TraceShape(vecEyePosition, vecEyePosition + (vecSite * flRotationDistance), pLocalPawn[0])
            local vecRotationPosition = vec3_t(pTraceDirection.vecEnd.x, pTraceDirection.vecEnd.y, pTraceDirection.vecEnd.z)
            if IsCanHitable(vecRotationPosition) then
                arrRotationFraction[arrData[1]] = 0
                goto continue
            end

            arrRotationFraction[arrData[1]] = arrRotationFraction[arrData[1]] + 1
            ::continue::
        end

        if arrRotationFraction.Left == arrRotationFraction.Right then
            return false
        end

        return arrRotationFraction.Right > arrRotationFraction.Left and 90 or - 90
    end

    local arrPlayers = entitylist.get_entities("C_CSPlayerPawn")
    local nTeamNum = GetField(pLocalPawn[0], "iTeamNum", "int8_t")
    local flFreestandingYaw = arrFraction.Right > arrFraction.Left and 90 or - 90
    local vecSite = Forward(vec3_t(0, vecViewAngles.y + flFreestandingYaw, 0))
    local bTeammateAreEnemies = IEngineCvar["mp_teammates_are_enemies"]:bool()
    local pTraceDirection = TraceShape(vecEyePosition, vecEyePosition + (vecSite * 8192), pLocalPawn[0])
    local vecRotationPosition = vec3_t(pTraceDirection.vecEnd.x, pTraceDirection.vecEnd.y, pTraceDirection.vecEnd.z)
    for nIndex = 1, #arrPlayers do
        local pPlayerPawn = arrPlayers[nIndex]
        if not pPlayerPawn or not IsAlive(pPlayerPawn[0]) then
            goto continue
        end

        local nPlayerTeamNum = GetField(pPlayerPawn[0], "iTeamNum", "int8_t")
        if bTeammateAreEnemies and nPlayerTeamNum == nTeamNum then
            goto continue
        end

        local vecPlayerEyePosition = GetEyePosition(pPlayerPawn[0])
        local pTrace = TraceShape(vecPlayerEyePosition, vecRotationPosition, pPlayerPawn[0])
        if pTrace.flFraction > 0.94 then
            return false
        end

        ::continue::
    end

    return flFreestandingYaw
end

local function AntiAim()
    local pLocalPawn = entitylist.get_local_player_pawn()
    if not pLocalPawn or not arrSettings.bEnabled or not IsAlive(pLocalPawn[0]) then
        return
    end

    local pUserCmd = GetUserCmd()
    if not pUserCmd then
        return
    end

    local pBaseCmd = pUserCmd.pBaseCmd
    if pBaseCmd == NULLPTR or pBaseCmd.pViewAngles == NULLPTR then
        return
    end

    local bInAttack = bit.band(pUserCmd.nButtons.nValue, bit.lshift(1, 0)) ~= 0
    if bInAttack or pUserCmd.nAttack3StartHistoryIndex >= 0 then
        return
    end

    local nFlags = GetField(pLocalPawn[0], "nFlags", "uint32_t")
    local nMoveType = GetField(pLocalPawn[0], "nMoveType", "uint8_t")
    local flWaterLevel = GetField(pLocalPawn[0], "flWaterLevel", "float")
    local vecVelocity = GetField(pLocalPawn[0], "vecVelocity", "struct Vector")
    if not nFlags or not nMoveType or not vecVelocity then
        return
    end

    if bit.band(pUserCmd.nButtons.nValue, bit.lshift(1, 5)) ~= 0 then
        return
    end

    local bOnGround = bit.band(nFlags, bit.lshift(1, 0)) ~= 0
    if arrSettings.bDisableInAir and not bOnGround then
        return
    end

    ProcessManualStatus()
    local vecCameraAnlges = GetViewAngles()
    local flAngleDiff = pBaseCmd.pViewAngles.vecValue.y - vecCameraAnlges.y
    local bInSpeed = bit.band(pUserCmd.nButtons.nValue, bit.lshift(1, 16)) ~= 0
    if arrSettings.nPitchMode ~= 0 then
        if arrSettings.nPitchMode == 1 then
            pBaseCmd.pViewAngles.vecValue.x = - 89
        elseif arrSettings.nPitchMode == 2 then
            pBaseCmd.pViewAngles.vecValue.x = 89
        elseif arrSettings.nPitchMode == 3 then
            math.randomseed(pBaseCmd.nRandomSeed)
            pBaseCmd.pViewAngles.vecValue.x = math.random(arrSettings.flPitchRandomMinimized, arrSettings.flPitchRandomMaximized)
        elseif arrSettings.nPitchMode == 4 then
            if math.abs(pBaseCmd.nClientTick - nPitchJitterTick) > arrSettings.nPitchJitterDeltaTick then
                bJitterPitch = not bJitterPitch
                nPitchJitterTick = pBaseCmd.nClientTick
            end

            pBaseCmd.pViewAngles.vecValue.x = bJitterPitch and arrSettings.flPitchRandomMaximized or arrSettings.flPitchRandomMinimized
        end
    end

    if arrSettings.nManualStyle == 0 then
        flControlManualYaw = 0
        flControlManualYawUpdate = 0
        vecPrevCameraAngles = vecCameraAnlges
    elseif IsKeyDown(arrSettings.nMouseControlKey) and not bControlManual then
        SetViewAngles(vecPrevCameraAngles)
        flControlManualYaw = flControlManualYaw + (vecCameraAnlges.y - vecPrevCameraAngles.y)
        if math.abs(flControlManualYaw) > 5 then
            bControlManual = true
        end

    elseif bControlManual then
        if IsKeyRelease(arrSettings.nMouseControlKey) then
            SetViewAngles(vecPrevCameraAngles)
            flControlManualYaw = Clamp(flControlManualYaw + flControlManualYawUpdate, - 90, 90)
            if math.abs(flControlManualYawUpdate) < 5 then
                bControlManual = false
                flControlManualYaw = 0
            end

        elseif IsKeyDown(arrSettings.nMouseControlKey) then
            SetViewAngles(vecPrevCameraAngles)
            flControlManualYawUpdate = flControlManualYawUpdate + (vecPrevCameraAngles.y - vecCameraAnlges.y)
        else
            flControlManualYawUpdate = 0
            vecPrevCameraAngles = vecCameraAnlges
        end
    else
        flControlManualYaw = 0
        flControlManualYawUpdate = 0
        vecPrevCameraAngles = vecCameraAnlges
    end

    if arrSettings.nManualStyle == 1 and bControlManual then
        local flCurrentManualYaw = Clamp(flControlManualYaw + flControlManualYawUpdate, - 90, 90)
        pBaseCmd.pViewAngles.vecValue.y = pBaseCmd.pViewAngles.vecValue.y + flCurrentManualYaw
        if arrSettings.bZeroPitchOnManual then
            pBaseCmd.pViewAngles.vecValue.x = 0
        end

    elseif arrSettings.nManualStyle == 0 and nManualSide ~= 0 and nManualSide ~= 3 then
        if arrSettings.bZeroPitchOnManual then
            pBaseCmd.pViewAngles.vecValue.x = 0
        end

        pBaseCmd.pViewAngles.vecValue.y = pBaseCmd.pViewAngles.vecValue.y + arrSettings.arrManualOffsets[nManualSide]
    else
        local flExtraYawOffset = 0
        if arrSettings.nYawJitterMode == 1 then
            if math.abs(pBaseCmd.nClientTick - flYawJitterTick) > arrSettings.nYawJitterDeltaTick then
                bYawJitter = not bYawJitter
                flYawJitterTick = pBaseCmd.nClientTick
            end

            flExtraYawOffset = (bYawJitter and arrSettings.nYawJitterOffset or - arrSettings.nYawJitterOffset)
        elseif arrSettings.nYawJitterMode == 2 then
            local nCenterOffset = arrSettings.nYawJitterOffset / 2
            if math.abs(pBaseCmd.nClientTick - flYawJitterTick) > arrSettings.nYawJitterDeltaTick then
                bYawJitter = not bYawJitter
                flYawJitterTick = pBaseCmd.nClientTick
            end

            flExtraYawOffset = (bYawJitter and nCenterOffset or - nCenterOffset)
        elseif arrSettings.nYawJitterMode == 3 then
            if math.abs(pBaseCmd.nClientTick - flYawJitterTick) > arrSettings.nYawJitterDeltaTick then
                math.randomseed(pBaseCmd.nRandomSeed)
                flYawJitterTick = pBaseCmd.nClientTick
                flYawJitterOffset = math.random(0, arrSettings.nYawJitterOffset)
            end

            flExtraYawOffset = flYawJitterOffset
        elseif arrSettings.nYawJitterMode == 4 then
            flYawJitterOffset = NormalizeYaw(flYawJitterOffset + arrSettings.nYawJitterOffset)
            flExtraYawOffset = flYawJitterOffset
        end

        local flEdgeYaw = CalculateEdgeYaw(pBaseCmd)
        local flFreestandingYaw = CalculateFreestandingYaw(pBaseCmd)
        if arrSettings.bFreestandingYaw and flFreestandingYaw then
            flExtraYawOffset = flFreestandingYaw
        elseif arrSettings.bEdgeYaw and flEdgeYaw then
            flExtraYawOffset = flEdgeYaw
        end

        pBaseCmd.pViewAngles.vecValue.y = pBaseCmd.pViewAngles.vecValue.y + flExtraYawOffset
    end

    local flMoveYaw = NormalizeYaw(vecCameraAnlges.y + flAngleDiff)
    if not bOnGround and not bInSpeed and arrSettings.bForceAirStrafe and nMoveType ~= 8 and nMoveType ~= 9 and flWaterLevel < 2 then
        AutoStrafe(pBaseCmd, flMoveYaw, vec3_t(vecVelocity.x, vecVelocity.y, vecVelocity.z))
    end

    NormalizeAngles(pBaseCmd.pViewAngles.vecValue)
    MovementCorrection(pUserCmd, vec3_t(0, flMoveYaw, 0))
end

local function hkWndProc(hWnd, nMsg, wParam, lParam)
    ProcessKey(nMsg, wParam)
    return ffi.C.CallWindowProcW(pOriginalWndProc, hWnd, nMsg, wParam, lParam)
end

local function hkCreateMove(pObject, pCCSGOInput, nSlot, nActive)
    pObject(pCCSGOInput, nSlot, nActive)
    pcall(AntiAim)
end

local function hkUnLoad()
    for _, pObject in pairs(arrHooks) do
        pObject:Remove()
    end

    if pOriginalWndProc ~= NULLPTR then
        local hWnd = ffi.C.GetActiveWindow()
		ffi.C.SetWindowLongPtrW(hWnd, - 4, ffi.cast("void*", pOriginalWndProc))
		pOriginalWndProc = NULLPTR
	end
end

local function hkPresent()
    local pLocalPawn = entitylist.get_local_player_pawn()
    if not pLocalPawn or not pRenderFont or not arrSettings.bEnabled or not arrSettings.bEnableIndicator or not IsAlive(pLocalPawn[0]) then
        return
    end

    local vecScreenSize = render.screen_size()
    if arrSettings.nManualStyle == 1 and bControlManual then
        local flCenterOffset = (Clamp(flControlManualYaw + flControlManualYawUpdate, - 90, 90) / 90) * arrSettings.flCenterOffset
        render.circle_fade(vec2_t((vecScreenSize.x / 2) + flCenterOffset, vecScreenSize.y / 2), 10, arrSettings.clrIndicatorColor, color_t(arrSettings.clrIndicatorColor.r, arrSettings.clrIndicatorColor.g, arrSettings.clrIndicatorColor.a, 0))
    elseif arrSettings.nManualStyle == 0 and nManualSide ~= 0 and nManualSide ~= 3 then
        render.text(nManualSide == 1 and "<" or ">", pRenderFont, vec2_t((vecScreenSize.x / 2) + (nManualSide == 1 and - arrSettings.flCenterOffset or arrSettings.flCenterOffset), (vecScreenSize.y / 2) - 18), arrSettings.clrIndicatorColor, 35)
    end
end

local function SetupWndProc()
    if pOriginalWndProc ~= NULLPTR then
        return
    end

    local hWnd = ffi.C.GetActiveWindow()
    local pWndProcProxy = ffi.cast("int64_t(__stdcall*)(void*, uint32_t, uint64_t, int64_t)", hkWndProc)
    pOriginalWndProc = ffi.C.SetWindowLongPtrW(hWnd, - 4, ffi.cast("void*", pWndProcProxy))
end

local function SetupFont()
    local szPath = ffi.new("char[260]")
    ffi.C.GetModuleFileNameA(NULLPTR, szPath, 260)
    local szGameDirectory = ffi.string(szPath)
    local nPosition = szGameDirectory:find("\\bin\\win64\\cs2.exe")
    if not nPosition then
        return
    end

    szGameDirectory = szGameDirectory:sub(0, nPosition)
    local szFontDirectory = ("%scsgo\\panorama\\fonts\\notosanssc-bold.ttf"):format(szGameDirectory)
    pRenderFont = render.setup_font(szFontDirectory, 35)
end

local function Setup()
    SetupFont()
    SetupWndProc()
    register_callback("unload", hkUnLoad)
    register_callback("paint", hkPresent)
    CreateHook(fnCreateMove, hkCreateMove, "void(__fastcall*)(void*, int, uint8_t)")
end

Setup()