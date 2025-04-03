local buybot_ref = menu.find("misc", "utility", "buybot", "enable")

local function OnEvent(event)
    if event.name == "round_prestart" then
        local is_valve = game_rules.get_prop("m_bIsValveDS") == 1
        if is_valve and buybot_ref:get() then
            buybot_ref:set(false)
            print("Disabled buybot due to Valve server")
        elseif not is_valve and not buybot_ref:get() then
            buybot_ref:set(true)
            print("Enabled buybot due to community server")
        end
    end
end

callbacks.add(e_callbacks.EVENT, OnEvent)