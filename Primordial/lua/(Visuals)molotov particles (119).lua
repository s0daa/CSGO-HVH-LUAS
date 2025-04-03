local find_material = materials.find
 
local materials = {
    "particle/fire_burning_character/fire_env_fire_depthblend_oriented",
    "particle/fire_burning_character/fire_burning_character",
    "particle/fire_explosion_1/fire_explosion_1_oriented",
    "particle/fire_explosion_1/fire_explosion_1_bright",
    "particle/fire_burning_character/fire_burning_character_depthblend",
    "particle/fire_burning_character/fire_env_fire_depthblend",
}
 
local function on_event(e)
    if e.name == "molotov_detonate" then
        for _, v in pairs(materials) do
            local molotov = find_material(v)
            if molotov ~= nil then
                molotov:set_flag(e_material_flags.NO_DRAW, false)
                molotov:set_flag(e_material_flags.WIREFRAME, true)
            end
        end
    end
end

callbacks.add(e_callbacks.EVENT, on_event)