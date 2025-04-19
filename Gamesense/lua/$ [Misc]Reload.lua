local name = "cancel_reload_animation"

local client_color_log = client.color_log 
local client_delay_call = client.delay_call
local client_set_event_callback = client.set_event_callback
local client_exec = client.exec

local entity_get_prop = entity.get_prop
local entity_get_player_weapon = entity.get_player_weapon
local entity_get_local_player = entity.get_local_player

local ui_get = ui.get
local ui_new_checkbox = ui.new_checkbox

local globals_tickcount = globals.tickcount

local function lua_log(...)
	client_color_log(153, 153, 255, "[" .. name .. "]\0")
	client_color_log(217, 217, 217, " ", ...)
end

local enable = ui_new_checkbox("MISC", "Miscellaneous", "\a78A3FFFF!!!Advanced projects\aFFFFFFFF cancel_reload_animation")

local pastAmmo = 0
local switchTick = -1

local function on_run_command()
	if ui_get(enable) then
		if switchTick ~= -1 and switchTick + 1 < globals_tickcount() then
			client_exec("lastinv")
			switchTick = -1
			lua_log("cancel_reload_animation")
		else
			local weapon = entity_get_player_weapon(entity_get_local_player())
			local currentAmmo = entity_get_prop(weapon, "m_iClip1")
			local reloading = entity_get_prop(weapon, "m_bInReload") == 1

			if reloading and currentAmmo > pastAmmo then
				client_exec("slot3")
				switchTick = globals_tickcount()
			else
				pastAmmo = currentAmmo
			end
		end
	end
end

client_set_event_callback("run_command", on_run_command)
