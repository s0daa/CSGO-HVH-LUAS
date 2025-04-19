-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_delay_call, client_find_signature, globals_realtime, panorama_open, error, print = client.delay_call, client.find_signature, globals.realtime, panorama.open, error, print

local ffi = require "ffi"
local uix = require 'gamesense/uix'

local js = panorama_open()
local last_realtime = 0

local mm_notification_ref
local round_notification_ref

local raw_hwnd 			= client_find_signature("engine.dll", "\x8B\x0D\xCC\xCC\xCC\xCC\x85\xC9\x74\x16\x8B\x01\x8B") or error("Invalid signature #1")
local raw_FlashWindow 	= client_find_signature("gameoverlayrenderer.dll", "\x55\x8B\xEC\x83\xEC\x14\x8B\x45\x0C\xF7") or error("Invalid signature #2")
local raw_insn_jmp_ecx 	= client_find_signature("gameoverlayrenderer.dll", "\xFF\xE1") or error("Invalid signature #3")
local raw_GetForegroundWindow = client_find_signature("gameoverlayrenderer.dll", "\xFF\x15\xCC\xCC\xCC\xCC\x3B\xC6\x74") or error("Invalid signature #4")

local hwnd_ptr 		= ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", raw_hwnd) + 2)[0])[0] + 2)
local FlashWindow 	= ffi.cast("int(__stdcall*)(uintptr_t, int)", raw_FlashWindow)
local insn_jmp_ecx 	= ffi.cast("int(__thiscall*)(uintptr_t)", raw_insn_jmp_ecx)
local GetForegroundWindow = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", raw_GetForegroundWindow) + 2)[0])[0]

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

local function on_round_start()
	if notify_user() then
		client_delay_call(1, on_round_start)
	end
end

local function on_paint_ui()
	local realtime = globals_realtime()
	if realtime >= last_realtime then
		if js.PartyListAPI.GetPartySessionSetting("game/mmqueue") == "reserved" then
			notify_user()
		end
		last_realtime = globals_realtime() + 1
	end
end

do
	mm_notification_ref = uix.new_checkbox("LUA", "A", "Notify on match found")
	mm_notification_ref:on("paint_ui", on_paint_ui)
	mm_notification_ref:set(true)

	round_notification_ref = uix.new_checkbox("LUA", "A", "Notify on round start")
	round_notification_ref:on("round_start", on_round_start)
	round_notification_ref:set(true)
end