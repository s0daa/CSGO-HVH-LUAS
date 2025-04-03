-- advanced fakelag builder
    -- developed by real timLP187

    local conditions = {
        "global",
        "stand",
        "slowwalk", 
        "move",
        "duck",
        "air",
        "air duck",
        "enemy visible",
        "keybind",
    }

    local references = {
        menu = {
            conditionselection  = menu.add_list("antiaim builder", "select condition", conditions),
            conditionenable     = menu.add_multi_selection("antiaim builder", "enabled conditions", {"stand","slowwalk", "move","duck","air","air duck","enemy visible","keybind"}),
            keybindbox          = menu.add_text("antiaim builder", "set keybind for condition"),
        },
        fakelagfinds = {
            -- angles
            menu.find("antiaim", "main", "fakelag", "amount"),
            menu.find("antiaim", "main", "fakelag", "break lag compensation"),
        },
        miscfinds = {
            slowwalk = menu.find("misc", "main", "movement", "slow walk"),
        }
    }

    -- idk why but this dont work in array 
    -- confused
    local keybind = references.menu.keybindbox:add_keybind("condition keybind")

    -- creates menu
    local active_elements = {}
    local hidden_elements = {}

    for i = 1, #conditions do
        active_elements[i] = {

            menu.add_slider("[".. conditions[i] .. "]", "amount", 0, 15),
            menu.add_checkbox("[".. conditions[i] .. "]", "break lag compensation", false),

            menu.set_group_column("[".. conditions[i] .. "]", 1),


        }
        hidden_elements[i] = menu.add_text("", "")
        hidden_elements[i]:set_visible(false)
    end


    -- returns player speed
    local function handle_speed(player)

        if not engine.is_connected() or not engine.is_in_game() then
            return
        else

        x = player:get_prop("m_vecVelocity[0]")
        y = player:get_prop("m_vecVelocity[1]")
        z = player:get_prop("m_vecVelocity[2]")
        if x == nil then return end
            return math.sqrt(x*x + y*y + z*z)
        end
    end

    -- returns true or false if enemy is visible
    local function handle_enemyvisible()
        if not engine.is_connected() or not engine.is_in_game() then
            return        
        else
        local is_point_visible = function(ent)
            local e_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
            if entity_list.get_local_player():is_point_visible(e_pos) then
                return true
            else
                return false
            end
        end
                    local enemies= entity_list.get_players(true)
            local local_player = entity_list.get_local_player()   
            local can_see = false
        
        
            for _, enemy in pairs(enemies) do
                if is_point_visible(enemy) then
                    can_see = true
                end
            end
    
                return can_see
        end
    end

    -- returns condition (1 to 6)
    local function handle_condition()

        if not engine.is_connected() or not engine.is_in_game() then
            return
        else

        local condition = {}
        condition.localplayer   = entity_list.get_local_player()
        condition.speed         = math.floor(handle_speed(condition.localplayer))
        condition.ducked        = condition.localplayer:get_prop("m_bDucked") == 1
        condition.air           = condition.localplayer:get_prop("m_vecVelocity[2]") ~= 0
        condition.choked        = engine.get_choked_commands()
        condition.charge        = exploits.get_charge()

        condition.enemyvisible  = handle_enemyvisible()

            -- global
        condition.value         = 1

            -- stand
        if condition.speed < 10 and not condition.air and not condition.ducked and references.menu.conditionenable:get(1) then
            condition.value = 2

            -- slowwalk
        elseif references.miscfinds.slowwalk[2]:get( ) == true and references.menu.conditionenable:get(2) then
            condition.value = 3

            -- move
        elseif condition.speed > 10 and not condition.air and not condition.ducked and references.menu.conditionenable:get(3) then
            condition.value = 4

            -- duck
        elseif condition.ducked and not condition.air and references.menu.conditionenable:get(4) then
            condition.value = 5

            -- air
        elseif condition.air and not condition.ducked and references.menu.conditionenable:get(5) then
            condition.value = 6

            -- air and duck
        elseif condition.ducked and condition.air and references.menu.conditionenable:get(6) then
            condition.value = 7
        end

            -- enemy visible
        if condition.enemyvisible and references.menu.conditionenable:get(7) then
            condition.value = 8
        end

            -- keybind
        if keybind:get() and references.menu.conditionenable:get(8) then
            condition.value = 9
        end



        return condition.value
    end
end


local function handle_fakelag(condition)

    local fakelag =  active_elements[condition]
    local returns = {
        fakelag[1]:get(),
        fakelag[2]:get(),
    }

    return returns

end


local function on_antiaim()

        condition = handle_condition()
        local fakelag = handle_fakelag(condition)

        for i = 1, #references.fakelagfinds do
            references.fakelagfinds[i]:set(fakelag[i])
        end


end

local function on_paint()
        -- hides not selected menu items
        for i = 1, #conditions  do
            local main = references.menu.conditionselection:get() == i

            for n = 1, 2 do
                active_elements[i][n]:set_visible(main)

            end

        end
end

    callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
    callbacks.add(e_callbacks.PAINT, on_paint)