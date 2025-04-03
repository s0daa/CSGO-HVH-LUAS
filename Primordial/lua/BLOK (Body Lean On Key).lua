client.log_screen('Lua created by bugpimp42.')

local enable    = menu.add_checkbox("Main", "Enable BLOK (Body Lean On Key)")
local keybind   = enable:add_keybind("BLOK Bind")
local bloktype  = menu.add_selection("Main", "Body lean type", {"Static", "Static Jitter", "Random Jitter", "Sway"})
local blokvalue = menu.add_slider("Main", "Body lean value", -50, 50)
local jitterval = menu.add_slider("Main", "Body lean jitter value", 0, 50)

local bruh      = menu.add_text("Information.", "Since extended angles has a bind.")
local bruhpt2   = menu.add_text("Information.", "Why shouldn't Body lean?")

local bdylean   = menu.find("antiaim", "main", "angles", "body lean")
local leanamt   = menu.find("antiaim", "main", "angles", "body lean value")

local bSwitcher = false

local function comit_tax_fraud() -- yes.
    if not enable:get() then
        return
    end

    if keybind:get() then
        bdylean:set(2)

        if bloktype:get() == 1 then --     Static.
            leanamt:set(blokvalue:get())
        elseif bloktype:get() == 2 then -- Jitter.
            leanamt:set(bSwitcher and jitterval:get() or -jitterval:get())
        elseif bloktype:get() == 3 then -- Random Jitter.
            leanamt:set(client.random_int(-jitterval:get(), jitterval:get()))
        elseif bloktype:get() == 4 then -- Sway.
            leanamt:set(math.sin(global_vars.cur_time() * 5) * blokvalue:get())
        end
    else
        bdylean:set(0)
        leanamt:set(0)
    end
end

callbacks.add(e_callbacks.PAINT, function()
    keybind:set_visible(enable:get())
    bloktype:set_visible(enable:get())

    if enable:get() and bloktype:get() > 1 and bloktype:get() < 4 then
        jitterval:set_visible(true)
        blokvalue:set_visible(false)
    elseif enable:get() and bloktype:get() ~= 2 and bloktype:get() ~= 3 then
        jitterval:set_visible(false)
        blokvalue:set_visible(true)
    elseif not enable:get() then
        jitterval:set_visible(false)
        blokvalue:set_visible(false)
    end

    bSwitcher = not bSwitcher

    comit_tax_fraud()
end)