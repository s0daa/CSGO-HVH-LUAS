local ui = {
    get = ui.get,
    set = ui.set,
    new_checkbox = ui.new_checkbox,
    new_combobox = ui.new_combobox,
    new_label = ui.new_label,
    new_button = ui.new_button,
    set_callback = ui.set_callback,
    set_visible = ui.set_visible,
    new_slider = ui.new_slider,
    new_color_picker = ui.new_color_picker,
    new_multiselect = ui.new_multiselect,
    reference = ui.reference,
    new_listbox = ui.new_listbox
}

local client = {
    exec = client.exec,
    screen_size = client.screen_size,
    set_cvar = client.set_cvar,
    set_event_callback = client.set_event_callback,
    latency = client.latency,
    get_cvar = client.get_cvar,
    eye_position = client.eye_position,
    userid_to_entindex = client.userid_to_entindex,
    tickcount = globals.tickcount,
    curtime = globals.curtime,
    world_to_screen = renderer.world_to_screen,
    line = renderer.line,
    gradient = renderer.gradient or function() client.log("renderer.gradient not available") end,
    rectangle = renderer.rectangle or function() client.log("renderer.rectangle not available") end,
    text = renderer.text or function() client.log("renderer.text not available") end,
    measure_text = renderer.measure_text or function() client.log("renderer.measure_text not available") end,
    absoluteframetime = globals.absoluteframetime,
    tickinterval = globals.tickinterval,
    current_threat = client.current_threat,
    camera_angles = client.camera_angles,
    create_interface = client.create_interface,
    find_signature = client.find_signature,
    unset_event_callback = client.unset_event_callback,
    log = client.log
}

local entity = {
    get_local_player = entity.get_local_player,
    get_prop = entity.get_prop,
    get_classname = entity.get_classname,
    get_player_name = entity.get_player_name,
    get_player_weapon = entity.get_player_weapon,
    get_esp_data = entity.get_esp_data,
    get_all = entity.get_all,
    set_prop = entity.set_prop,
    is_alive = entity.is_alive,
    is_enemy = entity.is_enemy,
    is_dormant = entity.is_dormant,
    get_bounding_box = entity.get_bounding_box
}

local math = {
    fmod = math.fmod,
    max = math.max,
    min = math.min,
    abs = math.abs,
    sqrt = math.sqrt,
    floor = math.floor,
    randomseed = math.randomseed,
    random = math.random,
    ceil = math.ceil
}

local bit = require 'bit'
local ffi = require 'ffi'
local js = panorama.open()

local tabs = {"Home", "Misc", "Visuals"}
local selected_tab = ui.new_combobox("LUA", "B", "Select Tab", tabs)

local name = js.MyPersonaAPI.GetName()
local home_text1 = ui.new_label("LUA", "B", "Hello! ")
local home_text2 = ui.new_label("LUA", "B", "Welcome to Multi-Tools Lua")
local home_version = ui.new_label("LUA", "B", "Version 1.0")
local label1 = ui.new_button("LUA", "B", "Bassota Youtube ~", function()
    js.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@bassota-cc")
end)
local label2 = ui.new_button("LUA", "B", "Bassota Server ~", function()
    js.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/KtQMfrkjsH")
end)

local function update_home_text()
    local player = entity.get_local_player()
    local player_name = player and entity.get_player_name(player) or "Unknown"
    ui.set(home_text1, "Hello! " .. player_name)
end

local in_game_features_label = ui.new_label("LUA", "B", "In game features")
local tp_checkbox = ui.new_checkbox("LUA", "B", "Enable Thirdperson")
local tpdistanceslider = ui.new_slider("LUA", "B", "Thirdperson Distance", 30, 200, 150)

local function toggle_thirdperson()
    local enabled = ui.get(tp_checkbox)
    if enabled then
        client.exec("thirdperson")
        local distance = ui.get(tpdistanceslider)
        if distance == nil then
            print("Error: tpdistanceslider returned nil in toggle_thirdperson")
            distance = 150
        end
        client.exec("cam_idealdist " .. tostring(distance))
    else
        client.exec("firstperson")
    end
end

local function tpdistance()
    if ui.get(tp_checkbox) then
        local distance = ui.get(tpdistanceslider)
        if distance == nil then
            print("Error: tpdistanceslider returned nil in tpdistance")
            distance = 150
        end
        client.exec("cam_idealdist " .. tostring(distance))
    end
end

ui.set_callback(tp_checkbox, toggle_thirdperson)
ui.set_callback(tpdistanceslider, tpdistance)

local function set_aspect_ratio(aspect_ratio_multiplier)
    local screen_width, screen_height = client.screen_size()
    local aspectratio_value = (screen_width * aspect_ratio_multiplier) / screen_height
    if aspect_ratio_multiplier == 1 then
        aspectratio_value = 0
    end
    client.set_cvar("r_aspectratio", tonumber(aspectratio_value))
end

local function gcd(m, n)
    while m ~= 0 do
        m, n = math.fmod(n, m), m
    end
    return n
end

local screen_width, screen_height
local aspect_ratio_checkbox = ui.new_checkbox("LUA", "B", "Enable Aspect Ratio")
local aspect_ratio_slider
local multiplier = 0.01
local steps = 200

local function setup_aspect_ratio()
    if not screen_width or not screen_height then
        screen_width, screen_height = client.screen_size()
        if not screen_width or not screen_height then
            client.log("Error: Cannot get screen size, defaulting to 1920x1080")
            screen_width, screen_height = 1920, 1080
        end
    end

    local aspect_ratio_table = {}
    for i = 1, steps do
        local i2 = (steps - i) * multiplier
        local divisor = gcd(screen_width * i2, screen_height)
        if screen_width * i2 / divisor < 100 or i2 == 1 then
            aspect_ratio_table[i] = screen_width * i2 / divisor .. ":" .. screen_height / divisor
        end
    end
    if not aspect_ratio_slider then
        aspect_ratio_slider = ui.new_slider("LUA", "B", "Force Aspect Ratio", 0, steps - 1, steps / 2, true, "%", 1, aspect_ratio_table)
    end

    local function toggle_aspect_ratio()
        local enabled = ui.get(aspect_ratio_checkbox)
        if enabled then
            local aspect_ratio = ui.get(aspect_ratio_slider) * 0.01
            aspect_ratio = 2 - aspect_ratio
            set_aspect_ratio(aspect_ratio)
        else
            set_aspect_ratio(1)
        end
    end
    local function on_aspect_ratio_changed()
        if ui.get(aspect_ratio_checkbox) then
            local aspect_ratio = ui.get(aspect_ratio_slider) * 0.01
            aspect_ratio = 2 - aspect_ratio
            set_aspect_ratio(aspect_ratio)
        end
    end
    ui.set_callback(aspect_ratio_checkbox, toggle_aspect_ratio)
    ui.set_callback(aspect_ratio_slider, on_aspect_ratio_changed)
end

screen_width, screen_height = client.screen_size()
setup_aspect_ratio()

local function on_paint()
    local screen_width_temp, screen_height_temp = client.screen_size()
    if screen_width_temp ~= screen_width or screen_height_temp ~= screen_height then
        screen_width, screen_height = screen_width_temp, screen_height_temp
        setup_aspect_ratio()
    end
end
client.set_event_callback("paint", on_paint)

local tracer_enabled = ui.new_checkbox("LUA", "B", "Enable Bullet Tracers Redux")
local tracer_color = ui.new_color_picker("LUA", "B", "Tracer Color", 255, 255, 255, 255)

local queue = {}

local function on_bullet_impact(e)
    if not ui.get(tracer_enabled) then
        return
    end
    if client.userid_to_entindex(e.userid) ~= entity.get_local_player() then
        return
    end
    local lx, ly, lz = client.eye_position()
    queue[client.tickcount()] = {lx, ly, lz, e.x, e.y, e.z, client.curtime() + 2}
end

local function on_paint_tracers()
    if not ui.get(tracer_enabled) then
        return
    end
    for tick, data in pairs(queue) do
        if client.curtime() <= data[7] then
            local x1, y1 = client.world_to_screen(data[1], data[2], data[3])
            local x2, y2 = client.world_to_screen(data[4], data[5], data[6])
            if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
                local r, g, b, a = ui.get(tracer_color)
                client.line(x1, y1, x2, y2, r, g, b, a)
            end
        end
    end
end

local function on_round_prestart()
    if not ui.get(tracer_enabled) then
        return
    end
    queue = {}
end

client.set_event_callback("bullet_impact", on_bullet_impact)
client.set_event_callback("paint", on_paint_tracers)
client.set_event_callback("round_prestart", on_round_prestart)

local function update_tracer_visibility()
    local enabled = ui.get(tracer_enabled)
    ui.set_visible(tracer_color, enabled)
end
ui.set_callback(tracer_enabled, update_tracer_visibility)

local viewmodel_enabled = ui.new_checkbox("LUA", "B", "Enable Viewmodel Changer")
local dir = { 'LUA', 'B', 4000, { '-', 'Left hand', 'Right hand' } }
local menu = {
    kpos = ui.new_combobox(dir[1], dir[2], 'Knife positioning', dir[4]),
    fov = ui.new_slider(dir[1], dir[2], 'Viewmodel FOV', -dir[3], dir[3], 0, true, '', 0.01),
    x = ui.new_slider(dir[1], dir[2], 'Viewmodel offset X', -dir[3], dir[3], 0, true, '', 0.01),
    y = ui.new_slider(dir[1], dir[2], 'Viewmodel offset Y', -dir[3], dir[3], 0, true, '', 0.01),
    z = ui.new_slider(dir[1], dir[2], 'Viewmodel offset Z', -dir[3], dir[3], 0, true, '', 0.01),
    roll = ui.new_slider(dir[1], dir[2], 'Viewmodel offset Roll', -180, 180, 0, true),
}

local ffi_to = {
    classptr = ffi.typeof('void***'),
    client_entity = ffi.typeof('void*(__thiscall*)(void*, int)'),
    set_angles = (function()
        ffi.cdef('typedef struct { float x; float y; float z; } vmodel_vec3_t;')
        return ffi.typeof('void(__thiscall*)(void*, const vmodel_vec3_t&)')
    end)()
}

local rawelist = client.create_interface('client_panorama.dll', 'VClientEntityList003') or error('VClientEntityList003 is nil', 2)
local ientitylist = ffi.cast(ffi_to.classptr, rawelist) or error('ientitylist is nil', 2)
local get_client_entity = ffi.cast(ffi_to.client_entity, ientitylist[0][3]) or error('get_client_entity is nil', 2)
local set_angles = client.find_signature('client_panorama.dll', '\x55\x8B\xEC\x83\xE4\xF8\x83\xEC\x64\x53\x56\x57\x8B\xF1') or error('Couldn\'t find set_angles signature!')
local set_angles_fn = ffi.cast(ffi_to.set_angles, set_angles) or error('Couldn\'t cast set_angles_fn')

local get_original = function()
    return {
        rhand = tonumber(client.get_cvar('cl_righthand')) or 1,
        fov = tonumber(client.get_cvar('viewmodel_fov')) or 60,
        x = tonumber(client.get_cvar('viewmodel_offset_x')) or 2.5,
        y = tonumber(client.get_cvar('viewmodel_offset_y')) or 0,
        z = tonumber(client.get_cvar('viewmodel_offset_z')) or -1.5
    }
end

local g_handler = function(...)
    if not ui.get(viewmodel_enabled) then
        return
    end
    local shutdown = #({...}) > 0
    local multiplier = shutdown and 0 or 0.0025
    local original, data = get_original(),
    {
        rhand = ui.get(menu.kpos),
        fov = ui.get(menu.fov) * multiplier,
        x = ui.get(menu.x) * multiplier,
        y = ui.get(menu.y) * multiplier,
        z = ui.get(menu.z) * multiplier
    }
    client.set_cvar('viewmodel_fov', original.fov + data.fov)
    client.set_cvar('viewmodel_offset_x', original.x + data.x)
    client.set_cvar('viewmodel_offset_y', original.y + data.y)
    client.set_cvar('viewmodel_offset_z', original.z + data.z)
    client.set_cvar('cl_righthand', original.rhand)
    if not shutdown and data.rhand ~= dir[4][1] then
        local is_holding_knife = false
        local me = entity.get_local_player()
        local wpn = entity.get_player_weapon(me)
        if me ~= nil and wpn ~= nil then
            is_holding_knife = string.match((entity.get_classname(wpn) or ''), 'Knife')
        end
        client.set_cvar('cl_righthand', (
            {
                [dir[4][2]] = is_holding_knife and 0 or 1, -- Left hand
                [dir[4][3]] = is_holding_knife and 1 or 0, -- Right hand
            }
        )[data.rhand])
    end
end

local g_override_view = function()
    if not ui.get(viewmodel_enabled) then
        return
    end
    local me = entity.get_local_player()
    local viewmodel = entity.get_prop(me, 'm_hViewModel[0]')
    if me == nil or viewmodel == nil then
        return
    end
    local viewmodel_ent = get_client_entity(ientitylist, viewmodel)
    if viewmodel_ent == nil then
        return
    end
    local camera_angles = { client.camera_angles() }
    local angles = ffi.cast('vmodel_vec3_t*', ffi.new('char[?]', ffi.sizeof('vmodel_vec3_t')))
    angles.x, angles.y, angles.z = camera_angles[1], camera_angles[2], ui.get(menu.roll)
    set_angles_fn(viewmodel_ent, angles)
end

client.set_event_callback('pre_render', g_handler)
client.set_event_callback('override_view', g_override_view)
client.set_event_callback('shutdown', function() g_handler(true) end)

local useful_features_label = ui.new_label("LUA", "B", "Useful features")
local buy_as_600ms_at
local has_bought = false

local primary_weapons = {
    {name='-', command=""},
    {name='AWP', command="buy awp; "},
    {name='Auto-Sniper', command="buy scar20; buy g3sg1; "},
    {name='Scout', command="buy ssg08; "},
    {name='Negev', command="buy negev; "},
    {name='SG553 / AUG', command="buy sg553; buy aug; "}
}

local secondary_weapons = {
    {name='-', command=""},
    {name='R8 Revolver / Deagle', command="buy deagle; "},
    {name='Dual Berettas', command="buy elite; "},
    {name='FN57 / Tec9 / CZ75-Auto', command="buy fn57; "},
    {name='P250', command="buy p250;"}
}

local gear_weapons = {
    {name='Kevlar', command="buy vest; "},
    {name='Helmet', command="buy vesthelm; "},
    {name='Defuse Kit', command="buy defuser; "},
    {name='Grenade', command="buy hegrenade; "},
    {name='Molotov', command="buy incgrenade; "},
    {name='Smoke', command="buy smokegrenade; "},
    {name='Flashbang (x2)', command="buy flashbang; "},
    {name='Taser', command="buy taser; "},
}

local function get_names(table_data)
    local names = {}
    for i=1, #table_data do
        table.insert(names, table_data[i]["name"])
    end
    return names
end

local function get_command(table_data, name)
    for i=1, #table_data do
        if table_data[i]["name"] == name then
            return table_data[i]["command"]
        end
    end
end

local function has_weapon(player)
    for i=0, 64 do
        local weapon = entity.get_prop(player, "m_hMyWeapons", i)
        if weapon ~= nil and entity.get_classname(weapon) == "CWeaponSCAR20" then
            return true
        end
    end
    return false
end

local buybot_enabled = ui.new_checkbox("LUA", "B", "Enable Auto-Buy")
local buybot_primary = ui.new_combobox("LUA", "B", "Auto-Buy: Primary", get_names(primary_weapons))
local buybot_pistol = ui.new_combobox("LUA", "B", "Auto-Buy: Secondary", get_names(secondary_weapons))
local buybot_gear = ui.new_multiselect("LUA", "B", "Auto-Buy: Gear", get_names(gear_weapons))

local function on_enabled_change()
    local enabled = ui.get(buybot_enabled)
    ui.set_visible(buybot_primary, enabled)
    ui.set_visible(buybot_pistol, enabled)
    ui.set_visible(buybot_gear, enabled)
end
ui.set_callback(buybot_enabled, on_enabled_change)

local function buy()
    if not ui.get(buybot_enabled) or has_bought then
        return
    end
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        return
    end
    
    local primary = ui.get(buybot_primary)
    local pistol = ui.get(buybot_pistol)
    local gear = ui.get(buybot_gear)
    local commands = {}
    
    if primary ~= "-" and not (primary == "Auto-Sniper" and has_weapon(local_player)) then
        table.insert(commands, get_command(primary_weapons, primary))
    end
    if pistol ~= "-" then
        table.insert(commands, get_command(secondary_weapons, pistol))
    end
    for i=1, #gear do
        if gear[i] ~= "-" then
            table.insert(commands, get_command(gear_weapons, gear[i]))
        end
    end
    table.insert(commands, "use weapon_knife;")
    
    if #commands > 1 then
        local command = table.concat(commands, "")
        client.exec(command)
        client.log("Auto-Buy executed: " .. command)
        has_bought = true
    end
end

local function run_buybot()
    if not ui.get(buybot_enabled) then
        return
    end
    has_bought = false
    buy_as_600ms_at = globals.realtime() + 0.6
end

local function on_paint_buybot()
    if not ui.get(buybot_enabled) or buy_as_600ms_at == nil then
        return
    end
    local realtime = globals.realtime()
    if buy_as_600ms_at <= realtime then
        buy()
        buy_as_600ms_at = nil
    end
end

client.set_event_callback("round_prestart", run_buybot)
client.set_event_callback("player_connect_full", function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        has_bought = false
    end
end)
client.set_event_callback("paint", on_paint_buybot)
client.set_event_callback("player_death", function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        has_bought = false
    end
end)

local unsafe_enabled = ui.new_checkbox("LUA", "B", "Enable Unsafe Charge In Air")
local ref = {
    aimbot = ui.reference('RAGE', 'Aimbot', 'Enabled'),
    doubletap = {
        main = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
        fakelag_limit = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit')
    }
}

local local_player_unsafe, callback_reg, dt_charged = nil, false, false

local function toticks(seconds)
    return math.floor(seconds / client.tickinterval() + 0.5)
end

local function check_charge()
    local m_nTickBase = entity.get_prop(local_player_unsafe, 'm_nTickBase')
    local clientlatency = client.latency()
    local shift = math.floor(m_nTickBase - client.tickcount() - 3 - toticks(clientlatency) * 0.5 + 0.5 * (clientlatency * 10))
    local wanted = -14 + (ui.get(ref.doubletap.fakelag_limit) - 1) + 3
    dt_charged = shift <= wanted
end

local function on_setup_command()
    if not ui.get(unsafe_enabled) then
        ui.set(ref.aimbot, true)
        if callback_reg then
            client.unset_event_callback('run_command', check_charge)
            callback_reg = false
        end
        return
    end
    if not ui.get(ref.doubletap.main[2]) or not ui.get(ref.doubletap.main[1]) then
        ui.set(ref.aimbot, true)
        if callback_reg then
            client.unset_event_callback('run_command', check_charge)
            callback_reg = false
        end
        return
    end
    local_player_unsafe = entity.get_local_player()
    if not callback_reg then
        client.set_event_callback('run_command', check_charge)
        callback_reg = true
    end
    local threat = client.current_threat()
    if not dt_charged and threat and bit.band(entity.get_prop(local_player_unsafe, 'm_fFlags'), 1) == 0 and bit.band(entity.get_esp_data(threat).flags, bit.lshift(1, 11)) == 2048 then
        ui.set(ref.aimbot, false)
    else
        ui.set(ref.aimbot, true)
    end
end

local function on_shutdown_unsafe()
    ui.set(ref.aimbot, true)
end

client.set_event_callback("setup_command", on_setup_command)
client.set_event_callback("shutdown", on_shutdown_unsafe)

local screen_features_label = ui.new_label("LUA", "B", "Screen features")

local animation_zoom_enabled = ui.new_checkbox("LUA", "B", "Enable Animation Zoom")
local animation_zoom_fov = ui.new_slider("LUA", "B", "Amount FOV", -40, 70, 0, true, "%", 1)
local animation_zoom_speed = ui.new_slider("LUA", "B", "Amount Speed", 0, 30, 0, true, "ms", 0.1)

local refs = {
    fov = ui.reference('MISC', 'Miscellaneous', 'Override FOV')
}

local zoom = 0

local function smooth(a, b, s)
    return a + (b - a) * s
end

client.set_event_callback("override_view", function(v)
    if not refs.fov then
        print("Override FOV reference not found!")
        return
    end

    local d_fov = ui.get(refs.fov)
    if not d_fov then
        print("Failed to get FOV value!")
        return
    end

    if not ui.get(animation_zoom_enabled) then
        zoom = smooth(zoom, d_fov, 0.05)
        v.fov = zoom
        return
    end

    local animation_speed = ui.get(animation_zoom_speed) / 1000
    local clamped_speed = math.max(0.01, math.min(0.03, animation_speed))

    local me = entity.get_local_player()
    if not me or entity.get_prop(me, "m_iHealth") <= 0 then return end

    local w = entity.get_player_weapon(me)
    if not w then return end

    local scoped = entity.get_prop(me, "m_bIsScoped") == 1
    if not scoped then
        zoom = smooth(zoom, d_fov, clamped_speed)
        v.fov = zoom
        return
    end

    local zoom_offset = ui.get(animation_zoom_fov) or 0
    local zoom_level = entity.get_prop(w, "m_zoomLevel") or 0
    local target_fov = d_fov - zoom_offset - (zoom_level == 2 and 45 or 30)

    target_fov = math.max(30, math.min(200, target_fov))
    zoom = smooth(zoom, target_fov, clamped_speed)
    v.fov = zoom
end)

local other_features_label = ui.new_label("LUA", "B", "Other features")
local tt_enabled = ui.new_checkbox("LUA", "B", "Enable Christian Talk")
local deathsay_enabled = ui.new_checkbox("LUA", "B", "Enable DeathSay")
local tt_mode = ui.new_combobox("LUA", "B", "Mode", {"off", "✟bassota"})

local killsay_sentences = {
    "✟Не бойся, я с тобой. Не расстраивайтесь, потому что Я ваш Бог. Я поддержу тебя своей победоносной правой рукой✟",
    "✟Поэтому не беспокойтесь о завтрашнем дне, потому что завтра будет тревожиться само за себя✟",
    "✟Он дает силу слабым, а также людям, у которых нет силы, он увеличивает силу✟",
    "✟Ибо Господь будет твоей уверенностью и удержит твою ногу, чтобы тебя не поймали✟",
    "✟Поэтому мы не устраняем сердце. Хотя наш внешний человек погибает, внутренний человек обновляется день ото дня✟",
    "✟Cо мной бог✟",
    "✟Прости меня за сделанное, всевышний!✟",
    "✟Будь сильным и храбрым. Не бойтесь и не ужасайтесь из-за них, потому что Господь, Бог ваш, идет с вами, он никогда не оставит вас и не покинет вас✟",
    "✟Кто не со Мною, тот против Меня, и кто не собирает со Мною, тот расточает✟",
    "✟Не различайте лиц на суде, как малого, так и великого выслушайте✟",
    "✟Отче! прости им, ибо не знают, что делают✟",
    "✟Не мсти и не имей злобы на сынов народа твоего, но люби ближнего твоего, как самого себя. Я Господь✟",
    "✟Кто не любит, тот не познал Бога, потому что Бог есть любовь✟"
}

local deathsay_sentences = {
    "✟Грехи юности моей … не вспоминай … Господи!✟",
    "✟Лицемеры! различать лице неба вы умеете, а знамений времён не можете?✟",
    "✟Мою душу заберет Господь Бог✟",
    "✟Прости меня грешного, Господь Бог!✟",
    "✟Всегда буду верным, Аминь✟",
    "✟Не искушай меня!✟",
    "✟Спаси и Сохрани!✟"
}

local function on_player_death(event)
    local local_player = entity.get_local_player()
    local attacker = client.userid_to_entindex(event.attacker)
    local victim = client.userid_to_entindex(event.userid)

    if local_player == nil or attacker == nil or victim == nil then
        return
    end
   
    if ui.get(tt_enabled) and ui.get(tt_mode) == "✟bassota" then
        if attacker == local_player and victim ~= local_player then
            local killsay = "say " .. killsay_sentences[math.random(#killsay_sentences)]
            client.log(killsay)
            client.exec(killsay)
        end
    end

    if ui.get(tt_enabled) and ui.get(deathsay_enabled) then
        if victim == local_player then
            local deathsay = "say " .. deathsay_sentences[math.random(#deathsay_sentences)]
            client.log(deathsay)
            client.exec(deathsay)
        end
    end
end

client.set_event_callback("player_death", on_player_death)

local function bind_signature(module, interface, signature, typestring)
    local interface = client.create_interface(module, interface) or error("invalid interface", 2)
    local instance = client.find_signature(module, signature) or error("invalid signature", 2)
    local success, typeof = pcall(ffi.typeof, typestring)
    if not success then
        error(typeof, 2)
    end
    local fnptr = ffi.cast(typeof, instance) or error("invalid typecast", 2)
    return function(...)
        return fnptr(interface, ...)
    end
end

local function vmt_entry(instance, index, type)
    return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end

local function vmt_bind(module, interface, index, typestring)
    local instance = client.create_interface(module, interface) or error("invalid interface")
    local success, typeof = pcall(ffi.typeof, typestring)
    if not success then
        error(typeof, 2)
    end
    local fnptr = vmt_entry(instance, index, typeof) or error("invalid vtable")
    return function(...)
        return fnptr(instance, ...)
    end
end

local hitsound_enabled
local head_sound_ref
local body_sound_ref
local volume_ref

local sound_names = {}
local sound_name_to_file = {}

local int_ptr = ffi.typeof("int[1]")
local char_buffer = ffi.typeof("char[?]")

local find_first = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x6A\x00\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08\xE8\xCC\xCC\xCC\xCC\x5D", "const char*(__thiscall*)(void*, const char*, const char*, int*)")
local find_next = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x83\xEC\x0C\x53\x8B\xD9\x8B\x0D\xCC\xCC\xCC\xCC", "const char*(__thiscall*)(void*, int)")
local find_close = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x53\x8B\x5D\x08\x85", "void(__thiscall*)(void*, int)")
local current_directory = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF\x75\x0C", "bool(__thiscall*)(void*, char*, int)")
local add_to_searchpath = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x56\x57", "void(__thiscall*)(void*, const char*, const char*, int)")
local find_is_directory = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x0F\xB7\x45\x08", "bool(__thiscall*)(void*, int)")

local sndplaydelay = cvar.sndplaydelay
local native_Surface_PlaySound = vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 82, "void(__thiscall*)(void*, const char*)")

local function collect_files()
    local files = {}
    local file_handle = int_ptr()
    local file = find_first("*", "XGAME", file_handle)
    while file ~= nil do
        local file_name = ffi.string(file)
        if find_is_directory(file_handle[0]) == false and (file_name:find(".mp3") or file_name:find(".wav")) then
            files[#files+1] = file_name
        end
        file = find_next(file_handle[0])
    end
    find_close(file_handle[0])
    return files
end

local function normalize_file_name(name)
    if name:find("_") then
        name = name:gsub("_", " ")
    end
    if name:find(".mp3") then
        name = name:gsub(".mp3", "")
    end
    if name:find(".wav") then
        name = name:gsub(".wav", "")
    end
    return name
end

local function on_player_hurt(e)
    if not ui.get(hitsound_enabled) then return end
    if client.userid_to_entindex(e.attacker) == entity.get_local_player() then
        local sound_file = sound_name_to_file[e.hitgroup == 1 and ui.get(head_sound_ref) or ui.get(body_sound_ref)]
        if sound_file then
            for i=1, ui.get(volume_ref) do
                native_Surface_PlaySound(sound_file)
            end
        end
    end
end

local function on_player_blind(e)
    if not ui.get(hitsound_enabled) then return end
    if client.userid_to_entindex(e.attacker) == entity.get_local_player() then
        local sound_file = sound_name_to_file[ui.get(body_sound_ref)]
        sndplaydelay:invoke_callback(0, sound_file)
    end
end

local function on_hitsound_toggle()
    local state = ui.get(hitsound_enabled)
    ui.set_visible(head_sound_ref, state)
    ui.set_visible(body_sound_ref, state)
    ui.set_visible(volume_ref, state)
end

local function init_hitsound()
    sound_names[#sound_names+1] = "Wood stop"
    sound_name_to_file["Wood stop"] = "doors/wood_stop1.wav"
    sound_names[#sound_names+1] = "Wood strain"
    sound_name_to_file["Wood strain"] = "physics/wood/wood_strain7.wav"
    sound_names[#sound_names+1] = "Wood plank impact"
    sound_name_to_file["Wood plank impact"] = "physics/wood/wood_plank_impact_hard4.wav"
    sound_names[#sound_names+1] = "Warning"
    sound_name_to_file["Warning"] = "resource/warning.wav"

    local current_path = char_buffer(128)
    current_directory(current_path, ffi.sizeof(current_path))
    current_path = string.format("%s\\csgo\\sound\\hitsounds", ffi.string(current_path))
    add_to_searchpath(current_path, "XGAME", 0)

    local sound_files = collect_files()
    for i=1, #sound_files do
        local file_name = sound_files[i]
        local normalized_name = normalize_file_name(file_name)
        sound_names[#sound_names+1] = normalized_name
        sound_name_to_file[normalized_name] = string.format("hitsounds/%s", file_name)
    end

    hitsound_enabled = ui.new_checkbox("LUA", "B", "Enable Custom Hitsound")
    head_sound_ref = ui.new_combobox("LUA", "B", "Head shot sound", sound_names)
    body_sound_ref = ui.new_combobox("LUA", "B", "Body shot sound", sound_names)
    volume_ref = ui.new_slider("LUA", "B", "Sound volume", 1, 100, 1, true, "%")

    ui.set_callback(hitsound_enabled, on_hitsound_toggle)
    client.set_event_callback("player_hurt", on_player_hurt)
    client.set_event_callback("player_blind", on_player_blind)

    ui.set_visible(head_sound_ref, false)
    ui.set_visible(body_sound_ref, false)
    ui.set_visible(volume_ref, false)
end

init_hitsound()

local enable_fog = ui.new_checkbox("LUA", "B", "Enable Fog")
local fog_color = ui.new_color_picker("LUA", "B", "Fog Color", 255, 255, 255, 255)
local fog_start = ui.new_slider("LUA", "B", "Fog Start", 0, 16384, 0)
local fog_end = ui.new_slider("LUA", "B", "Fog End", 0, 16384, 0)
local fog_max_density = ui.new_slider("LUA", "B", "Fog Max Density", 0, 100, 0, true, "%")

local color32 = {}

function color32.rgb_to_int(r, g, b)
    local r_byte = color32._decimal_to_byte(r)
    local g_byte = color32._decimal_to_byte(g)
    local b_byte = color32._decimal_to_byte(b)
    return color32._binary_to_decimal(b_byte .. g_byte .. r_byte)
end

function color32._decimal_to_byte(integer)
    local bin = ''
    while integer ~= 0 do
        if integer % 2 == 0 then
            bin = '0' .. bin
        else
            bin = '1' .. bin
        end
        integer = math.floor(integer / 2)
    end
    local length = string.len(bin)
    local byte = ''
    for _ = 1, 8 - length do
        byte = byte .. '0'
    end
    return byte .. bin
end

function color32._binary_to_decimal(binary)
    binary = string.reverse(binary)
    local sum = 0
    for i = 1, string.len(binary) do
        local num = string.sub(binary, i, i) == "1" and 1 or 0
        sum = sum + num * (2 ^ (i - 1))
    end
    return sum
end

local c_fog_controller = {
    entity = entity.get_all("CFogController")[1],
    fog_color = color32.rgb_to_int(255, 255, 255),
    fog_start = 0,
    fog_end = 0,
    fog_max_density = 0
}

client.set_event_callback("player_connect_full", function(data)
    local player = client.userid_to_entindex(data.userid)
    if player == entity.get_local_player() then
        c_fog_controller.entity = entity.get_all("CFogController")[1]
        if c_fog_controller.entity then
            entity.set_prop(c_fog_controller.entity, "m_fog.colorPrimary", c_fog_controller.fog_color)
            entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.colorPrimary", c_fog_controller.fog_color)
        end
    end
end)

client.set_event_callback("paint", function()
    if not c_fog_controller.entity then return end
    entity.set_prop(c_fog_controller.entity, "m_fog.enable", ui.get(enable_fog) and 1 or 0)
    entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.enable", ui.get(enable_fog) and 1 or 0)

    entity.set_prop(c_fog_controller.entity, "m_fog.start", c_fog_controller.fog_start)
    entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.start", c_fog_controller.fog_start)

    entity.set_prop(c_fog_controller.entity, "m_fog.end", c_fog_controller.fog_end)
    entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.end", c_fog_controller.fog_end)

    entity.set_prop(c_fog_controller.entity, "m_fog.maxdensity", c_fog_controller.fog_max_density)
    entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.maxdensity", c_fog_controller.fog_max_density)

    entity.set_prop(c_fog_controller.entity, "m_fog.colorPrimary", c_fog_controller.fog_color)
    entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.colorPrimary", c_fog_controller.fog_color)
end)

ui.set_callback(fog_start, function()
    local fog_start_value = ui.get(fog_start)
    local fog_end_value = ui.get(fog_end)
    if fog_start_value > fog_end_value then
        ui.set(fog_end, fog_start_value)
        fog_end_value = fog_start_value
    end
    c_fog_controller.fog_start = fog_start_value
    if c_fog_controller.entity then
        entity.set_prop(c_fog_controller.entity, "m_fog.start", fog_start_value)
        entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.start", fog_start_value)
    end
end)

ui.set_callback(fog_end, function()
    local fog_start_value = ui.get(fog_start)
    local fog_end_value = ui.get(fog_end)
    if fog_end_value < fog_start_value then
        ui.set(fog_start, fog_end_value)
        fog_start_value = fog_end_value
    end
    c_fog_controller.fog_end = fog_end_value
    if c_fog_controller.entity then
        entity.set_prop(c_fog_controller.entity, "m_fog.end", fog_end_value)
        entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.end", fog_end_value)
    end
end)

ui.set_callback(fog_max_density, function()
    local fog_max_density_value = ui.get(fog_max_density) / 100
    c_fog_controller.fog_max_density = fog_max_density_value
    if c_fog_controller.entity then
        entity.set_prop(c_fog_controller.entity, "m_fog.maxdensity", fog_max_density_value)
        entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.maxdensity", fog_max_density_value)
    end
end)

ui.set_callback(fog_color, function()
    local r, g, b = ui.get(fog_color)
    local color32_value = color32.rgb_to_int(r, g, b)
    c_fog_controller.fog_color = color32_value
    if c_fog_controller.entity then
        entity.set_prop(c_fog_controller.entity, "m_fog.colorPrimary", color32_value)
        entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.colorPrimary", color32_value)
    end
end)

local function initialize_fog()
    local r, g, b = ui.get(fog_color)
    local color32_value = color32.rgb_to_int(r, g, b)
    c_fog_controller.fog_color = color32_value
    if c_fog_controller.entity then
        entity.set_prop(c_fog_controller.entity, "m_fog.colorPrimary", color32_value)
        entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.colorPrimary", color32_value)
    end

    local fog_start_value = ui.get(fog_start)
    c_fog_controller.fog_start = fog_start_value
    if c_fog_controller.entity then
        entity.set_prop(c_fog_controller.entity, "m_fog.start", fog_start_value)
        entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.start", fog_start_value)
    end

    local fog_end_value = ui.get(fog_end)
    c_fog_controller.fog_end = fog_end_value
    if c_fog_controller.entity then
        entity.set_prop(c_fog_controller.entity, "m_fog.end", fog_end_value)
        entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.end", fog_end_value)
    end

    local fog_max_density_value = ui.get(fog_max_density) / 100
    c_fog_controller.fog_max_density = fog_max_density_value
    if c_fog_controller.entity then
        entity.set_prop(c_fog_controller.entity, "m_fog.maxdensity", fog_max_density_value)
        entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.maxdensity", fog_max_density_value)
    end
end

initialize_fog()

local hpbar = {
    customhealthbars = ui.new_checkbox("LUA", "B", "Custom Health bar"),
    gradient = ui.new_checkbox("LUA", "B", "Enable Gradient"),
    label = ui.new_label("LUA", "B", "Full Health"),
    colorpicker = ui.new_color_picker("LUA", "B", "Full Health", 142, 214, 77, 255),
    label2 = ui.new_label("LUA", "B", "Empty Health"),
    colorpicker2 = ui.new_color_picker("LUA", "B", "Empty Health", 244, 48, 87, 255),
}

local players = {}

local function lerp(a, b, percentage)
    return a + (b - a) * percentage
end

local function handle_checkbox()
    local enabled = ui.get(hpbar.customhealthbars)
    if enabled then
        ui.set(ui.reference("Visuals", "Player ESP", "Health bar"), false)
    end
    ui.set_visible(hpbar.gradient, enabled)
    ui.set_visible(hpbar.label, enabled)
    ui.set_visible(hpbar.label2, enabled)
    ui.set_visible(hpbar.colorpicker, enabled)
    ui.set_visible(hpbar.colorpicker2, enabled)
end

ui.set_callback(hpbar.customhealthbars, handle_checkbox)

client.set_event_callback("round_end", function(info)
    players = {}
end)

client.set_event_callback("paint", function()
    if ui.get(hpbar.customhealthbars) then
        local r, g, b, a = ui.get(hpbar.colorpicker)
        local r2, g2, b2, a2 = ui.get(hpbar.colorpicker2)
        local local_player = entity.get_local_player()
        local force_teammates = false or ui.get(ui.reference("Visuals", "Player ESP", "Teammates"))
        if not entity.is_alive(local_player) then
            local m_iObserverMode = entity.get_prop(local_player, "m_iObserverMode")
            if m_iObserverMode == 4 or m_iObserverMode == 5 then
                local spectated_ent = entity.get_prop(local_player, "m_hObserverTarget")
                if entity.is_enemy(spectated_ent) then
                    force_teammates = true
                end
            end
        end
        
        local all_players = entity.get_all("CCSPlayer")
        local enemy_players = {}
        for i = 1, #all_players do
            local player = all_players[i]
            if not force_teammates and entity.is_enemy(player) or force_teammates and not entity.is_enemy(player) then
                table.insert(enemy_players, player)
            end
        end
        for i = 1, #enemy_players do
            local e = enemy_players[i]
            if entity.is_alive(local_player) or not force_teammates or force_teammates and (not entity.is_alive(local_player) and not entity.is_enemy(e)) then
                local x1, y1, x2, y2, a = entity.get_bounding_box(e)
                if x1 ~= nil and y1 ~= nil and not entity.is_dormant(e) then
                    local hp = entity.get_prop(e, "m_iHealth")
                    local height = y2 - y1 + 2
                    y1 = y1 - 1
                    local width = x2 - x1
                    local leftside = x1 - 5
                    if hp ~= nil then
                        local percentage = hp / 100
                        local name = entity.get_player_name(e)
                        players[name] = {}
                        renderer.rectangle(leftside - 1, y1, 4, height, 20, 20, 20, 150)
                        local new_r, new_g, new_b = lerp(r2, r, percentage), lerp(g2, g, percentage), lerp(b2, b, percentage)
                        if ui.get(hpbar.gradient) then
                            renderer.gradient(leftside, math.ceil(y2 - (height * percentage)) + 2, 2, math.floor(height * percentage) - 2, new_r, new_g, new_b, 255, r2, g2, b2, 255, false)
                        else
                            renderer.rectangle(leftside, math.ceil(y2 - (height * percentage)) + 2, 2, math.floor(height * percentage) - 2, new_r, new_g, new_b, 255)
                        end
                        if hp < 100 then
                            renderer.text(leftside - 2, y2 - (height * percentage) + 2, 255, 255, 255, 255, "-cd", 0, hp)
                        end
                        players[name] = {
                            ent = e,
                            teammate = entity.is_enemy(e),
                            health = hp,
                            health_percentage = percentage,
                            active = false,
                            alpha = 255,
                        }
                    end
                end
            end
        end
        if entity.is_alive(local_player) then
            for k, v in pairs(players) do
                if not v.active and entity.is_alive(v.ent) then
                    local x1, y1, x2, y2, a = entity.get_bounding_box(v.ent)
                    if x1 ~= nil and y1 ~= nil then
                        local height = y2 - y1 + 2
                        y1 = y1 - 1
                        local width = x2 - x1
                        local leftside = x1 - 5
                        local percentage = v.health_percentage
                        local hp = v.health
                        renderer.rectangle(leftside - 1, y1, 4, height, 20, 20, 20, 150 * (players[k].alpha / 255))
                        players[k].alpha = players[k].alpha - 0.25
                        local new_r, new_g, new_b = lerp(r2, r, percentage), lerp(g2, g, percentage), lerp(b2, b, percentage)
                        if ui.get(hpbar.gradient) then
                            renderer.gradient(leftside, math.ceil(y2 - (height * percentage)) + 2, 2, math.floor(height * percentage) - 2, new_r, new_g, new_b, players[k].alpha, r2, g2, b2, players[k].alpha, false)
                        else
                            renderer.rectangle(leftside, math.ceil(y2 - (height * percentage)) + 2, 2, math.floor(height * percentage) - 2, new_r, new_g, new_b, players[k].alpha)
                        end
                        if hp < 100 then
                            renderer.text(leftside - 2, y2 - (height * percentage) + 2, 255, 255, 255, players[k].alpha, "-cd", 0, hp)
                        end
                    end
                end
                if v.alpha < 0 then
                    players[k] = nil
                end
            end
        end
    end
end)

local function update_tab_content()
    local current_tab = ui.get(selected_tab)
    local tp_enabled = ui.get(tp_checkbox)
    local aspect_enabled = ui.get(aspect_ratio_checkbox)
    local buybot_enabled_state = ui.get(buybot_enabled)
    local tracer_enabled_state = ui.get(tracer_enabled)
    local viewmodel_enabled_state = ui.get(viewmodel_enabled)
    local animation_zoom_enabled_state = ui.get(animation_zoom_enabled)
    local fog_enabled_state = ui.get(enable_fog)
    local tt_enabled_state = ui.get(tt_enabled)
    local hitsound_enabled_state = ui.get(hitsound_enabled)
    local hpbar_enabled_state = ui.get(hpbar.customhealthbars)

    local function safe_set_visible(element, state)
        if element then
            ui.set_visible(element, state)
        else
            client.log("Warning: Attempted to set visibility on nil UI element")
        end
    end

    if current_tab == "Home" then
        update_home_text()
    end

    safe_set_visible(home_text1, current_tab == "Home")
    safe_set_visible(home_text2, current_tab == "Home")
    safe_set_visible(home_version, current_tab == "Home")
    safe_set_visible(label1, current_tab == "Home")
    safe_set_visible(label2, current_tab == "Home")

    safe_set_visible(in_game_features_label, current_tab == "Misc")
    safe_set_visible(tp_checkbox, current_tab == "Misc")
    safe_set_visible(tpdistanceslider, current_tab == "Misc" and tp_enabled)
    safe_set_visible(aspect_ratio_checkbox, current_tab == "Misc")
    safe_set_visible(aspect_ratio_slider, current_tab == "Misc" and aspect_enabled)
    safe_set_visible(tracer_enabled, current_tab == "Misc")
    safe_set_visible(tracer_color, current_tab == "Misc" and tracer_enabled_state)
    safe_set_visible(viewmodel_enabled, current_tab == "Misc")
    safe_set_visible(menu.kpos, current_tab == "Misc" and viewmodel_enabled_state)
    safe_set_visible(menu.fov, current_tab == "Misc" and viewmodel_enabled_state)
    safe_set_visible(menu.x, current_tab == "Misc" and viewmodel_enabled_state)
    safe_set_visible(menu.y, current_tab == "Misc" and viewmodel_enabled_state)
    safe_set_visible(menu.z, current_tab == "Misc" and viewmodel_enabled_state)
    safe_set_visible(menu.roll, current_tab == "Misc" and viewmodel_enabled_state)

    safe_set_visible(useful_features_label, current_tab == "Misc")
    safe_set_visible(buybot_enabled, current_tab == "Misc")
    safe_set_visible(buybot_primary, current_tab == "Misc" and buybot_enabled_state)
    safe_set_visible(buybot_pistol, current_tab == "Misc" and buybot_enabled_state)
    safe_set_visible(buybot_gear, current_tab == "Misc" and buybot_enabled_state)
    safe_set_visible(unsafe_enabled, current_tab == "Misc")

    safe_set_visible(screen_features_label, current_tab == "Misc")
    safe_set_visible(animation_zoom_enabled, current_tab == "Misc")
    safe_set_visible(animation_zoom_fov, current_tab == "Misc" and animation_zoom_enabled_state)
    safe_set_visible(animation_zoom_speed, current_tab == "Misc" and animation_zoom_enabled_state)

    safe_set_visible(other_features_label, current_tab == "Misc")
    safe_set_visible(tt_enabled, current_tab == "Misc")
    safe_set_visible(deathsay_enabled, current_tab == "Misc" and tt_enabled_state)
    safe_set_visible(tt_mode, current_tab == "Misc" and tt_enabled_state)
    safe_set_visible(hitsound_enabled, current_tab == "Misc")
    safe_set_visible(head_sound_ref, current_tab == "Misc" and hitsound_enabled_state)
    safe_set_visible(body_sound_ref, current_tab == "Misc" and hitsound_enabled_state)
    safe_set_visible(volume_ref, current_tab == "Misc" and hitsound_enabled_state)

    safe_set_visible(enable_fog, current_tab == "Visuals")
    safe_set_visible(fog_color, current_tab == "Visuals" and fog_enabled_state)
    safe_set_visible(fog_start, current_tab == "Visuals" and fog_enabled_state)
    safe_set_visible(fog_end, current_tab == "Visuals" and fog_enabled_state)
    safe_set_visible(fog_max_density, current_tab == "Visuals" and fog_enabled_state)

    safe_set_visible(hpbar.customhealthbars, current_tab == "Visuals")
    safe_set_visible(hpbar.gradient, current_tab == "Visuals" and hpbar_enabled_state)
    safe_set_visible(hpbar.label, current_tab == "Visuals" and hpbar_enabled_state)
    safe_set_visible(hpbar.label2, current_tab == "Visuals" and hpbar_enabled_state)
    safe_set_visible(hpbar.colorpicker, current_tab == "Visuals" and hpbar_enabled_state)
    safe_set_visible(hpbar.colorpicker2, current_tab == "Visuals" and hpbar_enabled_state)
end

ui.set_callback(selected_tab, update_tab_content)
ui.set_callback(tp_checkbox, update_tab_content)
ui.set_callback(aspect_ratio_checkbox, update_tab_content)
ui.set_callback(buybot_enabled, update_tab_content)
ui.set_callback(tracer_enabled, update_tab_content)
ui.set_callback(viewmodel_enabled, update_tab_content)
ui.set_callback(animation_zoom_enabled, update_tab_content)
ui.set_callback(enable_fog, update_tab_content)
ui.set_callback(tt_enabled, update_tab_content)
ui.set_callback(hitsound_enabled, update_tab_content)
ui.set_callback(hpbar.customhealthbars, update_tab_content)

math.randomseed(globals.tickcount()) 

update_tab_content()

client.set_event_callback("shutdown", function()
    if ui.get(tp_checkbox) then
        client.exec("firstperson")
    end
    set_aspect_ratio(1)
    g_handler(true)
    on_shutdown_unsafe()
    if c_fog_controller.entity then
        entity.set_prop(c_fog_controller.entity, "m_fog.enable", 0)
        entity.set_prop(entity.get_local_player(), "m_skybox3d.fog.enable", 0)
    end
    ui.set(ui.reference("Visuals", "Player ESP", "Health bar"), true)
end)

client.log("Multi-Tools Lua v1.0 loaded successfully!")