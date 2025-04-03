local player_names = {}

local players_selectable = nil

local master_switch = menu.add_checkbox("Repeat What He Said", "Master Switch", true)

local say_player_names = menu.add_checkbox("Repeat What He Said", "Say Player Names", false)
local show_dead_alive_status = menu.add_checkbox("Repeat What He Said", "Show Dead Status", false)

function init_player_names()
    --menu.add_multi_selection
    if not engine.is_connected() then return end

    for i = 1, global_vars.max_clients(), 1 do
        local ent = entity_list.get_entity(i)
        local ent_name = ""
        if ent == nil then
            ent_name = ""
        else
            ent_name = ent:get_name()
        end
        
        table.insert(player_names, "[" .. tostring(i) .. "] " .. ent_name)
    end

    if players_selectable == nil then
        players_selectable = menu.add_multi_selection("Repeat What He Said", "Players", player_names)
    end

    local master_visible = master_switch:get()
    say_player_names:set_visible(master_visible)
    show_dead_alive_status:set_visible(master_visible)
    if players_selectable ~= nil then
        players_selectable:set_visible(master_visible)
    end
end

function on_event(event)
    if event.name == "player_say" then
        if not master_switch:get() then return end
        local pl_usid = event.userid
        local pl_text = event.text

        local ent = entity_list.get_player_from_userid(pl_usid)
        if ent ~= nil then
            local ent_idx = ent:get_index()
            local ent_name = ent:get_name()

            if players_selectable ~= nil then
                if players_selectable:get(tonumber(ent_idx)) == true then
                    if say_player_names:get() then
                        pl_text = ent_name .. " : " .. pl_text
                    end
                    if show_dead_alive_status:get() then
                        if ent:get_prop("m_iHealth") < 1 then
                            pl_text = "*Dead* " .. pl_text
                        end
                    end
                    engine.execute_cmd(string.format("say %s", pl_text))
                end
            end
        else print("Invalid Entity")
        end
    end
end


callbacks.add(e_callbacks.PAINT, function()
    init_player_names()
end)

callbacks.add(e_callbacks.EVENT, on_event)