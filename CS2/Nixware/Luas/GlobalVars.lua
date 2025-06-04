local GlobalVarsBase; do
    
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
    ]];

    local Abs = function(addr, pre, post) -- syr1337
        addr = addr + (pre or 1);
        addr = addr + ffi.sizeof("int") + ffi.cast("int64_t", ffi.cast("int*", addr)[0]);
        addr = addr + (post or 0);
        return addr;
    end;

    GlobalVarsBase = ffi.cast("struct CGlobalVarsBase**", Abs(ffi.cast("uintptr_t", find_pattern("client.dll", "48 8B 05 ?? ?? ?? ?? 8B 48 04 FF C1")), 3, 0))[0]; -- китаец с форума
    local last_map = "n1zex";

    local UpdateInterface = function ()
        local newMap = engine.get_level_name();
        if newMap ~= last_map then
            GlobalVarsBase = ffi.cast("struct CGlobalVarsBase**", Abs(ffi.cast("uintptr_t", find_pattern("client.dll", "48 8B 05 ?? ?? ?? ?? 8B 48 04 FF C1")), 3, 0))[0];
            last_map = newMap
            return true;
        end;
    end;

    register_callback("paint", function()
        if UpdateInterface() then return; end;
    end);
end;