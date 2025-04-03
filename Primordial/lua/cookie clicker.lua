local current_score = menu.add_text("cookie-clicker", "current score : 0")
local multiply_score = menu.add_text("cookie-clicker", "multiply : 1x")

current_score_int = 0
multiply_score_int = 1

local function curr_score_add()
    current_score_int = tonumber(current_score_int + multiply_score_int)
    current_score:set(tostring("current score : " .. current_score_int))
end

local button = menu.add_button("cookie-clicker", "click!", curr_score_add)

local function multi_upgrade()
    if current_score_int >= 150 then
        current_score_int = tonumber(current_score_int - 150)
        if current_score_int < 0 then
            current_score_int = 0
            current_score:set('current score : 0')
        end
        multiply_score_int = multiply_score_int + 1
        multiply_score:set('multiply : ' .. multiply_score_int .. 'x')
        current_score:set(tostring("current score : " .. current_score_int))
    else
        client.log_screen("not enought money for 1x upgrade")
    end
end

local button2 = menu.add_button("cookie-clicker", "1x upgrade (150 clicks)", multi_upgrade)

local function multi_upgrade_2()
    if current_score_int >= 300 then
        current_score_int = tonumber(current_score_int - 300)
        if current_score_int < 0 then
            current_score_int = 0
            current_score:set('current score : 0')
        end
        multiply_score_int = multiply_score_int + 2
        multiply_score:set('multiply : ' .. multiply_score_int .. 'x')
        current_score:set(tostring("current score : " .. current_score_int))
    else
        client.log_screen("not enought money for 2x upgrade")
    end
end

local button3 = menu.add_button("cookie-clicker", "2x upgrade (300 clicks)", multi_upgrade_2)



-- fix
local function fix() current_score:set(tostring("current score : " .. current_score_int))  end
callbacks.add(e_callbacks.PAINT, fix)