-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local fnFindHudElement = ffi.cast("uintptr_t*(__fastcall*)(const char*)", find_pattern("client.dll", "40 55 48 83 EC 20 48 83"));
local fnClearNotices = ffi.cast("void(__fastcall*)(uintptr_t)", find_pattern("client.dll", "48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 20 48 8B 71 68"));
local bClear = false;

local ClearNotices = function(hudPtr)
    fnClearNotices(ffi.cast("uintptr_t", hudPtr) - 0x28);
    bClear = false
end

local fnMain = function(bUnload)
    local hudPtr = fnFindHudElement("CCSGO_HudDeathNotice");
    if not hudPtr or hudPtr == nil then return end;
    ffi.cast("float*", ffi.cast("uintptr_t", hudPtr) + 0x50)[0] = bUnload and 1.5 or 99999999999999999999.0;
    if (bClear) then
        ClearNotices(hudPtr);
    end
end

local fnOnPaint = function() -- 🤍💙💖
    fnMain(false);
end

register_callback("paint", fnOnPaint)
register_callback("round_start", function (event)
    bClear = true;
end)
register_callback("unload", function()
    bClear = true;
    fnMain(true);
end)