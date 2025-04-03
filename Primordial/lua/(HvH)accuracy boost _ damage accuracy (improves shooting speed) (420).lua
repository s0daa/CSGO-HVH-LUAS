local g_master_switch = menu.add_checkbox( 'main', 'accuracy boost', false )
local g_accuracy_boost_amount = menu.add_slider('main', 'accuracy boost amount', 0, 100, 1, 0, "%")
local g_per_hitbox = menu.add_checkbox( 'main', 'accuracy boost per specific hitbox', false )
local g_ab_amount_head = menu.add_slider('main', '[head] accuracy boost amount', 0, 100, 1, 0, "%")
local g_ab_amount_chest = menu.add_slider('main', '[chest] accuracy boost amount', 0, 100, 1, 0, "%")
local g_ab_amount_arms = menu.add_slider('main', '[arms] accuracy boost amount', 0, 100, 1, 0, "%")
local g_ab_amount_stomach = menu.add_slider('main', '[stomach] accuracy boost amount', 0, 100, 1, 0, "%")
local g_ab_amount_legs = menu.add_slider('main', '[legs] accuracy boost amount', 0, 100, 1, 0, "%")
local g_ab_amount_feet = menu.add_slider('main', '[feet] accuracy boost amount', 0, 100, 1, 0, "%")

local g_time = menu.add_checkbox( 'misc', 'display time in watermark', false )

local function watermarkDraw()

    local sys_time = { client.get_local_time() }
    local actual_time = ('%02d:%02d'):format(sys_time[1], sys_time[2])

    return g_time:get() and ("primordial - %s - %s"):format(user.name, actual_time) or ("primordial - %s"):format(user.name)
end

callbacks.add(e_callbacks.DRAW_WATERMARK, watermarkDraw)

local function on_hitscan(ctx, cmd, unpredicted_data)

    if not g_master_switch:get( ) then
        return
    end

    if not g_per_hitbox:get() then 
        ctx:set_damage_accuracy(g_accuracy_boost_amount:get( ))
    else
        ctx:set_damage_accuracy(g_ab_amount_head:get(), e_hitscan_groups.HEAD)
        ctx:set_damage_accuracy(g_ab_amount_chest:get(), e_hitscan_groups.CHEST)
        ctx:set_damage_accuracy(g_ab_amount_arms:get(), e_hitscan_groups.ARMS)
        ctx:set_damage_accuracy(g_ab_amount_stomach:get(), e_hitscan_groups.STOMACH)
        ctx:set_damage_accuracy(g_ab_amount_legs:get(), e_hitscan_groups.LEGS)
        ctx:set_damage_accuracy(g_ab_amount_feet:get(), e_hitscan_groups.FEET)
    end
end

callbacks.add(e_callbacks.HITSCAN, on_hitscan)

local function on_paint()
    g_accuracy_boost_amount:set_visible(g_master_switch:get() and not (g_per_hitbox:get()))
    g_per_hitbox:set_visible(g_master_switch:get())
    g_ab_amount_head:set_visible(g_master_switch:get() and g_per_hitbox:get())
    g_ab_amount_chest:set_visible(g_master_switch:get() and g_per_hitbox:get())
    g_ab_amount_stomach:set_visible(g_master_switch:get() and g_per_hitbox:get())
    g_ab_amount_legs:set_visible(g_master_switch:get() and g_per_hitbox:get())
    g_ab_amount_feet:set_visible(g_master_switch:get() and g_per_hitbox:get())
    g_ab_amount_arms:set_visible(g_master_switch:get() and g_per_hitbox:get())
end

callbacks.add(e_callbacks.PAINT, on_paint)