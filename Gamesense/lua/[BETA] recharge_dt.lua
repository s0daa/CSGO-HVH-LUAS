local weapons = require("gamesense/csgo_weapons")

local menu_refs = {
    ["aimbot"] = ui.reference("RAGE", "Aimbot", "Enabled"),
    ["doubletap"] = { ui.reference("RAGE", "Aimbot", "Double tap") },
    ["hideshots"] = { ui.reference("AA", "Other", "On shot anti-aim") }
}

local timer = globals.tickcount()
local scriptleakstop = 14

local ctx = (function()
    local ctx = {}

    ctx.recharge = {
        run = function()
            local lp = entity.get_local_player()

            if not entity.is_alive(lp) then return end

            local lp_weapon = entity.get_player_weapon(lp)
            if not lp_weapon then return end

            scriptleakstop = weapons(lp_weapon).is_revolver and 17 or 14
 
            if ui.get(menu_refs["doubletap"][2]) or ui.get(menu_refs["hideshots"][2]) then
                if globals.tickcount() >= timer + scriptleakstop then
                    ui.set(menu_refs["aimbot"], true)
                else
                    ui.set(menu_refs["aimbot"], false)
                end
            else
                timer = globals.tickcount()
                ui.set(menu_refs["aimbot"], true)
            end
        end
    }

    return ctx
end)()

client.set_event_callback('setup_command', function(cmd)
    ctx.recharge.run()
end)

client.set_event_callback('level_init', function()
    timer = globals.tickcount()
end)
