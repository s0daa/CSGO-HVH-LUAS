--[[
    Filesystem Library
--]]

local filesystem = {} filesystem.__index = filesystem filesystem.char_buffer = ffi.typeof("char[?]")
filesystem.table = ffi.cast(ffi.typeof("void***"), memory.create_interface("filesystem_stdio.dll", "VBaseFileSystem011"))

filesystem.v_funcs = {
    file_open = ffi.cast(ffi.typeof("void*(__thiscall*)(void*, const char*, const char*, const char*)"), filesystem.table[0][2]),
    file_read = ffi.cast(ffi.typeof("int(__thiscall*)(void*, void*, int, void*)"), filesystem.table[0][0]),
    file_size = ffi.cast(ffi.typeof("unsigned int(__thiscall*)(void*, void*)"), filesystem.table[0][7]),
}

function filesystem.read_file(path)
	local handle = filesystem.v_funcs.file_open(filesystem.table, path, "r", "MOD")
	if (handle == nil) then return end

	local filesize = filesystem.v_funcs.file_size(filesystem.table, handle)
	if (filesize == nil or filesize < 0) then return end

	local buffer = filesystem.char_buffer(filesize + 1)
	if (buffer == nil) then return end

	if (not filesystem.v_funcs.file_read(filesystem.table, buffer, filesize, handle)) then return end

	return ffi.string(buffer, filesize)
end

filesystem.weapon_icons = {}
function filesystem.load_icon(weap)
    local function contains(tbl, text)
        for i = 1, #tbl do
            if (tbl[i][2] == text) then return i end
        end

        return
    end

    if (weap and weap:is_weapon()) then
        local weapon_data = weap:get_weapon_data()
        local item = weapon_data.console_name:gsub("^weapon_", ""):gsub("^item_", "")
        local contained = contains(filesystem.weapon_icons, item)

        if (contained) then
            return filesystem.weapon_icons[contained][1]
        else
            local file_text = filesystem.read_file("materials/panorama/images/icons/equipment/" .. item .. ".svg") -- Engine Read File

            if (file_text) then
                local img = render.load_image_buffer(file_text)

                if (img) then
                    table.insert(filesystem.weapon_icons, {img, item})
                    return img
                end
            end
        end
    end
    
    return
end

--[[
    Misc Functions
--]]

function math.clamp(value, min, max)
    if (max) then if (value > max) then value = max end end
    if (min) then if (value < min) then value = min end end

    return value
end

--[[
    ESP Functions
--]]

local esp = {} esp.__index = esp
esp.table = {
    screen_size = render.get_screen_size(),
    usage = { 0, 0, 0, 0 },
    fonts = {
        render.create_font("Segoe UI", 13, 100, e_font_flags.ANTIALIAS),
        render.create_font("Segoe UI", 10, 400, e_font_flags.ANTIALIAS),
        render.create_font("Impact", 13, 100, e_font_flags.ANTIALIAS),
        render.create_font("Impact", 10, 400, e_font_flags.ANTIALIAS),
        render.create_font("Verdana", 13, 100, e_font_flags.ANTIALIAS),
        render.create_font("Verdana", 10, 400, e_font_flags.ANTIALIAS),
    },
    controls = {
        general = {
            toggle = menu.add_checkbox("General", "Master Toggle", true),
            font = menu.add_selection("General", "Select Font", { "Segoe UI", "Impact", "Verdana" }),
            hide_health = menu.add_checkbox("General", "Hide Full Health", true),
        },
        esp = {
            name = menu.add_selection("ESP", "Name", {"None", "Left", "Right", "Top", "Bottom"}),
            health = menu.add_selection("ESP", "Health", {"None", "Left", "Right", "Top", "Bottom"}),
            weapon = menu.add_selection("ESP", "Weapon", {"None", "Left", "Right", "Top", "Bottom"}),
            ammo = menu.add_selection("ESP", "Ammo", {"None", "Left", "Right", "Top", "Bottom"}),
        }
    }
}

esp.table.controls.colors = {
    general = esp.table.controls.general.toggle:add_color_picker("Color"),
    name = esp.table.controls.esp.name:add_color_picker("Color"),
    health_1 = esp.table.controls.esp.health:add_color_picker("Color"),
    health_2 = esp.table.controls.esp.health:add_color_picker("Color"),
    weapon = esp.table.controls.esp.weapon:add_color_picker("Color"),
    ammo_1 = esp.table.controls.esp.ammo:add_color_picker("Color"),
    ammo_2 = esp.table.controls.esp.ammo:add_color_picker("Color"),
}

function esp.add_text(ctx, control, text, color)
    if (control:get() ~= 1 and ctx.bbox_start.x > 0 and ctx.bbox_start.y > 0 and 
    ctx.bbox_size.x + ctx.bbox_start.x < esp.table.screen_size.x and ctx.bbox_size.y + ctx.bbox_start.y < esp.table.screen_size.y) then
        local text_size, side_usage = render.get_text_size(esp.table.fonts[esp.table.controls.general.font:get() * 2 - 1], text), 0

        if (control:get() == 2 or control:get() == 3) then
            local pos = vec2_t(0, ctx.bbox_start.y)

            if (control:get() == 2) then
                pos.x = ctx.bbox_start.x - 4 - esp.table.usage[control:get() - 1] - text_size.x
            else
                pos.x = ctx.bbox_start.x + ctx.bbox_size.x + 4 + esp.table.usage[control:get() - 1]
            end

            render.text(esp.table.fonts[esp.table.controls.general.font:get() * 2 - 1], text, pos, color)
            side_usage = side_usage + 2 + text_size.x
        else
            local pos = vec2_t(ctx.bbox_start.x + ctx.bbox_size.x / 2 - text_size.x / 2, 0)

            if (control:get() == 4) then
                pos.y = ctx.bbox_start.y - 4 - esp.table.usage[control:get() - 1] - text_size.y
            else
                pos.y = ctx.bbox_start.y + ctx.bbox_size.y + 4 + esp.table.usage[control:get() - 1]
            end

            render.text(esp.table.fonts[esp.table.controls.general.font:get() * 2 - 1], text, pos, color)
            side_usage = side_usage + 2 + text_size.y
        end

        esp.table.usage[control:get() - 1] = esp.table.usage[control:get() - 1] + side_usage
    end
end

function esp.add_bar(ctx, control, min, max, value, color, color_2, show_value)
    if (control:get() ~= 1 and ctx.bbox_start.x > 0 and ctx.bbox_start.y > 0 and 
        ctx.bbox_size.x + ctx.bbox_start.x < esp.table.screen_size.x and ctx.bbox_size.y + ctx.bbox_start.y < esp.table.screen_size.y) then
        value = math.clamp(value, min, max)
        local side_usage, text_size = 0, vec2_t(0, 0)
        local percent = math.abs((value - max) / max)

        if (show_value) then
            text_size = render.get_text_size(esp.table.fonts[esp.table.controls.general.font:get() * 2], tostring(value))
        end

        if (color_2) then
            local function get_number(num_1, num_2, percent)
                local value = math.clamp(math.floor(num_2 + (num_1 - num_2) * percent), 0, 255)

                if (value ~= value) then
                    return 0
                else
                    return value
                end
            end

            color = color_t(get_number(color.r, color_2.r, percent),
                            get_number(color.g, color_2.g, percent),
                            get_number(color.b, color_2.b, percent),
                            get_number(color.a, color_2.a, percent))
        end

        if (control:get() == 2 or control:get() == 3) then
            local pos = vec2_t(0, ctx.bbox_start.y)

            if (control:get() == 2) then
                pos.x = ctx.bbox_start.x - 8 - esp.table.usage[control:get() - 1]
            else
                pos.x = ctx.bbox_start.x + ctx.bbox_size.x + 8 + esp.table.usage[control:get() - 1]
                print(esp.table.usage[control:get() - 1])
            end

            render.rect_filled(pos, vec2_t(4, ctx.bbox_size.y), esp.table.controls.colors.general:get())
            render.rect_filled(vec2_t(pos.x + 1, pos.y + 1), vec2_t(2, ctx.bbox_size.y - (ctx.bbox_size.y - 2) * percent), color)

            if (show_value) then
                if (control:get() == 2) then
                    pos.x = pos.x - 2 - text_size.x
                else
                    pos.x = pos.x + 6
                end

                render.text(esp.table.fonts[esp.table.controls.general.font:get() * 2], tostring(value), pos, color_t(255, 255, 255))
                side_usage = side_usage + 2 + text_size.x
            end
        else
            local pos = vec2_t(ctx.bbox_start.x, 0)

            if (control:get() == 4) then
                pos.y = ctx.bbox_start.y - 8 - esp.table.usage[control:get() - 1]
            else
                pos.y = ctx.bbox_start.y + ctx.bbox_size.y + 8 + esp.table.usage[control:get() - 1]
            end

            render.rect_filled(pos, vec2_t(ctx.bbox_size.x, 4), esp.table.controls.colors.general:get())
            render.rect_filled(vec2_t(pos.x + 1, pos.y + 1), vec2_t(ctx.bbox_size.x - (ctx.bbox_size.x - 2) * percent, 2), color)

            if (show_value) then
                pos.x = ctx.bbox_start.x + ctx.bbox_size.x / 2 - text_size.x / 2

                if (control:get() == 4) then
                    pos.y = pos.y - 2 - text_size.y
                else
                    pos.y = pos.y + 2
                end

                render.text(esp.table.fonts[esp.table.controls.general.font:get() * 2], tostring(value), pos, color_t(255, 255, 255))
                side_usage = side_usage + 2 + text_size.y
            end
        end

        side_usage = side_usage + 8

        esp.table.usage[control:get() - 1] = esp.table.usage[control:get() - 1] + side_usage
    end
end

function esp.add_weapon(ctx, control, weap, color)
    if (control:get() ~= 1 and ctx.bbox_start.x > 0 and ctx.bbox_start.y > 0 and 
    ctx.bbox_size.x + ctx.bbox_start.x < esp.table.screen_size.x and ctx.bbox_size.y + ctx.bbox_start.y < esp.table.screen_size.y) then
        local weapon_icon = filesystem.load_icon(weap)
        local weapon_percent = math.abs((16 - weapon_icon.size.y) / weapon_icon.size.y)
        local weapon_size = vec2_t(weapon_icon.size.x * weapon_percent, weapon_icon.size.y * weapon_percent)
        local side_usage = 0

        if (control:get() == 2 or control:get() == 3) then
            local pos = vec2_t(0, ctx.bbox_start.y)

            if (control:get() == 2) then
                pos.x = ctx.bbox_start.x - 4 - weapon_size.x - esp.table.usage[control:get() - 1]
            else
                pos.x = ctx.bbox_start.x + ctx.bbox_size.x + 8 + esp.table.usage[control:get() - 1]
            end

            render.texture(weapon_icon.id, pos, weapon_size, color)
            side_usage = side_usage + weapon_size.x + 4
        else
            local pos = vec2_t(ctx.bbox_start.x + ctx.bbox_size.x / 2 - weapon_size.x / 2, 0)

            if (control:get() == 4) then
                pos.y = ctx.bbox_start.y - 4 - esp.table.usage[control:get() - 1] - weapon_size.y
            else
                pos.y = ctx.bbox_start.y + ctx.bbox_size.y + esp.table.usage[control:get() - 1] + 4
            end

            render.texture(weapon_icon.id, pos, weapon_size, color)
            side_usage = side_usage + weapon_size.y + 4
        end

        esp.table.usage[control:get() - 1] = esp.table.usage[control:get() - 1] + side_usage
        print(esp.table.usage[control:get() - 1])
    end
end

--[[
    Callbacks
--]]

callbacks.add(e_callbacks.PAINT, function()
    esp.table.screen_size = render.get_screen_size()
end)

callbacks.add(e_callbacks.PLAYER_ESP, function(ctx)
    esp.add_bar(ctx, esp.table.controls.esp.health, 0, 100, ctx.player:get_prop("m_iHealth"), esp.table.controls.colors.health_1:get(), esp.table.controls.colors.health_2:get(), not (esp.table.controls.general.hide_health:get() and ctx.player:get_prop("m_iHealth") == 100))
    esp.add_text(ctx, esp.table.controls.esp.name, ctx.player:get_name(), esp.table.controls.colors.name:get())

    local local_weapon = ctx.player:get_active_weapon()

    if (local_weapon and not ctx.dormant) then
        if (local_weapon:get_prop("m_iClip1") > 0) then
            esp.add_bar(ctx, esp.table.controls.esp.ammo, 0, local_weapon:get_weapon_data().max_clip, local_weapon:get_prop("m_iClip1"), esp.table.controls.colors.ammo_1:get(), esp.table.controls.colors.ammo_2:get())
        end

        esp.add_weapon(ctx, esp.table.controls.esp.weapon, local_weapon, esp.table.controls.colors.weapon:get())
    end

    esp.table.usage = { 0, 0, 0, 0 } -- Reset usage for the next player
end)