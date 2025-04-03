local render_color = menu.add_text("Transparency on nade", "Transparency alpha"):add_color_picker("Transparency color")

render_color:set(color_t(255, 255, 255, 100))

local function on_draw_model(ctx)
    if not ctx.entity:is_valid() then return end
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    
    if ctx.entity:get_index() ~= local_player:get_index() then return end
    
    local weapon = local_player:get_active_weapon()
    if weapon == nil then return end
    
    local class_name = weapon:get_class_name()
    if class_name ~= "CHEGrenade" and 
    class_name ~= "CIncendiaryGrenade" and 
    class_name ~= "CSmokeGrenade" and 
    class_name ~= "CFlashbang" and 
    class_name ~= "CDecoyGrenade" and 
    class_name ~= "CMolotovGrenade" then return end
    
    ctx.override_original = true

    ctx:draw_original(render_color:get())
end

--CHEGrenade, CIncendiaryGrenade, CSmokeGrenade, CFlashbang, CDecoyGrenade, CMolotovGrenade 

callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)