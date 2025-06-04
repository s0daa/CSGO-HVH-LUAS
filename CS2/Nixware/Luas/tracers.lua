-- main code: SYR1337
-- extra funcs: qi-ux
-- new signatures + "client impacts" tracers: n1zex

local COLOR_RIGHT_HERE = color_t(1, 202 / 255, 113 / 255, 0.8)

xpcall(function()
    local print = function(...)

    end;
    local find_pattern_og = find_pattern
    find_pattern = function(a, b)
        local c = find_pattern_og(a, b)
        if not c then print(tostring(b) .. "  инвалид конкретный") end
        return c
    end

    if not pcall(ffi.sizeof, "struct CParticleInformation") then
        ffi.cdef([[
            typedef struct Vector {
                float x, y, z;
            } Vector;

            typedef struct CBindingData {
                void* pData;
                uint64_t nUnknown;
                uint64_t nUnknown2;
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
                float flTime;
                float flWidth;
                float flUnknown;
            } CParticleInformation;

            typedef struct vec3_t {
                float x, y, z;
            } vec3_t;

            typedef struct bullet_data {
                vec3_t position;
                float time_stamp;
                float expire_time;
            } bullet_data;
        ]])
    end

    local Abs = function(addr, pre, post)
        addr = ffi.cast("uintptr_t", addr);
        addr = addr + (pre or 1)
        addr = addr + ffi.sizeof("int") + ffi.cast("int64_t", ffi.cast("int*", addr)[0])
        addr = addr + (post or 0)
        return addr
    end;
    local anton_vfunc_CreateSnapshot = function (...) end
    local anton_vfunc_Draw = function (...) end
    local IParticleManager = setmetatable({
        pPatricleManager = nil,
        ppPatricleManager = (function()
            local ppParticleManager = assert(find_pattern("client.dll", "48 8B 05 ?? ?? ?? ?? 48 8B 08 48 8B 59 68"), "bullet tracer: not found patricle manager")
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
                anton_vfunc_CreateSnapshot = this:GetVFunc(42, "void(__thiscall*)(void*, struct CStrongHandle*, int64_t*)")
                anton_vfunc_Draw = this:GetVFunc(43, "void(__thiscall*)(void*, struct CStrongHandle*, int, void*)")
            end,

            IsValid = function(this)
                return this.pPatricleManager and this.ppPatricleManager and this.pPatricleManager ~= ffi.NULL and this.ppPatricleManager ~= ffi.NULL
            end,

            CallVFunc = function(this, nIndex, szType, ...)
                if not this:IsValid() then
                    return nil
                end

                local pVtable = ffi.cast("void***", this:Get())
                local func = ffi.cast(szType, pVtable[0][nIndex])

                if (not func or func == 0 or func == ffi.NULL) then
                    return nil; end;

                return func(this:Get(), ...)
            end,

            GetVFunc = function(this, nIndex, szType)
                if not this:IsValid() then
                    return nil
                end

                local pVtable = ffi.cast("void***", this:Get())
                local func = ffi.cast(szType, pVtable[0][nIndex])

                if (not func or func == 0 or func == ffi.NULL) then
                    return nil; end;

                return func
            end,

            CreateSnapshot = function(this, pSnapShotHandle)
                if not this:IsValid() then
                    return false
                end

                local pUtlStringData = ffi.new("int64_t[1]")
                this:CallVFunc(42, "void(__thiscall*)(void*, struct CStrongHandle*, int64_t*)", pSnapShotHandle, pUtlStringData)
                return true
            end,

            Draw = function(this, pSnapShotHandle, nCount, pEffectData)
                if not this:IsValid() then
                    return false
                end

                this:CallVFunc(43, "void(__thiscall*)(void*, struct CStrongHandle*, int, void*)", pSnapShotHandle, nCount, pEffectData)
                return true
            end
        }
    })

    local IGameParticleManager = setmetatable({
        pGameParticleManager = nil,
        fnSetEffectData = ffi.cast("void(__fastcall*)(void*, uint32_t, int, void*, int)", Abs(find_pattern("client.dll", "E8 ? ? ? ? 4C 39 A7 ? ? ? ?"), 1, 0)),
        fnCreateEffectIndex = ffi.cast("void(__fastcall*)(void*, uint32_t*, struct CParticleEffect*)", find_pattern("client.dll", "40 57 48 83 EC 20 49 8B ?? 48 8B")),
        fnCreateEffect2 = ffi.cast("void(__fastcall*)(void*, uint32_t*, const char*, int, int64_t, int64_t, int64_t, int)", Abs(find_pattern("client.dll", "E8 ? ? ? ? 33 D2 8B 08 89 4E 44"), 0x1, 0x0)),
        fnInitEffect = ffi.cast("bool(__fastcall*)(void*, int, uint32_t, struct CStrongHandle*)", find_pattern("client.dll", "48 89 74 24 10 57 48 83 EC 30 4C 8B D9 49 8B F9 33 C9 41 8B F0 83 FA FF 0F")),
        fnGetGameParticleManager = ffi.cast("void*(__fastcall*)()", find_pattern("client.dll", "48 8B ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? 48 89 5C 24 10 57 48 81 EC 70 06 ?? ?? 48 8B 1D"))
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
        for nIndex, szKey in pairs({ "r", "g", "b" }) do
            pBeamColor[0][szKey] = clrColor[szKey] * 255 or clrColor[nIndex] * 255 or 255
        end

        IParticleManager:Update()
        if ( not IParticleManager:IsValid() ) then return; end;
        IGameParticleManager:Update()
        if ( not IGameParticleManager:IsValid() ) then return; end;
        local vecDirection = (vecEnd - vecStart)
        local pEffectData = ffi.new("struct CParticleData[1]")
        local vecLinePointToEnd = vecStart + (vecDirection * 0.5)
        local vecCenterLinePoint = vecStart + (vecDirection * 0.3)
        local pSnapShotHandle = ffi.new("struct CStrongHandle[1]")
        if IGameParticleManager:CreateEffect(pEffectIndex, szBeamMaterial)  == -1337 then return end
        if IGameParticleManager:SetEffectData(pEffectIndex[0], 16, pBeamColor, 0) == -1337 then return end
        local pParticleInformation = ffi.new("struct CParticleInformation[1]")
        pParticleInformation[0].flUnknown = 1
        pParticleInformation[0].flWidth = 2
        pParticleInformation[0].flTime = 4
        if IGameParticleManager:SetEffectData(pEffectIndex[0], 3, pParticleInformation, 0) == -1337 then return end
        local vecStepPoints = { vecStart, vecCenterLinePoint, vecLinePointToEnd, vecEnd }
        for nIndex = 1, #vecStepPoints do
            pEffectData[0].flTimes = ffi.new(("float[%i]"):format(nIndex))
            pEffectData[0].vecPositions = ffi.new(("struct Vector[%i]"):format(nIndex))
            for nPointIndex = 1, nIndex do
                pEffectData[0].flTimes[nPointIndex - 1] = 0.015625 * nPointIndex
                for _, szKey in pairs({ "x", "y", "z" }) do
                    pEffectData[0].vecPositions[nPointIndex - 1][szKey] = vecStepPoints[nPointIndex][szKey]
                end
            end
            local pUtlStringData = ffi.new("int64_t[1]")
            if anton_vfunc_CreateSnapshot == nil then IParticleManager:Update() return; end;
            anton_vfunc_CreateSnapshot(IParticleManager:Get(), pSnapShotHandle, pUtlStringData)
            pEffectData[0].flTimes2 = pEffectData[0].flTimes
            if not IGameParticleManager:InitEffect(pEffectIndex[0], 0, pSnapShotHandle) then return; end
            if anton_vfunc_Draw == nil then IParticleManager:Update() return; end;
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

        MT.iterator_t = ffi.metatype(
            ffi.typeof([[ 
                struct {
                    $ index; 
                }
            ]], I),
            {
                __eq = function(self, it)
                    if ffi.istype(self, it) then
                        return self.index == it.index
                    end
                end
            }
        )

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
                print(tostring("max: " ..tostring(#MT)))
                print(tostring("access: " ..tostring(key)))
                print(tostring("self.m_memory: " ..tostring(self.m_allocation_count)))
                if MT[key] then return MT[key] end
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
        print(tostring("max: " ..tostring(self.m_size)))
        print(tostring("access: " ..tostring(i)))
        if i > -1 and i < self.m_size then 
            return self.m_memory[i] 
        else
            return nil
        end
    end

    return function(T, A)
        return ffi.metatype(anton_1, {
            __index = function(self, key)
                if MT[key] then return MT[key] end
                if type(key) == "number" then 
                    return self:element(key) 
                end
                return nil
            end,
            __ipairs = function(self)
                return function(t, i)
                    i = i + 1
                    local v = t[i]
                    if v then return i, v end
                end, self, -1
            end
        })
    end
end)() -- qi-ux
local pBulletData_type = ffi.typeof("$*", CUtlVector("bullet_data"))
    local GetEyePos = function(pLocalPawn)
        local GameSceneNode = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_pGameSceneNode)[0];
        if not GameSceneNode or GameSceneNode == 0 then return vec3_t(0,0,0) end;
        local vecAbsOrigin = ffi.cast("struct vec3_t*", ffi.cast("uintptr_t", GameSceneNode) + m_vecAbsOrigin)[0];
        local vecViewOffset = ffi.cast("struct vec3_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_vecViewOffset)[0];
        
        return vec3_t(vecAbsOrigin.x + vecViewOffset.x, vecAbsOrigin.y + vecViewOffset.y, vecAbsOrigin.z + vecViewOffset.z);
    end;
    local last_count_bullet = 0;

    local fnOnPaint = function ()
        local pLocalPawn = entitylist.get_local_player_pawn()
        if not pLocalPawn or pLocalPawn == 0 or ffi.cast("int*", pLocalPawn[m_iHealth])[0] <= 0 then
            return
        end
    
        local vecEyePosition = GetEyePos(pLocalPawn)
        local pBulletServices = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_pBulletServices)[0]
        if not pBulletServices or pBulletServices == 0 then return end
    
        -- local pBulletData_type = ffi.typeof("$*", CUtlVector("bullet_data"))
        if not pBulletData_type then return end
        local pBulletData = ffi.cast(pBulletData_type, ffi.cast("uintptr_t", pBulletServices) + 0x48)[0]
        if not pBulletData then return end
    
        local maxIterations = 100
        for i = math.min(pBulletData:count(), last_count_bullet + maxIterations), last_count_bullet + 1, -1 do
            local element = pBulletData:element(i - 1)
            if element and element.position then
                CreateBeamPoint(vecEyePosition, vec3_t(element.position.x, element.position.y, element.position.z), COLOR_RIGHT_HERE)
            else
                print("😪 >> " .. tostring(i - 1))
            end
        end
    
        if pBulletData:count() ~= last_count_bullet then 
            last_count_bullet = pBulletData:count()
        end
        goto zov_
        last_count_bullet = 0;
        ::zov_::
    end
    register_callback("paint", fnOnPaint)
end,print)
-- register_callback("unload", function ()
--     print("ZZZZZZZZZZZZZZZZZZZZZ", color_t(1, 0,0,1))
-- end)
