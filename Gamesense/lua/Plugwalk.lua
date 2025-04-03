local API = {
    ENV = {
        Ipairs = ipairs,
        Assert = assert,
        Pairs = pairs,
        Next = next,
        Tostring = tostring,
        Tonumber = tonumber,
        Setmetatable = setmetatable,
        Unpack = unpack,
        Type = type,
        Getmetatable = getmetatable,
        Pcall = pcall,
        Error = error
    },
    MENU = {
        Get = ui.get,
        Set = ui.set,
        Reference = ui.reference,
        Visible = ui.set_visible,
        Label = ui.new_label,
        Checkbox = ui.new_checkbox,
        Hotkey = ui.new_hotkey,
        Combobox = ui.new_combobox,
        Colorpicker = ui.new_color_picker,
        Multiselect = ui.new_multiselect,
        Slider = ui.new_slider,
        Textbox = ui.new_textbox,
        Button = ui.new_button,
        Callback = ui.set_callback,
        IsOpen = ui.is_menu_open,
        MousePos = ui.mouse_position
    },
    CLIENT = {
        Delay = client.delay_call,
        Interface = client.create_interface,
        Cvar = client.set_cvar,
        Get_cvar = client.get_cvar,
        Callback = client.set_event_callback,
        UnsetCallback = client.unset_event_callback,
        EyePos = client.eye_position,
        CamAngles = client.camera_angles,
        Trace = client.trace_line,
        UIDtoENT = client.userid_to_entindex,
        Update = client.update_player_list,
        Screen = client.screen_size,
        ESPFlag = client.register_esp_flag,
        Bullet = client.trace_bullet,
        Random = client.random_int,
        Exec = client.exec,
        Log = client.color_log,
        Key = client.key_state,
        Time = client.system_time,
        Latency = client.latency,
        Clantag = client.set_clan_tag,
        rLatency = client.real_latency,
        Drawline = client.draw_line,
        Drawcircle = client.draw_circle,
        Randomfloat = client.random_float,

    },
    TABLE = {
        Sort = table.sort,
        Insert = table.insert,
        GetN = table.getn,
        Remove = table.remove,
        Concat = table.concat
    },
    ENT = {
        LocalPlayer = entity.get_local_player,
        PlayerWeapon = entity.get_player_weapon,
        Prop = entity.get_prop,
        IsAlive = entity.is_alive,
        GetPlayers = entity.get_players,
        HitboxPos = entity.hitbox_position,
        GameRules = entity.get_game_rules,
        BoundingBox = entity.get_bounding_box,
        IsEnemy = entity.is_enemy,
        PlayerName = entity.get_player_name,
        GetAll = entity.get_all,
        ClassName = entity.get_classname,
        Setprop = entity.set_prop,
        IsDormant = entity.is_dormant,
        Resource = entity.get_player_resource,
        Origin = entity.get_origin,
        Hitbox = entity.hitbox_position,
    },
    RENDER = {
        Text = renderer.text,
        Indicator = renderer.indicator,
        Gradient = renderer.gradient,
        Measure = renderer.measure_text,
        Rectangle = renderer.rectangle,
        CircleOutline = renderer.circle_outline,
        Circle = renderer.circle,
        Texture = renderer.texture,
        Blur = renderer.blur,
        Svg = renderer.load_svg,
        Rectangles = renderer.rounded_rectangle,
        Triangle = renderer.triangle,
        World = renderer.world_to_screen,
    },
    GLOBALS = {
        Frametime = globals.absoluteframetime,
        Realtime = globals.realtime,
        Max = globals.maxplayers,
        Curtime = globals.curtime,
        Ticks = globals.tickinterval,
        Tickcount = globals.tickcount,
        Frametimes = globals.frametime
    },
    PLIST = {
        Get = plist.get
    },
    BIT = {
        Band = bit.band
    },
    DATA = {
        Write = database.write,
        Read = database.read
    },
    MATH = {
        Abs = math.abs,
        Acos = math.acos,
        Asin = math.asin,
        Atan = math.atan,
        Atan2 = math.atan2,
        Ceil = math.ceil,
        Cos = math.cos,
        Deg = math.deg,
        Exp = math.exp,
        Floor = math.floor,
        Pow = math.pow,
        Fmod = math.fmod,
        Huge = math.huge,
        Log = math.log,
        Max = math.max,
        Maxinteger = math.maxinteger,
        Min = math.min,
        Mininteger = math.mininteger,
        Modf = math.modf,
        Pi = math.pi,
        Rad = math.rad,
        Random = math.random,
        Randomseed = math.randomseed,
        Sin = math.sin,
        Sqrt = math.sqrt,
        Tan = math.tan,
        Tointeger = math.tointeger,
        Type = math.type,
        Ult = math.ult
    },
    STRING = {
        Format = string.format,
        Char = string.char,
        Gmatch = string.gmatch,
        Gsub = string.gsub,
        Upper = string.upper
    },
    REQUIRE = {
        Require = require
    },
    PANORAMA = panorama.open()
}

local animate = (function()
    local anim = {}

    local lerp = function(start, vend)
        return start + (vend - start) * (globals.frametime() * 6)
    end

    local lerp_notify = function(start, vend)
        return start + (vend - start) * (globals.frametime() * 8)
    end

    anim.new_notify = function(value, startpos, endpos, condition)
        if condition ~= nil then
            if condition then
                return lerp_notify(value,startpos)
            else
                return lerp_notify(value,endpos)
            end
        else
            return lerp_notify(value,startpos)
        end
    end

    anim.new = function(value, startpos, endpos, condition)
        if condition ~= nil then
            if condition then
                return lerp(value,startpos)
            else
                return lerp(value,endpos)
            end
        else
            return lerp(value,startpos)
        end
    end

    anim.color_lerp = function(color, color2, end_value, condition)
        if condition ~= nil then
            if condition then
                color.r = lerp(color.r,color2.r)
                color.g = lerp(color.g,color2.g)
                color.b = lerp(color.b,color2.b)
                color.a = lerp(color.a,color2.a)
            else
                color.r = lerp(color.r,end_value.r)
                color.g = lerp(color.g,end_value.g)
                color.b = lerp(color.b,end_value.b)
                color.a = lerp(color.a,end_value.a)
            end
        else
            color.r = lerp(color.r,color2.r)
            color.g = lerp(color.g,color2.g)
            color.b = lerp(color.b,color2.b)
            color.a = lerp(color.a,color2.a)
        end
        return { r = color.r , g = color.g , b = color.b , a = color.a }
    end

    anim.adapting = function(cur, min, max, target, step, speed)
        local step = step or 1
        local speed = speed or 0.1

        if cur < min + step then
            target = max
        elseif cur > max - step then
            target = min
        end
        return cur + (target - cur) * speed * (globals.absoluteframetime() * 10)
    end
    return anim
end)()

gradient_text = function(r1, g1, b1, a1, r2, g2, b2, a2, m)
    local output = ''
    local len = #m
    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len

    for i=1, len do
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, m:sub(i, i))
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end
    return output
end

local screen = {client.screen_size()}
local x_offset, y_offset = screen[1], screen[2]
local x, y =  x_offset/2,y_offset/2 

local visuals = {}

visuals = {

    ['stored'] = {
        ['script_load'] = {
            ['start'] = globals.realtime(),
            ['show'] = false,
            ['alpha'] = 0
        },
        ['crosshair'] = {
            ['alpha'] = 0,
            ['scoped'] = 0,
            ['values'] = {0, 0, 0, 0, 0, 0},
            ['doubletap_color'] = {r = 0 , g = 0 , b = 0 , a = 0},
            ['default_dt'] = {r = 0, g = 0, b = 0, a = 0},
            ['modern'] = {speed = 1, text_alpha = 0, text_alpha2 = 0, color = {r = 0 , g = 0 , b = 0 , a = 0}},
            ['fake_anim'] = 0
        },
        ['user_count'] = {
            ['alpha'] = 0,
            ['offset'] = 0
        },
    },

    script_load = function()
        local v = visuals['stored']['script_load']
        v['alpha'] = animate.new(v['alpha'],1,0,not v['show'])
        local svg_300 = '<svg width="554.4" height="649.6" version="1.1" viewBox="0 0 554.4 649.6" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><path d="m273.53 531.63-1.2395-1-9.3067-28.8-4.6424-12-9.818-24-17.748-35.2-8.6508-14.4-15.06-22.4-13.001-16.784-19.226-19.216-13.574-10.574-11.2-7.2366-9.0585-4.8934-13.342-5.418-12.169-3.7597 20.169-13.528 9.6-7.622 9.7313-10.168 5.9613-8.9982 4.6761-11.49 1.8536-10.644-.44579-8.4502-.44578-8.4502-4.2296-17.567-5.4146-16.362-3.4264-8.6192-3.4264-8.6192-11.531-23.496-7.5372-13.304-4.8378-8-12.086-19.2-21.358-31.75.61216-.61215 17.504 13.176 11.2 8.674 24 20.062 23.2 20.715 16.8 15.328 26.449 26.408 9.6565 10.4 16.766 20 7.9794 11.2 2.9747 4.5356 2.9746 4.5356v1.1609l-8.4-7.896-12.975-9.8364-20.234-13.684-10.792-5.4178-12.287-4.9044-2.8566-.53589-2.8566-.53591v.93244l4.1268 9.2456 4.7217 12.8 1.1757 6.7048 1.1757 6.7048-.006 12.99-2.3936 14.758-4.6527 11.712-8.0522 13.994-6.7765 8.3356-8.7112 9.0411.89866 1.4541 14.094 8.5536 12.8 9.9316 12.087 11.02 15.664 17.105 8.6992 10.895 11.805 16.8 11.046 17.6 9.4292 16.8 6.1129 11.2 2.6527 5.2h13.131l10.79-19.6 14.435-24 7.9316-12 9.7475-13.6 14.579-17.6 15.89-16.128 13.6-10.775 18.4-12.278.42665-.1792-10.184-10.541-9.981-14.573-6.3921-13.64-2.0371-8.1431-2.0371-8.1431-.062-18.4 2.1096-8 2.1096-8 7.2467-17.467-.73833-.73832-7.6613 1.8785-11.368 4.6767-11.832 6.6356-8.8 5.7196-20.8 15.067-9.2 8.9784v-1.4415l11.966-17.817 21.136-25.491 40.099-39.849 18.279-16.151 22.521-19.81 25.818-20.99 9.3822-7.2772 10.8-7.6632v.76582l-27.647 41.375-8.2699 13.6-9.9886 17.6-6.2336 12-7.3055 16-4.6248 12-2.6501 8-2.6501 8-1.3152 4.4709-1.3152 4.4709-1.1951 7.9291-1.1951 7.9291-.005 5.9345-.005 5.9345 1.8287 10.531 5.3676 11.792 3.5177 4.9042 3.5177 4.9042 13.368 12.954 23.735 15.578-.40504.40505-.40504.40504-18.925 6.3179-14.174 7.2282-10.16 6.1725-12.466 9.3149-16.602 16.025-13.127 16-11.902 16-9.0454 14.4-11.38 20-15.733 32-3.6731 8.8-3.6731 8.8-5.4866 14.4-6.3764 19.2-3.4474 11.6h-2.8481l-1.2396-1zm-39.27-181.47-3.0032-.70782-7.7678-3.9362-13.046-12.273-9.6518-12.809.37408-.37406.37407-.37407 9.3241 2.0225 13.355 6.9654 9.2924 6.3104 4.9404 5.9936 1.3228 4.0254 1.3228 4.0253.36908 1 .36906 1-4.5712-.1608zm75.805-1.7315.52931-2.6.73607-2.8922.73608-2.8922 7.5964-7.1049 10.259-6.012 10.541-4.8537 8.6625-3.0491.27134.27135.27136.27134-12.746 16.847-8.8057 8.0479-7.4467 4.162-8.097 2.4046h-3.0367z" stroke-width=".8" fill="#ffffff"/></svg>'
        local svg = renderer.load_svg(svg_300, 300 , 300 )
        local text = gradient_text(255, 255, 255,255 * v['alpha'] + 0.5,128,128,240,255 * v['alpha'] + 0.5, "P l u g W a l k")
        local text2 = gradient_text(255, 255, 255,255 * v['alpha'] + 0.5,128,128,240,255 * v['alpha'] + 0.5, "B E T A")
        local text_sizex, text_sizey = renderer.measure_text("+",text)

        renderer.blur(0, 0, x_offset * v['alpha'], y_offset * v['alpha'])
        renderer.rectangle(0, 0, x_offset, y_offset, 10, 10, 10, 150*v['alpha'])
        renderer.texture(svg, x - (312/2 + 7) * v['alpha'] + 15, y + (800/3 - 100) * v['alpha'] - 300, 300 * v['alpha'], 300 * v['alpha'], 128, 128, 240, math.floor(255 * v['alpha']), "f")
        renderer.text(x -text_sizex/2 + 4, y + 70 + (40 * v['alpha']),255,255,255,255* v['alpha'],"+",0,text)
        renderer.text(x -text_sizex/4 + 4, y + 95 + (40 * v['alpha']),255,255,255,255* v['alpha'],"+",0,text2)
        renderer.gradient(x -text_sizex/2 + 4, y + 120 + ( 40 *  v['alpha']) ,text_sizex * v['alpha'],3,115, 154, 255,255 ,128,128,240, math.floor(255 * v['alpha']),true)
        if v['start'] + 2.5 < globals.realtime() then
            v['start'] = globals.realtime()
            v['show'] = true
        end
    end,
}
API.CLIENT.Callback("paint_ui",visuals.script_load)
local main = function ()
    local lp = API.ENT.LocalPlayer()

    local screen = {API.CLIENT.Screen()}
    local center = {screen[1]/2, screen[2]/2}
    local lib = {
        ['gamesense/antiaim_funcs'] = 'https://gamesense.pub/forums/viewtopic.php?id=29665',
        ['gamesense/base64'] = 'https://gamesense.pub/forums/viewtopic.php?id=21619',
        ['gamesense/clipboard'] = 'https://gamesense.pub/forums/viewtopic.php?id=28678',
        ['gamesense/http'] = 'https://gamesense.pub/forums/viewtopic.php?id=19253',
        ['gamesense/images'] = "https://gamesense.pub/forums/viewtopic.php?id=22917"

    }
    local lib_notsub = { }
    local case = {
        ctx,
        self
    }

    for i, v in API.ENV.Pairs(lib) do
        if not API.ENV.Pcall(API.REQUIRE.Require, i) then
            lib_notsub[#lib_notsub + 1] = lib[i]
        end
    end

    for i=1, #lib_notsub do
        API.ENV.Error("pls sub the API " .. API.STRING.Char(10) .. "" .. API.TABLE.Concat(lib_notsub, ", " .. API.STRING.Char(10) .. ""))
    end
    local libs = {
        antiaim_funcs = API.REQUIRE.Require('gamesense/antiaim_funcs'),
        pretty_json = API.REQUIRE.Require('gamesense/pretty_json'),
        entity = API.REQUIRE.Require('gamesense/entity'),
        inspect = API.REQUIRE.Require('gamesense/inspect'),
        base64 = API.REQUIRE.Require('gamesense/base64'),
        clipboard = API.REQUIRE.Require('gamesense/clipboard'),
        http = API.REQUIRE.Require('gamesense/http'),
        images = API.REQUIRE.Require('gamesense/images'),
        ffi = API.REQUIRE.Require("ffi"),
        bit = API.REQUIRE.Require("bit"),
        vector = API.REQUIRE.Require("vector"),
    }

    local js = panorama.open()
    local persona_api = js.MyPersonaAPI
    local name = persona_api.GetName()


    local antiaim = {
        enabled = API.MENU.Reference("AA", "Anti-aimbot angles", "Enabled"),
        pitch = API.MENU.Reference("AA", "Anti-aimbot angles", "Pitch"),
        yaw_base = API.MENU.Reference("AA", "Anti-aimbot angles", "Yaw base"),
        yaw = { API.MENU.Reference("AA", "Anti-aimbot angles", "Yaw") },
        yaw_jitter = { API.MENU.Reference("AA", "Anti-aimbot angles", "Yaw jitter") } ,
        body_yaw = { API.MENU.Reference("AA", "Anti-aimbot angles", "Body yaw") },
        freestanding_body_yaw = API.MENU.Reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
        edge_yaw = API.MENU.Reference("AA", "Anti-aimbot angles", "Edge yaw"),
        freestanding = { API.MENU.Reference("AA", "Anti-aimbot angles", "Freestanding") },
        roll =  API.MENU.Reference("AA", "Anti-aimbot angles", "Roll") ,

        slow_motion = { API.MENU.Reference("AA", "Other", "Slow motion") },
        --slow_motion_type = API.MENU.Reference("AA", "Other", "Slow motion type"),
        leg_movement = API.MENU.Reference("AA", "Other", "Leg movement"),
        hide_shots = { API.MENU.Reference("AA", "Other", "On shot anti-aim") },
        fake_peek = { API.MENU.Reference("AA", "Other", "Fake peek") },
        fake_lag = API.MENU.Reference("AA", "Fake lag", "Enabled") ,
        fake_lag_limit = API.MENU.Reference("AA", "Fake lag", "Limit") ,
        anti_untrusted = API.MENU.Reference("MISC", "Settings", "Anti-untrusted"),

        fakeduck = API.MENU.Reference("Rage", "Other", "Duck peek assist"),

        doubletap = {API.MENU.Reference("RAGE","Aimbot","Double tap")},
        force_body_aim = API.MENU.Reference("RAGE", "Aimbot", "Force body aim"),
        force_safe_point = API.MENU.Reference("RAGE", "Aimbot", "Force safe point"),
        damage = API.MENU.Reference("RAGE", "Aimbot", "Minimum damage"),
        hitchance = API.MENU.Reference("RAGE", "Aimbot", "Minimum hit chance"),
        ping_spike = {API.MENU.Reference("MISC", "miscellaneous", "ping spike")},
        thirdperson = {API.MENU.Reference("VISUALS", "Effects", "Force third person (alive)")},
        menu_color = API.MENU.Reference("MISC", "Settings", "Menu color"),

        quick_peek_assist = { API.MENU.Reference("RAGE", "Other", "Quick peek assist") },
    }

    local ui_fn = {
        includes = function(table, key)
            for i = 1, #table do
                if table[i] == key then
                    return true, i
                end
            end

            return false, nil
        end,

        set_visible = function(state, ...)
            local args = {...}

            for i = 1, #args do
                API.MENU.Visible(args[i], state)
            end
        end,

        mouse_within = function(x, y, w, h)
            local mouse = {API.MENU.MousePos()}
            return mouse[1] > x and mouse[1] < x + w and mouse[2] > y and mouse[2] < y + h
        end
    }

    local math_fn = {
        TIME_TO_TICKS = function(t)
            return API.MATH.Floor(t / API.GLOBALS.Ticks() + 0.5)
        end,

        TICKS_TO_TIME = function(ticks)
            return API.GLOBALS.Ticks() * ticks
        end,

        clamp = function(min, max, value)
            if value > max then
                return max
            elseif value < min then
                return min
            else
                return value
            end
        end,

        normalize_yaw = function(yaw)
            yaw = (yaw % 360 + 360) % 360
            return yaw > 180 and yaw - 360 or yaw
        end,

        distance2d = function(start_pos, end_pos)
            local delta = {start_pos[1] - end_pos[1], start_pos[2] - end_pos[2]}
            return API.MATH.Sqrt(delta[1] * delta[1] + delta[2] * delta[2])
        end,

        distance3d = function(start_pos, end_pos)
            local delta = {start_pos[1] - end_pos[1], start_pos[2] - end_pos[2], start_pos[3] - end_pos[3]}
            return API.MATH.Sqrt(delta[1] * delta[1] + delta[2] * delta[2] + delta[3] * delta[3])
        end,

        lerp = function(one, two, percent) 
            local return_results = {}
            for i=1, #one do
                return_results[i] = one[i] + (two[i] - one[i]) * percent
            end
            return return_results
        end,

        calc_angle = function(start_pos, end_pos)
            if start_pos[1] == nil or end_pos[1] == nil then
                return {0, 0}
            end

            local delta_x, delta_y, delta_z = end_pos[1] - start_pos[1], end_pos[2] - start_pos[2], end_pos[3] - start_pos[3]

            if delta_x == 0 and delta_y == 0 then
                return {(delta_z > 0 and 270 or 90), 0}
            else
                local hyp = API.MATH.Sqrt(delta_x*delta_x + delta_y*delta_y)
        
                local pitch = API.MATH.Deg(API.MATH.Atan2(-delta_z, hyp))
                local yaw = API.MATH.Deg(API.MATH.Atan2(delta_y, delta_x))
        
                return {pitch, yaw}
            end
        end,

        dot = function(vec1, vec2)
            return vec1[1] * vec2[1] + vec1[2] * vec2[2] + vec1[3] * vec2[3]
        end,

        angle_vector = function(angle)
            local p, y = API.MATH.Rad(angle[1]), API.MATH.Rad(angle[2])
            local sp, cp, sy, cy = API.MATH.Sin(p), API.MATH.Cos(p), API.MATH.Sin(y), API.MATH.Cos(y)
            return {cp*cy, cp*sy, -sp}
        end,

        normalize_vector = function(vec)
            local len = API.MATH.Sqrt(vec[1] * vec[1] + vec[2] * vec[2] + vec[3] * vec[3])
            if len == 0 then
                return 0, 0, 0
            end
            local r = 1 / len
            return {vec[1]*r, vec[2]*r, vec[3]*r}
        end,

        fov = function(self, start_pos, end_pos, angle)
            if start_pos == nil or end_pos == nil or angle == nil then
                return 180
            end

            local vec = self.angle_vector(angle)
            local normalize_vec = self.normalize_vector({end_pos[1] - start_pos[1], end_pos[2] - start_pos[2], end_pos[3] - start_pos[3]})

            return API.MATH.Deg(API.MATH.Acos(self.dot(vec, normalize_vec)))
        end,

        extrapolate_origin = function(self, origin, angle, units)
            local angle_vec = self.angle_vector(angle)
        
            local results = {
                origin[1] + angle_vec[1] * units,
                origin[2] + angle_vec[2] * units,
                origin[3] + angle_vec[3] * units
            }
            return results
        end,

        extrapolate_origin_wall = function(self, ignore, origin, yaw, units)
            local forward = self.angle_vector({0, yaw})
            local trace = {API.CLIENT.Trace(ignore, origin[1], origin[2], origin[3], origin[1] + (forward[1] * units), origin[2] + (forward[2] * units), origin[3] + (forward[3] * units))}
            return {
                origin[1] + (forward[1] * (units * trace[1])),
                origin[2] + (forward[2] * (units * trace[1])),
                origin[3] + (forward[3] * (units * trace[1]))
            }, trace[1]
        end,

        extrapolate_angle_origin_wall = function(self, ignore, origin, angle, units)
            for i = 1, #units do
                units[i] = API.MATH.Abs(units[i])
            end

            local forward = self.angle_vector(angle)
            local trace = {API.CLIENT.Trace(ignore, origin[1], origin[2], origin[3], origin[1] + (forward[1] * units[1]), origin[2] + (forward[2] * units[2]), origin[3] + (forward[3] * units[3]))}
            return {
                origin[1] + (forward[1] * (units[1] * trace[1])),
                origin[2] + (forward[2] * (units[2] * trace[1])),
                origin[3] + (forward[3] * (units[3] * trace[1]))
            }
        end,

        extrapolate_player_position = function(player, origin, ticks)
            local vel = {API.ENT.Prop(player, "m_vecVelocity")}
        
            if vel[1] == nil then
                return nil
            end
        
            local pred_tick = API.GLOBALS.Ticks() * ticks
        
            return {
                origin[1] + (vel[1] * pred_tick),
                origin[2] + (vel[2] * pred_tick),
                origin[3] + (vel[3] * pred_tick)
            }
        end
    }

    local render_fn = {
        --gradient line.
        line = function(pos, end_pos, thickness, color, end_color, precision)
            pos[3] = 0
            end_pos[3] = 0

            local cxy = math_fn.lerp(pos, end_pos, 0.5)
            local max_distance = math_fn.distance2d(pos, cxy) * 1.25

            local angle = math_fn.calc_angle(pos, end_pos)
            local max = precision

            for i = 1, max do
                local c1 = math_fn.lerp(pos, end_pos, (i - 1) / max)
                local c2 = math_fn.lerp(pos, end_pos, i / max)
                local col = math_fn.lerp(color, end_color, (i - 1) / max)

                
                local distance = 1 - math_fn.clamp(0, 1, 1.2 * (math_fn.distance2d(c1, cxy) / max_distance))
                col[4] = col[4] * distance

                local xy1 = math_fn.angle_vector({0, math_fn.normalize_yaw(angle[2] + 90), 0})

                local xa = xy1[1] * (thickness / 2)
                local ya = xy1[2] * (thickness / 2)
                local xa2 = xy1[1] * (thickness / 4)
                local ya2 = xy1[2] * (thickness / 4)
                local p1 = {c1[1] + xa, c1[2] + ya, c1[3]}
                local p1_5 = {c1[1] + xa2, c1[2] + ya2, c1[3]}
                local p2 = {c1[1] - xa, c1[2] - ya, c1[3]}
                local p2_5 = {c1[1] - xa2, c1[2] - ya2, c1[3]}
                local p3 = {c2[1] + xa, c2[2] + ya, c2[3]}
                local p3_5 = {c2[1] + xa2, c2[2] + ya2, c2[3]}
                local p4 = {c2[1] - xa, c2[2] - ya, c2[3]}
                local p4_5 = {c2[1] - xa2, c2[2] - ya2, c2[3]}

                --outer stripe
                API.RENDER.Triangle(p1[1], p1[2], p3[1], p3[2], p1_5[1], p1_5[2], col[1], col[2], col[3], col[4] * 0.5 * distance)
                API.RENDER.Triangle(p1_5[1], p1_5[2], p3[1], p3[2], p3_5[1], p3_5[2], col[1], col[2], col[3], col[4] * 0.5 * distance)

                --middle 
                API.RENDER.Triangle(p1_5[1], p1_5[2], p2_5[1], p2_5[2], p3_5[1], p3_5[2], col[1], col[2], col[3], col[4] * distance)
                API.RENDER.Triangle(p2_5[1], p2_5[2], p3_5[1], p3_5[2], p4_5[1], p4_5[2], col[1], col[2], col[3], col[4] * distance)

                --outer stripe
                API.RENDER.Triangle(p2[1], p2[2], p4[1], p4[2], p2_5[1], p2_5[2], col[1], col[2], col[3], col[4] * 0.5 * distance)
                API.RENDER.Triangle(p2_5[1], p2_5[2], p4[1], p4[2], p4_5[1], p4_5[2], col[1], col[2], col[3], col[4] * 0.5 * distance)       
            end

            --renderer.line(pos[1], pos[2], end_pos[1], end_pos[2], 255, 255, 255, color[4])
        end,
        
        --world gradient line (bo$$)
        world_line = function(pos, yaw, distance, thickness, color, end_color)
            local end_pos = {pos[1] + API.MATH.Cos(API.MATH.Rad(yaw)) * distance, pos[2] + API.MATH.Sin(API.MATH.Rad(yaw)) * distance, pos[3]}
            
            local angle = math_fn.calc_angle(pos, end_pos)
            local max = 12

            local cxy = math_fn.lerp(pos, end_pos, 0.5)
            local max_distance = math_fn.distance2d(pos, cxy) * 1.25
            
            for i = 1, max do
                local c1 = math_fn.lerp(pos, end_pos, (i - 1) / max)
                local c2 = math_fn.lerp(pos, end_pos, i / max)
                local col = math_fn.lerp(color, end_color, (i - 1) / max)

                local xy1 = {
                    API.MATH.Cos(API.MATH.Rad(math_fn.normalize_yaw(yaw + 90))),
                    API.MATH.Sin(API.MATH.Rad(math_fn.normalize_yaw(yaw + 90))),
                }

                local distance = 1 - math_fn.clamp(0, 1, 1.2 * (math_fn.distance2d(c1, cxy) / max_distance))
                col[4] = col[4] * distance

                local xa = xy1[1] * (thickness / 2)
                local ya = xy1[2] * (thickness / 2)
                local xa2 = xy1[1] * (thickness / 4)
                local ya2 = xy1[2] * (thickness / 4)
                local p1 = {c1[1] + xa, c1[2] + ya, c1[3]}
                local p1_5 = {c1[1] + xa2, c1[2] + ya2, c1[3]}
                local p2 = {c1[1] - xa, c1[2] - ya, c1[3]}
                local p2_5 = {c1[1] - xa2, c1[2] - ya2, c1[3]}
                local p3 = {c2[1] + xa, c2[2] + ya, c2[3]}
                local p3_5 = {c2[1] + xa2, c2[2] + ya2, c2[3]}
                local p4 = {c2[1] - xa, c2[2] - ya, c2[3]}
                local p4_5 = {c2[1] - xa2, c2[2] - ya2, c2[3]}

                p1 = {API.RENDER.World(p1[1], p1[2], p1[3])}
                p1_5 = {API.RENDER.World(p1_5[1], p1_5[2], p1_5[3])}
                p2 = {API.RENDER.World(p2[1], p2[2], p2[3])}
                p2_5 = {API.RENDER.World(p2_5[1], p2_5[2], p2_5[3])}
                p3 = {API.RENDER.World(p3[1], p3[2], p3[3])}
                p3_5 = {API.RENDER.World(p3_5[1], p3_5[2], p3_5[3])}
                p4 = {API.RENDER.World(p4[1], p4[2], p4[3])}
                p4_5 = {API.RENDER.World(p4_5[1], p4_5[2], p4_5[3])}

                if p1[1] and p2[1] and p3[1] and p4[1] and p1_5[1] and p2_5[1] and p3_5[1] and p4_5[1] then
                    --outer stripe
                    API.RENDER.Triangle(p1[1], p1[2], p3[1], p3[2], p1_5[1], p1_5[2], col[1], col[2], col[3], col[4] * 0.5)
                    API.RENDER.Triangle(p1_5[1], p1_5[2], p3[1], p3[2], p3_5[1], p3_5[2], col[1], col[2], col[3], col[4] * 0.5)

                    --middle 
                    API.RENDER.Triangle(p1_5[1], p1_5[2], p2_5[1], p2_5[2], p3_5[1], p3_5[2], col[1], col[2], col[3], col[4])
                    API.RENDER.Triangle(p2_5[1], p2_5[2], p3_5[1], p3_5[2], p4_5[1], p4_5[2], col[1], col[2], col[3], col[4])

                    --outer stripe
                    API.RENDER.Triangle(p2[1], p2[2], p4[1], p4[2], p2_5[1], p2_5[2], col[1], col[2], col[3], col[4] * 0.5)
                    API.RENDER.Triangle(p2_5[1], p2_5[2], p4[1], p4[2], p4_5[1], p4_5[2], col[1], col[2], col[3], col[4] * 0.5)        
                end
            end

            return end_pos
        end,

        rounded_gradient_rectangle = function(x, y, w, h, r, color1, color2, color3, color4, background, max_alpha, padding, thickness, percent)
            x = API.MATH.Floor(x)
            y = API.MATH.Floor(y)
            w = API.MATH.Floor(w)
            h = API.MATH.Floor(h)

            color1[4] = API.MATH.Min(color1[4], max_alpha)
            color2[4] = API.MATH.Min(color2[4], max_alpha)
            color3[4] = API.MATH.Min(color3[4], max_alpha)
            color4[4] = API.MATH.Min(color4[4], max_alpha)
            background[4] = API.MATH.Min(background[4], max_alpha)

            local anims = {}

            anims[1] = API.MATH.Max(0, API.MATH.Min(percent * 2, 1))
            anims[2] = anims[1] == 1 and API.MATH.Max(0, API.MATH.Min((percent - 0.5) * 2, 1)) or 0

            --Background
            API.RENDER.Rectangle(x + r, y + r, w - r * 2, h - r * 2, background[1], background[2], background[3], background[4] * anims[1])

            API.RENDER.Rectangle(x + r, y, w - (r * 2), r, background[1], background[2], background[3], background[4] * anims[1])
            API.RENDER.Rectangle(x, y + r, r, h - (r * 2), background[1], background[2], background[3], background[4] * anims[1])
            API.RENDER.Rectangle(x + r, y + h - r, w - (r * 2), r, background[1], background[2], background[3], background[4] * anims[1])
            API.RENDER.Rectangle(x + w - r, y + r, r, h - (r * 2), background[1], background[2], background[3], background[4] * anims[1])

            API.RENDER.Circle(x + r, y + r, background[1], background[2], background[3], background[4] * anims[1], r, 180, 0.25)
            API.RENDER.Circle(x + w - r, y + r, background[1], background[2], background[3], background[4] * anims[1], r, 90, 0.25)
            API.RENDER.Circle(x + r, y + h - r, background[1], background[2], background[3], background[4] * anims[1], r, 270, 0.25)
            API.RENDER.Circle(x + w - r, y + h - r, background[1], background[2], background[3], background[4] * anims[1], r, 0, 0.25)

            --Gradient outline
            API.RENDER.Gradient(x + r, y + padding, (w - (r * 2)), thickness, color1[1], color1[2], color1[3], color1[4] * anims[2], color2[1], color2[2], color2[3], color2[4] * anims[2], true)
            API.RENDER.Gradient(x + w - padding - thickness, y + r, thickness, (h - (r * 2)), color2[1], color2[2], color2[3], color2[4] * anims[2], color3[1], color3[2], color3[3], color3[4] * anims[2], false)
            API.RENDER.Gradient(x + w - padding - r + 1, y + h - padding - thickness, -((w) - (r * 2)), thickness, color3[1], color3[2], color3[3], color3[4] * anims[2], color4[1], color4[2], color4[3], color4[4] * anims[2], true)
            API.RENDER.Gradient(x + padding, y + h - r, thickness, -(h - (r * 2)), color4[1], color4[2], color4[3], color4[4] * anims[2], color1[1], color1[2], color1[3], color1[4] * anims[2], false)

            API.RENDER.CircleOutline(x + r + padding, y + r + padding, color1[1], color1[2], color1[3], color1[4] * anims[2], r, 180, 0.25, thickness)
            API.RENDER.CircleOutline(x + w - r - padding, y + r + padding, color2[1], color2[2], color2[3], color2[4] * anims[2], r, 270, 0.25, thickness)
            API.RENDER.CircleOutline(x + r + padding, y + h - r - padding, color4[1], color4[2], color4[3], color4[4] * anims[2], r, 90, 0.25, thickness)
            API.RENDER.CircleOutline(x + w - r - padding, y + h - r - padding, color3[1], color3[2], color3[3], color3[4] * anims[2], r, 0, 0.25, thickness)
        end,

        rounded_gradient = function(x, y, w, h, c1, c2, rad)
            API.RENDER.Circle(x + rad, y + rad, c1[1], c1[2], c1[3], c1[4], rad, 180, 0.25)
            API.RENDER.Circle(x + w - rad, y + rad, c2[1], c2[2], c2[3], c2[4], rad, 90, 0.25)
            API.RENDER.Circle(x + rad, y + h - rad, c1[1], c1[2], c1[3], c1[4], rad, 270, 0.25)
            API.RENDER.Circle(x + w - rad, y + h - rad, c2[1], c2[2], c2[3], c2[4], rad, 0, 0.25)

            API.RENDER.Rectangle(x, y + rad, rad, h - (rad * 2), c1[1], c1[2], c1[3], c1[4])
            API.RENDER.Rectangle(x + w - rad, y + rad, rad, h - (rad * 2), c2[1], c2[2], c2[3], c2[4])

            API.RENDER.Gradient(x + rad, y, w - rad * 2, h, c1[1], c1[2], c1[3], c1[4], c2[1], c2[2], c2[3], c2[4], true)
        end,
    }

    local gui2 = {
        data = {},

        create = function(self, index, name)
            self.data[index] = {
                name = name,
                click_pos = {nil, nil},
                pos = {nil, nil},
                size = {nil, nil},
                elements = {},
                active = false,
                anim = 0
            }
        end,

        update_size = function(self, index, pos, size)
            self.data[index].pos = pos
            self.data[index].size = size
        end,

        add_combo_list = function(self, index, name, list)
            local ref = API.MENU.Combobox("LUA", "A", index .. name .. " | PlugWalk gui", list)
            API.MENU.Visible(ref, false)

            API.TABLE.Insert(self.data[index].elements, {
                type = "combo_list",
                name = name,
                ref = ref,
                list = list
            })
        end,

        add_multi_list = function(self, index, name, list)
            local ref = API.MENU.Multiselect("LUA", "A", index .. name .. " | PlugWalk gui", list)
            API.MENU.Visible(ref, false)

            API.TABLE.Insert(self.data[index].elements, {
                type = "multi_list",
                name = name,
                ref = ref,
                list = list
            })
        end,

        get_combo = function(self, index, name)
            for i = 1, #self.data[index].elements do
                if self.data[index].elements[i].type == "combo_list" and self.data[index].elements[i].name == name then
                    return API.MENU.Get(self.data[index].elements[i].ref)
                end
            end
        end,

        get_multi = function(self, index, name)
            for i = 1, #self.data[index].elements do
                if self.data[index].elements[i].type == "multi_list" and self.data[index].elements[i].name == name then
                    return API.MENU.Get(self.data[index].elements[i].ref)
                end
            end
        end,

        init = function(self)
            self:create(1, "Logs")
            self:add_combo_list(1, "Font style:", {"Normal", "Bold", "Small"})

            self:create(2, "Local player")
            self:add_combo_list(2, "In-air legs:", {"Normal", "Static legs"})
            self:add_combo_list(2, "Slow motion legs:", {"Normal", "Static legs"})
            self:add_combo_list(2, "Legfucker:", {"Normal", "Funky Legs"})
            self:add_combo_list(2, "Land anim:", {"Normal", "Zero on land"})
        end,

        left_state = false,
        left_release = false,
        right_state = false,
        right_release = false,
        index_active = nil,

        measure_size = function(self, id)
            local size = {135, 30}

            for i = 1, #self.data[id].elements do
                local element = self.data[id].elements[i]

                if element.type == "combo_list" then
                    size[2] = size[2] + 27
                elseif element.type == "multi_list" then
                    size[2] = size[2] + 10
                end
            end

            return size
        end,

        run = function(self)
            local menu_inc = (1 / 0.4) * API.GLOBALS.Frametime()
            local menu_dec = (1 / 0.2) * API.GLOBALS.Frametime()
            local menu_open = API.MENU.IsOpen()
            local mouse = {API.MENU.MousePos()}

            local active_color = {API.MENU.Get(antiaim.menu_color)}
            local hover_color = {255, 255, 255, 255}
            local disabled_color = {200, 200, 200, 255}

            self.left_release = false
            local left_key = API.CLIENT.Key(0x01)
            if left_key ~= self.left_state then
                if left_key == false then
                    self.left_release = true
                end
                self.left_state = left_key
            end

            --right key
            self.right_release = false
            local right_key = API.CLIENT.Key(0x02)
            if right_key ~= self.right_state then
                if right_key == false then
                    self.right_release = true
                end
                self.right_state = right_key
            end

            --find active menu and update alphas
            self.index_active = nil

            for i = 1, #self.data do
                local data = self.data[i]

                if menu_open == false then
                    data.active = false
                end

                data.anim = math_fn.clamp(0, 1, data.anim + (data.active and menu_inc or -menu_dec))

                if data.active and data.pos[1] ~= nil and data.size[1] ~= nil then
                    self.index_active = i
                    break
                end
            end

            if self.index_active == nil then
                local index = nil
                local smallest_hover = math.huge

                for i = 1, #self.data do
                    local data = self.data[i]

                    if data.pos[1] ~= nil and data.size[1] ~= nil then

                        local area = data.size[1] * data.size[2]

                        if ui_fn.mouse_within(data.pos[1], data.pos[2], data.size[1], data.size[2]) and (area < smallest_hover) and self.right_release then
                            smallest_hover = area
                            index = i
                        end
                    end
                end

                if index ~= nil then
                    self.data[index].active = true
                    self.data[index].click_pos = mouse 
                end
            end

            for i = 1, #self.data do
                local data = self.data[i]
                local size = self:measure_size(i)

                if data.pos[1] ~= nil and data.size[1] ~= nil and data.anim > 0 then
                    local pos = {data.click_pos[1] - size[1]/2, data.click_pos[2] - size[2]/2}

                    render_fn.rounded_gradient_rectangle(pos[1], pos[2], size[1], size[2], 5, active_color, active_color, active_color, active_color, {25, 25, 25, data.anim * 200}, data.anim * 255, 2, 2, data.anim)
                
                    if ui_fn.mouse_within(pos[1], pos[2], size[1], size[2]) == false and self.left_release then
                        data.active = false
                    end

                    local offset = 6

                    local title_size = {API.RENDER.Measure("b", data.name)}
                    API.RENDER.Text(pos[1] + size[1]/2 - title_size[1]/2, pos[2] + offset, 220, 220, 220, 255 * data.anim, "b", 0, data.name)
                    offset = offset + title_size[2] + 2

                    for j = 1, #data.elements do
                        local element = data.elements[j]

                        if element.type == "combo_list" then
                            local cur_element = API.MENU.Get(element.ref)

                            local hover = ui_fn.mouse_within(pos[1], pos[2] + offset - 6, size[1], 28)
                            local col = hover and hover_color or disabled_color


                            API.RENDER.Rectangle(pos[1] + 4, pos[2] + offset, size[1] - 8, 14, 200, 200, 200, 10 * data.anim)
                            API.RENDER.Text(pos[1] + 8, pos[2] + offset, 255, 255, 255, 255 * data.anim, "", 0, element.name)
                            offset = offset + 15

                            if hover then
                                local item_pos = 0

                                for i = 1, #element.list do
                                    if element.list[i] == cur_element then
                                        item_pos = i
                                        break
                                    end
                                end

                                if self.left_release then
                                    if item_pos + 1 > #element.list then
                                        item_pos = 1
                                    else 
                                        item_pos = item_pos + 1
                                    end
                                elseif self.right_release then
                                    if item_pos - 1 < 1 then
                                        item_pos = #element.list
                                    else 
                                        item_pos = item_pos - 1
                                    end
                                end
                                API.MENU.Set(element.ref, element.list[item_pos])
                            end
                            API.RENDER.Text(pos[1] + 8, pos[2] + offset, col[1], col[2], col[3], 255 * data.anim, "b", 0, cur_element)
                            offset = offset + 14               
                        end
                    end
                end
            end
        end,

        setup_command = function(self, cmd)
            if self.index_active == nil then
                return
            end

            cmd.in_attack = 0
            cmd.in_attack2 = 0
        end,
    }
    gui2:init()
    local obex_data =  {username = 'discord.gg/scriptleaks', build = 'Source'}
    local status = {
        build = obex_data.build,
        last_updatetime = "01/06/23",
        username = obex_data.username
    }

    local check_roll = false

    local main = {}
    local gui = {}
    local funcs = {}
    local render = {}
    local g_antiaim = {}

    funcs.misc = {}

    function funcs.misc.lua_msg(msg)
        API.CLIENT.Log(30, 187, 214,'[PlugWalk] '..msg)
    end

    funcs.ui = {}

    function funcs.ui:str_to_sub(input, sep)
        local t = {}
        for str in API.STRING.Gmatch(input, "([^"..sep.."]+)") do
            t[#t + 1] = API.STRING.Gsub(str, "" .. API.STRING.Char(10) .. "", "")
        end
        return t
    end


    function funcs.ui:arr_to_string(arr)
        arr = API.MENU.Get(arr)
        local str = ""
        for i=1, #arr do
            str = str .. arr[i] .. (i == #arr and "" or ",")
        end

        if str == "" then
            str = "-"
        end

        return str
    end


    function funcs.ui:to_boolean(str)
        if str == "true" or str == "false" then
            return (str == "true")
        else
            return str
        end
    end

    function funcs.ui:table_contains(tbl, val)
        for i=1,#tbl do
            if tbl[i] == val then
                return true
            end
        end
        return false
    end

    funcs.math = {}

    funcs.aa = {}


    function main:ui(register,need_export,... )
        local number_ = register
        if API.ENV.Type(number_) == 'number' then
            API.TABLE.Insert(gui.callback,number_)
        end

        if need_export then
            if API.ENV.Type(number_) == 'number' then
                API.TABLE.Insert(gui.export[API.ENV.Type(API.MENU.Get(number_))],number_)
            end
        end

        return number_
    end

    local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
        local output = ''
        local len = #text-1
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len
        for i=1, len+1 do
            output = output .. (API.STRING.Char(7) .. '%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
            r1 = r1 + rinc
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc
        end

        return output
    end
    gui.callback = {}
    gui.export = {
        ['number'] = {},
        ['boolean'] = {},
        ['table'] = {},
        ['string'] = {}
    }
    gui.tab = {
        "AA","Anti-aimbot angles","RAGE","Other"
    }

    local menu1,menu2,menu3,menu4 = "646464FF","646464FF","646464FF","646464FF"
    local _state = {"Stand","Move","Slow walk","Duck","Air"}
    local __state = {"\a7BDAEAFF[ST]\aFFFFFFC8","\a7BDAEAFF[M]\aFFFFFFC8","\a7BDAEAFF[SW]\aFFFFFFC8","\a7BDAEAFF[D]\aFFFFFFC8","\a7BDAEAFF[A]\aFFFFFFC8"}

    gui.menu = {
        spacing = main:ui(API.MENU.Label(gui.tab[1],gui.tab[2],"                                       "),false),

        info_1 = main:ui(API.MENU.Label(gui.tab[1],gui.tab[2],"\aAAC8FFFF[PlugWalk BETA]"),false),
        info_2 = main:ui(API.MENU.Label(gui.tab[1],gui.tab[2],"PlugWalk version: "..status.build..""),false),
        info_2__ = main:ui(API.MENU.Label(gui.tab[1],gui.tab[2],"Redid Roll and Dangerous Preset"),false),
        info_2_ = main:ui(API.MENU.Label(gui.tab[1],gui.tab[2],"Anti-Bruteforcing now works properly"),false),
        info_2___ = main:ui(API.MENU.Label(gui.tab[1],gui.tab[2],"Fixed Modern indicator"),false),
        info_user = main:ui(API.MENU.Label(gui.tab[1],gui.tab[2],"Welcome！\aAAC8FFFF"..status.username),false),
        info_3_ = main:ui(API.MENU.Label(gui.tab[1],gui.tab[2],"Current build: \aAAC8FFFF"..status.build),false),
        info_4_ = main:ui(API.MENU.Label(gui.tab[1],gui.tab[2],"Last update time：\aAAC8FFFF"..status.last_updatetime),false),


        master_swtich = main:ui(API.MENU.Checkbox(gui.tab[1],gui.tab[2],"[Enable] \aAAC8FFFFPlug\aFFFFFFFFWalk"),true),
        main_list = main:ui(API.MENU.Multiselect(gui.tab[1],gui.tab[2],"\a7BDAEAFF[+]\aFFFFFFC8 Main feature list",
        "\a"..menu1.."                       Indicators","\a"..menu2.."                  Built-in presets","\a"..menu3.."             Extra antiaim settings","\a"..menu4.."                   Misc features","\a707070E6 -"),true),
        presets = main:ui(API.MENU.Combobox(gui.tab[1],gui.tab[2],"[-] Presets manager",{"Dangerous","Meta","Dynamic","Custom"}),true),
        preset_static = main:ui(API.MENU.Multiselect(gui.tab[1],gui.tab[2],"Presets suppress jitter select","\a646464FF Stand","\a646464FF Move","\a646464FF Slow walk","\a646464FF Duck","\a646464FF Air"),true),
        indicator_settings = main:ui(API.MENU.Multiselect(gui.tab[1],gui.tab[2],"\a7BDAEAFF[~]\aFFFFFFC8 Indicator settings","\a646464FF Manual arrows","\a646464FF Indicator Style","\a646464FF Watermark","\a646464FF Menu effect","\a646464FF Logs"),true),

        draw = main:ui(API.MENU.Multiselect(gui.tab[1],gui.tab[2],"Draw Logs",{"Center","Corner","Console"}),true),
        indicator_label = main:ui(API.MENU.Label(gui.tab[1],gui.tab[2],"Indicator Color")),
        indicator_color = main:ui(API.MENU.Colorpicker(gui.tab[1],gui.tab[2],"Mainc",30, 187, 214,255),true),
        watermark_label = main:ui(API.MENU.Label(gui.tab[1],gui.tab[2],"Watermark Color")),
        watermark_color = main:ui(API.MENU.Colorpicker(gui.tab[1],gui.tab[2],"watermark",30, 187, 214,255),true),
        watermark_label2 = main:ui(API.MENU.Label(gui.tab[1],gui.tab[2],"Watermark Gradient Color")),
        watermark_color2 = main:ui(API.MENU.Colorpicker(gui.tab[1],gui.tab[2],"watermark",30, 187, 214,255),true),
        center_mode = main:ui(API.MENU.Combobox(gui.tab[1],gui.tab[2],"[-] Indicator Style",{"Text","Pixel Text","Icon","Modern"}),true),
        manualarrow_size = main:ui(API.MENU.Combobox(gui.tab[1],gui.tab[2],"[-] Arrow mode",{"+","-"}),true),
        manualarrow_back = main:ui(API.MENU.Checkbox(gui.tab[1],gui.tab[2],"Background shadow"),true),
        manualarrow_distance = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],"Arrow distance",0,100,15,true,"*"),true),
        antiaim_settings = main:ui(API.MENU.Multiselect(gui.tab[1],gui.tab[2],"\a7BDAEAFF[~]\aFFFFFFC8 Extra settings","\a646464FF Manual antiaim","\a646464FF Antiaim on use","\a646464FF Edge yaw","\a646464FF Freestanding","\a646464FF Roll","\a646464FF AX","\a646464FF Anti-Bruteforce"),true),
        abf = main:ui(API.MENU.Checkbox(gui.tab[1],gui.tab[2],"Anti-Bruteforce"),true),
        forceroll_states = main:ui(API.MENU.Multiselect(gui.tab[1],gui.tab[2],"[-] Roll states","\a646464FF Stand","\a646464FF Move","\a646464FF Slow walk","\a646464FF Duck","\a646464FF Air","\a646464FF Use","\a646464FF Manual"),true),
        roll_key = main:ui(API.MENU.Hotkey(gui.tab[1],gui.tab[2],"[-] Roll states",0),false),
        roll_selects = main:ui(API.MENU.Multiselect(gui.tab[1],gui.tab[2],"[-] Extra roll options",{"\aF8F884D1 Match making","\aF8F884D1 Jitter","\aF8F884D1 Disable roll when peeking","\aFA3F3FFF Unsafe roll"})),
        roll_inverter = main:ui(API.MENU.Hotkey(gui.tab[1],gui.tab[2],"Inverter"),false),
        disable_use = main:ui(API.MENU.Checkbox(gui.tab[1],gui.tab[2],"Disable use to plant"),true),
        static_onuse = main:ui(API.MENU.Checkbox(gui.tab[1],gui.tab[2],"Force static on use"),true),
        prevent_jitter = main:ui(API.MENU.Checkbox(gui.tab[1],gui.tab[2],"Prevent sideways jitter"),true),
        manual_left = main:ui(API.MENU.Hotkey(gui.tab[1],gui.tab[2],"Manual left"),false),
        manual_right = main:ui(API.MENU.Hotkey(gui.tab[1],gui.tab[2],"Manual right"),false),
        manual_reset = main:ui(API.MENU.Hotkey(gui.tab[1],gui.tab[2],"Reset"),false),
        edge_yaw_key = main:ui(API.MENU.Hotkey(gui.tab[1],gui.tab[2],"Edge yaw"),false),
        freestanding_key = main:ui(API.MENU.Hotkey(gui.tab[1],gui.tab[2],"Freestanding"),false),
        misc_settings = main:ui(API.MENU.Multiselect(gui.tab[1],gui.tab[2],"\a7BDAEAFF[~]\aFFFFFFC8 Misc settings","\a646464FF Anti knife","\a646464FF Clantag"),true),
        trashtalk = main:ui(API.MENU.Combobox(gui.tab[1],gui.tab[2],"[-] Trashtalk",{"-","\a646464FF Trash talk","\a646464FF Wholesome Trash talk"}),true),
        pitch0_onknife = main:ui(API.MENU.Checkbox(gui.tab[1],gui.tab[2],"Reset pitch on knife"),true),
        knife_distance = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],"Anti knife radius",0,1000,280,true,"u"),true),
        --anim_list = main:ui(API.MENU.Multiselect(gui.tab[1],gui.tab[2],"Break anims","In air","On land","Leg fucker"),true),
        states_selection = main:ui(API.MENU.Combobox(gui.tab[1],gui.tab[2],"Condition selection",_state),true),

        fake_lag_limit_d = main:ui(API.MENU.Slider(gui.tab[1],"Fake lag","Limit",1,15,14),true),

        temp_manual = main:ui(API.MENU.Slider(gui.tab[1],"Fake lag","TEMP_STATE",0,3,0),true),   
    }

    -- API.MENU.Callback(gui.menu.master_swtich, function(item)
    --     API.MENU.Visible(gui.menu.main_list,API.MENU.Get(item))
    -- end)

    -- API.MENU.Callback(gui.menu.main_list, function(item)
    --     local enable = API.MENU.Get(gui.menu.master_swtich)
    --     API.MENU.Visible(gui.menu.presets,enable and funcs.ui:table_contains(API.MENU.Get(item),"\a"..menu2.."                  Built-in presets") == true)
    --     API.MENU.Visible(gui.menu.preset_static,enable and funcs.ui:table_contains(API.MENU.Get(item),"\a"..menu2.."                  Built-in presets") == true and API.MENU.Get(gui.menu.presets) ~= "Custom")

    --     API.MENU.Visible(gui.menu.indicator_settings,enable and funcs.ui:table_contains(API.MENU.Get(item),"\a"..menu1.."                       Indicators") == true)
    --     API.MENU.Visible(gui.menu.indicator_color,enable and funcs.ui:table_contains(API.MENU.Get(item),"\a"..menu1.."                       Indicators") == true)
    --     API.MENU.Visible(gui.menu.antiaim_settings,enable and funcs.ui:table_contains(API.MENU.Get(item),"\a"..menu3.."             Extra antiaim settings") == true)
    --     API.MENU.Visible(gui.menu.misc_settings,enable and funcs.ui:table_contains(API.MENU.Get(item),"\a"..menu4.."                   Misc features") == true)
    --     API.MENU.Visible(gui.menu.trashtalk,enable and funcs.ui:table_contains(API.MENU.Get(item),"\a"..menu4.."                   Misc features") == true)
    -- end)



    local namecombo = API.MENU.Combobox("misc", "miscellaneous", "Plugwalk Name Spammer", "All", "Get Good")
    local function spammer(name)
    API.CLIENT.Cvar("name", name)
    end
    local namesteal = API.MENU.Reference("misc", "miscellaneous", "Steal player name")
    local namecombo2 = API.MENU.Button("misc", "miscellaneous", "spam", function()
    local oldName = API.CLIENT.Get_cvar("name")
    if API.MENU.Get(namecombo) == "All" then
        API.MENU.Set(namesteal, true)
        spammer( "Plugwalk > All ")
        API.CLIENT.Delay(0.2, spammer, "Plugwalk > All  ")
        API.CLIENT.Delay(0.4, spammer, "Plugwalk > All   ")
        API.CLIENT.Delay(0.6, spammer, "Plugwalk > All    ")
        API.CLIENT.Delay(0.8, spammer, oldName)
        
    elseif API.MENU.Get(namecombo) == "Get Good" then
        API.MENU.Set(namesteal, true)
        spammer( "Get. ")
        API.CLIENT.Delay(0.2, spammer, "Get Good.  ")
        API.CLIENT.Delay(0.4, spammer, "Get Good Get.   ")
        API.CLIENT.Delay(0.6, spammer, "Get Good Get PlugWalk.    ")
        API.CLIENT.Delay(0.8, spammer, oldName)
    end
    end)
    gui.menu.custom = {}
    for k, v in API.ENV.Pairs(_state) do
        gui.menu.custom[k] = {
            enable = main:ui(API.MENU.Checkbox(gui.tab[1],gui.tab[2],"Enable ".._state[k].. " setting"),true),
            extra_options = main:ui(API.MENU.Multiselect(gui.tab[1],gui.tab[2],__state[k].." Extra options","Suppress jitter when choking commands","-"),true),
            yaw_mode = main:ui(API.MENU.Combobox(gui.tab[1],gui.tab[2],__state[k].." Yaw mode built-in funcs",{"Static","Period jitter \a7BDAEAFF[Tick]","Period jitter \a7BDAEAFF[Choke]","Period jitter \a7BDAEAFF[Desync]"}),true),
            static_yaw = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Yaw modifier",-80,80,0,true,"°"),true),
            tick_yaw_left = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Yaw modifier left \a7BDAEAFF[Tick]",-80,80,0,true,"°"),true),
            tick_yaw_right = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Yaw modifier right \a7BDAEAFF[Tick]",-80,80,0,true,"°"),true),
            choke_yaw_left = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Yaw modifier left \a7BDAEAFF[Choke]",-80,80,0,true,"°"),true),
            choke_yaw_right = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Yaw modifier right \a7BDAEAFF[Choke]",-80,80,0,true,"°"),true),
            desync_yaw_left = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Yaw modifier left \a7BDAEAFF[Desync]",-80,80,0,true,"°"),true),
            desync_yaw_right = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Yaw modifier right \a7BDAEAFF[Desync]",-80,80,0,true,"°"),true),
            yaw_jitter = main:ui(API.MENU.Combobox(gui.tab[1],gui.tab[2],__state[k].." Native yaw mode",{ "Off", "Offset", "Center", "Random" }),true),
            yaw_jitter_degree = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Native yaw jitter degree",0,120,0,true,"°"),true),
            self_bodyyaw_mode = main:ui(API.MENU.Combobox(gui.tab[1],gui.tab[2],__state[k].." Native body yaw mode",{ "Off", "Opposite", "Jitter", "Static"  }),true),
            bodyyaw_mode = main:ui(API.MENU.Combobox(gui.tab[1],gui.tab[2],__state[k].." Body yaw mode built-in funcs",{"Static","Period jitter","Recursion"}),true),
            bodyyaw_degree = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Body yaw modifier",-180,180,0,true,"°"),true),
            jitter_bodyyaw_degree_left = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Body yaw modifier left \a7BDAEAFF[Period]",-180,180,0,true,"°"),true),
            jitter_bodyyaw_degree_right = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Body yaw modifier right \a7BDAEAFF[Period]",-180,180,0,true,"°"),true),
            body_yaw_step_ticks = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Recursion ticks ",0,15,1,true,"'"),true),
            body_yaw_step_value = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Recursion value",0,180,5,true,"°"),true),
            step_bodyyaw_degree_left = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Body yaw modifier min \a7BDAEAFF[Recursion]",-180,180,0,true,"°"),true),
            step_bodyyaw_degree_right = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Body yaw modifier max \a7BDAEAFF[Recursion]",-180,180,0,true,"°"),true),
            fake_yaw_mode = main:ui(API.MENU.Combobox(gui.tab[1],gui.tab[2],__state[k].." Desync modifier mode built-in funcs",{"Static","Period tick jitter","Progressively increase"}),true),
            static_fakeyaw = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Fake yaw limit",0,60,58,true,"°"),true),
            jitter_fakeyaw_left = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Fake yaw limit left \a7BDAEAFF[Period]",0,60,30,true,"°"),true),
            jitter_fakeyaw_right = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Fake yaw limit right \a7BDAEAFF[Period]",0,60,30,true,"°"),true),
            step_ticks = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Progressive ticks",0,15,7,true,"'"),true),
            step_value = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Progressive value",0,60,5,true,"°"),true),
            step_abs = main:ui(API.MENU.Checkbox(gui.tab[1],gui.tab[2],__state[k].." Increment absolute value"),true),
            step_fake_min = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Fake yaw limit - \a7BDAEAFFmin",0,60,58,true,"°"),true),
            step_fake_max = main:ui(API.MENU.Slider(gui.tab[1],gui.tab[2],__state[k].." Fake yaw limit - \a7BDAEAFFmax",0,60,58,true,"°"),true),
            freestanding_bodyyaw = main:ui(API.MENU.Checkbox(gui.tab[1],gui.tab[2],__state[k].." Freestanding bodyyaw"),true)
        }
    end

    g_antiaim.save_antiaims = {
        pitch = "Off",
        yaw_base = "Local view",
        yaw_1 = "Off",
        yaw_2 = 0,
        yaw_jitter_1 = "Off",
        yaw_jitter_2 = 0,
        body_yaw_1 = "Off",
        body_yaw_2 = 0,
        freestanding_body_yaw = false
    }

    function g_antiaim:og_menu(state)
        API.MENU.Visible(antiaim.pitch, state)
        API.MENU.Visible(antiaim.yaw_base, state)
        API.MENU.Visible(antiaim.yaw[1], state)
        API.MENU.Visible(antiaim.yaw[2], state)
        API.MENU.Visible(antiaim.yaw_jitter[1], state)
        API.MENU.Visible(antiaim.yaw_jitter[2], state)
        API.MENU.Visible(antiaim.body_yaw[1], state)
        API.MENU.Visible(antiaim.body_yaw[2], state)
        API.MENU.Visible(antiaim.freestanding_body_yaw, state)
        API.MENU.Visible(antiaim.edge_yaw, state)
        API.MENU.Visible(antiaim.freestanding[1], state)
        API.MENU.Visible(antiaim.freestanding[2], state)
        API.MENU.Visible(antiaim.roll, state)
    end


    g_antiaim.c_var = {
        c = 1,
        ground_ticks = 0,
        step_ticks = 0,
        min = 0,
        max = 0,
        step = 0,
        return_value = 0,
        bodystep_ticks = 0,
        bodystep_min = 0,
        bodystep_max = 0,
        bodystep_step = 0,
        bodystep_return_value = 0
    }

    g_antiaim.jitter = {}
    g_antiaim.jitter.c_var = {
        choke = 0,
        yaw_v = 0,
        yaw_r = 1,
        byaw_v = 0,
        byaw_r = 1,
        fyaw_v = 0,
        fyaw_r = 0
    }

    function g_antiaim.jitter:tick(a,b)
        return API.GLOBALS.Tickcount() % 4 >= 2 and a or b
    end

    function g_antiaim.jitter:choke_yaw(a,b)
        if API.GLOBALS.Tickcount() - self.c_var.yaw_v > 1  and self.c_var.choke == 1 then
            self.c_var.yaw_r = self.c_var.yaw_r == 1 and 0 or 1
            self.c_var.yaw_v = API.GLOBALS.Tickcount()
        end
    end

    function g_antiaim.jitter:normalize_yaw(p)
        while p > 180 do
            p = p - 360
        end
        while p < -180 do
            p = p + 360
        end
        return p
    end

    function g_antiaim.jitter:choke_body_yaw(a,b)
        local inverted = self:normalize_yaw( libs.antiaim_funcs.get_body_yaw(1) - libs.antiaim_funcs.get_abs_yaw() ) > 0
        local invert = (API.MATH.Floor(API.MATH.Min(60, (API.ENT.Prop(API.ENT.LocalPlayer(), "m_flPoseParameter", 11) * 120 - 60)))) > 0

        if API.MENU.Get(antiaim.body_yaw[1]) == "Jitter" then
            return inverted and a or b
        elseif API.MENU.Get(antiaim.body_yaw[1]) == "Static" then
            return invert and a or b
        end

    end

    function g_antiaim.jitter:choke_fake(a,b)
        if API.GLOBALS.Tickcount() - self.c_var.fyaw_v > 1  and self.c_var.choke == 1 then
            self.c_var.fyaw_r = self.c_var.fyaw_r == 1 and 0 or 1
            self.c_var.fyaw_v = API.GLOBALS.Tickcount()
        end
    end
    local start_time = API.GLOBALS.Curtime()

    local function get_tick()
        local end_time = API.GLOBALS.Curtime()
        local get_time = API.MATH.Abs(API.MATH.Floor((start_time - end_time) * 100)) % 2
        return get_time
    end

    function g_antiaim.jitter:desync(a,b)
        local inverted = self:normalize_yaw( libs.antiaim_funcs.get_body_yaw(1) - libs.antiaim_funcs.get_abs_yaw() ) > 0
        local invert = (API.MATH.Floor(API.MATH.Min(60, (API.ENT.Prop(API.ENT.LocalPlayer(), "m_flPoseParameter", 11) * 120 - 60)))) > 0

        if API.MENU.Get(antiaim.body_yaw[1]) == "Jitter" then
            return inverted and a or b
        elseif API.MENU.Get(antiaim.body_yaw[1]) == "Static" then
            return invert and a or b
        else 
            return a
        end



    end

    function g_antiaim:clamp(num, min, max)
        if num < min then
            num = min
        elseif num > max then
            num = max
        end
        return num
    end


    function g_antiaim:run_custom(cmd)
        if API.ENT.LocalPlayer() == nil then
            return
        end
        local p_duck = API.ENT.Prop(API.ENT.LocalPlayer(), "m_flDuckAmount")
        local inair = API.BIT.Band(API.ENT.Prop(API.ENT.LocalPlayer(), "m_fFlags" ), 1 ) == 0 and cmd.in_jump
        local on_ground = API.BIT.Band(API.ENT.Prop(API.ENT.LocalPlayer(), "m_fFlags"), 1) 
        local vx, vy, vz = API.ENT.Prop(API.ENT.LocalPlayer(), "m_vecVelocity")
        local p_still = API.MATH.Sqrt(vx ^ 2 + vy ^ 2)
        local p_slow = API.MENU.Get(antiaim.slow_motion[1]) and API.MENU.Get(antiaim.slow_motion[2])

        self.jitter.c_var.choke = cmd.chokedcommands
        local m = gui.menu.custom
        self.save_antiaims.yaw_1 = "180"

        if on_ground == 1 then
            self.c_var.ground_ticks = self.c_var.ground_ticks + 1
        else
            self.c_var.ground_ticks = 0
        end
        if API.MENU.Get(m[3].enable) and p_slow then
            self.c_var.c = 3
        elseif inair and cmd.in_jump and API.MENU.Get(m[5].enable) then
            self.c_var.c = 5
        elseif p_duck > 0.8 and not inair and self.c_var.ground_ticks > 8 and API.MENU.Get(m[4].enable)  then
            self.c_var.c = 4
        elseif p_still > 70 and self.c_var.ground_ticks > 8  and API.MENU.Get(m[2].enable) then
            self.c_var.c = 2
        elseif p_still < 2 and  self.c_var.ground_ticks > 8  and API.MENU.Get(m[1].enable) then
            self.c_var.c = 1
        else
            self.c_var.c = 5
        end
        self.save_antiaims.yaw_base = "At targets"
        self.save_antiaims.yaw_1 = "180"
        self.save_antiaims.pitch = "Default"

        if self.c_var.c == 1 and funcs.ui:table_contains(API.MENU.Get(m[1].extra_options),"Suppress jitter when choking commands") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 0
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        elseif self.c_var.c == 2 and funcs.ui:table_contains(API.MENU.Get(m[2].extra_options),"Suppress jitter when choking commands") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 0
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        elseif self.c_var.c == 3 and funcs.ui:table_contains(API.MENU.Get(m[3].extra_options),"Suppress jitter when choking commands") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 24 
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        elseif self.c_var.c == 4 and funcs.ui:table_contains(API.MENU.Get(m[4].extra_options),"Suppress jitter when choking commands") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 35 
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        elseif self.c_var.c == 5 and funcs.ui:table_contains(API.MENU.Get(m[5].extra_options),"Suppress jitter when choking commands") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 15
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        else
            
        
        

            self.c_var.max = API.MENU.Get(m[self.c_var.c].step_fake_max)
            self.c_var.min = API.MENU.Get(m[self.c_var.c].step_fake_min)
            self.c_var.step = API.MENU.Get(m[self.c_var.c].step_value)
            self.c_var.step_ticks = API.GLOBALS.Tickcount() % API.MENU.Get(m[self.c_var.c].step_ticks)

            if API.MENU.Get(m[self.c_var.c].step_fake_min) >= API.MENU.Get(m[self.c_var.c].step_fake_max) then
                API.MENU.Set(m[self.c_var.c].step_fake_min,API.MENU.Get(m[self.c_var.c].step_fake_max))
            end

            if self.c_var.step_ticks == API.MENU.Get(m[self.c_var.c].step_ticks) - 1 then
                if self.c_var.return_value < self.c_var.max then
                    self.c_var.return_value = self.c_var.return_value + API.MENU.Get(m[self.c_var.c].step_value)
                elseif self.c_var.return_value >= self.c_var.max then
                    self.c_var.return_value = self.c_var.min
                end
            end

            self.c_var.bodystep_max = API.MENU.Get(m[self.c_var.c].step_bodyyaw_degree_right)
            self.c_var.bodystep_min = API.MENU.Get(m[self.c_var.c].step_bodyyaw_degree_left)
            self.c_var.bodystep_step = API.MENU.Get(m[self.c_var.c].body_yaw_step_value)
            self.c_var.bodystep_ticks = API.GLOBALS.Tickcount() % API.MENU.Get(m[self.c_var.c].body_yaw_step_ticks)

            if API.MENU.Get(m[self.c_var.c].step_bodyyaw_degree_left) >= API.MENU.Get(m[self.c_var.c].step_bodyyaw_degree_right) then
                API.MENU.Set(m[self.c_var.c].step_bodyyaw_degree_left,API.MENU.Get(m[self.c_var.c].step_bodyyaw_degree_right))
            end
            if self.c_var.bodystep_ticks == API.MENU.Get(m[self.c_var.c].body_yaw_step_ticks) - 1 then
                if self.c_var.bodystep_return_value < self.c_var.bodystep_max then
                    self.c_var.bodystep_return_value = self.c_var.bodystep_return_value + self.c_var.bodystep_step
                elseif self.c_var.bodystep_return_value >= self.c_var.bodystep_max then
                    self.c_var.bodystep_return_value = self.c_var.bodystep_min
                end
            end


            -- {"Static","Period jitter \aC08A8AFF[Tick]","Period jitter \aC08A8AFF[Choke]","Period jitter \aC08A8AFF[Desync]"}
            if API.MENU.Get(m[self.c_var.c].yaw_mode) == "Static" then
                self.save_antiaims.yaw_2 = API.MENU.Get(m[self.c_var.c].static_yaw)
            elseif API.MENU.Get(m[self.c_var.c].yaw_mode) == "Period jitter \aC08A8AFF[Tick]" then
                self.save_antiaims.yaw_2 = self.jitter:tick(API.MENU.Get(m[self.c_var.c].tick_yaw_left),API.MENU.Get(m[self.c_var.c].tick_yaw_right))
            elseif API.MENU.Get(m[self.c_var.c].yaw_mode) == "Period jitter \aC08A8AFF[Choke]" then
                self.save_antiaims.yaw_2 = self.jitter:choke_yaw(API.MENU.Get(m[self.c_var.c].choke_yaw_left),API.MENU.Get(m[self.c_var.c].choke_yaw_right))
            elseif API.MENU.Get(m[self.c_var.c].yaw_mode) == "Period jitter \aC08A8AFF[Desync]" then
                self.save_antiaims.yaw_2 = self.jitter:desync(API.MENU.Get(m[self.c_var.c].desync_yaw_left),API.MENU.Get(m[self.c_var.c].desync_yaw_right))
            end

            self.save_antiaims.yaw_jitter_1 = API.MENU.Get(m[self.c_var.c].yaw_jitter)
            self.save_antiaims.yaw_jitter_2 = API.MENU.Get(m[self.c_var.c].yaw_jitter_degree)
            self.save_antiaims.body_yaw_1 = API.MENU.Get(m[self.c_var.c].self_bodyyaw_mode)

            if API.MENU.Get(m[self.c_var.c].bodyyaw_mode) == "Static" then
                self.save_antiaims.body_yaw_2 = API.MENU.Get(m[self.c_var.c].bodyyaw_degree)
            elseif API.MENU.Get(m[self.c_var.c].bodyyaw_mode) == "Period jitter" then
                self.save_antiaims.body_yaw_2 = self.jitter:choke_body_yaw(API.MENU.Get(m[self.c_var.c].jitter_bodyyaw_degree_left) ,  API.MENU.Get(m[self.c_var.c].jitter_bodyyaw_degree_right)) 
            elseif API.MENU.Get(m[self.c_var.c].bodyyaw_mode) == "Recursion" then
                self.save_antiaims.body_yaw_2 = self:clamp(self.c_var.bodystep_return_value,self.c_var.bodystep_min,self.c_var.bodystep_max)
            end

            -- {"Static","Period tick jitter","Progressively increase"}
            if API.MENU.Get(m[self.c_var.c].fake_yaw_mode) == "Static" then
            elseif API.MENU.Get(m[self.c_var.c].fake_yaw_mode) == "Period tick jitter" then
            elseif API.MENU.Get(m[self.c_var.c].fake_yaw_mode) == "Progressively increase" then
                if API.MENU.Get(m[self.c_var.c].step_abs) then
                else
                end
            end
            self.save_antiaims.freestanding_body_yaw = API.MENU.Get(m[self.c_var.c].freestanding_bodyyaw)
        end

        self:og_menu(false)

    end

    local presets_ticks = 0
    function g_antiaim:run_presets_states(cmd)
        local p_duck = API.ENT.Prop(API.ENT.LocalPlayer(), "m_flDuckAmount")
        local inair = API.BIT.Band( API.ENT.Prop( API.ENT.LocalPlayer( ), "m_fFlags" ), 1 ) == 0 
        local on_ground = API.BIT.Band(API.ENT.Prop( API.ENT.LocalPlayer( ), "m_fFlags"), 1) 
        local vx, vy, vz = API.ENT.Prop(API.ENT.LocalPlayer(), "m_vecVelocity")
        local p_still = API.MATH.Sqrt(vx ^ 2 + vy ^ 2)
        local p_slow = API.MENU.Get(antiaim.slow_motion[1]) and API.MENU.Get(antiaim.slow_motion[2])
        if on_ground == 1 then
            presets_ticks = presets_ticks + 1
        else 
            presets_ticks = 0
        end

        if API.CLIENT.Key(0x45) then
            return 7
        elseif self.direction.c_var.saved_dir ~= 0 then
            return 6
        elseif inair  then
            return 5
        elseif p_slow and presets_ticks > 8 then
            return 4
        elseif p_duck > 0.8 and presets_ticks > 8 then
            return 3
        elseif p_still > 5 and presets_ticks > 8 then
            return 2
        elseif p_still < 2 and presets_ticks > 8 then
            return 1
        else 
            return 5
        end


    end

    local presets_vars = {
        --stand 
        st_min = 0,
        st_max = 0,
        st_step = 0,
        st_stepticks = 0,
        st_return_values =0,
        st_min_desync = 0,
        st_max_desync = 0,
        st_step_desync = 0,
        st_stepticks_desync = 0,
        st_return_values_desync =0,
        --move
        m_min_desync = 0,
        m_max_desync = 0,
        m_step_desync = 0,
        m_stepticks_desync = 0,
        m_return_values_desync =0,    
    }

    libs.ffi.cdef('typedef struct { float x; float y; float z; } bbvec3_t;')

    local visuals = {
        pClientEntityList = API.CLIENT.Interface("client_panorama.dll", "VClientEntityList003") or error("invalid interface", 2),
        fnGetClientEntity = vtable_thunk(3, "void*(__thiscall*)(void*, int)"),

        fnGetAttachment = vtable_thunk(84, "bool(__thiscall*)(void*, int, bbvec3_t&)"),
        fnGetMuzzleAttachmentIndex1stPerson = vtable_thunk(468, "int(__thiscall*)(void*, void*)"),
        fnGetMuzzleAttachmentIndex3stPerson = vtable_thunk(469, "int(__thiscall*)(void*)"),

        get_attachment_vector = function(self, world_model)
            local wpn = API.ENT.PlayerWeapon(lp)

            if lp == nil or wpn == nil then
                return
            end

            local model = world_model and API.ENT.Prop(wpn, 'm_hWeaponWorldModel') or API.ENT.Prop(lp, 'm_hViewModel[0]')

            local active_weapon = self.fnGetClientEntity(self.pClientEntityList, wpn)
            local g_model = self.fnGetClientEntity(self.pClientEntityList, model)

            if active_weapon == nil or g_model == nil then
                return
            end

            local attachment_vector = libs.ffi.new("bbvec3_t[1]")
            local att_index = world_model and
                self.fnGetMuzzleAttachmentIndex3stPerson(active_weapon) or
                self.fnGetMuzzleAttachmentIndex1stPerson(active_weapon, g_model)
            
            if att_index > 0 and self.fnGetAttachment(g_model, att_index, attachment_vector[0]) then
                local pos = { attachment_vector[0].x, attachment_vector[0].y, attachment_vector[0].z }
                return {API.RENDER.World(pos[1], pos[2], pos[3])}
            end
        end,

        color_1 = {API.MENU.Get(gui.menu.watermark_color)},
        color_2 = {API.MENU.Get(gui.menu.watermark_color2)},
        crosshair_data = {},
        crosshair_text_data = {},

        watermark_animation = 0,
        antiaim_animation = 0,

        master_alpha = 0,
        doubletap_animation = 0,
        background_animation = 1,

        attached_to_gun = false,
        cur_position = {0,0},
        cur_end_position = center,

        frames = {},
        fps = 0,

        average_fps = function(self)
            local fps = 1 / API.GLOBALS.Frametime()

            API.TABLE.Insert(self.frames, fps)

            while (#self.frames > 50) do
                API.TABLE.Remove(self.frames, 1)
            end

            local sum = 0

            for i = 1, #self.frames do
                sum = sum + self.frames[i]
            end

            self.fps = API.MATH.Floor(sum / #self.frames + 0.5)
        end,

        update_crosshair = function(self, id, name, state, percent, col)
            local index = nil

            for i = 1, #self.crosshair_data do
                if self.crosshair_data[i].id == id then
                    index = i
                end
            end

            if index == nil then
                self.crosshair_data[#self.crosshair_data + 1] = {
                    id = id,
                    state = state,
                    name = name,
                    percent = percent,
                    col = col,
                    anim = 0,
                    anim2 = 0
                }
            else
                self.crosshair_data[index] = {
                    id = id,
                    state = state,
                    name = name,
                    percent = percent,
                    col = col,
                    anim = math_fn.clamp(0, 1, self.crosshair_data[index].anim + (state and (1 / 0.3) or -(1 / 0.3)) * API.GLOBALS.Frametime()),
                    anim2 = math_fn.clamp(0, 1, self.crosshair_data[index].anim2 + ((self.crosshair_data[index].anim == 0 and -(1 / 0.3) or (1 / 0.2)) * API.GLOBALS.Frametime()))
                }
            end
        end,

        update_text = function(self, id, text, state)
            local index = nil

            for i = 1, #self.crosshair_text_data do
                if self.crosshair_text_data[i].id == id then
                    index = i
                end
            end

            if index == nil then
                self.crosshair_text_data[#self.crosshair_text_data + 1] = {
                    id = id,
                    text = text,
                    state = state,
                    pad_anim = 0,
                    text_alpha = 0,
                }
            else
                local old = self.crosshair_text_data[index]

                self.crosshair_text_data[index] = {
                    id = id,
                    text = text,
                    state = state,
                    pad_anim = old.text_alpha == 0 and math_fn.clamp(0, 1, old.pad_anim + (state and (1 / 0.2) or -(1 / 0.2)) * API.GLOBALS.Frametime()) or old.pad_anim,
                    text_alpha = old.pad_anim == 1 and math_fn.clamp(0, 1, old.text_alpha + (state and (1 / 0.2) or -(1 / 0.2)) * API.GLOBALS.Frametime()) or old.text_alpha,
                }
            end
        end,

        update_attachment_position = function(self)
            local pos = self:get_attachment_vector()
            local thirdperson = API.MENU.Get(antiaim.thirdperson[1]) and API.MENU.Get(antiaim.thirdperson[2])

            if (pos == nil or pos[1] == nil) or thirdperson or API.ENT.Prop(lp, "m_bIsScoped") == 1 then
                self.attached_to_gun = false
            else
                self.attached_to_gun = true
            end

            if pos ~= nil and pos[1] ~= nil then
                self.cur_position = pos
            end

            local wish_end = {0, 0}

            if self.attached_to_gun == false then
                wish_end = {center[1] + 5, center[2] + 5}
            else
                local yaw = API.MATH.Rad(-135)
                local end_offset = {API.MATH.Floor(API.MATH.Sin(yaw) * 225), API.MATH.Floor(API.MATH.Cos(yaw) * 225)}

                --Avoid overlapping with crosshair
                local new_wish_end = {pos[1] + end_offset[1], pos[2] + end_offset[2]}
                local distance_to_center = math_fn.distance2d(center, new_wish_end)
                local max_distance = 150
                local percent = distance_to_center / max_distance
                local lerped_distance = math_fn.lerp(pos, new_wish_end, math_fn.clamp(0.6, 1, percent))

                wish_end = lerped_distance --{pos[1] + end_offset[1], pos[2] + end_offset[2]}
            end
            
            for i = 1, 2 do
                local inc = ((wish_end[i] - self.cur_end_position[i]) / 0.3) * API.GLOBALS.Frametimes()
                self.cur_end_position[i] = self.cur_end_position[i] + inc
            end
        end,

        update_animations = function(self, state)
            local inc = (1 / 0.4) * API.GLOBALS.Frametime()
            local alpha = (1 / 0.2) * API.GLOBALS.Frametime()

            if self.attached_to_gun == false then
                inc = inc * -1
            end

            if state == false then
                alpha = alpha * -1
            end

            if libs.antiaim_funcs.get_tickbase_shifting() > 0 then
                self.doubletap_animation = math_fn.clamp(0.1, 1, self.doubletap_animation + ((1 / 0.2) * API.GLOBALS.Frametime()))
            else
                self.doubletap_animation = math_fn.clamp(0.1, 1, self.doubletap_animation - ((1 / 0.1) * API.GLOBALS.Frametime()))
            end

            self.master_alpha = math_fn.clamp(0, 1, self.master_alpha + alpha)
            self.background_animation = math_fn.clamp(0, self.master_alpha, math_fn.clamp(0, 1, self.background_animation + inc))
        end,

        indicator_contents = function(self, render)
            local offset = 2
            local longest_text = 0
            local size = {90 + (10 * self.background_animation), 25}
            local average_color = math_fn.lerp(self.color_1, self.color_2, 0.5)

            for i = 1, #self.crosshair_data do
                local crosshair = self.crosshair_data[i]
                if crosshair.anim2 > 0 then
                    local text_size = {API.RENDER.Measure("-", crosshair.name)}

                    if text_size[1] > longest_text then
                        longest_text = text_size[1]
                    end

                    size[2] = size[2] + (10 * crosshair.anim2)
                end
            end

            for i = 1, #self.crosshair_text_data do
                local text = self.crosshair_text_data[i]

                if text.pad_anim > 0 then
                    size[2] = size[2] + (10 * text.pad_anim)
                end
            end
            size[2] = size[2] + 10

            --title text
            local text_size = {API.RENDER.Measure("", "PlugWalk")}
            local title_offset = API.MATH.Floor(math_fn.lerp({5}, {size[1]/2 - text_size[1]/2}, self.background_animation)[1])
            local modifier = API.ENT.Prop(API.ENT.LocalPlayer(), "m_flVelocityModifier")
            API.RENDER.Text(self.cur_end_position[1] + title_offset, self.cur_end_position[2] + offset, 220, 220, 220, 255 * (1 - self.background_animation) * self.master_alpha, "b", 0, "PlugWalk")
            API.RENDER.Text(self.cur_end_position[1] + title_offset, self.cur_end_position[2] + offset, 220, 220, 220, 255 * self.background_animation, "", 0, "PlugWalk")
            offset = offset + text_size[2] + 2

            --sliders
            self:update_crosshair("DT", "DT", (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])), self.doubletap_animation, {255, 0, 0, 255})
            self:update_crosshair("AA", "AA", true, math_fn.clamp(0.1, 1, API.MATH.Abs((API.ENT.Prop(lp, "m_flPoseParameter", 11) or 0.5) * 120 - 60) / 55), {255, 0, 0, 255})

            --draw sliders
            local padding = 4 * self.background_animation

            for i = 1, #self.crosshair_data do
                local crosshair = self.crosshair_data[i]
                local bar_size = size[1] - (4*2) - longest_text * 2 - 8

                if crosshair.anim2 > 0 then
                    local alpha = self.master_alpha * crosshair.anim * 255
                    local col = average_color
                    col[4] = alpha

                    API.RENDER.Text(self.cur_end_position[1] + 4 + padding, self.cur_end_position[2] + offset, 220, 220, 220, alpha, "-", 0, crosshair.name)
                    render_fn.rounded_gradient(self.cur_end_position[1] + (4*2) + padding + 2 + longest_text, self.cur_end_position[2] + offset + text_size[2]/4, bar_size * crosshair.anim, 4, {25, 25, 25, alpha}, {25, 25, 25, alpha}, 2)
                    render_fn.rounded_gradient(self.cur_end_position[1] + (4*2) + padding + 2 + longest_text, self.cur_end_position[2] + offset + text_size[2]/4, API.MATH.Floor(bar_size * crosshair.anim * crosshair.percent + 0.5), 4, col, col, 2)
                    offset = offset + (10 * crosshair.anim2)
                end
            end

            offset = offset + 1

            --draw list indicators
            local indicators = {}

            local function create(name, col)
                indicators[#indicators + 1] = {
                    name = name,
                    color = col,
                    size = {API.RENDER.Measure("-", name)}
                }
            end


            local white = {235, 235, 235, 255}
            local disabled_color = {180, 180, 180, 255}
            create("OS", (API.MENU.Get(antiaim.hide_shots[1]) and API.MENU.Get(antiaim.hide_shots[2])) and white or disabled_color)
            create("FD", API.MENU.Get(antiaim.fakeduck) and white or disabled_color)
            create("FS", API.MENU.Get(gui.menu.freestanding_key) and white or disabled_color)
            create("FB", API.MENU.Get(antiaim.force_body_aim) and white or disabled_color)

            local x_offset = 4 + padding
            local ind_offset = (size[1] / #indicators) - 4 - (1 * (1 - self.background_animation))

            for i = 1, #indicators do
                local indicator = indicators[i]
                
                API.RENDER.Text(self.cur_end_position[1] + x_offset,  self.cur_end_position[2] + offset, indicator.color[1], indicator.color[2], indicator.color[3], self.master_alpha * 255, "-", 0, indicator.name)
                x_offset = API.MATH.Floor(x_offset + ind_offset + indicator.size[1] / #indicators)
            end
            offset = offset + 11

            self:update_text("dt", 
                {
                    {"EXPLOITING:  ", "-", disabled_color},
                    {self.doubletap_animation == 1 and "CHARGED" or "CHARGING", "-", self.doubletap_animation == 1 and average_color or {255, 150, 150, 255}},
            }, API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2]))

            for i = 1, #self.crosshair_text_data do
                local text = self.crosshair_text_data[i]

                if text.pad_anim > 0 then
                    local x = self.cur_end_position[1] + 4 + padding

                    for j = 1, #text.text do
                        local c = text.text[j]
                        local text_size = {API.RENDER.Measure(c[2], c[1])}
                        API.RENDER.Text(x, self.cur_end_position[2] + offset, c[3][1], c[3][2], c[3][3], text.text_alpha * self.master_alpha * 255, c[2], 0, c[1])
                        x = x + text_size[1]
                    end
                    offset = offset + (10 * text.pad_anim)
                end
            end

            if render == false then
                return size
            end
        end,

        indicator_frame = function(self)
            local size = self:indicator_contents(false)
            render_fn.line(self.cur_position, {self.cur_end_position[1] + size[1], self.cur_end_position[2] + size[2]}, 6, {self.color_1[1], self.color_1[2], self.color_1[3], 255 * (self.background_animation / 2)}, {self.color_2[1], self.color_2[2], self.color_2[3], 255 * self.background_animation}, 40)
            render_fn.rounded_gradient_rectangle(self.cur_end_position[1], self.cur_end_position[2], size[1], size[2], 4, self.color_1, self.color_2, self.color_1, self.color_2, {25, 25, 25, 165 * self.master_alpha}, self.master_alpha * 255, 1, 1, self.background_animation)
        end,

        crosshair = function(self)
            self:update_attachment_position()
            if API.MENU.Get(gui.menu.center_mode) == "Modern" then
                self:update_animations(lp ~= nil and API.ENT.IsAlive(lp))
            else
                return
            end
            --self:update_animations(lp ~= nil and API.ENT.IsAlive(lp) and ui_fn.includes(API.MENU.Get(gui.menu.center_mode), "Modern"))

            if self.master_alpha <= 0 then
                return
            end

            if self.background_animation > 0 then
                self:indicator_frame()
            end

            self:indicator_contents(true)
        end,

        watermark = function(self)
            local inc = (1 / 0.5) * API.GLOBALS.Frametime()

            if (ui_fn.includes(API.MENU.Get(gui.menu.indicator_settings),"\a646464FF Watermark")) == false then
                inc = inc * -1
            end
            self.watermark_animation = math_fn.clamp(0, 1, self.watermark_animation + inc)

            if self.watermark_animation <= 0 then
                return
            end

            local white = {220, 220, 220, 255}
            local disabled_color = {150, 150, 150, 255}
            local average_color = math_fn.lerp(self.color_1, self.color_2, 0.5)

            local size = {0, 0}

            local resource = API.ENT.Resource()

            local ping = 0

            if resource ~= nil then
                ping = API.ENT.Prop(resource, "m_iPing", lp)
            end
            ping = API.MATH.Floor(ping)

            local text = {
                {"PlugWalk", "b", average_color},
                {" [", "", white},
                {status.build, "b", average_color},
                {"] ", "", white},
                {status.username, "b", average_color},    
                {"  ", "", white},
                {"fps: ", "", white},
                {API.STRING.Format(self.fps), "b", average_color},
                {"  ping: ", "", white},
                {ping, "b", average_color},
            }

            for i = 1, #text do
                local c = text[i]
                local text_size = {API.RENDER.Measure(c[2], c[1])}

                size[1] = size[1] + text_size[1]

                if size[2] < text_size[2] then
                    size[2] = text_size[2]
                end
            end

            local x = screen[1] - size[1] - 8

            render_fn.rounded_gradient_rectangle(x - 4, 4, size[1] + 8, size[2] + 6, 2, self.color_1, self.color_2, self.color_1, self.color_2, {25, 25, 25, 165 * self.watermark_animation}, self.watermark_animation * 255, 1, 1, self.watermark_animation)

            for i = 1, #text do
                local c = text[i]
                local text_size = {API.RENDER.Measure(c[2], c[1])}

                API.RENDER.Text(x, 6, c[3][1], c[3][2], c[3][3], self.watermark_animation * 255, c[2], 0, c[1])
                x = x + text_size[1]
            end
        end,

        model_right_click = function()
            if lp == nil or API.ENT.IsAlive(lp) == false then
                return
            end

            local min = {screen[1], screen[2]}
            local max = {0, 0}

            local valid = false

            for i = 1, 18 do
                local hb = {API.ENT.Hitbox(lp, i)}

                if hb[1] then
                    local w2s = {API.RENDER.World(hb[1], hb[2], hb[3])}

                    if w2s[1] and w2s[2] then
                        for xy = 1, 2 do
                            if w2s[xy] < min[xy] then
                                valid = true
                                min[xy] = w2s[xy]
                            end

                            if w2s[xy] > max[xy] then
                                valid = true
                                max[xy] = w2s[xy]
                            end
                        end
                    end
                end
            end

            if valid == false then
                return
            end

            gui2:update_size(2, min, {max[1] - min[1], max[2] - min[2]})
        end,

        run = function(self)
            self.color_1 = {API.MENU.Get(gui.menu.watermark_color)}
            self.color_2 = {API.MENU.Get(gui.menu.watermark_color2)}

            self:average_fps()

            self:crosshair()
            self:watermark()
            self.model_right_click()
        end,
    }

    local logs = {
        multicolor_console = function(texts)
            for i=1, #texts do
                local text = texts[i]
                API.CLIENT.Log(text[1][1], text[1][2], text[1][3], i ~= #texts and (text[2] .. '\0') or text[2])
            end
        end,

        logs_data = {},

        create_center_log = function(self, time, data)
            self.logs_data[#self.logs_data + 1] = {
                text = data,
                cur_offset = 0,
                alpha = 0,
                time = API.GLOBALS.Realtime() + time
            }
        end,

        corner_data = {},

        create_corner_log = function(self, time, data)
            API.TABLE.Insert(self.corner_data, {
                text = data,
                alpha = 0,
                time = API.GLOBALS.Realtime() + time
            })
        end,

        center_run = function(self)
            local alpha_inc = (255/0.25) * API.GLOBALS.Frametimes()
            local offset = 0
            local flags = ""
            local uppercase = false
            local log_font_g = gui2:get_combo(1, "Font style:")

            if log_font_g == "Normal" then
                flags = ""
            elseif log_font_g == "Bold" then
                flags = "b"
            else
                flags = "-"
                uppercase = true
            end

            local min_x = screen[1]
            local max_x = 0

            for i=#self.logs_data, 1, -1 do
                if self.logs_data[i] ~= nil then
                    local data = self.logs_data[i]
                    local table_text = data.text

                    data.alpha = math_fn.clamp(0, 255, data.time < API.GLOBALS.Realtime() and data.alpha - alpha_inc or data.alpha + alpha_inc)

                    if data.cur_offset ~= offset then
                        data.cur_offset = math_fn.clamp(0, offset, data.cur_offset < offset and data.cur_offset + (200 * API.GLOBALS.Frametimes()) or offset)
                    end
                    local raw_text = ''

                    for i2=1, #data.text do
                        raw_text = raw_text .. data.text[i2][2]
                    end

                    if uppercase then
                        raw_text = API.STRING.Upper(raw_text)
                    end
                    
                    local total_size = {API.RENDER.Measure(flags, raw_text)}

                    local percent = 1-(data.alpha/255)
                    local x_offset = data.time > API.GLOBALS.Realtime() and -percent*40 or percent*40

                    local text_height = 0
                    local text_offset = 0

                    for i2=1, #data.text do
                        local cur_table_text = data.text[i2]

                        local text = cur_table_text[2]
                        if uppercase then
                            text = API.STRING.Upper(cur_table_text[2])
                        end

                        local text_size = {API.RENDER.Measure(flags, text)}

                        if text_height < text_size[2] then
                            text_height = text_size[2]
                        end

                        API.RENDER.Text((center[1] - total_size[1]/2) + text_offset + x_offset, screen[2] - 300 + data.cur_offset, cur_table_text[1][1], cur_table_text[1][2], cur_table_text[1][3], data.alpha, flags, 0, text)
                        text_offset = text_offset + text_size[1] + (uppercase and 1 or 0)
                    end

                    if (center[1] - total_size[1]/2) < min_x then
                        min_x = center[1] - total_size[1]/2
                    end

                    if max_x < text_offset then
                        max_x = text_offset
                    end

                    offset = offset + text_height + 2
                end
            end
            gui2:update_size(1, {center[1] - 300, screen[2] - 300}, {600, 200})


            for i=1, #self.logs_data do
                local dif_from_newest = #self.logs_data - i 

                if dif_from_newest > 5 then
                    self.logs_data[i].time = 0
                end
            end

            --Remove old logs
            for i=#self.logs_data, 1, -1 do
                local data = self.logs_data[i]
                if data.alpha == 0 and data.time < API.GLOBALS.Realtime() then
                    API.TABLE.Remove(self.logs_data, i)
                end
            end 
        end,

        corner_run = function(self)
            local alpha_inc = (255/0.3) * API.GLOBALS.Frametimes()
            local dec = (20 / 0.3) * API.GLOBALS.Frametimes()
            local offset = -10

            for i = #self.corner_data, 1, -1 do
                local delta = #self.corner_data - i

                if delta > 7 then
                    API.TABLE.Remove(self.corner_data, i)
                end
            end

            for i = 1, #self.corner_data do
                local log = self.corner_data[i]

                if log then
                    if log.time < API.GLOBALS.Realtime() then
                        log.alpha = API.MATH.Max(0, log.alpha - alpha_inc)

                        if log.alpha == 0 then
                            API.TABLE.Remove(self.corner_data, i)
                        end
                    else
                        log.alpha = API.MATH.Min(255, log.alpha + alpha_inc)
                    end

                    local x_offset = 5

                    for j = 1, #log.text do
                        local text = log.text[j]
                        local size = {API.RENDER.Measure("", text[2])}
                        API.RENDER.Text(x_offset, offset + 10, text[1][1], text[1][2], text[1][3], log.alpha, "", 0, text[2])
                        x_offset = x_offset + size[1]
                    end

                    offset = offset + 13
                end
            end
        end,

        white = {255, 255, 255, 255},
        hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"},

        fire_logs = {},

        aim_fire = function(self, e)
            self.fire_logs[#self.fire_logs + 1] = {
                id = e.id,
                pred_hc = e.hit_chance,
                pred_hb = e.hitgroup,
                pred_dmg = e.damage
            }
        end,

        aim_hit = function(self, e)
            for i = 1, #self.fire_logs do
                local log = self.fire_logs[i]

                if log.id == e.id then
                    local name = API.ENT.PlayerName(e.target)
                    local hitbox = self.hitgroup_names[e.hitgroup + 1]
                    local health = API.ENT.Prop(e.target, "m_iHealth") or 0

                    local output = API.MENU.Get(gui.menu.draw)
                    local hit_color = {0, 255, 0,255}
                    
                    if ui_fn.includes(output, "Center") then
                        self:create_center_log(5, {
                            {self.white, "Hit "},
                            {hit_color, name},
                            {self.white, " in the "},
                            {hit_color, hitbox},
                            {self.white, " for "},
                            {hit_color, e.damage},
                            {self.white, " damage ("},
                            {hit_color, health},
                            {self.white, " health remaining)"}
                        })
                    end

                    local text = {
                        {self.white, "["},
                        {hit_color, "PlugWalk"},
                        {self.white, "] "},
                        {self.white, "Hit "},
                        {hit_color, name},
                        {self.white, " in the "},
                        {hit_color, hitbox},
                        {self.white, " for "},
                        {hit_color, e.damage},
                        {self.white, " damage ("},
                        {hit_color, health},
                        {self.white, " health remaining, real hitchance: "},
                        {hit_color, API.MATH.Floor(e.hit_chance)},
                        {self.white, ", client hitchance: "},
                        {hit_color, API.MATH.Floor(log.pred_hc)},
                        {self.white, ", client hitbox: "},
                        {hit_color, self.hitgroup_names[log.pred_hb + 1]},
                        {self.white, ", client damage: "},
                        {hit_color, log.pred_dmg},
                        {self.white, ")"}
                    }

                    if ui_fn.includes(output, "Corner") then
                        self:create_corner_log(5, text)
                    end

                    if ui_fn.includes(output, "Console") then
                        self.multicolor_console(text)
                    end 

                    API.TABLE.Remove(self.fire_logs, i)   
                    break
                end
            end
        end,

        aim_miss = function(self, e)
            for i = 1, #self.fire_logs do
                local log = self.fire_logs[i]

                if log.id == e.id then
                    local name = API.ENT.PlayerName(e.target)
                    local hitbox = self.hitgroup_names[e.hitgroup + 1]
                    local reason = e.reason == "?" and "resolver" or e.reason

                    local output = API.MENU.Get(gui.menu.draw)
                    local miss_color = {255,0,0,255}
                    
                    if ui_fn.includes(output, "Center") then
                        self:create_center_log(5, {
                            {self.white, "Missed "},
                            {miss_color, name},
                            {self.white, "'s "},
                            {miss_color, hitbox},
                            {self.white, " due to "},
                            {miss_color, reason},
                            {self.white, " ("},
                            {miss_color, API.MATH.Floor(e.hit_chance)},
                            {self.white, "% hitchance)"}
                        })
                    end

                    local text = {
                        {self.white, "["},
                        {miss_color, "PlugWalk"},
                        {self.white, "] "},
                        {self.white, "Missed "},
                        {miss_color, name},
                        {self.white, "'s "},
                        {miss_color, hitbox},
                        {self.white, " due to "},
                        {miss_color, reason},
                        {self.white, " (real hitchance: "},
                        {miss_color, API.MATH.Floor(e.hit_chance)},
                        {self.white, ", client hitchance: "},
                        {miss_color, API.MATH.Floor(log.pred_hc)},
                        {self.white, ", client hitbox: "},
                        {miss_color, self.hitgroup_names[log.pred_hb + 1]},
                        {self.white, ", client damage: "},
                        {miss_color, log.pred_dmg},
                        {self.white, ")"}
                    }

                    if ui_fn.includes(output, "Corner") then
                        self:create_corner_log(5, text)
                    end

                    if ui_fn.includes(output, "Console") then
                        self.multicolor_console(text)
                    end 

                    API.TABLE.Remove(self.fire_logs, i)   
                    break
                end
            end
        end,
    }

    local callbacks = {


        paint_ui = function()
            lp = API.ENT.LocalPlayer()

            screen = {API.CLIENT.Screen()}
            center = {screen[1]/2, screen[2]/2}
            visuals:run()
            logs:center_run()
            logs:corner_run()
            gui2:run()
        end,

        weapon_fire = function(e)
            local player = API.CLIENT.UIDtoENT(e.userid)

            if player ~= nil and lp ~= nil and player == lp then
            end
        end,

        aim_fire = function(e)
            logs:aim_fire(e)
        end,

        aim_hit = function(e)
            logs:aim_hit(e)
        end,

        aim_miss = function(e)
            logs:aim_miss(e)
        end,
    }

    API.CLIENT.Callback("paint_ui", callbacks.paint_ui)
    API.CLIENT.Callback("weapon_fire", callbacks.weapon_fire)
    API.CLIENT.Callback("aim_fire", callbacks.aim_fire)
    API.CLIENT.Callback("aim_hit", callbacks.aim_hit)
    API.CLIENT.Callback("aim_miss", callbacks.aim_miss)

    function g_antiaim:run_presets_1(cmd)
        local states = self:run_presets_states(cmd)

        self.save_antiaims.yaw_base = "At targets"
        self.save_antiaims.yaw_1 = "180"
        self.save_antiaims.pitch = "Default"
        if states == 1 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Stand") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 0
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 1 then
            self.save_antiaims.yaw_2 = self.jitter:desync(18,28)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 67
            self.save_antiaims.body_yaw_1 = "Static"
            presets_vars.st_max = 180
            presets_vars.st_min = 90
            presets_vars.st_step = 1
            presets_vars.st_stepticks = API.GLOBALS.Tickcount() % 1
            if presets_vars.st_stepticks == 1 - 1 then
                if presets_vars.st_return_values < presets_vars.st_max then
                    presets_vars.st_return_values = presets_vars.st_return_values + 1
                elseif presets_vars.st_return_values >= presets_vars.st_max  then
                    presets_vars.st_return_values = presets_vars.st_min
                end
            end
            self.save_antiaims.body_yaw_2 = self:clamp(presets_vars.st_return_values,presets_vars.st_min,presets_vars.st_max)
            presets_vars.st_max_desync = 60
            presets_vars.st_min_desync = 20
            presets_vars.st_step_desync = 5
            presets_vars.st_stepticks_desync = API.GLOBALS.Tickcount() % 3
            if presets_vars.st_stepticks_desync == 1 - 1 then
                if presets_vars.st_return_values_desync < presets_vars.st_max_desync then
                    presets_vars.st_return_values_desync = presets_vars.st_return_values_desync + 1
                elseif presets_vars.st_return_values_desync >= presets_vars.st_max_desync  then
                    presets_vars.st_return_values_desync = presets_vars.st_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end

        if states == 2 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Move") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 0
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 2 then
            self.save_antiaims.yaw_2 = self.jitter:desync(10,-5)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 70
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 0
            presets_vars.m_max_desync = 60
            presets_vars.m_min_desync = 30
            presets_vars.m_step_desync = 5
            presets_vars.m_stepticks_desync = API.GLOBALS.Tickcount() % 2
            if presets_vars.m_stepticks_desync == 1 - 1 then
                if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                    presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
                elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                    presets_vars.m_return_values_desync = presets_vars.m_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end



        if states == 3 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Duck") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 24 
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 3 then 
            self.save_antiaims.yaw_2 = self.jitter:desync(35,-10)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 25
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 0
            presets_vars.m_max_desync = 60
            presets_vars.m_min_desync = 30
            presets_vars.m_step_desync = 5
            presets_vars.m_stepticks_desync = API.GLOBALS.Tickcount() % 2
            if presets_vars.m_stepticks_desync == 1 - 1 then
                if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                    presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
                elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                    presets_vars.m_return_values_desync = presets_vars.m_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end


        if states == 4 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Slow walk") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 35 
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 4 then 
            self.save_antiaims.yaw_2 = self.jitter:desync(30,10)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 41
            self.save_antiaims.body_yaw_1 = "Static"
            presets_vars.st_max = 180
            presets_vars.st_min = 90
            presets_vars.st_step = 1
            presets_vars.st_stepticks = API.GLOBALS.Tickcount() % 1
            if presets_vars.st_stepticks == 1 - 1 then
                if presets_vars.st_return_values < presets_vars.st_max then
                    presets_vars.st_return_values = presets_vars.st_return_values + 1
                elseif presets_vars.st_return_values >= presets_vars.st_max  then
                    presets_vars.st_return_values = presets_vars.st_min
                end
            end
            self.save_antiaims.body_yaw_2 = self:clamp(presets_vars.st_return_values,presets_vars.st_min,presets_vars.st_max)
            presets_vars.m_max_desync = 60
            presets_vars.m_min_desync = 30
            presets_vars.m_step_desync = 1
            presets_vars.m_stepticks_desync = API.GLOBALS.Tickcount() % 1
            if presets_vars.m_stepticks_desync == 1 - 1 then
                if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                    presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
                elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                    presets_vars.m_return_values_desync = presets_vars.m_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end


        if states == 5 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Air") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 15
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 5 then
            self.save_antiaims.yaw_2 = self.jitter:desync(20,6)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 66
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 0
            presets_vars.m_max_desync = 60
            presets_vars.m_min_desync = 30
            presets_vars.m_step_desync = 1
            presets_vars.m_stepticks_desync = API.GLOBALS.Tickcount() % 1
            if presets_vars.m_stepticks_desync == 1 - 1 then
                if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                    presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
                elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                    presets_vars.m_return_values_desync = presets_vars.m_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end
    end
    function g_antiaim:run_presets_2(cmd)
        local states = self:run_presets_states(cmd)

        self.save_antiaims.yaw_base = "At targets"
        self.save_antiaims.yaw_1 = "180"
        self.save_antiaims.pitch = "Minimal"
        if states == 1 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Stand") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 0
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 36
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 0
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 1 then
            self.save_antiaims.yaw_2 = self.jitter:desync(18,28)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 38
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 0
            presets_vars.st_max = 180
            presets_vars.st_min = 90
            presets_vars.st_step = 1
            presets_vars.st_stepticks = API.GLOBALS.Tickcount() % 1
            if presets_vars.st_stepticks == 1 - 1 then
                if presets_vars.st_return_values < presets_vars.st_max then
                    presets_vars.st_return_values = presets_vars.st_return_values + 1
                elseif presets_vars.st_return_values >= presets_vars.st_max  then
                    presets_vars.st_return_values = presets_vars.st_min
                end
            end
            self.save_antiaims.body_yaw_2 = self:clamp(presets_vars.st_return_values,presets_vars.st_min,presets_vars.st_max)
            presets_vars.st_max_desync = 60
            presets_vars.st_min_desync = 20
            presets_vars.st_step_desync = 5
            presets_vars.st_stepticks_desync = API.GLOBALS.Tickcount() % 3
            if presets_vars.st_stepticks_desync == 1 - 1 then
                if presets_vars.st_return_values_desync < presets_vars.st_max_desync then
                    presets_vars.st_return_values_desync = presets_vars.st_return_values_desync + 1
                elseif presets_vars.st_return_values_desync >= presets_vars.st_max_desync  then
                    presets_vars.st_return_values_desync = presets_vars.st_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end

        if states == 2 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Move") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 0
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 50
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 0
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 2 then
            self.save_antiaims.yaw_2 = self.jitter:desync(10,-5)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 63
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 0
            presets_vars.m_max_desync = 60
            presets_vars.m_min_desync = 30
            presets_vars.m_step_desync = 5
            presets_vars.m_stepticks_desync = API.GLOBALS.Tickcount() % 2
            if presets_vars.m_stepticks_desync == 1 - 1 then
                if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                    presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
                elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                    presets_vars.m_return_values_desync = presets_vars.m_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end



        if states == 3 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Duck") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 24 
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 48
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 0
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 3 then 
            self.save_antiaims.yaw_2 = self.jitter:desync(35,-10)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 53
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 0
            presets_vars.m_max_desync = 60
            presets_vars.m_min_desync = 30
            presets_vars.m_step_desync = 5
            presets_vars.m_stepticks_desync = API.GLOBALS.Tickcount() % 2
            if presets_vars.m_stepticks_desync == 1 - 1 then
                if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                    presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
                elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                    presets_vars.m_return_values_desync = presets_vars.m_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end


        if states == 4 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Slow walk") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 35 
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 48
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 0
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 4 then 
            self.save_antiaims.yaw_2 = self.jitter:desync(30,10)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 41
            self.save_antiaims.body_yaw_1 = "Jitter"
            presets_vars.st_max = 180
            presets_vars.st_min = 90
            presets_vars.st_step = 1
            presets_vars.st_stepticks = API.GLOBALS.Tickcount() % 1
            if presets_vars.st_stepticks == 1 - 1 then
                if presets_vars.st_return_values < presets_vars.st_max then
                    presets_vars.st_return_values = presets_vars.st_return_values + 1
                elseif presets_vars.st_return_values >= presets_vars.st_max  then
                    presets_vars.st_return_values = presets_vars.st_min
                end
            end
            self.save_antiaims.body_yaw_2 = self:clamp(presets_vars.st_return_values,presets_vars.st_min,presets_vars.st_max)
            presets_vars.m_max_desync = 60
            presets_vars.m_min_desync = 30
            presets_vars.m_step_desync = 1
            presets_vars.m_stepticks_desync = API.GLOBALS.Tickcount() % 1
            if presets_vars.m_stepticks_desync == 1 - 1 then
                if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                    presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
                elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                    presets_vars.m_return_values_desync = presets_vars.m_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end


        if states == 5 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Air") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 15
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 5 then
            self.save_antiaims.yaw_2 = self.jitter:desync(20,6)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 66
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 0
            presets_vars.m_max_desync = 60
            presets_vars.m_min_desync = 30
            presets_vars.m_step_desync = 1
            presets_vars.m_stepticks_desync = API.GLOBALS.Tickcount() % 1
            if presets_vars.m_stepticks_desync == 1 - 1 then
                if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                    presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
                elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                    presets_vars.m_return_values_desync = presets_vars.m_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end
    end
    function g_antiaim:run_presets_3(cmd)
        local states = self:run_presets_states(cmd)

        self.save_antiaims.yaw_base = "At targets"
        self.save_antiaims.yaw_1 = "180"
        self.save_antiaims.pitch = "Default"
        if states == 1 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Stand") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 0
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 57
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = -140
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 1 then
            self.save_antiaims.yaw_2 = self.jitter:desync(18,28)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 67
            self.save_antiaims.body_yaw_1 = "Jitter"
            presets_vars.st_max = 180
            presets_vars.st_min = 90
            presets_vars.st_step = 1
            presets_vars.st_stepticks = API.GLOBALS.Tickcount() % 1
            if presets_vars.st_stepticks == 1 - 1 then
                if presets_vars.st_return_values < presets_vars.st_max then
                    presets_vars.st_return_values = presets_vars.st_return_values + 1
                elseif presets_vars.st_return_values >= presets_vars.st_max  then
                    presets_vars.st_return_values = presets_vars.st_min
                end
            end
            self.save_antiaims.body_yaw_2 = self:clamp(presets_vars.st_return_values,presets_vars.st_min,presets_vars.st_max)
            presets_vars.st_max_desync = 60
            presets_vars.st_min_desync = 20
            presets_vars.st_step_desync = 5
            presets_vars.st_stepticks_desync = API.GLOBALS.Tickcount() % 3
            if presets_vars.st_stepticks_desync == 1 - 1 then
                if presets_vars.st_return_values_desync < presets_vars.st_max_desync then
                    presets_vars.st_return_values_desync = presets_vars.st_return_values_desync + 1
                elseif presets_vars.st_return_values_desync >= presets_vars.st_max_desync  then
                    presets_vars.st_return_values_desync = presets_vars.st_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end

        if states == 2 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Move") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 0
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 67
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 2 then
            self.save_antiaims.yaw_2 = self.jitter:desync(10,-5)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 48
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 180
            presets_vars.m_max_desync = 60
            presets_vars.m_min_desync = 30
            presets_vars.m_step_desync = 5
            presets_vars.m_stepticks_desync = API.GLOBALS.Tickcount() % 2
            if presets_vars.m_stepticks_desync == 1 - 1 then
                if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                    presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
                elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                    presets_vars.m_return_values_desync = presets_vars.m_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end



        if states == 3 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Duck") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 24 
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 46
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 3 then 
            self.save_antiaims.yaw_2 = self.jitter:desync(35,-10)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 25
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 0
            presets_vars.m_max_desync = 60
            presets_vars.m_min_desync = 30
            presets_vars.m_step_desync = 5
            presets_vars.m_stepticks_desync = API.GLOBALS.Tickcount() % 2
            if presets_vars.m_stepticks_desync == 1 - 1 then
                if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                    presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
                elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                    presets_vars.m_return_values_desync = presets_vars.m_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end


        if states == 4 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Slow walk") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 35 
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 65
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 4 then 
            self.save_antiaims.yaw_2 = self.jitter:desync(30,10)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 41
            self.save_antiaims.body_yaw_1 = "Jitter"
            presets_vars.st_max = 180
            presets_vars.st_min = 90
            presets_vars.st_step = 1
            presets_vars.st_stepticks = API.GLOBALS.Tickcount() % 1
            if presets_vars.st_stepticks == 1 - 1 then
                if presets_vars.st_return_values < presets_vars.st_max then
                    presets_vars.st_return_values = presets_vars.st_return_values + 1
                elseif presets_vars.st_return_values >= presets_vars.st_max  then
                    presets_vars.st_return_values = presets_vars.st_min
                end
            end
            self.save_antiaims.body_yaw_2 = self:clamp(presets_vars.st_return_values,presets_vars.st_min,presets_vars.st_max)
            presets_vars.m_max_desync = 60
            presets_vars.m_min_desync = 30
            presets_vars.m_step_desync = 1
            presets_vars.m_stepticks_desync = API.GLOBALS.Tickcount() % 1
            if presets_vars.m_stepticks_desync == 1 - 1 then
                if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                    presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
                elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                    presets_vars.m_return_values_desync = presets_vars.m_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end


        if states == 5 and funcs.ui:table_contains(API.MENU.Get(gui.menu.preset_static),"\a646464FF Air") == true and not (API.MENU.Get(antiaim.doubletap[1]) and API.MENU.Get(antiaim.doubletap[2])) and not (API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2])) then
            self.save_antiaims.yaw_2 = 15
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 14
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 0
            self.save_antiaims.freestanding_body_yaw = false
        elseif states == 5 then
            self.save_antiaims.yaw_2 = self.jitter:desync(20,6)
            self.save_antiaims.yaw_jitter_1 = "Center"
            self.save_antiaims.yaw_jitter_2 = 66
            self.save_antiaims.body_yaw_1 = "Jitter"
            self.save_antiaims.body_yaw_2 = 0
            presets_vars.m_max_desync = 60
            presets_vars.m_min_desync = 30
            presets_vars.m_step_desync = 1
            presets_vars.m_stepticks_desync = API.GLOBALS.Tickcount() % 1
            if presets_vars.m_stepticks_desync == 1 - 1 then
                if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                    presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
                elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                    presets_vars.m_return_values_desync = presets_vars.m_min_desync
                end
            end
            self.save_antiaims.freestanding_body_yaw = false
        end
    end
    g_antiaim.direction = {}
    g_antiaim.direction.c_var = {
        saved_dir = 0,
        saved_press_tick = 0,
        left = false,
        right = false,
        back = false
    }
    function g_antiaim.direction:run_direction()
        if funcs.ui:table_contains(API.MENU.Get(gui.menu.main_list),"\a"..menu4.."             Extra antiaim settings") == false then
            return
        end
        API.MENU.Set(gui.menu.manual_left,"On hotkey")
        API.MENU.Set(gui.menu.manual_right,"On hotkey")
        API.MENU.Set(gui.menu.manual_reset,"On hotkey")
        API.MENU.Set(antiaim.freestanding[2],"Always on")
        local statements = API.MENU.Get(gui.menu.antiaim_settings)

        local fs_e = API.MENU.Get(gui.menu.freestanding_key) and funcs.ui:table_contains(statements,"\a646464FF Freestanding")
        local edge_e = API.MENU.Get(gui.menu.edge_yaw_key) and funcs.ui:table_contains(statements,"\a646464FF Edge yaw")
        API.MENU.Set(antiaim.freestanding[1], fs_e)
        API.MENU.Set(antiaim.edge_yaw, edge_e)
        if funcs.ui:table_contains(statements,"\a646464FF Manual antiaim") and API.CLIENT.Key( 0x45 ) then
            API.MENU.Set(antiaim.freestanding[1], false)
            API.MENU.Set(antiaim.edge_yaw, false)
    end

        local m_state = API.MENU.Get(gui.menu.temp_manual)
        local left_state
        local right_state
        local backward_state

        left_state, right_state, backward_state = API.MENU.Get(gui.menu.manual_left), API.MENU.Get(gui.menu.manual_right), -- this lua so sb
        API.MENU.Get(gui.menu.manual_reset)

        if left_state == self.c_var.left and right_state == self.c_var.right and backward_state == self.c_var.back then
            return
        end

        self.c_var.left, self.c_var.right, self.c_var.back = left_state, right_state, backward_state

        if (left_state and m_state == 1) or (right_state and m_state == 2) or (backward_state and m_state == 3) then
            API.MENU.Set(gui.menu.temp_manual, 0)
            return
        end




        if left_state and m_state ~= 1 then
            API.MENU.Set(gui.menu.temp_manual, 1)
        end
        if right_state and m_state ~= 2 then
            API.MENU.Set(gui.menu.temp_manual, 2)
        end
        if backward_state and m_state ~= 3 then
            API.MENU.Set(gui.menu.temp_manual, 3)
        end
        
    end
    local roll_ground_ticks = 0
    function g_antiaim:run_states(cmd)
        local p_duck = API.ENT.Prop(API.ENT.LocalPlayer(), "m_flDuckAmount")
        local inair = API.BIT.Band( API.ENT.Prop( API.ENT.LocalPlayer( ), "m_fFlags" ), 1 ) == 0 
        local on_ground = API.BIT.Band(API.ENT.Prop( API.ENT.LocalPlayer( ), "m_fFlags"), 1) 
        local vx, vy, vz = API.ENT.Prop(API.ENT.LocalPlayer(), "m_vecVelocity")
        local p_still = API.MATH.Sqrt(vx ^ 2 + vy ^ 2)
        local p_slow = API.MENU.Get(antiaim.slow_motion[1]) and API.MENU.Get(antiaim.slow_motion[2])
        if on_ground == 1 then
            roll_ground_ticks = roll_ground_ticks + 1
        else 
            roll_ground_ticks = 0
        end
        
        if API.CLIENT.Key(0x45) then
            return 7
        elseif self.direction.c_var.saved_dir ~= 0 then
            return 6
        elseif inair  then
            return 5
        elseif p_slow and roll_ground_ticks > 8 then
            return 4
        elseif p_duck > 0.8 and roll_ground_ticks > 8 then
            return 3
        elseif p_still > 5 and roll_ground_ticks > 8 then
            return 2
        elseif p_still < 2 and roll_ground_ticks > 8 then
            return 1
        else 
            return 5
        end




    end

    local gamerules_ptr = client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")
    local gamerules = libs.ffi.cast("intptr_t**", libs.ffi.cast("intptr_t", gamerules_ptr) + 2)[0]
    function g_antiaim:run_trustd()
        local is_valve_ds = libs.ffi.cast('bool*', gamerules[0] + 124)
        if is_valve_ds ~= nil then
            if funcs.ui:table_contains(API.MENU.Get(gui.menu.roll_selects),"\aF8F884D1 Match making") == true then
                is_valve_ds[0] = 0
            else
                is_valve_ds[0] = 1
            end
        end
    end

    local lean_lby = function(cmd)
        if check_roll == false then
            return
        end
        local local_player = API.ENT.LocalPlayer()
        if (API.MATH.Abs(cmd.forwardmove) > 1) or (API.MATH.Abs(cmd.sidemove) > 1) or cmd.in_jump == 1 or API.ENT.Prop(local_player, "m_MoveType") == 9 then
            return
        end

        local desync_amount = libs.antiaim_funcs.get_desync(2)

        if desync_amount == nil then
            return
        end
        
    if API.MATH.Abs(desync_amount) < 15 or cmd.chokedcommands == 0 then
            return
        end
        local vx, vy, vz = API.ENT.Prop(API.ENT.LocalPlayer(), "m_vecVelocity")

        local p_still = API.MATH.Sqrt(vx ^ 2 + vy ^ 2)
        local inair = API.BIT.Band( API.ENT.Prop( API.ENT.LocalPlayer( ), "m_fFlags" ), 1 ) == 0 and cmd.in_jump


    if p_still > 80 and not inair then return end

        cmd.forwardmove = 0
        cmd.in_forward = 1


    end

    function g_antiaim:run_roll(cmd)
        if funcs.ui:table_contains(API.MENU.Get(gui.menu.main_list),"\a"..menu4.."             Extra antiaim settings") == false then
            return
        end

        
        self.save_antiaims.pitch = "Default"

        self.save_antiaims.yaw_2 = "180"

        local states = self:run_states(cmd)

        -- "\a646464FF Stand","\a646464FF Move","\a646464FF Slow walk","\a646464FF Duck","\a646464FF Air","\a646464FF Use","\a646464FF Manual"  
        if API.MENU.Get(antiaim.quick_peek_assist[1]) and API.MENU.Get(antiaim.quick_peek_assist[2]) and funcs.ui:table_contains(API.MENU.Get(gui.menu.roll_selects),"\aF8F884D1 Disable roll when peeking") == true then
            check_roll = false
        
        elseif API.MENU.Get(gui.menu.roll_key) and funcs.ui:table_contains(API.MENU.Get(gui.menu.antiaim_settings),"\a646464FF Roll") then
            check_roll = true 
        elseif funcs.ui:table_contains(API.MENU.Get(gui.menu.forceroll_states),"\a646464FF Stand") and states == 1 and funcs.ui:table_contains(API.MENU.Get(gui.menu.antiaim_settings),"\a646464FF Roll") then
            check_roll = true 
        elseif funcs.ui:table_contains(API.MENU.Get(gui.menu.forceroll_states),"\a646464FF Move") and states == 2 and funcs.ui:table_contains(API.MENU.Get(gui.menu.antiaim_settings),"\a646464FF Roll") then
            check_roll = true 
        elseif funcs.ui:table_contains(API.MENU.Get(gui.menu.forceroll_states),"\a646464FF Slow walk") and states == 4 and funcs.ui:table_contains(API.MENU.Get(gui.menu.antiaim_settings),"\a646464FF Roll") then
            check_roll = true 
        elseif funcs.ui:table_contains(API.MENU.Get(gui.menu.forceroll_states),"\a646464FF Duck") and states == 3 and funcs.ui:table_contains(API.MENU.Get(gui.menu.antiaim_settings),"\a646464FF Roll") then
            check_roll = true 
        elseif funcs.ui:table_contains(API.MENU.Get(gui.menu.forceroll_states),"\a646464FF Air") and states == 5 and funcs.ui:table_contains(API.MENU.Get(gui.menu.antiaim_settings),"\a646464FF Roll") then
            check_roll = true 
        elseif funcs.ui:table_contains(API.MENU.Get(gui.menu.forceroll_states),"\a646464FF Use") and states == 7 and funcs.ui:table_contains(API.MENU.Get(gui.menu.antiaim_settings),"\a646464FF Roll") then
            check_roll = true 
        elseif funcs.ui:table_contains(API.MENU.Get(gui.menu.forceroll_states),"\a646464FF Manual") and states == 6 and funcs.ui:table_contains(API.MENU.Get(gui.menu.antiaim_settings),"\a646464FF Roll") then
            check_roll = true 
        else 
            check_roll = false
        end
        if check_roll == true then
            lean_lby(cmd)

        end
        

        if states == 7 then
            self.save_antiaims.yaw_2 = 0
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            if API.MENU.Get(gui.menu.roll_inverter) then
                self.save_antiaims.body_yaw_2 = 180
            else
                self.save_antiaims.body_yaw_2 = -180
            end



            self.save_antiaims.freestanding_body_yaw = false
        end

        if self.direction.c_var.saved_dir ~= 0 and states == 6 then
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = -180
            self.save_antiaims.freestanding_body_yaw = false
        end

        if states == 5 then
            self.save_antiaims.yaw_2 = 29
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        end

        if states == 4 then
            self.save_antiaims.yaw_2 = 9
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        end

        if states == 3 then
            self.save_antiaims.yaw_2 = 45
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        end

        if states == 2 then
            self.save_antiaims.yaw_2 = 4
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        end

        if states == 1 then
            if funcs.ui:table_contains(API.MENU.Get(gui.menu.roll_selects),"\aFA3F3FFF Unsafe roll") == true then
                if API.MENU.Get(gui.menu.roll_inverter) then
                    self.save_antiaims.yaw_2 = 10
                    self.save_antiaims.yaw_jitter_1 = "Off"
                    self.save_antiaims.yaw_jitter_2 = 0
                    self.save_antiaims.body_yaw_1 = "Static"
                    self.save_antiaims.body_yaw_2 = -180
                    self.save_antiaims.freestanding_body_yaw = false
                else
                    self.save_antiaims.yaw_2 = 10
                    self.save_antiaims.yaw_jitter_1 = "Off"
                    self.save_antiaims.yaw_jitter_2 = 0
                    self.save_antiaims.body_yaw_1 = "Static"
                    self.save_antiaims.body_yaw_2 = 180
                    self.save_antiaims.freestanding_body_yaw = false
                end

                
            else
                
                self.save_antiaims.yaw_2 = 4
                self.save_antiaims.yaw_jitter_1 = "Off"
                self.save_antiaims.yaw_jitter_2 = 0
                self.save_antiaims.body_yaw_1 = "Static"
                if API.MENU.Get(gui.menu.roll_inverter) then
                    self.save_antiaims.body_yaw_2 = -180
                else
                    self.save_antiaims.body_yaw_2 = 180
                end


                self.save_antiaims.freestanding_body_yaw = false
            end

        end
        local degree = 50
        if funcs.ui:table_contains(API.MENU.Get(gui.menu.roll_selects),"\aFA3F3FFF Unsafe roll") == true then
            degree = 80
            API.MENU.Set(antiaim.anti_untrusted,false)
        else
            API.MENU.Set(antiaim.anti_untrusted,true)
        end



        if check_roll == true then
            if self.direction.c_var.saved_dir ~= 0 then
                cmd.roll = -degree
            else 
                if funcs.ui:table_contains(API.MENU.Get(gui.menu.roll_selects),"\aF8F884D1 Jitter") == true then
                    cmd.roll = API.GLOBALS.Tickcount() % 4 >= 2 and degree or -degree

                else
                    cmd.roll = degree
                end
            end
        elseif check_roll == false then
            cmd.roll = 0
        end

    end


    g_antiaim.legit = {}
    g_antiaim.legit.classnames = {"CWorld","CCSPlayer","CFuncBrush"}

    function g_antiaim.legit:get_distance(x1, y1, z1, x2, y2, z2)
        return API.MATH.Sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
    end

    function g_antiaim.legit:entity_has_c4(ent)
        local bomb = API.ENT.GetAll("CC4")[1]
        return bomb ~= nil and API.ENT.Prop(bomb, "m_hOwnerEntity") == ent
    end

    function g_antiaim.legit:run_legit(cmd)
        if funcs.ui:table_contains(API.MENU.Get(gui.menu.main_list),"\a"..menu4.."             Extra antiaim settings") == false then
            return
        end
        if funcs.ui:table_contains(API.MENU.Get(gui.menu.antiaim_settings),"\a646464FF Antiaim on use") then

    
            local plocal = API.ENT.LocalPlayer()
            
            local distance = 100
            local bomb = API.ENT.GetAll("CPlantedC4")[1]
            local bomb_x, bomb_y, bomb_z = API.ENT.Prop(bomb, "m_vecOrigin")

            if bomb_x ~= nil then
                local player_x, player_y, player_z = API.ENT.Prop(plocal, "m_vecOrigin")
                distance = self:get_distance(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
            end
            
            local team_num = API.ENT.Prop(plocal, "m_iTeamNum")
            local defusing = team_num == 3 and distance < 62

            local on_bombsite = API.ENT.Prop(plocal, "m_bInBombZone")
    
            local has_bomb = self:entity_has_c4(plocal)
            local trynna_plant = on_bombsite ~= 0 and team_num == 2 and has_bomb and not API.MENU.Get(gui.menu.disable_use)
            
            local px, py, pz = API.CLIENT.EyePos()
            local pitch, yaw = API.CLIENT.CamAngles()
        
            local sin_pitch = API.MATH.Sin(API.MATH.Rad(pitch))
            local cos_pitch = API.MATH.Cos(API.MATH.Rad(pitch))
            local sin_yaw = API.MATH.Sin(API.MATH.Rad(yaw))
            local cos_yaw = API.MATH.Cos(API.MATH.Rad(yaw))

            local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }

            local fraction, entindex = API.CLIENT.Trace(plocal, px, py, pz, px + (dir_vec[1] * 8192), py + (dir_vec[2] * 8192), pz + (dir_vec[3] * 8192))

            local using = true

            if entindex ~= nil then
                for i=0, #self.classnames do
                    if API.ENT.ClassName(entindex) == self.classnames[i] then
                        using = false
                    end
                end
            end

            if not using and not trynna_plant and not defusing then
                cmd.in_use = 0
            end
        end
    end
    function g_antiaim:run_knife()
        local wpn_id = API.ENT.Prop(API.ENT.PlayerWeapon(API.ENT.LocalPlayer()), "m_iItemDefinitionIndex")
        local p_duck = API.ENT.Prop(API.ENT.LocalPlayer(), "m_flDuckAmount")
        local weapons = wpn_id ~= nil and API.BIT.Band(wpn_id, 0xFFFF) or 0
        if weapons == nil or wpn_id == nil then return end
        local is_knife = wpn_id >= 500 and wpn_id <= 525 or wpn_id == 41 or wpn_id == 42 or wpn_id == 59
        local in_air = API.BIT.Band( API.ENT.Prop( API.ENT.LocalPlayer( ), "m_fFlags" ), 1 ) == 0


        if is_knife and in_air and p_duck > 0.8 and not API.CLIENT.Key(0x45) then
            self.save_antiaims.pitch = "Default"
            self.save_antiaims.yaw_2 = 44
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.body_yaw_1 = "Static"
            self.save_antiaims.body_yaw_2 = 180
            self.save_antiaims.freestanding_body_yaw = false
        end
    end

    g_antiaim.anti_knife = {}
    function g_antiaim.anti_knife:get_distance(x1, y1, z1, x2, y2, z2)
        return API.MATH.Sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)

    end

    function g_antiaim.anti_knife:on_run_command()
        if funcs.ui:table_contains(API.MENU.Get(gui.menu.misc_settings),"\a646464FF Anti knife") == true then
            local players = API.ENT.GetPlayers(true)
            local lx, ly, lz = API.ENT.Prop(API.ENT.LocalPlayer(), "m_vecOrigin")
            local yaw, yaw_slider = API.MENU.Reference("AA", "Anti-aimbot angles", "Yaw")
            local pitch = API.MENU.Reference("AA", "Anti-aimbot angles", "Pitch")

            for i=1, #players do
                local x, y, z = API.ENT.Prop(players[i], "m_vecOrigin")
                local distance = self:get_distance(lx, ly, lz, x, y, z)
                local weapon = API.ENT.PlayerWeapon(players[i])
                if API.ENT.ClassName(weapon) == "CKnife" and distance <= API.MENU.Get(gui.menu.knife_distance) then
                    API.MENU.Set(yaw_slider,180)
                    if API.MENU.Get(gui.menu.pitch0_onknife) then
                        API.MENU.Set(pitch,"Off")
                    end
                end
            end
        end
    end

    g_antiaim.pre_render = {}
    g_antiaim.pre_render.vars = {
        ground_ticks = 0,
        end_time = 0
    }
    function g_antiaim.pre_render:animation_breaker()
        --if funcs.ui:table_contains(API.MENU.Get(gui.menu.misc_settings),"\a646464FF Animation breaker") == true then
            -- anim_list = main:ui(API.MENU.Multiselect(gui.tab[1],gui.tab[2],"Break anims","In air","On land","Leg fucker"),false,true),
            if not API.ENT.IsAlive(API.ENT.LocalPlayer()) then return end
        
            if gui2:get_combo(2, "In-air legs:") == "Static legs" then
                API.ENT.Setprop(API.ENT.LocalPlayer(), "m_flPoseParameter", 1, 6) 
            end

            if gui2:get_combo(2, "Slow motion legs:") == "Static legs" and API.MENU.Get(antiaim.slow_motion[1]) and API.MENU.Get(antiaim.slow_motion[2]) then
                API.ENT.Setprop(lp, "m_flPoseParameter", 0, 9)
            end

            if gui2:get_combo(2, "Land anim:") == "Zero on land" then
                local on_ground = API.BIT.Band(API.ENT.Prop(API.ENT.LocalPlayer(), "m_fFlags"), 1)
                if on_ground == 1 then
                    self.vars.ground_ticks = self.vars.ground_ticks + 1
                else
                    self.vars.ground_ticks = 0
                    self.vars.end_time = API.GLOBALS.Curtime() + 1
                end 
            
                if self.vars.ground_ticks > API.MENU.Get(antiaim.fake_lag_limit)+1 and self.vars.end_time > API.GLOBALS.Curtime() then
                    API.ENT.Setprop(API.ENT.LocalPlayer(), "m_flPoseParameter", 0.5, 12)
                end
            end 
            local legs_types = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
        
            if gui2:get_combo(2, "Legfucker:") == "Funky Legs" then
                API.MENU.Set(antiaim.leg_movement, legs_types[API.MATH.Random(1, 3)])
                API.ENT.Setprop(API.ENT.LocalPlayer(), "m_flPoseParameter", 8, 0)
            end
        end
        


    function g_antiaim:run_main(cmd)

        local m = gui.menu
        self.direction:run_direction()
        self.legit:run_legit(cmd)

        if API.MENU.Get(gui.menu.temp_manual) == 0 then

            self.direction.c_var.saved_dir = 0
        end
        if API.MENU.Get(gui.menu.temp_manual) == 1 then

            if check_roll == true then
                self.direction.c_var.saved_dir =  -90 

            elseif check_roll == false then
                self.direction.c_var.saved_dir =  -70 

            end
        end
        if API.MENU.Get(gui.menu.temp_manual) == 2 then
    
            if check_roll == true then
                self.direction.c_var.saved_dir =  90 

            elseif check_roll == false then
                self.direction.c_var.saved_dir =  110

            end
        end

        self:run_roll(cmd)

        if check_roll == false then
            if API.MENU.Get(m.presets) == "Dangerous" then
                self:run_presets_1(cmd)
            elseif API.MENU.Get(m.presets) == "Custom" then
                self:run_custom(cmd)
            elseif API.MENU.Get(m.presets) == "Meta" then
                self:run_presets_2(cmd)
            elseif API.MENU.Get(m.presets) == "Dynamic" then
                self:run_presets_3(cmd)
            end
        end
        
        if funcs.ui:table_contains(API.MENU.Get(gui.menu.main_list),"\a"..menu4.."             Extra antiaim settings") == true then
            if funcs.ui:table_contains(API.MENU.Get(gui.menu.antiaim_settings),"\a646464FF Antiaim on use") and API.CLIENT.Key(0x45) then

                self.save_antiaims.pitch = "Off"
                self.save_antiaims.yaw_1 = "Off"
                if API.MENU.Get(gui.menu.static_onuse) and not funcs.ui:table_contains(API.MENU.Get(gui.menu.forceroll_states),"\a646464FF Use") == true or not API.MENU.Get(gui.menu.roll_key) then
                    self.save_antiaims.body_yaw_1 = "Static"
                    self.save_antiaims.body_yaw_2 = 180
                    self.save_antiaims.yaw_jitter_1 = "Off"
                    self.save_antiaims.freestanding_body_yaw = true
        
                end
            end
        end
    

    
        

    
    


        if funcs.ui:table_contains(API.MENU.Get(gui.menu.main_list),"\a"..menu4.."             Extra antiaim settings") == true then


            if self.direction.c_var.saved_dir ~= 0 then
                self.save_antiaims.yaw_2 = self.direction.c_var.saved_dir
                if API.MENU.Get(gui.menu.prevent_jitter) then
                    self.save_antiaims.body_yaw_1 = "Static"
                    self.save_antiaims.yaw_jitter_1 = "Off"
                end
                if check_roll == true then
                    if self.direction.c_var.saved_dir ~= 0 then
                        self.save_antiaims.body_yaw_2 = 180

                    else
                        self.save_antiaims.body_yaw_2 = -180
                    end
                else
                    self.save_antiaims.body_yaw_2 = 180
                end
            end
    
        end



                

        
            self:run_knife()
            API.MENU.Set(antiaim.pitch,self.save_antiaims.pitch)
            API.MENU.Set(antiaim.yaw_base,self.direction.c_var.saved_dir == 0 and not API.CLIENT.Key(0x45) and "At targets" or "Local view")
            API.MENU.Set(antiaim.yaw[1],self.save_antiaims.yaw_1)
            API.MENU.Set(antiaim.yaw[2],self.save_antiaims.yaw_2)
            API.MENU.Set(antiaim.yaw_jitter[1],self.save_antiaims.yaw_jitter_1)
            API.MENU.Set(antiaim.yaw_jitter[2],self.save_antiaims.yaw_jitter_2)
            API.MENU.Set(antiaim.body_yaw[1],self.save_antiaims.body_yaw_1)
            -- API.MENU.Set(antiaim.body_yaw[2],self.save_antiaims.body_yaw_2)
            API.MENU.Set(antiaim.freestanding_body_yaw,self.save_antiaims.freestanding_body_yaw)

        



            self:og_menu(false)


    end

    API.RENDER.Rectangles = function(x, y, w, h, r, g, b, a, radius)
        y = y + radius
        local datacircle = {
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

        for _, data in API.ENV.Pairs(datacircle) do
            API.RENDER.Circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
        end

        for _, data in API.ENV.Pairs(data) do
        API.RENDER.Rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
        end
    end


    render.center = {}
    render.center.vars = {
        alpha = 0,
        add_x =0,
        add_x2 =0,
        add_x3 =0,
        add_standing =0,
        add_duck =0,
        add_moving =0,
        add_fakeduck =0,
        add_y = 0,
        rect_add_y =0,
        rect_alpha = 0,
        rect_width = 0,
        icon_alpha = 0,
        icon_back_alpha = 0

    }

    function render:lerp(start, vend, time)
        return start + (vend - start) * time
    end


    function render.center:draw()

            local sc = {API.CLIENT.Screen()}
            local desync_angle = API.MATH.Abs(libs.antiaim_funcs.get_desync())
            local cx,cy = sc[1]/2,sc[2]/2
            local r,g,b,a = API.MENU.Get(gui.menu.indicator_color)
            local tickbase = libs.antiaim_funcs.get_tickbase_shifting()
            local getdt = libs.antiaim_funcs.get_double_tap()
            local function get_velocity(player)
                local x,y,z = API.ENT.Prop(player, "m_vecVelocity")
                if x == nil then return end
                return API.MATH.Sqrt(x*x + y*y + z*z)
            end
            local lp_vel = get_velocity(API.ENT.LocalPlayer())
            local function is_crouching(player)
                local flags = API.ENT.Prop(player, "m_fFlags")
                
                if API.BIT.Band(flags, 4) == 4 then
                    return true
                end
                
                return false
            end
            
            local function in_air(player)
                local flags = API.ENT.Prop(player, "m_fFlags")
                
                if API.BIT.Band(flags, 1) == 0 then
                    return true
                end
                
                return false
            end
            local function state(lp_vel)
                if lp_vel < 5 and not in_air(API.ENT.LocalPlayer()) and not ((is_crouching(API.ENT.LocalPlayer())) or API.MENU.Get(antiaim.fakeduck)) then
                    cnds = 1
                elseif in_air(API.ENT.LocalPlayer()) then
                    cnds = 3
                elseif ((is_crouching(API.ENT.LocalPlayer()) and not in_air(API.ENT.LocalPlayer())) or API.MENU.Get(antiaim.fakeduck)) then
                    cnds = 4
                else
                    cnds = 2
                end
        
                return cnds
            end
            --API.RENDER.Indicator(255,255,255,255, getdt)
            --print(tickbase)
            local text_size = {API.RENDER.Measure("b","PlugWalk")}
            local alpha = API.MATH.Floor(API.MATH.Sin(API.MATH.Abs(-API.MATH.Pi + (API.GLOBALS.Curtime() * (1.25 / 0.75)) % (API.MATH.Pi * 2))) * 8)
            if alpha <= 1 then
                alpha = 1
            end
            local wpn_id = API.ENT.Prop(API.ENT.PlayerWeapon(API.ENT.LocalPlayer()), "m_iItemDefinitionIndex")
            local weapons = wpn_id ~= nil and API.BIT.Band(wpn_id, 0xFFFF) or 0
            if weapons == nil or wpn_id == nil then
                return
            end
            local is_scoped = API.ENT.Prop(API.ENT.PlayerWeapon(API.ENT.LocalPlayer()), "m_zoomLevel" )
            local is_knife =wpn_id >= 500 and wpn_id <= 525 or wpn_id == 41 or wpn_id == 42 or wpn_id == 59

            local modifier = API.ENT.Prop(API.ENT.LocalPlayer(), "m_flVelocityModifier")
            if funcs.ui:table_contains(API.MENU.Get(gui.menu.indicator_settings),"\a646464FF Indicator Style") then

                if is_scoped ~= 0 and not is_knife then
                    self.vars.alpha =  render:lerp(self.vars.alpha,70,API.GLOBALS.Frametimes() * 8)
                    self.vars.icon_alpha =  render:lerp(self.vars.icon_alpha,20,API.GLOBALS.Frametimes() * 8)
                    self.vars.icon_back_alpha =  render:lerp(self.vars.icon_back_alpha,20,API.GLOBALS.Frametimes() * 8)

                    
                    self.vars.add_x = render:lerp(self.vars.add_x,32,API.GLOBALS.Frametimes() * 8)
                    self.vars.add_y = render:lerp(self.vars.add_y,0,API.GLOBALS.Frametimes() * 8)
                    self.vars.add_x2 = render:lerp(self.vars.add_x2,18,API.GLOBALS.Frametimes() * 8)
                    self.vars.add_x3 = render:lerp(self.vars.add_x3,28,API.GLOBALS.Frametimes() * 8)
                    self.vars.add_duck = render:lerp(self.vars.add_duck,24,API.GLOBALS.Frametimes() * 8)
                    self.vars.add_fakeduck = render:lerp(self.vars.add_fakeduck,35,API.GLOBALS.Frametimes() * 8)
                    self.vars.add_standing = render:lerp(self.vars.add_standing,30,API.GLOBALS.Frametimes() * 8)
                    self.vars.add_moving = render:lerp(self.vars.add_moving,28,API.GLOBALS.Frametimes() * 8)
                    self.vars.rect_alpha = render:lerp(self.vars.rect_alpha,55,API.GLOBALS.Frametimes() * 8)

                else
                    self.vars.icon_alpha =  render:lerp(self.vars.icon_alpha,a,API.GLOBALS.Frametimes() * 8)
                    self.vars.icon_back_alpha =  render:lerp(self.vars.icon_back_alpha,150,API.GLOBALS.Frametimes() * 8)

                    self.vars.alpha =  render:lerp(self.vars.alpha,a,API.GLOBALS.Frametimes() * 8)
                    self.vars.add_x = render:lerp(self.vars.add_x,0,API.GLOBALS.Frametimes() * 8)
                    self.vars.add_x2 = render:lerp(self.vars.add_x2,0,API.GLOBALS.Frametimes() * 8)
                    self.vars.add_x3 = render:lerp(self.vars.add_x3,0,API.GLOBALS.Frametimes() * 8)
                    self.vars.add_duck = render:lerp(self.vars.add_duck,0,API.GLOBALS.Frametimes() * 8)
                    self.vars.add_fakeduck = render:lerp(self.vars.add_fakeduck,0,API.GLOBALS.Frametimes() * 8)
                    self.vars.add_standing = render:lerp(self.vars.add_standing,0,API.GLOBALS.Frametimes() * 8)
                    self.vars.add_moving = render:lerp(self.vars.add_moving,0,API.GLOBALS.Frametimes() * 8)
                    if modifier ~= 1 then
                        self.vars.add_y = render:lerp(self.vars.add_y,5,API.GLOBALS.Frametimes() * 8)
                        self.vars.rect_alpha = render:lerp(self.vars.rect_alpha,255,API.GLOBALS.Frametimes() * 8)
                        self.vars.rect_add_y = render:lerp(self.vars.rect_add_y,4,API.GLOBALS.Frametimes() * 8)
                        self.vars.rect_width = render:lerp(self.vars.rect_width,API.MATH.Floor((text_size[1]- 1) * modifier),API.GLOBALS.Frametimes() * 8)
                    else
                        self.vars.rect_alpha = render:lerp(self.vars.rect_alpha,0,API.GLOBALS.Frametimes() * 8)
                        self.vars.add_y = render:lerp(self.vars.add_y,0,API.GLOBALS.Frametimes() * 8)
                        self.vars.rect_add_y = render:lerp(self.vars.rect_add_y,0,API.GLOBALS.Frametimes() * 8)
                        self.vars.rect_width = render:lerp(self.vars.rect_width,0,API.GLOBALS.Frametimes() * 8)
            
                    end
            
                end
                    
            local bullet = {
                64,
                64,
                '<svg width="554.4" height="649.6" version="1.1" viewBox="0 0 554.4 649.6" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><path d="m273.53 531.63-1.2395-1-9.3067-28.8-4.6424-12-9.818-24-17.748-35.2-8.6508-14.4-15.06-22.4-13.001-16.784-19.226-19.216-13.574-10.574-11.2-7.2366-9.0585-4.8934-13.342-5.418-12.169-3.7597 20.169-13.528 9.6-7.622 9.7313-10.168 5.9613-8.9982 4.6761-11.49 1.8536-10.644-.44579-8.4502-.44578-8.4502-4.2296-17.567-5.4146-16.362-3.4264-8.6192-3.4264-8.6192-11.531-23.496-7.5372-13.304-4.8378-8-12.086-19.2-21.358-31.75.61216-.61215 17.504 13.176 11.2 8.674 24 20.062 23.2 20.715 16.8 15.328 26.449 26.408 9.6565 10.4 16.766 20 7.9794 11.2 2.9747 4.5356 2.9746 4.5356v1.1609l-8.4-7.896-12.975-9.8364-20.234-13.684-10.792-5.4178-12.287-4.9044-2.8566-.53589-2.8566-.53591v.93244l4.1268 9.2456 4.7217 12.8 1.1757 6.7048 1.1757 6.7048-.006 12.99-2.3936 14.758-4.6527 11.712-8.0522 13.994-6.7765 8.3356-8.7112 9.0411.89866 1.4541 14.094 8.5536 12.8 9.9316 12.087 11.02 15.664 17.105 8.6992 10.895 11.805 16.8 11.046 17.6 9.4292 16.8 6.1129 11.2 2.6527 5.2h13.131l10.79-19.6 14.435-24 7.9316-12 9.7475-13.6 14.579-17.6 15.89-16.128 13.6-10.775 18.4-12.278.42665-.1792-10.184-10.541-9.981-14.573-6.3921-13.64-2.0371-8.1431-2.0371-8.1431-.062-18.4 2.1096-8 2.1096-8 7.2467-17.467-.73833-.73832-7.6613 1.8785-11.368 4.6767-11.832 6.6356-8.8 5.7196-20.8 15.067-9.2 8.9784v-1.4415l11.966-17.817 21.136-25.491 40.099-39.849 18.279-16.151 22.521-19.81 25.818-20.99 9.3822-7.2772 10.8-7.6632v.76582l-27.647 41.375-8.2699 13.6-9.9886 17.6-6.2336 12-7.3055 16-4.6248 12-2.6501 8-2.6501 8-1.3152 4.4709-1.3152 4.4709-1.1951 7.9291-1.1951 7.9291-.005 5.9345-.005 5.9345 1.8287 10.531 5.3676 11.792 3.5177 4.9042 3.5177 4.9042 13.368 12.954 23.735 15.578-.40504.40505-.40504.40504-18.925 6.3179-14.174 7.2282-10.16 6.1725-12.466 9.3149-16.602 16.025-13.127 16-11.902 16-9.0454 14.4-11.38 20-15.733 32-3.6731 8.8-3.6731 8.8-5.4866 14.4-6.3764 19.2-3.4474 11.6h-2.8481l-1.2396-1zm-39.27-181.47-3.0032-.70782-7.7678-3.9362-13.046-12.273-9.6518-12.809.37408-.37406.37407-.37407 9.3241 2.0225 13.355 6.9654 9.2924 6.3104 4.9404 5.9936 1.3228 4.0254 1.3228 4.0253.36908 1 .36906 1-4.5712-.1608zm75.805-1.7315.52931-2.6.73607-2.8922.73608-2.8922 7.5964-7.1049 10.259-6.012 10.541-4.8537 8.6625-3.0491.27134.27135.27136.27134-12.746 16.847-8.8057 8.0479-7.4467 4.162-8.097 2.4046h-3.0367z" stroke-width=".8" fill="#ffffff"/></svg>',
                '<svg width="554.4" height="649.6" version="1.1" viewBox="0 0 554.4 649.6" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><path d="m273.53 531.63-1.2395-1-9.3067-28.8-4.6424-12-9.818-24-17.748-35.2-8.6508-14.4-15.06-22.4-13.001-16.784-19.226-19.216-13.574-10.574-11.2-7.2366-9.0585-4.8934-13.342-5.418-12.169-3.7597 20.169-13.528 9.6-7.622 9.7313-10.168 5.9613-8.9982 4.6761-11.49 1.8536-10.644-.44579-8.4502-.44578-8.4502-4.2296-17.567-5.4146-16.362-3.4264-8.6192-3.4264-8.6192-11.531-23.496-7.5372-13.304-4.8378-8-12.086-19.2-21.358-31.75.61216-.61215 17.504 13.176 11.2 8.674 24 20.062 23.2 20.715 16.8 15.328 26.449 26.408 9.6565 10.4 16.766 20 7.9794 11.2 2.9747 4.5356 2.9746 4.5356v1.1609l-8.4-7.896-12.975-9.8364-20.234-13.684-10.792-5.4178-12.287-4.9044-2.8566-.53589-2.8566-.53591v.93244l4.1268 9.2456 4.7217 12.8 1.1757 6.7048 1.1757 6.7048-.006 12.99-2.3936 14.758-4.6527 11.712-8.0522 13.994-6.7765 8.3356-8.7112 9.0411.89866 1.4541 14.094 8.5536 12.8 9.9316 12.087 11.02 15.664 17.105 8.6992 10.895 11.805 16.8 11.046 17.6 9.4292 16.8 6.1129 11.2 2.6527 5.2h13.131l10.79-19.6 14.435-24 7.9316-12 9.7475-13.6 14.579-17.6 15.89-16.128 13.6-10.775 18.4-12.278.42665-.1792-10.184-10.541-9.981-14.573-6.3921-13.64-2.0371-8.1431-2.0371-8.1431-.062-18.4 2.1096-8 2.1096-8 7.2467-17.467-.73833-.73832-7.6613 1.8785-11.368 4.6767-11.832 6.6356-8.8 5.7196-20.8 15.067-9.2 8.9784v-1.4415l11.966-17.817 21.136-25.491 40.099-39.849 18.279-16.151 22.521-19.81 25.818-20.99 9.3822-7.2772 10.8-7.6632v.76582l-27.647 41.375-8.2699 13.6-9.9886 17.6-6.2336 12-7.3055 16-4.6248 12-2.6501 8-2.6501 8-1.3152 4.4709-1.3152 4.4709-1.1951 7.9291-1.1951 7.9291-.005 5.9345-.005 5.9345 1.8287 10.531 5.3676 11.792 3.5177 4.9042 3.5177 4.9042 13.368 12.954 23.735 15.578-.40504.40505-.40504.40504-18.925 6.3179-14.174 7.2282-10.16 6.1725-12.466 9.3149-16.602 16.025-13.127 16-11.902 16-9.0454 14.4-11.38 20-15.733 32-3.6731 8.8-3.6731 8.8-5.4866 14.4-6.3764 19.2-3.4474 11.6h-2.8481l-1.2396-1zm-39.27-181.47-3.0032-.70782-7.7678-3.9362-13.046-12.273-9.6518-12.809.37408-.37406.37407-.37407 9.3241 2.0225 13.355 6.9654 9.2924 6.3104 4.9404 5.9936 1.3228 4.0254 1.3228 4.0253.36908 1 .36906 1-4.5712-.1608zm75.805-1.7315.52931-2.6.73607-2.8922.73608-2.8922 7.5964-7.1049 10.259-6.012 10.541-4.8537 8.6625-3.0491.27134.27135.27136.27134-12.746 16.847-8.8057 8.0479-7.4467 4.162-8.097 2.4046h-3.0367z" stroke-width=".8" fill="#ffffff"/></svg>'
            }
            local svg = API.RENDER.Svg(bullet[3], 64 , 64 )
            local svg_2 = API.RENDER.Svg(bullet[4], 64 , 64 )
            if API.MENU.Get(gui.menu.center_mode) == "Text" then
                API.RENDER.Text(cx - text_size[1]/2 + API.MATH.Floor(self.vars.add_x),cy + 20 - API.MATH.Floor(self.vars.add_y),255,255,255,70,"b",0,"PlugWalk")
                if lp_vel < 5 and not in_air(API.ENT.LocalPlayer()) and not ((is_crouching(API.ENT.LocalPlayer())) or API.MENU.Get(antiaim.fakeduck)) then
                    API.RENDER.Text(cx + 3 - text_size[1]/2 + API.MATH.Floor(self.vars.add_standing),cy + 32,r,g,b,self.vars.alpha,"b",0,('Standing'))
                elseif in_air(API.ENT.LocalPlayer()) then
                    API.RENDER.Text(cx+15 - text_size[1]/2 + API.MATH.Floor(self.vars.add_x2),cy + 32,r,g,b,self.vars.alpha,"b",0,('Air'))
                elseif API.MENU.Get(antiaim.fakeduck) then
                    API.RENDER.Text(cx - 3 - text_size[1]/2 + API.MATH.Floor(self.vars.add_fakeduck),cy + 32,r,g,b,self.vars.alpha,"b",0,('Fake-Duck'))
                elseif ((is_crouching(API.ENT.LocalPlayer()) and not in_air(API.ENT.LocalPlayer())) or API.MENU.Get(antiaim.fakeduck)) then
                    API.RENDER.Text(cx + 10 - text_size[1]/2 + API.MATH.Floor(self.vars.add_duck),cy + 32,r,g,b,self.vars.alpha,"b",0,('Duck'))
                else
                    API.RENDER.Text(cx + 5 - text_size[1]/2 + API.MATH.Floor(self.vars.add_moving),cy + 32,r,g,b,self.vars.alpha,"b",0,('Moving'))
                end
                if desync_angle > 30 then
                    API.RENDER.Text(cx - text_size[1]/2 + API.MATH.Floor(self.vars.add_x),cy + 20 - API.MATH.Floor(self.vars.add_y),r,g,b,self.vars.alpha,"b",0,"Plug")
                elseif desync_angle < 30 then
                    API.RENDER.Text(cx +22 - text_size[1]/2 + API.MATH.Floor(self.vars.add_x),cy + 20 - API.MATH.Floor(self.vars.add_y),r,g,b,self.vars.alpha,"b",0,"Walk")
                end
                if API.MENU.Get(antiaim.doubletap[2]) then
                    if getdt == false then
                        API.RENDER.Text(cx+ 15 - text_size[1]/2 + API.MATH.Floor(self.vars.add_x2),cy + 45,255, 0, 0,self.vars.alpha,"b",0,"DT")
                    else
                        API.RENDER.Text(cx + 15 - text_size[1]/2 + API.MATH.Floor(self.vars.add_x2),cy + 45,132,196,20,self.vars.alpha,"b",0,"DT")
                    end

                end
                if API.MENU.Get(antiaim.hide_shots[2]) and not API.MENU.Get(antiaim.doubletap[2]) then
                    API.RENDER.Text(cx+ 6 - text_size[1]/2 + API.MATH.Floor(self.vars.add_x3),cy + 45,132,196,20,self.vars.alpha,"b",0,"OS-AA")
                elseif API.MENU.Get(antiaim.hide_shots[2]) and API.MENU.Get(antiaim.doubletap[2]) then-- or API.MENU.Get(antiaim.fakeduck) then
                    API.RENDER.Text(cx+ 6 - text_size[1]/2 + API.MATH.Floor(self.vars.add_x3),cy + 55,255, 0, 0,self.vars.alpha,"b",0,"OS-AA")
                end
                API.RENDER.Rectangle(
                    cx - text_size[1]/2 + API.MATH.Floor(self.vars.add_x),cy + 15 + text_size[2] - 2 + API.MATH.Floor(self.vars.rect_add_y),text_size[1],3,25,25,25,API.MATH.Floor(self.vars.rect_alpha)
                )
                API.RENDER.Rectangle(
                    cx - text_size[1]/2 + API.MATH.Floor(self.vars.add_x) +1,cy + 15   + text_size[2] - 2 + API.MATH.Floor(self.vars.rect_add_y) + 1,self.vars.rect_width,1,r,g,b,API.MATH.Floor(self.vars.rect_alpha)
                )
            elseif API.MENU.Get(gui.menu.center_mode) == "Pixel Text" then
                --render_glow_rectangle(cx  - text_size[1]/2 + API.MATH.Floor(self.vars.add_x),cy + 22- API.MATH.Floor(self.vars.add_y),text_size[1] - 2 + 2,text_size[2] - 5,r,g,b,15,8,self.vars.alpha_glow,2)
                API.RENDER.Text(cx + 7 - text_size[1]/2 + API.MATH.Floor(self.vars.add_x),cy + 5 - API.MATH.Floor(self.vars.add_y),255,255,255,70,"-",0,"PlugWalk")
                if lp_vel < 5 and not in_air(API.ENT.LocalPlayer()) and not ((is_crouching(API.ENT.LocalPlayer())) or API.MENU.Get(antiaim.fakeduck)) then
                    API.RENDER.Text(cx + 7 - text_size[1]/2 + API.MATH.Floor(self.vars.add_standing),cy + 12,r,g,b,self.vars.alpha,"-",0,('Standing'))
                elseif in_air(API.ENT.LocalPlayer()) then
                    API.RENDER.Text(cx+15 - text_size[1]/2 + API.MATH.Floor(self.vars.add_x2),cy + 12,r,g,b,self.vars.alpha,"-",0,('Air'))
                elseif API.MENU.Get(antiaim.fakeduck) then
                    API.RENDER.Text(cx + 5 - text_size[1]/2 + API.MATH.Floor(self.vars.add_fakeduck),cy + 12,r,g,b,self.vars.alpha,"-",0,('Fake-Duck'))
                elseif ((is_crouching(API.ENT.LocalPlayer()) and not in_air(API.ENT.LocalPlayer())) or API.MENU.Get(antiaim.fakeduck)) then
                    API.RENDER.Text(cx + 13 - text_size[1]/2 + API.MATH.Floor(self.vars.add_duck),cy + 12,r,g,b,self.vars.alpha,"-",0,('Duck'))
                else
                    API.RENDER.Text(cx + 9 - text_size[1]/2 + API.MATH.Floor(self.vars.add_moving),cy + 12,r,g,b,self.vars.alpha,"-",0,('Moving'))
                end
                if desync_angle > 30 then
                    API.RENDER.Text(cx + 7 - text_size[1]/2 + API.MATH.Floor(self.vars.add_x),cy + 5 - API.MATH.Floor(self.vars.add_y),r,g,b,self.vars.alpha,"-",0,"Plug")
                elseif desync_angle < 30 then
                    API.RENDER.Text(cx +22 - text_size[1]/2 + API.MATH.Floor(self.vars.add_x),cy + 5 - API.MATH.Floor(self.vars.add_y),r,g,b,self.vars.alpha,"-",0,"Walk")
                end
                if API.MENU.Get(antiaim.doubletap[2]) then
                    if getdt == false then
                        API.RENDER.Text(cx+ 15 - text_size[1]/2 + API.MATH.Floor(self.vars.add_x2),cy + 20,255, 0, 0,self.vars.alpha,"-",0,"DT")
                    else
                        API.RENDER.Text(cx + 15 - text_size[1]/2 + API.MATH.Floor(self.vars.add_x2),cy + 20,132,196,20,self.vars.alpha,"-",0,"DT")
                    end

                end
                if API.MENU.Get(antiaim.hide_shots[2]) and not API.MENU.Get(antiaim.doubletap[2]) then
                    API.RENDER.Text(cx+ 8 - text_size[1]/2 + API.MATH.Floor(self.vars.add_x3),cy + 20,132,196,20,self.vars.alpha,"-",0,"OS-AA")
                elseif API.MENU.Get(antiaim.hide_shots[2]) and API.MENU.Get(antiaim.doubletap[2]) then-- or API.MENU.Get(antiaim.fakeduck) then
                    API.RENDER.Text(cx+ 8 - text_size[1]/2 + API.MATH.Floor(self.vars.add_x3),cy + 28,255, 0, 0,self.vars.alpha,"-",0,"OS-AA")
                end
                API.RENDER.Rectangle(
                    cx - text_size[1]/2 + API.MATH.Floor(self.vars.add_x),cy - 2 + text_size[2] - 1 + API.MATH.Floor(self.vars.rect_add_y),text_size[1],3,25,25,25,API.MATH.Floor(self.vars.rect_alpha)
                )
                API.RENDER.Rectangle(
                    cx - text_size[1]/2 + API.MATH.Floor(self.vars.add_x) +1,cy - 2 + text_size[2] - 1 + API.MATH.Floor(self.vars.rect_add_y) + 1,self.vars.rect_width,1,r,g,b,API.MATH.Floor(self.vars.rect_alpha)
                )
            elseif API.MENU.Get(gui.menu.center_mode) == "Icon" then
                API.RENDER.Texture(svg_2,cx - 40+ 6 + 1 +  API.MATH.Floor(self.vars.add_x) ,cy + 10 + 1,64 ,64 ,255,255,255,self.vars.icon_back_alpha)
                API.RENDER.Texture(svg_2,cx - 40+ 6 - 1  +  API.MATH.Floor(self.vars.add_x),cy + 10 - 1, 64,64 ,255,255,255,self.vars.icon_back_alpha)
                API.RENDER.Texture(svg_2,cx - 40+ 6- 1 +  API.MATH.Floor(self.vars.add_x),cy + 10 + 1,64 ,64 ,255,255,255,self.vars.icon_back_alpha)
                API.RENDER.Texture(svg_2,cx - 40+ 6 + 1+  API.MATH.Floor(self.vars.add_x) ,cy + 10 - 1,64 ,64 ,255,255,255,self.vars.icon_back_alpha)
                API.RENDER.Texture(svg,cx - 40 + 6+  API.MATH.Floor(self.vars.add_x) ,cy + 10,64 ,64 ,r,g,b,self.vars.icon_alpha)
                if API.MENU.Get(antiaim.doubletap[2]) then
                    if getdt == true then
                        API.RENDER.Texture(svg,cx - 40 + 6+  API.MATH.Floor(self.vars.add_x) ,cy + 10,64 ,64 ,132,196,20,self.vars.icon_alpha)
                    else
                        API.RENDER.Texture(svg,cx - 40 + 6+  API.MATH.Floor(self.vars.add_x) ,cy + 10,64 ,64 ,255,0,0,self.vars.icon_alpha)
                    end
                end
                --API.RENDER.Texture(svg,cx - 40 + 6+  API.MATH.Floor(self.vars.add_x) ,cy + 10,64 ,64 ,r,g,b,self.vars.icon_alpha)
                API.RENDER.Rectangle(
                    cx - text_size[1]/2 + API.MATH.Floor(self.vars.add_x),cy + 60 + text_size[2] - 2 - API.MATH.Floor(self.vars.add_y) + API.MATH.Floor(self.vars.rect_add_y),text_size[1],3,25,25,25,API.MATH.Floor(self.vars.rect_alpha)
                )
                API.RENDER.Rectangle(
                    cx - text_size[1]/2 + API.MATH.Floor(self.vars.add_x) +1,cy + 60   + text_size[2] - 2 - API.MATH.Floor(self.vars.add_y) + API.MATH.Floor(self.vars.rect_add_y) + 1,self.vars.rect_width,1,r,g,b,API.MATH.Floor(self.vars.rect_alpha)
                )
            end
        

        
        end
    end

    local brute = {
        yaw_status = "default",
        fs_side = 0,
        last_miss = 0,
        best_angle = 0,
        misses = { },
        hp = 0,
        misses_ind = { },
        can_hit_head = 0,
        can_hit = 0,
        hit_reverse = { }
    }


    local function brute_impact(e)

        local me = API.ENT.LocalPlayer()

        if not API.ENT.IsAlive(me) then return end

        local shooter_id = e.userid
        local shooter = API.CLIENT.UIDtoENT(shooter_id)

        if not API.ENT.IsEnemy(shooter) or API.ENT.IsDormant(shooter) then return end

        local lx, ly, lz = API.ENT.HitboxPos(me, "head_0")
        
        local ox, oy, oz = API.ENT.Prop(me, "m_vecOrigin")
        local ex, ey, ez = API.ENT.Prop(shooter, "m_vecOrigin")

        local dist = ((e.y - ey)*lx - (e.x - ex)*ly + e.x*ey - e.y*ex) / API.MATH.Sqrt((e.y-ey)^2 + (e.x - ex)^2)
        
        if API.MATH.Abs(dist) <= 35 and API.GLOBALS.Curtime() - brute.last_miss > 0.015 then
            if API.MENU.Get(gui.menu.static_onuse) then
                API.TABLE.Insert(render.notifications.table_text, {
                    text = "\aFFFFFFC8Switched AA due to Anti-Bruteforce",
                    timer = API.GLOBALS.Realtime(),
                
                    smooth_y = render.notifications.c_var.screen[2] + 100,
                    alpha = 0,
                    alpha2 = 0,
                    alpha3 = 0,
        
                    box_left = API.RENDER.Measure(nil,"\aFFFFFFC8Switched AA due to Anti-Bruteforce"),
                    box_right = API.RENDER.Measure(nil,"\aFFFFFFC8Switched AA due to Anti-Bruteforce"),
                
                    box_left_1 = 0,
                    box_right_1 = 0
                })   
            --else
            end
            brute.last_miss = API.GLOBALS.Curtime()
            if brute.misses[shooter] == nil then
                brute.misses[shooter] = 1 
                brute.misses_ind[shooter] = 1
            elseif brute.misses[shooter] >= 2 then
                brute.misses[shooter] = nil
            else
                brute.misses_ind[shooter] = brute.misses_ind[shooter] + 1
                brute.misses[shooter] = brute.misses[shooter] + 1
            end
        end
    end

    brute.reset = function()
        brute.fs_side = 0
        brute.last_miss = 0
        brute.best_angle = 0
        brute.misses_ind = { }
        brute.misses = { }
    end

    local function brute_death(e)
        
        local victim_id = e.userid
        local victim = API.CLIENT.UIDtoENT(victim_id)

        if victim ~= API.ENT.LocalPlayer() then return end

        local attacker_id = e.attacker
        local attacker = API.CLIENT.UIDtoENT(attacker_id)

        if not API.ENT.IsEnemy(attacker) then return end

        if not e.headshot then return end

        if brute.misses[attacker] == nil or (API.GLOBALS.Curtime() - brute.last_miss < 0.06 and brute.misses[attacker] == 1) then
            if brute.hit_reverse[attacker] == nil then
                brute.hit_reverse[attacker] = true
            else
                brute.hit_reverse[attacker] = nil
            end
        end
    end

    API.CLIENT.Callback("bullet_impact", function(e)
        brute_impact(e)
    end)

    render.arrows = {}
    render.arrows.c_var ={
        lerp = 0,
        rerp = 0
    }
    function render.arrows:draw()
        if funcs.ui:table_contains(API.MENU.Get(gui.menu.indicator_settings),"\a646464FF Manual arrows") == true then
            local w, h = API.CLIENT.Screen()
            local r, g, b = API.MENU.Get(gui.menu.indicator_color)
            local realtime = API.GLOBALS.Realtime() % 3
            local distance = (w/2) / 210 * API.MENU.Get(gui.menu.manualarrow_distance)
            if API.ENT.LocalPlayer() == nil then
                return
            end
    
            if g_antiaim.direction.c_var.saved_dir == 90 or g_antiaim.direction.c_var.saved_dir == 110 then
                self.c_var.lerp = render:lerp(self.c_var.lerp,255,API.GLOBALS.Frametimes() * 12)
                self.c_var.rerp = render:lerp(self.c_var.rerp,0,API.GLOBALS.Frametimes() * 12)
            elseif g_antiaim.direction.c_var.saved_dir == -90 or g_antiaim.direction.c_var.saved_dir == -70 then
                self.c_var.rerp = render:lerp(self.c_var.rerp,255,API.GLOBALS.Frametimes() * 12)
                self.c_var.lerp = render:lerp(self.c_var.lerp,0,API.GLOBALS.Frametimes() * 12)
            else
                self.c_var.rerp = render:lerp(self.c_var.rerp,0,API.GLOBALS.Frametimes() * 12)
                self.c_var.lerp = render:lerp(self.c_var.lerp,0,API.GLOBALS.Frametimes() * 12)
            end
            local flag = "c"
            if API.MENU.Get(gui.menu.manualarrow_size) == "+" then
                flag = "+c"
            elseif API.MENU.Get(gui.menu.manualarrow_size) == "-" then
                flag = "c"
            end
            if API.MENU.Get(gui.menu.manualarrow_back) then
                API.RENDER.Text(w/2 + distance, h / 2 - 1, 60, 60, 60, 125, flag, 0, "❯")
                API.RENDER.Text(w/2 - distance, h / 2 - 1, 60, 60, 60, 125, flag, 0, "❮")
            end

            API.RENDER.Text(w/2 + distance, h / 2 - 1, r, g, b, self.c_var.lerp, flag, 0, "❯")
            API.RENDER.Text(w/2 - distance, h / 2 - 1, r, g, b, self.c_var.rerp, flag, 0, "❮")
            
        end

    end

    render.roll = {}

    render.roll.c_var = {
        roll_r = 0,
        roll_g = 0,
        roll_b = 0,
        roll_a = 0
    }
    function render.roll:draw()
        if funcs.ui:table_contains(API.MENU.Get(gui.menu.antiaim_settings),"\a646464FF Roll") == true and funcs.ui:table_contains(API.MENU.Get(gui.menu.main_list),"\a"..menu4.."             Extra antiaim settings") == true then
            if check_roll == true then
                -- 200,200,200,255
                self.c_var.roll_r = render:lerp(self.c_var.roll_r,200,API.GLOBALS.Frametimes() * 8)
                self.c_var.roll_g = render:lerp(self.c_var.roll_g,200,API.GLOBALS.Frametimes() * 8)
                self.c_var.roll_b = render:lerp(self.c_var.roll_b,200,API.GLOBALS.Frametimes() * 8)
                self.c_var.roll_a = render:lerp(self.c_var.roll_a,255,API.GLOBALS.Frametimes() * 8)
            elseif check_roll == false then
                self.c_var.roll_r = render:lerp(self.c_var.roll_r,255,API.GLOBALS.Frametimes() * 8)
                self.c_var.roll_g = render:lerp(self.c_var.roll_g,0,API.GLOBALS.Frametimes() * 8)
                self.c_var.roll_b = render:lerp(self.c_var.roll_b,50,API.GLOBALS.Frametimes() * 8)
                self.c_var.roll_a = render:lerp(self.c_var.roll_a,255,API.GLOBALS.Frametimes() * 8)
            end

            API.RENDER.Indicator(self.c_var.roll_r,self.c_var.roll_g,self.c_var.roll_b,self.c_var.roll_a,"ROLL")
        end
    end

    render.watermark = {}
    render.watermark.c_var = {
        alpha = 0,
        alpha2 = 0,
        back = 0,
        backa = 0,
        cur_alpha = 1,
        min_alpha = 0.2,
        max_alpha = 1,
        target_alpha = 0,
        speed = 0.12,

        --menu 

        MENU_ADD_X = 0,
        MENU_ALPHA = 0,
        OPEN_ALPHA = 0


    }

    local solus_render = (function()
        local solus_m = {};
        local RoundedRect = function(x, y, w, h, radius, r, g, b, a)
            API.RENDER.Rectangle(x + radius, y, w - radius * 2, radius, r, g, b, a)
            API.RENDER.Rectangle(x, y + radius, radius, h - radius * 2, r, g, b, a)
            API.RENDER.Rectangle(x + radius, y + h - radius, w - radius * 2, radius,
                            r, g, b, a)
            API.RENDER.Rectangle(x + w - radius, y + radius, radius, h - radius * 2,
                            r, g, b, a)
            API.RENDER.Rectangle(x + radius, y + radius, w - radius * 2,
                            h - radius * 2, r, g, b, a)
            API.RENDER.Circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
            API.RENDER.Circle(x + w - radius, y + radius, r, g, b, a, radius, 90, 0.25)
            API.RENDER.Circle(x + radius, y + h - radius, r, g, b, a, radius, 270,
                            0.25)
            API.RENDER.Circle(x + w - radius, y + h - radius, r, g, b, a, radius, 0,
                            0.25)
        end;
        local rounding = 4;
        local rad = rounding + 2;
        local n = 45;
        local o = 20;
        local FadedRoundedRect = function(x, y, w, h, radius, r, g, b, a, glow)
            local n = a / 255 * n;
            API.RENDER.Rectangle(x + radius, y, w - radius * 2, 1, r, g, b, a)
            API.RENDER.CircleOutline(x + radius, y + radius, r, g, b, a, radius, 180,
                                    0.25, 1)
            API.RENDER.CircleOutline(x + w - radius, y + radius, r, g, b, a, radius,
                                    270, 0.25, 1)
            API.RENDER.Gradient(x, y + radius, 1, h - radius * 2, r, g, b, a, r, g, b,
                            n, false)
            API.RENDER.Gradient(x + w - 1, y + radius, 1, h - radius * 2, r, g, b, a,
                            r, g, b, n, false)
            API.RENDER.CircleOutline(x + radius, y + h - radius, r, g, b, n, radius,
                                    90, 0.25, 1)
            API.RENDER.CircleOutline(x + w - radius, y + h - radius, r, g, b, n,
                                    radius, 0, 0.25, 1)
            API.RENDER.Rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, n)
                for radius = 4, glow do
                    local radius = radius / 2;
                    -- OutlineGlow(x - radius, y - radius, w + radius * 2,
                    --             h + radius * 2, radius, r, g, b, glow - radius * 2)
                end
            
        end;
        local HorizontalFadedRoundedRect = function(x, y, w, h, radius, r, g, b, a,
                                                    glow, r1, g1, b1)
            local n = a / 255 * n;
            API.RENDER.Rectangle(x, y + radius, 1, h - radius * 2, r, g, b, a)
            API.RENDER.CircleOutline(x + radius, y + radius, r, g, b, a, radius, 180,
                                    0.25, 1)
            API.RENDER.CircleOutline(x + radius, y + h - radius, r, g, b, a, radius,
                                    90, 0.25, 1)
            API.RENDER.Gradient(x + radius, y, w / 3.5 - radius * 2, 1, r, g, b, a, 0,
                            0, 0, n / 0, true)
            API.RENDER.Gradient(x + radius, y + h - 1, w / 3.5 - radius * 2, 1, r, g,
                            b, a, 0, 0, 0, n / 0, true)
            API.RENDER.Rectangle(x + radius, y + h - 1, w - radius * 2, 1, r1, g1, b1,
                            n)
            API.RENDER.Rectangle(x + radius, y, w - radius * 2, 1, r1, g1, b1, n)
            API.RENDER.CircleOutline(x + w - radius, y + radius, r1, g1, b1, n,
                                    radius, -90, 0.25, 1)
            API.RENDER.CircleOutline(x + w - radius, y + h - radius, r1, g1, b1, n,
                                    radius, 0, 0.25, 1)
            API.RENDER.Rectangle(x + w - 1, y + radius, 1, h - radius * 2, r1, g1, b1,
                            n)
                for radius = 4, glow do
                    local radius = radius / 2;
                    -- OutlineGlow(x - radius, y - radius, w + radius * 2,
                    --             h + radius * 2, radius, r1, g1, b1,
                    --             glow - radius * 2)
                end
            
        end;
        local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1,
                                        g1, b1)
            local glow_enabled
            local n = a / 255 * n;
            API.RENDER.Rectangle(x + radius, y, w - radius * 2, 1, r, g, b, n)
            API.RENDER.CircleOutline(x + radius, y + radius, r, g, b, n, radius, 180,
                                    0.25, 1)
            API.RENDER.CircleOutline(x + w - radius, y + radius, r, g, b, n, radius,
                                    270, 0.25, 1)
            API.RENDER.Rectangle(x, y + radius, 1, h - radius * 2, r, g, b, n)
            API.RENDER.Rectangle(x + w - 1, y + radius, 1, h - radius * 2, r, g, b, n)
            API.RENDER.CircleOutline(x + radius, y + h - radius, r, g, b, n, radius,
                                    90, 0.25, 1)
            API.RENDER.CircleOutline(x + w - radius, y + h - radius, r, g, b, n,
                                    radius, 0, 0.25, 1)
            API.RENDER.Rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, n)
            if API.MENU.Get(glow_enabled) then
                for radius = 4, glow do
                    local radius = radius / 2;
                    -- OutlineGlow(x - radius, y - radius, w + radius * 2,
                    --             h + radius * 2, radius, r1, g1, b1,
                    --             glow - radius * 2)
                end
            end
        end;
        solus_m.linear_interpolation = function(start, _end, time)
            return (_end - start) * time + start
        end
        solus_m.clamp = function(value, minimum, maximum)
            if minimum > maximum then
                return API.MATH.Min(API.MATH.Max(value, maximum), minimum)
            else
                return API.MATH.Min(API.MATH.Max(value, minimum), maximum)
            end
        end
        solus_m.lerp = function(start, _end, time)
            time = time or 0.005;
            time = solus_m.clamp(API.GLOBALS.Frametimes() * time * 175.0, 0.01, 1.0)
            local a = solus_m.linear_interpolation(start, _end, time)
            if _end == 0.0 and a < 0.01 and a > -0.01 then
                a = 0.0
            elseif _end == 1.0 and a < 1.01 and a > 0.99 then
                a = 1.0
            end
            return a
        end
        -- solus_m.outlined_glow = function(x, y, w, h, radius, r, g, b, a,glow)

        --     for radius = 4, glow do
        --         local radius = radius / 2;
        --         OutlineGlow(x - radius, y - radius, w + radius * 2,
        --                     h + radius * 2, radius, r, g, b,
        --                     glow - radius * 2)
        --     end
        -- end

        solus_m.container = function(x, y, w, h, r, g, b, a, alpha, fn)
            if a > 0 then
                --API.RENDER.Blur(x, y, w, h) 
            end

            RoundedRect(x, y, w, h, rounding, 17, 17, 17, a)
            FadedRoundedRect(x, y, w, h, rounding, r, g, b, alpha * 255, alpha * o)
            if not fn then return end
            fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
        end;
        solus_m.horizontal_container = function(x, y, w, h, r, g, b, a, alpha, r1,
                                                g1, b1, fn)
            if alpha * 255 > 0 then API.RENDER.Blur(x, y, w, h) end
            RoundedRect(x, y, w, h, rounding, 17, 17, 17, a)
            HorizontalFadedRoundedRect(x, y, w, h, rounding, r, g, b, alpha * 255,
                                    alpha * o, r1, g1, b1)
            if not fn then return end
            fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
        end;
        solus_m.container_glow = function(x, y, w, h, r, g, b, a, alpha, r1, g1, b1,
                                        fn)
            if alpha * 255 > 0 then API.RENDER.Blur(x, y, w, h) end
            RoundedRect(x, y, w, h, rounding, 17, 17, 17, a)
            FadedRoundedGlow(x, y, w, h, rounding, r, g, b, alpha * 255, alpha * o,
                            r1, g1, b1)
            if not fn then return end
            fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
        end;
        solus_m.measure_multitext = function(flags, _table)
            local a = 0;
            for b, c in API.ENV.Pairs(_table) do
                c.flags = c.flags or ''
                a = a + API.RENDER.Measure(c.flags, c.text)
            end
            return a
        end
        solus_m.multitext = function(x, y, _table)
            for a, b in API.ENV.Pairs(_table) do
                b.flags = b.flags or ''
                b.limit = b.limit or 0;
                b.color = b.color or {255, 255, 255, 255}
                b.color[4] = b.color[4] or 255;
                API.RENDER.Text(x, y, b.color[1], b.color[2], b.color[3], b.color[4],
                            b.flags, b.limit, b.text)
                x = x + API.RENDER.Measure(b.flags, b.text)
            end
        end
        return solus_m
    end)()



    render.watermark.clamp = function(v, min, max) local num = v; num = num < min and min or num; num = num > max and max or num; return num end

    function render.watermark:draw_menu()
        if funcs.ui:table_contains(API.MENU.Get(gui.menu.indicator_settings),"\a646464FF Watermark") == true then
            self.c_var.MENU_ALPHA = render:lerp(self.c_var.MENU_ALPHA,1,API.GLOBALS.Frametimes() * 8)
        else
            self.c_var.MENU_ALPHA = render:lerp(self.c_var.MENU_ALPHA,0,API.GLOBALS.Frametimes() * 8)
        end

        local r,g,b,a = API.MENU.Get(gui.menu.watermark_color)
        local red,green,blue,aye = API.MENU.Get(gui.menu.watermark_color2)

        local text = {
            -- {text = "     ",color = {255,255,255,255*self.c_var.OPEN_ALPHA},render = "-"},
            -- {text = "Plug",color = {r,g,b,255*self.c_var.OPEN_ALPHA},render = "-"}, -- Find me here
            -- {text = "Walk",color = {255,255,255,255*self.c_var.OPEN_ALPHA},render = "-"},
            -- {text = "  ",color = {255,255,255,255*self.c_var.OPEN_ALPHA},render = "-"},
            -- {text = API.STRING.Upper(status.build),color = {159,227,255,255*self.c_var.OPEN_ALPHA},render = "-"},
            {text = "@"..API.STRING.Upper(status.username),color = {r,g,b,self.c_var.OPEN_ALPHA},render = "-"},


        }

        local lua = solus_render.measure_multitext("-", text) -30
        local menu_open = API.MENU.IsOpen()
        local sx,sy = API.CLIENT.Screen()
        local w ,h = lua + 160,40
        local steamid64 = js.MyPersonaAPI.GetXuid()
        local avatar = libs.images.get_steam_avatar(steamid64)
        --local r,g,b,a = API.MENU.Get(gui.menu.watermark_color)

        if menu_open then
            -- API.RENDER.Blur((sx/2 - (w+3))+ w/2,8*self.c_var.MENU_ADD_X,w,h)

            self.c_var.OPEN_ALPHA = render:lerp(self.c_var.OPEN_ALPHA,1*self.c_var.MENU_ALPHA,API.GLOBALS.Frametimes() * 6)
            self.c_var.MENU_ADD_X = render:lerp(self.c_var.MENU_ADD_X,1,API.GLOBALS.Frametimes() * 12)
        else
            self.c_var.OPEN_ALPHA = render:lerp(self.c_var.OPEN_ALPHA,0,API.GLOBALS.Frametimes() * 6)
            self.c_var.MENU_ADD_X = render:lerp(self.c_var.MENU_ADD_X,0,API.GLOBALS.Frametimes() * 6)
        end

        if (self.c_var.cur_alpha < self.c_var.min_alpha + 0.02) then
            self.c_var.target_alpha = self.c_var.max_alpha
        elseif (self.c_var.cur_alpha > self.c_var.max_alpha - 0.02) then
            self.c_var.target_alpha = self.c_var.min_alpha
        end
        self.c_var.cur_alpha = self.c_var.cur_alpha + (self.c_var.target_alpha - self.c_var.cur_alpha)*self.c_var.speed*(API.GLOBALS.Frametime()*10)
        --solus_render.outlined_glow(sx/2 - (w+3) + w/2,8*self.c_var.MENU_ADD_X,w,h,8,r,g,b,255*self.c_var.OPEN_ALPHA,(30*self.c_var.cur_alpha)*self.c_var.OPEN_ALPHA)

        API.RENDER.Rectangles(sx/2 - (w+3) + w/2,API.MATH.Floor(8*self.c_var.MENU_ADD_X),w,h,25,25,25,a*self.c_var.OPEN_ALPHA,6)
        if  avatar ~= nil then
            avatar:draw(sx/2 - (w+3)+ w/2 + 7.5 ,API.MATH.Floor(8*self.c_var.MENU_ADD_X) + 7,25,25,255,255,255,255*self.c_var.OPEN_ALPHA,true,"f")
            API.RENDER.CircleOutline(sx/2 - (w+3) + w/2+ 19 ,8*self.c_var.MENU_ADD_X + 20,25,25,25,255*self.c_var.OPEN_ALPHA,17.9,360,1,4.5)

        end
        local svg = {
            32,
            32,
            '<svg width="554.4" height="649.6" version="1.1" viewBox="0 0 554.4 649.6" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><path d="m273.53 531.63-1.2395-1-9.3067-28.8-4.6424-12-9.818-24-17.748-35.2-8.6508-14.4-15.06-22.4-13.001-16.784-19.226-19.216-13.574-10.574-11.2-7.2366-9.0585-4.8934-13.342-5.418-12.169-3.7597 20.169-13.528 9.6-7.622 9.7313-10.168 5.9613-8.9982 4.6761-11.49 1.8536-10.644-.44579-8.4502-.44578-8.4502-4.2296-17.567-5.4146-16.362-3.4264-8.6192-3.4264-8.6192-11.531-23.496-7.5372-13.304-4.8378-8-12.086-19.2-21.358-31.75.61216-.61215 17.504 13.176 11.2 8.674 24 20.062 23.2 20.715 16.8 15.328 26.449 26.408 9.6565 10.4 16.766 20 7.9794 11.2 2.9747 4.5356 2.9746 4.5356v1.1609l-8.4-7.896-12.975-9.8364-20.234-13.684-10.792-5.4178-12.287-4.9044-2.8566-.53589-2.8566-.53591v.93244l4.1268 9.2456 4.7217 12.8 1.1757 6.7048 1.1757 6.7048-.006 12.99-2.3936 14.758-4.6527 11.712-8.0522 13.994-6.7765 8.3356-8.7112 9.0411.89866 1.4541 14.094 8.5536 12.8 9.9316 12.087 11.02 15.664 17.105 8.6992 10.895 11.805 16.8 11.046 17.6 9.4292 16.8 6.1129 11.2 2.6527 5.2h13.131l10.79-19.6 14.435-24 7.9316-12 9.7475-13.6 14.579-17.6 15.89-16.128 13.6-10.775 18.4-12.278.42665-.1792-10.184-10.541-9.981-14.573-6.3921-13.64-2.0371-8.1431-2.0371-8.1431-.062-18.4 2.1096-8 2.1096-8 7.2467-17.467-.73833-.73832-7.6613 1.8785-11.368 4.6767-11.832 6.6356-8.8 5.7196-20.8 15.067-9.2 8.9784v-1.4415l11.966-17.817 21.136-25.491 40.099-39.849 18.279-16.151 22.521-19.81 25.818-20.99 9.3822-7.2772 10.8-7.6632v.76582l-27.647 41.375-8.2699 13.6-9.9886 17.6-6.2336 12-7.3055 16-4.6248 12-2.6501 8-2.6501 8-1.3152 4.4709-1.3152 4.4709-1.1951 7.9291-1.1951 7.9291-.005 5.9345-.005 5.9345 1.8287 10.531 5.3676 11.792 3.5177 4.9042 3.5177 4.9042 13.368 12.954 23.735 15.578-.40504.40505-.40504.40504-18.925 6.3179-14.174 7.2282-10.16 6.1725-12.466 9.3149-16.602 16.025-13.127 16-11.902 16-9.0454 14.4-11.38 20-15.733 32-3.6731 8.8-3.6731 8.8-5.4866 14.4-6.3764 19.2-3.4474 11.6h-2.8481l-1.2396-1zm-39.27-181.47-3.0032-.70782-7.7678-3.9362-13.046-12.273-9.6518-12.809.37408-.37406.37407-.37407 9.3241 2.0225 13.355 6.9654 9.2924 6.3104 4.9404 5.9936 1.3228 4.0254 1.3228 4.0253.36908 1 .36906 1-4.5712-.1608zm75.805-1.7315.52931-2.6.73607-2.8922.73608-2.8922 7.5964-7.1049 10.259-6.012 10.541-4.8537 8.6625-3.0491.27134.27135.27136.27134-12.746 16.847-8.8057 8.0479-7.4467 4.162-8.097 2.4046h-3.0367z" stroke-width=".8" fill="#ffffff"/></svg>',
        }
        local bmp = {
            32,
            32,
            '<svg width="554.4" height="649.6" version="1.1" viewBox="0 0 554.4 649.6" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><path d="m273.53 531.63-1.2395-1-9.3067-28.8-4.6424-12-9.818-24-17.748-35.2-8.6508-14.4-15.06-22.4-13.001-16.784-19.226-19.216-13.574-10.574-11.2-7.2366-9.0585-4.8934-13.342-5.418-12.169-3.7597 20.169-13.528 9.6-7.622 9.7313-10.168 5.9613-8.9982 4.6761-11.49 1.8536-10.644-.44579-8.4502-.44578-8.4502-4.2296-17.567-5.4146-16.362-3.4264-8.6192-3.4264-8.6192-11.531-23.496-7.5372-13.304-4.8378-8-12.086-19.2-21.358-31.75.61216-.61215 17.504 13.176 11.2 8.674 24 20.062 23.2 20.715 16.8 15.328 26.449 26.408 9.6565 10.4 16.766 20 7.9794 11.2 2.9747 4.5356 2.9746 4.5356v1.1609l-8.4-7.896-12.975-9.8364-20.234-13.684-10.792-5.4178-12.287-4.9044-2.8566-.53589-2.8566-.53591v.93244l4.1268 9.2456 4.7217 12.8 1.1757 6.7048 1.1757 6.7048-.006 12.99-2.3936 14.758-4.6527 11.712-8.0522 13.994-6.7765 8.3356-8.7112 9.0411.89866 1.4541 14.094 8.5536 12.8 9.9316 12.087 11.02 15.664 17.105 8.6992 10.895 11.805 16.8 11.046 17.6 9.4292 16.8 6.1129 11.2 2.6527 5.2h13.131l10.79-19.6 14.435-24 7.9316-12 9.7475-13.6 14.579-17.6 15.89-16.128 13.6-10.775 18.4-12.278.42665-.1792-10.184-10.541-9.981-14.573-6.3921-13.64-2.0371-8.1431-2.0371-8.1431-.062-18.4 2.1096-8 2.1096-8 7.2467-17.467-.73833-.73832-7.6613 1.8785-11.368 4.6767-11.832 6.6356-8.8 5.7196-20.8 15.067-9.2 8.9784v-1.4415l11.966-17.817 21.136-25.491 40.099-39.849 18.279-16.151 22.521-19.81 25.818-20.99 9.3822-7.2772 10.8-7.6632v.76582l-27.647 41.375-8.2699 13.6-9.9886 17.6-6.2336 12-7.3055 16-4.6248 12-2.6501 8-2.6501 8-1.3152 4.4709-1.3152 4.4709-1.1951 7.9291-1.1951 7.9291-.005 5.9345-.005 5.9345 1.8287 10.531 5.3676 11.792 3.5177 4.9042 3.5177 4.9042 13.368 12.954 23.735 15.578-.40504.40505-.40504.40504-18.925 6.3179-14.174 7.2282-10.16 6.1725-12.466 9.3149-16.602 16.025-13.127 16-11.902 16-9.0454 14.4-11.38 20-15.733 32-3.6731 8.8-3.6731 8.8-5.4866 14.4-6.3764 19.2-3.4474 11.6h-2.8481l-1.2396-1zm-39.27-181.47-3.0032-.70782-7.7678-3.9362-13.046-12.273-9.6518-12.809.37408-.37406.37407-.37407 9.3241 2.0225 13.355 6.9654 9.2924 6.3104 4.9404 5.9936 1.3228 4.0254 1.3228 4.0253.36908 1 .36906 1-4.5712-.1608zm75.805-1.7315.52931-2.6.73607-2.8922.73608-2.8922 7.5964-7.1049 10.259-6.012 10.541-4.8537 8.6625-3.0491.27134.27135.27136.27134-12.746 16.847-8.8057 8.0479-7.4467 4.162-8.097 2.4046h-3.0367z" stroke-width=".8" fill="#ffffff"/></svg>',
        }
        local svgx, svgy = 20, 20
        local svg = API.RENDER.Svg(svg[3], svgx , svgy )
        local svgdos = API.RENDER.Svg(bmp[3], 128 , 128 )

        API.RENDER.Texture(svg,(sx/2- (w)+ w/2 +1 ) + 35 ,8*self.c_var.MENU_ADD_X,svgx ,svgy ,r,g,b,a*self.c_var.OPEN_ALPHA )
        API.RENDER.Texture(svgdos,(sx/2- 30 - (w)+ w/2 ) + 87 ,sy*self.c_var.OPEN_ALPHA/2 -170,128 ,128 ,255,255,255,255*self.c_var.OPEN_ALPHA )
        API.RENDER.Texture(svgdos,(sx/2- 30 - (w)+ w/2 ) + 90 ,sy*self.c_var.OPEN_ALPHA/2-170,128 ,128 ,r,g,b,a*self.c_var.OPEN_ALPHA )
        solus_render.multitext((sx/2 - (w+3)+ w/2 ) + 46, 8*self.c_var.MENU_ADD_X+5, text)
        local username = gradient_text(red,green,blue,255*self.c_var.OPEN_ALPHA,r,g,b,255*self.c_var.OPEN_ALPHA,"@"..status.username)
        API.RENDER.Text((sx/2 - (w+3)+ w/2 ) + 39 ,8*self.c_var.MENU_ADD_X+20,255,255,255,255*self.c_var.OPEN_ALPHA,"b",0,username)
        local plug = gradient_text(red,green,blue,255*self.c_var.OPEN_ALPHA,r,g,b,255*self.c_var.OPEN_ALPHA,"Plug")
        local walk = gradient_text(red,green,blue,255*self.c_var.OPEN_ALPHA,r,g,b,255*self.c_var.OPEN_ALPHA,"Walk")
        local build2 = gradient_text(red,green,blue,255*self.c_var.OPEN_ALPHA,r,g,b,255*self.c_var.OPEN_ALPHA,status.build)
        API.RENDER.Text((sx/2 - (w)+ w/2 ) + 60 ,8*self.c_var.MENU_ADD_X+4,r,g,b,255*self.c_var.OPEN_ALPHA,"b",0,plug)
        API.RENDER.Text((sx/2 + 20 - (w)+ w/2 ) + 60 ,sy*self.c_var.MENU_ADD_X/2-50,r,g,b,255*self.c_var.OPEN_ALPHA,"+",0,plug)
        API.RENDER.Text((sx/2 + 65 - (w)+ w/2 ) + 60 ,sy*self.c_var.MENU_ADD_X/2-50,r,g,b,255*self.c_var.OPEN_ALPHA,"+",0,walk)
        API.RENDER.Text((sx/2 + 65 - (w)+ w/2 ) + 60 ,sy*self.c_var.MENU_ADD_X/2-15,r,g,b,255*self.c_var.OPEN_ALPHA,"+c",0,build2)
        API.RENDER.Text((sx/2 - (w)+ w/2 ) + 84 ,8*self.c_var.MENU_ADD_X+4,255,255,255,255*self.c_var.OPEN_ALPHA,"b",0,walk)
        API.RENDER.Text((sx/2 - (w)+ w/2 ) + 110 ,8*self.c_var.MENU_ADD_X+4,255,255,255,255*self.c_var.OPEN_ALPHA,"b",0,build2)

    end

    render.menu_effect = {}

    render.menu_effect.c_var = {
        alpha = 0,
        height = 0,
        cur_alpha = 200,
        min_alpha = 75,
        max_alpha = 200,
        target_alpha = 0,
        speed = 0.08,
        last_change = API.GLOBALS.Realtime() - 1,

        dots_alpha = 0,
        key_last_press = 0
    }

    local function distance(x1, y1, x2, y2)
        return API.MATH.Sqrt((x2-x1)^2 + (y2-y1)^2)
    end
    local dots = {}
    local dot_size = 3
    local menu_hotkey_reference = API.MENU.Reference("MISC", "Settings", "Menu key")
    local menu_open_prev = true
    local key_pressed_prev = false
    function render.menu_effect:draw()
        if funcs.ui:table_contains(API.MENU.Get(gui.menu.indicator_settings),"\a646464FF Menu effect") then
            
            if (self.c_var.cur_alpha < self.c_var.min_alpha + 2) then
                self.c_var.target_alpha = self.c_var.max_alpha
            elseif (self.c_var.cur_alpha > self.c_var.max_alpha - 2) then
                self.c_var.target_alpha = self.c_var.min_alpha
            end
            self.c_var.cur_alpha = self.c_var.cur_alpha + (self.c_var.target_alpha - self.c_var.cur_alpha)*self.c_var.speed*(API.GLOBALS.Frametime()*10)
            local SCR = {API.CLIENT.Screen()}
            local x,y = API.CLIENT.Screen()
            local r,g,b,a = API.MENU.Get(gui.menu.indicator_color)

            if API.MENU.IsOpen() then
                self.c_var.alpha = render:lerp(self.c_var.alpha, self.c_var.cur_alpha,API.GLOBALS.Frametimes() * 3.5)
                self.c_var.height = render:lerp(self.c_var.height,0,API.GLOBALS.Frametimes() * 3.5)
                API.RENDER.Blur(0,0, x,y)

            else
                self.c_var.height = render:lerp(self.c_var.height,600,API.GLOBALS.Frametimes() * 3.5)
                self.c_var.alpha = render:lerp(self.c_var.alpha,0,API.GLOBALS.Frametimes() * 3.5)
                self.c_var.height = render:lerp(self.c_var.height,0,API.GLOBALS.Frametimes() * 3.5)
            end
            API.RENDER.Gradient(0,0,SCR[1],600 -self.c_var.height ,r,g,b,self.c_var.alpha,r,g,b,0,false)
            
            local menu_open = API.MENU.IsOpen()
            local realtime = API.GLOBALS.Realtime()
            if menu_open and not menu_open_prev then
                self.c_var.last_change = realtime
            end
        
            
            if not menu_open then
                return
            end
        
            local key_pressed = API.MENU.Get(menu_hotkey_reference)
            if key_pressed and not key_pressed_prev then
                self.c_var.key_last_press = realtime
            end
            key_pressed_prev = key_pressed
        
            local opacity_multiplier = menu_open and 1 or 0
        
            local menu_fade_time = 0.2
        
            if realtime - self.c_var.last_change < menu_fade_time then
                opacity_multiplier = (realtime - self.c_var.last_change) / menu_fade_time
            elseif realtime - self.c_var.key_last_press < menu_fade_time then
                opacity_multiplier = (realtime - self.c_var.key_last_press) / menu_fade_time
                opacity_multiplier = 1 - opacity_multiplier
            end
        
            if opacity_multiplier ~= 1 then
                --client.log(opacity_multiplier)
            end

            local screen_width, screen_height = API.CLIENT.Screen()

            
            --@credit to sapphyrus 
            if opacity_multiplier > 0 then

                local r, g, b, a = 255,255,255,self.c_var.alpha
                a = a * opacity_multiplier
                local r_connect, g_connect, b_connect, a_connect = 255,255,255,self.c_var.alpha
                a_connect = a_connect * opacity_multiplier * 0.5
                local speed_multiplier = 61 / 100
                local dots_amount = 23
                local dots_connect_distance = 307
                local line_a = a/4
                while #dots > dots_amount do
                    API.TABLE.Remove(dots, #dots)
                end
                while #dots < dots_amount do
                    local x, y = API.CLIENT.Random(-dots_connect_distance, screen_width+dots_connect_distance), API.CLIENT.Random(-dots_connect_distance, screen_height+dots_connect_distance)
                    local max = 12
                    local min = 4

                    local velocity_x
                    if API.CLIENT.Random(0, 1) == 1 then
                        velocity_x = API.CLIENT.Randomfloat(-max, -min)
                    else
                        velocity_x = API.CLIENT.Randomfloat(min, max)
                    end

                    local velocity_y
                    if API.CLIENT.Random(0, 1) == 1 then
                        velocity_y = API.CLIENT.Randomfloat(-max, -min)
                    else
                        velocity_y = API.CLIENT.Randomfloat(min, max)
                    end

                    local size = API.CLIENT.Randomfloat(dot_size-1, dot_size+1)
                    API.TABLE.Insert(dots, {x, y, velocity_x, velocity_y, size})
                end

                local dots_new = {}
                for i=1, #dots do
                    local dot = dots[i]
                    local x, y, velocity_x, velocity_y, size = dot[1], dot[2], dot[3], dot[4], dot[5]
                    x = x + velocity_x*speed_multiplier*0.2
                    y = y + velocity_y*speed_multiplier*0.2
                    if x > -dots_connect_distance and x < screen_width+dots_connect_distance and y > -dots_connect_distance and y < screen_height+dots_connect_distance then
                        API.TABLE.Insert(dots_new, {x, y, velocity_x, velocity_y, size})
                    end
                end
                dots = dots_new

                for i=1, #dots do
                    local dot = dots[i]
                    local x, y, velocity_x, velocity_y, size = dot[1], dot[2], dot[3], dot[4], dot[5]
                    for i2=1, #dots do
                        local dot2 = dots[i2]
                        local x2, y2 = dot2[1], dot2[2]
                        local distance = distance(x, y, x2, y2)
                        if distance <= dots_connect_distance then
                            local a_connect_multiplier = 1
                            if distance > dots_connect_distance * 0.7 then
                                a_connect_multiplier = (dots_connect_distance - distance) / (dots_connect_distance * 0.3)
                                --distance - dots_connect_distance / 
                            end
                            API.CLIENT.Drawline(case.ctx, x, y, x2, y2, r_connect, g_connect, b_connect, a_connect*a_connect_multiplier)
                        end
                    end
                end

                for i=1, #dots do
                    local dot = dots[i]
                    local x, y, velocity_x, velocity_y, size = dot[1], dot[2], dot[3], dot[4], dot[5]
                    API.CLIENT.Drawline(case.ctx, x, y, r, g, b, a, size, 0, 1, 1)
                end
            end

        
        end

    
    end

    render.notifications = {}
    render.notifications.table_text = {}
    render.notifications.c_var = {
        screen = {API.CLIENT.Screen()},

    }

    local animate = (function()
        local anim = {}

        local lerp = function(start, vend)
            return start + (vend - start) * (globals.frametime() * 6)
        end

        local lerp_notify = function(start, vend)
            return start + (vend - start) * (globals.frametime() * 8)
        end

        anim.new_notify = function(value, startpos, endpos, condition)
            if condition ~= nil then
                if condition then
                    return lerp_notify(value,startpos)
                else
                    return lerp_notify(value,endpos)
                end
            else
                return lerp_notify(value,startpos)
            end
        end

        anim.new = function(value, startpos, endpos, condition)
            if condition ~= nil then
                if condition then
                    return lerp(value,startpos)
                else
                    return lerp(value,endpos)
                end
            else
                return lerp(value,startpos)
            end
        end

        anim.color_lerp = function(color, color2, end_value, condition)
            if condition ~= nil then
                if condition then
                    color.r = lerp(color.r,color2.r)
                    color.g = lerp(color.g,color2.g)
                    color.b = lerp(color.b,color2.b)
                    color.a = lerp(color.a,color2.a)
                else
                    color.r = lerp(color.r,end_value.r)
                    color.g = lerp(color.g,end_value.g)
                    color.b = lerp(color.b,end_value.b)
                    color.a = lerp(color.a,end_value.a)
                end
            else
                color.r = lerp(color.r,color2.r)
                color.g = lerp(color.g,color2.g)
                color.b = lerp(color.b,color2.b)
                color.a = lerp(color.a,color2.a)
            end
            return { r = color.r , g = color.g , b = color.b , a = color.a }
        end

        anim.adapting = function(cur, min, max, target, step, speed)
            local step = step or 1
            local speed = speed or 0.1
    
            if cur < min + step then
                target = max
            elseif cur > max - step then
                target = min
            end
            return cur + (target - cur) * speed * (globals.absoluteframetime() * 10)
        end
        return anim
    end)()

    gradient_text = function(r1, g1, b1, a1, r2, g2, b2, a2, m)
        local output = ''
        local len = #m
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len
    
        for i=1, len do
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, m:sub(i, i))
            r1 = r1 + rinc
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc
        end
        return output
    end
    
    local screen = {client.screen_size()}
    local x_offset, y_offset = screen[1], screen[2]
    local x, y =  x_offset/2,y_offset/2 

    local visuals = {}

    visuals = {

        ['stored'] = {
            ['script_load'] = {
                ['start'] = globals.realtime(),
                ['show'] = false,
                ['alpha'] = 0
            },
            ['crosshair'] = {
                ['alpha'] = 0,
                ['scoped'] = 0,
                ['values'] = {0, 0, 0, 0, 0, 0},
                ['doubletap_color'] = {r = 0 , g = 0 , b = 0 , a = 0},
                ['default_dt'] = {r = 0, g = 0, b = 0, a = 0},
                ['modern'] = {speed = 1, text_alpha = 0, text_alpha2 = 0, color = {r = 0 , g = 0 , b = 0 , a = 0}},
                ['fake_anim'] = 0
            },
            ['user_count'] = {
                ['alpha'] = 0,
                ['offset'] = 0
            },
        },

        script_load = function()
            local v = visuals['stored']['script_load']
            v['alpha'] = animate.new(v['alpha'],1,0,not v['show'])
            local svg_300 = '<svg width="554.4" height="649.6" version="1.1" viewBox="0 0 554.4 649.6" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><path d="m273.53 531.63-1.2395-1-9.3067-28.8-4.6424-12-9.818-24-17.748-35.2-8.6508-14.4-15.06-22.4-13.001-16.784-19.226-19.216-13.574-10.574-11.2-7.2366-9.0585-4.8934-13.342-5.418-12.169-3.7597 20.169-13.528 9.6-7.622 9.7313-10.168 5.9613-8.9982 4.6761-11.49 1.8536-10.644-.44579-8.4502-.44578-8.4502-4.2296-17.567-5.4146-16.362-3.4264-8.6192-3.4264-8.6192-11.531-23.496-7.5372-13.304-4.8378-8-12.086-19.2-21.358-31.75.61216-.61215 17.504 13.176 11.2 8.674 24 20.062 23.2 20.715 16.8 15.328 26.449 26.408 9.6565 10.4 16.766 20 7.9794 11.2 2.9747 4.5356 2.9746 4.5356v1.1609l-8.4-7.896-12.975-9.8364-20.234-13.684-10.792-5.4178-12.287-4.9044-2.8566-.53589-2.8566-.53591v.93244l4.1268 9.2456 4.7217 12.8 1.1757 6.7048 1.1757 6.7048-.006 12.99-2.3936 14.758-4.6527 11.712-8.0522 13.994-6.7765 8.3356-8.7112 9.0411.89866 1.4541 14.094 8.5536 12.8 9.9316 12.087 11.02 15.664 17.105 8.6992 10.895 11.805 16.8 11.046 17.6 9.4292 16.8 6.1129 11.2 2.6527 5.2h13.131l10.79-19.6 14.435-24 7.9316-12 9.7475-13.6 14.579-17.6 15.89-16.128 13.6-10.775 18.4-12.278.42665-.1792-10.184-10.541-9.981-14.573-6.3921-13.64-2.0371-8.1431-2.0371-8.1431-.062-18.4 2.1096-8 2.1096-8 7.2467-17.467-.73833-.73832-7.6613 1.8785-11.368 4.6767-11.832 6.6356-8.8 5.7196-20.8 15.067-9.2 8.9784v-1.4415l11.966-17.817 21.136-25.491 40.099-39.849 18.279-16.151 22.521-19.81 25.818-20.99 9.3822-7.2772 10.8-7.6632v.76582l-27.647 41.375-8.2699 13.6-9.9886 17.6-6.2336 12-7.3055 16-4.6248 12-2.6501 8-2.6501 8-1.3152 4.4709-1.3152 4.4709-1.1951 7.9291-1.1951 7.9291-.005 5.9345-.005 5.9345 1.8287 10.531 5.3676 11.792 3.5177 4.9042 3.5177 4.9042 13.368 12.954 23.735 15.578-.40504.40505-.40504.40504-18.925 6.3179-14.174 7.2282-10.16 6.1725-12.466 9.3149-16.602 16.025-13.127 16-11.902 16-9.0454 14.4-11.38 20-15.733 32-3.6731 8.8-3.6731 8.8-5.4866 14.4-6.3764 19.2-3.4474 11.6h-2.8481l-1.2396-1zm-39.27-181.47-3.0032-.70782-7.7678-3.9362-13.046-12.273-9.6518-12.809.37408-.37406.37407-.37407 9.3241 2.0225 13.355 6.9654 9.2924 6.3104 4.9404 5.9936 1.3228 4.0254 1.3228 4.0253.36908 1 .36906 1-4.5712-.1608zm75.805-1.7315.52931-2.6.73607-2.8922.73608-2.8922 7.5964-7.1049 10.259-6.012 10.541-4.8537 8.6625-3.0491.27134.27135.27136.27134-12.746 16.847-8.8057 8.0479-7.4467 4.162-8.097 2.4046h-3.0367z" stroke-width=".8" fill="#ffffff"/></svg>'
            local svg = renderer.load_svg(svg_300, 300 , 300 )
            local text = gradient_text(115, 154, 255,255 * v['alpha'] + 0.5,128,128,240,255 * v['alpha'] + 0.5, "P l u g W a l k")
            local text_sizex, text_sizey = renderer.measure_text("+",text)

            renderer.blur(0, 0, x_offset * v['alpha'], y_offset * v['alpha'])
            renderer.rectangle(0, 0, x_offset, y_offset, 10, 10, 10, 150*v['alpha'])
            renderer.texture(svg, x - (312/2 + 7) * v['alpha'] + 15, y + (800/3 - 100) * v['alpha'] - 300, 300 * v['alpha'], 300 * v['alpha'], 128, 128, 240, math.floor(255 * v['alpha']), "f")
            renderer.text(x -text_sizex/2 + 4, y + 70 + (40 * v['alpha']),255,255,255,255* v['alpha'],"+",0,text)
            renderer.gradient(x -text_sizex/2 + 4, y + 100 + ( 40 *  v['alpha']) ,text_sizex * v['alpha'],3,115, 154, 255,255 ,128,128,240, math.floor(255 * v['alpha']),true)
            if v['start'] + 10 < globals.realtime() then
                v['start'] = globals.realtime()
                v['show'] = true
            end
        end,
    }
    API.TABLE.Insert(render.notifications.table_text, {
        text = "\aFFFFFFC8Welcome! \a96C83BFF"..status.username.."\aFFFFFFC8 Build: \a9FE3FFFF"..status.build.."\aFFFFFFC8 Last update time: "..status.last_updatetime,
        timer = API.GLOBALS.Realtime(),

        smooth_y = render.notifications.c_var.screen[2] + 100,
        alpha = 0,
        alpha2 = 0,
        alpha3 = 0,


        box_left = API.RENDER.Measure(nil,"\aFFFFFFC8Welcome! \a96C83BFF"..status.username.."\aFFFFFFC8 Build: \a9FE3FFFF"..status.build.."\aFFFFFFC8 Last update time: "..status.last_updatetime),
        box_right = API.RENDER.Measure(nil,"\aFFFFFFC8Welcome! \a96C83BFF"..status.username.."\aFFFFFFC8 Build: \a9FE3FFFF"..status.build.."\aFFFFFFC8 Last update time: "..status.last_updatetime),

        box_left_1 = 0,
        box_right_1 = 0
    })   

    local function noti()
        local y = render.notifications.c_var.screen[2] - 100

        
        for i, info in API.ENV.Ipairs(render.notifications.table_text) do
            if i > 5 then
                API.TABLE.Remove(render.notifications.table_text,i)
            end
            if info.text ~= nil and info ~= "" then
                local text_size = {API.RENDER.Measure(nil,info.text)}
                local r,g,b,a = API.MENU.Get(gui.menu.watermark_color)
                if info.timer + 3.8 < API.GLOBALS.Realtime() then
        
                    info.box_left = render:lerp(info.box_left,text_size[1],API.GLOBALS.Frametimes() * 1)
                    info.box_right = render:lerp(info.box_right,text_size[1],API.GLOBALS.Frametimes() * 1)
                    info.box_left_1 = render:lerp(info.box_left_1,0,API.GLOBALS.Frametimes() * 1)
                    info.box_right_1 = render:lerp(info.box_right_1,0 ,API.GLOBALS.Frametimes() * 1)
                    info.smooth_y = render:lerp(info.smooth_y,render.notifications.c_var.screen[2] + 100,API.GLOBALS.Frametimes() * 2)
                    info.alpha = render:lerp(info.alpha,0,API.GLOBALS.Frametimes() * 4)
                    info.alpha2 = render:lerp(info.alpha2,0,API.GLOBALS.Frametimes() * 4)
                    info.alpha3 = render:lerp(info.alpha3,0,API.GLOBALS.Frametimes() * 4)


                else
                    info.alpha = render:lerp(info.alpha,a,API.GLOBALS.Frametimes() * 4)
                    info.alpha2 = render:lerp(info.alpha2,1,API.GLOBALS.Frametimes() * 4)
                    info.alpha3 = render:lerp(info.alpha3,255,API.GLOBALS.Frametimes() * 4)

                    info.smooth_y = render:lerp(info.smooth_y,y,API.GLOBALS.Frametimes() * 2)
                
                    info.box_left = render:lerp(info.box_left,text_size[1] - text_size[1] /2 -2,API.GLOBALS.Frametimes() * 1)
                    info.box_right = render:lerp(info.box_right,text_size[1]  - text_size[1] /2 +4,API.GLOBALS.Frametimes() * 1)
                    info.box_left_1 = render:lerp(info.box_left_1,text_size[1] +13,API.GLOBALS.Frametimes() * 2)
                    info.box_right_1 = render:lerp(info.box_right_1,text_size[1] +14 ,API.GLOBALS.Frametimes() * 2)
                end

                local add_y = API.MATH.Floor(info.smooth_y)
                local alpha = info.alpha
                local alpha2 = info.alpha2
                local alpha3 = info.alpha3

                local left_box = API.MATH.Floor(info.box_left)
                local right_box = API.MATH.Floor(info.box_right)
                local left_box_1 = API.MATH.Floor(info.box_left_1)
                local right_box_1 = API.MATH.Floor(info.box_right_1)

                solus_render.container(render.notifications.c_var.screen[1] / 2 - text_size[1] / 2 - 4 + 5,add_y - 21,text_size[1] +8 + 4 - 7 + 4 + 14 ,text_size[2] + 7 ,r,g,b,alpha,alpha2 )


                local svg = {
                    32,
                    32,
                    '<svg width="554.4" height="649.6" version="1.1" viewBox="0 0 554.4 649.6" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><path d="m273.53 531.63-1.2395-1-9.3067-28.8-4.6424-12-9.818-24-17.748-35.2-8.6508-14.4-15.06-22.4-13.001-16.784-19.226-19.216-13.574-10.574-11.2-7.2366-9.0585-4.8934-13.342-5.418-12.169-3.7597 20.169-13.528 9.6-7.622 9.7313-10.168 5.9613-8.9982 4.6761-11.49 1.8536-10.644-.44579-8.4502-.44578-8.4502-4.2296-17.567-5.4146-16.362-3.4264-8.6192-3.4264-8.6192-11.531-23.496-7.5372-13.304-4.8378-8-12.086-19.2-21.358-31.75.61216-.61215 17.504 13.176 11.2 8.674 24 20.062 23.2 20.715 16.8 15.328 26.449 26.408 9.6565 10.4 16.766 20 7.9794 11.2 2.9747 4.5356 2.9746 4.5356v1.1609l-8.4-7.896-12.975-9.8364-20.234-13.684-10.792-5.4178-12.287-4.9044-2.8566-.53589-2.8566-.53591v.93244l4.1268 9.2456 4.7217 12.8 1.1757 6.7048 1.1757 6.7048-.006 12.99-2.3936 14.758-4.6527 11.712-8.0522 13.994-6.7765 8.3356-8.7112 9.0411.89866 1.4541 14.094 8.5536 12.8 9.9316 12.087 11.02 15.664 17.105 8.6992 10.895 11.805 16.8 11.046 17.6 9.4292 16.8 6.1129 11.2 2.6527 5.2h13.131l10.79-19.6 14.435-24 7.9316-12 9.7475-13.6 14.579-17.6 15.89-16.128 13.6-10.775 18.4-12.278.42665-.1792-10.184-10.541-9.981-14.573-6.3921-13.64-2.0371-8.1431-2.0371-8.1431-.062-18.4 2.1096-8 2.1096-8 7.2467-17.467-.73833-.73832-7.6613 1.8785-11.368 4.6767-11.832 6.6356-8.8 5.7196-20.8 15.067-9.2 8.9784v-1.4415l11.966-17.817 21.136-25.491 40.099-39.849 18.279-16.151 22.521-19.81 25.818-20.99 9.3822-7.2772 10.8-7.6632v.76582l-27.647 41.375-8.2699 13.6-9.9886 17.6-6.2336 12-7.3055 16-4.6248 12-2.6501 8-2.6501 8-1.3152 4.4709-1.3152 4.4709-1.1951 7.9291-1.1951 7.9291-.005 5.9345-.005 5.9345 1.8287 10.531 5.3676 11.792 3.5177 4.9042 3.5177 4.9042 13.368 12.954 23.735 15.578-.40504.40505-.40504.40504-18.925 6.3179-14.174 7.2282-10.16 6.1725-12.466 9.3149-16.602 16.025-13.127 16-11.902 16-9.0454 14.4-11.38 20-15.733 32-3.6731 8.8-3.6731 8.8-5.4866 14.4-6.3764 19.2-3.4474 11.6h-2.8481l-1.2396-1zm-39.27-181.47-3.0032-.70782-7.7678-3.9362-13.046-12.273-9.6518-12.809.37408-.37406.37407-.37407 9.3241 2.0225 13.355 6.9654 9.2924 6.3104 4.9404 5.9936 1.3228 4.0254 1.3228 4.0253.36908 1 .36906 1-4.5712-.1608zm75.805-1.7315.52931-2.6.73607-2.8922.73608-2.8922 7.5964-7.1049 10.259-6.012 10.541-4.8537 8.6625-3.0491.27134.27135.27136.27134-12.746 16.847-8.8057 8.0479-7.4467 4.162-8.097 2.4046h-3.0367z" stroke-width=".8" fill="#ffffff"/></svg>',
                }
                local svg = API.RENDER.Svg(svg[3], 12 , 12 )

                API.RENDER.Texture(svg,render.notifications.c_var.screen[1] / 2 - text_size[1] / 2  + 5,add_y - 19 + 1,12 ,12 ,r,g,b,alpha3)

                API.RENDER.Text(
                    render.notifications.c_var.screen[1] / 2 - text_size[1] / 2  + 5 + 14,add_y - 19 + 1,
                    r,g,b,alpha,nil,0,info.text
                )
        
                y = y - 30
                if info.timer + 4 < API.GLOBALS.Realtime() then
                    API.TABLE.Remove(render.notifications.table_text,i)
                end
            end
        end
        
    end

    render.esp = {}



    local r,g,b,a = API.MENU.Get(gui.menu.indicator_color)

    -- API.CLIENT.ESPFlag("LC",255,255,255, function(player)
    --     local current_threat = client.current_threat()
    --     return  current_threat == player and API.ENT.IsAlive(player) 
    -- end)

    function render:paint()
        
        if API.ENT.LocalPlayer() == nil or not API.ENT.IsAlive(API.ENT.LocalPlayer()) or API.MENU.Get(gui.menu.master_swtich) == false or funcs.ui:table_contains(API.MENU.Get(gui.menu.main_list),"\a"..menu1.."                       Indicators") == false then
            return
        end

        self.center:draw()
        self.arrows:draw()
        self.roll:draw()
        --self.watermark:draw()
    end

    local say2 = {"Get Good Get PlugWalk", "god i wish i had PlugWalk", "uwu *nuzzles*", "qt eliminated", "hey you're cool wanna go out?", "sorry for killing u.. hope you forgive me", "(づ｡◕‿‿◕｡)づ", "i love you!!!", "(✿ ♥‿♥)", "(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧", "★~(◠︿⊙✿)", "★~(◡ω◡✿)", "would you hold me tight the rest of your life? >.<", "no need to be wude to me", "i miss you alweady..", "it's not that i like you or anything >.>", "how was your day?", "would u like to hold hands? >.<", "you look soooo good today!!", " u wanna come with me to starbucks?", "you are soo lewd!! >.<", "u wanna cuddle? >.<", "u make me cwy! but i still love u!!!", "hi you're cool, wanna get bubble tea?"}
    local say  = {"blasted lachkick HAHAHAHAHAHAHAHA", ", sit nn dog HHHHHH", ", laff you suck HAHAHAHAHA", ", hhhhhhh 1 shot by the NNblaster", ", RESOLVED habibi $$$", ", e-dating tranny down HAHAHAHAHAHA", ", shamed by true legende $ lachi", ", go RQ noone needs you hhhhhhhhhhh", ", hhh you just got blasted by PlugWalk", ", HHHHHHHHHHHHHHHH nice 10 iq monkey with BOT playstyle", ", FEMBOY BLASTED HAHAHAHAHAHA", ", 1tap laff sit fucking dog", ", did you know that duke is a qt? well now u know. 1 btw hrsn newfag", " , covid joiner blasted hhhhhhhhh", " , genderconfused noname owned LMAO ", "no PlugWalk no talk d0g", " , thats a 1 on my screen ROFLCOPTER", " , imagine still no PlugWalk in 2022 LACHBOMBE", " , go fucking hang yourself hrsn gypsy", " , estrogen addict kys hhhhhhhh","1", "just go rq ur trash", "why r u so shit", "1 nn down", "kys ur so bad", "menu -> quit game pls", "skeetless nn raped", "raped dog", "1", "weak rat", "bow down to me nn", "rekt", "mad got killed? hhh", "sit down nn", "owNNed", "dude look at that kd", "1", "owned LOL!", "shithead raped", "nn deported back to hell", "1 1 1 1 1", "wow that's a 1", "get 1'd", "h$", "EZ BOTS", "why so ez bro?", "raped", "that's a 1", "1 on my screen", "kys", "Did you actually sell your anal virginity for that trash hack?", "$$$ OwNeD DeGeNeRaTe $$$", "yourpaste.cc/refund.php", "I thought trump is the biggest retard on earth but u are atleast 2 steps ahead", "YOU BETTER RAGEQUIT NOW HAHA", "shitted on", "is that the best you can do?", "get on my level retard", "honestly just quit hvh", "aptal noname", "headshot!!!", "katie stack better", "1 dog", "nice suicide peek, do it irl too pls", "get out of my game", "imagine being PlugWalkless in 2022", "1 on my screen", "thats going in my media compilation right there get shamed retard rofl",}

    local function trash_talk()
        if API.MENU.Get(gui.menu.trashtalk) == "\a646464FF Trash talk" then 
            local sendconsole = API.CLIENT.Exec
            local _first = say[API.MATH.Random(1, #say)]
            if _first ~= nil  then
                local say = 'say ' .._first
            sendconsole(say)
            end
        elseif API.MENU.Get(gui.menu.trashtalk) == "\a646464FF Wholesome Trash talk" then --find me API.MENU.Get(gui.menu.center_mode) == "Text with glow" then
            local sendconsole = API.CLIENT.Exec
            local _first = say2[API.MATH.Random(1, #say2)]
            if _first ~= nil  then
                local say2 = 'say ' .._first
            sendconsole(say2)
            end
        end
    end

    local function clan_tag()
            local strClantag = "PlugWalk"
            local active = {}
            local strPlaceholder = ""
            local strPrevious = ""
            local fltTime = API.GLOBALS.Curtime() + API.CLIENT.rLatency()
            local intStep = API.MATH.Floor((fltTime) / 0.5)
            local intLength = API.MATH.Abs(intStep % (#strClantag * 4) - #strClantag * 2)
            local intSeed = intStep - (intStep % (#strClantag))
            -- API.RENDER.Indicator(255, 255, 0, 255, intLength .. " | " .. intSeed)
            local strCurrent = strClantag
            if intLength > #strClantag * 1.5 then
                if intLength % 2 < 1 then
                    strCurrent = "(/._.)/"
                else
                    strCurrent = "\\(._.\\)"
                end
            elseif intLength < #strClantag then
                API.MATH.Randomseed(intSeed)
                local tblCurrent = {}
                for i = 1, #strClantag, 1 do
                    tblCurrent[i] = strPlaceholder
                end
                local tblLeft = {}
                for i = 1, #strClantag, 1 do
                    tblLeft[i] = {strClantag:sub(i, i), i}
                end
                for i = 1, intLength, 1 do
                    local strChar, intIndex = API.ENV.Unpack(API.TABLE.Remove(tblLeft, API.MATH.Random(#tblLeft)))
                    tblCurrent[intIndex] = strChar
                end
                strCurrent = API.TABLE.Concat(tblCurrent)
            end
            --API.RENDER.Indicator(255, 255, 0, 255, strCurrent)
            if strCurrent ~= strPrevious then
                API.CLIENT.Clantag(strCurrent)
                strPrevious = strCurrent
            end
        end

    local function expd()
        local str = ""
        for i,o in API.ENV.Pairs(gui.export['number']) do
            str = str .. API.ENV.Tostring(API.MENU.Get(o)) .. '|'
        end
        for i,o in API.ENV.Pairs(gui.export['string']) do
            str = str .. (API.MENU.Get(o)) .. '|'
        end
        for i,o in API.ENV.Pairs(gui.export['boolean']) do
            str = str .. API.ENV.Tostring(API.MENU.Get(o)) .. '|'
        end
        for i,o in API.ENV.Pairs(gui.export['table']) do
            str = str .. funcs.ui:arr_to_string(o) .. '|'
        end
        libs.clipboard.set(libs.base64.encode(str, 'base64'))
    end

    local function loadd()
        local tbl = funcs.ui:str_to_sub(libs.base64.decode(libs.clipboard.get(), 'base64'), "|")
        local p = 1
        for i,o in API.ENV.Pairs(gui.export['number']) do

            API.MENU.Set(o,API.ENV.Tonumber(tbl[p]))
            p = p + 1
        end
        for i,o in API.ENV.Pairs(gui.export['string']) do
            API.MENU.Set(o,tbl[p])
            p = p + 1
        end
        for i,o in API.ENV.Pairs(gui.export['boolean']) do
            API.MENU.Set(o,funcs.ui:to_boolean(tbl[p]))
            p = p + 1
        end
        for i,o in API.ENV.Pairs(gui.export['table']) do
            API.MENU.Set(o,funcs.ui:str_to_sub(tbl[p],','))
            p = p + 1
        end
    end



    local function default_config()
        libs.http.get("https://invi.duke.cat/lua.lua",function(success, response) 
            if not success or response.status ~= 200 then
            API.ENV.Error("[PlugWalk] Unable to connect to the server,check your internet")
            return
            end
            local tbl = funcs.ui:str_to_sub(libs.base64.decode(response.body, 'base64'), "|")
            local p = 1
            for i,o in API.ENV.Pairs(gui.export['number']) do
                API.MENU.Set(o,API.ENV.Tonumber(tbl[p]))
                p = p + 1
            end
            for i,o in API.ENV.Pairs(gui.export['string']) do
                API.MENU.Set(o,tbl[p])
                p = p + 1
            end
            for i,o in API.ENV.Pairs(gui.export['boolean']) do
                API.MENU.Set(o,funcs.ui:to_boolean(tbl[p]))
                p = p + 1
            end
            for i,o in API.ENV.Pairs(gui.export['table']) do
                API.MENU.Set(o,funcs.ui:str_to_sub(tbl[p],','))
                p = p + 1
            end
        end)
    end

    local draw_logs = function()
        funcs.misc.lua_msg("|--------------------------------------------------------|")
        funcs.misc.lua_msg("                       Welcome " .. name .. "!            ")
        funcs.misc.lua_msg("                   Be different start PlugWalkin          ")
        funcs.misc.lua_msg("                          ".. obex_data.build .."                      ")
        funcs.misc.lua_msg("|--------------------------------------------------------|")
    end


    local export = API.MENU.Button("CONFIG","LUA",'\a7BDAEAFF>>  \aFFFFFFC8Export config to clipboard',expd)
    local load = API.MENU.Button("CONFIG","LUA",'\a7BDAEAFF>>  \aFFFFFFC8Import config from clipboard',loadd)
    local load_default = API.MENU.Button("CONFIG","LUA",'\a7BDAEAFF>>  \aFFFFFFC8Load default config',default_config)
    local get_logs = API.MENU.Button("CONFIG","LUA",'\a7BDAEAFF>>  \aFFFFFFC8Get current build updatelog',draw_logs)

    local spacing_2 = main:ui(API.MENU.Label(gui.tab[1],gui.tab[2],"                                       "),false)


    function main:callback(event_name,function_name,state,final)
        if state then
            API.CLIENT.Callback(event_name,function_name)
        else
            if final ~= nil then final() end
            API.CLIENT.UnsetCallback(event_name,function_name)
        end
    end
    local check_callback = true
    function main:set_callback(name,func)
        if check_callback == true then
            API.MENU.Callback(name,func)
        elseif check_callback == false then
            funcs.misc.lua_msg("Invoke failed")
        end
    end

    local setup_command = function(cmd)
        case.self = main or self

        if  API.MENU.Get(antiaim.hide_shots[1]) and  API.MENU.Get(antiaim.hide_shots[2]) and not API.MENU.Get(antiaim.fakeduck) then
            API.MENU.Set(antiaim.fake_lag,false)
            API.MENU.Set(antiaim.fake_lag_limit,1)

            cmd.allow_send_packet = cmd.chokedcommands >= 1
        else
            API.MENU.Set(antiaim.fake_lag_limit,API.MENU.Get(gui.menu.fake_lag_limit_d))
            API.MENU.Set(antiaim.fake_lag,true)
        end

        g_antiaim:og_menu(false)

        g_antiaim:run_main(cmd)
    end

    local run_command = function(cmd)
        case.self = main or self
        g_antiaim.anti_knife:on_run_command()
    end

    local pre_render = function()
        case.self = main or self
        g_antiaim.pre_render:animation_breaker()
    end


    local player_death = function(e)
        case.self = main or self
        if API.CLIENT.UIDtoENT(e.userid) == API.ENT.LocalPlayer() then
            API.TABLE.Insert(render.notifications.table_text, {
                text = "\aFFFFFFC8Reseted data due to death",
                timer = API.GLOBALS.Realtime(),
            
                smooth_y = render.notifications.c_var.screen[2] + 100,
                alpha = 0,
                alpha2 = 0,
                alpha3 = 0,

                box_left = API.RENDER.Measure(nil,"\aFFFFFFC8Reseted data due to death"),
                box_right = API.RENDER.Measure(nil,"\aFFFFFFC8Reseted data due to death"),
            
                box_left_1 = 0,
                box_right_1 = 0
            })   
        end
    end

    local round_start = function()
        case.self = main or self
            API.TABLE.Insert(render.notifications.table_text, {
                text = "\aFFFFFFC8Reseted data due to round start",
                timer = API.GLOBALS.Realtime(),
            
                smooth_y = render.notifications.c_var.screen[2] + 100,
                alpha = 0,
                alpha2 = 0,
                alpha3 = 0,

                box_left = API.RENDER.Measure(nil,"\aFFFFFFC8Reseted data due to round start"),
                box_right = API.RENDER.Measure(nil,"\aFFFFFFC8Reseted data due to round start"),
            
                box_left_1 = 0,
                box_right_1 = 0
            })   
        
    end

    
    local aim_hit = function(e)
        local health = API.ENT.Prop(e.target, 'm_iHealth')
        if health == 0 then
        trash_talk()
        end
    end

    local paint = function()
        case.self = main or self

        render:paint()
    end

    local callbacks = {

    }



    local verify = function()
        render.menu_effect:draw()
        render.watermark:draw_menu()

    end



    function main:shutdown()
        g_antiaim:og_menu(true)
        API.MENU.Visible(antiaim.fake_lag_limit,true) 
    end



    local function itemiscool(item, relevantlist)

        for i = 1, #relevantlist, 1 do
            if item == relevantlist[i] then 
                return true
            end
        end
        -- return funcs.ui:table_contains(relevantlist, item)
        return false
    end
        
    function main.init_gui(item)
        
        local enable = API.MENU.Get(gui.menu.master_swtich)
        local m = gui.menu

        if item == gui.menu.master_swtich then 
            API.MENU.Visible(export,enable) 
            API.MENU.Visible(load,enable) 
            API.MENU.Visible(load_default,enable) 
            API.MENU.Visible(m.fake_lag_limit_d,enable) 
            API.MENU.Visible(antiaim.fake_lag_limit,false) 
            API.MENU.Visible(m.temp_manual,false) 
            
            g_antiaim:og_menu(not enable)

            if enable then 
                API.MENU.Visible(m.info_1 ,  false)
                API.MENU.Visible(m.info_2,false)
                API.MENU.Visible(m.info_2_,false )
                API.MENU.Visible(m.info_2__,false )
                API.MENU.Visible(m.info_2___,false )
                API.MENU.Visible(m.info_user,false)
                API.MENU.Visible(m.info_3_,false )
                API.MENU.Visible(m.info_4_,false)
            else
                API.MENU.Visible(m.info_1 ,  true)
                API.MENU.Visible(m.info_2, true)
                API.MENU.Visible(m.info_2_, true )
                API.MENU.Visible(m.info_2__,true )
                API.MENU.Visible(m.info_2___,true )
                API.MENU.Visible(m.info_user,true)
                API.MENU.Visible(m.info_3_,true )
                API.MENU.Visible(m.info_4_,true)
            end

            API.MENU.Visible(m.main_list,enable)
        end

        if item == gui.menu.master_swtich or item == gui.menu.main_list then 
            API.MENU.Visible(m.presets,enable and funcs.ui:table_contains(API.MENU.Get(m.main_list),"\a"..menu2.."                  Built-in presets") == true)
            API.MENU.Visible(m.preset_static,enable and funcs.ui:table_contains(API.MENU.Get(m.main_list),"\a"..menu2.."                  Built-in presets") == true and API.MENU.Get(m.presets) ~= "Custom")

            API.MENU.Visible(m.indicator_settings,enable and funcs.ui:table_contains(API.MENU.Get(m.main_list),"\a"..menu1.."                       Indicators") == true)
            API.MENU.Visible(m.indicator_color,enable and funcs.ui:table_contains(API.MENU.Get(m.main_list),"\a"..menu1.."                       Indicators") == true)
            API.MENU.Visible(m.antiaim_settings,enable and funcs.ui:table_contains(API.MENU.Get(m.main_list),"\a"..menu3.."             Extra antiaim settings") == true)
            API.MENU.Visible(m.misc_settings,enable and funcs.ui:table_contains(API.MENU.Get(m.main_list),"\a"..menu4.."                   Misc features") == true)
            API.MENU.Visible(m.trashtalk,enable and funcs.ui:table_contains(API.MENU.Get(m.main_list),"\a"..menu4.."                   Misc features") == true)
        end

        if item == gui.menu.master_swtich or item == gui.menu.indicator_settings then 
            API.MENU.Visible(m.center_mode,enable and funcs.ui:table_contains(API.MENU.Get(m.indicator_settings),"\a646464FF Indicator Style") == true)
            API.MENU.Visible(m.indicator_label,enable and funcs.ui:table_contains(API.MENU.Get(m.indicator_settings),"\a646464FF Indicator Style") == true)
            API.MENU.Visible(m.indicator_color,enable and funcs.ui:table_contains(API.MENU.Get(m.indicator_settings),"\a646464FF Indicator Style") == true)
            API.MENU.Visible(m.manualarrow_distance,enable and funcs.ui:table_contains(API.MENU.Get(m.indicator_settings),"\a646464FF Manual arrows") == true)
            API.MENU.Visible(m.draw,enable and funcs.ui:table_contains(API.MENU.Get(m.indicator_settings),"\a646464FF Logs") == true)
            API.MENU.Visible(m.manualarrow_size,enable and funcs.ui:table_contains(API.MENU.Get(m.indicator_settings),"\a646464FF Manual arrows") == true)
            API.MENU.Visible(m.manualarrow_back,enable and funcs.ui:table_contains(API.MENU.Get(m.indicator_settings),"\a646464FF Manual arrows") == true)
            API.MENU.Visible(m.watermark_color,enable and funcs.ui:table_contains(API.MENU.Get(m.indicator_settings),"\a646464FF Watermark") == true)
            API.MENU.Visible(m.watermark_label,enable and funcs.ui:table_contains(API.MENU.Get(m.indicator_settings),"\a646464FF Watermark") == true)
            API.MENU.Visible(m.watermark_label2,enable and funcs.ui:table_contains(API.MENU.Get(m.indicator_settings),"\a646464FF Watermark") == true)
            API.MENU.Visible(m.watermark_color2,enable and funcs.ui:table_contains(API.MENU.Get(m.indicator_settings),"\a646464FF Watermark") == true)
        end

        if item == gui.menu.master_swtich or item == gui.menu.antiaim_settings or item == gui.menu.main_list then
            local antiaim_settings  = funcs.ui:table_contains(API.MENU.Get(m.main_list),"\a"..menu3.."             Extra antiaim settings") == true
            API.MENU.Visible(m.forceroll_states,enable and funcs.ui:table_contains(API.MENU.Get(m.antiaim_settings),"\a646464FF Roll") == true and antiaim_settings)
            API.MENU.Visible(m.roll_selects,enable and funcs.ui:table_contains(API.MENU.Get(m.antiaim_settings),"\a646464FF Roll") == true and antiaim_settings)
            API.MENU.Visible(m.roll_inverter,enable and funcs.ui:table_contains(API.MENU.Get(m.antiaim_settings),"\a646464FF Roll") == true and antiaim_settings)
            API.MENU.Visible(m.disable_use,enable and funcs.ui:table_contains(API.MENU.Get(m.antiaim_settings),"\a646464FF Antiaim on use") == true and antiaim_settings )
            API.MENU.Visible(m.static_onuse,enable and funcs.ui:table_contains(API.MENU.Get(m.antiaim_settings),"\a646464FF Antiaim on use") == true and antiaim_settings )
            API.MENU.Visible(m.roll_key,enable and funcs.ui:table_contains(API.MENU.Get(m.antiaim_settings),"\a646464FF Roll") == true and antiaim_settings)
            API.MENU.Visible(m.abf,enable and funcs.ui:table_contains(API.MENU.Get(m.antiaim_settings),"\a646464FF Anti-Bruteforce") == true and antiaim_settings)
            API.MENU.Visible(m.manual_left,enable and funcs.ui:table_contains(API.MENU.Get(m.antiaim_settings),"\a646464FF Manual antiaim") == true and antiaim_settings)
            API.MENU.Visible(m.manual_right,enable and funcs.ui:table_contains(API.MENU.Get(m.antiaim_settings),"\a646464FF Manual antiaim") == true and antiaim_settings)
            API.MENU.Visible(m.manual_reset,enable and funcs.ui:table_contains(API.MENU.Get(m.antiaim_settings),"\a646464FF Manual antiaim") == true and antiaim_settings)
            API.MENU.Visible(m.prevent_jitter,enable and funcs.ui:table_contains(API.MENU.Get(m.antiaim_settings),"\a646464FF Manual antiaim") == true and antiaim_settings)
        
            API.MENU.Visible(m.edge_yaw_key,enable and funcs.ui:table_contains(API.MENU.Get(m.antiaim_settings),"\a646464FF Edge yaw") == true and antiaim_settings) 
            API.MENU.Visible(m.freestanding_key,enable and funcs.ui:table_contains(API.MENU.Get(m.antiaim_settings),"\a646464FF Freestanding") == true and antiaim_settings )
        end 

        if item == gui.menu.master_swtich or item == gui.menu.misc_settings or item == gui.menu.main_list then
            local misc_d = funcs.ui:table_contains(API.MENU.Get(m.main_list),"\a"..menu4.."                   Misc features") == true
            API.MENU.Visible(m.pitch0_onknife,enable and funcs.ui:table_contains(API.MENU.Get(m.misc_settings),"\a646464FF Anti knife") == true and misc_d)
            API.MENU.Visible(m.knife_distance,enable and funcs.ui:table_contains(API.MENU.Get(m.misc_settings),"\a646464FF Anti knife") == true and misc_d)
        end
    --[-]
    local customitems = {gui.menu.master_swtich, gui.menu.main_list, gui.menu.states_selection, gui.menu.presets}
    for i = 1,#_state do
        customitems[#customitems+1]  = gui.menu.custom[i].enable
        customitems[#customitems+1]  = gui.menu.custom[i].extra_options
        customitems[#customitems+1]  = gui.menu.custom[i].yaw_mode
        customitems[#customitems+1]  = gui.menu.custom[i].static_yaw
        customitems[#customitems+1]  = gui.menu.custom[i].tick_yaw_left
        customitems[#customitems+1]  = gui.menu.custom[i].tick_yaw_right
        customitems[#customitems+1]  = gui.menu.custom[i].choke_yaw_left
        customitems[#customitems+1]  = gui.menu.custom[i].choke_yaw_right
        customitems[#customitems+1]  = gui.menu.custom[i].desync_yaw_left
        customitems[#customitems+1]  = gui.menu.custom[i].desync_yaw_right
        customitems[#customitems+1]  = gui.menu.custom[i].yaw_jitter
        customitems[#customitems+1]  = gui.menu.custom[i].yaw_jitter_degree
        customitems[#customitems+1]  = gui.menu.custom[i].self_bodyyaw_mode
        customitems[#customitems+1]  = gui.menu.custom[i].bodyyaw_mode
        customitems[#customitems+1]  = gui.menu.custom[i].bodyyaw_degree
        customitems[#customitems+1]  = gui.menu.custom[i].jitter_bodyyaw_degree_left
        customitems[#customitems+1]  = gui.menu.custom[i].jitter_bodyyaw_degree_right
        customitems[#customitems+1]  = gui.menu.custom[i].step_bodyyaw_degree_left
        customitems[#customitems+1]  = gui.menu.custom[i].step_bodyyaw_degree_right
        customitems[#customitems+1]  = gui.menu.custom[i].body_yaw_step_ticks
        customitems[#customitems+1]  = gui.menu.custom[i].body_yaw_step_value
        customitems[#customitems+1]  = gui.menu.custom[i].fake_yaw_mode
        customitems[#customitems+1]  = gui.menu.custom[i].static_fakeyaw
        customitems[#customitems+1]  = gui.menu.custom[i].jitter_fakeyaw_left
        customitems[#customitems+1]  = gui.menu.custom[i].jitter_fakeyaw_right
        customitems[#customitems+1]  = gui.menu.custom[i].step_ticks
        customitems[#customitems+1]  = gui.menu.custom[i].step_value
        customitems[#customitems+1]  = gui.menu.custom[i].step_ticks
        customitems[#customitems+1]  = gui.menu.custom[i].step_abs
        customitems[#customitems+1]  = gui.menu.custom[i].step_fake_min
        customitems[#customitems+1]  = gui.menu.custom[i].step_fake_max
        customitems[#customitems+1]  = gui.menu.custom[i].freestanding_bodyyaw

    end


    if itemiscool(item, customitems)then
        API.MENU.Visible(m.states_selection,enable and funcs.ui:table_contains(API.MENU.Get(m.main_list),"\a"..menu2.."                  Built-in presets") == true and API.MENU.Get(m.presets) == "Custom")
        
        for i = 1,#_state do
            local selects = API.MENU.Get(m.states_selection)
            local cswitch = API.MENU.Get(m.custom[i].enable)
            local show = enable and selects == _state[i] and funcs.ui:table_contains(API.MENU.Get(m.main_list),"\a"..menu2.."                  Built-in presets") == true and API.MENU.Get(m.presets) == "Custom" and cswitch
            API.MENU.Visible(m.custom[i].enable, enable and selects == _state[i] and funcs.ui:table_contains(API.MENU.Get(m.main_list),"\a"..menu2.."                  Built-in presets") == true and API.MENU.Get(m.presets) == "Custom")
            API.MENU.Visible(m.custom[i].extra_options,show)
            API.MENU.Visible(m.custom[i].yaw_mode,show)
            API.MENU.Visible(m.custom[i].static_yaw,show and API.MENU.Get(m.custom[i].yaw_mode) == "Static")
            API.MENU.Visible(m.custom[i].tick_yaw_left,show and API.MENU.Get(m.custom[i].yaw_mode) == "Period jitter \aC08A8AFF[Tick]")
            API.MENU.Visible(m.custom[i].tick_yaw_right,show and API.MENU.Get(m.custom[i].yaw_mode) == "Period jitter \aC08A8AFF[Tick]")
            API.MENU.Visible(m.custom[i].choke_yaw_left,show and API.MENU.Get(m.custom[i].yaw_mode) == "Period jitter \aC08A8AFF[Choke]")
            API.MENU.Visible(m.custom[i].choke_yaw_right,show and API.MENU.Get(m.custom[i].yaw_mode) == "Period jitter \aC08A8AFF[Choke]")
            API.MENU.Visible(m.custom[i].desync_yaw_left,show and API.MENU.Get(m.custom[i].yaw_mode) == "Period jitter \aC08A8AFF[Desync]")
            API.MENU.Visible(m.custom[i].desync_yaw_right,show and API.MENU.Get(m.custom[i].yaw_mode) == "Period jitter \aC08A8AFF[Desync]")
            API.MENU.Visible(m.custom[i].yaw_jitter,show)
            API.MENU.Visible(m.custom[i].yaw_jitter_degree,show)      
            API.MENU.Visible(m.custom[i].self_bodyyaw_mode,show)
            API.MENU.Visible(m.custom[i].bodyyaw_mode,show and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Opposite")     
            API.MENU.Visible(m.custom[i].bodyyaw_degree,show and API.MENU.Get(m.custom[i].bodyyaw_mode) == "Static" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Opposite" )
            API.MENU.Visible(m.custom[i].jitter_bodyyaw_degree_left,show and API.MENU.Get(m.custom[i].bodyyaw_mode) == "Period jitter" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Opposite")
            API.MENU.Visible(m.custom[i].jitter_bodyyaw_degree_right,show and API.MENU.Get(m.custom[i].bodyyaw_mode) == "Period jitter" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Opposite")
            API.MENU.Visible(m.custom[i].step_bodyyaw_degree_left,show and API.MENU.Get(m.custom[i].bodyyaw_mode) == "Recursion" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Opposite")
            API.MENU.Visible(m.custom[i].step_bodyyaw_degree_right,show and API.MENU.Get(m.custom[i].bodyyaw_mode) == "Recursion" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Opposite")
            API.MENU.Visible(m.custom[i].body_yaw_step_ticks,show and API.MENU.Get(m.custom[i].bodyyaw_mode) == "Recursion" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Opposite")
            API.MENU.Visible(m.custom[i].body_yaw_step_value,show and API.MENU.Get(m.custom[i].bodyyaw_mode) == "Recursion" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Opposite")

            API.MENU.Visible(m.custom[i].fake_yaw_mode,show and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off")
            API.MENU.Visible(m.custom[i].static_fakeyaw,show and API.MENU.Get(m.custom[i].fake_yaw_mode) == "Static" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off" )
            API.MENU.Visible(m.custom[i].jitter_fakeyaw_left,show and API.MENU.Get(m.custom[i].fake_yaw_mode) == "Period tick jitter" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off"and API.MENU.Get(m.custom[i].fake_yaw_mode) ~= "Static" )
            API.MENU.Visible(m.custom[i].jitter_fakeyaw_right,show and API.MENU.Get(m.custom[i].fake_yaw_mode) == "Period tick jitter" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off" and API.MENU.Get(m.custom[i].fake_yaw_mode) ~= "Static")
            API.MENU.Visible(m.custom[i].step_ticks,show and API.MENU.Get(m.custom[i].fake_yaw_mode) == "Progressively increase" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off"and API.MENU.Get(m.custom[i].fake_yaw_mode) ~= "Static" )
            API.MENU.Visible(m.custom[i].step_value,show and API.MENU.Get(m.custom[i].fake_yaw_mode) == "Progressively increase" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off"and API.MENU.Get(m.custom[i].fake_yaw_mode) ~= "Static")
            API.MENU.Visible(m.custom[i].step_ticks,show and API.MENU.Get(m.custom[i].fake_yaw_mode) == "Progressively increase" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off" and API.MENU.Get(m.custom[i].fake_yaw_mode) ~= "Static")

            API.MENU.Visible(m.custom[i].step_abs,show and API.MENU.Get(m.custom[i].fake_yaw_mode) == "Progressively increase" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off" and API.MENU.Get(m.custom[i].fake_yaw_mode) ~= "Static")
            API.MENU.Visible(m.custom[i].step_fake_min,show  and API.MENU.Get(m.custom[i].fake_yaw_mode) == "Progressively increase" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off" and API.MENU.Get(m.custom[i].fake_yaw_mode) ~= "Static" )
            API.MENU.Visible(m.custom[i].step_fake_max,show  and API.MENU.Get(m.custom[i].fake_yaw_mode) == "Progressively increase" and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off" and API.MENU.Get(m.custom[i].fake_yaw_mode) ~= "Static" )
            API.MENU.Visible(m.custom[i].freestanding_bodyyaw,show and API.MENU.Get(m.custom[i].self_bodyyaw_mode) ~= "Off")
    end
    
        end

        
        main:callback("shutdown",main.shutdown,enable)
        main:callback("setup_command",setup_command,enable)
        main:callback("run_command",run_command,enable)
        main:callback("paint",paint,enable)
        main:callback("pre_render",pre_render,enable)
        main:callback("aim_hit",aim_hit,enable)
        main:callback("player_death",player_death,enable)
        main:callback("round_start",round_start,enable)
        main:callback("paint_ui",verify,enable)

        main:callback("setup_command",g_antiaim.run_trustd,funcs.ui:table_contains(API.MENU.Get(gui.menu.forceroll_states),"\aF8F884D1 Match making") == true)

        main:callback("paint",clan_tag,funcs.ui:table_contains(API.MENU.Get(gui.menu.misc_settings),"\a646464FF Clantag") == true, function() API.CLIENT.Delay(0.1,API.CLIENT.Clantag,(""))  end)

    end

    main.init_gui(gui.menu.master_swtich)

    API.CLIENT.Callback("setup_command", setup_command)

    function main:register_callbacks()
        for k, v in API.ENV.Pairs(gui.callback) do
            API.MENU.Callback(v,main.init_gui)
        end
        API.MENU.Callback(load,main.init_gui)
        API.MENU.Callback(export,main.init_gui)
        API.MENU.Callback(load_default,main.init_gui)
        API.MENU.Callback(get_logs,main.init_gui)
        API.MENU.Callback(load,loadd)
        API.MENU.Callback(export,expd)
        API.MENU.Callback(load_default,default_config)
        API.MENU.Callback(get_logs,draw_logs)


    
    end

    API.CLIENT.Callback("paint_ui",noti)

    main:register_callbacks()
end
main()
