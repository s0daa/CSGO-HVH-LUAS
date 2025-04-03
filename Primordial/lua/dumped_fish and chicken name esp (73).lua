local main_font = render.create_font("Segoe Ui", 12, 700, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local chicken_enable = menu.add_checkbox("esp", "Chicken name", false)
local fish_enable = menu.add_checkbox("esp", "Fish name", false)
local uhhhhh = nil
local uhhhhhv2 = nil

local function draw_chicken_name() --// No comments on this func bc it's exact same as the below with minor changes B)
    if (not engine.is_in_game()) then return end;
    if (not chicken_enable:get()) then return end;
    local chicken = entity_list.get_entities_by_classid(36);
    
    for _,chicknr in pairs(chicken) do
        local screen_pos = render.world_to_screen(chicknr:get_render_origin());
        if uhhhhh ~= screen_pos then uhhhhh = screen_pos end
        if uhhhhh == nil then goto continue end
        render.text(main_font, "chicken.", uhhhhh, color_t(255, 255, 255, 255))
        ::continue::
    end
end

local function draw_fish_name()
    if (not engine.is_in_game()) then return end;
    if (not fish_enable:get()) then return end;
    local fish = entity_list.get_entities_by_classid(75);

    for _,fishm in pairs(fish) do --// Loop through all entities with the class of 75
        local screen_pos = render.world_to_screen(fishm:get_render_origin()); --// Convert our entity's pos to a vec2 instead of a vec3
        if uhhhhhv2 ~= screen_pos then uhhhhhv2 = screen_pos end --// Cache pos into a variable and read that instead of it direct (was told it has better performance, not even sure if it's being done correctly here. /shrug)
        if uhhhhhv2 == nil then goto continue end --// Skip any iterations returning nil
        render.text(main_font, 'fish', screen_pos, color_t(255, 255, 255, 255)) --// Finally render the text.
        ::continue::
    end
end

local function on_event(event)
    if event.name == "round_start" then --// Clear variables from previous round so we don't draw old coords.
        uhhhhh = nil
        uhhhhhv2 = nil
    end
end

callbacks.add(e_callbacks.EVENT, on_event)
callbacks.add(e_callbacks.PAINT, draw_chicken_name)
callbacks.add(e_callbacks.PAINT, draw_fish_name)