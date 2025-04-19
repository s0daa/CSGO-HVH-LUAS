local material_get_model, material_find = materialsystem.get_model_materials, materialsystem.find_material
local ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_multiselect, ui_get, ui_set_visible, ui_set_callback = ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_multiselect, ui.get, ui.set_visible, ui.set_callback 
local entity_get_local_player, entity_get_prop = entity.get_local_player, entity.get_prop

-- Custom textures
local textures = {

    ["FBI Glass"] = "models/player/ct_fbi/ct_fbi_glass",
    ["Cologne glass"] = "models/inventory_items/cologne_prediction/cologne_prediction_glass",
    ["Crystal clear"] = "models/inventory_items/trophy_majors/crystal_clear",
    ["Gold"] = "models/inventory_items/trophy_majors/gold",
    ["Glass"] = "models/gibs/glass/glass",
    ["Gloss"] = "models/inventory_items/trophy_majors/gloss",
    ["Glow"] = "vgui/achievements/glow",
    ["Wildfire gold"] = "models/inventory_items/wildfire_gold/wildfire_gold_detail",
    ["Crystal blue"] = "models/inventory_items/trophy_majors/crystal_blue",
    ["Velvet"] = "models/inventory_items/trophy_majors/velvet",
    ["Dogtag outline"] = "models/inventory_items/dogtags/dogtags_outline",
    ["Dogtag light"] = "models/inventory_items/dogtags/dogtags_lightray",
    ["Hydra crystal"] = "models/inventory_items/hydra_crystal/hydra_crystal",
    ["MP3 detail"] = "models/inventory_items/music_kit/darude_01/mp3_detail",
    ["Speech info"] = "models/extras/speech_info",
    ["Branches"] = "models/props_foliage/urban_tree03_branches",
    ["ESL_C"] = "models/weapons/customization/stickers/cologne2014/esl_c",
    ["Charset color"] = "models/inventory_items/contributor_map_tokens/contributor_charset_color",
    ["Dogstags"] = "models/inventory_items/dogtags/dogtags",
    ["Dreamhack star"] = "models/inventory_items/dreamhack_trophies/dreamhack_star_blur",
    ["Hydra crystal detail"] = "models/inventory_items/hydra_crystal/hydra_crystal_detail",
    ["2015 glass"] = "models/inventory_items/service_medal_2015/glass",
    ["2016 glass"] = "models/inventory_items/service_medal_2016/glass_lvl4",
    ["Guerilla"] = "models/player/t_guerilla/t_guerilla",
    ["Crystal blue"] = "models/inventory_items/trophy_majors/crystal_blue",
    ["Crystal clear"] = "models/inventory_items/trophy_majors/crystal_clear",
    ["Major gloss"] = "models/inventory_items/trophy_majors/gloss",
    ["Silver winners"] = "models/inventory_items/trophy_majors/silver_winners",
    ["Fishnet"] = "models/props_shacks/fishing_net01",

}

-- Var flags
local material_var_flags = {

    ["DEBUG"] = 0,
    ["NO_DEBUG_OVERRIDE"] = 1,
    ["NO_DRAW"] = 2,
    ["USE_IN_FILLRATE_MODE"] = 3,
    ["VERTEXCOLOR"] = 4,
    ["VERTEXALPHA"] = 5,
    ["SELFILLUM"] = 6,
    ["ADDITIVE"] = 7,
    ["ALPHATEST"] = 8,
    ["MULTIPASS"] = 9,
    ["ZNEARER"] = 10,
    ["MODEL"] = 11,
    ["FLAT"] = 12,
    ["NOCULL"] = 13,
    ["NOFOG"] = 14,
    ["IGNOREZ"] = 15,
    ["DECAL"] = 16,
    ["ENVMAPSPHERE"] = 17,
    ["NOALPHAMOD"] = 18,
    ["ENVMAPCAMERASPACE"] = 19,
    ["BASEALPHAENVMAPMASK"] = 20,
    ["TRANSLUCENT"] = 21,
    ["NORMALMAPALPHAENVMAPMASK"] = 22,
    ["NEEDS_SOFTWARE_SKINNING"] = 23,
    ["OPAQUETEXTURE"] = 24,
    ["ENVMAPMODE"] = 25,
    ["SUPPRESS_DECALS"] = 26,
    ["HALFLAMBERT"] = 27,
    ["WIREFRAME"] = 28,
    ["ALLOWALPHATOCOVERAGE"] = 29,
    ["IGNORE_ALPHA_MODULATION"] = 30,
    ["VERTEXFOG"] = 31,

}

-- Function for getting all texture keys
local function getMenuItems(table)

    local names = {}

    for k, v in pairs(table) do

        names[#names + 1] = k

    end

    return names

end

-- Function binder
local function functionBinder(func, arg)

    return function(callback)

        func(arg)

    end

end

-- Material functions
local function getWeaponMaterial()

    local viewmodel = entity_get_prop(entity_get_local_player(), "m_hViewModel[0]")
    return material_get_model(viewmodel)

end

-- Meta tables
local interface = {}
local interface_mt = {__index = interface}

function interface:init()

    ui_set_callback(self.cham, functionBinder(self.handle_menu, self))
    ui_set_callback(self.color, functionBinder(self.color_modulate, self))
    ui_set_callback(self.texture, functionBinder(self.update, self))
    ui_set_callback(self.flags, functionBinder(self.update, self))

    self.handle_menu(self)

end

function interface.update(self)

    if not ui_get(self.cham) or entity_get_local_player() == nil then

        return

    end

    local current_materials = self:materials()
    local new_material = material_find(textures[ui_get(self.texture)], true)

    local r, g, b, a = ui_get(self.color)
    local flags = ui_get(self.flags)
    
    for i = 1, #current_materials do

        local current_material = current_materials[i]

        -- Caching for reset
        self.cached_materials[current_material] = true

        -- Transfer var flags from the new material to the current one
        for k = 0, 31 do

            current_material:set_material_var_flag(k, new_material:get_material_var_flag(k))

         end
            
        -- Alternate material override
        current_material:set_shader_param(6, new_material:get_shader_param(6))

        -- Set var flags
        for j = 1, #flags do

            local flag_index = material_var_flags[flags[j]]
            local flag_value = current_material:get_material_var_flag(flag_index)
            current_material:set_material_var_flag(flag_index, not flag_value)

        end

        -- Color modulate
        current_material:color_modulate(r, g, b)
        current_material:alpha_modulate(a)

    end

end

function interface.color_modulate(self)

    if not ui_get(self.cham) or entity_get_local_player() == nil then

        return

    end

    local r, g, b, a = ui_get(self.color)
    local current_materials = self:materials()

    for i = 1, #current_materials do

        local current_material = current_materials[i]

        current_material:color_modulate(r, g, b)
        current_material:alpha_modulate(a)

    end

end

function interface:reset()

    local materials = self.cached_materials

    for material, _ in pairs(materials) do

        material:reload()

    end

end

function interface.handle_menu(self)

    local bState = ui_get(self.cham)
    ui_set_visible(self.texture, bState)
    ui_set_visible(self.flags, bState)

    if bState then

        self:update()

    else

        self:reset()

    end

end

local weapon_chams = setmetatable({

    cham = ui_new_checkbox("LUA", "A", "Weapon chams"),
    color = ui_new_color_picker("LUA", "A", "Weapon color", 255, 255, 255, 255),
    texture = ui_new_combobox("LUA", "A", "Weapon materials", getMenuItems(textures)),
    flags = ui_new_multiselect("LUA", "A", "Weapon flags", getMenuItems(material_var_flags)),
    materials = getWeaponMaterial,
    cached_materials = {}

}, interface_mt)

weapon_chams:init()

client.set_event_callback("item_equip", function(e)

    if not ui_get(weapon_chams.cham) then

        return

    end

    if client.userid_to_entindex(e.userid) == entity_get_local_player() then

        weapon_chams:update()

    end

end)

client.set_event_callback("player_connect_full", function(e)

    if client.userid_to_entindex(e.userid) == entity_get_local_player() then

        weapon_chams:update()

    end

end)