-- local variables for API functions. any changes to the line below will be lost on re-generation
local callbacks_add, entity_list_get_local_player, global_vars_real_time, materials_create, math_floor, math_sin, menu_add_checkbox, menu_add_multi_selection, menu_add_slider = callbacks.add, entity_list.get_local_player, global_vars.real_time, materials.create, math.floor, math.sin, menu.add_checkbox, menu.add_multi_selection, menu.add_slider

local enable_local = menu_add_checkbox("local", "Enable local chams")
local local_vis_base_chams_color = enable_local:add_color_picker("enemy_vis_base_chams_color", color_t(150, 200, 60, 255))
local local_overlay_chams_master = menu_add_multi_selection("local","local overlay materials",{"glow", "glow xqz","animated wireframe", "animated wireframe xqz"})
local local_xqz_glow_overlay_chams_color = local_overlay_chams_master:add_color_picker("local_xqz_glow_overlay_chams_color", color_t(63, 92, 120, 255))
local local_xqz_animated_wireframe_overlay_chams_color = local_overlay_chams_master:add_color_picker("local_xqz_animated_wireframe_overlay_chams_color", color_t(90, 136, 182, 255))
local local_vis_glow_overlay_chams_color = local_overlay_chams_master:add_color_picker("local_vis_glow_overlay_chams_color", color_t(55, 21, 60, 255))
local local_vis_animated_wireframe_overlay_chams_color = local_overlay_chams_master:add_color_picker("local_is_animated_wireframe_overlay_chams_color", color_t(189, 37, 113, 255))
local local_glow_overlay_chams_strength_pulse = menu_add_checkbox("local", "Enable local glow overlay pulse")
local local_glow_overlay_chams_strength = menu_add_slider("local", "local glow overlay strength", 1, 100)

local enable_un_enemy = menu_add_checkbox("enemy", "Enable enemy chams")
local enemy_un_vis_base_chams_color = enable_un_enemy:add_color_picker("enemy_vis_base_chams_color", color_t(150, 200, 60, 255))
local enemy_un_overlay_chams_master = menu_add_multi_selection("enemy","enemy overlay materials",{"glow", "glow xqz","animated wireframe", "animated wireframe xqz"})
local enemy_un_xqz_glow_overlay_chams_color = enemy_un_overlay_chams_master:add_color_picker("enemy_xqz_glow_overlay_chams_color", color_t(63, 92, 120, 255))
local enemy_un_xqz_animated_wireframe_overlay_chams_color = enemy_un_overlay_chams_master:add_color_picker("enemy_xqz_animated_wireframe_overlay_chams_color", color_t(90, 136, 182, 255))
local enemy_un_vis_glow_overlay_chams_color = enemy_un_overlay_chams_master:add_color_picker("enemy_vis_glow_overlay_chams_color", color_t(55, 21, 60, 255))
local enemy_un_vis_animated_wireframe_overlay_chams_color = enemy_un_overlay_chams_master:add_color_picker("enemy_vis_animated_wireframe_overlay_chams_color", color_t(189, 37, 113, 255))
local enemy_un_glow_overlay_chams_strength_pulse = menu_add_checkbox("enemy", "Enable enemy glow overlay pulse")
local enemy_un_glow_overlay_chams_strength = menu_add_slider("enemy", "enemy glow overlay strength", 1, 100)

local enable_atah = menu_add_checkbox("atachmen", "Enable atachmen chams")
local atah_vis_base_chams_color = enable_atah:add_color_picker("enemy_vis_base_chams_color", color_t(150, 200, 60, 255))
local atah_overlay_chams_master = menu_add_multi_selection("atachmen","atachmen overlay materials",{"glow", "glow xqz","animated wireframe", "animated wireframe xqz"})
local atah_xqz_glow_overlay_chams_color = atah_overlay_chams_master:add_color_picker("enemy_xqz_glow_overlay_chams_color", color_t(63, 92, 120, 255))
local atah_xqz_animated_wireframe_overlay_chams_color = atah_overlay_chams_master:add_color_picker("enemy_xqz_animated_wireframe_overlay_chams_color", color_t(90, 136, 182, 255))
local atah_vis_glow_overlay_chams_color = atah_overlay_chams_master:add_color_picker("enemy_vis_glow_overlay_chams_color", color_t(55, 21, 60, 255))
local atah_vis_animated_wireframe_overlay_chams_color = atah_overlay_chams_master:add_color_picker("enemy_vis_animated_wireframe_overlay_chams_color", color_t(189, 37, 113, 255))
local atah_glow_overlay_chams_strength_pulse = menu_add_checkbox("atachmen", "Enable atachmen glow overlay pulse")
local atah_glow_overlay_chams_strength = menu_add_slider("atachmen", "atachmen glow overlay strength", 1, 100)

local enable_sl = menu_add_checkbox("arms", "Enable arms chams")
local sl_vis_base_chams_color = enable_sl:add_color_picker("enemy_vis_base_chams_color", color_t(150, 200, 60, 255))
local sl_overlay_chams_master = menu_add_multi_selection("arms","arms overlay materials",{"glow", "glow xqz","animated wireframe", "animated wireframe xqz"})
local sl_xqz_glow_overlay_chams_color = sl_overlay_chams_master:add_color_picker("enemy_xqz_glow_overlay_chams_color", color_t(63, 92, 120, 255))
local sl_xqz_animated_wireframe_overlay_chams_color = sl_overlay_chams_master:add_color_picker("enemy_xqz_animated_wireframe_overlay_chams_color", color_t(90, 136, 182, 255))
local sl_vis_glow_overlay_chams_color = sl_overlay_chams_master:add_color_picker("enemy_vis_glow_overlay_chams_color", color_t(55, 21, 60, 255))
local sl_vis_animated_wireframe_overlay_chams_color = sl_overlay_chams_master:add_color_picker("enemy_vis_animated_wireframe_overlay_chams_color", color_t(189, 37, 113, 255))
local sl_glow_overlay_chams_strength_pulse = menu_add_checkbox("arms", "Enable arms glow overlay pulse")
local sl_glow_overlay_chams_strength = menu_add_slider("arms", "arms glow overlay strength", 1, 100)

local enable_weapon = menu_add_checkbox("weapon", "Enable weapon chams")
local weapon_vis_base_chams_color = enable_weapon:add_color_picker("enemy_vis_base_chams_color", color_t(150, 200, 60, 255))
local weapon_overlay_chams_master = menu_add_multi_selection("weapon","weapon overlay materials",{"glow", "glow xqz","animated wireframe", "animated wireframe xqz"})
local weapon_xqz_glow_overlay_chams_color = weapon_overlay_chams_master:add_color_picker("enemy_xqz_glow_overlay_chams_color", color_t(63, 92, 120, 255))
local weapon_xqz_animated_wireframe_overlay_chams_color = weapon_overlay_chams_master:add_color_picker("enemy_xqz_animated_wireframe_overlay_chams_color", color_t(90, 136, 182, 255))
local weapon_vis_glow_overlay_chams_color = weapon_overlay_chams_master:add_color_picker("enemy_vis_glow_overlay_chams_color", color_t(55, 21, 60, 255))
local weapon_vis_animated_wireframe_overlay_chams_color = weapon_overlay_chams_master:add_color_picker("enemy_vis_animated_wireframe_overlay_chams_color", color_t(189, 37, 113, 255))
local weapon_glow_overlay_chams_strength_pulse = menu_add_checkbox("weapon", "Enable weapon glow overlay pulse")
local weapon_glow_overlay_chams_strength = menu_add_slider("weapon", "weapon glow overlay strength", 1, 100)

local create_material = function(mat, name, count)
   local t = {}
   
   for i=1, count do
       table.insert(t, materials.create( ("t_%s_%i"):format(name, i), mat ) )
   end
   
   return t
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

function local_p(ctx)
   if enable_local:get() == false then return end
   if entity_list_get_local_player() == nil then return end
   if ctx.model_name:find("_dropped.mdl") then return end
   if ctx.model_name:find("w_models") then return end
   if ctx.model_name:find("weapons/w") then return end
   if ctx.model_name:find("weapons/v_") then return end
   if ctx.model_name:find("models/player") == nil and not entity_list_get_local_player() then 
      return
   end
   --if ctx.entity == entity_list_get_local_player() then return end

   local col_vis = local_vis_base_chams_color:get()
   local col_vis_glow = local_vis_glow_overlay_chams_color:get()
   local col_vis_wireframe = local_vis_animated_wireframe_overlay_chams_color:get()
   local strength_mod = local_glow_overlay_chams_strength:get()
   local strength_pulse = math_floor(math_sin(global_vars_real_time() * 2) * 50 + 50)

   if ctx.entity:is_player() and not ctx.entity:is_enemy() and entity_list_get_local_player() then
      default_material[2]:set_flag(e_material_flags.IGNOREZ, false)        
      default_material[2]:color_modulate(col_vis.r / 255, col_vis.g / 255, col_vis.b / 255)
      default_material[2]:alpha_modulate(col_vis.a / 255)
      ctx:draw_material(default_material)

      if local_overlay_chams_master:get(1) then
         glow_overlay[2]:set_flag(e_material_flags.IGNOREZ, false)
         glow_overlay[2]:set_shader_param("$envmaptint", vec3_t(col_vis_glow.r / 255, col_vis_glow.g / 255, col_vis_glow.b / 255))
         glow_overlay[2]:set_shader_param("$envmapfresnelminmaxexp", vec3_t(0.0, 1.0, local_glow_overlay_chams_strength_pulse:get() and strength_pulse or strength_mod))
         glow_overlay[2]:set_shader_param("$alpha", col_vis_glow.a / 255)
         ctx:draw_material(glow_overlay)
      end

      if local_overlay_chams_master:get(3) then
         animated_wireframe_overlay[2]:set_flag(e_material_flags.IGNOREZ, false)    
         animated_wireframe_overlay[2]:color_modulate(col_vis_wireframe.r / 255, col_vis_wireframe.g / 255, col_vis_wireframe.b / 255)
         animated_wireframe_overlay[2]:alpha_modulate(col_vis_wireframe.a / 255)
         ctx:draw_material(animated_wireframe_overlay)
      end
   end
end

function enemy_p_wal(ctx)
   if enable_un_enemy:get() == false then return end
   if entity_list_get_local_player() == nil then return end
   if ctx.model_name:find("_dropped.mdl") then return end
   if ctx.model_name:find("w_models") then return end
   if ctx.model_name:find("weapons/w") then return end
   if ctx.model_name:find("weapons/v_") then return end
   if ctx.model_name:find("models/player") == nil and not entity_list_get_local_player() then 
      return
   end

   if ctx.entity:is_player() and ctx.entity:is_enemy() then
      local col_vis = enemy_un_vis_base_chams_color:get()
      local col_vis_glow = enemy_un_vis_glow_overlay_chams_color:get()
      local col_vis_wireframe = enemy_un_vis_animated_wireframe_overlay_chams_color:get()
      local strength_mod = enemy_un_glow_overlay_chams_strength:get()
      local strength_pulse = math_floor(math_sin(global_vars_real_time() * 2) * 50 + 50)

      default_material[2]:set_flag(e_material_flags.IGNOREZ, true)        
      default_material[2]:color_modulate(col_vis.r / 255, col_vis.g / 255, col_vis.b / 255)
      default_material[2]:alpha_modulate(col_vis.a / 255)
      ctx:draw_material(default_material)

      if enemy_un_overlay_chams_master:get(1) then
         glow_overlay[2]:set_flag(e_material_flags.IGNOREZ, true)
         glow_overlay[2]:set_shader_param("$envmaptint", vec3_t(col_vis_glow.r / 255, col_vis_glow.g / 255, col_vis_glow.b / 255))
         glow_overlay[2]:set_shader_param("$envmapfresnelminmaxexp", vec3_t(0.0, 1.0, enemy_un_glow_overlay_chams_strength_pulse:get() and strength_pulse or strength_mod))
         glow_overlay[2]:set_shader_param("$alpha", col_vis_glow.a / 255)
         ctx:draw_material(glow_overlay)
      end

      if enemy_un_overlay_chams_master:get(3) then
         animated_wireframe_overlay[2]:set_flag(e_material_flags.IGNOREZ, true)
         animated_wireframe_overlay[2]:color_modulate(col_vis_wireframe.r / 255, col_vis_wireframe.g / 255, col_vis_wireframe.b / 255)
         animated_wireframe_overlay[2]:alpha_modulate(col_vis_wireframe.a / 255)
         ctx:draw_material(animated_wireframe_overlay)
      end
   end
end

function atah_lp(ctx)
   if enable_atah:get() == false then return end
   if entity_list_get_local_player() == nil then return end
   --if ctx.model_name:find("_dropped.mdl") then return end
   --if ctx.model_name:find("w_models") then return end
   if ctx.model_name:find("ied_dropped") then return end
   if ctx.model_name:find("arms") then return end

   local col_vis = atah_vis_base_chams_color:get()
   local col_vis_glow = atah_vis_glow_overlay_chams_color:get()
   local col_vis_wireframe = atah_vis_animated_wireframe_overlay_chams_color:get()
   local strength_mod = atah_glow_overlay_chams_strength:get()
   local strength_pulse = math_floor(math_sin(global_vars_real_time() * 2) * 50 + 50)

   if ctx.model_name:find("_dropped.mdl") or ctx.model_name:find("weapons/w") then
      default_material[2]:set_flag(e_material_flags.IGNOREZ, false)        
      default_material[2]:color_modulate(col_vis.r / 255, col_vis.g / 255, col_vis.b / 255)
      default_material[2]:alpha_modulate(col_vis.a / 255)
      ctx:draw_material(default_material)

      if atah_overlay_chams_master:get(1) then
         glow_overlay[2]:set_flag(e_material_flags.IGNOREZ, false)
         glow_overlay[2]:set_shader_param("$envmaptint", vec3_t(col_vis_glow.r / 255, col_vis_glow.g / 255, col_vis_glow.b / 255))
         glow_overlay[2]:set_shader_param("$envmapfresnelminmaxexp", vec3_t(0.0, 1.0, atah_glow_overlay_chams_strength_pulse:get() and strength_pulse or strength_mod))
         glow_overlay[2]:set_shader_param("$alpha", col_vis_glow.a / 255)
         ctx:draw_material(glow_overlay)
      end

      if atah_overlay_chams_master:get(3) then
         animated_wireframe_overlay[2]:set_flag(e_material_flags.IGNOREZ, false)    
         animated_wireframe_overlay[2]:color_modulate(col_vis_wireframe.r / 255, col_vis_wireframe.g / 255, col_vis_wireframe.b / 255)
         animated_wireframe_overlay[2]:alpha_modulate(col_vis_wireframe.a / 255)
         ctx:draw_material(animated_wireframe_overlay)
      end
   end
end

function sleeves(ctx)
   if enable_sl:get() == false then return end
   if entity_list_get_local_player() == nil then return end

   local col_vis = sl_vis_base_chams_color:get()
   local col_vis_glow = sl_vis_glow_overlay_chams_color:get()
   local col_vis_wireframe = sl_vis_animated_wireframe_overlay_chams_color:get()
   local strength_mod = sl_glow_overlay_chams_strength:get()
   local strength_pulse = math_floor(math_sin(global_vars_real_time() * 2) * 50 + 50)

   if ctx.model_name:find("arms") and not ctx.model_name:find("_dropped.mdl") and not ctx.model_name:find("weapons/w") and not ctx.model_name:find("ied_dropped") then
      default_material[2]:set_flag(e_material_flags.IGNOREZ, false)        
      default_material[2]:color_modulate(col_vis.r / 255, col_vis.g / 255, col_vis.b / 255)
      default_material[2]:alpha_modulate(col_vis.a / 255)
      ctx:draw_material(default_material)

      if sl_overlay_chams_master:get(1) then
         glow_overlay[2]:set_flag(e_material_flags.IGNOREZ, false)
         glow_overlay[2]:set_shader_param("$envmaptint", vec3_t(col_vis_glow.r / 255, col_vis_glow.g / 255, col_vis_glow.b / 255))
         glow_overlay[2]:set_shader_param("$envmapfresnelminmaxexp", vec3_t(0.0, 1.0, sl_glow_overlay_chams_strength_pulse:get() and strength_pulse or strength_mod))
         glow_overlay[2]:set_shader_param("$alpha", col_vis_glow.a / 255)
         ctx:draw_material(glow_overlay)
      end

      if sl_overlay_chams_master:get(3) then
         animated_wireframe_overlay[2]:set_flag(e_material_flags.IGNOREZ, false)    
         animated_wireframe_overlay[2]:color_modulate(col_vis_wireframe.r / 255, col_vis_wireframe.g / 255, col_vis_wireframe.b / 255)
         animated_wireframe_overlay[2]:alpha_modulate(col_vis_wireframe.a / 255)
         ctx:draw_material(animated_wireframe_overlay)
      end
   end
end

function weapon_lp(ctx)
   if enable_weapon:get() == false then return end
   if entity_list_get_local_player() == nil then return end
   if ctx.model_name:find("_dropped.mdl") then return end
   if ctx.model_name:find("w_models") then return end
   if ctx.model_name:find("weapons/w") then return end
   --if ctx.model_name:find("weapons/v_") then return end

   local col_vis = weapon_vis_base_chams_color:get()
   local col_vis_glow = weapon_vis_glow_overlay_chams_color:get()
   local col_vis_wireframe = weapon_vis_animated_wireframe_overlay_chams_color:get()
   local strength_mod = weapon_glow_overlay_chams_strength:get()
   local strength_pulse = math_floor(math_sin(global_vars_real_time() * 2) * 50 + 50)

   if ctx.model_name:find("weapons/v_") and not ctx.model_name:find("arms") then
      default_material[2]:set_flag(e_material_flags.IGNOREZ, false)        
      default_material[2]:color_modulate(col_vis.r / 255, col_vis.g / 255, col_vis.b / 255)
      default_material[2]:alpha_modulate(col_vis.a / 255)
      ctx:draw_material(default_material)

      if weapon_overlay_chams_master:get(1) then
         glow_overlay[2]:set_flag(e_material_flags.IGNOREZ, false)
         glow_overlay[2]:set_shader_param("$envmaptint", vec3_t(col_vis_glow.r / 255, col_vis_glow.g / 255, col_vis_glow.b / 255))
         glow_overlay[2]:set_shader_param("$envmapfresnelminmaxexp", vec3_t(0.0, 1.0, atah_glow_overlay_chams_strength_pulse:get() and strength_pulse or strength_mod))
         glow_overlay[2]:set_shader_param("$alpha", col_vis_glow.a / 255)
         ctx:draw_material(glow_overlay)
      end

      if weapon_overlay_chams_master:get(3) then
         animated_wireframe_overlay[2]:set_flag(e_material_flags.IGNOREZ, false)    
         animated_wireframe_overlay[2]:color_modulate(col_vis_wireframe.r / 255, col_vis_wireframe.g / 255, col_vis_wireframe.b / 255)
         animated_wireframe_overlay[2]:alpha_modulate(col_vis_wireframe.a / 255)
         ctx:draw_material(animated_wireframe_overlay)
      end
   end
end

function on_draw_model(ctx)
    local_p(ctx)
    enemy_p_wal(ctx)
    atah_lp(ctx)
    sleeves(ctx)
    weapon_lp(ctx)
end

callbacks_add(e_callbacks.DRAW_MODEL, on_draw_model)