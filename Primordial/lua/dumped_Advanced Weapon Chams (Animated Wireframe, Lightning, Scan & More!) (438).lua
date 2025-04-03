local glow_material = materials.create( "Animtated Wireframe", [[
      "VertexLitGeneric"
    {
      "$basetexture" "models/inventory_items/dreamhack_trophies/dreamhack_star_blur"
      "$additive" "1"
      "$wireframe" "1"
	  "$selfillum" "1"
	  "$ignorez" "0"
	
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.3"
                      "texturescrollangle" "90"
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


local checkbox1 = menu.add_checkbox('Chams', 'Animated Wireframe', false)



local color = checkbox1:add_color_picker('Chams', color_t(94,90,157))



function on_draw_model(ctx)
   
    if checkbox1:get() then


    if ctx.entity == nil or entity_list.get_local_player() == nil then return end
    if (ctx.model_name:lower():find("_dropped.mdl") and thirdperson[2]:get() and ctx.model_name:lower():find("weapons/w") and not ctx.model_name:lower():find("ied_dropped")) or (ctx.entity ~= nil and thirdperson[2]:get() and is_attachment_entity(ctx.entity, entity_list.get_local_player())) then
        ctx.override_original = false
        
        ctx:draw_material(glow_material)
    end

    if ctx.model_name:find("weapons/v_") ~= nil and not ctx.model_name:lower():find("arms") then
        ctx.override_original = false
        ctx:draw_material(glow_material)
    end

end
    glow_material:color_modulate(color:get().r / 255, color:get().g / 255, color:get().b / 255)
    glow_material:alpha_modulate(color:get().a / 255)

    
   
end
        callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)

local second = materials.create( "Lightning", [[
      "VertexLitGeneric"
    {
      "$basetexture" "particle/particle_ring_wave_2"
      "$additive" "1"
      
	  "$selfillum" "1"
	  "$ignorez" "0"
	
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.3"
                      "texturescrollangle" "90"
              }
      }
    }
   ]]
)

local checkbox2 = menu.add_checkbox('Chams', 'Lightning', false)

local color = checkbox2:add_color_picker('Chams', color_t(94,90,157))



function on_draw_model(ctx)

    if checkbox2:get() then
    
    if ctx.entity == nil or entity_list.get_local_player() == nil then return end
    if (ctx.model_name:lower():find("_dropped.mdl") and thirdperson[2]:get() and ctx.model_name:lower():find("weapons/w") and not ctx.model_name:lower():find("ied_dropped")) or (ctx.entity ~= nil and thirdperson[2]:get() and is_attachment_entity(ctx.entity, entity_list.get_local_player())) then
        ctx.override_original = false
        
        ctx:draw_material(second)
    end

    if ctx.model_name:find("weapons/v_") ~= nil and not ctx.model_name:lower():find("arms") then
        ctx.override_original = false
        ctx:draw_material(second)
    end
end
    second:color_modulate(color:get().r / 255, color:get().g / 255, color:get().b / 255)
    second:alpha_modulate(color:get().a / 255)
end


callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)

local third = materials.create( "Paints", [[
      "VertexLitGeneric"
    {
      "$basetexture" "models/weapons/customization/paints/anodized_multi/smoke2"
      "$additive" "1"
      
	  "$selfillum" "1"
	  "$ignorez" "0"
	
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.3"
                      "texturescrollangle" "90"
              }
      }
    }
   ]]
)

local checkbox3 = menu.add_checkbox('Chams', 'SpinArt', false)

local color = checkbox3:add_color_picker('Chams', color_t(94,90,157))



function on_draw_model(ctx)

    if checkbox3:get() then
    
    if ctx.entity == nil or entity_list.get_local_player() == nil then return end
    if (ctx.model_name:lower():find("_dropped.mdl") and thirdperson[2]:get() and ctx.model_name:lower():find("weapons/w") and not ctx.model_name:lower():find("ied_dropped")) or (ctx.entity ~= nil and thirdperson[2]:get() and is_attachment_entity(ctx.entity, entity_list.get_local_player())) then
        ctx.override_original = false
        
        ctx:draw_material(third)
    end

    if ctx.model_name:find("weapons/v_") ~= nil and not ctx.model_name:lower():find("arms") then
        ctx.override_original = false
        ctx:draw_material(third)
    end
end
    third:color_modulate(color:get().r / 255, color:get().g / 255, color:get().b / 255)
    third:alpha_modulate(color:get().a / 255)
end


callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)

local four = materials.create( "thing", [[
      "VertexLitGeneric"
    {
      "$basetexture" "decals/snow01"
      "$additive" "1"
      
	  "$selfillum" "1"
	  "$ignorez" "0"
	
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.3"
                      "texturescrollangle" "90"
              }
      }
    }
   ]]
)

local checkbox4 = menu.add_checkbox('Chams', 'Snow', false)

local color = checkbox4:add_color_picker('Chams', color_t(94,90,157))



function on_draw_model(ctx)

    if checkbox4:get() then
    
    if ctx.entity == nil or entity_list.get_local_player() == nil then return end
    if (ctx.model_name:lower():find("_dropped.mdl") and thirdperson[2]:get() and ctx.model_name:lower():find("weapons/w") and not ctx.model_name:lower():find("ied_dropped")) or (ctx.entity ~= nil and thirdperson[2]:get() and is_attachment_entity(ctx.entity, entity_list.get_local_player())) then
        ctx.override_original = false
        
        ctx:draw_material(four)
    end

    if ctx.model_name:find("weapons/v_") ~= nil and not ctx.model_name:lower():find("arms") then
        ctx.override_original = false
        ctx:draw_material(four)
    end
end
    four:color_modulate(color:get().r / 255, color:get().g / 255, color:get().b / 255)
    four:alpha_modulate(color:get().a / 255)
end


callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)

local five = materials.create( "thingyy", [[
      "VertexLitGeneric"
    {
      "$basetexture" "models/weapons/customization/paints/hydrographic/marbleized"
      "$additive" "1"
      "$rimlight" "1"
	  "$selfillum" "1"
	  "$ignorez" "0"
	
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.1"
                      "texturescrollangle" "90"
              }
      }
    }
   ]]
)

local checkbox5 = menu.add_checkbox('Chams', 'Paint', false)

local color = checkbox5:add_color_picker('Chams', color_t(94,90,157))



function on_draw_model(ctx)

    if checkbox5:get() then
    
    if ctx.entity == nil or entity_list.get_local_player() == nil then return end
    if (ctx.model_name:lower():find("_dropped.mdl") and thirdperson[2]:get() and ctx.model_name:lower():find("weapons/w") and not ctx.model_name:lower():find("ied_dropped")) or (ctx.entity ~= nil and thirdperson[2]:get() and is_attachment_entity(ctx.entity, entity_list.get_local_player())) then
        ctx.override_original = false
        
        ctx:draw_material(five)
    end

    if ctx.model_name:find("weapons/v_") ~= nil and not ctx.model_name:lower():find("arms") then
        ctx.override_original = false
        ctx:draw_material(five)
    end
end
    five:color_modulate(color:get().r / 255, color:get().g / 255, color:get().b / 255)
    five:alpha_modulate(color:get().a / 255)
end


callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)

local six = materials.create( "thingyyy", [[
      "VertexLitGeneric"
    {
      "$basetexture" "effects/tesla_glow"
      "$additive" "1"
      "$rimlight" "1"
	  "$selfillum" "1"
	  "$ignorez" "0"
      "$wireframe" "1"
	
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.3"
                      "texturescrollangle" "90"
              }
      }
    }
   ]]
)

local checkbox6 = menu.add_checkbox('Chams', 'Tesla Glow', false)

local color = checkbox6:add_color_picker('Chams', color_t(94,90,157))



function on_draw_model(ctx)

    if checkbox6:get() then
    
    if ctx.entity == nil or entity_list.get_local_player() == nil then return end
    if (ctx.model_name:lower():find("_dropped.mdl") and thirdperson[2]:get() and ctx.model_name:lower():find("weapons/w") and not ctx.model_name:lower():find("ied_dropped")) or (ctx.entity ~= nil and thirdperson[2]:get() and is_attachment_entity(ctx.entity, entity_list.get_local_player())) then
        ctx.override_original = false
        
        ctx:draw_material(six)
    end

    if ctx.model_name:find("weapons/v_") ~= nil and not ctx.model_name:lower():find("arms") then
        ctx.override_original = false
        ctx:draw_material(six)
    end
end
    six:color_modulate(color:get().r / 255, color:get().g / 255, color:get().b / 255)
    six:alpha_modulate(color:get().a / 255)
end


callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)


local seven = materials.create( "thingyyyyy", [[
      "VertexLitGeneric"
    {
      "$basetexture" "effects\screentear1"
      "$additive" "1"
     
	  "$selfillum" "1"
	  "$ignorez" "0"
	    

	
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.3"
                      "texturescrollangle" "90"
              }
      }
    }
   ]]
)

local checkbox7 = menu.add_checkbox('Chams', 'Ocean Flow', false)

local color = checkbox7:add_color_picker('Chams', color_t(94,90,157))



function on_draw_model(ctx)

    if checkbox7:get() then
    
    if ctx.entity == nil or entity_list.get_local_player() == nil then return end
    if (ctx.model_name:lower():find("_dropped.mdl") and thirdperson[2]:get() and ctx.model_name:lower():find("weapons/w") and not ctx.model_name:lower():find("ied_dropped")) or (ctx.entity ~= nil and thirdperson[2]:get() and is_attachment_entity(ctx.entity, entity_list.get_local_player())) then
        ctx.override_original = false
        
        ctx:draw_material(seven)
    end

    if ctx.model_name:find("weapons/v_") ~= nil and not ctx.model_name:lower():find("arms") then
        ctx.override_original = false
        ctx:draw_material(seven)
    end
end
    seven:color_modulate(color:get().r / 255, color:get().g / 255, color:get().b / 255)
    seven:alpha_modulate(color:get().a / 255)
end


callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)




local eight = materials.create( "thingyyyyyy", [[
      "VertexLitGeneric"
    {
      "$basetexture" "blade_mideffect"
      "$additive" "1"
     
	  "$selfillum" "1"
	  "$ignorez" "0"
	

	
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.2"
                      "texturescrollangle" "45"
              }
      }
    }
   ]]
)

local checkbox8 = menu.add_checkbox('Chams', 'Scan', false)

local color = checkbox8:add_color_picker('Chams', color_t(94,90,157))



function on_draw_model(ctx)

    if checkbox8:get() then
    
    if ctx.entity == nil or entity_list.get_local_player() == nil then return end
    if (ctx.model_name:lower():find("_dropped.mdl") and thirdperson[2]:get() and ctx.model_name:lower():find("weapons/w") and not ctx.model_name:lower():find("ied_dropped")) or (ctx.entity ~= nil and thirdperson[2]:get() and is_attachment_entity(ctx.entity, entity_list.get_local_player())) then
        ctx.override_original = false
        
        ctx:draw_material(eight)
    end

    if ctx.model_name:find("weapons/v_") ~= nil and not ctx.model_name:lower():find("arms") then
        ctx.override_original = false
        ctx:draw_material(eight)
    end
end
    eight:color_modulate(color:get().r / 255, color:get().g / 255, color:get().b / 255)
    eight:alpha_modulate(color:get().a / 255)
end


callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)