local materials = {
    "particle/particle_flares/particle_flare_gray",
    "particle/smoke1/smoke1_nearcull2",
    "particle/vistasmokev1/vistasmokev1_nearcull",
    "particle/smoke1/smoke1_nearcull",
    "particle/vistasmokev1/vistasmokev1_nearcull_nodepth",
    "particle/vistasmokev1/vistasmokev1_nearcull_fog",
    "particle/vistasmokev1/vistasmokev4_nearcull",
    "particle/smoke1/smoke1_nearcull3",

    "particle/fire_burning_character/fire_env_fire_depthblend_oriented",
    "particle/fire_burning_character/fire_burning_character",

    -- "particle/fire_burning_character/fire_env_fire",

    "particle/fire_explosion_1/fire_explosion_1_oriented",
    "particle/fire_explosion_1/fire_explosion_1_bright",

    "particle/fire_burning_character/fire_burning_character_depthblend",
    "particle/fire_burning_character/fire_env_fire_depthblend",

}

local set_materials = nil
local find_material = materialsystem.find_material

set_materials = function()
    for _, v in pairs(materials) do
        local material = find_material(v)
    
        if material ~= nil then
            local is_fire = v:match('fire') ~= nil

            material:set_material_var_flag(2, not is_fire)
            material:set_material_var_flag(28, is_fire)
        end
    end

    client.delay_call(3, set_materials)
end

set_materials()
