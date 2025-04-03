local Get = menu.find
local AddCheckbox = menu.add_checkbox
local AddSlider = menu.add_slider
local AddCombo = menu.add_selection

local JitterTypes = {"None", "Static", "Center", "Random", "Random v2", "Breaker"}
local DesyncSides = {"None", "Left", "Right", "Jitter", "Freestand", "Reversed freestand", "Sway", "Random", "Breaker"}
local FakelagTypes = {"Static", "Adaptive", "Random", "Break LC"}

local bebraui = menu.add_selection("movelean", "lean", {"OFF", "Small", "Medium", "High", "Extreme"})
callbacks.add(e_callbacks.ANTIAIM, function(ctx)
    local lp = entity_list.get_local_player()
    if not lp or not lp:is_alive() then
        return
    end
	local bebracheck = lp:get_prop("m_vecVelocity[1]") ~= 0	
	if bebraui:get(1) and bebracheck then
        ctx:set_render_animlayer(e_animlayers.LEAN, 0.35)
	end
	if bebraui:get(2) and bebracheck then
        ctx:set_render_animlayer(e_animlayers.LEAN, 0.5)
	end
	if bebraui:get(3) and bebracheck then
        ctx:set_render_animlayer(e_animlayers.LEAN, 0.75)
	end
	if bebraui:get(4) and bebracheck then
        ctx:set_render_animlayer(e_animlayers.LEAN, 1)
	end
end)

ffi.cdef[[
    typedef bool(__thiscall* console_is_visible)(void*);
]]
local engine_client = ffi.cast(ffi.typeof("void***"), memory.create_interface("engine.dll", "VEngineClient014"))
local console_is_visible = ffi.cast("console_is_visible", engine_client[0][11])

local enabled = menu.add_checkbox("console", "enable custom console color")
local recolor_console = enabled:add_color_picker("console colour")

local console_materials = { "vgui_white", "vgui/hud/800corner1", "vgui/hud/800corner2", "vgui/hud/800corner3", "vgui/hud/800corner4" }
local found_materials = {}

materials.for_each(function(mat)
    for material = 1, #console_materials do
        if ( string.match( mat:get_name( ), console_materials[material] )) then
            found_materials[material] = mat
        end
    end
end)

local function on_paint()
    if not engine.is_app_active() then 
        return 
    end

    local console_color = recolor_console:get()
    for material = 1, #found_materials do
        mat = found_materials[material]

        if enabled:get() and console_is_visible(engine_client) then
            mat:color_modulate(console_color.r/255, console_color.g/255, console_color.b/255)
            mat:alpha_modulate(console_color.a/255)
        else
            mat:color_modulate(1, 1, 1)
            mat:alpha_modulate(1)
        end
    end
end

---@diagnostic disable: undefined-global
local ui = {}
local callback = {}
local esp = {}

function menu.add_callback(control, fn)
    for i = 1, #callback do
        if (callback[i].control == control) then
            callback[i].fn = fn
            return
        end
    end

    local value, type = 0, 0
    local status = pcall(function() value = control:get() end)
    if (not status) then 
        type = 1 status = pcall(function() value = control:get_items() end)
    end
    if (not status) then type = 2 end

    if (type == 1) then
        local val = { items = control:get_items(), table = {} }

        for i = 1, #val.items do
            table.insert(val.table, control:get(i))
        end

        value = val.table
    end

    table.insert(callback, { control = control, fn = fn, value = value, type = type })
end

callbacks.add(e_callbacks.PAINT, function()
    for i = 1, #callback do
        if (callback[i].type ~= 1 and callback[i].type ~= 2 and callback[i].control:get() ~= callback[i].value) then
            callback[i].value = callback[i].control:get()
            callback[i].fn()
        elseif (callback[i].type == 1) then
            local val = { items = callback[i].control:get_items(), table = {} }

            for f = 1, #val.items do
                table.insert(val.table, callback[i].control:get(f))
            end

            for f = 1, #val.table do
                if (val.table[f] ~= callback[i].value[f]) then
                    callback[i].value = val.table
                    callback[i].fn()
                end
            end
        end
    end
end)

local elect_svg = render.load_image_buffer("<svg id=\"svg\" version=\"1.1\" width=\"608\" height=\"689\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" ><g id=\"svgg\"><path id=\"path0\" d=\"M185.803 18.945 C 184.779 19.092,182.028 23.306,174.851 35.722 C 169.580 44.841,157.064 66.513,147.038 83.882 C 109.237 149.365,100.864 163.863,93.085 177.303 C 88.686 184.901,78.772 202.072,71.053 215.461 C 63.333 228.849,53.959 245.069,50.219 251.505 C 46.480 257.941,43.421 263.491,43.421 263.837 C 43.421 264.234,69.566 264.530,114.025 264.635 L 184.628 264.803 181.217 278.618 C 179.342 286.217,174.952 304.128,171.463 318.421 C 167.974 332.714,160.115 364.836,153.999 389.803 C 147.882 414.770,142.934 435.254,143.002 435.324 C 143.127 435.452,148.286 428.934,199.343 364.145 C 215.026 344.243,230.900 324.112,234.619 319.408 C 238.337 314.704,254.449 294.276,270.423 274.013 C 286.397 253.750,303.090 232.582,307.519 226.974 C 340.870 184.745,355.263 166.399,355.263 166.117 C 355.263 165.937,323.554 165.789,284.798 165.789 C 223.368 165.789,214.380 165.667,214.701 164.831 C 215.039 163.949,222.249 151.366,243.554 114.474 C 280.604 50.317,298.192 19.768,298.267 19.444 C 298.355 19.064,188.388 18.576,185.803 18.945 \" stroke=\"none\" fill=\"#fff200\" fill-rule=\"evenodd\"></path></g></svg>")

local fonts = {
    pixel = render.create_font("Small fonts", 8, 350, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE),
    verdana = render.create_font("Verdana", 12, 0, e_font_flags.DROPSHADOW, e_font_flags.ANTIALIAS),
    verdana_flag = render.create_font("Verdana", 11, 0, e_font_flags.DROPSHADOW, e_font_flags.ANTIALIAS),
    weapon_icons_font = render.create_font("Counter-Strike", 20, 400, e_font_flags.DROPSHADOW, e_font_flags.ANTIALIAS)
}

ui.names = menu.add_checkbox('Visuals', 'Name', false)
ui.names_color = ui.names:add_color_picker('names color', color_t(255, 255, 255, 255))
ui.box = menu.add_checkbox('Visuals', 'Boundung box', false)
ui.box_color = ui.box:add_color_picker('box color', color_t(230, 230, 230, 230))
ui.healthbar = menu.add_selection('Visuals', 'Health bar', {'Disabled', 'Default', 'Custom', 'Gradient'})
ui.heathbar_color = ui.healthbar:add_color_picker('health color', color_t(255, 255, 255, 255))
ui.heathbar_color1 = ui.healthbar:add_color_picker('health color1', color_t(239, 165, 135, 255))
ui.heathbar_color2 = ui.healthbar:add_color_picker('health color2', color_t(76, 127, 182, 255))
ui.ammo_bar = menu.add_checkbox('Visuals', 'Ammo', false)
ui.ammo_color = ui.ammo_bar:add_color_picker('ammo color', color_t(80, 140, 200, 255))
ui.flags = menu.add_multi_selection('Visuals', 'Flags', {'Weapon name', 'Weapon icon', 'Money', 'Armor', 'Exploit', 'Fake', 'Blind', 'Zoom', 'C4', 'FD', 'Pin', 'Lethal', 'Zeus warning', 'Distance'})
ui.waep_ico_color = menu.add_text('Visuals', 'Weapon icon color'):add_color_picker('weapon color', color_t(255, 255, 255, 255))
ui.dpi_scale = menu.add_selection('Visuals', 'DPI scale', {'100%', '125%', '150%', '175%', '200%'})


local function reinit_fonts(dpi, dpin)
    fonts = {
        pixel = render.create_font("Small fonts", math.floor(8 * dpi), 350, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE),
        verdana = render.create_font("Verdana", math.floor(12 * dpin), 0, e_font_flags.DROPSHADOW, e_font_flags.ANTIALIAS),
        verdana_flag = render.create_font("Verdana", math.floor(11 * dpin), 0, e_font_flags.DROPSHADOW, e_font_flags.ANTIALIAS),
        weapon_icons_font = render.create_font("Counter-Strike", math.floor(20 * dpi), 400, e_font_flags.DROPSHADOW, e_font_flags.ANTIALIAS)
    }
end

function dpi_scale()
    if ui.dpi_scale:get() == 1 then
        esp.size = 1
        esp.size1 = 0.99
        esp.size2 = 1
        esp.dpi_size = 0
        reinit_fonts(esp.size, 1)
    elseif ui.dpi_scale:get() == 2 then
        esp.size = 1.2
        esp.size1 = 0.85
        esp.size2 = 1.4
        esp.dpi_size = 1
        reinit_fonts(esp.size, 1.1)
    elseif ui.dpi_scale:get() == 3 then
        esp.size = 1.4
        esp.size1 = 0.86
        esp.size2 = 1.5
        esp.dpi_size = 2
        reinit_fonts(esp.size, 1.2)
    elseif ui.dpi_scale:get() == 4 then
        esp.size = 1.5
        esp.size1 = 0.6
        esp.size2 = 1.8
        esp.dpi_size = 5
        reinit_fonts(esp.size, 1.5)
    elseif ui.dpi_scale:get() == 5 then
        esp.size = 1.5
        esp.size1 = 0.6
        esp.size2 = 1.9
        esp.dpi_size = 5
        reinit_fonts(esp.size, 1.59)
    end
end

esp.size = 1
esp.size1 = 1
esp.size2 = 1

menu.add_callback(ui.dpi_scale, function()
    dpi_scale()
end)
dpi_scale()

function length_sqr(vec)
    return vec.x * vec.x + vec.y * vec.y + vec.z * vec.z
end

local function get_player_weapons(idx)
	local list = {}

    for i = 0, 64 do
        local cwpn = idx:get_prop("m_hMyWeapons", i)

		if cwpn ~= nil and entity_list.get_entity(cwpn) ~= nil and entity_list.get_entity(cwpn):is_weapon() then
			table.insert(list, entity_list.get_entity(cwpn))
		end
	end

	return list
end

local sv_gravity = cvars.sv_gravity
local sv_jump_impulse = cvars.sv_jump_impulse
local g_net_data = {}
local g_sim_ticks = {}
local g_esp_data = {}

local function copy_vec(v) return vec3_t(v.x, v.y, v.z) end
local function length_sqr(x, y, z)
    return x * x + y * y + z * z
end

local extrapolate = function(ent, ticks)
    local tickinterval = global_vars.interval_per_tick()

    local sv_gravity = sv_gravity:get_float() * tickinterval
    local sv_jump_impulse = sv_jump_impulse:get_float() * tickinterval

    local p_origin, prev_origin = ent:get_render_origin(), ent:get_render_origin()

    local velocity = ent:get_prop("m_vecVelocity")
    local gravity = velocity.z > 0 and -sv_gravity or sv_jump_impulse

    for i=1, ticks do
        prev_origin = p_origin
        p_origin.x = p_origin.x + (velocity.x * tickinterval)
        p_origin.y = p_origin.y + (velocity.y * tickinterval)
        p_origin.z = p_origin.z + (velocity.z+gravity) * tickinterval

        local fraction = trace.line(prev_origin, p_origin, ent, 0x1).fraction

        if fraction <= 0.99 then
            return prev_origin
        end
    end

    return p_origin
end

callbacks.add(e_callbacks.NET_UPDATE, function()
    local local_player = entity_list.get_local_player()
    if not local_player then return end
    if not engine.is_in_game() or not engine.is_connected() then return end

    local players = entity_list.get_players(true)
    for _, player in pairs(players) do
        local idx = player:get_index()
        if player:is_dormant() or not player:is_alive() then
            g_net_data[idx] = nil
            g_sim_ticks[idx] = nil
            g_esp_data[idx] = nil
        else
            local prev_tick = g_sim_ticks[idx]
            local simulation_time = client.time_to_ticks(player:get_prop("m_flSimulationTime"))
            local origin = copy_vec(player:get_render_origin())

            if prev_tick ~= nil then
                local delta = simulation_time - prev_tick.tick

                if delta < 0 or delta > 0 and delta <= 64 then
                    local teleport_distance = length_sqr(prev_tick.origin.x - origin.x, prev_tick.origin.y - origin.y, prev_tick.origin.z - origin.z)
                    local extrapolated = extrapolate(player, delta - 1)

                    if delta < 0 then
                        g_esp_data[idx] = 1
                    end

                    g_net_data[idx] = {
                        tick = delta-1,

                        player = player,
                        delta = delta,
                        origin = origin,
                        extrapolated = extrapolated,

                        lagcomp = teleport_distance > 4096,
                        tickbase = delta < 3
                    }
                end
            end

            if g_esp_data[idx] == nil then
                g_esp_data[idx] = 0
            end

            g_sim_ticks[idx] = {
                tick = simulation_time,
                origin = origin
            }
        end
    end
end)

local add_element = function(name, c_table, text) name[#name+1] = {r = c_table[1], g = c_table[2], b = c_table[3], a = c_table[4], text = text} end
local function round(b, c) local d = 10 ^ (c or 0) return math.floor(b * d + 0.5) / d end
local function round_to_fifth(num) num = round(num, 0) num = num / 5 num = round(num, 0) num = num * 5 return num end
local function is_fake_ducking(player) local DuckSpeed = player:get_prop("m_flDuckSpeed"); local DuckAmount = player:get_prop("m_flDuckAmount"); local Flags = bit.band(player:get_prop('m_fFlags'), bit.lshift(1,0)) ~= 0 if DuckSpeed == 8 and DuckAmount > 0 and DuckAmount < 0.9 and Flags then return true; else return false; end end
local function get_distance_in_feet(a_x, a_y, a_z, b_x, b_y, b_z)
    return math.ceil(math.sqrt(math.pow(a_x - b_x, 2) + math.pow(a_y - b_y, 2) + math.pow(a_z - b_z, 2)) * 0.0254 / 0.3048)
end

local dist_to = function(pos1, pos2)
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    local dz = pos1.z - pos2.z

    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local tables = {}
local player_data = {}
tables.index_weapon_name = { [1] = {"desert eagle", 1}, [2] = {"dual berrettas", 2}, [3] = {"five-seven", 3}, [4] = {"glock-18", 4}, [7] = {"ak-47", 7}, [8] = {"aug", 8}, [9] = {"awp",9}, [10] = {"famas",10}, [11] = {"g3sg1",11}, [13] = {"galil ar",13}, [14] = {"m249",14}, [16] = {"m4a4",16}, [17] = {"mac-10",17}, [19] = {"p90",18}, [23] = {"mp5-sd",23}, [24] = {"ump-45",24}, [25] = {"xm1014",25}, [26] = {"pp-bizon",26}, [27] = {"mag-7",27}, [28] = {"negev",28}, [29] = {"sawed-off",29}, [30] = {"tec-9",30}, [31] = {"zeus x27",31}, [32] = {"p2000",32}, [33] = {"mp7",33}, [34] = {"mp9",34}, [35] = {"nova",35}, [36] = {"p250",36}, [38] = {"scar-20",38}, [39] = {"sg 556",39}, [40] = {"ssg 08",40}, [42] = {"knife",42}, [43] = {"flashbang",43}, [44] = {"high explosive grenade",44}, [45] = {"smoke grenade",45}, [46] = {"molotov",46}, [47] = {"decoy",47}, [48] = {"incendiary grenade",48}, [49] = {"c4",49}, [57] = {"healthshot",57}, [59] = {"knife",59}, [60] = {"m4a1-s",60}, [61] = {"usp-s",61}, [63] = {"cz75-auto",63}, [64] = {"r8 revolver",64}, [500] = {"bayonet",500}, [503] = {"classic knife",503}, [505] = {"flip knife",505}, [506] = {"gut knife",506}, [507] = {"karambit",507}, [508] = {"m9 bayonet",508}, [509] = {"huntsman knife",509}, [512] = {"falchion knife",512}, [514] = {"bowie knife",514}, [515] = {"butterfly knife",515}, [516] = {"shadow daggers",516}, [517] = {"paracord knife",517}, [518] = {"survival knife",518}, [519] = {"ursus knife",519}, [520] = {"navaja knife",520}, [521] = {"nomad knife",521}, [522] = {"stiletto knife",522}, [523] = {"talon knife",523}, [525] = {"skeleton knife",525} }

local function table_contains(tbl, val)
	for i=1,#tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end

local function table_remove_item(tbl, item)
	for i=#tbl, 1, -1 do
		if tbl[i] == item then
			table.remove(tbl, i)
		end
	end
end

local function on_player_disconnect(e)
    if e.name ~= 'player_disconnect' then return end
	local player = entity_list.get_player_from_userid(e.userid)
	if player == nil then return end
	player_data[player:get_index()] = nil
end

local function on_player_death(e)
    if e.name ~= 'player_death' then return end
	local player = entity_list.get_player_from_userid(e.userid)
	if player == nil then return end
	if player_data[player:get_index()] ~= nil and player:is_dormant() then
		player_data[player:get_index()] = nil
	end
end

local function on_player_spawn(e)
    if e.name ~= 'player_spawn' then return end
	local player = entity_list.get_player_from_userid(e.userid)
    if player == nil then return end
	if player_data[player:get_index()] == nil then
		player_data[player:get_index()] = {
			weapons = {}
		}
	elseif player_data[player:get_index()].weapons ~= nil then
		table_remove_item(player_data[player:get_index()].weapons, 'weapon_c4')
	end
end

local function on_item_remove(e)
    if e.name ~= 'item_remove' then return end
	local player = entity_list.get_player_from_userid(e.userid)
	if player == nil then return end
	local weapon = e.defindex
    if weapon == nil or tables.index_weapon_name[weapon] == nil then return end
    weapon = tables.index_weapon_name[weapon][1]
	if player_data[player:get_index()] ~= nil and player:is_dormant() and weapon then
		if weapon ~= "item_kevlar" and weapon ~= "item_assaultsuit" then
			table_remove_item(player_data[player:get_index()].weapons, weapon)
		end
	end
end

local function on_item_pickup(e)
    if e.name ~= 'item_pickup' then return end
	local player = entity_list.get_player_from_userid(e.userid)
	if player == nil then return end
	local weapon = e.defindex
    if weapon == nil or tables.index_weapon_name[weapon] == nil then return end
    weapon = tables.index_weapon_name[weapon][1]
	if player_data[player:get_index()] ~= nil and player:is_dormant() then
		if not table_contains(player_data[player:get_index()].weapons, weapon) then
			table.insert(player_data[player:get_index()].weapons, weapon)
		end
	end
end

local function on_item_equip(e)
    if e.name ~= 'item_equip' then return end
	local player = entity_list.get_player_from_userid(e.userid)
	if player == nil then return end
	local weapon = e.defindex
    local weapon_id = e.defindex
    if weapon == nil or tables.index_weapon_name[weapon] == nil or weapon_id == nil or tables.index_weapon_name[weapon_id] == nil then return end
    weapon = tables.index_weapon_name[weapon][1]

	if player_data[player:get_index()] ~= nil and player:is_dormant() then
		player_data[player:get_index()].active_weapon = weapon
        player_data[player:get_index()].active_weapon_id = weapon_id
	end
end

tables.get_weapon_index = function(ent)
    local m_iItemDefinitionIndex = bit.band(ent:get_prop("m_iItemDefinitionIndex"), 0xFFFF)
    if m_iItemDefinitionIndex ~= nil then
        local weapon_item_index = m_iItemDefinitionIndex
        return weapon_item_index
    end
end

tables.get_name_for_weapon_index = function(ent)
    return tables.index_weapon_name[tables.get_weapon_index(ent)]
end

local enemy_hp = 100
local round_start = false
local resetter = function(e)
    if e.name ~= 'round_start' then return end
	round_start = true
	enemy_hp = 100
    g_net_data = {}
end

local function esp_draw(ctx)
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    local weapon_local = local_player:get_active_weapon()
    local player_origin = render.world_to_screen(ctx.render_origin)

    if (not player_origin or player_origin.x < 0 or player_origin.x > render.get_screen_size().x or player_origin.y < 0 or player_origin.y > render.get_screen_size().y) then return end
    local x1, y1, x2, y2, a = ctx.bbox_start.x, ctx.bbox_start.y, ctx.bbox_size.x, ctx.bbox_size.y, ctx.alpha_modifier
    local armor = ctx.player:get_prop('m_ArmorValue')
    if ui.names:get() then
        local enemy_name = string.len(ctx.player:get_name()) > 12 and string.sub(ctx.player:get_name(), 0, 12) .. "..." or ctx.player:get_name()
        local textsize = render.get_text_size(fonts.verdana, enemy_name)
        render.text(fonts.verdana, enemy_name, vec2_t(x1 + x2 / 2-textsize.x/2, y1 - 13 - esp.dpi_size), ctx.player:is_dormant() and color_t(255, 255, 255, math.floor(a*255)) or color_t(ui.names_color:get().r, ui.names_color:get().g, ui.names_color:get().b, math.floor(a*ui.names_color:get().a)))
    end
    if ui.box:get() then
        render.rect(vec2_t(x1, y1-1), vec2_t(x2+1, y2+2), color_t(21, 21, 21, math.floor(0.5*a*255)))
        render.rect(vec2_t(x1+1, y1), vec2_t(x2-1, y2), ctx.player:is_dormant() and color_t(255, 255, 255, math.floor(a*255)) or color_t(ui.box_color:get().r, ui.box_color:get().g, ui.box_color:get().b, math.floor(a*ui.box_color:get().a)))
        render.rect(vec2_t(x1+2, y1+1), vec2_t(x2-3, y2-2), color_t(21, 21, 21, math.floor(0.5*a*255)))
    end

	if round_start and ctx.player:get_prop('m_iHealth') ~= 100 then
		enemy_hp = 100
		round_start = false
	else
		enemy_hp = ctx.player:get_prop('m_iHealth')
	end

    if ui.healthbar:get() ~= 1 then
        local color = {0, 0, 0}
        --134, 156, 68
        if enemy_hp >= 75 then
            color[0] = 120; color[1] = 225; color[2] = 80;
        elseif enemy_hp >= 50 then
            color[0] = 134; color[1] = 156; color[2] = 68;
        elseif enemy_hp >= 35 then
            color[0] = 188; color[1] = 86; color[2] = 69;
        else
            color[0] = 215; color[1] = 50; color[2] = 69;
        end
        local bar_height = math.min(100, enemy_hp) * y2 / 100
	    local offset = y2 - bar_height
        render.rect_filled(vec2_t(x1-6, y1-1), vec2_t(4, y2+2), color_t(0, 0, 0, math.floor(a*255/2)))
        render.rect(vec2_t(x1-6, y1-1), vec2_t(4, y2+2), color_t(0, 0, 0, math.floor(a*255/2)))
        if ui.healthbar:get() == 2 then
            render.rect_filled(vec2_t(x1-5, y1+offset), vec2_t(2, y2-(enemy_hp == 100 and offset or offset-1)), ctx.player:is_dormant() and color_t(255, 255, 255, math.floor(a*255)) or color_t(color[0], color[1], color[2], math.floor(a*255)))
        elseif ui.healthbar:get() == 3 then
            render.rect_filled(vec2_t(x1-5, y1+offset), vec2_t(2, y2-(enemy_hp == 100 and offset or offset-1)), ctx.player:is_dormant() and color_t(255, 255, 255, math.floor(a*255)) or color_t(ui.heathbar_color:get().r, ui.heathbar_color:get().g, ui.heathbar_color:get().b, math.floor(a*ui.heathbar_color:get().a)))
        elseif ui.healthbar:get() == 4 then
            render.rect_fade(vec2_t(x1-5, y1+offset), vec2_t(2, y2-(enemy_hp == 100 and offset or offset-1)), ctx.player:is_dormant() and color_t(255, 255, 255, math.floor(a*255)) or color_t(ui.heathbar_color1:get().r, ui.heathbar_color1:get().g, ui.heathbar_color1:get().b, math.floor(a*ui.heathbar_color1:get().a)), ctx.player:is_dormant() and color_t(255, 255, 255, math.floor(a*255)) or color_t(ui.heathbar_color2:get().r, ui.heathbar_color2:get().g, ui.heathbar_color2:get().b, math.floor(a*ui.heathbar_color2:get().a)))
        end
        if enemy_hp < 93 or (local_player:is_alive() and (weapon_local ~= nil and (weapon_local:get_weapon_data().type == e_weapon_types.PISTOL or weapon_local:get_weapon_data().type == e_weapon_types.GRENADE or weapon_local:get_weapon_data().type == e_weapon_types.KNIFE)) and armor == 0 and dist_to(local_player:get_render_origin(), ctx.player:get_render_origin()) < 684) then
            local textsize = render.get_text_size(ui.dpi_scale:get() >= 2 and fonts.verdana_flag or fonts.pixel, tostring(enemy_hp))
            render.text(ui.dpi_scale:get() >= 2 and fonts.verdana_flag or fonts.pixel, tostring(enemy_hp), vec2_t(x1-(ui.dpi_scale:get() >= 2 and (ui.dpi_scale:get() >= 4 and 6 or 8) or 5)-textsize.x/2, y1+offset-3*esp.size2), color_t(255, 255, 255, math.floor(a*250)))
        end
    end

    local y__ = 0

    --ammo bar
    local weapon = ctx.player:get_active_weapon()

    if ui.ammo_bar:get() and weapon then
        local clip = weapon:get_prop('m_iClip1')
        local max_clip = weapon:get_weapon_data().max_clip
        local ammo_percentage = math.min(1, max_clip == 0  and 1 or clip/max_clip)
        if max_clip ~= 0 then
            render.rect_filled(vec2_t(x1, y1 + y2 + 2+y__), vec2_t(x2 + 1, 4+y__), color_t(0, 0, 0, math.floor(a*255/2)))

            render.rect_filled(vec2_t(x1+1, y1 + y2 + 3+y__), vec2_t(x2*ammo_percentage-1, 2+y__), ctx.player:is_dormant() and color_t(255, 255, 255, math.floor(a*255)) or color_t(ui.ammo_color:get().r, ui.ammo_color:get().g, ui.ammo_color:get().b, math.floor(a*ui.ammo_color:get().a)))

            if clip <= 3 and clip > 0 then
                render.text(ui.dpi_scale:get() >= 2 and fonts.verdana_flag or fonts.pixel, tostring(clip), vec2_t(x1+1+y2*ammo_percentage - 1, y1 + y2 + 1+y__), ctx.player:is_dormant() and color_t(255, 255, 255, math.floor(a*255)) or color_t(255, 255, 255, 230))
            end
            y__ = y__ + 5/esp.size2
        end
    end
    if ui.flags:get(17) then
        y__ = y__ + 2
        local dist = round_to_fifth(get_distance_in_feet(local_player:get_render_origin().x, local_player:get_render_origin().y, local_player:get_render_origin().z, ctx.player:get_render_origin().x, ctx.player:get_render_origin().y, ctx.player:get_render_origin().z)) .. "FT"
        local textsize = render.get_text_size(ui.dpi_scale:get() >= 2 and fonts.verdana_flag or fonts.pixel, dist)

        render.text(ui.dpi_scale:get() >= 2 and fonts.verdana_flag or fonts.pixel, dist, vec2_t(x1 + x2 / 2-textsize.x/2, y1+y2+y__), ctx.player:is_dormant() and color_t(255, 255, 255, math.floor(a*255)) or color_t(255, 255, 255, 230))
        y__ = y__ + 7*esp.size2
    end

	local check = (player_data[ctx.player:get_index()] ~= nil and player_data[ctx.player:get_index()].active_weapon ~= nil and ctx.player:is_dormant())
    local wpn = check and player_data[ctx.player:get_index()].active_weapon or weapon

    if ui.flags:get(1) and wpn ~= nil then
        y__ = y__ + 2
		local weapon_name = check and player_data[ctx.player:get_index()].active_weapon or tables.get_name_for_weapon_index(weapon)[1]
        if weapon_name == nil then return end

        local textsize = render.get_text_size(ui.dpi_scale:get() >= 2 and fonts.verdana_flag or fonts.pixel, weapon_name:upper())
        render.text(ui.dpi_scale:get() >= 2 and fonts.verdana_flag or fonts.pixel, weapon_name:upper(), vec2_t(x1 + x2 / 2-textsize.x/2, y1+y2+y__), ctx.player:is_dormant() and color_t(255, 255, 255, math.floor(a*255)) or color_t(255, 255, 255, 230))
        y__ = y__ + 7*esp.size2
    end

	if ui.flags:get(2) and wpn ~= nil then
        y__ = y__ + 11*esp.size1

        render.weapon_icon(check and player_data[ctx.player:get_index()].active_weapon_id or bit.band(weapon:get_prop("m_iItemDefinitionIndex"), 0xFFFF), vec2_t(x1 + x2 / 2+1, y1+y2+y__+1+esp.dpi_size), color_t(0, 0, 0, math.floor(ui.waep_ico_color:get().a*0.5*a)), true, 0.42)
        render.weapon_icon(check and player_data[ctx.player:get_index()].active_weapon_id or bit.band(weapon:get_prop("m_iItemDefinitionIndex"), 0xFFFF), vec2_t(x1 + x2 / 2, y1+y2+y__+esp.dpi_size), ctx.player:is_dormant() and color_t(255, 255, 255, math.floor(a*255)) or color_t(ui.waep_ico_color:get().r, ui.waep_ico_color:get().g, ui.waep_ico_color:get().b, math.floor(ui.waep_ico_color:get().a*a)), true, 0.42*esp.size)
        y__ = y__ + 8
    end

    local x_, y_ = x1 + x2 + 3, y1 - 12
    local m_iAccount = ctx.player:get_prop('m_iAccount')
    local m_bHasHelmet = ctx.player:get_prop('m_bHasHelmet')
    local enemy_pitch = ctx.player:get_prop("m_angEyeAngles[0]")
    local is_blind = ctx.player:get_prop('m_flFlashDuration')
    local scoped = ctx.player:get_prop('m_bIsScoped')
    local c4 = false
    local has_taser = 0

	if check then
		for i1 = 1, #player_data[ctx.player:get_index()].weapons do
			local weaps = player_data[ctx.player:get_index()].weapons[i1]
			if weaps ~= nil and has_taser == 0 and weaps == 'zeus x27' then
				has_taser = 1
			end
		end
	else
		if get_player_weapons(ctx.player) ~= nil then
			for i2, v in ipairs(get_player_weapons(ctx.player)) do
				if v ~= nil and bit.band(v:get_prop("m_iItemDefinitionIndex"), 0xFFFF) == 49 then
					c4 = true
				end
				if v ~= nil and has_taser == 0 and bit.band(v:get_prop("m_iItemDefinitionIndex"), 0xFFFF) == 31 then
					has_taser = 1
				end
			end
		end
	end
	if weapon ~= nil then
    	pin = weapon:get_prop("m_bPinPulled")
	end
    local is_lethal = (function()
        if weapon_local ~= nil and local_player:is_alive() and bit.band(weapon_local:get_prop("m_iItemDefinitionIndex"), 0xFFFF) == 31 then
            local dist = get_distance_in_feet(local_player:get_render_origin().x, local_player:get_render_origin().y, local_player:get_render_origin().z, ctx.player:get_render_origin().x, ctx.player:get_render_origin().y, ctx.player:get_render_origin().z)
            if ctx.player:get_prop('m_iHealth') <= 80 and dist >= 12 then
                return true
            elseif ctx.player:get_prop('m_iHealth') <= 100 and dist < 14 then
                return true
            end
        elseif local_player:is_alive() and weapon_local ~= nil and bit.band(weapon_local:get_prop("m_iItemDefinitionIndex"), 0xFFFF) ~= 31 and weapon_local:get_weapon_data().damage >= ctx.player:get_prop('m_iHealth') then
            return true
        end
        return false
    end)()
    local flags = {}
    local m_flags = {
        {
            text = ('$%s'):format(m_iAccount),
            color = {105, 161, 22, 200},
            bool = ui.flags:get(3)
        },
        {
            text = m_bHasHelmet ~= 0 and 'HK' or 'K',
            color = {255, 255, 255, 200},
            bool = ui.flags:get(4) and armor > 0
        },
        {
            text = 'X',
            color = {255, 255, 255, 200},
            bool = ui.flags:get(5) and g_net_data[ctx.player:get_index()] ~= nil and g_net_data[ctx.player:get_index()].tickbase
        },
        {
            text = 'FAKE',
            color = {255, 255, 255, 200},
            bool = ui.flags:get(6) and enemy_pitch >= 85 and not ctx.player:is_dormant()
        },
        {
            text = 'BLIND',
            color = {60, 180, 225, 200},
            bool = ui.flags:get(7) and is_blind > 0
        },
        {
            text = 'ZOOM',
            color = {60, 180, 225, 200},
            bool = ui.flags:get(8) and scoped ~= 0
        },
        {
            text = 'C4',
            color = {255, 0, 0, 200},
            bool = ui.flags:get(9) and c4
        },
        {
            text = 'FD',
            color = {255, 255, 255, 200},
            bool = ui.flags:get(10) and is_fake_ducking(ctx.player)
        },
        {
            text = 'PIN',
            color = {240, 25, 50, 200},
            bool = ui.flags:get(11) and weapon ~= nil and pin
        },
        {
            text = 'LETHAL',
            color = {255, 0, 0, 200},
            bool = ui.flags:get(12) and is_lethal
        }
    }

    for index, value in pairs(m_flags) do
        if value.bool then
            add_element(flags, value.color, value.text)
        end
    end

    for i, v in pairs(flags) do
        y_ = y_ + 10
        render.text(ui.dpi_scale:get() >= 2 and fonts.verdana_flag or fonts.pixel, v.text, vec2_t(x_, y_), ctx.player:is_dormant() and color_t(255, 255, 255, math.floor(a*255)) or color_t(v.r, v.g, v.b, v.a))
        --renderer.text(x_, y_, ctx.player:is_dormant() and 255 or v.r, ctx.player:is_dormant() and 255 or v.g, ctx.player:is_dormant() and 255 or v.b, ctx.player:is_dormant() and esp_alpha*255 or v.a, ui.dpi_scale:Get() >= 1 and fonts.verdana_flag or fonts.pixel, v.text)
    end

    if ui.flags:get(13) then
        if elect_svg ~= nil and wpn ~= nil then
			local activewpn = check and player_data[ctx.player:get_index()].active_weapon_id or bit.band(weapon:get_prop("m_iItemDefinitionIndex"), 0xFFFF)
            if activewpn == 31 then
				has_taser = 2
			end

            if has_taser > 0 then
                local g, b = 255, 0

                if has_taser == 2 then
                    g, b = 0, 0
                end
                render.texture(elect_svg.id, vec2_t(x1 - 24, y1), vec2_t(25, 25), color_t(255, g, b, math.floor(a*255)))
            end
        end
    end
end

callbacks.add(e_callbacks.PLAYER_ESP, esp_draw)

callbacks.add(e_callbacks.EVENT, function(e)
    on_player_disconnect(e)
    on_player_death(e)
    on_player_spawn(e)
    on_item_remove(e)
    on_item_pickup(e)
    on_item_equip(e)
    resetter(e)
end)

local font=render.create_font("Verdana.ttf", 14,400,e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local api = require("primordial/Extended API.493")

local function on_paint()
    if engine.is_in_game()==false then return end
    local h, m, s = client.get_local_time()
    local timeW = string.format("%02d:%02d:%02d", h, m, s)
    local st, mi, se = api:cs_session_time()
    local playtime = "Playtime: "..string.format("%02d:%02d:%02d", st, mi, se)
    local MapN = engine.get_level_name_short()
    local screen_size = render.get_screen_size( )
    local accent_color_text, accent_color_color = unpack(menu.find("misc", "main", "config", "accent color")) -- accent_color_color()
    local cheatN1 = "Prim"
    local cheatN2 = "ordial.dev"
    local fps = math.floor(1 / globals.frame_time()).." fps"
    local ping = math.floor(1000 * engine.get_latency(e_latency_flows.OUTGOING) + engine.get_latency(e_latency_flows.INCOMING))
    local spacer = " | "
    local primsize = render.get_text_size(font, cheatN1)
    local mordialsize = render.get_text_size(font, cheatN2)
    local local_player = entity_list.get_local_player()
    local local_name = local_player:get_name()
    local hi, lo = api:get_velocity(local_player)
    local velocity = "Speed: "..string.format("%0d", hi, lo)

    local steamID3, steamID64 = local_player:get_steamids()


    local player_index = entity_list.get_local_player():get_index()
    local kills = player_resource.get_prop("m_iKills", player_index)
    local deaths = player_resource.get_prop("m_iDeaths", player_index)
    local assists = player_resource.get_prop("m_iAssists", player_index)
    local total = player_resource.get_prop("m_iTotalCashSpent", player_index)
    local round = player_resource.get_prop("m_iCashSpentThisRound", player_index)
    local earned = player_resource.get_prop("m_iMatchStats_CashEarned_Total", player_index)
    local crosshair = player_resource.get_prop("m_szCrosshairCodes", player_index)

    local tickrate = client.get_tickrate()
    local tabIn_Out = engine.is_app_active()
    local status = ""
    if tabIn_Out==true then
        status = "Tabbed in"
    elseif tabIn_Out==false then
        status = "Tabbed out"
    else
        status = "Error"
    end
    local HP = ""
    local weapon = ""
    if engine.is_in_game()==true then
        if engine.is_connected==false then
            HP = "Not Ingame"
        elseif local_player:get_prop("m_iHealth") >0 then
            HP = "Health: "..local_player:get_prop("m_iHealth")
            weapon = "Weapon: "..local_player:get_active_weapon():get_name()
        else
            HP = "Dead"
            weapon = "None"
        end
    end

    local shoot = ""
    if client.can_fire()==true then
        shoot = "Can shoot"
    else
        shoot = "Can't shoot"
    end

    local text= cheatN1..cheatN2..spacer..user.name..spacer..local_name..spacer..fps..spacer..HP..spacer..weapon..spacer..shoot..spacer..velocity..spacer.."Kills: "..kills.." / Deaths: "..deaths.." / Assists: "..assists..spacer.."Cash: Spend This round($"..round..") Total($"..total..") / Earned($"..earned..")"..spacer.."Crosshair: "..crosshair..spacer.."SteamID64: "..steamID64..spacer..status..spacer..playtime..spacer..MapN..spacer..tickrate.." tick"..spacer..ping.." ms".."00:00:00"

    local player=entity_list.get_local_player
    if player==nil and engine.is_in_game()==false  then return end
    if engine.is_in_game()==true then
    local text_size=render.get_text_size(font, text)
    --outer blackbox
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 47, 11 ), vec2_t( text_size.x + 38, text_size.y + 24 ), color_t(18, 18, 18))
    --outer outline
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 46, 12 ), vec2_t( text_size.x + 36, text_size.y + 22 ), color_t(66, 64, 62))
    --outerbox 
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 43, 14 ), vec2_t( text_size.x + 30, text_size.y + 17 ), color_t(44, 44, 44))
    --inner outline
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 39, 18 ), vec2_t( text_size.x + 22, text_size.y + 9 ), color_t(66, 64, 62))
    --blackbox
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 37, 20 ), vec2_t( text_size.x + 18, text_size.y + 5 ), color_t(18, 18, 18))
    --rgb line
    --render.line_multicolor(x-112,14, x-textx-25, 15, render.color("#9329cc"), render.color("#2986cc"))
    --render.line_multicolor(x-15,14, x-textx-1 * -85, 15, render.color("#aacc29"), render.color("#9329cc"))

    render.text(font, cheatN1, vec2_t( screen_size.x - 31  - text_size.x, 23 ), color_t(255,255, 255, 255))
    render.text(font, cheatN2, vec2_t( screen_size.x - 31  - text_size.x + primsize.x , 23 ), accent_color_color())
    render.text(font, spacer..user.name..spacer..local_name..spacer..fps..spacer..HP..spacer..weapon..spacer..shoot..spacer..velocity..spacer.."Kills: "..kills.." / Deaths: "..deaths.." / Assists: "..assists..spacer.."Cash: Spend This round($"..round..") Total($"..total..") / Earned($"..earned..")"..spacer.."Crosshair: "..crosshair..spacer.."SteamID64: "..steamID64..spacer..status..spacer..playtime..spacer..MapN..spacer..tickrate.." tick"..spacer..ping.." ms"..spacer..timeW, vec2_t( screen_size.x - 31  - text_size.x + primsize.x + mordialsize.x, 23 ), color_t(255,255, 255, 255))
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)

callbacks.add(e_callbacks.PAINT, on_paint)

local Lua = {
	OverrideAntiaim = AddCheckbox("Ati-Aim", "Override antiaim"),
	OverrideFakelag = AddCheckbox("Fake Lag modify", "Override fakelag"),

	Antiaim = {
		Preset = AddCombo("Antiaim", "Preset", {"None", "Nervous jitter", "Low jitter", "N-Way", "Custom"}),

		NWay = {
			Type = AddCombo("Antiaim [N-Way]", "Type", {"3-Way", "4-Way", "5-Way"}),

			Timings = AddCombo("Antiaim [N-Way]", "Time", {"Static", "Randomize"}),

			YawFirstSide = AddSlider("Antiaim [N-Way]", "Yaw Side - [1]", -58, 58),
			YawSecondSide = AddSlider("Antiaim [N-Way]", "Yaw Side - [2]", -58, 58),
			YawThirdSide = AddSlider("Antiaim [N-Way]", "Yaw Side - [3]", -58, 58),
			YawFourthSide = AddSlider("Antiaim [N-Way]", "Yaw Side - [4]", -58, 58),
			YawFivthSide = AddSlider("Antiaim [N-Way]", "Yaw Side [5]", -58, 58),

			DesyncOverride = AddCheckbox("Antiaim [N-Way]", "Override desync"),
			DesyncFirstSide = AddSlider("Antiaim [N-Way]", "Desync Side - [1]", -90, 90),
			DesyncSecondSide = AddSlider("Antiaim [N-Way]", "Desync Side - [2]", -90, 90),
			DesyncThirdSide = AddSlider("Antiaim [N-Way]", "Desync Side - [3]", -90, 90),
			DesyncFourthSide = AddSlider("Antiaim [N-Way]", "Desync Side - [4]", -90, 90),
			DesyncFivthSide = AddSlider("Antiaim [N-Way]", "Desync Side - [5]", -90, 90)
		},

		Custom = {
			Mode = AddCombo("Antiaim [Custom]", "Type", {"Standing", "Walking", "Running", "In-air", "Crouching", "Crouch in air", "Deffensive"}),

			Standing = {
				Yaw = AddSlider("Antiaim [Custom]", "[S] - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Antiaim [Custom]", "[S] - Randomize yaw"),

				OverrideJitter = AddCheckbox("Antiaim [Custom]", "[S] - Override jitter"),
				JitterType = AddCombo("Antiaim [Custom]", "[S] - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Antiaim [Custom]", "[S] - Amount", -58, 58),

				OverrideSpin = AddCheckbox("Antiaim [Custom]", "[S] - Override spin"),
				SpinType = AddCombo("Antiaim [Custom]", "[S] - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Antiaim [Custom]", "[S] - Amount", 0, 360),
				SpinSpeed = AddSlider("Antiaim [Custom]", "[S] - Speed", 0, 100),

				DesyncType = AddCombo("Antiaim [Custom]", "[S] - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Antiaim [Custom]", "[S] - Left amount", 0, 90),
				DesyncRight = AddSlider("Antiaim [Custom]", "[S] - Right amount", 0, 90),
			},

			Walking = {
				Yaw = AddSlider("Antiaim [Custom]", "[W] - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Antiaim [Custom]", "[W] - Randomize yaw"),

				OverrideJitter = AddCheckbox("Antiaim [Custom]", "[W] - Override jitter"),
				JitterType = AddCombo("Antiaim [Custom]", "[W] - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Antiaim [Custom]", "[W] - Amount", -58, 58),

				OverrideSpin = AddCheckbox("Antiaim [Custom]", "[W] - Override spin"),
				SpinType = AddCombo("Antiaim [Custom]", "[W] - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Antiaim [Custom]", "[W] - Amount", 0, 360),
				SpinSpeed = AddSlider("Antiaim [Custom]", "[W] - Speed", 0, 100),

				DesyncType = AddCombo("Antiaim [Custom]", "[W] - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Antiaim [Custom]", "[W] - Left amount", 0, 90),
				DesyncRight = AddSlider("Antiaim [Custom]", "[W] - Right amount", 0, 90),
			},

			Running = {
				Yaw = AddSlider("Antiaim [Custom]", "[R] - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Antiaim [Custom]", "[R] - Randomize yaw"),

				OverrideJitter = AddCheckbox("Antiaim [Custom]", "[R] - Override jitter"),
				JitterType = AddCombo("Antiaim [Custom]", "[R] - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Antiaim [Custom]", "[R] - Amount", -58, 58),

				OverrideSpin = AddCheckbox("Antiaim [Custom]", "[R] - Override spin"),
				SpinType = AddCombo("Antiaim [Custom]", "[R] - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Antiaim [Custom]", "[R] - Amount", 0, 360),
				SpinSpeed = AddSlider("Antiaim [Custom]", "[R] - Speed", 0, 100),

				DesyncType = AddCombo("Antiaim [Custom]", "[R] - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Antiaim [Custom]", "[R] - Left amount", 0, 90),
				DesyncRight = AddSlider("Antiaim [Custom]", "[R] - Right amount", 0, 90),
			},

			Air = {
				Yaw = AddSlider("Antiaim [Custom]", "[A] - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Antiaim [Custom]", "[A] - Randomize yaw"),

				OverrideJitter = AddCheckbox("Antiaim [Custom]", "[A] - Override jitter"),
				JitterType = AddCombo("Antiaim [Custom]", "[A] - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Antiaim [Custom]", "[A] - Amount", -58, 58),

				OverrideSpin = AddCheckbox("Antiaim [Custom]", "[A] - Override spin"),
				SpinType = AddCombo("Antiaim [Custom]", "[A] - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Antiaim [Custom]", "[A] - Amount", 0, 360),
				SpinSpeed = AddSlider("Antiaim [Custom]", "[A] - Speed", 0, 100),

				DesyncType = AddCombo("Antiaim [Custom]", "[A] - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Antiaim [Custom]", "[A] - Left amount", 0, 90),
				DesyncRight = AddSlider("Antiaim [Custom]", "[A] - Right amount", 0, 90),
			},

			Crouching = {
				Yaw = AddSlider("Antiaim [Custom]", "[C] - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Antiaim [Custom]", "[C] - Randomize yaw"),

				OverrideJitter = AddCheckbox("Antiaim [Custom]", "[C] - Override jitter"),
				JitterType = AddCombo("Antiaim [Custom]", "[C] - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Antiaim [Custom]", "[C] - Amount", -58, 58),

				OverrideSpin = AddCheckbox("Antiaim [Custom]", "[C] - Override spin"),
				SpinType = AddCombo("Antiaim [Custom]", "[C] - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Antiaim [Custom]", "[C] - Amount", 0, 360),
				SpinSpeed = AddSlider("Antiaim [Custom]", "[C] - Speed", 0, 100),

				DesyncType = AddCombo("Antiaim [Custom]", "[C] - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Antiaim [Custom]", "[C] - Left amount", 0, 90),
				DesyncRight = AddSlider("Antiaim [Custom]", "[C] - Right amount", 0, 90),
			},

			CrouchingInAir = {
				Yaw = AddSlider("Antiaim [Custom]", "[CA] - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Antiaim [Custom]", "[CA] - Randomize yaw"),

				OverrideJitter = AddCheckbox("Antiaim [Custom]", "[CA] - Override jitter"),
				JitterType = AddCombo("Antiaim [Custom]", "[CA] - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Antiaim [Custom]", "[CA] - Amount", -58, 58),

				OverrideSpin = AddCheckbox("Antiaim [Custom]", "[CA] - Override spin"),
				SpinType = AddCombo("Antiaim [Custom]", "[CA] - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Antiaim [Custom]", "[CA] - Amount", 0, 360),
				SpinSpeed = AddSlider("Antiaim [Custom]", "[CA] - Speed", 0, 100),

				DesyncType = AddCombo("Antiaim [Custom]", "[CA] - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Antiaim [Custom]", "[CA] - Left amount", 0, 90),
				DesyncRight = AddSlider("Antiaim [Custom]", "[CA] - Right amount", 0, 90),
			},

			Deffensive = {
				Sensivity = AddSlider("Antiaim [Custom]", "[D] - Deffensive sensivity", 0, 100),

				Pitch = AddCombo("Antiaim [Custom]", "[D] - Pitch", {"None", "Down", "Up", "Zero", "Jitter"}),
				Yaw = AddSlider("Antiaim [Custom]", "[D] - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Antiaim [Custom]", "[D] - Randomize yaw"),

				OverrideJitter = AddCheckbox("Antiaim [Custom]", "[D] - Override jitter"),
				JitterType = AddCombo("Antiaim [Custom]", "[D] - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Antiaim [Custom]", "[D] - Amount", -58, 58),

				OverrideSpin = AddCheckbox("Antiaim [Custom]", "[D] - Override spin"),
				SpinType = AddCombo("Antiaim [Custom]", "[D] - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Antiaim [Custom]", "[D] - Amount", 0, 360),
				SpinSpeed = AddSlider("Antiaim [Custom]", "[D] - Speed", 0, 100),

				DesyncType = AddCombo("Antiaim [Custom]", "[D] - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Antiaim [Custom]", "[D] - Left amount", 0, 90),
				DesyncRight = AddSlider("Antiaim [Custom]", "[D] - Right amount", 0, 90),
			}
		}
	},

	Fakelag = {
		MoveType = AddCombo("Fakelag [Custom]", "Move type", {"Standing", "Walking", "Running", "Air", "Crouching", "Crouch in air"}),

		Standing = {
			Amount = AddSlider("Fakelag [Custom]", "[S] - Amount", 0, 15),
			Mode = AddCombo("Fakelag [Custom]", "[S] - Mode", FakelagTypes),
		},

		Walking = {
			Amount = AddSlider("Fakelag [Custom]", "[W] - Amount", 0, 15),
			Mode = AddCombo("Fakelag [Custom]", "[W] - Mode", FakelagTypes),
		},

		Running = {
			Amount = AddSlider("Fakelag [Custom]", "[R] - Amount", 0, 15),
			Mode = AddCombo("Fakelag [Custom]", "[R] - Mode", FakelagTypes),
		},

		Air = {
			Amount = AddSlider("Fakelag [Custom]", "[A] - Amount", 0, 15),
			Mode = AddCombo("Fakelag [Custom]", "[A] - Mode", FakelagTypes),
		},

		Crouching = {
			Amount = AddSlider("Fakelag [Custom]", "[C] - Amount", 0, 15),
			Mode = AddCombo("Fakelag [Custom]", "[C] - Mode", FakelagTypes),
		},

		CrouchingInAir = {
			Amount = AddSlider("Fakelag [Custom]", "[AC] - Amount", 0, 15),
			Mode = AddCombo("Fakelag [Custom]", "[AC] - Mode", FakelagTypes),
		}
	}
}

local Ui = {

	Exploits = {
		Doubletap = Get("aimbot", "general", "exploits", "doubletap", "enable"),
		Hideshots = Get("aimbot", "general", "exploits", "hideshots", "enable")
	},

	Antiaim = {
		Enable = Get("antiaim", "main", "general", "enable"),
		Pitch = Get("antiaim", "main", "angles", "pitch"),
		Base = Get("antiaim", "main", "angles", "yaw base"),
		Yaw = Get("antiaim", "main", "angles", "yaw add"),

		OverrideSpin = Get("antiaim", "main", "angles", "rotate"),
		SpinAmount = Get("antiaim", "main", "angles", "rotate range"),
		SpinSpeed = Get("antiaim", "main", "angles", "rotate speed"),

		JitterType = Get("antiaim", "main", "angles", "jitter mode"),
		JitterMode = Get("antiaim", "main", "angles", "jitter type"),
		JitterAmount = Get("antiaim", "main", "angles", "jitter add"),

		DesyncSide = Get("antiaim", "main", "desync","side#stand"),
		DesyncLeft = Get("antiaim", "main", "desync","left amount#stand"),
		DesyncRight = Get("antiaim", "main", "desync","right amount#stand"),
	},

	Fakelag = {
		Amount = Get("antiaim", "main", "fakelag", "amount")
	}
}

function Clamp(x, min, max)
    if min > max then
        return math.min(math.max(x, max), min)
    else
        return math.min(math.max(x, min), max)
    end  
    
    return x
end

local function GetVelocity()
    local Entity = entity_list.get_local_player()

    local VelocityX = Entity:get_prop("m_vecVelocity[0]")
    local VelocityY = Entity:get_prop("m_vecVelocity[1]")
    local VelocityZ = Entity:get_prop("m_vecVelocity[2]")
  
    local Velocity = vec3_t(VelocityX, VelocityY, VelocityZ)

    if math.ceil(Velocity:length2d()) < 5 then
        return 0
    else 
        return math.ceil(Velocity:length2d()) 
    end
end

local Tickbase = {
	LastTickcount = global_vars.tick_count(),
	Ticks = 62,
	Difference = 0,
	Deffensive = false
}

local PreviousSimulationTime = 0
local DifferenceOfSimulation = 0
function SimulationDifference(entity)
	local CurrentSimulationTime = client.time_to_ticks(entity:get_prop("m_flSimulationTime"))
	local Difference = CurrentSimulationTime - (PreviousSimulationTime + (Lua.Antiaim.Custom.Deffensive.Sensivity:get() / 100))
	PreviousSimulationTime = CurrentSimulationTime
	DifferenceOfSimulation = Difference
	return DifferenceOfSimulation
end

function RefreshTickcount()
    Tickbase.LastTickcount = global_vars.tick_count()
end

local function AntiaimCondition()
	local LocalPlayer = entity_list.get_local_player()
	local AntiaimCondition = 0

	local Deffensive = false

    local TickBase = LocalPlayer:get_prop("m_nTickBase")
    Tickbase.Deffensive = math.abs(TickBase - Tickbase.Difference) >= 2.50
    Tickbase.Difference = math.max(TickBase, Tickbase.Difference or 0)
    if Tickbase.LastTickcount < global_vars.tick_count() - (Tickbase.Ticks / 2) + exploits.get_charge() then
		if (Tickbase.Deffensive or SimulationDifference(LocalPlayer) <= -1) and Tickbase.LastTickcount < global_vars.tick_count() and Ui.Exploits.Doubletap[2]:get() == true then
			Deffensive = true
			RefreshTickcount()
			Deffensive = false
		end

		Deffensive = true
    end

	if GetVelocity() == 0 and Deffensive then 
		AntiaimCondition = 1 
	end

	if GetVelocity() > 0 and LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and Deffensive then
		AntiaimCondition = 2
	end

	if GetVelocity() > 90 and LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and Deffensive then
        AntiaimCondition = 3
    end

    if not LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and Deffensive then
        AntiaimCondition = 4
    end

    if LocalPlayer:has_player_flag(e_player_flags.DUCKING) and LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and Deffensive then
        AntiaimCondition = 5
    end

	if not LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and LocalPlayer:has_player_flag(e_player_flags.DUCKING) and Deffensive then
		AntiaimCondition = 6
	end

	if Deffensive == false and not Ui.Exploits.Hideshots[2]:get() then
		AntiaimCondition = 7
	end

	return AntiaimCondition
end

function JitterSide()
    local JitterSide = 0
    local SwapTimer = 0
    SwapTimer = global_vars.cur_time() * 10000 % 1
    Clamp(SwapTimer, 0, 1)
    JitterSide = SwapTimer > 0.5 and 1 or -1

    return JitterSide
end

function SwapSide()
    local JitterSide = 0
    local SwapTimer = 0
    SwapTimer = math.ceil(global_vars.cur_time() * 36) % 2
    Clamp(SwapTimer, 0, 1)
    JitterSide = SwapTimer > 0.5 and 1 or -1
    return JitterSide
end

local Way = 0

local function CAntiaim()
	local Curtime = global_vars.cur_time()
	local LocalPlayer = entity_list.get_local_player()

	if Lua.Antiaim.NWay.Timings:get() == 1 then
		if JitterSide() == 1 then
			Way = Way + 1
		end
	else
		if math.ceil(Curtime * client.random_int(100, 128)) % 5 > 1 then
			Way = Way + 1
		end
	end

    if Lua.Antiaim.Preset:get() == 2 then
        Ui.Antiaim.OverrideSpin:set(false)
		Ui.Antiaim.JitterType:set(1)

        Ui.Antiaim.Yaw:set(math.ceil(Curtime * 128) % 20 * SwapSide())

		Ui.Antiaim.DesyncSide:set(SwapSide() == 1 and 2 or 3)
		Ui.Antiaim.DesyncLeft:set(75)
		Ui.Antiaim.DesyncRight:set(75)
    end

    if Lua.Antiaim.Preset:get() == 3 then
        Ui.Antiaim.OverrideSpin:set(false)
		Ui.Antiaim.JitterType:set(1)

        Ui.Antiaim.Yaw:set(15 + math.ceil(Curtime * client.random_int(120, 128)) % 25 * SwapSide())

		Ui.Antiaim.DesyncSide:set(3)
		Ui.Antiaim.DesyncLeft:set(75 - math.ceil(Curtime * 65) % 20)
		Ui.Antiaim.DesyncRight:set(75 - math.ceil(Curtime * 65) % 20)
    end

	if Lua.Antiaim.Preset:get() == 4 then
		Ui.Antiaim.OverrideSpin:set(false)
		Ui.Antiaim.JitterType:set(1)

		if Way == 1 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawFirstSide:get())
		elseif Way == 2 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawSecondSide:get())
		elseif Way == 3 and Lua.Antiaim.NWay.Type:get() > 0 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawThirdSide:get())
		elseif Way == 4 and Lua.Antiaim.NWay.Type:get() > 1 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawFourthSide:get())
		elseif Way == 5 and Lua.Antiaim.NWay.Type:get() > 2 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawFivthSide:get())
		else
			Way = 1
		end

		if Lua.Antiaim.NWay.DesyncOverride:get() then
			if Way == 1 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncFirstSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncFirstSide:get() > 0 and Lua.Antiaim.NWay.DesyncFirstSide:get() or Lua.Antiaim.NWay.DesyncFirstSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncFirstSide:get() > 0 and Lua.Antiaim.NWay.DesyncFirstSide:get() or Lua.Antiaim.NWay.DesyncFirstSide:get() * -1)
			elseif Way == 2 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncSecondSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncSecondSide:get() > 0 and Lua.Antiaim.NWay.DesyncSecondSide:get() or Lua.Antiaim.NWay.DesyncSecondSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncSecondSide:get() > 0 and Lua.Antiaim.NWay.DesyncSecondSide:get() or Lua.Antiaim.NWay.DesyncSecondSide:get() * -1)
			elseif Way == 3 and Lua.Antiaim.NWay.Type:get() > 0 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncThirdSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncThirdSide:get() > 0 and Lua.Antiaim.NWay.DesyncThirdSide:get() or Lua.Antiaim.NWay.DesyncThirdSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncThirdSide:get() > 0 and Lua.Antiaim.NWay.DesyncThirdSide:get() or Lua.Antiaim.NWay.DesyncThirdSide:get() * -1)
			elseif Way == 4 and Lua.Antiaim.NWay.Type:get() > 1 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncFourthSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncFourthSide:get() > 0 and Lua.Antiaim.NWay.DesyncFourthSide:get() or Lua.Antiaim.NWay.DesyncFourthSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncFourthSide:get() > 0 and Lua.Antiaim.NWay.DesyncFourthSide:get() or Lua.Antiaim.NWay.DesyncFourthSide:get() * -1)
			elseif Way == 5 and Lua.Antiaim.NWay.Type:get() > 2 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncFivthSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncFivthSide:get() > 0 and Lua.Antiaim.NWay.DesyncFivthSide:get() or Lua.Antiaim.NWay.DesyncFivthSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncFivthSide:get() > 0 and Lua.Antiaim.NWay.DesyncFivthSide:get() or Lua.Antiaim.NWay.DesyncFivthSide:get() * -1)
			else
				Way = 1
			end
		end
	end

	if Lua.Antiaim.Preset:get() == 5 then
		if AntiaimCondition() == 1 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Standing.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Standing.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Standing.Yaw:get(), -Lua.Antiaim.Custom.Standing.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Standing.Yaw:get(), Lua.Antiaim.Custom.Standing.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Standing.Yaw:get())
			end

			if Lua.Antiaim.Custom.Standing.OverrideJitter:get() then 
				if Lua.Antiaim.Custom.Standing.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Standing.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Standing.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Standing.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Standing.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Standing.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.OverrideSpin:set(Lua.Antiaim.Custom.Standing.OverrideSpin:get())

			if Lua.Antiaim.Custom.Standing.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Standing.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Standing.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Standing.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Standing.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Standing.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Standing.SpinSpeed:get())

			if Lua.Antiaim.Custom.Standing.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Standing.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Standing.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 2 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Walking.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Walking.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Walking.Yaw:get(), -Lua.Antiaim.Custom.Walking.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Walking.Yaw:get(), Lua.Antiaim.Custom.Walking.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Walking.Yaw:get())
			end

			if Lua.Antiaim.Custom.Walking.OverrideJitter:get() then 
				if Lua.Antiaim.Custom.Walking.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Walking.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Walking.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Walking.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Walking.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Walking.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.OverrideSpin:set(Lua.Antiaim.Custom.Walking.OverrideSpin:get())

			if Lua.Antiaim.Custom.Walking.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Walking.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Walking.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Walking.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Walking.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Walking.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Walking.SpinSpeed:get())

			if Lua.Antiaim.Custom.Walking.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Walking.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Walking.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 3 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Running.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Running.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Running.Yaw:get(), -Lua.Antiaim.Custom.Running.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Running.Yaw:get(), Lua.Antiaim.Custom.Running.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Running.Yaw:get())
			end

			if Lua.Antiaim.Custom.Running.OverrideJitter:get() then 
				if Lua.Antiaim.Custom.Running.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Running.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Running.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Running.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Running.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Running.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.OverrideSpin:set(Lua.Antiaim.Custom.Running.OverrideSpin:get())

			if Lua.Antiaim.Custom.Running.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Running.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Running.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Running.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Running.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Running.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Running.SpinSpeed:get())

			if Lua.Antiaim.Custom.Running.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Running.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Running.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 4 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Air.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Air.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Air.Yaw:get(), -Lua.Antiaim.Custom.Air.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Air.Yaw:get(), Lua.Antiaim.Custom.Air.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Air.Yaw:get())
			end

			if Lua.Antiaim.Custom.Air.OverrideJitter:get() then 
				if Lua.Antiaim.Custom.Air.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Air.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Air.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Air.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Air.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Air.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.OverrideSpin:set(Lua.Antiaim.Custom.Air.OverrideSpin:get())

			if Lua.Antiaim.Custom.Air.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Air.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Air.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Air.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Air.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Air.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Air.SpinSpeed:get())

			if Lua.Antiaim.Custom.Air.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Air.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Air.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 5 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Crouching.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Crouching.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Crouching.Yaw:get(), -Lua.Antiaim.Custom.Crouching.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Crouching.Yaw:get(), Lua.Antiaim.Custom.Crouching.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Crouching.Yaw:get())
			end

			if Lua.Antiaim.Custom.Crouching.OverrideJitter:get() then 
				if Lua.Antiaim.Custom.Crouching.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Crouching.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Crouching.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Crouching.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.OverrideSpin:set(Lua.Antiaim.Custom.Crouching.OverrideSpin:get())

			if Lua.Antiaim.Custom.Crouching.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Crouching.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Crouching.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Crouching.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Crouching.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Crouching.SpinSpeed:get())

			if Lua.Antiaim.Custom.Crouching.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 6 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.CrouchingInAir.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.CrouchingInAir.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.CrouchingInAir.Yaw:get(), -Lua.Antiaim.Custom.CrouchingInAir.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.CrouchingInAir.Yaw:get(), Lua.Antiaim.Custom.CrouchingInAir.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.CrouchingInAir.Yaw:get())
			end

			if Lua.Antiaim.Custom.CrouchingInAir.OverrideJitter:get() then 
				if Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get())
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get())
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get())
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.OverrideSpin:set(Lua.Antiaim.Custom.CrouchingInAir.OverrideSpin:get())

			if Lua.Antiaim.Custom.CrouchingInAir.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.CrouchingInAir.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.CrouchingInAir.SpinSpeed:get())

			if Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 7 then
			Ui.Antiaim.Pitch:set(Lua.Antiaim.Custom.Deffensive.Pitch:get())

			if Lua.Antiaim.Custom.Deffensive.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Deffensive.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Deffensive.Yaw:get(), -Lua.Antiaim.Custom.Deffensive.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Deffensive.Yaw:get(), Lua.Antiaim.Custom.Deffensive.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Deffensive.Yaw:get())
			end

			if Lua.Antiaim.Custom.Deffensive.OverrideJitter:get() then 
				if Lua.Antiaim.Custom.Deffensive.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Deffensive.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Deffensive.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Deffensive.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.OverrideSpin:set(Lua.Antiaim.Custom.Deffensive.OverrideSpin:get())

			if Lua.Antiaim.Custom.Deffensive.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Deffensive.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Deffensive.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Deffensive.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Deffensive.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Deffensive.SpinSpeed:get())

			if Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.DesyncRight:get()))
			end
		end
	end
end

local function CFakelag(antiaim)
	local Fluctate = 0
	local BreakLagcomp = 64.0 / (GetVelocity() * global_vars.interval_per_tick())

	if AntiaimCondition() == 1 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Standing.Amount:get()

		if Lua.Fakelag.Standing.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Standing.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Standing.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Standing.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Standing.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Standing.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Standing.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 2 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Walking.Amount:get()

		if Lua.Fakelag.Walking.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Walking.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Walking.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Walking.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Walking.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Walking.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Walking.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 3 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Running.Amount:get()

		if Lua.Fakelag.Running.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Running.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Running.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Running.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Running.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Running.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Running.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 4 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Air.Amount:get()

		if Lua.Fakelag.Air.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Air.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Air.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Air.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Air.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Air.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Air.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 5 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Crouching.Amount:get()

		if Lua.Fakelag.Crouching.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Crouching.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Crouching.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Crouching.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Crouching.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Crouching.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Crouching.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 6 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.CrouchingInAir.Amount:get()

		if Lua.Fakelag.CrouchingInAir.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.CrouchingInAir.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.CrouchingInAir.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.CrouchingInAir.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.CrouchingInAir.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.CrouchingInAir.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.CrouchingInAir.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	end
end	

local function UiModule()

	Lua.Antiaim.Preset:set_visible(false)

	Lua.Antiaim.NWay.Type:set_visible(false)

	Lua.Antiaim.NWay.Timings:set_visible(false)
	Lua.Antiaim.NWay.YawFirstSide:set_visible(false)
	Lua.Antiaim.NWay.YawSecondSide:set_visible(false)
	Lua.Antiaim.NWay.YawThirdSide:set_visible(false)
	Lua.Antiaim.NWay.YawFourthSide:set_visible(false)
	Lua.Antiaim.NWay.YawFivthSide:set_visible(false)
	Lua.Antiaim.NWay.DesyncOverride:set_visible(false)
	Lua.Antiaim.NWay.DesyncFirstSide:set_visible(false)
	Lua.Antiaim.NWay.DesyncSecondSide:set_visible(false)
	Lua.Antiaim.NWay.DesyncThirdSide:set_visible(false)
	Lua.Antiaim.NWay.DesyncFourthSide:set_visible(false)
	Lua.Antiaim.NWay.DesyncFivthSide:set_visible(false)

	Lua.Antiaim.Custom.Mode:set_visible(false)

	Lua.Antiaim.Custom.Standing.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Standing.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Standing.OverrideJitter:set_visible(false)
	Lua.Antiaim.Custom.Standing.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Standing.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Standing.OverrideSpin:set_visible(false)
	Lua.Antiaim.Custom.Standing.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Standing.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Standing.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Standing.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Standing.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Standing.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.Walking.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Walking.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Walking.OverrideJitter:set_visible(false)
	Lua.Antiaim.Custom.Walking.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Walking.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Walking.OverrideSpin:set_visible(false)
	Lua.Antiaim.Custom.Walking.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Walking.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Walking.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Walking.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Walking.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Walking.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.Running.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Running.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Running.OverrideJitter:set_visible(false)
	Lua.Antiaim.Custom.Running.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Running.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Running.OverrideSpin:set_visible(false)
	Lua.Antiaim.Custom.Running.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Running.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Running.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Running.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Running.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Running.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.Air.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Air.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Air.OverrideJitter:set_visible(false)
	Lua.Antiaim.Custom.Air.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Air.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Air.OverrideSpin:set_visible(false)
	Lua.Antiaim.Custom.Air.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Air.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Air.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Air.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Air.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Air.DesyncRight:set_visible(false)
	
	Lua.Antiaim.Custom.Crouching.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Crouching.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Crouching.OverrideJitter:set_visible(false)
	Lua.Antiaim.Custom.Crouching.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Crouching.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Crouching.OverrideSpin:set_visible(false)
	Lua.Antiaim.Custom.Crouching.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Crouching.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Crouching.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Crouching.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Crouching.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Crouching.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.CrouchingInAir.Yaw:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.OverrideJitter:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.JitterType:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.OverrideSpin:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.SpinType:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.Deffensive.Sensivity:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.Pitch:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.OverrideJitter:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.OverrideSpin:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.DesyncRight:set_visible(false)

	Lua.Fakelag.MoveType:set_visible(false)

	Lua.Fakelag.Standing.Amount:set_visible(false)
	Lua.Fakelag.Standing.Mode:set_visible(false)
	
	Lua.Fakelag.Walking.Amount:set_visible(false)
	Lua.Fakelag.Walking.Mode:set_visible(false)

	Lua.Fakelag.Running.Amount:set_visible(false)
	Lua.Fakelag.Running.Mode:set_visible(false)

	Lua.Fakelag.Air.Amount:set_visible(false)
	Lua.Fakelag.Air.Mode:set_visible(false)

	Lua.Fakelag.Crouching.Amount:set_visible(false)
	Lua.Fakelag.Crouching.Mode:set_visible(false)

	Lua.Fakelag.CrouchingInAir.Amount:set_visible(false)
	Lua.Fakelag.CrouchingInAir.Mode:set_visible(false)
	
	if Lua.OverrideAntiaim:get() then
		Lua.Antiaim.Preset:set_visible(true)

		if Lua.Antiaim.Preset:get() == 4 then
			Lua.Antiaim.NWay.Type:set_visible(true)

			Lua.Antiaim.NWay.Timings:set_visible(true)

			if Lua.Antiaim.NWay.Type:get() == 1 then
				Lua.Antiaim.NWay.YawFirstSide:set_visible(true)
				Lua.Antiaim.NWay.YawSecondSide:set_visible(true)
				Lua.Antiaim.NWay.YawThirdSide:set_visible(true)
				Lua.Antiaim.NWay.YawFourthSide:set_visible(false)
				Lua.Antiaim.NWay.YawFivthSide:set_visible(false)
			elseif Lua.Antiaim.NWay.Type:get() == 2 then
				Lua.Antiaim.NWay.YawFirstSide:set_visible(true)
				Lua.Antiaim.NWay.YawSecondSide:set_visible(true)
				Lua.Antiaim.NWay.YawThirdSide:set_visible(true)
				Lua.Antiaim.NWay.YawFourthSide:set_visible(true)
				Lua.Antiaim.NWay.YawFivthSide:set_visible(false)
			elseif Lua.Antiaim.NWay.Type:get() == 3 then
				Lua.Antiaim.NWay.YawFirstSide:set_visible(true)
				Lua.Antiaim.NWay.YawSecondSide:set_visible(true)
				Lua.Antiaim.NWay.YawThirdSide:set_visible(true)
				Lua.Antiaim.NWay.YawFourthSide:set_visible(true)
				Lua.Antiaim.NWay.YawFivthSide:set_visible(true)
			end

			Lua.Antiaim.NWay.DesyncOverride:set_visible(true)

			if Lua.Antiaim.NWay.DesyncOverride:get() then
				if Lua.Antiaim.NWay.Type:get() == 1 then
					Lua.Antiaim.NWay.DesyncFirstSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncSecondSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncThirdSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFourthSide:set_visible(false)
					Lua.Antiaim.NWay.DesyncFivthSide:set_visible(false)
				elseif Lua.Antiaim.NWay.Type:get() == 2 then
					Lua.Antiaim.NWay.DesyncFirstSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncSecondSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncThirdSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFourthSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFivthSide:set_visible(false)
				elseif Lua.Antiaim.NWay.Type:get() == 3 then
					Lua.Antiaim.NWay.DesyncFirstSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncSecondSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncThirdSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFourthSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFivthSide:set_visible(true)
				end
			else
				Lua.Antiaim.NWay.DesyncFirstSide:set_visible(false)
				Lua.Antiaim.NWay.DesyncSecondSide:set_visible(false)
				Lua.Antiaim.NWay.DesyncThirdSide:set_visible(false)
				Lua.Antiaim.NWay.DesyncFourthSide:set_visible(false)
				Lua.Antiaim.NWay.DesyncFivthSide:set_visible(false)
			end
		end

		if Lua.Antiaim.Preset:get() == 5 then
			Lua.Antiaim.Custom.Mode:set_visible(true)

			if Lua.Antiaim.Custom.Mode:get() == 1 then
				Lua.Antiaim.Custom.Standing.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Standing.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Standing.OverrideJitter:set_visible(true)
				Lua.Antiaim.Custom.Standing.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Standing.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Standing.OverrideSpin:set_visible(true)
				Lua.Antiaim.Custom.Standing.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Standing.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Standing.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Standing.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Standing.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Standing.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 2 then
				Lua.Antiaim.Custom.Walking.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Walking.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Walking.OverrideJitter:set_visible(true)
				Lua.Antiaim.Custom.Walking.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Walking.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Walking.OverrideSpin:set_visible(true)
				Lua.Antiaim.Custom.Walking.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Walking.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Walking.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Walking.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Walking.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Walking.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 3 then
				Lua.Antiaim.Custom.Running.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Running.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Running.OverrideJitter:set_visible(true)
				Lua.Antiaim.Custom.Running.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Running.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Running.OverrideSpin:set_visible(true)
				Lua.Antiaim.Custom.Running.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Running.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Running.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Running.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Running.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Running.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 4 then
				Lua.Antiaim.Custom.Air.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Air.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Air.OverrideJitter:set_visible(true)
				Lua.Antiaim.Custom.Air.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Air.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Air.OverrideSpin:set_visible(true)
				Lua.Antiaim.Custom.Air.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Air.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Air.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Air.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Air.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Air.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 5 then
				Lua.Antiaim.Custom.Crouching.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Crouching.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Crouching.OverrideJitter:set_visible(true)
				Lua.Antiaim.Custom.Crouching.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Crouching.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Crouching.OverrideSpin:set_visible(true)
				Lua.Antiaim.Custom.Crouching.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Crouching.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Crouching.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Crouching.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Crouching.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Crouching.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 6 then
				Lua.Antiaim.Custom.CrouchingInAir.Yaw:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.CrouchingInAir.OverrideJitter:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.JitterType:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.CrouchingInAir.OverrideSpin:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.SpinType:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.CrouchingInAir.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 7 then
				Lua.Antiaim.Custom.Deffensive.Sensivity:set_visible(true)

				Lua.Antiaim.Custom.Deffensive.Pitch:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Deffensive.OverrideJitter:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Deffensive.OverrideSpin:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Deffensive.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.DesyncRight:set_visible(true)
			end
		end
	end

	if Lua.OverrideFakelag:get() then
		Lua.Fakelag.MoveType:set_visible(true)

		if Lua.Fakelag.MoveType:get() == 1 then
			Lua.Fakelag.Standing.Amount:set_visible(true)
			Lua.Fakelag.Standing.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 2 then
			Lua.Fakelag.Walking.Amount:set_visible(true)
			Lua.Fakelag.Walking.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 3 then
			Lua.Fakelag.Running.Amount:set_visible(true)
			Lua.Fakelag.Running.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 4 then
			Lua.Fakelag.Air.Amount:set_visible(true)
			Lua.Fakelag.Air.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 5 then
			Lua.Fakelag.Crouching.Amount:set_visible(true)
			Lua.Fakelag.Crouching.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 6 then
			Lua.Fakelag.CrouchingInAir.Amount:set_visible(true)
			Lua.Fakelag.CrouchingInAir.Mode:set_visible(true)
		end
	end
end

function HookAntiaim(antiaim)
	if Lua.OverrideFakelag:get() and Ui.Exploits.Doubletap[2]:get() == false then
		CFakelag(antiaim)
	end
end

function HookRender()
	UiModule()

	if Lua.OverrideAntiaim:get() then
		if entity_list.get_local_player() ~= nil then
			if entity_list.get_local_player():get_prop("m_iHealth") > 0 then
				CAntiaim()
			end
		end
	end
end

callbacks.add(e_callbacks.ANTIAIM, HookAntiaim)
callbacks.add(e_callbacks.PAINT, HookRender)