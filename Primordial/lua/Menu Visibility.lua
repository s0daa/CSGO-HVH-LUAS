--[[
    Menu Items
]]

-- Anti Aim
local aa_main = menu.add_checkbox("Anti-Aim", "Enable Anti-Aim Functions") -- checkbox ( turn on the indicator)
local aa_slider = menu.add_slider("Anti-Aim", "Slider", 0, 10)
local aa_check = menu.add_checkbox("Anti-Aim", "Slider Check")

-- Visuals
local visuals_main = menu.add_checkbox("Visuals", "Enable Visuals Functions") 
local visual_ch = menu.add_checkbox("Visuals", "Box 1") -- checkbox ( turn on the indicator)

-- Misc
local misc_main = menu.add_checkbox("Misc", "Enable Misc Functions") 
local misc_selection = menu.add_multi_selection("Misc", "Selection", {"item1", "item2", "item3"})

local function handle_menu(reset)
    if reset == false then
     --Anti Aim    
        aa_slider:set_visible(false)
        aa_check:set_visible(false)

        
       if aa_main:get() then
        aa_slider:set_visible(true)
       end

       if aa_slider:get() == 10  then
            aa_check:set_visible(true)
       end

     --Visuals
        visual_ch:set_visible(false)
       

        if visuals_main:get() then 
            visual_ch:set_visible(true)
           
        end

     --Misc
        misc_selection:set_visible(false)
     
        if misc_main:get() then
            misc_selection:set_visible(true)
      
        end


    end
end

local slider = aa_slider:get()

function on_paint()
    handle_menu(false)
end

callbacks.add(e_callbacks.PAINT, on_paint)