-- Variables

local ffi = require("ffi")
local panorama = require("primordial/panorama-library.248")

panorama.open()

local raw_hwnd = memory.find_pattern("engine.dll", "8B 0D ? ? ? ? 85 C9 74 16 8B 01 8B") or error("Invalid signature #1")
local raw_FlashWindow = memory.find_pattern("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7") or error("Invalid signature #2")
local raw_insn_jmp_ecx = memory.find_pattern("gameoverlayrenderer.dll", "FF E1") or error("Invalid signature #3")
local raw_GetForegroundWindow = memory.find_pattern("gameoverlayrenderer.dll", "FF 15 ? ? ? ? 3B C6 74") or error("Invalid signature #4")

local hwnd_ptr = ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", raw_hwnd) + 2)[0])[0] + 2)
local FlashWindow = ffi.cast("int(__stdcall*)(uintptr_t, int)", raw_FlashWindow)
local insn_jmp_ecx = ffi.cast("int(__thiscall*)(uintptr_t)", raw_insn_jmp_ecx)
local GetForegroundWindow = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", raw_GetForegroundWindow) + 2)[0])[0]

local last_realtime = 0
local last_queue_string = ""

local function get_csgo_hwnd()
	return hwnd_ptr[0]
end

local function get_foreground_hwnd()
	return insn_jmp_ecx(GetForegroundWindow)
end

local function notify_user()
	local csgo_hwnd = get_csgo_hwnd()
	if get_foreground_hwnd() ~= csgo_hwnd then
		FlashWindow(csgo_hwnd, 1)
		return true
	end
	return false
end

-- Menu

local match_found = menu.add_checkbox("Notifications", "Match found")
local round_start = menu.add_checkbox("Notifications", "Round start")

-- Callbacks

local function on_round_start()
	if not round_start:get() then
        return
    end

    notify_user()
end

local function on_paint()
	if not match_found:get() then
        return
    end

    local realtime = global_vars.real_time()

    if realtime >= last_realtime then
        local queue_string = panorama.loadstring("return PartyListAPI.GetPartySessionSetting('game/mmqueue')")()

        if last_queue_string ~= "reserved" and queue_string == "reserved" then
            notify_user()
        end

        last_queue_string = queue_string
        last_realtime = realtime + 1
    end
end

callbacks.add(e_callbacks.EVENT, on_round_start, "round_start")
callbacks.add(e_callbacks.PAINT, on_paint)