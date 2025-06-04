local COLOR_RIGHT_HERE = color_t(255, 255 / 255, 255 / 255, 0.8)
local KIBIT = false;

xpcall(function()
    ffi.cdef[[
        typedef struct CGlobalVarsBase { // credits: jakebooom
            float m_flRealTime; //0x0000
            int32_t m_iFrameCount; //0x0004
            float m_flAbsoluteFrameTime; //0x0008
            float m_flAbsoluteFrameStartTimeStdDev; //0x000C
            int32_t m_nMaxClients; //0x0010
            char pad_0014[28]; //0x0014
            float m_flIntervalPerTick; //0x0030
            float m_flCurrentTime; //0x0034
            float m_flCurrentTime2; //0x0038
            char pad_003C[20]; //0x003C
            int32_t m_nTickCount; //0x0050
            char pad_0054[292]; //0x0054
            uint64_t m_uCurrentMap; //0x0178
            uint64_t m_uCurrentMapName; //0x0180
        } CGlobalVarsBase;

        typedef struct vec3_t {
            float x, y, z;
        } vec3_t;

        typedef struct bullet_data {
            vec3_t position;
            float time_stamp;
            float expire_time;
        } bullet_data;
    ]];

    local Abs = function(addr, pre, post) -- syr1337
        addr = addr + (pre or 1);
        addr = addr + ffi.sizeof("int") + ffi.cast("int64_t", ffi.cast("int*", addr)[0]);
        addr = addr + (post or 0);
        return addr;
    end;

    local GlobalVarsBase = ffi.cast("struct CGlobalVarsBase**", Abs(ffi.cast("uintptr_t", find_pattern("client.dll", "48 8B 05 ?? ?? ?? ?? 8B 48 04 FF C1")), 3, 0))[0]; -- китаец с форума
    local last_map = "n1zex";

    local UpdateInterface = function ()
        local newMap = engine.get_level_name();
        if newMap ~= last_map then
            GlobalVarsBase = ffi.cast("struct CGlobalVarsBase**", Abs(ffi.cast("uintptr_t", find_pattern("client.dll", "48 8B 05 ?? ?? ?? ?? 8B 48 04 FF C1")), 3, 0))[0];
            last_map = newMap
            return true;
        end;
    end;

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
    local Lerp = function(a, b, t)
        return a + (b - a) * t
    end
    local arrImpacts = {};

    local fnProcessImpacts = function ()
        for i,v in ipairs(arrImpacts) do
            local flDelta = 1 - ((GlobalVarsBase.m_flCurrentTime - v.flCurrentTime) / 4);
            local w2s = render.world_to_screen(v.vecPosition);
            local flLength = 8;
            local flOffset = 3;
            local color = color_t(COLOR_RIGHT_HERE.r, COLOR_RIGHT_HERE.g, COLOR_RIGHT_HERE.b, flDelta);
            if (w2s ~= nil and w2s.x and w2s.y) then 
                if (KIBIT) then
                    render.line(vec2_t(w2s.x - 8, w2s.y), vec2_t(w2s.x + 8, w2s.y), color, 3)
                    render.line(vec2_t(w2s.x, w2s.y - 8), vec2_t(w2s.x, w2s.y + 8), color, 3)
                else
                    render.line(vec2_t(w2s.x - flLength, w2s.y - flLength), vec2_t(w2s.x - flOffset, w2s.y - flOffset), color, 1)
                    render.line(vec2_t(w2s.x + flOffset, w2s.y - flOffset), vec2_t(w2s.x + flLength, w2s.y - flLength), color, 1)
                    render.line(vec2_t(w2s.x + flOffset, w2s.y + flOffset), vec2_t(w2s.x + flLength, w2s.y + flLength), color, 1)
                    render.line(vec2_t(w2s.x - flLength, w2s.y + flLength), vec2_t(w2s.x - flOffset, w2s.y + flOffset), color, 1)
                end
            end;
        end;
    end;

    local fnOnPaint = function ()
        if UpdateInterface() then return; end;
        fnProcessImpacts();
        local pLocalPawn = entitylist.get_local_player_pawn()
        if not pLocalPawn or pLocalPawn == 0 or ffi.cast("int*", pLocalPawn[m_iHealth])[0] <= 0 then
            return
        end
    
        local vecEyePosition = GetEyePos(pLocalPawn)
        local pBulletServices = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_pBulletServices)[0]
        if not pBulletServices or pBulletServices == 0 then return end
    
        if not pBulletData_type then return end
        local pBulletData = ffi.cast(pBulletData_type, ffi.cast("uintptr_t", pBulletServices) + 0x48)[0]
        if not pBulletData then return end
    
        local maxIterations = 100
        for i = math.min(pBulletData:count(), last_count_bullet + maxIterations), last_count_bullet + 1, -1 do
            local element = pBulletData:element(i - 1)
            if element and element.position then
                table.insert(arrImpacts, {vecPosition = vec3_t(element.position.x, element.position.y, element.position.z), flCurrentTime = GlobalVarsBase.m_flCurrentTime + 4});
            else
                print("л >> " .. tostring(i - 1))
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
end,print);