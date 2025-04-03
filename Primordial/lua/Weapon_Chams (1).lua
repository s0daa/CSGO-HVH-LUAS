local glow_material = materials.create( "glow_material", [[
      "VertexLitGeneric"
    {
      "$basetexture" "sprites/light_glow04"
      "$additive" "1"
      "$wireframe" "1"
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.6"
                      "texturescrollangle" "40"
              }
      }
    }
   ]]
)
local thirdperson = menu.find('visuals', 'other', 'thirdperson', 'enable')
local is_attachment_entity = function(e, o)
    if e == nil then return end
    if o == nil then return end
    
    if e:get_prop("moveparent") ~= nil and entity_list.get_entity(e:get_prop("moveparent")) ~= nil then
        if entity_list.get_entity(e:get_prop("moveparent")):get_index() ~= nil and o:get_index() ~= nil then
            return entity_list.get_entity(e:get_prop("moveparent")):get_index() == o:get_index()
        end
    end
end
local text = menu.add_text('Chams', 'Chams color')
local color = text:add_color_picker('Chams', color_t(94,90,157))
function on_draw_model(ctx)
    if ctx.entity == nil or entity_list.get_local_player() == nil then return end
    if (ctx.model_name:lower():find("_dropped.mdl") and thirdperson[2]:get() and ctx.model_name:lower():find("weapons/w") and not ctx.model_name:lower():find("ied_dropped")) or (ctx.entity ~= nil and thirdperson[2]:get() and is_attachment_entity(ctx.entity, entity_list.get_local_player())) then
        ctx.override_original = true
        
        ctx:draw_material(glow_material)
    end

    if ctx.model_name:find("weapons/v_") ~= nil and not ctx.model_name:lower():find("arms") then
        ctx.override_original = true
        ctx:draw_material(glow_material)
    end

    glow_material:color_modulate(color:get().r / 255, color:get().g / 255, color:get().b / 255)
    glow_material:alpha_modulate(color:get().a / 255)
end

callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)