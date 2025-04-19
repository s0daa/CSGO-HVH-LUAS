local weapons = require("weapons")

local g_TextureSpacing = {x = 3, y = 1}

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
local g_HealthRef       = gui.get_config_item("visuals>esp>player>health")

local g_Type            = gui.add_combo("Grenades", "visuals>esp>player", {"Off", "Top", "Bottom", "Left"})
local g_ColorPicker     = gui.add_colorpicker("visuals>esp>player>grenades", true, render.color("#FFFFFF"))





function math.clamp(v, mn, mx)
    return v < mn and mn or v > mx and mx or v
end

local MAXDISTANCE = 2500
local FADEDISTANCE = 50

local EspIconCount = {}

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

        local Distance = math.vec3(Player:get_eye_position()):dist(math.vec3(entities[LP]:get_eye_position()))
        local DistanceMult = 1
        if Distance > MAXDISTANCE then
            DistanceMult = math.clamp(1 - (Distance - MAXDISTANCE) / FADEDISTANCE, 0, 1)
            if DistanceMult <= 0 then
                return
            end
        end

        if DrawType == 3 then
            if Player:is_valid() then
                
                local index_count = 0
                for i = 0, 63 do
                    local handle = Player:get_prop("m_hMyWeapons", i)
                    local ent = entities.get_entity_from_handle(handle)
                    if ent then
                        local item = ent:get_prop("m_iItemDefinitionIndex")

                        if item == 49 then
                            index_count = index_count + 1
                        elseif item == 31 then
                            index_count = index_count + 1
                        end
                    end
                end

                EspIconCount[Player:get_index()] = index_count
            end
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
            TotalWidth = TotalWidth + g_Textures[m_iItemDefinitionIndex].Width + (i == #Grenades and 0 or g_TextureSpacing.x)
        end

        local x, y, x2, y2 = Player:get_bbox()
        if x then
            local Offset = {x = 0, y = 0}

            if DrawType == 1 then
                Offset.y = NameState and 14 or 4
            elseif DrawType == 2 then
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

            local DrawPos = {x = 0, y = 0}

            if DrawType <= 2 then
                DrawPos.x = x + (x2 - x) / 2 - TotalWidth / 2
                DrawPos.y = (DrawType == 1 and y - Offset.y or y2)
            elseif DrawType == 3 then
                DrawPos.x = x - 1
                DrawPos.y = y + 15 * (EspIconCount[Player:get_index()] or 0)
            end

            for _, m_iItemDefinitionIndex in pairs(Grenades) do
                local Texture = g_Textures[m_iItemDefinitionIndex]
                local Width, Height = Texture.Width, Texture.Height
                render.push_texture(Texture.ID)

                if DrawType == 3 then
                    Width       = Width * 0.75
                    Height      = Height * 0.75
                    Offset.x    = -Width - g_TextureSpacing.x - (3 - Width / 2)
                    if g_HealthRef:get_bool() then
                        Offset.x = Offset.x - 6
                    end
                end


                local Min = DrawType == 1 and {x = DrawPos.x + Offset.x, y = DrawPos.y - Height} or {x = DrawPos.x + Offset.x, y = DrawPos.y + Offset.y }
                local Max = DrawType == 1 and {x = DrawPos.x + Offset.x + Width, y = DrawPos.y} or {x = DrawPos.x + Offset.x + Width, y = DrawPos.y + Offset.y + Height}

                render.rect_filled(Min.x + 1, Min.y + 1, Max.x + 1, Max.y + 1, render.color(50, 50, 50, DrawColor.a * DistanceMult))
                render.rect_filled(Min.x, Min.y, Max.x, Max.y, render.color(DrawColor.r, DrawColor.g, DrawColor.b, DrawColor.a * DistanceMult))
                render.pop_texture()

                if DrawType <= 2 then
                    Offset.x = Offset.x + Width + g_TextureSpacing.x
                else
                    Offset.y = Offset.y + Height + g_TextureSpacing.y
                end
            end
        end
    end)
end