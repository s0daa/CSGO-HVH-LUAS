local ffi = require("ffi")

local FindElement = ffi.cast("unsigned long(__thiscall*)(void*, const char*)", memory.find_pattern("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28"))
local CHudChat = FindElement(ffi.cast("unsigned long**", ffi.cast("uintptr_t", memory.find_pattern("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 8B 5D 08")) + 1)[0], "CHudChat")
local FFI_ChatPrint = ffi.cast("void(__cdecl*)(int, int, int, const char*, ...)", ffi.cast("void***", CHudChat)[0][27])

local function PrintInChat(text)
    FFI_ChatPrint(CHudChat, 0, 0, string.format("%s ", text))
end

local hitgroups = {
	[0] = "n/a",
  [1] = "头",
    [2] = "胸",
    [3] = "胃",
    [4] = "左胳膊",
    [5] = "右胳膊",
    [6] = "左腿",
    [7] = "右腿",
    [8] = "左腿",
    [9] = "右小腿",
    [10] = "左小腿",
    [11] = "右脚",
    [12] = "左脚",
    [13] = "右手",
    [14] = "左手",
    [15] = "right upper arm",
    [16] = "right forearm",
    [17] = "left upper arm",
    [18] = "left forear"

}

local logsCheckbox = menu.add_checkbox("Ragebot", "日志")
local logsSelection = menu.add_multi_selection("Ragebot", "日志类型", {"Miss", "Hit" --[[, "Hurt", "Purchase"]]})

local function logFunction()
    local logsValue = logsCheckbox:get()
    
    if logsValue == true then
        logsSelection:set_visible(true)
    else
        logsSelection:set_visible(false)
        logsSelection:set(1, false)
        logsSelection:set(2, false)
        -- logsSelection:set(3, false)
        -- logsSelection:set(4, false)
    end
end

local function missLogs(shot)
    local missValue = logsSelection:get("Miss")

    if missValue == true then
        PrintInChat('\x0C水墨云烟 \x01» \x08空了 \x07' ..shot.player:get_name().. '\x08 因为 \x03' ..shot.reason_string.. '\x08 ， \x10' ..shot.backtrack_ticks.. '\x08 ms 回溯. 预测伤害 \x0B' ..shot.aim_damage.. '\x08 ， 命中率 \x05' ..shot.aim_hitchance.. '\x08.')
	    print('\x0C水墨云烟 \x01» \x08空了 \x07' ..shot.player:get_name().. '\x08 因为 \x03' ..shot.reason_string.. '\x08 ， \x10' ..shot.backtrack_ticks.. '\x08 ms 回溯. 预测伤害 \x0B' ..shot.aim_damage.. '， 命中率' ..shot.aim_hitchance.. '\x08.')
    end
end

local function hitLogs(shot)
    local hitValue = logsSelection:get("Hit")
    local hgroup = hitgroups[shot.hitgroup]

    if hitValue == true then
        PrintInChat('\x07水墨云烟 \x01» \x08击中 \x07'..shot.player:get_name()..'\x10'..hgroup..'\x08 造成 \x0B'..shot.damage..'\08 伤害， \x05'..shot.aim_hitchance..'\x08 命中率 ， 预测伤害 \x03' ..shot.aim_damage.. ' \x08 ， \x04'..shot.backtrack_ticks..'\x08 ms 回溯.')
	    print('\x07水墨云烟 \x01» \x08击中 \x07'..shot.player:get_name()..'\x10'..hgroup..'\x08 造成 \x0B'..shot.damage..'\08 伤害， \x05'..shot.aim_hitchance..'\x08 命中率 ， 预测伤害 \x03' ..shot.aim_damage.. ' \x08 ， \x04'..shot.backtrack_ticks..'\x08 ms 回溯.')
    end
end

callbacks.add(e_callbacks.PAINT, logFunction)
callbacks.add(e_callbacks.AIMBOT_MISS, missLogs)
callbacks.add(e_callbacks.AIMBOT_HIT, hitLogs)