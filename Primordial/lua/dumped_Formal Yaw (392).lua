local math_lerp = function(start, vend, time)
    return start + (vend - start) * time
end
local yaw = menu.add_slider("group", "yaw", -80, 80)
local jitter = menu.add_slider("group", "jitter", -80, 80)

local inv = false

local yawadd    = menu.find("antiaim", "main", "angles", "yaw add")
local jitteradd    = menu.find("antiaim", "main", "angles", "jitter add")

local side      = menu.find("antiaim", "main", "desync", "side")
local defside      = menu.find("antiaim", "main", "desync", "default side")
local leftamt   = menu.find("antiaim", "main", "desync", "left amount")
local rigtamt   = menu.find("antiaim", "main", "desync", "right amount")
local font_inds = render.create_font("Smallest Pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE) -- font
local alpha = 255
local cycle = 1
local screen_size = render.get_screen_size() -- screen
local x, y = screen_size.x / 2, screen_size.y / 2 -- x and y
local checkbox = menu.add_checkbox("Indicator", "Turn On") -- checkbox ( turn on the indicator)
local scope = 0
local dt_ref = menu.find("aimbot","general","exploits","doubletap","enable") -- get doubletap
local hs_ref = menu.find("aimbot","general","exploits","hideshots","enable") -- get hideshots
local direction = menu.find("antiaim","main","auto direction","enable") -- get auto direction 
local damage_override_auto = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local fakelag = menu.find('antiaim', 'main', 'fakelag', 'amount')
local dt_recharget = 0
local fakelag_cache = 14
local function cache()
    local fakelag_cache = menu.find('antiaim', 'main', 'fakelag', 'amount'):get()
    
end
--#region indicators
function on_paint()

    if not engine.is_connected() then
        return
      end
      
    if not engine.is_in_game() then
        return
    end
      
    local local_player = entity_list.get_local_player()
 
   scope = math_lerp(scope, local_player:get_prop("m_bIsScoped") == 1 and -58 or 0, 8 * global_vars.frame_time())
    if not local_player:get_prop("m_iHealth") then
        return
    end

    local baim_color = color_t(255,255,255,255)
	local hs_color = color_t(255,255,255,255)
	local sp_color = color_t(255,255,255,255)
	local fakeduck_color = color_t(255,255,255,255)
    local damage_color = color_t(255,255,255,255)

    if local_player:is_alive() then
        if checkbox:get() then
            if cycle == 1 then
                alpha = alpha - 1
             else
                 alpha = alpha + 1
             end
         
             if alpha <= 0 then
                cycle = 0
             elseif alpha >= 255 then
                cycle = 1
             end
            local ind_dst = 0
            local ind_spr = 8

            local text = "BASIC"
            local size = render.get_text_size(font_inds, text)

            if direction[2]:get() then
                acatel_style_2 = "FREESTAND"
            elseif antiaim.is_inverting_desync() then
                acatel_style_2 = "LEFT"
            else
                acatel_style_2 = "RIGHT"
            end
                render.text(font_inds, "FORMAL  ", vec2_t(x + scope , y + 19), color_t(97, 117, 250, 255))
                render.text(font_inds, "YAW  ", vec2_t(x + 35 + scope, y + 19), color_t(255,255,255,alpha)) 
                render.text(font_inds, "SIDE:  ", vec2_t(x + scope, y + 28.5), color_t(220, 91, 97, 255)) -- render text
                render.text(font_inds, acatel_style_2, vec2_t(x + 27 + scope, y + 28), color_t(138, 137, 204, 255)) -- render text
                    
                local dt_color = color_t(1,1,1,255)
                    
                if dt_ref[2]:get() then
                    
                    if exploits.get_charge() < 1 then
                        dt_color = color_t(255,0,0,255)
                    else
                        dt_color = color_t(255,255,255,255)
                    end
                end
                    
                --DT
                if dt_ref[2]:get() then
                    render.text(font_inds, "DT", vec2_t(x + scope, y + 36 + ind_dst), dt_color) -- render text
                else
                    render.text(font_inds, "DT", vec2_t(x + scope, y + 36 + ind_dst), color_t(48,48,48,255)) -- render tex
                end

                -- hideshots
                if hs_ref[2]:get() then
                    render.text(font_inds, "HS", vec2_t(x+ scope + 13, y + 36 + ind_dst), hs_color) -- render text
                else
                    render.text(font_inds, "HS", vec2_t(x+ scope + 13, y + 36 + ind_dst), color_t(48,48,48,255)) -- render text
                end

                -- safepoint
                if antiaim.is_fakeducking() then
                    render.text(font_inds, "FD", vec2_t(x+ scope + 26, y + 36 + ind_dst), fakeduck_color) -- render text
                else
                    render.text(font_inds, "FD", vec2_t(x+ scope + 26, y + 36 + ind_dst), color_t(48,48,48,255)) -- render text
                end

                -- damage override
                if damage_override_auto[2]:get() then
                    render.text(font_inds, "DMG", vec2_t(x+ scope + 39, y + 36 + ind_dst), damage_color) -- render text
                else
                    render.text(font_inds, "DMG", vec2_t(x+ scope + 39, y + 36 + ind_dst), color_t(48,48,48,255)) -- render text
                end
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)
--#endregion
local dt_charge_status = false
function dtfix()
    local_player = entity_list:get_local_player()
    local velocity = local_player:get_prop("m_vecVelocity"):length()
    velocity = math.floor(velocity + 0.5)




   
        if dt_ref then
  
      
            if not dt_charge_status then
                exploits.force_recharge()
      
                if exploits.get_charge() == 1 then
      
                    dt_charge_status = true
                end
            end
        else
      
            dt_charge_status = false
        end
    end

--local function aa()

    
--end
      --#region callbacks
      local function run()
        cache()
       dtfix()
      end
      callbacks.add(e_callbacks.RUN_COMMAND, run)


      --#endregion callback
      callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
        if cmd.command_number % 4 > 1 then
            inv = true
        else
            inv = false
            
        end
        local local_player = entity_list.get_local_player()
    
        if not local_player:has_player_flag(e_player_flags.ON_GROUND) then
            on_ground = false
        else
            on_ground = true
        end
    
        if cmd:has_button(e_cmd_buttons.DUCK) and not inaircrc then
            crouching = true
        else
            crouching = false
        end
    end)
    callbacks.add(e_callbacks.ANTIAIM, function(ctx)
        
        local_player = entity_list:get_local_player()
        local velocity = local_player:get_prop("m_vecVelocity"):length()
        velocity = math.floor(velocity + 0.5)
      
 ctx:set_invert_desync(inv)  
        if inv  then
            menu.find("antiaim", "main", "angles", "yaw add"):set(math.floor(jitter:get()/2+yaw:get()))
        else
            menu.find("antiaim", "main", "angles", "yaw add"):set(-math.floor(jitter:get()/2-yaw:get()))
        end
 
if velocity > 5 and on_ground and not crouching then
jitter:set(71)  
    side:set(2)    
      
    leftamt:set(88)  
    rigtamt:set(94)  
    yaw:set(0)


elseif not on_ground and not crouching then
    jitter:set(65)     
    side:set(2)
    leftamt:set(80)  
    rigtamt:set(69)  

    yaw:set(0)





elseif not on_ground and crouching then
    jitter:set(62)     
    side:set(2)
    leftamt:set(60)  
    rigtamt:set(60)
    yaw:set(13)


end

    end)