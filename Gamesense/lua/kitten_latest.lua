-- # region libs 
local ffi = require('ffi')
local pui = require('gamesense/pui')
local base64 = require('gamesense/base64')
local clipboard = require('gamesense/clipboard')
local c_entity = require ('gamesense/entity')
local http = require ('gamesense/http')
local vector = require "vector"
local steamworks = require('gamesense/steamworks')
local surface = require 'gamesense/surface'

local defer, error, getfenv, setfenv, getmetatable, setmetatable,
ipairs, pairs, next, printf, rawequal, rawset, rawlen, readfile, writefile, require, select,
tonumber, tostring, toticks, totime, type, unpack, pcall, xpcall =
defer, error, getfenv, setfenv, getmetatable, setmetatable,
ipairs, pairs, next, printf, rawequal, rawset, rawlen, readfile, writefile, require, select,
tonumber, tostring, toticks, totime, type, unpack, pcall, xpcall

local filesystem = {} do
    local m, i = "filesystem_stdio.dll", "VFileSystem017"
    local add_search_path        = vtable_bind(m, i, 11, "void (__thiscall*)(void*, const char*, const char*, int)")
    local remove_search_path     = vtable_bind(m, i, 12, "bool (__thiscall*)(void*, const char*, const char*)")

    local get_game_directory = vtable_bind("engine.dll", "VEngineClient014", 36, "const char*(__thiscall*)(void*)")
    filesystem.game_directory = string.sub(ffi.string(get_game_directory()), 1, -5)

    add_search_path(filesystem.game_directory, "ROOT_PATH", 0)
    defer(function () remove_search_path(filesystem.game_directory, "ROOT_PATH") end)

    filesystem.create_directory = vtable_bind(m, i, 22, "void (__thiscall*)(void*, const char*, const char*)")
end

filesystem.create_directory("meowhook", "ROOT_PATH")

local texts = {"t.me/itsloveparis", "братва курская", "сука тебе не давала", "я люблю вас!", "ХАХАХАХА угнал инвалидную коляску", "мяу котики", "загрузка бэст аашечек", "неандерталецхук", "ты не замечаешь тех, кто реально выделяется", "доброе утро, хомьяк", "understand me, and everything unfolds", "позитивчик!!!", "бля походу клейфа сбила бабушка на инвалидной коляске", "ооууу эйс", "телочку на веранде?", "[thesnowangel] > как-то раз я посмотрел с бабушкой порно..."}
local timer, display_time, is_displaying, random_text = 0, 2, false, ""
 
math.randomseed(math.floor(globals.realtime() * 1000))
random_text = texts[math.random(1, #texts)]

local motion = { base_speed = 6, _list = {} }
motion.new = function(name, new_value, speed, init)
    speed = speed or motion.base_speed
    motion._list[name] = motion._list[name] or (init or 0)
    motion._list[name] = math.lerp(motion._list[name], new_value, speed)
    return motion._list[name]
end

local file_texture = readfile("meowhook/texted.png")
local load_textures = function(data)
    meowhook = renderer.load_png(data, 1024, 1024)
    meowhook_s = renderer.load_png(data, 64, 64)
end

if not file_texture then
    http.get("https://github.com/pumpk1n812/meowhook/raw/736015e6a7f416faa2f8d19585f10956170bbf8d/meowhook%20(3).png", function(success, raw)
        if success and string.sub(raw.body, 2, 4) == "PNG" then
            load_textures(raw.body)
            writefile("meowhook/texted.png", raw.body)
        end
    end)
else
    load_textures(file_texture)
end

client.set_event_callback('paint', function()
    local width, height = client.screen_size()
    local alpha_value = motion.new("alpha_value", is_displaying and 145 or 0, 6)
    local text_alpha = motion.new("text_alpha", is_displaying and 255 or 0, 6) 

    local texture_alpha = motion.new("texture_alpha", is_displaying and 255 or 0, 6)

    renderer.rectangle(0, 0, width, height, 0, 0, 0, alpha_value)

    local texture_w, texture_h = 200, 24
    renderer.texture(meowhook, width / 2 - texture_w / 2, height / 2 - texture_h / 2, texture_w, texture_h, 255, 255, 255, texture_alpha, "f")

    local rw, rh = renderer.measure_text(verdana, random_text)
    renderer.text(width / 2 - rw / 2, height / 2 + texture_h / 2 + 10, 255, 255, 255, text_alpha, 0, 0, random_text)

    if is_displaying and globals.realtime() - timer > display_time then
        is_displaying = false
    elseif not is_displaying and timer == 0 then
        timer, is_displaying = globals.realtime(), true
    end
end)


local a = function (...) return ... end

local surface_create_font, surface_get_text_size, surface_draw_text = surface.create_font, surface.get_text_size, surface.draw_text
local verdana = surface_create_font('Verdana', 12, 400, {})
client.exec("Clear")
local sp = {}
sp.one = function (t, r, k) local result = {} for i, v in ipairs(t) do n = k and v[k] or i result[n] = r == nil and i or v[r] end return result end
sp.two = function (t, j)  for i = 1, #t do if t[i] == j then return i end end  end
sp.three = function (t)  local res = {} for i = 1, table.maxn(t) do if t[i] ~= nil then res[#res+1] = t[i] end end return res  end
local gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end
local gram_update = function(tab, value, forced)
    local new_tab = tab or {}
    if forced or new_tab[#new_tab] ~= value then
        _G._G.table.insert(new_tab, value)
        _G.table.remove(new_tab, 1)
    end
    tab = new_tab
end
local get_average = function(tab) local elements, sum = 0, 0; for k, v in pairs(tab) do sum = sum + v; elements = elements + 1; end return sum / elements; end
function get_velocity(player)
    local x,y,z = entity.get_prop(player, "m_vecVelocity")
    if x == nil then return end
    return math.sqrt(x*x + y*y + z*z)
end

function ui.multiReference(tab, groupbox, name)
    local ref1, ref2, ref3 = ui.reference(tab, groupbox, name)
    return { ref1, ref2, ref3 }
end
binds = {
    legMovement = ui.multiReference("AA", "Other", "Leg movement"),
    flenabled = ui.multiReference("AA", "Fake lag", "Enabled"),
    slowmotion = ui.multiReference("AA", "Other", "Slow motion"),
    OSAAA = ui.multiReference("AA", "Other", "On shot anti-aim"),
    AAfake = ui.multiReference("AA", "Other", "Fake peek"),
    fakelag_amount = ui.reference("AA", "Fake lag", "Amount"),
    fakelag_limit = ui.reference("AA", "Fake lag", "Limit"),
    fakelag_variance = ui.reference("AA", "Fake lag", "Variance"),
}

function traverse_table_on(tbl, prefix)
    prefix = prefix or ""
    local stack = {{tbl, prefix}}

    while #stack > 0 do
        local current = _G.table.remove(stack)
        local current_tbl = current[1]
        local current_prefix = current[2]

        for key, value in pairs(current_tbl) do
            local full_key = current_prefix .. key
            if type(value) == "table" then
                _G.table.insert(stack, {value, full_key .. "."})
            else
                ui.set_visible(value, true)
            end
        end
    end
end

function traverse_table(tbl, prefix)
    prefix = prefix or ""
    local stack = {{tbl, prefix}}

    while #stack > 0 do
        local current = _G.table.remove(stack)
        local current_tbl = current[1]
        local current_prefix = current[2]

        for key, value in pairs(current_tbl) do
            local full_key = current_prefix .. key
            if type(value) == "table" then
                _G.table.insert(stack, {value, full_key .. "."})
            else 
                ui.set_visible(value, false)
            end
        end
    end
end

renderer.rounded_rectangle = function(x, y, w, h, r, g, b, a, radius)
    y = y + radius
    local data_circle = {
        {x + radius, y, 180},
        {x + w - radius, y, 90},
        {x + radius, y + h - radius * 2, 270},
        {x + w - radius, y + h - radius * 2, 0},
    }

    local data = {
        {x + radius, y, w - radius * 2, h - radius * 2},
        {x + radius, y - radius, w - radius * 2, radius},
        {x + radius, y + h - radius * 2, w - radius * 2, radius},
        {x, y, radius, h - radius * 2},
        {x + w - radius, y, radius, h - radius * 2},
    }

    for _, data in next, data_circle do
        renderer.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
    end

    for _, data in next, data do
        renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
    end
end

function lerp(a, b, t)
    return a + (b - a) * t
end

math.max_lerp_low_fps = (1 / 45) * 100
math.lerp = function(start, end_pos, time)
    if start == end_pos then return end_pos end
    local frametime = globals.frametime() * 170
    time = time * math.min(frametime, math.max_lerp_low_fps)
    local val = start + (end_pos - start) * globals.frametime() * time
    return math.abs(val - end_pos) < 0.01 and end_pos or val
end

local motion = { base_speed = 20, _list = {} }
motion.new = function(name, new_value, speed, init)
    speed = speed or motion.base_speed
    motion._list[name] = motion._list[name] or (init or 0)
    motion._list[name] = math.lerp(motion._list[name], new_value, speed)
    return motion._list[name]
end

local utils = {}

utils.rgb_to_hex = function(color)
    return string.format("%02X%02X%02X%02X", color[1], color[2], color[3], color[4] or 255)
end
utils.animate_text = function(time, string, r, g, b, a, r1, g1, b1, a1)
    local t_out, t_out_iter = {}, 1
    local l = string:len() - 1

    local r_add = (r1 - r)
    local g_add = (g1 - g)
    local b_add = (b1 - b)
    local a_add = (a1 - a)

    for i = 1, #string do
        local iter = (i - 1)/(#string - 1) + time
        t_out[t_out_iter] = "\a" .. utils.rgb_to_hex({r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter ))})

        t_out[t_out_iter+1] = string:sub(i, i)
        t_out_iter = t_out_iter + 2
    end

    return _G.table.concat(t_out)
end

local js = panorama.open()
local MyPersonaAPI, LobbyAPI, PartyListAPI, SteamOverlayAPI = js.MyPersonaAPI, js.LobbyAPI, js.PartyListAPI, js.SteamOverlayAPI

local condition = {"Global", "Standing", "Running", "Walking", "Crouching", "Crouch Moving", "Air", "Air Crouching", "Fakelag"}
-- # region libs end


-- # region data
local data = {
    name = "meowhook",
    version = "cuteness",
    update = "15.01.2025 / 6:00",
    steamname = panorama.open("CSGOHud").MyPersonaAPI.GetName(),
}
-- # region data system

-- # region reference

local reference = {
    enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
    yawbase = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
    edgeyaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    forcebaim = ui.reference('RAGE', 'Aimbot', 'Force body aim'),
    safepoint = ui.reference('RAGE', 'Aimbot', 'Force safe point'),
    roll = { ui.reference('AA', 'Anti-aimbot angles', 'Roll') },
    clantag = ui.reference('Misc', 'Miscellaneous', 'Clan tag spammer'),
    mates = ui.reference("Visuals", "Player ESP", "Teammates"),
    name = ui.reference('Visuals', 'Player ESP', 'Name'),

    pitch = { ui.reference('AA', 'Anti-aimbot angles', 'pitch'), },
    rage = { ui.reference('RAGE', 'Aimbot', 'Enabled') },
    yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') }, 
    yawjitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
    bodyyaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
    freestand = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
    slow = { ui.reference('AA', 'Other', 'Slow motion') },
    os = { ui.reference('AA', 'Other', 'On shot anti-aim') },
    slow = { ui.reference('AA', 'Other', 'Slow motion') },
    dt = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
    fakeDuck = ui.reference("RAGE", "Other", "Duck peek assist"),
    sw = ui.reference('AA', 'Other', 'Slow motion'),
    lgm = ui.reference('AA', 'Other', 'Leg movement'),
    osaaa = ui.reference('AA', 'Other', 'On shot anti-aim'),
    fkp = ui.reference('AA', 'Other', 'Fake peek'),
    sw = ui.reference('AA', 'Other', 'Slow motion'),
    fk = ui.reference('AA', 'Fake lag', 'Enabled'),
    fke = ui.reference('AA', 'Fake lag', 'Amount'),
    fkv = ui.reference('AA', 'Fake lag', 'Variance'),
    fkl = ui.reference('AA', 'Fake lag', 'Limit'),
    fakeLag = {ui.reference("AA", "Fake lag", "Limit")},
    
    forcebaim = ui.reference('RAGE', 'Aimbot', 'Force body aim'),
    forcepoint = ui.reference('RAGE', 'Aimbot', 'Force safe point'),
    minimum_damage_override = { ui.reference("RAGE", "Aimbot", "Minimum damage override") },

    anti_aim = {ui.reference("AA", "Anti-aimbot angles", "Enabled")},
    pitch = {ui.reference("AA", "Anti-aimbot angles", "Pitch")},
    yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw Base"),
    yawjitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
    bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
    fs_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    freeStand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    slow = { ui.reference("AA", "Other", "Slow motion") },
    onshotaa = {ui.reference("AA","Other", "On shot anti-aim")},
    fakelaglimit = {ui.reference("AA","Fake lag", "Limit")},
    fakelagvariance = {ui.reference("AA","Fake lag", "Variance")},
    fakelagamount = {ui.reference("AA","Fake lag", "Amount")},
    fakelagenabled = {ui.reference("AA","Fake lag", "Enabled")},
    legmovement = {ui.reference("AA","Other", "Leg movement")},
    fakepeek = {ui.reference("AA","Other", "Fake peek")},
    qp = {ui.reference('RAGE', 'Other', 'Quick peek assist')},
    weapon_type = ui.reference('Rage', 'Weapon type', 'Weapon type'),
    rage_cb = { ui.reference("RAGE", "Aimbot", "Enabled") },
    fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    dt = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
    scope = ui.reference('misc', 'miscellaneous', 'override zoom fov'),
    dmg = { ui.reference('RAGE', "Aimbot", 'Minimum damage override')},
    hit_chance = pui.reference("RAGE", "Aimbot", "Minimum hit chance"),
    fov = pui.reference('misc', 'miscellaneous', 'override fov'),
}

-- # region reference end

-- # region group menu
table = {
    antiaim = pui.group('AA', 'Anti-aimbot angles'),
    fakelag = pui.group('AA', 'Fake lag'),
    other = pui.group('AA', 'Other'),
}
-- # region group menu end

-- # region ui
menu = {
    main = {
        categories = table.other:label("\v▪ \r Menu categories"),
        categories_other = table.other:label("\a333333FF⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"),
        select = table.other:combobox("\n", "Main", "Anti-aim", "Miscellaneous"),
        username = table.other:label("User › \v" .. data.steamname),
        build = table.other:label("Version › \v" .. data.version),
        update = table.other:label("Last Update › \v" .. data.update),
        link = table.other:button("Realm of delightful \vkittens!", function() SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/khjBpk5A7u") end),


        p_name_1 = table.antiaim:label("\v▪ \r Preset list"),
        p_line_1 = table.antiaim:label("\a333333FF⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"),
        p_name_2 = table.fakelag:label("\v▪ \r Create configuration"),
        p_line_2 = table.fakelag:label("\a333333FF⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"),
        list = table.antiaim:listbox('Configs', '', false),
		name = table.fakelag:textbox('Configuration name', '', false),
        load = table.antiaim:button('Load', function() end),
        save = table.fakelag:button('Save', function() end),
		delete = table.antiaim:button('Delete', function() end),
		import = table.antiaim:button('Import from \aFFC0CBFFclipboard', function() end),
		export = table.antiaim:button('Export to \aFFC0CBFFclipboard', function() end)
    },

    antiaim = {
        builder1 = table.antiaim:label("\v▪ \r Builder \vAnti-aims"),
        builder_1 = table.antiaim:label("\a333333FF⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"),
        cate = table.fakelag:label("\v▪ \r Anti-aim categories"),
        cate_1 = table.fakelag:label("\a333333FF⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"),
        select = table.fakelag:combobox("\n", "Builder", "Features"),
        features = table.antiaim:multiselect("\v› \rType", "Safe Function", "Avoid Backstab", "Edge on FD", "Useless Function"),
        take = table.antiaim:multiselect("\v› \rEssential", "Freestanding", "Manual Yaw"),
        safe = table.antiaim:multiselect("\v› \rSafe Function", "Knife", "Zeus", "Heigh Distance", "Standing", "Crouching", "Air Crouching"),
        useless = table.antiaim:multiselect("\v› \rUseless Function", "Spin on Warm-up", "Spin no Enemies"),
        key_freestand = table.antiaim:hotkey('\v›\r Freestanding'),
        disablers = table.antiaim:multiselect("\n", condition),
        key_left = table.antiaim:hotkey('\v›\r Manual Left'),
        key_right = table.antiaim:hotkey('\v›\r Manual Right'),
        key_forward = table.antiaim:hotkey('\v›\r Manual Forward'),
        key_reset = table.antiaim:hotkey('\v›\r Manual Reset'),
        condition = table.antiaim:combobox("\v› \rCurrent \vState", condition)
    },
    fakelag = {
        amount = table.fakelag:combobox("Amount", "Dynamic", "Maximum", "Fluctuate"),
        variance = table.fakelag:slider("Variance", 0, 100, 0, true, "%", 1),
        limit = table.fakelag:slider("Limit", 1, 15, 13, true, "t", 1)
    },
    misc = {
        lua_text_14 = table.fakelag:label("\v▪ \r Categories"),
        lua_line_14 = table.fakelag:label("\a333333FF⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"),
        select = table.fakelag:combobox("\n", "Ragebot", "Visuals", "Other"),
        lua_text_2 = table.antiaim:label("\v▪ \r Visuals Function"),
        lua_line_3 = table.antiaim:label("\a333333FF⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"),
        logs = table.antiaim:checkbox("Ragebot Logs"),
        logs_type = table.antiaim:multiselect("\aFFC0CBFF› \rSelect logger", "Console", "Screen"),
        hit_color = table.antiaim:label("\v›\r Damage color ", {255, 188, 188}),
        miss_color = table.antiaim:label("\v›\r Miss color ", {255, 188, 188}),

        screen_indicators = table.antiaim:checkbox("Screen Indicator"),
        screen_color = table.antiaim:label("\v›\r Centered color ", {255, 188, 188}),

        arrows = table.antiaim:checkbox("Manual Arrows"),
        arrows_color = table.antiaim:label("\v›\r Arrows color ", {255, 188, 188}),

        animationed = table.antiaim:checkbox("Animation Zoom"),
        animation_fov = table.antiaim:slider("\v› \rAmount FOV", -40, 70, 0, true, "%", 1),
        animation_speed = table.antiaim:slider("\v› \rAmount Speed", 0, 30, 0, true, "ms", 0.1),

        mindmg = table.antiaim:checkbox("Minimum Damage Indicator"),

        lua_text = table.antiaim:label("\v▪ \r Other Function"),
        lua_line_1 = table.antiaim:label("\a333333FF⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"),

        ladder = table.antiaim:checkbox("Fast Ladder"),

        clantag = table.antiaim:checkbox("Clantag spammer"),
        trashtalk = table.antiaim:checkbox("Chat spammer"),
        trashtalk_select = table.antiaim:multiselect("\n", "Kill", "Death", "1 MODE"),

        aspectratio = table.antiaim:checkbox("\rAspect Ratio"),
        aspectratio_value = table.antiaim:slider("\v› \rAmount", 0, 200, 177, true, " ", 0.01, {[0.1] = "Sosal?", [0.025] = "5:4", [133] = "4:3", [160] = "16:9", [170] = "16:10"}),

        third_person = table.antiaim:checkbox("\rThird Person"),
        third_person_value = table.antiaim:slider("\v› \rAmount", 30, 200, 70, true, " ", 1),

        animation = table.antiaim:checkbox("\rAnimation Breakers"),
        animation_ground = table.antiaim:combobox("  \rGround", {"Static", "Jitter"}),
        animation_value = table.antiaim:slider("  \rValue", 0, 10, 5),
        animation_air = table.antiaim:combobox("  \rIn Air", {"Off", "Static"}),
        animation_addons = table.antiaim:multiselect("  \rAddons", {"Body Lean", "Smoothing", "Earthquake"}),
        animation_body_lean = table.antiaim:slider("Body Lean Value", 0, 100, 0, true, "%", 0.01, {[0] = "Disabled", [35] = "Low", [50] = "Medium", [75] = "High", [100] = "Extreme"}),
        state = table.fakelag:multiselect("\v[Earthquake] › \rState", {"Running", "Air", "Air-C"}),
        indexes = table.fakelag:multiselect("\v[Earthquake] › \rIndexes", {6, 9, 10}),
        magnitude = table.fakelag:slider("\v[Earthquake] › \rMagnitude", 0, 100, 0, true, "", 0.01),
        speed = table.fakelag:slider("\v[Earthquake] › \rSpeed", 0, 10, 2),

        lua_text_4 = table.antiaim:label("\v▪ \r Ragebot Function"),
        lua_line_4 = table.antiaim:label("\a333333FF⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"),

        predicted = table.antiaim:checkbox("Prediction System"),
        hotkeying = table.antiaim:hotkey("\v› \rHotkey"),
        tab = table.antiaim:slider("Mode", 1, 3, 0, true, "%", 1, {[1] = "Wingman", [2] = "Competitive", [3] = "Experience"}),

        force = table.antiaim:checkbox("Safety Function"),
        force_select = table.antiaim:combobox("\n", "AWP", "SSG-08", "SCAR20", "G3SG1", "Glock", "Usp", "Deagle / Revolver", "Five Seven", "Tec-9"),

        baim_slider_awp = table.antiaim:slider("\v[AWP] \rHP \v› Baim", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        baim_slider_ssg = table.antiaim:slider("\v[SSG-08] \rHP \v› Baim", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        baim_slider_scar = table.antiaim:slider("\v[SCAR20] \rHP \v› Baim", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        baim_slider_g3sg1 = table.antiaim:slider("\v[G3SG1] \rHP \v› Baim", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        baim_slider_deagle = table.antiaim:slider("\v[DEAGLE / R8] \rHP \v› Baim", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        baim_slider_glock = table.antiaim:slider("\v[Glock] \rHP \v› Baim", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        baim_slider_usp = table.antiaim:slider("\v[Usp] \rHP \v› Baim", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        baim_slider_fiveseven = table.antiaim:slider("\v[Five Seven] \rHP \v› Baim", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        baim_slider_tec9 = table.antiaim:slider("\v[Tec-9] HP \r\v› Baim", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),

        safe_slider_awp = table.antiaim:slider("\v[AWP] \rHP \v› Safe ", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        safe_slider_ssg = table.antiaim:slider("\v[SSG-08] \rHP \v› Safe ", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        safe_slider_scar = table.antiaim:slider("\v[SCAR20] \rHP \v› Safe ", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        safe_slider_g3sg1 = table.antiaim:slider("\v[G3SG1] \rHP \v› Safe ", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        safe_slider_deagle = table.antiaim:slider("\v[DEAGLE / R8] \rHP \v› Safe ", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        safe_slider_glock = table.antiaim:slider("\v[Glock] \rHP \v› Safe ", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        safe_slider_usp = table.antiaim:slider("\v[Usp] \rHP \v› Safe ", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        safe_slider_fiveseven = table.antiaim:slider("\v[Five Seven] \rHP \v› Safe ", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),
        safe_slider_tec9 = table.antiaim:slider("\v[Tec-9] \rHP \v› Safe ", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),

        jump_scout = table.antiaim:checkbox("Air Stop"),
        jump_scout_hotkey = table.antiaim:hotkey("\v›\r Hotkey Air Stop"),
        jump_select = table.antiaim:multiselect("\n", "Distance", "Hitchance"),
        jump_distance = table.antiaim:slider("\v› \rDistance", 0, 1350, 0, true, "", 1),
        jump_hitchance = table.antiaim:slider("\v› \rHitchance", 0, 100, 0, true, "", 1, {[0] = "Disabled", [50] = "Safety", [100] = "0_0"}),

        hitchance_override = table.antiaim:checkbox("Override Hitchance"),
        hitchance_guns_type = table.antiaim:combobox("Guns", "SSG-08", "AWP", "SCAR20", "G3SG1", "GLOCK", "USP", "R8"),
        hitchance_override_hotkey = table.antiaim:hotkey("\v›\r Hotkey Override Hitchance"),
        hitchance_override_ssg = table.antiaim:slider("\n", 0, 75, 0, true, "%", 1, {[0] = "Disabled", [35] = "High", [50] = "Perfect", [75] = "0_o"}),
        hitchance_override_awp = table.antiaim:slider("\n", 0, 75, 0, true, "%", 1, {[0] = "Disabled", [35] = "High", [50] = "Perfect", [75] = "0_o"}),
        hitchance_override_scar = table.antiaim:slider("\n", 0, 75, 0, true, "%", 1, {[0] = "Disabled", [35] = "High", [50] = "Perfect", [75] = "0_o"}),
        hitchance_override_g3sg1 = table.antiaim:slider("\n", 0, 75, 0, true, "%", 1, {[0] = "Disabled", [35] = "High", [50] = "Perfect", [75] = "0_o"}),
        hitchance_override_glock = table.antiaim:slider("\n", 0, 75, 0, true, "%", 1, {[0] = "Disabled", [35] = "High", [50] = "Perfect", [75] = "0_o"}),
        hitchance_override_usp = table.antiaim:slider("\n", 0, 75, 0, true, "%", 1, {[0] = "Disabled", [35] = "High", [50] = "Perfect", [75] = "0_o"}),
        hitchance_override_r8 = table.antiaim:slider("\n", 0, 75, 0, true, "%", 1, {[0] = "Disabled", [35] = "High", [50] = "Perfect", [75] = "0_o"}),

        charge = table.antiaim:checkbox("Allow Unsafe Charge"),
        hideshots = table.antiaim:checkbox("Fixed Hideshots"),
    
    },
}
-- # region ui end

-- # region depend
menu.misc.indexes:depend( {menu.misc.animation, true}, {menu.misc.animation_addons, "Earthquake"}, {menu.misc.select, "Other"}, {menu.main.select, "Miscellaneous"}, {menu.misc.state, function()
    for _, v in ipairs(menu.misc.state:get()) do
        if v == "Running" or v == "Air" or v == "Air-C" then return true end
    end
    return false
end, true})
menu.misc.magnitude:depend( {menu.misc.animation, true}, {menu.misc.animation_addons, "Earthquake"}, {menu.misc.select, "Other"}, {menu.main.select, "Miscellaneous"}, {menu.misc.indexes, function()
    for _, v in ipairs(menu.misc.indexes:get()) do
        if v == "6" or v == "9" or v == "10" then return true end
    end
    return false
end, true})
menu.misc.speed:depend( {menu.misc.animation, true}, {menu.misc.animation_addons, "Earthquake"}, {menu.misc.select, "Other"}, {menu.main.select, "Miscellaneous"}, {menu.misc.indexes, function()
    for _, v in ipairs(menu.misc.indexes:get()) do
        if v == "6" or v == "9" or v == "10" then return true end
    end
    return false
end, true})

menu.misc.jump_select:depend({menu.misc.jump_scout, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.jump_distance:depend({menu.misc.jump_scout, true}, {menu.misc.jump_select, "Distance"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.jump_hitchance:depend({menu.misc.jump_scout, true}, {menu.misc.jump_select, "Hitchance"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})

menu.misc.predicted:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.tab:depend({menu.misc.predicted, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.hotkeying:depend({menu.misc.predicted, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.state:depend({menu.misc.animation, true}, {menu.misc.animation_addons, "Earthquake"}, {menu.misc.select, "Other"}, {menu.main.select, "Miscellaneous"})
menu.misc.clantag:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.misc.trashtalk:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.misc.trashtalk_select:depend({menu.misc.trashtalk, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.misc.mindmg:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Visuals"})
menu.misc.select:depend({menu.main.select, "Miscellaneous"})
menu.main.save:depend({menu.main.select, "Main"})
menu.fakelag.amount:depend({menu.main.select, "Anti-aim"}, {menu.antiaim.select, "Features"})
menu.fakelag.variance:depend({menu.main.select, "Anti-aim"}, {menu.antiaim.select, "Features"})
menu.fakelag.limit:depend({menu.main.select, "Anti-aim"}, {menu.antiaim.select, "Features"})
menu.misc.hitchance_guns_type:depend({menu.misc.hitchance_override, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.hitchance_override_usp:depend({menu.misc.hitchance_override, true}, {menu.misc.hitchance_guns_type, "USP"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.hitchance_override_awp:depend({menu.misc.hitchance_override, true}, {menu.misc.hitchance_guns_type, "AWP"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.hitchance_override_scar:depend({menu.misc.hitchance_override, true}, {menu.misc.hitchance_guns_type, "SCAR20"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.hitchance_override_g3sg1:depend({menu.misc.hitchance_override, true}, {menu.misc.hitchance_guns_type, "G3SG1"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.hitchance_override_r8:depend({menu.misc.hitchance_override, true}, {menu.misc.hitchance_guns_type, "R8"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.hitchance_override_glock:depend({menu.misc.hitchance_override, true}, {menu.misc.hitchance_guns_type, "GLOCK"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.hitchance_override_ssg:depend({menu.misc.hitchance_override, true}, {menu.misc.hitchance_guns_type, "SSG-08"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.force:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.force_select:depend({menu.misc.force, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})

menu.misc.baim_slider_awp:depend({menu.misc.force, true}, {menu.misc.force_select, "AWP"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.baim_slider_ssg:depend({menu.misc.force, true}, {menu.misc.force_select, "SSG-08"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.baim_slider_scar:depend({menu.misc.force, true}, {menu.misc.force_select, "SCAR20"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})

menu.misc.baim_slider_g3sg1:depend({menu.misc.force, true}, {menu.misc.force_select, "G3SG1"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.baim_slider_deagle:depend({menu.misc.force, true}, {menu.misc.force_select, "Deagle / Revolver"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.baim_slider_glock:depend({menu.misc.force, true}, {menu.misc.force_select, "Glock"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.baim_slider_usp:depend({menu.misc.force, true}, {menu.misc.force_select, "Usp"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.baim_slider_fiveseven:depend({menu.misc.force, true}, {menu.misc.force_select, "Five Seven"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})

menu.misc.baim_slider_tec9:depend({menu.misc.force, true}, {menu.misc.force_select, "Tec-9"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})

menu.misc.safe_slider_awp:depend({menu.misc.force, true}, {menu.misc.force_select, "AWP"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.safe_slider_ssg:depend({menu.misc.force, true}, {menu.misc.force_select, "SSG-08"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.safe_slider_scar:depend({menu.misc.force, true}, {menu.misc.force_select, "SCAR20"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})

menu.misc.safe_slider_g3sg1:depend({menu.misc.force, true}, {menu.misc.force_select, "G3SG1"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.safe_slider_deagle:depend({menu.misc.force, true}, {menu.misc.force_select, "Deagle / Revolver"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.safe_slider_glock:depend({menu.misc.force, true}, {menu.misc.force_select, "Glock"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.safe_slider_usp:depend({menu.misc.force, true}, {menu.misc.force_select, "Usp"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.safe_slider_fiveseven:depend({menu.misc.force, true}, {menu.misc.force_select, "Five Seven"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})

menu.misc.safe_slider_tec9:depend({menu.misc.force, true}, {menu.misc.force_select, "Tec-9"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})

menu.misc.lua_line_4:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.lua_text_4:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.lua_text:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.misc.lua_line_1:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.misc.lua_text_2:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Visuals"})
menu.misc.lua_line_14:depend({menu.main.select, "Miscellaneous"})
menu.misc.lua_text_14:depend({menu.main.select, "Miscellaneous"})
menu.antiaim.builder1:depend({menu.main.select, "Anti-aim"})
menu.antiaim.builder_1:depend({menu.main.select, "Anti-aim"})
menu.antiaim.cate:depend({menu.main.select, "Anti-aim"})
menu.antiaim.cate_1:depend({menu.main.select, "Anti-aim"})
menu.misc.lua_line_3:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Visuals"})
menu.misc.jump_scout:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.jump_scout_hotkey:depend({menu.misc.jump_scout, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.aspectratio:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.misc.aspectratio_value:depend({menu.misc.aspectratio, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.misc.third_person:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.misc.third_person_value:depend({menu.misc.third_person, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.misc.charge:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.hideshots:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.hitchance_override:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.hitchance_override_hotkey:depend({menu.misc.hitchance_override, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Ragebot"})
menu.misc.animation:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.misc.animation_ground:depend({menu.misc.animation, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.misc.animation_value:depend({menu.misc.animation, true}, {menu.misc.animation_ground, "Jitter"}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.misc.animation_air:depend({menu.misc.animation, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.misc.animation_addons:depend({menu.misc.animation, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.misc.animation_body_lean:depend({menu.misc.animation, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})
menu.antiaim.features:depend({menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.antiaim.take:depend({menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.antiaim.key_left:depend({menu.antiaim.take, "Manual Yaw"}, {menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.antiaim.disablers:depend({menu.antiaim.take, "Freestanding"}, {menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.antiaim.key_right:depend({menu.antiaim.take, "Manual Yaw"}, {menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.antiaim.key_reset:depend({menu.antiaim.take, "Manual Yaw"}, {menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.antiaim.key_forward:depend({menu.antiaim.take, "Manual Yaw"}, {menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.fakelag.amount:depend({menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.antiaim.condition:depend({menu.main.select, "Anti-aim"}, {menu.antiaim.select, "Builder"})
menu.antiaim.select:depend({menu.main.select, "Anti-aim"})
menu.fakelag.variance:depend({menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.fakelag.limit:depend({menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.antiaim.take:depend({menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.antiaim.key_freestand:depend({menu.antiaim.take, "Freestanding"}, {menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.antiaim.safe:depend({menu.antiaim.features, "Safe Function"}, {menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.antiaim.useless:depend({menu.antiaim.features, "Useless Function"}, {menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.antiaim.useless:depend({menu.antiaim.features, "Useless Function"}, {menu.antiaim.select, "Features"}, {menu.main.select, "Anti-aim"})
menu.antiaim.condition:depend({menu.antiaim.select, "Builder"})
menu.main.p_name_1:depend({menu.main.select, "Main"})
menu.main.p_line_1:depend({menu.main.select, "Main"})
menu.main.p_name_2:depend({menu.main.select, "Main"})
menu.main.p_line_2:depend({menu.main.select, "Main"})
menu.main.list:depend({menu.main.select, "Main"})
menu.main.name:depend({menu.main.select, "Main"})
menu.main.load:depend({menu.main.select, "Main"})
menu.main.delete:depend({menu.main.select, "Main"})
menu.main.import:depend({menu.main.select, "Main"})
menu.main.export:depend({menu.main.select, "Main"})
menu.misc.ladder:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Other"})   
menu.misc.logs:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Visuals"})
menu.misc.logs_type:depend({menu.misc.logs, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Visuals"})
menu.misc.hit_color:depend({menu.misc.logs_type, "Console"}, {menu.misc.logs, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Visuals"})
menu.misc.miss_color:depend({menu.misc.logs_type, "Console"}, {menu.misc.logs, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Visuals"})
menu.misc.arrows:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Visuals"})
menu.misc.animationed:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Visuals"})
menu.misc.animation_fov:depend({menu.misc.animationed, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Visuals"})
menu.misc.animation_speed:depend({menu.misc.animationed, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Visuals"})
menu.misc.arrows_color:depend({menu.misc.arrows, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Visuals"}, {menu.misc.select, "Visuals"})
menu.misc.screen_indicators:depend({menu.main.select, "Miscellaneous"}, {menu.misc.select, "Visuals"}, {menu.misc.select, "Visuals"})
menu.misc.screen_color:depend({menu.misc.screen_indicators, true}, {menu.main.select, "Miscellaneous"}, {menu.misc.select, "Visuals"}, {menu.misc.select, "Visuals"})
-- # region depend end

local builder = {}

for i=1, #condition do
    builder[i] = {    
        enable = table.antiaim:checkbox('Override \v' .. condition[i]),
        pitch = table.antiaim:combobox("\v›\r Pitch", {"Disabled", "Default", "Up", "Down", "Minimal", "Random"}),
        yawbase = table.fakelag:combobox("\v›\r Yaw Base", {"At targets", "Local View"}),
        yawtype = table.antiaim:combobox("\v›\r Yaw", {"Switch", "Tickount"}),
        delay = table.antiaim:slider("\v›\r Tickount", 1, 14, 1, true),
        left = table.antiaim:slider("\v›\r Min. Offset", -180, 180, 0, true, "°"),
        right = table.antiaim:slider("\v›\r Max. Offset", -180, 180, 0, true, "°"),
        modifier = table.antiaim:combobox("\v›\r Modifier", {"Disabled", "Offset", "Center", "Skitter"}),
        degree = table.antiaim:slider("\n", -180, 180, 0, true,"°"),
        bodyyaw = table.antiaim:combobox("\v›\r Desync", {"Disabled", "Static", "Jitter", "Opposite"}),
        bodyslide = table.antiaim:slider("\n", -180, 180, 0, true, "°"),
        
        force_defensive = table.antiaim:checkbox("\v›\r Defensive \vAnti-aim"),
        def_pitch = table.antiaim:combobox("\v›\r Pitch", {"Disabled", "Default", "Up", "Down", "Minimal", "Customize"}),
        pitch_value = table.antiaim:slider("\v›\r Amount", -89, 89, 0, true, "°", 1),
        def_yaw = table.antiaim:combobox("\v›\r Yaw", {"Disabled", "Spin", "Sideways", "Switch", "Random", "Customize"}),
        def_yawvalue = table.antiaim:slider("\v›\r Speed", -180, 180, 0, true,"°", 1),
        def_left = table.antiaim:slider("\v›\r Min. Offset", -180, 180, 0, true, "°"),
        def_right = table.antiaim:slider("\v›\r Max. Offset", -180, 180, 0, true, "°"),
        def_yawslider = table.antiaim:slider("\v›\r Min", -180, 180, 0, true, "°", 1),
        def_yawslider2 = table.antiaim:slider("\v›\r Max", -180, 180, 0, true, "°", 1),
    }
end

for i=1, #condition do
    -- Request
    cond_check = {menu.antiaim.condition, function() return (i ~= 1) end}
    tab_cond = {menu.antiaim.condition, condition[i]}
    check_tab = {menu.main.select, "Anti-aim"}
    menut_tab = {menu.antiaim.select, "Builder"}
    delay = {builder[i].yawtype, "Tickount"}
    lrcheck = {builder[i].yawtype, "Switch" or builder[i].yawtype, "Tickount"}
    default = {builder[i].modifier, "Center" or builder[i].modifier, "Offset" or builder[i].modifier, "Skitter"}
    checks = {builder[i].bodyyaw, "Static", "Jitter"}
    
    custompitch = {builder[i].def_pitch, "Customize"}
    yawslid = {builder[i].def_yaw, "Customize"}
    yawslid2 = {builder[i].def_yaw, "Spin"}
    switch = {builder[i].def_yaw, "Switch"}
    defaa = {builder[i].force_defensive, function() if (i == 1 ) then return builder[i].force_defensive:get() else return builder[i].force_defensive:get() end end}
    defensive = {builder[i].force_defensive, function() if (i == 1) then return builder[i].force_defensive:get() else return builder[i].force_defensive:get() end end}
    cnd_en = {builder[i].enable, function() if (i == 1) then return true else return builder[i].enable:get() end end}
    
    --Default
    
    builder[i].enable:depend(cond_check, tab_cond,check_tab, menut_tab)
    builder[i].pitch:depend( tab_cond, cnd_en,check_tab, menut_tab)
    builder[i].yawbase:depend( tab_cond,cnd_en, check_tab, menut_tab)
    builder[i].yawtype:depend( tab_cond, cnd_en,check_tab, menut_tab)
    builder[i].modifier:depend(tab_cond, cnd_en, check_tab, menut_tab)
    builder[i].degree:depend(tab_cond, cnd_en,check_tab, menut_tab, default)
    builder[i].left:depend( tab_cond, cnd_en,check_tab, menut_tab, lrcheck)
    builder[i].right:depend( tab_cond, cnd_en,check_tab, menut_tab, lrcheck)
    builder[i].delay:depend( tab_cond, cnd_en,check_tab, menut_tab, delay)
    builder[i].bodyyaw:depend( tab_cond, cnd_en,check_tab, menut_tab)
    builder[i].bodyslide:depend(tab_cond, cnd_en, check_tab, menut_tab, checks)
    
    --#defensive
    
    builder[i].force_defensive:depend( tab_cond,check_tab, cnd_en, menut_tab)
    builder[i].pitch_value:depend(tab_cond,check_tab, cnd_en, menut_tab, defensive, defaa, custompitch)
    builder[i].def_yaw:depend(tab_cond,check_tab, cnd_en, menut_tab, defaa,defensive)
    builder[i].def_yawslider:depend(tab_cond,check_tab, cnd_en, menut_tab, defensive,defaa, yawslid)
    builder[i].def_yawslider2:depend(tab_cond,check_tab, cnd_en, menut_tab, defensive,defaa, yawslid)
    builder[i].def_pitch:depend(tab_cond,check_tab, cnd_en, menut_tab, defaa, defensive)
    builder[i].def_yawvalue:depend(tab_cond, check_tab, cnd_en, menut_tab, defaa, defensive, yawslid2)
    builder[i].def_left:depend(tab_cond, check_tab, cnd_en, menut_tab, defaa, defensive, switch)
    builder[i].def_right:depend(tab_cond, check_tab, cnd_en, menut_tab, defaa, defensive, switch)
end

local breaker = {
    defensive = 0,
    defensive_check = 0,
    cmd = 0,
    last_origin = nil,
    origin = nil,
    tp_dist = 0,
    tp_data = gram_create(0,3),
    mapname = globals.mapname()
}

local yaw_direction = 0
    local last_press_t_dir = 0

    local run_direction = function()
        ui.set(reference.freestand[1], menu.antiaim.take:get("Freestanding"))
        ui.set(reference.freestand[2], menu.antiaim.key_freestand:get() and 'Always on' or 'On hotkey')

        if yaw_direction ~= 0 then
            ui.set(reference.freestand[1], false)
        end

        if menu.antiaim.take:get("Manual Yaw") and menu.antiaim.key_right:get() and last_press_t_dir + 0.2 < globals.curtime() then
            yaw_direction = yaw_direction == 90 and 0 or 90
            last_press_t_dir = globals.curtime()
        elseif menu.antiaim.take:get("Manual Yaw") and menu.antiaim.key_left:get() and last_press_t_dir + 0.2 < globals.curtime() then
            yaw_direction = yaw_direction == -90 and 0 or -90
            last_press_t_dir = globals.curtime()
        elseif menu.antiaim.take:get("Manual Yaw") and menu.antiaim.key_forward:get() and last_press_t_dir + 0.2 < globals.curtime() then
            yaw_direction = yaw_direction == 180 and 0 or 180
            last_press_t_dir = globals.curtime()
        elseif last_press_t_dir > globals.curtime() then
            last_press_t_dir = globals.curtime()
        end
    end

antiknife = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

local id = 1 
function player_state(cmd)
    local lp = entity.get_local_player()
    if lp == nil then return end
    local vecvelocity = { entity.get_prop(lp, 'm_vecVelocity') }
    local flags = entity.get_prop(lp, 'm_fFlags')
    local velocity = math.sqrt(vecvelocity[1]^2+vecvelocity[2]^2)
    local groundcheck = bit.band(flags, 1) == 1
    local jumpcheck = bit.band(flags, 1) == 0 or cmd.in_jump == 1
    local ducked = entity.get_prop(lp, 'm_flDuckAmount') > 0.7
    local duckcheck = ducked or ui.get(reference.fakeduck)
    local manuals = yaw_direction == -90 or yaw_direction == 90
    local slowwalk_key = ui.get(reference.slow[1]) and ui.get(reference.slow[2])
    local lag = ui.get(reference.dt[1]) and not ui.get(reference.dt[2])

    if jumpcheck and duckcheck then return "Air Crouching"
    elseif jumpcheck then return "Air"
    elseif duckcheck and velocity > 10 then return "Crouch Moving"
    elseif duckcheck and velocity < 10 then return "Crouch"
    elseif groundcheck and slowwalk_key and velocity > 10 then return "Walking"
    elseif groundcheck and velocity > 5 then return "Running"
    elseif groundcheck and velocity < 5 then return "Standing"
    elseif lag then return "Fakelag"
    else return "Global" end
end

forrealtime = 0
function smoothJitter(switchyaw1, switchyaw2, switchingspeed)
    if globals.curtime() > forrealtime + 1 / (switchingspeed * 2) then
        finalyawgg = switchyaw1
        if globals.curtime() - forrealtime > 2 / (switchingspeed * 2) then
            forrealtime = globals.curtime()
        end
    else
        finalyawgg = switchyaw2
    end
    return finalyawgg
end

function desyncside()
    if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then
        return
    end
    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local side = bodyyaw > 0 and -1 or 1
    return side
end

client.set_event_callback("predict_command", function(cmd)
    if cmd.command_number == breaker.cmd then
        local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
        breaker.defensive = math.abs(tickbase - breaker.defensive_check)
        breaker.defensive_check = math.max(tickbase, breaker.defensive_check)
        breaker.cmd = 0
    end
end)

client.set_event_callback("run_command", function(cmd)
    breaker.cmd = cmd.command_number
    if cmd.chokedcommands == 0 then
        breaker.origin = vector(entity.get_origin(entity.get_local_player()))
        if breaker.last_origin ~= nil then
            breaker.tp_dist = (breaker.origin - breaker.last_origin):length2dsqr()
            gram_update(breaker.tp_data, breaker.tp_dist, true)
        end
        breaker.last_origin = breaker.origin
    end
end)

edge_direction = function()
    ui.set(reference.edgeyaw, ui.get(reference.fakeduck) and menu.antiaim.features:get("Edge on FD"))
end


function aa_setup(cmd)
    local lp = entity.get_local_player()
    local tp_amount = get_average(breaker.tp_data)/get_velocity(lp)*100 
    local is_defensive = (breaker.defensive > 1) and not (tp_amount >= 25 and breaker.defensive >= 13) and ui.get(reference.dt[1]) and ui.get(reference.dt[2])
    local threat = client.current_threat()
    local weapon = entity.get_player_weapon(lp)
    local lp_orig_x, lp_orig_y, lp_orig_z = entity.get_prop(lp, "m_vecOrigin")
    local flags = entity.get_prop(lp, 'm_fFlags')
    local jumpcheck = bit.band(flags, 1) == 0 or cmd.in_jump == 1
    local ducked = entity.get_prop(lp, 'm_flDuckAmount') > 0.7
    

    if lp == nil then return end
    
    if player_state(cmd) == "Air Crouching" and builder[8].enable:get() then id = 8
    elseif player_state(cmd) == "Fakelag" and builder[10].enable:get() then id = 9
    elseif player_state(cmd) == "Air" and builder[7].enable:get() then id = 7
    elseif player_state(cmd) == "Crouch Moving" and builder[6].enable:get() then id = 6
    elseif player_state(cmd) == "Crouch" and builder[5].enable:get() then id = 5
    elseif player_state(cmd) == "Walking" and builder[4].enable:get() then id = 4
    elseif player_state(cmd) == "Running" and builder[3].enable:get() then id = 3
    elseif player_state(cmd) == "Standing" and builder[2].enable:get() then id = 2
    else id = 1 end

    run_direction()
    edge_direction()

    local yaw_amount = 0
    local pitch_amount = 0
    local me = entity.get_local_player()
    if not entity.is_alive(me) then return end
    desync_type = entity.get_prop(me, "m_flPoseParameter", 11) * 120 - 60
    desync_side = desync_type > 0 and 1 or -1


    cmd.force_defensive = builder[id].force_defensive:get()

    ui.set(reference.fakelagenabled[1], true)
    ui.set(reference.fakelagamount[1], menu.fakelag.amount:get())
    ui.set(reference.fakelagvariance[1], menu.fakelag.variance:get())
    ui.set(reference.fakelaglimit[1], menu.fakelag.limit:get())

    local valuepitch = builder[id].pitch_value:get()

    if builder[id].force_defensive:get() and is_defensive then
        ui.set(reference.anti_aim[1], true)
        if builder[id].def_pitch:get() == "Disabled" then
            ui.set(reference.pitch[1], "Off")
        elseif builder[id].def_pitch:get() == "Default" then
            ui.set(reference.pitch[1], "Default")
        elseif builder[id].def_pitch:get() == "Up" then
            ui.set(reference.pitch[1], "Up")
        elseif builder[id].def_pitch:get() == "Down" then
            ui.set(reference.pitch[1], "Down")
        elseif builder[id].def_pitch:get() == "Minimal" then
            ui.set(reference.pitch[1], "Minimal") 
        elseif builder[id].def_pitch:get() == "Customize" then
            ui.set(reference.pitch[1], "Custom")
            ui.set(reference.pitch[2], valuepitch)
        end

        if builder[id].def_yaw:get() == "Disabled" then
            ui.set(reference.yaw[1], "Off")
            ui.set(reference.yaw[2], 0)
        elseif builder[id].def_yaw:get() == "Spin" then
            ui.set(reference.yaw[1], "Spin")
            ui.set(reference.yaw[2], builder[id].def_yawvalue:get())
        elseif builder[id].def_yaw:get() == "Side-Ways" then
            ui.set(reference.yaw[2], globals.tickcount() % 3 == 0 and client.random_int(-100, -90) or globals.tickcount() % 3 == 1 and 180 or globals.tickcount() % 3 == 2 and client.random_int(90, 100) or 0)          
        elseif builder[id].def_yaw:get() == "Switch" then
            ui.set(reference.yaw[2], desync_side == 1 and builder[id].def_left:get() or builder[id].def_right:get())              
        elseif builder[id].def_yaw:get() == "Random" then
            ui.set(reference.yaw[2], math.random(-180, 180))
        elseif builder[id].def_yaw:get() == "Customize" then
            ui.set(reference.yaw[1], "180")
            ui.set(reference.yaw[2], math.random(builder[id].def_yawslider:get(), builder[id].def_yawslider2:get()))
        end
    else
        ui.set(reference.anti_aim[1], true)
    local pitch_value = builder[id].pitch:get()
    local modifier_value = builder[id].modifier:get()
    local body_yaw_value = builder[id].bodyyaw:get()

    if pitch_value == "Disabled" then
        ui.set(reference.pitch[1], "Off")
    else
        ui.set(reference.pitch[1], pitch_value)
    end

    if modifier_value == "Disabled" then
        ui.set(reference.yawjitter[1], "Off")
    else
        ui.set(reference.yawjitter[1], modifier_value)
        ui.set(reference.yawjitter[2], builder[id].degree:get())
    end

    if body_yaw_value == "Disabled" then
        ui.set(reference.bodyyaw[1], "Off")
    else
        ui.set(reference.bodyyaw[1], body_yaw_value)
        ui.set(reference.bodyyaw[2], smoothJitter(builder[id].left:get(), builder[id].right:get(), builder[id].delay:get(), builder[id].bodyslide:get() + 1))
    end

        ui.set(reference.yawbase, builder[id].yawbase:get())
        if builder[id].yawtype:get() == "Switch" and desyncside() == -1 then 
            ui.set(reference.yaw[1], "180")
            ui.set(reference.yaw[2], builder[id].left:get()) 
        else
            ui.set(reference.yaw[1], "180") 
            ui.set(reference.yaw[2], builder[id].right:get()) 
        end
        if builder[id].yawtype:get() == "Tickount" then 
            ui.set(reference.yaw[1], "180")
            ui.set(reference.yaw[2], smoothJitter(builder[id].left:get(), builder[id].right:get(), builder[id].delay:get())) 
        end
    end

    local safe_enable = false

    anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    end
    function safe_func()
        ui.set(reference.yawjitter[1], "Off")
        ui.set(reference.yaw[1], '180')
        ui.set(reference.bodyyaw[1], "Static")
        ui.set(reference.bodyyaw[2], 1)
        ui.set(reference.yaw[2], 14)
        ui.set(reference.pitch[2], 89)
    end

    

    -- # region features / anti-aim
if menu.antiaim.features:get("Useless Function") then
    if menu.antiaim.useless:get("Spin on Warm-up") and entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 1 then
        ui.set(reference.yaw[1], "Spin")
        ui.set(reference.yaw[2], "10")
        ui.set(reference.yawjitter[1], "Off")
        ui.set(reference.yawjitter[2], "0")
        ui.set(reference.bodyyaw[1], "Off")
        ui.set(reference.bodyyaw[2], "0")
        ui.set(reference.pitch[1], "Off")
        ui.set(reference.pitch[2], math.random(0))
    elseif menu.antiaim.useless:get("Spin no Enemies") then
        local player_resource = entity.get_player_resource()

        if player_resource then
            local are_all_enemies_dead = true
            local enemy_found = false

            for i = 1, globals.maxplayers() do
                if entity.get_prop(player_resource, 'm_bConnected', i) == 1 then
                    if entity.is_enemy(i) then
                        enemy_found = true
                        if entity.is_alive(i) then
                            are_all_enemies_dead = false
                            break
                        end
                    end
                end
            end

            if not enemy_found or are_all_enemies_dead then
                ui.set(reference.yaw[1], "Spin")
                ui.set(reference.yaw[2], "10")
                ui.set(reference.yawjitter[1], "Off")
                ui.set(reference.yawjitter[2], "0")
                ui.set(reference.bodyyaw[1], "Off")
                ui.set(reference.bodyyaw[2], "0")
                ui.set(reference.pitch[1], "Off")
                ui.set(reference.pitch[2], math.random(0))
            end
        end
    end
end
-- # region features / anti-aim end


    if yaw_direction == 90 then
        ui.set(reference.pitch[1], "Minimal")
        ui.set(reference.yawbase, "Local view")
        ui.set(reference.yaw[1], "180")
        ui.set(reference.yaw[2], 90)
        ui.set(reference.yawjitter[1], "Offset")
        ui.set(reference.yawjitter[2], 0)
        ui.set(reference.bodyyaw[1], "Off")
        ui.set(reference.bodyyaw[2], 0)
        ui.set(reference.fs_body_yaw, false)
    end

    if yaw_direction == -90 then
        ui.set(reference.pitch[1], "Minimal")
        ui.set(reference.yawbase, "Local view")
        ui.set(reference.yaw[1], "180")
        ui.set(reference.yaw[2], -90)
        ui.set(reference.yawjitter[1], "Offset")
        ui.set(reference.yawjitter[2], 0)
        ui.set(reference.bodyyaw[1], "Off")
        ui.set(reference.bodyyaw[2], 0)
        ui.set(reference.fs_body_yaw, false)
    end




    if menu.antiaim.features:get("Edge On FD") then
        ui.set(reference.edgeyaw, ui.get(reference.fakeduck))
    end
    
    local lp = entity.get_local_player()
    local lp_weapon = entity.get_player_weapon(lp)
    local lp_orig_x, lp_orig_y, lp_orig_z = entity.get_prop(lp, "m_vecOrigin")
    local flags = entity.get_prop(lp, 'm_fFlags') or 0
    local jumpcheck = bit.band(flags, 1) == 0 or cmd.in_jump == 1
    local ducked = entity.get_prop(lp, 'm_flDuckAmount') > 0.7
    
    if menu.antiaim.features:get("Safe Function") and lp_weapon then
        local function check_safety(condition, classname)
            if condition and entity.get_classname(lp_weapon) == classname then
                safe_func()
            end
        end
    
        check_safety(jumpcheck and ducked, "CKnife")
        check_safety(jumpcheck and ducked, "CWeaponTaser")
    
        if menu.antiaim.safe:get("Heigh Distance") then
            local threat = client.current_threat()
            if threat then
                local threat_x, threat_y, threat_z = entity.get_prop(threat, "m_vecOrigin")
                if anti_knife_dist(lp_orig_x, lp_orig_y, lp_orig_z, threat_x, threat_y, threat_z) > 900 then
                    safe_func()
                end
            end
        end
    
        local states = {
            ["Standing"] = "Standing",
            ["Crouching"] = "Crouch",
            ["Air Crouching"] = "Air Crouching",
        }
    
        for key, state in pairs(states) do
            if menu.antiaim.safe:get(key) and player_state(cmd) == state then
                safe_func()
            end
        end
    end
    
    if menu.antiaim.features:get("Avoid Backstab") then
        local players = entity.get_players(true)
        local backstab_avoided = false
        for i = 1, #players do
            local enemy = players[i]
            if enemy then
                local enemy_orig_x, enemy_orig_y, enemy_orig_z = entity.get_prop(enemy, "m_vecOrigin")
                local distance_to = anti_knife_dist(lp_orig_x, lp_orig_y, lp_orig_z, enemy_orig_x, enemy_orig_y, enemy_orig_z)
                local weapon = entity.get_player_weapon(enemy)
                if weapon and entity.get_classname(weapon) == "CKnife" and distance_to <= 250 then
                    ui.set(reference.yaw[2], 180)
                    ui.set(reference.yawbase, "At targets")
                    builder[id].force_defensive:override(false)
                    backstab_avoided = true
                    break
                end
            end
        end
        if not backstab_avoided then
            builder[id].force_defensive:override()
        end
    end
end
      


-- # region builder end

-- # region hide group menu

function hide_original_menu(state)
    ui.set_visible(reference.enabled, state)
    ui.set_visible(reference.sw, state)
    ui.set_visible(reference.pitch[1], state)
    ui.set_visible(reference.pitch[2], state)
    ui.set_visible(reference.yawbase, state)
    ui.set_visible(reference.yaw[1], state)
    ui.set_visible(reference.yaw[2], state)
    ui.set_visible(reference.yawjitter[1], state)
    ui.set_visible(reference.roll[1], state)
    ui.set_visible(reference.yawjitter[2], state)
    ui.set_visible(reference.bodyyaw[1], state)
    ui.set_visible(reference.bodyyaw[2], state)
    ui.set_visible(reference.fsbodyyaw, state)
    ui.set_visible(reference.edgeyaw, state)
    ui.set_visible(reference.freestand[1], state)
    ui.set_visible(reference.freestand[2], state)
    ui.set_visible(reference.fkp, state)
    ui.set_visible(reference.osaaa, state)
    ui.set_visible(reference.lgm, state)
    ui.set_visible(reference.fke, state)
    ui.set_visible(reference.fkl, state)
    ui.set_visible(reference.fkv, state)
    ui.set_visible(reference.fk, state)
end

-- # region hide group menu end



screen_indicator = function(cmd)
    local anim = {main = motion.new('screen_indication_main', menu.misc.screen_indicators:get() and 255 or 0)}
    local accent_color = {menu.misc.screen_color:get_color()}
    local x, y = client.screen_size()
    local center = {x*0.5, y*0.5+25}
    local plocal = entity.get_local_player()
    if not plocal or not entity.is_alive(plocal) or anim.main < 0.1 then return end

    local binds = {
        {'dt', ui.get(reference.dt[1]) and ui.get(reference.dt[2])},
        {'hide', ui.get(reference.os[1]) and ui.get(reference.os[2])},
        {'safe', ui.get(reference.forcepoint)},
        {'body', ui.get(reference.forcebaim)},
        {'dmg', ui.get(reference.dmg[1]) and ui.get(reference.dmg[2]) and ui.get(reference.dmg[3])},
        {'fs', ui.get(reference.freeStand[1]) and ui.get(reference.freeStand[2])}
    }

    local scope_based = entity.get_prop(plocal, 'm_bIsScoped') ~= 0
    local add_y = 0

    anim.name = {alpha = motion.new('lua_name_alpha', menu.misc.screen_indicators:get() and 255 or 0)}
    anim.name.move = motion.new('binds_move_name', not scope_based and -renderer.measure_text(nil, 'meowhook')*0.5 or 16)
    anim.name.glow = motion.new('glow_name_alpha', 50 or 0)

    if anim.name.alpha > 1 then
        if anim.name.glow > 1 then
            renderer.rectangle(center[1] + anim.name.move, center[2] + 7, renderer.measure_text('b', 'meowhook') - 1, 0, 10, 0, {accent_color[1], accent_color[2], accent_color[3], anim.name.glow}, {accent_color[1], accent_color[2], accent_color[3], anim.name.glow})
        end
        renderer.text(center[1] - 1 + string.format('%.0f', anim.name.move), center[2], 255, 255, 255, anim.main, 'b', 0, utils.animate_text(globals.curtime()*2, 'meowhook', accent_color[1], accent_color[2], accent_color[3], anim.main, accent_color[1], accent_color[2], accent_color[3], 150*(anim.main/255)))
        add_y = add_y + string.format('%.0f', anim.name.alpha / 255 * 12)
    end

    local state = "hi"
    if id == 1 then
        state = "shared"
    elseif id == 2 then
        state = "standing"
    elseif id == 3 then
        state = "running"
    elseif id == 4 then
        state = "walking"
    elseif id == 5 then
        state = "crouching"
    elseif id == 6 then
        state = "crouch moving"
    elseif id == 7 then
        state = "aierobic"
    elseif id == 8 then
        state = "aierobic+"
    elseif id == 9 then
        state = "fakelag"
    end
    
    anim.state = {alpha = motion.new('state_alpha', menu.misc.screen_indicators:get() and 200 or 0)}
    anim.state.text = state
    anim.state.scoped_check = motion.new('scoped_check', not scope_based and 1 or 0) ~= 1
    anim.state.move = anim.state.scoped_check and string.format('%.0f', motion.new('binds_move_state', not scope_based and -renderer.measure_text(nil, anim.state.text)*0.5 or 15)) or -renderer.measure_text(nil, anim.state.text)*0.5
    
    if anim.state.alpha > 1 then
        renderer.text(center[1] + anim.state.move, center[2] + add_y, 255, 255, 255, anim.state.alpha, nil, 0, anim.state.text)
        add_y = add_y + string.format('%.0f', anim.state.alpha / 255 * 15)
    end

    for k, v in pairs(binds) do
        anim.binds = {alpha = motion.new('binds_alpha_'..v[1], menu.misc.screen_indicators:get() and v[2] and 255 or 0), move = motion.new('binds_move_'..v[1], not scope_based and -renderer.measure_text(nil, v[1])*0.5 or 15)}
        if anim.binds.alpha > 1 then
            renderer.text(center[1] + string.format('%.0f', anim.binds.move), center[2] + add_y, 255, 255, 255, anim.binds.alpha, nil, 0, v[1])
            add_y = add_y + string.format('%.0f', anim.binds.alpha / 255 * 12)
        end
    end
end

local scoped_space, arrows_alpha, arrows_direction  = 0
local screen_width, screen_height = client.screen_size()

local left = renderer.load_svg('<svg width="8" height="10" viewBox="0 0 8 10"><path fill="#fff" d="m0.384 5.802c-0.24286-0.19453-0.3842-0.48884-0.3842-0.8s0.14134-0.60547 0.3842-0.8l6.08-4c0.29513-0.22371 0.69277-0.25727 1.0212-0.086202 0.32846 0.17107 0.52889 0.51613 0.51477 0.8862l-1.92 3.96 1.92 4.04c0.01412 0.37007-0.18631 0.71513-0.51477 0.8862-0.32846 0.1711-0.7261 0.1375-1.0212-0.0862z"/></svg>', 8, 10)
local right = renderer.load_svg('<svg width="8" height="10" viewBox="0 0 8 10"><path fill="#fff" transform="rotate(180, 4, 5)" d="m0.384 5.802c-0.24286-0.19453-0.3842-0.48884-0.3842-0.8s0.14134-0.60547 0.3842-0.8l6.08-4c0.29513-0.22371 0.69277-0.25727 1.0212-0.086202 0.32846 0.17107 0.52889 0.51613 0.51477 0.8862l-1.92 3.96 1.92 4.04c0.01412 0.37007-0.18631 0.71513-0.51477 0.8862-0.32846 0.1711-0.7261 0.1375-1.0212-0.0862z"/></svg>', 8, 10)

local mouse, arrows_positions, min_distance, max_distance, screen_darkness_alpha = 
    {pressed = function(key) return client.key_state(key or 1) end}, 
    {left = {x = screen_width / 2 - 55, y = screen_height / 2}, right = {x = screen_width / 2 + 55, y = screen_height / 2}, is_dragging = {left = false, right = false}}, 
    0, 90, 0

function move_arrow(side, mouse_x)
    local delta_x = mouse_x - arrows_positions[side].x
    if side == "left" then
        arrows_positions.left.x = math.lerp(arrows_positions.left.x, math.max(screen_width / 2 - 55 - max_distance, math.min(arrows_positions.left.x + delta_x, screen_width / 2 - 55 - min_distance)), 8)
        arrows_positions.right.x = screen_width - arrows_positions.left.x
    else
        arrows_positions.right.x = math.lerp(arrows_positions.right.x, math.max(screen_width / 2 + 55 + min_distance, math.min(arrows_positions.right.x + delta_x, screen_width / 2 + 55 + max_distance)), 8)
        arrows_positions.left.x = screen_width - arrows_positions.right.x
    end
end

function arrows()
    local lp = entity.get_local_player()
    if not lp then return end

    local scoped, menu_open = entity.get_prop(lp, "m_bIsScoped") == 1, ui.is_menu_open()
    scoped_space = math.lerp(scoped_space or 0, scoped and 15 or 0, 8)

    local show_arrows = menu_open or yaw_direction == -90 or yaw_direction == 90
    arrows_alpha_left = math.lerp(arrows_alpha_left or 0, show_arrows and (yaw_direction == -90 and 255 or 70) or 0, 8)
    arrows_alpha_right = math.lerp(arrows_alpha_right or 0, show_arrows and (yaw_direction == 90 and 255 or 70) or 0, 8)

    local arrows_color = {menu.misc.arrows_color:get()}
    local mouse_x, mouse_y = ui.mouse_position()

    local hovering_left = mouse_x >= arrows_positions.left.x - 8 and mouse_x <= arrows_positions.left.x + 10 and mouse_y >= arrows_positions.left.y - 5 and mouse_y <= arrows_positions.left.y + 15
    local hovering_right = mouse_x >= arrows_positions.right.x - 5 and mouse_x <= arrows_positions.right.x + 13 and mouse_y >= arrows_positions.right.y - 5 and mouse_y <= arrows_positions.right.y + 15

    if mouse.pressed(1) then
        arrows_positions.is_dragging.left = hovering_left or arrows_positions.is_dragging.left
        arrows_positions.is_dragging.right = hovering_right or arrows_positions.is_dragging.right
    end

    if arrows_positions.is_dragging.left or arrows_positions.is_dragging.right then
        screen_darkness_alpha = math.lerp(screen_darkness_alpha or 0, 150, 4)
    else
        screen_darkness_alpha = math.lerp(screen_darkness_alpha or 0, 0, 4)
    end

    renderer.rectangle(0, 0, screen_width, screen_height, 0, 0, 0, screen_darkness_alpha)

    for side, pos in pairs({left = arrows_positions.left, right = arrows_positions.right}) do
        -- Плавная анимация для фона
        local show_background = menu_open and 128 or 0
        background_alpha = math.lerp(background_alpha or 0, show_background, 8)
        
        if menu_open or background_alpha > 0 then
            renderer.rounded_rectangle(pos.x - (side == "left" and 8 or 5), pos.y - 9, 18, 20, 50, 50, 50, background_alpha, 3)
        end
        
        renderer.texture( side == "left" and left or right, pos.x - (side == "left" and 3 or 0), pos.y, 8, 10, arrows_color[1], arrows_color[2], arrows_color[3], side == "left" and arrows_alpha_left or arrows_alpha_right, "f")
    end

    renderer.text(arrows_positions.left.x, arrows_positions.left.y - 0.8, 255, 255, 255, arrows_alpha_left, "cb", 0, "❬")
    renderer.text(arrows_positions.right.x + 4, arrows_positions.right.y - 0.8, 255, 255, 255, arrows_alpha_right, "cb", 0, "❭")

    if arrows_positions.is_dragging.left then
        move_arrow("left", mouse_x)
    elseif arrows_positions.is_dragging.right then
        move_arrow("right", mouse_x)
    end

    if mouse.pressed(2) and (hovering_left or hovering_right) then
        arrows_positions.left.x, arrows_positions.right.x = screen_width / 2 - 55, screen_width / 2 + 55
    end

    if not mouse.pressed(1) then
        arrows_positions.is_dragging.left, arrows_positions.is_dragging.right = false, false
    end
end


-- #region ragebot logs

local notify=(function()local b=vector;local c=function(d,b,c)return d+(b-d)*c end;local e=function()return b(client.screen_size())end;local f=function(d,...)local c={...}local c=_G.table.concat(c,"")return b(renderer.measure_text(d,c))end;local g={notifications={bottom={}},max={bottom=6}}g.__index=g;g.new_bottom=function(...)_G.table.insert(g.notifications.bottom,{started=false,instance=setmetatable({active=false,timeout=5,color={["r"]=menu_r,["g"]=menu_g,["b"]=menu_b,a=0},x=e().x/2,y=e().y,text=...},g)})end;-- # region function g
function g:handler()local d=0;local b=0;for d,b in pairs(g.notifications.bottom)do if not b.instance.active and b.started then _G.table.remove(g.notifications.bottom,d)end end;for d=1,#g.notifications.bottom do if g.notifications.bottom[d].instance.active then b=b+1 end end;for c,e in pairs(g.notifications.bottom)do if c>g.max.bottom then return end;if e.instance.active then e.instance:render_bottom(d,b)d=d+1 end;if not e.started then e.instance:start()e.started=true end end end;-- # region function g
function g:start()self.active=true;self.delay=globals.realtime()+self.timeout end;-- # region function g
function g:get_text()local d=""for b,b in pairs(self.text)do local c=f("",b[1])local c,e,f=255,255,255;if b[2]then c,e,f=menu_r,menu_g,menu_b end;d=d..("\a%02x%02x%02x%02x%s"):format(c,e,f,self.color.a,b[1])end;return d end;local h=(function()local d={}d.rec=function(d,b,c,e,f,g,h,i,j)j=math.min(d/2,b/2,j)renderer.rectangle(d,b+j,c,e-j*2,f,g,h,i)renderer.rectangle(d+j,b,c-j*2,j,f,g,h,i)renderer.rectangle(d+j,b+e-j,c-j*2,j,f,g,h,i)renderer.circle(d+j,b+j,f,g,h,i,j,180,.25)renderer.circle(d-j+c,b+j,f,g,h,i,j,90,.25)renderer.circle(d-j+c,b-j+e,f,g,h,i,j,0,.25)renderer.circle(d+j,b-j+e,f,g,h,i,j,-90,.25)end;d.rec_outline=function(d,b,c,e,f,g,h,i,j,k)j=math.min(c/2,e/2,j)if j==1 then renderer.rectangle(d,b,c,k,f,g,h,i)renderer.rectangle(d,b+e-k,c,k,f,g,h,i)else renderer.rectangle(d+j,b,c-j*2,k,f,g,h,i)renderer.rectangle(d+j,b+e-k,c-j*2,k,f,g,h,i)renderer.rectangle(d,b+j,k,e-j*2,f,g,h,i)renderer.rectangle(d+c-k,b+j,k,e-j*2,f,g,h,i)renderer.circle_outline(d+j,b+j,f,g,h,i,j,180,.25,k)renderer.circle_outline(d+j,b+e-j,f,g,h,i,j,90,.25,k)renderer.circle_outline(d+c-j,b+j,f,g,h,i,j,-90,.25,k)renderer.circle_outline(d+c-j,b+e-j,f,g,h,i,j,0,.25,k)end end;d.glow_module_notify=function(b,c,e,f,g,h,i,j,k,l,m,n,o,p,p)local q=1;local r=1;if p then d.rec(b,c,e,f,i,j,k,l,h)end;for i=0,g do local j=l/2*(i/g)^3;d.rec_outline(b+(i-g-r)*q,c+(i-g-r)*q,e-(i-g-r)*q*2,f-(i-g-r)*q*2,m,n,o,j/1.5,h+q*(g-i+r),q)end end;return d end)()-- # region function g
function g:render_bottom(g,i)local e=e()local j=6;local k="     "..self:get_text()local f=f("",k)local l=8;local m=5;local n=0+j+f.x;local n,o=n+m*2,12+10+1;local p,q=self.x-n/2,math.ceil(self.y-40+.4)local r=globals.frametime()if globals.realtime()<self.delay then self.y=c(self.y,e.y-45-(i-g)*o*1.4,r*7)self.color.a=c(self.color.a,255,r*2)else self.y=c(self.y,self.y-10,r*15)self.color.a=c(self.color.a,0,r*20)if self.color.a<=1 then self.active=false end end;local c,e,g,i=self.color.r,self.color.g,self.color.b,self.color.a;h.glow_module_notify(p,q,n,o,15,l,25,25,25,i,menu_r,menu_g,menu_b,i,true)local h=m;h=h+0+j;renderer.text(p+h,q+o/2-f.y/2,menu_r,menu_g,menu_b,i,"b",nil,"M")renderer.text(p+h,q+o/2-f.y/2,c,e,g,i,"",nil,k)end;client.set_event_callback("paint_ui",function()g:handler()end)return g end)()



    local screen = {client.screen_size()}
    local center = {screen[1]/2, screen[2]/2} 

    math.lerp = function(name, value, speed)
        return name + (value - name) * globals.absoluteframetime() * speed
    end

    renderer.log = function(text, icon, r, g, b)
        menu_r, menu_g, menu_b, menu_a = menu.misc.prefix_color:get()
        notify.new_bottom({ { text }, {" ", true} })
    end
    

    local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

-- # region function aim_hit
function aim_hit(e)
    if not menu.misc.logs:get() or not menu.misc.logs_type:get("Screen") then return end
    local group = hitgroup_names[e.hitgroup + 1] or '?'
    menu_r, menu_g, menu_b, menu_a = menu.misc.hit_color:get_color()
    notify.new_bottom({ { "Hit " }, {entity.get_player_name(e.target), true}, {" in the "}, {group, true}, {" for "}, {e.damage, true}, {"   "} })
end
client.set_event_callback('aim_hit', aim_hit)

-- # region function aim_miss

function aim_miss(e)
    if not menu.misc.logs:get() or not menu.misc.logs_type:get("Screen") then return end
    local group = hitgroup_names[e.hitgroup + 1] or '?'
    menu_r, menu_g, menu_b, menu_a = menu.misc.miss_color:get_color()
    notify.new_bottom({ { "Missed " }, {entity.get_player_name(e.target), true}, {" in the "}, {group, true}, {" due to "}, {e.reason, true}, {". hs: "}, {math.floor(e.hit_chance), true}, {"   "}})
end
client.set_event_callback('aim_miss', aim_miss)

local shot_logger = {}

prefer_safe_point = ui.reference('RAGE', 'Aimbot', 'Prefer safe point')
force_safe_point = ui.reference('RAGE', 'Aimbot', 'Force safe point')

shot_logger.add = function(...)
    args = { ... }
    len = #args
    for i = 1, len do
        arg = args[i]
        r, g, b = unpack(arg)

        msg = {}

        if #arg == 3 then
            _G.table.insert(msg, " ")
        else
            for i = 4, #arg do
                _G.table.insert(msg, arg[i])
            end
        end
        msg = _G.table.concat(msg)

        if len > i then
            msg = msg .. "\0"
        end

        client.color_log(r, g, b, msg)


    end
end

shot_logger.bullet_impacts = {}
shot_logger.bullet_impact = function(e)
    local tick, me, user = globals.tickcount(), entity.get_local_player(), client.userid_to_entindex(e.userid)
    if user ~= me then return end
    if #shot_logger.bullet_impacts > 150 then shot_logger.bullet_impacts = {} end
    shot_logger.bullet_impacts[#shot_logger.bullet_impacts+1] = {tick = tick, eye = vector(client.eye_position()), shot = vector(e.x, e.y, e.z)}
end

shot_logger.get_inaccuracy_tick = function(pre_data, tick)
    for _, impact in pairs(shot_logger.bullet_impacts) do
        if impact.tick == tick then
            local spread_angle = vector((pre_data.eye-pre_data.shot_pos):angles()-(pre_data.eye-impact.shot):angles()):length2d()
            return spread_angle
        end
    end
    return -1
end

shot_logger.get_safety = function(aim_data, target)
    if not aim_data.boosted then return -1 end
    local plist_safety, ui_safety = plist.get(target, 'Override safe point'), {ui.get(prefer_safe_point), ui.get(force_safe_point) or plist_safety == 'On'}
    if plist_safety == 'Off' or not (ui_safety[1] or ui_safety[2]) then return 0 end
    return ui_safety[2] and 2 or (ui_safety[1] and 1 or 0)
end

shot_logger.generate_flags = function(pre_data)
    return {pre_data.self_choke > 1 and 1 or 0, pre_data.velocity_modifier < 1.00 and 1 or 0, pre_data.flags.boosted and 1 or 0}
end


shot_logger.hitboxes = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
shot_logger.on_aim_fire = function(e)
	local p_ent = e.target
	local me = entity.get_local_player()

	shot_logger[e.id] = {
		original = e,
		dropped_packets = { },

		handle_time = globals.realtime(),
		self_choke = globals.chokedcommands(),

		flags = {
			boosted = e.boosted
		},

		feet_yaw = entity.get_prop(p_ent, 'm_flPoseParameter', 11)*120-60,
		correction = plist.get(p_ent, 'Correction active'),

		safety = shot_logger.get_safety(e, p_ent),
		shot_pos = vector(e.x, e.y, e.z),
		eye = vector(client.eye_position()),
		view = vector(client.camera_angles()),

		velocity_modifier = entity.get_prop(me, 'm_flVelocityModifier'),
		total_hits = entity.get_prop(me, 'm_totalHitsOnServer'),

		history = globals.tickcount() - e.tick
	}
end
shot_logger.on_aim_hit = function(e)
	if not menu.misc.logs:get() or not menu.misc.logs_type:get("Console") then
		return
	end

	if shot_logger[e.id] == nil then
		return 
	end

	local info = 
	{
		type = math.max(0, entity.get_prop(e.target, 'm_iHealth')) > 0,
		prefix = { menu.misc.hit_color:get_color() },
		hit = { menu.misc.hit_color:get_color() },
		name = entity.get_player_name(e.target),
		hitgroup = shot_logger.hitboxes[e.hitgroup + 1] or '?',
		flags = string.format('%s', _G.table.concat(shot_logger.generate_flags(shot_logger[e.id]))),
		aimed_hitgroup = shot_logger.hitboxes[shot_logger[e.id].original.hitgroup + 1] or '?',
		aimed_hitchance = string.format('%d%%', math.floor(shot_logger[e.id].original.hit_chance + 0.5)),
		hp = math.max(0, entity.get_prop(e.target, 'm_iHealth')),
		spread_angle = string.format('%.2f°', shot_logger.get_inaccuracy_tick(shot_logger[e.id], globals.tickcount())),
		correction = string.format('%d:%d°', shot_logger[e.id].correction and 1 or 0, (shot_logger[e.id].feet_yaw < 10 and shot_logger[e.id].feet_yaw > -10) and 0 or shot_logger[e.id].feet_yaw)
	}

	shot_logger.add({ info.prefix[1], info.prefix[2], info.prefix[3], 'meowhook'}, 
					{ 134, 134, 134, ' › ' }, 
					{ 200, 200, 200, info.type and 'Damaged ' or 'Killed ' }, 
					{ info.hit[1], info.hit[2], info.hit[3],  info.name }, 
					{ 200, 200, 200, ' in the ' }, 
					{ info.hit[1], info.hit[2], info.hit[3], info.hitgroup }, 
					{ 200, 200, 200, info.type and info.hitgroup ~= info.aimed_hitgroup and ' (' or ''},
					{ info.hit[1], info.hit[2], info.hit[3], info.type and (info.hitgroup ~= info.aimed_hitgroup and info.aimed_hitgroup) or '' },
					{ 200, 200, 200, info.type and info.hitgroup ~= info.aimed_hitgroup and ']' or ''},
					{ 200, 200, 200, info.type and ' for ' or '' },
					{ info.hit[1], info.hit[2], info.hit[3], info.type and e.damage or '' },
					{ 200, 200, 200, info.type and e.damage ~= shot_logger[e.id].original.damage and ' (' or ''},
					{ info.hit[1], info.hit[2], info.hit[3], info.type and (e.damage ~= shot_logger[e.id].original.damage and shot_logger[e.id].original.damage) or '' },
					{ 200, 200, 200, info.type and e.damage ~= shot_logger[e.id].original.damage and ')' or ''},
					{ 200, 200, 200, info.type and ' damage' or '' },
					{ 200, 200, 200, info.type and ' (' or '' }, { info.hit[1], info.hit[2], info.hit[3], info.type and info.hp or '' }, { 200, 200, 200, info.type and ' hp remaning)' or '' },
					{ 200, 200, 200, ' [hc: ' }, { info.hit[1], info.hit[2], info.hit[3], info.aimed_hitchance }, { 200, 200, 200, ' | safety: ' }, { info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].safety },
					{ 200, 200, 200, ' | bt: ' }, { info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].history },
					{ 200, 200, 200, ']' })
end



shot_logger.on_aim_miss = function(e)
    if not menu.misc.logs:get() or not menu.misc.logs_type:get("Console") then return end

    local me = entity.get_local_player()
    local info = {
        prefix = {menu.misc.miss_color:get_color()},
        hit = {menu.misc.miss_color:get_color()},
        name = entity.get_player_name(e.target),
        hitgroup = shot_logger.hitboxes[e.hitgroup + 1] or '?',
        flags = string.format('%s', _G.table.concat(shot_logger.generate_flags(shot_logger[e.id]))),
        aimed_hitgroup = shot_logger.hitboxes[shot_logger[e.id].original.hitgroup + 1] or '?',
        aimed_hitchance = string.format('%d%%', math.floor(shot_logger[e.id].original.hit_chance + 0.5)),
        hp = math.max(0, entity.get_prop(e.target, 'm_iHealth')),
        reason = e.reason == '?' and (shot_logger[e.id].total_hits ~= entity.get_prop(me, 'm_totalHitsOnServer') and 'damage rejection' or 'unknown') or e.reason,
        spread_angle = string.format('%.2f°', shot_logger.get_inaccuracy_tick(shot_logger[e.id], globals.tickcount())),
        correction = string.format('%d:%d°', shot_logger[e.id].correction and 1 or 0, (shot_logger[e.id].feet_yaw < 10 and shot_logger[e.id].feet_yaw > -10) and 0 or shot_logger[e.id].feet_yaw)
    }

    shot_logger.add(
        {info.prefix[1], info.prefix[2], info.prefix[3], 'meowhook'}, {134, 134, 134, ' › '}, 
        {200, 200, 200, 'Missed shot at '}, {info.hit[1], info.hit[2], info.hit[3], info.name}, 
        {200, 200, 200, ' in the '}, {info.hit[1], info.hit[2], info.hit[3], info.hitgroup}, 
        {200, 200, 200, ' due to '}, {info.hit[1], info.hit[2], info.hit[3], info.reason},
        {200, 200, 200, ' [hc: '}, {info.hit[1], info.hit[2], info.hit[3], info.aimed_hitchance}, 
        {200, 200, 200, ' | safety: '}, {info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].safety},
        {200, 200, 200, ' | bt: '}, {info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].history},
        {200, 200, 200, ']'}
    )
end


-- # region ragebot logs end

local isOs, isFd, isDt = ui.get(reference.os[1]) and ui.get(reference.os[2]), ui.get(reference.fakeDuck), ui.get(reference.dt[1]) and ui.get(reference.dt[2])
local hsSaved, hsValue = false, 0

if menu.misc.hideshots:get() then
    if isOs and not isDt and not isFd then
        if not hsSaved then hsValue, hsSaved = ui.get(reference.fakeLag[1]), true end
        ui.set(reference.fakeLag[1], 1)
    elseif hsSaved then
        ui.set(reference.fakeLag[1], hsValue)
        hsSaved = false
    end
end

-- # region fast ladder

function hitchance_override(cmd)
    local hitchance_override = menu.misc.hitchance_override:get()
    local hitchance_hotkey = menu.misc.hitchance_override_hotkey:get()

    local local_player = entity.get_local_player()
    if not local_player then return end

    local weapon_entity = entity.get_player_weapon(local_player)
    if not weapon_entity then return end

    local my_weapon = entity.get_classname(weapon_entity)

    if hitchance_override and hitchance_hotkey then
        local new_hitchance = nil

        if my_weapon == "CWeaponAWP" then
            new_hitchance = menu.misc.hitchance_override_awp:get()
        elseif my_weapon == "CWeaponSSG08" then
            new_hitchance = menu.misc.hitchance_override_ssg:get()
        elseif my_weapon == "CWeaponRevolver" then
            new_hitchance = menu.misc.hitchance_override_r8:get()
        elseif my_weapon == "CWeaponSCAR20" then
            new_hitchance = menu.misc.hitchance_override_scar:get()
        elseif my_weapon == "CWeaponG3SG1" then
            new_hitchance = menu.misc.hitchance_override_g3sg1:get()
        elseif my_weapon == "CWeaponGlock" then
            new_hitchance = menu.misc.hitchance_override_glock:get()
        elseif my_weapon == "CWeaponUSP" then
            new_hitchance = menu.misc.hitchance_override_usp:get()
        end

        if new_hitchance and new_hitchance > 0 then
            reference.hit_chance:override(new_hitchance)
        else
            reference.hit_chance:override() -- Сбрасываем значение, если не установлено или <= 0
        end
    else
        reference.hit_chance:override() -- Сбрасываем, если функция или хоткей отключены
    end
end

function airstop(cmd)
    local lp = entity.get_local_player()
    local ticks = 0
    if not lp or not entity.is_alive(lp) then return end

    local current_hitchance = menu.misc.jump_hitchance:get()
    local flags = entity.get_prop(lp, "m_fFlags")
    local FL_ONGROUND = 1

    if menu.misc.jump_scout:get() and menu.misc.jump_scout_hotkey:get() and menu.misc.jump_select:get("Hitchance") and bit.band(flags, FL_ONGROUND) == 0 then
        if previous_hitchance == nil then
            previous_hitchance = reference.hit_chance:get()
        end
        reference.hit_chance:override(current_hitchance)
    else
        if previous_hitchance ~= nil then
            reference.hit_chance:override(current_hitchance)
            previous_hitchance = nil 
        end
    end

    local target = entity.get_players(true)
    for i = 1, #target do
        if target == nil then
            return
        end 

        lp_orig_x, lp_orig_y, lp_orig_z = entity.get_prop(lp, "m_vecOrigin")
        enemy_orig_x, enemy_orig_y, enemy_orig_z = entity.get_prop(target[i], "m_vecOrigin")

        local distance = anti_knife_dist(lp_orig_x, lp_orig_y, lp_orig_z, enemy_orig_x, enemy_orig_y, enemy_orig_z)

        if distance and menu.misc.jump_select:get("Distance") and menu.misc.jump_distance:get() and menu.misc.jump_scout:get() and menu.misc.jump_scout_hotkey:get() then
            if bit.band(flags, FL_ONGROUND) == 0 then
                if cmd.quick_stop then
                    if (globals.tickcount() - ticks) > 3 then
                        cmd.in_speed = 1
                    end
                else
                    ticks = globals.tickcount()
                end
            end
        end
    end
end


local ref = {
    aimbot = ui.reference('RAGE', 'Aimbot', 'Enabled'),
    doubletap = { main = { ui.reference('RAGE', 'Aimbot', 'Double tap') }, fakelag_limit = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit') }
}

local local_player, callback_reg, dt_charged = nil, false, false

function check_charge()
    local shift = math.floor(entity.get_prop(local_player, 'm_nTickBase') - globals.tickcount() - 3 - toticks(client.latency()) * .5 + .5 * (client.latency() * 10))
    dt_charged = shift <= -14 + (ui.get(ref.doubletap.fakelag_limit) - 1) + 3
end

client.set_event_callback('setup_command', function()
    if not ui.get(ref.doubletap.main[2]) or not ui.get(ref.doubletap.main[1]) or not menu.misc.charge:get() then
        ui.set(ref.aimbot, true)
        if callback_reg then
            client.unset_event_callback('run_command', check_charge)
            callback_reg = false
        end
        return
    end

    if not callback_reg then
        local_player = entity.get_local_player()
        client.set_event_callback('run_command', check_charge)
        callback_reg = true
    end

    local threat = client.current_threat()
    ui.set(ref.aimbot, (dt_charged or not threat or bit.band(entity.get_prop(local_player, 'm_fFlags'), 1) ~= 0 or bit.band(entity.get_esp_data(threat).flags, bit.lshift(1, 11)) ~= 2048))
end)



function aspectratio(value)
    if value then
        cvar.r_aspectratio:set_float(value)
    end
end 

function fast_ladder(cmd)
    if not menu.misc.ladder:get() then return end
    local plocal = entity.get_local_player()
    if not plocal then return end

    local pitch = client.camera_angles()
    if entity.get_prop(plocal, 'm_MoveType') == 9 then
        cmd.yaw = math.floor(cmd.yaw + 0.5)
        cmd.roll = 0

        if not menu.misc.ladder:get() and cmd.forwardmove > 0 and pitch < 45 then
            cmd.pitch, cmd.in_moveleft, cmd.in_moveright, cmd.in_forward, cmd.in_back = 89, 0, 1, 0, 1
            if cmd.sidemove == 0 then cmd.yaw = cmd.yaw + 90 end
            if cmd.sidemove < 0 then cmd.yaw = cmd.yaw + 150 end
            if cmd.sidemove > 0 then cmd.yaw = cmd.yaw + 30 end
        end

        if not menu.misc.ladder:get() and cmd.forwardmove < 0 then
            cmd.pitch, cmd.in_moveleft, cmd.in_moveright, cmd.in_forward, cmd.in_back = 89, 1, 0, 1, 0
            if cmd.sidemove == 0 then cmd.yaw = cmd.yaw + 90 end
            if cmd.sidemove > 0 then cmd.yaw = cmd.yaw + 150 end
            if cmd.sidemove < 0 then cmd.yaw = cmd.yaw + 30 end
        end
    end
end


local x, y = client.screen_size()
function mindmg()
    if (menu.misc.mindmg and menu.misc.mindmg:get()) then
		if ui.get(reference.minimum_damage_override[1]) and ui.get(reference.minimum_damage_override[2]) and ui.get(reference.minimum_damage_override[3]) then
			renderer.text(x*0.5 + 2, y*0.5 - 14, 255, 255, 255, 255, nil, 0, tostring(ui.get(reference.minimum_damage_override[3])))
		end
	end
end

local ws_clantag = {"", "m", "me", "meo", "meow", "meowh", "meowho", "meowhoo", "meowhook.", "meowhook.g", "meowhook.gs", "meowhook.gs", "meowhook.g", "meowhook.", "meowhoo", "meowho", "meowh", "meow", "meo", "me", "m", ""}
local iter, wstime, clantag_direction = 1, 0, 1

function rotate_string() return ws_clantag[iter] end

function clantag_en()
    ui.set(reference.clantag, false)
    if not menu.misc.clantag:get() then client.set_clan_tag("") return end
    local ct = globals.curtime()
    if wstime + 0.3 < ct then
        local current_clantag = rotate_string()
        if clantag_direction == 1 then
            iter = math.min(iter + 1, #ws_clantag)
            client.set_clan_tag(current_clantag)
            if iter == #ws_clantag then clantag_direction = -1 end
        elseif clantag_direction == -1 then
            client.set_clan_tag(current_clantag:sub(1, #current_clantag - 1))
            if #current_clantag == 0 then clantag_direction, iter = 1, 1 end
        end
        wstime = ct
    elseif wstime > ct then wstime = ct end
end


-- Массив с оружиями и их классами
function force_body_aim_logic()
    if not menu.misc.force:get() then
        local players = entity.get_players(true)
        for _, player in ipairs(players) do
            plist.set(player, "Override prefer body aim", "-")
            plist.set(player, "Override safe point", "-")
        end
        return
    end


    local local_player = entity.get_local_player()
    local weapon_entity = entity.get_player_weapon(local_player)
    local my_weapon = entity.get_classname(weapon_entity)

    if not my_weapon then return end

    local players = entity.get_players(true)
    for _, player in ipairs(players) do
        if not entity.is_alive(player) then
            plist.set(player, "Override prefer body aim", "-")
            plist.set(player, "Override safe point", "-")
            return
        end

        local target_health = entity.get_prop(player, "m_iHealth")
        if not target_health or target_health <= 0 then
            plist.set(player, "Override prefer body aim", "-")
            plist.set(player, "Override safe point", "-")
            return
        end

        local baim_slider = nil
        local safe_slider = nil

        if my_weapon == "CWeaponAWP" then
            baim_slider = menu.misc.baim_slider_awp:get()
            safe_slider = menu.misc.safe_slider_awp:get()
        elseif my_weapon == "CWeaponSSG08" then
            baim_slider = menu.misc.baim_slider_ssg:get()
            safe_slider = menu.misc.safe_slider_ssg:get()
        elseif my_weapon == "CWeaponSCAR20" then
            baim_slider = menu.misc.baim_slider_scar:get()
            safe_slider = menu.misc.safe_slider_scar:get()
        elseif my_weapon == "CWeaponG3SG1" then
            baim_slider = menu.misc.baim_slider_g3sg1:get()
            safe_slider = menu.misc.safe_slider_g3sg1:get()
        elseif my_weapon == "CDEagle" then
            baim_slider = menu.misc.baim_slider_deagle:get()
            safe_slider = menu.misc.safe_slider_deagle:get()
        elseif my_weapon == "CWeaponGlock" then
            baim_slider = menu.misc.baim_slider_glock:get()
            safe_slider = menu.misc.safe_slider_glock:get()
        elseif my_weapon == "CWeaponHKP2000" then
            baim_slider = menu.misc.baim_slider_usp:get()
            safe_slider = menu.misc.safe_slider_usp:get()
        elseif my_weapon == "CWeaponFiveSeven" then
            baim_slider = menu.misc.baim_slider_fiveseven:get()
            safe_slider = menu.misc.safe_slider_fiveseven:get()
        elseif my_weapon == "CWeaponTec9" then
            baim_slider = menu.misc.baim_slider_tec9:get()
            safe_slider = menu.misc.safe_slider_tec9:get()
        end

        if baim_slider and baim_slider > 0 then
            if target_health < baim_slider then
                plist.set(player, "Override prefer body aim", "Force")
            else
                plist.set(player, "Override prefer body aim", "-")
            end
        else
            plist.set(player, "Override prefer body aim", "-")
        end

        if safe_slider and safe_slider > 0 then
            if target_health < safe_slider then
                plist.set(player, "Override safe point", "On")
            else
                plist.set(player, "Override safe point", "-")
            end
        else
            plist.set(player, "Override safe point", "-")
        end
    end
end




function table_contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

client.set_event_callback("run_command", force_body_aim_logic)

client.register_esp_flag("BAIM", 255, 100, 100, function(player)
    if not menu.misc.force then return false end
    return plist.get(player, "Override prefer body aim") == "Force"
end)

client.register_esp_flag("SAFE", 100, 100, 255, function(player)
    if not menu.misc.force then return false end
    return plist.get(player, "Override safe point") == "On"
end)


function anim_breaker()
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return end

    local self_index, self_anim_state = c_entity.new(lp), c_entity.new(lp):get_anim_state()
    if not self_anim_state then return end

    local self_anim_overlay = self_index:get_anim_overlay(12)
    if not self_anim_overlay then return end

    if math.abs(entity.get_prop(lp, "m_vecVelocity[0]") or 0) >= 3 then self_anim_overlay.weight = 1 end

    local gm, am = menu.misc.animation_ground:get(), menu.misc.animation_air:get()
    if gm == "Static" then
        entity.set_prop(lp, "m_flPoseParameter", 1, 0)
        ui.set(reference.lgm, "Always slide")
    elseif gm == "Jitter" then
        entity.set_prop(lp, "m_flPoseParameter", (globals.tickcount() % 4 > 1) and menu.misc.animation_value:get() / 10 or 0, 0)
    else
        entity.set_prop(lp, "m_flPoseParameter", math.random(menu.misc.animation_value:get(), 10) / 10, 0)
    end

    if am == "Static" then
        entity.set_prop(lp, "m_flPoseParameter", 1, 6)
    elseif am == "Randomize" then
        entity.set_prop(lp, "m_flPoseParameter", math.random(0, 10) / 10, 6)
    end
end

-- # fast ladder end

local phrases_death = {
    "че такая мразь меня потушила",
    "ублюдок те ж повезло",
    "ссанина ты че сделала",
    "пошли слетаем 5v5 на 500$",
    "дискорд мне опракинь пидрила",
    "живитное ебливое твоя попытка удалась",
    "ты осел ебаный такому повезло",
    "хач ебаный ну и попал ты в меня",
}

local phrases_kill = {
    "ебанутый сынок шалавы ты че там возомнил блять тупица ты ебанная безмозглая",
    "пидорас хуёвый",
    "я тут тебя кастрирую чисто щенка ебанного",
    "на шампур тебя садил",
    "пидорас",
    "я мать твою ебал",
    "бездарьная ты нахуй прошмандовка ебанная",
    "слабохарактерная ты шалавенция максимально убогая и тупая",
    "ливни уже а то нам с котиками стыдно на тебя бедного смотреть",
    "вагинальная пробка ты че тут забыла",
    "твое место в очке пидарас",
    "становись на колени, будем тебя ебать",
    "ты ряльно думал то что то ты никчемное существо кому-то нужно?",
    "АХХАХАХАХАХАХА ТАК СМЕШНО ПОМЕРЛА МРАЗЬ",
    "Я ТЯ СБИЛ НА СВОЕЙ МАЛЫХЕ",
    "укатилась чурка на инвалидной коляске",
    "пидрила любое твое слово мне в хуяку",
    "хотя ты никчемная тварь, которая облизывает мои сочные яйки",
    "не пытайся победить короля, тупая гнида",
    "тебе до меня как муровью на гору",
    "тьфу пидрила ты такая мелочная дешевле моих трусов"
}

local used_phrases_kill = {}
local used_phrases_death = {}

local userid_to_entindex, get_local_player, is_enemy, console_cmd = client.userid_to_entindex, entity.get_local_player, entity.is_enemy, client.exec

if not _G.table.includes then
    function _G.table.includes(tbl, val)
        for _, v in ipairs(tbl) do
            if v == val then
                return true
            end
        end
        return false
    end
end

function get_random_phrase(phrases, used_phrases)
    if #used_phrases >= #phrases then
        used_phrases = {}
    end

    local available_phrases = {}
    for _, phrase in ipairs(phrases) do
        if not _G.table.includes(used_phrases, phrase) then
            _G.table.insert(available_phrases, phrase)
        end
    end

    local selected_phrase = available_phrases[math.random(1, #available_phrases)]
    _G.table.insert(used_phrases, selected_phrase)
    return selected_phrase, used_phrases
end

function send_phrases(phrases, used_phrases, mode)
    local phrase_1, updated_phrases = get_random_phrase(phrases, used_phrases)
    local phrase_2, updated_phrases_2 = get_random_phrase(phrases, updated_phrases)

    if mode then
        client.delay_call(0.5, function() console_cmd("say 1") end)
        client.delay_call(2.5, function() console_cmd("say " .. phrase_1) end)
        client.delay_call(3.2, function() console_cmd("say " .. phrase_2) end)
    else
        client.delay_call(1, function() console_cmd("say " .. phrase_1) end)
        client.delay_call(2, function() console_cmd("say " .. phrase_2) end)
    end

    return updated_phrases_2
end

function on_player_death(e)
    if not menu.misc.trashtalk:get() then return end
    local victim_entindex = userid_to_entindex(e.userid)
    local attacker_entindex = userid_to_entindex(e.attacker)

    local mode = menu.misc.trashtalk_select:get("1 MODE")

    if victim_entindex == get_local_player() then
        if menu.misc.trashtalk_select:get("Death") then
            used_phrases_death = send_phrases(phrases_death, used_phrases_death, mode)
        end
    elseif attacker_entindex == get_local_player() and is_enemy(victim_entindex) then
        if menu.misc.trashtalk_select:get("Kill") then
            used_phrases_kill = send_phrases(phrases_kill, used_phrases_kill, mode)
        end
    end
end


refs = {
    fov = pui.reference('misc', 'miscellaneous', 'override fov')
}

local zoom = 0

function smooth(a, b, s) return a + (b - a) * s end

client.set_event_callback("override_view", function(v)
    local d_fov = refs.fov:get()

    if not menu.misc.animationed:get() then
        zoom = smooth(zoom, d_fov, 0.05)
        v.fov = zoom
        return
    end


    local animation_speed = menu.misc.animation_speed:get() / 1000 
    local clamped_speed = math.max(0.01, math.min(0.03, animation_speed)) 

    local me = entity.get_local_player()
    if not me or not entity.is_alive(me) then return end

    local w = entity.get_player_weapon(me)
    if not w then return end

    local scoped = entity.get_prop(me, "m_bIsScoped") == 1
    if not scoped then
        zoom = smooth(zoom, d_fov, clamped_speed)
        v.fov = zoom
        return
    end

    local zoom_offset = menu.misc.animation_fov:get() or 0
    local zoom_level = entity.get_prop(w, "m_zoomLevel") or 0
    local target_fov = d_fov - zoom_offset - (zoom_level == 2 and 45 or 30)

    target_fov = math.max(30, math.min(200, target_fov))
    zoom = smooth(zoom, target_fov, clamped_speed)
    v.fov = zoom
end)





-- # region animation zoom


menu.misc.logs:set_callback(function ()
    if not menu.misc.logs_type:get("Console") then
        client.exec("cam_collision 0")
    else
        client.exec("cam_collision 1")
    end
    if not menu.misc.logs_type:get("Console") then
        cvar.developer:set_int(0)
        cvar.con_filter_enable:set_int(1)
        cvar.con_filter_text:set_string("IrWL5106TZZKNFPz4P4Gl3pSN?J370f5hi373ZjPg%VOVh6lN")
        client.exec("con_filter_enable 1")
    else
        cvar.con_filter_enable:set_int(0)
        cvar.con_filter_text:set_string("")
        client.exec("con_filter_enable 0")
    end
end)

client.set_event_callback("player_death", on_player_death)

-- # region prediction

local interp_values = {
    [1] = 0.018,
    [2] = 0.026, 
    [3] = 0.031 
}

function configure_client_interp()
    if not menu.misc.predicted:get() then
        cvar.cl_interp:set_float(0.001)
        return
    end

    local mode_selected = menu.misc.tab:get()
    local interp_value = interp_values[mode_selected]

    if interp_value then
        cvar.cl_interp:set_float(interp_value)
    end

    cvar.cl_interp_ratio:set_float(1)
    cvar.cl_interpolate:set_int(1)
end

function time_to_ticks(time)
    return math.floor(time / globals.tickinterval())
end

function ticks_to_time(ticks)
    return ticks * globals.tickinterval()
end

function calculate_lerp()
    local interp = cvar.cl_interp:get_float()
    local interp_ratio = cvar.cl_interp_ratio:get_float()
    return math.max(interp, interp_ratio * globals.tickinterval())
end

function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function compensate_lag(cmd)
    local lerp = calculate_lerp()
    local target_tick = globals.tickcount() - time_to_ticks(lerp)
    local correct_time = clamp(client.real_latency() + lerp, 0, cvar.sv_maxunlag:get_float())

    if math.abs(correct_time - ticks_to_time(globals.tickcount() - target_tick)) > 0.2 then
        target_tick = globals.tickcount() - time_to_ticks(correct_time)
    end

    local lerp_remainder = math.fmod(client.real_latency(), globals.tickinterval())
    local real_target_time = ticks_to_time(target_tick)

    if lerp_remainder > 0 then
        real_target_time = real_target_time + globals.tickinterval() - lerp_remainder
    end

    local target_ticks = math.floor(real_target_time / globals.tickinterval())
    local tick_count = globals.tickcount() + target_ticks 
end


-- # region prediction end

-- # region config system

aa_package = pui.setup(builder)
aa_config = aa_package:save()
package = pui.setup(menu)
config = package:save()

local config_system, protected, presets = {}, {}, {}

config_system.add = function(...)
    args = { ... }
    len = #args
    for i = 1, len do
        arg = args[i]
        r, g, b = unpack(arg)

        msg = {}

        if #arg == 3 then
            _G.table.insert(msg, " ")
        else
            for i = 4, #arg do
                _G.table.insert(msg, arg[i])
            end
        end
        msg = _G.table.concat(msg)

        if len > i then
            msg = msg .. "\0"
        end

        client.color_log(r, g, b, msg)

    end
end

protected.database = {
	configs = ':meowhook::configs:'
}

config_system.get = function(name)
    local database = database.read(protected.database.configs) or {}

    for i, v in pairs(database) do
        if v.name == name then
            return {
                config = v.config,
				config2 = v.config2,
                index = i
            }
        end
    end

    for i, v in pairs(presets) do
        if v.name == name then
            return {
                config = v.config,
				config2 = v.config2,
                index = i
            }
        end
    end

    return false
end

config_system.save = function(name)
    local db = database.read(protected.database.configs) or {}
    local config = {}

    if name:match('[^%w]') ~= nil then
        return
    end

	local config = base64.encode(json.stringify(package:save()))
	local config2 = base64.encode(json.stringify(aa_package:save()))

	local cfg = config_system.get(name)

    if not cfg then
        _G.table.insert(db, { name = name, config = config, config2 = config2 })
    else
		db[cfg.index].config = config
        db[cfg.index].config2 = config2
    end

    database.write(protected.database.configs, db)
end

config_system.delete = function(name)
    local db = database.read(protected.database.configs) or {}

    for i, v in pairs(db) do
        if v.name == name then
            _G.table.remove(db, i)
            break
        end
    end

    for i, v in pairs(presets) do
        if v.name == name then
            return false
        end
    end

    database.write(protected.database.configs, db)
end

config_system.config_list = function()
    local database = database.read(protected.database.configs) or {}
    local config = {}

    for i, v in pairs(presets) do
        _G._G.table.insert(config, v.name)
    end

    for i, v in pairs(database) do
        _G._G.table.insert(config, v.name)
    end

    return config
end



config_system.load_settings = function(e, e2)
	package:load(e)
	aa_package:load(e2)
end

config_system.import_settings = function()
    local frombuffer = clipboard.get()
	local config = json.parse(base64.decode(frombuffer))
    config_system.load_settings(config.config, config.config2)
end

config_system.export_settings = function(name)
    local config = { config = package:save(), config2 = aa_package:save() }
    local toExport = base64.encode(json.stringify(config))
    clipboard.set(toExport)
end

config_system.load = function(name)
    local fromDB = config_system.get(name)
    config_system.load_settings(json.parse(base64.decode(fromDB.config)), json.parse(base64.decode(fromDB.config2)))
end

menu.main.list:set_callback(function(value)
    if value == nil then 
        return 
    end
    local name = ''
    
    local configs = config_system.config_list()
    if configs == nil then 
        return 
    end

    name = configs[value:get() + 1] or '23'
    menu.main.name:set(name)
end)

menu.main.load:set_callback(function()
	local name = menu.main.name:get()
    if name == '' then return end
    client.exec("Play ".. "buttons/button9")

    local s, p = pcall(config_system.load, name)

    if s then
        name = name:gsub('*', '')
        config_system.add(
            { 255, 186, 208, 'meowhook' },
            { 255, 255, 255, ' › ' },
            { 255, 255, 255, 'Configuration ' },
            { 255, 186, 208, name },
            { 255, 255, 255, ' has been loaded' }
        )
    else
        config_system.add(
            { 255, 186, 208, 'meowhook' },
            { 255, 255, 255, ' › ' },
            { 255, 255, 255, 'Failed to load ' },
            { 255, 186, 208, name },
            { 255, 255, 255, '' }
        )
    end        
end)

menu.main.save:set_callback(function()			
	local name = menu.main.name:get()
	if name == '' then return end

    client.exec("Play ".. "buttons/button9")

	for i, v in pairs(presets) do
		if v.name == name:gsub('*', '') then
			print("You can't save built-in preset")
			return
		end
	end

	if name:match('[^%w]') ~= nil then
        config_system.add(
            { 255, 186, 208, 'meowhook' },
            { 255, 255, 255, ' › ' },
            { 255, 255, 255, 'Failed to save ' },
            { 255, 186, 208, name },
            { 255, 255, 255, ' has been loaded' }
        )
		return
	end

	local protected = function()
		config_system.save(name)
		menu.main.list:update(config_system.config_list())
	end

    if pcall(protected) then
        config_system.add(
            { 255, 186, 208, 'meowhook' },
            { 255, 255, 255, ' › ' },
            { 255, 255, 255, 'Configuration ' },
            { 255, 186, 208, name },
            { 255, 255, 255, ' has been successfully saved' }
        )
    else
        config_system.add(
            { 255, 186, 208, 'meowhook' },
            { 255, 255, 255, ' › ' },
            { 255, 255, 255, 'Failed to save ' },
            { 255, 186, 208, name }
        )
    end    
end)

menu.main.delete:set_callback(function()
    local name = menu.main.name:get()
    if name == '' then return end

    client.exec("Play ".. "buttons/button9")

    if config_system.delete(name) == false then
        print('Failed to delete ' .. name)
        menu.main.list:update(config_system.config_list())
        return
    end

    for i, v in pairs(presets) do
        if v.name == name:gsub('*', '') then
            print('You can`t delete built-in preset ' .. name:gsub('*', ''))
            return
        end
    end

    config_system.delete(name)

    menu.main.list:update(config_system.config_list())
    menu.main.list:set((#presets) or '')
    menu.main.name:set(#database.read(protected.database.configs) == 0 and "" or config_system.config_list()[#presets])
    config_system.add(
        { 255, 186, 208, 'meowhook' },
        { 255, 255, 255, ' › ' },
        { 255, 255, 255, 'Configuration ' },
        { 255, 186, 208, name },
        { 255, 255, 255, ' has been successfully delete' }
    )
end)

menu.main.import:set_callback(function()
    local name = menu.main.name:get()
    if name == '' then return end
	local protected = function()
        config_system.import_settings()
    end

    client.exec("Play ".. "buttons/button9")

    if pcall(protected) then
        config_system.add(
            { 255, 186, 208, 'meowhook' },
            { 255, 255, 255, ' › ' },
            { 255, 255, 255, 'Configuration ' },
            { 255, 186, 208, name },
            { 255, 255, 255, ' has been successfully import' }
        )
    else
        config_system.add(
            { 255, 186, 208, 'meowhook' },
            { 255, 255, 255, ' › ' },
            { 255, 255, 255, 'Failed to import ' },
            { 255, 186, 208, name }
        )
    end
end)

menu.main.export:set_callback(function()
    local name = menu.main.name:get()
    if name == '' then return end

    client.exec("Play ".. "buttons/button9")

    local protected = function()
        config_system.export_settings(name)
    end

    if pcall(protected) then
        config_system.add(
            { 255, 186, 208, 'meowhook' },
            { 255, 255, 255, ' › ' },
            { 255, 255, 255, 'Configuration ' },
            { 255, 186, 208, name },
            { 255, 255, 255, ' has been successfully export' }
        )
    else
        config_system.add(
            { 255, 186, 208, 'meowhook' },
            { 255, 255, 255, ' › ' },
            { 255, 255, 255, 'Failed to export ' },
            { 255, 186, 208, name }
        )
    end
end)

-- # region function initDatabase
function initDatabase()
    if database.read(protected.database.configs) == nil then
        database.write(protected.database.configs, {})
    end

    local link = 'eyJjb25maWcyIjpbeyJlbmFibGUiOmZhbHNlLCJwaXRjaCI6IkRvd24iLCJkZWZfeWF3c2xpZGVyMiI6MCwiZGVmX2xlZnQiOjAsImRlbGF5IjoxLCJkZWZfeWF3dmFsdWUiOjAsImRlZl9yaWdodCI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwiZGVmX3lhd3NsaWRlciI6MCwieWF3YmFzZSI6IkF0IHRhcmdldHMiLCJ5YXd0eXBlIjoiU3dpdGNoIiwiZGVmX3lhdyI6IkRpc2FibGVkIiwiYm9keXlhdyI6IkppdHRlciIsImRlZ3JlZSI6MCwiZGVmX3BpdGNoIjoiRGlzYWJsZWQiLCJib2R5c2xpZGUiOjEsIm1vZGlmaWVyIjoiRGlzYWJsZWQiLCJsZWZ0IjowLCJwaXRjaF92YWx1ZSI6MCwicmlnaHQiOjB9LHsiZW5hYmxlIjp0cnVlLCJwaXRjaCI6IkRvd24iLCJkZWZfeWF3c2xpZGVyMiI6MCwiZGVmX2xlZnQiOjAsImRlbGF5IjoxLCJkZWZfeWF3dmFsdWUiOjAsImRlZl9yaWdodCI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwiZGVmX3lhd3NsaWRlciI6MCwieWF3YmFzZSI6IkF0IHRhcmdldHMiLCJ5YXd0eXBlIjoiU3dpdGNoIiwiZGVmX3lhdyI6IkRpc2FibGVkIiwiYm9keXlhdyI6IkppdHRlciIsImRlZ3JlZSI6MjYsImRlZl9waXRjaCI6IkRpc2FibGVkIiwiYm9keXNsaWRlIjoxLCJtb2RpZmllciI6IkNlbnRlciIsImxlZnQiOi0xNywicGl0Y2hfdmFsdWUiOjAsInJpZ2h0IjoxN30seyJlbmFibGUiOnRydWUsInBpdGNoIjoiRG93biIsImRlZl95YXdzbGlkZXIyIjowLCJkZWZfbGVmdCI6MCwiZGVsYXkiOjEsImRlZl95YXd2YWx1ZSI6MCwiZGVmX3JpZ2h0IjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlLCJkZWZfeWF3c2xpZGVyIjowLCJ5YXdiYXNlIjoiQXQgdGFyZ2V0cyIsInlhd3R5cGUiOiJTd2l0Y2giLCJkZWZfeWF3IjoiRGlzYWJsZWQiLCJib2R5eWF3IjoiSml0dGVyIiwiZGVncmVlIjo4LCJkZWZfcGl0Y2giOiJEaXNhYmxlZCIsImJvZHlzbGlkZSI6MSwibW9kaWZpZXIiOiJDZW50ZXIiLCJsZWZ0IjotMjIsInBpdGNoX3ZhbHVlIjowLCJyaWdodCI6Mjl9LHsiZW5hYmxlIjp0cnVlLCJwaXRjaCI6IkRvd24iLCJkZWZfeWF3c2xpZGVyMiI6MCwiZGVmX2xlZnQiOi05OCwiZGVsYXkiOjEsImRlZl95YXd2YWx1ZSI6LTIyLCJkZWZfcmlnaHQiOjEwMywiZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJkZWZfeWF3c2xpZGVyIjowLCJ5YXdiYXNlIjoiQXQgdGFyZ2V0cyIsInlhd3R5cGUiOiJTd2l0Y2giLCJkZWZfeWF3IjoiU3dpdGNoIiwiYm9keXlhdyI6IkppdHRlciIsImRlZ3JlZSI6MTAsImRlZl9waXRjaCI6IlVwIiwiYm9keXNsaWRlIjowLCJtb2RpZmllciI6IkNlbnRlciIsImxlZnQiOi0yNiwicGl0Y2hfdmFsdWUiOjAsInJpZ2h0IjozOH0seyJlbmFibGUiOnRydWUsInBpdGNoIjoiRG93biIsImRlZl95YXdzbGlkZXIyIjowLCJkZWZfbGVmdCI6LTc1LCJkZWxheSI6MSwiZGVmX3lhd3ZhbHVlIjowLCJkZWZfcmlnaHQiOjc1LCJmb3JjZV9kZWZlbnNpdmUiOnRydWUsImRlZl95YXdzbGlkZXIiOjAsInlhd2Jhc2UiOiJBdCB0YXJnZXRzIiwieWF3dHlwZSI6IlN3aXRjaCIsImRlZl95YXciOiJTd2l0Y2giLCJib2R5eWF3IjoiSml0dGVyIiwiZGVncmVlIjozMywiZGVmX3BpdGNoIjoiVXAiLCJib2R5c2xpZGUiOjEsIm1vZGlmaWVyIjoiQ2VudGVyIiwibGVmdCI6LTI0LCJwaXRjaF92YWx1ZSI6MCwicmlnaHQiOjI5fSx7ImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJEb3duIiwiZGVmX3lhd3NsaWRlcjIiOjAsImRlZl9sZWZ0IjowLCJkZWxheSI6MSwiZGVmX3lhd3ZhbHVlIjowLCJkZWZfcmlnaHQiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsImRlZl95YXdzbGlkZXIiOjAsInlhd2Jhc2UiOiJBdCB0YXJnZXRzIiwieWF3dHlwZSI6IlN3aXRjaCIsImRlZl95YXciOiJEaXNhYmxlZCIsImJvZHl5YXciOiJKaXR0ZXIiLCJkZWdyZWUiOjI2LCJkZWZfcGl0Y2giOiJEaXNhYmxlZCIsImJvZHlzbGlkZSI6MSwibW9kaWZpZXIiOiJDZW50ZXIiLCJsZWZ0IjotMjIsInBpdGNoX3ZhbHVlIjowLCJyaWdodCI6MTd9LHsiZW5hYmxlIjp0cnVlLCJwaXRjaCI6IkRvd24iLCJkZWZfeWF3c2xpZGVyMiI6MCwiZGVmX2xlZnQiOi0xODAsImRlbGF5IjoxLCJkZWZfeWF3dmFsdWUiOjE2LCJkZWZfcmlnaHQiOjE4MCwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJkZWZfeWF3c2xpZGVyIjowLCJ5YXdiYXNlIjoiQXQgdGFyZ2V0cyIsInlhd3R5cGUiOiJTd2l0Y2giLCJkZWZfeWF3IjoiU3BpbiIsImJvZHl5YXciOiJKaXR0ZXIiLCJkZWdyZWUiOi04LCJkZWZfcGl0Y2giOiJDdXN0b21pemUiLCJib2R5c2xpZGUiOjEsIm1vZGlmaWVyIjoiQ2VudGVyIiwibGVmdCI6LTMxLCJwaXRjaF92YWx1ZSI6LTg5LCJyaWdodCI6MzF9LHsiZW5hYmxlIjp0cnVlLCJwaXRjaCI6IkRvd24iLCJkZWZfeWF3c2xpZGVyMiI6MCwiZGVmX2xlZnQiOjAsImRlbGF5IjoxLCJkZWZfeWF3dmFsdWUiOi0xNywiZGVmX3JpZ2h0IjowLCJmb3JjZV9kZWZlbnNpdmUiOnRydWUsImRlZl95YXdzbGlkZXIiOjAsInlhd2Jhc2UiOiJBdCB0YXJnZXRzIiwieWF3dHlwZSI6IlN3aXRjaCIsImRlZl95YXciOiJTcGluIiwiYm9keXlhdyI6IkppdHRlciIsImRlZ3JlZSI6MTAsImRlZl9waXRjaCI6IkN1c3RvbWl6ZSIsImJvZHlzbGlkZSI6MSwibW9kaWZpZXIiOiJDZW50ZXIiLCJsZWZ0IjotMjYsInBpdGNoX3ZhbHVlIjotODksInJpZ2h0IjoyOX0seyJlbmFibGUiOmZhbHNlLCJwaXRjaCI6IkRpc2FibGVkIiwiZGVmX3lhd3NsaWRlcjIiOjAsImRlZl9sZWZ0IjowLCJkZWxheSI6MSwiZGVmX3lhd3ZhbHVlIjowLCJkZWZfcmlnaHQiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsImRlZl95YXdzbGlkZXIiOjAsInlhd2Jhc2UiOiJBdCB0YXJnZXRzIiwieWF3dHlwZSI6IlN3aXRjaCIsImRlZl95YXciOiJEaXNhYmxlZCIsImJvZHl5YXciOiJEaXNhYmxlZCIsImRlZ3JlZSI6MCwiZGVmX3BpdGNoIjoiRGlzYWJsZWQiLCJib2R5c2xpZGUiOjAsIm1vZGlmaWVyIjoiRGlzYWJsZWQiLCJsZWZ0IjowLCJwaXRjaF92YWx1ZSI6MCwicmlnaHQiOjB9XSwiY29uZmlnIjp7Im1haW4iOnsibGlzdCI6MSwic2VsZWN0IjoiTWFpbiJ9LCJtaXNjIjp7ImhpZGVzaG90cyI6ZmFsc2UsInRhYiI6MSwiaGl0Y2hhbmNlX292ZXJyaWRlX3NjYXIiOjAsImZvcmNlX3NsaWRlcl9zYWZlIjoyMCwianVtcF9zY291dCI6ZmFsc2UsImFuaW1hdGlvbiI6dHJ1ZSwiYXJyb3dzIjpmYWxzZSwidGhpcmRfcGVyc29uX3ZhbHVlIjo2NSwiaW5kZXhlcyI6WyJ+Il0sImluZGV4ZXNfYyI6IiMwNjBBMDlGRiIsImZvcmNlX3NsaWRlcl9iYWltIjoyNSwibWlzc19jb2xvcl9jIjoiI0ZGQkNCQ0ZGIiwiaGl0Y2hhbmNlX292ZXJyaWRlIjp0cnVlLCJhbmltYXRpb25fYWlyIjoiU3RhdGljIiwiaGl0Y2hhbmNlX292ZXJyaWRlX3VzcCI6MCwiYXNwZWN0cmF0aW8iOnRydWUsImxhZGRlciI6dHJ1ZSwic3RhdGUiOlsifiJdLCJ0aGlyZF9wZXJzb24iOnRydWUsInNjcmVlbl9pbmRpY2F0b3JzIjp0cnVlLCJzY3JlZW5fY29sb3JfYyI6IiNGRkJDQkNGRiIsImZvcmNlIjp0cnVlLCJoaXRjaGFuY2Vfb3ZlcnJpZGVfYXdwIjowLCJjbGFudGFnIjp0cnVlLCJtYWduaXR1ZGUiOjAsInNwZWVkIjoyLCJqdW1wX3Njb3V0X2hvdGtleSI6WzEsMCwifiJdLCJwcmVkaWN0ZWQiOnRydWUsImFuaW1hdGlvbl92YWx1ZSI6NSwiaGl0Y2hhbmNlX292ZXJyaWRlX2hvdGtleSI6WzIsODQsIn4iXSwibG9nc190eXBlIjpbIkNvbnNvbGUiLCJTY3JlZW4iLCJ+Il0sImFycm93c19jb2xvcl9jIjoiI0ZGQkNCQ0ZGIiwiaGl0Y2hhbmNlX292ZXJyaWRlX3NzZyI6NDUsImxvZ3MiOnRydWUsImhpdGNoYW5jZV9vdmVycmlkZV9yOCI6MzAsImhpdF9jb2xvcl9jIjoiI0ZGQkNCQ0ZGIiwiaG90a2V5aW5nIjpbMiw3NCwifiJdLCJoaXRjaGFuY2Vfb3ZlcnJpZGVfZzNzZzEiOjAsImZvcmNlX3NlbGVjdCI6WyJTU0ctMDgiLCJ+Il0sImNoYXJnZSI6dHJ1ZSwiYW5pbWF0aW9uX2JvZHlfbGVhbiI6MTAwLCJoaXRjaGFuY2Vfb3ZlcnJpZGVfZ2xvY2siOjAsInRyYXNodGFsayI6dHJ1ZSwiYW5pbWF0aW9uX2dyb3VuZCI6IlN0YXRpYyIsInNlbGVjdCI6IlJhZ2Vib3QiLCJ0cmFzaHRhbGtfc2VsZWN0IjpbIktpbGwiLCJEZWF0aCIsIn4iXSwibWluZG1nIjp0cnVlLCJhc3BlY3RyYXRpb192YWx1ZSI6MjksImFuaW1hdGlvbl9hZGRvbnMiOlsiQm9keSBMZWFuIiwiU21vb3RoaW5nIiwifiJdLCJoaXRjaGFuY2VfZ3Vuc190eXBlIjoiU1NHLTA4In0sImFudGlhaW0iOnsidXNlbGVzcyI6WyJTcGluIG9uIFdhcm0tdXAiLCJTcGluIG5vIEVuZW1pZXMiLCJ+Il0sImZlYXR1cmVzIjpbIlNhZmUgRnVuY3Rpb24iLCJBdm9pZCBCYWNrc3RhYiIsIkVkZ2Ugb24gRkQiLCJVc2VsZXNzIEZ1bmN0aW9uIiwifiJdLCJkaXNhYmxlcnMiOlsifiJdLCJrZXlfZm9yd2FyZCI6WzEsMCwifiJdLCJrZXlfbGVmdCI6WzEsMCwifiJdLCJrZXlfcmlnaHQiOlsxLDAsIn4iXSwic2VsZWN0IjoiQnVpbGRlciIsInRha2UiOlsiRnJlZXN0YW5kaW5nIiwifiJdLCJrZXlfcmVzZXQiOlsxLDAsIn4iXSwia2V5X2ZyZWVzdGFuZCI6WzEsMTgsIn4iXSwiY29uZGl0aW9uIjoiUnVubmluZyIsInNhZmUiOlsiS25pZmUiLCJaZXVzIiwifiJdfSwiZmFrZWxhZyI6eyJhbW91bnQiOiJEeW5hbWljIiwibGltaXQiOjEzLCJ2YXJpYW5jZSI6MH19fQ=='

   
    local decode = base64.decode(link, 'base64')
    local toTable = json.parse(decode)

    _G._G.table.insert(presets, { name = '*Default', config = base64.encode(json.stringify(toTable.config)), config2 = base64.encode(json.stringify(toTable.config2))})
    menu.main.name:set('*Default')

    menu.main.list:update(config_system.config_list())


    menu.main.list:update(config_system.config_list())
end

initDatabase()


-- # region config system end
function disablers(cmd)
if table_contains(menu.antiaim.disablers.value, player_state(cmd)) then
    ui.set(reference.freestand[1], false)
else
    if menu.antiaim.key_freestand:get() == true then
        ui.set(reference.freestand[1], true)
        ui.set(reference.freestand[2], "Always on")
    else
        ui.set(reference.freestand[1], false)
        ui.set(reference.freestand[2], "On hotkey")
    end
end
end

-- # region callbacks 

client.set_event_callback("setup_command", function(cmd)
    if menu.misc.predicted:get() or menu.misc.hotkeying:get() then
        compensate_lag(cmd)
    end
end)

client.set_event_callback("paint_ui", function()
    configure_client_interp()
    if menu.misc.predicted:get() and menu.misc.hotkeying:get() then
        renderer.indicator(255, 255, 255, 255, "PREDICTED")
    end
end)

client.set_event_callback('shutdown', function()
    menu.misc.third_person_value:set(70)
end)

client.set_event_callback('paint', function()
    local function thirdperson(value)
        cvar.cam_idealdist:set_int(value or 70)
    end

    local function handle_aspect_ratio()
        local aspect_ratio = menu.misc.aspectratio:get() 
            and menu.misc.aspectratio_value:get() / 25 
            or 1
        aspectratio(aspect_ratio)
    end

    if menu.misc.third_person:get() then
        thirdperson(menu.misc.third_person_value:get())
    else
        thirdperson()
    end

    handle_aspect_ratio()
end)


client.set_event_callback('shutdown', function()
    hide_original_menu(true)
    aspectratio(0)
    random_text = texts[math.random(1, #texts)]
    client.delay_call(0.1, function()
        client.set_clan_tag("")
    end)
end)

client.set_event_callback('paint', function()
    if menu.misc.hitchance_override:get() and menu.misc.hitchance_override_hotkey:get() then
        renderer.indicator(255, 255, 255, 255, "HITCHANCE OVR")
    end
end)

client.set_event_callback("paint_ui",  function() 
    if menu.main.select:get() == "Anti-aim" and menu.antiaim.select:get() == "Builder" then
        traverse_table_on(binds)
    else
        traverse_table(binds)
    end
end)

client.set_event_callback('shutdown', function()
    hide_original_menu(true)
end)

client.set_event_callback('paint_ui', function()
    hide_original_menu(false)
end)

client.set_event_callback("setup_command", function(cmd)
    aa_setup(cmd)
    fast_ladder(cmd)
    disablers(cmd)
end)

client.set_event_callback("paint_ui", function()
    if (globals.mapname() ~= breaker.mapname) then
        breaker.cmd = 0
        breaker.defensive = 0
        breaker.defensive_check = 0
        breaker.mapname = globals.mapname()
    end
end)

client.set_event_callback('pre_render', function()
    if menu.misc.animation:get() then
        anim_breaker()
    end
end)

client.set_event_callback("pre_render", function()
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return end
    local anim_state = c_entity.new(lp):get_anim_state()
    if not anim_state then return end

    if menu.misc.animation_addons:get("Body Lean") then
        local overlay = c_entity.new(lp):get_anim_overlay(12)
        if overlay and math.abs(entity.get_prop(lp, "m_vecVelocity[0]")) >= 3 then
            overlay.weight = menu.misc.animation_body_lean:get() / 100
        elseif menu.misc.animation_addons:get("Smoothing") then
            local overlay_smooth = c_entity.new(lp):get_anim_overlay(2)
            if overlay_smooth then overlay_smooth.weight = 0 end
        end
    end
end)

client.set_event_callback("pre_render", function()
    if not menu.misc.animation_addons:get("Earthquake") then return end

    local lp = entity.get_local_player()
    if lp then
        local speed = menu.misc.speed:get()
        local magnitude = menu.misc.magnitude:get() / 100 
        local indexes = menu.misc.indexes:get()

        local state = nil
        if menu.misc.state:get("Air-C") and id == 8 then
            state = "Air Crouching"
            speed = speed * 10
            magnitude = magnitude * 10
        elseif menu.misc.state:get("Running") and id == 3 then
            state = "Running"
            speed = speed * 10
            magnitude = menu.misc.magnitude:get() / 8
        elseif menu.misc.state:get("Air") and id == 7 then
            state = "Air"
            speed = speed * 10
            magnitude = magnitude * 10
        end

        if state then
            for _, index in ipairs(indexes) do
                local value = math.random(-magnitude * 15, magnitude * 15) / 15
                for _ = 1, speed do
                    entity.set_prop(lp, "m_flPoseParameter", value, index)
                end
            end
        end
    end
end)

client.set_event_callback("round_start", function()
    breaker.cmd = 0
    breaker.defensive = 0
    breaker.defensive_check = 0
end)


client.set_event_callback("player_connect_full", function(e)
    local ent = client.userid_to_entindex(e.userid)
    if ent == entity.get_local_player() then
        breaker.cmd = 0
        breaker.defensive = 0
        breaker.defensive_check = 0
    end
end)
client.set_event_callback('aim_fire', shot_logger.on_aim_fire)
client.set_event_callback('aim_miss', shot_logger.on_aim_miss)
client.set_event_callback('aim_hit', shot_logger.on_aim_hit)
client.set_event_callback('bullet_impact', shot_logger.bullet_impact)

client.set_event_callback('paint', function() 
    screen_indicator(cmd)
    mindmg()
    if not menu.misc.clantag:get() then
        client.set_clan_tag("")
    else
        clantag_en()
    end
end)

client.set_event_callback("paint", function()
    if menu.misc.arrows:get() then
        arrows()
    end
end)

local materials = { 'vgui_white', 'vgui/hud/800corner1', 'vgui/hud/800corner2', 'vgui/hud/800corner3', 'vgui/hud/800corner4' }

client.set_event_callback('paint', function()
    local r, g, b, a = 255, 255, 255, 255

    if menu.misc.cl_color and not ffi.cast('bool(__thiscall*)(void*)', ffi.cast('void***', client.create_interface('engine.dll', 'VEngineClient014'))[0][11])(nil) then
        r, g, b, a = menu.misc.cl_color:get()
    end

    for _, mat in pairs(materials) do
        local material = materialsystem.find_material(mat)
        material:alpha_modulate(a)
        material:color_modulate(r, g, b)
    end
end)


client.set_event_callback('paint', function()
    if menu.misc.screen_indicators:get() then
        return
    end
    local screen_width, screen_height = client.screen_size()
    local text = "MEOWHOOK"
    local text_width, text_height = renderer.measure_text(0, text)
    local x = (screen_width - text_width) / 2
    local y = (screen_height - text_height) - 5
    renderer.text(x, y, 255, 255, 255, 255, "-", 0, text)
end)

client.set_event_callback("setup_command", function(cmd)
    hitchance_override(cmd) 
end)

client.set_event_callback("setup_command", function(cmd)
    if menu.misc.jump_scout:get() then
        airstop(cmd)
    end 
end)

-- # region callbacks end