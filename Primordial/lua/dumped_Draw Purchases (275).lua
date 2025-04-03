local screen_size = render.get_screen_size()
local enable = menu.add_checkbox("general", "enable draw purchases")
local name_color = enable:add_color_picker("names", color_t(255, 255, 255, 255), false)
local item_color = enable:add_color_picker("items", color_t(255, 255, 255, 255), false)
local pos_x = menu.add_slider("general", "x-pos", 0, screen_size.x)
local pos_y = menu.add_slider("general", "y-pos", 0, screen_size.y)
local extend_time = menu.add_slider("general", "extend display time", 0, 90, 1, 0, "s")
local style = menu.add_selection("general", "style", { "gs", "primordial" })
local cheat_color = menu.find("misc", "main", "config", "accent color")[2]

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

local bit_band = bit.band
local idx_to_console_name, weapon_types = {[1]="weapon_deagle",[2]="weapon_elite",[3]="weapon_fiveseven",[4]="weapon_glock",[7]="weapon_ak47",[8]="weapon_aug",[9]="weapon_awp",[10]="weapon_famas",[11]="weapon_g3sg1",[13]="weapon_galilar",[14]="weapon_m249",[16]="weapon_m4a1",[17]="weapon_mac10",[19]="weapon_p90",[23]="weapon_mp5sd",[24]="weapon_ump45",[25]="weapon_xm1014",[26]="weapon_bizon",[27]="weapon_mag7",[28]="weapon_negev",[29]="weapon_sawedoff",[30]="weapon_tec9",[31]="weapon_taser",[32]="weapon_hkp2000",[33]="weapon_mp7",[34]="weapon_mp9",[35]="weapon_nova",[36]="weapon_p250",[38]="weapon_scar20",[39]="weapon_sg556",[40]="weapon_ssg08",[41]="weapon_knifegg",[42]="weapon_knife",[43]="weapon_flashbang",[44]="weapon_hegrenade",[45]="weapon_smokegrenade",[46]="weapon_molotov",[47]="weapon_decoy",[48]="weapon_incgrenade",[49]="weapon_c4",[50]="item_kevlar",[51]="item_assaultsuit",[52]="item_heavyassaultsuit",[55]="item_defuser",[56]="item_cutters",[57]="weapon_healthshot",[59]="weapon_knife_t",[60]="weapon_m4a1_silencer",[61]="weapon_usp_silencer",[63]="weapon_cz75a",[64]="weapon_revolver",[68]="weapon_tagrenade",[69]="weapon_fists",[70]="weapon_breachcharge",[72]="weapon_tablet",[74]="weapon_melee",[75]="weapon_axe",[76]="weapon_hammer",[78]="weapon_spanner",[80]="weapon_knife_ghost",[81]="weapon_firebomb",[82]="weapon_diversion",[83]="weapon_frag_grenade",[84]="weapon_snowball",[500]="weapon_bayonet",[505]="weapon_knife_flip",[506]="weapon_knife_gut",[507]="weapon_knife_karambit",[508]="weapon_knife_m9_bayonet",[509]="weapon_knife_tactical",[512]="weapon_knife_falchion",[514]="weapon_knife_survival_bowie",[515]="weapon_knife_butterfly",[516]="weapon_knife_push",[519]="weapon_knife_ursus",[520]="weapon_knife_gypsy_jackknife",[522]="weapon_knife_stiletto",[523]="weapon_knife_widowmaker"}, {["secondary"]={1,2,3,4,30,32,36,61,63,64},["rifle"]={7,8,9,10,11,13,16,38,39,40,60},["heavy"]={14,25,27,28,29,35},["smg"]={17,19,23,24,26,33,34},["equipment"]={31,50,51,52,55,56},["melee"]={41,42,59,69,74,75,76,78,80,500,505,506,507,508,509,512,514,515,516,519,520,522,523},["grenade"]={43,44,45,46,47,48,68,81,82,83,84},["c4"]={49,70},["boost"]={57},["utility"]={72}}
local weapon_types_lookup, console_name_to_idx = setmetatable({}, {__index=function(tbl, idx) return type(idx) == "number" and rawget(tbl, bit_band(idx, 0xFFFF)) or nil end}), {}
for type, weapons in pairs(weapon_types) do
    for i=1, #weapons do
        weapon_types_lookup[weapons[i]], weapon_types_lookup[idx_to_console_name[weapons[i]]], console_name_to_idx[weapons[i]] = type, type, idx_to_console_name[weapons[i]]
    end
end

local font = render.get_default_font()
local container_x, container_y, last_height, last_width = 0,0,0,0

local function reset_position()
    container_x = screen_size.x-16-11
    container_y = screen_size.y/2.3
    pos_x:set(container_x)
    pos_y:set(container_y)
end

local reset_pos_button = menu.add_button("general", "reset position", reset_position)
local weapon_types_order = {"c4", "boost", "utility", "rifle", "heavy", "smg", "secondary", "melee", "equipment", "grenade"}

local type_opacities = {
    secondary=0.7,
    equipment=0.7,
    grenade=0.4,
    utility=0.4,
}

local function table_contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

local c = {10, 60, 40, 40, 40, 60, 20}
local color_header = color_t(41,41,41, 255)
local color_container = color_t(31, 31, 31, 255)
local color_black = color_t(0, 0, 0, 255)
local color_white = color_t(201, 201, 201, 255)
local round_amount = 4
local header_text = "purchases"
local header_text_size = render.get_text_size(font, header_text)

local function draw_container(x, y, w, h, header, a)

    if (style:get() == 1) then
        for i = 0,6,1 do
            render.rect_filled(vec2_t(x+i, y+i), vec2_t(w-(i*2), h-(i*2)), color_t(c[i+1], c[i+1], c[i+1], a))
        end

        if header then
            local x_inner, y_inner = x+7, y+7
            local w_inner = w-14

            render.rect_fade(vec2_t(x_inner, y_inner), vec2_t(math.floor(w_inner/2), 1), color_t(59, 175, 222, a), color_t(202, 70, 205, a), true)
            render.rect_fade(vec2_t(x_inner+math.floor(w_inner/2), y_inner), vec2_t(math.ceil(w_inner/2), 1), color_t(202, 70, 205, a), color_t(201, 227, 58, a), true)

            local a_lower = math.floor(a*0.2)
            render.rect_fade(vec2_t(x_inner, y_inner+1), vec2_t(math.floor(w_inner/2), 1), color_t(59, 175, 222, a_lower), color_t(202, 70, 205, a_lower), true)
            render.rect_fade(vec2_t(x_inner+math.floor(w_inner/2), y_inner+1), vec2_t(math.ceil(w_inner/2), 1), color_t(202, 70, 205, a_lower), color_t(201, 227, 58, a_lower), true)
        end
    else
        local color_cheat = cheat_color:get()
        color_cheat.a = a
        color_black.a = a
        color_white.a = a
        color_header.a = a
        color_container.a = a
        local height_add = 0
        if header then
            height_add = 19
        end

        render.rect_filled(vec2_t(x, y-height_add), vec2_t(w, h+height_add+1), color_container, round_amount)
        render.rect(vec2_t(x-1, y-height_add), vec2_t(w+1, h+height_add), color_black, round_amount)

        if (header) then
            render.rect_filled(vec2_t(x, y-height_add+1), vec2_t(w, height_add), color_header, round_amount)
            render.rect_filled(vec2_t(x, y), vec2_t(w, 1), color_cheat)

            render.text(font,
                    header_text,
                    vec2_t(x+math.floor((w-header_text_size.x)/2), y-math.floor(height_add)+math.floor(header_text_size.y/4)),
                    color_white)
        end
    end

end

filesystem.weapon_icons = {}

function filesystem.load_icon_for_text(text)
    local function contains(tbl, text)
        for i = 1, #tbl do
            if (tbl[i][2] == text) then return i end
        end

        return
    end

    local item = text:gsub("^weapon_", ""):gsub("^item_", "")
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

    return
end


local padding = 4
local line_height = 18
local dragging = false

local purchases = {}

local function handle_drag()
    if input.is_key_pressed(e_keys.MOUSE_LEFT) then
        local x = container_x
        local y = container_y
        local height = last_height

        if screen_size.x/2 < x then
            x = x - last_width
        end

        if style:get() == 2 then
            y = y - 19
            height = height + 19
        end

        if input.is_mouse_in_bounds(vec2_t(x, y), vec2_t(last_width, height)) then
            dragging = true
        end
    end

    if dragging and input.is_key_held(e_keys.MOUSE_LEFT) then
        local mouse_pos = input.get_mouse_pos()
        container_x = mouse_pos.x
        container_y = mouse_pos.y

        if container_x < 0 then
            container_x = 0
        end
        if container_x > screen_size.x then
            container_x = screen_size.x
        end

        if container_y < 0 then
            container_y = 0
        end
        if container_y > screen_size.y then
            container_y = screen_size.y
        end

        pos_x:set(container_x)
        pos_y:set(container_y)
    end

    if input.is_key_released(e_keys.MOUSE_LEFT) then
        dragging = false
    end
end

callbacks.add(e_callbacks.PAINT, function(e)
    if not enable:get() then
        return
    end

    if menu.is_open() then
        handle_drag()
    end

    local n_color = name_color:get()
    local i_color = item_color:get()
    local width_max = 90
    local names, width_name = {}, {}
    local i = 1

    for player, purchases_player in pairs(purchases) do
        local entity = entity_list.get_entity(player)
        if entity ~= nil then
            names[player] = entity:get_name() .. " bought "
            local width = render.get_text_size(font, names[player]).x
            width_name[player] = width

            for i=1, #purchases_player do
                if purchases_player[i] ~= "kevlar" or not table_contains(purchases_player, "assaultsuit") then
                    local icon = filesystem.load_icon_for_text(purchases_player[i])
                    if icon ~= nil then
                        local weapon_percent = math.abs((16 - icon.size.y) / icon.size.y)
                        local weapon_size = vec2_t(icon.size.x * weapon_percent, icon.size.y * weapon_percent)
                        width = width + weapon_size.x + padding
                    end
                end
            end
            width_max = math.max(width_max, width)
            i = i + 1
        end
    end

    if menu.is_open() and i == 1 then
        i = 2
    end

    if i == 1 then
        return
    end

    local a = 255
    local round_start_time = game_rules.get_prop("m_fRoundStartTime")
    local time_since_start = 0
    if global_vars.cur_time() ~= nil and round_start_time ~= nil then
        time_since_start = global_vars.cur_time()-round_start_time-extend_time:get()
    end

    if time_since_start > 5 and time_since_start <= 6 then
        a = math.floor(255 * (1-(time_since_start-5)/1))
    elseif time_since_start > 6 then
        a = 0
    end

    if menu.is_open() then
        a = 255
    end

    if a == 0 then
        return
    end

    local x = container_x
    local y = container_y
    if screen_size.x/2 < x then
        x = x - width_max
    end

    last_width = width_max+16
    last_height = i*line_height

    draw_container(x-4, y-4, last_width, last_height, true, a)
    x, y, i = x+5, y+8, 1

    for player, purchases_player in pairs(purchases) do
        if width_name[player]~= nil then
            local y_offset = (i-1)*line_height
            local max_icon_height = 0
            local x_offset = width_name[player]

            for i=1, #weapon_types_order do
                local type_current = weapon_types_order[i]
                for i=1, #purchases_player do
                    local weapon_type = weapon_types_lookup[purchases_player[i]]
                    if weapon_type == type_current then
                        if purchases_player[i] ~= "item_kevlar" or not table_contains(purchases_player, "item_assaultsuit") then
                            local icon = filesystem.load_icon_for_text(purchases_player[i])
                            if icon ~= nil then
                                local opacity_multiplier = type_opacities[weapon_type] or 1
                                local weapon_percent = math.abs((16 - icon.size.y) / icon.size.y)
                                local weapon_size = vec2_t(icon.size.x * weapon_percent, icon.size.y * weapon_percent)
                                render.texture(icon.id, vec2_t(x+x_offset, y+y_offset), weapon_size, color_t(i_color.r, i_color.g, i_color.b, math.floor(a * opacity_multiplier)))
                                x_offset = x_offset + weapon_size.x + padding
                                if max_icon_height < weapon_size.y then
                                    max_icon_height = weapon_size.y
                                end
                            end
                        end
                    end
                end
            end

            render.text(font, names[player], vec2_t(x, y+y_offset), color_t(n_color.r, n_color.g, n_color.b, a))
            i = i + 1
        end
    end
end)

local function purchase_event(event)
    local player = entity_list.get_player_from_userid(event.userid)
    if player == nil or not player:is_enemy() then
        return
    end

    local ent_index = player:get_index()
    if purchases[ent_index] == nil then
        purchases[ent_index] = {}
    end

    table.insert(purchases[ent_index], event.weapon)
end

local function player_spawn_event(event)
    local player = entity_list.get_player_from_userid(event.userid)
    if player == nil or not player:is_enemy() then
        return
    end

    local ent_index = player:get_index()
    if purchases[ent_index] ~= nil then
        purchases[ent_index] = {}
    end
end

local function reset()
    purchases = {}
end

callbacks.add(e_callbacks.EVENT, function(event)
    if event.name == "item_purchase" then
        purchase_event(event)
    end

    if event.name == "player_spawn" then
        player_spawn_event(event)
    end

    if event.name == "round_end" or event.name == "round_start" then
        reset()
    end
end)

local function init()
    pos_x:set_visible(false)
    pos_y:set_visible(false)

    if pos_x:get() == 0 and pos_y:get() == 0 then
        reset_position()
    else
        container_x = pos_x:get()
        container_y = pos_y:get()
    end
end

--delay the call so that the slider values are initialised
client.delay_call(init, 0.01)