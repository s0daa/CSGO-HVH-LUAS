client.log_screen('Lua created by bugpimp42.')

local enable    = menu.add_checkbox("Main", "Enable", false)
local aatyp     = menu.add_selection("Main", "Anti-Aim Mode", {"Static", "Jitter", "Custom"})
local side2     = menu.add_selection("Main", "Anti-Aim Side", {"Left", "Right", "Jitter"})
local leftamt2  = menu.add_slider("Main", "Left Amount", 0, 60)
local rigtamt2  = menu.add_slider("Main", "Right Amount", 0, 60)
local modifiers = menu.add_multi_selection("Main", "Modifiers", {"Static in air", "Static when crouched"})

local yawadd    = menu.find("antiaim", "main", "angles", "yaw add")
local side      = menu.find("antiaim", "main", "desync", "side")
local leftamt   = menu.find("antiaim", "main", "desync", "left amount")
local rigtamt   = menu.find("antiaim", "main", "desync", "right amount")
local bCrouchin = false
local bInAir    = false

callbacks.add(e_callbacks.PAINT, function()
    aatyp:set_visible(enable:get())

    if enable:get() then
        leftamt2:set_visible(aatyp:get() == 3)
        rigtamt2:set_visible(aatyp:get() == 3)
        side2:set_visible(aatyp:get() == 3)
        modifiers:set_visible(aatyp:get() == 3)
    else
        leftamt2:set_visible(false)
        rigtamt2:set_visible(false)
        side2:set_visible(false)
        modifiers:set_visible(false)
    end

    menu.find("antiaim", "main", "desync", "override stand#move"):set(false)
    menu.find("antiaim", "main", "desync", "override stand#slow walk"):set(false)
end)

callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
    local local_player = entity_list.get_local_player()

    if not local_player:has_player_flag(e_player_flags.ON_GROUND) then
		bInAir = true
	else
		bInAir = false
	end

    if cmd:has_button(e_cmd_buttons.DUCK) and not inaircrc then
        bCrouchin = true
    else
        bCrouchin = false
    end
end)

callbacks.add(e_callbacks.ANTIAIM, function(ctx)
    local local_player = entity_list.get_local_player()
    local bRunOnceAir  = nil
    local bRunOnceGrnd = nil
    
    if enable:get() then
        if aatyp:get() == 1 then
            leftamt:set(14)
            rigtamt:set(11)
            yawadd:set(0)
            side:set(3)
        elseif aatyp:get() == 2 then
            leftamt:set(16)
            rigtamt:set(18)

            if not bInAir then
                side:set(4)
                yawadd:set(-2)
            elseif bInAir and bCrouchin then
                yawadd:set(0)
                side:set(3)
            end
        elseif aatyp:get() == 3 then
            yawadd:set(0)
            leftamt:set(leftamt2:get() * 10/6)
            rigtamt:set(rigtamt2:get() * 10/6)

            if not modifiers:get(1) and not modifiers:get(2) then
                side:set(side2:get() + 1)
            end

            if modifiers:get(1) then
                if bInAir then
                    bRunOnceAir = false
                    side:set(3)
                else
                    if not bRunOnceAir then
                        side:set(side2:get() + 1)
                        bRunOnceAir = true
                    end
                end
            end

            if modifiers:get(2) then
                if bCrouchin then
                    side:set(3)
                    bRunOnceGrnd = false
                else
                    if not bRunOnceGrnd then
                        side:set(side2:get() + 1)
                        bRunOnceGrnd = true
                    end
                end
            end
        end
    end
end)