-- v0.4

menu.add_text("info", "Welcome " .. user.name .. " to BetterChams v0.4 by Lazarus!")
menu.add_text("info", "First overlay colorpicker in general is animated wireframe")
menu.add_text("info", "First two enemy overlay colorpickers are for the vis. materials")

local find_local_transparency =  menu.find("visuals", "other", "thirdperson", "transparency when scoped")

local local_base_chams_master = menu.add_checkbox("local player", "Enable local base chams")
local local_base_chams_color = local_base_chams_master:add_color_picker("local_base_color")

local local_chams_keep_original = menu.add_checkbox("local player", "Keep original model")

local local_overlay_chams_master = menu.add_multi_selection("local player","Local overlay materials",{"glow","animated wireframe"})
local local_glow_overlay_chams_color = local_overlay_chams_master:add_color_picker("local_glow_overlay_chams_color", color_t(63, 92, 120, 255))
local local_animated_wireframe_overlay_chams_color = local_overlay_chams_master:add_color_picker("local_animated_wireframe_overlay_chams_color", color_t(90, 136, 182, 255))
local local_glow_overlay_chams_strength_pulse = menu.add_checkbox("local player", "Enable local glow overlay pulse")
local local_glow_overlay_chams_strength = menu.add_slider("local player", "Local glow overlay strength", 1, 100)

local attachments_base_chams_master = menu.add_checkbox("local player", "Enable attachments base chams")
local attachments_base_chams_color = attachments_base_chams_master:add_color_picker("attachments_base_chams_color")

local attachments_overlay_chams_master = menu.add_multi_selection("local player","Attachments overlay materials",{"glow","animated wireframe"})
local attachments_glow_overlay_chams_color = attachments_overlay_chams_master:add_color_picker("attachments_glow_overlay_chams_color", color_t(120, 63, 106, 255))
local attachments_animated_wireframe_overlay_chams_color = attachments_overlay_chams_master:add_color_picker("attachments_animated_wireframe_overlay_chams_color", color_t(90, 136, 182, 255))
local attachments_glow_overlay_chams_strength_pulse = menu.add_checkbox("local player", "Enable attachments glow overlay pulse")
local attachments_glow_overlay_chams_strength = menu.add_slider("local player", "Attachments glow overlay strength", 1, 100)

local enemy_vis_base_chams_master = menu.add_checkbox("enemy", "Enable enemy visible base chams")
local enemy_vis_base_chams_color = enemy_vis_base_chams_master:add_color_picker("enemy_vis_base_chams_color", color_t(150, 200, 60, 255))
local enemy_xqz_base_chams_master = menu.add_checkbox("enemy", "Enable enemy behind walls base chams")
local enemy_xqz_base_chams_color = enemy_xqz_base_chams_master:add_color_picker("enemy_xqz_base_chams_color", color_t(60, 120, 180, 180))

local enemy_overlay_chams_master = menu.add_multi_selection("enemy","Enemy overlay materials",{"glow", "glow xqz","animated wireframe", "animated wireframe xqz"})
local enemy_xqz_glow_overlay_chams_color = enemy_overlay_chams_master:add_color_picker("enemy_xqz_glow_overlay_chams_color", color_t(63, 92, 120, 255))
local enemy_xqz_animated_wireframe_overlay_chams_color = enemy_overlay_chams_master:add_color_picker("enemy_xqz_animated_wireframe_overlay_chams_color", color_t(90, 136, 182, 255))
local enemy_vis_glow_overlay_chams_color = enemy_overlay_chams_master:add_color_picker("enemy_vis_glow_overlay_chams_color", color_t(55, 21, 60, 255))
local enemy_vis_animated_wireframe_overlay_chams_color = enemy_overlay_chams_master:add_color_picker("enemy_vis_animated_wireframe_overlay_chams_color", color_t(189, 37, 113, 255))
local enemy_glow_overlay_chams_strength_pulse = menu.add_checkbox("enemy", "Enable enemy glow overlay pulse")
local enemy_glow_overlay_chams_strength = menu.add_slider("enemy", "Enemy glow overlay strength", 1, 100)

local arms_base_chams_master = menu.add_checkbox("viewmodel", "Enable arms base chams")
local arms_base_chams_color = arms_base_chams_master:add_color_picker("arms_base_chams_color")

local arms_chams_keep_original = menu.add_checkbox("viewmodel", "Keep original model")

local arms_overlay_chams_master = menu.add_multi_selection("viewmodel","Arms overlay materials",{"glow","animated wireframe"})
local arms_glow_overlay_chams_color = arms_overlay_chams_master:add_color_picker("arms_glow_overlay_chams_color", color_t(63, 92, 120, 255))
local arms_animated_wireframe_overlay_chams_color = arms_overlay_chams_master:add_color_picker("arms_animated_wireframe_overlay_chams_color", color_t(90, 136, 182, 255))
local arms_glow_overlay_chams_strength_pulse = menu.add_checkbox("viewmodel", "Enable arms glow overlay pulse")
local arms_glow_overlay_chams_strength = menu.add_slider("viewmodel", "Arms glow overlay strength", 1, 100)

local weapon_base_chams_master = menu.add_checkbox("viewmodel", "Enable weapon base chams")
local weapon_base_chams_color = weapon_base_chams_master:add_color_picker("weapon_base_chams_color")

local weapon_chams_keep_original = menu.add_checkbox("viewmodel", "Keep original model")

local weapon_overlay_chams_master = menu.add_multi_selection("viewmodel","Weapon overlay materials",{"glow","animated wireframe"})
local weapon_glow_overlay_chams_color = weapon_overlay_chams_master:add_color_picker("weapon_glow_overlay_chams_color", color_t(63, 92, 120, 255))
local weapon_animated_wireframe_chams_color = weapon_overlay_chams_master:add_color_picker("weapon_animated_wireframe_chams_color", color_t(90, 136, 182, 255))
local weapon_glow_overlay_chams_strength_pulse = menu.add_checkbox("viewmodel", "Enable weapon glow overlay pulse")
local weapon_glow_overlay_chams_strength = menu.add_slider("viewmodel", "Weapon glow overlay strength", 1, 100)

local create_material = function(mat, name, count)
   local t = {}
   
   for i=1, count do
       table.insert(t, materials.create( ("t_%s_%i"):format(name, i), mat ) )
   end
   
   return t
end

local is_attachment_entity = function(e, o)
   if not e then
       return false
   end
   
   if not o then
       return false
   end
   
   if not e:get_prop("moveparent") or not entity_list.get_entity(e:get_prop("moveparent")) then
       return false
   end
   
   return entity_list.get_entity(e:get_prop("moveparent")):get_index() == o:get_index()
end

local default_material = create_material([[
      "VertexLitGeneric" {
         "$basetexture" "vgui/white_additive"
         "$envmap"       "debug/debugambientcube"
         "$envmaptint"   "[1 1 1]"
         "$nofog"        "1"
         "$model"        "1"
      }
]], "default_material", 2)


local glow_overlay = create_material([[
   "VertexLitGeneric" {
      "$additive" "1"
      "$envmap" "models/effects/cube_white"
      "$envmaptint" "[1 1 1]"
      "$envmapfresnel" "1"
      "$envmapfresnelminmaxexp" "[0 1 2]"
      "$alpha" "1.0"
   }
]], "glow_overlay", 2)

local animated_wireframe_overlay = create_material([[
      "VertexLitGeneric" {
         "$basetexture" "sprites/light_glow04"
         "$nodecal" "1"
         "$model" "1"
         "$additive" "1"
         "$nocull" "1"
         "$wireframe" "1"
         
         "proxies"
             {
             "texturescroll"
                 {
                     "texturescrollvar" "$basetexturetransform"
                     "texturescrollrate" "0.4"
                     "texturescrollangle" "90"
                 }
             }
      }
]], "animated_wireframe_overlay", 2)

callbacks.add(e_callbacks.DRAW_MODEL, function(ctx)
   local model = ctx.model_name:lower()
   local local_player = entity_list.get_local_player()

   if arms_base_chams_master:get() and not model:find("w_models") and (model:find("arms") or model:find("sleeve")) then
      local col = arms_base_chams_color:get()

      ctx.override_original = true

      default_material[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
      default_material[2]:alpha_modulate(col.a / 255)

      ctx:draw_material(default_material[2])
   end

   if (arms_overlay_chams_master:get(1) or arms_overlay_chams_master:get(2)) and not model:find("w_models") and (model:find("arms") or model:find("sleeve")) then
      if arms_chams_keep_original:get() then
          ctx:draw_original()
      end
   end

   if arms_overlay_chams_master:get(1) and not model:find("w_models") and (model:find("arms") or model:find("sleeve")) then
      local col = arms_glow_overlay_chams_color:get()
      local strength_mod = arms_glow_overlay_chams_strength:get()
      local strength_pulse = math.floor(math.sin(global_vars.real_time() * 2) * 50 + 50)

      ctx.override_original = true

      glow_overlay[2]:set_shader_param("$envmaptint", vec3_t(col.r / 255, col.g / 255, col.b / 255))
      glow_overlay[2]:set_shader_param("$envmapfresnelminmaxexp", vec3_t(0.0, 1.0, arms_glow_overlay_chams_strength_pulse:get() and strength_pulse or strength_mod))
      glow_overlay[2]:set_shader_param("$alpha", col.a / 255)

      ctx:draw_material(glow_overlay[2])
   end

   if arms_overlay_chams_master:get(2) and not model:find("w_models") and (model:find("arms") or model:find("sleeve")) then
      local col = arms_animated_wireframe_overlay_chams_color:get()

      ctx.override_original = true

      animated_wireframe_overlay[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
      animated_wireframe_overlay[2]:alpha_modulate(col.a / 255)

      ctx:draw_material(animated_wireframe_overlay[2])
   end

   if weapon_base_chams_master:get() and model:find("weapons/v_") and not model:find("arms") then
      local col = weapon_base_chams_color:get()

      ctx.override_original = true

      default_material[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
      default_material[2]:alpha_modulate(col.a / 255)

      ctx:draw_material(default_material[2])
   end

   if (weapon_overlay_chams_master:get(1) or weapon_overlay_chams_master:get(2)) and model:find("weapons/v_") and not model:find("arms") then
      if weapon_chams_keep_original:get() then
          ctx:draw_original()
      end
   end

   if weapon_overlay_chams_master:get(1) and model:find("weapons/v_") and not model:find("arms") then
      local col = weapon_glow_overlay_chams_color:get()
      local strength_mod = weapon_glow_overlay_chams_strength:get()
      local strength_pulse = math.floor(math.sin(global_vars.real_time() * 2) * 50 + 50)

      ctx.override_original = true

      glow_overlay[2]:set_shader_param("$envmaptint", vec3_t(col.r / 255, col.g / 255, col.b / 255))
      glow_overlay[2]:set_shader_param("$envmapfresnelminmaxexp", vec3_t(0.0, 1.0, weapon_glow_overlay_chams_strength_pulse:get() and strength_pulse or strength_mod))
      glow_overlay[2]:set_shader_param("$alpha", col.a / 255)

      ctx:draw_material(glow_overlay[2])
   end

   if weapon_overlay_chams_master:get(2) and model:find("weapons/v_") and not model:find("arms") then
      local col = weapon_animated_wireframe_chams_color:get()

      ctx.override_original = true

      animated_wireframe_overlay[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
      animated_wireframe_overlay[2]:alpha_modulate(col.a / 255)

      ctx:draw_material(animated_wireframe_overlay[2])
   end

   -- thanks @kstk once again!
   if attachments_base_chams_master:get() then
      if (model:find("_dropped.mdl") and model:find("weapons/w") and not model:find("arms") and not model:find("ied_dropped")) or (ctx.entity and is_attachment_entity(ctx.entity, entity_list.get_local_player())) then
         ctx.override_original = true

         local col = attachments_base_chams_color:get()
         local col_glow = attachments_glow_overlay_chams_color:get()
         local col_wireframe = attachments_animated_wireframe_overlay_chams_color:get()
         local strength_mod = attachments_glow_overlay_chams_strength:get()
         local strength_pulse = math.floor(math.sin(global_vars.real_time() * 2) * 50 + 50)

         default_material[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
         default_material[2]:alpha_modulate(col.a / 255)

         if local_player:get_prop("m_bIsScoped") ~= 0 then
            default_material[2]:alpha_modulate(math.min(col.a / 255, 1.0 - find_local_transparency:get() / 100))
            glow_overlay[2]:alpha_modulate(math.min(col.a / 255, 1.0 - find_local_transparency:get() / 100))
            animated_wireframe_overlay[2]:alpha_modulate(math.min(col.a / 255, 1.0 - find_local_transparency:get() / 100))
         end

         ctx:draw_material(default_material[2])

         if attachments_overlay_chams_master:get(1) then
           glow_overlay[2]:set_shader_param("$envmaptint", vec3_t(col_glow.r / 255, col_glow.g / 255, col_glow.b / 255))
           glow_overlay[2]:set_shader_param("$envmapfresnelminmaxexp", vec3_t(0.0, 1.0, attachments_glow_overlay_chams_strength_pulse:get() and strength_pulse or strength_mod))
           glow_overlay[2]:set_shader_param("$alpha", col_glow.a / 255)

           ctx:draw_material(glow_overlay[2])
         end

         if attachments_overlay_chams_master:get(2) then
           animated_wireframe_overlay[2]:color_modulate(col_wireframe.r / 255, col_wireframe.g / 255, col_wireframe.b / 255)
           animated_wireframe_overlay[2]:alpha_modulate(col_wireframe.a / 255)

           ctx:draw_material(animated_wireframe_overlay[2])
         end
      end
   end

   if local_base_chams_master:get() and model:find("models/player") then
      if ctx.entity == local_player then
         local col = local_base_chams_color:get()

         ctx.override_original = true

         default_material[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
         default_material[2]:alpha_modulate(col.a / 255)

         if local_player:get_prop("m_bIsScoped") ~= 0 then
            default_material[2]:alpha_modulate(math.min(col.a / 255, 1.0 - find_local_transparency:get() / 100))
         end

         ctx:draw_material(default_material[2])
      end
   end

   if (local_overlay_chams_master:get(1) or local_overlay_chams_master:get(2)) and model:find("models/player") then
      if ctx.entity == local_player then
         if local_chams_keep_original:get() then
            ctx:draw_original()
         end
      end
  end

   if local_overlay_chams_master:get(1) and model:find("models/player") then
      if ctx.entity == local_player then
         local col = local_glow_overlay_chams_color:get()
         local strength_mod = local_glow_overlay_chams_strength:get()
         local strength_pulse = math.floor(math.sin(global_vars.real_time() * 2) * 50 + 50)

         ctx.override_original = true

         glow_overlay[2]:set_shader_param("$envmaptint", vec3_t(col.r / 255, col.g / 255, col.b / 255))
         glow_overlay[2]:set_shader_param("$envmapfresnelminmaxexp", vec3_t(0.0, 1.0, local_glow_overlay_chams_strength_pulse:get() and strength_pulse or strength_mod))
         glow_overlay[2]:set_shader_param("$alpha", col.a / 255)

         if local_player:get_prop("m_bIsScoped") ~= 0 then
            glow_overlay[2]:alpha_modulate(math.min(col.a / 255, 1.0 - find_local_transparency:get() / 100))
         end

         ctx:draw_material(glow_overlay[2])
      end
   end

   if local_overlay_chams_master:get(2) and model:find("models/player") then
      if ctx.entity == local_player then
         local col = local_animated_wireframe_overlay_chams_color:get()

         ctx.override_original = true

         animated_wireframe_overlay[2]:color_modulate(col.r / 255, col.g / 255, col.b / 255)
         animated_wireframe_overlay[2]:alpha_modulate(col.a / 255)

         if local_player:get_prop("m_bIsScoped") ~= 0 then
            animated_wireframe_overlay[2]:alpha_modulate(math.min(col.a / 255, 1.0 - find_local_transparency:get() / 100))
         end

         ctx:draw_material(animated_wireframe_overlay[2])
      end
   end

   -- thanks @kstk!
   if ctx.entity and ctx.entity:is_player() and ctx.entity:is_enemy() then    
      if enemy_xqz_base_chams_master:get() then
          ctx.override_original = true
      
          local col_xqz = enemy_xqz_base_chams_color:get()
          local col_xqz_glow = enemy_xqz_glow_overlay_chams_color:get()
          local col_xqz_wireframe = enemy_xqz_animated_wireframe_overlay_chams_color:get()
          local strength_mod = enemy_glow_overlay_chams_strength:get()
          local strength_pulse = math.floor(math.sin(global_vars.real_time() * 2) * 50 + 50)

          default_material[1]:set_flag(e_material_flags.IGNOREZ, true)    
          default_material[1]:color_modulate(col_xqz.r / 255, col_xqz.g / 255, col_xqz.b / 255)
          default_material[1]:alpha_modulate(col_xqz.a / 255 )

          ctx:draw_material(default_material[1])

          if enemy_overlay_chams_master:get(2) then
            glow_overlay[1]:set_flag(e_material_flags.IGNOREZ, true)
            glow_overlay[1]:set_shader_param("$envmaptint", vec3_t(col_xqz_glow.r / 255, col_xqz_glow.g / 255, col_xqz_glow.b / 255))
            glow_overlay[1]:set_shader_param("$envmapfresnelminmaxexp", vec3_t(0.0, 1.0, enemy_glow_overlay_chams_strength_pulse:get() and strength_pulse or strength_mod))
            glow_overlay[1]:set_shader_param("$alpha", col_xqz_glow.a / 255)

            ctx:draw_material(glow_overlay[1])
          end

          if enemy_overlay_chams_master:get(4) then
            animated_wireframe_overlay[1]:set_flag(e_material_flags.IGNOREZ, true)    
            animated_wireframe_overlay[1]:color_modulate(col_xqz_wireframe.r / 255, col_xqz_wireframe.g / 255, col_xqz_wireframe.b / 255)
            animated_wireframe_overlay[1]:alpha_modulate(col_xqz_wireframe.a / 255)

            ctx:draw_material(animated_wireframe_overlay[1])
          end
      end
      
      if enemy_vis_base_chams_master:get() then
          ctx.override_original = true
      
          local col_vis = enemy_vis_base_chams_color:get()
          local col_vis_glow = enemy_vis_glow_overlay_chams_color:get()
          local col_vis_wireframe = enemy_vis_animated_wireframe_overlay_chams_color:get()
          local strength_mod = enemy_glow_overlay_chams_strength:get()
          local strength_pulse = math.floor(math.sin(global_vars.real_time() * 2) * 50 + 50)

          default_material[2]:set_flag(e_material_flags.IGNOREZ, false)        
          default_material[2]:color_modulate(col_vis.r / 255, col_vis.g / 255, col_vis.b / 255)
          default_material[2]:alpha_modulate(col_vis.a / 255)

          ctx:draw_material(default_material[2])

          if enemy_overlay_chams_master:get(1) then
            glow_overlay[2]:set_flag(e_material_flags.IGNOREZ, false)
            glow_overlay[2]:set_shader_param("$envmaptint", vec3_t(col_vis_glow.r / 255, col_vis_glow.g / 255, col_vis_glow.b / 255))
            glow_overlay[2]:set_shader_param("$envmapfresnelminmaxexp", vec3_t(0.0, 1.0, enemy_glow_overlay_chams_strength_pulse:get() and strength_pulse or strength_mod))
            glow_overlay[2]:set_shader_param("$alpha", col_vis_glow.a / 255)

            ctx:draw_material(glow_overlay[2])
          end

          if enemy_overlay_chams_master:get(3) then
            animated_wireframe_overlay[2]:set_flag(e_material_flags.IGNOREZ, false)    
            animated_wireframe_overlay[2]:color_modulate(col_vis_wireframe.r / 255, col_vis_wireframe.g / 255, col_vis_wireframe.b / 255)
            animated_wireframe_overlay[2]:alpha_modulate(col_vis_wireframe.a / 255)

            ctx:draw_material(animated_wireframe_overlay[2])
          end
      end
  end
end)