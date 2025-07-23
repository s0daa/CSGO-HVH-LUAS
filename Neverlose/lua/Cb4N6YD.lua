-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local base64 = require "neverlose/base64"
local smoothy = require "neverlose/smoothy"

local inspect = require "neverlose/inspect"

local ZWSP = "\xE2\x80\x8A"

local function round(x)
    return math.floor(0.5 + x)
end

local script_info do
    script_info = { }

    script_info.name = "Invincible"
    script_info.build = "Release"

    script_info.user = common.get_username()
end

local software do
    software = { }

    software.rage = {
        main = {
            enabled = {
                ui.find("Aimbot", "Ragebot", "Main", "Enabled"),
                ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
            },

            hide_shots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
            double_tap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),

            hide_shots_options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
            double_tap_lag_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options")
        },

        selection = {
            min_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage")
        }
    }

    software.aa = {
        angles = {
            enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),

            pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),

            yaw = {
                ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden")
            },

            yaw_modifier = {
                ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
            },

            body_yaw = {
                ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")
            },

            freestanding = {
                ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),

                ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")
            },

            extended_angles = {
                ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll")
            }
        },

        misc = {
            fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
            slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
            leg_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
        }
    }

    software.visuals = {
        world = {
            main = {
                scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
            },

            other = {
                world_marker = ui.find("Visuals", "World", "Other", "Hit Marker", "3D Marker"),
                damage_marker = ui.find("Visuals", "World", "Other", "Hit Marker", "Damage Marker"),

                grenade_prediction = {
                    color = ui.find("Visuals", "World", "Other", "Grenade Prediction", "Color"),
                    color_hit = { ui.find("Visuals", "World", "Other", "Grenade Prediction", "Color Hit") }
                }
            }
        }
    }

    software.misc = {
        main = {
            in_game = {
                clan_tag = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag")
            },

            other = {
                weapon_actions = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"),
                fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency")
            }
        }
    }
end

local clipboard do
    clipboard = { }

    local new_char_array = ffi.typeof "char[?]"

    local GetClipboardTextCount = utils.get_vfunc("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
    local SetClipboardText = utils.get_vfunc("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
    local GetClipboardText = utils.get_vfunc("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")

    function clipboard.get()
        local len = GetClipboardTextCount()

        if len > 0 then
            local arr = new_char_array(len)

            GetClipboardText(0, arr, len)
            return ffi.string(arr, len - 1)
        end

        return ""
    end

    function clipboard.set(...)
        local text = table.concat({ ... })
        local count = string.len(text)

        SetClipboardText(text, count)
    end
end

local decorators do
    decorators = { }

    local function get_u8_array(s)
        local arr = { }
        local count = 0

        for char in s:gmatch(".[\128-\191]*") do
            count = count + 1
            arr[count] = char
        end

        return arr, count
    end

    -- FIXME: Make it more optimized, maybe?
    -- cuz I think it is eats my frametime
    -- I really don't like dis, fuck...
    function decorators.wave(s, col_1, col_2, time)
        time = time or globals.realtime

        local list = { }

        local arr, count = get_u8_array(s)
        local step = 1 / (count - 1)

        local r_step = col_2.r - col_1.r
        local g_step = col_2.g - col_1.g
        local b_step = col_2.b - col_1.b
        local a_step = col_2.a - col_1.a

        local col = color()

        for i = 1, count do
            local t = math.abs((time - 1) % 2 - 1)

            col.r = col_1.r + r_step * t
            col.g = col_1.g + g_step * t
            col.b = col_1.b + b_step * t
            col.a = col_1.a + a_step * t

            local text = "\a" .. col:to_hex() .. arr[i]

            table.insert(list, text)
            time = time + step
        end

        return table.concat(list)
    end
end

local logging do
    logging = { }

    local LOGO_TEXT = script_info.name:lower()

    local SND_SUCCESS = "ui/beepclear.wav"
    local SND_WARNING = "resource/warning.wav"

    local playvol = cvar.playvol

    local function get_logo(color)
        if color == nil then
            color = "{Link Active}"
        end

        return "\a" .. color .. LOGO_TEXT .. "\aDEFAULT"
    end

    function logging.err(msg, ...)
        local text = table.concat {
            get_logo(), ": ", "\aFF0032FF", msg, ...
        }

        print_raw(text)
        playvol:call(SND_WARNING, 1.0)
    end

    function logging.msg(msg, ...)
        local text = table.concat {
            get_logo(), ": ", "\a80FF32FF", msg, ...
        }

        print_raw(text)
        playvol:call(SND_SUCCESS, 1.0)
    end

    function logging.raw(msg, ...)
        local text = table.concat {
            get_logo(), ": ", msg, ...
        }

        print_raw(text)
    end
end

local database do
    database = { }

    local DB_NAME = script_info.name:lower() .. "-db"

    local data = db[DB_NAME] or { }

    function database.get(key)
        return data[key]
    end

    function database.set(key, value)
        data[key] = value
    end

    function database.flush()
        data = { }
        db[DB_NAME] = { }
    end

    local function on_shutdown()
        db[DB_NAME] = data
    end

    events.shutdown(on_shutdown)
end


local localplayer do
    localplayer = { }

    local pre_flags = 0
    local post_flags = 0

    localplayer.is_onground = false

    localplayer.is_moving = false
    localplayer.is_crouched = false

    localplayer.abs_body_yaw = 0

    localplayer.velocity2d = 0
    localplayer.duck_amount = 0

    localplayer.eye_position = vector()

    localplayer.team_num = 0
    localplayer.sent_packets = 0

    local function get_body_yaw(player, max_desync)
        local animstate = player:get_anim_state()

        if animstate == nil then
            return 0
        end

        local body_yaw = math.normalize_yaw(animstate.eye_yaw - animstate.abs_yaw)

        if max_desync ~= nil then
            body_yaw = math.clamp(body_yaw, -max_desync, max_desync)
        end

        return body_yaw
    end

    local function on_createmove(cmd)
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        pre_flags = me.m_fFlags

        localplayer.velocity2d = me.m_vecVelocity:length2d()

        if cmd.choked_commands == 0 then
            local max_desync = rage.antiaim:get_max_desync()

            localplayer.max_body_yaw = max_desync
            localplayer.abs_body_yaw = get_body_yaw(me, max_desync)

            localplayer.duck_amount = me.m_flDuckAmount
            localplayer.eye_position = me:get_eye_position()

            localplayer.sent_packets = localplayer.sent_packets + 1
        end

        localplayer.is_moving = localplayer.velocity2d > 1.1 * 3.3
        localplayer.is_crouched = localplayer.duck_amount > 0

        localplayer.team_num = me.m_iTeamNum
    end

    local function on_createmove_run(e)
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        post_flags = me.m_fFlags

        localplayer.is_onground = bit.band(pre_flags, 1) == 1
            and bit.band(post_flags, 1) == 1
    end

    events.createmove(on_createmove)
    events.createmove_run(on_createmove_run)
end

local conditions do
    conditions = { }

    local state = nil

    local function compute_state()
        if localplayer.is_onground then
            if software.aa.misc.slow_walk:get() then
                return "Slow Walk"
            end

            if not localplayer.is_moving then
                if localplayer.is_crouched then
                    return "Crouching"
                end

                return "Standing"
            end

            if localplayer.is_crouched then
                return "Crouching Move"
            end

            return "Moving"
        end

        return localplayer.is_crouched
            and "Air Crouch" or "In Air"
    end

    local function on_createmove()
        state = compute_state()
    end

    function conditions.get()
        return state
    end

    events.createmove(on_createmove)
end

local config_system do
    config_system = { }

    local items = { }
    local lookup = { }

    local function hash_key(category, key)
        return category:lower() .. "::" .. key
    end

    local function generate_keys(...)
        local keys, empty = { }, true
        local count = select("#", ...)

        if count > 0 then
            for i = 1, count do
                keys[select(i, ...)] = i
            end

            empty = false
        end

        return keys, empty
    end

    local function get_value(item)
        if item:type() == "color_picker" then
            local list = item:list()
            local value = { item:get() }

            if list[1] == "" then
                return { "", value:to_hex() }
            end

            local new_value = { }

            for i = 1, #list do
                local name = list[i]
                local colors = item:get(name)

                local result = { }

                for j = 1, #colors do
                    result[j] = colors[j]:to_hex()
                end

                new_value[name] = result
            end

            return { value[1], new_value }
        end

        return { item:get() }
    end

    local function set_value(item, value)
        if item:type() == "color_picker" then
            -- if color_picker is single
            if value[1] == "" then
                item:set(color(value[2]))
                return
            end

            -- if color_picker is multiple
            for k, v in pairs(value[2]) do
                local colors = { }

                for i = 1, #v do
                    colors[i] = color(v[i])
                end

                item:set(k, colors)
            end

            item:set(value[1])
            return
        end

        item:set(unpack(value))
    end

    function config_system.encode(data)
        local ok, result = pcall(json.stringify, data)

        if not ok then
            return false, result
        end

        local ok, result = pcall(base64.encode, result)

        if not ok then
            return false, result
        end

        return true, result
    end

    function config_system.decode(str)
        local ok, result = pcall(base64.decode, str)

        if not ok then
            return false, result
        end

        local ok, result = pcall(json.parse, result)

        if not ok then
            return false, result
        end

        return true, result
    end

    function config_system.import(data, ...)
        local keys, empty = generate_keys(...)

        for k, v in pairs(data) do
            local item = lookup[k]

            if item == nil then
                goto continue
            end

            if not empty and not keys[item.category] then
                goto continue
            end

            set_value(item.ref, v)
            ::continue::
        end

        return true
    end

    function config_system.export(...)
        local data = { }

        local keys, empty = generate_keys(...)

        for i = 1, #items do
            local item = items[i]
            local ref = item.ref

            local hash = item.hash
            local category = item.category

            if not empty and not keys[category] then
                goto continue
            end

            local ok, value = pcall(get_value, ref)

            if not ok then
                goto continue
            end

            data[hash] = value
            ::continue::
        end

        return true, data
    end

    function config_system.push(category, key, item)
        local hash = hash_key(category, key)

        local list = {
            ref = item,
            hash = hash,
            category = category
        }

        if lookup[hash] == nil then
            lookup[hash] = list
        else
            logging.err("Found config collision: \"" .. key .. "\" for \"" .. item:name() .. "\" item")
        end

        table.insert(items, list)
        return item
    end
end

local window_system do
    window_system = { }

    local group = ui.create "Windows"
        :visibility(false)

    local list = { }

    local hovered_window = nil
    local foreground_window = nil

    local function extract(value)
        local ok, result = pcall(
            json.parse, value
        )

        return ok and result or nil
    end

    local function is_collided(point, a, b)
        return point.x >= a.x and point.x <= b.x
            and point.y >= a.y and point.y <= b.y
    end

    local ctx = { } do
        ctx.mouse_pos = vector()
        ctx.mouse_pos_prev = vector()

        ctx.mouse_down = false
        ctx.mouse_clicked = false

        ctx.mouse_down_duration = 0

        ctx.mouse_delta = vector()
        ctx.mouse_clicked_pos = vector()

        function ctx.update_mouse_inputs()
            local dt = globals.frametime

            local cursor = ui.get_mouse_position()
            local is_down = common.is_button_down(0x01)

            ctx.mouse_pos_prev = ctx.mouse_pos
            ctx.mouse_pos = cursor

            ctx.mouse_delta = ctx.mouse_pos - ctx.mouse_pos_prev

            ctx.mouse_down = is_down
            ctx.mouse_clicked = is_down and ctx.mouse_down_duration < 0

            ctx.mouse_down_duration = is_down and (ctx.mouse_down_duration < 0 and 0 or ctx.mouse_down_duration + dt) or -1

            if ctx.mouse_clicked then
                ctx.mouse_clicked_pos = ctx.mouse_pos
            end
        end
    end

    local Window = { } do
        Window.__index = Window

        function Window:__new(name, options)
            local item = group:value(name, "{ }")
            local item_data = extract(item:get())

            local initial_pos = vector(0, 0)
            local initial_size = vector(0, 0)
            local initial_anchor = vector(0, 0)

            if type(options) == "table" then
                if options.pos ~= nil then
                    initial_pos.x = options.pos.x or 0
                    initial_pos.y = options.pos.y or 0
                end

                if options.size ~= nil then
                    initial_size.x = options.size.x or 0
                    initial_size.y = options.size.y or 0
                end

                if options.anchor ~= nil then
                    initial_anchor.x = options.anchor.x or 0
                    initial_anchor.y = options.anchor.y or 0
                end
            end

            if item_data ~= nil then
                if item_data.pos ~= nil then
                    initial_pos.x = item_data.pos.x or 0
                    initial_pos.y = item_data.pos.y or 0
                end
            end

            local data = {
                item = item,
                name = name,

                pos = initial_pos,
                size = initial_size,
                anchor = initial_anchor,

                is_active = true,

                is_dragged = false,
                is_hovered = false,
            }

            table.insert(list, data)
            return setmetatable(data, self)
        end

        function Window:get_pos()
            return self.pos
        end

        function Window:get_size()
            return self.size
        end

        function Window:get_anchor()
            return self.anchor
        end

        function Window:set_pos(pos)
            local new_pos = pos:clone()

            if self.pos ~= new_pos then
                local saved_pos = vector(
                    new_pos.x + self.size.x * self.anchor.x,
                    new_pos.y + self.size.y * self.anchor.y
                )

                local data_to_save = {
                    pos = {
                        x = saved_pos.x,
                        y = saved_pos.y
                    }
                }

                self.item:set(json.stringify(data_to_save))
            end

            self.pos = new_pos
            return self
        end

        function Window:set_size(size)
            local delta = size - self.size
            local new_pos = self.pos - delta * self.anchor

            self.size = size
            self:set_pos(new_pos)

            return self
        end

        function Window:set_anchor(anchor)
            self.anchor = anchor
            return self
        end
    end

    local function find_hovered_window()
        local found_window = nil

        if ui.get_alpha() > 0 then
            for i = 1, #list do
                local window = list[i]

                local pos = window.pos
                local size = window.size

                if not window.is_active then
                    goto continue
                end

                if not is_collided(ctx.mouse_pos, pos, pos + size) then
                    goto continue
                end

                found_window = window
                ::continue::
            end
        end

        hovered_window = found_window
    end

    local function find_foreground_window()
        if not ctx.mouse_down then
            foreground_window = nil
            return
        end

        if ctx.mouse_clicked and hovered_window ~= nil then
            foreground_window = hovered_window
        end
    end

    local function update_all_windows()
        for i = 1, #list do
            local window = list[i]

            window.is_dragged = false
            window.is_hovered = false
        end
    end

    local function update_hovered_window()
        if hovered_window == nil then
            return
        end

        hovered_window.is_hovered = true
    end

    local function update_foreground_window()
        if foreground_window == nil then
            return
        end

        local new_position = foreground_window.pos + ctx.mouse_delta

        foreground_window:set_pos(new_position)
        foreground_window.is_dragged = true
    end

    local function on_render()
        ctx.update_mouse_inputs()

        find_hovered_window()
        find_foreground_window()

        update_all_windows()

        update_hovered_window()
        update_foreground_window()
    end

    local function on_createmove(cmd)
        local blocked = foreground_window ~= nil
            or hovered_window ~= nil

        if not blocked then
            return
        end

        cmd.in_attack = false
        cmd.in_attack2 = false
    end

    function window_system.new(name, options)
        return Window:__new(name, options)
    end

    events.render(on_render)
    events.createmove(on_createmove)
end

local resource do
    resource = { }

    local LEFT_COLUMN = 1
    local RIGHT_COLUMN = 2

    local function pad(count)
        return ZWSP:rep(count)
    end

    local function pad_label(icon, name, left, right)
        return pad(left) .. "\a{Link Active}" .. icon
            .. pad(right) .. "\aDEFAULT" .. name
    end

    local function pad_button(icon, name, count)
        return pad(count) .. "\a{Link Active}" .. icon
            .. pad(4) .. "\aDEFAULT" .. name .. pad(count)
    end

    local function create_link(url)
        return function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL(url)
        end
    end

    local sidebar = { } do
        local icon = ui.get_icon "trophy"
        local name = script_info.name

        local function on_render()
            local style = ui.get_style()

            local text = decorators.wave(
                name, style["Link Active"], style["Disabled Text"], globals.realtime
            )

            ui.sidebar(text, icon)
        end

        events.render(on_render)
    end

    local home = { } do
        local groups = { } do
            local TAB = ui.get_icon "star"

            groups.logo = ui.create(TAB, "##LOGO", LEFT_COLUMN)
            groups.controls = ui.create(TAB, "##CONTROLS", LEFT_COLUMN)

            groups.main = ui.create(TAB, "Main", RIGHT_COLUMN)
            groups.socials = ui.create(TAB, "Socials", RIGHT_COLUMN)
            groups.configs = ui.create(TAB, "Configs", RIGHT_COLUMN)
        end

        local logo = { } do
            local PNG_SIGNATURE = "\x89\x50\x4e\x47" -- 0x89 + "PNG"
            local URL = "https://i.imgur.com/eX4lnR7.png"

            local item = nil

            local function update_texture(texture)
                if texture == nil then
                    return false
                end

                if item == nil then
                    item = groups.logo:texture(texture)
                else
                    item:set(texture)
                end
            end

            network.get(URL, { }, function(response)
                if type(response) ~= "string" then
                    return
                end

                local signature = response:sub(1, 4)

                if signature ~= PNG_SIGNATURE then
                    return
                end

                local ok, result = pcall(render.load_image, response, vector(264, 264))

                if not ok then
                    return
                end

                update_texture(result)
            end)
        end

        local main = { } do
            local function get_clock_name()
                local time = common.get_system_time()

                local text = string.format("Time: \a{Link Active}%02d:%02d:%02d", time.hours, time.minutes, time.seconds)
                local label = pad_label(ui.get_icon "clock", text, 0, 4)

                return label
            end

            main.user = groups.main:label(pad_label(ui.get_icon "circle-user", string.format("User: \a{Link Active}%s", script_info.user), 0, 5))
            main.build = groups.main:label(pad_label(ui.get_icon "code-branch", string.format("Build: \a{Link Active}%s", script_info.build), 0, 5))
            main.clock = groups.main:label(get_clock_name())

            local function recursive_update()
                main.clock:name(get_clock_name())

                -- execute update every second
                utils.execute_after(1.0, recursive_update)
            end

            recursive_update()
        end

        local socials = { } do
            socials.config = groups.socials:button(pad_button(ui.get_icon "gear", "Claire's Config", 36), create_link("https://en.neverlose.cc/market/item?id=5Gd8L0"), true)
            socials.discord = groups.socials:button(pad_button(ui.get_icon "discord", "Discord Server", 36), create_link("https://discord.gg/UdMAQWXvde"), true)
            socials.youtube = groups.socials:button(pad_button(ui.get_icon "youtube", "Claire's Youtube", 34), create_link("https://www.youtube.com/channel/UC33dNSHbvj2FV62G1U1FQSQ"), true)
        end

        local configs = { } do
            local function on_export()
                local ok, result = config_system.export()

                if not ok then
                    logging.err(result)
                    return
                end

                local ok, result = config_system.encode(result)

                if not ok then
                    logging.err(result)
                    return
                end

                logging.msg("Config exported")
                clipboard.set(result)
            end

            local function on_import()
                local ok, result = config_system.decode(
                    clipboard.get()
                )

                if not ok then
                    logging.err(result)
                    return
                end

                local ok, result = config_system.import(result)

                if not ok then
                    logging.err(result)
                    return
                end

                logging.msg("Config imported")
            end

            local function on_default()
                local ok, result = config_system.decode(
                    "eyJhbnRpLWFpbTo6QWlyIENyb3VjaF9ib2R5X3lhdyI6W3RydWVdLCJhbnRpLWFpbTo6QWlyIENyb3VjaF9kZWxheSI6WzMuMF0sImFudGktYWltOjpBaXIgQ3JvdWNoX2VuYWJsZWQiOlt0cnVlXSwiYW50aS1haW06OkFpciBDcm91Y2hfZnJlZXN0YW5kaW5nIjpbIk9mZiJdLCJhbnRpLWFpbTo6QWlyIENyb3VjaF9sZWZ0X2xpbWl0IjpbNjAuMF0sImFudGktYWltOjpBaXIgQ3JvdWNoX21vZGlmaWVyX29mZnNldCI6WzAuMF0sImFudGktYWltOjpBaXIgQ3JvdWNoX29wdGlvbnMiOltbIkppdHRlciJdXSwiYW50aS1haW06OkFpciBDcm91Y2hfcGl0Y2giOlsiRG93biJdLCJhbnRpLWFpbTo6QWlyIENyb3VjaF9yaWdodF9saW1pdCI6WzYwLjBdLCJhbnRpLWFpbTo6QWlyIENyb3VjaF95YXciOlsiQmFja3dhcmQiXSwiYW50aS1haW06OkFpciBDcm91Y2hfeWF3X2Jhc2UiOlsiQXQgVGFyZ2V0Il0sImFudGktYWltOjpBaXIgQ3JvdWNoX3lhd19sZWZ0IjpbLTE2LjBdLCJhbnRpLWFpbTo6QWlyIENyb3VjaF95YXdfbW9kaWZpZXIiOlsiRGlzYWJsZWQiXSwiYW50aS1haW06OkFpciBDcm91Y2hfeWF3X3JpZ2h0IjpbMzguMF0sImFudGktYWltOjpDcm91Y2hpbmcgTW92ZV9ib2R5X3lhdyI6W3RydWVdLCJhbnRpLWFpbTo6Q3JvdWNoaW5nIE1vdmVfZGVsYXkiOlswLjBdLCJhbnRpLWFpbTo6Q3JvdWNoaW5nIE1vdmVfZW5hYmxlZCI6W3RydWVdLCJhbnRpLWFpbTo6Q3JvdWNoaW5nIE1vdmVfZnJlZXN0YW5kaW5nIjpbIk9mZiJdLCJhbnRpLWFpbTo6Q3JvdWNoaW5nIE1vdmVfbGVmdF9saW1pdCI6WzYwLjBdLCJhbnRpLWFpbTo6Q3JvdWNoaW5nIE1vdmVfbW9kaWZpZXJfb2Zmc2V0IjpbMC4wXSwiYW50aS1haW06OkNyb3VjaGluZyBNb3ZlX29wdGlvbnMiOltbIkppdHRlciJdXSwiYW50aS1haW06OkNyb3VjaGluZyBNb3ZlX3BpdGNoIjpbIkRvd24iXSwiYW50aS1haW06OkNyb3VjaGluZyBNb3ZlX3JpZ2h0X2xpbWl0IjpbNjAuMF0sImFudGktYWltOjpDcm91Y2hpbmcgTW92ZV95YXciOlsiQmFja3dhcmQiXSwiYW50aS1haW06OkNyb3VjaGluZyBNb3ZlX3lhd19iYXNlIjpbIkF0IFRhcmdldCJdLCJhbnRpLWFpbTo6Q3JvdWNoaW5nIE1vdmVfeWF3X2xlZnQiOlstMjAuMF0sImFudGktYWltOjpDcm91Y2hpbmcgTW92ZV95YXdfbW9kaWZpZXIiOlsiRGlzYWJsZWQiXSwiYW50aS1haW06OkNyb3VjaGluZyBNb3ZlX3lhd19yaWdodCI6WzI1LjBdLCJhbnRpLWFpbTo6Q3JvdWNoaW5nX2JvZHlfeWF3IjpbdHJ1ZV0sImFudGktYWltOjpDcm91Y2hpbmdfZGVsYXkiOlswLjBdLCJhbnRpLWFpbTo6Q3JvdWNoaW5nX2VuYWJsZWQiOlt0cnVlXSwiYW50aS1haW06OkNyb3VjaGluZ19mcmVlc3RhbmRpbmciOlsiT2ZmIl0sImFudGktYWltOjpDcm91Y2hpbmdfbGVmdF9saW1pdCI6WzYwLjBdLCJhbnRpLWFpbTo6Q3JvdWNoaW5nX21vZGlmaWVyX29mZnNldCI6WzAuMF0sImFudGktYWltOjpDcm91Y2hpbmdfb3B0aW9ucyI6W1siSml0dGVyIl1dLCJhbnRpLWFpbTo6Q3JvdWNoaW5nX3BpdGNoIjpbIkRvd24iXSwiYW50aS1haW06OkNyb3VjaGluZ19yaWdodF9saW1pdCI6WzYwLjBdLCJhbnRpLWFpbTo6Q3JvdWNoaW5nX3lhdyI6WyJCYWNrd2FyZCJdLCJhbnRpLWFpbTo6Q3JvdWNoaW5nX3lhd19iYXNlIjpbIkF0IFRhcmdldCJdLCJhbnRpLWFpbTo6Q3JvdWNoaW5nX3lhd19sZWZ0IjpbLTIwLjBdLCJhbnRpLWFpbTo6Q3JvdWNoaW5nX3lhd19tb2RpZmllciI6WyJEaXNhYmxlZCJdLCJhbnRpLWFpbTo6Q3JvdWNoaW5nX3lhd19yaWdodCI6WzI1LjBdLCJhbnRpLWFpbTo6SW4gQWlyX2JvZHlfeWF3IjpbdHJ1ZV0sImFudGktYWltOjpJbiBBaXJfZGVsYXkiOlszLjBdLCJhbnRpLWFpbTo6SW4gQWlyX2VuYWJsZWQiOlt0cnVlXSwiYW50aS1haW06OkluIEFpcl9mcmVlc3RhbmRpbmciOlsiT2ZmIl0sImFudGktYWltOjpJbiBBaXJfbGVmdF9saW1pdCI6WzU5LjBdLCJhbnRpLWFpbTo6SW4gQWlyX21vZGlmaWVyX29mZnNldCI6WzAuMF0sImFudGktYWltOjpJbiBBaXJfb3B0aW9ucyI6W1siSml0dGVyIl1dLCJhbnRpLWFpbTo6SW4gQWlyX3BpdGNoIjpbIkRvd24iXSwiYW50aS1haW06OkluIEFpcl9yaWdodF9saW1pdCI6WzU5LjBdLCJhbnRpLWFpbTo6SW4gQWlyX3lhdyI6WyJCYWNrd2FyZCJdLCJhbnRpLWFpbTo6SW4gQWlyX3lhd19iYXNlIjpbIkF0IFRhcmdldCJdLCJhbnRpLWFpbTo6SW4gQWlyX3lhd19sZWZ0IjpbLTMzLjBdLCJhbnRpLWFpbTo6SW4gQWlyX3lhd19tb2RpZmllciI6WyJEaXNhYmxlZCJdLCJhbnRpLWFpbTo6SW4gQWlyX3lhd19yaWdodCI6WzM4LjBdLCJhbnRpLWFpbTo6TW92aW5nX2JvZHlfeWF3IjpbdHJ1ZV0sImFudGktYWltOjpNb3ZpbmdfZGVsYXkiOlszLjBdLCJhbnRpLWFpbTo6TW92aW5nX2VuYWJsZWQiOlt0cnVlXSwiYW50aS1haW06Ok1vdmluZ19mcmVlc3RhbmRpbmciOlsiT2ZmIl0sImFudGktYWltOjpNb3ZpbmdfbGVmdF9saW1pdCI6WzU5LjBdLCJhbnRpLWFpbTo6TW92aW5nX21vZGlmaWVyX29mZnNldCI6WzAuMF0sImFudGktYWltOjpNb3Zpbmdfb3B0aW9ucyI6W1siSml0dGVyIl1dLCJhbnRpLWFpbTo6TW92aW5nX3BpdGNoIjpbIkRvd24iXSwiYW50aS1haW06Ok1vdmluZ19yaWdodF9saW1pdCI6WzU5LjBdLCJhbnRpLWFpbTo6TW92aW5nX3lhdyI6WyJCYWNrd2FyZCJdLCJhbnRpLWFpbTo6TW92aW5nX3lhd19iYXNlIjpbIkF0IFRhcmdldCJdLCJhbnRpLWFpbTo6TW92aW5nX3lhd19sZWZ0IjpbLTI5LjBdLCJhbnRpLWFpbTo6TW92aW5nX3lhd19tb2RpZmllciI6WyJEaXNhYmxlZCJdLCJhbnRpLWFpbTo6TW92aW5nX3lhd19yaWdodCI6WzM3LjBdLCJhbnRpLWFpbTo6U2hhcmVkX2JvZHlfeWF3IjpbZmFsc2VdLCJhbnRpLWFpbTo6U2hhcmVkX2RlbGF5IjpbMC4wXSwiYW50aS1haW06OlNoYXJlZF9mcmVlc3RhbmRpbmciOlsiT2ZmIl0sImFudGktYWltOjpTaGFyZWRfbGVmdF9saW1pdCI6WzYwLjBdLCJhbnRpLWFpbTo6U2hhcmVkX21vZGlmaWVyX29mZnNldCI6WzAuMF0sImFudGktYWltOjpTaGFyZWRfb3B0aW9ucyI6W1tdXSwiYW50aS1haW06OlNoYXJlZF9waXRjaCI6WyJEaXNhYmxlZCJdLCJhbnRpLWFpbTo6U2hhcmVkX3JpZ2h0X2xpbWl0IjpbNjAuMF0sImFudGktYWltOjpTaGFyZWRfeWF3IjpbIkRpc2FibGVkIl0sImFudGktYWltOjpTaGFyZWRfeWF3X2Jhc2UiOlsiTG9jYWwgVmlldyJdLCJhbnRpLWFpbTo6U2hhcmVkX3lhd19sZWZ0IjpbMC4wXSwiYW50aS1haW06OlNoYXJlZF95YXdfbW9kaWZpZXIiOlsiRGlzYWJsZWQiXSwiYW50aS1haW06OlNoYXJlZF95YXdfcmlnaHQiOlswLjBdLCJhbnRpLWFpbTo6U2xvdyBXYWxrX2JvZHlfeWF3IjpbdHJ1ZV0sImFudGktYWltOjpTbG93IFdhbGtfZGVsYXkiOlszLjBdLCJhbnRpLWFpbTo6U2xvdyBXYWxrX2VuYWJsZWQiOlt0cnVlXSwiYW50aS1haW06OlNsb3cgV2Fsa19mcmVlc3RhbmRpbmciOlsiT2ZmIl0sImFudGktYWltOjpTbG93IFdhbGtfbGVmdF9saW1pdCI6WzYwLjBdLCJhbnRpLWFpbTo6U2xvdyBXYWxrX21vZGlmaWVyX29mZnNldCI6WzAuMF0sImFudGktYWltOjpTbG93IFdhbGtfb3B0aW9ucyI6W1siSml0dGVyIl1dLCJhbnRpLWFpbTo6U2xvdyBXYWxrX3BpdGNoIjpbIkRvd24iXSwiYW50aS1haW06OlNsb3cgV2Fsa19yaWdodF9saW1pdCI6WzYwLjBdLCJhbnRpLWFpbTo6U2xvdyBXYWxrX3lhdyI6WyJCYWNrd2FyZCJdLCJhbnRpLWFpbTo6U2xvdyBXYWxrX3lhd19iYXNlIjpbIkF0IFRhcmdldCJdLCJhbnRpLWFpbTo6U2xvdyBXYWxrX3lhd19sZWZ0IjpbLTQyLjBdLCJhbnRpLWFpbTo6U2xvdyBXYWxrX3lhd19tb2RpZmllciI6WyJEaXNhYmxlZCJdLCJhbnRpLWFpbTo6U2xvdyBXYWxrX3lhd19yaWdodCI6WzQ2LjBdLCJhbnRpLWFpbTo6U3RhbmRpbmdfYm9keV95YXciOlt0cnVlXSwiYW50aS1haW06OlN0YW5kaW5nX2RlbGF5IjpbMC4wXSwiYW50aS1haW06OlN0YW5kaW5nX2VuYWJsZWQiOlt0cnVlXSwiYW50aS1haW06OlN0YW5kaW5nX2ZyZWVzdGFuZGluZyI6WyJPZmYiXSwiYW50aS1haW06OlN0YW5kaW5nX2xlZnRfbGltaXQiOls2MC4wXSwiYW50aS1haW06OlN0YW5kaW5nX21vZGlmaWVyX29mZnNldCI6WzAuMF0sImFudGktYWltOjpTdGFuZGluZ19vcHRpb25zIjpbWyJKaXR0ZXIiXV0sImFudGktYWltOjpTdGFuZGluZ19waXRjaCI6WyJEb3duIl0sImFudGktYWltOjpTdGFuZGluZ19yaWdodF9saW1pdCI6WzYwLjBdLCJhbnRpLWFpbTo6U3RhbmRpbmdfeWF3IjpbIkJhY2t3YXJkIl0sImFudGktYWltOjpTdGFuZGluZ195YXdfYmFzZSI6WyJBdCBUYXJnZXQiXSwiYW50aS1haW06OlN0YW5kaW5nX3lhd19sZWZ0IjpbLTIzLjBdLCJhbnRpLWFpbTo6U3RhbmRpbmdfeWF3X21vZGlmaWVyIjpbIkRpc2FibGVkIl0sImFudGktYWltOjpTdGFuZGluZ195YXdfcmlnaHQiOls0Mi4wXSwiYW50aS1haW06OmFuaW1hdGlvbl9icmVha2Vycy5lbmFibGVkIjpbdHJ1ZV0sImFudGktYWltOjphbmltYXRpb25fYnJlYWtlcnMubW92ZV9sZWFuX2ZvcmNlIjpbMTAwLjBdLCJhbnRpLWFpbTo6YW5pbWF0aW9uX2JyZWFrZXJzLm9uX2dyb3VuZF9mb3JjZSI6W2ZhbHNlXSwiYW50aS1haW06OmFuaW1hdGlvbl9icmVha2Vycy5vcHRpb25zIjpbWyJGb3JjZSBGYWxsaW5nIiwiU2tlZXQgTGVnIEZ1Y2tlciJdXSwiYW50aS1haW06OmF2b2lkX2JhY2tzdGFiLmVuYWJsZWQiOlt0cnVlXSwiYW50aS1haW06OmJ1aWxkZXIuY29uZGl0aW9uIjpbIlN0YW5kaW5nIl0sImFudGktYWltOjpidWlsZGVyLmVuYWJsZWQiOlt0cnVlXSwiYW50aS1haW06OmRlZmVuc2l2ZS5jb25kaXRpb24iOlsiU3RhbmRpbmciXSwiYW50aS1haW06OmRlZmVuc2l2ZS5lbmFibGVkIjpbZmFsc2VdLCJhbnRpLWFpbTo6ZGVmZW5zaXZlX0FpciBDcm91Y2hfZW5hYmxlZCI6W2ZhbHNlXSwiYW50aS1haW06OmRlZmVuc2l2ZV9BaXIgQ3JvdWNoX3BpdGNoIjpbIkRlZmF1bHQiXSwiYW50aS1haW06OmRlZmVuc2l2ZV9BaXIgQ3JvdWNoX3BpdGNoX29mZnNldCI6WzAuMF0sImFudGktYWltOjpkZWZlbnNpdmVfQWlyIENyb3VjaF95YXciOlsiRGVmYXVsdCJdLCJhbnRpLWFpbTo6ZGVmZW5zaXZlX0FpciBDcm91Y2hfeWF3X29mZnNldCI6WzAuMF0sImFudGktYWltOjpkZWZlbnNpdmVfQ3JvdWNoaW5nIE1vdmVfZW5hYmxlZCI6W2ZhbHNlXSwiYW50aS1haW06OmRlZmVuc2l2ZV9Dcm91Y2hpbmcgTW92ZV9waXRjaCI6WyJEZWZhdWx0Il0sImFudGktYWltOjpkZWZlbnNpdmVfQ3JvdWNoaW5nIE1vdmVfcGl0Y2hfb2Zmc2V0IjpbMC4wXSwiYW50aS1haW06OmRlZmVuc2l2ZV9Dcm91Y2hpbmcgTW92ZV95YXciOlsiRGVmYXVsdCJdLCJhbnRpLWFpbTo6ZGVmZW5zaXZlX0Nyb3VjaGluZyBNb3ZlX3lhd19vZmZzZXQiOlswLjBdLCJhbnRpLWFpbTo6ZGVmZW5zaXZlX0Nyb3VjaGluZ19lbmFibGVkIjpbZmFsc2VdLCJhbnRpLWFpbTo6ZGVmZW5zaXZlX0Nyb3VjaGluZ19waXRjaCI6WyJEZWZhdWx0Il0sImFudGktYWltOjpkZWZlbnNpdmVfQ3JvdWNoaW5nX3BpdGNoX29mZnNldCI6WzAuMF0sImFudGktYWltOjpkZWZlbnNpdmVfQ3JvdWNoaW5nX3lhdyI6WyJEZWZhdWx0Il0sImFudGktYWltOjpkZWZlbnNpdmVfQ3JvdWNoaW5nX3lhd19vZmZzZXQiOlswLjBdLCJhbnRpLWFpbTo6ZGVmZW5zaXZlX0luIEFpcl9lbmFibGVkIjpbZmFsc2VdLCJhbnRpLWFpbTo6ZGVmZW5zaXZlX0luIEFpcl9waXRjaCI6WyJEb3duIl0sImFudGktYWltOjpkZWZlbnNpdmVfSW4gQWlyX3BpdGNoX29mZnNldCI6WzAuMF0sImFudGktYWltOjpkZWZlbnNpdmVfSW4gQWlyX3lhdyI6WyJSYW5kb20iXSwiYW50aS1haW06OmRlZmVuc2l2ZV9JbiBBaXJfeWF3X29mZnNldCI6WzM3LjBdLCJhbnRpLWFpbTo6ZGVmZW5zaXZlX01vdmluZ19lbmFibGVkIjpbZmFsc2VdLCJhbnRpLWFpbTo6ZGVmZW5zaXZlX01vdmluZ19waXRjaCI6WyJEZWZhdWx0Il0sImFudGktYWltOjpkZWZlbnNpdmVfTW92aW5nX3BpdGNoX29mZnNldCI6WzAuMF0sImFudGktYWltOjpkZWZlbnNpdmVfTW92aW5nX3lhdyI6WyJEZWZhdWx0Il0sImFudGktYWltOjpkZWZlbnNpdmVfTW92aW5nX3lhd19vZmZzZXQiOlswLjBdLCJhbnRpLWFpbTo6ZGVmZW5zaXZlX1Nsb3cgV2Fsa19lbmFibGVkIjpbZmFsc2VdLCJhbnRpLWFpbTo6ZGVmZW5zaXZlX1Nsb3cgV2Fsa19waXRjaCI6WyJEZWZhdWx0Il0sImFudGktYWltOjpkZWZlbnNpdmVfU2xvdyBXYWxrX3BpdGNoX29mZnNldCI6WzAuMF0sImFudGktYWltOjpkZWZlbnNpdmVfU2xvdyBXYWxrX3lhdyI6WyJEZWZhdWx0Il0sImFudGktYWltOjpkZWZlbnNpdmVfU2xvdyBXYWxrX3lhd19vZmZzZXQiOlswLjBdLCJhbnRpLWFpbTo6ZGVmZW5zaXZlX1N0YW5kaW5nX2VuYWJsZWQiOltmYWxzZV0sImFudGktYWltOjpkZWZlbnNpdmVfU3RhbmRpbmdfcGl0Y2giOlsiRGVmYXVsdCJdLCJhbnRpLWFpbTo6ZGVmZW5zaXZlX1N0YW5kaW5nX3BpdGNoX29mZnNldCI6WzAuMF0sImFudGktYWltOjpkZWZlbnNpdmVfU3RhbmRpbmdfeWF3IjpbIkRlZmF1bHQiXSwiYW50aS1haW06OmRlZmVuc2l2ZV9TdGFuZGluZ195YXdfb2Zmc2V0IjpbMC4wXSwiYW50aS1haW06OmVkZ2VfeWF3LmVuYWJsZWQiOltmYWxzZV0sImFudGktYWltOjpmcmVlc3RhbmRpbmcuYm9keV9mcmVlc3RhbmRpbmciOltmYWxzZV0sImFudGktYWltOjpmcmVlc3RhbmRpbmcuZGlzYWJsZV95YXdfbW9kaWZpZXJzIjpbdHJ1ZV0sImFudGktYWltOjpmcmVlc3RhbmRpbmcuZW5hYmxlZCI6W2ZhbHNlXSwiYW50aS1haW06Om1hbnVhbF95YXcuYm9keV9mcmVlc3RhbmRpbmciOltmYWxzZV0sImFudGktYWltOjptYW51YWxfeWF3LmRpc2FibGVfeWF3X21vZGlmaWVycyI6W3RydWVdLCJhbnRpLWFpbTo6bWFudWFsX3lhdy5zZWxlY3QiOlsiRGlzYWJsZWQiXSwiYW50aS1haW06OnNhZmVfaGVhZC5jb25kaXRpb25zIjpbWyJLbmlmZSJdXSwiYW50aS1haW06OnNhZmVfaGVhZC5lbmFibGVkIjpbdHJ1ZV0sIm1vdmVtZW50OjpmYXN0X2xhZGRlci5lbmFibGVkIjpbdHJ1ZV0sIm90aGVyOjpjbGFudGFnLmVuYWJsZWQiOlt0cnVlXSwib3RoZXI6OnZpZXdtb2RlbC5lbmFibGVkIjpbdHJ1ZV0sIm90aGVyOjp2aWV3bW9kZWwuZm92IjpbNjgwLjBdLCJvdGhlcjo6dmlld21vZGVsLm9mZnNldF94IjpbMjAuMF0sIm90aGVyOjp2aWV3bW9kZWwub2Zmc2V0X3kiOlstOTAuMF0sIm90aGVyOjp2aWV3bW9kZWwub2Zmc2V0X3oiOlsxMy4wXSwib3RoZXI6OnZpZXdtb2RlbC5vcHBvc2l0ZV9rbmlmZV9oYW5kIjpbZmFsc2VdLCJyYWdlYm90OjphaW1ib3RfbG9ncy5lbmFibGVkIjpbdHJ1ZV0sInJhZ2Vib3Q6OmFpbWJvdF9sb2dzLm91dHB1dCI6W1siQ29uc29sZSIsIk5vdGlmeSJdXSwicmFnZWJvdDo6ZG9ybWFudF9haW1ib3QuYXV0b19zY29wZSI6W2ZhbHNlXSwicmFnZWJvdDo6ZG9ybWFudF9haW1ib3QuZGFtYWdlIjpbLTEuMF0sInJhZ2Vib3Q6OmRvcm1hbnRfYWltYm90LmVuYWJsZWQiOlt0cnVlXSwicmFnZWJvdDo6ZG9ybWFudF9haW1ib3QuaGl0Ym94ZXMiOltbIkNoZXN0IiwiU3RvbWFjaCJdXSwicmFnZWJvdDo6ZG9ybWFudF9haW1ib3QuaGl0Y2hhbmNlIjpbNjYuMF0sInJhZ2Vib3Q6OnBpbmdfc3Bpa2UuZW5hYmxlZCI6W2ZhbHNlXSwicmFnZWJvdDo6cGluZ19zcGlrZS52YWx1ZSI6WzIwMC4wXSwidmlzdWFsczo6YW50aWFpbV9hcnJvd3MuY29sb3IiOlsiTWFudWFsIix7IkRlc3luYyI6WyIwMEExRTdGRiJdLCJNYW51YWwiOlsiRDE2Q0Q3RkYiXX1dLCJ2aXN1YWxzOjphbnRpYWltX2Fycm93cy5lbmFibGVkIjpbZmFsc2VdLCJ2aXN1YWxzOjphbnRpYWltX2Fycm93cy50eXBlIjpbIkRlZmF1bHQiXSwidmlzdWFsczo6YXNwZWN0X3JhdGlvLmVuYWJsZWQiOlt0cnVlXSwidmlzdWFsczo6YXNwZWN0X3JhdGlvLnZhbHVlIjpbMTMzLjBdLCJ2aXN1YWxzOjpkYW1hZ2VfaW5kaWNhdG9yLmVuYWJsZWQiOltmYWxzZV0sInZpc3VhbHM6OmRhbWFnZV9pbmRpY2F0b3IuZm9udCI6WyJEZWZhdWx0Il0sInZpc3VhbHM6OmhpdF9tYXJrZXIuZW5hYmxlZCI6W3RydWVdLCJ2aXN1YWxzOjppbmRpY2F0ZV9zdGF0ZS5lbmFibGVkIjpbZmFsc2VdLCJ2aXN1YWxzOjpraWJpdF9tYXJrZXIuY29sb3IiOlsiVmVydGljYWwiLHsiSG9yaXpvbnRhbCI6WyIwMEZGRkZGRiJdLCJWZXJ0aWNhbCI6WyIwMEZGMDBGRiJdfV0sInZpc3VhbHM6OmtpYml0X21hcmtlci5lbmFibGVkIjpbZmFsc2VdLCJ2aXN1YWxzOjpzY29wZV9vdmVybGF5LmVuYWJsZWQiOlt0cnVlXSwidmlzdWFsczo6c2NvcGVfb3ZlcmxheS5vZmZzZXQiOlsxMC4wXSwidmlzdWFsczo6c2NvcGVfb3ZlcmxheS5wb3NpdGlvbiI6WzEwNS4wXSwidmlzdWFsczo6c2NvcGVfb3ZlcmxheS50X3N0eWxlIjpbZmFsc2VdfQ=="
                )

                if not ok then
                    logging.err(result)
                    return
                end

                local ok, result = config_system.import(result)

                if not ok then
                    logging.err(result)
                    return
                end

                logging.msg("Default config imported")
            end

            configs.export = groups.configs:button(pad_button(ui.get_icon "folder-arrow-up", "Export", 2), on_export, true)
            configs.import = groups.configs:button(pad_button(ui.get_icon "folder-arrow-down", "Import", 2), on_import, true)
            configs.default = groups.configs:button(pad_button(ui.get_icon "folder-gear", "Default", 3), on_default, true)
        end

        local controls = { } do
            local select = groups.controls:list("##SELECT", {
                "Main", "Socials"
            })

            select:set_callback(function(item)
                local value = item:get()

                local is_main = value == 1
                local is_socials = value == 2

                main.user:visibility(is_main)
                main.build:visibility(is_main)
                main.clock:visibility(is_main)

                socials.config:visibility(is_socials)
                socials.discord:visibility(is_socials)
                socials.youtube:visibility(is_socials)

                configs.export:visibility(is_main)
                configs.import:visibility(is_main)
                configs.default:visibility(is_main)
            end, true)
        end

        resource.home = home
    end

    local antiaim = { } do
        local groups = { } do
            local TAB = ui.get_icon "user-shield"

            groups.main = ui.create(TAB, "MAIN", LEFT_COLUMN)
            groups.other = ui.create(TAB, "##OTHER", LEFT_COLUMN)
            groups.builder = ui.create(TAB, "BUILDER", RIGHT_COLUMN)
            groups.builder_layout = ui.create(TAB, "##BUILDER_LAYOUT", RIGHT_COLUMN)
        end

        local manual_yaw = { } do
            manual_yaw.select = config_system.push(
                "Anti-Aim", "manual_yaw.select", groups.main:combo(
                    pad_label(ui.get_icon "arrows-up-down-left-right", "Manual Yaw", 0, 6), {
                        "Disabled",
                        "Left",
                        "Right",
                        "Forward",
                        "Backward"
                    }
                )
            )

            local group = manual_yaw.select:create() do
                manual_yaw.disable_yaw_modifiers = config_system.push(
                    "Anti-Aim", "manual_yaw.disable_yaw_modifiers", group:switch("Disable Yaw Modifiers")
                )

                manual_yaw.body_freestanding = config_system.push(
                    "Anti-Aim", "manual_yaw.body_freestanding", group:switch("Body Freestanding")
                )
            end

            antiaim.manual_yaw = manual_yaw
        end

        local freestanding = { } do
            freestanding.enabled = config_system.push(
                "Anti-Aim", "freestanding.enabled", groups.main:switch(
                    pad_label(ui.get_icon "arrows-cross", "Freestanding", 0, 7)
                )
            )

            local group = freestanding.enabled:create() do
                freestanding.disable_yaw_modifiers = config_system.push(
                    "Anti-Aim", "freestanding.disable_yaw_modifiers", group:switch("Disable Yaw Modifiers")
                )

                freestanding.body_freestanding = config_system.push(
                    "Anti-Aim", "freestanding.body_freestanding", group:switch("Body Freestanding")
                )
            end

            antiaim.freestanding = freestanding
        end

        local animation_breakers = { } do
            animation_breakers.enabled = config_system.push(
                "Anti-Aim", "animation_breakers.enabled", groups.other:switch(
                    pad_label(ui.get_icon "person-falling", "Animation Breakers", 1, 6)
                )
            )

            local group = animation_breakers.enabled:create() do
                animation_breakers.options = config_system.push(
                    "Anti-Aim", "animation_breakers.options", group:selectable("Options", {
                        "Landing Pitch",
                        "Static leg in air",
                        "Move Lean",
                        "Skeet Leg Fucker",
                        "Earthquake",
                        "Kangaroo"
                    })
                )

                animation_breakers.move_lean_force = config_system.push(
                    "Anti-Aim", "animation_breakers.move_lean_force", group:slider(
                        "Move Lean Force", 0, 100, 100, nil, "%"
                    )
                )

                animation_breakers.on_ground_force = config_system.push(
                    "Anti-Aim", "animation_breakers.on_ground_force", group:switch("On Ground Force")
                )

                animation_breakers.options:set_callback(function(item)
                    local is_move_lean = item:get "Move Lean"

                    animation_breakers.move_lean_force:visibility(is_move_lean)
                    animation_breakers.on_ground_force:visibility(is_move_lean)
                end, true)
            end

            antiaim.animation_breakers = animation_breakers
        end

        local avoid_backstab = { } do
            avoid_backstab.enabled = config_system.push(
                "Anti-Aim", "avoid_backstab.enabled", groups.other:switch(
                    pad_label(ui.get_icon "knife-kitchen", "Avoid Backstab", 0, 5)
                )
            )

            antiaim.avoid_backstab = avoid_backstab
        end

        local safe_head = { } do
            safe_head.enabled = config_system.push(
                "Anti-Aim", "safe_head.enabled", groups.other:switch(
                    pad_label(ui.get_icon "head-side-medical", "Safe Head", 0, 6)
                )
            )

            local group = safe_head.enabled:create() do
                safe_head.conditions = config_system.push(
                    "Anti-Aim", "safe_head.conditions", group:selectable("Conditions", {
                        "Knife", "Zeus", "Distance"
                    })
                )
            end

            antiaim.safe_head = safe_head
        end

        local edge_yaw = { } do
            edge_yaw.enabled = config_system.push(
                "Anti-Aim", "edge_yaw.enabled", groups.other:switch(
                    pad_label(ui.get_icon "rotate", "Edge Yaw", 0, 6)
                )
            )

            antiaim.edge_yaw = edge_yaw
        end

        local defensive = { } do
            local condition_list = {
                "Standing",
                "Moving",
                "Slow Walk",
                "Crouching",
                "Crouching Move",
                "In Air",
                "Air Crouch"
            }

            local function create_condition(condition, group)
                local list = { }

                list.enabled = config_system.push(
                    "Anti-Aim", "defensive_" .. condition .. "_enabled", group:switch(
                        "Enable " .. condition .. "##" .. condition
                    )
                )

                list.pitch = config_system.push(
                    "Anti-Aim", "defensive_" .. condition .. "_pitch", group:combo(
                        "Pitch" .. "##" .. condition, { "Default", "Up", "Down", "Zero", "Random", "Progressive", "Custom" }
                    )
                )

                list.pitch_offset = config_system.push(
                    "Anti-Aim", "defensive_" .. condition .. "_pitch_offset", group:slider(
                        "Offset" .. "##" .. condition, -89, 89, 0, nil
                    )
                )

                list.yaw = config_system.push(
                    "Anti-Aim", "defensive_" .. condition .. "_yaw", group:combo(
                        "Yaw" .. "##" .. condition, { "Default", "Jitter", "Opposite", "Spin", "Random", "Custom" }
                    )
                )

                list.yaw_offset = config_system.push(
                    "Anti-Aim", "defensive_" .. condition .. "_yaw_offset", group:slider(
                        "Offset" .. "##" .. condition, -180, 180, 0, nil
                    )
                )

                return list
            end

            local function create_layout(group)
                local layout = { }

                for i = 1, #condition_list do
                    local condition = condition_list[i]

                    layout[condition] = create_condition(
                        condition, group
                    )
                end

                return layout
            end

            defensive.enabled = config_system.push(
                "Anti-Aim", "defensive.enabled", groups.other:switch(
                    pad_label(ui.get_icon "person-walking-dashed-line-arrow-right", "Defensive", 0, 4)
                )
            )

            local group = defensive.enabled:create() do
                defensive.condition = config_system.push(
                    "Anti-Aim", "defensive.condition", group:combo(
                        "Condition", condition_list
                    )
                )

                defensive.layout = create_layout(group)
            end

            defensive.list = condition_list
            antiaim.defensive = defensive
        end

        local builder = { } do
            local condition_list = {
                "Shared",
                "Standing",
                "Moving",
                "Slow Walk",
                "Crouching",
                "Crouching Move",
                "In Air",
                "Air Crouch"
            }

            local function create_condition(condition)
                local list = { }

                if condition ~= "Shared" then
                    list.enabled = config_system.push(
                        "Anti-Aim", condition .. "_enabled", groups.builder_layout:switch(
                            "Enable " .. condition
                        )
                    )
                end

                list.pitch = config_system.push(
                    "Anti-Aim", condition .. "_pitch", groups.builder_layout:combo(
                        "Pitch", software.aa.angles.pitch:list()
                    )
                )

                list.yaw = config_system.push(
                    "Anti-Aim", condition .. "_yaw", groups.builder_layout:combo(
                        "Yaw", software.aa.angles.yaw[1]:list()
                    )
                )
                do
                    local group = list.yaw:create()

                    list.yaw_base = config_system.push(
                        "Anti-Aim", condition .. "_yaw_base", group:combo(
                            "Base", software.aa.angles.yaw[2]:list()
                        )
                    )

                    list.yaw_left = config_system.push(
                        "Anti-Aim", condition .. "_yaw_left", group:slider(
                            "Left Offset", -180, 180, 0, nil
                        )
                    )

                    list.yaw_right = config_system.push(
                        "Anti-Aim", condition .. "_yaw_right", group:slider(
                            "Right Offset", -180, 180, 0, nil
                        )
                    )
                end

                list.yaw_modifier = config_system.push(
                    "Anti-Aim", condition .. "_yaw_modifier", groups.builder_layout:combo(
                        "Yaw Modifier", software.aa.angles.yaw_modifier[1]:list()
                    )
                )

                do
                    local group = list.yaw_modifier:create()

                    list.modifier_offset = config_system.push(
                        "Anti-Aim", condition .. "_modifier_offset", group:slider(
                            "Offset", -180, 180, 0, nil
                        )
                    )
                end

                list.body_yaw = config_system.push(
                    "Anti-Aim", condition .. "_body_yaw", groups.builder_layout:switch("Body Yaw")
                )

                do
                    local group = list.body_yaw:create()

                    list.left_limit = config_system.push(
                        "Anti-Aim", condition .. "_left_limit", group:slider(
                            "Left Limit", 0, 60, 60, nil
                        )
                    )

                    list.right_limit = config_system.push(
                        "Anti-Aim", condition .. "_right_limit", group:slider(
                            "Right Limit", 0, 60, 60, nil
                        )
                    )

                    list.options = config_system.push(
                        "Anti-Aim", condition .. "_options", group:selectable(
                            "Options", software.aa.angles.body_yaw[5]:list()
                        )
                    )

                    list.delay = config_system.push(
                        "Anti-Aim", condition .. "_delay", group:slider(
                            "Delay", 0, 8, 0, nil
                        )
                    )

                    list.freestanding = config_system.push(
                        "Anti-Aim", condition .. "_freestanding", group:combo(
                            "Freestanding", software.aa.angles.body_yaw[6]:list()
                        )
                    )

                    list.options:set_callback(function(item)
                        list.delay:visibility(item:get "Jitter")
                    end, true)
                end

                return list
            end

            local function create_layout()
                local layout = { }

                for i = 1, #condition_list do
                    local condition = condition_list[i]

                    layout[condition] = create_condition(
                        condition
                    )
                end

                return layout
            end

            builder.enabled = config_system.push(
                "Anti-Aim", "builder.enabled", groups.builder:switch(
                    pad_label(ui.get_icon "sliders", "Builder", 0, 7)
                )
            )

            builder.condition = config_system.push(
                "Anti-Aim", "builder.condition", groups.builder:combo(
                    pad_label(ui.get_icon "pen", "Condition", 0, 7), condition_list
                )
            )

            builder.list = condition_list
            builder.layout = create_layout()

            antiaim.builder = builder
        end

        resource.antiaim = antiaim
    end

    local misc = { } do
        local groups = { } do
            local TAB = ui.get_icon "gears"

            groups.ragebot = ui.create(TAB, "##RAGEBOT", LEFT_COLUMN)
            groups.panels = ui.create(TAB, "##PANELS", LEFT_COLUMN)

            groups.visuals = ui.create(TAB, "##VISUALS", RIGHT_COLUMN)
            groups.other = ui.create(TAB, "##OTHER", RIGHT_COLUMN)
        end

        local aimbot_logs = { } do
            aimbot_logs.enabled = config_system.push(
                "Ragebot", "aimbot_logs.enabled", groups.ragebot:switch(
                    pad_label(ui.get_icon "message-lines", "Aimbot Logs", 0, 7)
                )
            )

            local group = aimbot_logs.enabled:create() do
                aimbot_logs.output = config_system.push(
                    "Ragebot", "aimbot_logs.output", group:selectable("Output", {
                        "Console", "Notify", "Render"
                    })
                )
            end

            misc.aimbot_logs = aimbot_logs
        end

        local aspect_ratio = { } do
            local function pad_simple(name, count)
                return pad(count) .. name .. pad(count)
            end

            local lookup = {
                [125] = "5:4",
                [133] = "4:3",
                [166] = "16:9",
                [160] = "16:10"
            }

            aspect_ratio.enabled = config_system.push(
                "Visuals", "aspect_ratio.enabled", groups.ragebot:switch(
                    pad_label(ui.get_icon "display-code", "Aspect Ratio", 0, 6)
                )
            )

            local group = aspect_ratio.enabled:create() do
                aspect_ratio.value = config_system.push(
                    "Visuals", "aspect_ratio.value", group:slider(
                        "Ratio", 0, 200, 0, 0.01, function(value)
                            return lookup[value] or nil
                        end
                    )
                )

                group:button(pad_simple("5:4", 6), function()
                    aspect_ratio.value:set(125)
                end, true)

                group:button(pad_simple("4:3", 6), function()
                    aspect_ratio.value:set(133)
                end, true)

                group:button(pad_simple("16:9", 6), function()
                    aspect_ratio.value:set(166)
                end, true)

                group:button(pad_simple("16:10", 5), function()
                    aspect_ratio.value:set(160)
                end, true)
            end

            misc.aspect_ratio = aspect_ratio
        end

        local dormant_aimbot = { } do
            dormant_aimbot.enabled = config_system.push(
                "Ragebot", "dormant_aimbot.enabled", groups.ragebot:switch(
                    pad_label(ui.get_icon "block-brick", "Dormant Aimbot", 1, 7)
                )
            )

            local group = dormant_aimbot.enabled:create() do
                dormant_aimbot.hitboxes = config_system.push(
                    "Ragebot", "dormant_aimbot.hitboxes", group:selectable("Hitboxes", {
                        "Head", "Chest", "Stomach", "Legs"
                    })
                )

                dormant_aimbot.hitchance = config_system.push(
                    "Ragebot", "dormant_aimbot.hitchance", group:slider(
                        "Accuracy", 50, 85, 60, nil, "%"
                    )
                )

                dormant_aimbot.damage = config_system.push(
                    "Ragebot", "dormant_aimbot.damage", group:slider(
                        "Min. Damage", -1, 130, -1, nil, function(value)
                            if value == -1 then
                                return "Auto"
                            end

                            if value > 100 then
                                return "+" .. (value - 100)
                            end

                            return nil
                        end
                    )
                )

                dormant_aimbot.auto_scope = config_system.push(
                    "Ragebot", "dormant_aimbot.auto_scope", group:switch("Auto Scope")
                )
            end

            misc.dormant_aimbot = dormant_aimbot
        end

        local ping_spike = { } do
            ping_spike.enabled = config_system.push(
                "Ragebot", "ping_spike.enabled", groups.ragebot:switch(
                    pad_label(ui.get_icon "signal-bars", "Ping Spike", 0, 6)
                )
            )

            local group = ping_spike.enabled:create() do
                ping_spike.value = config_system.push(
                    "Ragebot", "ping_spike.value", group:slider(
                        "Fake Latency", 0, 200, 0, nil
                    )
                )
            end

            misc.ping_spike = ping_spike
        end

        local fast_ladder = { } do
            fast_ladder.enabled = config_system.push(
                "Movement", "fast_ladder.enabled", groups.ragebot:switch(
                    pad_label(ui.get_icon "water-ladder", "Fast Ladder", 0, 6)
                )
            )

            misc.fast_ladder = fast_ladder
        end

        local clantag = { } do
            clantag.enabled = config_system.push(
                "Other", "clantag.enabled", groups.other:switch(
                    pad_label(ui.get_icon "signature", "Clantag", 0, 5)
                )
            )

            misc.clantag = clantag
        end

        local viewmodel = { } do
            viewmodel.enabled = config_system.push(
                "Other", "viewmodel.enabled", groups.other:switch(
                    pad_label(ui.get_icon "camera-viewfinder", "Viewmodel", 0, 7)
                )
            )

            local group = viewmodel.enabled:create() do
                viewmodel.fov = config_system.push(
                    "Other", "viewmodel.fov", group:slider(
                        "Field of View", 0, 1000, 680, 0.1
                    )
                )

                viewmodel.offset_x = config_system.push(
                    "Other", "viewmodel.offset_x", group:slider(
                        "Offset X", -100, 100, 25, 0.1
                    )
                )

                viewmodel.offset_y = config_system.push(
                    "Other", "viewmodel.offset_y", group:slider(
                        "Offset Y", -100, 100, 0, 0.1
                    )
                )

                viewmodel.offset_z = config_system.push(
                    "Other", "viewmodel.offset_z", group:slider(
                        "Offset Z", -100, 100, -15, 0.1
                    )
                )

                viewmodel.opposite_knife_hand = config_system.push(
                    "Other", "viewmodel.opposite_knife_hand", group:switch("Opposite knife hand")
                )
            end

            misc.viewmodel = viewmodel
        end

        local watermark = { } do
            watermark.enabled = groups.panels:switch(
                pad_label(ui.get_icon "marker", "Watermark", 1, 5)
            )

            misc.watermark = watermark
        end

        local keybinds = { } do
            keybinds.enabled = groups.panels:switch(
                pad_label(ui.get_icon "keyboard", "Keybinds", 0, 5)
            )

            misc.keybinds = keybinds
        end

        local spectators = { } do
            spectators.enabled = groups.panels:switch(
                pad_label(ui.get_icon "eye", "Spectators", 0, 5)
            )

            misc.spectators = spectators
        end

        local antiaim_arrows = { } do
            antiaim_arrows.enabled = config_system.push(
                "Visuals", "antiaim_arrows.enabled", groups.visuals:switch(
                    pad_label(ui.get_icon "arrows-left-right-to-line", "Anti-Aim Arrows", 0, 4)
                )
            )

            local group = antiaim_arrows.enabled:create() do
                antiaim_arrows.color = config_system.push(
                    "Visuals", "antiaim_arrows.color", group:color_picker("Color", {
                        ["Manual"] = { color "D16CD7FF" },
                        ["Desync"] = { color "00A1E7FF" }
                    })
                )

                antiaim_arrows.type = config_system.push(
                    "Visuals", "antiaim_arrows.type", group:combo("Type", {
                        "Default",
                        "Team Skeet"
                    })
                )
            end

            misc.antiaim_arrows = antiaim_arrows
        end

        local indicate_state = { } do
            indicate_state.enabled = config_system.push(
                "Visuals", "indicate_state.enabled", groups.visuals:switch(
                    pad_label(ui.get_icon "barcode", "Indicate State", 0, 6)
                )
            )

            misc.indicate_state = indicate_state
        end

        local damage_indicator = { } do
            damage_indicator.enabled = config_system.push(
                "Visuals", "damage_indicator.enabled", groups.visuals:switch(
                    pad_label(ui.get_icon "hundred-points", "Damage Indicator", 0, 6)
                )
            )

            local group = damage_indicator.enabled:create() do
                damage_indicator.color = config_system.push(
                    "Visuals", "damage_indicator.color", group:color_picker("Color")
                )

                damage_indicator.font = config_system.push(
                    "Visuals", "damage_indicator.font", group:combo("Font", {
                        "Default", "Small"
                    })
                )
            end

            misc.damage_indicator = damage_indicator
        end

        local scope_overlay = { } do
            scope_overlay.enabled = config_system.push(
                "Visuals", "scope_overlay.enabled", groups.visuals:switch(
                    pad_label(ui.get_icon "crosshairs", "Scope Overlay", 0, 6)
                )
            )

            local group = scope_overlay.enabled:create() do
                scope_overlay.color = config_system.push(
                    "Visuals", "scope_overlay.color", group:color_picker("Color")
                )

                scope_overlay.position = config_system.push(
                    "Visuals", "scope_overlay.position", group:slider(
                        "Position", 0, 500, 105, nil, "px"
                    )
                )

                scope_overlay.offset = config_system.push(
                    "Visuals", "scope_overlay.offset", group:slider(
                        "Offset", 0, 500, 10, nil, "px"
                    )
                )

                scope_overlay.t_style = config_system.push(
                    "Visuals", "scope_overlay.t_style", group:switch("T Style")
                )
            end

            misc.scope_overlay = scope_overlay
        end

        local hit_marker = { } do
            hit_marker.enabled = config_system.push(
                "Visuals", "hit_marker.enabled", groups.visuals:switch(
                    pad_label(ui.get_icon "xmark-large", "Hit Marker", 0, 7)
                )
            )

            local group = hit_marker.enabled:create() do
                hit_marker.color = config_system.push(
                    "Visuals", "hit_marker.color", group:color_picker("Color")
                )
            end

            misc.hit_marker = hit_marker
        end

        local kibit_marker = { } do
            kibit_marker.enabled = config_system.push(
                "Visuals", "kibit_marker.enabled", groups.visuals:switch(
                    pad_label(ui.get_icon "plus-large", "Kibit Marker", 0, 6)
                )
            )

            local group = kibit_marker.enabled:create() do
                kibit_marker.color = config_system.push(
                    "Visuals", "kibit_marker.color", group:color_picker("Color", {
                        ["Vertical"] = { color "00FF00FF" },
                        ["Horizontal"] = { color "00FFFFFF" }
                    })
                )
            end

            misc.kibit_marker = kibit_marker
        end

        resource.misc = misc
    end
end

local fonts do
    fonts = { }

    fonts.container = render.load_font("museo500", vector(13, 13, 1), "a")
    fonts.verdana_bold = render.load_font("verdana", 13, "ab")
end

local container do
    container = { }

    local radius = 8

    local function get_border_color(style)
        return style["Border"]
    end

    local function get_glow_color(style)
        local accent = style["Link Active"]
        local h, s, l, a = accent:to_hsl()

        return color():as_hsl(h, s - 0.25, l - 0.1, a * 0.75)
    end

    local function get_lower_color(style)
        local main_bg = style["Main Window Background"]
        local h, s, l, a = main_bg:to_hsl()

        return color():as_hsl(h, s, l + 0.05, a)
    end

    local function get_upper_color(style)
        return style["Main Window Background"]
    end

    function container.draw(pos_a, pos_b, style, alpha)
        local border = get_border_color(style)

        local upper = get_upper_color(style)
        local lower = get_lower_color(style)

        if alpha ~= nil then
            border = border:alpha_modulate(border.a * alpha)

            upper = upper:alpha_modulate(upper.a * alpha)
            lower = lower:alpha_modulate(lower.a * alpha)
        end

        render.gradient(pos_a, pos_b, upper, upper, lower, lower, radius)
        render.rect_outline(pos_a, pos_b, border, 1, radius)
    end

    function container.line(pos_a, pos_b, style, alpha)
        local width = (pos_b.x - pos_a.x) * 0.5 do
            width = width - (radius * 2)
            width = width * 0.66
        end

        if width < 5 then
            return
        end

        local center_x = (pos_a.x + pos_b.x) * 0.5
        local under_y = pos_b.y - 1

        local clr_a = get_glow_color(style)
        local clr_b = clr_a:alpha_modulate(0)

        if alpha ~= nil then
            clr_a = clr_a:alpha_modulate(clr_a.a * alpha)
        end

        render.gradient(
            vector(center_x, under_y),
            vector(center_x - width, under_y - 1),
            clr_a, clr_b, clr_a, clr_b
        )

        render.gradient(
            vector(center_x, under_y),
            vector(center_x + width, under_y - 1),
            clr_a, clr_b, clr_a, clr_b
        )
    end
end

local ragebot do
    local ragebot_logs do
        local PADDING_W = 8
        local PADDING_H = 8

        local ICON_MARGIN = 5
        local GAP_BETWEEN = 5

        local HIT_COLOR = "{Link Active}"
        local MISS_COLOR = "FF5050FF"

        local e_hitgroup = {
            [0]  = "generic",
            [1]  = "head",
            [2]  = "chest",
            [3]  = "stomach",
            [4]  = "chest",
            [5]  = "chest",
            [6]  = "legs",
            [7]  = "legs",
            [8]  = "head",
            [10] = "gear"
        }

        local renderables = { }

        local is_console_output = false
        local is_notify_output = false
        local is_render_output = false

        local function get_hitgroup(id)
            return e_hitgroup[id] or "?"
        end

        local function color_fmt(fmt, clr)
            local repl = string.format("\a%s%%1\aDEFAULT", clr)
            local result = fmt:gsub("%${(.-)}", repl)

            return result
        end

        local function push_renderable(hex, text)
            local data = { } do
                data.hex = hex
                data.text = text

                data.time = globals.realtime + 3
                data.alpha = smoothy.new(0.0)
            end

            table.insert(renderables, data)
            return data
        end

        local function on_render()
            local font = fonts.container
            local time = globals.realtime

            local screen = render.screen_size()
            local position = vector(screen.x * 0.5, screen.y * 0.8)

            local style = ui.get_style()
            local icon = ui.get_icon "trophy"

            local count = #renderables

            local text_color = style["Text"]

            for i = count, 1, -1 do
                local data = renderables[i]
                local order = count - i + 1

                local is_timed_out = time > data.time or order > 6
                local alpha = data.alpha:update(0.1, not is_timed_out)

                if is_timed_out and alpha <= 0.01 then
                    table.remove(renderables, i)
                end
            end

            for i = 1, #renderables do
                local data = renderables[i]

                local text = data.text
                local alpha = data.alpha.value

                local initial_pos = position:clone()

                local icon_size = render.measure_text(font, "s", icon)
                local text_size = render.measure_text(font, "s", text)

                local icon_rect = icon_size + vector(PADDING_W, PADDING_H) * 2.0
                local text_rect = text_size + vector(PADDING_W, PADDING_H) * 2.0

                local mod_text_color = text_color:alpha_modulate(text_color.a * alpha)

                local max_size = vector(
                    icon_rect.x + text_rect.x + ICON_MARGIN,
                    math.max(icon_rect.y, text_rect.y)
                )

                initial_pos.x = initial_pos.x - max_size.x * 0.5

                local icon_render do
                    container.draw(initial_pos, initial_pos + icon_rect, style, alpha)
                    render.text(font, initial_pos + (icon_rect - icon_size) * 0.5, mod_text_color, "s", "\a" .. data.hex .. icon)

                    initial_pos.x = initial_pos.x + icon_rect.x + ICON_MARGIN
                end

                local text_render do
                    local rect_pos = initial_pos:clone()

                    local text_pos = rect_pos + (text_rect - text_size) * 0.5
                    text_pos.y = text_pos.y - 1

                    container.draw(rect_pos, rect_pos + text_rect, style, alpha)
                    render.text(font, text_pos, mod_text_color, "s", text)
                end

                position.y = position.y - (max_size.y + GAP_BETWEEN) * alpha
            end
        end

        local function on_aim_hit(e)
            local target = e.target
            local damage = e.damage

            local backtrack = e.backtrack
            local hitchance = e.hitchance

            local name = target:get_name()
            local hitgroup = get_hitgroup(e.hitgroup)

            if is_console_output then
                local fmt = string.format(
                    "Hit ${%s}\'s ${%s} for ${%d} damage (hitchance: ${%d%%}, history: ${%dt})",
                    name, hitgroup, damage, hitchance, backtrack
                )

                logging.raw(color_fmt(fmt, HIT_COLOR))
            end

            if is_notify_output then
                local fmt = string.format(
                    "Hit ${%s}\'s ${%s} for ${%d} damage",
                    name, hitgroup, damage
                )

                print_dev(color_fmt(fmt, HIT_COLOR))
            end

            if is_render_output then
                local fmt = string.format(
                    "Hit ${%s}\'s ${%s} for ${%d} damage",
                    name, hitgroup, damage
                )

                push_renderable(HIT_COLOR, color_fmt(fmt, HIT_COLOR))
            end
        end

        local function on_aim_miss(e)
            local state = e.state
            local target = e.target

            local backtrack = e.backtrack
            local hitchance = e.hitchance

            local name = target:get_name()
            local hitgroup = get_hitgroup(e.wanted_hitgroup)

            if is_console_output then
                local fmt = string.format(
                    "Missed ${%s}\'s ${%s} due to ${%s} (hitchance: ${%d%%}, history: ${%dt})",
                    name, hitgroup, state, hitchance, backtrack
                )

                logging.raw(color_fmt(fmt, MISS_COLOR))
            end

            if is_notify_output then
                local fmt = string.format(
                    "Missed ${%s}\'s ${%s} due to ${%s}",
                    name, hitgroup, state
                )

                print_dev(color_fmt(fmt, MISS_COLOR))
            end

            if is_render_output then
                local fmt = string.format(
                    "Missed ${%s}\'s ${%s} due to ${%s}",
                    name, hitgroup, state
                )

                push_renderable(MISS_COLOR, color_fmt(fmt, MISS_COLOR))
            end
        end

        local function on_aim_ack(e)
            if e.state ~= nil then
                on_aim_miss(e)
            else
                on_aim_hit(e)
            end
        end

        local function on_dormant_hit(e)
            local target = e.userid
            local damage = e.dmg_health

            local name = target:get_name()
            local hitgroup = get_hitgroup(e.hitgroup)

            if is_console_output then
                local fmt = string.format(
                    "${Dormant} hit ${%s}\'s ${%s} for ${%d} damage",
                    name, hitgroup, damage
                )

                logging.raw(color_fmt(fmt, HIT_COLOR))
            end

            if is_notify_output then
                local fmt = string.format(
                    "${Dormant} hit ${%s}\'s ${%s} for ${%d} damage",
                    name, hitgroup, damage
                )

                print_dev(color_fmt(fmt, HIT_COLOR))
            end

            if is_render_output then
                local fmt = string.format(
                    "${Dormant} hit ${%s}\'s ${%s} for ${%d} damage",
                    name, hitgroup, damage
                )

                push_renderable(HIT_COLOR, color_fmt(fmt, HIT_COLOR))
            end
        end

        local function on_dormant_miss(e)
            local target = e.userid

            local accuracy = math.floor(0.5 + e.accuracy * 100)

            local name = target:get_name()
            local hitbox = e.aim_hitbox:lower()

            if is_console_output then
                local fmt = string.format(
                    "${Dormant} miss ${%s}\'s ${%s} (accuracy: ${%d%%})",
                    name, hitbox, accuracy
                )

                logging.raw(color_fmt(fmt, MISS_COLOR))
            end

            if is_notify_output then
                local fmt = string.format(
                    "${Dormant} miss ${%s}\'s ${%s}",
                    name, hitbox
                )

                print_dev(color_fmt(fmt, MISS_COLOR))
            end

            if is_render_output then
                local fmt = string.format(
                    "${Dormant} miss ${%s}\'s ${%s}",
                    name, hitbox
                )

                push_renderable(MISS_COLOR, color_fmt(fmt, MISS_COLOR))
            end
        end

        local namespace = resource.misc.aimbot_logs do
            local function on_output(item)
                is_console_output = item:get "Console"
                is_notify_output = item:get "Notify"
                is_render_output = item:get "Render"

                events.render(on_render, is_render_output)
            end

            local function on_enabled(item)
                local value = item:get()

                if value then
                    namespace.output:set_callback(on_output, true)
                else
                    namespace.output:unset_callback(on_output)
                    events.render(on_render, false)
                end

                events.aim_ack(on_aim_ack, value)

                events.dormant_hit(on_dormant_hit, value)
                events.dormant_miss(on_dormant_miss, value)
            end

            namespace.enabled:set_callback(on_enabled, true)
        end
    end

    local dormant_aimbot do
        local WEAPONTYPE_SNIPER_RIFLE = 5

        local aim_target
        local aim_point
        local aim_hitbox
        local aim_damage
        local aim_accuracy

        local is_hit = false
        local is_shot = false

        local target_index = 1
        local round_started = 0.0

        local e_hitbox = {
            [0]  = "Generic",
            [1]  = "Head",
            [2]  = "Chest",
            [3]  = "Stomach",
            [4]  = "Chest",
            [5]  = "Chest",
            [6]  = "Legs",
            [7]  = "Legs",
            [8]  = "Head",
            [10] = "Gear"
        }

        local hitbox_points = {
            {
                scale = 5,
                hitbox = "Stomach",
                vec = vector(0, 0, 40)
            },

            {
                scale = 6,
                hitbox = "Chest",
                vec = vector(0, 0, 50)
            },

            {
                scale = 3,
                hitbox = "Head",
                vec = vector(0, 0, 58)
            },

            {
                scale = 4,
                hitbox = "Legs",
                vec = vector(0, 0, 20)
            }
        }

        local function contains(list, value)
            for i = 1, #list do
                if list[i] == value then
                    return true
                end
            end

            return false
        end

        local function is_weapon_gun(type)
            return type >= 1 and type <= 6
        end

        local function get_aimbot_targets()
            local list = { }

            local player_resource = entity.get_player_resource()

            for i = 1, globals.max_players do
                local player = entity.get(i)

                if player == nil then
                    goto continue
                end

                local is_target_valid = player_resource.m_bConnected[i]
                    and player:is_enemy() and player:is_dormant()

                if not is_target_valid then
                    goto continue
                end

                table.insert(list, player)
                ::continue::
            end

            return list
        end

        local function create_multipoints(from, to, radius)
            local angles = from:to(to):angles()
            local radian = math.rad(angles.y + 90)

            local forward = vector(math.cos(radian), math.sin(radian), 0)
            local direction = forward * radius

            return {
                {
                    text = "Middle",
                    vec = to
                },

                {
                    text = "Left",
                    vec = to + direction
                },

                {
                    text = "Right",
                    vec = to - direction
                }
            }
        end

        local function trace_bullet(player, start_pos, end_pos, skip)
            local damage, trace = utils.trace_bullet(player, start_pos, end_pos, skip)

            if trace ~= nil then
                local ent = trace.entity

                if ent == nil then
                    return 0, trace
                end

                if ent:is_player() and not ent:is_enemy() then
                    return 0, trace
                end
            end

            return damage, trace
        end

        local function on_createmove(cmd)
            software.rage.main.enabled[2]:override(false)

            local me = entity.get_local_player()

            if me == nil then
                return
            end

            local weapon = me:get_player_weapon()

            if weapon == nil then
                return
            end

            local weapon_info = weapon:get_weapon_info()

            if weapon_info == nil then
                return
            end

            local inaccuracy = weapon:get_inaccuracy()

            if inaccuracy == nil then
                return
            end

            local tickcount = globals.tickcount

            local eye_pos = me:get_eye_position()
            local simtime = me:get_simulation_time().current

            local onground = bit.band(me.m_fFlags, bit.lshift(1, 0)) ~= 0

            if tickcount < round_started then
                return
            end

            if cmd.in_jump and not onground then
                return
            end

            local weapon_type = weapon_info.weapon_type

            if not is_weapon_gun(weapon_type) or weapon.m_iClip1 <= 0 then
                return false
            end

            local targets = get_aimbot_targets()
            local hitboxes = resource.misc.dormant_aimbot.hitboxes:get()

            if tickcount % #targets ~= 0 then
                target_index = target_index + 1
            else
                target_index = 1
            end

            local target = targets[target_index]

            if target == nil then
                return
            end

            local bbox = target:get_bbox()
            local origin = target:get_origin()

            local duck_amount = target.m_flDuckAmount

            local hitchance = resource.misc.dormant_aimbot.hitchance:get()
            local desired_damage = resource.misc.dormant_aimbot.damage:get()

            if desired_damage == -1 then
                desired_damage = software.rage.selection.min_damage:get()
            end

            if desired_damage > 100 then
                desired_damage = desired_damage - 100 + target.m_iHealth
            end

            local points = { }

            for i = 1, #hitbox_points do
                local data = hitbox_points[i]

                local vec = data.vec
                local scale = data.scale
                local hitbox = data.hitbox

                if hitbox == "Head" then
                    vec = vec - vector(0, 0, 10 * duck_amount)
                end

                if hitbox == "Chest" then
                    vec = vec - vector(0, 0, 4 * duck_amount)
                end

                if #hitboxes ~= 0 then
                    if contains(hitboxes, hitbox) then
                        table.insert(points, {
                            vec = vec,
                            scale = scale,
                            hitbox = hitbox
                        })
                    end
                else
                    table.insert(points, 1, {
                        vec = vec,
                        scale = scale,
                        hitbox = hitbox
                    })
                end
            end

            local is_available_to_shoot = weapon_info.is_revolver and weapon.m_flNextPrimaryAttack < simtime
                or math.max(me.m_flNextAttack, weapon.m_flNextPrimaryAttack, weapon.m_flNextSecondaryAttack) < simtime

            if not is_available_to_shoot then
                return
            end

            local found_pos
            local found_damage

            if hitchance >= math.floor(bbox.alpha * 100) + 5 then
                return
            end

            for j = 1, #points do
                local point = points[j]
                local multipoints = create_multipoints(eye_pos, origin + point.vec, point.scale)

                for k = 1, #multipoints do
                    local multipoint = multipoints[k]
                    local aimpoint = multipoint.vec

                    local damage, tr = trace_bullet(me, eye_pos, aimpoint, function(ent)
                        return ent == target
                    end)

                    if tr ~= nil and tr:is_visible() then
                        goto continue
                    end

                    if damage ~= 0 and desired_damage < damage then
                        found_pos = aimpoint
                        found_damage = damage

                        aim_target = target
                        aim_hitbox = point.hitbox
                        aim_damage = damage
                        aim_point = multipoint.text
                        aim_accuracy = bbox.alpha

                        break
                    end

                    ::continue::
                end

                if found_pos and found_damage then
                    break
                end
            end

            if not found_pos or not found_damage then
                return
            end

            local angles = eye_pos:to(found_pos):angles()

            cmd.block_movement = 1

            if resource.misc.dormant_aimbot.auto_scope:get() then
                local is_onground = not cmd.in_jump and onground

                local is_scoped = me.m_bIsScoped or me.m_bResumeZoom
                local is_sniper = weapon_info.weapon_type == WEAPONTYPE_SNIPER_RIFLE

                if not is_scoped and is_sniper and is_onground then
                    cmd.in_attack2 = true
                end
            end

            if inaccuracy < 0.01 then
                cmd.view_angles = angles
                cmd.in_attack = true

                is_shot = true
            end
        end

        local function on_weapon_fire(e)
            utils.execute_after(0.03, function()
                if entity.get(e.userid, true) == entity.get_local_player() then
                    if is_shot and not is_hit then
                        events["dormant_miss"]:call {
                            userid = aim_target,
                            aim_hitbox = aim_hitbox,
                            aim_damage = aim_damage,
                            aim_point = aim_point,
                            accuracy = aim_accuracy
                        }
                    end

                    is_hit = false
                    is_shot = false

                    aim_target = nil
                    aim_hitbox = nil
                    aim_damage = nil
                    aim_point = nil
                    aim_accuracy = nil
                end
            end)
        end

        local function on_player_hurt(e)
            local me = entity.get_local_player()

            local userid = entity.get(e.userid, true)
            local attacker = entity.get(e.attacker, true)

            if userid == nil or attacker ~= me then
                return
            end

            local bbox = userid:get_bbox()

            if bbox == nil then
                return
            end

            if userid:is_dormant() and is_shot == true then
                is_hit = true

                events["dormant_hit"]:call {
                    userid = userid,
                    attacker = attacker,
                    health = e.health,
                    armor = e.armor,
                    weapon = e.weapon,
                    dmg_health = e.dmg_health,
                    dmg_armor = e.dmg_armor,
                    hitgroup = e.hitgroup,
                    accuracy = bbox.alpha,
                    hitbox = e_hitbox[e.hitgroup],
                    aim_point = aim_point,
                    aim_hitbox = aim_hitbox,
                    aim_damage = aim_damage
                }
            end
        end

        local function on_shutdown()
            software.rage.main.enabled[2]:override()
        end

        resource.misc.dormant_aimbot.enabled:set_callback(function(item)
            local value = item:get()

            if not value then
                software.rage.main.enabled[2]:override()
            end

            events.shutdown(on_shutdown, value)
            events.createmove(on_createmove, value)

            events.weapon_fire(on_weapon_fire, value)
            events.player_hurt(on_player_hurt, value)
        end, true)
    end

    local ping_spike do
        local sv_maxunlag = cvar.sv_maxunlag

        local function set_value(value)
            if value == -1 then
                software.misc.main.other.fake_latency:override()
                sv_maxunlag:float(tonumber(sv_maxunlag:string()), false)
            else
                sv_maxunlag:float(math.max(0.200, value * 0.002), true)
                software.misc.main.other.fake_latency:override(value)
            end
        end

        local function on_shutdown()
            set_value(-1)
        end

        local function update_event_callbacks(value)
            events.shutdown(on_shutdown, value)
        end

        local namespace = resource.misc.ping_spike do
            local function on_value(item)
                set_value(item:get())
            end

            local function on_enabled(item)
                local value = item:get()

                if value then
                    namespace.value:set_callback(on_value, true)
                else
                    namespace.value:unset_callback(on_value)
                    set_value(-1)
                end

                update_event_callbacks(value)
            end

            namespace.enabled:set_callback(on_enabled, true)
        end
    end
end

local antiaim do
    local ctx do
        ctx = { }

        local Context = { } do
            Context.__index = Context

            local is_inverted = false
            local is_jitter = false

            local last_delay_tick = 0
            local last_delay_side = false

            local function contains(list, value)
                if list == nil then
                    return false
                end

                for i = 1, #list do
                    if list[i] == value then
                        return true
                    end
                end

                return false
            end

            local function remove(list, value)
                for i = #list, 1, -1 do
                    if list[i] == value then
                        table.remove(list, i)
                        return true
                    end
                end

                return false
            end

            local function update_inverter(ctx, e)
                if e.choked_commands ~= 0 then
                    is_jitter = contains(ctx.options, "Jitter")
                    is_inverted = rage.antiaim:inverter()

                    return
                end

                is_jitter = contains(ctx.options, "Jitter")
                is_inverted = not rage.antiaim:inverter()

                local should_delay = ctx.body_yaw and is_jitter
                    and ctx.delay ~= nil and ctx.delay > 0

                if should_delay then
                    last_delay_tick = last_delay_tick + 1

                    if last_delay_tick > ctx.delay then
                        last_delay_tick = 0
                        last_delay_side = not last_delay_side
                    end

                    is_inverted = last_delay_side
                    ctx.inverter = is_inverted

                    remove(ctx.options, "Jitter")
                end
            end

            local function modify_body_yaw(ctx, e)
                update_inverter(ctx, e)
            end

            local function modify_yaw_jitter(ctx, e)
                if ctx.body_yaw == nil or not is_jitter then
                    return
                end

                if ctx.yaw_modifier == "Offset" then
                    if is_inverted then
                        if ctx.yaw_add == nil then
                            ctx.yaw_add = 0
                        end

                        ctx.yaw_add = ctx.yaw_add + ctx.modifier_offset
                    end

                    ctx.yaw_modifier = "Disabled"
                    ctx.modifier_offset = 0

                    return
                end

                if ctx.yaw_modifier == "Center" then
                    if ctx.yaw_add == nil then
                        ctx.yaw_add = 0
                    end

                    if is_inverted then
                        ctx.yaw_add = ctx.yaw_add + ctx.modifier_offset * 0.5
                    else
                        ctx.yaw_add = ctx.yaw_add - ctx.modifier_offset * 0.5
                    end

                    ctx.yaw_modifier = "Disabled"
                    ctx.modifier_offset = 0

                    return
                end
            end

            local function modify_yaw(ctx, e)
                if ctx.yaw_left ~= nil and ctx.yaw_right ~= nil then
                    if ctx.yaw_add == nil then
                        ctx.yaw_add = 0
                    end

                    local offset = is_inverted
                        and ctx.yaw_left or ctx.yaw_right

                    ctx.yaw_add = ctx.yaw_add + offset
                end
            end

            local function apply_context(ctx)
                software.aa.angles.enabled:override(ctx.enabled)

                software.aa.angles.pitch:override(ctx.pitch)

                software.aa.angles.yaw[1]:override(ctx.yaw)
                software.aa.angles.yaw[2]:override(ctx.yaw_base)
                software.aa.angles.yaw[3]:override(ctx.yaw_add)
                software.aa.angles.yaw[4]:override(ctx.avoid_backstab)
                software.aa.angles.yaw[5]:override(ctx.hidden)

                software.aa.angles.yaw_modifier[1]:override(ctx.yaw_modifier)
                software.aa.angles.yaw_modifier[2]:override(ctx.modifier_offset)

                software.aa.angles.body_yaw[1]:override(ctx.body_yaw)
                software.aa.angles.body_yaw[2]:override(ctx.inverter)
                software.aa.angles.body_yaw[3]:override(ctx.left_limit)
                software.aa.angles.body_yaw[4]:override(ctx.right_limit)
                software.aa.angles.body_yaw[5]:override(ctx.options)
                software.aa.angles.body_yaw[6]:override(ctx.freestanding_body_yaw)

                software.aa.angles.freestanding[1]:override(ctx.freestanding)
                software.aa.angles.freestanding[2]:override(ctx.disable_yaw_modifiers)
                software.aa.angles.freestanding[3]:override(ctx.body_freestanding)

                software.aa.angles.extended_angles[1]:override(ctx.extended_angles)
                software.aa.angles.extended_angles[2]:override(ctx.extended_pitch)
                software.aa.angles.extended_angles[3]:override(ctx.extended_roll)
            end

            function Context:clear()
                for k in pairs(self) do
                    self[k] = nil
                end
            end

            function Context:update(e)
                if e ~= nil then
                    modify_body_yaw(self, e)
                    modify_yaw_jitter(self, e)
                    modify_yaw(self, e)
                end

                apply_context(self)
            end
        end

        setmetatable(ctx, Context)
    end

    local manual_yaw = { } do
        local namespace = resource.antiaim.manual_yaw

        local directions = {
            ["Left"] = -90,
            ["Right"] = 90,
            ["Backward"] = 0,
            ["Forward"] = 180
        }

        local function get_value()
            return directions[
                namespace.select:get()
            ]
        end

        function manual_yaw.update(cmd, ctx)
            local value = get_value()

            if value == nil then
                return false
            end

            if ctx.yaw_add == nil then
                ctx.yaw_add = 0
            end

            ctx.yaw_add = ctx.yaw_add + value
            ctx.yaw_base = "Local View"

            if namespace.disable_yaw_modifiers:get() then
                ctx.yaw_add = value
                ctx.yaw_modifier = "Disabled"
            end

            if namespace.body_freestanding:get() then
                ctx.body_yaw = true

                ctx.left_limit = 60
                ctx.right_limit = 60

                ctx.options = { }
                ctx.freestanding_body_yaw = "Peek Fake"
            end

            ctx.freestanding = false

            return true
        end
    end

    local freestanding = { } do
        local namespace = resource.antiaim.freestanding

        function freestanding.update(cmd, ctx)
            if not namespace.enabled:get() then
                ctx.freestanding = false
                return false
            end

            ctx.hidden = false
            ctx.freestanding = true

            ctx.disable_yaw_modifiers = namespace.disable_yaw_modifiers:get()
            ctx.body_freestanding = namespace.body_freestanding:get()

            return true
        end
    end

    local animation_breakers = { } do
        local namespace = resource.antiaim.animation_breakers

        local animlayer_t = ffi.typeof [[
            struct {
                float  m_flLayerAnimtime;
                float  m_flLayerFadeOuttime;

                // dispatch flags
                void  *m_pDispatchedStudioHdr;
                int    m_nDispatchedSrc;
                int    m_nDispatchedDst;

                int    m_nOrder;
                int    m_nSequence;
                float  m_flPrevCycle;
                float  m_flWeight;
                float  m_flWeightDeltaRate;

                // used for automatic crossfades between sequence changes;
                float  m_flPlaybackRate;
                float  m_flCycle;
                int    m_pOwner;
                int    m_nInvalidatePhysicsBits;
            } **
        ]]

        local function get_animation_layer(player)
            return ffi.cast(animlayer_t, ffi.cast("uintptr_t", player[0]) + 0x2990)[0]
        end

        local function get_earthquake_value(frequency)
            local current_tick = globals.tickcount / 10
            local factor = 0.5 + 0.5 * math.sin(current_tick * frequency)

            return factor * 100
        end

        local function update_static_leg_in_air(player, animlayers)
            if not namespace.options:get "Static leg in air" then
                return
            end

            player.m_flPoseParameter[6] = 1
        end

        local function update_leg_fucker(player, animlayers)
            if not namespace.options:get "Skeet Leg Fucker" then
                return
            end

            player.m_flPoseParameter[0] = utils.random_float(0.8 / 10, 1)
            software.aa.misc.leg_movement:override(utils.random_int(0, 1) == 0 and "Default" or "Sliding")
        end

        local function update_move_lean(player, animlayers)
            if not namespace.options:get "Move Lean" then
                return
            end

            if localplayer.is_onground and not namespace.on_ground_force:get() then
                return
            end

            local weight = animlayers[12].m_flWeight
            local amount = namespace.move_lean_force:get()

            animlayers[12].m_flWeight = math.clamp(weight + weight * amount, 0.0, 1.0)
        end

        local function update_landing_pitch(player, animstate)
            if not namespace.options:get "Landing Pitch" then
                return
            end

            if animstate.landing then
                player.m_flPoseParameter[12] = 0.5
            end
        end

        local function update_earthquake(player, animlayers)
            if not namespace.options:get "Earthquake" then
                return
            end

            if localplayer.is_onground and namespace.options:get "Skeet Leg Fucker" then
                return
            end

            if globals.tickcount % 10 > 1 then
                animlayers[12].m_flWeight = get_earthquake_value(7) / 100
            end
        end

        local function update_kangaroo(player)
            if not namespace.options:get "Kangaroo" then
                return
            end

            if localplayer.is_onground and namespace.options:get "Skeet Leg Fucker" then
                return
            end

            player.m_flPoseParameter[3] = math.random(0, 10) / 10
            player.m_flPoseParameter[6] = math.random(0, 10) / 10
            player.m_flPoseParameter[7] = math.random(0, 10) / 10
        end

        local function on_update_csa(player)
            local me = entity.get_local_player()

            if me ~= player then
                return
            end

            local animstate = player:get_anim_state()

            if animstate == nil then
                return
            end

            local animlayers = get_animation_layer(player)

            if animlayers == nil then
                return
            end

            if localplayer.is_onground then
                update_leg_fucker(player, animlayers)
                update_landing_pitch(player, animstate)
            else
                update_static_leg_in_air(player, animlayers)
            end

            update_kangaroo(player)

            update_move_lean(player, animlayers)
            update_earthquake(player, animlayers)
        end

        local function on_shutdown()
            software.aa.misc.leg_movement:override()
        end

        local function update_event_callbacks(value)
            events.shutdown(on_shutdown, value)
            events.post_update_clientside_animation(on_update_csa, value)
        end

        local function on_enabled(item)
            local value = item:get()

            if not value then
                on_shutdown()
            end

            update_event_callbacks(value)
        end

        namespace.enabled:set_callback(on_enabled, true)
    end

    local avoid_backstab = { } do
        local namespace = resource.antiaim.avoid_backstab

        function avoid_backstab.update(cmd, ctx)
            ctx.avoid_backstab = namespace.enabled:get()
        end
    end

    local edge_yaw = { } do
        local namespace = resource.antiaim.edge_yaw

        function edge_yaw.update(cmd, ctx)
            if not namespace.enabled:get() then
                return false
            end

            local me = entity.get_local_player()

            if me == nil then
                return false
            end

            local eyes = me:get_eye_position()

            if eyes == nil then
                return false
            end

            local count = 0
            local angles = { }

            for deg = 18, 360, 18 do
                local forward = vector():angles(0, deg)
                local expand = eyes + forward * 32

                local trace = utils.trace_line(eyes, expand, me, 0xFFFFFFFF, 1)
                local ent, fraction = trace.entity, trace.fraction

                if fraction == 1.0 or ent == nil or trace:did_hit_non_world() then
                    goto skip
                end

                count = count + 1
                table.insert(angles, deg)

                ::skip::
            end

            if count < 2 then
                return false
            end

            local view = cmd.view_angles

            local center = (angles[1] + angles[count]) * 0.5
            local angle = math.normalize_yaw(-view.y + center)

            if math.abs(angle) > 90 then
                return
            end

            angle = angle * 2.0 + 180

            if ctx.yaw_add == nil then
                ctx.yaw_add = 0
            end

            ctx.yaw_add = ctx.yaw_add + angle do
                ctx.yaw_base = "Local View"
                ctx.hidden = false
            end

            return true
        end
    end

    local safe_head = { } do
        local namespace = resource.antiaim.safe_head

        local function detect_condition()
            local me = entity.get_local_player()

            if me == nil then
                return nil
            end

            local threat = entity.get_threat()

            if threat == nil then
                return nil
            end

            local weapon = me:get_player_weapon()

            if weapon == nil then
                return nil
            end

            local weapon_info = weapon:get_weapon_info()
            local weapon_index = weapon:get_weapon_index()

            local is_taser = weapon_index == 31
            local is_knife = weapon_info.weapon_type == 0 and not is_taser

            local is_air = not localplayer.is_onground
            local is_ducked = localplayer.duck_amount >= 0.66

            local my_origin = me:get_origin()
            local threat_origin = threat:get_origin()

            local delta = threat_origin - my_origin
            local distancesqr = delta:length2dsqr()

            if is_air and is_ducked then
                if is_knife and namespace.conditions:get "Knife" then
                    return "Knife"
                end

                if is_taser and namespace.conditions:get "Zeus" then
                    return "Zeus"
                end
            end

            if is_air or is_ducked then
                if distancesqr > (1000 * 1000) and namespace.conditions:get "Distance" then
                    return "Distance"
                end
            end

            return nil
        end

        function safe_head.update(cmd, ctx)
            if not namespace.enabled:get() then
                return false
            end

            local state = detect_condition()

            if state == nil then
                return false
            end

            ctx.hidden = false
            ctx.pitch = "Down"

            if state == "Knife" then
                ctx.yaw_add = -19 do
                    ctx.yaw_base = "At Target"
                end

                ctx.yaw_modifier = "Disabled"

                ctx.body_yaw = true do
                    ctx.inverter = true

                    ctx.left_limit = 60
                    ctx.right_limit = 60

                    ctx.options = { }
                    ctx.freestanding_body_yaw = "Off"
                end
            end

            if state == "Zeus" then
                ctx.yaw_add = -2 do
                    ctx.yaw_base = "At Target"
                end

                ctx.yaw_modifier = "Disabled"

                ctx.body_yaw = true do
                    ctx.inverter = true

                    ctx.left_limit = 60
                    ctx.right_limit = 60

                    ctx.options = { }
                    ctx.freestanding_body_yaw = "Off"
                end
            end

            if state == "Distance" then
                ctx.yaw_add = -8 do
                    ctx.yaw_base = "At Target"
                end

                ctx.yaw_modifier = "Disabled"

                ctx.body_yaw = true do
                    ctx.inverter = true

                    ctx.left_limit = 60
                    ctx.right_limit = 60

                    ctx.options = { }
                    ctx.freestanding_body_yaw = "Off"
                end
            end

            return true
        end
    end

    local defensive = { } do
        local namespace = resource.antiaim.defensive do
            local list = namespace.list
            local layout = namespace.layout

            local function update_condition_items(items, is_visible)
                items.enabled:visibility(is_visible)

                if not items.enabled:get() then
                    is_visible = false
                end

                items.pitch:visibility(is_visible) do
                    local value = items.pitch:get()
                    local is_custom = value == "Custom"

                    items.pitch_offset:visibility(is_visible and is_custom)
                end

                items.yaw:visibility(is_visible) do
                    local value = items.yaw:get()

                    local is_valuable = value == "Spin"
                        or value == "Custom"

                    items.yaw_offset:visibility(is_visible and is_valuable)
                end
            end

            local function update_layout(item)
                local value = namespace.condition:get()

                if item == nil then
                    value = nil
                end

                for i = 1, #list do
                    local key = list[i]
                    local items = layout[key]

                    if items == nil then
                        goto continue
                    end

                    local is_visible = key == value

                    if is_visible then
                        items.enabled:set_callback(update_layout)
                        items.pitch:set_callback(update_layout)
                        items.yaw:set_callback(update_layout)
                    else
                        items.enabled:unset_callback(update_layout)
                        items.pitch:unset_callback(update_layout)
                        items.yaw:unset_callback(update_layout)
                    end

                    update_condition_items(
                        items, is_visible
                    )

                    ::continue::
                end
            end

            namespace.condition:set_callback(update_layout, true)
        end

        local function get_items(key)
            return namespace.layout[key]
        end

        local function get_pitch(items)
            local value = items.pitch:get()

            if value == "Up" then
                return -89
            end

            if value == "Down" then
                return 89
            end

            if value == "Zero" then
                return 0
            end

            if value == "Random" then
                return utils.random_int(-89, 89)
            end

            if value == "Progressive" then
                return ((globals.curtime * 7) % 2 - 1) * 89
            end

            if value == "Custom" then
                return items.pitch_offset:get()
            end

            return nil
        end

        local function get_yaw_offset(items)
            local value = items.yaw:get()

            if value == "Jitter" then
                return bit.band(localplayer.sent_packets, 1) ~= 0
                    and -90 or 90
            end

            if value == "Opposite" then
                return 180
            end

            if value == "Spin" then
                return globals.curtime * (items.yaw_offset:get() * 12) % 360
            end

            if value == "Random" then
                return utils.random_int(-180, 180)
            end

            if value == "Custom" then
                return -items.yaw_offset:get()
            end

            return nil
        end

        local function force_defensive()
            software.rage.main.hide_shots_options:override("Break LC")
            software.rage.main.double_tap_lag_options:override("Always On")
        end

        local function update_hidden(items)
            local pitch = get_pitch(items)
            local yaw_offset = get_yaw_offset(items)

            if pitch ~= nil then
                rage.antiaim:override_hidden_pitch(pitch)
            end

            if yaw_offset ~= nil then
                rage.antiaim:override_hidden_yaw_offset(yaw_offset)
            end
        end

        function defensive.update(cmd, ctx)
            if not namespace.enabled:get() then
                return false
            end

            local condition = conditions.get()
            local items = get_items(condition)

            if items == nil or not items.enabled:get() then
                return false
            end

            ctx.hidden = true

            force_defensive()
            update_hidden(items)

            return true
        end
    end

    local builder = { } do
        local namespace = resource.antiaim.builder do
            local list = namespace.list
            local layout = namespace.layout

            local function update_condition_items(items, is_visible)
                if items.enabled ~= nil then
                    items.enabled:visibility(is_visible)

                    if not items.enabled:get() then
                        is_visible = false
                    end
                end

                items.pitch:visibility(is_visible)
                items.yaw:visibility(is_visible)
                items.yaw_modifier:visibility(is_visible and items.yaw:get() ~= "Disabled")
                items.body_yaw:visibility(is_visible)
            end

            local function update_layout(item)
                local value = namespace.condition:get()

                if item == nil then
                    value = nil
                end

                for i = 1, #list do
                    local key = list[i]
                    local items = layout[key]

                    if items == nil then
                        goto continue
                    end

                    local is_visible = key == value

                    if is_visible then
                        if items.enabled ~= nil then
                            items.enabled:set_callback(update_layout)
                        end

                        items.yaw:set_callback(update_layout)
                    else
                        if items.enabled ~= nil then
                            items.enabled:unset_callback(update_layout)
                        end

                        items.yaw:unset_callback(update_layout)
                    end

                    update_condition_items(
                        items, is_visible
                    )

                    ::continue::
                end
            end

            local function on_enabled(item)
                local value = item:get()

                if value then
                    namespace.condition:set_callback(update_layout, true)
                else
                    namespace.condition:unset_callback(update_layout)
                    update_layout(nil)
                end

                namespace.condition:visibility(value)
            end

            namespace.enabled:set_callback(on_enabled, true)
        end

        local function get_items(key)
            local items = namespace.layout[key]

            local should_be_shared = items == nil
                or (items.enabled ~= nil and not items.enabled:get())

            if should_be_shared then
                return namespace.layout["Shared"]
            end

            return items
        end

        local function update_items(ctx, list)
            ctx.pitch = list.pitch:get()

            ctx.yaw = list.yaw:get() do
                ctx.yaw_base = list.yaw_base:get()

                ctx.yaw_left = list.yaw_left:get()
                ctx.yaw_right = list.yaw_right:get()

                ctx.yaw_modifier = list.yaw_modifier:get() do
                    ctx.modifier_offset = list.modifier_offset:get()
                end

                ctx.hidden = false
            end

            ctx.body_yaw = list.body_yaw:get() do
                ctx.left_limit = list.left_limit:get()
                ctx.right_limit = list.right_limit:get()
                ctx.options = list.options:get()
                ctx.delay = list.delay:get()
                ctx.freestanding_body_yaw = list.freestanding:get()
            end
        end

        function builder.update(cmd, ctx)
            if not namespace.enabled:get() then
                return false
            end

            local condition = conditions.get()
            local items = get_items(condition)

            if items == nil then
                return false
            end

            update_items(ctx, items)
            return true
        end
    end

    local function on_shutdown()
        ctx:clear()

        software.rage.main.hide_shots_options:override()
        software.rage.main.double_tap_lag_options:override()

        ctx:update()
    end

    local function on_createmove(cmd)
        ctx:clear()

        software.rage.main.hide_shots_options:override()
        software.rage.main.double_tap_lag_options:override()

        builder.update(cmd, ctx)
        avoid_backstab.update(cmd, ctx)

        if not manual_yaw.update(cmd, ctx) then
            defensive.update(cmd, ctx)

            if not freestanding.update(cmd, ctx) then
                edge_yaw.update(cmd, ctx)
            end

            safe_head.update(cmd, ctx)
        end

        ctx:update(cmd)
    end

    events.shutdown(on_shutdown)
    events.createmove(on_createmove)
end

local visuals do
    local watermark do
        local FONT_ENABLED = fonts.container
        local FONT_DISABLED = fonts.verdana_bold

        local PADDING_W = 10
        local PADDING_H = 10

        local name = "" do
            local function generate_name(str, sep)
                local list = { }

                for i = 1, #str do
                    list[i] = str:sub(i, i)
                end

                return table.concat(list, sep)
            end

            name = generate_name(script_info.name:upper(), "\x20")
        end

        local diagnostics = { } do
            local fps = 0
            local latency = 0

            local update_fps do
                local UPDATE_TIME = 1.0
                local FRAMERATE_AVG_FRAC = 0.99

                local frametime = 0.0
                local last_update_time = 0.0

                function update_fps()
                    frametime = FRAMERATE_AVG_FRAC * frametime + (1.0 - FRAMERATE_AVG_FRAC) * globals.absoluteframetime
                    last_update_time = last_update_time - globals.absoluteframetime

                    if last_update_time <= 0 then
                        fps = math.floor(1 / frametime)
                        last_update_time = UPDATE_TIME
                    end
                end
            end

            local update_latency do
                local UPDATE_TIME = 1.0

                local last_update_time = 0.0
                local cl_updaterate = cvar.cl_updaterate

                local function get_latency()
                    local net_channel = utils.net_channel()

                    if net_channel == nil or net_channel.is_loopback then
                        return 0.0
                    end

                    local avg_latency = net_channel.avg_latency[0]

                    if cl_updaterate:float() > 0.001 then
                        avg_latency = avg_latency + (-0.5 / cl_updaterate:float())
                    end

                    return math.max(0.0, avg_latency)
                end

                function update_latency()
                    last_update_time = last_update_time - globals.frametime

                    if last_update_time <= 0 then
                        local avg_latency = get_latency()

                        if avg_latency > 0 then
                            latency = math.floor(1.0 / avg_latency)
                        else
                            latency = 0
                        end

                        last_update_time = UPDATE_TIME
                    end
                end
            end

            function diagnostics.get_fps()
                return fps
            end

            function diagnostics.get_latency()
                return latency
            end

            function diagnostics.update()
                update_fps()
                update_latency()
            end
        end

        local function on_disabled_render()
            local screen = render.screen_size()
            local position = vector(0, 0)

            local style = ui.get_style()

            local text_flags = "s"
            local text_size = render.measure_text(FONT_DISABLED, text_flags, name)

            position.x = position.x + 25
            position.y = (screen.y - text_size.y) * 0.5

            local text = decorators.wave(
                name, style["Link Active"], style["Sidebar Text"], globals.realtime
            )

            render.text(FONT_DISABLED, position, color(), text_flags, text)
        end

        local function on_enabled_render()
            local font = FONT_ENABLED

            local screen = render.screen_size()
            local position = vector(screen.x - 10, 10)

            local style = ui.get_style()

            local text_clr = style["Sidebar Text"]
            local link_active_clr = style["Link Active"]

            local link_active_hex = link_active_clr:to_hex()

            local build_panel do
                local text = ui.get_icon "sparkles" .. "\x20" .. script_info.build:upper()

                local text_flags = "s"
                local text_size = render.measure_text(font, text_flags, text)

                local rect_size = text_size + vector(PADDING_W, PADDING_H) * 2.0

                position.x = position.x - rect_size.x

                container.draw(position, position + rect_size, style)
                container.line(position, position + rect_size, style)

                render.text(font, position + (rect_size - text_size) * 0.5, link_active_clr, text_flags, text)

                position.x = position.x - 8
            end

            local info_panel do
                diagnostics.update()

                local text = {
                    "\a" .. link_active_hex .. ui.get_icon "circle-user" .. "\x20" .. "\aDEFAULT" .. script_info.user,
                    "\a" .. link_active_hex .. ui.get_icon "desktop" .. "\x20" .. "\aDEFAULT" .. diagnostics.get_fps() .. "fps",
                    "\a" .. link_active_hex .. ui.get_icon "chart-column" .. "\x20" .. "\aDEFAULT" .. diagnostics.get_latency() .. "ms",
                }

                text = table.concat(text, ZWSP:rep(5))

                local text_flags = "s"
                local text_size = render.measure_text(font, text_flags, text)

                local rect_size = text_size + vector(PADDING_W, PADDING_H) * 2.0

                position.x = position.x - rect_size.x

                container.draw(position, position + rect_size, style)
                container.line(position, position + rect_size, style)

                render.text(font, position + (rect_size - text_size) * 0.5, text_clr, text_flags, text)

                position.x = position.x - 8
            end

            local icon_panel do
                local text = ui.get_icon "trophy"

                local text_flags = "s"
                local text_size = render.measure_text(font, text_flags, text)

                local rect_size = text_size + vector(PADDING_W, PADDING_H) * 2.0

                position.x = position.x - rect_size.x

                container.draw(position, position + rect_size, style)

                render.text(font, position + (rect_size - text_size) * 0.5, link_active_clr, text_flags, text)

                position.x = position.x - 8
            end
        end

        local function update_event_callbacks(value)
            events.render(on_enabled_render, value)
            events.render(on_disabled_render, not value)
        end

        local namespace = resource.misc.watermark do
            namespace.enabled:set_callback(function(item)
                local value = item:get()

                update_event_callbacks(value)
            end, true)
        end
    end

    local keybinds do
        local GAP_BETWEEN = 5
    
        local BIND_MARGIN = 10
        local BIND_PADDING = 4
    
        local BIND_SPACING = 10
    
        local FADE_IN_DURATION = 0.5
        local fade_alpha = 0
        local last_time = globals.realtime
    
        local font = fonts.container
    
        local window = window_system.new("keybinds", {
            pos = vector(20, 320),
            size = vector(140, 30)
        })
    
        local function join_table(list, sep)
            local result = { }
    
            for i = 1, #list do
                local value = tostring(list[i])
    
                if i ~= 1 and sep ~= nil then
                    table.insert(result, sep)
                end
    
                table.insert(result, value:sub(1, 1))
            end
    
            return table.concat(result)
        end
    
        local function get_value(bind)
            local value = bind.value
    
            if type(value) == "boolean" then
                return value and "on" or "off"
            end
    
            if type(value) == "table" then
                return join_table(value, ", ")
            end
    
            return value
        end
    
        local function get_data()
            local data = { }
            local max_size = vector()
    
            local binds = ui.get_binds()
    
            for i = 1, #binds do
                local bind = binds[i]
    
                if not bind.active then
                    goto continue
                end
    
                local name = bind.name
                local value = get_value(bind)
    
                local name_size = render.measure_text(font, "s", name)
                local value_size = render.measure_text(font, "s", value)
    
                local width = name_size.x + value_size.x + BIND_SPACING + BIND_MARGIN * 2
                local height = math.max(name_size.y, value_size.y)
    
                max_size.x = math.max(max_size.x, width)
                max_size.y = max_size.y + height
    
                table.insert(data, {
                    name = name,
                    value = value,
    
                    height = height,
    
                    name_size = name_size,
                    value_size = value_size
                })
    
                ::continue::
            end
    
            return data, max_size
        end
    
        local function on_render()
            local current_time = globals.realtime
            local delta_time = current_time - last_time
            last_time = current_time
    
            if fade_alpha < 1 then
                fade_alpha = math.min(1, fade_alpha + delta_time / FADE_IN_DURATION)
            end
    
            local text_flags = "s"
    
            local pos = window:get_pos():clone()
            local size = window:get_size():clone()
    
            local style = ui.get_style()
            local alpha = ui.get_alpha() * fade_alpha
    
            local data, max_size = get_data()
    
            if #data > 0 then
                alpha = 1.0 * fade_alpha
            end
    
            if alpha == 0 then
                return
            end
    
            local text_color = style["Text"]
    
            text_color = text_color:clone()
            text_color.a = text_color.a * alpha
    
            size.x = math.max(144, max_size.x)
            size.y = 30
    
            container.draw(pos, pos + size, style, alpha)
            container.line(pos, pos + size, style, alpha)
    
            local text = "Keybinds" do
                local text_size = render.measure_text(font, text_flags, text)
                local text_pos = vector(pos.x + BIND_MARGIN, pos.y + (size.y - text_size.y) * 0.5 - 1)
    
                render.text(font, text_pos, text_color, text_flags, text)
            end
    
            local y_offset = pos.y + size.y + GAP_BETWEEN
            for i, bind in ipairs(data) do
                local name = bind.name
                local value = bind.value
    
                local name_pos = vector(pos.x + BIND_MARGIN, y_offset)
                local value_pos = vector(pos.x + size.x - BIND_MARGIN - bind.value_size.x, y_offset)
    
                render.text(font, name_pos, text_color, text_flags, name)
                render.text(font, value_pos, text_color, text_flags, value)
    
                y_offset = y_offset + bind.height + BIND_PADDING
            end
        end

        local function update_event_callbacks(value)
            events.render(on_render, value)
        end

        local namespace = resource.misc.keybinds do
            namespace.enabled:set_callback(function(item)
                local value = item:get()

                update_event_callbacks(value)
            end, true)
        end
    end

    local spectators do
        local GAP_BETWEEN = 5

        local BIND_MARGIN = 10
        local BIND_PADDING = 4

        local BIND_SPACING = 10

        local font = fonts.container

        local window = window_system.new("keybinds", {
            pos = vector(20, 420),
            size = vector(140, 30)
        })

        local function get_spectators()
            local me = entity.get_local_player()

            if me == nil then
                return { }
            end

            if me:is_alive() then
                return me:get_spectators()
            end

            local observer_target = me.m_hObserverTarget

            if observer_target ~= nil then
                return observer_target:get_spectators()
            end

            return { }
        end

        local function get_data()
            local data = { }
            local max_size = vector()

            local spectators = get_spectators()

            if spectators == nil then
                return { }, vector()
            end

            for i = 1, #spectators do
                local spectator = spectators[i]

                local name = spectator:get_name()
                local avatar = spectator:get_steam_avatar()

                local name_size = render.measure_text(font, "s", name)
                local avatar_size = vector(12, 12)

                local width = name_size.x + avatar_size.x + BIND_SPACING + BIND_MARGIN * 2
                local height = math.max(name_size.y, avatar_size.y)

                max_size.x = math.max(max_size.x, width)
                max_size.y = max_size.y + height

                table.insert(data, {
                    name = name,
                    avatar = avatar,

                    height = height,

                    name_size = name_size,
                    avatar_size = avatar_size
                })
            end

            return data, max_size
        end

        local function on_render()
            local text_flags = "s"

            local pos = window:get_pos():clone()
            local size = window:get_size():clone()

            local style = ui.get_style()
            local alpha = ui.get_alpha()

            local data, max_size = get_data()

            if #data > 0 then
                alpha = 1.0
            end

            if alpha == 0 then
                return
            end

            local text_color = style["Text"]

            text_color = text_color:clone()
            text_color.a = text_color.a * alpha

            size.x = math.max(144, max_size.x)
            size.y = 30

            container.draw(pos, pos + size, style, alpha)
            container.line(pos, pos + size, style, alpha)

            local text = "Spectators" do
                local text_size = render.measure_text(font, text_flags, text)
                local text_pos = vector(pos.x + BIND_MARGIN, pos.y + (size.y - text_size.y) * 0.5 - 1)

                render.text(font, text_pos, text_color, text_flags, text)
            end

            local icon = ui.get_icon "eye" do
                local text_size = render.measure_text(font, text_flags, icon)
                local text_pos = vector(pos.x + size.x - text_size.x - BIND_MARGIN, pos.y + (size.y - text_size.y) * 0.5 - 1)

                render.text(font, text_pos, text_color, text_flags, icon)
            end

            pos.y = pos.y + size.y + GAP_BETWEEN

            if max_size.y > 0 then
                for i = 1, #data do
                    local info = data[i]

                    local name = info.name
                    local avatar = info.avatar

                    local height = info.height

                    local name_size = info.name_size
                    local avatar_size = info.avatar_size

                    local rect_size = vector(size.x, height + BIND_PADDING * 2)

                    local name_pos = vector(pos.x + BIND_MARGIN, pos.y + (rect_size.y - name_size.y) * 0.5 - 1)
                    local avatar_pos = vector(pos.x + size.x - avatar_size.x - BIND_MARGIN, pos.y + (rect_size.y - avatar_size.y) * 0.5 - 1)

                    container.draw(pos, pos + rect_size, style, alpha)

                    render.text(font, name_pos, text_color, text_flags, name)
                    render.texture(avatar, avatar_pos, avatar_size, text_color, "f", 4)

                    pos.y = pos.y + rect_size.y + GAP_BETWEEN
                end
            end
        end

        local function update_event_callbacks(value)
            events.render(on_render, value)
        end

        local namespace = resource.misc.spectators do
            namespace.enabled:set_callback(function(item)
                local value = item:get()

                update_event_callbacks(value)
            end, true)
        end
    end

    local scope_overlay do
        local RESOLUTION = 1 / 1080

        local smoothy_alpha = smoothy.new(0.0)

        local position = 0
        local offset = 0

        local scope_color = color()

        local excluded_left = false
        local excluded_right = false
        local excluded_top = false
        local excluded_bottom = false

        local function update_override(value)
            software.visuals.world.main.scope_overlay:override(
                value and "Remove All" or nil
            )
        end

        local function on_shutdown()
            update_override(false)
        end

        local function on_render()
            local me = entity.get_local_player()

            if me == nil or not me:is_alive() then
                return
            end

            local is_scoped = me.m_bIsScoped

            local alpha = smoothy_alpha(0.05, is_scoped)

            if alpha == 0.0 then
                return
            end

            local screen = render.screen_size()
            local center = screen * 0.5

            local offset = offset * screen.y * RESOLUTION
            local position = position * screen.y * RESOLUTION

            offset = math.floor(offset)
            position = math.floor(position)

            local delta = position - offset

            local color_a = scope_color:clone()
            local color_b = scope_color:clone()

            color_a.a = color_a.a * alpha
            color_b.a = 0

            if not excluded_top then
                local pos_a = vector(center.x, center.y - offset + 1)
                local pos_b = vector(pos_a.x + 1, center.y - position)

                render.gradient(pos_a, pos_b, color_a, color_a, color_b, color_b)
            end

            if not excluded_bottom then
                local pos_a = vector(center.x, center.y + offset)
                local pos_b = vector(pos_a.x + 1, center.y + position)

                render.gradient(pos_a, pos_b, color_a, color_a, color_b, color_b)
            end

            if not excluded_left then
                local pos_a = vector(center.x - offset + 1, center.y)
                local pos_b = vector(pos_a.x - delta, center.y + 1)

                render.gradient(pos_a, pos_b, color_a, color_b, color_a, color_b)
            end

            if not excluded_right then
                local pos_a = vector(center.x + offset, center.y)
                local pos_b = vector(pos_a.x + delta, center.y + 1)

                render.gradient(pos_a, pos_b, color_a, color_b, color_a, color_b)
            end
        end

        local function update_event_callbacks(value)
            events.shutdown(on_shutdown, value)
            events.render(on_render, value)
        end

        local namespace = resource.misc.scope_overlay do
            local function on_position(item)
                position = item:get()
            end

            local function on_offset(item)
                offset = item:get()
            end

            local function on_color(item)
                scope_color = item:get()
            end

            local function on_t_style(item)
                excluded_top = item:get()
            end

            local function on_enabled(item)
                local value = item:get()

                if value then
                    namespace.position:set_callback(on_position, true)
                    namespace.offset:set_callback(on_offset, true)
                    namespace.color:set_callback(on_color, true)
                    namespace.t_style:set_callback(on_t_style, true)
                else
                    namespace.position:unset_callback(on_position)
                    namespace.offset:unset_callback(on_offset)
                    namespace.color:unset_callback(on_color)
                    namespace.t_style:unset_callback(on_t_style)
                end

                update_override(value)
                update_event_callbacks(value)
            end

            namespace.enabled:set_callback(on_enabled, true)
        end
    end

    local antiaim_arrows do
        local FONT = render.load_font("Tahoma", 20, "ad")
        local PADDING = 40

        local TRIANGLE = vector(1, 2 / 3)
        local RECTANGLE = vector(2, 0)

        local INACTIVE_COLOR = color(17, 17, 17, 128)

        local smoothy_alpha = smoothy.new(0.0)

        local smoothy_left_manual = smoothy.new(0.0)
        local smoothy_right_manual = smoothy.new(0.0)

        local smoothy_left_desync = smoothy.new(0.0)
        local smoothy_right_desync = smoothy.new(0.0)

        local color_list = { }
        local arrows_type = nil

        local function get_position(screen, x, y)
            local position = screen * 0.5

            if x ~= nil then
                position.x = position.x + x * (screen.y / 1080)
            end

            if y ~= nil then
                position.y = position.y + y * (screen.y / 1080)
            end

            return position
        end

        local function on_render()
            local me = entity.get_local_player()

            local manual_dir = resource.antiaim.manual_yaw.select:get()

            local is_alive = me ~= nil and me:is_alive()
            local is_scoped = is_alive and me.m_bIsScoped

            local is_left_manual = is_alive and manual_dir == "Left"
            local is_right_manual = is_alive and manual_dir == "Right"

            local is_left_desync = is_alive and localplayer.abs_body_yaw < -10
            local is_right_desync = is_alive and localplayer.abs_body_yaw > 10

            local alpha = smoothy_alpha:update(0.05, is_alive and not is_scoped)

            local left_manual_value = smoothy_left_manual:update(0.05, is_left_manual and alpha or 0.0)
            local right_manual_value = smoothy_right_manual:update(0.05, is_right_manual and alpha or 0.0)

            local left_desync_value = smoothy_left_desync:update(0.05, is_left_desync and alpha or 0.0)
            local right_desync_value = smoothy_right_desync:update(0.05, is_right_desync and alpha or 0.0)

            if alpha <= 0.0 then
                return
            end

            local screen = render.screen_size()

            if arrows_type == "Default" then
                local manual_color = color_list["Manual"][1] or color()

                local left_arrow do
                    local position = get_position(screen, -PADDING) - vector(1, 0)

                    local arrow_color = manual_color:clone()
                    arrow_color.a = arrow_color.a * left_manual_value

                    local arrow_text = "<"

                    local text_flags = "rs"
                    local text_size = render.measure_text(FONT, text_flags, arrow_text)

                    position.y = position.y - round(text_size.y * 0.5) - 1

                    render.text(FONT, position, arrow_color, text_flags, arrow_text)
                end

                local right_arrow do
                    local position = get_position(screen, PADDING)

                    local arrow_color = manual_color:clone()
                    arrow_color.a = arrow_color.a * right_manual_value

                    local arrow_text = ">"

                    local text_flags = "s"
                    local text_size = render.measure_text(FONT, text_flags, arrow_text)

                    position.y = position.y - round(text_size.y * 0.5) - 1

                    render.text(FONT, position, arrow_color, text_flags, arrow_text)
                end
            end

            if arrows_type == "Team Skeet" then
                local size = TRIANGLE * 13.5

                local manual_color = color_list["Manual"][1] or color()
                local desync_color = color_list["Desync"][1] or color()

                local left_arrow do
                    local position = get_position(screen, -PADDING) - vector(1, 0)

                    local arrow_color = INACTIVE_COLOR:lerp(manual_color, left_manual_value)
                    arrow_color.a = arrow_color.a * alpha

                    local rect_color = INACTIVE_COLOR:lerp(desync_color, left_desync_value)
                    rect_color.a = rect_color.a * alpha

                    render.rect(position - vector(0, size.y), position + vector(RECTANGLE.x, size.y), rect_color)
                    position.x = position.x - RECTANGLE.x + 1

                    local p0 = position + vector(0, -size.y)
                    local p1 = position + vector(0, size.y)
                    local p2 = position + vector(-size.x, 0)

                    render.poly(arrow_color, p0, p1, p2)
                end

                local right_arrow do
                    local position = get_position(screen, PADDING) + vector(1, 0)

                    local arrow_color = INACTIVE_COLOR:lerp(manual_color, right_manual_value)
                    arrow_color.a = arrow_color.a * alpha

                    local rect_color = INACTIVE_COLOR:lerp(desync_color, right_desync_value)
                    rect_color.a = rect_color.a * alpha

                    render.rect(position - vector(0, size.y), position + vector(0, size.y), rect_color)
                    position.x = position.x + RECTANGLE.x

                    local p0 = position + vector(0, -size.y)
                    local p1 = position + vector(0, size.y)
                    local p2 = position + vector(size.x, 0)

                    render.poly(arrow_color, p0, p1, p2)
                end
            end
        end

        local function update_event_callbacks(value)
            events.render(on_render, value)
        end

        local namespace = resource.misc.antiaim_arrows do
            local function on_color(item)
                local list = item:list()

                for i = 1, #list do
                    local key = list[i]
                    local value = item:get(key)

                    color_list[key] = value
                end
            end

            local function on_type(item)
                arrows_type = item:get()
            end

            local function on_enabled(item)
                local value = item:get()

                if value then
                    namespace.color:set_callback(on_color, true)
                    namespace.type:set_callback(on_type, true)
                else
                    namespace.color:unset_callback(on_color)
                    namespace.type:unset_callback(on_type)
                end

                update_event_callbacks(value)
            end

            namespace.enabled:set_callback(on_enabled, true)
        end
    end

    local indicate_state do
        local FONT = 2

        local indicators = { } do
            local smoothy_alpha = smoothy.new()
            local smoothy_align = smoothy.new()

            local smoothy_dt = smoothy.new()
            local smoothy_osaa = smoothy.new()

            local function get_condition_text()
                if not localplayer.is_onground then
                    return "AIR"
                end

                if localplayer.is_crouched then
                    return "DUCK"
                end

                if localplayer.is_moving then
                    return "MOVE"
                end

                return "STAND"
            end

            local function render_indicator(font, position, color, flags, text, alpha, align, is_shadow)
                local measure = render.measure_text(font, flags, text)
                local offset = round(-measure.x * (1 - align) * 0.5 + 8 * align)

                local text_pos = position + vector(offset, 0)
                local text_color = color:alpha_modulate(color.a * alpha)

                if is_shadow then
                    local shadow_pos = text_pos + vector(
                        0, measure.y * 0.5
                    )

                    render.shadow(shadow_pos, shadow_pos + vector(measure.x, 0), text_color)
                end

                render.text(font, text_pos, text_color, flags, text)
                position.y = position.y + round(measure.y * 0.8 * alpha)
            end

            local function render_script_name(font, position, flags, alpha, align)
                local style = ui.get_style()

                local text = script_info.name:upper() do
                    text = decorators.wave(text, style["Disabled Text"], style["Link Active"], globals.realtime)
                end

                render_indicator(font, position, color(), flags, text, alpha, align)
            end

            local function render_player_state(font, position, flags, alpha, align)
                render_indicator(font, position, color(), flags, get_condition_text(), alpha, align)
            end

            local function render_double_tap(font, position, flags, alpha, align)
                if alpha <= 0.01 then
                    return
                end

                local text_state = "DT"

                local text_color = color(69, 69, 69, 255)
                    :lerp(color(100, 255, 40), rage.exploit:get())

                render_indicator(font, position, text_color, flags, text_state, alpha, align)
            end

            local function render_onshot_aa(font, position, flags, alpha, align)
                if alpha <= 0.01 then
                    return
                end

                local charge = math.max(
                    smoothy_dt.value, rage.exploit:get()
                )

                local text_state = "OSAA"

                local text_color = color(69, 69, 69, 255)
                    :lerp(color(), charge)

                render_indicator(font, position, text_color, flags, text_state, alpha, align)
            end

            function indicators.update()
                local me = entity.get_local_player()

                local is_alive = me ~= nil and me:is_alive()
                local is_scoped = is_alive and me.m_bIsScoped

                local is_double_tap = software.rage.main.double_tap:get()
                local is_onshot_aa = software.rage.main.hide_shots:get()

                smoothy_alpha:update(0.05, is_alive)
                smoothy_align:update(0.05, is_scoped)

                smoothy_dt:update(0.05, is_double_tap)
                smoothy_osaa:update(0.05, is_onshot_aa)
            end

            function indicators.draw()
                local alpha = smoothy_alpha.value
                local align = smoothy_align.value

                local dt_alpha = smoothy_dt.value
                local osaa_alpha = smoothy_osaa.value

                if alpha == 0.0 then
                    return
                end

                local display = render.screen_size()
                local center = display / 2

                local position = center + vector(0, 24)
                local text_flags = "s"

                render_script_name(FONT, position, text_flags, alpha, align)
                render_player_state(FONT, position, text_flags, alpha, align)

                render_double_tap(FONT, position, text_flags, alpha * dt_alpha, align)
                render_onshot_aa(FONT, position, text_flags, alpha * osaa_alpha, align)
            end

            function indicators.render()
                indicators.update()
                indicators.draw()
            end
        end

        local function on_render()
            indicators.render()
        end

        local function update_event_callbacks(value)
            events.render(on_render, value)
        end

        local namespace = resource.misc.indicate_state do
            local function on_enabled(item)
                update_event_callbacks(item:get())
            end

            namespace.enabled:set_callback(on_enabled, true)
        end
    end

    local damage_indicator do
        local FONTS = {
            ["Default"] = 1,
            ["Small"] = 2
        }

        local PADDING_W = 4.0
        local PADDING_H = 4.0

        local smoothy_drag = smoothy.new(0.0)

        local text_font = nil
        local text_color = color()

        local screen = render.screen_size()

        local window = window_system.new("damage_indicator", {
            pos = vector(screen.x * 0.5 + 5, screen.y * 0.5 - 5),
            anchor = vector(0.0, 1.0)
        })

        local function on_render()
            local me = entity.get_local_player()

            if me == nil or not me:is_alive() then
                return
            end

            local font = FONTS[text_font]

            if font == nil then
                return
            end

            local is_rect_dragged = window.is_dragged
            local is_rect_drawing = ui.get_alpha() > 0.0

            local target_alpha = is_rect_drawing and (is_rect_dragged and 0.5 or 1.0)
            local rect_alpha = smoothy_drag:update(0.05, target_alpha)

            local pos = window:get_pos()
            local text = tostring(software.rage.selection.min_damage:get())

            local text_flags = "cs"

            local text_size = render.measure_text(font, text_flags, text)
            local rect_size = text_size + vector(PADDING_W, PADDING_H) * 2.0 + vector(1, 0)

            local text_pos = pos + rect_size * 0.5 + vector(1, 0)

            local rect_color = color(200, 200, 200, 128)
            rect_color.a = rect_color.a * rect_alpha

            render.rect_outline(pos, pos + rect_size, rect_color, 1, 4)
            render.text(font, text_pos, text_color, text_flags, text)

            window:set_size(rect_size)
        end

        local function update_event_callbacks(value)
            events.render(on_render, value)
        end

        local namespace = resource.misc.damage_indicator do
            local function on_color(item)
                text_color = item:get()
            end

            local function on_font(item)
                text_font = item:get()
            end

            local function on_enabled(item)
                local value = item:get()

                if value then
                    namespace.color:set_callback(on_color, true)
                    namespace.font:set_callback(on_font, true)
                else
                    namespace.color:unset_callback(on_color)
                    namespace.font:unset_callback(on_font)
                end

                update_event_callbacks(value)
            end

            namespace.enabled:set_callback(on_enabled, true)
        end
    end

    local hit_marker do
        local marker_time = 0.0
        local marker_color = color()

        local function on_render()
            if not globals.is_in_game or marker_time <= 0 then
                return
            end

            local alpha = 1.0

            if marker_time < 0.25 then
                alpha = marker_time / 0.25
            end

            local col = marker_color:clone()
            col.a = col.a * alpha

            local center = render.screen_size() * 0.5

            render.line(vector(center.x - 10, center.y - 10), vector(center.x - 5, center.y - 5), col)
            render.line(vector(center.x + 10, center.y - 10), vector(center.x + 5, center.y - 5), col)
            render.line(vector(center.x + 10, center.y + 10), vector(center.x + 5, center.y + 5), col)
            render.line(vector(center.x - 10, center.y + 10), vector(center.x - 5, center.y + 5), col)

            marker_time = math.max(marker_time - globals.frametime, 0.0)
        end

        local function on_player_hurt(e)
            local me = entity.get_local_player()

            local userid = entity.get(e.userid, true)
            local attacker = entity.get(e.attacker, true)

            if userid == me or attacker ~= me then
                return
            end

            marker_time = 0.5
        end

        local function update_event_callbacks(value)
            if not value then
                marker_time = 0.0
            end

            events.render(on_render, value)
            events.player_hurt(on_player_hurt, value)
        end

        local namespace = resource.misc.hit_marker do
            local function on_color(item)
                marker_color = item:get()
            end

            local function on_enabled(item)
                local value = item:get()

                if value then
                    namespace.color:set_callback(on_color, true)
                else
                    namespace.color:unset_callback(on_color)
                end

                update_event_callbacks(value)
            end

            namespace.enabled:set_callback(on_enabled, true)
        end
    end

    local kibit_marker do
        local draw_list = { }
        local color_list = { }

        local function on_render()
            if not globals.is_in_game then
                return
            end

            local dt = globals.frametime
            local time = globals.realtime

            local color_w = color_list["Horizontal"][1] or color()
            local color_h = color_list["Vertical"][1] or color()

            for i = #draw_list, 1, -1 do
                local data = draw_list[i]

                if time > data.time then
                    table.remove(draw_list, i)
                end
            end

            for i = 1, #draw_list do
                local data = draw_list[i]

                local alpha = 1.0
                local liferemaining = data.time - time

                if liferemaining < 0.5 then
                    alpha = liferemaining / 0.5
                end

                local screen = render.world_to_screen(data.point)

                if screen == nil then
                    goto continue
                end

                local width_0 = vector(screen.x - 4, screen.y - 1)
                local width_1 = vector(screen.x + 4, screen.y + 1)

                local height_0 = vector(screen.x - 1, screen.y - 4)
                local height_1 = vector(screen.x + 1, screen.y + 4)

                render.rect(width_0, width_1, color_w:alpha_modulate(color_w.a * alpha))
                render.rect(height_0, height_1, color_h:alpha_modulate(color_h.a * alpha))

                ::continue::
            end
        end

        local function on_aim_ack(e)
            if e.state ~= nil then
                return
            end

            local time = globals.realtime + 3.0

            table.insert(draw_list, {
                time = time,
                point = e.aim
            })
        end

        local function update_event_callbacks(value)
            if not value then
                for i = 1, #draw_list do
                    draw_list[i] = nil
                end
            end

            events.render(on_render, value)
            events.aim_ack(on_aim_ack, value)
        end

        local namespace = resource.misc.kibit_marker do
            local function on_color(item)
                local list = item:list()

                for i = 1, #list do
                    local key = list[i]
                    local value = item:get(key)

                    color_list[key] = value
                end
            end

            local function on_enabled(item)
                local value = item:get()

                if value then
                    namespace.color:set_callback(on_color, true)
                else
                    namespace.color:unset_callback(on_color)
                end

                update_event_callbacks(value)
            end

            namespace.enabled:set_callback(on_enabled, true)
        end
    end
end

local other do
    local clantag do
        local buffer = {
            "🏆            ",
            "🏆            ",
            "🏆            ",
            "🏆 i          ",
            "🏆 in         ",
            "🏆 inv        ",
            "🏆 invi       ",
            "🏆 invin      ",
            "🏆 invinc     ",
            "🏆 invinci    ",
            "🏆 invincib   ",
            "🏆 invincibl  ",
            "🏆 invincible ",
            "🏆 invincible ",
            "🏆 invincible ",
            "🏆 invincible ",
            "🏆 invincible ",
            "🏆 invincible ",
            "🏆 invincible ",
            "🏆 invincible ",
            "🏆 invincible ",
            "🏆 invincible ",
            "🏆  nvincible ",
            "🏆   vincible ",
            "🏆    incible ",
            "🏆     ncible ",
            "🏆      cible ",
            "🏆       ible ",
            "🏆        ble ",
            "🏆         le ",
            "🏆          e ",
            "🏆            ",
            "🏆            ",
            "🏆            ",
        }

        local set_clantag do
            local prev_tag = nil

            function set_clantag(tag)
                if prev_tag == tag then
                    return
                end

                common.set_clan_tag(tag)
                prev_tag = tag
            end
        end

        local function on_shutdown()
            set_clantag ""
        end

        local function on_net_update()
            local net_channel = utils.net_channel()

            if net_channel == nil then
                return
            end

            local next_tick = to_ticks(net_channel.latency[1])
            local tick = (globals.tickcount + next_tick) / 17

            tick = math.floor(0.5 + tick)

            local index = (tick % #buffer) + 1
            local text = buffer[index]

            if text == nil then
                return
            end

            set_clantag(text)
        end

        local function update_event_callbacks(value)
            if not value then
                on_shutdown()
            end

            events.shutdown(on_shutdown, value)
            events.net_update_start(on_net_update, value)
        end

        local namespace = resource.misc.clantag do
            local function on_enabled(item)
                local value = item:get()

                if not value then
                    software.misc.main.in_game.clan_tag:override()
                else
                    software.misc.main.in_game.clan_tag:override(false)
                end

                update_event_callbacks(value)
            end

            namespace.enabled:set_callback(on_enabled, true)
        end
    end

    local aspect_ratio do
        local r_aspectratio = cvar.r_aspectratio

        local function set_value(value)
            if value == 0 then
                r_aspectratio:float(0, false)
            else
                r_aspectratio:float(value, true)
            end
        end

        local function on_shutdown()
            set_value(0.0)
        end

        local namespace = resource.misc.aspect_ratio do
            local function on_value(item)
                set_value(item:get() * 0.01)
            end

            local function on_enabled(item)
                local value = item:get()

                if value then
                    namespace.value:set_callback(on_value, true)
                else
                    namespace.value:unset_callback(on_value)
                    set_value(0.0)
                end

                events.shutdown(on_shutdown, value)
            end

            namespace.enabled:set_callback(on_enabled, true)
        end
    end

    local viewmodel do
        local WEAPONTYPE_KNIFE = 0

        local cl_righthand = cvar.cl_righthand
        local viewmodel_fov = cvar.viewmodel_fov

        local viewmodel_offset_x = cvar.viewmodel_offset_x
        local viewmodel_offset_y = cvar.viewmodel_offset_y
        local viewmodel_offset_z = cvar.viewmodel_offset_z

        local old_weaponselect = 0

        local function is_knife_equiped()
            local me = entity.get_local_player()

            if me == nil then
                return false
            end

            local weapon = me:get_player_weapon()

            if weapon == nil then
                return false
            end

            local weapon_info = weapon:get_weapon_info()

            if weapon_info == nil then
                return false
            end

            return weapon_info.weapon_type == WEAPONTYPE_KNIFE
        end

        local function get_original(convar)
            return tonumber(convar:string())
        end

        local function update_knife_hand(is_knife)
            local is_right = cl_righthand:string() == "1"

            if is_right then
                cl_righthand:int(is_knife and 0 or 1, true)
            else
                cl_righthand:int(is_knife and 1 or 0, true)
            end
        end

        local function shutdown_viewmodel()
            viewmodel_fov:float(get_original(viewmodel_fov), false)

            viewmodel_offset_x:float(get_original(viewmodel_offset_x), false)
            viewmodel_offset_y:float(get_original(viewmodel_offset_y), false)
            viewmodel_offset_z:float(get_original(viewmodel_offset_z), false)

            cl_righthand:int(cl_righthand:string() == "1" and 1 or 0, false)
        end

        local function on_shutdown()
            shutdown_viewmodel()
        end

        local function on_createmove(cmd)
            if old_weaponselect ~= 0 then
                update_knife_hand(is_knife_equiped())
            end

            old_weaponselect = cmd.weaponselect
        end

        local function update_event_callbacks(value)
            if not value then
                shutdown_viewmodel()
                events.createmove(on_createmove, false)
            end

            events.shutdown(on_shutdown, value)
        end

        local namespace = resource.misc.viewmodel do
            local function on_fov(item)
                viewmodel_fov:float(item:get() * 0.1, true)
            end

            local function on_offset_x(item)
                viewmodel_offset_x:float(item:get() * 0.1, true)
            end

            local function on_offset_y(item)
                viewmodel_offset_y:float(item:get() * 0.1, true)
            end

            local function on_offset_z(item)
                viewmodel_offset_z:float(item:get() * 0.1, true)
            end

            local function on_opposite_knife_hand(item)
                local value = item:get()

                if not value then
                    cl_righthand:int(cl_righthand:string() == "1" and 1 or 0, false)
                else
                    update_knife_hand(is_knife_equiped())
                end

                events.createmove(on_createmove, value)
            end

            local function on_enabled(item)
                local value = item:get()

                if value then
                    namespace.fov:set_callback(on_fov, true)
                    namespace.offset_x:set_callback(on_offset_x, true)
                    namespace.offset_y:set_callback(on_offset_y, true)
                    namespace.offset_z:set_callback(on_offset_z, true)
                    namespace.opposite_knife_hand:set_callback(on_opposite_knife_hand, true)
                else
                    namespace.fov:unset_callback(on_fov)
                    namespace.offset_x:unset_callback(on_offset_x)
                    namespace.offset_y:unset_callback(on_offset_y)
                    namespace.offset_z:unset_callback(on_offset_z)
                    namespace.opposite_knife_hand:unset_callback(on_opposite_knife_hand)
                end

                update_event_callbacks(value)
            end

            namespace.enabled:set_callback(on_enabled, true)
        end
    end
end