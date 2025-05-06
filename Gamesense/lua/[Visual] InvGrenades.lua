local weapons = require("weapons")

local g_TextureSpacing = 3

local TextureInfo = function (weapon_name)
    local id, w, h = weapons[weapon_name]:get_texture(17)
    return {ID =  id, Width = w, Height = h}
end

local g_Textures = 
{
    [43] = TextureInfo("weapon_flashbang"),
    [44] = TextureInfo("weapon_hegrenade"),
    [45] = TextureInfo("weapon_smokegrenade"),
    [46] = TextureInfo("weapon_molotov"),
    [47] = TextureInfo("weapon_decoy"),
    [48] = TextureInfo("weapon_incgrenade"),
}

local g_SortTable = 
{
    [43] = 4,
    [44] = 5,
    [45] = 3,
    [46] = 1,
    [47] = 6,
    [48] = 2,
}
local SortCallback = function (a, b)return g_SortTable[a] < g_SortTable[b] end

local g_NameRef         = gui.get_config_item("visuals>esp>player>name")
local g_WeaponTextRef   = gui.get_config_item("visuals>esp>player>weapon")
local g_WeaponIconRef   = gui.get_config_item("visuals>esp>player>weapon icons")
local g_AmmoRef         = gui.get_config_item("visuals>esp>player>ammo")

local g_Type = gui.add_combo("Grenades", "visuals>esp>player", {"Off", "Top", "Bottom"})
local g_ColorPicker = gui.add_colorpicker("visuals>esp>player>grenades", true, render.color("#FFFFFF"))

function on_paint()
    local DrawType = g_Type:get_int()
    if DrawType == 0 then
        return
    end

    local NameState         = g_NameRef:get_bool()
    local WeaponTextState   = g_WeaponTextRef:get_bool()
    local WeaponIconState   = g_WeaponIconRef:get_bool()
    local AmmoState         = g_AmmoRef:get_bool()
    local Color             = g_ColorPicker:get_color()

    local LP = engine.get_local_player()
    entities.for_each_player(function(Player)
        if not Player:is_alive() or Player:get_index() == LP or not Player:is_enemy() then
            return
        end

        local Grenades = {}
        for i = 0, 63 do
            local WeaponHandle = Player:get_prop("m_hMyWeapons", i)
            local Weapon = entities.get_entity_from_handle(WeaponHandle)
            if Weapon then
                local m_iItemDefinitionIndex = Weapon:get_prop("m_iItemDefinitionIndex")
                if g_Textures[m_iItemDefinitionIndex] then
                    table.insert(Grenades, m_iItemDefinitionIndex)
                end
            end
        end

        if #Grenades == 0 then
            return
        end

        table.sort(Grenades, SortCallback)

        local DrawColor     = Player:is_valid() and Color or render.color(225, 225, 225, Color.a * (Player:get_esp_alpha() / 255))
        local TotalWidth    = 0

        for i, m_iItemDefinitionIndex in pairs(Grenades) do
            TotalWidth = TotalWidth + g_Textures[m_iItemDefinitionIndex].Width + (i == #Grenades and 0 or g_TextureSpacing)
        end


        local x, y, x2, y2 = Player:get_bbox()
        if x then
            local Offset = {x = 0, y = 0}

            if DrawType == 1 then
                Offset.y = NameState and 14 or 4
            else
                if AmmoState then
                    Offset.y = Offset.y + 5
                end
                
                if WeaponTextState then
                    Offset.y = Offset.y + 8
                end

                if WeaponIconState then
                    Offset.y = Offset.y + 13
                end
            end

            local DrawPos = {x = x + (x2 - x) / 2 - TotalWidth / 2 , y = (DrawType == 1 and y - Offset.y or y2 + Offset.y)}
            for _, m_iItemDefinitionIndex in pairs(Grenades) do
                local Texture = g_Textures[m_iItemDefinitionIndex]
                
                render.push_texture(Texture.ID)

                local Min = DrawType == 1 and {x = DrawPos.x + Offset.x, y = DrawPos.y - Texture.Height} or {x = DrawPos.x + Offset.x, y = DrawPos.y }
                local Max = DrawType == 1 and {x = DrawPos.x + Offset.x + Texture.Width, y = DrawPos.y} or {x = DrawPos.x + Offset.x + Texture.Width, y = DrawPos.y + Texture.Height}



                render.rect_filled(Min.x + 1, Min.y + 1, Max.x + 1, Max.y + 1, render.color(50, 50, 50, DrawColor.a))
                render.rect_filled(Min.x, Min.y, Max.x, Max.y, DrawColor)
                render.pop_texture()


                Offset.x = Offset.x + Texture.Width + g_TextureSpacing
            end
        end
    end)
end