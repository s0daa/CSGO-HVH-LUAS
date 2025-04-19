--@project: enthusiasm
--@author: javasense

local _nam = 'Enthusiasm'
local _bui = 'dev'
local _nick = panorama.open().MyPersonaAPI.GetName()

--region enthusiasm

local lua = {}

--region lib

local ffi = require'ffi'
local vector = require'vector'
local pui = require'gamesense/pui'
local http = require'gamesense/http'
local images = require'gamesense/images'
local base64 = require'gamesense/base64'
local entitys = require'gamesense/entity'
local weapons = require'gamesense/csgo_weapons'
local clipboard = require'gamesense/clipboard'
local math = math
local client = client
local renderer = renderer
local screen = vector(client.screen_size())
local entity = entity
local cvar = cvar
local globals = globals
local color = function (r, g, b, a)
    return {
        r = r or 0,
        g = g or 0,
        b = b or 0,
        a = a or 255
    }
end
local coord = function (x, y)
    return {
        x = x or 0,
        y = y or 0
    }
end
local downloadfile = function()
    http.get('https://github.com/anarchisrt/antarctica/blob/main/pngwing.com%201%201.png?raw=true', function(success, response)
        if not success or response.status ~= 200 then
            return
        end
        writefile('enthusiasm.png', response.body)
    end)
end
downloadfile()

--endregion

--region render

local render = {
    text = function (coords, colors, fl, o, ...)
        renderer.text(coords.x, coords.y, colors.r, colors.g, colors.b, colors.a, fl or '', o or 0, ...)
    end,
    rect = function (coords, size, colors)
        renderer.rectangle(coords.x, coords.y, size.x, size.y, colors.r, colors.g, colors.b, colors.a)
    end,
    fade = function (coords, size, colors, colors2, align)
        renderer.gradient(coords.x, coords.y, size.x, size.y, colors.r, colors.g, colors.b, colors.a, colors2.r, colors2.g, colors2.b, colors2.a, align)
    end,
    blur = function (coords, size, alpha, amount)
        renderer.blur(coords.x, coords.y, size.x, size.y, alpha or 1, amount or 1)
    end,
    circle = function (coords, colors, radius, thickness, start, percentage)
        if thickness ~= nil then
            renderer.circle_outline(coords.x, coords.y, colors.r, colors.g, colors.b, colors.a, radius, start or 0, percentage or 1, thickness)
        else
            renderer.circle(coords.x, coords.y, colors.r, colors.g, colors.b, colors.a, radius, start or 0, percentage or 1)
        end
    end,
    measure_text = function (fl, text)
        local measure = coord(renderer.measure_text(fl, text))
        return measure
    end
}

--endregion

--region reference

lua.reference = {} do
    lua.reference.init = function ()
		lua.reference.rage = {
			binds = {
				weapon_type = pui.reference('rage', 'weapon type', 'weapon type'),
				enabled = { pui.reference('rage', 'aimbot', 'enabled') },
				stop = { pui.reference('rage', 'aimbot', 'quick stop') },
				minimum_damage = pui.reference('rage', 'aimbot', 'minimum damage'),
				minimum_damage_override = {pui.reference('rage', 'aimbot', 'minimum damage override')},
				minimum_hitchance = pui.reference('rage', 'aimbot', 'minimum hit chance'),
				double_tap = {pui.reference('rage', 'aimbot', 'double tap')},
                body_aim = pui.reference('rage', 'aimbot', 'force body aim'),
                safe_point = pui.reference('rage', 'aimbot', 'force safe point'),
				double_tap_fl = pui.reference('rage', 'aimbot', 'double tap fake lag limit'),
				ps = { pui.reference('misc', 'miscellaneous', 'ping spike') },
				quickpeek = {pui.reference('rage', 'other', 'quick peek assist')},
				quickpeekm = {pui.reference('rage', 'other', 'quick peek assist mode')},
                fakeduck = pui.reference('rage', 'other', 'duck peek assist'),
				on_shot_anti_aim = {pui.reference('aa', 'other', 'on shot anti-aim')},
				usercmd = pui.reference('misc', 'settings', 'sv_maxusrcmdprocessticks2')
			}
		}
		lua.reference.antiaim = {
			angles = {
				enabled = pui.reference('aa', 'anti-aimbot angles', 'enabled'),
				pitch = { pui.reference('aa', 'anti-aimbot angles', 'pitch') },
				roll = pui.reference('aa', 'anti-aimbot angles', 'roll'),
				yaw_base = pui.reference('aa', 'anti-aimbot angles', 'yaw base'),
				yaw = { pui.reference('aa', 'anti-aimbot angles', 'yaw') },
				freestanding_body_yaw = pui.reference('aa', 'anti-aimbot angles', 'freestanding body yaw'),
				edge_yaw = pui.reference('aa', 'anti-aimbot angles', 'edge yaw'),
				yaw_jitter = { pui.reference('aa', 'anti-aimbot angles', 'yaw jitter') },
				desync = { pui.reference('aa', 'anti-aimbot angles', 'body yaw') },
				freestanding = pui.reference('aa', 'anti-aimbot angles', 'freestanding'),
				roll_aa = pui.reference('aa', 'anti-aimbot angles', 'roll')
			},
			fakelag = {
				on = {pui.reference('aa', 'fake lag', 'enabled')},
				amount = pui.reference('aa', 'fake lag', 'amount'),
				variance = pui.reference('aa', 'fake lag', 'variance'),
				limit = pui.reference('aa', 'fake lag', 'limit')
			},
			other = {
				slide = {pui.reference('aa','other','slow motion')},
				slow_motion = {pui.reference('aa', 'other', 'slow motion')},
				fake_peek = {pui.reference('aa', 'other', 'fake peek')},
				leg_movement = pui.reference('aa', 'other', 'leg movement')
			}
		}
        lua.reference.antiaim.angles.enabled:set(true)
		lua.reference.visuals = {
			effects = {
				thirdperson = { pui.reference('visuals', 'effects', 'force third person (alive)') },
                scope = pui.reference('visuals', 'effects', 'remove scope overlay'),
				dpi = pui.reference('misc', 'settings', 'dpi scale'),
				clrmenu = pui.reference('misc', 'settings', 'menu color'),
				output = pui.reference('misc', 'miscellaneous', 'draw console output'),
				name = { pui.reference('visuals', 'player esp', 'name') },
                ping = {pui.reference('misc', 'miscellaneous', 'ping spike')},
				fov = pui.reference('misc', 'miscellaneous', 'override fov'),
                clantag = pui.reference('misc', 'miscellaneous', 'clan tag spammer'),
                dormantesp = pui.reference('visuals', 'player esp', 'dormant'),
				zfov = pui.reference('misc', 'miscellaneous', 'override zoom fov'),
                edge_jump = {pui.reference('misc', 'movement', 'jump at edge')},
			}
		}
	end
    lua.reference.hide = function(enabled)
		pui.traverse(lua.reference.antiaim.angles, function (r, path)
			r:set_visible(false)
		end)
        pui.traverse(lua.reference.antiaim.fakelag, function (r, path)
			r:set_visible(enabled)
		end)
        pui.traverse(lua.reference.antiaim.other, function (r, path)
			r:set_visible(enabled)
		end)
        lua.reference.rage.binds.on_shot_anti_aim[1]:set_visible(enabled)
    end
    defer(lua.reference.hide)
    defer(function ()
        pui.traverse(lua.reference.rage, function (ref)
            ref:override()
            ref:set_enabled(true)
            if ref.hotkey then ref.hotkey:set_enabled(true) end
        end)
        pui.traverse(lua.reference.antiaim, function (ref)
            ref:override()
            ref:set_enabled(true)
            if ref.hotkey then ref.hotkey:set_enabled(true) end
        end)
        pui.traverse(lua.reference.visuals, function (ref)
            ref:override()
            ref:set_enabled(true)
            if ref.hotkey then ref.hotkey:set_enabled(true) end
        end)
        lua.reference.rage.binds.usercmd:set_visible(false)
    end)
end
lua.reference.init()

--endregion

--region math

math.clamp = function (value, minimum, maximum)
    assert(value and minimum and maximum, '')
    if minimum > maximum then minimum, maximum = maximum, minimum end
    return math.max(minimum, math.min(maximum, value))
end

math.lerping = function (a, b, w)
    return a + (b - a) * w
end

math.tohexi = function (r, g, b)
    return string.format('0x%.2X%.2X%.2X', b, g, r)
end

math.lerp = function (start, enp, time)
    time = time or 0.005
    time = math.clamp(globals.absoluteframetime() * time * 175.0, 0.01, 1.0)
    local a = math.lerping(start, enp, time)
    if enp == 0.0 and a < 0.02 and a > -0.02 then
        a = 0.0
    elseif enp == 1.0 and a < 1.01 and a > 0.99 then
        a = 1.0
    end
    return a
end

math.round = function (x)
    if x < 0 then
        return math.ceil(x - 0.5);
    end

    return math.floor(x + 0.5);
end

math.side = 0
math.propering = function (cmd)
    local me = entity.get_local_player()
    if entity.is_alive(me) then
        math.side = cmd.in_moveright == 1 and -1 or cmd.in_moveleft == 1 and 1 or 0
    end
end
client.set_event_callback('setup_command', math.propering)

math.closest_ray_point = function (p, s, e)
	local t, d = p - s, e - s
	local l = d:length()
	d = d / l
	local r = d:dot(t)
	if r < 0 then return s elseif r > l then return e end
	return s + d * r
end

math.exploit = function ()
    local me = entity.get_local_player()
    if not me then return end
    local tick_defensive = lua.helps.on_level_init()
    local tickcount = globals.tickcount()
    local tickbase = entity.get_prop(me, 'm_nTickBase')
    local ready = (tickbase - tickcount) > 0 and true or false

    return tickbase, tickcount, ready, tick_defensive > 0 and 'unsafe' or 'safe'
end

math.tohex = function(rgb)
    local hexadecimal= '\a'

    for key, value in pairs(rgb) do
        local hex = ''

        while value > 0 do
            local index = math.fmod(value, 16) + 1
            value = math.floor(value/16)
            hex = ('0123456789ABCDEF'):sub(index, index) .. hex
        end

        if #hex == 0 then
            hex= '00'
        elseif #hex == 1 then
            hex= '0' .. hex
        end

        hexadecimal = hexadecimal .. hex
    end 

    return hexadecimal
end

local rg, gb, ba = lua.reference.visuals.effects.clrmenu:get()
math.gradienttext = function(text_to_draw, speed)
    local base_r, base_g, base_b,base_a = 255,255,255,255
    local r2, g2, b2, a2 = rg, gb, ba
    local highlight_fraction =  (globals.realtime() / 2 % 1.2 * speed) - 1.2
    local output = ""
    for idx = 1, #text_to_draw do
        local character = text_to_draw:sub(idx, idx)
        local character_fraction = idx / #text_to_draw

        local r, g, b, a = base_r, base_g, base_b, base_a
        local highlight_delta = (character_fraction - highlight_fraction)
        if highlight_delta >= 0 and highlight_delta <= 1.4 then
            if highlight_delta > 0.7 then
                highlight_delta = 1.4 - highlight_delta
            end
            local r_fraction, g_fraction, b_fraction, a_fraction = r2 - r, g2 - g, b2 - b
            r = r + r_fraction * highlight_delta / 0.8
            g = g + g_fraction * highlight_delta / 0.8
            b = b + b_fraction * highlight_delta / 0.8
        end
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, 255, text_to_draw:sub(idx, idx))
    end
    return output
end

math.hex_rgba = function(r, g, b, a)
    return bit.tohex(
    (math.floor(r + 0.5) * 16777216) +
    (math.floor(g + 0.5) * 65536) +
    (math.floor(b + 0.5) * 256) +
    (math.floor(a + 0.5))
    )
end

math.animate_text = function(time, string, color, color2)
    local t_out, t_out_iter = { }, 1

    local l = string:len( ) - 1

    local r, g, b, a = color.r, color.g, color.b, color.a
    local r2, g2, b2, a2 = color2.r, color2.g, color2.b, color2.a

    local r_add = (r2 - r)
    local g_add = (g2 - g)
    local b_add = (b2 - b)
    local a_add = (a2 - a)

    for i = 1, #string do
        local iter = (i - 1)/(#string - 1) + time
        t_out[t_out_iter] = '\a' .. math.hex_rgba( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )

        t_out[t_out_iter + 1] = string:sub( i, i )

        t_out_iter = t_out_iter + 2
    end

    return t_out
end

math.nway = function(start, final, way)
    local value = {} for i = 0, 1, 1 / (way - 1) do
        table.insert(value, math.lerping(start, final, i))
    end
    return value
end

local uway = {} do
    math.uway = function(name, start, final, condition, ways)
        if uway[name] == nil then
            uway[name] = 1
        end
        local value = math.nway(start, final, ways)

        if condition then
            uway[name] = uway[name] + 1
            if uway[name] > ways then
                uway[name] = 1
            end
        end

        if not value[uway[name]] then
            value[uway[name]] = 0
        end

        return value[uway[name]]
    end
end

--endregion

--region pui

lua.pui = {}

--region ui

lua.pui.ui = {} do
    lua.pui.ui.group = {
        main = pui.group('aa', 'anti-aimbot angles'),
        fake = pui.group('aa', 'fake lag'),
        other = pui.group('aa', 'other')
    }

    lua.pui.ui.selectab = {
        maing = lua.pui.ui.group.main:label(' Ⳋ┃Ⳓ  ' .._nam .. '                        ', {230, 230, 230, 230}),
        group = lua.pui.ui.group.main:combobox('\n  Selection', {'-', '  Builder', '  Antiaim', '  Visuals', '  Other'})
    }

    lua.pui.ui.lerping = lua.pui.ui.group.main:label('‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾')

    lua.pui.ui.builder_way = '  Builder'
    lua.pui.ui.antiaim_way = '  Antiaim'
    lua.pui.ui.visuals_way = '  Visuals'
    lua.pui.ui.other_way = '  Other'

    lua.pui.onground = false
    lua.pui.ticks = -1
    lua.pui.state = 'Total'
    lua.pui.condition_names = {'Total', 'Standing', 'Moving', 'Walking', 'Creeping', 'Crawling', 'Flying', 'Flying+', 'Using'}
    lua.pui.ui.conditions = {}
    lua.pui.ui.state = lua.pui.ui.group.main:combobox('  Statement', lua.pui.condition_names):depend( {lua.pui.ui.selectab.group, lua.pui.ui.builder_way} )
    lua.pui.ui.statep = lua.pui.ui.group.main:label('\n probel suka'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.builder_way} )
    for i, name in pairs(lua.pui.condition_names) do
        lua.pui.ui.conditions[name] = {
            override = lua.pui.ui.group.main:checkbox('  Change to '..name),
            yaw = lua.pui.ui.group.main:slider('Yaw \n'..name, -180, 180, 0, true, '°'),
            modifier = lua.pui.ui.group.main:combobox('  Modifier\n'..name, {'-', 'Switch', 'X-Ways'}),
            modulate = lua.pui.ui.group.main:combobox('\n   Modifier modulate '..name, {'Static', 'Random', 'Spray'}),
            spin = lua.pui.ui.group.main:combobox('\n   Modifier modulate spin'..name, {'Negative', 'Positive'}),
            ways = lua.pui.ui.group.main:slider('\n -  X-Ways'..name, 3, 12, 0, true, 'w'),
            modrag = lua.pui.ui.group.main:slider('\n Modifier modulate yaw -'..name, -120, 0, 0, true, '°'),
            modrag2 = lua.pui.ui.group.main:slider('\n Modifier modulate yaw +'..name, 0, 120, 0, true, '°'),
            desync = lua.pui.ui.group.main:combobox('  Desync\n'..name, {'-', 'Auto', 'Side'}),
            bodyleft = lua.pui.ui.group.main:slider('\n Desync yaw -'..name, -180, 180, 0, true, '°'),
            bodyright = lua.pui.ui.group.main:slider('\n Desync yaw +'..name, -180, 180, 0, true, '°'),
            lagmode = lua.pui.ui.group.fake:checkbox('Defensive\n'..name),
            lagselect = lua.pui.ui.group.fake:combobox('\nLag compenstation mode'..name, {'-', 'Hittable', 'Always'}),
            lagaa = lua.pui.ui.group.fake:combobox('\nLag compenstation mode aa'..name, {'Off', 'On'}),
            lagpitch = lua.pui.ui.group.fake:combobox('Pitch\nLag compenstation'..name, {'-', 'Static', 'Switch', 'Spray', 'Random'}),
            lagp = lua.pui.ui.group.fake:slider('\n Lag compenstation pitch 1'..name, -89, 89, 89, true, '°'),
            lagpn = lua.pui.ui.group.fake:slider('\n Lag compenstation pitch 2'..name, -89, 89, 89, true, '°'),
            lagyaw = lua.pui.ui.group.fake:combobox('Yaw\nLag compenstation'..name, {'-', 'Static', 'Switch', 'Spray', 'Random'}),
            lagy = lua.pui.ui.group.fake:slider('\n Lag compenstation yaw 1'..name, -180, 180, 0, true, '°'),
            lagyn = lua.pui.ui.group.fake:slider('\n Lag compenstation yaw 2'..name, -180, 180, 0, true, '°'),
            lagfr = lua.pui.ui.group.fake:checkbox('Freestand\n Lag compenstation yaw fr'..name),
            randomize = lua.pui.ui.group.other:slider('Randomize\n'..name, 0, 100, 0, true, '%'),
            dstart = lua.pui.ui.group.other:slider('Defensive start\n'..name, 0, 10, 1, true, 't'),
            spray = lua.pui.ui.group.other:slider('Spray speed\n'..name, 1, 5, 3, true, 't'),
            delay = lua.pui.ui.group.other:slider('Delay tick\n'..name, 1, 10, 1, true, 't')
        }
    end

    lua.pui.ui.antiaim = {
        onshot = lua.pui.ui.group.fake:checkbox('Avoid on shot'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        onshotex = lua.pui.ui.group.fake:checkbox('Untrust exploit [Beta]'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        roll = lua.pui.ui.group.main:checkbox('Roll yaw', 0x00):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        rollyaw = lua.pui.ui.group.main:slider('\n Rolly', -45, 45, 0, true, '°'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        brute = lua.pui.ui.group.main:checkbox('Brute force'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        backstab = lua.pui.ui.group.main:checkbox('Backstab'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        backdist = lua.pui.ui.group.main:slider('\n Backstab distance', 350, 450, 425, true, 'd'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        safehead = lua.pui.ui.group.main:checkbox('Safe health'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        epeek = lua.pui.ui.group.main:checkbox('Zero side peeking'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        l4 = lua.pui.ui.group.main:label('\naAdditive'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        manualm = lua.pui.ui.group.main:hotkey('⮀  Override yaw', false, 0):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        manuall = lua.pui.ui.group.main:hotkey('  Left', false, 0):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        manualr = lua.pui.ui.group.main:hotkey('  Right', false, 0):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        manualsr = lua.pui.ui.group.main:hotkey(' ⃓    Reset', false, 0):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        freestand = lua.pui.ui.group.main:hotkey('↲↳  Freestand'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} ),
        edgeyaw = lua.pui.ui.group.main:hotkey('↻  Edge yaw'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.antiaim_way} )
    }

    lua.pui.ui.visuals = {
        vgui = lua.pui.ui.group.main:checkbox('VGUI Color', {255}):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        obscuration = lua.pui.ui.group.main:checkbox('Obscuration'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        watermark = lua.pui.ui.group.main:checkbox('Watermark'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        watopt2 = lua.pui.ui.group.main:combobox('\n sWatermark2', {'Text', 'Icon'}):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        indicator = lua.pui.ui.group.main:checkbox('Indicator'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        indslide = lua.pui.ui.group.main:slider('\npxIndicator', 5, 170, 40, true, 'px'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        manuals = lua.pui.ui.group.main:checkbox('Manuals'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        manualss = lua.pui.ui.group.main:combobox('\n smn', {'L / R & Hit', 'Override yaw'}):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        viesc = lua.pui.ui.group.fake:checkbox('Show viewmodel while scoped'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        viesca = lua.pui.ui.group.fake:checkbox('Scope changes'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        vief = lua.pui.ui.group.fake:checkbox('Override viewmodel FOV'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        viefs = lua.pui.ui.group.fake:slider('\nViewmodel f', 20, 100, cvar.viewmodel_fov:get_float(), true, '°'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        viewm = lua.pui.ui.group.fake:checkbox('Override viewmodel position'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        viewx = lua.pui.ui.group.fake:slider('\nViewmodel x', -250, 250, 0, true, '°', 0.1):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        viewy = lua.pui.ui.group.fake:slider('\nViewmodel y', -250, 250, 0, true, '°', 0.1):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        viewz = lua.pui.ui.group.fake:slider('\nViewmodel z', -250, 250, 0, true, '°', 0.1):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        aspectratio = lua.pui.ui.group.fake:checkbox('Override aspect ratio'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        aspc = lua.pui.ui.group.fake:slider('\nAspectr', 80, 200, 130, true, '', 0.01):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        thirdpers = lua.pui.ui.group.fake:checkbox('Force third person'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        thirds = lua.pui.ui.group.fake:checkbox('Key changes'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        thrdst = lua.pui.ui.group.fake:slider('\nFTPs', 35, 200, cvar.cam_idealdist:get_int(), true, 'in'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        infowar_on = lua.pui.ui.group.main:checkbox('Information screen'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        infowar_add = lua.pui.ui.group.main:checkbox('Additive'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} ),
        infowar = lua.pui.ui.group.main:multiselect('\nIS', {'Min. Damage', 'Over. Damage', 'Hit. Chance'}):depend( {lua.pui.ui.selectab.group, lua.pui.ui.visuals_way} )
    }

    lua.pui.ui.other = {
        quis = lua.pui.ui.group.main:checkbox('Air stop', 0x00):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        rfix = lua.pui.ui.group.main:checkbox('Exploit fix'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        qswitch = lua.pui.ui.group.main:checkbox('Quick switch'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        qsmod = lua.pui.ui.group.main:multiselect('\nQS', {'Grenades', 'Zeus'}):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        logs = lua.pui.ui.group.main:checkbox('Unlock logs'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        lmod = lua.pui.ui.group.main:multiselect('\nLM', {'Output', 'Hit', 'Miss'}):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        ladder = lua.pui.ui.group.main:checkbox('Ladder addition'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        ladderc = lua.pui.ui.group.main:combobox('\n cLadder addition', {'-', 'Auto'}):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        airbr = lua.pui.ui.group.other:checkbox('Aerobic animation'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        airwlk = lua.pui.ui.group.other:checkbox('Walk in air'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        airbrs = lua.pui.ui.group.other:slider('\nAEA', 1, 100, 100, true, '%'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        grbr = lua.pui.ui.group.other:checkbox('Ground animation'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        grbrs = lua.pui.ui.group.other:slider('\nGRA', 1, 100, 100, true, '%'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        leanbr = lua.pui.ui.group.other:checkbox('Lean animation'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        leanbrs = lua.pui.ui.group.other:slider('\nLBR', 1, 100, 100, true, '%'):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
    }

    lua.pui.ui.antiaim.rollyaw:depend( { lua.pui.ui.antiaim.roll, true } )

    lua.pui.ui.other.qsmod:depend( { lua.pui.ui.other.qswitch, true } )
    lua.pui.ui.other.lmod:depend( { lua.pui.ui.other.logs, true } )

    lua.pui.ui.visuals.viesca:depend( { lua.pui.ui.visuals.viesc, true } )
    lua.pui.ui.visuals.viefs:depend( { lua.pui.ui.visuals.vief, true } )
    lua.pui.ui.visuals.viewx:depend( { lua.pui.ui.visuals.viewm, true } )
    lua.pui.ui.visuals.viewy:depend( { lua.pui.ui.visuals.viewm, true } )
    lua.pui.ui.visuals.viewz:depend( { lua.pui.ui.visuals.viewm, true } )

    lua.pui.ui.visuals.thrdst:depend( { lua.pui.ui.visuals.thirdpers, true } )
    lua.pui.ui.visuals.thirds:depend( { lua.pui.ui.visuals.thirdpers, true } )

    lua.pui.ui.visuals.aspc:depend( { lua.pui.ui.visuals.aspectratio, true } )

    lua.pui.ui.visuals.infowar_add:depend( { lua.pui.ui.visuals.infowar_on, true } )
    lua.pui.ui.visuals.infowar:depend( { lua.pui.ui.visuals.infowar_on, true } )

    lua.pui.ui.visuals.watermark:depend( { lua.pui.ui.visuals.indicator, false } )
    lua.pui.ui.visuals.watopt2:depend( { lua.pui.ui.visuals.watermark, true }, { lua.pui.ui.visuals.indicator, false } )

    lua.pui.ui.visuals.indslide:depend( { lua.pui.ui.visuals.indicator, true } )

    lua.pui.ui.visuals.manualss:depend( { lua.pui.ui.visuals.manuals, true } )

    lua.pui.ui.antiaim.backdist:depend( { lua.pui.ui.antiaim.backstab, true } )
    lua.pui.ui.other.ladderc:depend( { lua.pui.ui.other.ladder, true } )

    lua.pui.ui.other.airbrs:depend( { lua.pui.ui.other.airbr, true } )
    lua.pui.ui.other.airwlk:depend( { lua.pui.ui.other.airbr, true } )
    lua.pui.ui.other.leanbrs:depend( { lua.pui.ui.other.leanbr, true } )
    lua.pui.ui.other.grbrs:depend( { lua.pui.ui.other.grbr, true } )

    local set_visible = function ()
        local selected_state = lua.pui.ui.state:get()

        for i, name in pairs(lua.pui.condition_names) do
            local enabled = name == selected_state
            local overriden = i == 1 or lua.pui.ui.conditions[name].override:get()
            local modi = lua.pui.ui.conditions[name].modifier:get() ~= '-'
            local modifier = lua.pui.ui.conditions[name].modifier:get() ~= '-' and lua.pui.ui.conditions[name].modifier:get() ~= 'X-Ways'
            local spin = lua.pui.ui.conditions[name].modulate:get() == 'Spray'
            local body = lua.pui.ui.conditions[name].desync:get() == 'Side'
            local ways = lua.pui.ui.conditions[name].modifier:get() == 'X-Ways'
            local lag = lua.pui.ui.conditions[name].lagmode:get()
            local lagaa = lua.pui.ui.conditions[name].lagaa:get() ~= 'Off'
            local lagm = lua.pui.ui.conditions[name].lagselect:get() ~= '-'
            local lcp = lua.pui.ui.conditions[name].lagpitch:get() ~= '-'
            local lcy = lua.pui.ui.conditions[name].lagyaw:get() ~= '-'
            local lcyn = lua.pui.ui.conditions[name].lagyaw:get() ~= 'Static'
            local lchk = lua.pui.ui.conditions[name].lagpitch:get() ~= 'Static'
            lua.pui.ui.conditions[name].override:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and i > 1)
            lua.pui.ui.conditions[name].yaw:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden)
            lua.pui.ui.conditions[name].modifier:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden)
            lua.pui.ui.conditions[name].modulate:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and modifier)
            lua.pui.ui.conditions[name].spin:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and modifier and spin)
            lua.pui.ui.conditions[name].ways:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and ways)
            lua.pui.ui.conditions[name].modrag:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and modi and not ways)
            lua.pui.ui.conditions[name].modrag2:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and modi)
            lua.pui.ui.conditions[name].desync:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden)
            lua.pui.ui.conditions[name].bodyleft:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and body)
            lua.pui.ui.conditions[name].bodyright:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and body)
            lua.pui.ui.conditions[name].randomize:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden)
            lua.pui.ui.conditions[name].dstart:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden)
            lua.pui.ui.conditions[name].delay:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden)
            lua.pui.ui.conditions[name].spray:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden)
            lua.pui.ui.conditions[name].lagmode:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden)
            lua.pui.ui.conditions[name].lagaa:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and lag and lagm)
            lua.pui.ui.conditions[name].lagselect:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and lag)
            lua.pui.ui.conditions[name].lagpitch:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and lagaa and lag and lagm)
            lua.pui.ui.conditions[name].lagp:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and lagaa and lag and lagm and lcp)
            lua.pui.ui.conditions[name].lagpn:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and lagaa and lag and lagm and lcp and lchk)
            lua.pui.ui.conditions[name].lagyaw:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and lagaa and lag and lagm)
            lua.pui.ui.conditions[name].lagy:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and lagaa and lag and lcy and lagm)
            lua.pui.ui.conditions[name].lagfr:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and lagaa and lag and lcy and lagm)
            lua.pui.ui.conditions[name].lagyn:set_visible(lua.pui.ui.selectab.group:get() == lua.pui.ui.builder_way and enabled and overriden and lagaa and lag and lcy and lagm and lcyn)
        end
    end
    client.set_event_callback('paint_ui', set_visible)

    local config = {lua.pui.ui.conditions, lua.pui.ui.antiaim, lua.pui.ui.visuals, lua.pui.ui.other}
    local package, data, encrypted, decrypted = pui.setup(config)

    lua.pui.ui.export = function ()
        data = package:save()
        encrypted = base64.encode(json.stringify(data))
        clipboard.set(encrypted)
    end

    lua.pui.ui.import = function (input)
        decrypted = json.parse(base64.decode(input ~= nil and input or clipboard.get()))
        package:load(decrypted)
    end

    local cfg = 'W3siVG90YWwiOnsibGFncGl0Y2giOiItIiwiYm9keWxlZnQiOjAsImRlc3luYyI6Ii0iLCJsYWd5YXciOiItIiwibGFncG4iOjg5LCJsYWdhYSI6Ik9mZiIsInNwaW4iOiJOZWdhdGl2ZSIsImRlbGF5IjoxLCJtb2R1bGF0ZSI6IlN0YXRpYyIsIm92ZXJyaWRlIjpmYWxzZSwibGFnbW9kZSI6ZmFsc2UsIm1vZHJhZyI6MCwibGFneW4iOjAsInlhdyI6MCwibGFnZnIiOmZhbHNlLCJyYW5kb21pemUiOjAsImJvZHlyaWdodCI6MCwic3ByYXkiOjMsImxhZ3NlbGVjdCI6Ii0iLCJtb2RpZmllciI6Ii0iLCJ3YXlzIjozLCJsYWdwIjo4OSwibGFneSI6MH0sIkZseWluZysiOnsibGFncGl0Y2giOiJTcHJheSIsImJvZHlsZWZ0IjotMTgwLCJkZXN5bmMiOiJTaWRlIiwibGFneWF3IjoiU3dpdGNoIiwibGFncG4iOi0yOSwibGFnYWEiOiJPbiIsInNwaW4iOiJOZWdhdGl2ZSIsImRlbGF5IjoxLCJtb2R1bGF0ZSI6IlN0YXRpYyIsIm92ZXJyaWRlIjp0cnVlLCJsYWdtb2RlIjp0cnVlLCJtb2RyYWciOjAsImxhZ3luIjoxMDEsInlhdyI6MCwibGFnZnIiOmZhbHNlLCJyYW5kb21pemUiOjUsImJvZHlyaWdodCI6MTgwLCJzcHJheSI6MywibGFnc2VsZWN0IjoiQWx3YXlzIiwibW9kaWZpZXIiOiItIiwid2F5cyI6MywibGFncCI6LTg5LCJsYWd5IjotMTAxfSwiRmx5aW5nIjp7ImxhZ3BpdGNoIjoiU3dpdGNoIiwiYm9keWxlZnQiOi04LCJkZXN5bmMiOiJTaWRlIiwibGFneWF3IjoiU3RhdGljIiwibGFncG4iOjAsImxhZ2FhIjoiT24iLCJzcGluIjoiTmVnYXRpdmUiLCJkZWxheSI6MiwibW9kdWxhdGUiOiJTcHJheSIsIm92ZXJyaWRlIjp0cnVlLCJsYWdtb2RlIjp0cnVlLCJtb2RyYWciOjI3LCJsYWd5biI6MTAwLCJ5YXciOjAsImxhZ2ZyIjp0cnVlLCJyYW5kb21pemUiOjEwLCJib2R5cmlnaHQiOjI5LCJzcHJheSI6MywibGFnc2VsZWN0IjoiQWx3YXlzIiwibW9kaWZpZXIiOiJTd2l0Y2giLCJ3YXlzIjozLCJsYWdwIjotODksImxhZ3kiOi0xMDB9LCJDcmVlcGluZyI6eyJsYWdwaXRjaCI6IlN3aXRjaCIsImJvZHlsZWZ0IjotMTAsImRlc3luYyI6IlNpZGUiLCJsYWd5YXciOiJTdGF0aWMiLCJsYWdwbiI6LTg5LCJsYWdhYSI6Ik9uIiwic3BpbiI6Ik5lZ2F0aXZlIiwiZGVsYXkiOjIsIm1vZHVsYXRlIjoiU3ByYXkiLCJvdmVycmlkZSI6dHJ1ZSwibGFnbW9kZSI6dHJ1ZSwibW9kcmFnIjo1MywibGFneW4iOjAsInlhdyI6MCwibGFnZnIiOmZhbHNlLCJyYW5kb21pemUiOjAsImJvZHlyaWdodCI6MjIsInNwcmF5IjozLCJsYWdzZWxlY3QiOiJBbHdheXMiLCJtb2RpZmllciI6IlN3aXRjaCIsIndheXMiOjMsImxhZ3AiOi0yMCwibGFneSI6MH0sIlVzaW5nIjp7ImxhZ3BpdGNoIjoiLSIsImJvZHlsZWZ0IjowLCJkZXN5bmMiOiItIiwibGFneWF3IjoiLSIsImxhZ3BuIjo4OSwibGFnYWEiOiJPZmYiLCJzcGluIjoiTmVnYXRpdmUiLCJkZWxheSI6MSwibW9kdWxhdGUiOiJTdGF0aWMiLCJvdmVycmlkZSI6ZmFsc2UsImxhZ21vZGUiOmZhbHNlLCJtb2RyYWciOjAsImxhZ3luIjowLCJ5YXciOjAsImxhZ2ZyIjpmYWxzZSwicmFuZG9taXplIjowLCJib2R5cmlnaHQiOjAsInNwcmF5IjozLCJsYWdzZWxlY3QiOiItIiwibW9kaWZpZXIiOiItIiwid2F5cyI6MywibGFncCI6ODksImxhZ3kiOjB9LCJDcmF3bGluZyI6eyJsYWdwaXRjaCI6Ii0iLCJib2R5bGVmdCI6MCwiZGVzeW5jIjoiLSIsImxhZ3lhdyI6Ii0iLCJsYWdwbiI6ODksImxhZ2FhIjoiT2ZmIiwic3BpbiI6Ik5lZ2F0aXZlIiwiZGVsYXkiOjEsIm1vZHVsYXRlIjoiU3RhdGljIiwib3ZlcnJpZGUiOmZhbHNlLCJsYWdtb2RlIjpmYWxzZSwibW9kcmFnIjowLCJsYWd5biI6MCwieWF3IjowLCJsYWdmciI6ZmFsc2UsInJhbmRvbWl6ZSI6MCwiYm9keXJpZ2h0IjowLCJzcHJheSI6MywibGFnc2VsZWN0IjoiLSIsIm1vZGlmaWVyIjoiLSIsIndheXMiOjMsImxhZ3AiOjg5LCJsYWd5IjowfSwiTW92aW5nIjp7ImxhZ3BpdGNoIjoiLSIsImJvZHlsZWZ0IjotMTAsImRlc3luYyI6IlNpZGUiLCJsYWd5YXciOiItIiwibGFncG4iOjg5LCJsYWdhYSI6Ik9mZiIsInNwaW4iOiJOZWdhdGl2ZSIsImRlbGF5IjoxLCJtb2R1bGF0ZSI6IlN0YXRpYyIsIm92ZXJyaWRlIjp0cnVlLCJsYWdtb2RlIjp0cnVlLCJtb2RyYWciOjY2LCJsYWd5biI6MCwieWF3IjowLCJsYWdmciI6ZmFsc2UsInJhbmRvbWl6ZSI6NSwiYm9keXJpZ2h0IjozOCwic3ByYXkiOjMsImxhZ3NlbGVjdCI6IkhpdHRhYmxlIiwibW9kaWZpZXIiOiJTd2l0Y2giLCJ3YXlzIjozLCJsYWdwIjo4OSwibGFneSI6MH0sIldhbGtpbmciOnsibGFncGl0Y2giOiJTcHJheSIsImJvZHlsZWZ0IjotNSwiZGVzeW5jIjoiU2lkZSIsImxhZ3lhdyI6IlJhbmRvbSIsImxhZ3BuIjo4OSwibGFnYWEiOiJPbiIsInNwaW4iOiJOZWdhdGl2ZSIsImRlbGF5IjoxLCJtb2R1bGF0ZSI6IlNwcmF5Iiwib3ZlcnJpZGUiOnRydWUsImxhZ21vZGUiOnRydWUsIm1vZHJhZyI6NDEsImxhZ3luIjozNjAsInlhdyI6MCwibGFnZnIiOmZhbHNlLCJyYW5kb21pemUiOjUsImJvZHlyaWdodCI6MjQsInNwcmF5IjozLCJsYWdzZWxlY3QiOiJBbHdheXMiLCJtb2RpZmllciI6Ik9mZnNldCIsIndheXMiOjMsImxhZ3AiOi04OSwibGFneSI6LTM2MH0sIlN0YW5kaW5nIjp7ImxhZ3BpdGNoIjoiLSIsImJvZHlsZWZ0IjotNjEsImRlc3luYyI6IlNpZGUiLCJsYWd5YXciOiItIiwibGFncG4iOjg5LCJsYWdhYSI6Ik9mZiIsInNwaW4iOiJOZWdhdGl2ZSIsImRlbGF5IjozLCJtb2R1bGF0ZSI6IlNwcmF5Iiwib3ZlcnJpZGUiOnRydWUsImxhZ21vZGUiOmZhbHNlLCJtb2RyYWciOjUyLCJsYWd5biI6MCwieWF3IjoyLCJsYWdmciI6ZmFsc2UsInJhbmRvbWl6ZSI6NSwiYm9keXJpZ2h0Ijo4OSwic3ByYXkiOjMsImxhZ3NlbGVjdCI6Ii0iLCJtb2RpZmllciI6IlN3aXRjaCIsIndheXMiOjEyLCJsYWdwIjo4OSwibGFneSI6MH19LHsiYmFja3N0YWIiOnRydWUsImJydXRlIjp0cnVlLCJlZGdleWF3IjpbMSwxOCwifiJdLCJmcmVlc3RhbmQiOlsyLDY3LCJ+Il0sIm1hbnVhbHNyIjpbMSwwLCJ+Il0sIm1hbnVhbHIiOlsxLDg4LCJ+Il0sImJhY2tkaXN0Ijo0MjUsInNhZmVoZWFkIjp0cnVlLCJtYW51YWxtIjpbMSwwLCJ+Il0sIm1hbnVhbGwiOlsxLDkwLCJ+Il19LHsiaW5kaWNhdG9yIjpmYWxzZSwiaW5mb3dhciI6WyJPdmVyLiBEYW1hZ2UiLCJ+Il0sIm1hbnVhbHNzIjoiTCBcLyBSICYgSGl0Iiwid2F0b3B0IjoiLSIsIndhdGVybWFyayI6dHJ1ZSwiaW5mb3dhcl9vbiI6dHJ1ZSwiaW5mb3dhcl9hZGQiOmZhbHNlLCJvYnNjdXJhdGlvbiI6dHJ1ZSwiaW5kc2xpZGUiOjQwLCJtYW51YWxzIjp0cnVlfSx7ImxvZ3MiOnRydWUsInFzbW9kIjpbIkdyZW5hZGVzIiwiWmV1cyIsIn4iXSwicmZpeCI6dHJ1ZSwibG1vZCI6WyJPdXRwdXQiLCJIaXQiLCJNaXNzIiwifiJdLCJxc3dpdGNoIjp0cnVlfV0='

    lua.pui.ui.config = {
        export = lua.pui.ui.group.fake:button('Export', function ()
            lua.pui.ui.export()
        end):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        import = lua.pui.ui.group.fake:button('Import', function ()
            lua.pui.ui.import()
        end):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} ),
        default = lua.pui.ui.group.fake:button('Settings', function ()
            lua.pui.ui.import(cfg)
        end):depend( {lua.pui.ui.selectab.group, lua.pui.ui.other_way} )
    }
end

--endregion

--endregion

--region events

local events = {}
events.set_callback = function (reference, event, functions)
    reference:set_callback(function (this)
        local callback = this:get() and client.set_event_callback or client.unset_event_callback
        callback(event, functions)
        this:unset_callback(functions)

        --client.set_event_callback('shutdown', functions)
    end)
end
events.set_paint = function (functions)
    local callback = client.set_event_callback
    callback('paint_ui', functions)--function ()
        --if lerp == nil then
        --    error('set_paint:audit_event[lerp == nil]')
        --    goto unset
        --end

        --functions()
        --::unset::
    --end)
    --client.set_event_callback('shutdown', functions)
end

--endregion

--region helps

lua.helps = {} do
    local normalize = function (x, min, max)
        local delta = max - min

        while x < min do
            x = x + delta
        end

        while x > max do
            x = x - delta
        end

        return x
    end
    lua.helps.normalize_pitch = function (x)
        return normalize(x, -89, 89)
    end
    lua.helps.normalize_yaw = function (x)
        return normalize(x, -180, 180)
    end
    lua.helps.calc_angle = function (a, b)
        local x_delta = b.x - a.x
        local y_delta = b.y - a.y
        local z_delta = b.z - a.z 
        local hyp = math.sqrt(x_delta^2 + y_delta^2)
        local x = math.atan2(z_delta, hyp) * 57.295779513082
        local y = math.atan2(y_delta , x_delta) * 180 / 3.14159265358979323846
        return { x = lua.helps.normalize_yaw(x, 90), y = lua.helps.normalize_yaw(y, 180), z = 0 }
    end
    lua.helps.get_freestand = function(p)
        local enemy = client.current_threat()
        if not enemy then return end

        local is_fs = false
        local is_dynamic = lua.reference.antiaim.angles.yaw_base:get() == 'At targets'
        local player_origin = vector(entity.get_origin(p))
        local ent_origin = vector(entity.get_origin(enemy))
        local yaw_base = is_dynamic and lua.helps.calc_angle(player_origin, ent_origin).y or vector(client.camera_angles()).y
        local yaw = yaw_base + lua.reference.antiaim.angles.yaw[2]:get()
        local fs_yaw = lua.helps.normalize_yaw(entity.get_prop(p, 'm_angEyeAngles[1]') - 180, 180)
        local diff = math.abs(yaw - fs_yaw)
        is_fs = diff > 50 and diff < 300
        return is_fs
    end
    lua.helps.get_freestand_direction = function(p)
        local data = {
            side = 1,
            last_side = 0,
            last_hit = 0,
            hit_side = 0
        }

        if not p or entity.get_prop(p, 'm_lifeState') ~= 0 then
            return
        end

        if data.hit_side ~= 0 and globals.curtime() - data.last_hit > 5 then
            data.last_side = 0
            data.last_hit = 0
            data.hit_side = 0
        end

        local eye = vector(client.eye_position())
        local ang = vector(client.camera_angles())
        local trace_data = {left = 0, right = 0}

        for i = ang.y - 120, ang.y + 120, 30 do
            if i ~= ang.y then
                local rad = math.rad(i)
                local px, py, pz = eye.x + 256 * math.cos(rad), eye.y + 256 * math.sin(rad), eye.z
                local fraction = client.trace_line(p, eye.x, eye.y, eye.z, px, py, pz)
                local side = i < ang.y and 'left' or 'right'
                trace_data[side] = trace_data[side] + fraction
            end
        end

        data.side = trace_data.left < trace_data.right and -1 or 1

        if data.side == data.last_side then
            return
        end

        data.last_side = data.side

        if data.hit_side ~= 0 then
            data.side = data.hit_side
        end

        if data.side == nil then
            data.side = 1
        end

        return data.side
    end
    lua.helps.usercmd_ticks = function (wish_ticks)
        local game_rules = entity.get_game_rules()
        local is_valve_ds =
            entity.get_prop(game_rules, 'm_bIsValveDS') == 1 or
            entity.get_prop(game_rules, 'm_bIsQueuedMatchmaking') == 1

        local _iTicksAllowed = is_valve_ds and 6 or lua.reference.rage.binds.usercmd:get() - 2

        return wish_ticks and math.min(_iTicksAllowed, wish_ticks) or _iTicksAllowed
    end
    lua.helps.hittable = function()
        local enemy = entity.get_players(true)
        if not enemy then return end
        for w, n in ipairs(enemy) do
            if entity.is_alive(n) and not entity.is_dormant(n) then
                local esp = entity.get_esp_data(n).flags or 0
                if bit.band(esp, bit.lshift(1, 11)) ~= 0 then
                    return true
                else
                    return false
                end
            else
                return false
            end
        end
        return false
    end
    lua.helps.height = function(cmd)
        local me = entity.get_local_player()
        local enemy = client.current_threat()
        if not enemy or entity.is_dormant(enemy) then return end
        local oren = { entity.get_origin(enemy) }
        local orme = { entity.get_origin(me) }
        local wme = entity.get_player_weapon(me)
        if not lua.helps.hittable() then
            return false
        end
        if orme[3] > oren[3] + 55 and (vector(entity.get_prop(me, 'm_vecVelocity')):length2d() <= 60 or cmd.in_duck == 1) or cmd.in_duck == 1 and entity.get_classname(wme) == 'CKnife' then
            return true
        end
        return false
    end
    lua.helps.backstab = function()
        local me = entity.get_local_player()
        local enemy = client.current_threat()
        local stab = false
        if not enemy or entity.is_dormant(enemy) then
            stab = false
            return
        end
        local origin = { entity.get_origin(enemy) }
        local viewofs = { entity.get_prop(enemy, 'm_vecViewOffset') }
        local eyepos = { client.eye_position() }
        local ds = { origin[1] + viewofs[1], origin[2] + viewofs[2], origin[3] + viewofs[3] }
        local cnt = { math.abs(ds[1] - eyepos[1]), math.abs(ds[2] - eyepos[2]), math.abs(ds[3] - eyepos[3]) }
        local dst = math.abs(cnt[1] + cnt[2])
        if dst > lua.pui.ui.antiaim.backdist:get() then
            stab = false
            return
        end
        local vel = { entity.get_prop(me, 'm_vecVelocity') }
        local vele = { entity.get_prop(enemy, 'm_vecVelocity') }
        local interval = globals.tickinterval() * 16
        local cnd = { eyepos[1] + vel[1] * interval, eyepos[2] + vel[2] * interval, eyepos[3] + vel[3] * interval }
        local cndi = { ds[1] + vele[1] * interval, ds[2] + vele[2] * interval, ds[3] + vele[3] * interval }
        local v, n = client.trace_line(me, cnd[1], cnd[2], cnd[3], cndi[1], cndi[2], cndi[3])
        local k, m = client.trace_line(me, cndi[1], cndi[2], cndi[3], cnd[1], cnd[2], cnd[3])
        local c, s = client.trace_line(me, eyepos[1], eyepos[2], eyepos[3], ds[1], ds[2], ds[3])
        local p, t = client.trace_line(me, eyepos[1], eyepos[2], eyepos[3], origin[1], origin[2], origin[3])
        local oc = n == enemy or v == 1
        local po = m == me or k == 1
        local to = s == enemy or c == 1
        local vo = t == enemy or p == 1
        local zx = entity.get_player_weapon(enemy)

        stab = entity.get_classname(zx) == 'CKnife' and (oc or po or to or vo)
        return stab
    end
    lua.helps.max_tickbase = 0
    lua.helps.on_level_init = function()
        local me = entity.get_local_player()
        if not me then return 0 end
        local tickbase = entity.get_prop(me, 'm_nTickBase')

        if math.abs(tickbase - lua.helps.max_tickbase) > 64 then
            lua.helps.max_tickbase = 0
        end

        local defensive_ticks_left = 0

        if tickbase > lua.helps.max_tickbase then
            lua.helps.max_tickbase = tickbase
        elseif lua.helps.max_tickbase > tickbase then
            defensive_ticks_left = math.min(14, math.max(0, lua.helps.max_tickbase - tickbase - 1))
        end
        return defensive_ticks_left
    end
    client.set_event_callback('level_init', function ()
        lua.helps.max_tickbase = 0
    end)
end

--endregion

--region prestart features

lua.prestart = {} do
    lua.prestart.work = function ()
        lua.reference.antiaim.angles.enabled:set(true)
        lua.antiaim.anti_brute = 0
        lua.antiaim.hitted_tick = 0
        lua.antiaim.brute_miss = 0
        cvar.clear:invoke_callback()
        cvar.developer:set_int(0)
        cvar.con_filter_enable:set_raw_int(1)
        cvar.con_filter_text:set_string('IrWL5106TZZKNFPz4P4Gl3pSN?J370f5hi373ZjPg%VOVh6lN')
        cvar.sv_teamid_overhead:set_raw_float(0)
        cvar.sv_airaccelerate:set_raw_float(100)
        cvar.snd_restart:invoke_callback()
    end
    client.set_event_callback('round_prestart', lua.prestart.work)
end

--endregion

--region antiaim

lua.antiaim = {} do
    lua.antiaim.onshot = 0
    lua.antiaim.enabled = false
    lua.antiaim.start_time = globals.realtime()
    lua.antiaim.use_enable = function (cmd)
        lua.antiaim.enabled = false

        if not lua.pui.ui.conditions['Using'].override:get() then
            return
        end

        if cmd.in_use == 0 then
            lua.antiaim.start_time = globals.realtime()
            return
        end

        local player = entity.get_local_player()

        if player == nil then
            return
        end

        local player_origin = { entity.get_origin(player) }

        local CPlantedC4 = entity.get_all('CPlantedC4')
        local dist_to_bomb = 999

        if #CPlantedC4 > 0 then
            local bomb = CPlantedC4[1]
            local bomb_origin = { entity.get_origin(bomb) }

            dist_to_bomb = vector(player_origin[1], player_origin[2], player_origin[3]):dist(vector(bomb_origin[1], bomb_origin[2], bomb_origin[3]))
        end

        local CHostage = entity.get_all('CHostage')
        local dist_to_hostage = 999

        if CHostage ~= nil then
            if #CHostage > 0 then
                local hostage_origin = {entity.get_origin(CHostage[1])}

                dist_to_hostage = math.min(vector(player_origin[1], player_origin[2], player_origin[3]):dist(vector(hostage_origin[1], hostage_origin[2], hostage_origin[3])), vector(player_origin[1], player_origin[2], player_origin[3]):dist(vector(hostage_origin[1], hostage_origin[2], hostage_origin[3])))
            end
        end

        if dist_to_hostage < 65 and entity.get_prop(player, 'm_iTeamNum') ~= 2 then
            return
        end

        if dist_to_bomb < 65 and entity.get_prop(player, 'm_iTeamNum') ~= 2 then
            return
        end

        if cmd.in_use then
            if globals.realtime() - lua.antiaim.start_time < 0.02 then
                return
            end
        end

        cmd.in_use = false
        lua.antiaim.enabled = true
    end
    lua.antiaim.brute_miss = 0
    lua.antiaim.anti_brute = 0
    lua.antiaim.hitted_tick = 0
    lua.antiaim.brute = function (e)
        if not lua.pui.ui.antiaim.brute:get() then lua.antiaim.brute_miss = 0 lua.antiaim.anti_brute = 0 lua.antiaim.hitted_tick = 0 return end
        local me = entity.get_local_player()
        if not entity.is_alive(me) or lua.antiaim.hitted_tick == globals.tickcount() then
            return
        end

        local entity_fire = client.current_threat()
        if not entity_fire or entity.is_dormant(entity_fire) then
            return
        end

        local impact_origin = vector(e.x, e.y, e.z)
        local entity_origin = vector(entity.get_origin(entity_fire))
        local head_pos = vector(entity.hitbox_position(me, 0))
        local closest_point = math.closest_ray_point(head_pos, entity_origin, impact_origin)
        local dist = head_pos:dist(closest_point)

        if dist > 80 then
            return
        end

        lua.antiaim.brute_miss = lua.antiaim.brute_miss + 1
        lua.antiaim.anti_brute = math.random(-1,1)
        lua.antiaim.hitted_tick = globals.tickcount()
    end
    lua.antiaim.ticks = 0
    lua.antiaim.state = function ()
        local me = entity.get_local_player()
        if not me then
            return 'Total'
        end

        local first_velocity, second_velocity = entity.get_prop(me, 'm_vecVelocity')
        lua.antiaim.speed = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))

        if entity.get_prop(me, 'm_hGroundEntity') == 0 then
            lua.antiaim.ticks = lua.antiaim.ticks + 1
        else
            lua.antiaim.ticks = 0
        end

        lua.antiaim.onground = lua.antiaim.ticks >= 32

        if lua.antiaim.enabled and lua.pui.ui.conditions['Using'].override:get() then
            return 'Using'
        end

        if not lua.antiaim.onground then
            if entity.get_prop(me, 'm_flDuckAmount') == 1 and lua.pui.ui.conditions['Flying+'].override:get() then
                return 'Flying+'
            end

            return 'Flying'
        end

        if entity.get_prop(me, 'm_flDuckAmount') == 1 then
            if lua.antiaim.speed > 5 and lua.pui.ui.conditions['Crawling'].override:get() then
                return 'Crawling'
            end

            return 'Creeping'
        end

        if lua.reference.antiaim.other.slide[1].hotkey:get() and lua.pui.ui.conditions['Walking'].override:get() then
            return 'Walking'
        end

        if lua.antiaim.speed > 5 then
            return 'Moving'
        end

        return 'Standing'
    end
    lua.antiaim.replace, lua.antiaim.overriding = 0, false
    lua.antiaim.selected_manual = 0
    lua.antiaim.manual = function()
        lua.pui.ui.antiaim.manuall:set('On hotkey')
        lua.pui.ui.antiaim.manualr:set('On hotkey')
        lua.pui.ui.antiaim.manualsr:set('On hotkey')

        local fs = lua.pui.ui.antiaim.freestand:get()

        if lua.antiaim.selected_manual == nil then
            lua.antiaim.selected_manual = 0
        end

        local left_pressed = lua.pui.ui.antiaim.manuall:get()
        if left_pressed and not lua.antiaim.left_pressed then
            if lua.antiaim.selected_manual == 1 then
                lua.antiaim.selected_manual = 0
            else
                lua.antiaim.selected_manual = 1
            end
        end

        local right_pressed = lua.pui.ui.antiaim.manualr:get()
        if right_pressed and not lua.antiaim.right_pressed then
            if lua.antiaim.selected_manual == 2 then
                lua.antiaim.selected_manual = 0
            else
                lua.antiaim.selected_manual = 2
            end
        end

        local reset_pressed = lua.pui.ui.antiaim.manualsr:get()
        if reset_pressed and not lua.antiaim.reset_pressed then
            if lua.antiaim.selected_manual == 3 then
                lua.antiaim.selected_manual = 3
            else
                lua.antiaim.selected_manual = 0
            end
        end

        lua.antiaim.left_pressed = left_pressed
        lua.antiaim.right_pressed = right_pressed
        lua.antiaim.reset_pressed = reset_pressed

        local defensive_tick = lua.helps.on_level_init()

        if lua.antiaim.selected_manual ~= 0 or lua.antiaim.overriding then
            fs = false
        end

        local state = lua.antiaim.state()
        if not lua.pui.ui.conditions[state].override:get() then
            state = 'Total'
        end
        local defe_start = lua.pui.ui.conditions[state].dstart:get()
        if fs == true then
            lua.reference.antiaim.angles.freestanding.hotkey:override('always on')
            if defensive_tick > defe_start and lua.antiaim.defensive_aa == true then
               lua.reference.antiaim.angles.freestanding:override(false)
            else
               lua.reference.antiaim.angles.freestanding:override(fs)
            end
        else
            lua.reference.antiaim.angles.freestanding:override(false)
        end
    end
    lua.antiaim.override_yaw = function ()
        local me = entity.get_local_player()
        if me and lua.pui.ui.antiaim.manualm:get() then
            if not lua.antiaim.overriding and math.side ~= 0 then
                lua.antiaim.replace, lua.antiaim.overriding = math.side, true
            end
        else
            lua.antiaim.replace, lua.antiaim.overriding = 0, false
        end

        return lua.antiaim.replace, lua.antiaim.overriding
    end
    client.set_event_callback('paint_ui', lua.antiaim.override_yaw)
    lua.antiaim.set_invert = false
    lua.antiaim.set_tick = 0
    lua.antiaim.get_invert = function (ref, cmd)
        local me = entity.get_local_player()
        if not me then return end

        if globals.tickcount() > lua.antiaim.set_tick + ref then
            if cmd.chokedcommands == 0 then
                lua.antiaim.set_invert = not lua.antiaim.set_invert
                lua.antiaim.set_tick = globals.tickcount()
            end
        end

        if globals.tickcount() < lua.antiaim.set_tick then
            lua.antiaim.set_tick = globals.tickcount()
        end

        return lua.antiaim.set_invert
    end
    lua.antiaim.main = function (cmd)
        local me = entity.get_local_player()
        if not me then return end
        local state = lua.antiaim.state()
        if not lua.pui.ui.conditions[state].override:get() then
            state = 'Total'
        end
        if lua.antiaim.speed < 5 then
            cmd.in_speed = 1
        end
        local direction = lua.helps.get_freestand_direction(me)
        local defensive_tick = lua.helps.on_level_init()
        local brute = lua.antiaim.anti_brute
        local base = 'at targets'
        local pitch = 89
        local yaw_base = '180'
        local yaw = 0
        local jitter = 'off'
        local yaw_jitter = 0
        local desync = 'off'
        local desync_limit = 0
        local fs_body = false
        local dt_ready, mode_dt = math.exploit()
        local tick = lua.pui.ui.conditions[state].delay:get()
        local invert = lua.antiaim.get_invert(tick, cmd)
        local yaw_lua = lua.pui.ui.conditions[state].yaw:get()
        local lua_yaw_mod = 0
        local modifier = lua.pui.ui.conditions[state].modifier:get()
        local modulate = lua.pui.ui.conditions[state].modulate:get()
        local spin = lua.pui.ui.conditions[state].spin:get()
        local ways = lua.pui.ui.conditions[state].ways:get()
        local modrag = lua.pui.ui.conditions[state].modrag:get()
        local modrag2 = lua.pui.ui.conditions[state].modrag2:get()
        local bodyyaw = lua.pui.ui.conditions[state].desync:get()
        local bodyleft = lua.pui.ui.conditions[state].bodyleft:get()
        local bodyright = lua.pui.ui.conditions[state].bodyright:get()
        local bodymode = 'off'
        local bodylimit = 0
        local randomize = 0

        local lagmode = lua.pui.ui.conditions[state].lagmode:get()
        local lagselect = lua.pui.ui.conditions[state].lagselect:get()
        local lagyawfr = lua.pui.ui.conditions[state].lagfr:get()
        local lagpitch = lua.pui.ui.conditions[state].lagpitch:get()
        local lag_pitch = lua.pui.ui.conditions[state].lagp:get()
        local lag_pitch2 = lua.pui.ui.conditions[state].lagpn:get()
        local lagyaw = lua.pui.ui.conditions[state].lagyaw:get()
        local lagy = lua.pui.ui.conditions[state].lagy:get()
        local lagyn = lua.pui.ui.conditions[state].lagyn:get()
        local defe_start = lua.pui.ui.conditions[state].dstart:get()
        local dpitch = 89
        local dyaw = 0
        local lagfreestand = 0
        local lagdsy = 0
        local lagdsyl = 0

        local spraydel = lua.pui.ui.conditions[state].spray:get()

        if modifier == 'X-Ways' then
            lua_yaw_mod = math.uway('x-way', -modrag2 * 0.5, modrag2 * 0.5, true, ways)
        end

        if modifier == 'Switch' then
            if modulate == 'Static' then
                if invert then
                    lua_yaw_mod = modrag * 0.5
                else
                    lua_yaw_mod = modrag2 * 0.5
                end
            end

            if modulate == 'Random' then
                if invert then
                    lua_yaw_mod = math.random(modrag) * 0.5
                else
                    lua_yaw_mod = math.random(modrag2) * 0.5
                end
            end

            if modulate == 'Spray' then
                if spin == 'Negative' then
                    if invert then
                        lua_yaw_mod = math.lerping(modrag, 0, globals.curtime() * spraydel % 2 - 1) * 0.5
                    else
                        lua_yaw_mod = math.lerping(modrag2, 0, globals.curtime() * spraydel % 2 - 1) * 0.5
                    end
                else
                    if invert then
                        lua_yaw_mod = math.lerping(0, modrag, globals.curtime() * spraydel % 2 - 1) * 0.5
                    else
                        lua_yaw_mod = math.lerping(0, modrag2, globals.curtime() * spraydel % 2 - 1) * 0.5
                    end
                end
            end
        end

        if bodyyaw == 'Auto' then
            bodymode = 'Static'
            bodylimit = direction
            randomize = direction == -1 and -math.random(lua.pui.ui.conditions[state].randomize:get()) or math.random(lua.pui.ui.conditions[state].randomize:get())
        end

        if bodyyaw == 'Side' then
            bodymode = 'Static'
            if invert then
                bodylimit = bodyleft
            else
                bodylimit = bodyright
            end
            randomize = invert and -math.random(lua.pui.ui.conditions[state].randomize:get()) or math.random(lua.pui.ui.conditions[state].randomize:get())
        end

        lua.antiaim.defensive_aa = false
        local defensive = false
        if lua.helps.backstab() and lua.pui.ui.antiaim.backstab:get() then
            lua.antiaim.defensive_aa = false
            defensive = false
        elseif lua.helps.height(cmd) and lua.pui.ui.antiaim.safehead:get() then
            lua.antiaim.defensive_aa = false
            defensive = defensive
        elseif lagmode and lagselect == 'Hittable' then
            lua.antiaim.defensive_aa = lagselect == 'Hittable' and lua.helps.hittable()
            defensive = lua.helps.hittable()
        elseif lagmode and lagselect == 'Always' then
            lua.antiaim.defensive_aa = true
            defensive = true
        else
            lua.antiaim.defensive_aa = false
            defensive = false
        end

        if lagmode and lagselect ~= '-' and lua.antiaim.defensive_aa == true then

            if lagpitch == '-' then
                dpitch = 89
            end

            if lagpitch == 'Static' then
                dpitch = lag_pitch
            end

            if lagpitch == 'Switch' then
                dpitch = invert and lag_pitch or lag_pitch2
            end

            if lagpitch == 'Spray' then
                dpitch = math.lerping(lag_pitch, lag_pitch2, globals.curtime() * spraydel % 2 - 1) * 0.5
            end

            if lagpitch == 'Random' then
                dpitch = invert and math.random(lag_pitch) or math.random(lag_pitch2)
            end

            if lagpitch == 'Exploit' then
                if cmd.chokedcommands == 0 then
                    dpitch = lag_pitch
                else
                    dpitch = lag_pitch2
                end
            end

            if lagyaw == '-' then
                dyaw = 0
            end

            if lagyaw ~= '-' and lagyawfr then
                lagfreestand = -direction
            else
                lagfreestand = 1
            end

            lagdsyl = 0
            if lagyaw == 'Static' then
                dyaw = lagy + lua_yaw_mod
                lagdsy = 'static'
                lagdsyl = 0
            end

            if lagyaw == 'Switch' then
                dyaw = invert and lagy or lagyn
                lagdsy = 'static'
            end

            if lagyaw == 'Spray' then
                dyaw = math.lerping(lagy, lagyn, globals.curtime() * spraydel % 2 - 1) * 0.5
                lagdsy = 'static'
            end

            if lagyaw == 'Random' then
                dyaw = invert and math.random(lagy) or math.random(lagyn)
                lagdsy = 'off'
            end

        end

        local random_static = 0

        --if invert then
        --    random_static = random_static + math.random(-30, 30)
       -- end

        lua.antiaim.safeh = false

        local _override = lua.antiaim.selected_manual == 0 and lua.antiaim.replace * 90 or 0


        if lua.antiaim.enabled and lua.pui.ui.conditions['Using'].override:get() then
            base = 'local view'
            pitch = 0
            yaw_base = '180'
            yaw = yaw + 180
        end

        if lua.helps.backstab() and lua.pui.ui.antiaim.backstab:get() then
            lua_yaw_mod = 180
            bodymode = 'static'
            bodylimit = 0
        end

        if lua.helps.height(cmd) and lua.pui.ui.antiaim.safehead:get() then
            lua_yaw_mod = 15
            bodymode = 'static'
            bodylimit = 0
            lua.antiaim.safeh = true
        end

        yaw = yaw + _override + yaw_lua + lua_yaw_mod + randomize
        desync_limit = desync_limit + bodylimit
        desync = bodymode

        if lua.antiaim.selected_manual == 0 then
            lua.reference.antiaim.angles.pitch[1]:override('custom')
            if defensive_tick > defe_start and lua.pui.ui.conditions[state].lagaa:get() == 'On' and lagmode and lagselect ~= '-' and lua.antiaim.defensive_aa == true then
                lua.reference.antiaim.angles.pitch[2]:override(lua.helps.normalize_pitch(dpitch))
                lua.reference.antiaim.angles.yaw_base:override(base)
                lua.reference.antiaim.angles.yaw[1]:override(yaw_base)
                if dyaw ~= 0 then
                    lua.reference.antiaim.angles.yaw[2]:override(lua.helps.normalize_yaw(dyaw + random_static + _override + randomize) * lagfreestand)
                    lua.reference.antiaim.angles.yaw_jitter[1]:override('off')
                    lua.reference.antiaim.angles.desync[1]:override(lagdsy)
                    lua.reference.antiaim.angles.desync[2]:override(lagdsyl)
                    lua.reference.antiaim.angles.freestanding_body_yaw:override(false)
                else
                    lua.reference.antiaim.angles.yaw[2]:override(lua.helps.normalize_yaw(yaw + 5 * brute))
                    local fschk = lua.helps.get_freestand(me) == true and lua.pui.ui.antiaim.freestand:get() and lua.reference.antiaim.angles.freestanding:get() and lua.reference.antiaim.angles.freestanding.hotkey:get()
                    lua.reference.antiaim.angles.yaw_jitter[1]:override(fschk and 'off' or jitter)
                    lua.reference.antiaim.angles.yaw_jitter[2]:override(yaw_jitter)
                    lua.reference.antiaim.angles.desync[1]:override(fschk and 'static' or desync)
                    local dir = direction == -1 and -180 or 180
                    lua.reference.antiaim.angles.desync[2]:override(fschk and dir or desync_limit)
                    lua.reference.antiaim.angles.freestanding_body_yaw:override(fschk and false or fs_body)
                end
            else
                lua.reference.antiaim.angles.pitch[2]:override(lua.helps.normalize_pitch(pitch))
                lua.reference.antiaim.angles.yaw_base:override(base)
                lua.reference.antiaim.angles.yaw[1]:override(yaw_base)
                lua.reference.antiaim.angles.yaw[2]:override(lua.helps.normalize_yaw(yaw + 5 * brute))
                local fschk = lua.helps.get_freestand(me) == true and lua.pui.ui.antiaim.freestand:get() and lua.reference.antiaim.angles.freestanding:get() and lua.reference.antiaim.angles.freestanding.hotkey:get()
                lua.reference.antiaim.angles.yaw_jitter[1]:override(fschk and 'off' or jitter)
                lua.reference.antiaim.angles.yaw_jitter[2]:override(yaw_jitter)
                lua.reference.antiaim.angles.desync[1]:override(fschk and 'static' or desync)
                local dir = direction == -1 and -180 or 180
                lua.reference.antiaim.angles.desync[2]:override(fschk and dir or desync_limit)
                lua.reference.antiaim.angles.freestanding_body_yaw:override(fschk and false or fs_body)
            end
            lua.reference.antiaim.angles.edge_yaw:override(lua.antiaim.selected_manual ~= 0 and lua.pui.ui.antiaim.edgeyaw:get() or false)
        end

        cmd.force_defensive = lua.antiaim.selected_manual ~= 0 and lua.helps.hittable() or defensive
        lua.reference.rage.binds.usercmd:override(17)
    end
    lua.antiaim.fakelag = function (cmd)
        local state = lua.antiaim.state()
        local defensive_tick = lua.helps.on_level_init()

        local onshot = lua.antiaim.onshot > globals.curtime()

        if onshot then
            lua.reference.antiaim.fakelag.on[1].hotkey:set('on hotkey')
        elseif state == 'Standing' then
            lua.reference.antiaim.fakelag.on[1].hotkey:set('on hotkey')
        elseif state == 'Creeping' then
            lua.reference.antiaim.fakelag.on[1].hotkey:set('on hotkey')
        elseif state == 'Crawling' then
            lua.reference.antiaim.fakelag.on[1].hotkey:set('on hotkey')
        elseif state == 'Walking' then
            lua.reference.antiaim.fakelag.on[1].hotkey:set('on hotkey')
        else
            lua.reference.antiaim.fakelag.on[1].hotkey:set('always on')
        end
        if onshot and defensive_tick > 1 and lua.pui.ui.antiaim.onshotex:get() then
            cmd.pitch = -300
            cmd.yaw = math.random(360)
        end
    end
    client.set_event_callback('setup_command', lua.antiaim.main)
    lua.antiaim.zeroside = 0
    lua.antiaim.other = function ()
        local me = entity.get_local_player()
        if not me then return end
        if lua.antiaim.selected_manual == 0 then lua.antiaim.zeroside = 0 return end

        local defensive_tick = lua.helps.on_level_init()
        local hittable = lua.helps.hittable()
        local epeek = lua.pui.ui.antiaim.epeek:get()
        lua.antiaim.zeroside = math.lerp(lua.antiaim.zeroside, hittable and epeek and 180 or 0, 0.8)

        local dyaw, dpitch = 0, 1
        if defensive_tick > 0 and hittable and epeek then
            dpitch = 0
            dyaw = math.floor(lua.antiaim.zeroside)
        end

        local base = 'local view'
        local pitch = 89
        local yaw_base = '180'
        local yaw = 0
        local jitter = 'off'
        local desync = 'static'
        local desync_limit = 180
        local fs_body = true

        if lua.antiaim.selected_manual == 1 then
            yaw = dyaw - 90
        end

        if lua.antiaim.selected_manual == 2 then
            yaw = 90 - dyaw
        end

        if lua.helps.backstab() then
            yaw = 180
        end

        lua.reference.antiaim.angles.pitch[1]:override('custom')
        lua.reference.antiaim.angles.pitch[2]:override(pitch * dpitch)
        lua.reference.antiaim.angles.yaw_base:override(base)
        lua.reference.antiaim.angles.yaw[1]:override(yaw_base)
        lua.reference.antiaim.angles.yaw[2]:override(lua.helps.normalize_yaw(yaw))
        lua.reference.antiaim.angles.yaw_jitter[1]:override(jitter)
        lua.reference.antiaim.angles.desync[1]:override(desync)
        lua.reference.antiaim.angles.desync[2]:override(desync_limit)
        lua.reference.antiaim.angles.freestanding_body_yaw:override(fs_body)
    end
    lua.antiaim.roll = function (cmd)
        if not lua.pui.ui.antiaim.roll.hotkey:get() then
            goto ignore
        end
        cmd.roll = lua.pui.ui.antiaim.rollyaw:get()
        ::ignore::
    end
    client.set_event_callback('pre_render', lua.antiaim.manual)
    client.set_event_callback('setup_command', lua.antiaim.fakelag)
    client.set_event_callback('setup_command', lua.antiaim.other)
    client.set_event_callback('setup_command', lua.antiaim.use_enable)
    events.set_callback(lua.pui.ui.antiaim.roll, 'setup_command', lua.antiaim.roll)
    events.set_callback(lua.pui.ui.antiaim.brute, 'bullet_impact', lua.antiaim.brute)
    events.set_callback(lua.pui.ui.antiaim.onshot, 'aim_fire', function ()
        lua.antiaim.onshot = globals.curtime() + 0.3
    end)
    client.set_event_callback('paint_ui', function ()
        lua.reference.hide(lua.pui.ui.selectab.group:get() == lua.pui.ui.antiaim_way)
    end)
end



--endregion

--region menushoot

local shoot = function (cmd)
    if not ui.is_menu_open() then return end
    cmd.in_attack = false
    cmd.in_attack2 = false
end
client.set_event_callback('setup_command', shoot)

--endregion

--region visuals

--region work

lua.visuals = {} do
    lua.visuals.data_hurt = {}
    lua.visuals.hurt = function(e)
        local player = entity.get_local_player()
        if player == nil then
            return
        end

        local victim = client.userid_to_entindex(e.userid)
        if victim == nil then
            return
        end

        local attacker = client.userid_to_entindex(e.attacker)
        if attacker == nil then
            return
        end

        if attacker == player or victim == player then
            table.insert(lua.visuals.data_hurt,
                {
                    position = vector(entity.hitbox_position(victim, e.hitgroup)),
                    damage = e.dmg_health,
                    weapon = e.weapon,
                    alpha_crosshair = 0,
                    time = globals.realtime(),
                }
            )
        end
    end
    events.set_callback(lua.pui.ui.visuals.watermark, 'player_hurt', lua.visuals.hurt)
    lua.visuals.state = 0
    lua.visuals.time = 0
    lua.visuals.time_background = 0
    lua.visuals.time_brand = 0
    lua.visuals.lerp = {
        live = 0,
        frozen = 0,
        velocity = 0,
        exploit = {
            defensive = 0,
            rapid = 0
        },
        manuals = {
            directionl = 0,
            directionr = 0,
            left = 0,
            left = 0,
            right = 0,
            backward = 0,
            forward = 0
        },
        background = 0,
        backstab = 0,
        height = 0,
        hittable = 0,
        hurt = 0,
        ind = 0,
        dt = 0,
        dmgt = 0,
        dmg = 0,
        dmgh = 0,
        fs = 0,
        hc = 0,
        aa = 0,
        st = 0,
        brute = {
            tick = 0,
            b = 0,
            o = 0,
            p = 0
        },
        scoped = 0,
        scoping = 0,
        scope_replace = 0,
        scope_side = 0,
        alpha_scope = 0,
        override = {
            alpha = 0,
            position = 0
        },
        watermark = {
            enabled = 0,
            icon = 0,
            text = 0
        },
        indislide = 0
    }

    lua.visuals.timemark = function ()
        lua.visuals.time = lua.visuals.time + 0.1
        if lua.visuals.time > 120 then
            goto ignore
        end
        lua.visuals.time_background = math.lerp(lua.visuals.time_background, lua.visuals.time > 20 and lua.visuals.time < 70 and not entity.get_local_player() and 1 or 0, 0.01)
        lua.visuals.time_brand = math.lerp(lua.visuals.time_brand, lua.visuals.time_background > 0 and not entity.get_local_player() and 1 or 0, 0.04)
        local alpha = 145 * lua.visuals.time_background
        render.rect(coord(0, 0), coord(screen.x, screen.y), color(1, 1, 1, alpha))
        local alphatxt = 255 * lua.visuals.time_brand
        local r, g, b, a = lua.pui.ui.selectab.maing:get_color()
        local ant = images.load_png(readfile('enthusiasm.png'))
        ant:draw(screen.x / 2 - 25, screen.y / 2, 50 * lua.visuals.time_brand, 54 * lua.visuals.time_brand, r, g, b, alphatxt)
        ::ignore::
    end
    client.set_event_callback('paint_ui', lua.visuals.timemark)

    lua.visuals.lerping = function ()
        local me = entity.get_local_player()
        lua.visuals.lerp.live = math.lerp(lua.visuals.lerp.live, entity.is_alive(me) and 1 or 0, 0.096)
        lua.visuals.lerp.background = math.lerp(lua.visuals.lerp.background, pui.menu_open and lua.pui.ui.visuals.obscuration:get() and lua.visuals.time_background == 0 and 1 or 0, 0.01)

        local m_fFlags = entity.get_prop(me, 'm_fFlags')
        local is_frozen = lua.visuals.lerp.live == 1 and bit.band(m_fFlags, bit.lshift(1, 6)) ~= 0
        lua.visuals.lerp.frozen = math.lerp(lua.visuals.lerp.frozen, lua.visuals.lerp.live == 1 and is_frozen and 0.5 or 1, 0.096)

        local grenade = false
        local weapon = entity.get_player_weapon(me)
        if weapon ~= nil then
            local weaponi = weapons(weapon)
            if weaponi.weapon_type_int == 9 then
                grenade = true
            end
        end
        local fschk = lua.helps.get_freestand(me) == true and lua.pui.ui.antiaim.freestand:get() and lua.reference.antiaim.angles.freestanding:get() and lua.reference.antiaim.angles.freestanding.hotkey:get()
        lua.visuals.lerp.scoped = math.lerp(lua.visuals.lerp.scoped, lua.visuals.lerp.live > 0 and (lua.visuals.lerp.frozen < 1 or grenade or entity.get_prop(me, 'm_bResumeZoom') == 1 or
        entity.get_prop(me, 'm_bIsScoped') == 1) and 1 or 0, 0.05)

        if lua.visuals.lerp.live == 1 and lua.visuals.lerp.scoped == 1 then
            if not lua.visuals.lerp.scoping and math.side ~= 0 then
                lua.visuals.lerp.scope_replace, lua.visuals.lerp.scoping = -math.side, true
            end
        else
            lua.visuals.lerp.scope_replace, lua.visuals.lerp.scoping = 0, false
        end

        lua.visuals.lerp.scope_side = math.lerp(lua.visuals.lerp.scope_side, lua.visuals.lerp.scope_replace, 0.05)

        lua.visuals.lerp.alpha_scope = math.lerp(lua.visuals.lerp.alpha_scope,
        lua.visuals.lerp.scoped == 1 and lua.visuals.lerp.scope_side == 0 and 0.5 or 1, 0.05)
        local alpha = lua.visuals.lerp.alpha_scope
        --lua.visuals.lerp.velocity = math.lerp(lua.visuals.lerp.velocity, lua.visuals.lerp.live == 1 and
        --entity.get_prop(me, 'm_flVelocityModifier') < 1 and alpha or 0, 0.05)
        lua.visuals.lerp.exploit.defensive = math.lerp(lua.visuals.lerp.exploit.defensive, lua.visuals.lerp.live > 0 and
        lua.helps.on_level_init() > 0 and 1 or 0, 0.096)
        lua.visuals.lerp.hittable = math.lerp(lua.visuals.lerp.hittable, lua.visuals.lerp.live > 0 and
        lua.helps.hittable() and alpha or 0, 0.096)

        lua.visuals.lerp.ind = math.lerp(lua.visuals.lerp.ind, lua.visuals.lerp.live > 0 and lua.pui.ui.visuals.indicator:get() and 1 or 0, 0.1)

        local sz = render.measure_text('', lua.antiaim.state())
        lua.visuals.lerp.st = math.lerp(lua.visuals.lerp.st, lua.visuals.lerp.live > 0 and lua.visuals.lerp.ind == 1 and lua.visuals.state == sz.x and 1 or 0, 0.1)
        lua.visuals.lerp.dt = math.lerp(lua.visuals.lerp.dt, lua.visuals.lerp.live > 0 and lua.visuals.lerp.ind == 1 and
        lua.reference.rage.binds.double_tap[1]:get() and lua.reference.rage.binds.double_tap[1].hotkey:get() and 1 or 0, 0.1)
        lua.visuals.lerp.dmgt = math.lerp(lua.visuals.lerp.dmgt, lua.visuals.lerp.live > 0 and lua.visuals.lerp.ind == 1 and
        lua.reference.rage.binds.minimum_damage_override[1]:get_hotkey() and not lua.pui.ui.visuals.infowar_on:get() and 1 or 0, 0.1)
        lua.visuals.lerp.aa = math.lerp(lua.visuals.lerp.aa, lua.visuals.lerp.live > 0 and lua.visuals.lerp.ind == 1 and lua.visuals.lerp.dt == 0 and
        lua.reference.rage.binds.on_shot_anti_aim[1]:get() and lua.reference.rage.binds.on_shot_anti_aim[1].hotkey:get() and 1 or 0, 0.1)

        lua.visuals.lerp.brute.tick = math.lerp(lua.visuals.lerp.brute.tick, lua.visuals.lerp.live > 0 and
        lua.antiaim.brute_miss > 0 and 1 or 0, 0.096)

        local direction = lua.helps.get_freestand_direction(me)
        lua.visuals.lerp.manuals.directionl = math.lerp(lua.visuals.lerp.manuals.directionl, lua.visuals.lerp.live > 0 and lua.pui.ui.visuals.manualss:get() == 'L / R & Hit' and not lua.antiaim.overriding and lua.visuals.lerp.hittable > 0 and direction == 1 and 1 or 0, 0.096)
        lua.visuals.lerp.manuals.directionr = math.lerp(lua.visuals.lerp.manuals.directionr, lua.visuals.lerp.live > 0 and lua.pui.ui.visuals.manualss:get() == 'L / R & Hit' and not lua.antiaim.overriding and lua.visuals.lerp.hittable > 0 and direction == -1 and 1 or 0, 0.096)

        lua.visuals.lerp.manuals.left = math.lerp(lua.visuals.lerp.manuals.left, lua.visuals.lerp.live > 0 and
        lua.antiaim.selected_manual == 1 and lua.pui.ui.visuals.manualss:get() == 'L / R & Hit' and 1 or 0, 0.096)
        lua.visuals.lerp.manuals.right = math.lerp(lua.visuals.lerp.manuals.right, lua.visuals.lerp.live > 0 and
        lua.antiaim.selected_manual == 2 and lua.pui.ui.visuals.manualss:get() == 'L / R & Hit' and 1 or 0, 0.096)

        lua.visuals.lerp.override.alpha = math.lerp(lua.visuals.lerp.override.alpha, lua.pui.ui.antiaim.manualm:get() and lua.pui.ui.visuals.manualss:get() == 'Override yaw' and lua.antiaim.selected_manual == 0 and 1 or 0, 0.1)
        lua.visuals.lerp.override.position = math.lerp(lua.visuals.lerp.override.position, lua.antiaim.overriding and lua.antiaim.selected_manual == 0 and lua.antiaim.replace or 0, 0.1)

        if lua.visuals.lerp.st < 0.5 then
            lua.visuals.state = sz.x
        end
        lua.visuals.lerp.watermark.enabled = math.lerp(lua.visuals.lerp.watermark.enabled, lua.visuals.lerp.live > 0 and lua.pui.ui.visuals.watermark:get() and lua.visuals.lerp.ind ~= 1 and 1 or 0, 0.1)
        lua.visuals.lerp.watermark.icon = math.lerp(lua.visuals.lerp.watermark.icon, lua.visuals.lerp.watermark.enabled == 1 and lua.pui.ui.visuals.watopt2:get() == 'Icon' and 255 or 0, 0.1)
        lua.visuals.lerp.watermark.text = math.lerp(lua.visuals.lerp.watermark.text, lua.visuals.lerp.watermark.enabled == 1 and lua.pui.ui.visuals.watopt2:get() == 'Text' and 255 or 0, 0.1)
        lua.visuals.lerp.indislide = math.lerp(lua.visuals.lerp.indislide, lua.pui.ui.visuals.indicator:get() and lua.pui.ui.visuals.indslide:get() or 0, 0.1)
    end

    lua.visuals.rapid = function ()
        if lua.visuals.lerp.live == 0 then return end
        local tickb, tickc, rapid = math.exploit()
        lua.visuals.lerp.exploit.rapid = math.lerp(lua.visuals.lerp.exploit.rapid, lua.visuals.lerp.live == 0 or
        rapid and 0 or 1, 0.096)
    end
    client.set_event_callback('setup_command', lua.visuals.rapid)

    local y_cent = 0

    lua.visuals.obscuration = function ()
        local alpha = 145 * lua.visuals.lerp.background
        render.rect(coord(0, 0), coord(screen.x, screen.y), color(1, 1, 1, alpha))
    end

    render.indicatext = function(coords, colors, fl, alpha, text_size, ...)
		if alpha == nil then
			alpha = 1
		end

		if alpha <= 0 then
			return
		end

        local offset = 1
        local addx = 10 * -lua.visuals.lerp.scope_side
        if lua.visuals.lerp.scope_side > 0 then
            offset = offset + lua.visuals.lerp.scope_side
        elseif lua.visuals.lerp.scope_side < 0 then
            offset = offset + lua.visuals.lerp.scope_side
        end
        local measu = text_size == nil and render.measure_text(fl, ...) or text_size
        local adding = lua.visuals.lerp.scope_side == 0 and - measu.x * (1 - alpha) or 0
        local analize = measu.x + adding
		coords.x = coords.x - analize * offset * .5 + addx
        colors.a = colors.a * (alpha - (1 - lua.visuals.lerp.frozen))
        coords.y = coords.y + lua.visuals.lerp.indislide

		render.text(coords, colors, fl, 0, ...)

		y_cent = y_cent + (measu.y + 3) * alpha
	end

    lua.visuals.damage = function ()
        if lua.visuals.lerp.live == 0 then return end

        if lua.pui.ui.visuals.infowar:get('Min. Damage') and lua.reference.rage.binds.minimum_damage_override[1]:get_hotkey() == false then
            lua.visuals.lerp.dmgh = math.lerp(lua.visuals.lerp.dmgh, 1, 0.06)
        elseif lua.reference.rage.binds.minimum_damage_override[1]:get_hotkey() and lua.pui.ui.visuals.infowar:get('Over. Damage') then
            lua.visuals.lerp.dmgh = math.lerp(lua.visuals.lerp.dmgh, 1, 0.06)
        elseif pui.menu_open then
            lua.visuals.lerp.dmgh = math.lerp(lua.visuals.lerp.dmgh, 1, 0.06)
        elseif lua.visuals.lerp.live < 1 or lua.visuals.lerp.frozen < 1 then
            lua.visuals.lerp.dmgh = math.lerp(lua.visuals.lerp.dmgh, 0, 0.06)
        else
            lua.visuals.lerp.dmgh = math.lerp(lua.visuals.lerp.dmgh, 0, 0.06)
        end
        lua.visuals.lerp.dmg = math.lerp(lua.visuals.lerp.dmg, lua.reference.rage.binds.minimum_damage_override[1]:get_hotkey() and lua.reference.rage.binds.minimum_damage_override[2].value or lua.reference.rage.binds.minimum_damage:get() + 0.5, 0.06)

        local dmgt = ''
        if lua.visuals.lerp.dmg > 0.9 and lua.visuals.lerp.dmg < 100.55 then
            dmgt = math.floor(lua.visuals.lerp.dmg)
        elseif lua.visuals.lerp.dmg < 0.9 then
            dmgt = 'AUTO'
        elseif lua.visuals.lerp.dmg > 100.55 then
            dmgt = '+' .. math.floor(lua.visuals.lerp.dmg - 100)
        end

        local r, g, b, a = lua.pui.ui.selectab.maing:get_color()
        local dmg = lua.pui.ui.visuals.infowar_add:get() and 'MD '..dmgt or dmgt
        render.text(coord(screen.x / 2 + 5, screen.y / 2 - 15), color(r, g, b, 255 * lua.visuals.lerp.dmgh), '', 0, dmg)
        --dmgg:drag()
    end

    lua.visuals.indicator = function ()
        if lua.visuals.lerp.live == 0 then return end

        local r, g, b, a = lua.pui.ui.selectab.maing:get_color()

        y_cent = 11
        local rf = lua.visuals.lerp.dt + lua.visuals.lerp.aa
        local dmg = lua.visuals.lerp.dmgt
        local damage = 'impair'
        local rapid = 'rapid'
        local rap = lua.visuals.lerp.exploit.rapid
        local block = '₊‧.°.⋆✦⋆.°.₊'
        local blsize = render.measure_text('b', block)
        local textsize = render.measure_text('b', _nam:lower())
        local alpha = 255 * lua.visuals.lerp.ind
        local namz = math.animate_text(globals.curtime(), _nam:lower(), color(r, g, b, alpha * lua.visuals.lerp.alpha_scope), color(r  * 0.5, g  * 0.5, b * 0.5, (alpha * 0.75) * lua.visuals.lerp.alpha_scope))
        render.indicatext(coord(screen.x / 2, screen.y / 2 + 18), color(r, g, b, 155 * lua.visuals.lerp.alpha_scope), 'b', lua.visuals.lerp.ind, blsize, block)
        render.indicatext(coord(screen.x / 2, screen.y / 2 + y_cent), color(r, g, b, 255 * lua.visuals.lerp.alpha_scope), 'b', lua.visuals.lerp.ind, textsize, unpack(namz))
        render.indicatext(coord(screen.x / 2, screen.y / 2 + y_cent), color(255, 255 * rap, 255 * rap, 200 * lua.visuals.lerp.alpha_scope), '', rf, nil, string.sub(rapid, 1, 0.5 + #rapid * rf))
        render.indicatext(coord(screen.x / 2, screen.y / 2 + y_cent), color(255, 255, 255, 200 * lua.visuals.lerp.alpha_scope), '', dmg, nil, string.sub(damage, 1, 0.5 + #damage * dmg))
        render.indicatext(coord(screen.x / 2, screen.y / 2 + y_cent), color(255, 255, 255, 200 * lua.visuals.lerp.alpha_scope), '', lua.visuals.lerp.st, nil, lua.antiaim.state():lower())
    end

    lua.visuals.manuals = function ()
        if lua.visuals.lerp.live == 0 then return end
        local r, g, b, a = lua.pui.ui.selectab.maing:get_color()
        render.text(coord(screen.x / 2 - 90, screen.y / 2 - 6), color(r, g, b, 255 * lua.visuals.lerp.manuals.left), '+c', 0, '')
        render.text(coord(screen.x / 2 + 90, screen.y / 2 - 6), color(r, g, b, 255 * lua.visuals.lerp.manuals.right), '+c', 0, '')
        render.text(coord(screen.x / 2 - 80 - 10 * (1 - lua.visuals.lerp.manuals.left), screen.y / 2 - 6), color(r, g, b, 255 * lua.visuals.lerp.manuals.directionl), '+c', 0, '')
        render.text(coord(screen.x / 2 + 80 + 10 * (1 - lua.visuals.lerp.manuals.right), screen.y / 2 - 6), color(r, g, b, 255 * lua.visuals.lerp.manuals.directionr), '+c', 0, '')
    end

    lua.visuals.override_yaw = function ()
        local r, g, b, a = lua.pui.ui.selectab.maing:get_color()
        render.circle(coord(screen.x / 2 + 100 * lua.visuals.lerp.override.position, screen.y / 2 + 0.5), color(r, g, b, 255 * lua.visuals.lerp.override.alpha), 10, 1)
        render.circle(coord(screen.x / 2 + 100 * lua.visuals.lerp.override.position, screen.y / 2 + 0.5), color(r, g, b, a * lua.visuals.lerp.override.alpha), 10)
    end
    lua.visuals.watermark = function ()
        local r, g, b, a = lua.pui.ui.selectab.maing:get_color()
        local ant = images.load_png(readfile('enthusiasm.png'))
        local talpha = lua.visuals.lerp.watermark.text * lua.visuals.lerp.watermark.enabled
        local ialpha = lua.visuals.lerp.watermark.icon * lua.visuals.lerp.watermark.enabled
        for k, v in pairs(lua.visuals.data_hurt) do
            v.alpha_crosshair = math.lerp(v.alpha_crosshair, v.time + 0.5 > globals.realtime() and 1 or 0, 0.05)
            lua.visuals.lerp.hurt = v.alpha_crosshair
        end
        local hit = 1 - lua.visuals.lerp.hurt
        local namz = math.animate_text(globals.curtime(), _nam, color(r, g * hit, b * hit, talpha), color(r * 0.5, g * hit * 0.5, b * hit * 0.5, talpha * 0.5))
        ant:draw(screen.x / 2 - 25, screen.y - 50, 50, 54, r, g * hit, b * hit, ialpha)
        render.text(coord(screen.x / 2, screen.y - 7), color(r, g, b, talpha), 'c', 0, unpack(namz))
        render.text(coord(screen.x / 2, screen.y - 7), color(r, g, b, talpha), 'cb', 0, unpack(namz))
    end
    events.set_callback(lua.pui.ui.visuals.manuals, 'paint_ui', lua.visuals.manuals)
    events.set_callback(lua.pui.ui.visuals.manuals, 'paint_ui', lua.visuals.override_yaw)
    events.set_callback(lua.pui.ui.visuals.infowar_on, 'paint_ui', lua.visuals.damage)
    client.set_event_callback('paint_ui', lua.visuals.lerping)
    events.set_paint(function ()
        if lua.visuals.lerp.background > 0 then
            lua.visuals.obscuration()
        end

        if lua.visuals.lerp.watermark.enabled > 0 then
            lua.visuals.watermark()
        end

        if lua.visuals.lerp.ind > 0 then
            lua.visuals.indicator()
        end
    end)
end

--endregion

--endregion

--region quick switching

lua.qswitch = {} do

    lua.qswitch.grenade = function (e)
        if not lua.pui.ui.other.qsmod:get('Grenades') then return end
        local me = entity.get_local_player()
        local userid = client.userid_to_entindex(e.userid)

        if userid ~= me then
            return
        end

        client.exec('slot3')
        client.exec('slot2')
        client.exec('slot1')
    end

    lua.qswitch.zeus = function (e)
        if not lua.pui.ui.other.qsmod:get('Zeus') then return end
        local me = entity.get_local_player()
        local userid = client.userid_to_entindex(e.userid)

        if userid ~= me then
            return
        end

        if e.weapon == 'weapon_taser' and cvar.sv_infinite_ammo:get_int() ~= 1 and cvar.mp_taser_recharge_time:get_int() < 0 then
            client.exec('slot3')
            client.exec('slot2')
            client.exec('slot1')
        end
    end

    events.set_callback(lua.pui.ui.other.qswitch, 'grenade_thrown', lua.qswitch.grenade)
    events.set_callback(lua.pui.ui.other.qswitch, 'weapon_fire', lua.qswitch.zeus)

end

--endregion

--region logs

local logs = { list = {} } do
    logs.below_crosshair_push = function (text, time, r, g, b, a)
        table.insert(logs.list, {
            text = text,
            realtime = globals.realtime(),
            time = time,
            alpha = 0,
            r = r,
            g = g,
            b = b,
            a = a
        })
    end

    logs.below_crosshair_render = function ()
        if not logs.list or #logs.list == 0 then
            return
        end

        for i = #logs.list, 1, -1 do
            local log = logs.list[i]

            if not log then
                table.remove(logs.list, i)
            else
                if globals.realtime() - log.realtime < log.time then
                    log.alpha = log.alpha + globals.absoluteframetime() * 1200
                else
                    log.alpha = log.alpha - globals.absoluteframetime() * 1200
                end

                if log.alpha <= 0 then
                    table.remove(logs.list, i)
                end
            end
        end

        local position = coord(screen.x * 0.5, screen.y * 0.5 + 240)
        local offsets = { x = 0, y = 0 }

        for _, log in ipairs(logs.list) do
            log.alpha = math.clamp(log.alpha, 0, 255)
            local x_factor = log.alpha / 255
            --local time = globals.realtime() - log.realtime < 5 and '['..string.sub(globals.realtime() - log.realtime, 1, 4)..'] ' or '(5.00) '
            local text_size = render.measure_text('d', log.text)

            --render.rect(coord(position.x - text_size.x / 2 - 5, position.y + offsets.y - text_size.y / 2 + 6 - 4), coord(text_size.x + 10, text_size.y + 8), color(21, 21, 21, 230 * x_factor))
            render.text(coord(position.x - text_size.x / 2, position.y + offsets.y), color(230, 230, 230, 230 * x_factor), 'd', 0, log.text)
            offsets.y = offsets.y + math.round(text_size.y * x_factor * x_factor * (3 - 2 * x_factor))
        end
    end
    events.set_callback(lua.pui.ui.other.logs, 'paint_ui', logs.below_crosshair_render)

    local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
    local shot_data = {
        wanted = 0,
        aim = 'unknown',
        teleport = false,
        interp = false,
        aimed = 0,
    }

    local debug_fire = function (e)
        --if not lua.pui.ui.other.lmod:get('Hit') or not lua.pui.ui.other.lmod:get('Miss') then return end
        local want = e.damage
        local group = hitgroup_names[e.hitgroup + 1] or '?'
        local teleport = e.teleported
        local interp = e.interpolated
        local bt = globals.tickcount() - e.tick

        shot_data.wanted = want
        shot_data.aim = group
        shot_data.teleport = teleport and true or false
        shot_data.interp = interp and true or false
        shot_data.aimed = bt
    end

    local hit_log = function (e)
        local name = entity.get_player_name(e.target)
        local group = hitgroup_names[e.hitgroup + 1] or '?'
        local bt = globals.tickcount() - e.tick
        local hp_now = entity.get_prop(e.target, 'm_iHealth')
        local hitorkill = hp_now > 0 and 'Hitting' or 'Killed'
        local remain = hp_now > 0 and 'now: ' .. hp_now or 'killed'
        local hc = math.round(e.hit_chance)
        local wanted_group = group ~= shot_data.aim and ' ('..shot_data.aim..')' or ''
        local damage = e.damage
        local wanted = damage ~= shot_data.wanted and hp_now > 0 and 'want: ' .. shot_data.wanted .. ', ' or ''
        local wantedcros = damage ~= shot_data.wanted and hp_now > 0 and '('..shot_data.wanted..')' or ''
        local r, g, b, a = damage ~= wanted and 200, 200, 200, 255 or 255, 255, 255, 255
        local infocros = hp_now > 0 and 'for '..damage..wantedcros or 'in '..group
        local text_for_output =
        string.format('Hitting %s for %s (%s%s) in %s%s (hc: %s, bt: %s)',
        name, damage, wanted, remain, group, wanted_group, hc, bt)
        local text_for_below_crosshair =
        string.format('%s %s %s',
        hitorkill, name, infocros)

        client.color_log(r, g, b, lua.pui.ui.other.lmod:get('Output') and text_for_output or '')
        if lua.pui.ui.other.lmod:get('Hit') then logs.below_crosshair_push(text_for_below_crosshair, 4, r, g, b, a) end
    end

    local miss_log = function (e)
        local name = entity.get_player_name(e.target)
        local group = hitgroup_names[e.hitgroup + 1] or '?'
        local bt = globals.tickcount() - e.tick
        local hc = math.round(e.hit_chance)
        local wanted_group = group ~= shot_data.aim and ' ('..shot_data.aim..')' or ''
        local wanted_damage = shot_data.wanted
        local r, g, b, a = 255, 25, 25, 255

        if e.reason == '?' and not shot_data.teleport and bt < 10 then
            e.reason = 'resolver'
        elseif e.reason == '?' and not shot_data.teleport and bt > 10 then
            e.reason = 'animation'
        elseif e.reason == '?' and shot_data.teleport then
            e.reason = 'lagcomp'
        end

        local text_for_output =
        string.format('Missing %s due to %s for %s in %s%s (hc: %s, bt: %s)',
        name, e.reason, wanted_damage, group, wanted_group, hc, bt)

        local text_for_below_crosshair =
        string.format('Missing %s in %s',
        name, e.reason)

        client.color_log(r, g, b, lua.pui.ui.other.lmod:get('Output') and text_for_output or '')
        if lua.pui.ui.other.lmod:get('Miss') then logs.below_crosshair_push(text_for_below_crosshair, 4, r, g, b, a) end
    end
    events.set_callback(lua.pui.ui.other.logs, 'aim_fire', debug_fire)
    events.set_callback(lua.pui.ui.other.logs, 'aim_hit', hit_log)
    events.set_callback(lua.pui.ui.other.logs, 'aim_miss', miss_log)
end

--endregion

--region anti crasher
local CS_UM_SendPlayerItemFound = 63
local DispatchUserMessage_t = ffi.typeof [[ bool(__thiscall*)(void*, int msg_type, int nFlags, int size, const void* msg)
]]

local VClient018 = client.create_interface('client.dll', 'VClient018')
local pointer = ffi.cast('uintptr_t**', VClient018)
local vtable = ffi.cast('uintptr_t*', pointer[0])
local size = 0
while vtable[size] ~= 0x0 do
   size = size + 1
end

local hooked_vtable = ffi.new('uintptr_t[?]', size)
for i = 0, size - 1 do
    hooked_vtable[i] = vtable[i]
end

pointer[0] = hooked_vtable
local oDispatch = ffi.cast(DispatchUserMessage_t, vtable[38])
local function hkDispatch(thisptr, msg_type, nFlags, size, msg)
    if msg_type == CS_UM_SendPlayerItemFound then
        return false
    end

    return oDispatch(thisptr, msg_type, nFlags, size, msg)
end

client.set_event_callback('shutdown', function()
    hooked_vtable[38] = vtable[38]
    pointer[0] = vtable
end)
hooked_vtable[38] = ffi.cast('uintptr_t', ffi.cast(DispatchUserMessage_t, hkDispatch))
--endregion

--region dt fix

client.rapid_change = function ()
    local me = entity.get_local_player()
    if not me then
        goto ignore
    end

    local enabled = lua.reference.rage.binds.double_tap[1]:get() and lua.reference.rage.binds.double_tap[1].hotkey:get() and not lua.reference.rage.binds.fakeduck:get()
    local tickbase, tickcount, rapid = math.exploit()
    local active_weapon = entity.get_prop(me, 'm_hActiveWeapon')
    if active_weapon == nil then
        goto ignore
    end

    local weapon_idx = entity.get_prop(active_weapon, 'm_iItemDefinitionIndex')
    if weapon_idx == nil or weapon_idx == 64 then
        goto ignore
    end

    local lastshot = entity.get_prop(active_weapon, 'm_flastshotTime')
    if lastshot == nil then
        goto ignore
    end

    local single = weapon_idx == 64 or weapon_idx == 40 or weapon_idx == 35 or weapon_idx == 29 or weapon_idx == 27 or weapon_idx == 9
    local value = single and 1.50 or 0.50
    local in_attack = globals.curtime() - lastshot <= value

    lua.reference.rage.binds.enabled[1].hotkey:set('Always on')
    if rapid and enabled then
        lua.reference.rage.binds.enabled[1].hotkey:set(in_attack and 'Always on' or 'On hotkey')
    end

    ::ignore::
end
events.set_callback(lua.pui.ui.other.rfix, 'setup_command', client.rapid_change)

--endregion

--region world

local world = {} do
    local fov = 0
    local x = 0
    local y = 0
    local z = 0
    world.viewmanager = function ()
        local me = entity.get_local_player()
        if not me then return end
        if lua.pui.ui.visuals.viesc:get() and lua.pui.ui.visuals.viesca:get() and entity.get_prop(me, 'm_bIsScoped') == 1 then
            fov = math.lerp(fov, lua.pui.ui.visuals.vief:get() and lua.pui.ui.visuals.viefs:get() - 10 or 68, 0.01)
            if lua.pui.ui.visuals.viewm:get() then
                x = math.lerp(x, -3, 0.01)
                y = math.lerp(y, 1, 0.01)
                z = math.lerp(z, -4, 0.01)
            else
                x = math.lerp(x, 2.5, 0.01)
                y = math.lerp(y, 1, 0.01)
                z = math.lerp(z, -1, 0.01)
            end
        else
            fov = math.lerp(fov, lua.pui.ui.visuals.vief:get() and lua.pui.ui.visuals.viefs:get() or 68, 0.01)
            x = math.lerp(x, lua.pui.ui.visuals.viewm:get() and lua.pui.ui.visuals.viewx:get() * 0.1 or 2.5, 0.01)
            y = math.lerp(y, lua.pui.ui.visuals.viewm:get() and lua.pui.ui.visuals.viewy:get() * 0.1 or 1, 0.01)
            z = math.lerp(z, lua.pui.ui.visuals.viewm:get() and lua.pui.ui.visuals.viewz:get() * 0.1 or -1, 0.01)
        end

        cvar.viewmodel_fov:set_raw_float(fov)
        cvar.viewmodel_offset_x:set_raw_float(x)
        cvar.viewmodel_offset_y:set_raw_float(y)
        cvar.viewmodel_offset_z:set_raw_float(z)
    end
    local match = client.find_signature('client_panorama.dll', '\x8B\x35\xCC\xCC\xCC\xCC\xFF\x10\x0F\xB7\xC0')
    local weapon_raw = ffi.cast('void****', ffi.cast('char*', match) + 2)[0]
    local ccsweaponinfo_t = [[
    struct 
    {
        char __pad_0x0000[0x1cd];
        bool hide_vm_scope;
    }
    ]]
    local get_weapon_info = vtable_thunk(2, ccsweaponinfo_t .. '*(__thiscall*)(void*, unsigned int)')
    local inscope = true
    world.view_scope = function ()
        local me = entity.get_local_player()
        if not me then return end
        local weapon = entity.get_player_weapon(me)
        if not weapon then return end
        local w_id = entity.get_prop(weapon, 'm_iItemDefinitionIndex')
        local res = get_weapon_info(weapon_raw, w_id)
        inscope = not lua.pui.ui.visuals.viesc:get()
        res.hide_vm_scope = inscope
    end

    local incros = function ()
        local me = entity.get_local_player()
        if not me then return end
        local weapon = entity.get_player_weapon(me)
        if not weapon then return end
        local w_id = entity.get_prop(weapon, 'm_iItemDefinitionIndex')
        local res = get_weapon_info(weapon_raw, w_id)
        inscope = true
        res.hide_vm_scope = inscope
    end

    local aspect = 0
    world.aspectratio = function ()
        if lua.pui.ui.visuals.aspectratio:get() then
            aspect = math.lerp(aspect, lua.pui.ui.visuals.aspc:get() * 0.01, 0.01)
        else
            aspect = math.lerp(aspect, 0, 1)
        end
        cvar.r_aspectratio:set_raw_float(aspect)
    end

    local distance = 0
    local inthird = 0
    world.thirdperson = function ()
        local key = lua.reference.visuals.effects.thirdperson[1].hotkey:get()
        if lua.pui.ui.visuals.thirdpers:get() then
            distance = math.lerp(distance, lua.pui.ui.visuals.thrdst:get(), 0.01)
        else
            distance = cvar.cam_idealdist:get_float()
        end

        local dist2 = 0
        if key and lua.pui.ui.visuals.thirds:get() and lua.pui.ui.visuals.thirdpers:get() then
            dist2 = distance
            inthird = math.lerp(inthird, lua.pui.ui.visuals.thrdst:get(), 0.01)
        else
            dist2 = 0
            inthird = 0
        end
        cvar.cam_idealdist:set_raw_float(distance + (dist2 - inthird) * 0.5)
    end
    client.set_event_callback('run_command', world.view_scope)
    events.set_paint(world.aspectratio)
    events.set_paint(world.thirdperson)
    events.set_paint(world.viewmanager)

    local viewshut = function ()
        incros()
        cvar.r_aspectratio:set_raw_float(0)
        cvar.viewmodel_fov:set_float(68)
        cvar.viewmodel_offset_x:set_float(2.5)
        cvar.viewmodel_offset_y:set_float(1)
        cvar.viewmodel_offset_z:set_float(-1)
        cvar.con_filter_enable:set_raw_int(0)
        cvar.con_filter_text:set_string('')
    end
    client.set_event_callback('shutdown', viewshut)
end

--endregion

--region rage modifier

client.fire_get = function ()
    local fire = 0
    local wpn = 0
    for k, v in pairs(lua.visuals.data_hurt) do
        wpn = v.weapon
        fire = v.damage
        if v.time + 0.01 < globals.realtime() then
            table.remove(lua.visuals.data_hurt, k)
        end
    end
end

client.ladder = function(cmd)

    local me = entity.get_local_player()
    if not me then
        goto ignore
    end

    local movetype = entity.get_prop(me, 'm_MoveType')
    local weapon = entity.get_player_weapon(me)
    local throw = entity.get_prop(weapon, 'm_fThrowTime')
    local conditions = lua.pui.ui.other.ladderc

    if movetype ~= 9 then
        goto ignore
    end

    if weapon == nil then
        goto ignore
    end

    if throw ~= nil and throw ~= 0 then
        goto ignore
    end

    if conditions:get() == 'Auto' then
        if cmd.sidemove == 0 then
            cmd.yaw = cmd.yaw + 45
        end

        if cmd.in_forward then
            if cmd.sidemove > 0 then
                cmd.yaw = cmd.yaw - 1
            end

            if cmd.sidemove < 0 then
                cmd.yaw = cmd.yaw + 90
            end

            if in_forward then
                cmd.in_moveleft = false
                cmd.in_moveright = true
            else
                cmd.in_moveleft = true
                cmd.in_moveright = false
            end
        end

        if cmd.in_back then
            if cmd.sidemove < 0 then
                cmd.yaw = cmd.yaw - 1
            end

            if cmd.sidemove > 0 then
                cmd.yaw = cmd.yaw + 90
            end

            if in_forward then
                cmd.in_moveleft = true
                cmd.in_moveright = false
            else
                cmd.in_moveleft = false
                cmd.in_moveright = true
            end
        end
    else
        if cmd.forwardmove > 0 then
            if cmd.pitch < 45 then
                cmd.pitch = 89
                cmd.in_moveright = 1
                cmd.in_moveleft = 0
                cmd.in_forward = 0
                cmd.in_back = 1

                if cmd.sidemove == 0 then
                    cmd.yaw = cmd.yaw + 90
                end

                if cmd.sidemove < 0 then
                    cmd.yaw = cmd.yaw + 150
                end

                if cmd.sidemove > 0 then
                    cmd.yaw = cmd.yaw + 30
                end
            end
        end

        if cmd.forwardmove < 0 then
            cmd.pitch = 89
            cmd.in_moveleft = 1
            cmd.in_moveright = 0
            cmd.in_forward = 1
            cmd.in_back = 0

            if cmd.sidemove == 0 then
                cmd.yaw = cmd.yaw + 90
            end

            if cmd.sidemove > 0 then
                cmd.yaw = cmd.yaw + 150
            end

            if cmd.sidemove < 0 then
                cmd.yaw = cmd.yaw + 30
            end
        end
    end

    ::ignore::
end

client.airstop = function (cmd)
    if lua.pui.ui.other.quis.hotkey:get() then
        if cmd.quick_stop then
            local fly = not lua.antiaim.onground
            if fly then
                cmd.in_speed = 1
            end
        end
    end
end
local airstop = function ()
    if lua.pui.ui.other.quis.hotkey:get() and not lua.antiaim.onground then
        renderer.indicator(230, 230, 230, 230, 'AS')
    end
end
events.set_callback(lua.pui.ui.other.quis, 'setup_command', client.airstop)
events.set_callback(lua.pui.ui.other.quis, 'paint', airstop)
events.set_callback(lua.pui.ui.other.ladder, 'setup_command', client.ladder)

--endregion

--region console

local console = {} do
    local engine_client = ffi.cast(ffi.typeof('void***'), client.create_interface('engine.dll', 'VEngineClient014'))
    local console_is_visible = ffi.cast(ffi.typeof('bool(__thiscall*)(void*)'), engine_client[0][11])
    local materials = { 'vgui_white', 'vgui/hud/800corner1', 'vgui/hud/800corner2', 'vgui/hud/800corner3', 'vgui/hud/800corner4' }

    console.enabled = function ()
        local r, g, b, a = lua.pui.ui.visuals.vgui:get_color()

        if not console_is_visible(engine_client) or not lua.pui.ui.visuals.vgui:get() then
            r, g, b, a = 255, 255, 255, 255
        end

        for _, mat in pairs(materials) do
            materialsystem.find_material(mat):alpha_modulate(a)
            materialsystem.find_material(mat):color_modulate(r, g, b)
        end
    end

    client.set_event_callback('paint', console.enabled)
end

--endregion

--region animbreaker

lua.animbreak = {} do
    lua.animbreak.air = function ()
        local me = entity.get_local_player()
        if not me then return end
        local self_index = entitys.new(me)
        if self_index:get_anim_state().on_ground == true then return end
        self_index:get_anim_overlay(7).cycle = globals.realtime() * 0.5 % 1
        self_index:get_anim_overlay(6).cycle = globals.realtime() * 0.5 % 1
        if lua.pui.ui.other.airwlk:get() then
            self_index:get_anim_overlay(6).weight = lua.pui.ui.other.airbrs:get() / lua.pui.ui.other.airbrs:get()
        else
            entity.set_prop(me, 'm_flPoseParameter', math.random(lua.pui.ui.other.airbrs:get() * 0.01, 1), 6)
        end
    end
    events.set_callback(lua.pui.ui.other.airbr, 'pre_render', lua.animbreak.air)

    lua.animbreak.ground = function ()
        local me = entity.get_local_player()
        if not me then return end
        local self_index = entitys.new(me)
        if self_index:get_anim_state().on_ground == false then return end
        self_index:get_anim_overlay(7).cycle = globals.realtime() * 0.5 % 1
        self_index:get_anim_overlay(6).cycle = globals.realtime() * 0.5 % 1
        if lua.reference.antiaim.other.leg_movement:get() == 'Never slide' then
            self_index:get_anim_overlay(7).weight = 0
            entity.set_prop(me, 'm_flPoseParameter', math.random(lua.pui.ui.other.grbrs:get() * 0.01, 1), 7)
            entity.set_prop(me, 'm_flPoseParameter', math.random(lua.pui.ui.other.grbrs:get() * 0.01, 1), 1)
        else
            entity.set_prop(me, 'm_flPoseParameter', math.random(lua.pui.ui.other.grbrs:get() * 0.01, 1), 0)
            entity.set_prop(me, 'm_flPoseParameter', math.random(lua.pui.ui.other.grbrs:get() * 0.01, 1), 1)
        end
    end
    events.set_callback(lua.pui.ui.other.grbr, 'pre_render', lua.animbreak.ground)

    lua.animbreak.lean = function ()
        local me = entity.get_local_player()
        if not me then return end
        local self_index = entitys.new(me)
        self_index:get_anim_overlay(12).weight = math.random(lua.pui.ui.other.leanbrs:get() * 0.01, 1)
        self_index:get_anim_overlay(12).cycle = globals.realtime() * 0.5 % 1
    end
    events.set_callback(lua.pui.ui.other.leanbr, 'pre_render', lua.animbreak.lean)
end

--endregion

--region gamesensical

local gamesense = {} do

    local indexing = {}
    local place = {
        active = {}
    }
    local colore = {}

    gamesense.index = function(ref)
        indexing[#indexing + 1] = ref
    end

    client.set_event_callback('indicator', gamesense.index)

    gamesense.draw = function ()
        local updated_ind = {}
        local offset = 0

        for idx, name in pairs(indexing) do
            colore[name.text] = {r = name.r, g = name.g, b = name.b, a = name.a}
            if not place.active[name.text] then
                place.active[name.text] = {r = 0, g = 0, b = 0, a = 0, alpha = 0, offset = 0, active = true}
            end
            updated_ind[name.text] = true
        end

        for name, value in pairs(place.active) do
            if updated_ind[name] then
                latest_item = true
                value.alpha = math.lerp(value.alpha, 1, 0.1)
                value.r = math.lerp(value.r, colore[name].r, 0.1)
                value.g = math.lerp(value.g, colore[name].g, 0.1)
                value.b = math.lerp(value.b, colore[name].b, 0.1)
                value.a = math.lerp(value.a, colore[name].a, 0.1)
                value.active = true
            else
                value.alpha = math.lerp(value.alpha, 0, 0.1)
                value.r = math.lerp(value.r, 255, 0.1)
                value.g = math.lerp(value.g, 255, 0.1)
                value.b = math.lerp(value.b, 255, 0.1)
                value.a = math.lerp(value.a, 255, 0.1)
                if value.alpha == 0 then
                    place.active[name] = nil
                end
            end

            local size = render.measure_text('+d', name)
            local start = screen.y - 300
            offset = offset + (size.y + 12) * value.alpha
            local width_ind = math.floor(size.x / 2)
            local y = start - offset
            render.fade(coord(4, y), coord(width_ind + 24, size.y + 4), color(0, 0, 0, 0), color(0, 0, 0, 50 * value.alpha), true)
            render.fade(coord(28 + width_ind, y), coord(29 + width_ind, size.y + 4), color(0, 0, 0, 50 * value.alpha), color(0, 0, 0, 0), true)
            render.text(coord(28, y + 2), color(value.r, value.g, value.b, value.a * value.alpha), '+d', 0, name)
        end
        indexing = {}
    end
    client.set_event_callback('paint', gamesense.draw)

    local logging = {}

    gamesense.output = function(e)
        table.insert(logging, {
            text = e.text,
            realtime = globals.realtime() + 5,
            alpha = 0,
            r = e.r,
            g = e.g,
            b = e.b,
            a = e.a
        })
    end

    client.set_event_callback('output', gamesense.output)

    gamesense.logs = function ()
        if not logging or #logging == 0 then
            return
        end

        for i = #logging, 1, -1 do
            local log = logging[i]

            if not log then
                table.remove(logging, i)
            else
                if log.realtime > globals.realtime() then
                    log.alpha = math.lerp(log.alpha, 1, 0.1)
                else
                    log.alpha = math.lerp(log.alpha, 0, 0.1)
                end
                if log.alpha <= 0 then
                    table.remove(logging, i)
                end
            end
        end

        local offset = 0

        for _, log in ipairs(logging) do
            render.text(coord(5, 3 + offset), color(log.r, log.g, log.b, log.a * log.alpha), 'b', nil, log.text)
            offset = offset + 13 * log.alpha
        end
    end

    client.set_event_callback('paint_ui', gamesense.logs)
end

--endregion

--endregion