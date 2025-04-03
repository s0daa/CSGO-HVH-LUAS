client.log_screen('Lua created by bugpimp42.')

local enable = menu.add_checkbox("Main", "Enable")
local keybind = enable:add_keybind("Fakelag Keybind")
local slider = menu.add_slider("Main", "Fakelag Amount", 0, 61)

local info1 = menu.add_text("Information.", "---- Max Limits ----")
local info2 = menu.add_text("Information.", "chairhvh: 17")
local info3 = menu.add_text("Information.", "desynchvh: 60")

local backupmaxusr = cvars.sv_maxusrcmdprocessticks:get_int()

callbacks.add(e_callbacks.PAINT, function()
    keybind:set_visible(enable:get())
    slider:set_visible(enable:get())
end)

callbacks.add(e_callbacks.ANTIAIM, function(ctx)
    local bRunBack = false

    if exploits.get_charge() > 0 then
        if not bRunBack then
            cvars.sv_maxusrcmdprocessticks:set_int(backupmaxusr)
            ctx:set_fakelag(true)
            bRunBack = true
        end

        return
    end

    bRunBack = false

    local bRunOnce = false

    if enable:get() and keybind:get() then
        cvars.sv_maxusrcmdprocessticks:set_int(slider:get() + 2)

        if engine.get_choked_commands() < slider:get() then
            ctx:set_fakelag(true)
        else
            ctx:set_fakelag(false)
        end

        bRunOnce = true
    else
        if bRunOnce then
            cvars.sv_maxusrcmdprocessticks:set_int(backupmaxusr)
            ctx:set_fakelag(true)
            bRunOnce = false
        end
    end
end)