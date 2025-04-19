local friendly_fire = ui.new_checkbox("Rage", "Other", "DDoS")
local function handle_friendly_fire()
    local state = ui.get(friendly_fire) and 1 or 0
    cvar.mp_teammates_are_enemies:set_raw_int(state)
end
handle_friendly_fire()
ui.set_callback(friendly_fire, handle_friendly_fire)