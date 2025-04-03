-- made by danix

local toggle = menu.add_checkbox("HP", "Enable", false)
local dropdown = menu.add_multi_selection("HP", "Weapons", {"Scout", "AWP"})
local Scout_dmg = menu.add_slider("HP", "[SCOUT] HP+", 1, 5)
local Scout_dmg_acc = menu.add_slider("HP", "[SCOUT] DMG Accuracy", 0, 100, 1, 0, "%")
local Scout_baim_thing = menu.add_checkbox("HP", "[SCOUT] Force baim if lethal", false)
local Awp_dmg = menu.add_slider("HP", "[AWP] HP+", 1, 5)
local Awp_dmg_acc = menu.add_slider("HP", "[AWP] DMG Accuracy", 0, 100, 1, 0, "%")
local Awp_baim_thing = menu.add_checkbox("HP", "[AWP] Force baim if lethal", false)

local function handle_vis()
    dropdown:set_visible(toggle:get())
    Scout_dmg:set_visible(dropdown:get(1) and toggle:get())
    Scout_dmg_acc:set_visible(dropdown:get(1) and toggle:get())
    Scout_baim_thing:set_visible(dropdown:get(1) and toggle:get())
    Awp_dmg:set_visible(dropdown:get(2) and toggle:get())
    Awp_dmg_acc:set_visible(dropdown:get(2) and toggle:get())
    Awp_baim_thing:set_visible(dropdown:get(2) and toggle:get())
end

local function set_dmg(ctx)
    if not ctx or not ctx.player:is_alive() or ctx == nil then
        return
    end

    local health = ctx.player:get_prop("m_iHealth")

    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    local cur_weapon = local_player:get_active_weapon():get_name()
    if not cur_weapon then
        return
    end

    local scout_ovr = menu.find("aimbot", "scout", "target overrides", "min. damage")[2]:get()
    local awp_ovr = menu.find("aimbot", "awp", "target overrides", "min. damage")[2]:get()

    if cur_weapon == "ssg08" and dropdown:get(1) and toggle:get() and not scout_ovr then
        if Scout_baim_thing:get() and health < 65 then -- too lazy to add slider just change the number lol
            ctx:set_hitscan_group_state(e_hitscan_groups.HEAD, false)
        end
        ctx:set_min_dmg(tonumber(health + Scout_dmg:get()))
        ctx:set_damage_accuracy(Scout_dmg_acc:get())
    elseif cur_weapon == "awp" and dropdown:get(2) and toggle:get() and not awp_ovr then
        if Awp_baim_thing:get() and health < 80 then -- too lazy to add slider just change the number lol
            ctx:set_hitscan_group_state(e_hitscan_groups.HEAD, false)
        end
        ctx:set_min_dmg(tonumber(health + Awp_dmg:get()))
        ctx:set_damage_accuracy(Awp_dmg_acc:get())
    end
end

callbacks.add(e_callbacks.PAINT, handle_vis)
callbacks.add(e_callbacks.HITSCAN, set_dmg)