local checkbox = menu.add_checkbox("Anti-Aim", "Enabled")
select_mode = menu.add_selection("Anti-Aim", "Mode", {"Builder"})
conditions_name = {"Standing", "Moving", "Slowwalking", "Crouching", "Jumping", "Jumping Crouch"}
conditions = menu.add_selection("Anti-Aim", "Condtion", conditions_name)
anim_breakers = menu.add_multi_selection("Anti-Aim", "Anim. Breakers", {"Leg Fucker", "Better legs in-air", "Move Lean"})
air_legs = menu.add_selection("Anti-Aim", "Air Legs", {"Static", "Freeze", "Allah"})



prim = {
    yaw_base = menu.find("antiaim", "main", "angles", "yaw base"),
    yaw_add = menu.find("antiaim", "main", "angles", "yaw add"),
    jitter_mode = menu.find("antiaim", "main", "angles", "jitter mode"),
    jitter_type = menu.find("antiaim", "main", "angles", "jitter type"),
    jitter_add = menu.find("antiaim", "main", "angles", "jitter add"),
    desync_type = menu.find("antiaim", "main", "desync", "side#stand"),
    left_limit = menu.find("antiaim", "main", "desync", "left amount#stand"),
    right_limit = menu.find("antiaim", "main", "desync", "right amount#stand"),
    on_shot = menu.find("antiaim", "main", "desync", "on shot"),
    override_mode_move = menu.find("antiaim", "main", "desync", "override stand#move"),
    override_mode_sw = menu.find("antiaim", "main", "desync", "override stand#slow walk"),
    leg_movement = menu.find("antiaim", "main", "general", "leg slide"),
}

local menu_items = {items = {}}
menu_items.new = function(name, item)
    menu_items.items[name] = item
    return item 
end


custom_antiaim = {}
for i = 1, 6 do 
    custom_antiaim[i] = {
        yaw_base = menu_items.new("yaw_base " .. i, menu.add_selection("Builder", "Yaw Base", {"None", "Viewangle", "At Targets (Crosshair)", "At Targets (Distance)", "Velocity"})),
        yaw_offset_left = menu_items.new("yaw_add_left " .. i, menu.add_slider("Builder", "Yaw Offset Left", -180, 180)),
        yaw_offset_right = menu_items.new("yaw_add_right " .. i, menu.add_slider("Builder", "Yaw Offset Right", -180, 180)),
        jitter_mode = menu_items.new("jitter_mode " .. i, menu.add_selection("Builder", "Jitter Mode", {"Offset", "Center", "3-Way", "5-Way"})),
        jitter_type = menu_items.new("jitter_type " .. i, menu.add_selection("Builder", "Offset Type", {"Static", "Switch", "Random"})),
        jitter_offset = menu_items.new("jitter_offset " .. i, menu.add_slider("Builder", "Offset", -180, 180)),
        jitter_offset2 = menu_items.new("jitter_offset2 " .. i, menu.add_slider("Builder", "Second Offset", -180, 180)),
        desync_type = menu_items.new("desync_type " .. i, menu.add_selection("Builder", "Desync Type", {"Static", "Jitter", "Sway"})),
        left_desync = menu_items.new("left_desync " .. i, menu.add_slider("Builder", "Left Desync", 0, 100)),
        right_desync = menu_items.new("right_desync " .. i, menu.add_slider("Builder", "Right Desync", 0, 100)),
        on_shot = menu_items.new("on_shot " .. i, menu.add_selection("Builder", "On Shot", {"Off", "Opposite", "Same Side", "Random"})),
    }
end


function on_paint()
    select_mode:set_visible(checkbox:get())
    conditions:set_visible(checkbox:get())
    anim_breakers:set_visible(checkbox:get())
    air_legs:set_visible(checkbox:get() and anim_breakers:get(2))
    for i = 1, 6 do
        custom_antiaim[i].yaw_base:set_visible(checkbox:get() and conditions:get() == i)
        custom_antiaim[i].yaw_offset_left:set_visible(checkbox:get() and conditions:get() == i and custom_antiaim[i].yaw_base:get() ~= 1)
        custom_antiaim[i].yaw_offset_right:set_visible(checkbox:get() and conditions:get() == i and custom_antiaim[i].yaw_base:get() ~= 1)
        custom_antiaim[i].jitter_mode:set_visible(checkbox:get() and conditions:get() == i and custom_antiaim[i].yaw_base:get() ~= 1)
        custom_antiaim[i].jitter_type:set_visible(checkbox:get() and conditions:get() == i and custom_antiaim[i].yaw_base:get() ~= 1)
        custom_antiaim[i].jitter_offset:set_visible(checkbox:get() and conditions:get() == i and custom_antiaim[i].yaw_base:get() ~= 1)
        custom_antiaim[i].jitter_offset2:set_visible(checkbox:get() and conditions:get() == i and custom_antiaim[i].yaw_base:get() ~= 1 and custom_antiaim[i].jitter_type:get() ~= 1)
        custom_antiaim[i].desync_type:set_visible(checkbox:get() and conditions:get() == i)
        custom_antiaim[i].left_desync:set_visible(checkbox:get() and conditions:get() == i)
        custom_antiaim[i].right_desync:set_visible(checkbox:get() and conditions:get() == i)
        custom_antiaim[i].on_shot:set_visible(checkbox:get() and conditions:get() == i)
    end
end

local random = setmetatable(
    {},
    {
        __call = function(self, min, max)
            local value = math.random(min, max)
            if min ~= max then
                while value == self.last_value do
                    value = math.random(min, max)
                end
            end

            self.last_value = value
            return value
        end
    }
)

local way_jitter = {
    step = 1,
    steps = {
        [3] = {
            0,
            1,
            -1
        },
        [4] = {
            0,
            -0.5,
            0.5,
            1,
            -1
        }
    }
}
switch_ticks = 0
yaw_offset = 0
local clipboard = require("primordial/clipboard lib.131")
local json = require("primordial/JSON Library.97")
local state_lib = require("primordial/Player state library.641")
local function on_setup_command(cmd)
    if not checkbox:get() then return end
    id = state_lib.get_state()
    if engine.get_choked_commands() == 0 then
        switch_ticks = switch_ticks + 1
        if switch_ticks == 5 then
            switch_ticks = 1
        end
    end


    get_yaw = antiaim.get_desync_side() == 2 and custom_antiaim[id].yaw_offset_left:get() or custom_antiaim[id].yaw_offset_right:get()
    if custom_antiaim[id].jitter_mode:get() > 2 then
        yaw_offset = 0
        if engine.get_choked_commands() == 0 then
            way_jitter.step = way_jitter.step + 1
            if way_jitter.step > (custom_antiaim[id].jitter_mode:get() == 4 and 5 or 3) then
                way_jitter.step = 1
            end
        end
        if not (custom_antiaim[id].jitter_type:get() == 3) and not (custom_antiaim[id].jitter_type:get() == 2)  then
            yaw_offset = yaw_offset + (custom_antiaim[id].jitter_offset:get() * way_jitter.steps[custom_antiaim[id].jitter_mode:get()][way_jitter.step])
        end
        if (custom_antiaim[id].jitter_type:get() == 2) then
            yaw_offset = yaw_offset + ((switch_ticks > 2 and custom_antiaim[id].jitter_offset:get() or custom_antiaim[id].jitter_offset2:get()) * way_jitter.steps[custom_antiaim[id].jitter_mode:get()][way_jitter.step])
        end
        if (custom_antiaim[id].jitter_type:get() == 3) then
            yaw_offset = yaw_offset + (random(custom_antiaim[id].jitter_offset:get(), custom_antiaim[id].jitter_offset2:get()) * way_jitter.steps[custom_antiaim[id].jitter_mode:get()][way_jitter.step])
        end
    end

    if not (custom_antiaim[id].jitter_mode:get() > 2) then
        jit_off_val = custom_antiaim[id].jitter_offset:get()
        if custom_antiaim[id].jitter_type:get() == 2 then
            jit_off_val = switch_ticks > 2 and custom_antiaim[id].jitter_offset:get() or custom_antiaim[id].jitter_offset2:get()
        end
        if custom_antiaim[id].jitter_type:get() == 3 then
            jit_off_val = random(custom_antiaim[id].jitter_offset:get(), custom_antiaim[id].jitter_offset2:get())
        end
    else
        jit_off_val = 0
    end

    yaw_value = (custom_antiaim[id].jitter_mode:get() > 2) and yaw_offset or get_yaw
    prim.yaw_base:set(custom_antiaim[id].yaw_base:get())
    prim.yaw_add:set(yaw_value)
    prim.jitter_mode:set(2)
    if custom_antiaim[id].jitter_mode:get() < 3 then
    prim.jitter_type:set(custom_antiaim[id].jitter_mode:get())
    end
    prim.jitter_add:set(jit_off_val)
    desync_value = 2
    if custom_antiaim[id].desync_type:get() == 2 then
        desync_value = 4
    end
    if custom_antiaim[id].desync_type:get() == 3 then
        desync_value = 7
    end
    prim.desync_type:set(desync_value)
    prim.left_limit:set(custom_antiaim[id].left_desync:get())
    prim.right_limit:set(custom_antiaim[id].right_desync:get())
    prim.on_shot:set(custom_antiaim[id].on_shot:get())
end

menu.add_button("Anti-Aim", "Export", function()
    cfg_data = {}
    for key, value in pairs(menu_items.items) do
        local ui_value = value:get()
        if type(ui_value) == "userdata" then
            cfg_data[key] = ui_value:to_hex()
        else
            cfg_data[key] = ui_value
        end
    end
    clipboard.set(json.encode(cfg_data))
end)

menu.add_button("Anti-Aim", "Import", function()
    cfg_data = clipboard.get()
    local cfg_data = json.parse(cfg_data)
    if cfg_data ~= nil then
        for key, value in pairs(cfg_data) do
            local item2 = menu_items.items[key]
            if item2 ~= nil then
                local invalue = value
                item2:set(invalue)
            end
        end
    end
end)

on_layers = function(ctx)
    if anim_breakers:get(1) then
    ctx:set_render_pose(e_poses.RUN, 1)
    end
    if (state_lib.get_state() == 5 or state_lib.get_state() == 6) and anim_breakers:get(2) then
        if air_legs:get() == 1 then
            ctx:set_render_pose(e_poses.JUMP_FALL, 1)
        elseif air_legs:get() == 2 then
            ctx:set_render_animlayer(e_animlayers.MOVEMENT_LAND_OR_CLIMB, 1, 1)
        elseif air_legs:get() == 3 then
            ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 1)
        end
    end
    if anim_breakers:get(3) and state_lib.get_state() == 2 then
        ctx:set_render_animlayer(e_animlayers.LEAN, 1)
    end
end


callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.ANTIAIM, on_layers)
callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)