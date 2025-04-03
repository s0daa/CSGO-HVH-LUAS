local ffi = require("ffi")
ffi.cdef[[
    typedef struct {
        unsigned short wYear;
        unsigned short wMonth;
        unsigned short wDayOfWeek;
        unsigned short wDay;
        unsigned short wHour;
        unsigned short wMinute;
        unsigned short wSecond;
        unsigned short wMilliseconds;
    } SYSTEMTIME, *LPSYSTEMTIME;
    
    void GetSystemTime(LPSYSTEMTIME lpSystemTime);
    void GetLocalTime(LPSYSTEMTIME lpSystemTime);
]]

local FindElement = ffi.cast("unsigned long(__thiscall*)(void*, const char*)", memory.find_pattern("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28"))
local CHudChat = FindElement(ffi.cast("unsigned long**", ffi.cast("uintptr_t", memory.find_pattern("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 8B 5D 08")) + 1)[0], "CHudChat")
local FFI_ChatPrint = ffi.cast("void(__cdecl*)(int, int, int, const char*, ...)", ffi.cast("void***", CHudChat)[0][27])

local function PrintInChat(text)
    FFI_ChatPrint(CHudChat, 0, 0, string.format("%s ", text))
end



local logsCheckbox = menu.add_checkbox("空枪日志", "开启")
local logsSelection = menu.add_multi_selection("空枪日志", "选择", {"空枪", "命中"})

local function logFunction()
    local logsValue = logsCheckbox:get()
    
    if logsValue == true then
        logsSelection:set_visible(true)
    else
        logsSelection:set_visible(false)
        logsSelection:set(1, false)
        logsSelection:set(2, false)
    end
end

local function missLogs(shot)
    local missValue = logsSelection:get("空枪")

    if missValue == true then
        PrintInChat('\x01[\x0CPrimordial\x01] \x08空了:\x07' ..shot.player:get_name().. '\x08 原因:\x03' ..shot.reason_string.. '\x08 尝试\x10' ..shot.backtrack_ticks.. '\x08ms的回溯 预计伤害:\x0B' ..shot.aim_damage.. '\x08 命中率:\x05' ..shot.aim_hitchance.. '\x08')
	    print('\x01[\x0CPrimordial\x01] \x08空了:\x07' ..shot.player:get_name().. '\x08 原因:\x03' ..shot.reason_string.. '\x08 尝试\x10' ..shot.backtrack_ticks.. '\x08ms的回溯 预计伤害:\x0B' ..shot.aim_damage.. '命中率:' ..shot.aim_hitchance.. '\x08.')
    end
end

local function hitLogs(shot)
    local hitValue = logsSelection:get("命中")

    if hitValue == true then
        PrintInChat('\x01[\x0CPrimordial\x01] \x08命中玩家  \x07'..shot.player:get_name()..'\x08 造成伤害:\x0B'..shot.damage..'\08 命中率:\x05'..shot.aim_hitchance..'\x08 预计伤害:\x03' ..shot.aim_damage.. ' \x08 尝试\x04'..shot.backtrack_ticks..'\x08ms的回溯')
	    print('\x01[\x0CPrimordial\x01] \x08命中玩家  \x07'..shot.player:get_name()..'\x08 造成伤害:\x0B'..shot.damage..'\08 命中率:\x05'..shot.aim_hitchance..'\x08 预计伤害:\x03' ..shot.aim_damage.. ' \x08 尝试\x04'..shot.backtrack_ticks..'\x08ms的回溯')
    end
end

callbacks.add(e_callbacks.PAINT, logFunction)
callbacks.add(e_callbacks.AIMBOT_MISS, missLogs)
callbacks.add(e_callbacks.AIMBOT_HIT, hitLogs)