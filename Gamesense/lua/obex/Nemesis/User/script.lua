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
local ffi = require("ffi")
local bit = require("bit")

local obex = obex_fetch and obex_fetch() or {username = 'Developer', build = 'Source', discord=''}

if build == "User" then
    build = "Basic"
end

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
    tabs = { 'Anti-Aim', 'Visuals', 'Misc'}, --'Debug'
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
        -- enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'), OLD!!!
        -- pitch = ui.reference('AA', 'Anti-aimbot angles', 'Pitch'),
        -- yaw_base = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw base')},
        -- yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw')},
        -- yaw_jitter = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')},
        -- body_yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
        -- freestanding_body_yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw')},
        -- edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
        -- freestanding = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
        -- roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll')

        enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
        pitch = {ui.reference("AA", "Anti-aimbot angles", "Pitch")},
        yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
        yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
        yaw_jitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
        body_yaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
        freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
        edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
        freestanding = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
        roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
    },

    aa_other = {
        leg_movement = ui.reference('AA', 'Other', 'Leg movement'),
        fakelag_limit = ui.reference("AA", "Fake lag", "Limit"),
        on_shot = {ui.reference('AA', 'Other', 'On shot anti-aim')},
        slow_motion = {ui.reference("AA", "Other", "Slow motion")},
    },
}

function createOptions(prefix)
    return {
        pitch = ui.new_combobox('AA', 'Anti-aimbot angles', prefix .. ' Pitch', {'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random'}),
        yaw_base = ui.new_combobox('AA', 'Anti-aimbot angles', prefix .. ' Yaw base', {'Local view', 'At targets'}),
        yaw = ui.new_combobox('AA', 'Anti-aimbot angles', prefix .. ' Yaw', {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'}),
        --yaw_slider = ui.new_slider('AA', 'Anti-aimbot angles', '\n' .. prefix .. 'yaw_slider', -180, 180, 0, true,"°"),
        yaw_left_label = ui.new_label('AA', 'Anti-aimbot angles', prefix .. ' Yaw left'),
        yaw_slider_left = ui.new_slider('AA', 'Anti-aimbot angles', '\n' .. prefix .. 'yaw_slider_left', -180, 180, 0, true,"°"),
        yaw_right_label = ui.new_label('AA', 'Anti-aimbot angles', prefix .. ' Yaw right'),
        yaw_slider_right = ui.new_slider('AA', 'Anti-aimbot angles', '\n' .. prefix .. 'yaw_slider_right', -180, 180, 0, true,"°"),
        yaw_jitter = ui.new_combobox('AA', 'Anti-aimbot angles', prefix .. ' Yaw jitter', {'Off', 'Offset', 'Center', 'Random', 'Skitter'}),
        yaw_jitter_slider = ui.new_slider('AA', 'Anti-aimbot angles', '\n' .. prefix .. 'yaw_jitter_slider', -180, 180, 0, true,"°"),
        --body_yaw = ui.new_combobox('AA', 'Anti-aimbot angles', prefix .. ' Body yaw', {'Off', 'Opposite', 'Jitter', 'Static'}),
        --body_yaw_slider = ui.new_slider('AA', 'Anti-aimbot angles', '\n' .. prefix .. 'body_yaw_slider', -180, 180, 0, true,"°"),
        freestanding_body_yaw = ui.new_checkbox('AA', 'Anti-aimbot angles', prefix .. ' Freestanding body yaw'),
        edge_yaw_bind = ui.new_hotkey('AA', 'Anti-aimbot angles', prefix .. ' Edge yaw'),
    }
end

local menu = {

    user_info = ui.new_label('AA', 'Anti-aimbot angles', "\ac17f82ffN\ab77f8bffe\aae7f94ffm\aa57f9effe\a9b7fa7ffs\a927fb1ffi\a897fbaffs - \a646464FF"..tostring(obex.username)),
    enabled = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Enable'),

    tab = {
        switch_tabs = ui.new_combobox('AA', 'Anti-aimbot angles', 'Switch tabs', tables.tabs),

        [tables.tabs[1]] = { -- anti-aim
                player_state = ui.new_combobox('AA', 'Anti-aimbot angles', 'Player state', tables.states),
                standing = createOptions('\aC08A8AFF[Standing]\aCDCDCDFF'),
                moving = createOptions('\aC08A8AFF[Moving]\aCDCDCDFF'),
                ducking = createOptions('\aC08A8AFF[Ducking]\aCDCDCDFF'),
                in_air = createOptions('\aC08A8AFF[In air]\aCDCDCDFF'),
                air_duck = createOptions('\aC08A8AFF[Air duck]\aCDCDCDFF'),
                slowwalk = createOptions('\aC08A8AFF[Slowwalk]\aCDCDCDFF'),
                freestanding = ui.new_checkbox('AA', 'Anti-aimbot angles', '\aC08A8AFF[Anti-Aim]\aCDCDCDFF Freestanding'),
                freestanding_bind = ui.new_hotkey('AA', 'Anti-aimbot angles', '\nfreestanding_bind', true),
                --roll = ui.new_slider('AA', 'Anti-aimbot angles', '\aC08A8AFF[Anti-Aim]\aCDCDCDFF Roll', -45, 45, 0, true,"°"),
        },
        [tables.tabs[2]] = { --visuals
            indicator_mode = ui.new_combobox('AA', 'Anti-aimbot angles', 'Indicator mode', {'Default', 'Flow', 'Static', 'Off'}),
            indicator_color = ui.new_color_picker('AA', 'Anti-aimbot angles', 'indicator_color', 192, 138, 138, 255),
            prim_peek = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Peek circle'),
            prim_peek_color = ui.new_color_picker('AA', 'Anti-aimbot angles', 'prim_peek_color', 192, 138, 138, 255),
            watermark = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Watermark'),
        },
        [tables.tabs[3]] = { --misc
            console_logs = ui.new_multiselect("AA", "Anti-aimbot angles", "Console logs", {'Hit', 'Miss'}),
            console_logs_color = ui.new_color_picker('AA', 'Anti-aimbot angles', 'console_logs_color', 192, 138, 138, 255),
            animations = ui.new_multiselect('AA', 'Anti-aimbot angles', 'Animations', { 'Pitch on land', 'Slide', 'Air walk', 'Moon walk', 'Static legs' }),
            hoodkillsay = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Killsay'),
            clantag_spammer = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Clantag spammer'),
        },
        -- [tables.tabs[4]] = { --config
        --     save_settings = ui.new_button('AA', 'Anti-aimbot angles', 'Export settings', function() end),
        --     load_settings = ui.new_button('AA', 'Anti-aimbot angles', 'Import settings', function() end),
        -- },
        -- [tables.tabs[4]] = { --debug
        --     options = ui.new_multiselect('AA', 'Anti-aimbot angles', 'Options', { 'Debug panel', 'Resolver' }),
        -- },
    }
}

local save_settings = ui.new_button('AA', 'Anti-aimbot angles', 'Export settings', function()
    pcall(function()
        local settings = {}

        for i, v in pairs(menu) do
            if type(v) == 'table' then
                for j, e in pairs(v) do
                    if type(e) == 'table' then
                        for k, f in pairs(e) do
                            settings[k] = {}

                            if type(f) ~= 'table' then                            
                                local value = ui.get(f)
                                settings[k] = value
                            elseif type(f) == 'table' then
                                for l, g in pairs(f) do
                                    local tbl_value = ui.get(g)
                                    settings[k][l] = tbl_value
                                end
                            end
                        end              
                    end
                end
            end
        end

        clipboard.set(base64.encode(string.reverse(base64.encode(json.stringify(settings)))))
    end)
end)

local load_settings = ui.new_button('AA', 'Anti-aimbot angles', 'Import settings', function() 
    pcall(function()
        local settings = json.parse(base64.decode(string.reverse(base64.decode(clipboard.get()))))

        for i, v in pairs(menu) do
            if type(v) == 'table' then
                for j, e in pairs(v) do
                    if type(e) == 'table' then
                        for k, f in pairs(e) do
                            if type(f) ~= 'table' then
                                local value = settings[k]
                                ui.set(f, value)
                            elseif type(f) == 'table' then
                                for l, g in pairs(f) do
                                    local tbl_value = settings[k][l]
                                    ui.set(g, tbl_value)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
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

-- pasted from bassn
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

RGBAtoHEX = function(redArg, greenArg, blueArg, alphaArg)
    return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
end

local indicators = function()
    if ui.get(menu.enabled) then
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
            if entity.get_prop(entity.get_local_player(), 'm_bIsScoped') == 1 then --is scoped
                renderer.text(x/2 + 38, y/2 + 15, mcolor[1], mcolor[2], mcolor[3], alpha_pulse, 'c-d', 0, 'NEMESIS')
                if not (ui.get(reference.rage.double_tap[1]) and ui.get(reference.rage.double_tap[2])) then
                    renderer.text(x/2 + 25, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'DT')
                else
                    renderer.text(x/2 + 25, y/2 + 25, tables.dt_charge and 0 or 255,  tables.dt_charge and 255 or 0,0, 255, "c-", 0, "DT")
                end
                if ui.get(reference.aa_other.on_shot[2]) then
                    renderer.text(x/2 + 38, y/2 + 25, 255, 140, 140, 255, "c-", 0, 'OS')
                else
                    renderer.text(x/2 + 38, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'OS')
                end
                local freestanding_value = ui.get(reference.aa.freestanding[1])
                if ui.get(menu.tab['Anti-Aim'].freestanding) and ui.get(menu.tab['Anti-Aim'].freestanding_bind) then
                --if contains(ui.get(reference.aa.freestanding[1]), 'Default') and ui.get(reference.aa.freestanding[2]) then
                    renderer.text(x/2 + 51, y/2 + 25, 140, 140, 255, 255, "c-", 0, 'FS')
                else
                    renderer.text(x/2 + 51, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'FS')
                end

                renderer.text(x/2 + 38, y/2 + 35, 255, 255, 255, 255, "-c", nil, string.upper(tostring(tables.state)))

            else --not scoped
                renderer.text(x/2, y/2 + 15, mcolor[1], mcolor[2], mcolor[3], alpha_pulse, 'c-d', 0, 'NEMESIS')
                if not (ui.get(reference.rage.double_tap[1]) and ui.get(reference.rage.double_tap[2])) then
                    renderer.text(x/2 - 13, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'DT')
                else
                    renderer.text(x/2 - 13, y/2 + 25, tables.dt_charge and 0 or 255,  tables.dt_charge and 255 or 0,0, 255, "c-", 0, "DT")
                end
                if ui.get(reference.aa_other.on_shot[2]) then
                    renderer.text(x/2, y/2 + 25, 255, 140, 140, 255, "c-", 0, 'OS')
                else
                    renderer.text(x/2, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'OS')
                end
                local freestanding_value = ui.get(reference.aa.freestanding[1])
                if ui.get(menu.tab['Anti-Aim'].freestanding) and ui.get(menu.tab['Anti-Aim'].freestanding_bind) then
                --if contains(ui.get(reference.aa.freestanding[1]), 'Default') and ui.get(reference.aa.freestanding[2]) then
                    renderer.text(x/2 + 13, y/2 + 25, 140, 140, 255, 255, "c-", 0, 'FS')
                else
                    renderer.text(x/2 + 13, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'FS')
                end

                renderer.text(x/2, y/2 + 35, 255, 255, 255, 255, "-c", nil, string.upper(tostring(tables.state)))
            end
        elseif ui.get(menu.tab['Visuals'].indicator_mode) == 'Flow' then
            if entity.get_prop(entity.get_local_player(), 'm_bIsScoped') == 1 then
                renderer.text(x/2 + 38, y/2 + 15, 0, 0, 0, 50, "-c", nil, "NEMESIS")
                renderer.text(x/2 + 38, y/2 + 15, 255, 255, 255, 255, "-c", nil, string.format("\a%sN\a%sE\a%sM\a%sE\a%sS\a%sI\a%sS", RGBAtoHEX(unpack(aA[1])), RGBAtoHEX(unpack(aA[2])), RGBAtoHEX(unpack(aA[3])), RGBAtoHEX(unpack(aA[4])), RGBAtoHEX(unpack(aA[5])), RGBAtoHEX(unpack(aA[6])), RGBAtoHEX(unpack(aA[7]))))
                if not (ui.get(reference.rage.double_tap[1]) and ui.get(reference.rage.double_tap[2])) then
                    renderer.text(x/2 + 25, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'DT')
                else
                    renderer.text(x/2 + 25, y/2 + 25, tables.dt_charge and 0 or 255,  tables.dt_charge and 255 or 0,0, 255, "c-", 0, "DT")
                end
                if ui.get(reference.aa_other.on_shot[2]) then
                    renderer.text(x/2 + 38, y/2 + 25, 255, 140, 140, 255, "c-", 0, 'OS')
                else
                    renderer.text(x/2 + 38, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'OS')
                end
                local freestanding_value = ui.get(menu.tab['Anti-Aim'].freestanding)
                --if type(freestanding_value) == "table" and contains(freestanding_value, 'Default') and ui.get(menu.tab['Anti-Aim'].freestanding_bind) then
                if ui.get(menu.tab['Anti-Aim'].freestanding) and ui.get(menu.tab['Anti-Aim'].freestanding_bind) then
                --if contains(ui.get(reference.aa.freestanding[1]), 'Default') and ui.get(reference.aa.freestanding[2]) then
                    renderer.text(x/2 + 51, y/2 + 25, 140, 140, 255, 255, "c-", 0, 'FS')
                else
                    renderer.text(x/2 + 51, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'FS')
                end

                renderer.text(x/2 + 38, y/2 + 35, 255, 255, 255, 255, "-c", nil, string.upper(tostring(tables.state)))

            else
                renderer.text(x/2, y/2 + 15, 0, 0, 0, 50, "-c", nil, "NEMESIS")
                renderer.text(x/2, y/2 + 15, 255, 255, 255, 255, "-c", nil, string.format("\a%sN\a%sE\a%sM\a%sE\a%sS\a%sI\a%sS", RGBAtoHEX(unpack(aA[1])), RGBAtoHEX(unpack(aA[2])), RGBAtoHEX(unpack(aA[3])), RGBAtoHEX(unpack(aA[4])), RGBAtoHEX(unpack(aA[5])), RGBAtoHEX(unpack(aA[6])), RGBAtoHEX(unpack(aA[7]))))
                
                if not (ui.get(reference.rage.double_tap[1]) and ui.get(reference.rage.double_tap[2])) then
                    renderer.text(x/2 - 13, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'DT')
                else
                    renderer.text(x/2 - 13, y/2 + 25, tables.dt_charge and 0 or 255,  tables.dt_charge and 255 or 0,0, 255, "c-", 0, "DT")
                end
                if ui.get(reference.aa_other.on_shot[2]) then
                    renderer.text(x/2, y/2 + 25, 255, 140, 140, 255, "c-", 0, 'OS')
                else
                    renderer.text(x/2, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'OS')
                end
                local freestanding_value = ui.get(menu.tab['Anti-Aim'].freestanding)
                --if type(freestanding_value) == "table" and contains(freestanding_value, 'Default') and ui.get(menu.tab['Anti-Aim'].freestanding_bind) then
                if ui.get(menu.tab['Anti-Aim'].freestanding) and ui.get(menu.tab['Anti-Aim'].freestanding_bind) then
                --if contains(ui.get(reference.aa.freestanding[1]), 'Default') and ui.get(reference.aa.freestanding[2]) then
                    renderer.text(x/2 + 13, y/2 + 25, 140, 140, 255, 255, "c-", 0, 'FS')
                else
                    renderer.text(x/2 + 13, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'FS')
                end

                renderer.text(x/2, y/2 + 35, 255, 255, 255, 255, "-c", nil, string.upper(tostring(tables.state)))
            end
        elseif ui.get(menu.tab['Visuals'].indicator_mode) == 'Static' then
            if entity.get_prop(entity.get_local_player(), 'm_bIsScoped') == 1 then --is scoped
                renderer.text(x/2 + 38, y/2 + 15, mcolor[1], mcolor[2], mcolor[3], mcolor[4], 'c-d', 0, 'NEMESIS')
                if not (ui.get(reference.rage.double_tap[1]) and ui.get(reference.rage.double_tap[2])) then
                    renderer.text(x/2 + 25, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'DT')
                else
                    renderer.text(x/2 + 25, y/2 + 25, tables.dt_charge and 0 or 255,  tables.dt_charge and 255 or 0,0, 255, "c-", 0, "DT")
                end
                if ui.get(reference.aa_other.on_shot[2]) then
                    renderer.text(x/2 + 38, y/2 + 25, 255, 140, 140, 255, "c-", 0, 'OS')
                else
                    renderer.text(x/2 + 38, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'OS')
                end
                local freestanding_value = ui.get(menu.tab['Anti-Aim'].freestanding)
                --if type(freestanding_value) == "table" and contains(freestanding_value, 'Default') and ui.get(menu.tab['Anti-Aim'].freestanding_bind) then
                if ui.get(menu.tab['Anti-Aim'].freestanding) and ui.get(menu.tab['Anti-Aim'].freestanding_bind) then
                --if contains(ui.get(reference.aa.freestanding[1]), 'Default') and ui.get(reference.aa.freestanding[2]) then
                    renderer.text(x/2 + 51, y/2 + 25, 140, 140, 255, 255, "c-", 0, 'FS')
                else
                    renderer.text(x/2 + 51, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'FS')
                end

                renderer.text(x/2 + 38, y/2 + 35, 255, 255, 255, 255, "-c", nil, string.upper(tostring(tables.state)))

            else --not scoped
                renderer.text(x/2, y/2 + 15, mcolor[1], mcolor[2], mcolor[3], mcolor[4], 'c-d', 0, 'NEMESIS')
                if not (ui.get(reference.rage.double_tap[1]) and ui.get(reference.rage.double_tap[2])) then
                    renderer.text(x/2 - 13, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'DT')
                else
                    renderer.text(x/2 - 13, y/2 + 25, tables.dt_charge and 0 or 255,  tables.dt_charge and 255 or 0,0, 255, "c-", 0, "DT")
                end
                if ui.get(reference.aa_other.on_shot[2]) then
                    renderer.text(x/2, y/2 + 25, 255, 140, 140, 255, "c-", 0, 'OS')
                else
                    renderer.text(x/2, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'OS')
                end
                local freestanding_value = ui.get(menu.tab['Anti-Aim'].freestanding)
                --if type(freestanding_value) == "table" and contains(freestanding_value, 'Default') and ui.get(menu.tab['Anti-Aim'].freestanding_bind) then
                if ui.get(menu.tab['Anti-Aim'].freestanding) and ui.get(menu.tab['Anti-Aim'].freestanding_bind) then
                --if contains(ui.get(reference.aa.freestanding[1]), 'Default') and ui.get(reference.aa.freestanding[2]) then
                    renderer.text(x/2 + 13, y/2 + 25, 140, 140, 255, 255, "c-", 0, 'FS')
                else
                    renderer.text(x/2 + 13, y/2 + 25, 255, 255, 255, 150, "c-", 0, 'FS')
                end

                renderer.text(x/2, y/2 + 35, 255, 255, 255, 255, "-c", nil, string.upper(tostring(tables.state)))
            end
        end
    end
end

local watermark = function()
    if ui.get(menu.enabled) then
        local master_enabled = ui.get(menu.enabled)
        table_visible(reference.aa, not master_enabled)

        if ui.get(menu.tab['Visuals'].watermark) then
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
    end
end

local peek_cir = function()
    if ui.get(menu.enabled) then
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
end

local ground_ticks, end_time = 1, 0

local anims = function()
    if ui.get(menu.enabled) then
            
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

        if contains(ui.get(menu.tab['Misc'].animations), 'Moon walk') then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
        end
        
        if contains(ui.get(menu.tab['Misc'].animations), 'Static legs') then
            entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 1, 6)
            entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 1, 0)
        end
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
    if ui.get(menu.enabled) then
        local hit_id = e.id
        local hit_target = entity.get_player_name(e.target)
        local hit_chance = e.hit_chance
        local hit_damage = e.damage
        local hit_hitgroup = hitgroup_names[e.hitgroup + 1] or '?'

        local r, g, b = ui.get(menu.tab['Misc'].console_logs_color)

        if not contains(ui.get(menu.tab['Misc'].console_logs), 'Hit') then return end
        multicolor_log({r, g, b, '[nemesis] '}, {0, 255, 0, 'Hit '}, {r, g, b, hit_target}, {255, 255, 255, ' in the '}, {r, g, b, hit_hitgroup}, {255, 255, 255, ' for '}, {r, g, b, hit_damage}, {255, 255, 255, ' damage (hitchance '}, {r, g, b, round(hit_chance)}, {255, 255, 255, ')'})
    end
end

local on_miss = function(e)
    if ui.get(menu.enabled) then
        local miss_id = e.id
        local miss_target = entity.get_player_name(e.target)
        local miss_hitgroup = hitgroup_names[e.hitgroup + 1] or '?'
        local miss_reason = e.reason

        local r, g, b = ui.get(menu.tab['Misc'].console_logs_color)

        if not contains(ui.get(menu.tab['Misc'].console_logs), 'Miss') then return end
        multicolor_log({r, g, b, '[nemesis] '}, {255, 0, 0, 'Missed '}, {r, g, b, miss_target}, {255, 255, 255, ' in the '}, {r, g, b, miss_hitgroup}, {255, 255, 255, ' (reason '}, {r, g, b, miss_reason}, {255, 255, 255, ')'})
    end
end

local on_death = function(e)
    if ui.get(menu.enabled) then
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
    -- 'nemesis.pub',
    -- 'nemesis.pu',
    -- 'nemesis.p',
    -- 'nemesis.',
    -- 'nemesi$',
    -- 'nemes1',
    -- 'neme$',
    -- 'nem3',
    -- 'new',
    -- 'n3',
    -- 'n',
    -- '',
    -- 'n3',
    -- 'new',
    -- 'nem3',
    -- 'neme$',
    -- 'nemes1',
    -- 'nemesi$',
    -- 'nemesis.',
    -- 'nemesis.p',
    -- 'nemesis.pu',
    -- 'n3mesis.pub',
    -- 'nem3sis.pub',
    -- 'n3mesis.pub',
    -- 'nem3sis.pub',
    -- 'nemesis.pub',
    -- 'n3m3sis.pub',
    -- 'nemesis.pub',
    -- 'n3m3sis.pub',
    -- 'nemesis.pub',
    -- 'n3m3sis.pub',
    -- 'nemesis.pub',
    -- 'n3m3sis.pub',
    -- 'nem3sis.pub',
    -- 'n3mesis.pub',
    -- 'nem3sis.pub',
    -- 'n3mesis.pub'

    "n-----e",
    "n----e-",
    "n---e--",
    "n--e---",
    "n-e----",
    "ne-----",
    "ne----m",
    "ne---m-",
    "ne--m--",
    "ne-m---",
    "nem----",
    "nem---e",
    "nem--e-",
    "nem-e--",
    "neme---",
    "neme--s",
    "neme-s-",
    "nemes--",
    "nemes-i",
    "nemesi-",
    "nemesis",
    "nemesis",
    "nemesis",
    "nemesis",
    "nemesis",
    "nemesis",
    "nemesis",
    "nemesis",
    "nemesis",
    "nemesis",
    "nemesis",
    "nemesi-",
    "nemes-i",
    "nemes--",
    "neme-s-",
    "neme--s",
    "neme---",
    "nem-e--",
    "nem--e-",
    "nem---e",
    "nem----",
    "ne-m---",
    "ne--m--",
    "ne---m-",
    "ne----m",
    "ne-----",
    "n-e----",
    "n--e---",
    "n---e--",
    "n----e-",
    "n-----e",
    "n------",
}

local clantag_prev

local clantag = function()
    if ui.get(menu.enabled) then
        if ui.get(menu.tab['Misc'].clantag_spammer) then
            local cur = math.floor(globals.tickcount() / 20) % #clantags
            local clantag = clantags[cur+1]

            if clantag ~= clantag_prev then
            clantag_prev = clantag
            client.set_clan_tag(clantag)
            end
        else
            --client.set_clan_tag('')
        end
    end
end

local on_setup = function()
    if ui.get(menu.enabled) then

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

    ui.set(reference.aa.freestanding[1], ui.get(menu.tab['Anti-Aim'].freestanding))
    ui.set(reference.aa.freestanding[2], ui.get(menu.tab['Anti-Aim'].freestanding_bind) and "Always on" or "On hotkey")

    --local yaw_flip = 1
    --change the value of yaw_flip between 0 and 1 every millisecon
    local yaw_flip = math.floor(globals.curtime() * 1000) % 2




    --    local local_player = entity.get_local_player()
    --     if not local_player or not entity.is_alive(local_player) then return end

    --     local velocity = {entity_get_prop(local_player, 'm_vecVelocity')}
    --     local is_moving = math.abs(velocity[1]) > 5 or math.abs(velocity[2]) > 5 or math.abs(velocity[3]) > 5

    --     -- In Air, Crouching, Slow Motion, Moving, Standing
    --     local priorities = {
    --         not (bit.band(entity_get_prop(local_player, 'm_fFlags'), 1) == 1),
    --         entity_get_prop(local_player, 'm_flDuckAmount') > 0.5,
    --         ui_get(ref.slowwalk[2]),
    --         is_moving,
    --         not is_moving,
    --     }

        --in air
        if tables.state == "In air" then
            ui.set(reference.aa.pitch[1], ui.get(menu.tab['Anti-Aim'].in_air.pitch))
            ui.set(reference.aa.yaw_base, ui.get(menu.tab['Anti-Aim'].in_air.yaw_base))
            ui.set(reference.aa.yaw[1], ui.get(menu.tab['Anti-Aim'].in_air.yaw))
            --ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].in_air.yaw_slider))
            if (yaw_flip == 1) then
                ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].in_air.yaw_slider_left))
            else
                ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].in_air.yaw_slider_right))
            end
            ui.set(reference.aa.yaw_jitter[1], ui.get(menu.tab['Anti-Aim'].in_air.yaw_jitter))
            ui.set(reference.aa.yaw_jitter[2], ui.get(menu.tab['Anti-Aim'].in_air.yaw_jitter_slider))
            --ui.set(reference.aa.body_yaw[1], ui.get(menu.tab['Anti-Aim'].in_air.body_yaw))
            --ui.set(reference.aa.body_yaw[2], ui.get(menu.tab['Anti-Aim'].in_air.body_yaw_slider))
            ui.set(reference.aa.freestanding_body_yaw, ui.get(menu.tab['Anti-Aim'].in_air.freestanding_body_yaw))
            ui.set(reference.aa.edge_yaw, ui.get(menu.tab['Anti-Aim'].in_air.edge_yaw_bind))
        end
        --ducking

        --local player ducking flag
        if tables.state == "Ducking" then
            ui.set(reference.aa.pitch[1], ui.get(menu.tab['Anti-Aim'].ducking.pitch))
            ui.set(reference.aa.yaw_base, ui.get(menu.tab['Anti-Aim'].ducking.yaw_base))
            ui.set(reference.aa.yaw[1], ui.get(menu.tab['Anti-Aim'].ducking.yaw))
            --ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].ducking.yaw_slider))
            if (yaw_flip == 1) then
                ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].ducking.yaw_slider_left))
            else
                ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].ducking.yaw_slider_right))
            end
            ui.set(reference.aa.yaw_jitter[1], ui.get(menu.tab['Anti-Aim'].ducking.yaw_jitter))
            ui.set(reference.aa.yaw_jitter[2], ui.get(menu.tab['Anti-Aim'].ducking.yaw_jitter_slider))
            --ui.set(reference.aa.body_yaw[1], ui.get(menu.tab['Anti-Aim'].ducking.body_yaw))
            --ui.set(reference.aa.body_yaw[2], ui.get(menu.tab['Anti-Aim'].ducking.body_yaw_slider))
            ui.set(reference.aa.freestanding_body_yaw, ui.get(menu.tab['Anti-Aim'].ducking.freestanding_body_yaw))
            ui.set(reference.aa.edge_yaw, ui.get(menu.tab['Anti-Aim'].ducking.edge_yaw_bind))
        end
        --in air ducking
        if tables.state == "Air duck" then
            ui.set(reference.aa.pitch[1], ui.get(menu.tab['Anti-Aim'].air_duck.pitch))
            ui.set(reference.aa.yaw_base, ui.get(menu.tab['Anti-Aim'].air_duck.yaw_base))
            ui.set(reference.aa.yaw[1], ui.get(menu.tab['Anti-Aim'].air_duck.yaw))
            --ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].air_duck.yaw_slider))
            if (yaw_flip == 1) then
                ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].air_duck.yaw_slider_left))
            else
                ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].air_duck.yaw_slider_right))
            end
            ui.set(reference.aa.yaw_jitter[1], ui.get(menu.tab['Anti-Aim'].air_duck.yaw_jitter))
            ui.set(reference.aa.yaw_jitter[2], ui.get(menu.tab['Anti-Aim'].air_duck.yaw_jitter_slider))
            --ui.set(reference.aa.body_yaw[1], ui.get(menu.tab['Anti-Aim'].air_duck.body_yaw))
            --ui.set(reference.aa.body_yaw[2], ui.get(menu.tab['Anti-Aim'].air_duck.body_yaw_slider))
            ui.set(reference.aa.freestanding_body_yaw, ui.get(menu.tab['Anti-Aim'].air_duck.freestanding_body_yaw))
            ui.set(reference.aa.edge_yaw, ui.get(menu.tab['Anti-Aim'].air_duck.edge_yaw_bind))
        end
        --standing
        if tables.state == "Standing" then
            ui.set(reference.aa.pitch[1], ui.get(menu.tab['Anti-Aim'].standing.pitch))
            ui.set(reference.aa.yaw_base, ui.get(menu.tab['Anti-Aim'].standing.yaw_base))
            ui.set(reference.aa.yaw[1], ui.get(menu.tab['Anti-Aim'].standing.yaw))
            --ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].standing.yaw_slider))
            if (yaw_flip == 1) then
                ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].standing.yaw_slider_left))
            else
                ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].standing.yaw_slider_right))
            end
            ui.set(reference.aa.yaw_jitter[1], ui.get(menu.tab['Anti-Aim'].standing.yaw_jitter))
            ui.set(reference.aa.yaw_jitter[2], ui.get(menu.tab['Anti-Aim'].standing.yaw_jitter_slider))
            --ui.set(reference.aa.body_yaw[1], ui.get(menu.tab['Anti-Aim'].standing.body_yaw))
            --ui.set(reference.aa.body_yaw[2], ui.get(menu.tab['Anti-Aim'].standing.body_yaw_slider))
            ui.set(reference.aa.freestanding_body_yaw, ui.get(menu.tab['Anti-Aim'].standing.freestanding_body_yaw))
            ui.set(reference.aa.edge_yaw, ui.get(menu.tab['Anti-Aim'].standing.edge_yaw_bind))
        end
        --moving
        if tables.state == "Moving" then
            ui.set(reference.aa.pitch[1], ui.get(menu.tab['Anti-Aim'].moving.pitch))
            ui.set(reference.aa.yaw_base, ui.get(menu.tab['Anti-Aim'].moving.yaw_base))
            ui.set(reference.aa.yaw[1], ui.get(menu.tab['Anti-Aim'].moving.yaw))
            --ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].moving.yaw_slider))
            if (yaw_flip == 1) then
                ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].moving.yaw_slider_left))
            else
                ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].moving.yaw_slider_right))
            end
            ui.set(reference.aa.yaw_jitter[1], ui.get(menu.tab['Anti-Aim'].moving.yaw_jitter))
            ui.set(reference.aa.yaw_jitter[2], ui.get(menu.tab['Anti-Aim'].moving.yaw_jitter_slider))
            --ui.set(reference.aa.body_yaw[1], ui.get(menu.tab['Anti-Aim'].moving.body_yaw))
            --ui.set(reference.aa.body_yaw[2], ui.get(menu.tab['Anti-Aim'].moving.body_yaw_slider))
            ui.set(reference.aa.freestanding_body_yaw, ui.get(menu.tab['Anti-Aim'].moving.freestanding_body_yaw))
            ui.set(reference.aa.edge_yaw, ui.get(menu.tab['Anti-Aim'].moving.edge_yaw_bind))
        end
        --slowwalk
        if tables.state == "Slowwalk" then
            ui.set(reference.aa.pitch[1], ui.get(menu.tab['Anti-Aim'].slowwalk.pitch))
            ui.set(reference.aa.yaw_base, ui.get(menu.tab['Anti-Aim'].slowwalk.yaw_base))
            ui.set(reference.aa.yaw[1], ui.get(menu.tab['Anti-Aim'].slowwalk.yaw))
            --ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].slowwalk.yaw_slider))
            if (yaw_flip == 1) then
                ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].slowwalk.yaw_slider_left))
            else
                ui.set(reference.aa.yaw[2], ui.get(menu.tab['Anti-Aim'].slowwalk.yaw_slider_right))
            end
            ui.set(reference.aa.yaw_jitter[1], ui.get(menu.tab['Anti-Aim'].slowwalk.yaw_jitter))
            ui.set(reference.aa.yaw_jitter[2], ui.get(menu.tab['Anti-Aim'].slowwalk.yaw_jitter_slider))
            --ui.set(reference.aa.body_yaw[1], ui.get(menu.tab['Anti-Aim'].slowwalk.body_yaw))
            --ui.set(reference.aa.body_yaw[2], ui.get(menu.tab['Anti-Aim'].slowwalk.body_yaw_slider))
            ui.set(reference.aa.freestanding_body_yaw, ui.get(menu.tab['Anti-Aim'].slowwalk.freestanding_body_yaw))
            ui.set(reference.aa.edge_yaw, ui.get(menu.tab['Anti-Aim'].slowwalk.edge_yaw_bind))
        end
    end
end

local on_shutdown = function()
    table_visible(reference.aa, true)
end

local handle_interface = function()
    local master_enabled = ui.get(menu.enabled)
    table_visible(reference.aa, not master_enabled)

    if ui.get(menu.enabled) then
        ui.set(reference.aa.enabled, true)
    end

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
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'Standing' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, true)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'Moving' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, true)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'Ducking' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, true)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'In air' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, true)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'Air duck' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, true)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'Slowwalk' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, true)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'Use' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
        elseif ui.get(menu.tab['Anti-Aim'].player_state) == 'Freestanding' then
            table_visible({menu.tab['Anti-Aim'].default}, false)
            table_visible({menu.tab['Anti-Aim'].standing}, false)
            table_visible({menu.tab['Anti-Aim'].moving}, false)
            table_visible({menu.tab['Anti-Aim'].ducking}, false)
            table_visible({menu.tab['Anti-Aim'].in_air}, false)
            table_visible({menu.tab['Anti-Aim'].air_duck}, false)
            table_visible({menu.tab['Anti-Aim'].slowwalk}, false)
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

-- vector library
local vector = require('vector')

-- text for the indicator, change it if u want
local indicator_text = 'PEEK'

local allowed_hitscan = {0, 2, 4, 5, 7, 8}
local hitscan = allowed_hitscan
local prev_data = {}
local tmp_pos, count = 1
local start_pos, cur_target, did_shoot
local should_return = false

local hitscan_to_hitboxes = {
	['head'] = {0}, -- neck=1 but we wont use it cuz aimbot wont shoot neck. at least not if i play on hs only servers
	['chest'] = {2, 3, 4},
	['stomach'] = {5, 6},
	['arms'] = {13, 14, 15, 16, 17, 18}, 
	['legs'] = {7, 8, 9, 10}, 
	['feet'] = {11, 12}
}

local hitgroup_data = {
	['Head'] = 1,
	['Neck'] = 8,
	['Pelvis'] = 2,
	['Spine 4'] = 3,
	['Spine 3'] = 3,
	['Spine 2'] = 3,
	['Spine 1'] = 3,
	['Leg Upper L'] = 6,
	['Leg Upper R'] = 7,
	['Leg Lower L'] = 6,
	['Leg Lower R'] = 7,
	['Foot L'] = 6,
	['Foot R'] = 7,
	['Hand L'] = 4,
	['Hand R'] = 5,
	['Arm Upper L'] = 4,
	['Arm Upper R'] = 5,
	['Arm Lower L'] = 4,
	['Arm Lower R'] = 5
}

local hitboxes_num2text = {
	[0] = 'Head',
	[1] = 'Neck',
	[2] = 'Pelvis',
	[3] = 'Spine 4',
	[4] = 'Spine 3',
	[5] = 'Spine 2',
	[6] = 'Spine 1',
	[7] = 'Leg Upper L',
	[8] = 'Leg Upper R',
	[9] = 'Leg Lower L',
	[10] = 'Leg Lower R',
	[11] = 'Foot L',
	[12] = 'Foot R',
	[13] = 'Hand L',
	[14] = 'Hand R',
	[15] = 'Arm Upper L',
	[16] = 'Arm Upper R',
	[17] = 'Arm Lower L',
	[18] = 'Arm Lower R',
}

-- ui referenceseses
local refs = {
	mindmg = ui.reference('RAGE', 'Aimbot', 'Minimum damage'),
	target_hitbox = ui.reference('RAGE', 'Aimbot', 'Target hitbox'),
	menu_color = ui.reference('MISC', 'Settings', 'Menu color')
}

-- options for the multiselect ui object
local options_t = {
	'Allow limbs',
	'Indicator'
}

local menu_color = {ui.get(refs.menu_color)}

-- new ui objects or elemenst idk how u wanna call it
local enabled = ui.new_checkbox("AA", "Other", "\aC08A8AFF[Other]\aCDCDCDFF AI peek \aC08A8AFF[\ac0bc8ffanot my code\aC08A8AFF]")
local ui_obj = {
	peek_key = ui.new_hotkey("AA", "Other", "On key", true),
	options = ui.new_multiselect("AA", "Other", "\aC08A8AFF[AI peek]\aCDCDCDFF Options", options_t),
	max_dist = ui.new_slider("AA", "Other", "\aC08A8AFF[AI peek]\aCDCDCDFF Max peek distance", 30, 300, 45, true, 'u'),
	steps = ui.new_slider("AA", "Other", "\aC08A8AFF[AI peek]\aCDCDCDFF Trace steps", 1, 100, 10, true, 'u'),
	proc_speed = ui.new_slider("AA", "Other", "\aC08A8AFF[AI peek]\aCDCDCDFF Process update rate", 0, 10, 0, true, 's', 0.01),
	color = ui.new_color_picker("AA", "Other", "Indicator color", menu_color[1], menu_color[2], menu_color[3])
}

-- Utility functions
local function table_contains(t, val)
	if not t or not val then
		return false
	end
	for i=1,#t do
		if t[i] == val then
			return true
		end
	end
	return false
end

local function table_queue( t, v, max )
	for i = max, 1, -1 do
		if( t[ i ] ~= nil ) then
			t[ i + 1 ] = t[ i ]
		end
	end

	t[ 1 ] = v
	return t
end
  
local function math_clamp(x, min, max)
	return math.min(math.max(min, x), max)
end

local function math_round(num, decimals)
	num = num or 0
	local mult = 10 ^ (decimals or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function math_between(v, min, max)
	return (v and min and max) and (v > min and v < max) or false
end

local function degree_to_radian(degree)
	return (math.pi / 180) * degree
end

-- angle to vector calculation function i stole from my mom
local function AngleToVector (x, y)
	local pitch = degree_to_radian(x)
	local yaw = degree_to_radian(y)
	return math.cos(pitch) * math.cos(yaw), math.cos(pitch) * math.sin(yaw), -math.sin(pitch)
end

local client, o_trace_bullet, o_trace_line = client, client.trace_bullet, client.trace_line
local trace_cache = {
	bullet = {},
	line = {},
	line_cache = {},
	bullet_cache = {}
}

-- trace_line hook to crack luas
function client.trace_line(skip_entindex, from_x, from_y, from_z, to_x, to_y, to_z, name)
	-- for remembering and reusing trace results, which is stupit cuz trace_line drops close to 0 performance
	local cache_n = from_x..' '..from_y..' '..from_z..' '..to_x..' '..to_y..' '..to_z
	
	-- check if same trace was already made before and return the data in the table
	if trace_cache.line_cache[cache_n] then
		return trace_cache.line_cache[cache_n][1], trace_cache.line_cache[cache_n][2]
	end

	-- trace the line
	local frac, idx = o_trace_line(skip_entindex, from_x, from_y, from_z, to_x, to_y, to_z)
	
	-- store the trace data
	trace_cache.line_cache[cache_n] = {frac, idx}
	
	-- for drawing the trace lines 
	table_queue( trace_cache.line, {from = vector( from_x, from_y, from_z ), to = vector( to_x, to_y, to_z ), name = name or '', fraction = math_round(frac, 3)}, 1 )
	return frac, idx
end

function client.trace_bullet(from_player, from_x, from_y, from_z, to_x, to_y, to_z, skip_players, name)
	local idx, dmg = o_trace_bullet(from_player, from_x, from_y, from_z, to_x, to_y, to_z, skip_players)
	
	-- for drawing the damage traces 
	table_queue( trace_cache.bullet, {from = vector( from_x, from_y, from_z ), to = vector( to_x, to_y, to_z ), name = name or '', damage = dmg}, 1 )
	return idx, dmg
end

-- returns true if the entity is able to shoot, else it returns false
local function can_shoot(ent)
	ent = ent or entity.get_local_player()	
	local active_weapon = entity.get_prop(ent, "m_hActiveWeapon")
	local nextAttack = entity.get_prop(active_weapon, "m_flNextPrimaryAttack")
	return globals.curtime() >= nextAttack
end

-- make local player move to the given position
local function set_movement(cmd, desired_pos)
    local local_player = entity.get_local_player()
	local vec_angles = {
		vector(
			entity.get_origin( local_player )
		):to(
			desired_pos
		):angles()
	}

    local pitch, yaw = vec_angles[1], vec_angles[2]

    cmd.in_forward = 1
    cmd.in_back = 0
    cmd.in_moveleft = 0
    cmd.in_moveright = 0
    cmd.in_speed = 0
    cmd.forwardmove = 800
    cmd.sidemove = 0
    cmd.move_yaw = yaw
end


-- update the allowed hitscan if option allow limbs changed
local function update_allowed_hitscan(obj)
	local options = ui.get(obj)
	local limbs_allowed = table_contains(options, 'Allow limbs')

	-- i keep the commented out values just as an bridge of thought
	allowed_hitscan = (
		limbs_allowed and
		{0, --[[1, no neck. remember?]] 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18} or
		{0, --[[1, still no neck]] 2, --[[3,]] 4, 5, --[[6,]] 7, 8,--[[ 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]]}
	)
end
ui.set_callback(ui_obj.options, update_allowed_hitscan)

-- update the hitscan if target hitbox settings changed
local function update_hitscan(obj)
	local t_hitscan = {}
	local target_hitboxes = ui.get(obj)

	-- loop through all enabled target hitboxes
	for i=1, #target_hitboxes do
		local hitbox_t = hitscan_to_hitboxes[target_hitboxes[i]:lower()]

		-- store all hitbox numbers in an temporary table
		for i2=1, #hitbox_t do
			local hitbox = hitbox_t[i2]

			if table_contains(allowed_hitscan, hitbox) then
				table.insert(t_hitscan, hitbox)
			end
		end
	end
	
	-- set the hitscan
	hitscan = t_hitscan
end
ui.set_callback(refs.target_hitbox, update_hitscan)

update_hitscan( refs.target_hitbox )

local function handle_trace(ent, left_x, left_y, right_x, right_x, right_y, lp_eye_pos, dist)
	dist = dist or 1
	count = count or 1

	local max_dist = ui.get(ui_obj.max_dist)

	-- stop if trace distance reached max distance and reset
	if dist > max_dist then
		tmp_pos = nil
	    prev_data = {}
		return
	end              
		
	local local_player = entity.get_local_player()

	-- currently traced hitbox
	local cur_hitbox = hitscan[count]
	
	-- target hitbox position
	local enemy_hitbox = vector( entity.hitbox_position( ent, cur_hitbox ) )
	
	-- set the next traced hitbox
	count = count < #hitscan and count + 1 or 1
	
	local eye_left = vector( left_x * dist + lp_eye_pos.x, left_y * dist + lp_eye_pos.y, lp_eye_pos.z )	-- calculation for the position to your left
	local eye_right = vector( right_x * dist + lp_eye_pos.x, right_y * dist + lp_eye_pos.y, lp_eye_pos.z )-- calculation for the position to your left

	-- trace the fraction of your left and right to prevent tracing points starting inside a wall
	local fraction_l, _entindex = client.trace_line( local_player, lp_eye_pos.x, lp_eye_pos.y, lp_eye_pos.z, eye_left.x, eye_left.y, eye_left.z )		-- fraction from your eye position to the left
	local fraction_r, _entindex2 = client.trace_line( local_player, lp_eye_pos.x, lp_eye_pos.y, lp_eye_pos.z, eye_right.x, eye_right.y, eye_right.z )	-- fraction from your eye position to the right
	
	-- there has to be an reason why i did this trace...
	-- oh god, alzheimer kicks in... what is this? where am i? hello? yes, this is hello... or is it? idk i am retarted
	local frac_l_to_ent, entindex = client.trace_line( local_player, eye_left.x, eye_left.y, eye_left.z, enemy_hitbox.x, enemy_hitbox.y, enemy_hitbox.z )		-- fraction from your left side to the target entity
	local frac_r_to_ent, entindex2 = client.trace_line( local_player, eye_right.x, eye_right.y, eye_right.z, enemy_hitbox.x, enemy_hitbox.y, enemy_hitbox.z )	-- fraction from your right side to the target entity

	-- get the possible damage from your left and right
	local _, dmg_l = client.trace_bullet( local_player, eye_left.x, eye_left.y, eye_left.z, enemy_hitbox.x, enemy_hitbox.y, enemy_hitbox.z )		-- damage from your left side to the target entity hitbox
	local _, dmg_r = client.trace_bullet( local_player, eye_right.x, eye_right.y, eye_right.z, enemy_hitbox.x, enemy_hitbox.y, enemy_hitbox.z )	-- damage from your right side to the target entity hitbox
	
	-- convert hitbox number to hitbox name
	local hitbox_name = hitboxes_num2text[cur_hitbox]

	-- get the hitgroup of the hitbox
	local hitgroup = hitgroup_data[hitbox_name]
	
	-- adjust the damage for the hitgroup
	dmg_l = client.scale_damage(ent, hitgroup, dmg_l)
	dmg_r = client.scale_damage(ent, hitgroup, dmg_r)
	
	local mindmg = ui.get(refs.mindmg)

	if fraction_l == 1 and dmg_l >= mindmg  then
		tmp_pos = eye_left
	    prev_data = {}
		return
	else
		prev_data.left = eye_left
	end

	if fraction_r == 1 and dmg_r >= mindmg then
	   tmp_pos = eye_right
	   prev_data = {}
	   return
	else
		prev_data.right = eye_right
	end
	
	-- check if it tracing should continue on the next distance
	if (fraction_l == 1 or fraction_r == 1) and (frac_l_to_ent < 1 and frac_r_to_ent < 1) and (entindex ~= ent and entindex2 ~= ent) and (dmg_r < mindmg and dmg_l < mindmg) then
		
		-- delay call for the next trace with and distance increase of default: 10 units
		-- less distance increment is finer but slower tracing and more increment is the opposite
		client.delay_call(ui.get( ui_obj.proc_speed ) / 100, handle_trace, ent, left_x, left_y, right_x, right_x, right_y, lp_eye_pos, dist + ui.get( ui_obj.steps ))
	else
		prev_data = {}
	end
end

local function do_return( cmd )
	-- check if player should return to start position
	if start_pos and should_return then
		local m_vecOrigin_lp = vector( entity.get_origin( entity.get_local_player() ) )
		if start_pos:dist2d( m_vecOrigin_lp ) > 5 then
			set_movement( cmd, start_pos )
		else
			should_return = false
		end
	end
end

local function on_setup_command(cmd)
	if not ui.get(enabled) or not ui.get(ui_obj.peek_key) then
		should_return = false
		tmp_pos = nil
		start_pos = nil
	    prev_data = {}
		return
	end

	local local_player = entity.get_local_player()

	-- check if local player is alive
	if not entity.is_alive(local_player) then
		prev_data = {}	
		tmp_pos = nil
	   return
	end

	-- i use current_threat so we wont need to loop through all players and calculate the best target
	local ent = client.current_threat()
	
	-- as an backup to prevent target switch while peeking
	cur_target = cur_target or ent

	-- check if the target can be switched and set to new target if so
	cur_target = cur_target ~= ent and ((not tmp_pos or should_return) and ent or cur_target) or cur_target
	
	-- set ent to cur_target just cuz i am to lazy to change ent to cur_target. which i could have done while writing this comment like an schizophrenic.
	ent = cur_target

	-- check if target exists and is alive
	if not ent or not entity.is_alive(ent) then
		-- return to start pos
		return do_return( cmd )
	end

	local m_vecOrigin_lp = vector(entity.get_origin( local_player ))
	local m_vecOrigin_enemy = vector(entity.get_origin( ent ))

	start_pos = start_pos or m_vecOrigin_lp

	local lp_eye_pos = vector( client.eye_position() )
	
	local vec2enemy_x, vec2enemy_y = lp_eye_pos.x - m_vecOrigin_enemy.x, lp_eye_pos.y - m_vecOrigin_enemy.y
	local ang2enemy = math.atan2( vec2enemy_y, vec2enemy_x ) * ( 180 / math.pi )
	
	local vec2enemy_x2, vec2enemy_y2 = lp_eye_pos.x - m_vecOrigin_enemy.x, lp_eye_pos.y - m_vecOrigin_enemy.y
	local ang2enemy2 = math.atan2( vec2enemy_y2, vec2enemy_x2 ) * ( 180 / math.pi )
	
	local left_x, left_y, left_z = AngleToVector( 0, ang2enemy - 90 )
	local right_x, right_y, right_z = AngleToVector( 0, ang2enemy + 90 )

	-- can u?
	local can_shit = can_shoot()

	should_return = can_shit and false or should_return

	-- check if trace handeling function should be called
	if not prev_data.left and not prev_data.right and not tmp_pos then	
		handle_trace( ent, left_x, left_y, right_x, right_x, right_y, lp_eye_pos )
	end

	-- if shot fired, the peek was successful and the player should return
	if did_shoot then
		should_return = true
		did_shoot = false
		prev_data = {}	
		tmp_pos = nil
	end
	
	if tmp_pos then
		local move_dist = tmp_pos:dist2d( m_vecOrigin_lp )

		-- as long the player can shoot and is far from the goal, the player should move to the goal
		if move_dist > 5 and can_shit then
			should_return = false
			set_movement( cmd, tmp_pos )
		else
			should_return = true
			tmp_pos = nil
		end
	end

	-- check if player should return to start position
	do_return( cmd )
end	

local function draw_trace_lines(color)
	if not ui.get(enabled) or not ui.get(ui_obj.peek_key) then
		return
	end

	local options = ui.get( ui_obj.options )
	
	if table_contains(options, 'Indicator') then
		local r, g, b, a = ui.get(ui_obj.color)
		renderer.indicator(r, g, b, a, indicator_text)
	end

	if not table_contains(options, 'Draw trace') then
		return
	end

	for i=1, #trace_cache.bullet do
		local from = trace_cache.bullet[i]['from']
		local to = trace_cache.bullet[i]['to']
		local name = trace_cache.bullet[i]['name']
		local dmg = trace_cache.bullet[i]['damage']
		
		local scr_from_x, scr_from_y = renderer.world_to_screen( from.x, from.y, from.z )
		local scr_to_x, scr_to_y = renderer.world_to_screen( to.x, to.y, to.z )

		if scr_from_x and scr_from_y and scr_to_x and scr_to_y then
			renderer.line( scr_from_x, scr_from_y, scr_to_x, scr_to_y, math_clamp( 200 + dmg, 0, 255 ), math_clamp( 255 - dmg, 0, 255 ), math_clamp( 100 - dmg, 0, 255 ), 255 )
			renderer.text( scr_from_x + 20, scr_from_y + 20, math_clamp( 200 + dmg, 0, 255 ), math_clamp( 255 - dmg, 0, 255 ), math_clamp( 100 - dmg, 0, 255 ), 255, 'c', 0, dmg )
		end
	end

end

-- set start position on key press
local key_pressed
ui.set_callback( ui_obj.peek_key, function(obj)
	local key_press = ui.get(obj)
	key_pressed = key_pressed and not key_press and false or key_pressed
	
	if key_pressed then
		return
	end

	key_pressed = true
	start_pos = vector( entity.get_origin( entity.get_local_player() ) )
	should_return = false
	did_shoot = false
	prev_data = {}	
	tmp_pos = nil
end )

-- do things if player spawned
local function on_player_spawn( e )
	local ent = client.userid_to_entindex( e.userid )
	local local_player = entity.get_local_player()
	
	
	if ent == local_player then
		-- update the hitscan if local player is spawned
		update_hitscan( refs.target_hitbox )
		
		-- reset the trace cache
		trace_cache = {
			bullet = {},
			line = {},
			line_cache = {},
			bullet_cache = {}
		}
	end
end

-- do things if an weapon is fired
local function on_weapon_fire( e )
	local ent = client.userid_to_entindex( e.userid )
	local local_player = entity.get_local_player()
	
	-- did the local player shoot?
	should_return = ent == local_player and true or should_return
	did_shoot = ent == local_player
	tmp_pos = nil
end

-- set ui object invisible/visible
local function ui_obj_visibility(param)
	local succ, val = pcall(ui.get, type(param) == 'boolean' and enabled or param)
	param = not succ and param or (val)
	
	-- set or unset the event callbacks depending on if the checkbox is enabled or disabled
	local handle_event_callback = param and client.set_event_callback or client.unset_event_callback
	
	-- gs events
	handle_event_callback( 'paint', draw_trace_lines )
	handle_event_callback( 'setup_command', on_setup_command )	
	
	-- game events
	handle_event_callback( "weapon_fire", on_weapon_fire )
	handle_event_callback( "player_spawn", on_player_spawn )
	
	for k, v in pairs(ui_obj) do
		ui.set_visible(v, param)
	end
end
ui_obj_visibility(false)
ui.set_callback(enabled, ui_obj_visibility)

client.set_event_callback('setup_command', function() on_setup() end)
client.set_event_callback('paint', function() indicators() watermark() peek_cir() end)
client.set_event_callback('pre_render', function() anims() end)
client.set_event_callback('aim_hit', on_hit)
client.set_event_callback('aim_miss', on_miss)
client.set_event_callback('player_say', player_chat)
client.set_event_callback('player_death', on_death)
client.set_event_callback('net_update_end', function() clantag() end)
client.set_event_callback('shutdown', on_shutdown)