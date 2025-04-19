local menu = {
    enabled = ui.new_checkbox("VISUALS", "Effects", "Floating damage"),
    flags = ui.new_combobox("VISUALS", "Effects", "Floating damage text", "Bold", "Large", "Medium", "Small"),
    color = ui.new_color_picker("VISUALS", "Effects", "Floating damage color", 0, 255, 0, 255),
    time = ui.new_slider("VISUALS", "Effects", "Floating damage fade time", 1, 100, 20, true, "s", 0.1),
    distance = ui.new_slider("VISUALS", "Effects", "Floating damage fade distance", 3, 128, 16, true, "u", 1, {[3] = "Static"})
}

local r, g, b, a = 0, 0, 0, 0
local time = 2
local distance = 16
local flags = ""
local cb_to_flags = {
    ["Bold"] = "cb",
    ["Large"] = "c+",
    ["Medium"] = "c",
    ["Small"] = "c-"
}

local hitgroup_to_hitbox = {
    [0] = 0,
    [1] = 0,
    [2] = 3,
    [3] = 2,
    [4] = 13,
    [5] = 14,
    [6] = 11,
    [7] = 12,
    [10] = 0
}

local shots = {}

local function push_hurt(event)
    if client.userid_to_entindex(event.attacker) == entity.get_local_player() then 
        local target = client.userid_to_entindex(event.userid)
        table.insert(shots, { 
            event.dmg_health, 
            globals.curtime(), 
            entity.get_player_name(target),
            { entity.hitbox_position(target, hitgroup_to_hitbox[event.hitgroup]) },
        })
    end
end

local function on_level_init()
    shots = {}
end

local function render_hitmarkers(ctx)
    local removeindex = {}
    for i = 1, #shots do 
        local cur_shot = shots[i]
        local a_mod = math.max(math.min(1, (0 - ((globals.curtime() - cur_shot[2]) - time) / time)), 0)
        if a_mod == 0 then 
            removeindex[#removeindex+1] = i
        else 
            local x, y = renderer.world_to_screen(cur_shot[4][1], cur_shot[4][2], cur_shot[4][3]+distance+16-(distance*a_mod))
            if x ~= nil then 
                renderer.text(x-2, y, r, g, b, a * a_mod, flags, 0, cur_shot[1])
            end
        end
    end

    for i = 1, #removeindex do 
        table.remove(shots, removeindex[i])
    end
end

local function on_script_toggle(self)
    local state = ui.get(self)
    local update_callback = state and client.set_event_callback or client.unset_event_callback
    update_callback("paint", render_hitmarkers)
    update_callback("level_init", on_level_init)
    update_callback("player_hurt", push_hurt)
    ui.set_visible(menu.color, state)
    ui.set_visible(menu.flags, state)
    ui.set_visible(menu.time, state)
    ui.set_visible(menu.distance, state)
    shots = {}
end

ui.set_callback(menu.enabled, on_script_toggle)
ui.set_callback(menu.color, function(self) r, g, b, a = ui.get(self) end) r, g, b, a = ui.get(menu.color)
ui.set_callback(menu.flags, function(self) flags = cb_to_flags[ui.get(self)] end) flags = cb_to_flags[ui.get(menu.flags)]
ui.set_callback(menu.time, function(self) time = ui.get(self)*0.1 end) time = ui.get(menu.time)*0.1
ui.set_callback(menu.distance, function(self) local slider = ui.get(self) distance = (slider == 3) and 0 or slider end) distance = (ui.get(menu.distance) == 3) and 0 or ui.get(menu.distance)
on_script_toggle(menu.enabled)