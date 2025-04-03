local sv_maxunlag_ref = ui.reference("MISC", "Settings", "sv_maxunlag") -- reference for sv_maxunlag
local sv_maxusrcmdprocessticks_ref = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks") -- reference for sv_maxusrcmdprocessticks
local fakelag_limit_ref = ui.reference("AA", "Fake lag", "Limit") -- reference for fakelag limit
local fakelag_enabled_ref = ui.reference("AA", "Fake lag", "Enabled") -- reference for fakelag enable
local leg_movement_ref = ui.reference("AA", "Other", "Leg movement") -- reference for leg movement
local fakeduck_ref = ui.reference("RAGE", "Other", "Duck peek assist") -- reference for fakeduck

-- caching convars for easier access
local convars = {
    ["sv_maxusrcmdprocessticks"] = cvar["sv_maxusrcmdprocessticks"],
    ["sv_maxunlag"] = cvar["sv_maxunlag"]
}

-- making chokedcommands global for paint event
local choked_commands = {amount = 0}

-- setting both hidden elements visible
ui.set_visible(sv_maxunlag_ref, true)
ui.set_visible(sv_maxusrcmdprocessticks_ref, true)

-- button for forcing fakelag to slider value
ui.new_button(
    "MISC",
    "Settings",
    "Force fakelag to value",
    function()
        ui.set(fakelag_limit_ref, ui.get(sv_maxusrcmdprocessticks_ref) - 2)
    end
)

client.set_event_callback(
    "round_prestart",
    function(e)
        client.log(
            string.format(
                "round_prestart: maximum chokable forced fakelag limit %d, maximum chokable raw convar fakelag limit %d",
                ui.get(sv_maxusrcmdprocessticks_ref) - 2,
                convars.sv_maxusrcmdprocessticks:get_int() - 2
            )
        )

        if (convars.sv_maxusrcmdprocessticks:get_int() - 2 < ui.get(sv_maxusrcmdprocessticks_ref) - 2) then
            ui.set(fakelag_limit_ref, ui.get(sv_maxusrcmdprocessticks_ref) - 2)
        else
            ui.set(fakelag_limit_ref, convars.sv_maxusrcmdprocessticks:get_int() - 2)
        end
    end
)

client.set_event_callback(
    "setup_command",
    function(e)
        -- fixing fakeduck
        if (ui.get(fakeduck_ref)) then
            ui.set(fakelag_limit_ref, 14)
        else
            ui.set(fakelag_limit_ref, ui.get(sv_maxusrcmdprocessticks_ref) - 2)
        end

        if (e.chokedcommands > 16) then
            choked_commands.amount = e.chokedcommands
            ui.set(leg_movement_ref, "Always slide")
        else
            choked_commands.amount = 0
            ui.set(leg_movement_ref, "Never slide")
        end
    end
)

client.set_event_callback(
    "paint",
    function()
        if (ui.get(fakelag_enabled_ref) and entity.is_alive(entity.get_local_player())) then
            local percentage = choked_commands.amount * 100 / ui.get(sv_maxusrcmdprocessticks_ref)

            local color = {
                -- thanks to rave
                255 - (percentage / 1.62 * 2.29824561404),
                percentage / 1.62 * 3.42105263158,
                percentage / 1.62 * 0.22807017543
            }

            local vert = renderer.indicator(color[1], color[2], color[3], 255, "PEEK")

            -- what the fuck even are these numbers
            renderer.circle_outline(90, vert + 19, 0, 0, 0, 150, 10, 0, 1, 5)
            renderer.circle_outline(90, vert + 19, color[1], color[2], color[3], 255, 9, 0, percentage / 100, 4)
        end
    end
)

client.set_event_callback(
    "shutdown",
    function()
        -- setting both hidden elements invisible upon shutdown
        ui.set_visible(sv_maxunlag_ref, false)
        ui.set_visible(sv_maxusrcmdprocessticks_ref, false)
    end
)
