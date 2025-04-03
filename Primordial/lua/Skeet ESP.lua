-- // Init fonts

local verdana = {}

for i = 10, 18 do 
    verdana[i]                  = render.create_font("Verdana", i, 24, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
end
local smallest_pixel_9          = render.create_font("Smallest Pixel-7", 9, 155, e_font_flags.OUTLINE)
local smallest_pixel_10         = render.create_font("Smallest Pixel-7", 10, 155, e_font_flags.OUTLINE)

-- // Elements

local boundingbox = menu.add_checkbox("Boxes ESP", "Bounding Box", false)
local boundingbox_color = boundingbox:add_color_picker("Bounding Box")
      boundingbox_color:set(color_t(255,1,1,255))

local fillbox = menu.add_checkbox("Boxes ESP", "Fill Box", false)
local fillbox_color = fillbox:add_color_picker("Fill Box")
      fillbox_color:set(color_t(0, 0, 0, 100))


local nametags = menu.add_checkbox("Text ESP", "Nametags", false)
local nametags_color = nametags:add_color_picker("Nametags")
      nametags_color:set(color_t(255, 255, 255, 255))


local weaponesp = menu.add_checkbox("Text ESP", "Weapon ESP", false)
local weaponesp_color = weaponesp:add_color_picker("Weapon ESP")
      weaponesp_color:set(color_t(255, 255, 255, 255))

local weaponesp_icon = menu.add_checkbox("Text ESP", "Weapon Icon ESP", false)
local weaponesp_icon_color = weaponesp_icon:add_color_picker("Weapon Icon ESP")
      weaponesp_icon_color:set(color_t(255, 255, 255, 255))

local healthbar = menu.add_checkbox("Bars ESP", "Health bars", false)
local healthbar_text = menu.add_checkbox("Bars ESP", "Health Text", false)


local armorbar = menu.add_checkbox("Bars ESP", "Armor bars", false)
local armorbar_color = armorbar:add_color_picker("Armor bars")
      armorbar_color:set(color_t(255,255,255,255))

local money = menu.add_checkbox("Flags", "Money", false)
local money_color = money:add_color_picker("Money")
      money_color:set(color_t(1,255,1,255))

local armor = menu.add_checkbox("Flags", "Armor", false)
local armor_color = armor:add_color_picker("Armor")
      armor_color:set(color_t(255,255,255,255))

local zoom = menu.add_checkbox("Flags", "Zoom", false)
local zoom_color = zoom:add_color_picker("Zoom")
      zoom_color:set(color_t(0,255,255,255))

local smallest_pixel_size = menu.add_slider("Customization", "Smallest Pixel Size", 9, 10)
local verdana_size = menu.add_slider("Customization", "Verdana Size", 10, 18)
verdana_size:set(12)

local dormancy = menu.add_slider("Customization", "Alpha on dormancy", 0, 150)
dormancy:set(50)



-- // Rect that is going from center

function rect(entity, x, y, w, h, r, g, b, a, outline)
    local __ = outline and render.rect or render.rect_filled
    
    __(vec2_t(math.floor(x-w/2),math.floor(y-h/2)), vec2_t(w,h), entity:is_dormant() and color_t(r, g, b, dormancy:get()) or color_t(r, g, b, a), 0)
end


-- // Credits to owner of Custom ESP.lua (I do not claim this part as my own!! [onion])

local files = {} 
files.__index = files 
files.char_buffer = ffi.typeof("char[?]")
files.table = ffi.cast(ffi.typeof("void***"), memory.create_interface("filesystem_stdio.dll", "VBaseFileSystem011"))

files.v_funcs = {
    file_open = ffi.cast(ffi.typeof("void*(__thiscall*)(void*, const char*, const char*, const char*)"), files.table[0][2]),
    file_read = ffi.cast(ffi.typeof("int(__thiscall*)(void*, void*, int, void*)"), files.table[0][0]),
    file_size = ffi.cast(ffi.typeof("unsigned int(__thiscall*)(void*, void*)"), files.table[0][7]),
}

function files.read_file(path)
	local handle = files.v_funcs.file_open(files.table, path, "r", "MOD")
	if (handle == nil) then return end

	local filesize = files.v_funcs.file_size(files.table, handle)
	if (filesize == nil or filesize < 0) then return end

	local buffer = files.char_buffer(filesize + 1)
	if (buffer == nil) then return end

	if (not files.v_funcs.file_read(files.table, buffer, filesize, handle)) then return end

	return ffi.string(buffer, filesize)
end

files.weapon_icons = {}
function files.load_icon(weap)
    local function contains(tbl, text)
        for i = 1, #tbl do
            if (tbl[i][2] == text) then return i end
        end

        return
    end

    if (weap and weap:is_weapon()) then
        local weapon_data = weap:get_weapon_data()
        local item = weapon_data.console_name:gsub("^weapon_", ""):gsub("^item_", "")
        local contained = contains(files.weapon_icons, item)

        if (contained) then
            return files.weapon_icons[contained][1]
        else
            local file_text = files.read_file("materials/panorama/images/icons/equipment/" .. item .. ".svg") -- Engine Read File

            if (file_text) then
                local img = render.load_image_buffer(file_text)

                if (img) then
                    table.insert(files.weapon_icons, {img, item})
                    return img
                end
            end
        end
    end
    
    return
end


-- // Paint Callback

callbacks.add(e_callbacks.PAINT, function()

    -- // Looping through enemies;
    local entities = entity_list.get_players(true)
    if entities then 
        for _,entity in pairs(entities) do
            if entity == nil then 
                return 
            end
            -- // Self check;
            if entity ~= entity_list.get_local_player_or_spectating() then 

                -- // Getting world (vec3) positions of bones;
                local world_head                = entity:get_hitbox_pos(e_hitboxes.HEAD)
                local world_left_foot           = entity:get_hitbox_pos(e_hitboxes.LEFT_FOOT)
                local world_right_foot          = entity:get_hitbox_pos(e_hitboxes.RIGHT_FOOT)
                local world_origin              = entity:get_hitbox_pos(e_hitboxes.PELVIS)
            

                
                -- // Getting screen (vec2) positions of bones;
                local screen_head               = render.world_to_screen(world_head)
                local screen_left_foot          = render.world_to_screen(world_left_foot)
                local screen_right_foot         = render.world_to_screen(world_right_foot)
                local screen_origin             = render.world_to_screen(world_origin)


                -- // Is visible check;

                if screen_head and screen_right_foot and screen_left_foot and screen_origin and entity:is_alive() and entity:get_prop("m_iHealth") ~= 0 then

                    -- // The foot that is on the screen bottom;
                    local real_world_foot_position  = screen_left_foot.y < screen_right_foot.y and screen_left_foot.y or screen_right_foot.y 

                    -- // Mathematics for width and height;
                    local height                    = math.abs(screen_head.y-real_world_foot_position) * 1.2
                    local width                     = height * 0.5

                    -- // Making variables easier;
                    local x, y, w, h                = screen_origin.x, screen_head.y + height / 2, width, height

                    -- // Fill box

                    if fillbox:get() then 
                        rect(entity, x, y, w, h, fillbox_color:get().r, fillbox_color:get().g, fillbox_color:get().b, fillbox_color:get().a)
                    end

                    -- // Bounding box 

                    if boundingbox:get() then 
                        rect(entity, x, y, w-2, h-2, 1, 1, 1, 255, false)
                        rect(entity, x, y, w+2, h+2, 1, 1, 1, 255, false)
                        rect(entity, x, y, w, h, boundingbox_color:get().r, boundingbox_color:get().g, boundingbox_color:get().b, boundingbox_color:get().a, false)
                    end

                    -- // Health bar

                    if healthbar:get() then 

                        local healthbar_mathematics = (entity:get_prop("m_iHealth") or 0) / (entity:get_prop("m_iMaxHealth") or 100)
                        local healthbar_height = healthbar_mathematics * h 
                        local r, g, b, a = math.floor((1-healthbar_mathematics) * 255),math.floor(healthbar_mathematics * 255),0,255

                        rect(entity, x - w / 2 - 4, y, 2, h, 0, 0, 0, 200)
                        rect(entity, x - w / 2 - 4, y, 4, h+2, 0, 0, 0, 255, false)

                        rect(entity, x - w / 2 - 4, y + h / 2 - healthbar_height / 2, 2, healthbar_height, r, g, b, a)

                        if entity:get_prop("m_iHealth") < 99 and healthbar_text:get() then 
                            render.text(smallest_pixel_size:get() == 9 and smallest_pixel_9 or smallest_pixel_10, tostring(entity:get_prop("m_iHealth")), vec2_t(x - w / 2 - 4, y + h / 2 - healthbar_height), color_t(r, g, b, a),true)
                        end

                    end
                    
                    -- // Armor bar

                    minValue = armorbar:get() and (entity:get_prop("m_ArmorValue") > 0 and 0 or 4) or 4

                    if minValue == 0 then 

                        local armorbar_mathematics = (entity:get_prop("m_ArmorValue") or 0)/100
                        local armorbar_width = armorbar_mathematics * w 
                        local r, g, b, a = armorbar_color:get().r, armorbar_color:get().g, armorbar_color:get().b, armorbar_color:get().a


                        rect(entity, x, y + h / 2 + 4, w, 2, 0, 0, 0, 200)
                        rect(entity, x, y + h / 2 + 4, w+2, 4, 0, 0, 0, 255, false)


                        rect(entity, x - w / 2 + armorbar_width / 2, y + h / 2 + 4, armorbar_width, 2, r, g, b, a)
                    end

                    -- // Nametags

                    if nametags:get() then 
                        render.text(verdana[verdana_size:get()], tostring(entity:get_name()), vec2_t(x, y - h / 2 - 7), nametags_color:get(),true)
                    end

                    -- // Weapon ESP

                    local weap = entity:get_active_weapon()

                    if weap then 

                        if weaponesp:get() then 
                            render.text(smallest_pixel_size:get() == 9 and smallest_pixel_9 or smallest_pixel_10, tostring(weap:get_name()), vec2_t(x, y + h / 2 + 12 - minValue), weaponesp_color:get(),true)
                        end

                        if weaponesp_icon:get() then 
                            local weapon_icon = files.load_icon(weap)
                            local weapon_size = vec2_t(weapon_icon.size.x/3, weapon_icon.size.y/3)
                            render.texture(weapon_icon.id, vec2_t(x - weapon_size.x / 2, y + h / 2 + 12 + weapon_size.y / 2 - minValue - (not weaponesp:get() and 11 or 0)), weapon_size, weaponesp_icon_color:get())
                        end

                    end

                    -- // Flags


                    local _x, _y = x + w / 2 + 3, y - h / 2 + 4

                    if money:get() then 
                        local text = tostring("$".. entity:get_prop("m_iAccount"))
                        local size = render.get_text_size(smallest_pixel_size:get() == 9 and smallest_pixel_9 or smallest_pixel_10, text)
                        render.text(smallest_pixel_size:get() == 9 and smallest_pixel_9 or smallest_pixel_10, text, vec2_t(_x + size.x / 2, _y), money_color:get(), false)
                        _y = _y + 9
                    end

                    if armor:get() and entity:get_prop('m_ArmorValue') > 0 then 
                        local text = entity:get_prop('m_bHasHelmet') and 'HK' or entity:get_prop('m_ArmorValue') > 0 and not entity:get_prop('m_bHasHelmet') and 'H'
                        local size = render.get_text_size(smallest_pixel_size:get() == 9 and smallest_pixel_9 or smallest_pixel_10, text)
                        render.text(smallest_pixel_size:get() == 9 and smallest_pixel_9 or smallest_pixel_10, text, vec2_t(_x + size.x / 2, _y), armor_color:get(), false)
                        _y = _y + 9
                    end
                    
                    if zoom:get() and entity:get_prop("m_bIsScoped") then 
                        local text = "Zoom"
                        local size = render.get_text_size(smallest_pixel_size:get() == 9 and smallest_pixel_9 or smallest_pixel_10, text)
                        render.text(smallest_pixel_size:get() == 9 and smallest_pixel_9 or smallest_pixel_10, text, vec2_t(_x + size.x / 2, _y), zoom_color:get(), false)
                        _y = _y + 9
                    end


                


                end
            end

        end
    end
end)